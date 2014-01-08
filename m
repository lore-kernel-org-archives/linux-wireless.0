Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:41744 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756713AbaAHPbT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jan 2014 10:31:19 -0500
Received: by mail-ee0-f45.google.com with SMTP id d49so752739eek.32
        for <linux-wireless@vger.kernel.org>; Wed, 08 Jan 2014 07:31:18 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 4/4] cfg80211: implement multi-BSS CSA
Date: Wed,  8 Jan 2014 16:26:58 +0100
Message-Id: <1389194818-7864-5-git-send-email-michal.kazior@tieto.com> (sfid-20140108_163128_413858_1AAF52FE)
In-Reply-To: <1389194818-7864-1-git-send-email-michal.kazior@tieto.com>
References: <1389194818-7864-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This extends NL80211_CMD_CHANNEL_SWITCH by adding
a new attribute NL80211_ATTR_SWITCH_NEXT. The
attribute holds nested channel switch attributes
(including itself) allowing
multi-interface/chained CSA.

This makes it possible for userspace to request a
multi-interface channel switch while allowing
sanity checks wrt target interface/channel
combination.

This changes channel_switch() cfg80211 op to pass
different set of parameters. The only driver that
is affected by this is mac80211.

This change should not affect any prior CSA
behaviour.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 include/net/cfg80211.h       |  10 ++-
 include/uapi/linux/nl80211.h |   2 +
 net/mac80211/cfg.c           |  10 ++-
 net/wireless/nl80211.c       | 188 +++++++++++++++++++++++++++++++------------
 net/wireless/rdev-ops.h      |   8 +-
 net/wireless/trace.h         |  29 ++-----
 6 files changed, 161 insertions(+), 86 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index e9abc7b..1d57f97 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -688,6 +688,7 @@ struct cfg80211_ap_settings {
  * @count: number of beacons until switch
  */
 struct cfg80211_csa_settings {
+	struct net_device *dev;
 	struct cfg80211_chan_def chandef;
 	struct cfg80211_beacon_data beacon_csa;
 	u16 counter_offset_beacon, counter_offset_presp;
@@ -697,6 +698,8 @@ struct cfg80211_csa_settings {
 	u8 count;
 };
 
+#define CFG80211_MAX_NUM_CSA_SETTINGS 8
+
 /**
  * enum station_parameters_apply_mask - station parameter values to apply
  * @STATION_PARAM_APPLY_UAPSD: apply new uAPSD parameters (uapsd_queues, max_sp)
@@ -2207,7 +2210,8 @@ struct cfg80211_mgmt_tx_params {
  *	reliability. This operation can not fail.
  * @set_coalesce: Set coalesce parameters.
  *
- * @channel_switch: initiate channel-switch procedure (with CSA)
+ * @channel_switch: initiate channel-switch procedure (with CSA).
+ *	num_params is always >= 1.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -2447,8 +2451,8 @@ struct cfg80211_ops {
 				struct cfg80211_coalesce *coalesce);
 
 	int	(*channel_switch)(struct wiphy *wiphy,
-				  struct net_device *dev,
-				  struct cfg80211_csa_settings *params);
+				  struct cfg80211_csa_settings *params,
+				  int num_params);
 };
 
 /*
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 129b7b0..6d3b59c 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1839,6 +1839,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_SUPPORT_5_MHZ,
 	NL80211_ATTR_SUPPORT_10_MHZ,
 
+	NL80211_ATTR_CH_SWITCH_NEXT,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index f80e8c4..ef13120 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3047,9 +3047,11 @@ unlock:
 	sdata_unlock(sdata);
 }
 
-static int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
-				    struct cfg80211_csa_settings *params)
+static int ieee80211_channel_switch(struct wiphy *wiphy,
+				    struct cfg80211_csa_settings *params,
+				    int num_params)
 {
+	struct net_device *dev = params[0].dev;
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_chanctx_conf *chanctx_conf;
@@ -3059,6 +3061,10 @@ static int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 
 	lockdep_assert_held(&sdata->wdev.mtx);
 
+	/* multi-vif CSA is not implemented */
+	if (num_params > 1)
+		return -EOPNOTSUPP;
+
 	if (!list_empty(&local->roc_list) || local->scanning)
 		return -EBUSY;
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 33962ef..20cbcbd 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5709,12 +5709,18 @@ static int nl80211_channel_switch(struct sk_buff *skb, struct genl_info *info)
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct net_device *dev = info->user_ptr[1];
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct cfg80211_csa_settings params;
-	/* csa_attrs is defined static to avoid waste of stack size - this
+	/* static variables avoid waste of stack size - this
 	 * function is called under RTNL lock, so this should not be a problem.
 	 */
 	static struct nlattr *csa_attrs[NL80211_ATTR_MAX+1];
-	u8 radar_detect_width = 0;
+	static struct nlattr *next_attrs[NL80211_ATTR_MAX+1];
+	static struct cfg80211_csa_settings
+			all_params[CFG80211_MAX_NUM_CSA_SETTINGS] = {};
+	static struct cfg80211_iftype_chan_param
+			all_ifch_params[CFG80211_MAX_NUM_CSA_SETTINGS] = {};
+	struct cfg80211_csa_settings *params = &all_params[0];
+	struct cfg80211_iftype_chan_param *ifch_params = &all_ifch_params[0];
+	struct nlattr **attrs, *next_csa;
 	int err;
 	bool need_new_beacon = false;
 
@@ -5722,111 +5728,187 @@ static int nl80211_channel_switch(struct sk_buff *skb, struct genl_info *info)
 	    !(rdev->wiphy.flags & WIPHY_FLAG_HAS_CHANNEL_SWITCH))
 		return -EOPNOTSUPP;
 
+	attrs = info->attrs;
+
+again:
+	if (!attrs[NL80211_ATTR_IFINDEX]) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	dev = dev_get_by_index(genl_info_net(info),
+			       nla_get_u32(attrs[NL80211_ATTR_IFINDEX]));
+	if (!dev) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	params->dev = dev;
+	wdev = dev->ieee80211_ptr;
+	if (!wdev) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	if (!netif_running(dev)) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	switch (dev->ieee80211_ptr->iftype) {
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_P2P_GO:
 		need_new_beacon = true;
 
 		/* useless if AP is not running */
-		if (!wdev->beacon_interval)
-			return -EINVAL;
+		if (!wdev->beacon_interval) {
+			err = -EINVAL;
+			goto out;
+		}
 		break;
 	case NL80211_IFTYPE_ADHOC:
 	case NL80211_IFTYPE_MESH_POINT:
 		break;
 	default:
-		return -EOPNOTSUPP;
+		err = -EOPNOTSUPP;
+		goto out;
 	}
 
-	memset(&params, 0, sizeof(params));
-
-	if (!info->attrs[NL80211_ATTR_WIPHY_FREQ] ||
-	    !info->attrs[NL80211_ATTR_CH_SWITCH_COUNT])
-		return -EINVAL;
+	if (!attrs[NL80211_ATTR_WIPHY_FREQ] ||
+	    !attrs[NL80211_ATTR_CH_SWITCH_COUNT]) {
+		err = -EINVAL;
+		goto out;
+	}
 
 	/* only important for AP, IBSS and mesh create IEs internally */
-	if (need_new_beacon && !info->attrs[NL80211_ATTR_CSA_IES])
-		return -EINVAL;
+	if (need_new_beacon && !attrs[NL80211_ATTR_CSA_IES]) {
+		err = -EINVAL;
+		goto out;
+	}
 
-	params.count = nla_get_u32(info->attrs[NL80211_ATTR_CH_SWITCH_COUNT]);
+	params->count = nla_get_u32(attrs[NL80211_ATTR_CH_SWITCH_COUNT]);
 
 	if (!need_new_beacon)
 		goto skip_beacons;
 
-	err = nl80211_parse_beacon(info->attrs, &params.beacon_after);
+	err = nl80211_parse_beacon(attrs, &params->beacon_after);
 	if (err)
-		return err;
+		goto out;
 
 	err = nla_parse_nested(csa_attrs, NL80211_ATTR_MAX,
-			       info->attrs[NL80211_ATTR_CSA_IES],
+			       attrs[NL80211_ATTR_CSA_IES],
 			       nl80211_policy);
 	if (err)
-		return err;
+		goto out;
 
-	err = nl80211_parse_beacon(csa_attrs, &params.beacon_csa);
+	err = nl80211_parse_beacon(csa_attrs, &params->beacon_csa);
 	if (err)
-		return err;
+		goto out;
 
-	if (!csa_attrs[NL80211_ATTR_CSA_C_OFF_BEACON])
-		return -EINVAL;
+	if (!csa_attrs[NL80211_ATTR_CSA_C_OFF_BEACON]) {
+		err = -EINVAL;
+		goto out;
+	}
 
-	params.counter_offset_beacon =
+	params->counter_offset_beacon =
 		nla_get_u16(csa_attrs[NL80211_ATTR_CSA_C_OFF_BEACON]);
-	if (params.counter_offset_beacon >= params.beacon_csa.tail_len)
-		return -EINVAL;
+	if (params->counter_offset_beacon >= params->beacon_csa.tail_len) {
+		err = -EINVAL;
+		goto out;
+	}
 
 	/* sanity check - counters should be the same */
-	if (params.beacon_csa.tail[params.counter_offset_beacon] !=
-	    params.count)
-		return -EINVAL;
+	if (params->beacon_csa.tail[params->counter_offset_beacon] !=
+	    params->count) {
+		err = -EINVAL;
+		goto out;
+	}
 
 	if (csa_attrs[NL80211_ATTR_CSA_C_OFF_PRESP]) {
-		params.counter_offset_presp =
+		params->counter_offset_presp =
 			nla_get_u16(csa_attrs[NL80211_ATTR_CSA_C_OFF_PRESP]);
-		if (params.counter_offset_presp >=
-		    params.beacon_csa.probe_resp_len)
-			return -EINVAL;
+		if (params->counter_offset_presp >=
+		    params->beacon_csa.probe_resp_len) {
+			err = -EINVAL;
+			goto out;
+		}
 
-		if (params.beacon_csa.probe_resp[params.counter_offset_presp] !=
-		    params.count)
-			return -EINVAL;
+		if (params->beacon_csa.probe_resp[params->counter_offset_presp] !=
+		    params->count) {
+			err = -EINVAL;
+			goto out;
+		}
 	}
 
 skip_beacons:
-	err = nl80211_parse_chandef(rdev, info->attrs, &params.chandef);
+	err = nl80211_parse_chandef(rdev, attrs, &params->chandef);
 	if (err)
-		return err;
+		goto out;
 
-	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &params.chandef))
-		return -EINVAL;
+	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &params->chandef)) {
+		err = -EINVAL;
+		goto out;
+	}
 
 	if (dev->ieee80211_ptr->iftype == NL80211_IFTYPE_AP ||
 	    dev->ieee80211_ptr->iftype == NL80211_IFTYPE_P2P_GO ||
 	    dev->ieee80211_ptr->iftype == NL80211_IFTYPE_ADHOC) {
 		err = cfg80211_chandef_dfs_required(wdev->wiphy,
-						    &params.chandef);
+						    &params->chandef);
 		if (err < 0) {
-			return err;
+			err = -EINVAL;
+			goto out;
 		} else if (err) {
-			radar_detect_width = BIT(params.chandef.width);
-			params.radar_required = true;
+			params->radar_required = true;
 		}
 	}
 
