Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:42559 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbaLSBCL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2014 20:02:11 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@qca.qualcomm.com
Subject: [PATCH 5/5] ath9k: Add QCA956x HW support
Date: Fri, 19 Dec 2014 06:33:59 +0530
Message-Id: <1418951039-12309-6-git-send-email-sujith@msujith.org> (sfid-20141219_020221_463610_1014CF43)
In-Reply-To: <1418951039-12309-1-git-send-email-sujith@msujith.org>
References: <1418951039-12309-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Miaoqing Pan <miaoqing@qca.qualcomm.com>

Signed-off-by: Miaoqing Pan <miaoqing@qca.qualcomm.com>
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ani.c           |  3 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 15 +++++---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c    | 47 ++++++++++++++++++++------
 drivers/net/wireless/ath/ath9k/hw.c            | 37 ++++++++++++--------
 drivers/net/wireless/ath/ath9k/mac.c           |  3 +-
 drivers/net/wireless/ath/ath9k/recv.c          |  3 +-
 6 files changed, 76 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index ba502a2..ca01d17 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -259,7 +259,8 @@ static void ath9k_hw_set_cck_nil(struct ath_hw *ah, u_int8_t immunityLevel,
 				     entry_cck->fir_step_level);
 
 	/* Skip MRC CCK for pre AR9003 families */
-	if (!AR_SREV_9300_20_OR_LATER(ah) || AR_SREV_9485(ah) || AR_SREV_9565(ah))
+	if (!AR_SREV_9300_20_OR_LATER(ah) || AR_SREV_9485(ah) ||
+	    AR_SREV_9565(ah) || AR_SREV_9561(ah))
 		return;
 
 	if (aniState->mrcCCK != entry_cck->mrc_cck_on)
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 08225a0..8b4561e 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3536,7 +3536,7 @@ static void ar9003_hw_xpa_bias_level_apply(struct ath_hw *ah, bool is2ghz)
 	int bias = ar9003_modal_header(ah, is2ghz)->xpaBiasLvl;
 
 	if (AR_SREV_9485(ah) || AR_SREV_9330(ah) || AR_SREV_9340(ah) ||
-	    AR_SREV_9531(ah))
+	    AR_SREV_9531(ah) || AR_SREV_9561(ah))
 		REG_RMW_FIELD(ah, AR_CH0_TOP2, AR_CH0_TOP2_XPABIASLVL, bias);
 	else if (AR_SREV_9462(ah) || AR_SREV_9550(ah) || AR_SREV_9565(ah))
 		REG_RMW_FIELD(ah, AR_CH0_TOP, AR_CH0_TOP_XPABIASLVL, bias);
@@ -3599,7 +3599,7 @@ static void ar9003_hw_ant_ctrl_apply(struct ath_hw *ah, bool is2ghz)
 	if (AR_SREV_9462(ah) || AR_SREV_9565(ah)) {
 		REG_RMW_FIELD(ah, AR_PHY_SWITCH_COM,
 				AR_SWITCH_TABLE_COM_AR9462_ALL, value);
-	} else if (AR_SREV_9550(ah) || AR_SREV_9531(ah)) {
+	} else if (AR_SREV_9550(ah) || AR_SREV_9531(ah) || AR_SREV_9561(ah)) {
 		REG_RMW_FIELD(ah, AR_PHY_SWITCH_COM,
 				AR_SWITCH_TABLE_COM_AR9550_ALL, value);
 	} else
@@ -3929,9 +3929,13 @@ void ar9003_hw_internal_regulator_apply(struct ath_hw *ah)
 			REG_WRITE(ah, AR_PHY_PMU2, reg_pmu_set);
 			if (!is_pmu_set(ah, AR_PHY_PMU2, reg_pmu_set))
 				return;
