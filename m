Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3157 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750938AbcKHNPQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Nov 2016 08:15:16 -0500
From: <c_traja@qti.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: <ath10k@lists.infradead.org>, <johannes@sipsolutions.net>,
        <tamizhchelvam@codeaurora.org>,
        Tamizh chelvam <c_traja@qti.qualcomm.com>
Subject: [PATCH 2/4] cfg80211: Add new NL80211_CMD_SET_BTCOEX_PRIORITY to support BTCOEX
Date: Tue, 8 Nov 2016 18:45:30 +0530
Message-ID: <1478610932-21954-3-git-send-email-c_traja@qti.qualcomm.com> (sfid-20161108_141519_391340_9D59063C)
In-Reply-To: <1478610932-21954-1-git-send-email-c_traja@qti.qualcomm.com>
References: <1478610932-21954-1-git-send-email-c_traja@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tamizh chelvam <c_traja@qti.qualcomm.com>

This change enables user to set high priority for driver supported wlan
frames when BTCOEX enabled. The drivers that expose such capability make
use of this priority table to decide to whom the radio should be shared
(either bluetooth or WLAN). When the high priority frames are queued
driver or firmware will signal to block BT activity.
Capable drivers should advertise the frame type for which it supports
BTCOEX priority configuration through btcoex_support_flags.
This will be useful when wlan needs to transfer packet to avoid
connection lost or packet drop issue when BT is active on long time.

