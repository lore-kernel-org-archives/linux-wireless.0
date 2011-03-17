Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:51378 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755816Ab1CQV5F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2011 17:57:05 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/2] mwifiex: cleanup cipher suite validation check
Date: Thu, 17 Mar 2011 15:00:24 -0700
Message-Id: <1300399225-13066-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

The cipher suite validation is required only if the function
is called in add_key context. So we remove this cipher suite
check in mwifiex_set_encode() and adds similar check in
add_key handler.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c  |   46 +++++++++++-------------------
 drivers/net/wireless/mwifiex/main.h      |    2 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c |   22 ++------------
 3 files changed, 21 insertions(+), 49 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index fe03baa..e28f1c7 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -120,7 +120,9 @@ static int
 mwifiex_get_mwifiex_cipher(u32 cipher, int *wpa_enabled)
 {
 	int encrypt_mode;
-	*wpa_enabled = 0;
+
+	if (wpa_enabled)
+		*wpa_enabled = 0;
 	switch (cipher) {
 	case IW_AUTH_CIPHER_NONE:
 		encrypt_mode = MWIFIEX_ENCRYPTION_MODE_NONE;
@@ -133,11 +135,13 @@ mwifiex_get_mwifiex_cipher(u32 cipher, int *wpa_enabled)
 		break;
 	case WLAN_CIPHER_SUITE_TKIP:
 		encrypt_mode = MWIFIEX_ENCRYPTION_MODE_TKIP;
-		*wpa_enabled = 1;
+		if (wpa_enabled)
+			*wpa_enabled = 1;
 		break;
 	case WLAN_CIPHER_SUITE_CCMP:
 		encrypt_mode = MWIFIEX_ENCRYPTION_MODE_CCMP;
-		*wpa_enabled = 1;
+		if (wpa_enabled)
+			*wpa_enabled = 1;
 		break;
 	default:
 		encrypt_mode = -1;
@@ -164,7 +168,7 @@ mwifiex_cfg80211_del_key(struct wiphy *wiphy, struct net_device *netdev,
 	struct mwifiex_private *priv = mwifiex_cfg80211_get_priv(wiphy);
 	int ret = 0;
 
-	ret = mwifiex_set_encode(priv, 0, NULL, 0, key_index, 1);
+	ret = mwifiex_set_encode(priv, NULL, 0, key_index, 1);
 	if (ret) {
 		wiphy_err(wiphy, "deleting the crypto keys\n");
 		return -EFAULT;
@@ -234,9 +238,13 @@ mwifiex_cfg80211_add_key(struct wiphy *wiphy, struct net_device *netdev,
 {
 	struct mwifiex_private *priv = mwifiex_cfg80211_get_priv(wiphy);
 	int ret = 0;
+	int encrypt_mode;
 
-	ret = mwifiex_set_encode(priv, params->cipher, params->key,
-				 params->key_len, key_index, 0);
+	encrypt_mode = mwifiex_get_mwifiex_cipher(params->cipher, NULL);
+
+	if (encrypt_mode != -1)
+		ret = mwifiex_set_encode(priv, params->key, params->key_len,
+						key_index, 0);
 
 	wiphy_dbg(wiphy, "info: crypto keys added\n");
 
@@ -795,26 +803,6 @@ mwifiex_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *dev,
 }
 
 /*
- * This function is used to set WEP keys.
- *
- * Both WEP40 and WEP104 are supported.
- */
-static int
-mwifiex_set_wep_keys(struct mwifiex_private *priv, const u8 *key, int key_len,
-		     int index)
-{
-
-	u32 cipher = 0;
-
-	if (key_len == 5)
-		cipher = WLAN_CIPHER_SUITE_WEP40;
-	else
-		cipher = WLAN_CIPHER_SUITE_WEP104;
-
-	return mwifiex_set_encode(priv, cipher, key, key_len, index, 0);
-}
-
-/*
  * This function informs the CFG802.11 subsystem of a new IBSS.
  *
  * The following information are sent to the CFG802.11 subsystem
@@ -1051,7 +1039,7 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 		return ret;
 	}
 
-	ret = mwifiex_set_encode(priv, 0, NULL, 0, 0, 1);/* Disable keys */
+	ret = mwifiex_set_encode(priv, NULL, 0, 0, 1);	/* Disable keys */
 
 	if (!sme && privacy) {
 		/*
@@ -1096,8 +1084,8 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 			dev_dbg(priv->adapter->dev,
 				"info: setting wep encryption"
 				" with key len %d\n", sme->key_len);
-			ret = mwifiex_set_wep_keys(priv, sme->key, sme->key_len,
-						   sme->key_idx);
+			ret = mwifiex_set_encode(priv, sme->key, sme->key_len,
+							sme->key_idx, 0);
 		}
 	}
 done:
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index aee19a9..1cccf8e 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -1017,7 +1017,7 @@ int mwifiex_drv_change_adhoc_chan(struct mwifiex_private *priv, int channel);
 int mwifiex_set_auth(struct mwifiex_private *priv, int encrypt_mode,
 		     int auth_mode, int wpa_enabled);
 
-int mwifiex_set_encode(struct mwifiex_private *priv, u32 cipher, const u8 *key,
+int mwifiex_set_encode(struct mwifiex_private *priv, const u8 *key,
 		       int key_len, u8 key_index, int disable);
 
 int mwifiex_set_gen_ie(struct mwifiex_private *priv, u8 *ie, int ie_len);
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index f446a5a..436310d 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -2151,16 +2151,9 @@ mwifiex_set_auth(struct mwifiex_private *priv, int encrypt_mode,
  *
  * This function allocates the IOCTL request buffer, fills it
  * with requisite parameters and calls the IOCTL handler.
- *
- * The following cipher suites are supported -
- *      - WEP 40
- *      - WEP 104
- *      - TKIP
- *      - AES/CCMP
  */
-int
-mwifiex_set_encode(struct mwifiex_private *priv, u32 cipher, const u8 *key,
-		   int key_len, u8 key_index, int disable)
+int mwifiex_set_encode(struct mwifiex_private *priv, const u8 *key,
+			int key_len, u8 key_index, int disable)
 {
 	struct mwifiex_wait_queue *wait = NULL;
 	struct mwifiex_ds_encrypt_key encrypt_key;
@@ -2174,15 +2167,6 @@ mwifiex_set_encode(struct mwifiex_private *priv, u32 cipher, const u8 *key,
 	memset(&encrypt_key, 0, sizeof(struct mwifiex_ds_encrypt_key));
 	encrypt_key.key_len = key_len;
 	if (!disable) {
-		if (cipher != WLAN_CIPHER_SUITE_WEP40 &&
-		    cipher != WLAN_CIPHER_SUITE_WEP104 &&
-		    cipher != WLAN_CIPHER_SUITE_TKIP &&
-		    cipher != WLAN_CIPHER_SUITE_CCMP) {
-			dev_err(priv->adapter->dev,
-				"invalid cipher suite specified\n");
-			ret = -EINVAL;
-			goto done;
-		}
 		encrypt_key.key_index = key_index;
 		memcpy(encrypt_key.key_material, key, key_len);
 	} else {
@@ -2193,7 +2177,7 @@ mwifiex_set_encode(struct mwifiex_private *priv, u32 cipher, const u8 *key,
 
 	if (mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT))
 		ret = -EFAULT;
-done:
+
 	kfree(wait);
 	return ret;
 }
-- 
1.7.0.2

