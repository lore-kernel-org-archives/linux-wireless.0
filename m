Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:35393 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756697Ab0JDSJz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 14:09:55 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 3/5] ath9k_hw: remove code duplication in phy error counter handling
Date: Mon,  4 Oct 2010 20:09:48 +0200
Message-Id: <1286215790-67069-3-git-send-email-nbd@openwrt.org>
In-Reply-To: <1286215790-67069-2-git-send-email-nbd@openwrt.org>
References: <1286215790-67069-1-git-send-email-nbd@openwrt.org>
 <1286215790-67069-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Split out the PHY error counter update from ath9k_hw_ani_monitor_*, reuse
it in ath9k_hw_proc_mib_event (merged from ath9k_hw_proc_mib_event_old
and ath9k_hw_proc_mib_event_new).

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ani.c    |  142 +++++++------------------------
 drivers/net/wireless/ath/ath9k/hw-ops.h |    5 -
 drivers/net/wireless/ath/ath9k/hw.h     |    4 +-
 drivers/net/wireless/ath/ath9k/main.c   |    2 +-
 4 files changed, 34 insertions(+), 119 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index 6bae601..d5c9df5 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -661,21 +661,15 @@ static void ath9k_ani_reset_new(struct ath_hw *ah, bool is_scanning)
 	REGWRITE_BUFFER_FLUSH(ah);
 }
 
