Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:48591 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728Ab3CDHOd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 02:14:33 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/4] ath9k_hw: Use helper functions to simplify HW reset
Date: Mon,  4 Mar 2013 12:42:53 +0530
Message-Id: <1362381175-9634-2-git-send-email-sujith@msujith.org> (sfid-20130304_081443_103764_FC038EDD)
In-Reply-To: <1362381175-9634-1-git-send-email-sujith@msujith.org>
References: <1362381175-9634-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c | 182 ++++++++++++++++++++----------------
 1 file changed, 103 insertions(+), 79 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index fd4b7c5..47c073c 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1669,6 +1669,104 @@ bool ath9k_hw_check_alive(struct ath_hw *ah)
 }
 EXPORT_SYMBOL(ath9k_hw_check_alive);
 
+static void ath9k_hw_init_mfp(struct ath_hw *ah)
+{
+	/* Setup MFP options for CCMP */
+	if (AR_SREV_9280_20_OR_LATER(ah)) {
+		/* Mask Retry(b11), PwrMgt(b12), MoreData(b13) to 0 in mgmt
+		 * frames when constructing CCMP AAD. */
+		REG_RMW_FIELD(ah, AR_AES_MUTE_MASK1, AR_AES_MUTE_MASK1_FC_MGMT,
+			      0xc7ff);
+		ah->sw_mgmt_crypto = false;
+	} else if (AR_SREV_9160_10_OR_LATER(ah)) {
+		/* Disable hardware crypto for management frames */
+		REG_CLR_BIT(ah, AR_PCU_MISC_MODE2,
+			    AR_PCU_MISC_MODE2_MGMT_CRYPTO_ENABLE);
+		REG_SET_BIT(ah, AR_PCU_MISC_MODE2,
+			    AR_PCU_MISC_MODE2_NO_CRYPTO_FOR_NON_DATA_PKT);
+		ah->sw_mgmt_crypto = true;
+	} else {
+		ah->sw_mgmt_crypto = true;
+	}
+}
+
+static void ath9k_hw_reset_opmode(struct ath_hw *ah,
+				  u32 macStaId1, u32 saveDefAntenna)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	ENABLE_REGWRITE_BUFFER(ah);
+
+	REG_WRITE(ah, AR_STA_ID0, get_unaligned_le32(common->macaddr));
+	REG_WRITE(ah, AR_STA_ID1, get_unaligned_le16(common->macaddr + 4)
+		  | macStaId1
+		  | AR_STA_ID1_RTS_USE_DEF
+		  | (ah->config.ack_6mb ? AR_STA_ID1_ACKCTS_6MB : 0)
+		  | ah->sta_id1_defaults);
+	ath_hw_setbssidmask(common);
+	REG_WRITE(ah, AR_DEF_ANTENNA, saveDefAntenna);
+	ath9k_hw_write_associd(ah);
+	REG_WRITE(ah, AR_ISR, ~0);
+	REG_WRITE(ah, AR_RSSI_THR, INIT_RSSI_THR);
+
+	REGWRITE_BUFFER_FLUSH(ah);
+
+	ath9k_hw_set_operating_mode(ah, ah->opmode);
+}
+
+static void ath9k_hw_init_queues(struct ath_hw *ah)
+{
+	int i;
+
+	ENABLE_REGWRITE_BUFFER(ah);
+
+	for (i = 0; i < AR_NUM_DCU; i++)
+		REG_WRITE(ah, AR_DQCUMASK(i), 1 << i);
+
+	REGWRITE_BUFFER_FLUSH(ah);
+
+	ah->intr_txqs = 0;
+	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++)
+		ath9k_hw_resettxqueue(ah, i);
+}
+
+/*
+ * For big endian systems turn on swapping for descriptors
+ */
+static void ath9k_hw_init_desc(struct ath_hw *ah)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	if (AR_SREV_9100(ah)) {
+		u32 mask;
+		mask = REG_READ(ah, AR_CFG);
+		if (mask & (AR_CFG_SWRB | AR_CFG_SWTB | AR_CFG_SWRG)) {
+			ath_dbg(common, RESET, "CFG Byte Swap Set 0x%x\n",
+				mask);
+		} else {
+			mask = INIT_CONFIG_STATUS | AR_CFG_SWRB | AR_CFG_SWTB;
+			REG_WRITE(ah, AR_CFG, mask);
+			ath_dbg(common, RESET, "Setting CFG 0x%x\n",
+				REG_READ(ah, AR_CFG));
+		}
+	} else {
+		if (common->bus_ops->ath_bus_type == ATH_USB) {
+			/* Configure AR9271 target WLAN */
+			if (AR_SREV_9271(ah))
+				REG_WRITE(ah, AR_CFG, AR_CFG_SWRB | AR_CFG_SWTB);
+			else
+				REG_WRITE(ah, AR_CFG, AR_CFG_SWTD | AR_CFG_SWRD);
+		}
+#ifdef __BIG_ENDIAN
+		else if (AR_SREV_9330(ah) || AR_SREV_9340(ah) ||
+			 AR_SREV_9550(ah))
+			REG_RMW(ah, AR_CFG, AR_CFG_SWRB | AR_CFG_SWTB, 0);
+		else
+			REG_WRITE(ah, AR_CFG, AR_CFG_SWTD | AR_CFG_SWRD);
+#endif
+	}
+}
+
 /*
  * Fast channel change:
  * (Change synthesizer based on channel freq without resetting chip)
@@ -1746,7 +1844,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	u32 saveDefAntenna;
 	u32 macStaId1;
 	u64 tsf = 0;
-	int i, r;
+	int r;
 	bool start_mci_reset = false;
 	bool save_fullsleep = ah->chip_fullsleep;
 
@@ -1851,22 +1949,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 		ath9k_hw_settsf64(ah, tsf);
 	}
 
-	/* Setup MFP options for CCMP */
-	if (AR_SREV_9280_20_OR_LATER(ah)) {
-		/* Mask Retry(b11), PwrMgt(b12), MoreData(b13) to 0 in mgmt
-		 * frames when constructing CCMP AAD. */
-		REG_RMW_FIELD(ah, AR_AES_MUTE_MASK1, AR_AES_MUTE_MASK1_FC_MGMT,
-			      0xc7ff);
-		ah->sw_mgmt_crypto = false;
-	} else if (AR_SREV_9160_10_OR_LATER(ah)) {
-		/* Disable hardware crypto for management frames */
-		REG_CLR_BIT(ah, AR_PCU_MISC_MODE2,
-			    AR_PCU_MISC_MODE2_MGMT_CRYPTO_ENABLE);
-		REG_SET_BIT(ah, AR_PCU_MISC_MODE2,
-			    AR_PCU_MISC_MODE2_NO_CRYPTO_FOR_NON_DATA_PKT);
-		ah->sw_mgmt_crypto = true;
-	} else
-		ah->sw_mgmt_crypto = true;
+	ath9k_hw_init_mfp(ah);
 
 	if (IS_CHAN_OFDM(chan) || IS_CHAN_HT(chan))
 		ath9k_hw_set_delta_slope(ah, chan);