Signed-off-by: Tamizh chelvam <c_traja@qti.qualcomm.com>
---
 include/net/cfg80211.h       |   65 +++++++++++++++++++++++++++
 include/uapi/linux/nl80211.h |   37 ++++++++++++++++
 net/wireless/nl80211.c       |  101 ++++++++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      |   13 ++++++
 net/wireless/trace.h         |   43 ++++++++++++++++++
 5 files changed, 259 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 919ed1d..d52d76b 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2434,6 +2434,27 @@ struct cfg80211_nan_func {
 };
 
 /**
+ * struct cfg80211_btcoex_priority - BTCOEX support frame type
+ *
+ * This structure defines the driver supporting frame types for BTCOEX
+ *
+ * @wlan_be_preferred: best effort frames preferred over bt traffic
+ * @wlan_bk_preferred: background frames preferred over bt traffic
+ * @wlan_vi_preferred: video frames preferred over bt traffic
+ * @wlan_vo_preferred: voice frames preferred over bt traffic
+ * @wlan_beacon_preferred: beacon preferred over bt traffic
+ * @wlan_mgmt_preferred: management frames preferred ovet bt traffic
+ */
+struct cfg80211_btcoex_priority {
+	bool wlan_be_preferred;
+	bool wlan_bk_preferred;
+	bool wlan_vi_preferred;
+	bool wlan_vo_preferred;
+	bool wlan_beacon_preferred;
+	bool wlan_mgmt_preferred;
+};
+
+/**
  * struct cfg80211_ops - backend description for wireless configuration
  *
  * This struct is registered by fullmac card drivers and/or wireless stacks
@@ -2737,6 +2758,11 @@ struct cfg80211_nan_func {
  *	All other parameters must be ignored.
  * @set_btcoex: Use this callback to call driver API when user wants to
  *     enable/disable btcoex.
+ * @set_btcoex_priority: Use this callback to set wlan high
+ *     priority frames over bluetooth. Driver supported wlan frames
+ *     for the BTCOEX is exposed by btcoex_support_flags.
+ *     When BTCOEX enabled, the high priority wlan frames will have
+ *     more priority than BT.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -3014,6 +3040,8 @@ struct cfg80211_ops {
 				   struct cfg80211_nan_conf *conf,
 				   u32 changes);
 	int     (*set_btcoex)(struct wiphy *wiphy, bool enabled);
+	int     (*set_btcoex_priority)(struct wiphy *wiphy,
+			struct cfg80211_btcoex_priority *btcoex_priority);
 };
 
 /*
@@ -3253,6 +3281,38 @@ struct wiphy_wowlan_support {
 };
 
 /**
+ * wiphy_btcoex_support_flags
+ *	This enum has the driver supported frame types for BTCOEX.
+ * @WIPHY_WLAN_BE_PREFERRED - Supports Best Effort frame for BTCOEX
+ * @WIPHY_WLAN_BK_PREFERRED - supports Background frame for BTCOEX
+ * @WIPHY_WLAN_VI_PREFERRED - supports Video frame for BTCOEX
+ * @WIPHY_WLAN_VO_PREFERRED - supports Voice frame for BTCOEX
+ * @WIPHY_WLAN_BEACON_PREFERRED - supports Beacon frame for BTCOEX
+ * @WIPHY_WLAN_MGMT_PREFERRED - supports Management frames for BTCOEX.
+ */
+
+enum wiphy_btcoex_support_flags {
+	WIPHY_WLAN_BE_PREFERRED		= BIT(0),
+	WIPHY_WLAN_BK_PREFERRED		= BIT(1),
+	WIPHY_WLAN_VI_PREFERRED		= BIT(2),
+	WIPHY_WLAN_VO_PREFERRED		= BIT(3),
+	WIPHY_WLAN_BEACON_PREFERRED	= BIT(4),
+	WIPHY_WLAN_MGMT_PREFERRED	= BIT(5),
+};
+
+/**
+ * enum wiphy_btcoex_priority - BTCOEX priority level
+ *	This enum defines priority level for BTCOEX
+ * WIPHY_WLAN_PREFERRED_LOW - low priority frames over BT traffic
+ * WIPHY_WLAN_PREFERRED_HIGH - high priority frames over BT traffic
+ */
+
+enum wiphy_btcoex_priority {
+	WIPHY_WLAN_PREFERRED_LOW = false,
+	WIPHY_WLAN_PREFERRED_HIGH = true,
+};
+
+/**
  * struct wiphy_coalesce_support - coalesce support data
  * @n_rules: maximum number of coalesce rules
  * @max_delay: maximum supported coalescing delay in msecs
@@ -3430,6 +3490,10 @@ struct wiphy_iftype_ext_capab {
  *	used since access to it is necessarily racy, use the parameter passed
  *	to the suspend() operation instead.
  *
+ * @btcoex_support_flags: This will have the driver supported
+ *	frame types for BTCOEX. This value filled by using
+ *	%enum wiphy_btcoex_support_flags while driver
+ *	initialization.
  * @ap_sme_capa: AP SME capabilities, flags from &enum nl80211_ap_sme_features.
  * @ht_capa_mod_mask:  Specify what ht_cap values can be over-ridden.
  *	If null, then none can be over-ridden.
@@ -3538,6 +3602,7 @@ struct wiphy {
 	struct cfg80211_wowlan *wowlan_config;
 #endif
 
+	u32 btcoex_support_flags;
 	u16 max_remain_on_channel_duration;
 
 	u8 max_num_pmkids;
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index c47fe6c8..8d15321 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -874,6 +874,10 @@
  *	This will contain a %NL80211_ATTR_NAN_MATCH nested attribute and
  *	%NL80211_ATTR_COOKIE.
  *
+ * @NL80211_CMD_SET_BTCOEX_PRIORITY: Set high priority for driver supported
+ *	wlan frames for BTCOEX over bluetooth. High priority frame type
+ *	identified by %NL80211_ATTR_SET_BTCOEX_PRIORITY parameters.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -1069,6 +1073,8 @@ enum nl80211_commands {
 	NL80211_CMD_CHANGE_NAN_CONFIG,
 	NL80211_CMD_NAN_MATCH,
 
+	NL80211_CMD_SET_BTCOEX_PRIORITY,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -1941,6 +1947,11 @@ enum nl80211_commands {
  *	the btcoex feature. When used with %NL80211_CMD_SET_WIPHY it contains
  *	either 0 for disable or 1 for enable btcoex.
  *
+ * @NL80211_ATTR_SET_BTCOEX_PRIORITY: nested attribute for driver supporting
+ *	the BTCOEX. When used with %NL80211_CMD_SET_BTCOEX_PRIORITY it contains
+ *	attributes according &enum nl80211_btcoex_priority to indicate
+ *	which frame has high priority over BT.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2341,6 +2352,7 @@ enum nl80211_attrs {
 	NL80211_ATTR_NAN_MATCH,
 
 	NL80211_ATTR_WIPHY_BTCOEX_ENABLE,
+	NL80211_ATTR_SET_BTCOEX_PRIORITY,
 
 	/* add attributes here, update the policy in nl80211.c */
 
