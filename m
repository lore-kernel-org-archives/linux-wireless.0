Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34562 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759531Ab0I0PIM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 11:08:12 -0400
Subject: [RFC v2] cfg80211: add p2p listen API
From: Johannes Berg <johannes@sipsolutions.net>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1285584358.4043.11.camel@jlt3.sipsolutions.net>
References: <1285584358.4043.11.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Sep 2010 17:08:09 +0200
Message-ID: <1285600089.4043.22.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To offload P2P find and P2P extended listen to the
device, new API is necessary. This defines the API,
please let me know if you think this is sufficient
and correct.

Sanity checks that I think I should still add:

 * You cannot do remain-on-channel while a p2p-listen
   is active.

 * need to figure out what you can do while this is
   active -- can you try to associate?

 * need to figure out when this is allowed to be
   activated -- all the time? just at certain times
   (in terms of the state the device is in)? For
   example, should a p2p-find be allowed while a GO
   is active? That'd require some timing/scheduling
   from the driver...

Other thoughts?

johannes
---
 include/linux/nl80211.h |   30 +++++
 include/net/cfg80211.h  |   30 +++++
 net/wireless/core.c     |    6 +
 net/wireless/core.h     |    2 
 net/wireless/nl80211.c  |  257 ++++++++++++++++++++++++++++++++++++++----------
 5 files changed, 276 insertions(+), 49 deletions(-)

--- wireless-testing.orig/include/linux/nl80211.h	2010-09-27 16:29:42.000000000 +0200
+++ wireless-testing/include/linux/nl80211.h	2010-09-27 16:32:25.000000000 +0200
@@ -387,6 +387,21 @@
  *	of any other interfaces, and other interfaces will again take
  *	precedence when they are used.
  *
