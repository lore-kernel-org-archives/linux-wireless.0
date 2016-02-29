Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:41124 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750861AbcB2NZ3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 08:25:29 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, QH <qiumin.hu@gmail.com>,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	Etan Cohen <etancohen@google.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 04/12] cfg80211: allow the user space to change current NAN configuration
Date: Mon, 29 Feb 2016 15:25:05 +0200
Message-Id: <1456752313-5792-5-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160229_142532_564425_1A355623)
In-Reply-To: <1456752313-5792-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1456752313-5792-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some NAN configuration paramaters may change during the operation of
the NaN device. For example, a user may want to update master preference
value when the device gets plugged/unplugged to the power.
Add API that allows to do so.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/cfg80211.h       | 17 +++++++++++++++++
 include/uapi/linux/nl80211.h | 12 ++++++++++--
 net/wireless/nl80211.c       | 45 ++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      | 17 +++++++++++++++++
 net/wireless/trace.h         | 24 +++++++++++++++++++++++
 5 files changed, 113 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index e6bd90e..776827d 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2308,6 +2308,17 @@ struct cfg80211_nan_func {
 };
 
 /**
+ * enum cfg80211_nan_conf_changes - indicates changed fields in nan configuration
+ *
+ * @CFG80211_NAN_CONF_CHANGED_PREF: master preference
+ * @CFG80211_NAN_CONF_CHANGED_DUAL: dual band operation
+ */
+enum cfg80211_nan_conf_changes {
+	CFG80211_NAN_CONF_CHANGED_PREF = BIT(0),
+	CFG80211_NAN_CONF_CHANGED_DUAL = BIT(1),
+};
+
+/**
  * struct cfg80211_ops - backend description for wireless configuration
  *
  * This struct is registered by fullmac card drivers and/or wireless stacks
@@ -2587,6 +2598,8 @@ struct cfg80211_nan_func {
  *	scope of this call. The function assigns a unique instance_id in the
  *	provided @nan_func.
  * @rm_nan_func: Remove a nan function.
+ * @nan_change_conf: changes NAN configuration. The changed parameters must
+ *	be specified in @changes. All other parameters must be ignored.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -2859,6 +2872,10 @@ struct cfg80211_ops {
 				struct cfg80211_nan_func *nan_func);
 	void	(*rm_nan_func)(struct wiphy *wiphy, struct wireless_dev *wdev,
 			       u64 cookie);
+	int	(*nan_change_conf)(struct wiphy *wiphy,
+				   struct wireless_dev *wdev,
+				   struct cfg80211_nan_conf *conf,
+				   u32 changes);
 };
 
 /*
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index cf5464f..837185e 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -850,6 +850,10 @@
  *	This command is also used as a notification sent when a NAN function is
  *	terminated. This will contain a %NL80211_ATTR_NAN_FUNC_INST_ID
  *	and %NL80211_ATTR_COOKIE attributes.
+ * @NL80211_CMD_CHANGE_NAN_CONFIG: Change current NAN configuration. NAN
+ *	must be operational (%NL80211_CMD_START_NAN was executed).
+ *	It must contain at least one of the following attributes:
+ *	%NL80211_ATTR_NAN_MASTER_PREF, %NL80211_ATTR_NAN_DUAL.
  *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
@@ -1043,6 +1047,7 @@ enum nl80211_commands {
 	NL80211_CMD_STOP_NAN,
 	NL80211_CMD_ADD_NAN_FUNCTION,
 	NL80211_CMD_RM_NAN_FUNCTION,
+	NL80211_CMD_CHANGE_NAN_CONFIG,
 
 	/* add new commands above here */
 
