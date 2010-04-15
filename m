Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:32817 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757315Ab0DOVjo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Apr 2010 17:39:44 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v3 44/97] ath9k_hw: Split out the function for reading the noise floor
Date: Thu, 15 Apr 2010 17:38:49 -0400
Message-Id: <1271367582-992-45-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271367582-992-1-git-send-email-lrodriguez@atheros.com>
References: <1271367582-992-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar5008_phy.c |   50 ++++++++++++
 drivers/net/wireless/ath/ath9k/ar9002_phy.c |   53 +++++++++++++
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |  110 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/calib.c      |   90 +---------------------
 drivers/net/wireless/ath/ath9k/hw-ops.h     |    6 ++
 drivers/net/wireless/ath/ath9k/hw.c         |    3 +
 drivers/net/wireless/ath/ath9k/hw.h         |   12 +++
 7 files changed, 235 insertions(+), 89 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index dddca59..bd3792c 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -1198,6 +1198,55 @@ static bool ar5008_hw_ani_control(struct ath_hw *ah,
 	return true;
 }
 
+static void ar5008_hw_do_getnf(struct ath_hw *ah,
+			      int16_t nfarray[NUM_NF_READINGS])
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+	int16_t nf;
+
+	nf = MS(REG_READ(ah, AR_PHY_CCA), AR_PHY_MINCCA_PWR);
+	if (nf & 0x100)
+		nf = 0 - ((nf ^ 0x1ff) + 1);
+	ath_print(common, ATH_DBG_CALIBRATE,
+		  "NF calibrated [ctl] [chain 0] is %d\n", nf);
+	nfarray[0] = nf;
+
+	nf = MS(REG_READ(ah, AR_PHY_CH1_CCA), AR_PHY_CH1_MINCCA_PWR);
+	if (nf & 0x100)
+		nf = 0 - ((nf ^ 0x1ff) + 1);
+	ath_print(common, ATH_DBG_CALIBRATE,
+		  "NF calibrated [ctl] [chain 1] is %d\n", nf);
+	nfarray[1] = nf;
+
+	nf = MS(REG_READ(ah, AR_PHY_CH2_CCA), AR_PHY_CH2_MINCCA_PWR);
+	if (nf & 0x100)
+		nf = 0 - ((nf ^ 0x1ff) + 1);
+	ath_print(common, ATH_DBG_CALIBRATE,
+		  "NF calibrated [ctl] [chain 2] is %d\n", nf);
+	nfarray[2] = nf;
+
+	nf = MS(REG_READ(ah, AR_PHY_EXT_CCA), AR_PHY_EXT_MINCCA_PWR);
+	if (nf & 0x100)
+		nf = 0 - ((nf ^ 0x1ff) + 1);
+	ath_print(common, ATH_DBG_CALIBRATE,
+		  "NF calibrated [ext] [chain 0] is %d\n", nf);
+	nfarray[3] = nf;
+
+	nf = MS(REG_READ(ah, AR_PHY_CH1_EXT_CCA), AR_PHY_CH1_EXT_MINCCA_PWR);
+	if (nf & 0x100)
+		nf = 0 - ((nf ^ 0x1ff) + 1);
+	ath_print(common, ATH_DBG_CALIBRATE,
+		  "NF calibrated [ext] [chain 1] is %d\n", nf);
+	nfarray[4] = nf;
+
+	nf = MS(REG_READ(ah, AR_PHY_CH2_EXT_CCA), AR_PHY_CH2_EXT_MINCCA_PWR);
+	if (nf & 0x100)
+		nf = 0 - ((nf ^ 0x1ff) + 1);
+	ath_print(common, ATH_DBG_CALIBRATE,
+		  "NF calibrated [ext] [chain 2] is %d\n", nf);
+	nfarray[5] = nf;
+}
+
 void ar5008_hw_attach_phy_ops(struct ath_hw *ah)
 {
 	struct ath_hw_private_ops *priv_ops = ath9k_hw_private_ops(ah);
@@ -1220,6 +1269,7 @@ void ar5008_hw_attach_phy_ops(struct ath_hw *ah)
 	priv_ops->restore_chainmask = ar5008_restore_chainmask;
 	priv_ops->set_diversity = ar5008_set_diversity;
 	priv_ops->ani_control = ar5008_hw_ani_control;
+	priv_ops->do_getnf = ar5008_hw_do_getnf;
 
 	if (AR_SREV_9100(ah))
 		priv_ops->compute_pll_control = ar9100_hw_compute_pll_control;
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.c b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
index 1f8ac0a..a0a2f58 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
@@ -467,6 +467,58 @@ static u32 ar9002_hw_compute_pll_control(struct ath_hw *ah,
 	return pll;
 }
 
+static void ar9002_hw_do_getnf(struct ath_hw *ah,
+			      int16_t nfarray[NUM_NF_READINGS])
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+	int16_t nf;
+
+	nf = MS(REG_READ(ah, AR_PHY_CCA), AR9280_PHY_MINCCA_PWR);
+
+	if (nf & 0x100)
+		nf = 0 - ((nf ^ 0x1ff) + 1);
+	ath_print(common, ATH_DBG_CALIBRATE,
+		  "NF calibrated [ctl] [chain 0] is %d\n", nf);
+
+	if (AR_SREV_9271(ah) && (nf >= -114))
+		nf = -116;
+
+	nfarray[0] = nf;
+
+	if (!AR_SREV_9285(ah) && !AR_SREV_9271(ah)) {
+		nf = MS(REG_READ(ah, AR_PHY_CH1_CCA),
+				AR9280_PHY_CH1_MINCCA_PWR);
+
+		if (nf & 0x100)
+			nf = 0 - ((nf ^ 0x1ff) + 1);
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "NF calibrated [ctl] [chain 1] is %d\n", nf);
+		nfarray[1] = nf;
+	}
+
+	nf = MS(REG_READ(ah, AR_PHY_EXT_CCA), AR9280_PHY_EXT_MINCCA_PWR);
+	if (nf & 0x100)
+		nf = 0 - ((nf ^ 0x1ff) + 1);
+	ath_print(common, ATH_DBG_CALIBRATE,
+		  "NF calibrated [ext] [chain 0] is %d\n", nf);
+
+	if (AR_SREV_9271(ah) && (nf >= -114))
+		nf = -116;
+
+	nfarray[3] = nf;
+
+	if (!AR_SREV_9285(ah) && !AR_SREV_9271(ah)) {
+		nf = MS(REG_READ(ah, AR_PHY_CH1_EXT_CCA),
+				AR9280_PHY_CH1_EXT_MINCCA_PWR);
+
+		if (nf & 0x100)
+			nf = 0 - ((nf ^ 0x1ff) + 1);
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "NF calibrated [ext] [chain 1] is %d\n", nf);
+		nfarray[4] = nf;
+	}
+}
+
 void ar9002_hw_attach_phy_ops(struct ath_hw *ah)
 {
 	struct ath_hw_private_ops *priv_ops = ath9k_hw_private_ops(ah);
@@ -478,4 +530,5 @@ void ar9002_hw_attach_phy_ops(struct ath_hw *ah)
 	priv_ops->spur_mitigate_freq = ar9002_hw_spur_mitigate;
 	priv_ops->olc_init = ar9002_olc_init;
 	priv_ops->compute_pll_control = ar9002_hw_compute_pll_control;
+	priv_ops->do_getnf = ar9002_hw_do_getnf;
 }
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index c938b85..67b3b65 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -705,6 +705,115 @@ static bool ar9003_hw_ani_control(struct ath_hw *ah,
 	return true;
 }
 
