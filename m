Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:24738 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754835AbcJ0Nv6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Oct 2016 09:51:58 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        vamsi krishna <vamsin@qti.qualcomm.com>,
        Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH v2] cfg80211: Add support to update connection parameters
Date: Thu, 27 Oct 2016 16:51:11 +0300
Message-ID: <1477576271-12696-1-git-send-email-jouni@qca.qualcomm.com> (sfid-20161027_155257_018792_C5D0DCDE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: vamsi krishna <vamsin@qti.qualcomm.com>

Add functionality to update the connection parameters when in connected
state, so that driver/firmware uses the updated parameters for
subsequent roaming. This is for drivers that support internal BSS
selection and roaming. The new command does not change the current
association state, i.e., it can be used to update IE contents for future
(re)associations without causing an immediate disassociation or
reassociation with the current BSS.

This commit implements the required functionality for updating IEs for
(Re)Association Request frame only. Other parameters can be added in
future when required.

Signed-off-by: vamsi krishna <vamsin@qti.qualcomm.com>
Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 include/net/cfg80211.h       | 24 ++++++++++++++++++++++++
 include/uapi/linux/nl80211.h |  7 +++++++
 net/wireless/nl80211.c       | 39 +++++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      | 12 ++++++++++++
 net/wireless/trace.h         | 18 ++++++++++++++++++
 5 files changed, 100 insertions(+)

v2:
- Address the comments from Arend and Johannes:
  * replace _valid struct with u32 changed
  * fix couple of typos in the comments
  * remove unnecessary wrapper function from sme.c
  * use C99 initializer to clear struct data
  * use wdev_lock/unlock() around the current_bss check and driver call
- fix EOPNOTSUPP logic in nl80211_update_connect_params()

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 41ae3f5..c575583 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2051,6 +2051,18 @@ struct cfg80211_connect_params {
 };
 
 /**
+ * enum cfg80211_connect_params_changed - Connection parameters being updated
+ *
+ * This enum provides information of all connect parameters that
+ * have to be updated as part of update_connect_params() call.
+ *
+ * @UPDATE_ASSOC_IES: Indicates whether association request IEs are updated
+ */
+enum cfg80211_connect_params_changed {
+	UPDATE_ASSOC_IES		= BIT(0),
+};
+
+/**
  * enum wiphy_params_flags - set_wiphy_params bitfield values
  * @WIPHY_PARAM_RETRY_SHORT: wiphy->retry_short has changed
  * @WIPHY_PARAM_RETRY_LONG: wiphy->retry_long has changed
@@ -2571,6 +2583,14 @@ struct cfg80211_nan_func {
  *	cases, the result of roaming is indicated with a call to
  *	cfg80211_roamed() or cfg80211_roamed_bss().
  *	(invoked with the wireless_dev mutex held)
+ * @update_connect_params: Update the connect parameters while connected to a
+ *	BSS. The updated parameters can be used by driver/firmware for
+ *	subsequent BSS selection (roaming) decisions and to form the
+ *	Authentication/(Re)Association Request frames. This call does not
+ *	request an immediate disassociation or reassociation with the current
+ *	BSS, i.e., this impacts only subsequent (re)associations. The bits in
+ *	changed are defined in &enum cfg80211_connect_params_changed.
+ *	(invoked with the wireless_dev mutex held)
  * @disconnect: Disconnect from the BSS/ESS or stop connection attempts if
  *      connection is in progress. Once done, call cfg80211_disconnected() in
  *      case connection was already established (invoked with the
@@ -2858,6 +2878,10 @@ struct cfg80211_ops {
 
 	int	(*connect)(struct wiphy *wiphy, struct net_device *dev,
 			   struct cfg80211_connect_params *sme);
+	int	(*update_connect_params)(struct wiphy *wiphy,
+					 struct net_device *dev,
+					 struct cfg80211_connect_params *sme,
+					 u32 changed);
 	int	(*disconnect)(struct wiphy *wiphy, struct net_device *dev,
 			      u16 reason_code);
 
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index e21d23d..67b464f 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -888,6 +888,11 @@
  *	This will contain a %NL80211_ATTR_NAN_MATCH nested attribute and
  *	%NL80211_ATTR_COOKIE.
  *
+ * @NL80211_CMD_UPDATE_CONNECT_PARAMS: Update one or more connect parameters
+ *	for subsequent roaming cases if the driver or firmware uses internal
+ *	BSS selection. This command can be issued only while connected and it
+ *	does not result in a change for the current association.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -1085,6 +1090,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_SET_MULTICAST_TO_UNICAST,
 
+	NL80211_CMD_UPDATE_CONNECT_PARAMS,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 46b2e8c..26821d4 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -8778,6 +8778,37 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
 	return err;
 }
 
+static int nl80211_update_connect_params(struct sk_buff *skb,
+					 struct genl_info *info)
+{
+	struct cfg80211_connect_params connect = {};
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	u32 changed = 0;
+	int ret;
+
+	if (!rdev->ops->update_connect_params)
+		return -EOPNOTSUPP;
+
+	if (info->attrs[NL80211_ATTR_IE]) {
+		if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_IE]))
+			return -EINVAL;
+		connect.ie = nla_data(info->attrs[NL80211_ATTR_IE]);
+		connect.ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
+		changed |= UPDATE_ASSOC_IES;
+	}
+
+	wdev_lock(dev->ieee80211_ptr);
+	if (!wdev->current_bss)
+		ret = -ENOLINK;
+	else
+		ret = rdev_update_connect_params(rdev, dev, &connect, changed);
+	wdev_unlock(dev->ieee80211_ptr);
+
+	return ret;
+}
+
 static int nl80211_disconnect(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
@@ -12231,6 +12262,14 @@ static void nl80211_post_doit(const struct genl_ops *ops, struct sk_buff *skb,
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
+		.cmd = NL80211_CMD_UPDATE_CONNECT_PARAMS,
+		.doit = nl80211_update_connect_params,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
+	{
 		.cmd = NL80211_CMD_DISCONNECT,
 		.doit = nl80211_disconnect,
 		.policy = nl80211_policy,
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index e9ecf23..2f42507 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -490,6 +490,18 @@ static inline int rdev_connect(struct cfg80211_registered_device *rdev,
 	return ret;
 }
 
+static inline int
+rdev_update_connect_params(struct cfg80211_registered_device *rdev,
+			   struct net_device *dev,
+			   struct cfg80211_connect_params *sme, u32 changed)
+{
+	int ret;
+	trace_rdev_update_connect_params(&rdev->wiphy, dev, sme, changed);
+	ret = rdev->ops->update_connect_params(&rdev->wiphy, dev, sme, changed);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
+
 static inline int rdev_disconnect(struct cfg80211_registered_device *rdev,
 				  struct net_device *dev, u16 reason_code)
 {
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 25f8318..ea1b47e 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1281,6 +1281,24 @@
 		  __entry->wpa_versions, __entry->flags, MAC_PR_ARG(prev_bssid))
 );
 
+TRACE_EVENT(rdev_update_connect_params,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 struct cfg80211_connect_params *sme, u32 changed),
+	TP_ARGS(wiphy, netdev, sme, changed),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		__field(u32, changed)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		__entry->changed = changed;
+	),
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", parameters changed: %u",
+		  WIPHY_PR_ARG, NETDEV_PR_ARG,  __entry->changed)
+);
+
 TRACE_EVENT(rdev_set_cqm_rssi_config,
 	TP_PROTO(struct wiphy *wiphy,
 		 struct net_device *netdev, s32 rssi_thold,
-- 
1.9.1
