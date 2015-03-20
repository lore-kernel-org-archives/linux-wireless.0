Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:33859 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbbCTLAy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2015 07:00:54 -0400
Received: by lbbsy1 with SMTP id sy1so72590684lbb.1
        for <linux-wireless@vger.kernel.org>; Fri, 20 Mar 2015 04:00:53 -0700 (PDT)
From: Marek Puzyniak <marek.puzyniak@tieto.com>
To: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Cc: Marek Puzyniak <marek.puzyniak@tieto.com>
Subject: [PATCH v4 5/6] ath10k: add wmi support for tdls
Date: Fri, 20 Mar 2015 12:02:58 +0100
Message-Id: <1426849379-7562-6-git-send-email-marek.puzyniak@tieto.com> (sfid-20150320_120058_207030_B9FEC1BC)
In-Reply-To: <1426849379-7562-1-git-send-email-marek.puzyniak@tieto.com>
References: <1426849379-7562-1-git-send-email-marek.puzyniak@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As a part of tdls implementation introduce
tdls related wmi data structures, constant
values and functions.

Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wmi-ops.h |  42 ++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 153 ++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.h |  53 +++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h     |  37 ++++++++
 4 files changed, 285 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-ops.h b/drivers/net/wireless/ath/ath10k/wmi-ops.h
index 28d042c..1e444a0 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-ops.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-ops.h
@@ -151,6 +151,13 @@ struct wmi_ops {
 					      u32 num_ac);
 	struct sk_buff *(*gen_sta_keepalive)(struct ath10k *ar,
 					     const struct wmi_sta_keepalive_arg *arg);
+	struct sk_buff *(*gen_update_fw_tdls_state)(struct ath10k *ar,
+						    u32 vdev_id,
+						    enum wmi_tdls_state state);
+	struct sk_buff *(*gen_tdls_peer_update)(struct ath10k *ar,
+						const struct wmi_tdls_peer_update_cmd_arg *arg,
+						const struct wmi_tdls_peer_capab_arg *cap,
+						const struct wmi_channel_arg *chan);
 };
 
 int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb, u32 cmd_id);
@@ -1074,4 +1081,39 @@ ath10k_wmi_sta_keepalive(struct ath10k *ar,
 	return ath10k_wmi_cmd_send(ar, skb, cmd_id);
 }
 
+static inline int
+ath10k_wmi_update_fw_tdls_state(struct ath10k *ar, u32 vdev_id,
+				enum wmi_tdls_state state)
+{
+	struct sk_buff *skb;
+
+	if (!ar->wmi.ops->gen_update_fw_tdls_state)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_update_fw_tdls_state(ar, vdev_id, state);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->tdls_set_state_cmdid);
+}
+
+static inline int
+ath10k_wmi_tdls_peer_update(struct ath10k *ar,
+			    const struct wmi_tdls_peer_update_cmd_arg *arg,
+			    const struct wmi_tdls_peer_capab_arg *cap,
+			    const struct wmi_channel_arg *chan)
+{
+	struct sk_buff *skb;
+
+	if (!ar->wmi.ops->gen_tdls_peer_update)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_tdls_peer_update(ar, arg, cap, chan);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	return ath10k_wmi_cmd_send(ar, skb,
+				   ar->wmi.cmd->tdls_peer_update_cmdid);
+}
+
 #endif
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 80e882b..7b62f0d 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -2564,6 +2564,155 @@ ath10k_wmi_tlv_op_gen_p2p_go_bcn_ie(struct ath10k *ar, u32 vdev_id,
 	return skb;
 }
 
