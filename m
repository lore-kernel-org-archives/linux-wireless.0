Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:42775 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbaLRMvj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2014 07:51:39 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Gautam Kumar Shukla <gautams@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [RFC] cfg80211: Add feature flag for 4-way handshake offload
Date: Thu, 18 Dec 2014 13:51:35 +0100
Message-ID: <1418907095-10224-1-git-send-email-arend@broadcom.com> (sfid-20141218_135217_409584_A0CC5DE8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gautam Kumar Shukla <gautams@broadcom.com>

The new feature flag allows the driver to indicate that it can
offload the 4-way handshake for WPA/RSN-PSK. With the
wiphy::features flag being used up this patch adds a new
field wiphy::ext_features. Considering extensibility this
new field is declared as a byte array.

Signed-off-by: Gautam (Gautam Kumar) Shukla <gautams@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
Hi Johannes,

Here the proposed way to deal with new feature flags. Let
me know if this is suitable.

Regards,
Arend
---
 include/net/cfg80211.h       | 25 +++++++++++++++++++++++++
 include/uapi/linux/nl80211.h | 13 +++++++++++++
 net/wireless/nl80211.c       |  5 +++++
 net/wireless/util.c          | 20 ++++++++++++++++++++
 4 files changed, 63 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 670b9ed..8cb04da 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3013,6 +3013,8 @@ struct wiphy_vendor_command {
  * @regulatory_flags: wiphy regulatory flags, see
  *	&enum ieee80211_regulatory_flags
  * @features: features advertised to nl80211, see &enum nl80211_feature_flags.
+ * @ext_features: extended features advertised to nl80211, see
+ *	&enum nl80211_ext_feature_index.
  * @bss_priv_size: each BSS struct has private data allocated with it,
  *	this variable determines its size
  * @max_scan_ssids: maximum number of SSIDs the device can scan for in
@@ -3122,6 +3124,7 @@ struct wiphy {
 	u16 max_acl_mac_addrs;
 
 	u32 flags, regulatory_flags, features;
+	u8 ext_features[1];
 
 	u32 ap_sme_capa;
 
@@ -5049,6 +5052,28 @@ void cfg80211_stop_iface(struct wiphy *wiphy, struct wireless_dev *wdev,
  */
 void cfg80211_shutdown_all_interfaces(struct wiphy *wiphy);
 
+/**
+ * cfg80211_ext_feature_set - set the extended feature flag
+ *
+ * @wiphy: the wiphy to modify.
+ * @ftidx: extended feature bit index.
+ *
+ * The extended features are flagged in multiple bytes (see
+ * &struct wiphy.@ext_features)
+ */
+void cfg80211_ext_feature_set(struct wiphy *wiphy,
+			      enum nl80211_ext_feature_index ftidx);
+/**
+ * cfg80211_ext_feature_isset - check the extended feature flag
+ *
+ * @wiphy: the wiphy to modify.
+ * @ftidx: extended feature bit index.
+ *
+ * The extended features are flagged in multiple bytes (see
+ * &struct wiphy.@ext_features)
+ */
+bool cfg80211_ext_feature_isset(struct wiphy *wiphy,
+				enum nl80211_ext_feature_index ftidx);
 
 /* ethtool helper */
 void cfg80211_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info);
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index c0383e9..b4c4120 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1713,6 +1713,8 @@ enum nl80211_commands {
  *	obtained from it is coming from the device's wiphy and not the global
  *	cfg80211 regdomain.
  *
+ * @NL80211_ATTR_EXT_FEATURES: extended feature flags (u8 array)
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2072,6 +2074,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_WIPHY_SELF_MANAGED_REG,
 
+	NL80211_ATTR_EXT_FEATURES,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -4221,6 +4225,15 @@ enum nl80211_feature_flags {
 };
 
 /**
+ * enum nl80211_ext_feature_index - bit index of extended features.
+ *
+ * @NL80211_EXT_FEATURE_4WAY_HANDSHAKE: the device supports 4way handshake
+ */
+enum nl80211_ext_feature_index {
+	NL80211_EXT_FEATURE_4WAY_HANDSHAKE,
+};
+
+/**
  * enum nl80211_probe_resp_offload_support_attr - optional supported
  *	protocols for probe-response offloading by the driver/FW.
  *	To be used with the %NL80211_ATTR_PROBE_RESP_OFFLOAD attribute.
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 7029201..7c00577 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1603,6 +1603,11 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 		if (nla_put_u32(msg, NL80211_ATTR_FEATURE_FLAGS, features))
 			goto nla_put_failure;
 
+		if (nla_put(msg, NL80211_ATTR_EXT_FEATURES,
+			    sizeof(rdev->wiphy.ext_features),
+			    rdev->wiphy.ext_features))
+			goto nla_put_failure;
+
 		if (rdev->wiphy.ht_capa_mod_mask &&
 		    nla_put(msg, NL80211_ATTR_HT_CAPABILITY_MASK,
 			    sizeof(*rdev->wiphy.ht_capa_mod_mask),
diff --git a/net/wireless/util.c b/net/wireless/util.c
index d0ac795..af8d0dd 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1568,6 +1568,26 @@ int cfg80211_get_station(struct net_device *dev, const u8 *mac_addr,
 }
 EXPORT_SYMBOL(cfg80211_get_station);
 
+void cfg80211_ext_feature_set(struct wiphy *wiphy,
+			      enum nl80211_ext_feature_index ftidx)
+{
+	u8 *ft_byte;
+
+	ft_byte = &wiphy->ext_features[ftidx / 8];
+	*ft_byte |= BIT(ftidx % 8);
+}
+EXPORT_SYMBOL(cfg80211_ext_feature_set);
+
+bool cfg80211_ext_feature_isset(struct wiphy *wiphy,
+				enum nl80211_ext_feature_index ftidx)
+{
+	u8 ft_byte;
+
+	ft_byte = wiphy->ext_features[ftidx / 8];
+	return (ft_byte & BIT(ftidx % 8)) != 0;
+}
+EXPORT_SYMBOL(cfg80211_ext_feature_isset);
+
 /* See IEEE 802.1H for LLC/SNAP encapsulation/decapsulation */
 /* Ethernet-II snap header (RFC1042 for most EtherTypes) */
 const unsigned char rfc1042_header[] __aligned(2) =
-- 
1.9.1

