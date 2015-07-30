Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:33271 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbbG3Vff (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2015 17:35:35 -0400
Received: by padck2 with SMTP id ck2so29368588pad.0
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2015 14:35:35 -0700 (PDT)
From: Filipe Brandenburger <filbranden@google.com>
To: Johannes Berg <johannes.berg@intel.com>,
	Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Elliott Hughes <enh@google.com>,
	Christopher Wiley <wiley@google.com>,
	Filipe Brandenburger <filbranden@google.com>
Subject: [PATCH 1/2] iw: fix references to libnl in Android.mk
Date: Thu, 30 Jul 2015 14:35:14 -0700
Message-Id: <1438292115-39495-2-git-send-email-filbranden@google.com> (sfid-20150730_233545_127471_5C56C461)
In-Reply-To: <1438292115-39495-1-git-send-email-filbranden@google.com>
References: <1438292115-39495-1-git-send-email-filbranden@google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The latest AOSP refers to that library as libnl and not libnl_2.

TEST=Built AOSP tree with this patchset, tested the generated iw binary.

Signed-off-by: Filipe Brandenburger <filbranden@google.com>
---
 Android.mk | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Android.mk b/Android.mk
index 735b236809ef..0820892c6c19 100644
--- a/Android.mk
+++ b/Android.mk
@@ -11,13 +11,13 @@ LOCAL_SRC_FILES := $(patsubst %.o,%.c,$(OBJS)) android-nl.c
 
 LOCAL_C_INCLUDES := \
 	$(LOCAL_PATH) \
-	external/libnl-headers/
+	external/libnl/include
 
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

