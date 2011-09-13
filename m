Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:59497 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292Ab1IMRJ5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Sep 2011 13:09:57 -0400
From: Senthil Balasubramanian <senthilb@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Subject: [PATCH 3/4] ath9k_hw: Add support for AR946/8x chipsets.
Date: Tue, 13 Sep 2011 22:38:18 +0530
Message-ID: <1315933699-7642-3-git-send-email-senthilb@qca.qualcomm.com> (sfid-20110913_191003_511696_038CC993)
In-Reply-To: <1315933699-7642-1-git-send-email-senthilb@qca.qualcomm.com>
References: <1315933699-7642-1-git-send-email-senthilb@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds support for AR946/8x chipets.

Signed-off-by: Senthil Balasubramanian <senthilb@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |  109 +++++++++++---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h |    3 +-
 drivers/net/wireless/ath/ath9k/ar9003_hw.c     |  191 ++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/ar9003_paprd.c  |   11 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c    |   10 ++
 drivers/net/wireless/ath/ath9k/hw.c            |   73 ++++++++-
 drivers/net/wireless/ath/ath9k/pci.c           |    1 +
 7 files changed, 362 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index fc2d607..8884979 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -22,11 +22,13 @@
 #define COMP_HDR_LEN 4
 #define COMP_CKSUM_LEN 2
 
-#define AR_CH0_TOP (0x00016288)
+#define AR_CH0_TOP	(AR_SREV_9300(ah) ? 0x16288 : \
+				((AR_SREV_9480(ah) ? 0x1628c : 0x16280)))
 #define AR_CH0_TOP_XPABIASLVL (0x300)
 #define AR_CH0_TOP_XPABIASLVL_S (8)
 
-#define AR_CH0_THERM (0x00016290)
+#define AR_CH0_THERM	(AR_SREV_9300(ah) ? 0x16290 : \
+				((AR_SREV_9485(ah) ? 0x1628c : 0x16294)))
 #define AR_CH0_THERM_XPABIASLVL_MSB 0x3
 #define AR_CH0_THERM_XPABIASLVL_MSB_S 0
 #define AR_CH0_THERM_XPASHORT2GND 0x4
@@ -34,6 +36,11 @@
 
 #define AR_SWITCH_TABLE_COM_ALL (0xffff)
 #define AR_SWITCH_TABLE_COM_ALL_S (0)
+#define AR_SWITCH_TABLE_COM_AR9480_ALL (0xffffff)
+#define AR_SWITCH_TABLE_COM_AR9480_ALL_S (0)
+#define AR_SWITCH_TABLE_COM_SPDT (0x00f00000)
+#define AR_SWITCH_TABLE_COM_SPDT_ALL (0x0000fff0)
+#define AR_SWITCH_TABLE_COM_SPDT_ALL_S (4)
 
 #define AR_SWITCH_TABLE_COM2_ALL (0xffffff)
 #define AR_SWITCH_TABLE_COM2_ALL_S (0)
