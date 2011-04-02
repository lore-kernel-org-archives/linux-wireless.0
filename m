Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:39625 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab1DBBcw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 21:32:52 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/2] mwifiex: remove redundant encryption_mode mapping
Date: Fri,  1 Apr 2011 18:36:47 -0700
Message-Id: <1301708207-16265-2-git-send-email-bzhao@marvell.com>
In-Reply-To: <1301708207-16265-1-git-send-email-bzhao@marvell.com>
References: <1301708207-16265-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yogesh Ashok Powar <yogeshp@marvell.com>

remove MWIFIEX_ENCRYPTION_MODE_ and use WLAN_CIPHER_SUITE_
macros directly

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c  |   76 ++++--------------------------
 drivers/net/wireless/mwifiex/init.c      |    2 +-
 drivers/net/wireless/mwifiex/ioctl.h     |    8 ---
 drivers/net/wireless/mwifiex/join.c      |    2 +-
 drivers/net/wireless/mwifiex/scan.c      |   12 ++--
 drivers/net/wireless/mwifiex/sta_event.c |    2 +-
 6 files changed, 19 insertions(+), 83 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 4ac4f5a..ec0895f 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -90,8 +90,8 @@ mwifiex_is_alg_wep(u32 cipher)
 	int alg = 0;
 
 	switch (cipher) {
-	case MWIFIEX_ENCRYPTION_MODE_WEP40:
-	case MWIFIEX_ENCRYPTION_MODE_WEP104:
+	case WLAN_CIPHER_SUITE_WEP40:
+	case WLAN_CIPHER_SUITE_WEP104:
 		alg = 1;
 		break;
 	default:
@@ -102,55 +102,6 @@ mwifiex_is_alg_wep(u32 cipher)
 }
 
 /*
- * This function maps the given cipher type into driver specific type.
- *
- * It also sets a flag to indicate whether WPA is enabled or not.
- *
- * The mapping table is -
- *      Input cipher                Driver cipher type              WPA enabled?
- *      ------------                ------------------              ------------
- *      IW_AUTH_CIPHER_NONE         MWIFIEX_ENCRYPTION_MODE_NONE    No
- *      WLAN_CIPHER_SUITE_WEP40     MWIFIEX_ENCRYPTION_MODE_WEP40   No
- *      WLAN_CIPHER_SUITE_WEP104    MWIFIEX_ENCRYPTION_MODE_WEP104  No
- *      WLAN_CIPHER_SUITE_TKIP      MWIFIEX_ENCRYPTION_MODE_TKIP    Yes
- *      WLAN_CIPHER_SUITE_CCMP      MWIFIEX_ENCRYPTION_MODE_CCMP    Yes
- *      Others                      -1                              No
- */
-static int
-mwifiex_get_mwifiex_cipher(u32 cipher, int *wpa_enabled)
-{
-	int encrypt_mode;
-
-	if (wpa_enabled)
-		*wpa_enabled = 0;
-	switch (cipher) {
-	case IW_AUTH_CIPHER_NONE:
-		encrypt_mode = MWIFIEX_ENCRYPTION_MODE_NONE;
-		break;
-	case WLAN_CIPHER_SUITE_WEP40:
-		encrypt_mode = MWIFIEX_ENCRYPTION_MODE_WEP40;
-		break;
-	case WLAN_CIPHER_SUITE_WEP104:
-		encrypt_mode = MWIFIEX_ENCRYPTION_MODE_WEP104;
-		break;
-	case WLAN_CIPHER_SUITE_TKIP:
-		encrypt_mode = MWIFIEX_ENCRYPTION_MODE_TKIP;
-		if (wpa_enabled)
-			*wpa_enabled = 1;
-		break;
-	case WLAN_CIPHER_SUITE_CCMP:
-		encrypt_mode = MWIFIEX_ENCRYPTION_MODE_CCMP;
-		if (wpa_enabled)
-			*wpa_enabled = 1;
-		break;
-	default:
-		encrypt_mode = -1;
-	}
-
-	return encrypt_mode;
-}
-
-/*
  * This function retrieves the private structure from kernel wiphy structure.
  */
 static void *mwifiex_cfg80211_get_priv(struct wiphy *wiphy)
