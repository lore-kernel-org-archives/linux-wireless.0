Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51814 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S938663AbcJZM0j (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Oct 2016 08:26:39 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: avraham.stern@intel.com, akarwar@marvell.com, j@w1.fi,
        yangzy@marvell.com, cluo@marvell.com, nishants@marvell.com,
        lihz@marvell.com, ilan.peer@intel.com
Subject: [RFC] cfg80211: support 4-way-handshake offload with PSK and 802.1X
Date: Wed, 26 Oct 2016 14:26:33 +0200
Message-Id: <1477484793-29427-1-git-send-email-johannes@sipsolutions.net> (sfid-20161026_152413_052228_E04CB903)
In-Reply-To: <1477483882.4059.34.camel@sipsolutions.net>
References: <1477483882.4059.34.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avraham Stern <avraham.stern@intel.com>

TODO:
 * add a separate capability flag? and explain how the offload
   is supposed to work in 802.1X, EAPOL-Key messages are going
   to be processed by the supplicant, but then the 4-way-HS is
   done by the device after getting the PMK in the PMKSA cache
   entry - explain that mechanism
 * does anyone still want EAP-LEAP 16-byte PMK?

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211.h    |  3 +++
 include/net/cfg80211.h       |  8 +++++++-
 include/uapi/linux/nl80211.h | 14 +++++++++++++-
 net/wireless/nl80211.c       | 15 +++++++++++++++
 4 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index a80516fd65c8..40206b2a6e6d 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -2326,6 +2326,9 @@ enum ieee80211_sa_query_action {
 
 #define WLAN_PMKID_LEN			16
 
+#define WLAN_PMK_LEN			32
+#define WLAN_PMK_LEN_SUITE_B_192	48
+
 #define WLAN_OUI_WFA			0x506f9a
 #define WLAN_OUI_TYPE_WFA_P2P		9
 #define WLAN_OUI_MICROSOFT		0x0050f2
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index d1ffbc3a8e55..3bb407c57177 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -615,6 +615,7 @@ struct survey_info {
  * @wep_keys: static WEP keys, if not NULL points to an array of
  *	CFG80211_MAX_WEP_KEYS WEP keys
  * @wep_tx_key: key index (0..3) of the default TX static WEP key
+ * @psk: PSK (for devices supporting 4-way-handshake offload, 32 bytes)
  */
 struct cfg80211_crypto_settings {
 	u32 wpa_versions;
@@ -628,6 +629,7 @@ struct cfg80211_crypto_settings {
 	bool control_port_no_encrypt;
 	struct key_params *wep_keys;
 	int wep_tx_key;
+	const u8 *psk;
 };
 
 /**
@@ -2064,11 +2066,15 @@ enum wiphy_params_flags {
  * caching.
  *
  * @bssid: The AP's BSSID.
- * @pmkid: The PMK material itself.
+ * @pmkid: The PMK identifier.
+ * @pmk: The PMK material itself.
+ * @pmk_len: The PMK length in bytes.
  */
 struct cfg80211_pmksa {
 	const u8 *bssid;
 	const u8 *pmkid;
+	const u8 *pmk;
+	u8 pmk_len;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 1362d24957b5..40b003cc07bd 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -371,7 +371,8 @@
  *	NL80211_CMD_GET_SURVEY and on the "scan" multicast group)
  *
  * @NL80211_CMD_SET_PMKSA: Add a PMKSA cache entry, using %NL80211_ATTR_MAC
- *	(for the BSSID) and %NL80211_ATTR_PMKID.
+ *	(for the BSSID) and %NL80211_ATTR_PMKID. Optionally, %NL80211_ATTR_PMK
+ *	can be used to specify the PMK.
  * @NL80211_CMD_DEL_PMKSA: Delete a PMKSA cache entry, using %NL80211_ATTR_MAC
  *	(for the BSSID) and %NL80211_ATTR_PMKID.
  * @NL80211_CMD_FLUSH_PMKSA: Flush all PMKSA cache entries.
@@ -1937,6 +1938,11 @@ enum nl80211_commands {
  * @NL80211_ATTR_NAN_MATCH: used to report a match. This is a nested attribute.
  *	See &enum nl80211_nan_match_attributes.
  *
+ * @NL80211_ATTR_PMK: PMK for offloaded 4-Way Handshake. Relevant with
+ *	%NL80211_CMD_CONNECT (for WPA/WPA2-PSK networks) when PSK is used, or
+ *	with %NL80211_CMD_SET_PMKSA when 802.1X authentication is used and for
+ *	PMKSA caching.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2336,6 +2342,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_NAN_FUNC,
 	NL80211_ATTR_NAN_MATCH,
 
+	NL80211_ATTR_PMK,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -4638,6 +4646,9 @@ enum nl80211_feature_flags {
  *	configuration (AP/mesh) with HT rates.
  * @NL80211_EXT_FEATURE_BEACON_RATE_VHT: Driver supports beacon rate
  *	configuration (AP/mesh) with VHT rates.
+ * @NL80211_EXT_FEATURE_4WAY_HANDSHAKE_OFFLOAD_STA: Device supports
+ *	doing 4-way handshake in station mode (PSK is passed as part
+ *	of the connect command).
  *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
@@ -4652,6 +4663,7 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_BEACON_RATE_LEGACY,
 	NL80211_EXT_FEATURE_BEACON_RATE_HT,
 	NL80211_EXT_FEATURE_BEACON_RATE_VHT,
+	NL80211_EXT_FEATURE_4WAY_HANDSHAKE_OFFLOAD_STA,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b0440de82171..6720c7bf3ed1 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -414,6 +414,7 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_NAN_MASTER_PREF] = { .type = NLA_U8 },
 	[NL80211_ATTR_NAN_DUAL] = { .type = NLA_U8 },
 	[NL80211_ATTR_NAN_FUNC] = { .type = NLA_NESTED },
+	[NL80211_ATTR_PMK] = { .len = WLAN_PMK_LEN },
 };
 
 /* policy for the key attributes */
@@ -7922,6 +7923,13 @@ static int nl80211_crypto_settings(struct cfg80211_registered_device *rdev,
 		memcpy(settings->akm_suites, data, len);
 	}
 
+	if (info->attrs[NL80211_ATTR_PMK]) {
+		if (!wiphy_ext_feature_isset(&rdev->wiphy,
+					     NL80211_EXT_FEATURE_4WAY_HANDSHAKE_OFFLOAD_STA))
+			return -EINVAL;
+		settings->psk = nla_data(info->attrs[NL80211_ATTR_PMK]);
+	}
+
 	return 0;
 }
 
@@ -8824,6 +8832,13 @@ static int nl80211_setdel_pmksa(struct sk_buff *skb, struct genl_info *info)
 
 	pmksa.pmkid = nla_data(info->attrs[NL80211_ATTR_PMKID]);
 	pmksa.bssid = nla_data(info->attrs[NL80211_ATTR_MAC]);
+	if (info->attrs[NL80211_ATTR_PMK]) {
+		pmksa.pmk = nla_data(info->attrs[NL80211_ATTR_PMK]);
+		pmksa.pmk_len = nla_len(info->attrs[NL80211_ATTR_PMK]);
+		if (pmksa.pmk_len != WLAN_PMK_LEN &&
+		    pmksa.pmk_len != WLAN_PMK_LEN_SUITE_B_192)
+			return -EINVAL;
+	}
 
 	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_STATION &&
 	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_CLIENT)
-- 
2.8.1
