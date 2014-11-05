Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:63265 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbaKEVJp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2014 16:09:45 -0500
Received: by mail-wi0-f179.google.com with SMTP id h11so3261303wiw.6
        for <linux-wireless@vger.kernel.org>; Wed, 05 Nov 2014 13:09:44 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 06/11] staging: vt6655: device_set_options remove unused ethernet addresses
Date: Wed,  5 Nov 2014 21:08:54 +0000
Message-Id: <1415221739-3045-6-git-send-email-tvboxspy@gmail.com> (sfid-20141105_220949_476594_59D75BDD)
In-Reply-To: <1415221739-3045-1-git-send-email-tvboxspy@gmail.com>
References: <1415221739-3045-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing these variables
abyBroadcastAddr
abySNAP_RFC1042
abySNAP_Bridgetunnel

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device.h      | 3 ---
 drivers/staging/vt6655/device_main.c | 8 --------
 2 files changed, 11 deletions(-)

diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index 2f522977..05f2993 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -440,9 +440,6 @@ struct vnt_private {
 	unsigned long uNumSQ3[MAX_RATE];
 	unsigned short wAntDiversityMaxRate;
 
-	unsigned char abyBroadcastAddr[ETH_ALEN];
-	unsigned char abySNAP_RFC1042[ETH_ALEN];
-	unsigned char abySNAP_Bridgetunnel[ETH_ALEN];
 	unsigned char abyEEPROM[EEP_MAX_CONTEXT_SIZE]; /* unsigned long alignment */
 
 	/* for 802.11h */
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 37bbcf8..ee60624 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -222,14 +222,6 @@ static void device_get_options(struct vnt_private *pDevice)
 static void
 device_set_options(struct vnt_private *pDevice)
 {
-	unsigned char abyBroadcastAddr[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
-	unsigned char abySNAP_RFC1042[ETH_ALEN] = {0xAA, 0xAA, 0x03, 0x00, 0x00, 0x00};
-	unsigned char abySNAP_Bridgetunnel[ETH_ALEN] = {0xAA, 0xAA, 0x03, 0x00, 0x00, 0xF8};
-
-	ether_addr_copy(pDevice->abyBroadcastAddr, abyBroadcastAddr);
-	ether_addr_copy(pDevice->abySNAP_RFC1042, abySNAP_RFC1042);
-	ether_addr_copy(pDevice->abySNAP_Bridgetunnel, abySNAP_Bridgetunnel);
-
 	pDevice->byShortRetryLimit = pDevice->sOpts.short_retry;
 	pDevice->byLongRetryLimit = pDevice->sOpts.long_retry;
 	pDevice->bDiversityRegCtlON = (pDevice->sOpts.flags & DEVICE_FLAGS_DiversityANT) ? 1 : 0;
-- 
2.1.0

