Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:6660 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750938AbcKHNPH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Nov 2016 08:15:07 -0500
From: <c_traja@qti.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: <ath10k@lists.infradead.org>, <johannes@sipsolutions.net>,
        <tamizhchelvam@codeaurora.org>,
        Tamizh chelvam <c_traja@qti.qualcomm.com>
Subject: [PATCH 1/4] cfg80211: Add support to enable or disable btcoex
Date: Tue, 8 Nov 2016 18:45:29 +0530
Message-ID: <1478610932-21954-2-git-send-email-c_traja@qti.qualcomm.com> (sfid-20161108_141510_052010_C2D2D47F)
In-Reply-To: <1478610932-21954-1-git-send-email-c_traja@qti.qualcomm.com>
References: <1478610932-21954-1-git-send-email-c_traja@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tamizh chelvam <c_traja@qti.qualcomm.com>

This patch adds support to enable or disable btcoex by
adding NL80211_ATTR_WIPHY_BTCOEX_ENABLE attribute in
NL80211_CMD_SET_WIPHY command. By default BTCOEX disabled in driver.

Signed-off-by: Tamizh chelvam <c_traja@qti.qualcomm.com>
---
 include/net/cfg80211.h       |    3 +++
 include/uapi/linux/nl80211.h |    6 ++++++
 net/wireless/nl80211.c       |   18 ++++++++++++++++++
 net/wireless/rdev-ops.h      |   11 +++++++++++
 net/wireless/trace.h         |    5 +++++
 5 files changed, 43 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 9390365..919ed1d 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2735,6 +2735,8 @@ struct cfg80211_nan_func {
  * @nan_change_conf: changes NAN configuration. The changed parameters must
  *	be specified in @changes (using &enum cfg80211_nan_conf_changes);
  *	All other parameters must be ignored.
+ * @set_btcoex: Use this callback to call driver API when user wants to
+ *     enable/disable btcoex.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -3011,6 +3013,7 @@ struct cfg80211_ops {
 				   struct wireless_dev *wdev,
 				   struct cfg80211_nan_conf *conf,
 				   u32 changes);
+	int     (*set_btcoex)(struct wiphy *wiphy, bool enabled);
 };
 
 /*
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 1362d24..c47fe6c8 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1937,6 +1937,10 @@ enum nl80211_commands {
  * @NL80211_ATTR_NAN_MATCH: used to report a match. This is a nested attribute.
  *	See &enum nl80211_nan_match_attributes.
  *
+ * @NL80211_ATTR_WIPHY_BTCOEX_ENABLE: u8 attribute for driver supporting
+ *	the btcoex feature. When used with %NL80211_CMD_SET_WIPHY it contains
+ *	either 0 for disable or 1 for enable btcoex.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2336,6 +2340,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_NAN_FUNC,
 	NL80211_ATTR_NAN_MATCH,
 
+	NL80211_ATTR_WIPHY_BTCOEX_ENABLE,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 46cd489..5b77a41 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -414,6 +414,7 @@ enum nl80211_multicast_groups {
 	[NL80211_ATTR_NAN_MASTER_PREF] = { .type = NLA_U8 },
 	[NL80211_ATTR_NAN_DUAL] = { .type = NLA_U8 },
 	[NL80211_ATTR_NAN_FUNC] = { .type = NLA_NESTED },
+	[NL80211_ATTR_WIPHY_BTCOEX_ENABLE] = { .type = NLA_U8 },
 };
 
 /* policy for the key attributes */
@@ -2356,6 +2357,23 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 			return result;
 	}
 
+	if (info->attrs[NL80211_ATTR_WIPHY_BTCOEX_ENABLE]) {
+		u8 val;
+
+		if (!rdev->ops->set_btcoex)
+			return -ENOTSUPP;
+
+		val = nla_get_u8(info->attrs[NL80211_ATTR_WIPHY_BTCOEX_ENABLE]);
+
+		if (val > 1)
+			return -EINVAL;
+
+		result = rdev_set_btcoex(rdev, val);
+
+		if (result)
+			return result;
+	}
+
 	if (info->attrs[NL80211_ATTR_WIPHY_ANTENNA_TX] &&
 	    info->attrs[NL80211_ATTR_WIPHY_ANTENNA_RX]) {
 		u32 tx_ant, rx_ant;
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 11cf83c..2e547c3 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -1129,4 +1129,15 @@ static inline int rdev_set_qos_map(struct cfg80211_registered_device *rdev,
 	trace_rdev_return_int(&rdev->wiphy, ret);
 	return ret;
 }
+
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
 #endif /* __CFG80211_RDEV_OPS */
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index a3d0a91b..c9c6579 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -3026,6 +3026,11 @@
 		  WIPHY_PR_ARG, __entry->n_rules)
 );
 
+DEFINE_EVENT(wiphy_enabled_evt, rdev_set_btcoex,
+	TP_PROTO(struct wiphy *wiphy, bool enabled),
+	TP_ARGS(wiphy, enabled)
+);
+
 DEFINE_EVENT(wiphy_wdev_evt, rdev_abort_scan,
 	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev),
 	TP_ARGS(wiphy, wdev)
-- 
1.7.9.5
