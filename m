Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:15579 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbcDAIra (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2016 04:47:30 -0400
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 3/7] staging: wilc1000: txq_thread_started: replaces a semaphore with a completion
Date: Fri, 1 Apr 2016 17:44:15 +0900
Message-ID: <1459500259-27873-3-git-send-email-leo.kim@atmel.com> (sfid-20160401_104733_842672_3C5CBDC3)
In-Reply-To: <1459500259-27873-1-git-send-email-leo.kim@atmel.com>
References: <1459500259-27873-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces a semaphore(txq_thread_started) with a completion.
Struct semaphore txq_thread_started is used to signal completion of txq thread.
It is better to use completion than semaphore for this case.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c         | 10 +++++-----
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |  3 +--
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index a858552..2ed2bf3 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -22,6 +22,7 @@
 #include <linux/skbuff.h>
 
 #include <linux/semaphore.h>
+#include <linux/completion.h>
 
 static int dev_state_ev_handler(struct notifier_block *this,
 				unsigned long event, void *ptr);
@@ -313,12 +314,12 @@ static int linux_wlan_txq_task(void *vp)
 	vif = netdev_priv(dev);
 	wl = vif->wilc;
 
-	up(&wl->txq_thread_started);
+	complete(&wl->txq_thread_started);
 	while (1) {
 		down(&wl->txq_event);
 
 		if (wl->close) {
-			up(&wl->txq_thread_started);
+			complete(&wl->txq_thread_started);
 
 			while (!kthread_should_stop())
 				schedule();
@@ -693,8 +694,7 @@ static int wlan_init_locks(struct net_device *dev)
 
 	sema_init(&wl->cfg_event, 0);
 	sema_init(&wl->sync_event, 0);
-
-	sema_init(&wl->txq_thread_started, 0);
+	init_completion(&wl->txq_thread_started);
 
 	return 0;
 }
@@ -731,7 +731,7 @@ static int wlan_initialize_threads(struct net_device *dev)
 		wilc->close = 0;
 		return -ENOBUFS;
 	}
-	down(&wilc->txq_thread_started);
+	wait_for_completion(&wilc->txq_thread_started);
 
 	return 0;
 }
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 3d0ca8e..3a561df6 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -179,8 +179,7 @@ struct wilc {
 	struct semaphore cfg_event;
 	struct semaphore sync_event;
 	struct semaphore txq_event;
-
-	struct semaphore txq_thread_started;
+	struct completion txq_thread_started;
 
 	struct task_struct *txq_thread;
 
-- 
1.9.1

