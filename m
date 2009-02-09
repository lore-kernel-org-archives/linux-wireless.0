Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:53769 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbZBIIFJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2009 03:05:09 -0500
Received: from mail.atheros.com ([10.10.21.49])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 09 Feb 2009 00:05:08 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18831.57830.858049.204068@gargle.gargle.HOWL> (sfid-20090209_090520_510480_32A7DEDB)
Date: Mon, 9 Feb 2009 13:27:26 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 10/10] ath9k: Remove all the useless ah_ variable prefixes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/ani.c    |  186 ++++++------
 drivers/net/wireless/ath9k/ani.h    |    6 +-
 drivers/net/wireless/ath9k/ath9k.h  |    6 +-
 drivers/net/wireless/ath9k/beacon.c |   26 +-
 drivers/net/wireless/ath9k/calib.c  |  122 ++++----
 drivers/net/wireless/ath9k/calib.h  |   14 +-
 drivers/net/wireless/ath9k/eeprom.c |  102 +++---
 drivers/net/wireless/ath9k/eeprom.h |    2 +-
 drivers/net/wireless/ath9k/hw.c     |  602 +++++++++++++++++-----------------
 drivers/net/wireless/ath9k/hw.h     |  216 ++++++-------
 drivers/net/wireless/ath9k/mac.c    |   94 +++---
 drivers/net/wireless/ath9k/main.c   |   92 +++---
 drivers/net/wireless/ath9k/pci.c    |    4 +-
 drivers/net/wireless/ath9k/phy.c    |  176 +++++-----
 drivers/net/wireless/ath9k/phy.h    |    2 +-
 drivers/net/wireless/ath9k/rc.c     |   12 +-
 drivers/net/wireless/ath9k/recv.c   |   18 +-
 drivers/net/wireless/ath9k/xmit.c   |    6 +-
 18 files changed, 841 insertions(+), 845 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ani.c b/drivers/net/wireless/ath9k/ani.c