-	err = cfg80211_can_use_iftype_chan(rdev, wdev, wdev->iftype,
-					   params.chandef.chan,
-					   CHAN_MODE_SHARED,
-					   radar_detect_width);
-	if (err)
-		return err;
+	if (attrs[NL80211_ATTR_CH_SWITCH_BLOCK_TX])
+		params->block_tx = true;
+
+	ifch_params->wdev = wdev;
+	ifch_params->iftype = wdev->iftype;
+	ifch_params->chan = params->chandef.chan;
+	ifch_params->chanmode = CHAN_MODE_SHARED;
+	ifch_params->radar_detect_width = params->radar_required
+					? BIT(params->chandef.width)
+					: 0;
+	ifch_params++;
+	params++;
+
+	next_csa = attrs[NL80211_ATTR_CH_SWITCH_NEXT];
+	if (next_csa) {
+		memset(next_attrs, 0, sizeof(next_attrs));
 
-	if (info->attrs[NL80211_ATTR_CH_SWITCH_BLOCK_TX])
-		params.block_tx = true;
+		if (params - all_params >= ARRAY_SIZE(all_params)) {
+			err = -ENOMEM;
+			goto out;
+		}
+
+		err = nla_parse_nested(next_attrs, NL80211_ATTR_MAX, next_csa,
+				       nl80211_policy);
+		if (err)
+			goto out;
+
+		attrs = next_attrs;
+		goto again;
+	}
+
+	err = cfg80211_can_use_iftype_chan_params(rdev, all_ifch_params,
+						  ifch_params -
+						  all_ifch_params);
+	if (err)
+		goto out;
 
 	wdev_lock(wdev);
