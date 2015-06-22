Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:57044 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbbFVOme (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2015 10:42:34 -0400
From: Raja Mani <rmani@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Subject: [PATCH v2 07/10] ath10k: fill 10.4 fw wmi init cmd default values
Date: Mon, 22 Jun 2015 20:10:15 +0530
Message-ID: <1434984018-24057-8-git-send-email-rmani@qti.qualcomm.com> (sfid-20150622_164238_432517_5CA4297D)
In-Reply-To: <1434984018-24057-1-git-send-email-rmani@qti.qualcomm.com>
References: <1434984018-24057-1-git-send-email-rmani@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Define 10.4 wmi init command structure and introduce new function
ath10k_wmi_10_4_op_gen_init() to fill default values for each field
which goes as part of wmi init cmd to 10.4 firmware.

Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c |   7 ++
 drivers/net/wireless/ath/ath10k/core.h |   2 +
 drivers/net/wireless/ath/ath10k/hw.h   |  54 ++++++++
 drivers/net/wireless/ath/ath10k/wmi.c  |  83 +++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h  | 220 +++++++++++++++++++++++++++++++++
 5 files changed, 366 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 5e8d8af..020ac9f 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1116,6 +1116,13 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 			WMI_STAT_PEER;
 		break;
 	case ATH10K_FW_WMI_OP_VERSION_10_4:
+		ar->max_num_peers = TARGET_10_4_NUM_PEERS;
+		ar->max_num_stations = TARGET_10_4_NUM_STATIONS;
+		ar->num_active_peers = TARGET_10_4_ACTIVE_PEERS;
+		ar->max_num_vdevs = TARGET_10_4_NUM_VDEVS;
+		ar->num_tids = TARGET_10_4_TGT_NUM_TIDS;
+		ar->fw_stats_req_mask = WMI_STAT_PEER;
+		break;
 	case ATH10K_FW_WMI_OP_VERSION_UNSET:
 	case ATH10K_FW_WMI_OP_VERSION_MAX:
 		WARN_ON(1);
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index afd21d5..58b02ae 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -684,6 +684,8 @@ struct ath10k {
 	int max_num_stations;
 	int max_num_vdevs;
 	int max_num_tdls_vdevs;
+	int num_active_peers;
+	int num_tids;
 
 	struct work_struct offchan_tx_work;
 	struct sk_buff_head offchan_tx_queue;
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index b0c89b4..52fc024 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -354,6 +354,60 @@ enum ath10k_hw_rate_cck {
 
 #define NUM_TARGET_CE_CONFIG_WLAN ar->hw_values->num_target_ce_config_wlan
 
+/* Target specific defines for 10.4 firmware */
+#define TARGET_10_4_NUM_VDEVS			16
+#define TARGET_10_4_NUM_STATIONS		32
+#define TARGET_10_4_NUM_PEERS			((TARGET_10_4_NUM_STATIONS) + \
+						 (TARGET_10_4_NUM_VDEVS))
+#define TARGET_10_4_ACTIVE_PEERS		0
+#define TARGET_10_4_NUM_OFFLOAD_PEERS		0
+#define TARGET_10_4_NUM_OFFLOAD_REORDER_BUFFS	0
+#define TARGET_10_4_NUM_PEER_KEYS		2
+#define TARGET_10_4_TGT_NUM_TIDS		((TARGET_10_4_NUM_PEERS) * 2)
+#define TARGET_10_4_AST_SKID_LIMIT		32
+#define TARGET_10_4_TX_CHAIN_MASK		(BIT(0) | BIT(1) | \
+						 BIT(2) | BIT(3))
+#define TARGET_10_4_RX_CHAIN_MASK		(BIT(0) | BIT(1) | \
+						 BIT(2) | BIT(3))
+
+/* 100 ms for video, best-effort, and background */
+#define TARGET_10_4_RX_TIMEOUT_LO_PRI		100
+
+/* 40 ms for voice */
+#define TARGET_10_4_RX_TIMEOUT_HI_PRI		40
+
+#define TARGET_10_4_RX_DECAP_MODE		ATH10K_HW_TXRX_NATIVE_WIFI
+#define TARGET_10_4_SCAN_MAX_REQS		4
+#define TARGET_10_4_BMISS_OFFLOAD_MAX_VDEV	3
+#define TARGET_10_4_ROAM_OFFLOAD_MAX_VDEV	3
+#define TARGET_10_4_ROAM_OFFLOAD_MAX_PROFILES   8
+
+/* Note: mcast to ucast is disabled by default */
+#define TARGET_10_4_NUM_MCAST_GROUPS		0
+#define TARGET_10_4_NUM_MCAST_TABLE_ELEMS	0
+#define TARGET_10_4_MCAST2UCAST_MODE		0
+
+#define TARGET_10_4_TX_DBG_LOG_SIZE		1024
+#define TARGET_10_4_NUM_WDS_ENTRIES		32
+#define TARGET_10_4_DMA_BURST_SIZE		1
+#define TARGET_10_4_MAC_AGGR_DELIM		0
+#define TARGET_10_4_RX_SKIP_DEFRAG_TIMEOUT_DUP_DETECTION_CHECK 1
+#define TARGET_10_4_VOW_CONFIG			0
+#define TARGET_10_4_GTK_OFFLOAD_MAX_VDEV	3
+#define TARGET_10_4_NUM_MSDU_DESC		(1024 + 400)
+#define TARGET_10_4_11AC_TX_MAX_FRAGS		2
+#define TARGET_10_4_MAX_PEER_EXT_STATS		16
+#define TARGET_10_4_SMART_ANT_CAP		0
+#define TARGET_10_4_BK_MIN_FREE			0
+#define TARGET_10_4_BE_MIN_FREE			0
+#define TARGET_10_4_VI_MIN_FREE			0
+#define TARGET_10_4_VO_MIN_FREE			0
+#define TARGET_10_4_RX_BATCH_MODE		1
+#define TARGET_10_4_THERMAL_THROTTLING_CONFIG	0
+#define TARGET_10_4_ATF_CONFIG			0
+#define TARGET_10_4_IPHDR_PAD_CONFIG		1
+#define TARGET_10_4_QWRAP_CONFIG		0
+
 /* Number of Copy Engines supported */
 #define CE_COUNT ar->hw_values->ce_count
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 3f29886..6c51b20 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -4641,6 +4641,88 @@ static struct sk_buff *ath10k_wmi_10_2_op_gen_init(struct ath10k *ar)
 	return buf;
 }
 
