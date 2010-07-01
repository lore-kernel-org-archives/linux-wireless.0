Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:49986 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933500Ab0GAWKE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Jul 2010 18:10:04 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 4/6] ath9k_hw: sanitize noise floor values properly on all chips
Date: Fri,  2 Jul 2010 00:09:50 +0200
Message-Id: <1278022192-83277-4-git-send-email-nbd@openwrt.org>
In-Reply-To: <1278022192-83277-3-git-send-email-nbd@openwrt.org>
References: <1278022192-83277-1-git-send-email-nbd@openwrt.org>
 <1278022192-83277-2-git-send-email-nbd@openwrt.org>
 <1278022192-83277-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This refactors the noise floor range checks to make them generic,
and adds proper ranges for each supported chip type.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar5008_phy.c |   11 +++++
 drivers/net/wireless/ath/ath9k/ar9002_phy.c |   32 +++++++++++---
 drivers/net/wireless/ath/ath9k/ar9002_phy.h |   26 +++++++++++
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |   66 ++++-----------------------
 drivers/net/wireless/ath/ath9k/calib.c      |   57 ++++++++++++++++-------
 drivers/net/wireless/ath/ath9k/calib.h      |    6 ---
 drivers/net/wireless/ath/ath9k/hw.c         |    3 -
 drivers/net/wireless/ath/ath9k/hw.h         |   14 ++++--
 8 files changed, 120 insertions(+), 95 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index 004cddd..9af0bf3 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -1678,6 +1678,15 @@ static void ar5008_hw_ani_cache_ini_regs(struct ath_hw *ah)
 	aniState->cycleCount = 0;
 }
 
