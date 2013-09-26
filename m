Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:63675 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756234Ab3IZJaM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Sep 2013 05:30:12 -0400
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH v2 10/13] ath10k: add TARGET values for 10.x firmware
Date: Thu, 26 Sep 2013 11:29:49 +0200
Message-ID: <1380187792-25626-11-git-send-email-bartosz.markowski@tieto.com> (sfid-20130926_114457_723271_9007EF01)
In-Reply-To: <1380187792-25626-1-git-send-email-bartosz.markowski@tieto.com>
References: <1380187792-25626-1-git-send-email-bartosz.markowski@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduce all TARGET specific values for 10.x firmware.
Some of them are common for both firmwares we will support,
but to avoid confusion, define everything with prefix 10X_.

Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/hw.h  |   31 ++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.c |   58 ++++++++++++++++-----------------
 2 files changed, 60 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 66e721a..2de13db 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -53,6 +53,7 @@ enum ath10k_mcast2ucast_mode {
 	ATH10K_MCAST2UCAST_ENABLED = 1,
 };
 
+/* Target specific defines for MAIN firmware */
 #define TARGET_NUM_VDEVS			8
 #define TARGET_NUM_PEER_AST			2
 #define TARGET_NUM_WDS_ENTRIES			32
@@ -87,6 +88,36 @@ enum ath10k_mcast2ucast_mode {
 #define TARGET_NUM_MSDU_DESC			(1024 + 400)
 #define TARGET_MAX_FRAG_ENTRIES			0
 
+/* Target specific defines for 10.X firmware */
+#define TARGET_10X_NUM_VDEVS			16
+#define TARGET_10X_NUM_PEER_AST			2
+#define TARGET_10X_NUM_WDS_ENTRIES		32
+#define TARGET_10X_DMA_BURST_SIZE		0
+#define TARGET_10X_MAC_AGGR_DELIM		0
+#define TARGET_10X_AST_SKID_LIMIT		16
+#define TARGET_10X_NUM_PEERS			(128 + (TARGET_10X_NUM_VDEVS))
+#define TARGET_10X_NUM_OFFLOAD_PEERS		0
+#define TARGET_10X_NUM_OFFLOAD_REORDER_BUFS	0
+#define TARGET_10X_NUM_PEER_KEYS		2
+#define TARGET_10X_NUM_TIDS			256
+#define TARGET_10X_TX_CHAIN_MASK		(BIT(0) | BIT(1) | BIT(2))
+#define TARGET_10X_RX_CHAIN_MASK		(BIT(0) | BIT(1) | BIT(2))
+#define TARGET_10X_RX_TIMEOUT_LO_PRI		100
+#define TARGET_10X_RX_TIMEOUT_HI_PRI		40
+#define TARGET_10X_RX_DECAP_MODE		ATH10K_HW_TXRX_ETHERNET
+#define TARGET_10X_SCAN_MAX_PENDING_REQS	4
+#define TARGET_10X_BMISS_OFFLOAD_MAX_VDEV	2
+#define TARGET_10X_ROAM_OFFLOAD_MAX_VDEV	2
+#define TARGET_10X_ROAM_OFFLOAD_MAX_AP_PROFILES	8
+#define TARGET_10X_GTK_OFFLOAD_MAX_VDEV		3
+#define TARGET_10X_NUM_MCAST_GROUPS		0
+#define TARGET_10X_NUM_MCAST_TABLE_ELEMS	0
+#define TARGET_10X_MCAST2UCAST_MODE		ATH10K_MCAST2UCAST_DISABLED
+#define TARGET_10X_TX_DBG_LOG_SIZE		1024
+#define TARGET_10X_RX_SKIP_DEFRAG_TIMEOUT_DUP_DETECTION_CHECK 1
+#define TARGET_10X_VOW_CONFIG			0
+#define TARGET_10X_NUM_MSDU_DESC		(1024 + 400)
+#define TARGET_10X_MAX_FRAG_ENTRIES		0
 
 /* Number of Copy Engines supported */
 #define CE_COUNT 8
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index c81a8b7..de50856 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1450,9 +1450,9 @@ static void ath10k_wmi_10x_service_ready_event_rx(struct ath10k *ar,
 			 * peers, 1 extra for self peer on target */
 			/* this needs to be tied, host and target
 			 * can get out of sync */
-			num_units = TARGET_NUM_PEERS + 1;
+			num_units = TARGET_10X_NUM_PEERS + 1;
 		else if (num_unit_info & NUM_UNITS_IS_NUM_VDEVS)
-			num_units = TARGET_NUM_VDEVS + 1;
+			num_units = TARGET_10X_NUM_VDEVS + 1;
 
 		ath10k_dbg(ATH10K_DBG_WMI,
 			   "wmi mem_req_id %d num_units %d num_unit_info %d unit size %d actual units %d\n",
@@ -2015,48 +2015,48 @@ static int ath10k_wmi_10x_cmd_init(struct ath10k *ar)
 	u32 len, val;
 	int i;
 
-	config.num_vdevs = __cpu_to_le32(TARGET_NUM_VDEVS);
-	config.num_peers = __cpu_to_le32(TARGET_NUM_PEERS + TARGET_NUM_VDEVS);
-	config.num_peer_keys = __cpu_to_le32(TARGET_NUM_PEER_KEYS);
-	config.num_tids = __cpu_to_le32(TARGET_NUM_TIDS);
-	config.ast_skid_limit = __cpu_to_le32(TARGET_AST_SKID_LIMIT);
-	config.tx_chain_mask = __cpu_to_le32(TARGET_TX_CHAIN_MASK);
-	config.rx_chain_mask = __cpu_to_le32(TARGET_RX_CHAIN_MASK);
-	config.rx_timeout_pri_vo = __cpu_to_le32(TARGET_RX_TIMEOUT_LO_PRI);
-	config.rx_timeout_pri_vi = __cpu_to_le32(TARGET_RX_TIMEOUT_LO_PRI);
-	config.rx_timeout_pri_be = __cpu_to_le32(TARGET_RX_TIMEOUT_LO_PRI);
-	config.rx_timeout_pri_bk = __cpu_to_le32(TARGET_RX_TIMEOUT_HI_PRI);
-	config.rx_decap_mode = __cpu_to_le32(TARGET_RX_DECAP_MODE);
+	config.num_vdevs = __cpu_to_le32(TARGET_10X_NUM_VDEVS);
+	config.num_peers = __cpu_to_le32(TARGET_10X_NUM_PEERS);
+	config.num_peer_keys = __cpu_to_le32(TARGET_10X_NUM_PEER_KEYS);
+	config.num_tids = __cpu_to_le32(TARGET_10X_NUM_TIDS);
+	config.ast_skid_limit = __cpu_to_le32(TARGET_10X_AST_SKID_LIMIT);
+	config.tx_chain_mask = __cpu_to_le32(TARGET_10X_TX_CHAIN_MASK);
+	config.rx_chain_mask = __cpu_to_le32(TARGET_10X_RX_CHAIN_MASK);
+	config.rx_timeout_pri_vo = __cpu_to_le32(TARGET_10X_RX_TIMEOUT_LO_PRI);
+	config.rx_timeout_pri_vi = __cpu_to_le32(TARGET_10X_RX_TIMEOUT_LO_PRI);
+	config.rx_timeout_pri_be = __cpu_to_le32(TARGET_10X_RX_TIMEOUT_LO_PRI);
+	config.rx_timeout_pri_bk = __cpu_to_le32(TARGET_10X_RX_TIMEOUT_HI_PRI);
+	config.rx_decap_mode = __cpu_to_le32(TARGET_10X_RX_DECAP_MODE);
 
 	config.scan_max_pending_reqs =
-		__cpu_to_le32(TARGET_SCAN_MAX_PENDING_REQS);
+		__cpu_to_le32(TARGET_10X_SCAN_MAX_PENDING_REQS);
 
 	config.bmiss_offload_max_vdev =
-		__cpu_to_le32(TARGET_BMISS_OFFLOAD_MAX_VDEV);
+		__cpu_to_le32(TARGET_10X_BMISS_OFFLOAD_MAX_VDEV);
 
 	config.roam_offload_max_vdev =
-		__cpu_to_le32(TARGET_ROAM_OFFLOAD_MAX_VDEV);
+		__cpu_to_le32(TARGET_10X_ROAM_OFFLOAD_MAX_VDEV);
 
 	config.roam_offload_max_ap_profiles =
-		__cpu_to_le32(TARGET_ROAM_OFFLOAD_MAX_AP_PROFILES);
+		__cpu_to_le32(TARGET_10X_ROAM_OFFLOAD_MAX_AP_PROFILES);
 
-	config.num_mcast_groups = __cpu_to_le32(TARGET_NUM_MCAST_GROUPS);
+	config.num_mcast_groups = __cpu_to_le32(TARGET_10X_NUM_MCAST_GROUPS);
 	config.num_mcast_table_elems =
-		__cpu_to_le32(TARGET_NUM_MCAST_TABLE_ELEMS);
+		__cpu_to_le32(TARGET_10X_NUM_MCAST_TABLE_ELEMS);
 
-	config.mcast2ucast_mode = __cpu_to_le32(TARGET_MCAST2UCAST_MODE);
-	config.tx_dbg_log_size = __cpu_to_le32(TARGET_TX_DBG_LOG_SIZE);
-	config.num_wds_entries = __cpu_to_le32(TARGET_NUM_WDS_ENTRIES);
-	config.dma_burst_size = __cpu_to_le32(TARGET_DMA_BURST_SIZE);
-	config.mac_aggr_delim = __cpu_to_le32(TARGET_MAC_AGGR_DELIM);
+	config.mcast2ucast_mode = __cpu_to_le32(TARGET_10X_MCAST2UCAST_MODE);
+	config.tx_dbg_log_size = __cpu_to_le32(TARGET_10X_TX_DBG_LOG_SIZE);
+	config.num_wds_entries = __cpu_to_le32(TARGET_10X_NUM_WDS_ENTRIES);
+	config.dma_burst_size = __cpu_to_le32(TARGET_10X_DMA_BURST_SIZE);
+	config.mac_aggr_delim = __cpu_to_le32(TARGET_10X_MAC_AGGR_DELIM);
 
-	val = TARGET_RX_SKIP_DEFRAG_TIMEOUT_DUP_DETECTION_CHECK;
+	val = TARGET_10X_RX_SKIP_DEFRAG_TIMEOUT_DUP_DETECTION_CHECK;
 	config.rx_skip_defrag_timeout_dup_detection_check = __cpu_to_le32(val);
 
-	config.vow_config = __cpu_to_le32(TARGET_VOW_CONFIG);
+	config.vow_config = __cpu_to_le32(TARGET_10X_VOW_CONFIG);
 
-	config.num_msdu_desc = __cpu_to_le32(TARGET_NUM_MSDU_DESC);
-	config.max_frag_entries = __cpu_to_le32(TARGET_MAX_FRAG_ENTRIES);
+	config.num_msdu_desc = __cpu_to_le32(TARGET_10X_NUM_MSDU_DESC);
+	config.max_frag_entries = __cpu_to_le32(TARGET_10X_MAX_FRAG_ENTRIES);
 
 	len = sizeof(*cmd) +
 	      (sizeof(struct host_memory_chunk) * ar->wmi.num_mem_chunks);
-- 
1.7.10

