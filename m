Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:39268 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbaFDR0k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 13:26:40 -0400
Received: by mail-wi0-f174.google.com with SMTP id r20so9012797wiv.1
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jun 2014 10:26:39 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 10/15] staging: vt6656: firmware.c replace DBG_PRT debug messages
Date: Wed,  4 Jun 2014 18:25:30 +0100
Message-Id: <1401902735-3882-10-git-send-email-tvboxspy@gmail.com> (sfid-20140604_192645_444103_BACEF390)
In-Reply-To: <1401902735-3882-1-git-send-email-tvboxspy@gmail.com>
References: <1401902735-3882-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace with dev_dbg

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/firmware.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/vt6656/firmware.c b/drivers/staging/vt6656/firmware.c
index a74a42d..83680bc 100644
--- a/drivers/staging/vt6656/firmware.c
+++ b/drivers/staging/vt6656/firmware.c
@@ -35,9 +35,6 @@
 #include "firmware.h"
 #include "usbpipe.h"
 
-static int msglevel = MSG_LEVEL_INFO;
-/* static int msglevel = MSG_LEVEL_DEBUG; */
-
 #define FIRMWARE_VERSION	0x133		/* version 1.51 */
 #define FIRMWARE_NAME		"vntwusb.fw"
 
@@ -53,7 +50,7 @@ int FIRMWAREbDownload(struct vnt_private *priv)
 	u16 length;
 	int ii, rc;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->Download firmware\n");
+	dev_dbg(dev, "---->Download firmware\n");
 
 	rc = request_firmware(&fw, FIRMWARE_NAME, dev);
 	if (rc) {
@@ -77,8 +74,8 @@ int FIRMWAREbDownload(struct vnt_private *priv)
 						length,
 						buffer);
 
-		DBG_PRT(MSG_LEVEL_DEBUG,
-			KERN_INFO"Download firmware...%d %zu\n", ii, fw->size);
+		dev_dbg(dev, "Download firmware...%d %zu\n", ii, fw->size);
+
 		if (status != STATUS_SUCCESS)
 			goto free_fw;
 	}
@@ -98,7 +95,7 @@ int FIRMWAREbBrach2Sram(struct vnt_private *priv)
 {
 	int status;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->Branch to Sram\n");
+	dev_dbg(&priv->usb->dev, "---->Branch to Sram\n");
 
 	status = vnt_control_out(priv,
 					1,
@@ -123,18 +120,21 @@ int FIRMWAREbCheckVersion(struct vnt_private *priv)
 					2,
 					(u8 *) &(priv->wFirmwareVersion));
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Firmware Version [%04x]\n",
+	dev_dbg(&priv->usb->dev, "Firmware Version [%04x]\n",
 						priv->wFirmwareVersion);
+
 	if (status != STATUS_SUCCESS) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Firmware Invalid.\n");
+		dev_dbg(&priv->usb->dev, "Firmware Invalid.\n");
 		return false;
 	}
 	if (priv->wFirmwareVersion == 0xFFFF) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"In Loader.\n");
+		dev_dbg(&priv->usb->dev, "In Loader.\n");
 		return false;
 	}
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Firmware Version [%04x]\n",
+
+	dev_dbg(&priv->usb->dev, "Firmware Version [%04x]\n",
 						priv->wFirmwareVersion);
+
 	if (priv->wFirmwareVersion < FIRMWARE_VERSION) {
 		/* branch to loader for download new firmware */
 		FIRMWAREbBrach2Sram(priv);
-- 
1.9.1

