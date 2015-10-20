Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:16900 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbbJTIOa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 04:14:30 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 03/13] staging: wilc1000: wlan_init_locks: change parameter and use wilc
Date: Tue, 20 Oct 2015 17:13:53 +0900
Message-ID: <1445328843-32247-3-git-send-email-tony.cho@atmel.com> (sfid-20151020_101434_358003_BBA59139)
In-Reply-To: <1445328843-32247-1-git-send-email-tony.cho@atmel.com>
References: <1445328843-32247-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Glen Lee <glen.lee@atmel.com>

This patch changes function parameter type wilc with net_device and use netdev
private data member wilc instead of global variable g_linux_wlan.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 39341a8..5fcbfac 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -920,23 +920,28 @@ void wilc1000_wlan_deinit(struct wilc *nic)
 	}
 }
 
-int wlan_init_locks(struct wilc *p_nic)
+int wlan_init_locks(struct net_device *dev)
 {
+	perInterface_wlan_t *nic;
+	struct wilc *wl;
+
+	nic = netdev_priv(dev);
+	wl = nic->wilc;
 
 	PRINT_D(INIT_DBG, "Initializing Locks ...\n");
 
-	mutex_init(&g_linux_wlan->hif_cs);
-	mutex_init(&g_linux_wlan->rxq_cs);
+	mutex_init(&wl->hif_cs);
+	mutex_init(&wl->rxq_cs);
 
-	spin_lock_init(&g_linux_wlan->txq_spinlock);
-	sema_init(&g_linux_wlan->txq_add_to_head_cs, 1);
+	spin_lock_init(&wl->txq_spinlock);
+	sema_init(&wl->txq_add_to_head_cs, 1);
 
-	sema_init(&g_linux_wlan->txq_event, 0);
+	sema_init(&wl->txq_event, 0);
 
-	sema_init(&g_linux_wlan->cfg_event, 0);
-	sema_init(&g_linux_wlan->sync_event, 0);
+	sema_init(&wl->cfg_event, 0);
+	sema_init(&wl->sync_event, 0);
 
-	sema_init(&g_linux_wlan->txq_thread_started, 0);
+	sema_init(&wl->txq_thread_started, 0);
 
 	return 0;
 }
@@ -1033,7 +1038,7 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 		wl->mac_status = WILC_MAC_STATUS_INIT;
 		wl->close = 0;
 
-		wlan_init_locks(wl);
+		wlan_init_locks(dev);
 
 		linux_to_wlan(&nwi, wl);
 
-- 
1.9.1

