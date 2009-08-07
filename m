Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:32401 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132AbZHGEPA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 00:15:00 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2009 21:15:01 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19067.43601.454397.36121@gargle.gargle.HOWL>
Date: Fri, 7 Aug 2009 09:45:13 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 04/12] ath9k: Remove a few DEBUG mesages
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We have never used these at all.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/eeprom.c |  127 ++++++-------------------------
 1 files changed, 23 insertions(+), 104 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom.c b/drivers/net/wireless/ath/ath9k/eeprom.c
index 4303a4d..f35ee1e 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom.c
@@ -236,9 +236,6 @@ static void ath9k_olc_get_pdadcs(struct ath_hw *ah,
 			pPDADCValues[i] = 0xFF;
 }
 
-
-
-
 static void ath9k_hw_get_target_powers(struct ath_hw *ah,
 				       struct ath9k_channel *chan,
 				       struct cal_target_power_ht *powInfo,
@@ -905,21 +902,8 @@ static void ath9k_hw_set_4k_power_per_rate_table(struct ath_hw *ah,
 		    ah->eep_ops->get_eeprom_rev(ah) <= 2)
 			twiceMaxEdgePower = AR5416_MAX_RATE_POWER;
 
-		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
-			"LOOP-Mode ctlMode %d < %d, isHt40CtlMode %d, "
-			"EXT_ADDITIVE %d\n",
-			ctlMode, numCtlModes, isHt40CtlMode,
-			(pCtlMode[ctlMode] & EXT_ADDITIVE));
-
 		for (i = 0; (i < AR5416_EEP4K_NUM_CTLS) &&
 				pEepData->ctlIndex[i]; i++) {
-			DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
-				"  LOOP-Ctlidx %d: cfgCtl 0x%2.2x "
-				"pCtlMode 0x%2.2x ctlIndex 0x%2.2x "
-				"chan %d\n",
-				i, cfgCtl, pCtlMode[ctlMode],
-				pEepData->ctlIndex[i], chan->channel);
-
 			if ((((cfgCtl & ~CTL_MODE_M) |
 			      (pCtlMode[ctlMode] & CTL_MODE_M)) ==
 			     pEepData->ctlIndex[i]) ||
@@ -936,13 +920,6 @@ static void ath9k_hw_set_4k_power_per_rate_table(struct ath_hw *ah,
 				IS_CHAN_2GHZ(chan),
 				AR5416_EEP4K_NUM_BAND_EDGES);
 
-				DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
-					"    MATCH-EE_IDX %d: ch %d is2 %d "
-					"2xMinEdge %d chainmask %d chains %d\n",
-					i, freq, IS_CHAN_2GHZ(chan),
-					twiceMinEdgePower, tx_chainmask,
-					ar5416_get_ntxchains
-					(tx_chainmask));
 				if ((cfgCtl & ~CTL_MODE_M) == SD_NO_CTL) {
 					twiceMaxEdgePower =
 						min(twiceMaxEdgePower,
@@ -956,12 +933,6 @@ static void ath9k_hw_set_4k_power_per_rate_table(struct ath_hw *ah,
 
 		minCtlPower = (u8)min(twiceMaxEdgePower, scaledPower);
 
-		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
-			"    SEL-Min ctlMode %d pCtlMode %d "
-			"2xMaxEdge %d sP %d minCtlPwr %d\n",
-			ctlMode, pCtlMode[ctlMode], twiceMaxEdgePower,
-			scaledPower, minCtlPower);
-
 		switch (pCtlMode[ctlMode]) {
 		case CTL_11B:
 			for (i = 0; i < ARRAY_SIZE(targetPowerCck.tPow2x);
@@ -2491,20 +2462,7 @@ static void ath9k_hw_set_def_power_per_rate_table(struct ath_hw *ah,
 		    ah->eep_ops->get_eeprom_rev(ah) <= 2)
 			twiceMaxEdgePower = AR5416_MAX_RATE_POWER;
 
-		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
-			"LOOP-Mode ctlMode %d < %d, isHt40CtlMode %d, "
-			"EXT_ADDITIVE %d\n",
-			ctlMode, numCtlModes, isHt40CtlMode,
-			(pCtlMode[ctlMode] & EXT_ADDITIVE));
-
 		for (i = 0; (i < AR5416_NUM_CTLS) && pEepData->ctlIndex[i]; i++) {
-			DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
-				"  LOOP-Ctlidx %d: cfgCtl 0x%2.2x "
-				"pCtlMode 0x%2.2x ctlIndex 0x%2.2x "
-				"chan %d\n",
-				i, cfgCtl, pCtlMode[ctlMode],
-				pEepData->ctlIndex[i], chan->channel);
-
 			if ((((cfgCtl & ~CTL_MODE_M) |
 			      (pCtlMode[ctlMode] & CTL_MODE_M)) ==
 			     pEepData->ctlIndex[i]) ||
@@ -2517,13 +2475,6 @@ static void ath9k_hw_set_def_power_per_rate_table(struct ath_hw *ah,
 				rep->ctlEdges[ar5416_get_ntxchains(tx_chainmask) - 1],
 				IS_CHAN_2GHZ(chan), AR5416_NUM_BAND_EDGES);
 
-				DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
-					"    MATCH-EE_IDX %d: ch %d is2 %d "
-					"2xMinEdge %d chainmask %d chains %d\n",
-					i, freq, IS_CHAN_2GHZ(chan),
-					twiceMinEdgePower, tx_chainmask,
-					ar5416_get_ntxchains
-					(tx_chainmask));
 				if ((cfgCtl & ~CTL_MODE_M) == SD_NO_CTL) {
 					twiceMaxEdgePower = min(twiceMaxEdgePower,
 								twiceMinEdgePower);
@@ -2536,12 +2487,6 @@ static void ath9k_hw_set_def_power_per_rate_table(struct ath_hw *ah,
 
 		minCtlPower = min(twiceMaxEdgePower, scaledPower);
 
-		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
-			"    SEL-Min ctlMode %d pCtlMode %d "
-			"2xMaxEdge %d sP %d minCtlPwr %d\n",
-			ctlMode, pCtlMode[ctlMode], twiceMaxEdgePower,
-			scaledPower, minCtlPower);
-
 		switch (pCtlMode[ctlMode]) {
 		case CTL_11B:
 			for (i = 0; i < ARRAY_SIZE(targetPowerCck.tPow2x); i++) {
@@ -2898,17 +2843,15 @@ static int ath9k_hw_AR9287_check_eeprom(struct ath_hw *ah)
 
 	if (!ath9k_hw_use_flash(ah)) {
 		if (!ath9k_hw_nvram_read
-				(ah, AR5416_EEPROM_MAGIC_OFFSET, &magic)) {
+		    (ah, AR5416_EEPROM_MAGIC_OFFSET, &magic)) {
 			DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
-					"Reading Magic # failed\n");
+				"Reading Magic # failed\n");
 			return false;
 		}
 
 		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
 				"Read Magic = 0x%04X\n", magic);
 		if (magic != AR5416_EEPROM_MAGIC) {
-
-
 			magic2 = swab16(magic);
 
 			if (magic2 == AR5416_EEPROM_MAGIC) {
@@ -2924,13 +2867,14 @@ static int ath9k_hw_AR9287_check_eeprom(struct ath_hw *ah)
 				}
 			} else {
 				DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
-						"Invalid EEPROM Magic. "
-						"endianness mismatch.\n");
-				return -EINVAL;            }
+					"Invalid EEPROM Magic. "
+					"endianness mismatch.\n");
+				return -EINVAL;
+			}
 		}
 	}
 	DPRINTF(ah->ah_sc, ATH_DBG_EEPROM, "need_swap = %s.\n", need_swap ?
-					   "True" : "False");
+		"True" : "False");
 
 	if (need_swap)
 		el = swab16(ah->eeprom.map9287.baseEepHeader.length);
