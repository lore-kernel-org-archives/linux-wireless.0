Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:36881 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614AbaE3WYI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2014 18:24:08 -0400
Received: by mail-wg0-f42.google.com with SMTP id y10so2585685wgg.1
        for <linux-wireless@vger.kernel.org>; Fri, 30 May 2014 15:24:06 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 1/8] staging: vt6656: rename CARDbGetCurrentTSF to vnt_get_current_tsf
Date: Fri, 30 May 2014 23:22:47 +0100
Message-Id: <1401488574-16508-1-git-send-email-tvboxspy@gmail.com> (sfid-20140531_002413_443357_62D65F87)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drop card and rename to vnt_get_current_tsf

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
Follow on to
staging: vt6656: rename CARDvAdjustTSF to vnt_adjust_tsf

 drivers/staging/vt6656/card.c | 4 ++--
 drivers/staging/vt6656/card.h | 2 +-
 drivers/staging/vt6656/wmgr.c | 6 +++---
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 24dd9f8..c746677 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -29,7 +29,7 @@
  *      CARDvSetLoopbackMode - Set Loopback mode
  *      CARDbSoftwareReset - Sortware reset NIC
  *      vnt_get_tsf_offset - Calculate TSFOffset
- *      CARDbGetCurrentTSF - Read Current NIC TSF counter
+ *      vnt_get_current_tsf - Read Current NIC TSF counter
  *      CARDqGetNextTBTT - Calculate Next Beacon TSF counter
  *      CARDvSetFirstNextTBTT - Set NIC Beacon time
  *      CARDvUpdateNextTBTT - Sync. NIC Beacon time
@@ -614,7 +614,7 @@ void vnt_adjust_tsf(struct vnt_private *priv, u8 rx_rate,
  * Return Value: true if success; otherwise false
  *
  */
-bool CARDbGetCurrentTSF(struct vnt_private *priv, u64 *current_tsf)
+bool vnt_get_current_tsf(struct vnt_private *priv, u64 *current_tsf)
 {
 
 	*current_tsf = priv->qwCurrTSF;
diff --git a/drivers/staging/vt6656/card.h b/drivers/staging/vt6656/card.h
index 75e4f5f..89bbc70 100644
--- a/drivers/staging/vt6656/card.h
+++ b/drivers/staging/vt6656/card.h
@@ -52,7 +52,7 @@ void vnt_update_top_rates(struct vnt_private *);
 void vnt_add_basic_rate(struct vnt_private *, u16);
 int vnt_ofdm_min_rate(struct vnt_private *);
 void vnt_adjust_tsf(struct vnt_private *, u8, u64, u64);
-bool CARDbGetCurrentTSF(struct vnt_private *pDevice, u64 *pqwCurrTSF);
+bool vnt_get_current_tsf(struct vnt_private *, u64 *);
 bool CARDbClearCurrentTSF(struct vnt_private *pDevice);
 void CARDvSetFirstNextTBTT(struct vnt_private *pDevice, u16 wBeaconInterval);
 void CARDvUpdateNextTBTT(struct vnt_private *pDevice, u64 qwTSF,
diff --git a/drivers/staging/vt6656/wmgr.c b/drivers/staging/vt6656/wmgr.c
index d5d2273..55b92fe 100644
--- a/drivers/staging/vt6656/wmgr.c
+++ b/drivers/staging/vt6656/wmgr.c
@@ -1944,9 +1944,9 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==true)
     // endian issue ???
     // Update TSF
     if (bUpdateTSF) {
-        CARDbGetCurrentTSF(pDevice, &qwCurrTSF);
+	vnt_get_current_tsf(pDevice, &qwCurrTSF);
 	vnt_adjust_tsf(pDevice, pRxPacket->byRxRate, qwTimestamp , pRxPacket->qwLocalTSF);
-        CARDbGetCurrentTSF(pDevice, &qwCurrTSF);
+	vnt_get_current_tsf(pDevice, &qwCurrTSF);
         CARDvUpdateNextTBTT(pDevice, qwTimestamp, pMgmt->wCurrBeaconPeriod);
     }
 
@@ -2044,7 +2044,7 @@ void vMgrCreateOwnIBSS(struct vnt_private *pDevice, PCMD_STATUS pStatus)
         pMgmt->wIBSSBeaconPeriod = DEFAULT_IBSS_BI;
     MACvWriteBeaconInterval(pDevice, pMgmt->wIBSSBeaconPeriod);
 
-    CARDbGetCurrentTSF(pDevice, &qwCurrTSF);
+    vnt_get_current_tsf(pDevice, &qwCurrTSF);
     // clear TSF counter
     CARDbClearCurrentTSF(pDevice);
 
-- 
1.9.1

