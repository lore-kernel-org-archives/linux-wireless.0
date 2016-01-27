Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:14365 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335AbcA0C57 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 21:57:59 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 09/13] staging: wilc1000: removes unnecessary debug logs
Date: Wed, 27 Jan 2016 11:50:33 +0900
Message-ID: <1453863037-31073-9-git-send-email-glen.lee@atmel.com> (sfid-20160127_035803_261805_5FAB75E5)
In-Reply-To: <1453863037-31073-1-git-send-email-glen.lee@atmel.com>
References: <1453863037-31073-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes unnecessary debug logs.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 154 ++++++----------------------------
 1 file changed, 24 insertions(+), 130 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index f03daff..e8b4533 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -70,47 +70,32 @@ static int dev_state_ev_handler(struct notifier_block *this,
 	u8 null_ip[4] = {0};
 	char wlan_dev_name[5] = "wlan0";
 
-	if (!dev_iface || !dev_iface->ifa_dev || !dev_iface->ifa_dev->dev) {
-		PRINT_D(GENERIC_DBG, "dev_iface = NULL\n");
+	if (!dev_iface || !dev_iface->ifa_dev || !dev_iface->ifa_dev->dev)
 		return NOTIFY_DONE;
-	}
 
 	if (memcmp(dev_iface->ifa_label, "wlan0", 5) &&
-	    memcmp(dev_iface->ifa_label, "p2p0", 4)) {
-		PRINT_D(GENERIC_DBG, "Interface is neither WLAN0 nor P2P0\n");
+	    memcmp(dev_iface->ifa_label, "p2p0", 4))
 		return NOTIFY_DONE;
-	}
 
 	dev  = (struct net_device *)dev_iface->ifa_dev->dev;
-	if (!dev->ieee80211_ptr || !dev->ieee80211_ptr->wiphy) {
-		PRINT_D(GENERIC_DBG, "No Wireless registerd\n");
+	if (!dev->ieee80211_ptr || !dev->ieee80211_ptr->wiphy)
 		return NOTIFY_DONE;
-	}
+
 	priv = wiphy_priv(dev->ieee80211_ptr->wiphy);
-	if (!priv) {
-		PRINT_D(GENERIC_DBG, "No Wireless Priv\n");
+	if (!priv)
 		return NOTIFY_DONE;
-	}
+
 	hif_drv = (struct host_if_drv *)priv->hif_drv;
 	vif = netdev_priv(dev);
