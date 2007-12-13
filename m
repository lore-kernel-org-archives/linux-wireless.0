Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:55886 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762773AbXLMG7U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 01:59:20 -0500
Subject: [PATCH 55/48] libertas: make rtap and normal modes mutually exclusive, clean up open/stop
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J2i2W-0005rH-ML@shinybook.infradead.org> (sfid-20071213_065940_661323_32D883D3)
Date: Thu, 13 Dec 2007 01:59:24 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Mon, 10 Dec 2007 16:38:18 -0500

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/dev.h  |    1 -
 drivers/net/wireless/libertas/main.c |  133 +++++++++++++---------------------
 2 files changed, 50 insertions(+), 84 deletions(-)

diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index 4681405..9921d0c 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -99,7 +99,6 @@ struct lbs_mesh_stats {
 
 /** Private structure for the MV device */
 struct lbs_private {
-	int open;
 	int mesh_open;
 	int infra_open;
 	int mesh_autostart_enabled;
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 3d9de7a..8866402 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -274,6 +274,8 @@ static ssize_t lbs_rtap_set(struct device *dev,
 		if(priv->monitormode == monitor_mode)
 			return strlen(buf);
 		if (priv->monitormode == LBS_MONITOR_OFF) {
+			if (priv->infra_open || priv->mesh_open)
+				return -EBUSY;
 			if (priv->mode == IW_MODE_INFRA)
 				lbs_send_deauthentication(priv);
 			else if (priv->mode == IW_MODE_ADHOC)
@@ -367,84 +369,42 @@ static struct attribute_group lbs_mesh_attr_group = {
 };
 
 /**
- *  @brief This function opens the device
+ *  @brief This function opens the ethX or mshX interface
  *
  *  @param dev     A pointer to net_device structure
- *  @return 	   0
+ *  @return 	   0 or -EBUSY if monitor mode active
  */
 static int lbs_dev_open(struct net_device *dev)
 {
-	struct lbs_private *priv = (struct lbs_private *) dev->priv;
-
-	lbs_deb_enter(LBS_DEB_NET);
+	struct lbs_private *priv = (struct lbs_private *) dev->priv ;
+	int ret = 0;
 
-	priv->open = 1;
+	spin_lock_irq(&priv->driver_lock);
 
-	if (priv->connect_status == LBS_CONNECTED)
-		netif_carrier_on(priv->dev);
-	else
-		netif_carrier_off(priv->dev);
+	if (priv->monitormode != LBS_MONITOR_OFF) {
+		ret = -EBUSY;
+		goto out;
+	}
 
-	if (priv->mesh_dev) {
-		if (priv->mesh_connect_status == LBS_CONNECTED)
-			netif_carrier_on(priv->mesh_dev);
+	if (dev == priv->mesh_dev) {
+		priv->mesh_open = 1;
+		priv->mesh_connect_status = LBS_CONNECTED;
+		netif_carrier_on(dev);
+	} else {
+		priv->infra_open = 1;
+		
+		if (priv->connect_status == LBS_CONNECTED)
+			netif_carrier_on(dev);
 		else
-			netif_carrier_off(priv->mesh_dev);
+			netif_carrier_off(dev);
 	}
 
-	lbs_deb_leave(LBS_DEB_NET);
-	return 0;
-}
-/**
- *  @brief This function opens the mshX interface
- *
- *  @param dev     A pointer to net_device structure
- *  @return 	   0
- */
-static int lbs_mesh_open(struct net_device *dev)
-{
-	struct lbs_private *priv = (struct lbs_private *) dev->priv ;
-
-	priv->mesh_open = 1 ;
-	netif_wake_queue(priv->mesh_dev);
-
-	priv->mesh_connect_status = LBS_CONNECTED;
-
-	netif_carrier_on(priv->mesh_dev);
-	netif_wake_queue(priv->mesh_dev);
-	if (priv->infra_open == 0)
-		return lbs_dev_open(priv->dev) ;
-	return 0;
-}
-
-/**
- *  @brief This function opens the ethX interface
- *
- *  @param dev     A pointer to net_device structure
- *  @return 	   0
- */
-static int lbs_open(struct net_device *dev)
-{
-	struct lbs_private *priv = (struct lbs_private *) dev->priv ;
-
-	priv->infra_open = 1 ;
-	netif_wake_queue(priv->dev);
-	if (priv->open == 0)
-		return lbs_dev_open(priv->dev) ;
-	return 0;
-}
+	if (!priv->tx_pending_len)
+		netif_wake_queue(dev);
+ out:
 
-static int lbs_dev_close(struct net_device *dev)
-{
-	struct lbs_private *priv = dev->priv;
-
-	lbs_deb_enter(LBS_DEB_NET);
-
-	netif_carrier_off(priv->dev);
-	priv->open = 0;
-
-	lbs_deb_leave(LBS_DEB_NET);
-	return 0;
+	spin_unlock_irq(&priv->driver_lock);
+	return ret;
 }
 
 /**
@@ -453,16 +413,20 @@ static int lbs_dev_close(struct net_device *dev)
  *  @param dev     A pointer to net_device structure
  *  @return 	   0
  */
-static int lbs_mesh_close(struct net_device *dev)
+static int lbs_mesh_stop(struct net_device *dev)
 {
 	struct lbs_private *priv = (struct lbs_private *) (dev->priv);
 
+	spin_lock_irq(&priv->driver_lock);
+
 	priv->mesh_open = 0;
-	netif_stop_queue(priv->mesh_dev);
-	if (priv->infra_open == 0)
-		return lbs_dev_close(dev);
-	else
-		return 0;
+	priv->mesh_connect_status = LBS_DISCONNECTED;
+
+	netif_stop_queue(dev);
+	netif_carrier_off(dev);
+	
+	spin_unlock_irq(&priv->driver_lock);
+	return 0;
 }
 
 /**
@@ -471,16 +435,18 @@ static int lbs_mesh_close(struct net_device *dev)
  *  @param dev     A pointer to net_device structure
  *  @return 	   0
  */
-static int lbs_close(struct net_device *dev)
+static int lbs_eth_stop(struct net_device *dev)
 {
 	struct lbs_private *priv = (struct lbs_private *) dev->priv;
 
-	netif_stop_queue(dev);
+	spin_lock_irq(&priv->driver_lock);
+
 	priv->infra_open = 0;
-	if (priv->mesh_open == 0)
-		return lbs_dev_close(dev);
-	else
-		return 0;
+
+	netif_stop_queue(dev);
+	
+	spin_unlock_irq(&priv->driver_lock);
+	return 0;
 }
 
 static void lbs_tx_timeout(struct net_device *dev)
@@ -1065,9 +1031,9 @@ struct lbs_private *lbs_add_card(void *card, struct device *dmdev)
 	priv->infra_open = 0;
 
 	/* Setup the OS Interface to our functions */
-	dev->open = lbs_open;
+	dev->open = lbs_dev_open;
 	dev->hard_start_xmit = lbs_hard_start_xmit;
-	dev->stop = lbs_close;
+	dev->stop = lbs_eth_stop;
 	dev->set_mac_address = lbs_set_mac_address;
 	dev->tx_timeout = lbs_tx_timeout;
 	dev->get_stats = lbs_get_stats;
@@ -1237,9 +1203,9 @@ int lbs_add_mesh(struct lbs_private *priv, struct device *dev)
 	mesh_dev->priv = priv;
 	priv->mesh_dev = mesh_dev;
 
-	mesh_dev->open = lbs_mesh_open;
+	mesh_dev->open = lbs_dev_open;
 	mesh_dev->hard_start_xmit = lbs_hard_start_xmit;
-	mesh_dev->stop = lbs_mesh_close;
+	mesh_dev->stop = lbs_mesh_stop;
 	mesh_dev->get_stats = lbs_get_stats;
 	mesh_dev->set_mac_address = lbs_set_mac_address;
 	mesh_dev->ethtool_ops = &lbs_ethtool_ops;
@@ -1436,6 +1402,7 @@ static void __exit lbs_exit_module(void)
 
 static int lbs_rtap_open(struct net_device *dev)
 {
+	/* Yes, _stop_ the queue. Because we don't support injection */
         netif_carrier_off(dev);
         netif_stop_queue(dev);
         return 0;
@@ -1449,7 +1416,7 @@ static int lbs_rtap_stop(struct net_device *dev)
 static int lbs_rtap_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
         netif_stop_queue(dev);
-        return -EOPNOTSUPP;
+        return NETDEV_TX_BUSY;
 }
 
 static struct net_device_stats *lbs_rtap_get_stats(struct net_device *dev)
-- 
1.5.3.4

