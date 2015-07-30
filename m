Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:34276 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbbG3VrS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2015 17:47:18 -0400
Received: by pdbbh15 with SMTP id bh15so30540748pdb.1
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2015 14:47:18 -0700 (PDT)
From: Filipe Brandenburger <filbranden@google.com>
To: Johannes Berg <johannes.berg@intel.com>,
	Arik Nemtsov <arik@wizery.com>, Elliott Hughes <enh@google.com>
Cc: linux-wireless@vger.kernel.org,
	Christopher Wiley <wiley@google.com>,
	Filipe Brandenburger <filbranden@google.com>
Subject: [PATCH v2 1/2] iw: fix references to libnl in Android.mk
Date: Thu, 30 Jul 2015 14:47:08 -0700
Message-Id: <1438292828-13583-1-git-send-email-filbranden@google.com> (sfid-20150730_234721_817668_70E60D6D)
In-Reply-To: <CAJgzZoq4iqe_DQVNbDBjJkdpD15LrQY8aApJco5hbr0W-soA6A@mail.gmail.com>
References: <CAJgzZoq4iqe_DQVNbDBjJkdpD15LrQY8aApJco5hbr0W-soA6A@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The latest AOSP refers to that library as libnl and not libnl_2.

TEST=Built AOSP tree with this patchset, tested the generated iw binary.

Signed-off-by: Filipe Brandenburger <filbranden@google.com>
---
v2: Removed now redundant LOCAL_C_INCLUDES as suggested by Elliott.
    Retested to confirm it still builds and works as intended.

 Android.mk | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/Android.mk b/Android.mk
index 735b236809ef..03bcc3e93d4d 100644
--- a/Android.mk
+++ b/Android.mk
@@ -9,15 +9,11 @@ include $(LOCAL_PATH)/Makefile
 
 LOCAL_SRC_FILES := $(patsubst %.o,%.c,$(OBJS)) android-nl.c
 
-LOCAL_C_INCLUDES := \
-	$(LOCAL_PATH) \
-	external/libnl-headers/
-
 LOCAL_CFLAGS += -DCONFIG_LIBNL20
 LOCAL_LDFLAGS := -Wl,--no-gc-sections
 #LOCAL_MODULE_TAGS := optional
 LOCAL_MODULE_TAGS := eng
-LOCAL_STATIC_LIBRARIES := libnl_2
+LOCAL_STATIC_LIBRARIES := libnl
 LOCAL_MODULE := iw
 
 $(IW_SOURCE_DIR)/version.c:
-- 
2.5.0.rc2.392.g76e840b

