Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5869 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbcFUFqo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2016 01:46:44 -0400
From: <akolli@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <akolli@codeaurora.org>, <linux-wireless@vger.kernel.org>,
	Anilkumar Kolli <akolli@qti.qualcomm.com>
Subject: [PATCH 2/2] ath10k: Enable support for QCA9888
Date: Tue, 21 Jun 2016 11:18:08 +0530
Message-ID: <1466488088-20961-2-git-send-email-akolli@qti.qualcomm.com> (sfid-20160621_074705_064173_C6FAE77B)
In-Reply-To: <1466488088-20961-1-git-send-email-akolli@qti.qualcomm.com>
References: <1466488088-20961-1-git-send-email-akolli@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Anilkumar Kolli <akolli@qti.qualcomm.com>

QCA9888 shares the same configuration with QCA99X0
with NSS=2.

Signed-off-by: Anilkumar Kolli <akolli@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c |   26 ++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/hw.c   |    9 +++++++++
 drivers/net/wireless/ath/ath10k/hw.h   |   12 ++++++++++++
 drivers/net/wireless/ath/ath10k/pci.c  |   13 +++++++++++++
 4 files changed, 60 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index a003980d8972..8a080ab5b07e 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -185,6 +185,28 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		},
 	},
 	{
+		.id = QCA9888_HW_2_0_DEV_VERSION,
+		.dev_id = QCA9888_2_0_DEVICE_ID,
+		.name = "qca9888 hw2.0",
+		.patch_load_addr = QCA9888_HW_2_0_PATCH_LOAD_ADDR,
+		.uart_pin = 7,
+		.otp_exe_param = 0x00000700,
+		.continuous_frag_desc = true,
+		.channel_counters_freq_hz = 150000,
+		.max_probe_resp_desc_thres = 24,
+		.hw_4addr_pad = ATH10K_HW_4ADDR_PAD_BEFORE,
+		.tx_chain_mask = 3,
+		.rx_chain_mask = 3,
+		.max_spatial_stream = 2,
+		.cal_data_len = 12064,
+		.fw = {
+			.dir = QCA9888_HW_2_0_FW_DIR,
+			.board = QCA9888_HW_2_0_BOARD_DATA_FILE,
+			.board_size = QCA99X0_BOARD_DATA_SZ,
+			.board_ext_size = QCA99X0_BOARD_EXT_DATA_SZ,
+		},
+	},
+	{
 		.id = QCA9377_HW_1_0_DEV_VERSION,
 		.dev_id = QCA9377_1_0_DEVICE_ID,
 		.name = "qca9377 hw1.0",
@@ -2097,6 +2119,10 @@ struct ath10k *ath10k_core_create(size_t priv_size, struct device *dev,
 		ar->regs = &qca99x0_regs;
 		ar->hw_values = &qca99x0_values;
 		break;
+	case ATH10K_HW_QCA9888:
+		ar->regs = &qca99x0_regs;
+		ar->hw_values = &qca9888_values;
+		break;
 	case ATH10K_HW_QCA4019:
 		ar->regs = &qca4019_regs;
 		ar->hw_values = &qca4019_values;
diff --git a/drivers/net/wireless/ath/ath10k/hw.c b/drivers/net/wireless/ath/ath10k/hw.c
index 433e064c7718..c2c0122a140b 100644
--- a/drivers/net/wireless/ath/ath10k/hw.c
+++ b/drivers/net/wireless/ath/ath10k/hw.c
@@ -165,6 +165,15 @@ const struct ath10k_hw_values qca99x0_values = {
 	.ce_desc_meta_data_lsb		= 4,
 };
 
+const struct ath10k_hw_values qca9888_values = {
+	.rtc_state_val_on		= 3,
+	.ce_count			= 12,
+	.msi_assign_ce_max		= 12,
+	.num_target_ce_config_wlan	= 10,
+	.ce_desc_meta_data_mask		= 0xFFF0,
+	.ce_desc_meta_data_lsb		= 4,
+};
+
 const struct ath10k_hw_values qca4019_values = {
 	.ce_count                       = 12,
 	.num_target_ce_config_wlan      = 10,
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 549f99bdfb86..d537555b28e7 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -26,6 +26,7 @@
 #define QCA6164_2_1_DEVICE_ID   (0x0041)
 #define QCA6174_2_1_DEVICE_ID   (0x003e)
 #define QCA99X0_2_0_DEVICE_ID   (0x0040)
+#define QCA9888_2_0_DEVICE_ID	(0x0056)
 #define QCA9984_1_0_DEVICE_ID	(0x0046)
 #define QCA9377_1_0_DEVICE_ID   (0x0042)
 
@@ -100,6 +101,14 @@ enum qca9377_chip_id_rev {
 #define QCA9984_HW_1_0_BOARD_DATA_FILE "board.bin"
 #define QCA9984_HW_1_0_PATCH_LOAD_ADDR	0x1234
 
+/* QCA9888 2.0 defines */
+#define QCA9888_HW_2_0_DEV_VERSION	0x1000000
+#define QCA9888_HW_DEV_TYPE		0xc
+#define QCA9888_HW_2_0_CHIP_ID_REV	0x0
+#define QCA9888_HW_2_0_FW_DIR		ATH10K_FW_DIR "/QCA9888/hw2.0"
+#define QCA9888_HW_2_0_BOARD_DATA_FILE "board.bin"
+#define QCA9888_HW_2_0_PATCH_LOAD_ADDR	0x1234
+
 /* QCA9377 1.0 definitions */
 #define QCA9377_HW_1_0_FW_DIR          ATH10K_FW_DIR "/QCA9377/hw1.0"
 #define QCA9377_HW_1_0_BOARD_DATA_FILE "board.bin"
@@ -202,6 +211,7 @@ enum ath10k_hw_rev {
 	ATH10K_HW_QCA988X,
 	ATH10K_HW_QCA6174,
 	ATH10K_HW_QCA99X0,
+	ATH10K_HW_QCA9888,
 	ATH10K_HW_QCA9984,
 	ATH10K_HW_QCA9377,
 	ATH10K_HW_QCA4019,
@@ -250,6 +260,7 @@ struct ath10k_hw_values {
 extern const struct ath10k_hw_values qca988x_values;
 extern const struct ath10k_hw_values qca6174_values;
 extern const struct ath10k_hw_values qca99x0_values;
+extern const struct ath10k_hw_values qca9888_values;
 extern const struct ath10k_hw_values qca4019_values;
 
 void ath10k_hw_fill_survey_time(struct ath10k *ar, struct survey_info *survey,
@@ -258,6 +269,7 @@ void ath10k_hw_fill_survey_time(struct ath10k *ar, struct survey_info *survey,
 #define QCA_REV_988X(ar) ((ar)->hw_rev == ATH10K_HW_QCA988X)
 #define QCA_REV_6174(ar) ((ar)->hw_rev == ATH10K_HW_QCA6174)
 #define QCA_REV_99X0(ar) ((ar)->hw_rev == ATH10K_HW_QCA99X0)
+#define QCA_REV_9888(ar) ((ar)->hw_rev == ATH10K_HW_QCA9888)
 #define QCA_REV_9984(ar) ((ar)->hw_rev == ATH10K_HW_QCA9984)
 #define QCA_REV_9377(ar) ((ar)->hw_rev == ATH10K_HW_QCA9377)
 #define QCA_REV_40XX(ar) ((ar)->hw_rev == ATH10K_HW_QCA4019)
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 8e8e1eb4dd0a..d9ce865a5158 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -56,6 +56,7 @@ static const struct pci_device_id ath10k_pci_id_table[] = {
 	{ PCI_VDEVICE(ATHEROS, QCA6164_2_1_DEVICE_ID) }, /* PCI-E QCA6164 V2.1 */
 	{ PCI_VDEVICE(ATHEROS, QCA6174_2_1_DEVICE_ID) }, /* PCI-E QCA6174 V2.1 */
 	{ PCI_VDEVICE(ATHEROS, QCA99X0_2_0_DEVICE_ID) }, /* PCI-E QCA99X0 V2 */
+	{ PCI_VDEVICE(ATHEROS, QCA9888_2_0_DEVICE_ID) }, /* PCI-E QCA9888 V2 */
 	{ PCI_VDEVICE(ATHEROS, QCA9984_1_0_DEVICE_ID) }, /* PCI-E QCA9984 V1 */
 	{ PCI_VDEVICE(ATHEROS, QCA9377_1_0_DEVICE_ID) }, /* PCI-E QCA9377 V1 */
 	{0}
@@ -84,6 +85,8 @@ static const struct ath10k_pci_supp_chip ath10k_pci_supp_chips[] = {
 
 	{ QCA9984_1_0_DEVICE_ID, QCA9984_HW_1_0_CHIP_ID_REV },
 
+	{ QCA9888_2_0_DEVICE_ID, QCA9888_HW_2_0_CHIP_ID_REV },
+
 	{ QCA9377_1_0_DEVICE_ID, QCA9377_HW_1_0_CHIP_ID_REV },
 	{ QCA9377_1_0_DEVICE_ID, QCA9377_HW_1_1_CHIP_ID_REV },
 
@@ -847,6 +850,7 @@ static u32 ath10k_pci_targ_cpu_to_ce_addr(struct ath10k *ar, u32 addr)
 					  CORE_CTRL_ADDRESS) &
 		       0x7ff) << 21;
 		break;
+	case ATH10K_HW_QCA9888:
 	case ATH10K_HW_QCA99X0:
 	case ATH10K_HW_QCA9984:
 	case ATH10K_HW_QCA4019:
@@ -1575,6 +1579,7 @@ static void ath10k_pci_irq_msi_fw_mask(struct ath10k *ar)
 		break;
 	case ATH10K_HW_QCA99X0:
 	case ATH10K_HW_QCA9984:
+	case ATH10K_HW_QCA9888:
 	case ATH10K_HW_QCA4019:
 		/* TODO: Find appropriate register configuration for QCA99X0
 		 *  to mask irq/MSI.
@@ -1599,6 +1604,7 @@ static void ath10k_pci_irq_msi_fw_unmask(struct ath10k *ar)
 		break;
 	case ATH10K_HW_QCA99X0:
 	case ATH10K_HW_QCA9984:
+	case ATH10K_HW_QCA9888:
 	case ATH10K_HW_QCA4019:
 		/* TODO: Find appropriate register configuration for QCA99X0
 		 *  to unmask irq/MSI.
@@ -1939,6 +1945,7 @@ static int ath10k_pci_get_num_banks(struct ath10k *ar)
 	switch (ar_pci->pdev->device) {
 	case QCA988X_2_0_DEVICE_ID:
 	case QCA99X0_2_0_DEVICE_ID:
+	case QCA9888_2_0_DEVICE_ID:
 	case QCA9984_1_0_DEVICE_ID:
 		return 1;
 	case QCA6164_2_1_DEVICE_ID:
@@ -3013,6 +3020,12 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 		pci_soft_reset = ath10k_pci_qca99x0_soft_chip_reset;
 		pci_hard_reset = ath10k_pci_qca99x0_chip_reset;
 		break;
+	case QCA9888_2_0_DEVICE_ID:
+		hw_rev = ATH10K_HW_QCA9888;
+		pci_ps = false;
+		pci_soft_reset = ath10k_pci_qca99x0_soft_chip_reset;
+		pci_hard_reset = ath10k_pci_qca99x0_chip_reset;
+		break;
 	case QCA9377_1_0_DEVICE_ID:
 		hw_rev = ATH10K_HW_QCA9377;
 		pci_ps = true;
-- 
1.7.9.5

