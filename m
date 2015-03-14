Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:33424 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbbCNFyX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2015 01:54:23 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org
Subject: [PATCH v2 08/11] ath9k: Handle MCI_STATE_AIC_CAL_RESET
Date: Sat, 14 Mar 2015 11:27:54 +0530
Message-Id: <1426312677-2064-9-git-send-email-sujith@msujith.org> (sfid-20150314_065439_248203_E5CCFDDE)
In-Reply-To: <1426312677-2064-1-git-send-email-sujith@msujith.org>
References: <1426312677-2064-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Add a routine to handle the MCI_STATE_AIC_CAL_RESET
message.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_aic.c | 8 ++++++++
 drivers/net/wireless/ath/ath9k/ar9003_aic.h | 1 +
 drivers/net/wireless/ath/ath9k/ar9003_mci.c | 4 ++++
 3 files changed, 13 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_aic.c b/drivers/net/wireless/ath/ath9k/ar9003_aic.c
index 7bdbc7a..4e8cf08 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_aic.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_aic.c
@@ -512,6 +512,14 @@ exit:
 
 }
 
+u8 ar9003_aic_cal_reset(struct ath_hw *ah)
+{
+	struct ath9k_hw_aic *aic = &ah->btcoex_hw.aic;
+
+	aic->aic_cal_state = AIC_CAL_STATE_IDLE;
+	return aic->aic_cal_state;
+}
+
 u8 ar9003_aic_calibration_single(struct ath_hw *ah)
 {
 	struct ath9k_hw_mci *mci_hw = &ah->btcoex_hw.mci;
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_aic.h b/drivers/net/wireless/ath/ath9k/ar9003_aic.h
index e31c44e..f7c9546 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_aic.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_aic.h
@@ -53,6 +53,7 @@ struct ath_aic_out_info {
 	struct ath_aic_sram_info sram;
 };
 
+u8 ar9003_aic_cal_reset(struct ath_hw *ah);
 u8 ar9003_aic_calibration_single(struct ath_hw *ah);
 
 #endif /* AR9003_AIC_H */
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
index 6fa98e5..d6ed628 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
@@ -1363,6 +1363,10 @@ u32 ar9003_mci_state(struct ath_hw *ah, u32 state_type)
 		value = (!mci->unhalt_bt_gpm && mci->need_flush_btinfo) ? 1 : 0;
 		mci->need_flush_btinfo = false;
 		break;
+	case MCI_STATE_AIC_CAL_RESET:
+		if (ath9k_hw_is_aic_enabled(ah))
+			value = ar9003_aic_cal_reset(ah);
+		break;
 	case MCI_STATE_AIC_CAL_SINGLE:
 		if (ath9k_hw_is_aic_enabled(ah))
 			value = ar9003_aic_calibration_single(ah);
-- 
2.3.1

