Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:32772 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757304Ab0DOVjo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Apr 2010 17:39:44 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH v3 34/97] ath9k_hw: Split off ANI control to the PHY ops
Date: Thu, 15 Apr 2010 17:38:39 -0400
Message-Id: <1271367582-992-35-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271367582-992-1-git-send-email-lrodriguez@atheros.com>
References: <1271367582-992-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ani.c        |  186 +--------------------------
 drivers/net/wireless/ath/ath9k/ar5008_phy.c |  184 ++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |    8 +
 drivers/net/wireless/ath/ath9k/hw-ops.h     |    6 +
 drivers/net/wireless/ath/ath9k/hw.h         |    2 +
 5 files changed, 201 insertions(+), 185 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index 031802c..5a2d867 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -15,7 +15,7 @@
  */
 
 #include "hw.h"
-#include "ar9002_phy.h"
+#include "hw-ops.h"
 
 static int ath9k_hw_get_ani_channel_idx(struct ath_hw *ah,
 					struct ath9k_channel *chan)
@@ -38,190 +38,6 @@ static int ath9k_hw_get_ani_channel_idx(struct ath_hw *ah,
 	return 0;
 }
 
-static bool ath9k_hw_ani_control(struct ath_hw *ah,
-				 enum ath9k_ani_cmd cmd, int param)
-{
-	struct ar5416AniState *aniState = ah->curani;
-	struct ath_common *common = ath9k_hw_common(ah);
-
-	switch (cmd & ah->ani_function) {
-	case ATH9K_ANI_NOISE_IMMUNITY_LEVEL:{
-		u32 level = param;
-
-		if (level >= ARRAY_SIZE(ah->totalSizeDesired)) {
-			ath_print(common, ATH_DBG_ANI,
-				  "level out of range (%u > %u)\n",
-				  level,
-				  (unsigned)ARRAY_SIZE(ah->totalSizeDesired));
-			return false;
-		}
-
-		REG_RMW_FIELD(ah, AR_PHY_DESIRED_SZ,
-			      AR_PHY_DESIRED_SZ_TOT_DES,
-			      ah->totalSizeDesired[level]);
-		REG_RMW_FIELD(ah, AR_PHY_AGC_CTL1,
-			      AR_PHY_AGC_CTL1_COARSE_LOW,
-			      ah->coarse_low[level]);
-		REG_RMW_FIELD(ah, AR_PHY_AGC_CTL1,
-			      AR_PHY_AGC_CTL1_COARSE_HIGH,
-			      ah->coarse_high[level]);
-		REG_RMW_FIELD(ah, AR_PHY_FIND_SIG,
-			      AR_PHY_FIND_SIG_FIRPWR,
-			      ah->firpwr[level]);
-
-		if (level > aniState->noiseImmunityLevel)
-			ah->stats.ast_ani_niup++;
-		else if (level < aniState->noiseImmunityLevel)
-			ah->stats.ast_ani_nidown++;
-		aniState->noiseImmunityLevel = level;
-		break;
-	}
-	case ATH9K_ANI_OFDM_WEAK_SIGNAL_DETECTION:{
-		const int m1ThreshLow[] = { 127, 50 };
-		const int m2ThreshLow[] = { 127, 40 };
-		const int m1Thresh[] = { 127, 0x4d };
-		const int m2Thresh[] = { 127, 0x40 };
-		const int m2CountThr[] = { 31, 16 };
-		const int m2CountThrLow[] = { 63, 48 };
-		u32 on = param ? 1 : 0;
-
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
-		if (on)
-			REG_SET_BIT(ah, AR_PHY_SFCORR_LOW,
-				    AR_PHY_SFCORR_LOW_USE_SELF_CORR_LOW);
-		else
-			REG_CLR_BIT(ah, AR_PHY_SFCORR_LOW,
-				    AR_PHY_SFCORR_LOW_USE_SELF_CORR_LOW);
-
-		if (!on != aniState->ofdmWeakSigDetectOff) {
-			if (on)
-				ah->stats.ast_ani_ofdmon++;
-			else
-				ah->stats.ast_ani_ofdmoff++;
-			aniState->ofdmWeakSigDetectOff = !on;
-		}
-		break;
-	}
-	case ATH9K_ANI_CCK_WEAK_SIGNAL_THR:{
-		const int weakSigThrCck[] = { 8, 6 };
-		u32 high = param ? 1 : 0;
-
-		REG_RMW_FIELD(ah, AR_PHY_CCK_DETECT,
-			      AR_PHY_CCK_DETECT_WEAK_SIG_THR_CCK,
-			      weakSigThrCck[high]);
-		if (high != aniState->cckWeakSigThreshold) {
-			if (high)
-				ah->stats.ast_ani_cckhigh++;
-			else
-				ah->stats.ast_ani_ccklow++;
-			aniState->cckWeakSigThreshold = high;
-		}
-		break;
-	}
-	case ATH9K_ANI_FIRSTEP_LEVEL:{
-		const int firstep[] = { 0, 4, 8 };
-		u32 level = param;
-
-		if (level >= ARRAY_SIZE(firstep)) {
-			ath_print(common, ATH_DBG_ANI,
-				  "level out of range (%u > %u)\n",
-				  level,
-				  (unsigned) ARRAY_SIZE(firstep));
-			return false;
-		}
-		REG_RMW_FIELD(ah, AR_PHY_FIND_SIG,
-			      AR_PHY_FIND_SIG_FIRSTEP,
-			      firstep[level]);
-		if (level > aniState->firstepLevel)
-			ah->stats.ast_ani_stepup++;
-		else if (level < aniState->firstepLevel)
-			ah->stats.ast_ani_stepdown++;
-		aniState->firstepLevel = level;
-		break;
-	}
-	case ATH9K_ANI_SPUR_IMMUNITY_LEVEL:{
-		const int cycpwrThr1[] =
-			{ 2, 4, 6, 8, 10, 12, 14, 16 };
-		u32 level = param;
-
-		if (level >= ARRAY_SIZE(cycpwrThr1)) {
-			ath_print(common, ATH_DBG_ANI,
-				  "level out of range (%u > %u)\n",
-				  level,
-				  (unsigned) ARRAY_SIZE(cycpwrThr1));
-			return false;
-		}
-		REG_RMW_FIELD(ah, AR_PHY_TIMING5,
-			      AR_PHY_TIMING5_CYCPWR_THR1,
-			      cycpwrThr1[level]);
-		if (level > aniState->spurImmunityLevel)
-			ah->stats.ast_ani_spurup++;
-		else if (level < aniState->spurImmunityLevel)
-			ah->stats.ast_ani_spurdown++;
-		aniState->spurImmunityLevel = level;
-		break;
-	}
-	case ATH9K_ANI_PRESENT:
-		break;
-	default:
-		ath_print(common, ATH_DBG_ANI,
-			  "invalid cmd %u\n", cmd);
-		return false;
-	}
-
-	ath_print(common, ATH_DBG_ANI, "ANI parameters:\n");
-	ath_print(common, ATH_DBG_ANI,
-		  "noiseImmunityLevel=%d, spurImmunityLevel=%d, "
-		  "ofdmWeakSigDetectOff=%d\n",
-		  aniState->noiseImmunityLevel,
-		  aniState->spurImmunityLevel,
-		  !aniState->ofdmWeakSigDetectOff);
-	ath_print(common, ATH_DBG_ANI,
-		  "cckWeakSigThreshold=%d, "
-		  "firstepLevel=%d, listenTime=%d\n",
-		  aniState->cckWeakSigThreshold,
-		  aniState->firstepLevel,
-		  aniState->listenTime);
-	ath_print(common, ATH_DBG_ANI,
-		"cycleCount=%d, ofdmPhyErrCount=%d, cckPhyErrCount=%d\n\n",
-		aniState->cycleCount,
-		aniState->ofdmPhyErrCount,
-		aniState->cckPhyErrCount);
-
-	return true;
-}
-
 static void ath9k_hw_update_mibstats(struct ath_hw *ah,
 				     struct ath9k_mib_stats *stats)
 {
diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index 9685f4c..dddca59 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -1015,6 +1015,189 @@ static u32 ar5008_hw_compute_pll_control(struct ath_hw *ah,
 	return pll;
 }
 
+static bool ar5008_hw_ani_control(struct ath_hw *ah,
+				  enum ath9k_ani_cmd cmd, int param)
+{
+	struct ar5416AniState *aniState = ah->curani;
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	switch (cmd & ah->ani_function) {
+	case ATH9K_ANI_NOISE_IMMUNITY_LEVEL:{
+		u32 level = param;
+
+		if (level >= ARRAY_SIZE(ah->totalSizeDesired)) {
+			ath_print(common, ATH_DBG_ANI,
+				  "level out of range (%u > %u)\n",
+				  level,
+				  (unsigned)ARRAY_SIZE(ah->totalSizeDesired));
+			return false;
+		}
+
+		REG_RMW_FIELD(ah, AR_PHY_DESIRED_SZ,
+			      AR_PHY_DESIRED_SZ_TOT_DES,
+			      ah->totalSizeDesired[level]);
+		REG_RMW_FIELD(ah, AR_PHY_AGC_CTL1,
+			      AR_PHY_AGC_CTL1_COARSE_LOW,
+			      ah->coarse_low[level]);
+		REG_RMW_FIELD(ah, AR_PHY_AGC_CTL1,
+			      AR_PHY_AGC_CTL1_COARSE_HIGH,
+			      ah->coarse_high[level]);
+		REG_RMW_FIELD(ah, AR_PHY_FIND_SIG,
+			      AR_PHY_FIND_SIG_FIRPWR,
+			      ah->firpwr[level]);
+
+		if (level > aniState->noiseImmunityLevel)
+			ah->stats.ast_ani_niup++;
+		else if (level < aniState->noiseImmunityLevel)
+			ah->stats.ast_ani_nidown++;
+		aniState->noiseImmunityLevel = level;
+		break;
+	}
+	case ATH9K_ANI_OFDM_WEAK_SIGNAL_DETECTION:{
+		const int m1ThreshLow[] = { 127, 50 };
+		const int m2ThreshLow[] = { 127, 40 };
+		const int m1Thresh[] = { 127, 0x4d };
+		const int m2Thresh[] = { 127, 0x40 };
+		const int m2CountThr[] = { 31, 16 };
+		const int m2CountThrLow[] = { 63, 48 };
+		u32 on = param ? 1 : 0;
+
+		REG_RMW_FIELD(ah, AR_PHY_SFCORR_LOW,
+			      AR_PHY_SFCORR_LOW_M1_THRESH_LOW,
+			      m1ThreshLow[on]);
+		REG_RMW_FIELD(ah, AR_PHY_SFCORR_LOW,
+			      AR_PHY_SFCORR_LOW_M2_THRESH_LOW,
+			      m2ThreshLow[on]);
+		REG_RMW_FIELD(ah, AR_PHY_SFCORR,
+			      AR_PHY_SFCORR_M1_THRESH,
+			      m1Thresh[on]);
+		REG_RMW_FIELD(ah, AR_PHY_SFCORR,
+			      AR_PHY_SFCORR_M2_THRESH,
+			      m2Thresh[on]);
+		REG_RMW_FIELD(ah, AR_PHY_SFCORR,
+			      AR_PHY_SFCORR_M2COUNT_THR,
+			      m2CountThr[on]);
+		REG_RMW_FIELD(ah, AR_PHY_SFCORR_LOW,
+			      AR_PHY_SFCORR_LOW_M2COUNT_THR_LOW,
+			      m2CountThrLow[on]);
+
+		REG_RMW_FIELD(ah, AR_PHY_SFCORR_EXT,
+			      AR_PHY_SFCORR_EXT_M1_THRESH_LOW,
+			      m1ThreshLow[on]);
+		REG_RMW_FIELD(ah, AR_PHY_SFCORR_EXT,
+			      AR_PHY_SFCORR_EXT_M2_THRESH_LOW,
+			      m2ThreshLow[on]);
+		REG_RMW_FIELD(ah, AR_PHY_SFCORR_EXT,
+			      AR_PHY_SFCORR_EXT_M1_THRESH,
+			      m1Thresh[on]);
+		REG_RMW_FIELD(ah, AR_PHY_SFCORR_EXT,
+			      AR_PHY_SFCORR_EXT_M2_THRESH,
+			      m2Thresh[on]);
+
+		if (on)
+			REG_SET_BIT(ah, AR_PHY_SFCORR_LOW,
+				    AR_PHY_SFCORR_LOW_USE_SELF_CORR_LOW);
+		else
+			REG_CLR_BIT(ah, AR_PHY_SFCORR_LOW,
+				    AR_PHY_SFCORR_LOW_USE_SELF_CORR_LOW);
+
+		if (!on != aniState->ofdmWeakSigDetectOff) {
+			if (on)
+				ah->stats.ast_ani_ofdmon++;
+			else
+				ah->stats.ast_ani_ofdmoff++;
+			aniState->ofdmWeakSigDetectOff = !on;
+		}
+		break;
+	}
+	case ATH9K_ANI_CCK_WEAK_SIGNAL_THR:{
+		const int weakSigThrCck[] = { 8, 6 };
+		u32 high = param ? 1 : 0;
+
+		REG_RMW_FIELD(ah, AR_PHY_CCK_DETECT,
+			      AR_PHY_CCK_DETECT_WEAK_SIG_THR_CCK,
+			      weakSigThrCck[high]);
+		if (high != aniState->cckWeakSigThreshold) {
+			if (high)
+				ah->stats.ast_ani_cckhigh++;
+			else
+				ah->stats.ast_ani_ccklow++;
+			aniState->cckWeakSigThreshold = high;
+		}
+		break;
+	}
+	case ATH9K_ANI_FIRSTEP_LEVEL:{
+		const int firstep[] = { 0, 4, 8 };
+		u32 level = param;
+
+		if (level >= ARRAY_SIZE(firstep)) {
+			ath_print(common, ATH_DBG_ANI,
+				  "level out of range (%u > %u)\n",
+				  level,
+				  (unsigned) ARRAY_SIZE(firstep));
+			return false;
+		}
+		REG_RMW_FIELD(ah, AR_PHY_FIND_SIG,
+			      AR_PHY_FIND_SIG_FIRSTEP,
+			      firstep[level]);
+		if (level > aniState->firstepLevel)
+			ah->stats.ast_ani_stepup++;
+		else if (level < aniState->firstepLevel)
+			ah->stats.ast_ani_stepdown++;
+		aniState->firstepLevel = level;
+		break;
+	}
+	case ATH9K_ANI_SPUR_IMMUNITY_LEVEL:{
+		const int cycpwrThr1[] = { 2, 4, 6, 8, 10, 12, 14, 16 };
+		u32 level = param;
+
+		if (level >= ARRAY_SIZE(cycpwrThr1)) {
+			ath_print(common, ATH_DBG_ANI,
+				  "level out of range (%u > %u)\n",
+				  level,
+				  (unsigned) ARRAY_SIZE(cycpwrThr1));
+			return false;
+		}
+		REG_RMW_FIELD(ah, AR_PHY_TIMING5,
+			      AR_PHY_TIMING5_CYCPWR_THR1,
+			      cycpwrThr1[level]);
+		if (level > aniState->spurImmunityLevel)
+			ah->stats.ast_ani_spurup++;
+		else if (level < aniState->spurImmunityLevel)
+			ah->stats.ast_ani_spurdown++;
+		aniState->spurImmunityLevel = level;
+		break;
+	}
+	case ATH9K_ANI_PRESENT:
+		break;
+	default:
+		ath_print(common, ATH_DBG_ANI,
+			  "invalid cmd %u\n", cmd);
+		return false;
+	}
+
+	ath_print(common, ATH_DBG_ANI, "ANI parameters:\n");
+	ath_print(common, ATH_DBG_ANI,
+		  "noiseImmunityLevel=%d, spurImmunityLevel=%d, "
+		  "ofdmWeakSigDetectOff=%d\n",
+		  aniState->noiseImmunityLevel,
+		  aniState->spurImmunityLevel,
+		  !aniState->ofdmWeakSigDetectOff);
+	ath_print(common, ATH_DBG_ANI,
+		  "cckWeakSigThreshold=%d, "
+		  "firstepLevel=%d, listenTime=%d\n",
+		  aniState->cckWeakSigThreshold,
+		  aniState->firstepLevel,
+		  aniState->listenTime);
+	ath_print(common, ATH_DBG_ANI,
+		"cycleCount=%d, ofdmPhyErrCount=%d, cckPhyErrCount=%d\n\n",
+		aniState->cycleCount,
+		aniState->ofdmPhyErrCount,
+		aniState->cckPhyErrCount);
+
+	return true;
+}
+
 void ar5008_hw_attach_phy_ops(struct ath_hw *ah)
 {
 	struct ath_hw_private_ops *priv_ops = ath9k_hw_private_ops(ah);
@@ -1036,6 +1219,7 @@ void ar5008_hw_attach_phy_ops(struct ath_hw *ah)
 	priv_ops->enable_rfkill = ar5008_hw_enable_rfkill;
 	priv_ops->restore_chainmask = ar5008_restore_chainmask;
 	priv_ops->set_diversity = ar5008_set_diversity;
+	priv_ops->ani_control = ar5008_hw_ani_control;
 
 	if (AR_SREV_9100(ah))
 		priv_ops->compute_pll_control = ar9100_hw_compute_pll_control;
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index acbf122..356e03d 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -420,6 +420,13 @@ static void ar9003_hw_set_diversity(struct ath_hw *ah, bool value)
 	/* TODO */
 }
 
+static bool ar9003_hw_ani_control(struct ath_hw *ah,
+				  enum ath9k_ani_cmd cmd, int param)
+{
+	/* TODO */
+	return false;
+}
+
 void ar9003_hw_attach_phy_ops(struct ath_hw *ah)
 {
 	struct ath_hw_private_ops *priv_ops = ath9k_hw_private_ops(ah);
@@ -437,4 +444,5 @@ void ar9003_hw_attach_phy_ops(struct ath_hw *ah)
 	priv_ops->rfbus_done = ar9003_hw_rfbus_done;
 	priv_ops->enable_rfkill = ar9003_hw_enable_rfkill;
 	priv_ops->set_diversity = ar9003_hw_set_diversity;
+	priv_ops->ani_control = ar9003_hw_ani_control;
 }
diff --git a/drivers/net/wireless/ath/ath9k/hw-ops.h b/drivers/net/wireless/ath/ath9k/hw-ops.h
index 19259fb..08a51a2 100644
--- a/drivers/net/wireless/ath/ath9k/hw-ops.h
+++ b/drivers/net/wireless/ath/ath9k/hw-ops.h
@@ -146,4 +146,10 @@ static inline void ath9k_hw_set_diversity(struct ath_hw *ah, bool value)
 	return ath9k_hw_private_ops(ah)->set_diversity(ah, value);
 }
 
+static inline bool ath9k_hw_ani_control(struct ath_hw *ah,
+					enum ath9k_ani_cmd cmd, int param)
+{
+	return ath9k_hw_private_ops(ah)->ani_control(ah, cmd, param);
+}
+
 #endif /* ATH9K_HW_OPS_H */
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index c3928be..b0cfc77 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -508,6 +508,8 @@ struct ath_hw_private_ops {
 	void (*set_diversity)(struct ath_hw *ah, bool value);
 	u32 (*compute_pll_control)(struct ath_hw *ah,
 				   struct ath9k_channel *chan);
+	bool (*ani_control)(struct ath_hw *ah, enum ath9k_ani_cmd cmd,
+			    int param);
 };
 
 /**
-- 
1.6.3.3

