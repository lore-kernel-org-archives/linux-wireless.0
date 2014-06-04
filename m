Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:33451 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbaFDR0q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 13:26:46 -0400
Received: by mail-wi0-f172.google.com with SMTP id hi2so8818819wib.11
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jun 2014 10:26:44 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 13/15] staging: vt6656: rename FIRMWAREbCheckVersion to vnt_check_firmware_version
Date: Wed,  4 Jun 2014 18:25:33 +0100
Message-Id: <1401902735-3882-13-git-send-email-tvboxspy@gmail.com> (sfid-20140604_194614_240285_625C387B)
In-Reply-To: <1401902735-3882-1-git-send-email-tvboxspy@gmail.com>
References: <1401902735-3882-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/firmware.c | 2 +-
 drivers/staging/vt6656/firmware.h | 2 +-
 drivers/staging/vt6656/main_usb.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6656/firmware.c b/drivers/staging/vt6656/firmware.c
index 78e9283..f2250ee 100644
--- a/drivers/staging/vt6656/firmware.c
+++ b/drivers/staging/vt6656/firmware.c
@@ -109,7 +109,7 @@ int vnt_firmware_branch_to_sram(struct vnt_private *priv)
 		return true;
 }
 
-int FIRMWAREbCheckVersion(struct vnt_private *priv)
+int vnt_check_firmware_version(struct vnt_private *priv)
 {
 	int status;
 
diff --git a/drivers/staging/vt6656/firmware.h b/drivers/staging/vt6656/firmware.h
index eb25932..d594dbe 100644
--- a/drivers/staging/vt6656/firmware.h
+++ b/drivers/staging/vt6656/firmware.h
@@ -34,6 +34,6 @@
 
 int vnt_download_firmware(struct vnt_private *);
 int vnt_firmware_branch_to_sram(struct vnt_private *);
-int FIRMWAREbCheckVersion(struct vnt_private *);
+int vnt_check_firmware_version(struct vnt_private *);
 
 #endif /* __FIRMWARE_H__ */
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index c5adc34..4662a3e 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -287,7 +287,7 @@ static int device_init_registers(struct vnt_private *pDevice)
 	memcpy(pDevice->abySNAP_RFC1042, abySNAP_RFC1042, ETH_ALEN);
 	memcpy(pDevice->abySNAP_Bridgetunnel, abySNAP_Bridgetunnel, ETH_ALEN);
 
-	if (!FIRMWAREbCheckVersion(pDevice)) {
+	if (!vnt_check_firmware_version(pDevice)) {
 		if (vnt_download_firmware(pDevice) == true) {
 			if (vnt_firmware_branch_to_sram(pDevice) == false) {
 				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
-- 
1.9.1

