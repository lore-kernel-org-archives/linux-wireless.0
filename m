Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:10279 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475AbbK0GrQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Nov 2015 01:47:16 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 1/3] staging: wilc1000: move perInterface_wlan_t to wilc_vif
Date: Fri, 27 Nov 2015 15:50:31 +0900
Message-ID: <1448607033-25354-2-git-send-email-glen.lee@atmel.com> (sfid-20151127_074721_730084_8FE20882)
In-Reply-To: <1448607033-25354-1-git-send-email-glen.lee@atmel.com>
References: <1448607033-25354-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

perInterface_wlan_t and wilc_vif are all about interface control informations.
We will combine those two structures and maintain as one network interface
control information.
Move all the members of perInterface_wlan_t to wilc_vif and remove the
structure. Rename perInterace_wlan_t to wilc_vif and rename variable name nic
to vif which is proper name for it.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c         |   6 +-
 drivers/staging/wilc1000/linux_wlan.c             | 251 +++++++++++-----------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 148 ++++++-------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  21 +-
 drivers/staging/wilc1000/wilc_wlan.c              |  60 +++---
 5 files changed, 241 insertions(+), 245 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 3b986cb..f7e560e 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3772,11 +3772,11 @@ s32 wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 	s32 result = 0;
 	struct host_if_drv *hif_drv;
 	int err;
-	perInterface_wlan_t *nic;
+	struct wilc_vif *vif;
 	struct wilc *wilc;
 
-	nic = netdev_priv(dev);
-	wilc = nic->wilc;
+	vif = netdev_priv(dev);
+	wilc = vif->wilc;
 
 	PRINT_D(HOSTINF_DBG, "Initializing host interface for client %d\n", clients_count + 1);
 
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 92ca072..263d9d8 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -64,7 +64,7 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 	struct host_if_drv *hif_drv;
 	struct net_device *dev;
 	u8 *ip_addr_buf;
-	perInterface_wlan_t *nic;
+	struct wilc_vif *vif;
 	u8 null_ip[4] = {0};
 	char wlan_dev_name[5] = "wlan0";
 
@@ -90,8 +90,8 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 		return NOTIFY_DONE;
 	}
 	hif_drv = (struct host_if_drv *)priv->hWILCWFIDrv;
