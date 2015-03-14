Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:60240 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbbCNFy1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2015 01:54:27 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org
Subject: [PATCH v2 10/11] ath9k: Handle MCI_STATE_AIC_CAL
Date: Sat, 14 Mar 2015 11:27:56 +0530
Message-Id: <1426312677-2064-11-git-send-email-sujith@msujith.org> (sfid-20150314_065440_385598_7B7EFC6F)
In-Reply-To: <1426312677-2064-1-git-send-email-sujith@msujith.org>
References: <1426312677-2064-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Add the main AIC calibration function to
handle MCI_STATE_AIC_CAL.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_aic.c | 28 ++++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath9k/ar9003_aic.h |  1 +
 drivers/net/wireless/ath/ath9k/ar9003_mci.c |  4 ++++
 3 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_aic.c b/drivers/net/wireless/ath/ath9k/ar9003_aic.c
index 5b4f818..1db119d 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_aic.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_aic.c
@@ -162,7 +162,7 @@ static void ar9003_aic_gain_table(struct ath_hw *ah)
 	}
 }
 
-static void ar9003_aic_cal_start(struct ath_hw *ah, u8 min_valid_count)
+static u8 ar9003_aic_cal_start(struct ath_hw *ah, u8 min_valid_count)
 {
 	struct ath9k_hw_aic *aic = &ah->btcoex_hw.aic;
 	int i;
@@ -257,6 +257,8 @@ static void ar9003_aic_cal_start(struct ath_hw *ah, u8 min_valid_count)
 
 	aic->aic_caled_chan = 0;
 	aic->aic_cal_state = AIC_CAL_STATE_STARTED;
+
+	return aic->aic_cal_state;
 }
 
 static bool ar9003_aic_cal_post_process(struct ath_hw *ah)
@@ -513,6 +515,28 @@ exit:
 
 }
 
+u8 ar9003_aic_calibration(struct ath_hw *ah)
+{
+	struct ath9k_hw_aic *aic = &ah->btcoex_hw.aic;
+	u8 cal_ret = AIC_CAL_STATE_ERROR;
+
+	switch (aic->aic_cal_state) {
+	case AIC_CAL_STATE_IDLE:
+		cal_ret = ar9003_aic_cal_start(ah, 1);
+		break;
+	case AIC_CAL_STATE_STARTED:
+		cal_ret = ar9003_aic_cal_continue(ah, false);
+		break;
+	case AIC_CAL_STATE_DONE:
+		cal_ret = AIC_CAL_STATE_DONE;
+		break;
+	default:
+		break;
+	}
+
+	return cal_ret;
+}
+
 u8 ar9003_aic_start_normal(struct ath_hw *ah)
 {
 	struct ath9k_hw_aic *aic = &ah->btcoex_hw.aic;
@@ -561,7 +585,7 @@ u8 ar9003_aic_calibration_single(struct ath_hw *ah)
 
 	num_chan = MS(mci_hw->config, ATH_MCI_CONFIG_AIC_CAL_NUM_CHAN);
 
-	ar9003_aic_cal_start(ah, num_chan);
+	(void) ar9003_aic_cal_start(ah, num_chan);
 	cal_ret = ar9003_aic_cal_continue(ah, true);
 
 	return cal_ret;
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_aic.h b/drivers/net/wireless/ath/ath9k/ar9003_aic.h
index 4dbff96..86f4064 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_aic.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_aic.h
@@ -53,6 +53,7 @@ struct ath_aic_out_info {
 	struct ath_aic_sram_info sram;
 };
 
+u8 ar9003_aic_calibration(struct ath_hw *ah);
 u8 ar9003_aic_start_normal(struct ath_hw *ah);
 u8 ar9003_aic_cal_reset(struct ath_hw *ah);
 u8 ar9003_aic_calibration_single(struct ath_hw *ah);
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
index b559d75..cdd83d4 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
@@ -1363,6 +1363,10 @@ u32 ar9003_mci_state(struct ath_hw *ah, u32 state_type)
 		value = (!mci->unhalt_bt_gpm && mci->need_flush_btinfo) ? 1 : 0;
 		mci->need_flush_btinfo = false;
 		break;
+	case MCI_STATE_AIC_CAL:
+		if (ath9k_hw_is_aic_enabled(ah))
+			value = ar9003_aic_calibration(ah);
+		break;
 	case MCI_STATE_AIC_START:
 		if (ath9k_hw_is_aic_enabled(ah))
 			ar9003_aic_start_normal(ah);
-- 
2.3.1

