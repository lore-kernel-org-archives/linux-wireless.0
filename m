Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:6821 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384AbbIQOde (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2015 10:33:34 -0400
From: andrei.otcheretianski@intel.com
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Subject: [RFC 4/7] cfg80211: allow the user space to change current NAN configuration
Date: Thu, 17 Sep 2015 17:32:28 +0300
Message-Id: <1442500351-8780-5-git-send-email-andrei.otcheretianski@intel.com> (sfid-20150917_163348_917929_48C724CF)
In-Reply-To: <1442500351-8780-1-git-send-email-andrei.otcheretianski@intel.com>
References: <1442500351-8780-1-git-send-email-andrei.otcheretianski@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Some NAN configuration paramaters may change during the operation of
the NaN device. For example, a user may want to update master preference
value when the device gets plugged/unplugged to the power.
Add API that allows to do so.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
---
 include/net/cfg80211.h       | 16 +++++++++++++++
 include/uapi/linux/nl80211.h |  5 +++++
 net/wireless/nl80211.c       | 49 ++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      | 17 +++++++++++++++
 net/wireless/trace.h         | 24 ++++++++++++++++++++++
 5 files changed, 111 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 12203db..65970e3 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2262,6 +2262,17 @@ struct cfg80211_nan_func {
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
@@ -2535,6 +2546,7 @@ struct cfg80211_nan_func {
  *	upon success. The data in cfg80211_nan_func must not be referenced
  *	outside the scope of this call.
  * @rm_nan_func: Remove a nan function.
+ * @nan_change_conf: changes NAN configuration.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -2806,6 +2818,10 @@ struct cfg80211_ops {
 				const struct cfg80211_nan_func *nan_func);
 	void	(*rm_nan_func)(struct wiphy *wiphy, struct wireless_dev *wdev,
 				   u8 instance_id);
+	int	(*nan_change_conf)(struct wiphy *wiphy,
+				   struct wireless_dev *wdev,
+				   struct cfg80211_nan_conf *conf,
+				   u32 changes);
 };
 
 /*
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 699aa89..dbc5631 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -826,6 +826,10 @@
  *	the function upon success.
  * @NL80211_CMD_RM_NAN_FUNCTION: remove a NAN function based on its instance
  *	id.
+ * @NL80211_CMD_CHANGE_NAN_CONFIG: Changes current NAN configuration. NAN
+ *	should be opeartional (%NL80211_CMD_START_NAN was executed).
+ *	It must contain at least one of the following attributes:
+ *	%NL80211_ATTR_NAN_MASTER_PREF, %NL80211_ATTR_NAN_DUAL.
  *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
@@ -1017,6 +1021,7 @@ enum nl80211_commands {
 	NL80211_CMD_STOP_NAN,
 	NL80211_CMD_ADD_NAN_FUNCTION,
 	NL80211_CMD_RM_NAN_FUNCTION,
+	NL80211_CMD_CHANGE_NAN_CONFIG,
 
 	/* add new commands above here */
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d7106d4..7e32844 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -10150,6 +10150,47 @@ static int nl80211_nan_rm_func(struct sk_buff *skb,
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
+	/* cluster ID can't be changed on the fly */
+	if (info->attrs[NL80211_ATTR_NAN_CLUSTER_ID])
+		return -EINVAL;
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
+		if (conf.dual > 2)
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
@@ -11514,6 +11555,14 @@ static const struct genl_ops nl80211_ops[] = {
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
index 782755d..688f9c4 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -921,6 +921,23 @@ static inline void rdev_rm_nan_func(struct cfg80211_registered_device *rdev,
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
index 6c185ef..4088218 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1873,6 +1873,30 @@ TRACE_EVENT(rdev_start_nan,
 		  __entry->cluster_id, __entry->dual)
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
1.8.3