@@ -158,7 +165,7 @@ static const struct ar9300_eeprom ar9300_default = {
 		.papdRateMaskHt20 = LE32(0x0cf0e0e0),
 		.papdRateMaskHt40 = LE32(0x6cf0e0e0),
 		.futureModal = {
-			0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+			0, 0, 0, 0, 0, 0, 0, 0,
 		},
 	 },
 	.base_ext1 = {
@@ -360,7 +367,7 @@ static const struct ar9300_eeprom ar9300_default = {
 		.papdRateMaskHt20 = LE32(0x0c80c080),
 		.papdRateMaskHt40 = LE32(0x0080c080),
 		.futureModal = {
-			0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+			0, 0, 0, 0, 0, 0, 0, 0,
 		},
 	 },
 	.base_ext2 = {
@@ -735,7 +742,7 @@ static const struct ar9300_eeprom ar9300_x113 = {
 		.papdRateMaskHt20 = LE32(0x0c80c080),
 		.papdRateMaskHt40 = LE32(0x0080c080),
 		.futureModal = {
-			0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+			0, 0, 0, 0, 0, 0, 0, 0,
 		},
 	 },
 	 .base_ext1 = {
@@ -937,7 +944,7 @@ static const struct ar9300_eeprom ar9300_x113 = {
 		.papdRateMaskHt20 = LE32(0x0cf0e0e0),
 		.papdRateMaskHt40 = LE32(0x6cf0e0e0),
 		.futureModal = {
-			0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+			0, 0, 0, 0, 0, 0, 0, 0,
 		},
 	 },
 	.base_ext2 = {
@@ -1313,7 +1320,7 @@ static const struct ar9300_eeprom ar9300_h112 = {
 		.papdRateMaskHt20 = LE32(0x80c080),
 		.papdRateMaskHt40 = LE32(0x80c080),
 		.futureModal = {
-			0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+			0, 0, 0, 0, 0, 0, 0, 0,
 		},
 	},
 	.base_ext1 = {
@@ -1515,7 +1522,7 @@ static const struct ar9300_eeprom ar9300_h112 = {
 		.papdRateMaskHt20 = LE32(0x0cf0e0e0),
 		.papdRateMaskHt40 = LE32(0x6cf0e0e0),
 		.futureModal = {
-			0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+			0, 0, 0, 0, 0, 0, 0, 0,
 		},
 	},
 	.base_ext2 = {
@@ -1891,7 +1898,7 @@ static const struct ar9300_eeprom ar9300_x112 = {
 		.papdRateMaskHt20 = LE32(0x0c80c080),
 		.papdRateMaskHt40 = LE32(0x0080c080),
 		.futureModal = {
-			0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+			0, 0, 0, 0, 0, 0, 0, 0,
 		},
 	},
 	.base_ext1 = {
@@ -2093,7 +2100,7 @@ static const struct ar9300_eeprom ar9300_x112 = {
 		.papdRateMaskHt20 = LE32(0x0cf0e0e0),
 		.papdRateMaskHt40 = LE32(0x6cf0e0e0),
 		.futureModal = {
-			0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+			0, 0, 0, 0, 0, 0, 0, 0,
 		},
 	},
 	.base_ext2 = {
@@ -2468,7 +2475,7 @@ static const struct ar9300_eeprom ar9300_h116 = {
 		.papdRateMaskHt20 = LE32(0x0c80C080),
 		.papdRateMaskHt40 = LE32(0x0080C080),
 		.futureModal = {
-			0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+			0, 0, 0, 0, 0, 0, 0, 0,
 		},
 	 },
 	 .base_ext1 = {
@@ -2670,7 +2677,7 @@ static const struct ar9300_eeprom ar9300_h116 = {
 		.papdRateMaskHt20 = LE32(0x0cf0e0e0),
 		.papdRateMaskHt40 = LE32(0x6cf0e0e0),
 		.futureModal = {
-			0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+			0, 0, 0, 0, 0, 0, 0, 0,
 		},
 	 },
 	.base_ext2 = {
@@ -3573,6 +3580,8 @@ static void ar9003_hw_xpa_bias_level_apply(struct ath_hw *ah, bool is2ghz)
 
 	if (AR_SREV_9485(ah) || AR_SREV_9330(ah) || AR_SREV_9340(ah))
 		REG_RMW_FIELD(ah, AR_CH0_TOP2, AR_CH0_TOP2_XPABIASLVL, bias);
+	else if (AR_SREV_9480(ah))
+		REG_RMW_FIELD(ah, AR_CH0_TOP, AR_CH0_TOP_XPABIASLVL, bias);
 	else {
 		REG_RMW_FIELD(ah, AR_CH0_TOP, AR_CH0_TOP_XPABIASLVL, bias);
 		REG_RMW_FIELD(ah, AR_CH0_THERM,
@@ -3583,6 +3592,19 @@ static void ar9003_hw_xpa_bias_level_apply(struct ath_hw *ah, bool is2ghz)
 	}
 }
 
+static u16 ar9003_switch_com_spdt_get(struct ath_hw *ah, bool is_2ghz)
+{
+	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
+	__le32 val;
+
+	if (is_2ghz)
+		val = eep->modalHeader2G.switchcomspdt;
+	else
+		val = eep->modalHeader5G.switchcomspdt;
+	return le32_to_cpu(val);
+}
+
+
 static u32 ar9003_hw_ant_ctrl_common_get(struct ath_hw *ah, bool is2ghz)
 {
 	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
@@ -3637,7 +3659,36 @@ static void ar9003_hw_ant_ctrl_apply(struct ath_hw *ah, bool is2ghz)
 
 	u32 value = ar9003_hw_ant_ctrl_common_get(ah, is2ghz);
 
-	REG_RMW_FIELD(ah, AR_PHY_SWITCH_COM, AR_SWITCH_TABLE_COM_ALL, value);
+	if (AR_SREV_9480(ah)) {
+		if (AR_SREV_9480_10(ah)) {
+			value &= ~AR_SWITCH_TABLE_COM_SPDT;
+			value |= 0x00100000;
+		}
+		REG_RMW_FIELD(ah, AR_PHY_SWITCH_COM,
+				AR_SWITCH_TABLE_COM_AR9480_ALL, value);
+	} else
+		REG_RMW_FIELD(ah, AR_PHY_SWITCH_COM,
+			      AR_SWITCH_TABLE_COM_ALL, value);
+
+
+	/*
+	 *   AR9480 defines new switch table for BT/WLAN,
+	 *       here's new field name in XXX.ref for both 2G and 5G.
+	 *   Register: [GLB_CONTROL] GLB_CONTROL (@0x20044)
+	 *   15:12   R/W     SWITCH_TABLE_COM_SPDT_WLAN_RX
+	 * SWITCH_TABLE_COM_SPDT_WLAN_RX
+	 *
+	 *   11:8     R/W     SWITCH_TABLE_COM_SPDT_WLAN_TX
+	 * SWITCH_TABLE_COM_SPDT_WLAN_TX
+	 *
+	 *   7:4 R/W  SWITCH_TABLE_COM_SPDT_WLAN_IDLE
+	 * SWITCH_TABLE_COM_SPDT_WLAN_IDLE
+	 */
+	if (AR_SREV_9480_20_OR_LATER(ah)) {
+		value = ar9003_switch_com_spdt_get(ah, is2ghz);
+		REG_RMW_FIELD(ah, AR_PHY_GLB_CONTROL,
+				AR_SWITCH_TABLE_COM_SPDT_ALL, value);
+	}
 
 	value = ar9003_hw_ant_ctrl_common_2_get(ah, is2ghz);
 	REG_RMW_FIELD(ah, AR_PHY_SWITCH_COM_2, AR_SWITCH_TABLE_COM2_ALL, value);
@@ -3837,6 +3888,7 @@ static void ar9003_hw_internal_regulator_apply(struct ath_hw *ah)
 {
 	int internal_regulator =
 		ath9k_hw_ar9300_get_eeprom(ah, EEP_INTERNAL_REGULATOR);
+	u32 reg_val;
 
 	if (internal_regulator) {
 		if (AR_SREV_9330(ah) || AR_SREV_9485(ah)) {
@@ -3881,13 +3933,16 @@ static void ar9003_hw_internal_regulator_apply(struct ath_hw *ah)
 			REG_WRITE(ah, AR_PHY_PMU2, reg_pmu_set);
 			if (!is_pmu_set(ah, AR_PHY_PMU2, reg_pmu_set))
 				return;
+		} else if (AR_SREV_9480(ah)) {
+			reg_val = ath9k_hw_ar9300_get_eeprom(ah, EEP_SWREG);
+			REG_WRITE(ah, AR_PHY_PMU1, reg_val);
 		} else {
 			/* Internal regulator is ON. Write swreg register. */
-			int swreg = ath9k_hw_ar9300_get_eeprom(ah, EEP_SWREG);
+			reg_val = ath9k_hw_ar9300_get_eeprom(ah, EEP_SWREG);
 			REG_WRITE(ah, AR_RTC_REG_CONTROL1,
 				  REG_READ(ah, AR_RTC_REG_CONTROL1) &
 				  (~AR_RTC_REG_CONTROL1_SWREG_PROGRAM));
-			REG_WRITE(ah, AR_RTC_REG_CONTROL0, swreg);
+			REG_WRITE(ah, AR_RTC_REG_CONTROL0, reg_val);
 			/* Set REG_CONTROL1.SWREG_PROGRAM */
 			REG_WRITE(ah, AR_RTC_REG_CONTROL1,
 				  REG_READ(ah,
@@ -3898,22 +3953,24 @@ static void ar9003_hw_internal_regulator_apply(struct ath_hw *ah)
 		if (AR_SREV_9330(ah) || AR_SREV_9485(ah)) {
 			REG_RMW_FIELD(ah, AR_PHY_PMU2, AR_PHY_PMU2_PGM, 0);
 			while (REG_READ_FIELD(ah, AR_PHY_PMU2,
-					      AR_PHY_PMU2_PGM))
+						AR_PHY_PMU2_PGM))
 				udelay(10);
 
 			REG_RMW_FIELD(ah, AR_PHY_PMU1, AR_PHY_PMU1_PWD, 0x1);
 			while (!REG_READ_FIELD(ah, AR_PHY_PMU1,
-					       AR_PHY_PMU1_PWD))
+						AR_PHY_PMU1_PWD))
 				udelay(10);
 			REG_RMW_FIELD(ah, AR_PHY_PMU2, AR_PHY_PMU2_PGM, 0x1);
 			while (!REG_READ_FIELD(ah, AR_PHY_PMU2,
-					      AR_PHY_PMU2_PGM))
+						AR_PHY_PMU2_PGM))
 				udelay(10);
-		} else
-			REG_WRITE(ah, AR_RTC_SLEEP_CLK,
-				  (REG_READ(ah,
-				   AR_RTC_SLEEP_CLK) |
-				   AR_RTC_FORCE_SWREG_PRD));
+		} else if (AR_SREV_9480(ah))
+			REG_RMW_FIELD(ah, AR_PHY_PMU1, AR_PHY_PMU1_PWD, 0x1);
+		else {
+			reg_val = REG_READ(ah, AR_RTC_SLEEP_CLK) |
+				AR_RTC_FORCE_SWREG_PRD;
+			REG_WRITE(ah, AR_RTC_SLEEP_CLK, reg_val);
+		}
 	}
 
 }
@@ -4493,6 +4550,12 @@ static int ar9003_hw_power_control_override(struct ath_hw *ah,
 		tempSlope = eep->modalHeader5G.tempSlope;
 
 	REG_RMW_FIELD(ah, AR_PHY_TPC_19, AR_PHY_TPC_19_ALPHA_THERM, tempSlope);
+
+	if (AR_SREV_9480_20(ah))
+		REG_RMW_FIELD(ah, AR_PHY_TPC_19_B1,
+			      AR_PHY_TPC_19_B1_ALPHA_THERM, tempSlope);
+
+
 	REG_RMW_FIELD(ah, AR_PHY_TPC_18, AR_PHY_TPC_18_THERM_CAL_VALUE,
 		      temperature[0]);
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
index ab21a49..6335a86 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
@@ -233,7 +233,8 @@ struct ar9300_modal_eep_header {
 	u8 thresh62;
 	__le32 papdRateMaskHt20;
 	__le32 papdRateMaskHt40;
-	u8 futureModal[10];
+	__le16 switchcomspdt;
+	u8 futureModal[8];
 } __packed;
 
 struct ar9300_cal_data_per_freq_op_loop {
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index 6b54700..901f417 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -22,6 +22,8 @@
 #include "ar9330_1p1_initvals.h"
 #include "ar9330_1p2_initvals.h"
 #include "ar9580_1p0_initvals.h"
+#include "ar9480_1p0_initvals.h"
+#include "ar9480_2p0_initvals.h"
 
 /* General hardware code for the AR9003 hadware family */
 
@@ -32,6 +34,14 @@
  */
 static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
 {
+#define PCIE_PLL_ON_CREQ_DIS_L1_2P0 \
+		ar9480_pciephy_pll_on_clkreq_disable_L1_2p0
+
+#define AR9480_BB_CTX_COEFJ(x)	\
+		ar9480_##x##_baseband_core_txfir_coeff_japan_2484
+
+#define AR9480_BBC_TXIFR_COEFFJ \
+		ar9480_2p0_baseband_core_txfir_coeff_japan_2484
 	if (AR_SREV_9330_11(ah)) {
 		/* mac */
 		INIT_INI_ARRAY(&ah->iniMac[ATH_INI_PRE], NULL, 0, 0);
@@ -254,6 +264,132 @@ static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
 				ar9485_1_1_pcie_phy_clkreq_disable_L1,
 				ARRAY_SIZE(ar9485_1_1_pcie_phy_clkreq_disable_L1),
 				2);
+	} else if (AR_SREV_9480_10(ah)) {
+		INIT_INI_ARRAY(&ah->iniMac[ATH_INI_PRE], NULL, 0, 0);
+		INIT_INI_ARRAY(&ah->iniMac[ATH_INI_CORE], ar9480_1p0_mac_core,
+				ARRAY_SIZE(ar9480_1p0_mac_core), 2);
+		INIT_INI_ARRAY(&ah->iniMac[ATH_INI_POST],
+				ar9480_1p0_mac_postamble,
+				ARRAY_SIZE(ar9480_1p0_mac_postamble),
+				5);
+
+		INIT_INI_ARRAY(&ah->iniBB[ATH_INI_PRE], NULL, 0, 0);
+		INIT_INI_ARRAY(&ah->iniBB[ATH_INI_CORE],
+				ar9480_1p0_baseband_core,
+				ARRAY_SIZE(ar9480_1p0_baseband_core),
+				2);
+		INIT_INI_ARRAY(&ah->iniBB[ATH_INI_POST],
+				ar9480_1p0_baseband_postamble,
+				ARRAY_SIZE(ar9480_1p0_baseband_postamble), 5);
+
+		INIT_INI_ARRAY(&ah->iniRadio[ATH_INI_PRE], NULL, 0, 0);
+		INIT_INI_ARRAY(&ah->iniRadio[ATH_INI_CORE],
+				ar9480_1p0_radio_core,
+				ARRAY_SIZE(ar9480_1p0_radio_core), 2);
+		INIT_INI_ARRAY(&ah->iniRadio[ATH_INI_POST],
+				ar9480_1p0_radio_postamble,
+				ARRAY_SIZE(ar9480_1p0_radio_postamble), 5);
+
+		INIT_INI_ARRAY(&ah->iniSOC[ATH_INI_PRE],
+				ar9480_1p0_soc_preamble,
+				ARRAY_SIZE(ar9480_1p0_soc_preamble), 2);
+		INIT_INI_ARRAY(&ah->iniSOC[ATH_INI_CORE], NULL, 0, 0);
+		INIT_INI_ARRAY(&ah->iniSOC[ATH_INI_POST],
+				ar9480_1p0_soc_postamble,
+				ARRAY_SIZE(ar9480_1p0_soc_postamble), 5);
+
+		INIT_INI_ARRAY(&ah->iniModesRxGain,
+				ar9480_common_rx_gain_table_1p0,
+				ARRAY_SIZE(ar9480_common_rx_gain_table_1p0), 2);
+
+		/* Awake -> Sleep Setting */
+		INIT_INI_ARRAY(&ah->iniPcieSerdes,
+			ar9480_pcie_phy_clkreq_disable_L1_1p0,
+			ARRAY_SIZE(ar9480_pcie_phy_clkreq_disable_L1_1p0),
+			2);
+
+		/* Sleep -> Awake Setting */
+		INIT_INI_ARRAY(&ah->iniPcieSerdesLowPower,
+			ar9480_pcie_phy_clkreq_disable_L1_1p0,
+			ARRAY_SIZE(ar9480_pcie_phy_clkreq_disable_L1_1p0),
+			2);
+
+		INIT_INI_ARRAY(&ah->iniModesAdditional,
+				ar9480_modes_fast_clock_1p0,
+				ARRAY_SIZE(ar9480_modes_fast_clock_1p0), 3);
+		INIT_INI_ARRAY(&ah->iniCckfirJapan2484,
+				AR9480_BB_CTX_COEFJ(1p0),
+				ARRAY_SIZE(AR9480_BB_CTX_COEFJ(1p0)), 2);
+
+	} else if (AR_SREV_9480_20(ah)) {
+
+		INIT_INI_ARRAY(&ah->iniMac[ATH_INI_PRE], NULL, 0, 0);
+		INIT_INI_ARRAY(&ah->iniMac[ATH_INI_CORE], ar9480_2p0_mac_core,
+				ARRAY_SIZE(ar9480_2p0_mac_core), 2);
+		INIT_INI_ARRAY(&ah->iniMac[ATH_INI_POST],
+				ar9480_2p0_mac_postamble,
+				ARRAY_SIZE(ar9480_2p0_mac_postamble), 5);
+
+		INIT_INI_ARRAY(&ah->iniBB[ATH_INI_PRE], NULL, 0, 0);
+		INIT_INI_ARRAY(&ah->iniBB[ATH_INI_CORE],
+				ar9480_2p0_baseband_core,
+				ARRAY_SIZE(ar9480_2p0_baseband_core), 2);
+		INIT_INI_ARRAY(&ah->iniBB[ATH_INI_POST],
+				ar9480_2p0_baseband_postamble,
+				ARRAY_SIZE(ar9480_2p0_baseband_postamble), 5);
+
+		INIT_INI_ARRAY(&ah->iniRadio[ATH_INI_PRE], NULL, 0, 0);
+		INIT_INI_ARRAY(&ah->iniRadio[ATH_INI_CORE],
+				ar9480_2p0_radio_core,
+				ARRAY_SIZE(ar9480_2p0_radio_core), 2);
+		INIT_INI_ARRAY(&ah->iniRadio[ATH_INI_POST],
+				ar9480_2p0_radio_postamble,
+				ARRAY_SIZE(ar9480_2p0_radio_postamble), 5);
+		INIT_INI_ARRAY(&ah->ini_radio_post_sys2ant,
+				ar9480_2p0_radio_postamble_sys2ant,
+				ARRAY_SIZE(ar9480_2p0_radio_postamble_sys2ant),
+				5);
+
+		INIT_INI_ARRAY(&ah->iniSOC[ATH_INI_PRE],
+				ar9480_2p0_soc_preamble,
+				ARRAY_SIZE(ar9480_2p0_soc_preamble), 2);
+		INIT_INI_ARRAY(&ah->iniSOC[ATH_INI_CORE], NULL, 0, 0);
+		INIT_INI_ARRAY(&ah->iniSOC[ATH_INI_POST],
+				ar9480_2p0_soc_postamble,
+				ARRAY_SIZE(ar9480_2p0_soc_postamble), 5);
+
+		INIT_INI_ARRAY(&ah->iniModesRxGain,
+				ar9480_common_rx_gain_table_2p0,
+				ARRAY_SIZE(ar9480_common_rx_gain_table_2p0), 2);
+
+		INIT_INI_ARRAY(&ah->ini_BTCOEX_MAX_TXPWR,
+				ar9480_2p0_BTCOEX_MAX_TXPWR_table,
+				ARRAY_SIZE(ar9480_2p0_BTCOEX_MAX_TXPWR_table),
+				2);
+
+		/* Awake -> Sleep Setting */
+		INIT_INI_ARRAY(&ah->iniPcieSerdes,
+				PCIE_PLL_ON_CREQ_DIS_L1_2P0,
+				ARRAY_SIZE(PCIE_PLL_ON_CREQ_DIS_L1_2P0),
+				2);
+		/* Sleep -> Awake Setting */
+		INIT_INI_ARRAY(&ah->iniPcieSerdesLowPower,
+				PCIE_PLL_ON_CREQ_DIS_L1_2P0,
+				ARRAY_SIZE(PCIE_PLL_ON_CREQ_DIS_L1_2P0),
+				2);
+
+		/* Fast clock modal settings */
+		INIT_INI_ARRAY(&ah->iniModesAdditional,
+				ar9480_modes_fast_clock_2p0,
+				ARRAY_SIZE(ar9480_modes_fast_clock_2p0), 3);
+
+		INIT_INI_ARRAY(&ah->iniCckfirJapan2484,
+				AR9480_BB_CTX_COEFJ(2p0),
+				ARRAY_SIZE(AR9480_BB_CTX_COEFJ(2p0)), 2);
+
+		INIT_INI_ARRAY(&ah->ini_japan2484, AR9480_BBC_TXIFR_COEFFJ,
+				ARRAY_SIZE(AR9480_BBC_TXIFR_COEFFJ), 2);
+
 	} else if (AR_SREV_9580(ah)) {
 		/* mac */
 		INIT_INI_ARRAY(&ah->iniMac[ATH_INI_PRE], NULL, 0, 0);
@@ -401,6 +537,16 @@ static void ar9003_tx_gain_table_mode0(struct ath_hw *ah)
 			ar9580_1p0_lowest_ob_db_tx_gain_table,
 			ARRAY_SIZE(ar9580_1p0_lowest_ob_db_tx_gain_table),
 			5);
+	else if (AR_SREV_9480_10(ah))
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+			ar9480_modes_low_ob_db_tx_gain_table_1p0,
+			ARRAY_SIZE(ar9480_modes_low_ob_db_tx_gain_table_1p0),
+			5);
+	else if (AR_SREV_9480_20(ah))
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+			ar9480_modes_low_ob_db_tx_gain_table_2p0,
+			ARRAY_SIZE(ar9480_modes_low_ob_db_tx_gain_table_2p0),
+			5);
 	else
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
 			ar9300Modes_lowest_ob_db_tx_gain_table_2p2,
@@ -435,6 +581,16 @@ static void ar9003_tx_gain_table_mode1(struct ath_hw *ah)
 			ar9580_1p0_high_ob_db_tx_gain_table,
 			ARRAY_SIZE(ar9580_1p0_high_ob_db_tx_gain_table),
 			5);
+	else if (AR_SREV_9480_10(ah))
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+			ar9480_modes_high_ob_db_tx_gain_table_1p0,
+			ARRAY_SIZE(ar9480_modes_high_ob_db_tx_gain_table_1p0),
+			5);
+	else if (AR_SREV_9480_20(ah))
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+			ar9480_modes_high_ob_db_tx_gain_table_2p0,
+			ARRAY_SIZE(ar9480_modes_high_ob_db_tx_gain_table_2p0),
+			5);
 	else
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
 			ar9300Modes_high_ob_db_tx_gain_table_2p2,
@@ -556,6 +712,16 @@ static void ar9003_rx_gain_table_mode0(struct ath_hw *ah)
 				ar9580_1p0_rx_gain_table,
 				ARRAY_SIZE(ar9580_1p0_rx_gain_table),
 				2);
+	else if (AR_SREV_9480_10(ah))
+		INIT_INI_ARRAY(&ah->iniModesRxGain,
+				ar9480_common_rx_gain_table_1p0,
+				ARRAY_SIZE(ar9480_common_rx_gain_table_1p0),
+				2);
+	else if (AR_SREV_9480_20(ah))
+		INIT_INI_ARRAY(&ah->iniModesRxGain,
+				ar9480_common_rx_gain_table_2p0,
+				ARRAY_SIZE(ar9480_common_rx_gain_table_2p0),
+				2);
 	else
 		INIT_INI_ARRAY(&ah->iniModesRxGain,
 				ar9300Common_rx_gain_table_2p2,
@@ -585,6 +751,16 @@ static void ar9003_rx_gain_table_mode1(struct ath_hw *ah)
 			ar9485Common_wo_xlna_rx_gain_1_1,
 			ARRAY_SIZE(ar9485Common_wo_xlna_rx_gain_1_1),
 			2);
+	else if (AR_SREV_9480_10(ah))
+		INIT_INI_ARRAY(&ah->iniModesRxGain,
+			ar9480_common_wo_xlna_rx_gain_table_1p0,
+			ARRAY_SIZE(ar9480_common_wo_xlna_rx_gain_table_1p0),
+			2);
+	else if (AR_SREV_9480_20(ah))
+		INIT_INI_ARRAY(&ah->iniModesRxGain,
+			ar9480_common_wo_xlna_rx_gain_table_2p0,
+			ARRAY_SIZE(ar9480_common_wo_xlna_rx_gain_table_2p0),
+			2);
 	else if (AR_SREV_9580(ah))
 		INIT_INI_ARRAY(&ah->iniModesRxGain,
 			ar9580_1p0_wo_xlna_rx_gain_table,
@@ -597,6 +773,18 @@ static void ar9003_rx_gain_table_mode1(struct ath_hw *ah)
 			2);
 }
 
+static void ar9003_rx_gain_table_mode2(struct ath_hw *ah)
+{
+	if (AR_SREV_9480_10(ah))
+		INIT_INI_ARRAY(&ah->iniModesRxGain,
+			ar9480_common_mixed_rx_gain_table_1p0,
+			ARRAY_SIZE(ar9480_common_mixed_rx_gain_table_1p0), 2);
+	else if (AR_SREV_9480_20(ah))
+		INIT_INI_ARRAY(&ah->iniModesRxGain,
+			ar9480_common_mixed_rx_gain_table_2p0,
+			ARRAY_SIZE(ar9480_common_mixed_rx_gain_table_2p0), 2);
+}
+
 static void ar9003_rx_gain_table_apply(struct ath_hw *ah)
 {
 	switch (ar9003_hw_get_rx_gain_idx(ah)) {
@@ -607,6 +795,9 @@ static void ar9003_rx_gain_table_apply(struct ath_hw *ah)
 	case 1:
 		ar9003_rx_gain_table_mode1(ah);
 		break;
+	case 2:
+		ar9003_rx_gain_table_mode2(ah);
+		break;
 	}
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
index f80d1d6..8ebd414 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
@@ -147,7 +147,7 @@ static int ar9003_paprd_setup_single_table(struct ath_hw *ah)
 		AR_PHY_PAPRD_CTRL1_B2
 	};
 	int training_power;
-	int i;
+	int i, val;
 
 	if (IS_CHAN_2GHZ(ah->curchan))
 		training_power = ar9003_get_training_power_2g(ah);
@@ -207,8 +207,9 @@ static int ar9003_paprd_setup_single_table(struct ath_hw *ah)
 		      AR_PHY_PAPRD_TRAINER_CNTL1_CF_PAPRD_AGC2_SETTLING, 28);
 	REG_RMW_FIELD(ah, AR_PHY_PAPRD_TRAINER_CNTL1,
 		      AR_PHY_PAPRD_TRAINER_CNTL1_CF_CF_PAPRD_TRAIN_ENABLE, 1);
+	val = AR_SREV_9480(ah) ? 0x91 : 147;
 	REG_RMW_FIELD(ah, AR_PHY_PAPRD_TRAINER_CNTL2,
-		      AR_PHY_PAPRD_TRAINER_CNTL2_CF_PAPRD_INIT_RX_BB_GAIN, 147);
+		      AR_PHY_PAPRD_TRAINER_CNTL2_CF_PAPRD_INIT_RX_BB_GAIN, val);
 	REG_RMW_FIELD(ah, AR_PHY_PAPRD_TRAINER_CNTL3,
 		      AR_PHY_PAPRD_TRAINER_CNTL3_CF_PAPRD_FINE_CORR_LEN, 4);
 	REG_RMW_FIELD(ah, AR_PHY_PAPRD_TRAINER_CNTL3,
@@ -217,7 +218,7 @@ static int ar9003_paprd_setup_single_table(struct ath_hw *ah)
 		      AR_PHY_PAPRD_TRAINER_CNTL3_CF_PAPRD_NUM_CORR_STAGES, 7);
 	REG_RMW_FIELD(ah, AR_PHY_PAPRD_TRAINER_CNTL3,
 		      AR_PHY_PAPRD_TRAINER_CNTL3_CF_PAPRD_MIN_LOOPBACK_DEL, 1);
