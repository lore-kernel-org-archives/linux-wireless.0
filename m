Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55824 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750937AbeGJHNU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Jul 2018 03:13:20 -0400
From: Karthikeyan Periyasamy <periyasa@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Karthikeyan Periyasamy <periyasa@codeaurora.org>
Subject: [RFCv2 1/2] ath10k: add wmi interface for vdev_set_neighbor_rx_param
Date: Tue, 10 Jul 2018 12:42:58 +0530
Message-Id: <1531206779-26517-2-git-send-email-periyasa@codeaurora.org> (sfid-20180710_091323_590624_1F9C70EE)
In-Reply-To: <1531206779-26517-1-git-send-email-periyasa@codeaurora.org>
References: <1531206779-26517-1-git-send-email-periyasa@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add WMI command interface support for receiving neighbor BSS frames from
the target. QCA9984, QCA4019 and QCA9888 support this WMI command with the
capability advertisement through wmi service map.

Hardware tested: QCA9984, QCA4019 and QCA9888
Firmware tested: 10.4-3.6-xxxxx

NOTE: Tested with debug firmware

Signed-off-by: Karthikeyan Periyasamy <periyasa@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/wmi-ops.h | 28 +++++++++++-
 drivers/net/wireless/ath/ath10k/wmi.c     | 33 ++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h     | 76 +++++++++++++++++++++++++++++++
 3 files changed, 136 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-ops.h b/drivers/net/wireless/ath/ath10k/wmi-ops.h
index 5ecce04..8444b41 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-ops.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-ops.h
@@ -214,7 +214,12 @@ struct wmi_ops {
 	struct sk_buff *(*gen_echo)(struct ath10k *ar, u32 value);
 	struct sk_buff *(*gen_pdev_get_tpc_table_cmdid)(struct ath10k *ar,
 							u32 param);
-
+	struct sk_buff *(*gen_vdev_set_neighbor_rx_param)(struct ath10k *ar,
+							  u32 vdev_id,
+							  const u8 *addr,
+							  u32 idx,
+							  u32 action,
+							  u32 type);
 };
 
 int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb, u32 cmd_id);
@@ -1543,4 +1548,25 @@ struct wmi_ops {
 				   ar->wmi.cmd->radar_found_cmdid);
 }
 
+static inline int
+ath10k_wmi_set_neighbor_rx_param(struct ath10k *ar, u32 vdev_id,
+				 const u8 *addr, u32 idx,
+				 u32 action, u32 type)
+{
+	struct sk_buff *skb;
+	u32 cmdid;
+
+	if (!ar->wmi.ops->gen_vdev_set_neighbor_rx_param)
+		return -EOPNOTSUPP;
+
+	cmdid = ar->wmi.cmd->vdev_filter_neighbor_rx_packets_cmdid;
+	skb = ar->wmi.ops->gen_vdev_set_neighbor_rx_param(ar,
+							  vdev_id, addr,
+							  idx, action, type);
+
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	return ath10k_wmi_cmd_send(ar, skb, cmdid);
+}
 #endif
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 877249a..fe62489 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -8662,6 +8662,37 @@ static u32 ath10k_wmi_prepare_peer_qos(u8 uapsd_queues, u8 sp)
 	return 0;
 }
 
