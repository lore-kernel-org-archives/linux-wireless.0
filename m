Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:34773 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbbITGvk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Sep 2015 02:51:40 -0400
Received: by padhy16 with SMTP id hy16so87429572pad.1
        for <linux-wireless@vger.kernel.org>; Sat, 19 Sep 2015 23:51:39 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 01/18] staging: wilc1000: rename WILC_WFI_WiphyFree
Date: Sun, 20 Sep 2015 15:51:08 +0900
Message-Id: <1442731885-4344-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20150920_085203_695712_C0EE0688)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_WiphyFree with wilc_free_wiphy to avoid
CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/linux_wlan.c             | 2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.h | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 6791012..ed6044e 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -2006,7 +2006,7 @@ static void __exit exit_wilc_driver(void)
 			PRINT_D(INIT_DBG, "Unregistering netdev %p\n", g_linux_wlan->strInterfaceInfo[i].wilc_netdev);
 			unregister_netdev(g_linux_wlan->strInterfaceInfo[i].wilc_netdev);
 			PRINT_D(INIT_DBG, "Freeing Wiphy...\n");
-			WILC_WFI_WiphyFree(g_linux_wlan->strInterfaceInfo[i].wilc_netdev);
+			wilc_free_wiphy(g_linux_wlan->strInterfaceInfo[i].wilc_netdev);
 			PRINT_D(INIT_DBG, "Freeing netdev...\n");
 			free_netdev(g_linux_wlan->strInterfaceInfo[i].wilc_netdev);
 		}
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 5a95b95..239d0fc 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -3689,7 +3689,7 @@ int WILC_WFI_DeInitHostInt(struct net_device *net)
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-void WILC_WFI_WiphyFree(struct net_device *net)
+void wilc_free_wiphy(struct net_device *net)
 {
 
 	PRINT_D(CFG80211_DBG, "Unregistering wiphy\n");
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
index 4d37c4e..67b8de3 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
@@ -93,7 +93,7 @@ static const struct ieee80211_txrx_stypes
 
 struct wireless_dev *WILC_WFI_CfgAlloc(void);
 struct wireless_dev *WILC_WFI_WiphyRegister(struct net_device *net);
-void WILC_WFI_WiphyFree(struct net_device *net);
+void wilc_free_wiphy(struct net_device *net);
 int WILC_WFI_update_stats(struct wiphy *wiphy, u32 pktlen, u8 changed);
 int WILC_WFI_DeInitHostInt(struct net_device *net);
 int WILC_WFI_InitHostInt(struct net_device *net);
-- 
2.5.1

