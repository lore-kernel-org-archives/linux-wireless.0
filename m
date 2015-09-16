Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:40253 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512AbbIPJyH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2015 05:54:07 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 6/8] staging: wilc1000: remove unused semaphore and it's related codes
Date: Wed, 16 Sep 2015 18:53:25 +0900
Message-ID: <1442397207-20491-6-git-send-email-tony.cho@atmel.com> (sfid-20150916_115411_311969_20CE76F9)
In-Reply-To: <1442397207-20491-1-git-send-email-tony.cho@atmel.com>
References: <1442397207-20491-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Glen Lee <glen.lee@atmel.com>

Variable rxq_event, rxq_wait_event and rxq_wait have the same pointer.

nwi->os_context.rxq_wait_event = (void *)&g_linux_wlan->rxq_event;
g_wlan.rxq_wait = inp->os_context.rxq_wait_event;

They are never aquired(down) since down function was only called in
linux_wlan_rxq_task which was deleted in a previous patch.
So delete variable rxq_event, rxq_wait_event, rxq_wait and it's related codes.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c         | 9 ---------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h | 1 -
 drivers/staging/wilc1000/wilc_wlan.c          | 3 ---
 drivers/staging/wilc1000/wilc_wlan_if.h       | 1 -
 4 files changed, 14 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index f104a23..186e42e 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1088,10 +1088,6 @@ void wilc1000_wlan_deinit(linux_wlan_t *nic)
 		  #endif
 		#endif
 
-		/* not sure if the following unlocks are needed or not*/
-		if (&g_linux_wlan->rxq_event != NULL)
-			up(&g_linux_wlan->rxq_event);
-
 		if (&g_linux_wlan->txq_event != NULL)
 			up(&g_linux_wlan->txq_event);
 
@@ -1156,7 +1152,6 @@ int wlan_init_locks(linux_wlan_t *p_nic)
 	sema_init(&g_linux_wlan->txq_add_to_head_cs, 1);
 
 	sema_init(&g_linux_wlan->txq_event, 0);
-	sema_init(&g_linux_wlan->rxq_event, 0);
 
 	sema_init(&g_linux_wlan->cfg_event, 0);
 	sema_init(&g_linux_wlan->sync_event, 0);
@@ -1207,7 +1202,6 @@ void linux_to_wlan(wilc_wlan_inp_t *nwi, linux_wlan_t *nic)
 	nwi->os_context.rx_buffer_size = LINUX_RX_SIZE;
 #endif
 	nwi->os_context.rxq_critical_section = (void *)&g_linux_wlan->rxq_cs;
-	nwi->os_context.rxq_wait_event = (void *)&g_linux_wlan->rxq_event;
 	nwi->os_context.cfg_wait_event = (void *)&g_linux_wlan->cfg_event;
 
 	nwi->os_func.os_debug = linux_wlan_dbg;
@@ -1282,7 +1276,6 @@ int wlan_initialize_threads(perInterface_wlan_t *nic)
 _fail_2:
 	/*De-Initialize 2nd thread*/
 	g_linux_wlan->close = 1;
-	up(&g_linux_wlan->rxq_event);
 	kthread_stop(g_linux_wlan->rxq_thread);
 
 	#if (RX_BH_TYPE == RX_BH_KTHREAD)
@@ -1301,8 +1294,6 @@ static void wlan_deinitialize_threads(linux_wlan_t *nic)
 
 	g_linux_wlan->close = 1;
 	PRINT_D(INIT_DBG, "Deinitializing Threads\n");
-	if (&g_linux_wlan->rxq_event != NULL)
-		up(&g_linux_wlan->rxq_event);
 
 	if (g_linux_wlan->rxq_thread != NULL) {
 		kthread_stop(g_linux_wlan->rxq_thread);
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index c68df360..c98eab6 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -187,7 +187,6 @@ typedef struct {
 	struct mutex rxq_cs;
 	struct mutex hif_cs;
 
-	struct semaphore rxq_event;
 	struct semaphore cfg_event;
 	struct semaphore sync_event;
 	struct semaphore txq_event;
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 1db4cc8..22310cc 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -90,7 +90,6 @@ typedef struct {
 	struct rxq_entry_t *rxq_head;
 	struct rxq_entry_t *rxq_tail;
 	int rxq_entries;
-	void *rxq_wait;
 	int rxq_exit;
 
 
@@ -1398,7 +1397,6 @@ _end_:
 				rqe->buffer_size = size;
 				PRINT_D(RX_DBG, "rxq entery Size= %d - Address = %p\n", rqe->buffer_size, rqe->buffer);
 				wilc_wlan_rxq_add(rqe);
-				up(p->rxq_wait);
 			}
 		} else {
 #ifndef MEMORY_STATIC
@@ -2049,7 +2047,6 @@ int wilc_wlan_init(wilc_wlan_inp_t *inp, wilc_wlan_oup_t *oup)
 
 	g_wlan.rxq_lock = inp->os_context.rxq_critical_section;
 	g_wlan.txq_wait = inp->os_context.txq_wait_event;
-	g_wlan.rxq_wait = inp->os_context.rxq_wait_event;
 	g_wlan.cfg_wait = inp->os_context.cfg_wait_event;
 	g_wlan.tx_buffer_size = inp->os_context.tx_buffer_size;
 #if defined (MEMORY_STATIC)
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 3f5aa44..bccfcf9 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -137,7 +137,6 @@ typedef struct {
 	u32 rx_buffer_size;
 #endif
 	void *rxq_critical_section;
-	void *rxq_wait_event;
 
 	struct semaphore *cfg_wait_event;
 } wilc_wlan_os_context_t;
-- 
1.9.1

