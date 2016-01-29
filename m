Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:47608 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbcA2LF4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2016 06:05:56 -0500
From: Raja Mani <rmani@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Subject: [PATCH 2/2] ath10k: populate qca4019 fw specific wmi init params
Date: Fri, 29 Jan 2016 16:35:12 +0530
Message-ID: <1454065512-8238-3-git-send-email-rmani@qti.qualcomm.com> (sfid-20160129_120558_829913_29F35DB7)
In-Reply-To: <1454065512-8238-1-git-send-email-rmani@qti.qualcomm.com>
References: <1454065512-8238-1-git-send-email-rmani@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some of the parameter like tx/rx chain mask, number of htt tx desc,
qcache active peer count, etc goes via wmi init cmd to qca4019 firmware
are different.

To make use of 10.4 gen_init function for qca4019, change wmi service
ready handler and 10.4 wmi init functions to adapt qca4019 specific
init values.

Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 14 ++++++++++++--
 drivers/net/wireless/ath/ath10k/core.h |  6 ++++++
 drivers/net/wireless/ath/ath10k/hw.h   |  6 ------
 drivers/net/wireless/ath/ath10k/wmi.c  | 12 ++++++------
 drivers/net/wireless/ath/ath10k/wmi.h  |  1 -
 5 files changed, 24 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index ac29813..565cbab 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -156,6 +156,11 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.channel_counters_freq_hz = 150000,
 		.max_probe_resp_desc_thres = 24,
 		.hw_4addr_pad = ATH10K_HW_4ADDR_PAD_BEFORE,
