Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:51883 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbbJWF1A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2015 01:27:00 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 11/28] staging: wilc1000: linux_wlan_txq_task: use wilc instead of g_linux_wlan
Date: Fri, 23 Oct 2015 14:28:27 +0900
Message-ID: <1445578124-31486-11-git-send-email-glen.lee@atmel.com> (sfid-20151023_074656_141969_FE44A7F1)
In-Reply-To: <1445578124-31486-1-git-send-email-glen.lee@atmel.com>
References: <1445578124-31486-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pass argument dev instead of wilc from kthread_run and use netdev private data
member wilc instead of g_linux_wlan.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index f6862d5..9c4fecb 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -439,7 +439,9 @@ int linux_wlan_get_num_conn_ifcs(void)
 static int linux_wlan_txq_task(void *vp)
 {
 	int ret, txq_count;
-
+	perInterface_wlan_t *nic;
+	struct wilc *wl;
+	struct net_device *dev = vp;
 #if defined USE_TX_BACKOFF_DELAY_IF_NO_BUFFERS
 #define TX_BACKOFF_WEIGHT_INCR_STEP (1)
 #define TX_BACKOFF_WEIGHT_DECR_STEP (1)
@@ -449,18 +451,21 @@ static int linux_wlan_txq_task(void *vp)
 	int backoff_weight = TX_BACKOFF_WEIGHT_MIN;
 #endif
 
+	nic = netdev_priv(dev);
+	wl = nic->wilc;
+
 	/* inform wilc1000_wlan_init that TXQ task is started. */
-	up(&g_linux_wlan->txq_thread_started);
+	up(&wl->txq_thread_started);
 	while (1) {
 
 		PRINT_D(TX_DBG, "txq_task Taking a nap :)\n");
-		down(&g_linux_wlan->txq_event);
+		down(&wl->txq_event);
 		/* wait_for_completion(&pd->txq_event); */
 		PRINT_D(TX_DBG, "txq_task Who waked me up :$\n");
 
-		if (g_linux_wlan->close) {
+		if (wl->close) {
 			/*Unlock the mutex in the mac_close function to indicate the exiting of the TX thread */
-			up(&g_linux_wlan->txq_thread_started);
+			up(&wl->txq_thread_started);
 
 			while (!kthread_should_stop())
 				schedule();
@@ -477,10 +482,10 @@ static int linux_wlan_txq_task(void *vp)
 			if (txq_count < FLOW_CONTROL_LOWER_THRESHOLD /* && netif_queue_stopped(pd->wilc_netdev)*/) {
 				PRINT_D(TX_DBG, "Waking up queue\n");
 				/* netif_wake_queue(pd->wilc_netdev); */
-				if (netif_queue_stopped(g_linux_wlan->vif[0].ndev))
-					netif_wake_queue(g_linux_wlan->vif[0].ndev);
-				if (netif_queue_stopped(g_linux_wlan->vif[1].ndev))
-					netif_wake_queue(g_linux_wlan->vif[1].ndev);
+				if (netif_queue_stopped(wl->vif[0].ndev))
+					netif_wake_queue(wl->vif[0].ndev);
+				if (netif_queue_stopped(wl->vif[1].ndev))
+					netif_wake_queue(wl->vif[1].ndev);
 			}
 
 			if (ret == WILC_TX_ERR_NO_BUF) { /* failed to allocate buffers in chip. */
@@ -502,7 +507,7 @@ static int linux_wlan_txq_task(void *vp)
 				}
 			}
 			/*TODO: drop packets after a certain time/number of retry count. */
-		} while (ret == WILC_TX_ERR_NO_BUF && !g_linux_wlan->close); /* retry sending packets if no more buffers in chip. */
+		} while (ret == WILC_TX_ERR_NO_BUF && !wl->close); /* retry sending packets if no more buffers in chip. */
 #endif
 	}
 	return 0;
@@ -1023,7 +1028,7 @@ int wlan_initialize_threads(struct net_device *dev)
 
 	/* create tx task */
 	PRINT_D(INIT_DBG, "Creating kthread for transmission\n");
-	wl->txq_thread = kthread_run(linux_wlan_txq_task, (void *)wl,
+	wl->txq_thread = kthread_run(linux_wlan_txq_task, (void *)dev,
 				     "K_TXQ_TASK");
 	if (!wl->txq_thread) {
 		PRINT_ER("couldn't create TXQ thread\n");
-- 
1.9.1

