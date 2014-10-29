Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:39224 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932332AbaJ2R60 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 13:58:26 -0400
Received: by mail-wi0-f176.google.com with SMTP id h11so2426719wiw.3
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 10:58:25 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH v2 46/48] staging: vt6655: move MAKE_BEACON_RESERVED to device.h
Date: Wed, 29 Oct 2014 17:56:04 +0000
Message-Id: <1414605366-9335-47-git-send-email-tvboxspy@gmail.com> (sfid-20141029_185854_442622_196CB768)
In-Reply-To: <1414605366-9335-1-git-send-email-tvboxspy@gmail.com>
References: <1414605366-9335-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Used only in function device_intr in device_main.c move macro.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device.h | 2 ++
 drivers/staging/vt6655/wmgr.h   | 2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index e0c4069..45181a8 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -137,6 +137,8 @@
 #define RUN_AT(x)                       (jiffies+(x))
 #endif
 
+#define MAKE_BEACON_RESERVED	10  /* (us) */
+
 /* DMA related */
 #define RESERV_AC0DMA                   4
 
diff --git a/drivers/staging/vt6655/wmgr.h b/drivers/staging/vt6655/wmgr.h
index daf996c..ea23c79 100644
--- a/drivers/staging/vt6655/wmgr.h
+++ b/drivers/staging/vt6655/wmgr.h
@@ -54,8 +54,6 @@
 
 #define DEFAULT_MGN_LIFETIME            8    // ms
 
-#define MAKE_BEACON_RESERVED            10  //(us)
-
 #define TIM_MULTICAST_MASK           0x01
 #define TIM_BITMAPOFFSET_MASK        0xFE
 #define DEFAULT_DTIM_PERIOD             1
-- 
2.1.0

