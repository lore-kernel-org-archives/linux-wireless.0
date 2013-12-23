Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:53744 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab3LWHTa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Dec 2013 02:19:30 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org
Subject: [RFC 4/9] ath9k: Fix MAC HW hang check for AR9003
Date: Mon, 23 Dec 2013 12:44:21 +0530
Message-Id: <1387782866-19847-5-git-send-email-sujith@msujith.org> (sfid-20131223_081935_957589_3055787B)
In-Reply-To: <1387782866-19847-1-git-send-email-sujith@msujith.org>
References: <1387782866-19847-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The current method of identifying MAC hangs is
convoluted and also, the signatures are wrong and
don't apply to all the chips in the AR9003 family.
Fix this by cleaning up the code and checking for
the correct hang signatures.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_hw.c | 130 +++++++++++++++++------------
 1 file changed, 75 insertions(+), 55 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index 75a6d85..f3c4102 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -892,75 +892,95 @@ static void ar9003_hw_init_hang_checks(struct ath_hw *ah)
 		ah->bb_watchdog_timeout_ms = 25;
 }
 
-static bool ath9k_hw_check_dcs(u32 dma_dbg, u32 num_dcu_states,
-			       int *hang_state, int *hang_pos)
-{
-	static u32 dcu_chain_state[] = {5, 6, 9}; /* DCU chain stuck states */
-	u32 chain_state, dcs_pos, i;
-
-	for (dcs_pos = 0; dcs_pos < num_dcu_states; dcs_pos++) {
-		chain_state = (dma_dbg >> (5 * dcs_pos)) & 0x1f;
-		for (i = 0; i < 3; i++) {
-			if (chain_state == dcu_chain_state[i]) {
-				*hang_state = chain_state;
-				*hang_pos = dcs_pos;
-				return true;
-			}
-		}
-	}
-	return false;
-}
+/*
+ * MAC HW hang check
+ * =================
+ *
+ * Signature: dcu_chain_state is 0x6 and dcu_complete_state is 0x1.
+ *
+ * The state of each DCU chain (mapped to TX queues) is available from these
+ * DMA debug registers:
+ *
+ * Chain 0 state : Bits 4:0   of AR_DMADBG_4
+ * Chain 1 state : Bits 9:5   of AR_DMADBG_4
+ * Chain 2 state : Bits 14:10 of AR_DMADBG_4
+ * Chain 3 state : Bits 19:15 of AR_DMADBG_4
+ * Chain 4 state : Bits 24:20 of AR_DMADBG_4
+ * Chain 5 state : Bits 29:25 of AR_DMADBG_4
+ * Chain 6 state : Bits 4:0   of AR_DMADBG_5
+ * Chain 7 state : Bits 9:5   of AR_DMADBG_5
+ * Chain 8 state : Bits 14:10 of AR_DMADBG_5
+ * Chain 9 state : Bits 19:15 of AR_DMADBG_5
+ *
+ * The DCU chain state "0x6" means "WAIT_FRDONE" - wait for TX frame to be done.
+ */
 
-#define DCU_COMPLETE_STATE        1
-#define DCU_COMPLETE_STATE_MASK 0x3
-#define NUM_STATUS_READS         50
+#define NUM_STATUS_READS 50
 
