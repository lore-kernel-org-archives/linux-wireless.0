Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:49124 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbaKIQuq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Nov 2014 11:50:46 -0500
Received: by mail-wi0-f172.google.com with SMTP id bs8so8317314wib.11
        for <linux-wireless@vger.kernel.org>; Sun, 09 Nov 2014 08:50:44 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 14/16] mac80211: add TDLS channel-switch Rx flow
Date: Sun,  9 Nov 2014 18:50:20 +0200
Message-Id: <1415551822-20121-14-git-send-email-arik@wizery.com> (sfid-20141109_175050_785099_02B65DB4)
In-Reply-To: <1415551822-20121-1-git-send-email-arik@wizery.com>
References: <1415551822-20121-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When receiving a TDLS channel switch request or response, parse the frame
and call a new tdls_recv_channel_switch op in the low level driver with
the parsed data.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 include/net/mac80211.h     |  37 ++++-
 net/mac80211/driver-ops.h  |  12 ++
 net/mac80211/ieee80211_i.h |   3 +
 net/mac80211/iface.c       |   2 +
 net/mac80211/main.c        |   3 +-
 net/mac80211/rx.c          |  21 +++
 net/mac80211/tdls.c        | 328 +++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/trace.h       |  45 +++++++
 8 files changed, 449 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index faef510..7dfcfe1 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1790,6 +1790,31 @@ struct ieee80211_scan_request {
 };
 
 /**
+ * struct ieee80211_tdls_ch_sw_params - TDLS channel switch parameters
+ *
+ * @sta: peer this TDLS channel-switch request/response came from
+ * @chandef: channel referenced in a TDLS channel-switch request
+ * @action_code: see &enum ieee80211_tdls_actioncode
+ * @status: channel-switch response status
+ * @timestamp: time at which the frame was received
+ * @switch_time: switch-timing parameter received in the frame
+ * @switch_timeout: switch-timing parameter received in the frame
+ * @tmpl_skb: TDLS switch-channel response template
+ * @ch_sw_tm_ie: offset of the channel-switch timing IE inside @tmpl_skb
+ */
+struct ieee80211_tdls_ch_sw_params {
+	struct ieee80211_sta *sta;
+	struct cfg80211_chan_def *chandef;
+	u8 action_code;
+	u32 status;
+	u32 timestamp;
+	u16 switch_time;
+	u16 switch_timeout;
+	struct sk_buff *tmpl_skb;
+	u32 ch_sw_tm_ie;
+};
+
+/**
  * wiphy_to_ieee80211_hw - return a mac80211 driver hw struct from a wiphy
  *
  * @wiphy: the &struct wiphy which we want to query
@@ -2888,6 +2913,13 @@ enum ieee80211_reconfig_type {
  *	optionally copy the skb for further re-use.
  * @tdls_cancel_channel_switch: Stop channel-switching with a TDLS peer. Both
  *	peers must be on the base channel when the call completes.
+ * @tdls_recv_channel_switch: a TDLS channel-switch related frame (request or
+ *	response) has been received from a remote peer. The driver gets
+ *	parameters parsed from the incoming frame and may use them to continue
+ *	an ongoing channel-switch operation. In addition, a channel-switch
+ *	response template is provided, together with the location of the
+ *	switch-timing IE within the template. The skb can only be used within
+ *	the function call.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw,
@@ -3104,10 +3136,13 @@ struct ieee80211_ops {
 				   struct ieee80211_vif *vif,
 				   struct ieee80211_sta *sta, u8 oper_class,
 				   struct cfg80211_chan_def *chandef,
-				   struct sk_buff *skb, u32 ch_sw_tm_ie);
+				   struct sk_buff *tmpl_skb, u32 ch_sw_tm_ie);
 	void (*tdls_cancel_channel_switch)(struct ieee80211_hw *hw,
 					   struct ieee80211_vif *vif,
 					   struct ieee80211_sta *sta);
+	void (*tdls_recv_channel_switch)(struct ieee80211_hw *hw,
+					 struct ieee80211_vif *vif,
+					 struct ieee80211_tdls_ch_sw_params *params);
 };
 
 /**
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index ec4ae42..ba0d2cb 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1337,4 +1337,16 @@ drv_tdls_cancel_channel_switch(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
+static inline void
+drv_tdls_recv_channel_switch(struct ieee80211_local *local,
+			     struct ieee80211_sub_if_data *sdata,
+			     struct ieee80211_tdls_ch_sw_params *params)
+{
+	trace_drv_tdls_recv_channel_switch(local, sdata, params);
+	if (local->ops->tdls_recv_channel_switch)
+		local->ops->tdls_recv_channel_switch(&local->hw, &sdata->vif,
+						     params);
+	trace_drv_return_void(local);
+}
+
 #endif /* __MAC80211_DRIVER_OPS */
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 2c7abc0..5de2e5f 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -993,6 +993,7 @@ enum sdata_queue_type {
 	IEEE80211_SDATA_QUEUE_AGG_STOP		= 2,
 	IEEE80211_SDATA_QUEUE_RX_AGG_START	= 3,
 	IEEE80211_SDATA_QUEUE_RX_AGG_STOP	= 4,
+	IEEE80211_SDATA_QUEUE_TDLS_CHSW		= 5,
 };
 
 enum {
@@ -2013,6 +2014,8 @@ int ieee80211_tdls_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 void ieee80211_tdls_cancel_channel_switch(struct wiphy *wiphy,
 					  struct net_device *dev,
 					  const u8 *addr);
+void ieee80211_process_tdls_channel_switch(struct ieee80211_sub_if_data *sdata,
+					   struct sk_buff *skb);
 
 extern const struct ethtool_ops ieee80211_ethtool_ops;
 
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 6b631c0..82473d9 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1202,6 +1202,8 @@ static void ieee80211_iface_work(struct work_struct *work)
 							WLAN_BACK_RECIPIENT, 0,
 							false);
 			mutex_unlock(&local->sta_mtx);
