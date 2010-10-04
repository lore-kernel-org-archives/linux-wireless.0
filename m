Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:35392 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756748Ab0JDSJz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 14:09:55 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 5/5] ath9k_hw: merge ath9k_hw_ani_monitor_old and ath9k_hw_ani_monitor_new
Date: Mon,  4 Oct 2010 20:09:50 +0200
Message-Id: <1286215790-67069-5-git-send-email-nbd@openwrt.org>
In-Reply-To: <1286215790-67069-4-git-send-email-nbd@openwrt.org>
References: <1286215790-67069-1-git-send-email-nbd@openwrt.org>
 <1286215790-67069-2-git-send-email-nbd@openwrt.org>
 <1286215790-67069-3-git-send-email-nbd@openwrt.org>
 <1286215790-67069-4-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After the last rounds of cleanup, these functions are now functionally
equivalent and can thus be merged.
Also get rid of some excessive (and redundant) debug messages.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ani.c       |   83 +---------------------------
 drivers/net/wireless/ath/ath9k/ar9002_hw.c |    5 --
 drivers/net/wireless/ath/ath9k/ar9003_hw.c |    2 -
 drivers/net/wireless/ath/ath9k/hw-ops.h    |    6 --
 drivers/net/wireless/ath/ath9k/hw.h        |    8 +--
 5 files changed, 3 insertions(+), 101 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index b959564..f2a907b 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -730,40 +730,7 @@ static void ath9k_hw_ani_read_counters(struct ath_hw *ah)
 
 }
 
-static void ath9k_hw_ani_monitor_old(struct ath_hw *ah,
-				     struct ath9k_channel *chan)
-{
-	struct ar5416AniState *aniState;
-
-	if (!DO_ANI(ah))
-		return;
-
-	aniState = &ah->curchan->ani;
-	ath9k_hw_ani_read_counters(ah);
-
-	if (aniState->listenTime > 5 * ah->aniperiod) {
-		if (aniState->ofdmPhyErrCount <= aniState->listenTime *
-		    ah->config.ofdm_trig_low / 1000 &&
-		    aniState->cckPhyErrCount <= aniState->listenTime *
-		    ah->config.cck_trig_low / 1000)
-			ath9k_hw_ani_lower_immunity(ah);
-		ath9k_ani_restart(ah);
-	} else if (aniState->listenTime > ah->aniperiod) {
-		if (aniState->ofdmPhyErrCount > aniState->listenTime *
-		    ah->config.ofdm_trig_high / 1000) {
-			ath9k_hw_ani_ofdm_err_trigger(ah);
-			ath9k_ani_restart(ah);
-		} else if (aniState->cckPhyErrCount >
-			   aniState->listenTime * ah->config.cck_trig_high /
-			   1000) {
-			ath9k_hw_ani_cck_err_trigger(ah);
-			ath9k_ani_restart(ah);
-		}
-	}
-}
-
-static void ath9k_hw_ani_monitor_new(struct ath_hw *ah,
-				     struct ath9k_channel *chan)
+void ath9k_hw_ani_monitor(struct ath_hw *ah, struct ath9k_channel *chan)
 {
 	struct ar5416AniState *aniState;
 	struct ath_common *common = ath9k_hw_common(ah);
@@ -794,54 +761,26 @@ static void ath9k_hw_ani_monitor_new(struct ath_hw *ah,
 	if (aniState->listenTime > 5 * ah->aniperiod) {
 		if (ofdmPhyErrRate <= ah->config.ofdm_trig_low &&
 		    cckPhyErrRate <= ah->config.cck_trig_low) {
-			ath_print(common, ATH_DBG_ANI,
-				  "1. listenTime=%d OFDM:%d errs=%d/s(<%d)  "
-				  "CCK:%d errs=%d/s(<%d) -> "
-				  "ath9k_hw_ani_lower_immunity()\n",
-				  aniState->listenTime,
-				  aniState->ofdmNoiseImmunityLevel,
-				  ofdmPhyErrRate,
-				  ah->config.ofdm_trig_low,
-				  aniState->cckNoiseImmunityLevel,
-				  cckPhyErrRate,
-				  ah->config.cck_trig_low);
 			ath9k_hw_ani_lower_immunity(ah);
 			aniState->ofdmsTurn = !aniState->ofdmsTurn;
 		}
-		ath_print(common, ATH_DBG_ANI,
-			  "1 listenTime=%d ofdm=%d/s cck=%d/s - "
-			  "calling ath9k_ani_restart()\n",
-			  aniState->listenTime, ofdmPhyErrRate, cckPhyErrRate);
 		ath9k_ani_restart(ah);
 	} else if (aniState->listenTime > ah->aniperiod) {
 		/* check to see if need to raise immunity */
 		if (ofdmPhyErrRate > ah->config.ofdm_trig_high &&
 		    (cckPhyErrRate <= ah->config.cck_trig_high ||
 		     aniState->ofdmsTurn)) {
-			ath_print(common, ATH_DBG_ANI,
-				  "2 listenTime=%d OFDM:%d errs=%d/s(>%d) -> "
-				  "ath9k_hw_ani_ofdm_err_trigger()\n",
-				  aniState->listenTime,
-				  aniState->ofdmNoiseImmunityLevel,
-				  ofdmPhyErrRate,
-				  ah->config.ofdm_trig_high);
 			ath9k_hw_ani_ofdm_err_trigger(ah);
 			ath9k_ani_restart(ah);
 			aniState->ofdmsTurn = false;
 		} else if (cckPhyErrRate > ah->config.cck_trig_high) {
-			ath_print(common, ATH_DBG_ANI,
-				 "3 listenTime=%d CCK:%d errs=%d/s(>%d) -> "
-				 "ath9k_hw_ani_cck_err_trigger()\n",
-				 aniState->listenTime,
-				 aniState->cckNoiseImmunityLevel,
-				 cckPhyErrRate,
-				 ah->config.cck_trig_high);
 			ath9k_hw_ani_cck_err_trigger(ah);
 			ath9k_ani_restart(ah);
 			aniState->ofdmsTurn = true;
 		}
 	}
 }
+EXPORT_SYMBOL(ath9k_hw_ani_monitor);
 
 void ath9k_enable_mib_counters(struct ath_hw *ah)
 {
@@ -1065,21 +1004,3 @@ void ath9k_hw_ani_init(struct ath_hw *ah)
 	ath9k_ani_restart(ah);
 	ath9k_enable_mib_counters(ah);
 }
-
-void ath9k_hw_attach_ani_ops_old(struct ath_hw *ah)
-{
-	struct ath_hw_ops *ops = ath9k_hw_ops(ah);
-
-	ops->ani_monitor = ath9k_hw_ani_monitor_old;
-
-	ath_print(ath9k_hw_common(ah), ATH_DBG_ANY, "Using ANI v1\n");
-}
-
-void ath9k_hw_attach_ani_ops_new(struct ath_hw *ah)
-{
-	struct ath_hw_ops *ops = ath9k_hw_ops(ah);
-
-	ops->ani_monitor = ath9k_hw_ani_monitor_new;
-
-	ath_print(ath9k_hw_common(ah), ATH_DBG_ANY, "Using ANI v2\n");
-}
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_hw.c b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
index 78bdf0c..a0471f2 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
@@ -572,11 +572,6 @@ void ar9002_hw_attach_ops(struct ath_hw *ah)
 
 	ar9002_hw_attach_calib_ops(ah);
 	ar9002_hw_attach_mac_ops(ah);
-
-	if (modparam_force_new_ani)
-		ath9k_hw_attach_ani_ops_new(ah);
-	else
-		ath9k_hw_attach_ani_ops_old(ah);
 }
 
 void ar9002_hw_load_ani_reg(struct ath_hw *ah, struct ath9k_channel *chan)
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index 0641689..02c9708 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -333,6 +333,4 @@ void ar9003_hw_attach_ops(struct ath_hw *ah)
 	ar9003_hw_attach_phy_ops(ah);
 	ar9003_hw_attach_calib_ops(ah);
 	ar9003_hw_attach_mac_ops(ah);
