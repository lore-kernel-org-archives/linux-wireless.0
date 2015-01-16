Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:37331 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369AbbAPL3A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2015 06:29:00 -0500
Received: by mail-wi0-f175.google.com with SMTP id l15so3397808wiw.2
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2015 03:28:59 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 3/3] ath10k: add support for qca6174
Date: Fri, 16 Jan 2015 12:20:37 +0100
Message-Id: <1421407237-24159-3-git-send-email-michal.kazior@tieto.com> (sfid-20150116_122911_556457_BEE6E6FE)
In-Reply-To: <1421407237-24159-1-git-send-email-michal.kazior@tieto.com>
References: <1421407237-24159-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The QCA6174 in combination with new wmi-tlv
firmware is capable of multi-channel, beamforming,
tdls and other features.

This patch just makes it possible to boot these
devices and do some basic stuff. Some things may
not work or may be unreliable. New features will
be implemented later. This will be addressed
eventually with future patches.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/Makefile    |   3 +-
 drivers/net/wireless/ath/ath10k/ce.c        |  12 ++--
 drivers/net/wireless/ath/ath10k/ce.h        |   2 +-
 drivers/net/wireless/ath/ath10k/core.c      |  44 ++++++++++++
 drivers/net/wireless/ath/ath10k/core.h      |   6 +-
 drivers/net/wireless/ath/ath10k/hw.c        |  59 ++++++++++++++++
 drivers/net/wireless/ath/ath10k/hw.h        | 102 ++++++++++++++++++++++-----
 drivers/net/wireless/ath/ath10k/pci.c       | 105 ++++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath10k/targaddrs.h |   5 ++
 9 files changed, 303 insertions(+), 35 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath10k/hw.c

diff --git a/drivers/net/wireless/ath/ath10k/Makefile b/drivers/net/wireless/ath/ath10k/Makefile
index 6c0c23e..f4dbb3e 100644
--- a/drivers/net/wireless/ath/ath10k/Makefile
+++ b/drivers/net/wireless/ath/ath10k/Makefile
@@ -9,7 +9,8 @@ ath10k_core-y += mac.o \
 		 txrx.o \
 		 wmi.o \
 		 wmi-tlv.o \
-		 bmi.o
+		 bmi.o \
+		 hw.o
 
 ath10k_core-$(CONFIG_ATH10K_DEBUGFS) += spectral.o
 ath10k_core-$(CONFIG_NL80211_TESTMODE) += testmode.o
diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index 42ec793..e508c65 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -803,7 +803,7 @@ int ath10k_ce_disable_interrupts(struct ath10k *ar)
 	int ce_id;
 
 	for (ce_id = 0; ce_id < CE_COUNT; ce_id++) {
-		u32 ctrl_addr = ath10k_ce_base_address(ce_id);
+		u32 ctrl_addr = ath10k_ce_base_address(ar, ce_id);
 
 		ath10k_ce_copy_complete_intr_disable(ar, ctrl_addr);
 		ath10k_ce_error_intr_disable(ar, ctrl_addr);
@@ -832,7 +832,7 @@ static int ath10k_ce_init_src_ring(struct ath10k *ar,
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	struct ath10k_ce_pipe *ce_state = &ar_pci->ce_states[ce_id];
 	struct ath10k_ce_ring *src_ring = ce_state->src_ring;
-	u32 nentries, ctrl_addr = ath10k_ce_base_address(ce_id);
+	u32 nentries, ctrl_addr = ath10k_ce_base_address(ar, ce_id);
 
 	nentries = roundup_pow_of_two(attr->src_nentries);
 
@@ -869,7 +869,7 @@ static int ath10k_ce_init_dest_ring(struct ath10k *ar,
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	struct ath10k_ce_pipe *ce_state = &ar_pci->ce_states[ce_id];
 	struct ath10k_ce_ring *dest_ring = ce_state->dest_ring;
-	u32 nentries, ctrl_addr = ath10k_ce_base_address(ce_id);
+	u32 nentries, ctrl_addr = ath10k_ce_base_address(ar, ce_id);
 
 	nentries = roundup_pow_of_two(attr->dest_nentries);
 
@@ -1051,7 +1051,7 @@ int ath10k_ce_init_pipe(struct ath10k *ar, unsigned int ce_id,
 
 static void ath10k_ce_deinit_src_ring(struct ath10k *ar, unsigned int ce_id)
 {
-	u32 ctrl_addr = ath10k_ce_base_address(ce_id);
+	u32 ctrl_addr = ath10k_ce_base_address(ar, ce_id);
 
 	ath10k_ce_src_ring_base_addr_set(ar, ctrl_addr, 0);
 	ath10k_ce_src_ring_size_set(ar, ctrl_addr, 0);
@@ -1061,7 +1061,7 @@ static void ath10k_ce_deinit_src_ring(struct ath10k *ar, unsigned int ce_id)
 
 static void ath10k_ce_deinit_dest_ring(struct ath10k *ar, unsigned int ce_id)
 {
-	u32 ctrl_addr = ath10k_ce_base_address(ce_id);
+	u32 ctrl_addr = ath10k_ce_base_address(ar, ce_id);
 
 	ath10k_ce_dest_ring_base_addr_set(ar, ctrl_addr, 0);
 	ath10k_ce_dest_ring_size_set(ar, ctrl_addr, 0);
@@ -1098,7 +1098,7 @@ int ath10k_ce_alloc_pipe(struct ath10k *ar, int ce_id,
 
 	ce_state->ar = ar;
 	ce_state->id = ce_id;
-	ce_state->ctrl_addr = ath10k_ce_base_address(ce_id);
+	ce_state->ctrl_addr = ath10k_ce_base_address(ar, ce_id);
 	ce_state->attr_flags = attr->flags;
 	ce_state->src_sz_max = attr->src_sz_max;
 
diff --git a/drivers/net/wireless/ath/ath10k/ce.h b/drivers/net/wireless/ath/ath10k/ce.h
index 617a151..c18647b 100644
--- a/drivers/net/wireless/ath/ath10k/ce.h
+++ b/drivers/net/wireless/ath/ath10k/ce.h
@@ -394,7 +394,7 @@ struct ce_attr {
 #define DST_WATERMARK_HIGH_RESET		0
 #define DST_WATERMARK_ADDRESS			0x0050
 
-static inline u32 ath10k_ce_base_address(unsigned int ce_id)
+static inline u32 ath10k_ce_base_address(struct ath10k *ar, unsigned int ce_id)
 {
 	return CE0_BASE_ADDRESS + (CE1_BASE_ADDRESS - CE0_BASE_ADDRESS) * ce_id;
 }
diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index a546575..79fdd25 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -57,6 +57,34 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 			.board_ext_size = QCA988X_BOARD_EXT_DATA_SZ,
 		},
 	},
+	{
+		.id = QCA6174_HW_2_1_VERSION,
+		.name = "qca6174 hw2.1",
+		.patch_load_addr = QCA6174_HW_2_1_PATCH_LOAD_ADDR,
+		.uart_pin = 6,
+		.fw = {
+			.dir = QCA6174_HW_2_1_FW_DIR,
+			.fw = QCA6174_HW_2_1_FW_FILE,
+			.otp = QCA6174_HW_2_1_OTP_FILE,
+			.board = QCA6174_HW_2_1_BOARD_DATA_FILE,
+			.board_size = QCA6174_BOARD_DATA_SZ,
+			.board_ext_size = QCA6174_BOARD_EXT_DATA_SZ,
+		},
+	},
+	{
+		.id = QCA6174_HW_3_0_VERSION,
+		.name = "qca6174 hw3.0",
+		.patch_load_addr = QCA6174_HW_3_0_PATCH_LOAD_ADDR,
+		.uart_pin = 6,
+		.fw = {
+			.dir = QCA6174_HW_3_0_FW_DIR,
+			.fw = QCA6174_HW_3_0_FW_FILE,
+			.otp = QCA6174_HW_3_0_OTP_FILE,
+			.board = QCA6174_HW_3_0_BOARD_DATA_FILE,
+			.board_size = QCA6174_BOARD_DATA_SZ,
+			.board_ext_size = QCA6174_BOARD_EXT_DATA_SZ,
+		},
+	},
 };
 
 static void ath10k_send_suspend_complete(struct ath10k *ar)
@@ -1296,6 +1324,7 @@ EXPORT_SYMBOL(ath10k_core_unregister);
 
 struct ath10k *ath10k_core_create(size_t priv_size, struct device *dev,
 				  enum ath10k_bus bus,
+				  enum ath10k_hw_rev hw_rev,
 				  const struct ath10k_hif_ops *hif_ops)
 {
 	struct ath10k *ar;
@@ -1308,9 +1337,24 @@ struct ath10k *ath10k_core_create(size_t priv_size, struct device *dev,
 	ar->ath_common.priv = ar;
 	ar->ath_common.hw = ar->hw;
 	ar->dev = dev;
+	ar->hw_rev = hw_rev;
 	ar->hif.ops = hif_ops;
 	ar->hif.bus = bus;
 
+	switch (hw_rev) {
+	case ATH10K_HW_QCA988X:
+		ar->regs = &qca988x_regs;
+		break;
+	case ATH10K_HW_QCA6174:
+		ar->regs = &qca6174_regs;
+		break;
+	default:
+		ath10k_err(ar, "unsupported core hardware revision %d\n",
+			   hw_rev);
+		ret = -ENOTSUPP;
+		goto err_free_mac;
+	}
+
 	init_completion(&ar->scan.started);
 	init_completion(&ar->scan.completed);
 	init_completion(&ar->scan.on_channel);
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index c5686122..d67eb64 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -457,6 +457,7 @@ struct ath10k {
 	struct device *dev;
 	u8 mac_addr[ETH_ALEN];
 
+	enum ath10k_hw_rev hw_rev;
 	u32 chip_id;
 	u32 target_version;
 	u8 fw_version_major;
@@ -472,9 +473,6 @@ struct ath10k {
 
 	DECLARE_BITMAP(fw_features, ATH10K_FW_FEATURE_COUNT);
 
-	struct targetdef *targetdef;
-	struct hostdef *hostdef;
-
 	bool p2p;
 
 	struct {
@@ -484,6 +482,7 @@ struct ath10k {
 
 	struct completion target_suspend;
 
+	const struct ath10k_hw_regs *regs;
 	struct ath10k_bmi bmi;
 	struct ath10k_wmi wmi;
 	struct ath10k_htc htc;
@@ -648,6 +647,7 @@ struct ath10k {
 
 struct ath10k *ath10k_core_create(size_t priv_size, struct device *dev,
 				  enum ath10k_bus bus,
+				  enum ath10k_hw_rev hw_rev,
 				  const struct ath10k_hif_ops *hif_ops);
 void ath10k_core_destroy(struct ath10k *ar);
 
diff --git a/drivers/net/wireless/ath/ath10k/hw.c b/drivers/net/wireless/ath/ath10k/hw.c
new file mode 100644
index 0000000..d442004
--- /dev/null
+++ b/drivers/net/wireless/ath/ath10k/hw.c
@@ -0,0 +1,59 @@
+/*
+ * Copyright (c) 2005-2011 Atheros Communications Inc.
+ * Copyright (c) 2011-2014 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include <linux/types.h>
+#include "hw.h"
+
+const struct ath10k_hw_regs qca988x_regs = {
+	.rtc_state_cold_reset_mask	= 0x00000400,
+	.rtc_soc_base_address		= 0x00004000,
+	.rtc_wmac_base_address		= 0x00005000,
+	.soc_core_base_address		= 0x00009000,
+	.ce_wrapper_base_address	= 0x00057000,
+	.ce0_base_address		= 0x00057400,
+	.ce1_base_address		= 0x00057800,
+	.ce2_base_address		= 0x00057c00,
+	.ce3_base_address		= 0x00058000,
+	.ce4_base_address		= 0x00058400,
+	.ce5_base_address		= 0x00058800,
+	.ce6_base_address		= 0x00058c00,
+	.ce7_base_address		= 0x00059000,
+	.soc_reset_control_si0_rst_mask	= 0x00000001,
+	.soc_reset_control_ce_rst_mask	= 0x00040000,
+	.soc_chip_id_address		= 0x00ec,
+	.scratch_3_address		= 0x0030,
+};
+
+const struct ath10k_hw_regs qca6174_regs = {
+	.rtc_state_cold_reset_mask		= 0x00002000,
+	.rtc_soc_base_address			= 0x00000800,
+	.rtc_wmac_base_address			= 0x00001000,
+	.soc_core_base_address			= 0x0003a000,
+	.ce_wrapper_base_address		= 0x00034000,
+	.ce0_base_address			= 0x00034400,
+	.ce1_base_address			= 0x00034800,
+	.ce2_base_address			= 0x00034c00,
+	.ce3_base_address			= 0x00035000,
+	.ce4_base_address			= 0x00035400,
+	.ce5_base_address			= 0x00035800,
+	.ce6_base_address			= 0x00035c00,
+	.ce7_base_address			= 0x00036000,
+	.soc_reset_control_si0_rst_mask		= 0x00000000,
+	.soc_reset_control_ce_rst_mask		= 0x00000001,
+	.soc_chip_id_address			= 0x000f0,
+	.scratch_3_address			= 0x0028,
+};
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 7b771ae..5771278 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -34,6 +34,43 @@
 #define QCA988X_HW_2_0_BOARD_DATA_FILE	"board.bin"
 #define QCA988X_HW_2_0_PATCH_LOAD_ADDR	0x1234
 
+/* QCA6174 target BMI version signatures */
+#define QCA6174_HW_1_0_VERSION		0x05000000
+#define QCA6174_HW_1_1_VERSION		0x05000001
+#define QCA6174_HW_1_3_VERSION		0x05000003
+#define QCA6174_HW_2_1_VERSION		0x05010000
+#define QCA6174_HW_3_0_VERSION		0x05020000
+
+enum qca6174_pci_rev {
+	QCA6174_PCI_REV_1_1 = 0x11,
+	QCA6174_PCI_REV_1_3 = 0x13,
+	QCA6174_PCI_REV_2_0 = 0x20,
+	QCA6174_PCI_REV_3_0 = 0x30,
+};
+
+enum qca6174_chip_id_rev {
+	QCA6174_HW_1_0_CHIP_ID_REV = 0,
+	QCA6174_HW_1_1_CHIP_ID_REV = 1,
+	QCA6174_HW_1_3_CHIP_ID_REV = 2,
+	QCA6174_HW_2_1_CHIP_ID_REV = 4,
+	QCA6174_HW_2_2_CHIP_ID_REV = 5,
+	QCA6174_HW_3_0_CHIP_ID_REV = 8,
+	QCA6174_HW_3_1_CHIP_ID_REV = 9,
+	QCA6174_HW_3_2_CHIP_ID_REV = 10,
+};
+
+#define QCA6174_HW_2_1_FW_DIR		"ath10k/QCA6174/hw2.1"
+#define QCA6174_HW_2_1_FW_FILE		"firmware.bin"
+#define QCA6174_HW_2_1_OTP_FILE		"otp.bin"
+#define QCA6174_HW_2_1_BOARD_DATA_FILE	"board.bin"
+#define QCA6174_HW_2_1_PATCH_LOAD_ADDR	0x1234
+
+#define QCA6174_HW_3_0_FW_DIR		"ath10k/QCA6174/hw3.0"
+#define QCA6174_HW_3_0_FW_FILE		"firmware.bin"
+#define QCA6174_HW_3_0_OTP_FILE		"otp.bin"
+#define QCA6174_HW_3_0_BOARD_DATA_FILE	"board.bin"
+#define QCA6174_HW_3_0_PATCH_LOAD_ADDR	0x1234
+
 #define ATH10K_FW_API2_FILE		"firmware-2.bin"
 #define ATH10K_FW_API3_FILE		"firmware-3.bin"
 
@@ -81,6 +118,37 @@ enum ath10k_fw_wmi_op_version {
 	ATH10K_FW_WMI_OP_VERSION_MAX,
 };
 
+enum ath10k_hw_rev {
+	ATH10K_HW_QCA988X,
+	ATH10K_HW_QCA6174,
+};
+
+struct ath10k_hw_regs {
+	u32 rtc_state_cold_reset_mask;
+	u32 rtc_soc_base_address;
+	u32 rtc_wmac_base_address;
+	u32 soc_core_base_address;
+	u32 ce_wrapper_base_address;
+	u32 ce0_base_address;
+	u32 ce1_base_address;
+	u32 ce2_base_address;
+	u32 ce3_base_address;
+	u32 ce4_base_address;
+	u32 ce5_base_address;
+	u32 ce6_base_address;
+	u32 ce7_base_address;
+	u32 soc_reset_control_si0_rst_mask;
+	u32 soc_reset_control_ce_rst_mask;
+	u32 soc_chip_id_address;
+	u32 scratch_3_address;
+};
+
+extern const struct ath10k_hw_regs qca988x_regs;
+extern const struct ath10k_hw_regs qca6174_regs;
+
+#define QCA_REV_988X(ar) ((ar)->hw_rev == ATH10K_HW_QCA988X)
+#define QCA_REV_6174(ar) ((ar)->hw_rev == ATH10K_HW_QCA6174)
+
 /* Known pecularities:
  *  - current FW doesn't support raw rx mode (last tested v599)
  *  - current FW dumps upon raw tx mode (last tested v599)
@@ -225,7 +293,7 @@ struct ath10k_pktlog_hdr {
 /* as of IP3.7.1 */
 #define RTC_STATE_V_ON				3
 
-#define RTC_STATE_COLD_RESET_MASK		0x00000400
+#define RTC_STATE_COLD_RESET_MASK		ar->regs->rtc_state_cold_reset_mask
 #define RTC_STATE_V_LSB				0
 #define RTC_STATE_V_MASK			0x00000007
 #define RTC_STATE_ADDRESS			0x0000
@@ -234,12 +302,12 @@ struct ath10k_pktlog_hdr {
 #define PCIE_SOC_WAKE_RESET			0x00000000
 #define SOC_GLOBAL_RESET_ADDRESS		0x0008
 
-#define RTC_SOC_BASE_ADDRESS			0x00004000
-#define RTC_WMAC_BASE_ADDRESS			0x00005000
+#define RTC_SOC_BASE_ADDRESS			ar->regs->rtc_soc_base_address
+#define RTC_WMAC_BASE_ADDRESS			ar->regs->rtc_wmac_base_address
 #define MAC_COEX_BASE_ADDRESS			0x00006000
 #define BT_COEX_BASE_ADDRESS			0x00007000
 #define SOC_PCIE_BASE_ADDRESS			0x00008000
-#define SOC_CORE_BASE_ADDRESS			0x00009000
+#define SOC_CORE_BASE_ADDRESS			ar->regs->soc_core_base_address
 #define WLAN_UART_BASE_ADDRESS			0x0000c000
 #define WLAN_SI_BASE_ADDRESS			0x00010000
 #define WLAN_GPIO_BASE_ADDRESS			0x00014000
@@ -248,23 +316,23 @@ struct ath10k_pktlog_hdr {
 #define EFUSE_BASE_ADDRESS			0x00030000
 #define FPGA_REG_BASE_ADDRESS			0x00039000
 #define WLAN_UART2_BASE_ADDRESS			0x00054c00
-#define CE_WRAPPER_BASE_ADDRESS			0x00057000
-#define CE0_BASE_ADDRESS			0x00057400
-#define CE1_BASE_ADDRESS			0x00057800
-#define CE2_BASE_ADDRESS			0x00057c00
-#define CE3_BASE_ADDRESS			0x00058000
-#define CE4_BASE_ADDRESS			0x00058400
-#define CE5_BASE_ADDRESS			0x00058800
-#define CE6_BASE_ADDRESS			0x00058c00
-#define CE7_BASE_ADDRESS			0x00059000
+#define CE_WRAPPER_BASE_ADDRESS			ar->regs->ce_wrapper_base_address
+#define CE0_BASE_ADDRESS			ar->regs->ce0_base_address
+#define CE1_BASE_ADDRESS			ar->regs->ce1_base_address
+#define CE2_BASE_ADDRESS			ar->regs->ce2_base_address
+#define CE3_BASE_ADDRESS			ar->regs->ce3_base_address
+#define CE4_BASE_ADDRESS			ar->regs->ce4_base_address
+#define CE5_BASE_ADDRESS			ar->regs->ce5_base_address
+#define CE6_BASE_ADDRESS			ar->regs->ce6_base_address
+#define CE7_BASE_ADDRESS			ar->regs->ce7_base_address
 #define DBI_BASE_ADDRESS			0x00060000
 #define WLAN_ANALOG_INTF_PCIE_BASE_ADDRESS	0x0006c000
 #define PCIE_LOCAL_BASE_ADDRESS			0x00080000
 
 #define SOC_RESET_CONTROL_ADDRESS		0x00000000
 #define SOC_RESET_CONTROL_OFFSET		0x00000000
-#define SOC_RESET_CONTROL_SI0_RST_MASK		0x00000001
-#define SOC_RESET_CONTROL_CE_RST_MASK		0x00040000
+#define SOC_RESET_CONTROL_SI0_RST_MASK		ar->regs->soc_reset_control_si0_rst_mask
+#define SOC_RESET_CONTROL_CE_RST_MASK		ar->regs->soc_reset_control_ce_rst_mask
 #define SOC_RESET_CONTROL_CPU_WARM_RST_MASK	0x00000040
 #define SOC_CPU_CLOCK_OFFSET			0x00000020
 #define SOC_CPU_CLOCK_STANDARD_LSB		0
@@ -278,7 +346,7 @@ struct ath10k_pktlog_hdr {
 #define SOC_LF_TIMER_CONTROL0_ADDRESS		0x00000050
 #define SOC_LF_TIMER_CONTROL0_ENABLE_MASK	0x00000004
 
-#define SOC_CHIP_ID_ADDRESS			0x000000ec
+#define SOC_CHIP_ID_ADDRESS			ar->regs->soc_chip_id_address
 #define SOC_CHIP_ID_REV_LSB			8
 #define SOC_CHIP_ID_REV_MASK			0x00000f00
 
@@ -334,7 +402,7 @@ struct ath10k_pktlog_hdr {
 #define PCIE_INTR_ENABLE_ADDRESS		0x0008
 #define PCIE_INTR_CAUSE_ADDRESS			0x000c
 #define PCIE_INTR_CLR_ADDRESS			0x0014
-#define SCRATCH_3_ADDRESS			0x0030
+#define SCRATCH_3_ADDRESS			ar->regs->scratch_3_address
 #define CPU_INTR_ADDRESS			0x0010
 
 /* Firmware indications to the Host via SCRATCH_3 register. */
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 6a512fb..2fe67e3 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -58,9 +58,11 @@ MODULE_PARM_DESC(reset_mode, "0: auto, 1: warm only (default: 0)");
 #define ATH10K_PCI_NUM_WARM_RESET_ATTEMPTS 3
 
 #define QCA988X_2_0_DEVICE_ID	(0x003c)
+#define QCA6174_2_1_DEVICE_ID	(0x003e)
 
 static const struct pci_device_id ath10k_pci_id_table[] = {
 	{ PCI_VDEVICE(ATHEROS, QCA988X_2_0_DEVICE_ID) }, /* PCI-E QCA988X V2 */
+	{ PCI_VDEVICE(ATHEROS, QCA6174_2_1_DEVICE_ID) }, /* PCI-E QCA6174 V2.1 */
 	{0}
 };
 
@@ -70,6 +72,11 @@ static const struct ath10k_pci_supp_chip ath10k_pci_supp_chips[] = {
 	 * because of that.
 	 */
 	{ QCA988X_2_0_DEVICE_ID, QCA988X_HW_2_0_CHIP_ID_REV },
+	{ QCA6174_2_1_DEVICE_ID, QCA6174_HW_2_1_CHIP_ID_REV },
+	{ QCA6174_2_1_DEVICE_ID, QCA6174_HW_2_2_CHIP_ID_REV },
+	{ QCA6174_2_1_DEVICE_ID, QCA6174_HW_3_0_CHIP_ID_REV },
+	{ QCA6174_2_1_DEVICE_ID, QCA6174_HW_3_1_CHIP_ID_REV },
+	{ QCA6174_2_1_DEVICE_ID, QCA6174_HW_3_2_CHIP_ID_REV },
 };
 
 static void ath10k_pci_buffer_cleanup(struct ath10k *ar);
@@ -1506,6 +1513,35 @@ static int ath10k_pci_wake_target_cpu(struct ath10k *ar)
 	return 0;
 }
 
+static int ath10k_pci_get_num_banks(struct ath10k *ar)
+{
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+
+	switch (ar_pci->pdev->device) {
+	case QCA988X_2_0_DEVICE_ID:
+		return 1;
+	case QCA6174_2_1_DEVICE_ID:
+		switch (MS(ar->chip_id, SOC_CHIP_ID_REV)) {
+		case QCA6174_HW_1_0_CHIP_ID_REV:
+		case QCA6174_HW_1_1_CHIP_ID_REV:
+			return 3;
+		case QCA6174_HW_1_3_CHIP_ID_REV:
+			return 2;
+		case QCA6174_HW_2_1_CHIP_ID_REV:
+		case QCA6174_HW_2_2_CHIP_ID_REV:
+			return 6;
+		case QCA6174_HW_3_0_CHIP_ID_REV:
+		case QCA6174_HW_3_1_CHIP_ID_REV:
+		case QCA6174_HW_3_2_CHIP_ID_REV:
+			return 9;
+		}
+		break;
+	}
+
+	ath10k_warn(ar, "unknown number of banks, assuming 1\n");
+	return 1;
+}
+
 static int ath10k_pci_init_config(struct ath10k *ar)
 {
 	u32 interconnect_targ_addr;
@@ -1616,7 +1652,8 @@ static int ath10k_pci_init_config(struct ath10k *ar)
 	/* first bank is switched to IRAM */
 	ealloc_value |= ((HI_EARLY_ALLOC_MAGIC << HI_EARLY_ALLOC_MAGIC_SHIFT) &
 			 HI_EARLY_ALLOC_MAGIC_MASK);
-	ealloc_value |= ((1 << HI_EARLY_ALLOC_IRAM_BANKS_SHIFT) &
+	ealloc_value |= ((ath10k_pci_get_num_banks(ar) <<
+			  HI_EARLY_ALLOC_IRAM_BANKS_SHIFT) &
 			 HI_EARLY_ALLOC_IRAM_BANKS_MASK);
 
 	ret = ath10k_pci_diag_write32(ar, ealloc_targ_addr, ealloc_value);
@@ -1812,12 +1849,12 @@ static int ath10k_pci_warm_reset(struct ath10k *ar)
 	return 0;
 }
 
-static int ath10k_pci_chip_reset(struct ath10k *ar)
+static int ath10k_pci_qca988x_chip_reset(struct ath10k *ar)
 {
 	int i, ret;
 	u32 val;
 
-	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot chip reset\n");
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot 988x chip reset\n");
 
 	/* Some hardware revisions (e.g. CUS223v2) has issues with cold reset.
 	 * It is thus preferred to use warm reset which is safer but may not be
@@ -1881,11 +1918,53 @@ static int ath10k_pci_chip_reset(struct ath10k *ar)
 		return ret;
 	}
 
-	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot chip reset complete (cold)\n");
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot qca988x chip reset complete (cold)\n");
+
+	return 0;
+}
+
+static int ath10k_pci_qca6174_chip_reset(struct ath10k *ar)
+{
+	int ret;
+
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot qca6174 chip reset\n");
+
+	/* FIXME: QCA6174 requires cold + warm reset to work. */
+
+	ret = ath10k_pci_cold_reset(ar);
+	if (ret) {
+		ath10k_warn(ar, "failed to cold reset: %d\n", ret);
+		return ret;
+	}
+
+	ret = ath10k_pci_wait_for_target_init(ar);
+	if (ret) {
+		ath10k_warn(ar, "failed to wait for target after cold reset: %d\n",
+				ret);
+		return ret;
+	}
+
+	ret = ath10k_pci_warm_reset(ar);
+	if (ret) {
+		ath10k_warn(ar, "failed to warm reset: %d\n", ret);
+		return ret;
+	}
+
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot qca6174 chip reset complete (cold)\n");
 
 	return 0;
 }
 
+static int ath10k_pci_chip_reset(struct ath10k *ar)
+{
+	if (QCA_REV_988X(ar))
+		return ath10k_pci_qca988x_chip_reset(ar);
+	else if (QCA_REV_6174(ar))
+		return ath10k_pci_qca6174_chip_reset(ar);
+	else
+		return -ENOTSUPP;
+}
+
 static int ath10k_pci_hif_power_up(struct ath10k *ar)
 {
 	int ret;
@@ -2511,11 +2590,23 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 	int ret = 0;
 	struct ath10k *ar;
 	struct ath10k_pci *ar_pci;
+	enum ath10k_hw_rev hw_rev;
 	u32 chip_id;
 
-	ar = ath10k_core_create(sizeof(*ar_pci), &pdev->dev,
-				ATH10K_BUS_PCI,
-				&ath10k_pci_hif_ops);
+	switch (pci_dev->device) {
+	case QCA988X_2_0_DEVICE_ID:
+		hw_rev = ATH10K_HW_QCA988X;
+		break;
+	case QCA6174_2_1_DEVICE_ID:
+		hw_rev = ATH10K_HW_QCA6174;
+		break;
+	default:
+		WARN_ON(1);
+		return -ENOTSUPP;
+	}
+
+	ar = ath10k_core_create(sizeof(*ar_pci), &pdev->dev, ATH10K_BUS_PCI,
+				hw_rev, &ath10k_pci_hif_ops);
 	if (!ar) {
 		dev_err(&pdev->dev, "failed to allocate core\n");
 		return -ENOMEM;
diff --git a/drivers/net/wireless/ath/ath10k/targaddrs.h b/drivers/net/wireless/ath/ath10k/targaddrs.h
index 9d0ae30..a417aae 100644
--- a/drivers/net/wireless/ath/ath10k/targaddrs.h
+++ b/drivers/net/wireless/ath/ath10k/targaddrs.h
@@ -18,6 +18,8 @@
 #ifndef __TARGADDRS_H__
 #define __TARGADDRS_H__
 
+#include "hw.h"
+
 /*
  * xxx_HOST_INTEREST_ADDRESS is the address in Target RAM of the
  * host_interest structure.  It must match the address of the _host_interest
@@ -445,4 +447,7 @@ Fw Mode/SubMode Mask
 #define QCA988X_BOARD_DATA_SZ     7168
 #define QCA988X_BOARD_EXT_DATA_SZ 0
 
+#define QCA6174_BOARD_DATA_SZ     8192
+#define QCA6174_BOARD_EXT_DATA_SZ 0
+
 #endif /* __TARGADDRS_H__ */
-- 
1.8.5.3

