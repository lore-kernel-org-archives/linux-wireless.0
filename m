Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:60342 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757284AbaEQIxP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 May 2014 04:53:15 -0400
Received: by mail-we0-f182.google.com with SMTP id t60so3485723wes.41
        for <linux-wireless@vger.kernel.org>; Sat, 17 May 2014 01:53:14 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 17/22] staging: vt6656: Remove unused variable uScanTime.
Date: Sat, 17 May 2014 09:50:34 +0100
Message-Id: <1400316639-4430-17-git-send-email-tvboxspy@gmail.com> (sfid-20140517_112148_064114_E003D123)
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
index 8248824..eff50c8 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -607,7 +607,6 @@ struct vnt_private {
 	int bBeaconSent;
 	int bFixRate;
 	u8 byCurrentCh;
-	u32 uScanTime;
 
 	CMD_STATE eCommandState;
 
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index ea0c9e7..c00a16c 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -488,9 +488,6 @@ static int device_init_registers(struct vnt_private *pDevice)
 	/* get Auto Fall Back type */
 	pDevice->byAutoFBCtrl = AUTO_FB_0;
 
-	/* set SCAN Time */
-	pDevice->uScanTime = WLAN_SCAN_MINITIME;
-
 	/* default Auto Mode */
 	/* pDevice->NetworkType = Ndis802_11Automode; */
 	pDevice->eConfigPHYMode = PHY_TYPE_AUTO;
-- 
1.9.1

