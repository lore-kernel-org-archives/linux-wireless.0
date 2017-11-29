Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:46041 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754026AbdK2JwS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Nov 2017 04:52:18 -0500
From: Rakesh Pillai <pillair@qti.qualcomm.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@qti.qualcomm.com>,
        Govind Singh <govinds@qti.qualcomm.com>
Subject: [PATCH 3/4] ath10k: WMI: get wmi init parameter values from hw params
Date: Wed, 29 Nov 2017 15:21:36 +0530
Message-Id: <1511949097-524-3-git-send-email-pillair@qti.qualcomm.com> (sfid-20171129_105221_896471_A355BE62)
In-Reply-To: <1511949097-524-1-git-send-email-pillair@qti.qualcomm.com>
References: <1511949097-524-1-git-send-email-pillair@qti.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The parameter values for skid limit, number of peers and wds
entries values which are sent in wmi init cmd are hardware
specific.

Add support to obtain skid limit, number of peers and wds entries
values from hw params which will have the hw specific values
for these parameters.

Signed-off-by: Rakesh Pillai <pillair@qti.qualcomm.com>
Signed-off-by: Govind Singh <govinds@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c    | 36 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/hw.h      |  4 ++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |  7 +++---
 3 files changed, 44 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 1e4e18e..be18913 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -75,6 +75,9 @@
 		.vht160_mcs_rx_highest = 0,
 		.vht160_mcs_tx_highest = 0,
 		.n_cipher_suites = 8,
+		.num_peers = TARGET_TLV_NUM_PEERS,
+		.ast_skid_limit = 0x10,
+		.num_wds_entries = 0x20,
 	},
 	{
 		.id = QCA9887_HW_1_0_VERSION,
@@ -99,6 +102,9 @@
 		.vht160_mcs_rx_highest = 0,
 		.vht160_mcs_tx_highest = 0,
 		.n_cipher_suites = 8,
+		.num_peers = TARGET_TLV_NUM_PEERS,
+		.ast_skid_limit = 0x10,
+		.num_wds_entries = 0x20,
 	},
 	{
 		.id = QCA6174_HW_2_1_VERSION,
@@ -122,6 +128,9 @@
 		.vht160_mcs_rx_highest = 0,
 		.vht160_mcs_tx_highest = 0,
 		.n_cipher_suites = 8,
+		.num_peers = TARGET_TLV_NUM_PEERS,
+		.ast_skid_limit = 0x10,
+		.num_wds_entries = 0x20,
 	},
 	{
 		.id = QCA6174_HW_2_1_VERSION,
@@ -145,6 +154,9 @@
 		.vht160_mcs_rx_highest = 0,
 		.vht160_mcs_tx_highest = 0,
 		.n_cipher_suites = 8,
+		.num_peers = TARGET_TLV_NUM_PEERS,
+		.ast_skid_limit = 0x10,
+		.num_wds_entries = 0x20,
 	},
 	{
 		.id = QCA6174_HW_3_0_VERSION,
@@ -168,6 +180,9 @@
 		.vht160_mcs_rx_highest = 0,
 		.vht160_mcs_tx_highest = 0,
 		.n_cipher_suites = 8,
+		.num_peers = TARGET_TLV_NUM_PEERS,
+		.ast_skid_limit = 0x10,
+		.num_wds_entries = 0x20,
 	},
 	{
 		.id = QCA6174_HW_3_2_VERSION,
@@ -194,6 +209,9 @@
 		.vht160_mcs_rx_highest = 0,
 		.vht160_mcs_tx_highest = 0,
 		.n_cipher_suites = 8,
+		.num_peers = TARGET_TLV_NUM_PEERS,
+		.ast_skid_limit = 0x10,
+		.num_wds_entries = 0x20,
 	},
 	{
 		.id = QCA99X0_HW_2_0_DEV_VERSION,
@@ -223,6 +241,9 @@
 		.vht160_mcs_rx_highest = 0,
 		.vht160_mcs_tx_highest = 0,
 		.n_cipher_suites = 11,
+		.num_peers = TARGET_TLV_NUM_PEERS,
+		.ast_skid_limit = 0x10,
+		.num_wds_entries = 0x20,
 	},
 	{
 		.id = QCA9984_HW_1_0_DEV_VERSION,
@@ -257,6 +278,9 @@
 		.vht160_mcs_rx_highest = 1560,
 		.vht160_mcs_tx_highest = 1560,
 		.n_cipher_suites = 11,
+		.num_peers = TARGET_TLV_NUM_PEERS,
+		.ast_skid_limit = 0x10,
+		.num_wds_entries = 0x20,
 	},
 	{
 		.id = QCA9888_HW_2_0_DEV_VERSION,
@@ -290,6 +314,9 @@
 		.vht160_mcs_rx_highest = 780,
 		.vht160_mcs_tx_highest = 780,
 		.n_cipher_suites = 11,
+		.num_peers = TARGET_TLV_NUM_PEERS,
+		.ast_skid_limit = 0x10,
+		.num_wds_entries = 0x20,
 	},
 	{
 		.id = QCA9377_HW_1_0_DEV_VERSION,
@@ -313,6 +340,9 @@
 		.vht160_mcs_rx_highest = 0,
 		.vht160_mcs_tx_highest = 0,
 		.n_cipher_suites = 8,
+		.num_peers = TARGET_TLV_NUM_PEERS,
+		.ast_skid_limit = 0x10,
+		.num_wds_entries = 0x20,
 	},
 	{
 		.id = QCA9377_HW_1_1_DEV_VERSION,
@@ -338,6 +368,9 @@
 		.vht160_mcs_rx_highest = 0,
 		.vht160_mcs_tx_highest = 0,
 		.n_cipher_suites = 8,
+		.num_peers = TARGET_TLV_NUM_PEERS,
+		.ast_skid_limit = 0x10,
+		.num_wds_entries = 0x20,
 	},
 	{
 		.id = QCA4019_HW_1_0_DEV_VERSION,
@@ -368,6 +401,9 @@
 		.vht160_mcs_rx_highest = 0,
 		.vht160_mcs_tx_highest = 0,
 		.n_cipher_suites = 11,
+		.num_peers = TARGET_TLV_NUM_PEERS,
+		.ast_skid_limit = 0x10,
+		.num_wds_entries = 0x20,
 	},
 };
 
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 05f26e5..fedb6c7 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -553,6 +553,10 @@ struct ath10k_hw_params {
 
 	/* Number of ciphers supported (i.e First N) in cipher_suites array */
 	int n_cipher_suites;
+
+	u32 num_peers;
+	u32 ast_skid_limit;
+	u32 num_wds_entries;
 };
 
 struct htt_rx_desc;
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 452846c..0183d01 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -1440,7 +1440,10 @@ static struct sk_buff *ath10k_wmi_tlv_op_gen_init(struct ath10k *ar)
 	cmd->num_host_mem_chunks = __cpu_to_le32(ar->wmi.num_mem_chunks);
 
 	cfg->num_vdevs = __cpu_to_le32(TARGET_TLV_NUM_VDEVS);
