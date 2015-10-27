Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:57992 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbbJ0JZ4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2015 05:25:56 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 09/27] staging: wilc1000: wlan_initialize_threads: change argument with net_device
Date: Tue, 27 Oct 2015 18:27:45 +0900
Message-ID: <1445938083-20445-9-git-send-email-glen.lee@atmel.com> (sfid-20151027_102559_034910_8367E135)
In-Reply-To: <1445938083-20445-1-git-send-email-glen.lee@atmel.com>
References: <1445938083-20445-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes function argument with net_device and use netdev private
data member wilc instead of g_linux_wlan. And there are assignment code with
different value continuously. Take last code.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 8c81de9..4e88cbe 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1011,31 +1011,34 @@ void linux_to_wlan(wilc_wlan_inp_t *nwi, struct wilc *nic)
 #endif
 }
 
-int wlan_initialize_threads(perInterface_wlan_t *nic)
+int wlan_initialize_threads(struct net_device *dev)
 {
-
+	perInterface_wlan_t *nic;
+	struct wilc *wilc;
 	int ret = 0;
 
+	nic = netdev_priv(dev);
+	wilc = nic->wilc;
+
 	PRINT_D(INIT_DBG, "Initializing Threads ...\n");
 
 	/* create tx task */
 	PRINT_D(INIT_DBG, "Creating kthread for transmission\n");
-	g_linux_wlan->txq_thread = kthread_run(linux_wlan_txq_task, (void *)g_linux_wlan, "K_TXQ_TASK");
-	if (g_linux_wlan->txq_thread == NULL) {
+	wilc->txq_thread = kthread_run(linux_wlan_txq_task, (void *)wilc,
+				     "K_TXQ_TASK");
+	if (!wilc->txq_thread) {
 		PRINT_ER("couldn't create TXQ thread\n");
 		ret = -ENOBUFS;
 		goto _fail_2;
 	}
 	/* wait for TXQ task to start. */
-	down(&g_linux_wlan->txq_thread_started);
+	down(&wilc->txq_thread_started);
 
 	return 0;
 
 _fail_2:
 	/*De-Initialize 2nd thread*/
-	g_linux_wlan->close = 1;
-
-	g_linux_wlan->close = 0;
+	wilc->close = 0;
 	return ret;
 }
 
@@ -1084,7 +1087,7 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 		}
 #endif
 
-		ret = wlan_initialize_threads(nic);
+		ret = wlan_initialize_threads(dev);
 		if (ret < 0) {
 			PRINT_ER("Initializing Threads FAILED\n");
 			ret = -EIO;
-- 
1.9.1

