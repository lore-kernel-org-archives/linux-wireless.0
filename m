Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:10267 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751214AbdBYNwC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 25 Feb 2017 08:52:02 -0500
From: <c_traja@qti.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: <johannes@sipsolutions.net>, <ath10k@lists.infradead.org>,
        Tamizh chelvam <c_traja@qti.qualcomm.com>
Subject: [PATCHv2 1/4] cfg80211: Add support to enable or disable btcoex
Date: Sat, 25 Feb 2017 19:07:50 +0530
Message-ID: <1488029873-14600-2-git-send-email-c_traja@qti.qualcomm.com> (sfid-20170225_145206_128572_517B9438)
In-Reply-To: <1488029873-14600-1-git-send-email-c_traja@qti.qualcomm.com>
References: <1488029873-14600-1-git-send-email-c_traja@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tamizh chelvam <c_traja@qti.qualcomm.com>

This patch introduces NL80211_CMD_SET_BTCOEX command and
NL80211_ATTR_BTCOEX_OP attribute to enable or disable btcoex.

Signed-off-by: Tamizh chelvam <c_traja@qti.qualcomm.com>
---
 include/net/cfg80211.h       |    3 +++
 include/uapi/linux/nl80211.h |    9 +++++++++
 net/wireless/nl80211.c       |   31 +++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      |   11 +++++++++++
 net/wireless/trace.h         |   15 +++++++++++++++
 5 files changed, 69 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index c92dc03..a9aae03 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2816,6 +2816,8 @@ struct cfg80211_nan_func {
  *	All other parameters must be ignored.
  *
  * @set_multicast_to_unicast: configure multicast to unicast conversion for BSS
+ * @set_btcoex: Use this callback to call driver API when user wants to
+ *	enable/disable btcoex.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -3100,6 +3102,7 @@ struct cfg80211_ops {
 	int	(*set_multicast_to_unicast)(struct wiphy *wiphy,
 					    struct net_device *dev,
 					    const bool enabled);
+	int     (*set_btcoex)(struct wiphy *wiphy, bool enabled);
 };
 
 /*
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 5ed257c..30d691f 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -900,6 +900,8 @@
  *	BSS selection. This command can be issued only while connected and it
  *	does not result in a change for the current association. Currently,
  *	only the %NL80211_ATTR_IE data is used and updated with this command.
+ * @NL80211_CMD_SET_BTCOEX: Enable/Disable btcoex using
+ *	%NL80211_ATTR_SET_BTCOEX
  *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
@@ -1100,6 +1102,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_UPDATE_CONNECT_PARAMS,
 
+	NL80211_CMD_SET_BTCOEX,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -2011,6 +2015,9 @@ enum nl80211_commands {
  * @NL80211_ATTR_TIMEOUT_REASON: The reason for which an operation timed out.
  *	u32 attribute with an &enum nl80211_timeout_reason value. This is used,
  *	e.g., with %NL80211_CMD_CONNECT event.
+ * @NL80211_ATTR_BTCOEX_OP: u8 attribute for driver supporting
+ *     the btcoex feature. When used with %NL80211_CMD_SET_BTCOEX it contains
+ *     either 0 for disable or 1 for enable btcoex.
  *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
@@ -2423,6 +2430,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_TIMEOUT_REASON,
 
+	NL80211_ATTR_BTCOEX_OP,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d7f8be4..bd203c2 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -410,6 +410,7 @@ enum nl80211_multicast_groups {
 		.len = sizeof(struct nl80211_bss_select_rssi_adjust)
 	},
 	[NL80211_ATTR_TIMEOUT_REASON] = { .type = NLA_U32 },
+	[NL80211_ATTR_BTCOEX_OP] = { .type = NLA_U8 },
 };
 
 /* policy for the key attributes */
@@ -11966,6 +11967,28 @@ static int nl80211_set_multicast_to_unicast(struct sk_buff *skb,
 	return rdev_set_multicast_to_unicast(rdev, dev, enabled);
 }
 
+static int nl80211_set_btcoex(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	u8 val = 0;
+
+	if (!rdev->ops->set_btcoex)
+		return -ENOTSUPP;
+
+	if(!(info->attrs[NL80211_ATTR_BTCOEX_OP]))
+		goto set_btcoex;
+
+	if (info->attrs[NL80211_ATTR_BTCOEX_OP])
+		val = nla_get_u8(info->attrs[NL80211_ATTR_BTCOEX_OP]);
+
+	if (val > 1)
+		return -EINVAL;
+
+
+set_btcoex:
+	return rdev_set_btcoex(rdev, val);
+}
+
 #define NL80211_FLAG_NEED_WIPHY		0x01
 #define NL80211_FLAG_NEED_NETDEV	0x02
 #define NL80211_FLAG_NEED_RTNL		0x04
@@ -12841,6 +12864,14 @@ static void nl80211_post_doit(const struct genl_ops *ops, struct sk_buff *skb,
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
index 2f42507..6592f14 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -1153,4 +1153,15 @@ static inline int rdev_set_qos_map(struct cfg80211_registered_device *rdev,
 	trace_rdev_return_int(&rdev->wiphy, ret);
 	return ret;
 }
+
+static inline int
+rdev_set_btcoex(struct cfg80211_registered_device *rdev, bool enabled)
+{
+	int ret = -ENOTSUPP;
+
+	trace_rdev_set_btcoex(&rdev->wiphy, enabled);
+	ret = rdev->ops->set_btcoex(&rdev->wiphy, enabled);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
 #endif /* __CFG80211_RDEV_OPS */
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 776e80c..c3970b1 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -3047,6 +3047,21 @@
 		  WIPHY_PR_ARG, __entry->n_rules)
 );
 
+TRACE_EVENT(rdev_set_btcoex,
+	TP_PROTO(struct wiphy *wiphy, bool enabled),
+	TP_ARGS(wiphy, enabled),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		__field(bool, enabled)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		__entry->enabled = enabled;
+	),
+	TP_printk(WIPHY_PR_FMT, ", enabled=%d",
+		  WIPHY_PR_ARG, __entry->enabled)
+);
+
 DEFINE_EVENT(wiphy_wdev_evt, rdev_abort_scan,
 	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev),
 	TP_ARGS(wiphy, wdev)
-- 
1.7.9.5
