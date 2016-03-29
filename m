Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:4114 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756151AbcC2JfW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2016 05:35:22 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCHv3 RESEND 06/11] cfg80211: Provide an API to report NAN function termination
Date: Tue, 29 Mar 2016 12:35:04 +0300
Message-Id: <1459244109-16038-6-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160329_113539_905108_B3DB664F)
In-Reply-To: <1459244109-16038-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1459244109-16038-1-git-send-email-emmanuel.grumbach@intel.com>
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
index 8c200a0..3a94b21 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5528,6 +5528,22 @@ struct cfg80211_nan_match_params {
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
index 40dbbb9..f4a2e46 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1862,6 +1862,8 @@ enum nl80211_commands {
  *	Its type is u8 and it cannot be 0.
  * @NL80211_ATTR_NAN_MATCH: used to report a match. This is a nested attribute.
  *	See &enum nl80211_nan_match_attributes.
+ * @NL80211_ATTR_NAN_FUNC_TERM_REASON: NAN function termination reason.
+ *	See &enum nl80211_nan_func_term_reason.
  *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
@@ -2246,6 +2248,7 @@ enum nl80211_attrs {
 	NL80211_ATTR_NAN_FUNC,
 	NL80211_ATTR_NAN_FUNC_INST_ID,
 	NL80211_ATTR_NAN_MATCH,
+	NL80211_ATTR_NAN_FUNC_TERM_REASON,
 
 	/* add attributes here, update the policy in nl80211.c */
 
@@ -4838,6 +4841,21 @@ enum nl80211_nan_publish_type {
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
index 32334df..4872349 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -10591,6 +10591,52 @@ nla_put_failure:
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

