Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40944 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315AbbAPJsg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2015 04:48:36 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 1/2] nl80211: support per-rate/per-station statistics
Date: Fri, 16 Jan 2015 10:48:27 +0100
Message-Id: <1421401708-8123-1-git-send-email-johannes@sipsolutions.net> (sfid-20150116_104900_920207_8E62D548)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Per-rate/per-station statistics can be desirable to have but they're
quite expensive (keeping the four counters for each rate would take
close to 4k of memory per station only for VHT MCSes for a moderately
capable VHT chip (with 2 spatial streams and 80MHz support) so it's
not a good idea to keep all of this in the kernel. Using a hash table
instead can be done, but then addressing becomes more expensive.

Instead, this API provides a way for interested clients in userspace
to subscribe to such statistics. When supported by a driver, it can
then start collecting the data only when subscribers exist. To avoid
the kernel's data collection becoming too big, it can send out the
data at any point in time, for example to limit the counters to u32
internally and send it out when they're close to reaching the limit,
or to keep a hash table and sending it out when too many collisions
occur. Userspace can then keep track of the full state.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h       |  43 +++++++++
 include/uapi/linux/nl80211.h |  76 ++++++++++++++++
 net/wireless/core.c          |  17 ++++
 net/wireless/nl80211.c       | 208 +++++++++++++++++++++++++++++++++++++------
 net/wireless/nl80211.h       |  15 ++++
 net/wireless/rdev-ops.h      |  10 +++
 net/wireless/trace.h         |  14 +++
 7 files changed, 355 insertions(+), 28 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 7b44ba0a7632..0b9ac3af1853 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2143,6 +2143,21 @@ struct cfg80211_qos_map {
 };
 
 /**
+ * enum cfg80211_rate_stats_ops - rate statistics operations
+ *
+ * @CFG80211_RATE_STATS_START: start data collection
+ * @CFG80211_RATE_STATS_DUMP: atomically dump and clear the data
+ *	(using cfg80211_report_rate_stats() to report it); this
+ *	should be done before the function call returns
+ * @CFG80211_RATE_STATS_STOP: stop data collection
+ */
+enum cfg80211_rate_stats_ops {
+	CFG80211_RATE_STATS_START,
+	CFG80211_RATE_STATS_DUMP,
+	CFG80211_RATE_STATS_STOP,
+};
+
+/**
  * struct cfg80211_ops - backend description for wireless configuration
  *
  * This struct is registered by fullmac card drivers and/or wireless stacks
@@ -2410,6 +2425,9 @@ struct cfg80211_qos_map {
  *	and returning to the base channel for communication with the AP.
  * @tdls_cancel_channel_switch: Stop channel-switching with a TDLS peer. Both
  *	peers must be on the base channel when the call completes.
+ *
+ * @rate_stats: rate statistics operation - if supported all operations must be
+ *	supported, see &enum cfg80211_rate_stats_ops.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -2673,6 +2691,9 @@ struct cfg80211_ops {
 	void	(*tdls_cancel_channel_switch)(struct wiphy *wiphy,
 					      struct net_device *dev,
 					      const u8 *addr);
+
+	void	(*rate_stats)(struct wiphy *wiphy,
+			      enum cfg80211_rate_stats_ops op);
 };
 
 /*
@@ -5094,6 +5115,28 @@ wiphy_ext_feature_isset(struct wiphy *wiphy,
 	return (ft_byte & BIT(ftidx % 8)) != 0;
 }
 
+/* rate statistics */
+struct cfg80211_rate_stats {
+	struct rate_info rate;
+	struct cfg80211_tid_stats stats;
+};
+
+/**
+ * cfg80211_report_rate_stats - report rate statistics for a station
+ * @wiphy: the wiphy that's reporting the data
+ * @wdev: the virtual interface the data is reported for
+ * @addr: the station MAC address
+ * @n_stats: length of statistics array
+ * @stats: array of per-rate statistics
+ * @gfp: allocation flags
+ *
+ * Note that it is valid to call this function multiple times even for the
+ * same station, if the data isn't actually stored in an array.
+ */
+void cfg80211_report_rate_stats(struct wiphy *wiphy, struct wireless_dev *wdev,
+				const u8 *addr, unsigned int n_stats,
+				struct cfg80211_rate_stats *stats, gfp_t gfp);
+
 /* ethtool helper */
 void cfg80211_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info);
 
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index f52797a90816..d03e3caef505 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -35,6 +35,7 @@
 #define NL80211_MULTICAST_GROUP_MLME		"mlme"
 #define NL80211_MULTICAST_GROUP_VENDOR		"vendor"
 #define NL80211_MULTICAST_GROUP_TESTMODE	"testmode"
