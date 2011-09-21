Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:6192 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab1IUPR0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 11:17:26 -0400
Date: Wed, 21 Sep 2011 18:14:56 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] cfg80211: Validate cipher suite against supported ciphers
Message-ID: <20110921151456.GA32043@jouni.qca.qualcomm.com> (sfid-20110921_171734_815954_DC0FF3E0)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of using a hardcoded list of cipher suites in nl80211.c, use a
shared function in util.c to verify that the driver advertises support
for the specified cipher. This provides more accurate validation of the
values and allows vendor-specific cipher suites to be added in drivers.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 net/wireless/core.h    |    1 +
 net/wireless/nl80211.c |   16 ++++------------
 net/wireless/util.c    |   16 ++++++++++------
 3 files changed, 15 insertions(+), 18 deletions(-)

(while this is independent of the previous patch, you may want to apply
this after the AKM validation changes to avoid any conflicts)


diff --git a/net/wireless/core.h b/net/wireless/core.h
index 796a4bd..cb87b8b 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -406,6 +406,7 @@ void cfg80211_sme_failed_assoc(struct wireless_dev *wdev);
 bool cfg80211_sme_failed_reassoc(struct wireless_dev *wdev);
 
 /* internal helpers */
+bool cfg80211_supported_cipher_suite(struct wiphy *wiphy, u32 cipher);
 int cfg80211_validate_key_settings(struct cfg80211_registered_device *rdev,
 				   struct key_params *params, int key_idx,
 				   bool pairwise, const u8 *mac_addr);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index fd4da99..b6288b1 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4126,16 +4126,6 @@ static bool nl80211_valid_wpa_versions(u32 wpa_versions)
 				  NL80211_WPA_VERSION_2));
 }
 
-static bool nl80211_valid_cipher_suite(u32 cipher)
-{
-	return cipher == WLAN_CIPHER_SUITE_WEP40 ||
-		cipher == WLAN_CIPHER_SUITE_WEP104 ||
-		cipher == WLAN_CIPHER_SUITE_TKIP ||
-		cipher == WLAN_CIPHER_SUITE_CCMP ||
-		cipher == WLAN_CIPHER_SUITE_AES_CMAC;
-}
-
-
 static int nl80211_authenticate(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
@@ -4268,7 +4258,8 @@ static int nl80211_crypto_settings(struct cfg80211_registered_device *rdev,
 		memcpy(settings->ciphers_pairwise, data, len);
 
 		for (i = 0; i < settings->n_ciphers_pairwise; i++)
-			if (!nl80211_valid_cipher_suite(
+			if (!cfg80211_supported_cipher_suite(
+					&rdev->wiphy,
 					settings->ciphers_pairwise[i]))
 				return -EINVAL;
 	}
@@ -4276,7 +4267,8 @@ static int nl80211_crypto_settings(struct cfg80211_registered_device *rdev,
 	if (info->attrs[NL80211_ATTR_CIPHER_SUITE_GROUP]) {
 		settings->cipher_group =
 			nla_get_u32(info->attrs[NL80211_ATTR_CIPHER_SUITE_GROUP]);
-		if (!nl80211_valid_cipher_suite(settings->cipher_group))
+		if (!cfg80211_supported_cipher_suite(&rdev->wiphy,
+						     settings->cipher_group))
 			return -EINVAL;
 	}
 
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 39dbf4a..6304ed6 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -151,12 +151,19 @@ void ieee80211_set_bitrate_flags(struct wiphy *wiphy)
 			set_mandatory_flags_band(wiphy->bands[band], band);
 }
 
+bool cfg80211_supported_cipher_suite(struct wiphy *wiphy, u32 cipher)
+{
+	int i;
+	for (i = 0; i < wiphy->n_cipher_suites; i++)
+		if (cipher == wiphy->cipher_suites[i])
+			return true;
+	return false;
+}
+
 int cfg80211_validate_key_settings(struct cfg80211_registered_device *rdev,
 				   struct key_params *params, int key_idx,
 				   bool pairwise, const u8 *mac_addr)
 {
-	int i;
-
 	if (key_idx > 5)
 		return -EINVAL;
 
@@ -226,10 +233,7 @@ int cfg80211_validate_key_settings(struct cfg80211_registered_device *rdev,
 		}
 	}
 
-	for (i = 0; i < rdev->wiphy.n_cipher_suites; i++)
-		if (params->cipher == rdev->wiphy.cipher_suites[i])
-			break;
-	if (i == rdev->wiphy.n_cipher_suites)
+	if (!cfg80211_supported_cipher_suite(&rdev->wiphy, params->cipher))
 		return -EINVAL;
 
 	return 0;
-- 
1.7.4.1


-- 
Jouni Malinen                                            PGP id EFC895FA
