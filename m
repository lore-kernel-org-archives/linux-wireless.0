Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:46222 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbbAFKss (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2015 05:48:48 -0500
Received: by mail-wg0-f44.google.com with SMTP id b13so29346570wgh.31
        for <linux-wireless@vger.kernel.org>; Tue, 06 Jan 2015 02:48:47 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v2] iw: fix android build
Date: Tue,  6 Jan 2015 12:48:45 +0200
Message-Id: <1420541325-24052-1-git-send-email-arik@wizery.com> (sfid-20150106_114852_291644_686E598F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don't define "iw" build target in the regular Makefile which gets
included. This confuses the Android build system (coincides with module
name).

Also correct libnl_2 to a be static library, as compiled on Android.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 Android.mk | 3 ++-
 Makefile   | 2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/Android.mk b/Android.mk
index 8afda1d..735b236 100644
--- a/Android.mk
+++ b/Android.mk
@@ -3,6 +3,7 @@ IW_SOURCE_DIR := $(LOCAL_PATH)
 
 include $(CLEAR_VARS)
 
+IW_ANDROID_BUILD=y
 NO_PKG_CONFIG=y
 include $(LOCAL_PATH)/Makefile
 
@@ -16,7 +17,7 @@ LOCAL_CFLAGS += -DCONFIG_LIBNL20
 LOCAL_LDFLAGS := -Wl,--no-gc-sections
 #LOCAL_MODULE_TAGS := optional
 LOCAL_MODULE_TAGS := eng
-LOCAL_SHARED_LIBRARIES := libnl_2
+LOCAL_STATIC_LIBRARIES := libnl_2
 LOCAL_MODULE := iw
 
 $(IW_SOURCE_DIR)/version.c:
diff --git a/Makefile b/Makefile
index 5bf955d..58755dc 100644
--- a/Makefile
+++ b/Makefile
@@ -101,9 +101,11 @@ version.c: version.sh $(patsubst %.o,%.c,$(VERSION_OBJS)) nl80211.h iw.h Makefil
 	@$(NQ) ' CC  ' $@
 	$(Q)$(CC) $(CFLAGS) -c -o $@ $<
 
+ifeq ($(IW_ANDROID_BUILD),)
 iw:	$(OBJS)
 	@$(NQ) ' CC  ' iw
 	$(Q)$(CC) $(LDFLAGS) $(OBJS) $(LIBS) -o iw
+endif
 
 check:
 	$(Q)$(MAKE) all CC="REAL_CC=$(CC) CHECK=\"sparse -Wall\" cgcc"
-- 
2.1.0

