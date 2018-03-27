Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40848 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751184AbeC0IoQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Mar 2018 04:44:16 -0400
From: Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>
Subject: [RFC 2/4] nl80211/mac80211: Extend NoAck policy command with peer MAC address
Date: Tue, 27 Mar 2018 14:12:49 +0530
Message-Id: <1522140171-10926-3-git-send-email-vthiagar@codeaurora.org> (sfid-20180327_104423_626991_FEB0EA25)
In-Reply-To: <1522140171-10926-1-git-send-email-vthiagar@codeaurora.org>
References: <1522140171-10926-1-git-send-email-vthiagar@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Provides peer level NoAck policy configuration by extending
NL80211_CMD_SET_NOACK_MAP command with peer MAC address.
If user space does not give any peer mac address, the driver
should retain the existing functionality of applying the NoAck
policy for all the staions connected to the netdev. Peer specific
configuration takes precedence over netdev level configuration when
both are set by the user. Drivers supporting per-sta NoAck policy
must advertise the support through the extended flag index
NL80211_EXT_FEATURE_PER_STA_NOACK_MAP.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>
---
 include/net/cfg80211.h       |  9 +++++++--
 include/uapi/linux/nl80211.h | 12 +++++++++++-
 net/mac80211/cfg.c           |  1 +
 net/wireless/nl80211.c       | 12 +++++++++++-
 net/wireless/rdev-ops.h      |  7 ++++---
 net/wireless/trace.h         | 11 +++++++----
 6 files changed, 41 insertions(+), 11 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index fc40843..b974d32 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2872,7 +2872,12 @@ struct cfg80211_external_auth_params {
  * @probe_client: probe an associated client, must return a cookie that it
  *	later passes to cfg80211_probe_status().
  *
- * @set_noack_map: Set the NoAck Map for the TIDs.
+ * @set_noack_map: Set the NoAck Map for the TIDs. When peer is not %NULL NoAck
+ *	map will be applied for that particular peer. When peer is %NULL NoAck
+ *	map will be applied for all the connected stations (except the ones
+ *	which already have per-peer TID map configured) on the netdev.
+ *	Driver should return -ENOSPC when the it does not have room for
+ *	additional entries for per-peer NoAck map.
  *
  * @get_channel: Get the current operating channel for the virtual interface.
  *	For monitor interfaces, it should return %NULL unless there's a single
@@ -3180,7 +3185,7 @@ struct cfg80211_ops {
 
 	int	(*set_noack_map)(struct wiphy *wiphy,
 				  struct net_device *dev,
-				  u16 noack_map);
+				  const u8 *peer, u16 noack_map);
 
 	int	(*get_channel)(struct wiphy *wiphy,
 			       struct wireless_dev *wdev,
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 60fefc5..7425ea6 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -784,7 +784,14 @@
  *	messages. Note that per PHY only one application may register.
  *
  * @NL80211_CMD_SET_NOACK_MAP: sets a bitmap for the individual TIDs whether
- *      No Acknowledgement Policy should be applied.
+ *	No Acknowledgement Policy should be applied. %NL80211_ATTR_MAC is used
+ *	to apply No Acknowledgement policy for a particular connected station.
+ *	Station specific NoAck policy configuration is valid only for STA's
+ *	current connection, i.e. the configuration will not be used when the
+ *	station connects back after disconnection/roaming.
+ *	When user-space does not include %NL80211_ATTR_MAC, the No
+ *	Acknowledgement Policy setting should be treated as per-netdev
+ *	configuration.
  *
  * @NL80211_CMD_CH_SWITCH_NOTIFY: An AP or GO may decide to switch channels
  *	independently of the userspace SME, send this event indicating
@@ -5005,6 +5012,8 @@ enum nl80211_feature_flags {
  *	channel change triggered by radar detection event.
  *	No need to start CAC from user-space, no need to react to
  *	"radar detected" event.
+ * @NL80211_EXT_FEATURE_PER_STA_NOACK_MAP: Driver supports STA specific NoAck
+ *	policy functionality.
  *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
@@ -5036,6 +5045,7 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_LOW_POWER_SCAN,
 	NL80211_EXT_FEATURE_HIGH_ACCURACY_SCAN,
 	NL80211_EXT_FEATURE_DFS_OFFLOAD,
+	NL80211_EXT_FEATURE_PER_STA_NOACK_MAP,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a2f0eae..621ef38 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -341,6 +341,7 @@ static void ieee80211_del_nan_func(struct wiphy *wiphy,
 
 static int ieee80211_set_noack_map(struct wiphy *wiphy,
 				  struct net_device *dev,
+				  const u8 *peer,
 				  u16 noack_map)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index fe27ab4..8d7f055a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3095,16 +3095,26 @@ static int nl80211_set_noack_map(struct sk_buff *skb, struct genl_info *info)
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct net_device *dev = info->user_ptr[1];
 	u16 noack_map;
+	const u8 *peer = NULL;
 
 	if (!info->attrs[NL80211_ATTR_NOACK_MAP])
 		return -EINVAL;
 
+	if (info->attrs[NL80211_ATTR_MAC]) {
+		if (!wiphy_ext_feature_isset(
+				&rdev->wiphy,
+				NL80211_EXT_FEATURE_PER_STA_NOACK_MAP))
+			return -EOPNOTSUPP;
+
+		peer = nla_data(info->attrs[NL80211_ATTR_MAC]);
+	}
+
 	if (!rdev->ops->set_noack_map)
 		return -EOPNOTSUPP;
 
 	noack_map = nla_get_u16(info->attrs[NL80211_ATTR_NOACK_MAP]);
 
-	return rdev_set_noack_map(rdev, dev, noack_map);
+	return rdev_set_noack_map(rdev, dev, peer, noack_map);
 }
 
 struct get_key_cookie {
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 84f23ae..5c9089d 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -881,11 +881,12 @@ static inline int rdev_probe_client(struct cfg80211_registered_device *rdev,
 }
 
 static inline int rdev_set_noack_map(struct cfg80211_registered_device *rdev,
-				     struct net_device *dev, u16 noack_map)
+				     struct net_device *dev, const u8 *peer,
+				     u16 noack_map)
 {
 	int ret;
-	trace_rdev_set_noack_map(&rdev->wiphy, dev, noack_map);
-	ret = rdev->ops->set_noack_map(&rdev->wiphy, dev, noack_map);
+	trace_rdev_set_noack_map(&rdev->wiphy, dev, peer, noack_map);
+	ret = rdev->ops->set_noack_map(&rdev->wiphy, dev, peer, noack_map);
 	trace_rdev_return_int(&rdev->wiphy, ret);
 	return ret;
 }
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 5152938..caecf18 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1883,21 +1883,24 @@
 );
 
 TRACE_EVENT(rdev_set_noack_map,
-	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev, const u8 *peer,
 		 u16 noack_map),
-	TP_ARGS(wiphy, netdev, noack_map),
+	TP_ARGS(wiphy, netdev, peer, noack_map),
 	TP_STRUCT__entry(
 		WIPHY_ENTRY
 		NETDEV_ENTRY
+		MAC_ENTRY(peer)
 		__field(u16, noack_map)
 	),
 	TP_fast_assign(
 		WIPHY_ASSIGN;
 		NETDEV_ASSIGN;
+		MAC_ASSIGN(peer, peer);
 		__entry->noack_map = noack_map;
 	),
-	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", noack_map: %u",
-		  WIPHY_PR_ARG, NETDEV_PR_ARG, __entry->noack_map)
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", " MAC_PR_FMT
+		  ", noack_map: %u", WIPHY_PR_ARG, NETDEV_PR_ARG,
+		  MAC_PR_ARG(peer), __entry->noack_map)
 );
 
 DEFINE_EVENT(wiphy_wdev_evt, rdev_get_channel,
-- 
1.9.1