+static struct sk_buff *
+ath10k_wmi_10_4_op_gen_vdev_set_neighbor_rx_param(struct ath10k *ar,
+						  u32 vdev_id,
+						  const u8 *addr,
+						  u32 idx, u32 action,
+						  u32 type)
+{
+	struct wmi_set_vdev_filter_nrp_10_4_cmd *cmd;
+	struct sk_buff *skb;
+
+	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
+	if (!skb)
+		return ERR_PTR(-ENOMEM);
+
+	cmd = (struct wmi_set_vdev_filter_nrp_10_4_cmd *)skb->data;
+
+	cmd->vdev_id = __cpu_to_le32(vdev_id);
+	cmd->action = __cpu_to_le32(action);
+	cmd->type = __cpu_to_le32(type);
+	cmd->idx = __cpu_to_le32(idx);
+
+	ether_addr_copy(cmd->macaddr.addr, addr);
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI,
+		   "vdev id:0x%x Macaddr[0x%x]:[0x%x] idx:0x%x action:0x%x type:0x%x flag:0x%x\n",
+		   cmd->vdev_id, cmd->macaddr.addr[0], cmd->macaddr.addr[5],
+		   cmd->idx, cmd->action, cmd->type, cmd->flag);
+
+	return skb;
+}
+
 static const struct wmi_ops wmi_ops = {
 	.rx = ath10k_wmi_op_rx,
 	.map_svc = wmi_main_svc_map,
@@ -9014,6 +9045,8 @@ static u32 ath10k_wmi_prepare_peer_qos(u8 uapsd_queues, u8 sp)
 	.gen_pdev_bss_chan_info_req = ath10k_wmi_10_2_op_gen_pdev_bss_chan_info,
 	.gen_echo = ath10k_wmi_op_gen_echo,
 	.gen_pdev_get_tpc_config = ath10k_wmi_10_2_4_op_gen_pdev_get_tpc_config,
+	.gen_vdev_set_neighbor_rx_param =
+		ath10k_wmi_10_4_op_gen_vdev_set_neighbor_rx_param,
 };
 
 int ath10k_wmi_attach(struct ath10k *ar)
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index d68afb6..bc53d4c 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -203,6 +203,13 @@ enum wmi_service {
 	WMI_SERVICE_TPC_STATS_FINAL,
 	WMI_SERVICE_RESET_CHIP,
 	WMI_SERVICE_SPOOF_MAC_SUPPORT,
+	WMI_SERVICE_CFR_CAPTURE_SUPPORT,
+	WMI_SERVICE_TX_DATA_ACK_RSSI,
+	WMI_SERVICE_CFR_CAPTURE_IND_MSG_TYPE_LAGACY,
+	WMI_SERVICE_PER_PACKET_SW_ENCRYPT,
+	WMI_SERVICE_PEER_TID_CONFIGS_SUPPORT,
+	WMI_SERVICE_VDEV_BCN_RATE_CONTROL,
+	WMI_SERVICE_VDEV_FILTER_NEIGHBOR,
 
 	/* keep last */
 	WMI_SERVICE_MAX,
@@ -350,6 +357,13 @@ enum wmi_10_4_service {
 	WMI_10_4_SERVICE_HTT_MGMT_TX_COMP_VALID_FLAGS,
 	WMI_10_4_SERVICE_HOST_DFS_CHECK_SUPPORT,
 	WMI_10_4_SERVICE_TPC_STATS_FINAL,
+	WMI_10_4_SERVICE_CFR_CAPTURE_SUPPORT,
+	WMI_10_4_SERVICE_TX_DATA_ACK_RSSI,
+	WMI_10_4_SERVICE_CFR_CAPTURE_IND_MSG_TYPE_LAGACY,
+	WMI_10_4_SERVICE_PER_PACKET_SW_ENCRYPT,
+	WMI_10_4_SERVICE_PEER_TID_CONFIGS_SUPPORT,
+	WMI_10_4_SERVICE_VDEV_BCN_RATE_CONTROL,
+	WMI_10_4_SERVICE_VDEV_FILTER_NEIGHBOR,
 };
 
 static inline char *wmi_service_name(int service_id)
@@ -462,6 +476,15 @@ static inline char *wmi_service_name(int service_id)
 	SVCSTR(WMI_SERVICE_HTT_MGMT_TX_COMP_VALID_FLAGS);
 	SVCSTR(WMI_SERVICE_HOST_DFS_CHECK_SUPPORT);
 	SVCSTR(WMI_SERVICE_TPC_STATS_FINAL);
+	SVCSTR(WMI_SERVICE_RESET_CHIP);
+	SVCSTR(WMI_SERVICE_CFR_CAPTURE_SUPPORT);
+	SVCSTR(WMI_SERVICE_TX_DATA_ACK_RSSI);
+	SVCSTR(WMI_SERVICE_CFR_CAPTURE_IND_MSG_TYPE_LAGACY);
+	SVCSTR(WMI_SERVICE_PER_PACKET_SW_ENCRYPT);
+	SVCSTR(WMI_SERVICE_PEER_TID_CONFIGS_SUPPORT);
+	SVCSTR(WMI_SERVICE_VDEV_BCN_RATE_CONTROL);
+	SVCSTR(WMI_SERVICE_VDEV_FILTER_NEIGHBOR);
+
 	default:
 		return NULL;
 	}