+static void ar9003_hw_nf_sanitize_2g(struct ath_hw *ah, s16 *nf)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	if (*nf > ah->nf_2g_max) {
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "2 GHz NF (%d) > MAX (%d), "
+			  "correcting to MAX",
+			  *nf, ah->nf_2g_max);
+		*nf = ah->nf_2g_max;
+	} else if (*nf < ah->nf_2g_min) {
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "2 GHz NF (%d) < MIN (%d), "
+			  "correcting to MIN",
+			  *nf, ah->nf_2g_min);
+		*nf = ah->nf_2g_min;
+	}
+}
+
+static void ar9003_hw_nf_sanitize_5g(struct ath_hw *ah, s16 *nf)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	if (*nf > ah->nf_5g_max) {
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "5 GHz NF (%d) > MAX (%d), "
+			  "correcting to MAX",
+			  *nf, ah->nf_5g_max);
+		*nf = ah->nf_5g_max;
+	} else if (*nf < ah->nf_5g_min) {
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "5 GHz NF (%d) < MIN (%d), "
+			  "correcting to MIN",
+			  *nf, ah->nf_5g_min);
+		*nf = ah->nf_5g_min;
+	}
+}
+
+static void ar9003_hw_nf_sanitize(struct ath_hw *ah, s16 *nf)
+{
+	if (IS_CHAN_2GHZ(ah->curchan))
+		ar9003_hw_nf_sanitize_2g(ah, nf);
+	else
+		ar9003_hw_nf_sanitize_5g(ah, nf);
+}
+
+static void ar9003_hw_do_getnf(struct ath_hw *ah,
+			      int16_t nfarray[NUM_NF_READINGS])
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+	int16_t nf;
+
+	nf = MS(REG_READ(ah, AR_PHY_CCA_0), AR_PHY_MINCCA_PWR);
+	if (nf & 0x100)
+		nf = 0 - ((nf ^ 0x1ff) + 1);
+	ar9003_hw_nf_sanitize(ah, &nf);
+	ath_print(common, ATH_DBG_CALIBRATE,
+		  "NF calibrated [ctl] [chain 0] is %d\n", nf);
+	nfarray[0] = nf;
+
+	nf = MS(REG_READ(ah, AR_PHY_CCA_1), AR_PHY_CH1_MINCCA_PWR);
+	if (nf & 0x100)
+		nf = 0 - ((nf ^ 0x1ff) + 1);
+	ar9003_hw_nf_sanitize(ah, &nf);
+	ath_print(common, ATH_DBG_CALIBRATE,
+		  "NF calibrated [ctl] [chain 1] is %d\n", nf);
+	nfarray[1] = nf;
+
+	nf = MS(REG_READ(ah, AR_PHY_CCA_2), AR_PHY_CH2_MINCCA_PWR);
+	if (nf & 0x100)
+		nf = 0 - ((nf ^ 0x1ff) + 1);
+	ar9003_hw_nf_sanitize(ah, &nf);
+	ath_print(common, ATH_DBG_CALIBRATE,
+		  "NF calibrated [ctl] [chain 2] is %d\n", nf);
+	nfarray[2] = nf;
+
+	nf = MS(REG_READ(ah, AR_PHY_EXT_CCA), AR_PHY_EXT_MINCCA_PWR);
+	if (nf & 0x100)
+		nf = 0 - ((nf ^ 0x1ff) + 1);
+	ar9003_hw_nf_sanitize(ah, &nf);
+	ath_print(common, ATH_DBG_CALIBRATE,
+		  "NF calibrated [ext] [chain 0] is %d\n", nf);
+	nfarray[3] = nf;
+
+	nf = MS(REG_READ(ah, AR_PHY_EXT_CCA_1), AR_PHY_CH1_EXT_MINCCA_PWR);
+	if (nf & 0x100)
+		nf = 0 - ((nf ^ 0x1ff) + 1);
+	ar9003_hw_nf_sanitize(ah, &nf);
+	ath_print(common, ATH_DBG_CALIBRATE,
+		  "NF calibrated [ext] [chain 1] is %d\n", nf);
+	nfarray[4] = nf;
+
+	nf = MS(REG_READ(ah, AR_PHY_EXT_CCA_2), AR_PHY_CH2_EXT_MINCCA_PWR);
+	if (nf & 0x100)
+		nf = 0 - ((nf ^ 0x1ff) + 1);
+	ar9003_hw_nf_sanitize(ah, &nf);
+	ath_print(common, ATH_DBG_CALIBRATE,
+		  "NF calibrated [ext] [chain 2] is %d\n", nf);
+	nfarray[5] = nf;
+}
+
+void ar9003_hw_set_nf_limits(struct ath_hw *ah)
+{
+	ah->nf_2g_max = AR_PHY_CCA_MAX_GOOD_VAL_9300_2GHZ;
+	ah->nf_2g_min = AR_PHY_CCA_MIN_GOOD_VAL_9300_2GHZ;
+	ah->nf_5g_max = AR_PHY_CCA_MAX_GOOD_VAL_9300_5GHZ;
+	ah->nf_5g_min = AR_PHY_CCA_MIN_GOOD_VAL_9300_5GHZ;
+}
+
 void ar9003_hw_attach_phy_ops(struct ath_hw *ah)
 {
 	struct ath_hw_private_ops *priv_ops = ath9k_hw_private_ops(ah);
@@ -723,4 +832,5 @@ void ar9003_hw_attach_phy_ops(struct ath_hw *ah)
 	priv_ops->enable_rfkill = ar9003_hw_enable_rfkill;
 	priv_ops->set_diversity = ar9003_hw_set_diversity;
 	priv_ops->ani_control = ar9003_hw_ani_control;
+	priv_ops->do_getnf = ar9003_hw_do_getnf;
 }
diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index eba85ad..eed2c76 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -15,6 +15,7 @@
  */
 
 #include "hw.h"
+#include "hw-ops.h"
 #include "ar9002_phy.h"
 
 /* We can tune this as we go by monitoring really low values */
@@ -88,95 +89,6 @@ static void ath9k_hw_update_nfcal_hist_buffer(struct ath9k_nfcal_hist *h,
 	return;
 }
 
-static void ath9k_hw_do_getnf(struct ath_hw *ah,
-			      int16_t nfarray[NUM_NF_READINGS])
-{
-	struct ath_common *common = ath9k_hw_common(ah);
-	int16_t nf;
-
-	if (AR_SREV_9280_10_OR_LATER(ah))
-		nf = MS(REG_READ(ah, AR_PHY_CCA), AR9280_PHY_MINCCA_PWR);
-	else
-		nf = MS(REG_READ(ah, AR_PHY_CCA), AR_PHY_MINCCA_PWR);
-
-	if (nf & 0x100)
-		nf = 0 - ((nf ^ 0x1ff) + 1);
-	ath_print(common, ATH_DBG_CALIBRATE,
-		  "NF calibrated [ctl] [chain 0] is %d\n", nf);
-
-	if (AR_SREV_9271(ah) && (nf >= -114))
-		nf = -116;
-
-	nfarray[0] = nf;
-
-	if (!AR_SREV_9285(ah) && !AR_SREV_9271(ah)) {
-		if (AR_SREV_9280_10_OR_LATER(ah))
-			nf = MS(REG_READ(ah, AR_PHY_CH1_CCA),
-					AR9280_PHY_CH1_MINCCA_PWR);
-		else
-			nf = MS(REG_READ(ah, AR_PHY_CH1_CCA),
-					AR_PHY_CH1_MINCCA_PWR);
-
-		if (nf & 0x100)
-			nf = 0 - ((nf ^ 0x1ff) + 1);
-		ath_print(common, ATH_DBG_CALIBRATE,
-			  "NF calibrated [ctl] [chain 1] is %d\n", nf);
-		nfarray[1] = nf;
-
-		if (!AR_SREV_9280(ah) && !AR_SREV_9287(ah)) {
-			nf = MS(REG_READ(ah, AR_PHY_CH2_CCA),
-					AR_PHY_CH2_MINCCA_PWR);
-			if (nf & 0x100)
-				nf = 0 - ((nf ^ 0x1ff) + 1);
-			ath_print(common, ATH_DBG_CALIBRATE,
-				  "NF calibrated [ctl] [chain 2] is %d\n", nf);
-			nfarray[2] = nf;
-		}
-	}
-
-	if (AR_SREV_9280_10_OR_LATER(ah))
-		nf = MS(REG_READ(ah, AR_PHY_EXT_CCA),
-			AR9280_PHY_EXT_MINCCA_PWR);
-	else
-		nf = MS(REG_READ(ah, AR_PHY_EXT_CCA),
-			AR_PHY_EXT_MINCCA_PWR);
-
-	if (nf & 0x100)
-		nf = 0 - ((nf ^ 0x1ff) + 1);
-	ath_print(common, ATH_DBG_CALIBRATE,
-		  "NF calibrated [ext] [chain 0] is %d\n", nf);
-
-	if (AR_SREV_9271(ah) && (nf >= -114))
-		nf = -116;
-
-	nfarray[3] = nf;
-
-	if (!AR_SREV_9285(ah) && !AR_SREV_9271(ah)) {
-		if (AR_SREV_9280_10_OR_LATER(ah))
-			nf = MS(REG_READ(ah, AR_PHY_CH1_EXT_CCA),
-					AR9280_PHY_CH1_EXT_MINCCA_PWR);
-		else
-			nf = MS(REG_READ(ah, AR_PHY_CH1_EXT_CCA),
-					AR_PHY_CH1_EXT_MINCCA_PWR);
-
-		if (nf & 0x100)
-			nf = 0 - ((nf ^ 0x1ff) + 1);
-		ath_print(common, ATH_DBG_CALIBRATE,
-			  "NF calibrated [ext] [chain 1] is %d\n", nf);
-		nfarray[4] = nf;
-
-		if (!AR_SREV_9280(ah) && !AR_SREV_9287(ah)) {
-			nf = MS(REG_READ(ah, AR_PHY_CH2_EXT_CCA),
-					AR_PHY_CH2_EXT_MINCCA_PWR);
-			if (nf & 0x100)
-				nf = 0 - ((nf ^ 0x1ff) + 1);
-			ath_print(common, ATH_DBG_CALIBRATE,
-				  "NF calibrated [ext] [chain 2] is %d\n", nf);
-			nfarray[5] = nf;
-		}
-	}
-}
-
 static bool getNoiseFloorThresh(struct ath_hw *ah,
 				enum ieee80211_band band,
 				int16_t *nft)