@@ -1874,24 +1957,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	ath9k_hw_spur_mitigate_freq(ah, chan);
 	ah->eep_ops->set_board_values(ah, chan);
 
-	ENABLE_REGWRITE_BUFFER(ah);
-
-	REG_WRITE(ah, AR_STA_ID0, get_unaligned_le32(common->macaddr));
-	REG_WRITE(ah, AR_STA_ID1, get_unaligned_le16(common->macaddr + 4)
-		  | macStaId1
-		  | AR_STA_ID1_RTS_USE_DEF
-		  | (ah->config.
-		     ack_6mb ? AR_STA_ID1_ACKCTS_6MB : 0)
-		  | ah->sta_id1_defaults);
-	ath_hw_setbssidmask(common);
-	REG_WRITE(ah, AR_DEF_ANTENNA, saveDefAntenna);
-	ath9k_hw_write_associd(ah);
-	REG_WRITE(ah, AR_ISR, ~0);
-	REG_WRITE(ah, AR_RSSI_THR, INIT_RSSI_THR);
-
-	REGWRITE_BUFFER_FLUSH(ah);
-
-	ath9k_hw_set_operating_mode(ah, ah->opmode);
+	ath9k_hw_reset_opmode(ah, macStaId1, saveDefAntenna);
 
 	r = ath9k_hw_rf_set_freq(ah, chan);
 	if (r)
@@ -1899,17 +1965,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 
 	ath9k_hw_set_clockrate(ah);
 
-	ENABLE_REGWRITE_BUFFER(ah);
-
-	for (i = 0; i < AR_NUM_DCU; i++)
-		REG_WRITE(ah, AR_DQCUMASK(i), 1 << i);
-
-	REGWRITE_BUFFER_FLUSH(ah);
-
-	ah->intr_txqs = 0;
-	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++)
-		ath9k_hw_resettxqueue(ah, i);
-
+	ath9k_hw_init_queues(ah);
 	ath9k_hw_init_interrupt_masks(ah, ah->opmode);
 	ath9k_hw_ani_cache_ini_regs(ah);
 	ath9k_hw_init_qos(ah);
@@ -1964,38 +2020,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 
 	REGWRITE_BUFFER_FLUSH(ah);
 
-	/*
-	 * For big endian systems turn on swapping for descriptors
-	 */
-	if (AR_SREV_9100(ah)) {
-		u32 mask;
-		mask = REG_READ(ah, AR_CFG);
-		if (mask & (AR_CFG_SWRB | AR_CFG_SWTB | AR_CFG_SWRG)) {
-			ath_dbg(common, RESET, "CFG Byte Swap Set 0x%x\n",
-				mask);
-		} else {
-			mask =
-				INIT_CONFIG_STATUS | AR_CFG_SWRB | AR_CFG_SWTB;
-			REG_WRITE(ah, AR_CFG, mask);
-			ath_dbg(common, RESET, "Setting CFG 0x%x\n",
-				REG_READ(ah, AR_CFG));
-		}
-	} else {
-		if (common->bus_ops->ath_bus_type == ATH_USB) {
-			/* Configure AR9271 target WLAN */
-			if (AR_SREV_9271(ah))
-				REG_WRITE(ah, AR_CFG, AR_CFG_SWRB | AR_CFG_SWTB);
-			else
-				REG_WRITE(ah, AR_CFG, AR_CFG_SWTD | AR_CFG_SWRD);
-		}
-#ifdef __BIG_ENDIAN
-		else if (AR_SREV_9330(ah) || AR_SREV_9340(ah) ||
-			 AR_SREV_9550(ah))
-			REG_RMW(ah, AR_CFG, AR_CFG_SWRB | AR_CFG_SWTB, 0);
-		else
-			REG_WRITE(ah, AR_CFG, AR_CFG_SWTD | AR_CFG_SWRD);
-#endif
-	}
+	ath9k_hw_init_desc(ah);
 
 	if (ath9k_hw_btcoex_is_enabled(ah))
 		ath9k_hw_btcoex_enable(ah);
@@ -2008,7 +2033,6 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 
 	if (AR_SREV_9300_20_OR_LATER(ah)) {
 		ar9003_hw_bb_watchdog_config(ah);
-
 		ar9003_hw_disable_phy_restart(ah);
 	}
 
-- 
1.8.1.5