+static struct sk_buff *
+ath10k_wmi_tlv_op_gen_update_fw_tdls_state(struct ath10k *ar, u32 vdev_id,
+					   enum wmi_tdls_state state)
+{
+	struct wmi_tdls_set_state_cmd *cmd;
+	struct wmi_tlv *tlv;
+	struct sk_buff *skb;
+	void *ptr;
+	size_t len;
+	/* Set to options from wmi_tlv_tdls_options,
+	 * for now none of them are enabled.
+	 */
+	u32 options = 0;
+
+	len = sizeof(*tlv) + sizeof(*cmd);
+	skb = ath10k_wmi_alloc_skb(ar, len);
+	if (!skb)
+		return ERR_PTR(-ENOMEM);
+
+	ptr = (void *)skb->data;
+	tlv = ptr;
+	tlv->tag = __cpu_to_le16(WMI_TLV_TAG_STRUCT_TDLS_SET_STATE_CMD);
+	tlv->len = __cpu_to_le16(sizeof(*cmd));
+
+	cmd = (void *)tlv->value;
+	cmd->vdev_id = __cpu_to_le32(vdev_id);
+	cmd->state = __cpu_to_le32(state);
+	cmd->notification_interval_ms = __cpu_to_le32(5000);
+	cmd->tx_discovery_threshold = __cpu_to_le32(100);
+	cmd->tx_teardown_threshold = __cpu_to_le32(5);
+	cmd->rssi_teardown_threshold = __cpu_to_le32(-75);
+	cmd->rssi_delta = __cpu_to_le32(-20);
+	cmd->tdls_options = __cpu_to_le32(options);
+	cmd->tdls_peer_traffic_ind_window = __cpu_to_le32(2);
+	cmd->tdls_peer_traffic_response_timeout_ms = __cpu_to_le32(5000);
+	cmd->tdls_puapsd_mask = __cpu_to_le32(0xf);
+	cmd->tdls_puapsd_inactivity_time_ms = __cpu_to_le32(0);
+	cmd->tdls_puapsd_rx_frame_threshold = __cpu_to_le32(10);
+
+	ptr += sizeof(*tlv);
+	ptr += sizeof(*cmd);
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi tlv update fw tdls state %d for vdev %i\n",
+		   state, vdev_id);
+	return skb;
+}
+
+static u32 ath10k_wmi_tlv_prepare_peer_qos(u8 uapsd_queues, u8 sp)
+{
+	u32 peer_qos = 0;
+
+	if (uapsd_queues & IEEE80211_WMM_IE_STA_QOSINFO_AC_VO)
+		peer_qos |= WMI_TLV_TDLS_PEER_QOS_AC_VO;
+	if (uapsd_queues & IEEE80211_WMM_IE_STA_QOSINFO_AC_VI)
+		peer_qos |= WMI_TLV_TDLS_PEER_QOS_AC_VI;
+	if (uapsd_queues & IEEE80211_WMM_IE_STA_QOSINFO_AC_BK)
+		peer_qos |= WMI_TLV_TDLS_PEER_QOS_AC_BK;
+	if (uapsd_queues & IEEE80211_WMM_IE_STA_QOSINFO_AC_BE)
+		peer_qos |= WMI_TLV_TDLS_PEER_QOS_AC_BE;
+
+	peer_qos |= SM(sp, WMI_TLV_TDLS_PEER_SP);
+
+	return peer_qos;
+}
+
+static struct sk_buff *
+ath10k_wmi_tlv_op_gen_tdls_peer_update(struct ath10k *ar,
+				       const struct wmi_tdls_peer_update_cmd_arg *arg,
+				       const struct wmi_tdls_peer_capab_arg *cap,
+				       const struct wmi_channel_arg *chan_arg)
+{
+	struct wmi_tdls_peer_update_cmd *cmd;
+	struct wmi_tdls_peer_capab *peer_cap;
+	struct wmi_channel *chan;
+	struct wmi_tlv *tlv;
+	struct sk_buff *skb;
+	u32 peer_qos;
+	void *ptr;
+	int len;
+	int i;
+
+	len = sizeof(*tlv) + sizeof(*cmd) +
+	      sizeof(*tlv) + sizeof(*peer_cap) +
+	      sizeof(*tlv) + cap->peer_chan_len * sizeof(*chan);
+
+	skb = ath10k_wmi_alloc_skb(ar, len);
+	if (!skb)
+		return ERR_PTR(-ENOMEM);
+
+	ptr = (void *)skb->data;
+	tlv = ptr;
+	tlv->tag = __cpu_to_le16(WMI_TLV_TAG_STRUCT_TDLS_PEER_UPDATE_CMD);
+	tlv->len = __cpu_to_le16(sizeof(*cmd));
+
+	cmd = (void *)tlv->value;
+	cmd->vdev_id = __cpu_to_le32(arg->vdev_id);
+	ether_addr_copy(cmd->peer_macaddr.addr, arg->addr);
+	cmd->peer_state = __cpu_to_le32(arg->peer_state);
+
+	ptr += sizeof(*tlv);
+	ptr += sizeof(*cmd);
+
+	tlv = ptr;
+	tlv->tag = __cpu_to_le16(WMI_TLV_TAG_STRUCT_TDLS_PEER_CAPABILITIES);
+	tlv->len = __cpu_to_le16(sizeof(*peer_cap));
+	peer_cap = (void *)tlv->value;
+	peer_qos = ath10k_wmi_tlv_prepare_peer_qos(cap->peer_uapsd_queues,
+						   cap->peer_max_sp);
+	peer_cap->peer_qos = __cpu_to_le32(peer_qos);
+	peer_cap->buff_sta_support = __cpu_to_le32(cap->buff_sta_support);
+	peer_cap->off_chan_support = __cpu_to_le32(cap->off_chan_support);
+	peer_cap->peer_curr_operclass = __cpu_to_le32(cap->peer_curr_operclass);
+	peer_cap->self_curr_operclass = __cpu_to_le32(cap->self_curr_operclass);
+	peer_cap->peer_chan_len = __cpu_to_le32(cap->peer_chan_len);
+	peer_cap->peer_operclass_len = __cpu_to_le32(cap->peer_operclass_len);
+
+	for (i = 0; i < WMI_TDLS_MAX_SUPP_OPER_CLASSES; i++)
+		peer_cap->peer_operclass[i] = cap->peer_operclass[i];
+
+	peer_cap->is_peer_responder = __cpu_to_le32(cap->is_peer_responder);
+	peer_cap->pref_offchan_num = __cpu_to_le32(cap->pref_offchan_num);
+	peer_cap->pref_offchan_bw = __cpu_to_le32(cap->pref_offchan_bw);
+
+	ptr += sizeof(*tlv);
+	ptr += sizeof(*peer_cap);
+
+	tlv = ptr;
+	tlv->tag = __cpu_to_le16(WMI_TLV_TAG_ARRAY_STRUCT);
+	tlv->len = __cpu_to_le16(cap->peer_chan_len * sizeof(*chan));
+
+	ptr += sizeof(*tlv);
+
+	for (i = 0; i < cap->peer_chan_len; i++) {
+		tlv = ptr;
+		tlv->tag = __cpu_to_le16(WMI_TLV_TAG_STRUCT_CHANNEL);
+		tlv->len = __cpu_to_le16(sizeof(*chan));
+		chan = (void *)tlv->value;
+		ath10k_wmi_put_wmi_channel(chan, &chan_arg[i]);
+
+		ptr += sizeof(*tlv);
+		ptr += sizeof(*chan);
+	}
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI,
+		   "wmi tlv tdls peer update vdev %i state %d n_chans %u\n",
+		   arg->vdev_id, arg->peer_state, cap->peer_chan_len);
+	return skb;
+}
+
 /****************/
 /* TLV mappings */
 /****************/
