Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:6278 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753815AbeDRLkh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Apr 2018 07:40:37 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 06/22] staging: wilc1000: handle error condition in add_key() and remove auth_type variable
Date: Wed, 18 Apr 2018 17:09:08 +0530
Message-ID: <1524051564-15497-7-git-send-email-ajay.kathat@microchip.com> (sfid-20180418_134147_991530_6B3F9F1E)
In-Reply-To: <1524051564-15497-1-git-send-email-ajay.kathat@microchip.com>
References: <1524051564-15497-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Added the code to return correct error code in add_key() and also removed
'auth_type' variable. Now passing diretly to function instead of using
the 'auth_type' variable.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 52 ++++++++++++-----------
 1 file changed, 28 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 329899f..821d4f1 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -923,7 +923,6 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 	const u8 *tx_mic = NULL;
 	u8 mode = NO_ENCRYPT;
 	u8 op_mode;
-	enum AUTHTYPE auth_type = ANY;
 	struct wilc *wl;
 	struct wilc_vif *vif;
 
@@ -937,24 +936,24 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 		if (priv->wdev->iftype == NL80211_IFTYPE_AP) {
 			wilc_wfi_cfg_copy_wep_info(priv, key_index, params);
 
-			auth_type = OPEN_SYSTEM;
-
 			if (params->cipher == WLAN_CIPHER_SUITE_WEP40)
 				mode = ENCRYPT_ENABLED | WEP;
 			else
 				mode = ENCRYPT_ENABLED | WEP | WEP_EXTENDED;
 
-			wilc_add_wep_key_bss_ap(vif, params->key,
-						params->key_len, key_index,
-						mode, auth_type);
+			ret = wilc_add_wep_key_bss_ap(vif, params->key,
+						      params->key_len,
+						      key_index, mode,
+						      OPEN_SYSTEM);
 			break;
 		}
 		if (memcmp(params->key, priv->wep_key[key_index],
 			   params->key_len)) {
 			wilc_wfi_cfg_copy_wep_info(priv, key_index, params);
 
-			wilc_add_wep_key_bss_sta(vif, params->key,
-						 params->key_len, key_index);
+			ret = wilc_add_wep_key_bss_sta(vif, params->key,
+						       params->key_len,
+						       key_index);
 		}
 
 		break;
@@ -963,7 +962,9 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 	case WLAN_CIPHER_SUITE_CCMP:
 		if (priv->wdev->iftype == NL80211_IFTYPE_AP ||
 		    priv->wdev->iftype == NL80211_IFTYPE_P2P_GO) {
-			wilc_wfi_cfg_allocate_wpa_entry(priv, key_index);
+			ret = wilc_wfi_cfg_allocate_wpa_entry(priv, key_index);
+			if (ret)
+				return -ENOMEM;
 
 			if (params->key_len > 16 &&
 			    params->cipher == WLAN_CIPHER_SUITE_TKIP) {
@@ -980,16 +981,20 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 
 				priv->wilc_groupkey = mode;
 
-				wilc_wfi_cfg_copy_wpa_info(priv->wilc_gtk[key_index],
-							   params);
+				ret = wilc_wfi_cfg_copy_wpa_info(priv->wilc_gtk[key_index],
+								 params);
+				if (ret)
+					return -ENOMEM;
 			} else {
 				if (params->cipher == WLAN_CIPHER_SUITE_TKIP)
 					mode = ENCRYPT_ENABLED | WPA | TKIP;
 				else
 					mode = priv->wilc_groupkey | AES;
 
-				wilc_wfi_cfg_copy_wpa_info(priv->wilc_ptk[key_index],
-							   params);
+				ret = wilc_wfi_cfg_copy_wpa_info(priv->wilc_ptk[key_index],
+								 params);
+				if (ret)
+					return -ENOMEM;
 			}
 			op_mode = AP_MODE;
 		} else {
@@ -1003,17 +1008,16 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 			op_mode = STATION_MODE;
 		}
 
-		if (!pairwise) {
-			wilc_add_rx_gtk(vif, params->key, keylen,
-					key_index, params->seq_len,
-					params->seq, rx_mic,
-					tx_mic, op_mode,
-					mode);
-		} else {
-			wilc_add_ptk(vif, params->key, keylen,
-				     mac_addr, rx_mic, tx_mic,
-				     op_mode, mode, key_index);
-		}
+		if (!pairwise)
+			ret = wilc_add_rx_gtk(vif, params->key, keylen,
+					      key_index, params->seq_len,
+					      params->seq, rx_mic, tx_mic,
+					      op_mode, mode);
+		else
+			ret = wilc_add_ptk(vif, params->key, keylen, mac_addr,
+					   rx_mic, tx_mic, op_mode, mode,
+					   key_index);
+
 		break;
 
 	default:
-- 
2.7.4
