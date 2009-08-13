Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:52943 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709AbZHMEEK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 00:04:10 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2009 21:04:12 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19075.37065.768534.712283@gargle.gargle.HOWL>
Date: Thu, 13 Aug 2009 09:34:25 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/4] ath9k: Remove has_hw_phycounters
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PHY counters are available in all chipsets supported
by ath9k. Remove the check.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ani.c  |  195 +++++++++++++++------------------
 drivers/net/wireless/ath/ath9k/ani.h  |    1 -
 drivers/net/wireless/ath/ath9k/hw.h   |    1 -
 drivers/net/wireless/ath/ath9k/main.c |    3 +-
 4 files changed, 88 insertions(+), 112 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index b709312..f264097 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -236,36 +236,35 @@ static void ath9k_ani_restart(struct ath_hw *ah)
 		return;
 
 	aniState = ah->curani;
-
 	aniState->listenTime = 0;
-	if (ah->has_hw_phycounters) {
-		if (aniState->ofdmTrigHigh > AR_PHY_COUNTMAX) {
-			aniState->ofdmPhyErrBase = 0;
-			DPRINTF(ah->ah_sc, ATH_DBG_ANI,
-				"OFDM Trigger is too high for hw counters\n");
-		} else {
-			aniState->ofdmPhyErrBase =
-				AR_PHY_COUNTMAX - aniState->ofdmTrigHigh;
-		}
-		if (aniState->cckTrigHigh > AR_PHY_COUNTMAX) {
-			aniState->cckPhyErrBase = 0;
-			DPRINTF(ah->ah_sc, ATH_DBG_ANI,
-				"CCK Trigger is too high for hw counters\n");
-		} else {
-			aniState->cckPhyErrBase =
-				AR_PHY_COUNTMAX - aniState->cckTrigHigh;
-		}
+
+	if (aniState->ofdmTrigHigh > AR_PHY_COUNTMAX) {
+		aniState->ofdmPhyErrBase = 0;
 		DPRINTF(ah->ah_sc, ATH_DBG_ANI,
-			"Writing ofdmbase=%u   cckbase=%u\n",
-			aniState->ofdmPhyErrBase,
-			aniState->cckPhyErrBase);
-		REG_WRITE(ah, AR_PHY_ERR_1, aniState->ofdmPhyErrBase);
-		REG_WRITE(ah, AR_PHY_ERR_2, aniState->cckPhyErrBase);
-		REG_WRITE(ah, AR_PHY_ERR_MASK_1, AR_PHY_ERR_OFDM_TIMING);
-		REG_WRITE(ah, AR_PHY_ERR_MASK_2, AR_PHY_ERR_CCK_TIMING);
-
-		ath9k_hw_update_mibstats(ah, &ah->ah_mibStats);
+			"OFDM Trigger is too high for hw counters\n");
+	} else {
+		aniState->ofdmPhyErrBase =
+			AR_PHY_COUNTMAX - aniState->ofdmTrigHigh;
+	}
+	if (aniState->cckTrigHigh > AR_PHY_COUNTMAX) {
+		aniState->cckPhyErrBase = 0;
+		DPRINTF(ah->ah_sc, ATH_DBG_ANI,
+			"CCK Trigger is too high for hw counters\n");
+	} else {
+		aniState->cckPhyErrBase =
+			AR_PHY_COUNTMAX - aniState->cckTrigHigh;
 	}
+	DPRINTF(ah->ah_sc, ATH_DBG_ANI,
+		"Writing ofdmbase=%u   cckbase=%u\n",
+		aniState->ofdmPhyErrBase,
+		aniState->cckPhyErrBase);
+	REG_WRITE(ah, AR_PHY_ERR_1, aniState->ofdmPhyErrBase);
+	REG_WRITE(ah, AR_PHY_ERR_2, aniState->cckPhyErrBase);
+	REG_WRITE(ah, AR_PHY_ERR_MASK_1, AR_PHY_ERR_OFDM_TIMING);
+	REG_WRITE(ah, AR_PHY_ERR_MASK_2, AR_PHY_ERR_CCK_TIMING);
+
+	ath9k_hw_update_mibstats(ah, &ah->ah_mibStats);
+
 	aniState->ofdmPhyErrCount = 0;
 	aniState->cckPhyErrCount = 0;
 }
