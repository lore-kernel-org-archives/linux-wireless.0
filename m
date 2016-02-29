Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:41124 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633AbcB2NZb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 08:25:31 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, QH <qiumin.hu@gmail.com>,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	Etan Cohen <etancohen@google.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 05/12] cfg80211: provide a function to report a match for NAN
Date: Mon, 29 Feb 2016 15:25:06 +0200
Message-Id: <1456752313-5792-6-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160229_142534_465836_376B0F90)
In-Reply-To: <1456752313-5792-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1456752313-5792-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Provide a function the driver can call to report a match.
This will send the event to the user space.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/cfg80211.h       | 37 ++++++++++++++++++++++++++
 include/uapi/linux/nl80211.h | 38 +++++++++++++++++++++++++++
 net/wireless/nl80211.c       | 62 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 137 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 776827d..11d8aaf 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5457,6 +5457,43 @@ wiphy_ext_feature_isset(struct wiphy *wiphy,
 	return (ft_byte & BIT(ftidx % 8)) != 0;
 }
 
+/**
+ * struct cfg80211_nan_match_params - NAN match parameters
+ * @type: the type of the function that triggered a match. If it is
+ *	 %NL80211_NAN_FUNC_SUBSCRIBE it means that we replied to a subscriber.
+ *	 If it is %NL80211_NAN_FUNC_PUBLISH, it means that we got a discovery
+ *	 result.
+ *	 If it is %NL80211_NAN_FUNC_FOLLOW_UP, we received a follow up.
+ * @inst_id: the local instance id
+ * @peer_inst_id: the instance id of the peer's function
+ * @addr: the MAC address of the peer
+ * @info_len: the length of the &info
+ * @info: the Service Specific Info from the peer (if any)
+ * @cookie: user defined cookie of the corresponding function
+ */
+struct cfg80211_nan_match_params {
+	enum nl80211_nan_function_type type;
+	u8 inst_id;
+	u8 peer_inst_id;
+	const u8 *addr;
+	u8 info_len;
+	const u8 *info;
+	u64 cookie;
+};
+
+/**
+ * cfg80211_nan_match - report a match for a NAN function.
+ * @wdev: the wireless device reporting the match
+ * @match: match notification parameters
+ * @gfp: allocation flags
+ *
+ * This function reports that the a NAN function had a match. This
+ * can be a subscribe that had a match or a solicited publish that
+ * was sent. It can also be a follow up that was received.
+ */
+void cfg80211_nan_match(struct wireless_dev *wdev,
+			struct cfg80211_nan_match_params *match, gfp_t gfp);
+
 /* ethtool helper */
 void cfg80211_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info);
 
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 837185e..d25c85a 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -48,6 +48,7 @@
 #define NL80211_MULTICAST_GROUP_REG		"regulatory"
 #define NL80211_MULTICAST_GROUP_MLME		"mlme"
 #define NL80211_MULTICAST_GROUP_VENDOR		"vendor"
+#define NL80211_MULTICAST_GROUP_NAN		"nan"
 #define NL80211_MULTICAST_GROUP_TESTMODE	"testmode"
 
 /**
@@ -854,6 +855,9 @@
  *	must be operational (%NL80211_CMD_START_NAN was executed).
  *	It must contain at least one of the following attributes:
  *	%NL80211_ATTR_NAN_MASTER_PREF, %NL80211_ATTR_NAN_DUAL.
+ * @NL80211_CMD_NAN_FUNC_MATCH: Notification sent when a match is reported.
+ *	This will contain a %NL80211_ATTR_NAN_MATCH nested attribute and
+ *	%NL80211_ATTR_COOKIE.
  *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
@@ -1048,6 +1052,7 @@ enum nl80211_commands {
 	NL80211_CMD_ADD_NAN_FUNCTION,
 	NL80211_CMD_RM_NAN_FUNCTION,
 	NL80211_CMD_CHANGE_NAN_CONFIG,
+	NL80211_CMD_NAN_MATCH,
 
 	/* add new commands above here */
 
