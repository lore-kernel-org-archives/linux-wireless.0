Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:63152 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaLWPz0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 10:55:26 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Gautam Kumar Shukla <gautams@broadcom.com>,
	Avinash Patil <patila@marvell.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH] cfg80211: add extensible feature flag attribute
Date: Tue, 23 Dec 2014 16:55:19 +0100
Message-ID: <1419350119-29166-1-git-send-email-arend@broadcom.com> (sfid-20141223_165529_276590_13FD23C1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gautam Kumar Shukla <gautams@broadcom.com>

With the wiphy::features flag being used up this patch adds a
new field wiphy::ext_features. Considering extensibility this
new field is declared as a byte array. This extensible flag is
exposed to user-space by NL80211_ATTR_EXT_FEATURES.

Cc: Avinash Patil <patila@marvell.com>
Signed-off-by: Gautam (Gautam Kumar) Shukla <gautams@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 include/net/cfg80211.h       | 39 +++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/nl80211.h | 22 ++++++++++++++++++++++
 net/wireless/nl80211.c       |  5 +++++
 3 files changed, 66 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index bd672ea..f38645f 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3016,6 +3016,8 @@ struct wiphy_vendor_command {
  * @regulatory_flags: wiphy regulatory flags, see
  *	&enum ieee80211_regulatory_flags
  * @features: features advertised to nl80211, see &enum nl80211_feature_flags.
+ * @ext_features: extended features advertised to nl80211, see
+ *	&enum nl80211_ext_feature_index.
  * @bss_priv_size: each BSS struct has private data allocated with it,
  *	this variable determines its size
  * @max_scan_ssids: maximum number of SSIDs the device can scan for in
@@ -3125,6 +3127,7 @@ struct wiphy {
 	u16 max_acl_mac_addrs;
 
 	u32 flags, regulatory_flags, features;
+	u8 ext_features[DIV_ROUND_UP(NUM_NL80211_EXT_FEATURES, 8)];
 
 	u32 ap_sme_capa;
 
@@ -5052,6 +5055,42 @@ void cfg80211_stop_iface(struct wiphy *wiphy, struct wireless_dev *wdev,
  */
 void cfg80211_shutdown_all_interfaces(struct wiphy *wiphy);
 
+/**
+ * wiphy_ext_feature_set - set the extended feature flag
+ *
+ * @wiphy: the wiphy to modify.
+ * @ftidx: extended feature bit index.
+ *
+ * The extended features are flagged in multiple bytes (see
+ * &struct wiphy.@ext_features)
+ */
+static inline void wiphy_ext_feature_set(struct wiphy *wiphy,
+					 enum nl80211_ext_feature_index ftidx)
+{
+	u8 *ft_byte;
+
+	ft_byte = &wiphy->ext_features[ftidx / 8];
+	*ft_byte |= BIT(ftidx % 8);
+}
+
+/**
+ * wiphy_ext_feature_isset - check the extended feature flag
+ *
+ * @wiphy: the wiphy to modify.
+ * @ftidx: extended feature bit index.
+ *
+ * The extended features are flagged in multiple bytes (see
+ * &struct wiphy.@ext_features)
+ */
+static inline bool
+wiphy_ext_feature_isset(struct wiphy *wiphy,
+			enum nl80211_ext_feature_index ftidx)
+{
+	u8 ft_byte;
+
+	ft_byte = wiphy->ext_features[ftidx / 8];
+	return (ft_byte & BIT(ftidx % 8)) != 0;
+}
 
 /* ethtool helper */
 void cfg80211_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info);
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 18cb0aa..0fe36b4 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1713,6 +1713,13 @@ enum nl80211_commands {
  *	obtained from it is coming from the device's wiphy and not the global
  *	cfg80211 regdomain.
  *
+ * @NL80211_ATTR_EXT_FEATURES: extended feature flags contained in a byte
+ *	array. The feature flags are identified by their bit index (see &enum
+ *	nl80211_ext_feature_index). The bit index is ordered starting at the
+ *	least-significant bit of the first byte in the array, ie. bit index 0
+ *	is located at bit 0 of byte 0. bit index 25 would be located at bit 1
+ *	of byte 3 (u8 array).
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2072,6 +2079,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_WIPHY_SELF_MANAGED_REG,
 
+	NL80211_ATTR_EXT_FEATURES,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -4221,6 +4230,19 @@ enum nl80211_feature_flags {
 };
 
 /**
+ * enum nl80211_ext_feature_index - bit index of extended features.
+ *
+ * @NUM_NL80211_EXT_FEATURES: number of extended features.
+ * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
+ */
+enum nl80211_ext_feature_index {
+
+	/* add new features before the definition below */
+	NUM_NL80211_EXT_FEATURES,
+	MAX_NL80211_EXT_FEATURES = NUM_NL80211_EXT_FEATURES - 1
+};
+
+/**
  * enum nl80211_probe_resp_offload_support_attr - optional supported
  *	protocols for probe-response offloading by the driver/FW.
  *	To be used with the %NL80211_ATTR_PROBE_RESP_OFFLOAD attribute.
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 7029201..689e1a8 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1706,6 +1706,11 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 		    nla_put_flag(msg, NL80211_ATTR_WIPHY_SELF_MANAGED_REG))
 			goto nla_put_failure;
 
+		if (nla_put(msg, NL80211_ATTR_EXT_FEATURES,
+			    sizeof(rdev->wiphy.ext_features),
+			    rdev->wiphy.ext_features))
+			goto nla_put_failure;
+
 		/* done */
 		state->split_start = 0;
 		break;
-- 
1.9.1

