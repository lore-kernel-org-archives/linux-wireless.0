Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:45971 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbaD1IWO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Apr 2014 04:22:14 -0400
Date: Mon, 28 Apr 2014 11:22:08 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/3] cfg80211: Dynamic channel bandwidth changes in AP mode
Message-ID: <20140428082208.GA15442@jouni.qca.qualcomm.com> (sfid-20140428_102221_906477_7EF88C62)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This extends NL80211_CMD_SET_CHANNEL to allow dynamic channel bandwidth
changes in AP mode (including P2P GO) during a lifetime of the BSS. This
can be used to implement, e.g., HT 20/40 MHz co-existence rules on the
2.4 GHz band.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 include/net/cfg80211.h       |    7 +++++++
 include/uapi/linux/nl80211.h |    4 ++++
 net/wireless/nl80211.c       |   40 ++++++++++++++++++++++++++++------------
 net/wireless/rdev-ops.h      |   12 ++++++++++++
 net/wireless/trace.h         |   18 ++++++++++++++++++
 5 files changed, 69 insertions(+), 12 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index f3539a1..f8a7dfe 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2278,6 +2278,10 @@ struct cfg80211_qos_map {
  * @channel_switch: initiate channel-switch procedure (with CSA)
  *
  * @set_qos_map: Set QoS mapping information to the driver
+ *
+ * @set_ap_channel: Set the AP (including P2P GO) mode channel for the device.
+ *	This is used for dynamic HT 20/40 MHz channel width changes during the
+ *	lifetime of the BSS.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -2524,6 +2528,9 @@ struct cfg80211_ops {
 	int     (*set_qos_map)(struct wiphy *wiphy,
 			       struct net_device *dev,
 			       struct cfg80211_qos_map *qos_map);
+	int	(*set_ap_channel)(struct wiphy *wiphy,
+				  struct net_device *dev,
+				  struct cfg80211_chan_def *chandef);
 };
 
 /*
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 1ba9d62..8bcf86e 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -3891,6 +3891,9 @@ enum nl80211_ap_sme_features {
  *	interface. An active monitor interface behaves like a normal monitor
  *	interface, but gets added to the driver. It ensures that incoming
  *	unicast packets directed at the configured interface address get ACKed.
+ * @NL80211_FEATURE_AP_MODE_CHAN_WIDTH_CHANGE: This driver supports dynamic
+ *	channel bandwidth change (e.g., HT 20 <-> 40 MHz channel) during the
+ *	lifetime of a BSS.
  */
 enum nl80211_feature_flags {
 	NL80211_FEATURE_SK_TX_STATUS			= 1 << 0,
@@ -3911,6 +3914,7 @@ enum nl80211_feature_flags {
 	NL80211_FEATURE_FULL_AP_CLIENT_STATE		= 1 << 15,
 	NL80211_FEATURE_USERSPACE_MPM			= 1 << 16,
 	NL80211_FEATURE_ACTIVE_MONITOR			= 1 << 17,
+	NL80211_FEATURE_AP_MODE_CHAN_WIDTH_CHANGE	= 1 << 18,
 };
 
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 052c1bf..059c96c 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1908,18 +1908,20 @@ static int nl80211_parse_chandef(struct cfg80211_registered_device *rdev,
 }
 
 static int __nl80211_set_channel(struct cfg80211_registered_device *rdev,
-				 struct wireless_dev *wdev,
+				 struct net_device *dev,
 				 struct genl_info *info)
 {
 	struct cfg80211_chan_def chandef;
 	int result;
 	enum nl80211_iftype iftype = NL80211_IFTYPE_MONITOR;
+	struct wireless_dev *wdev = NULL;
 
-	if (wdev)
-		iftype = wdev->iftype;
-
+	if (dev)
+		wdev = dev->ieee80211_ptr;
 	if (!nl80211_can_set_dev_channel(wdev))
 		return -EOPNOTSUPP;
+	if (wdev)
+		iftype = wdev->iftype;
 
 	result = nl80211_parse_chandef(rdev, info, &chandef);
 	if (result)
@@ -1928,14 +1930,27 @@ static int __nl80211_set_channel(struct cfg80211_registered_device *rdev,
 	switch (iftype) {
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_P2P_GO:
-		if (wdev->beacon_interval) {
-			result = -EBUSY;
-			break;
-		}
 		if (!cfg80211_reg_can_beacon(&rdev->wiphy, &chandef)) {
 			result = -EINVAL;
 			break;
 		}
+		if (wdev->beacon_interval) {
+			if (!dev || !rdev->ops->set_ap_channel ||
+			    !(rdev->wiphy.features &
+			      NL80211_FEATURE_AP_MODE_CHAN_WIDTH_CHANGE)) {
+				result = -EBUSY;
+				break;
+			}
+
+			/* Only allow dynamic channel width changes */
+			if (chandef.chan != wdev->preset_chandef.chan) {
+				result = -EBUSY;
+				break;
+			}
+			result = rdev_set_ap_channel(rdev, dev, &chandef);
+			if (result)
+				break;
+		}
 		wdev->preset_chandef = chandef;
 		result = 0;
 		break;
@@ -1957,7 +1972,7 @@ static int nl80211_set_channel(struct sk_buff *skb, struct genl_info *info)
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct net_device *netdev = info->user_ptr[1];
 
-	return __nl80211_set_channel(rdev, netdev->ieee80211_ptr, info);
+	return __nl80211_set_channel(rdev, netdev, info);
 }
 
 static int nl80211_set_wds_peer(struct sk_buff *skb, struct genl_info *info)
@@ -2079,9 +2094,10 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	if (info->attrs[NL80211_ATTR_WIPHY_FREQ]) {
-		result = __nl80211_set_channel(rdev,
-				nl80211_can_set_dev_channel(wdev) ? wdev : NULL,
-				info);
+		result = __nl80211_set_channel(
+			rdev,
+			nl80211_can_set_dev_channel(wdev) ? netdev : NULL,
+			info);
 		if (result)
 			return result;
 	}
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 74d97d3..a3083c0 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -950,4 +950,16 @@ static inline int rdev_set_qos_map(struct cfg80211_registered_device *rdev,
 	return ret;
 }
 
+static inline int
+rdev_set_ap_channel(struct cfg80211_registered_device *rdev,
+		    struct net_device *dev, struct cfg80211_chan_def *chandef)
+{
+	int ret;
+
+	trace_rdev_set_ap_channel(&rdev->wiphy, dev, chandef);
+	ret = rdev->ops->set_ap_channel(&rdev->wiphy, dev, chandef);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
+
 #endif /* __CFG80211_RDEV_OPS */
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index aabccf1..75b8c1a 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1919,6 +1919,24 @@ TRACE_EVENT(rdev_set_qos_map,
 		  WIPHY_PR_ARG, NETDEV_PR_ARG, __entry->num_des)
 );
 
+TRACE_EVENT(rdev_set_ap_channel,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 struct cfg80211_chan_def *chandef),
+	TP_ARGS(wiphy, netdev, chandef),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		CHAN_DEF_ENTRY
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		CHAN_DEF_ASSIGN(chandef);
+	),
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", " CHAN_DEF_PR_FMT,
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, CHAN_DEF_PR_ARG)
+);
+
 /*************************************************************
  *	     cfg80211 exported functions traces		     *
  *************************************************************/
-- 
1.7.9.5


-- 
Jouni Malinen                                            PGP id EFC895FA
