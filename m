Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:55814 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792AbbBAMAM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Feb 2015 07:00:12 -0500
Received: by mail-wg0-f41.google.com with SMTP id a1so34157421wgh.0
        for <linux-wireless@vger.kernel.org>; Sun, 01 Feb 2015 04:00:11 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 2/6] staging: vt6655: parse bb vga code out of device_intr.
Date: Sun,  1 Feb 2015 11:59:39 +0000
Message-Id: <1422791983-3408-2-git-send-email-tvboxspy@gmail.com> (sfid-20150201_130020_219491_A46C58C8)
In-Reply-To: <1422791983-3408-1-git-send-email-tvboxspy@gmail.com>
References: <1422791983-3408-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reordering the code and reversing the priv->byBBVGANew verses
priv->byBBVGACurrent check and using dev_dbg for pr_debug.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device_main.c | 93 +++++++++++++++++++++---------------
 1 file changed, 54 insertions(+), 39 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 9a80144..870cafd 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -1008,6 +1008,58 @@ static void device_free_tx_buf(struct vnt_private *pDevice, PSTxDesc pDesc)
 	pTDInfo->byFlags = 0;
 }
 
+static void vnt_check_bb_vga(struct vnt_private *priv)
+{
+	long dbm;
+	int i;
+
+	if (!priv->bUpdateBBVGA)
+		return;
+
+	if (priv->hw->conf.flags & IEEE80211_CONF_OFFCHANNEL)
+		return;
+
+	if (!(priv->vif->bss_conf.assoc && priv->uCurrRSSI))
+		return;
+
+	RFvRSSITodBm(priv, (u8)priv->uCurrRSSI, &dbm);
+
+	for (i = 0; i < BB_VGA_LEVEL; i++) {
+		if (dbm < priv->ldBmThreshold[i]) {
+			priv->byBBVGANew = priv->abyBBVGA[i];
+			break;
+		}
+	}
+
+	if (priv->byBBVGANew == priv->byBBVGACurrent) {
+		priv->uBBVGADiffCount = 1;
+		return;
+	}
+
+	priv->uBBVGADiffCount++;
+
+	if (priv->uBBVGADiffCount == 1) {
+		/* first VGA diff gain */
+		BBvSetVGAGainOffset(priv, priv->byBBVGANew);
+
+		dev_dbg(&priv->pcid->dev,
+			"First RSSI[%d] NewGain[%d] OldGain[%d] Count[%d]\n",
+			(int)dbm, priv->byBBVGANew,
+			priv->byBBVGACurrent,
+			(int)priv->uBBVGADiffCount);
+	}
+
+	if (priv->uBBVGADiffCount >= BB_VGA_CHANGE_THRESHOLD) {
+		dev_dbg(&priv->pcid->dev,
+			"RSSI[%d] NewGain[%d] OldGain[%d] Count[%d]\n",
+			(int)dbm, priv->byBBVGANew,
+			priv->byBBVGACurrent,
+			(int)priv->uBBVGADiffCount);
+
+		BBvSetVGAGainOffset(priv, priv->byBBVGANew);
+	}
+}
+
 static  irqreturn_t  device_intr(int irq,  void *dev_instance)
 {
 	struct vnt_private *pDevice = dev_instance;
@@ -1015,7 +1067,6 @@ static  irqreturn_t  device_intr(int irq,  void *dev_instance)
 	unsigned long dwMIBCounter = 0;
 	unsigned char byOrgPageSel = 0;
 	int             handled = 0;
-	int             ii = 0;
 	unsigned long flags;
 
 	MACvReadISR(pDevice->PortOffset, &pDevice->dwIsr);
@@ -1059,44 +1110,8 @@ static  irqreturn_t  device_intr(int irq,  void *dev_instance)
 
 		if (pDevice->dwIsr & ISR_TBTT) {
 			if (pDevice->vif &&
-			    pDevice->op_mode != NL80211_IFTYPE_ADHOC) {
-				if (pDevice->bUpdateBBVGA &&
-				    !(pDevice->hw->conf.flags & IEEE80211_CONF_OFFCHANNEL) &&
-				    pDevice->vif->bss_conf.assoc &&
-				    pDevice->uCurrRSSI) {
-					long            ldBm;
-
-					RFvRSSITodBm(pDevice, (unsigned char) pDevice->uCurrRSSI, &ldBm);
-					for (ii = 0; ii < BB_VGA_LEVEL; ii++) {
-						if (ldBm < pDevice->ldBmThreshold[ii]) {
-							pDevice->byBBVGANew = pDevice->abyBBVGA[ii];
-							break;
-						}
-					}
-					if (pDevice->byBBVGANew != pDevice->byBBVGACurrent) {
-						pDevice->uBBVGADiffCount++;
-						if (pDevice->uBBVGADiffCount == 1) {
-							// first VGA diff gain
-							BBvSetVGAGainOffset(pDevice, pDevice->byBBVGANew);
-							pr_debug("First RSSI[%d] NewGain[%d] OldGain[%d] Count[%d]\n",
-								 (int)ldBm,
-								 pDevice->byBBVGANew,
-								 pDevice->byBBVGACurrent,
-								 (int)pDevice->uBBVGADiffCount);
-						}
-						if (pDevice->uBBVGADiffCount >= BB_VGA_CHANGE_THRESHOLD) {
-							pr_debug("RSSI[%d] NewGain[%d] OldGain[%d] Count[%d]\n",
-								 (int)ldBm,
-								 pDevice->byBBVGANew,
-								 pDevice->byBBVGACurrent,
-								 (int)pDevice->uBBVGADiffCount);
-							BBvSetVGAGainOffset(pDevice, pDevice->byBBVGANew);
-						}
-					} else {
-						pDevice->uBBVGADiffCount = 1;
-					}
-				}
-			}
+			    pDevice->op_mode != NL80211_IFTYPE_ADHOC)
+				vnt_check_bb_vga(pDevice);
 
 			pDevice->bBeaconSent = false;
 			if (pDevice->bEnablePSMode)
-- 
2.1.0

