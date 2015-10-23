Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:51953 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbbJWF1X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2015 01:27:23 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 15/28] staging: wilc1000: wlan_deinit_locks: rename argument name and use it
Date: Fri, 23 Oct 2015 14:28:31 +0900
Message-ID: <1445578124-31486-15-git-send-email-glen.lee@atmel.com> (sfid-20151023_074655_756116_4A0EF434)
In-Reply-To: <1445578124-31486-1-git-send-email-glen.lee@atmel.com>
References: <1445578124-31486-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames nic to wilc and use it instead of g_linux_wlan.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 4f9663d..2f1543d 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -95,7 +95,7 @@ static struct notifier_block g_dev_notifier = {
  */
 static struct semaphore close_exit_sync;
 
-static int wlan_deinit_locks(struct wilc *nic);
+static int wlan_deinit_locks(struct wilc *wilc);
 static void wlan_deinitialize_threads(struct wilc *nic);
 extern void WILC_WFI_monitor_rx(u8 *buff, u32 size);
 extern void WILC_WFI_p2p_rx(struct net_device *dev, u8 *buff, u32 size);
@@ -977,14 +977,14 @@ int wlan_init_locks(struct net_device *dev)
 	return 0;
 }
 
-static int wlan_deinit_locks(struct wilc *nic)
+static int wlan_deinit_locks(struct wilc *wilc)
 {
 	PRINT_D(INIT_DBG, "De-Initializing Locks\n");
 
-	if (&g_linux_wlan->hif_cs != NULL)
+	if (&wilc->hif_cs != NULL)
 		mutex_destroy(&g_linux_wlan->hif_cs);
 
-	if (&g_linux_wlan->rxq_cs != NULL)
+	if (&wilc->rxq_cs != NULL)
 		mutex_destroy(&g_linux_wlan->rxq_cs);
 
 	return 0;
-- 
1.9.1

