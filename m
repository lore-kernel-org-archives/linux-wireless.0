Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:60654 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804AbbFRHCb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2015 03:02:31 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Subject: [PATCH V2 03/10] ath10k: Add hw register/values for QCA99X0 chip
Date: Thu, 18 Jun 2015 12:31:03 +0530
Message-ID: <1434610870-5505-4-git-send-email-vthiagar@qti.qualcomm.com> (sfid-20150618_090234_339723_CA8B9451)
In-Reply-To: <1434610870-5505-1-git-send-email-vthiagar@qti.qualcomm.com>
References: <1434610870-5505-1-git-send-email-vthiagar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is to prepare the driver for QCA99X0 chip support.
This commit adds hw_params, hw register table and hw_values
table for QCA99X0 chip. Please note this is only a partial patch adding
support for QCA99X0, so the device id is not yet added to pci device
table.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c      | 18 ++++++++++++
 drivers/net/wireless/ath/ath10k/hw.c        | 44 +++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/hw.h        | 18 ++++++++++++
 drivers/net/wireless/ath/ath10k/pci.c       |  5 ++++
 drivers/net/wireless/ath/ath10k/targaddrs.h |  3 ++
 5 files changed, 88 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index b17541b..f239e96 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -101,6 +101,20 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 			.board_ext_size = QCA6174_BOARD_EXT_DATA_SZ,
 		},
 	},