index 6bd2d57..d4df7e6 100644
--- a/drivers/net/wireless/ath9k/ani.c
+++ b/drivers/net/wireless/ath9k/ani.c
@@ -21,12 +21,12 @@ static int ath9k_hw_get_ani_channel_idx(struct ath_hw *ah,
 {
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(ah->ah_ani); i++) {
-		if (ah->ah_ani[i].c &&
-		    ah->ah_ani[i].c->channel == chan->channel)
+	for (i = 0; i < ARRAY_SIZE(ah->ani); i++) {
+		if (ah->ani[i].c &&
+		    ah->ani[i].c->channel == chan->channel)
 			return i;
-		if (ah->ah_ani[i].c == NULL) {
-			ah->ah_ani[i].c = chan;
+		if (ah->ani[i].c == NULL) {
+			ah->ani[i].c = chan;
 			return i;
 		}
 	}
@@ -40,37 +40,37 @@ static int ath9k_hw_get_ani_channel_idx(struct ath_hw *ah,
 static bool ath9k_hw_ani_control(struct ath_hw *ah,
 				 enum ath9k_ani_cmd cmd, int param)
 {
-	struct ar5416AniState *aniState = ah->ah_curani;
+	struct ar5416AniState *aniState = ah->curani;
 
-	switch (cmd & ah->ah_ani_function) {
+	switch (cmd & ah->ani_function) {
 	case ATH9K_ANI_NOISE_IMMUNITY_LEVEL:{
 		u32 level = param;
 
-		if (level >= ARRAY_SIZE(ah->ah_totalSizeDesired)) {
+		if (level >= ARRAY_SIZE(ah->totalSizeDesired)) {
 			DPRINTF(ah->ah_sc, ATH_DBG_ANI,
 				"level out of range (%u > %u)\n",
 				level,
-				(unsigned)ARRAY_SIZE(ah->ah_totalSizeDesired));
+				(unsigned)ARRAY_SIZE(ah->totalSizeDesired));
 			return false;
 		}
 
 		REG_RMW_FIELD(ah, AR_PHY_DESIRED_SZ,
 			      AR_PHY_DESIRED_SZ_TOT_DES,
-			      ah->ah_totalSizeDesired[level]);
+			      ah->totalSizeDesired[level]);
 		REG_RMW_FIELD(ah, AR_PHY_AGC_CTL1,
 			      AR_PHY_AGC_CTL1_COARSE_LOW,
-			      ah->ah_coarseLow[level]);
+			      ah->coarse_low[level]);
 		REG_RMW_FIELD(ah, AR_PHY_AGC_CTL1,
 			      AR_PHY_AGC_CTL1_COARSE_HIGH,
-			      ah->ah_coarseHigh[level]);
+			      ah->coarse_high[level]);
 		REG_RMW_FIELD(ah, AR_PHY_FIND_SIG,
 			      AR_PHY_FIND_SIG_FIRPWR,
-			      ah->ah_firpwr[level]);
+			      ah->firpwr[level]);
 
 		if (level > aniState->noiseImmunityLevel)
-			ah->ah_stats.ast_ani_niup++;
+			ah->stats.ast_ani_niup++;
 		else if (level < aniState->noiseImmunityLevel)
-			ah->ah_stats.ast_ani_nidown++;
+			ah->stats.ast_ani_nidown++;
 		aniState->noiseImmunityLevel = level;
 		break;
 	}
@@ -124,9 +124,9 @@ static bool ath9k_hw_ani_control(struct ath_hw *ah,
 
 		if (!on != aniState->ofdmWeakSigDetectOff) {
 			if (on)
-				ah->ah_stats.ast_ani_ofdmon++;
+				ah->stats.ast_ani_ofdmon++;
 			else
-				ah->ah_stats.ast_ani_ofdmoff++;
+				ah->stats.ast_ani_ofdmoff++;
 			aniState->ofdmWeakSigDetectOff = !on;
 		}
 		break;
@@ -140,9 +140,9 @@ static bool ath9k_hw_ani_control(struct ath_hw *ah,
 			      weakSigThrCck[high]);
 		if (high != aniState->cckWeakSigThreshold) {
 			if (high)
-				ah->ah_stats.ast_ani_cckhigh++;
+				ah->stats.ast_ani_cckhigh++;
 			else
-				ah->ah_stats.ast_ani_ccklow++;
+				ah->stats.ast_ani_ccklow++;
 			aniState->cckWeakSigThreshold = high;
 		}
 		break;
@@ -162,9 +162,9 @@ static bool ath9k_hw_ani_control(struct ath_hw *ah,
 			      AR_PHY_FIND_SIG_FIRSTEP,
 			      firstep[level]);
 		if (level > aniState->firstepLevel)
-			ah->ah_stats.ast_ani_stepup++;
+			ah->stats.ast_ani_stepup++;
 		else if (level < aniState->firstepLevel)
-			ah->ah_stats.ast_ani_stepdown++;
+			ah->stats.ast_ani_stepdown++;
 		aniState->firstepLevel = level;
 		break;
 	}
@@ -185,9 +185,9 @@ static bool ath9k_hw_ani_control(struct ath_hw *ah,
 			      AR_PHY_TIMING5_CYCPWR_THR1,
 			      cycpwrThr1[level]);
 		if (level > aniState->spurImmunityLevel)
-			ah->ah_stats.ast_ani_spurup++;
+			ah->stats.ast_ani_spurup++;
 		else if (level < aniState->spurImmunityLevel)
-			ah->ah_stats.ast_ani_spurdown++;
+			ah->stats.ast_ani_spurdown++;
 		aniState->spurImmunityLevel = level;
 		break;
 	}
@@ -235,10 +235,10 @@ static void ath9k_ani_restart(struct ath_hw *ah)
 	if (!DO_ANI(ah))
 		return;
 
-	aniState = ah->ah_curani;
+	aniState = ah->curani;
 
 	aniState->listenTime = 0;
-	if (ah->ah_hasHwPhyCounters) {
+	if (ah->has_hw_phycounters) {
 		if (aniState->ofdmTrigHigh > AR_PHY_COUNTMAX) {
 			aniState->ofdmPhyErrBase = 0;
 			DPRINTF(ah->ah_sc, ATH_DBG_ANI,
@@ -279,7 +279,7 @@ static void ath9k_hw_ani_ofdm_err_trigger(struct ath_hw *ah)
 	if (!DO_ANI(ah))
 		return;
 
-	aniState = ah->ah_curani;
+	aniState = ah->curani;
 
 	if (aniState->noiseImmunityLevel < HAL_NOISE_IMMUNE_MAX) {
 		if (ath9k_hw_ani_control(ah, ATH9K_ANI_NOISE_IMMUNITY_LEVEL,
@@ -295,7 +295,7 @@ static void ath9k_hw_ani_ofdm_err_trigger(struct ath_hw *ah)
 		}
 	}
 
-	if (ah->ah_opmode == NL80211_IFTYPE_AP) {
+	if (ah->opmode == NL80211_IFTYPE_AP) {
 		if (aniState->firstepLevel < HAL_FIRST_STEP_MAX) {
 			ath9k_hw_ani_control(ah, ATH9K_ANI_FIRSTEP_LEVEL,
 					     aniState->firstepLevel + 1);
@@ -350,14 +350,14 @@ static void ath9k_hw_ani_cck_err_trigger(struct ath_hw *ah)
 	if (!DO_ANI(ah))
 		return;
 
-	aniState = ah->ah_curani;
+	aniState = ah->curani;
 	if (aniState->noiseImmunityLevel < HAL_NOISE_IMMUNE_MAX) {
 		if (ath9k_hw_ani_control(ah, ATH9K_ANI_NOISE_IMMUNITY_LEVEL,
 					 aniState->noiseImmunityLevel + 1)) {
 			return;
 		}
 	}
-	if (ah->ah_opmode == NL80211_IFTYPE_AP) {
+	if (ah->opmode == NL80211_IFTYPE_AP) {
 		if (aniState->firstepLevel < HAL_FIRST_STEP_MAX) {
 			ath9k_hw_ani_control(ah, ATH9K_ANI_FIRSTEP_LEVEL,
 					     aniState->firstepLevel + 1);
@@ -383,9 +383,9 @@ static void ath9k_hw_ani_lower_immunity(struct ath_hw *ah)
 	struct ar5416AniState *aniState;
 	int32_t rssi;
 
-	aniState = ah->ah_curani;
+	aniState = ah->curani;
 
-	if (ah->ah_opmode == NL80211_IFTYPE_AP) {
+	if (ah->opmode == NL80211_IFTYPE_AP) {
 		if (aniState->firstepLevel > 0) {
 			if (ath9k_hw_ani_control(ah, ATH9K_ANI_FIRSTEP_LEVEL,
 						 aniState->firstepLevel - 1))
@@ -441,11 +441,11 @@ static int32_t ath9k_hw_ani_get_listen_time(struct ath_hw *ah)
 	rxFrameCount = REG_READ(ah, AR_RFCNT);
 	cycleCount = REG_READ(ah, AR_CCCNT);
 
-	aniState = ah->ah_curani;
+	aniState = ah->curani;
 	if (aniState->cycleCount == 0 || aniState->cycleCount > cycleCount) {
 
 		listenTime = 0;
-		ah->ah_stats.ast_ani_lzero++;
+		ah->stats.ast_ani_lzero++;
 	} else {
 		int32_t ccdelta = cycleCount - aniState->cycleCount;
 		int32_t rfdelta = rxFrameCount - aniState->rxFrameCount;
@@ -462,21 +462,21 @@ static int32_t ath9k_hw_ani_get_listen_time(struct ath_hw *ah)
 void ath9k_ani_reset(struct ath_hw *ah)
 {
 	struct ar5416AniState *aniState;
-	struct ath9k_channel *chan = ah->ah_curchan;
+	struct ath9k_channel *chan = ah->curchan;
 	int index;
 
 	if (!DO_ANI(ah))
 		return;
 
 	index = ath9k_hw_get_ani_channel_idx(ah, chan);
-	aniState = &ah->ah_ani[index];
-	ah->ah_curani = aniState;
+	aniState = &ah->ani[index];
+	ah->curani = aniState;
 
-	if (DO_ANI(ah) && ah->ah_opmode != NL80211_IFTYPE_STATION
-	    && ah->ah_opmode != NL80211_IFTYPE_ADHOC) {
+	if (DO_ANI(ah) && ah->opmode != NL80211_IFTYPE_STATION
+	    && ah->opmode != NL80211_IFTYPE_ADHOC) {
 		DPRINTF(ah->ah_sc, ATH_DBG_ANI,
-			"Reset ANI state opmode %u\n", ah->ah_opmode);
-		ah->ah_stats.ast_ani_reset++;
+			"Reset ANI state opmode %u\n", ah->opmode);
+		ah->stats.ast_ani_reset++;
 
 		ath9k_hw_ani_control(ah, ATH9K_ANI_NOISE_IMMUNITY_LEVEL, 0);
 		ath9k_hw_ani_control(ah, ATH9K_ANI_SPUR_IMMUNITY_LEVEL, 0);
@@ -489,15 +489,15 @@ void ath9k_ani_reset(struct ath_hw *ah)
 		ath9k_hw_setrxfilter(ah, ath9k_hw_getrxfilter(ah) |
 				     ATH9K_RX_FILTER_PHYERR);
 
-		if (ah->ah_opmode == NL80211_IFTYPE_AP) {
-			ah->ah_curani->ofdmTrigHigh =
-				ah->ah_config.ofdm_trig_high;
-			ah->ah_curani->ofdmTrigLow =
-				ah->ah_config.ofdm_trig_low;
-			ah->ah_curani->cckTrigHigh =
-				ah->ah_config.cck_trig_high;
-			ah->ah_curani->cckTrigLow =
-				ah->ah_config.cck_trig_low;
+		if (ah->opmode == NL80211_IFTYPE_AP) {
+			ah->curani->ofdmTrigHigh =
+				ah->config.ofdm_trig_high;
+			ah->curani->ofdmTrigLow =
+				ah->config.ofdm_trig_low;
+			ah->curani->cckTrigHigh =
+				ah->config.cck_trig_high;
+			ah->curani->cckTrigLow =
+				ah->config.cck_trig_low;
 		}
 		ath9k_ani_restart(ah);
 		return;
@@ -518,7 +518,7 @@ void ath9k_ani_reset(struct ath_hw *ah)
 	if (aniState->firstepLevel != 0)
 		ath9k_hw_ani_control(ah, ATH9K_ANI_FIRSTEP_LEVEL,
 				     aniState->firstepLevel);
-	if (ah->ah_hasHwPhyCounters) {
+	if (ah->has_hw_phycounters) {
 		ath9k_hw_setrxfilter(ah, ath9k_hw_getrxfilter(ah) &
 				     ~ATH9K_RX_FILTER_PHYERR);
 		ath9k_ani_restart(ah);
@@ -542,19 +542,19 @@ void ath9k_hw_ani_monitor(struct ath_hw *ah,
 	if (!DO_ANI(ah))
 		return;
 
-	aniState = ah->ah_curani;
-	ah->ah_stats.ast_nodestats = *stats;
+	aniState = ah->curani;
+	ah->stats.ast_nodestats = *stats;
 
 	listenTime = ath9k_hw_ani_get_listen_time(ah);
 	if (listenTime < 0) {
-		ah->ah_stats.ast_ani_lneg++;
+		ah->stats.ast_ani_lneg++;
 		ath9k_ani_restart(ah);
 		return;
 	}
 
 	aniState->listenTime += listenTime;
 
-	if (ah->ah_hasHwPhyCounters) {
+	if (ah->has_hw_phycounters) {
 		u32 phyCnt1, phyCnt2;
 		u32 ofdmPhyErrCnt, cckPhyErrCnt;
 
@@ -591,24 +591,24 @@ void ath9k_hw_ani_monitor(struct ath_hw *ah,
 		}
 
 		ofdmPhyErrCnt = phyCnt1 - aniState->ofdmPhyErrBase;
-		ah->ah_stats.ast_ani_ofdmerrs +=
+		ah->stats.ast_ani_ofdmerrs +=
 			ofdmPhyErrCnt - aniState->ofdmPhyErrCount;
 		aniState->ofdmPhyErrCount = ofdmPhyErrCnt;
 
 		cckPhyErrCnt = phyCnt2 - aniState->cckPhyErrBase;
-		ah->ah_stats.ast_ani_cckerrs +=
+		ah->stats.ast_ani_cckerrs +=
 			cckPhyErrCnt - aniState->cckPhyErrCount;
 		aniState->cckPhyErrCount = cckPhyErrCnt;
 	}
 
-	if (aniState->listenTime > 5 * ah->ah_aniPeriod) {
+	if (aniState->listenTime > 5 * ah->aniperiod) {
 		if (aniState->ofdmPhyErrCount <= aniState->listenTime *
 		    aniState->ofdmTrigLow / 1000 &&
 		    aniState->cckPhyErrCount <= aniState->listenTime *
 		    aniState->cckTrigLow / 1000)
 			ath9k_hw_ani_lower_immunity(ah);
 		ath9k_ani_restart(ah);
-	} else if (aniState->listenTime > ah->ah_aniPeriod) {
+	} else if (aniState->listenTime > ah->aniperiod) {
 		if (aniState->ofdmPhyErrCount > aniState->listenTime *
 		    aniState->ofdmTrigHigh / 1000) {
 			ath9k_hw_ani_ofdm_err_trigger(ah);
@@ -624,7 +624,7 @@ void ath9k_hw_ani_monitor(struct ath_hw *ah,
 
 bool ath9k_hw_phycounters(struct ath_hw *ah)
 {
-	return ah->ah_hasHwPhyCounters ? true : false;
+	return ah->has_hw_phycounters ? true : false;
 }
 
 void ath9k_enable_mib_counters(struct ath_hw *ah)
@@ -712,7 +712,7 @@ void ath9k_hw_procmibevent(struct ath_hw *ah,
 
 	/* Clear the mib counters and save them in the stats */
 	ath9k_hw_update_mibstats(ah, &ah->ah_mibStats);
-	ah->ah_stats.ast_nodestats = *stats;
+	ah->stats.ast_nodestats = *stats;
 
 	if (!DO_ANI(ah))
 		return;
@@ -722,17 +722,17 @@ void ath9k_hw_procmibevent(struct ath_hw *ah,
 	phyCnt2 = REG_READ(ah, AR_PHY_ERR_2);
 	if (((phyCnt1 & AR_MIBCNT_INTRMASK) == AR_MIBCNT_INTRMASK) ||
 	    ((phyCnt2 & AR_MIBCNT_INTRMASK) == AR_MIBCNT_INTRMASK)) {
-		struct ar5416AniState *aniState = ah->ah_curani;
+		struct ar5416AniState *aniState = ah->curani;
 		u32 ofdmPhyErrCnt, cckPhyErrCnt;
 
 		/* NB: only use ast_ani_*errs with AH_PRIVATE_DIAG */
 		ofdmPhyErrCnt = phyCnt1 - aniState->ofdmPhyErrBase;
-		ah->ah_stats.ast_ani_ofdmerrs +=
+		ah->stats.ast_ani_ofdmerrs +=
 			ofdmPhyErrCnt - aniState->ofdmPhyErrCount;
 		aniState->ofdmPhyErrCount = ofdmPhyErrCnt;
 
 		cckPhyErrCnt = phyCnt2 - aniState->cckPhyErrBase;
-		ah->ah_stats.ast_ani_cckerrs +=
+		ah->stats.ast_ani_cckerrs +=
 			cckPhyErrCnt - aniState->cckPhyErrCount;
 		aniState->cckPhyErrCount = cckPhyErrCnt;
 
@@ -761,10 +761,10 @@ void ath9k_hw_ani_setup(struct ath_hw *ah)
 	const int firpwr[] = { -78, -78, -78, -78, -80 };
 
 	for (i = 0; i < 5; i++) {
-		ah->ah_totalSizeDesired[i] = totalSizeDesired[i];
-		ah->ah_coarseHigh[i] = coarseHigh[i];
-		ah->ah_coarseLow[i] = coarseLow[i];
-		ah->ah_firpwr[i] = firpwr[i];
+		ah->totalSizeDesired[i] = totalSizeDesired[i];
+		ah->coarse_high[i] = coarseHigh[i];
+		ah->coarse_low[i] = coarseLow[i];
+		ah->firpwr[i] = firpwr[i];
 	}
 }
 
@@ -774,50 +774,50 @@ void ath9k_hw_ani_attach(struct ath_hw *ah)
 
 	DPRINTF(ah->ah_sc, ATH_DBG_ANI, "Attach ANI\n");
 
-	ah->ah_hasHwPhyCounters = 1;
-
-	memset(ah->ah_ani, 0, sizeof(ah->ah_ani));
-	for (i = 0; i < ARRAY_SIZE(ah->ah_ani); i++) {
-		ah->ah_ani[i].ofdmTrigHigh = ATH9K_ANI_OFDM_TRIG_HIGH;
-		ah->ah_ani[i].ofdmTrigLow = ATH9K_ANI_OFDM_TRIG_LOW;
-		ah->ah_ani[i].cckTrigHigh = ATH9K_ANI_CCK_TRIG_HIGH;
-		ah->ah_ani[i].cckTrigLow = ATH9K_ANI_CCK_TRIG_LOW;
-		ah->ah_ani[i].rssiThrHigh = ATH9K_ANI_RSSI_THR_HIGH;
-		ah->ah_ani[i].rssiThrLow = ATH9K_ANI_RSSI_THR_LOW;
-		ah->ah_ani[i].ofdmWeakSigDetectOff =
+	ah->has_hw_phycounters = 1;
+
+	memset(ah->ani, 0, sizeof(ah->ani));
+	for (i = 0; i < ARRAY_SIZE(ah->ani); i++) {
+		ah->ani[i].ofdmTrigHigh = ATH9K_ANI_OFDM_TRIG_HIGH;
+		ah->ani[i].ofdmTrigLow = ATH9K_ANI_OFDM_TRIG_LOW;
+		ah->ani[i].cckTrigHigh = ATH9K_ANI_CCK_TRIG_HIGH;
+		ah->ani[i].cckTrigLow = ATH9K_ANI_CCK_TRIG_LOW;
+		ah->ani[i].rssiThrHigh = ATH9K_ANI_RSSI_THR_HIGH;
+		ah->ani[i].rssiThrLow = ATH9K_ANI_RSSI_THR_LOW;
+		ah->ani[i].ofdmWeakSigDetectOff =
 			!ATH9K_ANI_USE_OFDM_WEAK_SIG;
-		ah->ah_ani[i].cckWeakSigThreshold =
+		ah->ani[i].cckWeakSigThreshold =
 			ATH9K_ANI_CCK_WEAK_SIG_THR;
-		ah->ah_ani[i].spurImmunityLevel = ATH9K_ANI_SPUR_IMMUNE_LVL;
-		ah->ah_ani[i].firstepLevel = ATH9K_ANI_FIRSTEP_LVL;
-		if (ah->ah_hasHwPhyCounters) {
-			ah->ah_ani[i].ofdmPhyErrBase =
+		ah->ani[i].spurImmunityLevel = ATH9K_ANI_SPUR_IMMUNE_LVL;
+		ah->ani[i].firstepLevel = ATH9K_ANI_FIRSTEP_LVL;
+		if (ah->has_hw_phycounters) {
+			ah->ani[i].ofdmPhyErrBase =
 				AR_PHY_COUNTMAX - ATH9K_ANI_OFDM_TRIG_HIGH;
-			ah->ah_ani[i].cckPhyErrBase =
+			ah->ani[i].cckPhyErrBase =
 				AR_PHY_COUNTMAX - ATH9K_ANI_CCK_TRIG_HIGH;
 		}
 	}
-	if (ah->ah_hasHwPhyCounters) {
+	if (ah->has_hw_phycounters) {
 		DPRINTF(ah->ah_sc, ATH_DBG_ANI,
 			"Setting OfdmErrBase = 0x%08x\n",
-			ah->ah_ani[0].ofdmPhyErrBase);
+			ah->ani[0].ofdmPhyErrBase);
 		DPRINTF(ah->ah_sc, ATH_DBG_ANI, "Setting cckErrBase = 0x%08x\n",
-			ah->ah_ani[0].cckPhyErrBase);
+			ah->ani[0].cckPhyErrBase);
 
-		REG_WRITE(ah, AR_PHY_ERR_1, ah->ah_ani[0].ofdmPhyErrBase);
-		REG_WRITE(ah, AR_PHY_ERR_2, ah->ah_ani[0].cckPhyErrBase);
+		REG_WRITE(ah, AR_PHY_ERR_1, ah->ani[0].ofdmPhyErrBase);
+		REG_WRITE(ah, AR_PHY_ERR_2, ah->ani[0].cckPhyErrBase);
 		ath9k_enable_mib_counters(ah);
 	}
-	ah->ah_aniPeriod = ATH9K_ANI_PERIOD;
-	if (ah->ah_config.enable_ani)
-		ah->ah_procPhyErr |= HAL_PROCESS_ANI;
+	ah->aniperiod = ATH9K_ANI_PERIOD;
+	if (ah->config.enable_ani)
+		ah->proc_phyerr |= HAL_PROCESS_ANI;
 }
 
 void ath9k_hw_ani_detach(struct ath_hw *ah)
 {
 	DPRINTF(ah->ah_sc, ATH_DBG_ANI, "Detach ANI\n");
 
-	if (ah->ah_hasHwPhyCounters) {
+	if (ah->has_hw_phycounters) {
 		ath9k_hw_disable_mib_counters(ah);
 		REG_WRITE(ah, AR_PHY_ERR_1, 0);
 		REG_WRITE(ah, AR_PHY_ERR_2, 0);
diff --git a/drivers/net/wireless/ath9k/ani.h b/drivers/net/wireless/ath9k/ani.h
index 7e9ca95..7315761 100644
--- a/drivers/net/wireless/ath9k/ani.h
+++ b/drivers/net/wireless/ath9k/ani.h
@@ -20,12 +20,12 @@
 #define HAL_PROCESS_ANI           0x00000001
 #define ATH9K_RSSI_EP_MULTIPLIER  (1<<7)
 
-#define DO_ANI(ah) (((ah)->ah_procPhyErr & HAL_PROCESS_ANI))
+#define DO_ANI(ah) (((ah)->proc_phyerr & HAL_PROCESS_ANI))
 
 #define HAL_EP_RND(x, mul)						\
 	((((x)%(mul)) >= ((mul)/2)) ? ((x) + ((mul) - 1)) / (mul) : (x)/(mul))
 #define BEACON_RSSI(ahp)					\
-	HAL_EP_RND(ahp->ah_stats.ast_nodestats.ns_avgbrssi,	\
+	HAL_EP_RND(ahp->stats.ast_nodestats.ns_avgbrssi,	\
 		   ATH9K_RSSI_EP_MULTIPLIER)
 
 #define ATH9K_ANI_OFDM_TRIG_HIGH          500
@@ -118,7 +118,7 @@ struct ar5416Stats {
 	struct ath9k_mib_stats ast_mibstats;
 	struct ath9k_node_stats ast_nodestats;
 };
-#define ah_mibStats ah_stats.ast_mibstats
+#define ah_mibStats stats.ast_mibstats
 
 void ath9k_ani_reset(struct ath_hw *ah);
 void ath9k_hw_ani_monitor(struct ath_hw *ah,
diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index 91140b7..0b0f82c 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -670,8 +670,8 @@ static inline void ath_ahb_exit(void) {};
 static inline void ath9k_ps_wakeup(struct ath_softc *sc)
 {
 	if (atomic_inc_return(&sc->ps_usecount) == 1)
-		if (sc->sc_ah->ah_power_mode !=  ATH9K_PM_AWAKE) {
-			sc->sc_ah->ah_restore_mode = sc->sc_ah->ah_power_mode;
+		if (sc->sc_ah->power_mode !=  ATH9K_PM_AWAKE) {
+			sc->sc_ah->restore_mode = sc->sc_ah->power_mode;
 			ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_AWAKE);
 		}
 }
@@ -681,6 +681,6 @@ static inline void ath9k_ps_restore(struct ath_softc *sc)
 	if (atomic_dec_and_test(&sc->ps_usecount))
 		if (sc->hw->conf.flags & IEEE80211_CONF_PS)
 			ath9k_hw_setpower(sc->sc_ah,
-					  sc->sc_ah->ah_restore_mode);
+					  sc->sc_ah->restore_mode);
 }
 #endif /* ATH9K_H */
diff --git a/drivers/net/wireless/ath9k/beacon.c b/drivers/net/wireless/ath9k/beacon.c
index 19ec4e8..2e2ef35 100644
--- a/drivers/net/wireless/ath9k/beacon.c
+++ b/drivers/net/wireless/ath9k/beacon.c
@@ -27,7 +27,7 @@ static int ath_beaconq_config(struct ath_softc *sc)
 	struct ath9k_tx_queue_info qi;
 
 	ath9k_hw_get_txq_props(ah, sc->beacon.beaconq, &qi);
-	if (sc->sc_ah->ah_opmode == NL80211_IFTYPE_AP) {
+	if (sc->sc_ah->opmode == NL80211_IFTYPE_AP) {
 		/* Always burst out beacon and CAB traffic. */
 		qi.tqi_aifs = 1;
 		qi.tqi_cwmin = 0;
@@ -82,8 +82,8 @@ static void ath_beacon_setup(struct ath_softc *sc,
 
 	flags = ATH9K_TXDESC_NOACK;
 
-	if (sc->sc_ah->ah_opmode == NL80211_IFTYPE_ADHOC &&
-	    (ah->ah_caps.hw_caps & ATH9K_HW_CAP_VEOL)) {
+	if (sc->sc_ah->opmode == NL80211_IFTYPE_ADHOC &&
+	    (ah->caps.hw_caps & ATH9K_HW_CAP_VEOL)) {
 		ds->ds_link = bf->bf_daddr; /* self-linked */
 		flags |= ATH9K_TXDESC_VEOL;
 		/* Let hardware handle antenna switching. */
@@ -310,8 +310,8 @@ int ath_beacon_alloc(struct ath_softc *sc, int if_id)
 						 struct ath_buf, list);
 		list_del(&avp->av_bcbuf->list);
 
-		if (sc->sc_ah->ah_opmode == NL80211_IFTYPE_AP ||
-		    !(sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_VEOL)) {
+		if (sc->sc_ah->opmode == NL80211_IFTYPE_AP ||
+		    !(sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_VEOL)) {
 			int slot;
 			/*
 			 * Assign the vif to a beacon xmit slot. As
@@ -631,7 +631,7 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 		avp = (void *)vif->drv_priv;
 		opmode = avp->av_opmode;
 	} else {
-		opmode = sc->sc_ah->ah_opmode;
+		opmode = sc->sc_ah->opmode;
 	}
 
 	memset(&conf, 0, sizeof(struct ath_beacon_config));
@@ -647,7 +647,7 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 	nexttbtt = TSF_TO_TU(sc->beacon.bc_tstamp >> 32, sc->beacon.bc_tstamp);
 
 	/* XXX conditionalize multi-bss support? */
-	if (sc->sc_ah->ah_opmode == NL80211_IFTYPE_AP) {
+	if (sc->sc_ah->opmode == NL80211_IFTYPE_AP) {
 		/*
 		 * For multi-bss ap support beacons are either staggered
 		 * evenly over N slots or burst together.  For the former
@@ -670,7 +670,7 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 		nexttbtt, intval, conf.beacon_interval);
 
 	/* Check for NL80211_IFTYPE_AP and sc_nostabeacons for WDS client */
-	if (sc->sc_ah->ah_opmode == NL80211_IFTYPE_STATION) {
+	if (sc->sc_ah->opmode == NL80211_IFTYPE_STATION) {
 		struct ath9k_beacon_state bs;
 		u64 tsf;
 		u32 tsftu;
@@ -789,7 +789,7 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 		ath9k_hw_set_interrupts(ah, 0);
 		if (nexttbtt == intval)
 			intval |= ATH9K_BEACON_RESET_TSF;
-		if (sc->sc_ah->ah_opmode == NL80211_IFTYPE_ADHOC) {
+		if (sc->sc_ah->opmode == NL80211_IFTYPE_ADHOC) {
 			/*
 			 * Pull nexttbtt forward to reflect the current
 			 * TSF
@@ -818,10 +818,10 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 			 * deal with things.
 			 */
 			intval |= ATH9K_BEACON_ENA;
-			if (!(ah->ah_caps.hw_caps & ATH9K_HW_CAP_VEOL))
+			if (!(ah->caps.hw_caps & ATH9K_HW_CAP_VEOL))
 				sc->imask |= ATH9K_INT_SWBA;
 			ath_beaconq_config(sc);
-		} else if (sc->sc_ah->ah_opmode == NL80211_IFTYPE_AP) {
+		} else if (sc->sc_ah->opmode == NL80211_IFTYPE_AP) {
 			/*
 			 * In AP mode we enable the beacon timers and
 			 * SWBA interrupts to prepare beacon frames.
@@ -837,8 +837,8 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 		 * When using a self-linked beacon descriptor in
 		 * ibss mode load it once here.
 		 */
-		if (sc->sc_ah->ah_opmode == NL80211_IFTYPE_ADHOC &&
-		    (ah->ah_caps.hw_caps & ATH9K_HW_CAP_VEOL))
+		if (sc->sc_ah->opmode == NL80211_IFTYPE_ADHOC &&
+		    (ah->caps.hw_caps & ATH9K_HW_CAP_VEOL))
 			ath_beacon_start_adhoc(sc, 0);
 	}
 }
diff --git a/drivers/net/wireless/ath9k/calib.c b/drivers/net/wireless/ath9k/calib.c
index 7e70a81..1fc3a08 100644
--- a/drivers/net/wireless/ath9k/calib.c
+++ b/drivers/net/wireless/ath9k/calib.c
@@ -229,13 +229,13 @@ static void ath9k_hw_reset_calibration(struct ath_hw *ah,
 	currCal->calState = CAL_RUNNING;
 
 	for (i = 0; i < AR5416_MAX_CHAINS; i++) {
-		ah->ah_Meas0.sign[i] = 0;
-		ah->ah_Meas1.sign[i] = 0;
-		ah->ah_Meas2.sign[i] = 0;
-		ah->ah_Meas3.sign[i] = 0;
+		ah->meas0.sign[i] = 0;
+		ah->meas1.sign[i] = 0;
+		ah->meas2.sign[i] = 0;
+		ah->meas3.sign[i] = 0;
 	}
 
-	ah->ah_CalSamples = 0;
+	ah->cal_samples = 0;
 }
 
 static void ath9k_hw_per_calibration(struct ath_hw *ah,
@@ -251,9 +251,9 @@ static void ath9k_hw_per_calibration(struct ath_hw *ah,
 		      AR_PHY_TIMING_CTRL4_DO_CAL)) {
 
 			currCal->calData->calCollect(ah);
-			ah->ah_CalSamples++;
+			ah->cal_samples++;
 
-			if (ah->ah_CalSamples >= currCal->calData->calNumSamples) {
+			if (ah->cal_samples >= currCal->calData->calNumSamples) {
 				int i, numChains = 0;
 				for (i = 0; i < AR5416_MAX_CHAINS; i++) {
 					if (rxchainmask & (1 << i))
@@ -279,7 +279,7 @@ static bool ath9k_hw_iscal_supported(struct ath_hw *ah,
 {
 	struct ieee80211_conf *conf = &ah->ah_sc->hw->conf;
 
-	switch (calType & ah->ah_suppCals) {
+	switch (calType & ah->supp_cals) {
 	case IQ_MISMATCH_CAL: /* Both 2 GHz and 5 GHz support OFDM */
 		return true;
 	case ADC_GAIN_CAL:
@@ -297,17 +297,17 @@ static void ath9k_hw_iqcal_collect(struct ath_hw *ah)
 	int i;
 
 	for (i = 0; i < AR5416_MAX_CHAINS; i++) {
-		ah->ah_totalPowerMeasI[i] +=
+		ah->totalPowerMeasI[i] +=
 			REG_READ(ah, AR_PHY_CAL_MEAS_0(i));
-		ah->ah_totalPowerMeasQ[i] +=
+		ah->totalPowerMeasQ[i] +=
 			REG_READ(ah, AR_PHY_CAL_MEAS_1(i));
-		ah->ah_totalIqCorrMeas[i] +=
+		ah->totalIqCorrMeas[i] +=
 			(int32_t) REG_READ(ah, AR_PHY_CAL_MEAS_2(i));
 		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 			"%d: Chn %d pmi=0x%08x;pmq=0x%08x;iqcm=0x%08x;\n",
-			ah->ah_CalSamples, i, ah->ah_totalPowerMeasI[i],
-			ah->ah_totalPowerMeasQ[i],
-			ah->ah_totalIqCorrMeas[i]);
+			ah->cal_samples, i, ah->totalPowerMeasI[i],
+			ah->totalPowerMeasQ[i],
+			ah->totalIqCorrMeas[i]);
 	}
 }
 
@@ -316,23 +316,23 @@ static void ath9k_hw_adc_gaincal_collect(struct ath_hw *ah)
 	int i;
 
 	for (i = 0; i < AR5416_MAX_CHAINS; i++) {
-		ah->ah_totalAdcIOddPhase[i] +=
+		ah->totalAdcIOddPhase[i] +=
 			REG_READ(ah, AR_PHY_CAL_MEAS_0(i));
-		ah->ah_totalAdcIEvenPhase[i] +=
+		ah->totalAdcIEvenPhase[i] +=
 			REG_READ(ah, AR_PHY_CAL_MEAS_1(i));
-		ah->ah_totalAdcQOddPhase[i] +=
+		ah->totalAdcQOddPhase[i] +=
 			REG_READ(ah, AR_PHY_CAL_MEAS_2(i));
-		ah->ah_totalAdcQEvenPhase[i] +=
+		ah->totalAdcQEvenPhase[i] +=
 			REG_READ(ah, AR_PHY_CAL_MEAS_3(i));
 
 		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 			"%d: Chn %d oddi=0x%08x; eveni=0x%08x; "
 			"oddq=0x%08x; evenq=0x%08x;\n",
-			ah->ah_CalSamples, i,
-			ah->ah_totalAdcIOddPhase[i],
-			ah->ah_totalAdcIEvenPhase[i],
-			ah->ah_totalAdcQOddPhase[i],
-			ah->ah_totalAdcQEvenPhase[i]);
+			ah->cal_samples, i,
+			ah->totalAdcIOddPhase[i],
+			ah->totalAdcIEvenPhase[i],
+			ah->totalAdcQOddPhase[i],
+			ah->totalAdcQEvenPhase[i]);
 	}
 }
 
@@ -341,23 +341,23 @@ static void ath9k_hw_adc_dccal_collect(struct ath_hw *ah)
 	int i;
 
 	for (i = 0; i < AR5416_MAX_CHAINS; i++) {
-		ah->ah_totalAdcDcOffsetIOddPhase[i] +=
+		ah->totalAdcDcOffsetIOddPhase[i] +=
 			(int32_t) REG_READ(ah, AR_PHY_CAL_MEAS_0(i));
-		ah->ah_totalAdcDcOffsetIEvenPhase[i] +=
+		ah->totalAdcDcOffsetIEvenPhase[i] +=
 			(int32_t) REG_READ(ah, AR_PHY_CAL_MEAS_1(i));
-		ah->ah_totalAdcDcOffsetQOddPhase[i] +=
+		ah->totalAdcDcOffsetQOddPhase[i] +=
 			(int32_t) REG_READ(ah, AR_PHY_CAL_MEAS_2(i));
-		ah->ah_totalAdcDcOffsetQEvenPhase[i] +=
+		ah->totalAdcDcOffsetQEvenPhase[i] +=
 			(int32_t) REG_READ(ah, AR_PHY_CAL_MEAS_3(i));
 
 		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 			"%d: Chn %d oddi=0x%08x; eveni=0x%08x; "
 			"oddq=0x%08x; evenq=0x%08x;\n",
-			ah->ah_CalSamples, i,
-			ah->ah_totalAdcDcOffsetIOddPhase[i],
-			ah->ah_totalAdcDcOffsetIEvenPhase[i],
-			ah->ah_totalAdcDcOffsetQOddPhase[i],
-			ah->ah_totalAdcDcOffsetQEvenPhase[i]);
+			ah->cal_samples, i,
+			ah->totalAdcDcOffsetIOddPhase[i],
+			ah->totalAdcDcOffsetIEvenPhase[i],
+			ah->totalAdcDcOffsetQOddPhase[i],
+			ah->totalAdcDcOffsetQEvenPhase[i]);
 	}
 }
 
@@ -369,9 +369,9 @@ static void ath9k_hw_iqcalibrate(struct ath_hw *ah, u8 numChains)
 	int iqCorrNeg, i;
 
 	for (i = 0; i < numChains; i++) {
-		powerMeasI = ah->ah_totalPowerMeasI[i];
-		powerMeasQ = ah->ah_totalPowerMeasQ[i];
-		iqCorrMeas = ah->ah_totalIqCorrMeas[i];
+		powerMeasI = ah->totalPowerMeasI[i];
+		powerMeasQ = ah->totalPowerMeasQ[i];
+		iqCorrMeas = ah->totalIqCorrMeas[i];
 
 		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 			"Starting IQ Cal and Correction for Chain %d\n",
@@ -379,7 +379,7 @@ static void ath9k_hw_iqcalibrate(struct ath_hw *ah, u8 numChains)
 
 		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 			"Orignal: Chn %diq_corr_meas = 0x%08x\n",
-			i, ah->ah_totalIqCorrMeas[i]);
+			i, ah->totalIqCorrMeas[i]);
 
 		iqCorrNeg = 0;
 
@@ -443,10 +443,10 @@ static void ath9k_hw_adc_gaincal_calibrate(struct ath_hw *ah, u8 numChains)
 	u32 qGainMismatch, iGainMismatch, val, i;
 
 	for (i = 0; i < numChains; i++) {
-		iOddMeasOffset = ah->ah_totalAdcIOddPhase[i];
-		iEvenMeasOffset = ah->ah_totalAdcIEvenPhase[i];
-		qOddMeasOffset = ah->ah_totalAdcQOddPhase[i];
-		qEvenMeasOffset = ah->ah_totalAdcQEvenPhase[i];
+		iOddMeasOffset = ah->totalAdcIOddPhase[i];
+		iEvenMeasOffset = ah->totalAdcIEvenPhase[i];
+		qOddMeasOffset = ah->totalAdcQOddPhase[i];
+		qEvenMeasOffset = ah->totalAdcQEvenPhase[i];
 
 		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 			"Starting ADC Gain Cal for Chain %d\n", i);
@@ -499,15 +499,15 @@ static void ath9k_hw_adc_dccal_calibrate(struct ath_hw *ah, u8 numChains)
 	u32 iOddMeasOffset, iEvenMeasOffset, val, i;
 	int32_t qOddMeasOffset, qEvenMeasOffset, qDcMismatch, iDcMismatch;
 	const struct hal_percal_data *calData =
-		ah->ah_cal_list_curr->calData;
+		ah->cal_list_curr->calData;
 	u32 numSamples =
 		(1 << (calData->calCountMax + 5)) * calData->calNumSamples;
 
 	for (i = 0; i < numChains; i++) {
-		iOddMeasOffset = ah->ah_totalAdcDcOffsetIOddPhase[i];
-		iEvenMeasOffset = ah->ah_totalAdcDcOffsetIEvenPhase[i];
-		qOddMeasOffset = ah->ah_totalAdcDcOffsetQOddPhase[i];
-		qEvenMeasOffset = ah->ah_totalAdcDcOffsetQEvenPhase[i];
+		iOddMeasOffset = ah->totalAdcDcOffsetIOddPhase[i];
+		iEvenMeasOffset = ah->totalAdcDcOffsetIEvenPhase[i];
+		qOddMeasOffset = ah->totalAdcDcOffsetQOddPhase[i];
+		qEvenMeasOffset = ah->totalAdcDcOffsetQEvenPhase[i];
 
 		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 			"Starting ADC DC Offset Cal for Chain %d\n", i);
@@ -555,9 +555,9 @@ static void ath9k_hw_adc_dccal_calibrate(struct ath_hw *ah, u8 numChains)
 bool ath9k_hw_reset_calvalid(struct ath_hw *ah)
 {
 	struct ieee80211_conf *conf = &ah->ah_sc->hw->conf;
-	struct hal_cal_list *currCal = ah->ah_cal_list_curr;
+	struct hal_cal_list *currCal = ah->cal_list_curr;
 
-	if (!ah->ah_curchan)
+	if (!ah->curchan)
 		return true;
 
 	if (!AR_SREV_9100(ah) && !AR_SREV_9160_10_OR_LATER(ah))
@@ -580,7 +580,7 @@ bool ath9k_hw_reset_calvalid(struct ath_hw *ah)
 		"Resetting Cal %d state for channel %u\n",
 		currCal->calData->calType, conf->channel->center_freq);
 
-	ah->ah_curchan->CalValid &= ~currCal->calData->calType;
+	ah->curchan->CalValid &= ~currCal->calData->calType;
 	currCal->calState = CAL_WAITING;
 
 	return false;
@@ -722,7 +722,7 @@ bool ath9k_hw_calibrate(struct ath_hw *ah, struct ath9k_channel *chan,
 			u8 rxchainmask, bool longcal,
 			bool *isCalDone)
 {
-	struct hal_cal_list *currCal = ah->ah_cal_list_curr;
+	struct hal_cal_list *currCal = ah->cal_list_curr;
 
 	*isCalDone = true;
 
@@ -732,7 +732,7 @@ bool ath9k_hw_calibrate(struct ath_hw *ah, struct ath9k_channel *chan,
 		ath9k_hw_per_calibration(ah, chan, rxchainmask, currCal,
 					 isCalDone);
 		if (*isCalDone) {
-			ah->ah_cal_list_curr = currCal = currCal->calNext;
+			ah->cal_list_curr = currCal = currCal->calNext;
 
 			if (currCal->calState == CAL_WAITING) {
 				*isCalDone = false;
@@ -743,7 +743,7 @@ bool ath9k_hw_calibrate(struct ath_hw *ah, struct ath9k_channel *chan,
 
 	if (longcal) {
 		ath9k_hw_getnf(ah, chan);
-		ath9k_hw_loadnf(ah, ah->ah_curchan);
+		ath9k_hw_loadnf(ah, ah->curchan);
 		ath9k_hw_start_nfcal(ah);
 
 		if (chan->channelFlags & CHANNEL_CW_INT)
@@ -869,32 +869,32 @@ bool ath9k_hw_init_cal(struct ath_hw *ah,
 		  REG_READ(ah, AR_PHY_AGC_CONTROL) |
 		  AR_PHY_AGC_CONTROL_NF);
 
-	ah->ah_cal_list = ah->ah_cal_list_last = ah->ah_cal_list_curr = NULL;
+	ah->cal_list = ah->cal_list_last = ah->cal_list_curr = NULL;
 
 	if (AR_SREV_9100(ah) || AR_SREV_9160_10_OR_LATER(ah)) {
 		if (ath9k_hw_iscal_supported(ah, ADC_GAIN_CAL)) {
-			INIT_CAL(&ah->ah_adcGainCalData);
-			INSERT_CAL(ah, &ah->ah_adcGainCalData);
+			INIT_CAL(&ah->adcgain_caldata);
+			INSERT_CAL(ah, &ah->adcgain_caldata);
 			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 				"enabling ADC Gain Calibration.\n");
 		}
 		if (ath9k_hw_iscal_supported(ah, ADC_DC_CAL)) {
-			INIT_CAL(&ah->ah_adcDcCalData);
-			INSERT_CAL(ah, &ah->ah_adcDcCalData);
+			INIT_CAL(&ah->adcdc_caldata);
+			INSERT_CAL(ah, &ah->adcdc_caldata);
 			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 				"enabling ADC DC Calibration.\n");
 		}
 		if (ath9k_hw_iscal_supported(ah, IQ_MISMATCH_CAL)) {
-			INIT_CAL(&ah->ah_iqCalData);
-			INSERT_CAL(ah, &ah->ah_iqCalData);
+			INIT_CAL(&ah->iq_caldata);
+			INSERT_CAL(ah, &ah->iq_caldata);
 			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 				"enabling IQ Calibration.\n");
 		}
 
-		ah->ah_cal_list_curr = ah->ah_cal_list;
+		ah->cal_list_curr = ah->cal_list;
 
-		if (ah->ah_cal_list_curr)
-			ath9k_hw_reset_calibration(ah, ah->ah_cal_list_curr);
+		if (ah->cal_list_curr)
+			ath9k_hw_reset_calibration(ah, ah->cal_list_curr);
 	}
 
 	chan->CalValid = 0;
diff --git a/drivers/net/wireless/ath9k/calib.h b/drivers/net/wireless/ath9k/calib.h
index e2c6140..d2448f0 100644
--- a/drivers/net/wireless/ath9k/calib.h
+++ b/drivers/net/wireless/ath9k/calib.h
@@ -56,14 +56,14 @@ struct ar5416IniArray {
 
 #define INSERT_CAL(_ahp, _perCal)					\
 	do {								\
-		if ((_ahp)->ah_cal_list_last == NULL) {			\
-			(_ahp)->ah_cal_list =				\
-				(_ahp)->ah_cal_list_last = (_perCal);	\
-			((_ahp)->ah_cal_list_last)->calNext = (_perCal); \
+		if ((_ahp)->cal_list_last == NULL) {			\
+			(_ahp)->cal_list =				\
+				(_ahp)->cal_list_last = (_perCal);	\
+			((_ahp)->cal_list_last)->calNext = (_perCal); \
 		} else {						\
-			((_ahp)->ah_cal_list_last)->calNext = (_perCal); \
-			(_ahp)->ah_cal_list_last = (_perCal);		\
-			(_perCal)->calNext = (_ahp)->ah_cal_list;	\
+			((_ahp)->cal_list_last)->calNext = (_perCal); \
+			(_ahp)->cal_list_last = (_perCal);		\
+			(_perCal)->calNext = (_ahp)->cal_list;	\
 		}							\
 	} while (0)
 
diff --git a/drivers/net/wireless/ath9k/eeprom.c b/drivers/net/wireless/ath9k/eeprom.c
index 2e604e1..c0359ad 100644
--- a/drivers/net/wireless/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath9k/eeprom.c
@@ -27,7 +27,7 @@ static void ath9k_hw_analog_shift_rmw(struct ath_hw *ah,
 
 	REG_WRITE(ah, reg, regVal);
 
-	if (ah->ah_config.analog_shiftreg)
+	if (ah->config.analog_shiftreg)
 		udelay(100);
 
 	return;
@@ -268,18 +268,18 @@ static u16 ath9k_hw_get_max_edge_power(u16 freq,
 
 static int ath9k_hw_4k_get_eeprom_ver(struct ath_hw *ah)
 {
-	return ((ah->ah_eeprom.map4k.baseEepHeader.version >> 12) & 0xF);
+	return ((ah->eeprom.map4k.baseEepHeader.version >> 12) & 0xF);
 }
 
 static int ath9k_hw_4k_get_eeprom_rev(struct ath_hw *ah)
 {
-	return ((ah->ah_eeprom.map4k.baseEepHeader.version) & 0xFFF);
+	return ((ah->eeprom.map4k.baseEepHeader.version) & 0xFFF);
 }
 
 static bool ath9k_hw_4k_fill_eeprom(struct ath_hw *ah)
 {
 #define SIZE_EEPROM_4K (sizeof(struct ar5416_eeprom_4k) / sizeof(u16))
-	struct ar5416_eeprom_4k *eep = &ah->ah_eeprom.map4k;
+	struct ar5416_eeprom_4k *eep = &ah->eeprom.map4k;
 	u16 *eep_data;
 	int addr, eep_start_loc = 0;
 
@@ -308,7 +308,7 @@ static int ath9k_hw_4k_check_eeprom(struct ath_hw *ah)
 {
 #define EEPROM_4K_SIZE (sizeof(struct ar5416_eeprom_4k) / sizeof(u16))
 	struct ar5416_eeprom_4k *eep =
-		(struct ar5416_eeprom_4k *) &ah->ah_eeprom.map4k;
+		(struct ar5416_eeprom_4k *) &ah->eeprom.map4k;
 	u16 *eepdata, temp, magic, magic2;
 	u32 sum = 0, el;
 	bool need_swap = false;
@@ -332,7 +332,7 @@ static int ath9k_hw_4k_check_eeprom(struct ath_hw *ah)
 
 			if (magic2 == AR5416_EEPROM_MAGIC) {
 				need_swap = true;
-				eepdata = (u16 *) (&ah->ah_eeprom);
+				eepdata = (u16 *) (&ah->eeprom);
 
 				for (addr = 0; addr < EEPROM_4K_SIZE; addr++) {
 					temp = swab16(*eepdata);
@@ -359,16 +359,16 @@ static int ath9k_hw_4k_check_eeprom(struct ath_hw *ah)
 		need_swap ? "True" : "False");
 
 	if (need_swap)
-		el = swab16(ah->ah_eeprom.map4k.baseEepHeader.length);
+		el = swab16(ah->eeprom.map4k.baseEepHeader.length);
 	else
-		el = ah->ah_eeprom.map4k.baseEepHeader.length;
+		el = ah->eeprom.map4k.baseEepHeader.length;
 
 	if (el > sizeof(struct ar5416_eeprom_def))
 		el = sizeof(struct ar5416_eeprom_4k) / sizeof(u16);
 	else
 		el = el / sizeof(u16);
 
-	eepdata = (u16 *)(&ah->ah_eeprom);
+	eepdata = (u16 *)(&ah->eeprom);
 
 	for (i = 0; i < el; i++)
 		sum ^= *eepdata++;
@@ -433,7 +433,7 @@ static int ath9k_hw_4k_check_eeprom(struct ath_hw *ah)
 static u32 ath9k_hw_4k_get_eeprom(struct ath_hw *ah,
 				  enum eeprom_param param)
 {
-	struct ar5416_eeprom_4k *eep = &ah->ah_eeprom.map4k;
+	struct ar5416_eeprom_4k *eep = &ah->eeprom.map4k;
 	struct modal_eep_4k_header *pModal = &eep->modalHeader;
 	struct base_eep_header_4k *pBase = &eep->baseEepHeader;
 
@@ -643,7 +643,7 @@ static bool ath9k_hw_set_4k_power_cal_table(struct ath_hw *ah,
 				  struct ath9k_channel *chan,
 				  int16_t *pTxPowerIndexOffset)
 {
-	struct ar5416_eeprom_4k *pEepData = &ah->ah_eeprom.map4k;
+	struct ar5416_eeprom_4k *pEepData = &ah->eeprom.map4k;
 	struct cal_data_per_freq_4k *pRawDataset;
 	u8 *pCalBChans = NULL;
 	u16 pdGainOverlap_t2;
@@ -692,7 +692,7 @@ static bool ath9k_hw_set_4k_power_cal_table(struct ath_hw *ah,
 
 	for (i = 0; i < AR5416_MAX_CHAINS; i++) {
 		if (AR_SREV_5416_V20_OR_LATER(ah) &&
-		    (ah->ah_rxchainmask == 5 || ah->ah_txchainmask == 5) &&
+		    (ah->rxchainmask == 5 || ah->txchainmask == 5) &&
 		    (i != 0)) {
 			regChainOffset = (i == 1) ? 0x2000 : 0x1000;
 		} else
@@ -763,7 +763,7 @@ static bool ath9k_hw_set_4k_power_per_rate_table(struct ath_hw *ah,
 						 u16 twiceMaxRegulatoryPower,
 						 u16 powerLimit)
 {
-	struct ar5416_eeprom_4k *pEepData = &ah->ah_eeprom.map4k;
+	struct ar5416_eeprom_4k *pEepData = &ah->eeprom.map4k;
 	u16 twiceMaxEdgePower = AR5416_MAX_RATE_POWER;
 	static const u16 tpScaleReductionTable[5] =
 		{ 0, 3, 6, 9, AR5416_MAX_RATE_POWER };
@@ -791,7 +791,7 @@ static bool ath9k_hw_set_4k_power_per_rate_table(struct ath_hw *ah,
 	int tx_chainmask;
 	u16 twiceMinEdgePower;
 
-	tx_chainmask = ah->ah_txchainmask;
+	tx_chainmask = ah->txchainmask;
 
 	ath9k_hw_get_channel_centers(ah, chan, &centers);
 
@@ -997,7 +997,7 @@ static int ath9k_hw_4k_set_txpower(struct ath_hw *ah,
 				   u8 twiceMaxRegulatoryPower,
 				   u8 powerLimit)
 {
-	struct ar5416_eeprom_4k *pEepData = &ah->ah_eeprom.map4k;
+	struct ar5416_eeprom_4k *pEepData = &ah->eeprom.map4k;
 	struct modal_eep_4k_header *pModal = &pEepData->modalHeader;
 	int16_t ratesArray[Ar5416RateSize];
 	int16_t txPowerIndexOffset = 0;
@@ -1121,7 +1121,7 @@ static void ath9k_hw_4k_set_addac(struct ath_hw *ah,
 				  struct ath9k_channel *chan)
 {
 	struct modal_eep_4k_header *pModal;
-	struct ar5416_eeprom_4k *eep = &ah->ah_eeprom.map4k;
+	struct ar5416_eeprom_4k *eep = &ah->eeprom.map4k;
 	u8 biaslevel;
 
 	if (ah->hw_version.macVersion != AR_SREV_VERSION_9160)
@@ -1134,8 +1134,8 @@ static void ath9k_hw_4k_set_addac(struct ath_hw *ah,
 
 	if (pModal->xpaBiasLvl != 0xff) {
 		biaslevel = pModal->xpaBiasLvl;
-		INI_RA(&ah->ah_iniAddac, 7, 1) =
-		  (INI_RA(&ah->ah_iniAddac, 7, 1) & (~0x18)) | biaslevel << 3;
+		INI_RA(&ah->iniAddac, 7, 1) =
+		  (INI_RA(&ah->iniAddac, 7, 1) & (~0x18)) | biaslevel << 3;
 	}
 }
 
@@ -1143,7 +1143,7 @@ static bool ath9k_hw_4k_set_board_values(struct ath_hw *ah,
 					 struct ath9k_channel *chan)
 {
 	struct modal_eep_4k_header *pModal;
-	struct ar5416_eeprom_4k *eep = &ah->ah_eeprom.map4k;
+	struct ar5416_eeprom_4k *eep = &ah->eeprom.map4k;
 	int regChainOffset;
 	u8 txRxAttenLocal;
 	u8 ob[5], db1[5], db2[5];
@@ -1328,7 +1328,7 @@ static bool ath9k_hw_4k_set_board_values(struct ath_hw *ah,
 static u16 ath9k_hw_4k_get_eeprom_antenna_cfg(struct ath_hw *ah,
 					      struct ath9k_channel *chan)
 {
-	struct ar5416_eeprom_4k *eep = &ah->ah_eeprom.map4k;
+	struct ar5416_eeprom_4k *eep = &ah->eeprom.map4k;
 	struct modal_eep_4k_header *pModal = &eep->modalHeader;
 
 	return pModal->antCtrlCommon & 0xFFFF;
@@ -1343,19 +1343,19 @@ static u8 ath9k_hw_4k_get_num_ant_config(struct ath_hw *ah,
 u16 ath9k_hw_4k_get_spur_channel(struct ath_hw *ah, u16 i, bool is2GHz)
 {
 #define EEP_MAP4K_SPURCHAN \
-	(ah->ah_eeprom.map4k.modalHeader.spurChans[i].spurChan)
+	(ah->eeprom.map4k.modalHeader.spurChans[i].spurChan)
 
 	u16 spur_val = AR_NO_SPUR;
 
 	DPRINTF(ah->ah_sc, ATH_DBG_ANI,
 		"Getting spur idx %d is2Ghz. %d val %x\n",
-		i, is2GHz, ah->ah_config.spurchans[i][is2GHz]);
+		i, is2GHz, ah->config.spurchans[i][is2GHz]);
 
-	switch (ah->ah_config.spurmode) {
+	switch (ah->config.spurmode) {
 	case SPUR_DISABLE:
 		break;
 	case SPUR_ENABLE_IOCTL:
-		spur_val = ah->ah_config.spurchans[i][is2GHz];
+		spur_val = ah->config.spurchans[i][is2GHz];
 		DPRINTF(ah->ah_sc, ATH_DBG_ANI,
 			"Getting spur val from new loc. %d\n", spur_val);
 		break;
@@ -1389,18 +1389,18 @@ struct eeprom_ops eep_4k_ops = {
 
 static int ath9k_hw_def_get_eeprom_ver(struct ath_hw *ah)
 {
-	return ((ah->ah_eeprom.def.baseEepHeader.version >> 12) & 0xF);
+	return ((ah->eeprom.def.baseEepHeader.version >> 12) & 0xF);
 }
 
 static int ath9k_hw_def_get_eeprom_rev(struct ath_hw *ah)
 {
-	return ((ah->ah_eeprom.def.baseEepHeader.version) & 0xFFF);
+	return ((ah->eeprom.def.baseEepHeader.version) & 0xFFF);
 }
 
 static bool ath9k_hw_def_fill_eeprom(struct ath_hw *ah)
 {
 #define SIZE_EEPROM_DEF (sizeof(struct ar5416_eeprom_def) / sizeof(u16))
-	struct ar5416_eeprom_def *eep = &ah->ah_eeprom.def;
+	struct ar5416_eeprom_def *eep = &ah->eeprom.def;
 	u16 *eep_data;
 	int addr, ar5416_eep_start_loc = 0x100;
 
@@ -1422,7 +1422,7 @@ static bool ath9k_hw_def_fill_eeprom(struct ath_hw *ah)
 static int ath9k_hw_def_check_eeprom(struct ath_hw *ah)
 {
 	struct ar5416_eeprom_def *eep =
-		(struct ar5416_eeprom_def *) &ah->ah_eeprom.def;
+		(struct ar5416_eeprom_def *) &ah->eeprom.def;
 	u16 *eepdata, temp, magic, magic2;
 	u32 sum = 0, el;
 	bool need_swap = false;
@@ -1446,7 +1446,7 @@ static int ath9k_hw_def_check_eeprom(struct ath_hw *ah)
 			if (magic2 == AR5416_EEPROM_MAGIC) {
 				size = sizeof(struct ar5416_eeprom_def);
 				need_swap = true;
-				eepdata = (u16 *) (&ah->ah_eeprom);
+				eepdata = (u16 *) (&ah->eeprom);
 
 				for (addr = 0; addr < size / sizeof(u16); addr++) {
 					temp = swab16(*eepdata);
@@ -1473,16 +1473,16 @@ static int ath9k_hw_def_check_eeprom(struct ath_hw *ah)
 		need_swap ? "True" : "False");
 
 	if (need_swap)
-		el = swab16(ah->ah_eeprom.def.baseEepHeader.length);
+		el = swab16(ah->eeprom.def.baseEepHeader.length);
 	else
-		el = ah->ah_eeprom.def.baseEepHeader.length;
+		el = ah->eeprom.def.baseEepHeader.length;
 
 	if (el > sizeof(struct ar5416_eeprom_def))
 		el = sizeof(struct ar5416_eeprom_def) / sizeof(u16);
 	else
 		el = el / sizeof(u16);
 
-	eepdata = (u16 *)(&ah->ah_eeprom);
+	eepdata = (u16 *)(&ah->eeprom);
 
 	for (i = 0; i < el; i++)
 		sum ^= *eepdata++;
@@ -1551,7 +1551,7 @@ static u32 ath9k_hw_def_get_eeprom(struct ath_hw *ah,
 				   enum eeprom_param param)
 {
 #define AR5416_VER_MASK (pBase->version & AR5416_EEP_VER_MINOR_MASK)
-	struct ar5416_eeprom_def *eep = &ah->ah_eeprom.def;
+	struct ar5416_eeprom_def *eep = &ah->eeprom.def;
 	struct modal_eep_header *pModal = eep->modalHeader;
 	struct base_eep_header *pBase = &eep->baseEepHeader;
 
@@ -1611,7 +1611,7 @@ static bool ath9k_hw_def_set_board_values(struct ath_hw *ah,
 {
 #define AR5416_VER_MASK (eep->baseEepHeader.version & AR5416_EEP_VER_MINOR_MASK)
 	struct modal_eep_header *pModal;
-	struct ar5416_eeprom_def *eep = &ah->ah_eeprom.def;
+	struct ar5416_eeprom_def *eep = &ah->eeprom.def;
 	int i, regChainOffset;
 	u8 txRxAttenLocal;
 
@@ -1629,7 +1629,7 @@ static bool ath9k_hw_def_set_board_values(struct ath_hw *ah,
 		}
 
 		if (AR_SREV_5416_V20_OR_LATER(ah) &&
-		    (ah->ah_rxchainmask == 5 || ah->ah_txchainmask == 5)
+		    (ah->rxchainmask == 5 || ah->txchainmask == 5)
 		    && (i != 0))
 			regChainOffset = (i == 1) ? 0x2000 : 0x1000;
 		else
@@ -1855,7 +1855,7 @@ static void ath9k_hw_def_set_addac(struct ath_hw *ah,
 {
 #define XPA_LVL_FREQ(cnt) (pModal->xpaBiasLvlFreq[cnt])
 	struct modal_eep_header *pModal;
-	struct ar5416_eeprom_def *eep = &ah->ah_eeprom.def;
+	struct ar5416_eeprom_def *eep = &ah->eeprom.def;
 	u8 biaslevel;
 
 	if (ah->hw_version.macVersion != AR_SREV_VERSION_9160)
@@ -1895,10 +1895,10 @@ static void ath9k_hw_def_set_addac(struct ath_hw *ah,
 	}
 
 	if (IS_CHAN_2GHZ(chan)) {
-		INI_RA(&ah->ah_iniAddac, 7, 1) = (INI_RA(&ah->ah_iniAddac,
+		INI_RA(&ah->iniAddac, 7, 1) = (INI_RA(&ah->iniAddac,
 					7, 1) & (~0x18)) | biaslevel << 3;
 	} else {
-		INI_RA(&ah->ah_iniAddac, 6, 1) = (INI_RA(&ah->ah_iniAddac,
+		INI_RA(&ah->iniAddac, 6, 1) = (INI_RA(&ah->iniAddac,
 					6, 1) & (~0xc0)) | biaslevel << 6;
 	}
 #undef XPA_LVL_FREQ
@@ -2073,7 +2073,7 @@ static bool ath9k_hw_set_def_power_cal_table(struct ath_hw *ah,
 				  struct ath9k_channel *chan,
 				  int16_t *pTxPowerIndexOffset)
 {
-	struct ar5416_eeprom_def *pEepData = &ah->ah_eeprom.def;
+	struct ar5416_eeprom_def *pEepData = &ah->eeprom.def;
 	struct cal_data_per_freq *pRawDataset;
 	u8 *pCalBChans = NULL;
 	u16 pdGainOverlap_t2;
@@ -2129,7 +2129,7 @@ static bool ath9k_hw_set_def_power_cal_table(struct ath_hw *ah,
 
 	for (i = 0; i < AR5416_MAX_CHAINS; i++) {
 		if (AR_SREV_5416_V20_OR_LATER(ah) &&
-		    (ah->ah_rxchainmask == 5 || ah->ah_txchainmask == 5) &&
+		    (ah->rxchainmask == 5 || ah->txchainmask == 5) &&
 		    (i != 0)) {
 			regChainOffset = (i == 1) ? 0x2000 : 0x1000;
 		} else
@@ -2206,7 +2206,7 @@ static bool ath9k_hw_set_def_power_per_rate_table(struct ath_hw *ah,
 #define REDUCE_SCALED_POWER_BY_TWO_CHAIN     6  /* 10*log10(2)*2 */
 #define REDUCE_SCALED_POWER_BY_THREE_CHAIN   10 /* 10*log10(3)*2 */
 
-	struct ar5416_eeprom_def *pEepData = &ah->ah_eeprom.def;
+	struct ar5416_eeprom_def *pEepData = &ah->eeprom.def;
 	u16 twiceMaxEdgePower = AR5416_MAX_RATE_POWER;
 	static const u16 tpScaleReductionTable[5] =
 		{ 0, 3, 6, 9, AR5416_MAX_RATE_POWER };
@@ -2236,7 +2236,7 @@ static bool ath9k_hw_set_def_power_per_rate_table(struct ath_hw *ah,
 	int tx_chainmask;
 	u16 twiceMinEdgePower;
 
-	tx_chainmask = ah->ah_txchainmask;
+	tx_chainmask = ah->txchainmask;
 
 	ath9k_hw_get_channel_centers(ah, chan, &centers);
 
@@ -2493,7 +2493,7 @@ static int ath9k_hw_def_set_txpower(struct ath_hw *ah,
 				    u8 twiceMaxRegulatoryPower,
 				    u8 powerLimit)
 {
-	struct ar5416_eeprom_def *pEepData = &ah->ah_eeprom.def;
+	struct ar5416_eeprom_def *pEepData = &ah->eeprom.def;
 	struct modal_eep_header *pModal =
 		&(pEepData->modalHeader[IS_CHAN_2GHZ(chan)]);
 	int16_t ratesArray[Ar5416RateSize];
@@ -2621,7 +2621,7 @@ static int ath9k_hw_def_set_txpower(struct ath_hw *ah,
 static u8 ath9k_hw_def_get_num_ant_config(struct ath_hw *ah,
 					  enum ieee80211_band freq_band)
 {
-	struct ar5416_eeprom_def *eep = &ah->ah_eeprom.def;
+	struct ar5416_eeprom_def *eep = &ah->eeprom.def;
 	struct modal_eep_header *pModal =
 		&(eep->modalHeader[ATH9K_HAL_FREQ_BAND_2GHZ == freq_band]);
 	struct base_eep_header *pBase = &eep->baseEepHeader;
@@ -2639,7 +2639,7 @@ static u8 ath9k_hw_def_get_num_ant_config(struct ath_hw *ah,
 static u16 ath9k_hw_def_get_eeprom_antenna_cfg(struct ath_hw *ah,
 					       struct ath9k_channel *chan)
 {
-	struct ar5416_eeprom_def *eep = &ah->ah_eeprom.def;
+	struct ar5416_eeprom_def *eep = &ah->eeprom.def;
 	struct modal_eep_header *pModal =
 		&(eep->modalHeader[IS_CHAN_2GHZ(chan)]);
 
@@ -2649,19 +2649,19 @@ static u16 ath9k_hw_def_get_eeprom_antenna_cfg(struct ath_hw *ah,
 u16 ath9k_hw_def_get_spur_channel(struct ath_hw *ah, u16 i, bool is2GHz)
 {
 #define EEP_DEF_SPURCHAN \
-	(ah->ah_eeprom.def.modalHeader[is2GHz].spurChans[i].spurChan)
+	(ah->eeprom.def.modalHeader[is2GHz].spurChans[i].spurChan)
 
 	u16 spur_val = AR_NO_SPUR;
 
 	DPRINTF(ah->ah_sc, ATH_DBG_ANI,
 		"Getting spur idx %d is2Ghz. %d val %x\n",
-		i, is2GHz, ah->ah_config.spurchans[i][is2GHz]);
+		i, is2GHz, ah->config.spurchans[i][is2GHz]);
 
-	switch (ah->ah_config.spurmode) {
+	switch (ah->config.spurmode) {
 	case SPUR_DISABLE:
 		break;
 	case SPUR_ENABLE_IOCTL:
-		spur_val = ah->ah_config.spurchans[i][is2GHz];
+		spur_val = ah->config.spurchans[i][is2GHz];
 		DPRINTF(ah->ah_sc, ATH_DBG_ANI,
 			"Getting spur val from new loc. %d\n", spur_val);
 		break;
@@ -2694,10 +2694,10 @@ int ath9k_hw_eeprom_attach(struct ath_hw *ah)
 	int status;
 
 	if (AR_SREV_9285(ah)) {
-		ah->ah_eep_map = EEP_MAP_4KBITS;
+		ah->eep_map = EEP_MAP_4KBITS;
 		ah->eep_ops = &eep_4k_ops;
 	} else {
-		ah->ah_eep_map = EEP_MAP_DEFAULT;
+		ah->eep_map = EEP_MAP_DEFAULT;
 		ah->eep_ops = &eep_def_ops;
 	}
 
diff --git a/drivers/net/wireless/ath9k/eeprom.h b/drivers/net/wireless/ath9k/eeprom.h
index 7a4266f..99863b5 100644
--- a/drivers/net/wireless/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath9k/eeprom.h
@@ -441,7 +441,7 @@ struct ath9k_country_entry {
 	u8 iso[3];
 };
 
-enum hal_eep_map {
+enum ath9k_eep_map {
 	EEP_MAP_DEFAULT = 0x0,
 	EEP_MAP_4KBITS,
 	EEP_MAP_MAX
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index f744d8c..72ca1c8 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -45,7 +45,7 @@ static u32 ath9k_hw_mac_usec(struct ath_hw *ah, u32 clks)
 {
 	struct ieee80211_conf *conf = &ah->ah_sc->hw->conf;
 
-	if (!ah->ah_curchan) /* should really check for CCK instead */
+	if (!ah->curchan) /* should really check for CCK instead */
 		return clks / ATH9K_CLOCK_RATE_CCK;
 	if (conf->channel->band == IEEE80211_BAND_2GHZ)
 		return clks / ATH9K_CLOCK_RATE_2GHZ_OFDM;
@@ -67,7 +67,7 @@ static u32 ath9k_hw_mac_clks(struct ath_hw *ah, u32 usecs)
 {
 	struct ieee80211_conf *conf = &ah->ah_sc->hw->conf;
 
-	if (!ah->ah_curchan) /* should really check for CCK instead */
+	if (!ah->curchan) /* should really check for CCK instead */
 		return usecs *ATH9K_CLOCK_RATE_CCK;
 	if (conf->channel->band == IEEE80211_BAND_2GHZ)
 		return usecs *ATH9K_CLOCK_RATE_2GHZ_OFDM;
@@ -118,7 +118,7 @@ bool ath9k_get_channel_edges(struct ath_hw *ah,
 			     u16 flags, u16 *low,
 			     u16 *high)
 {
-	struct ath9k_hw_capabilities *pCap = &ah->ah_caps;
+	struct ath9k_hw_capabilities *pCap = &ah->caps;
 
 	if (flags & CHANNEL_5GHZ) {
 		*low = pCap->low_5ghz_chan;
@@ -155,15 +155,15 @@ u16 ath9k_hw_computetxtime(struct ath_hw *ah,
 		txTime = CCK_SIFS_TIME + phyTime + ((numBits * 1000) / kbps);
 		break;
 	case WLAN_RC_PHY_OFDM:
-		if (ah->ah_curchan && IS_CHAN_QUARTER_RATE(ah->ah_curchan)) {
+		if (ah->curchan && IS_CHAN_QUARTER_RATE(ah->curchan)) {
 			bitsPerSymbol =	(kbps * OFDM_SYMBOL_TIME_QUARTER) / 1000;
 			numBits = OFDM_PLCP_BITS + (frameLen << 3);
 			numSymbols = DIV_ROUND_UP(numBits, bitsPerSymbol);
 			txTime = OFDM_SIFS_TIME_QUARTER
 				+ OFDM_PREAMBLE_TIME_QUARTER
 				+ (numSymbols * OFDM_SYMBOL_TIME_QUARTER);
-		} else if (ah->ah_curchan &&
-			   IS_CHAN_HALF_RATE(ah->ah_curchan)) {
+		} else if (ah->curchan &&
+			   IS_CHAN_HALF_RATE(ah->curchan)) {
 			bitsPerSymbol =	(kbps * OFDM_SYMBOL_TIME_HALF) / 1000;
 			numBits = OFDM_PLCP_BITS + (frameLen << 3);
 			numSymbols = DIV_ROUND_UP(numBits, bitsPerSymbol);
@@ -216,7 +216,7 @@ void ath9k_hw_get_channel_centers(struct ath_hw *ah,
 		centers->synth_center - (extoff * HT40_CHANNEL_CENTER_SHIFT);
 	centers->ext_center =
 		centers->synth_center + (extoff *
-			 ((ah->ah_extprotspacing == ATH9K_HT_EXTPROTSPACING_20) ?
+			 ((ah->extprotspacing == ATH9K_HT_EXTPROTSPACING_20) ?
 			  HT40_CHANNEL_CENTER_SHIFT : 15));
 }
 
@@ -235,7 +235,7 @@ static void ath9k_hw_read_revisions(struct ath_hw *ah)
 		ah->hw_version.macVersion =
 			(val & AR_SREV_VERSION2) >> AR_SREV_TYPE2_S;
 		ah->hw_version.macRev = MS(val, AR_SREV_REVISION2);
-		ah->ah_isPciExpress = (val & AR_SREV_TYPE2_HOST_MODE) ? 0 : 1;
+		ah->is_pciexpress = (val & AR_SREV_TYPE2_HOST_MODE) ? 0 : 1;
 	} else {
 		if (!AR_SREV_9100(ah))
 			ah->hw_version.macVersion = MS(val, AR_SREV_VERSION);
@@ -243,7 +243,7 @@ static void ath9k_hw_read_revisions(struct ath_hw *ah)
 		ah->hw_version.macRev = val & AR_SREV_REVISION;
 
 		if (ah->hw_version.macVersion == AR_SREV_VERSION_5416_PCIE)
-			ah->ah_isPciExpress = true;
+			ah->is_pciexpress = true;
 	}
 }
 
@@ -355,40 +355,40 @@ static void ath9k_hw_set_defaults(struct ath_hw *ah)
 {
 	int i;
 
-	ah->ah_config.dma_beacon_response_time = 2;
-	ah->ah_config.sw_beacon_response_time = 10;
-	ah->ah_config.additional_swba_backoff = 0;
-	ah->ah_config.ack_6mb = 0x0;
-	ah->ah_config.cwm_ignore_extcca = 0;
-	ah->ah_config.pcie_powersave_enable = 0;
-	ah->ah_config.pcie_l1skp_enable = 0;
-	ah->ah_config.pcie_clock_req = 0;
-	ah->ah_config.pcie_power_reset = 0x100;
-	ah->ah_config.pcie_restore = 0;
-	ah->ah_config.pcie_waen = 0;
-	ah->ah_config.analog_shiftreg = 1;
-	ah->ah_config.ht_enable = 1;
-	ah->ah_config.ofdm_trig_low = 200;
-	ah->ah_config.ofdm_trig_high = 500;
-	ah->ah_config.cck_trig_high = 200;
-	ah->ah_config.cck_trig_low = 100;
-	ah->ah_config.enable_ani = 1;
-	ah->ah_config.noise_immunity_level = 4;
-	ah->ah_config.ofdm_weaksignal_det = 1;
-	ah->ah_config.cck_weaksignal_thr = 0;
-	ah->ah_config.spur_immunity_level = 2;
-	ah->ah_config.firstep_level = 0;
-	ah->ah_config.rssi_thr_high = 40;
-	ah->ah_config.rssi_thr_low = 7;
-	ah->ah_config.diversity_control = 0;
-	ah->ah_config.antenna_switch_swap = 0;
+	ah->config.dma_beacon_response_time = 2;
+	ah->config.sw_beacon_response_time = 10;
+	ah->config.additional_swba_backoff = 0;
+	ah->config.ack_6mb = 0x0;
+	ah->config.cwm_ignore_extcca = 0;
+	ah->config.pcie_powersave_enable = 0;
+	ah->config.pcie_l1skp_enable = 0;
+	ah->config.pcie_clock_req = 0;
+	ah->config.pcie_power_reset = 0x100;
+	ah->config.pcie_restore = 0;
+	ah->config.pcie_waen = 0;
+	ah->config.analog_shiftreg = 1;
+	ah->config.ht_enable = 1;
+	ah->config.ofdm_trig_low = 200;
+	ah->config.ofdm_trig_high = 500;
+	ah->config.cck_trig_high = 200;
+	ah->config.cck_trig_low = 100;
+	ah->config.enable_ani = 1;
+	ah->config.noise_immunity_level = 4;
+	ah->config.ofdm_weaksignal_det = 1;
+	ah->config.cck_weaksignal_thr = 0;
+	ah->config.spur_immunity_level = 2;
+	ah->config.firstep_level = 0;
+	ah->config.rssi_thr_high = 40;
+	ah->config.rssi_thr_low = 7;
+	ah->config.diversity_control = 0;
+	ah->config.antenna_switch_swap = 0;
 
 	for (i = 0; i < AR_EEPROM_MODAL_SPURS; i++) {
-		ah->ah_config.spurchans[i][0] = AR_NO_SPUR;
-		ah->ah_config.spurchans[i][1] = AR_NO_SPUR;
+		ah->config.spurchans[i][0] = AR_NO_SPUR;
+		ah->config.spurchans[i][1] = AR_NO_SPUR;
 	}
 
-	ah->ah_config.intr_mitigation = 1;
+	ah->config.intr_mitigation = 1;
 }
 
 static struct ath_hw *ath9k_hw_newstate(u16 devid, struct ath_softc *sc,
@@ -418,19 +418,19 @@ static struct ath_hw *ath9k_hw_newstate(u16 devid, struct ath_softc *sc,
 
 	ah->regulatory.power_limit = MAX_RATE_POWER;
 	ah->regulatory.tp_scale = ATH9K_TP_SCALE_MAX;
-	ah->ah_atimWindow = 0;
-	ah->ah_diversityControl = ah->ah_config.diversity_control;
-	ah->ah_antennaSwitchSwap =
-		ah->ah_config.antenna_switch_swap;
-	ah->ah_staId1Defaults = AR_STA_ID1_CRPT_MIC_ENABLE;
-	ah->ah_beaconInterval = 100;
-	ah->ah_enable32kHzClock = DONT_USE_32KHZ;
-	ah->ah_slottime = (u32) -1;
-	ah->ah_acktimeout = (u32) -1;
-	ah->ah_ctstimeout = (u32) -1;
-	ah->ah_globaltxtimeout = (u32) -1;
-
-	ah->ah_gBeaconRate = 0;
+	ah->atim_window = 0;
+	ah->diversity_control = ah->config.diversity_control;
+	ah->antenna_switch_swap =
+		ah->config.antenna_switch_swap;
+	ah->sta_id1_defaults = AR_STA_ID1_CRPT_MIC_ENABLE;
+	ah->beacon_interval = 100;
+	ah->enable_32kHz_clock = DONT_USE_32KHZ;
+	ah->slottime = (u32) -1;
+	ah->acktimeout = (u32) -1;
+	ah->ctstimeout = (u32) -1;
+	ah->globaltxtimeout = (u32) -1;
+
+	ah->gbeacon_rate = 0;
 
 	return ah;
 }
@@ -510,19 +510,19 @@ static void ath9k_hw_init_rxgain_ini(struct ath_hw *ah)
 		rxgain_type = ah->eep_ops->get_eeprom(ah, EEP_RXGAIN_TYPE);
 
 		if (rxgain_type == AR5416_EEP_RXGAIN_13DB_BACKOFF)
-			INIT_INI_ARRAY(&ah->ah_iniModesRxGain,
+			INIT_INI_ARRAY(&ah->iniModesRxGain,
 			ar9280Modes_backoff_13db_rxgain_9280_2,
 			ARRAY_SIZE(ar9280Modes_backoff_13db_rxgain_9280_2), 6);
 		else if (rxgain_type == AR5416_EEP_RXGAIN_23DB_BACKOFF)
-			INIT_INI_ARRAY(&ah->ah_iniModesRxGain,
+			INIT_INI_ARRAY(&ah->iniModesRxGain,
 			ar9280Modes_backoff_23db_rxgain_9280_2,
 			ARRAY_SIZE(ar9280Modes_backoff_23db_rxgain_9280_2), 6);
 		else
-			INIT_INI_ARRAY(&ah->ah_iniModesRxGain,
+			INIT_INI_ARRAY(&ah->iniModesRxGain,
 			ar9280Modes_original_rxgain_9280_2,
 			ARRAY_SIZE(ar9280Modes_original_rxgain_9280_2), 6);
 	} else {
-		INIT_INI_ARRAY(&ah->ah_iniModesRxGain,
+		INIT_INI_ARRAY(&ah->iniModesRxGain,
 			ar9280Modes_original_rxgain_9280_2,
 			ARRAY_SIZE(ar9280Modes_original_rxgain_9280_2), 6);
 	}
@@ -536,15 +536,15 @@ static void ath9k_hw_init_txgain_ini(struct ath_hw *ah)
 		txgain_type = ah->eep_ops->get_eeprom(ah, EEP_TXGAIN_TYPE);
 
 		if (txgain_type == AR5416_EEP_TXGAIN_HIGH_POWER)
-			INIT_INI_ARRAY(&ah->ah_iniModesTxGain,
+			INIT_INI_ARRAY(&ah->iniModesTxGain,
 			ar9280Modes_high_power_tx_gain_9280_2,
 			ARRAY_SIZE(ar9280Modes_high_power_tx_gain_9280_2), 6);
 		else
-			INIT_INI_ARRAY(&ah->ah_iniModesTxGain,
+			INIT_INI_ARRAY(&ah->iniModesTxGain,
 			ar9280Modes_original_tx_gain_9280_2,
 			ARRAY_SIZE(ar9280Modes_original_tx_gain_9280_2), 6);
 	} else {
-		INIT_INI_ARRAY(&ah->ah_iniModesTxGain,
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
 		ar9280Modes_original_tx_gain_9280_2,
 		ARRAY_SIZE(ar9280Modes_original_tx_gain_9280_2), 6);
 	}
@@ -592,8 +592,8 @@ static struct ath_hw *ath9k_hw_do_attach(u16 devid, struct ath_softc *sc,
 
 	ath9k_hw_set_defaults(ah);
 
-	if (ah->ah_config.intr_mitigation != 0)
-		ah->ah_intrMitigation = true;
+	if (ah->config.intr_mitigation != 0)
+		ah->intr_mitigation = true;
 
 	if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_POWER_ON)) {
 		DPRINTF(sc, ATH_DBG_RESET, "Couldn't reset chip\n");
@@ -607,18 +607,18 @@ static struct ath_hw *ath9k_hw_do_attach(u16 devid, struct ath_softc *sc,
 		goto bad;
 	}
 
-	if (ah->ah_config.serialize_regmode == SER_REG_MODE_AUTO) {
+	if (ah->config.serialize_regmode == SER_REG_MODE_AUTO) {
 		if (ah->hw_version.macVersion == AR_SREV_VERSION_5416_PCI) {
-			ah->ah_config.serialize_regmode =
+			ah->config.serialize_regmode =
 				SER_REG_MODE_ON;
 		} else {
-			ah->ah_config.serialize_regmode =
+			ah->config.serialize_regmode =
 				SER_REG_MODE_OFF;
 		}
 	}
 
 	DPRINTF(sc, ATH_DBG_RESET, "serialize_regmode is %d\n",
-		ah->ah_config.serialize_regmode);
+		ah->config.serialize_regmode);
 
 	if ((ah->hw_version.macVersion != AR_SREV_VERSION_5416_PCI) &&
 	    (ah->hw_version.macVersion != AR_SREV_VERSION_5416_PCIE) &&
@@ -633,41 +633,41 @@ static struct ath_hw *ath9k_hw_do_attach(u16 devid, struct ath_softc *sc,
 	}
 
 	if (AR_SREV_9100(ah)) {
-		ah->ah_iqCalData.calData = &iq_cal_multi_sample;
-		ah->ah_suppCals = IQ_MISMATCH_CAL;
-		ah->ah_isPciExpress = false;
+		ah->iq_caldata.calData = &iq_cal_multi_sample;
+		ah->supp_cals = IQ_MISMATCH_CAL;
+		ah->is_pciexpress = false;
 	}
 	ah->hw_version.phyRev = REG_READ(ah, AR_PHY_CHIP_ID);
 
 	if (AR_SREV_9160_10_OR_LATER(ah)) {
 		if (AR_SREV_9280_10_OR_LATER(ah)) {
-			ah->ah_iqCalData.calData = &iq_cal_single_sample;
-			ah->ah_adcGainCalData.calData =
+			ah->iq_caldata.calData = &iq_cal_single_sample;
+			ah->adcgain_caldata.calData =
 				&adc_gain_cal_single_sample;
-			ah->ah_adcDcCalData.calData =
+			ah->adcdc_caldata.calData =
 				&adc_dc_cal_single_sample;
-			ah->ah_adcDcCalInitData.calData =
+			ah->adcdc_calinitdata.calData =
 				&adc_init_dc_cal;
 		} else {
-			ah->ah_iqCalData.calData = &iq_cal_multi_sample;
-			ah->ah_adcGainCalData.calData =
+			ah->iq_caldata.calData = &iq_cal_multi_sample;
+			ah->adcgain_caldata.calData =
 				&adc_gain_cal_multi_sample;
-			ah->ah_adcDcCalData.calData =
+			ah->adcdc_caldata.calData =
 				&adc_dc_cal_multi_sample;
-			ah->ah_adcDcCalInitData.calData =
+			ah->adcdc_calinitdata.calData =
 				&adc_init_dc_cal;
 		}
-		ah->ah_suppCals = ADC_GAIN_CAL | ADC_DC_CAL | IQ_MISMATCH_CAL;
+		ah->supp_cals = ADC_GAIN_CAL | ADC_DC_CAL | IQ_MISMATCH_CAL;
 	}
 
 	if (AR_SREV_9160(ah)) {
-		ah->ah_config.enable_ani = 1;
-		ah->ah_ani_function = (ATH9K_ANI_SPUR_IMMUNITY_LEVEL |
+		ah->config.enable_ani = 1;
+		ah->ani_function = (ATH9K_ANI_SPUR_IMMUNITY_LEVEL |
 					ATH9K_ANI_FIRSTEP_LEVEL);
 	} else {
-		ah->ah_ani_function = ATH9K_ANI_ALL;
+		ah->ani_function = ATH9K_ANI_ALL;
 		if (AR_SREV_9280_10_OR_LATER(ah)) {
-			ah->ah_ani_function &=	~ATH9K_ANI_NOISE_IMMUNITY_LEVEL;
+			ah->ani_function &=	~ATH9K_ANI_NOISE_IMMUNITY_LEVEL;
 		}
 	}
 
@@ -676,137 +676,137 @@ static struct ath_hw *ath9k_hw_do_attach(u16 devid, struct ath_softc *sc,
 		ah->hw_version.macVersion, ah->hw_version.macRev);
 
 	if (AR_SREV_9285_12_OR_LATER(ah)) {
-		INIT_INI_ARRAY(&ah->ah_iniModes, ar9285Modes_9285_1_2,
+		INIT_INI_ARRAY(&ah->iniModes, ar9285Modes_9285_1_2,
 			       ARRAY_SIZE(ar9285Modes_9285_1_2), 6);
-		INIT_INI_ARRAY(&ah->ah_iniCommon, ar9285Common_9285_1_2,
+		INIT_INI_ARRAY(&ah->iniCommon, ar9285Common_9285_1_2,
 			       ARRAY_SIZE(ar9285Common_9285_1_2), 2);
 
-		if (ah->ah_config.pcie_clock_req) {
-			INIT_INI_ARRAY(&ah->ah_iniPcieSerdes,
+		if (ah->config.pcie_clock_req) {
+			INIT_INI_ARRAY(&ah->iniPcieSerdes,
 			ar9285PciePhy_clkreq_off_L1_9285_1_2,
 			ARRAY_SIZE(ar9285PciePhy_clkreq_off_L1_9285_1_2), 2);
 		} else {
-			INIT_INI_ARRAY(&ah->ah_iniPcieSerdes,
+			INIT_INI_ARRAY(&ah->iniPcieSerdes,
 			ar9285PciePhy_clkreq_always_on_L1_9285_1_2,
 			ARRAY_SIZE(ar9285PciePhy_clkreq_always_on_L1_9285_1_2),
 				  2);
 		}
 	} else if (AR_SREV_9285_10_OR_LATER(ah)) {
-		INIT_INI_ARRAY(&ah->ah_iniModes, ar9285Modes_9285,
+		INIT_INI_ARRAY(&ah->iniModes, ar9285Modes_9285,
 			       ARRAY_SIZE(ar9285Modes_9285), 6);
-		INIT_INI_ARRAY(&ah->ah_iniCommon, ar9285Common_9285,
+		INIT_INI_ARRAY(&ah->iniCommon, ar9285Common_9285,
 			       ARRAY_SIZE(ar9285Common_9285), 2);
 
-		if (ah->ah_config.pcie_clock_req) {
-			INIT_INI_ARRAY(&ah->ah_iniPcieSerdes,
+		if (ah->config.pcie_clock_req) {
+			INIT_INI_ARRAY(&ah->iniPcieSerdes,
 			ar9285PciePhy_clkreq_off_L1_9285,
 			ARRAY_SIZE(ar9285PciePhy_clkreq_off_L1_9285), 2);
 		} else {
-			INIT_INI_ARRAY(&ah->ah_iniPcieSerdes,
+			INIT_INI_ARRAY(&ah->iniPcieSerdes,
 			ar9285PciePhy_clkreq_always_on_L1_9285,
 			ARRAY_SIZE(ar9285PciePhy_clkreq_always_on_L1_9285), 2);
 		}
 	} else if (AR_SREV_9280_20_OR_LATER(ah)) {
-		INIT_INI_ARRAY(&ah->ah_iniModes, ar9280Modes_9280_2,
+		INIT_INI_ARRAY(&ah->iniModes, ar9280Modes_9280_2,
 			       ARRAY_SIZE(ar9280Modes_9280_2), 6);
-		INIT_INI_ARRAY(&ah->ah_iniCommon, ar9280Common_9280_2,
+		INIT_INI_ARRAY(&ah->iniCommon, ar9280Common_9280_2,
 			       ARRAY_SIZE(ar9280Common_9280_2), 2);
 
-		if (ah->ah_config.pcie_clock_req) {
-			INIT_INI_ARRAY(&ah->ah_iniPcieSerdes,
+		if (ah->config.pcie_clock_req) {
+			INIT_INI_ARRAY(&ah->iniPcieSerdes,
 			       ar9280PciePhy_clkreq_off_L1_9280,
 			       ARRAY_SIZE(ar9280PciePhy_clkreq_off_L1_9280),2);
 		} else {
-			INIT_INI_ARRAY(&ah->ah_iniPcieSerdes,
+			INIT_INI_ARRAY(&ah->iniPcieSerdes,
 			       ar9280PciePhy_clkreq_always_on_L1_9280,
 			       ARRAY_SIZE(ar9280PciePhy_clkreq_always_on_L1_9280), 2);
 		}
-		INIT_INI_ARRAY(&ah->ah_iniModesAdditional,
+		INIT_INI_ARRAY(&ah->iniModesAdditional,
 			       ar9280Modes_fast_clock_9280_2,
 			       ARRAY_SIZE(ar9280Modes_fast_clock_9280_2), 3);
 	} else if (AR_SREV_9280_10_OR_LATER(ah)) {
-		INIT_INI_ARRAY(&ah->ah_iniModes, ar9280Modes_9280,
+		INIT_INI_ARRAY(&ah->iniModes, ar9280Modes_9280,
 			       ARRAY_SIZE(ar9280Modes_9280), 6);
-		INIT_INI_ARRAY(&ah->ah_iniCommon, ar9280Common_9280,
+		INIT_INI_ARRAY(&ah->iniCommon, ar9280Common_9280,
 			       ARRAY_SIZE(ar9280Common_9280), 2);
 	} else if (AR_SREV_9160_10_OR_LATER(ah)) {
-		INIT_INI_ARRAY(&ah->ah_iniModes, ar5416Modes_9160,
+		INIT_INI_ARRAY(&ah->iniModes, ar5416Modes_9160,
 			       ARRAY_SIZE(ar5416Modes_9160), 6);
-		INIT_INI_ARRAY(&ah->ah_iniCommon, ar5416Common_9160,
+		INIT_INI_ARRAY(&ah->iniCommon, ar5416Common_9160,
 			       ARRAY_SIZE(ar5416Common_9160), 2);
-		INIT_INI_ARRAY(&ah->ah_iniBank0, ar5416Bank0_9160,
+		INIT_INI_ARRAY(&ah->iniBank0, ar5416Bank0_9160,
 			       ARRAY_SIZE(ar5416Bank0_9160), 2);
-		INIT_INI_ARRAY(&ah->ah_iniBB_RfGain, ar5416BB_RfGain_9160,
+		INIT_INI_ARRAY(&ah->iniBB_RfGain, ar5416BB_RfGain_9160,
 			       ARRAY_SIZE(ar5416BB_RfGain_9160), 3);
-		INIT_INI_ARRAY(&ah->ah_iniBank1, ar5416Bank1_9160,
+		INIT_INI_ARRAY(&ah->iniBank1, ar5416Bank1_9160,
 			       ARRAY_SIZE(ar5416Bank1_9160), 2);
-		INIT_INI_ARRAY(&ah->ah_iniBank2, ar5416Bank2_9160,
+		INIT_INI_ARRAY(&ah->iniBank2, ar5416Bank2_9160,
 			       ARRAY_SIZE(ar5416Bank2_9160), 2);
-		INIT_INI_ARRAY(&ah->ah_iniBank3, ar5416Bank3_9160,
+		INIT_INI_ARRAY(&ah->iniBank3, ar5416Bank3_9160,
 			       ARRAY_SIZE(ar5416Bank3_9160), 3);
-		INIT_INI_ARRAY(&ah->ah_iniBank6, ar5416Bank6_9160,
+		INIT_INI_ARRAY(&ah->iniBank6, ar5416Bank6_9160,
 			       ARRAY_SIZE(ar5416Bank6_9160), 3);
-		INIT_INI_ARRAY(&ah->ah_iniBank6TPC, ar5416Bank6TPC_9160,
+		INIT_INI_ARRAY(&ah->iniBank6TPC, ar5416Bank6TPC_9160,
 			       ARRAY_SIZE(ar5416Bank6TPC_9160), 3);
-		INIT_INI_ARRAY(&ah->ah_iniBank7, ar5416Bank7_9160,
+		INIT_INI_ARRAY(&ah->iniBank7, ar5416Bank7_9160,
 			       ARRAY_SIZE(ar5416Bank7_9160), 2);
 		if (AR_SREV_9160_11(ah)) {
-			INIT_INI_ARRAY(&ah->ah_iniAddac,
+			INIT_INI_ARRAY(&ah->iniAddac,
 				       ar5416Addac_91601_1,
 				       ARRAY_SIZE(ar5416Addac_91601_1), 2);
 		} else {
-			INIT_INI_ARRAY(&ah->ah_iniAddac, ar5416Addac_9160,
+			INIT_INI_ARRAY(&ah->iniAddac, ar5416Addac_9160,
 				       ARRAY_SIZE(ar5416Addac_9160), 2);
 		}
 	} else if (AR_SREV_9100_OR_LATER(ah)) {
-		INIT_INI_ARRAY(&ah->ah_iniModes, ar5416Modes_9100,
+		INIT_INI_ARRAY(&ah->iniModes, ar5416Modes_9100,
 			       ARRAY_SIZE(ar5416Modes_9100), 6);
-		INIT_INI_ARRAY(&ah->ah_iniCommon, ar5416Common_9100,
+		INIT_INI_ARRAY(&ah->iniCommon, ar5416Common_9100,
 			       ARRAY_SIZE(ar5416Common_9100), 2);
-		INIT_INI_ARRAY(&ah->ah_iniBank0, ar5416Bank0_9100,
+		INIT_INI_ARRAY(&ah->iniBank0, ar5416Bank0_9100,
 			       ARRAY_SIZE(ar5416Bank0_9100), 2);
-		INIT_INI_ARRAY(&ah->ah_iniBB_RfGain, ar5416BB_RfGain_9100,
+		INIT_INI_ARRAY(&ah->iniBB_RfGain, ar5416BB_RfGain_9100,
 			       ARRAY_SIZE(ar5416BB_RfGain_9100), 3);
-		INIT_INI_ARRAY(&ah->ah_iniBank1, ar5416Bank1_9100,
+		INIT_INI_ARRAY(&ah->iniBank1, ar5416Bank1_9100,
 			       ARRAY_SIZE(ar5416Bank1_9100), 2);
-		INIT_INI_ARRAY(&ah->ah_iniBank2, ar5416Bank2_9100,
+		INIT_INI_ARRAY(&ah->iniBank2, ar5416Bank2_9100,
 			       ARRAY_SIZE(ar5416Bank2_9100), 2);
-		INIT_INI_ARRAY(&ah->ah_iniBank3, ar5416Bank3_9100,
+		INIT_INI_ARRAY(&ah->iniBank3, ar5416Bank3_9100,
 			       ARRAY_SIZE(ar5416Bank3_9100), 3);
-		INIT_INI_ARRAY(&ah->ah_iniBank6, ar5416Bank6_9100,
+		INIT_INI_ARRAY(&ah->iniBank6, ar5416Bank6_9100,
 			       ARRAY_SIZE(ar5416Bank6_9100), 3);
-		INIT_INI_ARRAY(&ah->ah_iniBank6TPC, ar5416Bank6TPC_9100,
+		INIT_INI_ARRAY(&ah->iniBank6TPC, ar5416Bank6TPC_9100,
 			       ARRAY_SIZE(ar5416Bank6TPC_9100), 3);
-		INIT_INI_ARRAY(&ah->ah_iniBank7, ar5416Bank7_9100,
+		INIT_INI_ARRAY(&ah->iniBank7, ar5416Bank7_9100,
 			       ARRAY_SIZE(ar5416Bank7_9100), 2);
-		INIT_INI_ARRAY(&ah->ah_iniAddac, ar5416Addac_9100,
+		INIT_INI_ARRAY(&ah->iniAddac, ar5416Addac_9100,
 			       ARRAY_SIZE(ar5416Addac_9100), 2);
 	} else {
-		INIT_INI_ARRAY(&ah->ah_iniModes, ar5416Modes,
+		INIT_INI_ARRAY(&ah->iniModes, ar5416Modes,
 			       ARRAY_SIZE(ar5416Modes), 6);
-		INIT_INI_ARRAY(&ah->ah_iniCommon, ar5416Common,
+		INIT_INI_ARRAY(&ah->iniCommon, ar5416Common,
 			       ARRAY_SIZE(ar5416Common), 2);
-		INIT_INI_ARRAY(&ah->ah_iniBank0, ar5416Bank0,
+		INIT_INI_ARRAY(&ah->iniBank0, ar5416Bank0,
 			       ARRAY_SIZE(ar5416Bank0), 2);
-		INIT_INI_ARRAY(&ah->ah_iniBB_RfGain, ar5416BB_RfGain,
+		INIT_INI_ARRAY(&ah->iniBB_RfGain, ar5416BB_RfGain,
 			       ARRAY_SIZE(ar5416BB_RfGain), 3);
-		INIT_INI_ARRAY(&ah->ah_iniBank1, ar5416Bank1,
+		INIT_INI_ARRAY(&ah->iniBank1, ar5416Bank1,
 			       ARRAY_SIZE(ar5416Bank1), 2);
-		INIT_INI_ARRAY(&ah->ah_iniBank2, ar5416Bank2,
+		INIT_INI_ARRAY(&ah->iniBank2, ar5416Bank2,
 			       ARRAY_SIZE(ar5416Bank2), 2);
-		INIT_INI_ARRAY(&ah->ah_iniBank3, ar5416Bank3,
+		INIT_INI_ARRAY(&ah->iniBank3, ar5416Bank3,
 			       ARRAY_SIZE(ar5416Bank3), 3);
-		INIT_INI_ARRAY(&ah->ah_iniBank6, ar5416Bank6,
+		INIT_INI_ARRAY(&ah->iniBank6, ar5416Bank6,
 			       ARRAY_SIZE(ar5416Bank6), 3);
-		INIT_INI_ARRAY(&ah->ah_iniBank6TPC, ar5416Bank6TPC,
+		INIT_INI_ARRAY(&ah->iniBank6TPC, ar5416Bank6TPC,
 			       ARRAY_SIZE(ar5416Bank6TPC), 3);
-		INIT_INI_ARRAY(&ah->ah_iniBank7, ar5416Bank7,
+		INIT_INI_ARRAY(&ah->iniBank7, ar5416Bank7,
 			       ARRAY_SIZE(ar5416Bank7), 2);
-		INIT_INI_ARRAY(&ah->ah_iniAddac, ar5416Addac,
+		INIT_INI_ARRAY(&ah->iniAddac, ar5416Addac,
 			       ARRAY_SIZE(ar5416Addac), 2);
 	}
 
-	if (ah->ah_isPciExpress)
+	if (ah->is_pciexpress)
 		ath9k_hw_configpcipowersave(ah, 0);
 	else
 		ath9k_hw_disablepcie(ah);
@@ -824,15 +824,15 @@ static struct ath_hw *ath9k_hw_do_attach(u16 devid, struct ath_softc *sc,
 		ath9k_hw_init_txgain_ini(ah);
 
 	if (ah->hw_version.devid == AR9280_DEVID_PCI) {
-		for (i = 0; i < ah->ah_iniModes.ia_rows; i++) {
-			u32 reg = INI_RA(&ah->ah_iniModes, i, 0);
+		for (i = 0; i < ah->iniModes.ia_rows; i++) {
+			u32 reg = INI_RA(&ah->iniModes, i, 0);
 
-			for (j = 1; j < ah->ah_iniModes.ia_columns; j++) {
-				u32 val = INI_RA(&ah->ah_iniModes, i, j);
+			for (j = 1; j < ah->iniModes.ia_columns; j++) {
+				u32 val = INI_RA(&ah->iniModes, i, j);
 
-				INI_RA(&ah->ah_iniModes, i, j) =
+				INI_RA(&ah->iniModes, i, j) =
 					ath9k_hw_ini_fixup(ah,
-							   &ah->ah_eeprom.def,
+							   &ah->eeprom.def,
 							   reg, val);
 			}
 		}
@@ -853,9 +853,9 @@ static struct ath_hw *ath9k_hw_do_attach(u16 devid, struct ath_softc *sc,
 	}
 
 	if (AR_SREV_9285(ah))
-		ah->ah_txTrigLevel = (AR_FTRIG_256B >> AR_FTRIG_S);
+		ah->tx_trig_level = (AR_FTRIG_256B >> AR_FTRIG_S);
 	else
-		ah->ah_txTrigLevel = (AR_FTRIG_512B >> AR_FTRIG_S);
+		ah->tx_trig_level = (AR_FTRIG_512B >> AR_FTRIG_S);
 
 	ath9k_init_nfcal_hist_buffer(ah);
 
@@ -974,8 +974,8 @@ static void ath9k_hw_init_chain_masks(struct ath_hw *ah)
 {
 	int rx_chainmask, tx_chainmask;
 
-	rx_chainmask = ah->ah_rxchainmask;
-	tx_chainmask = ah->ah_txchainmask;
+	rx_chainmask = ah->rxchainmask;
+	tx_chainmask = ah->txchainmask;
 
 	switch (rx_chainmask) {
 	case 0x5:
@@ -1010,23 +1010,23 @@ static void ath9k_hw_init_chain_masks(struct ath_hw *ah)
 static void ath9k_hw_init_interrupt_masks(struct ath_hw *ah,
 					  enum nl80211_iftype opmode)
 {
-	ah->ah_maskReg = AR_IMR_TXERR |
+	ah->mask_reg = AR_IMR_TXERR |
 		AR_IMR_TXURN |
 		AR_IMR_RXERR |
 		AR_IMR_RXORN |
 		AR_IMR_BCNMISC;
 
-	if (ah->ah_intrMitigation)
-		ah->ah_maskReg |= AR_IMR_RXINTM | AR_IMR_RXMINTR;
+	if (ah->intr_mitigation)
+		ah->mask_reg |= AR_IMR_RXINTM | AR_IMR_RXMINTR;
 	else
-		ah->ah_maskReg |= AR_IMR_RXOK;
+		ah->mask_reg |= AR_IMR_RXOK;
 
-	ah->ah_maskReg |= AR_IMR_TXOK;
+	ah->mask_reg |= AR_IMR_TXOK;
 
 	if (opmode == NL80211_IFTYPE_AP)
-		ah->ah_maskReg |= AR_IMR_MIB;
+		ah->mask_reg |= AR_IMR_MIB;
 
-	REG_WRITE(ah, AR_IMR, ah->ah_maskReg);
+	REG_WRITE(ah, AR_IMR, ah->mask_reg);
 	REG_WRITE(ah, AR_IMR_S2, REG_READ(ah, AR_IMR_S2) | AR_IMR_S2_GTT);
 
 	if (!AR_SREV_9100(ah)) {
@@ -1040,12 +1040,12 @@ static bool ath9k_hw_set_ack_timeout(struct ath_hw *ah, u32 us)
 {
 	if (us > ath9k_hw_mac_to_usec(ah, MS(0xffffffff, AR_TIME_OUT_ACK))) {
 		DPRINTF(ah->ah_sc, ATH_DBG_RESET, "bad ack timeout %u\n", us);
-		ah->ah_acktimeout = (u32) -1;
+		ah->acktimeout = (u32) -1;
 		return false;
 	} else {
 		REG_RMW_FIELD(ah, AR_TIME_OUT,
 			      AR_TIME_OUT_ACK, ath9k_hw_mac_to_clks(ah, us));
-		ah->ah_acktimeout = us;
+		ah->acktimeout = us;
 		return true;
 	}
 }
@@ -1054,12 +1054,12 @@ static bool ath9k_hw_set_cts_timeout(struct ath_hw *ah, u32 us)
 {
 	if (us > ath9k_hw_mac_to_usec(ah, MS(0xffffffff, AR_TIME_OUT_CTS))) {
 		DPRINTF(ah->ah_sc, ATH_DBG_RESET, "bad cts timeout %u\n", us);
-		ah->ah_ctstimeout = (u32) -1;
+		ah->ctstimeout = (u32) -1;
 		return false;
 	} else {
 		REG_RMW_FIELD(ah, AR_TIME_OUT,
 			      AR_TIME_OUT_CTS, ath9k_hw_mac_to_clks(ah, us));
-		ah->ah_ctstimeout = us;
+		ah->ctstimeout = us;
 		return true;
 	}
 }
@@ -1069,31 +1069,31 @@ static bool ath9k_hw_set_global_txtimeout(struct ath_hw *ah, u32 tu)
 	if (tu > 0xFFFF) {
 		DPRINTF(ah->ah_sc, ATH_DBG_XMIT,
 			"bad global tx timeout %u\n", tu);
-		ah->ah_globaltxtimeout = (u32) -1;
+		ah->globaltxtimeout = (u32) -1;
 		return false;
 	} else {
 		REG_RMW_FIELD(ah, AR_GTXTO, AR_GTXTO_TIMEOUT_LIMIT, tu);
-		ah->ah_globaltxtimeout = tu;
+		ah->globaltxtimeout = tu;
 		return true;
 	}
 }
 
 static void ath9k_hw_init_user_settings(struct ath_hw *ah)
 {
-	DPRINTF(ah->ah_sc, ATH_DBG_RESET, "ah->ah_miscMode 0x%x\n",
-		ah->ah_miscMode);
+	DPRINTF(ah->ah_sc, ATH_DBG_RESET, "ah->misc_mode 0x%x\n",
+		ah->misc_mode);
 
-	if (ah->ah_miscMode != 0)
+	if (ah->misc_mode != 0)
 		REG_WRITE(ah, AR_PCU_MISC,
-			  REG_READ(ah, AR_PCU_MISC) | ah->ah_miscMode);
-	if (ah->ah_slottime != (u32) -1)
-		ath9k_hw_setslottime(ah, ah->ah_slottime);
-	if (ah->ah_acktimeout != (u32) -1)
-		ath9k_hw_set_ack_timeout(ah, ah->ah_acktimeout);
-	if (ah->ah_ctstimeout != (u32) -1)
-		ath9k_hw_set_cts_timeout(ah, ah->ah_ctstimeout);
-	if (ah->ah_globaltxtimeout != (u32) -1)
-		ath9k_hw_set_global_txtimeout(ah, ah->ah_globaltxtimeout);
+			  REG_READ(ah, AR_PCU_MISC) | ah->misc_mode);
+	if (ah->slottime != (u32) -1)
+		ath9k_hw_setslottime(ah, ah->slottime);
+	if (ah->acktimeout != (u32) -1)
+		ath9k_hw_set_ack_timeout(ah, ah->acktimeout);
+	if (ah->ctstimeout != (u32) -1)
+		ath9k_hw_set_cts_timeout(ah, ah->ctstimeout);
+	if (ah->globaltxtimeout != (u32) -1)
+		ath9k_hw_set_global_txtimeout(ah, ah->globaltxtimeout);
 }
 
 const char *ath9k_hw_probe(u16 vendorid, u16 devid)
@@ -1194,7 +1194,7 @@ static u32 ath9k_hw_ini_fixup(struct ath_hw *ah,
 			      struct ar5416_eeprom_def *pEepData,
 			      u32 reg, u32 value)
 {
-	if (ah->ah_eep_map == EEP_MAP_4KBITS)
+	if (ah->eep_map == EEP_MAP_4KBITS)
 		return value;
 	else
 		return ath9k_hw_def_ini_fixup(ah, pEepData, reg, value);
@@ -1241,34 +1241,34 @@ static int ath9k_hw_process_ini(struct ath_hw *ah,
 	ah->eep_ops->set_addac(ah, chan);
 
 	if (AR_SREV_5416_V22_OR_LATER(ah)) {
-		REG_WRITE_ARRAY(&ah->ah_iniAddac, 1, regWrites);
+		REG_WRITE_ARRAY(&ah->iniAddac, 1, regWrites);
 	} else {
 		struct ar5416IniArray temp;
 		u32 addacSize =
-			sizeof(u32) * ah->ah_iniAddac.ia_rows *
-			ah->ah_iniAddac.ia_columns;
+			sizeof(u32) * ah->iniAddac.ia_rows *
+			ah->iniAddac.ia_columns;
 
-		memcpy(ah->ah_addac5416_21,
-		       ah->ah_iniAddac.ia_array, addacSize);
+		memcpy(ah->addac5416_21,
+		       ah->iniAddac.ia_array, addacSize);
 
-		(ah->ah_addac5416_21)[31 * ah->ah_iniAddac.ia_columns + 1] = 0;
+		(ah->addac5416_21)[31 * ah->iniAddac.ia_columns + 1] = 0;
 
-		temp.ia_array = ah->ah_addac5416_21;
-		temp.ia_columns = ah->ah_iniAddac.ia_columns;
-		temp.ia_rows = ah->ah_iniAddac.ia_rows;
+		temp.ia_array = ah->addac5416_21;
+		temp.ia_columns = ah->iniAddac.ia_columns;
+		temp.ia_rows = ah->iniAddac.ia_rows;
 		REG_WRITE_ARRAY(&temp, 1, regWrites);
 	}
 
 	REG_WRITE(ah, AR_PHY_ADC_SERIAL_CTL, AR_PHY_SEL_INTERNAL_ADDAC);
 
-	for (i = 0; i < ah->ah_iniModes.ia_rows; i++) {
-		u32 reg = INI_RA(&ah->ah_iniModes, i, 0);
-		u32 val = INI_RA(&ah->ah_iniModes, i, modesIndex);
+	for (i = 0; i < ah->iniModes.ia_rows; i++) {
+		u32 reg = INI_RA(&ah->iniModes, i, 0);
+		u32 val = INI_RA(&ah->iniModes, i, modesIndex);
 
 		REG_WRITE(ah, reg, val);
 
 		if (reg >= 0x7800 && reg < 0x78a0
-		    && ah->ah_config.analog_shiftreg) {
+		    && ah->config.analog_shiftreg) {
 			udelay(100);
 		}
 
@@ -1276,19 +1276,19 @@ static int ath9k_hw_process_ini(struct ath_hw *ah,
 	}
 
 	if (AR_SREV_9280(ah))
-		REG_WRITE_ARRAY(&ah->ah_iniModesRxGain, modesIndex, regWrites);
+		REG_WRITE_ARRAY(&ah->iniModesRxGain, modesIndex, regWrites);
 
 	if (AR_SREV_9280(ah))
-		REG_WRITE_ARRAY(&ah->ah_iniModesTxGain, modesIndex, regWrites);
+		REG_WRITE_ARRAY(&ah->iniModesTxGain, modesIndex, regWrites);
 
-	for (i = 0; i < ah->ah_iniCommon.ia_rows; i++) {
-		u32 reg = INI_RA(&ah->ah_iniCommon, i, 0);
-		u32 val = INI_RA(&ah->ah_iniCommon, i, 1);
+	for (i = 0; i < ah->iniCommon.ia_rows; i++) {
+		u32 reg = INI_RA(&ah->iniCommon, i, 0);
+		u32 val = INI_RA(&ah->iniCommon, i, 1);
 
 		REG_WRITE(ah, reg, val);
 
 		if (reg >= 0x7800 && reg < 0x78a0
-		    && ah->ah_config.analog_shiftreg) {
+		    && ah->config.analog_shiftreg) {
 			udelay(100);
 		}
 
@@ -1298,7 +1298,7 @@ static int ath9k_hw_process_ini(struct ath_hw *ah,
 	ath9k_hw_write_regs(ah, modesIndex, freqIndex, regWrites);
 
 	if (AR_SREV_9280_20(ah) && IS_CHAN_A_5MHZ_SPACED(chan)) {
-		REG_WRITE_ARRAY(&ah->ah_iniModesAdditional, modesIndex,
+		REG_WRITE_ARRAY(&ah->iniModesAdditional, modesIndex,
 				regWrites);
 	}
 
@@ -1366,7 +1366,7 @@ static inline void ath9k_hw_set_dma(struct ath_hw *ah)
 	regval = REG_READ(ah, AR_TXCFG) & ~AR_TXCFG_DMASZ_MASK;
 	REG_WRITE(ah, AR_TXCFG, regval | AR_TXCFG_DMASZ_128B);
 
-	REG_RMW_FIELD(ah, AR_TXCFG, AR_FTRIG, ah->ah_txTrigLevel);
+	REG_RMW_FIELD(ah, AR_TXCFG, AR_FTRIG, ah->tx_trig_level);
 
 	regval = REG_READ(ah, AR_RXCFG) & ~AR_RXCFG_DMASZ_MASK;
 	REG_WRITE(ah, AR_RXCFG, regval | AR_RXCFG_DMASZ_128B);
@@ -1566,7 +1566,7 @@ static void ath9k_hw_set_regs(struct ath_hw *ah, struct ath9k_channel *chan,
 		    (chan->chanmode == CHANNEL_G_HT40PLUS))
 			phymode |= AR_PHY_FC_DYN2040_PRI_CH;
 
-		if (ah->ah_extprotspacing == ATH9K_HT_EXTPROTSPACING_25)
+		if (ah->extprotspacing == ATH9K_HT_EXTPROTSPACING_25)
 			phymode |= AR_PHY_FC_DYN2040_EXT_CH;
 	}
 	REG_WRITE(ah, AR_PHY_TURBO, phymode);
@@ -1586,7 +1586,7 @@ static bool ath9k_hw_chip_reset(struct ath_hw *ah,
 	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE))
 		return false;
 
-	ah->ah_chipFullSleep = false;
+	ah->chip_fullsleep = false;
 	ath9k_hw_init_pll(ah, chan);
 	ath9k_hw_set_rfmode(ah, chan);
 
@@ -1701,7 +1701,7 @@ static void ath9k_hw_9280_spur_mitigate(struct ath_hw *ah, struct ath9k_channel
 	ath9k_hw_get_channel_centers(ah, chan, &centers);
 	freq = centers.synth_center;
 
-	ah->ah_config.spurmode = SPUR_ENABLE_EEPROM;
+	ah->config.spurmode = SPUR_ENABLE_EEPROM;
 	for (i = 0; i < AR_EEPROM_MODAL_SPURS; i++) {
 		cur_bb_spur = ah->eep_ops->get_spur_channel(ah, i, is2GHz);
 
@@ -2123,21 +2123,21 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 {
 	u32 saveLedState;
 	struct ath_softc *sc = ah->ah_sc;
-	struct ath9k_channel *curchan = ah->ah_curchan;
+	struct ath9k_channel *curchan = ah->curchan;
 	u32 saveDefAntenna;
 	u32 macStaId1;
 	int i, rx_chainmask, r;
 
-	ah->ah_extprotspacing = sc->ht_extprotspacing;
-	ah->ah_txchainmask = sc->tx_chainmask;
-	ah->ah_rxchainmask = sc->rx_chainmask;
+	ah->extprotspacing = sc->ht_extprotspacing;
+	ah->txchainmask = sc->tx_chainmask;
+	ah->rxchainmask = sc->rx_chainmask;
 
 	if (AR_SREV_9285(ah)) {
-		ah->ah_txchainmask &= 0x1;
-		ah->ah_rxchainmask &= 0x1;
+		ah->txchainmask &= 0x1;
+		ah->rxchainmask &= 0x1;
 	} else if (AR_SREV_9280(ah)) {
-		ah->ah_txchainmask &= 0x3;
-		ah->ah_rxchainmask &= 0x3;
+		ah->txchainmask &= 0x3;
+		ah->rxchainmask &= 0x3;
 	}
 
 	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE))
@@ -2147,16 +2147,16 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 		ath9k_hw_getnf(ah, curchan);
 
 	if (bChannelChange &&
-	    (ah->ah_chipFullSleep != true) &&
-	    (ah->ah_curchan != NULL) &&
-	    (chan->channel != ah->ah_curchan->channel) &&
+	    (ah->chip_fullsleep != true) &&
+	    (ah->curchan != NULL) &&
+	    (chan->channel != ah->curchan->channel) &&
 	    ((chan->channelFlags & CHANNEL_ALL) ==
-	     (ah->ah_curchan->channelFlags & CHANNEL_ALL)) &&
+	     (ah->curchan->channelFlags & CHANNEL_ALL)) &&
 	    (!AR_SREV_9280(ah) || (!IS_CHAN_A_5MHZ_SPACED(chan) &&
-				   !IS_CHAN_A_5MHZ_SPACED(ah->ah_curchan)))) {
+				   !IS_CHAN_A_5MHZ_SPACED(ah->curchan)))) {
 
 		if (ath9k_hw_channel_change(ah, chan, sc->tx_chan_width)) {
-			ath9k_hw_loadnf(ah, ah->ah_curchan);
+			ath9k_hw_loadnf(ah, ah->curchan);
 			ath9k_hw_start_nfcal(ah);
 			return 0;
 		}
@@ -2223,10 +2223,10 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	REG_WRITE(ah, AR_STA_ID1, get_unaligned_le16(ah->macaddr + 4)
 		  | macStaId1
 		  | AR_STA_ID1_RTS_USE_DEF
-		  | (ah->ah_config.
+		  | (ah->config.
 		     ack_6mb ? AR_STA_ID1_ACKCTS_6MB : 0)
-		  | ah->ah_staId1Defaults);
-	ath9k_hw_set_operating_mode(ah, ah->ah_opmode);
+		  | ah->sta_id1_defaults);
+	ath9k_hw_set_operating_mode(ah, ah->opmode);
 
 	REG_WRITE(ah, AR_BSSMSKL, get_unaligned_le32(sc->bssidmask));
 	REG_WRITE(ah, AR_BSSMSKU, get_unaligned_le16(sc->bssidmask + 4));
@@ -2252,15 +2252,15 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	for (i = 0; i < AR_NUM_DCU; i++)
 		REG_WRITE(ah, AR_DQCUMASK(i), 1 << i);
 
-	ah->ah_intrTxqs = 0;
-	for (i = 0; i < ah->ah_caps.total_queues; i++)
+	ah->intr_txqs = 0;
+	for (i = 0; i < ah->caps.total_queues; i++)
 		ath9k_hw_resettxqueue(ah, i);
 
-	ath9k_hw_init_interrupt_masks(ah, ah->ah_opmode);
+	ath9k_hw_init_interrupt_masks(ah, ah->opmode);
 	ath9k_hw_init_qos(ah);
 
 #if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
-	if (ah->ah_caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
+	if (ah->caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
 		ath9k_enable_rfkill(ah);
 #endif
 	ath9k_hw_init_user_settings(ah);
@@ -2272,7 +2272,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 
 	REG_WRITE(ah, AR_OBS, 8);
 
-	if (ah->ah_intrMitigation) {
+	if (ah->intr_mitigation) {
 
 		REG_RMW_FIELD(ah, AR_RIMT, AR_RIMT_LAST, 500);
 		REG_RMW_FIELD(ah, AR_RIMT, AR_RIMT_FIRST, 2000);
@@ -2283,7 +2283,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	if (!ath9k_hw_init_cal(ah, chan))
 		return -EIO;;
 
-	rx_chainmask = ah->ah_rxchainmask;
+	rx_chainmask = ah->rxchainmask;
 	if ((rx_chainmask == 0x5) || (rx_chainmask == 0x3)) {
 		REG_WRITE(ah, AR_PHY_RX_CHAINMASK, rx_chainmask);
 		REG_WRITE(ah, AR_PHY_CAL_CHAINMASK, rx_chainmask);
@@ -2321,7 +2321,7 @@ bool ath9k_hw_keyreset(struct ath_hw *ah, u16 entry)
 {
 	u32 keyType;
 
-	if (entry >= ah->ah_caps.keycache_size) {
+	if (entry >= ah->caps.keycache_size) {
 		DPRINTF(ah->ah_sc, ATH_DBG_KEYCACHE,
 			"entry %u out of range\n", entry);
 		return false;
@@ -2348,7 +2348,7 @@ bool ath9k_hw_keyreset(struct ath_hw *ah, u16 entry)
 
 	}
 
-	if (ah->ah_curchan == NULL)
+	if (ah->curchan == NULL)
 		return true;
 
 	return true;
@@ -2358,7 +2358,7 @@ bool ath9k_hw_keysetmac(struct ath_hw *ah, u16 entry, const u8 *mac)
 {
 	u32 macHi, macLo;
 
-	if (entry >= ah->ah_caps.keycache_size) {
+	if (entry >= ah->caps.keycache_size) {
 		DPRINTF(ah->ah_sc, ATH_DBG_KEYCACHE,
 			"entry %u out of range\n", entry);
 		return false;
@@ -2386,7 +2386,7 @@ bool ath9k_hw_set_keycache_entry(struct ath_hw *ah, u16 entry,
 				 const struct ath9k_keyval *k,
 				 const u8 *mac, int xorKey)
 {
-	const struct ath9k_hw_capabilities *pCap = &ah->ah_caps;
+	const struct ath9k_hw_capabilities *pCap = &ah->caps;
 	u32 key0, key1, key2, key3, key4;
 	u32 keyType;
 	u32 xorMask = xorKey ?
@@ -2462,7 +2462,7 @@ bool ath9k_hw_set_keycache_entry(struct ath_hw *ah, u16 entry,
 		REG_WRITE(ah, AR_KEYTABLE_TYPE(entry), keyType);
 		(void) ath9k_hw_keysetmac(ah, entry, mac);
 
-		if (ah->ah_miscMode & AR_PCU_MIC_NEW_LOC_ENA) {
+		if (ah->misc_mode & AR_PCU_MIC_NEW_LOC_ENA) {
 			u32 mic0, mic1, mic2, mic3, mic4;
 
 			mic0 = get_unaligned_le32(k->kv_mic + 0);
@@ -2506,7 +2506,7 @@ bool ath9k_hw_set_keycache_entry(struct ath_hw *ah, u16 entry,
 		(void) ath9k_hw_keysetmac(ah, entry, mac);
 	}
 
-	if (ah->ah_curchan == NULL)
+	if (ah->curchan == NULL)
 		return true;
 
 	return true;
@@ -2514,7 +2514,7 @@ bool ath9k_hw_set_keycache_entry(struct ath_hw *ah, u16 entry,
 
 bool ath9k_hw_keyisvalid(struct ath_hw *ah, u16 entry)
 {
-	if (entry < ah->ah_caps.keycache_size) {
+	if (entry < ah->caps.keycache_size) {
 		u32 val = REG_READ(ah, AR_KEYTABLE_MAC1(entry));
 		if (val & AR_KEYTABLE_VALID)
 			return true;
@@ -2544,7 +2544,7 @@ static void ath9k_set_power_network_sleep(struct ath_hw *ah, int setChip)
 {
 	REG_SET_BIT(ah, AR_STA_ID1, AR_STA_ID1_PWR_SAV);
 	if (setChip) {
-		struct ath9k_hw_capabilities *pCap = &ah->ah_caps;
+		struct ath9k_hw_capabilities *pCap = &ah->caps;
 
 		if (!(pCap->hw_caps & ATH9K_HW_CAP_AUTOSLEEP)) {
 			REG_WRITE(ah, AR_RTC_FORCE_WAKE,
@@ -2608,7 +2608,7 @@ bool ath9k_hw_setpower(struct ath_hw *ah, enum ath9k_power_mode mode)
 	};
 
 	DPRINTF(ah->ah_sc, ATH_DBG_POWER_MGMT, "%s -> %s (%s)\n",
-		modes[ah->ah_power_mode], modes[mode],
+		modes[ah->power_mode], modes[mode],
 		setChip ? "set chip " : "");
 
 	switch (mode) {
@@ -2617,7 +2617,7 @@ bool ath9k_hw_setpower(struct ath_hw *ah, enum ath9k_power_mode mode)
 		break;
 	case ATH9K_PM_FULL_SLEEP:
 		ath9k_set_power_sleep(ah, setChip);
-		ah->ah_chipFullSleep = true;
+		ah->chip_fullsleep = true;
 		break;
 	case ATH9K_PM_NETWORK_SLEEP:
 		ath9k_set_power_network_sleep(ah, setChip);
@@ -2627,7 +2627,7 @@ bool ath9k_hw_setpower(struct ath_hw *ah, enum ath9k_power_mode mode)
 			"Unknown power mode %u\n", mode);
 		return false;
 	}
-	ah->ah_power_mode = mode;
+	ah->power_mode = mode;
 
 	return status;
 }
@@ -2636,19 +2636,19 @@ void ath9k_hw_configpcipowersave(struct ath_hw *ah, int restore)
 {
 	u8 i;
 
-	if (ah->ah_isPciExpress != true)
+	if (ah->is_pciexpress != true)
 		return;
 
-	if (ah->ah_config.pcie_powersave_enable == 2)
+	if (ah->config.pcie_powersave_enable == 2)
 		return;
 
 	if (restore)
 		return;
 
 	if (AR_SREV_9280_20_OR_LATER(ah)) {
-		for (i = 0; i < ah->ah_iniPcieSerdes.ia_rows; i++) {
-			REG_WRITE(ah, INI_RA(&ah->ah_iniPcieSerdes, i, 0),
-				  INI_RA(&ah->ah_iniPcieSerdes, i, 1));
+		for (i = 0; i < ah->iniPcieSerdes.ia_rows; i++) {
+			REG_WRITE(ah, INI_RA(&ah->iniPcieSerdes, i, 0),
+				  INI_RA(&ah->iniPcieSerdes, i, 1));
 		}
 		udelay(1000);
 	} else if (AR_SREV_9280(ah) &&
@@ -2660,7 +2660,7 @@ void ath9k_hw_configpcipowersave(struct ath_hw *ah, int restore)
 		REG_WRITE(ah, AR_PCIE_SERDES, 0x13160820);
 		REG_WRITE(ah, AR_PCIE_SERDES, 0xe5980560);
 
-		if (ah->ah_config.pcie_clock_req)
+		if (ah->config.pcie_clock_req)
 			REG_WRITE(ah, AR_PCIE_SERDES, 0x401deffc);
 		else
 			REG_WRITE(ah, AR_PCIE_SERDES, 0x401deffd);
@@ -2687,8 +2687,8 @@ void ath9k_hw_configpcipowersave(struct ath_hw *ah, int restore)
 
 	REG_SET_BIT(ah, AR_PCIE_PM_CTRL, AR_PCIE_PM_CTRL_ENA);
 
-	if (ah->ah_config.pcie_waen) {
-		REG_WRITE(ah, AR_WA, ah->ah_config.pcie_waen);
+	if (ah->config.pcie_waen) {
+		REG_WRITE(ah, AR_WA, ah->config.pcie_waen);
 	} else {
 		if (AR_SREV_9285(ah))
 			REG_WRITE(ah, AR_WA, AR9285_WA_DEFAULT);
@@ -2726,7 +2726,7 @@ bool ath9k_hw_getisr(struct ath_hw *ah, enum ath9k_int *masked)
 {
 	u32 isr = 0;
 	u32 mask2 = 0;
-	struct ath9k_hw_capabilities *pCap = &ah->ah_caps;
+	struct ath9k_hw_capabilities *pCap = &ah->caps;
 	u32 sync_cause = 0;
 	bool fatal_int = false;
 
@@ -2776,7 +2776,7 @@ bool ath9k_hw_getisr(struct ath_hw *ah, enum ath9k_int *masked)
 
 		*masked = isr & ATH9K_INT_COMMON;
 
-		if (ah->ah_intrMitigation) {
+		if (ah->intr_mitigation) {
 			if (isr & (AR_ISR_RXMINTR | AR_ISR_RXINTM))
 				*masked |= ATH9K_INT_RX;
 		}
@@ -2791,12 +2791,12 @@ bool ath9k_hw_getisr(struct ath_hw *ah, enum ath9k_int *masked)
 			*masked |= ATH9K_INT_TX;
 
 			s0_s = REG_READ(ah, AR_ISR_S0_S);
-			ah->ah_intrTxqs |= MS(s0_s, AR_ISR_S0_QCU_TXOK);
-			ah->ah_intrTxqs |= MS(s0_s, AR_ISR_S0_QCU_TXDESC);
+			ah->intr_txqs |= MS(s0_s, AR_ISR_S0_QCU_TXOK);
+			ah->intr_txqs |= MS(s0_s, AR_ISR_S0_QCU_TXDESC);
 
 			s1_s = REG_READ(ah, AR_ISR_S1_S);
-			ah->ah_intrTxqs |= MS(s1_s, AR_ISR_S1_QCU_TXERR);
-			ah->ah_intrTxqs |= MS(s1_s, AR_ISR_S1_QCU_TXEOL);
+			ah->intr_txqs |= MS(s1_s, AR_ISR_S1_QCU_TXERR);
+			ah->intr_txqs |= MS(s1_s, AR_ISR_S1_QCU_TXEOL);
 		}
 
 		if (isr & AR_ISR_RXORN) {
@@ -2855,14 +2855,14 @@ bool ath9k_hw_getisr(struct ath_hw *ah, enum ath9k_int *masked)
 
 enum ath9k_int ath9k_hw_intrget(struct ath_hw *ah)
 {
-	return ah->ah_maskReg;
+	return ah->mask_reg;
 }
 
 enum ath9k_int ath9k_hw_set_interrupts(struct ath_hw *ah, enum ath9k_int ints)
 {
-	u32 omask = ah->ah_maskReg;
+	u32 omask = ah->mask_reg;
 	u32 mask, mask2;
-	struct ath9k_hw_capabilities *pCap = &ah->ah_caps;
+	struct ath9k_hw_capabilities *pCap = &ah->caps;
 
 	DPRINTF(ah->ah_sc, ATH_DBG_INTERRUPT, "0x%x => 0x%x\n", omask, ints);
 
@@ -2883,18 +2883,18 @@ enum ath9k_int ath9k_hw_set_interrupts(struct ath_hw *ah, enum ath9k_int ints)
 	mask2 = 0;
 
 	if (ints & ATH9K_INT_TX) {
-		if (ah->ah_txOkInterruptMask)
+		if (ah->txok_interrupt_mask)
 			mask |= AR_IMR_TXOK;
-		if (ah->ah_txDescInterruptMask)
+		if (ah->txdesc_interrupt_mask)
 			mask |= AR_IMR_TXDESC;
-		if (ah->ah_txErrInterruptMask)
+		if (ah->txerr_interrupt_mask)
 			mask |= AR_IMR_TXERR;
-		if (ah->ah_txEolInterruptMask)
+		if (ah->txeol_interrupt_mask)
 			mask |= AR_IMR_TXEOL;
 	}
 	if (ints & ATH9K_INT_RX) {
 		mask |= AR_IMR_RXERR;
-		if (ah->ah_intrMitigation)
+		if (ah->intr_mitigation)
 			mask |= AR_IMR_RXMINTR | AR_IMR_RXINTM;
 		else
 			mask |= AR_IMR_RXOK | AR_IMR_RXDESC;
@@ -2932,7 +2932,7 @@ enum ath9k_int ath9k_hw_set_interrupts(struct ath_hw *ah, enum ath9k_int ints)
 					   AR_IMR_S2_TSFOOR |
 					   AR_IMR_S2_GTT | AR_IMR_S2_CST);
 	REG_WRITE(ah, AR_IMR_S2, mask | mask2);
-	ah->ah_maskReg = ints;
+	ah->mask_reg = ints;
 
 	if (!(pCap->hw_caps & ATH9K_HW_CAP_AUTOSLEEP)) {
 		if (ints & ATH9K_INT_TIM_TIMER)
@@ -2970,9 +2970,9 @@ void ath9k_hw_beaconinit(struct ath_hw *ah, u32 next_beacon, u32 beacon_period)
 {
 	int flags = 0;
 
-	ah->ah_beaconInterval = beacon_period;
+	ah->beacon_interval = beacon_period;
 
-	switch (ah->ah_opmode) {
+	switch (ah->opmode) {
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_MONITOR:
 		REG_WRITE(ah, AR_NEXT_TBTT_TIMER, TU_TO_USEC(next_beacon));
@@ -2985,18 +2985,18 @@ void ath9k_hw_beaconinit(struct ath_hw *ah, u32 next_beacon, u32 beacon_period)
 			    AR_TXCFG_ADHOC_BEACON_ATIM_TX_POLICY);
 		REG_WRITE(ah, AR_NEXT_NDP_TIMER,
 			  TU_TO_USEC(next_beacon +
-				     (ah->ah_atimWindow ? ah->
-				      ah_atimWindow : 1)));
+				     (ah->atim_window ? ah->
+				      atim_window : 1)));
 		flags |= AR_NDP_TIMER_EN;
 	case NL80211_IFTYPE_AP:
 		REG_WRITE(ah, AR_NEXT_TBTT_TIMER, TU_TO_USEC(next_beacon));
 		REG_WRITE(ah, AR_NEXT_DMA_BEACON_ALERT,
 			  TU_TO_USEC(next_beacon -
-				     ah->ah_config.
+				     ah->config.
 				     dma_beacon_response_time));
 		REG_WRITE(ah, AR_NEXT_SWBA,
 			  TU_TO_USEC(next_beacon -
-				     ah->ah_config.
+				     ah->config.
 				     sw_beacon_response_time));
 		flags |=
 			AR_TBTT_TIMER_EN | AR_DBA_TIMER_EN | AR_SWBA_TIMER_EN;
@@ -3004,7 +3004,7 @@ void ath9k_hw_beaconinit(struct ath_hw *ah, u32 next_beacon, u32 beacon_period)
 	default:
 		DPRINTF(ah->ah_sc, ATH_DBG_BEACON,
 			"%s: unsupported opmode: %d\n",
-			__func__, ah->ah_opmode);
+			__func__, ah->opmode);
 		return;
 		break;
 	}
@@ -3027,7 +3027,7 @@ void ath9k_hw_set_sta_beacon_timers(struct ath_hw *ah,
 				    const struct ath9k_beacon_state *bs)
 {
 	u32 nextTbtt, beaconintval, dtimperiod, beacontimeout;
-	struct ath9k_hw_capabilities *pCap = &ah->ah_caps;
+	struct ath9k_hw_capabilities *pCap = &ah->caps;
 
 	REG_WRITE(ah, AR_NEXT_TBTT_TIMER, TU_TO_USEC(bs->bs_nexttbtt));
 
@@ -3089,7 +3089,7 @@ void ath9k_hw_set_sta_beacon_timers(struct ath_hw *ah,
 
 bool ath9k_hw_fill_cap_info(struct ath_hw *ah)
 {
-	struct ath9k_hw_capabilities *pCap = &ah->ah_caps;
+	struct ath9k_hw_capabilities *pCap = &ah->caps;
 	u16 capField = 0, eeval;
 
 	eeval = ah->eep_ops->get_eeprom(ah, EEP_REG_0);
@@ -3101,7 +3101,7 @@ bool ath9k_hw_fill_cap_info(struct ath_hw *ah)
 
 	capField = ah->eep_ops->get_eeprom(ah, EEP_OP_CAP);
 
-	if (ah->ah_opmode != NL80211_IFTYPE_AP &&
+	if (ah->opmode != NL80211_IFTYPE_AP &&
 	    ah->hw_version.subvendorid == AR_SUBVENDOR_ID_NEW_A) {
 		if (ah->regulatory.current_rd == 0x64 ||
 		    ah->regulatory.current_rd == 0x65)
@@ -3117,7 +3117,7 @@ bool ath9k_hw_fill_cap_info(struct ath_hw *ah)
 
 	if (eeval & AR5416_OPFLAGS_11A) {
 		set_bit(ATH9K_MODE_11A, pCap->wireless_modes);
-		if (ah->ah_config.ht_enable) {
+		if (ah->config.ht_enable) {
 			if (!(eeval & AR5416_OPFLAGS_N_5G_HT20))
 				set_bit(ATH9K_MODE_11NA_HT20,
 					pCap->wireless_modes);
@@ -3133,7 +3133,7 @@ bool ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	if (eeval & AR5416_OPFLAGS_11G) {
 		set_bit(ATH9K_MODE_11B, pCap->wireless_modes);
 		set_bit(ATH9K_MODE_11G, pCap->wireless_modes);
-		if (ah->ah_config.ht_enable) {
+		if (ah->config.ht_enable) {
 			if (!(eeval & AR5416_OPFLAGS_N_2G_HT20))
 				set_bit(ATH9K_MODE_11NG_HT20,
 					pCap->wireless_modes);
@@ -3147,7 +3147,7 @@ bool ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	}
 
 	pCap->tx_chainmask = ah->eep_ops->get_eeprom(ah, EEP_TX_MASK);
-	if ((ah->ah_isPciExpress)
+	if ((ah->is_pciexpress)
 	    || (eeval & AR5416_OPFLAGS_11A)) {
 		pCap->rx_chainmask =
 			ah->eep_ops->get_eeprom(ah, EEP_RX_MASK);
@@ -3157,7 +3157,7 @@ bool ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	}
 
 	if (!(AR_SREV_9280(ah) && (ah->hw_version.macRev == 0)))
-		ah->ah_miscMode |= AR_PCU_MIC_NEW_LOC_ENA;
+		ah->misc_mode |= AR_PCU_MIC_NEW_LOC_ENA;
 
 	pCap->low_2ghz_chan = 2312;
 	pCap->high_2ghz_chan = 2732;
@@ -3175,7 +3175,7 @@ bool ath9k_hw_fill_cap_info(struct ath_hw *ah)
 
 	pCap->hw_caps |= ATH9K_HW_CAP_CHAN_SPREAD;
 
-	if (ah->ah_config.ht_enable)
+	if (ah->config.ht_enable)
 		pCap->hw_caps |= ATH9K_HW_CAP_HT;
 	else
 		pCap->hw_caps &= ~ATH9K_HW_CAP_HT;
@@ -3226,12 +3226,12 @@ bool ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	pCap->hw_caps |= ATH9K_HW_CAP_ENHANCEDPM;
 
 #if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
-	ah->ah_rfsilent = ah->eep_ops->get_eeprom(ah, EEP_RF_SILENT);
-	if (ah->ah_rfsilent & EEP_RFSILENT_ENABLED) {
-		ah->ah_rfkill_gpio =
-			MS(ah->ah_rfsilent, EEP_RFSILENT_GPIO_SEL);
-		ah->ah_rfkill_polarity =
-			MS(ah->ah_rfsilent, EEP_RFSILENT_POLARITY);
+	ah->rfsilent = ah->eep_ops->get_eeprom(ah, EEP_RF_SILENT);
+	if (ah->rfsilent & EEP_RFSILENT_ENABLED) {
+		ah->rfkill_gpio =
+			MS(ah->rfsilent, EEP_RFSILENT_GPIO_SEL);
+		ah->rfkill_polarity =
+			MS(ah->rfsilent, EEP_RFSILENT_POLARITY);
 
 		pCap->hw_caps |= ATH9K_HW_CAP_RFSILENT;
 	}
@@ -3272,8 +3272,8 @@ bool ath9k_hw_fill_cap_info(struct ath_hw *ah)
 
 	if (AR_SREV_9280_10_OR_LATER(ah) && btcoex_enable) {
 		pCap->hw_caps |= ATH9K_HW_CAP_BT_COEX;
-		ah->ah_btactive_gpio = 6;
-		ah->ah_wlanactive_gpio = 5;
+		ah->btactive_gpio = 6;
+		ah->wlanactive_gpio = 5;
 	}
 
 	return true;
@@ -3282,7 +3282,7 @@ bool ath9k_hw_fill_cap_info(struct ath_hw *ah)
 bool ath9k_hw_getcapability(struct ath_hw *ah, enum ath9k_capability_type type,
 			    u32 capability, u32 *result)
 {
-	const struct ath9k_hw_capabilities *pCap = &ah->ah_caps;
+	const struct ath9k_hw_capabilities *pCap = &ah->caps;
 
 	switch (type) {
 	case ATH9K_CAP_CIPHER:
@@ -3302,17 +3302,17 @@ bool ath9k_hw_getcapability(struct ath_hw *ah, enum ath9k_capability_type type,
 		case 0:
 			return true;
 		case 1:
-			return (ah->ah_staId1Defaults &
+			return (ah->sta_id1_defaults &
 				AR_STA_ID1_CRPT_MIC_ENABLE) ? true :
 			false;
 		}
 	case ATH9K_CAP_TKIP_SPLIT:
-		return (ah->ah_miscMode & AR_PCU_MIC_NEW_LOC_ENA) ?
+		return (ah->misc_mode & AR_PCU_MIC_NEW_LOC_ENA) ?
 			false : true;
 	case ATH9K_CAP_WME_TKIPMIC:
 		return 0;
 	case ATH9K_CAP_PHYCOUNTERS:
-		return ah->ah_hasHwPhyCounters ? 0 : -ENXIO;
+		return ah->has_hw_phycounters ? 0 : -ENXIO;
 	case ATH9K_CAP_DIVERSITY:
 		return (REG_READ(ah, AR_PHY_CCK_DETECT) &
 			AR_PHY_CCK_DETECT_BB_ENABLE_ANT_FAST_DIV) ?
@@ -3327,14 +3327,14 @@ bool ath9k_hw_getcapability(struct ath_hw *ah, enum ath9k_capability_type type,
 			if (REG_READ(ah, AR_STA_ID1) & AR_STA_ID1_ADHOC) {
 				return false;
 			} else {
-				return (ah->ah_staId1Defaults &
+				return (ah->sta_id1_defaults &
 					AR_STA_ID1_MCAST_KSRCH) ? true :
 					false;
 			}
 		}
 		return false;
 	case ATH9K_CAP_TSF_ADJUST:
-		return (ah->ah_miscMode & AR_PCU_TX_ADD_TSF) ?
+		return (ah->misc_mode & AR_PCU_TX_ADD_TSF) ?
 			true : false;
 	case ATH9K_CAP_RFSILENT:
 		if (capability == 3)
@@ -3373,10 +3373,10 @@ bool ath9k_hw_setcapability(struct ath_hw *ah, enum ath9k_capability_type type,
 	switch (type) {
 	case ATH9K_CAP_TKIP_MIC:
 		if (setting)
-			ah->ah_staId1Defaults |=
+			ah->sta_id1_defaults |=
 				AR_STA_ID1_CRPT_MIC_ENABLE;
 		else
-			ah->ah_staId1Defaults &=
+			ah->sta_id1_defaults &=
 				~AR_STA_ID1_CRPT_MIC_ENABLE;
 		return true;
 	case ATH9K_CAP_DIVERSITY:
@@ -3389,15 +3389,15 @@ bool ath9k_hw_setcapability(struct ath_hw *ah, enum ath9k_capability_type type,
 		return true;
 	case ATH9K_CAP_MCAST_KEYSRCH:
 		if (setting)
-			ah->ah_staId1Defaults |= AR_STA_ID1_MCAST_KSRCH;
+			ah->sta_id1_defaults |= AR_STA_ID1_MCAST_KSRCH;
 		else
-			ah->ah_staId1Defaults &= ~AR_STA_ID1_MCAST_KSRCH;
+			ah->sta_id1_defaults &= ~AR_STA_ID1_MCAST_KSRCH;
 		return true;
 	case ATH9K_CAP_TSF_ADJUST:
 		if (setting)
-			ah->ah_miscMode |= AR_PCU_TX_ADD_TSF;
+			ah->misc_mode |= AR_PCU_TX_ADD_TSF;
 		else
-			ah->ah_miscMode &= ~AR_PCU_TX_ADD_TSF;
+			ah->misc_mode &= ~AR_PCU_TX_ADD_TSF;
 		return true;
 	default:
 		return false;
@@ -3440,7 +3440,7 @@ void ath9k_hw_cfg_gpio_input(struct ath_hw *ah, u32 gpio)
 {
 	u32 gpio_shift;
 
-	ASSERT(gpio < ah->ah_caps.num_gpio_pins);
+	ASSERT(gpio < ah->caps.num_gpio_pins);
 
 	gpio_shift = gpio << 1;
 
@@ -3455,7 +3455,7 @@ u32 ath9k_hw_gpio_get(struct ath_hw *ah, u32 gpio)
 #define MS_REG_READ(x, y) \
 	(MS(REG_READ(ah, AR_GPIO_IN_OUT), x##_GPIO_IN_VAL) & (AR_GPIO_BIT(y)))
 
-	if (gpio >= ah->ah_caps.num_gpio_pins)
+	if (gpio >= ah->caps.num_gpio_pins)
 		return 0xffffffff;
 
 	if (AR_SREV_9285_10_OR_LATER(ah))
@@ -3496,7 +3496,7 @@ void ath9k_enable_rfkill(struct ath_hw *ah)
 	REG_CLR_BIT(ah, AR_GPIO_INPUT_MUX2,
 		    AR_GPIO_INPUT_MUX2_RFSILENT);
 
-	ath9k_hw_cfg_gpio_input(ah, ah->ah_rfkill_gpio);
+	ath9k_hw_cfg_gpio_input(ah, ah->rfkill_gpio);
 	REG_SET_BIT(ah, AR_PHY_TEST, RFSILENT_BB);
 }
 #endif
@@ -3534,7 +3534,7 @@ bool ath9k_hw_setantennaswitch(struct ath_hw *ah,
 			*antenna_cfgd = true;
 			break;
 		case ATH9K_ANT_FIXED_B:
-			if (ah->ah_caps.tx_chainmask >
+			if (ah->caps.tx_chainmask >
 			    ATH9K_ANTENNA1_CHAINMASK) {
 				*tx_chainmask = ATH9K_ANTENNA1_CHAINMASK;
 			}
@@ -3550,7 +3550,7 @@ bool ath9k_hw_setantennaswitch(struct ath_hw *ah,
 			break;
 		}
 	} else {
-		ah->ah_diversityControl = settings;
+		ah->diversity_control = settings;
 	}
 
 	return true;
@@ -3608,7 +3608,7 @@ bool ath9k_hw_disable(struct ath_hw *ah)
 
 bool ath9k_hw_set_txpowerlimit(struct ath_hw *ah, u32 limit)
 {
-	struct ath9k_channel *chan = ah->ah_curchan;
+	struct ath9k_channel *chan = ah->curchan;
 	struct ieee80211_channel *channel = chan->chan;
 
 	ah->regulatory.power_limit = min(limit, (u32) MAX_RATE_POWER);
@@ -3631,7 +3631,7 @@ void ath9k_hw_setmac(struct ath_hw *ah, const u8 *mac)
 
 void ath9k_hw_setopmode(struct ath_hw *ah)
 {
-	ath9k_hw_set_operating_mode(ah, ah->ah_opmode);
+	ath9k_hw_set_operating_mode(ah, ah->opmode);
 }
 
 void ath9k_hw_setmcastfilter(struct ath_hw *ah, u32 filter0, u32 filter1)
@@ -3690,9 +3690,9 @@ void ath9k_hw_reset_tsf(struct ath_hw *ah)
 bool ath9k_hw_set_tsfadjust(struct ath_hw *ah, u32 setting)
 {
 	if (setting)
-		ah->ah_miscMode |= AR_PCU_TX_ADD_TSF;
+		ah->misc_mode |= AR_PCU_TX_ADD_TSF;
 	else
-		ah->ah_miscMode &= ~AR_PCU_TX_ADD_TSF;
+		ah->misc_mode &= ~AR_PCU_TX_ADD_TSF;
 
 	return true;
 }
@@ -3701,11 +3701,11 @@ bool ath9k_hw_setslottime(struct ath_hw *ah, u32 us)
 {
 	if (us < ATH9K_SLOT_TIME_9 || us > ath9k_hw_mac_to_usec(ah, 0xffff)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_RESET, "bad slot time %u\n", us);
-		ah->ah_slottime = (u32) -1;
+		ah->slottime = (u32) -1;
 		return false;
 	} else {
 		REG_WRITE(ah, AR_D_GBL_IFS_SLOT, ath9k_hw_mac_to_clks(ah, us));
-		ah->ah_slottime = us;
+		ah->slottime = us;
 		return true;
 	}
 }
@@ -3715,7 +3715,7 @@ void ath9k_hw_set11nmac2040(struct ath_hw *ah, enum ath9k_ht_macmode mode)
 	u32 macmode;
 
 	if (mode == ATH9K_HT_MACMODE_2040 &&
-	    !ah->ah_config.cwm_ignore_extcca)
+	    !ah->config.cwm_ignore_extcca)
 		macmode = AR_2040_JOINED_RX_CLEAR;
 	else
 		macmode = 0;
@@ -3740,12 +3740,12 @@ void ath9k_hw_btcoex_enable(struct ath_hw *ah)
 	/* Set input mux for bt_active to gpio pin */
 	REG_RMW_FIELD(ah, AR_GPIO_INPUT_MUX1,
 			AR_GPIO_INPUT_MUX1_BT_ACTIVE,
-			ah->ah_btactive_gpio);
+			ah->btactive_gpio);
 
 	/* Configure the desired gpio port for input */
-	ath9k_hw_cfg_gpio_input(ah, ah->ah_btactive_gpio);
+	ath9k_hw_cfg_gpio_input(ah, ah->btactive_gpio);
 
 	/* Configure the desired GPIO port for TX_FRAME output */
-	ath9k_hw_cfg_output(ah, ah->ah_wlanactive_gpio,
+	ath9k_hw_cfg_output(ah, ah->wlanactive_gpio,
 			    AR_GPIO_OUTPUT_MUX_AS_TX_FRAME);
 }
diff --git a/drivers/net/wireless/ath9k/hw.h b/drivers/net/wireless/ath9k/hw.h
index f8f46db..8211163 100644
--- a/drivers/net/wireless/ath9k/hw.h
+++ b/drivers/net/wireless/ath9k/hw.h
@@ -420,152 +420,148 @@ struct ath9k_hw_version {
 struct ath_hw {
 	struct ath_softc *ah_sc;
 	struct ath9k_hw_version hw_version;
-	struct ath9k_ops_config ah_config;
-	struct ath9k_hw_capabilities ah_caps;
+	struct ath9k_ops_config config;
+	struct ath9k_hw_capabilities caps;
 	struct ath9k_regulatory regulatory;
-	struct ath9k_channel ah_channels[38];
-	struct ath9k_channel *ah_curchan;
+	struct ath9k_channel channels[38];
+	struct ath9k_channel *curchan;
 
 	union {
 		struct ar5416_eeprom_def def;
 		struct ar5416_eeprom_4k map4k;
-	} ah_eeprom;
+	} eeprom;
 	const struct eeprom_ops *eep_ops;
+	enum ath9k_eep_map eep_map;
 
 	bool sw_mgmt_crypto;
-	bool ah_isPciExpress;
+	bool is_pciexpress;
 	u8 macaddr[ETH_ALEN];
-	u16 ah_txTrigLevel;
-	u16 ah_rfsilent;
-	u32 ah_rfkill_gpio;
-	u32 ah_rfkill_polarity;
-	u32 ah_btactive_gpio;
-	u32 ah_wlanactive_gpio;
+	u16 tx_trig_level;
+	u16 rfsilent;
+	u32 rfkill_gpio;
+	u32 rfkill_polarity;
+	u32 btactive_gpio;
+	u32 wlanactive_gpio;
 	u32 ah_flags;
-	enum nl80211_iftype ah_opmode;
 
-	enum ath9k_power_mode ah_power_mode;
-	enum ath9k_power_mode ah_restore_mode;
+	enum nl80211_iftype opmode;
+	enum ath9k_power_mode power_mode;
+	enum ath9k_power_mode restore_mode;
 
 	struct ath9k_nfcal_hist nfCalHist[NUM_NF_READINGS];
-	struct ar5416Stats ah_stats;
-	struct ath9k_tx_queue_info ah_txq[ATH9K_NUM_TX_QUEUES];
-
-	int16_t ah_curchanRadIndex;
-	u32 ah_maskReg;
-	u32 ah_txOkInterruptMask;
-	u32 ah_txErrInterruptMask;
-	u32 ah_txDescInterruptMask;
-	u32 ah_txEolInterruptMask;
-	u32 ah_txUrnInterruptMask;
-	bool ah_chipFullSleep;
-	u32 ah_atimWindow;
-	u16 ah_antennaSwitchSwap;
-	enum ath9k_ant_setting ah_diversityControl;
+	struct ar5416Stats stats;
+	struct ath9k_tx_queue_info txq[ATH9K_NUM_TX_QUEUES];
+
+	int16_t curchan_rad_index;
+	u32 mask_reg;
+	u32 txok_interrupt_mask;
+	u32 txerr_interrupt_mask;
+	u32 txdesc_interrupt_mask;
+	u32 txeol_interrupt_mask;
+	u32 txurn_interrupt_mask;
+	bool chip_fullsleep;
+	u32 atim_window;
+	u16 antenna_switch_swap;
+	enum ath9k_ant_setting diversity_control;
 
 	/* Calibration */
-	enum hal_cal_types ah_suppCals;
-	struct hal_cal_list ah_iqCalData;
-	struct hal_cal_list ah_adcGainCalData;
-	struct hal_cal_list ah_adcDcCalInitData;
-	struct hal_cal_list ah_adcDcCalData;
-	struct hal_cal_list *ah_cal_list;
-	struct hal_cal_list *ah_cal_list_last;
-	struct hal_cal_list *ah_cal_list_curr;
-#define ah_totalPowerMeasI ah_Meas0.unsign
-#define ah_totalPowerMeasQ ah_Meas1.unsign
-#define ah_totalIqCorrMeas ah_Meas2.sign
-#define ah_totalAdcIOddPhase  ah_Meas0.unsign
-#define ah_totalAdcIEvenPhase ah_Meas1.unsign
-#define ah_totalAdcQOddPhase  ah_Meas2.unsign
-#define ah_totalAdcQEvenPhase ah_Meas3.unsign
-#define ah_totalAdcDcOffsetIOddPhase  ah_Meas0.sign
-#define ah_totalAdcDcOffsetIEvenPhase ah_Meas1.sign
-#define ah_totalAdcDcOffsetQOddPhase  ah_Meas2.sign
-#define ah_totalAdcDcOffsetQEvenPhase ah_Meas3.sign
+	enum hal_cal_types supp_cals;
+	struct hal_cal_list iq_caldata;
+	struct hal_cal_list adcgain_caldata;
+	struct hal_cal_list adcdc_calinitdata;
+	struct hal_cal_list adcdc_caldata;
+	struct hal_cal_list *cal_list;
+	struct hal_cal_list *cal_list_last;
+	struct hal_cal_list *cal_list_curr;
+#define totalPowerMeasI meas0.unsign
+#define totalPowerMeasQ meas1.unsign
+#define totalIqCorrMeas meas2.sign
+#define totalAdcIOddPhase  meas0.unsign
+#define totalAdcIEvenPhase meas1.unsign
+#define totalAdcQOddPhase  meas2.unsign
+#define totalAdcQEvenPhase meas3.unsign
+#define totalAdcDcOffsetIOddPhase  meas0.sign
+#define totalAdcDcOffsetIEvenPhase meas1.sign
+#define totalAdcDcOffsetQOddPhase  meas2.sign
+#define totalAdcDcOffsetQEvenPhase meas3.sign
 	union {
 		u32 unsign[AR5416_MAX_CHAINS];
 		int32_t sign[AR5416_MAX_CHAINS];
-	} ah_Meas0;
+	} meas0;
 	union {
 		u32 unsign[AR5416_MAX_CHAINS];
 		int32_t sign[AR5416_MAX_CHAINS];
-	} ah_Meas1;
+	} meas1;
 	union {
 		u32 unsign[AR5416_MAX_CHAINS];
 		int32_t sign[AR5416_MAX_CHAINS];
-	} ah_Meas2;
+	} meas2;
 	union {
 		u32 unsign[AR5416_MAX_CHAINS];
 		int32_t sign[AR5416_MAX_CHAINS];
-	} ah_Meas3;
-	u16 ah_CalSamples;
+	} meas3;
+	u16 cal_samples;
 
-	u32 ah_staId1Defaults;
-	u32 ah_miscMode;
+	u32 sta_id1_defaults;
+	u32 misc_mode;
 	enum {
 		AUTO_32KHZ,
 		USE_32KHZ,
 		DONT_USE_32KHZ,
-	} ah_enable32kHzClock;
+	} enable_32kHz_clock;
 
 	/* RF */
-	u32 *ah_analogBank0Data;
-	u32 *ah_analogBank1Data;
-	u32 *ah_analogBank2Data;
-	u32 *ah_analogBank3Data;
-	u32 *ah_analogBank6Data;
-	u32 *ah_analogBank6TPCData;
-	u32 *ah_analogBank7Data;
-	u32 *ah_addac5416_21;
-	u32 *ah_bank6Temp;
-
-	int16_t ah_txPowerIndexOffset;
-	u32 ah_beaconInterval;
-	u32 ah_slottime;
-	u32 ah_acktimeout;
-	u32 ah_ctstimeout;
-	u32 ah_globaltxtimeout;
-	u8 ah_gBeaconRate;
-	u32 ah_gpioSelect;
-	u32 ah_polarity;
-	u32 ah_gpioBit;
+	u32 *analogBank0Data;
+	u32 *analogBank1Data;
+	u32 *analogBank2Data;
+	u32 *analogBank3Data;
+	u32 *analogBank6Data;
+	u32 *analogBank6TPCData;
+	u32 *analogBank7Data;
+	u32 *addac5416_21;
+	u32 *bank6Temp;
+
+	int16_t txpower_indexoffset;
+	u32 beacon_interval;
+	u32 slottime;
+	u32 acktimeout;
+	u32 ctstimeout;
+	u32 globaltxtimeout;
+	u8 gbeacon_rate;
 
 	/* ANI */
-	u32 ah_procPhyErr;
-	bool ah_hasHwPhyCounters;
-	u32 ah_aniPeriod;
-	struct ar5416AniState *ah_curani;
-	struct ar5416AniState ah_ani[255];
-	int ah_totalSizeDesired[5];
-	int ah_coarseHigh[5];
-	int ah_coarseLow[5];
-	int ah_firpwr[5];
-	enum ath9k_ani_cmd ah_ani_function;
-
-	u32 ah_intrTxqs;
-	bool ah_intrMitigation;
-	enum ath9k_ht_extprotspacing ah_extprotspacing;
-	u8 ah_txchainmask;
-	u8 ah_rxchainmask;
-
-	struct ar5416IniArray ah_iniModes;
-	struct ar5416IniArray ah_iniCommon;
-	struct ar5416IniArray ah_iniBank0;
-	struct ar5416IniArray ah_iniBB_RfGain;
-	struct ar5416IniArray ah_iniBank1;
-	struct ar5416IniArray ah_iniBank2;
-	struct ar5416IniArray ah_iniBank3;
-	struct ar5416IniArray ah_iniBank6;
-	struct ar5416IniArray ah_iniBank6TPC;
-	struct ar5416IniArray ah_iniBank7;
-	struct ar5416IniArray ah_iniAddac;
-	struct ar5416IniArray ah_iniPcieSerdes;
-	struct ar5416IniArray ah_iniModesAdditional;
-	struct ar5416IniArray ah_iniModesRxGain;
-	struct ar5416IniArray ah_iniModesTxGain;
-	/* To indicate EEPROM mapping used */
-	enum hal_eep_map ah_eep_map;
+	u32 proc_phyerr;
+	bool has_hw_phycounters;
+	u32 aniperiod;
+	struct ar5416AniState *curani;
+	struct ar5416AniState ani[255];
+	int totalSizeDesired[5];
+	int coarse_high[5];
+	int coarse_low[5];
+	int firpwr[5];
+	enum ath9k_ani_cmd ani_function;
+
+	u32 intr_txqs;
+	bool intr_mitigation;
+	enum ath9k_ht_extprotspacing extprotspacing;
+	u8 txchainmask;
+	u8 rxchainmask;
+
+	struct ar5416IniArray iniModes;
+	struct ar5416IniArray iniCommon;
+	struct ar5416IniArray iniBank0;
+	struct ar5416IniArray iniBB_RfGain;
+	struct ar5416IniArray iniBank1;
+	struct ar5416IniArray iniBank2;
+	struct ar5416IniArray iniBank3;
+	struct ar5416IniArray iniBank6;
+	struct ar5416IniArray iniBank6TPC;
+	struct ar5416IniArray iniBank7;
+	struct ar5416IniArray iniAddac;
+	struct ar5416IniArray iniPcieSerdes;
+	struct ar5416IniArray iniModesAdditional;
+	struct ar5416IniArray iniModesRxGain;
+	struct ar5416IniArray iniModesTxGain;
 };
 
 /* Attach, Detach, Reset */
diff --git a/drivers/net/wireless/ath9k/mac.c b/drivers/net/wireless/ath9k/mac.c
index ac20714..f32c622 100644
--- a/drivers/net/wireless/ath9k/mac.c
+++ b/drivers/net/wireless/ath9k/mac.c
@@ -21,18 +21,18 @@ static void ath9k_hw_set_txq_interrupts(struct ath_hw *ah,
 {
 	DPRINTF(ah->ah_sc, ATH_DBG_INTERRUPT,
 		"tx ok 0x%x err 0x%x desc 0x%x eol 0x%x urn 0x%x\n",
-		ah->ah_txOkInterruptMask, ah->ah_txErrInterruptMask,
-		ah->ah_txDescInterruptMask, ah->ah_txEolInterruptMask,
-		ah->ah_txUrnInterruptMask);
+		ah->txok_interrupt_mask, ah->txerr_interrupt_mask,
+		ah->txdesc_interrupt_mask, ah->txeol_interrupt_mask,
+		ah->txurn_interrupt_mask);
 
 	REG_WRITE(ah, AR_IMR_S0,
-		  SM(ah->ah_txOkInterruptMask, AR_IMR_S0_QCU_TXOK)
-		  | SM(ah->ah_txDescInterruptMask, AR_IMR_S0_QCU_TXDESC));
+		  SM(ah->txok_interrupt_mask, AR_IMR_S0_QCU_TXOK)
+		  | SM(ah->txdesc_interrupt_mask, AR_IMR_S0_QCU_TXDESC));
 	REG_WRITE(ah, AR_IMR_S1,
-		  SM(ah->ah_txErrInterruptMask, AR_IMR_S1_QCU_TXERR)
-		  | SM(ah->ah_txEolInterruptMask, AR_IMR_S1_QCU_TXEOL));
+		  SM(ah->txerr_interrupt_mask, AR_IMR_S1_QCU_TXERR)
+		  | SM(ah->txeol_interrupt_mask, AR_IMR_S1_QCU_TXEOL));
 	REG_RMW_FIELD(ah, AR_IMR_S2,
-		      AR_IMR_S2_QCU_TXURN, ah->ah_txUrnInterruptMask);
+		      AR_IMR_S2_QCU_TXURN, ah->txurn_interrupt_mask);
 }
 
 u32 ath9k_hw_gettxbuf(struct ath_hw *ah, u32 q)
@@ -75,10 +75,10 @@ bool ath9k_hw_updatetxtriglevel(struct ath_hw *ah, bool bIncTrigLevel)
 	u32 txcfg, curLevel, newLevel;
 	enum ath9k_int omask;
 
-	if (ah->ah_txTrigLevel >= MAX_TX_FIFO_THRESHOLD)
+	if (ah->tx_trig_level >= MAX_TX_FIFO_THRESHOLD)
 		return false;
 
-	omask = ath9k_hw_set_interrupts(ah, ah->ah_maskReg & ~ATH9K_INT_GLOBAL);
+	omask = ath9k_hw_set_interrupts(ah, ah->mask_reg & ~ATH9K_INT_GLOBAL);
 
 	txcfg = REG_READ(ah, AR_TXCFG);
 	curLevel = MS(txcfg, AR_FTRIG);
@@ -94,7 +94,7 @@ bool ath9k_hw_updatetxtriglevel(struct ath_hw *ah, bool bIncTrigLevel)
 
 	ath9k_hw_set_interrupts(ah, omask);
 
-	ah->ah_txTrigLevel = newLevel;
+	ah->tx_trig_level = newLevel;
 
 	return newLevel != curLevel;
 }
@@ -104,7 +104,7 @@ bool ath9k_hw_stoptxdma(struct ath_hw *ah, u32 q)
 #define ATH9K_TX_STOP_DMA_TIMEOUT	4000    /* usec */
 #define ATH9K_TIME_QUANTUM		100     /* usec */
 
-	struct ath9k_hw_capabilities *pCap = &ah->ah_caps;
+	struct ath9k_hw_capabilities *pCap = &ah->caps;
 	struct ath9k_tx_queue_info *qi;
 	u32 tsfLow, j, wait;
 	u32 wait_time = ATH9K_TX_STOP_DMA_TIMEOUT / ATH9K_TIME_QUANTUM;
@@ -114,7 +114,7 @@ bool ath9k_hw_stoptxdma(struct ath_hw *ah, u32 q)
 		return false;
 	}
 
-	qi = &ah->ah_txq[q];
+	qi = &ah->txq[q];
 	if (qi->tqi_type == ATH9K_TX_QUEUE_INACTIVE) {
 		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "inactive queue\n");
 		return false;
@@ -296,7 +296,7 @@ void ath9k_hw_set11n_txdesc(struct ath_hw *ah, struct ath_desc *ds,
 {
 	struct ar5416_desc *ads = AR5416DESC(ds);
 
-	txPower += ah->ah_txPowerIndexOffset;
+	txPower += ah->txpower_indexoffset;
 	if (txPower > 63)
 		txPower = 63;
 
@@ -442,15 +442,15 @@ void ath9k_hw_set11n_virtualmorefrag(struct ath_hw *ah, struct ath_desc *ds,
 
 void ath9k_hw_gettxintrtxqs(struct ath_hw *ah, u32 *txqs)
 {
-	*txqs &= ah->ah_intrTxqs;
-	ah->ah_intrTxqs &= ~(*txqs);
+	*txqs &= ah->intr_txqs;
+	ah->intr_txqs &= ~(*txqs);
 }
 
 bool ath9k_hw_set_txq_props(struct ath_hw *ah, int q,
 			    const struct ath9k_tx_queue_info *qinfo)
 {
 	u32 cw;
-	struct ath9k_hw_capabilities *pCap = &ah->ah_caps;
+	struct ath9k_hw_capabilities *pCap = &ah->caps;
 	struct ath9k_tx_queue_info *qi;
 
 	if (q >= pCap->total_queues) {
@@ -458,7 +458,7 @@ bool ath9k_hw_set_txq_props(struct ath_hw *ah, int q,
 		return false;
 	}
 
-	qi = &ah->ah_txq[q];
+	qi = &ah->txq[q];
 	if (qi->tqi_type == ATH9K_TX_QUEUE_INACTIVE) {
 		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "inactive queue\n");
 		return false;
@@ -517,7 +517,7 @@ bool ath9k_hw_set_txq_props(struct ath_hw *ah, int q,
 bool ath9k_hw_get_txq_props(struct ath_hw *ah, int q,
 			    struct ath9k_tx_queue_info *qinfo)
 {
-	struct ath9k_hw_capabilities *pCap = &ah->ah_caps;
+	struct ath9k_hw_capabilities *pCap = &ah->caps;
 	struct ath9k_tx_queue_info *qi;
 
 	if (q >= pCap->total_queues) {
@@ -525,7 +525,7 @@ bool ath9k_hw_get_txq_props(struct ath_hw *ah, int q,
 		return false;
 	}
 
-	qi = &ah->ah_txq[q];
+	qi = &ah->txq[q];
 	if (qi->tqi_type == ATH9K_TX_QUEUE_INACTIVE) {
 		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "inactive queue\n");
 		return false;
@@ -553,7 +553,7 @@ int ath9k_hw_setuptxqueue(struct ath_hw *ah, enum ath9k_tx_queue type,
 			  const struct ath9k_tx_queue_info *qinfo)
 {
 	struct ath9k_tx_queue_info *qi;
-	struct ath9k_hw_capabilities *pCap = &ah->ah_caps;
+	struct ath9k_hw_capabilities *pCap = &ah->caps;
 	int q;
 
 	switch (type) {
@@ -571,7 +571,7 @@ int ath9k_hw_setuptxqueue(struct ath_hw *ah, enum ath9k_tx_queue type,
 		break;
 	case ATH9K_TX_QUEUE_DATA:
 		for (q = 0; q < pCap->total_queues; q++)
-			if (ah->ah_txq[q].tqi_type ==
+			if (ah->txq[q].tqi_type ==
 			    ATH9K_TX_QUEUE_INACTIVE)
 				break;
 		if (q == pCap->total_queues) {
@@ -587,7 +587,7 @@ int ath9k_hw_setuptxqueue(struct ath_hw *ah, enum ath9k_tx_queue type,
 
 	DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "queue %u\n", q);
 
-	qi = &ah->ah_txq[q];
+	qi = &ah->txq[q];
 	if (qi->tqi_type != ATH9K_TX_QUEUE_INACTIVE) {
 		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE,
 			"tx queue %u already active\n", q);
@@ -616,14 +616,14 @@ int ath9k_hw_setuptxqueue(struct ath_hw *ah, enum ath9k_tx_queue type,
 
 bool ath9k_hw_releasetxqueue(struct ath_hw *ah, u32 q)
 {
-	struct ath9k_hw_capabilities *pCap = &ah->ah_caps;
+	struct ath9k_hw_capabilities *pCap = &ah->caps;
 	struct ath9k_tx_queue_info *qi;
 
 	if (q >= pCap->total_queues) {
 		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "invalid queue num %u\n", q);
 		return false;
 	}
-	qi = &ah->ah_txq[q];
+	qi = &ah->txq[q];
 	if (qi->tqi_type == ATH9K_TX_QUEUE_INACTIVE) {
 		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "inactive queue %u\n", q);
 		return false;
@@ -632,11 +632,11 @@ bool ath9k_hw_releasetxqueue(struct ath_hw *ah, u32 q)
 	DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "release queue %u\n", q);
 
 	qi->tqi_type = ATH9K_TX_QUEUE_INACTIVE;
-	ah->ah_txOkInterruptMask &= ~(1 << q);
-	ah->ah_txErrInterruptMask &= ~(1 << q);
-	ah->ah_txDescInterruptMask &= ~(1 << q);
-	ah->ah_txEolInterruptMask &= ~(1 << q);
-	ah->ah_txUrnInterruptMask &= ~(1 << q);
+	ah->txok_interrupt_mask &= ~(1 << q);
+	ah->txerr_interrupt_mask &= ~(1 << q);
+	ah->txdesc_interrupt_mask &= ~(1 << q);
+	ah->txeol_interrupt_mask &= ~(1 << q);
+	ah->txurn_interrupt_mask &= ~(1 << q);
 	ath9k_hw_set_txq_interrupts(ah, qi);
 
 	return true;
@@ -644,8 +644,8 @@ bool ath9k_hw_releasetxqueue(struct ath_hw *ah, u32 q)
 
 bool ath9k_hw_resettxqueue(struct ath_hw *ah, u32 q)
 {
-	struct ath9k_hw_capabilities *pCap = &ah->ah_caps;
-	struct ath9k_channel *chan = ah->ah_curchan;
+	struct ath9k_hw_capabilities *pCap = &ah->caps;
+	struct ath9k_channel *chan = ah->curchan;
 	struct ath9k_tx_queue_info *qi;
 	u32 cwMin, chanCwMin, value;
 
@@ -654,7 +654,7 @@ bool ath9k_hw_resettxqueue(struct ath_hw *ah, u32 q)
 		return false;
 	}
 
-	qi = &ah->ah_txq[q];
+	qi = &ah->txq[q];
 	if (qi->tqi_type == ATH9K_TX_QUEUE_INACTIVE) {
 		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "inactive queue %u\n", q);
 		return true;
@@ -742,9 +742,9 @@ bool ath9k_hw_resettxqueue(struct ath_hw *ah, u32 q)
 			  | AR_Q_MISC_CBR_INCR_DIS1
 			  | AR_Q_MISC_CBR_INCR_DIS0);
 		value = (qi->tqi_readyTime -
-			 (ah->ah_config.sw_beacon_response_time -
-			  ah->ah_config.dma_beacon_response_time) -
-			 ah->ah_config.additional_swba_backoff) * 1024;
+			 (ah->config.sw_beacon_response_time -
+			  ah->config.dma_beacon_response_time) -
+			 ah->config.additional_swba_backoff) * 1024;
 		REG_WRITE(ah, AR_QRDYTIMECFG(q),
 			  value | AR_Q_RDYTIMECFG_EN);
 		REG_WRITE(ah, AR_DMISC(q), REG_READ(ah, AR_DMISC(q))
@@ -772,25 +772,25 @@ bool ath9k_hw_resettxqueue(struct ath_hw *ah, u32 q)
 	}
 
 	if (qi->tqi_qflags & TXQ_FLAG_TXOKINT_ENABLE)
-		ah->ah_txOkInterruptMask |= 1 << q;
+		ah->txok_interrupt_mask |= 1 << q;
 	else
-		ah->ah_txOkInterruptMask &= ~(1 << q);
+		ah->txok_interrupt_mask &= ~(1 << q);
 	if (qi->tqi_qflags & TXQ_FLAG_TXERRINT_ENABLE)
-		ah->ah_txErrInterruptMask |= 1 << q;
+		ah->txerr_interrupt_mask |= 1 << q;
 	else
-		ah->ah_txErrInterruptMask &= ~(1 << q);
+		ah->txerr_interrupt_mask &= ~(1 << q);
 	if (qi->tqi_qflags & TXQ_FLAG_TXDESCINT_ENABLE)
-		ah->ah_txDescInterruptMask |= 1 << q;
+		ah->txdesc_interrupt_mask |= 1 << q;
 	else
-		ah->ah_txDescInterruptMask &= ~(1 << q);
+		ah->txdesc_interrupt_mask &= ~(1 << q);
 	if (qi->tqi_qflags & TXQ_FLAG_TXEOLINT_ENABLE)
-		ah->ah_txEolInterruptMask |= 1 << q;
+		ah->txeol_interrupt_mask |= 1 << q;
 	else
-		ah->ah_txEolInterruptMask &= ~(1 << q);
+		ah->txeol_interrupt_mask &= ~(1 << q);
 	if (qi->tqi_qflags & TXQ_FLAG_TXURNINT_ENABLE)
-		ah->ah_txUrnInterruptMask |= 1 << q;
+		ah->txurn_interrupt_mask |= 1 << q;
 	else
-		ah->ah_txUrnInterruptMask &= ~(1 << q);
+		ah->txurn_interrupt_mask &= ~(1 << q);
 	ath9k_hw_set_txq_interrupts(ah, qi);
 
 	return true;
@@ -865,7 +865,7 @@ bool ath9k_hw_setuprxdesc(struct ath_hw *ah, struct ath_desc *ds,
 			  u32 size, u32 flags)
 {
 	struct ar5416_desc *ads = AR5416DESC(ds);
-	struct ath9k_hw_capabilities *pCap = &ah->ah_caps;
+	struct ath9k_hw_capabilities *pCap = &ah->caps;
 
 	ads->ds_ctl1 = size & AR_BufLen;
 	if (flags & ATH9K_RXDESC_INTREQ)
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index a50f989..fc3460f 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -267,7 +267,7 @@ static int ath_set_channel(struct ath_softc *sc, struct ath9k_channel *hchan)
 
 	DPRINTF(sc, ATH_DBG_CONFIG,
 		"(%u MHz) -> (%u MHz), chanwidth: %d\n",
-		sc->sc_ah->ah_curchan->channel,
+		sc->sc_ah->curchan->channel,
 		channel->center_freq, sc->tx_chan_width);
 
 	spin_lock_bh(&sc->sc_resetlock);
@@ -363,30 +363,30 @@ static void ath_ani_calibrate(unsigned long data)
 		/* Call ANI routine if necessary */
 		if (aniflag)
 			ath9k_hw_ani_monitor(ah, &sc->nodestats,
-					     ah->ah_curchan);
+					     ah->curchan);
 
 		/* Perform calibration if necessary */
 		if (longcal || shortcal) {
 			bool iscaldone = false;
 
-			if (ath9k_hw_calibrate(ah, ah->ah_curchan,
+			if (ath9k_hw_calibrate(ah, ah->curchan,
 					       sc->rx_chainmask, longcal,
 					       &iscaldone)) {
 				if (longcal)
 					sc->ani.noise_floor =
 						ath9k_hw_getchan_noise(ah,
-							       ah->ah_curchan);
+							       ah->curchan);
 
 				DPRINTF(sc, ATH_DBG_ANI,
 					"calibrate chan %u/%x nf: %d\n",
-					ah->ah_curchan->channel,
-					ah->ah_curchan->channelFlags,
+					ah->curchan->channel,
+					ah->curchan->channelFlags,
 					sc->ani.noise_floor);
 			} else {
 				DPRINTF(sc, ATH_DBG_ANY,
 					"calibrate chan %u/%x failed\n",
-					ah->ah_curchan->channel,
-					ah->ah_curchan->channelFlags);
+					ah->curchan->channel,
+					ah->curchan->channelFlags);
 			}
 			sc->ani.caldone = iscaldone;
 		}
@@ -398,7 +398,7 @@ static void ath_ani_calibrate(unsigned long data)
 	* short calibration and long calibration.
 	*/
 	cal_interval = ATH_LONG_CALINTERVAL;
-	if (sc->sc_ah->ah_config.enable_ani)
+	if (sc->sc_ah->config.enable_ani)
 		cal_interval = min(cal_interval, (u32)ATH_ANI_POLLINTERVAL);
 	if (!sc->ani.caldone)
 		cal_interval = min(cal_interval, (u32)ATH_SHORT_CALINTERVAL);
@@ -416,9 +416,9 @@ static void ath_update_chainmask(struct ath_softc *sc, int is_ht)
 {
 	sc->sc_flags |= SC_OP_CHAINMASK_UPDATE;
 	if (is_ht ||
-	    (sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_BT_COEX)) {
-		sc->tx_chainmask = sc->sc_ah->ah_caps.tx_chainmask;
-		sc->rx_chainmask = sc->sc_ah->ah_caps.rx_chainmask;
+	    (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_BT_COEX)) {
+		sc->tx_chainmask = sc->sc_ah->caps.tx_chainmask;
+		sc->rx_chainmask = sc->sc_ah->caps.rx_chainmask;
 	} else {
 		sc->tx_chainmask = 1;
 		sc->rx_chainmask = 1;
@@ -564,7 +564,7 @@ irqreturn_t ath_isr(int irq, void *dev)
 				ath9k_hw_set_interrupts(ah, sc->imask);
 			}
 			if (status & ATH9K_INT_TIM_TIMER) {
-				if (!(ah->ah_caps.hw_caps &
+				if (!(ah->caps.hw_caps &
 				      ATH9K_HW_CAP_AUTOSLEEP)) {
 					/* Clear RxAbort bit so that we can
 					 * receive frames */
@@ -1098,7 +1098,7 @@ static void ath_radio_enable(struct ath_softc *sc)
 	ath9k_ps_wakeup(sc);
 	spin_lock_bh(&sc->sc_resetlock);
 
-	r = ath9k_hw_reset(ah, ah->ah_curchan, false);
+	r = ath9k_hw_reset(ah, ah->curchan, false);
 
 	if (r) {
 		DPRINTF(sc, ATH_DBG_FATAL,
@@ -1151,7 +1151,7 @@ static void ath_radio_disable(struct ath_softc *sc)
 	ath_flushrecv(sc);		/* flush recv queue */
 
 	spin_lock_bh(&sc->sc_resetlock);
-	r = ath9k_hw_reset(ah, ah->ah_curchan, false);
+	r = ath9k_hw_reset(ah, ah->curchan, false);
 	if (r) {
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"Unable to reset channel %u (%uMhz) "
@@ -1169,8 +1169,8 @@ static bool ath_is_rfkill_set(struct ath_softc *sc)
 {
 	struct ath_hw *ah = sc->sc_ah;
 
-	return ath9k_hw_gpio_get(ah, ah->ah_rfkill_gpio) ==
-				  ah->ah_rfkill_polarity;
+	return ath9k_hw_gpio_get(ah, ah->rfkill_gpio) ==
+				  ah->rfkill_polarity;
 }
 
 /* h/w rfkill poll function */
@@ -1267,7 +1267,7 @@ static int ath_init_sw_rfkill(struct ath_softc *sc)
 /* Deinitialize rfkill */
 static void ath_deinit_rfkill(struct ath_softc *sc)
 {
-	if (sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
+	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
 		cancel_delayed_work_sync(&sc->rf_kill.rfkill_poll);
 
 	if (sc->sc_flags & SC_OP_RFKILL_REGISTERED) {
@@ -1279,7 +1279,7 @@ static void ath_deinit_rfkill(struct ath_softc *sc)
 
 static int ath_start_rfkill_poll(struct ath_softc *sc)
 {
-	if (sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
+	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
 		queue_delayed_work(sc->hw->workqueue,
 				   &sc->rf_kill.rfkill_poll, 0);
 
@@ -1380,7 +1380,7 @@ static int ath_init(u16 devid, struct ath_softc *sc)
 	sc->sc_ah = ah;
 
 	/* Get the hardware key cache size. */
-	sc->keymax = ah->ah_caps.keycache_size;
+	sc->keymax = ah->caps.keycache_size;
 	if (sc->keymax > ATH_KEYMAX) {
 		DPRINTF(sc, ATH_DBG_KEYCACHE,
 			"Warning, using only %u entries in %u key cache\n",
@@ -1399,7 +1399,7 @@ static int ath_init(u16 devid, struct ath_softc *sc)
 		goto bad;
 
 	/* default to MONITOR mode */
-	sc->sc_ah->ah_opmode = NL80211_IFTYPE_MONITOR;
+	sc->sc_ah->opmode = NL80211_IFTYPE_MONITOR;
 
 	/* Setup rate tables */
 
@@ -1502,18 +1502,18 @@ static int ath_init(u16 devid, struct ath_softc *sc)
 	sc->config.txpowlimit = ATH_TXPOWER_MAX;
 
 	/* 11n Capabilities */
-	if (ah->ah_caps.hw_caps & ATH9K_HW_CAP_HT) {
+	if (ah->caps.hw_caps & ATH9K_HW_CAP_HT) {
 		sc->sc_flags |= SC_OP_TXAGGR;
 		sc->sc_flags |= SC_OP_RXAGGR;
 	}
 
-	sc->tx_chainmask = ah->ah_caps.tx_chainmask;
-	sc->rx_chainmask = ah->ah_caps.rx_chainmask;
+	sc->tx_chainmask = ah->caps.tx_chainmask;
+	sc->rx_chainmask = ah->caps.rx_chainmask;
 
 	ath9k_hw_setcapability(ah, ATH9K_CAP_DIVERSITY, 1, true, NULL);
 	sc->rx.defant = ath9k_hw_getdefantenna(ah);
 
-	if (ah->ah_caps.hw_caps & ATH9K_HW_CAP_BSSIDMASK) {
+	if (ah->caps.hw_caps & ATH9K_HW_CAP_BSSIDMASK) {
 		memcpy(sc->bssidmask, ath_bcast_mac, ETH_ALEN);
 		ATH_SET_VIF_BSSID_MASK(sc->bssidmask);
 		ath9k_hw_setbssidmask(sc);
@@ -1537,7 +1537,7 @@ static int ath_init(u16 devid, struct ath_softc *sc)
 	sc->sbands[IEEE80211_BAND_2GHZ].n_channels =
 		ARRAY_SIZE(ath9k_2ghz_chantable);
 
-	if (test_bit(ATH9K_MODE_11A, sc->sc_ah->ah_caps.wireless_modes)) {
+	if (test_bit(ATH9K_MODE_11A, sc->sc_ah->caps.wireless_modes)) {
 		sc->sbands[IEEE80211_BAND_5GHZ].channels = ath9k_5ghz_chantable;
 		sc->sbands[IEEE80211_BAND_5GHZ].bitrates =
 			sc->rates[IEEE80211_BAND_5GHZ];
@@ -1546,7 +1546,7 @@ static int ath_init(u16 devid, struct ath_softc *sc)
 			ARRAY_SIZE(ath9k_5ghz_chantable);
 	}
 
-	if (sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_BT_COEX)
+	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_BT_COEX)
 		ath9k_hw_btcoex_enable(sc->sc_ah);
 
 	return 0;
@@ -1603,14 +1603,14 @@ int ath_attach(u16 devid, struct ath_softc *sc)
 
 	hw->rate_control_algorithm = "ath9k_rate_control";
 
-	if (sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_HT) {
+	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT) {
 		setup_ht_cap(sc, &sc->sbands[IEEE80211_BAND_2GHZ].ht_cap);
-		if (test_bit(ATH9K_MODE_11A, sc->sc_ah->ah_caps.wireless_modes))
+		if (test_bit(ATH9K_MODE_11A, sc->sc_ah->caps.wireless_modes))
 			setup_ht_cap(sc, &sc->sbands[IEEE80211_BAND_5GHZ].ht_cap);
 	}
 
 	hw->wiphy->bands[IEEE80211_BAND_2GHZ] =	&sc->sbands[IEEE80211_BAND_2GHZ];
-	if (test_bit(ATH9K_MODE_11A, sc->sc_ah->ah_caps.wireless_modes))
+	if (test_bit(ATH9K_MODE_11A, sc->sc_ah->caps.wireless_modes))
 		hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
 			&sc->sbands[IEEE80211_BAND_5GHZ];
 
@@ -1625,7 +1625,7 @@ int ath_attach(u16 devid, struct ath_softc *sc)
 
 #if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
 	/* Initialze h/w Rfkill */
-	if (sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
+	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
 		INIT_DELAYED_WORK(&sc->rf_kill.rfkill_poll, ath_rfkill_poll);
 
 	/* Initialize s/w rfkill */
@@ -1681,7 +1681,7 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 	ath_flushrecv(sc);
 
 	spin_lock_bh(&sc->sc_resetlock);
-	r = ath9k_hw_reset(ah, sc->sc_ah->ah_curchan, false);
+	r = ath9k_hw_reset(ah, sc->sc_ah->curchan, false);
 	if (r)
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"Unable to reset hardware; reset status %u\n", r);
@@ -1755,7 +1755,7 @@ int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
 	 * descriptors that cross the 4K page boundary. Assume
 	 * one skipped descriptor per 4K page.
 	 */
-	if (!(sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_4KB_SPLITTRANS)) {
+	if (!(sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_4KB_SPLITTRANS)) {
 		u32 ndesc_skipped =
 			ATH_DESC_4KB_BOUND_NUM_SKIPPED(dd->dd_desc_len);
 		u32 dma_len;
@@ -1795,7 +1795,7 @@ int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
 		bf->bf_desc = ds;
 		bf->bf_daddr = DS2PHYS(dd, ds);
 
-		if (!(sc->sc_ah->ah_caps.hw_caps &
+		if (!(sc->sc_ah->caps.hw_caps &
 		      ATH9K_HW_CAP_4KB_SPLITTRANS)) {
 			/*
 			 * Skip descriptor addresses which can cause 4KB
@@ -1939,7 +1939,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 
 	pos = curchan->hw_value;
 
-	init_channel = &sc->sc_ah->ah_channels[pos];
+	init_channel = &sc->sc_ah->channels[pos];
 	ath9k_update_ichannel(sc, init_channel);
 
 	/* Reset SERDES registers */
@@ -1989,10 +1989,10 @@ static int ath9k_start(struct ieee80211_hw *hw)
 		| ATH9K_INT_RXEOL | ATH9K_INT_RXORN
 		| ATH9K_INT_FATAL | ATH9K_INT_GLOBAL;
 
-	if (sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_GTT)
+	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_GTT)
 		sc->imask |= ATH9K_INT_GTT;
 
-	if (sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_HT)
+	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT)
 		sc->imask |= ATH9K_INT_CST;
 
 	ath_cache_conf_rate(sc, &hw->conf);
@@ -2092,7 +2092,7 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 		sc->rx.rxlink = NULL;
 
 #if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
-	if (sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
+	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
 		cancel_delayed_work_sync(&sc->rf_kill.rfkill_poll);
 #endif
 	/* disable HAL and put h/w to sleep */
@@ -2149,7 +2149,7 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 	sc->nvifs++;
 
 	/* Set the device opmode */
-	sc->sc_ah->ah_opmode = ic_opmode;
+	sc->sc_ah->opmode = ic_opmode;
 
 	/*
 	 * Enable MIB interrupts when there are hardware phy counters.
@@ -2165,7 +2165,7 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 	 * that does, if not overridden by configuration,
 	 * enable the TIM interrupt when operating as station.
 	 */
-	if ((sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_ENHANCEDPM) &&
+	if ((sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_ENHANCEDPM) &&
 	    (conf->type == NL80211_IFTYPE_STATION) &&
 	    !sc->config.swBeaconProcess)
 		sc->imask |= ATH9K_INT_TIM;
@@ -2198,8 +2198,8 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 	del_timer_sync(&sc->ani.timer);
 
 	/* Reclaim beacon resources */
-	if (sc->sc_ah->ah_opmode == NL80211_IFTYPE_AP ||
-	    sc->sc_ah->ah_opmode == NL80211_IFTYPE_ADHOC) {
+	if (sc->sc_ah->opmode == NL80211_IFTYPE_AP ||
+	    sc->sc_ah->opmode == NL80211_IFTYPE_ADHOC) {
 		ath9k_hw_stoptxdma(sc->sc_ah, sc->beacon.beaconq);
 		ath_beacon_return(sc, avp);
 	}
@@ -2248,11 +2248,11 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 			curchan->center_freq);
 
 		/* XXX: remove me eventualy */
-		ath9k_update_ichannel(sc, &sc->sc_ah->ah_channels[pos]);
+		ath9k_update_ichannel(sc, &sc->sc_ah->channels[pos]);
 
 		ath_update_chainmask(sc, conf_is_ht(conf));
 
-		if (ath_set_channel(sc, &sc->sc_ah->ah_channels[pos]) < 0) {
+		if (ath_set_channel(sc, &sc->sc_ah->channels[pos]) < 0) {
 			DPRINTF(sc, ATH_DBG_FATAL, "Unable to set channel\n");
 			mutex_unlock(&sc->mutex);
 			return -EINVAL;
@@ -2280,8 +2280,8 @@ static int ath9k_config_interface(struct ieee80211_hw *hw,
 	/* TODO: Need to decide which hw opmode to use for multi-interface
 	 * cases */
 	if (vif->type == NL80211_IFTYPE_AP &&
-	    ah->ah_opmode != NL80211_IFTYPE_AP) {
-		ah->ah_opmode = NL80211_IFTYPE_STATION;
+	    ah->opmode != NL80211_IFTYPE_AP) {
+		ah->opmode = NL80211_IFTYPE_STATION;
 		ath9k_hw_setopmode(ah);
 		memcpy(sc->curbssid, sc->sc_ah->macaddr, ETH_ALEN);
 		sc->curaid = 0;
diff --git a/drivers/net/wireless/ath9k/pci.c b/drivers/net/wireless/ath9k/pci.c
index eac8db7..c28afe4 100644
--- a/drivers/net/wireless/ath9k/pci.c
+++ b/drivers/net/wireless/ath9k/pci.c
@@ -228,7 +228,7 @@ static int ath_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 	ath9k_hw_set_gpio(sc->sc_ah, ATH_LED_PIN, 1);
 
 #if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
-	if (sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
+	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
 		cancel_delayed_work_sync(&sc->rf_kill.rfkill_poll);
 #endif
 
@@ -269,7 +269,7 @@ static int ath_pci_resume(struct pci_dev *pdev)
 	 * check the h/w rfkill state on resume
 	 * and start the rfkill poll timer
 	 */
-	if (sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
+	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
 		queue_delayed_work(sc->hw->workqueue,
 				   &sc->rf_kill.rfkill_poll, 0);
 #endif
diff --git a/drivers/net/wireless/ath9k/phy.c b/drivers/net/wireless/ath9k/phy.c
index 5a42969..52aa2a7 100644
--- a/drivers/net/wireless/ath9k/phy.c
+++ b/drivers/net/wireless/ath9k/phy.c
@@ -20,7 +20,7 @@ void
 ath9k_hw_write_regs(struct ath_hw *ah, u32 modesIndex, u32 freqIndex,
 		    int regWrites)
 {
-	REG_WRITE_ARRAY(&ah->ah_iniBB_RfGain, freqIndex, regWrites);
+	REG_WRITE_ARRAY(&ah->iniBB_RfGain, freqIndex, regWrites);
 }
 
 bool
@@ -90,8 +90,8 @@ ath9k_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
 
 	REG_WRITE(ah, AR_PHY(0x37), reg32);
 
-	ah->ah_curchan = chan;
-	ah->ah_curchanRadIndex = -1;
+	ah->curchan = chan;
+	ah->curchan_rad_index = -1;
 
 	return true;
 }
@@ -160,8 +160,8 @@ ath9k_hw_ar9280_set_channel(struct ath_hw *ah,
 
 	REG_WRITE(ah, AR_PHY_SYNTH_CONTROL, reg32);
 
-	ah->ah_curchan = chan;
-	ah->ah_curchanRadIndex = -1;
+	ah->curchan = chan;
+	ah->curchan_rad_index = -1;
 
 	return true;
 }
@@ -207,19 +207,19 @@ ath9k_hw_set_rf_regs(struct ath_hw *ah, struct ath9k_channel *chan,
 
 	eepMinorRev = ah->eep_ops->get_eeprom(ah, EEP_MINOR_REV);
 
-	RF_BANK_SETUP(ah->ah_analogBank0Data, &ah->ah_iniBank0, 1);
+	RF_BANK_SETUP(ah->analogBank0Data, &ah->iniBank0, 1);
 
-	RF_BANK_SETUP(ah->ah_analogBank1Data, &ah->ah_iniBank1, 1);
+	RF_BANK_SETUP(ah->analogBank1Data, &ah->iniBank1, 1);
 
-	RF_BANK_SETUP(ah->ah_analogBank2Data, &ah->ah_iniBank2, 1);
+	RF_BANK_SETUP(ah->analogBank2Data, &ah->iniBank2, 1);
 
-	RF_BANK_SETUP(ah->ah_analogBank3Data, &ah->ah_iniBank3,
+	RF_BANK_SETUP(ah->analogBank3Data, &ah->iniBank3,
 		      modesIndex);
 	{
 		int i;
-		for (i = 0; i < ah->ah_iniBank6TPC.ia_rows; i++) {
-			ah->ah_analogBank6Data[i] =
-			    INI_RA(&ah->ah_iniBank6TPC, i, modesIndex);
+		for (i = 0; i < ah->iniBank6TPC.ia_rows; i++) {
+			ah->analogBank6Data[i] =
+			    INI_RA(&ah->iniBank6TPC, i, modesIndex);
 		}
 	}
 
@@ -227,33 +227,33 @@ ath9k_hw_set_rf_regs(struct ath_hw *ah, struct ath9k_channel *chan,
 		if (IS_CHAN_2GHZ(chan)) {
 			ob2GHz = ah->eep_ops->get_eeprom(ah, EEP_OB_2);
 			db2GHz = ah->eep_ops->get_eeprom(ah, EEP_DB_2);
-			ath9k_phy_modify_rx_buffer(ah->ah_analogBank6Data,
+			ath9k_phy_modify_rx_buffer(ah->analogBank6Data,
 						   ob2GHz, 3, 197, 0);
-			ath9k_phy_modify_rx_buffer(ah->ah_analogBank6Data,
+			ath9k_phy_modify_rx_buffer(ah->analogBank6Data,
 						   db2GHz, 3, 194, 0);
 		} else {
 			ob5GHz = ah->eep_ops->get_eeprom(ah, EEP_OB_5);
 			db5GHz = ah->eep_ops->get_eeprom(ah, EEP_DB_5);
-			ath9k_phy_modify_rx_buffer(ah->ah_analogBank6Data,
+			ath9k_phy_modify_rx_buffer(ah->analogBank6Data,
 						   ob5GHz, 3, 203, 0);
-			ath9k_phy_modify_rx_buffer(ah->ah_analogBank6Data,
+			ath9k_phy_modify_rx_buffer(ah->analogBank6Data,
 						   db5GHz, 3, 200, 0);
 		}
 	}
 
-	RF_BANK_SETUP(ah->ah_analogBank7Data, &ah->ah_iniBank7, 1);
+	RF_BANK_SETUP(ah->analogBank7Data, &ah->iniBank7, 1);
 
-	REG_WRITE_RF_ARRAY(&ah->ah_iniBank0, ah->ah_analogBank0Data,
+	REG_WRITE_RF_ARRAY(&ah->iniBank0, ah->analogBank0Data,
 			   regWrites);
-	REG_WRITE_RF_ARRAY(&ah->ah_iniBank1, ah->ah_analogBank1Data,
+	REG_WRITE_RF_ARRAY(&ah->iniBank1, ah->analogBank1Data,
 			   regWrites);
-	REG_WRITE_RF_ARRAY(&ah->ah_iniBank2, ah->ah_analogBank2Data,
+	REG_WRITE_RF_ARRAY(&ah->iniBank2, ah->analogBank2Data,
 			   regWrites);
-	REG_WRITE_RF_ARRAY(&ah->ah_iniBank3, ah->ah_analogBank3Data,
+	REG_WRITE_RF_ARRAY(&ah->iniBank3, ah->analogBank3Data,
 			   regWrites);
-	REG_WRITE_RF_ARRAY(&ah->ah_iniBank6TPC, ah->ah_analogBank6Data,
+	REG_WRITE_RF_ARRAY(&ah->iniBank6TPC, ah->analogBank6Data,
 			   regWrites);
-	REG_WRITE_RF_ARRAY(&ah->ah_iniBank7, ah->ah_analogBank7Data,
+	REG_WRITE_RF_ARRAY(&ah->iniBank7, ah->analogBank7Data,
 			   regWrites);
 
 	return true;
@@ -262,99 +262,99 @@ ath9k_hw_set_rf_regs(struct ath_hw *ah, struct ath9k_channel *chan,
 void
 ath9k_hw_rfdetach(struct ath_hw *ah)
 {
-	if (ah->ah_analogBank0Data != NULL) {
-		kfree(ah->ah_analogBank0Data);
-		ah->ah_analogBank0Data = NULL;
+	if (ah->analogBank0Data != NULL) {
+		kfree(ah->analogBank0Data);
+		ah->analogBank0Data = NULL;
 	}
-	if (ah->ah_analogBank1Data != NULL) {
-		kfree(ah->ah_analogBank1Data);
-		ah->ah_analogBank1Data = NULL;
+	if (ah->analogBank1Data != NULL) {
+		kfree(ah->analogBank1Data);
+		ah->analogBank1Data = NULL;
 	}
-	if (ah->ah_analogBank2Data != NULL) {
-		kfree(ah->ah_analogBank2Data);
-		ah->ah_analogBank2Data = NULL;
+	if (ah->analogBank2Data != NULL) {
+		kfree(ah->analogBank2Data);
+		ah->analogBank2Data = NULL;
 	}
-	if (ah->ah_analogBank3Data != NULL) {
-		kfree(ah->ah_analogBank3Data);
-		ah->ah_analogBank3Data = NULL;
+	if (ah->analogBank3Data != NULL) {
+		kfree(ah->analogBank3Data);
+		ah->analogBank3Data = NULL;
 	}
-	if (ah->ah_analogBank6Data != NULL) {
-		kfree(ah->ah_analogBank6Data);
-		ah->ah_analogBank6Data = NULL;
+	if (ah->analogBank6Data != NULL) {
+		kfree(ah->analogBank6Data);
+		ah->analogBank6Data = NULL;
 	}
-	if (ah->ah_analogBank6TPCData != NULL) {
-		kfree(ah->ah_analogBank6TPCData);
-		ah->ah_analogBank6TPCData = NULL;
+	if (ah->analogBank6TPCData != NULL) {
+		kfree(ah->analogBank6TPCData);
+		ah->analogBank6TPCData = NULL;
 	}
-	if (ah->ah_analogBank7Data != NULL) {
-		kfree(ah->ah_analogBank7Data);
-		ah->ah_analogBank7Data = NULL;
+	if (ah->analogBank7Data != NULL) {
+		kfree(ah->analogBank7Data);
+		ah->analogBank7Data = NULL;
 	}
-	if (ah->ah_addac5416_21 != NULL) {
-		kfree(ah->ah_addac5416_21);
-		ah->ah_addac5416_21 = NULL;
+	if (ah->addac5416_21 != NULL) {
+		kfree(ah->addac5416_21);
+		ah->addac5416_21 = NULL;
 	}
-	if (ah->ah_bank6Temp != NULL) {
-		kfree(ah->ah_bank6Temp);
-		ah->ah_bank6Temp = NULL;
+	if (ah->bank6Temp != NULL) {
+		kfree(ah->bank6Temp);
+		ah->bank6Temp = NULL;
 	}
 }
 
 bool ath9k_hw_init_rf(struct ath_hw *ah, int *status)
 {
 	if (!AR_SREV_9280_10_OR_LATER(ah)) {
-		ah->ah_analogBank0Data =
+		ah->analogBank0Data =
 		    kzalloc((sizeof(u32) *
-			     ah->ah_iniBank0.ia_rows), GFP_KERNEL);
-		ah->ah_analogBank1Data =
+			     ah->iniBank0.ia_rows), GFP_KERNEL);
+		ah->analogBank1Data =
 		    kzalloc((sizeof(u32) *
-			     ah->ah_iniBank1.ia_rows), GFP_KERNEL);
-		ah->ah_analogBank2Data =
+			     ah->iniBank1.ia_rows), GFP_KERNEL);
+		ah->analogBank2Data =
 		    kzalloc((sizeof(u32) *
-			     ah->ah_iniBank2.ia_rows), GFP_KERNEL);
-		ah->ah_analogBank3Data =
+			     ah->iniBank2.ia_rows), GFP_KERNEL);
+		ah->analogBank3Data =
 		    kzalloc((sizeof(u32) *
-			     ah->ah_iniBank3.ia_rows), GFP_KERNEL);
-		ah->ah_analogBank6Data =
+			     ah->iniBank3.ia_rows), GFP_KERNEL);
+		ah->analogBank6Data =
 		    kzalloc((sizeof(u32) *
-			     ah->ah_iniBank6.ia_rows), GFP_KERNEL);
-		ah->ah_analogBank6TPCData =
+			     ah->iniBank6.ia_rows), GFP_KERNEL);
+		ah->analogBank6TPCData =
 		    kzalloc((sizeof(u32) *
-			     ah->ah_iniBank6TPC.ia_rows), GFP_KERNEL);
-		ah->ah_analogBank7Data =
+			     ah->iniBank6TPC.ia_rows), GFP_KERNEL);
+		ah->analogBank7Data =
 		    kzalloc((sizeof(u32) *
-			     ah->ah_iniBank7.ia_rows), GFP_KERNEL);
-
-		if (ah->ah_analogBank0Data == NULL
-		    || ah->ah_analogBank1Data == NULL
-		    || ah->ah_analogBank2Data == NULL
-		    || ah->ah_analogBank3Data == NULL
-		    || ah->ah_analogBank6Data == NULL
-		    || ah->ah_analogBank6TPCData == NULL
-		    || ah->ah_analogBank7Data == NULL) {
+			     ah->iniBank7.ia_rows), GFP_KERNEL);
+
+		if (ah->analogBank0Data == NULL
+		    || ah->analogBank1Data == NULL
+		    || ah->analogBank2Data == NULL
+		    || ah->analogBank3Data == NULL
+		    || ah->analogBank6Data == NULL
+		    || ah->analogBank6TPCData == NULL
+		    || ah->analogBank7Data == NULL) {
 			DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
 				"Cannot allocate RF banks\n");
 			*status = -ENOMEM;
 			return false;
 		}
 
-		ah->ah_addac5416_21 =
+		ah->addac5416_21 =
 		    kzalloc((sizeof(u32) *
-			     ah->ah_iniAddac.ia_rows *
-			     ah->ah_iniAddac.ia_columns), GFP_KERNEL);
-		if (ah->ah_addac5416_21 == NULL) {
+			     ah->iniAddac.ia_rows *
+			     ah->iniAddac.ia_columns), GFP_KERNEL);
+		if (ah->addac5416_21 == NULL) {
 			DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
-				"Cannot allocate ah_addac5416_21\n");
+				"Cannot allocate addac5416_21\n");
 			*status = -ENOMEM;
 			return false;
 		}
 
-		ah->ah_bank6Temp =
+		ah->bank6Temp =
 		    kzalloc((sizeof(u32) *
-			     ah->ah_iniBank6.ia_rows), GFP_KERNEL);
-		if (ah->ah_bank6Temp == NULL) {
+			     ah->iniBank6.ia_rows), GFP_KERNEL);
+		if (ah->bank6Temp == NULL) {
 			DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
-				"Cannot allocate ah_bank6Temp\n");
+				"Cannot allocate bank6Temp\n");
 			*status = -ENOMEM;
 			return false;
 		}
@@ -368,19 +368,19 @@ ath9k_hw_decrease_chain_power(struct ath_hw *ah, struct ath9k_channel *chan)
 {
 	int i, regWrites = 0;
 	u32 bank6SelMask;
-	u32 *bank6Temp = ah->ah_bank6Temp;
+	u32 *bank6Temp = ah->bank6Temp;
 
-	switch (ah->ah_diversityControl) {
+	switch (ah->diversity_control) {
 	case ATH9K_ANT_FIXED_A:
 		bank6SelMask =
 		    (ah->
-		     ah_antennaSwitchSwap & ANTSWAP_AB) ? REDUCE_CHAIN_0 :
+		     antenna_switch_swap & ANTSWAP_AB) ? REDUCE_CHAIN_0 :
 		    REDUCE_CHAIN_1;
 		break;
 	case ATH9K_ANT_FIXED_B:
 		bank6SelMask =
 		    (ah->
-		     ah_antennaSwitchSwap & ANTSWAP_AB) ? REDUCE_CHAIN_1 :
+		     antenna_switch_swap & ANTSWAP_AB) ? REDUCE_CHAIN_1 :
 		    REDUCE_CHAIN_0;
 		break;
 	case ATH9K_ANT_VARIABLE:
@@ -391,8 +391,8 @@ ath9k_hw_decrease_chain_power(struct ath_hw *ah, struct ath9k_channel *chan)
 		break;
 	}
 
-	for (i = 0; i < ah->ah_iniBank6.ia_rows; i++)
-		bank6Temp[i] = ah->ah_analogBank6Data[i];
+	for (i = 0; i < ah->iniBank6.ia_rows; i++)
+		bank6Temp[i] = ah->analogBank6Data[i];
 
 	REG_WRITE(ah, AR_PHY_BASE + 0xD8, bank6SelMask);
 
@@ -406,7 +406,7 @@ ath9k_hw_decrease_chain_power(struct ath_hw *ah, struct ath9k_channel *chan)
 	ath9k_phy_modify_rx_buffer(bank6Temp, 1, 1, 246, 0);
 	ath9k_phy_modify_rx_buffer(bank6Temp, 1, 1, 247, 0);
 
-	REG_WRITE_RF_ARRAY(&ah->ah_iniBank6, bank6Temp, regWrites);
+	REG_WRITE_RF_ARRAY(&ah->iniBank6, bank6Temp, regWrites);
 
 	REG_WRITE(ah, AR_PHY_BASE + 0xD8, 0x00000053);
 #ifdef ALTER_SWITCH
diff --git a/drivers/net/wireless/ath9k/phy.h b/drivers/net/wireless/ath9k/phy.h
index 71a7f5a..837a598 100644
--- a/drivers/net/wireless/ath9k/phy.h
+++ b/drivers/net/wireless/ath9k/phy.h
@@ -533,7 +533,7 @@ bool ath9k_hw_init_rf(struct ath_hw *ah,
 #define ATH9K_KEY_XOR                 0xaa
 
 #define ATH9K_IS_MIC_ENABLED(ah)					\
-	((ah)->ah_staId1Defaults & AR_STA_ID1_CRPT_MIC_ENABLE)
+	((ah)->sta_id1_defaults & AR_STA_ID1_CRPT_MIC_ENABLE)
 
 #define ANTSWAP_AB 0x0001
 #define REDUCE_CHAIN_0 0x00000050
diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index 060a7cf..a4e8631 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -1394,13 +1394,13 @@ static void ath_rc_init(struct ath_softc *sc,
 	u8 i, j, k, hi = 0, hthi = 0;
 
 	/* FIXME: Adhoc */
-	if ((sc->sc_ah->ah_opmode == NL80211_IFTYPE_STATION) ||
-	    (sc->sc_ah->ah_opmode == NL80211_IFTYPE_ADHOC)) {
+	if ((sc->sc_ah->opmode == NL80211_IFTYPE_STATION) ||
+	    (sc->sc_ah->opmode == NL80211_IFTYPE_ADHOC)) {
 		bool is_cw_40 = sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40;
 		rate_table = ath_choose_rate_table(sc, sband->band,
 						   sta->ht_cap.ht_supported,
 						   is_cw_40);
-	} else if (sc->sc_ah->ah_opmode == NL80211_IFTYPE_AP) {
+	} else if (sc->sc_ah->opmode == NL80211_IFTYPE_AP) {
 		/* cur_rate_table would be set on init through config() */
 		rate_table = sc->cur_rate_table;
 	}
@@ -1412,7 +1412,7 @@ static void ath_rc_init(struct ath_softc *sc,
 
 	if (sta->ht_cap.ht_supported) {
 		ath_rc_priv->ht_cap = WLAN_RC_HT_FLAG;
-		if (sc->sc_ah->ah_caps.tx_chainmask != 1)
+		if (sc->sc_ah->caps.tx_chainmask != 1)
 			ath_rc_priv->ht_cap |= WLAN_RC_DS_FLAG;
 		if (sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40)
 			ath_rc_priv->ht_cap |= WLAN_RC_40_FLAG;
@@ -1519,7 +1519,7 @@ static void ath_tx_status(void *priv, struct ieee80211_supported_band *sband,
 	 */
 	if (tx_info_priv->tx.ts_flags &
 	    (ATH9K_TX_DATA_UNDERRUN | ATH9K_TX_DELIM_UNDERRUN) &&
-	    ((sc->sc_ah->ah_txTrigLevel) >= ath_rc_priv->tx_triglevel_max)) {
+	    ((sc->sc_ah->tx_trig_level) >= ath_rc_priv->tx_triglevel_max)) {
 		tx_status = 1;
 		is_underrun = 1;
 	}
@@ -1628,7 +1628,7 @@ static void *ath_rate_alloc_sta(void *priv, struct ieee80211_sta *sta, gfp_t gfp
 	}
 
 	rate_priv->rssi_down_time = jiffies_to_msecs(jiffies);
-	rate_priv->tx_triglevel_max = sc->sc_ah->ah_caps.tx_triglevel_max;
+	rate_priv->tx_triglevel_max = sc->sc_ah->caps.tx_triglevel_max;
 
 	return rate_priv;
 }
diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index 7c011b1..08f676a 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -135,7 +135,7 @@ static int ath_rx_prepare(struct sk_buff *skb, struct ath_desc *ds,
 		 * discard the frame. Enable this if you want to see
 		 * error frames in Monitor mode.
 		 */
-		if (sc->sc_ah->ah_opmode != NL80211_IFTYPE_MONITOR)
+		if (sc->sc_ah->opmode != NL80211_IFTYPE_MONITOR)
 			goto rx_next;
 	} else if (ds->ds_rxstat.rs_status != 0) {
 		if (ds->ds_rxstat.rs_status & ATH9K_RXERR_CRC)
@@ -161,7 +161,7 @@ static int ath_rx_prepare(struct sk_buff *skb, struct ath_desc *ds,
 		 * decryption and MIC failures. For monitor mode,
 		 * we also ignore the CRC error.
 		 */
-		if (sc->sc_ah->ah_opmode == NL80211_IFTYPE_MONITOR) {
+		if (sc->sc_ah->opmode == NL80211_IFTYPE_MONITOR) {
 			if (ds->ds_rxstat.rs_status &
 			    ~(ATH9K_RXERR_DECRYPT | ATH9K_RXERR_MIC |
 			      ATH9K_RXERR_CRC))
@@ -241,7 +241,7 @@ static void ath_opmode_init(struct ath_softc *sc)
 	ath9k_hw_setrxfilter(ah, rfilt);
 
 	/* configure bssid mask */
-	if (ah->ah_caps.hw_caps & ATH9K_HW_CAP_BSSIDMASK)
+	if (ah->caps.hw_caps & ATH9K_HW_CAP_BSSIDMASK)
 		ath9k_hw_setbssidmask(sc);
 
 	/* configure operational mode */
@@ -360,13 +360,13 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
 		| ATH9K_RX_FILTER_MCAST;
 
 	/* If not a STA, enable processing of Probe Requests */
-	if (sc->sc_ah->ah_opmode != NL80211_IFTYPE_STATION)
+	if (sc->sc_ah->opmode != NL80211_IFTYPE_STATION)
 		rfilt |= ATH9K_RX_FILTER_PROBEREQ;
 
 	/* Can't set HOSTAP into promiscous mode */
-	if (((sc->sc_ah->ah_opmode != NL80211_IFTYPE_AP) &&
+	if (((sc->sc_ah->opmode != NL80211_IFTYPE_AP) &&
 	     (sc->rx.rxfilter & FIF_PROMISC_IN_BSS)) ||
-	    (sc->sc_ah->ah_opmode == NL80211_IFTYPE_MONITOR)) {
+	    (sc->sc_ah->opmode == NL80211_IFTYPE_MONITOR)) {
 		rfilt |= ATH9K_RX_FILTER_PROM;
 		/* ??? To prevent from sending ACK */
 		rfilt &= ~ATH9K_RX_FILTER_UCAST;
@@ -375,13 +375,13 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
 	if (sc->rx.rxfilter & FIF_CONTROL)
 		rfilt |= ATH9K_RX_FILTER_CONTROL;
 
-	if (sc->sc_ah->ah_opmode == NL80211_IFTYPE_STATION ||
-	    sc->sc_ah->ah_opmode == NL80211_IFTYPE_ADHOC)
+	if (sc->sc_ah->opmode == NL80211_IFTYPE_STATION ||
+	    sc->sc_ah->opmode == NL80211_IFTYPE_ADHOC)
 		rfilt |= ATH9K_RX_FILTER_BEACON;
 
 	/* If in HOSTAP mode, want to enable reception of PSPOLL frames
 	   & beacon frames */
-	if (sc->sc_ah->ah_opmode == NL80211_IFTYPE_AP)
+	if (sc->sc_ah->opmode == NL80211_IFTYPE_AP)
 		rfilt |= (ATH9K_RX_FILTER_BEACON | ATH9K_RX_FILTER_PSPOLL);
 
 	return rfilt;
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 3fff334..3f70b1e 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -308,7 +308,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 			 * when perform internal reset in this routine.
 			 * Only enable reset in STA mode for now.
 			 */
-			if (sc->sc_ah->ah_opmode == NL80211_IFTYPE_STATION)
+			if (sc->sc_ah->opmode == NL80211_IFTYPE_STATION)
 				needreset = 1;
 		}
 	}
@@ -1072,7 +1072,7 @@ void ath_drain_all_txq(struct ath_softc *sc, bool retry_tx)
 		DPRINTF(sc, ATH_DBG_XMIT, "Unable to stop TxDMA. Reset HAL!\n");
 
 		spin_lock_bh(&sc->sc_resetlock);
-		r = ath9k_hw_reset(ah, sc->sc_ah->ah_curchan, true);
+		r = ath9k_hw_reset(ah, sc->sc_ah->curchan, true);
 		if (r)
 			DPRINTF(sc, ATH_DBG_FATAL,
 				"Unable to reset hardware; reset status %u\n",
@@ -1477,7 +1477,7 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 	}
 
 	/* For AR5416 - RTS cannot be followed by a frame larger than 8K */
-	if (bf_isaggr(bf) && (bf->bf_al > sc->sc_ah->ah_caps.rts_aggr_limit))
+	if (bf_isaggr(bf) && (bf->bf_al > sc->sc_ah->caps.rts_aggr_limit))
 		flags &= ~(ATH9K_TXDESC_RTSENA);
 
 	for (i = 0; i < 4; i++) {
-- 
1.6.1

