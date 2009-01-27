Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:22933 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328AbZA0JkP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2009 04:40:15 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 27 Jan 2009 01:40:15 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18814.54694.118398.164348@gargle.gargle.HOWL> (sfid-20090127_104020_562638_04D2E36F)
Date: Tue, 27 Jan 2009 15:06:38 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH] ath9k: Fix bug in TX DMA termination
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing the module was slow because ath9k_hw_stopdma()
was looping for a long time quantum. Use reasonable
values now to fix this issue.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/mac.c |   31 +++++++++++++++++++++++++------
 1 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath9k/mac.c b/drivers/net/wireless/ath9k/mac.c
index af32d09..ef832a5 100644
--- a/drivers/net/wireless/ath9k/mac.c
+++ b/drivers/net/wireless/ath9k/mac.c
@@ -107,14 +107,32 @@ bool ath9k_hw_updatetxtriglevel(struct ath_hal *ah, bool bIncTrigLevel)
 
 bool ath9k_hw_stoptxdma(struct ath_hal *ah, u32 q)
 {
+#define ATH9K_TX_STOP_DMA_TIMEOUT	4000    /* usec */
+#define ATH9K_TIME_QUANTUM		100     /* usec */
+
+	struct ath_hal_5416 *ahp = AH5416(ah);
+	struct ath9k_hw_capabilities *pCap = &ah->ah_caps;
+	struct ath9k_tx_queue_info *qi;
 	u32 tsfLow, j, wait;
+	u32 wait_time = ATH9K_TX_STOP_DMA_TIMEOUT / ATH9K_TIME_QUANTUM;
+
+	if (q >= pCap->total_queues) {
+		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "invalid queue num %u\n", q);
+		return false;
+	}
+
+	qi = &ahp->ah_txq[q];
+	if (qi->tqi_type == ATH9K_TX_QUEUE_INACTIVE) {
+		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "inactive queue\n");
+		return false;
+	}
 
 	REG_WRITE(ah, AR_Q_TXD, 1 << q);
 
-	for (wait = 1000; wait != 0; wait--) {
+	for (wait = wait_time; wait != 0; wait--) {
 		if (ath9k_hw_numtxpending(ah, q) == 0)
 			break;
-		udelay(100);
+		udelay(ATH9K_TIME_QUANTUM);
 	}
 
 	if (ath9k_hw_numtxpending(ah, q)) {
@@ -144,8 +162,7 @@ bool ath9k_hw_stoptxdma(struct ath_hal *ah, u32 q)
 		udelay(200);
 		REG_CLR_BIT(ah, AR_TIMER_MODE, AR_QUIET_TIMER_EN);
 
-		wait = 1000;
-
+		wait = wait_time;
 		while (ath9k_hw_numtxpending(ah, q)) {
 			if ((--wait) == 0) {
 				DPRINTF(ah->ah_sc, ATH_DBG_XMIT,
@@ -153,15 +170,17 @@ bool ath9k_hw_stoptxdma(struct ath_hal *ah, u32 q)
 					"msec after killing last frame\n");
 				break;
 			}
-			udelay(100);
+			udelay(ATH9K_TIME_QUANTUM);
 		}
 
 		REG_CLR_BIT(ah, AR_DIAG_SW, AR_DIAG_FORCE_CH_IDLE_HIGH);
 	}
 
 	REG_WRITE(ah, AR_Q_TXD, 0);
-
 	return wait != 0;
+
+#undef ATH9K_TX_STOP_DMA_TIMEOUT
+#undef ATH9K_TIME_QUANTUM
 }
 
 bool ath9k_hw_filltxdesc(struct ath_hal *ah, struct ath_desc *ds,
-- 
1.6.1

