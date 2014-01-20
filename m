Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:33716 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbaATOOJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jan 2014 09:14:09 -0500
Received: by mail-ee0-f53.google.com with SMTP id t10so3497158eei.12
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jan 2014 06:14:08 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 3/3] cfg80211: implement multi-interface CSA
Date: Mon, 20 Jan 2014 15:09:28 +0100
Message-Id: <1390226968-18928-4-git-send-email-michal.kazior@tieto.com> (sfid-20140120_151418_961323_2D6BAC24)
In-Reply-To: <1390226968-18928-1-git-send-email-michal.kazior@tieto.com>
References: <1390226968-18928-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This extends NL80211_CMD_CHANNEL_SWITCH by adding
a new attribute NL80211_ATTR_CH_SWITCH_IFACES. The
attribute holds an array of CSA attributes. Each
entry holds attributes that were used until now:
ifindex, chandef, blocktx, beacon/proberesp.

The new attribute is used as a flag in
send_wiphy() and a driver may advertise the
capability with WIPHY_FLAG_HAS_MULTI_IF_CHSWITCH.

Userspace may now submit CSA in the old way or
with the new attribute set. If the new attribute
is set attributes outside the nested attribute are
ignored.

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
 include/net/cfg80211.h       |  10 +-
 include/uapi/linux/nl80211.h |   6 ++
 net/mac80211/cfg.c           |  23 ++++-
 net/mac80211/ibss.c          |   4 +-
 net/mac80211/ieee80211_i.h   |   7 +-
 net/mac80211/mesh.c          |   4 +-
 net/wireless/nl80211.c       | 237 ++++++++++++++++++++++++++++++++-----------
 net/wireless/rdev-ops.h      |   8 +-
 net/wireless/trace.h         |  37 +++----
 9 files changed, 235 insertions(+), 101 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index d5e57bf..226d1e1 100644
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
@@ -2266,6 +2267,7 @@ struct cfg80211_qos_map {
  * @set_coalesce: Set coalesce parameters.
  *
  * @channel_switch: initiate channel-switch procedure (with CSA)
+ *	num_params is always >= 1.
  *
  * @set_qos_map: Set QoS mapping information to the driver
  */
@@ -2507,8 +2509,8 @@ struct cfg80211_ops {
 				struct cfg80211_coalesce *coalesce);
 
 	int	(*channel_switch)(struct wiphy *wiphy,
-				  struct net_device *dev,
-				  struct cfg80211_csa_settings *params);
+				  struct cfg80211_csa_settings *params,
+				  int num_params);
 	int     (*set_qos_map)(struct wiphy *wiphy,
 			       struct net_device *dev,
 			       struct cfg80211_qos_map *qos_map);
@@ -2558,6 +2560,9 @@ struct cfg80211_ops {
  * @WIPHY_FLAG_SUPPORTS_5_10_MHZ: Device supports 5 MHz and 10 MHz channels.
  * @WIPHY_FLAG_HAS_CHANNEL_SWITCH: Device supports channel switch in
  *	beaconing mode (AP, IBSS, Mesh, ...).
+ * @WIPHY_FLAG_HAS_MULTI_IF_CHSWITCH: Device supports multi-interface channel
+ *	switching in beaconing mode (AP, IBSS, Mesh). If this is set it is
+ *	expected that @WIPHY_FLAG_HAS_CHANNEL_SWITCH is set as well.
  */
 enum wiphy_flags {
 	/* use hole at 0 */
@@ -2583,6 +2588,7 @@ enum wiphy_flags {
 	WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL	= BIT(21),
 	WIPHY_FLAG_SUPPORTS_5_10_MHZ		= BIT(22),
 	WIPHY_FLAG_HAS_CHANNEL_SWITCH		= BIT(23),
+	WIPHY_FLAG_HAS_MULTI_IF_CHSWITCH	= BIT(24),
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 53e56cf..ac45e62 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1575,6 +1575,10 @@ enum nl80211_commands {
  *	advertise values that cannot always be met. In such cases, an attempt
  *	to add a new station entry with @NL80211_CMD_NEW_STATION may fail.
  *
+ * @NL80211_ATTR_CH_SWITCH_IFACES: Nested attribute with channel switch
+ *	settings in each entry (ifindex, frequency, beacon IEs). Also used as a
+ *	device capability flag in nl80211_send_wiphy().
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1908,6 +1912,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_MAX_AP_ASSOC_STA,
 
+	NL80211_ATTR_CH_SWITCH_IFACES,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 032081c..65dac7f 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3071,8 +3071,8 @@ unlock:
 	sdata_unlock(sdata);
 }
 
-int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
-			     struct cfg80211_csa_settings *params)
+int __ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
+			       struct cfg80211_csa_settings *params)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
@@ -3255,6 +3255,25 @@ int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 	return 0;
 }
 
