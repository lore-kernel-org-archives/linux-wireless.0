Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:58018 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932317AbaFYUV7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 16:21:59 -0400
Received: by mail-wg0-f45.google.com with SMTP id l18so2551362wgh.28
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2014 13:21:58 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 32/34] staging: vt6656: dead code remove variables device_set_options
Date: Wed, 25 Jun 2014 21:20:09 +0100
Message-Id: <1403727611-6825-33-git-send-email-tvboxspy@gmail.com> (sfid-20140625_223010_354973_37876162)
In-Reply-To: <1403727611-6825-1-git-send-email-tvboxspy@gmail.com>
References: <1403727611-6825-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c | 23 -----------------------
 1 file changed, 23 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 6479ced..b49effa 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -206,27 +206,12 @@ static void usb_device_reset(struct vnt_private *pDevice);
 
 static void
 device_set_options(struct vnt_private *pDevice) {
-
-    u8    abyBroadcastAddr[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
-    u8    abySNAP_RFC1042[ETH_ALEN] = {0xAA, 0xAA, 0x03, 0x00, 0x00, 0x00};
-    u8 abySNAP_Bridgetunnel[ETH_ALEN] = {0xAA, 0xAA, 0x03, 0x00, 0x00, 0xF8};
-
-    memcpy(pDevice->abyBroadcastAddr, abyBroadcastAddr, ETH_ALEN);
-    memcpy(pDevice->abySNAP_RFC1042, abySNAP_RFC1042, ETH_ALEN);
-    memcpy(pDevice->abySNAP_Bridgetunnel, abySNAP_Bridgetunnel, ETH_ALEN);
-
     pDevice->cbTD = TX_DESC_DEF0;
     pDevice->cbRD = RX_DESC_DEF0;
     pDevice->uChannel = CHANNEL_DEF;
-    pDevice->wRTSThreshold = RTS_THRESH_DEF;
-    pDevice->wFragmentationThreshold = FRAG_THRESH_DEF;
     pDevice->byShortRetryLimit = SHORT_RETRY_DEF;
     pDevice->byLongRetryLimit = LONG_RETRY_DEF;
-    pDevice->byShortPreamble = PREAMBLE_TYPE_DEF;
-    pDevice->b11hEnable = X80211h_MODE_DEF;
     pDevice->op_mode = NL80211_IFTYPE_UNSPECIFIED;
-    pDevice->uConnectionRate = DATA_RATE_DEF;
-    if (pDevice->uConnectionRate < RATE_AUTO) pDevice->bFixRate = true;
     pDevice->byBBType = BBP_TYPE_DEF;
     pDevice->byPacketType = pDevice->byBBType;
     pDevice->byAutoFBCtrl = AUTO_FB_0;
@@ -306,14 +291,6 @@ static int device_init_registers(struct vnt_private *pDevice)
 	/* only used in 11g type, sync with ERP IE */
 	pDevice->bNonERPPresent = false;
 	pDevice->bBarkerPreambleMd = false;
-	if (pDevice->bFixRate) {
-		pDevice->wCurrentRate = (u16)pDevice->uConnectionRate;
-	} else {
-		if (pDevice->byBBType == BB_TYPE_11B)
-			pDevice->wCurrentRate = RATE_11M;
-		else
-			pDevice->wCurrentRate = RATE_54M;
-	}
 
 	pDevice->byTopOFDMBasicRate = RATE_24M;
 	pDevice->byTopCCKBasicRate = RATE_1M;
-- 
1.9.1

