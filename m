Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:47389 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539Ab3LaCrP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Dec 2013 21:47:15 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2 5/5] ath9k: Add hardware support for QCA9531
Date: Tue, 31 Dec 2013 08:12:02 +0530
Message-Id: <1388457722-29643-5-git-send-email-sujith@msujith.org> (sfid-20131231_034721_002910_F0A2286B)
In-Reply-To: <1388457722-29643-1-git-send-email-sujith@msujith.org>
References: <1388457722-29643-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 13 ++++---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c    | 14 ++++---
 drivers/net/wireless/ath/ath9k/hw.c            | 52 ++++++++++++++++++++------
 drivers/net/wireless/ath/ath9k/recv.c          |  2 +-
 4 files changed, 57 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index c8d22ec..25243cb 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3598,7 +3598,7 @@ static void ar9003_hw_ant_ctrl_apply(struct ath_hw *ah, bool is2ghz)
 	if (AR_SREV_9462(ah) || AR_SREV_9565(ah)) {
 		REG_RMW_FIELD(ah, AR_PHY_SWITCH_COM,
 				AR_SWITCH_TABLE_COM_AR9462_ALL, value);
-	} else if (AR_SREV_9550(ah)) {
+	} else if (AR_SREV_9550(ah) || AR_SREV_9531(ah)) {
 		REG_RMW_FIELD(ah, AR_PHY_SWITCH_COM,
 				AR_SWITCH_TABLE_COM_AR9550_ALL, value);
 	} else
@@ -3975,7 +3975,7 @@ static void ar9003_hw_apply_tuning_caps(struct ath_hw *ah)
 	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
 	u8 tuning_caps_param = eep->baseEepHeader.params_for_tuning_caps[0];
 
