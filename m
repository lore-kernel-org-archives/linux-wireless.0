Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:4293 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751406AbdLUJBw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Dec 2017 04:01:52 -0500
From: Govind Singh <govinds@qti.qualcomm.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Govind Singh <govinds@qti.qualcomm.com>
Subject: [PATCH 07/10] ath10k: Add hw param for rx ring size support
Date: Thu, 21 Dec 2017 14:30:56 +0530
Message-Id: <1513846859-23639-8-git-send-email-govinds@qti.qualcomm.com> (sfid-20171221_100203_058962_6A82096F)
In-Reply-To: <1513846859-23639-1-git-send-email-govinds@qti.qualcomm.com>
References: <1513846859-23639-1-git-send-email-govinds@qti.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

WCN3990 uses larger ring size in comparison to existing
ring size value.
Add rx ring size hw param for supporting different rx ring
size across multiple target.

Signed-off-by: Govind Singh <govinds@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c   | 13 +++++++++++++
 drivers/net/wireless/ath/ath10k/htt.h    |  3 +++
 drivers/net/wireless/ath/ath10k/htt_rx.c |  5 +----
 drivers/net/wireless/ath/ath10k/hw.h     |  3 +++
 4 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 031fe00..8374b05 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -79,6 +79,7 @@
 		.ast_skid_limit = 0x10,
 		.num_wds_entries = 0x20,
 		.target_64bit = false,
+		.rx_ring_fill_level = HTT_RX_RING_FILL_LEVEL,
 	},
 	{
 		.id = QCA9887_HW_1_0_VERSION,
@@ -107,6 +108,7 @@
 		.ast_skid_limit = 0x10,
 		.num_wds_entries = 0x20,
 		.target_64bit = false,
+		.rx_ring_fill_level = HTT_RX_RING_FILL_LEVEL,
 	},
 	{
 		.id = QCA6174_HW_2_1_VERSION,
@@ -134,6 +136,7 @@
 		.ast_skid_limit = 0x10,
 		.num_wds_entries = 0x20,
 		.target_64bit = false,
+		.rx_ring_fill_level = HTT_RX_RING_FILL_LEVEL,
 	},
 	{
 		.id = QCA6174_HW_2_1_VERSION,
@@ -161,6 +164,7 @@
 		.ast_skid_limit = 0x10,
 		.num_wds_entries = 0x20,
 		.target_64bit = false,
+		.rx_ring_fill_level = HTT_RX_RING_FILL_LEVEL,
 	},
 	{
 		.id = QCA6174_HW_3_0_VERSION,
@@ -188,6 +192,7 @@
 		.ast_skid_limit = 0x10,
 		.num_wds_entries = 0x20,
 		.target_64bit = false,
+		.rx_ring_fill_level = HTT_RX_RING_FILL_LEVEL,
 	},
 	{
 		.id = QCA6174_HW_3_2_VERSION,
@@ -218,6 +223,7 @@
 		.ast_skid_limit = 0x10,
 		.num_wds_entries = 0x20,
 		.target_64bit = false,
+		.rx_ring_fill_level = HTT_RX_RING_FILL_LEVEL,
 	},
 	{
 		.id = QCA99X0_HW_2_0_DEV_VERSION,
@@ -251,6 +257,7 @@
 		.ast_skid_limit = 0x10,
 		.num_wds_entries = 0x20,
 		.target_64bit = false,
+		.rx_ring_fill_level = HTT_RX_RING_FILL_LEVEL,
 	},
 	{
 		.id = QCA9984_HW_1_0_DEV_VERSION,
@@ -289,6 +296,7 @@
 		.ast_skid_limit = 0x10,
 		.num_wds_entries = 0x20,
 		.target_64bit = false,
+		.rx_ring_fill_level = HTT_RX_RING_FILL_LEVEL,
 	},
 	{
 		.id = QCA9888_HW_2_0_DEV_VERSION,
@@ -326,6 +334,7 @@
 		.ast_skid_limit = 0x10,
 		.num_wds_entries = 0x20,
 		.target_64bit = false,
+		.rx_ring_fill_level = HTT_RX_RING_FILL_LEVEL,
 	},
 	{
 		.id = QCA9377_HW_1_0_DEV_VERSION,
@@ -353,6 +362,7 @@
 		.ast_skid_limit = 0x10,
 		.num_wds_entries = 0x20,
 		.target_64bit = false,
+		.rx_ring_fill_level = HTT_RX_RING_FILL_LEVEL,
 	},
 	{
 		.id = QCA9377_HW_1_1_DEV_VERSION,
@@ -382,6 +392,7 @@
 		.ast_skid_limit = 0x10,
 		.num_wds_entries = 0x20,
 		.target_64bit = false,
+		.rx_ring_fill_level = HTT_RX_RING_FILL_LEVEL,
 	},
 	{
 		.id = QCA4019_HW_1_0_DEV_VERSION,
@@ -416,6 +427,7 @@
 		.ast_skid_limit = 0x10,
 		.num_wds_entries = 0x20,
 		.target_64bit = false,
+		.rx_ring_fill_level = HTT_RX_RING_FILL_LEVEL,
 	},
 	{
 		.id = WCN3990_HW_1_0_DEV_VERSION,
@@ -435,6 +447,7 @@
 		.ast_skid_limit = TARGET_HL_10_TLV_AST_SKID_LIMIT,
 		.num_wds_entries = TARGET_HL_10_TLV_NUM_WDS_ENTRIES,
 		.target_64bit = true,
+		.rx_ring_fill_level = HTT_RX_RING_FILL_LEVEL_DUAL_MAC,
 	},
 };
 
diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index ac5d720..3a43a48 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -224,6 +224,9 @@ enum htt_rx_ring_flags {
 
 #define HTT_RX_RING_SIZE_MIN 128
 #define HTT_RX_RING_SIZE_MAX 2048
+#define HTT_RX_RING_SIZE HTT_RX_RING_SIZE_MAX
+#define HTT_RX_RING_FILL_LEVEL (((HTT_RX_RING_SIZE) / 2) - 1)
+#define HTT_RX_RING_FILL_LEVEL_DUAL_MAC (HTT_RX_RING_SIZE - 1)
 
 struct htt_rx_ring_setup_ring32 {
 	__le32 fw_idx_shadow_reg_paddr;
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 6402189..6fb6751 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -25,9 +25,6 @@
 
 #include <linux/log2.h>
 
-#define HTT_RX_RING_SIZE HTT_RX_RING_SIZE_MAX
-#define HTT_RX_RING_FILL_LEVEL (((HTT_RX_RING_SIZE) / 2) - 1)
-
 /* when under memory pressure rx ring refill may fail and needs a retry */
 #define HTT_RX_RING_REFILL_RETRY_MS 50
 
@@ -522,7 +519,7 @@ int ath10k_htt_rx_alloc(struct ath10k_htt *htt)
 	 */
 	htt->rx_ring.size = HTT_RX_RING_SIZE;
 	htt->rx_ring.size_mask = htt->rx_ring.size - 1;
-	htt->rx_ring.fill_level = HTT_RX_RING_FILL_LEVEL;
+	htt->rx_ring.fill_level = ar->hw_params.rx_ring_fill_level;
 
 	if (!is_power_of_2(htt->rx_ring.size)) {
 		ath10k_warn(ar, "htt rx ring size is not power of 2\n");
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 5d243f3..84aedaa 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -564,6 +564,9 @@ struct ath10k_hw_params {
 
 	/* Targets supporting physical addressing capability above 32-bits */
 	bool target_64bit;
+
+	/* Target rx ring fill level */
+	u32 rx_ring_fill_level;
 };
 
 struct htt_rx_desc;
-- 
1.9.1