-	if (!vif || !hif_drv) {
-		PRINT_D(GENERIC_DBG, "No Wireless Priv\n");
+	if (!vif || !hif_drv)
 		return NOTIFY_DONE;
-	}
-
-	PRINT_INFO(GENERIC_DBG, "dev_state_ev_handler +++\n");
 
 	switch (event) {
 	case NETDEV_UP:
-		PRINT_D(GENERIC_DBG, "dev_state_ev_handler event=NETDEV_UP %p\n", dev);
-
-		PRINT_INFO(GENERIC_DBG, "\n ============== IP Address Obtained ===============\n\n");
-
 		if (vif->iftype == STATION_MODE || vif->iftype == CLIENT_MODE) {
 			hif_drv->IFC_UP = 1;
 			wilc_optaining_ip = false;
 			del_timer(&wilc_during_ip_timer);
-			PRINT_D(GENERIC_DBG, "IP obtained , enable scan\n");
 		}
 
 		if (wilc_enable_ps)
@@ -127,9 +112,6 @@ static int dev_state_ev_handler(struct notifier_block *this,
 		break;
 
 	case NETDEV_DOWN:
-		PRINT_D(GENERIC_DBG, "dev_state_ev_handler event=NETDEV_DOWN %p\n", dev);
-
-		PRINT_INFO(GENERIC_DBG, "\n ============== IP Address Released ===============\n\n");
 		if (vif->iftype == STATION_MODE || vif->iftype == CLIENT_MODE) {
 			hif_drv->IFC_UP = 0;
 			wilc_optaining_ip = false;
@@ -152,9 +134,6 @@ static int dev_state_ev_handler(struct notifier_block *this,
 		break;
 
 	default:
-		PRINT_INFO(GENERIC_DBG, "dev_state_ev_handler event=default\n");
-		PRINT_INFO(GENERIC_DBG, "[%s] unknown dev event: %lu\n", dev_iface->ifa_label, event);
-
 		break;
 	}
 
@@ -169,7 +148,6 @@ static irqreturn_t isr_uh_routine(int irq, void *user_data)
 
 	vif = netdev_priv(dev);
 	wilc = vif->wilc;
-	PRINT_D(INT_DBG, "Interrupt received UH\n");
 
 	if (wilc->close) {
 		PRINT_ER("Driver is CLOSING: Can't handle UH interrupt\n");
@@ -191,7 +169,6 @@ static irqreturn_t isr_bh_routine(int irq, void *userdata)
 		return IRQ_HANDLED;
 	}
 
-	PRINT_D(INT_DBG, "Interrupt received BH\n");
 	wilc_handle_isr(wilc);
 
 	return IRQ_HANDLED;
@@ -255,12 +232,9 @@ int wilc_lock_timeout(struct wilc *nic, void *vp, u32 timeout)
 	/* FIXME: replace with mutex_lock or wait_for_completion */
 	int error = -1;
 
-	PRINT_D(LOCK_DBG, "Locking %p\n", vp);
 	if (vp)
 		error = down_timeout((struct semaphore *)vp,
 				     msecs_to_jiffies(timeout));
-	else
-		PRINT_ER("Failed, mutex is NULL\n");
 	return error;
 }
 
@@ -358,28 +332,21 @@ static int linux_wlan_txq_task(void *vp)
 
 	up(&wl->txq_thread_started);
 	while (1) {
-		PRINT_D(TX_DBG, "txq_task Taking a nap :)\n");
 		down(&wl->txq_event);
-		PRINT_D(TX_DBG, "txq_task Who waked me up :$\n");
 
 		if (wl->close) {
 			up(&wl->txq_thread_started);
 
 			while (!kthread_should_stop())
 				schedule();
-
-			PRINT_D(TX_DBG, "TX thread stopped\n");
 			break;
 		}
-		PRINT_D(TX_DBG, "txq_task handle the sending packet and let me go to sleep.\n");
 #if !defined USE_TX_BACKOFF_DELAY_IF_NO_BUFFERS
 		ret = wilc_wlan_handle_txq(dev, &txq_count);
 #else
 		do {
 			ret = wilc_wlan_handle_txq(dev, &txq_count);
 			if (txq_count < FLOW_CONTROL_LOWER_THRESHOLD) {
-				PRINT_D(TX_DBG, "Waking up queue\n");
-
 				if (netif_queue_stopped(wl->vif[0]->ndev))
 					netif_wake_queue(wl->vif[0]->ndev);
 				if (netif_queue_stopped(wl->vif[1]->ndev))
@@ -428,15 +395,11 @@ int wilc_wlan_get_firmware(struct net_device *dev)
 
 	netdev_info(dev, "loading firmware %s\n", firmware);
 
-	if (!vif) {
-		PRINT_ER("vif is NULL\n");
+	if (!vif)
 		goto _fail_;
-	}
 
-	if (!(&vif->ndev->dev)) {
-		PRINT_ER("&vif->ndev->dev  is NULL\n");
+	if (!(&vif->ndev->dev))
 		goto _fail_;
-	}
 
 	if (request_firmware(&wilc_firmware, firmware, wilc->dev) != 0) {
 		PRINT_ER("%s - firmare not available\n", firmware);
@@ -459,20 +422,13 @@ static int linux_wlan_start_firmware(struct net_device *dev)
 	vif = netdev_priv(dev);
 	wilc = vif->wilc;
 
-	PRINT_D(INIT_DBG, "Starting Firmware ...\n");
 	ret = wilc_wlan_start(wilc);
-	if (ret < 0) {
-		PRINT_ER("Failed to start Firmware\n");
+	if (ret < 0)
 		return ret;
-	}
 
-	PRINT_D(INIT_DBG, "Waiting for Firmware to get ready ...\n");
 	ret = wilc_lock_timeout(wilc, &wilc->sync_event, 5000);
-	if (ret) {
-		PRINT_D(INIT_DBG, "Firmware start timed out");
+	if (ret)
 		return ret;
-	}
-	PRINT_D(INIT_DBG, "Firmware successfully started\n");
 
 	return 0;
 }
@@ -490,14 +446,12 @@ static int wilc1000_firmware_download(struct net_device *dev)
 		PRINT_ER("Firmware buffer is NULL\n");
 		return -ENOBUFS;
 	}
-	PRINT_D(INIT_DBG, "Downloading Firmware ...\n");
+
 	ret = wilc_wlan_firmware_download(wilc, wilc->firmware->data,
 					  wilc->firmware->size);
 	if (ret < 0)
 		return ret;
 
-	PRINT_D(INIT_DBG, "Freeing FW buffer ...\n");
-	PRINT_D(INIT_DBG, "Releasing firmware\n");
 	release_firmware(wilc->firmware);
 	wilc->firmware = NULL;
 
@@ -740,7 +694,6 @@ void wilc1000_wlan_deinit(struct net_device *dev)
 	if (wl->initialized)	{
 		netdev_info(dev, "Deinitializing wilc1000...\n");
 
-		PRINT_D(INIT_DBG, "Disabling IRQ\n");
 		if (!wl->dev_irq_num &&
 		    wl->hif_func->disable_interrupt) {
 			mutex_lock(&wl->hif_cs);
@@ -750,29 +703,19 @@ void wilc1000_wlan_deinit(struct net_device *dev)
 		if (&wl->txq_event)
 			up(&wl->txq_event);
 
-		PRINT_D(INIT_DBG, "Deinitializing Threads\n");
 		wlan_deinitialize_threads(dev);
-
-		PRINT_D(INIT_DBG, "Deinitializing IRQ\n");
 		deinit_irq(dev);
 
 		wilc_wlan_stop(wl);
-
-		PRINT_D(INIT_DBG, "Deinitializing WILC Wlan\n");
 		wilc_wlan_cleanup(dev);
 #if defined(PLAT_ALLWINNER_A20) || defined(PLAT_ALLWINNER_A23) || defined(PLAT_ALLWINNER_A31)
 		if (!wl->dev_irq_num &&
 		    wl->hif_func->disable_interrupt) {
-
-			PRINT_D(INIT_DBG, "Disabling IRQ 2\n");
-
 			mutex_lock(&wl->hif_cs);
 			wl->hif_func->disable_interrupt(wl);
 			mutex_unlock(&wl->hif_cs);
 		}
 #endif
-
-		PRINT_D(INIT_DBG, "Deinitializing Locks\n");
 		wlan_deinit_locks(dev);
 
 		wl->initialized = false;
@@ -792,8 +735,6 @@ static int wlan_init_locks(struct net_device *dev)
 	vif = netdev_priv(dev);
 	wl = vif->wilc;
 
-	PRINT_D(INIT_DBG, "Initializing Locks ...\n");
-
 	mutex_init(&wl->hif_cs);
 	mutex_init(&wl->rxq_cs);
 
@@ -818,8 +759,6 @@ static int wlan_deinit_locks(struct net_device *dev)
 	vif = netdev_priv(dev);
 	wilc = vif->wilc;
 
-	PRINT_D(INIT_DBG, "De-Initializing Locks\n");
-
 	if (&wilc->hif_cs)
 		mutex_destroy(&wilc->hif_cs);
 
@@ -837,8 +776,6 @@ static int wlan_initialize_threads(struct net_device *dev)
 	vif = netdev_priv(dev);
 	wilc = vif->wilc;
 
-	PRINT_D(INIT_DBG, "Initializing Threads ...\n");
-	PRINT_D(INIT_DBG, "Creating kthread for transmission\n");
 	wilc->txq_thread = kthread_run(linux_wlan_txq_task, (void *)dev,
 				     "K_TXQ_TASK");
 	if (!wilc->txq_thread) {
@@ -860,7 +797,6 @@ static void wlan_deinitialize_threads(struct net_device *dev)
 	wl = vif->wilc;
 
 	wl->close = 1;
-	PRINT_D(INIT_DBG, "Deinitializing Threads\n");
 
 	if (&wl->txq_event)
 		up(&wl->txq_event);
@@ -884,20 +820,17 @@ int wilc1000_wlan_init(struct net_device *dev, struct wilc_vif *vif)
 
 		ret = wilc_wlan_init(dev);
 		if (ret < 0) {
-			PRINT_ER("Initializing WILC_Wlan FAILED\n");
 			ret = -EIO;
 			goto _fail_locks_;
 		}
 
 		if (wl->gpio >= 0 && init_irq(dev)) {
-			PRINT_ER("couldn't initialize IRQ\n");
 			ret = -EIO;
 			goto _fail_locks_;
 		}
 
 		ret = wlan_initialize_threads(dev);
 		if (ret < 0) {
-			PRINT_ER("Initializing Threads FAILED\n");
 			ret = -EIO;
 			goto _fail_wilc_wlan_;
 		}
@@ -905,27 +838,23 @@ int wilc1000_wlan_init(struct net_device *dev, struct wilc_vif *vif)
 		if (!wl->dev_irq_num &&
 		    wl->hif_func->enable_interrupt &&
 		    wl->hif_func->enable_interrupt(wl)) {
-			PRINT_ER("couldn't initialize IRQ\n");
 			ret = -EIO;
 			goto _fail_irq_init_;
 		}
 
 		if (wilc_wlan_get_firmware(dev)) {
-			PRINT_ER("Can't get firmware\n");
 			ret = -EIO;
 			goto _fail_irq_enable_;
 		}
 
 		ret = wilc1000_firmware_download(dev);
 		if (ret < 0) {
-			PRINT_ER("Failed to download firmware\n");
 			ret = -EIO;
 			goto _fail_irq_enable_;
 		}
 
 		ret = linux_wlan_start_firmware(dev);
 		if (ret < 0) {
-			PRINT_ER("Failed to start firmware\n");
 			ret = -EIO;
 			goto _fail_irq_enable_;
 		}
@@ -1008,16 +937,11 @@ int wilc_mac_open(struct net_device *ndev)
 	PRINT_D(INIT_DBG, "MAC OPEN[%p]\n", ndev);
 
 	ret = wilc_init_host_int(ndev);
-	if (ret < 0) {
-		PRINT_ER("Failed to initialize host interface\n");
-
+	if (ret < 0)
 		return ret;
-	}
 
-	PRINT_D(INIT_DBG, "*** re-init ***\n");
 	ret = wilc1000_wlan_init(ndev, vif);
 	if (ret < 0) {
-		PRINT_ER("Failed to initialize wilc1000\n");
 		wilc_deinit_host_int(ndev);
 		return ret;
 	}
@@ -1098,23 +1022,16 @@ static void wilc_set_multicast_list(struct net_device *dev)
 	if (!dev)
 		return;
 
-	PRINT_D(INIT_DBG, "Setting Multicast List with count = %d.\n",
-		dev->mc.count);
-
-	if (dev->flags & IFF_PROMISC) {
-		PRINT_D(INIT_DBG, "Set promiscuous mode ON, retrive all packets\n");
+	if (dev->flags & IFF_PROMISC)
 		return;
-	}
 
 	if ((dev->flags & IFF_ALLMULTI) ||
 	    (dev->mc.count) > WILC_MULTICAST_TABLE_SIZE) {
-		PRINT_D(INIT_DBG, "Disable multicast filter, retrive all multicast packets\n");
 		wilc_setup_multicast_filter(vif, false, 0);
 		return;
 	}
 
 	if ((dev->mc.count) == 0) {
-		PRINT_D(INIT_DBG, "Enable multicast filter, retrive directed packets only.\n");
 		wilc_setup_multicast_filter(vif, true, 0);
 		return;
 	}
@@ -1161,8 +1078,6 @@ int wilc_mac_xmit(struct sk_buff *skb, struct net_device *ndev)
 	vif = netdev_priv(ndev);
 	wilc = vif->wilc;
 
-	PRINT_D(TX_DBG, "Sending packet just received from TCP/IP\n");
-
 	if (skb->dev != ndev) {
 		PRINT_ER("Packet not destined to this device\n");
 		return 0;
@@ -1170,7 +1085,6 @@ int wilc_mac_xmit(struct sk_buff *skb, struct net_device *ndev)
 
 	tx_data = kmalloc(sizeof(*tx_data), GFP_ATOMIC);
 	if (!tx_data) {
-		PRINT_ER("Failed to allocate memory for tx_data structure\n");
 		dev_kfree_skb(skb);
 		netif_wake_queue(ndev);
 		return 0;
@@ -1192,8 +1106,6 @@ int wilc_mac_xmit(struct sk_buff *skb, struct net_device *ndev)
 		PRINT_D(GENERIC_DBG, "DHCP Message transmitted, type:%x %x %x\n",
 			udp_buf[248], udp_buf[249], udp_buf[250]);
 
-	PRINT_D(TX_DBG, "Sending packet - Size = %d - Address = %p - SKB = %p\n", tx_data->size, tx_data->buff, tx_data->skb);
-	PRINT_D(TX_DBG, "Adding tx packet to TX Queue\n");
 	vif->netstats.tx_packets++;
 	vif->netstats.tx_bytes += tx_data->size;
 	tx_data->bssid = wilc->vif[vif->u8IfIdx]->bssid;
@@ -1219,39 +1131,29 @@ int wilc_mac_close(struct net_device *ndev)
 	vif = netdev_priv(ndev);
 
 	if (!vif || !vif->ndev || !vif->ndev->ieee80211_ptr ||
-	    !vif->ndev->ieee80211_ptr->wiphy) {
-		PRINT_ER("vif = NULL\n");
+	    !vif->ndev->ieee80211_ptr->wiphy)
 		return 0;
-	}
 
 	priv = wiphy_priv(vif->ndev->ieee80211_ptr->wiphy);
 	wl = vif->wilc;
 
-	if (!priv) {
-		PRINT_ER("priv = NULL\n");
+	if (!priv)
 		return 0;
-	}
 
 	hif_drv = (struct host_if_drv *)priv->hif_drv;
 
 	PRINT_D(GENERIC_DBG, "Mac close\n");
 
-	if (!wl) {
-		PRINT_ER("wl = NULL\n");
+	if (!wl)
 		return 0;
-	}
 
-	if (!hif_drv) {
-		PRINT_ER("hif_drv = NULL\n");
+	if (!hif_drv)
 		return 0;
-	}
 
-	if ((wl->open_ifcs) > 0) {
+	if ((wl->open_ifcs) > 0)
 		wl->open_ifcs--;
-	} else {
-		PRINT_ER("ERROR: MAC close called while number of opened interfaces is zero\n");
+	else
 		return 0;
-	}
 
 	if (vif->ndev) {
 		netif_stop_queue(vif->ndev);
@@ -1304,8 +1206,6 @@ static int mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 			if (strncasecmp(buff, "RSSI", length) == 0) {
 				priv = wiphy_priv(vif->ndev->ieee80211_ptr->wiphy);
 				ret = wilc_get_rssi(vif, &rssi);
-				if (ret)
-					PRINT_ER("Failed to send get rssi param's message queue ");
 				PRINT_INFO(GENERIC_DBG, "RSSI :%d\n", rssi);
 
 				rssi += 5;
@@ -1361,10 +1261,9 @@ void wilc_frmw_to_linux(struct wilc *wilc, u8 *buff, u32 size, u32 pkt_offset)
 		buff_to_send = buff;
 
 		skb = dev_alloc_skb(frame_len);
-		if (!skb) {
-			PRINT_ER("Low memory - packet droped\n");
+		if (!skb)
 			return;
-		}
+
 		skb->dev = wilc_netdev;
 
 		memcpy(skb_put(skb, frame_len), buff_to_send, frame_len);
@@ -1454,10 +1353,8 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 
 	for (i = 0; i < NUM_CONCURRENT_IFC; i++) {
 		ndev = alloc_etherdev(sizeof(struct wilc_vif));
-		if (!ndev) {
-			PRINT_ER("Failed to allocate ethernet dev\n");
+		if (!ndev)
 			return -1;
-		}
 
 		vif = netdev_priv(ndev);
 		memset(vif, 0, sizeof(struct wilc_vif));
@@ -1496,11 +1393,8 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 			vif->netstats.tx_bytes = 0;
 		}
 
-		if (register_netdev(ndev)) {
-			PRINT_ER("Device couldn't be registered - %s\n",
-				 ndev->name);
+		if (register_netdev(ndev))
 			return -1;
-		}
 
 		vif->iftype = STATION_MODE;
 		vif->mac_opened = 0;
-- 
1.9.1