-	if (AR_SREV_9485(ah))
+	if (AR_SREV_9485(ah) || AR_SREV_9480(ah))
 		REG_RMW_FIELD(ah, AR_PHY_PAPRD_TRAINER_CNTL3,
 			      AR_PHY_PAPRD_TRAINER_CNTL3_CF_PAPRD_QUICK_DROP,
 			      -3);
@@ -225,9 +226,10 @@ static int ar9003_paprd_setup_single_table(struct ath_hw *ah)
 		REG_RMW_FIELD(ah, AR_PHY_PAPRD_TRAINER_CNTL3,
 			      AR_PHY_PAPRD_TRAINER_CNTL3_CF_PAPRD_QUICK_DROP,
 			      -6);
+	val = AR_SREV_9480(ah) ? -10 : -15;
 	REG_RMW_FIELD(ah, AR_PHY_PAPRD_TRAINER_CNTL3,
 		      AR_PHY_PAPRD_TRAINER_CNTL3_CF_PAPRD_ADC_DESIRED_SIZE,
-		      -15);
+		      val);
 	REG_RMW_FIELD(ah, AR_PHY_PAPRD_TRAINER_CNTL3,
 		      AR_PHY_PAPRD_TRAINER_CNTL3_CF_PAPRD_BBTXMIX_DISABLE, 1);
 	REG_RMW_FIELD(ah, AR_PHY_PAPRD_TRAINER_CNTL4,
@@ -757,6 +759,7 @@ void ar9003_paprd_populate_single_table(struct ath_hw *ah,
 			      training_power);
 
 	if (ah->caps.tx_chainmask & BIT(2))
+		/* val AR_PHY_PAPRD_CTRL1_PAPRD_POWER_AT_AM2AM_CAL correct? */
 		REG_RMW_FIELD(ah, AR_PHY_PAPRD_CTRL1_B2,
 			      AR_PHY_PAPRD_CTRL1_PAPRD_POWER_AT_AM2AM_CAL,
 			      training_power);
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 2f35aee..4956d09 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -559,6 +559,9 @@ static void ar9003_hw_set_chain_masks(struct ath_hw *ah, u8 rx, u8 tx)
 
 	if ((ah->caps.hw_caps & ATH9K_HW_CAP_APM) && (tx == 0x7))
 		REG_WRITE(ah, AR_SELFGEN_MASK, 0x3);
+	else if (AR_SREV_9480(ah))
+		/* xxx only when MCI support is enabled */
+		REG_WRITE(ah, AR_SELFGEN_MASK, 0x3);
 	else
 		REG_WRITE(ah, AR_SELFGEN_MASK, tx);
 
@@ -658,6 +661,10 @@ static int ar9003_hw_process_ini(struct ath_hw *ah,
 		ar9003_hw_prog_ini(ah, &ah->iniMac[i], modesIndex);
 		ar9003_hw_prog_ini(ah, &ah->iniBB[i], modesIndex);
 		ar9003_hw_prog_ini(ah, &ah->iniRadio[i], modesIndex);
+		if (i == ATH_INI_POST && AR_SREV_9480_20(ah))
+			ar9003_hw_prog_ini(ah,
+					   &ah->ini_radio_post_sys2ant,
+					   modesIndex);
 	}
 
 	REG_WRITE_ARRAY(&ah->iniModesRxGain, 1, regWrites);
@@ -677,6 +684,9 @@ static int ar9003_hw_process_ini(struct ath_hw *ah,
 	if (AR_SREV_9340(ah) && !ah->is_clk_25mhz)
 		REG_WRITE_ARRAY(&ah->iniModesAdditional_40M, 1, regWrites);
 
+	if (AR_SREV_9480(ah))
+		ar9003_hw_prog_ini(ah, &ah->ini_BTCOEX_MAX_TXPWR, 1);
+
 	ar9003_hw_override_ini(ah);
 	ar9003_hw_set_channel_regs(ah, chan);
 	ar9003_hw_set_chain_masks(ah, ah->rxchainmask, ah->txchainmask);
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 3a16ba2..7f9a4e5 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -580,6 +580,7 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 	case AR_SREV_VERSION_9330:
 	case AR_SREV_VERSION_9485:
 	case AR_SREV_VERSION_9340:
+	case AR_SREV_VERSION_9480:
 		break;
 	default:
 		ath_err(common,
@@ -664,6 +665,7 @@ int ath9k_hw_init(struct ath_hw *ah)
 	case AR9300_DEVID_AR9330:
 	case AR9300_DEVID_AR9340:
 	case AR9300_DEVID_AR9580:
+	case AR9300_DEVID_AR9480:
 		break;
 	default:
 		if (common->bus_ops->ath_bus_type == ATH_USB)
@@ -1336,6 +1338,7 @@ static bool ath9k_hw_set_reset_power_on(struct ath_hw *ah)
 
 static bool ath9k_hw_set_reset_reg(struct ath_hw *ah, u32 type)
 {
+
 	if (AR_SREV_9300_20_OR_LATER(ah)) {
 		REG_WRITE(ah, AR_WA, ah->WARegVal);
 		udelay(10);
@@ -1742,25 +1745,41 @@ static void ath9k_set_power_sleep(struct ath_hw *ah, int setChip)
 {
 	REG_SET_BIT(ah, AR_STA_ID1, AR_STA_ID1_PWR_SAV);
 	if (setChip) {
+		if (AR_SREV_9480(ah)) {
+			REG_WRITE(ah, AR_TIMER_MODE,
+				  REG_READ(ah, AR_TIMER_MODE) & 0xFFFFFF00);
+			REG_WRITE(ah, AR_NDP2_TIMER_MODE, REG_READ(ah,
+				  AR_NDP2_TIMER_MODE) & 0xFFFFFF00);
+			REG_WRITE(ah, AR_SLP32_INC,
+				  REG_READ(ah, AR_SLP32_INC) & 0xFFF00000);
+			/* xxx Required for WLAN only case ? */
+			REG_WRITE(ah, AR_MCI_INTERRUPT_RX_MSG_EN, 0);
+			udelay(100);
+		}
+
 		/*
 		 * Clear the RTC force wake bit to allow the
 		 * mac to go to sleep.
 		 */
-		REG_CLR_BIT(ah, AR_RTC_FORCE_WAKE,
-			    AR_RTC_FORCE_WAKE_EN);
+		REG_CLR_BIT(ah, AR_RTC_FORCE_WAKE, AR_RTC_FORCE_WAKE_EN);
+
+		if (AR_SREV_9480(ah))
+			udelay(100);
+
 		if (!AR_SREV_9100(ah) && !AR_SREV_9300_20_OR_LATER(ah))
 			REG_WRITE(ah, AR_RC, AR_RC_AHB | AR_RC_HOSTIF);
 
 		/* Shutdown chip. Active low */
-		if (!AR_SREV_5416(ah) && !AR_SREV_9271(ah))
-			REG_CLR_BIT(ah, (AR_RTC_RESET),
-				    AR_RTC_RESET_EN);
+		if (!AR_SREV_5416(ah) &&
+				!AR_SREV_9271(ah) && !AR_SREV_9480_10(ah)) {
+			REG_CLR_BIT(ah, AR_RTC_RESET, AR_RTC_RESET_EN);
+			udelay(2);
+		}
 	}
 
 	/* Clear Bit 14 of AR_WA after putting chip into Full Sleep mode. */
-	if (AR_SREV_9300_20_OR_LATER(ah))
-		REG_WRITE(ah, AR_WA,
-			  ah->WARegVal & ~AR_WA_D3_L1_DISABLE);
+	if (!AR_SREV_9480(ah))
+		REG_WRITE(ah, AR_WA, ah->WARegVal & ~AR_WA_D3_L1_DISABLE);
 }
 
 /*
@@ -1770,6 +1789,8 @@ static void ath9k_set_power_sleep(struct ath_hw *ah, int setChip)
  */
 static void ath9k_set_power_network_sleep(struct ath_hw *ah, int setChip)
 {
+	u32 val;
+
 	REG_SET_BIT(ah, AR_STA_ID1, AR_STA_ID1_PWR_SAV);
 	if (setChip) {
 		struct ath9k_hw_capabilities *pCap = &ah->caps;
@@ -1779,12 +1800,30 @@ static void ath9k_set_power_network_sleep(struct ath_hw *ah, int setChip)
 			REG_WRITE(ah, AR_RTC_FORCE_WAKE,
 				  AR_RTC_FORCE_WAKE_ON_INT);
 		} else {
+
+			/* When chip goes into network sleep, it could be waken
+			 * up by MCI_INT interrupt caused by BT's HW messages
+			 * (LNA_xxx, CONT_xxx) which chould be in a very fast
+			 * rate (~100us). This will cause chip to leave and
+			 * re-enter network sleep mode frequently, which in
+			 * consequence will have WLAN MCI HW to generate lots of
+			 * SYS_WAKING and SYS_SLEEPING messages which will make
+			 * BT CPU to busy to process.
+			 */
+			if (AR_SREV_9480(ah)) {
+				val = REG_READ(ah, AR_MCI_INTERRUPT_RX_MSG_EN) &
+					~AR_MCI_INTERRUPT_RX_HW_MSG_MASK;
+				REG_WRITE(ah, AR_MCI_INTERRUPT_RX_MSG_EN, val);
+			}
 			/*
 			 * Clear the RTC force wake bit to allow the
 			 * mac to go to sleep.
 			 */
 			REG_CLR_BIT(ah, AR_RTC_FORCE_WAKE,
 				    AR_RTC_FORCE_WAKE_EN);
+
+			if (AR_SREV_9480(ah))
+				udelay(30);
 		}
 	}
 
@@ -2401,6 +2440,9 @@ void ath9k_hw_setrxfilter(struct ath_hw *ah, u32 bits)
 
 	ENABLE_REGWRITE_BUFFER(ah);
 
+	if (AR_SREV_9480(ah))
+		bits |= ATH9K_RX_FILTER_CONTROL_WRAPPER;
+
 	REG_WRITE(ah, AR_RX_FILTER, bits);
 
 	phybits = 0;
@@ -2657,6 +2699,20 @@ void ath9k_hw_gen_timer_start(struct ath_hw *ah,
 	REG_SET_BIT(ah, gen_tmr_configuration[timer->index].mode_addr,
 		    gen_tmr_configuration[timer->index].mode_mask);
 
+	if (AR_SREV_9480(ah)) {
+		/*
+		 * Starting from AR9480, each generic timer can select which tsf
+		 * to use. But we still follow the old rule, 0 - 7 use tsf and
+		 * 8 - 15  use tsf2.
+		 */
+		if ((timer->index < AR_GEN_TIMER_BANK_1_LEN))
+			REG_CLR_BIT(ah, AR_MAC_PCU_GEN_TIMER_TSF_SEL,
+				       (1 << timer->index));
+		else
+			REG_SET_BIT(ah, AR_MAC_PCU_GEN_TIMER_TSF_SEL,
+				       (1 << timer->index));
+	}
+
 	/* Enable both trigger and thresh interrupt masks */
 	REG_SET_BIT(ah, AR_IMR_S5,
 		(SM(AR_GENTMR_BIT(timer->index), AR_IMR_S5_GENTIMER_THRESH) |
@@ -2762,6 +2818,7 @@ static struct {
 	{ AR_SREV_VERSION_9330,         "9330" },
 	{ AR_SREV_VERSION_9340,		"9340" },
 	{ AR_SREV_VERSION_9485,         "9485" },
+	{ AR_SREV_VERSION_9480,         "9480" },
 };
 
 /* For devices with external radios */
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 891661a..bda2233 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -33,6 +33,7 @@ static DEFINE_PCI_DEVICE_TABLE(ath_pci_id_table) = {
 	{ PCI_VDEVICE(ATHEROS, 0x0030) }, /* PCI-E  AR9300 */
 	{ PCI_VDEVICE(ATHEROS, 0x0032) }, /* PCI-E  AR9485 */
 	{ PCI_VDEVICE(ATHEROS, 0x0033) }, /* PCI-E  AR9580 */
+	{ PCI_VDEVICE(ATHEROS, 0x0034) }, /* PCI-E  AR9480 */
 	{ 0 }
 };
 
-- 
1.7.0.4

