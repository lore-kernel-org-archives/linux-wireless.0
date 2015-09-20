Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:35621 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304AbbITGw3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Sep 2015 02:52:29 -0400
Received: by pacfv12 with SMTP id fv12so89104986pac.2
        for <linux-wireless@vger.kernel.org>; Sat, 19 Sep 2015 23:52:28 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 17/18] staging: wilc1000: rename WILC_WFI_DeInitHostInt
Date: Sun, 20 Sep 2015 15:51:24 +0900
Message-Id: <1442731885-4344-17-git-send-email-chaehyun.lim@gmail.com> (sfid-20150920_091655_725881_3F715ACE)
In-Reply-To: <1442731885-4344-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442731885-4344-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_DeInitHostInt with wilc_deinit_host_int to
avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/linux_wlan.c             | 6 +++---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.h | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index f71f7ea..181459f 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1434,7 +1434,7 @@ int mac_open(struct net_device *ndev)
 	ret = wilc1000_wlan_init(ndev, nic);
 	if (ret < 0) {
 		PRINT_ER("Failed to initialize wilc1000\n");
-		WILC_WFI_DeInitHostInt(ndev);
+		wilc_deinit_host_int(ndev);
 		return ret;
 	}
 
@@ -1471,7 +1471,7 @@ int mac_open(struct net_device *ndev)
 	return 0;
 
 _err_:
-	WILC_WFI_DeInitHostInt(ndev);
+	wilc_deinit_host_int(ndev);
 	wilc1000_wlan_deinit(g_linux_wlan);
 	return ret;
 }
@@ -1664,7 +1664,7 @@ int mac_close(struct net_device *ndev)
 		/* Stop the network interface queue */
 		netif_stop_queue(nic->wilc_netdev);
 
-		WILC_WFI_DeInitHostInt(nic->wilc_netdev);
+		wilc_deinit_host_int(nic->wilc_netdev);
 	}
 
 	if (g_linux_wlan->open_ifcs == 0) {
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index ee4cc7f..50e03f1 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -3641,7 +3641,7 @@ int WILC_WFI_InitHostInt(struct net_device *net)
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-int WILC_WFI_DeInitHostInt(struct net_device *net)
+int wilc_deinit_host_int(struct net_device *net)
 {
 	int s32Error = 0;
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
index 4730128..859d62a 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
@@ -95,7 +95,7 @@ struct wireless_dev *WILC_WFI_CfgAlloc(void);
 struct wireless_dev *wilc_create_wiphy(struct net_device *net);
 void wilc_free_wiphy(struct net_device *net);
 int WILC_WFI_update_stats(struct wiphy *wiphy, u32 pktlen, u8 changed);
-int WILC_WFI_DeInitHostInt(struct net_device *net);
+int wilc_deinit_host_int(struct net_device *net);
 int WILC_WFI_InitHostInt(struct net_device *net);
 void WILC_WFI_monitor_rx(u8 *buff, u32 size);
 int WILC_WFI_deinit_mon_interface(void);
-- 
2.5.1

