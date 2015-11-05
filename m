Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:26504 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104AbbKEFeV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 00:34:21 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 09/38] staging: wilc1000: replace explicit NULL comparisons with !
Date: Thu, 5 Nov 2015 14:36:10 +0900
Message-ID: <1446701799-24870-9-git-send-email-glen.lee@atmel.com> (sfid-20151105_063425_052360_67036349)
In-Reply-To: <1446701799-24870-1-git-send-email-glen.lee@atmel.com>
References: <1446701799-24870-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch replace explicit NULL comparison with ! or unmark
operator to simplify code.
Reported by checkpatch.pl for comparison to NULL could be written "!XXX" or "XXX".

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 45 ++++++++++++++++++-----------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 1e14e97..d50f0d6 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -136,7 +136,7 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 	u8 null_ip[4] = {0};
 	char wlan_dev_name[5] = "wlan0";
 
-	if (dev_iface == NULL || dev_iface->ifa_dev == NULL || dev_iface->ifa_dev->dev == NULL)	{
+	if (!dev_iface || !dev_iface->ifa_dev || !dev_iface->ifa_dev->dev) {
 		PRINT_D(GENERIC_DBG, "dev_iface = NULL\n");
 		return NOTIFY_DONE;
 	}
@@ -147,18 +147,18 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 	}
 
 	dev  = (struct net_device *)dev_iface->ifa_dev->dev;
