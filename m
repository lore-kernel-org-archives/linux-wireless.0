Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:49313 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892Ab3LQJWs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 04:22:48 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 4/4] ath9k: Fix regulatory compliance
Date: Tue, 17 Dec 2013 14:47:49 +0530
Message-Id: <1387271869-12780-4-git-send-email-sujith@msujith.org> (sfid-20131217_102319_302356_C1BB2AE9)
In-Reply-To: <1387271869-12780-1-git-send-email-sujith@msujith.org>
References: <1387271869-12780-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

To comply with ETSI regulations, make sure that
the CCA registers are programmed with the threshold
values from the EEPROM/Caldata. A new field is used
to indicate if the card has been calibrated with the
required threshold information.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 32 ++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/ar9003_phy.h    |  4 +++-
 2 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index d9e09bf..c8d22ec 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -4121,6 +4121,37 @@ static void ar9003_hw_thermo_cal_apply(struct ath_hw *ah)
 	}
 }
 
+static void ar9003_hw_apply_minccapwr_thresh(struct ath_hw *ah,
+					     bool is2ghz)
+{
+	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
+	const u_int32_t cca_ctrl[AR9300_MAX_CHAINS] = {
+		AR_PHY_CCA_CTRL_0,
+		AR_PHY_CCA_CTRL_1,
+		AR_PHY_CCA_CTRL_2,
+	};
+	int chain;
+	u32 val;
+
+	if (is2ghz) {
+		if (!(eep->base_ext1.misc_enable & BIT(2)))
+			return;
+	} else {
+		if (!(eep->base_ext1.misc_enable & BIT(3)))
+			return;
+	}
+
+	for (chain = 0; chain < AR9300_MAX_CHAINS; chain++) {
+		if (!(ah->caps.tx_chainmask & BIT(chain)))
+			continue;
+
+		val = ar9003_modal_header(ah, is2ghz)->noiseFloorThreshCh[chain];
+		REG_RMW_FIELD(ah, cca_ctrl[chain],
+			      AR_PHY_EXT_CCA0_THRESH62_1, val);
+	}
+
+}
+
 static void ath9k_hw_ar9300_set_board_values(struct ath_hw *ah,
 					     struct ath9k_channel *chan)
 {
@@ -4135,6 +4166,7 @@ static void ath9k_hw_ar9300_set_board_values(struct ath_hw *ah,
 	if (!AR_SREV_9330(ah) && !AR_SREV_9340(ah))
 		ar9003_hw_internal_regulator_apply(ah);
 	ar9003_hw_apply_tuning_caps(ah);
+	ar9003_hw_apply_minccapwr_thresh(ah, chan);
 	ar9003_hw_txend_to_xpa_off_apply(ah, is2ghz);
 	ar9003_hw_thermometer_apply(ah);
 	ar9003_hw_thermo_cal_apply(ah);
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index bbbfc4d..1b44171 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -270,7 +270,7 @@
 #define AR_PHY_AGC              (AR_AGC_BASE + 0x14)
 #define AR_PHY_EXT_ATTEN_CTL_0  (AR_AGC_BASE + 0x18)
 #define AR_PHY_CCA_0            (AR_AGC_BASE + 0x1c)
-#define AR_PHY_EXT_CCA0         (AR_AGC_BASE + 0x20)
+#define AR_PHY_CCA_CTRL_0       (AR_AGC_BASE + 0x20)
 #define AR_PHY_RESTART          (AR_AGC_BASE + 0x24)
 
 /*
@@ -398,6 +398,8 @@
 #define AR9280_PHY_CCA_THRESH62_S   12
 #define AR_PHY_EXT_CCA0_THRESH62    0x000000FF
 #define AR_PHY_EXT_CCA0_THRESH62_S  0
+#define AR_PHY_EXT_CCA0_THRESH62_1    0x000001FF
+#define AR_PHY_EXT_CCA0_THRESH62_1_S  0
 #define AR_PHY_CCK_DETECT_WEAK_SIG_THR_CCK          0x0000003F
 #define AR_PHY_CCK_DETECT_WEAK_SIG_THR_CCK_S        0
 #define AR_PHY_CCK_DETECT_ANT_SWITCH_TIME           0x00001FC0
-- 
1.8.5.1

