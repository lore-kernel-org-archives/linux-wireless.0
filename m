Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:46438 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbbCNFyR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2015 01:54:17 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org
Subject: [PATCH v2 05/11] ath9k: Finish AIC calibration
Date: Sat, 14 Mar 2015 11:27:51 +0530
Message-Id: <1426312677-2064-6-git-send-email-sujith@msujith.org> (sfid-20150314_065424_629960_1AE33F6A)
In-Reply-To: <1426312677-2064-1-git-send-email-sujith@msujith.org>
References: <1426312677-2064-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Set the appropriate bits in the HW after
AIC calibration is done.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_aic.c | 78 ++++++++++++++++++++++++++++-
 1 file changed, 77 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_aic.c b/drivers/net/wireless/ath/ath9k/ar9003_aic.c
index c2cfac3..00aaf4d 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_aic.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_aic.c
@@ -186,15 +186,91 @@ static void ar9003_aic_cal_start(struct ath_hw *ah, u8 min_valid_count)
 	aic->aic_cal_state = AIC_CAL_STATE_STARTED;
 }
 
+static void ar9003_aic_cal_done(struct ath_hw *ah)
+{
+	/* Disable AIC reference signal in BT modem. */
+	REG_WRITE(ah, ATH_AIC_BT_JUPITER_CTRL,
+		  (REG_READ(ah, ATH_AIC_BT_JUPITER_CTRL) &
+		   ~ATH_AIC_BT_AIC_ENABLE));
+}
+
+static u8 ar9003_aic_cal_continue(struct ath_hw *ah, bool cal_once)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+	struct ath9k_hw_mci *mci_hw = &ah->btcoex_hw.mci;
+	struct ath9k_hw_aic *aic = &ah->btcoex_hw.aic;
+	int i, num_chan;
+
+	num_chan = MS(mci_hw->config, ATH_MCI_CONFIG_AIC_CAL_NUM_CHAN);
+
+	if (!num_chan) {
+		aic->aic_cal_state = AIC_CAL_STATE_ERROR;
+		return aic->aic_cal_state;
+	}
+
+	if (cal_once) {
+		for (i = 0; i < 10000; i++) {
+			if ((REG_READ(ah, AR_PHY_AIC_CTRL_0_B1) &
+			     AR_PHY_AIC_CAL_ENABLE) == 0)
+				break;
+
+			udelay(100);
+		}
+	}
+
+	/*
+	 * Use AR_PHY_AIC_CAL_ENABLE bit instead of AR_PHY_AIC_CAL_DONE.
+	 * Sometimes CAL_DONE bit is not asserted.
+	 */
+	if ((REG_READ(ah, AR_PHY_AIC_CTRL_0_B1) &
+	     AR_PHY_AIC_CAL_ENABLE) != 0) {
+		ath_dbg(common, MCI, "AIC cal is not done after 40ms");
+		goto exit;
+	}
+
+	REG_WRITE(ah, AR_PHY_AIC_SRAM_ADDR_B1,
+		  (ATH_AIC_SRAM_CAL_OFFSET | ATH_AIC_SRAM_AUTO_INCREMENT));
+
+	for (i = 0; i < ATH_AIC_MAX_BT_CHANNEL; i++) {
+		u32 value;
+
+		value = REG_READ(ah, AR_PHY_AIC_SRAM_DATA_B1);
+
+		if (value & 0x01) {
+			if (aic->aic_sram[i] == 0)
+				aic->aic_caled_chan++;
+
+			aic->aic_sram[i] = value;
+
+			if (!cal_once)
+				break;
+		}
+	}
+
+	if ((aic->aic_caled_chan >= num_chan) || cal_once) {
+		ar9003_aic_cal_done(ah);
+	} else {
+		/* Start calibration */
+		REG_CLR_BIT(ah, AR_PHY_AIC_CTRL_0_B1, AR_PHY_AIC_CAL_ENABLE);
+		REG_SET_BIT(ah, AR_PHY_AIC_CTRL_0_B1,
+			    AR_PHY_AIC_CAL_CH_VALID_RESET);
+		REG_SET_BIT(ah, AR_PHY_AIC_CTRL_0_B1, AR_PHY_AIC_CAL_ENABLE);
+	}
+exit:
+	return aic->aic_cal_state;
+
+}
+
 u8 ar9003_aic_calibration_single(struct ath_hw *ah)
 {
 	struct ath9k_hw_mci *mci_hw = &ah->btcoex_hw.mci;
-	u8 cal_ret = 0;
+	u8 cal_ret;
 	int num_chan;
 
 	num_chan = MS(mci_hw->config, ATH_MCI_CONFIG_AIC_CAL_NUM_CHAN);
 
 	ar9003_aic_cal_start(ah, num_chan);
+	cal_ret = ar9003_aic_cal_continue(ah, true);
 
 	return cal_ret;
 }
-- 
2.3.1

