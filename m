Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na6sys009bog028.obsmtp.com ([74.125.150.102]:39988 "EHLO
	na6sys009bog028.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752979Ab2HDBUL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2012 21:20:11 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 15/16] mwifiex: pass key_params pointer in mwifiex_set_encode
Date: Fri,  3 Aug 2012 18:06:13 -0700
Message-Id: <1344042374-6892-16-git-send-email-bzhao@marvell.com> (sfid-20120804_032014_233378_015EF0B1)
In-Reply-To: <1344042374-6892-1-git-send-email-bzhao@marvell.com>
References: <1344042374-6892-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ying Luo <luoy@marvell.com>

'cipher' and 'seq' coming from cfg80211 add_key handler will be
parsed in mwifiex_set_encode() to handle AES_CMAC cipher suite.

Signed-off-by: Ying Luo <luoy@marvell.com>
Signed-off-by: Stone Piao <piaoyun@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c  |   15 +++++++++------
 drivers/net/wireless/mwifiex/ioctl.h     |    1 +
 drivers/net/wireless/mwifiex/main.h      |    6 +++---
 drivers/net/wireless/mwifiex/sta_ioctl.c |   12 +++++++++---
 4 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 1f80f7e..e57f543 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -99,7 +99,7 @@ mwifiex_cfg80211_del_key(struct wiphy *wiphy, struct net_device *netdev,
 	const u8 bc_mac[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 	const u8 *peer_mac = pairwise ? mac_addr : bc_mac;
 
-	if (mwifiex_set_encode(priv, NULL, 0, key_index, peer_mac, 1)) {
+	if (mwifiex_set_encode(priv, NULL, NULL, 0, key_index, peer_mac, 1)) {
 		wiphy_err(wiphy, "deleting the crypto keys\n");
 		return -EFAULT;
 	}
@@ -171,7 +171,8 @@ mwifiex_cfg80211_set_default_key(struct wiphy *wiphy, struct net_device *netdev,
 
 	if (priv->bss_type == MWIFIEX_BSS_TYPE_UAP) {
 		priv->wep_key_curr_index = key_index;
-	} else if (mwifiex_set_encode(priv, NULL, 0, key_index, NULL, 0)) {
+	} else if (mwifiex_set_encode(priv, NULL, NULL, 0, key_index,
+				      NULL, 0)) {
 		wiphy_err(wiphy, "set default Tx key index\n");
 		return -EFAULT;
 	}
@@ -207,7 +208,7 @@ mwifiex_cfg80211_add_key(struct wiphy *wiphy, struct net_device *netdev,
 		return 0;
 	}
 
-	if (mwifiex_set_encode(priv, params->key, params->key_len,
+	if (mwifiex_set_encode(priv, params, params->key, params->key_len,
 			       key_index, peer_mac, 0)) {
 		wiphy_err(wiphy, "crypto keys added\n");
 		return -EFAULT;
@@ -748,6 +749,7 @@ static const u32 mwifiex_cipher_suites[] = {
 	WLAN_CIPHER_SUITE_WEP104,
 	WLAN_CIPHER_SUITE_TKIP,
 	WLAN_CIPHER_SUITE_CCMP,
+	WLAN_CIPHER_SUITE_AES_CMAC,
 };
 
 /*
@@ -1161,7 +1163,7 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 	priv->wep_key_curr_index = 0;
 	priv->sec_info.encryption_mode = 0;
 	priv->sec_info.is_authtype_auto = 0;
-	ret = mwifiex_set_encode(priv, NULL, 0, 0, NULL, 1);
+	ret = mwifiex_set_encode(priv, NULL, NULL, 0, 0, NULL, 1);
 
 	if (mode == NL80211_IFTYPE_ADHOC) {
 		/* "privacy" is set only for ad-hoc mode */
@@ -1208,8 +1210,9 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 				"info: setting wep encryption"
 				" with key len %d\n", sme->key_len);
 			priv->wep_key_curr_index = sme->key_idx;
-			ret = mwifiex_set_encode(priv, sme->key, sme->key_len,
-						 sme->key_idx, NULL, 0);
+			ret = mwifiex_set_encode(priv, NULL, sme->key,
+						 sme->key_len, sme->key_idx,
+						 NULL, 0);
 		}
 	}
 done:
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index f2865b5..6a5eded 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -223,6 +223,7 @@ struct mwifiex_ds_encrypt_key {
 	u8 mac_addr[ETH_ALEN];
 	u32 is_wapi_key;
 	u8 pn[PN_LEN];		/* packet number */
+	u8 is_igtk_key;
 };
 
 struct mwifiex_power_cfg {
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index c39cd8e..994bc4f 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -981,9 +981,9 @@ int mwifiex_scan_networks(struct mwifiex_private *priv,
 			  const struct mwifiex_user_scan_cfg *user_scan_in);
 int mwifiex_set_radio(struct mwifiex_private *priv, u8 option);
 
-int mwifiex_set_encode(struct mwifiex_private *priv, const u8 *key,
-		       int key_len, u8 key_index, const u8 *mac_addr,
-		       int disable);
+int mwifiex_set_encode(struct mwifiex_private *priv, struct key_params *kp,
+		       const u8 *key, int key_len, u8 key_index,
+		       const u8 *mac_addr, int disable);
 
 int mwifiex_set_gen_ie(struct mwifiex_private *priv, u8 *ie, int ie_len);
 
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index fb21360..3f02597 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -942,20 +942,26 @@ mwifiex_drv_get_driver_version(struct mwifiex_adapter *adapter, char *version,
  * This function allocates the IOCTL request buffer, fills it
  * with requisite parameters and calls the IOCTL handler.
  */
-int mwifiex_set_encode(struct mwifiex_private *priv, const u8 *key,
-			int key_len, u8 key_index,
-			const u8 *mac_addr, int disable)
+int mwifiex_set_encode(struct mwifiex_private *priv, struct key_params *kp,
+		       const u8 *key, int key_len, u8 key_index,
+		       const u8 *mac_addr, int disable)
 {
 	struct mwifiex_ds_encrypt_key encrypt_key;
 
 	memset(&encrypt_key, 0, sizeof(struct mwifiex_ds_encrypt_key));
 	encrypt_key.key_len = key_len;
+
+	if (kp && kp->cipher == WLAN_CIPHER_SUITE_AES_CMAC)
+		encrypt_key.is_igtk_key = true;
+
 	if (!disable) {
 		encrypt_key.key_index = key_index;
 		if (key_len)
 			memcpy(encrypt_key.key_material, key, key_len);
 		if (mac_addr)
 			memcpy(encrypt_key.mac_addr, mac_addr, ETH_ALEN);
+		if (kp && kp->seq && kp->seq_len)
+			memcpy(encrypt_key.pn, kp->seq, kp->seq_len);
 	} else {
 		encrypt_key.key_disable = true;
 		if (mac_addr)
-- 
1.7.0.2