+ * @NL80211_CMD_START_P2P_LISTEN: Start P2P listen state, with device offload;
+ *	if not implemented but p2p is supported, @NL80211_CMD_REMAIN_ON_CHANNEL
+ *	will be used. Timing is specified via the attributes
+ *	%NL80211_ATTR_P2P_LISTEN_PERIOD, %NL80211_ATTR_P2P_LISTEN_INT_MIN and
+ *	%NL80211_ATTR_P2P_LISTEN_INT_MAX, where the period is optional if a
+ *	scan is also configured.
+ *	Additionally, scanning may be specified by passing at least the
+ *	%NL80211_ATTR_SCAN_SSIDS attribute (and optionally %NL80211_ATTR_IE
+ *	and %NL80211_ATTR_SCAN_FREQUENCIES.) If so, the driver will do the scan
+ *	(approximately) every listen period. If no listen period is specified,
+ *	it should be as quick as possible (essentially back-to-back as defined
+ *	in "3.1.2.1.3 Find Phase.")
+ *
+ * @NL80211_CMD_STOP_P2P_LISTEN: Stop a P2P listen/find phase.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -490,6 +505,9 @@ enum nl80211_commands {
 
 	NL80211_CMD_SET_CHANNEL,
 
+	NL80211_CMD_START_P2P_LISTEN,
+	NL80211_CMD_STOP_P2P_LISTEN,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -801,6 +819,14 @@ enum nl80211_commands {
  * @NL80211_ATTR_SUPPORT_IBSS_RSN: The device supports IBSS RSN, which mostly
  *	means support for per-station GTKs.
  *
+ * @NL80211_ATTR_P2P_LISTEN_PERIOD: The p2p listen period, specified in units
+ *	of 100 TU.
+ * @NL80211_ATTR_P2P_LISTEN_INT_MIN: The p2p listen discoverable interval min,
+ *	specified in units of 100 TU. Use the same as the max for extended
+ *	listen.
+ * @NL80211_ATTR_P2P_LISTEN_INT_MAX: The p2p listen discoverable interval max,
+ *	specified in utils of 100 TU.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -970,6 +996,10 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_SUPPORT_IBSS_RSN,
 
+	NL80211_ATTR_P2P_LISTEN_PERIOD,
+	NL80211_ATTR_P2P_LISTEN_INT_MIN,
+	NL80211_ATTR_P2P_LISTEN_INT_MAX,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
--- wireless-testing.orig/include/net/cfg80211.h	2010-09-27 16:29:42.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2010-09-27 16:32:25.000000000 +0200
@@ -978,6 +978,27 @@ struct cfg80211_pmksa {
 };
 
 /**
+ * struct p2p_listen_cfg - P2P listen configuration
+ * @dev: The device this operation is on
+ * @listen_chan: The listen channel
+ * @scan_req: additional scan request
+ * @listen_period: The periodicity of this listen request, may be zero
+ *	if there should be no pause (only if scan_req is also specified.)
+ *	Given in units of 100 TU.
+ * @listen_int_max: The time spent on the listen channel should be
+ *	randomized in each round between @listen_int_min and this,
+ *	both values are given in units of 100 TU.
+ * @listen_int_min: See @listen_int_max.
+ */
+struct p2p_listen_cfg {
+	struct net_device *dev;
+	struct ieee80211_channel *listen_chan;
+	struct cfg80211_scan_request *scan_req;
+	u32 listen_period;
+	u8 listen_int_max, listen_int_min;
+};
+
+/**
  * struct cfg80211_ops - backend description for wireless configuration
  *
  * This struct is registered by fullmac card drivers and/or wireless stacks
@@ -1112,6 +1133,8 @@ struct cfg80211_pmksa {
  * @set_power_mgmt: Configure WLAN power management. A timeout value of -1
  *	allows the driver to adjust the dynamic ps timeout value.
  * @set_cqm_rssi_config: Configure connection quality monitor RSSI threshold.
+ * @start_p2p_listen: start P2P listen operation
+ * @stop_p2p_listen: stop P2P listen operation
  *
  */
 struct cfg80211_ops {
@@ -1263,6 +1286,10 @@ struct cfg80211_ops {
 	int	(*set_cqm_rssi_config)(struct wiphy *wiphy,
 				       struct net_device *dev,
 				       s32 rssi_thold, u32 rssi_hyst);
+
+	int	(*start_p2p_listen)(struct wiphy *wiphy,
+				    struct p2p_listen_cfg *cfg);
+	void	(*stop_p2p_listen)(struct wiphy *wiphy, struct net_device *dev);
 };
 
 /*
@@ -1304,6 +1331,8 @@ struct cfg80211_ops {
  *	control port protocol ethertype. The device also honours the
  *	control_port_no_encrypt flag.
  * @WIPHY_FLAG_IBSS_RSN: The device supports IBSS RSN.
+ * @WIPHY_FLAG_SUPPORTS_P2P_LISTEN: The device supports the P2P listen
+ *	command (it must also support p2p device types.)
  */
 enum wiphy_flags {
 	WIPHY_FLAG_CUSTOM_REGULATORY		= BIT(0),
@@ -1315,6 +1344,7 @@ enum wiphy_flags {
 	WIPHY_FLAG_4ADDR_STATION		= BIT(6),
 	WIPHY_FLAG_CONTROL_PORT_PROTOCOL	= BIT(7),
 	WIPHY_FLAG_IBSS_RSN			= BIT(7),
+	WIPHY_FLAG_SUPPORTS_P2P_LISTEN		= BIT(8),
 };
 
 struct mac_address {
--- wireless-testing.orig/net/wireless/core.c	2010-09-27 16:29:08.000000000 +0200
+++ wireless-testing/net/wireless/core.c	2010-09-27 16:32:25.000000000 +0200
@@ -734,6 +734,12 @@ static int cfg80211_netdev_notifier_call
 			dev->priv_flags |= IFF_DONT_BRIDGE;
 		break;
 	case NETDEV_GOING_DOWN:
+		if (rdev->p2p_listen) {
+			rdev->ops->stop_p2p_listen(&rdev->wiphy, dev);
+			kfree(rdev->p2p_listen);
+			kfree(rdev->p2p_listen->scan_req);
+			rdev->p2p_listen = NULL;
+		}
 		switch (wdev->iftype) {
 		case NL80211_IFTYPE_ADHOC:
 			cfg80211_leave_ibss(rdev, dev, true);
--- wireless-testing.orig/net/wireless/core.h	2010-09-27 16:29:42.000000000 +0200
+++ wireless-testing/net/wireless/core.h	2010-09-27 16:32:25.000000000 +0200
@@ -67,6 +67,8 @@ struct cfg80211_registered_device {
 	struct genl_info *testmode_info;
 #endif
 
+	struct p2p_listen_cfg *p2p_listen;
+
 	struct work_struct conn_work;
 	struct work_struct event_work;
 
--- wireless-testing.orig/net/wireless/nl80211.c	2010-09-27 16:30:56.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2010-09-27 16:43:04.000000000 +0200
@@ -156,10 +156,12 @@ static const struct nla_policy nl80211_p
 	[NL80211_ATTR_CQM] = { .type = NLA_NESTED, },
 	[NL80211_ATTR_LOCAL_STATE_CHANGE] = { .type = NLA_FLAG },
 	[NL80211_ATTR_AP_ISOLATE] = { .type = NLA_U8 },
-
 	[NL80211_ATTR_WIPHY_TX_POWER_SETTING] = { .type = NLA_U32 },
 	[NL80211_ATTR_WIPHY_TX_POWER_LEVEL] = { .type = NLA_U32 },
 	[NL80211_ATTR_FRAME_TYPE] = { .type = NLA_U16 },
+	[NL80211_ATTR_P2P_LISTEN_PERIOD] = { .type = NLA_U32 },
+	[NL80211_ATTR_P2P_LISTEN_INT_MIN] = { .type = NLA_U8 },
+	[NL80211_ATTR_P2P_LISTEN_INT_MAX] = { .type = NLA_U8 },
 };
 
 /* policy for the key attributes */
@@ -622,6 +624,8 @@ static int nl80211_send_wiphy(struct sk_
 		NLA_PUT_U32(msg, i, NL80211_CMD_SET_WIPHY_NETNS);
 	}
 	CMD(set_channel, SET_CHANNEL);
+	if (dev->wiphy.flags & WIPHY_FLAG_SUPPORTS_P2P_LISTEN)
+		CMD(start_p2p_listen, START_P2P_LISTEN);
 
 #undef CMD
 
@@ -3206,52 +3210,27 @@ static int validate_scan_freqs(struct nl
 	return n_channels;
 }
 
-static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
+static struct cfg80211_scan_request *
+nl80211_build_scan_req(struct cfg80211_registered_device *rdev,
+		       struct net_device *dev, struct genl_info *info)
 {
-	struct cfg80211_registered_device *rdev;
-	struct net_device *dev;
+	struct wiphy *wiphy = &rdev->wiphy;
 	struct cfg80211_scan_request *request;
 	struct cfg80211_ssid *ssid;
 	struct ieee80211_channel *channel;
 	struct nlattr *attr;
-	struct wiphy *wiphy;
 	int err, tmp, n_ssids = 0, n_channels, i;
 	enum ieee80211_band band;
 	size_t ie_len;
 
 	if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_IE]))
-		return -EINVAL;
-
-	rtnl_lock();
-
-	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
-	if (err)
-		goto out_rtnl;
-
-	wiphy = &rdev->wiphy;
-
-	if (!rdev->ops->scan) {
-		err = -EOPNOTSUPP;
-		goto out;
-	}
-
-	if (!netif_running(dev)) {
-		err = -ENETDOWN;
-		goto out;
-	}
-
-	if (rdev->scan_req) {
-		err = -EBUSY;
-		goto out;
-	}
+		return ERR_PTR(-EINVAL);
 
 	if (info->attrs[NL80211_ATTR_SCAN_FREQUENCIES]) {
 		n_channels = validate_scan_freqs(
 				info->attrs[NL80211_ATTR_SCAN_FREQUENCIES]);
-		if (!n_channels) {
-			err = -EINVAL;
-			goto out;
-		}
+		if (!n_channels)
+			return ERR_PTR(-EINVAL);
 	} else {
 		n_channels = 0;
 
@@ -3264,29 +3243,23 @@ static int nl80211_trigger_scan(struct s
 		nla_for_each_nested(attr, info->attrs[NL80211_ATTR_SCAN_SSIDS], tmp)
 			n_ssids++;
 
-	if (n_ssids > wiphy->max_scan_ssids) {
-		err = -EINVAL;
-		goto out;
-	}
+	if (n_ssids > wiphy->max_scan_ssids)
+		return ERR_PTR(-EINVAL);
 
 	if (info->attrs[NL80211_ATTR_IE])
 		ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
 	else
 		ie_len = 0;
 
-	if (ie_len > wiphy->max_scan_ie_len) {
-		err = -EINVAL;
-		goto out;
-	}
+	if (ie_len > wiphy->max_scan_ie_len)
+		return ERR_PTR(-EINVAL);
 
 	request = kzalloc(sizeof(*request)
 			+ sizeof(*ssid) * n_ssids
 			+ sizeof(channel) * n_channels
 			+ ie_len, GFP_KERNEL);
-	if (!request) {
-		err = -ENOMEM;
-		goto out;
-	}
+	if (!request)
+		return ERR_PTR(-ENOMEM);
 
 	if (n_ssids)
 		request->ssids = (void *)&request->channels[n_channels];
@@ -3368,16 +3341,54 @@ static int nl80211_trigger_scan(struct s
 	request->dev = dev;
 	request->wiphy = &rdev->wiphy;
 
+	return request;
+
+ out_free:
+	kfree(request);
+	return ERR_PTR(err);
+}
+
+static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev;
+	struct net_device *dev;
+	struct cfg80211_scan_request *request;
+	int err;
+
+	rtnl_lock();
+
+	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
+	if (err)
+		goto out_rtnl;
+
+	if (!rdev->ops->scan) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	if (!netif_running(dev)) {
+		err = -ENETDOWN;
+		goto out;
+	}
+
+	if (rdev->scan_req) {
+		err = -EBUSY;
+		goto out;
+	}
+
+	request = nl80211_build_scan_req(rdev, dev, info);
+	if (IS_ERR(request)) {
+		err = PTR_ERR(request);
+		goto out;
+	}
+
 	rdev->scan_req = request;
 	err = rdev->ops->scan(&rdev->wiphy, dev, request);
 
 	if (!err) {
 		nl80211_send_scan_start(rdev, dev);
 		dev_hold(dev);
-	}
-
- out_free:
-	if (err) {
+	} else {
 		rdev->scan_req = NULL;
 		kfree(request);
 	}
@@ -5235,6 +5246,142 @@ out:
 	return err;
 }
 
+static int nl80211_start_p2p_listen(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev;
+	struct wireless_dev *wdev;
+	struct net_device *dev;
+	struct ieee80211_channel *chan;
+	struct cfg80211_scan_request *scan_req;
+	struct p2p_listen_cfg *cfg;
+	int err;
+	u8 listen_min, listen_max;
+
+	if (!info->attrs[NL80211_ATTR_P2P_LISTEN_INT_MAX] ||
+	    !info->attrs[NL80211_ATTR_P2P_LISTEN_INT_MIN] ||
+	    !info->attrs[NL80211_ATTR_WIPHY_FREQ])
+		return -EINVAL;
+
+	listen_min = nla_get_u8(info->attrs[NL80211_ATTR_P2P_LISTEN_INT_MIN]);
+	listen_max = nla_get_u8(info->attrs[NL80211_ATTR_P2P_LISTEN_INT_MAX]);
+
+	if (listen_min > listen_max || listen_min > 20 || listen_max > 20)
+		return -EINVAL;
+
+	rtnl_lock();
+
+	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
+	if (err)
+		goto unlock_rdev;
+
+	if (rdev->p2p_listen) {
+		err = -EBUSY;
+		goto unlock_rdev;
+	}
+
+	wdev = dev->ieee80211_ptr;
+
+	if (wdev->iftype != NL80211_IFTYPE_P2P_CLIENT &&
+	    wdev->iftype != NL80211_IFTYPE_P2P_GO) {
+		err = -EOPNOTSUPP;
+		goto unlock_rdev;
+	}
+
+	if (!rdev->ops->start_p2p_listen ||
+	    !(rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_P2P_LISTEN)) {
+		err = -EOPNOTSUPP;
+		goto unlock_rdev;
+	}
+
+	chan = ieee80211_get_channel(&rdev->wiphy,
+		nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]));
+	if (!chan || (chan->flags & IEEE80211_CHAN_DISABLED)) {
+		err = -EINVAL;
+		goto unlock_rdev;
+	}
+
+	if (info->attrs[NL80211_ATTR_SCAN_SSIDS]) {
+		scan_req = nl80211_build_scan_req(rdev, dev, info);
+		if (IS_ERR(scan_req)) {
+			err = PTR_ERR(scan_req);
+			goto unlock_rdev;
+		}
+	} else {
+		scan_req = NULL;
+		if (!info->attrs[NL80211_ATTR_P2P_LISTEN_PERIOD]) {
+			err = -EINVAL;
+			goto unlock_rdev;
+		}
+	}
+
+	cfg = kzalloc(sizeof(*cfg), GFP_KERNEL);
+	if (!cfg) {
+		err = -ENOMEM;
+		goto free_scan;
+	}
+
+	cfg->dev = dev;
+	cfg->listen_chan = chan;
+	cfg->scan_req = scan_req;
+	cfg->listen_int_min = listen_min;
+	cfg->listen_int_max = listen_max;
+	if (info->attrs[NL80211_ATTR_P2P_LISTEN_PERIOD])
+		cfg->listen_period =
+			nla_get_u32(info->attrs[NL80211_ATTR_P2P_LISTEN_PERIOD]);
+
+	rdev->p2p_listen = cfg;
+
+	err = rdev->ops->start_p2p_listen(wdev->wiphy, cfg);
+	if (err) {
+		rdev->p2p_listen = NULL;
+		kfree(cfg);
+		/* scan request freed below */
+	} else {
+		/* don't free scan request */
+		scan_req = NULL;
+	}
+
+ free_scan:
+	kfree(scan_req);
+ unlock_rdev:
+	cfg80211_unlock_rdev(rdev);
+	dev_put(dev);
+	rtnl_unlock();
+	return err;
+}
+
+static int nl80211_stop_p2p_listen(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev;
+	struct wireless_dev *wdev;
+	struct net_device *dev;
+	int err;
+
+	rtnl_lock();
+
+	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
+	if (err)
+		goto unlock_rdev;
+
+	wdev = dev->ieee80211_ptr;
+
+	if (!rdev->p2p_listen || rdev->p2p_listen->dev != dev) {
+		err = -ENOENT;
+		goto unlock_rdev;
+	}
+
+	rdev->ops->stop_p2p_listen(wdev->wiphy, dev);
+	kfree(rdev->p2p_listen);
+	kfree(rdev->p2p_listen->scan_req);
+	rdev->p2p_listen = NULL;
+
+ unlock_rdev:
+	cfg80211_unlock_rdev(rdev);
+	dev_put(dev);
+	rtnl_unlock();
+	return err;
+}
+
 static struct genl_ops nl80211_ops[] = {
 	{
 		.cmd = NL80211_CMD_GET_WIPHY,
@@ -5551,6 +5698,18 @@ static struct genl_ops nl80211_ops[] = {
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
+	{
+		.cmd = NL80211_CMD_START_P2P_LISTEN,
+		.doit = nl80211_start_p2p_listen,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = NL80211_CMD_STOP_P2P_LISTEN,
+		.doit = nl80211_stop_p2p_listen,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
 };
 
 static struct genl_multicast_group nl80211_mlme_mcgrp = {


