Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:2314 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932614AbcCQNln (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 09:41:43 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Avraham Stern <avraham.stern@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/5] nl80211: add an option to set driver action for beacon loss
Date: Thu, 17 Mar 2016 15:41:35 +0200
Message-Id: <1458222099-30301-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160317_144147_675403_D8A0C160)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avraham Stern <avraham.stern@intel.com>

When beacon loss is detected the driver will try to probe the AP and
if the AP does not respond, it will disconnect. However, userspace
may not want to disconnect immediately but look for a roaming
candidate first.
So add a flag to connect and association commands that indicates that
for the current connection the driver should not disconnect when
beacon loss is detected but only send an event to userspace.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/cfg80211.h       |  3 +++
 include/uapi/linux/nl80211.h | 11 +++++++++++
 net/wireless/nl80211.c       | 15 +++++++++++++++
 3 files changed, 29 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 0bbfbf3..3f49867 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1728,11 +1728,14 @@ struct cfg80211_auth_request {
  * @ASSOC_REQ_DISABLE_HT:  Disable HT (802.11n)
  * @ASSOC_REQ_DISABLE_VHT:  Disable VHT
  * @ASSOC_REQ_USE_RRM: Declare RRM capability in this association
+ * @ASSOC_REQ_BEACON_LOSS_DO_NOT_DISCONNECT: Do not disconnect when beacon loss
+ *	is detected but only send a beacon loss event.
  */
 enum cfg80211_assoc_req_flags {
 	ASSOC_REQ_DISABLE_HT		= BIT(0),
 	ASSOC_REQ_DISABLE_VHT		= BIT(1),
 	ASSOC_REQ_USE_RRM		= BIT(2),
+	ASSOC_REQ_BEACON_LOSS_DO_NOT_DISCONNECT	= BIT(3),
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index b2a8d8c..673328a 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1804,6 +1804,9 @@ enum nl80211_commands {
  *	it contains the behaviour-specific attribute containing the parameters for
  *	BSS selection to be done by driver and/or firmware.
  *
+ * @NL80211_ATTR_BEACON_LOSS_DO_NOT_DISCONNECT: If set, the driver should not
+ *	take action (e.g. disconnect) upon beacon loss besides sending an event.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2182,6 +2185,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_BSS_SELECT,
 
+	NL80211_ATTR_BEACON_LOSS_DO_NOT_DISCONNECT,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -4419,6 +4424,11 @@ enum nl80211_feature_flags {
  *	%NL80211_CMD_ASSOCIATE and %NL80211_CMD_CONNECT requests, which will set
  *	the ASSOC_REQ_USE_RRM flag in the association request even if
  *	NL80211_FEATURE_QUIET is not advertized.
+ * @NL80211_EXT_FEATURE_BEACON_LOSS_DO_NOT_DISCONNECT: The driver supports
+ *	configuration in which the driver will not disconnect when beacon loss
+ *	is detected but it will only send a beacon loss event.
+ *	%NL80211_ATTR_BEACON_LOSS_DO_NOT_DISCONNECT flag attribute is used to
+ *	enable this configuration.
  *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
@@ -4426,6 +4436,7 @@ enum nl80211_feature_flags {
 enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_VHT_IBSS,
 	NL80211_EXT_FEATURE_RRM,
+	NL80211_EXT_FEATURE_BEACON_LOSS_DO_NOT_DISCONNECT,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c4233a0..749e315 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -403,6 +403,7 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_REG_INDOOR] = { .type = NLA_FLAG },
 	[NL80211_ATTR_PBSS] = { .type = NLA_FLAG },
 	[NL80211_ATTR_BSS_SELECT] = { .type = NLA_NESTED },
+	[NL80211_ATTR_BEACON_LOSS_DO_NOT_DISCONNECT] = { .type = NLA_FLAG },
 };
 
 /* policy for the key attributes */
@@ -7397,6 +7398,13 @@ static int nl80211_associate(struct sk_buff *skb, struct genl_info *info)
 		req.flags |= ASSOC_REQ_USE_RRM;
 	}
 
+	if (nla_get_flag(info->attrs[NL80211_ATTR_BEACON_LOSS_DO_NOT_DISCONNECT])) {
+		if (!wiphy_ext_feature_isset(&rdev->wiphy,
+					     NL80211_EXT_FEATURE_BEACON_LOSS_DO_NOT_DISCONNECT))
+			return -EINVAL;
+		req.flags |= ASSOC_REQ_BEACON_LOSS_DO_NOT_DISCONNECT;
+	}
+
 	err = nl80211_crypto_settings(rdev, info, &req.crypto, 1);
 	if (!err) {
 		wdev_lock(dev->ieee80211_ptr);
@@ -8112,6 +8120,13 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
 		}
 	}
 
+	if (nla_get_flag(info->attrs[NL80211_ATTR_BEACON_LOSS_DO_NOT_DISCONNECT])) {
+		if (!wiphy_ext_feature_isset(&rdev->wiphy,
+					     NL80211_EXT_FEATURE_BEACON_LOSS_DO_NOT_DISCONNECT))
+			return -EINVAL;
+		connect.flags |= ASSOC_REQ_BEACON_LOSS_DO_NOT_DISCONNECT;
+	}
+
 	wdev_lock(dev->ieee80211_ptr);
 	err = cfg80211_connect(rdev, dev, &connect, connkeys, NULL);
 	wdev_unlock(dev->ieee80211_ptr);
-- 
2.5.0

