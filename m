Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:34726 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751658AbeAYLO0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Jan 2018 06:14:26 -0500
From: Tobias Schramm <tobleminer@gmail.com>
To: kvalo@qca.qualcomm.com, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, bhelgaas@google.com,
        linux-pci@vger.kernel.org
Cc: Tobias Schramm <tobleminer@gmail.com>
Subject: [PATCH v3 2/2] ath10k: Add support for Ubiquiti rebranded QCA988X v2
Date: Thu, 25 Jan 2018 12:13:40 +0100
Message-Id: <20180125111340.17553-3-tobleminer@gmail.com> (sfid-20180125_121434_411991_5A407505)
In-Reply-To: <20180125111340.17553-1-tobleminer@gmail.com>
References: <20180125111340.17553-1-tobleminer@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some modern Ubiquiti devices contain a rebranded QCA988X rev2 with
a custom Ubiquiti vendor and device id. This patch adds support for
those devices, treating them as a QCA988X v2.

Signed-off-by: Tobias Schramm <tobleminer@gmail.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 24 ++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/hw.h   |  1 +
 drivers/net/wireless/ath/ath10k/pci.c  |  4 ++++
 3 files changed, 29 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index b29fdbd21ead..9fb38f2c1d6e 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -52,6 +52,30 @@ MODULE_PARM_DESC(cryptmode, "Crypto mode: 0-hardware, 1-software");
 MODULE_PARM_DESC(rawmode, "Use raw 802.11 frame datapath");
 
 static const struct ath10k_hw_params ath10k_hw_params_list[] = {
+	{
+		.id = QCA988X_HW_2_0_VERSION,
+		.dev_id = QCA988X_2_0_DEVICE_ID_UBNT,
+		.name = "qca988x hw2.0",
+		.patch_load_addr = QCA988X_HW_2_0_PATCH_LOAD_ADDR,
+		.uart_pin = 7,
+		.cc_wraparound_type = ATH10K_HW_CC_WRAP_SHIFTED_ALL,
+		.otp_exe_param = 0,
+		.channel_counters_freq_hz = 88000,
+		.max_probe_resp_desc_thres = 0,
+		.cal_data_len = 2116,
+		.fw = {
+			.dir = QCA988X_HW_2_0_FW_DIR,
+			.board = QCA988X_HW_2_0_BOARD_DATA_FILE,
+			.board_size = QCA988X_BOARD_DATA_SZ,
+			.board_ext_size = QCA988X_BOARD_EXT_DATA_SZ,
+		},
+		.hw_ops = &qca988x_ops,
+		.decap_align_bytes = 4,
+		.spectral_bin_discard = 0,
+		.vht160_mcs_rx_highest = 0,
+		.vht160_mcs_tx_highest = 0,
+		.n_cipher_suites = 8,
+	},
 	{
 		.id = QCA988X_HW_2_0_VERSION,
 		.dev_id = QCA988X_2_0_DEVICE_ID,
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 05f26e5858ad..5ae3b56acc19 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -22,6 +22,7 @@
 
 #define ATH10K_FW_DIR			"ath10k"
 
+#define QCA988X_2_0_DEVICE_ID_UBNT   (0x11ac)
 #define QCA988X_2_0_DEVICE_ID   (0x003c)
 #define QCA6164_2_1_DEVICE_ID   (0x0041)
 #define QCA6174_2_1_DEVICE_ID   (0x003e)
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index ffea348b2190..e28e2f5f09c5 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -52,6 +52,7 @@ MODULE_PARM_DESC(reset_mode, "0: auto, 1: warm only (default: 0)");
 #define ATH10K_PCI_NUM_WARM_RESET_ATTEMPTS 3
 
 static const struct pci_device_id ath10k_pci_id_table[] = {
+	{ PCI_VDEVICE(UBIQUITI, QCA988X_2_0_DEVICE_ID_UBNT) }, /* PCI-E QCA988X V2 (Ubiquiti branded) */
 	{ PCI_VDEVICE(ATHEROS, QCA988X_2_0_DEVICE_ID) }, /* PCI-E QCA988X V2 */
 	{ PCI_VDEVICE(ATHEROS, QCA6164_2_1_DEVICE_ID) }, /* PCI-E QCA6164 V2.1 */
 	{ PCI_VDEVICE(ATHEROS, QCA6174_2_1_DEVICE_ID) }, /* PCI-E QCA6174 V2.1 */
@@ -68,6 +69,7 @@ static const struct ath10k_pci_supp_chip ath10k_pci_supp_chips[] = {
 	 * hacks. ath10k doesn't have them and these devices crash horribly
 	 * because of that.
 	 */
+	{ QCA988X_2_0_DEVICE_ID_UBNT, QCA988X_HW_2_0_CHIP_ID_REV },
 	{ QCA988X_2_0_DEVICE_ID, QCA988X_HW_2_0_CHIP_ID_REV },
 
 	{ QCA6164_2_1_DEVICE_ID, QCA6174_HW_2_1_CHIP_ID_REV },
@@ -1977,6 +1979,7 @@ static int ath10k_pci_get_num_banks(struct ath10k *ar)
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 
 	switch (ar_pci->pdev->device) {
+	case QCA988X_2_0_DEVICE_ID_UBNT:
 	case QCA988X_2_0_DEVICE_ID:
 	case QCA99X0_2_0_DEVICE_ID:
 	case QCA9888_2_0_DEVICE_ID:
@@ -3208,6 +3211,7 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 	u32 (*targ_cpu_to_ce_addr)(struct ath10k *ar, u32 addr);
 
 	switch (pci_dev->device) {
+	case QCA988X_2_0_DEVICE_ID_UBNT:
 	case QCA988X_2_0_DEVICE_ID:
 		hw_rev = ATH10K_HW_QCA988X;
 		pci_ps = false;
-- 
2.16.0