+int ieee80211_channel_switch(struct wiphy *wiphy,
+			     struct cfg80211_csa_settings *params,
+			     int num_params)
+{
+	struct ieee80211_sub_if_data *sdata;
+	int err;
+
+	/* multi-vif CSA is not implemented */
+	if (num_params > 1)
+		return -EOPNOTSUPP;
+
+	sdata = IEEE80211_DEV_TO_SUB_IF(params[0].dev);
+	sdata_lock(sdata);
+	err = __ieee80211_channel_switch(wiphy, params[0].dev, &params[0]);
+	sdata_unlock(sdata);
+
+	return err;
+}
+
 static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 			     struct cfg80211_mgmt_tx_params *params,
 			     u64 *cookie)
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index ed7eec3..5ca5834 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -899,8 +899,8 @@ ieee80211_ibss_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 
 	params.block_tx = !!csa_ie.mode;
 
-	if (ieee80211_channel_switch(sdata->local->hw.wiphy, sdata->dev,
-				     &params))
+	if (__ieee80211_channel_switch(sdata->local->hw.wiphy, sdata->dev,
+				       &params))
 		goto disconnect;
 
 	ieee80211_ibss_csa_mark_radar(sdata);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 96eb272..a6cda02 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1460,8 +1460,11 @@ void ieee80211_handle_roc_started(struct ieee80211_roc_work *roc);
 
 /* channel switch handling */
 void ieee80211_csa_finalize_work(struct work_struct *work);
-int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
-			     struct cfg80211_csa_settings *params);
+int __ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
+			       struct cfg80211_csa_settings *params);
+int ieee80211_channel_switch(struct wiphy *wiphy,
+			     struct cfg80211_csa_settings *params,
+			     int num_params);
 
 /* interface handling */
 int ieee80211_iface_init(void);
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index b02ac33..98bcd2b 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -934,8 +934,8 @@ ieee80211_mesh_process_chnswitch(struct ieee80211_sub_if_data *sdata,
 
 	ifmsh->csa_role = IEEE80211_MESH_CSA_ROLE_REPEATER;
 
-	if (ieee80211_channel_switch(sdata->local->hw.wiphy, sdata->dev,
-				     &params) < 0)
+	if (__ieee80211_channel_switch(sdata->local->hw.wiphy, sdata->dev,
+				       &params) < 0)
 		return false;
 
 	return true;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 8742ed9..fc52992 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -386,6 +386,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 				   .len = IEEE80211_QOS_MAP_LEN_MAX },
 	[NL80211_ATTR_MAC_HINT] = { .len = ETH_ALEN },
 	[NL80211_ATTR_WIPHY_FREQ_HINT] = { .type = NLA_U32 },
+	[NL80211_ATTR_CH_SWITCH_IFACES] = { .type = NLA_NESTED },
 };
 
 /* policy for the key attributes */
@@ -1270,6 +1271,9 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 		if ((dev->wiphy.flags & WIPHY_FLAG_TDLS_EXTERNAL_SETUP) &&
 		    nla_put_flag(msg, NL80211_ATTR_TDLS_EXTERNAL_SETUP))
 			goto nla_put_failure;
+		if ((dev->wiphy.flags & WIPHY_FLAG_HAS_MULTI_IF_CHSWITCH) &&
+		     nla_put_flag(msg, NL80211_ATTR_CH_SWITCH_IFACES))
+			goto nla_put_failure;
 		state->split_start++;
 		if (state->split)
 			break;
@@ -5771,23 +5775,42 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
 	return err;
 }
 
