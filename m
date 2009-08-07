Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:32410 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138AbZHGEPR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 00:15:17 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2009 21:15:18 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19067.43621.271588.246020@gargle.gargle.HOWL>
Date: Fri, 7 Aug 2009 09:45:33 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 10/12] ath9k: Remove local chainmask variable
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The chainmask can be obtained directly from ath_hw.
Also, use a helper macro for comparing CTLs - this improves readability.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/eeprom_4k.c |   86 ++++++++++++++--------------
 1 files changed, 42 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index 29878e0..d34dd23 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -502,14 +502,23 @@ static void ath9k_hw_set_4k_power_per_rate_table(struct ath_hw *ah,
 						 u16 twiceMaxRegulatoryPower,
 						 u16 powerLimit)
 {
-	struct ar5416_eeprom_4k *pEepData = &ah->eeprom.map4k;
-	u16 twiceMaxEdgePower = AR5416_MAX_RATE_POWER;
-	static const u16 tpScaleReductionTable[5] =
-		{ 0, 3, 6, 9, AR5416_MAX_RATE_POWER };
+#define CMP_TEST_GRP \
+	(((cfgCtl & ~CTL_MODE_M)| (pCtlMode[ctlMode] & CTL_MODE_M)) ==	\
+	 pEepData->ctlIndex[i])						\
+	|| (((cfgCtl & ~CTL_MODE_M) | (pCtlMode[ctlMode] & CTL_MODE_M)) == \
+	    ((pEepData->ctlIndex[i] & CTL_MODE_M) | SD_NO_CTL))
 
 	int i;
 	int16_t twiceLargestAntenna;
+	u16 twiceMinEdgePower;
+	u16 twiceMaxEdgePower = AR5416_MAX_RATE_POWER;
+	u16 scaledPower = 0, minCtlPower, maxRegAllowedPower;
+	u16 numCtlModes, *pCtlMode, ctlMode, freq;
+	struct chan_centers centers;
 	struct cal_ctl_data_4k *rep;
+	struct ar5416_eeprom_4k *pEepData = &ah->eeprom.map4k;
+	static const u16 tpScaleReductionTable[5] =
+		{ 0, 3, 6, 9, AR5416_MAX_RATE_POWER };
 	struct cal_target_power_leg targetPowerOfdm, targetPowerCck = {
 		0, { 0, 0, 0, 0}
 	};
@@ -520,27 +529,18 @@ static void ath9k_hw_set_4k_power_per_rate_table(struct ath_hw *ah,
 	struct cal_target_power_ht targetPowerHt20, targetPowerHt40 = {
 		0, {0, 0, 0, 0}
 	};
-	u16 scaledPower = 0, minCtlPower, maxRegAllowedPower;
 	u16 ctlModesFor11g[] =
 		{ CTL_11B, CTL_11G, CTL_2GHT20, CTL_11B_EXT, CTL_11G_EXT,
 		  CTL_2GHT40
 		};
-	u16 numCtlModes, *pCtlMode, ctlMode, freq;
-	struct chan_centers centers;
-	int tx_chainmask;
-	u16 twiceMinEdgePower;
-
-	tx_chainmask = ah->txchainmask;
 
 	ath9k_hw_get_channel_centers(ah, chan, &centers);
 
 	twiceLargestAntenna = pEepData->modalHeader.antennaGainCh[0];
-
 	twiceLargestAntenna = (int16_t)min(AntennaReduction -
 					   twiceLargestAntenna, 0);
 
 	maxRegAllowedPower = twiceMaxRegulatoryPower + twiceLargestAntenna;
-
 	if (ah->regulatory.tp_scale != ATH9K_TP_SCALE_MAX) {
 		maxRegAllowedPower -=
 			(tpScaleReductionTable[(ah->regulatory.tp_scale)] * 2);
@@ -584,6 +584,7 @@ static void ath9k_hw_set_4k_power_per_rate_table(struct ath_hw *ah,
 	for (ctlMode = 0; ctlMode < numCtlModes; ctlMode++) {
 		bool isHt40CtlMode = (pCtlMode[ctlMode] == CTL_5GHT40) ||
 			(pCtlMode[ctlMode] == CTL_2GHT40);
+
 		if (isHt40CtlMode)
 			freq = centers.synth_center;
 		else if (pCtlMode[ctlMode] & EXT_ADDITIVE)
@@ -596,22 +597,17 @@ static void ath9k_hw_set_4k_power_per_rate_table(struct ath_hw *ah,
 			twiceMaxEdgePower = AR5416_MAX_RATE_POWER;
 
 		for (i = 0; (i < AR5416_EEP4K_NUM_CTLS) &&
-				pEepData->ctlIndex[i]; i++) {
-			if ((((cfgCtl & ~CTL_MODE_M) |
-			      (pCtlMode[ctlMode] & CTL_MODE_M)) ==
-			     pEepData->ctlIndex[i]) ||
-			    (((cfgCtl & ~CTL_MODE_M) |
-			      (pCtlMode[ctlMode] & CTL_MODE_M)) ==
-			     ((pEepData->ctlIndex[i] & CTL_MODE_M) |
-			      SD_NO_CTL))) {
+			     pEepData->ctlIndex[i]; i++) {
+
+			if (CMP_TEST_GRP) {
 				rep = &(pEepData->ctlData[i]);
 
-				twiceMinEdgePower =
-					ath9k_hw_get_max_edge_power(freq,
-				rep->ctlEdges[ar5416_get_ntxchains
-						(tx_chainmask) - 1],
-				IS_CHAN_2GHZ(chan),
-				AR5416_EEP4K_NUM_BAND_EDGES);
+				twiceMinEdgePower = ath9k_hw_get_max_edge_power(
+					freq,
+					rep->ctlEdges[
+					ar5416_get_ntxchains(ah->txchainmask) - 1],
+					IS_CHAN_2GHZ(chan),
+					AR5416_EEP4K_NUM_BAND_EDGES);
 
 				if ((cfgCtl & ~CTL_MODE_M) == SD_NO_CTL) {
 					twiceMaxEdgePower =
@@ -628,42 +624,38 @@ static void ath9k_hw_set_4k_power_per_rate_table(struct ath_hw *ah,
 
 		switch (pCtlMode[ctlMode]) {
 		case CTL_11B:
-			for (i = 0; i < ARRAY_SIZE(targetPowerCck.tPow2x);
-					i++) {
+			for (i = 0; i < ARRAY_SIZE(targetPowerCck.tPow2x); i++) {
 				targetPowerCck.tPow2x[i] =
 					min((u16)targetPowerCck.tPow2x[i],
 					    minCtlPower);
 			}
 			break;
 		case CTL_11G:
-			for (i = 0; i < ARRAY_SIZE(targetPowerOfdm.tPow2x);
-					i++) {
+			for (i = 0; i < ARRAY_SIZE(targetPowerOfdm.tPow2x); i++) {
 				targetPowerOfdm.tPow2x[i] =
 					min((u16)targetPowerOfdm.tPow2x[i],
 					    minCtlPower);
 			}
 			break;
 		case CTL_2GHT20:
-			for (i = 0; i < ARRAY_SIZE(targetPowerHt20.tPow2x);
-					i++) {
+			for (i = 0; i < ARRAY_SIZE(targetPowerHt20.tPow2x); i++) {
 				targetPowerHt20.tPow2x[i] =
 					min((u16)targetPowerHt20.tPow2x[i],
 					    minCtlPower);
 			}
 			break;
 		case CTL_11B_EXT:
-			targetPowerCckExt.tPow2x[0] = min((u16)
-					targetPowerCckExt.tPow2x[0],
-					minCtlPower);
+			targetPowerCckExt.tPow2x[0] =
+				min((u16)targetPowerCckExt.tPow2x[0],
+				    minCtlPower);
 			break;
 		case CTL_11G_EXT:
-			targetPowerOfdmExt.tPow2x[0] = min((u16)
-					targetPowerOfdmExt.tPow2x[0],
-					minCtlPower);
+			targetPowerOfdmExt.tPow2x[0] =
+				min((u16)targetPowerOfdmExt.tPow2x[0],
+				    minCtlPower);
 			break;
 		case CTL_2GHT40:
-			for (i = 0; i < ARRAY_SIZE(targetPowerHt40.tPow2x);
-					i++) {
+			for (i = 0; i < ARRAY_SIZE(targetPowerHt40.tPow2x); i++) {
 				targetPowerHt40.tPow2x[i] =
 					min((u16)targetPowerHt40.tPow2x[i],
 					    minCtlPower);
@@ -674,9 +666,13 @@ static void ath9k_hw_set_4k_power_per_rate_table(struct ath_hw *ah,
 		}
 	}
 
-	ratesArray[rate6mb] = ratesArray[rate9mb] = ratesArray[rate12mb] =
-		ratesArray[rate18mb] = ratesArray[rate24mb] =
-		targetPowerOfdm.tPow2x[0];
+	ratesArray[rate6mb] =
+	ratesArray[rate9mb] =
+	ratesArray[rate12mb] =
+	ratesArray[rate18mb] =
+	ratesArray[rate24mb] =
+	targetPowerOfdm.tPow2x[0];
+
 	ratesArray[rate36mb] = targetPowerOfdm.tPow2x[1];
 	ratesArray[rate48mb] = targetPowerOfdm.tPow2x[2];
 	ratesArray[rate54mb] = targetPowerOfdm.tPow2x[3];
@@ -700,6 +696,8 @@ static void ath9k_hw_set_4k_power_per_rate_table(struct ath_hw *ah,
 		ratesArray[rateExtOfdm] = targetPowerOfdmExt.tPow2x[0];
 		ratesArray[rateExtCck] = targetPowerCckExt.tPow2x[0];
 	}
+
+#undef CMP_TEST_GRP
 }
 
 static void ath9k_hw_4k_set_txpower(struct ath_hw *ah,
-- 
1.6.4

