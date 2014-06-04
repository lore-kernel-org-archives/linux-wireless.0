Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:39850 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbaFDR0l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 13:26:41 -0400
Received: by mail-we0-f175.google.com with SMTP id p10so8982085wes.34
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jun 2014 10:26:40 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 11/15] staging: vt6656: rename FIRMWAREbDownload to vnt_download_firmware
Date: Wed,  4 Jun 2014 18:25:31 +0100
Message-Id: <1401902735-3882-11-git-send-email-tvboxspy@gmail.com> (sfid-20140604_194613_449471_93766EC9)
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
index 83680bc..3990698 100644
--- a/drivers/staging/vt6656/firmware.c
+++ b/drivers/staging/vt6656/firmware.c
@@ -40,7 +40,7 @@
 
 #define FIRMWARE_CHUNK_SIZE	0x400
 
-int FIRMWAREbDownload(struct vnt_private *priv)
+int vnt_download_firmware(struct vnt_private *priv)
 {
 	struct device *dev = &priv->usb->dev;
 	const struct firmware *fw;
diff --git a/drivers/staging/vt6656/firmware.h b/drivers/staging/vt6656/firmware.h
index e3b08db..961afb7 100644
--- a/drivers/staging/vt6656/firmware.h
+++ b/drivers/staging/vt6656/firmware.h
@@ -32,7 +32,7 @@
 
 #include "device.h"
 
-int FIRMWAREbDownload(struct vnt_private *);
+int vnt_download_firmware(struct vnt_private *);
 int FIRMWAREbBrach2Sram(struct vnt_private *);
 int FIRMWAREbCheckVersion(struct vnt_private *);
 
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index ebb0955..0c9eb60 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -288,7 +288,7 @@ static int device_init_registers(struct vnt_private *pDevice)
 	memcpy(pDevice->abySNAP_Bridgetunnel, abySNAP_Bridgetunnel, ETH_ALEN);
 
 	if (!FIRMWAREbCheckVersion(pDevice)) {
-		if (FIRMWAREbDownload(pDevice) == true) {
+		if (vnt_download_firmware(pDevice) == true) {
 			if (FIRMWAREbBrach2Sram(pDevice) == false) {
 				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
 					" FIRMWAREbBrach2Sram fail\n");
-- 
1.9.1

