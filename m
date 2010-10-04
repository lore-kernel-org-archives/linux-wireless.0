Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:35395 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756706Ab0JDSJ4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 14:09:56 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 2/5] ath9k_hw: clean up ANI state handling
Date: Mon,  4 Oct 2010 20:09:47 +0200
Message-Id: <1286215790-67069-2-git-send-email-nbd@openwrt.org>
In-Reply-To: <1286215790-67069-1-git-send-email-nbd@openwrt.org>
References: <1286215790-67069-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ANI state is kept per channel, so instead of keeping an array of ANI states
with an arbitrary size of 255, move the ANI state into the channel struct.

Move some config settings that are not per-channel out of
the per-channel struct to save some memory.

With those changes, ath9k_ani_restart_old and ath9k_ani_restart_new can
be merged into a single function.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ani.c        |  338 ++++++++-------------------
 drivers/net/wireless/ath/ath9k/ani.h        |    8 +-
 drivers/net/wireless/ath/ath9k/ar5008_phy.c |   10 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |    7 +-
 drivers/net/wireless/ath/ath9k/hw.c         |    4 -
 drivers/net/wireless/ath/ath9k/hw.h         |    3 +-
 6 files changed, 110 insertions(+), 260 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index 9856a1b..6bae601 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -114,27 +114,6 @@ static bool use_new_ani(struct ath_hw *ah)
 	return AR_SREV_9300_20_OR_LATER(ah) || modparam_force_new_ani;
 }
 
