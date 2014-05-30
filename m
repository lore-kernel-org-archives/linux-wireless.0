Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:33285 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932289AbaE3WYM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2014 18:24:12 -0400
Received: by mail-wi0-f181.google.com with SMTP id n15so1954390wiw.8
        for <linux-wireless@vger.kernel.org>; Fri, 30 May 2014 15:24:11 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 4/8] staging: vt6656: rename CARDvSetFirstNextTBTT to vnt_reset_next_tbtt
Date: Fri, 30 May 2014 23:22:50 +0100
Message-Id: <1401488574-16508-4-git-send-email-tvboxspy@gmail.com> (sfid-20140531_002419_913552_2D485AC5)
In-Reply-To: <1401488574-16508-1-git-send-email-tvboxspy@gmail.com>
References: <1401488574-16508-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drop card, set and first. The device resets the next tbtt rename
to vnt_reset_next_tbtt

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c | 4 ++--
 drivers/staging/vt6656/card.h | 2 +-
 drivers/staging/vt6656/wmgr.c | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index ee013a3..7cb7bbc 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -31,7 +31,7 @@
  *      vnt_get_tsf_offset - Calculate TSFOffset
  *      vnt_get_current_tsf - Read Current NIC TSF counter
  *      vnt_get_next_tbtt - Calculate Next Beacon TSF counter
- *      CARDvSetFirstNextTBTT - Set NIC Beacon time
+ *      vnt_reset_next_tbtt - Set NIC Beacon time
  *      CARDvUpdateNextTBTT - Sync. NIC Beacon time
  *      CARDbRadioPowerOff - Turn Off NIC Radio Power
  *      CARDbRadioPowerOn - Turn On NIC Radio Power
@@ -689,7 +689,7 @@ u64 vnt_get_next_tbtt(u64 tsf, u16 beacon_interval)
  * Return Value: none
  *
  */
-void CARDvSetFirstNextTBTT(struct vnt_private *priv, u16 beacon_interval)
+void vnt_reset_next_tbtt(struct vnt_private *priv, u16 beacon_interval)
 {
 	u64 next_tbtt = 0;
 	u8 data[8];
diff --git a/drivers/staging/vt6656/card.h b/drivers/staging/vt6656/card.h
index d39a0a5..768515c 100644
--- a/drivers/staging/vt6656/card.h
+++ b/drivers/staging/vt6656/card.h
@@ -54,7 +54,7 @@ int vnt_ofdm_min_rate(struct vnt_private *);
 void vnt_adjust_tsf(struct vnt_private *, u8, u64, u64);
 bool vnt_get_current_tsf(struct vnt_private *, u64 *);
 bool vnt_clear_current_tsf(struct vnt_private *);
-void CARDvSetFirstNextTBTT(struct vnt_private *pDevice, u16 wBeaconInterval);
+void vnt_reset_next_tbtt(struct vnt_private *, u16);
 void CARDvUpdateNextTBTT(struct vnt_private *pDevice, u64 qwTSF,
 			 u16 wBeaconInterval);
 u64 vnt_get_next_tbtt(u64, u16);
diff --git a/drivers/staging/vt6656/wmgr.c b/drivers/staging/vt6656/wmgr.c
index 5b2e9e5..28112ec 100644
--- a/drivers/staging/vt6656/wmgr.c
+++ b/drivers/staging/vt6656/wmgr.c
@@ -2051,7 +2051,7 @@ void vMgrCreateOwnIBSS(struct vnt_private *pDevice, PCMD_STATUS pStatus)
     // enable TSF counter
     MACvRegBitsOn(pDevice,MAC_REG_TFTCTL,TFTCTL_TSFCNTREN);
     // set Next TBTT
-    CARDvSetFirstNextTBTT(pDevice, pMgmt->wIBSSBeaconPeriod);
+    vnt_reset_next_tbtt(pDevice, pMgmt->wIBSSBeaconPeriod);
 
     pMgmt->uIBSSChannel = pDevice->uChannel;
 
@@ -2584,7 +2584,7 @@ static void s_vMgrSynchBSS(struct vnt_private *pDevice, u32 uBSSMode,
 
     // set Next TBTT
     // Next TBTT = ((local_current_TSF / beacon_interval) + 1 ) * beacon_interval
-    CARDvSetFirstNextTBTT(pDevice, pCurr->wBeaconInterval);
+    vnt_reset_next_tbtt(pDevice, pCurr->wBeaconInterval);
 
     // set BSSID
     MACvWriteBSSIDAddress(pDevice, pCurr->abyBSSID);
-- 
1.9.1

