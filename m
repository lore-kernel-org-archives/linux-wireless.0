Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:32780 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbcD1NhT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2016 09:37:19 -0400
Received: by mail-pa0-f49.google.com with SMTP id zm5so35885287pac.0
        for <linux-wireless@vger.kernel.org>; Thu, 28 Apr 2016 06:37:18 -0700 (PDT)
From: Yongqin Liu <yongqin.liu@linaro.org>
To: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Filipe Brandenburger <filbranden@google.com>
Cc: Yongqin Liu <yongqin.liu@linaro.org>
Subject: [PATCH 1/1] iw: Android.mk & version.sh: update for Android based compilation
Date: Thu, 28 Apr 2016 21:36:59 +0800
Message-Id: <1461850619-15298-1-git-send-email-yongqin.liu@linaro.org> (sfid-20160428_153725_499910_13CE9B8C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

update the Android.mk file and version.sh script for
Android based compilation

Android.mk:  the same file as the one in AOSP master tip
version.sh:  update to get the version information from the
   git repository where this file is located instead of the
   the current directory where it is executed, otherwise if
   there is .git directory in the current directory, it will
   get the wrong version information.
   And improved the version check since the tag information
   may not be mirrored like what AOSP does now.

Change-Id: I8fa59f0e5c7ebd61b364c77fdccf8e74da2e565c
Signed-off-by: Yongqin Liu <yongqin.liu@linaro.org>
---
 Android.mk | 30 ++++++++++++++++++++----------
 version.sh | 39 +++++++++++++++++++++++++++------------
 2 files changed, 47 insertions(+), 22 deletions(-)

diff --git a/Android.mk b/Android.mk
index 4a50f89..20b0432 100644
--- a/Android.mk
+++ b/Android.mk
@@ -1,22 +1,32 @@
 LOCAL_PATH := $(call my-dir)
-IW_SOURCE_DIR := $(LOCAL_PATH)
 
 include $(CLEAR_VARS)
 
-IW_ANDROID_BUILD=y
-NO_PKG_CONFIG=y
-include $(LOCAL_PATH)/Makefile
-
-LOCAL_SRC_FILES := $(patsubst %.o,%.c,$(OBJS))
+LOCAL_SRC_FILES := \
+  iw.c genl.c event.c info.c phy.c \
+  interface.c ibss.c station.c survey.c util.c ocb.c \
+  mesh.c mpath.c mpp.c scan.c reg.c \
+  reason.c status.c connect.c link.c offch.c ps.c cqm.c \
+  bitrate.c wowlan.c coalesce.c roc.c p2p.c vendor.c \
+  sections.c
 
 LOCAL_CFLAGS += -DCONFIG_LIBNL20
+
+# Silence some warnings for now. Needs to be fixed upstream. b/26105799
+LOCAL_CFLAGS += -Wno-unused-parameter \
+                -Wno-sign-compare \
+                -Wno-format
+LOCAL_CLANG_CFLAGS += -Wno-enum-conversion
+
 LOCAL_LDFLAGS := -Wl,--no-gc-sections
-#LOCAL_MODULE_TAGS := optional
-LOCAL_MODULE_TAGS := eng
+LOCAL_MODULE_TAGS := debug
 LOCAL_STATIC_LIBRARIES := libnl
 LOCAL_MODULE := iw
 
-$(IW_SOURCE_DIR)/version.c:
-	$(IW_SOURCE_DIR)/version.sh $(IW_SOURCE_DIR)/version.c
+LOCAL_MODULE_CLASS := EXECUTABLES
+LOCAL_GENERATED_SOURCES := $(local-generated-sources-dir)/version.c
+$(LOCAL_GENERATED_SOURCES) : $(LOCAL_PATH)/version.sh
+	@mkdir -p $(dir $@)
+	$(hide) $< $@
 
 include $(BUILD_EXECUTABLE)
diff --git a/version.sh b/version.sh
index 7ccd419..7f292f3 100755
--- a/version.sh
+++ b/version.sh
@@ -3,20 +3,35 @@
 VERSION="4.3"
 OUT="$1"
 
-if [ -d .git ] && head=`git rev-parse --verify HEAD 2>/dev/null`; then
-	git update-index --refresh --unmerged > /dev/null
-	descr=$(git describe --match=v*)
+# get the absolute path for the OUT file
+OUT_NAME=$(basename ${OUT})
+OUT_DIR=$(cd $(dirname ${OUT}); pwd)
+OUT="${OUT_DIR}/${OUT_NAME}"
 
-	# on git builds check that the version number above
-	# is correct...
-	[ "${descr%%-*}" = "v$VERSION" ] || exit 2
+# the version check should be under the source directory
+# where this script is located, instead of the currect directory
+# where this script is excuted.
+SRC_DIR=$(dirname $0)
+SRC_DIR=$(cd ${SRC_DIR}; pwd)
+cd "${SRC_DIR}"
 
-	v="${descr#v}"
-	if git diff-index --name-only HEAD | read dummy ; then
-		v="$v"-dirty
-	fi
-else
-	v="$VERSION"
+v=""
+if [ -d .git ] && head=`git rev-parse --verify HEAD 2>/dev/null`; then
+    git update-index --refresh --unmerged > /dev/null
+    descr=$(git describe --match=v* 2>/dev/null)
+    if [ $? -eq 0 ]; then
+        # on git builds check that the version number above
+        # is correct...
+        if [ "${descr%%-*}" = "v$VERSION" ]; then
+            v="${descr#v}"
+            if git diff-index --name-only HEAD | read dummy ; then
+                v="$v"-dirty
+            fi
+        fi
+    fi
+fi
+if [ -z "${v}" ]; then
+    v="$VERSION"
 fi
 
 echo '#include "iw.h"' > "$OUT"
-- 
2.1.4