-		} else if (AR_SREV_9462(ah) || AR_SREV_9565(ah)) {
+		} else if (AR_SREV_9462(ah) || AR_SREV_9565(ah) ||
+			   AR_SREV_9561(ah)) {
 			reg_val = le32_to_cpu(pBase->swreg);
 			REG_WRITE(ah, AR_PHY_PMU1, reg_val);
+
+			if (AR_SREV_9561(ah))
+				REG_WRITE(ah, AR_PHY_PMU2, 0x10200000);
 		} else {
 			/* Internal regulator is ON. Write swreg register. */
 			reg_val = le32_to_cpu(pBase->swreg);
@@ -4034,7 +4038,8 @@ static void ar9003_hw_xpa_timing_control_apply(struct ath_hw *ah, bool is2ghz)
 	if (!AR_SREV_9300(ah) &&
 	    !AR_SREV_9340(ah) &&
 	    !AR_SREV_9580(ah) &&
-	    !AR_SREV_9531(ah))
+	    !AR_SREV_9531(ah) &&
+	    !AR_SREV_9561(ah))
 		return;
 
 	xpa_ctl = ar9003_modal_header(ah, is2ghz)->txFrameToXpaOn;
@@ -4812,7 +4817,7 @@ static void ar9003_hw_power_control_override(struct ath_hw *ah,
 	}
 
 tempslope:
