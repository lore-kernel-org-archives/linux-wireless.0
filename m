Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:39637 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501AbcA0J53 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2016 04:57:29 -0500
From: Raja Mani <rmani@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Subject: [PATCH 05/12] ath10k: include qca4019 register map table
Date: Wed, 27 Jan 2016 15:24:26 +0530
Message-ID: <1453888473-2879-6-git-send-email-rmani@qti.qualcomm.com> (sfid-20160127_105754_263950_AD5BA071)
In-Reply-To: <1453888473-2879-1-git-send-email-rmani@qti.qualcomm.com>
References: <1453888473-2879-1-git-send-email-rmani@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

New register table is added for qca4019 to tell about it's
register mapping details.

Nothing much other than this.

Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c |  4 ++++
 drivers/net/wireless/ath/ath10k/hw.c   | 39 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/hw.h   |  2 ++
 3 files changed, 45 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index b41eb3f..5c684e0 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1979,6 +1979,10 @@ struct ath10k *ath10k_core_create(size_t priv_size, struct device *dev,
 		ar->regs = &qca99x0_regs;
 		ar->hw_values = &qca99x0_values;
 		break;
+	case ATH10K_HW_QCA4019:
+		ar->regs = &qca4019_regs;
+		ar->hw_values = &qca4019_values;
+		break;
 	default:
 		ath10k_err(ar, "unsupported core hardware revision %d\n",
 			   hw_rev);
diff --git a/drivers/net/wireless/ath/ath10k/hw.c b/drivers/net/wireless/ath/ath10k/hw.c
index 7b84d08..f544d48 100644
--- a/drivers/net/wireless/ath/ath10k/hw.c
+++ b/drivers/net/wireless/ath/ath10k/hw.c
@@ -109,6 +109,38 @@ const struct ath10k_hw_regs qca99x0_regs = {
 	.pcie_intr_clr_address			= 0x00000010,
 };
 
+const struct ath10k_hw_regs qca4019_regs = {
+	.rtc_soc_base_address                   = 0x00080000,
+	.soc_core_base_address                  = 0x00082000,
+	.ce_wrapper_base_address                = 0x0004d000,
+	.ce0_base_address                       = 0x0004a000,
+	.ce1_base_address                       = 0x0004a400,
+	.ce2_base_address                       = 0x0004a800,
+	.ce3_base_address                       = 0x0004ac00,
+	.ce4_base_address                       = 0x0004b000,
+	.ce5_base_address                       = 0x0004b400,
+	.ce6_base_address                       = 0x0004b800,
+	.ce7_base_address                       = 0x0004bc00,
+	/* qca4019 supports upto 12 copy engines. Since base address
+	 * of ce8 to ce11 are not directly referred in the code,
+	 * no need have them in separate members in this table.
+	 *      Copy Engine             Address
+	 *      CE8                     0x0004c000
+	 *      CE9                     0x0004c400
+	 *      CE10                    0x0004c800
+	 *      CE11                    0x0004cc00
+	 */
+	.soc_reset_control_si0_rst_mask         = 0x00000001,
+	.soc_reset_control_ce_rst_mask          = 0x00000100,
+	.soc_chip_id_address                    = 0x000000ec,
+	.fw_indicator_address                   = 0x0004f00c,
+	.ce_wrap_intr_sum_host_msi_lsb          = 0x0000000c,
+	.ce_wrap_intr_sum_host_msi_mask         = 0x00fff000,
+	.pcie_intr_fw_mask                      = 0x00100000,
+	.pcie_intr_ce_mask_all                  = 0x000fff00,
+	.pcie_intr_clr_address                  = 0x00000010,
+};
+
 const struct ath10k_hw_values qca988x_values = {
 	.rtc_state_val_on		= 3,
 	.ce_count			= 8,
@@ -136,6 +168,13 @@ const struct ath10k_hw_values qca99x0_values = {
 	.ce_desc_meta_data_lsb		= 4,
 };
 
+const struct ath10k_hw_values qca4019_values = {
+	.ce_count                       = 12,
+	.num_target_ce_config_wlan      = 10,
+	.ce_desc_meta_data_mask         = 0xFFF0,
+	.ce_desc_meta_data_lsb          = 4,
+};
+
 void ath10k_hw_fill_survey_time(struct ath10k *ar, struct survey_info *survey,
 				u32 cc, u32 rcc, u32 cc_prev, u32 rcc_prev)
 {
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index f885015..f57a37b 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -233,6 +233,7 @@ struct ath10k_hw_regs {
 extern const struct ath10k_hw_regs qca988x_regs;
 extern const struct ath10k_hw_regs qca6174_regs;
 extern const struct ath10k_hw_regs qca99x0_regs;
+extern const struct ath10k_hw_regs qca4019_regs;
 
 struct ath10k_hw_values {
 	u32 rtc_state_val_on;
@@ -246,6 +247,7 @@ struct ath10k_hw_values {
 extern const struct ath10k_hw_values qca988x_values;
 extern const struct ath10k_hw_values qca6174_values;
 extern const struct ath10k_hw_values qca99x0_values;
+extern const struct ath10k_hw_values qca4019_values;
 
 void ath10k_hw_fill_survey_time(struct ath10k *ar, struct survey_info *survey,
 				u32 cc, u32 rcc, u32 cc_prev, u32 rcc_prev);
-- 
1.8.1.2

