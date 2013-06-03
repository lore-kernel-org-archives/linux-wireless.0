Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:54834 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758421Ab3FCVrZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 17:47:25 -0400
Received: by mail-wi0-f174.google.com with SMTP id c10so3157407wiw.13
        for <linux-wireless@vger.kernel.org>; Mon, 03 Jun 2013 14:47:24 -0700 (PDT)
Message-ID: <1370296040.9091.29.camel@canaries64> (sfid-20130603_234728_595177_B44BABDE)
Subject: [PATCH 3/8] staging: vt6656: rf.c/h rename RFbSetPower
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 03 Jun 2013 22:47:20 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove camel case rename RFbSetPower to vnt_rf_setpower

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rf.c   |  2 +-
 drivers/staging/vt6656/rf.h   |  2 +-
 drivers/staging/vt6656/rxtx.c | 19 +++++++++----------
 drivers/staging/vt6656/wcmd.c |  8 ++++----
 4 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/vt6656/rf.c b/drivers/staging/vt6656/rf.c
index 8c10886..7e6e386 100644
--- a/drivers/staging/vt6656/rf.c
+++ b/drivers/staging/vt6656/rf.c
@@ -735,7 +735,7 @@ int vnt_rf_write_embedded(struct vnt_private *priv, u32 data)
  * Return Value: true if succeeded; false if failed.
  *
  */
-int RFbSetPower(struct vnt_private *priv, u32 rate, u32 channel)
+int vnt_rf_setpower(struct vnt_private *priv, u32 rate, u32 channel)
 {
 	int ret = true;
 	u8 power = priv->byCCKPwr;
diff --git a/drivers/staging/vt6656/rf.h b/drivers/staging/vt6656/rf.h
index 9de28c0..62fcfc6 100644
--- a/drivers/staging/vt6656/rf.h
+++ b/drivers/staging/vt6656/rf.h
@@ -56,7 +56,7 @@
 extern const u8 RFaby11aChannelIndex[200];
 
 int vnt_rf_write_embedded(struct vnt_private *, u32);
-int RFbSetPower(struct vnt_private *, u32 uRATE, u32 uCH);
+int vnt_rf_setpower(struct vnt_private *, u32, u32);
 int RFbRawSetPower(struct vnt_private *, u8 byPwr, u32 uRATE);
 void RFvRSSITodBm(struct vnt_private *, u8 byCurrRSSI, long *pldBm);
 void RFbRFTableDownload(struct vnt_private *pDevice);
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 9bf2f8d..d29d4b2 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -1720,11 +1720,11 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
     // 2004.11.11 Kyle -- Using OFDM power to tx MngPkt will decrease the connection capability.
     //                    And cmd timer will wait data pkt TX finish before scanning so it's OK
     //                    to set power here.
-    if (pMgmt->eScanState != WMAC_NO_SCANNING) {
-        RFbSetPower(pDevice, wCurrentRate, pDevice->byCurrentCh);
-    } else {
-        RFbSetPower(pDevice, wCurrentRate, pMgmt->uCurrChannel);
-    }
+	if (pMgmt->eScanState != WMAC_NO_SCANNING)
+		vnt_rf_setpower(pDevice, wCurrentRate, pDevice->byCurrentCh);
+	else
+		vnt_rf_setpower(pDevice, wCurrentRate, pMgmt->uCurrChannel);
+
     pDevice->wCurrentRate = wCurrentRate;
 
     //Set packet type
@@ -2098,11 +2098,10 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
     // 2004.11.11 Kyle -- Using OFDM power to tx MngPkt will decrease the connection capability.
     //                    And cmd timer will wait data pkt TX finish before scanning so it's OK
     //                    to set power here.
-    if (pMgmt->eScanState != WMAC_NO_SCANNING) {
-        RFbSetPower(pDevice, wCurrentRate, pDevice->byCurrentCh);
-    } else {
-        RFbSetPower(pDevice, wCurrentRate, pMgmt->uCurrChannel);
-    }
+	if (pMgmt->eScanState != WMAC_NO_SCANNING)
+		vnt_rf_setpower(pDevice, wCurrentRate, pDevice->byCurrentCh);
+	else
+		vnt_rf_setpower(pDevice, wCurrentRate, pMgmt->uCurrChannel);
 
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"vDMA0_tx_80211: p80211Header->sA3.wFrameCtl = %x \n", p80211Header->sA3.wFrameCtl);
 
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index 0013cb7..8cd45e3 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -905,11 +905,11 @@ void vRunCommand(struct vnt_private *pDevice)
             break;
 
         case WLAN_CMD_SETPOWER_START:
+		vnt_rf_setpower(pDevice, pDevice->wCurrentRate,
+							pMgmt->uCurrChannel);
 
-            RFbSetPower(pDevice, pDevice->wCurrentRate, pMgmt->uCurrChannel);
-
-            s_bCommandComplete(pDevice);
-            break;
+		s_bCommandComplete(pDevice);
+		break;
 
         case WLAN_CMD_CHANGE_ANTENNA_START:
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Change from Antenna%d to", (int)pDevice->dwRxAntennaSel);
-- 
1.8.1.2

