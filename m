Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:37581 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758159AbbEaJgH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 May 2015 05:36:07 -0400
Received: by wifw1 with SMTP id w1so70933571wif.0
        for <linux-wireless@vger.kernel.org>; Sun, 31 May 2015 02:36:06 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 7/9] staging: vt6655: vnt_interrupt_process remove camel case.
Date: Sun, 31 May 2015 10:35:26 +0100
Message-Id: <1433064928-2139-7-git-send-email-tvboxspy@gmail.com> (sfid-20150531_113615_095108_70F4C909)
In-Reply-To: <1433064928-2139-1-git-send-email-tvboxspy@gmail.com>
References: <1433064928-2139-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

pDevice -> priv

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device_main.c | 103 ++++++++++++++++++-----------------
 1 file changed, 52 insertions(+), 51 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 2262a61..575ba87 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -1051,29 +1051,29 @@ static void vnt_check_bb_vga(struct vnt_private *priv)
 	}
 }
 
-static void vnt_interrupt_process(struct vnt_private *pDevice)
+static void vnt_interrupt_process(struct vnt_private *priv)
 {
-	struct ieee80211_low_level_stats *low_stats = &pDevice->low_stats;
+	struct ieee80211_low_level_stats *low_stats = &priv->low_stats;
 	int             max_count = 0;
 	u32 mib_counter;
 	unsigned long flags;
 
-	MACvReadISR(pDevice->PortOffset, &pDevice->dwIsr);
+	MACvReadISR(priv->PortOffset, &priv->dwIsr);
 
-	if (pDevice->dwIsr == 0)
+	if (priv->dwIsr == 0)
 		return;
 
-	if (pDevice->dwIsr == 0xffffffff) {
+	if (priv->dwIsr == 0xffffffff) {
 		pr_debug("dwIsr = 0xffff\n");
 		return;
 	}
 
-	MACvIntDisable(pDevice->PortOffset);
+	MACvIntDisable(priv->PortOffset);
 
-	spin_lock_irqsave(&pDevice->lock, flags);
+	spin_lock_irqsave(&priv->lock, flags);
 
 	/* Read low level stats */
-	MACvReadMIBCounter(pDevice->PortOffset, &mib_counter);
+	MACvReadMIBCounter(priv->PortOffset, &mib_counter);
 
 	low_stats->dot11RTSSuccessCount += mib_counter & 0xff;
 	low_stats->dot11RTSFailureCount += (mib_counter >> 8) & 0xff;
@@ -1086,79 +1086,80 @@ static void vnt_interrupt_process(struct vnt_private *pDevice)
 	 * than RD/TD write back
 	 * update ISR counter
 	 */
-	while (pDevice->dwIsr && pDevice->vif) {
-		MACvWriteISR(pDevice->PortOffset, pDevice->dwIsr);
+	while (priv->dwIsr && priv->vif) {
+		MACvWriteISR(priv->PortOffset, priv->dwIsr);
 
-		if (pDevice->dwIsr & ISR_FETALERR) {
+		if (priv->dwIsr & ISR_FETALERR) {
 			pr_debug(" ISR_FETALERR\n");
-			VNSvOutPortB(pDevice->PortOffset + MAC_REG_SOFTPWRCTL, 0);
-			VNSvOutPortW(pDevice->PortOffset + MAC_REG_SOFTPWRCTL, SOFTPWRCTL_SWPECTI);
-			device_error(pDevice, pDevice->dwIsr);
+			VNSvOutPortB(priv->PortOffset + MAC_REG_SOFTPWRCTL, 0);
+			VNSvOutPortW(priv->PortOffset +
+				     MAC_REG_SOFTPWRCTL, SOFTPWRCTL_SWPECTI);
+			device_error(priv, priv->dwIsr);
 		}
 
-		if (pDevice->dwIsr & ISR_TBTT) {
-			if (pDevice->op_mode != NL80211_IFTYPE_ADHOC)
-				vnt_check_bb_vga(pDevice);
+		if (priv->dwIsr & ISR_TBTT) {
+			if (priv->op_mode != NL80211_IFTYPE_ADHOC)
+				vnt_check_bb_vga(priv);
 
-			pDevice->bBeaconSent = false;
-			if (pDevice->bEnablePSMode)
-				PSbIsNextTBTTWakeUp((void *)pDevice);
+			priv->bBeaconSent = false;
+			if (priv->bEnablePSMode)
+				PSbIsNextTBTTWakeUp((void *)priv);
 
-			if ((pDevice->op_mode == NL80211_IFTYPE_AP ||
-			    pDevice->op_mode == NL80211_IFTYPE_ADHOC) &&
-			    pDevice->vif->bss_conf.enable_beacon) {
-				MACvOneShotTimer1MicroSec(pDevice->PortOffset,
-							  (pDevice->vif->bss_conf.beacon_int - MAKE_BEACON_RESERVED) << 10);
+			if ((priv->op_mode == NL80211_IFTYPE_AP ||
+			    priv->op_mode == NL80211_IFTYPE_ADHOC) &&
+			    priv->vif->bss_conf.enable_beacon) {
+				MACvOneShotTimer1MicroSec(priv->PortOffset,
+							  (priv->vif->bss_conf.beacon_int - MAKE_BEACON_RESERVED) << 10);
 			}
 
 			/* TODO: adhoc PS mode */
 
 		}
 
-		if (pDevice->dwIsr & ISR_BNTX) {
-			if (pDevice->op_mode == NL80211_IFTYPE_ADHOC) {
-				pDevice->bIsBeaconBufReadySet = false;
-				pDevice->cbBeaconBufReadySetCnt = 0;
+		if (priv->dwIsr & ISR_BNTX) {
+			if (priv->op_mode == NL80211_IFTYPE_ADHOC) {
+				priv->bIsBeaconBufReadySet = false;
+				priv->cbBeaconBufReadySetCnt = 0;
 			}
 
-			pDevice->bBeaconSent = true;
+			priv->bBeaconSent = true;
 		}
 
-		if (pDevice->dwIsr & ISR_RXDMA0)
-			max_count += device_rx_srv(pDevice, TYPE_RXDMA0);
+		if (priv->dwIsr & ISR_RXDMA0)
+			max_count += device_rx_srv(priv, TYPE_RXDMA0);
 
-		if (pDevice->dwIsr & ISR_RXDMA1)
-			max_count += device_rx_srv(pDevice, TYPE_RXDMA1);
+		if (priv->dwIsr & ISR_RXDMA1)
+			max_count += device_rx_srv(priv, TYPE_RXDMA1);
 
-		if (pDevice->dwIsr & ISR_TXDMA0)
-			max_count += device_tx_srv(pDevice, TYPE_TXDMA0);
+		if (priv->dwIsr & ISR_TXDMA0)
+			max_count += device_tx_srv(priv, TYPE_TXDMA0);
 
-		if (pDevice->dwIsr & ISR_AC0DMA)
-			max_count += device_tx_srv(pDevice, TYPE_AC0DMA);
+		if (priv->dwIsr & ISR_AC0DMA)
+			max_count += device_tx_srv(priv, TYPE_AC0DMA);
 
-		if (pDevice->dwIsr & ISR_SOFTTIMER1) {
-			if (pDevice->vif->bss_conf.enable_beacon)
-				vnt_beacon_make(pDevice, pDevice->vif);
+		if (priv->dwIsr & ISR_SOFTTIMER1) {
+			if (priv->vif->bss_conf.enable_beacon)
+				vnt_beacon_make(priv, priv->vif);
 		}
 
 		/* If both buffers available wake the queue */
-		if (AVAIL_TD(pDevice, TYPE_TXDMA0) &&
-		    AVAIL_TD(pDevice, TYPE_AC0DMA) &&
-		    ieee80211_queue_stopped(pDevice->hw, 0))
-			ieee80211_wake_queues(pDevice->hw);
+		if (AVAIL_TD(priv, TYPE_TXDMA0) &&
+		    AVAIL_TD(priv, TYPE_AC0DMA) &&
+		    ieee80211_queue_stopped(priv->hw, 0))
+			ieee80211_wake_queues(priv->hw);
 
-		MACvReadISR(pDevice->PortOffset, &pDevice->dwIsr);
+		MACvReadISR(priv->PortOffset, &priv->dwIsr);
 
-		MACvReceive0(pDevice->PortOffset);
-		MACvReceive1(pDevice->PortOffset);
+		MACvReceive0(priv->PortOffset);
+		MACvReceive1(priv->PortOffset);
 
-		if (max_count > pDevice->sOpts.int_works)
+		if (max_count > priv->sOpts.int_works)
 			break;
 	}
 
-	spin_unlock_irqrestore(&pDevice->lock, flags);
+	spin_unlock_irqrestore(&priv->lock, flags);
 
-	MACvIntEnable(pDevice->PortOffset, IMR_MASK_VALUE);
+	MACvIntEnable(priv->PortOffset, IMR_MASK_VALUE);
 }
 
 static void vnt_interrupt_work(struct work_struct *work)
-- 
2.1.4