@@ -3551,6 +3563,31 @@ enum nl80211_chan_width {
 };
 
 /**
+ * enum nl80211_btcoex_priority - BTCOEX parameter attributes
+ *	This strcuture has enum values for driver supported wlan
+ *	frame type for BTCOEX.
+ * @NL80211_WLAN_BE_PREFERRED - Best Effort frame
+ * @NL80211_WLAN_BK_PREFERRED - Background frame
+ * @NL80211_WLAN_VI_PREFERRED - Video frame
+ * @NL80211_WLAN_VO_PREFERRED - Voice frame
+ * @NL80211_WLAN_BEACON_PREFERRED - BEACON frame
+ * @NL80211_WLAN_MGMT_PREFERRED - MGMT frame
+ */
+
+enum nl80211_btcoex_priority {
+	__NL80211_WLAN_PREFERRED_INVALID,
+	NL80211_WLAN_BE_PREFERRED,
+	NL80211_WLAN_BK_PREFERRED,
+	NL80211_WLAN_VI_PREFERRED,
+	NL80211_WLAN_VO_PREFERRED,
+	NL80211_WLAN_BEACON_PREFERRED,
+	NL80211_WLAN_MGMT_PREFERRED,
+	__NL80211_WLAN_PREFERRED_LAST,
+	NL80211_WLAN_PREFERRED_MAX =
+			__NL80211_WLAN_PREFERRED_LAST - 1,
+};
+
+/**
  * enum nl80211_bss_scan_width - control channel width for a BSS
  *
  * These values are used with the %NL80211_BSS_CHAN_WIDTH attribute.
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 5b77a41..2d89919 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -415,6 +415,7 @@ enum nl80211_multicast_groups {
 	[NL80211_ATTR_NAN_DUAL] = { .type = NLA_U8 },
 	[NL80211_ATTR_NAN_FUNC] = { .type = NLA_NESTED },
 	[NL80211_ATTR_WIPHY_BTCOEX_ENABLE] = { .type = NLA_U8 },
+	[NL80211_ATTR_SET_BTCOEX_PRIORITY] = { .type = NLA_NESTED },
 };
 
 /* policy for the key attributes */
@@ -2017,6 +2018,16 @@ static int nl80211_get_wiphy(struct sk_buff *skb, struct genl_info *info)
 	return genlmsg_reply(msg, info);
 }
 
+static const struct nla_policy
+wlan_preferred_policy[NL80211_WLAN_PREFERRED_MAX + 1] = {
+	[NL80211_WLAN_BE_PREFERRED]	= { .type = NLA_FLAG },
+	[NL80211_WLAN_BK_PREFERRED]	= { .type = NLA_FLAG },
+	[NL80211_WLAN_VI_PREFERRED]	= { .type = NLA_FLAG },
+	[NL80211_WLAN_VO_PREFERRED]	= { .type = NLA_FLAG },
+	[NL80211_WLAN_BEACON_PREFERRED]	= { .type = NLA_FLAG },
+	[NL80211_WLAN_MGMT_PREFERRED]	= { .type = NLA_FLAG },
+};
+
 static const struct nla_policy txq_params_policy[NL80211_TXQ_ATTR_MAX + 1] = {
 	[NL80211_TXQ_ATTR_QUEUE]		= { .type = NLA_U8 },
 	[NL80211_TXQ_ATTR_TXOP]			= { .type = NLA_U16 },
@@ -11749,6 +11760,88 @@ static int nl80211_tdls_cancel_channel_switch(struct sk_buff *skb,
 	return 0;
 }
 
+static int
+parse_btcoex_priority(struct nlattr *tb[], struct wiphy *wiphy,
+		      struct cfg80211_btcoex_priority *btcoex_priority)
+{
+	memset(btcoex_priority, false, sizeof(*btcoex_priority));
+
+	if (tb[NL80211_WLAN_BE_PREFERRED]) {
+		if (!(wiphy->btcoex_support_flags &
+		      WIPHY_WLAN_BE_PREFERRED))
+			return -EINVAL;
+		btcoex_priority->wlan_be_preferred =
+				WIPHY_WLAN_PREFERRED_HIGH;
+	}
+	if (tb[NL80211_WLAN_BK_PREFERRED]) {
+		if (!(wiphy->btcoex_support_flags &
+		      WIPHY_WLAN_BK_PREFERRED))
+			return -EINVAL;
+		btcoex_priority->wlan_bk_preferred =
+				WIPHY_WLAN_PREFERRED_HIGH;
+	}
+	if (tb[NL80211_WLAN_VI_PREFERRED]) {
+		if (!(wiphy->btcoex_support_flags &
+		      WIPHY_WLAN_VI_PREFERRED))
+			return -EINVAL;
+		btcoex_priority->wlan_vi_preferred =
+				WIPHY_WLAN_PREFERRED_HIGH;
+	}
+	if (tb[NL80211_WLAN_VO_PREFERRED]) {
+		if (!(wiphy->btcoex_support_flags &
+		      WIPHY_WLAN_VO_PREFERRED))
+			return -EINVAL;
+		btcoex_priority->wlan_vo_preferred =
+				WIPHY_WLAN_PREFERRED_HIGH;
+	}
+	if (tb[NL80211_WLAN_BEACON_PREFERRED]) {
+		if (!(wiphy->btcoex_support_flags &
+		      WIPHY_WLAN_BEACON_PREFERRED))
+			return -EINVAL;
+		btcoex_priority->wlan_beacon_preferred =
+				WIPHY_WLAN_PREFERRED_HIGH;
+	}
+	if (tb[NL80211_WLAN_MGMT_PREFERRED]) {
+		if (!(wiphy->btcoex_support_flags &
+		      WIPHY_WLAN_MGMT_PREFERRED))
+			return -EINVAL;
+		btcoex_priority->wlan_mgmt_preferred =
+				WIPHY_WLAN_PREFERRED_HIGH;
+	}
+	return 0;
+}
+
+static int nl80211_btcoex_priority(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct cfg80211_btcoex_priority btcoex_priority = {};
+	struct wiphy wiphy = rdev->wiphy;
+	struct nlattr *tb[NL80211_WLAN_PREFERRED_MAX + 1];
+	int err;
+
+	if (!rdev->ops->set_btcoex_priority)
+		return -EOPNOTSUPP;
+
+	if (!(info->attrs[NL80211_ATTR_SET_BTCOEX_PRIORITY]))
+		return -EINVAL;
+
+	err = nla_parse(tb, NL80211_WLAN_PREFERRED_MAX,
+			nla_data(info->attrs[NL80211_ATTR_SET_BTCOEX_PRIORITY]),
+			nla_len(info->attrs[NL80211_ATTR_SET_BTCOEX_PRIORITY]),
+			wlan_preferred_policy);
+
+	if (err)
+		return err;
+
+	err = parse_btcoex_priority(tb, &wiphy, &btcoex_priority);
+
+	if (err)
+		return -EINVAL;
+
+	return rdev_set_btcoex_priority(rdev, dev, &btcoex_priority);
+}
+
 #define NL80211_FLAG_NEED_WIPHY		0x01
 #define NL80211_FLAG_NEED_NETDEV	0x02
 #define NL80211_FLAG_NEED_RTNL		0x04
@@ -12608,6 +12701,14 @@ static void nl80211_post_doit(const struct genl_ops *ops, struct sk_buff *skb,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL80211_CMD_SET_BTCOEX_PRIORITY,
+		.doit = nl80211_btcoex_priority,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_WIPHY |
+				  NL80211_FLAG_NEED_RTNL,
+	},
 };
 
 /* notification functions */
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 2e547c3..f41168e 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -1140,4 +1140,17 @@ static inline int rdev_set_qos_map(struct cfg80211_registered_device *rdev,
 	trace_rdev_return_int(&rdev->wiphy, ret);
 	return ret;
 }
