Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:33095 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886AbbITGvz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Sep 2015 02:51:55 -0400
Received: by pacex6 with SMTP id ex6so87538281pac.0
        for <linux-wireless@vger.kernel.org>; Sat, 19 Sep 2015 23:51:54 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 06/18] staging: wilc1000: replace PRINT_D with netdev_info
Date: Sun, 20 Sep 2015 15:51:13 +0900
Message-Id: <1442731885-4344-6-git-send-email-chaehyun.lim@gmail.com> (sfid-20150920_085213_117151_B2A35A1E)
In-Reply-To: <1442731885-4344-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442731885-4344-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces PRINT_D with netdev_info in wilc_free_wiphy function.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index fbe8643..216da0c 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -3691,7 +3691,7 @@ int WILC_WFI_DeInitHostInt(struct net_device *net)
  */
 void wilc_free_wiphy(struct net_device *net)
 {
-	PRINT_D(CFG80211_DBG, "Unregistering wiphy\n");
+	netdev_info(net, "Unregistering wiphy\n");
 
 	if (!net) {
 		PRINT_D(INIT_DBG, "net_device is NULL\n");
@@ -3710,7 +3710,7 @@ void wilc_free_wiphy(struct net_device *net)
 
 	wiphy_unregister(net->ieee80211_ptr->wiphy);
 
-	PRINT_D(INIT_DBG, "Freeing wiphy\n");
+	netdev_info(net, "Freeing wiphy\n");
 	wiphy_free(net->ieee80211_ptr->wiphy);
 	kfree(net->ieee80211_ptr);
 }
-- 
2.5.1

