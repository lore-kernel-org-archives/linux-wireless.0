Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:57544 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932342AbaFYUV6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 16:21:58 -0400
Received: by mail-wi0-f176.google.com with SMTP id n3so8750050wiv.15
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2014 13:21:57 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 31/34] staging: vt6656: device_init_registers remove unused variables
Date: Wed, 25 Jun 2014 21:20:08 +0100
Message-Id: <1403727611-6825-32-git-send-email-tvboxspy@gmail.com> (sfid-20140625_223022_659393_62FE5282)
In-Reply-To: <1403727611-6825-1-git-send-email-tvboxspy@gmail.com>
References: <1403727611-6825-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 5ce0caa..6479ced 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -241,10 +241,6 @@ static int device_init_registers(struct vnt_private *pDevice)
 {
 	struct vnt_cmd_card_init *init_cmd = &pDevice->init_command;
 	struct vnt_rsp_card_init *init_rsp = &pDevice->init_response;
-	u8 abyBroadcastAddr[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
-	u8 abySNAP_RFC1042[ETH_ALEN] = {0xaa, 0xaa, 0x03, 0x00, 0x00, 0x00};
-	u8 abySNAP_Bridgetunnel[ETH_ALEN]
-		= {0xaa, 0xaa, 0x03, 0x00, 0x00, 0xf8};
 	u8 byAntenna;
 	int ii;
 	int ntStatus = STATUS_SUCCESS;
@@ -254,10 +250,6 @@ static int device_init_registers(struct vnt_private *pDevice)
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "---->INIbInitAdapter. [%d][%d]\n",
 				DEVICE_INIT_COLD, pDevice->byPacketType);
 
-	memcpy(pDevice->abyBroadcastAddr, abyBroadcastAddr, ETH_ALEN);
-	memcpy(pDevice->abySNAP_RFC1042, abySNAP_RFC1042, ETH_ALEN);
-	memcpy(pDevice->abySNAP_Bridgetunnel, abySNAP_Bridgetunnel, ETH_ALEN);
-
 	if (!vnt_check_firmware_version(pDevice)) {
 		if (vnt_download_firmware(pDevice) == true) {
 			if (vnt_firmware_branch_to_sram(pDevice) == false) {
@@ -412,14 +404,8 @@ static int device_init_registers(struct vnt_private *pDevice)
 	pDevice->byAutoFBCtrl = AUTO_FB_0;
 
 	/* default Auto Mode */
-	/* pDevice->NetworkType = Ndis802_11Automode; */
-	pDevice->eConfigPHYMode = PHY_TYPE_AUTO;
 	pDevice->byBBType = BB_TYPE_11G;
 
-	/* get channel range */
-	pDevice->byMinChannel = 1;
-	pDevice->byMaxChannel = CB_MAX_CHANNEL;
-
 	/* get RFType */
 	pDevice->byRFType = init_rsp->rf_type;
 
-- 
1.9.1