+
+static inline int
+rdev_set_btcoex_priority(struct cfg80211_registered_device *rdev,
+			 struct net_device *dev,
+			 struct cfg80211_btcoex_priority *btcoex_priority)
+{
+	int ret;
+
+	trace_rdev_set_btcoex_priority(&rdev->wiphy, btcoex_priority);
+	ret = rdev->ops->set_btcoex_priority(&rdev->wiphy, btcoex_priority);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
 #endif /* __CFG80211_RDEV_OPS */
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index c9c6579..5bde0cf 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -3031,6 +3031,49 @@
 	TP_ARGS(wiphy, enabled)
 );
 
+TRACE_EVENT(rdev_set_btcoex_priority,
+	TP_PROTO(struct wiphy *wiphy,
+		 struct cfg80211_btcoex_priority *btcoex_priority),
+	TP_ARGS(wiphy, btcoex_priority),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		__field(bool, wlan_be_preferred)
+		__field(bool, wlan_bk_preferred)
+		__field(bool, wlan_vi_preferred)
+		__field(bool, wlan_vo_preferred)
+		__field(bool, wlan_beacon_preferred)
+		__field(bool, wlan_mgmt_preferred)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		if (btcoex_priority) {
+			__entry->wlan_be_preferred =
+				btcoex_priority->wlan_be_preferred;
+			__entry->wlan_bk_preferred =
+				btcoex_priority->wlan_bk_preferred;
+			__entry->wlan_vi_preferred =
+				btcoex_priority->wlan_vi_preferred;
+			__entry->wlan_vo_preferred =
+				btcoex_priority->wlan_vo_preferred;
+			__entry->wlan_beacon_preferred =
+				btcoex_priority->wlan_beacon_preferred;
+			__entry->wlan_mgmt_preferred =
+				btcoex_priority->wlan_mgmt_preferred;
+		}
+	),
+	TP_printk(WIPHY_PR_FMT ", wlan_be_preferred: %d, "
+		  "wlan_bk_preferred: %d, "
+		  "wlan_vi_preferred: %d,"
+		  "wlan_vo_preferred: %d, "
+		  "wlan_beacon_preferred: %d "
+		  "wlan_mgmt_preferred: %d.",
+		  WIPHY_PR_ARG, __entry->wlan_be_preferred,
+		  __entry->wlan_bk_preferred,
+		  __entry->wlan_vi_preferred,
+		  __entry->wlan_vo_preferred,
+		  __entry->wlan_beacon_preferred,
+		  __entry->wlan_mgmt_preferred)
+);
 DEFINE_EVENT(wiphy_wdev_evt, rdev_abort_scan,
 	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev),
 	TP_ARGS(wiphy, wdev)
-- 
1.7.9.5
