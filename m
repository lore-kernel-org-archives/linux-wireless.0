Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:60839 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab3LXFTb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Dec 2013 00:19:31 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 02/11] ath9k: Register supported HW hang checks
Date: Tue, 24 Dec 2013 10:44:18 +0530
Message-Id: <1387862067-25457-2-git-send-email-sujith@msujith.org> (sfid-20131224_063435_491966_E2FC446A)
In-Reply-To: <1387862067-25457-1-git-send-email-sujith@msujith.org>
References: <1387862067-25457-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

HW hang checks have to be done on a per-chip basis.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9002_hw.c | 15 +++++++++++++++
 drivers/net/wireless/ath/ath9k/ar9003_hw.c | 21 +++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw-ops.h    |  5 +++++
 drivers/net/wireless/ath/ath9k/hw.c        |  5 +----
 drivers/net/wireless/ath/ath9k/hw.h        | 22 +++++++++++++++++-----
 5 files changed, 59 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_hw.c b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
index 149aba3..d480d2f 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
@@ -383,6 +383,20 @@ void ar9002_hw_enable_async_fifo(struct ath_hw *ah)
 	}
 }
 
+static void ar9002_hw_init_hang_checks(struct ath_hw *ah)
+{
+	if (AR_SREV_9100(ah) || AR_SREV_9160(ah)) {
+		ah->config.hw_hang_checks |= HW_BB_RIFS_HANG;
+		ah->config.hw_hang_checks |= HW_BB_DFS_HANG;
+	}
+
+	if (AR_SREV_9280(ah))
+		ah->config.hw_hang_checks |= HW_BB_RX_CLEAR_STUCK_HANG;
+
+	if (AR_SREV_5416(ah) || AR_SREV_9100(ah) || AR_SREV_9160(ah))
+		ah->config.hw_hang_checks |= HW_MAC_HANG;
+}
+
 /* Sets up the AR5008/AR9001/AR9002 hardware familiy callbacks */
 int ar9002_hw_attach_ops(struct ath_hw *ah)
 {
@@ -395,6 +409,7 @@ int ar9002_hw_attach_ops(struct ath_hw *ah)
 		return ret;
 
 	priv_ops->init_mode_gain_regs = ar9002_hw_init_mode_gain_regs;
+	priv_ops->init_hang_checks = ar9002_hw_init_hang_checks;
 
 	ops->config_pci_powersave = ar9002_hw_configpcipowersave;
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index 29613eb..f1d3c4a 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -872,6 +872,26 @@ static void ar9003_hw_configpcipowersave(struct ath_hw *ah,
 	}
 }
 
+static void ar9003_hw_init_hang_checks(struct ath_hw *ah)
+{
+	/*
+	 * All chips support detection of BB/MAC hangs.
+	 */
+	ah->config.hw_hang_checks |= HW_BB_WATCHDOG;
+	ah->config.hw_hang_checks |= HW_MAC_HANG;
+
+	/*
+	 * This is not required for AR9580 1.0
+	 */
+	if (AR_SREV_9300_22(ah))
+		ah->config.hw_hang_checks |= HW_PHYRESTART_CLC_WAR;
+
+	if (AR_SREV_9330(ah))
+		ah->bb_watchdog_timeout_ms = 85;
+	else
+		ah->bb_watchdog_timeout_ms = 25;
+}
+
 /* Sets up the AR9003 hardware familiy callbacks */
 void ar9003_hw_attach_ops(struct ath_hw *ah)
 {
@@ -880,6 +900,7 @@ void ar9003_hw_attach_ops(struct ath_hw *ah)
 
 	ar9003_hw_init_mode_regs(ah);
 	priv_ops->init_mode_gain_regs = ar9003_hw_init_mode_gain_regs;
+	priv_ops->init_hang_checks = ar9003_hw_init_hang_checks;
 
 	ops->config_pci_powersave = ar9003_hw_configpcipowersave;
 
diff --git a/drivers/net/wireless/ath/ath9k/hw-ops.h b/drivers/net/wireless/ath/ath9k/hw-ops.h
index cc58a8e..bd95eae 100644
--- a/drivers/net/wireless/ath/ath9k/hw-ops.h
+++ b/drivers/net/wireless/ath/ath9k/hw-ops.h
@@ -107,6 +107,11 @@ static inline void ath9k_hw_set_bt_ant_diversity(struct ath_hw *ah, bool enable)
 
 /* Private hardware call ops */
 
+static inline void ath9k_hw_init_hang_checks(struct ath_hw *ah)
+{
+	ath9k_hw_private_ops(ah)->init_hang_checks(ah);
+}
+
 /* PHY ops */
 
 static inline int ath9k_hw_rf_set_freq(struct ath_hw *ah,
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index a4b1ae0..d4fb74f 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -636,10 +636,7 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 	else
 		ah->tx_trig_level = (AR_FTRIG_512B >> AR_FTRIG_S);
 
-	if (AR_SREV_9330(ah))
-		ah->bb_watchdog_timeout_ms = 85;
-	else
-		ah->bb_watchdog_timeout_ms = 25;
+	ath9k_hw_init_hang_checks(ah);
 
 	common->state = ATH_HW_INITIALIZED;
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 6132ffe..0a3cfc5 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -277,6 +277,21 @@ struct ath9k_hw_capabilities {
 	u8 txs_len;
 };
 
+#define AR_NO_SPUR      	0x8000
+#define AR_BASE_FREQ_2GHZ   	2300
+#define AR_BASE_FREQ_5GHZ   	4900
+#define AR_SPUR_FEEQ_BOUND_HT40 19
+#define AR_SPUR_FEEQ_BOUND_HT20 10
+
+enum ath9k_hw_hang_checks {
+	HW_BB_WATCHDOG            = BIT(0),
+	HW_PHYRESTART_CLC_WAR     = BIT(1),
+	HW_BB_RIFS_HANG           = BIT(2),
+	HW_BB_DFS_HANG            = BIT(3),
+	HW_BB_RX_CLEAR_STUCK_HANG = BIT(4),
+	HW_MAC_HANG               = BIT(5),
+};
+
 struct ath9k_ops_config {
 	int dma_beacon_response_time;
 	int sw_beacon_response_time;
@@ -292,13 +307,9 @@ struct ath9k_ops_config {
 	int serialize_regmode;
 	bool rx_intr_mitigation;
 	bool tx_intr_mitigation;
-#define AR_NO_SPUR      	0x8000
-#define AR_BASE_FREQ_2GHZ   	2300
-#define AR_BASE_FREQ_5GHZ   	4900
-#define AR_SPUR_FEEQ_BOUND_HT40 19
-#define AR_SPUR_FEEQ_BOUND_HT20 10
 	u8 max_txtrig_level;
 	u16 ani_poll_interval; /* ANI poll interval in ms */
+	u16 hw_hang_checks;
 
 	/* Platform specific config */
 	u32 aspm_l1_fix;
@@ -573,6 +584,7 @@ struct ath_hw_radar_conf {
  *	register settings through the register initialization.
  */
 struct ath_hw_private_ops {
+	void (*init_hang_checks)(struct ath_hw *ah);
 	/* Calibration ops */
 	void (*init_cal_settings)(struct ath_hw *ah);
 	bool (*init_cal)(struct ath_hw *ah, struct ath9k_channel *chan);
-- 
1.8.5.2

