Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:61792 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbaKEVJu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2014 16:09:50 -0500
Received: by mail-wi0-f177.google.com with SMTP id ex7so3237190wid.16
        for <linux-wireless@vger.kernel.org>; Wed, 05 Nov 2014 13:09:49 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 09/11] staging: vt6655: device_set_options remove dead variables
Date: Wed,  5 Nov 2014 21:08:57 +0000
Message-Id: <1415221739-3045-9-git-send-email-tvboxspy@gmail.com> (sfid-20141105_220958_239518_0741898F)
In-Reply-To: <1415221739-3045-1-git-send-email-tvboxspy@gmail.com>
References: <1415221739-3045-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

uConnectionRate
wRTSThreshold
byOpMode
b11hEnable
uChannel

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device.h      | 8 --------
 drivers/staging/vt6655/device_main.c | 5 -----
 2 files changed, 13 deletions(-)

diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index 05f2993..74d2afb 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -335,17 +335,14 @@ struct vnt_private {
 
 	unsigned char byMinChannel;
 	unsigned char byMaxChannel;
-	unsigned int	uConnectionRate;
 
 	unsigned char byPreambleType;
 	unsigned char byShortPreamble;
 
 	unsigned short wCurrentRate;
-	unsigned short wRTSThreshold;
 	unsigned char byShortRetryLimit;
 	unsigned char byLongRetryLimit;
 	enum nl80211_iftype op_mode;
-	unsigned char byOpMode;
 	bool bBSSIDFilter;
 	unsigned short wMaxTransmitMSDULifetime;
 
@@ -442,13 +439,8 @@ struct vnt_private {
 
 	unsigned char abyEEPROM[EEP_MAX_CONTEXT_SIZE]; /* unsigned long alignment */
 
-	/* for 802.11h */
-	bool b11hEnable;
-
 	unsigned short wBeaconInterval;
 
-	unsigned int	uChannel;
-
 	struct iw_statistics	wstats;		/* wireless stats */
 };
 
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index a35069b..5fc6022 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -231,16 +231,11 @@ device_set_options(struct vnt_private *pDevice)
 	pDevice->bUpdateBBVGA = true;
 	pDevice->byPreambleType = 0;
 
-	pr_debug(" uChannel= %d\n", (int)pDevice->uChannel);
-	pr_debug(" byOpMode= %d\n", (int)pDevice->byOpMode);
-	pr_debug(" wRTSThreshold= %d\n", (int)pDevice->wRTSThreshold);
 	pr_debug(" byShortRetryLimit= %d\n", (int)pDevice->byShortRetryLimit);
 	pr_debug(" byLongRetryLimit= %d\n", (int)pDevice->byLongRetryLimit);
 	pr_debug(" byPreambleType= %d\n", (int)pDevice->byPreambleType);
 	pr_debug(" byShortPreamble= %d\n", (int)pDevice->byShortPreamble);
-	pr_debug(" uConnectionRate= %d\n", (int)pDevice->uConnectionRate);
 	pr_debug(" byBBType= %d\n", (int)pDevice->byBBType);
-	pr_debug(" pDevice->b11hEnable= %d\n", (int)pDevice->b11hEnable);
 	pr_debug(" pDevice->bDiversityRegCtlON= %d\n",
 		 (int)pDevice->bDiversityRegCtlON);
 }
-- 
2.1.0

