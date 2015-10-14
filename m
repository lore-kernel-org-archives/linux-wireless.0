Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:43517 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490AbbJNLrT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 07:47:19 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 03/16] staging: wilc1000: rename g_linux_wlan to wl
Date: Wed, 14 Oct 2015 20:46:31 +0900
Message-ID: <1444823204-16736-3-git-send-email-tony.cho@atmel.com> (sfid-20151014_134727_645101_84F3B8B9)
In-Reply-To: <1444823204-16736-1-git-send-email-tony.cho@atmel.com>
References: <1444823204-16736-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames g_linux_wlan to wl.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c             | 289 +++++++++++-----------
 drivers/staging/wilc1000/linux_wlan_sdio.c        |   4 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 114 ++++-----
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |   2 +-
 drivers/staging/wilc1000/wilc_wlan.c              |  72 +++---
 5 files changed, 237 insertions(+), 244 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index b879b8b..6a98660 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -114,7 +114,7 @@ static void wilc_set_multicast_list(struct net_device *dev);
  * for now - in frmw_to_linux there should be private data to be passed to it
  * and this data should be pointer to net device
  */
-struct wilc *g_linux_wlan;
+struct wilc *wl;
 bool bEnablePS = true;
 
 static const struct net_device_ops wilc_netdev_ops = {
@@ -233,7 +233,7 @@ static irqreturn_t isr_uh_routine(int irq, void *user_data)
 	PRINT_D(INT_DBG, "Interrupt received UH\n");
 
 	/*While mac is closing cacncel the handling of any interrupts received*/
-	if (g_linux_wlan->close) {
+	if (wl->close) {
 		PRINT_ER("Driver is CLOSING: Can't handle UH interrupt\n");
 		return IRQ_HANDLED;
 	}
@@ -248,7 +248,7 @@ irqreturn_t isr_bh_routine(int irq, void *userdata)
 	nic = (struct wilc *)userdata;
 
 	/*While mac is closing cacncel the handling of any interrupts received*/
-	if (g_linux_wlan->close) {
+	if (wl->close) {
 		PRINT_ER("Driver is CLOSING: Can't handle BH interrupt\n");
 		return IRQ_HANDLED;
 	}
@@ -304,7 +304,7 @@ static void deinit_irq(struct wilc *nic)
 #if (defined WILC_SPI) || (defined WILC_SDIO_IRQ_GPIO)
 	/* Deintialize IRQ */
 	if (&nic->dev_irq_num != 0) {
-		free_irq(nic->dev_irq_num, g_linux_wlan);
+		free_irq(nic->dev_irq_num, wl);
 
 		gpio_free(GPIO_NUM);
 	}
@@ -336,7 +336,7 @@ void linux_wlan_mac_indicate(int flag)
 	/*I have to do it that way becuase there is no mean to encapsulate device pointer
 	 * as a parameter
 	 */
-	struct wilc *pd = g_linux_wlan;
+	struct wilc *pd = wl;
 	int status;
 
 	if (flag == WILC_MAC_INDICATE_STATUS) {
@@ -366,24 +366,21 @@ struct net_device *GetIfHandler(u8 *pMacHeader)
 	Bssid  = pMacHeader + 10;
 	Bssid1 = pMacHeader + 4;
 
-	for (i = 0; i < g_linux_wlan->u8NoIfcs; i++) {
-		if (!memcmp(Bssid1, g_linux_wlan->strInterfaceInfo[i].aBSSID, ETH_ALEN) ||
-		    !memcmp(Bssid, g_linux_wlan->strInterfaceInfo[i].aBSSID, ETH_ALEN))	{
-			return g_linux_wlan->strInterfaceInfo[i].wilc_netdev;
-		}
-	}
+	for (i = 0; i < wl->u8NoIfcs; i++)
+		if (!memcmp(Bssid1, wl->strInterfaceInfo[i].aBSSID, ETH_ALEN) ||
+		    !memcmp(Bssid, wl->strInterfaceInfo[i].aBSSID, ETH_ALEN))
+			return wl->strInterfaceInfo[i].wilc_netdev;
+
 	PRINT_INFO(INIT_DBG, "Invalide handle\n");
 	for (i = 0; i < 25; i++)
 		PRINT_D(INIT_DBG, "%02x ", pMacHeader[i]);
 	Bssid  = pMacHeader + 18;
 	Bssid1 = pMacHeader + 12;
-	for (i = 0; i < g_linux_wlan->u8NoIfcs; i++) {
-		if (!memcmp(Bssid1, g_linux_wlan->strInterfaceInfo[i].aBSSID, ETH_ALEN) ||
-		    !memcmp(Bssid, g_linux_wlan->strInterfaceInfo[i].aBSSID, ETH_ALEN))	{
-			PRINT_D(INIT_DBG, "Ctx [%p]\n", g_linux_wlan->strInterfaceInfo[i].wilc_netdev);
-			return g_linux_wlan->strInterfaceInfo[i].wilc_netdev;
-		}
-	}
+	for (i = 0; i < wl->u8NoIfcs; i++)
+		if (!memcmp(Bssid1, wl->strInterfaceInfo[i].aBSSID, ETH_ALEN) ||
+		    !memcmp(Bssid, wl->strInterfaceInfo[i].aBSSID, ETH_ALEN))
+			return wl->strInterfaceInfo[i].wilc_netdev;
+
 	PRINT_INFO(INIT_DBG, "\n");
 	return NULL;
 }
@@ -394,14 +391,13 @@ int linux_wlan_set_bssid(struct net_device *wilc_netdev, u8 *pBSSID)
 	int ret = -1;
 
 	PRINT_D(INIT_DBG, "set bssid on[%p]\n", wilc_netdev);
-	for (i = 0; i < g_linux_wlan->u8NoIfcs; i++) {
-		if (g_linux_wlan->strInterfaceInfo[i].wilc_netdev == wilc_netdev) {
-			PRINT_D(INIT_DBG, "set bssid [%x][%x][%x]\n", pBSSID[0], pBSSID[1], pBSSID[2]);
-			memcpy(g_linux_wlan->strInterfaceInfo[i].aBSSID, pBSSID, 6);
+	for (i = 0; i < wl->u8NoIfcs; i++)
+		if (wl->strInterfaceInfo[i].wilc_netdev == wilc_netdev) {
+			memcpy(wl->strInterfaceInfo[i].aBSSID, pBSSID, 6);
 			ret = 0;
 			break;
 		}
-	}
+
 	return ret;
 }
 
@@ -412,10 +408,10 @@ int linux_wlan_get_num_conn_ifcs(void)
 	u8 null_bssid[6] = {0};
 	u8 ret_val = 0;
 
-	for (i = 0; i < g_linux_wlan->u8NoIfcs; i++) {
-		if (memcmp(g_linux_wlan->strInterfaceInfo[i].aBSSID, null_bssid, 6))
+	for (i = 0; i < wl->u8NoIfcs; i++)
+		if (memcmp(wl->strInterfaceInfo[i].aBSSID, null_bssid, 6))
 			ret_val++;
-	}
+
 	return ret_val;
 }
 
@@ -435,17 +431,17 @@ static int linux_wlan_txq_task(void *vp)
 #endif
 
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
@@ -462,10 +458,10 @@ static int linux_wlan_txq_task(void *vp)
 			if (txq_count < FLOW_CONTROL_LOWER_THRESHOLD /* && netif_queue_stopped(pd->wilc_netdev)*/) {
 				PRINT_D(TX_DBG, "Waking up queue\n");
 				/* netif_wake_queue(pd->wilc_netdev); */
-				if (netif_queue_stopped(g_linux_wlan->strInterfaceInfo[0].wilc_netdev))
-					netif_wake_queue(g_linux_wlan->strInterfaceInfo[0].wilc_netdev);
-				if (netif_queue_stopped(g_linux_wlan->strInterfaceInfo[1].wilc_netdev))
-					netif_wake_queue(g_linux_wlan->strInterfaceInfo[1].wilc_netdev);
+				if (netif_queue_stopped(wl->strInterfaceInfo[0].wilc_netdev))
+					netif_wake_queue(wl->strInterfaceInfo[0].wilc_netdev);
+				if (netif_queue_stopped(wl->strInterfaceInfo[1].wilc_netdev))
+					netif_wake_queue(wl->strInterfaceInfo[1].wilc_netdev);
 			}
 
 			if (ret == WILC_TX_ERR_NO_BUF) { /* failed to allocate buffers in chip. */
@@ -487,7 +483,7 @@ static int linux_wlan_txq_task(void *vp)
 				}
 			}
 			/*TODO: drop packets after a certain time/number of retry count. */
-		} while (ret == WILC_TX_ERR_NO_BUF && !g_linux_wlan->close); /* retry sending packets if no more buffers in chip. */
+		} while (ret == WILC_TX_ERR_NO_BUF && !wl->close); /* retry sending packets if no more buffers in chip. */
 #endif
 	}
 	return 0;
