Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51766 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1033174AbeCAR7k (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 12:59:40 -0500
From: Tamizh chelvam <tamizhr@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCH 1/2] cfg80211: Add support to enable or disable btcoex
Date: Thu,  1 Mar 2018 23:29:29 +0530
Message-Id: <1519927170-11920-1-git-send-email-tamizhr@codeaurora.org> (sfid-20180301_185944_165776_C3907BE7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tamizh chelvam <tamizhr@codeaurora.org>

This patch introduces NL80211_CMD_SET_BTCOEX command and
NL80211_ATTR_BTCOEX_OP attribute to enable or disable btcoex.

Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
---
 include/net/cfg80211.h       |    4 ++++
 include/uapi/linux/nl80211.h |   10 ++++++++++
 net/wireless/nl80211.c       |   28 ++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      |   11 +++++++++++
 net/wireless/trace.h         |   15 +++++++++++++++
 5 files changed, 68 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index fc40843..b0e8bf6 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2960,6 +2960,9 @@ struct cfg80211_external_auth_params {
  *
  * @external_auth: indicates result of offloaded authentication processing from
  *     user space
+ *
+ * @set_btcoex: This callback used to Enable/disable btcoex
+ *
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -3255,6 +3258,7 @@ struct cfg80211_ops {
 			   const u8 *aa);
 	int     (*external_auth)(struct wiphy *wiphy, struct net_device *dev,
 				 struct cfg80211_external_auth_params *params);
+	int     (*set_btcoex)(struct wiphy *wiphy, bool enabled);
 };
 
 /*
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index c13c843..3fb45b2 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1018,6 +1018,8 @@
  *	&NL80211_ATTR_CHANNEL_WIDTH,&NL80211_ATTR_NSS attributes with its
  *	address(specified in &NL80211_ATTR_MAC).
  *
+ * @NL80211_CMD_SET_BTCOEX: Enable/Disable btcoex using %NL80211_ATTR_BTCOEX_OP.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -1228,6 +1230,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_STA_OPMODE_CHANGED,
 
+	NL80211_CMD_SET_BTCOEX,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -2196,6 +2200,10 @@ enum nl80211_commands {
  * @NL80211_ATTR_NSS: Station's New/updated  RX_NSS value notified using this
  *	u8 attribute. This is used with %NL80211_CMD_STA_OPMODE_CHANGED.
  *
+ * @NL80211_ATTR_BTCOEX_OP: u8 attribute for driver supporting
+ *	the btcoex feature. This will be used with %NL80211_CMD_SET_BTCOEX
+ *	to enable/disable btcoex.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2628,6 +2636,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_NSS,
 	NL80211_ATTR_ACK_SIGNAL,
 
+	NL80211_ATTR_BTCOEX_OP,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index a910150..ebd119b 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -422,6 +422,7 @@ enum nl80211_multicast_groups {
 	[NL80211_ATTR_PMK] = { .type = NLA_BINARY, .len = PMK_MAX_LEN },
 	[NL80211_ATTR_SCHED_SCAN_MULTI] = { .type = NLA_FLAG },
 	[NL80211_ATTR_EXTERNAL_AUTH_SUPPORT] = { .type = NLA_FLAG },
+	[NL80211_ATTR_BTCOEX_OP] = { .type = NLA_U8 },
 };
 
 /* policy for the key attributes */
@@ -12517,6 +12518,25 @@ static int nl80211_external_auth(struct sk_buff *skb, struct genl_info *info)
 	return rdev_external_auth(rdev, dev, &params);
 }
 
+static int nl80211_set_btcoex(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	u8 val = 0;
+
+	if (!rdev->ops->set_btcoex)
+		return -ENOTSUPP;
+
+	if (!info->attrs[NL80211_ATTR_BTCOEX_OP])
+		return -EINVAL;
+
+	val = nla_get_u8(info->attrs[NL80211_ATTR_BTCOEX_OP]);
+
+	if (val > 1)
+		return -EINVAL;
+
+	return rdev_set_btcoex(rdev, val);
+}
+
 #define NL80211_FLAG_NEED_WIPHY		0x01
 #define NL80211_FLAG_NEED_NETDEV	0x02
 #define NL80211_FLAG_NEED_RTNL		0x04
@@ -13420,6 +13440,14 @@ static void nl80211_post_doit(const struct genl_ops *ops, struct sk_buff *skb,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
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
 
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 84f23ae..4002f2c 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -1205,4 +1205,15 @@ static inline int rdev_del_pmk(struct cfg80211_registered_device *rdev,
 	return ret;
 }
 
+static inline int
+rdev_set_btcoex(struct cfg80211_registered_device *rdev, bool enabled)
+{
+	int ret;
+
+	trace_rdev_set_btcoex(&rdev->wiphy, enabled);
+	ret = rdev->ops->set_btcoex(&rdev->wiphy, enabled);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
+
 #endif /* __CFG80211_RDEV_OPS */
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 5152938..838ec11 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -3173,6 +3173,21 @@
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
+	TP_printk(WIPHY_PR_FMT ", enabled=%d ",
+		  WIPHY_PR_ARG, __entry->enabled)
+);
+
 DEFINE_EVENT(wiphy_wdev_evt, rdev_abort_scan,
 	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev),
 	TP_ARGS(wiphy, wdev)
-- 
1.7.9.5
