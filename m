Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:31999 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752315AbeEGIpW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 May 2018 04:45:22 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 23/30] staging: wilc1000: rename u8security to avoid datatype in variable name
Date: Mon, 7 May 2018 14:13:27 +0530
Message-ID: <1525682614-3824-24-git-send-email-ajay.kathat@microchip.com> (sfid-20180507_104722_274696_82CCCFAE)
In-Reply-To: <1525682614-3824-1-git-send-email-ajay.kathat@microchip.com>
References: <1525682614-3824-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to avoid use of datatype in variable name to follow as
per linux coding style.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 00381c9..4600f4a 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -674,7 +674,7 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 	s32 ret = 0;
 	u32 i;
 	u32 sel_bssi_idx = UINT_MAX;
-	u8 u8security = NO_ENCRYPT;
+	u8 security = NO_ENCRYPT;
 	enum AUTHTYPE auth_type = ANY;
 	u32 cipher_group;
 	struct wilc_priv *priv;
@@ -727,7 +727,7 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 	cipher_group = sme->crypto.cipher_group;
 	if (cipher_group != NO_ENCRYPT) {
 		if (cipher_group == WLAN_CIPHER_SUITE_WEP40) {
-			u8security = ENCRYPT_ENABLED | WEP;
+			security = ENCRYPT_ENABLED | WEP;
 
 			priv->wep_key_len[sme->key_idx] = sme->key_len;
 			memcpy(priv->wep_key[sme->key_idx], sme->key,
@@ -737,7 +737,7 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 			wilc_add_wep_key_bss_sta(vif, sme->key, sme->key_len,
 						 sme->key_idx);
 		} else if (cipher_group == WLAN_CIPHER_SUITE_WEP104) {
-			u8security = ENCRYPT_ENABLED | WEP | WEP_EXTENDED;
+			security = ENCRYPT_ENABLED | WEP | WEP_EXTENDED;
 
 			priv->wep_key_len[sme->key_idx] = sme->key_len;
 			memcpy(priv->wep_key[sme->key_idx], sme->key,
@@ -748,14 +748,14 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 						 sme->key_idx);
 		} else if (sme->crypto.wpa_versions & NL80211_WPA_VERSION_2) {
 			if (cipher_group == WLAN_CIPHER_SUITE_TKIP)
-				u8security = ENCRYPT_ENABLED | WPA2 | TKIP;
+				security = ENCRYPT_ENABLED | WPA2 | TKIP;
 			else
-				u8security = ENCRYPT_ENABLED | WPA2 | AES;
+				security = ENCRYPT_ENABLED | WPA2 | AES;
 		} else if (sme->crypto.wpa_versions & NL80211_WPA_VERSION_1) {
 			if (cipher_group == WLAN_CIPHER_SUITE_TKIP)
-				u8security = ENCRYPT_ENABLED | WPA | TKIP;
+				security = ENCRYPT_ENABLED | WPA | TKIP;
 			else
-				u8security = ENCRYPT_ENABLED | WPA | AES;
+				security = ENCRYPT_ENABLED | WPA | AES;
 		} else {
 			ret = -ENOTSUPP;
 			netdev_err(dev, "Not supported cipher\n");
@@ -770,9 +770,9 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 			u32 ciphers_pairwise = sme->crypto.ciphers_pairwise[i];
 
 			if (ciphers_pairwise == WLAN_CIPHER_SUITE_TKIP)
-				u8security = u8security | TKIP;
+				security = security | TKIP;
 			else
-				u8security = u8security | AES;
+				security = security | AES;
 		}
 	}
 
@@ -804,7 +804,7 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 	ret = wilc_set_join_req(vif, nw_info->bssid, sme->ssid,
 				sme->ssid_len, sme->ie, sme->ie_len,
 				cfg_connect_result, (void *)priv,
-				u8security, auth_type,
+				security, auth_type,
 				nw_info->ch,
 				nw_info->join_params);
 	if (ret != 0) {
-- 
2.7.4