-	if (AR_SREV_9340(ah))
+	if (AR_SREV_9340(ah) || AR_SREV_9531(ah))
 		return;
 
 	if (eep->baseEepHeader.featureEnable & 0x40) {
@@ -4030,7 +4030,10 @@ static void ar9003_hw_xpa_timing_control_apply(struct ath_hw *ah, bool is2ghz)
 	if (!(eep->baseEepHeader.featureEnable & 0x80))
 		return;
 
-	if (!AR_SREV_9300(ah) && !AR_SREV_9340(ah) && !AR_SREV_9580(ah))
+	if (!AR_SREV_9300(ah) &&
+	    !AR_SREV_9340(ah) &&
+	    !AR_SREV_9580(ah) &&
+	    !AR_SREV_9531(ah))
 		return;
 
 	xpa_ctl = ar9003_modal_header(ah, is2ghz)->txFrameToXpaOn;
@@ -4163,7 +4166,7 @@ static void ath9k_hw_ar9300_set_board_values(struct ath_hw *ah,
 	ar9003_hw_xlna_bias_strength_apply(ah, is2ghz);
 	ar9003_hw_atten_apply(ah, chan);
 	ar9003_hw_quick_drop_apply(ah, chan->channel);
-	if (!AR_SREV_9330(ah) && !AR_SREV_9340(ah))
+	if (!AR_SREV_9330(ah) && !AR_SREV_9340(ah) && !AR_SREV_9531(ah))
 		ar9003_hw_internal_regulator_apply(ah);
 	ar9003_hw_apply_tuning_caps(ah);
 	ar9003_hw_apply_minccapwr_thresh(ah, chan);
@@ -4788,7 +4791,7 @@ static void ar9003_hw_power_control_override(struct ath_hw *ah,
 	}
 
 tempslope:
-	if (AR_SREV_9550(ah)) {
+	if (AR_SREV_9550(ah) || AR_SREV_9531(ah)) {
 		/*
 		 * AR955x has tempSlope register for each chain.
 		 * Check whether temp_compensation feature is enabled or not.
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 9b1494c..09facba 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -103,7 +103,7 @@ static int ar9003_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
 			} else {
 				channelSel = CHANSEL_2G(freq) >> 1;
 			}
-		} else if (AR_SREV_9550(ah)) {
+		} else if (AR_SREV_9550(ah) || AR_SREV_9531(ah)) {
 			if (ah->is_clk_25mhz)
 				div = 75;
 			else
@@ -118,7 +118,7 @@ static int ar9003_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
 		/* Set to 2G mode */
 		bMode = 1;
 	} else {
-		if ((AR_SREV_9340(ah) || AR_SREV_9550(ah)) &&
+		if ((AR_SREV_9340(ah) || AR_SREV_9550(ah) || AR_SREV_9531(ah)) &&
 		    ah->is_clk_25mhz) {
 			channelSel = freq / 75;
 			chan_frac = ((freq % 75) * 0x20000) / 75;
@@ -810,10 +810,12 @@ static int ar9003_hw_process_ini(struct ath_hw *ah,
 	/*
 	 * TXGAIN initvals.
 	 */
-	if (AR_SREV_9550(ah)) {
-		int modes_txgain_index;
+	if (AR_SREV_9550(ah) || AR_SREV_9531(ah)) {
+		int modes_txgain_index = 1;
+
+		if (AR_SREV_9550(ah))
+			modes_txgain_index = ar9550_hw_get_modes_txgain_index(ah, chan);
 
-		modes_txgain_index = ar9550_hw_get_modes_txgain_index(ah, chan);
 		if (modes_txgain_index < 0)
 			return -EINVAL;
 
@@ -1862,7 +1864,7 @@ bool ar9003_hw_bb_watchdog_check(struct ath_hw *ah)
 	case 0x04000b09:
 		return true;
 	case 0x04000409:
-		if (AR_SREV_9340(ah))
+		if (AR_SREV_9340(ah) || AR_SREV_9531(ah))
 			return false;
 		else
 			return true;
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 2525cb1..f6a2e1b 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -757,7 +757,7 @@ static void ath9k_hw_init_pll(struct ath_hw *ah,
 		/* program BB PLL phase_shift */
 		REG_RMW_FIELD(ah, AR_CH0_BB_DPLL3,
 			      AR_CH0_BB_DPLL3_PHASE_SHIFT, 0x1);
-	} else if (AR_SREV_9340(ah) || AR_SREV_9550(ah)) {
+	} else if (AR_SREV_9340(ah) || AR_SREV_9550(ah) || AR_SREV_9531(ah)) {
 		u32 regval, pll2_divint, pll2_divfrac, refdiv;
 
 		REG_WRITE(ah, AR_RTC_PLL_CONTROL, 0x1142c);
@@ -767,9 +767,15 @@ static void ath9k_hw_init_pll(struct ath_hw *ah,
 		udelay(100);
 
 		if (ah->is_clk_25mhz) {
-			pll2_divint = 0x54;
-			pll2_divfrac = 0x1eb85;
-			refdiv = 3;
+			if (AR_SREV_9531(ah)) {
+				pll2_divint = 0x1c;
+				pll2_divfrac = 0xa3d2;
+				refdiv = 1;
+			} else {
+				pll2_divint = 0x54;
+				pll2_divfrac = 0x1eb85;
+				refdiv = 3;
+			}
 		} else {
 			if (AR_SREV_9340(ah)) {
 				pll2_divint = 88;
@@ -783,7 +789,10 @@ static void ath9k_hw_init_pll(struct ath_hw *ah,
 		}
 
 		regval = REG_READ(ah, AR_PHY_PLL_MODE);
-		regval |= (0x1 << 16);
+		if (AR_SREV_9531(ah))
+			regval |= (0x1 << 22);
+		else
+			regval |= (0x1 << 16);
 		REG_WRITE(ah, AR_PHY_PLL_MODE, regval);
 		udelay(100);
 
@@ -793,14 +802,33 @@ static void ath9k_hw_init_pll(struct ath_hw *ah,
 
 		regval = REG_READ(ah, AR_PHY_PLL_MODE);
 		if (AR_SREV_9340(ah))
-			regval = (regval & 0x80071fff) | (0x1 << 30) |
-				 (0x1 << 13) | (0x4 << 26) | (0x18 << 19);
+			regval = (regval & 0x80071fff) |
+				(0x1 << 30) |
+				(0x1 << 13) |
+				(0x4 << 26) |
+				(0x18 << 19);
+		else if (AR_SREV_9531(ah))
+			regval = (regval & 0x01c00fff) |
+				(0x1 << 31) |
+				(0x2 << 29) |
+				(0xa << 25) |
+				(0x1 << 19) |
+				(0x6 << 12);
 		else
-			regval = (regval & 0x80071fff) | (0x3 << 30) |
-				 (0x1 << 13) | (0x4 << 26) | (0x60 << 19);
+			regval = (regval & 0x80071fff) |
+				(0x3 << 30) |
+				(0x1 << 13) |
+				(0x4 << 26) |
+				(0x60 << 19);
 		REG_WRITE(ah, AR_PHY_PLL_MODE, regval);
-		REG_WRITE(ah, AR_PHY_PLL_MODE,
-			  REG_READ(ah, AR_PHY_PLL_MODE) & 0xfffeffff);
+
+		if (AR_SREV_9531(ah))
+			REG_WRITE(ah, AR_PHY_PLL_MODE,
+				  REG_READ(ah, AR_PHY_PLL_MODE) & 0xffbfffff);
+		else
+			REG_WRITE(ah, AR_PHY_PLL_MODE,
+				  REG_READ(ah, AR_PHY_PLL_MODE) & 0xfffeffff);
+
 		udelay(1000);
 	}
 
@@ -1614,7 +1642,7 @@ static void ath9k_hw_init_desc(struct ath_hw *ah)
 		}
 #ifdef __BIG_ENDIAN
 		else if (AR_SREV_9330(ah) || AR_SREV_9340(ah) ||
-			 AR_SREV_9550(ah))
+			 AR_SREV_9550(ah) || AR_SREV_9531(ah))
 			REG_RMW(ah, AR_CFG, AR_CFG_SWRB | AR_CFG_SWTB, 0);
 		else
 			REG_WRITE(ah, AR_CFG, AR_CFG_SWTD | AR_CFG_SWRD);
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 470e1c0..bd7daf5 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -419,7 +419,7 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
 		rfilt |= ATH9K_RX_FILTER_MCAST_BCAST_ALL;
 	}
 
-	if (AR_SREV_9550(sc->sc_ah))
+	if (AR_SREV_9550(sc->sc_ah) || AR_SREV_9531(sc->sc_ah))
 		rfilt |= ATH9K_RX_FILTER_4ADDRESS;
 
 	return rfilt;
-- 
1.8.5.2

