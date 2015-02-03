Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:55021 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323AbbBCKkc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2015 05:40:32 -0500
Received: by mail-wg0-f49.google.com with SMTP id k14so43769180wgh.8
        for <linux-wireless@vger.kernel.org>; Tue, 03 Feb 2015 02:40:31 -0800 (PST)
From: Marek Puzyniak <marek.puzyniak@tieto.com>
To: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Cc: Marek Puzyniak <marek.puzyniak@tieto.com>,
	Michal Kazior <michal.kazior@tieto.com>,
	Marek Kwaczynski <marek.kwaczynski@tieto.com>
Subject: [RFC 4/4] ath10k: introduce basic tdls functionality
Date: Tue,  3 Feb 2015 11:41:54 +0100
Message-Id: <1422960114-25137-5-git-send-email-marek.puzyniak@tieto.com> (sfid-20150203_114038_591426_9532F4F8)
In-Reply-To: <1422960114-25137-1-git-send-email-marek.puzyniak@tieto.com>
References: <1422960114-25137-1-git-send-email-marek.puzyniak@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds functions to enable/disable tdls
and to configure tdls peer station for tlv based firmware.
Tdls peer uapsd and tdls channel switching are not supported.
Transmitting tdls data frames works only for ethernet
type frames, that's why data addressed to tdls sta
is in ethernet format.

Tdls functionality for ath10k requires changes in mac80211
provided in patch:
mac80211: initialize rate control earlier for tdls station

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Marek Kwaczynski <marek.kwaczynski@tieto.com>
Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c     | 127 +++++++++++++++++++++++--
 drivers/net/wireless/ath/ath10k/wmi-ops.h |  42 +++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 151 ++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.h |  52 ++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h     |  37 ++++++++
 5 files changed, 403 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 7f0a594..3ef4d98 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -535,6 +535,72 @@ static void ath10k_peer_cleanup_all(struct ath10k *ar)
 	ar->num_stations = 0;
 }
 