+#define NL80211_MULTICAST_GROUP_RATESTATS	"rate-stats"
 
 /**
  * DOC: Station handling
@@ -796,6 +797,10 @@
  *	as an event to indicate changes for devices with wiphy-specific regdom
  *	management.
  *
+ * @NL80211_CMD_GET_RATE_STATISTICS: This command can be used to trigger the
+ *	rate statistics dump to userspace, which also clears the data in the
+ *	kernel (driver). See the "per-rate statistics" documentation section.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -982,6 +987,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_WIPHY_REG_CHANGE,
 
+	NL80211_CMD_GET_RATE_STATISTICS,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -1735,6 +1742,9 @@ enum nl80211_commands {
  *	should be contained in the result as the sum of the respective counters
  *	over all channels.
  *
+ * @NL80211_ATTR_RATE_STATS: per-rate statistics container attribute, this is
+ *	contains the attributes from &enum nl80211_rate_stats.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2098,6 +2108,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_SURVEY_RADIO_STATS,
 
+	NL80211_ATTR_RATE_STATS,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -4318,10 +4330,13 @@ enum nl80211_feature_flags {
 /**
  * enum nl80211_ext_feature_index - bit index of extended features.
  *
+ * @NL80211_EXT_FEATURE_RATE_STATS: This device supports the per-rate
+ *	statistics subscription API.
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
  */
 enum nl80211_ext_feature_index {
+	NL80211_EXT_FEATURE_RATE_STATS,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
@@ -4547,4 +4562,65 @@ enum nl80211_tdls_peer_capability {
 	NL80211_TDLS_PEER_WMM = 1<<2,
 };
 
+/**
+ * DOC: per-rate statistics
+ *
+ * The nl80211 API provides a way to subscribe to per-bitrate statistics. Since
+ * there are many bitrates it isn't always desirable to keep statistics for all
+ * of the rates in the kernel. As a consequence, the API allows the drivers to
+ * dump the information to userspace and reset their internal values. As it can
+ * also be expensive to keep the counters, this is only done when subscribers
+ * exist.
+ *
+ * To use this facility, a userspace client must subscribe to the data using the
+ * rate statistics multicast group (%NL80211_MULTICAST_GROUP_RATESTATS). This is
+ * used by the kernel to start data collection. If, at this point, other clients
+ * exist, those are also sent the current statistics in order to allow the new
+ * client to collect only the data obtained while subscribed.
+ *
+ * While subscribed, the client must listen for %NL80211_CMD_GET_RATE_STATISTICS
+ * events sent to the subscribed socket, and accumulate data retrieved in them.
+ * Every time such an event is sent by the kernel, the in-kernel data is also
+ * cleared. Therefore, to achieve data collection over longer periods of time,
+ * the subscribers must accumulate data. No guarantees are made about how long
+ * the kernel will collect data, but (as an implementation guideline) the data
+ * shouldn't be sent out frequently, and only while traffic is keeping the CPU
+ * busy anyway (i.e. it is recommended to not use timers in drivers supporting
+ * this facility.)
+ *
+ * In order to obtain a sample or clear the statistics at a given point in time,
+ * the %NL80211_CMD_GET_RATE_STATISTICS command can be used. This command can
+ * be called by any nl80211 client (even non-subscribers) and causes the kernel
+ * to send out and clear (atomically) the currently accumulated data to all of
+ * the subscribers.
+ *
+ * Note that the data sent out in each notification contains only some data for
+ * a single station (identified by the interface index and the station's MAC
+ * address.) It is therefore expected that multiple messages will be received
+ * by an application, possibly even multiple messages for the same station and
+ * the same rate (e.g. for separate RX and TX counters), and subscribers need
+ * to ensure that their socket buffers are big enough to retrieve all the data.
+ */
+
+/**
+ * enum nl80211_rate_stats - per-rate statistics container attributes
+ * @__NL80211_ATTR_RATE_STATS_INVALID: attribute number 0 is reserved
+ * @NL80211_ATTR_RATE_STATS_RATE: bitrate definition, nested attribute
+ *	containing the attributes from &enum nl80211_rate_info.
+ * @NL80211_ATTR_RATE_STATS_STATS: statistics values, nested attribute
+ *	containing the attributes from &enum nl80211_tid_stats (even
+ *	though the statistics are not per TID)
+ * @NUM_NL80211_ATTR_RATE_STATS: number of attributes here
+ * @NL80211_ATTR_RATE_STATS_MAX: highest numbered attribute here
+ */
+enum nl80211_rate_stats {
+	__NL80211_ATTR_RATE_STATS_INVALID,
+	NL80211_ATTR_RATE_STATS_RATE,
+	NL80211_ATTR_RATE_STATS_STATS,
+
+	/* keep last */
+	NUM_NL80211_ATTR_RATE_STATS,
+	NL80211_ATTR_RATE_STATS_MAX = NUM_NL80211_ATTR_RATE_STATS - 1
+};
+
 #endif /* __LINUX_NL80211_H */
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 456e4c38c279..79d914f794e9 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -562,6 +562,11 @@ int wiphy_register(struct wiphy *wiphy)
 		     !rdev->ops->tdls_cancel_channel_switch)))
 		return -EINVAL;
 
