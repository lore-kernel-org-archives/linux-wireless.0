Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:33047 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649AbbAFKty (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2015 05:49:54 -0500
Received: by mail-wg0-f45.google.com with SMTP id b13so29070040wgh.4
        for <linux-wireless@vger.kernel.org>; Tue, 06 Jan 2015 02:49:53 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH] iw: don't define iw target in Android build
Date: Tue,  6 Jan 2015 12:41:32 +0200
Message-Id: <1420540892-21478-1-git-send-email-arik@wizery.com> (sfid-20150106_115640_300589_0417E6DA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Otherwise Android gets confused and tries to build the Makefile target

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 Android.mk | 1 +
 Makefile   | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/Android.mk b/Android.mk
index 8afda1d..00c8c49 100644
--- a/Android.mk
+++ b/Android.mk
@@ -3,6 +3,7 @@ IW_SOURCE_DIR := $(LOCAL_PATH)
 
 include $(CLEAR_VARS)
 
+IW_ANDROID_BUILD=y
 NO_PKG_CONFIG=y
 include $(LOCAL_PATH)/Makefile
 
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

