Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:7511 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053AbbKBIt7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2015 03:49:59 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 17/38] staging: wilc1000: linux_wlan.c: clean up comments
Date: Mon, 2 Nov 2015 17:51:00 +0900
Message-ID: <1446454281-22484-17-git-send-email-glen.lee@atmel.com> (sfid-20151102_101657_887547_DB941DC7)
In-Reply-To: <1446454281-22484-1-git-send-email-glen.lee@atmel.com>
References: <1446454281-22484-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

There are over-commenting in the linux_wlan.c file and most of them
are not helpful to explain what the code does and generate 80 ending
line over warnings. So, all of comments and commented codes are removed in
this patch. Comment will be added if necessary with the preferred Linux style.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 218 ++++------------------------------
 1 file changed, 26 insertions(+), 192 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index b7c40ac..e7e5229 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -79,12 +79,6 @@ static struct notifier_block g_dev_notifier = {
 
 #define IRQ_WAIT	1
 #define IRQ_NO_WAIT	0
-/*
- *      to sync between mac_close and module exit.
- *      don't initialize or de-initialize from init/deinitlocks
- *      to be initialized from module wilc_netdev_init and
- *      deinitialized from mdoule_exit
- */
 static struct semaphore close_exit_sync;
 
 static int wlan_deinit_locks(struct net_device *dev);
@@ -101,10 +95,6 @@ static struct net_device_stats *mac_stats(struct net_device *dev);
 static int  mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd);
 static void wilc_set_multicast_list(struct net_device *dev);
 
-/*
- * for now - in frmw_to_linux there should be private data to be passed to it
- * and this data should be pointer to net device
- */
 bool bEnablePS = true;
 
 static const struct net_device_ops wilc_netdev_ops = {
@@ -156,15 +146,14 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 		return NOTIFY_DONE;
 	}
 
