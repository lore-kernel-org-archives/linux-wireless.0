Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:33162 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512AbaGSLbA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jul 2014 07:31:00 -0400
Received: by mail-wi0-f173.google.com with SMTP id f8so1996311wiw.0
        for <linux-wireless@vger.kernel.org>; Sat, 19 Jul 2014 04:30:59 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 03/16] staging: vt6656: struct vnt_private rename wFirmwareVersion to firmware_version
Date: Sat, 19 Jul 2014 12:30:05 +0100
Message-Id: <1405769418-2815-3-git-send-email-tvboxspy@gmail.com> (sfid-20140719_133109_067878_81A2DCBD)
In-Reply-To: <1405769418-2815-1-git-send-email-tvboxspy@gmail.com>
References: <1405769418-2815-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing camel case

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h   |  2 +-
 drivers/staging/vt6656/firmware.c | 10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 416a55d..b9f4841 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -299,7 +299,7 @@ struct vnt_private {
 	struct vnt_interrupt_buffer int_buf;
 
 	/* Version control */
-	u16 wFirmwareVersion;
+	u16 firmware_version;
 	u8 byLocalID;
 	u8 byRFType;
 	u8 byBBRxConf;
diff --git a/drivers/staging/vt6656/firmware.c b/drivers/staging/vt6656/firmware.c
index f2250ee..eae4f32d 100644
--- a/drivers/staging/vt6656/firmware.c
+++ b/drivers/staging/vt6656/firmware.c
@@ -118,24 +118,24 @@ int vnt_check_firmware_version(struct vnt_private *priv)
 					0,
 					MESSAGE_REQUEST_VERSION,
 					2,
-					(u8 *) &(priv->wFirmwareVersion));
+					(u8 *)&priv->firmware_version);
 
 	dev_dbg(&priv->usb->dev, "Firmware Version [%04x]\n",
-						priv->wFirmwareVersion);
+						priv->firmware_version);
 
 	if (status != STATUS_SUCCESS) {
 		dev_dbg(&priv->usb->dev, "Firmware Invalid.\n");
 		return false;
 	}
-	if (priv->wFirmwareVersion == 0xFFFF) {
+	if (priv->firmware_version == 0xFFFF) {
 		dev_dbg(&priv->usb->dev, "In Loader.\n");
 		return false;
 	}
 
 	dev_dbg(&priv->usb->dev, "Firmware Version [%04x]\n",
-						priv->wFirmwareVersion);
+						priv->firmware_version);
 
-	if (priv->wFirmwareVersion < FIRMWARE_VERSION) {
+	if (priv->firmware_version < FIRMWARE_VERSION) {
 		/* branch to loader for download new firmware */
 		vnt_firmware_branch_to_sram(priv);
 		return false;
-- 
2.0.1

