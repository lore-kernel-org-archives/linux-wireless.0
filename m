Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:21115 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932564Ab0JEJzW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 05:55:22 -0400
Received: from vs3000.wh2.ocn.ne.jp (125.206.180.163)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 1-0738792519
	for <linux-wireless@vger.kernel.org>; Tue,  5 Oct 2010 18:55:20 +0900 (JST)
Subject: [PATCH 3/5] ath9k: Use common cycle counters
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: nbd@openwrt.org, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, adrian@freebsd.org,
	vasanth@atheros.com
Date: Tue, 05 Oct 2010 18:55:21 +0900
Message-ID: <20101005095521.3083.87663.stgit@tt-desk>
In-Reply-To: <20101005095510.3083.46174.stgit@tt-desk>
References: <20101005095510.3083.46174.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update ath9k to use the common cycle counters.

This also includes other changes from Felix Fietkaus "[PATCH 2/4] ath9k_hw:
merge codepaths that access the cycle counter registers".

Compile tested only. ath9k team please review...

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath9k/ani.c        |   87 +++------------------------
 drivers/net/wireless/ath/ath9k/ani.h        |    6 --
 drivers/net/wireless/ath/ath9k/ar5008_phy.c |    9 +--
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |   18 +++---
 4 files changed, 22 insertions(+), 98 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index 0496f96..0c0d01d 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -549,47 +549,21 @@ static u8 ath9k_hw_chan_2_clockrate_mhz(struct ath_hw *ah)
 
 static int32_t ath9k_hw_ani_get_listen_time(struct ath_hw *ah)
 {
-	struct ar5416AniState *aniState;
 	struct ath_common *common = ath9k_hw_common(ah);
-	u32 txFrameCount, rxFrameCount, cycleCount;
-	int32_t listenTime;
+	int32_t listen_time;
+	int32_t clock_rate;
 
-	txFrameCount = REG_READ(ah, AR_TFCNT);
-	rxFrameCount = REG_READ(ah, AR_RFCNT);
-	cycleCount = REG_READ(ah, AR_CCCNT);
+	ath_hw_cycle_counters_lock(common);
+	ath_hw_cycle_counters_update(common);
 
-	aniState = ah->curani;
-	if (aniState->cycleCount == 0 || aniState->cycleCount > cycleCount) {
-		listenTime = 0;
-		ah->stats.ast_ani_lzero++;
-		ath_print(common, ATH_DBG_ANI,
-			  "1st call: aniState->cycleCount=%d\n",
-			  aniState->cycleCount);
-	} else {
-		int32_t ccdelta = cycleCount - aniState->cycleCount;
-		int32_t rfdelta = rxFrameCount - aniState->rxFrameCount;
-		int32_t tfdelta = txFrameCount - aniState->txFrameCount;
-		int32_t clock_rate;
+	clock_rate = ath9k_hw_chan_2_clockrate_mhz(ah) * 1000;
+	listen_time = (common->cc_ani.cycles - common->cc_ani.rx_frame -
+			common->cc_ani.tx_frame) / clock_rate;
 
-		/*
-		 * convert HW counter values to ms using mode
-		 * specifix clock rate
-		 */
-		clock_rate = ath9k_hw_chan_2_clockrate_mhz(ah) * 1000;;
+	memset(&common->cc_ani, 0, sizeof(struct ath_cycle_counters));
+	ath_hw_cycle_counters_unlock(common);
 
-		listenTime = (ccdelta - rfdelta - tfdelta) / clock_rate;
-
-		ath_print(common, ATH_DBG_ANI,
-			  "cyclecount=%d, rfcount=%d, "
-			  "tfcount=%d, listenTime=%d CLOCK_RATE=%d\n",
-			  ccdelta, rfdelta, tfdelta, listenTime, clock_rate);
-	}
-
-	aniState->cycleCount = cycleCount;
-	aniState->txFrameCount = txFrameCount;
-	aniState->rxFrameCount = rxFrameCount;
-
-	return listenTime;
+	return listen_time;
 }
 
 static void ath9k_ani_reset_old(struct ath_hw *ah, bool is_scanning)
@@ -1041,47 +1015,6 @@ void ath9k_hw_disable_mib_counters(struct ath_hw *ah)
 }
 EXPORT_SYMBOL(ath9k_hw_disable_mib_counters);
 