+		.num_msdu_desc = 1424,
+		.qcache_active_peers = 50,
+		.tx_chain_mask = 0xf,
+		.rx_chain_mask = 0xf,
+		.max_spatial_stream = 4,
 		.fw = {
 			.dir = QCA99X0_HW_2_0_FW_DIR,
 			.fw = QCA99X0_HW_2_0_FW_FILE,
@@ -212,6 +217,11 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.channel_counters_freq_hz = 125000,
 		.max_probe_resp_desc_thres = 24,
 		.hw_4addr_pad = ATH10K_HW_4ADDR_PAD_BEFORE,
+		.num_msdu_desc = 2500,
+		.qcache_active_peers = 35,
+		.tx_chain_mask = 0x3,
+		.rx_chain_mask = 0x3,
+		.max_spatial_stream = 2,
 		.fw = {
 			.dir = QCA4019_HW_1_0_FW_DIR,
 			.fw = QCA4019_HW_1_0_FW_FILE,
@@ -1522,9 +1532,9 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 		ar->num_active_peers = TARGET_10_4_ACTIVE_PEERS;
 		ar->max_num_vdevs = TARGET_10_4_NUM_VDEVS;
 		ar->num_tids = TARGET_10_4_TGT_NUM_TIDS;
-		ar->htt.max_num_pending_tx = TARGET_10_4_NUM_MSDU_DESC;
+		ar->htt.max_num_pending_tx = ar->hw_params.num_msdu_desc;
 		ar->fw_stats_req_mask = WMI_STAT_PEER;
-		ar->max_spatial_stream = WMI_10_4_MAX_SPATIAL_STREAM;
+		ar->max_spatial_stream = ar->hw_params.max_spatial_stream;
 		break;
 	case ATH10K_FW_WMI_OP_VERSION_UNSET:
 	case ATH10K_FW_WMI_OP_VERSION_MAX:
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 2e1a7da..dad608c 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -669,6 +669,12 @@ struct ath10k {
 		/* The padding bytes's location is different on various chips */
 		enum ath10k_hw_4addr_pad hw_4addr_pad;
 
+		u32 num_msdu_desc;
+		u32 qcache_active_peers;
+		u32 tx_chain_mask;
+		u32 rx_chain_mask;
+		u32 max_spatial_stream;
+
 		struct ath10k_hw_params_fw {
 			const char *dir;
 			const char *fw;
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 291ca1f..2dece8d 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -426,16 +426,11 @@ enum ath10k_hw_4addr_pad {
 #define TARGET_10_4_ACTIVE_PEERS		0
 
 #define TARGET_10_4_NUM_QCACHE_PEERS_MAX	512
-#define TARGET_10_4_QCACHE_ACTIVE_PEERS		50
 #define TARGET_10_4_NUM_OFFLOAD_PEERS		0
 #define TARGET_10_4_NUM_OFFLOAD_REORDER_BUFFS	0
 #define TARGET_10_4_NUM_PEER_KEYS		2
 #define TARGET_10_4_TGT_NUM_TIDS		((TARGET_10_4_NUM_PEERS) * 2)
 #define TARGET_10_4_AST_SKID_LIMIT		32
-#define TARGET_10_4_TX_CHAIN_MASK		(BIT(0) | BIT(1) | \
-						 BIT(2) | BIT(3))
-#define TARGET_10_4_RX_CHAIN_MASK		(BIT(0) | BIT(1) | \
-						 BIT(2) | BIT(3))
 
 /* 100 ms for video, best-effort, and background */
 #define TARGET_10_4_RX_TIMEOUT_LO_PRI		100
@@ -461,7 +456,6 @@ enum ath10k_hw_4addr_pad {
 #define TARGET_10_4_RX_SKIP_DEFRAG_TIMEOUT_DUP_DETECTION_CHECK 1
 #define TARGET_10_4_VOW_CONFIG			0
 #define TARGET_10_4_GTK_OFFLOAD_MAX_VDEV	3
-#define TARGET_10_4_NUM_MSDU_DESC		(1024 + 400)
 #define TARGET_10_4_11AC_TX_MAX_FRAGS		2
 #define TARGET_10_4_MAX_PEER_EXT_STATS		16
 #define TARGET_10_4_SMART_ANT_CAP		0
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index a7c3d29..fcf101d 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -4562,9 +4562,9 @@ static void ath10k_wmi_event_service_ready_work(struct work_struct *work)
 
 	if (test_bit(WMI_SERVICE_PEER_CACHING, ar->wmi.svc_map)) {
 		ar->max_num_peers = TARGET_10_4_NUM_QCACHE_PEERS_MAX +
-				    TARGET_10_4_NUM_VDEVS;
-		ar->num_active_peers = TARGET_10_4_QCACHE_ACTIVE_PEERS +
-				       TARGET_10_4_NUM_VDEVS;
+				    ar->max_num_vdevs;
+		ar->num_active_peers = ar->hw_params.qcache_active_peers +
+				       ar->max_num_vdevs;
 		ar->num_tids = ar->num_active_peers * 2;
 		ar->max_num_stations = TARGET_10_4_NUM_QCACHE_PEERS_MAX;
 	}
@@ -5543,8 +5543,8 @@ static struct sk_buff *ath10k_wmi_10_4_op_gen_init(struct ath10k *ar)
 			__cpu_to_le32(TARGET_10_4_NUM_OFFLOAD_REORDER_BUFFS);
 	config.num_peer_keys  = __cpu_to_le32(TARGET_10_4_NUM_PEER_KEYS);
 	config.ast_skid_limit = __cpu_to_le32(TARGET_10_4_AST_SKID_LIMIT);
-	config.tx_chain_mask  = __cpu_to_le32(TARGET_10_4_TX_CHAIN_MASK);
-	config.rx_chain_mask  = __cpu_to_le32(TARGET_10_4_RX_CHAIN_MASK);
+	config.tx_chain_mask  = __cpu_to_le32(ar->hw_params.tx_chain_mask);
+	config.rx_chain_mask  = __cpu_to_le32(ar->hw_params.rx_chain_mask);
 
 	config.rx_timeout_pri[0] = __cpu_to_le32(TARGET_10_4_RX_TIMEOUT_LO_PRI);
 	config.rx_timeout_pri[1] = __cpu_to_le32(TARGET_10_4_RX_TIMEOUT_LO_PRI);
@@ -5575,7 +5575,7 @@ static struct sk_buff *ath10k_wmi_10_4_op_gen_init(struct ath10k *ar)
 	config.vow_config = __cpu_to_le32(TARGET_10_4_VOW_CONFIG);
 	config.gtk_offload_max_vdev =
 			__cpu_to_le32(TARGET_10_4_GTK_OFFLOAD_MAX_VDEV);
-	config.num_msdu_desc = __cpu_to_le32(TARGET_10_4_NUM_MSDU_DESC);
+	config.num_msdu_desc = __cpu_to_le32(ar->htt.max_num_pending_tx);
 	config.max_frag_entries = __cpu_to_le32(TARGET_10_4_11AC_TX_MAX_FRAGS);
 	config.max_peer_ext_stats =
 			__cpu_to_le32(TARGET_10_4_MAX_PEER_EXT_STATS);
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index d85ad78..ddcd3a5 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -1800,7 +1800,6 @@ enum wmi_channel_change_cause {
 #define WMI_CHANNEL_CHANGE_CAUSE_CSA (1 << 13)
 
 #define WMI_MAX_SPATIAL_STREAM        3 /* default max ss */
-#define WMI_10_4_MAX_SPATIAL_STREAM   4
 
 /* HT Capabilities*/
 #define WMI_HT_CAP_ENABLED                0x0001   /* HT Enabled/ disabled */
-- 
1.8.1.2

