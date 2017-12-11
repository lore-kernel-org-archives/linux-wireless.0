Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:64306 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751678AbdLKOX0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Dec 2017 09:23:26 -0500
From: Rakesh Pillai <pillair@qti.qualcomm.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@qti.qualcomm.com>,
        Govind Singh <govinds@qti.qualcomm.com>
Subject: [PATCH v3 4/4] ath10k: WMI: add hw params entry for wcn3990
Date: Mon, 11 Dec 2017 19:52:55 +0530
Message-Id: <1513002175-2498-5-git-send-email-pillair@qti.qualcomm.com> (sfid-20171211_152337_432428_956E6F9D)
In-Reply-To: <1513002175-2498-1-git-send-email-pillair@qti.qualcomm.com>
References: <1513002175-2498-1-git-send-email-pillair@qti.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add hw params entry for wcn3990 and populate various
target specific values for wcn3990.

Signed-off-by: Rakesh Pillai <pillair@qti.qualcomm.com>
Signed-off-by: Govind Singh <govinds@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 18 ++++++++++++++++++
 drivers/net/wireless/ath/ath10k/hw.c   |  2 ++
 drivers/net/wireless/ath/ath10k/hw.h   | 10 ++++++++++
 3 files changed, 30 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index be189132623d..6abffb530027 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -405,6 +405,24 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.ast_skid_limit = 0x10,
 		.num_wds_entries = 0x20,
 	},
+	{
+		.id = WCN3990_HW_1_0_DEV_VERSION,
+		.dev_id = 0,
+		.name = "wcn3990 hw1.0",
+		.continuous_frag_desc = true,
+		.tx_chain_mask = 0x7,
+		.rx_chain_mask = 0x7,
+		.max_spatial_stream = 4,
+		.fw = {
+			.dir = WCN3990_HW_1_0_FW_DIR,
+		},
+		.sw_decrypt_mcast_mgmt = true,
+		.hw_ops = &wcn3990_ops,
+		.decap_align_bytes = 1,
+		.num_peers = TARGET_HL_10_TLV_NUM_PEERS,
+		.ast_skid_limit = TARGET_HL_10_TLV_AST_SKID_LIMIT,
+		.num_wds_entries = TARGET_HL_10_TLV_NUM_WDS_ENTRIES,
+	},
 };
 
 static const char *const ath10k_core_fw_feature_str[] = {
diff --git a/drivers/net/wireless/ath/ath10k/hw.c b/drivers/net/wireless/ath/ath10k/hw.c
index 88955bbe20bd..c31eea632777 100644
--- a/drivers/net/wireless/ath/ath10k/hw.c
+++ b/drivers/net/wireless/ath/ath10k/hw.c
@@ -931,3 +931,5 @@ const struct ath10k_hw_ops qca6174_ops = {
 	.set_coverage_class = ath10k_hw_qca988x_set_coverage_class,
 	.enable_pll_clk = ath10k_hw_qca6174_enable_pll_clock,
 };
+
+const struct ath10k_hw_ops wcn3990_ops = {};
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index fedb6c799374..90ad39bdeec4 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -128,6 +128,10 @@ enum qca9377_chip_id_rev {
 #define QCA4019_HW_1_0_BOARD_DATA_FILE "board.bin"
 #define QCA4019_HW_1_0_PATCH_LOAD_ADDR  0x1234
 
+/* WCN3990 1.0 definitions */
+#define WCN3990_HW_1_0_DEV_VERSION	ATH10K_HW_WCN3990
+#define WCN3990_HW_1_0_FW_DIR		ATH10K_FW_DIR "/WCN3990/hw3.0"
+
 #define ATH10K_FW_FILE_BASE		"firmware"
 #define ATH10K_FW_API_MAX		6
 #define ATH10K_FW_API_MIN		2
@@ -571,6 +575,7 @@ struct ath10k_hw_ops {
 extern const struct ath10k_hw_ops qca988x_ops;
 extern const struct ath10k_hw_ops qca99x0_ops;
 extern const struct ath10k_hw_ops qca6174_ops;
+extern const struct ath10k_hw_ops wcn3990_ops;
 
 extern const struct ath10k_hw_clk_params qca6174_clk[];
 
@@ -667,6 +672,11 @@ ath10k_rx_desc_get_l3_pad_bytes(struct ath10k_hw_params *hw,
 #define TARGET_TLV_NUM_MSDU_DESC		(1024 + 32)
 #define TARGET_TLV_NUM_WOW_PATTERNS		22
 
+/* Target specific defines for WMI-HL-1.0 firmware */
+#define TARGET_HL_10_TLV_NUM_PEERS		14
+#define TARGET_HL_10_TLV_AST_SKID_LIMIT		6
+#define TARGET_HL_10_TLV_NUM_WDS_ENTRIES	2
+
 /* Diagnostic Window */
 #define CE_DIAG_PIPE	7
 
-- 
2.11.0
