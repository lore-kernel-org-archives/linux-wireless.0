Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:51993 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbbJWF1f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2015 01:27:35 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 17/28] staging: wilc1000: wlan_deinitialize_threads: change argument and use wilc
Date: Fri, 23 Oct 2015 14:28:33 +0900
Message-ID: <1445578124-31486-17-git-send-email-glen.lee@atmel.com> (sfid-20151023_074658_805312_09634703)
In-Reply-To: <1445578124-31486-1-git-send-email-glen.lee@atmel.com>
References: <1445578124-31486-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes function parameter type struct wilc with struct net_device
and use netdev private data member wilc instead of g_linux_wlan.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index fef6664..75dad3e 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -96,7 +96,7 @@ static struct notifier_block g_dev_notifier = {
 static struct semaphore close_exit_sync;
 
 static int wlan_deinit_locks(struct wilc *wilc);
-static void wlan_deinitialize_threads(struct wilc *nic);
+static void wlan_deinitialize_threads(struct net_device *dev);
 extern void WILC_WFI_monitor_rx(u8 *buff, u32 size);
 extern void WILC_WFI_p2p_rx(struct net_device *dev, u8 *buff, u32 size);
 
@@ -918,7 +918,7 @@ void wilc1000_wlan_deinit(struct net_device *dev)
 			up(&wl->txq_event);
 
 		PRINT_D(INIT_DBG, "Deinitializing Threads\n");
-		wlan_deinitialize_threads(wl);
+		wlan_deinitialize_threads(dev);
 
 		PRINT_D(INIT_DBG, "Deinitializing IRQ\n");
 		deinit_irq(dev);
@@ -1046,18 +1046,23 @@ _fail_2:
 	return ret;
 }
 
-static void wlan_deinitialize_threads(struct wilc *nic)
+static void wlan_deinitialize_threads(struct net_device *dev)
 {
+	perInterface_wlan_t *nic;
+	struct wilc *wl;
+
+	nic = netdev_priv(dev);
+	wl = nic->wilc;
 
-	g_linux_wlan->close = 1;
+	wl->close = 1;
 	PRINT_D(INIT_DBG, "Deinitializing Threads\n");
 
-	if (&g_linux_wlan->txq_event != NULL)
-		up(&g_linux_wlan->txq_event);
+	if (&wl->txq_event != NULL)
+		up(&wl->txq_event);
 
-	if (g_linux_wlan->txq_thread != NULL) {
-		kthread_stop(g_linux_wlan->txq_thread);
-		g_linux_wlan->txq_thread = NULL;
+	if (wl->txq_thread != NULL) {
+		kthread_stop(wl->txq_thread);
+		wl->txq_thread = NULL;
 	}
 }
 
@@ -1164,7 +1169,7 @@ _fail_irq_init_:
 		deinit_irq(dev);
 
 #endif
-		wlan_deinitialize_threads(wl);
+		wlan_deinitialize_threads(dev);
 _fail_wilc_wlan_:
 		wilc_wlan_cleanup();
 _fail_locks_:
-- 
1.9.1