-int ath9k_hw_get_ani_channel_idx(struct ath_hw *ah,
-				 struct ath9k_channel *chan)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(ah->ani); i++) {
-		if (ah->ani[i].c &&
-		    ah->ani[i].c->channel == chan->channel)
-			return i;
-		if (ah->ani[i].c == NULL) {
-			ah->ani[i].c = chan;
-			return i;
-		}
-	}
-
-	ath_print(ath9k_hw_common(ah), ATH_DBG_ANI,
-		  "No more channel states left. Using channel 0\n");
-
-	return 0;
-}
-
 static void ath9k_hw_update_mibstats(struct ath_hw *ah,
 				     struct ath9k_mib_stats *stats)
 {
@@ -145,76 +124,30 @@ static void ath9k_hw_update_mibstats(struct ath_hw *ah,
 	stats->beacons += REG_READ(ah, AR_BEACON_CNT);
 }
 
-static void ath9k_ani_restart_old(struct ath_hw *ah)
+static void ath9k_ani_restart(struct ath_hw *ah)
 {
 	struct ar5416AniState *aniState;
 	struct ath_common *common = ath9k_hw_common(ah);
+	u32 ofdm_base = 0, cck_base = 0;
 
 	if (!DO_ANI(ah))
 		return;
 
-	aniState = ah->curani;
+	aniState = &ah->curchan->ani;
 	aniState->listenTime = 0;
 
-	if (aniState->ofdmTrigHigh > AR_PHY_COUNTMAX) {
-		aniState->ofdmPhyErrBase = 0;
-		ath_print(common, ATH_DBG_ANI,
-			  "OFDM Trigger is too high for hw counters\n");
-	} else {
-		aniState->ofdmPhyErrBase =
-			AR_PHY_COUNTMAX - aniState->ofdmTrigHigh;
+	if (!use_new_ani(ah)) {
+		ofdm_base = AR_PHY_COUNTMAX - ah->config.ofdm_trig_high;
+		cck_base = AR_PHY_COUNTMAX - ah->config.cck_trig_high;
 	}
-	if (aniState->cckTrigHigh > AR_PHY_COUNTMAX) {
-		aniState->cckPhyErrBase = 0;
-		ath_print(common, ATH_DBG_ANI,
-			  "CCK Trigger is too high for hw counters\n");
-	} else {
-		aniState->cckPhyErrBase =
-			AR_PHY_COUNTMAX - aniState->cckTrigHigh;
-	}
-	ath_print(common, ATH_DBG_ANI,
-		  "Writing ofdmbase=%u   cckbase=%u\n",
-		  aniState->ofdmPhyErrBase,
-		  aniState->cckPhyErrBase);
-
-	ENABLE_REGWRITE_BUFFER(ah);
-
-	REG_WRITE(ah, AR_PHY_ERR_1, aniState->ofdmPhyErrBase);
-	REG_WRITE(ah, AR_PHY_ERR_2, aniState->cckPhyErrBase);
-	REG_WRITE(ah, AR_PHY_ERR_MASK_1, AR_PHY_ERR_OFDM_TIMING);
-	REG_WRITE(ah, AR_PHY_ERR_MASK_2, AR_PHY_ERR_CCK_TIMING);
-
-	REGWRITE_BUFFER_FLUSH(ah);
-
-	ath9k_hw_update_mibstats(ah, &ah->ah_mibStats);
-
-	aniState->ofdmPhyErrCount = 0;
-	aniState->cckPhyErrCount = 0;
-}
-
-static void ath9k_ani_restart_new(struct ath_hw *ah)
-{
-	struct ar5416AniState *aniState;
-	struct ath_common *common = ath9k_hw_common(ah);
-
-	if (!DO_ANI(ah))
-		return;
-
-	aniState = ah->curani;
-	aniState->listenTime = 0;
-
-	aniState->ofdmPhyErrBase = 0;
-	aniState->cckPhyErrBase = 0;
 
 	ath_print(common, ATH_DBG_ANI,
-		  "Writing ofdmbase=%08x   cckbase=%08x\n",
-		  aniState->ofdmPhyErrBase,
-		  aniState->cckPhyErrBase);
+		  "Writing ofdmbase=%u   cckbase=%u\n", ofdm_base, cck_base);
 
 	ENABLE_REGWRITE_BUFFER(ah);
 
-	REG_WRITE(ah, AR_PHY_ERR_1, aniState->ofdmPhyErrBase);
-	REG_WRITE(ah, AR_PHY_ERR_2, aniState->cckPhyErrBase);
+	REG_WRITE(ah, AR_PHY_ERR_1, ofdm_base);
+	REG_WRITE(ah, AR_PHY_ERR_2, cck_base);
 	REG_WRITE(ah, AR_PHY_ERR_MASK_1, AR_PHY_ERR_OFDM_TIMING);
 	REG_WRITE(ah, AR_PHY_ERR_MASK_2, AR_PHY_ERR_CCK_TIMING);
 
@@ -235,7 +168,7 @@ static void ath9k_hw_ani_ofdm_err_trigger_old(struct ath_hw *ah)
 	if (!DO_ANI(ah))
 		return;
 
-	aniState = ah->curani;
+	aniState = &ah->curchan->ani;
 
 	if (aniState->noiseImmunityLevel < HAL_NOISE_IMMUNE_MAX) {
 		if (ath9k_hw_ani_control(ah, ATH9K_ANI_NOISE_IMMUNITY_LEVEL,
@@ -307,7 +240,7 @@ static void ath9k_hw_ani_cck_err_trigger_old(struct ath_hw *ah)
 	if (!DO_ANI(ah))
 		return;
 
-	aniState = ah->curani;
+	aniState = &ah->curchan->ani;
 	if (aniState->noiseImmunityLevel < HAL_NOISE_IMMUNE_MAX) {
 		if (ath9k_hw_ani_control(ah, ATH9K_ANI_NOISE_IMMUNITY_LEVEL,
 					 aniState->noiseImmunityLevel + 1)) {
@@ -339,7 +272,7 @@ static void ath9k_hw_ani_cck_err_trigger_old(struct ath_hw *ah)
 /* Adjust the OFDM Noise Immunity Level */
 static void ath9k_hw_set_ofdm_nil(struct ath_hw *ah, u8 immunityLevel)
 {
-	struct ar5416AniState *aniState = ah->curani;
+	struct ar5416AniState *aniState = &ah->curchan->ani;
 	struct ath_common *common = ath9k_hw_common(ah);
 	const struct ani_ofdm_level_entry *entry_ofdm;
 	const struct ani_cck_level_entry *entry_cck;
@@ -391,7 +324,7 @@ static void ath9k_hw_ani_ofdm_err_trigger_new(struct ath_hw *ah)
 	if (!DO_ANI(ah))
 		return;
 
-	aniState = ah->curani;
+	aniState = &ah->curchan->ani;
 
 	if (aniState->ofdmNoiseImmunityLevel < ATH9K_ANI_OFDM_MAX_LEVEL)
 		ath9k_hw_set_ofdm_nil(ah, aniState->ofdmNoiseImmunityLevel + 1);
@@ -402,7 +335,7 @@ static void ath9k_hw_ani_ofdm_err_trigger_new(struct ath_hw *ah)
  */
 static void ath9k_hw_set_cck_nil(struct ath_hw *ah, u_int8_t immunityLevel)
 {
-	struct ar5416AniState *aniState = ah->curani;
+	struct ar5416AniState *aniState = &ah->curchan->ani;
 	struct ath_common *common = ath9k_hw_common(ah);
 	const struct ani_ofdm_level_entry *entry_ofdm;
 	const struct ani_cck_level_entry *entry_cck;
@@ -448,7 +381,7 @@ static void ath9k_hw_ani_cck_err_trigger_new(struct ath_hw *ah)
 	if (!DO_ANI(ah))
 		return;
 
-	aniState = ah->curani;
+	aniState = &ah->curchan->ani;
 
 	if (aniState->cckNoiseImmunityLevel < ATH9K_ANI_CCK_MAX_LEVEL)
 		ath9k_hw_set_cck_nil(ah, aniState->cckNoiseImmunityLevel + 1);
@@ -459,7 +392,7 @@ static void ath9k_hw_ani_lower_immunity_old(struct ath_hw *ah)
 	struct ar5416AniState *aniState;
 	int32_t rssi;
 
-	aniState = ah->curani;
+	aniState = &ah->curchan->ani;
 
 	if (ah->opmode == NL80211_IFTYPE_AP) {
 		if (aniState->firstepLevel > 0) {
@@ -515,7 +448,7 @@ static void ath9k_hw_ani_lower_immunity_new(struct ath_hw *ah)
 {
 	struct ar5416AniState *aniState;
 
-	aniState = ah->curani;
+	aniState = &ah->curchan->ani;
 
 	/* lower OFDM noise immunity */
 	if (aniState->ofdmNoiseImmunityLevel > 0 &&
@@ -568,16 +501,13 @@ static void ath9k_ani_reset_old(struct ath_hw *ah, bool is_scanning)
 	struct ar5416AniState *aniState;
 	struct ath9k_channel *chan = ah->curchan;
 	struct ath_common *common = ath9k_hw_common(ah);
-	int index;
 
 	if (!DO_ANI(ah))
 		return;
 
-	index = ath9k_hw_get_ani_channel_idx(ah, chan);
-	aniState = &ah->ani[index];
-	ah->curani = aniState;
+	aniState = &ah->curchan->ani;
 
-	if (DO_ANI(ah) && ah->opmode != NL80211_IFTYPE_STATION
+	if (ah->opmode != NL80211_IFTYPE_STATION
 	    && ah->opmode != NL80211_IFTYPE_ADHOC) {
 		ath_print(common, ATH_DBG_ANI,
 			  "Reset ANI state opmode %u\n", ah->opmode);
@@ -606,17 +536,7 @@ static void ath9k_ani_reset_old(struct ath_hw *ah, bool is_scanning)
 		ath9k_hw_setrxfilter(ah, ath9k_hw_getrxfilter(ah) |
 				     ATH9K_RX_FILTER_PHYERR);
 
-		if (ah->opmode == NL80211_IFTYPE_AP) {
-			ah->curani->ofdmTrigHigh =
-				ah->config.ofdm_trig_high;
-			ah->curani->ofdmTrigLow =
-				ah->config.ofdm_trig_low;
-			ah->curani->cckTrigHigh =
-				ah->config.cck_trig_high;
-			ah->curani->cckTrigLow =
-				ah->config.cck_trig_low;
-		}
-		ath9k_ani_restart_old(ah);
+		ath9k_ani_restart(ah);
 		return;
 	}
 
@@ -638,7 +558,7 @@ static void ath9k_ani_reset_old(struct ath_hw *ah, bool is_scanning)
 
 	ath9k_hw_setrxfilter(ah, ath9k_hw_getrxfilter(ah) &
 			     ~ATH9K_RX_FILTER_PHYERR);
-	ath9k_ani_restart_old(ah);
+	ath9k_ani_restart(ah);
 
 	ENABLE_REGWRITE_BUFFER(ah);
 
@@ -655,7 +575,7 @@ static void ath9k_ani_reset_old(struct ath_hw *ah, bool is_scanning)
  */
 static void ath9k_ani_reset_new(struct ath_hw *ah, bool is_scanning)
 {
-	struct ar5416AniState *aniState = ah->curani;
+	struct ar5416AniState *aniState = &ah->curchan->ani;
 	struct ath9k_channel *chan = ah->curchan;
 	struct ath_common *common = ath9k_hw_common(ah);
 
@@ -731,7 +651,7 @@ static void ath9k_ani_reset_new(struct ath_hw *ah, bool is_scanning)
 	 * enable phy counters if hw supports or if not, enable phy
 	 * interrupts (so we can count each one)
 	 */
-	ath9k_ani_restart_new(ah);
+	ath9k_ani_restart(ah);
 
 	ENABLE_REGWRITE_BUFFER(ah);
 
@@ -749,16 +669,18 @@ static void ath9k_hw_ani_monitor_old(struct ath_hw *ah,
 	int32_t listenTime;
 	u32 phyCnt1, phyCnt2;
 	u32 ofdmPhyErrCnt, cckPhyErrCnt;
+	u32 ofdm_base = AR_PHY_COUNTMAX - ah->config.ofdm_trig_high;
+	u32 cck_base = AR_PHY_COUNTMAX - ah->config.cck_trig_high;
 
 	if (!DO_ANI(ah))
 		return;
 
-	aniState = ah->curani;
+	aniState = &ah->curchan->ani;
 
 	listenTime = ath9k_hw_ani_get_listen_time(ah);
 	if (listenTime < 0) {
 		ah->stats.ast_ani_lneg++;
-		ath9k_ani_restart_old(ah);
+		ath9k_ani_restart(ah);
 		return;
 	}
 
@@ -769,60 +691,55 @@ static void ath9k_hw_ani_monitor_old(struct ath_hw *ah,
 	phyCnt1 = REG_READ(ah, AR_PHY_ERR_1);
 	phyCnt2 = REG_READ(ah, AR_PHY_ERR_2);
 
-	if (phyCnt1 < aniState->ofdmPhyErrBase ||
-	    phyCnt2 < aniState->cckPhyErrBase) {
-		if (phyCnt1 < aniState->ofdmPhyErrBase) {
+	if (phyCnt1 < ofdm_base || phyCnt2 < cck_base) {
+		if (phyCnt1 < ofdm_base) {
 			ath_print(common, ATH_DBG_ANI,
 				  "phyCnt1 0x%x, resetting "
 				  "counter value to 0x%x\n",
-				  phyCnt1,
-				  aniState->ofdmPhyErrBase);
-			REG_WRITE(ah, AR_PHY_ERR_1,
-				  aniState->ofdmPhyErrBase);
+				  phyCnt1, ofdm_base);
+			REG_WRITE(ah, AR_PHY_ERR_1, ofdm_base);
 			REG_WRITE(ah, AR_PHY_ERR_MASK_1,
 				  AR_PHY_ERR_OFDM_TIMING);
 		}
-		if (phyCnt2 < aniState->cckPhyErrBase) {
+		if (phyCnt2 < cck_base) {
 			ath_print(common, ATH_DBG_ANI,
 				  "phyCnt2 0x%x, resetting "
 				  "counter value to 0x%x\n",
-				  phyCnt2,
-				  aniState->cckPhyErrBase);
-			REG_WRITE(ah, AR_PHY_ERR_2,
-				  aniState->cckPhyErrBase);
+				  phyCnt2, cck_base);
+			REG_WRITE(ah, AR_PHY_ERR_2, cck_base);
 			REG_WRITE(ah, AR_PHY_ERR_MASK_2,
 				  AR_PHY_ERR_CCK_TIMING);
 		}
 		return;
 	}
 
-	ofdmPhyErrCnt = phyCnt1 - aniState->ofdmPhyErrBase;
+	ofdmPhyErrCnt = phyCnt1 - ofdm_base;
 	ah->stats.ast_ani_ofdmerrs +=
 		ofdmPhyErrCnt - aniState->ofdmPhyErrCount;
 	aniState->ofdmPhyErrCount = ofdmPhyErrCnt;
 
-	cckPhyErrCnt = phyCnt2 - aniState->cckPhyErrBase;
+	cckPhyErrCnt = phyCnt2 - cck_base;
 	ah->stats.ast_ani_cckerrs +=
 		cckPhyErrCnt - aniState->cckPhyErrCount;
 	aniState->cckPhyErrCount = cckPhyErrCnt;
 
 	if (aniState->listenTime > 5 * ah->aniperiod) {
 		if (aniState->ofdmPhyErrCount <= aniState->listenTime *
-		    aniState->ofdmTrigLow / 1000 &&
+		    ah->config.ofdm_trig_low / 1000 &&
 		    aniState->cckPhyErrCount <= aniState->listenTime *
-		    aniState->cckTrigLow / 1000)
+		    ah->config.cck_trig_low / 1000)
 			ath9k_hw_ani_lower_immunity(ah);
-		ath9k_ani_restart_old(ah);
+		ath9k_ani_restart(ah);
 	} else if (aniState->listenTime > ah->aniperiod) {
 		if (aniState->ofdmPhyErrCount > aniState->listenTime *
-		    aniState->ofdmTrigHigh / 1000) {
+		    ah->config.ofdm_trig_high / 1000) {
 			ath9k_hw_ani_ofdm_err_trigger_old(ah);
-			ath9k_ani_restart_old(ah);
+			ath9k_ani_restart(ah);
 		} else if (aniState->cckPhyErrCount >
-			   aniState->listenTime * aniState->cckTrigHigh /
+			   aniState->listenTime * ah->config.cck_trig_high /
 			   1000) {
 			ath9k_hw_ani_cck_err_trigger_old(ah);
-			ath9k_ani_restart_old(ah);
+			ath9k_ani_restart(ah);
 		}
 	}
 }
@@ -833,14 +750,13 @@ static void ath9k_hw_ani_monitor_new(struct ath_hw *ah,
 	struct ar5416AniState *aniState;
 	struct ath_common *common = ath9k_hw_common(ah);
 	int32_t listenTime;
-	u32 phyCnt1, phyCnt2;
 	u32 ofdmPhyErrCnt, cckPhyErrCnt;
 	u32 ofdmPhyErrRate, cckPhyErrRate;
 
 	if (!DO_ANI(ah))
 		return;
 
-	aniState = ah->curani;
+	aniState = &ah->curchan->ani;
 	if (WARN_ON(!aniState))
 		return;
 
@@ -851,7 +767,7 @@ static void ath9k_hw_ani_monitor_new(struct ath_hw *ah,
 		ath_print(common, ATH_DBG_ANI,
 			  "listenTime=%d - on new ani monitor\n",
 			  listenTime);
-		ath9k_ani_restart_new(ah);
+		ath9k_ani_restart(ah);
 		return;
 	}
 
@@ -859,55 +775,20 @@ static void ath9k_hw_ani_monitor_new(struct ath_hw *ah,
 
 	ath9k_hw_update_mibstats(ah, &ah->ah_mibStats);
 
-	phyCnt1 = REG_READ(ah, AR_PHY_ERR_1);
-	phyCnt2 = REG_READ(ah, AR_PHY_ERR_2);
-
-	if (phyCnt1 < aniState->ofdmPhyErrBase ||
-	    phyCnt2 < aniState->cckPhyErrBase) {
-		if (phyCnt1 < aniState->ofdmPhyErrBase) {
-			ath_print(common, ATH_DBG_ANI,
-				  "phyCnt1 0x%x, resetting "
-				  "counter value to 0x%x\n",
-				  phyCnt1,
-				  aniState->ofdmPhyErrBase);
-			REG_WRITE(ah, AR_PHY_ERR_1,
-				  aniState->ofdmPhyErrBase);
-			REG_WRITE(ah, AR_PHY_ERR_MASK_1,
-				  AR_PHY_ERR_OFDM_TIMING);
-		}
-		if (phyCnt2 < aniState->cckPhyErrBase) {
-			ath_print(common, ATH_DBG_ANI,
-				  "phyCnt2 0x%x, resetting "
-				  "counter value to 0x%x\n",
-				  phyCnt2,
-				  aniState->cckPhyErrBase);
-			REG_WRITE(ah, AR_PHY_ERR_2,
-				  aniState->cckPhyErrBase);
-			REG_WRITE(ah, AR_PHY_ERR_MASK_2,
-				  AR_PHY_ERR_CCK_TIMING);
-		}
-		return;
-	}
+	ofdmPhyErrCnt = REG_READ(ah, AR_PHY_ERR_1);
+	cckPhyErrCnt = REG_READ(ah, AR_PHY_ERR_2);
 
-	ofdmPhyErrCnt = phyCnt1 - aniState->ofdmPhyErrBase;
 	ah->stats.ast_ani_ofdmerrs +=
 		ofdmPhyErrCnt - aniState->ofdmPhyErrCount;
 	aniState->ofdmPhyErrCount = ofdmPhyErrCnt;
 
-	cckPhyErrCnt = phyCnt2 - aniState->cckPhyErrBase;
 	ah->stats.ast_ani_cckerrs +=
 		cckPhyErrCnt - aniState->cckPhyErrCount;
 	aniState->cckPhyErrCount = cckPhyErrCnt;
 
 	ath_print(common, ATH_DBG_ANI,
-		  "Errors: OFDM=0x%08x-0x%08x=%d   "
-		  "CCK=0x%08x-0x%08x=%d\n",
-		  phyCnt1,
-		  aniState->ofdmPhyErrBase,
-		  ofdmPhyErrCnt,
-		  phyCnt2,
-		  aniState->cckPhyErrBase,
-		  cckPhyErrCnt);
+		  "Errors: OFDM=%d, CCK=%d\n",
+		  ofdmPhyErrCnt, cckPhyErrCnt);
 
 	ofdmPhyErrRate = aniState->ofdmPhyErrCount * 1000 /
 			 aniState->listenTime;
@@ -922,8 +803,8 @@ static void ath9k_hw_ani_monitor_new(struct ath_hw *ah,
 		  cckPhyErrRate, aniState->ofdmsTurn);
 
 	if (aniState->listenTime > 5 * ah->aniperiod) {
-		if (ofdmPhyErrRate <= aniState->ofdmTrigLow &&
-		    cckPhyErrRate <= aniState->cckTrigLow) {
+		if (ofdmPhyErrRate <= ah->config.ofdm_trig_low &&
+		    cckPhyErrRate <= ah->config.cck_trig_low) {
 			ath_print(common, ATH_DBG_ANI,
 				  "1. listenTime=%d OFDM:%d errs=%d/s(<%d)  "
 				  "CCK:%d errs=%d/s(<%d) -> "
@@ -931,22 +812,22 @@ static void ath9k_hw_ani_monitor_new(struct ath_hw *ah,
 				  aniState->listenTime,
 				  aniState->ofdmNoiseImmunityLevel,
 				  ofdmPhyErrRate,
-				  aniState->ofdmTrigLow,
+				  ah->config.ofdm_trig_low,
 				  aniState->cckNoiseImmunityLevel,
 				  cckPhyErrRate,
-				  aniState->cckTrigLow);
+				  ah->config.cck_trig_low);
 			ath9k_hw_ani_lower_immunity(ah);
 			aniState->ofdmsTurn = !aniState->ofdmsTurn;
 		}
 		ath_print(common, ATH_DBG_ANI,
 			  "1 listenTime=%d ofdm=%d/s cck=%d/s - "
-			  "calling ath9k_ani_restart_new()\n",
+			  "calling ath9k_ani_restart()\n",
 			  aniState->listenTime, ofdmPhyErrRate, cckPhyErrRate);
-		ath9k_ani_restart_new(ah);
+		ath9k_ani_restart(ah);
 	} else if (aniState->listenTime > ah->aniperiod) {
 		/* check to see if need to raise immunity */
-		if (ofdmPhyErrRate > aniState->ofdmTrigHigh &&
-		    (cckPhyErrRate <= aniState->cckTrigHigh ||
+		if (ofdmPhyErrRate > ah->config.ofdm_trig_high &&
+		    (cckPhyErrRate <= ah->config.cck_trig_high ||
 		     aniState->ofdmsTurn)) {
 			ath_print(common, ATH_DBG_ANI,
 				  "2 listenTime=%d OFDM:%d errs=%d/s(>%d) -> "
@@ -954,20 +835,20 @@ static void ath9k_hw_ani_monitor_new(struct ath_hw *ah,
 				  aniState->listenTime,
 				  aniState->ofdmNoiseImmunityLevel,
 				  ofdmPhyErrRate,
-				  aniState->ofdmTrigHigh);
+				  ah->config.ofdm_trig_high);
 			ath9k_hw_ani_ofdm_err_trigger_new(ah);
-			ath9k_ani_restart_new(ah);
+			ath9k_ani_restart(ah);
 			aniState->ofdmsTurn = false;
-		} else if (cckPhyErrRate > aniState->cckTrigHigh) {
+		} else if (cckPhyErrRate > ah->config.cck_trig_high) {
 			ath_print(common, ATH_DBG_ANI,
 				 "3 listenTime=%d CCK:%d errs=%d/s(>%d) -> "
 				 "ath9k_hw_ani_cck_err_trigger_new()\n",
 				 aniState->listenTime,
 				 aniState->cckNoiseImmunityLevel,
 				 cckPhyErrRate,
-				 aniState->cckTrigHigh);
+				 ah->config.cck_trig_high);
 			ath9k_hw_ani_cck_err_trigger_new(ah);
-			ath9k_ani_restart_new(ah);
+			ath9k_ani_restart(ah);
 			aniState->ofdmsTurn = true;
 		}
 	}
@@ -1064,6 +945,8 @@ skip:
  */
 static void ath9k_hw_proc_mib_event_old(struct ath_hw *ah)
 {
+	u32 ofdm_base = AR_PHY_COUNTMAX - ah->config.ofdm_trig_high;
+	u32 cck_base = AR_PHY_COUNTMAX - ah->config.cck_trig_high;
 	u32 phyCnt1, phyCnt2;
 
 	/* Reset these counters regardless */
@@ -1090,16 +973,16 @@ static void ath9k_hw_proc_mib_event_old(struct ath_hw *ah)
 	phyCnt2 = REG_READ(ah, AR_PHY_ERR_2);
 	if (((phyCnt1 & AR_MIBCNT_INTRMASK) == AR_MIBCNT_INTRMASK) ||
 	    ((phyCnt2 & AR_MIBCNT_INTRMASK) == AR_MIBCNT_INTRMASK)) {
-		struct ar5416AniState *aniState = ah->curani;
+		struct ar5416AniState *aniState = &ah->curchan->ani;
 		u32 ofdmPhyErrCnt, cckPhyErrCnt;
 
 		/* NB: only use ast_ani_*errs with AH_PRIVATE_DIAG */
-		ofdmPhyErrCnt = phyCnt1 - aniState->ofdmPhyErrBase;
+		ofdmPhyErrCnt = phyCnt1 - ofdm_base;
 		ah->stats.ast_ani_ofdmerrs +=
 			ofdmPhyErrCnt - aniState->ofdmPhyErrCount;
 		aniState->ofdmPhyErrCount = ofdmPhyErrCnt;
 
-		cckPhyErrCnt = phyCnt2 - aniState->cckPhyErrBase;
+		cckPhyErrCnt = phyCnt2 - cck_base;
 		ah->stats.ast_ani_cckerrs +=
 			cckPhyErrCnt - aniState->cckPhyErrCount;
 		aniState->cckPhyErrCount = cckPhyErrCnt;
@@ -1110,12 +993,12 @@ static void ath9k_hw_proc_mib_event_old(struct ath_hw *ah)
 		 * clobbers the error counter so the trigger threshold
 		 * check will never be true.
 		 */
-		if (aniState->ofdmPhyErrCount > aniState->ofdmTrigHigh)
+		if (aniState->ofdmPhyErrCount > ah->config.ofdm_trig_high)
 			ath9k_hw_ani_ofdm_err_trigger_new(ah);
-		if (aniState->cckPhyErrCount > aniState->cckTrigHigh)
+		if (aniState->cckPhyErrCount > ah->config.cck_trig_high)
 			ath9k_hw_ani_cck_err_trigger_old(ah);
 		/* NB: always restart to insure the h/w counters are reset */
-		ath9k_ani_restart_old(ah);
+		ath9k_ani_restart(ah);
 	}
 }
 
@@ -1154,7 +1037,7 @@ static void ath9k_hw_proc_mib_event_new(struct ath_hw *ah)
 	/* NB: always restart to insure the h/w counters are reset */
 	if (((phyCnt1 & AR_MIBCNT_INTRMASK) == AR_MIBCNT_INTRMASK) ||
 	    ((phyCnt2 & AR_MIBCNT_INTRMASK) == AR_MIBCNT_INTRMASK))
-		ath9k_ani_restart_new(ah);
+		ath9k_ani_restart(ah);
 }
 
 void ath9k_hw_ani_setup(struct ath_hw *ah)
@@ -1181,54 +1064,51 @@ void ath9k_hw_ani_init(struct ath_hw *ah)
 
 	ath_print(common, ATH_DBG_ANI, "Initialize ANI\n");
 
-	memset(ah->ani, 0, sizeof(ah->ani));
-	for (i = 0; i < ARRAY_SIZE(ah->ani); i++) {
-		if (use_new_ani(ah)) {
-			ah->ani[i].ofdmTrigHigh = ATH9K_ANI_OFDM_TRIG_HIGH_NEW;
-			ah->ani[i].ofdmTrigLow = ATH9K_ANI_OFDM_TRIG_LOW_NEW;
+	if (use_new_ani(ah)) {
+		ah->config.ofdm_trig_high = ATH9K_ANI_OFDM_TRIG_HIGH_NEW;
+		ah->config.ofdm_trig_low = ATH9K_ANI_OFDM_TRIG_LOW_NEW;
 
-			ah->ani[i].cckTrigHigh = ATH9K_ANI_CCK_TRIG_HIGH_NEW;
-			ah->ani[i].cckTrigLow = ATH9K_ANI_CCK_TRIG_LOW_NEW;
+		ah->config.cck_trig_high = ATH9K_ANI_CCK_TRIG_HIGH_NEW;
+		ah->config.cck_trig_low = ATH9K_ANI_CCK_TRIG_LOW_NEW;
+	} else {
+		ah->config.ofdm_trig_high = ATH9K_ANI_OFDM_TRIG_HIGH_OLD;
+		ah->config.ofdm_trig_low = ATH9K_ANI_OFDM_TRIG_LOW_OLD;
 
-			ah->ani[i].spurImmunityLevel =
-				ATH9K_ANI_SPUR_IMMUNE_LVL_NEW;
+		ah->config.cck_trig_high = ATH9K_ANI_CCK_TRIG_HIGH_OLD;
+		ah->config.cck_trig_low = ATH9K_ANI_CCK_TRIG_LOW_OLD;
+	}
 
-			ah->ani[i].firstepLevel = ATH9K_ANI_FIRSTEP_LVL_NEW;
+	for (i = 0; i < ARRAY_SIZE(ah->channels); i++) {
+		struct ath9k_channel *chan = &ah->channels[i];
+		struct ar5416AniState *ani = &chan->ani;
+
+		if (use_new_ani(ah)) {
+			ani->spurImmunityLevel =
+				ATH9K_ANI_SPUR_IMMUNE_LVL_NEW;
 
-			ah->ani[i].ofdmPhyErrBase = 0;
-			ah->ani[i].cckPhyErrBase = 0;
+			ani->firstepLevel = ATH9K_ANI_FIRSTEP_LVL_NEW;
 
 			if (AR_SREV_9300_20_OR_LATER(ah))
-				ah->ani[i].mrcCCKOff =
+				ani->mrcCCKOff =
 					!ATH9K_ANI_ENABLE_MRC_CCK;
 			else
-				ah->ani[i].mrcCCKOff = true;
+				ani->mrcCCKOff = true;
 
-			ah->ani[i].ofdmsTurn = true;
+			ani->ofdmsTurn = true;
 		} else {
-			ah->ani[i].ofdmTrigHigh = ATH9K_ANI_OFDM_TRIG_HIGH_OLD;
-			ah->ani[i].ofdmTrigLow = ATH9K_ANI_OFDM_TRIG_LOW_OLD;
-
-			ah->ani[i].cckTrigHigh = ATH9K_ANI_CCK_TRIG_HIGH_OLD;
-			ah->ani[i].cckTrigLow = ATH9K_ANI_CCK_TRIG_LOW_OLD;
-
-			ah->ani[i].spurImmunityLevel =
+			ani->spurImmunityLevel =
 				ATH9K_ANI_SPUR_IMMUNE_LVL_OLD;
-			ah->ani[i].firstepLevel = ATH9K_ANI_FIRSTEP_LVL_OLD;
+			ani->firstepLevel = ATH9K_ANI_FIRSTEP_LVL_OLD;
 
-			ah->ani[i].ofdmPhyErrBase =
-				AR_PHY_COUNTMAX - ATH9K_ANI_OFDM_TRIG_HIGH_OLD;
-			ah->ani[i].cckPhyErrBase =
-				AR_PHY_COUNTMAX - ATH9K_ANI_CCK_TRIG_HIGH_OLD;
-			ah->ani[i].cckWeakSigThreshold =
+			ani->cckWeakSigThreshold =
 				ATH9K_ANI_CCK_WEAK_SIG_THR;
 		}
 
-		ah->ani[i].rssiThrHigh = ATH9K_ANI_RSSI_THR_HIGH;
-		ah->ani[i].rssiThrLow = ATH9K_ANI_RSSI_THR_LOW;
-		ah->ani[i].ofdmWeakSigDetectOff =
+		ani->rssiThrHigh = ATH9K_ANI_RSSI_THR_HIGH;
+		ani->rssiThrLow = ATH9K_ANI_RSSI_THR_LOW;
+		ani->ofdmWeakSigDetectOff =
 			!ATH9K_ANI_USE_OFDM_WEAK_SIG;
-		ah->ani[i].cckNoiseImmunityLevel = ATH9K_ANI_CCK_DEF_LEVEL;
+		ani->cckNoiseImmunityLevel = ATH9K_ANI_CCK_DEF_LEVEL;
 	}
 
 	/*
@@ -1249,23 +1129,11 @@ void ath9k_hw_ani_init(struct ath_hw *ah)
 		ah->config.ani_poll_interval = ATH9K_ANI_POLLINTERVAL_OLD;
 	}
 
-	ath_print(common, ATH_DBG_ANI,
-		  "Setting OfdmErrBase = 0x%08x\n",
-		  ah->ani[0].ofdmPhyErrBase);
-	ath_print(common, ATH_DBG_ANI, "Setting cckErrBase = 0x%08x\n",
-		  ah->ani[0].cckPhyErrBase);
-
-	ENABLE_REGWRITE_BUFFER(ah);
-
-	REG_WRITE(ah, AR_PHY_ERR_1, ah->ani[0].ofdmPhyErrBase);
-	REG_WRITE(ah, AR_PHY_ERR_2, ah->ani[0].cckPhyErrBase);
-
-	REGWRITE_BUFFER_FLUSH(ah);
-
-	ath9k_enable_mib_counters(ah);
-
 	if (ah->config.enable_ani)
 		ah->proc_phyerr |= HAL_PROCESS_ANI;
+
+	ath9k_ani_restart(ah);
+	ath9k_enable_mib_counters(ah);
 }
 
 void ath9k_hw_attach_ani_ops_old(struct ath_hw *ah)
diff --git a/drivers/net/wireless/ath/ath9k/ani.h b/drivers/net/wireless/ath/ath9k/ani.h
index 15f9d67..98cfd81 100644
--- a/drivers/net/wireless/ath/ath9k/ani.h
+++ b/drivers/net/wireless/ath/ath9k/ani.h
@@ -19,7 +19,7 @@
 
 #define HAL_PROCESS_ANI           0x00000001
 
-#define DO_ANI(ah) (((ah)->proc_phyerr & HAL_PROCESS_ANI))
+#define DO_ANI(ah) (((ah)->proc_phyerr & HAL_PROCESS_ANI) && ah->curchan)
 
 #define BEACON_RSSI(ahp) (ahp->stats.avgbrssi)
 
@@ -130,17 +130,11 @@ struct ar5416AniState {
 	u8 ofdmWeakSigDetectOff;
 	u8 cckWeakSigThreshold;
 	u32 listenTime;
-	u32 ofdmTrigHigh;
-	u32 ofdmTrigLow;
-	int32_t cckTrigHigh;
-	int32_t cckTrigLow;
 	int32_t rssiThrLow;
 	int32_t rssiThrHigh;
 	u32 noiseFloor;
 	u32 ofdmPhyErrCount;
 	u32 cckPhyErrCount;
-	u32 ofdmPhyErrBase;
-	u32 cckPhyErrBase;
 	int16_t pktRssi[2];
 	int16_t ofdmErrRssi[2];
 	int16_t cckErrRssi[2];
diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index da07f8d..c0e7939 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -1050,7 +1050,7 @@ static bool ar5008_hw_ani_control_old(struct ath_hw *ah,
 				      enum ath9k_ani_cmd cmd,
 				      int param)
 {
-	struct ar5416AniState *aniState = ah->curani;
+	struct ar5416AniState *aniState = &ah->curchan->ani;
 	struct ath_common *common = ath9k_hw_common(ah);
 
 	switch (cmd & ah->ani_function) {
@@ -1233,9 +1233,9 @@ static bool ar5008_hw_ani_control_new(struct ath_hw *ah,
 				      enum ath9k_ani_cmd cmd,
 				      int param)
 {
-	struct ar5416AniState *aniState = ah->curani;
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_channel *chan = ah->curchan;
+	struct ar5416AniState *aniState = &chan->ani;
 	s32 value, value2;
 
 	switch (cmd & ah->ani_function) {
@@ -1520,16 +1520,12 @@ static void ar5008_hw_do_getnf(struct ath_hw *ah,
  */
 static void ar5008_hw_ani_cache_ini_regs(struct ath_hw *ah)
 {
-	struct ar5416AniState *aniState;
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_channel *chan = ah->curchan;
+	struct ar5416AniState *aniState = &chan->ani;
 	struct ath9k_ani_default *iniDef;
-	int index;
 	u32 val;
 
-	index = ath9k_hw_get_ani_channel_idx(ah, chan);
-	aniState = &ah->ani[index];
-	ah->curani = aniState;
 	iniDef = &aniState->iniDef;
 
 	ath_print(common, ATH_DBG_ANI,
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index e15574c..efb0559 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -747,9 +747,9 @@ static void ar9003_hw_set_diversity(struct ath_hw *ah, bool value)
 static bool ar9003_hw_ani_control(struct ath_hw *ah,
 				  enum ath9k_ani_cmd cmd, int param)
 {
-	struct ar5416AniState *aniState = ah->curani;
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_channel *chan = ah->curchan;
+	struct ar5416AniState *aniState = &chan->ani;
 	s32 value, value2;
 
 	switch (cmd & ah->ani_function) {
@@ -1065,12 +1065,9 @@ static void ar9003_hw_ani_cache_ini_regs(struct ath_hw *ah)
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_channel *chan = ah->curchan;
 	struct ath9k_ani_default *iniDef;
-	int index;
 	u32 val;
 
-	index = ath9k_hw_get_ani_channel_idx(ah, chan);
-	aniState = &ah->ani[index];
-	ah->curani = aniState;
+	aniState = &ah->curchan->ani;
 	iniDef = &aniState->iniDef;
 
 	ath_print(common, ATH_DBG_ANI,
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 98c9765..05e9935 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -370,10 +370,6 @@ static void ath9k_hw_init_config(struct ath_hw *ah)
 	ah->config.pcie_clock_req = 0;
 	ah->config.pcie_waen = 0;
 	ah->config.analog_shiftreg = 1;
-	ah->config.ofdm_trig_low = 200;
-	ah->config.ofdm_trig_high = 500;
-	ah->config.cck_trig_high = 200;
-	ah->config.cck_trig_low = 100;
 	ah->config.enable_ani = true;
 
 	for (i = 0; i < AR_EEPROM_MODAL_SPURS; i++) {
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index d558c51..5063463 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -346,6 +346,7 @@ struct ath9k_hw_cal_data {
 
 struct ath9k_channel {
 	struct ieee80211_channel *chan;
+	struct ar5416AniState ani;
 	u16 channel;
 	u32 channelFlags;
 	u32 chanmode;
@@ -752,8 +753,6 @@ struct ath_hw {
 	/* ANI */
 	u32 proc_phyerr;
 	u32 aniperiod;
-	struct ar5416AniState *curani;
-	struct ar5416AniState ani[255];
 	int totalSizeDesired[5];
 	int coarse_high[5];
 	int coarse_low[5];
-- 
1.7.2.2

