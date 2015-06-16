Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:49375 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbbFPFM7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2015 01:12:59 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Subject: [PATCH 01/10] ath10k: Add a table to store hw specific values
Date: Tue, 16 Jun 2015 10:42:13 +0530
Message-ID: <1434431542-14724-2-git-send-email-vthiagar@qti.qualcomm.com> (sfid-20150616_071308_660983_D500419F)
In-Reply-To: <1434431542-14724-1-git-send-email-vthiagar@qti.qualcomm.com>
References: <1434431542-14724-1-git-send-email-vthiagar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is to prepare ath10k to support newer chip set.
Values like CE_COUNT, MSI_ASSIGN_CE_MAX and
RTC_STATE_V_ON can be different for different
chips.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c |  2 ++
 drivers/net/wireless/ath/ath10k/core.h |  1 +
 drivers/net/wireless/ath/ath10k/hw.c   | 14 ++++++++++++++
 drivers/net/wireless/ath/ath10k/hw.h   | 18 +++++++++++++++---
 4 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 59496a9..2a17664 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1470,9 +1470,11 @@ struct ath10k *ath10k_core_create(size_t priv_size, struct device *dev,
 	switch (hw_rev) {
 	case ATH10K_HW_QCA988X:
 		ar->regs = &qca988x_regs;
+		ar->hw_values = &qca988x_values;
 		break;
 	case ATH10K_HW_QCA6174:
 		ar->regs = &qca6174_regs;
+		ar->hw_values = &qca6174_values;
 		break;
 	default:
 		ath10k_err(ar, "unsupported core hardware revision %d\n",
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 78094f2..ae92f64 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -560,6 +560,7 @@ struct ath10k {
 	struct completion target_suspend;
 
 	const struct ath10k_hw_regs *regs;
+	const struct ath10k_hw_values *hw_values;
 	struct ath10k_bmi bmi;
 	struct ath10k_wmi wmi;
 	struct ath10k_htc htc;
diff --git a/drivers/net/wireless/ath/ath10k/hw.c b/drivers/net/wireless/ath/ath10k/hw.c
index 5997f00..48bcd2c 100644
--- a/drivers/net/wireless/ath/ath10k/hw.c
+++ b/drivers/net/wireless/ath/ath10k/hw.c
@@ -58,6 +58,20 @@ const struct ath10k_hw_regs qca6174_regs = {
 	.scratch_3_address			= 0x0028,
 };
 
+const struct ath10k_hw_values qca988x_values = {
+	.rtc_state_val_on		= 3,
+	.ce_count			= 8,
+	.msi_assign_ce_max		= 7,
+	.num_target_ce_config_wlan	= 7,
+};
+
+const struct ath10k_hw_values qca6174_values = {
+	.rtc_state_val_on		= 3,
+	.ce_count			= 8,
+	.msi_assign_ce_max		= 7,
+	.num_target_ce_config_wlan	= 7,
+};
+
 void ath10k_hw_fill_survey_time(struct ath10k *ar, struct survey_info *survey,
 				u32 cc, u32 rcc, u32 cc_prev, u32 rcc_prev)
 {
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 85cca29..b218388 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -169,6 +169,16 @@ struct ath10k_hw_regs {
 extern const struct ath10k_hw_regs qca988x_regs;
 extern const struct ath10k_hw_regs qca6174_regs;
 
+struct ath10k_hw_values {
+	u32 rtc_state_val_on;
+	u8 ce_count;
+	u8 msi_assign_ce_max;
+	u8 num_target_ce_config_wlan;
+};
+
+extern const struct ath10k_hw_values qca988x_values;
+extern const struct ath10k_hw_values qca6174_values;
+
 void ath10k_hw_fill_survey_time(struct ath10k *ar, struct survey_info *survey,
 				u32 cc, u32 rcc, u32 cc_prev, u32 rcc_prev);
 
@@ -310,8 +320,10 @@ enum ath10k_hw_rate_cck {
 #define TARGET_TLV_NUM_MSDU_DESC		(1024 + 32)
 #define TARGET_TLV_NUM_WOW_PATTERNS		22
 
+#define NUM_TARGET_CE_CONFIG_WLAN ar->hw_values->num_target_ce_config_wlan
+
 /* Number of Copy Engines supported */
-#define CE_COUNT 8
+#define CE_COUNT ar->hw_values->ce_count
 
 /*
  * Total number of PCIe MSI interrupts requested for all interrupt sources.
@@ -335,10 +347,10 @@ enum ath10k_hw_rate_cck {
 
 /* MSIs for Copy Engines */
 #define MSI_ASSIGN_CE_INITIAL	1
-#define MSI_ASSIGN_CE_MAX	7
+#define MSI_ASSIGN_CE_MAX	ar->hw_values->msi_assign_ce_max
 
 /* as of IP3.7.1 */
-#define RTC_STATE_V_ON				3
+#define RTC_STATE_V_ON				ar->hw_values->rtc_state_val_on
 
 #define RTC_STATE_COLD_RESET_MASK		ar->regs->rtc_state_cold_reset_mask
 #define RTC_STATE_V_LSB				0
-- 
1.9.1

