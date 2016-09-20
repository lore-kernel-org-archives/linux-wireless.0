Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:56524 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755020AbcITObk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Sep 2016 10:31:40 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, ayala.beker@intel.com,
        andrei.otcheretianski@intel.com, arend.vanspriel@broadcom.com,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 20 Sep 2016 17:31:17 +0300
Message-Id: <20160920143121.28247-6-luca@coelho.fi> (sfid-20160920_163147_786510_AB06830E)
In-Reply-To: <20160920143121.28247-1-luca@coelho.fi>
References: <20160920143121.28247-1-luca@coelho.fi>
Subject: [PATCH v3 5/9] cfg80211: provide a function to report a match for NAN
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ayala Beker <ayala.beker@intel.com>

Provide a function the driver can call to report a match.
This will send the event to the user space.
If the NAN instance is tied to the owner, the notifications will be
sent to the socket that started the NAN interface only.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/net/cfg80211.h       | 37 ++++++++++++++++++++
 include/uapi/linux/nl80211.h | 31 +++++++++++++++++
 net/wireless/nl80211.c       | 80 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 148 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 22cc70e..983b0bb 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5639,6 +5639,43 @@ wiphy_ext_feature_isset(struct wiphy *wiphy,
  */
 void cfg80211_free_nan_func(struct cfg80211_nan_func *f);
 
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
+ * @cookie: unique identifier of the corresponding function
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
index 4664904..b845f9c 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -48,6 +48,7 @@
 #define NL80211_MULTICAST_GROUP_REG		"regulatory"
 #define NL80211_MULTICAST_GROUP_MLME		"mlme"
 #define NL80211_MULTICAST_GROUP_VENDOR		"vendor"
+#define NL80211_MULTICAST_GROUP_NAN		"nan"
 #define NL80211_MULTICAST_GROUP_TESTMODE	"testmode"
 
 /**
@@ -866,6 +867,9 @@
  *	must be operational (%NL80211_CMD_START_NAN was executed).
  *	It must contain at least one of the following attributes:
  *	%NL80211_ATTR_NAN_MASTER_PREF, %NL80211_ATTR_NAN_DUAL.
+ * @NL80211_CMD_NAN_FUNC_MATCH: Notification sent when a match is reported.
+ *	This will contain a %NL80211_ATTR_NAN_MATCH nested attribute and
+ *	%NL80211_ATTR_COOKIE.
  *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
@@ -1060,6 +1064,7 @@ enum nl80211_commands {
 	NL80211_CMD_ADD_NAN_FUNCTION,
 	NL80211_CMD_DEL_NAN_FUNCTION,
 	NL80211_CMD_CHANGE_NAN_CONFIG,
+	NL80211_CMD_NAN_MATCH,
 
 	/* add new commands above here */
 
@@ -1920,6 +1925,8 @@ enum nl80211_commands {
  * @NL80211_ATTR_NAN_FUNC: a function that can be added to NAN. See
  *	&enum nl80211_nan_func_attributes for description of this nested
  *	attribute.
+ * @NL80211_ATTR_NAN_MATCH: used to report a match. This is a nested attribute.
+ *	See &enum nl80211_nan_match_attributes.
  *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
@@ -2318,6 +2325,7 @@ enum nl80211_attrs {
 	NL80211_ATTR_NAN_MASTER_PREF,
 	NL80211_ATTR_NAN_DUAL,
 	NL80211_ATTR_NAN_FUNC,
+	NL80211_ATTR_NAN_MATCH,
 
 	/* add attributes here, update the policy in nl80211.c */
 
@@ -5059,4 +5067,27 @@ enum nl80211_nan_srf_attributes {
 	NL80211_NAN_SRF_ATTR_MAX = NUM_NL80211_NAN_SRF_ATTR - 1,
 };
 
+/**
+ * enum nl80211_nan_match_attributes - NAN match attributes
+ * @__NL80211_NAN_MATCH_INVALID: invalid
+ * @NL80211_NAN_MATCH_FUNC_LOCAL: the local function that had the
+ *	match. This is a nested attribute.
+ *	See &enum nl80211_nan_func_attributes.
+ * @NL80211_NAN_MATCH_FUNC_PEER: the peer function
+ *	that caused the match. This is a nested attribute.
+ *	See &enum nl80211_nan_func_attributes.
+ *
+ * @NUM_NL80211_NAN_MATCH_ATTR: internal
+ * @NL80211_NAN_MATCH_ATTR_MAX: highest NAN match attribute
+ */
+enum nl80211_nan_match_attributes {
+	__NL80211_NAN_MATCH_INVALID,
+	NL80211_NAN_MATCH_FUNC_LOCAL,
+	NL80211_NAN_MATCH_FUNC_PEER,
+
+	/* keep last */
+	NUM_NL80211_NAN_MATCH_ATTR,
+	NL80211_NAN_MATCH_ATTR_MAX = NUM_NL80211_NAN_MATCH_ATTR - 1
+};
+
 #endif /* __LINUX_NL80211_H */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 7058669..73a8ac5 100644
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
@@ -10863,6 +10865,84 @@ static int nl80211_nan_change_config(struct sk_buff *skb,
 	return rdev_nan_change_conf(rdev, wdev, &conf, changed);
 }
 
+void cfg80211_nan_match(struct wireless_dev *wdev,
+			struct cfg80211_nan_match_params *match, gfp_t gfp)
+{
+	struct wiphy *wiphy = wdev->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
+	struct nlattr *match_attr, *local_func_attr, *peer_func_attr;
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
+	    nla_put_u64_64bit(msg, NL80211_ATTR_WDEV, wdev_id(wdev),
+			      NL80211_ATTR_PAD))
+		goto nla_put_failure;
+
+	if (nla_put_u64_64bit(msg, NL80211_ATTR_COOKIE, match->cookie,
+			      NL80211_ATTR_PAD) ||
+	    nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, match->addr))
+		goto nla_put_failure;
+
+	match_attr = nla_nest_start(msg, NL80211_ATTR_NAN_MATCH);
+	if (!match_attr)
+		goto nla_put_failure;
+
+	local_func_attr = nla_nest_start(msg, NL80211_NAN_MATCH_FUNC_LOCAL);
+	if (!local_func_attr)
+		goto nla_put_failure;
+
+	if (nla_put_u8(msg, NL80211_NAN_FUNC_INSTANCE_ID, match->inst_id))
+		goto nla_put_failure;
+
+	nla_nest_end(msg, local_func_attr);
+
+	peer_func_attr = nla_nest_start(msg, NL80211_NAN_MATCH_FUNC_PEER);
+	if (!peer_func_attr)
+		goto nla_put_failure;
+
+	if (nla_put_u8(msg, NL80211_NAN_FUNC_TYPE, match->type) ||
+	    nla_put_u8(msg, NL80211_NAN_FUNC_INSTANCE_ID, match->peer_inst_id))
+		goto nla_put_failure;
+
+	if (match->info && match->info_len &&
+	    nla_put(msg, NL80211_NAN_FUNC_SERVICE_INFO, match->info_len,
+		    match->info))
+		goto nla_put_failure;
+
+	nla_nest_end(msg, peer_func_attr);
+	nla_nest_end(msg, match_attr);
+	genlmsg_end(msg, hdr);
+
+	if (!wdev->owner_nlportid)
+		genlmsg_multicast_netns(&nl80211_fam, wiphy_net(&rdev->wiphy),
+					msg, 0, NL80211_MCGRP_NAN, gfp);
+	else
+		genlmsg_unicast(wiphy_net(&rdev->wiphy), msg,
+				wdev->owner_nlportid);
+
+	return;
+
+nla_put_failure:
+	nlmsg_free(msg);
+}
+EXPORT_SYMBOL(cfg80211_nan_match);
+
 static int nl80211_get_protocol_features(struct sk_buff *skb,
 					 struct genl_info *info)
 {
-- 
2.9.3
