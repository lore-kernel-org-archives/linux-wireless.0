Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:64573 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbaFDR0g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 13:26:36 -0400
Received: by mail-we0-f174.google.com with SMTP id k48so8862896wev.19
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jun 2014 10:26:35 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 08/15] staging: vt6656: FIRMWAREbBrach2Sram remove camel case
Date: Wed,  4 Jun 2014 18:25:28 +0100
Message-Id: <1401902735-3882-8-git-send-email-tvboxspy@gmail.com> (sfid-20140604_192640_359659_B2140DF2)
In-Reply-To: <1401902735-3882-1-git-send-email-tvboxspy@gmail.com>
References: <1401902735-3882-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

camel case changes
pDevice -> priv
NdisStatus -> status

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/firmware.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6656/firmware.c b/drivers/staging/vt6656/firmware.c
index 9e31e6c..7e66d8b 100644
--- a/drivers/staging/vt6656/firmware.c
+++ b/drivers/staging/vt6656/firmware.c
@@ -94,19 +94,19 @@ out:
 }
 MODULE_FIRMWARE(FIRMWARE_NAME);
 
-int FIRMWAREbBrach2Sram(struct vnt_private *pDevice)
+int FIRMWAREbBrach2Sram(struct vnt_private *priv)
 {
-	int NdisStatus;
+	int status;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->Branch to Sram\n");
 
-	NdisStatus = vnt_control_out(pDevice,
+	status = vnt_control_out(priv,
 					1,
 					0x1200,
 					0x0000,
 					0,
 					NULL);
-	if (NdisStatus != STATUS_SUCCESS)
+	if (status != STATUS_SUCCESS)
 		return false;
 	else
 		return true;
-- 
1.9.1

