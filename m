Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:7399 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752115AbeEGIoz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 May 2018 04:44:55 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 22/30] staging: wilc1000: fix line over 80 chars issue in connect()
Date: Mon, 7 May 2018 14:13:26 +0530
Message-ID: <1525682614-3824-23-git-send-email-ajay.kathat@microchip.com> (sfid-20180507_104537_937201_2C6825BE)
In-Reply-To: <1525682614-3824-1-git-send-email-ajay.kathat@microchip.com>
References: <1525682614-3824-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix line over 80 characters in connect() by using temporary variables.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 29 +++++++++++++----------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index ec4fa1c..00381c9 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -676,7 +676,7 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 	u32 sel_bssi_idx = UINT_MAX;
 	u8 u8security = NO_ENCRYPT;
 	enum AUTHTYPE auth_type = ANY;
-
+	u32 cipher_group;
 	struct wilc_priv *priv;
 	struct host_if_drv *wfi_drv;
 	struct network_info *nw_info = NULL;
@@ -724,32 +724,35 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 	memset(priv->wep_key, 0, sizeof(priv->wep_key));
 	memset(priv->wep_key_len, 0, sizeof(priv->wep_key_len));
 
-	if (sme->crypto.cipher_group != NO_ENCRYPT) {
-		if (sme->crypto.cipher_group == WLAN_CIPHER_SUITE_WEP40) {
+	cipher_group = sme->crypto.cipher_group;
+	if (cipher_group != NO_ENCRYPT) {
+		if (cipher_group == WLAN_CIPHER_SUITE_WEP40) {
 			u8security = ENCRYPT_ENABLED | WEP;
 
 			priv->wep_key_len[sme->key_idx] = sme->key_len;
-			memcpy(priv->wep_key[sme->key_idx], sme->key, sme->key_len);
+			memcpy(priv->wep_key[sme->key_idx], sme->key,
+			       sme->key_len);
 
 			wilc_set_wep_default_keyid(vif, sme->key_idx);
 			wilc_add_wep_key_bss_sta(vif, sme->key, sme->key_len,
 						 sme->key_idx);
-		} else if (sme->crypto.cipher_group == WLAN_CIPHER_SUITE_WEP104)   {
+		} else if (cipher_group == WLAN_CIPHER_SUITE_WEP104) {
 			u8security = ENCRYPT_ENABLED | WEP | WEP_EXTENDED;
 
 			priv->wep_key_len[sme->key_idx] = sme->key_len;
-			memcpy(priv->wep_key[sme->key_idx], sme->key, sme->key_len);
+			memcpy(priv->wep_key[sme->key_idx], sme->key,
+			       sme->key_len);
 
 			wilc_set_wep_default_keyid(vif, sme->key_idx);
 			wilc_add_wep_key_bss_sta(vif, sme->key, sme->key_len,
 						 sme->key_idx);
-		} else if (sme->crypto.wpa_versions & NL80211_WPA_VERSION_2)   {
-			if (sme->crypto.cipher_group == WLAN_CIPHER_SUITE_TKIP)
+		} else if (sme->crypto.wpa_versions & NL80211_WPA_VERSION_2) {
+			if (cipher_group == WLAN_CIPHER_SUITE_TKIP)
 				u8security = ENCRYPT_ENABLED | WPA2 | TKIP;
 			else
 				u8security = ENCRYPT_ENABLED | WPA2 | AES;
-		} else if (sme->crypto.wpa_versions & NL80211_WPA_VERSION_1)   {
-			if (sme->crypto.cipher_group == WLAN_CIPHER_SUITE_TKIP)
+		} else if (sme->crypto.wpa_versions & NL80211_WPA_VERSION_1) {
+			if (cipher_group == WLAN_CIPHER_SUITE_TKIP)
 				u8security = ENCRYPT_ENABLED | WPA | TKIP;
 			else
 				u8security = ENCRYPT_ENABLED | WPA | AES;
@@ -764,14 +767,16 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 	if ((sme->crypto.wpa_versions & NL80211_WPA_VERSION_1) ||
 	    (sme->crypto.wpa_versions & NL80211_WPA_VERSION_2)) {
 		for (i = 0; i < sme->crypto.n_ciphers_pairwise; i++) {
-			if (sme->crypto.ciphers_pairwise[i] == WLAN_CIPHER_SUITE_TKIP)
+			u32 ciphers_pairwise = sme->crypto.ciphers_pairwise[i];
+
+			if (ciphers_pairwise == WLAN_CIPHER_SUITE_TKIP)
 				u8security = u8security | TKIP;
 			else
 				u8security = u8security | AES;
 		}
 	}
 
-	switch (sme->auth_type)	{
+	switch (sme->auth_type) {
 	case NL80211_AUTHTYPE_OPEN_SYSTEM:
 		auth_type = OPEN_SYSTEM;
 		break;
-- 
2.7.4
