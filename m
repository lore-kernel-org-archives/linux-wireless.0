Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:64569 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057Ab3G3UD0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jul 2013 16:03:26 -0400
Received: by mail-wi0-f181.google.com with SMTP id en1so4727553wid.8
        for <linux-wireless@vger.kernel.org>; Tue, 30 Jul 2013 13:03:24 -0700 (PDT)
Message-ID: <1375214593.5852.6.camel@canaries64> (sfid-20130730_220329_406254_B4F64812)
Subject: [PATCH 1/2] staging: vt6656: dead code wCTSDuration.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Tue, 30 Jul 2013 21:03:13 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Always set to zero, so remove.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>

---
 drivers/staging/vt6656/device.h   | 1 -
 drivers/staging/vt6656/main_usb.c | 1 -
 drivers/staging/vt6656/rxtx.c     | 4 ----
 3 files changed, 6 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index f07ba24..5324c24 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -591,7 +591,6 @@ struct vnt_private {
 	u8 abyBSSID[ETH_ALEN];
 	u8 abyDesireBSSID[ETH_ALEN];
 
-	u16 wCTSDuration;       /* update while speed change */
 	u16 wACKDuration;
 	u16 wRTSTransmitLen;
 	u8 byRTSServiceField;
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 0c9e60f..3bc5834 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -267,7 +267,6 @@ device_set_options(struct vnt_private *pDevice) {
     pDevice->bUpdateBBVGA = true;
     pDevice->byFOETuning = 0;
     pDevice->byAutoPwrTunning = 0;
-    pDevice->wCTSDuration = 0;
     pDevice->byPreambleType = 0;
     pDevice->bExistSWNetAddr = false;
     /* pDevice->bDiversityRegCtlON = true; */
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 00e0c71..be0c9ce 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -1005,15 +1005,12 @@ static void s_vFillCTSHead(struct vnt_private *pDevice, u32 uDMAIdx,
             );
             pBuf->wTransmitLength_b = cpu_to_le16(wLen);
             pBuf->wDuration_ba = (u16)s_uGetRTSCTSDuration(pDevice, CTSDUR_BA, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption); //3:CTSDuration_ba, 1:2.4G, 2,3:2.4G OFDM Data
-            pBuf->wDuration_ba += pDevice->wCTSDuration;
             pBuf->wDuration_ba = cpu_to_le16(pBuf->wDuration_ba);
             //Get CTSDuration_ba_f0
             pBuf->wCTSDuration_ba_f0 = (u16)s_uGetRTSCTSDuration(pDevice, CTSDUR_BA_F0, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption); //8:CTSDuration_ba_f0, 1:2.4G, 2,3:2.4G OFDM Data
-            pBuf->wCTSDuration_ba_f0 += pDevice->wCTSDuration;
             pBuf->wCTSDuration_ba_f0 = cpu_to_le16(pBuf->wCTSDuration_ba_f0);
             //Get CTSDuration_ba_f1
             pBuf->wCTSDuration_ba_f1 = (u16)s_uGetRTSCTSDuration(pDevice, CTSDUR_BA_F1, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption); //9:CTSDuration_ba_f1, 1:2.4G, 2,3:2.4G OFDM Data
-            pBuf->wCTSDuration_ba_f1 += pDevice->wCTSDuration;
             pBuf->wCTSDuration_ba_f1 = cpu_to_le16(pBuf->wCTSDuration_ba_f1);
             //Get CTS Frame body
             pBuf->Data.wDurationID = pBuf->wDuration_ba;
@@ -1031,7 +1028,6 @@ static void s_vFillCTSHead(struct vnt_private *pDevice, u32 uDMAIdx,
             pBuf->wTransmitLength_b = cpu_to_le16(wLen);
             //Get CTSDuration_ba
             pBuf->wDuration_ba = cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, CTSDUR_BA, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption)); //3:CTSDuration_ba, 1:2.4G, 2,3:2.4G OFDM Data
-            pBuf->wDuration_ba += pDevice->wCTSDuration;
             pBuf->wDuration_ba = cpu_to_le16(pBuf->wDuration_ba);
 
             //Get CTS Frame body
-- 
1.8.1.2


