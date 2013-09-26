Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:56240 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303Ab3IZPri (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Sep 2013 11:47:38 -0400
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH v3 09/13] ath10k: split wmi_cmd_init path
Date: Thu, 26 Sep 2013 17:47:13 +0200
Message-ID: <1380210437-4391-10-git-send-email-bartosz.markowski@tieto.com> (sfid-20130926_174744_982798_0D82BB0C)
In-Reply-To: <1380210437-4391-1-git-send-email-bartosz.markowski@tieto.com>
References: <1380210437-4391-1-git-send-email-bartosz.markowski@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Due to API differences in initialization structures for
main and 10.x firmwares we need to split the wmi_init_cmd
and wmi_resource_config  structures.

This will be usefull also when setting the correct TARGET values,
like: number of peers, vdevs, pdevs etc.

Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c |  105 +++++++++++++++++-
 drivers/net/wireless/ath/ath10k/wmi.h |  195 +++++++++++++++++++++++++++++++++
 2 files changed, 299 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 8c22367..71ad1b8 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1908,7 +1908,7 @@ int ath10k_wmi_pdev_set_param(struct ath10k *ar, enum wmi_pdev_param id,
 	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->pdev_set_param_cmdid);
 }
 
-int ath10k_wmi_cmd_init(struct ath10k *ar)
+static int ath10k_wmi_main_cmd_init(struct ath10k *ar)
 {
 	struct wmi_init_cmd *cmd;
 	struct sk_buff *buf;
@@ -2007,6 +2007,109 @@ out:
 	return ath10k_wmi_cmd_send(ar, buf, ar->wmi.cmd->init_cmdid);
 }
 