-static void ath9k_hw_ani_monitor_old(struct ath_hw *ah,
-				     struct ath9k_channel *chan)
+static void ath9k_hw_ani_read_counters(struct ath_hw *ah)
 {
-	struct ar5416AniState *aniState;
 	struct ath_common *common = ath9k_hw_common(ah);
-	int32_t listenTime;
-	u32 phyCnt1, phyCnt2;
+	struct ar5416AniState *aniState = &ah->curchan->ani;
+	u32 ofdm_base = 0;
+	u32 cck_base = 0;
 	u32 ofdmPhyErrCnt, cckPhyErrCnt;
-	u32 ofdm_base = AR_PHY_COUNTMAX - ah->config.ofdm_trig_high;
-	u32 cck_base = AR_PHY_COUNTMAX - ah->config.cck_trig_high;
-
-	if (!DO_ANI(ah))
-		return;
-
-	aniState = &ah->curchan->ani;
+	u32 phyCnt1, phyCnt2;
+	int32_t listenTime;
 
 	listenTime = ath9k_hw_ani_get_listen_time(ah);
 	if (listenTime < 0) {
@@ -684,6 +678,11 @@ static void ath9k_hw_ani_monitor_old(struct ath_hw *ah,
 		return;
 	}
 
+	if (!use_new_ani(ah)) {
+		ofdm_base = AR_PHY_COUNTMAX - ah->config.ofdm_trig_high;
+		cck_base = AR_PHY_COUNTMAX - ah->config.cck_trig_high;
+	}
+
 	aniState->listenTime += listenTime;
 
 	ath9k_hw_update_mibstats(ah, &ah->ah_mibStats);
@@ -691,7 +690,7 @@ static void ath9k_hw_ani_monitor_old(struct ath_hw *ah,
 	phyCnt1 = REG_READ(ah, AR_PHY_ERR_1);
 	phyCnt2 = REG_READ(ah, AR_PHY_ERR_2);
 
-	if (phyCnt1 < ofdm_base || phyCnt2 < cck_base) {
+	if (use_new_ani(ah) && (phyCnt1 < ofdm_base || phyCnt2 < cck_base)) {
 		if (phyCnt1 < ofdm_base) {
 			ath_print(common, ATH_DBG_ANI,
 				  "phyCnt1 0x%x, resetting "
@@ -723,6 +722,19 @@ static void ath9k_hw_ani_monitor_old(struct ath_hw *ah,
 		cckPhyErrCnt - aniState->cckPhyErrCount;
 	aniState->cckPhyErrCount = cckPhyErrCnt;
 
+}
+
+static void ath9k_hw_ani_monitor_old(struct ath_hw *ah,
+				     struct ath9k_channel *chan)
+{
+	struct ar5416AniState *aniState;
+
+	if (!DO_ANI(ah))
+		return;
+
+	aniState = &ah->curchan->ani;
+	ath9k_hw_ani_read_counters(ah);
+
 	if (aniState->listenTime > 5 * ah->aniperiod) {
 		if (aniState->ofdmPhyErrCount <= aniState->listenTime *
 		    ah->config.ofdm_trig_low / 1000 &&
@@ -749,8 +761,6 @@ static void ath9k_hw_ani_monitor_new(struct ath_hw *ah,
 {
 	struct ar5416AniState *aniState;
 	struct ath_common *common = ath9k_hw_common(ah);
-	int32_t listenTime;
-	u32 ofdmPhyErrCnt, cckPhyErrCnt;
 	u32 ofdmPhyErrRate, cckPhyErrRate;
 
 	if (!DO_ANI(ah))
@@ -760,35 +770,7 @@ static void ath9k_hw_ani_monitor_new(struct ath_hw *ah,
 	if (WARN_ON(!aniState))
 		return;
 
-	listenTime = ath9k_hw_ani_get_listen_time(ah);
-	if (listenTime <= 0) {
-		ah->stats.ast_ani_lneg++;
-		/* restart ANI period if listenTime is invalid */
-		ath_print(common, ATH_DBG_ANI,
-			  "listenTime=%d - on new ani monitor\n",
-			  listenTime);
-		ath9k_ani_restart(ah);
-		return;
-	}
-
-	aniState->listenTime += listenTime;
-
-	ath9k_hw_update_mibstats(ah, &ah->ah_mibStats);
-
-	ofdmPhyErrCnt = REG_READ(ah, AR_PHY_ERR_1);
-	cckPhyErrCnt = REG_READ(ah, AR_PHY_ERR_2);
-
-	ah->stats.ast_ani_ofdmerrs +=
-		ofdmPhyErrCnt - aniState->ofdmPhyErrCount;
-	aniState->ofdmPhyErrCount = ofdmPhyErrCnt;
-
-	ah->stats.ast_ani_cckerrs +=
-		cckPhyErrCnt - aniState->cckPhyErrCount;
-	aniState->cckPhyErrCount = cckPhyErrCnt;
-
-	ath_print(common, ATH_DBG_ANI,
-		  "Errors: OFDM=%d, CCK=%d\n",
-		  ofdmPhyErrCnt, cckPhyErrCnt);
+	ath9k_hw_ani_read_counters(ah);
 
 	ofdmPhyErrRate = aniState->ofdmPhyErrCount * 1000 /
 			 aniState->listenTime;
@@ -798,7 +780,8 @@ static void ath9k_hw_ani_monitor_new(struct ath_hw *ah,
 	ath_print(common, ATH_DBG_ANI,
 		  "listenTime=%d OFDM:%d errs=%d/s CCK:%d "
 		  "errs=%d/s ofdm_turn=%d\n",
-		  listenTime, aniState->ofdmNoiseImmunityLevel,
+		  aniState->listenTime,
+		  aniState->ofdmNoiseImmunityLevel,
 		  ofdmPhyErrRate, aniState->cckNoiseImmunityLevel,
 		  cckPhyErrRate, aniState->ofdmsTurn);
 
@@ -943,10 +926,8 @@ skip:
  * any of the MIB counters overflow/trigger so don't assume we're
  * here because a PHY error counter triggered.
  */
-static void ath9k_hw_proc_mib_event_old(struct ath_hw *ah)
+void ath9k_hw_proc_mib_event(struct ath_hw *ah)
 {
-	u32 ofdm_base = AR_PHY_COUNTMAX - ah->config.ofdm_trig_high;
-	u32 cck_base = AR_PHY_COUNTMAX - ah->config.cck_trig_high;
 	u32 phyCnt1, phyCnt2;
 
 	/* Reset these counters regardless */
@@ -973,72 +954,15 @@ static void ath9k_hw_proc_mib_event_old(struct ath_hw *ah)
 	phyCnt2 = REG_READ(ah, AR_PHY_ERR_2);
 	if (((phyCnt1 & AR_MIBCNT_INTRMASK) == AR_MIBCNT_INTRMASK) ||
 	    ((phyCnt2 & AR_MIBCNT_INTRMASK) == AR_MIBCNT_INTRMASK)) {
-		struct ar5416AniState *aniState = &ah->curchan->ani;
-		u32 ofdmPhyErrCnt, cckPhyErrCnt;
-
-		/* NB: only use ast_ani_*errs with AH_PRIVATE_DIAG */
-		ofdmPhyErrCnt = phyCnt1 - ofdm_base;
-		ah->stats.ast_ani_ofdmerrs +=
-			ofdmPhyErrCnt - aniState->ofdmPhyErrCount;
-		aniState->ofdmPhyErrCount = ofdmPhyErrCnt;
 
-		cckPhyErrCnt = phyCnt2 - cck_base;
-		ah->stats.ast_ani_cckerrs +=
-			cckPhyErrCnt - aniState->cckPhyErrCount;
-		aniState->cckPhyErrCount = cckPhyErrCnt;
+		if (!use_new_ani(ah))
+			ath9k_hw_ani_read_counters(ah);
 
-		/*
-		 * NB: figure out which counter triggered.  If both
-		 * trigger we'll only deal with one as the processing
-		 * clobbers the error counter so the trigger threshold
-		 * check will never be true.
-		 */
-		if (aniState->ofdmPhyErrCount > ah->config.ofdm_trig_high)
-			ath9k_hw_ani_ofdm_err_trigger_new(ah);
-		if (aniState->cckPhyErrCount > ah->config.cck_trig_high)
-			ath9k_hw_ani_cck_err_trigger_old(ah);
 		/* NB: always restart to insure the h/w counters are reset */
 		ath9k_ani_restart(ah);
 	}
 }
-
-/*
- * Process a MIB interrupt.  We may potentially be invoked because
- * any of the MIB counters overflow/trigger so don't assume we're
- * here because a PHY error counter triggered.
- */
-static void ath9k_hw_proc_mib_event_new(struct ath_hw *ah)
-{
-	u32 phyCnt1, phyCnt2;
-
-	/* Reset these counters regardless */
-	REG_WRITE(ah, AR_FILT_OFDM, 0);
-	REG_WRITE(ah, AR_FILT_CCK, 0);
-	if (!(REG_READ(ah, AR_SLP_MIB_CTRL) & AR_SLP_MIB_PENDING))
-		REG_WRITE(ah, AR_SLP_MIB_CTRL, AR_SLP_MIB_CLEAR);
-
-	/* Clear the mib counters and save them in the stats */
-	ath9k_hw_update_mibstats(ah, &ah->ah_mibStats);
-
-	if (!DO_ANI(ah)) {
-		/*
-		 * We must always clear the interrupt cause by
-		 * resetting the phy error regs.
-		 */
-		REG_WRITE(ah, AR_PHY_ERR_1, 0);
-		REG_WRITE(ah, AR_PHY_ERR_2, 0);
-		return;
-	}
-
-	/* NB: these are not reset-on-read */
-	phyCnt1 = REG_READ(ah, AR_PHY_ERR_1);
-	phyCnt2 = REG_READ(ah, AR_PHY_ERR_2);
-
-	/* NB: always restart to insure the h/w counters are reset */
-	if (((phyCnt1 & AR_MIBCNT_INTRMASK) == AR_MIBCNT_INTRMASK) ||
-	    ((phyCnt2 & AR_MIBCNT_INTRMASK) == AR_MIBCNT_INTRMASK))
-		ath9k_ani_restart(ah);
-}
+EXPORT_SYMBOL(ath9k_hw_proc_mib_event);
 
 void ath9k_hw_ani_setup(struct ath_hw *ah)
 {
@@ -1144,7 +1068,6 @@ void ath9k_hw_attach_ani_ops_old(struct ath_hw *ah)
 	priv_ops->ani_reset = ath9k_ani_reset_old;
 	priv_ops->ani_lower_immunity = ath9k_hw_ani_lower_immunity_old;
 
-	ops->ani_proc_mib_event = ath9k_hw_proc_mib_event_old;
 	ops->ani_monitor = ath9k_hw_ani_monitor_old;
 
 	ath_print(ath9k_hw_common(ah), ATH_DBG_ANY, "Using ANI v1\n");
@@ -1158,7 +1081,6 @@ void ath9k_hw_attach_ani_ops_new(struct ath_hw *ah)
 	priv_ops->ani_reset = ath9k_ani_reset_new;
 	priv_ops->ani_lower_immunity = ath9k_hw_ani_lower_immunity_new;
 
-	ops->ani_proc_mib_event = ath9k_hw_proc_mib_event_new;
 	ops->ani_monitor = ath9k_hw_ani_monitor_new;
 
 	ath_print(ath9k_hw_common(ah), ATH_DBG_ANY, "Using ANI v2\n");
diff --git a/drivers/net/wireless/ath/ath9k/hw-ops.h b/drivers/net/wireless/ath/ath9k/hw-ops.h
index 9c4dd0e..f42c198 100644
--- a/drivers/net/wireless/ath/ath9k/hw-ops.h
+++ b/drivers/net/wireless/ath/ath9k/hw-ops.h
@@ -128,11 +128,6 @@ static inline void ath9k_hw_set11n_virtualmorefrag(struct ath_hw *ah, void *ds,
 	ath9k_hw_ops(ah)->set11n_virtualmorefrag(ah, ds, vmf);
 }
 
-static inline void ath9k_hw_procmibevent(struct ath_hw *ah)
-{
-	ath9k_hw_ops(ah)->ani_proc_mib_event(ah);
-}
-
 static inline void ath9k_hw_ani_monitor(struct ath_hw *ah,
 					struct ath9k_channel *chan)
 {
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 5063463..a87840b 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -575,8 +575,6 @@ struct ath_hw_private_ops {
  * @config_pci_powersave:
  * @calibrate: periodic calibration for NF, ANI, IQ, ADC gain, ADC-DC
  *
- * @ani_proc_mib_event: process MIB events, this would happen upon specific ANI
- *	thresholds being reached or having overflowed.
  * @ani_monitor: called periodically by the core driver to collect
  *	MIB stats and adjust ANI if specific thresholds have been reached.
  */
@@ -620,7 +618,6 @@ struct ath_hw_ops {
 	void (*set11n_virtualmorefrag)(struct ath_hw *ah, void *ds,
 				       u32 vmf);
 
-	void (*ani_proc_mib_event)(struct ath_hw *ah);
 	void (*ani_monitor)(struct ath_hw *ah, struct ath9k_channel *chan);
 };
 
@@ -980,6 +977,7 @@ void ar9002_hw_load_ani_reg(struct ath_hw *ah, struct ath9k_channel *chan);
  * older families (AR5008, AR9001, AR9002) by using modparam_force_new_ani.
  */
 extern int modparam_force_new_ani;
+void ath9k_hw_proc_mib_event(struct ath_hw *ah);
 void ath9k_hw_attach_ani_ops_old(struct ath_hw *ah);
 void ath9k_hw_attach_ani_ops_new(struct ath_hw *ah);
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 49ea458..d79f78d 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -713,7 +713,7 @@ irqreturn_t ath_isr(int irq, void *dev)
 		 * it will clear whatever condition caused
 		 * the interrupt.
 		 */
-		ath9k_hw_procmibevent(ah);
+		ath9k_hw_proc_mib_event(ah);
 		ath9k_hw_set_interrupts(ah, ah->imask);
 	}
 
-- 
1.7.2.2

