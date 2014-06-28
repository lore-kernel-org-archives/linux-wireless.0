Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:62640 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbaF1W4f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jun 2014 18:56:35 -0400
Received: by mail-wi0-f180.google.com with SMTP id hi2so4357007wib.13
        for <linux-wireless@vger.kernel.org>; Sat, 28 Jun 2014 15:56:34 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 7/8] staging: vt6656: set BBvSetVGAGainOffset inside vnt_set_bss_mode
Date: Sat, 28 Jun 2014 23:55:45 +0100
Message-Id: <1403996146-4082-7-git-send-email-tvboxspy@gmail.com> (sfid-20140629_005640_332873_5ACAB63B)
In-Reply-To: <1403996146-4082-1-git-send-email-tvboxspy@gmail.com>
References: <1403996146-4082-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

vnt_set_bss_mode changes the state of abyBBVGA so move
BBvSetVGAGainOffset to the function.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c     | 2 ++
 drivers/staging/vt6656/main_usb.c | 5 -----
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 82d6b64..1849e34 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -825,4 +825,6 @@ void vnt_set_bss_mode(struct vnt_private *priv)
 		priv->abyBBVGA[2] = 0x0;
 		priv->abyBBVGA[3] = 0x0;
 	}
+
+	BBvSetVGAGainOffset(priv, priv->abyBBVGA[0]);
 }
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index d8164ec..e0ed1bb 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -440,11 +440,6 @@ static int device_init_registers(struct vnt_private *pDevice)
 	BBvSetShortSlotTime(pDevice);
 	vnt_set_bss_mode(pDevice);
 
-	pDevice->byBBVGACurrent = pDevice->abyBBVGA[0];
-	pDevice->byBBVGANew = pDevice->byBBVGACurrent;
-
-	BBvSetVGAGainOffset(pDevice, pDevice->abyBBVGA[0]);
-
 	pDevice->byRadioCtl = pDevice->abyEEPROM[EEP_OFS_RADIOCTL];
 	pDevice->bHWRadioOff = false;
 
-- 
1.9.1

