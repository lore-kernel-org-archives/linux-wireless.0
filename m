Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:16429 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566AbXIAEfl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2007 00:35:41 -0400
Received: from dv.roinet.com (static-72-92-88-10.phlapa.fios.verizon.net [72.92.88.10])
	by relay.cesmail.net (Postfix) with ESMTP id 0940C618FE1
	for <linux-wireless@vger.kernel.org>; Sat,  1 Sep 2007 00:35:41 -0400 (EDT)
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 15/35] Introduce at76_quiesce(),  use it to stop network activity
To: linux-wireless@vger.kernel.org
Date: Sat, 01 Sep 2007 00:35:40 -0400
Message-ID: <20070901043540.2498.64664.stgit@dv.roinet.com>
In-Reply-To: <20070901043233.2498.95850.stgit@dv.roinet.com>
References: <20070901043233.2498.95850.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |   76 ++++++++++++++-------------------------
 1 files changed, 27 insertions(+), 49 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index cabef24..5577606 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -1942,6 +1942,28 @@ static void at76_set_multicast(struct net_device *netdev)
 	}
 }
 
+/* Stop all network activity, flush all pending tasks */
+static void at76_quiesce(struct at76_priv *priv)
+{
+	unsigned long flags;
+
+	netif_stop_queue(priv->netdev);
+	netif_carrier_off(priv->netdev);
+
+	at76_set_mac_state(priv, MAC_INIT);
+
+	cancel_delayed_work(&priv->dwork_get_scan);
+	cancel_delayed_work(&priv->dwork_beacon);
+	cancel_delayed_work(&priv->dwork_auth);
+	cancel_delayed_work(&priv->dwork_assoc);
+	cancel_delayed_work(&priv->dwork_restart);
+
+	spin_lock_irqsave(&priv->mgmt_spinlock, flags);
+	kfree(priv->next_mgmt_bulk);
+	priv->next_mgmt_bulk = NULL;
+	spin_unlock_irqrestore(&priv->mgmt_spinlock, flags);
+}
+
 /*******************************************************************************
  * at76_priv implementations of iw_handler functions:
  */
@@ -1950,27 +1972,12 @@ static int at76_iw_handler_commit(struct net_device *netdev,
 				  void *null, char *extra)
 {
 	struct at76_priv *priv = netdev_priv(netdev);
-	unsigned long flags;
+
 	at76_dbg(DBG_IOCTL, "%s %s: restarting the device", netdev->name,
 		 __func__);
 
-	/* TODO: stop any pending tx bulk urb */
-	if (priv->mac_state != MAC_INIT) {
-		at76_set_mac_state(priv, MAC_INIT);
-		/* stop pending management stuff */
-		cancel_delayed_work(&priv->dwork_get_scan);
-		cancel_delayed_work(&priv->dwork_beacon);
-		cancel_delayed_work(&priv->dwork_auth);
-		cancel_delayed_work(&priv->dwork_assoc);
-
-		spin_lock_irqsave(&priv->mgmt_spinlock, flags);
-		kfree(priv->next_mgmt_bulk);
-		priv->next_mgmt_bulk = NULL;
-		spin_unlock_irqrestore(&priv->mgmt_spinlock, flags);
-
-		netif_carrier_off(priv->netdev);
-		netif_stop_queue(priv->netdev);
-	}
+	if (priv->mac_state != MAC_INIT)
+		at76_quiesce(priv);
 
 	/* Wait half second before the restart to process subsequent
 	 * requests from the same iwconfig in a single restart */
@@ -2293,7 +2300,6 @@ static int at76_iw_handler_set_scan(struct net_device *netdev,
 				    union iwreq_data *wrqu, char *extra)
 {
 	struct at76_priv *priv = netdev_priv(netdev);
-	unsigned long flags;
 	int ret = 0;
 
 	at76_dbg(DBG_IOCTL, "%s: SIOCSIWSCAN", netdev->name);
@@ -2317,22 +2323,8 @@ static int at76_iw_handler_set_scan(struct net_device *netdev,
 
 	priv->scan_state = SCAN_IN_PROGRESS;
 
-	/* stop pending management stuff */
-	cancel_delayed_work(&priv->dwork_get_scan);
-	cancel_delayed_work(&priv->dwork_beacon);
-	cancel_delayed_work(&priv->dwork_auth);
-	cancel_delayed_work(&priv->dwork_assoc);
-
-	spin_lock_irqsave(&priv->mgmt_spinlock, flags);
-	kfree(priv->next_mgmt_bulk);
-	priv->next_mgmt_bulk = NULL;
-	spin_unlock_irqrestore(&priv->mgmt_spinlock, flags);
+	at76_quiesce(priv);
 
-	if (netif_running(priv->netdev)) {
-		/* pause network activity */
-		netif_carrier_off(priv->netdev);
-		netif_stop_queue(priv->netdev);
-	}
 	/* Try to do passive or active scan if WE asks as. */
 	if (wrqu->data.length
 	    && wrqu->data.length == sizeof(struct iw_scan_req)) {
@@ -3465,17 +3457,14 @@ error:
 static int at76_stop(struct net_device *netdev)
 {
 	struct at76_priv *priv = netdev_priv(netdev);
-	unsigned long flags;
 
 	at76_dbg(DBG_DEVSTART, "%s: ENTER", __func__);
 
 	if (mutex_lock_interruptible(&priv->mtx))
 		return -EINTR;
 
-	netif_stop_queue(netdev);
-
-	at76_set_mac_state(priv, MAC_INIT);
 	tasklet_disable(&priv->rx_tasklet);
+	at76_quiesce(priv);
 
 	if (!priv->device_unplugged) {
 		/* We are called by "ifconfig ethX down", not because the
@@ -3487,17 +3476,6 @@ static int at76_stop(struct net_device *netdev)
 		usb_kill_urb(priv->rx_urb);
 	}
 
-	cancel_delayed_work(&priv->dwork_get_scan);
-	cancel_delayed_work(&priv->dwork_beacon);
-	cancel_delayed_work(&priv->dwork_auth);
-	cancel_delayed_work(&priv->dwork_assoc);
-	cancel_delayed_work(&priv->dwork_restart);
-
-	spin_lock_irqsave(&priv->mgmt_spinlock, flags);
-	kfree(priv->next_mgmt_bulk);
-	priv->next_mgmt_bulk = NULL;
-	spin_unlock_irqrestore(&priv->mgmt_spinlock, flags);
-
 	/* free the bss_list */
 	at76_free_bss_list(priv);
 
