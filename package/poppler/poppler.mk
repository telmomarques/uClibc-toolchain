################################################################################
#
# poppler
#
################################################################################

POPPLER_VERSION = 0.84.0
POPPLER_SOURCE = poppler-$(POPPLER_VERSION).tar.xz
POPPLER_SITE = http://poppler.freedesktop.org
POPPLER_DEPENDENCIES = fontconfig host-pkgconf
POPPLER_LICENSE = GPL-2.0+
POPPLER_LICENSE_FILES = COPYING
POPPLER_INSTALL_STAGING = YES

POPPLER_CONF_OPTS = \
	-DENABLE_UNSTABLE_API_ABI_HEADERS=ON \
	-DBUILD_GTK_TESTS=OFF \
	-DBUILD_QT5_TESTS=OFF \
	-DBUILD_CPP_TESTS=OFF \
	-DENABLE_GOBJECT_INTROSPECTION=OFF \
	-DENABLE_GTK_DOC=OFF

# cmake older than 3.10 requires this to avoid try_run() in FindThreads
POPPLER_CONF_OPTS += -DTHREADS_PTHREAD_ARG=OFF

ifeq ($(BR2_TOOLCHAIN_HAS_LIBATOMIC),y)
POPPLER_CONF_OPTS += -DCMAKE_CXX_FLAGS="$(TARGET_CXXFLAGS) -latomic"
endif

ifeq ($(BR2_PACKAGE_JPEG),y)
POPPLER_DEPENDENCIES += jpeg
POPPLER_CONF_OPTS += -DENABLE_DCTDECODER=libjpeg -DWITH_JPEG=ON
else
POPPLER_CONF_OPTS += -DENABLE_DCTDECODER=none -DWITH_JPEG=OFF
endif

ifeq ($(BR2_PACKAGE_LIBPNG),y)
POPPLER_DEPENDENCIES += libpng
POPPLER_CONF_OPTS += -DWITH_PNG=ON
else
POPPLER_CONF_OPTS += -DWITH_PNG=OFF
endif

ifeq ($(BR2_PACKAGE_LCMS2),y)
POPPLER_DEPENDENCIES += lcms2
POPPLER_CONF_OPTS += -DENABLE_CMS=lcms2
else
POPPLER_CONF_OPTS += -DENABLE_CMS=none
endif

ifeq ($(BR2_PACKAGE_OPENJPEG),y)
POPPLER_DEPENDENCIES += openjpeg
POPPLER_CONF_OPTS += -DENABLE_LIBOPENJPEG=openjpeg2
else
POPPLER_CONF_OPTS += -DENABLE_LIBOPENJPEG=none
endif

ifeq ($(BR2_PACKAGE_LIBCURL),y)
POPPLER_DEPENDENCIES += libcurl
POPPLER_CONF_OPTS += -DENABLE_LIBCURL=ON
else
POPPLER_CONF_OPTS += -DENABLE_LIBCURL=OFF
endif

ifeq ($(BR2_PACKAGE_POPPLER_QT5),y)
POPPLER_DEPENDENCIES += qt5base
POPPLER_CONF_OPTS += -DENABLE_QT5=ON
else
POPPLER_CONF_OPTS += -DENABLE_QT5=OFF
endif

ifeq ($(BR2_PACKAGE_POPPLER_UTILS),y)
POPPLER_CONF_OPTS += -DENABLE_UTILS=ON
else
POPPLER_CONF_OPTS += -DENABLE_UTILS=OFF
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
POPPLER_DEPENDENCIES += zlib
POPPLER_CONF_OPTS += -DENABLE_ZLIB=ON
else
POPPLER_CONF_OPTS += -DENABLE_ZLIB=OFF
endif

ifeq ($(BR2_PACKAGE_CAIRO),y)
POPPLER_DEPENDENCIES += cairo
POPPLER_CONF_OPTS += -DWITH_Cairo=ON
else
POPPLER_CONF_OPTS += -DWITH_Cairo=OFF
endif

ifeq ($(BR2_PACKAGE_TIFF),y)
POPPLER_DEPENDENCIES += tiff
POPPLER_CONF_OPTS += -DWITH_TIFF=ON
else
POPPLER_CONF_OPTS += -DWITH_TIFF=OFF
endif

ifeq ($(BR2_PACKAGE_LIBGLIB2),y)
POPPLER_DEPENDENCIES += libglib2
endif

ifeq ($(BR2_PACKAGE_LIBNSS),y)
POPPLER_DEPENDENCIES += libnss
POPPLER_CONF_OPTS += -DWITH_NSS3=ON
else
POPPLER_CONF_OPTS += -DWITH_NSS3=OFF
endif

ifeq ($(BR2_SOFT_FLOAT),y)
POPPLER_CONF_OPTS += -DUSE_FLOAT=OFF
else
POPPLER_CONF_OPTS += -DUSE_FLOAT=ON
endif

$(eval $(cmake-package))
