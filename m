Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:2854 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755727AbeDWQfU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Apr 2018 12:35:20 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [RESEND 14/33] staging: wilc1000: split add_key() to avoid line over 80 chars
Date: Mon, 23 Apr 2018 22:03:16 +0530
Message-ID: <1524501215-4963-15-git-send-email-ajay.kathat@microchip.com> (sfid-20180423_183526_074670_D68F0C53)
In-Reply-To: <1524501215-4963-1-git-send-email-ajay.kathat@microchip.com>
References: <1524501215-4963-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup changes to fix 'line over 80 chars' issue found by checkpatch.pl
script by spliting the function. Also make use of kzalloc() instead
kmalloc().

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 108 +++++++++++++---------
 1 file changed, 64 insertions(+), 44 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 0f63c43..a80d4d7 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -859,6 +859,58 @@ static int disconnect(struct wiphy *wiphy, struct net_device *dev,
 	return ret;
 }
 
+static inline void wilc_wfi_cfg_copy_wep_info(struct wilc_priv *priv,
+					      u8 key_index,
+					      struct key_params *params)
+{
+	priv->wep_key_len[key_index] = params->key_len;
+	memcpy(priv->wep_key[key_index], params->key, params->key_len);
+}
+
+static int wilc_wfi_cfg_allocate_wpa_entry(struct wilc_priv *priv, u8 idx)
+{
+	if (!priv->wilc_gtk[idx]) {
+		priv->wilc_gtk[idx] = kzalloc(sizeof(struct wilc_wfi_key),
+					       GFP_KERNEL);
+		if (!priv->wilc_gtk[idx])
+			return -ENOMEM;
+	}
+
+	if (!priv->wilc_ptk[idx]) {
+		priv->wilc_ptk[idx] = kzalloc(sizeof(struct wilc_wfi_key),
+					       GFP_KERNEL);
+		if (!priv->wilc_ptk[idx])
+			return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static int wilc_wfi_cfg_copy_wpa_info(struct wilc_wfi_key *key_info,
+				      struct key_params *params)
+{
+	kfree(key_info->key);
+
+	key_info->key = kmemdup(params->key, params->key_len, GFP_KERNEL);
+	if (!key_info->key)
+		return -ENOMEM;
+
+	kfree(key_info->seq);
+
+	if (params->seq_len > 0) {
+		key_info->seq = kmemdup(params->seq, params->seq_len,
+					GFP_KERNEL);
+		if (!key_info->seq)
+			return -ENOMEM;
+	}
+
+	key_info->cipher = params->cipher;
+	key_info->key_len = params->key_len;
+	key_info->seq_len = params->seq_len;
+
+	return 0;
+}
+
 static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 		   bool pairwise,
 		   const u8 *mac_addr, struct key_params *params)
@@ -879,12 +931,11 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 	vif = netdev_priv(netdev);
 	wl = vif->wilc;
 
-	switch (params->cipher)	{
+	switch (params->cipher) {
 	case WLAN_CIPHER_SUITE_WEP40:
 	case WLAN_CIPHER_SUITE_WEP104:
 		if (priv->wdev->iftype == NL80211_IFTYPE_AP) {
-			priv->wep_key_len[key_index] = params->key_len;
-			memcpy(priv->wep_key[key_index], params->key, params->key_len);
+			wilc_wfi_cfg_copy_wep_info(priv, key_index, params);
 
 			auth_type = OPEN_SYSTEM;
 
@@ -898,9 +949,9 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 						mode, auth_type);
 			break;
 		}
-		if (memcmp(params->key, priv->wep_key[key_index], params->key_len)) {
-			priv->wep_key_len[key_index] = params->key_len;
-			memcpy(priv->wep_key[key_index], params->key, params->key_len);
+		if (memcmp(params->key, priv->wep_key[key_index],
+			   params->key_len)) {
+			wilc_wfi_cfg_copy_wep_info(priv, key_index, params);
 
 			wilc_add_wep_key_bss_sta(vif, params->key,
 						 params->key_len, key_index);
@@ -910,17 +961,9 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 
 	case WLAN_CIPHER_SUITE_TKIP:
 	case WLAN_CIPHER_SUITE_CCMP:
-		if (priv->wdev->iftype == NL80211_IFTYPE_AP || priv->wdev->iftype == NL80211_IFTYPE_P2P_GO) {
-			if (!priv->wilc_gtk[key_index]) {
-				priv->wilc_gtk[key_index] = kmalloc(sizeof(struct wilc_wfi_key), GFP_KERNEL);
-				priv->wilc_gtk[key_index]->key = NULL;
-				priv->wilc_gtk[key_index]->seq = NULL;
-			}
-			if (!priv->wilc_ptk[key_index]) {
-				priv->wilc_ptk[key_index] = kmalloc(sizeof(struct wilc_wfi_key), GFP_KERNEL);
-				priv->wilc_ptk[key_index]->key = NULL;
-				priv->wilc_ptk[key_index]->seq = NULL;
-			}
+		if (priv->wdev->iftype == NL80211_IFTYPE_AP ||
+		    priv->wdev->iftype == NL80211_IFTYPE_P2P_GO) {
+			wilc_wfi_cfg_allocate_wpa_entry(priv, key_index);
 
 			if (!pairwise) {
 				if (params->cipher == WLAN_CIPHER_SUITE_TKIP)
@@ -935,20 +978,8 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 					rx_mic = params->key + 16;
 					keylen = params->key_len - 16;
 				}
-				kfree(priv->wilc_gtk[key_index]->key);
-
-				priv->wilc_gtk[key_index]->key = kmalloc(params->key_len, GFP_KERNEL);
-				memcpy(priv->wilc_gtk[key_index]->key, params->key, params->key_len);
-				kfree(priv->wilc_gtk[key_index]->seq);
-
-				if (params->seq_len > 0) {
-					priv->wilc_gtk[key_index]->seq = kmalloc(params->seq_len, GFP_KERNEL);
-					memcpy(priv->wilc_gtk[key_index]->seq, params->seq, params->seq_len);
-				}
-
-				priv->wilc_gtk[key_index]->cipher = params->cipher;
-				priv->wilc_gtk[key_index]->key_len = params->key_len;
-				priv->wilc_gtk[key_index]->seq_len = params->seq_len;
+				wilc_wfi_cfg_copy_wpa_info(priv->wilc_gtk[key_index],
+							   params);
 
 				wilc_add_rx_gtk(vif, params->key, keylen,
 						key_index, params->seq_len,
@@ -967,19 +998,8 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 					keylen = params->key_len - 16;
 				}
 
-				kfree(priv->wilc_ptk[key_index]->key);
-				priv->wilc_ptk[key_index]->key = kmalloc(params->key_len, GFP_KERNEL);
-				memcpy(priv->wilc_ptk[key_index]->key, params->key, params->key_len);
-
-				kfree(priv->wilc_ptk[key_index]->seq);
-				if (params->seq_len > 0) {
-					priv->wilc_ptk[key_index]->seq = kmalloc(params->seq_len, GFP_KERNEL);
-					memcpy(priv->wilc_ptk[key_index]->seq, params->seq, params->seq_len);
-				}
-
-				priv->wilc_ptk[key_index]->cipher = params->cipher;
-				priv->wilc_ptk[key_index]->key_len = params->key_len;
-				priv->wilc_ptk[key_index]->seq_len = params->seq_len;
+				wilc_wfi_cfg_copy_wpa_info(priv->wilc_ptk[key_index],
+							   params);
 
 				wilc_add_ptk(vif, params->key, keylen,
 					     mac_addr, rx_mic, tx_mic,
-- 
2.7.4