-	if (dev->ieee80211_ptr == NULL || dev->ieee80211_ptr->wiphy == NULL) {
+	if (!dev->ieee80211_ptr || !dev->ieee80211_ptr->wiphy) {
 		PRINT_D(GENERIC_DBG, "No Wireless registerd\n");
 		return NOTIFY_DONE;
 	}
 	priv = wiphy_priv(dev->ieee80211_ptr->wiphy);
-	if (priv == NULL) {
+	if (!priv) {
 		PRINT_D(GENERIC_DBG, "No Wireless Priv\n");
 		return NOTIFY_DONE;
 	}
 	pstrWFIDrv = (struct host_if_drv *)priv->hWILCWFIDrv;
 	nic = netdev_priv(dev);
-	if (nic == NULL || pstrWFIDrv == NULL) {
+	if (!nic || !pstrWFIDrv) {
 		PRINT_D(GENERIC_DBG, "No Wireless Priv\n");
 		return NOTIFY_DONE;
 	}
@@ -339,7 +339,7 @@ int linux_wlan_lock_timeout(void *vp, u32 timeout)
 	int error = -1;
 
 	PRINT_D(LOCK_DBG, "Locking %p\n", vp);
-	if (vp != NULL)
+	if (vp)
 		error = down_timeout((struct semaphore *)vp, msecs_to_jiffies(timeout));
 	else
 		PRINT_ER("Failed, mutex is NULL\n");
@@ -538,12 +538,12 @@ int linux_wlan_get_firmware(struct net_device *dev)
 		firmware = P2P_CONCURRENCY_FIRMWARE;
 	}
 
-	if (nic == NULL) {
+	if (!nic) {
 		PRINT_ER("NIC is NULL\n");
 		goto _fail_;
 	}
 
-	if (&nic->wilc_netdev->dev == NULL) {
+	if (!(&nic->wilc_netdev->dev)) {
 		PRINT_ER("&nic->wilc_netdev->dev  is NULL\n");
 		goto _fail_;
 	}
@@ -925,7 +925,7 @@ void wilc1000_wlan_deinit(struct net_device *dev)
 		disable_sdio_interrupt();
 		mutex_unlock(&wl->hif_cs);
 #endif
-		if (&wl->txq_event != NULL)
+		if (&wl->txq_event)
 			up(&wl->txq_event);
 
 		PRINT_D(INIT_DBG, "Deinitializing Threads\n");
@@ -998,10 +998,10 @@ static int wlan_deinit_locks(struct net_device *dev)
 
 	PRINT_D(INIT_DBG, "De-Initializing Locks\n");
 
-	if (&wilc->hif_cs != NULL)
+	if (&wilc->hif_cs)
 		mutex_destroy(&wilc->hif_cs);
 
-	if (&wilc->rxq_cs != NULL)
+	if (&wilc->rxq_cs)
 		mutex_destroy(&wilc->rxq_cs);
 
 	return 0;
@@ -1074,10 +1074,10 @@ static void wlan_deinitialize_threads(struct net_device *dev)
 	wl->close = 1;
 	PRINT_D(INIT_DBG, "Deinitializing Threads\n");
 
-	if (&wl->txq_event != NULL)
+	if (&wl->txq_event)
 		up(&wl->txq_event);
 
-	if (wl->txq_thread != NULL) {
+	if (wl->txq_thread) {
 		kthread_stop(wl->txq_thread);
 		wl->txq_thread = NULL;
 	}
@@ -1396,7 +1396,7 @@ int mac_xmit(struct sk_buff *skb, struct net_device *ndev)
 	}
 
 	tx_data = kmalloc(sizeof(struct tx_complete_data), GFP_ATOMIC);
-	if (tx_data == NULL) {
+	if (!tx_data) {
 		PRINT_ER("Failed to allocate memory for tx_data structure\n");
 		dev_kfree_skb(skb);
 		netif_wake_queue(ndev);
@@ -1450,7 +1450,8 @@ int mac_close(struct net_device *ndev)
 
 	nic = netdev_priv(ndev);
 
-	if ((nic == NULL) || (nic->wilc_netdev == NULL) || (nic->wilc_netdev->ieee80211_ptr == NULL) || (nic->wilc_netdev->ieee80211_ptr->wiphy == NULL)) {
+	if (!nic || !nic->wilc_netdev || !nic->wilc_netdev->ieee80211_ptr ||
+	    !nic->wilc_netdev->ieee80211_ptr->wiphy) {
 		PRINT_ER("nic = NULL\n");
 		return 0;
 	}
@@ -1458,7 +1459,7 @@ int mac_close(struct net_device *ndev)
 	priv = wiphy_priv(nic->wilc_netdev->ieee80211_ptr->wiphy);
 	wl = nic->wilc;
 
-	if (priv == NULL) {
+	if (!priv) {
 		PRINT_ER("priv = NULL\n");
 		return 0;
 	}
@@ -1472,7 +1473,7 @@ int mac_close(struct net_device *ndev)
 		return 0;
 	}
 
-	if (pstrWFIDrv == NULL)	{
+	if (!pstrWFIDrv) {
 		PRINT_ER("pstrWFIDrv = NULL\n");
 		return 0;
 	}
@@ -1484,7 +1485,7 @@ int mac_close(struct net_device *ndev)
 		return 0;
 	}
 
-	if (nic->wilc_netdev != NULL) {
+	if (nic->wilc_netdev) {
 		/* Stop the network interface queue */
 		netif_stop_queue(nic->wilc_netdev);
 
@@ -1585,7 +1586,7 @@ void frmw_to_linux(struct wilc *wilc, u8 *buff, u32 size, u32 pkt_offset)
 	perInterface_wlan_t *nic;
 
 	wilc_netdev = GetIfHandler(wilc, buff);
-	if (wilc_netdev == NULL)
+	if (!wilc_netdev)
 		return;
 
 	buff += pkt_offset;
@@ -1598,16 +1599,16 @@ void frmw_to_linux(struct wilc *wilc, u8 *buff, u32 size, u32 pkt_offset)
 
 		/* Need to send the packet up to the host, allocate a skb buffer */
 		skb = dev_alloc_skb(frame_len);
-		if (skb == NULL) {
+		if (!skb) {
 			PRINT_ER("Low memory - packet droped\n");
 			return;
 		}
 
-		if (wilc == NULL || wilc_netdev == NULL)
+		if (!wilc || !wilc_netdev)
 			PRINT_ER("wilc_netdev in wilc is NULL");
 		skb->dev = wilc_netdev;
 
-		if (skb->dev == NULL)
+		if (!skb->dev)
 			PRINT_ER("skb->dev is NULL\n");
 
 		/*
@@ -1754,7 +1755,7 @@ int wilc_netdev_init(struct wilc **wilc)
 			SET_NETDEV_DEV(ndev, &local_sdio_func->dev);
 			#endif
 
-			if (wdev == NULL) {
+			if (!wdev) {
 				PRINT_ER("Can't register WILC Wiphy\n");
 				return -1;
 			}
-- 
1.9.1