+	if (WARN_ON(wiphy_ext_feature_isset(wiphy,
+					    NL80211_EXT_FEATURE_RATE_STATS) &&
+		    !rdev->ops->rate_stats))
+		return -EINVAL;
+
 	/*
 	 * if a wiphy has unsupported modes for regulatory channel enforcement,
 	 * opt-out of enforcement checking
@@ -724,6 +729,12 @@ int wiphy_register(struct wiphy *wiphy)
 		nl80211_send_reg_change_event(&request);
 	}
 
+	if (wiphy_ext_feature_isset(&rdev->wiphy,
+				    NL80211_EXT_FEATURE_RATE_STATS) &&
+	    genl_has_listeners(&nl80211_fam, wiphy_net(wiphy),
+			       NL80211_MCGRP_RATESTATS))
+		rdev_rate_stats(rdev, CFG80211_RATE_STATS_START);
+
 	rdev->wiphy.registered = true;
 	rtnl_unlock();
 
@@ -773,6 +784,12 @@ void wiphy_unregister(struct wiphy *wiphy)
 		rfkill_unregister(rdev->rfkill);
 
 	rtnl_lock();
+	if (wiphy_ext_feature_isset(&rdev->wiphy,
+				    NL80211_EXT_FEATURE_RATE_STATS) &&
+	    genl_has_listeners(&nl80211_fam, wiphy_net(wiphy),
+			       NL80211_MCGRP_RATESTATS))
+		rdev_rate_stats(rdev, CFG80211_RATE_STATS_STOP);
+
 	nl80211_notify_wiphy(rdev, NL80211_CMD_DEL_WIPHY);
 	rdev->wiphy.registered = false;
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 8e56eeb583aa..b907fd21055f 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -35,9 +35,11 @@ static int nl80211_pre_doit(const struct genl_ops *ops, struct sk_buff *skb,
 			    struct genl_info *info);
 static void nl80211_post_doit(const struct genl_ops *ops, struct sk_buff *skb,
 			      struct genl_info *info);
+static int nl80211_mcast_bind(struct net *net, int group);
+static void nl80211_mcast_unbind(struct net *net, int group);
 
 /* the netlink family */
