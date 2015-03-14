Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:33976 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbbCNFyZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2015 01:54:25 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org
Subject: [PATCH v2 09/11] ath9k: Handle MCI_STATE_AIC_START
Date: Sat, 14 Mar 2015 11:27:55 +0530
Message-Id: <1426312677-2064-10-git-send-email-sujith@msujith.org> (sfid-20150314_070417_297594_2B12D077)
In-Reply-To: <1426312677-2064-1-git-send-email-sujith@msujith.org>
References: <1426312677-2064-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

This patch adds a function to handle the
MCI message MCI_STATE_AIC_START.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_aic.c | 33 +++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/ar9003_aic.h |  1 +
 drivers/net/wireless/ath/ath9k/ar9003_mci.c |  4 ++++
 3 files changed, 38 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_aic.c b/drivers/net/wireless/ath/ath9k/ar9003_aic.c
index 4e8cf08..5b4f818 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_aic.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_aic.c
@@ -18,6 +18,7 @@
 #include "hw-ops.h"
 #include "ar9003_mci.h"
 #include "ar9003_aic.h"
+#include "ar9003_phy.h"
 #include "reg_aic.h"
 
 static const u8 com_att_db_table[ATH_AIC_MAX_COM_ATT_DB_TABLE] = {
@@ -512,6 +513,38 @@ exit:
 
 }
 
+u8 ar9003_aic_start_normal(struct ath_hw *ah)
+{
+	struct ath9k_hw_aic *aic = &ah->btcoex_hw.aic;
+	int16_t i;
+
+	if (aic->aic_cal_state != AIC_CAL_STATE_DONE)
+		return 1;
+
+	ar9003_aic_gain_table(ah);
+
+	REG_WRITE(ah, AR_PHY_AIC_SRAM_ADDR_B1, ATH_AIC_SRAM_AUTO_INCREMENT);
+
+	for (i = 0; i < ATH_AIC_MAX_BT_CHANNEL; i++) {
+		REG_WRITE(ah, AR_PHY_AIC_SRAM_DATA_B1, aic->aic_sram[i]);
+	}
+
+	/* FIXME: Replace these with proper register names */
+	REG_WRITE(ah, 0xa6b0, 0x80);
+	REG_WRITE(ah, 0xa6b4, 0x5b2df0);
+	REG_WRITE(ah, 0xa6b8, 0x10762cc8);
+	REG_WRITE(ah, 0xa6bc, 0x1219a4b);
+	REG_WRITE(ah, 0xa6c0, 0x1e01);
+	REG_WRITE(ah, 0xb6b4, 0xf0);
+	REG_WRITE(ah, 0xb6c0, 0x1e01);
+	REG_WRITE(ah, 0xb6b0, 0x81);
+	REG_WRITE(ah, AR_PHY_65NM_CH1_RXTX4, 0x40000000);
+
+	aic->aic_enabled = true;
+
+	return 0;
+}
+
 u8 ar9003_aic_cal_reset(struct ath_hw *ah)
 {
 	struct ath9k_hw_aic *aic = &ah->btcoex_hw.aic;
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_aic.h b/drivers/net/wireless/ath/ath9k/ar9003_aic.h
index f7c9546..4dbff96 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_aic.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_aic.h
@@ -53,6 +53,7 @@ struct ath_aic_out_info {
 	struct ath_aic_sram_info sram;
 };
 
+u8 ar9003_aic_start_normal(struct ath_hw *ah);
 u8 ar9003_aic_cal_reset(struct ath_hw *ah);
 u8 ar9003_aic_calibration_single(struct ath_hw *ah);
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
index d6ed628..b559d75 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
@@ -1363,6 +1363,10 @@ u32 ar9003_mci_state(struct ath_hw *ah, u32 state_type)
 		value = (!mci->unhalt_bt_gpm && mci->need_flush_btinfo) ? 1 : 0;
 		mci->need_flush_btinfo = false;
 		break;
+	case MCI_STATE_AIC_START:
+		if (ath9k_hw_is_aic_enabled(ah))
+			ar9003_aic_start_normal(ah);
+		break;
 	case MCI_STATE_AIC_CAL_RESET:
 		if (ath9k_hw_is_aic_enabled(ah))
 			value = ar9003_aic_cal_reset(ah);
-- 
2.3.1