-u32 ath9k_hw_GetMibCycleCountsPct(struct ath_hw *ah,
-				  u32 *rxc_pcnt,
-				  u32 *rxf_pcnt,
-				  u32 *txf_pcnt)
-{
-	struct ath_common *common = ath9k_hw_common(ah);
-	static u32 cycles, rx_clear, rx_frame, tx_frame;
-	u32 good = 1;
-
-	u32 rc = REG_READ(ah, AR_RCCNT);
-	u32 rf = REG_READ(ah, AR_RFCNT);
-	u32 tf = REG_READ(ah, AR_TFCNT);
-	u32 cc = REG_READ(ah, AR_CCCNT);
-
-	if (cycles == 0 || cycles > cc) {
-		ath_print(common, ATH_DBG_ANI,
-			  "cycle counter wrap. ExtBusy = 0\n");
-		good = 0;
-	} else {
-		u32 cc_d = cc - cycles;
-		u32 rc_d = rc - rx_clear;
-		u32 rf_d = rf - rx_frame;
-		u32 tf_d = tf - tx_frame;
-
-		if (cc_d != 0) {
-			*rxc_pcnt = rc_d * 100 / cc_d;
-			*rxf_pcnt = rf_d * 100 / cc_d;
-			*txf_pcnt = tf_d * 100 / cc_d;
-		} else {
-			good = 0;
-		}
-	}
-
-	cycles = cc;
-	rx_frame = rf;
-	rx_clear = rc;
-	tx_frame = tf;
-
-	return good;
-}
-
 /*
  * Process a MIB interrupt.  We may potentially be invoked because
  * any of the MIB counters overflow/trigger so don't assume we're
diff --git a/drivers/net/wireless/ath/ath9k/ani.h b/drivers/net/wireless/ath/ath9k/ani.h
index f4d0a4d..41f1d63 100644
--- a/drivers/net/wireless/ath/ath9k/ani.h
+++ b/drivers/net/wireless/ath/ath9k/ani.h
@@ -130,9 +130,6 @@ struct ar5416AniState {
 	int32_t rssiThrLow;
 	int32_t rssiThrHigh;
 	u32 noiseFloor;
-	u32 txFrameCount;
-	u32 rxFrameCount;
-	u32 cycleCount;
 	u32 ofdmPhyErrCount;
 	u32 cckPhyErrCount;
 	u32 ofdmPhyErrBase;
@@ -166,8 +163,7 @@ struct ar5416Stats {
 
 void ath9k_enable_mib_counters(struct ath_hw *ah);
 void ath9k_hw_disable_mib_counters(struct ath_hw *ah);
-u32 ath9k_hw_GetMibCycleCountsPct(struct ath_hw *ah, u32 *rxc_pcnt,
-				  u32 *rxf_pcnt, u32 *txf_pcnt);
+void ath9k_hw_update_cycle_counters(struct ath_hw *ah);
 void ath9k_hw_ani_setup(struct ath_hw *ah);
 void ath9k_hw_ani_init(struct ath_hw *ah);
 int ath9k_hw_get_ani_channel_idx(struct ath_hw *ah,
diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index 3937cfd..74b4213 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -1227,8 +1227,7 @@ static bool ar5008_hw_ani_control_old(struct ath_hw *ah,
 		  aniState->firstepLevel,
 		  aniState->listenTime);
 	ath_print(common, ATH_DBG_ANI,
-		"cycleCount=%d, ofdmPhyErrCount=%d, cckPhyErrCount=%d\n\n",
-		aniState->cycleCount,
+		"ofdmPhyErrCount=%d, cckPhyErrCount=%d\n\n",
 		aniState->ofdmPhyErrCount,
 		aniState->cckPhyErrCount);
 
@@ -1480,15 +1479,13 @@ static bool ar5008_hw_ani_control_new(struct ath_hw *ah,
 
 	ath_print(common, ATH_DBG_ANI,
 		  "ANI parameters: SI=%d, ofdmWS=%s FS=%d "
-		  "MRCcck=%s listenTime=%d CC=%d listen=%d "
+		  "MRCcck=%s listenTime=%d "
 		  "ofdmErrs=%d cckErrs=%d\n",
 		  aniState->spurImmunityLevel,
 		  !aniState->ofdmWeakSigDetectOff ? "on" : "off",
 		  aniState->firstepLevel,
 		  !aniState->mrcCCKOff ? "on" : "off",
 		  aniState->listenTime,
-		  aniState->cycleCount,
-		  aniState->listenTime,
 		  aniState->ofdmPhyErrCount,
 		  aniState->cckPhyErrCount);
 	return true;
@@ -1581,8 +1578,6 @@ static void ar5008_hw_ani_cache_ini_regs(struct ath_hw *ah)
 	aniState->firstepLevel = ATH9K_ANI_FIRSTEP_LVL_NEW;
 	aniState->ofdmWeakSigDetectOff = !ATH9K_ANI_USE_OFDM_WEAK_SIG;
 	aniState->mrcCCKOff = true; /* not available on pre AR9003 */
