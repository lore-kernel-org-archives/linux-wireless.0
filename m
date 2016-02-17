Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:35691 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933149AbcBQSaP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2016 13:30:15 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Beni Lev <beni.lev@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] cfg80211: Add global RRM capability
Date: Wed, 17 Feb 2016 20:30:00 +0200
Message-Id: <1455733800-13230-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160217_193023_166442_22A3818D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Beni Lev <beni.lev@intel.com>

Today, the supplicant will add the RRM capabilities
Information Element in the association request only if
Quiet period is supported (NL80211_FEATURE_QUIET).

Quiet is one of many RRM features, and there are other RRM
features that are not related to Quiet (e.g. neighbor
report). Therefore, requiring Quiet to enable RRM is too
restrictive.
Some of the features, like neighbor report, can be
supported by user space without any help from the kernel.
Hence adding the RRM capabilities IE to association request
should be the sole user space's decision.
Removing the RRM dependency on Quiet in the driver solves
this problem, but using an old driver with a user space
tool that would not require Quiet feature would be
problematic: the user space would add NL80211_ATTR_USE_RRM
in the association request even if the kernel doesn't
advertize NL80211_FEATURE_QUIET and the association would
be denied by the kernel.

This solution adds a global RRM capability, that tells user
space that it can request RRM capabilities IE publishment
without any specific feature support in the kernel.

Signed-off-by: Beni Lev <beni.lev@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/uapi/linux/nl80211.h |  8 ++++++++
 net/wireless/nl80211.c       | 18 +++++++++++-------
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 7758969..5a30a75 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1727,6 +1727,8 @@ enum nl80211_commands {
  *	underlying device supports these minimal RRM features:
  *		%NL80211_FEATURE_DS_PARAM_SET_IE_IN_PROBES,
  *		%NL80211_FEATURE_QUIET,
+ *	Or, if global RRM is supported, see:
+ *		%NL80211_EXT_FEATURE_RRM
  *	If this flag is used, driver must add the Power Capabilities IE to the
  *	association request. In addition, it must also set the RRM capability
  *	flag in the association request's Capability Info field.
@@ -4402,12 +4404,18 @@ enum nl80211_feature_flags {
 /**
  * enum nl80211_ext_feature_index - bit index of extended features.
  * @NL80211_EXT_FEATURE_VHT_IBSS: This driver supports IBSS with VHT datarates.
+ * @NL80211_EXT_FEATURE_RRM: This driver supports RRM. When featured, user can
+ *	can request to use RRM (see %NL80211_ATTR_USE_RRM) with
+ *	%NL80211_CMD_ASSOCIATE and %NL80211_CMD_CONNECT requests, which will set
+ *	the ASSOC_REQ_USE_RRM flag in the association request even if
+ *	NL80211_FEATURE_QUIET is not advertized.
  *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
  */
 enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_VHT_IBSS,
+	NL80211_EXT_FEATURE_RRM,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 268cb49..90890f1 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3,7 +3,7 @@
  *
  * Copyright 2006-2010	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
- * Copyright 2015	Intel Deutschland GmbH
+ * Copyright 2015-2016	Intel Deutschland GmbH
  */
 
 #include <linux/if.h>
@@ -7286,9 +7286,11 @@ static int nl80211_associate(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	if (nla_get_flag(info->attrs[NL80211_ATTR_USE_RRM])) {
-		if (!(rdev->wiphy.features &
-		      NL80211_FEATURE_DS_PARAM_SET_IE_IN_PROBES) ||
-		    !(rdev->wiphy.features & NL80211_FEATURE_QUIET))
+		if (!((rdev->wiphy.features &
+			NL80211_FEATURE_DS_PARAM_SET_IE_IN_PROBES) &&
+		       (rdev->wiphy.features & NL80211_FEATURE_QUIET)) &&
+		    !wiphy_ext_feature_isset(&rdev->wiphy,
+					     NL80211_EXT_FEATURE_RRM))
 			return -EINVAL;
 		req.flags |= ASSOC_REQ_USE_RRM;
 	}
@@ -7976,9 +7978,11 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	if (nla_get_flag(info->attrs[NL80211_ATTR_USE_RRM])) {
-		if (!(rdev->wiphy.features &
-		      NL80211_FEATURE_DS_PARAM_SET_IE_IN_PROBES) ||
-		    !(rdev->wiphy.features & NL80211_FEATURE_QUIET)) {
+		if (!((rdev->wiphy.features &
+			NL80211_FEATURE_DS_PARAM_SET_IE_IN_PROBES) &&
+		       (rdev->wiphy.features & NL80211_FEATURE_QUIET)) &&
+		    !wiphy_ext_feature_isset(&rdev->wiphy,
+					     NL80211_EXT_FEATURE_RRM)) {
 			kzfree(connkeys);
 			return -EINVAL;
 		}
-- 
2.5.0

