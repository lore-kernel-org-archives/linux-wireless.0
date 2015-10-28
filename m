Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:34659 "EHLO
	mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965873AbbJ1OKM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 10:10:12 -0400
Received: by lfaz124 with SMTP id z124so4314439lfa.1
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2015 07:10:10 -0700 (PDT)
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH v2] ath10k: add QCA9377 chipset support
Date: Wed, 28 Oct 2015 15:09:53 +0100
Message-Id: <1446041393-4652-1-git-send-email-bartosz.markowski@tieto.com> (sfid-20151028_151024_108652_6ADCBD7D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add the hardware name, revision and update the pci_id table.

Currently there're two HW ref. designs available I'm aware of,
with 1.0.2 and 1.1 chip revisions. I've access and been using
the first one so far and this patch cover only it.

QCA9377 inherits most of the stuff (e.g. fw interfaces)
from QCA61x4 design, so the integration was pretty straightforward.

Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---

Notes:
    v2:
     * fix the missig pci_ps initialization in probe function [kbuild]

 drivers/net/wireless/ath/ath10k/core.c      | 16 ++++++++++++++++
 drivers/net/wireless/ath/ath10k/hw.h        | 11 +++++++++++
 drivers/net/wireless/ath/ath10k/pci.c       | 18 ++++++++++++++++++
 drivers/net/wireless/ath/ath10k/targaddrs.h |  3 +++
 4 files changed, 48 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 13de3617d5ab..828aefce8a7a 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -137,6 +137,21 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 			.board_ext_size = QCA99X0_BOARD_EXT_DATA_SZ,
 		},
 	},
