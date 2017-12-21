Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:37110 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751318AbdLUJBu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Dec 2017 04:01:50 -0500
From: Govind Singh <govinds@qti.qualcomm.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@qti.qualcomm.com>,
        Govind Singh <govinds@qti.qualcomm.com>
Subject: [PATCH 01/10] ath10k: Add hw param for 64-bit address support
Date: Thu, 21 Dec 2017 14:30:50 +0530
Message-Id: <1513846859-23639-2-git-send-email-govinds@qti.qualcomm.com> (sfid-20171221_100201_954583_9E6CD7E9)
In-Reply-To: <1513846859-23639-1-git-send-email-govinds@qti.qualcomm.com>
References: <1513846859-23639-1-git-send-email-govinds@qti.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rakesh Pillai <pillair@qti.qualcomm.com>

WCN3990 target supports 37-bit addressing mode. In order
to accommodate extended address support, add hw param to
indicate if the target supports addressing above 32-bits.

Signed-off-by: Rakesh Pillai <pillair@qti.qualcomm.com>
Signed-off-by: Govind Singh <govinds@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 13 +++++++++++++
 drivers/net/wireless/ath/ath10k/hw.h   |  3 +++
 2 files changed, 16 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index ad61e64..031fe00 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -78,6 +78,7 @@
 		.num_peers = TARGET_TLV_NUM_PEERS,
 		.ast_skid_limit = 0x10,
 		.num_wds_entries = 0x20,
+		.target_64bit = false,
 	},
 	{
 		.id = QCA9887_HW_1_0_VERSION,
@@ -105,6 +106,7 @@
 		.num_peers = TARGET_TLV_NUM_PEERS,
 		.ast_skid_limit = 0x10,
 		.num_wds_entries = 0x20,
+		.target_64bit = false,
 	},
 	{
 		.id = QCA6174_HW_2_1_VERSION,
@@ -131,6 +133,7 @@
 		.num_peers = TARGET_TLV_NUM_PEERS,
 		.ast_skid_limit = 0x10,
 		.num_wds_entries = 0x20,
+		.target_64bit = false,
 	},
 	{
 		.id = QCA6174_HW_2_1_VERSION,
@@ -157,6 +160,7 @@
 		.num_peers = TARGET_TLV_NUM_PEERS,
 		.ast_skid_limit = 0x10,
 		.num_wds_entries = 0x20,
+		.target_64bit = false,
 	},
 	{
 		.id = QCA6174_HW_3_0_VERSION,
@@ -183,6 +187,7 @@
 		.num_peers = TARGET_TLV_NUM_PEERS,
 		.ast_skid_limit = 0x10,
 		.num_wds_entries = 0x20,
+		.target_64bit = false,
 	},
 	{
 		.id = QCA6174_HW_3_2_VERSION,
@@ -212,6 +217,7 @@
 		.num_peers = TARGET_TLV_NUM_PEERS,
 		.ast_skid_limit = 0x10,
 		.num_wds_entries = 0x20,
+		.target_64bit = false,
 	},
 	{
 		.id = QCA99X0_HW_2_0_DEV_VERSION,
@@ -244,6 +250,7 @@
 		.num_peers = TARGET_TLV_NUM_PEERS,
 		.ast_skid_limit = 0x10,
 		.num_wds_entries = 0x20,
+		.target_64bit = false,
 	},
 	{
 		.id = QCA9984_HW_1_0_DEV_VERSION,
@@ -281,6 +288,7 @@
 		.num_peers = TARGET_TLV_NUM_PEERS,
 		.ast_skid_limit = 0x10,
 		.num_wds_entries = 0x20,
+		.target_64bit = false,
 	},
 	{
 		.id = QCA9888_HW_2_0_DEV_VERSION,
@@ -317,6 +325,7 @@
 		.num_peers = TARGET_TLV_NUM_PEERS,
 		.ast_skid_limit = 0x10,
 		.num_wds_entries = 0x20,
+		.target_64bit = false,
 	},
 	{
 		.id = QCA9377_HW_1_0_DEV_VERSION,
@@ -343,6 +352,7 @@
 		.num_peers = TARGET_TLV_NUM_PEERS,
 		.ast_skid_limit = 0x10,
 		.num_wds_entries = 0x20,
+		.target_64bit = false,
 	},
 	{
 		.id = QCA9377_HW_1_1_DEV_VERSION,
@@ -371,6 +381,7 @@
 		.num_peers = TARGET_TLV_NUM_PEERS,
 		.ast_skid_limit = 0x10,
 		.num_wds_entries = 0x20,
+		.target_64bit = false,
 	},
 	{
 		.id = QCA4019_HW_1_0_DEV_VERSION,
@@ -404,6 +415,7 @@
 		.num_peers = TARGET_TLV_NUM_PEERS,
 		.ast_skid_limit = 0x10,
 		.num_wds_entries = 0x20,
+		.target_64bit = false,
 	},
 	{
 		.id = WCN3990_HW_1_0_DEV_VERSION,
@@ -422,6 +434,7 @@
 		.num_peers = TARGET_HL_10_TLV_NUM_PEERS,
 		.ast_skid_limit = TARGET_HL_10_TLV_AST_SKID_LIMIT,
 		.num_wds_entries = TARGET_HL_10_TLV_NUM_WDS_ENTRIES,
+		.target_64bit = true,
 	},
 };
 
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 90ad39b..5d243f3 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -561,6 +561,9 @@ struct ath10k_hw_params {
 	u32 num_peers;
 	u32 ast_skid_limit;
 	u32 num_wds_entries;
+
+	/* Targets supporting physical addressing capability above 32-bits */
+	bool target_64bit;
 };
 
 struct htt_rx_desc;
-- 
1.9.1
