Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35340 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752697AbdESHXt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 May 2017 03:23:49 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: j@w1.fi, arend.vanspriel@broadcom.com,
        Avraham Stern <avraham.stern@intel.com>
Subject: [RFC] nl80211/cfg80211: allow setting multiple group cipher suites
Date: Fri, 19 May 2017 09:23:39 +0200
Message-Id: <20170519072339.11544-1-johannes@sipsolutions.net> (sfid-20170519_092410_727976_E4F4DC28)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avraham Stern <avraham.stern@intel.com>

For drivers with SME offload, allow setting multiple group cipher
suites so that userspace can configure all the permissible cipher
suites allowing the driver to connect to a network that supports
either of the configured group ciphers (similar to the way that
multiple pairwise cipher suites may be configured).

Also clean up the documentation a bit that was listing some things
twice.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
---
 include/net/cfg80211.h       |  6 ++++--
 include/uapi/linux/nl80211.h | 21 +++++++++------------
 net/mac80211/util.c          |  8 +++++---
 net/wireless/nl80211.c       | 39 ++++++++++++++++++++++++++++-----------
 net/wireless/sme.c           |  6 ++++--
 net/wireless/wext-compat.c   | 13 +++++++------
 6 files changed, 57 insertions(+), 36 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index b083e6cbae8c..06e4d6e2c5f6 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -633,7 +633,8 @@ struct survey_info {
  * struct cfg80211_crypto_settings - Crypto settings
  * @wpa_versions: indicates which, if any, WPA versions are enabled
  *	(from enum nl80211_wpa_versions)
- * @cipher_group: group key cipher suite (or 0 if unset)
+ * @n_ciphers_group: number of supported group ciphers
+ * @ciphers_group: group key cipher suites
  * @n_ciphers_pairwise: number of AP supported unicast ciphers
  * @ciphers_pairwise: unicast key cipher suites
  * @n_akm_suites: number of AKM suites
@@ -652,7 +653,8 @@ struct survey_info {
  */
 struct cfg80211_crypto_settings {
 	u32 wpa_versions;
-	u32 cipher_group;
+	int n_ciphers_group;
+	u32 ciphers_group[NL80211_MAX_NR_CIPHER_SUITES];
 	int n_ciphers_pairwise;
 	u32 ciphers_pairwise[NL80211_MAX_NR_CIPHER_SUITES];
 	int n_akm_suites;
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index b8c44b98f12d..2ba019ecb847 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1237,10 +1237,6 @@ enum nl80211_commands {
  * @NL80211_ATTR_KEY_DEFAULT: Flag attribute indicating the key is default key
  * @NL80211_ATTR_KEY_DEFAULT_MGMT: Flag attribute indicating the key is the
  *	default management key
- * @NL80211_ATTR_CIPHER_SUITES_PAIRWISE: For crypto settings for connect or
- *	other commands, indicates which pairwise cipher suites are used
- * @NL80211_ATTR_CIPHER_SUITE_GROUP: For crypto settings for connect or
- *	other commands, indicates which group cipher suite is used
  *
  * @NL80211_ATTR_BEACON_INTERVAL: beacon interval in TU
  * @NL80211_ATTR_DTIM_PERIOD: DTIM period for beaconing
@@ -1402,12 +1398,12 @@ enum nl80211_commands {
  *	that protected APs should be used. This is also used with NEW_BEACON to
  *	indicate that the BSS is to use protection.
  *
- * @NL80211_ATTR_CIPHERS_PAIRWISE: Used with CONNECT, ASSOCIATE, and NEW_BEACON
- *	to indicate which unicast key ciphers will be used with the connection
- *	(an array of u32).
- * @NL80211_ATTR_CIPHER_GROUP: Used with CONNECT, ASSOCIATE, and NEW_BEACON to
- *	indicate which group key cipher will be used with the connection (a
- *	u32).
+ * @NL80211_ATTR_CIPHER_SUITES_PAIRWISE: Used with CONNECT, ASSOCIATE, and
+ *	NEW_BEACON to indicate which unicast key ciphers will be used with
+ *	the connection (an array of u32).
+ * @NL80211_ATTR_CIPHER_SUITES_GROUP: Used with CONNECT, ASSOCIATE, and
+ *	NEW_BEACON to indicate which group key ciphers will be used with the
+ *	connection (an array of u32).
  * @NL80211_ATTR_WPA_VERSIONS: Used with CONNECT, ASSOCIATE, and NEW_BEACON to
  *	indicate which WPA version(s) the AP we want to associate with is using
  *	(a u32 with flags from &enum nl80211_wpa_versions).
@@ -2205,7 +2201,7 @@ enum nl80211_attrs {
 	NL80211_ATTR_STATUS_CODE,
 
 	NL80211_ATTR_CIPHER_SUITES_PAIRWISE,
-	NL80211_ATTR_CIPHER_SUITE_GROUP,
+	NL80211_ATTR_CIPHER_SUITES_GROUP,
 	NL80211_ATTR_WPA_VERSIONS,
 	NL80211_ATTR_AKM_SUITES,
 
@@ -2542,7 +2538,8 @@ enum nl80211_attrs {
 #define NL80211_ATTR_AUTH_TYPE NL80211_ATTR_AUTH_TYPE
 #define NL80211_ATTR_REASON_CODE NL80211_ATTR_REASON_CODE
 #define NL80211_ATTR_CIPHER_SUITES_PAIRWISE NL80211_ATTR_CIPHER_SUITES_PAIRWISE
-#define NL80211_ATTR_CIPHER_SUITE_GROUP NL80211_ATTR_CIPHER_SUITE_GROUP
+#define NL80211_ATTR_CIPHER_SUITE_GROUP NL80211_ATTR_CIPHER_SUITES_GROUP
+#define NL80211_ATTR_CIPHER_SUITES_GROUP NL80211_ATTR_CIPHER_SUITES_GROUP
 #define NL80211_ATTR_WPA_VERSIONS NL80211_ATTR_WPA_VERSIONS
 #define NL80211_ATTR_AKM_SUITES NL80211_ATTR_AKM_SUITES
 #define NL80211_ATTR_KEY NL80211_ATTR_KEY
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index ac9ac6c35594..542d1e828525 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -3087,9 +3087,11 @@ int ieee80211_cs_headroom(struct ieee80211_local *local,
 			headroom = cs->hdr_len;
 	}
 
-	cs = ieee80211_cs_get(local, crypto->cipher_group, iftype);
-	if (cs && headroom < cs->hdr_len)
-		headroom = cs->hdr_len;
+	for (i = 0; i < crypto->n_ciphers_group; i++) {
+		cs = ieee80211_cs_get(local, crypto->ciphers_group[i], iftype);
+		if (cs && headroom < cs->hdr_len)
+			headroom = cs->hdr_len;
+	}
 
 	return headroom;
 }
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c3bc9da30cff..03b45a1df17b 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -30,7 +30,8 @@
 static int nl80211_crypto_settings(struct cfg80211_registered_device *rdev,
 				   struct genl_info *info,
 				   struct cfg80211_crypto_settings *settings,
-				   int cipher_limit);
+				   int pairwise_cipher_limit,
+				   int group_cipher_limit);
 
 /* the netlink family */
 static struct genl_family nl80211_fam;
@@ -287,7 +288,6 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_CONTROL_PORT_ETHERTYPE] = { .type = NLA_U16 },
 	[NL80211_ATTR_CONTROL_PORT_NO_ENCRYPT] = { .type = NLA_FLAG },
 	[NL80211_ATTR_PRIVACY] = { .type = NLA_FLAG },
-	[NL80211_ATTR_CIPHER_SUITE_GROUP] = { .type = NLA_U32 },
 	[NL80211_ATTR_WPA_VERSIONS] = { .type = NLA_U32 },
 	[NL80211_ATTR_PID] = { .type = NLA_U32 },
 	[NL80211_ATTR_4ADDR] = { .type = NLA_U8 },
@@ -3957,7 +3957,7 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 		params.auth_type = NL80211_AUTHTYPE_AUTOMATIC;
 
 	err = nl80211_crypto_settings(rdev, info, &params.crypto,
-				      NL80211_MAX_NR_CIPHER_SUITES);
+				      NL80211_MAX_NR_CIPHER_SUITES, 1);
 	if (err)
 		return err;
 
@@ -8081,7 +8081,8 @@ static int nl80211_authenticate(struct sk_buff *skb, struct genl_info *info)
 static int nl80211_crypto_settings(struct cfg80211_registered_device *rdev,
 				   struct genl_info *info,
 				   struct cfg80211_crypto_settings *settings,
-				   int cipher_limit)
+				   int pairwise_cipher_limit,
+				   int group_cipher_limit)
 {
 	memset(settings, 0, sizeof(*settings));
 
@@ -8112,7 +8113,7 @@ static int nl80211_crypto_settings(struct cfg80211_registered_device *rdev,
 		if (len % sizeof(u32))
 			return -EINVAL;
 
-		if (settings->n_ciphers_pairwise > cipher_limit)
+		if (settings->n_ciphers_pairwise > pairwise_cipher_limit)
 			return -EINVAL;
 
 		memcpy(settings->ciphers_pairwise, data, len);
@@ -8124,12 +8125,27 @@ static int nl80211_crypto_settings(struct cfg80211_registered_device *rdev,
 				return -EINVAL;
 	}
 
-	if (info->attrs[NL80211_ATTR_CIPHER_SUITE_GROUP]) {
-		settings->cipher_group =
-			nla_get_u32(info->attrs[NL80211_ATTR_CIPHER_SUITE_GROUP]);
-		if (!cfg80211_supported_cipher_suite(&rdev->wiphy,
-						     settings->cipher_group))
+	if (info->attrs[NL80211_ATTR_CIPHER_SUITES_GROUP]) {
+		void *data;
+		int len, i;
+
+		data = nla_data(info->attrs[NL80211_ATTR_CIPHER_SUITES_GROUP]);
+		len = nla_len(info->attrs[NL80211_ATTR_CIPHER_SUITES_GROUP]);
+		settings->n_ciphers_group = len / sizeof(u32);
+
+		if (len % sizeof(u32))
 			return -EINVAL;
+
+		if (settings->n_ciphers_group > group_cipher_limit)
+			return -EINVAL;
+
+		memcpy(settings->ciphers_group, data, len);
+
+		for (i = 0; i < settings->n_ciphers_group; i++)
+			if (!cfg80211_supported_cipher_suite(
+					&rdev->wiphy,
+					settings->ciphers_group[i]))
+				return -EINVAL;
 	}
 
 	if (info->attrs[NL80211_ATTR_WPA_VERSIONS]) {
@@ -8261,7 +8277,7 @@ static int nl80211_associate(struct sk_buff *skb, struct genl_info *info)
 			nla_data(info->attrs[NL80211_ATTR_FILS_NONCES]);
 	}
 
-	err = nl80211_crypto_settings(rdev, info, &req.crypto, 1);
+	err = nl80211_crypto_settings(rdev, info, &req.crypto, 1, 1);
 	if (!err) {
 		wdev_lock(dev->ieee80211_ptr);
 
@@ -8861,6 +8877,7 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
 	connect.privacy = info->attrs[NL80211_ATTR_PRIVACY];
 
 	err = nl80211_crypto_settings(rdev, info, &connect.crypto,
+				      NL80211_MAX_NR_CIPHER_SUITES,
 				      NL80211_MAX_NR_CIPHER_SUITES);
 	if (err)
 		return err;
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 532a0007ce82..12bd3f168e96 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -1087,8 +1087,10 @@ int cfg80211_connect(struct cfg80211_registered_device *rdev,
 			 * If ciphers are not set (e.g. when going through
 			 * iwconfig), we have to set them appropriately here.
 			 */
-			if (connect->crypto.cipher_group == 0)
-				connect->crypto.cipher_group = cipher;
+			if (connect->crypto.n_ciphers_group == 0) {
+				connect->crypto.n_ciphers_group = 1;
+				connect->crypto.ciphers_group[0] = cipher;
+			}
 
 			if (connect->crypto.n_ciphers_pairwise == 0) {
 				connect->crypto.n_ciphers_pairwise = 1;
diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index 5d4a02c7979b..5a3d50822cb6 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -967,25 +967,26 @@ static int cfg80211_set_wpa_version(struct wireless_dev *wdev, u32 wpa_versions)
 static int cfg80211_set_cipher_group(struct wireless_dev *wdev, u32 cipher)
 {
 	if (cipher & IW_AUTH_CIPHER_WEP40)
-		wdev->wext.connect.crypto.cipher_group =
+		wdev->wext.connect.crypto.ciphers_group[0] =
 			WLAN_CIPHER_SUITE_WEP40;
 	else if (cipher & IW_AUTH_CIPHER_WEP104)
-		wdev->wext.connect.crypto.cipher_group =
+		wdev->wext.connect.crypto.ciphers_group[0] =
 			WLAN_CIPHER_SUITE_WEP104;
 	else if (cipher & IW_AUTH_CIPHER_TKIP)
-		wdev->wext.connect.crypto.cipher_group =
+		wdev->wext.connect.crypto.ciphers_group[0] =
 			WLAN_CIPHER_SUITE_TKIP;
 	else if (cipher & IW_AUTH_CIPHER_CCMP)
-		wdev->wext.connect.crypto.cipher_group =
+		wdev->wext.connect.crypto.ciphers_group[0] =
 			WLAN_CIPHER_SUITE_CCMP;
 	else if (cipher & IW_AUTH_CIPHER_AES_CMAC)
-		wdev->wext.connect.crypto.cipher_group =
+		wdev->wext.connect.crypto.ciphers_group[0] =
 			WLAN_CIPHER_SUITE_AES_CMAC;
 	else if (cipher & IW_AUTH_CIPHER_NONE)
-		wdev->wext.connect.crypto.cipher_group = 0;
+		wdev->wext.connect.crypto.ciphers_group[0] = 0;
 	else
 		return -EINVAL;
 
+	wdev->wext.connect.crypto.n_ciphers_group = 1;
 	return 0;
 }
 
-- 
2.11.0