@@ -1829,10 +1834,13 @@ enum nl80211_commands {
  *	a PCP instead of AP. Relevant for DMG networks only.
  *
  * @NL80211_ATTR_NAN_MASTER_PREF: the master preference to be used by
- *	&NL80211_CMD_START_NAN. Its type is u8 and it can't be 0, 1 or 255.
+ *	&NL80211_CMD_START_NAN and optionally with
+ *	&NL80211_CMD_CHANGE_NAN_CONFIG. Its type is u8 and it can't be 0, 1 or
+ *	255.
  * @NL80211_ATTR_NAN_DUAL: NAN dual band operation config (see
  *	&enum nl80211_nan_dual_band_conf). This attribute is used with
- *	&NL80211_CMD_START_NAN.
+ *	&NL80211_CMD_START_NAN and optionally with
+ *	&NL80211_CMD_CHANGE_NAN_CONFIG.
  * @NL80211_ATTR_NAN_FUNC: a function that can be added to NAN. See
  *	&enum nl80211_nan_func_attributes for description of this nested
  *	attribute.
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index dee728f..3c4d374 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -10375,6 +10375,43 @@ static int nl80211_nan_rm_func(struct sk_buff *skb,
 	return 0;
 }
 
+static int nl80211_nan_change_config(struct sk_buff *skb,
+				     struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct wireless_dev *wdev = info->user_ptr[1];
+	struct cfg80211_nan_conf conf = {};
+	u32 changed = 0;
+
+	if (wdev->iftype != NL80211_IFTYPE_NAN)
+		return -EOPNOTSUPP;
+
+	if (!wdev->nan_started)
+		return -ENOTCONN;
+
+	if (info->attrs[NL80211_ATTR_NAN_MASTER_PREF]) {
+		conf.master_pref =
+			nla_get_u8(info->attrs[NL80211_ATTR_NAN_MASTER_PREF]);
+		if (conf.master_pref <= 1 || conf.master_pref == 255)
+			return -EINVAL;
+
+		changed |= CFG80211_NAN_CONF_CHANGED_PREF;
+	}
+
+	if (info->attrs[NL80211_ATTR_NAN_DUAL]) {
+		conf.dual = nla_get_u8(info->attrs[NL80211_ATTR_NAN_DUAL]);
+		if (conf.dual > NL80211_NAN_BAND_MAX)
+			return -EINVAL;
+
+		changed |= CFG80211_NAN_CONF_CHANGED_DUAL;
+	}
+
+	if (!changed)
+		return -EINVAL;
+
+	return rdev_nan_change_conf(rdev, wdev, &conf, changed);
+}
+
 static int nl80211_get_protocol_features(struct sk_buff *skb,
 					 struct genl_info *info)
 {
@@ -11750,6 +11787,14 @@ static const struct genl_ops nl80211_ops[] = {
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
+		.cmd = NL80211_CMD_CHANGE_NAN_CONFIG,
+		.doit = nl80211_nan_change_config,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_WDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
+	{
 		.cmd = NL80211_CMD_SET_MCAST_RATE,
 		.doit = nl80211_set_mcast_rate,
 		.policy = nl80211_policy,
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index baa5242..9b6326e 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -928,6 +928,23 @@ static inline void rdev_rm_nan_func(struct cfg80211_registered_device *rdev,
 	trace_rdev_return_void(&rdev->wiphy);
 }
 
+static inline int
+rdev_nan_change_conf(struct cfg80211_registered_device *rdev,
+		     struct wireless_dev *wdev,
+		     struct cfg80211_nan_conf *conf, u32 changes)
+{
+	int ret;
+
+	trace_rdev_nan_change_conf(&rdev->wiphy, wdev, conf, changes);
+	if (rdev->ops->nan_change_conf)
+		ret = rdev->ops->nan_change_conf(&rdev->wiphy, wdev, conf,
+						 changes);
+	else
+		ret = -ENOTSUPP;
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
+
 static inline int rdev_set_mac_acl(struct cfg80211_registered_device *rdev,
 				   struct net_device *dev,
 				   struct cfg80211_acl_data *params)
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index b30087b..9442420 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1909,6 +1909,30 @@ TRACE_EVENT(rdev_start_nan,
 		  __entry->dual)
 );
 
+TRACE_EVENT(rdev_nan_change_conf,
+	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev,
+		 struct cfg80211_nan_conf *conf, u32 changes),
+	TP_ARGS(wiphy, wdev, conf, changes),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		WDEV_ENTRY
+		__field(u8, master_pref)
+		__field(u8, dual);
+		__field(u32, changes);
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		WDEV_ASSIGN;
+		__entry->master_pref = conf->master_pref;
+		__entry->dual = conf->dual;
+		__entry->changes = changes;
+	),
+	TP_printk(WIPHY_PR_FMT ", " WDEV_PR_FMT
+		  ", master preference: %u, dual: %d, changes: %x",
+		  WIPHY_PR_ARG, WDEV_PR_ARG, __entry->master_pref,
+		  __entry->dual, __entry->changes)
+);
+
 DEFINE_EVENT(wiphy_wdev_evt, rdev_stop_nan,
 	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev),
 	TP_ARGS(wiphy, wdev)
-- 
2.5.0