@@ -252,13 +203,9 @@ mwifiex_cfg80211_add_key(struct wiphy *wiphy, struct net_device *netdev,
 {
 	struct mwifiex_private *priv = mwifiex_cfg80211_get_priv(wiphy);
 	int ret = 0;
-	int encrypt_mode;
-
-	encrypt_mode = mwifiex_get_mwifiex_cipher(params->cipher, NULL);
 
-	if (encrypt_mode != -1)
-		ret = mwifiex_set_encode(priv, params->key, params->key_len,
-						key_index, 0);
+	ret = mwifiex_set_encode(priv, params->key, params->key_len,
+								key_index, 0);
 
 	wiphy_dbg(wiphy, "info: crypto keys added\n");
 
@@ -1019,7 +966,7 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 	struct mwifiex_802_11_ssid req_ssid;
 	struct mwifiex_ssid_bssid ssid_bssid;
 	int ret = 0;
-	int auth_type = 0, pairwise_encrypt_mode = 0, wpa_enabled = 0;
+	int auth_type = 0, pairwise_encrypt_mode = 0;
 	int group_encrypt_mode = 0;
 	int alg_is_wep = 0;
 
@@ -1052,13 +999,13 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 		/* "privacy" is set only for ad-hoc mode */
 		if (privacy) {
 			/*
-			 * Keep MWIFIEX_ENCRYPTION_MODE_WEP104 for now so that
+			 * Keep WLAN_CIPHER_SUITE_WEP104 for now so that
 			 * the firmware can find a matching network from the
 			 * scan. The cfg80211 does not give us the encryption
 			 * mode at this stage so just setting it to WEP here.
 			 */
 			priv->sec_info.encryption_mode =
-					MWIFIEX_ENCRYPTION_MODE_WEP104;
+					WLAN_CIPHER_SUITE_WEP104;
 			priv->sec_info.authentication_mode =
 					NL80211_AUTHTYPE_OPEN_SYSTEM;
 		}
@@ -1074,16 +1021,13 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 		auth_type = NL80211_AUTHTYPE_SHARED_KEY;
 
 	if (sme->crypto.n_ciphers_pairwise) {
-		pairwise_encrypt_mode = mwifiex_get_mwifiex_cipher(sme->crypto.
-					ciphers_pairwise[0], &wpa_enabled);
-		priv->sec_info.encryption_mode = pairwise_encrypt_mode;
+		priv->sec_info.encryption_mode =
+						sme->crypto.ciphers_pairwise[0];
 		priv->sec_info.authentication_mode = auth_type;
 	}
 
 	if (sme->crypto.cipher_group) {
-		group_encrypt_mode = mwifiex_get_mwifiex_cipher(sme->crypto.
-						   cipher_group, &wpa_enabled);
-		priv->sec_info.encryption_mode = group_encrypt_mode;
+		priv->sec_info.encryption_mode = sme->crypto.cipher_group;
 		priv->sec_info.authentication_mode = auth_type;
 	}
 	if (sme->ie)
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 43ea87d..8189862 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -86,7 +86,7 @@ static int mwifiex_init_priv(struct mwifiex_private *priv)
 
 	priv->sec_info.wep_status = MWIFIEX_802_11_WEP_DISABLED;
 	priv->sec_info.authentication_mode = NL80211_AUTHTYPE_OPEN_SYSTEM;
-	priv->sec_info.encryption_mode = MWIFIEX_ENCRYPTION_MODE_NONE;
+	priv->sec_info.encryption_mode = 0;
 	for (i = 0; i < ARRAY_SIZE(priv->wep_key); i++)
 		memset(&priv->wep_key[i], 0, sizeof(struct mwifiex_wep_key));
 	priv->wep_key_curr_index = 0;
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index d01160a..703a6d1 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -267,14 +267,6 @@ struct mwifiex_debug_info {
 	u8 event_received;
 };
 
-enum {
-	MWIFIEX_ENCRYPTION_MODE_NONE = 0,
-	MWIFIEX_ENCRYPTION_MODE_WEP40 = 1,
-	MWIFIEX_ENCRYPTION_MODE_TKIP = 2,
-	MWIFIEX_ENCRYPTION_MODE_CCMP = 3,
-	MWIFIEX_ENCRYPTION_MODE_WEP104 = 4,
-};
-
 #define MWIFIEX_KEY_INDEX_UNICAST	0x40000000
 #define MWIFIEX_MAX_KEY_LENGTH		32
 #define WAPI_RXPN_LEN			16
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 8a1eb2a..7a9e0b5 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -869,7 +869,7 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 	tmp_cap |= WLAN_CAPABILITY_IBSS;
 
 	/* Set up privacy in bss_desc */
-	if (priv->sec_info.encryption_mode != MWIFIEX_ENCRYPTION_MODE_NONE) {
+	if (priv->sec_info.encryption_mode) {
 		/* Ad-Hoc capability privacy on */
 		dev_dbg(adapter->dev,
 			"info: ADHOC_S_CMD: wep_status set privacy to WEP\n");
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 64ed60a..6bb52d0 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -273,8 +273,8 @@ mwifiex_is_network_compatible_for_no_sec(struct mwifiex_private *priv,
 	    && ((!bss_desc->bcn_rsn_ie) ||
 		((*(bss_desc->bcn_rsn_ie)).ieee_hdr.element_id !=
 	    WLAN_EID_RSN))
-	    && priv->sec_info.encryption_mode ==
-	    MWIFIEX_ENCRYPTION_MODE_NONE && !bss_desc->privacy) {
+	    && !priv->sec_info.encryption_mode
+	    && !bss_desc->privacy) {
 		return true;
 	}
 	return false;
@@ -386,8 +386,8 @@ mwifiex_is_network_compatible_for_adhoc_aes(struct mwifiex_private *priv,
 		   element_id != WLAN_EID_WPA))
 	    && ((!bss_desc->bcn_rsn_ie) || ((*(bss_desc->bcn_rsn_ie)).ieee_hdr.
 		   element_id != WLAN_EID_RSN))
-	    && priv->sec_info.encryption_mode ==
-	    MWIFIEX_ENCRYPTION_MODE_NONE && bss_desc->privacy) {
+	    && !priv->sec_info.encryption_mode
+	    && bss_desc->privacy) {
 		return true;
 	}
 	return false;
@@ -408,8 +408,8 @@ mwifiex_is_network_compatible_for_dynamic_wep(struct mwifiex_private *priv,
 		   element_id != WLAN_EID_WPA))
 	    && ((!bss_desc->bcn_rsn_ie) || ((*(bss_desc->bcn_rsn_ie)).ieee_hdr.
 		   element_id != WLAN_EID_RSN))
-	    && priv->sec_info.encryption_mode !=
-	    MWIFIEX_ENCRYPTION_MODE_NONE && bss_desc->privacy) {
+	    && priv->sec_info.encryption_mode
+	    && bss_desc->privacy) {
 		dev_dbg(priv->adapter->dev, "info: %s: dynamic "
 			"WEP: index=%d wpa_ie=%#x wpa2_ie=%#x "
 			"EncMode=%#x privacy=%#x\n",
diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index 0187185..936d7c1 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -76,7 +76,7 @@ mwifiex_reset_connect_state(struct mwifiex_private *priv)
 	priv->wapi_ie_len = 0;
 	priv->sec_info.wapi_key_on = false;
 
-	priv->sec_info.encryption_mode = MWIFIEX_ENCRYPTION_MODE_NONE;
+	priv->sec_info.encryption_mode = 0;
 
 	/* Enable auto data rate */
 	priv->is_data_rate_auto = true;
-- 
1.7.0.2

