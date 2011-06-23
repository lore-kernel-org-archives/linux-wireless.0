Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:36899 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755342Ab1FWOeN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jun 2011 10:34:13 -0400
Received: from mail.atheros.com ([10.234.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jun 2011 07:33:37 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <rodrigue@qca.qualcomm.com>,
	<senthilb@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	<muddin@qca.qualcomm.com>
Subject: [PATCH] ath9k_hw: Add carrier leak correction in desired gain calculation
Date: Thu, 23 Jun 2011 20:03:38 +0530
Message-ID: <1308839618-15190-1-git-send-email-mshajakhan@atheros.com> (sfid-20110623_163417_020048_A143CAC0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Cc: muddin@qca.qualcomm.com
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_paprd.c |   34 +++++++++++++++++-------
 drivers/net/wireless/ath/ath9k/ar9003_phy.h   |    3 ++
 2 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
index 8f6d11d..6e9e892 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
@@ -246,13 +246,13 @@ static void ar9003_paprd_get_gain_table(struct ath_hw *ah)
 static unsigned int ar9003_get_desired_gain(struct ath_hw *ah, int chain,
 					    int target_power)
 {
-	int olpc_gain_delta = 0;
+	int olpc_gain_delta = 0, cl_gain_mod;
 	int alpha_therm, alpha_volt;
 	int therm_cal_value, volt_cal_value;
 	int therm_value, volt_value;
 	int thermal_gain_corr, voltage_gain_corr;
 	int desired_scale, desired_gain = 0;
-	u32 reg;
+	u32 reg_olpc  = 0, reg_cl_gain  = 0;
 
 	REG_CLR_BIT(ah, AR_PHY_PAPRD_TRAINER_STAT1,
 		    AR_PHY_PAPRD_TRAINER_STAT1_PAPRD_TRAIN_DONE);
@@ -271,15 +271,29 @@ static unsigned int ar9003_get_desired_gain(struct ath_hw *ah, int chain,
 	volt_value = REG_READ_FIELD(ah, AR_PHY_BB_THERM_ADC_4,
 				    AR_PHY_BB_THERM_ADC_4_LATEST_VOLT_VALUE);
 
-	if (chain == 0)
-		reg = AR_PHY_TPC_11_B0;
-	else if (chain == 1)
-		reg = AR_PHY_TPC_11_B1;
-	else
-		reg = AR_PHY_TPC_11_B2;
+	switch (chain) {
+	case 0:
+		reg_olpc = AR_PHY_TPC_11_B0;
+		reg_cl_gain = AR_PHY_CL_TAB_0;
+		break;
+	case 1:
+		reg_olpc = AR_PHY_TPC_11_B1;
+		reg_cl_gain = AR_PHY_CL_TAB_1;
+		break;
+	case 2:
+		reg_olpc = AR_PHY_TPC_11_B2;
+		reg_cl_gain = AR_PHY_CL_TAB_2;
+		break;
+	default:
+		ath_dbg(ath9k_hw_common(ah), ATH_DBG_CALIBRATE,
+		"Invalid chainmask: %d\n", chain);
+		break;
+	}
 
-	olpc_gain_delta = REG_READ_FIELD(ah, reg,
+	olpc_gain_delta = REG_READ_FIELD(ah, reg_olpc,
 					 AR_PHY_TPC_11_OLPC_GAIN_DELTA);
+	cl_gain_mod = REG_READ_FIELD(ah, reg_cl_gain,
+					 AR_PHY_CL_TAB_CL_GAIN_MOD);
 
 	if (olpc_gain_delta >= 128)
 		olpc_gain_delta = olpc_gain_delta - 256;
@@ -289,7 +303,7 @@ static unsigned int ar9003_get_desired_gain(struct ath_hw *ah, int chain,
 	voltage_gain_corr = (alpha_volt * (volt_value - volt_cal_value) +
 			     (128 / 2)) / 128;
 	desired_gain = target_power - olpc_gain_delta - thermal_gain_corr -
-	    voltage_gain_corr + desired_scale;
+	    voltage_gain_corr + desired_scale + cl_gain_mod;
 
 	return desired_gain;
 }
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index 9eb3aa2..6de3f0b 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -1121,6 +1121,9 @@
 #define AR_PHY_POWERTX_RATE8_POWERTXHT40_5	0x3F00
 #define AR_PHY_POWERTX_RATE8_POWERTXHT40_5_S	8
 
+#define AR_PHY_CL_TAB_CL_GAIN_MOD		0x1f
+#define AR_PHY_CL_TAB_CL_GAIN_MOD_S		0
+
 void ar9003_hw_set_chain_masks(struct ath_hw *ah, u8 rx, u8 tx);
 
 #endif  /* AR9003_PHY_H */
-- 
1.7.0.4