-static int nl80211_channel_switch(struct sk_buff *skb, struct genl_info *info)
+static int
+nl80211_parse_csa_settings(struct cfg80211_registered_device *rdev,
+			   struct nlattr **attrs,
+			   struct cfg80211_csa_settings *params,
+			   struct cfg80211_iftype_chan_param *ifch_params)
 {
-	struct cfg80211_registered_device *rdev = info->user_ptr[0];
-	struct net_device *dev = info->user_ptr[1];
-	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct cfg80211_csa_settings params;
-	/* csa_attrs is defined static to avoid waste of stack size - this
+	/* static variables avoid waste of stack size - this
 	 * function is called under RTNL lock, so this should not be a problem.
 	 */
 	static struct nlattr *csa_attrs[NL80211_ATTR_MAX+1];
-	u8 radar_detect_width = 0;
+	struct net_device *dev = NULL;
+	struct wireless_dev *wdev;
 	int err;
 	bool need_new_beacon = false;
 
-	if (!rdev->ops->channel_switch ||
-	    !(rdev->wiphy.flags & WIPHY_FLAG_HAS_CHANNEL_SWITCH))
-		return -EOPNOTSUPP;
+	ASSERT_RTNL();
+
+	if (!attrs[NL80211_ATTR_IFINDEX])
+		return -EINVAL;
+
+	dev = dev_get_by_index(wiphy_net(&rdev->wiphy),
+			       nla_get_u32(attrs[NL80211_ATTR_IFINDEX]));
+	if (!dev)
+		return -ENOENT;
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
 
 	switch (dev->ieee80211_ptr->iftype) {
 	case NL80211_IFTYPE_AP:
@@ -5795,105 +5818,195 @@ static int nl80211_channel_switch(struct sk_buff *skb, struct genl_info *info)
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
 
-	if (info->attrs[NL80211_ATTR_CH_SWITCH_BLOCK_TX])
-		params.block_tx = true;
+	ifch_params->wdev = wdev;
+	ifch_params->iftype = wdev->iftype;
+	ifch_params->chan = params->chandef.chan;
+	ifch_params->chanmode = CHAN_MODE_SHARED;
+	ifch_params->radar_detect_width = params->radar_required
+					? BIT(params->chandef.width)
+					: 0;
 
-	wdev_lock(wdev);
-	err = rdev_channel_switch(rdev, dev, &params);
-	wdev_unlock(wdev);
+out:
+	dev_put(dev);
+	return 0;
+}
+
+static int nl80211_channel_switch(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct cfg80211_csa_settings *csa_params;
+	struct cfg80211_iftype_chan_param *ifch_params;
+	struct nlattr *attrs;
+	/* static variables avoid waste of stack size - this function is called
+	 * under RTNL lock, so this should not be a problem. */
+	static struct nlattr *csa_attrs[NL80211_ATTR_MAX+1];
+	int err, num_params = 0, tmp;
+
+	if (!rdev->ops->channel_switch ||
+	    !(rdev->wiphy.flags & WIPHY_FLAG_HAS_CHANNEL_SWITCH))
+		return -EOPNOTSUPP;
+
+	if (info->attrs[NL80211_ATTR_CH_SWITCH_IFACES]) {
+		if (!(rdev->wiphy.flags & NL80211_ATTR_CH_SWITCH_IFACES))
+			return -EOPNOTSUPP;
+
+		nla_for_each_nested(attrs,
+				    info->attrs[NL80211_ATTR_CH_SWITCH_IFACES],
+				    tmp)
+			num_params++;
+	} else {
+		num_params = 1;
+	}
+
+	csa_params = kzalloc(sizeof(*csa_params) * num_params, GFP_KERNEL);
+	if (!csa_params)
+		return -ENOMEM;
+
+	ifch_params = kzalloc(sizeof(*ifch_params) * num_params, GFP_KERNEL);
+	if (!ifch_params) {
+		kfree(csa_params);
+		return -ENOMEM;
+	}
+
+	if (info->attrs[NL80211_ATTR_CH_SWITCH_IFACES]) {
+		int i = 0;
+
+		nla_for_each_nested(attrs,
+				    info->attrs[NL80211_ATTR_CH_SWITCH_IFACES],
+				    tmp) {
+			nla_parse(csa_attrs, NL80211_ATTR_MAX, nla_data(attrs),
+				  nla_len(attrs), nl80211_policy);
 
+			err = nl80211_parse_csa_settings(rdev, csa_attrs,
+							 &csa_params[i],
+							 &ifch_params[i]);
+			if (err)
+				goto out;
+			i++;
+		}
+	} else {
+		err = nl80211_parse_csa_settings(rdev, info->attrs,
+						 &csa_params[0],
+						 &ifch_params[0]);
+		if (err)
+			goto out;
+	}
+
+	err = cfg80211_can_use_iftype_chan_params(rdev, ifch_params,
+						  num_params);
+	if (err)
+		goto out;
+
+	err = rdev_channel_switch(rdev, csa_params, num_params);
+
+out:
+	kfree(csa_params);
+	kfree(ifch_params);
 	return err;
 }
 
@@ -9918,7 +10031,7 @@ static const struct genl_ops nl80211_ops[] = {
 		.doit = nl80211_channel_switch,
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+		.internal_flags = NL80211_FLAG_NEED_WIPHY |
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index c8e2259..ade70b7 100644
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
+	trace_rdev_channel_switch(&rdev->wiphy, params, num_params);
+	ret = rdev->ops->channel_switch(&rdev->wiphy, params, num_params);
 	trace_rdev_return_int(&rdev->wiphy, ret);
 	return ret;
 }
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index fbcc23e..982246e 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1865,36 +1865,23 @@ TRACE_EVENT(rdev_crit_proto_stop,
 );
 
 TRACE_EVENT(rdev_channel_switch,
-	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
-		 struct cfg80211_csa_settings *params),
-	TP_ARGS(wiphy, netdev, params),
+	TP_PROTO(struct wiphy *wiphy,
+		 struct cfg80211_csa_settings *params,
+		 int num_params),
+	TP_ARGS(wiphy, params, num_params),
 	TP_STRUCT__entry(
 		WIPHY_ENTRY
-		NETDEV_ENTRY
-		CHAN_DEF_ENTRY
-		__field(u16, counter_offset_beacon)
-		__field(u16, counter_offset_presp)
-		__field(bool, radar_required)
-		__field(bool, block_tx)
-		__field(u8, count)
+		__field(int, num_params)
+		__dynamic_array(u8, params, sizeof(*params) * num_params)
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
+		__entry->num_params = num_params;
+		memcpy(__get_dynamic_array(params), params,
+		       sizeof(*params) * num_params);
+	),
+	TP_printk(WIPHY_PR_FMT ", num_params=%d",
+		  WIPHY_PR_ARG, __entry->num_params)
 );
 
 TRACE_EVENT(rdev_set_qos_map,
-- 
1.8.4.rc3

