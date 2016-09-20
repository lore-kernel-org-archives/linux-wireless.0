Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:56536 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755005AbcITObl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Sep 2016 10:31:41 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, ayala.beker@intel.com,
        andrei.otcheretianski@intel.com, arend.vanspriel@broadcom.com,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 20 Sep 2016 17:31:18 +0300
Message-Id: <20160920143121.28247-7-luca@coelho.fi> (sfid-20160920_163145_256362_D01B0D3B)
In-Reply-To: <20160920143121.28247-1-luca@coelho.fi>
References: <20160920143121.28247-1-luca@coelho.fi>
Subject: [PATCH v3 6/9] cfg80211: Provide an API to report NAN function termination
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ayala Beker <ayala.beker@intel.com>

Provide a function that reports NAN DE function termination. The function
may be terminated due to one of the following reasons: user request,
ttl expiration or failure.
If the NAN instance is tied to the owner, the notification will be
sent to the socket that started the NAN interface only

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/net/cfg80211.h       | 16 ++++++++++++
 include/uapi/linux/nl80211.h | 18 +++++++++++++
 net/wireless/nl80211.c       | 60 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 94 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 983b0bb..73f7f75 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5676,6 +5676,22 @@ struct cfg80211_nan_match_params {
 void cfg80211_nan_match(struct wireless_dev *wdev,
 			struct cfg80211_nan_match_params *match, gfp_t gfp);
 
+/**
+ * cfg80211_nan_func_terminated - notify about NAN function termination.
+ *
+ * @wdev: the wireless device reporting the match
+ * @inst_id: the local instance id
+ * @reason: termination reason (one of the NL80211_NAN_FUNC_TERM_REASON_*)
+ * @cookie: unique NAN function identifier
+ * @gfp: allocation flags
+ *
+ * This function reports that the a NAN function is terminated.
+ */
+void cfg80211_nan_func_terminated(struct wireless_dev *wdev,
+				  u8 inst_id,
+				  enum nl80211_nan_func_term_reason reason,
+				  u64 cookie, gfp_t gfp);
+
 /* ethtool helper */
 void cfg80211_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info);
 
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index b845f9c..0489ba1 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -863,6 +863,9 @@
  *	the response to this command.
  *	Look at %NL80211_ATTR_SOCKET_OWNER as well.
  * @NL80211_CMD_DEL_NAN_FUNCTION: Delete a NAN function by cookie.
+ *	This command is also used as a notification sent when a NAN function is
+ *	terminated. This will contain a %NL80211_ATTR_NAN_FUNC_INST_ID
+ *	and %NL80211_ATTR_COOKIE attributes.
  * @NL80211_CMD_CHANGE_NAN_CONFIG: Change current NAN configuration. NAN
  *	must be operational (%NL80211_CMD_START_NAN was executed).
  *	It must contain at least one of the following attributes:
@@ -4970,6 +4973,21 @@ enum nl80211_nan_publish_type {
 	NL80211_NAN_UNSOLICITED_PUBLISH = 1 << 1,
 };
 
+/**
+ * enum nl80211_nan_func_term_reason - NAN functions termination reason
+ *
+ * Defines termination reasons of a NAN function
+ *
+ * @NL80211_NAN_FUNC_TERM_REASON_USER_REQUEST: requested by user
+ * @NL80211_NAN_FUNC_TERM_REASON_TTL_EXPIRED: timeout
+ * @NL80211_NAN_FUNC_TERM_REASON_ERROR: errored
+ */
+enum nl80211_nan_func_term_reason {
+	NL80211_NAN_FUNC_TERM_REASON_USER_REQUEST,
+	NL80211_NAN_FUNC_TERM_REASON_TTL_EXPIRED,
+	NL80211_NAN_FUNC_TERM_REASON_ERROR,
+};
+
 #define NL80211_NAN_FUNC_SERVICE_ID_LEN 6
 #define NL80211_NAN_FUNC_SERVICE_SPEC_INFO_MAX_LEN 0xff
 #define NL80211_NAN_FUNC_SRF_MAX_LEN 0xff
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 73a8ac5..718f8643 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -10943,6 +10943,66 @@ nla_put_failure:
 }
 EXPORT_SYMBOL(cfg80211_nan_match);
 
+void cfg80211_nan_func_terminated(struct wireless_dev *wdev,
+				  u8 inst_id,
+				  enum nl80211_nan_func_term_reason reason,
+				  u64 cookie, gfp_t gfp)
+{
+	struct wiphy *wiphy = wdev->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
+	struct sk_buff *msg;
+	struct nlattr *func_attr;
+	void *hdr;
+
+	if (WARN_ON(!inst_id))
+		return;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_DEL_NAN_FUNCTION);
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
+	if (nla_put_u64_64bit(msg, NL80211_ATTR_COOKIE, cookie,
+			      NL80211_ATTR_PAD))
+		goto nla_put_failure;
+
+	func_attr = nla_nest_start(msg, NL80211_ATTR_NAN_FUNC);
+	if (!func_attr)
+		goto nla_put_failure;
+
+	if (nla_put_u8(msg, NL80211_NAN_FUNC_INSTANCE_ID, inst_id) ||
+	    nla_put_u8(msg, NL80211_NAN_FUNC_TERM_REASON, reason))
+		goto nla_put_failure;
+
+	nla_nest_end(msg, func_attr);
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
+EXPORT_SYMBOL(cfg80211_nan_func_terminated);
+
 static int nl80211_get_protocol_features(struct sk_buff *skb,
 					 struct genl_info *info)
 {
-- 
2.9.3