-static struct genl_family nl80211_fam = {
+struct genl_family nl80211_fam = {
 	.id = GENL_ID_GENERATE,		/* don't bother with a hardcoded ID */
 	.name = NL80211_GENL_NAME,	/* have users key off the name instead */
 	.hdrsize = 0,			/* no private header */
@@ -46,24 +48,20 @@ static struct genl_family nl80211_fam = {
 	.netnsok = true,
 	.pre_doit = nl80211_pre_doit,
 	.post_doit = nl80211_post_doit,
+	.mcast_bind = nl80211_mcast_bind,
+	.mcast_unbind = nl80211_mcast_unbind,
 };
 
 /* multicast groups */
-enum nl80211_multicast_groups {
-	NL80211_MCGRP_CONFIG,
-	NL80211_MCGRP_SCAN,
-	NL80211_MCGRP_REGULATORY,
-	NL80211_MCGRP_MLME,
-	NL80211_MCGRP_VENDOR,
-	NL80211_MCGRP_TESTMODE /* keep last - ifdef! */
-};
-
 static const struct genl_multicast_group nl80211_mcgrps[] = {
 	[NL80211_MCGRP_CONFIG] = { .name = NL80211_MULTICAST_GROUP_CONFIG },
 	[NL80211_MCGRP_SCAN] = { .name = NL80211_MULTICAST_GROUP_SCAN },
 	[NL80211_MCGRP_REGULATORY] = { .name = NL80211_MULTICAST_GROUP_REG },
 	[NL80211_MCGRP_MLME] = { .name = NL80211_MULTICAST_GROUP_MLME },
 	[NL80211_MCGRP_VENDOR] = { .name = NL80211_MULTICAST_GROUP_VENDOR },
+	[NL80211_MCGRP_RATESTATS] = {
+		.name = NL80211_MULTICAST_GROUP_RATESTATS
+	},
 #ifdef CONFIG_NL80211_TESTMODE
 	[NL80211_MCGRP_TESTMODE] = { .name = NL80211_MULTICAST_GROUP_TESTMODE }
 #endif
@@ -3668,6 +3666,33 @@ static bool nl80211_put_signal(struct sk_buff *msg, u8 mask, s8 *signal,
 	return true;
 }
 
+static bool nl80211_put_tidstats(struct sk_buff *msg,
+				 struct cfg80211_tid_stats *tidstats,
+				 u32 attr)
+{
+	struct nlattr *tidattr = nla_nest_start(msg, attr);
+
+	if (!tidattr)
+		return false;
+
+#define PUT_TIDVAL(attr, memb, type) do {				\
+	if (tidstats->filled & BIT(NL80211_TID_STATS_ ## attr) &&	\
+	    nla_put_ ## type(msg, NL80211_TID_STATS_ ## attr,		\
+			     tidstats->memb))				\
+		return false;						\
+	} while (0)
+
+	PUT_TIDVAL(RX_MSDU, rx_msdu, u64);
+	PUT_TIDVAL(TX_MSDU, tx_msdu, u64);
+	PUT_TIDVAL(TX_MSDU_RETRIES, tx_msdu_retries, u64);
+	PUT_TIDVAL(TX_MSDU_FAILED, tx_msdu_failed, u64);
+
+#undef PUT_TIDVAL
+	nla_nest_end(msg, tidattr);
+
+	return true;
+}
+
 static int nl80211_send_station(struct sk_buff *msg, u32 cmd, u32 portid,
 				u32 seq, int flags,
 				struct cfg80211_registered_device *rdev,
@@ -3801,31 +3826,14 @@ static int nl80211_send_station(struct sk_buff *msg, u32 cmd, u32 portid,
 
 		for (tid = 0; tid < IEEE80211_NUM_TIDS + 1; tid++) {
 			struct cfg80211_tid_stats *tidstats;
-			struct nlattr *tidattr;
 
 			tidstats = &sinfo->pertid[tid];
 
 			if (!tidstats->filled)
 				continue;
 
-			tidattr = nla_nest_start(msg, tid + 1);
-			if (!tidattr)
+			if (!nl80211_put_tidstats(msg, tidstats, tid + 1))
 				goto nla_put_failure;
-
-#define PUT_TIDVAL(attr, memb, type) do {				\
-	if (tidstats->filled & BIT(NL80211_TID_STATS_ ## attr) &&	\
-	    nla_put_ ## type(msg, NL80211_TID_STATS_ ## attr,		\
-			     tidstats->memb))				\
-		goto nla_put_failure;					\
-	} while (0)
-
-			PUT_TIDVAL(RX_MSDU, rx_msdu, u64);
-			PUT_TIDVAL(TX_MSDU, tx_msdu, u64);
-			PUT_TIDVAL(TX_MSDU_RETRIES, tx_msdu_retries, u64);
-			PUT_TIDVAL(TX_MSDU_FAILED, tx_msdu_failed, u64);
-
-#undef PUT_TIDVAL
-			nla_nest_end(msg, tidattr);
 		}
 
 		nla_nest_end(msg, tidsattr);
@@ -10135,6 +10143,28 @@ static int nl80211_tdls_cancel_channel_switch(struct sk_buff *skb,
 	return 0;
 }
 
+static int nl80211_get_rate_stats(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev;
+
+	if (!genl_has_listeners(&nl80211_fam, genl_info_net(info),
+				NL80211_MCGRP_RATESTATS))
+		return -ENODATA;
+
+	list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
+		if (wiphy_net(&rdev->wiphy) != genl_info_net(info))
+			continue;
+
+		if (!wiphy_ext_feature_isset(&rdev->wiphy,
+					     NL80211_EXT_FEATURE_RATE_STATS))
+			continue;
+
+		rdev_rate_stats(rdev, CFG80211_RATE_STATS_DUMP);
+	}
+
+	return 0;
+}
+
 #define NL80211_FLAG_NEED_WIPHY		0x01
 #define NL80211_FLAG_NEED_NETDEV	0x02
 #define NL80211_FLAG_NEED_RTNL		0x04
@@ -10245,6 +10275,56 @@ static void nl80211_post_doit(const struct genl_ops *ops, struct sk_buff *skb,
 	}
 }
 
+static void nl80211_do_rate_stats(struct net *net,
+				  enum cfg80211_rate_stats_ops op)
+{
+	struct cfg80211_registered_device *rdev;
+
+	rtnl_lock();
+
+	list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
+		if (wiphy_net(&rdev->wiphy) != net)
+			continue;
+
+		if (!wiphy_ext_feature_isset(&rdev->wiphy,
+					     NL80211_EXT_FEATURE_RATE_STATS))
+			continue;
+
+		rdev_rate_stats(rdev, op);
+	}
+
+	rtnl_unlock();
+}
+
+static int nl80211_mcast_bind(struct net *net, int group)
+{
+	enum cfg80211_rate_stats_ops op;
+
+	switch (group) {
+	case NL80211_MCGRP_RATESTATS:
+		if (!genl_has_listeners(&nl80211_fam, net,
+					NL80211_MCGRP_RATESTATS))
+			op = CFG80211_RATE_STATS_START;
+		else
+			op = CFG80211_RATE_STATS_DUMP;
+		nl80211_do_rate_stats(net, op);
+		break;
+	}
+
+	return 0;
+}
+
+static void nl80211_mcast_unbind(struct net *net, int group)
+{
+	switch (group) {
+	case NL80211_MCGRP_RATESTATS:
+		if (!genl_has_listeners(&nl80211_fam, net,
+					NL80211_MCGRP_RATESTATS))
+			nl80211_do_rate_stats(net, CFG80211_RATE_STATS_STOP);
+		break;
+	}
+}
+
 static const struct genl_ops nl80211_ops[] = {
 	{
 		.cmd = NL80211_CMD_GET_WIPHY,
@@ -10950,6 +11030,13 @@ static const struct genl_ops nl80211_ops[] = {
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL80211_CMD_GET_RATE_STATISTICS,
+		.doit = nl80211_get_rate_stats,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_RTNL,
+	},
 };
 
 /* notification functions */
@@ -12838,6 +12925,71 @@ void cfg80211_crit_proto_stopped(struct wireless_dev *wdev, gfp_t gfp)
 }
 EXPORT_SYMBOL(cfg80211_crit_proto_stopped);
 