-	cfg->num_peers = __cpu_to_le32(TARGET_TLV_NUM_PEERS);
+
+	cfg->num_peers = ar->hw_params.num_peers;
+	cfg->ast_skid_limit = ar->hw_params.ast_skid_limit;
+	cfg->num_wds_entries = ar->hw_params.num_wds_entries;
 
 	if (test_bit(WMI_SERVICE_RX_FULL_REORDER, ar->wmi.svc_map)) {
 		cfg->num_offload_peers = __cpu_to_le32(TARGET_TLV_NUM_VDEVS);
@@ -1452,7 +1455,6 @@ static struct sk_buff *ath10k_wmi_tlv_op_gen_init(struct ath10k *ar)
 
 	cfg->num_peer_keys = __cpu_to_le32(2);
 	cfg->num_tids = __cpu_to_le32(TARGET_TLV_NUM_TIDS);
-	cfg->ast_skid_limit = __cpu_to_le32(0x10);
 	cfg->tx_chain_mask = __cpu_to_le32(0x7);
 	cfg->rx_chain_mask = __cpu_to_le32(0x7);
 	cfg->rx_timeout_pri[0] = __cpu_to_le32(0x64);
@@ -1468,7 +1470,6 @@ static struct sk_buff *ath10k_wmi_tlv_op_gen_init(struct ath10k *ar)
 	cfg->num_mcast_table_elems = __cpu_to_le32(0);
 	cfg->mcast2ucast_mode = __cpu_to_le32(0);
 	cfg->tx_dbg_log_size = __cpu_to_le32(0x400);
-	cfg->num_wds_entries = __cpu_to_le32(0x20);
 	cfg->dma_burst_size = __cpu_to_le32(0);
 	cfg->mac_aggr_delim = __cpu_to_le32(0);
 	cfg->rx_skip_defrag_timeout_dup_detection_check = __cpu_to_le32(0);
-- 
1.9.1
