Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:42301 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757041AbcBWGu2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 01:50:28 -0500
From: <akolli@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Anilkumar Kolli <akolli@qti.qualcomm.com>
Subject: [PATCH] ath10k: Reduce number of peers to support peer stats feature
Date: Tue, 23 Feb 2016 12:19:57 +0530
Message-ID: <1456210197-27892-1-git-send-email-akolli@qti.qualcomm.com> (sfid-20160223_075032_024112_0F1A1594)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Anilkumar Kolli <akolli@qti.qualcomm.com>

To enable per peer stats feature we are reducing the number of peers.
Firmware has introduced tx stats feature. We have memory limitation in
firmware to add these additional bytes.

These are the new variables introduced in the firmware.
========		=======================
Variable	      	Bytes required/per rate
========		=======================
TX success packets 	1
TX failed packets	1
Retry packets		1
Success bytes		2
TX failed bytes		2
Retry bytes		2
Tx duration		4
Rate			1
Bw and AMPDU flags	1
Total			16 (because of allocation in word pattern)

Firmware sends these tx_stats in pktlog.
If we consider 4 feedbacks at a time, Frimware need about ~1K memory for coding
and 8192 bytes required / per rate [ 4*16*128(peers)].
To accommodate this firmware needs to reduce 10 peers.

Signed-off-by: Anilkumar Kolli <akolli@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c |  9 +++++++--
 drivers/net/wireless/ath/ath10k/hw.h   |  5 +++++
 drivers/net/wireless/ath/ath10k/wmi.c  | 10 ++++++++--
 3 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 1f4a278..59a7b00 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1479,8 +1479,13 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 	case ATH10K_FW_WMI_OP_VERSION_10_1:
 	case ATH10K_FW_WMI_OP_VERSION_10_2:
 	case ATH10K_FW_WMI_OP_VERSION_10_2_4:
-		ar->max_num_peers = TARGET_10X_NUM_PEERS;
-		ar->max_num_stations = TARGET_10X_NUM_STATIONS;
+		if (test_bit(WMI_SERVICE_PEER_STATS, ar->wmi.svc_map)) {
+			ar->max_num_peers = TARGET_10X_TX_STATS_NUM_PEERS;
+			ar->max_num_stations = TARGET_10X_TX_STATS_NUM_STATIONS;
+		} else {
+			ar->max_num_peers = TARGET_10X_NUM_PEERS;
+			ar->max_num_stations = TARGET_10X_NUM_STATIONS;
+		}
 		ar->max_num_vdevs = TARGET_10X_NUM_VDEVS;
 		ar->htt.max_num_pending_tx = TARGET_10X_NUM_MSDU_DESC;
 		ar->fw_stats_req_mask = WMI_STAT_PEER;
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 4217bdb..c8c86a7 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -367,14 +367,19 @@ enum ath10k_hw_4addr_pad {
 #define TARGET_10X_MAC_AGGR_DELIM		0
 #define TARGET_10X_AST_SKID_LIMIT		128
 #define TARGET_10X_NUM_STATIONS			128
+#define TARGET_10X_TX_STATS_NUM_STATIONS	118
 #define TARGET_10X_NUM_PEERS			((TARGET_10X_NUM_STATIONS) + \
 						 (TARGET_10X_NUM_VDEVS))
+#define TARGET_10X_TX_STATS_NUM_PEERS		((TARGET_10X_TX_STATS_NUM_STATIONS) + \
+						 (TARGET_10X_NUM_VDEVS))
 #define TARGET_10X_NUM_OFFLOAD_PEERS		0
 #define TARGET_10X_NUM_OFFLOAD_REORDER_BUFS	0
 #define TARGET_10X_NUM_PEER_KEYS		2
 #define TARGET_10X_NUM_TIDS_MAX			256
 #define TARGET_10X_NUM_TIDS			min((TARGET_10X_NUM_TIDS_MAX), \
 						    (TARGET_10X_NUM_PEERS) * 2)
+#define TARGET_10X_TX_STATS_NUM_TIDS		min((TARGET_10X_NUM_TIDS_MAX), \
+						    (TARGET_10X_TX_STATS_NUM_PEERS) * 2)
 #define TARGET_10X_TX_CHAIN_MASK		(BIT(0) | BIT(1) | BIT(2))
 #define TARGET_10X_RX_CHAIN_MASK		(BIT(0) | BIT(1) | BIT(2))
 #define TARGET_10X_RX_TIMEOUT_LO_PRI		100
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index b109b80..e77e60c 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -5517,9 +5517,15 @@ static struct sk_buff *ath10k_wmi_10_2_op_gen_init(struct ath10k *ar)
 	u32 len, val, features;
 
 	config.num_vdevs = __cpu_to_le32(TARGET_10X_NUM_VDEVS);
-	config.num_peers = __cpu_to_le32(TARGET_10X_NUM_PEERS);
 	config.num_peer_keys = __cpu_to_le32(TARGET_10X_NUM_PEER_KEYS);
-	config.num_tids = __cpu_to_le32(TARGET_10X_NUM_TIDS);
+	if (test_bit(WMI_SERVICE_PEER_STATS, ar->wmi.svc_map)) {
+		config.num_peers = __cpu_to_le32(TARGET_10X_TX_STATS_NUM_PEERS);
+		config.num_tids = __cpu_to_le32(TARGET_10X_TX_STATS_NUM_TIDS);
+	} else {
+		config.num_peers = __cpu_to_le32(TARGET_10X_NUM_PEERS);
+		config.num_tids = __cpu_to_le32(TARGET_10X_NUM_TIDS);
+	}
+
 	config.ast_skid_limit = __cpu_to_le32(TARGET_10X_AST_SKID_LIMIT);
 	config.tx_chain_mask = __cpu_to_le32(TARGET_10X_TX_CHAIN_MASK);
 	config.rx_chain_mask = __cpu_to_le32(TARGET_10X_RX_CHAIN_MASK);
-- 
1.9.1

