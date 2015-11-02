Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:7476 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbbKBItw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2015 03:49:52 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 16/38] staging: wilc1000: fixes blank lines aren't necessary brace
Date: Mon, 2 Nov 2015 17:50:59 +0900
Message-ID: <1446454281-22484-16-git-send-email-glen.lee@atmel.com> (sfid-20151102_101655_202146_55882666)
In-Reply-To: <1446454281-22484-1-git-send-email-glen.lee@atmel.com>
References: <1446454281-22484-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch fixes the checks reported by checkpatch.pl
for Blank lines aren't necessary after an open brace '{' and
Blank lines aren't necessary before a close brace '}'.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 335aa2b..b7c40ac 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -218,7 +218,6 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 	}
 
 	return NOTIFY_DONE;
-
 }
 
 #if (defined WILC_SPI) || (defined WILC_SDIO_IRQ_GPIO)
@@ -284,11 +283,9 @@ static int init_irq(struct net_device *dev)
 	if ((ret != -1) && (request_threaded_irq(wl->dev_irq_num, isr_uh_routine, isr_bh_routine,
 						  IRQF_TRIGGER_LOW | IRQF_ONESHOT,               /*Without IRQF_ONESHOT the uh will remain kicked in and dont gave a chance to bh*/
 						  "WILC_IRQ", dev)) < 0) {
-
 		PRINT_ER("Failed to request IRQ for GPIO: %d\n", GPIO_NUM);
 		ret = -1;
 	} else {
-
 		PRINT_D(INIT_DBG, "IRQ request succeeded IRQ-NUM= %d on GPIO: %d\n",
 			wl->dev_irq_num, GPIO_NUM);
 	}
@@ -353,12 +350,9 @@ void linux_wlan_mac_indicate(struct wilc *wilc, int flag)
 
 		if (wilc->mac_status == WILC_MAC_STATUS_CONNECT) {        /* Connect */
 		}
-
 	} else if (flag == WILC_MAC_INDICATE_SCAN) {
 		PRINT_D(GENERIC_DBG, "Scanning ...\n");
-
 	}
-
 }
 
 struct net_device *GetIfHandler(struct wilc *wilc, u8 *pMacHeader)
@@ -449,7 +443,6 @@ static int linux_wlan_txq_task(void *vp)
 	/* inform wilc1000_wlan_init that TXQ task is started. */
 	up(&wl->txq_thread_started);
 	while (1) {
-
 		PRINT_D(TX_DBG, "txq_task Taking a nap :)\n");
 		down(&wl->txq_event);
 		/* wait_for_completion(&pd->txq_event); */
@@ -562,7 +555,6 @@ int linux_wlan_get_firmware(struct net_device *dev)
 _fail_:
 
 	return ret;
-
 }
 
 static int linux_wlan_start_firmware(struct net_device *dev)
@@ -635,7 +627,6 @@ _FAIL_:
 /* startup configuration - could be changed later using iconfig*/
 static int linux_wlan_init_test_config(struct net_device *dev, struct wilc *p_nic)
 {
-
 	unsigned char c_val[64];
 	unsigned char mac_add[] = {0x00, 0x80, 0xC2, 0x5E, 0xa2, 0xff};
 
@@ -1001,7 +992,6 @@ static int wlan_deinit_locks(struct net_device *dev)
 }
 void linux_to_wlan(wilc_wlan_inp_t *nwi, struct wilc *nic)
 {
-
 	PRINT_D(INIT_DBG, "Linux to Wlan services ...\n");
 
 	nwi->wilc = (void *)nic;
@@ -1197,7 +1187,6 @@ _fail_locks_:
 
 int mac_init_fn(struct net_device *ndev)
 {
-
 	/*Why we do this !!!*/
 	netif_start_queue(ndev); /* ma */
 	netif_stop_queue(ndev); /* ma */
@@ -1295,7 +1284,6 @@ struct net_device_stats *mac_stats(struct net_device *dev)
 /* Setup the multicast filter */
 static void wilc_set_multicast_list(struct net_device *dev)
 {
-
 	struct netdev_hw_addr *ha;
 	struct wilc_priv *priv;
 	struct host_if_drv *hif_drv;
@@ -1350,12 +1338,10 @@ static void wilc_set_multicast_list(struct net_device *dev)
 	host_int_setup_multicast_filter(hif_drv, true, (dev->mc.count));
 
 	return;
-
 }
 
 static void linux_wlan_tx_complete(void *priv, int status)
 {
-
 	struct tx_complete_data *pv_data = (struct tx_complete_data *)priv;
 
 	if (status == 1)
@@ -1500,7 +1486,6 @@ int mac_close(struct net_device *ndev)
 
 int mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 {
-
 	u8 *buff = NULL;
 	s8 rssi;
 	u32 size = 0, length = 0;
@@ -1517,7 +1502,6 @@ int mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 		return 0;
 
 	switch (cmd) {
-
 	/* ]] 2013-06-24 */
 	case SIOCSIWPRIV:
 	{
@@ -1526,7 +1510,6 @@ int mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 		size = wrq->u.data.length;
 
 		if (size && wrq->u.data.pointer) {
-
 			buff = memdup_user(wrq->u.data.pointer, wrq->u.data.length);
 			if (IS_ERR(buff))
 				return PTR_ERR(buff);
@@ -1570,7 +1553,6 @@ done:
 
 void frmw_to_linux(struct wilc *wilc, u8 *buff, u32 size, u32 pkt_offset)
 {
-
 	unsigned int frame_len = 0;
 	int stats;
 	unsigned char *buff_to_send = NULL;
@@ -1586,7 +1568,6 @@ void frmw_to_linux(struct wilc *wilc, u8 *buff, u32 size, u32 pkt_offset)
 	nic = netdev_priv(wilc_netdev);
 
 	if (size > 0) {
-
 		frame_len = size;
 		buff_to_send = buff;
 
@@ -1762,7 +1743,6 @@ int wilc_netdev_init(struct wilc **wilc)
 			nic->netstats.tx_packets = 0;
 			nic->netstats.rx_bytes = 0;
 			nic->netstats.tx_bytes = 0;
-
 		}
 
 		if (register_netdev(ndev)) {
@@ -1772,7 +1752,6 @@ int wilc_netdev_init(struct wilc **wilc)
 
 		nic->iftype = STATION_MODE;
 		nic->mac_opened = 0;
-
 	}
 
 	#ifndef WILC_SDIO
-- 
1.9.1

