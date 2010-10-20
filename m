Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:54437 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753507Ab0JTBI6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Oct 2010 21:08:58 -0400
Message-ID: <4CBE4125.4050403@openwrt.org>
Date: Wed, 20 Oct 2010 03:08:53 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH v2 2/3] ath9k_hw: extend ath9k_hw_set_txpowerlimit to test
 channel txpower
References: <1287533386-68715-1-git-send-email-nbd@openwrt.org> <1287533386-68715-2-git-send-email-nbd@openwrt.org>
In-Reply-To: <1287533386-68715-2-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k_hw_set_txpowerlimit gets an extra boolean parameter that - if set -
causes the rate txpower table and the regulatory limit to be calculated
and stored, without changing hardware registers.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 v2: use the maximum tx power from the rate table instead of the channel default

 drivers/net/wireless/ath/ath9k/ar5008_phy.c    |    2 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   20 +++++--
 drivers/net/wireless/ath/ath9k/ar9003_phy.c    |    2 +-
 drivers/net/wireless/ath/ath9k/eeprom.h        |    3 +-
 drivers/net/wireless/ath/ath9k/eeprom_4k.c     |    9 +++-
 drivers/net/wireless/ath/ath9k/eeprom_9287.c   |   27 ++++++-----
 drivers/net/wireless/ath/ath9k/eeprom_def.c    |   62 +++++++++++++-----------
 drivers/net/wireless/ath/ath9k/htc_drv_main.c  |    2 +-
 drivers/net/wireless/ath/ath9k/hw.c            |    6 +-
 drivers/net/wireless/ath/ath9k/hw.h            |    2 +-
 drivers/net/wireless/ath/ath9k/main.c          |    2 +-
 11 files changed, 79 insertions(+), 58 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index c0e7939..9fa8c14 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -875,7 +875,7 @@ static int ar5008_hw_process_ini(struct ath_hw *ah,
 				 channel->max_antenna_gain * 2,
 				 channel->max_power * 2,
 				 min((u32) MAX_RATE_POWER,
-				 (u32) regulatory->power_limit));
+				 (u32) regulatory->power_limit), false);
 
 	/* Write analog registers */
 	if (!ath9k_hw_set_rf_regs(ah, chan, freqIndex)) {
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 92cfef2..a88fe0d 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -2131,7 +2131,7 @@ static void ath9k_hw_ar9300_set_txpower(struct ath_hw *ah,
 					struct ath9k_channel *chan, u16 cfgCtl,
 					u8 twiceAntennaReduction,
 					u8 twiceMaxRegulatoryPower,
-					u8 powerLimit)
+					u8 powerLimit, bool test)
 {
 	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
 	struct ath_common *common = ath9k_hw_common(ah);
@@ -2145,7 +2145,16 @@ static void ath9k_hw_ar9300_set_txpower(struct ath_hw *ah,
 					   twiceMaxRegulatoryPower,
 					   powerLimit);
 
-	while (i < ar9300RateSize) {
+	regulatory->max_power_level = 0;
+	for (i = 0; i < ar9300RateSize; i++) {
+		if (targetPowerValT2[i] > regulatory->max_power_level)
+			regulatory->max_power_level = targetPowerValT2[i];
+	}
+
+	if (test)
+		return;
+
+	for (i = 0; i < ar9300RateSize; i++) {
 		ath_print(common, ATH_DBG_EEPROM,
 			  "TPC[%02d] 0x%08x ", i, targetPowerValT2[i]);
 		i++;
@@ -2160,9 +2169,6 @@ static void ath9k_hw_ar9300_set_txpower(struct ath_hw *ah,
 		i++;
 	}
 
-	/* Write target power array to registers */
-	ar9003_hw_tx_power_regwrite(ah, targetPowerValT2);
-
 	/*
 	 * This is the TX power we send back to driver core,
 	 * and it can use to pass to userspace to display our
@@ -2181,8 +2187,10 @@ static void ath9k_hw_ar9300_set_txpower(struct ath_hw *ah,
 		i = ALL_TARGET_HT20_0_8_16; /* ht20 */
 
 	ah->txpower_limit = targetPowerValT2[i];
-	regulatory->max_power_level = ratesArray[i];
+	regulatory->max_power_level = targetPowerValT2[i];
 
+	/* Write target power array to registers */
+	ar9003_hw_tx_power_regwrite(ah, targetPowerValT2);
 	ar9003_hw_calibration_apply(ah, chan->channel);
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 669b777..06a9c4c 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -614,7 +614,7 @@ static int ar9003_hw_process_ini(struct ath_hw *ah,
 				 channel->max_antenna_gain * 2,
 				 channel->max_power * 2,
 				 min((u32) MAX_RATE_POWER,
-				 (u32) regulatory->power_limit));
+				 (u32) regulatory->power_limit), false);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless/ath/ath9k/eeprom.h
index dacb45e..3c99830 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h
@@ -680,7 +680,8 @@ struct eeprom_ops {
 	void (*set_addac)(struct ath_hw *hw, struct ath9k_channel *chan);
 	void (*set_txpower)(struct ath_hw *hw, struct ath9k_channel *chan,
 			   u16 cfgCtl, u8 twiceAntennaReduction,
-			   u8 twiceMaxRegulatoryPower, u8 powerLimit);
+			   u8 twiceMaxRegulatoryPower, u8 powerLimit,
+			   bool test);
 	u16 (*get_spur_channel)(struct ath_hw *ah, u16 i, bool is2GHz);
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index 4fa4d8e..c40c534 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -726,7 +726,7 @@ static void ath9k_hw_4k_set_txpower(struct ath_hw *ah,
 				    u16 cfgCtl,
 				    u8 twiceAntennaReduction,
 				    u8 twiceMaxRegulatoryPower,
-				    u8 powerLimit)
+				    u8 powerLimit, bool test)
 {
 	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
 	struct ar5416_eeprom_4k *pEepData = &ah->eeprom.map4k;
@@ -751,15 +751,20 @@ static void ath9k_hw_4k_set_txpower(struct ath_hw *ah,
 
 	ath9k_hw_set_4k_power_cal_table(ah, chan, &txPowerIndexOffset);
 
+	regulatory->max_power_level = 0;
 	for (i = 0; i < ARRAY_SIZE(ratesArray); i++) {
 		ratesArray[i] =	(int16_t)(txPowerIndexOffset + ratesArray[i]);
 		if (ratesArray[i] > AR5416_MAX_RATE_POWER)
 			ratesArray[i] = AR5416_MAX_RATE_POWER;
+
+		if (ratesArray[i] > regulatory->max_power_level)
+			regulatory->max_power_level = ratesArray[i];
 	}
 
+	if (test)
+	    return;
 
 	/* Update regulatory */
-
 	i = rate6mb;
 	if (IS_CHAN_HT40(chan))
 		i = rateHt40_0;
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index 966b949..ebf7a89 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -853,7 +853,7 @@ static void ath9k_hw_ar9287_set_txpower(struct ath_hw *ah,
 					struct ath9k_channel *chan, u16 cfgCtl,
 					u8 twiceAntennaReduction,
 					u8 twiceMaxRegulatoryPower,
-					u8 powerLimit)
+					u8 powerLimit, bool test)
 {
 	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
 	struct ar9287_eeprom *pEepData = &ah->eeprom.map9287;
@@ -877,12 +877,26 @@ static void ath9k_hw_ar9287_set_txpower(struct ath_hw *ah,
 
 	ath9k_hw_set_ar9287_power_cal_table(ah, chan, &txPowerIndexOffset);
 
+	regulatory->max_power_level = 0;
 	for (i = 0; i < ARRAY_SIZE(ratesArray); i++) {
 		ratesArray[i] = (int16_t)(txPowerIndexOffset + ratesArray[i]);
 		if (ratesArray[i] > AR9287_MAX_RATE_POWER)
 			ratesArray[i] = AR9287_MAX_RATE_POWER;
+
+		if (ratesArray[i] > regulatory->max_power_level)
+			regulatory->max_power_level = ratesArray[i];
 	}
 
+	if (test)
+		return;
+
+	if (IS_CHAN_2GHZ(chan))
+		i = rate1l;
+	else
+		i = rate6mb;
+
+	regulatory->max_power_level = ratesArray[i];
+
 	if (AR_SREV_9280_20_OR_LATER(ah)) {
 		for (i = 0; i < Ar5416RateSize; i++)
 			ratesArray[i] -= AR9287_PWR_TABLE_OFFSET_DB * 2;
@@ -971,17 +985,6 @@ static void ath9k_hw_ar9287_set_txpower(struct ath_hw *ah,
 			  | ATH9K_POW_SM(ratesArray[rateDupOfdm], 8)
 			  | ATH9K_POW_SM(ratesArray[rateDupCck], 0));
 	}
-
-	if (IS_CHAN_2GHZ(chan))
-		i = rate1l;
-	else
-		i = rate6mb;
-
-	if (AR_SREV_9280_20_OR_LATER(ah))
-		regulatory->max_power_level =
-			ratesArray[i] + AR9287_PWR_TABLE_OFFSET_DB * 2;
-	else
-		regulatory->max_power_level = ratesArray[i];
 }
 
 static void ath9k_hw_ar9287_set_addac(struct ath_hw *ah,
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index 76b4d65..a819ddc 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -1258,7 +1258,7 @@ static void ath9k_hw_def_set_txpower(struct ath_hw *ah,
 				    u16 cfgCtl,
 				    u8 twiceAntennaReduction,
 				    u8 twiceMaxRegulatoryPower,
-				    u8 powerLimit)
+				    u8 powerLimit, bool test)
 {
 #define RT_AR_DELTA(x) (ratesArray[x] - cck_ofdm_delta)
 	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
@@ -1285,12 +1285,44 @@ static void ath9k_hw_def_set_txpower(struct ath_hw *ah,
 
 	ath9k_hw_set_def_power_cal_table(ah, chan, &txPowerIndexOffset);
 
+	regulatory->max_power_level = 0;
 	for (i = 0; i < ARRAY_SIZE(ratesArray); i++) {
 		ratesArray[i] =	(int16_t)(txPowerIndexOffset + ratesArray[i]);
 		if (ratesArray[i] > AR5416_MAX_RATE_POWER)
 			ratesArray[i] = AR5416_MAX_RATE_POWER;
+		if (ratesArray[i] > regulatory->max_power_level)
+			regulatory->max_power_level = ratesArray[i];
 	}
 
+	if (!test) {
+		i = rate6mb;
+
+		if (IS_CHAN_HT40(chan))
+			i = rateHt40_0;
+		else if (IS_CHAN_HT20(chan))
+			i = rateHt20_0;
+
+		regulatory->max_power_level = ratesArray[i];
+	}
+
+	switch(ar5416_get_ntxchains(ah->txchainmask)) {
+	case 1:
+		break;
+	case 2:
+		regulatory->max_power_level += INCREASE_MAXPOW_BY_TWO_CHAIN;
+		break;
+	case 3:
+		regulatory->max_power_level += INCREASE_MAXPOW_BY_THREE_CHAIN;
+		break;
+	default:
+		ath_print(ath9k_hw_common(ah), ATH_DBG_EEPROM,
+			  "Invalid chainmask configuration\n");
+		break;
+	}
+
+	if (test)
+		return;
+
 	if (AR_SREV_9280_20_OR_LATER(ah)) {
 		for (i = 0; i < Ar5416RateSize; i++) {
 			int8_t pwr_table_offset;
@@ -1387,34 +1419,6 @@ static void ath9k_hw_def_set_txpower(struct ath_hw *ah,
 	REG_WRITE(ah, AR_PHY_POWER_TX_SUB,
 		  ATH9K_POW_SM(pModal->pwrDecreaseFor3Chain, 6)
 		  | ATH9K_POW_SM(pModal->pwrDecreaseFor2Chain, 0));
-
-	i = rate6mb;
-
-	if (IS_CHAN_HT40(chan))
-		i = rateHt40_0;
-	else if (IS_CHAN_HT20(chan))
-		i = rateHt20_0;
-
-	if (AR_SREV_9280_20_OR_LATER(ah))
-		regulatory->max_power_level =
-			ratesArray[i] + AR5416_PWR_TABLE_OFFSET_DB * 2;
-	else
-		regulatory->max_power_level = ratesArray[i];
-
-	switch(ar5416_get_ntxchains(ah->txchainmask)) {
-	case 1:
-		break;
-	case 2:
-		regulatory->max_power_level += INCREASE_MAXPOW_BY_TWO_CHAIN;
-		break;
-	case 3:
-		regulatory->max_power_level += INCREASE_MAXPOW_BY_THREE_CHAIN;
-		break;
-	default:
-		ath_print(ath9k_hw_common(ah), ATH_DBG_EEPROM,
-			  "Invalid chainmask configuration\n");
-		break;
-	}
 }
 
 static u8 ath9k_hw_def_get_num_ant_config(struct ath_hw *ah,
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 55c8086..1e5323e 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -29,7 +29,7 @@ static void ath_update_txpow(struct ath9k_htc_priv *priv)
 	struct ath_hw *ah = priv->ah;
 
 	if (priv->curtxpow != priv->txpowlimit) {
-		ath9k_hw_set_txpowerlimit(ah, priv->txpowlimit);
+		ath9k_hw_set_txpowerlimit(ah, priv->txpowlimit, false);
 		/* read back in case value is clamped */
 		priv->curtxpow = ath9k_hw_regulatory(ah)->power_limit;
 	}
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index d37a8ad..e75d8e8 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1166,7 +1166,7 @@ static bool ath9k_hw_channel_change(struct ath_hw *ah,
 			     channel->max_antenna_gain * 2,
 			     channel->max_power * 2,
 			     min((u32) MAX_RATE_POWER,
-			     (u32) regulatory->power_limit));
+			     (u32) regulatory->power_limit), false);
 
 	ath9k_hw_rfbus_done(ah);
 
@@ -2165,7 +2165,7 @@ bool ath9k_hw_disable(struct ath_hw *ah)
 }
 EXPORT_SYMBOL(ath9k_hw_disable);
 
-void ath9k_hw_set_txpowerlimit(struct ath_hw *ah, u32 limit)
+void ath9k_hw_set_txpowerlimit(struct ath_hw *ah, u32 limit, bool test)
 {
 	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
 	struct ath9k_channel *chan = ah->curchan;
@@ -2178,7 +2178,7 @@ void ath9k_hw_set_txpowerlimit(struct ath_hw *ah, u32 limit)
 				 channel->max_antenna_gain * 2,
 				 channel->max_power * 2,
 				 min((u32) MAX_RATE_POWER,
-				 (u32) regulatory->power_limit));
+				 (u32) regulatory->power_limit), test);
 }
 EXPORT_SYMBOL(ath9k_hw_set_txpowerlimit);
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index e68204a..366f088 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -860,7 +860,7 @@ u32 ath9k_hw_getrxfilter(struct ath_hw *ah);
 void ath9k_hw_setrxfilter(struct ath_hw *ah, u32 bits);
 bool ath9k_hw_phy_disable(struct ath_hw *ah);
 bool ath9k_hw_disable(struct ath_hw *ah);
-void ath9k_hw_set_txpowerlimit(struct ath_hw *ah, u32 limit);
+void ath9k_hw_set_txpowerlimit(struct ath_hw *ah, u32 limit, bool test);
 void ath9k_hw_setopmode(struct ath_hw *ah);
 void ath9k_hw_setmcastfilter(struct ath_hw *ah, u32 filter0, u32 filter1);
 void ath9k_hw_setbssidmask(struct ath_hw *ah);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index dcd94ba..8bce54d 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -23,7 +23,7 @@ static void ath_update_txpow(struct ath_softc *sc)
 	struct ath_hw *ah = sc->sc_ah;
 
 	if (sc->curtxpow != sc->config.txpowlimit) {
-		ath9k_hw_set_txpowerlimit(ah, sc->config.txpowlimit);
+		ath9k_hw_set_txpowerlimit(ah, sc->config.txpowlimit, false);
 		/* read back in case value is clamped */
 		sc->curtxpow = ath9k_hw_regulatory(ah)->power_limit;
 	}
