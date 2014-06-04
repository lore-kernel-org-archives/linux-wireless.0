Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:57418 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbaFDR0i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 13:26:38 -0400
Received: by mail-we0-f177.google.com with SMTP id x48so8602525wes.8
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jun 2014 10:26:37 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 09/15] staging: vt6656: FIRMWAREbCheckVersion remove camel case
Date: Wed,  4 Jun 2014 18:25:29 +0100
Message-Id: <1401902735-3882-9-git-send-email-tvboxspy@gmail.com> (sfid-20140604_192642_649463_DD7038A9)
In-Reply-To: <1401902735-3882-1-git-send-email-tvboxspy@gmail.com>
References: <1401902735-3882-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

camel case changes
pDevice -> priv
ntStatus -> status

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/firmware.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/vt6656/firmware.c b/drivers/staging/vt6656/firmware.c
index 7e66d8b..a74a42d 100644
--- a/drivers/staging/vt6656/firmware.c
+++ b/drivers/staging/vt6656/firmware.c
@@ -112,32 +112,32 @@ int FIRMWAREbBrach2Sram(struct vnt_private *priv)
 		return true;
 }
 
-int FIRMWAREbCheckVersion(struct vnt_private *pDevice)
+int FIRMWAREbCheckVersion(struct vnt_private *priv)
 {
-	int ntStatus;
+	int status;
 
-	ntStatus = vnt_control_in(pDevice,
+	status = vnt_control_in(priv,
 					MESSAGE_TYPE_READ,
 					0,
 					MESSAGE_REQUEST_VERSION,
 					2,
-					(u8 *) &(pDevice->wFirmwareVersion));
+					(u8 *) &(priv->wFirmwareVersion));
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Firmware Version [%04x]\n",
-						pDevice->wFirmwareVersion);
-	if (ntStatus != STATUS_SUCCESS) {
+						priv->wFirmwareVersion);
+	if (status != STATUS_SUCCESS) {
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Firmware Invalid.\n");
 		return false;
 	}
-	if (pDevice->wFirmwareVersion == 0xFFFF) {
+	if (priv->wFirmwareVersion == 0xFFFF) {
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"In Loader.\n");
 		return false;
 	}
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Firmware Version [%04x]\n",
-						pDevice->wFirmwareVersion);
-	if (pDevice->wFirmwareVersion < FIRMWARE_VERSION) {
+						priv->wFirmwareVersion);
+	if (priv->wFirmwareVersion < FIRMWARE_VERSION) {
 		/* branch to loader for download new firmware */
-		FIRMWAREbBrach2Sram(pDevice);
+		FIRMWAREbBrach2Sram(priv);
 		return false;
 	}
 	return true;
-- 
1.9.1

