Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:34085 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab0DSHgF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Apr 2010 03:36:05 -0400
Received: by mail-ww0-f46.google.com with SMTP id 24so2319543wwb.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Apr 2010 00:36:04 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@googlemail.com>
Subject: [RFC 2/5] orinoco: allow driver to specify netdev_ops
Date: Mon, 19 Apr 2010 08:35:19 +0100
Message-Id: <1271662522-29119-3-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1271662522-29119-1-git-send-email-kilroyd@googlemail.com>
References: <1271662522-29119-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow the main drivers to specify a custom version of the net_device_ops
structure. This is required by orinoco_usb to supply a separate transmit
function.

Export existing net_device_ops callbacks so that the drivers can reuse
some of the existing code.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/airport.c        |    2 +-
 drivers/net/wireless/orinoco/main.c           |   28 +++++++++++++++++-------
 drivers/net/wireless/orinoco/orinoco.h        |   11 +++++++++-
 drivers/net/wireless/orinoco/orinoco_cs.c     |    2 +-
 drivers/net/wireless/orinoco/orinoco_nortel.c |    2 +-
 drivers/net/wireless/orinoco/orinoco_pci.c    |    2 +-
 drivers/net/wireless/orinoco/orinoco_plx.c    |    2 +-
 drivers/net/wireless/orinoco/orinoco_tmd.c    |    2 +-
 drivers/net/wireless/orinoco/spectrum_cs.c    |    2 +-
 9 files changed, 37 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/orinoco/airport.c b/drivers/net/wireless/orinoco/airport.c
index ea23c4f..7dac5ad 100644
--- a/drivers/net/wireless/orinoco/airport.c
+++ b/drivers/net/wireless/orinoco/airport.c
@@ -210,7 +210,7 @@ airport_attach(struct macio_dev *mdev, const struct of_device_id *match)
 	}
 
 	/* Register an interface with the stack */
-	if (orinoco_if_add(priv, phys_addr, card->irq) != 0) {
+	if (orinoco_if_add(priv, phys_addr, card->irq, NULL) != 0) {
 		printk(KERN_ERR PFX "orinoco_if_add() failed\n");
 		goto failed;
 	}
diff --git a/drivers/net/wireless/orinoco/main.c b/drivers/net/wireless/orinoco/main.c
index 8c8009c..9dc458d 100644
--- a/drivers/net/wireless/orinoco/main.c
+++ b/drivers/net/wireless/orinoco/main.c
@@ -254,7 +254,7 @@ void set_port_type(struct orinoco_private *priv)
 /* Device methods                                                   */
 /********************************************************************/
 
-static int orinoco_open(struct net_device *dev)
+int orinoco_open(struct net_device *dev)
 {
 	struct orinoco_private *priv = ndev_priv(dev);
 	unsigned long flags;
@@ -272,8 +272,9 @@ static int orinoco_open(struct net_device *dev)
 
 	return err;
 }
+EXPORT_SYMBOL(orinoco_open);
 
-static int orinoco_stop(struct net_device *dev)
+int orinoco_stop(struct net_device *dev)
 {
 	struct orinoco_private *priv = ndev_priv(dev);
 	int err = 0;
@@ -291,15 +292,17 @@ static int orinoco_stop(struct net_device *dev)
 
 	return err;
 }
+EXPORT_SYMBOL(orinoco_stop);
 
-static struct net_device_stats *orinoco_get_stats(struct net_device *dev)
+struct net_device_stats *orinoco_get_stats(struct net_device *dev)
 {
 	struct orinoco_private *priv = ndev_priv(dev);
 
 	return &priv->stats;
 }
+EXPORT_SYMBOL(orinoco_get_stats);
 
-static void orinoco_set_multicast_list(struct net_device *dev)
+void orinoco_set_multicast_list(struct net_device *dev)
 {
 	struct orinoco_private *priv = ndev_priv(dev);
 	unsigned long flags;
@@ -313,8 +316,9 @@ static void orinoco_set_multicast_list(struct net_device *dev)
 	__orinoco_set_multicast_list(dev);
 	orinoco_unlock(priv, &flags);
 }
+EXPORT_SYMBOL(orinoco_set_multicast_list);
 
-static int orinoco_change_mtu(struct net_device *dev, int new_mtu)
+int orinoco_change_mtu(struct net_device *dev, int new_mtu)
 {
 	struct orinoco_private *priv = ndev_priv(dev);
 
@@ -330,6 +334,7 @@ static int orinoco_change_mtu(struct net_device *dev, int new_mtu)
 
 	return 0;
 }
+EXPORT_SYMBOL(orinoco_change_mtu);
 
 /********************************************************************/
 /* Tx path                                                          */
@@ -615,7 +620,7 @@ static void __orinoco_ev_txexc(struct net_device *dev, hermes_t *hw)
 	netif_wake_queue(dev);
 }
 
