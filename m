Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:49988 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933503Ab0GAWKG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Jul 2010 18:10:06 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 5/6] ath9k_hw: clean up the noise floor calibration code to reduce code duplication
Date: Fri,  2 Jul 2010 00:09:51 +0200
Message-Id: <1278022192-83277-5-git-send-email-nbd@openwrt.org>
In-Reply-To: <1278022192-83277-4-git-send-email-nbd@openwrt.org>
References: <1278022192-83277-1-git-send-email-nbd@openwrt.org>
 <1278022192-83277-2-git-send-email-nbd@openwrt.org>
 <1278022192-83277-3-git-send-email-nbd@openwrt.org>
 <1278022192-83277-4-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar5008_phy.c |   37 ++++-------------------
 drivers/net/wireless/ath/ath9k/ar9002_phy.c |   43 +++++---------------------
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |   37 ++++-------------------
 drivers/net/wireless/ath/ath9k/calib.c      |    4 ++
 drivers/net/wireless/ath/ath9k/hw.h         |    6 ++++
 5 files changed, 31 insertions(+), 96 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index 9af0bf3..101c89c 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -1497,50 +1497,25 @@ static bool ar5008_hw_ani_control_new(struct ath_hw *ah,
 static void ar5008_hw_do_getnf(struct ath_hw *ah,
 			      int16_t nfarray[NUM_NF_READINGS])
 {
-	struct ath_common *common = ath9k_hw_common(ah);
 	int16_t nf;
 
 	nf = MS(REG_READ(ah, AR_PHY_CCA), AR_PHY_MINCCA_PWR);
-	if (nf & 0x100)
-		nf = 0 - ((nf ^ 0x1ff) + 1);
-	ath_print(common, ATH_DBG_CALIBRATE,
-		  "NF calibrated [ctl] [chain 0] is %d\n", nf);
-	nfarray[0] = nf;
+	nfarray[0] = sign_extend(nf, 9);
 
 	nf = MS(REG_READ(ah, AR_PHY_CH1_CCA), AR_PHY_CH1_MINCCA_PWR);
-	if (nf & 0x100)
-		nf = 0 - ((nf ^ 0x1ff) + 1);
-	ath_print(common, ATH_DBG_CALIBRATE,
-		  "NF calibrated [ctl] [chain 1] is %d\n", nf);
-	nfarray[1] = nf;
+	nfarray[1] = sign_extend(nf, 9);
 
 	nf = MS(REG_READ(ah, AR_PHY_CH2_CCA), AR_PHY_CH2_MINCCA_PWR);
-	if (nf & 0x100)
-		nf = 0 - ((nf ^ 0x1ff) + 1);
-	ath_print(common, ATH_DBG_CALIBRATE,
-		  "NF calibrated [ctl] [chain 2] is %d\n", nf);
-	nfarray[2] = nf;
+	nfarray[2] = sign_extend(nf, 9);
 
 	nf = MS(REG_READ(ah, AR_PHY_EXT_CCA), AR_PHY_EXT_MINCCA_PWR);
-	if (nf & 0x100)
-		nf = 0 - ((nf ^ 0x1ff) + 1);
-	ath_print(common, ATH_DBG_CALIBRATE,
-		  "NF calibrated [ext] [chain 0] is %d\n", nf);
-	nfarray[3] = nf;
+	nfarray[3] = sign_extend(nf, 9);
 
 	nf = MS(REG_READ(ah, AR_PHY_CH1_EXT_CCA), AR_PHY_CH1_EXT_MINCCA_PWR);
-	if (nf & 0x100)
-		nf = 0 - ((nf ^ 0x1ff) + 1);
-	ath_print(common, ATH_DBG_CALIBRATE,
-		  "NF calibrated [ext] [chain 1] is %d\n", nf);
-	nfarray[4] = nf;
+	nfarray[4] = sign_extend(nf, 9);
 
 	nf = MS(REG_READ(ah, AR_PHY_CH2_EXT_CCA), AR_PHY_CH2_EXT_MINCCA_PWR);
-	if (nf & 0x100)
-		nf = 0 - ((nf ^ 0x1ff) + 1);
-	ath_print(common, ATH_DBG_CALIBRATE,
-		  "NF calibrated [ext] [chain 2] is %d\n", nf);
-	nfarray[5] = nf;
+	nfarray[5] = sign_extend(nf, 9);
 }
 
 static void ar5008_hw_loadnf(struct ath_hw *ah, struct ath9k_channel *chan)
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.c b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
index 240e8a4..4922b8d 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
@@ -471,47 +471,22 @@ static u32 ar9002_hw_compute_pll_control(struct ath_hw *ah,
 static void ar9002_hw_do_getnf(struct ath_hw *ah,
 			      int16_t nfarray[NUM_NF_READINGS])
 {
-	struct ath_common *common = ath9k_hw_common(ah);
 	int16_t nf;
 
 	nf = MS(REG_READ(ah, AR_PHY_CCA), AR9280_PHY_MINCCA_PWR);
+	nfarray[0] = sign_extend(nf, 9);
 
-	if (nf & 0x100)
-		nf = 0 - ((nf ^ 0x1ff) + 1);
-	ath_print(common, ATH_DBG_CALIBRATE,
-		  "NF calibrated [ctl] [chain 0] is %d\n", nf);
-
-	nfarray[0] = nf;
+	nf = MS(REG_READ(ah, AR_PHY_EXT_CCA), AR9280_PHY_EXT_MINCCA_PWR);
+	nfarray[3] = sign_extend(nf, 9);
 
-	if (!AR_SREV_9285(ah) && !AR_SREV_9271(ah)) {
-		nf = MS(REG_READ(ah, AR_PHY_CH1_CCA),
-				AR9280_PHY_CH1_MINCCA_PWR);
+	if (AR_SREV_9285(ah) || AR_SREV_9271(ah))
+		return;
 
-		if (nf & 0x100)
-			nf = 0 - ((nf ^ 0x1ff) + 1);
-		ath_print(common, ATH_DBG_CALIBRATE,
-			  "NF calibrated [ctl] [chain 1] is %d\n", nf);
-		nfarray[1] = nf;
-	}
+	nf = MS(REG_READ(ah, AR_PHY_CH1_CCA), AR9280_PHY_CH1_MINCCA_PWR);
+	nfarray[1] = sign_extend(nf, 9);
 
-	nf = MS(REG_READ(ah, AR_PHY_EXT_CCA), AR9280_PHY_EXT_MINCCA_PWR);
-	if (nf & 0x100)
-		nf = 0 - ((nf ^ 0x1ff) + 1);
-	ath_print(common, ATH_DBG_CALIBRATE,
-		  "NF calibrated [ext] [chain 0] is %d\n", nf);
-
-	nfarray[3] = nf;
-
-	if (!AR_SREV_9285(ah) && !AR_SREV_9271(ah)) {
-		nf = MS(REG_READ(ah, AR_PHY_CH1_EXT_CCA),
-				AR9280_PHY_CH1_EXT_MINCCA_PWR);
-
-		if (nf & 0x100)
-			nf = 0 - ((nf ^ 0x1ff) + 1);
-		ath_print(common, ATH_DBG_CALIBRATE,
-			  "NF calibrated [ext] [chain 1] is %d\n", nf);
-		nfarray[4] = nf;
-	}
+	nf = MS(REG_READ(ah, AR_PHY_CH1_EXT_CCA), AR9280_PHY_CH1_EXT_MINCCA_PWR);
+	nfarray[4] = sign_extend(nf, 9);
 }
 
 static void ar9002_hw_set_nf_limits(struct ath_hw *ah)
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index a0bc1b7..868b24a 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1018,50 +1018,25 @@ static bool ar9003_hw_ani_control(struct ath_hw *ah,
 static void ar9003_hw_do_getnf(struct ath_hw *ah,
 			      int16_t nfarray[NUM_NF_READINGS])
 {
-	struct ath_common *common = ath9k_hw_common(ah);
 	int16_t nf;
 
 	nf = MS(REG_READ(ah, AR_PHY_CCA_0), AR_PHY_MINCCA_PWR);
-	if (nf & 0x100)
-		nf = 0 - ((nf ^ 0x1ff) + 1);
-	ath_print(common, ATH_DBG_CALIBRATE,
-		  "NF calibrated [ctl] [chain 0] is %d\n", nf);
-	nfarray[0] = nf;
+	nfarray[0] = sign_extend(nf, 9);
 
 	nf = MS(REG_READ(ah, AR_PHY_CCA_1), AR_PHY_CH1_MINCCA_PWR);
-	if (nf & 0x100)
-		nf = 0 - ((nf ^ 0x1ff) + 1);
-	ath_print(common, ATH_DBG_CALIBRATE,
-		  "NF calibrated [ctl] [chain 1] is %d\n", nf);
-	nfarray[1] = nf;
+	nfarray[1] = sign_extend(nf, 9);
 
 	nf = MS(REG_READ(ah, AR_PHY_CCA_2), AR_PHY_CH2_MINCCA_PWR);
-	if (nf & 0x100)
-		nf = 0 - ((nf ^ 0x1ff) + 1);
-	ath_print(common, ATH_DBG_CALIBRATE,
-		  "NF calibrated [ctl] [chain 2] is %d\n", nf);
-	nfarray[2] = nf;
+	nfarray[2] = sign_extend(nf, 9);
 
 	nf = MS(REG_READ(ah, AR_PHY_EXT_CCA), AR_PHY_EXT_MINCCA_PWR);
-	if (nf & 0x100)
-		nf = 0 - ((nf ^ 0x1ff) + 1);
-	ath_print(common, ATH_DBG_CALIBRATE,
-		  "NF calibrated [ext] [chain 0] is %d\n", nf);
-	nfarray[3] = nf;
+	nfarray[3] = sign_extend(nf, 9);
 
 	nf = MS(REG_READ(ah, AR_PHY_EXT_CCA_1), AR_PHY_CH1_EXT_MINCCA_PWR);
-	if (nf & 0x100)
-		nf = 0 - ((nf ^ 0x1ff) + 1);
-	ath_print(common, ATH_DBG_CALIBRATE,
-		  "NF calibrated [ext] [chain 1] is %d\n", nf);
-	nfarray[4] = nf;
+	nfarray[4] = sign_extend(nf, 9);
 
 	nf = MS(REG_READ(ah, AR_PHY_EXT_CCA_2), AR_PHY_CH2_EXT_MINCCA_PWR);
-	if (nf & 0x100)
-		nf = 0 - ((nf ^ 0x1ff) + 1);
-	ath_print(common, ATH_DBG_CALIBRATE,
-		  "NF calibrated [ext] [chain 2] is %d\n", nf);
-	nfarray[5] = nf;
+	nfarray[5] = sign_extend(nf, 9);
 }
 
 static void ar9003_hw_set_nf_limits(struct ath_hw *ah)
diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index 7f49b75..cc29ef7 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -182,6 +182,10 @@ static void ath9k_hw_nf_sanitize(struct ath_hw *ah, s16 *nf)
 		if (!nf[i])
 			continue;
 
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "NF calibrated [%s] [chain %d] is %d\n",
+			  (i > 3 ? "ext" : "ctl"), i % 3, nf[i]);
+
 		if (nf[i] > limit->max) {
 			ath_print(common, ATH_DBG_CALIBRATE,
 				  "NF[%d] (%d) > MAX (%d), correcting to MAX",
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 6a4b692..92e2502 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -853,6 +853,12 @@ static inline struct ath_hw_ops *ath9k_hw_ops(struct ath_hw *ah)
 	return &ah->ops;
 }
 
+static inline int sign_extend(int val, const int nbits)
+{
+	int order = BIT(nbits-1);
+	return (val ^ order) - order;
+}
+
 /* Initialization, Detach, Reset */
 const char *ath9k_hw_probe(u16 vendorid, u16 devid);
 void ath9k_hw_deinit(struct ath_hw *ah);
-- 
1.6.4.2

