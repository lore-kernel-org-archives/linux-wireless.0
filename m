Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:64459 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753724AbeDRLk1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Apr 2018 07:40:27 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 01/22] staging: wilc1000: rename WILC_WFI_wep_key & WILC_WFI_wep_key_len
Date: Wed, 18 Apr 2018 17:09:03 +0530
Message-ID: <1524051564-15497-2-git-send-email-ajay.kathat@microchip.com> (sfid-20180418_134030_316892_686A7438)
In-Reply-To: <1524051564-15497-1-git-send-email-ajay.kathat@microchip.com>
References: <1524051564-15497-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to use lower case for variable name as per linux coding
style.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 30 +++++++++++------------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  4 +--
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 3139ead..bdc6c85 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -726,15 +726,15 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 		return ret;
 	}
 
-	memset(priv->WILC_WFI_wep_key, 0, sizeof(priv->WILC_WFI_wep_key));
-	memset(priv->WILC_WFI_wep_key_len, 0, sizeof(priv->WILC_WFI_wep_key_len));
+	memset(priv->wep_key, 0, sizeof(priv->wep_key));
+	memset(priv->wep_key_len, 0, sizeof(priv->wep_key_len));
 
 	if (sme->crypto.cipher_group != NO_ENCRYPT) {
 		if (sme->crypto.cipher_group == WLAN_CIPHER_SUITE_WEP40) {
 			u8security = ENCRYPT_ENABLED | WEP;
 
-			priv->WILC_WFI_wep_key_len[sme->key_idx] = sme->key_len;
-			memcpy(priv->WILC_WFI_wep_key[sme->key_idx], sme->key, sme->key_len);
+			priv->wep_key_len[sme->key_idx] = sme->key_len;
+			memcpy(priv->wep_key[sme->key_idx], sme->key, sme->key_len);
 
 			wilc_set_wep_default_keyid(vif, sme->key_idx);
 			wilc_add_wep_key_bss_sta(vif, sme->key, sme->key_len,
@@ -742,8 +742,8 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 		} else if (sme->crypto.cipher_group == WLAN_CIPHER_SUITE_WEP104)   {
 			u8security = ENCRYPT_ENABLED | WEP | WEP_EXTENDED;
 
-			priv->WILC_WFI_wep_key_len[sme->key_idx] = sme->key_len;
-			memcpy(priv->WILC_WFI_wep_key[sme->key_idx], sme->key, sme->key_len);
+			priv->wep_key_len[sme->key_idx] = sme->key_len;
+			memcpy(priv->wep_key[sme->key_idx], sme->key, sme->key_len);
 
 			wilc_set_wep_default_keyid(vif, sme->key_idx);
 			wilc_add_wep_key_bss_sta(vif, sme->key, sme->key_len,
@@ -884,8 +884,8 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 	case WLAN_CIPHER_SUITE_WEP40:
 	case WLAN_CIPHER_SUITE_WEP104:
 		if (priv->wdev->iftype == NL80211_IFTYPE_AP) {
-			priv->WILC_WFI_wep_key_len[key_index] = params->key_len;
-			memcpy(priv->WILC_WFI_wep_key[key_index], params->key, params->key_len);
+			priv->wep_key_len[key_index] = params->key_len;
+			memcpy(priv->wep_key[key_index], params->key, params->key_len);
 
 			auth_type = OPEN_SYSTEM;
 
@@ -899,9 +899,9 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 						u8mode, auth_type);
 			break;
 		}
-		if (memcmp(params->key, priv->WILC_WFI_wep_key[key_index], params->key_len)) {
-			priv->WILC_WFI_wep_key_len[key_index] = params->key_len;
-			memcpy(priv->WILC_WFI_wep_key[key_index], params->key, params->key_len);
+		if (memcmp(params->key, priv->wep_key[key_index], params->key_len)) {
+			priv->wep_key_len[key_index] = params->key_len;
+			memcpy(priv->wep_key[key_index], params->key, params->key_len);
 
 			wilc_add_wep_key_bss_sta(vif, params->key,
 						 params->key_len, key_index);
@@ -1060,10 +1060,10 @@ static int del_key(struct wiphy *wiphy, struct net_device *netdev,
 	}
 
 	if (key_index >= 0 && key_index <= 3) {
-		if (priv->WILC_WFI_wep_key_len[key_index]) {
-			memset(priv->WILC_WFI_wep_key[key_index], 0,
-			       priv->WILC_WFI_wep_key_len[key_index]);
-			priv->WILC_WFI_wep_key_len[key_index] = 0;
+		if (priv->wep_key_len[key_index]) {
+			memset(priv->wep_key[key_index], 0,
+			       priv->wep_key_len[key_index]);
+			priv->wep_key_len[key_index] = 0;
 			wilc_remove_wep_key(vif, key_index);
 		}
 	} else {
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index d62c4f1..bd0c98a 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -124,8 +124,8 @@ struct wilc_priv {
 	struct host_if_drv *hif_drv;
 	struct host_if_pmkid_attr pmkid_list;
 	struct WILC_WFI_stats netstats;
-	u8 WILC_WFI_wep_key[4][WLAN_KEY_LEN_WEP104];
-	u8 WILC_WFI_wep_key_len[4];
+	u8 wep_key[4][WLAN_KEY_LEN_WEP104];
+	u8 wep_key_len[4];
 	/* The real interface that the monitor is on */
 	struct net_device *real_ndev;
 	struct wilc_wfi_key *wilc_gtk[MAX_NUM_STA];
-- 
2.7.4
