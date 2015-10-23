Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:51861 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbbJWF0y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2015 01:26:54 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 10/28] staging: wilc1000: wlan_initialize_threads: change argument with net_device
Date: Fri, 23 Oct 2015 14:28:26 +0900
Message-ID: <1445578124-31486-10-git-send-email-glen.lee@atmel.com> (sfid-20151023_074656_449201_4360806B)
In-Reply-To: <1445578124-31486-1-git-send-email-glen.lee@atmel.com>
References: <1445578124-31486-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes function argument with net_device dev and use netdev private
data member wilc instead of g_linux_wlan. And there are assignment code with
different value continuously. Take last code.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index b8fd4ae..f6862d5 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1010,31 +1010,34 @@ void linux_to_wlan(wilc_wlan_inp_t *nwi, struct wilc *nic)
 #endif
 }
 
-int wlan_initialize_threads(perInterface_wlan_t *nic)
+int wlan_initialize_threads(struct net_device *dev)
 {
-
+	perInterface_wlan_t *nic;
+	struct wilc *wl;
 	int ret = 0;
 
+	nic = netdev_priv(dev);
+	wl = nic->wilc;
+
 	PRINT_D(INIT_DBG, "Initializing Threads ...\n");
 
 	/* create tx task */
 	PRINT_D(INIT_DBG, "Creating kthread for transmission\n");
-	g_linux_wlan->txq_thread = kthread_run(linux_wlan_txq_task, (void *)g_linux_wlan, "K_TXQ_TASK");
-	if (g_linux_wlan->txq_thread == NULL) {
+	wl->txq_thread = kthread_run(linux_wlan_txq_task, (void *)wl,
+				     "K_TXQ_TASK");
+	if (!wl->txq_thread) {
 		PRINT_ER("couldn't create TXQ thread\n");
 		ret = -ENOBUFS;
 		goto _fail_2;
 	}
 	/* wait for TXQ task to start. */
-	down(&g_linux_wlan->txq_thread_started);
+	down(&wl->txq_thread_started);
 
 	return 0;
 
 _fail_2:
 	/*De-Initialize 2nd thread*/
-	g_linux_wlan->close = 1;
-
-	g_linux_wlan->close = 0;
+	wl->close = 0;
 	return ret;
 }
 
@@ -1083,7 +1086,7 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 		}
 #endif
 
-		ret = wlan_initialize_threads(nic);
+		ret = wlan_initialize_threads(dev);
 		if (ret < 0) {
 			PRINT_ER("Initializing Threads FAILED\n");
 			ret = -EIO;
-- 
1.9.1

