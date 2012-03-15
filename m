Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35521 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030189Ab2COAD6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Mar 2012 20:03:58 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Paul Stewart <pstew@google.com>,
	Susinder Gulasekaran <susinder@qca.qualcomm.com>,
	Suresh Chandrasekaran <csuresh@qca.qualcomm.com>
Subject: [PATCH RESEND v2 1/2] ath9k_hw: improve ANI processing and rx desensitizing parameters
Date: Thu, 15 Mar 2012 05:34:26 +0530
Message-ID: <1331769867-19088-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120315_010401_599354_67D925A0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch improves ANI operations by switching among the immunity
levels based on PHY errors and beacon rssi which will adjust receiver
desensitizing parameters. The changes are

* Configure the Weak Signal Detection based on current immunity value.
* At highest OFDM immunity level poor performance was observed with
  strong interference. By tuning the FIR step and spur immunity levels
  and not changing any weak signal detection thresholds at any level
  helped to improve the performance.
* ANI took long time to recover back to lower immunity levels on heavy
  data load. As the listen time got reset to zero before reaching to
  the 5x of aniperiod, the immunity level is not lowering back even
  without any interference. This patch fix that.

Cc: Paul Stewart <pstew@google.com>
Cc: Susinder Gulasekaran <susinder@qca.qualcomm.com>
Signed-off-by: Suresh Chandrasekaran <csuresh@qca.qualcomm.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ani.c        |   49 +++++++++++++--------------
 drivers/net/wireless/ath/ath9k/ani.h        |    6 ++--
 drivers/net/wireless/ath/ath9k/ar5008_phy.c |   38 ---------------------
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |   49 ---------------------------
 4 files changed, 27 insertions(+), 115 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index bc56f57..6c771f5 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -46,8 +46,8 @@ static const struct ani_ofdm_level_entry ofdm_level_table[] = {
 	{  5,  4,  1  }, /* lvl 5 */
 	{  6,  5,  1  }, /* lvl 6 */
 	{  7,  6,  1  }, /* lvl 7 */
-	{  7,  7,  1  }, /* lvl 8 */
-	{  7,  8,  0  }  /* lvl 9 */
+	{  7,  6,  0  }, /* lvl 8 */
+	{  7,  7,  0  }  /* lvl 9 */
 };
 #define ATH9K_ANI_OFDM_NUM_LEVEL \
 	ARRAY_SIZE(ofdm_level_table)
@@ -91,8 +91,8 @@ static const struct ani_cck_level_entry cck_level_table[] = {
 	{  4,  0  }, /* lvl 4 */
 	{  5,  0  }, /* lvl 5 */
 	{  6,  0  }, /* lvl 6 */
-	{  7,  0  }, /* lvl 7 (only for high rssi) */
-	{  8,  0  }  /* lvl 8 (only for high rssi) */
+	{  6,  0  }, /* lvl 7 (only for high rssi) */
+	{  7,  0  }  /* lvl 8 (only for high rssi) */
 };
 
 #define ATH9K_ANI_CCK_NUM_LEVEL \
@@ -290,16 +290,9 @@ static void ath9k_hw_set_ofdm_nil(struct ath_hw *ah, u8 immunityLevel)
 				     ATH9K_ANI_FIRSTEP_LEVEL,
 				     entry_ofdm->fir_step_level);
 
