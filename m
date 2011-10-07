Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:19441 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427Ab1JGLtJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Oct 2011 07:49:09 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 14/14] ath9k: Rename AR9480 into AR9462
Date: Fri, 7 Oct 2011 17:17:19 +0530
Message-ID: <1317988039-28632-14-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20111007_141655_878971_E1EAE9B5)
In-Reply-To: <1317988039-28632-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1317988039-28632-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Renamed to be in sync with Marketing term and to avoid
confusion with other chip names.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     |   18 +-
 drivers/net/wireless/ath/ath9k/ar9003_hw.c         |  182 ++++++++++----------
 drivers/net/wireless/ath/ath9k/ar9003_paprd.c      |    6 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c        |   10 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.h        |   28 ++--
 .../net/wireless/ath/ath9k/ar9462_1p0_initvals.h   |   62 ++++----
 .../net/wireless/ath/ath9k/ar9462_2p0_initvals.h   |   68 ++++----
 drivers/net/wireless/ath/ath9k/ath9k.h             |    2 +-
 drivers/net/wireless/ath/ath9k/eeprom.h            |    2 +-
 drivers/net/wireless/ath/ath9k/gpio.c              |    4 +-
 drivers/net/wireless/ath/ath9k/hw.c                |   28 ++--
 drivers/net/wireless/ath/ath9k/hw.h                |    2 +-
 drivers/net/wireless/ath/ath9k/pci.c               |    2 +-
 drivers/net/wireless/ath/ath9k/reg.h               |   28 ++--
 14 files changed, 221 insertions(+), 221 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 51398f0..9e27899 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3554,7 +3554,7 @@ static void ar9003_hw_xpa_bias_level_apply(struct ath_hw *ah, bool is2ghz)
 
 	if (AR_SREV_9485(ah) || AR_SREV_9330(ah) || AR_SREV_9340(ah))
 		REG_RMW_FIELD(ah, AR_CH0_TOP2, AR_CH0_TOP2_XPABIASLVL, bias);
-	else if (AR_SREV_9480(ah))
+	else if (AR_SREV_9462(ah))
 		REG_RMW_FIELD(ah, AR_CH0_TOP, AR_CH0_TOP_XPABIASLVL, bias);
 	else {
 		REG_RMW_FIELD(ah, AR_CH0_TOP, AR_CH0_TOP_XPABIASLVL, bias);
@@ -3633,20 +3633,20 @@ static void ar9003_hw_ant_ctrl_apply(struct ath_hw *ah, bool is2ghz)
 
 	u32 value = ar9003_hw_ant_ctrl_common_get(ah, is2ghz);
 
-	if (AR_SREV_9480(ah)) {
-		if (AR_SREV_9480_10(ah)) {
+	if (AR_SREV_9462(ah)) {
+		if (AR_SREV_9462_10(ah)) {
 			value &= ~AR_SWITCH_TABLE_COM_SPDT;
 			value |= 0x00100000;
 		}
 		REG_RMW_FIELD(ah, AR_PHY_SWITCH_COM,
-				AR_SWITCH_TABLE_COM_AR9480_ALL, value);
+				AR_SWITCH_TABLE_COM_AR9462_ALL, value);
 	} else
 		REG_RMW_FIELD(ah, AR_PHY_SWITCH_COM,
 			      AR_SWITCH_TABLE_COM_ALL, value);
 
 
 	/*
-	 *   AR9480 defines new switch table for BT/WLAN,
+	 *   AR9462 defines new switch table for BT/WLAN,
 	 *       here's new field name in XXX.ref for both 2G and 5G.
 	 *   Register: [GLB_CONTROL] GLB_CONTROL (@0x20044)
 	 *   15:12   R/W     SWITCH_TABLE_COM_SPDT_WLAN_RX
@@ -3658,7 +3658,7 @@ static void ar9003_hw_ant_ctrl_apply(struct ath_hw *ah, bool is2ghz)
 	 *   7:4 R/W  SWITCH_TABLE_COM_SPDT_WLAN_IDLE
 	 * SWITCH_TABLE_COM_SPDT_WLAN_IDLE
 	 */
-	if (AR_SREV_9480_20_OR_LATER(ah)) {
+	if (AR_SREV_9462_20_OR_LATER(ah)) {
 		value = ar9003_switch_com_spdt_get(ah, is2ghz);
 		REG_RMW_FIELD(ah, AR_PHY_GLB_CONTROL,
 				AR_SWITCH_TABLE_COM_SPDT_ALL, value);
@@ -3907,7 +3907,7 @@ static void ar9003_hw_internal_regulator_apply(struct ath_hw *ah)
 			REG_WRITE(ah, AR_PHY_PMU2, reg_pmu_set);
 			if (!is_pmu_set(ah, AR_PHY_PMU2, reg_pmu_set))
 				return;
-		} else if (AR_SREV_9480(ah)) {
+		} else if (AR_SREV_9462(ah)) {
 			reg_val = ath9k_hw_ar9300_get_eeprom(ah, EEP_SWREG);
 			REG_WRITE(ah, AR_PHY_PMU1, reg_val);
 		} else {
@@ -3938,7 +3938,7 @@ static void ar9003_hw_internal_regulator_apply(struct ath_hw *ah)
 			while (!REG_READ_FIELD(ah, AR_PHY_PMU2,
 						AR_PHY_PMU2_PGM))
 				udelay(10);
-		} else if (AR_SREV_9480(ah))
+		} else if (AR_SREV_9462(ah))
 			REG_RMW_FIELD(ah, AR_PHY_PMU1, AR_PHY_PMU1_PWD, 0x1);
 		else {
 			reg_val = REG_READ(ah, AR_RTC_SLEEP_CLK) |
@@ -4525,7 +4525,7 @@ static int ar9003_hw_power_control_override(struct ath_hw *ah,
 
 	REG_RMW_FIELD(ah, AR_PHY_TPC_19, AR_PHY_TPC_19_ALPHA_THERM, tempSlope);
 
-	if (AR_SREV_9480_20(ah))
+	if (AR_SREV_9462_20(ah))
 		REG_RMW_FIELD(ah, AR_PHY_TPC_19_B1,
 			      AR_PHY_TPC_19_B1_ALPHA_THERM, tempSlope);
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index 6b2a4d0..fb937ba 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -35,13 +35,13 @@
 static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
 {
 #define PCIE_PLL_ON_CREQ_DIS_L1_2P0 \
-		ar9480_pciephy_pll_on_clkreq_disable_L1_2p0
+		ar9462_pciephy_pll_on_clkreq_disable_L1_2p0
 
-#define AR9480_BB_CTX_COEFJ(x)	\
-		ar9480_##x##_baseband_core_txfir_coeff_japan_2484
+#define AR9462_BB_CTX_COEFJ(x)	\
+		ar9462_##x##_baseband_core_txfir_coeff_japan_2484
 
-#define AR9480_BBC_TXIFR_COEFFJ \
-		ar9480_2p0_baseband_core_txfir_coeff_japan_2484
+#define AR9462_BBC_TXIFR_COEFFJ \
+		ar9462_2p0_baseband_core_txfir_coeff_japan_2484
 	if (AR_SREV_9330_11(ah)) {
 		/* mac */
 		INIT_INI_ARRAY(&ah->iniMac[ATH_INI_PRE], NULL, 0, 0);
@@ -264,107 +264,107 @@ static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
 				ar9485_1_1_pcie_phy_clkreq_disable_L1,
 				ARRAY_SIZE(ar9485_1_1_pcie_phy_clkreq_disable_L1),
 				2);
-	} else if (AR_SREV_9480_10(ah)) {
+	} else if (AR_SREV_9462_10(ah)) {
 		INIT_INI_ARRAY(&ah->iniMac[ATH_INI_PRE], NULL, 0, 0);
-		INIT_INI_ARRAY(&ah->iniMac[ATH_INI_CORE], ar9480_1p0_mac_core,
-				ARRAY_SIZE(ar9480_1p0_mac_core), 2);
+		INIT_INI_ARRAY(&ah->iniMac[ATH_INI_CORE], ar9462_1p0_mac_core,
+				ARRAY_SIZE(ar9462_1p0_mac_core), 2);
 		INIT_INI_ARRAY(&ah->iniMac[ATH_INI_POST],
-				ar9480_1p0_mac_postamble,
-				ARRAY_SIZE(ar9480_1p0_mac_postamble),
+				ar9462_1p0_mac_postamble,
+				ARRAY_SIZE(ar9462_1p0_mac_postamble),
 				5);
 
 		INIT_INI_ARRAY(&ah->iniBB[ATH_INI_PRE], NULL, 0, 0);
 		INIT_INI_ARRAY(&ah->iniBB[ATH_INI_CORE],
-				ar9480_1p0_baseband_core,
-				ARRAY_SIZE(ar9480_1p0_baseband_core),
+				ar9462_1p0_baseband_core,
+				ARRAY_SIZE(ar9462_1p0_baseband_core),
 				2);
 		INIT_INI_ARRAY(&ah->iniBB[ATH_INI_POST],
-				ar9480_1p0_baseband_postamble,
-				ARRAY_SIZE(ar9480_1p0_baseband_postamble), 5);
+				ar9462_1p0_baseband_postamble,
+				ARRAY_SIZE(ar9462_1p0_baseband_postamble), 5);
 
 		INIT_INI_ARRAY(&ah->iniRadio[ATH_INI_PRE], NULL, 0, 0);
 		INIT_INI_ARRAY(&ah->iniRadio[ATH_INI_CORE],
-				ar9480_1p0_radio_core,
-				ARRAY_SIZE(ar9480_1p0_radio_core), 2);
+				ar9462_1p0_radio_core,
+				ARRAY_SIZE(ar9462_1p0_radio_core), 2);
 		INIT_INI_ARRAY(&ah->iniRadio[ATH_INI_POST],
-				ar9480_1p0_radio_postamble,
-				ARRAY_SIZE(ar9480_1p0_radio_postamble), 5);
+				ar9462_1p0_radio_postamble,
+				ARRAY_SIZE(ar9462_1p0_radio_postamble), 5);
 
 		INIT_INI_ARRAY(&ah->iniSOC[ATH_INI_PRE],
-				ar9480_1p0_soc_preamble,
-				ARRAY_SIZE(ar9480_1p0_soc_preamble), 2);
+				ar9462_1p0_soc_preamble,
+				ARRAY_SIZE(ar9462_1p0_soc_preamble), 2);
 		INIT_INI_ARRAY(&ah->iniSOC[ATH_INI_CORE], NULL, 0, 0);
 		INIT_INI_ARRAY(&ah->iniSOC[ATH_INI_POST],
-				ar9480_1p0_soc_postamble,
-				ARRAY_SIZE(ar9480_1p0_soc_postamble), 5);
+				ar9462_1p0_soc_postamble,
+				ARRAY_SIZE(ar9462_1p0_soc_postamble), 5);
 
 		INIT_INI_ARRAY(&ah->iniModesRxGain,
-				ar9480_common_rx_gain_table_1p0,
-				ARRAY_SIZE(ar9480_common_rx_gain_table_1p0), 2);
+				ar9462_common_rx_gain_table_1p0,
+				ARRAY_SIZE(ar9462_common_rx_gain_table_1p0), 2);
 
 		/* Awake -> Sleep Setting */
 		INIT_INI_ARRAY(&ah->iniPcieSerdes,
-			ar9480_pcie_phy_clkreq_disable_L1_1p0,
-			ARRAY_SIZE(ar9480_pcie_phy_clkreq_disable_L1_1p0),
+			ar9462_pcie_phy_clkreq_disable_L1_1p0,
+			ARRAY_SIZE(ar9462_pcie_phy_clkreq_disable_L1_1p0),
 			2);
 
 		/* Sleep -> Awake Setting */
 		INIT_INI_ARRAY(&ah->iniPcieSerdesLowPower,
-			ar9480_pcie_phy_clkreq_disable_L1_1p0,
-			ARRAY_SIZE(ar9480_pcie_phy_clkreq_disable_L1_1p0),
+			ar9462_pcie_phy_clkreq_disable_L1_1p0,
+			ARRAY_SIZE(ar9462_pcie_phy_clkreq_disable_L1_1p0),
 			2);
 
 		INIT_INI_ARRAY(&ah->iniModesAdditional,
-				ar9480_modes_fast_clock_1p0,
-				ARRAY_SIZE(ar9480_modes_fast_clock_1p0), 3);
+				ar9462_modes_fast_clock_1p0,
+				ARRAY_SIZE(ar9462_modes_fast_clock_1p0), 3);
 		INIT_INI_ARRAY(&ah->iniCckfirJapan2484,
-				AR9480_BB_CTX_COEFJ(1p0),
-				ARRAY_SIZE(AR9480_BB_CTX_COEFJ(1p0)), 2);
+				AR9462_BB_CTX_COEFJ(1p0),
+				ARRAY_SIZE(AR9462_BB_CTX_COEFJ(1p0)), 2);
 
