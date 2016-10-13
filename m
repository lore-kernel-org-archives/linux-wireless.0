Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:37392 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754053AbcJMPlC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Oct 2016 11:41:02 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        vamsi krishna <vamsin@qti.qualcomm.com>,
        Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH] cfg80211: Add support to update connection parameters
Date: Thu, 13 Oct 2016 18:39:38 +0300
Message-ID: <1476373178-31105-1-git-send-email-jouni@qca.qualcomm.com> (sfid-20161013_174127_080386_3407A6DE)
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
 include/net/cfg80211.h       | 22 ++++++++++++++++++++++
 include/uapi/linux/nl80211.h |  7 +++++++
 net/wireless/core.h          |  4 ++++
 net/wireless/nl80211.c       | 33 +++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      | 13 +++++++++++++
 net/wireless/sme.c           | 10 ++++++++++
 net/wireless/trace.h         | 19 +++++++++++++++++++
 7 files changed, 108 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 5000ec7..a4fc28a 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2044,6 +2044,18 @@ struct cfg80211_connect_params {
 };
 
 /**
+ * struct cfg80211_connect_params_valid - Connection parameters to be updated
+ *
+ * This structure provides information of all connect parameters that
+ * have to be updated as part of update_connect_params() call.
+ *
+ * @assoc_ies_valid: Indicates whether association request IEs are updated
+ */
+struct cfg80211_connect_params_valid {
+	bool assoc_ies_valid;
+};
+
+/**
  * enum wiphy_params_flags - set_wiphy_params bitfield values
  * @WIPHY_PARAM_RETRY_SHORT: wiphy->retry_short has changed
  * @WIPHY_PARAM_RETRY_LONG: wiphy->retry_long has changed
@@ -2564,6 +2576,12 @@ struct cfg80211_nan_func {
  *	cases, the result of roaming is indicated with a call to
  *	cfg80211_roamed() or cfg80211_roamed_bss().
  *	(invoked with the wireless_dev mutex held)
+ * @update_connect_params: Update the connect parameters while connected to a
+ *	BSS. The updated parameters can be used by driver/firmware for
+ *	subsequent BSS selection (roaming) decisions and to form the
+ *	Authentication/(Re)Association Request frames. This call does not
+ *	request an immediate disassociation or reassociation with the current
+ *	BSS, i.e., this impacts only subsequence (re)associations.
  * @disconnect: Disconnect from the BSS/ESS. Once done, call
  *	cfg80211_disconnected().
  *	(invoked with the wireless_dev mutex held)
@@ -2848,6 +2866,10 @@ struct cfg80211_ops {
 
 	int	(*connect)(struct wiphy *wiphy, struct net_device *dev,
 			   struct cfg80211_connect_params *sme);
+	int	(*update_connect_params)(struct wiphy *wiphy,
+					 struct net_device *dev,
+					 struct cfg80211_connect_params *sme,
+					 struct cfg80211_connect_params_valid *cpv);
 	int	(*disconnect)(struct wiphy *wiphy, struct net_device *dev,
 			      u16 reason_code);
 
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 1362d24..ee85ce1 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -874,6 +874,11 @@
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
@@ -1069,6 +1074,8 @@ enum nl80211_commands {
 	NL80211_CMD_CHANGE_NAN_CONFIG,
 	NL80211_CMD_NAN_MATCH,
 
+	NL80211_CMD_UPDATE_CONNECT_PARAMS,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 21e3188..7b8c8d1 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -383,6 +383,10 @@ int cfg80211_connect(struct cfg80211_registered_device *rdev,
 		     struct cfg80211_connect_params *connect,
 		     struct cfg80211_cached_keys *connkeys,
 		     const u8 *prev_bssid);
+int cfg80211_update_connect_params(struct cfg80211_registered_device *rdev,
+				   struct net_device *dev,
+				   struct cfg80211_connect_params *connect,
+				   struct cfg80211_connect_params_valid *cpv);
 void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 			       const u8 *req_ie, size_t req_ie_len,
 			       const u8 *resp_ie, size_t resp_ie_len,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 903cd5a..a3c5f5a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -8732,6 +8732,31 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
 	return err;
 }
 
+static int nl80211_update_connect_params(struct sk_buff *skb,
+					 struct genl_info *info)
+{
+	struct cfg80211_connect_params connect;
+	struct cfg80211_connect_params_valid cpv;
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+
+	memset(&connect, 0, sizeof(connect));
+	memset(&cpv, 0, sizeof(cpv));
+
+	if (!wdev->current_bss)
+		return -ENOLINK;
+
+	if (info->attrs[NL80211_ATTR_IE]) {
+		if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_IE]))
+			return -EINVAL;
+		connect.ie = nla_data(info->attrs[NL80211_ATTR_IE]);
+		connect.ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
+		cpv.assoc_ies_valid = true;
+	}
+	return cfg80211_update_connect_params(rdev, dev, &connect, &cpv);
+}
+
 static int nl80211_disconnect(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
@@ -12187,6 +12212,14 @@ static void nl80211_post_doit(const struct genl_ops *ops, struct sk_buff *skb,
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
index 11cf83c..9ad3b2c 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -490,6 +490,19 @@ static inline int rdev_connect(struct cfg80211_registered_device *rdev,
 	return ret;
 }
 
+static inline int
+rdev_update_connect_params(struct cfg80211_registered_device *rdev,
+			   struct net_device *dev,
+			   struct cfg80211_connect_params *sme,
+			   struct cfg80211_connect_params_valid *cpv)
+{
+	int ret;
+	trace_rdev_update_connect_params(&rdev->wiphy, dev, sme, cpv);
+	ret = rdev->ops->update_connect_params(&rdev->wiphy, dev, sme, cpv);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
+
 static inline int rdev_disconnect(struct cfg80211_registered_device *rdev,
 				  struct net_device *dev, u16 reason_code)
 {
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index a77db33..93106da 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -1073,6 +1073,16 @@ int cfg80211_connect(struct cfg80211_registered_device *rdev,
 	return 0;
 }
 
+int cfg80211_update_connect_params(struct cfg80211_registered_device *rdev,
+				   struct net_device *dev,
+				   struct cfg80211_connect_params *connect,
+				   struct cfg80211_connect_params_valid *cpv)
+{
+	if (rdev->ops->update_connect_params)
+		return rdev_update_connect_params(rdev, dev, connect, cpv);
+	return 0;
+}
+
 int cfg80211_disconnect(struct cfg80211_registered_device *rdev,
 			struct net_device *dev, u16 reason, bool wextev)
 {
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index a3d0a91b..b53d72b 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1281,6 +1281,25 @@
 		  __entry->wpa_versions, __entry->flags, MAC_PR_ARG(prev_bssid))
 );
 
+TRACE_EVENT(rdev_update_connect_params,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 struct cfg80211_connect_params *sme,
+		 struct cfg80211_connect_params_valid *cpv),
+	TP_ARGS(wiphy, netdev, sme, cpv),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		__field(bool, assoc_ies_valid)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		__entry->assoc_ies_valid = cpv->assoc_ies_valid;
+	),
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", assoc_ies_valid: %d",
+		  WIPHY_PR_ARG, NETDEV_PR_ARG,  __entry->assoc_ies_valid)
+);
+
 TRACE_EVENT(rdev_set_cqm_rssi_config,
 	TP_PROTO(struct wiphy *wiphy,
 		 struct net_device *netdev, s32 rssi_thold,
-- 
1.9.1
