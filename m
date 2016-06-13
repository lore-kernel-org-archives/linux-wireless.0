Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:32905 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965411AbcFMKiM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2016 06:38:12 -0400
Received: by mail-pa0-f52.google.com with SMTP id b13so22371490pat.0
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jun 2016 03:38:12 -0700 (PDT)
From: Binoy Jayan <binoy.jayan@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Binoy Jayan <binoy.jayan@linaro.org>
Subject: [PATCH 2/7] staging: wilc1000: Replace semaphore txq_add_to_head_cs with mutex
Date: Mon, 13 Jun 2016 16:07:34 +0530
Message-Id: <1465814259-3009-3-git-send-email-binoy.jayan@linaro.org> (sfid-20160613_124026_438125_FA8F4E3C)
In-Reply-To: <1465814259-3009-1-git-send-email-binoy.jayan@linaro.org>
References: <1465814259-3009-1-git-send-email-binoy.jayan@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The semaphore 'txq_add_to_head_cs' is a simple mutex, so it should be
written as one. Semaphores are going away in the future. Also, removing
the timeout scenario as the error handling code does not propagate the
timeout properly.

Signed-off-by: Binoy Jayan <binoy.jayan@linaro.org>
---
 drivers/staging/wilc1000/linux_wlan.c         |  4 ++--
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |  3 ++-
 drivers/staging/wilc1000/wilc_wlan.c          | 11 ++++-------
 3 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 90f906d..a933551 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -20,7 +20,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/skbuff.h>
-
+#include <linux/mutex.h>
 #include <linux/semaphore.h>
 #include <linux/completion.h>
 
@@ -679,7 +679,7 @@ static int wlan_init_locks(struct net_device *dev)
 	mutex_init(&wl->rxq_cs);
 
 	spin_lock_init(&wl->txq_spinlock);
-	sema_init(&wl->txq_add_to_head_cs, 1);
+	mutex_init(&wl->txq_add_to_head_cs);
 
 	init_completion(&wl->txq_event);
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 12d7c7b..239cd43 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -43,6 +43,7 @@
 #include "wilc_wlan.h"
 #include <linux/wireless.h>
 #include <linux/completion.h>
+#include <linux/mutex.h>
 
 #define FLOW_CONTROL_LOWER_THRESHOLD	128
 #define FLOW_CONTROL_UPPER_THRESHOLD	256
@@ -171,7 +172,7 @@ struct wilc {
 	struct wilc_vif *vif[NUM_CONCURRENT_IFC];
 	u8 open_ifcs;
 
-	struct semaphore txq_add_to_head_cs;
+	struct mutex txq_add_to_head_cs;
 	spinlock_t txq_spinlock;
 
 	struct mutex rxq_cs;
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 1a57135..9afbe8d 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -99,9 +99,7 @@ static int wilc_wlan_txq_add_to_head(struct wilc_vif *vif,
 	unsigned long flags;
 	struct wilc *wilc = vif->wilc;
 
-	if (wilc_lock_timeout(wilc, &wilc->txq_add_to_head_cs,
-				    CFG_PKTS_TIMEOUT))
-		return -1;
+	mutex_lock(&wilc->txq_add_to_head_cs);
 
 	spin_lock_irqsave(&wilc->txq_spinlock, flags);
 
@@ -119,7 +117,7 @@ static int wilc_wlan_txq_add_to_head(struct wilc_vif *vif,
 	wilc->txq_entries += 1;
 
 	spin_unlock_irqrestore(&wilc->txq_spinlock, flags);
-	up(&wilc->txq_add_to_head_cs);
+	mutex_unlock(&wilc->txq_add_to_head_cs);
 	complete(&wilc->txq_event);
 
 	return 0;
@@ -573,8 +571,7 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 		if (wilc->quit)
 			break;
 
-		wilc_lock_timeout(wilc, &wilc->txq_add_to_head_cs,
-					CFG_PKTS_TIMEOUT);
+		mutex_lock(&wilc->txq_add_to_head_cs);
 		wilc_wlan_txq_filter_dup_tcp_ack(dev);
 		tqe = wilc_wlan_txq_get_first(wilc);
 		i = 0;
@@ -755,7 +752,7 @@ _end_:
 		if (ret != 1)
 			break;
 	} while (0);
-	up(&wilc->txq_add_to_head_cs);
+	mutex_unlock(&wilc->txq_add_to_head_cs);
 
 	wilc->txq_exit = 1;
 	*txq_count = wilc->txq_entries;
-- 
2.7.4