@@ -530,18 +529,12 @@ void ath9k_ani_reset(struct ath_hw *ah)
 	if (aniState->firstepLevel != 0)
 		ath9k_hw_ani_control(ah, ATH9K_ANI_FIRSTEP_LEVEL,
 				     aniState->firstepLevel);
-	if (ah->has_hw_phycounters) {
-		ath9k_hw_setrxfilter(ah, ath9k_hw_getrxfilter(ah) &
-				     ~ATH9K_RX_FILTER_PHYERR);
-		ath9k_ani_restart(ah);
-		REG_WRITE(ah, AR_PHY_ERR_MASK_1, AR_PHY_ERR_OFDM_TIMING);
-		REG_WRITE(ah, AR_PHY_ERR_MASK_2, AR_PHY_ERR_CCK_TIMING);
 
-	} else {
-		ath9k_ani_restart(ah);
-		ath9k_hw_setrxfilter(ah, ath9k_hw_getrxfilter(ah) |
-				     ATH9K_RX_FILTER_PHYERR);
-	}
+	ath9k_hw_setrxfilter(ah, ath9k_hw_getrxfilter(ah) &
+			     ~ATH9K_RX_FILTER_PHYERR);
+	ath9k_ani_restart(ah);
+	REG_WRITE(ah, AR_PHY_ERR_MASK_1, AR_PHY_ERR_OFDM_TIMING);
+	REG_WRITE(ah, AR_PHY_ERR_MASK_2, AR_PHY_ERR_CCK_TIMING);
 }
 
 void ath9k_hw_ani_monitor(struct ath_hw *ah,
@@ -550,6 +543,8 @@ void ath9k_hw_ani_monitor(struct ath_hw *ah,
 {
 	struct ar5416AniState *aniState;
 	int32_t listenTime;
+	u32 phyCnt1, phyCnt2;
+	u32 ofdmPhyErrCnt, cckPhyErrCnt;
 
 	if (!DO_ANI(ah))
 		return;
@@ -566,50 +561,45 @@ void ath9k_hw_ani_monitor(struct ath_hw *ah,
 
 	aniState->listenTime += listenTime;
 
-	if (ah->has_hw_phycounters) {
-		u32 phyCnt1, phyCnt2;
-		u32 ofdmPhyErrCnt, cckPhyErrCnt;
+	ath9k_hw_update_mibstats(ah, &ah->ah_mibStats);
 
-		ath9k_hw_update_mibstats(ah, &ah->ah_mibStats);
-
-		phyCnt1 = REG_READ(ah, AR_PHY_ERR_1);
-		phyCnt2 = REG_READ(ah, AR_PHY_ERR_2);
-
-		if (phyCnt1 < aniState->ofdmPhyErrBase ||
-		    phyCnt2 < aniState->cckPhyErrBase) {
-			if (phyCnt1 < aniState->ofdmPhyErrBase) {
-				DPRINTF(ah->ah_sc, ATH_DBG_ANI,
-					"phyCnt1 0x%x, resetting "
-					"counter value to 0x%x\n",
-					phyCnt1, aniState->ofdmPhyErrBase);
-				REG_WRITE(ah, AR_PHY_ERR_1,
-					  aniState->ofdmPhyErrBase);
-				REG_WRITE(ah, AR_PHY_ERR_MASK_1,
-					  AR_PHY_ERR_OFDM_TIMING);
-			}
-			if (phyCnt2 < aniState->cckPhyErrBase) {
-				DPRINTF(ah->ah_sc, ATH_DBG_ANI,
-					"phyCnt2 0x%x, resetting "
-					"counter value to 0x%x\n",
-					phyCnt2, aniState->cckPhyErrBase);
-				REG_WRITE(ah, AR_PHY_ERR_2,
-					  aniState->cckPhyErrBase);
-				REG_WRITE(ah, AR_PHY_ERR_MASK_2,
-					  AR_PHY_ERR_CCK_TIMING);
-			}
-			return;
+	phyCnt1 = REG_READ(ah, AR_PHY_ERR_1);
+	phyCnt2 = REG_READ(ah, AR_PHY_ERR_2);
+
+	if (phyCnt1 < aniState->ofdmPhyErrBase ||
+	    phyCnt2 < aniState->cckPhyErrBase) {
+		if (phyCnt1 < aniState->ofdmPhyErrBase) {
+			DPRINTF(ah->ah_sc, ATH_DBG_ANI,
+				"phyCnt1 0x%x, resetting "
+				"counter value to 0x%x\n",
+				phyCnt1, aniState->ofdmPhyErrBase);
+			REG_WRITE(ah, AR_PHY_ERR_1,
+				  aniState->ofdmPhyErrBase);
+			REG_WRITE(ah, AR_PHY_ERR_MASK_1,
+				  AR_PHY_ERR_OFDM_TIMING);
+		}
+		if (phyCnt2 < aniState->cckPhyErrBase) {
+			DPRINTF(ah->ah_sc, ATH_DBG_ANI,
+				"phyCnt2 0x%x, resetting "
+				"counter value to 0x%x\n",
+				phyCnt2, aniState->cckPhyErrBase);
+			REG_WRITE(ah, AR_PHY_ERR_2,
+				  aniState->cckPhyErrBase);
+			REG_WRITE(ah, AR_PHY_ERR_MASK_2,
+				  AR_PHY_ERR_CCK_TIMING);
 		}
+		return;
+	}
 
-		ofdmPhyErrCnt = phyCnt1 - aniState->ofdmPhyErrBase;
-		ah->stats.ast_ani_ofdmerrs +=
-			ofdmPhyErrCnt - aniState->ofdmPhyErrCount;
-		aniState->ofdmPhyErrCount = ofdmPhyErrCnt;
+	ofdmPhyErrCnt = phyCnt1 - aniState->ofdmPhyErrBase;
+	ah->stats.ast_ani_ofdmerrs +=
+		ofdmPhyErrCnt - aniState->ofdmPhyErrCount;
+	aniState->ofdmPhyErrCount = ofdmPhyErrCnt;
 
-		cckPhyErrCnt = phyCnt2 - aniState->cckPhyErrBase;
-		ah->stats.ast_ani_cckerrs +=
-			cckPhyErrCnt - aniState->cckPhyErrCount;
-		aniState->cckPhyErrCount = cckPhyErrCnt;
-	}
+	cckPhyErrCnt = phyCnt2 - aniState->cckPhyErrBase;
+	ah->stats.ast_ani_cckerrs +=
+		cckPhyErrCnt - aniState->cckPhyErrCount;
+	aniState->cckPhyErrCount = cckPhyErrCnt;
 
 	if (aniState->listenTime > 5 * ah->aniperiod) {
 		if (aniState->ofdmPhyErrCount <= aniState->listenTime *
@@ -632,11 +622,6 @@ void ath9k_hw_ani_monitor(struct ath_hw *ah,
 	}
 }
 
-bool ath9k_hw_phycounters(struct ath_hw *ah)
-{
-	return ah->has_hw_phycounters ? true : false;
-}
-
 void ath9k_enable_mib_counters(struct ath_hw *ah)
 {
 	DPRINTF(ah->ah_sc, ATH_DBG_ANI, "Enable MIB counters\n");
@@ -781,9 +766,7 @@ void ath9k_hw_ani_init(struct ath_hw *ah)
 {
 	int i;
 
-	DPRINTF(ah->ah_sc, ATH_DBG_ANI, "Attach ANI\n");
-
-	ah->has_hw_phycounters = 1;
+	DPRINTF(ah->ah_sc, ATH_DBG_ANI, "Initialize ANI\n");
 
 	memset(ah->ani, 0, sizeof(ah->ani));
 	for (i = 0; i < ARRAY_SIZE(ah->ani); i++) {
@@ -799,24 +782,22 @@ void ath9k_hw_ani_init(struct ath_hw *ah)
 			ATH9K_ANI_CCK_WEAK_SIG_THR;
 		ah->ani[i].spurImmunityLevel = ATH9K_ANI_SPUR_IMMUNE_LVL;
 		ah->ani[i].firstepLevel = ATH9K_ANI_FIRSTEP_LVL;
-		if (ah->has_hw_phycounters) {
-			ah->ani[i].ofdmPhyErrBase =
-				AR_PHY_COUNTMAX - ATH9K_ANI_OFDM_TRIG_HIGH;
-			ah->ani[i].cckPhyErrBase =
-				AR_PHY_COUNTMAX - ATH9K_ANI_CCK_TRIG_HIGH;
-		}
-	}
-	if (ah->has_hw_phycounters) {
-		DPRINTF(ah->ah_sc, ATH_DBG_ANI,
-			"Setting OfdmErrBase = 0x%08x\n",
-			ah->ani[0].ofdmPhyErrBase);
-		DPRINTF(ah->ah_sc, ATH_DBG_ANI, "Setting cckErrBase = 0x%08x\n",
-			ah->ani[0].cckPhyErrBase);
-
-		REG_WRITE(ah, AR_PHY_ERR_1, ah->ani[0].ofdmPhyErrBase);
-		REG_WRITE(ah, AR_PHY_ERR_2, ah->ani[0].cckPhyErrBase);
-		ath9k_enable_mib_counters(ah);
+		ah->ani[i].ofdmPhyErrBase =
+			AR_PHY_COUNTMAX - ATH9K_ANI_OFDM_TRIG_HIGH;
+		ah->ani[i].cckPhyErrBase =
+			AR_PHY_COUNTMAX - ATH9K_ANI_CCK_TRIG_HIGH;
 	}
+
+	DPRINTF(ah->ah_sc, ATH_DBG_ANI,
+		"Setting OfdmErrBase = 0x%08x\n",
+		ah->ani[0].ofdmPhyErrBase);
+	DPRINTF(ah->ah_sc, ATH_DBG_ANI, "Setting cckErrBase = 0x%08x\n",
+		ah->ani[0].cckPhyErrBase);
+
+	REG_WRITE(ah, AR_PHY_ERR_1, ah->ani[0].ofdmPhyErrBase);
+	REG_WRITE(ah, AR_PHY_ERR_2, ah->ani[0].cckPhyErrBase);
+	ath9k_enable_mib_counters(ah);
+
 	ah->aniperiod = ATH9K_ANI_PERIOD;
 	if (ah->config.enable_ani)
 		ah->proc_phyerr |= HAL_PROCESS_ANI;
@@ -826,9 +807,7 @@ void ath9k_hw_ani_disable(struct ath_hw *ah)
 {
 	DPRINTF(ah->ah_sc, ATH_DBG_ANI, "Disabling ANI\n");
 
-	if (ah->has_hw_phycounters) {
-		ath9k_hw_disable_mib_counters(ah);
-		REG_WRITE(ah, AR_PHY_ERR_1, 0);
-		REG_WRITE(ah, AR_PHY_ERR_2, 0);
-	}
+	ath9k_hw_disable_mib_counters(ah);
+	REG_WRITE(ah, AR_PHY_ERR_1, 0);
+	REG_WRITE(ah, AR_PHY_ERR_2, 0);
 }
diff --git a/drivers/net/wireless/ath/ath9k/ani.h b/drivers/net/wireless/ath/ath9k/ani.h
index a36b7bb..1199245 100644
--- a/drivers/net/wireless/ath/ath9k/ani.h
+++ b/drivers/net/wireless/ath/ath9k/ani.h
@@ -124,7 +124,6 @@ void ath9k_ani_reset(struct ath_hw *ah);
 void ath9k_hw_ani_monitor(struct ath_hw *ah,
 			  const struct ath9k_node_stats *stats,
 			  struct ath9k_channel *chan);
-bool ath9k_hw_phycounters(struct ath_hw *ah);
 void ath9k_enable_mib_counters(struct ath_hw *ah);
 void ath9k_hw_disable_mib_counters(struct ath_hw *ah);
 u32 ath9k_hw_GetMibCycleCountsPct(struct ath_hw *ah, u32 *rxc_pcnt,
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index e83e900..0e65873 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -507,7 +507,6 @@ struct ath_hw {
 
 	/* ANI */
 	u32 proc_phyerr;
-	bool has_hw_phycounters;
 	u32 aniperiod;
 	struct ar5416AniState *curani;
 	struct ar5416AniState ani[255];
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index efe2e85..4a6f2d2 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2214,8 +2214,7 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 	if ((conf->type == NL80211_IFTYPE_STATION) ||
 	    (conf->type == NL80211_IFTYPE_ADHOC) ||
 	    (conf->type == NL80211_IFTYPE_MESH_POINT)) {
-		if (ath9k_hw_phycounters(sc->sc_ah))
-			sc->imask |= ATH9K_INT_MIB;
+		sc->imask |= ATH9K_INT_MIB;
 		sc->imask |= ATH9K_INT_TSFOOR;
 	}
 
-- 
1.6.4

