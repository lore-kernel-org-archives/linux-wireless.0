Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54779 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab0DODax (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Apr 2010 23:30:53 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 35/97] ath9k_hw: add all the AR9003 PHY callbacks
Date: Wed, 14 Apr 2010 23:29:49 -0400
Message-Id: <1271302251-9075-36-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
References: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |  300 ++++++++++++++++++++++++++-
 1 files changed, 289 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 356e03d..c938b85 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -225,7 +225,30 @@ static void ar9003_hw_set_channel_regs(struct ath_hw *ah,
 static void ar9003_hw_init_bb(struct ath_hw *ah,
 			      struct ath9k_channel *chan)
 {
-	/* TODO */
+	u32 synthDelay;
+
+	/*
+	 * Wait for the frequency synth to settle (synth goes on
+	 * via AR_PHY_ACTIVE_EN).  Read the phy active delay register.
+	 * Value is in 100ns increments.
+	 */
+	synthDelay = REG_READ(ah, AR_PHY_RX_DELAY) & AR_PHY_RX_DELAY_DELAY;
+	if (IS_CHAN_B(chan))
+		synthDelay = (4 * synthDelay) / 22;
+	else
+		synthDelay /= 10;
+
+	/* Activate the PHY (includes baseband activate + synthesizer on) */
+	REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_EN);
+
+	/*
+	 * There is an issue if the AP starts the calibration before
+	 * the base band timeout completes.  This could result in the
+	 * rx_clear false triggering.  As a workaround we add delay an
+	 * extra BASE_ACTIVATE_DELAY usecs to ensure this condition
+	 * does not happen.
+	 */
+	udelay(synthDelay + BASE_ACTIVATE_DELAY);
 }
 
 void ar9003_hw_set_chain_masks(struct ath_hw *ah, u8 rx, u8 tx)
@@ -385,46 +408,301 @@ static int ar9003_hw_process_ini(struct ath_hw *ah,
 static void ar9003_hw_set_rfmode(struct ath_hw *ah,
 				 struct ath9k_channel *chan)
 {
-	/* TODO */
+	u32 rfMode = 0;
+
+	if (chan == NULL)
+		return;
+
+	rfMode |= (IS_CHAN_B(chan) || IS_CHAN_G(chan))
+		? AR_PHY_MODE_DYNAMIC : AR_PHY_MODE_OFDM;
+
+	if (IS_CHAN_A_5MHZ_SPACED(chan))
+		rfMode |= (AR_PHY_MODE_DYNAMIC | AR_PHY_MODE_DYN_CCK_DISABLE);
+
+	REG_WRITE(ah, AR_PHY_MODE, rfMode);
 }
 
 static void ar9003_hw_mark_phy_inactive(struct ath_hw *ah)
 {
-	/* TODO */
+	REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_DIS);
 }
 
 static void ar9003_hw_set_delta_slope(struct ath_hw *ah,
 				      struct ath9k_channel *chan)
 {
-	/* TODO */
+	u32 coef_scaled, ds_coef_exp, ds_coef_man;
+	u32 clockMhzScaled = 0x64000000;
+	struct chan_centers centers;
+
+	/*
+	 * half and quarter rate can divide the scaled clock by 2 or 4
+	 * scale for selected channel bandwidth
+	 */
+	if (IS_CHAN_HALF_RATE(chan))
+		clockMhzScaled = clockMhzScaled >> 1;
+	else if (IS_CHAN_QUARTER_RATE(chan))
+		clockMhzScaled = clockMhzScaled >> 2;
+
+	/*
+	 * ALGO -> coef = 1e8/fcarrier*fclock/40;
+	 * scaled coef to provide precision for this floating calculation
+	 */
+	ath9k_hw_get_channel_centers(ah, chan, &centers);
+	coef_scaled = clockMhzScaled / centers.synth_center;
+
+	ath9k_hw_get_delta_slope_vals(ah, coef_scaled, &ds_coef_man,
+				      &ds_coef_exp);
+
+	REG_RMW_FIELD(ah, AR_PHY_TIMING3,
+		      AR_PHY_TIMING3_DSC_MAN, ds_coef_man);
+	REG_RMW_FIELD(ah, AR_PHY_TIMING3,
+		      AR_PHY_TIMING3_DSC_EXP, ds_coef_exp);
+
+	/*
+	 * For Short GI,
+	 * scaled coeff is 9/10 that of normal coeff
+	 */
+	coef_scaled = (9 * coef_scaled) / 10;
+
+	ath9k_hw_get_delta_slope_vals(ah, coef_scaled, &ds_coef_man,
+				      &ds_coef_exp);
+
+	/* for short gi */
+	REG_RMW_FIELD(ah, AR_PHY_SGI_DELTA,
+		      AR_PHY_SGI_DSC_MAN, ds_coef_man);
+	REG_RMW_FIELD(ah, AR_PHY_SGI_DELTA,
+		      AR_PHY_SGI_DSC_EXP, ds_coef_exp);
 }
 
 static bool ar9003_hw_rfbus_req(struct ath_hw *ah)
 {
-	/* TODO */
-	return false;
+	REG_WRITE(ah, AR_PHY_RFBUS_REQ, AR_PHY_RFBUS_REQ_EN);
+	return ath9k_hw_wait(ah, AR_PHY_RFBUS_GRANT, AR_PHY_RFBUS_GRANT_EN,
+			     AR_PHY_RFBUS_GRANT_EN, AH_WAIT_TIMEOUT);
 }
 
