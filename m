Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:35394 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756746Ab0JDSJz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 14:09:55 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 4/5] ath9k_hw: remove function pointer abstraction for internal ANI ops
Date: Mon,  4 Oct 2010 20:09:49 +0200
Message-Id: <1286215790-67069-4-git-send-email-nbd@openwrt.org>
In-Reply-To: <1286215790-67069-3-git-send-email-nbd@openwrt.org>
References: <1286215790-67069-1-git-send-email-nbd@openwrt.org>
 <1286215790-67069-2-git-send-email-nbd@openwrt.org>
 <1286215790-67069-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The code gets more concise and readable when making the new ANI functions
fall back to the old ones if ANI v2 is disabled. This also makes further code
cleanup easier.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ani.c    |   58 +++++++++++++++----------------
 drivers/net/wireless/ath/ath9k/hw-ops.h |    5 ---
 drivers/net/wireless/ath/ath9k/hw.h     |   11 +-----
 3 files changed, 29 insertions(+), 45 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index d5c9df5..b959564 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -103,12 +103,6 @@ static const struct ani_cck_level_entry cck_level_table[] = {
 #define ATH9K_ANI_CCK_DEF_LEVEL \
 	2 /* default level - matches the INI settings */
 
-/* Private to ani.c */
-static void ath9k_hw_ani_lower_immunity(struct ath_hw *ah)
-{
-	ath9k_hw_private_ops(ah)->ani_lower_immunity(ah);
-}
-
 static bool use_new_ani(struct ath_hw *ah)
 {
 	return AR_SREV_9300_20_OR_LATER(ah) || modparam_force_new_ani;
@@ -165,9 +159,6 @@ static void ath9k_hw_ani_ofdm_err_trigger_old(struct ath_hw *ah)
 	struct ar5416AniState *aniState;
 	int32_t rssi;
 
-	if (!DO_ANI(ah))
-		return;
-
 	aniState = &ah->curchan->ani;
 
 	if (aniState->noiseImmunityLevel < HAL_NOISE_IMMUNE_MAX) {
@@ -237,9 +228,6 @@ static void ath9k_hw_ani_cck_err_trigger_old(struct ath_hw *ah)
 	struct ar5416AniState *aniState;
 	int32_t rssi;
 
-	if (!DO_ANI(ah))
-		return;
-
 	aniState = &ah->curchan->ani;
 	if (aniState->noiseImmunityLevel < HAL_NOISE_IMMUNE_MAX) {
 		if (ath9k_hw_ani_control(ah, ATH9K_ANI_NOISE_IMMUNITY_LEVEL,
@@ -317,13 +305,18 @@ static void ath9k_hw_set_ofdm_nil(struct ath_hw *ah, u8 immunityLevel)
 	}
 }
 
-static void ath9k_hw_ani_ofdm_err_trigger_new(struct ath_hw *ah)
+static void ath9k_hw_ani_ofdm_err_trigger(struct ath_hw *ah)
 {
 	struct ar5416AniState *aniState;
 
 	if (!DO_ANI(ah))
 		return;
 
+	if (!use_new_ani(ah)) {
+		ath9k_hw_ani_ofdm_err_trigger_old(ah);
+		return;
+	}
+
 	aniState = &ah->curchan->ani;
 
 	if (aniState->ofdmNoiseImmunityLevel < ATH9K_ANI_OFDM_MAX_LEVEL)
@@ -374,13 +367,18 @@ static void ath9k_hw_set_cck_nil(struct ath_hw *ah, u_int8_t immunityLevel)
 				     entry_cck->mrc_cck_on);
 }
 
-static void ath9k_hw_ani_cck_err_trigger_new(struct ath_hw *ah)
+static void ath9k_hw_ani_cck_err_trigger(struct ath_hw *ah)
 {
 	struct ar5416AniState *aniState;
 
 	if (!DO_ANI(ah))
 		return;
 
+	if (!use_new_ani(ah)) {
+		ath9k_hw_ani_cck_err_trigger_old(ah);
+		return;
+	}
+
 	aniState = &ah->curchan->ani;
 
 	if (aniState->cckNoiseImmunityLevel < ATH9K_ANI_CCK_MAX_LEVEL)
@@ -444,12 +442,17 @@ static void ath9k_hw_ani_lower_immunity_old(struct ath_hw *ah)
  * only lower either OFDM or CCK errors per turn
  * we lower the other one next time
  */
-static void ath9k_hw_ani_lower_immunity_new(struct ath_hw *ah)
+static void ath9k_hw_ani_lower_immunity(struct ath_hw *ah)
 {
 	struct ar5416AniState *aniState;
 
 	aniState = &ah->curchan->ani;
 
+	if (!use_new_ani(ah)) {
+		ath9k_hw_ani_lower_immunity_old(ah);
+		return;
+	}
+
 	/* lower OFDM noise immunity */
 	if (aniState->ofdmNoiseImmunityLevel > 0 &&
 	    (aniState->ofdmsTurn || aniState->cckNoiseImmunityLevel == 0)) {
@@ -573,7 +576,7 @@ static void ath9k_ani_reset_old(struct ath_hw *ah, bool is_scanning)
  * This routine should be called for every hardware reset and for
  * every channel change.
  */
-static void ath9k_ani_reset_new(struct ath_hw *ah, bool is_scanning)
+void ath9k_ani_reset(struct ath_hw *ah, bool is_scanning)
 {
 	struct ar5416AniState *aniState = &ah->curchan->ani;
 	struct ath9k_channel *chan = ah->curchan;
@@ -582,6 +585,9 @@ static void ath9k_ani_reset_new(struct ath_hw *ah, bool is_scanning)
 	if (!DO_ANI(ah))
 		return;
 
+	if (!use_new_ani(ah))
+		return ath9k_ani_reset_old(ah, is_scanning);
+
 	BUG_ON(aniState == NULL);
 	ah->stats.ast_ani_reset++;
 
@@ -745,12 +751,12 @@ static void ath9k_hw_ani_monitor_old(struct ath_hw *ah,
 	} else if (aniState->listenTime > ah->aniperiod) {
 		if (aniState->ofdmPhyErrCount > aniState->listenTime *
 		    ah->config.ofdm_trig_high / 1000) {
-			ath9k_hw_ani_ofdm_err_trigger_old(ah);
+			ath9k_hw_ani_ofdm_err_trigger(ah);
 			ath9k_ani_restart(ah);
 		} else if (aniState->cckPhyErrCount >
 			   aniState->listenTime * ah->config.cck_trig_high /
 			   1000) {
-			ath9k_hw_ani_cck_err_trigger_old(ah);
+			ath9k_hw_ani_cck_err_trigger(ah);
 			ath9k_ani_restart(ah);
 		}
 	}
@@ -814,23 +820,23 @@ static void ath9k_hw_ani_monitor_new(struct ath_hw *ah,
 		     aniState->ofdmsTurn)) {
 			ath_print(common, ATH_DBG_ANI,
 				  "2 listenTime=%d OFDM:%d errs=%d/s(>%d) -> "
-				  "ath9k_hw_ani_ofdm_err_trigger_new()\n",
+				  "ath9k_hw_ani_ofdm_err_trigger()\n",
 				  aniState->listenTime,
 				  aniState->ofdmNoiseImmunityLevel,
 				  ofdmPhyErrRate,
 				  ah->config.ofdm_trig_high);
-			ath9k_hw_ani_ofdm_err_trigger_new(ah);
+			ath9k_hw_ani_ofdm_err_trigger(ah);
 			ath9k_ani_restart(ah);
 			aniState->ofdmsTurn = false;
 		} else if (cckPhyErrRate > ah->config.cck_trig_high) {
 			ath_print(common, ATH_DBG_ANI,
 				 "3 listenTime=%d CCK:%d errs=%d/s(>%d) -> "
-				 "ath9k_hw_ani_cck_err_trigger_new()\n",
+				 "ath9k_hw_ani_cck_err_trigger()\n",
 				 aniState->listenTime,
 				 aniState->cckNoiseImmunityLevel,
 				 cckPhyErrRate,
 				 ah->config.cck_trig_high);
-			ath9k_hw_ani_cck_err_trigger_new(ah);
+			ath9k_hw_ani_cck_err_trigger(ah);
 			ath9k_ani_restart(ah);
 			aniState->ofdmsTurn = true;
 		}
@@ -1062,12 +1068,8 @@ void ath9k_hw_ani_init(struct ath_hw *ah)
 
 void ath9k_hw_attach_ani_ops_old(struct ath_hw *ah)
 {
-	struct ath_hw_private_ops *priv_ops = ath9k_hw_private_ops(ah);
 	struct ath_hw_ops *ops = ath9k_hw_ops(ah);
 
-	priv_ops->ani_reset = ath9k_ani_reset_old;
-	priv_ops->ani_lower_immunity = ath9k_hw_ani_lower_immunity_old;
-
 	ops->ani_monitor = ath9k_hw_ani_monitor_old;
 
 	ath_print(ath9k_hw_common(ah), ATH_DBG_ANY, "Using ANI v1\n");
@@ -1075,12 +1077,8 @@ void ath9k_hw_attach_ani_ops_old(struct ath_hw *ah)
 
 void ath9k_hw_attach_ani_ops_new(struct ath_hw *ah)
 {
-	struct ath_hw_private_ops *priv_ops = ath9k_hw_private_ops(ah);
 	struct ath_hw_ops *ops = ath9k_hw_ops(ah);
 
-	priv_ops->ani_reset = ath9k_ani_reset_new;
-	priv_ops->ani_lower_immunity = ath9k_hw_ani_lower_immunity_new;
-
 	ops->ani_monitor = ath9k_hw_ani_monitor_new;
 
 	ath_print(ath9k_hw_common(ah), ATH_DBG_ANY, "Using ANI v2\n");
diff --git a/drivers/net/wireless/ath/ath9k/hw-ops.h b/drivers/net/wireless/ath/ath9k/hw-ops.h
index f42c198..6564d1f 100644
--- a/drivers/net/wireless/ath/ath9k/hw-ops.h
+++ b/drivers/net/wireless/ath/ath9k/hw-ops.h
@@ -271,9 +271,4 @@ static inline void ath9k_hw_setup_calibration(struct ath_hw *ah,
 	ath9k_hw_private_ops(ah)->setup_calibration(ah, currCal);
 }
 
-static inline void ath9k_ani_reset(struct ath_hw *ah, bool is_scanning)
-{
-	ath9k_hw_private_ops(ah)->ani_reset(ah, is_scanning);
-}
-
 #endif /* ATH9K_HW_OPS_H */
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index a87840b..c982a24 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -509,14 +509,6 @@ struct ath_hw_antcomb_conf {
  * @setup_calibration: set up calibration
  * @iscal_supported: used to query if a type of calibration is supported
  *
- * @ani_reset: reset ANI parameters to default values
- * @ani_lower_immunity: lower the noise immunity level. The level controls
- *	the power-based packet detection on hardware. If a power jump is
- *	detected the adapter takes it as an indication that a packet has
- *	arrived. The level ranges from 0-5. Each level corresponds to a
- *	few dB more of noise immunity. If you have a strong time-varying
- *	interference that is causing false detections (OFDM timing errors or
- *	CCK timing errors) the level can be increased.
  * @ani_cache_ini_regs: cache the values for ANI from the initial
  *	register settings through the register initialization.
  */
@@ -561,8 +553,6 @@ struct ath_hw_private_ops {
 	void (*do_getnf)(struct ath_hw *ah, int16_t nfarray[NUM_NF_READINGS]);
 
 	/* ANI */
-	void (*ani_reset)(struct ath_hw *ah, bool is_scanning);
-	void (*ani_lower_immunity)(struct ath_hw *ah);
 	void (*ani_cache_ini_regs)(struct ath_hw *ah);
 };
 
@@ -977,6 +967,7 @@ void ar9002_hw_load_ani_reg(struct ath_hw *ah, struct ath9k_channel *chan);
  * older families (AR5008, AR9001, AR9002) by using modparam_force_new_ani.
  */
 extern int modparam_force_new_ani;
+void ath9k_ani_reset(struct ath_hw *ah, bool is_scanning);
 void ath9k_hw_proc_mib_event(struct ath_hw *ah);
 void ath9k_hw_attach_ani_ops_old(struct ath_hw *ah);
 void ath9k_hw_attach_ani_ops_new(struct ath_hw *ah);
-- 
1.7.2.2

