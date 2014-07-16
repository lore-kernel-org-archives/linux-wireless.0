Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:37151 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950AbaGPVX3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jul 2014 17:23:29 -0400
Received: by mail-wi0-f172.google.com with SMTP id n3so6969568wiv.5
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jul 2014 14:23:28 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, peter.senna@gmail.com,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 12/21] staging: vt6656: main_usb replace DBG_PRT debug messages
Date: Wed, 16 Jul 2014 22:22:02 +0100
Message-Id: <1405545731-6082-12-git-send-email-tvboxspy@gmail.com> (sfid-20140716_235107_966381_C63F1BD9)
In-Reply-To: <1405545731-6082-1-git-send-email-tvboxspy@gmail.com>
References: <1405545731-6082-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

replace with dev_dbg

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 12f93c7..021e892 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -230,25 +230,24 @@ static int device_init_registers(struct vnt_private *priv)
 	u8 tmp;
 	u8 calib_tx_iq = 0, calib_tx_dc = 0, calib_rx_iq = 0;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "---->INIbInitAdapter. [%d][%d]\n",
+	dev_dbg(&priv->usb->dev, "---->INIbInitAdapter. [%d][%d]\n",
 				DEVICE_INIT_COLD, priv->byPacketType);
 
 	if (!vnt_check_firmware_version(priv)) {
 		if (vnt_download_firmware(priv) == true) {
 			if (vnt_firmware_branch_to_sram(priv) == false) {
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+				dev_dbg(&priv->usb->dev,
 					" vnt_firmware_branch_to_sram fail\n");
 				return false;
 			}
 		} else {
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
-				" FIRMWAREbDownload fail\n");
+			dev_dbg(&priv->usb->dev, "FIRMWAREbDownload fail\n");
 			return false;
 		}
 	}
 
 	if (!vnt_vt3184_init(priv)) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO" vnt_vt3184_init fail\n");
+		dev_dbg(&priv->usb->dev, "vnt_vt3184_init fail\n");
 		return false;
 	}
 
@@ -264,14 +263,14 @@ static int device_init_registers(struct vnt_private *priv)
 		MESSAGE_TYPE_CARDINIT, 0, 0,
 		sizeof(struct vnt_cmd_card_init), (u8 *)init_cmd);
 	if (status != STATUS_SUCCESS) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO" Issue Card init fail\n");
+		dev_dbg(&priv->usb->dev, "Issue Card init fail\n");
 		return false;
 	}
 
 	status = vnt_control_in(priv, MESSAGE_TYPE_INIT_RSP, 0, 0,
 		sizeof(struct vnt_rsp_card_init), (u8 *)init_rsp);
 	if (status != STATUS_SUCCESS) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+		dev_dbg(&priv->usb->dev,
 			"Cardinit request in status fail!\n");
 		return false;
 	}
@@ -429,7 +428,7 @@ static int device_init_registers(struct vnt_private *priv)
 				priv->abyPermanentNetAddr, ETH_ALEN);
 
 	/* if exist SW network address, use it */
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Network address = %pM\n",
+	dev_dbg(&priv->usb->dev, "Network address = %pM\n",
 		priv->abyCurrentNetAddr);
 
 	/*
@@ -478,7 +477,7 @@ static int device_init_registers(struct vnt_private *priv)
 		vnt_radio_power_on(priv);
 	}
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"<----INIbInitAdapter Exit\n");
+	dev_dbg(&priv->usb->dev, "<----INIbInitAdapter Exit\n");
 
 	return true;
 }
-- 
2.0.1

