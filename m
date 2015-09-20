Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:33871 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754029AbbITGv6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Sep 2015 02:51:58 -0400
Received: by padhy16 with SMTP id hy16so87432980pad.1
        for <linux-wireless@vger.kernel.org>; Sat, 19 Sep 2015 23:51:58 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 07/18] staging: wilc1000: replaces PRINT_D with netdev_err
Date: Sun, 20 Sep 2015 15:51:14 +0900
Message-Id: <1442731885-4344-7-git-send-email-chaehyun.lim@gmail.com> (sfid-20150920_085215_172248_F86B2818)
In-Reply-To: <1442731885-4344-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442731885-4344-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces PRINT_D with netdev_err which is used at error
checking.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 216da0c..bf9d9ee 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -3694,17 +3694,17 @@ void wilc_free_wiphy(struct net_device *net)
 	netdev_info(net, "Unregistering wiphy\n");
 
 	if (!net) {
-		PRINT_D(INIT_DBG, "net_device is NULL\n");
+		netdev_err(net, "net_device is NULL\n");
 		return;
 	}
 
 	if (!net->ieee80211_ptr) {
-		PRINT_D(INIT_DBG, "ieee80211_ptr is NULL\n");
+		netdev_err(net, "ieee80211_ptr is NULL\n");
 		return;
 	}
 
 	if (!net->ieee80211_ptr->wiphy) {
-		PRINT_D(INIT_DBG, "wiphy is NULL\n");
+		netdev_err(net, "wiphy is NULL\n");
 		return;
 	}
 
-- 
2.5.1