-
-	ath9k_hw_attach_ani_ops_new(ah);
 }
diff --git a/drivers/net/wireless/ath/ath9k/hw-ops.h b/drivers/net/wireless/ath/ath9k/hw-ops.h
index 6564d1f..0a4ad34 100644
--- a/drivers/net/wireless/ath/ath9k/hw-ops.h
+++ b/drivers/net/wireless/ath/ath9k/hw-ops.h
@@ -128,12 +128,6 @@ static inline void ath9k_hw_set11n_virtualmorefrag(struct ath_hw *ah, void *ds,
 	ath9k_hw_ops(ah)->set11n_virtualmorefrag(ah, ds, vmf);
 }
 
-static inline void ath9k_hw_ani_monitor(struct ath_hw *ah,
-					struct ath9k_channel *chan)
-{
-	ath9k_hw_ops(ah)->ani_monitor(ah, chan);
-}
-
 /* Private hardware call ops */
 
 /* PHY ops */
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index c982a24..87627dd 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -564,9 +564,6 @@ struct ath_hw_private_ops {
  *
  * @config_pci_powersave:
  * @calibrate: periodic calibration for NF, ANI, IQ, ADC gain, ADC-DC
- *
- * @ani_monitor: called periodically by the core driver to collect
- *	MIB stats and adjust ANI if specific thresholds have been reached.
  */
 struct ath_hw_ops {
 	void (*config_pci_powersave)(struct ath_hw *ah,
@@ -607,8 +604,6 @@ struct ath_hw_ops {
 				     u32 burstDuration);
 	void (*set11n_virtualmorefrag)(struct ath_hw *ah, void *ds,
 				       u32 vmf);
-
-	void (*ani_monitor)(struct ath_hw *ah, struct ath9k_channel *chan);
 };
 
 struct ath_nf_limits {
@@ -969,8 +964,7 @@ void ar9002_hw_load_ani_reg(struct ath_hw *ah, struct ath9k_channel *chan);
 extern int modparam_force_new_ani;
 void ath9k_ani_reset(struct ath_hw *ah, bool is_scanning);
 void ath9k_hw_proc_mib_event(struct ath_hw *ah);
-void ath9k_hw_attach_ani_ops_old(struct ath_hw *ah);
-void ath9k_hw_attach_ani_ops_new(struct ath_hw *ah);
+void ath9k_hw_ani_monitor(struct ath_hw *ah, struct ath9k_channel *chan);
 
 #define ATH_PCIE_CAP_LINK_CTRL	0x70
 #define ATH_PCIE_CAP_LINK_L0S	1
-- 
1.7.2.2