-	} else if (AR_SREV_9480_20(ah)) {
+	} else if (AR_SREV_9462_20(ah)) {
 
 		INIT_INI_ARRAY(&ah->iniMac[ATH_INI_PRE], NULL, 0, 0);
-		INIT_INI_ARRAY(&ah->iniMac[ATH_INI_CORE], ar9480_2p0_mac_core,
-				ARRAY_SIZE(ar9480_2p0_mac_core), 2);
+		INIT_INI_ARRAY(&ah->iniMac[ATH_INI_CORE], ar9462_2p0_mac_core,
+				ARRAY_SIZE(ar9462_2p0_mac_core), 2);
 		INIT_INI_ARRAY(&ah->iniMac[ATH_INI_POST],
-				ar9480_2p0_mac_postamble,
-				ARRAY_SIZE(ar9480_2p0_mac_postamble), 5);
+				ar9462_2p0_mac_postamble,
+				ARRAY_SIZE(ar9462_2p0_mac_postamble), 5);
 
 		INIT_INI_ARRAY(&ah->iniBB[ATH_INI_PRE], NULL, 0, 0);
 		INIT_INI_ARRAY(&ah->iniBB[ATH_INI_CORE],
-				ar9480_2p0_baseband_core,
-				ARRAY_SIZE(ar9480_2p0_baseband_core), 2);
+				ar9462_2p0_baseband_core,
+				ARRAY_SIZE(ar9462_2p0_baseband_core), 2);
 		INIT_INI_ARRAY(&ah->iniBB[ATH_INI_POST],
-				ar9480_2p0_baseband_postamble,
-				ARRAY_SIZE(ar9480_2p0_baseband_postamble), 5);
+				ar9462_2p0_baseband_postamble,
+				ARRAY_SIZE(ar9462_2p0_baseband_postamble), 5);
 
 		INIT_INI_ARRAY(&ah->iniRadio[ATH_INI_PRE], NULL, 0, 0);
 		INIT_INI_ARRAY(&ah->iniRadio[ATH_INI_CORE],
-				ar9480_2p0_radio_core,
-				ARRAY_SIZE(ar9480_2p0_radio_core), 2);
+				ar9462_2p0_radio_core,
+				ARRAY_SIZE(ar9462_2p0_radio_core), 2);
 		INIT_INI_ARRAY(&ah->iniRadio[ATH_INI_POST],
-				ar9480_2p0_radio_postamble,
-				ARRAY_SIZE(ar9480_2p0_radio_postamble), 5);
+				ar9462_2p0_radio_postamble,
+				ARRAY_SIZE(ar9462_2p0_radio_postamble), 5);
 		INIT_INI_ARRAY(&ah->ini_radio_post_sys2ant,
-				ar9480_2p0_radio_postamble_sys2ant,
-				ARRAY_SIZE(ar9480_2p0_radio_postamble_sys2ant),
+				ar9462_2p0_radio_postamble_sys2ant,
+				ARRAY_SIZE(ar9462_2p0_radio_postamble_sys2ant),
 				5);
 
 		INIT_INI_ARRAY(&ah->iniSOC[ATH_INI_PRE],
-				ar9480_2p0_soc_preamble,
-				ARRAY_SIZE(ar9480_2p0_soc_preamble), 2);
+				ar9462_2p0_soc_preamble,
+				ARRAY_SIZE(ar9462_2p0_soc_preamble), 2);
 		INIT_INI_ARRAY(&ah->iniSOC[ATH_INI_CORE], NULL, 0, 0);
 		INIT_INI_ARRAY(&ah->iniSOC[ATH_INI_POST],
-				ar9480_2p0_soc_postamble,
-				ARRAY_SIZE(ar9480_2p0_soc_postamble), 5);
+				ar9462_2p0_soc_postamble,
+				ARRAY_SIZE(ar9462_2p0_soc_postamble), 5);
 
 		INIT_INI_ARRAY(&ah->iniModesRxGain,
-				ar9480_common_rx_gain_table_2p0,
-				ARRAY_SIZE(ar9480_common_rx_gain_table_2p0), 2);
+				ar9462_common_rx_gain_table_2p0,
+				ARRAY_SIZE(ar9462_common_rx_gain_table_2p0), 2);
 
 		INIT_INI_ARRAY(&ah->ini_BTCOEX_MAX_TXPWR,
-				ar9480_2p0_BTCOEX_MAX_TXPWR_table,
-				ARRAY_SIZE(ar9480_2p0_BTCOEX_MAX_TXPWR_table),
+				ar9462_2p0_BTCOEX_MAX_TXPWR_table,
+				ARRAY_SIZE(ar9462_2p0_BTCOEX_MAX_TXPWR_table),
 				2);
 
 		/* Awake -> Sleep Setting */
@@ -380,15 +380,15 @@ static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
 
 		/* Fast clock modal settings */
 		INIT_INI_ARRAY(&ah->iniModesAdditional,
-				ar9480_modes_fast_clock_2p0,
-				ARRAY_SIZE(ar9480_modes_fast_clock_2p0), 3);
+				ar9462_modes_fast_clock_2p0,
+				ARRAY_SIZE(ar9462_modes_fast_clock_2p0), 3);
 
 		INIT_INI_ARRAY(&ah->iniCckfirJapan2484,
-				AR9480_BB_CTX_COEFJ(2p0),
-				ARRAY_SIZE(AR9480_BB_CTX_COEFJ(2p0)), 2);
+				AR9462_BB_CTX_COEFJ(2p0),
+				ARRAY_SIZE(AR9462_BB_CTX_COEFJ(2p0)), 2);
 
-		INIT_INI_ARRAY(&ah->ini_japan2484, AR9480_BBC_TXIFR_COEFFJ,
-				ARRAY_SIZE(AR9480_BBC_TXIFR_COEFFJ), 2);
+		INIT_INI_ARRAY(&ah->ini_japan2484, AR9462_BBC_TXIFR_COEFFJ,
+				ARRAY_SIZE(AR9462_BBC_TXIFR_COEFFJ), 2);
 
 	} else if (AR_SREV_9580(ah)) {
 		/* mac */
@@ -537,15 +537,15 @@ static void ar9003_tx_gain_table_mode0(struct ath_hw *ah)
 			ar9580_1p0_lowest_ob_db_tx_gain_table,
 			ARRAY_SIZE(ar9580_1p0_lowest_ob_db_tx_gain_table),
 			5);