@@ -770,6 +793,20 @@ static inline void wmi_10_4_svc_map(const __le32 *in, unsigned long *out,
 	       WMI_SERVICE_HOST_DFS_CHECK_SUPPORT, len);
 	SVCMAP(WMI_10_4_SERVICE_TPC_STATS_FINAL,
 	       WMI_SERVICE_TPC_STATS_FINAL, len);
+	SVCMAP(WMI_10_4_SERVICE_CFR_CAPTURE_SUPPORT,
+	       WMI_SERVICE_CFR_CAPTURE_SUPPORT, len);
+	SVCMAP(WMI_10_4_SERVICE_TX_DATA_ACK_RSSI,
+	       WMI_SERVICE_TX_DATA_ACK_RSSI, len);
+	SVCMAP(WMI_10_4_SERVICE_CFR_CAPTURE_IND_MSG_TYPE_LAGACY,
+	       WMI_SERVICE_CFR_CAPTURE_IND_MSG_TYPE_LAGACY, len);
+	SVCMAP(WMI_10_4_SERVICE_PER_PACKET_SW_ENCRYPT,
+	       WMI_SERVICE_PER_PACKET_SW_ENCRYPT, len);
+	SVCMAP(WMI_10_4_SERVICE_PEER_TID_CONFIGS_SUPPORT,
+	       WMI_SERVICE_PEER_TID_CONFIGS_SUPPORT, len);
+	SVCMAP(WMI_10_4_SERVICE_VDEV_BCN_RATE_CONTROL,
+	       WMI_SERVICE_VDEV_BCN_RATE_CONTROL, len);
+	SVCMAP(WMI_10_4_SERVICE_VDEV_FILTER_NEIGHBOR,
+	       WMI_SERVICE_VDEV_FILTER_NEIGHBOR, len);
 }
 
 #undef SVCMAP
@@ -7028,6 +7065,45 @@ struct wmi_pdev_chan_info_req_cmd {
 	__le32 reserved;
 } __packed;
 
+/* enum wmi_neighbor_rx_action - Neighbor Rx Packets add/remove filter */
+enum wmi_neighbor_rx_action {
+	WMI_NEIGHBOR_RX_ACTION_ADD = 1,
+	WMI_NEIGHBOR_RX_ACTION_DEL,
+};
+
+/* enum wmi_neighbor_rx_type - Neighbor Rx Packets ap/client addr */
+enum wmi_neighbor_rx_type {
+	WMI_NEIGHBOR_RX_TYPE_BSSID = 1,
+	WMI_NEIGHBOR_RX_TYPE_CLIENT,
+};
+
+/* enum wmi_neighbor_rx_capture_flag - Neighbor Rx Packets flags */
+enum wmi_neighbor_rx_capture_flag {
+	WMI_NEIGHBOR_RX_CAPTURE_ONLY_RX_PKT = 1,
+	WMI_NEIGHBOR_RX_CAPTURE_ONLY_TX_PKT,
+	WMI_NEIGHBOR_RX_CAPTURE_BOTH_TXRX_PKT
+};
+
+/* Filter for Neighbor Rx Packets  */
+struct wmi_set_vdev_filter_nrp_10_4_cmd {
+	__le32 vdev_id;
+
+	/* AP Bssid or Client Mac-addr */
+	struct wmi_mac_addr macaddr;
+
+	/* see enum wmi_neighbor_rx_action */
+	__le32 action;
+
+	/* see enum wmi_neighbor_rx_type */
+	__le32 type;
+
+	/* enum wmi_neighbor_rx_capture_flag */
+	__le32 flag;
+
+	/* BSSID index - index of the BSSID register */
+	__le32 idx;
+} __packed;
+
 struct ath10k;
 struct ath10k_vif;
 struct ath10k_fw_stats_pdev;
-- 
1.9.1
