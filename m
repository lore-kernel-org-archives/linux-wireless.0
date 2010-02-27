Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:31398 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499Ab0B0Fr3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Feb 2010 00:47:29 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 26 Feb 2010 21:47:29 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19336.46689.153603.324919@gargle.gargle.HOWL>
Date: Sat, 27 Feb 2010 11:36:25 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	<Vasanth.Thiagarajan@Atheros.com>,
	<Senthilkumar.Balasubramanian@Atheros.com>
Subject: [PATCH 2/3] ath9k_hw: HW fixes for ath9k_htc
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Update initvals and set them up properly during initialization.
* Assign number of GPIO pins for AR9271.
* Chip test is not required for host driver
  Target will do the test internally.
* Do not setup/Free RF banks for AR9271.
* Use 9280 channel set routine for AR9271.
* Set TX descriptors properly.
* Fix FULLSLEEP mode for AR9271.
* Fix PLL/INI override for AR9271.
* Fix byte swap for descriptors
* Set set NF value to -116 when the actual value exceeds -114.
  Also no need to read NF value on chain 1 for single chain chips.
* Configure correct chainmask in ath9k_hw_loadnf().
* Initialize default nf value.
* Use skip counts for PA calibration.
* Don't fiddle with initvals for AR9271.
  Manipulating ACK/CTS timeout values results in association problems.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/calib.c    |   27 +++++--
 drivers/net/wireless/ath/ath9k/calib.h    |    1 +
 drivers/net/wireless/ath/ath9k/hw.c       |  128 ++++++++++++--------------
 drivers/net/wireless/ath/ath9k/hw.h       |    5 +
 drivers/net/wireless/ath/ath9k/initvals.h |  141 +++++++++++++++++++++--------
 drivers/net/wireless/ath/ath9k/mac.c      |    2 +-
 drivers/net/wireless/ath/ath9k/phy.c      |    6 +-
 7 files changed, 190 insertions(+), 120 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index 238a574..f8d4da6 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -101,9 +101,13 @@ static void ath9k_hw_do_getnf(struct ath_hw *ah,
 		nf = 0 - ((nf ^ 0x1ff) + 1);
 	ath_print(common, ATH_DBG_CALIBRATE,
 		  "NF calibrated [ctl] [chain 0] is %d\n", nf);
+
+	if (AR_SREV_9271(ah))
+		if (nf >= -114)
+			nf = -116;
 	nfarray[0] = nf;
 
-	if (!AR_SREV_9285(ah)) {
+	if (!AR_SREV_9285(ah) && !AR_SREV_9271(ah)) {
 		if (AR_SREV_9280_10_OR_LATER(ah))
 			nf = MS(REG_READ(ah, AR_PHY_CH1_CCA),
 					AR9280_PHY_CH1_MINCCA_PWR);
@@ -139,6 +143,11 @@ static void ath9k_hw_do_getnf(struct ath_hw *ah,
 		nf = 0 - ((nf ^ 0x1ff) + 1);
 	ath_print(common, ATH_DBG_CALIBRATE,
 		  "NF calibrated [ext] [chain 0] is %d\n", nf);
+
+	if (AR_SREV_9271(ah))
+		if (nf >= -114)
+			nf = -116;
+
 	nfarray[3] = nf;
 
 	if (!AR_SREV_9285(ah)) {
@@ -621,7 +630,7 @@ void ath9k_hw_loadnf(struct ath_hw *ah, struct ath9k_channel *chan)
 	u8 chainmask, rx_chain_status;
 
 	rx_chain_status = REG_READ(ah, AR_PHY_RX_CHAINMASK);
-	if (AR_SREV_9285(ah))
+	if (AR_SREV_9285(ah) || AR_SREV_9271(ah))
 		chainmask = 0x9;
 	else if (AR_SREV_9280(ah) || AR_SREV_9287(ah)) {
 		if ((rx_chain_status & 0x2) || (rx_chain_status & 0x4))
@@ -715,7 +724,7 @@ void ath9k_init_nfcal_hist_buffer(struct ath_hw *ah)
 
 	if (AR_SREV_9280(ah))
 		noise_floor = AR_PHY_CCA_MAX_AR9280_GOOD_VALUE;
-	else if (AR_SREV_9285(ah))
+	else if (AR_SREV_9285(ah) || AR_SREV_9271(ah))
 		noise_floor = AR_PHY_CCA_MAX_AR9285_GOOD_VALUE;
 	else if (AR_SREV_9287(ah))
 		noise_floor = AR_PHY_CCA_MAX_AR9287_GOOD_VALUE;
@@ -815,6 +824,7 @@ static void ath9k_olc_temp_compensation(struct ath_hw *ah)
 
 static void ath9k_hw_9271_pa_cal(struct ath_hw *ah, bool is_reset)
 {
+	struct ath_common *common = ath9k_hw_common(ah);
 	u32 regVal;
 	unsigned int i;
 	u32 regList [][2] = {
@@ -828,6 +838,8 @@ static void ath9k_hw_9271_pa_cal(struct ath_hw *ah, bool is_reset)
 		{ 0x7828, 0 } ,
 	};
 
+	ath_print(common, ATH_DBG_CALIBRATE, "Running PA Calibration\n");
+
 	for (i = 0; i < ARRAY_SIZE(regList); i++)
 		regList[i][1] = REG_READ(ah, regList[i][0]);
 
@@ -1051,9 +1063,12 @@ bool ath9k_hw_calibrate(struct ath_hw *ah, struct ath9k_channel *chan,
 	/* Do NF cal only at longer intervals */
 	if (longcal) {
 		/* Do periodic PAOffset Cal */
-		if (AR_SREV_9271(ah))
-			ath9k_hw_9271_pa_cal(ah, false);
-		else if (AR_SREV_9285_11_OR_LATER(ah)) {
+		if (AR_SREV_9271(ah)) {
+			if (!ah->pacal_info.skipcount)
+				ath9k_hw_9271_pa_cal(ah, false);
+			else
+				ah->pacal_info.skipcount--;
+		} else if (AR_SREV_9285_11_OR_LATER(ah)) {
 			if (!ah->pacal_info.skipcount)
 				ath9k_hw_9285_pa_cal(ah, false);
 			else
diff --git a/drivers/net/wireless/ath/ath9k/calib.h b/drivers/net/wireless/ath/ath9k/calib.h
index b2c873e..3b634d4 100644
--- a/drivers/net/wireless/ath/ath9k/calib.h
+++ b/drivers/net/wireless/ath/ath9k/calib.h
@@ -114,6 +114,7 @@ struct ath9k_nfcal_hist {
 };
 
 #define MAX_PACAL_SKIPCOUNT 8
+
 struct ath9k_pacal_info{
 	int32_t prev_offset;	/* Previous value of PA offset value */
 	int8_t max_skipcount;	/* Max No. of times PACAL can be skipped */
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 07d0b8b..cc4242f 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -499,8 +499,10 @@ static int ath9k_hw_post_init(struct ath_hw *ah)
 {
 	int ecode;
 
-	if (!ath9k_hw_chip_test(ah))
-		return -ENODEV;
+	if (!AR_SREV_9271(ah)) {
+		if (!ath9k_hw_chip_test(ah))
+			return -ENODEV;
+	}
 
 	ecode = ath9k_hw_rf_claim(ah);
 	if (ecode != 0)
@@ -515,7 +517,7 @@ static int ath9k_hw_post_init(struct ath_hw *ah)
 		  ah->eep_ops->get_eeprom_ver(ah),
 		  ah->eep_ops->get_eeprom_rev(ah));
 
-        if (!AR_SREV_9280_10_OR_LATER(ah)) {
+        if (!AR_SREV_9280_10_OR_LATER(ah) && !AR_SREV_9271(ah)) {
 		ecode = ath9k_hw_rf_alloc_ext_banks(ah);
 		if (ecode) {
 			ath_print(ath9k_hw_common(ah), ATH_DBG_FATAL,
@@ -603,9 +605,23 @@ static void ath9k_hw_init_mode_regs(struct ath_hw *ah)
 			       ARRAY_SIZE(ar9271Modes_9271), 6);
 		INIT_INI_ARRAY(&ah->iniCommon, ar9271Common_9271,
 			       ARRAY_SIZE(ar9271Common_9271), 2);
+		INIT_INI_ARRAY(&ah->iniCommon_normal_cck_fir_coeff_9271,
+			       ar9271Common_normal_cck_fir_coeff_9271,
+			       ARRAY_SIZE(ar9271Common_normal_cck_fir_coeff_9271), 2);
+		INIT_INI_ARRAY(&ah->iniCommon_japan_2484_cck_fir_coeff_9271,
+			       ar9271Common_japan_2484_cck_fir_coeff_9271,
+			       ARRAY_SIZE(ar9271Common_japan_2484_cck_fir_coeff_9271), 2);
 		INIT_INI_ARRAY(&ah->iniModes_9271_1_0_only,
 			       ar9271Modes_9271_1_0_only,
 			       ARRAY_SIZE(ar9271Modes_9271_1_0_only), 6);
+		INIT_INI_ARRAY(&ah->iniModes_9271_ANI_reg, ar9271Modes_9271_ANI_reg,
+			       ARRAY_SIZE(ar9271Modes_9271_ANI_reg), 6);
+		INIT_INI_ARRAY(&ah->iniModes_high_power_tx_gain_9271,
+			       ar9271Modes_high_power_tx_gain_9271,
+			       ARRAY_SIZE(ar9271Modes_high_power_tx_gain_9271), 6);
+		INIT_INI_ARRAY(&ah->iniModes_normal_power_tx_gain_9271,
+			       ar9271Modes_normal_power_tx_gain_9271,
+			       ARRAY_SIZE(ar9271Modes_normal_power_tx_gain_9271), 6);
 		return;
 	}
 
@@ -901,7 +917,7 @@ int ath9k_hw_init(struct ath_hw *ah)
 	ath9k_hw_init_cal_settings(ah);
 
 	ah->ani_function = ATH9K_ANI_ALL;
-	if (AR_SREV_9280_10_OR_LATER(ah)) {
+	if (AR_SREV_9280_10_OR_LATER(ah) || AR_SREV_9271(ah)) {
 		ah->ani_function &= ~ATH9K_ANI_NOISE_IMMUNITY_LEVEL;
 		ah->ath9k_hw_rf_set_freq = &ath9k_hw_ar9280_set_channel;
 		ah->ath9k_hw_spur_mitigate_freq = &ath9k_hw_9280_spur_mitigate;
@@ -990,22 +1006,6 @@ static void ath9k_hw_init_qos(struct ath_hw *ah)
 	REG_WRITE(ah, AR_TXOP_12_15, 0xFFFFFFFF);
 }
 
-static void ath9k_hw_change_target_baud(struct ath_hw *ah, u32 freq, u32 baud)
-{
-	u32 lcr;
-	u32 baud_divider = freq * 1000 * 1000 / 16 / baud;
-
-	lcr = REG_READ(ah , 0x5100c);
-	lcr |= 0x80;
-
-	REG_WRITE(ah, 0x5100c, lcr);
-	REG_WRITE(ah, 0x51004, (baud_divider >> 8));
-	REG_WRITE(ah, 0x51000, (baud_divider & 0xff));
-
-	lcr &= ~0x80;
-	REG_WRITE(ah, 0x5100c, lcr);
-}
-
 static void ath9k_hw_init_pll(struct ath_hw *ah,
 			      struct ath9k_channel *chan)
 {
@@ -1017,7 +1017,7 @@ static void ath9k_hw_init_pll(struct ath_hw *ah,
 		else
 			pll = 0x1458;
 	} else {
-		if (AR_SREV_9280_10_OR_LATER(ah)) {
+		if (AR_SREV_9280_10_OR_LATER(ah) || AR_SREV_9271(ah)) {
 			pll = SM(0x5, AR_RTC_9160_PLL_REFDIV);
 
 			if (chan && IS_CHAN_HALF_RATE(chan))
@@ -1028,7 +1028,6 @@ static void ath9k_hw_init_pll(struct ath_hw *ah,
 			if (chan && IS_CHAN_5GHZ(chan)) {
 				pll |= SM(0x28, AR_RTC_9160_PLL_DIV);
 
-
 				if (AR_SREV_9280_20(ah)) {
 					if (((chan->channel % 20) == 0)
 					    || ((chan->channel % 10) == 0))
@@ -1071,22 +1070,8 @@ static void ath9k_hw_init_pll(struct ath_hw *ah,
 
 	/* Switch the core clock for ar9271 to 117Mhz */
 	if (AR_SREV_9271(ah)) {
-		if ((pll == 0x142c) || (pll == 0x2850) ) {
-			udelay(500);
-			/* set CLKOBS to output AHB clock */
-			REG_WRITE(ah, 0x7020, 0xe);
-			/*
-			 * 0x304: 117Mhz, ahb_ratio: 1x1
-			 * 0x306: 40Mhz, ahb_ratio: 1x1
-			 */
-			REG_WRITE(ah, 0x50040, 0x304);
-			/*
-			 * makes adjustments for the baud dividor to keep the
-			 * targetted baud rate based on the used core clock.
-			 */
-			ath9k_hw_change_target_baud(ah, AR9271_CORE_CLOCK,
-						    AR9271_TARGET_BAUD_RATE);
-		}
+		udelay(500);
+		REG_WRITE(ah, 0x50040, 0x304);
 	}
 
 	udelay(RTC_PLL_SETTLE_DELAY);
@@ -1209,6 +1194,9 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
 		REG_WRITE(ah, AR_PCU_MISC,
 			  REG_READ(ah, AR_PCU_MISC) | ah->misc_mode);
 
+	if (AR_SREV_9271(ah))
+		return;
+
 	if (conf->channel && conf->channel->band == IEEE80211_BAND_5GHZ)
 		sifstime = 16;
 	else
@@ -1249,7 +1237,7 @@ void ath9k_hw_deinit(struct ath_hw *ah)
 	ath9k_hw_setpower(ah, ATH9K_PM_FULL_SLEEP);
 
 free_hw:
-	if (!AR_SREV_9280_10_OR_LATER(ah))
+	if (!AR_SREV_9280_10_OR_LATER(ah) && !AR_SREV_9271(ah))
 		ath9k_hw_rf_free_ext_banks(ah);
 	kfree(ah);
 	ah = NULL;
@@ -1265,26 +1253,6 @@ static void ath9k_hw_override_ini(struct ath_hw *ah,
 {
 	u32 val;
 
-	if (AR_SREV_9271(ah)) {
-		/*
-		 * Enable spectral scan to solution for issues with stuck
-		 * beacons on AR9271 1.0. The beacon stuck issue is not seeon on
-		 * AR9271 1.1
-		 */
-		if (AR_SREV_9271_10(ah)) {
-			val = REG_READ(ah, AR_PHY_SPECTRAL_SCAN) |
-			      AR_PHY_SPECTRAL_SCAN_ENABLE;
-			REG_WRITE(ah, AR_PHY_SPECTRAL_SCAN, val);
-		}
-		else if (AR_SREV_9271_11(ah))
-			/*
-			 * change AR_PHY_RF_CTL3 setting to fix MAC issue
-			 * present on AR9271 1.1
-			 */
-			REG_WRITE(ah, AR_PHY_RF_CTL3, 0x3a020001);
-		return;
-	}
-
 	/*
 	 * Set the RX_ABORT and RX_DIS and clear if off only after
 	 * RXE is set for MAC. This prevents frames with corrupted
@@ -1293,8 +1261,10 @@ static void ath9k_hw_override_ini(struct ath_hw *ah,
 	REG_SET_BIT(ah, AR_DIAG_SW, (AR_DIAG_RX_DIS | AR_DIAG_RX_ABORT));
 
 	if (AR_SREV_9280_10_OR_LATER(ah)) {
-		val = REG_READ(ah, AR_PCU_MISC_MODE2) &
-			       (~AR_PCU_MISC_MODE2_HWWAR1);
+		val = REG_READ(ah, AR_PCU_MISC_MODE2);
+
+		if (!AR_SREV_9271(ah))
+			val &= ~AR_PCU_MISC_MODE2_HWWAR1;
 
 		if (AR_SREV_9287_10_OR_LATER(ah))
 			val = val & (~AR_PCU_MISC_MODE2_HWWAR2);
@@ -1438,7 +1408,10 @@ static int ath9k_hw_process_ini(struct ath_hw *ah,
 		return -EINVAL;
 	}
 
+	/* Set correct baseband to analog shift setting to access analog chips */
 	REG_WRITE(ah, AR_PHY(0), 0x00000007);
+
+	/* Write ADDAC shifts */
 	REG_WRITE(ah, AR_PHY_ADC_SERIAL_CTL, AR_PHY_SEL_EXTERNAL_RADIO);
 	ah->eep_ops->set_addac(ah, chan);
 
@@ -1450,9 +1423,11 @@ static int ath9k_hw_process_ini(struct ath_hw *ah,
 			sizeof(u32) * ah->iniAddac.ia_rows *
 			ah->iniAddac.ia_columns;
 
+		/* For AR5416 2.0/2.1 */
 		memcpy(ah->addac5416_21,
 		       ah->iniAddac.ia_array, addacSize);
 
+		/* override CLKDRV value at [row, column] = [31, 1] */
 		(ah->addac5416_21)[31 * ah->iniAddac.ia_columns + 1] = 0;
 
 		temp.ia_array = ah->addac5416_21;
@@ -1484,6 +1459,11 @@ static int ath9k_hw_process_ini(struct ath_hw *ah,
 	    AR_SREV_9287_10_OR_LATER(ah))
 		REG_WRITE_ARRAY(&ah->iniModesTxGain, modesIndex, regWrites);
 
+	if (AR_SREV_9271_10(ah))
+		REG_WRITE_ARRAY(&ah->iniModes_9271_1_0_only,
+				modesIndex, regWrites);
+
+	/* Write common array parameters */
 	for (i = 0; i < ah->iniCommon.ia_rows; i++) {
 		u32 reg = INI_RA(&ah->iniCommon, i, 0);
 		u32 val = INI_RA(&ah->iniCommon, i, 1);
@@ -1498,11 +1478,16 @@ static int ath9k_hw_process_ini(struct ath_hw *ah,
 		DO_DELAY(regWrites);
 	}
 
-	ath9k_hw_write_regs(ah, freqIndex, regWrites);
+	if (AR_SREV_9271(ah)) {
+		if (ah->eep_ops->get_eeprom(ah, EEP_TXGAIN_TYPE) == 1)
+			REG_WRITE_ARRAY(&ah->iniModes_high_power_tx_gain_9271,
+					modesIndex, regWrites);
+		else
+			REG_WRITE_ARRAY(&ah->iniModes_normal_power_tx_gain_9271,
+					modesIndex, regWrites);
+	}
 
-	if (AR_SREV_9271_10(ah))
-		REG_WRITE_ARRAY(&ah->iniModes_9271_1_0_only,
-				modesIndex, regWrites);
+	ath9k_hw_write_regs(ah, freqIndex, regWrites);
 
 	if (AR_SREV_9280_20(ah) && IS_CHAN_A_5MHZ_SPACED(chan)) {
 		REG_WRITE_ARRAY(&ah->iniModesAdditional, modesIndex,
@@ -1516,6 +1501,7 @@ static int ath9k_hw_process_ini(struct ath_hw *ah,
 	if (OLC_FOR_AR9280_20_LATER)
 		ath9k_olc_init(ah);
 
+	/* Set TX power */
 	ah->eep_ops->set_txpower(ah, chan,
 				 ath9k_regd_get_ctl(regulatory, chan),
 				 channel->max_antenna_gain * 2,
@@ -1523,6 +1509,7 @@ static int ath9k_hw_process_ini(struct ath_hw *ah,
 				 min((u32) MAX_RATE_POWER,
 				 (u32) regulatory->power_limit));
 
+	/* Write analog registers */
 	if (!ath9k_hw_set_rf_regs(ah, chan, freqIndex)) {
 		ath_print(ath9k_hw_common(ah), ATH_DBG_FATAL,
 			  "ar5416SetRfRegs failed\n");
@@ -2131,12 +2118,13 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 		}
 	} else {
 		/* Configure AR9271 target WLAN */
-                if (AR_SREV_9271(ah))
+		if (AR_SREV_9271(ah)) {
 			REG_WRITE(ah, AR_CFG, AR_CFG_SWRB | AR_CFG_SWTB);
+		} else {
 #ifdef __BIG_ENDIAN
-                else
 			REG_WRITE(ah, AR_CFG, AR_CFG_SWTD | AR_CFG_SWRD);
 #endif
+		}
 	}
 
 	if (ah->btcoex_hw.enabled)
@@ -2437,7 +2425,7 @@ static void ath9k_set_power_sleep(struct ath_hw *ah, int setChip)
 		if (!AR_SREV_9100(ah))
 			REG_WRITE(ah, AR_RC, AR_RC_AHB | AR_RC_HOSTIF);
 
-		if(!AR_SREV_5416(ah))
+		if (!AR_SREV_5416(ah) && !AR_SREV_9271(ah))
 			REG_CLR_BIT(ah, (AR_RTC_RESET),
 				    AR_RTC_RESET_EN);
 	}
@@ -3218,7 +3206,9 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	else
 		pCap->tx_triglevel_max = MAX_TX_FIFO_THRESHOLD;
 
-	if (AR_SREV_9285_10_OR_LATER(ah))
+	if (AR_SREV_9271(ah))
+		pCap->num_gpio_pins = AR9271_NUM_GPIO;
+	else if (AR_SREV_9285_10_OR_LATER(ah))
 		pCap->num_gpio_pins = AR9285_NUM_GPIO;
 	else if (AR_SREV_9280_10_OR_LATER(ah))
 		pCap->num_gpio_pins = AR928X_NUM_GPIO;
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 3b58baa..608ec77 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -598,6 +598,11 @@ struct ath_hw {
 	struct ar5416IniArray iniModes_9271_1_0_only;
 	struct ar5416IniArray iniCckfirNormal;
 	struct ar5416IniArray iniCckfirJapan2484;
+	struct ar5416IniArray iniCommon_normal_cck_fir_coeff_9271;
+	struct ar5416IniArray iniCommon_japan_2484_cck_fir_coeff_9271;
+	struct ar5416IniArray iniModes_9271_ANI_reg;
+	struct ar5416IniArray iniModes_high_power_tx_gain_9271;
+	struct ar5416IniArray iniModes_normal_power_tx_gain_9271;
 
 	u32 intr_gen_timer_trigger;
 	u32 intr_gen_timer_thresh;
diff --git a/drivers/net/wireless/ath/ath9k/initvals.h b/drivers/net/wireless/ath/ath9k/initvals.h
index 8a3bf3a..177bdeb 100644
--- a/drivers/net/wireless/ath/ath9k/initvals.h
+++ b/drivers/net/wireless/ath/ath9k/initvals.h
@@ -6441,7 +6441,7 @@ static const u_int32_t ar9271Modes_9271[][6] = {
     { 0x00009a44, 0x00000000, 0x00000000, 0x000581a8, 0x000581a8, 0x00000000 },
     { 0x00009a48, 0x00000000, 0x00000000, 0x00058284, 0x00058284, 0x00000000 },
     { 0x00009a4c, 0x00000000, 0x00000000, 0x00058288, 0x00058288, 0x00000000 },
-    { 0x00009a50, 0x00000000, 0x00000000, 0x00058220, 0x00058220, 0x00000000 },
+    { 0x00009a50, 0x00000000, 0x00000000, 0x00058224, 0x00058224, 0x00000000 },
     { 0x00009a54, 0x00000000, 0x00000000, 0x00058290, 0x00058290, 0x00000000 },
     { 0x00009a58, 0x00000000, 0x00000000, 0x00058300, 0x00058300, 0x00000000 },
     { 0x00009a5c, 0x00000000, 0x00000000, 0x00058304, 0x00058304, 0x00000000 },
@@ -6455,8 +6455,8 @@ static const u_int32_t ar9271Modes_9271[][6] = {
     { 0x00009a7c, 0x00000000, 0x00000000, 0x0006870c, 0x0006870c, 0x00000000 },
     { 0x00009a80, 0x00000000, 0x00000000, 0x00068780, 0x00068780, 0x00000000 },
     { 0x00009a84, 0x00000000, 0x00000000, 0x00068784, 0x00068784, 0x00000000 },
-    { 0x00009a88, 0x00000000, 0x00000000, 0x00078b04, 0x00078b04, 0x00000000 },
-    { 0x00009a8c, 0x00000000, 0x00000000, 0x00078b08, 0x00078b08, 0x00000000 },
+    { 0x00009a88, 0x00000000, 0x00000000, 0x00078b00, 0x00078b00, 0x00000000 },
+    { 0x00009a8c, 0x00000000, 0x00000000, 0x00078b04, 0x00078b04, 0x00000000 },
     { 0x00009a90, 0x00000000, 0x00000000, 0x00078b08, 0x00078b08, 0x00000000 },
     { 0x00009a94, 0x00000000, 0x00000000, 0x00078b0c, 0x00078b0c, 0x00000000 },
     { 0x00009a98, 0x00000000, 0x00000000, 0x00078b80, 0x00078b80, 0x00000000 },
@@ -6569,7 +6569,7 @@ static const u_int32_t ar9271Modes_9271[][6] = {
     { 0x0000aa44, 0x00000000, 0x00000000, 0x000581a8, 0x000581a8, 0x00000000 },
     { 0x0000aa48, 0x00000000, 0x00000000, 0x00058284, 0x00058284, 0x00000000 },
     { 0x0000aa4c, 0x00000000, 0x00000000, 0x00058288, 0x00058288, 0x00000000 },
-    { 0x0000aa50, 0x00000000, 0x00000000, 0x00058220, 0x00058220, 0x00000000 },
+    { 0x0000aa50, 0x00000000, 0x00000000, 0x00058224, 0x00058224, 0x00000000 },
     { 0x0000aa54, 0x00000000, 0x00000000, 0x00058290, 0x00058290, 0x00000000 },
     { 0x0000aa58, 0x00000000, 0x00000000, 0x00058300, 0x00058300, 0x00000000 },
     { 0x0000aa5c, 0x00000000, 0x00000000, 0x00058304, 0x00058304, 0x00000000 },
@@ -6583,8 +6583,8 @@ static const u_int32_t ar9271Modes_9271[][6] = {
     { 0x0000aa7c, 0x00000000, 0x00000000, 0x0006870c, 0x0006870c, 0x00000000 },
     { 0x0000aa80, 0x00000000, 0x00000000, 0x00068780, 0x00068780, 0x00000000 },
     { 0x0000aa84, 0x00000000, 0x00000000, 0x00068784, 0x00068784, 0x00000000 },
-    { 0x0000aa88, 0x00000000, 0x00000000, 0x00078b04, 0x00078b04, 0x00000000 },
-    { 0x0000aa8c, 0x00000000, 0x00000000, 0x00078b08, 0x00078b08, 0x00000000 },
+    { 0x0000aa88, 0x00000000, 0x00000000, 0x00078b00, 0x00078b00, 0x00000000 },
+    { 0x0000aa8c, 0x00000000, 0x00000000, 0x00078b04, 0x00078b04, 0x00000000 },
     { 0x0000aa90, 0x00000000, 0x00000000, 0x00078b08, 0x00078b08, 0x00000000 },
     { 0x0000aa94, 0x00000000, 0x00000000, 0x00078b0c, 0x00078b0c, 0x00000000 },
     { 0x0000aa98, 0x00000000, 0x00000000, 0x00078b80, 0x00078b80, 0x00000000 },
@@ -6683,25 +6683,6 @@ static const u_int32_t ar9271Modes_9271[][6] = {
     { 0x0000a21c, 0x1883800a, 0x1883800a, 0x1883800a, 0x1883800a, 0x1883800a },
     { 0x0000a230, 0x00000000, 0x00000000, 0x00000210, 0x00000108, 0x00000000 },
     { 0x0000a250, 0x0004f000, 0x0004f000, 0x0004a000, 0x0004a000, 0x0004a000 },
-    { 0x0000a274, 0x0a21c652, 0x0a21c652, 0x0a218652, 0x0a218652, 0x0a22a652 },
-    { 0x0000a300, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 },
-    { 0x0000a304, 0x00000000, 0x00000000, 0x00009200, 0x00009200, 0x00000000 },
-    { 0x0000a308, 0x00000000, 0x00000000, 0x00010208, 0x00010208, 0x00000000 },
-    { 0x0000a30c, 0x00000000, 0x00000000, 0x00019608, 0x00019608, 0x00000000 },
-    { 0x0000a310, 0x00000000, 0x00000000, 0x0001e610, 0x0001e610, 0x00000000 },
-    { 0x0000a314, 0x00000000, 0x00000000, 0x0002d6d0, 0x0002d6d0, 0x00000000 },
-    { 0x0000a318, 0x00000000, 0x00000000, 0x00039758, 0x00039758, 0x00000000 },
-    { 0x0000a31c, 0x00000000, 0x00000000, 0x0003b759, 0x0003b759, 0x00000000 },
-    { 0x0000a320, 0x00000000, 0x00000000, 0x0003d75a, 0x0003d75a, 0x00000000 },
-    { 0x0000a324, 0x00000000, 0x00000000, 0x0004175c, 0x0004175c, 0x00000000 },
-    { 0x0000a328, 0x00000000, 0x00000000, 0x0004575e, 0x0004575e, 0x00000000 },
-    { 0x0000a32c, 0x00000000, 0x00000000, 0x0004979f, 0x0004979f, 0x00000000 },
-    { 0x0000a330, 0x00000000, 0x00000000, 0x0004d7df, 0x0004d7df, 0x00000000 },
-    { 0x0000a334, 0x000368de, 0x000368de, 0x000368de, 0x000368de, 0x00000000 },
-    { 0x0000a338, 0x0003891e, 0x0003891e, 0x0003891e, 0x0003891e, 0x00000000 },
-    { 0x0000a33c, 0x0003a95e, 0x0003a95e, 0x0003a95e, 0x0003a95e, 0x00000000 },
-    { 0x0000a340, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x00000000 },
-    { 0x0000a344, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x00000000 },
     { 0x0000a358, 0x7999aa02, 0x7999aa02, 0x7999aa0e, 0x7999aa0e, 0x7999aa0e },
 };
 
@@ -6879,7 +6860,7 @@ static const u_int32_t ar9271Common_9271[][2] = {
     { 0x00008258, 0x00000000 },
     { 0x0000825c, 0x400000ff },
     { 0x00008260, 0x00080922 },
-    { 0x00008264, 0x88a00010 },
+    { 0x00008264, 0xa8a00010 },
     { 0x00008270, 0x00000000 },
     { 0x00008274, 0x40000000 },
     { 0x00008278, 0x003e4180 },
@@ -6910,13 +6891,10 @@ static const u_int32_t ar9271Common_9271[][2] = {
     { 0x00007810, 0x71c0d388 },
     { 0x00007814, 0x924934a8 },
     { 0x0000781c, 0x00000000 },
-    { 0x00007820, 0x00000c04 },
-    { 0x00007824, 0x00d8abff },
     { 0x00007828, 0x66964300 },
     { 0x0000782c, 0x8db6d961 },
     { 0x00007830, 0x8db6d96c },
     { 0x00007834, 0x6140008b },
-    { 0x00007838, 0x00000029 },
     { 0x0000783c, 0x72ee0a72 },
     { 0x00007840, 0xbbfffffc },
     { 0x00007844, 0x000c0db6 },
@@ -6929,7 +6907,6 @@ static const u_int32_t ar9271Common_9271[][2] = {
     { 0x00007860, 0x21084210 },
     { 0x00007864, 0xf7d7ffde },
     { 0x00007868, 0xc2034080 },
-    { 0x0000786c, 0x48609eb4 },
     { 0x00007870, 0x10142c00 },
     { 0x00009808, 0x00000000 },
     { 0x0000980c, 0xafe68e30 },
@@ -6982,9 +6959,6 @@ static const u_int32_t ar9271Common_9271[][2] = {
     { 0x000099e8, 0x3c466478 },
     { 0x000099ec, 0x0cc80caa },
     { 0x000099f0, 0x00000000 },
-    { 0x0000a1f4, 0x00000000 },
-    { 0x0000a1f8, 0x71733d01 },
-    { 0x0000a1fc, 0xd0ad5c12 },
     { 0x0000a208, 0x803e68c8 },
     { 0x0000a210, 0x4080a333 },
     { 0x0000a214, 0x00206c10 },
@@ -7004,13 +6978,9 @@ static const u_int32_t ar9271Common_9271[][2] = {
     { 0x0000a260, 0xdfa90f01 },
     { 0x0000a268, 0x00000000 },
     { 0x0000a26c, 0x0ebae9e6 },
-    { 0x0000a278, 0x3bdef7bd },
-    { 0x0000a27c, 0x050e83bd },
     { 0x0000a388, 0x0c000000 },
     { 0x0000a38c, 0x20202020 },
     { 0x0000a390, 0x20202020 },
-    { 0x0000a394, 0x3bdef7bd },
-    { 0x0000a398, 0x000003bd },
     { 0x0000a39c, 0x00000001 },
     { 0x0000a3a0, 0x00000000 },
     { 0x0000a3a4, 0x00000000 },
@@ -7025,8 +6995,6 @@ static const u_int32_t ar9271Common_9271[][2] = {
     { 0x0000a3cc, 0x20202020 },
     { 0x0000a3d0, 0x20202020 },
     { 0x0000a3d4, 0x20202020 },
-    { 0x0000a3dc, 0x3bdef7bd },
-    { 0x0000a3e0, 0x000003bd },
     { 0x0000a3e4, 0x00000000 },
     { 0x0000a3e8, 0x18c43433 },
     { 0x0000a3ec, 0x00f70081 },
@@ -7046,7 +7014,102 @@ static const u_int32_t ar9271Common_9271[][2] = {
     { 0x0000d384, 0xf3307ff0 },
 };
 
+static const u_int32_t ar9271Common_normal_cck_fir_coeff_9271[][2] = {
+    { 0x0000a1f4, 0x00fffeff },
+    { 0x0000a1f8, 0x00f5f9ff },
+    { 0x0000a1fc, 0xb79f6427 },
+};
+
+static const u_int32_t ar9271Common_japan_2484_cck_fir_coeff_9271[][2] = {
+    { 0x0000a1f4, 0x00000000 },
+    { 0x0000a1f8, 0xefff0301 },
+    { 0x0000a1fc, 0xca9228ee },
+};
+
 static const u_int32_t ar9271Modes_9271_1_0_only[][6] = {
     { 0x00009910, 0x30002311, 0x30002311, 0x30002311, 0x30002311, 0x30002311 },
     { 0x00009828, 0x0a020001, 0x0a020001, 0x0a020001, 0x0a020001, 0x0a020001 },
 };
+
+static const u_int32_t ar9271Modes_9271_ANI_reg[][6] = {
+    { 0x00009850, 0x6d4000e2, 0x6d4000e2, 0x6d4000e2, 0x6d4000e2, 0x6d4000e2 },
+    { 0x0000985c, 0x3139605e, 0x3139605e, 0x3137605e, 0x3137605e, 0x3139605e },
+    { 0x00009858, 0x7ec84d2e, 0x7ec84d2e, 0x7ec84d2e, 0x7ec84d2e, 0x7ec84d2e },
+    { 0x0000986c, 0x06903881, 0x06903881, 0x06903881, 0x06903881, 0x06903881 },
+    { 0x00009868, 0x5ac640d0, 0x5ac640d0, 0x5ac640d0, 0x5ac640d0, 0x5ac640d0 },
+    { 0x0000a208, 0x803e68c8, 0x803e68c8, 0x803e68c8, 0x803e68c8, 0x803e68c8 },
+    { 0x00009924, 0xd00a8007, 0xd00a8007, 0xd00a800d, 0xd00a800d, 0xd00a800d },
+    { 0x000099c0, 0x05eea6d4, 0x05eea6d4, 0x05eea6d4, 0x05eea6d4, 0x05eea6d4 },
+};
+
+static const u_int32_t ar9271Modes_normal_power_tx_gain_9271[][6] = {
+    { 0x0000a300, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 },
+    { 0x0000a304, 0x00000000, 0x00000000, 0x00009200, 0x00009200, 0x00000000 },
+    { 0x0000a308, 0x00000000, 0x00000000, 0x00010208, 0x00010208, 0x00000000 },
+    { 0x0000a30c, 0x00000000, 0x00000000, 0x00019608, 0x00019608, 0x00000000 },
+    { 0x0000a310, 0x00000000, 0x00000000, 0x0001e610, 0x0001e610, 0x00000000 },
+    { 0x0000a314, 0x00000000, 0x00000000, 0x0002d6d0, 0x0002d6d0, 0x00000000 },
+    { 0x0000a318, 0x00000000, 0x00000000, 0x00039758, 0x00039758, 0x00000000 },
+    { 0x0000a31c, 0x00000000, 0x00000000, 0x0003b759, 0x0003b759, 0x00000000 },
+    { 0x0000a320, 0x00000000, 0x00000000, 0x0003d75a, 0x0003d75a, 0x00000000 },
+    { 0x0000a324, 0x00000000, 0x00000000, 0x0004175c, 0x0004175c, 0x00000000 },
+    { 0x0000a328, 0x00000000, 0x00000000, 0x0004575e, 0x0004575e, 0x00000000 },
+    { 0x0000a32c, 0x00000000, 0x00000000, 0x0004979f, 0x0004979f, 0x00000000 },
+    { 0x0000a330, 0x00000000, 0x00000000, 0x0004d7df, 0x0004d7df, 0x00000000 },
+    { 0x0000a334, 0x000368de, 0x000368de, 0x000368de, 0x000368de, 0x00000000 },
+    { 0x0000a338, 0x0003891e, 0x0003891e, 0x0003891e, 0x0003891e, 0x00000000 },
+    { 0x0000a33c, 0x0003a95e, 0x0003a95e, 0x0003a95e, 0x0003a95e, 0x00000000 },
+    { 0x0000a340, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x00000000 },
+    { 0x0000a344, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x00000000 },
+    { 0x0000a348, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x00000000 },
+    { 0x0000a34c, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x00000000 },
+    { 0x0000a350, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x00000000 },
+    { 0x0000a354, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x00000000 },
+    { 0x00007838, 0x00000029, 0x00000029, 0x00000029, 0x00000029, 0x00000029 },
+    { 0x00007824, 0x00d8abff, 0x00d8abff, 0x00d8abff, 0x00d8abff, 0x00d8abff },
+    { 0x0000786c, 0x48609eb4, 0x48609eb4, 0x48609eb4, 0x48609eb4, 0x48609eb4 },
+    { 0x00007820, 0x00000c04, 0x00000c04, 0x00000c04, 0x00000c04, 0x00000c04 },
+    { 0x0000a274, 0x0a21c652, 0x0a21c652, 0x0a218652, 0x0a218652, 0x0a22a652 },
+    { 0x0000a278, 0x3bdef7bd, 0x3bdef7bd, 0x3bdef7bd, 0x3bdef7bd, 0x3bdef7bd },
+    { 0x0000a27c, 0x050e83bd, 0x050e83bd, 0x050e83bd, 0x050e83bd, 0x050e83bd },
+    { 0x0000a394, 0x3bdef7bd, 0x3bdef7bd, 0x3bdef7bd, 0x3bdef7bd, 0x3bdef7bd },
+    { 0x0000a398, 0x000003bd, 0x000003bd, 0x000003bd, 0x000003bd, 0x000003bd },
+    { 0x0000a3dc, 0x3bdef7bd, 0x3bdef7bd, 0x3bdef7bd, 0x3bdef7bd, 0x3bdef7bd },
+    { 0x0000a3e0, 0x000003bd, 0x000003bd, 0x000003bd, 0x000003bd, 0x000003bd },
+};
+
+static const u_int32_t ar9271Modes_high_power_tx_gain_9271[][6] = {
+    { 0x0000a300, 0x00000000, 0x00000000, 0x00010000, 0x00010000, 0x00000000 },
+    { 0x0000a304, 0x00000000, 0x00000000, 0x00016200, 0x00016200, 0x00000000 },
+    { 0x0000a308, 0x00000000, 0x00000000, 0x00018201, 0x00018201, 0x00000000 },
+    { 0x0000a30c, 0x00000000, 0x00000000, 0x0001b240, 0x0001b240, 0x00000000 },
+    { 0x0000a310, 0x00000000, 0x00000000, 0x0001d241, 0x0001d241, 0x00000000 },
+    { 0x0000a314, 0x00000000, 0x00000000, 0x0001f600, 0x0001f600, 0x00000000 },
+    { 0x0000a318, 0x00000000, 0x00000000, 0x00022800, 0x00022800, 0x00000000 },
+    { 0x0000a31c, 0x00000000, 0x00000000, 0x00026802, 0x00026802, 0x00000000 },
+    { 0x0000a320, 0x00000000, 0x00000000, 0x0002b805, 0x0002b805, 0x00000000 },
+    { 0x0000a324, 0x00000000, 0x00000000, 0x0002ea41, 0x0002ea41, 0x00000000 },
+    { 0x0000a328, 0x00000000, 0x00000000, 0x00038b00, 0x00038b00, 0x00000000 },
+    { 0x0000a32c, 0x00000000, 0x00000000, 0x0003ab40, 0x0003ab40, 0x00000000 },
+    { 0x0000a330, 0x00000000, 0x00000000, 0x0003cd80, 0x0003cd80, 0x00000000 },
+    { 0x0000a334, 0x000368de, 0x000368de, 0x000368de, 0x000368de, 0x00000000 },
+    { 0x0000a338, 0x0003891e, 0x0003891e, 0x0003891e, 0x0003891e, 0x00000000 },
+    { 0x0000a33c, 0x0003a95e, 0x0003a95e, 0x0003a95e, 0x0003a95e, 0x00000000 },
+    { 0x0000a340, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x00000000 },
+    { 0x0000a344, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x00000000 },
+    { 0x0000a348, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x00000000 },
+    { 0x0000a34c, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x00000000 },
+    { 0x0000a350, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x00000000 },
+    { 0x0000a354, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x00000000 },
+    { 0x00007838, 0x0000002b, 0x0000002b, 0x0000002b, 0x0000002b, 0x0000002b },
+    { 0x00007824, 0x00d8a7ff, 0x00d8a7ff, 0x00d8a7ff, 0x00d8a7ff, 0x00d8a7ff },
+    { 0x0000786c, 0x08609eb6, 0x08609eb6, 0x08609eba, 0x08609eba, 0x08609eb6 },
+    { 0x00007820, 0x00000c00, 0x00000c00, 0x00000c00, 0x00000c00, 0x00000c00 },
+    { 0x0000a274, 0x0a22a652, 0x0a22a652, 0x0a212652, 0x0a212652, 0x0a22a652 },
+    { 0x0000a278, 0x0e739ce7, 0x0e739ce7, 0x0e739ce7, 0x0e739ce7, 0x0e739ce7 },
+    { 0x0000a27c, 0x05018063, 0x05038063, 0x05018063, 0x05018063, 0x05018063 },
+    { 0x0000a394, 0x06318c63, 0x06318c63, 0x06318c63, 0x06318c63, 0x06318c63 },
+    { 0x0000a398, 0x00000063, 0x00000063, 0x00000063, 0x00000063, 0x00000063 },
+    { 0x0000a3dc, 0x06318c63, 0x06318c63, 0x06318c63, 0x06318c63, 0x06318c63 },
+    { 0x0000a3e0, 0x00000063, 0x00000063, 0x00000063, 0x00000063, 0x00000063 },
+};
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index efc420c..e19c823 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -349,7 +349,7 @@ void ath9k_hw_set11n_txdesc(struct ath_hw *ah, struct ath_desc *ds,
 
 	ads->ds_ctl6 = SM(keyType, AR_EncrType);
 
-	if (AR_SREV_9285(ah)) {
+	if (AR_SREV_9285(ah) || AR_SREV_9271(ah)) {
 		ads->ds_ctl8 = 0;
 		ads->ds_ctl9 = 0;
 		ads->ds_ctl10 = 0;
diff --git a/drivers/net/wireless/ath/ath9k/phy.c b/drivers/net/wireless/ath/ath9k/phy.c
index c3b5939..10e68cb 100644
--- a/drivers/net/wireless/ath/ath9k/phy.c
+++ b/drivers/net/wireless/ath/ath9k/phy.c
@@ -839,8 +839,6 @@ int ath9k_hw_rf_alloc_ext_banks(struct ath_hw *ah)
 
 	struct ath_common *common = ath9k_hw_common(ah);
 
-	BUG_ON(AR_SREV_9280_10_OR_LATER(ah));
-
 	ATH_ALLOC_BANK(ah->analogBank0Data, ah->iniBank0.ia_rows);
 	ATH_ALLOC_BANK(ah->analogBank1Data, ah->iniBank1.ia_rows);
 	ATH_ALLOC_BANK(ah->analogBank2Data, ah->iniBank2.ia_rows);
@@ -870,8 +868,6 @@ ath9k_hw_rf_free_ext_banks(struct ath_hw *ah)
 		bank = NULL; \
 	} while (0);
 
-	BUG_ON(AR_SREV_9280_10_OR_LATER(ah));
-
 	ATH_FREE_BANK(ah->analogBank0Data);
 	ATH_FREE_BANK(ah->analogBank1Data);
 	ATH_FREE_BANK(ah->analogBank2Data);
@@ -910,7 +906,7 @@ bool ath9k_hw_set_rf_regs(struct ath_hw *ah, struct ath9k_channel *chan,
 	 * for single chip devices, that is AR9280 or anything
 	 * after that.
 	 */
-	if (AR_SREV_9280_10_OR_LATER(ah))
+	if (AR_SREV_9280_10_OR_LATER(ah) || AR_SREV_9271(ah))
 		return true;
 
 	/* Setup rf parameters */
-- 
1.7.0

