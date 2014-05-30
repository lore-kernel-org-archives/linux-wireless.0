Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:33110 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933620AbaE3P2o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2014 11:28:44 -0400
Received: by mail-wi0-f171.google.com with SMTP id cc10so1346863wib.4
        for <linux-wireless@vger.kernel.org>; Fri, 30 May 2014 08:28:43 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 12/12] staging: vt6656: rename CARDvAdjustTSF to vnt_adjust_tsf
Date: Fri, 30 May 2014 16:27:51 +0100
Message-Id: <1401463671-4705-12-git-send-email-tvboxspy@gmail.com> (sfid-20140530_172855_740294_6C768A35)
In-Reply-To: <1401463671-4705-1-git-send-email-tvboxspy@gmail.com>
References: <1401463671-4705-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drop card and rename to vnt_adjust_tsf

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c | 2 +-
 drivers/staging/vt6656/card.h | 3 +--
 drivers/staging/vt6656/wmgr.c | 6 +++---
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 3b51eae..24dd9f8 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -581,7 +581,7 @@ u64 vnt_get_tsf_offset(u8 rx_rate, u64 tsf1, u64 tsf2)
  * Return Value: none
  *
  */
-void CARDvAdjustTSF(struct vnt_private *priv, u8 rx_rate,
+void vnt_adjust_tsf(struct vnt_private *priv, u8 rx_rate,
 		u64 time_stamp, u64 local_tsf)
 {
 	u64 tsf_offset = 0;
diff --git a/drivers/staging/vt6656/card.h b/drivers/staging/vt6656/card.h
index ffd6552..75e4f5f 100644
--- a/drivers/staging/vt6656/card.h
+++ b/drivers/staging/vt6656/card.h
@@ -51,8 +51,7 @@ void vnt_update_ifs(struct vnt_private *);
 void vnt_update_top_rates(struct vnt_private *);
 void vnt_add_basic_rate(struct vnt_private *, u16);
 int vnt_ofdm_min_rate(struct vnt_private *);
-void CARDvAdjustTSF(struct vnt_private *pDevice, u8 byRxRate,
-		u64 qwBSSTimestamp, u64 qwLocalTSF);
+void vnt_adjust_tsf(struct vnt_private *, u8, u64, u64);
 bool CARDbGetCurrentTSF(struct vnt_private *pDevice, u64 *pqwCurrTSF);
 bool CARDbClearCurrentTSF(struct vnt_private *pDevice);
 void CARDvSetFirstNextTBTT(struct vnt_private *pDevice, u16 wBeaconInterval);
diff --git a/drivers/staging/vt6656/wmgr.c b/drivers/staging/vt6656/wmgr.c
index 9381d6f..d5d2273 100644
--- a/drivers/staging/vt6656/wmgr.c
+++ b/drivers/staging/vt6656/wmgr.c
@@ -1916,7 +1916,7 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==true)
                      DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Rejoining to Other Adhoc group with same SSID........\n");
 
                      MACvWriteBeaconInterval(pDevice, pMgmt->wCurrBeaconPeriod);
-                     CARDvAdjustTSF(pDevice, pRxPacket->byRxRate, qwTimestamp, pRxPacket->qwLocalTSF);
+		     vnt_adjust_tsf(pDevice, pRxPacket->byRxRate, qwTimestamp, pRxPacket->qwLocalTSF);
                      CARDvUpdateNextTBTT(pDevice, qwTimestamp, pMgmt->wCurrBeaconPeriod);
 
                      // Turn off bssid filter to avoid filter others adhoc station which bssid is different.
@@ -1945,7 +1945,7 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==true)
     // Update TSF
     if (bUpdateTSF) {
         CARDbGetCurrentTSF(pDevice, &qwCurrTSF);
-        CARDvAdjustTSF(pDevice, pRxPacket->byRxRate, qwTimestamp , pRxPacket->qwLocalTSF);
+	vnt_adjust_tsf(pDevice, pRxPacket->byRxRate, qwTimestamp , pRxPacket->qwLocalTSF);
         CARDbGetCurrentTSF(pDevice, &qwCurrTSF);
         CARDvUpdateNextTBTT(pDevice, qwTimestamp, pMgmt->wCurrBeaconPeriod);
     }
@@ -2577,7 +2577,7 @@ static void s_vMgrSynchBSS(struct vnt_private *pDevice, u32 uBSSMode,
 
     // calculate TSF offset
     // TSF Offset = Received Timestamp TSF - Marked Local's TSF
-    CARDvAdjustTSF(pDevice, pCurr->byRxRate, pCurr->qwBSSTimestamp, pCurr->qwLocalTSF);
+    vnt_adjust_tsf(pDevice, pCurr->byRxRate, pCurr->qwBSSTimestamp, pCurr->qwLocalTSF);
 
     // set HW beacon interval
     MACvWriteBeaconInterval(pDevice, pCurr->wBeaconInterval);
-- 
1.9.1