-static void orinoco_tx_timeout(struct net_device *dev)
+void orinoco_tx_timeout(struct net_device *dev)
 {
 	struct orinoco_private *priv = ndev_priv(dev);
 	struct net_device_stats *stats = &priv->stats;
@@ -630,6 +635,7 @@ static void orinoco_tx_timeout(struct net_device *dev)
 
 	schedule_work(&priv->reset_work);
 }
+EXPORT_SYMBOL(orinoco_tx_timeout);
 
 /********************************************************************/
 /* Rx path (data frames)                                            */
@@ -2193,7 +2199,8 @@ EXPORT_SYMBOL(alloc_orinocodev);
  */
 int orinoco_if_add(struct orinoco_private *priv,
 		   unsigned long base_addr,
-		   unsigned int irq)
+		   unsigned int irq,
+		   const struct net_device_ops *ops)
 {
 	struct wiphy *wiphy = priv_to_wiphy(priv);
 	struct wireless_dev *wdev;
@@ -2212,12 +2219,17 @@ int orinoco_if_add(struct orinoco_private *priv,
 
 	/* Setup / override net_device fields */
 	dev->ieee80211_ptr = wdev;
-	dev->netdev_ops = &orinoco_netdev_ops;
 	dev->watchdog_timeo = HZ; /* 1 second timeout */
 	dev->wireless_handlers = &orinoco_handler_def;
 #ifdef WIRELESS_SPY
 	dev->wireless_data = &priv->wireless_data;
 #endif
+	/* Default to standard ops if not set */
+	if (ops)
+		dev->netdev_ops = ops;
+	else
+		dev->netdev_ops = &orinoco_netdev_ops;
+
 	/* we use the default eth_mac_addr for setting the MAC addr */
 
 	/* Reserve space in skb for the SNAP header */
diff --git a/drivers/net/wireless/orinoco/orinoco.h b/drivers/net/wireless/orinoco/orinoco.h
index ff6b7b1..f1901d6 100644
--- a/drivers/net/wireless/orinoco/orinoco.h
+++ b/drivers/net/wireless/orinoco/orinoco.h
@@ -190,12 +190,21 @@ extern void free_orinocodev(struct orinoco_private *priv);
 extern int orinoco_init(struct orinoco_private *priv);
 extern int orinoco_if_add(struct orinoco_private *priv,
 			  unsigned long base_addr,
-			  unsigned int irq);
+			  unsigned int irq,
+			  const struct net_device_ops *ops);
 extern void orinoco_if_del(struct orinoco_private *priv);
 extern int orinoco_up(struct orinoco_private *priv);
 extern void orinoco_down(struct orinoco_private *priv);
 extern irqreturn_t orinoco_interrupt(int irq, void *dev_id);
 
+/* Common ndo functions exported for reuse by orinoco_usb */
+int orinoco_open(struct net_device *dev);
+int orinoco_stop(struct net_device *dev);
+struct net_device_stats *orinoco_get_stats(struct net_device *dev);
+void orinoco_set_multicast_list(struct net_device *dev);
+int orinoco_change_mtu(struct net_device *dev, int new_mtu);
+void orinoco_tx_timeout(struct net_device *dev);
+
 /********************************************************************/
 /* Locking and synchronization functions                            */
 /********************************************************************/
diff --git a/drivers/net/wireless/orinoco/orinoco_cs.c b/drivers/net/wireless/orinoco/orinoco_cs.c
index fdc9613..525f74e 100644
--- a/drivers/net/wireless/orinoco/orinoco_cs.c
+++ b/drivers/net/wireless/orinoco/orinoco_cs.c
@@ -296,7 +296,7 @@ orinoco_cs_config(struct pcmcia_device *link)
 
 	/* Register an interface with the stack */
 	if (orinoco_if_add(priv, link->io.BasePort1,
-			   link->irq.AssignedIRQ) != 0) {
+			   link->irq.AssignedIRQ, NULL) != 0) {
 		printk(KERN_ERR PFX "orinoco_if_add() failed\n");
 		goto failed;
 	}
