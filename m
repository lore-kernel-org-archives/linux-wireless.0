Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:57002 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933501AbaE3P2m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2014 11:28:42 -0400
Received: by mail-we0-f172.google.com with SMTP id k48so2217340wev.17
        for <linux-wireless@vger.kernel.org>; Fri, 30 May 2014 08:28:41 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 11/12] staging: vt6656: rename CARDqGetTSFOffset to vnt_get_tsf_offset
Date: Fri, 30 May 2014 16:27:50 +0100
Message-Id: <1401463671-4705-11-git-send-email-tvboxspy@gmail.com> (sfid-20140530_172855_119124_DB724EBB)
In-Reply-To: <1401463671-4705-1-git-send-email-tvboxspy@gmail.com>
References: <1401463671-4705-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drop card and rename to vnt_get_tsf_offset

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c | 6 +++---
 drivers/staging/vt6656/card.h | 2 +-
 drivers/staging/vt6656/wmgr.c | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 27ed88b..3b51eae 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -28,7 +28,7 @@
  *      vnt_ofdm_min_rate - Check if any OFDM rate is in BasicRateSet
  *      CARDvSetLoopbackMode - Set Loopback mode
  *      CARDbSoftwareReset - Sortware reset NIC
- *      CARDqGetTSFOffset - Calculate TSFOffset
+ *      vnt_get_tsf_offset - Calculate TSFOffset
  *      CARDbGetCurrentTSF - Read Current NIC TSF counter
  *      CARDqGetNextTBTT - Calculate Next Beacon TSF counter
  *      CARDvSetFirstNextTBTT - Set NIC Beacon time
@@ -552,7 +552,7 @@ u8 vnt_get_pkt_type(struct vnt_private *priv)
  * Return Value: TSF Offset value
  *
  */
-u64 CARDqGetTSFOffset(u8 rx_rate, u64 tsf1, u64 tsf2)
+u64 vnt_get_tsf_offset(u8 rx_rate, u64 tsf1, u64 tsf2)
 {
 	u64 tsf_offset = 0;
 	u16 rx_bcn_offset = 0;
@@ -587,7 +587,7 @@ void CARDvAdjustTSF(struct vnt_private *priv, u8 rx_rate,
 	u64 tsf_offset = 0;
 	u8 data[8];
 
-	tsf_offset = CARDqGetTSFOffset(rx_rate, time_stamp, local_tsf);
+	tsf_offset = vnt_get_tsf_offset(rx_rate, time_stamp, local_tsf);
 
 	data[0] = (u8)tsf_offset;
 	data[1] = (u8)(tsf_offset >> 8);
diff --git a/drivers/staging/vt6656/card.h b/drivers/staging/vt6656/card.h
index 7a844c3..ffd6552 100644
--- a/drivers/staging/vt6656/card.h
+++ b/drivers/staging/vt6656/card.h
@@ -59,7 +59,7 @@ void CARDvSetFirstNextTBTT(struct vnt_private *pDevice, u16 wBeaconInterval);
 void CARDvUpdateNextTBTT(struct vnt_private *pDevice, u64 qwTSF,
 			 u16 wBeaconInterval);
 u64 CARDqGetNextTBTT(u64 qwTSF, u16 wBeaconInterval);
-u64 CARDqGetTSFOffset(u8 byRxRate, u64 qwTSF1, u64 qwTSF2);
+u64 vnt_get_tsf_offset(u8 byRxRate, u64 qwTSF1, u64 qwTSF2);
 int CARDbRadioPowerOff(struct vnt_private *pDevice);
 int CARDbRadioPowerOn(struct vnt_private *pDevice);
 u8 vnt_get_pkt_type(struct vnt_private *);
diff --git a/drivers/staging/vt6656/wmgr.c b/drivers/staging/vt6656/wmgr.c
index 652e8b6..9381d6f 100644
--- a/drivers/staging/vt6656/wmgr.c
+++ b/drivers/staging/vt6656/wmgr.c
@@ -1750,10 +1750,10 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==true)
 		bTSFOffsetPostive = false;
 
     if (bTSFOffsetPostive) {
-        qwTSFOffset = CARDqGetTSFOffset(pRxPacket->byRxRate, (qwTimestamp), (qwLocalTSF));
+	qwTSFOffset = vnt_get_tsf_offset(pRxPacket->byRxRate, (qwTimestamp), (qwLocalTSF));
     }
     else {
-        qwTSFOffset = CARDqGetTSFOffset(pRxPacket->byRxRate, (qwLocalTSF), (qwTimestamp));
+	qwTSFOffset = vnt_get_tsf_offset(pRxPacket->byRxRate, (qwLocalTSF), (qwTimestamp));
     }
 
 	if (qwTSFOffset > TRIVIAL_SYNC_DIFFERENCE)
-- 
1.9.1