-	if (AR_SREV_9550(ah) || AR_SREV_9531(ah)) {
+	if (AR_SREV_9550(ah) || AR_SREV_9531(ah) || AR_SREV_9561(ah)) {
 		u8 txmask = (eep->baseEepHeader.txrxMask & 0xf0) >> 4;
 
 		/*
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index ae6cde2..1ad66b7 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -183,7 +183,8 @@ static int ar9003_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
 			} else {
 				channelSel = CHANSEL_2G(freq) >> 1;
 			}
-		} else if (AR_SREV_9550(ah) || AR_SREV_9531(ah)) {
+		} else if (AR_SREV_9550(ah) || AR_SREV_9531(ah) ||
+			   AR_SREV_9561(ah)) {
 			if (ah->is_clk_25mhz)
 				div = 75;
 			else
@@ -198,7 +199,8 @@ static int ar9003_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
 		/* Set to 2G mode */
 		bMode = 1;
 	} else {
-		if ((AR_SREV_9340(ah) || AR_SREV_9550(ah) || AR_SREV_9531(ah)) &&
+		if ((AR_SREV_9340(ah) || AR_SREV_9550(ah) ||
+		     AR_SREV_9531(ah) || AR_SREV_9561(ah)) &&
 		    ah->is_clk_25mhz) {
 			channelSel = freq / 75;
 			chan_frac = ((freq % 75) * 0x20000) / 75;
@@ -265,7 +267,7 @@ static void ar9003_hw_spur_mitigate_mrc_cck(struct ath_hw *ah,
 	 */
 
 	if (AR_SREV_9485(ah) || AR_SREV_9340(ah) || AR_SREV_9330(ah) ||
-	    AR_SREV_9550(ah)) {
+	    AR_SREV_9550(ah) || AR_SREV_9561(ah)) {
 		if (spur_fbin_ptr[0] == 0) /* No spur */
 			return;
 		max_spur_cnts = 5;
@@ -292,7 +294,7 @@ static void ar9003_hw_spur_mitigate_mrc_cck(struct ath_hw *ah,
 
 		negative = 0;
 		if (AR_SREV_9485(ah) || AR_SREV_9340(ah) || AR_SREV_9330(ah) ||
-		    AR_SREV_9550(ah))
+		    AR_SREV_9550(ah) || AR_SREV_9561(ah))
 			cur_bb_spur = ath9k_hw_fbin2freq(spur_fbin_ptr[i],
 							 IS_CHAN_2GHZ(chan));
 		else
@@ -641,8 +643,10 @@ static void ar9003_hw_set_channel_regs(struct ath_hw *ah,
 		(REG_READ(ah, AR_PHY_GEN_CTRL) & AR_PHY_GC_ENABLE_DAC_FIFO);
 
 	/* Enable 11n HT, 20 MHz */
-	phymode = AR_PHY_GC_HT_EN | AR_PHY_GC_SINGLE_HT_LTF1 |
-		  AR_PHY_GC_SHORT_GI_40 | enableDacFifo;
+	phymode = AR_PHY_GC_HT_EN | AR_PHY_GC_SHORT_GI_40 | enableDacFifo;
+
+	if (!AR_SREV_9561(ah))
+		phymode |= AR_PHY_GC_SINGLE_HT_LTF1;
 
 	/* Configure baseband for dynamic 20/40 operation */
 	if (IS_CHAN_HT40(chan)) {
@@ -745,7 +749,8 @@ static void ar9003_hw_override_ini(struct ath_hw *ah)
 	else
 		ah->enabled_cals &= ~TX_CL_CAL;
 
-	if (AR_SREV_9340(ah) || AR_SREV_9531(ah) || AR_SREV_9550(ah)) {
+	if (AR_SREV_9340(ah) || AR_SREV_9531(ah) || AR_SREV_9550(ah) ||
+	    AR_SREV_9561(ah)) {
 		if (ah->is_clk_25mhz) {
 			REG_WRITE(ah, AR_RTC_DERIVED_CLK, 0x17c << 1);
 			REG_WRITE(ah, AR_SLP32_MODE, 0x0010f3d7);
@@ -812,6 +817,19 @@ static int ar9550_hw_get_modes_txgain_index(struct ath_hw *ah,
 	return ret;
 }
 
+static int ar9561_hw_get_modes_txgain_index(struct ath_hw *ah,
+					    struct ath9k_channel *chan)
+{
+	if (IS_CHAN_2GHZ(chan)) {
+		if (IS_CHAN_HT40(chan))
+			return 1;
+		else
+			return 2;
+	}
+
+	return 0;
+}
+
 static void ar9003_doubler_fix(struct ath_hw *ah)
 {
 	if (AR_SREV_9300(ah) || AR_SREV_9580(ah) || AR_SREV_9550(ah)) {
@@ -911,21 +929,29 @@ static int ar9003_hw_process_ini(struct ath_hw *ah,
 			REG_WRITE_ARRAY(&ah->ini_modes_rxgain_5g_xlna,
 					modesIndex, regWrites);
 		}
+
+		if (AR_SREV_9561(ah) && (ar9003_hw_get_rx_gain_idx(ah) == 0))
+			REG_WRITE_ARRAY(&ah->ini_modes_rxgain_5g_xlna,
+					modesIndex, regWrites);
 	}
 
-	if (AR_SREV_9550(ah))
+	if (AR_SREV_9550(ah) || AR_SREV_9561(ah))
 		REG_WRITE_ARRAY(&ah->ini_modes_rx_gain_bounds, modesIndex,
 				regWrites);
 
 	/*
 	 * TXGAIN initvals.
 	 */
-	if (AR_SREV_9550(ah) || AR_SREV_9531(ah)) {
+	if (AR_SREV_9550(ah) || AR_SREV_9531(ah) || AR_SREV_9561(ah)) {
 		int modes_txgain_index = 1;
 
 		if (AR_SREV_9550(ah))
 			modes_txgain_index = ar9550_hw_get_modes_txgain_index(ah, chan);
 
+		if (AR_SREV_9561(ah))
+			modes_txgain_index =
+				ar9561_hw_get_modes_txgain_index(ah, chan);
+
 		if (modes_txgain_index < 0)
 			return -EINVAL;
 
@@ -1989,7 +2015,8 @@ void ar9003_hw_attach_phy_ops(struct ath_hw *ah)
 	priv_ops->rf_set_freq = ar9003_hw_set_channel;
 	priv_ops->spur_mitigate_freq = ar9003_hw_spur_mitigate;
 
-	if (AR_SREV_9340(ah) || AR_SREV_9550(ah) || AR_SREV_9531(ah))
+	if (AR_SREV_9340(ah) || AR_SREV_9550(ah) || AR_SREV_9531(ah) ||
+	    AR_SREV_9561(ah))
 		priv_ops->compute_pll_control = ar9003_hw_compute_pll_control_soc;
 	else
 		priv_ops->compute_pll_control = ar9003_hw_compute_pll_control;
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 49510ff..3a4559d 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -780,7 +780,8 @@ static void ath9k_hw_init_pll(struct ath_hw *ah,
 		/* program BB PLL phase_shift */
 		REG_RMW_FIELD(ah, AR_CH0_BB_DPLL3,
 			      AR_CH0_BB_DPLL3_PHASE_SHIFT, 0x1);
-	} else if (AR_SREV_9340(ah) || AR_SREV_9550(ah) || AR_SREV_9531(ah)) {
+	} else if (AR_SREV_9340(ah) || AR_SREV_9550(ah) || AR_SREV_9531(ah) ||
+		   AR_SREV_9561(ah)) {
 		u32 regval, pll2_divint, pll2_divfrac, refdiv;
 
 		REG_WRITE(ah, AR_RTC_PLL_CONTROL,
@@ -791,7 +792,7 @@ static void ath9k_hw_init_pll(struct ath_hw *ah,
 		udelay(100);
 
 		if (ah->is_clk_25mhz) {
-			if (AR_SREV_9531(ah)) {
+			if (AR_SREV_9531(ah) || AR_SREV_9561(ah)) {
 				pll2_divint = 0x1c;
 				pll2_divfrac = 0xa3d2;
 				refdiv = 1;
@@ -807,14 +808,15 @@ static void ath9k_hw_init_pll(struct ath_hw *ah,
 				refdiv = 5;
 			} else {
 				pll2_divint = 0x11;
-				pll2_divfrac =
-					AR_SREV_9531(ah) ? 0x26665 : 0x26666;
+				pll2_divfrac = (AR_SREV_9531(ah) ||
+						AR_SREV_9561(ah)) ?
+						0x26665 : 0x26666;
 				refdiv = 1;
 			}
 		}
 
 		regval = REG_READ(ah, AR_PHY_PLL_MODE);
-		if (AR_SREV_9531(ah))
+		if (AR_SREV_9531(ah) || AR_SREV_9561(ah))
 			regval |= (0x1 << 22);
 		else
 			regval |= (0x1 << 16);
@@ -832,14 +834,16 @@ static void ath9k_hw_init_pll(struct ath_hw *ah,
 				(0x1 << 13) |
 				(0x4 << 26) |
 				(0x18 << 19);
-		else if (AR_SREV_9531(ah))
+		else if (AR_SREV_9531(ah) || AR_SREV_9561(ah)) {
 			regval = (regval & 0x01c00fff) |
 				(0x1 << 31) |
 				(0x2 << 29) |
 				(0xa << 25) |
-				(0x1 << 19) |
-				(0x6 << 12);
-		else
+				(0x1 << 19);
+
+			if (AR_SREV_9531(ah))
+				regval |= (0x6 << 12);
+		} else
 			regval = (regval & 0x80071fff) |
 				(0x3 << 30) |
 				(0x1 << 13) |
@@ -847,7 +851,7 @@ static void ath9k_hw_init_pll(struct ath_hw *ah,
 				(0x60 << 19);
 		REG_WRITE(ah, AR_PHY_PLL_MODE, regval);
 
-		if (AR_SREV_9531(ah))
+		if (AR_SREV_9531(ah) || AR_SREV_9561(ah))
 			REG_WRITE(ah, AR_PHY_PLL_MODE,
 				  REG_READ(ah, AR_PHY_PLL_MODE) & 0xffbfffff);
 		else
@@ -886,7 +890,8 @@ static void ath9k_hw_init_interrupt_masks(struct ath_hw *ah,
 		AR_IMR_RXORN |
 		AR_IMR_BCNMISC;
 
-	if (AR_SREV_9340(ah) || AR_SREV_9550(ah) || AR_SREV_9531(ah))
+	if (AR_SREV_9340(ah) || AR_SREV_9550(ah) || AR_SREV_9531(ah) ||
+	    AR_SREV_9561(ah))
 		sync_default &= ~AR_INTR_SYNC_HOST1_FATAL;
 
 	if (AR_SREV_9300_20_OR_LATER(ah)) {
@@ -1675,7 +1680,8 @@ static void ath9k_hw_init_desc(struct ath_hw *ah)
 		}
 #ifdef __BIG_ENDIAN
 		else if (AR_SREV_9330(ah) || AR_SREV_9340(ah) ||
-			 AR_SREV_9550(ah) || AR_SREV_9531(ah))
+			 AR_SREV_9550(ah) || AR_SREV_9531(ah) ||
+			 AR_SREV_9561(ah))
 			REG_RMW(ah, AR_CFG, AR_CFG_SWRB | AR_CFG_SWTB, 0);
 		else
 			REG_WRITE(ah, AR_CFG, AR_CFG_SWTD | AR_CFG_SWRD);
@@ -2463,7 +2469,8 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 
 	if (AR_SREV_9300_20_OR_LATER(ah)) {
 		pCap->hw_caps |= ATH9K_HW_CAP_EDMA | ATH9K_HW_CAP_FASTCLOCK;
-		if (!AR_SREV_9330(ah) && !AR_SREV_9485(ah) && !AR_SREV_9565(ah))
+		if (!AR_SREV_9330(ah) && !AR_SREV_9485(ah) &&
+		    !AR_SREV_9561(ah) && !AR_SREV_9565(ah))
 			pCap->hw_caps |= ATH9K_HW_CAP_LDPC;
 
 		pCap->rx_hp_qdepth = ATH9K_HW_RX_HP_QDEPTH;
@@ -2480,7 +2487,9 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	if (AR_SREV_9300_20_OR_LATER(ah))
 		pCap->hw_caps |= ATH9K_HW_CAP_RAC_SUPPORTED;
 
-	if (AR_SREV_9300_20_OR_LATER(ah))
+	if (AR_SREV_9561(ah))
+		ah->ent_mode = 0x3BDA000;
+	else if (AR_SREV_9300_20_OR_LATER(ah))
 		ah->ent_mode = REG_READ(ah, AR_ENT_OTP);
 
 	if (AR_SREV_9287_11_OR_LATER(ah) || AR_SREV_9271(ah))
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 3e58bfa..bba85d1 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -820,7 +820,8 @@ void ath9k_hw_enable_interrupts(struct ath_hw *ah)
 		return;
 	}
 
-	if (AR_SREV_9340(ah) || AR_SREV_9550(ah) || AR_SREV_9531(ah))
+	if (AR_SREV_9340(ah) || AR_SREV_9550(ah) || AR_SREV_9531(ah) ||
+	    AR_SREV_9561(ah))
 		sync_default &= ~AR_INTR_SYNC_HOST1_FATAL;
 
 	async_mask = AR_INTR_MAC_IRQ;
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 7395afb..6fb40ef 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -425,7 +425,8 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
 		rfilt |= ATH9K_RX_FILTER_MCAST_BCAST_ALL;
 	}
 
-	if (AR_SREV_9550(sc->sc_ah) || AR_SREV_9531(sc->sc_ah))
+	if (AR_SREV_9550(sc->sc_ah) || AR_SREV_9531(sc->sc_ah) ||
+	    AR_SREV_9561(sc->sc_ah))
 		rfilt |= ATH9K_RX_FILTER_4ADDRESS;
 
 	if (ath9k_is_chanctx_enabled() &&
-- 
2.1.3