diff --git a/drivers/net/wireless/ath/ath9k/hw-ops.h b/drivers/net/wireless/ath/ath9k/hw-ops.h
index a770107..e2b8ad4 100644
--- a/drivers/net/wireless/ath/ath9k/hw-ops.h
+++ b/drivers/net/wireless/ath/ath9k/hw-ops.h
@@ -163,4 +163,10 @@ static inline bool ath9k_hw_ani_control(struct ath_hw *ah,
 	return ath9k_hw_private_ops(ah)->ani_control(ah, cmd, param);
 }
 
+static inline void ath9k_hw_do_getnf(struct ath_hw *ah,
+				     int16_t nfarray[NUM_NF_READINGS])
+{
+	return ath9k_hw_private_ops(ah)->do_getnf(ah, nfarray);
+}
+
 #endif /* ATH9K_HW_OPS_H */
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index aa80d43..2dcfaa9 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1072,6 +1072,9 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 	else
 		ah->tx_trig_level = (AR_FTRIG_512B >> AR_FTRIG_S);
 
+	if (AR_SREV_9300_20_OR_LATER(ah))
+		ar9003_hw_set_nf_limits(ah);
+
 	ath9k_init_nfcal_hist_buffer(ah);
 
 	common->state = ATH_HW_INITIALIZED;
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 1eceda2..7889ecb 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -513,6 +513,7 @@ struct ath_hw_private_ops {
 				   struct ath9k_channel *chan);
 	bool (*ani_control)(struct ath_hw *ah, enum ath9k_ani_cmd cmd,
 			    int param);
