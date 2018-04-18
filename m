Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:6278 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753250AbeDRLk2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Apr 2018 07:40:28 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 02/22] staging: wilc1000: rename variable using datatype in their name in add_key()
Date: Wed, 18 Apr 2018 17:09:04 +0530
Message-ID: <1524051564-15497-3-git-send-email-ajay.kathat@microchip.com> (sfid-20180418_134030_888184_1E1F3471)
In-Reply-To: <1524051564-15497-1-git-send-email-ajay.kathat@microchip.com>
References: <1524051564-15497-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup changes to use variable name as per linux coding style.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 32 +++++++++++------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index bdc6c85..57e7bf6 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -869,9 +869,9 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 	struct wilc_priv *priv;
 	const u8 *rx_mic = NULL;
 	const u8 *tx_mic = NULL;
-	u8 u8mode = NO_ENCRYPT;
-	u8 u8gmode = NO_ENCRYPT;
-	u8 u8pmode = NO_ENCRYPT;
+	u8 mode = NO_ENCRYPT;
+	u8 gmode = NO_ENCRYPT;
+	u8 pmode = NO_ENCRYPT;
 	enum AUTHTYPE auth_type = ANY;
 	struct wilc *wl;
 	struct wilc_vif *vif;
@@ -890,13 +890,13 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 			auth_type = OPEN_SYSTEM;
 
 			if (params->cipher == WLAN_CIPHER_SUITE_WEP40)
-				u8mode = ENCRYPT_ENABLED | WEP;
+				mode = ENCRYPT_ENABLED | WEP;
 			else
-				u8mode = ENCRYPT_ENABLED | WEP | WEP_EXTENDED;
+				mode = ENCRYPT_ENABLED | WEP | WEP_EXTENDED;
 
 			wilc_add_wep_key_bss_ap(vif, params->key,
 						params->key_len, key_index,
-						u8mode, auth_type);
+						mode, auth_type);
 			break;
 		}
 		if (memcmp(params->key, priv->wep_key[key_index], params->key_len)) {
@@ -925,11 +925,11 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 
 			if (!pairwise) {
 				if (params->cipher == WLAN_CIPHER_SUITE_TKIP)
-					u8gmode = ENCRYPT_ENABLED | WPA | TKIP;
+					gmode = ENCRYPT_ENABLED | WPA | TKIP;
 				else
-					u8gmode = ENCRYPT_ENABLED | WPA2 | AES;
+					gmode = ENCRYPT_ENABLED | WPA2 | AES;
 
-				priv->wilc_groupkey = u8gmode;
+				priv->wilc_groupkey = gmode;
 
 				if (params->key_len > 16 && params->cipher == WLAN_CIPHER_SUITE_TKIP) {
 					tx_mic = params->key + 24;
@@ -954,13 +954,13 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 				wilc_add_rx_gtk(vif, params->key, keylen,
 						key_index, params->seq_len,
 						params->seq, rx_mic,
-						tx_mic, AP_MODE, u8gmode);
+						tx_mic, AP_MODE, gmode);
 
 			} else {
 				if (params->cipher == WLAN_CIPHER_SUITE_TKIP)
-					u8pmode = ENCRYPT_ENABLED | WPA | TKIP;
+					pmode = ENCRYPT_ENABLED | WPA | TKIP;
 				else
-					u8pmode = priv->wilc_groupkey | AES;
+					pmode = priv->wilc_groupkey | AES;
 
 				if (params->key_len > 16 && params->cipher == WLAN_CIPHER_SUITE_TKIP) {
 					tx_mic = params->key + 24;
@@ -984,13 +984,13 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 
 				wilc_add_ptk(vif, params->key, keylen,
 					     mac_addr, rx_mic, tx_mic,
-					     AP_MODE, u8pmode, key_index);
+					     AP_MODE, pmode, key_index);
 			}
 			break;
 		}
 
 		{
-			u8mode = 0;
+			mode = 0;
 			if (!pairwise) {
 				if (params->key_len > 16 && params->cipher == WLAN_CIPHER_SUITE_TKIP) {
 					rx_mic = params->key + 24;
@@ -1002,7 +1002,7 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 						key_index, params->seq_len,
 						params->seq, rx_mic,
 						tx_mic, STATION_MODE,
-						u8mode);
+						mode);
 			} else {
 				if (params->key_len > 16 && params->cipher == WLAN_CIPHER_SUITE_TKIP) {
 					rx_mic = params->key + 24;
@@ -1012,7 +1012,7 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 
 				wilc_add_ptk(vif, params->key, keylen,
 					     mac_addr, rx_mic, tx_mic,
-					     STATION_MODE, u8mode, key_index);
+					     STATION_MODE, mode, key_index);
 			}
 		}
 		break;
-- 
2.7.4