-	else if (AR_SREV_9480_10(ah))
+	else if (AR_SREV_9462_10(ah))
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
-			ar9480_modes_low_ob_db_tx_gain_table_1p0,
-			ARRAY_SIZE(ar9480_modes_low_ob_db_tx_gain_table_1p0),
+			ar9462_modes_low_ob_db_tx_gain_table_1p0,
+			ARRAY_SIZE(ar9462_modes_low_ob_db_tx_gain_table_1p0),
 			5);
-	else if (AR_SREV_9480_20(ah))
+	else if (AR_SREV_9462_20(ah))
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
-			ar9480_modes_low_ob_db_tx_gain_table_2p0,
-			ARRAY_SIZE(ar9480_modes_low_ob_db_tx_gain_table_2p0),
+			ar9462_modes_low_ob_db_tx_gain_table_2p0,
+			ARRAY_SIZE(ar9462_modes_low_ob_db_tx_gain_table_2p0),
 			5);
 	else
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
@@ -581,15 +581,15 @@ static void ar9003_tx_gain_table_mode1(struct ath_hw *ah)
 			ar9580_1p0_high_ob_db_tx_gain_table,
 			ARRAY_SIZE(ar9580_1p0_high_ob_db_tx_gain_table),
 			5);
-	else if (AR_SREV_9480_10(ah))
+	else if (AR_SREV_9462_10(ah))
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
-			ar9480_modes_high_ob_db_tx_gain_table_1p0,
-			ARRAY_SIZE(ar9480_modes_high_ob_db_tx_gain_table_1p0),
+			ar9462_modes_high_ob_db_tx_gain_table_1p0,
+			ARRAY_SIZE(ar9462_modes_high_ob_db_tx_gain_table_1p0),
 			5);
-	else if (AR_SREV_9480_20(ah))
+	else if (AR_SREV_9462_20(ah))
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
-			ar9480_modes_high_ob_db_tx_gain_table_2p0,
-			ARRAY_SIZE(ar9480_modes_high_ob_db_tx_gain_table_2p0),
+			ar9462_modes_high_ob_db_tx_gain_table_2p0,
+			ARRAY_SIZE(ar9462_modes_high_ob_db_tx_gain_table_2p0),
 			5);
 	else
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
@@ -712,15 +712,15 @@ static void ar9003_rx_gain_table_mode0(struct ath_hw *ah)
 				ar9580_1p0_rx_gain_table,
 				ARRAY_SIZE(ar9580_1p0_rx_gain_table),
 				2);
-	else if (AR_SREV_9480_10(ah))
+	else if (AR_SREV_9462_10(ah))
 		INIT_INI_ARRAY(&ah->iniModesRxGain,
-				ar9480_common_rx_gain_table_1p0,
-				ARRAY_SIZE(ar9480_common_rx_gain_table_1p0),
+				ar9462_common_rx_gain_table_1p0,
+				ARRAY_SIZE(ar9462_common_rx_gain_table_1p0),
 				2);
-	else if (AR_SREV_9480_20(ah))
+	else if (AR_SREV_9462_20(ah))
 		INIT_INI_ARRAY(&ah->iniModesRxGain,
-				ar9480_common_rx_gain_table_2p0,
-				ARRAY_SIZE(ar9480_common_rx_gain_table_2p0),
+				ar9462_common_rx_gain_table_2p0,
+				ARRAY_SIZE(ar9462_common_rx_gain_table_2p0),
 				2);
 	else
 		INIT_INI_ARRAY(&ah->iniModesRxGain,
@@ -751,15 +751,15 @@ static void ar9003_rx_gain_table_mode1(struct ath_hw *ah)
 			ar9485Common_wo_xlna_rx_gain_1_1,
 			ARRAY_SIZE(ar9485Common_wo_xlna_rx_gain_1_1),
 			2);
-	else if (AR_SREV_9480_10(ah))
+	else if (AR_SREV_9462_10(ah))
 		INIT_INI_ARRAY(&ah->iniModesRxGain,
-			ar9480_common_wo_xlna_rx_gain_table_1p0,
-			ARRAY_SIZE(ar9480_common_wo_xlna_rx_gain_table_1p0),
+			ar9462_common_wo_xlna_rx_gain_table_1p0,
+			ARRAY_SIZE(ar9462_common_wo_xlna_rx_gain_table_1p0),
 			2);
-	else if (AR_SREV_9480_20(ah))
+	else if (AR_SREV_9462_20(ah))
 		INIT_INI_ARRAY(&ah->iniModesRxGain,
-			ar9480_common_wo_xlna_rx_gain_table_2p0,
-			ARRAY_SIZE(ar9480_common_wo_xlna_rx_gain_table_2p0),
+			ar9462_common_wo_xlna_rx_gain_table_2p0,
+			ARRAY_SIZE(ar9462_common_wo_xlna_rx_gain_table_2p0),
 			2);
 	else if (AR_SREV_9580(ah))
 		INIT_INI_ARRAY(&ah->iniModesRxGain,
@@ -775,14 +775,14 @@ static void ar9003_rx_gain_table_mode1(struct ath_hw *ah)
 
 static void ar9003_rx_gain_table_mode2(struct ath_hw *ah)
 {
-	if (AR_SREV_9480_10(ah))
+	if (AR_SREV_9462_10(ah))
 		INIT_INI_ARRAY(&ah->iniModesRxGain,
-			ar9480_common_mixed_rx_gain_table_1p0,
-			ARRAY_SIZE(ar9480_common_mixed_rx_gain_table_1p0), 2);
-	else if (AR_SREV_9480_20(ah))
+			ar9462_common_mixed_rx_gain_table_1p0,
+			ARRAY_SIZE(ar9462_common_mixed_rx_gain_table_1p0), 2);
+	else if (AR_SREV_9462_20(ah))
 		INIT_INI_ARRAY(&ah->iniModesRxGain,
-			ar9480_common_mixed_rx_gain_table_2p0,
-			ARRAY_SIZE(ar9480_common_mixed_rx_gain_table_2p0), 2);
+			ar9462_common_mixed_rx_gain_table_2p0,
+			ARRAY_SIZE(ar9462_common_mixed_rx_gain_table_2p0), 2);
 }
 
 static void ar9003_rx_gain_table_apply(struct ath_hw *ah)
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
index 609acb2..8d788eb 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
@@ -207,7 +207,7 @@ static int ar9003_paprd_setup_single_table(struct ath_hw *ah)
 		      AR_PHY_PAPRD_TRAINER_CNTL1_CF_PAPRD_AGC2_SETTLING, 28);
 	REG_RMW_FIELD(ah, AR_PHY_PAPRD_TRAINER_CNTL1,
 		      AR_PHY_PAPRD_TRAINER_CNTL1_CF_CF_PAPRD_TRAIN_ENABLE, 1);
-	val = AR_SREV_9480(ah) ? 0x91 : 147;
+	val = AR_SREV_9462(ah) ? 0x91 : 147;
 	REG_RMW_FIELD(ah, AR_PHY_PAPRD_TRAINER_CNTL2,
 		      AR_PHY_PAPRD_TRAINER_CNTL2_CF_PAPRD_INIT_RX_BB_GAIN, val);
 	REG_RMW_FIELD(ah, AR_PHY_PAPRD_TRAINER_CNTL3,
@@ -218,7 +218,7 @@ static int ar9003_paprd_setup_single_table(struct ath_hw *ah)
 		      AR_PHY_PAPRD_TRAINER_CNTL3_CF_PAPRD_NUM_CORR_STAGES, 7);
 	REG_RMW_FIELD(ah, AR_PHY_PAPRD_TRAINER_CNTL3,
 		      AR_PHY_PAPRD_TRAINER_CNTL3_CF_PAPRD_MIN_LOOPBACK_DEL, 1);
-	if (AR_SREV_9485(ah) || AR_SREV_9480(ah))
+	if (AR_SREV_9485(ah) || AR_SREV_9462(ah))
 		REG_RMW_FIELD(ah, AR_PHY_PAPRD_TRAINER_CNTL3,
 			      AR_PHY_PAPRD_TRAINER_CNTL3_CF_PAPRD_QUICK_DROP,
 			      -3);
@@ -226,7 +226,7 @@ static int ar9003_paprd_setup_single_table(struct ath_hw *ah)
 		REG_RMW_FIELD(ah, AR_PHY_PAPRD_TRAINER_CNTL3,
 			      AR_PHY_PAPRD_TRAINER_CNTL3_CF_PAPRD_QUICK_DROP,
 			      -6);
-	val = AR_SREV_9480(ah) ? -10 : -15;
+	val = AR_SREV_9462(ah) ? -10 : -15;
 	REG_RMW_FIELD(ah, AR_PHY_PAPRD_TRAINER_CNTL3,
 		      AR_PHY_PAPRD_TRAINER_CNTL3_CF_PAPRD_ADC_DESIRED_SIZE,
 		      val);
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 3bf7c81..e97480e 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -559,7 +559,7 @@ static void ar9003_hw_set_chain_masks(struct ath_hw *ah, u8 rx, u8 tx)
 
 	if ((ah->caps.hw_caps & ATH9K_HW_CAP_APM) && (tx == 0x7))
 		REG_WRITE(ah, AR_SELFGEN_MASK, 0x3);
-	else if (AR_SREV_9480(ah))
+	else if (AR_SREV_9462(ah))
 		/* xxx only when MCI support is enabled */
 		REG_WRITE(ah, AR_SELFGEN_MASK, 0x3);
 	else
