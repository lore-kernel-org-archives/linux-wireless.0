Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48128 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1163258AbeE1NfL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 May 2018 09:35:11 -0400
From: Sriram R <srirrama@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Sriram R <srirrama@codeaurora.org>
Subject: [RFCv2 1/2] nl80211: support per-rate/per-station statistics
Date: Mon, 28 May 2018 19:04:38 +0530
Message-Id: <1527514479-6696-2-git-send-email-srirrama@codeaurora.org> (sfid-20180528_153607_221120_88600214)
In-Reply-To: <1527514479-6696-1-git-send-email-srirrama@codeaurora.org>
References: <1527514479-6696-1-git-send-email-srirrama@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Per-rate/per-station statistics can be desirable to have but they're
quite expensive (keeping the four counters for each rate would take
close to 4k of memory per station only for VHT MCSes for a moderately
capable VHT chip (with 2 spatial streams and 80MHz support) so it's
not a good idea to keep all of this in the kernel.

Instead, this API provides a way for interested clients in userspace
to subscribe to such statistics. When supported by a driver, it can
then start collecting the data only when subscribers exist. To avoid
the kernel's data collection becoming too big, it can send out the
data at any point in time, for example to limit the counters to u16
internally and send it out when they're close to reaching the limit,
or to keep a hash table and sending it out when too many collisions
occur. Userspace can then keep track of the full state.

Based on below implementation by Johannes Berg <johannes@sipsolutions.net>
http://thread.gmane.org/gmane.linux.kernel.wireless.general/133172
with following changes,
 1. Allow rx bytes stats to be collected
 2. Rate info sent to userspace is encoded into 32bit value

Signed-off-by: Sriram R <srirrama@codeaurora.org>
---
 include/net/cfg80211.h       |  51 +++++++++++++
 include/uapi/linux/nl80211.h |  76 +++++++++++++++++++
 net/wireless/core.c          |  18 +++++
 net/wireless/nl80211.c       | 175 +++++++++++++++++++++++++++++++++++++++----
 net/wireless/nl80211.h       |  14 ++++
 net/wireless/rdev-ops.h      |  10 +++
 net/wireless/trace.h         |  15 ++++
 7 files changed, 346 insertions(+), 13 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 5fbfe61..6796462 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1236,6 +1236,37 @@ struct station_info {
 	s8 avg_ack_signal;
 };
 
+/**
+ * struct cfg80211_rate_stats - per rate statistics of station
+ *
+ * @rate: encoded rate value
+ * @bytes: Total number of bytes received at this @rate
+ * @packets: Packet count received at this @rate
+ */
+struct cfg80211_rate_stats {
+	u32 rate;
+	u32 bytes;
+	u16 packets;
+};
+
+/**
+ * cfg80211_report_rate_stats - report rate statistics for a station
+ * @wiphy: the wiphy that's reporting the data
+ * @wdev: the virtual interface the data is reported for
+ * @mac_addr: the station MAC address
+ * @rate_table_len: length of rate table
+ * @rate_stats_buf: per-rate,per-station statistics buffer
+ * @gfp: allocation flags
+ *
+ * Note that it is valid to call this function multiple times even for the
+ * same station, if the data isn't actually stored in an array.
+ */
+void cfg80211_report_rate_stats(struct wiphy *wiphy, struct wireless_dev *wdev,
+				const u8 *mac_addr, unsigned int rate_table_len,
+				struct cfg80211_rate_stats *rate_stats_buf,
+				gfp_t gfp);
+
+
 #if IS_ENABLED(CONFIG_CFG80211)
 /**
  * cfg80211_get_station - retrieve information about a given station
@@ -2693,6 +2724,20 @@ struct cfg80211_external_auth_params {
 };
 
 /**
+ * enum cfg80211_rate_stats_ops - rate statistics operations
+ *
+ * @CFG80211_RATE_STATS_START: start data collection
+ * @CFG80211_RATE_STATS_DUMP: dump and clear the data
+ *	(using cfg80211_report_rate_stats() to report it)
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
@@ -3024,6 +3069,9 @@ struct cfg80211_external_auth_params {
  *
  * @tx_control_port: TX a control port frame (EAPoL).  The noencrypt parameter
  *	tells the driver that the frame should not be encrypted.
+ *
+ * @rate_stats: rate statistics operation - if supported all operations must be
+ *	supported, see &enum cfg80211_rate_stats_ops.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -3329,6 +3377,9 @@ struct cfg80211_ops {
 				   const u8 *buf, size_t len,
 				   const u8 *dest, const __be16 proto,
 				   const bool noencrypt);
+
+	void	(*rate_stats)(struct wiphy *wiphy,
+			      enum cfg80211_rate_stats_ops op);
 };
 
 /*
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 06f9af2..fca25b8 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -51,6 +51,7 @@
 #define NL80211_MULTICAST_GROUP_VENDOR		"vendor"
 #define NL80211_MULTICAST_GROUP_NAN		"nan"
 #define NL80211_MULTICAST_GROUP_TESTMODE	"testmode"
+#define NL80211_MULTICAST_GROUP_RATE_STATS	"rate-stats"
 
 /**
  * DOC: Station handling
@@ -1033,6 +1034,10 @@
  *	&NL80211_ATTR_CHANNEL_WIDTH,&NL80211_ATTR_NSS attributes with its
  *	address(specified in &NL80211_ATTR_MAC).
  *
+ * @NL80211_CMD_GET_RATE_STATS: This command can be used to trigger the
+ *	rate statistics dump to userspace, which also clears the data in the
+ *	kernel (driver). See the "per-rate statistics" documentation section.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -1245,6 +1250,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_CONTROL_PORT_FRAME,
 
+	NL80211_CMD_GET_RATE_STATS,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -2238,6 +2245,9 @@ enum nl80211_commands {
  * @NL80211_ATTR_TXQ_QUANTUM: TXQ scheduler quantum (bytes). Number of bytes
  *      a flow is assigned on each round of the DRR scheduler.
  *
+ * @NL80211_ATTR_RATE_STATS: per-rate statistics container attribute, this is
+ *	contains the attributes from &enum nl80211_rate_stats.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2677,6 +2687,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_TXQ_MEMORY_LIMIT,
 	NL80211_ATTR_TXQ_QUANTUM,
 
+	NL80211_ATTR_RATE_STATS,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -3116,6 +3128,67 @@ enum nl80211_txq_stats {
 };
 
 /**
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
+ * rate statistics multicast group (%NL80211_MULTICAST_GROUP_RATE_STATS).
+ * This is used by the kernel to start data collection. If, at this point,
+ * other clients exist, those are also sent the current statistics in order to
+ * allow the new client to collect only the data obtained while subscribed.
+ *
+ * While subscribed, the client must listen for %NL80211_CMD_GET_RATE_STATS
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
+ * the %NL80211_CMD_GET_RATE_STATS command can be used. This command can
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
+ * enum nl80211_rate_stats - per-rate stats attributes
+ * @__NL80211_RATE_STATS_INVALID :attribute number 0 is reserved
+ * @NL80211_ATTR_RATE_STATS_RATE :identifier for the encoded rate field.
+ * @NL80211_ATTR_RATE_STATS_RX_PACKETS: Number of packets which are received
+ *	per @rate for this specific station identified by @NL80211_ATTR_MAC.
+ * @NL80211_ATTR_RATE_STATS_RX_BYTES: Number of bytes which are received
+ *	per @rate for this specific station identified by @NL80211_ATTR_MAC.
+ * @NUM_NL80211_ATTR_RATE_STATS: Total number of rate-stats attributes
+ * @NL80211_ATTR_RATE_STATS_MAX: MAX rate-stats attribute number.
+ */
+enum nl80211_rate_stats {
+	__NL80211_RATE_STATS_INVALID,
+	NL80211_ATTR_RATE_STATS_RATE,
+	NL80211_ATTR_RATE_STATS_RX_PACKETS,
+	NL80211_ATTR_RATE_STATS_RX_BYTES,
+
+	/* keep last */
+	NUM_NL80211_ATTR_RATE_STATS,
+	NL80211_ATTR_RATE_STATS_MAX = NUM_NL80211_ATTR_RATE_STATS - 1
+};
+/**
  * enum nl80211_mpath_flags - nl80211 mesh path flags
  *
  * @NL80211_MPATH_FLAG_ACTIVE: the mesh path is active
@@ -5133,6 +5206,8 @@ enum nl80211_feature_flags {
  *	support to nl80211.
  * @NL80211_EXT_FEATURE_TXQS: Driver supports FQ-CoDel-enabled intermediate
  *      TXQs.
+ * @NL80211_EXT_FEATURE_RATE_STATS: This device supports the per-rate
+ *	statistics subscription API.
  *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
@@ -5167,6 +5242,7 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_CONTROL_PORT_OVER_NL80211,
 	NL80211_EXT_FEATURE_DATA_ACK_SIGNAL_SUPPORT,
 	NL80211_EXT_FEATURE_TXQS,
+	NL80211_EXT_FEATURE_RATE_STATS,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 5fe35aa..e345166 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -664,6 +664,12 @@ int wiphy_register(struct wiphy *wiphy)
 		return -EINVAL;
 #endif
 
+	if (WARN_ON(wiphy_ext_feature_isset(wiphy,
+					    NL80211_EXT_FEATURE_RATE_STATS) &&
+		    !rdev->ops->rate_stats))
+		return -EINVAL;
+
+
 	/*
 	 * if a wiphy has unsupported modes for regulatory channel enforcement,
 	 * opt-out of enforcement checking
@@ -872,6 +878,12 @@ int wiphy_register(struct wiphy *wiphy)
 				break;
 		}
 	}
+	
+	if (wiphy_ext_feature_isset(&rdev->wiphy,
+				    NL80211_EXT_FEATURE_RATE_STATS) &&
+	    genl_has_listeners(&nl80211_fam, wiphy_net(wiphy),
+			       NL80211_MCGRP_RATE_STATS))
+		rdev_rate_stats(rdev, CFG80211_RATE_STATS_START);
 
 	rdev->wiphy.registered = true;
 	rtnl_unlock();
@@ -922,6 +934,12 @@ void wiphy_unregister(struct wiphy *wiphy)
 		rfkill_unregister(rdev->rfkill);
 
 	rtnl_lock();
+	if (wiphy_ext_feature_isset(&rdev->wiphy,
+				    NL80211_EXT_FEATURE_RATE_STATS) &&
+	    genl_has_listeners(&nl80211_fam, wiphy_net(wiphy),
+			       NL80211_MCGRP_RATE_STATS))
+		rdev_rate_stats(rdev, CFG80211_RATE_STATS_STOP);
+
 	nl80211_notify_wiphy(rdev, NL80211_CMD_DEL_WIPHY);
 	rdev->wiphy.registered = false;
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index bc40a78..27248d8 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -35,18 +35,8 @@ static int nl80211_crypto_settings(struct cfg80211_registered_device *rdev,
 				   int cipher_limit);
 
 /* the netlink family */
-static struct genl_family nl80211_fam;
-
-/* multicast groups */
-enum nl80211_multicast_groups {
-	NL80211_MCGRP_CONFIG,
-	NL80211_MCGRP_SCAN,
-	NL80211_MCGRP_REGULATORY,
-	NL80211_MCGRP_MLME,
-	NL80211_MCGRP_VENDOR,
-	NL80211_MCGRP_NAN,
-	NL80211_MCGRP_TESTMODE /* keep last - ifdef! */
-};
+struct genl_family nl80211_fam;
+
 
 static const struct genl_multicast_group nl80211_mcgrps[] = {
 	[NL80211_MCGRP_CONFIG] = { .name = NL80211_MULTICAST_GROUP_CONFIG },
@@ -55,6 +45,9 @@ static const struct genl_multicast_group nl80211_mcgrps[] = {
 	[NL80211_MCGRP_MLME] = { .name = NL80211_MULTICAST_GROUP_MLME },
 	[NL80211_MCGRP_VENDOR] = { .name = NL80211_MULTICAST_GROUP_VENDOR },
 	[NL80211_MCGRP_NAN] = { .name = NL80211_MULTICAST_GROUP_NAN },
+	[NL80211_MCGRP_RATE_STATS] = {
+		.name = NL80211_MULTICAST_GROUP_RATE_STATS
+	},
 #ifdef CONFIG_NL80211_TESTMODE
 	[NL80211_MCGRP_TESTMODE] = { .name = NL80211_MULTICAST_GROUP_TESTMODE }
 #endif
@@ -4813,6 +4806,28 @@ static int nl80211_get_station(struct sk_buff *skb, struct genl_info *info)
 	return genlmsg_reply(msg, info);
 }
 
+static int nl80211_get_rate_stats(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev;
+
+	if (!genl_has_listeners(&nl80211_fam, genl_info_net(info),
+				NL80211_MCGRP_RATE_STATS))
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
 int cfg80211_check_station_change(struct wiphy *wiphy,
 				  struct station_parameters *params,
 				  enum cfg80211_station_type statype)
@@ -12991,6 +13006,56 @@ static void nl80211_post_doit(const struct genl_ops *ops, struct sk_buff *skb,
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
+	case NL80211_MCGRP_RATE_STATS:
+		if (!genl_has_listeners(&nl80211_fam, net,
+					NL80211_MCGRP_RATE_STATS))
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
+	case NL80211_MCGRP_RATE_STATS:
+		if (!genl_has_listeners(&nl80211_fam, net,
+					NL80211_MCGRP_RATE_STATS))
+			nl80211_do_rate_stats(net, CFG80211_RATE_STATS_STOP);
+		break;
+	}
+}
+
 static const struct genl_ops nl80211_ops[] = {
 	{
 		.cmd = NL80211_CMD_GET_WIPHY,
@@ -13799,9 +13864,16 @@ static const struct genl_ops nl80211_ops[] = {
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL80211_CMD_GET_RATE_STATS,
+		.doit = nl80211_get_rate_stats,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_RTNL,
+	},
 };
 
-static struct genl_family nl80211_fam __ro_after_init = {
+struct genl_family nl80211_fam __ro_after_init = {
 	.name = NL80211_GENL_NAME,	/* have users key off the name instead */
 	.hdrsize = 0,			/* no private header */
 	.version = 1,			/* no particular meaning now */
@@ -13814,6 +13886,8 @@ static struct genl_family nl80211_fam __ro_after_init = {
 	.n_ops = ARRAY_SIZE(nl80211_ops),
 	.mcgrps = nl80211_mcgrps,
 	.n_mcgrps = ARRAY_SIZE(nl80211_mcgrps),
+	.mcast_bind = nl80211_mcast_bind,
+	.mcast_unbind = nl80211_mcast_unbind,
 };
 
 /* notification functions */
@@ -15885,6 +15959,81 @@ void cfg80211_crit_proto_stopped(struct wireless_dev *wdev, gfp_t gfp)
 }
 EXPORT_SYMBOL(cfg80211_crit_proto_stopped);
 
+void cfg80211_report_rate_stats(struct wiphy *wiphy, struct wireless_dev *wdev,
+				const u8 *mac_addr, unsigned int rate_table_len,
+				struct cfg80211_rate_stats *rate_stats_buf,
+				gfp_t gfp)
+{
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
+	struct sk_buff *msg;
+	void *hdr;
+	struct nlattr *rstatsattr, *rentryattr;
+	struct cfg80211_rate_stats *report;
+	int rid;
+
+	if (!genl_has_listeners(&nl80211_fam, wiphy_net(wiphy),
+				NL80211_MCGRP_RATE_STATS))
+		return;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0,
+			     NL80211_CMD_GET_RATE_STATS);
+	if (!hdr)
+		goto out;
+
+	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
+	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, wdev->netdev->ifindex) ||
+	    nla_put_u64_64bit(msg, NL80211_ATTR_WDEV, wdev_id(wdev),
+			      NL80211_ATTR_PAD))
+		goto out;
+
+	if (nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, mac_addr))
+		goto out;
+
+	if (1 && rate_table_len && rate_stats_buf) {
+		rstatsattr = nla_nest_start(msg, NL80211_ATTR_RATE_STATS);
+
+		if (!rstatsattr)
+			goto out;
+
+		report = rate_stats_buf;
+
+		for (rid = 0; rid < rate_table_len ; rid++) {
+			rentryattr = nla_nest_start(msg, rid + 1);
+			if (!rentryattr)
+				goto out;
+
+			nla_put_u32(msg, NL80211_ATTR_RATE_STATS_RATE,
+				    report->rate);
+			nla_put_u16(msg, NL80211_ATTR_RATE_STATS_RX_PACKETS,
+				    report->packets);
+			nla_put_u32(msg, NL80211_ATTR_RATE_STATS_RX_BYTES,
+				    report->bytes);
+			nla_nest_end(msg, rentryattr);
+
+			if (rid + 1 < rate_table_len)
+				report++;
+		}
+
+		nla_nest_end(msg, rstatsattr);
+	}
+
+
+	genlmsg_end(msg, hdr);
+
+	genlmsg_multicast_netns(&nl80211_fam, wiphy_net(wiphy), msg, 0,
+				NL80211_MCGRP_RATE_STATS, GFP_KERNEL);
+	return;
+
+ out:
+	nlmsg_free(msg);
+}
+
+EXPORT_SYMBOL_GPL(cfg80211_report_rate_stats);
+
 void nl80211_send_ap_stopped(struct wireless_dev *wdev)
 {
 	struct wiphy *wiphy = wdev->wiphy;
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index 79e47fe..df9763f 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -4,6 +4,20 @@
 
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
+	NL80211_MCGRP_NAN,
+	NL80211_MCGRP_RATE_STATS,
+	NL80211_MCGRP_TESTMODE /* keep last - ifdef! */
+};
 int nl80211_init(void);
 void nl80211_exit(void);
 void nl80211_notify_wiphy(struct cfg80211_registered_device *rdev,
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 364f5d6..bffefc2 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -222,6 +222,16 @@ static inline int rdev_dump_station(struct cfg80211_registered_device *rdev,
 	return ret;
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
 static inline int rdev_add_mpath(struct cfg80211_registered_device *rdev,
 				 struct net_device *dev, u8 *dst, u8 *next_hop)
 {
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 2b417a2..c82b21b 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2368,6 +2368,21 @@ TRACE_EVENT(rdev_external_auth,
 		      __entry->bssid, __entry->ssid, __entry->status)
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
+
 /*************************************************************
  *	     cfg80211 exported functions traces		     *
  *************************************************************/
-- 
2.7.4