+	{
+		.id = QCA9377_HW_1_0_DEV_VERSION,
+		.name = "qca9377 hw1.0",
+		.patch_load_addr = QCA9377_HW_1_0_PATCH_LOAD_ADDR,
+		.uart_pin = 7,
+		.otp_exe_param = 0,
+		.fw = {
+			.dir = QCA9377_HW_1_0_FW_DIR,
+			.fw = QCA9377_HW_1_0_FW_FILE,
+			.otp = QCA9377_HW_1_0_OTP_FILE,
+			.board = QCA9377_HW_1_0_BOARD_DATA_FILE,
+			.board_size = QCA9377_BOARD_DATA_SZ,
+			.board_ext_size = QCA9377_BOARD_EXT_DATA_SZ,
+		},
+	},
 };
 
 static const char *const ath10k_core_fw_feature_str[] = {
@@ -1900,6 +1915,7 @@ struct ath10k *ath10k_core_create(size_t priv_size, struct device *dev,
 		ar->hw_values = &qca988x_values;
 		break;
 	case ATH10K_HW_QCA6174:
+	case ATH10K_HW_QCA9377:
 		ar->regs = &qca6174_regs;
 		ar->hw_values = &qca6174_values;
 		break;
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 2d87737e35ff..b70f167200ef 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -84,6 +84,15 @@ enum qca6174_chip_id_rev {
 #define QCA99X0_HW_2_0_BOARD_DATA_FILE "board.bin"
 #define QCA99X0_HW_2_0_PATCH_LOAD_ADDR	0x1234
 
+/* QCA9377 1.0 definitions */
+#define QCA9377_HW_1_0_DEV_VERSION     0x05020001
+#define QCA9377_HW_1_0_CHIP_ID_REV     0x1
+#define QCA9377_HW_1_0_FW_DIR          ATH10K_FW_DIR "/QCA9377/hw1.0"
+#define QCA9377_HW_1_0_FW_FILE         "firmware.bin"
+#define QCA9377_HW_1_0_OTP_FILE        "otp.bin"
+#define QCA9377_HW_1_0_BOARD_DATA_FILE "board.bin"
+#define QCA9377_HW_1_0_PATCH_LOAD_ADDR	0x1234
+
 #define ATH10K_FW_API2_FILE		"firmware-2.bin"
 #define ATH10K_FW_API3_FILE		"firmware-3.bin"
 
@@ -176,6 +185,7 @@ enum ath10k_hw_rev {
 	ATH10K_HW_QCA988X,
 	ATH10K_HW_QCA6174,
 	ATH10K_HW_QCA99X0,
+	ATH10K_HW_QCA9377,
 };
 
 struct ath10k_hw_regs {
@@ -228,6 +238,7 @@ void ath10k_hw_fill_survey_time(struct ath10k *ar, struct survey_info *survey,
 #define QCA_REV_988X(ar) ((ar)->hw_rev == ATH10K_HW_QCA988X)
 #define QCA_REV_6174(ar) ((ar)->hw_rev == ATH10K_HW_QCA6174)
 #define QCA_REV_99X0(ar) ((ar)->hw_rev == ATH10K_HW_QCA99X0)
+#define QCA_REV_9377(ar) ((ar)->hw_rev == ATH10K_HW_QCA9377)
 
 /* Known pecularities:
  *  - raw appears in nwifi decap, raw and nwifi appear in ethernet decap
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 5c05b0cf54a1..f7ad69be6c44 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -61,12 +61,14 @@ MODULE_PARM_DESC(reset_mode, "0: auto, 1: warm only (default: 0)");
 #define QCA6164_2_1_DEVICE_ID	(0x0041)
 #define QCA6174_2_1_DEVICE_ID	(0x003e)
 #define QCA99X0_2_0_DEVICE_ID	(0x0040)
+#define QCA9377_1_0_DEVICE_ID	(0x0042)
 
 static const struct pci_device_id ath10k_pci_id_table[] = {
 	{ PCI_VDEVICE(ATHEROS, QCA988X_2_0_DEVICE_ID) }, /* PCI-E QCA988X V2 */
 	{ PCI_VDEVICE(ATHEROS, QCA6164_2_1_DEVICE_ID) }, /* PCI-E QCA6164 V2.1 */
 	{ PCI_VDEVICE(ATHEROS, QCA6174_2_1_DEVICE_ID) }, /* PCI-E QCA6174 V2.1 */
 	{ PCI_VDEVICE(ATHEROS, QCA99X0_2_0_DEVICE_ID) }, /* PCI-E QCA99X0 V2 */
+	{ PCI_VDEVICE(ATHEROS, QCA9377_1_0_DEVICE_ID) }, /* PCI-E QCA9377 V1 */
 	{0}
 };
 
@@ -90,6 +92,7 @@ static const struct ath10k_pci_supp_chip ath10k_pci_supp_chips[] = {
 	{ QCA6174_2_1_DEVICE_ID, QCA6174_HW_3_2_CHIP_ID_REV },
 
 	{ QCA99X0_2_0_DEVICE_ID, QCA99X0_HW_2_0_CHIP_ID_REV },
+	{ QCA9377_1_0_DEVICE_ID, QCA9377_HW_1_0_CHIP_ID_REV },
 };
 
 static void ath10k_pci_buffer_cleanup(struct ath10k *ar);
@@ -827,6 +830,7 @@ static u32 ath10k_pci_targ_cpu_to_ce_addr(struct ath10k *ar, u32 addr)
 	switch (ar->hw_rev) {
 	case ATH10K_HW_QCA988X:
 	case ATH10K_HW_QCA6174:
+	case ATH10K_HW_QCA9377:
 		val = (ath10k_pci_read32(ar, SOC_CORE_BASE_ADDRESS +
 					  CORE_CTRL_ADDRESS) &
 		       0x7ff) << 21;
@@ -1513,6 +1517,7 @@ static void ath10k_pci_irq_msi_fw_mask(struct ath10k *ar)
 	switch (ar->hw_rev) {
 	case ATH10K_HW_QCA988X:
 	case ATH10K_HW_QCA6174:
+	case ATH10K_HW_QCA9377:
 		val = ath10k_pci_read32(ar, SOC_CORE_BASE_ADDRESS +
 					CORE_CTRL_ADDRESS);
 		val &= ~CORE_CTRL_PCIE_REG_31_MASK;
@@ -1534,6 +1539,7 @@ static void ath10k_pci_irq_msi_fw_unmask(struct ath10k *ar)
 	switch (ar->hw_rev) {
 	case ATH10K_HW_QCA988X:
 	case ATH10K_HW_QCA6174:
+	case ATH10K_HW_QCA9377:
 		val = ath10k_pci_read32(ar, SOC_CORE_BASE_ADDRESS +
 					CORE_CTRL_ADDRESS);
 		val |= CORE_CTRL_PCIE_REG_31_MASK;
@@ -1911,6 +1917,8 @@ static int ath10k_pci_get_num_banks(struct ath10k *ar)
 			return 9;
 		}
 		break;
+	case QCA9377_1_0_DEVICE_ID:
+		return 2;
 	}
 
 	ath10k_warn(ar, "unknown number of banks, assuming 1\n");
@@ -2371,6 +2379,8 @@ static int ath10k_pci_chip_reset(struct ath10k *ar)
 		return ath10k_pci_qca988x_chip_reset(ar);
 	else if (QCA_REV_6174(ar))
 		return ath10k_pci_qca6174_chip_reset(ar);
+	else if (QCA_REV_9377(ar))
+		return ath10k_pci_qca6174_chip_reset(ar);
 	else if (QCA_REV_99X0(ar))
 		return ath10k_pci_qca99x0_chip_reset(ar);
 	else
@@ -3003,6 +3013,10 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 		hw_rev = ATH10K_HW_QCA99X0;
 		pci_ps = false;
 		break;
+	case QCA9377_1_0_DEVICE_ID:
+		hw_rev = ATH10K_HW_QCA9377;
+		pci_ps = true;
+		break;
 	default:
 		WARN_ON(1);
 		return -ENOTSUPP;
@@ -3204,3 +3218,7 @@ MODULE_FIRMWARE(QCA6174_HW_3_0_FW_DIR "/" ATH10K_FW_API4_FILE);
 MODULE_FIRMWARE(QCA6174_HW_3_0_FW_DIR "/" ATH10K_FW_API5_FILE);
 MODULE_FIRMWARE(QCA6174_HW_3_0_FW_DIR "/" QCA6174_HW_3_0_BOARD_DATA_FILE);
 MODULE_FIRMWARE(QCA6174_HW_3_0_FW_DIR "/" ATH10K_BOARD_API2_FILE);
+
+/* QCA9377 1.0 firmware files */
+MODULE_FIRMWARE(QCA9377_HW_1_0_FW_DIR "/" ATH10K_FW_API5_FILE);
+MODULE_FIRMWARE(QCA9377_HW_1_0_FW_DIR "/" QCA9377_HW_1_0_BOARD_DATA_FILE);
diff --git a/drivers/net/wireless/ath/ath10k/targaddrs.h b/drivers/net/wireless/ath/ath10k/targaddrs.h
index 768bef629099..05a421bc322a 100644
--- a/drivers/net/wireless/ath/ath10k/targaddrs.h
+++ b/drivers/net/wireless/ath/ath10k/targaddrs.h
@@ -450,6 +450,9 @@ Fw Mode/SubMode Mask
 #define QCA6174_BOARD_DATA_SZ     8192
 #define QCA6174_BOARD_EXT_DATA_SZ 0
 
+#define QCA9377_BOARD_DATA_SZ     QCA6174_BOARD_DATA_SZ
+#define QCA9377_BOARD_EXT_DATA_SZ 0
+
 #define QCA99X0_BOARD_DATA_SZ	  12288
 #define QCA99X0_BOARD_EXT_DATA_SZ 0
 
-- 
2.1.2

