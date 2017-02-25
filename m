Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:29262 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751281AbdBYNps (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 25 Feb 2017 08:45:48 -0500
From: <c_traja@qti.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: <johannes@sipsolutions.net>, <ath10k@lists.infradead.org>,
        Tamizh chelvam <c_traja@qti.qualcomm.com>
Subject: [PATCHv2 3/4] cfg80211: Add Support set btcoex priority value
Date: Sat, 25 Feb 2017 19:07:52 +0530
Message-ID: <1488029873-14600-4-git-send-email-c_traja@qti.qualcomm.com> (sfid-20170225_145114_012376_A3AAECF4)
In-Reply-To: <1488029873-14600-1-git-send-email-c_traja@qti.qualcomm.com>
References: <1488029873-14600-1-git-send-email-c_traja@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tamizh chelvam <c_traja@qti.qualcomm.com>

This change enables user to set btcoex priority by using
NL80211_ATTR_BTCOEX_PRIORITY attribute for the driver which
has the btcoex priority capability. Driver should expose such
capability and make use of this priority to decide whom to share the radio
(either bluetooth or WLAN). When the high priority wlan frames are queued
driver or firmware will signal to block BT activity.
Capable drivers should advertise this support through
btcoex_priority_support.

This will be useful to avoid connection lost or packet drop
issue when BT is active on long time.

Signed-off-by: Tamizh chelvam <c_traja@qti.qualcomm.com>
---
 include/net/cfg80211.h       |   10 ++++++++--
 include/uapi/linux/nl80211.h |    7 +++++++
 net/wireless/nl80211.c       |   16 +++++++++++++++-
 net/wireless/rdev-ops.h      |    8 +++++---
 net/wireless/trace.h         |   10 ++++++----
 5 files changed, 41 insertions(+), 10 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index a9aae03..3f44aac 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2817,7 +2817,10 @@ struct cfg80211_nan_func {
  *
  * @set_multicast_to_unicast: configure multicast to unicast conversion for BSS
  * @set_btcoex: Use this callback to call driver API when user wants to
- *	enable/disable btcoex.
+ *	enable/disable btcoex and use this callback to set wlan high priority over
+ *	Bluetooth. This capability will be exposed by the driver using
+ *	btcoex_priority_support boolean flag. When BTCOEX enabled,
+ *	the high priority wlan frames will have more priority than BT.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -3102,7 +3105,8 @@ struct cfg80211_ops {
 	int	(*set_multicast_to_unicast)(struct wiphy *wiphy,
 					    struct net_device *dev,
 					    const bool enabled);
-	int     (*set_btcoex)(struct wiphy *wiphy, bool enabled);
+	int     (*set_btcoex)(struct wiphy *wiphy, bool enabled,
+			      int btcoex_priority);
 };
 
 /*
@@ -3738,6 +3742,8 @@ struct wiphy {
 
 	u8 nan_supported_bands;
 
+	bool btcoex_priority_support;
+
 	char priv[0] __aligned(NETDEV_ALIGN);
 };
 
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 30d691f..94b6eff 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2019,6 +2019,12 @@ enum nl80211_commands {
  *     the btcoex feature. When used with %NL80211_CMD_SET_BTCOEX it contains
  *     either 0 for disable or 1 for enable btcoex.
  *
+ * @NL80211_ATTR_BTCOEX_PRIORITY: This is for the driver which
+ *     support btcoex priority feature. It used with %NL80211_CMD_SET_BTCOEX.
+ *     This will have u32 BITMAP value which represents
+ *     frame(bk, be, vi, vo, mgmt, beacon) type and that will have more
+ *     priority than a BT traffic.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2431,6 +2437,7 @@ enum nl80211_attrs {
 	NL80211_ATTR_TIMEOUT_REASON,
 
 	NL80211_ATTR_BTCOEX_OP,
+	NL80211_ATTR_BTCOEX_PRIORITY,
 
 	/* add attributes here, update the policy in nl80211.c */
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index bd203c2..56518c4 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -411,6 +411,7 @@ enum nl80211_multicast_groups {
 	},
 	[NL80211_ATTR_TIMEOUT_REASON] = { .type = NLA_U32 },
 	[NL80211_ATTR_BTCOEX_OP] = { .type = NLA_U8 },
+	[NL80211_ATTR_BTCOEX_PRIORITY] = { .type = NLA_U32 },
 };
 
 /* policy for the key attributes */
@@ -11970,7 +11971,9 @@ static int nl80211_set_multicast_to_unicast(struct sk_buff *skb,
 static int nl80211_set_btcoex(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct wiphy *wiphy = &rdev->wiphy;
 	u8 val = 0;
+	int btcoex_priority = -1;
 
 	if (!rdev->ops->set_btcoex)
 		return -ENOTSUPP;
@@ -11984,9 +11987,20 @@ static int nl80211_set_btcoex(struct sk_buff *skb, struct genl_info *info)
 	if (val > 1)
 		return -EINVAL;
 
+	if (wiphy->btcoex_priority_support)
+		btcoex_priority = 0;
+
+	if (info->attrs[NL80211_ATTR_BTCOEX_PRIORITY]) {
+		if (!wiphy->btcoex_priority_support)
+			return -EOPNOTSUPP;
+
+		btcoex_priority =
+		nla_get_u32(info->attrs[NL80211_ATTR_BTCOEX_PRIORITY]);
+
+	}
 
 set_btcoex:
-	return rdev_set_btcoex(rdev, val);
+	return rdev_set_btcoex(rdev, val, btcoex_priority);
 }
 
 #define NL80211_FLAG_NEED_WIPHY		0x01
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 6592f14..7c0c139 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -1155,13 +1155,15 @@ static inline int rdev_set_qos_map(struct cfg80211_registered_device *rdev,
 }
 
 static inline int
-rdev_set_btcoex(struct cfg80211_registered_device *rdev, bool enabled)
+rdev_set_btcoex(struct cfg80211_registered_device *rdev, bool enabled,
+		int btcoex_priority)
 {
 	int ret = -ENOTSUPP;
 
-	trace_rdev_set_btcoex(&rdev->wiphy, enabled);
-	ret = rdev->ops->set_btcoex(&rdev->wiphy, enabled);
+	trace_rdev_set_btcoex(&rdev->wiphy, enabled, btcoex_priority);
+	ret = rdev->ops->set_btcoex(&rdev->wiphy, enabled, btcoex_priority);
 	trace_rdev_return_int(&rdev->wiphy, ret);
 	return ret;
 }
+
 #endif /* __CFG80211_RDEV_OPS */
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index c3970b1..4f88f50 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -3048,18 +3048,20 @@
 );
 
 TRACE_EVENT(rdev_set_btcoex,
-	TP_PROTO(struct wiphy *wiphy, bool enabled),
-	TP_ARGS(wiphy, enabled),
+	TP_PROTO(struct wiphy *wiphy, bool enabled, int btcoex_priority),
+	TP_ARGS(wiphy, enabled, btcoex_priority),
 	TP_STRUCT__entry(
 		WIPHY_ENTRY
 		__field(bool, enabled)
+		__field(int, btcoex_priority)
 	),
 	TP_fast_assign(
 		WIPHY_ASSIGN;
 		__entry->enabled = enabled;
+		__entry->btcoex_priority = btcoex_priority;
 	),
-	TP_printk(WIPHY_PR_FMT, ", enabled=%d",
-		  WIPHY_PR_ARG, __entry->enabled)
+	TP_printk(WIPHY_PR_FMT, ", enabled=%d btcoex_priority :%d",
+		  WIPHY_PR_ARG, __entry->enabled, __entry->btcoex_priority)
 );
 
 DEFINE_EVENT(wiphy_wdev_evt, rdev_abort_scan,
-- 
1.7.9.5