-static bool ar9003_hw_detect_mac_hang(struct ath_hw *ah)
+static bool ath9k_hw_verify_hang(struct ath_hw *ah, unsigned int queue)
 {
-	u32 chain_state, comp_state, dcs_reg = AR_DMADBG_4;
-	u32 i, hang_pos, hang_state, num_state = 6;
+	u32 dma_dbg_chain, dma_dbg_complete;
+	u8 dcu_chain_state, dcu_complete_state;
+	int i;
 
-	comp_state = REG_READ(ah, AR_DMADBG_6);
+	for (i = 0; i < NUM_STATUS_READS; i++) {
+		if (queue < 6)
+			dma_dbg_chain = REG_READ(ah, AR_DMADBG_4);
+		else
+			dma_dbg_chain = REG_READ(ah, AR_DMADBG_5);
 
-	if ((comp_state & DCU_COMPLETE_STATE_MASK) != DCU_COMPLETE_STATE) {
-		ath_dbg(ath9k_hw_common(ah), RESET,
-			"MAC Hang signature not found at DCU complete\n");
-		return false;
-	}
+		dma_dbg_complete = REG_READ(ah, AR_DMADBG_6);
 
-	chain_state = REG_READ(ah, dcs_reg);
-	if (ath9k_hw_check_dcs(chain_state, num_state, &hang_state, &hang_pos))
-		goto hang_check_iter;
+		dcu_chain_state = (dma_dbg_chain >> (5 * queue)) & 0x1f;
+		dcu_complete_state = dma_dbg_complete & 0x3;
 
-	dcs_reg = AR_DMADBG_5;
-	num_state = 4;
-	chain_state = REG_READ(ah, dcs_reg);
-	if (ath9k_hw_check_dcs(chain_state, num_state, &hang_state, &hang_pos))
-		goto hang_check_iter;
+		if ((dcu_chain_state != 0x6) || (dcu_complete_state != 0x1))
+			return false;
+	}
 
 	ath_dbg(ath9k_hw_common(ah), RESET,
-		"MAC Hang signature 1 not found\n");
-	return false;
+		"MAC Hang signature found for queue: %d\n", queue);
 
-hang_check_iter:
-	ath_dbg(ath9k_hw_common(ah), RESET,
-		"DCU registers: chain %08x complete %08x Hang: state %d pos %d\n",
-		chain_state, comp_state, hang_state, hang_pos);
+	return true;
+}
 
-	for (i = 0; i < NUM_STATUS_READS; i++) {
-		chain_state = REG_READ(ah, dcs_reg);
-		chain_state = (chain_state >> (5 * hang_pos)) & 0x1f;
-		comp_state = REG_READ(ah, AR_DMADBG_6);
+static bool ar9003_hw_detect_mac_hang(struct ath_hw *ah)
+{
+	u32 dma_dbg_4, dma_dbg_5, dma_dbg_6, chk_dbg;
+	u8 dcu_chain_state, dcu_complete_state;
+	bool dcu_wait_frdone = false;
+	unsigned long chk_dcu = 0;
+	unsigned int i = 0;
+
+	dma_dbg_4 = REG_READ(ah, AR_DMADBG_4);
+	dma_dbg_5 = REG_READ(ah, AR_DMADBG_5);
+	dma_dbg_6 = REG_READ(ah, AR_DMADBG_6);
+
+	dcu_complete_state = dma_dbg_6 & 0x3;
+	if (dcu_complete_state != 0x1)
+		goto exit;
+
+	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
+		if (i < 6)
+			chk_dbg = dma_dbg_4;
+		else
+			chk_dbg = dma_dbg_5;
 
-		if (((comp_state & DCU_COMPLETE_STATE_MASK) !=
-					DCU_COMPLETE_STATE) ||
-		    (chain_state != hang_state))
-			return false;
+		dcu_chain_state = (chk_dbg >> (5 * i)) & 0x1f;
+		if (dcu_chain_state == 0x6) {
+			dcu_wait_frdone = true;
+			chk_dcu |= BIT(i);
+		}
 	}
 
-	ath_dbg(ath9k_hw_common(ah), RESET, "MAC Hang signature 1 found\n");
-
-	return true;
+	if ((dcu_complete_state == 0x1) && dcu_wait_frdone) {
+		for_each_set_bit(i, &chk_dcu, ATH9K_NUM_TX_QUEUES) {
+			if (ath9k_hw_verify_hang(ah, i))
+				return true;
+		}
+	}
+exit:
+	return false;
 }
 
 /* Sets up the AR9003 hardware familiy callbacks */
-- 
1.8.5.2

