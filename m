Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:41268 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab3LXFTb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Dec 2013 00:19:31 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 03/11] ath9k: Add HW callbacks for MAC/BB hang checks
Date: Tue, 24 Dec 2013 10:44:19 +0530
Message-Id: <1387862067-25457-3-git-send-email-sujith@msujith.org> (sfid-20131224_061953_598023_36C463E8)
In-Reply-To: <1387862067-25457-1-git-send-email-sujith@msujith.org>
References: <1387862067-25457-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

This is required for adding separate hang check
routines for AR9002 and AR9003.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_hw.c | 72 ++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw-ops.h    | 10 +++++
 drivers/net/wireless/ath/ath9k/hw.c        | 70 -----------------------------
 drivers/net/wireless/ath/ath9k/hw.h        |  3 ++
 4 files changed, 85 insertions(+), 70 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index f1d3c4a..75a6d85 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -892,6 +892,77 @@ static void ar9003_hw_init_hang_checks(struct ath_hw *ah)
 		ah->bb_watchdog_timeout_ms = 25;
 }
 
+static bool ath9k_hw_check_dcs(u32 dma_dbg, u32 num_dcu_states,
+			       int *hang_state, int *hang_pos)
+{
+	static u32 dcu_chain_state[] = {5, 6, 9}; /* DCU chain stuck states */
+	u32 chain_state, dcs_pos, i;
+
+	for (dcs_pos = 0; dcs_pos < num_dcu_states; dcs_pos++) {
+		chain_state = (dma_dbg >> (5 * dcs_pos)) & 0x1f;
+		for (i = 0; i < 3; i++) {
+			if (chain_state == dcu_chain_state[i]) {
+				*hang_state = chain_state;
+				*hang_pos = dcs_pos;
+				return true;
+			}
+		}
+	}
+	return false;
+}
+
+#define DCU_COMPLETE_STATE        1
+#define DCU_COMPLETE_STATE_MASK 0x3
+#define NUM_STATUS_READS         50
+
+static bool ar9003_hw_detect_mac_hang(struct ath_hw *ah)
+{
+	u32 chain_state, comp_state, dcs_reg = AR_DMADBG_4;
+	u32 i, hang_pos, hang_state, num_state = 6;
+
+	comp_state = REG_READ(ah, AR_DMADBG_6);
+
+	if ((comp_state & DCU_COMPLETE_STATE_MASK) != DCU_COMPLETE_STATE) {
+		ath_dbg(ath9k_hw_common(ah), RESET,
+			"MAC Hang signature not found at DCU complete\n");
+		return false;
+	}
+
+	chain_state = REG_READ(ah, dcs_reg);
+	if (ath9k_hw_check_dcs(chain_state, num_state, &hang_state, &hang_pos))
+		goto hang_check_iter;
+
+	dcs_reg = AR_DMADBG_5;
+	num_state = 4;
+	chain_state = REG_READ(ah, dcs_reg);
+	if (ath9k_hw_check_dcs(chain_state, num_state, &hang_state, &hang_pos))
+		goto hang_check_iter;
+
+	ath_dbg(ath9k_hw_common(ah), RESET,
+		"MAC Hang signature 1 not found\n");
+	return false;
+
+hang_check_iter:
+	ath_dbg(ath9k_hw_common(ah), RESET,
+		"DCU registers: chain %08x complete %08x Hang: state %d pos %d\n",
+		chain_state, comp_state, hang_state, hang_pos);
+
+	for (i = 0; i < NUM_STATUS_READS; i++) {
+		chain_state = REG_READ(ah, dcs_reg);
+		chain_state = (chain_state >> (5 * hang_pos)) & 0x1f;
+		comp_state = REG_READ(ah, AR_DMADBG_6);
+
+		if (((comp_state & DCU_COMPLETE_STATE_MASK) !=
+					DCU_COMPLETE_STATE) ||
+		    (chain_state != hang_state))
+			return false;
+	}
+
+	ath_dbg(ath9k_hw_common(ah), RESET, "MAC Hang signature 1 found\n");
+
+	return true;
+}
+
 /* Sets up the AR9003 hardware familiy callbacks */
 void ar9003_hw_attach_ops(struct ath_hw *ah)
 {
@@ -901,6 +972,7 @@ void ar9003_hw_attach_ops(struct ath_hw *ah)
 	ar9003_hw_init_mode_regs(ah);
 	priv_ops->init_mode_gain_regs = ar9003_hw_init_mode_gain_regs;
 	priv_ops->init_hang_checks = ar9003_hw_init_hang_checks;
+	priv_ops->detect_mac_hang = ar9003_hw_detect_mac_hang;
 
 	ops->config_pci_powersave = ar9003_hw_configpcipowersave;
 
diff --git a/drivers/net/wireless/ath/ath9k/hw-ops.h b/drivers/net/wireless/ath/ath9k/hw-ops.h
index bd95eae..0b2550a 100644
--- a/drivers/net/wireless/ath/ath9k/hw-ops.h
+++ b/drivers/net/wireless/ath/ath9k/hw-ops.h
@@ -112,6 +112,16 @@ static inline void ath9k_hw_init_hang_checks(struct ath_hw *ah)
 	ath9k_hw_private_ops(ah)->init_hang_checks(ah);
 }
 