@@ -1846,6 +1851,8 @@ enum nl80211_commands {
  *	attribute.
  * @NL80211_ATTR_NAN_FUNC_INST_ID: the instance id of a %NL80211_ATTR_NAN_FUNC.
  *	Its type is u8 and it cannot be 0.
+ * @NL80211_ATTR_NAN_MATCH: used to report a match. This is a nested attribute.
+ *	See &enum nl80211_nan_match_attributes.
  *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
@@ -2227,6 +2234,7 @@ enum nl80211_attrs {
 	NL80211_ATTR_NAN_DUAL,
 	NL80211_ATTR_NAN_FUNC,
 	NL80211_ATTR_NAN_FUNC_INST_ID,
+	NL80211_ATTR_NAN_MATCH,
 
 	/* add attributes here, update the policy in nl80211.c */
 
@@ -4868,4 +4876,34 @@ enum nl80211_nan_srf_attributes {
 	NL80211_NAN_SRF_ATTR_MAX = NUM_NL80211_NAN_SRF_ATTR - 1,
 };
 
+/**
+ * enum nl80211_nan_match_attributes - NAN match attributes
+ * @__NL80211_NAN_MATCH_INVALID: invalid
+ * @NL80211_NAN_MATCH_FUNC_TYPE: &enum nl80211_nan_function_type (u8). This is
+ *	the type of the function which had a match.
+ * @NL80211_NAN_MATCH_INSTANCE_ID: The instance ID of the local function that
+ *	had a match. This is a u8.
+ * @NL80211_NAN_MATCH_PEER_INSTANCE_ID: The instance ID of the peer's function
+ *	that caused the match. This is a u8.
+ * @NL80211_NAN_MATCH_MAC: The MAC address of the peer. This attribute is
+ *	binary.
+ * @NL80211_NAN_MATCH_SERVICE_INFO: array of bytes describing the peer's
+ *	service specific info. This is a binary attribute.
+ *
+ * @NUM_NL80211_NAN_MATCH_ATTR: internal
+ * @NL80211_NAN_MATCH_ATTR_MAX: highest NAN match attribute
+ */
+enum nl80211_nan_match_attributes {
+	__NL80211_NAN_MATCH_INVALID,
+	NL80211_NAN_MATCH_FUNC_TYPE,
+	NL80211_NAN_MATCH_INSTANCE_ID,
+	NL80211_NAN_MATCH_PEER_INSTANCE_ID,
+	NL80211_NAN_MATCH_MAC,
+	NL80211_NAN_MATCH_SERVICE_INFO,
+
+	/* keep last */
+	NUM_NL80211_NAN_MATCH_ATTR,
+	NL80211_NAN_MATCH_ATTR_MAX = NUM_NL80211_NAN_MATCH_ATTR - 1
+};
+
 #endif /* __LINUX_NL80211_H */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 3c4d374..6015c58 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -56,6 +56,7 @@ enum nl80211_multicast_groups {
 	NL80211_MCGRP_REGULATORY,
 	NL80211_MCGRP_MLME,
 	NL80211_MCGRP_VENDOR,
+	NL80211_MCGRP_NAN,
 	NL80211_MCGRP_TESTMODE /* keep last - ifdef! */
 };
 
@@ -65,6 +66,7 @@ static const struct genl_multicast_group nl80211_mcgrps[] = {
 	[NL80211_MCGRP_REGULATORY] = { .name = NL80211_MULTICAST_GROUP_REG },
 	[NL80211_MCGRP_MLME] = { .name = NL80211_MULTICAST_GROUP_MLME },
 	[NL80211_MCGRP_VENDOR] = { .name = NL80211_MULTICAST_GROUP_VENDOR },
+	[NL80211_MCGRP_NAN] = { .name = NL80211_MULTICAST_GROUP_NAN },
 #ifdef CONFIG_NL80211_TESTMODE
 	[NL80211_MCGRP_TESTMODE] = { .name = NL80211_MULTICAST_GROUP_TESTMODE }
 #endif
@@ -10412,6 +10414,66 @@ static int nl80211_nan_change_config(struct sk_buff *skb,
 	return rdev_nan_change_conf(rdev, wdev, &conf, changed);
 }
 
+void cfg80211_nan_match(struct wireless_dev *wdev,
+			struct cfg80211_nan_match_params *match, gfp_t gfp)
+{
+	struct wiphy *wiphy = wdev->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
+	struct nlattr *match_attr;
+	struct sk_buff *msg;
+	void *hdr;
+
+	if (WARN_ON(!match->inst_id || !match->peer_inst_id || !match->addr))
+		return;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_NAN_MATCH);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
+	    (wdev->netdev && nla_put_u32(msg, NL80211_ATTR_IFINDEX,
+					 wdev->netdev->ifindex)) ||
+	    nla_put_u64(msg, NL80211_ATTR_WDEV, wdev_id(wdev)))
+		goto nla_put_failure;
+
+	if (nla_put_u64(msg, NL80211_ATTR_COOKIE, match->cookie))
+		goto nla_put_failure;
+
+	match_attr = nla_nest_start(msg, NL80211_ATTR_NAN_MATCH);
+	if (!match_attr)
+		goto nla_put_failure;
+
+	if (nla_put_u8(msg, NL80211_NAN_MATCH_FUNC_TYPE, match->type) ||
+	    nla_put_u8(msg, NL80211_NAN_MATCH_INSTANCE_ID, match->inst_id) ||
+	    nla_put_u8(msg, NL80211_NAN_MATCH_PEER_INSTANCE_ID,
+		       match->peer_inst_id) ||
+	    nla_put(msg, NL80211_NAN_MATCH_MAC, ETH_ALEN, match->addr))
+		goto nla_put_failure;
+
+	if (match->info && match->info_len &&
+	    nla_put(msg, NL80211_NAN_MATCH_SERVICE_INFO, match->info_len,
+		    match->info))
+		goto nla_put_failure;
+
+	nla_nest_end(msg, match_attr);
+	genlmsg_end(msg, hdr);
+
+	genlmsg_multicast_netns(&nl80211_fam, wiphy_net(&rdev->wiphy), msg, 0,
+				NL80211_MCGRP_NAN, gfp);
+	return;
+
+nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	nlmsg_free(msg);
+}
+EXPORT_SYMBOL(cfg80211_nan_match);
+
 static int nl80211_get_protocol_features(struct sk_buff *skb,
 					 struct genl_info *info)
 {
-- 
2.5.0

