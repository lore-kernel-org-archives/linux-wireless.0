Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:36262 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbbJZApE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Oct 2015 20:45:04 -0400
Received: by pacfv9 with SMTP id fv9so177827259pac.3
        for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2015 17:45:04 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 4/4] staging: wilc1000: rename host_int_set_WEPDefaultKeyID
Date: Mon, 26 Oct 2015 09:44:45 +0900
Message-Id: <1445820285-14433-4-git-send-email-chaehyun.lim@gmail.com> (sfid-20151026_014509_336158_B3AA4C9D)
In-Reply-To: <1445820285-14433-1-git-send-email-chaehyun.lim@gmail.com>
References: <1445820285-14433-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces host_int_set_WEPDefaultKeyID with
host_int_set_wep_default_key to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c         |  2 +-
 drivers/staging/wilc1000/host_interface.h         |  2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 12 ++++++------
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 4f1af61..e5ffe52 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3128,7 +3128,7 @@ int host_int_remove_wep_key(struct host_if_drv *hif_drv, u8 index)
 	return result;
 }
 
-int host_int_set_WEPDefaultKeyID(struct host_if_drv *hif_drv, u8 index)
+int host_int_set_wep_default_key(struct host_if_drv *hif_drv, u8 index)
 {
 	int result = 0;
 	struct host_if_msg msg;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index ea91bbf..f3fb628 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -384,7 +384,7 @@ int host_int_remove_wep_key(struct host_if_drv *wfi_drv, u8 index);
  *  @date		8 March 2012
  *  @version		1.0
  */
-int host_int_set_WEPDefaultKeyID(struct host_if_drv *hif_drv, u8 index);
+int host_int_set_wep_default_key(struct host_if_drv *hif_drv, u8 index);
 
 /**
  *  @brief              sets WEP deafault key
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 5559aa6..ac32d2b 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -892,7 +892,7 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 			g_key_wep_params.key_idx = sme->key_idx;
 			g_wep_keys_saved = true;
 
-			host_int_set_WEPDefaultKeyID(priv->hWILCWFIDrv, sme->key_idx);
+			host_int_set_wep_default_key(priv->hWILCWFIDrv, sme->key_idx);
 			host_int_add_wep_key_bss_sta(priv->hWILCWFIDrv, sme->key, sme->key_len, sme->key_idx);
 		} else if (sme->crypto.cipher_group == WLAN_CIPHER_SUITE_WEP104)   {
 			u8security = ENCRYPT_ENABLED | WEP | WEP_EXTENDED;
@@ -909,7 +909,7 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 			g_key_wep_params.key_idx = sme->key_idx;
 			g_wep_keys_saved = true;
 
-			host_int_set_WEPDefaultKeyID(priv->hWILCWFIDrv, sme->key_idx);
+			host_int_set_wep_default_key(priv->hWILCWFIDrv, sme->key_idx);
 			host_int_add_wep_key_bss_sta(priv->hWILCWFIDrv, sme->key, sme->key_len, sme->key_idx);
 		} else if (sme->crypto.wpa_versions & NL80211_WPA_VERSION_2)   {
 			if (sme->crypto.cipher_group == WLAN_CIPHER_SUITE_TKIP)	{
@@ -1502,7 +1502,7 @@ static int set_default_key(struct wiphy *wiphy, struct net_device *netdev, u8 ke
 
 	if (key_index != priv->WILC_WFI_wep_default) {
 
-		host_int_set_WEPDefaultKeyID(priv->hWILCWFIDrv, key_index);
+		host_int_set_wep_default_key(priv->hWILCWFIDrv, key_index);
 	}
 
 	return 0;
@@ -2605,7 +2605,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 
 			/*Add saved WEP keys, if any*/
 			if (g_wep_keys_saved) {
-				host_int_set_WEPDefaultKeyID(wl->vif[0].hif_drv,
+				host_int_set_wep_default_key(wl->vif[0].hif_drv,
 							     g_key_wep_params.key_idx);
 				host_int_add_wep_key_bss_sta(wl->vif[0].hif_drv,
 							     g_key_wep_params.key,
@@ -2687,7 +2687,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 
 			/*Add saved WEP keys, if any*/
 			if (g_wep_keys_saved) {
-				host_int_set_WEPDefaultKeyID(wl->vif[0].hif_drv,
+				host_int_set_wep_default_key(wl->vif[0].hif_drv,
 							     g_key_wep_params.key_idx);
 				host_int_add_wep_key_bss_sta(wl->vif[0].hif_drv,
 							     g_key_wep_params.key,
@@ -2803,7 +2803,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 
 		/*Add saved WEP keys, if any*/
 		if (g_wep_keys_saved) {
-			host_int_set_WEPDefaultKeyID(wl->vif[0].hif_drv,
+			host_int_set_wep_default_key(wl->vif[0].hif_drv,
 						     g_key_wep_params.key_idx);
 			host_int_add_wep_key_bss_sta(wl->vif[0].hif_drv,
 						     g_key_wep_params.key,
-- 
2.6.1

