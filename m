Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:60286 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752885Ab0IVKfI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 06:35:08 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 1/3] ath9k_hw: simplify revision checks for AR9280
Date: Wed, 22 Sep 2010 12:34:52 +0200
Message-Id: <1285151694-39227-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since AR9280 v1.0 was never sold (and the initvals removed), v1.0 specific
revision checks can be removed and the 'v2.0 or later' check can be
simplified to a check for AR9280 or later.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar5008_phy.c   |   14 +++++++-------
 drivers/net/wireless/ath/ath9k/ar9002_calib.c |    6 +++---
 drivers/net/wireless/ath/ath9k/ar9002_hw.c    |    2 +-
 drivers/net/wireless/ath/ath9k/eeprom_4k.c    |    4 ++--
 drivers/net/wireless/ath/ath9k/eeprom_9287.c  |    6 +++---
 drivers/net/wireless/ath/ath9k/eeprom_def.c   |   18 +++++++++---------
 drivers/net/wireless/ath/ath9k/hw.c           |   15 +++++++--------
 drivers/net/wireless/ath/ath9k/init.c         |    2 +-
 drivers/net/wireless/ath/ath9k/recv.c         |    2 +-
 drivers/net/wireless/ath/ath9k/reg.h          |    9 ++-------
 10 files changed, 36 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index 3d2c867..9318ae7 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -118,7 +118,7 @@ static void ar5008_hw_force_bias(struct ath_hw *ah, u16 synth_freq)
 	if (!AR_SREV_5416(ah) || synth_freq >= 3000)
 		return;
 
-	BUG_ON(AR_SREV_9280_10_OR_LATER(ah));
+	BUG_ON(AR_SREV_9280_20_OR_LATER(ah));
 
 	if (synth_freq < 2412)
 		new_bias = 0;
@@ -454,7 +454,7 @@ static int ar5008_hw_rf_alloc_ext_banks(struct ath_hw *ah)
 
 	struct ath_common *common = ath9k_hw_common(ah);
 
-	BUG_ON(AR_SREV_9280_10_OR_LATER(ah));
+	BUG_ON(AR_SREV_9280_20_OR_LATER(ah));
 
 	ATH_ALLOC_BANK(ah->analogBank0Data, ah->iniBank0.ia_rows);
 	ATH_ALLOC_BANK(ah->analogBank1Data, ah->iniBank1.ia_rows);
@@ -484,7 +484,7 @@ static void ar5008_hw_rf_free_ext_banks(struct ath_hw *ah)
 		bank = NULL; \
 	} while (0);
 
-	BUG_ON(AR_SREV_9280_10_OR_LATER(ah));
+	BUG_ON(AR_SREV_9280_20_OR_LATER(ah));
 
 	ATH_FREE_BANK(ah->analogBank0Data);
 	ATH_FREE_BANK(ah->analogBank1Data);