@@ -664,7 +664,7 @@ static int ar9003_hw_process_ini(struct ath_hw *ah,
 		ar9003_hw_prog_ini(ah, &ah->iniMac[i], modesIndex);
 		ar9003_hw_prog_ini(ah, &ah->iniBB[i], modesIndex);
 		ar9003_hw_prog_ini(ah, &ah->iniRadio[i], modesIndex);
-		if (i == ATH_INI_POST && AR_SREV_9480_20(ah))
+		if (i == ATH_INI_POST && AR_SREV_9462_20(ah))
 			ar9003_hw_prog_ini(ah,
 					   &ah->ini_radio_post_sys2ant,
 					   modesIndex);
@@ -687,7 +687,7 @@ static int ar9003_hw_process_ini(struct ath_hw *ah,
 	if (AR_SREV_9340(ah) && !ah->is_clk_25mhz)
 		REG_WRITE_ARRAY(&ah->iniModesAdditional_40M, 1, regWrites);
 
-	if (AR_SREV_9480(ah))
+	if (AR_SREV_9462(ah))
 		ar9003_hw_prog_ini(ah, &ah->ini_BTCOEX_MAX_TXPWR, 1);
 
 	ah->modes_index = modesIndex;
@@ -702,7 +702,7 @@ static int ar9003_hw_process_ini(struct ath_hw *ah,
 				 channel->max_power * 2,
 				 min((u32) MAX_RATE_POWER,
 				 (u32) regulatory->power_limit), false);
-	if (AR_SREV_9480(ah)) {
+	if (AR_SREV_9462(ah)) {
 		if (REG_READ_FIELD(ah, AR_PHY_TX_IQCAL_CONTROL_0,
 				AR_PHY_TX_IQCAL_CONTROL_0_ENABLE_TXIQ_CAL))
 			ah->enabled_cals |= TX_IQ_CAL;
@@ -1308,7 +1308,7 @@ static int ar9003_hw_fast_chan_change(struct ath_hw *ah,
 	ar9003_hw_prog_ini(ah, &ah->iniMac[ATH_INI_POST], modesIndex);
 	ar9003_hw_prog_ini(ah, &ah->iniBB[ATH_INI_POST], modesIndex);
 	ar9003_hw_prog_ini(ah, &ah->iniRadio[ATH_INI_POST], modesIndex);
-	if (AR_SREV_9480_20(ah))
+	if (AR_SREV_9462_20(ah))
 		ar9003_hw_prog_ini(ah,
 				&ah->ini_radio_post_sys2ant,
 				modesIndex);
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index 9fe6fbe..2f4023e 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -325,10 +325,10 @@
 
 #define AR_PHY_RX_OCGAIN        (AR_AGC_BASE + 0x200)
 
-#define AR_PHY_CCA_NOM_VAL_9300_2GHZ          (AR_SREV_9480(ah) ? -127 : -110)
-#define AR_PHY_CCA_NOM_VAL_9300_5GHZ          (AR_SREV_9480(ah) ? -127 : -115)
-#define AR_PHY_CCA_MIN_GOOD_VAL_9300_2GHZ     (AR_SREV_9480(ah) ? -127 : -125)
-#define AR_PHY_CCA_MIN_GOOD_VAL_9300_5GHZ     (AR_SREV_9480(ah) ? -127 : -125)
+#define AR_PHY_CCA_NOM_VAL_9300_2GHZ          (AR_SREV_9462(ah) ? -127 : -110)
+#define AR_PHY_CCA_NOM_VAL_9300_5GHZ          (AR_SREV_9462(ah) ? -127 : -115)
+#define AR_PHY_CCA_MIN_GOOD_VAL_9300_2GHZ     (AR_SREV_9462(ah) ? -127 : -125)
+#define AR_PHY_CCA_MIN_GOOD_VAL_9300_5GHZ     (AR_SREV_9462(ah) ? -127 : -125)
 #define AR_PHY_CCA_MAX_GOOD_VAL_9300_2GHZ     -95
 #define AR_PHY_CCA_MAX_GOOD_VAL_9300_5GHZ     -100
 
@@ -608,9 +608,9 @@
 #define AR_PHY_AIC_CTRL_1_B0	(AR_SM_BASE + 0x4b4)
 #define AR_PHY_AIC_CTRL_2_B0	(AR_SM_BASE + 0x4b8)
 #define AR_PHY_AIC_CTRL_3_B0	(AR_SM_BASE + 0x4bc)
-#define AR_PHY_AIC_STAT_0_B0	(AR_SM_BASE + (AR_SREV_9480_10(ah) ? \
+#define AR_PHY_AIC_STAT_0_B0	(AR_SM_BASE + (AR_SREV_9462_10(ah) ? \
 					0x4c0 : 0x4c4))
-#define AR_PHY_AIC_STAT_1_B0	(AR_SM_BASE + (AR_SREV_9480_10(ah) ? \
+#define AR_PHY_AIC_STAT_1_B0	(AR_SM_BASE + (AR_SREV_9462_10(ah) ? \
 					0x4c4 : 0x4c8))
 #define AR_PHY_AIC_CTRL_4_B0	(AR_SM_BASE + 0x4c0)
 #define AR_PHY_AIC_STAT_2_B0	(AR_SM_BASE + 0x4cc)
@@ -625,7 +625,7 @@
 #define AR_PHY_65NM_CH0_RXTX4       0x1610c
 
 #define AR_CH0_TOP	(AR_SREV_9300(ah) ? 0x16288 : \
-				((AR_SREV_9480(ah) ? 0x1628c : 0x16280)))
+				((AR_SREV_9462(ah) ? 0x1628c : 0x16280)))
 #define AR_CH0_TOP_XPABIASLVL (0x300)
 #define AR_CH0_TOP_XPABIASLVL_S (8)
 
@@ -638,8 +638,8 @@
 
 #define AR_SWITCH_TABLE_COM_ALL (0xffff)
 #define AR_SWITCH_TABLE_COM_ALL_S (0)
-#define AR_SWITCH_TABLE_COM_AR9480_ALL (0xffffff)
-#define AR_SWITCH_TABLE_COM_AR9480_ALL_S (0)
+#define AR_SWITCH_TABLE_COM_AR9462_ALL (0xffffff)
+#define AR_SWITCH_TABLE_COM_AR9462_ALL_S (0)
 #define AR_SWITCH_TABLE_COM_SPDT (0x00f00000)
 #define AR_SWITCH_TABLE_COM_SPDT_ALL (0x0000fff0)
 #define AR_SWITCH_TABLE_COM_SPDT_ALL_S (4)
@@ -679,11 +679,11 @@
 #define AR_CH0_XTAL_CAPOUTDAC	0x00fe0000
 #define AR_CH0_XTAL_CAPOUTDAC_S	17
 
-#define AR_PHY_PMU1		(AR_SREV_9480(ah) ? 0x16340 : 0x16c40)
+#define AR_PHY_PMU1		(AR_SREV_9462(ah) ? 0x16340 : 0x16c40)
 #define AR_PHY_PMU1_PWD		0x1
 #define AR_PHY_PMU1_PWD_S	0
 
-#define AR_PHY_PMU2		(AR_SREV_9480(ah) ? 0x16344 : 0x16c44)
+#define AR_PHY_PMU2		(AR_SREV_9462(ah) ? 0x16344 : 0x16c44)
 #define AR_PHY_PMU2_PGM		0x00200000
 #define AR_PHY_PMU2_PGM_S	21
 
@@ -921,9 +921,9 @@
 #define AR_PHY_AIC_CTRL_0_B1	(AR_SM1_BASE + 0x4b0)
 #define AR_PHY_AIC_CTRL_1_B1	(AR_SM1_BASE + 0x4b4)
 #define AR_PHY_AIC_CTRL_2_B1	(AR_SM1_BASE + 0x4b8)
-#define AR_PHY_AIC_STAT_0_B1	(AR_SM1_BASE + (AR_SREV_9480_10(ah) ? \
+#define AR_PHY_AIC_STAT_0_B1	(AR_SM1_BASE + (AR_SREV_9462_10(ah) ? \
 					0x4c0 : 0x4c4))
-#define AR_PHY_AIC_STAT_1_B1	(AR_SM1_BASE + (AR_SREV_9480_10(ah) ? \
+#define AR_PHY_AIC_STAT_1_B1	(AR_SM1_BASE + (AR_SREV_9462_10(ah) ? \
 					0x4c4 : 0x4c8))
 #define AR_PHY_AIC_CTRL_4_B1	(AR_SM1_BASE + 0x4c0)
 #define AR_PHY_AIC_STAT_2_B1	(AR_SM1_BASE + 0x4cc)
@@ -1001,7 +1001,7 @@
 #define AR_GLB_BASE	0x20000
 #define AR_PHY_GLB_CONTROL	(AR_GLB_BASE + 0x44)
 #define AR_GLB_SCRATCH(_ah)	(AR_GLB_BASE + \
-					(AR_SREV_9480_20(_ah) ? 0x4c : 0x50))
+					(AR_SREV_9462_20(_ah) ? 0x4c : 0x50))
 #define AR_GLB_STATUS		(AR_GLB_BASE + 0x48)
 
 /*
diff --git a/drivers/net/wireless/ath/ath9k/ar9462_1p0_initvals.h b/drivers/net/wireless/ath/ath9k/ar9462_1p0_initvals.h
index 4071bd2..5c55ae3 100644
--- a/drivers/net/wireless/ath/ath9k/ar9462_1p0_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9462_1p0_initvals.h
@@ -14,12 +14,12 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#ifndef INITVALS_9480_1P0_H
-#define INITVALS_9480_1P0_H
+#ifndef INITVALS_9462_1P0_H
+#define INITVALS_9462_1P0_H
 
-/* AR9480 1.0 */
+/* AR9462 1.0 */
 