@@ -3360,19 +3304,19 @@ static void ath9k_hw_set_AR9287_power_cal_table(struct ath_hw *ah,
 
 			if (i == 0) {
 				if (!ath9k_hw_AR9287_get_eeprom(
-							ah, EEP_OL_PWRCTRL)) {
+					    ah, EEP_OL_PWRCTRL)) {
 					REG_WRITE(ah, AR_PHY_TPCRG5 +
-					    regChainOffset,
-					    SM(pdGainOverlap_t2,
-					    AR_PHY_TPCRG5_PD_GAIN_OVERLAP) |
-					    SM(gainBoundaries[0],
+					  regChainOffset,
+					  SM(pdGainOverlap_t2,
+					     AR_PHY_TPCRG5_PD_GAIN_OVERLAP) |
+					  SM(gainBoundaries[0],
 					     AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_1)
-					     | SM(gainBoundaries[1],
-					     AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_2)
-					     | SM(gainBoundaries[2],
-					     AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_3)
-					     | SM(gainBoundaries[3],
-					     AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_4));
+					  | SM(gainBoundaries[1],
+					       AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_2)
+					  | SM(gainBoundaries[2],
+					       AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_3)
+					  | SM(gainBoundaries[3],
+					       AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_4));
 				}
 			}
 
@@ -3394,6 +3338,7 @@ static void ath9k_hw_set_AR9287_power_cal_table(struct ath_hw *ah,
 					  pdadcValues[
 					  AR9287_NUM_PDADC_VALUES-diff];
 			}