@@ -525,7 +525,7 @@ static bool ar5008_hw_set_rf_regs(struct ath_hw *ah,
 	 * for single chip devices, that is AR9280 or anything
 	 * after that.
 	 */
-	if (AR_SREV_9280_10_OR_LATER(ah))
+	if (AR_SREV_9280_20_OR_LATER(ah))
 		return true;
 
 	/* Setup rf parameters */
@@ -663,7 +663,7 @@ static void ar5008_hw_override_ini(struct ath_hw *ah,
 	 */
 	REG_SET_BIT(ah, AR_DIAG_SW, (AR_DIAG_RX_DIS | AR_DIAG_RX_ABORT));
 
-	if (AR_SREV_9280_10_OR_LATER(ah)) {
+	if (AR_SREV_9280_20_OR_LATER(ah)) {
 		val = REG_READ(ah, AR_PCU_MISC_MODE2);
 
 		if (!AR_SREV_9271(ah))
@@ -676,7 +676,7 @@ static void ar5008_hw_override_ini(struct ath_hw *ah,
 	}
 
 	if (!AR_SREV_5416_20_OR_LATER(ah) ||
-	    AR_SREV_9280_10_OR_LATER(ah))
+	    AR_SREV_9280_20_OR_LATER(ah))
 		return;
 	/*
 	 * Disable BB clock gating
@@ -900,7 +900,7 @@ static void ar5008_hw_set_rfmode(struct ath_hw *ah, struct ath9k_channel *chan)
 	rfMode |= (IS_CHAN_B(chan) || IS_CHAN_G(chan))
 		? AR_PHY_MODE_DYNAMIC : AR_PHY_MODE_OFDM;
 
-	if (!AR_SREV_9280_10_OR_LATER(ah))
+	if (!AR_SREV_9280_20_OR_LATER(ah))
 		rfMode |= (IS_CHAN_5GHZ(chan)) ?
 			AR_PHY_MODE_RF5GHZ : AR_PHY_MODE_RF2GHZ;
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_calib.c b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
index fe7418a..dc64afe 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
@@ -841,7 +841,7 @@ static bool ar9002_hw_init_cal(struct ath_hw *ah, struct ath9k_channel *chan)
 		if (!ar9285_hw_clc(ah, chan))
 			return false;
 	} else {
-		if (AR_SREV_9280_10_OR_LATER(ah)) {
+		if (AR_SREV_9280_20_OR_LATER(ah)) {
 			if (!AR_SREV_9287_10_OR_LATER(ah))
 				REG_CLR_BIT(ah, AR_PHY_ADC_CTL,
 					    AR_PHY_ADC_CTL_OFF_PWDADC);
@@ -864,7 +864,7 @@ static bool ar9002_hw_init_cal(struct ath_hw *ah, struct ath9k_channel *chan)
 			return false;
 		}
 
-		if (AR_SREV_9280_10_OR_LATER(ah)) {
+		if (AR_SREV_9280_20_OR_LATER(ah)) {
 			if (!AR_SREV_9287_10_OR_LATER(ah))
 				REG_SET_BIT(ah, AR_PHY_ADC_CTL,
 					    AR_PHY_ADC_CTL_OFF_PWDADC);
@@ -976,7 +976,7 @@ static void ar9002_hw_init_cal_settings(struct ath_hw *ah)
 	}
 
 	if (AR_SREV_9160_10_OR_LATER(ah)) {
-		if (AR_SREV_9280_10_OR_LATER(ah)) {
+		if (AR_SREV_9280_20_OR_LATER(ah)) {
 			ah->iq_caldata.calData = &iq_cal_single_sample;
 			ah->adcgain_caldata.calData =
 				&adc_gain_cal_single_sample;
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_hw.c b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
index 94392da..fde45082 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
@@ -569,7 +569,7 @@ void ar9002_hw_attach_ops(struct ath_hw *ah)
 	ops->config_pci_powersave = ar9002_hw_configpcipowersave;
 
 	ar5008_hw_attach_phy_ops(ah);
-	if (AR_SREV_9280_10_OR_LATER(ah))
+	if (AR_SREV_9280_20_OR_LATER(ah))
 		ar9002_hw_attach_phy_ops(ah);
 
 	ar9002_hw_attach_calib_ops(ah);
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index ead8b0d..677e0c9 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -333,7 +333,7 @@ static void ath9k_hw_get_4k_gain_boundaries_pdadcs(struct ath_hw *ah,
 		}
 
 		if (i == 0) {
-			if (AR_SREV_9280_10_OR_LATER(ah))
+			if (AR_SREV_9280_20_OR_LATER(ah))
 				ss = (int16_t)(0 - (minPwrT4[i] / 2));
 			else
 				ss = 0;
@@ -761,7 +761,7 @@ static void ath9k_hw_4k_set_txpower(struct ath_hw *ah,
 
 	regulatory->max_power_level = ratesArray[i];
 
-	if (AR_SREV_9280_10_OR_LATER(ah)) {
+	if (AR_SREV_9280_20_OR_LATER(ah)) {
 		for (i = 0; i < Ar5416RateSize; i++)
 			ratesArray[i] -= AR5416_PWR_TABLE_OFFSET_DB * 2;
 	}
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index e618651..966b949 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -324,7 +324,7 @@ static void ath9k_hw_get_ar9287_gain_boundaries_pdadcs(struct ath_hw *ah,
 		minDelta = 0;
 
 		if (i == 0) {
-			if (AR_SREV_9280_10_OR_LATER(ah))
+			if (AR_SREV_9280_20_OR_LATER(ah))
 				ss = (int16_t)(0 - (minPwrT4[i] / 2));
 			else
 				ss = 0;
@@ -883,7 +883,7 @@ static void ath9k_hw_ar9287_set_txpower(struct ath_hw *ah,
 			ratesArray[i] = AR9287_MAX_RATE_POWER;
 	}
 
-	if (AR_SREV_9280_10_OR_LATER(ah)) {
+	if (AR_SREV_9280_20_OR_LATER(ah)) {
 		for (i = 0; i < Ar5416RateSize; i++)
 			ratesArray[i] -= AR9287_PWR_TABLE_OFFSET_DB * 2;
 	}
@@ -977,7 +977,7 @@ static void ath9k_hw_ar9287_set_txpower(struct ath_hw *ah,
 	else
 		i = rate6mb;
 
-	if (AR_SREV_9280_10_OR_LATER(ah))
+	if (AR_SREV_9280_20_OR_LATER(ah))
 		regulatory->max_power_level =
 			ratesArray[i] + AR9287_PWR_TABLE_OFFSET_DB * 2;
 	else
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index 23f480d..76b4d65 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -223,7 +223,7 @@ static int ath9k_hw_def_check_eeprom(struct ath_hw *ah)
 	}
 
 	/* Enable fixup for AR_AN_TOP2 if necessary */
-	if (AR_SREV_9280_10_OR_LATER(ah) &&
+	if (AR_SREV_9280_20_OR_LATER(ah) &&
 	    (eep->baseEepHeader.version & 0xff) > 0x0a &&
 	    eep->baseEepHeader.pwdclkind == 0)
 		ah->need_an_top2_fixup = 1;
@@ -317,7 +317,7 @@ static void ath9k_hw_def_set_gain(struct ath_hw *ah,
 	if (AR5416_VER_MASK >= AR5416_EEP_MINOR_VER_3) {
 		txRxAttenLocal = pModal->txRxAttenCh[i];
 
-		if (AR_SREV_9280_10_OR_LATER(ah)) {
+		if (AR_SREV_9280_20_OR_LATER(ah)) {
 			REG_RMW_FIELD(ah, AR_PHY_GAIN_2GHZ + regChainOffset,
 			      AR_PHY_GAIN_2GHZ_XATTEN1_MARGIN,
 			      pModal->bswMargin[i]);
@@ -344,7 +344,7 @@ static void ath9k_hw_def_set_gain(struct ath_hw *ah,
 		}
 	}
 
-	if (AR_SREV_9280_10_OR_LATER(ah)) {
+	if (AR_SREV_9280_20_OR_LATER(ah)) {
 		REG_RMW_FIELD(ah,
 		      AR_PHY_RXGAIN + regChainOffset,
 		      AR9280_PHY_RXGAIN_TXRX_ATTEN, txRxAttenLocal);
@@ -408,7 +408,7 @@ static void ath9k_hw_def_set_board_values(struct ath_hw *ah,
 					      regChainOffset, i);
 	}
 
-	if (AR_SREV_9280_10_OR_LATER(ah)) {
+	if (AR_SREV_9280_20_OR_LATER(ah)) {
 		if (IS_CHAN_2GHZ(chan)) {
 			ath9k_hw_analog_shift_rmw(ah, AR_AN_RF2G1_CH0,
 						  AR_AN_RF2G1_CH0_OB,
@@ -461,7 +461,7 @@ static void ath9k_hw_def_set_board_values(struct ath_hw *ah,
 	REG_RMW_FIELD(ah, AR_PHY_DESIRED_SZ, AR_PHY_DESIRED_SZ_ADC,
 		      pModal->adcDesiredSize);
 
-	if (!AR_SREV_9280_10_OR_LATER(ah))
+	if (!AR_SREV_9280_20_OR_LATER(ah))
 		REG_RMW_FIELD(ah, AR_PHY_DESIRED_SZ,
 			      AR_PHY_DESIRED_SZ_PGA,
 			      pModal->pgaDesiredSize);
@@ -478,7 +478,7 @@ static void ath9k_hw_def_set_board_values(struct ath_hw *ah,
 	REG_RMW_FIELD(ah, AR_PHY_RF_CTL3, AR_PHY_TX_END_TO_A2_RX_ON,
 		      pModal->txEndToRxOn);
 
-	if (AR_SREV_9280_10_OR_LATER(ah)) {
+	if (AR_SREV_9280_20_OR_LATER(ah)) {
 		REG_RMW_FIELD(ah, AR_PHY_CCA, AR9280_PHY_CCA_THRESH62,
 			      pModal->thresh62);
 		REG_RMW_FIELD(ah, AR_PHY_EXT_CCA0,
@@ -696,7 +696,7 @@ static void ath9k_hw_get_def_gain_boundaries_pdadcs(struct ath_hw *ah,
 		}
 
 		if (i == 0) {
-			if (AR_SREV_9280_10_OR_LATER(ah))
+			if (AR_SREV_9280_20_OR_LATER(ah))
 				ss = (int16_t)(0 - (minPwrT4[i] / 2));
 			else
 				ss = 0;
@@ -1291,7 +1291,7 @@ static void ath9k_hw_def_set_txpower(struct ath_hw *ah,
 			ratesArray[i] = AR5416_MAX_RATE_POWER;
 	}
 
-	if (AR_SREV_9280_10_OR_LATER(ah)) {
+	if (AR_SREV_9280_20_OR_LATER(ah)) {
 		for (i = 0; i < Ar5416RateSize; i++) {
 			int8_t pwr_table_offset;
 
@@ -1395,7 +1395,7 @@ static void ath9k_hw_def_set_txpower(struct ath_hw *ah,
 	else if (IS_CHAN_HT20(chan))
 		i = rateHt20_0;
 
-	if (AR_SREV_9280_10_OR_LATER(ah))
+	if (AR_SREV_9280_20_OR_LATER(ah))
 		regulatory->max_power_level =
 			ratesArray[i] + AR5416_PWR_TABLE_OFFSET_DB * 2;
 	else
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 0b2ff98..f2255a2 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -565,7 +565,7 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 	ath9k_hw_init_cal_settings(ah);
 
 	ah->ani_function = ATH9K_ANI_ALL;
-	if (AR_SREV_9280_10_OR_LATER(ah) && !AR_SREV_9300_20_OR_LATER(ah))
+	if (AR_SREV_9280_20_OR_LATER(ah) && !AR_SREV_9300_20_OR_LATER(ah))
 		ah->ani_function &= ~ATH9K_ANI_NOISE_IMMUNITY_LEVEL;
 	if (!AR_SREV_9300_20_OR_LATER(ah))
 		ah->ani_function &= ~ATH9K_ANI_MRC_CCK;
@@ -1312,7 +1312,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	if (tsf)
 		ath9k_hw_settsf64(ah, tsf);
 
-	if (AR_SREV_9280_10_OR_LATER(ah))
+	if (AR_SREV_9280_20_OR_LATER(ah))
 		REG_SET_BIT(ah, AR_GPIO_INPUT_EN_VAL, AR_GPIO_JTAG_DISABLE);
 
 	if (!AR_SREV_9300_20_OR_LATER(ah))
@@ -1857,8 +1857,7 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 		/* Use rx_chainmask from EEPROM. */
 		pCap->rx_chainmask = ah->eep_ops->get_eeprom(ah, EEP_RX_MASK);
 
-	if (!(AR_SREV_9280(ah) && (ah->hw_version.macRev == 0)))
-		ah->misc_mode |= AR_PCU_MIC_NEW_LOC_ENA;
+	ah->misc_mode |= AR_PCU_MIC_NEW_LOC_ENA;
 
 	pCap->low_2ghz_chan = 2312;
 	pCap->high_2ghz_chan = 2732;
@@ -1896,7 +1895,7 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 		pCap->num_gpio_pins = AR7010_NUM_GPIO;
 	else if (AR_SREV_9285_10_OR_LATER(ah))
 		pCap->num_gpio_pins = AR9285_NUM_GPIO;
-	else if (AR_SREV_9280_10_OR_LATER(ah))
+	else if (AR_SREV_9280_20_OR_LATER(ah))
 		pCap->num_gpio_pins = AR928X_NUM_GPIO;
 	else
 		pCap->num_gpio_pins = AR_NUM_GPIO;
@@ -1953,7 +1952,7 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	pCap->num_antcfg_2ghz =
 		ah->eep_ops->get_num_ant_config(ah, ATH9K_HAL_FREQ_BAND_2GHZ);
 
-	if (AR_SREV_9280_10_OR_LATER(ah) &&
+	if (AR_SREV_9280_20_OR_LATER(ah) &&
 	    ath9k_hw_btcoex_supported(ah)) {
 		btcoex_hw->btactive_gpio = ATH_BTACTIVE_GPIO;
 		btcoex_hw->wlanactive_gpio = ATH_WLANACTIVE_GPIO;
@@ -2078,7 +2077,7 @@ u32 ath9k_hw_gpio_get(struct ath_hw *ah, u32 gpio)
 		return MS_REG_READ(AR9287, gpio) != 0;
 	else if (AR_SREV_9285_10_OR_LATER(ah))
 		return MS_REG_READ(AR9285, gpio) != 0;
-	else if (AR_SREV_9280_10_OR_LATER(ah))
+	else if (AR_SREV_9280_20_OR_LATER(ah))
 		return MS_REG_READ(AR928X, gpio) != 0;
 	else
 		return MS_REG_READ(AR, gpio) != 0;
@@ -2575,7 +2574,7 @@ void ath9k_hw_name(struct ath_hw *ah, char *hw_name, size_t len)
 	int used;
 
 	/* chipsets >= AR9280 are single-chip */
-	if (AR_SREV_9280_10_OR_LATER(ah)) {
+	if (AR_SREV_9280_20_OR_LATER(ah)) {
 		used = snprintf(hw_name, len,
 			       "Atheros AR%s Rev:%x",
 			       ath9k_hw_mac_bb_name(ah->hw_version.macVersion),
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 573899e..de33938 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -211,7 +211,7 @@ static void setup_ht_cap(struct ath_softc *sc,
 	else
 		max_streams = 2;
 
-	if (AR_SREV_9280_10_OR_LATER(ah)) {
+	if (AR_SREV_9280_20_OR_LATER(ah)) {
 		if (max_streams >= 2)
 			ht_info->cap |= IEEE80211_HT_CAP_TX_STBC;
 		ht_info->cap |= (1 << IEEE80211_HT_CAP_RX_STBC_SHIFT);
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index c5e7af4..7b6f66b 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -454,7 +454,7 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
 	else
 		rfilt |= ATH9K_RX_FILTER_BEACON;
 
-	if ((AR_SREV_9280_10_OR_LATER(sc->sc_ah) ||
+	if ((AR_SREV_9280_20_OR_LATER(sc->sc_ah) ||
 	    AR_SREV_9285_10_OR_LATER(sc->sc_ah)) &&
 	    (sc->sc_ah->opmode == NL80211_IFTYPE_AP) &&
 	    (sc->rx.rxfilter & FIF_PSPOLL))
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index d01c4ad..cabfa03 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -819,15 +819,10 @@
 	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9160_11))
 #define AR_SREV_9280(_ah) \
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9280))
-#define AR_SREV_9280_10_OR_LATER(_ah) \
+#define AR_SREV_9280_20_OR_LATER(_ah) \
 	(((_ah)->hw_version.macVersion >= AR_SREV_VERSION_9280))
 #define AR_SREV_9280_20(_ah) \
-	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9280) && \
-		((_ah)->hw_version.macRev >= AR_SREV_REVISION_9280_20))
-#define AR_SREV_9280_20_OR_LATER(_ah) \
-	(((_ah)->hw_version.macVersion > AR_SREV_VERSION_9280) || \
-	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9280) && \
-	((_ah)->hw_version.macRev >= AR_SREV_REVISION_9280_20)))
+	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9280))
 
 #define AR_SREV_9285(_ah) \
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9285))
-- 
1.7.2.2

