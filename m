Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:52708 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760710AbaGSLbU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jul 2014 07:31:20 -0400
Received: by mail-wi0-f176.google.com with SMTP id bs8so2006131wib.9
        for <linux-wireless@vger.kernel.org>; Sat, 19 Jul 2014 04:31:19 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 13/16] staging: vt6656: antenna modes remove unused variables
Date: Sat, 19 Jul 2014 12:30:15 +0100
Message-Id: <1405769418-2815-13-git-send-email-tvboxspy@gmail.com> (sfid-20140719_133127_926493_9B65E03A)
In-Reply-To: <1405769418-2815-1-git-send-email-tvboxspy@gmail.com>
References: <1405769418-2815-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

dwTxAntennaSel is always the same as dwRxAntennaSel

byAntennaCount is never used.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h   | 2 --
 drivers/staging/vt6656/main_usb.c | 4 ----
 2 files changed, 6 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 7c81105..ecf8da0 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -319,8 +319,6 @@ struct vnt_private {
 	/* Antenna Diversity */
 	int bTxRxAntInv;
 	u32 dwRxAntennaSel;
-	u32 dwTxAntennaSel;
-	u8 byAntennaCount;
 	u8 byRxAntennaMode;
 	u8 byTxAntennaMode;
 	u8 byRadioCtl;
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index c0951bf..4ca6639 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -249,9 +249,7 @@ static int device_init_registers(struct vnt_private *priv)
 		antenna = (EEP_ANTENNA_AUX | EEP_ANTENNA_MAIN);
 
 	if (antenna == (EEP_ANTENNA_AUX | EEP_ANTENNA_MAIN)) {
-		priv->byAntennaCount = 2;
 		priv->byTxAntennaMode = ANT_B;
-		priv->dwTxAntennaSel = 1;
 		priv->dwRxAntennaSel = 1;
 
 		if (priv->bTxRxAntInv == true)
@@ -259,8 +257,6 @@ static int device_init_registers(struct vnt_private *priv)
 		else
 			priv->byRxAntennaMode = ANT_B;
 	} else  {
-		priv->byAntennaCount = 1;
-		priv->dwTxAntennaSel = 0;
 		priv->dwRxAntennaSel = 0;
 
 		if (antenna & EEP_ANTENNA_AUX) {
-- 
2.0.1

