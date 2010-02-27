Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:60495 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966773Ab0B0BUK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Feb 2010 20:20:10 -0500
Subject: Re: [PATCH] ath9k_htc: Add ath9k_htc driver
From: Pavel Roskin <proski@gnu.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Sujith <Sujith.Manoharan@atheros.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, Vasanth.Thiagarajan@atheros.com,
	Senthilkumar.Balasubramanian@atheros.com
In-Reply-To: <43e72e891002261042s587f9fb8g9f491b1bac363582@mail.gmail.com>
References: <19335.43241.887933.207404@gargle.gargle.HOWL>
	 <1267209201.30426.8.camel@mj>
	 <43e72e891002261042s587f9fb8g9f491b1bac363582@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 26 Feb 2010 20:19:55 -0500
Message-Id: <1267233595.2835.20.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-02-26 at 10:42 -0800, Luis R. Rodriguez wrote:

> While at it, if you can separate the ath9k_hw changes that would be great.

OK, I left the changes that could affect other hardware and comment
changes.  I removed the code that doesn't affect AR9271 and formatting
changes.

This piece of code is almost certainly wrong (it addition to being
longer than 80 characters:

if (AR_SREV_9271(ah) && (ah->eep_ops->get_eeprom(ah, EEP_TXGAIN_TYPE) == 1)) {
        REG_WRITE_ARRAY(&ah->iniModes_high_power_tx_gain_9271,
                        modesIndex, regWrites);
} else {
        REG_WRITE_ARRAY(&ah->iniModes_normal_power_tx_gain_9271,
                        modesIndex, regWrites);
}

I think the right code would be

if (AR_SREV_9271(ah)) {
        if (ah->eep_ops->get_eeprom(ah, EEP_TXGAIN_TYPE) == 1))
                REG_WRITE_ARRAY(&ah->iniModes_high_power_tx_gain_9271,
                                modesIndex, regWrites);
        else
                REG_WRITE_ARRAY(&ah->iniModes_normal_power_tx_gain_9271,
                                modesIndex, regWrites);
}

Better yet, I would use a variable and refactor REG_WRITE_ARRAY.

This code also looks wrong:

                val = REG_READ(ah, AR_PCU_MISC_MODE2) &
                               (~AR_PCU_MISC_MODE2_HWWAR1);

                if (!AR_SREV_9271(ah))
                        val &= ~AR_PCU_MISC_MODE2_HWWAR1;

I think it should be:

                val = REG_READ(ah, AR_PCU_MISC_MODE2);

                if (!AR_SREV_9271(ah))
                        val &= ~AR_PCU_MISC_MODE2_HWWAR1;

The change involving ATH_HW_INITIALIZED appears to be a serious bugfix,
perhaps even suitable for stable kernels.

The message "Running PA Calibration" would be more suitable in
ath9k_hw_init_cal().

The original patch should be run through checkpatch.pl.  In addition to
overly long lines, there are some other formatting issues.