+static int ath10k_enable_tdls(struct ath10k *ar, u32 vdev_id, bool enable)
+{
+	int ret;
+	enum wmi_tdls_state state = WMI_TDLS_DISABLE;
+
+	lockdep_assert_held(&ar->conf_mutex);
+
+	if (enable)
+		state = WMI_TDLS_ENABLE_ACTIVE;
+
+	ret = ath10k_wmi_update_fw_tdls_state(ar, vdev_id, state);
+	if (ret) {
+		ath10k_warn(ar, "failed to update fw tdls state on vdev %i: %i\n",
+			    vdev_id, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int ath10k_tdls_peer_update(struct ath10k *ar, u32 vdev_id,
+				   struct ieee80211_sta *sta,
+				   enum wmi_tdls_peer_state state)
+{
+	int ret;
+	struct wmi_tdls_peer_update_cmd_arg arg;
+	struct wmi_tdls_peer_capab_arg cap;
+	struct wmi_channel_arg chan_arg;
+	int i;
+
+	lockdep_assert_held(&ar->conf_mutex);
+
+	arg.vdev_id = vdev_id;
+	arg.peer_state = state;
+	ether_addr_copy(arg.addr, sta->addr);
+
+	cap.peer_max_sp = sta->max_sp;
+	cap.peer_uapsd_queues = sta->uapsd_queues;
+	cap.peer_curr_operclass = 0;
+	cap.self_curr_operclass = 0;
+	cap.peer_chan_len = 0;
+	cap.peer_operclass_len = 0;
+	cap.is_peer_responder = 0;
+	cap.buff_sta_support = 0;
+	cap.off_chan_support = 0;
+	cap.pref_offchan_num = 0;
+	cap.pref_offchan_bw = 0;
+
+	for (i = 0; i < WMI_TDLS_MAX_SUPP_OPER_CLASSES; i++)
+		cap.peer_operclass[i] = 0;
+
+	if (state == WMI_TDLS_PEER_STATE_CONNECTED) {
+		if (!sta->tdls_initiator)
+			cap.is_peer_responder = 1;
+	}
+
+	ret = ath10k_wmi_tdls_peer_update(ar, &arg, &cap, &chan_arg);
+	if (ret) {
+		ath10k_warn(ar, "failed to update tdls peer %pM on vdev %i: %i\n",
+			    arg.addr, vdev_id, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
 /************************/
 /* Interface management */
 /************************/
@@ -2463,7 +2529,7 @@ static u8 ath10k_tx_h_get_vdev_id(struct ath10k *ar, struct ieee80211_vif *vif)
 
 static enum ath10k_hw_txrx_mode
 ath10k_tx_h_get_txmode(struct ath10k *ar, struct ieee80211_vif *vif,
-		       struct sk_buff *skb)
+		       struct ieee80211_sta *sta, struct sk_buff *skb)
 {
 	const struct ieee80211_hdr *hdr = (void *)skb->data;
 	__le16 fc = hdr->frame_control;
@@ -2495,6 +2561,15 @@ ath10k_tx_h_get_txmode(struct ath10k *ar, struct ieee80211_vif *vif,
 	    !test_bit(ATH10K_FW_FEATURE_HAS_WMI_MGMT_TX, ar->fw_features))
 		return ATH10K_HW_TXRX_MGMT;
 
+	/* Workaround:
+	 *
+	 * Some wmi-tlv firmwares for qca6174 have broken Tx key selection for
+	 * NativeWifi txmode - it selects AP key instead of peer key. It seems
+	 * to work with Ethernet txmode so use it.
+	 */
+	if (ieee80211_is_data_present(fc) && sta && sta->tdls)
+		return ATH10K_HW_TXRX_ETHERNET;
+
 	return ATH10K_HW_TXRX_NATIVE_WIFI;
 }
 
@@ -3014,6 +3089,7 @@ static void ath10k_tx(struct ieee80211_hw *hw,
 	struct ath10k *ar = hw->priv;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_vif *vif = info->control.vif;
+	struct ieee80211_sta *sta = control->sta;
 	struct ieee80211_key_conf *key = info->control.hw_key;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	__le16 fc = hdr->frame_control;
@@ -3025,7 +3101,7 @@ static void ath10k_tx(struct ieee80211_hw *hw,
 	ATH10K_SKB_CB(skb)->htt.is_offchan = false;
 	ATH10K_SKB_CB(skb)->htt.tid = ath10k_tx_h_get_tid(hdr);
 	ATH10K_SKB_CB(skb)->vdev_id = ath10k_tx_h_get_vdev_id(ar, vif);
-	ATH10K_SKB_CB(skb)->txmode = ath10k_tx_h_get_txmode(ar, vif, skb);
+	ATH10K_SKB_CB(skb)->txmode = ath10k_tx_h_get_txmode(ar, vif, sta, skb);
 	ATH10K_SKB_CB(skb)->is_protected = ieee80211_has_protected(fc);
 
 	switch (ATH10K_SKB_CB(skb)->txmode) {
@@ -4429,6 +4505,8 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 		/*
 		 * New station addition.
 		 */
+		enum wmi_peer_type peer_type = WMI_PEER_TYPE_DEFAULT;
+
 		ath10k_dbg(ar, ATH10K_DBG_MAC,
 			   "mac vdev %d peer create %pM (new sta) sta %d / %d peer %d / %d\n",
 			   arvif->vdev_id, sta->addr,
@@ -4442,14 +4520,27 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 			goto exit;
 		}
 
+		if (sta->tdls) {
+			peer_type = WMI_PEER_TYPE_TDLS;
+			ath10k_enable_tdls(ar, arvif->vdev_id, true);
+		}
+
 		ret = ath10k_peer_create(ar, arvif->vdev_id, sta->addr,
-					 WMI_PEER_TYPE_DEFAULT);
+					 peer_type);
 		if (ret) {
 			ath10k_warn(ar, "failed to add peer %pM for vdev %d when adding a new sta: %i\n",
 				    sta->addr, arvif->vdev_id, ret);
 			ath10k_mac_dec_num_stations(arvif);
 			goto exit;
 		}
+
+		if (sta->tdls)
+			ret = ath10k_tdls_peer_update(ar, arvif->vdev_id, sta,
+						      WMI_TDLS_PEER_STATE_PEERING);
+		if (ret)
+			ath10k_warn(ar,
+				    "failed to update tdls peer %pM for vdev %d when adding a new sta: %i\n",
+				    sta->addr, arvif->vdev_id, ret);
 	} else if ((old_state == IEEE80211_STA_NONE &&
 		    new_state == IEEE80211_STA_NOTEXIST)) {
 		/*
@@ -4462,6 +4553,8 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 		if (ret)
 			ath10k_warn(ar, "failed to delete peer %pM for vdev %d: %i\n",
 				    sta->addr, arvif->vdev_id, ret);
+		if (sta->tdls)
+			ath10k_enable_tdls(ar, arvif->vdev_id, false);
 
 		ath10k_mac_dec_num_stations(arvif);
 	} else if (old_state == IEEE80211_STA_AUTH &&
@@ -4479,9 +4572,28 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 			ath10k_warn(ar, "failed to associate station %pM for vdev %i: %i\n",
 				    sta->addr, arvif->vdev_id, ret);
 	} else if (old_state == IEEE80211_STA_ASSOC &&
-		   new_state == IEEE80211_STA_AUTH &&
-		   (vif->type == NL80211_IFTYPE_AP ||
-		    vif->type == NL80211_IFTYPE_ADHOC)) {
+		   new_state == IEEE80211_STA_AUTHORIZED &&
+		   sta->tdls) {
+		/*
+		 * Tdls station authorized.
+		 */
+		ath10k_dbg(ar, ATH10K_DBG_MAC, "mac tdls sta %pM authorized\n",
+			   sta->addr);
+
+		ret = ath10k_station_assoc(ar, vif, sta, false);
+		if (ret)
+			ath10k_warn(ar, "failed to associate station %pM for vdev %i: %i\n",
+				    sta->addr, arvif->vdev_id, ret);
+
+		ret = ath10k_tdls_peer_update(ar, arvif->vdev_id, sta,
+					      WMI_TDLS_PEER_STATE_CONNECTED);
+		if (ret)
+			ath10k_warn(ar, "failed to update tdls peer %pM for vdev %i: %i\n",
+				    sta->addr, arvif->vdev_id, ret);
+	} else if (old_state == IEEE80211_STA_ASSOC &&
+		    new_state == IEEE80211_STA_AUTH &&
+		    (vif->type == NL80211_IFTYPE_AP ||
+		     vif->type == NL80211_IFTYPE_ADHOC)) {
 		/*
 		 * Disassociation.
 		 */
@@ -6208,6 +6320,9 @@ int ath10k_mac_register(struct ath10k *ar)
 			NL80211_PROBE_RESP_OFFLOAD_SUPPORT_P2P;
 	}
 
+	if (test_bit(WMI_SERVICE_TDLS, ar->wmi.svc_map))
+		ar->hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS;
+
 	ar->hw->wiphy->flags |= WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
 	ar->hw->wiphy->flags |= WIPHY_FLAG_HAS_CHANNEL_SWITCH;
 	ar->hw->wiphy->max_remain_on_channel_duration = 5000;
diff --git a/drivers/net/wireless/ath/ath10k/wmi-ops.h b/drivers/net/wireless/ath/ath10k/wmi-ops.h
index 16d2d7c..350ed07 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-ops.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-ops.h
@@ -148,6 +148,13 @@ struct wmi_ops {
 	struct sk_buff *(*gen_sta_keepalive)(struct ath10k *ar,
 					     const struct wmi_sta_keepalive_arg *arg);
 	struct sk_buff *(*gen_adaptive_qcs)(struct ath10k *ar, bool enable);
+	struct sk_buff *(*gen_update_fw_tdls_state)(struct ath10k *ar,
+						    u32 vdev_id,
+						    enum wmi_tdls_state state);
+	struct sk_buff *(*gen_tdls_peer_update)(struct ath10k *ar,
+						struct wmi_tdls_peer_update_cmd_arg *arg,
+						struct wmi_tdls_peer_capab_arg *cap,
+						struct wmi_channel_arg *chan);
 };
 
 int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb, u32 cmd_id);
@@ -1083,4 +1090,39 @@ ath10k_wmi_adaptive_qcs(struct ath10k *ar, bool enable)
 	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->adaptive_qcs_cmdid);
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
+			    struct wmi_tdls_peer_update_cmd_arg *arg,
+			    struct wmi_tdls_peer_capab_arg *cap,
+			    struct wmi_channel_arg *chan)
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
index 16b0e6b..0d74e22 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -2713,6 +2713,153 @@ ath10k_wmi_tlv_op_gen_adaptive_qcs(struct ath10k *ar, bool enable)
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
+	 * for now none of then are enabled.
+	 */
+	u32 options = 0;
+
+	len = sizeof(*tlv) + sizeof(*cmd);
+	skb = ath10k_wmi_alloc_skb(ar, sizeof(*tlv) + sizeof(*cmd));
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
+	peer_qos |= (sp << WMI_TLV_TDLS_PEER_SP_POS);
+
+	return peer_qos;
+}
+
+static struct sk_buff *
+ath10k_wmi_tlv_op_gen_tdls_peer_update(struct ath10k *ar,
+				       struct wmi_tdls_peer_update_cmd_arg *arg,
+				       struct wmi_tdls_peer_capab_arg *cap,
+				       struct wmi_channel_arg *chan_arg)
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
@@ -2838,6 +2985,8 @@ static struct wmi_cmd_map wmi_tlv_cmd_map = {
 	.pdev_get_temperature_cmdid = WMI_TLV_CMD_UNSUPPORTED,
 	.vdev_set_wmm_params_cmdid = WMI_TLV_VDEV_SET_WMM_PARAMS_CMDID,
 	.adaptive_qcs_cmdid = WMI_TLV_RESMGR_ADAPTIVE_OCS_CMDID,
+	.tdls_set_state_cmdid = WMI_TLV_TDLS_SET_STATE_CMDID,
+	.tdls_peer_update_cmdid = WMI_TLV_TDLS_PEER_UPDATE_CMDID,
 };
 
 static struct wmi_pdev_param_map wmi_tlv_pdev_param_map = {
@@ -3012,6 +3161,8 @@ static const struct wmi_ops wmi_tlv_ops = {
 	.gen_vdev_sta_uapsd = ath10k_wmi_tlv_op_gen_vdev_sta_uapsd,
 	.gen_sta_keepalive = ath10k_wmi_tlv_op_gen_sta_keepalive,
 	.gen_adaptive_qcs = ath10k_wmi_tlv_op_gen_adaptive_qcs,
+	.gen_update_fw_tdls_state = ath10k_wmi_tlv_op_gen_update_fw_tdls_state,
+	.gen_tdls_peer_update = ath10k_wmi_tlv_op_gen_tdls_peer_update,
 };
 
 /************/
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.h b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
index 5f0fe84..8c219f0 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
@@ -1516,6 +1516,58 @@ struct wmi_tlv_p2p_noa_ev {
 	__le32 vdev_id;
 } __packed;
 
+/* TDLS Options */
+enum wmi_tlv_tdls_options {
+	WMI_TLV_TDLS_OFFCHAN_EN = BIT(0), /* TDLS Off Channel support */
+	WMI_TLV_TDLS_BUFFER_STA_EN = BIT(1), /* TDLS Buffer STA support */
+	WMI_TLV_TDLS_SLEEP_STA_EN = BIT(2), /* TDLS Sleep STA support */
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
+#define WMI_TLV_TDLS_PEER_SP_POS 5
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
index 01cdb8b..ff0fb20 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -553,6 +553,8 @@ struct wmi_cmd_map {
 	u32 pdev_get_temperature_cmdid;
 	u32 vdev_set_wmm_params_cmdid;
 	u32 adaptive_qcs_cmdid;
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
+} __packed;
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
+} __packed;
+
 struct ath10k;
 struct ath10k_vif;
 struct ath10k_fw_stats_pdev;
-- 
2.1.4

