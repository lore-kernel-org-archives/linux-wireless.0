Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:41243 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634AbcAYHoj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2016 02:44:39 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 25/26] staging: wilc1000: fix WEP security bug
Date: Mon, 25 Jan 2016 16:35:29 +0900
Message-ID: <1453707330-13526-26-git-send-email-glen.lee@atmel.com> (sfid-20160125_084442_347273_B7D2936A)
In-Reply-To: <1453707330-13526-1-git-send-email-glen.lee@atmel.com>
References: <1453707330-13526-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Station cannot connect to soft AP mode wilc when it is configured for WEP
security. This patch fixes it by setting the key index within the key value and
change the last else condition with DEFAULTKEY action case, and also do not use
WILC_WFI_wep_default index to set wep key id.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c         | 27 +++++++++++------------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  9 +-------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  1 -
 3 files changed, 14 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 9112f6d..031d0b4 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1741,14 +1741,7 @@ static int Handle_Key(struct wilc_vif *vif,
 			strWIDList[1].size = sizeof(char);
 			strWIDList[1].val = (s8 *)&pstrHostIFkeyAttr->attr.wep.auth_type;
 
-			strWIDList[2].id = (u16)WID_KEY_ID;
-			strWIDList[2].type = WID_CHAR;
-
-			strWIDList[2].val = (s8 *)&pstrHostIFkeyAttr->attr.wep.index;
-			strWIDList[2].size = sizeof(char);
-
-			pu8keybuf = kmemdup(pstrHostIFkeyAttr->attr.wep.key,
-					    pstrHostIFkeyAttr->attr.wep.key_len,
+			pu8keybuf = kmalloc(pstrHostIFkeyAttr->attr.wep.key_len + 2,
 					    GFP_KERNEL);
 
 			if (pu8keybuf == NULL) {
@@ -1756,15 +1749,21 @@ static int Handle_Key(struct wilc_vif *vif,
 				return -ENOMEM;
 			}
 
+			pu8keybuf[0] = pstrHostIFkeyAttr->attr.wep.index;
+			pu8keybuf[1] = pstrHostIFkeyAttr->attr.wep.key_len;
+
+			memcpy(&pu8keybuf[2], pstrHostIFkeyAttr->attr.wep.key,
+			       pstrHostIFkeyAttr->attr.wep.key_len);
+
 			kfree(pstrHostIFkeyAttr->attr.wep.key);
 
-			strWIDList[3].id = (u16)WID_WEP_KEY_VALUE;
-			strWIDList[3].type = WID_STR;
-			strWIDList[3].size = pstrHostIFkeyAttr->attr.wep.key_len;
-			strWIDList[3].val = (s8 *)pu8keybuf;
+			strWIDList[2].id = (u16)WID_WEP_KEY_VALUE;
+			strWIDList[2].type = WID_STR;
+			strWIDList[2].size = pstrHostIFkeyAttr->attr.wep.key_len + 2;
+			strWIDList[2].val = (s8 *)pu8keybuf;
 
 			result = wilc_send_config_pkt(vif->wilc, SET_CFG,
-						strWIDList, 4,
+						strWIDList, 3,
 						wilc_get_vif_idx(vif));
 			kfree(pu8keybuf);
 		} else if (pstrHostIFkeyAttr->action & ADDKEY) {
@@ -1801,7 +1800,7 @@ static int Handle_Key(struct wilc_vif *vif,
 			result = wilc_send_config_pkt(vif->wilc, SET_CFG,
 						&wid, 1,
 						wilc_get_vif_idx(vif));
-		} else {
+		} else if (pstrHostIFkeyAttr->action & DEFAULTKEY) {
 			wid.id = (u16)WID_KEY_ID;
 			wid.type = WID_CHAR;
 			wid.val = (s8 *)&pstrHostIFkeyAttr->attr.wep.index;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index dbfcb3b..6e7f5d6 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -761,7 +761,6 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 		return s32Error;
 	}
 
-	priv->WILC_WFI_wep_default = 0;
 	memset(priv->WILC_WFI_wep_key, 0, sizeof(priv->WILC_WFI_wep_key));
 	memset(priv->WILC_WFI_wep_key_len, 0, sizeof(priv->WILC_WFI_wep_key_len));
 
@@ -788,7 +787,6 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 				for (i = 0; i < sme->key_len; i++)
 					PRINT_D(CORECONFIG_DBG, "WEP Key Value[%d] = %d\n", i, sme->key[i]);
 			}
-			priv->WILC_WFI_wep_default = sme->key_idx;
 			priv->WILC_WFI_wep_key_len[sme->key_idx] = sme->key_len;
 			memcpy(priv->WILC_WFI_wep_key[sme->key_idx], sme->key, sme->key_len);
 
@@ -806,7 +804,6 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 			pcgroup_encrypt_val = "WEP104";
 			pccipher_group = "WLAN_CIPHER_SUITE_WEP104";
 
-			priv->WILC_WFI_wep_default = sme->key_idx;
 			priv->WILC_WFI_wep_key_len[sme->key_idx] = sme->key_len;
 			memcpy(priv->WILC_WFI_wep_key[sme->key_idx], sme->key, sme->key_len);
 
@@ -986,7 +983,6 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 	case WLAN_CIPHER_SUITE_WEP40:
 	case WLAN_CIPHER_SUITE_WEP104:
 		if (priv->wdev->iftype == NL80211_IFTYPE_AP) {
-			priv->WILC_WFI_wep_default = key_index;
 			priv->WILC_WFI_wep_key_len[key_index] = params->key_len;
 			memcpy(priv->WILC_WFI_wep_key[key_index], params->key, params->key_len);
 
@@ -1009,7 +1005,6 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 			break;
 		}
 		if (memcmp(params->key, priv->WILC_WFI_wep_key[key_index], params->key_len)) {
-			priv->WILC_WFI_wep_default = key_index;
 			priv->WILC_WFI_wep_key_len[key_index] = params->key_len;
 			memcpy(priv->WILC_WFI_wep_key[key_index], params->key, params->key_len);
 
@@ -1336,9 +1331,7 @@ static int set_default_key(struct wiphy *wiphy, struct net_device *netdev, u8 ke
 
 	PRINT_D(CFG80211_DBG, "Setting default key with idx = %d\n", key_index);
 
-	if (key_index != priv->WILC_WFI_wep_default) {
-		wilc_set_wep_default_keyid(vif, key_index);
-	}
+	wilc_set_wep_default_keyid(vif, key_index);
 
 	return 0;
 }
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 9f8c79e..07eda4d 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -124,7 +124,6 @@ struct wilc_priv {
 	struct host_if_drv *hWILCWFIDrv;
 	struct host_if_pmkid_attr pmkid_list;
 	struct WILC_WFI_stats netstats;
-	u8 WILC_WFI_wep_default;
 	u8 WILC_WFI_wep_key[4][WLAN_KEY_LEN_WEP104];
 	u8 WILC_WFI_wep_key_len[4];
 	/* The real interface that the monitor is on */
-- 
1.9.1

