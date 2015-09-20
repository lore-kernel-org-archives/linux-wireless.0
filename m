Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:33352 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755441AbbITGwc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Sep 2015 02:52:32 -0400
Received: by pacex6 with SMTP id ex6so87545505pac.0
        for <linux-wireless@vger.kernel.org>; Sat, 19 Sep 2015 23:52:31 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 18/18] staging: wilc1000: rename WILC_WFI_InitHostInt
Date: Sun, 20 Sep 2015 15:51:25 +0900
Message-Id: <1442731885-4344-18-git-send-email-chaehyun.lim@gmail.com> (sfid-20150920_091655_139070_029B6294)
In-Reply-To: <1442731885-4344-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442731885-4344-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_InitHostInt with wilc_init_host_int to
avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/linux_wlan.c             | 2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.h | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 181459f..7857ad2 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1422,7 +1422,7 @@ int mac_open(struct net_device *ndev)
 	priv = wiphy_priv(nic->wilc_netdev->ieee80211_ptr->wiphy);
 	PRINT_D(INIT_DBG, "MAC OPEN[%p]\n", ndev);
 
-	ret = WILC_WFI_InitHostInt(ndev);
+	ret = wilc_init_host_int(ndev);
 	if (ret < 0) {
 		PRINT_ER("Failed to initialize host interface\n");
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 50e03f1..a44d8a0 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -3599,7 +3599,7 @@ struct wireless_dev *wilc_create_wiphy(struct net_device *net)
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-int WILC_WFI_InitHostInt(struct net_device *net)
+int wilc_init_host_int(struct net_device *net)
 {
 
 	int s32Error = 0;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
index 859d62a..b240a79 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
@@ -96,7 +96,7 @@ struct wireless_dev *wilc_create_wiphy(struct net_device *net);
 void wilc_free_wiphy(struct net_device *net);
 int WILC_WFI_update_stats(struct wiphy *wiphy, u32 pktlen, u8 changed);
 int wilc_deinit_host_int(struct net_device *net);
-int WILC_WFI_InitHostInt(struct net_device *net);
+int wilc_init_host_int(struct net_device *net);
 void WILC_WFI_monitor_rx(u8 *buff, u32 size);
 int WILC_WFI_deinit_mon_interface(void);
 struct net_device *WILC_WFI_init_mon_interface(const char *name, struct net_device *real_dev);
-- 
2.5.1

