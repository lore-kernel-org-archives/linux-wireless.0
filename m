Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:65211 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932108AbaICMcr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 08:32:47 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Assaf Krauss <assaf.krauss@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 05/10] nl80211: Add flag attribute for RRM connections
Date: Wed,  3 Sep 2014 15:25:01 +0300
Message-Id: <1409747106-30717-6-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140903_143256_784346_20B5820E)
In-Reply-To: <1409747106-30717-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1409747106-30717-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Assaf Krauss <assaf.krauss@intel.com>

Add a flag attribute to use in associations, for tagging the target
connection as supporting RRM. It is the responsibility of upper
layers to set this flag only if both the underlying device, and the
target network indeed support RRM.
To be used in ASSOCIATE and CONNECT commands.

Signed-off-by: Assaf Krauss <assaf.krauss@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/cfg80211.h       |  2 ++
 include/uapi/linux/nl80211.h | 13 +++++++++++++
 net/wireless/nl80211.c       | 17 +++++++++++++++++
 3 files changed, 32 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 42a990c..dbd696d 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1606,10 +1606,12 @@ struct cfg80211_auth_request {
  *
  * @ASSOC_REQ_DISABLE_HT:  Disable HT (802.11n)
  * @ASSOC_REQ_DISABLE_VHT:  Disable VHT
+ * @ASSOC_REQ_USE_RRM: Declare RRM capability in this association
  */
 enum cfg80211_assoc_req_flags {
 	ASSOC_REQ_DISABLE_HT		= BIT(0),
 	ASSOC_REQ_DISABLE_VHT		= BIT(1),
+	ASSOC_REQ_USE_RRM		= BIT(2),
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 375225f..8951c31 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1594,6 +1594,17 @@ enum nl80211_commands {
  * @NL80211_ATTR_TDLS_INITIATOR: flag attribute indicating the current end is
  *	the TDLS link initiator.
  *
+ * @NL80211_ATTR_USE_RRM: flag for indicating whether the current connection
+ *	shall support Radio Resource Measurements (11k). This attribute can be
+ *	used with %NL80211_CMD_ASSOCIATE and %NL80211_CMD_CONNECT requests.
+ *	User space applications are expected to use this flag only if the
+ *	underlying device supports these minimal RRM features:
+ *		%NL80211_FEATURE_DS_PARAM_SET_IE_IN_PROBES,
+ *		%NL80211_FEATURE_QUIET,
+ *	If this flag is used, driver must add the Power Capabilities IE to the
+ *	association request. In addition, it must also set the RRM capability
+ *	flag in the association request's Capability Info field.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1936,6 +1947,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_TDLS_INITIATOR,
 
+	NL80211_ATTR_USE_RRM,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 23f5ee7..55da200 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -389,6 +389,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_TDLS_PEER_CAPABILITY] = { .type = NLA_U32 },
 	[NL80211_ATTR_IFACE_SOCKET_OWNER] = { .type = NLA_FLAG },
 	[NL80211_ATTR_CSA_C_OFFSETS_TX] = { .type = NLA_BINARY },
+	[NL80211_ATTR_USE_RRM] = { .type = NLA_FLAG },
 };
 
 /* policy for the key attributes */
@@ -6576,6 +6577,14 @@ static int nl80211_associate(struct sk_buff *skb, struct genl_info *info)
 		       sizeof(req.vht_capa));
 	}
 
+	if (nla_get_flag(info->attrs[NL80211_ATTR_USE_RRM])) {
+		if (!(rdev->wiphy.features &
+		      NL80211_FEATURE_DS_PARAM_SET_IE_IN_PROBES) ||
+		    !(rdev->wiphy.features & NL80211_FEATURE_QUIET))
+			return -EINVAL;
+		req.flags |= ASSOC_REQ_USE_RRM;
+	}
+
 	err = nl80211_crypto_settings(rdev, info, &req.crypto, 1);
 	if (!err) {
 		wdev_lock(dev->ieee80211_ptr);
@@ -7233,6 +7242,14 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
 		       sizeof(connect.vht_capa));
 	}
 
+	if (nla_get_flag(info->attrs[NL80211_ATTR_USE_RRM])) {
+		if (!(rdev->wiphy.features &
+		      NL80211_FEATURE_DS_PARAM_SET_IE_IN_PROBES) ||
+		    !(rdev->wiphy.features & NL80211_FEATURE_QUIET))
+			return -EINVAL;
+		connect.flags |= ASSOC_REQ_USE_RRM;
+	}
+
 	wdev_lock(dev->ieee80211_ptr);
 	err = cfg80211_connect(rdev, dev, &connect, connkeys, NULL);
 	wdev_unlock(dev->ieee80211_ptr);
-- 
1.9.1