Here's the patch (changes potentially affecting other hardware and comments)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index 238a574..be82f05 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -815,6 +815,7 @@ static void ath9k_olc_temp_compensation(struct ath_hw *ah)
 
 static void ath9k_hw_9271_pa_cal(struct ath_hw *ah, bool is_reset)
 {
+	struct ath_common *common = ath9k_hw_common(ah);
 	u32 regVal;
 	unsigned int i;
 	u32 regList [][2] = {
@@ -828,6 +829,8 @@ static void ath9k_hw_9271_pa_cal(struct ath_hw *ah, bool is_reset)
 		{ 0x7828, 0 } ,
 	};
 
+	ath_print(common, ATH_DBG_CALIBRATE, "Running PA Calibration\n");
+
 	for (i = 0; i < ARRAY_SIZE(regList); i++)
 		regList[i][1] = REG_READ(ah, regList[i][0]);
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index f00f5c7..959f964 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1240,7 +1240,7 @@ void ath9k_hw_deinit(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
 
-	if (common->state <= ATH_HW_INITIALIZED)
+	if (common->state < ATH_HW_INITIALIZED)
 		goto free_hw;
 
 	if (!AR_SREV_9100(ah))
@@ -1251,8 +1251,6 @@ void ath9k_hw_deinit(struct ath_hw *ah)
 free_hw:
 	if (!AR_SREV_9280_10_OR_LATER(ah))
 		ath9k_hw_rf_free_ext_banks(ah);
-	kfree(ah);
-	ah = NULL;
 }
 EXPORT_SYMBOL(ath9k_hw_deinit);
 
@@ -1296,6 +1294,9 @@ static void ath9k_hw_override_ini(struct ath_hw *ah,
 		val = REG_READ(ah, AR_PCU_MISC_MODE2) &
 			       (~AR_PCU_MISC_MODE2_HWWAR1);
 
+		if (!AR_SREV_9271(ah))
+			val &= ~AR_PCU_MISC_MODE2_HWWAR1;
+
 		if (AR_SREV_9287_10_OR_LATER(ah))
 			val = val & (~AR_PCU_MISC_MODE2_HWWAR2);
 
@@ -1428,7 +1429,10 @@ static int ath9k_hw_process_ini(struct ath_hw *ah,
 		return -EINVAL;
 	}
 
+	/* Set correct baseband to analog shift setting to access analog chips */
 	REG_WRITE(ah, AR_PHY(0), 0x00000007);
+
+	/* Write ADDAC shifts */
 	REG_WRITE(ah, AR_PHY_ADC_SERIAL_CTL, AR_PHY_SEL_EXTERNAL_RADIO);
 	ah->eep_ops->set_addac(ah, chan);
 
@@ -1440,9 +1444,11 @@ static int ath9k_hw_process_ini(struct ath_hw *ah,
 			sizeof(u32) * ah->iniAddac.ia_rows *
 			ah->iniAddac.ia_columns;
 
+		/* For AR5416 2.0/2.1 */
 		memcpy(ah->addac5416_21,
 		       ah->iniAddac.ia_array, addacSize);
 
+		/* override CLKDRV value at [row, column] = [31, 1] */
 		(ah->addac5416_21)[31 * ah->iniAddac.ia_columns + 1] = 0;
 
 		temp.ia_array = ah->addac5416_21;
@@ -1474,6 +1480,7 @@ static int ath9k_hw_process_ini(struct ath_hw *ah,
 	    AR_SREV_9287_10_OR_LATER(ah))
 		REG_WRITE_ARRAY(&ah->iniModesTxGain, modesIndex, regWrites);
 
+	/* Write common array parameters */
 	for (i = 0; i < ah->iniCommon.ia_rows; i++) {
 		u32 reg = INI_RA(&ah->iniCommon, i, 0);
 		u32 val = INI_RA(&ah->iniCommon, i, 1);
@@ -1488,11 +1495,15 @@ static int ath9k_hw_process_ini(struct ath_hw *ah,
 		DO_DELAY(regWrites);
 	}
 
-	ath9k_hw_write_regs(ah, freqIndex, regWrites);
-
-	if (AR_SREV_9271_10(ah))
-		REG_WRITE_ARRAY(&ah->iniModes_9271_1_0_only,
+	if (AR_SREV_9271(ah) && (ah->eep_ops->get_eeprom(ah, EEP_TXGAIN_TYPE) == 1)) {
+		REG_WRITE_ARRAY(&ah->iniModes_high_power_tx_gain_9271,
 				modesIndex, regWrites);
+	} else {
+		REG_WRITE_ARRAY(&ah->iniModes_normal_power_tx_gain_9271,
+				modesIndex, regWrites);
+	}
+
+	ath9k_hw_write_regs(ah, freqIndex, regWrites);
 
 	if (AR_SREV_9280_20(ah) && IS_CHAN_A_5MHZ_SPACED(chan)) {
 		REG_WRITE_ARRAY(&ah->iniModesAdditional, modesIndex,
@@ -1506,6 +1517,7 @@ static int ath9k_hw_process_ini(struct ath_hw *ah,
 	if (OLC_FOR_AR9280_20_LATER)
 		ath9k_olc_init(ah);
 
+	/* Set TX power */
 	ah->eep_ops->set_txpower(ah, chan,
 				 ath9k_regd_get_ctl(regulatory, chan),
 				 channel->max_antenna_gain * 2,
@@ -1513,6 +1525,7 @@ static int ath9k_hw_process_ini(struct ath_hw *ah,
 				 min((u32) MAX_RATE_POWER,
 				 (u32) regulatory->power_limit));
 
+	/* Write analog registers */
 	if (!ath9k_hw_set_rf_regs(ah, chan, freqIndex)) {
 		ath_print(ath9k_hw_common(ah), ATH_DBG_FATAL,
 			  "ar5416SetRfRegs failed\n");
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 623c2f8..6063f54 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -758,6 +758,9 @@ static void ath9k_deinit_softc(struct ath_softc *sc)
 
 	tasklet_kill(&sc->intr_tq);
 	tasklet_kill(&sc->bcon_tasklet);
+
+	kfree(sc->sc_ah);
+	sc->sc_ah = NULL;
 }
 
 void ath9k_deinit_device(struct ath_softc *sc)
diff --git a/drivers/net/wireless/ath/ath9k/phy.c b/drivers/net/wireless/ath/ath9k/phy.c
index c3b5939..ec3f58c 100644
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


-- 
Regards,
Pavel Roskin
