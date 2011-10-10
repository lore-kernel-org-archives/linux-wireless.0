Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:32349 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab1JJFvT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 01:51:19 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH v2 06/13] ath9k_hw: Add support to reuse Carrier leak calibration
Date: Mon, 10 Oct 2011 11:21:11 +0530
Message-ID: <1318225878-7283-6-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20111010_075122_014475_BE62CAD7)
In-Reply-To: <1318225878-7283-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1318225878-7283-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds support to reuse Carrier leak calibration
during fast channel change for AR9480 chips.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c |   46 +++++++++++++++++++++++-
 drivers/net/wireless/ath/ath9k/hw.c           |    4 ++-
 drivers/net/wireless/ath/ath9k/hw.h           |    3 ++
 3 files changed, 50 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 6d68566..5f40638 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -905,8 +905,23 @@ static bool ar9003_hw_init_cal(struct ath_hw *ah,
 {
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_hw_cal_data *caldata = ah->caldata;
-	bool txiqcal_done = false;
-	bool is_reusable = true;
+	bool txiqcal_done = false, txclcal_done = false;
+	bool is_reusable = true, txclcal_enabled;
+	u32 cl_idx[AR9300_MAX_CHAINS] = { AR_PHY_CL_TAB_0,
+					  AR_PHY_CL_TAB_1,
+					  AR_PHY_CL_TAB_2 };
+
+	txclcal_enabled = !!(REG_READ(ah, AR_PHY_CL_CAL_CTL) &
+				      AR_PHY_CL_CAL_ENABLE);
+
+	if (txclcal_enabled) {
+		if (caldata && caldata->done_txclcal_once)
+			REG_CLR_BIT(ah, AR_PHY_CL_CAL_CTL,
+				    AR_PHY_CL_CAL_ENABLE);
+		else
+			REG_SET_BIT(ah, AR_PHY_CL_CAL_CTL,
+				    AR_PHY_CL_CAL_ENABLE);
+	}
 
 	/* Do Tx IQ Calibration */
 	REG_RMW_FIELD(ah, AR_PHY_TX_IQCAL_CONTROL_1,
@@ -950,6 +965,33 @@ static bool ar9003_hw_init_cal(struct ath_hw *ah,
 	else if (caldata && caldata->done_txiqcal_once)
 		ar9003_hw_tx_iq_cal_reload(ah);
 
+#define CL_TAB_ENTRY(reg_base)	(reg_base + (4 * j))
+	if (caldata && txclcal_enabled) {
+		int i, j;
+		txclcal_done = !!(REG_READ(ah, AR_PHY_AGC_CONTROL) &
+					   AR_PHY_AGC_CONTROL_CLC_SUCCESS);
+		if (caldata->done_txclcal_once) {
+			for (i = 0; i < AR9300_MAX_CHAINS; i++) {
+				if (!(ah->txchainmask & (1 << i)))
+					continue;
+				for (j = 0; j < MAX_CL_TAB_ENTRY; j++)
+					REG_WRITE(ah, CL_TAB_ENTRY(cl_idx[i]),
+						  caldata->tx_clcal[i][j]);
+			}
+		} else if (is_reusable && txclcal_done) {
+			for (i = 0; i < AR9300_MAX_CHAINS; i++) {
+				if (!(ah->txchainmask & (1 << i)))
+					continue;
+				for (j = 0; j < MAX_CL_TAB_ENTRY; j++)
+					caldata->tx_clcal[i][j] =
+						REG_READ(ah,
+						  CL_TAB_ENTRY(cl_idx[i]));
+			}
+			caldata->done_txclcal_once = true;
+		}
+	}
+#undef CL_TAB_ENTRY
+
 	ath9k_hw_loadnf(ah, chan);
 	ath9k_hw_start_nfcal(ah, true);
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index a71e14a..e2cae1a 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1714,8 +1714,10 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 
 	ath9k_hw_init_bb(ah, chan);
 
-	if (caldata)
+	if (caldata) {
 		caldata->done_txiqcal_once = false;
+		caldata->done_txclcal_once = false;
+	}
 	if (!ath9k_hw_init_cal(ah, chan))
 		return -EIO;
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 04db968..0a8aef9 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -338,6 +338,7 @@ enum ath9k_int {
 	 CHANNEL_HT40MINUS)
 
 #define MAX_IQCAL_MEASUREMENT	8
+#define MAX_CL_TAB_ENTRY	16
 
 struct ath9k_hw_cal_data {
 	u16 channel;
@@ -349,10 +350,12 @@ struct ath9k_hw_cal_data {
 	bool nfcal_pending;
 	bool nfcal_interference;
 	bool done_txiqcal_once;
+	bool done_txclcal_once;
 	u16 small_signal_gain[AR9300_MAX_CHAINS];
 	u32 pa_table[AR9300_MAX_CHAINS][PAPRD_TABLE_SZ];
 	u32 num_measures[AR9300_MAX_CHAINS];
 	int tx_corr_coeff[MAX_IQCAL_MEASUREMENT][AR9300_MAX_CHAINS];
+	u32 tx_clcal[AR9300_MAX_CHAINS][MAX_CL_TAB_ENTRY];
 	struct ath9k_nfcal_hist nfCalHist[NUM_NF_READINGS];
 };
 
-- 
1.7.7