-	err = rdev_channel_switch(rdev, dev, &params);
+	err = rdev_channel_switch(rdev, all_params, params - all_params);
 	wdev_unlock(wdev);
 
+out:
+	for (; params - all_params >= 0; params--)
+		if (params->dev)
+			dev_put(params->dev);
+
 	return err;
 }
 
@@ -9593,7 +9675,7 @@ static const struct genl_ops nl80211_ops[] = {
 		.doit = nl80211_channel_switch,
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+		.internal_flags = NL80211_FLAG_NEED_WIPHY |
 				  NL80211_FLAG_NEED_RTNL,
 	},
 };
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index a6c03ab..6d7cacf 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -921,13 +921,13 @@ static inline void rdev_crit_proto_stop(struct cfg80211_registered_device *rdev,
 }
 
 static inline int rdev_channel_switch(struct cfg80211_registered_device *rdev,
-				      struct net_device *dev,
-				      struct cfg80211_csa_settings *params)
+				      struct cfg80211_csa_settings *params,
+				      int num_params)
 {
 	int ret;
 
-	trace_rdev_channel_switch(&rdev->wiphy, dev, params);
-	ret = rdev->ops->channel_switch(&rdev->wiphy, dev, params);
+	trace_rdev_channel_switch(&rdev->wiphy, params);
+	ret = rdev->ops->channel_switch(&rdev->wiphy, params, num_params);
 	trace_rdev_return_int(&rdev->wiphy, ret);
 	return ret;
 }
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index f7aa7a7..daaa806 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1843,36 +1843,17 @@ TRACE_EVENT(rdev_crit_proto_stop,
 );
 
 TRACE_EVENT(rdev_channel_switch,
-	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+	TP_PROTO(struct wiphy *wiphy,
 		 struct cfg80211_csa_settings *params),
-	TP_ARGS(wiphy, netdev, params),
+	TP_ARGS(wiphy, params),
 	TP_STRUCT__entry(
 		WIPHY_ENTRY
-		NETDEV_ENTRY
-		CHAN_DEF_ENTRY
-		__field(u16, counter_offset_beacon)
-		__field(u16, counter_offset_presp)
-		__field(bool, radar_required)
-		__field(bool, block_tx)
-		__field(u8, count)
 	),
 	TP_fast_assign(
 		WIPHY_ASSIGN;
-		NETDEV_ASSIGN;
-		CHAN_DEF_ASSIGN(&params->chandef);
-		__entry->counter_offset_beacon = params->counter_offset_beacon;
-		__entry->counter_offset_presp = params->counter_offset_presp;
-		__entry->radar_required = params->radar_required;
-		__entry->block_tx = params->block_tx;
-		__entry->count = params->count;
-	),
-	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", " CHAN_DEF_PR_FMT
-		  ", block_tx: %d, count: %u, radar_required: %d"
-		  ", counter offsets (beacon/presp): %u/%u",
-		  WIPHY_PR_ARG, NETDEV_PR_ARG, CHAN_DEF_PR_ARG,
-		  __entry->block_tx, __entry->count, __entry->radar_required,
-		  __entry->counter_offset_beacon,
-		  __entry->counter_offset_presp)
+	),
+	TP_printk(WIPHY_PR_FMT,
+		  WIPHY_PR_ARG)
 );
 
 /*************************************************************
-- 
1.8.4.rc3

