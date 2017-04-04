Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:2122 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750998AbdDDFmZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Apr 2017 01:42:25 -0400
From: <c_traja@qti.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: <ath10k@lists.infradead.org>, <johannes@sipsolutions.net>,
        <tamizhchelvam@codeaurora.org>,
        Tamizh chelvam <c_traja@qti.qualcomm.com>
Subject: [PATCHv3 1/2] cfg80211: Add support to enable or disable btcoex and  set btcoex_priority
Date: Tue, 4 Apr 2017 11:12:37 +0530
Message-ID: <1491284558-1915-2-git-send-email-c_traja@qti.qualcomm.com> (sfid-20170404_074228_879656_1C50C926)
In-Reply-To: <1491284558-1915-1-git-send-email-c_traja@qti.qualcomm.com>
References: <1491284558-1915-1-git-send-email-c_traja@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tamizh chelvam <c_traja@qti.qualcomm.com>

This patch introduces NL80211_CMD_SET_BTCOEX command and
NL80211_ATTR_BTCOEX_OP attribute to enable or disable btcoex.
And this change enables user to set btcoex priority by using
NL80211_ATTR_BTCOEX_PRIORITY attribute for the driver which
has the btcoex priority capability. Driver should expose such
capability and make use of this priority to decide whom to share the radio
(either bluetooth or WLAN). When the high priority wlan frames are queued
driver or firmware will signal to block BT activity.
Capable drivers should advertise this support by setting
NL80211_EXT_FEATURE_BTCOEX_PRIORITY nl80211 extended feature.

