Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:35848 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693Ab0HAGZR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Aug 2010 02:25:17 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] ath9k_hw: Fix regulatory CTL index usage for AR9003
Date: Sun,  1 Aug 2010 02:25:16 -0400
Message-Id: <1280643916-26018-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AR9003 was not relying on the CTL indexes from the EEPROM for capping the
max output power. The CTL indexes from the EEPROM provide calibrated
limits for output power for each tested and supported frequency. Without
this the device operates at a power level which only conforms to the
transmit spectrum mask as specified by IEEE Annex I.2.3.

The regulatory limit by CRDA is always used but does not provide
calibrated values for optimal performance, specially on band edges.
Using the calibrated data from the EEPROM ensures the device
operates at optimal output power while still ensuring proper
regulatory compliance. The device uses the minimum of these tree
values, the value from CRDA, the calibrated value from CTL indexex,
and the value to conform to the IEEE transmit spectrum mask.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |  388 +++++++++++++++++++++++-
 1 files changed, 381 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index ace8d26..b883b17 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -41,6 +41,20 @@
 #define LE16(x) __constant_cpu_to_le16(x)
 #define LE32(x) __constant_cpu_to_le32(x)
 
+/* Local defines to distinguish between extension and control CTL's */
+#define EXT_ADDITIVE (0x8000)
+#define CTL_11A_EXT (CTL_11A | EXT_ADDITIVE)
+#define CTL_11G_EXT (CTL_11G | EXT_ADDITIVE)
+#define CTL_11B_EXT (CTL_11B | EXT_ADDITIVE)
+#define REDUCE_SCALED_POWER_BY_TWO_CHAIN     6  /* 10*log10(2)*2 */
+#define REDUCE_SCALED_POWER_BY_THREE_CHAIN   9  /* 10*log10(3)*2 */
+#define PWRINCR_3_TO_1_CHAIN      9             /* 10*log(3)*2 */
+#define PWRINCR_3_TO_2_CHAIN      3             /* floor(10*log(3/2)*2) */
+#define PWRINCR_2_TO_1_CHAIN      6             /* 10*log(2)*2 */
+
+#define SUB_NUM_CTL_MODES_AT_5G_40 2    /* excluding HT40, EXT-OFDM */
+#define SUB_NUM_CTL_MODES_AT_2G_40 3    /* excluding HT40, EXT-OFDM, EXT-CCK */
+
 static const struct ar9300_eeprom ar9300_default = {
 	.eepromVersion = 2,
 	.templateVersion = 2,
@@ -609,6 +623,14 @@ static const struct ar9300_eeprom ar9300_default = {
 	 }
 };
 
+static u16 ath9k_hw_fbin2freq(u8 fbin, bool is2GHz)
+{
+	if (fbin == AR9300_BCHAN_UNUSED)
+		return fbin;
+
+	return (u16) ((is2GHz) ? (2300 + fbin) : (4800 + 5 * fbin));
+}
+
 static int ath9k_hw_ar9300_check_eeprom(struct ath_hw *ah)
 {
 	return 0;
@@ -1417,9 +1439,9 @@ static int ar9003_hw_tx_power_regwrite(struct ath_hw *ah, u8 * pPwrArray)
 #undef POW_SM
 }
 
-static void ar9003_hw_set_target_power_eeprom(struct ath_hw *ah, u16 freq)
+static void ar9003_hw_set_target_power_eeprom(struct ath_hw *ah, u16 freq,
+					      u8 *targetPowerValT2)
 {
-	u8 targetPowerValT2[ar9300RateSize];
 	/* XXX: hard code for now, need to get from eeprom struct */
 	u8 ht40PowerIncForPdadc = 0;
 	bool is2GHz = false;
@@ -1553,9 +1575,6 @@ static void ar9003_hw_set_target_power_eeprom(struct ath_hw *ah, u16 freq)
 			  "TPC[%02d] 0x%08x\n", i, targetPowerValT2[i]);
 		i++;
 	}
