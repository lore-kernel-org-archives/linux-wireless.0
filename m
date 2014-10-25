Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:53127 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbaJYUE1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2014 16:04:27 -0400
Received: by mail-wg0-f42.google.com with SMTP id k14so1200406wgh.25
        for <linux-wireless@vger.kernel.org>; Sat, 25 Oct 2014 13:04:26 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 46/48] staging: vt6655: move MAKE_BEACON_RESERVED to device.h
Date: Sat, 25 Oct 2014 09:40:24 +0100
Message-Id: <1414226426-5811-47-git-send-email-tvboxspy@gmail.com> (sfid-20141025_220430_553891_4969120E)
In-Reply-To: <1414226426-5811-1-git-send-email-tvboxspy@gmail.com>
References: <1414226426-5811-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Used only in function device_intr in device_main.c move macro.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device.h | 2 ++
 drivers/staging/vt6655/wmgr.h   | 2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index 42099b3..2aa42b5 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -141,6 +141,8 @@
 #define RUN_AT(x)                       (jiffies+(x))
 #endif
 
+#define MAKE_BEACON_RESERVED	10  /* (us) */
+
 // DMA related
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
1.9.1

