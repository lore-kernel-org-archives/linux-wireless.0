Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:36180 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbbHMMcI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2015 08:32:08 -0400
Received: by lagz9 with SMTP id z9so25191197lag.3
        for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2015 05:32:06 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: arnd@arndb.de, twilightrook@gmail.com, vvanpo@gmail.com,
	linux-wireless@vger.kernel.org, oscarrydberg@gmail.com,
	joseph.salisbury@canonical.com,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH/RFT 2/2] ath10k: rename qca6174 to qca61x4
Date: Thu, 13 Aug 2015 14:32:27 +0200
Message-Id: <1439469147-9408-3-git-send-email-michal.kazior@tieto.com> (sfid-20150813_143213_496431_340E8955)
In-Reply-To: <1439469147-9408-1-git-send-email-michal.kazior@tieto.com>
References: <1439469147-9408-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This cleans up the naming a little bit. Both
QCA6174 and QCA6164 are in practice the same as
far as driving them is concerned.

Unfortunately firmware paths will need to stay
untouched, i.e. QCA6164 firmware will still be
looked for in QCA6174 to avoid breaking backward
compatibility with older /lib/firmware setups.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c      | 60 +++++++++++------------
 drivers/net/wireless/ath/ath10k/hw.c        |  4 +-
 drivers/net/wireless/ath/ath10k/hw.h        | 70 +++++++++++++--------------
 drivers/net/wireless/ath/ath10k/pci.c       | 74 ++++++++++++++---------------
 drivers/net/wireless/ath/ath10k/pci.h       |  2 +-
 drivers/net/wireless/ath/ath10k/rx_desc.h   |  4 +-
 drivers/net/wireless/ath/ath10k/targaddrs.h |  4 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.h   |  2 +-
 8 files changed, 110 insertions(+), 110 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 1ea16d044645..9074022fdf84 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -63,49 +63,49 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		},
 	},
 	{
-		.id = QCA6174_HW_2_1_VERSION,
-		.name = "qca6174 hw2.1",
-		.patch_load_addr = QCA6174_HW_2_1_PATCH_LOAD_ADDR,
+		.id = QCA61X4_HW_2_1_VERSION,
+		.name = "qca61x4 hw2.1",
+		.patch_load_addr = QCA61X4_HW_2_1_PATCH_LOAD_ADDR,
 		.uart_pin = 6,
 		.otp_exe_param = 0,
 		.fw = {
-			.dir = QCA6174_HW_2_1_FW_DIR,
-			.fw = QCA6174_HW_2_1_FW_FILE,
-			.otp = QCA6174_HW_2_1_OTP_FILE,
-			.board = QCA6174_HW_2_1_BOARD_DATA_FILE,
-			.board_size = QCA6174_BOARD_DATA_SZ,
-			.board_ext_size = QCA6174_BOARD_EXT_DATA_SZ,
+			.dir = QCA61X4_HW_2_1_FW_DIR,
+			.fw = QCA61X4_HW_2_1_FW_FILE,
+			.otp = QCA61X4_HW_2_1_OTP_FILE,
+			.board = QCA61X4_HW_2_1_BOARD_DATA_FILE,
+			.board_size = QCA61X4_BOARD_DATA_SZ,
+			.board_ext_size = QCA61X4_BOARD_EXT_DATA_SZ,
 		},
 	},
 	{
-		.id = QCA6174_HW_3_0_VERSION,
-		.name = "qca6174 hw3.0",
-		.patch_load_addr = QCA6174_HW_3_0_PATCH_LOAD_ADDR,
+		.id = QCA61X4_HW_3_0_VERSION,
+		.name = "qca61x4 hw3.0",
+		.patch_load_addr = QCA61X4_HW_3_0_PATCH_LOAD_ADDR,
 		.uart_pin = 6,
 		.otp_exe_param = 0,
 		.fw = {
-			.dir = QCA6174_HW_3_0_FW_DIR,
-			.fw = QCA6174_HW_3_0_FW_FILE,
-			.otp = QCA6174_HW_3_0_OTP_FILE,
-			.board = QCA6174_HW_3_0_BOARD_DATA_FILE,
-			.board_size = QCA6174_BOARD_DATA_SZ,
-			.board_ext_size = QCA6174_BOARD_EXT_DATA_SZ,
+			.dir = QCA61X4_HW_3_0_FW_DIR,
+			.fw = QCA61X4_HW_3_0_FW_FILE,
+			.otp = QCA61X4_HW_3_0_OTP_FILE,
+			.board = QCA61X4_HW_3_0_BOARD_DATA_FILE,
+			.board_size = QCA61X4_BOARD_DATA_SZ,
+			.board_ext_size = QCA61X4_BOARD_EXT_DATA_SZ,
 		},
 	},
 	{
-		.id = QCA6174_HW_3_2_VERSION,
-		.name = "qca6174 hw3.2",
-		.patch_load_addr = QCA6174_HW_3_0_PATCH_LOAD_ADDR,
+		.id = QCA61X4_HW_3_2_VERSION,
+		.name = "qca61x4 hw3.2",
+		.patch_load_addr = QCA61X4_HW_3_0_PATCH_LOAD_ADDR,
 		.uart_pin = 6,
 		.otp_exe_param = 0,
 		.fw = {
 			/* uses same binaries as hw3.0 */
-			.dir = QCA6174_HW_3_0_FW_DIR,
-			.fw = QCA6174_HW_3_0_FW_FILE,
-			.otp = QCA6174_HW_3_0_OTP_FILE,
-			.board = QCA6174_HW_3_0_BOARD_DATA_FILE,
-			.board_size = QCA6174_BOARD_DATA_SZ,
-			.board_ext_size = QCA6174_BOARD_EXT_DATA_SZ,
+			.dir = QCA61X4_HW_3_0_FW_DIR,
+			.fw = QCA61X4_HW_3_0_FW_FILE,
+			.otp = QCA61X4_HW_3_0_OTP_FILE,
+			.board = QCA61X4_HW_3_0_BOARD_DATA_FILE,
+			.board_size = QCA61X4_BOARD_DATA_SZ,
+			.board_ext_size = QCA61X4_BOARD_EXT_DATA_SZ,
 		},
 	},
 	{
@@ -1629,9 +1629,9 @@ struct ath10k *ath10k_core_create(size_t priv_size, struct device *dev,
 		ar->regs = &qca988x_regs;
 		ar->hw_values = &qca988x_values;
 		break;
-	case ATH10K_HW_QCA6174:
-		ar->regs = &qca6174_regs;
-		ar->hw_values = &qca6174_values;
+	case ATH10K_HW_QCA61X4:
+		ar->regs = &qca61x4_regs;
+		ar->hw_values = &qca61x4_values;
 		break;
 	case ATH10K_HW_QCA99X0:
 		ar->regs = &qca99x0_regs;
diff --git a/drivers/net/wireless/ath/ath10k/hw.c b/drivers/net/wireless/ath/ath10k/hw.c
index fef7ccf6e185..8549e60c8f21 100644
--- a/drivers/net/wireless/ath/ath10k/hw.c
+++ b/drivers/net/wireless/ath/ath10k/hw.c
@@ -45,7 +45,7 @@ const struct ath10k_hw_regs qca988x_regs = {
 	.pcie_intr_clr_address		= 0x00000014,
 };
 
-const struct ath10k_hw_regs qca6174_regs = {
+const struct ath10k_hw_regs qca61x4_regs = {
 	.rtc_state_cold_reset_mask		= 0x00002000,
 	.rtc_soc_base_address			= 0x00000800,
 	.rtc_wmac_base_address			= 0x00001000,
@@ -118,7 +118,7 @@ const struct ath10k_hw_values qca988x_values = {
 	.ce_desc_meta_data_lsb		= 2,
 };
 
-const struct ath10k_hw_values qca6174_values = {
+const struct ath10k_hw_values qca61x4_values = {
 	.rtc_state_val_on		= 3,
 	.ce_count			= 8,
 	.msi_assign_ce_max		= 7,
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index d9de4a738470..0fe3dc33d0f2 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -34,43 +34,43 @@
 #define QCA988X_HW_2_0_BOARD_DATA_FILE	"board.bin"
 #define QCA988X_HW_2_0_PATCH_LOAD_ADDR	0x1234
 
-/* QCA6174 target BMI version signatures */
-#define QCA6174_HW_1_0_VERSION		0x05000000
-#define QCA6174_HW_1_1_VERSION		0x05000001
-#define QCA6174_HW_1_3_VERSION		0x05000003
-#define QCA6174_HW_2_1_VERSION		0x05010000
-#define QCA6174_HW_3_0_VERSION		0x05020000
-#define QCA6174_HW_3_2_VERSION		0x05030000
+/* QCA61X4 target BMI version signatures */
+#define QCA61X4_HW_1_0_VERSION		0x05000000
+#define QCA61X4_HW_1_1_VERSION		0x05000001
+#define QCA61X4_HW_1_3_VERSION		0x05000003
+#define QCA61X4_HW_2_1_VERSION		0x05010000
+#define QCA61X4_HW_3_0_VERSION		0x05020000
+#define QCA61X4_HW_3_2_VERSION		0x05030000
 
-enum qca6174_pci_rev {
-	QCA6174_PCI_REV_1_1 = 0x11,
-	QCA6174_PCI_REV_1_3 = 0x13,
-	QCA6174_PCI_REV_2_0 = 0x20,
-	QCA6174_PCI_REV_3_0 = 0x30,
+enum qca61x4_pci_rev {
+	QCA61X4_PCI_REV_1_1 = 0x11,
+	QCA61X4_PCI_REV_1_3 = 0x13,
+	QCA61X4_PCI_REV_2_0 = 0x20,
+	QCA61X4_PCI_REV_3_0 = 0x30,
 };
 
-enum qca6174_chip_id_rev {
-	QCA6174_HW_1_0_CHIP_ID_REV = 0,
-	QCA6174_HW_1_1_CHIP_ID_REV = 1,
-	QCA6174_HW_1_3_CHIP_ID_REV = 2,
-	QCA6174_HW_2_1_CHIP_ID_REV = 4,
-	QCA6174_HW_2_2_CHIP_ID_REV = 5,
-	QCA6174_HW_3_0_CHIP_ID_REV = 8,
-	QCA6174_HW_3_1_CHIP_ID_REV = 9,
-	QCA6174_HW_3_2_CHIP_ID_REV = 10,
+enum qca61x4_chip_id_rev {
+	QCA61X4_HW_1_0_CHIP_ID_REV = 0,
+	QCA61X4_HW_1_1_CHIP_ID_REV = 1,
+	QCA61X4_HW_1_3_CHIP_ID_REV = 2,
+	QCA61X4_HW_2_1_CHIP_ID_REV = 4,
+	QCA61X4_HW_2_2_CHIP_ID_REV = 5,
+	QCA61X4_HW_3_0_CHIP_ID_REV = 8,
+	QCA61X4_HW_3_1_CHIP_ID_REV = 9,
+	QCA61X4_HW_3_2_CHIP_ID_REV = 10,
 };
 
-#define QCA6174_HW_2_1_FW_DIR		"ath10k/QCA6174/hw2.1"
-#define QCA6174_HW_2_1_FW_FILE		"firmware.bin"
-#define QCA6174_HW_2_1_OTP_FILE		"otp.bin"
-#define QCA6174_HW_2_1_BOARD_DATA_FILE	"board.bin"
-#define QCA6174_HW_2_1_PATCH_LOAD_ADDR	0x1234
+#define QCA61X4_HW_2_1_FW_DIR		"ath10k/QCA6174/hw2.1"
+#define QCA61X4_HW_2_1_FW_FILE		"firmware.bin"
+#define QCA61X4_HW_2_1_OTP_FILE		"otp.bin"
+#define QCA61X4_HW_2_1_BOARD_DATA_FILE	"board.bin"
+#define QCA61X4_HW_2_1_PATCH_LOAD_ADDR	0x1234
 
-#define QCA6174_HW_3_0_FW_DIR		"ath10k/QCA6174/hw3.0"
-#define QCA6174_HW_3_0_FW_FILE		"firmware.bin"
-#define QCA6174_HW_3_0_OTP_FILE		"otp.bin"
-#define QCA6174_HW_3_0_BOARD_DATA_FILE	"board.bin"
-#define QCA6174_HW_3_0_PATCH_LOAD_ADDR	0x1234
+#define QCA61X4_HW_3_0_FW_DIR		"ath10k/QCA6174/hw3.0"
+#define QCA61X4_HW_3_0_FW_FILE		"firmware.bin"
+#define QCA61X4_HW_3_0_OTP_FILE		"otp.bin"
+#define QCA61X4_HW_3_0_BOARD_DATA_FILE	"board.bin"
+#define QCA61X4_HW_3_0_PATCH_LOAD_ADDR	0x1234
 
 /* QCA99X0 1.0 definitions (unsupported) */
 #define QCA99X0_HW_1_0_CHIP_ID_REV     0x0
@@ -161,7 +161,7 @@ enum ath10k_fw_htt_op_version {
 
 enum ath10k_hw_rev {
 	ATH10K_HW_QCA988X,
-	ATH10K_HW_QCA6174,
+	ATH10K_HW_QCA61X4,
 	ATH10K_HW_QCA99X0,
 };
 
@@ -193,7 +193,7 @@ struct ath10k_hw_regs {
 };
 
 extern const struct ath10k_hw_regs qca988x_regs;
-extern const struct ath10k_hw_regs qca6174_regs;
+extern const struct ath10k_hw_regs qca61x4_regs;
 extern const struct ath10k_hw_regs qca99x0_regs;
 
 struct ath10k_hw_values {
@@ -206,14 +206,14 @@ struct ath10k_hw_values {
 };
 
 extern const struct ath10k_hw_values qca988x_values;
-extern const struct ath10k_hw_values qca6174_values;
+extern const struct ath10k_hw_values qca61x4_values;
 extern const struct ath10k_hw_values qca99x0_values;
 
 void ath10k_hw_fill_survey_time(struct ath10k *ar, struct survey_info *survey,
 				u32 cc, u32 rcc, u32 cc_prev, u32 rcc_prev);
 
 #define QCA_REV_988X(ar) ((ar)->hw_rev == ATH10K_HW_QCA988X)
-#define QCA_REV_6174(ar) ((ar)->hw_rev == ATH10K_HW_QCA6174)
+#define QCA_REV_61X4(ar) ((ar)->hw_rev == ATH10K_HW_QCA61X4)
 #define QCA_REV_99X0(ar) ((ar)->hw_rev == ATH10K_HW_QCA99X0)
 
 /* Known pecularities:
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 49a7538325e3..10a5d72b9bff 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -77,17 +77,17 @@ static const struct ath10k_pci_supp_chip ath10k_pci_supp_chips[] = {
 	 */
 	{ QCA988X_2_0_DEVICE_ID, QCA988X_HW_2_0_CHIP_ID_REV },
 
-	{ QCA6164_2_1_DEVICE_ID, QCA6174_HW_2_1_CHIP_ID_REV },
-	{ QCA6164_2_1_DEVICE_ID, QCA6174_HW_2_2_CHIP_ID_REV },
-	{ QCA6164_2_1_DEVICE_ID, QCA6174_HW_3_0_CHIP_ID_REV },
-	{ QCA6164_2_1_DEVICE_ID, QCA6174_HW_3_1_CHIP_ID_REV },
-	{ QCA6164_2_1_DEVICE_ID, QCA6174_HW_3_2_CHIP_ID_REV },
+	{ QCA6164_2_1_DEVICE_ID, QCA61X4_HW_2_1_CHIP_ID_REV },
+	{ QCA6164_2_1_DEVICE_ID, QCA61X4_HW_2_2_CHIP_ID_REV },
+	{ QCA6164_2_1_DEVICE_ID, QCA61X4_HW_3_0_CHIP_ID_REV },
+	{ QCA6164_2_1_DEVICE_ID, QCA61X4_HW_3_1_CHIP_ID_REV },
+	{ QCA6164_2_1_DEVICE_ID, QCA61X4_HW_3_2_CHIP_ID_REV },
 
-	{ QCA6174_2_1_DEVICE_ID, QCA6174_HW_2_1_CHIP_ID_REV },
-	{ QCA6174_2_1_DEVICE_ID, QCA6174_HW_2_2_CHIP_ID_REV },
-	{ QCA6174_2_1_DEVICE_ID, QCA6174_HW_3_0_CHIP_ID_REV },
-	{ QCA6174_2_1_DEVICE_ID, QCA6174_HW_3_1_CHIP_ID_REV },
-	{ QCA6174_2_1_DEVICE_ID, QCA6174_HW_3_2_CHIP_ID_REV },
+	{ QCA6174_2_1_DEVICE_ID, QCA61X4_HW_2_1_CHIP_ID_REV },
+	{ QCA6174_2_1_DEVICE_ID, QCA61X4_HW_2_2_CHIP_ID_REV },
+	{ QCA6174_2_1_DEVICE_ID, QCA61X4_HW_3_0_CHIP_ID_REV },
+	{ QCA6174_2_1_DEVICE_ID, QCA61X4_HW_3_1_CHIP_ID_REV },
+	{ QCA6174_2_1_DEVICE_ID, QCA61X4_HW_3_2_CHIP_ID_REV },
 
 	{ QCA99X0_2_0_DEVICE_ID, QCA99X0_HW_2_0_CHIP_ID_REV },
 };
@@ -774,7 +774,7 @@ static u32 ath10k_pci_targ_cpu_to_ce_addr(struct ath10k *ar, u32 addr)
 
 	switch (ar->hw_rev) {
 	case ATH10K_HW_QCA988X:
-	case ATH10K_HW_QCA6174:
+	case ATH10K_HW_QCA61X4:
 		val = (ath10k_pci_read32(ar, SOC_CORE_BASE_ADDRESS +
 					  CORE_CTRL_ADDRESS) &
 		       0x7ff) << 21;
@@ -1442,7 +1442,7 @@ static void ath10k_pci_irq_msi_fw_mask(struct ath10k *ar)
 
 	switch (ar->hw_rev) {
 	case ATH10K_HW_QCA988X:
-	case ATH10K_HW_QCA6174:
+	case ATH10K_HW_QCA61X4:
 		val = ath10k_pci_read32(ar, SOC_CORE_BASE_ADDRESS +
 					CORE_CTRL_ADDRESS);
 		val &= ~CORE_CTRL_PCIE_REG_31_MASK;
@@ -1463,7 +1463,7 @@ static void ath10k_pci_irq_msi_fw_unmask(struct ath10k *ar)
 
 	switch (ar->hw_rev) {
 	case ATH10K_HW_QCA988X:
-	case ATH10K_HW_QCA6174:
+	case ATH10K_HW_QCA61X4:
 		val = ath10k_pci_read32(ar, SOC_CORE_BASE_ADDRESS +
 					CORE_CTRL_ADDRESS);
 		val |= CORE_CTRL_PCIE_REG_31_MASK;
@@ -1823,16 +1823,16 @@ static int ath10k_pci_get_num_banks(struct ath10k *ar)
 	case QCA6164_2_1_DEVICE_ID:
 	case QCA6174_2_1_DEVICE_ID:
 		switch (MS(ar->chip_id, SOC_CHIP_ID_REV)) {
-		case QCA6174_HW_1_0_CHIP_ID_REV:
-		case QCA6174_HW_1_1_CHIP_ID_REV:
-		case QCA6174_HW_2_1_CHIP_ID_REV:
-		case QCA6174_HW_2_2_CHIP_ID_REV:
+		case QCA61X4_HW_1_0_CHIP_ID_REV:
+		case QCA61X4_HW_1_1_CHIP_ID_REV:
+		case QCA61X4_HW_2_1_CHIP_ID_REV:
+		case QCA61X4_HW_2_2_CHIP_ID_REV:
 			return 3;
-		case QCA6174_HW_1_3_CHIP_ID_REV:
+		case QCA61X4_HW_1_3_CHIP_ID_REV:
 			return 2;
-		case QCA6174_HW_3_0_CHIP_ID_REV:
-		case QCA6174_HW_3_1_CHIP_ID_REV:
-		case QCA6174_HW_3_2_CHIP_ID_REV:
+		case QCA61X4_HW_3_0_CHIP_ID_REV:
+		case QCA61X4_HW_3_1_CHIP_ID_REV:
+		case QCA61X4_HW_3_2_CHIP_ID_REV:
 			return 9;
 		}
 		break;
@@ -2152,7 +2152,7 @@ static int ath10k_pci_warm_reset(struct ath10k *ar)
 
 static int ath10k_pci_safe_chip_reset(struct ath10k *ar)
 {
-	if (QCA_REV_988X(ar) || QCA_REV_6174(ar)) {
+	if (QCA_REV_988X(ar) || QCA_REV_61X4(ar)) {
 		return ath10k_pci_warm_reset(ar);
 	} else if (QCA_REV_99X0(ar)) {
 		ath10k_pci_irq_disable(ar);
@@ -2236,13 +2236,13 @@ static int ath10k_pci_qca988x_chip_reset(struct ath10k *ar)
 	return 0;
 }
 
-static int ath10k_pci_qca6174_chip_reset(struct ath10k *ar)
+static int ath10k_pci_qca61x4_chip_reset(struct ath10k *ar)
 {
 	int ret;
 
-	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot qca6174 chip reset\n");
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot qca61x4 chip reset\n");
 
-	/* FIXME: QCA6174 requires cold + warm reset to work. */
+	/* FIXME: QCA61X4 requires cold + warm reset to work. */
 
 	ret = ath10k_pci_cold_reset(ar);
 	if (ret) {
@@ -2263,7 +2263,7 @@ static int ath10k_pci_qca6174_chip_reset(struct ath10k *ar)
 		return ret;
 	}
 
-	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot qca6174 chip reset complete (cold)\n");
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot qca61x4 chip reset complete (cold)\n");
 
 	return 0;
 }
@@ -2296,8 +2296,8 @@ static int ath10k_pci_chip_reset(struct ath10k *ar)
 {
 	if (QCA_REV_988X(ar))
 		return ath10k_pci_qca988x_chip_reset(ar);
-	else if (QCA_REV_6174(ar))
-		return ath10k_pci_qca6174_chip_reset(ar);
+	else if (QCA_REV_61X4(ar))
+		return ath10k_pci_qca61x4_chip_reset(ar);
 	else if (QCA_REV_99X0(ar))
 		return ath10k_pci_qca99x0_chip_reset(ar);
 	else
@@ -2911,7 +2911,7 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 		break;
 	case QCA6164_2_1_DEVICE_ID:
 	case QCA6174_2_1_DEVICE_ID:
-		hw_rev = ATH10K_HW_QCA6174;
+		hw_rev = ATH10K_HW_QCA61X4;
 		break;
 	case QCA99X0_2_0_DEVICE_ID:
 		hw_rev = ATH10K_HW_QCA99X0;
@@ -3095,12 +3095,12 @@ MODULE_FIRMWARE(QCA988X_HW_2_0_FW_DIR "/" ATH10K_FW_API4_FILE);
 MODULE_FIRMWARE(QCA988X_HW_2_0_FW_DIR "/" ATH10K_FW_API5_FILE);
 MODULE_FIRMWARE(QCA988X_HW_2_0_FW_DIR "/" QCA988X_HW_2_0_BOARD_DATA_FILE);
 
-/* QCA6174 2.1 firmware files */
-MODULE_FIRMWARE(QCA6174_HW_2_1_FW_DIR "/" ATH10K_FW_API4_FILE);
-MODULE_FIRMWARE(QCA6174_HW_2_1_FW_DIR "/" ATH10K_FW_API5_FILE);
-MODULE_FIRMWARE(QCA6174_HW_2_1_FW_DIR "/" QCA6174_HW_2_1_BOARD_DATA_FILE);
+/* QCA61X4 2.1 firmware files */
+MODULE_FIRMWARE(QCA61X4_HW_2_1_FW_DIR "/" ATH10K_FW_API4_FILE);
+MODULE_FIRMWARE(QCA61X4_HW_2_1_FW_DIR "/" ATH10K_FW_API5_FILE);
+MODULE_FIRMWARE(QCA61X4_HW_2_1_FW_DIR "/" QCA61X4_HW_2_1_BOARD_DATA_FILE);
 
-/* QCA6174 3.1 firmware files */
-MODULE_FIRMWARE(QCA6174_HW_3_0_FW_DIR "/" ATH10K_FW_API4_FILE);
-MODULE_FIRMWARE(QCA6174_HW_3_0_FW_DIR "/" ATH10K_FW_API5_FILE);
-MODULE_FIRMWARE(QCA6174_HW_3_0_FW_DIR "/" QCA6174_HW_3_0_BOARD_DATA_FILE);
+/* QCA61X4 3.1 firmware files */
+MODULE_FIRMWARE(QCA61X4_HW_3_0_FW_DIR "/" ATH10K_FW_API4_FILE);
+MODULE_FIRMWARE(QCA61X4_HW_3_0_FW_DIR "/" ATH10K_FW_API5_FILE);
+MODULE_FIRMWARE(QCA61X4_HW_3_0_FW_DIR "/" QCA61X4_HW_3_0_BOARD_DATA_FILE);
diff --git a/drivers/net/wireless/ath/ath10k/pci.h b/drivers/net/wireless/ath/ath10k/pci.h
index 8d364fb8f743..b4d14e8a052f 100644
--- a/drivers/net/wireless/ath/ath10k/pci.h
+++ b/drivers/net/wireless/ath/ath10k/pci.h
@@ -248,7 +248,7 @@ u32 ath10k_pci_read32(struct ath10k *ar, u32 offset);
 u32 ath10k_pci_soc_read32(struct ath10k *ar, u32 addr);
 u32 ath10k_pci_reg_read32(struct ath10k *ar, u32 addr);
 
-/* QCA6174 is known to have Tx/Rx issues when SOC_WAKE register is poked too
+/* QCA61X4 is known to have Tx/Rx issues when SOC_WAKE register is poked too
  * frequently. To avoid this put SoC to sleep after a very conservative grace
  * period. Adjust with great care.
  */
diff --git a/drivers/net/wireless/ath/ath10k/rx_desc.h b/drivers/net/wireless/ath/ath10k/rx_desc.h
index ca8d16884af1..affabb26880d 100644
--- a/drivers/net/wireless/ath/ath10k/rx_desc.h
+++ b/drivers/net/wireless/ath/ath10k/rx_desc.h
@@ -959,7 +959,7 @@ struct rx_ppdu_end_qca988x {
 #define RX_PPDU_END_RTT_UNUSED_LSB             24
 #define RX_PPDU_END_RTT_NORMAL_MODE            BIT(31)
 
-struct rx_ppdu_end_qca6174 {
+struct rx_ppdu_end_qca61x4 {
 	u8 locationing_timestamp;
 	u8 phy_err_code;
 	__le16 flags; /* %RX_PPDU_END_FLAGS_ */
@@ -1078,7 +1078,7 @@ struct rx_ppdu_end {
 	struct rx_ppdu_end_common common;
 	union {
 		struct rx_ppdu_end_qca988x qca988x;
-		struct rx_ppdu_end_qca6174 qca6174;
+		struct rx_ppdu_end_qca61x4 qca61x4;
 		struct rx_ppdu_end_qca99x0 qca99x0;
 	} __packed;
 } __packed;
diff --git a/drivers/net/wireless/ath/ath10k/targaddrs.h b/drivers/net/wireless/ath/ath10k/targaddrs.h
index 768bef629099..db6b86d1fcd2 100644
--- a/drivers/net/wireless/ath/ath10k/targaddrs.h
+++ b/drivers/net/wireless/ath/ath10k/targaddrs.h
@@ -447,8 +447,8 @@ Fw Mode/SubMode Mask
 #define QCA988X_BOARD_DATA_SZ     7168
 #define QCA988X_BOARD_EXT_DATA_SZ 0
 
-#define QCA6174_BOARD_DATA_SZ     8192
-#define QCA6174_BOARD_EXT_DATA_SZ 0
+#define QCA61X4_BOARD_DATA_SZ     8192
+#define QCA61X4_BOARD_EXT_DATA_SZ 0
 
 #define QCA99X0_BOARD_DATA_SZ	  12288
 #define QCA99X0_BOARD_EXT_DATA_SZ 0
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.h b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
index ad655c44afdb..21ef7d395aa0 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
@@ -1135,7 +1135,7 @@ struct wmi_tlv_abi_version {
 
 enum wmi_tlv_hw_bd_id {
 	WMI_TLV_HW_BD_LEGACY = 0,
-	WMI_TLV_HW_BD_QCA6174 = 1,
+	WMI_TLV_HW_BD_QCA61X4 = 1,
 	WMI_TLV_HW_BD_QCA2582 = 2,
 };
 
-- 
2.1.4

