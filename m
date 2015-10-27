Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:58203 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbbJ0J01 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2015 05:26:27 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 14/27] staging: wilc1000: wlan_deinit_locks: change argument wilc with net_device
Date: Tue, 27 Oct 2015 18:27:50 +0900
Message-ID: <1445938083-20445-14-git-send-email-glen.lee@atmel.com> (sfid-20151027_102630_080037_A788E831)
In-Reply-To: <1445938083-20445-1-git-send-email-glen.lee@atmel.com>
References: <1445938083-20445-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes argument wilc with net_device and use netdev private data
member wilc instead of g_linux_wlan.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index d9f1bf1..c0fac3cd 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -95,7 +95,7 @@ static struct notifier_block g_dev_notifier = {
  */
 static struct semaphore close_exit_sync;
 
-static int wlan_deinit_locks(struct wilc *nic);
+static int wlan_deinit_locks(struct net_device *dev);
 static void wlan_deinitialize_threads(struct wilc *nic);
 extern void WILC_WFI_monitor_rx(u8 *buff, u32 size);
 extern void WILC_WFI_p2p_rx(struct net_device *dev, u8 *buff, u32 size);
@@ -940,7 +940,7 @@ void wilc1000_wlan_deinit(struct net_device *dev)
 
 		/*De-Initialize locks*/
 		PRINT_D(INIT_DBG, "Deinitializing Locks\n");
-		wlan_deinit_locks(wl);
+		wlan_deinit_locks(dev);
 
 		/* announce that wilc1000 is not initialized */
 		wl->initialized = false;
@@ -978,15 +978,21 @@ int wlan_init_locks(struct net_device *dev)
 	return 0;
 }
 
-static int wlan_deinit_locks(struct wilc *nic)
+static int wlan_deinit_locks(struct net_device *dev)
 {
+	perInterface_wlan_t *nic;
+	struct wilc *wilc;
+
+	nic = netdev_priv(dev);
+	wilc = nic->wilc;
+
 	PRINT_D(INIT_DBG, "De-Initializing Locks\n");
 
-	if (&g_linux_wlan->hif_cs != NULL)
-		mutex_destroy(&g_linux_wlan->hif_cs);
+	if (&wilc->hif_cs != NULL)
+		mutex_destroy(&wilc->hif_cs);
 
-	if (&g_linux_wlan->rxq_cs != NULL)
-		mutex_destroy(&g_linux_wlan->rxq_cs);
+	if (&wilc->rxq_cs != NULL)
+		mutex_destroy(&wilc->rxq_cs);
 
 	return 0;
 }
@@ -1169,7 +1175,7 @@ _fail_irq_init_:
 _fail_wilc_wlan_:
 		wilc_wlan_cleanup();
 _fail_locks_:
-		wlan_deinit_locks(wl);
+		wlan_deinit_locks(dev);
 		PRINT_ER("WLAN Iinitialization FAILED\n");
 	} else {
 		PRINT_D(INIT_DBG, "wilc1000 already initialized\n");
-- 
1.9.1

