Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:34250 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbaFDR0f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 13:26:35 -0400
Received: by mail-we0-f176.google.com with SMTP id q59so8665453wes.21
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jun 2014 10:26:34 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 07/15] staging: vt6656: FIRMWAREbDownload remove camel case
Date: Wed,  4 Jun 2014 18:25:27 +0100
Message-Id: <1401902735-3882-7-git-send-email-tvboxspy@gmail.com> (sfid-20140604_192638_481249_82C9421E)
In-Reply-To: <1401902735-3882-1-git-send-email-tvboxspy@gmail.com>
References: <1401902735-3882-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

camel case changes
pDevice -> priv
NdisStatus -> status
pBuffer -> buffer
wLength -> length

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/firmware.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/vt6656/firmware.c b/drivers/staging/vt6656/firmware.c
index 1159f0b..9e31e6c 100644
--- a/drivers/staging/vt6656/firmware.c
+++ b/drivers/staging/vt6656/firmware.c
@@ -43,14 +43,14 @@ static int msglevel = MSG_LEVEL_INFO;
 
 #define FIRMWARE_CHUNK_SIZE	0x400
 
-int FIRMWAREbDownload(struct vnt_private *pDevice)
+int FIRMWAREbDownload(struct vnt_private *priv)
 {
-	struct device *dev = &pDevice->usb->dev;
+	struct device *dev = &priv->usb->dev;
 	const struct firmware *fw;
-	int NdisStatus;
-	void *pBuffer = NULL;
+	int status;
+	void *buffer = NULL;
 	bool result = false;
-	u16 wLength;
+	u16 length;
 	int ii, rc;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->Download firmware\n");
@@ -62,24 +62,24 @@ int FIRMWAREbDownload(struct vnt_private *pDevice)
 			goto out;
 	}
 
-	pBuffer = kmalloc(FIRMWARE_CHUNK_SIZE, GFP_KERNEL);
-	if (!pBuffer)
+	buffer = kmalloc(FIRMWARE_CHUNK_SIZE, GFP_KERNEL);
+	if (!buffer)
 		goto out;
 
 	for (ii = 0; ii < fw->size; ii += FIRMWARE_CHUNK_SIZE) {
-		wLength = min_t(int, fw->size - ii, FIRMWARE_CHUNK_SIZE);
-		memcpy(pBuffer, fw->data + ii, wLength);
+		length = min_t(int, fw->size - ii, FIRMWARE_CHUNK_SIZE);
+		memcpy(buffer, fw->data + ii, length);
 
-		NdisStatus = vnt_control_out(pDevice,
+		status = vnt_control_out(priv,
 						0,
 						0x1200+ii,
 						0x0000,
-						wLength,
-						pBuffer);
+						length,
+						buffer);
 
 		DBG_PRT(MSG_LEVEL_DEBUG,
 			KERN_INFO"Download firmware...%d %zu\n", ii, fw->size);
-		if (NdisStatus != STATUS_SUCCESS)
+		if (status != STATUS_SUCCESS)
 			goto free_fw;
 	}
 
@@ -88,7 +88,7 @@ free_fw:
 	release_firmware(fw);
 
 out:
-	kfree(pBuffer);
+	kfree(buffer);
 
 	return result;
 }
-- 
1.9.1