+void cfg80211_report_rate_stats(struct wiphy *wiphy, struct wireless_dev *wdev,
+				const u8 *addr, unsigned int n_stats,
+				struct cfg80211_rate_stats *stats, gfp_t gfp)
+{
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
+	unsigned int i;
+
+	if (!genl_has_listeners(&nl80211_fam, wiphy_net(wiphy),
+				NL80211_MCGRP_RATESTATS))
+		return;
+
+	for (i = 0; i < n_stats; i++) {
+		struct sk_buff *msg;
+		void *hdr;
+		struct nlattr *attr_all;
+
+		if (!stats[i].stats.filled)
+			continue;
+
+		msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
+		if (!msg)
+			continue;
+
+		hdr = nl80211hdr_put(msg, 0, 0, 0,
+				     NL80211_CMD_GET_RATE_STATISTICS);
+		if (!hdr)
+			goto nla_put_failure;
+
+		if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
+		    nla_put_u64(msg, NL80211_ATTR_WDEV, wdev_id(wdev)))
+			goto nla_put_failure;
+
+		if (wdev->netdev &&
+		    nla_put_u32(msg, NL80211_ATTR_IFINDEX,
+				wdev->netdev->ifindex))
+			goto nla_put_failure;
+
+		if (nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, addr))
+			goto nla_put_failure;
+
+		attr_all = nla_nest_start(msg, NL80211_ATTR_RATE_STATS);
+		if (!attr_all)
+			goto nla_put_failure;
+
+		if (!nl80211_put_sta_rate(msg, &stats[i].rate,
+					  NL80211_ATTR_RATE_STATS_RATE))
+			goto nla_put_failure;
+
+		if (!nl80211_put_tidstats(msg, &stats[i].stats,
+					  NL80211_ATTR_RATE_STATS_STATS))
+			goto nla_put_failure;
+
+		nla_nest_end(msg, attr_all);
+
+		genlmsg_end(msg, hdr);
+
+		genlmsg_multicast_netns(&nl80211_fam, wiphy_net(wiphy), msg, 0,
+					NL80211_MCGRP_RATESTATS, GFP_KERNEL);
+		continue;
+ nla_put_failure:
+		nlmsg_free(msg);
+	}
+}
+EXPORT_SYMBOL_GPL(cfg80211_report_rate_stats);
+
 void nl80211_send_ap_stopped(struct wireless_dev *wdev)
 {
 	struct wiphy *wiphy = wdev->wiphy;
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index 84d4edf1d545..39c87e396595 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -3,6 +3,21 @@
 
 #include "core.h"
 
+/* netlink family */
+extern struct genl_family nl80211_fam;
+
+/* multicast groups */
+enum nl80211_multicast_groups {
+	NL80211_MCGRP_CONFIG,
+	NL80211_MCGRP_SCAN,
+	NL80211_MCGRP_REGULATORY,
+	NL80211_MCGRP_MLME,
+	NL80211_MCGRP_VENDOR,
+	NL80211_MCGRP_RATESTATS,
+	NL80211_MCGRP_TESTMODE /* keep last - ifdef! */
+};
+
+
 int nl80211_init(void);
 void nl80211_exit(void);
 void nl80211_notify_wiphy(struct cfg80211_registered_device *rdev,
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 35cfb7134bdb..67c7e329489c 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -1017,4 +1017,14 @@ rdev_tdls_cancel_channel_switch(struct cfg80211_registered_device *rdev,
 	trace_rdev_return_void(&rdev->wiphy);
 }
 
+static inline void
+rdev_rate_stats(struct cfg80211_registered_device *rdev,
+		enum cfg80211_rate_stats_ops op)
+{
+	trace_rdev_rate_stats(&rdev->wiphy, op);
+	if (rdev->ops->rate_stats)
+		rdev->ops->rate_stats(&rdev->wiphy, op);
+	trace_rdev_return_void(&rdev->wiphy);
+}
+
 #endif /* __CFG80211_RDEV_OPS */
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index b17b3692f8c2..b59a9c6231f5 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2077,6 +2077,20 @@ TRACE_EVENT(rdev_tdls_cancel_channel_switch,
 		  WIPHY_PR_ARG, NETDEV_PR_ARG, MAC_PR_ARG(addr))
 );
 
+TRACE_EVENT(rdev_rate_stats,
+	TP_PROTO(struct wiphy *wiphy, enum cfg80211_rate_stats_ops op),
+	TP_ARGS(wiphy, op),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		__field(u32, op)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		__entry->op = op;
+	),
+	TP_printk(WIPHY_PR_FMT ", op=%d", WIPHY_PR_ARG, __entry->op)
+);
+
 /*************************************************************
  *	     cfg80211 exported functions traces		     *
  *************************************************************/
-- 
2.1.4

