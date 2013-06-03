Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:33545 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261Ab3FCDwU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Jun 2013 23:52:20 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 4/7] ath9k: Simplify ANI initialization
Date: Mon,  3 Jun 2013 09:19:26 +0530
Message-Id: <1370231369-16241-4-git-send-email-sujith@msujith.org> (sfid-20130603_055225_944739_A84144A5)
In-Reply-To: <1370231369-16241-1-git-send-email-sujith@msujith.org>
References: <1370231369-16241-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The check "enable_ani" is not required since it is always
set to true and the logic for disabling/enabling ANI via
debugfs is done at a higher layer.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ani.c          | 13 +++++--------
 drivers/net/wireless/ath/ath9k/ani.h          |  4 ----
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |  6 ++----
 drivers/net/wireless/ath/ath9k/hw.c           |  4 +---
 drivers/net/wireless/ath/ath9k/hw.h           |  2 --
 drivers/net/wireless/ath/ath9k/link.c         |  8 ++------
 6 files changed, 10 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index 7ecd40f..734e72d 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -118,7 +118,7 @@ static void ath9k_ani_restart(struct ath_hw *ah)
 {
 	struct ar5416AniState *aniState;
 
-	if (!DO_ANI(ah))
+	if (!ah->curchan)
 		return;
 
 	aniState = &ah->curchan->ani;
@@ -195,7 +195,7 @@ static void ath9k_hw_ani_ofdm_err_trigger(struct ath_hw *ah)
 {
 	struct ar5416AniState *aniState;
 
-	if (!DO_ANI(ah))
+	if (!ah->curchan)
 		return;
 
 	aniState = &ah->curchan->ani;
@@ -251,7 +251,7 @@ static void ath9k_hw_ani_cck_err_trigger(struct ath_hw *ah)
 {
 	struct ar5416AniState *aniState;
 
-	if (!DO_ANI(ah))
+	if (!ah->curchan)
 		return;
 
 	aniState = &ah->curchan->ani;
@@ -297,7 +297,7 @@ void ath9k_ani_reset(struct ath_hw *ah, bool is_scanning)
 	struct ath_common *common = ath9k_hw_common(ah);
 	int ofdm_nil, cck_nil;
 
-	if (!DO_ANI(ah))
+	if (!ah->curchan)
 		return;
 
 	BUG_ON(aniState == NULL);
@@ -415,7 +415,7 @@ void ath9k_hw_ani_monitor(struct ath_hw *ah, struct ath9k_channel *chan)
 	struct ath_common *common = ath9k_hw_common(ah);
 	u32 ofdmPhyErrRate, cckPhyErrRate;
 
-	if (!DO_ANI(ah))
+	if (!ah->curchan)
 		return;
 
 	aniState = &ah->curchan->ani;
@@ -524,9 +524,6 @@ void ath9k_hw_ani_init(struct ath_hw *ah)
 	ah->aniperiod = ATH9K_ANI_PERIOD;
 	ah->config.ani_poll_interval = ATH9K_ANI_POLLINTERVAL;
 
-	if (ah->config.enable_ani)
-		ah->proc_phyerr |= HAL_PROCESS_ANI;
-
 	ath9k_ani_restart(ah);
 	ath9k_enable_mib_counters(ah);
 }
diff --git a/drivers/net/wireless/ath/ath9k/ani.h b/drivers/net/wireless/ath/ath9k/ani.h
index dddb136..07079f2 100644
--- a/drivers/net/wireless/ath/ath9k/ani.h
+++ b/drivers/net/wireless/ath/ath9k/ani.h
@@ -17,10 +17,6 @@
 #ifndef ANI_H
 #define ANI_H
 
-#define HAL_PROCESS_ANI           0x00000001
-
-#define DO_ANI(ah) (((ah)->proc_phyerr & HAL_PROCESS_ANI) && ah->curchan)
-
 #define BEACON_RSSI(ahp) (ahp->stats.avgbrssi)
 
 /* units are errors per second */
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 2a67b57..34869c2 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -814,8 +814,7 @@ void ath9k_htc_ani_work(struct work_struct *work)
 	}
 
 	/* Verify whether we must check ANI */
-	if (ah->config.enable_ani &&
-	    (timestamp - common->ani.checkani_timer) >= ATH_ANI_POLLINTERVAL) {
+	if ((timestamp - common->ani.checkani_timer) >= ATH_ANI_POLLINTERVAL) {
 		aniflag = true;
 		common->ani.checkani_timer = timestamp;
 	}
@@ -845,8 +844,7 @@ set_timer:
 	* short calibration and long calibration.
 	*/
 	cal_interval = ATH_LONG_CALINTERVAL;
-	if (ah->config.enable_ani)
-		cal_interval = min(cal_interval, (u32)ATH_ANI_POLLINTERVAL);
+	cal_interval = min(cal_interval, (u32)ATH_ANI_POLLINTERVAL);
 	if (!common->ani.caldone)
 		cal_interval = min(cal_interval, (u32)short_cal_interval);
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index c71027c..d813ab8 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -452,7 +452,6 @@ static void ath9k_hw_init_config(struct ath_hw *ah)
 	ah->config.pcie_clock_req = 0;
 	ah->config.pcie_waen = 0;
 	ah->config.analog_shiftreg = 1;
-	ah->config.enable_ani = true;
 
 	for (i = 0; i < AR_EEPROM_MODAL_SPURS; i++) {
 		ah->config.spurchans[i][0] = AR_NO_SPUR;
@@ -549,8 +548,7 @@ static int ath9k_hw_post_init(struct ath_hw *ah)
 		ah->eep_ops->get_eeprom_ver(ah),
 		ah->eep_ops->get_eeprom_rev(ah));
 
-	if (ah->config.enable_ani)
-		ath9k_hw_ani_init(ah);
+	ath9k_hw_ani_init(ah);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index e3c3997..301b19e 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -289,7 +289,6 @@ struct ath9k_ops_config {
 	u32 ofdm_trig_high;
 	u32 cck_trig_high;
 	u32 cck_trig_low;
-	u32 enable_ani;
 	u32 enable_paprd;
 	int serialize_regmode;
 	bool rx_intr_mitigation;
@@ -852,7 +851,6 @@ struct ath_hw {
 	u32 globaltxtimeout;
 
 	/* ANI */
-	u32 proc_phyerr;
 	u32 aniperiod;
 	enum ath9k_ani_cmd ani_function;
 	u32 ani_skip_count;
diff --git a/drivers/net/wireless/ath/ath9k/link.c b/drivers/net/wireless/ath/ath9k/link.c
index cc422a4..fff5d3c 100644
--- a/drivers/net/wireless/ath/ath9k/link.c
+++ b/drivers/net/wireless/ath/ath9k/link.c
@@ -390,9 +390,7 @@ void ath_ani_calibrate(unsigned long data)
 	}
 
 	/* Verify whether we must check ANI */
-	if (sc->sc_ah->config.enable_ani
-	    && (timestamp - common->ani.checkani_timer) >=
-	    ah->config.ani_poll_interval) {
+	if ((timestamp - common->ani.checkani_timer) >= ah->config.ani_poll_interval) {
 		aniflag = true;
 		common->ani.checkani_timer = timestamp;
 	}
@@ -427,9 +425,7 @@ set_timer:
 	* short calibration and long calibration.
 	*/
 	cal_interval = ATH_LONG_CALINTERVAL;
-	if (sc->sc_ah->config.enable_ani)
-		cal_interval = min(cal_interval,
-				   (u32)ah->config.ani_poll_interval);
+	cal_interval = min(cal_interval, (u32)ah->config.ani_poll_interval);
 	if (!common->ani.caldone)
 		cal_interval = min(cal_interval, (u32)short_cal_interval);
 
-- 
1.8.3