-
-	/* Write target power array to registers */
-	ar9003_hw_tx_power_regwrite(ah, targetPowerValT2);
 }
 
 static int ar9003_hw_cal_pier_get(struct ath_hw *ah,
@@ -1799,14 +1818,369 @@ static int ar9003_hw_calibration_apply(struct ath_hw *ah, int frequency)
 	return 0;
 }
 
+static u16 ar9003_hw_get_direct_edge_power(struct ar9300_eeprom *eep,
+					   int idx,
+					   int edge,
+					   bool is2GHz)
+{
+	struct cal_ctl_data_2g *ctl_2g = eep->ctlPowerData_2G;
+	struct cal_ctl_data_5g *ctl_5g = eep->ctlPowerData_5G;
+
+	if (is2GHz)
+		return ctl_2g[idx].ctlEdges[edge].tPower;
+	else
+		return ctl_5g[idx].ctlEdges[edge].tPower;
+}
+
+static u16 ar9003_hw_get_indirect_edge_power(struct ar9300_eeprom *eep,
+					     int idx,
+					     unsigned int edge,
+					     u16 freq,
+					     bool is2GHz)
+{
+	struct cal_ctl_data_2g *ctl_2g = eep->ctlPowerData_2G;
+	struct cal_ctl_data_5g *ctl_5g = eep->ctlPowerData_5G;
+
+	u8 *ctl_freqbin = is2GHz ?
+		&eep->ctl_freqbin_2G[idx][0] :
+		&eep->ctl_freqbin_5G[idx][0];
+
+	if (is2GHz) {
+		if (ath9k_hw_fbin2freq(ctl_freqbin[edge - 1], 1) < freq &&
+		    ctl_2g[idx].ctlEdges[edge - 1].flag)
+			return ctl_2g[idx].ctlEdges[edge - 1].tPower;
+	} else {
+		if (ath9k_hw_fbin2freq(ctl_freqbin[edge - 1], 0) < freq &&
+		    ctl_5g[idx].ctlEdges[edge - 1].flag)
+			return ctl_5g[idx].ctlEdges[edge - 1].tPower;
+	}
+
+	return AR9300_MAX_RATE_POWER;
+}
+
+/*
+ * Find the maximum conformance test limit for the given channel and CTL info
+ */
+static u16 ar9003_hw_get_max_edge_power(struct ar9300_eeprom *eep,
+					u16 freq, int idx, bool is2GHz)
+{
+	u16 twiceMaxEdgePower = AR9300_MAX_RATE_POWER;
+	u8 *ctl_freqbin = is2GHz ?
+		&eep->ctl_freqbin_2G[idx][0] :
+		&eep->ctl_freqbin_5G[idx][0];
+	u16 num_edges = is2GHz ?
+		AR9300_NUM_BAND_EDGES_2G : AR9300_NUM_BAND_EDGES_5G;
+	unsigned int edge;
+
+	/* Get the edge power */
+	for (edge = 0;
+	     (edge < num_edges) && (ctl_freqbin[edge] != AR9300_BCHAN_UNUSED);
+	     edge++) {
+		/*
+		 * If there's an exact channel match or an inband flag set
+		 * on the lower channel use the given rdEdgePower
+		 */
+		if (freq == ath9k_hw_fbin2freq(ctl_freqbin[edge], is2GHz)) {
+			twiceMaxEdgePower =
+				ar9003_hw_get_direct_edge_power(eep, idx,
+								edge, is2GHz);
+			break;
+		} else if ((edge > 0) &&
+			   (freq < ath9k_hw_fbin2freq(ctl_freqbin[edge],
+						      is2GHz))) {
+			twiceMaxEdgePower =
+				ar9003_hw_get_indirect_edge_power(eep, idx,
+								  edge, freq,
+								  is2GHz);
+			/*
+			 * Leave loop - no more affecting edges possible in
+			 * this monotonic increasing list
+			 */
+			break;
+		}
+	}
+	return twiceMaxEdgePower;
+}
+
+static void ar9003_hw_set_power_per_rate_table(struct ath_hw *ah,
+					       struct ath9k_channel *chan,
+					       u8 *pPwrArray, u16 cfgCtl,
+					       u8 twiceAntennaReduction,
+					       u8 twiceMaxRegulatoryPower,
+					       u16 powerLimit)
+{
+	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
+	struct ath_common *common = ath9k_hw_common(ah);
+	struct ar9300_eeprom *pEepData = &ah->eeprom.ar9300_eep;
+	u16 twiceMaxEdgePower = AR9300_MAX_RATE_POWER;
+	static const u16 tpScaleReductionTable[5] = {
+		0, 3, 6, 9, AR9300_MAX_RATE_POWER
+	};
+	int i;
+	int16_t  twiceLargestAntenna;
+	u16 scaledPower = 0, minCtlPower, maxRegAllowedPower;
+	u16 ctlModesFor11a[] = {
+		CTL_11A, CTL_5GHT20, CTL_11A_EXT, CTL_5GHT40
+	};
+	u16 ctlModesFor11g[] = {
+		CTL_11B, CTL_11G, CTL_2GHT20, CTL_11B_EXT,
+		CTL_11G_EXT, CTL_2GHT40
+	};
+	u16 numCtlModes, *pCtlMode, ctlMode, freq;
+	struct chan_centers centers;
+	u8 *ctlIndex;
+	u8 ctlNum;
+	u16 twiceMinEdgePower;
+	bool is2ghz = IS_CHAN_2GHZ(chan);
+
+	ath9k_hw_get_channel_centers(ah, chan, &centers);
+
+	/* Compute TxPower reduction due to Antenna Gain */
+	if (is2ghz)
+		twiceLargestAntenna = pEepData->modalHeader2G.antennaGain;
+	else
+		twiceLargestAntenna = pEepData->modalHeader5G.antennaGain;
+
+	twiceLargestAntenna = (int16_t)min((twiceAntennaReduction) -
+				twiceLargestAntenna, 0);
+
+	/*
+	 * scaledPower is the minimum of the user input power level
+	 * and the regulatory allowed power level
+	 */
+	maxRegAllowedPower = twiceMaxRegulatoryPower + twiceLargestAntenna;
+
+	if (regulatory->tp_scale != ATH9K_TP_SCALE_MAX) {
+		maxRegAllowedPower -=
+			(tpScaleReductionTable[(regulatory->tp_scale)] * 2);
+	}
+
+	scaledPower = min(powerLimit, maxRegAllowedPower);
+
+	/*
+	 * Reduce scaled Power by number of chains active to get
+	 * to per chain tx power level
+	 */
+	switch (ar5416_get_ntxchains(ah->txchainmask)) {
+	case 1:
+		break;
+	case 2:
+		scaledPower -= REDUCE_SCALED_POWER_BY_TWO_CHAIN;
+		break;
+	case 3:
+		scaledPower -= REDUCE_SCALED_POWER_BY_THREE_CHAIN;
+		break;
+	}
+
+	scaledPower = max((u16)0, scaledPower);
+
+	/*
+	 * Get target powers from EEPROM - our baseline for TX Power
+	 */
+	if (is2ghz) {
+		/* Setup for CTL modes */
+		/* CTL_11B, CTL_11G, CTL_2GHT20 */
+		numCtlModes =
+			ARRAY_SIZE(ctlModesFor11g) -
+				   SUB_NUM_CTL_MODES_AT_2G_40;
+		pCtlMode = ctlModesFor11g;
+		if (IS_CHAN_HT40(chan))
+			/* All 2G CTL's */
+			numCtlModes = ARRAY_SIZE(ctlModesFor11g);
+	} else {
+		/* Setup for CTL modes */
+		/* CTL_11A, CTL_5GHT20 */
+		numCtlModes = ARRAY_SIZE(ctlModesFor11a) -
+					 SUB_NUM_CTL_MODES_AT_5G_40;
+		pCtlMode = ctlModesFor11a;
+		if (IS_CHAN_HT40(chan))
+			/* All 5G CTL's */
+			numCtlModes = ARRAY_SIZE(ctlModesFor11a);
+	}
+
+	/*
+	 * For MIMO, need to apply regulatory caps individually across
+	 * dynamically running modes: CCK, OFDM, HT20, HT40
+	 *
+	 * The outer loop walks through each possible applicable runtime mode.
+	 * The inner loop walks through each ctlIndex entry in EEPROM.
+	 * The ctl value is encoded as [7:4] == test group, [3:0] == test mode.
+	 */
+	for (ctlMode = 0; ctlMode < numCtlModes; ctlMode++) {
+		bool isHt40CtlMode = (pCtlMode[ctlMode] == CTL_5GHT40) ||
+			(pCtlMode[ctlMode] == CTL_2GHT40);
+		if (isHt40CtlMode)
+			freq = centers.synth_center;
+		else if (pCtlMode[ctlMode] & EXT_ADDITIVE)
+			freq = centers.ext_center;
+		else
+			freq = centers.ctl_center;
+
+		ath_print(common, ATH_DBG_REGULATORY,
+			  "LOOP-Mode ctlMode %d < %d, isHt40CtlMode %d, "
+			  "EXT_ADDITIVE %d\n",
+			  ctlMode, numCtlModes, isHt40CtlMode,
+			  (pCtlMode[ctlMode] & EXT_ADDITIVE));
+
+		/* walk through each CTL index stored in EEPROM */
+		if (is2ghz) {
+			ctlIndex = pEepData->ctlIndex_2G;
+			ctlNum = AR9300_NUM_CTLS_2G;
+		} else {
+			ctlIndex = pEepData->ctlIndex_5G;
+			ctlNum = AR9300_NUM_CTLS_5G;
+		}
+
+		for (i = 0; (i < ctlNum) && ctlIndex[i]; i++) {
+			ath_print(common, ATH_DBG_REGULATORY,
+				  "LOOP-Ctlidx %d: cfgCtl 0x%2.2x "
+				  "pCtlMode 0x%2.2x ctlIndex 0x%2.2x "
+				  "chan %dn",
+				  i, cfgCtl, pCtlMode[ctlMode], ctlIndex[i],
+				  chan->channel);
+
+				/*
+				 * compare test group from regulatory
+				 * channel list with test mode from pCtlMode
+				 * list
+				 */
+				if ((((cfgCtl & ~CTL_MODE_M) |
+				       (pCtlMode[ctlMode] & CTL_MODE_M)) ==
+					ctlIndex[i]) ||
+				    (((cfgCtl & ~CTL_MODE_M) |
+				       (pCtlMode[ctlMode] & CTL_MODE_M)) ==
+				     ((ctlIndex[i] & CTL_MODE_M) |
+				       SD_NO_CTL))) {
+					twiceMinEdgePower =
+					  ar9003_hw_get_max_edge_power(pEepData,
+								       freq, i,
+								       is2ghz);
+
+					if ((cfgCtl & ~CTL_MODE_M) == SD_NO_CTL)
+						/*
+						 * Find the minimum of all CTL
+						 * edge powers that apply to
+						 * this channel
+						 */
+						twiceMaxEdgePower =
+							min(twiceMaxEdgePower,
+							    twiceMinEdgePower);
+						else {
+							/* specific */
+							twiceMaxEdgePower =
+							  twiceMinEdgePower;
+							break;
+						}
+				}
+			}
+
+			minCtlPower = (u8)min(twiceMaxEdgePower, scaledPower);
+
+			ath_print(common, ATH_DBG_REGULATORY,
+				  "SEL-Min ctlMode %d pCtlMode %d 2xMaxEdge %d "
+				  "sP %d minCtlPwr %d\n",
+				  ctlMode, pCtlMode[ctlMode], twiceMaxEdgePower,
+				  scaledPower, minCtlPower);
+
+			/* Apply ctl mode to correct target power set */
+			switch (pCtlMode[ctlMode]) {
+			case CTL_11B:
+				for (i = ALL_TARGET_LEGACY_1L_5L;
+				     i <= ALL_TARGET_LEGACY_11S; i++)
+					pPwrArray[i] =
+					  (u8)min((u16)pPwrArray[i],
+						  minCtlPower);
+				break;
+			case CTL_11A:
+			case CTL_11G:
+				for (i = ALL_TARGET_LEGACY_6_24;
+				     i <= ALL_TARGET_LEGACY_54; i++)
+					pPwrArray[i] =
+					  (u8)min((u16)pPwrArray[i],
+						  minCtlPower);
+				break;
+			case CTL_5GHT20:
+			case CTL_2GHT20:
+				for (i = ALL_TARGET_HT20_0_8_16;
+				     i <= ALL_TARGET_HT20_21; i++)
+					pPwrArray[i] =
+					  (u8)min((u16)pPwrArray[i],
+						  minCtlPower);
+				pPwrArray[ALL_TARGET_HT20_22] =
+				  (u8)min((u16)pPwrArray[ALL_TARGET_HT20_22],
+					  minCtlPower);
+				pPwrArray[ALL_TARGET_HT20_23] =
+				  (u8)min((u16)pPwrArray[ALL_TARGET_HT20_23],
+					   minCtlPower);
+				break;
+			case CTL_5GHT40:
+			case CTL_2GHT40:
+				for (i = ALL_TARGET_HT40_0_8_16;
+				     i <= ALL_TARGET_HT40_23; i++)
+					pPwrArray[i] =
+					  (u8)min((u16)pPwrArray[i],
+						  minCtlPower);
+				break;
+			default:
+			    break;
+			}
+	} /* end ctl mode checking */
+}
+
 static void ath9k_hw_ar9300_set_txpower(struct ath_hw *ah,
 					struct ath9k_channel *chan, u16 cfgCtl,
 					u8 twiceAntennaReduction,
 					u8 twiceMaxRegulatoryPower,
 					u8 powerLimit)
 {
-	ah->txpower_limit = powerLimit;
-	ar9003_hw_set_target_power_eeprom(ah, chan->channel);
+	struct ath_common *common = ath9k_hw_common(ah);
+	u8 targetPowerValT2[ar9300RateSize];
+	unsigned int i = 0;
+
+	ar9003_hw_set_target_power_eeprom(ah, chan->channel, targetPowerValT2);
+	ar9003_hw_set_power_per_rate_table(ah, chan,
+					   targetPowerValT2, cfgCtl,
+					   twiceAntennaReduction,
+					   twiceMaxRegulatoryPower,
+					   powerLimit);
+
+	while (i < ar9300RateSize) {
+		ath_print(common, ATH_DBG_EEPROM,
+			  "TPC[%02d] 0x%08x ", i, targetPowerValT2[i]);
+		i++;
+		ath_print(common, ATH_DBG_EEPROM,
+			  "TPC[%02d] 0x%08x ", i, targetPowerValT2[i]);
+		i++;
+		ath_print(common, ATH_DBG_EEPROM,
+			  "TPC[%02d] 0x%08x ", i, targetPowerValT2[i]);
+		i++;
+		ath_print(common, ATH_DBG_EEPROM,
+			  "TPC[%02d] 0x%08x\n\n", i, targetPowerValT2[i]);
+		i++;
+	}
+
+	/* Write target power array to registers */
+	ar9003_hw_tx_power_regwrite(ah, targetPowerValT2);
+
+	/*
+	 * This is the TX power we send back to driver core,
+	 * and it can use to pass to userspace to display our
+	 * currently configured TX power setting.
+	 *
+	 * Since power is rate dependent, use one of the indices
+	 * from the AR9300_Rates enum to select an entry from
+	 * targetPowerValT2[] to report. Currently returns the
+	 * power for HT40 MCS 0, HT20 MCS 0, or OFDM 6 Mbps
+	 * as CCK power is less interesting (?).
+	 */
+	i = ALL_TARGET_LEGACY_6_24; /* legacy */
+	if (IS_CHAN_HT40(chan))
+		i = ALL_TARGET_HT40_0_8_16; /* ht40 */
+	else if (IS_CHAN_HT20(chan))
+		i = ALL_TARGET_HT20_0_8_16; /* ht20 */
+
+	ah->txpower_limit = targetPowerValT2[i];
+
 	ar9003_hw_calibration_apply(ah, chan->channel);
 }
 
-- 
1.7.0.4

