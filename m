Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:39895 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbaFDR0n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 13:26:43 -0400
Received: by mail-we0-f172.google.com with SMTP id k48so9022260wev.31
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jun 2014 10:26:42 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 12/15] staging: vt6656: rename FIRMWAREbBrach2Sram to vnt_firmware_branch_to_sram
Date: Wed,  4 Jun 2014 18:25:32 +0100
Message-Id: <1401902735-3882-12-git-send-email-tvboxspy@gmail.com> (sfid-20140604_194614_111246_67CD9389)
In-Reply-To: <1401902735-3882-1-git-send-email-tvboxspy@gmail.com>
References: <1401902735-3882-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/firmware.c | 4 ++--
 drivers/staging/vt6656/firmware.h | 2 +-
 drivers/staging/vt6656/main_usb.c | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vt6656/firmware.c b/drivers/staging/vt6656/firmware.c
index 3990698..78e9283 100644
--- a/drivers/staging/vt6656/firmware.c
+++ b/drivers/staging/vt6656/firmware.c
@@ -91,7 +91,7 @@ out:
 }
 MODULE_FIRMWARE(FIRMWARE_NAME);
 
-int FIRMWAREbBrach2Sram(struct vnt_private *priv)
+int vnt_firmware_branch_to_sram(struct vnt_private *priv)
 {
 	int status;
 
@@ -137,7 +137,7 @@ int FIRMWAREbCheckVersion(struct vnt_private *priv)
 
 	if (priv->wFirmwareVersion < FIRMWARE_VERSION) {
 		/* branch to loader for download new firmware */
-		FIRMWAREbBrach2Sram(priv);
+		vnt_firmware_branch_to_sram(priv);
 		return false;
 	}
 	return true;
diff --git a/drivers/staging/vt6656/firmware.h b/drivers/staging/vt6656/firmware.h
index 961afb7..eb25932 100644
--- a/drivers/staging/vt6656/firmware.h
+++ b/drivers/staging/vt6656/firmware.h
@@ -33,7 +33,7 @@
 #include "device.h"
 
 int vnt_download_firmware(struct vnt_private *);
-int FIRMWAREbBrach2Sram(struct vnt_private *);
+int vnt_firmware_branch_to_sram(struct vnt_private *);
 int FIRMWAREbCheckVersion(struct vnt_private *);
 
 #endif /* __FIRMWARE_H__ */
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 0c9eb60..c5adc34 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -289,9 +289,9 @@ static int device_init_registers(struct vnt_private *pDevice)
 
 	if (!FIRMWAREbCheckVersion(pDevice)) {
 		if (vnt_download_firmware(pDevice) == true) {
-			if (FIRMWAREbBrach2Sram(pDevice) == false) {
+			if (vnt_firmware_branch_to_sram(pDevice) == false) {
 				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
-					" FIRMWAREbBrach2Sram fail\n");
+					" vnt_firmware_branch_to_sram fail\n");
 				return false;
 			}
 		} else {
-- 
1.9.1

