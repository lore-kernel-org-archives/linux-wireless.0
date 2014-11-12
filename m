Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:50346 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404AbaKLVLy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2014 16:11:54 -0500
Received: by mail-wi0-f174.google.com with SMTP id d1so6299171wiv.1
        for <linux-wireless@vger.kernel.org>; Wed, 12 Nov 2014 13:11:53 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 2/8] staging: vt6655: card.c move __iomem into functions.
Date: Wed, 12 Nov 2014 21:11:09 +0000
Message-Id: <1415826675-8446-2-git-send-email-tvboxspy@gmail.com> (sfid-20141112_221158_169623_E11B9383)
In-Reply-To: <1415826675-8446-1-git-send-email-tvboxspy@gmail.com>
References: <1415826675-8446-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing dereferencing from callers

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/card.c        | 18 ++++++++++++------
 drivers/staging/vt6655/card.h        |  8 ++++----
 drivers/staging/vt6655/device_main.c |  7 +++----
 drivers/staging/vt6655/rxtx.c        |  2 +-
 4 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index a93ca16..a079640 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -394,7 +394,7 @@ bool CARDbSetBeaconPeriod(struct vnt_private *pDevice,
 {
 	u64 qwNextTBTT = 0;
 
-	CARDbGetCurrentTSF(pDevice->PortOffset, &qwNextTBTT); /* Get Local TSF counter */
+	CARDbGetCurrentTSF(pDevice, &qwNextTBTT); /* Get Local TSF counter */
 
 	qwNextTBTT = CARDqGetNextTBTT(qwNextTBTT, wBeaconInterval);
 
@@ -828,8 +828,10 @@ unsigned char CARDbyGetPktType(struct vnt_private *pDevice)
  *
  * Return Value: none
  */
-void CARDvSetLoopbackMode(void __iomem *dwIoBase, unsigned short wLoopbackMode)
+void CARDvSetLoopbackMode(struct vnt_private *priv, unsigned short wLoopbackMode)
 {
+	void __iomem *dwIoBase = priv->PortOffset;
+
 	switch (wLoopbackMode) {
 	case CARD_LB_NONE:
 	case CARD_LB_MAC:
@@ -905,8 +907,9 @@ u64 CARDqGetTSFOffset(unsigned char byRxRate, u64 qwTSF1, u64 qwTSF2)
  *
  * Return Value: true if success; otherwise false
  */
-bool CARDbGetCurrentTSF(void __iomem *dwIoBase, u64 *pqwCurrTSF)
+bool CARDbGetCurrentTSF(struct vnt_private *priv, u64 *pqwCurrTSF)
 {
+	void __iomem *dwIoBase = priv->PortOffset;
 	unsigned short ww;
 	unsigned char byData;
 
@@ -964,11 +967,12 @@ u64 CARDqGetNextTBTT(u64 qwTSF, unsigned short wBeaconInterval)
  *
  * Return Value: none
  */
-void CARDvSetFirstNextTBTT(void __iomem *dwIoBase, unsigned short wBeaconInterval)
+void CARDvSetFirstNextTBTT(struct vnt_private *priv, unsigned short wBeaconInterval)
 {
+	void __iomem *dwIoBase = priv->PortOffset;
 	u64 qwNextTBTT = 0;
 
-	CARDbGetCurrentTSF(dwIoBase, &qwNextTBTT); /* Get Local TSF counter */
+	CARDbGetCurrentTSF(priv, &qwNextTBTT); /* Get Local TSF counter */
 
 	qwNextTBTT = CARDqGetNextTBTT(qwNextTBTT, wBeaconInterval);
 	/* Set NextTBTT */
@@ -991,8 +995,10 @@ void CARDvSetFirstNextTBTT(void __iomem *dwIoBase, unsigned short wBeaconInterva
  *
  * Return Value: none
  */
-void CARDvUpdateNextTBTT(void __iomem *dwIoBase, u64 qwTSF, unsigned short wBeaconInterval)
+void CARDvUpdateNextTBTT(struct vnt_private *priv, u64 qwTSF, unsigned short wBeaconInterval)
 {
+	void __iomem *dwIoBase = priv->PortOffset;
+
 	qwTSF = CARDqGetNextTBTT(qwTSF, wBeaconInterval);
 	/* Set NextTBTT */
 	VNSvOutPortD(dwIoBase + MAC_REG_NEXTTBTT, (u32)qwTSF);
diff --git a/drivers/staging/vt6655/card.h b/drivers/staging/vt6655/card.h
index 2e56710..2dfc419 100644
--- a/drivers/staging/vt6655/card.h
+++ b/drivers/staging/vt6655/card.h
@@ -69,11 +69,11 @@ struct vnt_private;
 void CARDvSetRSPINF(struct vnt_private *, u8);
 void CARDvUpdateBasicTopRate(struct vnt_private *);
 bool CARDbIsOFDMinBasicRate(struct vnt_private *);
-void CARDvSetLoopbackMode(void __iomem *dwIoBase, unsigned short wLoopbackMode);
+void CARDvSetLoopbackMode(struct vnt_private *, unsigned short wLoopbackMode);
 bool CARDbSoftwareReset(struct vnt_private *);
-void CARDvSetFirstNextTBTT(void __iomem *dwIoBase, unsigned short wBeaconInterval);
-void CARDvUpdateNextTBTT(void __iomem *dwIoBase, u64 qwTSF, unsigned short wBeaconInterval);
-bool CARDbGetCurrentTSF(void __iomem *dwIoBase, u64 *pqwCurrTSF);
+void CARDvSetFirstNextTBTT(struct vnt_private *, unsigned short wBeaconInterval);
+void CARDvUpdateNextTBTT(struct vnt_private *, u64 qwTSF, unsigned short wBeaconInterval);
+bool CARDbGetCurrentTSF(struct vnt_private *, u64 *pqwCurrTSF);
 u64 CARDqGetNextTBTT(u64 qwTSF, unsigned short wBeaconInterval);
 u64 CARDqGetTSFOffset(unsigned char byRxRate, u64 qwTSF1, u64 qwTSF2);
 unsigned char CARDbyGetPktType(struct vnt_private *);
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 1392332..83e4162 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -1513,8 +1513,7 @@ static void vnt_bss_info_changed(struct ieee80211_hw *hw,
 
 			CARDbSetBeaconPeriod(priv, conf->beacon_int);
 
-			CARDvSetFirstNextTBTT(priv->PortOffset,
-					      conf->beacon_int);
+			CARDvSetFirstNextTBTT(priv, conf->beacon_int);
 		} else {
 			VNSvOutPortB(priv->PortOffset + MAC_REG_TFTCTL,
 				     TFTCTL_TSFCNTRST);
@@ -1633,7 +1632,7 @@ static u64 vnt_get_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	struct vnt_private *priv = hw->priv;
 	u64 tsf;
 
-	CARDbGetCurrentTSF(priv->PortOffset, &tsf);
+	CARDbGetCurrentTSF(priv, &tsf);
 
 	return tsf;
 }
@@ -1643,7 +1642,7 @@ static void vnt_set_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 {
 	struct vnt_private *priv = hw->priv;
 
-	CARDvUpdateNextTBTT(priv->PortOffset, tsf, vif->bss_conf.beacon_int);
+	CARDvUpdateNextTBTT(priv, tsf, vif->bss_conf.beacon_int);
 }
 
 static void vnt_reset_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index f4da7e7..4189405 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -1521,7 +1521,7 @@ int vnt_beacon_enable(struct vnt_private *priv, struct ieee80211_vif *vif,
 
 	VNSvOutPortB(priv->PortOffset + MAC_REG_TFTCTL, TFTCTL_TSFCNTREN);
 
-	CARDvSetFirstNextTBTT(priv->PortOffset, conf->beacon_int);
+	CARDvSetFirstNextTBTT(priv, conf->beacon_int);
 
 	CARDbSetBeaconPeriod(priv, conf->beacon_int);
 
-- 
2.1.0