+	{
+		.id = QCA99X0_HW_2_0_DEV_VERSION,
+		.name = "qca99x0 hw2.0",
+		.patch_load_addr = QCA99X0_HW_2_0_PATCH_LOAD_ADDR,
+		.uart_pin = 7,
+		.fw = {
+			.dir = QCA99X0_HW_2_0_FW_DIR,
+			.fw = QCA99X0_HW_2_0_FW_FILE,
+			.otp = QCA99X0_HW_2_0_OTP_FILE,
+			.board = QCA99X0_HW_2_0_BOARD_DATA_FILE,
+			.board_size = QCA99X0_BOARD_DATA_SZ,
+			.board_ext_size = QCA99X0_BOARD_EXT_DATA_SZ,
+		},
+	},
 };
 
 static const char *const ath10k_core_fw_feature_str[] = {
@@ -1520,6 +1534,10 @@ struct ath10k *ath10k_core_create(size_t priv_size, struct device *dev,
 		ar->regs = &qca6174_regs;
 		ar->hw_values = &qca6174_values;
 		break;
+	case ATH10K_HW_QCA99X0:
+		ar->regs = &qca99x0_regs;
+		ar->hw_values = &qca99x0_values;
+		break;
 	default:
 		ath10k_err(ar, "unsupported core hardware revision %d\n",
 			   hw_rev);
diff --git a/drivers/net/wireless/ath/ath10k/hw.c b/drivers/net/wireless/ath/ath10k/hw.c
index cb09867..e5fe33d9 100644
--- a/drivers/net/wireless/ath/ath10k/hw.c
+++ b/drivers/net/wireless/ath/ath10k/hw.c
@@ -72,6 +72,43 @@ const struct ath10k_hw_regs qca6174_regs = {
 	.pcie_intr_clr_address			= 0x00000014,
 };
 
+const struct ath10k_hw_regs qca99x0_regs = {
+	.rtc_state_cold_reset_mask		= 0x00000400,
+	.rtc_soc_base_address			= 0x00080000,
+	.rtc_wmac_base_address			= 0x00000000,
+	.soc_core_base_address			= 0x00082000,
+	.ce_wrapper_base_address		= 0x0004d000,
+	.ce0_base_address			= 0x0004a000,
+	.ce1_base_address			= 0x0004a400,
+	.ce2_base_address			= 0x0004a800,
+	.ce3_base_address			= 0x0004ac00,
+	.ce4_base_address			= 0x0004b000,
+	.ce5_base_address			= 0x0004b400,
+	.ce6_base_address			= 0x0004b800,
+	.ce7_base_address			= 0x0004bc00,
+	/* Note: qca99x0 supports upto 12 Copy Engines. Other than address of
+	 * CE0 and CE1 no other copy engine is directly referred in the code.
+	 * It is not really neccessary to assign address for newly supported
+	 * CEs in this address table.
+	 *	Copy Engine		Address
+	 *	CE8			0x0004c000
+	 *	CE9			0x0004c400
+	 *	CE10			0x0004c800
+	 *	CE11			0x0004cc00
+	 */
+	.soc_reset_control_si0_rst_mask		= 0x00000001,
+	.soc_reset_control_ce_rst_mask		= 0x00000100,
+	.soc_chip_id_address			= 0x000000ec,
+	.scratch_3_address			= 0x00040050,
+	.fw_indicator_address			= 0x00040050,
+	.pcie_local_base_address		= 0x00000000,
+	.ce_wrap_intr_sum_host_msi_lsb		= 0x0000000c,
+	.ce_wrap_intr_sum_host_msi_mask		= 0x00fff000,
+	.pcie_intr_fw_mask			= 0x00100000,
+	.pcie_intr_ce_mask_all			= 0x000fff00,
+	.pcie_intr_clr_address			= 0x00000010,
+};
+
 const struct ath10k_hw_values qca988x_values = {
 	.rtc_state_val_on		= 3,
 	.ce_count			= 8,
@@ -86,6 +123,13 @@ const struct ath10k_hw_values qca6174_values = {
 	.num_target_ce_config_wlan	= 7,
 };
 
+const struct ath10k_hw_values qca99x0_values = {
+	.rtc_state_val_on		= 5,
+	.ce_count			= 12,
+	.msi_assign_ce_max		= 12,
+	.num_target_ce_config_wlan	= 10,
+};
+
 void ath10k_hw_fill_survey_time(struct ath10k *ar, struct survey_info *survey,
 				u32 cc, u32 rcc, u32 cc_prev, u32 rcc_prev)
 {
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 5d04317..76caeab 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -72,6 +72,18 @@ enum qca6174_chip_id_rev {
 #define QCA6174_HW_3_0_BOARD_DATA_FILE	"board.bin"
 #define QCA6174_HW_3_0_PATCH_LOAD_ADDR	0x1234
 
+/* QCA99X0 1.0 definitions (unsupported) */
+#define QCA99X0_HW_1_0_CHIP_ID_REV     0x0
+
+/* QCA99X0 2.0 definitions */
+#define QCA99X0_HW_2_0_DEV_VERSION     0x01000000
+#define QCA99X0_HW_2_0_CHIP_ID_REV     0x1
+#define QCA99X0_HW_2_0_FW_DIR          ATH10K_FW_DIR "/QCA99X0/hw2.0"
+#define QCA99X0_HW_2_0_FW_FILE         "firmware.bin"
+#define QCA99X0_HW_2_0_OTP_FILE        "otp.bin"
+#define QCA99X0_HW_2_0_BOARD_DATA_FILE "board.bin"
+#define QCA99X0_HW_2_0_PATCH_LOAD_ADDR	0x1234
+
 #define ATH10K_FW_API2_FILE		"firmware-2.bin"
 #define ATH10K_FW_API3_FILE		"firmware-3.bin"
 
@@ -144,6 +156,7 @@ enum ath10k_fw_htt_op_version {
 enum ath10k_hw_rev {
 	ATH10K_HW_QCA988X,
 	ATH10K_HW_QCA6174,
+	ATH10K_HW_QCA99X0,
 };
 
 struct ath10k_hw_regs {
@@ -175,6 +188,7 @@ struct ath10k_hw_regs {
 
 extern const struct ath10k_hw_regs qca988x_regs;
 extern const struct ath10k_hw_regs qca6174_regs;
+extern const struct ath10k_hw_regs qca99x0_regs;
 
 struct ath10k_hw_values {
 	u32 rtc_state_val_on;
@@ -185,12 +199,14 @@ struct ath10k_hw_values {
 
 extern const struct ath10k_hw_values qca988x_values;
 extern const struct ath10k_hw_values qca6174_values;
+extern const struct ath10k_hw_values qca99x0_values;
 
 void ath10k_hw_fill_survey_time(struct ath10k *ar, struct survey_info *survey,
 				u32 cc, u32 rcc, u32 cc_prev, u32 rcc_prev);
 
 #define QCA_REV_988X(ar) ((ar)->hw_rev == ATH10K_HW_QCA988X)
 #define QCA_REV_6174(ar) ((ar)->hw_rev == ATH10K_HW_QCA6174)
+#define QCA_REV_99X0(ar) ((ar)->hw_rev == ATH10K_HW_QCA99X0)
 
 /* Known pecularities:
  *  - current FW doesn't support raw rx mode (last tested v599)
@@ -485,6 +501,8 @@ enum ath10k_hw_rate_cck {
 
 #define DRAM_BASE_ADDRESS			0x00400000
 
+#define PCIE_BAR_REG_ADDRESS			0x40030
+
 #define MISSING 0
 
 #define SYSTEM_SLEEP_OFFSET			SOC_SYSTEM_SLEEP_OFFSET
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 4176517..0007e70 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -59,6 +59,7 @@ MODULE_PARM_DESC(reset_mode, "0: auto, 1: warm only (default: 0)");
 
 #define QCA988X_2_0_DEVICE_ID	(0x003c)
 #define QCA6174_2_1_DEVICE_ID	(0x003e)
+#define QCA99X0_2_0_DEVICE_ID	(0x0040)
 
 static const struct pci_device_id ath10k_pci_id_table[] = {
 	{ PCI_VDEVICE(ATHEROS, QCA988X_2_0_DEVICE_ID) }, /* PCI-E QCA988X V2 */
@@ -1699,6 +1700,7 @@ static int ath10k_pci_get_num_banks(struct ath10k *ar)
 
 	switch (ar_pci->pdev->device) {
 	case QCA988X_2_0_DEVICE_ID:
+	case QCA99X0_2_0_DEVICE_ID:
 		return 1;
 	case QCA6174_2_1_DEVICE_ID:
 		switch (MS(ar->chip_id, SOC_CHIP_ID_REV)) {
@@ -2758,6 +2760,9 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 	case QCA6174_2_1_DEVICE_ID:
 		hw_rev = ATH10K_HW_QCA6174;
 		break;
+	case QCA99X0_2_0_DEVICE_ID:
+		hw_rev = ATH10K_HW_QCA99X0;
+		break;
 	default:
 		WARN_ON(1);
 		return -ENOTSUPP;
diff --git a/drivers/net/wireless/ath/ath10k/targaddrs.h b/drivers/net/wireless/ath/ath10k/targaddrs.h
index a417aae..768bef6 100644
--- a/drivers/net/wireless/ath/ath10k/targaddrs.h
+++ b/drivers/net/wireless/ath/ath10k/targaddrs.h
@@ -450,4 +450,7 @@ Fw Mode/SubMode Mask
 #define QCA6174_BOARD_DATA_SZ     8192
 #define QCA6174_BOARD_EXT_DATA_SZ 0
 
+#define QCA99X0_BOARD_DATA_SZ	  12288
+#define QCA99X0_BOARD_EXT_DATA_SZ 0
+
 #endif /* __TARGADDRS_H__ */
-- 
1.9.1