Signed-off-by: Tamizh chelvam <c_traja@qti.qualcomm.com>
---
 include/net/cfg80211.h       |   35 ++++++++++++++++++++++++++++++++
 include/uapi/linux/nl80211.h |   20 +++++++++++++++++++
 net/wireless/nl80211.c       |   45 ++++++++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      |   13 ++++++++++++
 net/wireless/trace.h         |   17 ++++++++++++++++
 5 files changed, 130 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 273b1dc..b144998 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2856,6 +2856,10 @@ struct cfg80211_nan_func {
  *	All other parameters must be ignored.
  *
  * @set_multicast_to_unicast: configure multicast to unicast conversion for BSS
+ * @set_btcoex: Use this callback to call driver API when user wants to
+ *	enable/disable btcoex and use this callback to set wlan high priority
+ *	over bluetooth. When BTCOEX enabled, the high priority wlan frames
+ *	will have more priority than BT.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -3144,6 +3148,8 @@ struct cfg80211_ops {
 	int	(*set_multicast_to_unicast)(struct wiphy *wiphy,
 					    struct net_device *dev,
 					    const bool enabled);
+	int     (*set_btcoex)(struct wiphy *wiphy, bool enabled,
+			      u32 btcoex_priority);
 };
 
 /*
@@ -3488,6 +3494,35 @@ struct wiphy_iftype_ext_capab {
 };
 
 /**
+ * enum btcoex_priority_support_flag - btcoex priority supported frame types and
+ *	its bitmap values.
+ * @WIPHY_BTCOEX_SUPPORTS_BE_PREF - BE wlan frame takes more preference than
+ *	 BT traffic.
+ * @WIPHY_BTCOEX_SUPPORTS_BK_PREF - BK wlan frame takes more preference than
+ *	 BT traffic.
+ * @WIPHY_BTCOEX_SUPPORTS_VI_PREF - VI wlan frame takes more preference than
+ *	 BT traffic.
+ * @WIPHY_BTCOEX_SUPPORTS_VO_PREF - VO wlan frame takes more preference than
+ *	 BT traffic.
+ * @WIPHY_BTCOEX_SUPPORTS_BEACON_PREF - BEACON wlan frame takes more preference
+ *	than  BT traffic.
+ * @WIPHY_BTCOEX_SUPPORTS_MGMT_PREF - MGMT wlan frame takes more preference than
+ *	 BT traffic.
+ * @WIPHY_BTCOEX_SUPPORTS_MAX_PREF - MAX supported value for btcoex priority
+ *	feature.
+ */
+
+enum btcoex_priority_support_flag {
+	WIPHY_BTCOEX_SUPPORTS_BE_PREF = BIT(0),
+	WIPHY_BTCOEX_SUPPORTS_BK_PREF = BIT(1),
+	WIPHY_BTCOEX_SUPPORTS_VI_PREF = BIT(2),
+	WIPHY_BTCOEX_SUPPORTS_VO_PREF = BIT(3),
+	WIPHY_BTCOEX_SUPPORTS_BEACON_PREF = BIT(4),
+	WIPHY_BTCOEX_SUPPORTS_MGMT_PREF = BIT(5),
+	WIPHY_BTCOEX_SUPPORTS_MAX_PREF	= BIT(6) - 1,
+};
+
+/**
  * struct wiphy - wireless hardware description
  * @reg_notifier: the driver's regulatory notification callback,
  *	note that if your driver uses wiphy_apply_custom_regulatory()
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 6095a6c..e6b2647 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -944,6 +944,8 @@
  *	BSS selection. This command can be issued only while connected and it
  *	does not result in a change for the current association. Currently,
  *	only the %NL80211_ATTR_IE data is used and updated with this command.
+ * @NL80211_CMD_SET_BTCOEX: Enable/Disable btcoex using
+ *	%NL80211_ATTR_SET_BTCOEX
  *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
@@ -1144,6 +1146,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_UPDATE_CONNECT_PARAMS,
 
+	NL80211_CMD_SET_BTCOEX,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -2081,6 +2085,16 @@ enum nl80211_commands {
  * @NL80211_ATTR_PMK: PMK for the PMKSA identified by %NL80211_ATTR_PMKID.
  *	This is used with @NL80211_CMD_SET_PMKSA.
  *
+ * @NL80211_ATTR_BTCOEX_OP: u8 attribute for driver supporting
+ *	the btcoex feature. When used with %NL80211_CMD_SET_BTCOEX it contains
+ *	either 0 for disable or 1 for enable btcoex.
+ *
+ * @NL80211_ATTR_BTCOEX_PRIORITY: This is for the driver which supprot
+ *	btcoex priority feature. It used with %NL80211_CMD_SET_BTCOEX.
+ *	This will have u32 BITMAP value which represents
+ *	frame(bk, be, vi, vo, mgmt, beacon) type and that will have more
+ *	priority than a BT traffic.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2500,6 +2514,9 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_PMK,
 
+	NL80211_ATTR_BTCOEX_OP,
+	NL80211_ATTR_BTCOEX_PRIORITY,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -4838,6 +4855,8 @@ enum nl80211_feature_flags {
  *	RSSI threshold values to monitor rather than exactly one threshold.
  * @NL80211_EXT_FEATURE_FILS_SK_OFFLOAD: Driver SME supports FILS shared key
  *	authentication with %NL80211_CMD_CONNECT.
+ * @NL80211_EXT_FEATURE_BTCOEX_PRIORITY: Driver supprots btcoex priority
+ *	feature with %NL80211_ATTR_BTCOEX_PRIORITY.
  *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
@@ -4858,6 +4877,7 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_SCHED_SCAN_RELATIVE_RSSI,
 	NL80211_EXT_FEATURE_CQM_RSSI_LIST,
 	NL80211_EXT_FEATURE_FILS_SK_OFFLOAD,
+	NL80211_EXT_FEATURE_BTCOEX_PRIORITY,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 9910aae..3e39d0d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -419,6 +419,8 @@ enum nl80211_multicast_groups {
 					.len = FILS_ERP_MAX_RRK_LEN },
 	[NL80211_ATTR_FILS_CACHE_ID] = { .len = 2 },
 	[NL80211_ATTR_PMK] = { .type = NLA_BINARY, .len = PMK_MAX_LEN },
+	[NL80211_ATTR_BTCOEX_OP] = { .type = NLA_U8 },
+	[NL80211_ATTR_BTCOEX_PRIORITY] = { .type = NLA_U32 },
 };
 
 /* policy for the key attributes */
@@ -12184,6 +12186,41 @@ static int nl80211_set_multicast_to_unicast(struct sk_buff *skb,
 	return rdev_set_multicast_to_unicast(rdev, dev, enabled);
 }
 
+static int nl80211_set_btcoex(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct wiphy *wiphy = &rdev->wiphy;
+	u8 val = 0;
+	u32 btcoex_priority = 0;
+
+	if (!rdev->ops->set_btcoex)
+		return -ENOTSUPP;
+
+	if (!(info->attrs[NL80211_ATTR_BTCOEX_OP]))
+		goto set_btcoex;
+
+	if (info->attrs[NL80211_ATTR_BTCOEX_OP])
+		val = nla_get_u8(info->attrs[NL80211_ATTR_BTCOEX_OP]);
+
+	if (val > 1)
+		return -EINVAL;
+
+	if (info->attrs[NL80211_ATTR_BTCOEX_PRIORITY]) {
+		if (!wiphy_ext_feature_isset(wiphy,
+					NL80211_EXT_FEATURE_BTCOEX_PRIORITY))
+			return -EOPNOTSUPP;
+
+		btcoex_priority =
+		nla_get_u32(info->attrs[NL80211_ATTR_BTCOEX_PRIORITY]);
+
+		if (btcoex_priority > WIPHY_BTCOEX_SUPPORTS_MAX_PREF)
+			return -E2BIG;
+	}
+
+set_btcoex:
+	return rdev_set_btcoex(rdev, val, btcoex_priority);
+}
+
 #define NL80211_FLAG_NEED_WIPHY		0x01
 #define NL80211_FLAG_NEED_NETDEV	0x02
 #define NL80211_FLAG_NEED_RTNL		0x04
@@ -13059,6 +13096,14 @@ static void nl80211_post_doit(const struct genl_ops *ops, struct sk_buff *skb,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL80211_CMD_SET_BTCOEX,
+		.doit = nl80211_set_btcoex,
+		.policy = nl80211_policy,
+		.flags = GENL_UNS_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_WIPHY |
+				  NL80211_FLAG_NEED_RTNL,
+	},
 };
 
 static struct genl_family nl80211_fam __ro_after_init = {
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index f2baf59..d0dec56 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -1165,4 +1165,17 @@ static inline int rdev_set_qos_map(struct cfg80211_registered_device *rdev,
 	trace_rdev_return_int(&rdev->wiphy, ret);
 	return ret;
 }
+
+static inline int
+rdev_set_btcoex(struct cfg80211_registered_device *rdev, bool enabled,
+		u32 btcoex_priority)
+{
+	int ret = -ENOTSUPP;
+
+	trace_rdev_set_btcoex(&rdev->wiphy, enabled, btcoex_priority);
+	ret = rdev->ops->set_btcoex(&rdev->wiphy, enabled, btcoex_priority);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
+
 #endif /* __CFG80211_RDEV_OPS */
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index fd55786..1947011 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -3069,6 +3069,23 @@
 		  WIPHY_PR_ARG, __entry->n_rules)
 );
 
+TRACE_EVENT(rdev_set_btcoex,
+	TP_PROTO(struct wiphy *wiphy, bool enabled, u32 btcoex_priority),
+	TP_ARGS(wiphy, enabled, btcoex_priority),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		__field(bool, enabled)
+		__field(u32, btcoex_priority)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		__entry->enabled = enabled;
+		__entry->btcoex_priority = btcoex_priority;
+	),
+	TP_printk(WIPHY_PR_FMT ", enabled=%d btcoex_priority :%u",
+		  WIPHY_PR_ARG, __entry->enabled, __entry->btcoex_priority)
+);
+
 DEFINE_EVENT(wiphy_wdev_evt, rdev_abort_scan,
 	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev),
 	TP_ARGS(wiphy, wdev)
-- 
1.7.9.5
