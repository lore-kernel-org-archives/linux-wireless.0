Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:60584 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757231AbaEQIxL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 May 2014 04:53:11 -0400
Received: by mail-we0-f171.google.com with SMTP id w62so3569826wes.16
        for <linux-wireless@vger.kernel.org>; Sat, 17 May 2014 01:53:10 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 15/22] staging: vt6656: Remove unused variable ulTxPower.
Date: Sat, 17 May 2014 09:50:32 +0100
Message-Id: <1400316639-4430-15-git-send-email-tvboxspy@gmail.com> (sfid-20140517_112148_376989_6BE6423A)
In-Reply-To: <1400316639-4430-1-git-send-email-tvboxspy@gmail.com>
References: <1400316639-4430-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h   | 1 -
 drivers/staging/vt6656/main_usb.c | 3 ---
 2 files changed, 4 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index aefbe93..7e7ac80 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -639,7 +639,6 @@ struct vnt_private {
 	u8 bSameBSSCurNum;
 	int bRoaming;
 	int b11hEable;
-	unsigned long ulTxPower;
 
 	/* Encryption */
 	NDIS_802_11_WEP_STATUS eEncryptionStatus;
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 68ae97c..3832bcb 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -498,9 +498,6 @@ static int device_init_registers(struct vnt_private *pDevice)
 	pDevice->eConfigPHYMode = PHY_TYPE_AUTO;
 	pDevice->byBBType = BB_TYPE_11G;
 
-	/* initialize BBP registers */
-	pDevice->ulTxPower = 25;
-
 	/* get channel range */
 	pDevice->byMinChannel = 1;
 	pDevice->byMaxChannel = CB_MAX_CHANNEL;
-- 
1.9.1

