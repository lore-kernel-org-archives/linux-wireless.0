Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:41124 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752709AbcB2NZe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 08:25:34 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, QH <qiumin.hu@gmail.com>,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	Etan Cohen <etancohen@google.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 06/12] cfg80211: Provide an API to report NAN function termination
Date: Mon, 29 Feb 2016 15:25:07 +0200
Message-Id: <1456752313-5792-7-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160229_142536_793419_C2DA8940)
In-Reply-To: <1456752313-5792-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1456752313-5792-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

Provide a function that reports NAN DE function termination. The function
may be terminated due to one of the following reasons: user request,
ttl expiration or failure.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/cfg80211.h       | 16 +++++++++++++++
 include/uapi/linux/nl80211.h | 18 +++++++++++++++++
 net/wireless/nl80211.c       | 46 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 80 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 11d8aaf..a016abc 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5494,6 +5494,22 @@ struct cfg80211_nan_match_params {
 void cfg80211_nan_match(struct wireless_dev *wdev,
 			struct cfg80211_nan_match_params *match, gfp_t gfp);
 
+/**
+ * cfg80211_nan_func_terminated - notify about NAN function termination.
+ *
+ * @wdev: the wireless device reporting the match
+ * @inst_id: the local instance id
+ * @reason: termination reason (one of the NL80211_NAN_FUNC_TERM_REASON_*)
+ * @cookie: user defined cookie
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
index d25c85a..3c0b71f 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1853,6 +1853,8 @@ enum nl80211_commands {
  *	Its type is u8 and it cannot be 0.
  * @NL80211_ATTR_NAN_MATCH: used to report a match. This is a nested attribute.
  *	See &enum nl80211_nan_match_attributes.
+ * @NL80211_ATTR_NAN_FUNC_TERM_REASON: NAN function termination reason.
+ *	See &enum nl80211_nan_func_term_reason.
  *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
@@ -2235,6 +2237,7 @@ enum nl80211_attrs {
 	NL80211_ATTR_NAN_FUNC,
 	NL80211_ATTR_NAN_FUNC_INST_ID,
 	NL80211_ATTR_NAN_MATCH,
+	NL80211_ATTR_NAN_FUNC_TERM_REASON,
 
 	/* add attributes here, update the policy in nl80211.c */
 
@@ -4783,6 +4786,21 @@ enum nl80211_nan_publish_type {
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
index 6015c58..9470d36 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -10474,6 +10474,52 @@ nla_put_failure:
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
+	void *hdr;
+
+	if (WARN_ON(!inst_id))
+		return;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_RM_NAN_FUNCTION);
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
+	if (nla_put_u8(msg, NL80211_ATTR_NAN_FUNC_INST_ID, inst_id) ||
+	    nla_put_u8(msg, NL80211_ATTR_NAN_FUNC_TERM_REASON, reason) ||
+	    nla_put_u64(msg, NL80211_ATTR_COOKIE, cookie))
+		goto nla_put_failure;
+
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
+EXPORT_SYMBOL(cfg80211_nan_func_terminated);
+
 static int nl80211_get_protocol_features(struct sk_buff *skb,
 					 struct genl_info *info)
 {
-- 
2.5.0

