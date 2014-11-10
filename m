Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:53524 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468AbaKJJKO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2014 04:10:14 -0500
Received: by mail-wi0-f178.google.com with SMTP id bs8so9680062wib.11
        for <linux-wireless@vger.kernel.org>; Mon, 10 Nov 2014 01:10:12 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v2 11/16] cfg80211: introduce TDLS channel switch commands
Date: Mon, 10 Nov 2014 11:10:08 +0200
Message-Id: <1415610608-17852-1-git-send-email-arik@wizery.com> (sfid-20141110_101024_270097_82B694D8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduce commands to initiate and cancel TDLS channel-switching. Once
TDLS channel-switching is started, the lower level driver is responsible
for continually initiating channel-switch operations and returning to
the base (AP) channel to listen for beacons from time to time.

Upon cancellation of the channel-switch all communication between the
relevant TDLS peers will continue on the base channel.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
v2: removed .rej file (thanks Arend)

 include/net/cfg80211.h       |  14 ++++++
 include/uapi/linux/nl80211.h |  17 +++++++
 net/wireless/core.c          |   4 ++
 net/wireless/nl80211.c       | 108 +++++++++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      |  24 ++++++++++
 net/wireless/trace.h         |  42 +++++++++++++++++
 6 files changed, 209 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 5c3acd0..57c34e3 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2367,6 +2367,12 @@ struct cfg80211_qos_map {
  *	(invoked with the wireless_dev mutex held)
  * @leave_ocb: leave the current OCB network
  *	(invoked with the wireless_dev mutex held)
+ *
+ * @tdls_channel_switch: Start channel-switching with a TDLS peer. The driver
+ *	is responsible for continually initiating channel-switching operations
+ *	and returning to the base channel for communication with the AP.
+ * @tdls_cancel_channel_switch: Stop channel-switching with a TDLS peer. Both
+ *	peers must be on the base channel when the call completes.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -2622,6 +2628,14 @@ struct cfg80211_ops {
 			     u16 admitted_time);
 	int	(*del_tx_ts)(struct wiphy *wiphy, struct net_device *dev,
 			     u8 tsid, const u8 *peer);
+
+	int	(*tdls_channel_switch)(struct wiphy *wiphy,
+				       struct net_device *dev,
+				       const u8 *addr, u8 oper_class,
+				       struct cfg80211_chan_def *chandef);
+	void	(*tdls_cancel_channel_switch)(struct wiphy *wiphy,
+					      struct net_device *dev,
+					      const u8 *addr);
 };
 
 /*
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index e7f01d6..c2df1e0 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -751,6 +751,18 @@
  * @NL80211_CMD_LEAVE_OCB: Leave the OCB network -- no special arguments, the
  *	network is determined by the network interface.
  *
+ * @NL80211_CMD_TDLS_CHANNEL_SWITCH: Start channel-switching with a TDLS peer,
+ *	identified by the %NL80211_ATTR_MAC parameter. A target channel is
+ *	provided via %NL80211_ATTR_WIPHY_FREQ and other attributes determining
+ *	channel width/type. The target operating class is given via
+ *	%NL80211_ATTR_OPER_CLASS.
+ *	The driver is responsible for continually initiating channel-switching
+ *	operations and returning to the base channel for communication with the
+ *	AP.
+ * @NL80211_CMD_TDLS_CANCEL_CHANNEL_SWITCH: Stop channel-switching with a TDLS
+ *	peer given by %NL80211_ATTR_MAC. Both peers must be on the base channel
+ *	when this command completes.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -930,6 +942,9 @@ enum nl80211_commands {
 	NL80211_CMD_JOIN_OCB,
 	NL80211_CMD_LEAVE_OCB,
 
+	NL80211_CMD_TDLS_CHANNEL_SWITCH,
+	NL80211_CMD_TDLS_CANCEL_CHANNEL_SWITCH,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -2008,6 +2023,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_SMPS_MODE,
 
+	NL80211_ATTR_OPER_CLASS,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/core.c b/net/wireless/core.c
index a4d2792..4c2e501 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -541,6 +541,10 @@ int wiphy_register(struct wiphy *wiphy)
 		    !wiphy->wowlan->tcp))
 		return -EINVAL;
 #endif
+	if (WARN_ON((wiphy->features & NL80211_FEATURE_TDLS_CHANNEL_SWITCH) &&
+		    (!rdev->ops->tdls_channel_switch ||
+		     !rdev->ops->tdls_cancel_channel_switch)))
+		return -EINVAL;
 
 	if (WARN_ON(wiphy->coalesce &&
 		    (!wiphy->coalesce->n_rules ||
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 24549cb..328c45b 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -9658,6 +9658,98 @@ static int nl80211_del_tx_ts(struct sk_buff *skb, struct genl_info *info)
 	return err;
 }
 
+static int nl80211_tdls_channel_switch(struct sk_buff *skb,
+				       struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_chan_def chandef = {};
+	const u8 *addr;
+	u8 oper_class;
+	int err;
+
+	if (!rdev->ops->tdls_channel_switch ||
+	    !(rdev->wiphy.features & NL80211_FEATURE_TDLS_CHANNEL_SWITCH))
+		return -EOPNOTSUPP;
+
+	switch (dev->ieee80211_ptr->iftype) {
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_P2P_CLIENT:
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	if (!info->attrs[NL80211_ATTR_MAC] ||
+	    !info->attrs[NL80211_ATTR_OPER_CLASS])
+		return -EINVAL;
+
+	err = nl80211_parse_chandef(rdev, info, &chandef);
+	if (err)
+		return err;
+
+	/*
+	 * Don't allow wide channels on the 2.4Ghz band, as per IEEE802.11-2012
+	 * section 10.22.6.2.1. Disallow 5/10Mhz channels as well for now, the
+	 * specification is not defined for them.
+	 */
+	if (chandef.chan->band == IEEE80211_BAND_2GHZ &&
+	    chandef.width != NL80211_CHAN_WIDTH_20_NOHT &&
+	    chandef.width != NL80211_CHAN_WIDTH_20)
+		return -EINVAL;
+
+	/* we will be active on the TDLS link */
+	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &chandef, wdev->iftype))
+		return -EINVAL;
+
+	/* don't allow switching to DFS channels */
+	if (cfg80211_chandef_dfs_required(wdev->wiphy, &chandef, wdev->iftype))
+		return -EINVAL;
+
+	addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
+	oper_class = nla_get_u8(info->attrs[NL80211_ATTR_OPER_CLASS]);
+
+	wdev_lock(wdev);
+	err = rdev_tdls_channel_switch(rdev, dev, addr, oper_class, &chandef);
+	wdev_unlock(wdev);
+
+	return err;
+}
+
+static int nl80211_tdls_cancel_channel_switch(struct sk_buff *skb,
+					      struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	const u8 *addr;
+
+	if (!rdev->ops->tdls_channel_switch ||
+	    !rdev->ops->tdls_cancel_channel_switch ||
+	    !(rdev->wiphy.features & NL80211_FEATURE_TDLS_CHANNEL_SWITCH))
+		return -EOPNOTSUPP;
+
+	switch (dev->ieee80211_ptr->iftype) {
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_P2P_CLIENT:
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	if (!info->attrs[NL80211_ATTR_MAC])
+		return -EINVAL;
+
+	addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
+
+	wdev_lock(wdev);
+	rdev_tdls_cancel_channel_switch(rdev, dev, addr);
+	wdev_unlock(wdev);
+
+	return 0;
+}
+
 #define NL80211_FLAG_NEED_WIPHY		0x01
 #define NL80211_FLAG_NEED_NETDEV	0x02
 #define NL80211_FLAG_NEED_RTNL		0x04
@@ -10456,6 +10548,22 @@ static const struct genl_ops nl80211_ops[] = {
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL80211_CMD_TDLS_CHANNEL_SWITCH,
+		.doit = nl80211_tdls_channel_switch,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
+	{
+		.cmd = NL80211_CMD_TDLS_CANCEL_CHANNEL_SWITCH,
+		.doit = nl80211_tdls_cancel_channel_switch,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
 };
 
 /* notification functions */
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 1b3864c..35cfb71 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -993,4 +993,28 @@ rdev_del_tx_ts(struct cfg80211_registered_device *rdev,
 	return ret;
 }
 
+static inline int
+rdev_tdls_channel_switch(struct cfg80211_registered_device *rdev,
+			 struct net_device *dev, const u8 *addr,
+			 u8 oper_class, struct cfg80211_chan_def *chandef)
+{
+	int ret;
+
+	trace_rdev_tdls_channel_switch(&rdev->wiphy, dev, addr, oper_class,
+				       chandef);
+	ret = rdev->ops->tdls_channel_switch(&rdev->wiphy, dev, addr,
+					     oper_class, chandef);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
+
+static inline void
+rdev_tdls_cancel_channel_switch(struct cfg80211_registered_device *rdev,
+				struct net_device *dev, const u8 *addr)
+{
+	trace_rdev_tdls_cancel_channel_switch(&rdev->wiphy, dev, addr);
+	rdev->ops->tdls_cancel_channel_switch(&rdev->wiphy, dev, addr);
+	trace_rdev_return_void(&rdev->wiphy);
+}
+
 #endif /* __CFG80211_RDEV_OPS */
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 277a85d..f0545e1 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2032,6 +2032,48 @@ TRACE_EVENT(rdev_del_tx_ts,
 		  WIPHY_PR_ARG, NETDEV_PR_ARG, MAC_PR_ARG(peer), __entry->tsid)
 );
 
+TRACE_EVENT(rdev_tdls_channel_switch,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 const u8 *addr, u8 oper_class,
+		 struct cfg80211_chan_def *chandef),
+	TP_ARGS(wiphy, netdev, addr, oper_class, chandef),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		MAC_ENTRY(addr)
+		__field(u8, oper_class)
+		CHAN_DEF_ENTRY
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(addr, addr);
+		CHAN_DEF_ASSIGN(chandef);
+	),
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", " MAC_PR_FMT
+		  " oper class %d, " CHAN_DEF_PR_FMT,
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, MAC_PR_ARG(addr),
+		  __entry->oper_class, CHAN_DEF_PR_ARG)
+);
+
+TRACE_EVENT(rdev_tdls_cancel_channel_switch,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 const u8 *addr),
+	TP_ARGS(wiphy, netdev, addr),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		MAC_ENTRY(addr)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(addr, addr);
+	),
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", " MAC_PR_FMT,
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, MAC_PR_ARG(addr))
+);
+
 /*************************************************************
  *	     cfg80211 exported functions traces		     *
  *************************************************************/
-- 
1.9.1