+static inline bool ath9k_hw_detect_mac_hang(struct ath_hw *ah)
+{
+	return ath9k_hw_private_ops(ah)->detect_mac_hang(ah);
+}
+
+static inline bool ath9k_hw_detect_bb_hang(struct ath_hw *ah)
+{
+	return ath9k_hw_private_ops(ah)->detect_bb_hang(ah);
+}
+
 /* PHY ops */
 
 static inline int ath9k_hw_rf_set_freq(struct ath_hw *ah,
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index d4fb74f..7aa7835 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1529,76 +1529,6 @@ static void ath9k_hw_apply_gpio_override(struct ath_hw *ah)
 	}
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
-
-#define DCU_COMPLETE_STATE        1
-#define DCU_COMPLETE_STATE_MASK 0x3
-#define NUM_STATUS_READS         50
-static bool ath9k_hw_detect_mac_hang(struct ath_hw *ah)
-{
-	u32 chain_state, comp_state, dcs_reg = AR_DMADBG_4;
-	u32 i, hang_pos, hang_state, num_state = 6;
-
-	comp_state = REG_READ(ah, AR_DMADBG_6);
-
-	if ((comp_state & DCU_COMPLETE_STATE_MASK) != DCU_COMPLETE_STATE) {
-		ath_dbg(ath9k_hw_common(ah), RESET,
-			"MAC Hang signature not found at DCU complete\n");
-		return false;
-	}
-
-	chain_state = REG_READ(ah, dcs_reg);
-	if (ath9k_hw_check_dcs(chain_state, num_state, &hang_state, &hang_pos))
-		goto hang_check_iter;
-
-	dcs_reg = AR_DMADBG_5;
-	num_state = 4;
-	chain_state = REG_READ(ah, dcs_reg);
-	if (ath9k_hw_check_dcs(chain_state, num_state, &hang_state, &hang_pos))
-		goto hang_check_iter;
-
-	ath_dbg(ath9k_hw_common(ah), RESET,
-		"MAC Hang signature 1 not found\n");
-	return false;
-
-hang_check_iter:
-	ath_dbg(ath9k_hw_common(ah), RESET,
-		"DCU registers: chain %08x complete %08x Hang: state %d pos %d\n",
-		chain_state, comp_state, hang_state, hang_pos);
-
-	for (i = 0; i < NUM_STATUS_READS; i++) {
-		chain_state = REG_READ(ah, dcs_reg);
-		chain_state = (chain_state >> (5 * hang_pos)) & 0x1f;
-		comp_state = REG_READ(ah, AR_DMADBG_6);
-
-		if (((comp_state & DCU_COMPLETE_STATE_MASK) !=
-					DCU_COMPLETE_STATE) ||
-		    (chain_state != hang_state))
-			return false;
-	}
-
-	ath_dbg(ath9k_hw_common(ah), RESET, "MAC Hang signature 1 found\n");
-
-	return true;
-}
-
 void ath9k_hw_check_nav(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 0a3cfc5..cb930d6 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -585,6 +585,9 @@ struct ath_hw_radar_conf {
  */
 struct ath_hw_private_ops {
 	void (*init_hang_checks)(struct ath_hw *ah);
+	bool (*detect_mac_hang)(struct ath_hw *ah);
+	bool (*detect_bb_hang)(struct ath_hw *ah);
+
 	/* Calibration ops */
 	void (*init_cal_settings)(struct ath_hw *ah);
 	bool (*init_cal)(struct ath_hw *ah, struct ath9k_channel *chan);
-- 
1.8.5.2