-static const u32 ar9480_1p0_mac_core[][2] = {
+static const u32 ar9462_1p0_mac_core[][2] = {
 	/* Addr      allmodes  */
 	{0x00000008, 0x00000000},
 	{0x00000030, 0x00060085},
@@ -183,27 +183,27 @@ static const u32 ar9480_1p0_mac_core[][2] = {
 	{0x000083d0, 0x000301ff},
 };
 
-static const u32 ar9480_1p0_baseband_core_txfir_coeff_japan_2484[][2] = {
+static const u32 ar9462_1p0_baseband_core_txfir_coeff_japan_2484[][2] = {
 	/* Addr      allmodes  */
 	{0x0000a398, 0x00000000},
 	{0x0000a39c, 0x6f7f0301},
 	{0x0000a3a0, 0xca9228ee},
 };
 
-static const u32 ar9480_1p0_sys3ant[][2] = {
+static const u32 ar9462_1p0_sys3ant[][2] = {
 	/* Addr      allmodes  */
 	{0x00063280, 0x00040807},
 	{0x00063284, 0x104ccccc},
 };
 
-static const u32 ar9480_pcie_phy_clkreq_enable_L1_1p0[][2] = {
+static const u32 ar9462_pcie_phy_clkreq_enable_L1_1p0[][2] = {
 	/* Addr      allmodes  */
 	{0x00018c00, 0x10053e5e},
 	{0x00018c04, 0x000801d8},
 	{0x00018c08, 0x0000580c},
 };
 
-static const u32 ar9480_1p0_mac_core_emulation[][2] = {
+static const u32 ar9462_1p0_mac_core_emulation[][2] = {
 	/* Addr      allmodes  */
 	{0x00000030, 0x00060085},
 	{0x00000044, 0x00000008},
@@ -211,7 +211,7 @@ static const u32 ar9480_1p0_mac_core_emulation[][2] = {
 	{0x00008344, 0xaa4a105b},
 };
 
-static const u32 ar9480_common_rx_gain_table_ar9280_2p0_1p0[][2] = {
+static const u32 ar9462_common_rx_gain_table_ar9280_2p0_1p0[][2] = {
 	/* Addr      allmodes  */
 	{0x0000a000, 0x02000101},
 	{0x0000a004, 0x02000102},
@@ -513,7 +513,7 @@ static const u32 ar9200_ar9280_2p0_radio_core_1p0[][2] = {
 	{0x00007894, 0x5a108000},
 };
 
-static const u32 ar9480_1p0_baseband_postamble_emulation[][5] = {
+static const u32 ar9462_1p0_baseband_postamble_emulation[][5] = {
 	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
 	{0x00009e18, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 	{0x00009e3c, 0xcf946221, 0xcf946221, 0xcf946221, 0xcf946221},
@@ -535,14 +535,14 @@ static const u32 ar9480_1p0_baseband_postamble_emulation[][5] = {
 	{0x0000ae18, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 };
 
-static const u32 ar9480_pcie_phy_pll_on_clkreq_disable_L1_1p0[][2] = {
+static const u32 ar9462_pcie_phy_pll_on_clkreq_disable_L1_1p0[][2] = {
 	/* Addr      allmodes  */
 	{0x00018c00, 0x10012e5e},
 	{0x00018c04, 0x000801d8},
 	{0x00018c08, 0x0000580c},
 };
 
-static const u32 ar9480_common_rx_gain_table_1p0[][2] = {
+static const u32 ar9462_common_rx_gain_table_1p0[][2] = {
 	/* Addr      allmodes  */
 	{0x0000a000, 0x00010000},
 	{0x0000a004, 0x00030002},
@@ -802,7 +802,7 @@ static const u32 ar9480_common_rx_gain_table_1p0[][2] = {
 	{0x0000b1fc, 0x00000196},
 };
 
-static const u32 ar9480_modes_high_ob_db_tx_gain_table_1p0[][5] = {
+static const u32 ar9462_modes_high_ob_db_tx_gain_table_1p0[][5] = {
 	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
 	{0x0000a2dc, 0x01feee00, 0x01feee00, 0x03aaa352, 0x03aaa352},
 	{0x0000a2e0, 0x0000f000, 0x0000f000, 0x03ccc584, 0x03ccc584},
@@ -867,7 +867,7 @@ static const u32 ar9480_modes_high_ob_db_tx_gain_table_1p0[][5] = {
 	{0x00016448, 0x8db49000, 0x8db49000, 0x8db49000, 0x8db49000},
 };
 
-static const u32 ar9480_common_wo_xlna_rx_gain_table_1p0[][2] = {
+static const u32 ar9462_common_wo_xlna_rx_gain_table_1p0[][2] = {
 	/* Addr      allmodes  */
 	{0x0000a000, 0x00010000},
 	{0x0000a004, 0x00030002},
@@ -1127,7 +1127,7 @@ static const u32 ar9480_common_wo_xlna_rx_gain_table_1p0[][2] = {
 	{0x0000b1fc, 0x00000196},
 };
 
-static const u32 ar9480_1p0_mac_postamble[][5] = {
+static const u32 ar9462_1p0_mac_postamble[][5] = {
 	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
 	{0x00001030, 0x00000230, 0x00000460, 0x000002c0, 0x00000160},
 	{0x00001070, 0x00000168, 0x000002d0, 0x00000318, 0x0000018c},
@@ -1139,13 +1139,13 @@ static const u32 ar9480_1p0_mac_postamble[][5] = {
 	{0x00008318, 0x00003e80, 0x00007d00, 0x00006880, 0x00003440},
 };
 
-static const u32 ar9480_1p0_mac_postamble_emulation[][5] = {
+static const u32 ar9462_1p0_mac_postamble_emulation[][5] = {
 	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
 	{0x00008014, 0x10f810f8, 0x10f810f8, 0x10f810f8, 0x10f810f8},
 	{0x0000801c, 0x0e8d8017, 0x0e8d8017, 0x0e8d8017, 0x0e8d8017},
 };
 
-static const u32 ar9480_1p0_tx_gain_table_baseband_postamble_emulation[][5] = {
+static const u32 ar9462_1p0_tx_gain_table_baseband_postamble_emulation[][5] = {
 	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
 	{0x0000a410, 0x000000d5, 0x000000d5, 0x000000d5, 0x000000d5},
 	{0x0000a500, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
@@ -1163,7 +1163,7 @@ static const u32 ar9480_1p0_tx_gain_table_baseband_postamble_emulation[][5] = {
 	{0x0000a534, 0x00034e8a, 0x00034e8a, 0x00034e8a, 0x00034e8a},
 };
 
-static const u32 ar9480_1p0_radio_postamble[][5] = {
+static const u32 ar9462_1p0_radio_postamble[][5] = {
 	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
 	{0x0001609c, 0x0b8ee524, 0x0b8ee524, 0x0b8ee524, 0x0b8ee524},
 	{0x000160ac, 0xa4646c08, 0xa4646c08, 0x24646c08, 0x24646c08},
@@ -1174,12 +1174,12 @@ static const u32 ar9480_1p0_radio_postamble[][5] = {
 	{0x00016540, 0x10804008, 0x10804008, 0x50804008, 0x50804008},
 };
 
-static const u32 ar9480_1p0_soc_postamble_emulation[][5] = {
+static const u32 ar9462_1p0_soc_postamble_emulation[][5] = {
 	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
 	{0x00007010, 0x00001133, 0x00001133, 0x00001133, 0x00001133},
 };
 
-static const u32 ar9480_1p0_baseband_core[][2] = {
+static const u32 ar9462_1p0_baseband_core[][2] = {
 	/* Addr      allmodes  */
 	{0x00009800, 0xafe68e30},
 	{0x00009804, 0xfd14e000},
@@ -1336,7 +1336,7 @@ static const u32 ar9480_1p0_baseband_core[][2] = {
 	{0x0000b6b4, 0x00c00001},
 };
 
-static const u32 ar9480_1p0_baseband_postamble[][5] = {
+static const u32 ar9462_1p0_baseband_postamble[][5] = {
 	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
 	{0x00009810, 0xd00a8005, 0xd00a8005, 0xd00a8011, 0xd00a8011},
 	{0x00009820, 0x206a022e, 0x206a022e, 0x206a012e, 0x206a012e},
@@ -1386,7 +1386,7 @@ static const u32 ar9480_1p0_baseband_postamble[][5] = {
 	{0x0000b284, 0x00000000, 0x00000000, 0x00000550, 0x00000550},
 };
 
-static const u32 ar9480_modes_fast_clock_1p0[][3] = {
+static const u32 ar9462_modes_fast_clock_1p0[][3] = {
 	/* Addr      5G_HT20     5G_HT40   */
 	{0x00001030, 0x00000268, 0x000004d0},
 	{0x00001070, 0x0000018c, 0x00000318},
@@ -1399,7 +1399,7 @@ static const u32 ar9480_modes_fast_clock_1p0[][3] = {
 	{0x0000a254, 0x00000898, 0x00001130},
 };
 
-static const u32 ar9480_modes_low_ob_db_tx_gain_table_1p0[][5] = {
+static const u32 ar9462_modes_low_ob_db_tx_gain_table_1p0[][5] = {
 	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
 	{0x0000a2dc, 0x0380c7fc, 0x0380c7fc, 0x03aaa352, 0x03aaa352},
 	{0x0000a2e0, 0x0000f800, 0x0000f800, 0x03ccc584, 0x03ccc584},
@@ -1464,12 +1464,12 @@ static const u32 ar9480_modes_low_ob_db_tx_gain_table_1p0[][5] = {
 	{0x00016448, 0x64992000, 0x64992000, 0x64992000, 0x64992000},
 };
 
-static const u32 ar9480_1p0_soc_postamble[][5] = {
+static const u32 ar9462_1p0_soc_postamble[][5] = {
 	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
 	{0x00007010, 0x00002233, 0x00002233, 0x00002233, 0x00002233},
 };
 
-static const u32 ar9480_common_mixed_rx_gain_table_1p0[][2] = {
+static const u32 ar9462_common_mixed_rx_gain_table_1p0[][2] = {
 	/* Addr      allmodes  */
 	{0x0000a000, 0x00010000},
 	{0x0000a004, 0x00030002},
@@ -1729,14 +1729,14 @@ static const u32 ar9480_common_mixed_rx_gain_table_1p0[][2] = {
 	{0x0000b1fc, 0x00000196},
 };
 
-static const u32 ar9480_pcie_phy_clkreq_disable_L1_1p0[][2] = {
+static const u32 ar9462_pcie_phy_clkreq_disable_L1_1p0[][2] = {
 	/* Addr      allmodes  */
 	{0x00018c00, 0x10013e5e},
 	{0x00018c04, 0x000801d8},
 	{0x00018c08, 0x0000580c},
 };
 
-static const u32 ar9480_1p0_baseband_core_emulation[][2] = {
+static const u32 ar9462_1p0_baseband_core_emulation[][2] = {
 	/* Addr      allmodes  */
 	{0x00009800, 0xafa68e30},
 	{0x00009884, 0x00002842},
@@ -1758,7 +1758,7 @@ static const u32 ar9480_1p0_baseband_core_emulation[][2] = {
 	{0x0000a690, 0x00000038},
 };
 
-static const u32 ar9480_1p0_radio_core[][2] = {
+static const u32 ar9462_1p0_radio_core[][2] = {
 	/* Addr      allmodes  */
 	{0x00016000, 0x36db6db6},
 	{0x00016004, 0x6db6db40},
@@ -1818,16 +1818,16 @@ static const u32 ar9480_1p0_radio_core[][2] = {
 	{0x00016548, 0x000080c0},
 };
 
-static const u32 ar9480_1p0_soc_preamble[][2] = {
+static const u32 ar9462_1p0_soc_preamble[][2] = {
 	/* Addr      allmodes  */
 	{0x00007020, 0x00000000},
 	{0x00007034, 0x00000002},
 	{0x00007038, 0x000004c2},
 };
 
-static const u32 ar9480_1p0_sys2ant[][2] = {
+static const u32 ar9462_1p0_sys2ant[][2] = {
 	/* Addr      allmodes  */
 	{0x00063120, 0x00801980},
 };
 
-#endif /* INITVALS_9480_1P0_H */
+#endif /* INITVALS_9462_1P0_H */
diff --git a/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h b/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
index d54163d..9c51b39 100644
--- a/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
@@ -14,12 +14,12 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#ifndef INITVALS_9480_2P0_H
-#define INITVALS_9480_2P0_H
+#ifndef INITVALS_9462_2P0_H
+#define INITVALS_9462_2P0_H
 
-/* AR9480 2.0 */
+/* AR9462 2.0 */
 
-static const u32 ar9480_modes_fast_clock_2p0[][3] = {
+static const u32 ar9462_modes_fast_clock_2p0[][3] = {
 	/* Addr      5G_HT20     5G_HT40   */
 	{0x00001030, 0x00000268, 0x000004d0},
 	{0x00001070, 0x0000018c, 0x00000318},
@@ -32,14 +32,14 @@ static const u32 ar9480_modes_fast_clock_2p0[][3] = {
 	{0x0000a254, 0x00000898, 0x00001130},
 };
 
-static const u32 ar9480_pciephy_clkreq_enable_L1_2p0[][2] = {
+static const u32 ar9462_pciephy_clkreq_enable_L1_2p0[][2] = {
 	/* Addr      allmodes  */
 	{0x00018c00, 0x18253ede},
 	{0x00018c04, 0x000801d8},
 	{0x00018c08, 0x0003580c},
 };
 
-static const u32 ar9480_2p0_baseband_postamble[][5] = {
+static const u32 ar9462_2p0_baseband_postamble[][5] = {
 	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
 	{0x00009810, 0xd00a8005, 0xd00a8005, 0xd00a8011, 0xd00a8011},
 	{0x00009820, 0x206a022e, 0x206a022e, 0x206a012e, 0x206a012e},
@@ -89,7 +89,7 @@ static const u32 ar9480_2p0_baseband_postamble[][5] = {
 	{0x0000b284, 0x00000000, 0x00000000, 0x00000550, 0x00000550},
 };
 
-static const u32 ar9480_2p0_mac_core_emulation[][2] = {
+static const u32 ar9462_2p0_mac_core_emulation[][2] = {
 	/* Addr      allmodes  */
 	{0x00000030, 0x000e0085},
 	{0x00000044, 0x00000008},
@@ -97,7 +97,7 @@ static const u32 ar9480_2p0_mac_core_emulation[][2] = {
 	{0x00008344, 0xaa4a105b},
 };
 
-static const u32 ar9480_common_rx_gain_table_2p0[][2] = {
+static const u32 ar9462_common_rx_gain_table_2p0[][2] = {
 	/* Addr      allmodes  */
 	{0x0000a000, 0x00010000},
 	{0x0000a004, 0x00030002},
@@ -357,27 +357,27 @@ static const u32 ar9480_common_rx_gain_table_2p0[][2] = {
 	{0x0000b1fc, 0x00000196},
 };
 
-static const u32 ar9480_pciephy_clkreq_disable_L1_2p0[][2] = {
+static const u32 ar9462_pciephy_clkreq_disable_L1_2p0[][2] = {
 	/* Addr      allmodes  */
 	{0x00018c00, 0x18213ede},
 	{0x00018c04, 0x000801d8},
 	{0x00018c08, 0x0003580c},
 };
 
-static const u32 ar9480_pciephy_pll_on_clkreq_disable_L1_2p0[][2] = {
+static const u32 ar9462_pciephy_pll_on_clkreq_disable_L1_2p0[][2] = {
 	/* Addr      allmodes  */
 	{0x00018c00, 0x18212ede},
 	{0x00018c04, 0x000801d8},
 	{0x00018c08, 0x0003580c},
 };
 
-static const u32 ar9480_2p0_sys3ant[][2] = {
+static const u32 ar9462_2p0_sys3ant[][2] = {
 	/* Addr      allmodes  */
 	{0x00063280, 0x00040807},
 	{0x00063284, 0x104ccccc},
 };
 
-static const u32 ar9480_common_rx_gain_table_ar9280_2p0[][2] = {
+static const u32 ar9462_common_rx_gain_table_ar9280_2p0[][2] = {
 	/* Addr      allmodes  */
 	{0x0000a000, 0x02000101},
 	{0x0000a004, 0x02000102},
@@ -679,20 +679,20 @@ static const u32 ar9200_ar9280_2p0_radio_core[][2] = {
 	{0x00007894, 0x5a108000},
 };
 
-static const u32 ar9480_2p0_mac_postamble_emulation[][5] = {
+static const u32 ar9462_2p0_mac_postamble_emulation[][5] = {
 	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
 	{0x00008014, 0x10f810f8, 0x10f810f8, 0x10f810f8, 0x10f810f8},
 	{0x0000801c, 0x0e8d8017, 0x0e8d8017, 0x0e8d8017, 0x0e8d8017},
 };
 
-static const u32 ar9480_2p0_radio_postamble_sys3ant[][5] = {
+static const u32 ar9462_2p0_radio_postamble_sys3ant[][5] = {
 	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
 	{0x000160ac, 0xa4646c08, 0xa4646c08, 0x24645808, 0x24645808},
 	{0x00016140, 0x10804008, 0x10804008, 0x90804008, 0x90804008},
 	{0x00016540, 0x10804008, 0x10804008, 0x90804008, 0x90804008},
 };
 
-static const u32 ar9480_2p0_baseband_postamble_emulation[][5] = {
+static const u32 ar9462_2p0_baseband_postamble_emulation[][5] = {
 	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
 	{0x00009e18, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 	{0x00009e3c, 0xcf946221, 0xcf946221, 0xcf946221, 0xcf946221},
@@ -714,14 +714,14 @@ static const u32 ar9480_2p0_baseband_postamble_emulation[][5] = {
 	{0x0000ae18, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 };
 
-static const u32 ar9480_2p0_radio_postamble_sys2ant[][5] = {
+static const u32 ar9462_2p0_radio_postamble_sys2ant[][5] = {
 	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
 	{0x000160ac, 0xa4646c08, 0xa4646c08, 0x24645808, 0x24645808},
 	{0x00016140, 0x10804008, 0x10804008, 0x90804008, 0x90804008},
 	{0x00016540, 0x10804008, 0x10804008, 0x90804008, 0x90804008},
 };
 
-static const u32 ar9480_common_wo_xlna_rx_gain_table_2p0[][2] = {
+static const u32 ar9462_common_wo_xlna_rx_gain_table_2p0[][2] = {
 	/* Addr      allmodes  */
 	{0x0000a000, 0x00010000},
 	{0x0000a004, 0x00030002},
@@ -981,14 +981,14 @@ static const u32 ar9480_common_wo_xlna_rx_gain_table_2p0[][2] = {
 	{0x0000b1fc, 0x00000196},
 };
 
-static const u32 ar9480_2p0_baseband_core_txfir_coeff_japan_2484[][2] = {
+static const u32 ar9462_2p0_baseband_core_txfir_coeff_japan_2484[][2] = {
 	/* Addr      allmodes  */
 	{0x0000a398, 0x00000000},
 	{0x0000a39c, 0x6f7f0301},
 	{0x0000a3a0, 0xca9228ee},
 };
 
-static const u32 ar9480_modes_low_ob_db_tx_gain_table_2p0[][5] = {
+static const u32 ar9462_modes_low_ob_db_tx_gain_table_2p0[][5] = {
 	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
 	{0x000098bc, 0x00000002, 0x00000002, 0x00000002, 0x00000002},
 	{0x0000a2dc, 0x0380c7fc, 0x0380c7fc, 0x03aaa352, 0x03aaa352},
@@ -1057,12 +1057,12 @@ static const u32 ar9480_modes_low_ob_db_tx_gain_table_2p0[][5] = {
 	{0x00016454, 0x6db60000, 0x6db60000, 0x6db60000, 0x6db60000},
 };
 
-static const u32 ar9480_2p0_soc_postamble[][5] = {
+static const u32 ar9462_2p0_soc_postamble[][5] = {
 	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
 	{0x00007010, 0x00002233, 0x00002233, 0x00002233, 0x00002233},
 };
 
-static const u32 ar9480_2p0_baseband_core[][2] = {
+static const u32 ar9462_2p0_baseband_core[][2] = {
 	/* Addr      allmodes  */
 	{0x00009800, 0xafe68e30},
 	{0x00009804, 0xfd14e000},
@@ -1221,7 +1221,7 @@ static const u32 ar9480_2p0_baseband_core[][2] = {
 	{0x0000b6b4, 0x00000001},
 };
 
-static const u32 ar9480_2p0_radio_postamble[][5] = {
+static const u32 ar9462_2p0_radio_postamble[][5] = {
 	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
 	{0x0001609c, 0x0b8ee524, 0x0b8ee524, 0x0b8ee524, 0x0b8ee524},
 	{0x000160b0, 0x01d67f70, 0x01d67f70, 0x01d67f70, 0x01d67f70},
@@ -1229,7 +1229,7 @@ static const u32 ar9480_2p0_radio_postamble[][5] = {
 	{0x0001650c, 0x48000000, 0x40000000, 0x40000000, 0x40000000},
 };
 
-static const u32 ar9480_modes_high_ob_db_tx_gain_table_2p0[][5] = {
+static const u32 ar9462_modes_high_ob_db_tx_gain_table_2p0[][5] = {
 	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
 	{0x000098bc, 0x00000002, 0x00000002, 0x00000002, 0x00000002},
 	{0x0000a2dc, 0x01feee00, 0x01feee00, 0x03aaa352, 0x03aaa352},
@@ -1298,7 +1298,7 @@ static const u32 ar9480_modes_high_ob_db_tx_gain_table_2p0[][5] = {
 	{0x00016454, 0x6db60000, 0x6db60000, 0x6db60000, 0x6db60000},
 };
 
-static const u32 ar9480_2p0_radio_core[][2] = {
+static const u32 ar9462_2p0_radio_core[][2] = {
 	/* Addr      allmodes  */
 	{0x00016000, 0x36db6db6},
 	{0x00016004, 0x6db6db40},
@@ -1356,7 +1356,7 @@ static const u32 ar9480_2p0_radio_core[][2] = {
 	{0x00016548, 0x000080c0},
 };
 
-static const u32 ar9480_2p0_tx_gain_table_baseband_postamble_emulation[][5] = {
+static const u32 ar9462_2p0_tx_gain_table_baseband_postamble_emulation[][5] = {
 	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
 	{0x0000a410, 0x000000d5, 0x000000d5, 0x000000d5, 0x000000d5},
 	{0x0000a500, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
@@ -1374,19 +1374,19 @@ static const u32 ar9480_2p0_tx_gain_table_baseband_postamble_emulation[][5] = {
 	{0x0000a534, 0x00034e8a, 0x00034e8a, 0x00034e8a, 0x00034e8a},
 };
 
-static const u32 ar9480_2p0_soc_preamble[][2] = {
+static const u32 ar9462_2p0_soc_preamble[][2] = {
 	/* Addr      allmodes  */
 	{0x00007020, 0x00000000},
 	{0x00007034, 0x00000002},
 	{0x00007038, 0x000004c2},
 };
 
-static const u32 ar9480_2p0_sys2ant[][2] = {
+static const u32 ar9462_2p0_sys2ant[][2] = {
 	/* Addr      allmodes  */
 	{0x00063120, 0x00801980},
 };
 
-static const u32 ar9480_2p0_mac_core[][2] = {
+static const u32 ar9462_2p0_mac_core[][2] = {
 	/* Addr      allmodes  */
 	{0x00000008, 0x00000000},
 	{0x00000030, 0x000e0085},
@@ -1550,7 +1550,7 @@ static const u32 ar9480_2p0_mac_core[][2] = {
 	{0x000083d0, 0x000301ff},
 };
 
-static const u32 ar9480_2p0_mac_postamble[][5] = {
+static const u32 ar9462_2p0_mac_postamble[][5] = {
 	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
 	{0x00001030, 0x00000230, 0x00000460, 0x000002c0, 0x00000160},
 	{0x00001070, 0x00000168, 0x000002d0, 0x00000318, 0x0000018c},
@@ -1562,7 +1562,7 @@ static const u32 ar9480_2p0_mac_postamble[][5] = {
 	{0x00008318, 0x00003e80, 0x00007d00, 0x00006880, 0x00003440},
 };
 
-static const u32 ar9480_common_mixed_rx_gain_table_2p0[][2] = {
+static const u32 ar9462_common_mixed_rx_gain_table_2p0[][2] = {
 	/* Addr      allmodes  */
 	{0x0000a000, 0x00010000},
 	{0x0000a004, 0x00030002},
@@ -1822,7 +1822,7 @@ static const u32 ar9480_common_mixed_rx_gain_table_2p0[][2] = {
 	{0x0000b1fc, 0x00000196},
 };
 
-static const u32 ar9480_modes_green_ob_db_tx_gain_table_2p0[][5] = {
+static const u32 ar9462_modes_green_ob_db_tx_gain_table_2p0[][5] = {
 	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
 	{0x000098bc, 0x00000003, 0x00000003, 0x00000003, 0x00000003},
 	{0x0000a2dc, 0x01feee00, 0x01feee00, 0x03aaa352, 0x03aaa352},
@@ -1891,7 +1891,7 @@ static const u32 ar9480_modes_green_ob_db_tx_gain_table_2p0[][5] = {
 	{0x00016454, 0x6db60180, 0x6db60180, 0x6db60180, 0x6db60180},
 };
 
-static const u32 ar9480_2p0_BTCOEX_MAX_TXPWR_table[][2] = {
+static const u32 ar9462_2p0_BTCOEX_MAX_TXPWR_table[][2] = {
 	/* Addr      allmodes  */
 	{0x000018c0, 0x10101010},
 	{0x000018c4, 0x10101010},
@@ -1903,7 +1903,7 @@ static const u32 ar9480_2p0_BTCOEX_MAX_TXPWR_table[][2] = {
 	{0x000018dc, 0x10101010},
 };
 
-static const u32 ar9480_2p0_baseband_core_emulation[][2] = {
+static const u32 ar9462_2p0_baseband_core_emulation[][2] = {
 	/* Addr      allmodes  */
 	{0x00009800, 0xafa68e30},
 	{0x00009884, 0x00002842},
@@ -1925,4 +1925,4 @@ static const u32 ar9480_2p0_baseband_core_emulation[][2] = {
 	{0x0000a690, 0x00000038},
 };
 
-#endif /* INITVALS_9480_2P0_H */
+#endif /* INITVALS_9462_2P0_H */
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 1e86147..1c269f5 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -458,7 +458,7 @@ void ath9k_btcoex_timer_pause(struct ath_softc *sc);
 #define ATH_LED_PIN_9287		8
 #define ATH_LED_PIN_9300		10
 #define ATH_LED_PIN_9485		6
-#define ATH_LED_PIN_9480		0
+#define ATH_LED_PIN_9462		0
 
 #ifdef CONFIG_MAC80211_LEDS
 void ath_init_leds(struct ath_softc *sc);
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless/ath/ath9k/eeprom.h
index 5d92f96..0420041 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h
@@ -108,7 +108,7 @@
 #define EEP_RFSILENT_ENABLED_S      0
 #define EEP_RFSILENT_POLARITY       0x0002
 #define EEP_RFSILENT_POLARITY_S     1
-#define EEP_RFSILENT_GPIO_SEL       (AR_SREV_9480(ah) ? 0x00fc : 0x001c)
+#define EEP_RFSILENT_GPIO_SEL       (AR_SREV_9462(ah) ? 0x00fc : 0x001c)
 #define EEP_RFSILENT_GPIO_SEL_S     2
 
 #define AR5416_OPFLAGS_11A           0x01
diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index fd0f84e..d7db61d 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -48,8 +48,8 @@ void ath_init_leds(struct ath_softc *sc)
 			sc->sc_ah->led_pin = ATH_LED_PIN_9485;
 		else if (AR_SREV_9300(sc->sc_ah))
 			sc->sc_ah->led_pin = ATH_LED_PIN_9300;
-		else if (AR_SREV_9480(sc->sc_ah))
-			sc->sc_ah->led_pin = ATH_LED_PIN_9480;
+		else if (AR_SREV_9462(sc->sc_ah))
+			sc->sc_ah->led_pin = ATH_LED_PIN_9462;
 		else
 			sc->sc_ah->led_pin = ATH_LED_PIN_DEF;
 	}
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index e5dbf12..255a538 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -285,7 +285,7 @@ static void ath9k_hw_read_revisions(struct ath_hw *ah)
 			(val & AR_SREV_VERSION2) >> AR_SREV_TYPE2_S;
 		ah->hw_version.macRev = MS(val, AR_SREV_REVISION2);
 
-		if (AR_SREV_9480(ah))
+		if (AR_SREV_9462(ah))
 			ah->is_pciexpress = true;
 		else
 			ah->is_pciexpress = (val &
@@ -542,7 +542,7 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 		return -EIO;
 	}
 
-	if (AR_SREV_9480(ah))
+	if (AR_SREV_9462(ah))
 		ah->WARegVal &= ~AR_WA_D3_L1_DISABLE;
 
 	ath9k_hw_init_defaults(ah);
@@ -588,7 +588,7 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 	case AR_SREV_VERSION_9330:
 	case AR_SREV_VERSION_9485:
 	case AR_SREV_VERSION_9340:
-	case AR_SREV_VERSION_9480:
+	case AR_SREV_VERSION_9462:
 		break;
 	default:
 		ath_err(common,
@@ -673,7 +673,7 @@ int ath9k_hw_init(struct ath_hw *ah)
 	case AR9300_DEVID_AR9330:
 	case AR9300_DEVID_AR9340:
 	case AR9300_DEVID_AR9580:
-	case AR9300_DEVID_AR9480:
+	case AR9300_DEVID_AR9462:
 		break;
 	default:
 		if (common->bus_ops->ath_bus_type == ATH_USB)
@@ -1800,7 +1800,7 @@ static void ath9k_set_power_sleep(struct ath_hw *ah, int setChip)
 {
 	REG_SET_BIT(ah, AR_STA_ID1, AR_STA_ID1_PWR_SAV);
 	if (setChip) {
-		if (AR_SREV_9480(ah)) {
+		if (AR_SREV_9462(ah)) {
 			REG_WRITE(ah, AR_TIMER_MODE,
 				  REG_READ(ah, AR_TIMER_MODE) & 0xFFFFFF00);
 			REG_WRITE(ah, AR_NDP2_TIMER_MODE, REG_READ(ah,
@@ -1818,7 +1818,7 @@ static void ath9k_set_power_sleep(struct ath_hw *ah, int setChip)
 		 */
 		REG_CLR_BIT(ah, AR_RTC_FORCE_WAKE, AR_RTC_FORCE_WAKE_EN);
 
-		if (AR_SREV_9480(ah))
+		if (AR_SREV_9462(ah))
 			udelay(100);
 
 		if (!AR_SREV_9100(ah) && !AR_SREV_9300_20_OR_LATER(ah))
@@ -1826,7 +1826,7 @@ static void ath9k_set_power_sleep(struct ath_hw *ah, int setChip)
 
 		/* Shutdown chip. Active low */
 		if (!AR_SREV_5416(ah) &&
-				!AR_SREV_9271(ah) && !AR_SREV_9480_10(ah)) {
+				!AR_SREV_9271(ah) && !AR_SREV_9462_10(ah)) {
 			REG_CLR_BIT(ah, AR_RTC_RESET, AR_RTC_RESET_EN);
 			udelay(2);
 		}
@@ -1864,7 +1864,7 @@ static void ath9k_set_power_network_sleep(struct ath_hw *ah, int setChip)
 			 * SYS_WAKING and SYS_SLEEPING messages which will make
 			 * BT CPU to busy to process.
 			 */
-			if (AR_SREV_9480(ah)) {
+			if (AR_SREV_9462(ah)) {
 				val = REG_READ(ah, AR_MCI_INTERRUPT_RX_MSG_EN) &
 					~AR_MCI_INTERRUPT_RX_HW_MSG_MASK;
 				REG_WRITE(ah, AR_MCI_INTERRUPT_RX_MSG_EN, val);
@@ -1876,7 +1876,7 @@ static void ath9k_set_power_network_sleep(struct ath_hw *ah, int setChip)
 			REG_CLR_BIT(ah, AR_RTC_FORCE_WAKE,
 				    AR_RTC_FORCE_WAKE_EN);
 
-			if (AR_SREV_9480(ah))
+			if (AR_SREV_9462(ah))
 				udelay(30);
 		}
 	}
@@ -2345,7 +2345,7 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 		if (!AR_SREV_9330(ah))
 			ah->enabled_cals |= TX_IQ_ON_AGC_CAL;
 	}
-	if (AR_SREV_9480(ah))
+	if (AR_SREV_9462(ah))
 		pCap->hw_caps |= ATH9K_HW_CAP_RTT;
 
 	return 0;
@@ -2508,7 +2508,7 @@ void ath9k_hw_setrxfilter(struct ath_hw *ah, u32 bits)
 
 	ENABLE_REGWRITE_BUFFER(ah);
 
-	if (AR_SREV_9480(ah))
+	if (AR_SREV_9462(ah))
 		bits |= ATH9K_RX_FILTER_CONTROL_WRAPPER;
 
 	REG_WRITE(ah, AR_RX_FILTER, bits);
@@ -2767,9 +2767,9 @@ void ath9k_hw_gen_timer_start(struct ath_hw *ah,
 	REG_SET_BIT(ah, gen_tmr_configuration[timer->index].mode_addr,
 		    gen_tmr_configuration[timer->index].mode_mask);
 
-	if (AR_SREV_9480(ah)) {
+	if (AR_SREV_9462(ah)) {
 		/*
-		 * Starting from AR9480, each generic timer can select which tsf
+		 * Starting from AR9462, each generic timer can select which tsf
 		 * to use. But we still follow the old rule, 0 - 7 use tsf and
 		 * 8 - 15  use tsf2.
 		 */
@@ -2886,7 +2886,7 @@ static struct {
 	{ AR_SREV_VERSION_9330,         "9330" },
 	{ AR_SREV_VERSION_9340,		"9340" },
 	{ AR_SREV_VERSION_9485,         "9485" },
-	{ AR_SREV_VERSION_9480,         "9480" },
+	{ AR_SREV_VERSION_9462,         "9462" },
 };
 
 /* For devices with external radios */
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 3ed3619..14206f3 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -46,7 +46,7 @@
 #define AR9300_DEVID_AR9340	0x0031
 #define AR9300_DEVID_AR9485_PCIE 0x0032
 #define AR9300_DEVID_AR9580	0x0033
-#define AR9300_DEVID_AR9480	0x0034
+#define AR9300_DEVID_AR9462	0x0034
 #define AR9300_DEVID_AR9330	0x0035
 
 #define AR5416_AR9100_DEVID	0x000b
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index d67d6ee..edb0b4b 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -33,7 +33,7 @@ static DEFINE_PCI_DEVICE_TABLE(ath_pci_id_table) = {
 	{ PCI_VDEVICE(ATHEROS, 0x0030) }, /* PCI-E  AR9300 */
 	{ PCI_VDEVICE(ATHEROS, 0x0032) }, /* PCI-E  AR9485 */
 	{ PCI_VDEVICE(ATHEROS, 0x0033) }, /* PCI-E  AR9580 */
-	{ PCI_VDEVICE(ATHEROS, 0x0034) }, /* PCI-E  AR9480 */
+	{ PCI_VDEVICE(ATHEROS, 0x0034) }, /* PCI-E  AR9462 */
 	{ 0 }
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 87a1245..8fcb7e9 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -796,9 +796,9 @@
 #define AR_SREV_VERSION_9340		0x300
 #define AR_SREV_VERSION_9580		0x1C0
 #define AR_SREV_REVISION_9580_10	4 /* AR9580 1.0 */
-#define AR_SREV_VERSION_9480		0x280
-#define AR_SREV_REVISION_9480_10	0
-#define AR_SREV_REVISION_9480_20	2
+#define AR_SREV_VERSION_9462		0x280
+#define AR_SREV_REVISION_9462_10	0
+#define AR_SREV_REVISION_9462_20	2
 
 #define AR_SREV_5416(_ah) \
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_5416_PCI) || \
@@ -895,20 +895,20 @@
     (AR_SREV_9285_12_OR_LATER(_ah) && \
      ((REG_READ(_ah, AR_AN_SYNTH9) & 0x7) == 0x1))
 
-#define AR_SREV_9480(_ah) \
-	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9480))
+#define AR_SREV_9462(_ah) \
+	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9462))
 
-#define AR_SREV_9480_10(_ah) \
-	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9480) && \
-	((_ah)->hw_version.macRev == AR_SREV_REVISION_9480_10))
+#define AR_SREV_9462_10(_ah) \
+	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9462) && \
+	((_ah)->hw_version.macRev == AR_SREV_REVISION_9462_10))
 
-#define AR_SREV_9480_20(_ah) \
-	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9480) && \
-	((_ah)->hw_version.macRev == AR_SREV_REVISION_9480_20))
+#define AR_SREV_9462_20(_ah) \
+	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9462) && \
+	((_ah)->hw_version.macRev == AR_SREV_REVISION_9462_20))
 
-#define AR_SREV_9480_20_OR_LATER(_ah) \
-	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9480) && \
-	((_ah)->hw_version.macRev >= AR_SREV_REVISION_9480_20))
+#define AR_SREV_9462_20_OR_LATER(_ah) \
+	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9462) && \
+	((_ah)->hw_version.macRev >= AR_SREV_REVISION_9462_20))
 
 #define AR_SREV_9580(_ah) \
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9580) && \
-- 
1.7.7