-	PRINT_INFO(GENERIC_DBG, "dev_state_ev_handler +++\n"); /* tony */
+	PRINT_INFO(GENERIC_DBG, "dev_state_ev_handler +++\n");
 
 	switch (event) {
 	case NETDEV_UP:
-		PRINT_D(GENERIC_DBG, "dev_state_ev_handler event=NETDEV_UP %p\n", dev);       /* tony */
+		PRINT_D(GENERIC_DBG, "dev_state_ev_handler event=NETDEV_UP %p\n", dev);
 
 		PRINT_INFO(GENERIC_DBG, "\n ============== IP Address Obtained ===============\n\n");
 
-		/*If we are in station mode or client mode*/
 		if (nic->iftype == STATION_MODE || nic->iftype == CLIENT_MODE) {
 			hif_drv->IFC_UP = 1;
 			g_obtainingIP = false;
@@ -186,7 +175,7 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 		break;
 
 	case NETDEV_DOWN:
-		PRINT_D(GENERIC_DBG, "dev_state_ev_handler event=NETDEV_DOWN %p\n", dev);               /* tony */
+		PRINT_D(GENERIC_DBG, "dev_state_ev_handler event=NETDEV_DOWN %p\n", dev);
 
 		PRINT_INFO(GENERIC_DBG, "\n ============== IP Address Released ===============\n\n");
 		if (nic->iftype == STATION_MODE || nic->iftype == CLIENT_MODE) {
@@ -211,7 +200,7 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 		break;
 
 	default:
-		PRINT_INFO(GENERIC_DBG, "dev_state_ev_handler event=default\n");        /* tony */
+		PRINT_INFO(GENERIC_DBG, "dev_state_ev_handler event=default\n");
 		PRINT_INFO(GENERIC_DBG, "[%s] unknown dev event: %lu\n", dev_iface->ifa_label, event);
 
 		break;
@@ -231,7 +220,6 @@ static irqreturn_t isr_uh_routine(int irq, void *user_data)
 	wilc = nic->wilc;
 	PRINT_D(INT_DBG, "Interrupt received UH\n");
 
-	/*While mac is closing cacncel the handling of any interrupts received*/
 	if (wilc->close) {
 		PRINT_ER("Driver is CLOSING: Can't handle UH interrupt\n");
 		return IRQ_HANDLED;
@@ -248,7 +236,6 @@ irqreturn_t isr_bh_routine(int irq, void *userdata)
 	nic = netdev_priv(userdata);
 	wilc = nic->wilc;
 
-	/*While mac is closing cacncel the handling of any interrupts received*/
 	if (wilc->close) {
 		PRINT_ER("Driver is CLOSING: Can't handle BH interrupt\n");
 		return IRQ_HANDLED;
@@ -270,8 +257,6 @@ static int init_irq(struct net_device *dev)
 	nic = netdev_priv(dev);
 	wl = nic->wilc;
 
-	/*initialize GPIO and register IRQ num*/
-	/*GPIO request*/
 	if ((gpio_request(GPIO_NUM, "WILC_INTR") == 0) &&
 	    (gpio_direction_input(GPIO_NUM) == 0)) {
 		wl->dev_irq_num = gpio_to_irq(GPIO_NUM);
@@ -281,7 +266,7 @@ static int init_irq(struct net_device *dev)
 	}
 
 	if ((ret != -1) && (request_threaded_irq(wl->dev_irq_num, isr_uh_routine, isr_bh_routine,
-						  IRQF_TRIGGER_LOW | IRQF_ONESHOT,               /*Without IRQF_ONESHOT the uh will remain kicked in and dont gave a chance to bh*/
+						  IRQF_TRIGGER_LOW | IRQF_ONESHOT,
 						  "WILC_IRQ", dev)) < 0) {
 		PRINT_ER("Failed to request IRQ for GPIO: %d\n", GPIO_NUM);
 		ret = -1;
@@ -303,7 +288,6 @@ static void deinit_irq(struct net_device *dev)
 	wilc = nic->wilc;
 
 #if (defined WILC_SPI) || (defined WILC_SDIO_IRQ_GPIO)
-	/* Deintialize IRQ */
 	if (&wilc->dev_irq_num != 0) {
 		free_irq(wilc->dev_irq_num, wilc);
 
@@ -312,9 +296,6 @@ static void deinit_irq(struct net_device *dev)
 #endif
 }
 
-/*
- *      OS functions
- */
 void linux_wlan_dbg(u8 *buff)
 {
 	PRINT_D(INIT_DBG, "%d\n", *buff);
@@ -334,9 +315,6 @@ int linux_wlan_lock_timeout(void *vp, u32 timeout)
 
 void linux_wlan_mac_indicate(struct wilc *wilc, int flag)
 {
-	/*I have to do it that way becuase there is no mean to encapsulate device pointer
-	 * as a parameter
-	 */
 	int status;
 
 	if (flag == WILC_MAC_INDICATE_STATUS) {
@@ -348,7 +326,7 @@ void linux_wlan_mac_indicate(struct wilc *wilc, int flag)
 			wilc->mac_status = status;
 		}
 
-		if (wilc->mac_status == WILC_MAC_STATUS_CONNECT) {        /* Connect */
+		if (wilc->mac_status == WILC_MAC_STATUS_CONNECT) {
 		}
 	} else if (flag == WILC_MAC_INDICATE_SCAN) {
 		PRINT_D(GENERIC_DBG, "Scanning ...\n");
@@ -402,7 +380,6 @@ int linux_wlan_set_bssid(struct net_device *wilc_netdev, u8 *pBSSID)
 	return ret;
 }
 
-/*Function to get number of connected interfaces*/
 int linux_wlan_get_num_conn_ifcs(struct net_device *dev)
 {
 	u8 i = 0;
@@ -440,16 +417,13 @@ static int linux_wlan_txq_task(void *vp)
 	nic = netdev_priv(dev);
 	wl = nic->wilc;
 
-	/* inform wilc1000_wlan_init that TXQ task is started. */
 	up(&wl->txq_thread_started);
 	while (1) {
 		PRINT_D(TX_DBG, "txq_task Taking a nap :)\n");
 		down(&wl->txq_event);
-		/* wait_for_completion(&pd->txq_event); */
 		PRINT_D(TX_DBG, "txq_task Who waked me up :$\n");
 
 		if (wl->close) {
-			/*Unlock the mutex in the mac_close function to indicate the exiting of the TX thread */
 			up(&wl->txq_thread_started);
 
 			while (!kthread_should_stop())
@@ -464,23 +438,19 @@ static int linux_wlan_txq_task(void *vp)
 #else
 		do {
 			ret = wilc_wlan_handle_txq(dev, &txq_count);
-			if (txq_count < FLOW_CONTROL_LOWER_THRESHOLD /* && netif_queue_stopped(pd->wilc_netdev)*/) {
+			if (txq_count < FLOW_CONTROL_LOWER_THRESHOLD) {
 				PRINT_D(TX_DBG, "Waking up queue\n");
-				/* netif_wake_queue(pd->wilc_netdev); */
+
 				if (netif_queue_stopped(wl->vif[0].ndev))
 					netif_wake_queue(wl->vif[0].ndev);
 				if (netif_queue_stopped(wl->vif[1].ndev))
 					netif_wake_queue(wl->vif[1].ndev);
 			}
 
-			if (ret == WILC_TX_ERR_NO_BUF) { /* failed to allocate buffers in chip. */
+			if (ret == WILC_TX_ERR_NO_BUF) {
 				do {
-					/* Back off from sending packets for some time. */
-					/* schedule_timeout will allow RX task to run and free buffers.*/
-					/* set_current_state(TASK_UNINTERRUPTIBLE); */
-					/* timeout = schedule_timeout(timeout); */
 					msleep(TX_BACKOFF_WEIGHT_UNIT_MS << backoff_weight);
-				} while (/*timeout*/ 0);
+				} while (0);
 				backoff_weight += TX_BACKOFF_WEIGHT_INCR_STEP;
 				if (backoff_weight > TX_BACKOFF_WEIGHT_MAX)
 					backoff_weight = TX_BACKOFF_WEIGHT_MAX;
@@ -491,8 +461,7 @@ static int linux_wlan_txq_task(void *vp)
 						backoff_weight = TX_BACKOFF_WEIGHT_MIN;
 				}
 			}
-			/*TODO: drop packets after a certain time/number of retry count. */
-		} while (ret == WILC_TX_ERR_NO_BUF && !wl->close); /* retry sending packets if no more buffers in chip. */
+		} while (ret == WILC_TX_ERR_NO_BUF && !wl->close);
 #endif
 	}
 	return 0;
@@ -534,9 +503,6 @@ int linux_wlan_get_firmware(struct net_device *dev)
 		goto _fail_;
 	}
 
-	/*	the firmare should be located in /lib/firmware in
-	 *      root file system with the name specified above */
-
 #ifdef WILC_SDIO
 	if (request_firmware(&wilc_firmware, firmware, &wilc->wilc_sdio_func->dev) != 0) {
 		PRINT_ER("%s - firmare not available\n", firmware);
@@ -566,7 +532,6 @@ static int linux_wlan_start_firmware(struct net_device *dev)
 	nic = netdev_priv(dev);
 	wilc = nic->wilc;
 
-	/* start firmware */
 	PRINT_D(INIT_DBG, "Starting Firmware ...\n");
 	ret = wilc_wlan_start(dev);
 	if (ret < 0) {
@@ -574,17 +539,12 @@ static int linux_wlan_start_firmware(struct net_device *dev)
 		goto _fail_;
 	}
 
-	/* wait for mac ready */
 	PRINT_D(INIT_DBG, "Waiting for Firmware to get ready ...\n");
 	ret = linux_wlan_lock_timeout(&wilc->sync_event, 5000);
 	if (ret) {
 		PRINT_D(INIT_DBG, "Firmware start timed out");
 		goto _fail_;
 	}
-	/*
-	 *      TODO: Driver shouoldn't wait forever for firmware to get started -
-	 *      in case of timeout this should be handled properly
-	 */
 	PRINT_D(INIT_DBG, "Firmware successfully started\n");
 
 _fail_:
@@ -604,16 +564,12 @@ static int linux_wlan_firmware_download(struct net_device *dev)
 		ret = -ENOBUFS;
 		goto _FAIL_;
 	}
-	/**
-	 *      do the firmware download
-	 **/
 	PRINT_D(INIT_DBG, "Downloading Firmware ...\n");
 	ret = wilc_wlan_firmware_download(dev, wilc->firmware->data,
 					  wilc->firmware->size);
 	if (ret < 0)
 		goto _FAIL_;
 
-	/* Freeing FW buffer */
 	PRINT_D(INIT_DBG, "Freeing FW buffer ...\n");
 	PRINT_D(INIT_DBG, "Releasing firmware\n");
 	release_firmware(wilc->firmware);
@@ -624,7 +580,6 @@ _FAIL_:
 	return ret;
 }
 
-/* startup configuration - could be changed later using iconfig*/
 static int linux_wlan_init_test_config(struct net_device *dev, struct wilc *p_nic)
 {
 	unsigned char c_val[64];
@@ -648,7 +603,6 @@ static int linux_wlan_init_test_config(struct net_device *dev, struct wilc *p_ni
 	if (!wilc_wlan_cfg_set(dev, 1, WID_SET_DRV_HANDLER, c_val, 4, 0, 0))
 		goto _fail_;
 
-	/*to tell fw that we are going to use PC test - WILC specific*/
 	c_val[0] = 0;
 	if (!wilc_wlan_cfg_set(dev, 0, WID_PC_TEST_MODE, c_val, 1, 0, 0))
 		goto _fail_;
@@ -657,7 +611,6 @@ static int linux_wlan_init_test_config(struct net_device *dev, struct wilc *p_ni
 	if (!wilc_wlan_cfg_set(dev, 0, WID_BSS_TYPE, c_val, 1, 0, 0))
 		goto _fail_;
 
-	/* c_val[0] = RATE_AUTO; */
 	c_val[0] = RATE_AUTO;
 	if (!wilc_wlan_cfg_set(dev, 0, WID_CURRENT_TX_RATE, c_val, 1, 0, 0))
 		goto _fail_;
@@ -686,7 +639,7 @@ static int linux_wlan_init_test_config(struct net_device *dev, struct wilc *p_ni
 	if (!wilc_wlan_cfg_set(dev, 0, WID_SITE_SURVEY, c_val, 1, 0, 0))
 		goto _fail_;
 
-	*((int *)c_val) = 0xffff; /* Never use RTS-CTS */
+	*((int *)c_val) = 0xffff;
 	if (!wilc_wlan_cfg_set(dev, 0, WID_RTS_THRESHOLD, c_val, 2, 0, 0))
 		goto _fail_;
 
@@ -694,13 +647,6 @@ static int linux_wlan_init_test_config(struct net_device *dev, struct wilc *p_ni
 	if (!wilc_wlan_cfg_set(dev, 0, WID_FRAG_THRESHOLD, c_val, 2, 0, 0))
 		goto _fail_;
 
-	/*  SSID                                                                 */
-	/*  --------------------------------------------------------------       */
-	/*  Configuration :   String with length less than 32 bytes              */
-	/*  Values to set :   Any string with length less than 32 bytes          */
-	/*                    ( In BSS Station Set SSID to "" (null string)      */
-	/*                      to enable Broadcast SSID suppport )              */
-	/*  --------------------------------------------------------------       */
 	c_val[0] = 0;
 	if (!wilc_wlan_cfg_set(dev, 0, WID_BCAST_SSID, c_val, 1, 0, 0))
 		goto _fail_;
@@ -713,7 +659,7 @@ static int linux_wlan_init_test_config(struct net_device *dev, struct wilc *p_ni
 	if (!wilc_wlan_cfg_set(dev, 0, WID_POWER_MANAGEMENT, c_val, 1, 0, 0))
 		goto _fail_;
 
-	c_val[0] = NO_ENCRYPT; /* NO_ENCRYPT, 0x79 */
+	c_val[0] = NO_ENCRYPT;
 	if (!wilc_wlan_cfg_set(dev, 0, WID_11I_MODE, c_val, 1, 0, 0))
 		goto _fail_;
 
@@ -721,43 +667,18 @@ static int linux_wlan_init_test_config(struct net_device *dev, struct wilc *p_ni
 	if (!wilc_wlan_cfg_set(dev, 0, WID_AUTH_TYPE, c_val, 1, 0, 0))
 		goto _fail_;
 
-	/*  WEP/802 11I Configuration                                            */
-	/*  ------------------------------------------------------------------   */
-	/*  Configuration : WEP Key                                              */
-	/*  Values (0x)   : 5 byte for WEP40 and 13 bytes for WEP104             */
-	/*                  In case more than 5 bytes are passed on for WEP 40   */
-	/*                  only first 5 bytes will be used as the key           */
-	/*  ------------------------------------------------------------------   */
-
 	strcpy(c_val, "123456790abcdef1234567890");
 	if (!wilc_wlan_cfg_set(dev, 0, WID_WEP_KEY_VALUE, c_val, (strlen(c_val) + 1), 0, 0))
 		goto _fail_;
 
-	/*  WEP/802 11I Configuration                                            */
-	/*  ------------------------------------------------------------------   */
-	/*  Configuration : AES/TKIP WPA/RSNA Pre-Shared Key                     */
-	/*  Values to set : Any string with length greater than equal to 8 bytes */
-	/*                  and less than 64 bytes                               */
-	/*  ------------------------------------------------------------------   */
 	strcpy(c_val, "12345678");
 	if (!wilc_wlan_cfg_set(dev, 0, WID_11I_PSK, c_val, (strlen(c_val)), 0, 0))
 		goto _fail_;
 
-	/*  IEEE802.1X Key Configuration                                         */
-	/*  ------------------------------------------------------------------   */
-	/*  Configuration : Radius Server Access Secret Key                      */
-	/*  Values to set : Any string with length greater than equal to 8 bytes */
-	/*                  and less than 65 bytes                               */
-	/*  ------------------------------------------------------------------   */
 	strcpy(c_val, "password");
 	if (!wilc_wlan_cfg_set(dev, 0, WID_1X_KEY, c_val, (strlen(c_val) + 1), 0, 0))
 		goto _fail_;
 
-	/*   IEEE802.1X Server Address Configuration                             */
-	/*  ------------------------------------------------------------------   */
-	/*  Configuration : Radius Server IP Address                             */
-	/*  Values to set : Any valid IP Address                                 */
-	/*  ------------------------------------------------------------------   */
 	c_val[0] = 192;
 	c_val[1] = 168;
 	c_val[2] = 1;
@@ -789,12 +710,6 @@ static int linux_wlan_init_test_config(struct net_device *dev, struct wilc *p_ni
 	if (!wilc_wlan_cfg_set(dev, 0, WID_TX_POWER_LEVEL_11B, c_val, 1, 0, 0))
 		goto _fail_;
 
-	/*  Beacon Interval                                                      */
-	/*  -------------------------------------------------------------------- */
-	/*  Configuration : Sets the beacon interval value                       */
-	/*  Values to set : Any 16-bit value                                     */
-	/*  -------------------------------------------------------------------- */
-
 	*((int *)c_val) = 100;
 	if (!wilc_wlan_cfg_set(dev, 0, WID_BEACON_INTERVAL, c_val, 2, 0, 0))
 		goto _fail_;
@@ -803,20 +718,10 @@ static int linux_wlan_init_test_config(struct net_device *dev, struct wilc *p_ni
 	if (!wilc_wlan_cfg_set(dev, 0, WID_REKEY_POLICY, c_val, 1, 0, 0))
 		goto _fail_;
 
-	/*  Rekey Time (s) (Used only when the Rekey policy is 2 or 4)           */
-	/*  -------------------------------------------------------------------- */
-	/*  Configuration : Sets the Rekey Time (s)                              */
-	/*  Values to set : 32-bit value                                         */
-	/*  -------------------------------------------------------------------- */
 	*((int *)c_val) = 84600;
 	if (!wilc_wlan_cfg_set(dev, 0, WID_REKEY_PERIOD, c_val, 4, 0, 0))
 		goto _fail_;
 
-	/*  Rekey Packet Count (in 1000s; used when Rekey Policy is 3)           */
-	/*  -------------------------------------------------------------------- */
-	/*  Configuration : Sets Rekey Group Packet count                        */
-	/*  Values to set : 32-bit Value                                         */
-	/*  -------------------------------------------------------------------- */
 	*((int *)c_val) = 500;
 	if (!wilc_wlan_cfg_set(dev, 0, WID_REKEY_PACKET_COUNT, c_val, 4, 0, 0))
 		goto _fail_;
@@ -829,7 +734,7 @@ static int linux_wlan_init_test_config(struct net_device *dev, struct wilc *p_ni
 	if (!wilc_wlan_cfg_set(dev, 0, WID_11N_ERP_PROT_TYPE, c_val, 1, 0, 0))
 		goto _fail_;
 
-	c_val[0] = 1;  /* Enable N */
+	c_val[0] = 1;
 	if (!wilc_wlan_cfg_set(dev, 0, WID_11N_ENABLE, c_val, 1, 0, 0))
 		goto _fail_;
 
@@ -837,7 +742,7 @@ static int linux_wlan_init_test_config(struct net_device *dev, struct wilc *p_ni
 	if (!wilc_wlan_cfg_set(dev, 0, WID_11N_OPERATING_MODE, c_val, 1, 0, 0))
 		goto _fail_;
 
-	c_val[0] = 1;   /* TXOP Prot disable in N mode: No RTS-CTS on TX A-MPDUs to save air-time. */
+	c_val[0] = 1;
 	if (!wilc_wlan_cfg_set(dev, 0, WID_11N_TXOP_PROT_DISABLE, c_val, 1, 0, 0))
 		goto _fail_;
 
@@ -846,9 +751,6 @@ static int linux_wlan_init_test_config(struct net_device *dev, struct wilc *p_ni
 	if (!wilc_wlan_cfg_set(dev, 0, WID_MAC_ADDR, c_val, 6, 0, 0))
 		goto _fail_;
 
-	/**
-	 *      AP only
-	 **/
 	c_val[0] = DETECT_PROTECT_REPORT;
 	if (!wilc_wlan_cfg_set(dev, 0, WID_11N_OBSS_NONHT_DETECTION, c_val, 1, 0, 0))
 		goto _fail_;
@@ -869,7 +771,7 @@ static int linux_wlan_init_test_config(struct net_device *dev, struct wilc *p_ni
 	if (!wilc_wlan_cfg_set(dev, 0, WID_11N_CURRENT_TX_MCS, c_val, 1, 0, 0))
 		goto _fail_;
 
-	c_val[0] = 1; /* Enable N with immediate block ack. */
+	c_val[0] = 1;
 	if (!wilc_wlan_cfg_set(dev, 0, WID_11N_IMMEDIATE_BA_ENABLED, c_val, 1, 1, 1))
 		goto _fail_;
 
@@ -879,7 +781,6 @@ _fail_:
 	return -1;
 }
 
-/**************************/
 void wilc1000_wlan_deinit(struct net_device *dev)
 {
 	perInterface_wlan_t *nic;
@@ -897,7 +798,6 @@ void wilc1000_wlan_deinit(struct net_device *dev)
 		netdev_info(dev, "Deinitializing wilc1000...\n");
 
 #if defined(PLAT_ALLWINNER_A20) || defined(PLAT_ALLWINNER_A23) || defined(PLAT_ALLWINNER_A31)
-		/* johnny : remove */
 		PRINT_D(INIT_DBG, "skip wilc_bus_set_default_speed\n");
 #else
 		wilc_bus_set_default_speed();
@@ -932,11 +832,9 @@ void wilc1000_wlan_deinit(struct net_device *dev)
   #endif
 #endif
 
-		/*De-Initialize locks*/
 		PRINT_D(INIT_DBG, "Deinitializing Locks\n");
 		wlan_deinit_locks(dev);
 
-		/* announce that wilc1000 is not initialized */
 		wl->initialized = false;
 
 		PRINT_D(INIT_DBG, "wilc1000 deinitialization Done\n");
@@ -1025,8 +923,6 @@ int wlan_initialize_threads(struct net_device *dev)
 	wilc = nic->wilc;
 
 	PRINT_D(INIT_DBG, "Initializing Threads ...\n");
-
-	/* create tx task */
 	PRINT_D(INIT_DBG, "Creating kthread for transmission\n");
 	wilc->txq_thread = kthread_run(linux_wlan_txq_task, (void *)dev,
 				     "K_TXQ_TASK");
@@ -1035,13 +931,11 @@ int wlan_initialize_threads(struct net_device *dev)
 		ret = -ENOBUFS;
 		goto _fail_2;
 	}
-	/* wait for TXQ task to start. */
 	down(&wilc->txq_thread_started);
 
 	return 0;
 
 _fail_2:
-	/*De-Initialize 2nd thread*/
 	wilc->close = 0;
 	return ret;
 }
@@ -1117,7 +1011,6 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 			goto _fail_irq_enable_;
 		}
 
-		/*Download firmware*/
 		ret = linux_wlan_firmware_download(dev);
 		if (ret < 0) {
 			PRINT_ER("Failed to download firmware\n");
@@ -1125,7 +1018,6 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 			goto _fail_irq_enable_;
 		}
 
-		/* Start firmware*/
 		ret = linux_wlan_start_firmware(dev);
 		if (ret < 0) {
 			PRINT_ER("Failed to start firmware\n");
@@ -1145,7 +1037,6 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 			Firmware_ver[size] = '\0';
 			PRINT_D(INIT_DBG, "***** Firmware Ver = %s  *******\n", Firmware_ver);
 		}
-		/* Initialize firmware with default configuration */
 		ret = linux_wlan_init_test_config(dev, wl);
 
 		if (ret < 0) {
@@ -1155,7 +1046,7 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 		}
 
 		wl->initialized = true;
-		return 0; /*success*/
+		return 0;
 
 _fail_fw_start_:
 		wilc_wlan_stop(dev);
@@ -1181,26 +1072,18 @@ _fail_locks_:
 	return ret;
 }
 
-/*
- *      - this function will be called automatically by OS when module inserted.
- */
-
 int mac_init_fn(struct net_device *ndev)
 {
-	/*Why we do this !!!*/
-	netif_start_queue(ndev); /* ma */
-	netif_stop_queue(ndev); /* ma */
+	netif_start_queue(ndev);
+	netif_stop_queue(ndev);
 
 	return 0;
 }
 
-/* This fn is called, when this device is setup using ifconfig */
 int mac_open(struct net_device *ndev)
 {
 	perInterface_wlan_t *nic;
 
-	/*No need for setting mac address here anymore,*/
-	/*Just set it in init_test_config()*/
 	unsigned char mac_add[ETH_ALEN] = {0};
 	int ret = 0;
 	int i = 0;
@@ -1227,7 +1110,6 @@ int mac_open(struct net_device *ndev)
 		return ret;
 	}
 
-	/*initialize platform*/
 	PRINT_D(INIT_DBG, "*** re-init ***\n");
 	ret = wilc1000_wlan_init(ndev, nic);
 	if (ret < 0) {
@@ -1241,7 +1123,6 @@ int mac_open(struct net_device *ndev)
 	host_int_get_MacAddress(priv->hWILCWFIDrv, mac_add);
 	PRINT_D(INIT_DBG, "Mac address: %pM\n", mac_add);
 
-	/* loop through the NUM of supported devices and set the MAC address */
 	for (i = 0; i < wl->vif_num; i++) {
 		if (ndev == wl->vif[i].ndev) {
 			memcpy(wl->vif[i].src_addr, mac_add, ETH_ALEN);
@@ -1250,7 +1131,6 @@ int mac_open(struct net_device *ndev)
 		}
 	}
 
-	/* TODO: get MAC address whenever the source is EPROM - hardcoded and copy it to ndev*/
 	memcpy(ndev->dev_addr, wl->vif[i].src_addr, ETH_ALEN);
 
 	if (!is_valid_ether_addr(ndev->dev_addr)) {
@@ -1281,7 +1161,6 @@ struct net_device_stats *mac_stats(struct net_device *dev)
 	return &nic->netstats;
 }
 
-/* Setup the multicast filter */
 static void wilc_set_multicast_list(struct net_device *dev)
 {
 	struct netdev_hw_addr *ha;
@@ -1298,30 +1177,22 @@ static void wilc_set_multicast_list(struct net_device *dev)
 	PRINT_D(INIT_DBG, "Setting Multicast List with count = %d.\n", dev->mc.count);
 
 	if (dev->flags & IFF_PROMISC) {
-		/* Normally, we should configure the chip to retrive all packets
-		 * but we don't wanna support this right now */
-		/* TODO: add promiscuous mode support */
 		PRINT_D(INIT_DBG, "Set promiscuous mode ON, retrive all packets\n");
 		return;
 	}
 
-	/* If there's more addresses than we handle, get all multicast
-	 * packets and sort them out in software. */
 	if ((dev->flags & IFF_ALLMULTI) || (dev->mc.count) > WILC_MULTICAST_TABLE_SIZE) {
 		PRINT_D(INIT_DBG, "Disable multicast filter, retrive all multicast packets\n");
-		/* get all multicast packets */
 		host_int_setup_multicast_filter(hif_drv, false, 0);
 		return;
 	}
 
-	/* No multicast?  Just get our own stuff */
 	if ((dev->mc.count) == 0) {
 		PRINT_D(INIT_DBG, "Enable multicast filter, retrive directed packets only.\n");
 		host_int_setup_multicast_filter(hif_drv, true, 0);
 		return;
 	}
 
-	/* Store all of the multicast addresses in the hardware filter */
 	netdev_for_each_mc_addr(ha, dev)
 	{
 		memcpy(multicast_mac_addr_list[i], ha->addr, ETH_ALEN);
@@ -1348,7 +1219,6 @@ static void linux_wlan_tx_complete(void *priv, int status)
 		PRINT_D(TX_DBG, "Packet sent successfully - Size = %d - Address = %p - SKB = %p\n", pv_data->size, pv_data->buff, pv_data->skb);
 	else
 		PRINT_D(TX_DBG, "Couldn't send packet - Size = %d - Address = %p - SKB = %p\n", pv_data->size, pv_data->buff, pv_data->skb);
-	/* Free the SK Buffer, its work is done */
 	dev_kfree_skb(pv_data->skb);
 	kfree(pv_data);
 }
@@ -1368,7 +1238,6 @@ int mac_xmit(struct sk_buff *skb, struct net_device *ndev)
 
 	PRINT_D(TX_DBG, "Sending packet just received from TCP/IP\n");
 
-	/* Stop the network interface queue */
 	if (skb->dev != ndev) {
 		PRINT_ER("Packet not destined to this device\n");
 		return 0;
@@ -1390,7 +1259,6 @@ int mac_xmit(struct sk_buff *skb, struct net_device *ndev)
 	if (eth_h->h_proto == 0x8e88)
 		PRINT_D(INIT_DBG, "EAPOL transmitted\n");
 
-	/*get source and dest ip addresses*/
 	ih = (struct iphdr *)(skb->data + sizeof(struct ethhdr));
 
 	pu8UdpBuffer = (char *)ih + sizeof(struct iphdr);
@@ -1398,12 +1266,6 @@ int mac_xmit(struct sk_buff *skb, struct net_device *ndev)
 		PRINT_D(GENERIC_DBG, "DHCP Message transmitted, type:%x %x %x\n", pu8UdpBuffer[248], pu8UdpBuffer[249], pu8UdpBuffer[250]);
 
 	PRINT_D(TX_DBG, "Sending packet - Size = %d - Address = %p - SKB = %p\n", tx_data->size, tx_data->buff, tx_data->skb);
-
-	/* Send packet to MAC HW - for now the tx_complete function will be just status
-	 * indicator. still not sure if I need to suspend host transmission till the tx_complete
-	 * function called or not?
-	 * allocated buffer will be freed in tx_complete function.
-	 */
 	PRINT_D(TX_DBG, "Adding tx packet to TX Queue\n");
 	nic->netstats.tx_packets++;
 	nic->netstats.tx_bytes += tx_data->size;
@@ -1465,7 +1327,6 @@ int mac_close(struct net_device *ndev)
 	}
 
 	if (nic->wilc_netdev) {
-		/* Stop the network interface queue */
 		netif_stop_queue(nic->wilc_netdev);
 
 		wilc_deinit_host_int(nic->wilc_netdev);
@@ -1494,7 +1355,6 @@ int mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 	s32 s32Error = 0;
 	struct wilc *wilc;
 
-	/* struct iwreq *wrq = (struct iwreq *) req;	// tony moved to case SIOCSIWPRIV */
 	nic = netdev_priv(ndev);
 	wilc = nic->wilc;
 
@@ -1502,10 +1362,9 @@ int mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 		return 0;
 
 	switch (cmd) {
-	/* ]] 2013-06-24 */
 	case SIOCSIWPRIV:
 	{
-		struct iwreq *wrq = (struct iwreq *) req;               /* added by tony */
+		struct iwreq *wrq = (struct iwreq *) req;
 
 		size = wrq->u.data.length;
 
@@ -1521,7 +1380,6 @@ int mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 					PRINT_ER("Failed to send get rssi param's message queue ");
 				PRINT_INFO(GENERIC_DBG, "RSSI :%d\n", rssi);
 
-				/*Rounding up the rssi negative value*/
 				rssi += 5;
 
 				snprintf(buff, size, "rssi %d", rssi);
@@ -1571,7 +1429,6 @@ void frmw_to_linux(struct wilc *wilc, u8 *buff, u32 size, u32 pkt_offset)
 		frame_len = size;
 		buff_to_send = buff;
 
-		/* Need to send the packet up to the host, allocate a skb buffer */
 		skb = dev_alloc_skb(frame_len);
 		if (!skb) {
 			PRINT_ER("Low memory - packet droped\n");
@@ -1585,23 +1442,9 @@ void frmw_to_linux(struct wilc *wilc, u8 *buff, u32 size, u32 pkt_offset)
 		if (!skb->dev)
 			PRINT_ER("skb->dev is NULL\n");
 
-		/*
-		 * for(i=0;i<40;i++)
-		 * {
-		 *      if(i<frame_len)
-		 *              WILC_PRINTF("buff_to_send[%d]=%2x\n",i,buff_to_send[i]);
-		 *
-		 * }*/
-
-		/* skb_put(skb, frame_len); */
 		memcpy(skb_put(skb, frame_len), buff_to_send, frame_len);
 
-		/* WILC_PRINTF("After MEM_CPY\n"); */
-
-		/* nic = netdev_priv(wilc_netdev); */
-
 		skb->protocol = eth_type_trans(skb, wilc_netdev);
-		/* Send the packet to the stack by giving it to the bridge */
 		nic->netstats.rx_packets++;
 		nic->netstats.rx_bytes += frame_len;
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
@@ -1615,8 +1458,6 @@ void WILC_WFI_mgmt_rx(struct wilc *wilc, u8 *buff, u32 size)
 	int i = 0;
 	perInterface_wlan_t *nic;
 
-	/*Pass the frame on the monitor interface, if any.*/
-	/*Otherwise, pass it on p2p0 netdev, if registered on it*/
 	for (i = 0; i < wilc->vif_num; i++) {
 		nic = netdev_priv(wilc->vif[i].ndev);
 		if (nic->monitor_flag) {
@@ -1625,7 +1466,7 @@ void WILC_WFI_mgmt_rx(struct wilc *wilc, u8 *buff, u32 size)
 		}
 	}
 
-	nic = netdev_priv(wilc->vif[1].ndev); /* p2p0 */
+	nic = netdev_priv(wilc->vif[1].ndev);
 	if ((buff[0] == nic->g_struct_frame_reg[0].frame_type && nic->g_struct_frame_reg[0].reg) ||
 	    (buff[0] == nic->g_struct_frame_reg[1].frame_type && nic->g_struct_frame_reg[1].reg))
 		WILC_WFI_p2p_rx(wilc->vif[1].ndev, buff, size);
@@ -1681,7 +1522,6 @@ int wilc_netdev_init(struct wilc **wilc)
 
 	sema_init(&close_exit_sync, 0);
 
-	/*create the common structure*/
 	wl = kzalloc(sizeof(*wl), GFP_KERNEL);
 	if (!wl)
 		return -ENOMEM;
@@ -1691,7 +1531,6 @@ int wilc_netdev_init(struct wilc **wilc)
 	register_inetaddr_notifier(&g_dev_notifier);
 
 	for (i = 0; i < NUM_CONCURRENT_IFC; i++) {
-		/*allocate first ethernet device with perinterface_wlan_t as its private data*/
 		ndev = alloc_etherdev(sizeof(perInterface_wlan_t));
 		if (!ndev) {
 			PRINT_ER("Failed to allocate ethernet dev\n");
@@ -1701,13 +1540,12 @@ int wilc_netdev_init(struct wilc **wilc)
 		nic = netdev_priv(ndev);
 		memset(nic, 0, sizeof(perInterface_wlan_t));
 
-		/*Name the Devices*/
 		if (i == 0) {
-		#if defined(NM73131)    /* tony, 2012-09-20 */
+		#if defined(NM73131)
 			strcpy(ndev->name, "wilc_eth%d");
-		#elif defined(PLAT_CLM9722)                     /* rachel */
+		#elif defined(PLAT_CLM9722)
 			strcpy(ndev->name, "eth%d");
-		#else /* PANDA_BOARD, PLAT_ALLWINNER_A10, PLAT_ALLWINNER_A20, PLAT_ALLWINNER_A31, PLAT_AML8726_M3 or PLAT_WMS8304 */
+		#else
 			strcpy(ndev->name, "wlan%d");
 		#endif
 		} else
@@ -1722,11 +1560,9 @@ int wilc_netdev_init(struct wilc **wilc)
 
 		{
 			struct wireless_dev *wdev;
-			/*Register WiFi*/
 			wdev = wilc_create_wiphy(ndev);
 
 			#ifdef WILC_SDIO
-			/* set netdev, tony */
 			SET_NETDEV_DEV(ndev, &local_sdio_func->dev);
 			#endif
 
@@ -1735,7 +1571,6 @@ int wilc_netdev_init(struct wilc **wilc)
 				return -1;
 			}
 
-			/*linking the wireless_dev structure with the netdevice*/
 			nic->wilc_netdev->ieee80211_ptr = wdev;
 			nic->wilc_netdev->ml_priv = nic;
 			wdev->netdev = nic->wilc_netdev;
@@ -1747,7 +1582,7 @@ int wilc_netdev_init(struct wilc **wilc)
 
 		if (register_netdev(ndev)) {
 			PRINT_ER("Device couldn't be registered - %s\n", ndev->name);
-			return -1; /* ERROR */
+			return -1;
 		}
 
 		nic->iftype = STATION_MODE;
@@ -1757,7 +1592,7 @@ int wilc_netdev_init(struct wilc **wilc)
 	#ifndef WILC_SDIO
 	if (!linux_spi_init(&wl->wilc_spidev)) {
 		PRINT_ER("Can't initialize SPI\n");
-		return -1; /* ERROR */
+		return -1;
 	}
 	wl->wilc_spidev = wilc_spi_dev;
 	#else
@@ -1767,7 +1602,6 @@ int wilc_netdev_init(struct wilc **wilc)
 	return 0;
 }
 
-/*The 1st function called after module inserted*/
 static int __init init_wilc_driver(void)
 {
 #ifdef WILC_SPI
-- 
1.9.1

