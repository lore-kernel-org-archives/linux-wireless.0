Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:35334 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139AbbIHP4W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2015 11:56:22 -0400
Received: by pacfv12 with SMTP id fv12so130434958pac.2
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2015 08:56:21 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 04/30] staging: wilc1000: rename WILC_WFI_add_key
Date: Wed,  9 Sep 2015 00:55:41 +0900
Message-Id: <1441727767-26026-4-git-send-email-chaehyun.lim@gmail.com> (sfid-20150908_175624_633864_23F33C07)
In-Reply-To: <1441727767-26026-1-git-send-email-chaehyun.lim@gmail.com>
References: <1441727767-26026-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_add_key with wilc_cfg80211_add_key to avoid
CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 563841f..0714034 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1112,7 +1112,7 @@ static int WILC_WFI_disconnect(struct wiphy *wiphy, struct net_device *dev, u16
 }
 
 /**
- *  @brief      WILC_WFI_add_key
+ *  @brief      wilc_cfg80211_add_key
  *  @details    Add a key with the given parameters. @mac_addr will be %NULL
  *                      when adding a group key.
  *  @param[in] key : key buffer; TKIP: 16-byte temporal key, 8-byte Tx Mic key, 8-byte Rx Mic Key
@@ -1121,7 +1121,7 @@ static int WILC_WFI_disconnect(struct wiphy *wiphy, struct net_device *dev, u16
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-static int WILC_WFI_add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
+static int wilc_cfg80211_add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 			    bool pairwise,
 			    const u8 *mac_addr, struct key_params *params)
 
@@ -2932,14 +2932,14 @@ static int WILC_WFI_change_virt_intf(struct wiphy *wiphy, struct net_device *dev
 				PRINT_D(CFG80211_DBG, "gtk %x %x %x\n", g_key_gtk_params.key[0],
 					g_key_gtk_params.key[1],
 					g_key_gtk_params.key[2]);
-				WILC_WFI_add_key(g_linux_wlan->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
+				wilc_cfg80211_add_key(g_linux_wlan->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
 						 g_linux_wlan->strInterfaceInfo[0].wilc_netdev,
 						 g_add_ptk_key_params.key_idx,
 						 g_add_ptk_key_params.pairwise,
 						 g_add_ptk_key_params.mac_addr,
 						 (struct key_params *)(&g_key_ptk_params));
 
-				WILC_WFI_add_key(g_linux_wlan->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
+				wilc_cfg80211_add_key(g_linux_wlan->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
 						 g_linux_wlan->strInterfaceInfo[0].wilc_netdev,
 						 g_add_gtk_key_params.key_idx,
 						 g_add_gtk_key_params.pairwise,
@@ -3018,14 +3018,14 @@ static int WILC_WFI_change_virt_intf(struct wiphy *wiphy, struct net_device *dev
 				PRINT_D(CFG80211_DBG, "gtk %x %x %x\n", g_key_gtk_params.key[0],
 					g_key_gtk_params.key[1],
 					g_key_gtk_params.key[2]);
-				WILC_WFI_add_key(g_linux_wlan->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
+				wilc_cfg80211_add_key(g_linux_wlan->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
 						 g_linux_wlan->strInterfaceInfo[0].wilc_netdev,
 						 g_add_ptk_key_params.key_idx,
 						 g_add_ptk_key_params.pairwise,
 						 g_add_ptk_key_params.mac_addr,
 						 (struct key_params *)(&g_key_ptk_params));
 
-				WILC_WFI_add_key(g_linux_wlan->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
+				wilc_cfg80211_add_key(g_linux_wlan->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
 						 g_linux_wlan->strInterfaceInfo[0].wilc_netdev,
 						 g_add_gtk_key_params.key_idx,
 						 g_add_gtk_key_params.pairwise,
@@ -3149,14 +3149,14 @@ static int WILC_WFI_change_virt_intf(struct wiphy *wiphy, struct net_device *dev
 				g_key_gtk_params.key[2],
 				g_key_gtk_params.cipher);
 			#if 1
-			WILC_WFI_add_key(g_linux_wlan->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
+			wilc_cfg80211_add_key(g_linux_wlan->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
 					 g_linux_wlan->strInterfaceInfo[0].wilc_netdev,
 					 g_add_ptk_key_params.key_idx,
 					 g_add_ptk_key_params.pairwise,
 					 g_add_ptk_key_params.mac_addr,
 					 (struct key_params *)(&g_key_ptk_params));
 
-			WILC_WFI_add_key(g_linux_wlan->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
+			wilc_cfg80211_add_key(g_linux_wlan->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
 					 g_linux_wlan->strInterfaceInfo[0].wilc_netdev,
 					 g_add_gtk_key_params.key_idx,
 					 g_add_gtk_key_params.pairwise,
@@ -3607,7 +3607,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	.scan = wilc_cfg80211_scan,
 	.connect = wilc_cfg80211_connect,
 	.disconnect = WILC_WFI_disconnect,
-	.add_key = WILC_WFI_add_key,
+	.add_key = wilc_cfg80211_add_key,
 	.del_key = WILC_WFI_del_key,
 	.get_key = WILC_WFI_get_key,
 	.set_default_key = WILC_WFI_set_default_key,
-- 
2.5.1