+		} else if (skb->pkt_type == IEEE80211_SDATA_QUEUE_TDLS_CHSW) {
+			ieee80211_process_tdls_channel_switch(sdata, skb);
 		} else if (ieee80211_is_action(mgmt->frame_control) &&
 			   mgmt->u.action.category == WLAN_CATEGORY_BACK) {
 			int len = skb->len;
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 774ccb2..6ab99da 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -766,7 +766,8 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 
 	if ((hw->wiphy->features & NL80211_FEATURE_TDLS_CHANNEL_SWITCH) &&
 	    (!local->ops->tdls_channel_switch ||
-	     !local->ops->tdls_cancel_channel_switch))
+	     !local->ops->tdls_cancel_channel_switch ||
+	     !local->ops->tdls_recv_channel_switch))
 		return -EOPNOTSUPP;
 
 #ifdef CONFIG_PM
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index bc63aa0..5bca571 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2257,6 +2257,27 @@ ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
 	if (!ieee80211_frame_allowed(rx, fc))
 		return RX_DROP_MONITOR;
 
+	/* directly handle TDLS channel switch requests/responses */
+	if (unlikely(((struct ethhdr *)rx->skb->data)->h_proto ==
+						cpu_to_be16(ETH_P_TDLS))) {
+		struct ieee80211_tdls_data *tf = (void *)rx->skb->data;
+
+		if (pskb_may_pull(rx->skb,
+				  offsetof(struct ieee80211_tdls_data, u)) &&
+		    tf->payload_type == WLAN_TDLS_SNAP_RFTYPE &&
+		    tf->category == WLAN_CATEGORY_TDLS &&
+		    (tf->action_code == WLAN_TDLS_CHANNEL_SWITCH_REQUEST ||
+		     tf->action_code == WLAN_TDLS_CHANNEL_SWITCH_RESPONSE)) {
+			rx->skb->pkt_type = IEEE80211_SDATA_QUEUE_TDLS_CHSW;
+			skb_queue_tail(&sdata->skb_queue, rx->skb);
+			ieee80211_queue_work(&rx->local->hw, &sdata->work);
+			if (rx->sta)
+				rx->sta->rx_packets++;
+
+			return RX_QUEUED;
+		}
+	}
+
 	if (rx->sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
 	    unlikely(port_control) && sdata->bss) {
 		sdata = container_of(sdata->bss, struct ieee80211_sub_if_data,
diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index 358f9a4..55ddd77 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -491,6 +491,20 @@ ieee80211_tdls_add_chan_switch_req_ies(struct ieee80211_sub_if_data *sdata,
 	}
 }
 
+static void
+ieee80211_tdls_add_chan_switch_resp_ies(struct ieee80211_sub_if_data *sdata,
+					struct sk_buff *skb, const u8 *peer,
+					u16 status_code, bool initiator,
+					const u8 *extra_ies,
+					size_t extra_ies_len)
+{
+	if (status_code == 0)
+		ieee80211_tdls_add_link_ie(sdata, skb, peer, initiator);
+
+	if (extra_ies_len)
+		memcpy(skb_put(skb, extra_ies_len), extra_ies, extra_ies_len);
+}
+
 static void ieee80211_tdls_add_ies(struct ieee80211_sub_if_data *sdata,
 				   struct sk_buff *skb, const u8 *peer,
 				   u8 action_code, u16 status_code,
@@ -529,6 +543,12 @@ static void ieee80211_tdls_add_ies(struct ieee80211_sub_if_data *sdata,
 						       extra_ies_len,
 						       oper_class, chandef);
 		break;
+	case WLAN_TDLS_CHANNEL_SWITCH_RESPONSE:
+		ieee80211_tdls_add_chan_switch_resp_ies(sdata, skb, peer,
+							status_code,
+							initiator, extra_ies,
+							extra_ies_len);
+		break;
 	}
 
 }
