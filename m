Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:30466 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbZBIIAz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2009 03:00:55 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 09 Feb 2009 00:00:55 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18831.57816.962109.461805@gargle.gargle.HOWL> (sfid-20090209_090108_382154_643EA10B)
Date: Mon, 9 Feb 2009 13:27:12 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 07/10] ath9k: Merge ath_hal and ath_hal_5416 structures
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Finally, merge these structures and have a single
HW specific data structure.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/ahb.c    |    4 +-
 drivers/net/wireless/ath9k/ani.c    |  232 ++++++-------
 drivers/net/wireless/ath9k/ani.h    |   22 +-
 drivers/net/wireless/ath9k/ath9k.h  |    6 +-
 drivers/net/wireless/ath9k/beacon.c |   12 +-
 drivers/net/wireless/ath9k/calib.c  |  175 ++++-----
 drivers/net/wireless/ath9k/calib.h  |   20 +-
 drivers/net/wireless/ath9k/debug.c  |    2 +-
 drivers/net/wireless/ath9k/eeprom.c |  251 ++++++--------
 drivers/net/wireless/ath9k/eeprom.h |   36 +-
 drivers/net/wireless/ath9k/hw.c     |  675 ++++++++++++++++-------------------
 drivers/net/wireless/ath9k/hw.h     |  134 ++++----
 drivers/net/wireless/ath9k/mac.c    |  144 ++++----
 drivers/net/wireless/ath9k/mac.h    |   64 ++--
 drivers/net/wireless/ath9k/main.c   |   22 +-
 drivers/net/wireless/ath9k/pci.c    |    4 +-
 drivers/net/wireless/ath9k/phy.c    |  194 +++++------
 drivers/net/wireless/ath9k/phy.h    |   14 +-
 drivers/net/wireless/ath9k/recv.c   |   10 +-
 drivers/net/wireless/ath9k/regd.c   |   18 +-
 drivers/net/wireless/ath9k/regd.h   |   14 +-
 drivers/net/wireless/ath9k/xmit.c   |   12 +-
 22 files changed, 956 insertions(+), 1109 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ahb.c b/drivers/net/wireless/ath9k/ahb.c
index d254b35..391c9fd 100644
--- a/drivers/net/wireless/ath9k/ahb.c
+++ b/drivers/net/wireless/ath9k/ahb.c
@@ -32,7 +32,7 @@ static void ath_ahb_cleanup(struct ath_softc *sc)
 	iounmap(sc->mem);
 }
 
