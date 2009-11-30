Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56828 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410AbZK3Pnb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 10:43:31 -0500
Message-Id: <20091130154300.492667106@sipsolutions.net>
Date: Mon, 30 Nov 2009 16:38:58 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] cfg80211: add SM PS hooks
References: <20091130153857.963079149@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add spatial multiplexing power save configuration
hooks to cfg80211/nl80211.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/linux/nl80211.h |   32 ++++++++++++++++++++++++++++++++
 include/net/cfg80211.h  |    5 ++++-
 net/wireless/nl80211.c  |   21 +++++++++++++++++++++
 3 files changed, 57 insertions(+), 1 deletion(-)

--- wireless-testing.orig/include/linux/nl80211.h	2009-11-29 11:33:01.000000000 +0100
+++ wireless-testing/include/linux/nl80211.h	2009-11-29 11:34:11.000000000 +0100
@@ -606,6 +606,11 @@ enum nl80211_commands {
  * @NL80211_ATTR_MAX_NUM_PMKIDS: maximum number of PMKIDs a firmware can
  *	cache, a wiphy attribute.
  *
+ * @NL80211_ATTR_SMPS_MODE: Used with change interface, this will set the
+ *	desired spatial multiplexing powersave mode for a device. Due to
+ *	multiple virtual interfaces it might not always be the mode that
+ *	actually ends up being used.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -743,6 +748,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_PMKID,
 	NL80211_ATTR_MAX_NUM_PMKIDS,
 
+	NL80211_ATTR_SMPS_MODE,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -1442,4 +1449,29 @@ enum nl80211_key_attributes {
 	NL80211_KEY_MAX = __NL80211_KEY_AFTER_LAST - 1
 };
 
+/**
+ * enum nl80211_smps_mode - spatial multiplexing powersave mode
+ *
+ * @NL80211_SMPS_AUTOMATIC: automatic SM PS, i.e. enable
+ *	dynamic SM PS if supported and in powersave, disable
+ *	SM PS when powersave is turned off. This is the default
+ *	mode for HT devices if they support SM PS.
+ * @NL80211_SMPS_OFF: SM PS turned off, i.e. all chains on
+ * @NL80211_SMPS_STATIC: static SM PS, i.e. using a single chain
+ * @NL80211_SMPS_DYNAMIC: dynamic SM PS, i.e. chains turned on
+ *	after, for example, rts/cts handshake
+ * @__NL80211_SMPS_NUM: internal
+ * @NL80211_SMPS_MAX: largest allowed smps value
+ */
+enum nl80211_smps_mode {
+	NL80211_SMPS_AUTOMATIC,
+	NL80211_SMPS_OFF,
+	NL80211_SMPS_STATIC,
+	NL80211_SMPS_DYNAMIC,
+
+	/* keep last */
+	__NL80211_SMPS_NUM,
+	NL80211_SMPS_MAX = __NL80211_SMPS_NUM - 1,
+};
+
 #endif /* __LINUX_NL80211_H */
--- wireless-testing.orig/net/wireless/nl80211.c	2009-11-29 11:33:01.000000000 +0100
+++ wireless-testing/net/wireless/nl80211.c	2009-11-29 11:34:11.000000000 +0100
@@ -141,6 +141,7 @@ static struct nla_policy nl80211_policy[
 	[NL80211_ATTR_4ADDR] = { .type = NLA_U8 },
 	[NL80211_ATTR_PMKID] = { .type = NLA_BINARY,
 				 .len = WLAN_PMKID_LEN },
+	[NL80211_ATTR_SMPS_MODE] = { .type = NLA_U32 },
 };
 
 /* policy for the attributes */
@@ -1052,6 +1053,26 @@ static int nl80211_set_interface(struct 
 		params.use_4addr = -1;
 	}
 
+	if (info->attrs[NL80211_ATTR_SMPS_MODE]) {
+		enum nl80211_smps_mode smps_mode;
+
+		smps_mode = nla_get_u32(info->attrs[NL80211_ATTR_SMPS_MODE]);
+
+		if (smps_mode > NL80211_SMPS_MAX) {
+			err = -EINVAL;
+			goto unlock;
+		}
+
+		if (!rdev->ops->set_smps) {
+			err = -EOPNOTSUPP;
+			goto unlock;
+		}
+
+		err = rdev->ops->set_smps(&rdev->wiphy, dev, smps_mode);
+		if (err)
+			goto unlock;
+	}
+
 	if (info->attrs[NL80211_ATTR_MNTR_FLAGS]) {
 		if (ntype != NL80211_IFTYPE_MONITOR) {
 			err = -EINVAL;
--- wireless-testing.orig/include/net/cfg80211.h	2009-11-29 11:33:01.000000000 +0100
+++ wireless-testing/include/net/cfg80211.h	2009-11-29 11:34:11.000000000 +0100
@@ -1115,7 +1115,10 @@ struct cfg80211_ops {
 				    const struct cfg80211_bitrate_mask *mask);
 
 	int	(*dump_survey)(struct wiphy *wiphy, struct net_device *netdev,
-			int idx, struct survey_info *info);
+			       int idx, struct survey_info *info);
+
+	int	(*set_smps)(struct wiphy *wiphy, struct net_device *netdev,
+			    enum nl80211_smps_mode smps_mode);
 
 	int	(*set_pmksa)(struct wiphy *wiphy, struct net_device *netdev,
 			     struct cfg80211_pmksa *pmksa);