-	if ((ah->opmode != NL80211_IFTYPE_STATION &&
-	     ah->opmode != NL80211_IFTYPE_ADHOC) ||
-	    aniState->noiseFloor <= aniState->rssiThrHigh) {
-		if (aniState->ofdmWeakSigDetectOff)
-			/* force on ofdm weak sig detect */
-			ath9k_hw_ani_control(ah,
-				ATH9K_ANI_OFDM_WEAK_SIGNAL_DETECTION,
-					     true);
-		else if (aniState->ofdmWeakSigDetectOff ==
-			 entry_ofdm->ofdm_weak_signal_on)
+	if ((aniState->noiseFloor >= aniState->rssiThrHigh) &&
+	    (!aniState->ofdmWeakSigDetectOff !=
+	     entry_ofdm->ofdm_weak_signal_on)) {
 			ath9k_hw_ani_control(ah,
 				ATH9K_ANI_OFDM_WEAK_SIGNAL_DETECTION,
 				entry_ofdm->ofdm_weak_signal_on);
@@ -717,26 +710,30 @@ void ath9k_hw_ani_monitor(struct ath_hw *ah, struct ath9k_channel *chan)
 		ofdmPhyErrRate, aniState->cckNoiseImmunityLevel,
 		cckPhyErrRate, aniState->ofdmsTurn);
 
-	if (aniState->listenTime > 5 * ah->aniperiod) {
-		if (ofdmPhyErrRate <= ah->config.ofdm_trig_low &&
-		    cckPhyErrRate <= ah->config.cck_trig_low) {
+	if (aniState->listenTime > ah->aniperiod) {
+		if (cckPhyErrRate < ah->config.cck_trig_low &&
+		    ((ofdmPhyErrRate < ah->config.ofdm_trig_low &&
+		      aniState->ofdmNoiseImmunityLevel <
+		      ATH9K_ANI_OFDM_DEF_LEVEL) ||
+		     (ofdmPhyErrRate < ATH9K_ANI_OFDM_TRIG_LOW_ABOVE_INI &&
+		      aniState->ofdmNoiseImmunityLevel >=
+		      ATH9K_ANI_OFDM_DEF_LEVEL))) {
 			ath9k_hw_ani_lower_immunity(ah);
 			aniState->ofdmsTurn = !aniState->ofdmsTurn;
-		}
-		ath9k_ani_restart(ah);
-	} else if (aniState->listenTime > ah->aniperiod) {
-		/* check to see if need to raise immunity */
-		if (ofdmPhyErrRate > ah->config.ofdm_trig_high &&
-		    (cckPhyErrRate <= ah->config.cck_trig_high ||
-		     aniState->ofdmsTurn)) {
+		} else if ((ofdmPhyErrRate > ah->config.ofdm_trig_high &&
+			    aniState->ofdmNoiseImmunityLevel >=
+			    ATH9K_ANI_OFDM_DEF_LEVEL) ||
+			   (ofdmPhyErrRate >
+			    ATH9K_ANI_OFDM_TRIG_HIGH_BELOW_INI &&
+			    aniState->ofdmNoiseImmunityLevel <
+			    ATH9K_ANI_OFDM_DEF_LEVEL)) {
 			ath9k_hw_ani_ofdm_err_trigger(ah);
-			ath9k_ani_restart(ah);
 			aniState->ofdmsTurn = false;
 		} else if (cckPhyErrRate > ah->config.cck_trig_high) {
 			ath9k_hw_ani_cck_err_trigger(ah);
-			ath9k_ani_restart(ah);
 			aniState->ofdmsTurn = true;
 		}
+		ath9k_ani_restart(ah);
 	}
 }
 EXPORT_SYMBOL(ath9k_hw_ani_monitor);
diff --git a/drivers/net/wireless/ath/ath9k/ani.h b/drivers/net/wireless/ath/ath9k/ani.h
index 83029d6..72e2b87 100644
--- a/drivers/net/wireless/ath/ath9k/ani.h
+++ b/drivers/net/wireless/ath/ath9k/ani.h
@@ -25,11 +25,13 @@
 
 /* units are errors per second */
 #define ATH9K_ANI_OFDM_TRIG_HIGH_OLD      500
-#define ATH9K_ANI_OFDM_TRIG_HIGH_NEW      1000
+#define ATH9K_ANI_OFDM_TRIG_HIGH_NEW      3500
+#define ATH9K_ANI_OFDM_TRIG_HIGH_BELOW_INI 1000
 
 /* units are errors per second */
 #define ATH9K_ANI_OFDM_TRIG_LOW_OLD       200
 #define ATH9K_ANI_OFDM_TRIG_LOW_NEW       400
+#define ATH9K_ANI_OFDM_TRIG_LOW_ABOVE_INI 900
 
 /* units are errors per second */
 #define ATH9K_ANI_CCK_TRIG_HIGH_OLD       200
@@ -53,7 +55,7 @@
 #define ATH9K_ANI_RSSI_THR_LOW            7
 
 #define ATH9K_ANI_PERIOD_OLD              100
-#define ATH9K_ANI_PERIOD_NEW              1000
+#define ATH9K_ANI_PERIOD_NEW              300
 
 /* in ms */
 #define ATH9K_ANI_POLLINTERVAL_OLD        100
diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index 86a891f..96527a4 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -1056,46 +1056,8 @@ static bool ar5008_hw_ani_control_old(struct ath_hw *ah,
 		break;
 	}
 	case ATH9K_ANI_OFDM_WEAK_SIGNAL_DETECTION:{
-		static const int m1ThreshLow[] = { 127, 50 };
-		static const int m2ThreshLow[] = { 127, 40 };
-		static const int m1Thresh[] = { 127, 0x4d };
-		static const int m2Thresh[] = { 127, 0x40 };
-		static const int m2CountThr[] = { 31, 16 };
-		static const int m2CountThrLow[] = { 63, 48 };
 		u32 on = param ? 1 : 0;
 
-		REG_RMW_FIELD(ah, AR_PHY_SFCORR_LOW,
-			      AR_PHY_SFCORR_LOW_M1_THRESH_LOW,
-			      m1ThreshLow[on]);
-		REG_RMW_FIELD(ah, AR_PHY_SFCORR_LOW,
-			      AR_PHY_SFCORR_LOW_M2_THRESH_LOW,
-			      m2ThreshLow[on]);
-		REG_RMW_FIELD(ah, AR_PHY_SFCORR,
-			      AR_PHY_SFCORR_M1_THRESH,
-			      m1Thresh[on]);
-		REG_RMW_FIELD(ah, AR_PHY_SFCORR,
-			      AR_PHY_SFCORR_M2_THRESH,
-			      m2Thresh[on]);
-		REG_RMW_FIELD(ah, AR_PHY_SFCORR,
-			      AR_PHY_SFCORR_M2COUNT_THR,
-			      m2CountThr[on]);
-		REG_RMW_FIELD(ah, AR_PHY_SFCORR_LOW,
-			      AR_PHY_SFCORR_LOW_M2COUNT_THR_LOW,
-			      m2CountThrLow[on]);
-
-		REG_RMW_FIELD(ah, AR_PHY_SFCORR_EXT,
-			      AR_PHY_SFCORR_EXT_M1_THRESH_LOW,
-			      m1ThreshLow[on]);
-		REG_RMW_FIELD(ah, AR_PHY_SFCORR_EXT,
-			      AR_PHY_SFCORR_EXT_M2_THRESH_LOW,
-			      m2ThreshLow[on]);
-		REG_RMW_FIELD(ah, AR_PHY_SFCORR_EXT,
-			      AR_PHY_SFCORR_EXT_M1_THRESH,
-			      m1Thresh[on]);
-		REG_RMW_FIELD(ah, AR_PHY_SFCORR_EXT,
-			      AR_PHY_SFCORR_EXT_M2_THRESH,
-			      m2Thresh[on]);
-
 		if (on)
 			REG_SET_BIT(ah, AR_PHY_SFCORR_LOW,
 				    AR_PHY_SFCORR_LOW_USE_SELF_CORR_LOW);
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 70e27d2..54797e3 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -824,55 +824,6 @@ static bool ar9003_hw_ani_control(struct ath_hw *ah,
 		 * on == 0 means more noise imm
 		 */
 		u32 on = param ? 1 : 0;
-		/*
-		 * make register setting for default
-		 * (weak sig detect ON) come from INI file
-		 */
-		int m1ThreshLow = on ?
-			aniState->iniDef.m1ThreshLow : m1ThreshLow_off;
-		int m2ThreshLow = on ?
-			aniState->iniDef.m2ThreshLow : m2ThreshLow_off;
-		int m1Thresh = on ?
-			aniState->iniDef.m1Thresh : m1Thresh_off;
-		int m2Thresh = on ?
-			aniState->iniDef.m2Thresh : m2Thresh_off;
-		int m2CountThr = on ?
-			aniState->iniDef.m2CountThr : m2CountThr_off;
-		int m2CountThrLow = on ?
-			aniState->iniDef.m2CountThrLow : m2CountThrLow_off;
-		int m1ThreshLowExt = on ?
-			aniState->iniDef.m1ThreshLowExt : m1ThreshLowExt_off;
-		int m2ThreshLowExt = on ?
-			aniState->iniDef.m2ThreshLowExt : m2ThreshLowExt_off;
-		int m1ThreshExt = on ?
-			aniState->iniDef.m1ThreshExt : m1ThreshExt_off;
-		int m2ThreshExt = on ?
-			aniState->iniDef.m2ThreshExt : m2ThreshExt_off;
-
-		REG_RMW_FIELD(ah, AR_PHY_SFCORR_LOW,
-			      AR_PHY_SFCORR_LOW_M1_THRESH_LOW,
-			      m1ThreshLow);
-		REG_RMW_FIELD(ah, AR_PHY_SFCORR_LOW,
-			      AR_PHY_SFCORR_LOW_M2_THRESH_LOW,
-			      m2ThreshLow);
-		REG_RMW_FIELD(ah, AR_PHY_SFCORR,
-			      AR_PHY_SFCORR_M1_THRESH, m1Thresh);
-		REG_RMW_FIELD(ah, AR_PHY_SFCORR,
-			      AR_PHY_SFCORR_M2_THRESH, m2Thresh);
-		REG_RMW_FIELD(ah, AR_PHY_SFCORR,
-			      AR_PHY_SFCORR_M2COUNT_THR, m2CountThr);
-		REG_RMW_FIELD(ah, AR_PHY_SFCORR_LOW,
-			      AR_PHY_SFCORR_LOW_M2COUNT_THR_LOW,
-			      m2CountThrLow);
-
-		REG_RMW_FIELD(ah, AR_PHY_SFCORR_EXT,
-			      AR_PHY_SFCORR_EXT_M1_THRESH_LOW, m1ThreshLowExt);
-		REG_RMW_FIELD(ah, AR_PHY_SFCORR_EXT,
-			      AR_PHY_SFCORR_EXT_M2_THRESH_LOW, m2ThreshLowExt);
-		REG_RMW_FIELD(ah, AR_PHY_SFCORR_EXT,
-			      AR_PHY_SFCORR_EXT_M1_THRESH, m1ThreshExt);
-		REG_RMW_FIELD(ah, AR_PHY_SFCORR_EXT,
-			      AR_PHY_SFCORR_EXT_M2_THRESH, m2ThreshExt);
 
 		if (on)
 			REG_SET_BIT(ah, AR_PHY_SFCORR_LOW,
-- 
1.7.9.4

