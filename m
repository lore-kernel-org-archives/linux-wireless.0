Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:33857 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbbIJTOy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2015 15:14:54 -0400
Received: by padhy16 with SMTP id hy16so50949080pad.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2015 12:14:54 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 05/31] staging: wilc1000: rename WILC_WFI_add_key
Date: Fri, 11 Sep 2015 04:14:04 +0900
Message-Id: <1441912470-3371-5-git-send-email-chaehyun.lim@gmail.com> (sfid-20150910_211458_228448_19FA6F51)
In-Reply-To: <1441912470-3371-1-git-send-email-chaehyun.lim@gmail.com>
References: <1441912470-3371-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_add_key with wilc_add_key to avoid
CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V2: to make function name simple

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index e301372..db327f7 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1112,7 +1112,7 @@ static int wilc_disconnect(struct wiphy *wiphy, struct net_device *dev, u16 reas
 }
 
 /**
- *  @brief      WILC_WFI_add_key
+ *  @brief      wilc_add_key
  *  @details    Add a key with the given parameters. @mac_addr will be %NULL
  *                      when adding a group key.
  *  @param[in] key : key buffer; TKIP: 16-byte temporal key, 8-byte Tx Mic key, 8-byte Rx Mic Key
@@ -1121,9 +1121,9 @@ static int wilc_disconnect(struct wiphy *wiphy, struct net_device *dev, u16 reas
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-static int WILC_WFI_add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
-			    bool pairwise,
-			    const u8 *mac_addr, struct key_params *params)
+static int wilc_add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
+			bool pairwise,
+			const u8 *mac_addr, struct key_params *params)
 
 {
 	s32 s32Error = WILC_SUCCESS, KeyLen = params->key_len;
@@ -2933,14 +2933,14 @@ static int WILC_WFI_change_virt_intf(struct wiphy *wiphy, struct net_device *dev
 				PRINT_D(CFG80211_DBG, "gtk %x %x %x\n", g_key_gtk_params.key[0],
 					g_key_gtk_params.key[1],
 					g_key_gtk_params.key[2]);
-				WILC_WFI_add_key(g_linux_wlan->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
+				wilc_add_key(g_linux_wlan->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
 						 g_linux_wlan->strInterfaceInfo[0].wilc_netdev,
 						 g_add_ptk_key_params.key_idx,
 						 g_add_ptk_key_params.pairwise,
 						 g_add_ptk_key_params.mac_addr,
 						 (struct key_params *)(&g_key_ptk_params));
 
-				WILC_WFI_add_key(g_linux_wlan->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
+				wilc_add_key(g_linux_wlan->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
 						 g_linux_wlan->strInterfaceInfo[0].wilc_netdev,
 						 g_add_gtk_key_params.key_idx,
 						 g_add_gtk_key_params.pairwise,
@@ -3019,14 +3019,14 @@ static int WILC_WFI_change_virt_intf(struct wiphy *wiphy, struct net_device *dev
 				PRINT_D(CFG80211_DBG, "gtk %x %x %x\n", g_key_gtk_params.key[0],
 					g_key_gtk_params.key[1],
 					g_key_gtk_params.key[2]);
-				WILC_WFI_add_key(g_linux_wlan->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
+				wilc_add_key(g_linux_wlan->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
 						 g_linux_wlan->strInterfaceInfo[0].wilc_netdev,
 						 g_add_ptk_key_params.key_idx,
 						 g_add_ptk_key_params.pairwise,
 						 g_add_ptk_key_params.mac_addr,
 						 (struct key_params *)(&g_key_ptk_params));
 
-				WILC_WFI_add_key(g_linux_wlan->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
+				wilc_add_key(g_linux_wlan->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
 						 g_linux_wlan->strInterfaceInfo[0].wilc_netdev,
 						 g_add_gtk_key_params.key_idx,
 						 g_add_gtk_key_params.pairwise,
@@ -3150,14 +3150,14 @@ static int WILC_WFI_change_virt_intf(struct wiphy *wiphy, struct net_device *dev
 				g_key_gtk_params.key[2],
 				g_key_gtk_params.cipher);
 			#if 1
-			WILC_WFI_add_key(g_linux_wlan->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
+			wilc_add_key(g_linux_wlan->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
 					 g_linux_wlan->strInterfaceInfo[0].wilc_netdev,
 					 g_add_ptk_key_params.key_idx,
 					 g_add_ptk_key_params.pairwise,
 					 g_add_ptk_key_params.mac_addr,
 					 (struct key_params *)(&g_key_ptk_params));
 
-			WILC_WFI_add_key(g_linux_wlan->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
+			wilc_add_key(g_linux_wlan->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
 					 g_linux_wlan->strInterfaceInfo[0].wilc_netdev,
 					 g_add_gtk_key_params.key_idx,
 					 g_add_gtk_key_params.pairwise,
@@ -3562,7 +3562,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	.scan = wilc_scan,
 	.connect = wilc_connect,
 	.disconnect = wilc_disconnect,
-	.add_key = WILC_WFI_add_key,
+	.add_key = wilc_add_key,
 	.del_key = WILC_WFI_del_key,
 	.get_key = WILC_WFI_get_key,
 	.set_default_key = WILC_WFI_set_default_key,
-- 
2.5.1

