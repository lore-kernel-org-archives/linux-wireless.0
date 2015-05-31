Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:36371 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758167AbbEaJgJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 May 2015 05:36:09 -0400
Received: by wgbgq6 with SMTP id gq6so92646832wgb.3
        for <linux-wireless@vger.kernel.org>; Sun, 31 May 2015 02:36:07 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 8/9] staging: vt6655: replace and resize dwIsr
Date: Sun, 31 May 2015 10:35:27 +0100
Message-Id: <1433064928-2139-8-git-send-email-tvboxspy@gmail.com> (sfid-20150531_113617_717388_17B58902)
In-Reply-To: <1433064928-2139-1-git-send-email-tvboxspy@gmail.com>
References: <1433064928-2139-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

dwIsr is not used outside vnt_interrupt_process and should
be u32.

Move to function and resize to u32.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device.h      |  1 -
 drivers/staging/vt6655/device_main.c | 33 +++++++++++++++++----------------
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index b928c2a..5cf1b33 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -238,7 +238,6 @@ struct vnt_private {
 	CHIP_TYPE                   chip_id;
 
 	void __iomem                *PortOffset;
-	unsigned long dwIsr;
 	u32                         memaddr;
 	u32                         ioaddr;
 	u32                         io_size;
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 575ba87..aec3cce 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -1056,15 +1056,16 @@ static void vnt_interrupt_process(struct vnt_private *priv)
 	struct ieee80211_low_level_stats *low_stats = &priv->low_stats;
 	int             max_count = 0;
 	u32 mib_counter;
+	u32 isr;
 	unsigned long flags;
 
-	MACvReadISR(priv->PortOffset, &priv->dwIsr);
+	MACvReadISR(priv->PortOffset, &isr);
 
-	if (priv->dwIsr == 0)
+	if (isr == 0)
 		return;
 
-	if (priv->dwIsr == 0xffffffff) {
-		pr_debug("dwIsr = 0xffff\n");
+	if (isr == 0xffffffff) {
+		pr_debug("isr = 0xffff\n");
 		return;
 	}
 
@@ -1086,18 +1087,18 @@ static void vnt_interrupt_process(struct vnt_private *priv)
 	 * than RD/TD write back
 	 * update ISR counter
 	 */
-	while (priv->dwIsr && priv->vif) {
-		MACvWriteISR(priv->PortOffset, priv->dwIsr);
+	while (isr && priv->vif) {
+		MACvWriteISR(priv->PortOffset, isr);
 
-		if (priv->dwIsr & ISR_FETALERR) {
+		if (isr & ISR_FETALERR) {
 			pr_debug(" ISR_FETALERR\n");
 			VNSvOutPortB(priv->PortOffset + MAC_REG_SOFTPWRCTL, 0);
 			VNSvOutPortW(priv->PortOffset +
 				     MAC_REG_SOFTPWRCTL, SOFTPWRCTL_SWPECTI);
-			device_error(priv, priv->dwIsr);
+			device_error(priv, isr);
 		}
 
-		if (priv->dwIsr & ISR_TBTT) {
+		if (isr & ISR_TBTT) {
 			if (priv->op_mode != NL80211_IFTYPE_ADHOC)
 				vnt_check_bb_vga(priv);
 
@@ -1116,7 +1117,7 @@ static void vnt_interrupt_process(struct vnt_private *priv)
 
 		}
 
-		if (priv->dwIsr & ISR_BNTX) {
+		if (isr & ISR_BNTX) {
 			if (priv->op_mode == NL80211_IFTYPE_ADHOC) {
 				priv->bIsBeaconBufReadySet = false;
 				priv->cbBeaconBufReadySetCnt = 0;
@@ -1125,19 +1126,19 @@ static void vnt_interrupt_process(struct vnt_private *priv)
 			priv->bBeaconSent = true;
 		}
 
-		if (priv->dwIsr & ISR_RXDMA0)
+		if (isr & ISR_RXDMA0)
 			max_count += device_rx_srv(priv, TYPE_RXDMA0);
 
-		if (priv->dwIsr & ISR_RXDMA1)
+		if (isr & ISR_RXDMA1)
 			max_count += device_rx_srv(priv, TYPE_RXDMA1);
 
-		if (priv->dwIsr & ISR_TXDMA0)
+		if (isr & ISR_TXDMA0)
 			max_count += device_tx_srv(priv, TYPE_TXDMA0);
 
-		if (priv->dwIsr & ISR_AC0DMA)
+		if (isr & ISR_AC0DMA)
 			max_count += device_tx_srv(priv, TYPE_AC0DMA);
 
-		if (priv->dwIsr & ISR_SOFTTIMER1) {
+		if (isr & ISR_SOFTTIMER1) {
 			if (priv->vif->bss_conf.enable_beacon)
 				vnt_beacon_make(priv, priv->vif);
 		}
@@ -1148,7 +1149,7 @@ static void vnt_interrupt_process(struct vnt_private *priv)
 		    ieee80211_queue_stopped(priv->hw, 0))
 			ieee80211_wake_queues(priv->hw);
 
-		MACvReadISR(priv->PortOffset, &priv->dwIsr);
+		MACvReadISR(priv->PortOffset, &isr);
 
 		MACvReceive0(priv->PortOffset);
 		MACvReceive1(priv->PortOffset);
-- 
2.1.4

