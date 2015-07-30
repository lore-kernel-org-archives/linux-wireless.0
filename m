Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:33293 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbbG3Vfi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2015 17:35:38 -0400
Received: by padck2 with SMTP id ck2so29369099pad.0
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2015 14:35:38 -0700 (PDT)
From: Filipe Brandenburger <filbranden@google.com>
To: Johannes Berg <johannes.berg@intel.com>,
	Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Elliott Hughes <enh@google.com>,
	Christopher Wiley <wiley@google.com>,
	Filipe Brandenburger <filbranden@google.com>
Subject: [PATCH 2/2] iw: remove android-nl.c with unneeded workaround
Date: Thu, 30 Jul 2015 14:35:15 -0700
Message-Id: <1438292115-39495-3-git-send-email-filbranden@google.com> (sfid-20150730_233545_683482_AFE73F07)
In-Reply-To: <1438292115-39495-1-git-send-email-filbranden@google.com>
References: <1438292115-39495-1-git-send-email-filbranden@google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The workaround might have been necessary in the past, however now it
produces the following error:

  .../libnl.a(attr.o): multiple definition of 'nla_put_flag'
  .../android-nl.o: previous definition here
  collect2: error: ld returned 1 exit status

TEST=Built AOSP tree with this patchset, tested the generated iw binary.

Signed-off-by: Filipe Brandenburger <filbranden@google.com>
---
 Android.mk   | 2 +-
 android-nl.c | 6 ------
 2 files changed, 1 insertion(+), 7 deletions(-)
 delete mode 100644 android-nl.c

diff --git a/Android.mk b/Android.mk
index 0820892c6c19..8d6567f624c1 100644
--- a/Android.mk
+++ b/Android.mk
@@ -7,7 +7,7 @@ IW_ANDROID_BUILD=y
 NO_PKG_CONFIG=y
 include $(LOCAL_PATH)/Makefile
 
-LOCAL_SRC_FILES := $(patsubst %.o,%.c,$(OBJS)) android-nl.c
+LOCAL_SRC_FILES := $(patsubst %.o,%.c,$(OBJS))
 
 LOCAL_C_INCLUDES := \
 	$(LOCAL_PATH) \
diff --git a/android-nl.c b/android-nl.c
deleted file mode 100644
index d216f5fe8680..000000000000
--- a/android-nl.c
+++ /dev/null
@@ -1,6 +0,0 @@
-#include <netlink/attr.h>
-
-int nla_put_flag(struct nl_msg *msg, int flag)
-{
-	return nla_put(msg, flag, 0, NULL);
-}
-- 
2.5.0.rc2.392.g76e840b

