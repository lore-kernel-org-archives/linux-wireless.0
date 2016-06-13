Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:35058 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965368AbcFMKiH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2016 06:38:07 -0400
Received: by mail-pa0-f42.google.com with SMTP id hl6so44776247pac.2
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jun 2016 03:38:06 -0700 (PDT)
From: Binoy Jayan <binoy.jayan@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Binoy Jayan <binoy.jayan@linaro.org>
Subject: [PATCH 1/7] staging: wilc1000: Replace semaphore txq_event with completion
Date: Mon, 13 Jun 2016 16:07:33 +0530
Message-Id: <1465814259-3009-2-git-send-email-binoy.jayan@linaro.org> (sfid-20160613_124041_363356_A3EAB144)
In-Reply-To: <1465814259-3009-1-git-send-email-binoy.jayan@linaro.org>
References: <1465814259-3009-1-git-send-email-binoy.jayan@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The semaphore 'txq_event' is used as completion, so convert it
to a struct completion type.

Signed-off-by: Binoy Jayan <binoy.jayan@linaro.org>
---
 drivers/staging/wilc1000/linux_wlan.c         | 8 ++++----
 drivers/staging/wilc1000/wilc_wfi_netdevice.h | 3 ++-
 drivers/staging/wilc1000/wilc_wlan.c          | 8 +++++---
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 4f93c11..90f906d 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -316,7 +316,7 @@ static int linux_wlan_txq_task(void *vp)
 
 	complete(&wl->txq_thread_started);
 	while (1) {
-		down(&wl->txq_event);
+		wait_for_completion(&wl->txq_event);
 
 		if (wl->close) {
 			complete(&wl->txq_thread_started);
@@ -650,7 +650,7 @@ void wilc1000_wlan_deinit(struct net_device *dev)
 			mutex_unlock(&wl->hif_cs);
 		}
 		if (&wl->txq_event)
-			up(&wl->txq_event);
+			wait_for_completion(&wl->txq_event);
 
 		wlan_deinitialize_threads(dev);
 		deinit_irq(dev);
@@ -681,7 +681,7 @@ static int wlan_init_locks(struct net_device *dev)
 	spin_lock_init(&wl->txq_spinlock);
 	sema_init(&wl->txq_add_to_head_cs, 1);
 
-	sema_init(&wl->txq_event, 0);
+	init_completion(&wl->txq_event);
 
 	sema_init(&wl->cfg_event, 0);
 	sema_init(&wl->sync_event, 0);
@@ -738,7 +738,7 @@ static void wlan_deinitialize_threads(struct net_device *dev)
 	wl->close = 1;
 
 	if (&wl->txq_event)
-		up(&wl->txq_event);
+		complete(&wl->txq_event);
 
 	if (wl->txq_thread) {
 		kthread_stop(wl->txq_thread);
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 3a561df6..12d7c7b 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -42,6 +42,7 @@
 #include "host_interface.h"
 #include "wilc_wlan.h"
 #include <linux/wireless.h>
+#include <linux/completion.h>
 
 #define FLOW_CONTROL_LOWER_THRESHOLD	128
 #define FLOW_CONTROL_UPPER_THRESHOLD	256
@@ -178,7 +179,7 @@ struct wilc {
 
 	struct semaphore cfg_event;
 	struct semaphore sync_event;
-	struct semaphore txq_event;
+	struct completion txq_event;
 	struct completion txq_thread_started;
 
 	struct task_struct *txq_thread;
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 11e16d5..1a57135 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1,3 +1,4 @@
+#include <linux/completion.h>
 #include "wilc_wlan_if.h"
 #include "wilc_wlan.h"
 #include "wilc_wfi_netdevice.h"
@@ -89,7 +90,7 @@ static void wilc_wlan_txq_add_to_tail(struct net_device *dev,
 
 	spin_unlock_irqrestore(&wilc->txq_spinlock, flags);
 
-	up(&wilc->txq_event);
+	complete(&wilc->txq_event);
 }
 
 static int wilc_wlan_txq_add_to_head(struct wilc_vif *vif,
@@ -119,7 +120,7 @@ static int wilc_wlan_txq_add_to_head(struct wilc_vif *vif,
 
 	spin_unlock_irqrestore(&wilc->txq_spinlock, flags);
 	up(&wilc->txq_add_to_head_cs);
-	up(&wilc->txq_event);
+	complete(&wilc->txq_event);
 
 	return 0;
 }
@@ -287,7 +288,8 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
 	spin_unlock_irqrestore(&wilc->txq_spinlock, wilc->txq_spinlock_flags);
 
 	while (dropped > 0) {
-		wilc_lock_timeout(wilc, &wilc->txq_event, 1);
+		wait_for_completion_timeout(&wilc->txq_event,
+						msecs_to_jiffies(1));
 		dropped--;
 	}
 
-- 
2.7.4