diff --git a/drivers/net/wireless/orinoco/orinoco_nortel.c b/drivers/net/wireless/orinoco/orinoco_nortel.c
index 075f446..bc3ea0b 100644
--- a/drivers/net/wireless/orinoco/orinoco_nortel.c
+++ b/drivers/net/wireless/orinoco/orinoco_nortel.c
@@ -220,7 +220,7 @@ static int orinoco_nortel_init_one(struct pci_dev *pdev,
 		goto fail;
 	}
 
-	err = orinoco_if_add(priv, 0, 0);
+	err = orinoco_if_add(priv, 0, 0, NULL);
 	if (err) {
 		printk(KERN_ERR PFX "orinoco_if_add() failed\n");
 		goto fail;
diff --git a/drivers/net/wireless/orinoco/orinoco_pci.c b/drivers/net/wireless/orinoco/orinoco_pci.c
index bda5317..468197f 100644
--- a/drivers/net/wireless/orinoco/orinoco_pci.c
+++ b/drivers/net/wireless/orinoco/orinoco_pci.c
@@ -170,7 +170,7 @@ static int orinoco_pci_init_one(struct pci_dev *pdev,
 		goto fail;
 	}
 
-	err = orinoco_if_add(priv, 0, 0);
+	err = orinoco_if_add(priv, 0, 0, NULL);
 	if (err) {
 		printk(KERN_ERR PFX "orinoco_if_add() failed\n");
 		goto fail;
diff --git a/drivers/net/wireless/orinoco/orinoco_plx.c b/drivers/net/wireless/orinoco/orinoco_plx.c
index e0d5874..9358f4d 100644
--- a/drivers/net/wireless/orinoco/orinoco_plx.c
+++ b/drivers/net/wireless/orinoco/orinoco_plx.c
@@ -259,7 +259,7 @@ static int orinoco_plx_init_one(struct pci_dev *pdev,
 		goto fail;
 	}
 
-	err = orinoco_if_add(priv, 0, 0);
+	err = orinoco_if_add(priv, 0, 0, NULL);
 	if (err) {
 		printk(KERN_ERR PFX "orinoco_if_add() failed\n");
 		goto fail;
diff --git a/drivers/net/wireless/orinoco/orinoco_tmd.c b/drivers/net/wireless/orinoco/orinoco_tmd.c
index 88cbc79..784605f 100644
--- a/drivers/net/wireless/orinoco/orinoco_tmd.c
+++ b/drivers/net/wireless/orinoco/orinoco_tmd.c
@@ -156,7 +156,7 @@ static int orinoco_tmd_init_one(struct pci_dev *pdev,
 		goto fail;
 	}
 
-	err = orinoco_if_add(priv, 0, 0);
+	err = orinoco_if_add(priv, 0, 0, NULL);
 	if (err) {
 		printk(KERN_ERR PFX "orinoco_if_add() failed\n");
 		goto fail;
diff --git a/drivers/net/wireless/orinoco/spectrum_cs.c b/drivers/net/wireless/orinoco/spectrum_cs.c
index 59bda24..77b5871 100644
--- a/drivers/net/wireless/orinoco/spectrum_cs.c
+++ b/drivers/net/wireless/orinoco/spectrum_cs.c
@@ -374,7 +374,7 @@ spectrum_cs_config(struct pcmcia_device *link)
 
 	/* Register an interface with the stack */
 	if (orinoco_if_add(priv, link->io.BasePort1,
-			   link->irq.AssignedIRQ) != 0) {
+			   link->irq.AssignedIRQ, NULL) != 0) {
 		printk(KERN_ERR PFX "orinoco_if_add() failed\n");
 		goto failed;
 	}
-- 
1.6.4.4

