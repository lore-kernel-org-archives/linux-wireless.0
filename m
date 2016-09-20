Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:56516 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755005AbcITObi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Sep 2016 10:31:38 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, ayala.beker@intel.com,
        andrei.otcheretianski@intel.com, arend.vanspriel@broadcom.com,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 20 Sep 2016 17:31:16 +0300
Message-Id: <20160920143121.28247-5-luca@coelho.fi> (sfid-20160920_163153_432291_304BB070)
In-Reply-To: <20160920143121.28247-1-luca@coelho.fi>
References: <20160920143121.28247-1-luca@coelho.fi>
Subject: [PATCH v3 4/9] cfg80211: allow the user space to change current NAN configuration
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ayala Beker <ayala.beker@intel.com>

Some NAN configuration paramaters may change during the operation of
the NAN device. For example, a user may want to update master preference
value when the device gets plugged/unplugged to the power.
Add API that allows to do so.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/net/cfg80211.h       | 19 +++++++++++++++++++
 include/uapi/linux/nl80211.h | 11 +++++++++--
 net/wireless/nl80211.c       | 42 ++++++++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      | 17 +++++++++++++++++
 net/wireless/trace.h         | 24 ++++++++++++++++++++++++
 5 files changed, 111 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 093339c..22cc70e 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2306,6 +2306,18 @@ struct cfg80211_nan_conf {
 };
 
 /**
+ * enum cfg80211_nan_conf_changes - indicates changed fields in NAN
+ * configuration
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
  * struct cfg80211_nan_func_filter - a NAN function Rx / Tx filter
  *
  * @filter: the content of the filter
@@ -2670,6 +2682,9 @@ struct cfg80211_nan_func {
  *	On success the driver should assign an instance_id in the
  *	provided @nan_func.
  * @del_nan_func: Delete a NAN function.
+ * @nan_change_conf: changes NAN configuration. The changed parameters must
+ *	be specified in @changes (using &enum cfg80211_nan_conf_changes);
+ *	All other parameters must be ignored.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -2942,6 +2957,10 @@ struct cfg80211_ops {
 				struct cfg80211_nan_func *nan_func);
 	void	(*del_nan_func)(struct wiphy *wiphy, struct wireless_dev *wdev,
 			       u64 cookie);
+	int	(*nan_change_conf)(struct wiphy *wiphy,
+				   struct wireless_dev *wdev,
+				   struct cfg80211_nan_conf *conf,
+				   u32 changes);
 };
 
 /*
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 9f3172d..4664904 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -862,6 +862,10 @@
  *	the response to this command.
  *	Look at %NL80211_ATTR_SOCKET_OWNER as well.
  * @NL80211_CMD_DEL_NAN_FUNCTION: Delete a NAN function by cookie.
+ * @NL80211_CMD_CHANGE_NAN_CONFIG: Change current NAN configuration. NAN
+ *	must be operational (%NL80211_CMD_START_NAN was executed).
+ *	It must contain at least one of the following attributes:
+ *	%NL80211_ATTR_NAN_MASTER_PREF, %NL80211_ATTR_NAN_DUAL.
  *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
@@ -1055,6 +1059,7 @@ enum nl80211_commands {
 	NL80211_CMD_STOP_NAN,
 	NL80211_CMD_ADD_NAN_FUNCTION,
 	NL80211_CMD_DEL_NAN_FUNCTION,
+	NL80211_CMD_CHANGE_NAN_CONFIG,
 
 	/* add new commands above here */
 
@@ -1904,12 +1909,14 @@ enum nl80211_commands {
  *	used to pull the stored data for mesh peer in power save state.
  *
  * @NL80211_ATTR_NAN_MASTER_PREF: the master preference to be used by
- *	%NL80211_CMD_START_NAN. Its type is u8 and it can't be 0.
+ *	%NL80211_CMD_START_NAN and optionally with
+ *	%NL80211_CMD_CHANGE_NAN_CONFIG. Its type is u8 and it can't be 0.
  *	Also, values 1 and 255 are reserved for certification purposes and
  *	should not be used during a normal device operation.
  * @NL80211_ATTR_NAN_DUAL: NAN dual band operation config (see
  *	&enum nl80211_nan_dual_band_conf). This attribute is used with
- *	%NL80211_CMD_START_NAN.
+ *	%NL80211_CMD_START_NAN and optionally with
+ *	%NL80211_CMD_CHANGE_NAN_CONFIG.
  * @NL80211_ATTR_NAN_FUNC: a function that can be added to NAN. See
  *	&enum nl80211_nan_func_attributes for description of this nested
  *	attribute.
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 8ec803b..7058669 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -10829,6 +10829,40 @@ static int nl80211_nan_del_func(struct sk_buff *skb,
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
@@ -12203,6 +12237,14 @@ static const struct genl_ops nl80211_ops[] = {
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
index 98c4c3b..11cf83c 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -928,6 +928,23 @@ static inline void rdev_del_nan_func(struct cfg80211_registered_device *rdev,
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
index 5608984..a3d0a91b 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1911,6 +1911,30 @@ TRACE_EVENT(rdev_start_nan,
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
2.9.3