-static bool ath_ahb_eeprom_read(struct ath_hal *ah, u32 off, u16 *data)
+static bool ath_ahb_eeprom_read(struct ath_hw *ah, u32 off, u16 *data)
 {
 	struct ath_softc *sc = ah->ah_sc;
 	struct platform_device *pdev = to_platform_device(sc->dev);
@@ -65,7 +65,7 @@ static int ath_ahb_probe(struct platform_device *pdev)
 	struct resource *res;
 	int irq;
 	int ret = 0;
-	struct ath_hal *ah;
+	struct ath_hw *ah;
 
 	if (!pdev->dev.platform_data) {
 		dev_err(&pdev->dev, "no platform data specified\n");
diff --git a/drivers/net/wireless/ath9k/ani.c b/drivers/net/wireless/ath9k/ani.c
index 9cebf0e..6bd2d57 100644
--- a/drivers/net/wireless/ath9k/ani.c
+++ b/drivers/net/wireless/ath9k/ani.c
@@ -16,18 +16,17 @@
 
 #include "ath9k.h"
 
-static int ath9k_hw_get_ani_channel_idx(struct ath_hal *ah,
+static int ath9k_hw_get_ani_channel_idx(struct ath_hw *ah,
 					struct ath9k_channel *chan)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(ahp->ah_ani); i++) {
-		if (ahp->ah_ani[i].c &&
-		    ahp->ah_ani[i].c->channel == chan->channel)
+	for (i = 0; i < ARRAY_SIZE(ah->ah_ani); i++) {
+		if (ah->ah_ani[i].c &&
+		    ah->ah_ani[i].c->channel == chan->channel)
 			return i;
-		if (ahp->ah_ani[i].c == NULL) {
-			ahp->ah_ani[i].c = chan;
+		if (ah->ah_ani[i].c == NULL) {
+			ah->ah_ani[i].c = chan;
 			return i;
 		}
 	}
@@ -38,41 +37,40 @@ static int ath9k_hw_get_ani_channel_idx(struct ath_hal *ah,
 	return 0;
 }
 
-static bool ath9k_hw_ani_control(struct ath_hal *ah,
+static bool ath9k_hw_ani_control(struct ath_hw *ah,
 				 enum ath9k_ani_cmd cmd, int param)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
-	struct ar5416AniState *aniState = ahp->ah_curani;
+	struct ar5416AniState *aniState = ah->ah_curani;
 
-	switch (cmd & ahp->ah_ani_function) {
+	switch (cmd & ah->ah_ani_function) {
 	case ATH9K_ANI_NOISE_IMMUNITY_LEVEL:{
 		u32 level = param;
 
-		if (level >= ARRAY_SIZE(ahp->ah_totalSizeDesired)) {
+		if (level >= ARRAY_SIZE(ah->ah_totalSizeDesired)) {
 			DPRINTF(ah->ah_sc, ATH_DBG_ANI,
 				"level out of range (%u > %u)\n",
 				level,
-				(unsigned)ARRAY_SIZE(ahp->ah_totalSizeDesired));
+				(unsigned)ARRAY_SIZE(ah->ah_totalSizeDesired));
 			return false;
 		}
 
 		REG_RMW_FIELD(ah, AR_PHY_DESIRED_SZ,
 			      AR_PHY_DESIRED_SZ_TOT_DES,
-			      ahp->ah_totalSizeDesired[level]);
+			      ah->ah_totalSizeDesired[level]);
 		REG_RMW_FIELD(ah, AR_PHY_AGC_CTL1,
 			      AR_PHY_AGC_CTL1_COARSE_LOW,
-			      ahp->ah_coarseLow[level]);
+			      ah->ah_coarseLow[level]);
 		REG_RMW_FIELD(ah, AR_PHY_AGC_CTL1,
 			      AR_PHY_AGC_CTL1_COARSE_HIGH,
-			      ahp->ah_coarseHigh[level]);
+			      ah->ah_coarseHigh[level]);
 		REG_RMW_FIELD(ah, AR_PHY_FIND_SIG,
 			      AR_PHY_FIND_SIG_FIRPWR,
-			      ahp->ah_firpwr[level]);
+			      ah->ah_firpwr[level]);
 
 		if (level > aniState->noiseImmunityLevel)
-			ahp->ah_stats.ast_ani_niup++;
+			ah->ah_stats.ast_ani_niup++;
 		else if (level < aniState->noiseImmunityLevel)
-			ahp->ah_stats.ast_ani_nidown++;
+			ah->ah_stats.ast_ani_nidown++;
 		aniState->noiseImmunityLevel = level;
 		break;
 	}
@@ -126,9 +124,9 @@ static bool ath9k_hw_ani_control(struct ath_hal *ah,
 
 		if (!on != aniState->ofdmWeakSigDetectOff) {
 			if (on)
-				ahp->ah_stats.ast_ani_ofdmon++;
+				ah->ah_stats.ast_ani_ofdmon++;
 			else
-				ahp->ah_stats.ast_ani_ofdmoff++;
+				ah->ah_stats.ast_ani_ofdmoff++;
 			aniState->ofdmWeakSigDetectOff = !on;
 		}
 		break;
@@ -142,9 +140,9 @@ static bool ath9k_hw_ani_control(struct ath_hal *ah,
 			      weakSigThrCck[high]);
 		if (high != aniState->cckWeakSigThreshold) {
 			if (high)
-				ahp->ah_stats.ast_ani_cckhigh++;
+				ah->ah_stats.ast_ani_cckhigh++;
 			else
-				ahp->ah_stats.ast_ani_ccklow++;
+				ah->ah_stats.ast_ani_ccklow++;
 			aniState->cckWeakSigThreshold = high;
 		}
 		break;
@@ -164,9 +162,9 @@ static bool ath9k_hw_ani_control(struct ath_hal *ah,
 			      AR_PHY_FIND_SIG_FIRSTEP,
 			      firstep[level]);
 		if (level > aniState->firstepLevel)
-			ahp->ah_stats.ast_ani_stepup++;
+			ah->ah_stats.ast_ani_stepup++;
 		else if (level < aniState->firstepLevel)
-			ahp->ah_stats.ast_ani_stepdown++;
+			ah->ah_stats.ast_ani_stepdown++;
 		aniState->firstepLevel = level;
 		break;
 	}
@@ -187,9 +185,9 @@ static bool ath9k_hw_ani_control(struct ath_hal *ah,
 			      AR_PHY_TIMING5_CYCPWR_THR1,
 			      cycpwrThr1[level]);
 		if (level > aniState->spurImmunityLevel)
-			ahp->ah_stats.ast_ani_spurup++;
+			ah->ah_stats.ast_ani_spurup++;
 		else if (level < aniState->spurImmunityLevel)
-			ahp->ah_stats.ast_ani_spurdown++;
+			ah->ah_stats.ast_ani_spurdown++;
 		aniState->spurImmunityLevel = level;
 		break;
 	}
@@ -220,7 +218,7 @@ static bool ath9k_hw_ani_control(struct ath_hal *ah,
 	return true;
 }
 
-static void ath9k_hw_update_mibstats(struct ath_hal *ah,
+static void ath9k_hw_update_mibstats(struct ath_hw *ah,
 				     struct ath9k_mib_stats *stats)
 {
 	stats->ackrcv_bad += REG_READ(ah, AR_ACK_FAIL);
@@ -230,18 +228,17 @@ static void ath9k_hw_update_mibstats(struct ath_hal *ah,
 	stats->beacons += REG_READ(ah, AR_BEACON_CNT);
 }
 
-static void ath9k_ani_restart(struct ath_hal *ah)
+static void ath9k_ani_restart(struct ath_hw *ah)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct ar5416AniState *aniState;
 
 	if (!DO_ANI(ah))
 		return;
 
-	aniState = ahp->ah_curani;
+	aniState = ah->ah_curani;
 
 	aniState->listenTime = 0;
-	if (ahp->ah_hasHwPhyCounters) {
+	if (ah->ah_hasHwPhyCounters) {
 		if (aniState->ofdmTrigHigh > AR_PHY_COUNTMAX) {
 			aniState->ofdmPhyErrBase = 0;
 			DPRINTF(ah->ah_sc, ATH_DBG_ANI,
@@ -267,15 +264,14 @@ static void ath9k_ani_restart(struct ath_hal *ah)
 		REG_WRITE(ah, AR_PHY_ERR_MASK_1, AR_PHY_ERR_OFDM_TIMING);
 		REG_WRITE(ah, AR_PHY_ERR_MASK_2, AR_PHY_ERR_CCK_TIMING);
 
-		ath9k_hw_update_mibstats(ah, &ahp->ah_mibStats);
+		ath9k_hw_update_mibstats(ah, &ah->ah_mibStats);
 	}
 	aniState->ofdmPhyErrCount = 0;
 	aniState->cckPhyErrCount = 0;
 }
 
-static void ath9k_hw_ani_ofdm_err_trigger(struct ath_hal *ah)
+static void ath9k_hw_ani_ofdm_err_trigger(struct ath_hw *ah)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct ieee80211_conf *conf = &ah->ah_sc->hw->conf;
 	struct ar5416AniState *aniState;
 	int32_t rssi;
@@ -283,7 +279,7 @@ static void ath9k_hw_ani_ofdm_err_trigger(struct ath_hal *ah)
 	if (!DO_ANI(ah))
 		return;
 
-	aniState = ahp->ah_curani;
+	aniState = ah->ah_curani;
 
 	if (aniState->noiseImmunityLevel < HAL_NOISE_IMMUNE_MAX) {
 		if (ath9k_hw_ani_control(ah, ATH9K_ANI_NOISE_IMMUNITY_LEVEL,
@@ -306,7 +302,7 @@ static void ath9k_hw_ani_ofdm_err_trigger(struct ath_hal *ah)
 		}
 		return;
 	}
-	rssi = BEACON_RSSI(ahp);
+	rssi = BEACON_RSSI(ah);
 	if (rssi > aniState->rssiThrHigh) {
 		if (!aniState->ofdmWeakSigDetectOff) {
 			if (ath9k_hw_ani_control(ah,
@@ -345,9 +341,8 @@ static void ath9k_hw_ani_ofdm_err_trigger(struct ath_hal *ah)
 	}
 }
 
-static void ath9k_hw_ani_cck_err_trigger(struct ath_hal *ah)
+static void ath9k_hw_ani_cck_err_trigger(struct ath_hw *ah)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct ieee80211_conf *conf = &ah->ah_sc->hw->conf;
 	struct ar5416AniState *aniState;
 	int32_t rssi;
@@ -355,7 +350,7 @@ static void ath9k_hw_ani_cck_err_trigger(struct ath_hal *ah)
 	if (!DO_ANI(ah))
 		return;
 
-	aniState = ahp->ah_curani;
+	aniState = ah->ah_curani;
 	if (aniState->noiseImmunityLevel < HAL_NOISE_IMMUNE_MAX) {
 		if (ath9k_hw_ani_control(ah, ATH9K_ANI_NOISE_IMMUNITY_LEVEL,
 					 aniState->noiseImmunityLevel + 1)) {
@@ -369,7 +364,7 @@ static void ath9k_hw_ani_cck_err_trigger(struct ath_hal *ah)
 		}
 		return;
 	}
-	rssi = BEACON_RSSI(ahp);
+	rssi = BEACON_RSSI(ah);
 	if (rssi > aniState->rssiThrLow) {
 		if (aniState->firstepLevel < HAL_FIRST_STEP_MAX)
 			ath9k_hw_ani_control(ah, ATH9K_ANI_FIRSTEP_LEVEL,
@@ -383,13 +378,12 @@ static void ath9k_hw_ani_cck_err_trigger(struct ath_hal *ah)
 	}
 }
 
-static void ath9k_hw_ani_lower_immunity(struct ath_hal *ah)
+static void ath9k_hw_ani_lower_immunity(struct ath_hw *ah)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct ar5416AniState *aniState;
 	int32_t rssi;
 
-	aniState = ahp->ah_curani;
+	aniState = ah->ah_curani;
 
 	if (ah->ah_opmode == NL80211_IFTYPE_AP) {
 		if (aniState->firstepLevel > 0) {
@@ -398,7 +392,7 @@ static void ath9k_hw_ani_lower_immunity(struct ath_hal *ah)
 				return;
 		}
 	} else {
-		rssi = BEACON_RSSI(ahp);
+		rssi = BEACON_RSSI(ah);
 		if (rssi > aniState->rssiThrHigh) {
 			/* XXX: Handle me */
 		} else if (rssi > aniState->rssiThrLow) {
@@ -437,9 +431,8 @@ static void ath9k_hw_ani_lower_immunity(struct ath_hal *ah)
 	}
 }
 
-static int32_t ath9k_hw_ani_get_listen_time(struct ath_hal *ah)
+static int32_t ath9k_hw_ani_get_listen_time(struct ath_hw *ah)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct ar5416AniState *aniState;
 	u32 txFrameCount, rxFrameCount, cycleCount;
 	int32_t listenTime;
@@ -448,11 +441,11 @@ static int32_t ath9k_hw_ani_get_listen_time(struct ath_hal *ah)
 	rxFrameCount = REG_READ(ah, AR_RFCNT);
 	cycleCount = REG_READ(ah, AR_CCCNT);
 
-	aniState = ahp->ah_curani;
+	aniState = ah->ah_curani;
 	if (aniState->cycleCount == 0 || aniState->cycleCount > cycleCount) {
 
 		listenTime = 0;
-		ahp->ah_stats.ast_ani_lzero++;
+		ah->ah_stats.ast_ani_lzero++;
 	} else {
 		int32_t ccdelta = cycleCount - aniState->cycleCount;
 		int32_t rfdelta = rxFrameCount - aniState->rxFrameCount;
@@ -466,9 +459,8 @@ static int32_t ath9k_hw_ani_get_listen_time(struct ath_hal *ah)
 	return listenTime;
 }
 
-void ath9k_ani_reset(struct ath_hal *ah)
+void ath9k_ani_reset(struct ath_hw *ah)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct ar5416AniState *aniState;
 	struct ath9k_channel *chan = ah->ah_curchan;
 	int index;
@@ -477,14 +469,14 @@ void ath9k_ani_reset(struct ath_hal *ah)
 		return;
 
 	index = ath9k_hw_get_ani_channel_idx(ah, chan);
-	aniState = &ahp->ah_ani[index];
-	ahp->ah_curani = aniState;
+	aniState = &ah->ah_ani[index];
+	ah->ah_curani = aniState;
 
 	if (DO_ANI(ah) && ah->ah_opmode != NL80211_IFTYPE_STATION
 	    && ah->ah_opmode != NL80211_IFTYPE_ADHOC) {
 		DPRINTF(ah->ah_sc, ATH_DBG_ANI,
 			"Reset ANI state opmode %u\n", ah->ah_opmode);
-		ahp->ah_stats.ast_ani_reset++;
+		ah->ah_stats.ast_ani_reset++;
 
 		ath9k_hw_ani_control(ah, ATH9K_ANI_NOISE_IMMUNITY_LEVEL, 0);
 		ath9k_hw_ani_control(ah, ATH9K_ANI_SPUR_IMMUNITY_LEVEL, 0);
@@ -498,13 +490,13 @@ void ath9k_ani_reset(struct ath_hal *ah)
 				     ATH9K_RX_FILTER_PHYERR);
 
 		if (ah->ah_opmode == NL80211_IFTYPE_AP) {
-			ahp->ah_curani->ofdmTrigHigh =
+			ah->ah_curani->ofdmTrigHigh =
 				ah->ah_config.ofdm_trig_high;
-			ahp->ah_curani->ofdmTrigLow =
+			ah->ah_curani->ofdmTrigLow =
 				ah->ah_config.ofdm_trig_low;
-			ahp->ah_curani->cckTrigHigh =
+			ah->ah_curani->cckTrigHigh =
 				ah->ah_config.cck_trig_high;
-			ahp->ah_curani->cckTrigLow =
+			ah->ah_curani->cckTrigLow =
 				ah->ah_config.cck_trig_low;
 		}
 		ath9k_ani_restart(ah);
@@ -526,7 +518,7 @@ void ath9k_ani_reset(struct ath_hal *ah)
 	if (aniState->firstepLevel != 0)
 		ath9k_hw_ani_control(ah, ATH9K_ANI_FIRSTEP_LEVEL,
 				     aniState->firstepLevel);
-	if (ahp->ah_hasHwPhyCounters) {
+	if (ah->ah_hasHwPhyCounters) {
 		ath9k_hw_setrxfilter(ah, ath9k_hw_getrxfilter(ah) &
 				     ~ATH9K_RX_FILTER_PHYERR);
 		ath9k_ani_restart(ah);
@@ -540,34 +532,33 @@ void ath9k_ani_reset(struct ath_hal *ah)
 	}
 }
 
-void ath9k_hw_ani_monitor(struct ath_hal *ah,
+void ath9k_hw_ani_monitor(struct ath_hw *ah,
 			  const struct ath9k_node_stats *stats,
 			  struct ath9k_channel *chan)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct ar5416AniState *aniState;
 	int32_t listenTime;
 
 	if (!DO_ANI(ah))
 		return;
 
-	aniState = ahp->ah_curani;
-	ahp->ah_stats.ast_nodestats = *stats;
+	aniState = ah->ah_curani;
+	ah->ah_stats.ast_nodestats = *stats;
 
 	listenTime = ath9k_hw_ani_get_listen_time(ah);
 	if (listenTime < 0) {
-		ahp->ah_stats.ast_ani_lneg++;
+		ah->ah_stats.ast_ani_lneg++;
 		ath9k_ani_restart(ah);
 		return;
 	}
 
 	aniState->listenTime += listenTime;
 
-	if (ahp->ah_hasHwPhyCounters) {
+	if (ah->ah_hasHwPhyCounters) {
 		u32 phyCnt1, phyCnt2;
 		u32 ofdmPhyErrCnt, cckPhyErrCnt;
 
-		ath9k_hw_update_mibstats(ah, &ahp->ah_mibStats);
+		ath9k_hw_update_mibstats(ah, &ah->ah_mibStats);
 
 		phyCnt1 = REG_READ(ah, AR_PHY_ERR_1);
 		phyCnt2 = REG_READ(ah, AR_PHY_ERR_2);
@@ -600,24 +591,24 @@ void ath9k_hw_ani_monitor(struct ath_hal *ah,
 		}
 
 		ofdmPhyErrCnt = phyCnt1 - aniState->ofdmPhyErrBase;
-		ahp->ah_stats.ast_ani_ofdmerrs +=
+		ah->ah_stats.ast_ani_ofdmerrs +=
 			ofdmPhyErrCnt - aniState->ofdmPhyErrCount;
 		aniState->ofdmPhyErrCount = ofdmPhyErrCnt;
 
 		cckPhyErrCnt = phyCnt2 - aniState->cckPhyErrBase;
-		ahp->ah_stats.ast_ani_cckerrs +=
+		ah->ah_stats.ast_ani_cckerrs +=
 			cckPhyErrCnt - aniState->cckPhyErrCount;
 		aniState->cckPhyErrCount = cckPhyErrCnt;
 	}
 
-	if (aniState->listenTime > 5 * ahp->ah_aniPeriod) {
+	if (aniState->listenTime > 5 * ah->ah_aniPeriod) {
 		if (aniState->ofdmPhyErrCount <= aniState->listenTime *
 		    aniState->ofdmTrigLow / 1000 &&
 		    aniState->cckPhyErrCount <= aniState->listenTime *
 		    aniState->cckTrigLow / 1000)
 			ath9k_hw_ani_lower_immunity(ah);
 		ath9k_ani_restart(ah);
-	} else if (aniState->listenTime > ahp->ah_aniPeriod) {
+	} else if (aniState->listenTime > ah->ah_aniPeriod) {
 		if (aniState->ofdmPhyErrCount > aniState->listenTime *
 		    aniState->ofdmTrigHigh / 1000) {
 			ath9k_hw_ani_ofdm_err_trigger(ah);
@@ -631,20 +622,16 @@ void ath9k_hw_ani_monitor(struct ath_hal *ah,
 	}
 }
 
-bool ath9k_hw_phycounters(struct ath_hal *ah)
+bool ath9k_hw_phycounters(struct ath_hw *ah)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
-
-	return ahp->ah_hasHwPhyCounters ? true : false;
+	return ah->ah_hasHwPhyCounters ? true : false;
 }
 
-void ath9k_enable_mib_counters(struct ath_hal *ah)
+void ath9k_enable_mib_counters(struct ath_hw *ah)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
-
 	DPRINTF(ah->ah_sc, ATH_DBG_ANI, "Enable MIB counters\n");
 
-	ath9k_hw_update_mibstats(ah, &ahp->ah_mibStats);
+	ath9k_hw_update_mibstats(ah, &ah->ah_mibStats);
 
 	REG_WRITE(ah, AR_FILT_OFDM, 0);
 	REG_WRITE(ah, AR_FILT_CCK, 0);
@@ -655,21 +642,19 @@ void ath9k_enable_mib_counters(struct ath_hal *ah)
 	REG_WRITE(ah, AR_PHY_ERR_MASK_2, AR_PHY_ERR_CCK_TIMING);
 }
 
-void ath9k_hw_disable_mib_counters(struct ath_hal *ah)
+void ath9k_hw_disable_mib_counters(struct ath_hw *ah)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
-
 	DPRINTF(ah->ah_sc, ATH_DBG_ANI, "Disable MIB counters\n");
 
 	REG_WRITE(ah, AR_MIBC, AR_MIBC_FMC | AR_MIBC_CMC);
 
-	ath9k_hw_update_mibstats(ah, &ahp->ah_mibStats);
+	ath9k_hw_update_mibstats(ah, &ah->ah_mibStats);
 
 	REG_WRITE(ah, AR_FILT_OFDM, 0);
 	REG_WRITE(ah, AR_FILT_CCK, 0);
 }
 
-u32 ath9k_hw_GetMibCycleCountsPct(struct ath_hal *ah,
+u32 ath9k_hw_GetMibCycleCountsPct(struct ath_hw *ah,
 				  u32 *rxc_pcnt,
 				  u32 *rxf_pcnt,
 				  u32 *txf_pcnt)
@@ -714,10 +699,9 @@ u32 ath9k_hw_GetMibCycleCountsPct(struct ath_hal *ah,
  * any of the MIB counters overflow/trigger so don't assume we're
  * here because a PHY error counter triggered.
  */
-void ath9k_hw_procmibevent(struct ath_hal *ah,
+void ath9k_hw_procmibevent(struct ath_hw *ah,
 			   const struct ath9k_node_stats *stats)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
 	u32 phyCnt1, phyCnt2;
 
 	/* Reset these counters regardless */
@@ -727,8 +711,8 @@ void ath9k_hw_procmibevent(struct ath_hal *ah,
 		REG_WRITE(ah, AR_SLP_MIB_CTRL, AR_SLP_MIB_CLEAR);
 
 	/* Clear the mib counters and save them in the stats */
-	ath9k_hw_update_mibstats(ah, &ahp->ah_mibStats);
-	ahp->ah_stats.ast_nodestats = *stats;
+	ath9k_hw_update_mibstats(ah, &ah->ah_mibStats);
+	ah->ah_stats.ast_nodestats = *stats;
 
 	if (!DO_ANI(ah))
 		return;
@@ -738,17 +722,17 @@ void ath9k_hw_procmibevent(struct ath_hal *ah,
 	phyCnt2 = REG_READ(ah, AR_PHY_ERR_2);
 	if (((phyCnt1 & AR_MIBCNT_INTRMASK) == AR_MIBCNT_INTRMASK) ||
 	    ((phyCnt2 & AR_MIBCNT_INTRMASK) == AR_MIBCNT_INTRMASK)) {
-		struct ar5416AniState *aniState = ahp->ah_curani;
+		struct ar5416AniState *aniState = ah->ah_curani;
 		u32 ofdmPhyErrCnt, cckPhyErrCnt;
 
 		/* NB: only use ast_ani_*errs with AH_PRIVATE_DIAG */
 		ofdmPhyErrCnt = phyCnt1 - aniState->ofdmPhyErrBase;
-		ahp->ah_stats.ast_ani_ofdmerrs +=
+		ah->ah_stats.ast_ani_ofdmerrs +=
 			ofdmPhyErrCnt - aniState->ofdmPhyErrCount;
 		aniState->ofdmPhyErrCount = ofdmPhyErrCnt;
 
 		cckPhyErrCnt = phyCnt2 - aniState->cckPhyErrBase;
-		ahp->ah_stats.ast_ani_cckerrs +=
+		ah->ah_stats.ast_ani_cckerrs +=
 			cckPhyErrCnt - aniState->cckPhyErrCount;
 		aniState->cckPhyErrCount = cckPhyErrCnt;
 
@@ -767,9 +751,8 @@ void ath9k_hw_procmibevent(struct ath_hal *ah,
 	}
 }
 
-void ath9k_hw_ani_setup(struct ath_hal *ah)
+void ath9k_hw_ani_setup(struct ath_hw *ah)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
 	int i;
 
 	const int totalSizeDesired[] = { -55, -55, -55, -55, -62 };
@@ -778,66 +761,63 @@ void ath9k_hw_ani_setup(struct ath_hal *ah)
 	const int firpwr[] = { -78, -78, -78, -78, -80 };
 
 	for (i = 0; i < 5; i++) {
-		ahp->ah_totalSizeDesired[i] = totalSizeDesired[i];
-		ahp->ah_coarseHigh[i] = coarseHigh[i];
-		ahp->ah_coarseLow[i] = coarseLow[i];
-		ahp->ah_firpwr[i] = firpwr[i];
+		ah->ah_totalSizeDesired[i] = totalSizeDesired[i];
+		ah->ah_coarseHigh[i] = coarseHigh[i];
+		ah->ah_coarseLow[i] = coarseLow[i];
+		ah->ah_firpwr[i] = firpwr[i];
 	}
 }
 
-void ath9k_hw_ani_attach(struct ath_hal *ah)
+void ath9k_hw_ani_attach(struct ath_hw *ah)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
 	int i;
 
 	DPRINTF(ah->ah_sc, ATH_DBG_ANI, "Attach ANI\n");
 
-	ahp->ah_hasHwPhyCounters = 1;
-
-	memset(ahp->ah_ani, 0, sizeof(ahp->ah_ani));
-	for (i = 0; i < ARRAY_SIZE(ahp->ah_ani); i++) {
-		ahp->ah_ani[i].ofdmTrigHigh = ATH9K_ANI_OFDM_TRIG_HIGH;
-		ahp->ah_ani[i].ofdmTrigLow = ATH9K_ANI_OFDM_TRIG_LOW;
-		ahp->ah_ani[i].cckTrigHigh = ATH9K_ANI_CCK_TRIG_HIGH;
-		ahp->ah_ani[i].cckTrigLow = ATH9K_ANI_CCK_TRIG_LOW;
-		ahp->ah_ani[i].rssiThrHigh = ATH9K_ANI_RSSI_THR_HIGH;
-		ahp->ah_ani[i].rssiThrLow = ATH9K_ANI_RSSI_THR_LOW;
-		ahp->ah_ani[i].ofdmWeakSigDetectOff =
+	ah->ah_hasHwPhyCounters = 1;
+
+	memset(ah->ah_ani, 0, sizeof(ah->ah_ani));
+	for (i = 0; i < ARRAY_SIZE(ah->ah_ani); i++) {
+		ah->ah_ani[i].ofdmTrigHigh = ATH9K_ANI_OFDM_TRIG_HIGH;
+		ah->ah_ani[i].ofdmTrigLow = ATH9K_ANI_OFDM_TRIG_LOW;
+		ah->ah_ani[i].cckTrigHigh = ATH9K_ANI_CCK_TRIG_HIGH;
+		ah->ah_ani[i].cckTrigLow = ATH9K_ANI_CCK_TRIG_LOW;
+		ah->ah_ani[i].rssiThrHigh = ATH9K_ANI_RSSI_THR_HIGH;
+		ah->ah_ani[i].rssiThrLow = ATH9K_ANI_RSSI_THR_LOW;
+		ah->ah_ani[i].ofdmWeakSigDetectOff =
 			!ATH9K_ANI_USE_OFDM_WEAK_SIG;
-		ahp->ah_ani[i].cckWeakSigThreshold =
+		ah->ah_ani[i].cckWeakSigThreshold =
 			ATH9K_ANI_CCK_WEAK_SIG_THR;
-		ahp->ah_ani[i].spurImmunityLevel = ATH9K_ANI_SPUR_IMMUNE_LVL;
-		ahp->ah_ani[i].firstepLevel = ATH9K_ANI_FIRSTEP_LVL;
-		if (ahp->ah_hasHwPhyCounters) {
-			ahp->ah_ani[i].ofdmPhyErrBase =
+		ah->ah_ani[i].spurImmunityLevel = ATH9K_ANI_SPUR_IMMUNE_LVL;
+		ah->ah_ani[i].firstepLevel = ATH9K_ANI_FIRSTEP_LVL;
+		if (ah->ah_hasHwPhyCounters) {
+			ah->ah_ani[i].ofdmPhyErrBase =
 				AR_PHY_COUNTMAX - ATH9K_ANI_OFDM_TRIG_HIGH;
-			ahp->ah_ani[i].cckPhyErrBase =
+			ah->ah_ani[i].cckPhyErrBase =
 				AR_PHY_COUNTMAX - ATH9K_ANI_CCK_TRIG_HIGH;
 		}
 	}
-	if (ahp->ah_hasHwPhyCounters) {
+	if (ah->ah_hasHwPhyCounters) {
 		DPRINTF(ah->ah_sc, ATH_DBG_ANI,
 			"Setting OfdmErrBase = 0x%08x\n",
-			ahp->ah_ani[0].ofdmPhyErrBase);
+			ah->ah_ani[0].ofdmPhyErrBase);
 		DPRINTF(ah->ah_sc, ATH_DBG_ANI, "Setting cckErrBase = 0x%08x\n",
-			ahp->ah_ani[0].cckPhyErrBase);
+			ah->ah_ani[0].cckPhyErrBase);
 
-		REG_WRITE(ah, AR_PHY_ERR_1, ahp->ah_ani[0].ofdmPhyErrBase);
-		REG_WRITE(ah, AR_PHY_ERR_2, ahp->ah_ani[0].cckPhyErrBase);
+		REG_WRITE(ah, AR_PHY_ERR_1, ah->ah_ani[0].ofdmPhyErrBase);
+		REG_WRITE(ah, AR_PHY_ERR_2, ah->ah_ani[0].cckPhyErrBase);
 		ath9k_enable_mib_counters(ah);
 	}
-	ahp->ah_aniPeriod = ATH9K_ANI_PERIOD;
+	ah->ah_aniPeriod = ATH9K_ANI_PERIOD;
 	if (ah->ah_config.enable_ani)
-		ahp->ah_procPhyErr |= HAL_PROCESS_ANI;
+		ah->ah_procPhyErr |= HAL_PROCESS_ANI;
 }
 
-void ath9k_hw_ani_detach(struct ath_hal *ah)
+void ath9k_hw_ani_detach(struct ath_hw *ah)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
-
 	DPRINTF(ah->ah_sc, ATH_DBG_ANI, "Detach ANI\n");
 
-	if (ahp->ah_hasHwPhyCounters) {
+	if (ah->ah_hasHwPhyCounters) {
 		ath9k_hw_disable_mib_counters(ah);
 		REG_WRITE(ah, AR_PHY_ERR_1, 0);
 		REG_WRITE(ah, AR_PHY_ERR_2, 0);
diff --git a/drivers/net/wireless/ath9k/ani.h b/drivers/net/wireless/ath9k/ani.h
index 78880e5..7e9ca95 100644
--- a/drivers/net/wireless/ath9k/ani.h
+++ b/drivers/net/wireless/ath9k/ani.h
@@ -20,7 +20,7 @@
 #define HAL_PROCESS_ANI           0x00000001
 #define ATH9K_RSSI_EP_MULTIPLIER  (1<<7)
 
-#define DO_ANI(ah) ((AH5416(ah)->ah_procPhyErr & HAL_PROCESS_ANI))
+#define DO_ANI(ah) (((ah)->ah_procPhyErr & HAL_PROCESS_ANI))
 
 #define HAL_EP_RND(x, mul)						\
 	((((x)%(mul)) >= ((mul)/2)) ? ((x) + ((mul) - 1)) / (mul) : (x)/(mul))
@@ -120,19 +120,19 @@ struct ar5416Stats {
 };
 #define ah_mibStats ah_stats.ast_mibstats
 
-void ath9k_ani_reset(struct ath_hal *ah);
-void ath9k_hw_ani_monitor(struct ath_hal *ah,
+void ath9k_ani_reset(struct ath_hw *ah);
+void ath9k_hw_ani_monitor(struct ath_hw *ah,
 			  const struct ath9k_node_stats *stats,
 			  struct ath9k_channel *chan);
-bool ath9k_hw_phycounters(struct ath_hal *ah);
-void ath9k_enable_mib_counters(struct ath_hal *ah);
-void ath9k_hw_disable_mib_counters(struct ath_hal *ah);
-u32 ath9k_hw_GetMibCycleCountsPct(struct ath_hal *ah, u32 *rxc_pcnt,
+bool ath9k_hw_phycounters(struct ath_hw *ah);
+void ath9k_enable_mib_counters(struct ath_hw *ah);
+void ath9k_hw_disable_mib_counters(struct ath_hw *ah);
+u32 ath9k_hw_GetMibCycleCountsPct(struct ath_hw *ah, u32 *rxc_pcnt,
 				  u32 *rxf_pcnt, u32 *txf_pcnt);
-void ath9k_hw_procmibevent(struct ath_hal *ah,
+void ath9k_hw_procmibevent(struct ath_hw *ah,
 			   const struct ath9k_node_stats *stats);
-void ath9k_hw_ani_setup(struct ath_hal *ah);
-void ath9k_hw_ani_attach(struct ath_hal *ah);
-void ath9k_hw_ani_detach(struct ath_hal *ah);
+void ath9k_hw_ani_setup(struct ath_hw *ah);
+void ath9k_hw_ani_attach(struct ath_hw *ah);
+void ath9k_hw_ani_detach(struct ath_hw *ah);
 
 #endif /* ANI_H */
diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index 03e4d0b..91140b7 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -455,7 +455,7 @@ struct ath_beacon {
 
 void ath9k_beacon_tasklet(unsigned long data);
 void ath_beacon_config(struct ath_softc *sc, int if_id);
-int ath_beaconq_setup(struct ath_hal *ah);
+int ath_beaconq_setup(struct ath_hw *ah);
 int ath_beacon_alloc(struct ath_softc *sc, int if_id);
 void ath_beacon_return(struct ath_softc *sc, struct ath_vif *avp);
 void ath_beacon_sync(struct ath_softc *sc, int if_id);
@@ -565,7 +565,7 @@ struct ath_rfkill {
 struct ath_bus_ops {
 	void		(*read_cachesize)(struct ath_softc *sc, int *csz);
 	void		(*cleanup)(struct ath_softc *sc);
-	bool		(*eeprom_read)(struct ath_hal *ah, u32 off, u16 *data);
+	bool		(*eeprom_read)(struct ath_hw *ah, u32 off, u16 *data);
 };
 
 struct ath_softc {
@@ -573,7 +573,7 @@ struct ath_softc {
 	struct device *dev;
 	struct tasklet_struct intr_tq;
 	struct tasklet_struct bcon_tasklet;
-	struct ath_hal *sc_ah;
+	struct ath_hw *sc_ah;
 	void __iomem *mem;
 	int irq;
 	spinlock_t sc_resetlock;
diff --git a/drivers/net/wireless/ath9k/beacon.c b/drivers/net/wireless/ath9k/beacon.c
index 139bba7..19ec4e8 100644
--- a/drivers/net/wireless/ath9k/beacon.c
+++ b/drivers/net/wireless/ath9k/beacon.c
@@ -23,7 +23,7 @@
 */
 static int ath_beaconq_config(struct ath_softc *sc)
 {
-	struct ath_hal *ah = sc->sc_ah;
+	struct ath_hw *ah = sc->sc_ah;
 	struct ath9k_tx_queue_info qi;
 
 	ath9k_hw_get_txq_props(ah, sc->beacon.beaconq, &qi);
@@ -66,7 +66,7 @@ static void ath_beacon_setup(struct ath_softc *sc,
 			     struct ath_vif *avp, struct ath_buf *bf)
 {
 	struct sk_buff *skb = (struct sk_buff *)bf->bf_mpdu;
-	struct ath_hal *ah = sc->sc_ah;
+	struct ath_hw *ah = sc->sc_ah;
 	struct ath_desc *ds;
 	struct ath9k_11n_rate_series series[4];
 	struct ath_rate_table *rt;
@@ -248,7 +248,7 @@ static struct ath_buf *ath_beacon_generate(struct ath_softc *sc, int if_id)
 static void ath_beacon_start_adhoc(struct ath_softc *sc, int if_id)
 {
 	struct ieee80211_vif *vif;
-	struct ath_hal *ah = sc->sc_ah;
+	struct ath_hw *ah = sc->sc_ah;
 	struct ath_buf *bf;
 	struct ath_vif *avp;
 	struct sk_buff *skb;
@@ -276,7 +276,7 @@ static void ath_beacon_start_adhoc(struct ath_softc *sc, int if_id)
 		sc->beacon.beaconq, ito64(bf->bf_daddr), bf->bf_desc);
 }
 
-int ath_beaconq_setup(struct ath_hal *ah)
+int ath_beaconq_setup(struct ath_hw *ah)
 {
 	struct ath9k_tx_queue_info qi;
 
@@ -444,7 +444,7 @@ void ath_beacon_return(struct ath_softc *sc, struct ath_vif *avp)
 void ath9k_beacon_tasklet(unsigned long data)
 {
 	struct ath_softc *sc = (struct ath_softc *)data;
-	struct ath_hal *ah = sc->sc_ah;
+	struct ath_hw *ah = sc->sc_ah;
 	struct ath_buf *bf = NULL;
 	int slot, if_id;
 	u32 bfaddr;
@@ -619,7 +619,7 @@ void ath9k_beacon_tasklet(unsigned long data)
 void ath_beacon_config(struct ath_softc *sc, int if_id)
 {
 	struct ieee80211_vif *vif;
-	struct ath_hal *ah = sc->sc_ah;
+	struct ath_hw *ah = sc->sc_ah;
 	struct ath_beacon_config conf;
 	struct ath_vif *avp;
 	enum nl80211_iftype opmode;
diff --git a/drivers/net/wireless/ath9k/calib.c b/drivers/net/wireless/ath9k/calib.c
index 016302c..8c44d5a 100644
--- a/drivers/net/wireless/ath9k/calib.c
+++ b/drivers/net/wireless/ath9k/calib.c
@@ -23,7 +23,7 @@
  * is incorrect and we should use the static NF value. Later we can try to
  * find out why they are reporting these values */
 
-static bool ath9k_hw_nf_in_range(struct ath_hal *ah, s16 nf)
+static bool ath9k_hw_nf_in_range(struct ath_hw *ah, s16 nf)
 {
 	if (nf > ATH9K_NF_TOO_LOW) {
 		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
@@ -86,7 +86,7 @@ static void ath9k_hw_update_nfcal_hist_buffer(struct ath9k_nfcal_hist *h,
 	return;
 }
 
-static void ath9k_hw_do_getnf(struct ath_hal *ah,
+static void ath9k_hw_do_getnf(struct ath_hw *ah,
 			      int16_t nfarray[NUM_NF_READINGS])
 {
 	int16_t nf;
@@ -166,7 +166,7 @@ static void ath9k_hw_do_getnf(struct ath_hal *ah,
 	}
 }
 
-static bool getNoiseFloorThresh(struct ath_hal *ah,
+static bool getNoiseFloorThresh(struct ath_hw *ah,
 				enum ieee80211_band band,
 				int16_t *nft)
 {
@@ -185,7 +185,7 @@ static bool getNoiseFloorThresh(struct ath_hal *ah,
 	return true;
 }
 
-static void ath9k_hw_setup_calibration(struct ath_hal *ah,
+static void ath9k_hw_setup_calibration(struct ath_hw *ah,
 				       struct hal_cal_list *currCal)
 {
 	REG_RMW_FIELD(ah, AR_PHY_TIMING_CTRL4(0),
@@ -219,10 +219,9 @@ static void ath9k_hw_setup_calibration(struct ath_hal *ah,
 		    AR_PHY_TIMING_CTRL4_DO_CAL);
 }
 
-static void ath9k_hw_reset_calibration(struct ath_hal *ah,
+static void ath9k_hw_reset_calibration(struct ath_hw *ah,
 				       struct hal_cal_list *currCal)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
 	int i;
 
 	ath9k_hw_setup_calibration(ah, currCal);
@@ -230,23 +229,21 @@ static void ath9k_hw_reset_calibration(struct ath_hal *ah,
 	currCal->calState = CAL_RUNNING;
 
 	for (i = 0; i < AR5416_MAX_CHAINS; i++) {
-		ahp->ah_Meas0.sign[i] = 0;
-		ahp->ah_Meas1.sign[i] = 0;
-		ahp->ah_Meas2.sign[i] = 0;
-		ahp->ah_Meas3.sign[i] = 0;
+		ah->ah_Meas0.sign[i] = 0;
+		ah->ah_Meas1.sign[i] = 0;
+		ah->ah_Meas2.sign[i] = 0;
+		ah->ah_Meas3.sign[i] = 0;
 	}
 
-	ahp->ah_CalSamples = 0;
+	ah->ah_CalSamples = 0;
 }
 
-static void ath9k_hw_per_calibration(struct ath_hal *ah,
+static void ath9k_hw_per_calibration(struct ath_hw *ah,
 				     struct ath9k_channel *ichan,
 				     u8 rxchainmask,
 				     struct hal_cal_list *currCal,
 				     bool *isCalDone)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
-
 	*isCalDone = false;
 
 	if (currCal->calState == CAL_RUNNING) {
@@ -254,9 +251,9 @@ static void ath9k_hw_per_calibration(struct ath_hal *ah,
 		      AR_PHY_TIMING_CTRL4_DO_CAL)) {
 
 			currCal->calData->calCollect(ah);
-			ahp->ah_CalSamples++;
+			ah->ah_CalSamples++;
 
-			if (ahp->ah_CalSamples >= currCal->calData->calNumSamples) {
+			if (ah->ah_CalSamples >= currCal->calData->calNumSamples) {
 				int i, numChains = 0;
 				for (i = 0; i < AR5416_MAX_CHAINS; i++) {
 					if (rxchainmask & (1 << i))
@@ -277,13 +274,12 @@ static void ath9k_hw_per_calibration(struct ath_hal *ah,
 }
 
 /* Assumes you are talking about the currently configured channel */
-static bool ath9k_hw_iscal_supported(struct ath_hal *ah,
+static bool ath9k_hw_iscal_supported(struct ath_hw *ah,
 				     enum hal_cal_types calType)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct ieee80211_conf *conf = &ah->ah_sc->hw->conf;
 
-	switch (calType & ahp->ah_suppCals) {
+	switch (calType & ah->ah_suppCals) {
 	case IQ_MISMATCH_CAL: /* Both 2 GHz and 5 GHz support OFDM */
 		return true;
 	case ADC_GAIN_CAL:
@@ -296,90 +292,86 @@ static bool ath9k_hw_iscal_supported(struct ath_hal *ah,
 	return false;
 }
 
-static void ath9k_hw_iqcal_collect(struct ath_hal *ah)
+static void ath9k_hw_iqcal_collect(struct ath_hw *ah)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
 	int i;
 
 	for (i = 0; i < AR5416_MAX_CHAINS; i++) {
-		ahp->ah_totalPowerMeasI[i] +=
+		ah->ah_totalPowerMeasI[i] +=
 			REG_READ(ah, AR_PHY_CAL_MEAS_0(i));
-		ahp->ah_totalPowerMeasQ[i] +=
+		ah->ah_totalPowerMeasQ[i] +=
 			REG_READ(ah, AR_PHY_CAL_MEAS_1(i));
-		ahp->ah_totalIqCorrMeas[i] +=
+		ah->ah_totalIqCorrMeas[i] +=
 			(int32_t) REG_READ(ah, AR_PHY_CAL_MEAS_2(i));
 		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 			"%d: Chn %d pmi=0x%08x;pmq=0x%08x;iqcm=0x%08x;\n",
-			ahp->ah_CalSamples, i, ahp->ah_totalPowerMeasI[i],
-			ahp->ah_totalPowerMeasQ[i],
-			ahp->ah_totalIqCorrMeas[i]);
+			ah->ah_CalSamples, i, ah->ah_totalPowerMeasI[i],
+			ah->ah_totalPowerMeasQ[i],
+			ah->ah_totalIqCorrMeas[i]);
 	}
 }
 
-static void ath9k_hw_adc_gaincal_collect(struct ath_hal *ah)
+static void ath9k_hw_adc_gaincal_collect(struct ath_hw *ah)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
 	int i;
 
 	for (i = 0; i < AR5416_MAX_CHAINS; i++) {
-		ahp->ah_totalAdcIOddPhase[i] +=
+		ah->ah_totalAdcIOddPhase[i] +=
 			REG_READ(ah, AR_PHY_CAL_MEAS_0(i));
-		ahp->ah_totalAdcIEvenPhase[i] +=
+		ah->ah_totalAdcIEvenPhase[i] +=
 			REG_READ(ah, AR_PHY_CAL_MEAS_1(i));
-		ahp->ah_totalAdcQOddPhase[i] +=
+		ah->ah_totalAdcQOddPhase[i] +=
 			REG_READ(ah, AR_PHY_CAL_MEAS_2(i));
-		ahp->ah_totalAdcQEvenPhase[i] +=
+		ah->ah_totalAdcQEvenPhase[i] +=
 			REG_READ(ah, AR_PHY_CAL_MEAS_3(i));
 
 		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 			"%d: Chn %d oddi=0x%08x; eveni=0x%08x; "
 			"oddq=0x%08x; evenq=0x%08x;\n",
-			ahp->ah_CalSamples, i,
-			ahp->ah_totalAdcIOddPhase[i],
-			ahp->ah_totalAdcIEvenPhase[i],
-			ahp->ah_totalAdcQOddPhase[i],
-			ahp->ah_totalAdcQEvenPhase[i]);
+			ah->ah_CalSamples, i,
+			ah->ah_totalAdcIOddPhase[i],
+			ah->ah_totalAdcIEvenPhase[i],
+			ah->ah_totalAdcQOddPhase[i],
+			ah->ah_totalAdcQEvenPhase[i]);
 	}
 }
 
-static void ath9k_hw_adc_dccal_collect(struct ath_hal *ah)
+static void ath9k_hw_adc_dccal_collect(struct ath_hw *ah)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
 	int i;
 
 	for (i = 0; i < AR5416_MAX_CHAINS; i++) {
-		ahp->ah_totalAdcDcOffsetIOddPhase[i] +=
+		ah->ah_totalAdcDcOffsetIOddPhase[i] +=
 			(int32_t) REG_READ(ah, AR_PHY_CAL_MEAS_0(i));
-		ahp->ah_totalAdcDcOffsetIEvenPhase[i] +=
+		ah->ah_totalAdcDcOffsetIEvenPhase[i] +=
 			(int32_t) REG_READ(ah, AR_PHY_CAL_MEAS_1(i));
-		ahp->ah_totalAdcDcOffsetQOddPhase[i] +=
+		ah->ah_totalAdcDcOffsetQOddPhase[i] +=
 			(int32_t) REG_READ(ah, AR_PHY_CAL_MEAS_2(i));
-		ahp->ah_totalAdcDcOffsetQEvenPhase[i] +=
+		ah->ah_totalAdcDcOffsetQEvenPhase[i] +=
 			(int32_t) REG_READ(ah, AR_PHY_CAL_MEAS_3(i));
 
 		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 			"%d: Chn %d oddi=0x%08x; eveni=0x%08x; "
 			"oddq=0x%08x; evenq=0x%08x;\n",
-			ahp->ah_CalSamples, i,
-			ahp->ah_totalAdcDcOffsetIOddPhase[i],
-			ahp->ah_totalAdcDcOffsetIEvenPhase[i],
-			ahp->ah_totalAdcDcOffsetQOddPhase[i],
-			ahp->ah_totalAdcDcOffsetQEvenPhase[i]);
+			ah->ah_CalSamples, i,
+			ah->ah_totalAdcDcOffsetIOddPhase[i],
+			ah->ah_totalAdcDcOffsetIEvenPhase[i],
+			ah->ah_totalAdcDcOffsetQOddPhase[i],
+			ah->ah_totalAdcDcOffsetQEvenPhase[i]);
 	}
 }
 
-static void ath9k_hw_iqcalibrate(struct ath_hal *ah, u8 numChains)
+static void ath9k_hw_iqcalibrate(struct ath_hw *ah, u8 numChains)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
 	u32 powerMeasQ, powerMeasI, iqCorrMeas;
 	u32 qCoffDenom, iCoffDenom;
 	int32_t qCoff, iCoff;
 	int iqCorrNeg, i;
 
 	for (i = 0; i < numChains; i++) {
-		powerMeasI = ahp->ah_totalPowerMeasI[i];
-		powerMeasQ = ahp->ah_totalPowerMeasQ[i];
-		iqCorrMeas = ahp->ah_totalIqCorrMeas[i];
+		powerMeasI = ah->ah_totalPowerMeasI[i];
+		powerMeasQ = ah->ah_totalPowerMeasQ[i];
+		iqCorrMeas = ah->ah_totalIqCorrMeas[i];
 
 		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 			"Starting IQ Cal and Correction for Chain %d\n",
@@ -387,7 +379,7 @@ static void ath9k_hw_iqcalibrate(struct ath_hal *ah, u8 numChains)
 
 		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 			"Orignal: Chn %diq_corr_meas = 0x%08x\n",
-			i, ahp->ah_totalIqCorrMeas[i]);
+			i, ah->ah_totalIqCorrMeas[i]);
 
 		iqCorrNeg = 0;
 
@@ -445,17 +437,16 @@ static void ath9k_hw_iqcalibrate(struct ath_hal *ah, u8 numChains)
 		    AR_PHY_TIMING_CTRL4_IQCORR_ENABLE);
 }
 
-static void ath9k_hw_adc_gaincal_calibrate(struct ath_hal *ah, u8 numChains)
+static void ath9k_hw_adc_gaincal_calibrate(struct ath_hw *ah, u8 numChains)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
 	u32 iOddMeasOffset, iEvenMeasOffset, qOddMeasOffset, qEvenMeasOffset;
 	u32 qGainMismatch, iGainMismatch, val, i;
 
 	for (i = 0; i < numChains; i++) {
-		iOddMeasOffset = ahp->ah_totalAdcIOddPhase[i];
-		iEvenMeasOffset = ahp->ah_totalAdcIEvenPhase[i];
-		qOddMeasOffset = ahp->ah_totalAdcQOddPhase[i];
-		qEvenMeasOffset = ahp->ah_totalAdcQEvenPhase[i];
+		iOddMeasOffset = ah->ah_totalAdcIOddPhase[i];
+		iEvenMeasOffset = ah->ah_totalAdcIEvenPhase[i];
+		qOddMeasOffset = ah->ah_totalAdcQOddPhase[i];
+		qEvenMeasOffset = ah->ah_totalAdcQEvenPhase[i];
 
 		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 			"Starting ADC Gain Cal for Chain %d\n", i);
@@ -503,21 +494,20 @@ static void ath9k_hw_adc_gaincal_calibrate(struct ath_hal *ah, u8 numChains)
 		  AR_PHY_NEW_ADC_GAIN_CORR_ENABLE);
 }
 
-static void ath9k_hw_adc_dccal_calibrate(struct ath_hal *ah, u8 numChains)
+static void ath9k_hw_adc_dccal_calibrate(struct ath_hw *ah, u8 numChains)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
 	u32 iOddMeasOffset, iEvenMeasOffset, val, i;
 	int32_t qOddMeasOffset, qEvenMeasOffset, qDcMismatch, iDcMismatch;
 	const struct hal_percal_data *calData =
-		ahp->ah_cal_list_curr->calData;
+		ah->ah_cal_list_curr->calData;
 	u32 numSamples =
 		(1 << (calData->calCountMax + 5)) * calData->calNumSamples;
 
 	for (i = 0; i < numChains; i++) {
-		iOddMeasOffset = ahp->ah_totalAdcDcOffsetIOddPhase[i];
-		iEvenMeasOffset = ahp->ah_totalAdcDcOffsetIEvenPhase[i];
-		qOddMeasOffset = ahp->ah_totalAdcDcOffsetQOddPhase[i];
-		qEvenMeasOffset = ahp->ah_totalAdcDcOffsetQEvenPhase[i];
+		iOddMeasOffset = ah->ah_totalAdcDcOffsetIOddPhase[i];
+		iEvenMeasOffset = ah->ah_totalAdcDcOffsetIEvenPhase[i];
+		qOddMeasOffset = ah->ah_totalAdcDcOffsetQOddPhase[i];
+		qEvenMeasOffset = ah->ah_totalAdcDcOffsetQEvenPhase[i];
 
 		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 			"Starting ADC DC Offset Cal for Chain %d\n", i);
@@ -562,11 +552,10 @@ static void ath9k_hw_adc_dccal_calibrate(struct ath_hal *ah, u8 numChains)
 }
 
 /* This is done for the currently configured channel */
-bool ath9k_hw_reset_calvalid(struct ath_hal *ah)
+bool ath9k_hw_reset_calvalid(struct ath_hw *ah)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct ieee80211_conf *conf = &ah->ah_sc->hw->conf;
-	struct hal_cal_list *currCal = ahp->ah_cal_list_curr;
+	struct hal_cal_list *currCal = ah->ah_cal_list_curr;
 
 	if (!ah->ah_curchan)
 		return true;
@@ -597,7 +586,7 @@ bool ath9k_hw_reset_calvalid(struct ath_hal *ah)
 	return false;
 }
 
-void ath9k_hw_start_nfcal(struct ath_hal *ah)
+void ath9k_hw_start_nfcal(struct ath_hw *ah)
 {
 	REG_SET_BIT(ah, AR_PHY_AGC_CONTROL,
 		    AR_PHY_AGC_CONTROL_ENABLE_NF);
@@ -606,7 +595,7 @@ void ath9k_hw_start_nfcal(struct ath_hal *ah)
 	REG_SET_BIT(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_NF);
 }
 
-void ath9k_hw_loadnf(struct ath_hal *ah, struct ath9k_channel *chan)
+void ath9k_hw_loadnf(struct ath_hw *ah, struct ath9k_channel *chan)
 {
 	struct ath9k_nfcal_hist *h;
 	int i, j;
@@ -662,7 +651,7 @@ void ath9k_hw_loadnf(struct ath_hal *ah, struct ath9k_channel *chan)
 	}
 }
 
-int16_t ath9k_hw_getnf(struct ath_hal *ah,
+int16_t ath9k_hw_getnf(struct ath_hw *ah,
 		       struct ath9k_channel *chan)
 {
 	int16_t nf, nfThresh;
@@ -698,7 +687,7 @@ int16_t ath9k_hw_getnf(struct ath_hal *ah,
 	return chan->rawNoiseFloor;
 }
 
-void ath9k_init_nfcal_hist_buffer(struct ath_hal *ah)
+void ath9k_init_nfcal_hist_buffer(struct ath_hw *ah)
 {
 	int i, j;
 
@@ -712,10 +701,9 @@ void ath9k_init_nfcal_hist_buffer(struct ath_hal *ah)
 				AR_PHY_CCA_MAX_GOOD_VALUE;
 		}
 	}
-	return;
 }
 
-s16 ath9k_hw_getchan_noise(struct ath_hal *ah, struct ath9k_channel *chan)
+s16 ath9k_hw_getchan_noise(struct ath_hw *ah, struct ath9k_channel *chan)
 {
 	s16 nf;
 
@@ -730,12 +718,11 @@ s16 ath9k_hw_getchan_noise(struct ath_hal *ah, struct ath9k_channel *chan)
 	return nf;
 }
 
-bool ath9k_hw_calibrate(struct ath_hal *ah, struct ath9k_channel *chan,
+bool ath9k_hw_calibrate(struct ath_hw *ah, struct ath9k_channel *chan,
 			u8 rxchainmask, bool longcal,
 			bool *isCalDone)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
-	struct hal_cal_list *currCal = ahp->ah_cal_list_curr;
+	struct hal_cal_list *currCal = ah->ah_cal_list_curr;
 
 	*isCalDone = true;
 
@@ -745,7 +732,7 @@ bool ath9k_hw_calibrate(struct ath_hal *ah, struct ath9k_channel *chan,
 		ath9k_hw_per_calibration(ah, chan, rxchainmask, currCal,
 					 isCalDone);
 		if (*isCalDone) {
-			ahp->ah_cal_list_curr = currCal = currCal->calNext;
+			ah->ah_cal_list_curr = currCal = currCal->calNext;
 
 			if (currCal->calState == CAL_WAITING) {
 				*isCalDone = false;
@@ -766,7 +753,7 @@ bool ath9k_hw_calibrate(struct ath_hal *ah, struct ath9k_channel *chan,
 	return true;
 }
 
-static inline void ath9k_hw_9285_pa_cal(struct ath_hal *ah)
+static inline void ath9k_hw_9285_pa_cal(struct ath_hw *ah)
 {
 
 	u32 regVal;
@@ -861,11 +848,9 @@ static inline void ath9k_hw_9285_pa_cal(struct ath_hal *ah)
 
 }
 
-bool ath9k_hw_init_cal(struct ath_hal *ah,
+bool ath9k_hw_init_cal(struct ath_hw *ah,
 		       struct ath9k_channel *chan)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
-
 	REG_WRITE(ah, AR_PHY_AGC_CONTROL,
 		  REG_READ(ah, AR_PHY_AGC_CONTROL) |
 		  AR_PHY_AGC_CONTROL_CAL);
@@ -884,32 +869,32 @@ bool ath9k_hw_init_cal(struct ath_hal *ah,
 		  REG_READ(ah, AR_PHY_AGC_CONTROL) |
 		  AR_PHY_AGC_CONTROL_NF);
 
-	ahp->ah_cal_list = ahp->ah_cal_list_last = ahp->ah_cal_list_curr = NULL;
+	ah->ah_cal_list = ah->ah_cal_list_last = ah->ah_cal_list_curr = NULL;
 
 	if (AR_SREV_9100(ah) || AR_SREV_9160_10_OR_LATER(ah)) {
 		if (ath9k_hw_iscal_supported(ah, ADC_GAIN_CAL)) {
-			INIT_CAL(&ahp->ah_adcGainCalData);
-			INSERT_CAL(ahp, &ahp->ah_adcGainCalData);
+			INIT_CAL(&ah->ah_adcGainCalData);
+			INSERT_CAL(ah, &ah->ah_adcGainCalData);
 			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 				"enabling ADC Gain Calibration.\n");
 		}
 		if (ath9k_hw_iscal_supported(ah, ADC_DC_CAL)) {
-			INIT_CAL(&ahp->ah_adcDcCalData);
-			INSERT_CAL(ahp, &ahp->ah_adcDcCalData);
+			INIT_CAL(&ah->ah_adcDcCalData);
+			INSERT_CAL(ah, &ah->ah_adcDcCalData);
 			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 				"enabling ADC DC Calibration.\n");
 		}
 		if (ath9k_hw_iscal_supported(ah, IQ_MISMATCH_CAL)) {
-			INIT_CAL(&ahp->ah_iqCalData);
-			INSERT_CAL(ahp, &ahp->ah_iqCalData);
+			INIT_CAL(&ah->ah_iqCalData);
+			INSERT_CAL(ah, &ah->ah_iqCalData);
 			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 				"enabling IQ Calibration.\n");
 		}
 
-		ahp->ah_cal_list_curr = ahp->ah_cal_list;
+		ah->ah_cal_list_curr = ah->ah_cal_list;
 
-		if (ahp->ah_cal_list_curr)
-			ath9k_hw_reset_calibration(ah, ahp->ah_cal_list_curr);
+		if (ah->ah_cal_list_curr)
+			ath9k_hw_reset_calibration(ah, ah->ah_cal_list_curr);
 	}
 
 	chan->CalValid = 0;
diff --git a/drivers/net/wireless/ath9k/calib.h b/drivers/net/wireless/ath9k/calib.h
index ac7d88f..e2c6140 100644
--- a/drivers/net/wireless/ath9k/calib.h
+++ b/drivers/net/wireless/ath9k/calib.h
@@ -91,8 +91,8 @@ struct hal_percal_data {
 	enum hal_cal_types calType;
 	u32 calNumSamples;
 	u32 calCountMax;
-	void (*calCollect) (struct ath_hal *);
-	void (*calPostProc) (struct ath_hal *, u8);
+	void (*calCollect) (struct ath_hw *);
+	void (*calPostProc) (struct ath_hw *, u8);
 };
 
 struct hal_cal_list {
@@ -108,17 +108,17 @@ struct ath9k_nfcal_hist {
 	u8 invalidNFcount;
 };
 
-bool ath9k_hw_reset_calvalid(struct ath_hal *ah);
-void ath9k_hw_start_nfcal(struct ath_hal *ah);
-void ath9k_hw_loadnf(struct ath_hal *ah, struct ath9k_channel *chan);
-int16_t ath9k_hw_getnf(struct ath_hal *ah,
+bool ath9k_hw_reset_calvalid(struct ath_hw *ah);
+void ath9k_hw_start_nfcal(struct ath_hw *ah);
+void ath9k_hw_loadnf(struct ath_hw *ah, struct ath9k_channel *chan);
+int16_t ath9k_hw_getnf(struct ath_hw *ah,
 		       struct ath9k_channel *chan);
-void ath9k_init_nfcal_hist_buffer(struct ath_hal *ah);
-s16 ath9k_hw_getchan_noise(struct ath_hal *ah, struct ath9k_channel *chan);
-bool ath9k_hw_calibrate(struct ath_hal *ah, struct ath9k_channel *chan,
+void ath9k_init_nfcal_hist_buffer(struct ath_hw *ah);
+s16 ath9k_hw_getchan_noise(struct ath_hw *ah, struct ath9k_channel *chan);
+bool ath9k_hw_calibrate(struct ath_hw *ah, struct ath9k_channel *chan,
 			u8 rxchainmask, bool longcal,
 			bool *isCalDone);
-bool ath9k_hw_init_cal(struct ath_hal *ah,
+bool ath9k_hw_init_cal(struct ath_hw *ah,
 		       struct ath9k_channel *chan);
 
 #endif /* CALIB_H */
diff --git a/drivers/net/wireless/ath9k/debug.c b/drivers/net/wireless/ath9k/debug.c
index daca5ce..800ad59 100644
--- a/drivers/net/wireless/ath9k/debug.c
+++ b/drivers/net/wireless/ath9k/debug.c
@@ -44,7 +44,7 @@ static ssize_t read_file_dma(struct file *file, char __user *user_buf,
 			     size_t count, loff_t *ppos)
 {
 	struct ath_softc *sc = file->private_data;
-	struct ath_hal *ah = sc->sc_ah;
+	struct ath_hw *ah = sc->sc_ah;
 	char buf[1024];
 	unsigned int len = 0;
 	u32 val[ATH9K_NUM_DMA_DEBUG_REGS];
diff --git a/drivers/net/wireless/ath9k/eeprom.c b/drivers/net/wireless/ath9k/eeprom.c
index d58d8a3..94e7993 100644
--- a/drivers/net/wireless/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath9k/eeprom.c
@@ -16,7 +16,7 @@
 
 #include "ath9k.h"
 
-static void ath9k_hw_analog_shift_rmw(struct ath_hal *ah,
+static void ath9k_hw_analog_shift_rmw(struct ath_hw *ah,
 				      u32 reg, u32 mask,
 				      u32 shift, u32 val)
 {
@@ -88,18 +88,17 @@ static inline bool ath9k_hw_get_lower_upper_index(u8 target, u8 *pList,
 	return false;
 }
 
-static inline bool ath9k_hw_nvram_read(struct ath_hal *ah, u32 off, u16 *data)
+static inline bool ath9k_hw_nvram_read(struct ath_hw *ah, u32 off, u16 *data)
 {
 	struct ath_softc *sc = ah->ah_sc;
 
 	return sc->bus_ops->eeprom_read(ah, off, data);
 }
 
-static bool ath9k_hw_fill_4k_eeprom(struct ath_hal *ah)
+static bool ath9k_hw_fill_4k_eeprom(struct ath_hw *ah)
 {
 #define SIZE_EEPROM_4K (sizeof(struct ar5416_eeprom_4k) / sizeof(u16))
-	struct ath_hal_5416 *ahp = AH5416(ah);
-	struct ar5416_eeprom_4k *eep = &ahp->ah_eeprom.map4k;
+	struct ar5416_eeprom_4k *eep = &ah->ah_eeprom.map4k;
 	u16 *eep_data;
 	int addr, eep_start_loc = 0;
 
@@ -124,11 +123,10 @@ static bool ath9k_hw_fill_4k_eeprom(struct ath_hal *ah)
 #undef SIZE_EEPROM_4K
 }
 
-static bool ath9k_hw_fill_def_eeprom(struct ath_hal *ah)
+static bool ath9k_hw_fill_def_eeprom(struct ath_hw *ah)
 {
 #define SIZE_EEPROM_DEF (sizeof(struct ar5416_eeprom_def) / sizeof(u16))
-	struct ath_hal_5416 *ahp = AH5416(ah);
-	struct ar5416_eeprom_def *eep = &ahp->ah_eeprom.def;
+	struct ar5416_eeprom_def *eep = &ah->ah_eeprom.def;
 	u16 *eep_data;
 	int addr, ar5416_eep_start_loc = 0x100;
 
@@ -147,23 +145,20 @@ static bool ath9k_hw_fill_def_eeprom(struct ath_hal *ah)
 #undef SIZE_EEPROM_DEF
 }
 
-static bool (*ath9k_fill_eeprom[]) (struct ath_hal *) = {
+static bool (*ath9k_fill_eeprom[]) (struct ath_hw *) = {
 	ath9k_hw_fill_def_eeprom,
 	ath9k_hw_fill_4k_eeprom
 };
 
-static inline bool ath9k_hw_fill_eeprom(struct ath_hal *ah)
+static inline bool ath9k_hw_fill_eeprom(struct ath_hw *ah)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
-
-	return ath9k_fill_eeprom[ahp->ah_eep_map](ah);
+	return ath9k_fill_eeprom[ah->ah_eep_map](ah);
 }
 
-static int ath9k_hw_check_def_eeprom(struct ath_hal *ah)
+static int ath9k_hw_check_def_eeprom(struct ath_hw *ah)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct ar5416_eeprom_def *eep =
-		(struct ar5416_eeprom_def *) &ahp->ah_eeprom.def;
+		(struct ar5416_eeprom_def *) &ah->ah_eeprom.def;
 	u16 *eepdata, temp, magic, magic2;
 	u32 sum = 0, el;
 	bool need_swap = false;
@@ -187,7 +182,7 @@ static int ath9k_hw_check_def_eeprom(struct ath_hal *ah)
 			if (magic2 == AR5416_EEPROM_MAGIC) {
 				size = sizeof(struct ar5416_eeprom_def);
 				need_swap = true;
-				eepdata = (u16 *) (&ahp->ah_eeprom);
+				eepdata = (u16 *) (&ah->ah_eeprom);
 
 				for (addr = 0; addr < size / sizeof(u16); addr++) {
 					temp = swab16(*eepdata);
@@ -214,16 +209,16 @@ static int ath9k_hw_check_def_eeprom(struct ath_hal *ah)
 		need_swap ? "True" : "False");
 
 	if (need_swap)
-		el = swab16(ahp->ah_eeprom.def.baseEepHeader.length);
+		el = swab16(ah->ah_eeprom.def.baseEepHeader.length);
 	else
-		el = ahp->ah_eeprom.def.baseEepHeader.length;
+		el = ah->ah_eeprom.def.baseEepHeader.length;
 
 	if (el > sizeof(struct ar5416_eeprom_def))
 		el = sizeof(struct ar5416_eeprom_def) / sizeof(u16);
 	else
 		el = el / sizeof(u16);
 
-	eepdata = (u16 *)(&ahp->ah_eeprom);
+	eepdata = (u16 *)(&ah->ah_eeprom);
 
 	for (i = 0; i < el; i++)
 		sum ^= *eepdata++;
@@ -277,23 +272,22 @@ static int ath9k_hw_check_def_eeprom(struct ath_hal *ah)
 		}
 	}
 
-	if (sum != 0xffff || ar5416_get_eep_ver(ahp) != AR5416_EEP_VER ||
-	    ar5416_get_eep_rev(ahp) < AR5416_EEP_NO_BACK_VER) {
+	if (sum != 0xffff || ar5416_get_eep_ver(ah) != AR5416_EEP_VER ||
+	    ar5416_get_eep_rev(ah) < AR5416_EEP_NO_BACK_VER) {
 		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
 			"Bad EEPROM checksum 0x%x or revision 0x%04x\n",
-			sum, ar5416_get_eep_ver(ahp));
+			sum, ar5416_get_eep_ver(ah));
 		return -EINVAL;
 	}
 
 	return 0;
 }
 
-static int ath9k_hw_check_4k_eeprom(struct ath_hal *ah)
+static int ath9k_hw_check_4k_eeprom(struct ath_hw *ah)
 {
 #define EEPROM_4K_SIZE (sizeof(struct ar5416_eeprom_4k) / sizeof(u16))
-	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct ar5416_eeprom_4k *eep =
-		(struct ar5416_eeprom_4k *) &ahp->ah_eeprom.map4k;
+		(struct ar5416_eeprom_4k *) &ah->ah_eeprom.map4k;
 	u16 *eepdata, temp, magic, magic2;
 	u32 sum = 0, el;
 	bool need_swap = false;
@@ -317,7 +311,7 @@ static int ath9k_hw_check_4k_eeprom(struct ath_hal *ah)
 
 			if (magic2 == AR5416_EEPROM_MAGIC) {
 				need_swap = true;
-				eepdata = (u16 *) (&ahp->ah_eeprom);
+				eepdata = (u16 *) (&ah->ah_eeprom);
 
 				for (addr = 0; addr < EEPROM_4K_SIZE; addr++) {
 					temp = swab16(*eepdata);
@@ -344,16 +338,16 @@ static int ath9k_hw_check_4k_eeprom(struct ath_hal *ah)
 		need_swap ? "True" : "False");
 
 	if (need_swap)
-		el = swab16(ahp->ah_eeprom.map4k.baseEepHeader.length);
+		el = swab16(ah->ah_eeprom.map4k.baseEepHeader.length);
 	else
-		el = ahp->ah_eeprom.map4k.baseEepHeader.length;
+		el = ah->ah_eeprom.map4k.baseEepHeader.length;
 
 	if (el > sizeof(struct ar5416_eeprom_def))
 		el = sizeof(struct ar5416_eeprom_4k) / sizeof(u16);
 	else
 		el = el / sizeof(u16);
 
-	eepdata = (u16 *)(&ahp->ah_eeprom);
+	eepdata = (u16 *)(&ah->ah_eeprom);
 
 	for (i = 0; i < el; i++)
 		sum ^= *eepdata++;
@@ -403,11 +397,11 @@ static int ath9k_hw_check_4k_eeprom(struct ath_hal *ah)
 		}
 	}
 
-	if (sum != 0xffff || ar5416_get_eep4k_ver(ahp) != AR5416_EEP_VER ||
-	    ar5416_get_eep4k_rev(ahp) < AR5416_EEP_NO_BACK_VER) {
+	if (sum != 0xffff || ar5416_get_eep4k_ver(ah) != AR5416_EEP_VER ||
+	    ar5416_get_eep4k_rev(ah) < AR5416_EEP_NO_BACK_VER) {
 		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
 			"Bad EEPROM checksum 0x%x or revision 0x%04x\n",
-			sum, ar5416_get_eep4k_ver(ahp));
+			sum, ar5416_get_eep4k_ver(ah));
 		return -EINVAL;
 	}
 
@@ -415,16 +409,14 @@ static int ath9k_hw_check_4k_eeprom(struct ath_hal *ah)
 #undef EEPROM_4K_SIZE
 }
 
-static int (*ath9k_check_eeprom[]) (struct ath_hal *) = {
+static int (*ath9k_check_eeprom[]) (struct ath_hw *) = {
 	ath9k_hw_check_def_eeprom,
 	ath9k_hw_check_4k_eeprom
 };
 
-static inline int ath9k_hw_check_eeprom(struct ath_hal *ah)
+static inline int ath9k_hw_check_eeprom(struct ath_hw *ah)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
-
-	return ath9k_check_eeprom[ahp->ah_eep_map](ah);
+	return ath9k_check_eeprom[ah->ah_eep_map](ah);
 }
 
 static inline bool ath9k_hw_fill_vpd_table(u8 pwrMin, u8 pwrMax, u8 *pPwrList,
@@ -456,7 +448,7 @@ static inline bool ath9k_hw_fill_vpd_table(u8 pwrMin, u8 pwrMax, u8 *pPwrList,
 	return true;
 }
 
-static void ath9k_hw_get_4k_gain_boundaries_pdadcs(struct ath_hal *ah,
+static void ath9k_hw_get_4k_gain_boundaries_pdadcs(struct ath_hw *ah,
 				struct ath9k_channel *chan,
 				struct cal_data_per_freq_4k *pRawDataSet,
 				u8 *bChans, u16 availPiers,
@@ -624,7 +616,7 @@ static void ath9k_hw_get_4k_gain_boundaries_pdadcs(struct ath_hal *ah,
 #undef TMP_VAL_VPD_TABLE
 }
 
-static void ath9k_hw_get_def_gain_boundaries_pdadcs(struct ath_hal *ah,
+static void ath9k_hw_get_def_gain_boundaries_pdadcs(struct ath_hw *ah,
 				struct ath9k_channel *chan,
 				struct cal_data_per_freq *pRawDataSet,
 				u8 *bChans, u16 availPiers,
@@ -789,7 +781,7 @@ static void ath9k_hw_get_def_gain_boundaries_pdadcs(struct ath_hal *ah,
 	return;
 }
 
-static void ath9k_hw_get_legacy_target_powers(struct ath_hal *ah,
+static void ath9k_hw_get_legacy_target_powers(struct ath_hw *ah,
 				      struct ath9k_channel *chan,
 				      struct cal_target_power_leg *powInfo,
 				      u16 numChannels,
@@ -844,7 +836,7 @@ static void ath9k_hw_get_legacy_target_powers(struct ath_hal *ah,
 	}
 }
 
-static void ath9k_hw_get_target_powers(struct ath_hal *ah,
+static void ath9k_hw_get_target_powers(struct ath_hw *ah,
 				       struct ath9k_channel *chan,
 				       struct cal_target_power_ht *powInfo,
 				       u16 numChannels,
@@ -927,12 +919,11 @@ static u16 ath9k_hw_get_max_edge_power(u16 freq,
 	return twiceMaxEdgePower;
 }
 
-static bool ath9k_hw_set_def_power_cal_table(struct ath_hal *ah,
+static bool ath9k_hw_set_def_power_cal_table(struct ath_hw *ah,
 				  struct ath9k_channel *chan,
 				  int16_t *pTxPowerIndexOffset)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
-	struct ar5416_eeprom_def *pEepData = &ahp->ah_eeprom.def;
+	struct ar5416_eeprom_def *pEepData = &ah->ah_eeprom.def;
 	struct cal_data_per_freq *pRawDataset;
 	u8 *pCalBChans = NULL;
 	u16 pdGainOverlap_t2;
@@ -988,7 +979,7 @@ static bool ath9k_hw_set_def_power_cal_table(struct ath_hal *ah,
 
 	for (i = 0; i < AR5416_MAX_CHAINS; i++) {
 		if (AR_SREV_5416_V20_OR_LATER(ah) &&
-		    (ahp->ah_rxchainmask == 5 || ahp->ah_txchainmask == 5) &&
+		    (ah->ah_rxchainmask == 5 || ah->ah_txchainmask == 5) &&
 		    (i != 0)) {
 			regChainOffset = (i == 1) ? 0x2000 : 0x1000;
 		} else
@@ -1054,12 +1045,11 @@ static bool ath9k_hw_set_def_power_cal_table(struct ath_hal *ah,
 	return true;
 }
 
-static bool ath9k_hw_set_4k_power_cal_table(struct ath_hal *ah,
+static bool ath9k_hw_set_4k_power_cal_table(struct ath_hw *ah,
 				  struct ath9k_channel *chan,
 				  int16_t *pTxPowerIndexOffset)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
-	struct ar5416_eeprom_4k *pEepData = &ahp->ah_eeprom.map4k;
+	struct ar5416_eeprom_4k *pEepData = &ah->ah_eeprom.map4k;
 	struct cal_data_per_freq_4k *pRawDataset;
 	u8 *pCalBChans = NULL;
 	u16 pdGainOverlap_t2;
@@ -1108,7 +1098,7 @@ static bool ath9k_hw_set_4k_power_cal_table(struct ath_hal *ah,
 
 	for (i = 0; i < AR5416_MAX_CHAINS; i++) {
 		if (AR_SREV_5416_V20_OR_LATER(ah) &&
-		    (ahp->ah_rxchainmask == 5 || ahp->ah_txchainmask == 5) &&
+		    (ah->ah_rxchainmask == 5 || ah->ah_txchainmask == 5) &&
 		    (i != 0)) {
 			regChainOffset = (i == 1) ? 0x2000 : 0x1000;
 		} else
@@ -1171,7 +1161,7 @@ static bool ath9k_hw_set_4k_power_cal_table(struct ath_hal *ah,
 	return true;
 }
 
-static bool ath9k_hw_set_def_power_per_rate_table(struct ath_hal *ah,
+static bool ath9k_hw_set_def_power_per_rate_table(struct ath_hw *ah,
 						  struct ath9k_channel *chan,
 						  int16_t *ratesArray,
 						  u16 cfgCtl,
@@ -1182,8 +1172,7 @@ static bool ath9k_hw_set_def_power_per_rate_table(struct ath_hal *ah,
 #define REDUCE_SCALED_POWER_BY_TWO_CHAIN     6  /* 10*log10(2)*2 */
 #define REDUCE_SCALED_POWER_BY_THREE_CHAIN   10 /* 10*log10(3)*2 */
 
-	struct ath_hal_5416 *ahp = AH5416(ah);
-	struct ar5416_eeprom_def *pEepData = &ahp->ah_eeprom.def;
+	struct ar5416_eeprom_def *pEepData = &ah->ah_eeprom.def;
 	u16 twiceMaxEdgePower = AR5416_MAX_RATE_POWER;
 	static const u16 tpScaleReductionTable[5] =
 		{ 0, 3, 6, 9, AR5416_MAX_RATE_POWER };
@@ -1213,7 +1202,7 @@ static bool ath9k_hw_set_def_power_per_rate_table(struct ath_hal *ah,
 	int tx_chainmask;
 	u16 twiceMinEdgePower;
 
-	tx_chainmask = ahp->ah_txchainmask;
+	tx_chainmask = ah->ah_txchainmask;
 
 	ath9k_hw_get_channel_centers(ah, chan, &centers);
 
@@ -1322,7 +1311,7 @@ static bool ath9k_hw_set_def_power_per_rate_table(struct ath_hal *ah,
 		else
 			freq = centers.ctl_center;
 
-		if (ar5416_get_eep_ver(ahp) == 14 && ar5416_get_eep_rev(ahp) <= 2)
+		if (ar5416_get_eep_ver(ah) == 14 && ar5416_get_eep_rev(ah) <= 2)
 			twiceMaxEdgePower = AR5416_MAX_RATE_POWER;
 
 		DPRINTF(ah->ah_sc, ATH_DBG_POWER_MGMT,
@@ -1462,7 +1451,7 @@ static bool ath9k_hw_set_def_power_per_rate_table(struct ath_hal *ah,
 	return true;
 }
 
-static bool ath9k_hw_set_4k_power_per_rate_table(struct ath_hal *ah,
+static bool ath9k_hw_set_4k_power_per_rate_table(struct ath_hw *ah,
 						 struct ath9k_channel *chan,
 						 int16_t *ratesArray,
 						 u16 cfgCtl,
@@ -1470,8 +1459,7 @@ static bool ath9k_hw_set_4k_power_per_rate_table(struct ath_hal *ah,
 						 u16 twiceMaxRegulatoryPower,
 						 u16 powerLimit)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
-	struct ar5416_eeprom_4k *pEepData = &ahp->ah_eeprom.map4k;
+	struct ar5416_eeprom_4k *pEepData = &ah->ah_eeprom.map4k;
 	u16 twiceMaxEdgePower = AR5416_MAX_RATE_POWER;
 	static const u16 tpScaleReductionTable[5] =
 		{ 0, 3, 6, 9, AR5416_MAX_RATE_POWER };
@@ -1499,7 +1487,7 @@ static bool ath9k_hw_set_4k_power_per_rate_table(struct ath_hal *ah,
 	int tx_chainmask;
 	u16 twiceMinEdgePower;
 
-	tx_chainmask = ahp->ah_txchainmask;
+	tx_chainmask = ah->ah_txchainmask;
 
 	ath9k_hw_get_channel_centers(ah, chan, &centers);
 
@@ -1560,8 +1548,8 @@ static bool ath9k_hw_set_4k_power_per_rate_table(struct ath_hal *ah,
 		else
 			freq = centers.ctl_center;
 
-		if (ar5416_get_eep_ver(ahp) == 14 &&
-				ar5416_get_eep_rev(ahp) <= 2)
+		if (ar5416_get_eep_ver(ah) == 14 &&
+				ar5416_get_eep_rev(ah) <= 2)
 			twiceMaxEdgePower = AR5416_MAX_RATE_POWER;
 
 		DPRINTF(ah->ah_sc, ATH_DBG_POWER_MGMT,
@@ -1698,15 +1686,14 @@ static bool ath9k_hw_set_4k_power_per_rate_table(struct ath_hal *ah,
 	return true;
 }
 
-static int ath9k_hw_def_set_txpower(struct ath_hal *ah,
+static int ath9k_hw_def_set_txpower(struct ath_hw *ah,
 			 struct ath9k_channel *chan,
 			 u16 cfgCtl,
 			 u8 twiceAntennaReduction,
 			 u8 twiceMaxRegulatoryPower,
 			 u8 powerLimit)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
-	struct ar5416_eeprom_def *pEepData = &ahp->ah_eeprom.def;
+	struct ar5416_eeprom_def *pEepData = &ah->ah_eeprom.def;
 	struct modal_eep_header *pModal =
 		&(pEepData->modalHeader[IS_CHAN_2GHZ(chan)]);
 	int16_t ratesArray[Ar5416RateSize];
@@ -1831,15 +1818,14 @@ static int ath9k_hw_def_set_txpower(struct ath_hal *ah,
 	return 0;
 }
 
-static int ath9k_hw_4k_set_txpower(struct ath_hal *ah,
+static int ath9k_hw_4k_set_txpower(struct ath_hw *ah,
 			 struct ath9k_channel *chan,
 			 u16 cfgCtl,
 			 u8 twiceAntennaReduction,
 			 u8 twiceMaxRegulatoryPower,
 			 u8 powerLimit)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
-	struct ar5416_eeprom_4k *pEepData = &ahp->ah_eeprom.map4k;
+	struct ar5416_eeprom_4k *pEepData = &ah->ah_eeprom.map4k;
 	struct modal_eep_4k_header *pModal = &pEepData->modalHeader;
 	int16_t ratesArray[Ar5416RateSize];
 	int16_t txPowerIndexOffset = 0;
@@ -1959,40 +1945,37 @@ static int ath9k_hw_4k_set_txpower(struct ath_hal *ah,
 	return 0;
 }
 
-static int (*ath9k_set_txpower[]) (struct ath_hal *,
+static int (*ath9k_set_txpower[]) (struct ath_hw *,
 				   struct ath9k_channel *,
 				   u16, u8, u8, u8) = {
 	ath9k_hw_def_set_txpower,
 	ath9k_hw_4k_set_txpower
 };
 
-int ath9k_hw_set_txpower(struct ath_hal *ah,
+int ath9k_hw_set_txpower(struct ath_hw *ah,
 			 struct ath9k_channel *chan,
 			 u16 cfgCtl,
 			 u8 twiceAntennaReduction,
 			 u8 twiceMaxRegulatoryPower,
 			 u8 powerLimit)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
-
-	return ath9k_set_txpower[ahp->ah_eep_map](ah, chan, cfgCtl,
-			twiceAntennaReduction, twiceMaxRegulatoryPower,
-			powerLimit);
+	return ath9k_set_txpower[ah->ah_eep_map](ah, chan, cfgCtl,
+				 twiceAntennaReduction, twiceMaxRegulatoryPower,
+				 powerLimit);
 }
 
-static void ath9k_hw_set_def_addac(struct ath_hal *ah,
+static void ath9k_hw_set_def_addac(struct ath_hw *ah,
 				   struct ath9k_channel *chan)
 {
 #define XPA_LVL_FREQ(cnt) (pModal->xpaBiasLvlFreq[cnt])
 	struct modal_eep_header *pModal;
-	struct ath_hal_5416 *ahp = AH5416(ah);
-	struct ar5416_eeprom_def *eep = &ahp->ah_eeprom.def;
+	struct ar5416_eeprom_def *eep = &ah->ah_eeprom.def;
 	u8 biaslevel;
 
 	if (ah->hw_version.macVersion != AR_SREV_VERSION_9160)
 		return;
 
-	if (ar5416_get_eep_rev(ahp) < AR5416_EEP_MINOR_VER_7)
+	if (ar5416_get_eep_rev(ah) < AR5416_EEP_MINOR_VER_7)
 		return;
 
 	pModal = &(eep->modalHeader[IS_CHAN_2GHZ(chan)]);
@@ -2026,60 +2009,54 @@ static void ath9k_hw_set_def_addac(struct ath_hal *ah,
 	}
 
 	if (IS_CHAN_2GHZ(chan)) {
-		INI_RA(&ahp->ah_iniAddac, 7, 1) = (INI_RA(&ahp->ah_iniAddac,
+		INI_RA(&ah->ah_iniAddac, 7, 1) = (INI_RA(&ah->ah_iniAddac,
 					7, 1) & (~0x18)) | biaslevel << 3;
 	} else {
-		INI_RA(&ahp->ah_iniAddac, 6, 1) = (INI_RA(&ahp->ah_iniAddac,
+		INI_RA(&ah->ah_iniAddac, 6, 1) = (INI_RA(&ah->ah_iniAddac,
 					6, 1) & (~0xc0)) | biaslevel << 6;
 	}
 #undef XPA_LVL_FREQ
 }
 
-static void ath9k_hw_set_4k_addac(struct ath_hal *ah,
+static void ath9k_hw_set_4k_addac(struct ath_hw *ah,
 				  struct ath9k_channel *chan)
 {
 	struct modal_eep_4k_header *pModal;
-	struct ath_hal_5416 *ahp = AH5416(ah);
-	struct ar5416_eeprom_4k *eep = &ahp->ah_eeprom.map4k;
+	struct ar5416_eeprom_4k *eep = &ah->ah_eeprom.map4k;
 	u8 biaslevel;
 
 	if (ah->hw_version.macVersion != AR_SREV_VERSION_9160)
 		return;
 
-	if (ar5416_get_eep_rev(ahp) < AR5416_EEP_MINOR_VER_7)
+	if (ar5416_get_eep_rev(ah) < AR5416_EEP_MINOR_VER_7)
 		return;
 
 	pModal = &eep->modalHeader;
 
 	if (pModal->xpaBiasLvl != 0xff) {
 		biaslevel = pModal->xpaBiasLvl;
-		INI_RA(&ahp->ah_iniAddac, 7, 1) =
-		  (INI_RA(&ahp->ah_iniAddac, 7, 1) & (~0x18)) | biaslevel << 3;
+		INI_RA(&ah->ah_iniAddac, 7, 1) =
+		  (INI_RA(&ah->ah_iniAddac, 7, 1) & (~0x18)) | biaslevel << 3;
 	}
 }
 
-static void (*ath9k_set_addac[]) (struct ath_hal *, struct ath9k_channel *) = {
+static void (*ath9k_set_addac[]) (struct ath_hw *, struct ath9k_channel *) = {
 	ath9k_hw_set_def_addac,
 	ath9k_hw_set_4k_addac
 };
 
-void ath9k_hw_set_addac(struct ath_hal *ah, struct ath9k_channel *chan)
+void ath9k_hw_set_addac(struct ath_hw *ah, struct ath9k_channel *chan)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
-
-	ath9k_set_addac[ahp->ah_eep_map](ah, chan);
+	ath9k_set_addac[ah->ah_eep_map](ah, chan);
 }
 
-
-
 /* XXX: Clean me up, make me more legible */
-static bool ath9k_hw_eeprom_set_def_board_values(struct ath_hal *ah,
+static bool ath9k_hw_eeprom_set_def_board_values(struct ath_hw *ah,
 				      struct ath9k_channel *chan)
 {
 #define AR5416_VER_MASK (eep->baseEepHeader.version & AR5416_EEP_VER_MINOR_MASK)
 	struct modal_eep_header *pModal;
-	struct ath_hal_5416 *ahp = AH5416(ah);
-	struct ar5416_eeprom_def *eep = &ahp->ah_eeprom.def;
+	struct ar5416_eeprom_def *eep = &ah->ah_eeprom.def;
 	int i, regChainOffset;
 	u8 txRxAttenLocal;
 
@@ -2097,7 +2074,7 @@ static bool ath9k_hw_eeprom_set_def_board_values(struct ath_hal *ah,
 		}
 
 		if (AR_SREV_5416_V20_OR_LATER(ah) &&
-		    (ahp->ah_rxchainmask == 5 || ahp->ah_txchainmask == 5)
+		    (ah->ah_rxchainmask == 5 || ah->ah_txchainmask == 5)
 		    && (i != 0))
 			regChainOffset = (i == 1) ? 0x2000 : 0x1000;
 		else
@@ -2318,12 +2295,11 @@ static bool ath9k_hw_eeprom_set_def_board_values(struct ath_hal *ah,
 #undef AR5416_VER_MASK
 }
 
-static bool ath9k_hw_eeprom_set_4k_board_values(struct ath_hal *ah,
+static bool ath9k_hw_eeprom_set_4k_board_values(struct ath_hw *ah,
 				      struct ath9k_channel *chan)
 {
 	struct modal_eep_4k_header *pModal;
-	struct ath_hal_5416 *ahp = AH5416(ah);
-	struct ar5416_eeprom_4k *eep = &ahp->ah_eeprom.map4k;
+	struct ar5416_eeprom_4k *eep = &ah->ah_eeprom.map4k;
 	int regChainOffset;
 	u8 txRxAttenLocal;
 	u8 ob[5], db1[5], db2[5];
@@ -2505,66 +2481,59 @@ static bool ath9k_hw_eeprom_set_4k_board_values(struct ath_hal *ah,
 	return true;
 }
 
-static bool (*ath9k_eeprom_set_board_values[])(struct ath_hal *,
+static bool (*ath9k_eeprom_set_board_values[])(struct ath_hw *,
 					       struct ath9k_channel *) = {
 	ath9k_hw_eeprom_set_def_board_values,
 	ath9k_hw_eeprom_set_4k_board_values
 };
 
-bool ath9k_hw_eeprom_set_board_values(struct ath_hal *ah,
+bool ath9k_hw_eeprom_set_board_values(struct ath_hw *ah,
 				      struct ath9k_channel *chan)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
-
-	return ath9k_eeprom_set_board_values[ahp->ah_eep_map](ah, chan);
+	return ath9k_eeprom_set_board_values[ah->ah_eep_map](ah, chan);
 }
 
-static u16 ath9k_hw_get_def_eeprom_antenna_cfg(struct ath_hal *ah,
+static u16 ath9k_hw_get_def_eeprom_antenna_cfg(struct ath_hw *ah,
 					       struct ath9k_channel *chan)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
-	struct ar5416_eeprom_def *eep = &ahp->ah_eeprom.def;
+	struct ar5416_eeprom_def *eep = &ah->ah_eeprom.def;
 	struct modal_eep_header *pModal =
 		&(eep->modalHeader[IS_CHAN_2GHZ(chan)]);
 
 	return pModal->antCtrlCommon & 0xFFFF;
 }
 
-static u16 ath9k_hw_get_4k_eeprom_antenna_cfg(struct ath_hal *ah,
+static u16 ath9k_hw_get_4k_eeprom_antenna_cfg(struct ath_hw *ah,
 					      struct ath9k_channel *chan)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
-	struct ar5416_eeprom_4k *eep = &ahp->ah_eeprom.map4k;
+	struct ar5416_eeprom_4k *eep = &ah->ah_eeprom.map4k;
 	struct modal_eep_4k_header *pModal = &eep->modalHeader;
 
 	return pModal->antCtrlCommon & 0xFFFF;
 }
 
-static u16 (*ath9k_get_eeprom_antenna_cfg[])(struct ath_hal *,
+static u16 (*ath9k_get_eeprom_antenna_cfg[])(struct ath_hw *,
 					     struct ath9k_channel *) = {
 	ath9k_hw_get_def_eeprom_antenna_cfg,
 	ath9k_hw_get_4k_eeprom_antenna_cfg
 };
 
-u16 ath9k_hw_get_eeprom_antenna_cfg(struct ath_hal *ah,
+u16 ath9k_hw_get_eeprom_antenna_cfg(struct ath_hw *ah,
 				    struct ath9k_channel *chan)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
-
-	return ath9k_get_eeprom_antenna_cfg[ahp->ah_eep_map](ah, chan);
+	return ath9k_get_eeprom_antenna_cfg[ah->ah_eep_map](ah, chan);
 }
 
-static u8 ath9k_hw_get_4k_num_ant_config(struct ath_hal *ah,
+static u8 ath9k_hw_get_4k_num_ant_config(struct ath_hw *ah,
 					 enum ieee80211_band freq_band)
 {
 	return 1;
 }
 
-static u8 ath9k_hw_get_def_num_ant_config(struct ath_hal *ah,
+static u8 ath9k_hw_get_def_num_ant_config(struct ath_hw *ah,
 					  enum ieee80211_band freq_band)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
-	struct ar5416_eeprom_def *eep = &ahp->ah_eeprom.def;
+	struct ar5416_eeprom_def *eep = &ah->ah_eeprom.def;
 	struct modal_eep_header *pModal =
 		&(eep->modalHeader[ATH9K_HAL_FREQ_BAND_2GHZ == freq_band]);
 	struct base_eep_header *pBase = &eep->baseEepHeader;
@@ -2579,27 +2548,24 @@ static u8 ath9k_hw_get_def_num_ant_config(struct ath_hal *ah,
 	return num_ant_config;
 }
 
-static u8 (*ath9k_get_num_ant_config[])(struct ath_hal *,
+static u8 (*ath9k_get_num_ant_config[])(struct ath_hw *,
 					enum ieee80211_band) = {
 	ath9k_hw_get_def_num_ant_config,
 	ath9k_hw_get_4k_num_ant_config
 };
 
-u8 ath9k_hw_get_num_ant_config(struct ath_hal *ah,
+u8 ath9k_hw_get_num_ant_config(struct ath_hw *ah,
 			       enum ieee80211_band freq_band)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
-
-	return ath9k_get_num_ant_config[ahp->ah_eep_map](ah, freq_band);
+	return ath9k_get_num_ant_config[ah->ah_eep_map](ah, freq_band);
 }
 
-u16 ath9k_hw_eeprom_get_spur_chan(struct ath_hal *ah, u16 i, bool is2GHz)
+u16 ath9k_hw_eeprom_get_spur_chan(struct ath_hw *ah, u16 i, bool is2GHz)
 {
 #define EEP_MAP4K_SPURCHAN \
-	(ahp->ah_eeprom.map4k.modalHeader.spurChans[i].spurChan)
+	(ah->ah_eeprom.map4k.modalHeader.spurChans[i].spurChan)
 #define EEP_DEF_SPURCHAN \
-	(ahp->ah_eeprom.def.modalHeader[is2GHz].spurChans[i].spurChan)
-	struct ath_hal_5416 *ahp = AH5416(ah);
+	(ah->ah_eeprom.def.modalHeader[is2GHz].spurChans[i].spurChan)
 	u16 spur_val = AR_NO_SPUR;
 
 	DPRINTF(ah->ah_sc, ATH_DBG_ANI,
@@ -2615,7 +2581,7 @@ u16 ath9k_hw_eeprom_get_spur_chan(struct ath_hal *ah, u16 i, bool is2GHz)
 			"Getting spur val from new loc. %d\n", spur_val);
 		break;
 	case SPUR_ENABLE_EEPROM:
-		if (ahp->ah_eep_map == EEP_MAP_4KBITS)
+		if (ah->ah_eep_map == EEP_MAP_4KBITS)
 			spur_val = EEP_MAP4K_SPURCHAN;
 		else
 			spur_val = EEP_DEF_SPURCHAN;
@@ -2628,11 +2594,10 @@ u16 ath9k_hw_eeprom_get_spur_chan(struct ath_hal *ah, u16 i, bool is2GHz)
 #undef EEP_MAP4K_SPURCHAN
 }
 
-static u32 ath9k_hw_get_eeprom_4k(struct ath_hal *ah,
+static u32 ath9k_hw_get_eeprom_4k(struct ath_hw *ah,
 				  enum eeprom_param param)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
-	struct ar5416_eeprom_4k *eep = &ahp->ah_eeprom.map4k;
+	struct ar5416_eeprom_4k *eep = &ah->ah_eeprom.map4k;
 	struct modal_eep_4k_header *pModal = &eep->modalHeader;
 	struct base_eep_header_4k *pBase = &eep->baseEepHeader;
 
@@ -2670,12 +2635,11 @@ static u32 ath9k_hw_get_eeprom_4k(struct ath_hal *ah,
 	}
 }
 
-static u32 ath9k_hw_get_eeprom_def(struct ath_hal *ah,
+static u32 ath9k_hw_get_eeprom_def(struct ath_hw *ah,
 				   enum eeprom_param param)
 {
 #define AR5416_VER_MASK (pBase->version & AR5416_EEP_VER_MINOR_MASK)
-	struct ath_hal_5416 *ahp = AH5416(ah);
-	struct ar5416_eeprom_def *eep = &ahp->ah_eeprom.def;
+	struct ar5416_eeprom_def *eep = &ah->ah_eeprom.def;
 	struct modal_eep_header *pModal = eep->modalHeader;
 	struct base_eep_header *pBase = &eep->baseEepHeader;
 
@@ -2729,28 +2693,25 @@ static u32 ath9k_hw_get_eeprom_def(struct ath_hal *ah,
 #undef AR5416_VER_MASK
 }
 
-static u32 (*ath9k_get_eeprom[])(struct ath_hal *, enum eeprom_param) = {
+static u32 (*ath9k_get_eeprom[])(struct ath_hw *, enum eeprom_param) = {
 	ath9k_hw_get_eeprom_def,
 	ath9k_hw_get_eeprom_4k
 };
 
-u32 ath9k_hw_get_eeprom(struct ath_hal *ah,
+u32 ath9k_hw_get_eeprom(struct ath_hw *ah,
 			enum eeprom_param param)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
-
-	return ath9k_get_eeprom[ahp->ah_eep_map](ah, param);
+	return ath9k_get_eeprom[ah->ah_eep_map](ah, param);
 }
 
-int ath9k_hw_eeprom_attach(struct ath_hal *ah)
+int ath9k_hw_eeprom_attach(struct ath_hw *ah)
 {
 	int status;
-	struct ath_hal_5416 *ahp = AH5416(ah);
 
 	if (AR_SREV_9285(ah))
-		ahp->ah_eep_map = EEP_MAP_4KBITS;
+		ah->ah_eep_map = EEP_MAP_4KBITS;
 	else
-		ahp->ah_eep_map = EEP_MAP_DEFAULT;
+		ah->ah_eep_map = EEP_MAP_DEFAULT;
 
 	if (!ath9k_hw_fill_eeprom(ah))
 		return -EIO;
diff --git a/drivers/net/wireless/ath9k/eeprom.h b/drivers/net/wireless/ath9k/eeprom.h
index 9eb7774..81a7a70 100644
--- a/drivers/net/wireless/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath9k/eeprom.h
@@ -447,38 +447,38 @@ enum hal_eep_map {
 	EEP_MAP_MAX
 };
 
-#define ar5416_get_eep_ver(_ahp) \
-	(((_ahp)->ah_eeprom.def.baseEepHeader.version >> 12) & 0xF)
-#define ar5416_get_eep_rev(_ahp) \
-	(((_ahp)->ah_eeprom.def.baseEepHeader.version) & 0xFFF)
+#define ar5416_get_eep_ver(_ah) \
+	(((_ah)->ah_eeprom.def.baseEepHeader.version >> 12) & 0xF)
+#define ar5416_get_eep_rev(_ah) \
+	(((_ah)->ah_eeprom.def.baseEepHeader.version) & 0xFFF)
 #define ar5416_get_ntxchains(_txchainmask)			\
 	(((_txchainmask >> 2) & 1) +				\
 	 ((_txchainmask >> 1) & 1) + (_txchainmask & 1))
 
-#define ar5416_get_eep4k_ver(_ahp) \
-	(((_ahp)->ah_eeprom.map4k.baseEepHeader.version >> 12) & 0xF)
-#define ar5416_get_eep4k_rev(_ahp) \
-	(((_ahp)->ah_eeprom.map4k.baseEepHeader.version) & 0xFFF)
+#define ar5416_get_eep4k_ver(_ah) \
+	(((_ah)->ah_eeprom.map4k.baseEepHeader.version >> 12) & 0xF)
+#define ar5416_get_eep4k_rev(_ah) \
+	(((_ah)->ah_eeprom.map4k.baseEepHeader.version) & 0xFFF)
 
-int ath9k_hw_set_txpower(struct ath_hal *ah, struct ath9k_channel *chan,
+int ath9k_hw_set_txpower(struct ath_hw *ah, struct ath9k_channel *chan,
 			 u16 cfgCtl, u8 twiceAntennaReduction,
 			 u8 twiceMaxRegulatoryPower, u8 powerLimit);
-void ath9k_hw_set_addac(struct ath_hal *ah, struct ath9k_channel *chan);
-bool ath9k_hw_set_power_per_rate_table(struct ath_hal *ah,
+void ath9k_hw_set_addac(struct ath_hw *ah, struct ath9k_channel *chan);
+bool ath9k_hw_set_power_per_rate_table(struct ath_hw *ah,
 		       struct ath9k_channel *chan, int16_t *ratesArray,
 		       u16 cfgCtl, u8 AntennaReduction,
 		       u8 twiceMaxRegulatoryPower, u8 powerLimit);
-bool ath9k_hw_set_power_cal_table(struct ath_hal *ah,
+bool ath9k_hw_set_power_cal_table(struct ath_hw *ah,
 				  struct ath9k_channel *chan,
 				  int16_t *pTxPowerIndexOffset);
-bool ath9k_hw_eeprom_set_board_values(struct ath_hal *ah,
+bool ath9k_hw_eeprom_set_board_values(struct ath_hw *ah,
 				      struct ath9k_channel *chan);
-u16 ath9k_hw_get_eeprom_antenna_cfg(struct ath_hal *ah,
+u16 ath9k_hw_get_eeprom_antenna_cfg(struct ath_hw *ah,
 				    struct ath9k_channel *chan);
-u8 ath9k_hw_get_num_ant_config(struct ath_hal *ah,
+u8 ath9k_hw_get_num_ant_config(struct ath_hw *ah,
 			       enum ieee80211_band freq_band);
-u16 ath9k_hw_eeprom_get_spur_chan(struct ath_hal *ah, u16 i, bool is2GHz);
-u32 ath9k_hw_get_eeprom(struct ath_hal *ah, enum eeprom_param param);
-int ath9k_hw_eeprom_attach(struct ath_hal *ah);
+u16 ath9k_hw_eeprom_get_spur_chan(struct ath_hw *ah, u16 i, bool is2GHz);
+u32 ath9k_hw_get_eeprom(struct ath_hw *ah, enum eeprom_param param);
+int ath9k_hw_eeprom_attach(struct ath_hw *ah);
 
 #endif /* EEPROM_H */
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 5d72875..ba908e9 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -28,41 +28,45 @@ MODULE_PARM_DESC(btcoex_enable, "Enable Bluetooth coexistence support");
 #define ATH9K_CLOCK_RATE_5GHZ_OFDM	40
 #define ATH9K_CLOCK_RATE_2GHZ_OFDM	44
 
-static bool ath9k_hw_set_reset_reg(struct ath_hal *ah, u32 type);
-static void ath9k_hw_set_regs(struct ath_hal *ah, struct ath9k_channel *chan,
+static bool ath9k_hw_set_reset_reg(struct ath_hw *ah, u32 type);
+static void ath9k_hw_set_regs(struct ath_hw *ah, struct ath9k_channel *chan,
 			      enum ath9k_ht_macmode macmode);
-static u32 ath9k_hw_ini_fixup(struct ath_hal *ah,
+static u32 ath9k_hw_ini_fixup(struct ath_hw *ah,
 			      struct ar5416_eeprom_def *pEepData,
 			      u32 reg, u32 value);
-static void ath9k_hw_9280_spur_mitigate(struct ath_hal *ah, struct ath9k_channel *chan);
-static void ath9k_hw_spur_mitigate(struct ath_hal *ah, struct ath9k_channel *chan);
+static void ath9k_hw_9280_spur_mitigate(struct ath_hw *ah, struct ath9k_channel *chan);
+static void ath9k_hw_spur_mitigate(struct ath_hw *ah, struct ath9k_channel *chan);
 
 /********************/
 /* Helper Functions */
 /********************/
 
-static u32 ath9k_hw_mac_usec(struct ath_hal *ah, u32 clks)
+static u32 ath9k_hw_mac_usec(struct ath_hw *ah, u32 clks)
 {
 	struct ieee80211_conf *conf = &ah->ah_sc->hw->conf;
+
 	if (!ah->ah_curchan) /* should really check for CCK instead */
 		return clks / ATH9K_CLOCK_RATE_CCK;
 	if (conf->channel->band == IEEE80211_BAND_2GHZ)
 		return clks / ATH9K_CLOCK_RATE_2GHZ_OFDM;
+
 	return clks / ATH9K_CLOCK_RATE_5GHZ_OFDM;
 }
 
-static u32 ath9k_hw_mac_to_usec(struct ath_hal *ah, u32 clks)
+static u32 ath9k_hw_mac_to_usec(struct ath_hw *ah, u32 clks)
 {
 	struct ieee80211_conf *conf = &ah->ah_sc->hw->conf;
+
 	if (conf_is_ht40(conf))
 		return ath9k_hw_mac_usec(ah, clks) / 2;
 	else
 		return ath9k_hw_mac_usec(ah, clks);
 }
 
-static u32 ath9k_hw_mac_clks(struct ath_hal *ah, u32 usecs)
+static u32 ath9k_hw_mac_clks(struct ath_hw *ah, u32 usecs)
 {
 	struct ieee80211_conf *conf = &ah->ah_sc->hw->conf;
+
 	if (!ah->ah_curchan) /* should really check for CCK instead */
 		return usecs *ATH9K_CLOCK_RATE_CCK;
 	if (conf->channel->band == IEEE80211_BAND_2GHZ)
@@ -70,16 +74,17 @@ static u32 ath9k_hw_mac_clks(struct ath_hal *ah, u32 usecs)
 	return usecs *ATH9K_CLOCK_RATE_5GHZ_OFDM;
 }
 
-static u32 ath9k_hw_mac_to_clks(struct ath_hal *ah, u32 usecs)
+static u32 ath9k_hw_mac_to_clks(struct ath_hw *ah, u32 usecs)
 {
 	struct ieee80211_conf *conf = &ah->ah_sc->hw->conf;
+
 	if (conf_is_ht40(conf))
 		return ath9k_hw_mac_clks(ah, usecs) * 2;
 	else
 		return ath9k_hw_mac_clks(ah, usecs);
 }
 
-bool ath9k_hw_wait(struct ath_hal *ah, u32 reg, u32 mask, u32 val)
+bool ath9k_hw_wait(struct ath_hw *ah, u32 reg, u32 mask, u32 val)
 {
 	int i;
 
@@ -109,7 +114,7 @@ u32 ath9k_hw_reverse_bits(u32 val, u32 n)
 	return retval;
 }
 
-bool ath9k_get_channel_edges(struct ath_hal *ah,
+bool ath9k_get_channel_edges(struct ath_hw *ah,
 			     u16 flags, u16 *low,
 			     u16 *high)
 {
@@ -128,7 +133,7 @@ bool ath9k_get_channel_edges(struct ath_hal *ah,
 	return false;
 }
 
-u16 ath9k_hw_computetxtime(struct ath_hal *ah,
+u16 ath9k_hw_computetxtime(struct ath_hw *ah,
 			   struct ath_rate_table *rates,
 			   u32 frameLen, u16 rateix,
 			   bool shortPreamble)
@@ -184,12 +189,11 @@ u16 ath9k_hw_computetxtime(struct ath_hal *ah,
 	return txTime;
 }
 
-void ath9k_hw_get_channel_centers(struct ath_hal *ah,
+void ath9k_hw_get_channel_centers(struct ath_hw *ah,
 				  struct ath9k_channel *chan,
 				  struct chan_centers *centers)
 {
 	int8_t extoff;
-	struct ath_hal_5416 *ahp = AH5416(ah);
 
 	if (!IS_CHAN_HT40(chan)) {
 		centers->ctl_center = centers->ext_center =
@@ -212,16 +216,15 @@ void ath9k_hw_get_channel_centers(struct ath_hal *ah,
 		centers->synth_center - (extoff * HT40_CHANNEL_CENTER_SHIFT);
 	centers->ext_center =
 		centers->synth_center + (extoff *
-			 ((ahp->ah_extprotspacing == ATH9K_HT_EXTPROTSPACING_20) ?
+			 ((ah->ah_extprotspacing == ATH9K_HT_EXTPROTSPACING_20) ?
 			  HT40_CHANNEL_CENTER_SHIFT : 15));
-
 }
 
 /******************/
 /* Chip Revisions */
 /******************/
 
-static void ath9k_hw_read_revisions(struct ath_hal *ah)
+static void ath9k_hw_read_revisions(struct ath_hw *ah)
 {
 	u32 val;
 
@@ -244,7 +247,7 @@ static void ath9k_hw_read_revisions(struct ath_hal *ah)
 	}
 }
 
-static int ath9k_hw_get_radiorev(struct ath_hal *ah)
+static int ath9k_hw_get_radiorev(struct ath_hw *ah)
 {
 	u32 val;
 	int i;
@@ -263,7 +266,7 @@ static int ath9k_hw_get_radiorev(struct ath_hal *ah)
 /* HW Attach, Detach, Init Routines */
 /************************************/
 
-static void ath9k_hw_disablepcie(struct ath_hal *ah)
+static void ath9k_hw_disablepcie(struct ath_hw *ah)
 {
 	if (AR_SREV_9100(ah))
 		return;
@@ -281,7 +284,7 @@ static void ath9k_hw_disablepcie(struct ath_hal *ah)
 	REG_WRITE(ah, AR_PCIE_SERDES2, 0x00000000);
 }
 
-static bool ath9k_hw_chip_test(struct ath_hal *ah)
+static bool ath9k_hw_chip_test(struct ath_hw *ah)
 {
 	u32 regAddr[2] = { AR_STA_ID0, AR_PHY_BASE + (8 << 2) };
 	u32 regHold[2];
@@ -323,6 +326,7 @@ static bool ath9k_hw_chip_test(struct ath_hal *ah)
 		REG_WRITE(ah, regAddr[i], regHold[i]);
 	}
 	udelay(100);
+
 	return true;
 }
 
@@ -347,7 +351,7 @@ static const char *ath9k_hw_devname(u16 devid)
 	return NULL;
 }
 
-static void ath9k_hw_set_defaults(struct ath_hal *ah)
+static void ath9k_hw_set_defaults(struct ath_hw *ah)
 {
 	int i;
 
@@ -387,25 +391,20 @@ static void ath9k_hw_set_defaults(struct ath_hal *ah)
 	ah->ah_config.intr_mitigation = 1;
 }
 
-static struct ath_hal_5416 *ath9k_hw_newstate(u16 devid,
-					      struct ath_softc *sc,
-					      void __iomem *mem,
-					      int *status)
+static struct ath_hw *ath9k_hw_newstate(u16 devid, struct ath_softc *sc,
+					int *status)
 {
-	struct ath_hal_5416 *ahp;
-	struct ath_hal *ah;
+	struct ath_hw *ah;
 
-	ahp = kzalloc(sizeof(struct ath_hal_5416), GFP_KERNEL);
-	if (ahp == NULL) {
+	ah = kzalloc(sizeof(struct ath_hw), GFP_KERNEL);
+	if (ah == NULL) {
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"Cannot allocate memory for state block\n");
 		*status = -ENOMEM;
 		return NULL;
 	}
 
-	ah = &ahp->ah;
 	ah->ah_sc = sc;
-	ah->ah_sh = mem;
 	ah->hw_version.magic = AR5416_MAGIC;
 	ah->regulatory.country_code = CTRY_DEFAULT;
 	ah->hw_version.devid = devid;
@@ -419,24 +418,24 @@ static struct ath_hal_5416 *ath9k_hw_newstate(u16 devid,
 
 	ah->regulatory.power_limit = MAX_RATE_POWER;
 	ah->regulatory.tp_scale = ATH9K_TP_SCALE_MAX;
-	ahp->ah_atimWindow = 0;
-	ahp->ah_diversityControl = ah->ah_config.diversity_control;
-	ahp->ah_antennaSwitchSwap =
+	ah->ah_atimWindow = 0;
+	ah->ah_diversityControl = ah->ah_config.diversity_control;
+	ah->ah_antennaSwitchSwap =
 		ah->ah_config.antenna_switch_swap;
-	ahp->ah_staId1Defaults = AR_STA_ID1_CRPT_MIC_ENABLE;
-	ahp->ah_beaconInterval = 100;
-	ahp->ah_enable32kHzClock = DONT_USE_32KHZ;
-	ahp->ah_slottime = (u32) -1;
-	ahp->ah_acktimeout = (u32) -1;
-	ahp->ah_ctstimeout = (u32) -1;
-	ahp->ah_globaltxtimeout = (u32) -1;
+	ah->ah_staId1Defaults = AR_STA_ID1_CRPT_MIC_ENABLE;
+	ah->ah_beaconInterval = 100;
+	ah->ah_enable32kHzClock = DONT_USE_32KHZ;
+	ah->ah_slottime = (u32) -1;
+	ah->ah_acktimeout = (u32) -1;
+	ah->ah_ctstimeout = (u32) -1;
+	ah->ah_globaltxtimeout = (u32) -1;
 
-	ahp->ah_gBeaconRate = 0;
+	ah->ah_gBeaconRate = 0;
 
-	return ahp;
+	return ah;
 }
 
-static int ath9k_hw_rfattach(struct ath_hal *ah)
+static int ath9k_hw_rfattach(struct ath_hw *ah)
 {
 	bool rfStatus = false;
 	int ecode = 0;
@@ -451,7 +450,7 @@ static int ath9k_hw_rfattach(struct ath_hal *ah)
 	return 0;
 }
 
-static int ath9k_hw_rf_claim(struct ath_hal *ah)
+static int ath9k_hw_rf_claim(struct ath_hw *ah)
 {
 	u32 val;
 
@@ -480,7 +479,7 @@ static int ath9k_hw_rf_claim(struct ath_hal *ah)
 	return 0;
 }
 
-static int ath9k_hw_init_macaddr(struct ath_hal *ah)
+static int ath9k_hw_init_macaddr(struct ath_hw *ah)
 {
 	u32 sum;
 	int i;
@@ -503,55 +502,55 @@ static int ath9k_hw_init_macaddr(struct ath_hal *ah)
 	return 0;
 }
 
-static void ath9k_hw_init_rxgain_ini(struct ath_hal *ah)
+static void ath9k_hw_init_rxgain_ini(struct ath_hw *ah)
 {
 	u32 rxgain_type;
-	struct ath_hal_5416 *ahp = AH5416(ah);
 
 	if (ath9k_hw_get_eeprom(ah, EEP_MINOR_REV) >= AR5416_EEP_MINOR_VER_17) {
 		rxgain_type = ath9k_hw_get_eeprom(ah, EEP_RXGAIN_TYPE);
 
 		if (rxgain_type == AR5416_EEP_RXGAIN_13DB_BACKOFF)
-			INIT_INI_ARRAY(&ahp->ah_iniModesRxGain,
+			INIT_INI_ARRAY(&ah->ah_iniModesRxGain,
 			ar9280Modes_backoff_13db_rxgain_9280_2,
 			ARRAY_SIZE(ar9280Modes_backoff_13db_rxgain_9280_2), 6);
 		else if (rxgain_type == AR5416_EEP_RXGAIN_23DB_BACKOFF)
-			INIT_INI_ARRAY(&ahp->ah_iniModesRxGain,
+			INIT_INI_ARRAY(&ah->ah_iniModesRxGain,
 			ar9280Modes_backoff_23db_rxgain_9280_2,
 			ARRAY_SIZE(ar9280Modes_backoff_23db_rxgain_9280_2), 6);
 		else
-			INIT_INI_ARRAY(&ahp->ah_iniModesRxGain,
+			INIT_INI_ARRAY(&ah->ah_iniModesRxGain,
 			ar9280Modes_original_rxgain_9280_2,
 			ARRAY_SIZE(ar9280Modes_original_rxgain_9280_2), 6);
-	} else
-		INIT_INI_ARRAY(&ahp->ah_iniModesRxGain,
+	} else {
+		INIT_INI_ARRAY(&ah->ah_iniModesRxGain,
 			ar9280Modes_original_rxgain_9280_2,
 			ARRAY_SIZE(ar9280Modes_original_rxgain_9280_2), 6);
+	}
 }
 
-static void ath9k_hw_init_txgain_ini(struct ath_hal *ah)
+static void ath9k_hw_init_txgain_ini(struct ath_hw *ah)
 {
 	u32 txgain_type;
-	struct ath_hal_5416 *ahp = AH5416(ah);
 
 	if (ath9k_hw_get_eeprom(ah, EEP_MINOR_REV) >= AR5416_EEP_MINOR_VER_19) {
 		txgain_type = ath9k_hw_get_eeprom(ah, EEP_TXGAIN_TYPE);
 
 		if (txgain_type == AR5416_EEP_TXGAIN_HIGH_POWER)
-			INIT_INI_ARRAY(&ahp->ah_iniModesTxGain,
+			INIT_INI_ARRAY(&ah->ah_iniModesTxGain,
 			ar9280Modes_high_power_tx_gain_9280_2,
 			ARRAY_SIZE(ar9280Modes_high_power_tx_gain_9280_2), 6);
 		else
-			INIT_INI_ARRAY(&ahp->ah_iniModesTxGain,
+			INIT_INI_ARRAY(&ah->ah_iniModesTxGain,
 			ar9280Modes_original_tx_gain_9280_2,
 			ARRAY_SIZE(ar9280Modes_original_tx_gain_9280_2), 6);
-	} else
-		INIT_INI_ARRAY(&ahp->ah_iniModesTxGain,
+	} else {
+		INIT_INI_ARRAY(&ah->ah_iniModesTxGain,
 		ar9280Modes_original_tx_gain_9280_2,
 		ARRAY_SIZE(ar9280Modes_original_tx_gain_9280_2), 6);
+	}
 }
 
-static int ath9k_hw_post_attach(struct ath_hal *ah)
+static int ath9k_hw_post_attach(struct ath_hw *ah)
 {
 	int ecode;
 
@@ -580,33 +579,30 @@ static int ath9k_hw_post_attach(struct ath_hal *ah)
 	return 0;
 }
 
-static struct ath_hal *ath9k_hw_do_attach(u16 devid, struct ath_softc *sc,
-					  void __iomem *mem, int *status)
+static struct ath_hw *ath9k_hw_do_attach(u16 devid, struct ath_softc *sc,
+					 int *status)
 {
-	struct ath_hal_5416 *ahp;
-	struct ath_hal *ah;
+	struct ath_hw *ah;
 	int ecode;
 	u32 i, j;
 
-	ahp = ath9k_hw_newstate(devid, sc, mem, status);
-	if (ahp == NULL)
+	ah = ath9k_hw_newstate(devid, sc, status);
+	if (ah == NULL)
 		return NULL;
 
-	ah = &ahp->ah;
-
 	ath9k_hw_set_defaults(ah);
 
 	if (ah->ah_config.intr_mitigation != 0)
-		ahp->ah_intrMitigation = true;
+		ah->ah_intrMitigation = true;
 
 	if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_POWER_ON)) {
-		DPRINTF(ah->ah_sc, ATH_DBG_RESET, "Couldn't reset chip\n");
+		DPRINTF(sc, ATH_DBG_RESET, "Couldn't reset chip\n");
 		ecode = -EIO;
 		goto bad;
 	}
 
 	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE)) {
-		DPRINTF(ah->ah_sc, ATH_DBG_RESET, "Couldn't wakeup chip\n");
+		DPRINTF(sc, ATH_DBG_RESET, "Couldn't wakeup chip\n");
 		ecode = -EIO;
 		goto bad;
 	}
@@ -621,15 +617,14 @@ static struct ath_hal *ath9k_hw_do_attach(u16 devid, struct ath_softc *sc,
 		}
 	}
 
-	DPRINTF(ah->ah_sc, ATH_DBG_RESET,
-		"serialize_regmode is %d\n",
+	DPRINTF(sc, ATH_DBG_RESET, "serialize_regmode is %d\n",
 		ah->ah_config.serialize_regmode);
 
 	if ((ah->hw_version.macVersion != AR_SREV_VERSION_5416_PCI) &&
 	    (ah->hw_version.macVersion != AR_SREV_VERSION_5416_PCIE) &&
 	    (ah->hw_version.macVersion != AR_SREV_VERSION_9160) &&
 	    (!AR_SREV_9100(ah)) && (!AR_SREV_9280(ah)) && (!AR_SREV_9285(ah))) {
-		DPRINTF(ah->ah_sc, ATH_DBG_RESET,
+		DPRINTF(sc, ATH_DBG_RESET,
 			"Mac Chip Rev 0x%02x.%x is not supported by "
 			"this driver\n", ah->hw_version.macVersion,
 			ah->hw_version.macRev);
@@ -638,176 +633,176 @@ static struct ath_hal *ath9k_hw_do_attach(u16 devid, struct ath_softc *sc,
 	}
 
 	if (AR_SREV_9100(ah)) {
-		ahp->ah_iqCalData.calData = &iq_cal_multi_sample;
-		ahp->ah_suppCals = IQ_MISMATCH_CAL;
+		ah->ah_iqCalData.calData = &iq_cal_multi_sample;
+		ah->ah_suppCals = IQ_MISMATCH_CAL;
 		ah->ah_isPciExpress = false;
 	}
 	ah->hw_version.phyRev = REG_READ(ah, AR_PHY_CHIP_ID);
 
 	if (AR_SREV_9160_10_OR_LATER(ah)) {
 		if (AR_SREV_9280_10_OR_LATER(ah)) {
-			ahp->ah_iqCalData.calData = &iq_cal_single_sample;
-			ahp->ah_adcGainCalData.calData =
+			ah->ah_iqCalData.calData = &iq_cal_single_sample;
+			ah->ah_adcGainCalData.calData =
 				&adc_gain_cal_single_sample;
-			ahp->ah_adcDcCalData.calData =
+			ah->ah_adcDcCalData.calData =
 				&adc_dc_cal_single_sample;
-			ahp->ah_adcDcCalInitData.calData =
+			ah->ah_adcDcCalInitData.calData =
 				&adc_init_dc_cal;
 		} else {
-			ahp->ah_iqCalData.calData = &iq_cal_multi_sample;
-			ahp->ah_adcGainCalData.calData =
+			ah->ah_iqCalData.calData = &iq_cal_multi_sample;
+			ah->ah_adcGainCalData.calData =
 				&adc_gain_cal_multi_sample;
-			ahp->ah_adcDcCalData.calData =
+			ah->ah_adcDcCalData.calData =
 				&adc_dc_cal_multi_sample;
-			ahp->ah_adcDcCalInitData.calData =
+			ah->ah_adcDcCalInitData.calData =
 				&adc_init_dc_cal;
 		}
-		ahp->ah_suppCals = ADC_GAIN_CAL | ADC_DC_CAL | IQ_MISMATCH_CAL;
+		ah->ah_suppCals = ADC_GAIN_CAL | ADC_DC_CAL | IQ_MISMATCH_CAL;
 	}
 
 	if (AR_SREV_9160(ah)) {
 		ah->ah_config.enable_ani = 1;
-		ahp->ah_ani_function = (ATH9K_ANI_SPUR_IMMUNITY_LEVEL |
+		ah->ah_ani_function = (ATH9K_ANI_SPUR_IMMUNITY_LEVEL |
 					ATH9K_ANI_FIRSTEP_LEVEL);
 	} else {
-		ahp->ah_ani_function = ATH9K_ANI_ALL;
+		ah->ah_ani_function = ATH9K_ANI_ALL;
 		if (AR_SREV_9280_10_OR_LATER(ah)) {
-			ahp->ah_ani_function &=	~ATH9K_ANI_NOISE_IMMUNITY_LEVEL;
+			ah->ah_ani_function &=	~ATH9K_ANI_NOISE_IMMUNITY_LEVEL;
 		}
 	}
 
-	DPRINTF(ah->ah_sc, ATH_DBG_RESET,
+	DPRINTF(sc, ATH_DBG_RESET,
 		"This Mac Chip Rev 0x%02x.%x is \n",
 		ah->hw_version.macVersion, ah->hw_version.macRev);
 
 	if (AR_SREV_9285_12_OR_LATER(ah)) {
-		INIT_INI_ARRAY(&ahp->ah_iniModes, ar9285Modes_9285_1_2,
+		INIT_INI_ARRAY(&ah->ah_iniModes, ar9285Modes_9285_1_2,
 			       ARRAY_SIZE(ar9285Modes_9285_1_2), 6);
-		INIT_INI_ARRAY(&ahp->ah_iniCommon, ar9285Common_9285_1_2,
+		INIT_INI_ARRAY(&ah->ah_iniCommon, ar9285Common_9285_1_2,
 			       ARRAY_SIZE(ar9285Common_9285_1_2), 2);
 
 		if (ah->ah_config.pcie_clock_req) {
-			INIT_INI_ARRAY(&ahp->ah_iniPcieSerdes,
+			INIT_INI_ARRAY(&ah->ah_iniPcieSerdes,
 			ar9285PciePhy_clkreq_off_L1_9285_1_2,
 			ARRAY_SIZE(ar9285PciePhy_clkreq_off_L1_9285_1_2), 2);
 		} else {
-			INIT_INI_ARRAY(&ahp->ah_iniPcieSerdes,
+			INIT_INI_ARRAY(&ah->ah_iniPcieSerdes,
 			ar9285PciePhy_clkreq_always_on_L1_9285_1_2,
 			ARRAY_SIZE(ar9285PciePhy_clkreq_always_on_L1_9285_1_2),
 				  2);
 		}
 	} else if (AR_SREV_9285_10_OR_LATER(ah)) {
-		INIT_INI_ARRAY(&ahp->ah_iniModes, ar9285Modes_9285,
+		INIT_INI_ARRAY(&ah->ah_iniModes, ar9285Modes_9285,
 			       ARRAY_SIZE(ar9285Modes_9285), 6);
-		INIT_INI_ARRAY(&ahp->ah_iniCommon, ar9285Common_9285,
+		INIT_INI_ARRAY(&ah->ah_iniCommon, ar9285Common_9285,
 			       ARRAY_SIZE(ar9285Common_9285), 2);
 
 		if (ah->ah_config.pcie_clock_req) {
-			INIT_INI_ARRAY(&ahp->ah_iniPcieSerdes,
+			INIT_INI_ARRAY(&ah->ah_iniPcieSerdes,
 			ar9285PciePhy_clkreq_off_L1_9285,
 			ARRAY_SIZE(ar9285PciePhy_clkreq_off_L1_9285), 2);
 		} else {
-			INIT_INI_ARRAY(&ahp->ah_iniPcieSerdes,
+			INIT_INI_ARRAY(&ah->ah_iniPcieSerdes,
 			ar9285PciePhy_clkreq_always_on_L1_9285,
 			ARRAY_SIZE(ar9285PciePhy_clkreq_always_on_L1_9285), 2);
 		}
 	} else if (AR_SREV_9280_20_OR_LATER(ah)) {
-		INIT_INI_ARRAY(&ahp->ah_iniModes, ar9280Modes_9280_2,
+		INIT_INI_ARRAY(&ah->ah_iniModes, ar9280Modes_9280_2,
 			       ARRAY_SIZE(ar9280Modes_9280_2), 6);
-		INIT_INI_ARRAY(&ahp->ah_iniCommon, ar9280Common_9280_2,
+		INIT_INI_ARRAY(&ah->ah_iniCommon, ar9280Common_9280_2,
 			       ARRAY_SIZE(ar9280Common_9280_2), 2);
 
 		if (ah->ah_config.pcie_clock_req) {
-			INIT_INI_ARRAY(&ahp->ah_iniPcieSerdes,
+			INIT_INI_ARRAY(&ah->ah_iniPcieSerdes,
 			       ar9280PciePhy_clkreq_off_L1_9280,
 			       ARRAY_SIZE(ar9280PciePhy_clkreq_off_L1_9280),2);
 		} else {
-			INIT_INI_ARRAY(&ahp->ah_iniPcieSerdes,
+			INIT_INI_ARRAY(&ah->ah_iniPcieSerdes,
 			       ar9280PciePhy_clkreq_always_on_L1_9280,
 			       ARRAY_SIZE(ar9280PciePhy_clkreq_always_on_L1_9280), 2);
 		}
-		INIT_INI_ARRAY(&ahp->ah_iniModesAdditional,
+		INIT_INI_ARRAY(&ah->ah_iniModesAdditional,
 			       ar9280Modes_fast_clock_9280_2,
 			       ARRAY_SIZE(ar9280Modes_fast_clock_9280_2), 3);
 	} else if (AR_SREV_9280_10_OR_LATER(ah)) {
-		INIT_INI_ARRAY(&ahp->ah_iniModes, ar9280Modes_9280,
+		INIT_INI_ARRAY(&ah->ah_iniModes, ar9280Modes_9280,
 			       ARRAY_SIZE(ar9280Modes_9280), 6);
-		INIT_INI_ARRAY(&ahp->ah_iniCommon, ar9280Common_9280,
+		INIT_INI_ARRAY(&ah->ah_iniCommon, ar9280Common_9280,
 			       ARRAY_SIZE(ar9280Common_9280), 2);
 	} else if (AR_SREV_9160_10_OR_LATER(ah)) {
-		INIT_INI_ARRAY(&ahp->ah_iniModes, ar5416Modes_9160,
+		INIT_INI_ARRAY(&ah->ah_iniModes, ar5416Modes_9160,
 			       ARRAY_SIZE(ar5416Modes_9160), 6);
-		INIT_INI_ARRAY(&ahp->ah_iniCommon, ar5416Common_9160,
+		INIT_INI_ARRAY(&ah->ah_iniCommon, ar5416Common_9160,
 			       ARRAY_SIZE(ar5416Common_9160), 2);
-		INIT_INI_ARRAY(&ahp->ah_iniBank0, ar5416Bank0_9160,
+		INIT_INI_ARRAY(&ah->ah_iniBank0, ar5416Bank0_9160,
 			       ARRAY_SIZE(ar5416Bank0_9160), 2);
-		INIT_INI_ARRAY(&ahp->ah_iniBB_RfGain, ar5416BB_RfGain_9160,
+		INIT_INI_ARRAY(&ah->ah_iniBB_RfGain, ar5416BB_RfGain_9160,
 			       ARRAY_SIZE(ar5416BB_RfGain_9160), 3);
-		INIT_INI_ARRAY(&ahp->ah_iniBank1, ar5416Bank1_9160,
+		INIT_INI_ARRAY(&ah->ah_iniBank1, ar5416Bank1_9160,
 			       ARRAY_SIZE(ar5416Bank1_9160), 2);
-		INIT_INI_ARRAY(&ahp->ah_iniBank2, ar5416Bank2_9160,
+		INIT_INI_ARRAY(&ah->ah_iniBank2, ar5416Bank2_9160,
 			       ARRAY_SIZE(ar5416Bank2_9160), 2);
-		INIT_INI_ARRAY(&ahp->ah_iniBank3, ar5416Bank3_9160,
+		INIT_INI_ARRAY(&ah->ah_iniBank3, ar5416Bank3_9160,
 			       ARRAY_SIZE(ar5416Bank3_9160), 3);
-		INIT_INI_ARRAY(&ahp->ah_iniBank6, ar5416Bank6_9160,
+		INIT_INI_ARRAY(&ah->ah_iniBank6, ar5416Bank6_9160,
 			       ARRAY_SIZE(ar5416Bank6_9160), 3);
-		INIT_INI_ARRAY(&ahp->ah_iniBank6TPC, ar5416Bank6TPC_9160,
+		INIT_INI_ARRAY(&ah->ah_iniBank6TPC, ar5416Bank6TPC_9160,
 			       ARRAY_SIZE(ar5416Bank6TPC_9160), 3);
-		INIT_INI_ARRAY(&ahp->ah_iniBank7, ar5416Bank7_9160,
+		INIT_INI_ARRAY(&ah->ah_iniBank7, ar5416Bank7_9160,
 			       ARRAY_SIZE(ar5416Bank7_9160), 2);
 		if (AR_SREV_9160_11(ah)) {
-			INIT_INI_ARRAY(&ahp->ah_iniAddac,
+			INIT_INI_ARRAY(&ah->ah_iniAddac,
 				       ar5416Addac_91601_1,
 				       ARRAY_SIZE(ar5416Addac_91601_1), 2);
 		} else {
-			INIT_INI_ARRAY(&ahp->ah_iniAddac, ar5416Addac_9160,
+			INIT_INI_ARRAY(&ah->ah_iniAddac, ar5416Addac_9160,
 				       ARRAY_SIZE(ar5416Addac_9160), 2);
 		}
 	} else if (AR_SREV_9100_OR_LATER(ah)) {
-		INIT_INI_ARRAY(&ahp->ah_iniModes, ar5416Modes_9100,
+		INIT_INI_ARRAY(&ah->ah_iniModes, ar5416Modes_9100,
 			       ARRAY_SIZE(ar5416Modes_9100), 6);
-		INIT_INI_ARRAY(&ahp->ah_iniCommon, ar5416Common_9100,
+		INIT_INI_ARRAY(&ah->ah_iniCommon, ar5416Common_9100,
 			       ARRAY_SIZE(ar5416Common_9100), 2);
-		INIT_INI_ARRAY(&ahp->ah_iniBank0, ar5416Bank0_9100,
+		INIT_INI_ARRAY(&ah->ah_iniBank0, ar5416Bank0_9100,
 			       ARRAY_SIZE(ar5416Bank0_9100), 2);
-		INIT_INI_ARRAY(&ahp->ah_iniBB_RfGain, ar5416BB_RfGain_9100,
+		INIT_INI_ARRAY(&ah->ah_iniBB_RfGain, ar5416BB_RfGain_9100,
 			       ARRAY_SIZE(ar5416BB_RfGain_9100), 3);
-		INIT_INI_ARRAY(&ahp->ah_iniBank1, ar5416Bank1_9100,
+		INIT_INI_ARRAY(&ah->ah_iniBank1, ar5416Bank1_9100,
 			       ARRAY_SIZE(ar5416Bank1_9100), 2);
-		INIT_INI_ARRAY(&ahp->ah_iniBank2, ar5416Bank2_9100,
+		INIT_INI_ARRAY(&ah->ah_iniBank2, ar5416Bank2_9100,
 			       ARRAY_SIZE(ar5416Bank2_9100), 2);
-		INIT_INI_ARRAY(&ahp->ah_iniBank3, ar5416Bank3_9100,
+		INIT_INI_ARRAY(&ah->ah_iniBank3, ar5416Bank3_9100,
 			       ARRAY_SIZE(ar5416Bank3_9100), 3);
-		INIT_INI_ARRAY(&ahp->ah_iniBank6, ar5416Bank6_9100,
+		INIT_INI_ARRAY(&ah->ah_iniBank6, ar5416Bank6_9100,
 			       ARRAY_SIZE(ar5416Bank6_9100), 3);
-		INIT_INI_ARRAY(&ahp->ah_iniBank6TPC, ar5416Bank6TPC_9100,
+		INIT_INI_ARRAY(&ah->ah_iniBank6TPC, ar5416Bank6TPC_9100,
 			       ARRAY_SIZE(ar5416Bank6TPC_9100), 3);
-		INIT_INI_ARRAY(&ahp->ah_iniBank7, ar5416Bank7_9100,
+		INIT_INI_ARRAY(&ah->ah_iniBank7, ar5416Bank7_9100,
 			       ARRAY_SIZE(ar5416Bank7_9100), 2);
-		INIT_INI_ARRAY(&ahp->ah_iniAddac, ar5416Addac_9100,
+		INIT_INI_ARRAY(&ah->ah_iniAddac, ar5416Addac_9100,
 			       ARRAY_SIZE(ar5416Addac_9100), 2);
 	} else {
-		INIT_INI_ARRAY(&ahp->ah_iniModes, ar5416Modes,
+		INIT_INI_ARRAY(&ah->ah_iniModes, ar5416Modes,
 			       ARRAY_SIZE(ar5416Modes), 6);
-		INIT_INI_ARRAY(&ahp->ah_iniCommon, ar5416Common,
+		INIT_INI_ARRAY(&ah->ah_iniCommon, ar5416Common,
 			       ARRAY_SIZE(ar5416Common), 2);
-		INIT_INI_ARRAY(&ahp->ah_iniBank0, ar5416Bank0,
+		INIT_INI_ARRAY(&ah->ah_iniBank0, ar5416Bank0,
 			       ARRAY_SIZE(ar5416Bank0), 2);
-		INIT_INI_ARRAY(&ahp->ah_iniBB_RfGain, ar5416BB_RfGain,
+		INIT_INI_ARRAY(&ah->ah_iniBB_RfGain, ar5416BB_RfGain,
 			       ARRAY_SIZE(ar5416BB_RfGain), 3);
-		INIT_INI_ARRAY(&ahp->ah_iniBank1, ar5416Bank1,
+		INIT_INI_ARRAY(&ah->ah_iniBank1, ar5416Bank1,
 			       ARRAY_SIZE(ar5416Bank1), 2);
-		INIT_INI_ARRAY(&ahp->ah_iniBank2, ar5416Bank2,
+		INIT_INI_ARRAY(&ah->ah_iniBank2, ar5416Bank2,
 			       ARRAY_SIZE(ar5416Bank2), 2);
-		INIT_INI_ARRAY(&ahp->ah_iniBank3, ar5416Bank3,
+		INIT_INI_ARRAY(&ah->ah_iniBank3, ar5416Bank3,
 			       ARRAY_SIZE(ar5416Bank3), 3);
-		INIT_INI_ARRAY(&ahp->ah_iniBank6, ar5416Bank6,
+		INIT_INI_ARRAY(&ah->ah_iniBank6, ar5416Bank6,
 			       ARRAY_SIZE(ar5416Bank6), 3);
-		INIT_INI_ARRAY(&ahp->ah_iniBank6TPC, ar5416Bank6TPC,
+		INIT_INI_ARRAY(&ah->ah_iniBank6TPC, ar5416Bank6TPC,
 			       ARRAY_SIZE(ar5416Bank6TPC), 3);
-		INIT_INI_ARRAY(&ahp->ah_iniBank7, ar5416Bank7,
+		INIT_INI_ARRAY(&ah->ah_iniBank7, ar5416Bank7,
 			       ARRAY_SIZE(ar5416Bank7), 2);
-		INIT_INI_ARRAY(&ahp->ah_iniAddac, ar5416Addac,
+		INIT_INI_ARRAY(&ah->ah_iniAddac, ar5416Addac,
 			       ARRAY_SIZE(ar5416Addac), 2);
 	}
 
@@ -829,22 +824,22 @@ static struct ath_hal *ath9k_hw_do_attach(u16 devid, struct ath_softc *sc,
 		ath9k_hw_init_txgain_ini(ah);
 
 	if (ah->hw_version.devid == AR9280_DEVID_PCI) {
-		for (i = 0; i < ahp->ah_iniModes.ia_rows; i++) {
-			u32 reg = INI_RA(&ahp->ah_iniModes, i, 0);
+		for (i = 0; i < ah->ah_iniModes.ia_rows; i++) {
+			u32 reg = INI_RA(&ah->ah_iniModes, i, 0);
 
-			for (j = 1; j < ahp->ah_iniModes.ia_columns; j++) {
-				u32 val = INI_RA(&ahp->ah_iniModes, i, j);
+			for (j = 1; j < ah->ah_iniModes.ia_columns; j++) {
+				u32 val = INI_RA(&ah->ah_iniModes, i, j);
 
-				INI_RA(&ahp->ah_iniModes, i, j) =
+				INI_RA(&ah->ah_iniModes, i, j) =
 					ath9k_hw_ini_fixup(ah,
-							   &ahp->ah_eeprom.def,
+							   &ah->ah_eeprom.def,
 							   reg, val);
 			}
 		}
 	}
 
 	if (!ath9k_hw_fill_cap_info(ah)) {
-		DPRINTF(ah->ah_sc, ATH_DBG_RESET,
+		DPRINTF(sc, ATH_DBG_RESET,
 			"failed ath9k_hw_fill_cap_info\n");
 		ecode = -EINVAL;
 		goto bad;
@@ -852,7 +847,7 @@ static struct ath_hal *ath9k_hw_do_attach(u16 devid, struct ath_softc *sc,
 
 	ecode = ath9k_hw_init_macaddr(ah);
 	if (ecode != 0) {
-		DPRINTF(ah->ah_sc, ATH_DBG_RESET,
+		DPRINTF(sc, ATH_DBG_RESET,
 			"failed initializing mac address\n");
 		goto bad;
 	}
@@ -866,15 +861,15 @@ static struct ath_hal *ath9k_hw_do_attach(u16 devid, struct ath_softc *sc,
 
 	return ah;
 bad:
-	if (ahp)
-		ath9k_hw_detach((struct ath_hal *) ahp);
+	if (ah)
+		ath9k_hw_detach(ah);
 	if (status)
 		*status = ecode;
 
 	return NULL;
 }
 
-static void ath9k_hw_init_bb(struct ath_hal *ah,
+static void ath9k_hw_init_bb(struct ath_hw *ah,
 			     struct ath9k_channel *chan)
 {
 	u32 synthDelay;
@@ -890,7 +885,7 @@ static void ath9k_hw_init_bb(struct ath_hal *ah,
 	udelay(synthDelay + BASE_ACTIVATE_DELAY);
 }
 
-static void ath9k_hw_init_qos(struct ath_hal *ah)
+static void ath9k_hw_init_qos(struct ath_hw *ah)
 {
 	REG_WRITE(ah, AR_MIC_QOS_CONTROL, 0x100aa);
 	REG_WRITE(ah, AR_MIC_QOS_SELECT, 0x3210);
@@ -907,7 +902,7 @@ static void ath9k_hw_init_qos(struct ath_hal *ah)
 	REG_WRITE(ah, AR_TXOP_12_15, 0xFFFFFFFF);
 }
 
-static void ath9k_hw_init_pll(struct ath_hal *ah,
+static void ath9k_hw_init_pll(struct ath_hw *ah,
 			      struct ath9k_channel *chan)
 {
 	u32 pll;
@@ -975,13 +970,12 @@ static void ath9k_hw_init_pll(struct ath_hal *ah,
 	REG_WRITE(ah, AR_RTC_SLEEP_CLK, AR_RTC_FORCE_DERIVED_CLK);
 }
 
-static void ath9k_hw_init_chain_masks(struct ath_hal *ah)
+static void ath9k_hw_init_chain_masks(struct ath_hw *ah)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
 	int rx_chainmask, tx_chainmask;
 
-	rx_chainmask = ahp->ah_rxchainmask;
-	tx_chainmask = ahp->ah_txchainmask;
+	rx_chainmask = ah->ah_rxchainmask;
+	tx_chainmask = ah->ah_txchainmask;
 
 	switch (rx_chainmask) {
 	case 0x5:
@@ -1013,28 +1007,26 @@ static void ath9k_hw_init_chain_masks(struct ath_hal *ah)
 			  REG_READ(ah, AR_PHY_ANALOG_SWAP) | 0x00000001);
 }
 
-static void ath9k_hw_init_interrupt_masks(struct ath_hal *ah,
+static void ath9k_hw_init_interrupt_masks(struct ath_hw *ah,
 					  enum nl80211_iftype opmode)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
-
-	ahp->ah_maskReg = AR_IMR_TXERR |
+	ah->ah_maskReg = AR_IMR_TXERR |
 		AR_IMR_TXURN |
 		AR_IMR_RXERR |
 		AR_IMR_RXORN |
 		AR_IMR_BCNMISC;
 
-	if (ahp->ah_intrMitigation)
-		ahp->ah_maskReg |= AR_IMR_RXINTM | AR_IMR_RXMINTR;
+	if (ah->ah_intrMitigation)
+		ah->ah_maskReg |= AR_IMR_RXINTM | AR_IMR_RXMINTR;
 	else
-		ahp->ah_maskReg |= AR_IMR_RXOK;
+		ah->ah_maskReg |= AR_IMR_RXOK;
 
-	ahp->ah_maskReg |= AR_IMR_TXOK;
+	ah->ah_maskReg |= AR_IMR_TXOK;
 
 	if (opmode == NL80211_IFTYPE_AP)
-		ahp->ah_maskReg |= AR_IMR_MIB;
+		ah->ah_maskReg |= AR_IMR_MIB;
 
-	REG_WRITE(ah, AR_IMR, ahp->ah_maskReg);
+	REG_WRITE(ah, AR_IMR, ah->ah_maskReg);
 	REG_WRITE(ah, AR_IMR_S2, REG_READ(ah, AR_IMR_S2) | AR_IMR_S2_GTT);
 
 	if (!AR_SREV_9100(ah)) {
@@ -1044,72 +1036,64 @@ static void ath9k_hw_init_interrupt_masks(struct ath_hal *ah,
 	}
 }
 
-static bool ath9k_hw_set_ack_timeout(struct ath_hal *ah, u32 us)
+static bool ath9k_hw_set_ack_timeout(struct ath_hw *ah, u32 us)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
-
 	if (us > ath9k_hw_mac_to_usec(ah, MS(0xffffffff, AR_TIME_OUT_ACK))) {
 		DPRINTF(ah->ah_sc, ATH_DBG_RESET, "bad ack timeout %u\n", us);
-		ahp->ah_acktimeout = (u32) -1;
+		ah->ah_acktimeout = (u32) -1;
 		return false;
 	} else {
 		REG_RMW_FIELD(ah, AR_TIME_OUT,
 			      AR_TIME_OUT_ACK, ath9k_hw_mac_to_clks(ah, us));
-		ahp->ah_acktimeout = us;
+		ah->ah_acktimeout = us;
 		return true;
 	}
 }
 
-static bool ath9k_hw_set_cts_timeout(struct ath_hal *ah, u32 us)
+static bool ath9k_hw_set_cts_timeout(struct ath_hw *ah, u32 us)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
-
 	if (us > ath9k_hw_mac_to_usec(ah, MS(0xffffffff, AR_TIME_OUT_CTS))) {
 		DPRINTF(ah->ah_sc, ATH_DBG_RESET, "bad cts timeout %u\n", us);
-		ahp->ah_ctstimeout = (u32) -1;
+		ah->ah_ctstimeout = (u32) -1;
 		return false;
 	} else {
 		REG_RMW_FIELD(ah, AR_TIME_OUT,
 			      AR_TIME_OUT_CTS, ath9k_hw_mac_to_clks(ah, us));
-		ahp->ah_ctstimeout = us;
+		ah->ah_ctstimeout = us;
 		return true;
 	}
 }
 
-static bool ath9k_hw_set_global_txtimeout(struct ath_hal *ah, u32 tu)
+static bool ath9k_hw_set_global_txtimeout(struct ath_hw *ah, u32 tu)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
-
 	if (tu > 0xFFFF) {
 		DPRINTF(ah->ah_sc, ATH_DBG_XMIT,
 			"bad global tx timeout %u\n", tu);
-		ahp->ah_globaltxtimeout = (u32) -1;
+		ah->ah_globaltxtimeout = (u32) -1;
 		return false;
 	} else {
 		REG_RMW_FIELD(ah, AR_GTXTO, AR_GTXTO_TIMEOUT_LIMIT, tu);
-		ahp->ah_globaltxtimeout = tu;
+		ah->ah_globaltxtimeout = tu;
 		return true;
 	}
 }
 
-static void ath9k_hw_init_user_settings(struct ath_hal *ah)
+static void ath9k_hw_init_user_settings(struct ath_hw *ah)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
+	DPRINTF(ah->ah_sc, ATH_DBG_RESET, "ah->ah_miscMode 0x%x\n",
+		ah->ah_miscMode);
 
-	DPRINTF(ah->ah_sc, ATH_DBG_RESET, "ahp->ah_miscMode 0x%x\n",
-		ahp->ah_miscMode);
-
-	if (ahp->ah_miscMode != 0)
+	if (ah->ah_miscMode != 0)
 		REG_WRITE(ah, AR_PCU_MISC,
-			  REG_READ(ah, AR_PCU_MISC) | ahp->ah_miscMode);
-	if (ahp->ah_slottime != (u32) -1)
-		ath9k_hw_setslottime(ah, ahp->ah_slottime);
-	if (ahp->ah_acktimeout != (u32) -1)
-		ath9k_hw_set_ack_timeout(ah, ahp->ah_acktimeout);
-	if (ahp->ah_ctstimeout != (u32) -1)
-		ath9k_hw_set_cts_timeout(ah, ahp->ah_ctstimeout);
-	if (ahp->ah_globaltxtimeout != (u32) -1)
-		ath9k_hw_set_global_txtimeout(ah, ahp->ah_globaltxtimeout);
+			  REG_READ(ah, AR_PCU_MISC) | ah->ah_miscMode);
+	if (ah->ah_slottime != (u32) -1)
+		ath9k_hw_setslottime(ah, ah->ah_slottime);
+	if (ah->ah_acktimeout != (u32) -1)
+		ath9k_hw_set_ack_timeout(ah, ah->ah_acktimeout);
+	if (ah->ah_ctstimeout != (u32) -1)
+		ath9k_hw_set_cts_timeout(ah, ah->ah_ctstimeout);
+	if (ah->ah_globaltxtimeout != (u32) -1)
+		ath9k_hw_set_global_txtimeout(ah, ah->ah_globaltxtimeout);
 }
 
 const char *ath9k_hw_probe(u16 vendorid, u16 devid)
@@ -1118,7 +1102,7 @@ const char *ath9k_hw_probe(u16 vendorid, u16 devid)
 		ath9k_hw_devname(devid) : NULL;
 }
 
-void ath9k_hw_detach(struct ath_hal *ah)
+void ath9k_hw_detach(struct ath_hw *ah)
 {
 	if (!AR_SREV_9100(ah))
 		ath9k_hw_ani_detach(ah);
@@ -1128,10 +1112,9 @@ void ath9k_hw_detach(struct ath_hal *ah)
 	kfree(ah);
 }
 
-struct ath_hal *ath9k_hw_attach(u16 devid, struct ath_softc *sc,
-				void __iomem *mem, int *error)
+struct ath_hw *ath9k_hw_attach(u16 devid, struct ath_softc *sc, int *error)
 {
-	struct ath_hal *ah = NULL;
+	struct ath_hw *ah = NULL;
 
 	switch (devid) {
 	case AR5416_DEVID_PCI:
@@ -1141,7 +1124,7 @@ struct ath_hal *ath9k_hw_attach(u16 devid, struct ath_softc *sc,
 	case AR9280_DEVID_PCI:
 	case AR9280_DEVID_PCIE:
 	case AR9285_DEVID_PCIE:
-		ah = ath9k_hw_do_attach(devid, sc, mem, error);
+		ah = ath9k_hw_do_attach(devid, sc, error);
 		break;
 	default:
 		*error = -ENXIO;
@@ -1155,7 +1138,7 @@ struct ath_hal *ath9k_hw_attach(u16 devid, struct ath_softc *sc,
 /* INI */
 /*******/
 
-static void ath9k_hw_override_ini(struct ath_hal *ah,
+static void ath9k_hw_override_ini(struct ath_hw *ah,
 				  struct ath9k_channel *chan)
 {
 	/*
@@ -1173,7 +1156,7 @@ static void ath9k_hw_override_ini(struct ath_hal *ah,
 	REG_WRITE(ah, 0x9800 + (651 << 2), 0x11);
 }
 
-static u32 ath9k_hw_def_ini_fixup(struct ath_hal *ah,
+static u32 ath9k_hw_def_ini_fixup(struct ath_hw *ah,
 			      struct ar5416_eeprom_def *pEepData,
 			      u32 reg, u32 value)
 {
@@ -1207,24 +1190,21 @@ static u32 ath9k_hw_def_ini_fixup(struct ath_hal *ah,
 	return value;
 }
 
-static u32 ath9k_hw_ini_fixup(struct ath_hal *ah,
+static u32 ath9k_hw_ini_fixup(struct ath_hw *ah,
 			      struct ar5416_eeprom_def *pEepData,
 			      u32 reg, u32 value)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
-
-	if (ahp->ah_eep_map == EEP_MAP_4KBITS)
+	if (ah->ah_eep_map == EEP_MAP_4KBITS)
 		return value;
 	else
 		return ath9k_hw_def_ini_fixup(ah, pEepData, reg, value);
 }
 
-static int ath9k_hw_process_ini(struct ath_hal *ah,
+static int ath9k_hw_process_ini(struct ath_hw *ah,
 				struct ath9k_channel *chan,
 				enum ath9k_ht_macmode macmode)
 {
 	int i, regWrites = 0;
-	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct ieee80211_channel *channel = chan->chan;
 	u32 modesIndex, freqIndex;
 	int status;
@@ -1257,35 +1237,33 @@ static int ath9k_hw_process_ini(struct ath_hal *ah,
 	}
 
 	REG_WRITE(ah, AR_PHY(0), 0x00000007);
-
 	REG_WRITE(ah, AR_PHY_ADC_SERIAL_CTL, AR_PHY_SEL_EXTERNAL_RADIO);
-
 	ath9k_hw_set_addac(ah, chan);
 
 	if (AR_SREV_5416_V22_OR_LATER(ah)) {
-		REG_WRITE_ARRAY(&ahp->ah_iniAddac, 1, regWrites);
+		REG_WRITE_ARRAY(&ah->ah_iniAddac, 1, regWrites);
 	} else {
 		struct ar5416IniArray temp;
 		u32 addacSize =
-			sizeof(u32) * ahp->ah_iniAddac.ia_rows *
-			ahp->ah_iniAddac.ia_columns;
+			sizeof(u32) * ah->ah_iniAddac.ia_rows *
+			ah->ah_iniAddac.ia_columns;
 
-		memcpy(ahp->ah_addac5416_21,
-		       ahp->ah_iniAddac.ia_array, addacSize);
+		memcpy(ah->ah_addac5416_21,
+		       ah->ah_iniAddac.ia_array, addacSize);
 
-		(ahp->ah_addac5416_21)[31 * ahp->ah_iniAddac.ia_columns + 1] = 0;
+		(ah->ah_addac5416_21)[31 * ah->ah_iniAddac.ia_columns + 1] = 0;
 
-		temp.ia_array = ahp->ah_addac5416_21;
-		temp.ia_columns = ahp->ah_iniAddac.ia_columns;
-		temp.ia_rows = ahp->ah_iniAddac.ia_rows;
+		temp.ia_array = ah->ah_addac5416_21;
+		temp.ia_columns = ah->ah_iniAddac.ia_columns;
+		temp.ia_rows = ah->ah_iniAddac.ia_rows;
 		REG_WRITE_ARRAY(&temp, 1, regWrites);
 	}
 
 	REG_WRITE(ah, AR_PHY_ADC_SERIAL_CTL, AR_PHY_SEL_INTERNAL_ADDAC);
 
-	for (i = 0; i < ahp->ah_iniModes.ia_rows; i++) {
-		u32 reg = INI_RA(&ahp->ah_iniModes, i, 0);
-		u32 val = INI_RA(&ahp->ah_iniModes, i, modesIndex);
+	for (i = 0; i < ah->ah_iniModes.ia_rows; i++) {
+		u32 reg = INI_RA(&ah->ah_iniModes, i, 0);
+		u32 val = INI_RA(&ah->ah_iniModes, i, modesIndex);
 
 		REG_WRITE(ah, reg, val);
 
@@ -1298,14 +1276,14 @@ static int ath9k_hw_process_ini(struct ath_hal *ah,
 	}
 
 	if (AR_SREV_9280(ah))
-		REG_WRITE_ARRAY(&ahp->ah_iniModesRxGain, modesIndex, regWrites);
+		REG_WRITE_ARRAY(&ah->ah_iniModesRxGain, modesIndex, regWrites);
 
 	if (AR_SREV_9280(ah))
-		REG_WRITE_ARRAY(&ahp->ah_iniModesTxGain, modesIndex, regWrites);
+		REG_WRITE_ARRAY(&ah->ah_iniModesTxGain, modesIndex, regWrites);
 
-	for (i = 0; i < ahp->ah_iniCommon.ia_rows; i++) {
-		u32 reg = INI_RA(&ahp->ah_iniCommon, i, 0);
-		u32 val = INI_RA(&ahp->ah_iniCommon, i, 1);
+	for (i = 0; i < ah->ah_iniCommon.ia_rows; i++) {
+		u32 reg = INI_RA(&ah->ah_iniCommon, i, 0);
+		u32 val = INI_RA(&ah->ah_iniCommon, i, 1);
 
 		REG_WRITE(ah, reg, val);
 
@@ -1320,7 +1298,7 @@ static int ath9k_hw_process_ini(struct ath_hal *ah,
 	ath9k_hw_write_regs(ah, modesIndex, freqIndex, regWrites);
 
 	if (AR_SREV_9280_20(ah) && IS_CHAN_A_5MHZ_SPACED(chan)) {
-		REG_WRITE_ARRAY(&ahp->ah_iniModesAdditional, modesIndex,
+		REG_WRITE_ARRAY(&ah->ah_iniModesAdditional, modesIndex,
 				regWrites);
 	}
 
@@ -1353,7 +1331,7 @@ static int ath9k_hw_process_ini(struct ath_hal *ah,
 /* Reset and Channel Switching Routines */
 /****************************************/
 
-static void ath9k_hw_set_rfmode(struct ath_hal *ah, struct ath9k_channel *chan)
+static void ath9k_hw_set_rfmode(struct ath_hw *ah, struct ath9k_channel *chan)
 {
 	u32 rfMode = 0;
 
@@ -1373,12 +1351,12 @@ static void ath9k_hw_set_rfmode(struct ath_hal *ah, struct ath9k_channel *chan)
 	REG_WRITE(ah, AR_PHY_MODE, rfMode);
 }
 
-static void ath9k_hw_mark_phy_inactive(struct ath_hal *ah)
+static void ath9k_hw_mark_phy_inactive(struct ath_hw *ah)
 {
 	REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_DIS);
 }
 
-static inline void ath9k_hw_set_dma(struct ath_hal *ah)
+static inline void ath9k_hw_set_dma(struct ath_hw *ah)
 {
 	u32 regval;
 
@@ -1404,7 +1382,7 @@ static inline void ath9k_hw_set_dma(struct ath_hal *ah)
 	}
 }
 
-static void ath9k_hw_set_operating_mode(struct ath_hal *ah, int opmode)
+static void ath9k_hw_set_operating_mode(struct ath_hw *ah, int opmode)
 {
 	u32 val;
 
@@ -1428,7 +1406,7 @@ static void ath9k_hw_set_operating_mode(struct ath_hal *ah, int opmode)
 	}
 }
 
-static inline void ath9k_hw_get_delta_slope_vals(struct ath_hal *ah,
+static inline void ath9k_hw_get_delta_slope_vals(struct ath_hw *ah,
 						 u32 coef_scaled,
 						 u32 *coef_mantissa,
 						 u32 *coef_exponent)
@@ -1447,7 +1425,7 @@ static inline void ath9k_hw_get_delta_slope_vals(struct ath_hal *ah,
 	*coef_exponent = coef_exp - 16;
 }
 
-static void ath9k_hw_set_delta_slope(struct ath_hal *ah,
+static void ath9k_hw_set_delta_slope(struct ath_hw *ah,
 				     struct ath9k_channel *chan)
 {
 	u32 coef_scaled, ds_coef_exp, ds_coef_man;
@@ -1481,7 +1459,7 @@ static void ath9k_hw_set_delta_slope(struct ath_hal *ah,
 		      AR_PHY_HALFGI_DSC_EXP, ds_coef_exp);
 }
 
-static bool ath9k_hw_set_reset(struct ath_hal *ah, int type)
+static bool ath9k_hw_set_reset(struct ath_hw *ah, int type)
 {
 	u32 rst_flags;
 	u32 tmpReg;
@@ -1529,7 +1507,7 @@ static bool ath9k_hw_set_reset(struct ath_hal *ah, int type)
 	return true;
 }
 
-static bool ath9k_hw_set_reset_power_on(struct ath_hal *ah)
+static bool ath9k_hw_set_reset_power_on(struct ath_hw *ah)
 {
 	REG_WRITE(ah, AR_RTC_FORCE_WAKE, AR_RTC_FORCE_WAKE_EN |
 		  AR_RTC_FORCE_WAKE_ON_INT);
@@ -1550,7 +1528,7 @@ static bool ath9k_hw_set_reset_power_on(struct ath_hal *ah)
 	return ath9k_hw_set_reset(ah, ATH9K_RESET_WARM);
 }
 
-static bool ath9k_hw_set_reset_reg(struct ath_hal *ah, u32 type)
+static bool ath9k_hw_set_reset_reg(struct ath_hw *ah, u32 type)
 {
 	REG_WRITE(ah, AR_RTC_FORCE_WAKE,
 		  AR_RTC_FORCE_WAKE_EN | AR_RTC_FORCE_WAKE_ON_INT);
@@ -1568,12 +1546,11 @@ static bool ath9k_hw_set_reset_reg(struct ath_hal *ah, u32 type)
 	}
 }
 
-static void ath9k_hw_set_regs(struct ath_hal *ah, struct ath9k_channel *chan,
+static void ath9k_hw_set_regs(struct ath_hw *ah, struct ath9k_channel *chan,
 			      enum ath9k_ht_macmode macmode)
 {
 	u32 phymode;
 	u32 enableDacFifo = 0;
-	struct ath_hal_5416 *ahp = AH5416(ah);
 
 	if (AR_SREV_9285_10_OR_LATER(ah))
 		enableDacFifo = (REG_READ(ah, AR_PHY_TURBO) &
@@ -1589,7 +1566,7 @@ static void ath9k_hw_set_regs(struct ath_hal *ah, struct ath9k_channel *chan,
 		    (chan->chanmode == CHANNEL_G_HT40PLUS))
 			phymode |= AR_PHY_FC_DYN2040_PRI_CH;
 
-		if (ahp->ah_extprotspacing == ATH9K_HT_EXTPROTSPACING_25)
+		if (ah->ah_extprotspacing == ATH9K_HT_EXTPROTSPACING_25)
 			phymode |= AR_PHY_FC_DYN2040_EXT_CH;
 	}
 	REG_WRITE(ah, AR_PHY_TURBO, phymode);
@@ -1600,27 +1577,23 @@ static void ath9k_hw_set_regs(struct ath_hal *ah, struct ath9k_channel *chan,
 	REG_WRITE(ah, AR_CST, 0xF << AR_CST_TIMEOUT_LIMIT_S);
 }
 
-static bool ath9k_hw_chip_reset(struct ath_hal *ah,
+static bool ath9k_hw_chip_reset(struct ath_hw *ah,
 				struct ath9k_channel *chan)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
-
 	if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_WARM))
 		return false;
 
 	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE))
 		return false;
 
-	ahp->ah_chipFullSleep = false;
-
+	ah->ah_chipFullSleep = false;
 	ath9k_hw_init_pll(ah, chan);
-
 	ath9k_hw_set_rfmode(ah, chan);
 
 	return true;
 }
 
-static bool ath9k_hw_channel_change(struct ath_hal *ah,
+static bool ath9k_hw_channel_change(struct ath_hw *ah,
 				    struct ath9k_channel *chan,
 				    enum ath9k_ht_macmode macmode)
 {
@@ -1694,7 +1667,7 @@ static bool ath9k_hw_channel_change(struct ath_hal *ah,
 	return true;
 }
 
-static void ath9k_hw_9280_spur_mitigate(struct ath_hal *ah, struct ath9k_channel *chan)
+static void ath9k_hw_9280_spur_mitigate(struct ath_hw *ah, struct ath9k_channel *chan)
 {
 	int bb_spur = AR_NO_SPUR;
 	int freq;
@@ -1944,7 +1917,7 @@ static void ath9k_hw_9280_spur_mitigate(struct ath_hal *ah, struct ath9k_channel
 	REG_WRITE(ah, AR_PHY_MASK2_P_61_45, tmp_mask);
 }
 
-static void ath9k_hw_spur_mitigate(struct ath_hal *ah, struct ath9k_channel *chan)
+static void ath9k_hw_spur_mitigate(struct ath_hw *ah, struct ath9k_channel *chan)
 {
 	int bb_spur = AR_NO_SPUR;
 	int bin, cur_bin;
@@ -2145,27 +2118,26 @@ static void ath9k_hw_spur_mitigate(struct ath_hal *ah, struct ath9k_channel *cha
 	REG_WRITE(ah, AR_PHY_MASK2_P_61_45, tmp_mask);
 }
 
-int ath9k_hw_reset(struct ath_hal *ah, struct ath9k_channel *chan,
+int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 		    bool bChannelChange)
 {
 	u32 saveLedState;
 	struct ath_softc *sc = ah->ah_sc;
-	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct ath9k_channel *curchan = ah->ah_curchan;
 	u32 saveDefAntenna;
 	u32 macStaId1;
 	int i, rx_chainmask, r;
 
-	ahp->ah_extprotspacing = sc->ht_extprotspacing;
-	ahp->ah_txchainmask = sc->tx_chainmask;
-	ahp->ah_rxchainmask = sc->rx_chainmask;
+	ah->ah_extprotspacing = sc->ht_extprotspacing;
+	ah->ah_txchainmask = sc->tx_chainmask;
+	ah->ah_rxchainmask = sc->rx_chainmask;
 
 	if (AR_SREV_9285(ah)) {
-		ahp->ah_txchainmask &= 0x1;
-		ahp->ah_rxchainmask &= 0x1;
+		ah->ah_txchainmask &= 0x1;
+		ah->ah_rxchainmask &= 0x1;
 	} else if (AR_SREV_9280(ah)) {
-		ahp->ah_txchainmask &= 0x3;
-		ahp->ah_rxchainmask &= 0x3;
+		ah->ah_txchainmask &= 0x3;
+		ah->ah_rxchainmask &= 0x3;
 	}
 
 	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE))
@@ -2175,7 +2147,7 @@ int ath9k_hw_reset(struct ath_hal *ah, struct ath9k_channel *chan,
 		ath9k_hw_getnf(ah, curchan);
 
 	if (bChannelChange &&
-	    (ahp->ah_chipFullSleep != true) &&
+	    (ah->ah_chipFullSleep != true) &&
 	    (ah->ah_curchan != NULL) &&
 	    (chan->channel != ah->ah_curchan->channel) &&
 	    ((chan->channelFlags & CHANNEL_ALL) ==
@@ -2253,7 +2225,7 @@ int ath9k_hw_reset(struct ath_hal *ah, struct ath9k_channel *chan,
 		  | AR_STA_ID1_RTS_USE_DEF
 		  | (ah->ah_config.
 		     ack_6mb ? AR_STA_ID1_ACKCTS_6MB : 0)
-		  | ahp->ah_staId1Defaults);
+		  | ah->ah_staId1Defaults);
 	ath9k_hw_set_operating_mode(ah, ah->ah_opmode);
 
 	REG_WRITE(ah, AR_BSSMSKL, get_unaligned_le32(sc->bssidmask));
@@ -2280,7 +2252,7 @@ int ath9k_hw_reset(struct ath_hal *ah, struct ath9k_channel *chan,
 	for (i = 0; i < AR_NUM_DCU; i++)
 		REG_WRITE(ah, AR_DQCUMASK(i), 1 << i);
 
-	ahp->ah_intrTxqs = 0;
+	ah->ah_intrTxqs = 0;
 	for (i = 0; i < ah->ah_caps.total_queues; i++)
 		ath9k_hw_resettxqueue(ah, i);
 
@@ -2300,7 +2272,7 @@ int ath9k_hw_reset(struct ath_hal *ah, struct ath9k_channel *chan,
 
 	REG_WRITE(ah, AR_OBS, 8);
 
-	if (ahp->ah_intrMitigation) {
+	if (ah->ah_intrMitigation) {
 
 		REG_RMW_FIELD(ah, AR_RIMT, AR_RIMT_LAST, 500);
 		REG_RMW_FIELD(ah, AR_RIMT, AR_RIMT_FIRST, 2000);
@@ -2311,7 +2283,7 @@ int ath9k_hw_reset(struct ath_hal *ah, struct ath9k_channel *chan,
 	if (!ath9k_hw_init_cal(ah, chan))
 		return -EIO;;
 
-	rx_chainmask = ahp->ah_rxchainmask;
+	rx_chainmask = ah->ah_rxchainmask;
 	if ((rx_chainmask == 0x5) || (rx_chainmask == 0x3)) {
 		REG_WRITE(ah, AR_PHY_RX_CHAINMASK, rx_chainmask);
 		REG_WRITE(ah, AR_PHY_CAL_CHAINMASK, rx_chainmask);
@@ -2345,7 +2317,7 @@ int ath9k_hw_reset(struct ath_hal *ah, struct ath9k_channel *chan,
 /* Key Cache Management */
 /************************/
 
-bool ath9k_hw_keyreset(struct ath_hal *ah, u16 entry)
+bool ath9k_hw_keyreset(struct ath_hw *ah, u16 entry)
 {
 	u32 keyType;
 
@@ -2382,7 +2354,7 @@ bool ath9k_hw_keyreset(struct ath_hal *ah, u16 entry)
 	return true;
 }
 
-bool ath9k_hw_keysetmac(struct ath_hal *ah, u16 entry, const u8 *mac)
+bool ath9k_hw_keysetmac(struct ath_hw *ah, u16 entry, const u8 *mac)
 {
 	u32 macHi, macLo;
 
@@ -2410,7 +2382,7 @@ bool ath9k_hw_keysetmac(struct ath_hal *ah, u16 entry, const u8 *mac)
 	return true;
 }
 
-bool ath9k_hw_set_keycache_entry(struct ath_hal *ah, u16 entry,
+bool ath9k_hw_set_keycache_entry(struct ath_hw *ah, u16 entry,
 				 const struct ath9k_keyval *k,
 				 const u8 *mac, int xorKey)
 {
@@ -2420,7 +2392,6 @@ bool ath9k_hw_set_keycache_entry(struct ath_hal *ah, u16 entry,
 	u32 xorMask = xorKey ?
 		(ATH9K_KEY_XOR << 24 | ATH9K_KEY_XOR << 16 | ATH9K_KEY_XOR << 8
 		 | ATH9K_KEY_XOR) : 0;
-	struct ath_hal_5416 *ahp = AH5416(ah);
 
 	if (entry >= pCap->keycache_size) {
 		DPRINTF(ah->ah_sc, ATH_DBG_KEYCACHE,
@@ -2491,7 +2462,7 @@ bool ath9k_hw_set_keycache_entry(struct ath_hal *ah, u16 entry,
 		REG_WRITE(ah, AR_KEYTABLE_TYPE(entry), keyType);
 		(void) ath9k_hw_keysetmac(ah, entry, mac);
 
-		if (ahp->ah_miscMode & AR_PCU_MIC_NEW_LOC_ENA) {
+		if (ah->ah_miscMode & AR_PCU_MIC_NEW_LOC_ENA) {
 			u32 mic0, mic1, mic2, mic3, mic4;
 
 			mic0 = get_unaligned_le32(k->kv_mic + 0);
@@ -2541,7 +2512,7 @@ bool ath9k_hw_set_keycache_entry(struct ath_hal *ah, u16 entry,
 	return true;
 }
 
-bool ath9k_hw_keyisvalid(struct ath_hal *ah, u16 entry)
+bool ath9k_hw_keyisvalid(struct ath_hw *ah, u16 entry)
 {
 	if (entry < ah->ah_caps.keycache_size) {
 		u32 val = REG_READ(ah, AR_KEYTABLE_MAC1(entry));
@@ -2555,7 +2526,7 @@ bool ath9k_hw_keyisvalid(struct ath_hal *ah, u16 entry)
 /* Power Management (Chipset) */
 /******************************/
 
-static void ath9k_set_power_sleep(struct ath_hal *ah, int setChip)
+static void ath9k_set_power_sleep(struct ath_hw *ah, int setChip)
 {
 	REG_SET_BIT(ah, AR_STA_ID1, AR_STA_ID1_PWR_SAV);
 	if (setChip) {
@@ -2569,7 +2540,7 @@ static void ath9k_set_power_sleep(struct ath_hal *ah, int setChip)
 	}
 }
 
-static void ath9k_set_power_network_sleep(struct ath_hal *ah, int setChip)
+static void ath9k_set_power_network_sleep(struct ath_hw *ah, int setChip)
 {
 	REG_SET_BIT(ah, AR_STA_ID1, AR_STA_ID1_PWR_SAV);
 	if (setChip) {
@@ -2585,8 +2556,7 @@ static void ath9k_set_power_network_sleep(struct ath_hal *ah, int setChip)
 	}
 }
 
-static bool ath9k_hw_set_power_awake(struct ath_hal *ah,
-				     int setChip)
+static bool ath9k_hw_set_power_awake(struct ath_hw *ah, int setChip)
 {
 	u32 val;
 	int i;
@@ -2627,17 +2597,15 @@ static bool ath9k_hw_set_power_awake(struct ath_hal *ah,
 	return true;
 }
 
-bool ath9k_hw_setpower(struct ath_hal *ah,
-		       enum ath9k_power_mode mode)
+bool ath9k_hw_setpower(struct ath_hw *ah, enum ath9k_power_mode mode)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
+	int status = true, setChip = true;
 	static const char *modes[] = {
 		"AWAKE",
 		"FULL-SLEEP",
 		"NETWORK SLEEP",
 		"UNDEFINED"
 	};
-	int status = true, setChip = true;
 
 	DPRINTF(ah->ah_sc, ATH_DBG_POWER_MGMT, "%s -> %s (%s)\n",
 		modes[ah->ah_power_mode], modes[mode],
@@ -2649,7 +2617,7 @@ bool ath9k_hw_setpower(struct ath_hal *ah,
 		break;
 	case ATH9K_PM_FULL_SLEEP:
 		ath9k_set_power_sleep(ah, setChip);
-		ahp->ah_chipFullSleep = true;
+		ah->ah_chipFullSleep = true;
 		break;
 	case ATH9K_PM_NETWORK_SLEEP:
 		ath9k_set_power_network_sleep(ah, setChip);
@@ -2664,9 +2632,8 @@ bool ath9k_hw_setpower(struct ath_hal *ah,
 	return status;
 }
 
-void ath9k_hw_configpcipowersave(struct ath_hal *ah, int restore)
+void ath9k_hw_configpcipowersave(struct ath_hw *ah, int restore)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
 	u8 i;
 
 	if (ah->ah_isPciExpress != true)
@@ -2679,9 +2646,9 @@ void ath9k_hw_configpcipowersave(struct ath_hal *ah, int restore)
 		return;
 
 	if (AR_SREV_9280_20_OR_LATER(ah)) {
-		for (i = 0; i < ahp->ah_iniPcieSerdes.ia_rows; i++) {
-			REG_WRITE(ah, INI_RA(&ahp->ah_iniPcieSerdes, i, 0),
-				  INI_RA(&ahp->ah_iniPcieSerdes, i, 1));
+		for (i = 0; i < ah->ah_iniPcieSerdes.ia_rows; i++) {
+			REG_WRITE(ah, INI_RA(&ah->ah_iniPcieSerdes, i, 0),
+				  INI_RA(&ah->ah_iniPcieSerdes, i, 1));
 		}
 		udelay(1000);
 	} else if (AR_SREV_9280(ah) &&
@@ -2730,14 +2697,13 @@ void ath9k_hw_configpcipowersave(struct ath_hal *ah, int restore)
 		else
 			REG_WRITE(ah, AR_WA, AR_WA_DEFAULT);
 	}
-
 }
 
 /**********************/
 /* Interrupt Handling */
 /**********************/
 
-bool ath9k_hw_intrpend(struct ath_hal *ah)
+bool ath9k_hw_intrpend(struct ath_hw *ah)
 {
 	u32 host_isr;
 
@@ -2756,14 +2722,13 @@ bool ath9k_hw_intrpend(struct ath_hal *ah)
 	return false;
 }
 
-bool ath9k_hw_getisr(struct ath_hal *ah, enum ath9k_int *masked)
+bool ath9k_hw_getisr(struct ath_hw *ah, enum ath9k_int *masked)
 {
 	u32 isr = 0;
 	u32 mask2 = 0;
 	struct ath9k_hw_capabilities *pCap = &ah->ah_caps;
 	u32 sync_cause = 0;
 	bool fatal_int = false;
-	struct ath_hal_5416 *ahp = AH5416(ah);
 
 	if (!AR_SREV_9100(ah)) {
 		if (REG_READ(ah, AR_INTR_ASYNC_CAUSE) & AR_INTR_MAC_IRQ) {
@@ -2811,7 +2776,7 @@ bool ath9k_hw_getisr(struct ath_hal *ah, enum ath9k_int *masked)
 
 		*masked = isr & ATH9K_INT_COMMON;
 
-		if (ahp->ah_intrMitigation) {
+		if (ah->ah_intrMitigation) {
 			if (isr & (AR_ISR_RXMINTR | AR_ISR_RXINTM))
 				*masked |= ATH9K_INT_RX;
 		}
@@ -2826,12 +2791,12 @@ bool ath9k_hw_getisr(struct ath_hal *ah, enum ath9k_int *masked)
 			*masked |= ATH9K_INT_TX;
 
 			s0_s = REG_READ(ah, AR_ISR_S0_S);
-			ahp->ah_intrTxqs |= MS(s0_s, AR_ISR_S0_QCU_TXOK);
-			ahp->ah_intrTxqs |= MS(s0_s, AR_ISR_S0_QCU_TXDESC);
+			ah->ah_intrTxqs |= MS(s0_s, AR_ISR_S0_QCU_TXOK);
+			ah->ah_intrTxqs |= MS(s0_s, AR_ISR_S0_QCU_TXDESC);
 
 			s1_s = REG_READ(ah, AR_ISR_S1_S);
-			ahp->ah_intrTxqs |= MS(s1_s, AR_ISR_S1_QCU_TXERR);
-			ahp->ah_intrTxqs |= MS(s1_s, AR_ISR_S1_QCU_TXEOL);
+			ah->ah_intrTxqs |= MS(s1_s, AR_ISR_S1_QCU_TXERR);
+			ah->ah_intrTxqs |= MS(s1_s, AR_ISR_S1_QCU_TXEOL);
 		}
 
 		if (isr & AR_ISR_RXORN) {
@@ -2888,15 +2853,14 @@ bool ath9k_hw_getisr(struct ath_hal *ah, enum ath9k_int *masked)
 	return true;
 }
 
-enum ath9k_int ath9k_hw_intrget(struct ath_hal *ah)
+enum ath9k_int ath9k_hw_intrget(struct ath_hw *ah)
 {
-	return AH5416(ah)->ah_maskReg;
+	return ah->ah_maskReg;
 }
 
-enum ath9k_int ath9k_hw_set_interrupts(struct ath_hal *ah, enum ath9k_int ints)
+enum ath9k_int ath9k_hw_set_interrupts(struct ath_hw *ah, enum ath9k_int ints)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
-	u32 omask = ahp->ah_maskReg;
+	u32 omask = ah->ah_maskReg;
 	u32 mask, mask2;
 	struct ath9k_hw_capabilities *pCap = &ah->ah_caps;
 
@@ -2919,18 +2883,18 @@ enum ath9k_int ath9k_hw_set_interrupts(struct ath_hal *ah, enum ath9k_int ints)
 	mask2 = 0;
 
 	if (ints & ATH9K_INT_TX) {
-		if (ahp->ah_txOkInterruptMask)
+		if (ah->ah_txOkInterruptMask)
 			mask |= AR_IMR_TXOK;
-		if (ahp->ah_txDescInterruptMask)
+		if (ah->ah_txDescInterruptMask)
 			mask |= AR_IMR_TXDESC;
-		if (ahp->ah_txErrInterruptMask)
+		if (ah->ah_txErrInterruptMask)
 			mask |= AR_IMR_TXERR;
-		if (ahp->ah_txEolInterruptMask)
+		if (ah->ah_txEolInterruptMask)
 			mask |= AR_IMR_TXEOL;
 	}
 	if (ints & ATH9K_INT_RX) {
 		mask |= AR_IMR_RXERR;
-		if (ahp->ah_intrMitigation)
+		if (ah->ah_intrMitigation)
 			mask |= AR_IMR_RXMINTR | AR_IMR_RXINTM;
 		else
 			mask |= AR_IMR_RXOK | AR_IMR_RXDESC;
@@ -2968,7 +2932,7 @@ enum ath9k_int ath9k_hw_set_interrupts(struct ath_hal *ah, enum ath9k_int ints)
 					   AR_IMR_S2_TSFOOR |
 					   AR_IMR_S2_GTT | AR_IMR_S2_CST);
 	REG_WRITE(ah, AR_IMR_S2, mask | mask2);
-	ahp->ah_maskReg = ints;
+	ah->ah_maskReg = ints;
 
 	if (!(pCap->hw_caps & ATH9K_HW_CAP_AUTOSLEEP)) {
 		if (ints & ATH9K_INT_TIM_TIMER)
@@ -3002,12 +2966,11 @@ enum ath9k_int ath9k_hw_set_interrupts(struct ath_hal *ah, enum ath9k_int ints)
 /* Beacon Handling */
 /*******************/
 
-void ath9k_hw_beaconinit(struct ath_hal *ah, u32 next_beacon, u32 beacon_period)
+void ath9k_hw_beaconinit(struct ath_hw *ah, u32 next_beacon, u32 beacon_period)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
 	int flags = 0;
 
-	ahp->ah_beaconInterval = beacon_period;
+	ah->ah_beaconInterval = beacon_period;
 
 	switch (ah->ah_opmode) {
 	case NL80211_IFTYPE_STATION:
@@ -3022,7 +2985,7 @@ void ath9k_hw_beaconinit(struct ath_hal *ah, u32 next_beacon, u32 beacon_period)
 			    AR_TXCFG_ADHOC_BEACON_ATIM_TX_POLICY);
 		REG_WRITE(ah, AR_NEXT_NDP_TIMER,
 			  TU_TO_USEC(next_beacon +
-				     (ahp->ah_atimWindow ? ahp->
+				     (ah->ah_atimWindow ? ah->
 				      ah_atimWindow : 1)));
 		flags |= AR_NDP_TIMER_EN;
 	case NL80211_IFTYPE_AP:
@@ -3060,7 +3023,7 @@ void ath9k_hw_beaconinit(struct ath_hal *ah, u32 next_beacon, u32 beacon_period)
 	REG_SET_BIT(ah, AR_TIMER_MODE, flags);
 }
 
-void ath9k_hw_set_sta_beacon_timers(struct ath_hal *ah,
+void ath9k_hw_set_sta_beacon_timers(struct ath_hw *ah,
 				    const struct ath9k_beacon_state *bs)
 {
 	u32 nextTbtt, beaconintval, dtimperiod, beacontimeout;
@@ -3124,9 +3087,8 @@ void ath9k_hw_set_sta_beacon_timers(struct ath_hal *ah,
 /* HW Capabilities */
 /*******************/
 
-bool ath9k_hw_fill_cap_info(struct ath_hal *ah)
+bool ath9k_hw_fill_cap_info(struct ath_hw *ah)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct ath9k_hw_capabilities *pCap = &ah->ah_caps;
 	u16 capField = 0, eeval;
 
@@ -3195,7 +3157,7 @@ bool ath9k_hw_fill_cap_info(struct ath_hal *ah)
 	}
 
 	if (!(AR_SREV_9280(ah) && (ah->hw_version.macRev == 0)))
-		ahp->ah_miscMode |= AR_PCU_MIC_NEW_LOC_ENA;
+		ah->ah_miscMode |= AR_PCU_MIC_NEW_LOC_ENA;
 
 	pCap->low_2ghz_chan = 2312;
 	pCap->high_2ghz_chan = 2732;
@@ -3317,10 +3279,9 @@ bool ath9k_hw_fill_cap_info(struct ath_hal *ah)
 	return true;
 }
 
-bool ath9k_hw_getcapability(struct ath_hal *ah, enum ath9k_capability_type type,
+bool ath9k_hw_getcapability(struct ath_hw *ah, enum ath9k_capability_type type,
 			    u32 capability, u32 *result)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
 	const struct ath9k_hw_capabilities *pCap = &ah->ah_caps;
 
 	switch (type) {
@@ -3341,17 +3302,17 @@ bool ath9k_hw_getcapability(struct ath_hal *ah, enum ath9k_capability_type type,
 		case 0:
 			return true;
 		case 1:
-			return (ahp->ah_staId1Defaults &
+			return (ah->ah_staId1Defaults &
 				AR_STA_ID1_CRPT_MIC_ENABLE) ? true :
 			false;
 		}
 	case ATH9K_CAP_TKIP_SPLIT:
-		return (ahp->ah_miscMode & AR_PCU_MIC_NEW_LOC_ENA) ?
+		return (ah->ah_miscMode & AR_PCU_MIC_NEW_LOC_ENA) ?
 			false : true;
 	case ATH9K_CAP_WME_TKIPMIC:
 		return 0;
 	case ATH9K_CAP_PHYCOUNTERS:
-		return ahp->ah_hasHwPhyCounters ? 0 : -ENXIO;
+		return ah->ah_hasHwPhyCounters ? 0 : -ENXIO;
 	case ATH9K_CAP_DIVERSITY:
 		return (REG_READ(ah, AR_PHY_CCK_DETECT) &
 			AR_PHY_CCK_DETECT_BB_ENABLE_ANT_FAST_DIV) ?
@@ -3366,14 +3327,14 @@ bool ath9k_hw_getcapability(struct ath_hal *ah, enum ath9k_capability_type type,
 			if (REG_READ(ah, AR_STA_ID1) & AR_STA_ID1_ADHOC) {
 				return false;
 			} else {
-				return (ahp->ah_staId1Defaults &
+				return (ah->ah_staId1Defaults &
 					AR_STA_ID1_MCAST_KSRCH) ? true :
 					false;
 			}
 		}
 		return false;
 	case ATH9K_CAP_TSF_ADJUST:
-		return (ahp->ah_miscMode & AR_PCU_TX_ADD_TSF) ?
+		return (ah->ah_miscMode & AR_PCU_TX_ADD_TSF) ?
 			true : false;
 	case ATH9K_CAP_RFSILENT:
 		if (capability == 3)
@@ -3404,19 +3365,18 @@ bool ath9k_hw_getcapability(struct ath_hal *ah, enum ath9k_capability_type type,
 	}
 }
 
-bool ath9k_hw_setcapability(struct ath_hal *ah, enum ath9k_capability_type type,
+bool ath9k_hw_setcapability(struct ath_hw *ah, enum ath9k_capability_type type,
 			    u32 capability, u32 setting, int *status)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
 	u32 v;
 
 	switch (type) {
 	case ATH9K_CAP_TKIP_MIC:
 		if (setting)
-			ahp->ah_staId1Defaults |=
+			ah->ah_staId1Defaults |=
 				AR_STA_ID1_CRPT_MIC_ENABLE;
 		else
-			ahp->ah_staId1Defaults &=
+			ah->ah_staId1Defaults &=
 				~AR_STA_ID1_CRPT_MIC_ENABLE;
 		return true;
 	case ATH9K_CAP_DIVERSITY:
@@ -3429,15 +3389,15 @@ bool ath9k_hw_setcapability(struct ath_hal *ah, enum ath9k_capability_type type,
 		return true;
 	case ATH9K_CAP_MCAST_KEYSRCH:
 		if (setting)
-			ahp->ah_staId1Defaults |= AR_STA_ID1_MCAST_KSRCH;
+			ah->ah_staId1Defaults |= AR_STA_ID1_MCAST_KSRCH;
 		else
-			ahp->ah_staId1Defaults &= ~AR_STA_ID1_MCAST_KSRCH;
+			ah->ah_staId1Defaults &= ~AR_STA_ID1_MCAST_KSRCH;
 		return true;
 	case ATH9K_CAP_TSF_ADJUST:
 		if (setting)
-			ahp->ah_miscMode |= AR_PCU_TX_ADD_TSF;
+			ah->ah_miscMode |= AR_PCU_TX_ADD_TSF;
 		else
-			ahp->ah_miscMode &= ~AR_PCU_TX_ADD_TSF;
+			ah->ah_miscMode &= ~AR_PCU_TX_ADD_TSF;
 		return true;
 	default:
 		return false;
@@ -3448,7 +3408,7 @@ bool ath9k_hw_setcapability(struct ath_hal *ah, enum ath9k_capability_type type,
 /* GPIO / RFKILL / Antennae */
 /****************************/
 
-static void ath9k_hw_gpio_cfg_output_mux(struct ath_hal *ah,
+static void ath9k_hw_gpio_cfg_output_mux(struct ath_hw *ah,
 					 u32 gpio, u32 type)
 {
 	int addr;
@@ -3476,7 +3436,7 @@ static void ath9k_hw_gpio_cfg_output_mux(struct ath_hal *ah,
 	}
 }
 
-void ath9k_hw_cfg_gpio_input(struct ath_hal *ah, u32 gpio)
+void ath9k_hw_cfg_gpio_input(struct ath_hw *ah, u32 gpio)
 {
 	u32 gpio_shift;
 
@@ -3490,7 +3450,7 @@ void ath9k_hw_cfg_gpio_input(struct ath_hal *ah, u32 gpio)
 		(AR_GPIO_OE_OUT_DRV << gpio_shift));
 }
 
-u32 ath9k_hw_gpio_get(struct ath_hal *ah, u32 gpio)
+u32 ath9k_hw_gpio_get(struct ath_hw *ah, u32 gpio)
 {
 #define MS_REG_READ(x, y) \
 	(MS(REG_READ(ah, AR_GPIO_IN_OUT), x##_GPIO_IN_VAL) & (AR_GPIO_BIT(y)))
@@ -3506,7 +3466,7 @@ u32 ath9k_hw_gpio_get(struct ath_hal *ah, u32 gpio)
 		return MS_REG_READ(AR, gpio) != 0;
 }
 
-void ath9k_hw_cfg_output(struct ath_hal *ah, u32 gpio,
+void ath9k_hw_cfg_output(struct ath_hw *ah, u32 gpio,
 			 u32 ah_signal_type)
 {
 	u32 gpio_shift;
@@ -3521,14 +3481,14 @@ void ath9k_hw_cfg_output(struct ath_hal *ah, u32 gpio,
 		(AR_GPIO_OE_OUT_DRV << gpio_shift));
 }
 
-void ath9k_hw_set_gpio(struct ath_hal *ah, u32 gpio, u32 val)
+void ath9k_hw_set_gpio(struct ath_hw *ah, u32 gpio, u32 val)
 {
 	REG_RMW(ah, AR_GPIO_IN_OUT, ((val & 1) << gpio),
 		AR_GPIO_BIT(gpio));
 }
 
 #if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
-void ath9k_enable_rfkill(struct ath_hal *ah)
+void ath9k_enable_rfkill(struct ath_hw *ah)
 {
 	REG_SET_BIT(ah, AR_GPIO_INPUT_EN_VAL,
 		    AR_GPIO_INPUT_EN_VAL_RFSILENT_BB);
@@ -3541,24 +3501,23 @@ void ath9k_enable_rfkill(struct ath_hal *ah)
 }
 #endif
 
-u32 ath9k_hw_getdefantenna(struct ath_hal *ah)
+u32 ath9k_hw_getdefantenna(struct ath_hw *ah)
 {
 	return REG_READ(ah, AR_DEF_ANTENNA) & 0x7;
 }
 
-void ath9k_hw_setantenna(struct ath_hal *ah, u32 antenna)
+void ath9k_hw_setantenna(struct ath_hw *ah, u32 antenna)
 {
 	REG_WRITE(ah, AR_DEF_ANTENNA, (antenna & 0x7));
 }
 
-bool ath9k_hw_setantennaswitch(struct ath_hal *ah,
+bool ath9k_hw_setantennaswitch(struct ath_hw *ah,
 			       enum ath9k_ant_setting settings,
 			       struct ath9k_channel *chan,
 			       u8 *tx_chainmask,
 			       u8 *rx_chainmask,
 			       u8 *antenna_cfgd)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
 	static u8 tx_chainmask_cfg, rx_chainmask_cfg;
 
 	if (AR_SREV_9280(ah)) {
@@ -3591,7 +3550,7 @@ bool ath9k_hw_setantennaswitch(struct ath_hal *ah,
 			break;
 		}
 	} else {
-		ahp->ah_diversityControl = settings;
+		ah->ah_diversityControl = settings;
 	}
 
 	return true;
@@ -3601,7 +3560,7 @@ bool ath9k_hw_setantennaswitch(struct ath_hal *ah,
 /* General Operation */
 /*********************/
 
-u32 ath9k_hw_getrxfilter(struct ath_hal *ah)
+u32 ath9k_hw_getrxfilter(struct ath_hw *ah)
 {
 	u32 bits = REG_READ(ah, AR_RX_FILTER);
 	u32 phybits = REG_READ(ah, AR_PHY_ERR);
@@ -3614,7 +3573,7 @@ u32 ath9k_hw_getrxfilter(struct ath_hal *ah)
 	return bits;
 }
 
-void ath9k_hw_setrxfilter(struct ath_hal *ah, u32 bits)
+void ath9k_hw_setrxfilter(struct ath_hw *ah, u32 bits)
 {
 	u32 phybits;
 
@@ -3634,12 +3593,12 @@ void ath9k_hw_setrxfilter(struct ath_hal *ah, u32 bits)
 			  REG_READ(ah, AR_RXCFG) & ~AR_RXCFG_ZLFDMA);
 }
 
-bool ath9k_hw_phy_disable(struct ath_hal *ah)
+bool ath9k_hw_phy_disable(struct ath_hw *ah)
 {
 	return ath9k_hw_set_reset_reg(ah, ATH9K_RESET_WARM);
 }
 
-bool ath9k_hw_disable(struct ath_hal *ah)
+bool ath9k_hw_disable(struct ath_hw *ah)
 {
 	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE))
 		return false;
@@ -3647,7 +3606,7 @@ bool ath9k_hw_disable(struct ath_hal *ah)
 	return ath9k_hw_set_reset_reg(ah, ATH9K_RESET_COLD);
 }
 
-bool ath9k_hw_set_txpowerlimit(struct ath_hal *ah, u32 limit)
+bool ath9k_hw_set_txpowerlimit(struct ath_hw *ah, u32 limit)
 {
 	struct ath9k_channel *chan = ah->ah_curchan;
 	struct ieee80211_channel *channel = chan->chan;
@@ -3665,17 +3624,17 @@ bool ath9k_hw_set_txpowerlimit(struct ath_hal *ah, u32 limit)
 	return true;
 }
 
-void ath9k_hw_setmac(struct ath_hal *ah, const u8 *mac)
+void ath9k_hw_setmac(struct ath_hw *ah, const u8 *mac)
 {
 	memcpy(ah->macaddr, mac, ETH_ALEN);
 }
 
-void ath9k_hw_setopmode(struct ath_hal *ah)
+void ath9k_hw_setopmode(struct ath_hw *ah)
 {
 	ath9k_hw_set_operating_mode(ah, ah->ah_opmode);
 }
 
-void ath9k_hw_setmcastfilter(struct ath_hal *ah, u32 filter0, u32 filter1)
+void ath9k_hw_setmcastfilter(struct ath_hw *ah, u32 filter0, u32 filter1)
 {
 	REG_WRITE(ah, AR_MCAST_FIL0, filter0);
 	REG_WRITE(ah, AR_MCAST_FIL1, filter1);
@@ -3694,7 +3653,7 @@ void ath9k_hw_write_associd(struct ath_softc *sc)
 		  ((sc->curaid & 0x3fff) << AR_BSS_ID1_AID_S));
 }
 
-u64 ath9k_hw_gettsf64(struct ath_hal *ah)
+u64 ath9k_hw_gettsf64(struct ath_hw *ah)
 {
 	u64 tsf;
 
@@ -3704,14 +3663,14 @@ u64 ath9k_hw_gettsf64(struct ath_hal *ah)
 	return tsf;
 }
 
-void ath9k_hw_settsf64(struct ath_hal *ah, u64 tsf64)
+void ath9k_hw_settsf64(struct ath_hw *ah, u64 tsf64)
 {
 	REG_WRITE(ah, AR_TSF_L32, 0x00000000);
 	REG_WRITE(ah, AR_TSF_U32, (tsf64 >> 32) & 0xffffffff);
 	REG_WRITE(ah, AR_TSF_L32, tsf64 & 0xffffffff);
 }
 
-void ath9k_hw_reset_tsf(struct ath_hal *ah)
+void ath9k_hw_reset_tsf(struct ath_hw *ah)
 {
 	int count;
 
@@ -3728,34 +3687,30 @@ void ath9k_hw_reset_tsf(struct ath_hal *ah)
 	REG_WRITE(ah, AR_RESET_TSF, AR_RESET_TSF_ONCE);
 }
 
-bool ath9k_hw_set_tsfadjust(struct ath_hal *ah, u32 setting)
+bool ath9k_hw_set_tsfadjust(struct ath_hw *ah, u32 setting)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
-
 	if (setting)
-		ahp->ah_miscMode |= AR_PCU_TX_ADD_TSF;
+		ah->ah_miscMode |= AR_PCU_TX_ADD_TSF;
 	else
-		ahp->ah_miscMode &= ~AR_PCU_TX_ADD_TSF;
+		ah->ah_miscMode &= ~AR_PCU_TX_ADD_TSF;
 
 	return true;
 }
 
-bool ath9k_hw_setslottime(struct ath_hal *ah, u32 us)
+bool ath9k_hw_setslottime(struct ath_hw *ah, u32 us)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
-
 	if (us < ATH9K_SLOT_TIME_9 || us > ath9k_hw_mac_to_usec(ah, 0xffff)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_RESET, "bad slot time %u\n", us);
-		ahp->ah_slottime = (u32) -1;
+		ah->ah_slottime = (u32) -1;
 		return false;
 	} else {
 		REG_WRITE(ah, AR_D_GBL_IFS_SLOT, ath9k_hw_mac_to_clks(ah, us));
-		ahp->ah_slottime = us;
+		ah->ah_slottime = us;
 		return true;
 	}
 }
 
-void ath9k_hw_set11nmac2040(struct ath_hal *ah, enum ath9k_ht_macmode mode)
+void ath9k_hw_set11nmac2040(struct ath_hw *ah, enum ath9k_ht_macmode mode)
 {
 	u32 macmode;
 
@@ -3772,7 +3727,7 @@ void ath9k_hw_set11nmac2040(struct ath_hal *ah, enum ath9k_ht_macmode mode)
 /*  Bluetooth Coexistence  */
 /***************************/
 
-void ath9k_hw_btcoex_enable(struct ath_hal *ah)
+void ath9k_hw_btcoex_enable(struct ath_hw *ah)
 {
 	/* connect bt_active to baseband */
 	REG_CLR_BIT(ah, AR_GPIO_INPUT_EN_VAL,
diff --git a/drivers/net/wireless/ath9k/hw.h b/drivers/net/wireless/ath9k/hw.h
index f4bf702..84914e2 100644
--- a/drivers/net/wireless/ath9k/hw.h
+++ b/drivers/net/wireless/ath9k/hw.h
@@ -42,8 +42,8 @@
 #define AR5416_MAGIC		0x19641014
 
 /* Register read/write primitives */
-#define REG_WRITE(_ah, _reg, _val) iowrite32(_val, _ah->ah_sh + _reg)
-#define REG_READ(_ah, _reg) ioread32(_ah->ah_sh + _reg)
+#define REG_WRITE(_ah, _reg, _val) iowrite32(_val, _ah->ah_sc->mem + _reg)
+#define REG_READ(_ah, _reg) ioread32(_ah->ah_sc->mem + _reg)
 
 #define SM(_v, _f)  (((_v) << _f##_S) & _f)
 #define MS(_v, _f)  (((_v) & _f) >> _f##_S)
@@ -417,46 +417,38 @@ struct ath9k_hw_version {
 	u16 analog2GhzRev;
 };
 
-struct ath_hal {
-	struct ath9k_hw_version hw_version;
-	void __iomem *ah_sh;
+struct ath_hw {
 	struct ath_softc *ah_sc;
-
-	enum nl80211_iftype ah_opmode;
+	struct ath9k_hw_version hw_version;
 	struct ath9k_ops_config ah_config;
 	struct ath9k_hw_capabilities ah_caps;
 	struct ath9k_regulatory regulatory;
-	u32 ah_flags;
-	u8 macaddr[ETH_ALEN];
-
-	enum ath9k_power_mode ah_power_mode;
-	enum ath9k_power_mode ah_restore_mode;
-
 	struct ath9k_channel ah_channels[38];
 	struct ath9k_channel *ah_curchan;
 
+	union {
+		struct ar5416_eeprom_def def;
+		struct ar5416_eeprom_4k map4k;
+	} ah_eeprom;
+
+	bool sw_mgmt_crypto;
 	bool ah_isPciExpress;
+	u8 macaddr[ETH_ALEN];
 	u16 ah_txTrigLevel;
 	u16 ah_rfsilent;
 	u32 ah_rfkill_gpio;
 	u32 ah_rfkill_polarity;
 	u32 ah_btactive_gpio;
 	u32 ah_wlanactive_gpio;
+	u32 ah_flags;
+	enum nl80211_iftype ah_opmode;
 
-	struct ath9k_nfcal_hist nfCalHist[NUM_NF_READINGS];
-
-	bool sw_mgmt_crypto;
-};
+	enum ath9k_power_mode ah_power_mode;
+	enum ath9k_power_mode ah_restore_mode;
 
-struct ath_hal_5416 {
-	struct ath_hal ah;
-	union {
-		struct ar5416_eeprom_def def;
-		struct ar5416_eeprom_4k map4k;
-	} ah_eeprom;
+	struct ath9k_nfcal_hist nfCalHist[NUM_NF_READINGS];
 	struct ar5416Stats ah_stats;
 	struct ath9k_tx_queue_info ah_txq[ATH9K_NUM_TX_QUEUES];
-	void __iomem *ah_cal_mem;
 
 	int16_t ah_curchanRadIndex;
 	u32 ah_maskReg;
@@ -574,85 +566,83 @@ struct ath_hal_5416 {
 	/* To indicate EEPROM mapping used */
 	enum hal_eep_map ah_eep_map;
 };
-#define AH5416(_ah) ((struct ath_hal_5416 *)(_ah))
 
 /* Attach, Detach, Reset */
 const char *ath9k_hw_probe(u16 vendorid, u16 devid);
-void ath9k_hw_detach(struct ath_hal *ah);
-struct ath_hal *ath9k_hw_attach(u16 devid, struct ath_softc *sc,
-				void __iomem *mem, int *error);
-void ath9k_hw_rfdetach(struct ath_hal *ah);
-int ath9k_hw_reset(struct ath_hal *ah, struct ath9k_channel *chan,
+void ath9k_hw_detach(struct ath_hw *ah);
+struct ath_hw *ath9k_hw_attach(u16 devid, struct ath_softc *sc, int *error);
+void ath9k_hw_rfdetach(struct ath_hw *ah);
+int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 		   bool bChannelChange);
-bool ath9k_hw_fill_cap_info(struct ath_hal *ah);
-bool ath9k_hw_getcapability(struct ath_hal *ah, enum ath9k_capability_type type,
+bool ath9k_hw_fill_cap_info(struct ath_hw *ah);
+bool ath9k_hw_getcapability(struct ath_hw *ah, enum ath9k_capability_type type,
 			    u32 capability, u32 *result);
-bool ath9k_hw_setcapability(struct ath_hal *ah, enum ath9k_capability_type type,
+bool ath9k_hw_setcapability(struct ath_hw *ah, enum ath9k_capability_type type,
 			    u32 capability, u32 setting, int *status);
 
 /* Key Cache Management */
-bool ath9k_hw_keyreset(struct ath_hal *ah, u16 entry);
-bool ath9k_hw_keysetmac(struct ath_hal *ah, u16 entry, const u8 *mac);
-bool ath9k_hw_set_keycache_entry(struct ath_hal *ah, u16 entry,
+bool ath9k_hw_keyreset(struct ath_hw *ah, u16 entry);
+bool ath9k_hw_keysetmac(struct ath_hw *ah, u16 entry, const u8 *mac);
+bool ath9k_hw_set_keycache_entry(struct ath_hw *ah, u16 entry,
 				 const struct ath9k_keyval *k,
 				 const u8 *mac, int xorKey);
-bool ath9k_hw_keyisvalid(struct ath_hal *ah, u16 entry);
+bool ath9k_hw_keyisvalid(struct ath_hw *ah, u16 entry);
 
 /* GPIO / RFKILL / Antennae */
-void ath9k_hw_cfg_gpio_input(struct ath_hal *ah, u32 gpio);
-u32 ath9k_hw_gpio_get(struct ath_hal *ah, u32 gpio);
-void ath9k_hw_cfg_output(struct ath_hal *ah, u32 gpio,
+void ath9k_hw_cfg_gpio_input(struct ath_hw *ah, u32 gpio);
+u32 ath9k_hw_gpio_get(struct ath_hw *ah, u32 gpio);
+void ath9k_hw_cfg_output(struct ath_hw *ah, u32 gpio,
 			 u32 ah_signal_type);
-void ath9k_hw_set_gpio(struct ath_hal *ah, u32 gpio, u32 val);
+void ath9k_hw_set_gpio(struct ath_hw *ah, u32 gpio, u32 val);
 #if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
-void ath9k_enable_rfkill(struct ath_hal *ah);
+void ath9k_enable_rfkill(struct ath_hw *ah);
 #endif
-u32 ath9k_hw_getdefantenna(struct ath_hal *ah);
-void ath9k_hw_setantenna(struct ath_hal *ah, u32 antenna);
-bool ath9k_hw_setantennaswitch(struct ath_hal *ah,
+u32 ath9k_hw_getdefantenna(struct ath_hw *ah);
+void ath9k_hw_setantenna(struct ath_hw *ah, u32 antenna);
+bool ath9k_hw_setantennaswitch(struct ath_hw *ah,
 			       enum ath9k_ant_setting settings,
 			       struct ath9k_channel *chan,
 			       u8 *tx_chainmask, u8 *rx_chainmask,
 			       u8 *antenna_cfgd);
 
 /* General Operation */
-bool ath9k_hw_wait(struct ath_hal *ah, u32 reg, u32 mask, u32 val);
+bool ath9k_hw_wait(struct ath_hw *ah, u32 reg, u32 mask, u32 val);
 u32 ath9k_hw_reverse_bits(u32 val, u32 n);
-bool ath9k_get_channel_edges(struct ath_hal *ah, u16 flags, u16 *low, u16 *high);
-u16 ath9k_hw_computetxtime(struct ath_hal *ah, struct ath_rate_table *rates,
+bool ath9k_get_channel_edges(struct ath_hw *ah, u16 flags, u16 *low, u16 *high);
+u16 ath9k_hw_computetxtime(struct ath_hw *ah, struct ath_rate_table *rates,
 			   u32 frameLen, u16 rateix, bool shortPreamble);
-void ath9k_hw_get_channel_centers(struct ath_hal *ah,
+void ath9k_hw_get_channel_centers(struct ath_hw *ah,
 				  struct ath9k_channel *chan,
 				  struct chan_centers *centers);
-u32 ath9k_hw_getrxfilter(struct ath_hal *ah);
-void ath9k_hw_setrxfilter(struct ath_hal *ah, u32 bits);
-bool ath9k_hw_phy_disable(struct ath_hal *ah);
-bool ath9k_hw_disable(struct ath_hal *ah);
-bool ath9k_hw_set_txpowerlimit(struct ath_hal *ah, u32 limit);
-void ath9k_hw_setmac(struct ath_hal *ah, const u8 *mac);
-void ath9k_hw_setopmode(struct ath_hal *ah);
-void ath9k_hw_setmcastfilter(struct ath_hal *ah, u32 filter0, u32 filter1);
+u32 ath9k_hw_getrxfilter(struct ath_hw *ah);
+void ath9k_hw_setrxfilter(struct ath_hw *ah, u32 bits);
+bool ath9k_hw_phy_disable(struct ath_hw *ah);
+bool ath9k_hw_disable(struct ath_hw *ah);
+bool ath9k_hw_set_txpowerlimit(struct ath_hw *ah, u32 limit);
+void ath9k_hw_setmac(struct ath_hw *ah, const u8 *mac);
+void ath9k_hw_setopmode(struct ath_hw *ah);
+void ath9k_hw_setmcastfilter(struct ath_hw *ah, u32 filter0, u32 filter1);
 void ath9k_hw_setbssidmask(struct ath_softc *sc);
 void ath9k_hw_write_associd(struct ath_softc *sc);
-u64 ath9k_hw_gettsf64(struct ath_hal *ah);
-void ath9k_hw_settsf64(struct ath_hal *ah, u64 tsf64);
-void ath9k_hw_reset_tsf(struct ath_hal *ah);
-bool ath9k_hw_set_tsfadjust(struct ath_hal *ah, u32 setting);
-bool ath9k_hw_setslottime(struct ath_hal *ah, u32 us);
-void ath9k_hw_set11nmac2040(struct ath_hal *ah, enum ath9k_ht_macmode mode);
-void ath9k_hw_beaconinit(struct ath_hal *ah, u32 next_beacon, u32 beacon_period);
-void ath9k_hw_set_sta_beacon_timers(struct ath_hal *ah,
+u64 ath9k_hw_gettsf64(struct ath_hw *ah);
+void ath9k_hw_settsf64(struct ath_hw *ah, u64 tsf64);
+void ath9k_hw_reset_tsf(struct ath_hw *ah);
+bool ath9k_hw_set_tsfadjust(struct ath_hw *ah, u32 setting);
+bool ath9k_hw_setslottime(struct ath_hw *ah, u32 us);
+void ath9k_hw_set11nmac2040(struct ath_hw *ah, enum ath9k_ht_macmode mode);
+void ath9k_hw_beaconinit(struct ath_hw *ah, u32 next_beacon, u32 beacon_period);
+void ath9k_hw_set_sta_beacon_timers(struct ath_hw *ah,
 				    const struct ath9k_beacon_state *bs);
-bool ath9k_hw_setpower(struct ath_hal *ah,
+bool ath9k_hw_setpower(struct ath_hw *ah,
 		       enum ath9k_power_mode mode);
-void ath9k_hw_configpcipowersave(struct ath_hal *ah, int restore);
+void ath9k_hw_configpcipowersave(struct ath_hw *ah, int restore);
 
 /* Interrupt Handling */
-bool ath9k_hw_intrpend(struct ath_hal *ah);
-bool ath9k_hw_getisr(struct ath_hal *ah, enum ath9k_int *masked);
-enum ath9k_int ath9k_hw_intrget(struct ath_hal *ah);
-enum ath9k_int ath9k_hw_set_interrupts(struct ath_hal *ah, enum ath9k_int ints);
+bool ath9k_hw_intrpend(struct ath_hw *ah);
+bool ath9k_hw_getisr(struct ath_hw *ah, enum ath9k_int *masked);
+enum ath9k_int ath9k_hw_intrget(struct ath_hw *ah);
+enum ath9k_int ath9k_hw_set_interrupts(struct ath_hw *ah, enum ath9k_int ints);
 
-void ath9k_hw_btcoex_enable(struct ath_hal *ah);
+void ath9k_hw_btcoex_enable(struct ath_hw *ah);
 
 #endif
diff --git a/drivers/net/wireless/ath9k/mac.c b/drivers/net/wireless/ath9k/mac.c
index b375a29..ac20714 100644
--- a/drivers/net/wireless/ath9k/mac.c
+++ b/drivers/net/wireless/ath9k/mac.c
@@ -16,40 +16,38 @@
 
 #include "ath9k.h"
 
-static void ath9k_hw_set_txq_interrupts(struct ath_hal *ah,
+static void ath9k_hw_set_txq_interrupts(struct ath_hw *ah,
 					struct ath9k_tx_queue_info *qi)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
-
 	DPRINTF(ah->ah_sc, ATH_DBG_INTERRUPT,
 		"tx ok 0x%x err 0x%x desc 0x%x eol 0x%x urn 0x%x\n",
-		ahp->ah_txOkInterruptMask, ahp->ah_txErrInterruptMask,
-		ahp->ah_txDescInterruptMask, ahp->ah_txEolInterruptMask,
-		ahp->ah_txUrnInterruptMask);
+		ah->ah_txOkInterruptMask, ah->ah_txErrInterruptMask,
+		ah->ah_txDescInterruptMask, ah->ah_txEolInterruptMask,
+		ah->ah_txUrnInterruptMask);
 
 	REG_WRITE(ah, AR_IMR_S0,
-		  SM(ahp->ah_txOkInterruptMask, AR_IMR_S0_QCU_TXOK)
-		  | SM(ahp->ah_txDescInterruptMask, AR_IMR_S0_QCU_TXDESC));
+		  SM(ah->ah_txOkInterruptMask, AR_IMR_S0_QCU_TXOK)
+		  | SM(ah->ah_txDescInterruptMask, AR_IMR_S0_QCU_TXDESC));
 	REG_WRITE(ah, AR_IMR_S1,
-		  SM(ahp->ah_txErrInterruptMask, AR_IMR_S1_QCU_TXERR)
-		  | SM(ahp->ah_txEolInterruptMask, AR_IMR_S1_QCU_TXEOL));
+		  SM(ah->ah_txErrInterruptMask, AR_IMR_S1_QCU_TXERR)
+		  | SM(ah->ah_txEolInterruptMask, AR_IMR_S1_QCU_TXEOL));
 	REG_RMW_FIELD(ah, AR_IMR_S2,
-		      AR_IMR_S2_QCU_TXURN, ahp->ah_txUrnInterruptMask);
+		      AR_IMR_S2_QCU_TXURN, ah->ah_txUrnInterruptMask);
 }
 
-u32 ath9k_hw_gettxbuf(struct ath_hal *ah, u32 q)
+u32 ath9k_hw_gettxbuf(struct ath_hw *ah, u32 q)
 {
 	return REG_READ(ah, AR_QTXDP(q));
 }
 
-bool ath9k_hw_puttxbuf(struct ath_hal *ah, u32 q, u32 txdp)
+bool ath9k_hw_puttxbuf(struct ath_hw *ah, u32 q, u32 txdp)
 {
 	REG_WRITE(ah, AR_QTXDP(q), txdp);
 
 	return true;
 }
 
-bool ath9k_hw_txstart(struct ath_hal *ah, u32 q)
+bool ath9k_hw_txstart(struct ath_hw *ah, u32 q)
 {
 	DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "queue %u\n", q);
 
@@ -58,7 +56,7 @@ bool ath9k_hw_txstart(struct ath_hal *ah, u32 q)
 	return true;
 }
 
-u32 ath9k_hw_numtxpending(struct ath_hal *ah, u32 q)
+u32 ath9k_hw_numtxpending(struct ath_hw *ah, u32 q)
 {
 	u32 npend;
 
@@ -72,16 +70,15 @@ u32 ath9k_hw_numtxpending(struct ath_hal *ah, u32 q)
 	return npend;
 }
 
-bool ath9k_hw_updatetxtriglevel(struct ath_hal *ah, bool bIncTrigLevel)
+bool ath9k_hw_updatetxtriglevel(struct ath_hw *ah, bool bIncTrigLevel)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
 	u32 txcfg, curLevel, newLevel;
 	enum ath9k_int omask;
 
 	if (ah->ah_txTrigLevel >= MAX_TX_FIFO_THRESHOLD)
 		return false;
 
-	omask = ath9k_hw_set_interrupts(ah, ahp->ah_maskReg & ~ATH9K_INT_GLOBAL);
+	omask = ath9k_hw_set_interrupts(ah, ah->ah_maskReg & ~ATH9K_INT_GLOBAL);
 
 	txcfg = REG_READ(ah, AR_TXCFG);
 	curLevel = MS(txcfg, AR_FTRIG);
@@ -102,12 +99,11 @@ bool ath9k_hw_updatetxtriglevel(struct ath_hal *ah, bool bIncTrigLevel)
 	return newLevel != curLevel;
 }
 
-bool ath9k_hw_stoptxdma(struct ath_hal *ah, u32 q)
+bool ath9k_hw_stoptxdma(struct ath_hw *ah, u32 q)
 {
 #define ATH9K_TX_STOP_DMA_TIMEOUT	4000    /* usec */
 #define ATH9K_TIME_QUANTUM		100     /* usec */
 
-	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct ath9k_hw_capabilities *pCap = &ah->ah_caps;
 	struct ath9k_tx_queue_info *qi;
 	u32 tsfLow, j, wait;
@@ -118,7 +114,7 @@ bool ath9k_hw_stoptxdma(struct ath_hal *ah, u32 q)
 		return false;
 	}
 
-	qi = &ahp->ah_txq[q];
+	qi = &ah->ah_txq[q];
 	if (qi->tqi_type == ATH9K_TX_QUEUE_INACTIVE) {
 		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "inactive queue\n");
 		return false;
@@ -180,7 +176,7 @@ bool ath9k_hw_stoptxdma(struct ath_hal *ah, u32 q)
 #undef ATH9K_TIME_QUANTUM
 }
 
-bool ath9k_hw_filltxdesc(struct ath_hal *ah, struct ath_desc *ds,
+bool ath9k_hw_filltxdesc(struct ath_hw *ah, struct ath_desc *ds,
 			 u32 segLen, bool firstSeg,
 			 bool lastSeg, const struct ath_desc *ds0)
 {
@@ -208,7 +204,7 @@ bool ath9k_hw_filltxdesc(struct ath_hal *ah, struct ath_desc *ds,
 	return true;
 }
 
-void ath9k_hw_cleartxdesc(struct ath_hal *ah, struct ath_desc *ds)
+void ath9k_hw_cleartxdesc(struct ath_hw *ah, struct ath_desc *ds)
 {
 	struct ar5416_desc *ads = AR5416DESC(ds);
 
@@ -219,7 +215,7 @@ void ath9k_hw_cleartxdesc(struct ath_hal *ah, struct ath_desc *ds)
 	ads->ds_txstatus8 = ads->ds_txstatus9 = 0;
 }
 
-int ath9k_hw_txprocdesc(struct ath_hal *ah, struct ath_desc *ds)
+int ath9k_hw_txprocdesc(struct ath_hw *ah, struct ath_desc *ds)
 {
 	struct ar5416_desc *ads = AR5416DESC(ds);
 
@@ -294,14 +290,13 @@ int ath9k_hw_txprocdesc(struct ath_hal *ah, struct ath_desc *ds)
 	return 0;
 }
 
-void ath9k_hw_set11n_txdesc(struct ath_hal *ah, struct ath_desc *ds,
+void ath9k_hw_set11n_txdesc(struct ath_hw *ah, struct ath_desc *ds,
 			    u32 pktLen, enum ath9k_pkt_type type, u32 txPower,
 			    u32 keyIx, enum ath9k_key_type keyType, u32 flags)
 {
 	struct ar5416_desc *ads = AR5416DESC(ds);
-	struct ath_hal_5416 *ahp = AH5416(ah);
 
-	txPower += ahp->ah_txPowerIndexOffset;
+	txPower += ah->ah_txPowerIndexOffset;
 	if (txPower > 63)
 		txPower = 63;
 
@@ -330,7 +325,7 @@ void ath9k_hw_set11n_txdesc(struct ath_hal *ah, struct ath_desc *ds,
 	}
 }
 
-void ath9k_hw_set11n_ratescenario(struct ath_hal *ah, struct ath_desc *ds,
+void ath9k_hw_set11n_ratescenario(struct ath_hw *ah, struct ath_desc *ds,
 				  struct ath_desc *lastds,
 				  u32 durUpdateEn, u32 rtsctsRate,
 				  u32 rtsctsDuration,
@@ -385,7 +380,7 @@ void ath9k_hw_set11n_ratescenario(struct ath_hal *ah, struct ath_desc *ds,
 	last_ads->ds_ctl3 = ads->ds_ctl3;
 }
 
-void ath9k_hw_set11n_aggr_first(struct ath_hal *ah, struct ath_desc *ds,
+void ath9k_hw_set11n_aggr_first(struct ath_hw *ah, struct ath_desc *ds,
 				u32 aggrLen)
 {
 	struct ar5416_desc *ads = AR5416DESC(ds);
@@ -395,7 +390,7 @@ void ath9k_hw_set11n_aggr_first(struct ath_hal *ah, struct ath_desc *ds,
 	ads->ds_ctl6 |= SM(aggrLen, AR_AggrLen);
 }
 
-void ath9k_hw_set11n_aggr_middle(struct ath_hal *ah, struct ath_desc *ds,
+void ath9k_hw_set11n_aggr_middle(struct ath_hw *ah, struct ath_desc *ds,
 				 u32 numDelims)
 {
 	struct ar5416_desc *ads = AR5416DESC(ds);
@@ -409,7 +404,7 @@ void ath9k_hw_set11n_aggr_middle(struct ath_hal *ah, struct ath_desc *ds,
 	ads->ds_ctl6 = ctl6;
 }
 
-void ath9k_hw_set11n_aggr_last(struct ath_hal *ah, struct ath_desc *ds)
+void ath9k_hw_set11n_aggr_last(struct ath_hw *ah, struct ath_desc *ds)
 {
 	struct ar5416_desc *ads = AR5416DESC(ds);
 
@@ -418,14 +413,14 @@ void ath9k_hw_set11n_aggr_last(struct ath_hal *ah, struct ath_desc *ds)
 	ads->ds_ctl6 &= ~AR_PadDelim;
 }
 
-void ath9k_hw_clr11n_aggr(struct ath_hal *ah, struct ath_desc *ds)
+void ath9k_hw_clr11n_aggr(struct ath_hw *ah, struct ath_desc *ds)
 {
 	struct ar5416_desc *ads = AR5416DESC(ds);
 
 	ads->ds_ctl1 &= (~AR_IsAggr & ~AR_MoreAggr);
 }
 
-void ath9k_hw_set11n_burstduration(struct ath_hal *ah, struct ath_desc *ds,
+void ath9k_hw_set11n_burstduration(struct ath_hw *ah, struct ath_desc *ds,
 				   u32 burstDuration)
 {
 	struct ar5416_desc *ads = AR5416DESC(ds);
@@ -434,7 +429,7 @@ void ath9k_hw_set11n_burstduration(struct ath_hal *ah, struct ath_desc *ds,
 	ads->ds_ctl2 |= SM(burstDuration, AR_BurstDur);
 }
 
-void ath9k_hw_set11n_virtualmorefrag(struct ath_hal *ah, struct ath_desc *ds,
+void ath9k_hw_set11n_virtualmorefrag(struct ath_hw *ah, struct ath_desc *ds,
 				     u32 vmf)
 {
 	struct ar5416_desc *ads = AR5416DESC(ds);
@@ -445,19 +440,16 @@ void ath9k_hw_set11n_virtualmorefrag(struct ath_hal *ah, struct ath_desc *ds,
 		ads->ds_ctl0 &= ~AR_VirtMoreFrag;
 }
 
-void ath9k_hw_gettxintrtxqs(struct ath_hal *ah, u32 *txqs)
+void ath9k_hw_gettxintrtxqs(struct ath_hw *ah, u32 *txqs)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
-
-	*txqs &= ahp->ah_intrTxqs;
-	ahp->ah_intrTxqs &= ~(*txqs);
+	*txqs &= ah->ah_intrTxqs;
+	ah->ah_intrTxqs &= ~(*txqs);
 }
 
-bool ath9k_hw_set_txq_props(struct ath_hal *ah, int q,
+bool ath9k_hw_set_txq_props(struct ath_hw *ah, int q,
 			    const struct ath9k_tx_queue_info *qinfo)
 {
 	u32 cw;
-	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct ath9k_hw_capabilities *pCap = &ah->ah_caps;
 	struct ath9k_tx_queue_info *qi;
 
@@ -466,7 +458,7 @@ bool ath9k_hw_set_txq_props(struct ath_hal *ah, int q,
 		return false;
 	}
 
-	qi = &ahp->ah_txq[q];
+	qi = &ah->ah_txq[q];
 	if (qi->tqi_type == ATH9K_TX_QUEUE_INACTIVE) {
 		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "inactive queue\n");
 		return false;
@@ -522,10 +514,9 @@ bool ath9k_hw_set_txq_props(struct ath_hal *ah, int q,
 	return true;
 }
 
-bool ath9k_hw_get_txq_props(struct ath_hal *ah, int q,
+bool ath9k_hw_get_txq_props(struct ath_hw *ah, int q,
 			    struct ath9k_tx_queue_info *qinfo)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct ath9k_hw_capabilities *pCap = &ah->ah_caps;
 	struct ath9k_tx_queue_info *qi;
 
@@ -534,7 +525,7 @@ bool ath9k_hw_get_txq_props(struct ath_hal *ah, int q,
 		return false;
 	}
 
-	qi = &ahp->ah_txq[q];
+	qi = &ah->ah_txq[q];
 	if (qi->tqi_type == ATH9K_TX_QUEUE_INACTIVE) {
 		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "inactive queue\n");
 		return false;
@@ -558,10 +549,9 @@ bool ath9k_hw_get_txq_props(struct ath_hal *ah, int q,
 	return true;
 }
 
-int ath9k_hw_setuptxqueue(struct ath_hal *ah, enum ath9k_tx_queue type,
+int ath9k_hw_setuptxqueue(struct ath_hw *ah, enum ath9k_tx_queue type,
 			  const struct ath9k_tx_queue_info *qinfo)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct ath9k_tx_queue_info *qi;
 	struct ath9k_hw_capabilities *pCap = &ah->ah_caps;
 	int q;
@@ -581,7 +571,7 @@ int ath9k_hw_setuptxqueue(struct ath_hal *ah, enum ath9k_tx_queue type,
 		break;
 	case ATH9K_TX_QUEUE_DATA:
 		for (q = 0; q < pCap->total_queues; q++)
-			if (ahp->ah_txq[q].tqi_type ==
+			if (ah->ah_txq[q].tqi_type ==
 			    ATH9K_TX_QUEUE_INACTIVE)
 				break;
 		if (q == pCap->total_queues) {
@@ -597,7 +587,7 @@ int ath9k_hw_setuptxqueue(struct ath_hal *ah, enum ath9k_tx_queue type,
 
 	DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "queue %u\n", q);
 
-	qi = &ahp->ah_txq[q];
+	qi = &ah->ah_txq[q];
 	if (qi->tqi_type != ATH9K_TX_QUEUE_INACTIVE) {
 		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE,
 			"tx queue %u already active\n", q);
@@ -624,9 +614,8 @@ int ath9k_hw_setuptxqueue(struct ath_hal *ah, enum ath9k_tx_queue type,
 	return q;
 }
 
-bool ath9k_hw_releasetxqueue(struct ath_hal *ah, u32 q)
+bool ath9k_hw_releasetxqueue(struct ath_hw *ah, u32 q)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct ath9k_hw_capabilities *pCap = &ah->ah_caps;
 	struct ath9k_tx_queue_info *qi;
 
@@ -634,7 +623,7 @@ bool ath9k_hw_releasetxqueue(struct ath_hal *ah, u32 q)
 		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "invalid queue num %u\n", q);
 		return false;
 	}
-	qi = &ahp->ah_txq[q];
+	qi = &ah->ah_txq[q];
 	if (qi->tqi_type == ATH9K_TX_QUEUE_INACTIVE) {
 		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "inactive queue %u\n", q);
 		return false;
@@ -643,19 +632,18 @@ bool ath9k_hw_releasetxqueue(struct ath_hal *ah, u32 q)
 	DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "release queue %u\n", q);
 
 	qi->tqi_type = ATH9K_TX_QUEUE_INACTIVE;
-	ahp->ah_txOkInterruptMask &= ~(1 << q);
-	ahp->ah_txErrInterruptMask &= ~(1 << q);
-	ahp->ah_txDescInterruptMask &= ~(1 << q);
-	ahp->ah_txEolInterruptMask &= ~(1 << q);
-	ahp->ah_txUrnInterruptMask &= ~(1 << q);
+	ah->ah_txOkInterruptMask &= ~(1 << q);
+	ah->ah_txErrInterruptMask &= ~(1 << q);
+	ah->ah_txDescInterruptMask &= ~(1 << q);
+	ah->ah_txEolInterruptMask &= ~(1 << q);
+	ah->ah_txUrnInterruptMask &= ~(1 << q);
 	ath9k_hw_set_txq_interrupts(ah, qi);
 
 	return true;
 }
 
-bool ath9k_hw_resettxqueue(struct ath_hal *ah, u32 q)
+bool ath9k_hw_resettxqueue(struct ath_hw *ah, u32 q)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct ath9k_hw_capabilities *pCap = &ah->ah_caps;
 	struct ath9k_channel *chan = ah->ah_curchan;
 	struct ath9k_tx_queue_info *qi;
@@ -666,7 +654,7 @@ bool ath9k_hw_resettxqueue(struct ath_hal *ah, u32 q)
 		return false;
 	}
 
-	qi = &ahp->ah_txq[q];
+	qi = &ah->ah_txq[q];
 	if (qi->tqi_type == ATH9K_TX_QUEUE_INACTIVE) {
 		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "inactive queue %u\n", q);
 		return true;
@@ -784,31 +772,31 @@ bool ath9k_hw_resettxqueue(struct ath_hal *ah, u32 q)
 	}
 
 	if (qi->tqi_qflags & TXQ_FLAG_TXOKINT_ENABLE)
-		ahp->ah_txOkInterruptMask |= 1 << q;
+		ah->ah_txOkInterruptMask |= 1 << q;
 	else
-		ahp->ah_txOkInterruptMask &= ~(1 << q);
+		ah->ah_txOkInterruptMask &= ~(1 << q);
 	if (qi->tqi_qflags & TXQ_FLAG_TXERRINT_ENABLE)
-		ahp->ah_txErrInterruptMask |= 1 << q;
+		ah->ah_txErrInterruptMask |= 1 << q;
 	else
-		ahp->ah_txErrInterruptMask &= ~(1 << q);
+		ah->ah_txErrInterruptMask &= ~(1 << q);
 	if (qi->tqi_qflags & TXQ_FLAG_TXDESCINT_ENABLE)
-		ahp->ah_txDescInterruptMask |= 1 << q;
+		ah->ah_txDescInterruptMask |= 1 << q;
 	else
-		ahp->ah_txDescInterruptMask &= ~(1 << q);
+		ah->ah_txDescInterruptMask &= ~(1 << q);
 	if (qi->tqi_qflags & TXQ_FLAG_TXEOLINT_ENABLE)
-		ahp->ah_txEolInterruptMask |= 1 << q;
+		ah->ah_txEolInterruptMask |= 1 << q;
 	else
-		ahp->ah_txEolInterruptMask &= ~(1 << q);
+		ah->ah_txEolInterruptMask &= ~(1 << q);
 	if (qi->tqi_qflags & TXQ_FLAG_TXURNINT_ENABLE)
-		ahp->ah_txUrnInterruptMask |= 1 << q;
+		ah->ah_txUrnInterruptMask |= 1 << q;
 	else
-		ahp->ah_txUrnInterruptMask &= ~(1 << q);
+		ah->ah_txUrnInterruptMask &= ~(1 << q);
 	ath9k_hw_set_txq_interrupts(ah, qi);
 
 	return true;
 }
 
-int ath9k_hw_rxprocdesc(struct ath_hal *ah, struct ath_desc *ds,
+int ath9k_hw_rxprocdesc(struct ath_hw *ah, struct ath_desc *ds,
 			u32 pa, struct ath_desc *nds, u64 tsf)
 {
 	struct ar5416_desc ads;
@@ -873,7 +861,7 @@ int ath9k_hw_rxprocdesc(struct ath_hal *ah, struct ath_desc *ds,
 	return 0;
 }
 
-bool ath9k_hw_setuprxdesc(struct ath_hal *ah, struct ath_desc *ds,
+bool ath9k_hw_setuprxdesc(struct ath_hw *ah, struct ath_desc *ds,
 			  u32 size, u32 flags)
 {
 	struct ar5416_desc *ads = AR5416DESC(ds);
@@ -890,7 +878,7 @@ bool ath9k_hw_setuprxdesc(struct ath_hal *ah, struct ath_desc *ds,
 	return true;
 }
 
-bool ath9k_hw_setrxabort(struct ath_hal *ah, bool set)
+bool ath9k_hw_setrxabort(struct ath_hw *ah, bool set)
 {
 	u32 reg;
 
@@ -917,17 +905,17 @@ bool ath9k_hw_setrxabort(struct ath_hal *ah, bool set)
 	return true;
 }
 
-void ath9k_hw_putrxbuf(struct ath_hal *ah, u32 rxdp)
+void ath9k_hw_putrxbuf(struct ath_hw *ah, u32 rxdp)
 {
 	REG_WRITE(ah, AR_RXDP, rxdp);
 }
 
-void ath9k_hw_rxena(struct ath_hal *ah)
+void ath9k_hw_rxena(struct ath_hw *ah)
 {
 	REG_WRITE(ah, AR_CR, AR_CR_RXE);
 }
 
-void ath9k_hw_startpcureceive(struct ath_hal *ah)
+void ath9k_hw_startpcureceive(struct ath_hw *ah)
 {
 	ath9k_enable_mib_counters(ah);
 
@@ -936,14 +924,14 @@ void ath9k_hw_startpcureceive(struct ath_hal *ah)
 	REG_CLR_BIT(ah, AR_DIAG_SW, (AR_DIAG_RX_DIS | AR_DIAG_RX_ABORT));
 }
 
-void ath9k_hw_stoppcurecv(struct ath_hal *ah)
+void ath9k_hw_stoppcurecv(struct ath_hw *ah)
 {
 	REG_SET_BIT(ah, AR_DIAG_SW, AR_DIAG_RX_DIS);
 
 	ath9k_hw_disable_mib_counters(ah);
 }
 
-bool ath9k_hw_stopdmarecv(struct ath_hal *ah)
+bool ath9k_hw_stopdmarecv(struct ath_hw *ah)
 {
 	REG_WRITE(ah, AR_CR, AR_CR_RXD);
 
diff --git a/drivers/net/wireless/ath9k/mac.h b/drivers/net/wireless/ath9k/mac.h
index 9012af2..74b660a 100644
--- a/drivers/net/wireless/ath9k/mac.h
+++ b/drivers/net/wireless/ath9k/mac.h
@@ -619,58 +619,58 @@ enum ath9k_ht_extprotspacing {
 	ATH9K_HT_EXTPROTSPACING_25 = 1,
 };
 
-struct ath_hal;
+struct ath_hw;
 struct ath9k_channel;
 struct ath_rate_table;
 
-u32 ath9k_hw_gettxbuf(struct ath_hal *ah, u32 q);
-bool ath9k_hw_puttxbuf(struct ath_hal *ah, u32 q, u32 txdp);
-bool ath9k_hw_txstart(struct ath_hal *ah, u32 q);
-u32 ath9k_hw_numtxpending(struct ath_hal *ah, u32 q);
-bool ath9k_hw_updatetxtriglevel(struct ath_hal *ah, bool bIncTrigLevel);
-bool ath9k_hw_stoptxdma(struct ath_hal *ah, u32 q);
-bool ath9k_hw_filltxdesc(struct ath_hal *ah, struct ath_desc *ds,
+u32 ath9k_hw_gettxbuf(struct ath_hw *ah, u32 q);
+bool ath9k_hw_puttxbuf(struct ath_hw *ah, u32 q, u32 txdp);
+bool ath9k_hw_txstart(struct ath_hw *ah, u32 q);
+u32 ath9k_hw_numtxpending(struct ath_hw *ah, u32 q);
+bool ath9k_hw_updatetxtriglevel(struct ath_hw *ah, bool bIncTrigLevel);
+bool ath9k_hw_stoptxdma(struct ath_hw *ah, u32 q);
+bool ath9k_hw_filltxdesc(struct ath_hw *ah, struct ath_desc *ds,
 			 u32 segLen, bool firstSeg,
 			 bool lastSeg, const struct ath_desc *ds0);
-void ath9k_hw_cleartxdesc(struct ath_hal *ah, struct ath_desc *ds);
-int ath9k_hw_txprocdesc(struct ath_hal *ah, struct ath_desc *ds);
-void ath9k_hw_set11n_txdesc(struct ath_hal *ah, struct ath_desc *ds,
+void ath9k_hw_cleartxdesc(struct ath_hw *ah, struct ath_desc *ds);
+int ath9k_hw_txprocdesc(struct ath_hw *ah, struct ath_desc *ds);
+void ath9k_hw_set11n_txdesc(struct ath_hw *ah, struct ath_desc *ds,
 			    u32 pktLen, enum ath9k_pkt_type type, u32 txPower,
 			    u32 keyIx, enum ath9k_key_type keyType, u32 flags);
-void ath9k_hw_set11n_ratescenario(struct ath_hal *ah, struct ath_desc *ds,
+void ath9k_hw_set11n_ratescenario(struct ath_hw *ah, struct ath_desc *ds,
 				  struct ath_desc *lastds,
 				  u32 durUpdateEn, u32 rtsctsRate,
 				  u32 rtsctsDuration,
 				  struct ath9k_11n_rate_series series[],
 				  u32 nseries, u32 flags);
-void ath9k_hw_set11n_aggr_first(struct ath_hal *ah, struct ath_desc *ds,
+void ath9k_hw_set11n_aggr_first(struct ath_hw *ah, struct ath_desc *ds,
 				u32 aggrLen);
-void ath9k_hw_set11n_aggr_middle(struct ath_hal *ah, struct ath_desc *ds,
+void ath9k_hw_set11n_aggr_middle(struct ath_hw *ah, struct ath_desc *ds,
 				 u32 numDelims);
-void ath9k_hw_set11n_aggr_last(struct ath_hal *ah, struct ath_desc *ds);
-void ath9k_hw_clr11n_aggr(struct ath_hal *ah, struct ath_desc *ds);
-void ath9k_hw_set11n_burstduration(struct ath_hal *ah, struct ath_desc *ds,
+void ath9k_hw_set11n_aggr_last(struct ath_hw *ah, struct ath_desc *ds);
+void ath9k_hw_clr11n_aggr(struct ath_hw *ah, struct ath_desc *ds);
+void ath9k_hw_set11n_burstduration(struct ath_hw *ah, struct ath_desc *ds,
 				   u32 burstDuration);
-void ath9k_hw_set11n_virtualmorefrag(struct ath_hal *ah, struct ath_desc *ds,
+void ath9k_hw_set11n_virtualmorefrag(struct ath_hw *ah, struct ath_desc *ds,
 				     u32 vmf);
-void ath9k_hw_gettxintrtxqs(struct ath_hal *ah, u32 *txqs);
-bool ath9k_hw_set_txq_props(struct ath_hal *ah, int q,
+void ath9k_hw_gettxintrtxqs(struct ath_hw *ah, u32 *txqs);
+bool ath9k_hw_set_txq_props(struct ath_hw *ah, int q,
 			    const struct ath9k_tx_queue_info *qinfo);
-bool ath9k_hw_get_txq_props(struct ath_hal *ah, int q,
+bool ath9k_hw_get_txq_props(struct ath_hw *ah, int q,
 			    struct ath9k_tx_queue_info *qinfo);
-int ath9k_hw_setuptxqueue(struct ath_hal *ah, enum ath9k_tx_queue type,
+int ath9k_hw_setuptxqueue(struct ath_hw *ah, enum ath9k_tx_queue type,
 			  const struct ath9k_tx_queue_info *qinfo);
-bool ath9k_hw_releasetxqueue(struct ath_hal *ah, u32 q);
-bool ath9k_hw_resettxqueue(struct ath_hal *ah, u32 q);
-int ath9k_hw_rxprocdesc(struct ath_hal *ah, struct ath_desc *ds,
+bool ath9k_hw_releasetxqueue(struct ath_hw *ah, u32 q);
+bool ath9k_hw_resettxqueue(struct ath_hw *ah, u32 q);
+int ath9k_hw_rxprocdesc(struct ath_hw *ah, struct ath_desc *ds,
 			u32 pa, struct ath_desc *nds, u64 tsf);
-bool ath9k_hw_setuprxdesc(struct ath_hal *ah, struct ath_desc *ds,
+bool ath9k_hw_setuprxdesc(struct ath_hw *ah, struct ath_desc *ds,
 			  u32 size, u32 flags);
-bool ath9k_hw_setrxabort(struct ath_hal *ah, bool set);
-void ath9k_hw_putrxbuf(struct ath_hal *ah, u32 rxdp);
-void ath9k_hw_rxena(struct ath_hal *ah);
-void ath9k_hw_startpcureceive(struct ath_hal *ah);
-void ath9k_hw_stoppcurecv(struct ath_hal *ah);
-bool ath9k_hw_stopdmarecv(struct ath_hal *ah);
+bool ath9k_hw_setrxabort(struct ath_hw *ah, bool set);
+void ath9k_hw_putrxbuf(struct ath_hw *ah, u32 rxdp);
+void ath9k_hw_rxena(struct ath_hw *ah);
+void ath9k_hw_startpcureceive(struct ath_hw *ah);
+void ath9k_hw_stoppcurecv(struct ath_hw *ah);
+bool ath9k_hw_stopdmarecv(struct ath_hw *ah);
 
 #endif /* MAC_H */
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index bafefbe..a50f989 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -137,7 +137,7 @@ static void ath_cache_conf_rate(struct ath_softc *sc,
 
 static void ath_update_txpow(struct ath_softc *sc)
 {
-	struct ath_hal *ah = sc->sc_ah;
+	struct ath_hw *ah = sc->sc_ah;
 	u32 txpow;
 
 	if (sc->curtxpow != sc->config.txpowlimit) {
@@ -234,7 +234,7 @@ static void ath_setup_rates(struct ath_softc *sc, enum ieee80211_band band)
 */
 static int ath_set_channel(struct ath_softc *sc, struct ath9k_channel *hchan)
 {
-	struct ath_hal *ah = sc->sc_ah;
+	struct ath_hw *ah = sc->sc_ah;
 	bool fastcc = true, stopped;
 	struct ieee80211_hw *hw = sc->hw;
 	struct ieee80211_channel *channel = hw->conf.channel;
@@ -309,7 +309,7 @@ static int ath_set_channel(struct ath_softc *sc, struct ath9k_channel *hchan)
 static void ath_ani_calibrate(unsigned long data)
 {
 	struct ath_softc *sc;
-	struct ath_hal *ah;
+	struct ath_hw *ah;
 	bool longcal = false;
 	bool shortcal = false;
 	bool aniflag = false;
@@ -479,7 +479,7 @@ static void ath9k_tasklet(unsigned long data)
 irqreturn_t ath_isr(int irq, void *dev)
 {
 	struct ath_softc *sc = dev;
-	struct ath_hal *ah = sc->sc_ah;
+	struct ath_hw *ah = sc->sc_ah;
 	enum ath9k_int status;
 	bool sched = false;
 
@@ -1091,7 +1091,7 @@ fail:
 
 static void ath_radio_enable(struct ath_softc *sc)
 {
-	struct ath_hal *ah = sc->sc_ah;
+	struct ath_hw *ah = sc->sc_ah;
 	struct ieee80211_channel *channel = sc->hw->conf.channel;
 	int r;
 
@@ -1132,7 +1132,7 @@ static void ath_radio_enable(struct ath_softc *sc)
 
 static void ath_radio_disable(struct ath_softc *sc)
 {
-	struct ath_hal *ah = sc->sc_ah;
+	struct ath_hw *ah = sc->sc_ah;
 	struct ieee80211_channel *channel = sc->hw->conf.channel;
 	int r;
 
@@ -1167,7 +1167,7 @@ static void ath_radio_disable(struct ath_softc *sc)
 
 static bool ath_is_rfkill_set(struct ath_softc *sc)
 {
-	struct ath_hal *ah = sc->sc_ah;
+	struct ath_hw *ah = sc->sc_ah;
 
 	return ath9k_hw_gpio_get(ah, ah->ah_rfkill_gpio) ==
 				  ah->ah_rfkill_polarity;
@@ -1345,7 +1345,7 @@ void ath_detach(struct ath_softc *sc)
 
 static int ath_init(u16 devid, struct ath_softc *sc)
 {
-	struct ath_hal *ah = NULL;
+	struct ath_hw *ah = NULL;
 	int status;
 	int error = 0, i;
 	int csz = 0;
@@ -1370,7 +1370,7 @@ static int ath_init(u16 devid, struct ath_softc *sc)
 	/* XXX assert csz is non-zero */
 	sc->cachelsz = csz << 2;	/* convert to bytes */
 
-	ah = ath9k_hw_attach(devid, sc, sc->mem, &status);
+	ah = ath9k_hw_attach(devid, sc, &status);
 	if (ah == NULL) {
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"Unable to attach hardware; HAL status %d\n", status);
@@ -1671,7 +1671,7 @@ detach:
 
 int ath_reset(struct ath_softc *sc, bool retry_tx)
 {
-	struct ath_hal *ah = sc->sc_ah;
+	struct ath_hw *ah = sc->sc_ah;
 	struct ieee80211_hw *hw = sc->hw;
 	int r;
 
@@ -2272,7 +2272,7 @@ static int ath9k_config_interface(struct ieee80211_hw *hw,
 				  struct ieee80211_if_conf *conf)
 {
 	struct ath_softc *sc = hw->priv;
-	struct ath_hal *ah = sc->sc_ah;
+	struct ath_hw *ah = sc->sc_ah;
 	struct ath_vif *avp = (void *)vif->drv_priv;
 	u32 rfilt = 0;
 	int error, i;
diff --git a/drivers/net/wireless/ath9k/pci.c b/drivers/net/wireless/ath9k/pci.c
index 192c8c4..eac8db7 100644
--- a/drivers/net/wireless/ath9k/pci.c
+++ b/drivers/net/wireless/ath9k/pci.c
@@ -56,7 +56,7 @@ static void ath_pci_cleanup(struct ath_softc *sc)
 	pci_disable_device(pdev);
 }
 
-static bool ath_pci_eeprom_read(struct ath_hal *ah, u32 off, u16 *data)
+static bool ath_pci_eeprom_read(struct ath_hw *ah, u32 off, u16 *data)
 {
 	(void)REG_READ(ah, AR5416_EEPROM_OFFSET + (off << AR5416_EEPROM_S));
 
@@ -87,7 +87,7 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	u8 csz;
 	u32 val;
 	int ret = 0;
-	struct ath_hal *ah;
+	struct ath_hw *ah;
 
 	if (pci_enable_device(pdev))
 		return -EIO;
diff --git a/drivers/net/wireless/ath9k/phy.c b/drivers/net/wireless/ath9k/phy.c
index ea29941..da4165b 100644
--- a/drivers/net/wireless/ath9k/phy.c
+++ b/drivers/net/wireless/ath9k/phy.c
@@ -17,16 +17,14 @@
 #include "ath9k.h"
 
 void
-ath9k_hw_write_regs(struct ath_hal *ah, u32 modesIndex, u32 freqIndex,
+ath9k_hw_write_regs(struct ath_hw *ah, u32 modesIndex, u32 freqIndex,
 		    int regWrites)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
-
-	REG_WRITE_ARRAY(&ahp->ah_iniBB_RfGain, freqIndex, regWrites);
+	REG_WRITE_ARRAY(&ah->ah_iniBB_RfGain, freqIndex, regWrites);
 }
 
 bool
-ath9k_hw_set_channel(struct ath_hal *ah, struct ath9k_channel *chan)
+ath9k_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
 {
 	u32 channelSel = 0;
 	u32 bModeSynth = 0;
@@ -93,14 +91,13 @@ ath9k_hw_set_channel(struct ath_hal *ah, struct ath9k_channel *chan)
 	REG_WRITE(ah, AR_PHY(0x37), reg32);
 
 	ah->ah_curchan = chan;
-
-	AH5416(ah)->ah_curchanRadIndex = -1;
+	ah->ah_curchanRadIndex = -1;
 
 	return true;
 }
 
 bool
-ath9k_hw_ar9280_set_channel(struct ath_hal *ah,
+ath9k_hw_ar9280_set_channel(struct ath_hw *ah,
 			    struct ath9k_channel *chan)
 {
 	u16 bMode, fracMode, aModeRefSel = 0;
@@ -164,8 +161,7 @@ ath9k_hw_ar9280_set_channel(struct ath_hal *ah,
 	REG_WRITE(ah, AR_PHY_SYNTH_CONTROL, reg32);
 
 	ah->ah_curchan = chan;
-
-	AH5416(ah)->ah_curchanRadIndex = -1;
+	ah->ah_curchanRadIndex = -1;
 
 	return true;
 }
@@ -198,11 +194,9 @@ ath9k_phy_modify_rx_buffer(u32 *rfBuf, u32 reg32,
 }
 
 bool
-ath9k_hw_set_rf_regs(struct ath_hal *ah, struct ath9k_channel *chan,
+ath9k_hw_set_rf_regs(struct ath_hw *ah, struct ath9k_channel *chan,
 		     u16 modesIndex)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
-
 	u32 eepMinorRev;
 	u32 ob5GHz = 0, db5GHz = 0;
 	u32 ob2GHz = 0, db2GHz = 0;
@@ -213,19 +207,19 @@ ath9k_hw_set_rf_regs(struct ath_hal *ah, struct ath9k_channel *chan,
 
 	eepMinorRev = ath9k_hw_get_eeprom(ah, EEP_MINOR_REV);
 
-	RF_BANK_SETUP(ahp->ah_analogBank0Data, &ahp->ah_iniBank0, 1);
+	RF_BANK_SETUP(ah->ah_analogBank0Data, &ah->ah_iniBank0, 1);
 
-	RF_BANK_SETUP(ahp->ah_analogBank1Data, &ahp->ah_iniBank1, 1);
+	RF_BANK_SETUP(ah->ah_analogBank1Data, &ah->ah_iniBank1, 1);
 
-	RF_BANK_SETUP(ahp->ah_analogBank2Data, &ahp->ah_iniBank2, 1);
+	RF_BANK_SETUP(ah->ah_analogBank2Data, &ah->ah_iniBank2, 1);
 
-	RF_BANK_SETUP(ahp->ah_analogBank3Data, &ahp->ah_iniBank3,
+	RF_BANK_SETUP(ah->ah_analogBank3Data, &ah->ah_iniBank3,
 		      modesIndex);
 	{
 		int i;
-		for (i = 0; i < ahp->ah_iniBank6TPC.ia_rows; i++) {
-			ahp->ah_analogBank6Data[i] =
-			    INI_RA(&ahp->ah_iniBank6TPC, i, modesIndex);
+		for (i = 0; i < ah->ah_iniBank6TPC.ia_rows; i++) {
+			ah->ah_analogBank6Data[i] =
+			    INI_RA(&ah->ah_iniBank6TPC, i, modesIndex);
 		}
 	}
 
@@ -233,137 +227,132 @@ ath9k_hw_set_rf_regs(struct ath_hal *ah, struct ath9k_channel *chan,
 		if (IS_CHAN_2GHZ(chan)) {
 			ob2GHz = ath9k_hw_get_eeprom(ah, EEP_OB_2);
 			db2GHz = ath9k_hw_get_eeprom(ah, EEP_DB_2);
-			ath9k_phy_modify_rx_buffer(ahp->ah_analogBank6Data,
+			ath9k_phy_modify_rx_buffer(ah->ah_analogBank6Data,
 						   ob2GHz, 3, 197, 0);
-			ath9k_phy_modify_rx_buffer(ahp->ah_analogBank6Data,
+			ath9k_phy_modify_rx_buffer(ah->ah_analogBank6Data,
 						   db2GHz, 3, 194, 0);
 		} else {
 			ob5GHz = ath9k_hw_get_eeprom(ah, EEP_OB_5);
 			db5GHz = ath9k_hw_get_eeprom(ah, EEP_DB_5);
-			ath9k_phy_modify_rx_buffer(ahp->ah_analogBank6Data,
+			ath9k_phy_modify_rx_buffer(ah->ah_analogBank6Data,
 						   ob5GHz, 3, 203, 0);
-			ath9k_phy_modify_rx_buffer(ahp->ah_analogBank6Data,
+			ath9k_phy_modify_rx_buffer(ah->ah_analogBank6Data,
 						   db5GHz, 3, 200, 0);
 		}
 	}
 
-	RF_BANK_SETUP(ahp->ah_analogBank7Data, &ahp->ah_iniBank7, 1);
+	RF_BANK_SETUP(ah->ah_analogBank7Data, &ah->ah_iniBank7, 1);
 
-	REG_WRITE_RF_ARRAY(&ahp->ah_iniBank0, ahp->ah_analogBank0Data,
+	REG_WRITE_RF_ARRAY(&ah->ah_iniBank0, ah->ah_analogBank0Data,
 			   regWrites);
-	REG_WRITE_RF_ARRAY(&ahp->ah_iniBank1, ahp->ah_analogBank1Data,
+	REG_WRITE_RF_ARRAY(&ah->ah_iniBank1, ah->ah_analogBank1Data,
 			   regWrites);
-	REG_WRITE_RF_ARRAY(&ahp->ah_iniBank2, ahp->ah_analogBank2Data,
+	REG_WRITE_RF_ARRAY(&ah->ah_iniBank2, ah->ah_analogBank2Data,
 			   regWrites);
-	REG_WRITE_RF_ARRAY(&ahp->ah_iniBank3, ahp->ah_analogBank3Data,
+	REG_WRITE_RF_ARRAY(&ah->ah_iniBank3, ah->ah_analogBank3Data,
 			   regWrites);
-	REG_WRITE_RF_ARRAY(&ahp->ah_iniBank6TPC, ahp->ah_analogBank6Data,
+	REG_WRITE_RF_ARRAY(&ah->ah_iniBank6TPC, ah->ah_analogBank6Data,
 			   regWrites);
-	REG_WRITE_RF_ARRAY(&ahp->ah_iniBank7, ahp->ah_analogBank7Data,
+	REG_WRITE_RF_ARRAY(&ah->ah_iniBank7, ah->ah_analogBank7Data,
 			   regWrites);
 
 	return true;
 }
 
 void
-ath9k_hw_rfdetach(struct ath_hal *ah)
+ath9k_hw_rfdetach(struct ath_hw *ah)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
-
-	if (ahp->ah_analogBank0Data != NULL) {
-		kfree(ahp->ah_analogBank0Data);
-		ahp->ah_analogBank0Data = NULL;
+	if (ah->ah_analogBank0Data != NULL) {
+		kfree(ah->ah_analogBank0Data);
+		ah->ah_analogBank0Data = NULL;
 	}
-	if (ahp->ah_analogBank1Data != NULL) {
-		kfree(ahp->ah_analogBank1Data);
-		ahp->ah_analogBank1Data = NULL;
+	if (ah->ah_analogBank1Data != NULL) {
+		kfree(ah->ah_analogBank1Data);
+		ah->ah_analogBank1Data = NULL;
 	}
-	if (ahp->ah_analogBank2Data != NULL) {
-		kfree(ahp->ah_analogBank2Data);
-		ahp->ah_analogBank2Data = NULL;
+	if (ah->ah_analogBank2Data != NULL) {
+		kfree(ah->ah_analogBank2Data);
+		ah->ah_analogBank2Data = NULL;
 	}
-	if (ahp->ah_analogBank3Data != NULL) {
-		kfree(ahp->ah_analogBank3Data);
-		ahp->ah_analogBank3Data = NULL;
+	if (ah->ah_analogBank3Data != NULL) {
+		kfree(ah->ah_analogBank3Data);
+		ah->ah_analogBank3Data = NULL;
 	}
-	if (ahp->ah_analogBank6Data != NULL) {
-		kfree(ahp->ah_analogBank6Data);
-		ahp->ah_analogBank6Data = NULL;
+	if (ah->ah_analogBank6Data != NULL) {
+		kfree(ah->ah_analogBank6Data);
+		ah->ah_analogBank6Data = NULL;
 	}
-	if (ahp->ah_analogBank6TPCData != NULL) {
-		kfree(ahp->ah_analogBank6TPCData);
-		ahp->ah_analogBank6TPCData = NULL;
+	if (ah->ah_analogBank6TPCData != NULL) {
+		kfree(ah->ah_analogBank6TPCData);
+		ah->ah_analogBank6TPCData = NULL;
 	}
-	if (ahp->ah_analogBank7Data != NULL) {
-		kfree(ahp->ah_analogBank7Data);
-		ahp->ah_analogBank7Data = NULL;
+	if (ah->ah_analogBank7Data != NULL) {
+		kfree(ah->ah_analogBank7Data);
+		ah->ah_analogBank7Data = NULL;
 	}
-	if (ahp->ah_addac5416_21 != NULL) {
-		kfree(ahp->ah_addac5416_21);
-		ahp->ah_addac5416_21 = NULL;
+	if (ah->ah_addac5416_21 != NULL) {
+		kfree(ah->ah_addac5416_21);
+		ah->ah_addac5416_21 = NULL;
 	}
-	if (ahp->ah_bank6Temp != NULL) {
-		kfree(ahp->ah_bank6Temp);
-		ahp->ah_bank6Temp = NULL;
+	if (ah->ah_bank6Temp != NULL) {
+		kfree(ah->ah_bank6Temp);
+		ah->ah_bank6Temp = NULL;
 	}
 }
 
-bool ath9k_hw_init_rf(struct ath_hal *ah, int *status)
+bool ath9k_hw_init_rf(struct ath_hw *ah, int *status)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
-
 	if (!AR_SREV_9280_10_OR_LATER(ah)) {
-
-		ahp->ah_analogBank0Data =
+		ah->ah_analogBank0Data =
 		    kzalloc((sizeof(u32) *
-			     ahp->ah_iniBank0.ia_rows), GFP_KERNEL);
-		ahp->ah_analogBank1Data =
+			     ah->ah_iniBank0.ia_rows), GFP_KERNEL);
+		ah->ah_analogBank1Data =
 		    kzalloc((sizeof(u32) *
-			     ahp->ah_iniBank1.ia_rows), GFP_KERNEL);
-		ahp->ah_analogBank2Data =
+			     ah->ah_iniBank1.ia_rows), GFP_KERNEL);
+		ah->ah_analogBank2Data =
 		    kzalloc((sizeof(u32) *
-			     ahp->ah_iniBank2.ia_rows), GFP_KERNEL);
-		ahp->ah_analogBank3Data =
+			     ah->ah_iniBank2.ia_rows), GFP_KERNEL);
+		ah->ah_analogBank3Data =
 		    kzalloc((sizeof(u32) *
-			     ahp->ah_iniBank3.ia_rows), GFP_KERNEL);
-		ahp->ah_analogBank6Data =
+			     ah->ah_iniBank3.ia_rows), GFP_KERNEL);
+		ah->ah_analogBank6Data =
 		    kzalloc((sizeof(u32) *
-			     ahp->ah_iniBank6.ia_rows), GFP_KERNEL);
-		ahp->ah_analogBank6TPCData =
+			     ah->ah_iniBank6.ia_rows), GFP_KERNEL);
+		ah->ah_analogBank6TPCData =
 		    kzalloc((sizeof(u32) *
-			     ahp->ah_iniBank6TPC.ia_rows), GFP_KERNEL);
-		ahp->ah_analogBank7Data =
+			     ah->ah_iniBank6TPC.ia_rows), GFP_KERNEL);
+		ah->ah_analogBank7Data =
 		    kzalloc((sizeof(u32) *
-			     ahp->ah_iniBank7.ia_rows), GFP_KERNEL);
-
-		if (ahp->ah_analogBank0Data == NULL
-		    || ahp->ah_analogBank1Data == NULL
-		    || ahp->ah_analogBank2Data == NULL
-		    || ahp->ah_analogBank3Data == NULL
-		    || ahp->ah_analogBank6Data == NULL
-		    || ahp->ah_analogBank6TPCData == NULL
-		    || ahp->ah_analogBank7Data == NULL) {
+			     ah->ah_iniBank7.ia_rows), GFP_KERNEL);
+
+		if (ah->ah_analogBank0Data == NULL
+		    || ah->ah_analogBank1Data == NULL
+		    || ah->ah_analogBank2Data == NULL
+		    || ah->ah_analogBank3Data == NULL
+		    || ah->ah_analogBank6Data == NULL
+		    || ah->ah_analogBank6TPCData == NULL
+		    || ah->ah_analogBank7Data == NULL) {
 			DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
 				"Cannot allocate RF banks\n");
 			*status = -ENOMEM;
 			return false;
 		}
 
-		ahp->ah_addac5416_21 =
+		ah->ah_addac5416_21 =
 		    kzalloc((sizeof(u32) *
-			     ahp->ah_iniAddac.ia_rows *
-			     ahp->ah_iniAddac.ia_columns), GFP_KERNEL);
-		if (ahp->ah_addac5416_21 == NULL) {
+			     ah->ah_iniAddac.ia_rows *
+			     ah->ah_iniAddac.ia_columns), GFP_KERNEL);
+		if (ah->ah_addac5416_21 == NULL) {
 			DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
 				"Cannot allocate ah_addac5416_21\n");
 			*status = -ENOMEM;
 			return false;
 		}
 
-		ahp->ah_bank6Temp =
+		ah->ah_bank6Temp =
 		    kzalloc((sizeof(u32) *
-			     ahp->ah_iniBank6.ia_rows), GFP_KERNEL);
-		if (ahp->ah_bank6Temp == NULL) {
+			     ah->ah_iniBank6.ia_rows), GFP_KERNEL);
+		if (ah->ah_bank6Temp == NULL) {
 			DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
 				"Cannot allocate ah_bank6Temp\n");
 			*status = -ENOMEM;
@@ -375,23 +364,22 @@ bool ath9k_hw_init_rf(struct ath_hal *ah, int *status)
 }
 
 void
-ath9k_hw_decrease_chain_power(struct ath_hal *ah, struct ath9k_channel *chan)
+ath9k_hw_decrease_chain_power(struct ath_hw *ah, struct ath9k_channel *chan)
 {
 	int i, regWrites = 0;
-	struct ath_hal_5416 *ahp = AH5416(ah);
 	u32 bank6SelMask;
-	u32 *bank6Temp = ahp->ah_bank6Temp;
+	u32 *bank6Temp = ah->ah_bank6Temp;
 
-	switch (ahp->ah_diversityControl) {
+	switch (ah->ah_diversityControl) {
 	case ATH9K_ANT_FIXED_A:
 		bank6SelMask =
-		    (ahp->
+		    (ah->
 		     ah_antennaSwitchSwap & ANTSWAP_AB) ? REDUCE_CHAIN_0 :
 		    REDUCE_CHAIN_1;
 		break;
 	case ATH9K_ANT_FIXED_B:
 		bank6SelMask =
-		    (ahp->
+		    (ah->
 		     ah_antennaSwitchSwap & ANTSWAP_AB) ? REDUCE_CHAIN_1 :
 		    REDUCE_CHAIN_0;
 		break;
@@ -403,8 +391,8 @@ ath9k_hw_decrease_chain_power(struct ath_hal *ah, struct ath9k_channel *chan)
 		break;
 	}
 
-	for (i = 0; i < ahp->ah_iniBank6.ia_rows; i++)
-		bank6Temp[i] = ahp->ah_analogBank6Data[i];
+	for (i = 0; i < ah->ah_iniBank6.ia_rows; i++)
+		bank6Temp[i] = ah->ah_analogBank6Data[i];
 
 	REG_WRITE(ah, AR_PHY_BASE + 0xD8, bank6SelMask);
 
@@ -418,7 +406,7 @@ ath9k_hw_decrease_chain_power(struct ath_hal *ah, struct ath9k_channel *chan)
 	ath9k_phy_modify_rx_buffer(bank6Temp, 1, 1, 246, 0);
 	ath9k_phy_modify_rx_buffer(bank6Temp, 1, 1, 247, 0);
 
-	REG_WRITE_RF_ARRAY(&ahp->ah_iniBank6, bank6Temp, regWrites);
+	REG_WRITE_RF_ARRAY(&ah->ah_iniBank6, bank6Temp, regWrites);
 
 	REG_WRITE(ah, AR_PHY_BASE + 0xD8, 0x00000053);
 #ifdef ALTER_SWITCH
diff --git a/drivers/net/wireless/ath9k/phy.h b/drivers/net/wireless/ath9k/phy.h
index 3a406a5..71a7f5a 100644
--- a/drivers/net/wireless/ath9k/phy.h
+++ b/drivers/net/wireless/ath9k/phy.h
@@ -17,19 +17,19 @@
 #ifndef PHY_H
 #define PHY_H
 
-bool ath9k_hw_ar9280_set_channel(struct ath_hal *ah,
+bool ath9k_hw_ar9280_set_channel(struct ath_hw *ah,
 				 struct ath9k_channel
 				 *chan);
-bool ath9k_hw_set_channel(struct ath_hal *ah,
+bool ath9k_hw_set_channel(struct ath_hw *ah,
 			  struct ath9k_channel *chan);
-void ath9k_hw_write_regs(struct ath_hal *ah, u32 modesIndex,
+void ath9k_hw_write_regs(struct ath_hw *ah, u32 modesIndex,
 			 u32 freqIndex, int regWrites);
-bool ath9k_hw_set_rf_regs(struct ath_hal *ah,
+bool ath9k_hw_set_rf_regs(struct ath_hw *ah,
 			  struct ath9k_channel *chan,
 			  u16 modesIndex);
-void ath9k_hw_decrease_chain_power(struct ath_hal *ah,
+void ath9k_hw_decrease_chain_power(struct ath_hw *ah,
 				   struct ath9k_channel *chan);
-bool ath9k_hw_init_rf(struct ath_hal *ah,
+bool ath9k_hw_init_rf(struct ath_hw *ah,
 		      int *status);
 
 #define AR_PHY_BASE     0x9800
@@ -533,7 +533,7 @@ bool ath9k_hw_init_rf(struct ath_hal *ah,
 #define ATH9K_KEY_XOR                 0xaa
 
 #define ATH9K_IS_MIC_ENABLED(ah)					\
-	(AH5416(ah)->ah_staId1Defaults & AR_STA_ID1_CRPT_MIC_ENABLE)
+	((ah)->ah_staId1Defaults & AR_STA_ID1_CRPT_MIC_ENABLE)
 
 #define ANTSWAP_AB 0x0001
 #define REDUCE_CHAIN_0 0x00000050
diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index c51c085..7c011b1 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -26,7 +26,7 @@
  */
 static void ath_rx_buf_link(struct ath_softc *sc, struct ath_buf *bf)
 {
-	struct ath_hal *ah = sc->sc_ah;
+	struct ath_hw *ah = sc->sc_ah;
 	struct ath_desc *ds;
 	struct sk_buff *skb;
 
@@ -233,7 +233,7 @@ rx_next:
 
 static void ath_opmode_init(struct ath_softc *sc)
 {
-	struct ath_hal *ah = sc->sc_ah;
+	struct ath_hw *ah = sc->sc_ah;
 	u32 rfilt, mfilt[2];
 
 	/* configure rx filter */
@@ -391,7 +391,7 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
 
 int ath_startrecv(struct ath_softc *sc)
 {
-	struct ath_hal *ah = sc->sc_ah;
+	struct ath_hw *ah = sc->sc_ah;
 	struct ath_buf *bf, *tbf;
 
 	spin_lock_bh(&sc->rx.rxbuflock);
@@ -421,7 +421,7 @@ start_recv:
 
 bool ath_stoprecv(struct ath_softc *sc)
 {
-	struct ath_hal *ah = sc->sc_ah;
+	struct ath_hw *ah = sc->sc_ah;
 	bool stopped;
 
 	ath9k_hw_stoppcurecv(ah);
@@ -452,7 +452,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 	struct ath_desc *ds;
 	struct sk_buff *skb = NULL, *requeue_skb;
 	struct ieee80211_rx_status rx_status;
-	struct ath_hal *ah = sc->sc_ah;
+	struct ath_hw *ah = sc->sc_ah;
 	struct ieee80211_hdr *hdr;
 	int hdrlen, padsize, retval;
 	bool decrypt_error = false;
diff --git a/drivers/net/wireless/ath9k/regd.c b/drivers/net/wireless/ath9k/regd.c
index 32dd0cb..8c2b56a 100644
--- a/drivers/net/wireless/ath9k/regd.c
+++ b/drivers/net/wireless/ath9k/regd.c
@@ -106,17 +106,17 @@ static const struct ieee80211_regdomain ath9k_world_regdom_67_68_6A = {
 	}
 };
 
-static u16 ath9k_regd_get_eepromRD(struct ath_hal *ah)
+static u16 ath9k_regd_get_eepromRD(struct ath_hw *ah)
 {
 	return ah->regulatory.current_rd & ~WORLDWIDE_ROAMING_FLAG;
 }
 
-u16 ath9k_regd_get_rd(struct ath_hal *ah)
+u16 ath9k_regd_get_rd(struct ath_hw *ah)
 {
 	return ath9k_regd_get_eepromRD(ah);
 }
 
-bool ath9k_is_world_regd(struct ath_hal *ah)
+bool ath9k_is_world_regd(struct ath_hw *ah)
 {
 	return isWwrSKU(ah);
 }
@@ -127,7 +127,7 @@ const struct ieee80211_regdomain *ath9k_default_world_regdomain(void)
 	return &ath9k_world_regdom_64;
 }
 
-const struct ieee80211_regdomain *ath9k_world_regdomain(struct ath_hal *ah)
+const struct ieee80211_regdomain *ath9k_world_regdomain(struct ath_hw *ah)
 {
 	switch (ah->regulatory.regpair->regDmnEnum) {
 	case 0x60:
@@ -282,7 +282,7 @@ void ath9k_reg_apply_world_flags(struct wiphy *wiphy, enum reg_set_by setby)
 {
 	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
 	struct ath_softc *sc = hw->priv;
-	struct ath_hal *ah = sc->sc_ah;
+	struct ath_hw *ah = sc->sc_ah;
 
 	switch (ah->regulatory.regpair->regDmnEnum) {
 	case 0x60:
@@ -322,7 +322,7 @@ int ath9k_reg_notifier(struct wiphy *wiphy, struct regulatory_request *request)
 	return 0;
 }
 
-bool ath9k_regd_is_eeprom_valid(struct ath_hal *ah)
+bool ath9k_regd_is_eeprom_valid(struct ath_hw *ah)
 {
 	u16 rd = ath9k_regd_get_eepromRD(ah);
 	int i;
@@ -371,7 +371,7 @@ ath9k_regd_find_country_by_rd(int regdmn)
 }
 
 /* Returns the map of the EEPROM set RD to a country code */
-static u16 ath9k_regd_get_default_country(struct ath_hal *ah)
+static u16 ath9k_regd_get_default_country(struct ath_hw *ah)
 {
 	u16 rd;
 
@@ -402,7 +402,7 @@ ath9k_get_regpair(int regdmn)
 	return NULL;
 }
 
-int ath9k_regd_init(struct ath_hal *ah)
+int ath9k_regd_init(struct ath_hw *ah)
 {
 	struct country_code_to_enum_rd *country = NULL;
 	int regdmn;
@@ -462,7 +462,7 @@ int ath9k_regd_init(struct ath_hal *ah)
 	return 0;
 }
 
-u32 ath9k_regd_get_ctl(struct ath_hal *ah, struct ath9k_channel *chan)
+u32 ath9k_regd_get_ctl(struct ath_hw *ah, struct ath9k_channel *chan)
 {
 	u32 ctl = NO_CTL;
 
diff --git a/drivers/net/wireless/ath9k/regd.h b/drivers/net/wireless/ath9k/regd.h
index 65abdf4..39420de 100644
--- a/drivers/net/wireless/ath9k/regd.h
+++ b/drivers/net/wireless/ath9k/regd.h
@@ -239,17 +239,17 @@ enum CountryCode {
 	CTRY_BELGIUM2 = 5002
 };
 
-u16 ath9k_regd_get_rd(struct ath_hal *ah);
-bool ath9k_is_world_regd(struct ath_hal *ah);
-const struct ieee80211_regdomain *ath9k_world_regdomain(struct ath_hal *ah);
+u16 ath9k_regd_get_rd(struct ath_hw *ah);
+bool ath9k_is_world_regd(struct ath_hw *ah);
+const struct ieee80211_regdomain *ath9k_world_regdomain(struct ath_hw *ah);
 const struct ieee80211_regdomain *ath9k_default_world_regdomain(void);
 void ath9k_reg_apply_world_flags(struct wiphy *wiphy, enum reg_set_by setby);
 void ath9k_reg_apply_radar_flags(struct wiphy *wiphy);
-int ath9k_regd_init(struct ath_hal *ah);
-bool ath9k_regd_is_eeprom_valid(struct ath_hal *ah);
-u32 ath9k_regd_get_ctl(struct ath_hal *ah, struct ath9k_channel *chan);
+int ath9k_regd_init(struct ath_hw *ah);
+bool ath9k_regd_is_eeprom_valid(struct ath_hw *ah);
+u32 ath9k_regd_get_ctl(struct ath_hw *ah, struct ath9k_channel *chan);
 int ath9k_reg_notifier(struct wiphy *wiphy, struct regulatory_request *request);
-void ath9k_regd_get_current_country(struct ath_hal *ah,
+void ath9k_regd_get_current_country(struct ath_hw *ah,
 				    struct ath9k_country_entry *ctry);
 
 #endif
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 7773760..3fff334 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -809,7 +809,7 @@ static void ath_txq_drain_pending_buffers(struct ath_softc *sc,
 
 struct ath_txq *ath_txq_setup(struct ath_softc *sc, int qtype, int subtype)
 {
-	struct ath_hal *ah = sc->sc_ah;
+	struct ath_hw *ah = sc->sc_ah;
 	struct ath9k_tx_queue_info qi;
 	int qnum;
 
@@ -926,7 +926,7 @@ struct ath_txq *ath_test_get_txq(struct ath_softc *sc, struct sk_buff *skb)
 int ath_txq_update(struct ath_softc *sc, int qnum,
 		   struct ath9k_tx_queue_info *qinfo)
 {
-	struct ath_hal *ah = sc->sc_ah;
+	struct ath_hw *ah = sc->sc_ah;
 	int error = 0;
 	struct ath9k_tx_queue_info qi;
 
@@ -1047,7 +1047,7 @@ void ath_draintxq(struct ath_softc *sc, struct ath_txq *txq, bool retry_tx)
 
 void ath_drain_all_txq(struct ath_softc *sc, bool retry_tx)
 {
-	struct ath_hal *ah = sc->sc_ah;
+	struct ath_hw *ah = sc->sc_ah;
 	struct ath_txq *txq;
 	int i, npend = 0;
 
@@ -1165,7 +1165,7 @@ int ath_tx_setup(struct ath_softc *sc, int haltype)
 static void ath_tx_txqaddbuf(struct ath_softc *sc, struct ath_txq *txq,
 			     struct list_head *head)
 {
-	struct ath_hal *ah = sc->sc_ah;
+	struct ath_hw *ah = sc->sc_ah;
 	struct ath_buf *bf;
 
 	/*
@@ -1580,7 +1580,7 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
 	struct list_head bf_head;
 	struct ath_desc *ds;
 	struct ath_atx_tid *tid;
-	struct ath_hal *ah = sc->sc_ah;
+	struct ath_hw *ah = sc->sc_ah;
 	int frm_type;
 
 	frm_type = get_hw_packet_type(skb);
@@ -1879,7 +1879,7 @@ static void ath_wake_mac80211_queue(struct ath_softc *sc, struct ath_txq *txq)
 
 static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 {
-	struct ath_hal *ah = sc->sc_ah;
+	struct ath_hw *ah = sc->sc_ah;
 	struct ath_buf *bf, *lastbf, *bf_held = NULL;
 	struct list_head bf_head;
 	struct ath_desc *ds;
-- 
1.6.1

