Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63313 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbaKIQuo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Nov 2014 11:50:44 -0500
Received: by mail-wg0-f44.google.com with SMTP id x12so7156522wgg.3
        for <linux-wireless@vger.kernel.org>; Sun, 09 Nov 2014 08:50:43 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 13/16] mac80211: introduce TDLS channel switch ops
Date: Sun,  9 Nov 2014 18:50:19 +0200
Message-Id: <1415551822-20121-13-git-send-email-arik@wizery.com> (sfid-20141109_181321_317149_97EDBCFE)
In-Reply-To: <1415551822-20121-1-git-send-email-arik@wizery.com>
References: <1415551822-20121-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Implement the cfg80211 TDLS channel switch ops and introduce new mac80211
ones for low-level drivers.
Verify low-level driver support for the new ops when using the relevant
wiphy feature bit. Also verify the peer supports channel switching before
passing the command down.

Add a new STA flag to track the off-channel state with the TDLS peer and
make sure to cancel the channel-switch if the peer STA is unexpectedly
removed.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 include/net/mac80211.h     |  19 ++++
 net/mac80211/cfg.c         |   2 +
 net/mac80211/debugfs_sta.c |  10 +-
 net/mac80211/driver-ops.h  |  41 ++++++++
 net/mac80211/ieee80211_i.h |   6 ++
 net/mac80211/main.c        |   5 +
 net/mac80211/sta_info.c    |   9 ++
 net/mac80211/sta_info.h    |   3 +
 net/mac80211/tdls.c        | 234 +++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/trace.h       |  57 +++++++++++
 10 files changed, 381 insertions(+), 5 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 5f203a6..faef510 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2878,6 +2878,16 @@ enum ieee80211_reconfig_type {
  *
  * @get_txpower: get current maximum tx power (in dBm) based on configuration
  *	and hardware limits.
+ *
+ * @tdls_channel_switch: Start channel-switching with a TDLS peer. The driver
+ *	is responsible for continually initiating channel-switching operations
+ *	and returning to the base channel for communication with the AP. The
+ *	driver receives a channel-switch request template and the location of
+ *	the switch-timing IE within the template as part of the invocation.
+ *	The template is valid only within the call, and the driver can
+ *	optionally copy the skb for further re-use.
+ * @tdls_cancel_channel_switch: Stop channel-switching with a TDLS peer. Both
+ *	peers must be on the base channel when the call completes.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw,
@@ -3089,6 +3099,15 @@ struct ieee80211_ops {
 	u32 (*get_expected_throughput)(struct ieee80211_sta *sta);
 	int (*get_txpower)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			   int *dbm);
+
+	int (*tdls_channel_switch)(struct ieee80211_hw *hw,
+				   struct ieee80211_vif *vif,
+				   struct ieee80211_sta *sta, u8 oper_class,
+				   struct cfg80211_chan_def *chandef,
+				   struct sk_buff *skb, u32 ch_sw_tm_ie);
+	void (*tdls_cancel_channel_switch)(struct ieee80211_hw *hw,
+					   struct ieee80211_vif *vif,
+					   struct ieee80211_sta *sta);
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 257edd2..5f99827 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3749,6 +3749,8 @@ const struct cfg80211_ops mac80211_config_ops = {
 	.set_rekey_data = ieee80211_set_rekey_data,
 	.tdls_oper = ieee80211_tdls_oper,
 	.tdls_mgmt = ieee80211_tdls_mgmt,
+	.tdls_channel_switch = ieee80211_tdls_channel_switch,
+	.tdls_cancel_channel_switch = ieee80211_tdls_cancel_channel_switch,
 	.probe_client = ieee80211_probe_client,
 	.set_noack_map = ieee80211_set_noack_map,
 #ifdef CONFIG_PM
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 2ba7f53..94c7009 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -74,7 +74,7 @@ static ssize_t sta_flags_read(struct file *file, char __user *userbuf,
 	test_sta_flag(sta, WLAN_STA_##flg) ? #flg "\n" : ""
 
 	int res = scnprintf(buf, sizeof(buf),
-			    "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
+			    "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
 			    TEST(AUTH), TEST(ASSOC), TEST(PS_STA),
 			    TEST(PS_DRIVER), TEST(AUTHORIZED),
 			    TEST(SHORT_PREAMBLE),
@@ -83,10 +83,10 @@ static ssize_t sta_flags_read(struct file *file, char __user *userbuf,
 			    TEST(MFP), TEST(BLOCK_BA), TEST(PSPOLL),
 			    TEST(UAPSD), TEST(SP), TEST(TDLS_PEER),
 			    TEST(TDLS_PEER_AUTH), TEST(TDLS_INITIATOR),
-			    TEST(TDLS_CHAN_SWITCH), TEST(4ADDR_EVENT),
-			    TEST(INSERTED), TEST(RATE_CONTROL),
-			    TEST(TOFFSET_KNOWN), TEST(MPSP_OWNER),
-			    TEST(MPSP_RECIPIENT));
+			    TEST(TDLS_CHAN_SWITCH), TEST(TDLS_OFF_CHANNEL),
+			    TEST(4ADDR_EVENT), TEST(INSERTED),
+			    TEST(RATE_CONTROL), TEST(TOFFSET_KNOWN),
+			    TEST(MPSP_OWNER), TEST(MPSP_RECIPIENT));
 #undef TEST
 	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
 }
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 9759dd1..ec4ae42 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1296,4 +1296,45 @@ static inline int drv_get_txpower(struct ieee80211_local *local,
 	return ret;
 }
 
+static inline int
+drv_tdls_channel_switch(struct ieee80211_local *local,
+			struct ieee80211_sub_if_data *sdata,
+			struct ieee80211_sta *sta, u8 oper_class,
+			struct cfg80211_chan_def *chandef,
+			struct sk_buff *tmpl_skb, u32 ch_sw_tm_ie)
+{
+	int ret;
+
+	might_sleep();
+	if (!check_sdata_in_driver(sdata))
+		return -EIO;
+
+	if (!local->ops->tdls_channel_switch)
+		return -EOPNOTSUPP;
+
+	trace_drv_tdls_channel_switch(local, sdata, sta, oper_class, chandef);
+	ret = local->ops->tdls_channel_switch(&local->hw, &sdata->vif, sta,
+					      oper_class, chandef, tmpl_skb,
+					      ch_sw_tm_ie);
+	trace_drv_return_int(local, ret);
+	return ret;
+}
+
+static inline void
+drv_tdls_cancel_channel_switch(struct ieee80211_local *local,
+			       struct ieee80211_sub_if_data *sdata,
+			       struct ieee80211_sta *sta)
+{
+	might_sleep();
+	if (!check_sdata_in_driver(sdata))
+		return;
+
+	if (!local->ops->tdls_cancel_channel_switch)
+		return;
+
+	trace_drv_tdls_cancel_channel_switch(local, sdata, sta);
+	local->ops->tdls_cancel_channel_switch(&local->hw, &sdata->vif, sta);
+	trace_drv_return_void(local);
+}
+
 #endif /* __MAC80211_DRIVER_OPS */
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index e786ab6..2c7abc0 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2007,6 +2007,12 @@ int ieee80211_tdls_mgmt(struct wiphy *wiphy, struct net_device *dev,
 int ieee80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 			const u8 *peer, enum nl80211_tdls_operation oper);
 void ieee80211_tdls_peer_del_work(struct work_struct *wk);
+int ieee80211_tdls_channel_switch(struct wiphy *wiphy, struct net_device *dev,
+				  const u8 *addr, u8 oper_class,
+				  struct cfg80211_chan_def *chandef);
+void ieee80211_tdls_cancel_channel_switch(struct wiphy *wiphy,
+					  struct net_device *dev,
+					  const u8 *addr);
 
 extern const struct ethtool_ops ieee80211_ethtool_ops;
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 282a4f3..774ccb2 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -764,6 +764,11 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	     local->hw.offchannel_tx_hw_queue >= local->hw.queues))
 		return -EINVAL;
 
+	if ((hw->wiphy->features & NL80211_FEATURE_TDLS_CHANNEL_SWITCH) &&
+	    (!local->ops->tdls_channel_switch ||
+	     !local->ops->tdls_cancel_channel_switch))
+		return -EOPNOTSUPP;
+
 #ifdef CONFIG_PM
 	if (hw->wiphy->wowlan && (!local->ops->suspend || !local->ops->resume))
 		return -EINVAL;
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 9737251..86ca627 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -847,6 +847,15 @@ static int __must_check __sta_info_destroy_part1(struct sta_info *sta)
 	if (WARN_ON(ret))
 		return ret;
 
+	/*
+	 * for TDLS peers, make sure to return to the base channel before
+	 * removal.
+	 */
+	if (test_sta_flag(sta, WLAN_STA_TDLS_OFF_CHANNEL)) {
+		drv_tdls_cancel_channel_switch(local, sdata, &sta->sta);
+		clear_sta_flag(sta, WLAN_STA_TDLS_OFF_CHANNEL);
+	}
+
 	list_del_rcu(&sta->list);
 
 	drv_sta_pre_rcu_remove(local, sta->sdata, sta);
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index b6702c8..00f56eb 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -50,6 +50,8 @@
  * @WLAN_STA_TDLS_INITIATOR: We are the initiator of the TDLS link with this
  *	station.
  * @WLAN_STA_TDLS_CHAN_SWITCH: This TDLS peer supports TDLS channel-switching
+ * @WLAN_STA_TDLS_OFF_CHANNEL: The local STA is currently off-channel with this
+ *	TDLS peer
  * @WLAN_STA_UAPSD: Station requested unscheduled SP while driver was
  *	keeping station in power-save mode, reply when the driver
  *	unblocks the station.
@@ -80,6 +82,7 @@ enum ieee80211_sta_info_flags {
 	WLAN_STA_TDLS_PEER_AUTH,
 	WLAN_STA_TDLS_INITIATOR,
 	WLAN_STA_TDLS_CHAN_SWITCH,
+	WLAN_STA_TDLS_OFF_CHANNEL,
 	WLAN_STA_UAPSD,
 	WLAN_STA_SP,
 	WLAN_STA_4ADDR_EVENT,
diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index fa141ae..358f9a4 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -449,6 +449,48 @@ ieee80211_tdls_add_setup_cfm_ies(struct ieee80211_sub_if_data *sdata,
 	ieee80211_tdls_add_link_ie(sdata, skb, peer, initiator);
 }
 
+static void
+ieee80211_tdls_add_chan_switch_req_ies(struct ieee80211_sub_if_data *sdata,
+				       struct sk_buff *skb, const u8 *peer,
+				       bool initiator, const u8 *extra_ies,
+				       size_t extra_ies_len, u8 oper_class,
+				       struct cfg80211_chan_def *chandef)
+{
+	struct ieee80211_tdls_data *tf;
+	size_t offset = 0, noffset;
+	u8 *pos;
+
+	if (WARN_ON_ONCE(!chandef))
+		return;
+
+	tf = (void *)skb->data;
+	tf->u.chan_switch_req.target_channel =
+		ieee80211_frequency_to_channel(chandef->chan->center_freq);
+	tf->u.chan_switch_req.oper_class = oper_class;
+
+	if (extra_ies_len) {
+		static const u8 before_lnkie[] = {
+			WLAN_EID_SECONDARY_CHANNEL_OFFSET,
+		};
+		noffset = ieee80211_ie_split(extra_ies, extra_ies_len,
+					     before_lnkie,
+					     ARRAY_SIZE(before_lnkie),
+					     offset);
+		pos = skb_put(skb, noffset - offset);
+		memcpy(pos, extra_ies + offset, noffset - offset);
+		offset = noffset;
+	}
+
+	ieee80211_tdls_add_link_ie(sdata, skb, peer, initiator);
+
+	/* add any remaining IEs */
+	if (extra_ies_len) {
+		noffset = extra_ies_len;
+		pos = skb_put(skb, noffset - offset);
+		memcpy(pos, extra_ies + offset, noffset - offset);
+	}
+}
+
 static void ieee80211_tdls_add_ies(struct ieee80211_sub_if_data *sdata,
 				   struct sk_buff *skb, const u8 *peer,
 				   u8 action_code, u16 status_code,
@@ -481,6 +523,12 @@ static void ieee80211_tdls_add_ies(struct ieee80211_sub_if_data *sdata,
 		if (status_code == 0 || action_code == WLAN_TDLS_TEARDOWN)
 			ieee80211_tdls_add_link_ie(sdata, skb, peer, initiator);
 		break;
+	case WLAN_TDLS_CHANNEL_SWITCH_REQUEST:
+		ieee80211_tdls_add_chan_switch_req_ies(sdata, skb, peer,
+						       initiator, extra_ies,
+						       extra_ies_len,
+						       oper_class, chandef);
+		break;
 	}
 
 }
@@ -547,6 +595,12 @@ ieee80211_prep_tdls_encap_data(struct wiphy *wiphy, struct net_device *dev,
 		skb_put(skb, sizeof(tf->u.discover_req));
 		tf->u.discover_req.dialog_token = dialog_token;
 		break;
+	case WLAN_TDLS_CHANNEL_SWITCH_REQUEST:
+		tf->category = WLAN_CATEGORY_TDLS;
+		tf->action_code = WLAN_TDLS_CHANNEL_SWITCH_REQUEST;
+
+		skb_put(skb, sizeof(tf->u.chan_switch_req));
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -626,6 +680,7 @@ ieee80211_tdls_build_mgmt_packet_data(struct ieee80211_sub_if_data *sdata,
 	case WLAN_TDLS_SETUP_CONFIRM:
 	case WLAN_TDLS_TEARDOWN:
 	case WLAN_TDLS_DISCOVERY_REQUEST:
+	case WLAN_TDLS_CHANNEL_SWITCH_REQUEST:
 		ret = ieee80211_prep_tdls_encap_data(local->hw.wiphy,
 						     sdata->dev, peer,
 						     action_code, dialog_token,
@@ -699,6 +754,7 @@ ieee80211_tdls_prep_mgmt_packet(struct wiphy *wiphy, struct net_device *dev,
 		initiator = false;
 		break;
 	case WLAN_TDLS_TEARDOWN:
+	case WLAN_TDLS_CHANNEL_SWITCH_REQUEST:
 		/* any value is ok */
 		break;
 	default:
@@ -1046,3 +1102,181 @@ void ieee80211_tdls_oper_request(struct ieee80211_vif *vif, const u8 *peer,
 	cfg80211_tdls_oper_request(sdata->dev, peer, oper, reason_code, gfp);
 }
 EXPORT_SYMBOL(ieee80211_tdls_oper_request);
+
+static void
+iee80211_tdls_add_ch_switch_timing(u8 *buf, u16 switch_time, u16 switch_timeout)
+{
+	struct ieee80211_ch_switch_timing *ch_sw;
+
+	*buf++ = WLAN_EID_CHAN_SWITCH_TIMING;
+	*buf++ = sizeof(struct ieee80211_ch_switch_timing);
+
+	ch_sw = (void *)buf;
+	ch_sw->switch_time = cpu_to_le16(switch_time);
+	ch_sw->switch_timeout = cpu_to_le16(switch_timeout);
+}
+
+/* find switch timing IE in SKB ready for Tx */
+static const u8 *ieee80211_tdls_find_sw_timing_ie(struct sk_buff *skb)
+{
+	struct ieee80211_tdls_data *tf;
+	const u8 *ie_start;
+
+	/*
+	 * Get the offset for the new location of the switch timing IE.
+	 * The SKB network header will now point to the "payload_type"
+	 * element of the TDLS data frame struct.
+	 */
+	tf = container_of(skb->data + skb_network_offset(skb),
+			  struct ieee80211_tdls_data, payload_type);
+	ie_start = tf->u.chan_switch_req.variable;
+	return cfg80211_find_ie(WLAN_EID_CHAN_SWITCH_TIMING, ie_start,
+				skb->len - (ie_start - skb->data));
+}
+
+static struct sk_buff *
+ieee80211_tdls_ch_sw_tmpl_get(struct sta_info *sta, u8 oper_class,
+			      struct cfg80211_chan_def *chandef,
+			      u32 *ch_sw_tm_ie_offset)
+{
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	u8 extra_ies[2 + sizeof(struct ieee80211_sec_chan_offs_ie) +
+		     2 + sizeof(struct ieee80211_ch_switch_timing)];
+	int extra_ies_len = 2 + sizeof(struct ieee80211_ch_switch_timing);
+	u8 *pos = extra_ies;
+	struct sk_buff *skb;
+
+	/*
+	 * if chandef points to a wide channel add a Secondary-Channel
+	 * Offset information element
+	 */
+	if (chandef->width == NL80211_CHAN_WIDTH_40) {
+		struct ieee80211_sec_chan_offs_ie *sec_chan_ie;
+		bool ht40plus;
+
+		*pos++ = WLAN_EID_SECONDARY_CHANNEL_OFFSET;
+		*pos++ = sizeof(*sec_chan_ie);
+		sec_chan_ie = (void *)pos;
+
+		ht40plus = cfg80211_get_chandef_type(chandef) ==
+							NL80211_CHAN_HT40PLUS;
+		sec_chan_ie->sec_chan_offs = ht40plus ?
+					     IEEE80211_HT_PARAM_CHA_SEC_ABOVE :
+					     IEEE80211_HT_PARAM_CHA_SEC_BELOW;
+		pos += sizeof(*sec_chan_ie);
+
+		extra_ies_len += 2 + sizeof(struct ieee80211_sec_chan_offs_ie);
+	}
+
+	/* just set the values to 0, this is a template */
+	iee80211_tdls_add_ch_switch_timing(pos, 0, 0);
+
+	skb = ieee80211_tdls_build_mgmt_packet_data(sdata, sta->sta.addr,
+					      WLAN_TDLS_CHANNEL_SWITCH_REQUEST,
+					      0, 0, !sta->sta.tdls_initiator,
+					      extra_ies, extra_ies_len,
+					      oper_class, chandef);
+	if (!skb)
+		return NULL;
+
+	skb = ieee80211_build_data_template(sdata, skb, 0);
+	if (IS_ERR(skb)) {
+		tdls_dbg(sdata, "Failed building TDLS channel switch frame\n");
+		return NULL;
+	}
+
+	if (ch_sw_tm_ie_offset) {
+		const u8 *tm_ie = ieee80211_tdls_find_sw_timing_ie(skb);
+
+		if (!tm_ie) {
+			tdls_dbg(sdata, "No switch timing IE in TDLS switch\n");
+			dev_kfree_skb_any(skb);
+			return NULL;
+		}
+
+		*ch_sw_tm_ie_offset = tm_ie - skb->data;
+	}
+
+	tdls_dbg(sdata,
+		 "TDLS channel switch request template for %pM ch %d width %d\n",
+		 sta->sta.addr, chandef->chan->center_freq, chandef->width);
+	return skb;
+}
+
+int
+ieee80211_tdls_channel_switch(struct wiphy *wiphy, struct net_device *dev,
+			      const u8 *addr, u8 oper_class,
+			      struct cfg80211_chan_def *chandef)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
+	struct sta_info *sta;
+	struct sk_buff *skb = NULL;
+	u32 ch_sw_tm_ie;
+	int ret;
+
+	mutex_lock(&local->sta_mtx);
+	sta = sta_info_get(sdata, addr);
+	if (!sta) {
+		tdls_dbg(sdata,
+			 "Invalid TDLS peer %pM for channel switch request\n",
+			 addr);
+		ret = -ENOENT;
+		goto out;
+	}
+
+	if (!test_sta_flag(sta, WLAN_STA_TDLS_CHAN_SWITCH)) {
+		tdls_dbg(sdata, "TDLS channel switch unsupported by %pM\n",
+			 addr);
+		ret = -ENOTSUPP;
+		goto out;
+	}
+
+	skb = ieee80211_tdls_ch_sw_tmpl_get(sta, oper_class, chandef,
+					    &ch_sw_tm_ie);
+	if (!skb) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	ret = drv_tdls_channel_switch(local, sdata, &sta->sta, oper_class,
+				      chandef, skb, ch_sw_tm_ie);
+	if (!ret)
+		set_sta_flag(sta, WLAN_STA_TDLS_OFF_CHANNEL);
+
+out:
+	mutex_unlock(&local->sta_mtx);
+	dev_kfree_skb_any(skb);
+	return ret;
+}
+
+void
+ieee80211_tdls_cancel_channel_switch(struct wiphy *wiphy,
+				     struct net_device *dev,
+				     const u8 *addr)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
+	struct sta_info *sta;
+
+	mutex_lock(&local->sta_mtx);
+	sta = sta_info_get(sdata, addr);
+	if (!sta) {
+		tdls_dbg(sdata,
+			 "Invalid TDLS peer %pM for channel switch cancel\n",
+			 addr);
+		goto out;
+	}
+
+	if (!test_sta_flag(sta, WLAN_STA_TDLS_OFF_CHANNEL)) {
+		tdls_dbg(sdata, "TDLS channel switch not initiated by %pM\n",
+			 addr);
+		goto out;
+	}
+
+	drv_tdls_cancel_channel_switch(local, sdata, &sta->sta);
+	clear_sta_flag(sta, WLAN_STA_TDLS_OFF_CHANNEL);
+
+out:
+	mutex_unlock(&local->sta_mtx);
+}
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 809a498..12c5220 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -2194,6 +2194,63 @@ TRACE_EVENT(drv_get_txpower,
 	)
 );
 
+TRACE_EVENT(drv_tdls_channel_switch,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 struct ieee80211_sta *sta, u8 oper_class,
+		 struct cfg80211_chan_def *chandef),
+
+	TP_ARGS(local, sdata, sta, oper_class, chandef),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+		STA_ENTRY
+		__field(u8, oper_class)
+		CHANDEF_ENTRY
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		STA_ASSIGN;
+		__entry->oper_class = oper_class;
+		CHANDEF_ASSIGN(chandef)
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT VIF_PR_FMT " tdls channel switch to"
+		CHANDEF_PR_FMT  " oper_class:%d " STA_PR_FMT,
+		LOCAL_PR_ARG, VIF_PR_ARG, CHANDEF_PR_ARG, __entry->oper_class,
+		STA_PR_ARG
+	)
+);
+
+TRACE_EVENT(drv_tdls_cancel_channel_switch,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 struct ieee80211_sta *sta),
+
+	TP_ARGS(local, sdata, sta),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+		STA_ENTRY
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		STA_ASSIGN;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT VIF_PR_FMT
+		" tdls cancel channel switch with " STA_PR_FMT,
+		LOCAL_PR_ARG, VIF_PR_ARG, STA_PR_ARG
+	)
+);
 
 #ifdef CONFIG_MAC80211_MESSAGE_TRACING
 #undef TRACE_SYSTEM
-- 
1.9.1

