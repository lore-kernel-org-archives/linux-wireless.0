Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59240 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932243Ab0JDTMG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 15:12:06 -0400
Subject: [RFC v3] cfg80211: add p2p listen API
From: Johannes Berg <johannes@sipsolutions.net>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1285600089.4043.22.camel@jlt3.sipsolutions.net>
References: <1285584358.4043.11.camel@jlt3.sipsolutions.net>
	 <1285600089.4043.22.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Oct 2010 21:12:04 +0200
Message-ID: <1286219524.3620.57.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This version now actually works! :-)

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
 include/linux/nl80211.h |   30 +++++++
 include/net/cfg80211.h  |   33 ++++++++
 net/wireless/core.c     |    6 +
 net/wireless/core.h     |    2 
 net/wireless/nl80211.c  |  186 +++++++++++++++++++++++++++++++++++++++++-------
 net/wireless/nl80211.h  |    6 -
 net/wireless/scan.c     |   50 ++++++++----
 net/wireless/sme.c      |    2 
 8 files changed, 268 insertions(+), 47 deletions(-)

--- wireless-testing.orig/include/linux/nl80211.h	2010-10-04 20:25:42.000000000 +0200
+++ wireless-testing/include/linux/nl80211.h	2010-10-04 20:25:42.000000000 +0200
@@ -399,6 +399,21 @@
  *	If used as the command, must have an interface index, and you can
  *	only unsubscribe from the event by closing the socket.
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
@@ -504,6 +519,9 @@ enum nl80211_commands {
 
 	NL80211_CMD_UNEXPECTED_FRAME,
 
+	NL80211_CMD_START_P2P_LISTEN,
+	NL80211_CMD_STOP_P2P_LISTEN,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -815,6 +833,14 @@ enum nl80211_commands {
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
@@ -984,6 +1010,10 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_SUPPORT_IBSS_RSN,
 
+	NL80211_ATTR_P2P_LISTEN_PERIOD,
+	NL80211_ATTR_P2P_LISTEN_INT_MIN,
+	NL80211_ATTR_P2P_LISTEN_INT_MAX,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
--- wireless-testing.orig/include/net/cfg80211.h	2010-10-04 20:25:42.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2010-10-04 20:25:42.000000000 +0200
@@ -667,6 +667,7 @@ struct cfg80211_ssid {
  * @wiphy: the wiphy this was for
  * @dev: the interface
  * @aborted: (internal) scan request was notified as aborted
+ * @done: (internal) scan request was marked done
  */
 struct cfg80211_scan_request {
 	struct cfg80211_ssid *ssids;
@@ -678,7 +679,7 @@ struct cfg80211_scan_request {
 	/* internal */
 	struct wiphy *wiphy;
 	struct net_device *dev;
-	bool aborted;
+	bool aborted, done;
 
 	/* keep last */
 	struct ieee80211_channel *channels[0];
@@ -978,6 +979,27 @@ struct cfg80211_pmksa {
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
@@ -1112,6 +1134,8 @@ struct cfg80211_pmksa {
  * @set_power_mgmt: Configure WLAN power management. A timeout value of -1
  *	allows the driver to adjust the dynamic ps timeout value.
  * @set_cqm_rssi_config: Configure connection quality monitor RSSI threshold.
+ * @start_p2p_listen: start P2P listen operation
+ * @stop_p2p_listen: stop P2P listen operation
  *
  */
 struct cfg80211_ops {
@@ -1263,6 +1287,10 @@ struct cfg80211_ops {
 	int	(*set_cqm_rssi_config)(struct wiphy *wiphy,
 				       struct net_device *dev,
 				       s32 rssi_thold, u32 rssi_hyst);
+
+	int	(*start_p2p_listen)(struct wiphy *wiphy,
+				    struct p2p_listen_cfg *cfg);
+	void	(*stop_p2p_listen)(struct wiphy *wiphy, struct net_device *dev);
 };
 
 /*
@@ -1304,6 +1332,8 @@ struct cfg80211_ops {
  *	control port protocol ethertype. The device also honours the
  *	control_port_no_encrypt flag.
  * @WIPHY_FLAG_IBSS_RSN: The device supports IBSS RSN.
+ * @WIPHY_FLAG_SUPPORTS_P2P_LISTEN: The device supports the P2P listen
+ *	command (it must also support p2p device types.)
  */
 enum wiphy_flags {
 	WIPHY_FLAG_CUSTOM_REGULATORY		= BIT(0),
@@ -1315,6 +1345,7 @@ enum wiphy_flags {
 	WIPHY_FLAG_4ADDR_STATION		= BIT(6),
 	WIPHY_FLAG_CONTROL_PORT_PROTOCOL	= BIT(7),
 	WIPHY_FLAG_IBSS_RSN			= BIT(7),
+	WIPHY_FLAG_SUPPORTS_P2P_LISTEN		= BIT(8),
 };
 
 struct mac_address {
--- wireless-testing.orig/net/wireless/core.c	2010-10-04 20:24:44.000000000 +0200
+++ wireless-testing/net/wireless/core.c	2010-10-04 20:25:42.000000000 +0200
@@ -734,6 +734,12 @@ static int cfg80211_netdev_notifier_call
 			dev->priv_flags |= IFF_DONT_BRIDGE;
 		break;
 	case NETDEV_GOING_DOWN:
+		if (rdev->p2p_listen && rdev->p2p_listen->dev == dev) {
+			rdev->ops->stop_p2p_listen(&rdev->wiphy, dev);
+			kfree(rdev->p2p_listen->scan_req);
+			kfree(rdev->p2p_listen);
+			rdev->p2p_listen = NULL;
+		}
 		switch (wdev->iftype) {
 		case NL80211_IFTYPE_ADHOC:
 			cfg80211_leave_ibss(rdev, dev, true);
--- wireless-testing.orig/net/wireless/core.h	2010-10-04 20:25:42.000000000 +0200
+++ wireless-testing/net/wireless/core.h	2010-10-04 20:25:42.000000000 +0200
@@ -67,6 +67,8 @@ struct cfg80211_registered_device {
 	struct genl_info *testmode_info;
 #endif
 
+	struct p2p_listen_cfg *p2p_listen;
+
 	struct work_struct conn_work;
 	struct work_struct event_work;
 
--- wireless-testing.orig/net/wireless/nl80211.c	2010-10-04 20:25:42.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2010-10-04 20:27:05.000000000 +0200
@@ -163,10 +163,12 @@ static const struct nla_policy nl80211_p
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
@@ -667,6 +669,8 @@ static int nl80211_send_wiphy(struct sk_
 		NLA_PUT_U32(msg, i, NL80211_CMD_SET_WIPHY_NETNS);
 	}
 	CMD(set_channel, SET_CHANNEL);
+	if (dev->wiphy.flags & WIPHY_FLAG_SUPPORTS_P2P_LISTEN)
+		CMD(start_p2p_listen, START_P2P_LISTEN);
 
 #undef CMD
 
@@ -2813,7 +2817,8 @@ static int validate_scan_freqs(struct nl
 	return n_channels;
 }
 
-static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
+static struct cfg80211_scan_request *
+nl80211_build_scan_req(struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct net_device *dev = info->user_ptr[1];
@@ -2827,21 +2832,15 @@ static int nl80211_trigger_scan(struct s
 	size_t ie_len;
 
 	if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_IE]))
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 
 	wiphy = &rdev->wiphy;
 
-	if (!rdev->ops->scan)
-		return -EOPNOTSUPP;
-
-	if (rdev->scan_req)
-		return -EBUSY;
-
 	if (info->attrs[NL80211_ATTR_SCAN_FREQUENCIES]) {
 		n_channels = validate_scan_freqs(
 				info->attrs[NL80211_ATTR_SCAN_FREQUENCIES]);
 		if (!n_channels)
-			return -EINVAL;
+			return ERR_PTR(-EINVAL);
 	} else {
 		n_channels = 0;
 
@@ -2855,7 +2854,7 @@ static int nl80211_trigger_scan(struct s
 			n_ssids++;
 
 	if (n_ssids > wiphy->max_scan_ssids)
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 
 	if (info->attrs[NL80211_ATTR_IE])
 		ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
@@ -2863,14 +2862,14 @@ static int nl80211_trigger_scan(struct s
 		ie_len = 0;
 
 	if (ie_len > wiphy->max_scan_ie_len)
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 
 	request = kzalloc(sizeof(*request)
 			+ sizeof(*ssid) * n_ssids
 			+ sizeof(channel) * n_channels
 			+ ie_len, GFP_KERNEL);
 	if (!request)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	if (n_ssids)
 		request->ssids = (void *)&request->channels[n_channels];
@@ -2952,14 +2951,36 @@ static int nl80211_trigger_scan(struct s
 	request->dev = dev;
 	request->wiphy = &rdev->wiphy;
 
+	return request;
+ out_free:
+	kfree(request);
+	return ERR_PTR(err);
+}
+
+static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct cfg80211_scan_request *request;
+	int err;
+
+	if (!rdev->ops->scan)
+		return -EOPNOTSUPP;
+
+	if (rdev->scan_req)
+		return -EBUSY;
+
+	request = nl80211_build_scan_req(info);
+	if (IS_ERR(request))
+		return PTR_ERR(request);
+
 	rdev->scan_req = request;
 	err = rdev->ops->scan(&rdev->wiphy, dev, request);
 
 	if (!err) {
-		nl80211_send_scan_start(rdev, dev);
+		nl80211_send_scan_start(rdev, request);
 		dev_hold(dev);
 	} else {
- out_free:
 		rdev->scan_req = NULL;
 		kfree(request);
 	}
@@ -4407,6 +4428,103 @@ static void nl80211_post_doit(struct gen
 		rtnl_unlock();
 }
 
+static int nl80211_start_p2p_listen(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
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
+	if (rdev->p2p_listen)
+		return -EBUSY;
+
+	if (wdev->iftype != NL80211_IFTYPE_P2P_CLIENT)
+		return -EOPNOTSUPP;
+
+	if (!rdev->ops->start_p2p_listen ||
+	    !(rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_P2P_LISTEN))
+		return -EOPNOTSUPP;
+
+	chan = ieee80211_get_channel(&rdev->wiphy,
+		nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]));
+	if (!chan || (chan->flags & IEEE80211_CHAN_DISABLED))
+		return -EINVAL;
+
+	if (info->attrs[NL80211_ATTR_SCAN_SSIDS]) {
+		scan_req = nl80211_build_scan_req(info);
+		if (IS_ERR(scan_req))
+			return PTR_ERR(scan_req);
+	} else {
+		scan_req = NULL;
+		if (!info->attrs[NL80211_ATTR_P2P_LISTEN_PERIOD] ||
+		    !nla_get_u32(info->attrs[NL80211_ATTR_P2P_LISTEN_PERIOD]))
+			return -EINVAL;
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
+	return err;
+}
+
+static int nl80211_stop_p2p_listen(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+
+	if (!rdev->p2p_listen || rdev->p2p_listen->dev != dev)
+		return -ENOENT;
+
+	rdev->ops->stop_p2p_listen(wdev->wiphy, dev);
+	kfree(rdev->p2p_listen->scan_req);
+	kfree(rdev->p2p_listen);
+	rdev->p2p_listen = NULL;
+
+	return 0;
+}
+
 static struct genl_ops nl80211_ops[] = {
 	{
 		.cmd = NL80211_CMD_GET_WIPHY,
@@ -4822,6 +4940,22 @@ static struct genl_ops nl80211_ops[] = {
 		.internal_flags = NL80211_FLAG_NEED_NETDEV |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL80211_CMD_START_P2P_LISTEN,
+		.doit = nl80211_start_p2p_listen,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
+	{
+		.cmd = NL80211_CMD_STOP_P2P_LISTEN,
+		.doit = nl80211_stop_p2p_listen,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
 };
 
 static struct genl_multicast_group nl80211_mlme_mcgrp = {
@@ -4859,9 +4993,9 @@ void nl80211_notify_dev_rename(struct cf
 }
 
 static int nl80211_add_scan_req(struct sk_buff *msg,
-				struct cfg80211_registered_device *rdev)
+				struct cfg80211_registered_device *rdev,
+				struct cfg80211_scan_request *req)
 {
-	struct cfg80211_scan_request *req = rdev->scan_req;
 	struct nlattr *nest;
 	int i;
 
@@ -4894,7 +5028,7 @@ static int nl80211_add_scan_req(struct s
 
 static int nl80211_send_scan_msg(struct sk_buff *msg,
 				 struct cfg80211_registered_device *rdev,
-				 struct net_device *netdev,
+				 struct cfg80211_scan_request *request,
 				 u32 pid, u32 seq, int flags,
 				 u32 cmd)
 {
@@ -4905,10 +5039,10 @@ static int nl80211_send_scan_msg(struct
 		return -1;
 
 	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx);
-	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex);
+	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, request->dev->ifindex);
 
 	/* ignore errors and send incomplete event anyway */
-	nl80211_add_scan_req(msg, rdev);
+	nl80211_add_scan_req(msg, rdev, request);
 
 	return genlmsg_end(msg, hdr);
 
@@ -4918,7 +5052,7 @@ static int nl80211_send_scan_msg(struct
 }
 
 void nl80211_send_scan_start(struct cfg80211_registered_device *rdev,
-			     struct net_device *netdev)
+			     struct cfg80211_scan_request *request)
 {
 	struct sk_buff *msg;
 
@@ -4926,7 +5060,7 @@ void nl80211_send_scan_start(struct cfg8
 	if (!msg)
 		return;
 
-	if (nl80211_send_scan_msg(msg, rdev, netdev, 0, 0, 0,
+	if (nl80211_send_scan_msg(msg, rdev, request, 0, 0, 0,
 				  NL80211_CMD_TRIGGER_SCAN) < 0) {
 		nlmsg_free(msg);
 		return;
@@ -4937,7 +5071,7 @@ void nl80211_send_scan_start(struct cfg8
 }
 
 void nl80211_send_scan_done(struct cfg80211_registered_device *rdev,
-			    struct net_device *netdev)
+			    struct cfg80211_scan_request *request)
 {
 	struct sk_buff *msg;
 
@@ -4945,7 +5079,7 @@ void nl80211_send_scan_done(struct cfg80
 	if (!msg)
 		return;
 
-	if (nl80211_send_scan_msg(msg, rdev, netdev, 0, 0, 0,
+	if (nl80211_send_scan_msg(msg, rdev, request, 0, 0, 0,
 				  NL80211_CMD_NEW_SCAN_RESULTS) < 0) {
 		nlmsg_free(msg);
 		return;
@@ -4956,7 +5090,7 @@ void nl80211_send_scan_done(struct cfg80
 }
 
 void nl80211_send_scan_aborted(struct cfg80211_registered_device *rdev,
-			       struct net_device *netdev)
+			       struct cfg80211_scan_request *request)
 {
 	struct sk_buff *msg;
 
@@ -4964,7 +5098,7 @@ void nl80211_send_scan_aborted(struct cf
 	if (!msg)
 		return;
 
-	if (nl80211_send_scan_msg(msg, rdev, netdev, 0, 0, 0,
+	if (nl80211_send_scan_msg(msg, rdev, request, 0, 0, 0,
 				  NL80211_CMD_SCAN_ABORTED) < 0) {
 		nlmsg_free(msg);
 		return;
--- wireless-testing.orig/net/wireless/scan.c	2010-10-04 20:24:44.000000000 +0200
+++ wireless-testing/net/wireless/scan.c	2010-10-04 20:34:21.000000000 +0200
@@ -19,21 +19,15 @@
 
 #define IEEE80211_SCAN_RESULT_EXPIRE	(15 * HZ)
 
-void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev, bool leak)
+static void ____cfg80211_scan_done(struct cfg80211_registered_device *rdev,
+				   struct cfg80211_scan_request *request,
+				   bool leak, bool p2p)
 {
-	struct cfg80211_scan_request *request;
 	struct net_device *dev;
 #ifdef CONFIG_CFG80211_WEXT
 	union iwreq_data wrqu;
 #endif
 
-	ASSERT_RDEV_LOCK(rdev);
-
-	request = rdev->scan_req;
-
-	if (!request)
-		return;
-
 	dev = request->dev;
 
 	/*
@@ -44,9 +38,9 @@ void ___cfg80211_scan_done(struct cfg802
 	cfg80211_sme_scan_done(dev);
 
 	if (request->aborted)
-		nl80211_send_scan_aborted(rdev, dev);
+		nl80211_send_scan_aborted(rdev, request);
 	else
-		nl80211_send_scan_done(rdev, dev);
+		nl80211_send_scan_done(rdev, request);
 
 #ifdef CONFIG_CFG80211_WEXT
 	if (!request->aborted) {
@@ -56,9 +50,9 @@ void ___cfg80211_scan_done(struct cfg802
 	}
 #endif
 
-	dev_put(dev);
-
-	rdev->scan_req = NULL;
+	/* p2p scans don't hold a netdev reference */
+	if (!p2p)
+		dev_put(dev);
 
 	/*
 	 * OK. If this is invoked with "leak" then we can't
@@ -72,6 +66,23 @@ void ___cfg80211_scan_done(struct cfg802
 		kfree(request);
 }
 
+void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev, bool leak)
+{
+	ASSERT_RDEV_LOCK(rdev);
+
+	if (rdev->scan_req && rdev->scan_req->done) {
+		____cfg80211_scan_done(rdev, rdev->scan_req, leak, false);
+		rdev->scan_req = NULL;
+	}
+
+	if (rdev->p2p_listen && rdev->p2p_listen->scan_req &&
+	    rdev->p2p_listen->scan_req->done) {
+		____cfg80211_scan_done(rdev, rdev->p2p_listen->scan_req,
+				       true, true);
+		rdev->p2p_listen->scan_req->done = false;
+	}
+}
+
 void __cfg80211_scan_done(struct work_struct *wk)
 {
 	struct cfg80211_registered_device *rdev;
@@ -86,9 +97,16 @@ void __cfg80211_scan_done(struct work_st
 
 void cfg80211_scan_done(struct cfg80211_scan_request *request, bool aborted)
 {
-	WARN_ON(request != wiphy_to_dev(request->wiphy)->scan_req);
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(request->wiphy);
+
+	if (WARN_ON(!request))
+		return;
+
+	WARN_ON(request != rdev->scan_req &&
+		(!rdev->p2p_listen || request != rdev->p2p_listen->scan_req));
 
 	request->aborted = aborted;
+	request->done = true;
 	queue_work(cfg80211_wq, &wiphy_to_dev(request->wiphy)->scan_done_wk);
 }
 EXPORT_SYMBOL(cfg80211_scan_done);
@@ -779,7 +797,7 @@ int cfg80211_wext_siwscan(struct net_dev
 		rdev->scan_req = NULL;
 		/* creq will be freed below */
 	} else {
-		nl80211_send_scan_start(rdev, dev);
+		nl80211_send_scan_start(rdev, creq);
 		/* creq now owned by driver */
 		creq = NULL;
 		dev_hold(dev);
--- wireless-testing.orig/net/wireless/nl80211.h	2010-10-04 20:25:42.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.h	2010-10-04 20:26:08.000000000 +0200
@@ -7,11 +7,11 @@ int nl80211_init(void);
 void nl80211_exit(void);
 void nl80211_notify_dev_rename(struct cfg80211_registered_device *rdev);
 void nl80211_send_scan_start(struct cfg80211_registered_device *rdev,
-			     struct net_device *netdev);
+			     struct cfg80211_scan_request *request);
 void nl80211_send_scan_done(struct cfg80211_registered_device *rdev,
-			    struct net_device *netdev);
+			    struct cfg80211_scan_request *request);
 void nl80211_send_scan_aborted(struct cfg80211_registered_device *rdev,
-			       struct net_device *netdev);
+			       struct cfg80211_scan_request *request);
 void nl80211_send_reg_change_event(struct regulatory_request *request);
 void nl80211_send_rx_auth(struct cfg80211_registered_device *rdev,
 			  struct net_device *netdev,
--- wireless-testing.orig/net/wireless/sme.c	2010-10-04 20:34:27.000000000 +0200
+++ wireless-testing/net/wireless/sme.c	2010-10-04 20:34:36.000000000 +0200
@@ -136,7 +136,7 @@ static int cfg80211_conn_scan(struct wir
 	err = rdev->ops->scan(wdev->wiphy, wdev->netdev, request);
 	if (!err) {
 		wdev->conn->state = CFG80211_CONN_SCANNING;
-		nl80211_send_scan_start(rdev, wdev->netdev);
+		nl80211_send_scan_start(rdev, request);
 		dev_hold(wdev->netdev);
 	} else {
 		rdev->scan_req = NULL;


