Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:56767 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758239AbZEHM1D (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2009 08:27:03 -0400
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 08 May 2009 05:27:04 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 2/2] ath9k: Cleanup ineffective return values
Date: Fri, 8 May 2009 17:54:51 -0700
Message-ID: <1241830491-10912-2-git-send-email-vasanth@atheros.com>
In-Reply-To: <1241830491-10912-1-git-send-email-vasanth@atheros.com>
References: <1241830491-10912-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch makes the return type of some of the functions
void as those functions always return true

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/eeprom.c |   51 ++++++---------------------
 drivers/net/wireless/ath/ath9k/eeprom.h |    2 +-
 drivers/net/wireless/ath/ath9k/hw.c     |   57 ++++++++++--------------------
 drivers/net/wireless/ath/ath9k/hw.h     |    2 +-
 drivers/net/wireless/ath/ath9k/phy.c    |    7 +---
 drivers/net/wireless/ath/ath9k/phy.h    |    2 +-
 6 files changed, 36 insertions(+), 85 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom.c b/drivers/net/wireless/ath/ath9k/eeprom.c
index 44fee5a..a2fda70 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom.c
@@ -694,7 +694,7 @@ static void ath9k_hw_get_4k_gain_boundaries_pdadcs(struct ath_hw *ah,
 #undef TMP_VAL_VPD_TABLE
 }
 