+static struct sk_buff *ath10k_wmi_10_4_op_gen_init(struct ath10k *ar)
+{
+	struct wmi_init_cmd_10_4 *cmd;
+	struct sk_buff *buf;
+	struct wmi_resource_config_10_4 config = {};
+	u32 len;
+
+	config.num_vdevs = __cpu_to_le32(ar->max_num_vdevs);
+	config.num_peers = __cpu_to_le32(ar->max_num_peers);
+	config.num_active_peers = __cpu_to_le32(ar->num_active_peers);
+	config.num_tids = __cpu_to_le32(ar->num_tids);
+
+	config.num_offload_peers = __cpu_to_le32(TARGET_10_4_NUM_OFFLOAD_PEERS);
+	config.num_offload_reorder_buffs =
+			__cpu_to_le32(TARGET_10_4_NUM_OFFLOAD_REORDER_BUFFS);
+	config.num_peer_keys  = __cpu_to_le32(TARGET_10_4_NUM_PEER_KEYS);
+	config.ast_skid_limit = __cpu_to_le32(TARGET_10_4_AST_SKID_LIMIT);
+	config.tx_chain_mask  = __cpu_to_le32(TARGET_10_4_TX_CHAIN_MASK);
+	config.rx_chain_mask  = __cpu_to_le32(TARGET_10_4_RX_CHAIN_MASK);
+
+	config.rx_timeout_pri[0] = __cpu_to_le32(TARGET_10_4_RX_TIMEOUT_LO_PRI);
+	config.rx_timeout_pri[1] = __cpu_to_le32(TARGET_10_4_RX_TIMEOUT_LO_PRI);
+	config.rx_timeout_pri[2] = __cpu_to_le32(TARGET_10_4_RX_TIMEOUT_LO_PRI);
+	config.rx_timeout_pri[3] = __cpu_to_le32(TARGET_10_4_RX_TIMEOUT_HI_PRI);
+
+	config.rx_decap_mode	    = __cpu_to_le32(TARGET_10_4_RX_DECAP_MODE);
+	config.scan_max_pending_req = __cpu_to_le32(TARGET_10_4_SCAN_MAX_REQS);
+	config.bmiss_offload_max_vdev =
+			__cpu_to_le32(TARGET_10_4_BMISS_OFFLOAD_MAX_VDEV);
+	config.roam_offload_max_vdev  =
+			__cpu_to_le32(TARGET_10_4_ROAM_OFFLOAD_MAX_VDEV);
+	config.roam_offload_max_ap_profiles =
+			__cpu_to_le32(TARGET_10_4_ROAM_OFFLOAD_MAX_PROFILES);
+	config.num_mcast_groups = __cpu_to_le32(TARGET_10_4_NUM_MCAST_GROUPS);
+	config.num_mcast_table_elems =
+			__cpu_to_le32(TARGET_10_4_NUM_MCAST_TABLE_ELEMS);
+
+	config.mcast2ucast_mode = __cpu_to_le32(TARGET_10_4_MCAST2UCAST_MODE);
+	config.tx_dbg_log_size  = __cpu_to_le32(TARGET_10_4_TX_DBG_LOG_SIZE);
+	config.num_wds_entries  = __cpu_to_le32(TARGET_10_4_NUM_WDS_ENTRIES);
+	config.dma_burst_size   = __cpu_to_le32(TARGET_10_4_DMA_BURST_SIZE);
+	config.mac_aggr_delim   = __cpu_to_le32(TARGET_10_4_MAC_AGGR_DELIM);
+
+	config.rx_skip_defrag_timeout_dup_detection_check =
+	  __cpu_to_le32(TARGET_10_4_RX_SKIP_DEFRAG_TIMEOUT_DUP_DETECTION_CHECK);
+
+	config.vow_config = __cpu_to_le32(TARGET_10_4_VOW_CONFIG);
+	config.gtk_offload_max_vdev =
+			__cpu_to_le32(TARGET_10_4_GTK_OFFLOAD_MAX_VDEV);
+	config.num_msdu_desc = __cpu_to_le32(TARGET_10_4_NUM_MSDU_DESC);
+	config.max_frag_entries = __cpu_to_le32(TARGET_10_4_11AC_TX_MAX_FRAGS);
+	config.max_peer_ext_stats =
+			__cpu_to_le32(TARGET_10_4_MAX_PEER_EXT_STATS);
+	config.smart_ant_cap = __cpu_to_le32(TARGET_10_4_SMART_ANT_CAP);
+
+	config.bk_minfree = __cpu_to_le32(TARGET_10_4_BK_MIN_FREE);
+	config.be_minfree = __cpu_to_le32(TARGET_10_4_BE_MIN_FREE);
+	config.vi_minfree = __cpu_to_le32(TARGET_10_4_VI_MIN_FREE);
+	config.vo_minfree = __cpu_to_le32(TARGET_10_4_VO_MIN_FREE);
+
+	config.rx_batchmode = __cpu_to_le32(TARGET_10_4_RX_BATCH_MODE);
+	config.tt_support =
+			__cpu_to_le32(TARGET_10_4_THERMAL_THROTTLING_CONFIG);
+	config.atf_config = __cpu_to_le32(TARGET_10_4_ATF_CONFIG);
+	config.iphdr_pad_config = __cpu_to_le32(TARGET_10_4_IPHDR_PAD_CONFIG);
+	config.qwrap_config = __cpu_to_le32(TARGET_10_4_QWRAP_CONFIG);
+
+	len = sizeof(*cmd) +
+	      (sizeof(struct host_memory_chunk) * ar->wmi.num_mem_chunks);
+
+	buf = ath10k_wmi_alloc_skb(ar, len);
+	if (!buf)
+		return ERR_PTR(-ENOMEM);
+
+	cmd = (struct wmi_init_cmd_10_4 *)buf->data;
+	memcpy(&cmd->resource_config, &config, sizeof(config));
+	ath10k_wmi_put_host_mem_chunks(ar, &cmd->mem_chunks);
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi init 10.4\n");
+	return buf;
+}
+
 int ath10k_wmi_start_scan_verify(const struct wmi_start_scan_arg *arg)
 {
 	if (arg->ie_len && !arg->ie)
@@ -6105,6 +6187,7 @@ static const struct wmi_ops wmi_10_2_4_ops = {
 
 static const struct wmi_ops wmi_10_4_ops = {
 	.map_svc = wmi_10_4_svc_map,
+	.gen_init = ath10k_wmi_10_4_op_gen_init,
 };
 
 int ath10k_wmi_attach(struct ath10k *ar)
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index f6ee163..dbb9f1c 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -2380,6 +2380,221 @@ struct wmi_resource_config_10_2 {
 #define NUM_UNITS_IS_NUM_VDEVS   0x1
 #define NUM_UNITS_IS_NUM_PEERS   0x2
 
+struct wmi_resource_config_10_4 {
+	/* Number of virtual devices (VAPs) to support */
+	__le32 num_vdevs;
+
+	/* Number of peer nodes to support */
+	__le32 num_peers;
+
+	/* Number of active peer nodes to support */
+	__le32 num_active_peers;
+
+	/* In offload mode, target supports features like WOW, chatter and other
+	 * protocol offloads. In order to support them some functionalities like
+	 * reorder buffering, PN checking need to be done in target.
+	 * This determines maximum number of peers supported by target in
+	 * offload mode.
+	 */
+	__le32 num_offload_peers;
+
+	/* Number of reorder buffers available for doing target based reorder
+	 * Rx reorder buffering
+	 */
+	__le32 num_offload_reorder_buffs;
+
+	/* Number of keys per peer */
+	__le32 num_peer_keys;
+
+	/* Total number of TX/RX data TIDs */
+	__le32 num_tids;
+
+	/* Max skid for resolving hash collisions.
+	 * The address search table is sparse, so that if two MAC addresses
+	 * result in the same hash value, the second of these conflicting
+	 * entries can slide to the next index in the address search table,
+	 * and use it, if it is unoccupied.  This ast_skid_limit parameter
+	 * specifies the upper bound on how many subsequent indices to search
+	 * over to find an unoccupied space.
+	 */
+	__le32 ast_skid_limit;
+
+	/* The nominal chain mask for transmit.
+	 * The chain mask may be modified dynamically, e.g. to operate AP tx
+	 * with a reduced number of chains if no clients are associated.
+	 * This configuration parameter specifies the nominal chain-mask that
+	 * should be used when not operating with a reduced set of tx chains.
+	 */
+	__le32 tx_chain_mask;
+
+	/* The nominal chain mask for receive.
+	 * The chain mask may be modified dynamically, e.g. for a client to use
+	 * a reduced number of chains for receive if the traffic to the client
+	 * is low enough that it doesn't require downlink MIMO or antenna
+	 * diversity. This configuration parameter specifies the nominal
+	 * chain-mask that should be used when not operating with a reduced
+	 * set of rx chains.
+	 */
+	__le32 rx_chain_mask;
+
+	/* What rx reorder timeout (ms) to use for the AC.
+	 * Each WMM access class (voice, video, best-effort, background) will
+	 * have its own timeout value to dictate how long to wait for missing
+	 * rx MPDUs to arrive before flushing subsequent MPDUs that have already
+	 * been received. This parameter specifies the timeout in milliseconds
+	 * for each class.
+	 */
+	__le32 rx_timeout_pri[4];
+
+	/* What mode the rx should decap packets to.
+	 * MAC can decap to RAW (no decap), native wifi or Ethernet types.
+	 * This setting also determines the default TX behavior, however TX
+	 * behavior can be modified on a per VAP basis during VAP init
+	 */
+	__le32 rx_decap_mode;
+
+	__le32 scan_max_pending_req;
+
+	__le32 bmiss_offload_max_vdev;
+
+	__le32 roam_offload_max_vdev;
+
+	__le32 roam_offload_max_ap_profiles;
+
+	/* How many groups to use for mcast->ucast conversion.
+	 * The target's WAL maintains a table to hold information regarding
+	 * which peers belong to a given multicast group, so that if
+	 * multicast->unicast conversion is enabled, the target can convert
+	 * multicast tx frames to a series of unicast tx frames, to each peer
+	 * within the multicast group. This num_mcast_groups configuration
+	 * parameter tells the target how many multicast groups to provide
+	 * storage for within its multicast group membership table.
+	 */
+	__le32 num_mcast_groups;
+
+	/* Size to alloc for the mcast membership table.
+	 * This num_mcast_table_elems configuration parameter tells the target
+	 * how many peer elements it needs to provide storage for in its
+	 * multicast group membership table. These multicast group membership
+	 * table elements are shared by the multicast groups stored within
+	 * the table.
+	 */
+	__le32 num_mcast_table_elems;
+
+	/* Whether/how to do multicast->unicast conversion.
+	 * This configuration parameter specifies whether the target should
+	 * perform multicast --> unicast conversion on transmit, and if so,
+	 * what to do if it finds no entries in its multicast group membership
+	 * table for the multicast IP address in the tx frame.
+	 * Configuration value:
+	 * 0 -> Do not perform multicast to unicast conversion.
+	 * 1 -> Convert multicast frames to unicast, if the IP multicast address
+	 *      from the tx frame is found in the multicast group membership
+	 *      table.  If the IP multicast address is not found, drop the frame
+	 * 2 -> Convert multicast frames to unicast, if the IP multicast address
+	 *      from the tx frame is found in the multicast group membership
+	 *      table.  If the IP multicast address is not found, transmit the
+	 *      frame as multicast.
+	 */
+	__le32 mcast2ucast_mode;
+
+	/* How much memory to allocate for a tx PPDU dbg log.
+	 * This parameter controls how much memory the target will allocate to
+	 * store a log of tx PPDU meta-information (how large the PPDU was,
+	 * when it was sent, whether it was successful, etc.)
+	 */
+	__le32 tx_dbg_log_size;
+
+	/* How many AST entries to be allocated for WDS */
+	__le32 num_wds_entries;
+
+	/* MAC DMA burst size. 0 -default, 1 -256B */
+	__le32 dma_burst_size;
+
+	/* Fixed delimiters to be inserted after every MPDU to account for
+	 * interface latency to avoid underrun.
+	 */
+	__le32 mac_aggr_delim;
+
+	/* Determine whether target is responsible for detecting duplicate
+	 * non-aggregate MPDU and timing out stale fragments. A-MPDU reordering
+	 * is always performed on the target.
+	 *
+	 * 0: target responsible for frag timeout and dup checking
+	 * 1: host responsible for frag timeout and dup checking
+	 */
+	__le32 rx_skip_defrag_timeout_dup_detection_check;
+
+	/* Configuration for VoW : No of Video nodes to be supported and max
+	 * no of descriptors for each video link (node).
+	 */
+	__le32 vow_config;
+
+	/* Maximum vdev that could use gtk offload */
+	__le32 gtk_offload_max_vdev;
+
+	/* Number of msdu descriptors target should use */
+	__le32 num_msdu_desc;
+
+	/* Max number of tx fragments per MSDU.
+	 * This parameter controls the max number of tx fragments per MSDU.
+	 * This will passed by target as part of the WMI_SERVICE_READY event
+	 * and is overridden by the OS shim as required.
+	 */
+	__le32 max_frag_entries;
+
+	/* Max number of extended peer stats.
+	 * This parameter controls the max number of peers for which extended
+	 * statistics are supported by target
+	 */
+	__le32 max_peer_ext_stats;
+
+	/* Smart antenna capabilities information.
+	 * 1 - Smart antenna is enabled
+	 * 0 - Smart antenna is disabled
+	 * In future this can contain smart antenna specific capabilities.
+	 */
+	__le32 smart_ant_cap;
+
+	/* User can configure the buffers allocated for each AC (BE, BK, VI, VO)
+	 * during init.
+	 */
+	__le32 bk_minfree;
+	__le32 be_minfree;
+	__le32 vi_minfree;
+	__le32 vo_minfree;
+
+	/* Rx batch mode capability.
+	 * 1 - Rx batch mode enabled
+	 * 0 - Rx batch mode disabled
+	 */
+	__le32 rx_batchmode;
+
+	/* Thermal throttling capability.
+	 * 1 - Capable of thermal throttling
+	 * 0 - Not capable of thermal throttling
+	 */
+	__le32 tt_support;
+
+	/* ATF configuration.
+	 * 1  - Enable ATF
+	 * 0  - Disable ATF
+	 */
+	__le32 atf_config;
+
+	/* Configure padding to manage IP header un-alignment
+	 * 1  - Enable padding
+	 * 0  - Disable padding
+	 */
+	__le32 iphdr_pad_config;
+
+	/* qwrap configuration
+	 * 1  - This is qwrap configuration
+	 * 0  - This is not qwrap
+	 */
+	__le32 qwrap_config;
+} __packed;
+
 /* strucutre describing host memory chunk. */
 struct host_memory_chunk {
 	/* id of the request that is passed up in service ready */
@@ -2412,6 +2627,11 @@ struct wmi_init_cmd_10_2 {
 	struct wmi_host_mem_chunks mem_chunks;
 } __packed;
 
+struct wmi_init_cmd_10_4 {
+	struct wmi_resource_config_10_4 resource_config;
+	struct wmi_host_mem_chunks mem_chunks;
+} __packed;
+
 struct wmi_chan_list_entry {
 	__le16 freq;
 	u8 phy_mode; /* valid for 10.2 only */
-- 
1.8.1.2

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