+
 			if (!ath9k_hw_AR9287_get_eeprom(ah, EEP_OL_PWRCTRL)) {
 				regOffset = AR_PHY_BASE + (672 << 2) +
 							   regChainOffset;
@@ -3412,6 +3357,7 @@ static void ath9k_hw_set_AR9287_power_cal_table(struct ath_hw *ah,
 						"PDADC (%d,%4x): %4.4x %8.8x\n",
 						i, regChainOffset, regOffset,
 						reg32);
+
 					DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
 						"PDADC: Chain %d | "
 						"PDADC %3d Value %3d | "
@@ -3542,20 +3488,7 @@ static void ath9k_hw_set_AR9287_power_per_rate_table(struct ath_hw *ah,
 		    ah->eep_ops->get_eeprom_rev(ah) <= 2)
 			twiceMaxEdgePower = AR5416_MAX_RATE_POWER;
 
-		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
-			"LOOP-Mode ctlMode %d < %d, isHt40CtlMode %d,"
-			 "EXT_ADDITIVE %d\n", ctlMode, numCtlModes,
-			 isHt40CtlMode, (pCtlMode[ctlMode] & EXT_ADDITIVE));
-
-		for (i = 0; (i < AR9287_NUM_CTLS)
-			     && pEepData->ctlIndex[i]; i++) {
-			DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
-				"LOOP-Ctlidx %d: cfgCtl 0x%2.2x"
-				 "pCtlMode 0x%2.2x ctlIndex 0x%2.2x"
-				 "chan %d chanctl=xxxx\n",
-				 i, cfgCtl, pCtlMode[ctlMode],
-				 pEepData->ctlIndex[i],	chan->channel);
-
+		for (i = 0; (i < AR9287_NUM_CTLS) && pEepData->ctlIndex[i]; i++) {
 			if ((((cfgCtl & ~CTL_MODE_M) |
 			      (pCtlMode[ctlMode] & CTL_MODE_M)) ==
 			     pEepData->ctlIndex[i]) ||
@@ -3571,13 +3504,6 @@ static void ath9k_hw_set_AR9287_power_per_rate_table(struct ath_hw *ah,
 				    tx_chainmask) - 1],
 				    IS_CHAN_2GHZ(chan), AR5416_NUM_BAND_EDGES);
 
-				DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
-					"MATCH-EE_IDX %d: ch %d is2 %d"
-					"2xMinEdge %d chainmask %d chains %d\n",
-					 i, freq, IS_CHAN_2GHZ(chan),
-					 twiceMinEdgePower, tx_chainmask,
-					 ar5416_get_ntxchains(tx_chainmask));
-
 				if ((cfgCtl & ~CTL_MODE_M) == SD_NO_CTL)
 					twiceMaxEdgePower = min(
 							    twiceMaxEdgePower,
@@ -3591,14 +3517,7 @@ static void ath9k_hw_set_AR9287_power_per_rate_table(struct ath_hw *ah,
 
 		minCtlPower = (u8)min(twiceMaxEdgePower, scaledPower);
 
-		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
-				"SEL-Min ctlMode %d pCtlMode %d 2xMaxEdge %d"
-				 "sP %d minCtlPwr %d\n",
-				 ctlMode, pCtlMode[ctlMode], twiceMaxEdgePower,
-				 scaledPower, minCtlPower);
-
 		switch (pCtlMode[ctlMode]) {
-
 		case CTL_11B:
 			for (i = 0;
 			     i < ARRAY_SIZE(targetPowerCck.tPow2x);
@@ -3670,7 +3589,7 @@ static void ath9k_hw_set_AR9287_power_per_rate_table(struct ath_hw *ah,
 		ratesArray[rateHt20_0 + i] = targetPowerHt20.tPow2x[i];
 
 	if (IS_CHAN_2GHZ(chan))	{
-		ratesArray[rate1l]  = targetPowerCck.tPow2x[0];
+		ratesArray[rate1l] = targetPowerCck.tPow2x[0];
 		ratesArray[rate2s] = ratesArray[rate2l] =
 			targetPowerCck.tPow2x[1];
 		ratesArray[rate5_5s] = ratesArray[rate5_5l] =
@@ -3686,7 +3605,7 @@ static void ath9k_hw_set_AR9287_power_per_rate_table(struct ath_hw *ah,
 		ratesArray[rateDupCck]  = targetPowerHt40.tPow2x[0];
 		ratesArray[rateExtOfdm] = targetPowerOfdmExt.tPow2x[0];
 		if (IS_CHAN_2GHZ(chan))
-			ratesArray[rateExtCck]  = targetPowerCckExt.tPow2x[0];
+			ratesArray[rateExtCck] = targetPowerCckExt.tPow2x[0];
 	}
 
 #undef REDUCE_SCALED_POWER_BY_TWO_CHAIN
-- 
1.6.4