@@ -2688,6 +2837,8 @@ static struct wmi_cmd_map wmi_tlv_cmd_map = {
 	.gpio_output_cmdid = WMI_TLV_GPIO_OUTPUT_CMDID,
 	.pdev_get_temperature_cmdid = WMI_TLV_CMD_UNSUPPORTED,
 	.vdev_set_wmm_params_cmdid = WMI_TLV_VDEV_SET_WMM_PARAMS_CMDID,
+	.tdls_set_state_cmdid = WMI_TLV_TDLS_SET_STATE_CMDID,
+	.tdls_peer_update_cmdid = WMI_TLV_TDLS_PEER_UPDATE_CMDID,
 };
 
 static struct wmi_pdev_param_map wmi_tlv_pdev_param_map = {
@@ -2861,6 +3012,8 @@ static const struct wmi_ops wmi_tlv_ops = {
 	.gen_p2p_go_bcn_ie = ath10k_wmi_tlv_op_gen_p2p_go_bcn_ie,
 	.gen_vdev_sta_uapsd = ath10k_wmi_tlv_op_gen_vdev_sta_uapsd,
 	.gen_sta_keepalive = ath10k_wmi_tlv_op_gen_sta_keepalive,
+	.gen_update_fw_tdls_state = ath10k_wmi_tlv_op_gen_update_fw_tdls_state,
+	.gen_tdls_peer_update = ath10k_wmi_tlv_op_gen_tdls_peer_update,
 };
 
 /************/
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.h b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
index 06b37b2..03e2584 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
@@ -1464,6 +1464,59 @@ struct wmi_tlv_roam_ev {
 	__le32 rssi;
 } __packed;
 
+/* TDLS Options */
+enum wmi_tlv_tdls_options {
+	WMI_TLV_TDLS_OFFCHAN_EN = BIT(0),
+	WMI_TLV_TDLS_BUFFER_STA_EN = BIT(1),
+	WMI_TLV_TDLS_SLEEP_STA_EN = BIT(2),
+};
+
+struct wmi_tdls_set_state_cmd {
+	__le32 vdev_id;
+	__le32 state;
+	__le32 notification_interval_ms;
+	__le32 tx_discovery_threshold;
+	__le32 tx_teardown_threshold;
+	__le32 rssi_teardown_threshold;
+	__le32 rssi_delta;
+	__le32 tdls_options;
+	__le32 tdls_peer_traffic_ind_window;
+	__le32 tdls_peer_traffic_response_timeout_ms;
+	__le32 tdls_puapsd_mask;
+	__le32 tdls_puapsd_inactivity_time_ms;
+	__le32 tdls_puapsd_rx_frame_threshold;
+} __packed;
+
+struct wmi_tdls_peer_update_cmd {
+	__le32 vdev_id;
+	struct wmi_mac_addr peer_macaddr;
+	__le32 peer_state;
+} __packed;
+
+enum {
+	WMI_TLV_TDLS_PEER_QOS_AC_VO = BIT(0),
+	WMI_TLV_TDLS_PEER_QOS_AC_VI = BIT(1),
+	WMI_TLV_TDLS_PEER_QOS_AC_BK = BIT(2),
+	WMI_TLV_TDLS_PEER_QOS_AC_BE = BIT(3),
+};
+
+#define WMI_TLV_TDLS_PEER_SP_MASK	0x60
+#define WMI_TLV_TDLS_PEER_SP_LSB	5
+
+struct wmi_tdls_peer_capab {
+	__le32 peer_qos;
+	__le32 buff_sta_support;
+	__le32 off_chan_support;
+	__le32 peer_curr_operclass;
+	__le32 self_curr_operclass;
+	__le32 peer_chan_len;
+	__le32 peer_operclass_len;
+	u8 peer_operclass[WMI_TDLS_MAX_SUPP_OPER_CLASSES];
+	__le32 is_peer_responder;
+	__le32 pref_offchan_num;
+	__le32 pref_offchan_bw;
+} __packed;
+
 void ath10k_wmi_tlv_attach(struct ath10k *ar);
 
 #endif
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 3dddd47..f25ce03 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -552,6 +552,8 @@ struct wmi_cmd_map {
 	u32 gpio_output_cmdid;
 	u32 pdev_get_temperature_cmdid;
 	u32 vdev_set_wmm_params_cmdid;
+	u32 tdls_set_state_cmdid;
+	u32 tdls_peer_update_cmdid;
 };
 
 /*
@@ -4890,6 +4892,41 @@ struct wmi_pdev_temperature_event {
 	__le32 temperature;
 } __packed;
 
+enum wmi_tdls_state {
+	WMI_TDLS_DISABLE,
+	WMI_TDLS_ENABLE_PASSIVE,
+	WMI_TDLS_ENABLE_ACTIVE,
+};
+
+enum wmi_tdls_peer_state {
+	WMI_TDLS_PEER_STATE_PEERING,
+	WMI_TDLS_PEER_STATE_CONNECTED,
+	WMI_TDLS_PEER_STATE_TEARDOWN,
+};
+
+struct wmi_tdls_peer_update_cmd_arg {
+	u32 vdev_id;
+	enum wmi_tdls_peer_state peer_state;
+	u8 addr[ETH_ALEN];
+};
+
+#define WMI_TDLS_MAX_SUPP_OPER_CLASSES 32
+
+struct wmi_tdls_peer_capab_arg {
+	u8 peer_uapsd_queues;
+	u8 peer_max_sp;
+	u32 buff_sta_support;
+	u32 off_chan_support;
+	u32 peer_curr_operclass;
+	u32 self_curr_operclass;
+	u32 peer_chan_len;
+	u32 peer_operclass_len;
+	u8 peer_operclass[WMI_TDLS_MAX_SUPP_OPER_CLASSES];
+	u32 is_peer_responder;
+	u32 pref_offchan_num;
+	u32 pref_offchan_bw;
+};
+
 struct ath10k;
 struct ath10k_vif;
 struct ath10k_fw_stats_pdev;
-- 
2.1.4

