Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:36565 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754336AbbINDYv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Sep 2015 23:24:51 -0400
Received: by padhk3 with SMTP id hk3so129779173pad.3
        for <linux-wireless@vger.kernel.org>; Sun, 13 Sep 2015 20:24:51 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V3 05/31] staging: wilc1000: rename WILC_WFI_add_key
Date: Mon, 14 Sep 2015 12:24:05 +0900
Message-Id: <1442201071-16155-5-git-send-email-chaehyun.lim@gmail.com> (sfid-20150914_052456_614388_E2F21303)
In-Reply-To: <1442201071-16155-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442201071-16155-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_add_key with add_key to avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V3: remove "wilc_" prefix

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 88 +++++++++++------------
 1 file changed, 44 insertions(+), 44 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 1ebaaef..b5e6176 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1112,7 +1112,7 @@ static int disconnect(struct wiphy *wiphy, struct net_device *dev, u16 reason_co
 }
 
 /**
- *  @brief      WILC_WFI_add_key
+ *  @brief      add_key
  *  @details    Add a key with the given parameters. @mac_addr will be %NULL
  *                      when adding a group key.
  *  @param[in] key : key buffer; TKIP: 16-byte temporal key, 8-byte Tx Mic key, 8-byte Rx Mic Key
@@ -1121,9 +1121,9 @@ static int disconnect(struct wiphy *wiphy, struct net_device *dev, u16 reason_co
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-static int WILC_WFI_add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
-			    bool pairwise,
-			    const u8 *mac_addr, struct key_params *params)
+static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
+		   bool pairwise,
+		   const u8 *mac_addr, struct key_params *params)
 
 {
 	s32 s32Error = WILC_SUCCESS, KeyLen = params->key_len;
@@ -2933,19 +2933,19 @@ static int WILC_WFI_change_virt_intf(struct wiphy *wiphy, struct net_device *dev
 				PRINT_D(CFG80211_DBG, "gtk %x %x %x\n", g_key_gtk_params.key[0],
 					g_key_gtk_params.key[1],
 					g_key_gtk_params.key[2]);
-				WILC_WFI_add_key(g_linux_wlan->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
-						 g_linux_wlan->strInterfaceInfo[0].wilc_netdev,
-						 g_add_ptk_key_params.key_idx,
-						 g_add_ptk_key_params.pairwise,
-						 g_add_ptk_key_params.mac_addr,
-						 (struct key_params *)(&g_key_ptk_params));
-
-				WILC_WFI_add_key(g_linux_wlan->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
-						 g_linux_wlan->strInterfaceInfo[0].wilc_netdev,
-						 g_add_gtk_key_params.key_idx,
-						 g_add_gtk_key_params.pairwise,
-						 g_add_gtk_key_params.mac_addr,
-						 (struct key_params *)(&g_key_gtk_params));
+				add_key(g_linux_wlan->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
+					g_linux_wlan->strInterfaceInfo[0].wilc_netdev,
+					g_add_ptk_key_params.key_idx,
+					g_add_ptk_key_params.pairwise,
+					g_add_ptk_key_params.mac_addr,
+					(struct key_params *)(&g_key_ptk_params));
+
+				add_key(g_linux_wlan->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
+					g_linux_wlan->strInterfaceInfo[0].wilc_netdev,
+					g_add_gtk_key_params.key_idx,
+					g_add_gtk_key_params.pairwise,
+					g_add_gtk_key_params.mac_addr,
+					(struct key_params *)(&g_key_gtk_params));
 			}
 
 			/*BugID_4847: registered frames in firmware are now*/
@@ -3019,19 +3019,19 @@ static int WILC_WFI_change_virt_intf(struct wiphy *wiphy, struct net_device *dev
 				PRINT_D(CFG80211_DBG, "gtk %x %x %x\n", g_key_gtk_params.key[0],
 					g_key_gtk_params.key[1],
 					g_key_gtk_params.key[2]);
-				WILC_WFI_add_key(g_linux_wlan->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
-						 g_linux_wlan->strInterfaceInfo[0].wilc_netdev,
-						 g_add_ptk_key_params.key_idx,
-						 g_add_ptk_key_params.pairwise,
-						 g_add_ptk_key_params.mac_addr,
-						 (struct key_params *)(&g_key_ptk_params));
-
-				WILC_WFI_add_key(g_linux_wlan->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
-						 g_linux_wlan->strInterfaceInfo[0].wilc_netdev,
-						 g_add_gtk_key_params.key_idx,
-						 g_add_gtk_key_params.pairwise,
-						 g_add_gtk_key_params.mac_addr,
-						 (struct key_params *)(&g_key_gtk_params));
+				add_key(g_linux_wlan->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
+					g_linux_wlan->strInterfaceInfo[0].wilc_netdev,
+					g_add_ptk_key_params.key_idx,
+					g_add_ptk_key_params.pairwise,
+					g_add_ptk_key_params.mac_addr,
+					(struct key_params *)(&g_key_ptk_params));
+
+				add_key(g_linux_wlan->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
+					g_linux_wlan->strInterfaceInfo[0].wilc_netdev,
+					g_add_gtk_key_params.key_idx,
+					g_add_gtk_key_params.pairwise,
+					g_add_gtk_key_params.mac_addr,
+					(struct key_params *)(&g_key_gtk_params));
 			}
 
 			/*Refresh scan, to refresh the scan results to the wpa_supplicant. Set MachHw to false to enable further key installments*/
@@ -3150,19 +3150,19 @@ static int WILC_WFI_change_virt_intf(struct wiphy *wiphy, struct net_device *dev
 				g_key_gtk_params.key[2],
 				g_key_gtk_params.cipher);
 			#if 1
-			WILC_WFI_add_key(g_linux_wlan->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
-					 g_linux_wlan->strInterfaceInfo[0].wilc_netdev,
-					 g_add_ptk_key_params.key_idx,
-					 g_add_ptk_key_params.pairwise,
-					 g_add_ptk_key_params.mac_addr,
-					 (struct key_params *)(&g_key_ptk_params));
-
-			WILC_WFI_add_key(g_linux_wlan->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
-					 g_linux_wlan->strInterfaceInfo[0].wilc_netdev,
-					 g_add_gtk_key_params.key_idx,
-					 g_add_gtk_key_params.pairwise,
-					 g_add_gtk_key_params.mac_addr,
-					 (struct key_params *)(&g_key_gtk_params));
+			add_key(g_linux_wlan->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
+				g_linux_wlan->strInterfaceInfo[0].wilc_netdev,
+				g_add_ptk_key_params.key_idx,
+				g_add_ptk_key_params.pairwise,
+				g_add_ptk_key_params.mac_addr,
+				(struct key_params *)(&g_key_ptk_params));
+
+			add_key(g_linux_wlan->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
+				g_linux_wlan->strInterfaceInfo[0].wilc_netdev,
+				g_add_gtk_key_params.key_idx,
+				g_add_gtk_key_params.pairwise,
+				g_add_gtk_key_params.mac_addr,
+				(struct key_params *)(&g_key_gtk_params));
 			#endif
 		}
 		#endif
@@ -3562,7 +3562,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	.scan = scan,
 	.connect = connect,
 	.disconnect = disconnect,
-	.add_key = WILC_WFI_add_key,
+	.add_key = add_key,
 	.del_key = WILC_WFI_del_key,
 	.get_key = WILC_WFI_get_key,
 	.set_default_key = WILC_WFI_set_default_key,
-- 
2.5.1

