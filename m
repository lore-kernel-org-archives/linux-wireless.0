Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:56017 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777AbbC3OOf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 10:14:35 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [RFC 4/5] cfg80211: allow the user space to change the NAN master preference
Date: Mon, 30 Mar 2015 17:14:19 +0300
Message-Id: <1427724860-1992-5-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150330_161439_228972_C4ADA283)
In-Reply-To: <1427724860-1992-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1427724860-1992-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This can be useful if the device get plugged / unplugged
to the power. Update the driver when the master preference
is updated and make it optional.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/cfg80211.h       |  4 ++++
 include/uapi/linux/nl80211.h |  4 ++++
 net/wireless/nl80211.c       | 28 ++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      | 16 ++++++++++++++++
 net/wireless/trace.h         | 18 ++++++++++++++++++
 5 files changed, 70 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 64f45a9..56ed869 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2434,6 +2434,7 @@ struct cfg80211_nan_func {
  *	upon success. The data in cfg80211_nan_func must not be referenced
  *	outside the scope of this call.
  * @rm_nan_func: Remove a nan function
+ * @nan_change_master_pref: changes the NAN master preference.
  *
  * @set_mac_acl: Sets MAC address control list in AP and P2P GO mode.
  *	Parameters include ACL policy, an array of MAC address of stations
@@ -2759,6 +2760,9 @@ struct cfg80211_ops {
 				const struct cfg80211_nan_func *nan_func);
 	void	(*rm_nan_func)(struct wiphy *wiphy, struct wireless_dev *wdev,
 				   u8 instance_id);
+	int	(*nan_change_master_pref)(struct wiphy *wiphy,
+					  struct wireless_dev *wdev,
+					  u8 master_pref);
 };
 
 /*
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index b3bf9aa..471879d 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -812,6 +812,9 @@
  *	the function upon success.
  * @NL80211_CMD_RM_NAN_FUNCTION: remove a NAN function based on its instance
  *	id.
+ * @NL80211_CMD_CHANGE_NAN_MASTER_PREF: Changes the master preference while NAN
+ *	is operational. It must contain a valid %NL80211_ATTR_NAN_MASTER_PREF
+ *	attribute.
  *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
@@ -1003,6 +1006,7 @@ enum nl80211_commands {
 	NL80211_CMD_STOP_NAN,
 	NL80211_CMD_ADD_NAN_FUNCTION,
 	NL80211_CMD_RM_NAN_FUNCTION,
+	NL80211_CMD_CHANGE_NAN_MASTER_PREF,
 
 	/* add new commands above here */
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 0cfe17d..f1cd4e3 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -10125,6 +10125,26 @@ static int nl80211_nan_rm_func(struct sk_buff *skb,
 	return 0;
 }
 
+static int nl80211_nan_change_master_pref(struct sk_buff *skb,
+					  struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct wireless_dev *wdev = info->user_ptr[1];
+	u8 master_pref;
+
+	if (wdev->iftype != NL80211_IFTYPE_NAN)
+		return -EOPNOTSUPP;
+
+	if (!info->attrs[NL80211_ATTR_NAN_MASTER_PREF])
+		return -EINVAL;
+
+	master_pref = nla_get_u8(info->attrs[NL80211_ATTR_NAN_MASTER_PREF]);
+	if (master_pref <= 1 || master_pref == 255)
+		return -EINVAL;
+
+	return rdev_nan_change_master_pref(rdev, wdev, master_pref);
+}
+
 static int nl80211_get_protocol_features(struct sk_buff *skb,
 					 struct genl_info *info)
 {
@@ -11305,6 +11325,14 @@ static __genl_const struct genl_ops nl80211_ops[] = {
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
+		.cmd = NL80211_CMD_CHANGE_NAN_MASTER_PREF,
+		.doit = nl80211_nan_change_master_pref,
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
index 9a42c92..2cad83c 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -917,6 +917,22 @@ static inline void rdev_rm_nan_func(struct cfg80211_registered_device *rdev,
 	trace_rdev_return_void(&rdev->wiphy);
 }
 
+static inline int
+rdev_nan_change_master_pref(struct cfg80211_registered_device *rdev,
+			    struct wireless_dev *wdev, u8 master_pref)
+{
+	int ret;
+
+	trace_rdev_nan_change_master_pref(&rdev->wiphy, wdev, master_pref);
+	if (rdev->ops->nan_change_master_pref)
+		ret = rdev->ops->nan_change_master_pref(&rdev->wiphy, wdev,
+							master_pref);
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
index a0de576..f264ac3 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1872,6 +1872,24 @@ TRACE_EVENT(rdev_start_nan,
 		  WIPHY_PR_ARG, WDEV_PR_ARG, __entry->master_pref)
 );
 
+TRACE_EVENT(rdev_nan_change_master_pref,
+	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev,
+		 u8 master_pref),
+	TP_ARGS(wiphy, wdev, master_pref),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		WDEV_ENTRY
+		__field(u8, master_pref)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		WDEV_ASSIGN;
+		__entry->master_pref = master_pref;
+	),
+	TP_printk(WIPHY_PR_FMT ", " WDEV_PR_FMT ", master preference: %u",
+		  WIPHY_PR_ARG, WDEV_PR_ARG, __entry->master_pref)
+);
+
 DEFINE_EVENT(wiphy_wdev_evt, rdev_stop_nan,
 	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev),
 	TP_ARGS(wiphy, wdev)
-- 
1.9.1

