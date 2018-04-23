Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:2854 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755778AbeDWQfZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Apr 2018 12:35:25 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [RESEND 16/33] staging: wilc1000: refactor add_key() to avoid duplicated code
Date: Mon, 23 Apr 2018 22:03:18 +0530
Message-ID: <1524501215-4963-17-git-send-email-ajay.kathat@microchip.com> (sfid-20180423_183532_080114_0CA44F6B)
In-Reply-To: <1524501215-4963-1-git-send-email-ajay.kathat@microchip.com>
References: <1524501215-4963-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup fixes by removing the duplicated code in actor add_key().

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 64 ++++++++---------------
 1 file changed, 23 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 4eb697f..9f147ee 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -921,8 +921,7 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 	const u8 *rx_mic = NULL;
 	const u8 *tx_mic = NULL;
 	u8 mode = NO_ENCRYPT;
-	u8 gmode = NO_ENCRYPT;
-	u8 pmode = NO_ENCRYPT;
+	u8 op_mode;
 	enum AUTHTYPE auth_type = ANY;
 	struct wilc *wl;
 	struct wilc_vif *vif;
@@ -965,71 +964,54 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 		    priv->wdev->iftype == NL80211_IFTYPE_P2P_GO) {
 			wilc_wfi_cfg_allocate_wpa_entry(priv, key_index);
 
+			if (params->key_len > 16 &&
+			    params->cipher == WLAN_CIPHER_SUITE_TKIP) {
+				tx_mic = params->key + 24;
+				rx_mic = params->key + 16;
+				keylen = params->key_len - 16;
+			}
+
 			if (!pairwise) {
 				if (params->cipher == WLAN_CIPHER_SUITE_TKIP)
-					gmode = ENCRYPT_ENABLED | WPA | TKIP;
+					mode = ENCRYPT_ENABLED | WPA | TKIP;
 				else
-					gmode = ENCRYPT_ENABLED | WPA2 | AES;
+					mode = ENCRYPT_ENABLED | WPA2 | AES;
 
-				priv->wilc_groupkey = gmode;
+				priv->wilc_groupkey = mode;
 
-				if (params->key_len > 16 && params->cipher == WLAN_CIPHER_SUITE_TKIP) {
-					tx_mic = params->key + 24;
-					rx_mic = params->key + 16;
-					keylen = params->key_len - 16;
-				}
 				wilc_wfi_cfg_copy_wpa_info(priv->wilc_gtk[key_index],
 							   params);
-
-				wilc_add_rx_gtk(vif, params->key, keylen,
-						key_index, params->seq_len,
-						params->seq, rx_mic,
-						tx_mic, AP_MODE, gmode);
-
 			} else {
 				if (params->cipher == WLAN_CIPHER_SUITE_TKIP)
-					pmode = ENCRYPT_ENABLED | WPA | TKIP;
+					mode = ENCRYPT_ENABLED | WPA | TKIP;
 				else
-					pmode = priv->wilc_groupkey | AES;
-
-				if (params->key_len > 16 && params->cipher == WLAN_CIPHER_SUITE_TKIP) {
-					tx_mic = params->key + 24;
-					rx_mic = params->key + 16;
-					keylen = params->key_len - 16;
-				}
+					mode = priv->wilc_groupkey | AES;
 
 				wilc_wfi_cfg_copy_wpa_info(priv->wilc_ptk[key_index],
 							   params);
-
-				wilc_add_ptk(vif, params->key, keylen,
-					     mac_addr, rx_mic, tx_mic,
-					     AP_MODE, pmode, key_index);
 			}
-			break;
-		}
-
-		if (!pairwise) {
-			if (params->key_len > 16 && params->cipher == WLAN_CIPHER_SUITE_TKIP) {
+			op_mode = AP_MODE;
+		} else {
+			if (params->key_len > 16 &&
+			    params->cipher == WLAN_CIPHER_SUITE_TKIP) {
 				rx_mic = params->key + 24;
 				tx_mic = params->key + 16;
 				keylen = params->key_len - 16;
 			}
 
+			op_mode = STATION_MODE;
+		}
+
+		if (!pairwise) {
 			wilc_add_rx_gtk(vif, params->key, keylen,
 					key_index, params->seq_len,
 					params->seq, rx_mic,
-					tx_mic, STATION_MODE,
+					tx_mic, op_mode,
 					mode);
 		} else {
-			if (params->key_len > 16 && params->cipher == WLAN_CIPHER_SUITE_TKIP) {
-				rx_mic = params->key + 24;
-				tx_mic = params->key + 16;
-				keylen = params->key_len - 16;
-			}
-
 			wilc_add_ptk(vif, params->key, keylen,
 				     mac_addr, rx_mic, tx_mic,
-				     STATION_MODE, mode, key_index);
+				     op_mode, mode, key_index);
 		}
 		break;
 
-- 
2.7.4
