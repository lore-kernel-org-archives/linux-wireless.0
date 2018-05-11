Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:40291 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752673AbeEKIO6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 May 2018 04:14:58 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 19/30] staging: wilc1000: fix line over 80 characters in add_key()
Date: Fri, 11 May 2018 13:43:20 +0530
Message-ID: <1526026411-11058-20-git-send-email-ajay.kathat@microchip.com> (sfid-20180511_101502_320013_55EBE16D)
In-Reply-To: <1526026411-11058-1-git-send-email-ajay.kathat@microchip.com>
References: <1526026411-11058-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix line over 80 character issue found by checkpatch.pl script in
add_key().

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 9684d34..b67a170 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -908,8 +908,7 @@ static int wilc_wfi_cfg_copy_wpa_info(struct wilc_wfi_key *key_info,
 }
 
 static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
-		   bool pairwise,
-		   const u8 *mac_addr, struct key_params *params)
+		   bool pairwise, const u8 *mac_addr, struct key_params *params)
 
 {
 	s32 ret = 0, keylen = params->key_len;
@@ -955,6 +954,8 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 	case WLAN_CIPHER_SUITE_CCMP:
 		if (priv->wdev->iftype == NL80211_IFTYPE_AP ||
 		    priv->wdev->iftype == NL80211_IFTYPE_P2P_GO) {
+			struct wilc_wfi_key *key;
+
 			ret = wilc_wfi_cfg_allocate_wpa_entry(priv, key_index);
 			if (ret)
 				return -ENOMEM;
@@ -974,21 +975,19 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 
 				priv->wilc_groupkey = mode;
 
-				ret = wilc_wfi_cfg_copy_wpa_info(priv->wilc_gtk[key_index],
-								 params);
-				if (ret)
-					return -ENOMEM;
+				key = priv->wilc_gtk[key_index];
 			} else {
 				if (params->cipher == WLAN_CIPHER_SUITE_TKIP)
 					mode = ENCRYPT_ENABLED | WPA | TKIP;
 				else
 					mode = priv->wilc_groupkey | AES;
 
-				ret = wilc_wfi_cfg_copy_wpa_info(priv->wilc_ptk[key_index],
-								 params);
-				if (ret)
-					return -ENOMEM;
+				key = priv->wilc_ptk[key_index];
 			}
+			ret = wilc_wfi_cfg_copy_wpa_info(key, params);
+			if (ret)
+				return -ENOMEM;
+
 			op_mode = AP_MODE;
 		} else {
 			if (params->key_len > 16 &&
-- 
2.7.4
