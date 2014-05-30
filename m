Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:63648 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934726AbaE3WYN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2014 18:24:13 -0400
Received: by mail-wi0-f178.google.com with SMTP id cc10so1846602wib.11
        for <linux-wireless@vger.kernel.org>; Fri, 30 May 2014 15:24:12 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 5/8] staging: vt6656: rename CARDvUpdateNextTBTT to vnt_update_next_tbtt
Date: Fri, 30 May 2014 23:22:51 +0100
Message-Id: <1401488574-16508-5-git-send-email-tvboxspy@gmail.com> (sfid-20140531_002426_324467_B26E6D5D)
In-Reply-To: <1401488574-16508-1-git-send-email-tvboxspy@gmail.com>
References: <1401488574-16508-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drop card and rename to vnt_update_next_tbtt

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c | 4 ++--
 drivers/staging/vt6656/card.h | 3 +--
 drivers/staging/vt6656/wmgr.c | 4 ++--
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 7cb7bbc..9ecf189 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -32,7 +32,7 @@
  *      vnt_get_current_tsf - Read Current NIC TSF counter
  *      vnt_get_next_tbtt - Calculate Next Beacon TSF counter
  *      vnt_reset_next_tbtt - Set NIC Beacon time
- *      CARDvUpdateNextTBTT - Sync. NIC Beacon time
+ *      vnt_update_next_tbtt - Sync. NIC Beacon time
  *      CARDbRadioPowerOff - Turn Off NIC Radio Power
  *      CARDbRadioPowerOn - Turn On NIC Radio Power
  *      CARDbSetWEPMode - Set NIC Wep mode
@@ -728,7 +728,7 @@ void vnt_reset_next_tbtt(struct vnt_private *priv, u16 beacon_interval)
  * Return Value: none
  *
  */
-void CARDvUpdateNextTBTT(struct vnt_private *priv, u64 tsf,
+void vnt_update_next_tbtt(struct vnt_private *priv, u64 tsf,
 			u16 beacon_interval)
 {
 	u8 data[8];
diff --git a/drivers/staging/vt6656/card.h b/drivers/staging/vt6656/card.h
index 768515c..d5f7c68 100644
--- a/drivers/staging/vt6656/card.h
+++ b/drivers/staging/vt6656/card.h
@@ -55,8 +55,7 @@ void vnt_adjust_tsf(struct vnt_private *, u8, u64, u64);
 bool vnt_get_current_tsf(struct vnt_private *, u64 *);
 bool vnt_clear_current_tsf(struct vnt_private *);
 void vnt_reset_next_tbtt(struct vnt_private *, u16);
-void CARDvUpdateNextTBTT(struct vnt_private *pDevice, u64 qwTSF,
-			 u16 wBeaconInterval);
+void vnt_update_next_tbtt(struct vnt_private *, u64, u16);
 u64 vnt_get_next_tbtt(u64, u16);
 u64 vnt_get_tsf_offset(u8 byRxRate, u64 qwTSF1, u64 qwTSF2);
 int CARDbRadioPowerOff(struct vnt_private *pDevice);
diff --git a/drivers/staging/vt6656/wmgr.c b/drivers/staging/vt6656/wmgr.c
index 28112ec..1646aaf 100644
--- a/drivers/staging/vt6656/wmgr.c
+++ b/drivers/staging/vt6656/wmgr.c
@@ -1917,7 +1917,7 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==true)
 
                      MACvWriteBeaconInterval(pDevice, pMgmt->wCurrBeaconPeriod);
 		     vnt_adjust_tsf(pDevice, pRxPacket->byRxRate, qwTimestamp, pRxPacket->qwLocalTSF);
-                     CARDvUpdateNextTBTT(pDevice, qwTimestamp, pMgmt->wCurrBeaconPeriod);
+		     vnt_update_next_tbtt(pDevice, qwTimestamp, pMgmt->wCurrBeaconPeriod);
 
                      // Turn off bssid filter to avoid filter others adhoc station which bssid is different.
                      MACvWriteBSSIDAddress(pDevice, pMgmt->abyCurrBSSID);
@@ -1947,7 +1947,7 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==true)
 	vnt_get_current_tsf(pDevice, &qwCurrTSF);
 	vnt_adjust_tsf(pDevice, pRxPacket->byRxRate, qwTimestamp , pRxPacket->qwLocalTSF);
 	vnt_get_current_tsf(pDevice, &qwCurrTSF);
-        CARDvUpdateNextTBTT(pDevice, qwTimestamp, pMgmt->wCurrBeaconPeriod);
+	vnt_update_next_tbtt(pDevice, qwTimestamp, pMgmt->wCurrBeaconPeriod);
     }
 
     return;
-- 
1.9.1

