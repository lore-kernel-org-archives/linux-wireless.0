Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sg2plsmtpa01-01.prod.sin2.secureserver.net ([182.50.145.6]:37816
	"EHLO sg2plsmtpa01-01.prod.sin2.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808Ab3AGJOd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jan 2013 04:14:33 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2] ath9k_hw: Use helper routines to simplify ar9003_hw_init_cal()
Date: Mon,  7 Jan 2013 14:43:33 +0530
Message-Id: <1357550013-26317-1-git-send-email-sujith@msujith.org> (sfid-20130107_101440_080491_79EC0AD8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c | 92 ++++++++++++++++-----------
 drivers/net/wireless/ath/ath9k/hw.h           |  1 +
 2 files changed, 55 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 15f9b89..9221f32 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -960,22 +960,68 @@ static void ar9003_hw_manual_peak_cal(struct ath_hw *ah, u8 chain, bool is_2g)
 		      AR_PHY_65NM_RXRF_AGC_AGC_CAL_OVR, 0);
 }
 
+static void ar9003_hw_do_manual_peak_cal(struct ath_hw *ah,
+					 struct ath9k_channel *chan)
+{
+	int i;
+
+	if (!AR_SREV_9462(ah) && !AR_SREV_9565(ah))
+		return;
+
+	for (i = 0; i < AR9300_MAX_CHAINS; i++) {
+		if (!(ah->rxchainmask & (1 << i)))
+			continue;
+		ar9003_hw_manual_peak_cal(ah, i, IS_CHAN_2GHZ(chan));
+	}
+}
+
+static void ar9003_hw_cl_cal_post_proc(struct ath_hw *ah, bool is_reusable)
+{
+	u32 cl_idx[AR9300_MAX_CHAINS] = { AR_PHY_CL_TAB_0,
+					  AR_PHY_CL_TAB_1,
+					  AR_PHY_CL_TAB_2 };
+	struct ath9k_hw_cal_data *caldata = ah->caldata;
+	bool txclcal_done = false;
+	int i, j;
+
+	if (!caldata || !(ah->enabled_cals & TX_CL_CAL))
+		return;
+
+	txclcal_done = !!(REG_READ(ah, AR_PHY_AGC_CONTROL) &
+			  AR_PHY_AGC_CONTROL_CLC_SUCCESS);
+
+	if (caldata->done_txclcal_once) {
+		for (i = 0; i < AR9300_MAX_CHAINS; i++) {
+			if (!(ah->txchainmask & (1 << i)))
+				continue;
+			for (j = 0; j < MAX_CL_TAB_ENTRY; j++)
+				REG_WRITE(ah, CL_TAB_ENTRY(cl_idx[i]),
+					  caldata->tx_clcal[i][j]);
+		}
+	} else if (is_reusable && txclcal_done) {
+		for (i = 0; i < AR9300_MAX_CHAINS; i++) {
+			if (!(ah->txchainmask & (1 << i)))
+				continue;
+			for (j = 0; j < MAX_CL_TAB_ENTRY; j++)
+				caldata->tx_clcal[i][j] =
+					REG_READ(ah, CL_TAB_ENTRY(cl_idx[i]));
+		}
+		caldata->done_txclcal_once = true;
+	}
+}
+
 static bool ar9003_hw_init_cal(struct ath_hw *ah,
 			       struct ath9k_channel *chan)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_hw_cal_data *caldata = ah->caldata;
-	bool txiqcal_done = false, txclcal_done = false;
+	bool txiqcal_done = false;
 	bool is_reusable = true, status = true;
 	bool run_rtt_cal = false, run_agc_cal, sep_iq_cal = false;
 	bool rtt = !!(ah->caps.hw_caps & ATH9K_HW_CAP_RTT);
 	u32 agc_ctrl = 0, agc_supp_cals = AR_PHY_AGC_CONTROL_OFFSET_CAL |
 					  AR_PHY_AGC_CONTROL_FLTR_CAL   |
 					  AR_PHY_AGC_CONTROL_PKDET_CAL;
-	int i, j;
-	u32 cl_idx[AR9300_MAX_CHAINS] = { AR_PHY_CL_TAB_0,
-					  AR_PHY_CL_TAB_1,
-					  AR_PHY_CL_TAB_2 };
 
 	if (rtt) {
 		if (!ar9003_hw_rtt_restore(ah, chan))
@@ -1060,14 +1106,8 @@ skip_tx_iqcal:
 		status = ath9k_hw_wait(ah, AR_PHY_AGC_CONTROL,
 				       AR_PHY_AGC_CONTROL_CAL,
 				       0, AH_WAIT_TIMEOUT);
-		if (AR_SREV_9462(ah) || AR_SREV_9565(ah)) {
-			for (i = 0; i < AR9300_MAX_CHAINS; i++) {
-				if (!(ah->rxchainmask & (1 << i)))
-					continue;
-				ar9003_hw_manual_peak_cal(ah, i,
-							  IS_CHAN_2GHZ(chan));
-			}
-		}
+
+		ar9003_hw_do_manual_peak_cal(ah, chan);
 	}
 
 	if (ath9k_hw_mci_is_enabled(ah) && IS_CHAN_2GHZ(chan) && run_agc_cal)
@@ -1092,31 +1132,7 @@ skip_tx_iqcal:
 	else if (caldata && caldata->done_txiqcal_once)
 		ar9003_hw_tx_iq_cal_reload(ah);
 
-#define CL_TAB_ENTRY(reg_base)	(reg_base + (4 * j))
-	if (caldata && (ah->enabled_cals & TX_CL_CAL)) {
-		txclcal_done = !!(REG_READ(ah, AR_PHY_AGC_CONTROL) &
-					   AR_PHY_AGC_CONTROL_CLC_SUCCESS);
-		if (caldata->done_txclcal_once) {
-			for (i = 0; i < AR9300_MAX_CHAINS; i++) {
-				if (!(ah->txchainmask & (1 << i)))
-					continue;
-				for (j = 0; j < MAX_CL_TAB_ENTRY; j++)
-					REG_WRITE(ah, CL_TAB_ENTRY(cl_idx[i]),
-						  caldata->tx_clcal[i][j]);
-			}
-		} else if (is_reusable && txclcal_done) {
-			for (i = 0; i < AR9300_MAX_CHAINS; i++) {
-				if (!(ah->txchainmask & (1 << i)))
-					continue;
-				for (j = 0; j < MAX_CL_TAB_ENTRY; j++)
-					caldata->tx_clcal[i][j] =
-						REG_READ(ah,
-						  CL_TAB_ENTRY(cl_idx[i]));
-			}
-			caldata->done_txclcal_once = true;
-		}
-	}
-#undef CL_TAB_ENTRY
+	ar9003_hw_cl_cal_post_proc(ah, is_reusable);
 
 	if (run_rtt_cal && caldata) {
 		if (is_reusable) {
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 809599c..f5332b1 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -397,6 +397,7 @@ enum ath9k_int {
 #define MAX_RTT_TABLE_ENTRY     6
 #define MAX_IQCAL_MEASUREMENT	8
 #define MAX_CL_TAB_ENTRY	16
+#define CL_TAB_ENTRY(reg_base)	(reg_base + (4 * j))
 
 struct ath9k_hw_cal_data {
 	u16 channel;
-- 
1.8.1