-static bool ath9k_hw_set_4k_power_cal_table(struct ath_hw *ah,
+static void ath9k_hw_set_4k_power_cal_table(struct ath_hw *ah,
 				  struct ath9k_channel *chan,
 				  int16_t *pTxPowerIndexOffset)
 {
@@ -805,11 +805,9 @@ static bool ath9k_hw_set_4k_power_cal_table(struct ath_hw *ah,
 	}
 
 	*pTxPowerIndexOffset = 0;
-
-	return true;
 }
 
-static bool ath9k_hw_set_4k_power_per_rate_table(struct ath_hw *ah,
+static void ath9k_hw_set_4k_power_per_rate_table(struct ath_hw *ah,
 						 struct ath9k_channel *chan,
 						 int16_t *ratesArray,
 						 u16 cfgCtl,
@@ -1041,10 +1039,9 @@ static bool ath9k_hw_set_4k_power_per_rate_table(struct ath_hw *ah,
 		ratesArray[rateExtOfdm] = targetPowerOfdmExt.tPow2x[0];
 		ratesArray[rateExtCck] = targetPowerCckExt.tPow2x[0];
 	}
-	return true;
 }
 
-static int ath9k_hw_4k_set_txpower(struct ath_hw *ah,
+static void ath9k_hw_4k_set_txpower(struct ath_hw *ah,
 				   struct ath9k_channel *chan,
 				   u16 cfgCtl,
 				   u8 twiceAntennaReduction,
@@ -1065,22 +1062,13 @@ static int ath9k_hw_4k_set_txpower(struct ath_hw *ah,
 		ht40PowerIncForPdadc = pModal->ht40PowerIncForPdadc;
 	}
 
-	if (!ath9k_hw_set_4k_power_per_rate_table(ah, chan,
+	ath9k_hw_set_4k_power_per_rate_table(ah, chan,
 					       &ratesArray[0], cfgCtl,
 					       twiceAntennaReduction,
 					       twiceMaxRegulatoryPower,
-					       powerLimit)) {
-		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
-			"ath9k_hw_set_txpower: unable to set "
-			"tx power per rate table\n");
-		return -EIO;
-	}
+					       powerLimit);
 
-	if (!ath9k_hw_set_4k_power_cal_table(ah, chan, &txPowerIndexOffset)) {
-		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
-			 "ath9k_hw_set_txpower: unable to set power table\n");
-		return -EIO;
-	}
+	ath9k_hw_set_4k_power_cal_table(ah, chan, &txPowerIndexOffset);
 
 	for (i = 0; i < ARRAY_SIZE(ratesArray); i++) {
 		ratesArray[i] =	(int16_t)(txPowerIndexOffset + ratesArray[i]);
@@ -1168,7 +1156,6 @@ static int ath9k_hw_4k_set_txpower(struct ath_hw *ah,
 	else
 		ah->regulatory.max_power_level = ratesArray[i];
 
-	return 0;
 }
 
 static void ath9k_hw_4k_set_addac(struct ath_hw *ah,
@@ -2103,7 +2090,7 @@ static void ath9k_hw_get_def_gain_boundaries_pdadcs(struct ath_hw *ah,
 	return;
 }
 
-static bool ath9k_hw_set_def_power_cal_table(struct ath_hw *ah,
+static void ath9k_hw_set_def_power_cal_table(struct ath_hw *ah,
 				  struct ath9k_channel *chan,
 				  int16_t *pTxPowerIndexOffset)
 {
@@ -2255,13 +2242,11 @@ static bool ath9k_hw_set_def_power_cal_table(struct ath_hw *ah,
 	}
 
 	*pTxPowerIndexOffset = 0;
-
-	return true;
 #undef SM_PD_GAIN
 #undef SM_PDGAIN_B
 }
 
-static bool ath9k_hw_set_def_power_per_rate_table(struct ath_hw *ah,
+static void ath9k_hw_set_def_power_per_rate_table(struct ath_hw *ah,
 						  struct ath9k_channel *chan,
 						  int16_t *ratesArray,
 						  u16 cfgCtl,
@@ -2549,10 +2534,9 @@ static bool ath9k_hw_set_def_power_per_rate_table(struct ath_hw *ah,
 				targetPowerCckExt.tPow2x[0];
 		}
 	}
-	return true;
 }
 
-static int ath9k_hw_def_set_txpower(struct ath_hw *ah,
+static void ath9k_hw_def_set_txpower(struct ath_hw *ah,
 				    struct ath9k_channel *chan,
 				    u16 cfgCtl,
 				    u8 twiceAntennaReduction,
@@ -2575,22 +2559,13 @@ static int ath9k_hw_def_set_txpower(struct ath_hw *ah,
 		ht40PowerIncForPdadc = pModal->ht40PowerIncForPdadc;
 	}
 
-	if (!ath9k_hw_set_def_power_per_rate_table(ah, chan,
+	ath9k_hw_set_def_power_per_rate_table(ah, chan,
 					       &ratesArray[0], cfgCtl,
 					       twiceAntennaReduction,
 					       twiceMaxRegulatoryPower,
-					       powerLimit)) {
-		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
-			"ath9k_hw_set_txpower: unable to set "
-			"tx power per rate table\n");
-		return -EIO;
-	}
+					       powerLimit);
 
-	if (!ath9k_hw_set_def_power_cal_table(ah, chan, &txPowerIndexOffset)) {
-		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
-			 "ath9k_hw_set_txpower: unable to set power table\n");
-		return -EIO;
-	}
+	ath9k_hw_set_def_power_cal_table(ah, chan, &txPowerIndexOffset);
 
 	for (i = 0; i < ARRAY_SIZE(ratesArray); i++) {
 		ratesArray[i] =	(int16_t)(txPowerIndexOffset + ratesArray[i]);
@@ -2717,8 +2692,6 @@ static int ath9k_hw_def_set_txpower(struct ath_hw *ah,
 			"Invalid chainmask configuration\n");
 		break;
 	}
-
-	return 0;
 }
 
 static u8 ath9k_hw_def_get_num_ant_config(struct ath_hw *ah,
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless/ath/ath9k/eeprom.h
index 7c59dc4..67b8bd1 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h
@@ -494,7 +494,7 @@ struct eeprom_ops {
 				      struct ath9k_channel *chan);
 	void (*set_board_values)(struct ath_hw *hw, struct ath9k_channel *chan);
 	void (*set_addac)(struct ath_hw *hw, struct ath9k_channel *chan);
-	int (*set_txpower)(struct ath_hw *hw, struct ath9k_channel *chan,
+	void (*set_txpower)(struct ath_hw *hw, struct ath9k_channel *chan,
 			   u16 cfgCtl, u8 twiceAntennaReduction,
 			   u8 twiceMaxRegulatoryPower, u8 powerLimit);
 	u16 (*get_spur_channel)(struct ath_hw *ah, u16 i, bool is2GHz);
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 9e1db85..4acfab5 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1274,7 +1274,6 @@ static int ath9k_hw_process_ini(struct ath_hw *ah,
 	int i, regWrites = 0;
 	struct ieee80211_channel *channel = chan->chan;
 	u32 modesIndex, freqIndex;
-	int status;
 
 	switch (chan->chanmode) {
 	case CHANNEL_A:
@@ -1376,17 +1375,12 @@ static int ath9k_hw_process_ini(struct ath_hw *ah,
 	if (OLC_FOR_AR9280_20_LATER)
 		ath9k_olc_init(ah);
 
-	status = ah->eep_ops->set_txpower(ah, chan,
-				  ath9k_regd_get_ctl(&ah->regulatory, chan),
-				  channel->max_antenna_gain * 2,
-				  channel->max_power * 2,
-				  min((u32) MAX_RATE_POWER,
-				      (u32) ah->regulatory.power_limit));
-	if (status != 0) {
-		DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
-			"Error initializing transmit power\n");
-		return -EIO;
-	}
+	ah->eep_ops->set_txpower(ah, chan,
+				 ath9k_regd_get_ctl(&ah->regulatory, chan),
+				 channel->max_antenna_gain * 2,
+				 channel->max_power * 2,
+				 min((u32) MAX_RATE_POWER,
+				 (u32) ah->regulatory.power_limit));
 
 	if (!ath9k_hw_set_rf_regs(ah, chan, freqIndex)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
@@ -1701,11 +1695,7 @@ static bool ath9k_hw_channel_change(struct ath_hw *ah,
 	ath9k_hw_set_regs(ah, chan, macmode);
 
 	if (AR_SREV_9280_10_OR_LATER(ah)) {
-		if (!(ath9k_hw_ar9280_set_channel(ah, chan))) {
-			DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
-				"Failed to set channel\n");
-			return false;
-		}
+		ath9k_hw_ar9280_set_channel(ah, chan);
 	} else {
 		if (!(ath9k_hw_set_channel(ah, chan))) {
 			DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
@@ -1714,16 +1704,12 @@ static bool ath9k_hw_channel_change(struct ath_hw *ah,
 		}
 	}
 
-	if (ah->eep_ops->set_txpower(ah, chan,
+	ah->eep_ops->set_txpower(ah, chan,
 			     ath9k_regd_get_ctl(&ah->regulatory, chan),
 			     channel->max_antenna_gain * 2,
 			     channel->max_power * 2,
 			     min((u32) MAX_RATE_POWER,
-				 (u32) ah->regulatory.power_limit)) != 0) {
-		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
-			"Error initializing transmit power\n");
-		return false;
-	}
+			     (u32) ah->regulatory.power_limit));
 
 	synthDelay = REG_READ(ah, AR_PHY_RX_DELAY) & AR_PHY_RX_DELAY_DELAY;
 	if (IS_CHAN_B(chan))
@@ -2311,13 +2297,11 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 
 	REG_WRITE(ah, AR_RSSI_THR, INIT_RSSI_THR);
 
-	if (AR_SREV_9280_10_OR_LATER(ah)) {
-		if (!(ath9k_hw_ar9280_set_channel(ah, chan)))
-			return -EIO;
-	} else {
+	if (AR_SREV_9280_10_OR_LATER(ah))
+		ath9k_hw_ar9280_set_channel(ah, chan);
+	else
 		if (!(ath9k_hw_set_channel(ah, chan)))
 			return -EIO;
-	}
 
 	for (i = 0; i < AR_NUM_DCU; i++)
 		REG_WRITE(ah, AR_DQCUMASK(i), 1 << i);
@@ -3748,22 +3732,19 @@ bool ath9k_hw_disable(struct ath_hw *ah)
 	return ath9k_hw_set_reset_reg(ah, ATH9K_RESET_COLD);
 }
 
-bool ath9k_hw_set_txpowerlimit(struct ath_hw *ah, u32 limit)
+void ath9k_hw_set_txpowerlimit(struct ath_hw *ah, u32 limit)
 {
 	struct ath9k_channel *chan = ah->curchan;
 	struct ieee80211_channel *channel = chan->chan;
 
 	ah->regulatory.power_limit = min(limit, (u32) MAX_RATE_POWER);
 
-	if (ah->eep_ops->set_txpower(ah, chan,
-			     ath9k_regd_get_ctl(&ah->regulatory, chan),
-			     channel->max_antenna_gain * 2,
-			     channel->max_power * 2,
-			     min((u32) MAX_RATE_POWER,
-				 (u32) ah->regulatory.power_limit)) != 0)
-		return false;
-
-	return true;
+	ah->eep_ops->set_txpower(ah, chan,
+				 ath9k_regd_get_ctl(&ah->regulatory, chan),
+				 channel->max_antenna_gain * 2,
+				 channel->max_power * 2,
+				 min((u32) MAX_RATE_POWER,
+				 (u32) ah->regulatory.power_limit));
 }
 
 void ath9k_hw_setmac(struct ath_hw *ah, const u8 *mac)
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index ddb24c4..dd8508e 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -590,7 +590,7 @@ u32 ath9k_hw_getrxfilter(struct ath_hw *ah);
 void ath9k_hw_setrxfilter(struct ath_hw *ah, u32 bits);
 bool ath9k_hw_phy_disable(struct ath_hw *ah);
 bool ath9k_hw_disable(struct ath_hw *ah);
-bool ath9k_hw_set_txpowerlimit(struct ath_hw *ah, u32 limit);
+void ath9k_hw_set_txpowerlimit(struct ath_hw *ah, u32 limit);
 void ath9k_hw_setmac(struct ath_hw *ah, const u8 *mac);
 void ath9k_hw_setopmode(struct ath_hw *ah);
 void ath9k_hw_setmcastfilter(struct ath_hw *ah, u32 filter0, u32 filter1);
diff --git a/drivers/net/wireless/ath/ath9k/phy.c b/drivers/net/wireless/ath/ath9k/phy.c
index 5ec9ce9..aaa9415 100644
--- a/drivers/net/wireless/ath/ath9k/phy.c
+++ b/drivers/net/wireless/ath/ath9k/phy.c
@@ -96,9 +96,8 @@ ath9k_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
 	return true;
 }
 
-bool
-ath9k_hw_ar9280_set_channel(struct ath_hw *ah,
-			    struct ath9k_channel *chan)
+void ath9k_hw_ar9280_set_channel(struct ath_hw *ah,
+				 struct ath9k_channel *chan)
 {
 	u16 bMode, fracMode, aModeRefSel = 0;
 	u32 freq, ndiv, channelSel = 0, channelFrac = 0, reg32 = 0;
@@ -169,8 +168,6 @@ ath9k_hw_ar9280_set_channel(struct ath_hw *ah,
 
 	ah->curchan = chan;
 	ah->curchan_rad_index = -1;
-
-	return true;
 }
 
 static void
diff --git a/drivers/net/wireless/ath/ath9k/phy.h b/drivers/net/wireless/ath/ath9k/phy.h
index 296d0e9..c70f530 100644
--- a/drivers/net/wireless/ath/ath9k/phy.h
+++ b/drivers/net/wireless/ath/ath9k/phy.h
@@ -17,7 +17,7 @@
 #ifndef PHY_H
 #define PHY_H
 
-bool ath9k_hw_ar9280_set_channel(struct ath_hw *ah,
+void ath9k_hw_ar9280_set_channel(struct ath_hw *ah,
 				 struct ath9k_channel
 				 *chan);
 bool ath9k_hw_set_channel(struct ath_hw *ah,
-- 
1.6.2.4

