Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:16360 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752103AbeAPODb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Jan 2018 09:03:31 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 10/13] staging: wilc1000: rename variables using camelCase in add_key()
Date: Tue, 16 Jan 2018 19:32:28 +0530
Message-ID: <1516111351-5353-11-git-send-email-ajay.kathat@microchip.com> (sfid-20180116_150402_675639_6CA19FA8)
In-Reply-To: <1516111351-5353-1-git-send-email-ajay.kathat@microchip.com>
References: <1516111351-5353-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a cleanup patch to avoid using camelCase for variable
names.
Changes fix "Avoid camelCase" issue reported by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 56 +++++++++++------------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index ae8df88..b68f46c 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -855,14 +855,14 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 		   const u8 *mac_addr, struct key_params *params)
 
 {
-	s32 ret = 0, KeyLen = params->key_len;
+	s32 ret = 0, keylen = params->key_len;
 	struct wilc_priv *priv;
-	const u8 *pu8RxMic = NULL;
-	const u8 *pu8TxMic = NULL;
+	const u8 *rx_mic = NULL;
+	const u8 *tx_mic = NULL;
 	u8 u8mode = NO_ENCRYPT;
 	u8 u8gmode = NO_ENCRYPT;
 	u8 u8pmode = NO_ENCRYPT;
-	enum AUTHTYPE tenuAuth_type = ANY;
+	enum AUTHTYPE auth_type = ANY;
 	struct wilc *wl;
 	struct wilc_vif *vif;
 
@@ -877,7 +877,7 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 			priv->WILC_WFI_wep_key_len[key_index] = params->key_len;
 			memcpy(priv->WILC_WFI_wep_key[key_index], params->key, params->key_len);
 
-			tenuAuth_type = OPEN_SYSTEM;
+			auth_type = OPEN_SYSTEM;
 
 			if (params->cipher == WLAN_CIPHER_SUITE_WEP40)
 				u8mode = ENCRYPT_ENABLED | WEP;
@@ -886,7 +886,7 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 
 			wilc_add_wep_key_bss_ap(vif, params->key,
 						params->key_len, key_index,
-						u8mode, tenuAuth_type);
+						u8mode, auth_type);
 			break;
 		}
 		if (memcmp(params->key, priv->WILC_WFI_wep_key[key_index], params->key_len)) {
@@ -922,9 +922,9 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 				priv->wilc_groupkey = u8gmode;
 
 				if (params->key_len > 16 && params->cipher == WLAN_CIPHER_SUITE_TKIP) {
-					pu8TxMic = params->key + 24;
-					pu8RxMic = params->key + 16;
-					KeyLen = params->key_len - 16;
+					tx_mic = params->key + 24;
+					rx_mic = params->key + 16;
+					keylen = params->key_len - 16;
 				}
 				kfree(priv->wilc_gtk[key_index]->key);
 
@@ -941,10 +941,10 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 				priv->wilc_gtk[key_index]->key_len = params->key_len;
 				priv->wilc_gtk[key_index]->seq_len = params->seq_len;
 
-				wilc_add_rx_gtk(vif, params->key, KeyLen,
+				wilc_add_rx_gtk(vif, params->key, keylen,
 						key_index, params->seq_len,
-						params->seq, pu8RxMic,
-						pu8TxMic, AP_MODE, u8gmode);
+						params->seq, rx_mic,
+						tx_mic, AP_MODE, u8gmode);
 
 			} else {
 				if (params->cipher == WLAN_CIPHER_SUITE_TKIP)
@@ -953,9 +953,9 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 					u8pmode = priv->wilc_groupkey | AES;
 
 				if (params->key_len > 16 && params->cipher == WLAN_CIPHER_SUITE_TKIP) {
-					pu8TxMic = params->key + 24;
-					pu8RxMic = params->key + 16;
-					KeyLen = params->key_len - 16;
+					tx_mic = params->key + 24;
+					rx_mic = params->key + 16;
+					keylen = params->key_len - 16;
 				}
 
 				kfree(priv->wilc_ptk[key_index]->key);
@@ -976,8 +976,8 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 				priv->wilc_ptk[key_index]->key_len = params->key_len;
 				priv->wilc_ptk[key_index]->seq_len = params->seq_len;
 
-				wilc_add_ptk(vif, params->key, KeyLen,
-					     mac_addr, pu8RxMic, pu8TxMic,
+				wilc_add_ptk(vif, params->key, keylen,
+					     mac_addr, rx_mic, tx_mic,
 					     AP_MODE, u8pmode, key_index);
 			}
 			break;
@@ -987,9 +987,9 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 			u8mode = 0;
 			if (!pairwise) {
 				if (params->key_len > 16 && params->cipher == WLAN_CIPHER_SUITE_TKIP) {
-					pu8RxMic = params->key + 24;
-					pu8TxMic = params->key + 16;
-					KeyLen = params->key_len - 16;
+					rx_mic = params->key + 24;
+					tx_mic = params->key + 16;
+					keylen = params->key_len - 16;
 				}
 
 				if (!g_gtk_keys_saved && netdev == wl->vif[0]->ndev) {
@@ -1013,16 +1013,16 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 					g_gtk_keys_saved = true;
 				}
 
-				wilc_add_rx_gtk(vif, params->key, KeyLen,
+				wilc_add_rx_gtk(vif, params->key, keylen,
 						key_index, params->seq_len,
-						params->seq, pu8RxMic,
-						pu8TxMic, STATION_MODE,
+						params->seq, rx_mic,
+						tx_mic, STATION_MODE,
 						u8mode);
 			} else {
 				if (params->key_len > 16 && params->cipher == WLAN_CIPHER_SUITE_TKIP) {
-					pu8RxMic = params->key + 24;
-					pu8TxMic = params->key + 16;
-					KeyLen = params->key_len - 16;
+					rx_mic = params->key + 24;
+					tx_mic = params->key + 16;
+					keylen = params->key_len - 16;
 				}
 
 				if (!g_ptk_keys_saved && netdev == wl->vif[0]->ndev) {
@@ -1046,8 +1046,8 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 					g_ptk_keys_saved = true;
 				}
 
-				wilc_add_ptk(vif, params->key, KeyLen,
-					     mac_addr, pu8RxMic, pu8TxMic,
+				wilc_add_ptk(vif, params->key, keylen,
+					     mac_addr, rx_mic, tx_mic,
 					     STATION_MODE, u8mode, key_index);
 			}
 		}
-- 
2.7.4