+/*
+ * Wait for the frequency synth to settle (synth goes on via PHY_ACTIVE_EN).
+ * Read the phy active delay register. Value is in 100ns increments.
+ */
 static void ar9003_hw_rfbus_done(struct ath_hw *ah)
 {
-	/* TODO */
+	u32 synthDelay = REG_READ(ah, AR_PHY_RX_DELAY) & AR_PHY_RX_DELAY_DELAY;
+	if (IS_CHAN_B(ah->curchan))
+		synthDelay = (4 * synthDelay) / 22;
+	else
+		synthDelay /= 10;
+
+	udelay(synthDelay + BASE_ACTIVATE_DELAY);
+
+	REG_WRITE(ah, AR_PHY_RFBUS_REQ, 0);
 }
 
+/*
+ * Set the interrupt and GPIO values so the ISR can disable RF
+ * on a switch signal.  Assumes GPIO port and interrupt polarity
+ * are set prior to call.
+ */
 static void ar9003_hw_enable_rfkill(struct ath_hw *ah)
 {
-	/* TODO */
+	/* Connect rfsilent_bb_l to baseband */
+	REG_SET_BIT(ah, AR_GPIO_INPUT_EN_VAL,
+		    AR_GPIO_INPUT_EN_VAL_RFSILENT_BB);
+	/* Set input mux for rfsilent_bb_l to GPIO #0 */
+	REG_CLR_BIT(ah, AR_GPIO_INPUT_MUX2,
+		    AR_GPIO_INPUT_MUX2_RFSILENT);
+
+	/*
+	 * Configure the desired GPIO port for input and
+	 * enable baseband rf silence.
+	 */
+	ath9k_hw_cfg_gpio_input(ah, ah->rfkill_gpio);
+	REG_SET_BIT(ah, AR_PHY_TEST, RFSILENT_BB);
 }
 
 static void ar9003_hw_set_diversity(struct ath_hw *ah, bool value)
 {
-	/* TODO */
+	u32 v = REG_READ(ah, AR_PHY_CCK_DETECT);
+	if (value)
+		v |= AR_PHY_CCK_DETECT_BB_ENABLE_ANT_FAST_DIV;
+	else
+		v &= ~AR_PHY_CCK_DETECT_BB_ENABLE_ANT_FAST_DIV;
+	REG_WRITE(ah, AR_PHY_CCK_DETECT, v);
 }
 
 static bool ar9003_hw_ani_control(struct ath_hw *ah,
 				  enum ath9k_ani_cmd cmd, int param)
 {
-	/* TODO */
-	return false;
+	struct ar5416AniState *aniState = ah->curani;
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	switch (cmd & ah->ani_function) {
+	case ATH9K_ANI_NOISE_IMMUNITY_LEVEL:{
+		u32 level = param;
+
+		if (level >= ARRAY_SIZE(ah->totalSizeDesired)) {
+			ath_print(common, ATH_DBG_ANI,
+				  "level out of range (%u > %u)\n",
+				  level,
+				  (unsigned)ARRAY_SIZE(ah->totalSizeDesired));
+			return false;
+		}
+
+		REG_RMW_FIELD(ah, AR_PHY_DESIRED_SZ,
+			      AR_PHY_DESIRED_SZ_TOT_DES,
+			      ah->totalSizeDesired[level]);
+		REG_RMW_FIELD(ah, AR_PHY_AGC,
+			      AR_PHY_AGC_COARSE_LOW,
+			      ah->coarse_low[level]);
+		REG_RMW_FIELD(ah, AR_PHY_AGC,
+			      AR_PHY_AGC_COARSE_HIGH,
+			      ah->coarse_high[level]);
+		REG_RMW_FIELD(ah, AR_PHY_FIND_SIG,
+			      AR_PHY_FIND_SIG_FIRPWR, ah->firpwr[level]);
+
+		if (level > aniState->noiseImmunityLevel)
+			ah->stats.ast_ani_niup++;
+		else if (level < aniState->noiseImmunityLevel)
+			ah->stats.ast_ani_nidown++;
+		aniState->noiseImmunityLevel = level;
+		break;
+	}
+	case ATH9K_ANI_OFDM_WEAK_SIGNAL_DETECTION:{
+		const int m1ThreshLow[] = { 127, 50 };
+		const int m2ThreshLow[] = { 127, 40 };
+		const int m1Thresh[] = { 127, 0x4d };
+		const int m2Thresh[] = { 127, 0x40 };
+		const int m2CountThr[] = { 31, 16 };
+		const int m2CountThrLow[] = { 63, 48 };
+		u32 on = param ? 1 : 0;
+
+		REG_RMW_FIELD(ah, AR_PHY_SFCORR_LOW,
+			      AR_PHY_SFCORR_LOW_M1_THRESH_LOW,
+			      m1ThreshLow[on]);
+		REG_RMW_FIELD(ah, AR_PHY_SFCORR_LOW,
+			      AR_PHY_SFCORR_LOW_M2_THRESH_LOW,
+			      m2ThreshLow[on]);
+		REG_RMW_FIELD(ah, AR_PHY_SFCORR,
+			      AR_PHY_SFCORR_M1_THRESH, m1Thresh[on]);
+		REG_RMW_FIELD(ah, AR_PHY_SFCORR,
+			      AR_PHY_SFCORR_M2_THRESH, m2Thresh[on]);
+		REG_RMW_FIELD(ah, AR_PHY_SFCORR,
+			      AR_PHY_SFCORR_M2COUNT_THR, m2CountThr[on]);
+		REG_RMW_FIELD(ah, AR_PHY_SFCORR_LOW,
+			      AR_PHY_SFCORR_LOW_M2COUNT_THR_LOW,
+			      m2CountThrLow[on]);
+
+		REG_RMW_FIELD(ah, AR_PHY_SFCORR_EXT,
+			      AR_PHY_SFCORR_EXT_M1_THRESH_LOW, m1ThreshLow[on]);
+		REG_RMW_FIELD(ah, AR_PHY_SFCORR_EXT,
+			      AR_PHY_SFCORR_EXT_M2_THRESH_LOW, m2ThreshLow[on]);
+		REG_RMW_FIELD(ah, AR_PHY_SFCORR_EXT,
+			      AR_PHY_SFCORR_EXT_M1_THRESH, m1Thresh[on]);
+		REG_RMW_FIELD(ah, AR_PHY_SFCORR_EXT,
+			      AR_PHY_SFCORR_EXT_M2_THRESH, m2Thresh[on]);
+
+		if (on)
+			REG_SET_BIT(ah, AR_PHY_SFCORR_LOW,
+				    AR_PHY_SFCORR_LOW_USE_SELF_CORR_LOW);
+		else
+			REG_CLR_BIT(ah, AR_PHY_SFCORR_LOW,
+				    AR_PHY_SFCORR_LOW_USE_SELF_CORR_LOW);
+
+		if (!on != aniState->ofdmWeakSigDetectOff) {
+			if (on)
+				ah->stats.ast_ani_ofdmon++;
+			else
+				ah->stats.ast_ani_ofdmoff++;
+			aniState->ofdmWeakSigDetectOff = !on;
+		}
+		break;
+	}
+	case ATH9K_ANI_CCK_WEAK_SIGNAL_THR:{
+		const int weakSigThrCck[] = { 8, 6 };
+		u32 high = param ? 1 : 0;
+
+		REG_RMW_FIELD(ah, AR_PHY_CCK_DETECT,
+			      AR_PHY_CCK_DETECT_WEAK_SIG_THR_CCK,
+			      weakSigThrCck[high]);
+		if (high != aniState->cckWeakSigThreshold) {
+			if (high)
+				ah->stats.ast_ani_cckhigh++;
+			else
+				ah->stats.ast_ani_ccklow++;
+			aniState->cckWeakSigThreshold = high;
+		}
+		break;
+	}
+	case ATH9K_ANI_FIRSTEP_LEVEL:{
+		const int firstep[] = { 0, 4, 8 };
+		u32 level = param;
+
+		if (level >= ARRAY_SIZE(firstep)) {
+			ath_print(common, ATH_DBG_ANI,
+				  "level out of range (%u > %u)\n",
+				  level,
+				  (unsigned) ARRAY_SIZE(firstep));
+			return false;
+		}
+		REG_RMW_FIELD(ah, AR_PHY_FIND_SIG,
+			      AR_PHY_FIND_SIG_FIRSTEP,
+			      firstep[level]);
+		if (level > aniState->firstepLevel)
+			ah->stats.ast_ani_stepup++;
+		else if (level < aniState->firstepLevel)
+			ah->stats.ast_ani_stepdown++;
+		aniState->firstepLevel = level;
+		break;
+	}
+	case ATH9K_ANI_SPUR_IMMUNITY_LEVEL:{
+		const int cycpwrThr1[] = { 2, 4, 6, 8, 10, 12, 14, 16 };
+		u32 level = param;
+
+		if (level >= ARRAY_SIZE(cycpwrThr1)) {
+			ath_print(common, ATH_DBG_ANI,
+				  "level out of range (%u > %u)\n",
+				  level,
+				  (unsigned) ARRAY_SIZE(cycpwrThr1));
+			return false;
+		}
+		REG_RMW_FIELD(ah, AR_PHY_TIMING5,
+			      AR_PHY_TIMING5_CYCPWR_THR1,
+			      cycpwrThr1[level]);
+		if (level > aniState->spurImmunityLevel)
+			ah->stats.ast_ani_spurup++;
+		else if (level < aniState->spurImmunityLevel)
+			ah->stats.ast_ani_spurdown++;
+		aniState->spurImmunityLevel = level;
+		break;
+	}
+	case ATH9K_ANI_PRESENT:
+		break;
+	default:
+		ath_print(common, ATH_DBG_ANI,
+			  "invalid cmd %u\n", cmd);
+		return false;
+	}
+
+	ath_print(common, ATH_DBG_ANI, "ANI parameters:\n");
+	ath_print(common, ATH_DBG_ANI,
+		  "noiseImmunityLevel=%d, spurImmunityLevel=%d, "
+		  "ofdmWeakSigDetectOff=%d\n",
+		  aniState->noiseImmunityLevel,
+		  aniState->spurImmunityLevel,
+		  !aniState->ofdmWeakSigDetectOff);
+	ath_print(common, ATH_DBG_ANI,
+		  "cckWeakSigThreshold=%d, "
+		  "firstepLevel=%d, listenTime=%d\n",
+		  aniState->cckWeakSigThreshold,
+		  aniState->firstepLevel,
+		  aniState->listenTime);
+	ath_print(common, ATH_DBG_ANI,
+		"cycleCount=%d, ofdmPhyErrCount=%d, cckPhyErrCount=%d\n\n",
+		aniState->cycleCount,
+		aniState->ofdmPhyErrCount,
+		aniState->cckPhyErrCount);
+
+	return true;
 }
 
 void ar9003_hw_attach_phy_ops(struct ath_hw *ah)
-- 
1.6.3.3