-	nic = netdev_priv(dev);
-	if (!nic || !hif_drv) {
+	vif = netdev_priv(dev);
+	if (!vif || !hif_drv) {
 		PRINT_D(GENERIC_DBG, "No Wireless Priv\n");
 		return NOTIFY_DONE;
 	}
@@ -104,7 +104,7 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 
 		PRINT_INFO(GENERIC_DBG, "\n ============== IP Address Obtained ===============\n\n");
 
-		if (nic->iftype == STATION_MODE || nic->iftype == CLIENT_MODE) {
+		if (vif->iftype == STATION_MODE || vif->iftype == CLIENT_MODE) {
 			hif_drv->IFC_UP = 1;
 			wilc_optaining_ip = false;
 			del_timer(&wilc_during_ip_timer);
@@ -120,7 +120,7 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 		PRINT_D(GENERIC_DBG, "IP add=%d:%d:%d:%d\n",
 			ip_addr_buf[0], ip_addr_buf[1],
 			ip_addr_buf[2], ip_addr_buf[3]);
-		wilc_setup_ipaddress(hif_drv, ip_addr_buf, nic->u8IfIdx);
+		wilc_setup_ipaddress(hif_drv, ip_addr_buf, vif->u8IfIdx);
 
 		break;
 
@@ -128,7 +128,7 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 		PRINT_D(GENERIC_DBG, "dev_state_ev_handler event=NETDEV_DOWN %p\n", dev);
 
 		PRINT_INFO(GENERIC_DBG, "\n ============== IP Address Released ===============\n\n");
-		if (nic->iftype == STATION_MODE || nic->iftype == CLIENT_MODE) {
+		if (vif->iftype == STATION_MODE || vif->iftype == CLIENT_MODE) {
 			hif_drv->IFC_UP = 0;
 			wilc_optaining_ip = false;
 		}
@@ -145,7 +145,7 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 			ip_addr_buf[0], ip_addr_buf[1],
 			ip_addr_buf[2], ip_addr_buf[3]);
 
-		wilc_setup_ipaddress(hif_drv, ip_addr_buf, nic->u8IfIdx);
+		wilc_setup_ipaddress(hif_drv, ip_addr_buf, vif->u8IfIdx);
 
 		break;
 
@@ -161,12 +161,12 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 
 static irqreturn_t isr_uh_routine(int irq, void *user_data)
 {
-	perInterface_wlan_t *nic;
+	struct wilc_vif *vif;
 	struct wilc *wilc;
 	struct net_device *dev = (struct net_device *)user_data;
 
-	nic = netdev_priv(dev);
-	wilc = nic->wilc;
+	vif = netdev_priv(dev);
+	wilc = vif->wilc;
 	PRINT_D(INT_DBG, "Interrupt received UH\n");
 
 	if (wilc->close) {
@@ -178,11 +178,11 @@ static irqreturn_t isr_uh_routine(int irq, void *user_data)
 
 static irqreturn_t isr_bh_routine(int irq, void *userdata)
 {
-	perInterface_wlan_t *nic;
+	struct wilc_vif *vif;
 	struct wilc *wilc;
 
-	nic = netdev_priv(userdata);
-	wilc = nic->wilc;
+	vif = netdev_priv(userdata);
+	wilc = vif->wilc;
 
 	if (wilc->close) {
 		PRINT_ER("Driver is CLOSING: Can't handle BH interrupt\n");
@@ -198,11 +198,11 @@ static irqreturn_t isr_bh_routine(int irq, void *userdata)
 static int init_irq(struct net_device *dev)
 {
 	int ret = 0;
-	perInterface_wlan_t *nic;
+	struct wilc_vif *vif;
 	struct wilc *wl;
 
-	nic = netdev_priv(dev);
-	wl = nic->wilc;
+	vif = netdev_priv(dev);
+	wl = vif->wilc;
 
 	if ((gpio_request(wl->gpio, "WILC_INTR") == 0) &&
 	    (gpio_direction_input(wl->gpio) == 0)) {
@@ -230,11 +230,11 @@ static int init_irq(struct net_device *dev)
 
 static void deinit_irq(struct net_device *dev)
 {
-	perInterface_wlan_t *nic;
+	struct wilc_vif *vif;
 	struct wilc *wilc;
 
-	nic = netdev_priv(dev);
-	wilc = nic->wilc;
+	vif = netdev_priv(dev);
+	wilc = vif->wilc;
 
 	/* Deintialize IRQ */
 	if (wilc->dev_irq_num) {
@@ -311,11 +311,11 @@ int wilc_wlan_set_bssid(struct net_device *wilc_netdev, u8 *bssid)
 {
 	int i = 0;
 	int ret = -1;
-	perInterface_wlan_t *nic;
+	struct wilc_vif *vif;
 	struct wilc *wilc;
 
-	nic = netdev_priv(wilc_netdev);
-	wilc = nic->wilc;
+	vif = netdev_priv(wilc_netdev);
+	wilc = vif->wilc;
 
 	for (i = 0; i < wilc->vif_num; i++)
 		if (wilc->vif[i].ndev == wilc_netdev) {
@@ -345,7 +345,7 @@ int wilc_wlan_get_num_conn_ifcs(struct wilc *wilc)
 static int linux_wlan_txq_task(void *vp)
 {
 	int ret, txq_count;
-	perInterface_wlan_t *nic;
+	struct wilc_vif *vif;
 	struct wilc *wl;
 	struct net_device *dev = vp;
 #if defined USE_TX_BACKOFF_DELAY_IF_NO_BUFFERS
@@ -357,8 +357,8 @@ static int linux_wlan_txq_task(void *vp)
 	int backoff_weight = TX_BACKOFF_WEIGHT_MIN;
 #endif
 
-	nic = netdev_priv(dev);
-	wl = nic->wilc;
+	vif = netdev_priv(dev);
+	wl = vif->wilc;
 
 	up(&wl->txq_thread_started);
 	while (1) {
@@ -417,31 +417,31 @@ void wilc_rx_complete(struct wilc *nic)
 
 int wilc_wlan_get_firmware(struct net_device *dev)
 {
-	perInterface_wlan_t *nic;
+	struct wilc_vif *vif;
 	struct wilc *wilc;
 	int ret = 0;
 	const struct firmware *wilc_firmware;
 	char *firmware;
 
-	nic = netdev_priv(dev);
-	wilc = nic->wilc;
+	vif = netdev_priv(dev);
+	wilc = vif->wilc;
 
-	if (nic->iftype == AP_MODE) {
+	if (vif->iftype == AP_MODE) {
 		firmware = AP_FIRMWARE;
-	} else if (nic->iftype == STATION_MODE) {
+	} else if (vif->iftype == STATION_MODE) {
 		firmware = STA_FIRMWARE;
 	} else {
 		PRINT_D(INIT_DBG, "Get P2P_CONCURRENCY_FIRMWARE\n");
 		firmware = P2P_CONCURRENCY_FIRMWARE;
 	}
 
-	if (!nic) {
-		PRINT_ER("NIC is NULL\n");
+	if (!vif) {
+		PRINT_ER("vif is NULL\n");
 		goto _fail_;
 	}
 
-	if (!(&nic->wilc_netdev->dev)) {
-		PRINT_ER("&nic->wilc_netdev->dev  is NULL\n");
+	if (!(&vif->wilc_netdev->dev)) {
+		PRINT_ER("&vif->wilc_netdev->dev  is NULL\n");
 		goto _fail_;
 	}
 
@@ -459,12 +459,12 @@ _fail_:
 
 static int linux_wlan_start_firmware(struct net_device *dev)
 {
-	perInterface_wlan_t *nic;
+	struct wilc_vif *vif;
 	struct wilc *wilc;
 	int ret = 0;
 
-	nic = netdev_priv(dev);
-	wilc = nic->wilc;
+	vif = netdev_priv(dev);
+	wilc = vif->wilc;
 
 	PRINT_D(INIT_DBG, "Starting Firmware ...\n");
 	ret = wilc_wlan_start(wilc);
@@ -486,12 +486,12 @@ static int linux_wlan_start_firmware(struct net_device *dev)
 
 static int wilc1000_firmware_download(struct net_device *dev)
 {
-	perInterface_wlan_t *nic;
+	struct wilc_vif *vif;
 	struct wilc *wilc;
 	int ret = 0;
 
-	nic = netdev_priv(dev);
-	wilc = nic->wilc;
+	vif = netdev_priv(dev);
+	wilc = vif->wilc;
 
 	if (!wilc->firmware) {
 		PRINT_ER("Firmware buffer is NULL\n");
@@ -734,11 +734,11 @@ _fail_:
 
 void wilc1000_wlan_deinit(struct net_device *dev)
 {
-	perInterface_wlan_t *nic;
+	struct wilc_vif *vif;
 	struct wilc *wl;
 
-	nic = netdev_priv(dev);
-	wl = nic->wilc;
+	vif = netdev_priv(dev);
+	wl = vif->wilc;
 
 	if (!wl) {
 		netdev_err(dev, "wl is NULL\n");
@@ -794,11 +794,11 @@ void wilc1000_wlan_deinit(struct net_device *dev)
 
 static int wlan_init_locks(struct net_device *dev)
 {
-	perInterface_wlan_t *nic;
+	struct wilc_vif *vif;
 	struct wilc *wl;
 
-	nic = netdev_priv(dev);
-	wl = nic->wilc;
+	vif = netdev_priv(dev);
+	wl = vif->wilc;
 
 	PRINT_D(INIT_DBG, "Initializing Locks ...\n");
 
@@ -820,11 +820,11 @@ static int wlan_init_locks(struct net_device *dev)
 
 static int wlan_deinit_locks(struct net_device *dev)
 {
-	perInterface_wlan_t *nic;
+	struct wilc_vif *vif;
 	struct wilc *wilc;
 
-	nic = netdev_priv(dev);
-	wilc = nic->wilc;
+	vif = netdev_priv(dev);
+	wilc = vif->wilc;
 
 	PRINT_D(INIT_DBG, "De-Initializing Locks\n");
 
@@ -839,11 +839,11 @@ static int wlan_deinit_locks(struct net_device *dev)
 
 static int wlan_initialize_threads(struct net_device *dev)
 {
-	perInterface_wlan_t *nic;
+	struct wilc_vif *vif;
 	struct wilc *wilc;
 
-	nic = netdev_priv(dev);
-	wilc = nic->wilc;
+	vif = netdev_priv(dev);
+	wilc = vif->wilc;
 
 	PRINT_D(INIT_DBG, "Initializing Threads ...\n");
 	PRINT_D(INIT_DBG, "Creating kthread for transmission\n");
@@ -861,10 +861,10 @@ static int wlan_initialize_threads(struct net_device *dev)
 
 static void wlan_deinitialize_threads(struct net_device *dev)
 {
-	perInterface_wlan_t *nic;
+	struct wilc_vif *vif;
 	struct wilc *wl;
-	nic = netdev_priv(dev);
-	wl = nic->wilc;
+	vif = netdev_priv(dev);
+	wl = vif->wilc;
 
 	wl->close = 1;
 	PRINT_D(INIT_DBG, "Deinitializing Threads\n");
@@ -878,11 +878,10 @@ static void wlan_deinitialize_threads(struct net_device *dev)
 	}
 }
 
-int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
+int wilc1000_wlan_init(struct net_device *dev, struct wilc_vif *vif)
 {
-	perInterface_wlan_t *nic = p_nic;
 	int ret = 0;
-	struct wilc *wl = nic->wilc;
+	struct wilc *wl = vif->wilc;
 
 	if (!wl->initialized) {
 		wl->mac_status = WILC_MAC_STATUS_INIT;
@@ -992,7 +991,7 @@ static int mac_init_fn(struct net_device *ndev)
 
 int wilc_mac_open(struct net_device *ndev)
 {
-	perInterface_wlan_t *nic;
+	struct wilc_vif *vif;
 	struct wilc *wilc;
 
 	unsigned char mac_add[ETH_ALEN] = {0};
@@ -1001,17 +1000,17 @@ int wilc_mac_open(struct net_device *ndev)
 	struct wilc_priv *priv;
 	struct wilc *wl;
 
-	nic = netdev_priv(ndev);
-	wl = nic->wilc;
+	vif = netdev_priv(ndev);
+	wl = vif->wilc;
 
 	if (!wl|| !wl->dev) {
 		netdev_err(ndev, "wilc1000: SPI device not ready\n");
 		return -ENODEV;
 	}
 
-	nic = netdev_priv(ndev);
-	wilc = nic->wilc;
-	priv = wiphy_priv(nic->wilc_netdev->ieee80211_ptr->wiphy);
+	vif = netdev_priv(ndev);
+	wilc = vif->wilc;
+	priv = wiphy_priv(vif->wilc_netdev->ieee80211_ptr->wiphy);
 	PRINT_D(INIT_DBG, "MAC OPEN[%p]\n", ndev);
 
 	ret = wilc_init_host_int(ndev);
@@ -1022,7 +1021,7 @@ int wilc_mac_open(struct net_device *ndev)
 	}
 
 	PRINT_D(INIT_DBG, "*** re-init ***\n");
-	ret = wilc1000_wlan_init(ndev, nic);
+	ret = wilc1000_wlan_init(ndev, vif);
 	if (ret < 0) {
 		PRINT_ER("Failed to initialize wilc1000\n");
 		wilc_deinit_host_int(ndev);
@@ -1051,25 +1050,25 @@ int wilc_mac_open(struct net_device *ndev)
 		return -EINVAL;
 	}
 
-	wilc_mgmt_frame_register(nic->wilc_netdev->ieee80211_ptr->wiphy,
-				 nic->wilc_netdev->ieee80211_ptr,
-				 nic->g_struct_frame_reg[0].frame_type,
-				 nic->g_struct_frame_reg[0].reg);
-	wilc_mgmt_frame_register(nic->wilc_netdev->ieee80211_ptr->wiphy,
-				 nic->wilc_netdev->ieee80211_ptr,
-				 nic->g_struct_frame_reg[1].frame_type,
-				 nic->g_struct_frame_reg[1].reg);
+	wilc_mgmt_frame_register(vif->wilc_netdev->ieee80211_ptr->wiphy,
+				 vif->wilc_netdev->ieee80211_ptr,
+				 vif->g_struct_frame_reg[0].frame_type,
+				 vif->g_struct_frame_reg[0].reg);
+	wilc_mgmt_frame_register(vif->wilc_netdev->ieee80211_ptr->wiphy,
+				 vif->wilc_netdev->ieee80211_ptr,
+				 vif->g_struct_frame_reg[1].frame_type,
+				 vif->g_struct_frame_reg[1].reg);
 	netif_wake_queue(ndev);
 	wl->open_ifcs++;
-	nic->mac_opened = 1;
+	vif->mac_opened = 1;
 	return 0;
 }
 
 static struct net_device_stats *mac_stats(struct net_device *dev)
 {
-	perInterface_wlan_t *nic = netdev_priv(dev);
+	struct wilc_vif *vif= netdev_priv(dev);
 
-	return &nic->netstats;
+	return &vif->netstats;
 }
 
 static void wilc_set_multicast_list(struct net_device *dev)
@@ -1137,7 +1136,7 @@ static void linux_wlan_tx_complete(void *priv, int status)
 
 int wilc_mac_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
-	perInterface_wlan_t *nic;
+	struct wilc_vif *vif;
 	struct tx_complete_data *tx_data = NULL;
 	int queue_count;
 	char *udp_buf;
@@ -1145,8 +1144,8 @@ int wilc_mac_xmit(struct sk_buff *skb, struct net_device *ndev)
 	struct ethhdr *eth_h;
 	struct wilc *wilc;
 
-	nic = netdev_priv(ndev);
-	wilc = nic->wilc;
+	vif = netdev_priv(ndev);
+	wilc = vif->wilc;
 
 	PRINT_D(TX_DBG, "Sending packet just received from TCP/IP\n");
 
@@ -1181,9 +1180,9 @@ int wilc_mac_xmit(struct sk_buff *skb, struct net_device *ndev)
 
 	PRINT_D(TX_DBG, "Sending packet - Size = %d - Address = %p - SKB = %p\n", tx_data->size, tx_data->buff, tx_data->skb);
 	PRINT_D(TX_DBG, "Adding tx packet to TX Queue\n");
-	nic->netstats.tx_packets++;
-	nic->netstats.tx_bytes += tx_data->size;
-	tx_data->pBssid = wilc->vif[nic->u8IfIdx].bssid;
+	vif->netstats.tx_packets++;
+	vif->netstats.tx_bytes += tx_data->size;
+	tx_data->pBssid = wilc->vif[vif->u8IfIdx].bssid;
 	queue_count = wilc_wlan_txq_add_net_pkt(ndev, (void *)tx_data,
 						tx_data->buff, tx_data->size,
 						linux_wlan_tx_complete);
@@ -1199,20 +1198,20 @@ int wilc_mac_xmit(struct sk_buff *skb, struct net_device *ndev)
 int wilc_mac_close(struct net_device *ndev)
 {
 	struct wilc_priv *priv;
-	perInterface_wlan_t *nic;
+	struct wilc_vif *vif;
 	struct host_if_drv *hif_drv;
 	struct wilc *wl;
 
-	nic = netdev_priv(ndev);
+	vif = netdev_priv(ndev);
 
-	if (!nic || !nic->wilc_netdev || !nic->wilc_netdev->ieee80211_ptr ||
-	    !nic->wilc_netdev->ieee80211_ptr->wiphy) {
-		PRINT_ER("nic = NULL\n");
+	if (!vif || !vif->wilc_netdev || !vif->wilc_netdev->ieee80211_ptr ||
+	    !vif->wilc_netdev->ieee80211_ptr->wiphy) {
+		PRINT_ER("vif = NULL\n");
 		return 0;
 	}
 
-	priv = wiphy_priv(nic->wilc_netdev->ieee80211_ptr->wiphy);
-	wl = nic->wilc;
+	priv = wiphy_priv(vif->wilc_netdev->ieee80211_ptr->wiphy);
+	wl = vif->wilc;
 
 	if (!priv) {
 		PRINT_ER("priv = NULL\n");
@@ -1240,10 +1239,10 @@ int wilc_mac_close(struct net_device *ndev)
 		return 0;
 	}
 
-	if (nic->wilc_netdev) {
-		netif_stop_queue(nic->wilc_netdev);
+	if (vif->wilc_netdev) {
+		netif_stop_queue(vif->wilc_netdev);
 
-		wilc_deinit_host_int(nic->wilc_netdev);
+		wilc_deinit_host_int(vif->wilc_netdev);
 	}
 
 	if (wl->open_ifcs == 0) {
@@ -1254,7 +1253,7 @@ int wilc_mac_close(struct net_device *ndev)
 	}
 
 	up(&close_exit_sync);
-	nic->mac_opened = 0;
+	vif->mac_opened = 0;
 
 	return 0;
 }
@@ -1264,13 +1263,13 @@ static int mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 	u8 *buff = NULL;
 	s8 rssi;
 	u32 size = 0, length = 0;
-	perInterface_wlan_t *nic;
+	struct wilc_vif *vif;
 	struct wilc_priv *priv;
 	s32 ret = 0;
 	struct wilc *wilc;
 
-	nic = netdev_priv(ndev);
-	wilc = nic->wilc;
+	vif = netdev_priv(ndev);
+	wilc = vif->wilc;
 
 	if (!wilc->initialized)
 		return 0;
@@ -1289,7 +1288,7 @@ static int mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 				return PTR_ERR(buff);
 
 			if (strncasecmp(buff, "RSSI", length) == 0) {
-				priv = wiphy_priv(nic->wilc_netdev->ieee80211_ptr->wiphy);
+				priv = wiphy_priv(vif->wilc_netdev->ieee80211_ptr->wiphy);
 				ret = wilc_get_rssi(priv->hWILCWFIDrv, &rssi);
 				if (ret)
 					PRINT_ER("Failed to send get rssi param's message queue ");
@@ -1331,14 +1330,14 @@ void wilc_frmw_to_linux(struct wilc *wilc, u8 *buff, u32 size, u32 pkt_offset)
 	unsigned char *buff_to_send = NULL;
 	struct sk_buff *skb;
 	struct net_device *wilc_netdev;
-	perInterface_wlan_t *nic;
+	struct wilc_vif *vif;
 
 	wilc_netdev = get_if_handler(wilc, buff);
 	if (!wilc_netdev)
 		return;
 
 	buff += pkt_offset;
-	nic = netdev_priv(wilc_netdev);
+	vif = netdev_priv(wilc_netdev);
 
 	if (size > 0) {
 		frame_len = size;
@@ -1360,8 +1359,8 @@ void wilc_frmw_to_linux(struct wilc *wilc, u8 *buff, u32 size, u32 pkt_offset)
 		memcpy(skb_put(skb, frame_len), buff_to_send, frame_len);
 
 		skb->protocol = eth_type_trans(skb, wilc_netdev);
-		nic->netstats.rx_packets++;
-		nic->netstats.rx_bytes += frame_len;
+		vif->netstats.rx_packets++;
+		vif->netstats.rx_bytes += frame_len;
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
 		stats = netif_rx(skb);
 		PRINT_D(RX_DBG, "netif_rx ret value is: %d\n", stats);
@@ -1371,32 +1370,32 @@ void wilc_frmw_to_linux(struct wilc *wilc, u8 *buff, u32 size, u32 pkt_offset)
 void WILC_WFI_mgmt_rx(struct wilc *wilc, u8 *buff, u32 size)
 {
 	int i = 0;
-	perInterface_wlan_t *nic;
+	struct wilc_vif *vif;
 
 	for (i = 0; i < wilc->vif_num; i++) {
-		nic = netdev_priv(wilc->vif[i].ndev);
-		if (nic->monitor_flag) {
+		vif = netdev_priv(wilc->vif[i].ndev);
+		if (vif->monitor_flag) {
 			WILC_WFI_monitor_rx(buff, size);
 			return;
 		}
 	}
 
-	nic = netdev_priv(wilc->vif[1].ndev);
-	if ((buff[0] == nic->g_struct_frame_reg[0].frame_type && nic->g_struct_frame_reg[0].reg) ||
-	    (buff[0] == nic->g_struct_frame_reg[1].frame_type && nic->g_struct_frame_reg[1].reg))
+	vif = netdev_priv(wilc->vif[1].ndev);
+	if ((buff[0] == vif->g_struct_frame_reg[0].frame_type && vif->g_struct_frame_reg[0].reg) ||
+	    (buff[0] == vif->g_struct_frame_reg[1].frame_type && vif->g_struct_frame_reg[1].reg))
 		WILC_WFI_p2p_rx(wilc->vif[1].ndev, buff, size);
 }
 
 void wilc_netdev_cleanup(struct wilc *wilc)
 {
 	int i = 0;
-	perInterface_wlan_t *nic[NUM_CONCURRENT_IFC];
+	struct wilc_vif *vif[NUM_CONCURRENT_IFC];
 
 	if (wilc && (wilc->vif[0].ndev || wilc->vif[1].ndev)) {
 		unregister_inetaddr_notifier(&g_dev_notifier);
 
 		for (i = 0; i < NUM_CONCURRENT_IFC; i++)
-			nic[i] = netdev_priv(wilc->vif[i].ndev);
+			vif[i] = netdev_priv(wilc->vif[i].ndev);
 	}
 
 	if (wilc && wilc->firmware)
@@ -1407,7 +1406,7 @@ void wilc_netdev_cleanup(struct wilc *wilc)
 
 		for (i = 0; i < NUM_CONCURRENT_IFC; i++)
 			if (wilc->vif[i].ndev)
-				if (nic[i]->mac_opened)
+				if (vif[i]->mac_opened)
 					wilc_mac_close(wilc->vif[i].ndev);
 
 		for (i = 0; i < NUM_CONCURRENT_IFC; i++) {
@@ -1425,7 +1424,7 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 		     int gpio, const struct wilc_hif_func *ops)
 {
 	int i;
-	perInterface_wlan_t *nic;
+	struct wilc_vif *vif;
 	struct net_device *ndev;
 	struct wilc *wl;
 
@@ -1443,23 +1442,23 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 	register_inetaddr_notifier(&g_dev_notifier);
 
 	for (i = 0; i < NUM_CONCURRENT_IFC; i++) {
-		ndev = alloc_etherdev(sizeof(perInterface_wlan_t));
+		ndev = alloc_etherdev(sizeof(struct wilc_vif));
 		if (!ndev) {
 			PRINT_ER("Failed to allocate ethernet dev\n");
 			return -1;
 		}
 
-		nic = netdev_priv(ndev);
-		memset(nic, 0, sizeof(perInterface_wlan_t));
+		vif = netdev_priv(ndev);
+		memset(vif, 0, sizeof(struct wilc_vif));
 
 		if (i == 0)
 			strcpy(ndev->name, "wlan%d");
 		else
 			strcpy(ndev->name, "p2p%d");
 
-		nic->u8IfIdx = wl->vif_num;
-		nic->wilc_netdev = ndev;
-		nic->wilc = *wilc;
+		vif->u8IfIdx = wl->vif_num;
+		vif->wilc_netdev = ndev;
+		vif->wilc = *wilc;
 		wl->vif[wl->vif_num].ndev = ndev;
 		wl->vif_num++;
 		ndev->netdev_ops = &wilc_netdev_ops;
@@ -1476,13 +1475,13 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 				return -1;
 			}
 
-			nic->wilc_netdev->ieee80211_ptr = wdev;
-			nic->wilc_netdev->ml_priv = nic;
-			wdev->netdev = nic->wilc_netdev;
-			nic->netstats.rx_packets = 0;
-			nic->netstats.tx_packets = 0;
-			nic->netstats.rx_bytes = 0;
-			nic->netstats.tx_bytes = 0;
+			vif->wilc_netdev->ieee80211_ptr = wdev;
+			vif->wilc_netdev->ml_priv = vif;
+			wdev->netdev = vif->wilc_netdev;
+			vif->netstats.rx_packets = 0;
+			vif->netstats.tx_packets = 0;
+			vif->netstats.rx_bytes = 0;
+			vif->netstats.tx_bytes = 0;
 		}
 
 		if (register_netdev(ndev)) {
@@ -1491,8 +1490,8 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 			return -1;
 		}
 
-		nic->iftype = STATION_MODE;
-		nic->mac_opened = 0;
+		vif->iftype = STATION_MODE;
+		vif->mac_opened = 0;
 	}
 
 	return 0;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index bdc4537..8ec12f8 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -500,14 +500,14 @@ static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 	struct host_if_drv *pstrWFIDrv;
 	u8 NullBssid[ETH_ALEN] = {0};
 	struct wilc *wl;
-	perInterface_wlan_t *nic;
+	struct wilc_vif *vif;
 
 	wilc_connecting = 0;
 
 	priv = (struct wilc_priv *)pUserVoid;
 	dev = priv->dev;
-	nic = netdev_priv(dev);
-	wl = nic->wilc;
+	vif = netdev_priv(dev);
+	wl = vif->wilc;
 	pstrWFIDrv = (struct host_if_drv *)priv->hWILCWFIDrv;
 
 	if (enuConnDisconnEvent == CONN_DISCONN_EVENT_CONN_RESP) {
@@ -952,11 +952,11 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 	u8 u8pmode = NO_ENCRYPT;
 	enum AUTHTYPE tenuAuth_type = ANY;
 	struct wilc *wl;
-	perInterface_wlan_t *nic;
+	struct wilc_vif *vif;
 
 	priv = wiphy_priv(wiphy);
-	nic = netdev_priv(netdev);
-	wl = nic->wilc;
+	vif = netdev_priv(netdev);
+	wl = vif->wilc;
 
 	PRINT_D(CFG80211_DBG, "Adding key with cipher suite = %x\n", params->cipher);
 
@@ -1203,11 +1203,11 @@ static int del_key(struct wiphy *wiphy, struct net_device *netdev,
 {
 	struct wilc_priv *priv;
 	struct wilc *wl;
-	perInterface_wlan_t *nic;
+	struct wilc_vif *vif;
 
 	priv = wiphy_priv(wiphy);
-	nic = netdev_priv(netdev);
-	wl = nic->wilc;
+	vif = netdev_priv(netdev);
+	wl = vif->wilc;
 
 	if (netdev == wl->vif[0].ndev) {
 		g_ptk_keys_saved = false;
@@ -1322,14 +1322,14 @@ static int get_station(struct wiphy *wiphy, struct net_device *dev,
 		       const u8 *mac, struct station_info *sinfo)
 {
 	struct wilc_priv *priv;
-	perInterface_wlan_t *nic;
+	struct wilc_vif *vif;
 	u32 i = 0;
 	u32 associatedsta = 0;
 	u32 inactive_time = 0;
 	priv = wiphy_priv(wiphy);
-	nic = netdev_priv(dev);
+	vif = netdev_priv(dev);
 
-	if (nic->iftype == AP_MODE || nic->iftype == GO_MODE) {
+	if (vif->iftype == AP_MODE || vif->iftype == GO_MODE) {
 		PRINT_D(HOSTAPD_DBG, "Getting station parameters\n");
 
 		PRINT_INFO(HOSTAPD_DBG, ": %x%x%x%x%x\n", mac[0], mac[1], mac[2], mac[3], mac[4]);
@@ -1353,7 +1353,7 @@ static int get_station(struct wiphy *wiphy, struct net_device *dev,
 		PRINT_D(CFG80211_DBG, "Inactive time %d\n", sinfo->inactive_time);
 	}
 
-	if (nic->iftype == STATION_MODE) {
+	if (vif->iftype == STATION_MODE) {
 		struct rf_info strStatistics;
 
 		wilc_get_statistics(priv->hWILCWFIDrv, &strStatistics);
@@ -1816,10 +1816,10 @@ static int mgmt_tx(struct wiphy *wiphy,
 	struct wilc_priv *priv;
 	struct host_if_drv *pstrWFIDrv;
 	u32 i;
-	perInterface_wlan_t *nic;
+	struct wilc_vif *vif;
 	u32 buf_len = len + sizeof(p2p_vendor_spec) + sizeof(p2p_local_random);
 
-	nic = netdev_priv(wdev->netdev);
+	vif = netdev_priv(wdev->netdev);
 	priv = wiphy_priv(wiphy);
 	pstrWFIDrv = (struct host_if_drv *)priv->hWILCWFIDrv;
 
@@ -1890,9 +1890,9 @@ static int mgmt_tx(struct wiphy *wiphy,
 								for (i = P2P_PUB_ACTION_SUBTYPE + 2; i < len; i++) {
 									if (buf[i] == P2PELEM_ATTR_ID && !(memcmp(p2p_oui, &buf[i + 2], 4))) {
 										if (buf[P2P_PUB_ACTION_SUBTYPE] == P2P_INV_REQ || buf[P2P_PUB_ACTION_SUBTYPE] == P2P_INV_RSP)
-											WILC_WFI_CfgParseTxAction(&mgmt_tx->buff[i + 6], len - (i + 6), true, nic->iftype);
+											WILC_WFI_CfgParseTxAction(&mgmt_tx->buff[i + 6], len - (i + 6), true, vif->iftype);
 										else
-											WILC_WFI_CfgParseTxAction(&mgmt_tx->buff[i + 6], len - (i + 6), false, nic->iftype);
+											WILC_WFI_CfgParseTxAction(&mgmt_tx->buff[i + 6], len - (i + 6), false, vif->iftype);
 										break;
 									}
 								}
@@ -1966,12 +1966,12 @@ void wilc_mgmt_frame_register(struct wiphy *wiphy, struct wireless_dev *wdev,
 			      u16 frame_type, bool reg)
 {
 	struct wilc_priv *priv;
-	perInterface_wlan_t *nic;
+	struct wilc_vif *vif;
 	struct wilc *wl;
 
 	priv = wiphy_priv(wiphy);
-	nic = netdev_priv(priv->wdev->netdev);
-	wl = nic->wilc;
+	vif = netdev_priv(priv->wdev->netdev);
+	wl = vif->wilc;
 
 	if (!frame_type)
 		return;
@@ -1980,15 +1980,15 @@ void wilc_mgmt_frame_register(struct wiphy *wiphy, struct wireless_dev *wdev,
 	switch (frame_type) {
 	case PROBE_REQ:
 	{
-		nic->g_struct_frame_reg[0].frame_type = frame_type;
-		nic->g_struct_frame_reg[0].reg = reg;
+		vif->g_struct_frame_reg[0].frame_type = frame_type;
+		vif->g_struct_frame_reg[0].reg = reg;
 	}
 	break;
 
 	case ACTION:
 	{
-		nic->g_struct_frame_reg[1].frame_type = frame_type;
-		nic->g_struct_frame_reg[1].reg = reg;
+		vif->g_struct_frame_reg[1].frame_type = frame_type;
+		vif->g_struct_frame_reg[1].reg = reg;
 	}
 	break;
 
@@ -2058,15 +2058,15 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 			       enum nl80211_iftype type, u32 *flags, struct vif_params *params)
 {
 	struct wilc_priv *priv;
-	perInterface_wlan_t *nic;
+	struct wilc_vif *vif;
 	u8 interface_type;
 	u16 TID = 0;
 	u8 i;
 	struct wilc *wl;
 
-	nic = netdev_priv(dev);
+	vif = netdev_priv(dev);
 	priv = wiphy_priv(wiphy);
-	wl = nic->wilc;
+	wl = vif->wilc;
 
 	PRINT_D(HOSTAPD_DBG, "In Change virtual interface function\n");
 	PRINT_D(HOSTAPD_DBG, "Wireless interface name =%s\n", dev->name);
@@ -2088,12 +2088,12 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 
 		dev->ieee80211_ptr->iftype = type;
 		priv->wdev->iftype = type;
-		nic->monitor_flag = 0;
-		nic->iftype = STATION_MODE;
+		vif->monitor_flag = 0;
+		vif->iftype = STATION_MODE;
 
 		memset(priv->assoc_stainfo.au8Sta_AssociatedBss, 0, MAX_NUM_STA * ETH_ALEN);
-		interface_type = nic->iftype;
-		nic->iftype = STATION_MODE;
+		interface_type = vif->iftype;
+		vif->iftype = STATION_MODE;
 
 		if (wl->initialized) {
 			wilc_del_all_rx_ba_session(priv->hWILCWFIDrv,
@@ -2103,9 +2103,9 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 			up(&wl->cfg_event);
 
 			wilc1000_wlan_deinit(dev);
-			wilc1000_wlan_init(dev, nic);
+			wilc1000_wlan_init(dev, vif);
 			wilc_initialized = 1;
-			nic->iftype = interface_type;
+			vif->iftype = interface_type;
 
 			wilc_set_wfi_drv_handler(wl->vif[0].hif_drv);
 			wilc_set_mac_address(wl->vif[0].hif_drv,
@@ -2147,11 +2147,11 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 
 			if (wl->initialized)	{
 				for (i = 0; i < num_reg_frame; i++) {
-					PRINT_D(INIT_DBG, "Frame registering Type: %x - Reg: %d\n", nic->g_struct_frame_reg[i].frame_type,
-						nic->g_struct_frame_reg[i].reg);
+					PRINT_D(INIT_DBG, "Frame registering Type: %x - Reg: %d\n", vif->g_struct_frame_reg[i].frame_type,
+						vif->g_struct_frame_reg[i].reg);
 					wilc_frame_register(priv->hWILCWFIDrv,
-								nic->g_struct_frame_reg[i].frame_type,
-								nic->g_struct_frame_reg[i].reg);
+								vif->g_struct_frame_reg[i].frame_type,
+								vif->g_struct_frame_reg[i].reg);
 				}
 			}
 
@@ -2171,17 +2171,17 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 
 		dev->ieee80211_ptr->iftype = type;
 		priv->wdev->iftype = type;
-		nic->monitor_flag = 0;
+		vif->monitor_flag = 0;
 
 		PRINT_D(HOSTAPD_DBG, "Downloading P2P_CONCURRENCY_FIRMWARE\n");
-		nic->iftype = CLIENT_MODE;
+		vif->iftype = CLIENT_MODE;
 
 
 		if (wl->initialized)	{
 			wilc_wait_msg_queue_idle();
 
 			wilc1000_wlan_deinit(dev);
-			wilc1000_wlan_init(dev, nic);
+			wilc1000_wlan_init(dev, vif);
 			wilc_initialized = 1;
 
 			wilc_set_wfi_drv_handler(wl->vif[0].hif_drv);
@@ -2227,11 +2227,11 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 
 			if (wl->initialized)	{
 				for (i = 0; i < num_reg_frame; i++) {
-					PRINT_D(INIT_DBG, "Frame registering Type: %x - Reg: %d\n", nic->g_struct_frame_reg[i].frame_type,
-						nic->g_struct_frame_reg[i].reg);
+					PRINT_D(INIT_DBG, "Frame registering Type: %x - Reg: %d\n", vif->g_struct_frame_reg[i].frame_type,
+						vif->g_struct_frame_reg[i].reg);
 					wilc_frame_register(priv->hWILCWFIDrv,
-								nic->g_struct_frame_reg[i].frame_type,
-								nic->g_struct_frame_reg[i].reg);
+								vif->g_struct_frame_reg[i].frame_type,
+								vif->g_struct_frame_reg[i].reg);
 				}
 			}
 		}
@@ -2242,23 +2242,23 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		PRINT_D(HOSTAPD_DBG, "Interface type = NL80211_IFTYPE_AP %d\n", type);
 		dev->ieee80211_ptr->iftype = type;
 		priv->wdev->iftype = type;
-		nic->iftype = AP_MODE;
+		vif->iftype = AP_MODE;
 		PRINT_D(CORECONFIG_DBG, "priv->hWILCWFIDrv[%p]\n", priv->hWILCWFIDrv);
 
 		PRINT_D(HOSTAPD_DBG, "Downloading AP firmware\n");
 		wilc_wlan_get_firmware(dev);
 
 		if (wl->initialized)	{
-			nic->iftype = AP_MODE;
+			vif->iftype = AP_MODE;
 			wilc_mac_close(dev);
 			wilc_mac_open(dev);
 
 			for (i = 0; i < num_reg_frame; i++) {
-				PRINT_D(INIT_DBG, "Frame registering Type: %x - Reg: %d\n", nic->g_struct_frame_reg[i].frame_type,
-					nic->g_struct_frame_reg[i].reg);
+				PRINT_D(INIT_DBG, "Frame registering Type: %x - Reg: %d\n", vif->g_struct_frame_reg[i].frame_type,
+					vif->g_struct_frame_reg[i].reg);
 				wilc_frame_register(priv->hWILCWFIDrv,
-							nic->g_struct_frame_reg[i].frame_type,
-							nic->g_struct_frame_reg[i].reg);
+							vif->g_struct_frame_reg[i].frame_type,
+							vif->g_struct_frame_reg[i].reg);
 			}
 		}
 		break;
@@ -2282,11 +2282,11 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		PRINT_D(HOSTAPD_DBG, "Downloading P2P_CONCURRENCY_FIRMWARE\n");
 
 
-		nic->iftype = GO_MODE;
+		vif->iftype = GO_MODE;
 
 		wilc_wait_msg_queue_idle();
 		wilc1000_wlan_deinit(dev);
-		wilc1000_wlan_init(dev, nic);
+		wilc1000_wlan_init(dev, vif);
 		wilc_initialized = 1;
 
 		wilc_set_wfi_drv_handler(wl->vif[0].hif_drv);
@@ -2331,11 +2331,11 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 
 		if (wl->initialized)	{
 			for (i = 0; i < num_reg_frame; i++) {
-				PRINT_D(INIT_DBG, "Frame registering Type: %x - Reg: %d\n", nic->g_struct_frame_reg[i].frame_type,
-					nic->g_struct_frame_reg[i].reg);
+				PRINT_D(INIT_DBG, "Frame registering Type: %x - Reg: %d\n", vif->g_struct_frame_reg[i].frame_type,
+					vif->g_struct_frame_reg[i].reg);
 				wilc_frame_register(priv->hWILCWFIDrv,
-							nic->g_struct_frame_reg[i].frame_type,
-							nic->g_struct_frame_reg[i].reg);
+							vif->g_struct_frame_reg[i].frame_type,
+							vif->g_struct_frame_reg[i].reg);
 			}
 		}
 		break;
@@ -2355,11 +2355,11 @@ static int start_ap(struct wiphy *wiphy, struct net_device *dev,
 	struct wilc_priv *priv;
 	s32 s32Error = 0;
 	struct wilc *wl;
-	perInterface_wlan_t *nic;
+	struct wilc_vif *vif;
 
 	priv = wiphy_priv(wiphy);
-	nic = netdev_priv(dev);
-	wl = nic->wilc;
+	vif = netdev_priv(dev);
+	wl = vif ->wilc;
 	PRINT_D(HOSTAPD_DBG, "Starting ap\n");
 
 	PRINT_D(HOSTAPD_DBG, "Interval = %d\n DTIM period = %d\n Head length = %zu Tail length = %zu\n",
@@ -2429,15 +2429,15 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
 	s32 s32Error = 0;
 	struct wilc_priv *priv;
 	struct add_sta_param strStaParams = { {0} };
-	perInterface_wlan_t *nic;
+	struct wilc_vif *vif;
 
 	if (!wiphy)
 		return -EFAULT;
 
 	priv = wiphy_priv(wiphy);
-	nic = netdev_priv(dev);
+	vif = netdev_priv(dev);
 
-	if (nic->iftype == AP_MODE || nic->iftype == GO_MODE) {
+	if (vif->iftype == AP_MODE || vif->iftype == GO_MODE) {
 		memcpy(strStaParams.bssid, mac, ETH_ALEN);
 		memcpy(priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid], mac, ETH_ALEN);
 		strStaParams.aid = params->aid;
@@ -2500,15 +2500,15 @@ static int del_station(struct wiphy *wiphy, struct net_device *dev,
 	const u8 *mac = params->mac;
 	s32 s32Error = 0;
 	struct wilc_priv *priv;
-	perInterface_wlan_t *nic;
+	struct wilc_vif *vif;
 
 	if (!wiphy)
 		return -EFAULT;
 
 	priv = wiphy_priv(wiphy);
-	nic = netdev_priv(dev);
+	vif = netdev_priv(dev);
 
-	if (nic->iftype == AP_MODE || nic->iftype == GO_MODE) {
+	if (vif->iftype == AP_MODE || vif->iftype == GO_MODE) {
 		PRINT_D(HOSTAPD_DBG, "Deleting station\n");
 
 
@@ -2533,7 +2533,7 @@ static int change_station(struct wiphy *wiphy, struct net_device *dev,
 	s32 s32Error = 0;
 	struct wilc_priv *priv;
 	struct add_sta_param strStaParams = { {0} };
-	perInterface_wlan_t *nic;
+	struct wilc_vif *vif;
 
 
 	PRINT_D(HOSTAPD_DBG, "Change station paramters\n");
@@ -2542,9 +2542,9 @@ static int change_station(struct wiphy *wiphy, struct net_device *dev,
 		return -EFAULT;
 
 	priv = wiphy_priv(wiphy);
-	nic = netdev_priv(dev);
+	vif = netdev_priv(dev);
 
-	if (nic->iftype == AP_MODE || nic->iftype == GO_MODE) {
+	if (vif->iftype == AP_MODE || vif->iftype == GO_MODE) {
 		memcpy(strStaParams.bssid, mac, ETH_ALEN);
 		strStaParams.aid = params->aid;
 		strStaParams.rates_len = params->supported_rates_len;
@@ -2606,7 +2606,7 @@ static struct wireless_dev *add_virtual_intf(struct wiphy *wiphy,
 					     u32 *flags,
 					     struct vif_params *params)
 {
-	perInterface_wlan_t *nic;
+	struct wilc_vif *vif;
 	struct wilc_priv *priv;
 	struct net_device *new_ifc = NULL;
 
@@ -2616,17 +2616,17 @@ static struct wireless_dev *add_virtual_intf(struct wiphy *wiphy,
 
 	PRINT_D(HOSTAPD_DBG, "Adding monitor interface[%p]\n", priv->wdev->netdev);
 
-	nic = netdev_priv(priv->wdev->netdev);
+	vif = netdev_priv(priv->wdev->netdev);
 
 
 	if (type == NL80211_IFTYPE_MONITOR) {
 		PRINT_D(HOSTAPD_DBG, "Monitor interface mode: Initializing mon interface virtual device driver\n");
-		PRINT_D(HOSTAPD_DBG, "Adding monitor interface[%p]\n", nic->wilc_netdev);
-		new_ifc = WILC_WFI_init_mon_interface(name, nic->wilc_netdev);
+		PRINT_D(HOSTAPD_DBG, "Adding monitor interface[%p]\n", vif->wilc_netdev);
+		new_ifc = WILC_WFI_init_mon_interface(name, vif->wilc_netdev);
 		if (new_ifc) {
 			PRINT_D(HOSTAPD_DBG, "Setting monitor flag in private structure\n");
-			nic = netdev_priv(priv->wdev->netdev);
-			nic->monitor_flag = 1;
+			vif = netdev_priv(priv->wdev->netdev);
+			vif->monitor_flag = 1;
 		} else
 			PRINT_ER("Error in initializing monitor interface\n ");
 	}
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index b9961f0..0d04497 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -149,6 +149,14 @@ typedef struct {
 } struct_frame_reg;
 
 struct wilc_vif {
+	u8 u8IfIdx;
+	u8 iftype;
+	int monitor_flag;
+	int mac_opened;
+	struct_frame_reg g_struct_frame_reg[num_reg_frame];
+	struct net_device *wilc_netdev;
+	struct net_device_stats netstats;
+	struct wilc *wilc;
 	u8 src_addr[ETH_ALEN];
 	u8 bssid[ETH_ALEN];
 	struct host_if_drv *hif_drv;
@@ -210,22 +218,11 @@ struct wilc {
 	struct device *dev;
 };
 
-typedef struct {
-	u8 u8IfIdx;
-	u8 iftype;
-	int monitor_flag;
-	int mac_opened;
-	struct_frame_reg g_struct_frame_reg[num_reg_frame];
-	struct net_device *wilc_netdev;
-	struct net_device_stats netstats;
-	struct wilc *wilc;
-} perInterface_wlan_t;
-
 struct WILC_WFI_mon_priv {
 	struct net_device *real_ndev;
 };
 
-int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic);
+int wilc1000_wlan_init(struct net_device *dev, struct wilc_vif *vif);
 
 void wilc_frmw_to_linux(struct wilc *wilc, u8 *buff, u32 size, u32 pkt_offset);
 void wilc_mac_indicate(struct wilc *wilc, int flag);
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 32ecc2d..768a42c 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -72,11 +72,11 @@ wilc_wlan_txq_remove_from_head(struct net_device *dev)
 {
 	struct txq_entry_t *tqe;
 	unsigned long flags;
-	perInterface_wlan_t *nic;
+	struct wilc_vif *vif;
 	struct wilc *wilc;
 
-	nic = netdev_priv(dev);
-	wilc = nic->wilc;
+	vif = netdev_priv(dev);
+	wilc = vif->wilc;
 
 	spin_lock_irqsave(&wilc->txq_spinlock, flags);
 	if (wilc->txq_head) {
@@ -97,11 +97,11 @@ static void wilc_wlan_txq_add_to_tail(struct net_device *dev,
 				      struct txq_entry_t *tqe)
 {
 	unsigned long flags;
-	perInterface_wlan_t *nic;
+	struct wilc_vif *vif;
 	struct wilc *wilc;
 
-	nic = netdev_priv(dev);
-	wilc = nic->wilc;
+	vif = netdev_priv(dev);
+	wilc = vif->wilc;
 
 	spin_lock_irqsave(&wilc->txq_spinlock, flags);
 
@@ -239,11 +239,11 @@ static inline int tcp_process(struct net_device *dev, struct txq_entry_t *tqe)
 	unsigned short h_proto;
 	int i;
 	unsigned long flags;
-	perInterface_wlan_t *nic;
+	struct wilc_vif *vif;
 	struct wilc *wilc;
 
-	nic = netdev_priv(dev);
-	wilc = nic->wilc;
+	vif = netdev_priv(dev);
+	wilc = vif->wilc;
 
 
 	eth_hdr_ptr = &buffer[0];
@@ -301,13 +301,13 @@ static inline int tcp_process(struct net_device *dev, struct txq_entry_t *tqe)
 
 static int wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
 {
-	perInterface_wlan_t *nic;
+	struct wilc_vif *vif;
 	struct wilc *wilc;
 	u32 i = 0;
 	u32 dropped = 0;
 
-	nic = netdev_priv(dev);
-	wilc = nic->wilc;
+	vif = netdev_priv(dev);
+	wilc = vif->wilc;
 
 	spin_lock_irqsave(&wilc->txq_spinlock, wilc->txq_spinlock_flags);
 	for (i = pending_base; i < (pending_base + pending_acks); i++) {
@@ -397,10 +397,10 @@ int wilc_wlan_txq_add_net_pkt(struct net_device *dev, void *priv, u8 *buffer,
 			      u32 buffer_size, wilc_tx_complete_func_t func)
 {
 	struct txq_entry_t *tqe;
-	perInterface_wlan_t *nic = netdev_priv(dev);
+	struct wilc_vif *vif = netdev_priv(dev);
 	struct wilc *wilc;
 
-	wilc = nic->wilc;
+	wilc = vif->wilc;
 
 	if (wilc->quit)
 		return 0;
@@ -429,10 +429,10 @@ int wilc_wlan_txq_add_mgmt_pkt(struct net_device *dev, void *priv, u8 *buffer,
 			       u32 buffer_size, wilc_tx_complete_func_t func)
 {
 	struct txq_entry_t *tqe;
-	perInterface_wlan_t *nic = netdev_priv(dev);
+	struct wilc_vif *vif = netdev_priv(dev);
 	struct wilc *wilc;
 
-	wilc = nic->wilc;
+	wilc = vif->wilc;
 
 	if (wilc->quit)
 		return 0;
@@ -676,11 +676,11 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 	int counter;
 	int timeout;
 	u32 vmm_table[WILC_VMM_TBL_SIZE];
-	perInterface_wlan_t *nic;
+	struct wilc_vif *vif;
 	struct wilc *wilc;
 
-	nic = netdev_priv(dev);
-	wilc = nic->wilc;
+	vif = netdev_priv(dev);
+	wilc = vif->wilc;
 
 	txb = wilc->tx_buffer;
 	wilc->txq_exit = 0;
@@ -1348,11 +1348,11 @@ void wilc_wlan_cleanup(struct net_device *dev)
 	struct rxq_entry_t *rqe;
 	u32 reg = 0;
 	int ret;
-	perInterface_wlan_t *nic;
+	struct wilc_vif *vif;
 	struct wilc *wilc;
 
-	nic = netdev_priv(dev);
-	wilc = nic->wilc;
+	vif = netdev_priv(dev);
+	wilc = vif->wilc;
 
 	wilc->quit = 1;
 	do {
@@ -1510,11 +1510,11 @@ static u32 init_chip(struct net_device *dev)
 {
 	u32 chipid;
 	u32 reg, ret = 0;
-	perInterface_wlan_t *nic;
+	struct wilc_vif *vif;
 	struct wilc *wilc;
 
-	nic = netdev_priv(dev);
-	wilc = nic->wilc;
+	vif = netdev_priv(dev);
+	wilc = vif->wilc;
 
 	acquire_bus(wilc, ACQUIRE_ONLY);
 
@@ -1580,10 +1580,10 @@ _fail_:
 int wilc_wlan_init(struct net_device *dev)
 {
 	int ret = 0;
-	perInterface_wlan_t *nic = netdev_priv(dev);
+	struct wilc_vif *vif = netdev_priv(dev);
 	struct wilc *wilc;
 
-	wilc = nic->wilc;
+	wilc = vif->wilc;
 
 	PRINT_D(INIT_DBG, "Initializing WILC_Wlan ...\n");
 
@@ -1640,11 +1640,11 @@ u16 wilc_set_machw_change_vir_if(struct net_device *dev, bool value)
 {
 	u16 ret;
 	u32 reg;
-	perInterface_wlan_t *nic;
+	struct wilc_vif *vif;
 	struct wilc *wilc;
 
-	nic = netdev_priv(dev);
-	wilc = nic->wilc;
+	vif = netdev_priv(dev);
+	wilc = vif->wilc;
 
 	mutex_lock(&wilc->hif_cs);
 	ret = wilc->hif_func->hif_read_reg(wilc, WILC_CHANGING_VIR_IF,
-- 
1.9.1