+static int ath10k_wmi_10x_cmd_init(struct ath10k *ar)
+{
+	struct wmi_init_cmd_10x *cmd;
+	struct sk_buff *buf;
+	struct wmi_resource_config_10x config = {};
+	u32 len, val;
+	int i;
+
+	config.num_vdevs = __cpu_to_le32(TARGET_NUM_VDEVS);
+	config.num_peers = __cpu_to_le32(TARGET_NUM_PEERS + TARGET_NUM_VDEVS);
+	config.num_peer_keys = __cpu_to_le32(TARGET_NUM_PEER_KEYS);
+	config.num_tids = __cpu_to_le32(TARGET_NUM_TIDS);
+	config.ast_skid_limit = __cpu_to_le32(TARGET_AST_SKID_LIMIT);
+	config.tx_chain_mask = __cpu_to_le32(TARGET_TX_CHAIN_MASK);
+	config.rx_chain_mask = __cpu_to_le32(TARGET_RX_CHAIN_MASK);
+	config.rx_timeout_pri_vo = __cpu_to_le32(TARGET_RX_TIMEOUT_LO_PRI);
+	config.rx_timeout_pri_vi = __cpu_to_le32(TARGET_RX_TIMEOUT_LO_PRI);
+	config.rx_timeout_pri_be = __cpu_to_le32(TARGET_RX_TIMEOUT_LO_PRI);
+	config.rx_timeout_pri_bk = __cpu_to_le32(TARGET_RX_TIMEOUT_HI_PRI);
+	config.rx_decap_mode = __cpu_to_le32(TARGET_RX_DECAP_MODE);
+
+	config.scan_max_pending_reqs =
+		__cpu_to_le32(TARGET_SCAN_MAX_PENDING_REQS);
+
+	config.bmiss_offload_max_vdev =
+		__cpu_to_le32(TARGET_BMISS_OFFLOAD_MAX_VDEV);
+
+	config.roam_offload_max_vdev =
+		__cpu_to_le32(TARGET_ROAM_OFFLOAD_MAX_VDEV);
+
+	config.roam_offload_max_ap_profiles =
+		__cpu_to_le32(TARGET_ROAM_OFFLOAD_MAX_AP_PROFILES);
+
+	config.num_mcast_groups = __cpu_to_le32(TARGET_NUM_MCAST_GROUPS);
+	config.num_mcast_table_elems =
+		__cpu_to_le32(TARGET_NUM_MCAST_TABLE_ELEMS);
+
+	config.mcast2ucast_mode = __cpu_to_le32(TARGET_MCAST2UCAST_MODE);
+	config.tx_dbg_log_size = __cpu_to_le32(TARGET_TX_DBG_LOG_SIZE);
+	config.num_wds_entries = __cpu_to_le32(TARGET_NUM_WDS_ENTRIES);
+	config.dma_burst_size = __cpu_to_le32(TARGET_DMA_BURST_SIZE);
+	config.mac_aggr_delim = __cpu_to_le32(TARGET_MAC_AGGR_DELIM);
+
+	val = TARGET_RX_SKIP_DEFRAG_TIMEOUT_DUP_DETECTION_CHECK;
+	config.rx_skip_defrag_timeout_dup_detection_check = __cpu_to_le32(val);
+
+	config.vow_config = __cpu_to_le32(TARGET_VOW_CONFIG);
+
+	config.num_msdu_desc = __cpu_to_le32(TARGET_NUM_MSDU_DESC);
+	config.max_frag_entries = __cpu_to_le32(TARGET_MAX_FRAG_ENTRIES);
+
+	len = sizeof(*cmd) +
+	      (sizeof(struct host_memory_chunk) * ar->wmi.num_mem_chunks);
+
+	buf = ath10k_wmi_alloc_skb(len);
+	if (!buf)
+		return -ENOMEM;
+
+	cmd = (struct wmi_init_cmd_10x *)buf->data;
+
+	if (ar->wmi.num_mem_chunks == 0) {
+		cmd->num_host_mem_chunks = 0;
+		goto out;
+	}
+
+	ath10k_dbg(ATH10K_DBG_WMI, "wmi sending %d memory chunks info.\n",
+		   __cpu_to_le32(ar->wmi.num_mem_chunks));
+
+	cmd->num_host_mem_chunks = __cpu_to_le32(ar->wmi.num_mem_chunks);
+
+	for (i = 0; i < ar->wmi.num_mem_chunks; i++) {
+		cmd->host_mem_chunks[i].ptr =
+			__cpu_to_le32(ar->wmi.mem_chunks[i].paddr);
+		cmd->host_mem_chunks[i].size =
+			__cpu_to_le32(ar->wmi.mem_chunks[i].len);
+		cmd->host_mem_chunks[i].req_id =
+			__cpu_to_le32(ar->wmi.mem_chunks[i].req_id);
+
+		ath10k_dbg(ATH10K_DBG_WMI,
+			   "wmi chunk %d len %d requested, addr 0x%x\n",
+			   i,
+			   cmd->host_mem_chunks[i].size,
+			   cmd->host_mem_chunks[i].ptr);
+	}
+out:
+	memcpy(&cmd->resource_config, &config, sizeof(config));
+
+	ath10k_dbg(ATH10K_DBG_WMI, "wmi init 10x\n");
+	return ath10k_wmi_cmd_send(ar, buf, ar->wmi.cmd->init_cmdid);
+}
+
+int ath10k_wmi_cmd_init(struct ath10k *ar)
+{
+	int ret;
+
+	if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features))
+		ret = ath10k_wmi_10x_cmd_init(ar);
+	else
+		ret = ath10k_wmi_main_cmd_init(ar);
+
+	return ret;
+}
+
 static int ath10k_wmi_start_scan_calc_len(const struct wmi_start_scan_arg *arg)
 {
 	int len;
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 1c515d6..5383f7e 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -1377,6 +1377,189 @@ struct wmi_resource_config {
 	__le32 max_frag_entries;
 } __packed;
 
+struct wmi_resource_config_10x {
+	/* number of virtual devices (VAPs) to support */
+	__le32 num_vdevs;
+
+	/* number of peer nodes to support */
+	__le32 num_peers;
+
+	/* number of keys per peer */
+	__le32 num_peer_keys;
+
+	/* total number of TX/RX data TIDs */
+	__le32 num_tids;
+
+	/*
+	 * max skid for resolving hash collisions
+	 *
+	 *   The address search table is sparse, so that if two MAC addresses
+	 *   result in the same hash value, the second of these conflicting
+	 *   entries can slide to the next index in the address search table,
+	 *   and use it, if it is unoccupied.  This ast_skid_limit parameter
+	 *   specifies the upper bound on how many subsequent indices to search
+	 *   over to find an unoccupied space.
+	 */
+	__le32 ast_skid_limit;
+
+	/*
+	 * the nominal chain mask for transmit
+	 *
+	 *   The chain mask may be modified dynamically, e.g. to operate AP
+	 *   tx with a reduced number of chains if no clients are associated.
+	 *   This configuration parameter specifies the nominal chain-mask that
+	 *   should be used when not operating with a reduced set of tx chains.
+	 */
+	__le32 tx_chain_mask;
+
+	/*
+	 * the nominal chain mask for receive
+	 *
+	 *   The chain mask may be modified dynamically, e.g. for a client
+	 *   to use a reduced number of chains for receive if the traffic to
+	 *   the client is low enough that it doesn't require downlink MIMO
+	 *   or antenna diversity.
+	 *   This configuration parameter specifies the nominal chain-mask that
+	 *   should be used when not operating with a reduced set of rx chains.
+	 */
+	__le32 rx_chain_mask;
+
+	/*
+	 * what rx reorder timeout (ms) to use for the AC
+	 *
+	 *   Each WMM access class (voice, video, best-effort, background) will
+	 *   have its own timeout value to dictate how long to wait for missing
+	 *   rx MPDUs to arrive before flushing subsequent MPDUs that have
+	 *   already been received.
+	 *   This parameter specifies the timeout in milliseconds for each
+	 *   class.
+	 */
+	__le32 rx_timeout_pri_vi;
+	__le32 rx_timeout_pri_vo;
+	__le32 rx_timeout_pri_be;
+	__le32 rx_timeout_pri_bk;
+
+	/*
+	 * what mode the rx should decap packets to
+	 *
+	 *   MAC can decap to RAW (no decap), native wifi or Ethernet types
+	 *   THis setting also determines the default TX behavior, however TX
+	 *   behavior can be modified on a per VAP basis during VAP init
+	 */
+	__le32 rx_decap_mode;
+
+	/* what is the maximum scan requests than can be queued */
+	__le32 scan_max_pending_reqs;
+
+	/* maximum VDEV that could use BMISS offload */
+	__le32 bmiss_offload_max_vdev;
+
+	/* maximum VDEV that could use offload roaming */
+	__le32 roam_offload_max_vdev;
+
+	/* maximum AP profiles that would push to offload roaming */
+	__le32 roam_offload_max_ap_profiles;
+
+	/*
+	 * how many groups to use for mcast->ucast conversion
+	 *
+	 *   The target's WAL maintains a table to hold information regarding
+	 *   which peers belong to a given multicast group, so that if
+	 *   multicast->unicast conversion is enabled, the target can convert
+	 *   multicast tx frames to a series of unicast tx frames, to each
+	 *   peer within the multicast group.
+	     This num_mcast_groups configuration parameter tells the target how
+	 *   many multicast groups to provide storage for within its multicast
+	 *   group membership table.
+	 */
+	__le32 num_mcast_groups;
+
+	/*
+	 * size to alloc for the mcast membership table
+	 *
+	 *   This num_mcast_table_elems configuration parameter tells the
+	 *   target how many peer elements it needs to provide storage for in
+	 *   its multicast group membership table.
+	 *   These multicast group membership table elements are shared by the
+	 *   multicast groups stored within the table.
+	 */
+	__le32 num_mcast_table_elems;
+
+	/*
+	 * whether/how to do multicast->unicast conversion
+	 *
+	 *   This configuration parameter specifies whether the target should
+	 *   perform multicast --> unicast conversion on transmit, and if so,
+	 *   what to do if it finds no entries in its multicast group
+	 *   membership table for the multicast IP address in the tx frame.
+	 *   Configuration value:
+	 *   0 -> Do not perform multicast to unicast conversion.
+	 *   1 -> Convert multicast frames to unicast, if the IP multicast
+	 *        address from the tx frame is found in the multicast group
+	 *        membership table.  If the IP multicast address is not found,
+	 *        drop the frame.
+	 *   2 -> Convert multicast frames to unicast, if the IP multicast
+	 *        address from the tx frame is found in the multicast group
+	 *        membership table.  If the IP multicast address is not found,
+	 *        transmit the frame as multicast.
+	 */
+	__le32 mcast2ucast_mode;
+
+	/*
+	 * how much memory to allocate for a tx PPDU dbg log
+	 *
+	 *   This parameter controls how much memory the target will allocate
+	 *   to store a log of tx PPDU meta-information (how large the PPDU
+	 *   was, when it was sent, whether it was successful, etc.)
+	 */
+	__le32 tx_dbg_log_size;
+
+	/* how many AST entries to be allocated for WDS */
+	__le32 num_wds_entries;
+
+	/*
+	 * MAC DMA burst size, e.g., For target PCI limit can be
+	 * 0 -default, 1 256B
+	 */
+	__le32 dma_burst_size;
+
+	/*
+	 * Fixed delimiters to be inserted after every MPDU to
+	 * account for interface latency to avoid underrun.
+	 */
+	__le32 mac_aggr_delim;
+
+	/*
+	 *   determine whether target is responsible for detecting duplicate
+	 *   non-aggregate MPDU and timing out stale fragments.
+	 *
+	 *   A-MPDU reordering is always performed on the target.
+	 *
+	 *   0: target responsible for frag timeout and dup checking
+	 *   1: host responsible for frag timeout and dup checking
+	 */
+	__le32 rx_skip_defrag_timeout_dup_detection_check;
+
+	/*
+	 * Configuration for VoW :
+	 * No of Video Nodes to be supported
+	 * and Max no of descriptors for each Video link (node).
+	 */
+	__le32 vow_config;
+
+	/* Number of msdu descriptors target should use */
+	__le32 num_msdu_desc;
+
+	/*
+	 * Max. number of Tx fragments per MSDU
+	 *  This parameter controls the max number of Tx fragments per MSDU.
+	 *  This is sent by the target as part of the WMI_SERVICE_READY event
+	 *  and is overriden by the OS shim as required.
+	 */
+	__le32 max_frag_entries;
+} __packed;
+
+
 #define NUM_UNITS_IS_NUM_VDEVS   0x1
 #define NUM_UNITS_IS_NUM_PEERS   0x2
 
@@ -1401,6 +1584,18 @@ struct wmi_init_cmd {
 	struct host_memory_chunk host_mem_chunks[1];
 } __packed;
 
+/* _10x stucture is from 10.X FW API */
+struct wmi_init_cmd_10x {
+	struct wmi_resource_config_10x resource_config;
+	__le32 num_host_mem_chunks;
+
+	/*
+	 * variable number of host memory chunks.
+	 * This should be the last element in the structure
+	 */
+	struct host_memory_chunk host_mem_chunks[1];
+} __packed;
+
 /* TLV for channel list */
 struct wmi_chan_list {
 	__le32 tag; /* WMI_CHAN_LIST_TAG */
-- 
1.7.10