+	void (*do_getnf)(struct ath_hw *ah, int16_t nfarray[NUM_NF_READINGS]);
 };
 
 /**
@@ -553,6 +554,10 @@ struct ath_hw {
 	bool is_pciexpress;
 	bool need_an_top2_fixup;
 	u16 tx_trig_level;
+	s16 nf_2g_max;
+	s16 nf_2g_min;
+	s16 nf_5g_max;
+	s16 nf_5g_min;
 	u16 rfsilent;
 	u32 rfkill_gpio;
 	u32 rfkill_polarity;
@@ -818,6 +823,13 @@ void ath9k_hw_htc_resetinit(struct ath_hw *ah);
 void ath9k_hw_get_delta_slope_vals(struct ath_hw *ah, u32 coef_scaled,
 				   u32 *coef_mantissa, u32 *coef_exponent);
 
+/*
+ * Code specifric to AR9003, we stuff these here to avoid callbacks
+ * for older families
+ */
+void ar9003_hw_set_nf_limits(struct ath_hw *ah);
+
+/* Hardware family op attach helpers */
 void ar5008_hw_attach_phy_ops(struct ath_hw *ah);
 void ar9002_hw_attach_phy_ops(struct ath_hw *ah);
 void ar9003_hw_attach_phy_ops(struct ath_hw *ah);
-- 
1.6.3.3