@@ -530,19 +526,19 @@ int linux_wlan_get_firmware(perInterface_wlan_t *p_nic)
 	 *      root file system with the name specified above */
 
 #ifdef WILC_SDIO
-	if (request_firmware(&wilc_firmware, firmware, &g_linux_wlan->wilc_sdio_func->dev) != 0) {
+	if (request_firmware(&wilc_firmware, firmware, &wl->wilc_sdio_func->dev) != 0) {
 		PRINT_ER("%s - firmare not available\n", firmware);
 		ret = -1;
 		goto _fail_;
 	}
 #else
-	if (request_firmware(&wilc_firmware, firmware, &g_linux_wlan->wilc_spidev->dev) != 0) {
+	if (request_firmware(&wilc_firmware, firmware, &wl->wilc_spidev->dev) != 0) {
 		PRINT_ER("%s - firmare not available\n", firmware);
 		ret = -1;
 		goto _fail_;
 	}
 #endif
-	g_linux_wlan->wilc_firmware = wilc_firmware;
+	wl->wilc_firmware = wilc_firmware;
 
 _fail_:
 
@@ -568,7 +564,7 @@ static int linux_wlan_start_firmware(perInterface_wlan_t *nic)
 
 	/* wait for mac ready */
 	PRINT_D(INIT_DBG, "Waiting for Firmware to get ready ...\n");
-	ret = linux_wlan_lock_timeout(&g_linux_wlan->sync_event, 5000);
+	ret = linux_wlan_lock_timeout(&wl->sync_event, 5000);
 	if (ret) {
 #ifdef COMPLEMENT_BOOT
 		static int timeout = 5;
@@ -599,7 +595,7 @@ static int linux_wlan_firmware_download(struct wilc *p_nic)
 
 	int ret = 0;
 
-	if (g_linux_wlan->wilc_firmware == NULL) {
+	if (!wl->wilc_firmware) {
 		PRINT_ER("Firmware buffer is NULL\n");
 		ret = -ENOBUFS;
 		goto _FAIL_;
@@ -608,16 +604,16 @@ static int linux_wlan_firmware_download(struct wilc *p_nic)
 	 *      do the firmware download
 	 **/
 	PRINT_D(INIT_DBG, "Downloading Firmware ...\n");
-	ret = wilc_wlan_firmware_download(g_linux_wlan->wilc_firmware->data,
-					  g_linux_wlan->wilc_firmware->size);
+	ret = wilc_wlan_firmware_download(wl->wilc_firmware->data,
+					  wl->wilc_firmware->size);
 	if (ret < 0)
 		goto _FAIL_;
 
 	/* Freeing FW buffer */
 	PRINT_D(INIT_DBG, "Freeing FW buffer ...\n");
 	PRINT_D(INIT_DBG, "Releasing firmware\n");
-	release_firmware(g_linux_wlan->wilc_firmware);
-	g_linux_wlan->wilc_firmware = NULL;
+	release_firmware(wl->wilc_firmware);
+	wl->wilc_firmware = NULL;
 
 	PRINT_D(INIT_DBG, "Download Succeeded\n");
 
@@ -885,7 +881,7 @@ _fail_:
 void wilc1000_wlan_deinit(struct wilc *nic)
 {
 
-	if (g_linux_wlan->wilc1000_initialized)	{
+	if (wl->wilc1000_initialized) {
 
 		printk("Deinitializing wilc1000  ...\n");
 
@@ -903,18 +899,18 @@ void wilc1000_wlan_deinit(struct wilc *nic)
 
 		PRINT_D(INIT_DBG, "Disabling IRQ\n");
 #ifdef WILC_SDIO
-		mutex_lock(&g_linux_wlan->hif_cs);
+		mutex_lock(&wl->hif_cs);
 		disable_sdio_interrupt();
-		mutex_unlock(&g_linux_wlan->hif_cs);
+		mutex_unlock(&wl->hif_cs);
 #endif
-		if (&g_linux_wlan->txq_event != NULL)
-			up(&g_linux_wlan->txq_event);
+		if (&wl->txq_event)
+			up(&wl->txq_event);
 
 		PRINT_D(INIT_DBG, "Deinitializing Threads\n");
 		wlan_deinitialize_threads(nic);
 
 		PRINT_D(INIT_DBG, "Deinitializing IRQ\n");
-		deinit_irq(g_linux_wlan);
+		deinit_irq(wl);
 
 		wilc_wlan_stop();
 
@@ -924,18 +920,18 @@ void wilc1000_wlan_deinit(struct wilc *nic)
   #if defined(PLAT_ALLWINNER_A20) || defined(PLAT_ALLWINNER_A23) || defined(PLAT_ALLWINNER_A31)
 		PRINT_D(INIT_DBG, "Disabling IRQ 2\n");
 
-		mutex_lock(&g_linux_wlan->hif_cs);
+		mutex_lock(&wl->hif_cs);
 		disable_sdio_interrupt();
-		mutex_unlock(&g_linux_wlan->hif_cs);
+		mutex_unlock(&wl->hif_cs);
   #endif
 #endif
 
 		/*De-Initialize locks*/
 		PRINT_D(INIT_DBG, "Deinitializing Locks\n");
-		wlan_deinit_locks(g_linux_wlan);
+		wlan_deinit_locks(wl);
 
 		/* announce that wilc1000 is not initialized */
-		g_linux_wlan->wilc1000_initialized = 0;
+		wl->wilc1000_initialized = 0;
 
 		PRINT_D(INIT_DBG, "wilc1000 deinitialization Done\n");
 
@@ -949,18 +945,16 @@ int wlan_init_locks(struct wilc *p_nic)
 
 	PRINT_D(INIT_DBG, "Initializing Locks ...\n");
 
-	mutex_init(&g_linux_wlan->hif_cs);
-	mutex_init(&g_linux_wlan->rxq_cs);
-
-	spin_lock_init(&g_linux_wlan->txq_spinlock);
-	sema_init(&g_linux_wlan->txq_add_to_head_cs, 1);
+	mutex_init(&wl->hif_cs);
+	mutex_init(&wl->rxq_cs);
 
-	sema_init(&g_linux_wlan->txq_event, 0);
+	spin_lock_init(&wl->txq_spinlock);
 
-	sema_init(&g_linux_wlan->cfg_event, 0);
-	sema_init(&g_linux_wlan->sync_event, 0);
-
-	sema_init(&g_linux_wlan->txq_thread_started, 0);
+	sema_init(&wl->txq_add_to_head_cs, 1);
+	sema_init(&wl->txq_event, 0);
+	sema_init(&wl->cfg_event, 0);
+	sema_init(&wl->sync_event, 0);
+	sema_init(&wl->txq_thread_started, 0);
 
 	return 0;
 }
@@ -969,11 +963,11 @@ static int wlan_deinit_locks(struct wilc *nic)
 {
 	PRINT_D(INIT_DBG, "De-Initializing Locks\n");
 
-	if (&g_linux_wlan->hif_cs != NULL)
-		mutex_destroy(&g_linux_wlan->hif_cs);
+	if (&wl->hif_cs)
+		mutex_destroy(&wl->hif_cs);
 
-	if (&g_linux_wlan->rxq_cs != NULL)
-		mutex_destroy(&g_linux_wlan->rxq_cs);
+	if (&wl->rxq_cs)
+		mutex_destroy(&wl->rxq_cs);
 
 	return 0;
 }
@@ -1012,37 +1006,37 @@ int wlan_initialize_threads(perInterface_wlan_t *nic)
 
 	/* create tx task */
 	PRINT_D(INIT_DBG, "Creating kthread for transmission\n");
-	g_linux_wlan->txq_thread = kthread_run(linux_wlan_txq_task, (void *)g_linux_wlan, "K_TXQ_TASK");
-	if (g_linux_wlan->txq_thread == NULL) {
+	wl->txq_thread = kthread_run(linux_wlan_txq_task, (void *)wl, "K_TXQ_TASK");
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
+	wl->close = 1;
 
-	g_linux_wlan->close = 0;
+	wl->close = 0;
 	return ret;
 }
 
 static void wlan_deinitialize_threads(struct wilc *nic)
 {
 
-	g_linux_wlan->close = 1;
+	wl->close = 1;
 	PRINT_D(INIT_DBG, "Deinitializing Threads\n");
 
-	if (&g_linux_wlan->txq_event != NULL)
-		up(&g_linux_wlan->txq_event);
+	if (&wl->txq_event)
+		up(&wl->txq_event);
 
-	if (g_linux_wlan->txq_thread != NULL) {
-		kthread_stop(g_linux_wlan->txq_thread);
-		g_linux_wlan->txq_thread = NULL;
+	if (wl->txq_thread) {
+		kthread_stop(wl->txq_thread);
+		wl->txq_thread = NULL;
 	}
 }
 
@@ -1074,7 +1068,7 @@ u8 wilc1000_prepare_11b_core(wilc_wlan_inp_t *nwi, struct wilc *nic)
 		while (!probe)
 			msleep(100);
 		probe = 0;
-		g_linux_wlan->wilc_sdio_func = local_sdio_func;
+		wl->wilc_sdio_func = local_sdio_func;
 		linux_to_wlan(nwi, nic);
 		wilc_wlan_init(nwi);
 	}
@@ -1107,11 +1101,11 @@ int repeat_power_cycle(perInterface_wlan_t *nic)
 	while (!probe)
 		msleep(100);
 	probe = 0;
-	g_linux_wlan->wilc_sdio_func = local_sdio_func;
-	linux_to_wlan(&nwi, g_linux_wlan);
+	wl->wilc_sdio_func = local_sdio_func;
+	linux_to_wlan(&nwi, wl);
 	ret = wilc_wlan_init(&nwi);
 
-	g_linux_wlan->mac_status = WILC_MAC_STATUS_INIT;
+	wl->mac_status = WILC_MAC_STATUS_INIT;
 	#if (defined WILC_SDIO) && (!defined WILC_SDIO_IRQ_GPIO)
 	enable_sdio_interrupt();
 	#endif
@@ -1123,7 +1117,7 @@ int repeat_power_cycle(perInterface_wlan_t *nic)
 	}
 
 	/*Download firmware*/
-	ret = linux_wlan_firmware_download(g_linux_wlan);
+	ret = linux_wlan_firmware_download(wl);
 	if (ret < 0) {
 		PRINT_ER("Failed to download firmware\n");
 		goto __fail__;
@@ -1143,14 +1137,14 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 	perInterface_wlan_t *nic = p_nic;
 	int ret = 0;
 
-	if (!g_linux_wlan->wilc1000_initialized) {
-		g_linux_wlan->mac_status = WILC_MAC_STATUS_INIT;
-		g_linux_wlan->close = 0;
-		g_linux_wlan->wilc1000_initialized = 0;
+	if (!wl->wilc1000_initialized) {
+		wl->mac_status = WILC_MAC_STATUS_INIT;
+		wl->close = 0;
+		wl->wilc1000_initialized = 0;
 
-		wlan_init_locks(g_linux_wlan);
+		wlan_init_locks(wl);
 
-		linux_to_wlan(&nwi, g_linux_wlan);
+		linux_to_wlan(&nwi, wl);
 
 		ret = wilc_wlan_init(&nwi);
 		if (ret < 0) {
@@ -1167,7 +1161,7 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 		}
 
 #if (defined WILC_SDIO) && (defined COMPLEMENT_BOOT)
-		if (wilc1000_prepare_11b_core(&nwi, g_linux_wlan)) {
+		if (wilc1000_prepare_11b_core(&nwi, wl)) {
 			PRINT_ER("11b Core is not ready\n");
 			ret = -EIO;
 			goto _fail_threads_;
@@ -1175,7 +1169,7 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 #endif
 
 #if (!defined WILC_SDIO) || (defined WILC_SDIO_IRQ_GPIO)
-		if (init_irq(g_linux_wlan)) {
+		if (init_irq(wl)) {
 			PRINT_ER("couldn't initialize IRQ\n");
 			ret = -EIO;
 			goto _fail_threads_;
@@ -1197,7 +1191,7 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 		}
 
 		/*Download firmware*/
-		ret = linux_wlan_firmware_download(g_linux_wlan);
+		ret = linux_wlan_firmware_download(wl);
 		if (ret < 0) {
 			PRINT_ER("Failed to download firmware\n");
 			ret = -EIO;
@@ -1225,7 +1219,7 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 			PRINT_D(INIT_DBG, "***** Firmware Ver = %s  *******\n", Firmware_ver);
 		}
 		/* Initialize firmware with default configuration */
-		ret = linux_wlan_init_test_config(dev, g_linux_wlan);
+		ret = linux_wlan_init_test_config(dev, wl);
 
 		if (ret < 0) {
 			PRINT_ER("Failed to configure firmware\n");
@@ -1233,7 +1227,7 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 			goto _fail_fw_start_;
 		}
 
-		g_linux_wlan->wilc1000_initialized = 1;
+		wl->wilc1000_initialized = 1;
 		return 0; /*success*/
 
 _fail_fw_start_:
@@ -1245,15 +1239,15 @@ _fail_irq_enable_:
 _fail_irq_init_:
 #endif
 #if (!defined WILC_SDIO) || (defined WILC_SDIO_IRQ_GPIO)
-		deinit_irq(g_linux_wlan);
+		deinit_irq(wl);
 
 #endif
 _fail_threads_:
-		wlan_deinitialize_threads(g_linux_wlan);
+		wlan_deinitialize_threads(wl);
 _fail_wilc_wlan_:
 		wilc_wlan_cleanup();
 _fail_locks_:
-		wlan_deinit_locks(g_linux_wlan);
+		wlan_deinit_locks(wl);
 		PRINT_ER("WLAN Iinitialization FAILED\n");
 	} else {
 		PRINT_D(INIT_DBG, "wilc1000 already initialized\n");
@@ -1288,7 +1282,7 @@ int mac_open(struct net_device *ndev)
 	struct wilc_priv *priv;
 
 #ifdef WILC_SPI
-	if (!g_linux_wlan || !g_linux_wlan->wilc_spidev) {
+	if (!wl || !wl->wilc_spidev) {
 		netdev_err(ndev, "wilc1000: SPI device not ready\n");
 		return -ENODEV;
 	}
@@ -1319,16 +1313,15 @@ int mac_open(struct net_device *ndev)
 	PRINT_D(INIT_DBG, "Mac address: %pM\n", mac_add);
 
 	/* loop through the NUM of supported devices and set the MAC address */
-	for (i = 0; i < g_linux_wlan->u8NoIfcs; i++) {
-		if (ndev == g_linux_wlan->strInterfaceInfo[i].wilc_netdev) {
-			memcpy(g_linux_wlan->strInterfaceInfo[i].aSrcAddress, mac_add, ETH_ALEN);
-			g_linux_wlan->strInterfaceInfo[i].drvHandler = priv->hWILCWFIDrv;
+	for (i = 0; i < wl->u8NoIfcs; i++)
+		if (ndev == wl->strInterfaceInfo[i].wilc_netdev) {
+			memcpy(wl->strInterfaceInfo[i].aSrcAddress, mac_add, ETH_ALEN);
+			wl->strInterfaceInfo[i].drvHandler = priv->hWILCWFIDrv;
 			break;
 		}
-	}
 
 	/* TODO: get MAC address whenever the source is EPROM - hardcoded and copy it to ndev*/
-	memcpy(ndev->dev_addr, g_linux_wlan->strInterfaceInfo[i].aSrcAddress, ETH_ALEN);
+	memcpy(ndev->dev_addr, wl->strInterfaceInfo[i].aSrcAddress, ETH_ALEN);
 
 	if (!is_valid_ether_addr(ndev->dev_addr)) {
 		PRINT_ER("Error: Wrong MAC address\n");
@@ -1341,13 +1334,13 @@ int mac_open(struct net_device *ndev)
 	wilc_mgmt_frame_register(nic->wilc_netdev->ieee80211_ptr->wiphy, nic->wilc_netdev->ieee80211_ptr,
 				 nic->g_struct_frame_reg[1].frame_type, nic->g_struct_frame_reg[1].reg);
 	netif_wake_queue(ndev);
-	g_linux_wlan->open_ifcs++;
+	wl->open_ifcs++;
 	nic->mac_opened = 1;
 	return 0;
 
 _err_:
 	wilc_deinit_host_int(ndev);
-	wilc1000_wlan_deinit(g_linux_wlan);
+	wilc1000_wlan_deinit(wl);
 	return ret;
 }
 
@@ -1480,14 +1473,14 @@ int mac_xmit(struct sk_buff *skb, struct net_device *ndev)
 	PRINT_D(TX_DBG, "Adding tx packet to TX Queue\n");
 	nic->netstats.tx_packets++;
 	nic->netstats.tx_bytes += tx_data->size;
-	tx_data->pBssid = g_linux_wlan->strInterfaceInfo[nic->u8IfIdx].aBSSID;
+	tx_data->pBssid = wl->strInterfaceInfo[nic->u8IfIdx].aBSSID;
 	QueueCount = wilc_wlan_txq_add_net_pkt((void *)tx_data, tx_data->buff,
 					       tx_data->size,
 					       linux_wlan_tx_complete);
 
 	if (QueueCount > FLOW_CONTROL_UPPER_THRESHOLD) {
-		netif_stop_queue(g_linux_wlan->strInterfaceInfo[0].wilc_netdev);
-		netif_stop_queue(g_linux_wlan->strInterfaceInfo[1].wilc_netdev);
+		netif_stop_queue(wl->strInterfaceInfo[0].wilc_netdev);
+		netif_stop_queue(wl->strInterfaceInfo[1].wilc_netdev);
 	}
 
 	return 0;
@@ -1517,8 +1510,8 @@ int mac_close(struct net_device *ndev)
 
 	PRINT_D(GENERIC_DBG, "Mac close\n");
 
-	if (g_linux_wlan == NULL) {
-		PRINT_ER("g_linux_wlan = NULL\n");
+	if (wl == NULL) {
+		PRINT_ER("wl = NULL\n");
 		return 0;
 	}
 
@@ -1527,8 +1520,8 @@ int mac_close(struct net_device *ndev)
 		return 0;
 	}
 
-	if ((g_linux_wlan->open_ifcs) > 0) {
-		g_linux_wlan->open_ifcs--;
+	if ((wl->open_ifcs) > 0) {
+		wl->open_ifcs--;
 	} else {
 		PRINT_ER("ERROR: MAC close called while number of opened interfaces is zero\n");
 		return 0;
@@ -1541,10 +1534,10 @@ int mac_close(struct net_device *ndev)
 		wilc_deinit_host_int(nic->wilc_netdev);
 	}
 
-	if (g_linux_wlan->open_ifcs == 0) {
+	if (wl->open_ifcs == 0) {
 		PRINT_D(GENERIC_DBG, "Deinitializing wilc1000\n");
-		g_linux_wlan->close = 1;
-		wilc1000_wlan_deinit(g_linux_wlan);
+		wl->close = 1;
+		wilc1000_wlan_deinit(wl);
 		WILC_WFI_deinit_mon_interface();
 	}
 
@@ -1567,7 +1560,7 @@ int mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 	/* struct iwreq *wrq = (struct iwreq *) req;	// tony moved to case SIOCSIWPRIV */
 	nic = netdev_priv(ndev);
 
-	if (!g_linux_wlan->wilc1000_initialized)
+	if (!wl->wilc1000_initialized)
 		return 0;
 
 	switch (cmd) {
@@ -1651,8 +1644,8 @@ void frmw_to_linux(u8 *buff, u32 size, u32 pkt_offset)
 			return;
 		}
 
-		if (g_linux_wlan == NULL || wilc_netdev == NULL)
-			PRINT_ER("wilc_netdev in g_linux_wlan is NULL");
+		if (!wl || !wilc_netdev)
+			PRINT_ER("wilc_netdev in wl is NULL");
 		skb->dev = wilc_netdev;
 
 		if (skb->dev == NULL)
@@ -1690,18 +1683,18 @@ void WILC_WFI_mgmt_rx(u8 *buff, u32 size)
 
 	/*Pass the frame on the monitor interface, if any.*/
 	/*Otherwise, pass it on p2p0 netdev, if registered on it*/
-	for (i = 0; i < g_linux_wlan->u8NoIfcs; i++) {
-		nic = netdev_priv(g_linux_wlan->strInterfaceInfo[i].wilc_netdev);
+	for (i = 0; i < wl->u8NoIfcs; i++) {
+		nic = netdev_priv(wl->strInterfaceInfo[i].wilc_netdev);
 		if (nic->monitor_flag) {
 			WILC_WFI_monitor_rx(buff, size);
 			return;
 		}
 	}
 
-	nic = netdev_priv(g_linux_wlan->strInterfaceInfo[1].wilc_netdev); /* p2p0 */
+	nic = netdev_priv(wl->strInterfaceInfo[1].wilc_netdev); /* p2p0 */
 	if ((buff[0] == nic->g_struct_frame_reg[0].frame_type && nic->g_struct_frame_reg[0].reg) ||
 	    (buff[0] == nic->g_struct_frame_reg[1].frame_type && nic->g_struct_frame_reg[1].reg))
-		WILC_WFI_p2p_rx(g_linux_wlan->strInterfaceInfo[1].wilc_netdev, buff, size);
+		WILC_WFI_p2p_rx(wl->strInterfaceInfo[1].wilc_netdev, buff, size);
 }
 
 int wilc_netdev_init(void)
@@ -1714,8 +1707,8 @@ int wilc_netdev_init(void)
 	sema_init(&close_exit_sync, 0);
 
 	/*create the common structure*/
-	g_linux_wlan = kzalloc(sizeof(*g_linux_wlan), GFP_KERNEL);
-	if (!g_linux_wlan)
+	wl = kzalloc(sizeof(*wl), GFP_KERNEL);
+	if (!wl)
 		return -ENOMEM;
 
 	register_inetaddr_notifier(&g_dev_notifier);
@@ -1743,10 +1736,10 @@ int wilc_netdev_init(void)
 		} else
 			strcpy(ndev->name, "p2p%d");
 
-		nic->u8IfIdx = g_linux_wlan->u8NoIfcs;
+		nic->u8IfIdx = wl->u8NoIfcs;
 		nic->wilc_netdev = ndev;
-		g_linux_wlan->strInterfaceInfo[g_linux_wlan->u8NoIfcs].wilc_netdev = ndev;
-		g_linux_wlan->u8NoIfcs++;
+		wl->strInterfaceInfo[wl->u8NoIfcs].wilc_netdev = ndev;
+		wl->u8NoIfcs++;
 		ndev->netdev_ops = &wilc_netdev_ops;
 
 		{
@@ -1786,13 +1779,13 @@ int wilc_netdev_init(void)
 	}
 
 	#ifndef WILC_SDIO
-	if (!linux_spi_init(&g_linux_wlan->wilc_spidev)) {
+	if (!linux_spi_init(&wl->wilc_spidev)) {
 		PRINT_ER("Can't initialize SPI\n");
 		return -1; /* ERROR */
 	}
-	g_linux_wlan->wilc_spidev = wilc_spi_dev;
+	wl->wilc_spidev = wilc_spi_dev;
 	#else
-	g_linux_wlan->wilc_sdio_func = local_sdio_func;
+	wl->wilc_sdio_func = local_sdio_func;
 	#endif
 
 	return 0;
@@ -1840,21 +1833,21 @@ static void __exit exit_wilc_driver(void)
 	perInterface_wlan_t *nic[NUM_CONCURRENT_IFC] = {NULL,};
 	#define CLOSE_TIMEOUT (12 * 1000)
 
-	if ((g_linux_wlan != NULL) && (((g_linux_wlan->strInterfaceInfo[0].wilc_netdev) != NULL)
-				       || ((g_linux_wlan->strInterfaceInfo[1].wilc_netdev) != NULL))) {
+	if (wl && (wl->strInterfaceInfo[0].wilc_netdev ||
+	    wl->strInterfaceInfo[1].wilc_netdev)) {
 		unregister_inetaddr_notifier(&g_dev_notifier);
 
 		for (i = 0; i < NUM_CONCURRENT_IFC; i++)
-			nic[i] = netdev_priv(g_linux_wlan->strInterfaceInfo[i].wilc_netdev);
+			nic[i] = netdev_priv(wl->strInterfaceInfo[i].wilc_netdev);
 	}
 
-	if ((g_linux_wlan != NULL) && g_linux_wlan->wilc_firmware != NULL) {
-		release_firmware(g_linux_wlan->wilc_firmware);
-		g_linux_wlan->wilc_firmware = NULL;
+	if (wl && wl->wilc_firmware) {
+		release_firmware(wl->wilc_firmware);
+		wl->wilc_firmware = NULL;
 	}
 
-	if ((g_linux_wlan != NULL) && (((g_linux_wlan->strInterfaceInfo[0].wilc_netdev) != NULL)
-				       || ((g_linux_wlan->strInterfaceInfo[1].wilc_netdev) != NULL))) {
+	if (wl && (wl->strInterfaceInfo[0].wilc_netdev ||
+	    wl->strInterfaceInfo[1].wilc_netdev)) {
 		PRINT_D(INIT_DBG, "Waiting for mac_close ....\n");
 
 		if (linux_wlan_lock_timeout(&close_exit_sync, CLOSE_TIMEOUT) < 0)
@@ -1864,18 +1857,18 @@ static void __exit exit_wilc_driver(void)
 
 		for (i = 0; i < NUM_CONCURRENT_IFC; i++) {
 			/* close all opened interfaces */
-			if (g_linux_wlan->strInterfaceInfo[i].wilc_netdev != NULL) {
+			if (wl->strInterfaceInfo[i].wilc_netdev) {
 				if (nic[i]->mac_opened)
-					mac_close(g_linux_wlan->strInterfaceInfo[i].wilc_netdev);
+					mac_close(wl->strInterfaceInfo[i].wilc_netdev);
 			}
 		}
 		for (i = 0; i < NUM_CONCURRENT_IFC; i++) {
-			PRINT_D(INIT_DBG, "Unregistering netdev %p\n", g_linux_wlan->strInterfaceInfo[i].wilc_netdev);
-			unregister_netdev(g_linux_wlan->strInterfaceInfo[i].wilc_netdev);
+			PRINT_D(INIT_DBG, "Unregistering netdev %p\n", wl->strInterfaceInfo[i].wilc_netdev);
+			unregister_netdev(wl->strInterfaceInfo[i].wilc_netdev);
 			PRINT_D(INIT_DBG, "Freeing Wiphy...\n");
-			wilc_free_wiphy(g_linux_wlan->strInterfaceInfo[i].wilc_netdev);
+			wilc_free_wiphy(wl->strInterfaceInfo[i].wilc_netdev);
 			PRINT_D(INIT_DBG, "Freeing netdev...\n");
-			free_netdev(g_linux_wlan->strInterfaceInfo[i].wilc_netdev);
+			free_netdev(wl->strInterfaceInfo[i].wilc_netdev);
 		}
 	}
 
@@ -1886,9 +1879,7 @@ static void __exit exit_wilc_driver(void)
 	PRINT_D(INIT_DBG, "SDIO unregsiter...\n");
 	sdio_unregister_driver(&wilc_bus);
 #endif
-
-	kfree(g_linux_wlan);
-	g_linux_wlan = NULL;
+	kfree(wl);
 	printk("Module_exit Done.\n");
 
 #if defined(WILC_DEBUGFS)
diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.c b/drivers/staging/wilc1000/linux_wlan_sdio.c
index ebacd29..0dd4b19 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.c
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.c
@@ -49,7 +49,7 @@ static void wilc_sdio_interrupt(struct sdio_func *func)
 
 int linux_sdio_cmd52(sdio_cmd52_t *cmd)
 {
-	struct sdio_func *func = g_linux_wlan->wilc_sdio_func;
+	struct sdio_func *func = wl->wilc_sdio_func;
 	int ret;
 	u8 data;
 
@@ -81,7 +81,7 @@ int linux_sdio_cmd52(sdio_cmd52_t *cmd)
 
 int linux_sdio_cmd53(sdio_cmd53_t *cmd)
 {
-	struct sdio_func *func = g_linux_wlan->wilc_sdio_func;
+	struct sdio_func *func = wl->wilc_sdio_func;
 	int size, ret;
 
 	sdio_claim_host(func);
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 08ba5ba..9696839 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -624,14 +624,13 @@ static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 			u8WLANChannel = INVALID_CHANNEL;
 		/*Incase "P2P CLIENT Connected" send deauthentication reason by 3 to force the WPA_SUPPLICANT to directly change
 		 *      virtual interface to station*/
-		if ((pstrWFIDrv->IFC_UP) && (dev == g_linux_wlan->strInterfaceInfo[1].wilc_netdev)) {
+		if (pstrWFIDrv->IFC_UP &&
+		   (dev == wl->strInterfaceInfo[1].wilc_netdev))
 			pstrDisconnectNotifInfo->u16reason = 3;
-		}
-		/*Incase "P2P CLIENT during connection(not connected)" send deauthentication reason by 1 to force the WPA_SUPPLICANT
-		 *      to scan again and retry the connection*/
-		else if ((!pstrWFIDrv->IFC_UP) && (dev == g_linux_wlan->strInterfaceInfo[1].wilc_netdev)) {
+		else if (!pstrWFIDrv->IFC_UP &&
+			(dev == wl->strInterfaceInfo[1].wilc_netdev))
 			pstrDisconnectNotifInfo->u16reason = 1;
-		}
+
 		cfg80211_disconnected(dev, pstrDisconnectNotifInfo->u16reason, pstrDisconnectNotifInfo->ie,
 				      pstrDisconnectNotifInfo->ie_len, false,
 				      GFP_KERNEL);
@@ -1255,7 +1254,8 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 				}
 
 				/*save keys only on interface 0 (wifi interface)*/
-				if (!g_gtk_keys_saved && netdev == g_linux_wlan->strInterfaceInfo[0].wilc_netdev) {
+				if (!g_gtk_keys_saved &&
+				    netdev == wl->strInterfaceInfo[0].wilc_netdev) {
 					g_add_gtk_key_params.key_idx = key_index;
 					g_add_gtk_key_params.pairwise = pairwise;
 					if (!mac_addr) {
@@ -1291,7 +1291,8 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 				}
 
 				/*save keys only on interface 0 (wifi interface)*/
-				if (!g_ptk_keys_saved && netdev == g_linux_wlan->strInterfaceInfo[0].wilc_netdev) {
+				if (!g_ptk_keys_saved &&
+				    netdev == wl->strInterfaceInfo[0].wilc_netdev) {
 					g_add_ptk_key_params.key_idx = key_index;
 					g_add_ptk_key_params.pairwise = pairwise;
 					if (!mac_addr) {
@@ -1356,7 +1357,7 @@ static int del_key(struct wiphy *wiphy, struct net_device *netdev,
 	priv = wiphy_priv(wiphy);
 
 	/*delete saved keys, if any*/
-	if (netdev == g_linux_wlan->strInterfaceInfo[0].wilc_netdev) {
+	if (netdev == wl->strInterfaceInfo[0].wilc_netdev) {
 		g_ptk_keys_saved = false;
 		g_gtk_keys_saved = false;
 		g_wep_keys_saved = false;
@@ -2418,7 +2419,7 @@ void wilc_mgmt_frame_register(struct wiphy *wiphy, struct wireless_dev *wdev,
 
 	}
 	/*If mac is closed, then return*/
-	if (!g_linux_wlan->wilc1000_initialized) {
+	if (!wl->wilc1000_initialized) {
 		PRINT_D(GENERIC_DBG, "Return since mac is closed\n");
 		return;
 	}
@@ -2571,30 +2572,32 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		interface_type = nic->iftype;
 		nic->iftype = STATION_MODE;
 
-		if (g_linux_wlan->wilc1000_initialized)	{
-			host_int_del_All_Rx_BASession(priv->hWILCWFIDrv, g_linux_wlan->strInterfaceInfo[0].aBSSID, TID);
+		if (wl->wilc1000_initialized) {
+			host_int_del_All_Rx_BASession(priv->hWILCWFIDrv,
+						      wl->strInterfaceInfo[0].aBSSID,
+						      TID);
 			/* ensure that the message Q is empty */
 			host_int_wait_msg_queue_idle();
 
 			/*Eliminate host interface blocking state*/
-			up(&g_linux_wlan->cfg_event);
+			up(&wl->cfg_event);
 
-			wilc1000_wlan_deinit(g_linux_wlan);
+			wilc1000_wlan_deinit(wl);
 			wilc1000_wlan_init(dev, nic);
 			g_wilc_initialized = 1;
 			nic->iftype = interface_type;
 
 			/*Setting interface 1 drv handler and mac address in newly downloaded FW*/
-			host_int_set_wfi_drv_handler(g_linux_wlan->strInterfaceInfo[0].drvHandler);
-			host_int_set_MacAddress(g_linux_wlan->strInterfaceInfo[0].drvHandler,
-						g_linux_wlan->strInterfaceInfo[0].aSrcAddress);
+			host_int_set_wfi_drv_handler(wl->strInterfaceInfo[0].drvHandler);
+			host_int_set_MacAddress(wl->strInterfaceInfo[0].drvHandler,
+						wl->strInterfaceInfo[0].aSrcAddress);
 			host_int_set_operation_mode(priv->hWILCWFIDrv, STATION_MODE);
 
 			/*Add saved WEP keys, if any*/
 			if (g_wep_keys_saved) {
-				host_int_set_WEPDefaultKeyID(g_linux_wlan->strInterfaceInfo[0].drvHandler,
+				host_int_set_WEPDefaultKeyID(wl->strInterfaceInfo[0].drvHandler,
 							     g_key_wep_params.key_idx);
-				host_int_add_wep_key_bss_sta(g_linux_wlan->strInterfaceInfo[0].drvHandler,
+				host_int_add_wep_key_bss_sta(wl->strInterfaceInfo[0].drvHandler,
 							     g_key_wep_params.key,
 							     g_key_wep_params.key_len,
 							     g_key_wep_params.key_idx);
@@ -2612,22 +2615,22 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 				PRINT_D(CFG80211_DBG, "gtk %x %x %x\n", g_key_gtk_params.key[0],
 					g_key_gtk_params.key[1],
 					g_key_gtk_params.key[2]);
-				add_key(g_linux_wlan->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
-					g_linux_wlan->strInterfaceInfo[0].wilc_netdev,
+				add_key(wl->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
+					wl->strInterfaceInfo[0].wilc_netdev,
 					g_add_ptk_key_params.key_idx,
 					g_add_ptk_key_params.pairwise,
 					g_add_ptk_key_params.mac_addr,
 					(struct key_params *)(&g_key_ptk_params));
 
-				add_key(g_linux_wlan->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
-					g_linux_wlan->strInterfaceInfo[0].wilc_netdev,
+				add_key(wl->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
+					wl->strInterfaceInfo[0].wilc_netdev,
 					g_add_gtk_key_params.key_idx,
 					g_add_gtk_key_params.pairwise,
 					g_add_gtk_key_params.mac_addr,
 					(struct key_params *)(&g_key_gtk_params));
 			}
 
-			if (g_linux_wlan->wilc1000_initialized)	{
+			if (wl->wilc1000_initialized)
 				for (i = 0; i < num_reg_frame; i++) {
 					PRINT_D(INIT_DBG, "Frame registering Type: %x - Reg: %d\n", nic->g_struct_frame_reg[i].frame_type,
 						nic->g_struct_frame_reg[i].reg);
@@ -2635,7 +2638,6 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 								nic->g_struct_frame_reg[i].frame_type,
 								nic->g_struct_frame_reg[i].reg);
 				}
-			}
 
 			bEnablePS = true;
 			host_int_set_power_mgmt(priv->hWILCWFIDrv, 1, 0);
@@ -2648,7 +2650,8 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		connecting = 0;
 		PRINT_D(HOSTAPD_DBG, "Interface type = NL80211_IFTYPE_P2P_CLIENT\n");
 
-		host_int_del_All_Rx_BASession(priv->hWILCWFIDrv, g_linux_wlan->strInterfaceInfo[0].aBSSID, TID);
+		host_int_del_All_Rx_BASession(priv->hWILCWFIDrv,
+					      wl->strInterfaceInfo[0].aBSSID, TID);
 
 		dev->ieee80211_ptr->iftype = type;
 		priv->wdev->iftype = type;
@@ -2657,25 +2660,24 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		PRINT_D(HOSTAPD_DBG, "Downloading P2P_CONCURRENCY_FIRMWARE\n");
 		nic->iftype = CLIENT_MODE;
 
-
-		if (g_linux_wlan->wilc1000_initialized)	{
+		if (wl->wilc1000_initialized) {
 			/* ensure that the message Q is empty */
 			host_int_wait_msg_queue_idle();
 
-			wilc1000_wlan_deinit(g_linux_wlan);
+			wilc1000_wlan_deinit(wl);
 			wilc1000_wlan_init(dev, nic);
 			g_wilc_initialized = 1;
 
-			host_int_set_wfi_drv_handler(g_linux_wlan->strInterfaceInfo[0].drvHandler);
-			host_int_set_MacAddress(g_linux_wlan->strInterfaceInfo[0].drvHandler,
-						g_linux_wlan->strInterfaceInfo[0].aSrcAddress);
+			host_int_set_wfi_drv_handler(wl->strInterfaceInfo[0].drvHandler);
+			host_int_set_MacAddress(wl->strInterfaceInfo[0].drvHandler,
+						wl->strInterfaceInfo[0].aSrcAddress);
 			host_int_set_operation_mode(priv->hWILCWFIDrv, STATION_MODE);
 
 			/*Add saved WEP keys, if any*/
 			if (g_wep_keys_saved) {
-				host_int_set_WEPDefaultKeyID(g_linux_wlan->strInterfaceInfo[0].drvHandler,
+				host_int_set_WEPDefaultKeyID(wl->strInterfaceInfo[0].drvHandler,
 							     g_key_wep_params.key_idx);
-				host_int_add_wep_key_bss_sta(g_linux_wlan->strInterfaceInfo[0].drvHandler,
+				host_int_add_wep_key_bss_sta(wl->strInterfaceInfo[0].drvHandler,
 							     g_key_wep_params.key,
 							     g_key_wep_params.key_len,
 							     g_key_wep_params.key_idx);
@@ -2693,15 +2695,15 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 				PRINT_D(CFG80211_DBG, "gtk %x %x %x\n", g_key_gtk_params.key[0],
 					g_key_gtk_params.key[1],
 					g_key_gtk_params.key[2]);
-				add_key(g_linux_wlan->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
-					g_linux_wlan->strInterfaceInfo[0].wilc_netdev,
+				add_key(wl->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
+					wl->strInterfaceInfo[0].wilc_netdev,
 					g_add_ptk_key_params.key_idx,
 					g_add_ptk_key_params.pairwise,
 					g_add_ptk_key_params.mac_addr,
 					(struct key_params *)(&g_key_ptk_params));
 
-				add_key(g_linux_wlan->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
-					g_linux_wlan->strInterfaceInfo[0].wilc_netdev,
+				add_key(wl->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
+					wl->strInterfaceInfo[0].wilc_netdev,
 					g_add_gtk_key_params.key_idx,
 					g_add_gtk_key_params.pairwise,
 					g_add_gtk_key_params.mac_addr,
@@ -2712,7 +2714,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 			refresh_scan(priv, 1, true);
 			Set_machw_change_vir_if(false);
 
-			if (g_linux_wlan->wilc1000_initialized)	{
+			if (wl->wilc1000_initialized)
 				for (i = 0; i < num_reg_frame; i++) {
 					PRINT_D(INIT_DBG, "Frame registering Type: %x - Reg: %d\n", nic->g_struct_frame_reg[i].frame_type,
 						nic->g_struct_frame_reg[i].reg);
@@ -2720,7 +2722,6 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 								nic->g_struct_frame_reg[i].frame_type,
 								nic->g_struct_frame_reg[i].reg);
 				}
-			}
 		}
 		break;
 
@@ -2735,9 +2736,9 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		PRINT_D(HOSTAPD_DBG, "Downloading AP firmware\n");
 		linux_wlan_get_firmware(nic);
 		/*If wilc is running, then close-open to actually get new firmware running (serves P2P)*/
-		if (g_linux_wlan->wilc1000_initialized)	{
+		if (wl->wilc1000_initialized) {
 			nic->iftype = AP_MODE;
-			g_linux_wlan->wilc1000_initialized = 1;
+			wl->wilc1000_initialized = 1;
 			mac_close(dev);
 			mac_open(dev);
 
@@ -2761,7 +2762,9 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		/*sent before downloading new FW. This is because it blocks on*/
 		/*hWaitResponse semaphore, which allows previous config*/
 		/*packets to actually take action on old FW*/
-		host_int_del_All_Rx_BASession(priv->hWILCWFIDrv, g_linux_wlan->strInterfaceInfo[0].aBSSID, TID);
+		host_int_del_All_Rx_BASession(priv->hWILCWFIDrv,
+					      wl->strInterfaceInfo[0].aBSSID,
+					      TID);
 		bEnablePS = false;
 		PRINT_D(HOSTAPD_DBG, "Interface type = NL80211_IFTYPE_GO\n");
 		dev->ieee80211_ptr->iftype = type;
@@ -2776,22 +2779,22 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 
 		/* ensure that the message Q is empty */
 		host_int_wait_msg_queue_idle();
-		wilc1000_wlan_deinit(g_linux_wlan);
+		wilc1000_wlan_deinit(wl);
 		wilc1000_wlan_init(dev, nic);
 		g_wilc_initialized = 1;
 
 
 		/*Setting interface 1 drv handler and mac address in newly downloaded FW*/
-		host_int_set_wfi_drv_handler(g_linux_wlan->strInterfaceInfo[0].drvHandler);
-		host_int_set_MacAddress(g_linux_wlan->strInterfaceInfo[0].drvHandler,
-					g_linux_wlan->strInterfaceInfo[0].aSrcAddress);
+		host_int_set_wfi_drv_handler(wl->strInterfaceInfo[0].drvHandler);
+		host_int_set_MacAddress(wl->strInterfaceInfo[0].drvHandler,
+					wl->strInterfaceInfo[0].aSrcAddress);
 		host_int_set_operation_mode(priv->hWILCWFIDrv, AP_MODE);
 
 		/*Add saved WEP keys, if any*/
 		if (g_wep_keys_saved) {
-			host_int_set_WEPDefaultKeyID(g_linux_wlan->strInterfaceInfo[0].drvHandler,
+			host_int_set_WEPDefaultKeyID(wl->strInterfaceInfo[0].drvHandler,
 						     g_key_wep_params.key_idx);
-			host_int_add_wep_key_bss_sta(g_linux_wlan->strInterfaceInfo[0].drvHandler,
+			host_int_add_wep_key_bss_sta(wl->strInterfaceInfo[0].drvHandler,
 						     g_key_wep_params.key,
 						     g_key_wep_params.key_len,
 						     g_key_wep_params.key_idx);
@@ -2811,22 +2814,22 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 				g_key_gtk_params.key[1],
 				g_key_gtk_params.key[2],
 				g_key_gtk_params.cipher);
-			add_key(g_linux_wlan->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
-				g_linux_wlan->strInterfaceInfo[0].wilc_netdev,
+			add_key(wl->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
+				wl->strInterfaceInfo[0].wilc_netdev,
 				g_add_ptk_key_params.key_idx,
 				g_add_ptk_key_params.pairwise,
 				g_add_ptk_key_params.mac_addr,
 				(struct key_params *)(&g_key_ptk_params));
 
-			add_key(g_linux_wlan->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
-				g_linux_wlan->strInterfaceInfo[0].wilc_netdev,
+			add_key(wl->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
+				wl->strInterfaceInfo[0].wilc_netdev,
 				g_add_gtk_key_params.key_idx,
 				g_add_gtk_key_params.pairwise,
 				g_add_gtk_key_params.mac_addr,
 				(struct key_params *)(&g_key_gtk_params));
 		}
 
-		if (g_linux_wlan->wilc1000_initialized)	{
+		if (wl->wilc1000_initialized)
 			for (i = 0; i < num_reg_frame; i++) {
 				PRINT_D(INIT_DBG, "Frame registering Type: %x - Reg: %d\n", nic->g_struct_frame_reg[i].frame_type,
 					nic->g_struct_frame_reg[i].reg);
@@ -2834,7 +2837,6 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 							nic->g_struct_frame_reg[i].frame_type,
 							nic->g_struct_frame_reg[i].reg);
 			}
-		}
 		break;
 
 	default:
@@ -2889,7 +2891,7 @@ static int start_ap(struct wiphy *wiphy, struct net_device *dev,
 	if (s32Error != 0)
 		PRINT_ER("Error in setting channel\n");
 
-	linux_wlan_set_bssid(dev, g_linux_wlan->strInterfaceInfo[0].aSrcAddress);
+	linux_wlan_set_bssid(dev, wl->strInterfaceInfo[0].aSrcAddress);
 
 	s32Error = host_int_add_beacon(priv->hWILCWFIDrv,
 					settings->beacon_interval,
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 373959b..2fe0ef0 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -206,7 +206,7 @@ struct WILC_WFI_mon_priv {
 	struct net_device *real_ndev;
 };
 
-extern struct wilc *g_linux_wlan;
+extern struct wilc *wl;
 extern struct net_device *WILC_WFI_devs[];
 void frmw_to_linux(u8 *buff, u32 size, u32 pkt_offset);
 void linux_wlan_mac_indicate(int flag);
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index c731641..317b645 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -114,7 +114,7 @@ static CHIP_PS_STATE_T genuChipPSstate = CHIP_WAKEDUP;
 static inline void acquire_bus(BUS_ACQUIRE_T acquire)
 {
 
-	mutex_lock(&g_linux_wlan->hif_cs);
+	mutex_lock(&wl->hif_cs);
 	#ifndef WILC_OPTIMIZE_SLEEP_INT
 	if (genuChipPSstate != CHIP_WAKEDUP)
 	#endif
@@ -130,7 +130,7 @@ static inline void release_bus(BUS_RELEASE_T release)
 	if (release == RELEASE_ALLOW_SLEEP)
 		chip_allow_sleep();
 	#endif
-	mutex_unlock(&g_linux_wlan->hif_cs);
+	mutex_unlock(&wl->hif_cs);
 }
 /********************************************
  *
@@ -167,7 +167,7 @@ static struct txq_entry_t *wilc_wlan_txq_remove_from_head(void)
 	wilc_wlan_dev_t *p = &g_wlan;
 	unsigned long flags;
 
-	spin_lock_irqsave(&g_linux_wlan->txq_spinlock, flags);
+	spin_lock_irqsave(&wl->txq_spinlock, flags);
 	if (p->txq_head) {
 		tqe = p->txq_head;
 		p->txq_head = tqe->next;
@@ -182,7 +182,7 @@ static struct txq_entry_t *wilc_wlan_txq_remove_from_head(void)
 	} else {
 		tqe = NULL;
 	}
-	spin_unlock_irqrestore(&g_linux_wlan->txq_spinlock, flags);
+	spin_unlock_irqrestore(&wl->txq_spinlock, flags);
 	return tqe;
 }
 
@@ -190,7 +190,7 @@ static void wilc_wlan_txq_add_to_tail(struct txq_entry_t *tqe)
 {
 	wilc_wlan_dev_t *p = &g_wlan;
 	unsigned long flags;
-	spin_lock_irqsave(&g_linux_wlan->txq_spinlock, flags);
+	spin_lock_irqsave(&wl->txq_spinlock, flags);
 
 	if (p->txq_head == NULL) {
 		tqe->next = NULL;
@@ -206,25 +206,25 @@ static void wilc_wlan_txq_add_to_tail(struct txq_entry_t *tqe)
 	p->txq_entries += 1;
 	PRINT_D(TX_DBG, "Number of entries in TxQ = %d\n", p->txq_entries);
 
-	spin_unlock_irqrestore(&g_linux_wlan->txq_spinlock, flags);
+	spin_unlock_irqrestore(&wl->txq_spinlock, flags);
 
 	/**
 	 *      wake up TX queue
 	 **/
 	PRINT_D(TX_DBG, "Wake the txq_handling\n");
 
-	up(&g_linux_wlan->txq_event);
+	up(&wl->txq_event);
 }
 
 static int wilc_wlan_txq_add_to_head(struct txq_entry_t *tqe)
 {
 	wilc_wlan_dev_t *p = &g_wlan;
 	unsigned long flags;
-	if (linux_wlan_lock_timeout(&g_linux_wlan->txq_add_to_head_cs,
+	if (linux_wlan_lock_timeout(&wl->txq_add_to_head_cs,
 				    CFG_PKTS_TIMEOUT))
 		return -1;
 
-	spin_lock_irqsave(&g_linux_wlan->txq_spinlock, flags);
+	spin_lock_irqsave(&wl->txq_spinlock, flags);
 
 	if (p->txq_head == NULL) {
 		tqe->next = NULL;
@@ -240,14 +240,14 @@ static int wilc_wlan_txq_add_to_head(struct txq_entry_t *tqe)
 	p->txq_entries += 1;
 	PRINT_D(TX_DBG, "Number of entries in TxQ = %d\n", p->txq_entries);
 
-	spin_unlock_irqrestore(&g_linux_wlan->txq_spinlock, flags);
-	up(&g_linux_wlan->txq_add_to_head_cs);
+	spin_unlock_irqrestore(&wl->txq_spinlock, flags);
+	up(&wl->txq_add_to_head_cs);
 
 
 	/**
 	 *      wake up TX queue
 	 **/
-	up(&g_linux_wlan->txq_event);
+	up(&wl->txq_event);
 	PRINT_D(TX_DBG, "Wake up the txq_handler\n");
 
 	return 0;
@@ -337,9 +337,9 @@ static inline int remove_TCP_related(void)
 	wilc_wlan_dev_t *p = &g_wlan;
 	unsigned long flags;
 
-	spin_lock_irqsave(&g_linux_wlan->txq_spinlock, flags);
+	spin_lock_irqsave(&wl->txq_spinlock, flags);
 
-	spin_unlock_irqrestore(&g_linux_wlan->txq_spinlock, flags);
+	spin_unlock_irqrestore(&wl->txq_spinlock, flags);
 	return 0;
 }
 
@@ -353,7 +353,7 @@ static inline int tcp_process(struct txq_entry_t *tqe)
 	wilc_wlan_dev_t *p = &g_wlan;
 	unsigned long flags;
 
-	spin_lock_irqsave(&g_linux_wlan->txq_spinlock, flags);
+	spin_lock_irqsave(&wl->txq_spinlock, flags);
 
 	eth_hdr_ptr = &buffer[0];
 	h_proto = ntohs(*((unsigned short *)&eth_hdr_ptr[12]));
@@ -401,7 +401,7 @@ static inline int tcp_process(struct txq_entry_t *tqe)
 	} else {
 		ret = 0;
 	}
-	spin_unlock_irqrestore(&g_linux_wlan->txq_spinlock, flags);
+	spin_unlock_irqrestore(&wl->txq_spinlock, flags);
 	return ret;
 }
 
@@ -413,7 +413,7 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(void)
 	u32 Dropped = 0;
 	wilc_wlan_dev_t *p = &g_wlan;
 
-	spin_lock_irqsave(&g_linux_wlan->txq_spinlock, p->txq_spinlock_flags);
+	spin_lock_irqsave(&wl->txq_spinlock, p->txq_spinlock_flags);
 	for (i = PendingAcks_arrBase; i < (PendingAcks_arrBase + Pending_Acks); i++) {
 		if (Pending_Acks_info[i].ack_num < Acks_keep_track_info[Pending_Acks_info[i].Session_index].Bigger_Ack_num) {
 			struct txq_entry_t *tqe;
@@ -440,12 +440,12 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(void)
 		PendingAcks_arrBase = 0;
 
 
-	spin_unlock_irqrestore(&g_linux_wlan->txq_spinlock,
+	spin_unlock_irqrestore(&wl->txq_spinlock,
 			       p->txq_spinlock_flags);
 
 	while (Dropped > 0) {
 		/*consume the semaphore count of the removed packet*/
-		linux_wlan_lock_timeout(&g_linux_wlan->txq_event, 1);
+		linux_wlan_lock_timeout(&wl->txq_event, 1);
 		Dropped--;
 	}
 
@@ -473,7 +473,7 @@ static int wilc_wlan_txq_add_cfg_pkt(u8 *buffer, u32 buffer_size)
 	PRINT_D(TX_DBG, "Adding config packet ...\n");
 	if (p->quit) {
 		PRINT_D(TX_DBG, "Return due to clear function\n");
-		up(&g_linux_wlan->cfg_event);
+		up(&wl->cfg_event);
 		return 0;
 	}
 
@@ -563,11 +563,11 @@ static struct txq_entry_t *wilc_wlan_txq_get_first(void)
 	struct txq_entry_t *tqe;
 	unsigned long flags;
 
-	spin_lock_irqsave(&g_linux_wlan->txq_spinlock, flags);
+	spin_lock_irqsave(&wl->txq_spinlock, flags);
 
 	tqe = p->txq_head;
 
-	spin_unlock_irqrestore(&g_linux_wlan->txq_spinlock, flags);
+	spin_unlock_irqrestore(&wl->txq_spinlock, flags);
 
 
 	return tqe;
@@ -576,10 +576,10 @@ static struct txq_entry_t *wilc_wlan_txq_get_first(void)
 static struct txq_entry_t *wilc_wlan_txq_get_next(struct txq_entry_t *tqe)
 {
 	unsigned long flags;
-	spin_lock_irqsave(&g_linux_wlan->txq_spinlock, flags);
+	spin_lock_irqsave(&wl->txq_spinlock, flags);
 
 	tqe = tqe->next;
-	spin_unlock_irqrestore(&g_linux_wlan->txq_spinlock, flags);
+	spin_unlock_irqrestore(&wl->txq_spinlock, flags);
 
 
 	return tqe;
@@ -592,7 +592,7 @@ static int wilc_wlan_rxq_add(struct rxq_entry_t *rqe)
 	if (p->quit)
 		return 0;
 
-	mutex_lock(&g_linux_wlan->rxq_cs);
+	mutex_lock(&wl->rxq_cs);
 	if (p->rxq_head == NULL) {
 		PRINT_D(RX_DBG, "Add to Queue head\n");
 		rqe->next = NULL;
@@ -606,7 +606,7 @@ static int wilc_wlan_rxq_add(struct rxq_entry_t *rqe)
 	}
 	p->rxq_entries += 1;
 	PRINT_D(RX_DBG, "Number of queue entries: %d\n", p->rxq_entries);
-	mutex_unlock(&g_linux_wlan->rxq_cs);
+	mutex_unlock(&wl->rxq_cs);
 	return p->rxq_entries;
 }
 
@@ -618,12 +618,12 @@ static struct rxq_entry_t *wilc_wlan_rxq_remove(void)
 	if (p->rxq_head) {
 		struct rxq_entry_t *rqe;
 
-		mutex_lock(&g_linux_wlan->rxq_cs);
+		mutex_lock(&wl->rxq_cs);
 		rqe = p->rxq_head;
 		p->rxq_head = p->rxq_head->next;
 		p->rxq_entries -= 1;
 		PRINT_D(RX_DBG, "RXQ entries decreased\n");
-		mutex_unlock(&g_linux_wlan->rxq_cs);
+		mutex_unlock(&wl->rxq_cs);
 		return rqe;
 	}
 	PRINT_D(RX_DBG, "Nothing to get from Q\n");
@@ -834,7 +834,7 @@ int wilc_wlan_handle_txq(u32 *pu32TxqCount)
 		if (p->quit)
 			break;
 
-		linux_wlan_lock_timeout(&g_linux_wlan->txq_add_to_head_cs,
+		linux_wlan_lock_timeout(&wl->txq_add_to_head_cs,
 					CFG_PKTS_TIMEOUT);
 #ifdef	TCP_ACK_FILTER
 		wilc_wlan_txq_filter_dup_tcp_ack();
@@ -1098,7 +1098,7 @@ _end_:
 		if (ret != 1)
 			break;
 	} while (0);
-	up(&g_linux_wlan->txq_add_to_head_cs);
+	up(&wl->txq_add_to_head_cs);
 
 	p->txq_exit = 1;
 	PRINT_D(TX_DBG, "THREAD: Exiting txq\n");
@@ -1122,7 +1122,7 @@ static void wilc_wlan_handle_rxq(void)
 	do {
 		if (p->quit) {
 			PRINT_D(RX_DBG, "exit 1st do-while due to Clean_UP function\n");
-			up(&g_linux_wlan->cfg_event);
+			up(&wl->cfg_event);
 			break;
 		}
 		rqe = wilc_wlan_rxq_remove();
@@ -1194,7 +1194,7 @@ static void wilc_wlan_handle_rxq(void)
 						 **/
 						PRINT_D(RX_DBG, "p->cfg_seq_no = %d - rsp.seq_no = %d\n", p->cfg_seq_no, rsp.seq_no);
 						if (p->cfg_seq_no == rsp.seq_no)
-							up(&g_linux_wlan->cfg_event);
+							up(&wl->cfg_event);
 					} else if (rsp.type == WILC_CFG_RSP_STATUS) {
 						/**
 						 *      Call back to indicate status...
@@ -1764,7 +1764,7 @@ int wilc_wlan_cfg_set(int start, u32 wid, u8 *buffer, u32 buffer_size,
 		if (wilc_wlan_cfg_commit(WILC_CFG_SET, drvHandler))
 			ret_size = 0;
 
-		if (linux_wlan_lock_timeout(&g_linux_wlan->cfg_event,
+		if (linux_wlan_lock_timeout(&wl->cfg_event,
 					    CFG_PKTS_TIMEOUT)) {
 			PRINT_D(TX_DBG, "Set Timed Out\n");
 			ret_size = 0;
@@ -1802,7 +1802,7 @@ int wilc_wlan_cfg_get(int start, u32 wid, int commit, u32 drvHandler)
 			ret_size = 0;
 
 
-		if (linux_wlan_lock_timeout(&g_linux_wlan->cfg_event,
+		if (linux_wlan_lock_timeout(&wl->cfg_event,
 					    CFG_PKTS_TIMEOUT)) {
 			PRINT_D(TX_DBG, "Get Timed Out\n");
 			ret_size = 0;
@@ -2044,7 +2044,7 @@ u16 Set_machw_change_vir_if(bool bValue)
 	u32 reg;
 
 	/*Reset WILC_CHANGING_VIR_IF register to allow adding futrue keys to CE H/W*/
-	mutex_lock(&g_linux_wlan->hif_cs);
+	mutex_lock(&wl->hif_cs);
 	ret = (&g_wlan)->hif_func.hif_read_reg(WILC_CHANGING_VIR_IF, &reg);
 	if (!ret)
 		PRINT_ER("Error while Reading reg WILC_CHANGING_VIR_IF\n");
@@ -2059,7 +2059,7 @@ u16 Set_machw_change_vir_if(bool bValue)
 	if (!ret)
 		PRINT_ER("Error while writing reg WILC_CHANGING_VIR_IF\n");
 
-	mutex_unlock(&g_linux_wlan->hif_cs);
+	mutex_unlock(&wl->hif_cs);
 
 	return ret;
 }
-- 
1.9.1