-
-	aniState->cycleCount = 0;
 }
 
 static void ar5008_hw_set_nf_limits(struct ath_hw *ah)
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index a491854..68ef986 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1005,15 +1005,13 @@ static bool ar9003_hw_ani_control(struct ath_hw *ah,
 
 	ath_print(common, ATH_DBG_ANI,
 		  "ANI parameters: SI=%d, ofdmWS=%s FS=%d "
-		  "MRCcck=%s listenTime=%d CC=%d listen=%d "
+		  "MRCcck=%s listenTime=%d "
 		  "ofdmErrs=%d cckErrs=%d\n",
 		  aniState->spurImmunityLevel,
 		  !aniState->ofdmWeakSigDetectOff ? "on" : "off",
 		  aniState->firstepLevel,
 		  !aniState->mrcCCKOff ? "on" : "off",
 		  aniState->listenTime,
-		  aniState->cycleCount,
-		  aniState->listenTime,
 		  aniState->ofdmPhyErrCount,
 		  aniState->cckPhyErrCount);
 	return true;
@@ -1116,8 +1114,6 @@ static void ar9003_hw_ani_cache_ini_regs(struct ath_hw *ah)
 	aniState->firstepLevel = ATH9K_ANI_FIRSTEP_LVL_NEW;
 	aniState->ofdmWeakSigDetectOff = !ATH9K_ANI_USE_OFDM_WEAK_SIG;
 	aniState->mrcCCKOff = !ATH9K_ANI_ENABLE_MRC_CCK;
-
-	aniState->cycleCount = 0;
 }
 
 void ar9003_hw_attach_phy_ops(struct ath_hw *ah)
@@ -1232,7 +1228,7 @@ void ar9003_hw_bb_watchdog_read(struct ath_hw *ah)
 void ar9003_hw_bb_watchdog_dbg_info(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
-	u32 rxc_pcnt = 0, rxf_pcnt = 0, txf_pcnt = 0, status;
+	u32 status;
 
 	if (likely(!(common->debug_mask & ATH_DBG_RESET)))
 		return;
@@ -1261,11 +1257,15 @@ void ar9003_hw_bb_watchdog_dbg_info(struct ath_hw *ah)
 		  "** BB mode: BB_gen_controls=0x%08x **\n",
 		  REG_READ(ah, AR_PHY_GEN_CTRL));
 
-	if (ath9k_hw_GetMibCycleCountsPct(ah, &rxc_pcnt, &rxf_pcnt, &txf_pcnt))
+	ath_hw_cycle_counters_lock(common);
+	ath_hw_cycle_counters_update(common);
+#define PCT(_field) (common->cc_survey._field * 100 / common->cc_survey.cycles)
+	if (common->cc_survey.cycles)
 		ath_print(common, ATH_DBG_RESET,
-			  "** BB busy times: rx_clear=%d%%, "
+			  "** BB busy times: rx_busy=%d%%, "
 			  "rx_frame=%d%%, tx_frame=%d%% **\n",
-			  rxc_pcnt, rxf_pcnt, txf_pcnt);
+			  PCT(rx_busy), PCT(rx_frame), PCT(tx_frame));
+	ath_hw_cycle_counters_unlock(common);
 
 	ath_print(common, ATH_DBG_RESET,
 		  "==== BB update: done ====\n\n");