+static void ar5008_hw_set_nf_limits(struct ath_hw *ah)
+{
+	ah->nf_2g.max = AR_PHY_CCA_MAX_GOOD_VAL_5416_2GHZ;
+	ah->nf_2g.min = AR_PHY_CCA_MIN_GOOD_VAL_5416_2GHZ;
+	ah->nf_2g.nominal = AR_PHY_CCA_NOM_VAL_5416_2GHZ;
+	ah->nf_5g.max = AR_PHY_CCA_MAX_GOOD_VAL_5416_5GHZ;
+	ah->nf_5g.min = AR_PHY_CCA_MIN_GOOD_VAL_5416_5GHZ;
+	ah->nf_5g.nominal = AR_PHY_CCA_NOM_VAL_5416_5GHZ;
+}
 
 void ar5008_hw_attach_phy_ops(struct ath_hw *ah)
 {
@@ -1715,4 +1724,6 @@ void ar5008_hw_attach_phy_ops(struct ath_hw *ah)
 		priv_ops->compute_pll_control = ar9160_hw_compute_pll_control;
 	else
 		priv_ops->compute_pll_control = ar5008_hw_compute_pll_control;
+
+	ar5008_hw_set_nf_limits(ah);
 }
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.c b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
index ed314e8..240e8a4 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
@@ -481,9 +481,6 @@ static void ar9002_hw_do_getnf(struct ath_hw *ah,
 	ath_print(common, ATH_DBG_CALIBRATE,
 		  "NF calibrated [ctl] [chain 0] is %d\n", nf);
 
-	if (AR_SREV_9271(ah) && (nf >= -114))
-		nf = -116;
-
 	nfarray[0] = nf;
 
 	if (!AR_SREV_9285(ah) && !AR_SREV_9271(ah)) {
@@ -503,9 +500,6 @@ static void ar9002_hw_do_getnf(struct ath_hw *ah,
 	ath_print(common, ATH_DBG_CALIBRATE,
 		  "NF calibrated [ext] [chain 0] is %d\n", nf);
 
-	if (AR_SREV_9271(ah) && (nf >= -114))
-		nf = -116;
-
 	nfarray[3] = nf;
 
 	if (!AR_SREV_9285(ah) && !AR_SREV_9271(ah)) {
@@ -520,6 +514,30 @@ static void ar9002_hw_do_getnf(struct ath_hw *ah,
 	}
 }
 
+static void ar9002_hw_set_nf_limits(struct ath_hw *ah)
+{
+	if (AR_SREV_9285(ah)) {
+		ah->nf_2g.max = AR_PHY_CCA_MAX_GOOD_VAL_9285_2GHZ;
+		ah->nf_2g.min = AR_PHY_CCA_MIN_GOOD_VAL_9285_2GHZ;
+		ah->nf_2g.nominal = AR_PHY_CCA_NOM_VAL_9285_2GHZ;
+	} else if (AR_SREV_9287(ah)) {
+		ah->nf_2g.max = AR_PHY_CCA_MAX_GOOD_VAL_9287_2GHZ;
+		ah->nf_2g.min = AR_PHY_CCA_MIN_GOOD_VAL_9287_2GHZ;
+		ah->nf_2g.nominal = AR_PHY_CCA_NOM_VAL_9287_2GHZ;
+	} else if (AR_SREV_9271(ah)) {
+		ah->nf_2g.max = AR_PHY_CCA_MAX_GOOD_VAL_9271_2GHZ;
+		ah->nf_2g.min = AR_PHY_CCA_MIN_GOOD_VAL_9271_2GHZ;
+		ah->nf_2g.nominal = AR_PHY_CCA_NOM_VAL_9271_2GHZ;
+	} else {
+		ah->nf_2g.max = AR_PHY_CCA_MAX_GOOD_VAL_9280_2GHZ;
+		ah->nf_2g.min = AR_PHY_CCA_MIN_GOOD_VAL_9280_2GHZ;
+		ah->nf_2g.nominal = AR_PHY_CCA_NOM_VAL_9280_2GHZ;
+		ah->nf_5g.max = AR_PHY_CCA_MAX_GOOD_VAL_9280_5GHZ;
+		ah->nf_5g.min = AR_PHY_CCA_MIN_GOOD_VAL_9280_5GHZ;
+		ah->nf_5g.nominal = AR_PHY_CCA_NOM_VAL_9280_5GHZ;
+	}
+}
+
 void ar9002_hw_attach_phy_ops(struct ath_hw *ah)
 {
 	struct ath_hw_private_ops *priv_ops = ath9k_hw_private_ops(ah);
@@ -532,4 +550,6 @@ void ar9002_hw_attach_phy_ops(struct ath_hw *ah)
 	priv_ops->olc_init = ar9002_olc_init;
 	priv_ops->compute_pll_control = ar9002_hw_compute_pll_control;
 	priv_ops->do_getnf = ar9002_hw_do_getnf;
+
+	ar9002_hw_set_nf_limits(ah);
 }
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.h b/drivers/net/wireless/ath/ath9k/ar9002_phy.h
index ce8bb00..c5151a4 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.h
@@ -576,4 +576,30 @@
 #define AR_PHY_CH2_EXT_MINCCA_PWR   0xFF800000
 #define AR_PHY_CH2_EXT_MINCCA_PWR_S 23
 
+#define AR_PHY_CCA_NOM_VAL_5416_2GHZ            -90
+#define AR_PHY_CCA_NOM_VAL_5416_5GHZ            -100
+#define AR_PHY_CCA_MIN_GOOD_VAL_5416_2GHZ     -100
+#define AR_PHY_CCA_MIN_GOOD_VAL_5416_5GHZ     -110
+#define AR_PHY_CCA_MAX_GOOD_VAL_5416_2GHZ     -80
+#define AR_PHY_CCA_MAX_GOOD_VAL_5416_5GHZ     -90
+
+#define AR_PHY_CCA_NOM_VAL_9280_2GHZ         -112
+#define AR_PHY_CCA_NOM_VAL_9280_5GHZ         -112
+#define AR_PHY_CCA_MIN_GOOD_VAL_9280_2GHZ  -127
+#define AR_PHY_CCA_MIN_GOOD_VAL_9280_5GHZ  -122
+#define AR_PHY_CCA_MAX_GOOD_VAL_9280_2GHZ  -97
+#define AR_PHY_CCA_MAX_GOOD_VAL_9280_5GHZ  -102
+
+#define AR_PHY_CCA_NOM_VAL_9285_2GHZ           -118
+#define AR_PHY_CCA_MIN_GOOD_VAL_9285_2GHZ    -127
+#define AR_PHY_CCA_MAX_GOOD_VAL_9285_2GHZ    -108
+
+#define AR_PHY_CCA_NOM_VAL_9271_2GHZ             -118
+#define AR_PHY_CCA_MIN_GOOD_VAL_9271_2GHZ      -127
+#define AR_PHY_CCA_MAX_GOOD_VAL_9271_2GHZ      -116
+
+#define AR_PHY_CCA_NOM_VAL_9287_2GHZ           -120
+#define AR_PHY_CCA_MIN_GOOD_VAL_9287_2GHZ    -127
+#define AR_PHY_CCA_MAX_GOOD_VAL_9287_2GHZ    -110
+
 #endif
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 19bc05c..a0bc1b7 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1015,52 +1015,6 @@ static bool ar9003_hw_ani_control(struct ath_hw *ah,
 	return true;
 }
 
-static void ar9003_hw_nf_sanitize_2g(struct ath_hw *ah, s16 *nf)
-{
-	struct ath_common *common = ath9k_hw_common(ah);
-
-	if (*nf > ah->nf_2g_max) {
-		ath_print(common, ATH_DBG_CALIBRATE,
-			  "2 GHz NF (%d) > MAX (%d), "
-			  "correcting to MAX",
-			  *nf, ah->nf_2g_max);
-		*nf = ah->nf_2g_max;
-	} else if (*nf < ah->nf_2g_min) {
-		ath_print(common, ATH_DBG_CALIBRATE,
-			  "2 GHz NF (%d) < MIN (%d), "
-			  "correcting to MIN",
-			  *nf, ah->nf_2g_min);
-		*nf = ah->nf_2g_min;
-	}
-}
-
-static void ar9003_hw_nf_sanitize_5g(struct ath_hw *ah, s16 *nf)
-{
-	struct ath_common *common = ath9k_hw_common(ah);
-
-	if (*nf > ah->nf_5g_max) {
-		ath_print(common, ATH_DBG_CALIBRATE,
-			  "5 GHz NF (%d) > MAX (%d), "
-			  "correcting to MAX",
-			  *nf, ah->nf_5g_max);
-		*nf = ah->nf_5g_max;
-	} else if (*nf < ah->nf_5g_min) {
-		ath_print(common, ATH_DBG_CALIBRATE,
-			  "5 GHz NF (%d) < MIN (%d), "
-			  "correcting to MIN",
-			  *nf, ah->nf_5g_min);
-		*nf = ah->nf_5g_min;
-	}
-}
-
-static void ar9003_hw_nf_sanitize(struct ath_hw *ah, s16 *nf)
-{
-	if (IS_CHAN_2GHZ(ah->curchan))
-		ar9003_hw_nf_sanitize_2g(ah, nf);
-	else
-		ar9003_hw_nf_sanitize_5g(ah, nf);
-}
-
 static void ar9003_hw_do_getnf(struct ath_hw *ah,
 			      int16_t nfarray[NUM_NF_READINGS])
 {
@@ -1070,7 +1024,6 @@ static void ar9003_hw_do_getnf(struct ath_hw *ah,
 	nf = MS(REG_READ(ah, AR_PHY_CCA_0), AR_PHY_MINCCA_PWR);
 	if (nf & 0x100)
 		nf = 0 - ((nf ^ 0x1ff) + 1);
-	ar9003_hw_nf_sanitize(ah, &nf);
 	ath_print(common, ATH_DBG_CALIBRATE,
 		  "NF calibrated [ctl] [chain 0] is %d\n", nf);
 	nfarray[0] = nf;
@@ -1078,7 +1031,6 @@ static void ar9003_hw_do_getnf(struct ath_hw *ah,
 	nf = MS(REG_READ(ah, AR_PHY_CCA_1), AR_PHY_CH1_MINCCA_PWR);
 	if (nf & 0x100)
 		nf = 0 - ((nf ^ 0x1ff) + 1);
-	ar9003_hw_nf_sanitize(ah, &nf);
 	ath_print(common, ATH_DBG_CALIBRATE,
 		  "NF calibrated [ctl] [chain 1] is %d\n", nf);
 	nfarray[1] = nf;
@@ -1086,7 +1038,6 @@ static void ar9003_hw_do_getnf(struct ath_hw *ah,
 	nf = MS(REG_READ(ah, AR_PHY_CCA_2), AR_PHY_CH2_MINCCA_PWR);
 	if (nf & 0x100)
 		nf = 0 - ((nf ^ 0x1ff) + 1);
-	ar9003_hw_nf_sanitize(ah, &nf);
 	ath_print(common, ATH_DBG_CALIBRATE,
 		  "NF calibrated [ctl] [chain 2] is %d\n", nf);
 	nfarray[2] = nf;
@@ -1094,7 +1045,6 @@ static void ar9003_hw_do_getnf(struct ath_hw *ah,
 	nf = MS(REG_READ(ah, AR_PHY_EXT_CCA), AR_PHY_EXT_MINCCA_PWR);
 	if (nf & 0x100)
 		nf = 0 - ((nf ^ 0x1ff) + 1);
-	ar9003_hw_nf_sanitize(ah, &nf);
 	ath_print(common, ATH_DBG_CALIBRATE,
 		  "NF calibrated [ext] [chain 0] is %d\n", nf);
 	nfarray[3] = nf;
@@ -1102,7 +1052,6 @@ static void ar9003_hw_do_getnf(struct ath_hw *ah,
 	nf = MS(REG_READ(ah, AR_PHY_EXT_CCA_1), AR_PHY_CH1_EXT_MINCCA_PWR);
 	if (nf & 0x100)
 		nf = 0 - ((nf ^ 0x1ff) + 1);
-	ar9003_hw_nf_sanitize(ah, &nf);
 	ath_print(common, ATH_DBG_CALIBRATE,
 		  "NF calibrated [ext] [chain 1] is %d\n", nf);
 	nfarray[4] = nf;
@@ -1110,18 +1059,19 @@ static void ar9003_hw_do_getnf(struct ath_hw *ah,
 	nf = MS(REG_READ(ah, AR_PHY_EXT_CCA_2), AR_PHY_CH2_EXT_MINCCA_PWR);
 	if (nf & 0x100)
 		nf = 0 - ((nf ^ 0x1ff) + 1);
-	ar9003_hw_nf_sanitize(ah, &nf);
 	ath_print(common, ATH_DBG_CALIBRATE,
 		  "NF calibrated [ext] [chain 2] is %d\n", nf);
 	nfarray[5] = nf;
 }
 
-void ar9003_hw_set_nf_limits(struct ath_hw *ah)
+static void ar9003_hw_set_nf_limits(struct ath_hw *ah)
 {
-	ah->nf_2g_max = AR_PHY_CCA_MAX_GOOD_VAL_9300_2GHZ;
-	ah->nf_2g_min = AR_PHY_CCA_MIN_GOOD_VAL_9300_2GHZ;
-	ah->nf_5g_max = AR_PHY_CCA_MAX_GOOD_VAL_9300_5GHZ;
-	ah->nf_5g_min = AR_PHY_CCA_MIN_GOOD_VAL_9300_5GHZ;
+	ah->nf_2g.max = AR_PHY_CCA_MAX_GOOD_VAL_9300_2GHZ;
+	ah->nf_2g.min = AR_PHY_CCA_MIN_GOOD_VAL_9300_2GHZ;
+	ah->nf_2g.nominal = AR_PHY_CCA_NOM_VAL_9300_2GHZ;
+	ah->nf_5g.max = AR_PHY_CCA_MAX_GOOD_VAL_9300_5GHZ;
+	ah->nf_5g.min = AR_PHY_CCA_MIN_GOOD_VAL_9300_5GHZ;
+	ah->nf_5g.nominal = AR_PHY_CCA_NOM_VAL_9300_5GHZ;
 }
 
 /*
@@ -1309,6 +1259,8 @@ void ar9003_hw_attach_phy_ops(struct ath_hw *ah)
 	priv_ops->do_getnf = ar9003_hw_do_getnf;
 	priv_ops->loadnf = ar9003_hw_loadnf;
 	priv_ops->ani_cache_ini_regs = ar9003_hw_ani_cache_ini_regs;
+
+	ar9003_hw_set_nf_limits(ah);
 }
 
 void ar9003_hw_bb_watchdog_config(struct ath_hw *ah)
diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index 07b8fa6..7f49b75 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -74,13 +74,8 @@ static void ath9k_hw_update_nfcal_hist_buffer(struct ath9k_nfcal_hist *h,
 			h[i].currIndex = 0;
 
 		if (h[i].invalidNFcount > 0) {
-			if (nfarray[i] < AR_PHY_CCA_MIN_BAD_VALUE ||
-			    nfarray[i] > AR_PHY_CCA_MAX_HIGH_VALUE) {
-				h[i].invalidNFcount = ATH9K_NF_CAL_HIST_MAX;
-			} else {
-				h[i].invalidNFcount--;
-				h[i].privNF = nfarray[i];
-			}
+			h[i].invalidNFcount--;
+			h[i].privNF = nfarray[i];
 		} else {
 			h[i].privNF =
 				ath9k_hw_get_nf_hist_mid(h[i].nfCalBuffer);
@@ -172,6 +167,35 @@ void ath9k_hw_start_nfcal(struct ath_hw *ah)
 	REG_SET_BIT(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_NF);
 }
 
+static void ath9k_hw_nf_sanitize(struct ath_hw *ah, s16 *nf)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+	struct ath_nf_limits *limit;
+	int i;
+
+	if (IS_CHAN_2GHZ(ah->curchan))
+		limit = &ah->nf_2g;
+	else
+		limit = &ah->nf_5g;
+
+	for (i = 0; i < NUM_NF_READINGS; i++) {
+		if (!nf[i])
+			continue;
+
+		if (nf[i] > limit->max) {
+			ath_print(common, ATH_DBG_CALIBRATE,
+				  "NF[%d] (%d) > MAX (%d), correcting to MAX",
+				  i, nf[i], limit->max);
+			nf[i] = limit->max;
+		} else if (nf[i] < limit->min) {
+			ath_print(common, ATH_DBG_CALIBRATE,
+				  "NF[%d] (%d) < MIN (%d), correcting to NOM",
+				  i, nf[i], limit->min);
+			nf[i] = limit->nominal;
+		}
+	}
+}
+
 int16_t ath9k_hw_getnf(struct ath_hw *ah,
 		       struct ath9k_channel *chan)
 {
@@ -190,6 +214,7 @@ int16_t ath9k_hw_getnf(struct ath_hw *ah,
 		return chan->rawNoiseFloor;
 	} else {
 		ath9k_hw_do_getnf(ah, nfarray);
+		ath9k_hw_nf_sanitize(ah, nfarray);
 		nf = nfarray[0];
 		if (ath9k_hw_get_nf_thresh(ah, c->band, &nfThresh)
 		    && nf > nfThresh) {
@@ -211,25 +236,21 @@ int16_t ath9k_hw_getnf(struct ath_hw *ah,
 
 void ath9k_init_nfcal_hist_buffer(struct ath_hw *ah)
 {
+	struct ath_nf_limits *limit;
 	int i, j;
-	s16 noise_floor;
-
-	if (AR_SREV_9280(ah))
-		noise_floor = AR_PHY_CCA_MAX_AR9280_GOOD_VALUE;
-	else if (AR_SREV_9285(ah) || AR_SREV_9271(ah))
-		noise_floor = AR_PHY_CCA_MAX_AR9285_GOOD_VALUE;
-	else if (AR_SREV_9287(ah))
-		noise_floor = AR_PHY_CCA_MAX_AR9287_GOOD_VALUE;
+
+	if (!ah->curchan || IS_CHAN_2GHZ(ah->curchan))
+		limit = &ah->nf_2g;
 	else
-		noise_floor = AR_PHY_CCA_MAX_AR5416_GOOD_VALUE;
+		limit = &ah->nf_5g;
 
 	for (i = 0; i < NUM_NF_READINGS; i++) {
 		ah->nfCalHist[i].currIndex = 0;
-		ah->nfCalHist[i].privNF = noise_floor;
+		ah->nfCalHist[i].privNF = limit->nominal;
 		ah->nfCalHist[i].invalidNFcount =
 			AR_PHY_CCA_FILTERWINDOW_LENGTH;
 		for (j = 0; j < ATH9K_NF_CAL_HIST_MAX; j++) {
-			ah->nfCalHist[i].nfCalBuffer[j] = noise_floor;
+			ah->nfCalHist[i].nfCalBuffer[j] = limit->nominal;
 		}
 	}
 }
diff --git a/drivers/net/wireless/ath/ath9k/calib.h b/drivers/net/wireless/ath/ath9k/calib.h
index 24538bd..ca4638d 100644
--- a/drivers/net/wireless/ath/ath9k/calib.h
+++ b/drivers/net/wireless/ath/ath9k/calib.h
@@ -19,12 +19,6 @@
 
 #include "hw.h"
 
-#define AR_PHY_CCA_MAX_AR5416_GOOD_VALUE	-85
-#define AR_PHY_CCA_MAX_AR9280_GOOD_VALUE	-112
-#define AR_PHY_CCA_MAX_AR9285_GOOD_VALUE	-118
-#define AR_PHY_CCA_MAX_AR9287_GOOD_VALUE	-118
-#define AR_PHY_CCA_MAX_HIGH_VALUE      		-62
-#define AR_PHY_CCA_MIN_BAD_VALUE       		-140
 #define AR_PHY_CCA_FILTERWINDOW_LENGTH_INIT     3
 #define AR_PHY_CCA_FILTERWINDOW_LENGTH          5
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 3ed5c9e..2acd799 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -609,9 +609,6 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 	else
 		ah->tx_trig_level = (AR_FTRIG_512B >> AR_FTRIG_S);
 
-	if (AR_SREV_9300_20_OR_LATER(ah))
-		ar9003_hw_set_nf_limits(ah);
-
 	ath9k_init_nfcal_hist_buffer(ah);
 	ah->bb_watchdog_timeout_ms = 25;
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index bb99e2e..6a4b692 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -630,6 +630,12 @@ struct ath_hw_ops {
 	void (*ani_monitor)(struct ath_hw *ah, struct ath9k_channel *chan);
 };
 
+struct ath_nf_limits {
+	s16 max;
+	s16 min;
+	s16 nominal;
+};
+
 struct ath_hw {
 	struct ieee80211_hw *hw;
 	struct ath_common common;
@@ -651,10 +657,9 @@ struct ath_hw {
 	bool is_pciexpress;
 	bool need_an_top2_fixup;
 	u16 tx_trig_level;
-	s16 nf_2g_max;
-	s16 nf_2g_min;
-	s16 nf_5g_max;
-	s16 nf_5g_min;
+
+	struct ath_nf_limits nf_2g;
+	struct ath_nf_limits nf_5g;
 	u16 rfsilent;
 	u32 rfkill_gpio;
 	u32 rfkill_polarity;
@@ -943,7 +948,6 @@ void ar9002_hw_enable_wep_aggregation(struct ath_hw *ah);
  * Code specific to AR9003, we stuff these here to avoid callbacks
  * for older families
  */
-void ar9003_hw_set_nf_limits(struct ath_hw *ah);
 void ar9003_hw_bb_watchdog_config(struct ath_hw *ah);
 void ar9003_hw_bb_watchdog_read(struct ath_hw *ah);
 void ar9003_hw_bb_watchdog_dbg_info(struct ath_hw *ah);
-- 
1.6.4.2