@@ -601,6 +621,13 @@ ieee80211_prep_tdls_encap_data(struct wiphy *wiphy, struct net_device *dev,
 
 		skb_put(skb, sizeof(tf->u.chan_switch_req));
 		break;
+	case WLAN_TDLS_CHANNEL_SWITCH_RESPONSE:
+		tf->category = WLAN_CATEGORY_TDLS;
+		tf->action_code = WLAN_TDLS_CHANNEL_SWITCH_RESPONSE;
+
+		skb_put(skb, sizeof(tf->u.chan_switch_resp));
+		tf->u.chan_switch_resp.status_code = cpu_to_le16(status_code);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -681,6 +708,7 @@ ieee80211_tdls_build_mgmt_packet_data(struct ieee80211_sub_if_data *sdata,
 	case WLAN_TDLS_TEARDOWN:
 	case WLAN_TDLS_DISCOVERY_REQUEST:
 	case WLAN_TDLS_CHANNEL_SWITCH_REQUEST:
+	case WLAN_TDLS_CHANNEL_SWITCH_RESPONSE:
 		ret = ieee80211_prep_tdls_encap_data(local->hw.wiphy,
 						     sdata->dev, peer,
 						     action_code, dialog_token,
@@ -755,6 +783,7 @@ ieee80211_tdls_prep_mgmt_packet(struct wiphy *wiphy, struct net_device *dev,
 		break;
 	case WLAN_TDLS_TEARDOWN:
 	case WLAN_TDLS_CHANNEL_SWITCH_REQUEST:
+	case WLAN_TDLS_CHANNEL_SWITCH_RESPONSE:
 		/* any value is ok */
 		break;
 	default:
@@ -1280,3 +1309,302 @@ ieee80211_tdls_cancel_channel_switch(struct wiphy *wiphy,
 out:
 	mutex_unlock(&local->sta_mtx);
 }
+
+static struct sk_buff *
+ieee80211_tdls_ch_sw_resp_tmpl_get(struct sta_info *sta,
+				   u32 *ch_sw_tm_ie_offset)
+{
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct sk_buff *skb;
+	u8 extra_ies[2 + sizeof(struct ieee80211_ch_switch_timing)];
+
+	/* initial timing are always zero in the template */
+	iee80211_tdls_add_ch_switch_timing(extra_ies, 0, 0);
+
+	skb = ieee80211_tdls_build_mgmt_packet_data(sdata, sta->sta.addr,
+					WLAN_TDLS_CHANNEL_SWITCH_RESPONSE,
+					0, 0, !sta->sta.tdls_initiator,
+					extra_ies, sizeof(extra_ies), 0, NULL);
+	if (!skb)
+		return NULL;
+
+	skb = ieee80211_build_data_template(sdata, skb, 0);
+	if (IS_ERR(skb)) {
+		tdls_dbg(sdata,
+			 "Failed building TDLS channel switch resp frame\n");
+		return NULL;
+	}
+
+	if (ch_sw_tm_ie_offset) {
+		const u8 *tm_ie = ieee80211_tdls_find_sw_timing_ie(skb);
+
+		if (!tm_ie) {
+			tdls_dbg(sdata,
+				 "No switch timing IE in TDLS switch resp\n");
+			dev_kfree_skb_any(skb);
+			return NULL;
+		}
+
+		*ch_sw_tm_ie_offset = tm_ie - skb->data;
+	}
+
+	tdls_dbg(sdata, "TDLS get channel switch response template for %pM\n",
+		 sta->sta.addr);
+	return skb;
+}
+
+static int
+ieee80211_process_tdls_channel_switch_resp(struct ieee80211_sub_if_data *sdata,
+					   struct sk_buff *skb)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee802_11_elems elems;
+	struct sta_info *sta;
+	struct ieee80211_tdls_data *tf = (void *)skb->data;
+	bool local_initiator;
+	struct ieee80211_rx_status *rx_status = IEEE80211_SKB_RXCB(skb);
+	int baselen = offsetof(typeof(*tf), u.chan_switch_resp.variable);
+	struct ieee80211_tdls_ch_sw_params params = {};
+	int ret;
+
+	params.action_code = WLAN_TDLS_CHANNEL_SWITCH_RESPONSE;
+	params.timestamp = rx_status->device_timestamp;
+
+	if (skb->len < baselen) {
+		tdls_dbg(sdata, "TDLS channel switch resp too short: %d\n",
+			 skb->len);
+		return -EINVAL;
+	}
+
+	mutex_lock(&local->sta_mtx);
+	sta = sta_info_get(sdata, tf->sa);
+	if (!sta || !test_sta_flag(sta, WLAN_STA_TDLS_PEER_AUTH)) {
+		tdls_dbg(sdata, "TDLS chan switch from non-peer sta %pM\n",
+			 tf->sa);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	params.sta = &sta->sta;
+	params.status = le16_to_cpu(tf->u.chan_switch_resp.status_code);
+	if (params.status != 0) {
+		ret = 0;
+		goto call_drv;
+	}
+
+	ieee802_11_parse_elems(tf->u.chan_switch_resp.variable,
+			       skb->len - baselen, false, &elems);
+	if (elems.parse_error) {
+		tdls_dbg(sdata, "Invalid IEs in TDLS channel switch resp\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (!elems.ch_sw_timing || !elems.lnk_id) {
+		tdls_dbg(sdata, "TDLS channel switch resp - missing IEs\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/* validate the initiator is set correctly */
+	local_initiator =
+		!memcmp(elems.lnk_id->init_sta, sdata->vif.addr, ETH_ALEN);
+	if (local_initiator == sta->sta.tdls_initiator) {
+		tdls_dbg(sdata, "TDLS chan switch invalid lnk-id initiator\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	params.switch_time = le16_to_cpu(elems.ch_sw_timing->switch_time);
+	params.switch_timeout = le16_to_cpu(elems.ch_sw_timing->switch_timeout);
+
+	params.tmpl_skb =
+		ieee80211_tdls_ch_sw_resp_tmpl_get(sta, &params.ch_sw_tm_ie);
+	if (!params.tmpl_skb) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+call_drv:
+	drv_tdls_recv_channel_switch(sdata->local, sdata, &params);
+
+	tdls_dbg(sdata,
+		 "TDLS channel switch response received from %pM status %d\n",
+		 tf->sa, params.status);
+
+out:
+	mutex_unlock(&local->sta_mtx);
+	dev_kfree_skb_any(params.tmpl_skb);
+	return ret;
+}
+
+static int
+ieee80211_process_tdls_channel_switch_req(struct ieee80211_sub_if_data *sdata,
+					  struct sk_buff *skb)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee802_11_elems elems;
+	struct cfg80211_chan_def chandef;
+	struct ieee80211_channel *chan;
+	enum nl80211_channel_type chan_type;
+	int freq;
+	u8 target_channel, oper_class;
+	bool local_initiator;
+	struct sta_info *sta;
+	enum ieee80211_band band;
+	struct ieee80211_tdls_data *tf = (void *)skb->data;
+	struct ieee80211_rx_status *rx_status = IEEE80211_SKB_RXCB(skb);
+	int baselen = offsetof(typeof(*tf), u.chan_switch_req.variable);
+	struct ieee80211_tdls_ch_sw_params params = {};
+	int ret = 0;
+
+	params.action_code = WLAN_TDLS_CHANNEL_SWITCH_REQUEST;
+	params.timestamp = rx_status->device_timestamp;
+
+	if (skb->len < baselen) {
+		tdls_dbg(sdata, "TDLS channel switch req too short: %d\n",
+			 skb->len);
+		return -EINVAL;
+	}
+
+	target_channel = tf->u.chan_switch_req.target_channel;
+	oper_class = tf->u.chan_switch_req.oper_class;
+
+	/*
+	 * We can't easily infer the channel band. The operating class is
+	 * ambiguous - there are multiple tables (US/Europe/JP/Global). The
+	 * solution here is to treat channels with number >14 as 5GHz ones,
+	 * and specifically check for the (oper_class, channel) combinations
+	 * where this doesn't hold. These are thankfully unique according to
+	 * IEEE802.11-2012.
+	 * We consider only the 2GHz and 5GHz bands and 20MHz+ channels as
+	 * valid here.
+	 */
+	if ((oper_class == 112 || oper_class == 2 || oper_class == 3 ||
+	     oper_class == 4 || oper_class == 5 || oper_class == 6) &&
+	     target_channel < 14)
+		band = IEEE80211_BAND_5GHZ;
+	else
+		band = target_channel < 14 ? IEEE80211_BAND_2GHZ :
+					     IEEE80211_BAND_5GHZ;
+
+	freq = ieee80211_channel_to_frequency(target_channel, band);
+	if (freq == 0) {
+		tdls_dbg(sdata, "Invalid channel in TDLS chan switch: %d\n",
+			 target_channel);
+		return -EINVAL;
+	}
+
+	chan = ieee80211_get_channel(sdata->local->hw.wiphy, freq);
+	if (!chan) {
+		tdls_dbg(sdata,
+			 "Unsupported channel for TDLS chan switch: %d\n",
+			 target_channel);
+		return -EINVAL;
+	}
+
+	ieee802_11_parse_elems(tf->u.chan_switch_req.variable,
+			       skb->len - baselen, false, &elems);
+	if (elems.parse_error) {
+		tdls_dbg(sdata, "Invalid IEs in TDLS channel switch req\n");
+		return -EINVAL;
+	}
+
+	if (!elems.ch_sw_timing || !elems.lnk_id) {
+		tdls_dbg(sdata, "TDLS channel switch req - missing IEs\n");
+		return -EINVAL;
+	}
+
+	mutex_lock(&local->sta_mtx);
+	sta = sta_info_get(sdata, tf->sa);
+	if (!sta || !test_sta_flag(sta, WLAN_STA_TDLS_PEER_AUTH)) {
+		tdls_dbg(sdata, "TDLS chan switch from non-peer sta %pM\n",
+			 tf->sa);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	params.sta = &sta->sta;
+
+	/* validate the initiator is set correctly */
+	local_initiator =
+		!memcmp(elems.lnk_id->init_sta, sdata->vif.addr, ETH_ALEN);
+	if (local_initiator == sta->sta.tdls_initiator) {
+		tdls_dbg(sdata, "TDLS chan switch invalid lnk-id initiator\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (!sta->sta.ht_cap.ht_supported) {
+		chan_type = NL80211_CHAN_NO_HT;
+	} else if (!elems.sec_chan_offs) {
+		chan_type = NL80211_CHAN_HT20;
+	} else {
+		switch (elems.sec_chan_offs->sec_chan_offs) {
+		case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
+			chan_type = NL80211_CHAN_HT40PLUS;
+			break;
+		case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
+			chan_type = NL80211_CHAN_HT40MINUS;
+			break;
+		default:
+			chan_type = NL80211_CHAN_HT20;
+			break;
+		}
+	}
+
+	cfg80211_chandef_create(&chandef, chan, chan_type);
+	params.chandef = &chandef;
+
+	params.switch_time = le16_to_cpu(elems.ch_sw_timing->switch_time);
+	params.switch_timeout = le16_to_cpu(elems.ch_sw_timing->switch_timeout);
+
+	params.tmpl_skb =
+		ieee80211_tdls_ch_sw_resp_tmpl_get(sta,
+						   &params.ch_sw_tm_ie);
+	if (!params.tmpl_skb) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	drv_tdls_recv_channel_switch(sdata->local, sdata, &params);
+
+	tdls_dbg(sdata,
+		 "TDLS ch switch request received from %pM ch %d width %d\n",
+		 tf->sa, params.chandef->chan->center_freq,
+		 params.chandef->width);
+out:
+	mutex_unlock(&local->sta_mtx);
+	dev_kfree_skb_any(params.tmpl_skb);
+	return ret;
+}
+
+void ieee80211_process_tdls_channel_switch(struct ieee80211_sub_if_data *sdata,
+					   struct sk_buff *skb)
+{
+	struct ieee80211_tdls_data *tf = (void *)skb->data;
+	struct wiphy *wiphy = sdata->local->hw.wiphy;
+
+	/* make sure the driver supports it */
+	if (!(wiphy->features & NL80211_FEATURE_TDLS_CHANNEL_SWITCH))
+		return;
+
+	/* we want to access the entire packet */
+	if (skb_linearize(skb))
+		return;
+	/*
+	 * The packet/size was already validated by mac80211 Rx path, only look
+	 * at the action type.
+	 */
+	switch (tf->action_code) {
+	case WLAN_TDLS_CHANNEL_SWITCH_REQUEST:
+		ieee80211_process_tdls_channel_switch_req(sdata, skb);
+		break;
+	case WLAN_TDLS_CHANNEL_SWITCH_RESPONSE:
+		ieee80211_process_tdls_channel_switch_resp(sdata, skb);
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return;
+	}
+}
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 12c5220..316f5cb 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -16,6 +16,7 @@
 
 #define STA_ENTRY	__array(char, sta_addr, ETH_ALEN)
 #define STA_ASSIGN	(sta ? memcpy(__entry->sta_addr, sta->addr, ETH_ALEN) : memset(__entry->sta_addr, 0, ETH_ALEN))
+#define STA_NAMED_ASSIGN(s)	memcpy(__entry->sta_addr, (s)->addr, ETH_ALEN)
 #define STA_PR_FMT	" sta:%pM"
 #define STA_PR_ARG	__entry->sta_addr
 
@@ -2252,6 +2253,50 @@ TRACE_EVENT(drv_tdls_cancel_channel_switch,
 	)
 );
 
+TRACE_EVENT(drv_tdls_recv_channel_switch,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 struct ieee80211_tdls_ch_sw_params *params),
+
+	TP_ARGS(local, sdata, params),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+		__field(u8, action_code)
+		STA_ENTRY
+		CHANDEF_ENTRY
+		__field(u32, status)
+		__field(bool, peer_initiator)
+		__field(u32, timestamp)
+		__field(u16, switch_time)
+		__field(u16, switch_timeout)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		STA_NAMED_ASSIGN(params->sta);
+		CHANDEF_ASSIGN(params->chandef)
+		__entry->peer_initiator = params->sta->tdls_initiator;
+		__entry->action_code = params->action_code;
+		__entry->status = params->status;
+		__entry->timestamp = params->timestamp;
+		__entry->switch_time = params->switch_time;
+		__entry->switch_timeout = params->switch_timeout;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT VIF_PR_FMT " received tdls channel switch packet"
+		" action:%d status:%d time:%d switch time:%d switch"
+		" timeout:%d initiator: %d chan:" CHANDEF_PR_FMT STA_PR_FMT,
+		LOCAL_PR_ARG, VIF_PR_ARG, __entry->action_code, __entry->status,
+		__entry->timestamp, __entry->switch_time,
+		__entry->switch_timeout, __entry->peer_initiator,
+		CHANDEF_PR_ARG, STA_PR_ARG
+	)
+);
+
 #ifdef CONFIG_MAC80211_MESSAGE_TRACING
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM mac80211_msg
-- 
1.9.1

