Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:56827 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763408AbZE3Rh5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 May 2009 13:37:57 -0400
Received: by mail-ew0-f176.google.com with SMTP id 24so6938274ewy.37
        for <linux-wireless@vger.kernel.org>; Sat, 30 May 2009 10:37:59 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@googlemail.com>
Subject: [RFC v2 16/23] orinoco: move netdev interface creation to main driver
Date: Sat, 30 May 2009 18:36:50 +0100
Message-Id: <1243705017-8784-17-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1243705017-8784-1-git-send-email-kilroyd@googlemail.com>
References: <1243705017-8784-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the move to cfg80211 it's nice to keep the hardware operations
distinct from the interface, even though we can only support a single
interface.

This also means the driver resembles other cfg80211 drivers.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/airport.c        |   23 ++---
 drivers/net/wireless/orinoco/main.c           |  106 +++++++++++++++++-------
 drivers/net/wireless/orinoco/orinoco.h        |    4 +
 drivers/net/wireless/orinoco/orinoco_cs.c     |   21 ++----
 drivers/net/wireless/orinoco/orinoco_nortel.c |   14 +---
 drivers/net/wireless/orinoco/orinoco_pci.c    |   14 +---
 drivers/net/wireless/orinoco/orinoco_plx.c    |   14 +---
 drivers/net/wireless/orinoco/orinoco_tmd.c    |   14 +---
 drivers/net/wireless/orinoco/spectrum_cs.c    |   22 ++----
 9 files changed, 116 insertions(+), 116 deletions(-)

diff --git a/drivers/net/wireless/orinoco/airport.c b/drivers/net/wireless/orinoco/airport.c
index 9f90337..e46e0d7 100644
--- a/drivers/net/wireless/orinoco/airport.c
+++ b/drivers/net/wireless/orinoco/airport.c
@@ -116,7 +116,7 @@ airport_detach(struct macio_dev *mdev)
 	struct airport *card = priv->card;
 
 	if (card->ndev_registered)
-		unregister_netdev(dev);
+		orinoco_if_del(priv);
 	card->ndev_registered = 0;
 
 	if (card->irq_requested)
@@ -174,9 +174,9 @@ static int
 airport_attach(struct macio_dev *mdev, const struct of_device_id *match)
 {
 	struct orinoco_private *priv;
-	struct net_device *dev;
 	struct airport *card;
 	unsigned long phys_addr;
+	unsigned int irq;
 	hermes_t *hw;
 
 	if (macio_resource_count(mdev) < 1 || macio_irq_count(mdev) < 1) {
@@ -191,27 +191,23 @@ airport_attach(struct macio_dev *mdev, const struct of_device_id *match)
 		printk(KERN_ERR PFX "Cannot allocate network device\n");
 		return -ENODEV;
 	}
-	dev = priv->ndev;
 	card = priv->card;
 
 	hw = &priv->hw;
 	card->mdev = mdev;
 
-	if (macio_request_resource(mdev, 0, "airport")) {
+	if (macio_request_resource(mdev, 0, DRIVER_NAME)) {
 		printk(KERN_ERR PFX "can't request IO resource !\n");
 		free_orinocodev(priv);
 		return -EBUSY;
 	}
 
-	SET_NETDEV_DEV(dev, &mdev->ofdev.dev);
-
 	macio_set_drvdata(mdev, priv);
 
 	/* Setup interrupts & base address */
-	dev->irq = macio_irq(mdev, 0);
+	irq = macio_irq(mdev, 0);
 	phys_addr = macio_resource_start(mdev, 0);  /* Physical address */
 	printk(KERN_DEBUG PFX "Physical address %lx\n", phys_addr);
-	dev->base_addr = phys_addr;
 	card->vaddr = ioremap(phys_addr, AIRPORT_IO_LEN);
 	if (!card->vaddr) {
 		printk(KERN_ERR PFX "ioremap() failed\n");
@@ -228,8 +224,8 @@ airport_attach(struct macio_dev *mdev, const struct of_device_id *match)
 	/* Reset it before we get the interrupt */
 	hermes_init(hw);
 
-	if (request_irq(dev->irq, orinoco_interrupt, 0, dev->name, priv)) {
-		printk(KERN_ERR PFX "Couldn't get IRQ %d\n", dev->irq);
+	if (request_irq(irq, orinoco_interrupt, 0, DRIVER_NAME, priv)) {
+		printk(KERN_ERR PFX "Couldn't get IRQ %d\n", irq);
 		goto failed;
 	}
 	card->irq_requested = 1;
@@ -240,12 +236,11 @@ airport_attach(struct macio_dev *mdev, const struct of_device_id *match)
 		goto failed;
 	}
 
-	/* Tell the stack we exist */
-	if (register_netdev(dev) != 0) {
-		printk(KERN_ERR PFX "register_netdev() failed\n");
+	/* Register an interface with the stack */
+	if (orinoco_if_add(priv, phys_addr, irq) != 0) {
+		printk(KERN_ERR PFX "orinoco_if_add() failed\n");
 		goto failed;
 	}
-	printk(KERN_DEBUG PFX "Card registered for interface %s\n", dev->name);
 	card->ndev_registered = 1;
 	return 0;
  failed:
diff --git a/drivers/net/wireless/orinoco/main.c b/drivers/net/wireless/orinoco/main.c
index 5c1cf64..8218f44 100644
--- a/drivers/net/wireless/orinoco/main.c
+++ b/drivers/net/wireless/orinoco/main.c
@@ -1017,8 +1017,8 @@ static void orinoco_rx(struct net_device *dev,
 
 static void orinoco_rx_isr_tasklet(unsigned long data)
 {
-	struct net_device *dev = (struct net_device *) data;
-	struct orinoco_private *priv = ndev_priv(dev);
+	struct orinoco_private *priv = (struct orinoco_private *) data;
+	struct net_device *dev = priv->ndev;
 	struct orinoco_rx_data *rx_data, *temp;
 	struct hermes_rx_descriptor *desc;
 	struct sk_buff *skb;
@@ -2143,7 +2143,6 @@ int orinoco_init(struct orinoco_private *priv)
 	err = orinoco_hw_read_card_settings(priv, wiphy->perm_addr);
 	if (err)
 		goto out;
-	memcpy(priv->ndev->dev_addr, wiphy->perm_addr, ETH_ALEN);
 
 	err = orinoco_hw_allocate_fid(priv);
 	if (err) {
@@ -2226,9 +2225,7 @@ struct orinoco_private
 		  int (*hard_reset)(struct orinoco_private *),
 		  int (*stop_fw)(struct orinoco_private *, int))
 {
-	struct net_device *dev;
 	struct orinoco_private *priv;
-	struct wireless_dev *wdev;
 	struct wiphy *wiphy;
 
 	/* allocate wiphy
@@ -2240,43 +2237,20 @@ struct orinoco_private
 	if (!wiphy)
 		return NULL;
 
-	dev = alloc_etherdev(sizeof(struct wireless_dev));
-	if (!dev) {
-		wiphy_free(wiphy);
-		return NULL;
-	}
-
 	priv = wiphy_priv(wiphy);
-	priv->ndev = dev;
+	priv->dev = device;
 
 	if (sizeof_card)
 		priv->card = (void *)((unsigned long)priv
 				      + sizeof(struct orinoco_private));
 	else
 		priv->card = NULL;
-	priv->dev = device;
 
 	orinoco_wiphy_init(wiphy);
 
-	/* Initialise wireless_dev */
-	wdev = netdev_priv(dev);
-	wdev->wiphy = wiphy;
-	wdev->iftype = NL80211_IFTYPE_STATION;
-
-	/* Setup / override net_device fields */
-	dev->ieee80211_ptr = wdev;
-	dev->netdev_ops = &orinoco_netdev_ops;
-	dev->watchdog_timeo = HZ; /* 1 second timeout */
-	dev->ethtool_ops = &orinoco_ethtool_ops;
-	dev->wireless_handlers = &orinoco_handler_def;
 #ifdef WIRELESS_SPY
 	priv->wireless_data.spy_data = &priv->spy_data;
-	dev->wireless_data = &priv->wireless_data;
 #endif
-	/* we use the default eth_mac_addr for setting the MAC addr */
-
-	/* Reserve space in skb for the SNAP header */
-	dev->hard_header_len += ENCAPS_OVERHEAD;
 
 	/* Set up default callbacks */
 	priv->hard_reset = hard_reset;
@@ -2293,9 +2267,8 @@ struct orinoco_private
 
 	INIT_LIST_HEAD(&priv->rx_list);
 	tasklet_init(&priv->rx_tasklet, orinoco_rx_isr_tasklet,
-		     (unsigned long) dev);
+		     (unsigned long) priv);
 
-	netif_carrier_off(dev);
 	priv->last_linkstatus = 0xffff;
 
 #if defined(CONFIG_HERMES_CACHE_FW_ON_INIT) || defined(CONFIG_PM_SLEEP)
@@ -2310,6 +2283,77 @@ struct orinoco_private
 }
 EXPORT_SYMBOL(alloc_orinocodev);
 
+/* We can only support a single interface. We provide a separate
+ * function to set it up to distinguish between hardware
+ * initialisation and interface setup.
+ *
+ * The base_addr and irq parameters are passed on to netdev for use
+ * with SIOCGIFMAP.
+ */
+int orinoco_if_add(struct orinoco_private *priv,
+		   unsigned long base_addr,
+		   unsigned int irq)
+{
+	struct wiphy *wiphy = priv_to_wiphy(priv);
+	struct wireless_dev *wdev;
+	struct net_device *dev;
+	int ret;
+
+	dev = alloc_etherdev(sizeof(struct wireless_dev));
+
+	if (!dev)
+		return -ENOMEM;
+
+	/* Initialise wireless_dev */
+	wdev = netdev_priv(dev);
+	wdev->wiphy = wiphy;
+	wdev->iftype = NL80211_IFTYPE_STATION;
+
+	/* Setup / override net_device fields */
+	dev->ieee80211_ptr = wdev;
+	dev->netdev_ops = &orinoco_netdev_ops;
+	dev->watchdog_timeo = HZ; /* 1 second timeout */
+	dev->ethtool_ops = &orinoco_ethtool_ops;
+	dev->wireless_handlers = &orinoco_handler_def;
+#ifdef WIRELESS_SPY
+	dev->wireless_data = &priv->wireless_data;
+#endif
+	/* we use the default eth_mac_addr for setting the MAC addr */
+
+	/* Reserve space in skb for the SNAP header */
+	dev->hard_header_len += ENCAPS_OVERHEAD;
+
+	netif_carrier_off(dev);
+
+	memcpy(dev->dev_addr, wiphy->perm_addr, ETH_ALEN);
+
+	dev->base_addr = base_addr;
+	dev->irq = irq;
+
+	SET_NETDEV_DEV(dev, priv->dev);
+	ret = register_netdev(dev);
+	if (ret)
+		goto fail;
+
+	priv->ndev = dev;
+
+	/* Report what we've done */
+	dev_dbg(priv->dev, "Registerred interface %s.\n", dev->name);
+
+	return 0;
+
+ fail:
+	free_netdev(dev);
+	return ret;
+}
+EXPORT_SYMBOL(orinoco_if_add);
+
+void orinoco_if_del(struct orinoco_private *priv)
+{
+	unregister_netdev(priv->ndev);
+}
+EXPORT_SYMBOL(orinoco_if_del);
+
 void free_orinocodev(struct orinoco_private *priv)
 {
 	struct net_device *dev = priv->ndev;
diff --git a/drivers/net/wireless/orinoco/orinoco.h b/drivers/net/wireless/orinoco/orinoco.h
index 608cc5e..45aa616 100644
--- a/drivers/net/wireless/orinoco/orinoco.h
+++ b/drivers/net/wireless/orinoco/orinoco.h
@@ -193,6 +193,10 @@ extern struct orinoco_private *alloc_orinocodev(
 	int (*stop_fw)(struct orinoco_private *, int));
 extern void free_orinocodev(struct orinoco_private *priv);
 extern int orinoco_init(struct orinoco_private *priv);
+extern int orinoco_if_add(struct orinoco_private *priv,
+			  unsigned long base_addr,
+			  unsigned int irq);
+extern void orinoco_if_del(struct orinoco_private *priv);
 extern int __orinoco_up(struct orinoco_private *priv);
 extern int __orinoco_down(struct orinoco_private *priv);
 extern int orinoco_reinit_firmware(struct orinoco_private *priv);
diff --git a/drivers/net/wireless/orinoco/orinoco_cs.c b/drivers/net/wireless/orinoco/orinoco_cs.c
index 20abf02..4c29d36 100644
--- a/drivers/net/wireless/orinoco/orinoco_cs.c
+++ b/drivers/net/wireless/orinoco/orinoco_cs.c
@@ -147,7 +147,7 @@ static void orinoco_cs_detach(struct pcmcia_device *link)
 	struct orinoco_private *priv = link->priv;
 
 	if (link->dev_node)
-		unregister_netdev(priv->ndev);
+		orinoco_if_del(priv);
 
 	orinoco_cs_release(link);
 
@@ -239,7 +239,6 @@ orinoco_cs_config(struct pcmcia_device *link)
 {
 	struct orinoco_private *priv = link->priv;
 	struct orinoco_pccard *card = priv->card;
-	struct net_device *dev = priv->ndev;
 	hermes_t *hw = &priv->hw;
 	int last_fn, last_ret;
 	void __iomem *mem;
@@ -293,8 +292,6 @@ orinoco_cs_config(struct pcmcia_device *link)
 		 pcmcia_request_configuration(link, &link->conf));
 
 	/* Ok, we have the configuration, prepare to register the netdev */
-	dev->base_addr = link->io.BasePort1;
-	dev->irq = link->irq.AssignedIRQ;
 	card->node.major = card->node.minor = 0;
 
 	/* Initialise the main driver */
@@ -303,25 +300,19 @@ orinoco_cs_config(struct pcmcia_device *link)
 		goto failed;
 	}
 
-	SET_NETDEV_DEV(dev, &handle_to_dev(link));
-	/* Tell the stack we exist */
-	if (register_netdev(dev) != 0) {
-		printk(KERN_ERR PFX "register_netdev() failed\n");
+	/* Register an interface with the stack */
+	if (orinoco_if_add(priv, link->io.BasePort1,
+			   link->irq.AssignedIRQ) != 0) {
+		printk(KERN_ERR PFX "orinoco_if_add() failed\n");
 		goto failed;
 	}
 
 	/* At this point, the dev_node_t structure(s) needs to be
 	 * initialized and arranged in a linked list at link->dev_node. */
-	strcpy(card->node.dev_name, dev->name);
+	strcpy(card->node.dev_name, priv->ndev->name);
 	link->dev_node = &card->node; /* link->dev_node being non-NULL is also
 				       * used to indicate that the
 				       * net_device has been registered */
-
-	/* Finally, report what we've done */
-	printk(KERN_DEBUG "%s: " DRIVER_NAME " at %s, irq %d, io "
-	       "0x%04x-0x%04x\n", dev->name, dev_name(dev->dev.parent),
-	       link->irq.AssignedIRQ, link->io.BasePort1,
-	       link->io.BasePort1 + link->io.NumPorts1 - 1);
 	return 0;
 
  cs_failed:
diff --git a/drivers/net/wireless/orinoco/orinoco_nortel.c b/drivers/net/wireless/orinoco/orinoco_nortel.c
index 45cef81..c13a4c3 100644
--- a/drivers/net/wireless/orinoco/orinoco_nortel.c
+++ b/drivers/net/wireless/orinoco/orinoco_nortel.c
@@ -144,7 +144,6 @@ static int orinoco_nortel_init_one(struct pci_dev *pdev,
 	int err;
 	struct orinoco_private *priv;
 	struct orinoco_pci_card *card;
-	struct net_device *dev;
 	void __iomem *hermes_io, *bridge_io, *attr_io;
 
 	err = pci_enable_device(pdev);
@@ -189,16 +188,14 @@ static int orinoco_nortel_init_one(struct pci_dev *pdev,
 		goto fail_alloc;
 	}
 
-	dev = priv->ndev;
 	card = priv->card;
 	card->bridge_io = bridge_io;
 	card->attr_io = attr_io;
-	SET_NETDEV_DEV(dev, &pdev->dev);
 
 	hermes_struct_init(&priv->hw, hermes_io, HERMES_16BIT_REGSPACING);
 
 	err = request_irq(pdev->irq, orinoco_interrupt, IRQF_SHARED,
-			  dev->name, priv);
+			  DRIVER_NAME, priv);
 	if (err) {
 		printk(KERN_ERR PFX "Cannot allocate IRQ %d\n", pdev->irq);
 		err = -EBUSY;
@@ -223,15 +220,13 @@ static int orinoco_nortel_init_one(struct pci_dev *pdev,
 		goto fail;
 	}
 
-	err = register_netdev(dev);
+	err = orinoco_if_add(priv, 0, 0);
 	if (err) {
-		printk(KERN_ERR PFX "Cannot register network device\n");
+		printk(KERN_ERR PFX "orinoco_if_add() failed\n");
 		goto fail;
 	}
 
 	pci_set_drvdata(pdev, priv);
-	printk(KERN_DEBUG "%s: " DRIVER_NAME " at %s\n", dev->name,
-	       pci_name(pdev));
 
 	return 0;
 
@@ -263,13 +258,12 @@ static int orinoco_nortel_init_one(struct pci_dev *pdev,
 static void __devexit orinoco_nortel_remove_one(struct pci_dev *pdev)
 {
 	struct orinoco_private *priv = pci_get_drvdata(pdev);
-	struct net_device *dev = priv->ndev;
 	struct orinoco_pci_card *card = priv->card;
 
 	/* Clear LEDs */
 	iowrite16(0, card->bridge_io + 10);
 
-	unregister_netdev(dev);
+	orinoco_if_del(priv);
 	free_irq(pdev->irq, priv);
 	pci_set_drvdata(pdev, NULL);
 	free_orinocodev(priv);
diff --git a/drivers/net/wireless/orinoco/orinoco_pci.c b/drivers/net/wireless/orinoco/orinoco_pci.c
index d0eb4ae..fea7781 100644
--- a/drivers/net/wireless/orinoco/orinoco_pci.c
+++ b/drivers/net/wireless/orinoco/orinoco_pci.c
@@ -116,7 +116,6 @@ static int orinoco_pci_init_one(struct pci_dev *pdev,
 	int err;
 	struct orinoco_private *priv;
 	struct orinoco_pci_card *card;
-	struct net_device *dev;
 	void __iomem *hermes_io;
 
 	err = pci_enable_device(pdev);
@@ -147,14 +146,12 @@ static int orinoco_pci_init_one(struct pci_dev *pdev,
 		goto fail_alloc;
 	}
 
-	dev = priv->ndev;
 	card = priv->card;
-	SET_NETDEV_DEV(dev, &pdev->dev);
 
 	hermes_struct_init(&priv->hw, hermes_io, HERMES_32BIT_REGSPACING);
 
 	err = request_irq(pdev->irq, orinoco_interrupt, IRQF_SHARED,
-			  dev->name, priv);
+			  DRIVER_NAME, priv);
 	if (err) {
 		printk(KERN_ERR PFX "Cannot allocate IRQ %d\n", pdev->irq);
 		err = -EBUSY;
@@ -173,15 +170,13 @@ static int orinoco_pci_init_one(struct pci_dev *pdev,
 		goto fail;
 	}
 
-	err = register_netdev(dev);
+	err = orinoco_if_add(priv, 0, 0);
 	if (err) {
-		printk(KERN_ERR PFX "Cannot register network device\n");
+		printk(KERN_ERR PFX "orinoco_if_add() failed\n");
 		goto fail;
 	}
 
 	pci_set_drvdata(pdev, priv);
-	printk(KERN_DEBUG "%s: " DRIVER_NAME " at %s\n", dev->name,
-	       pci_name(pdev));
 
 	return 0;
 
@@ -207,9 +202,8 @@ static int orinoco_pci_init_one(struct pci_dev *pdev,
 static void __devexit orinoco_pci_remove_one(struct pci_dev *pdev)
 {
 	struct orinoco_private *priv = pci_get_drvdata(pdev);
-	struct net_device *dev = priv->ndev;
 
-	unregister_netdev(dev);
+	orinoco_if_del(priv);
 	free_irq(pdev->irq, priv);
 	pci_set_drvdata(pdev, NULL);
 	free_orinocodev(priv);
diff --git a/drivers/net/wireless/orinoco/orinoco_plx.c b/drivers/net/wireless/orinoco/orinoco_plx.c
index 8f225d0..3f2942a 100644
--- a/drivers/net/wireless/orinoco/orinoco_plx.c
+++ b/drivers/net/wireless/orinoco/orinoco_plx.c
@@ -183,7 +183,6 @@ static int orinoco_plx_init_one(struct pci_dev *pdev,
 	int err;
 	struct orinoco_private *priv;
 	struct orinoco_pci_card *card;
-	struct net_device *dev;
 	void __iomem *hermes_io, *attr_io, *bridge_io;
 
 	err = pci_enable_device(pdev);
@@ -228,16 +227,14 @@ static int orinoco_plx_init_one(struct pci_dev *pdev,
 		goto fail_alloc;
 	}
 
-	dev = priv->ndev;
 	card = priv->card;
 	card->bridge_io = bridge_io;
 	card->attr_io = attr_io;
-	SET_NETDEV_DEV(dev, &pdev->dev);
 
 	hermes_struct_init(&priv->hw, hermes_io, HERMES_16BIT_REGSPACING);
 
 	err = request_irq(pdev->irq, orinoco_interrupt, IRQF_SHARED,
-			  dev->name, priv);
+			  DRIVER_NAME, priv);
 	if (err) {
 		printk(KERN_ERR PFX "Cannot allocate IRQ %d\n", pdev->irq);
 		err = -EBUSY;
@@ -262,15 +259,13 @@ static int orinoco_plx_init_one(struct pci_dev *pdev,
 		goto fail;
 	}
 
-	err = register_netdev(dev);
+	err = orinoco_if_add(priv, 0, 0);
 	if (err) {
-		printk(KERN_ERR PFX "Cannot register network device\n");
+		printk(KERN_ERR PFX "orinoco_if_add() failed\n");
 		goto fail;
 	}
 
 	pci_set_drvdata(pdev, priv);
-	printk(KERN_DEBUG "%s: " DRIVER_NAME " at %s\n", dev->name,
-	       pci_name(pdev));
 
 	return 0;
 
@@ -302,10 +297,9 @@ static int orinoco_plx_init_one(struct pci_dev *pdev,
 static void __devexit orinoco_plx_remove_one(struct pci_dev *pdev)
 {
 	struct orinoco_private *priv = pci_get_drvdata(pdev);
-	struct net_device *dev = priv->ndev;
 	struct orinoco_pci_card *card = priv->card;
 
-	unregister_netdev(dev);
+	orinoco_if_del(priv);
 	free_irq(pdev->irq, priv);
 	pci_set_drvdata(pdev, NULL);
 	free_orinocodev(priv);
diff --git a/drivers/net/wireless/orinoco/orinoco_tmd.c b/drivers/net/wireless/orinoco/orinoco_tmd.c
index 3c04fae..d345254 100644
--- a/drivers/net/wireless/orinoco/orinoco_tmd.c
+++ b/drivers/net/wireless/orinoco/orinoco_tmd.c
@@ -94,7 +94,6 @@ static int orinoco_tmd_init_one(struct pci_dev *pdev,
 	int err;
 	struct orinoco_private *priv;
 	struct orinoco_pci_card *card;
-	struct net_device *dev;
 	void __iomem *hermes_io, *bridge_io;
 
 	err = pci_enable_device(pdev);
@@ -132,15 +131,13 @@ static int orinoco_tmd_init_one(struct pci_dev *pdev,
 		goto fail_alloc;
 	}
 
-	dev = priv->ndev;
 	card = priv->card;
 	card->bridge_io = bridge_io;
-	SET_NETDEV_DEV(dev, &pdev->dev);
 
 	hermes_struct_init(&priv->hw, hermes_io, HERMES_16BIT_REGSPACING);
 
 	err = request_irq(pdev->irq, orinoco_interrupt, IRQF_SHARED,
-			  dev->name, priv);
+			  DRIVER_NAME, priv);
 	if (err) {
 		printk(KERN_ERR PFX "Cannot allocate IRQ %d\n", pdev->irq);
 		err = -EBUSY;
@@ -159,15 +156,13 @@ static int orinoco_tmd_init_one(struct pci_dev *pdev,
 		goto fail;
 	}
 
-	err = register_netdev(dev);
+	err = orinoco_if_add(priv, 0, 0);
 	if (err) {
-		printk(KERN_ERR PFX "Cannot register network device\n");
+		printk(KERN_ERR PFX "orinoco_if_add() failed\n");
 		goto fail;
 	}
 
 	pci_set_drvdata(pdev, priv);
-	printk(KERN_DEBUG "%s: " DRIVER_NAME " at %s\n", dev->name,
-	       pci_name(pdev));
 
 	return 0;
 
@@ -196,10 +191,9 @@ static int orinoco_tmd_init_one(struct pci_dev *pdev,
 static void __devexit orinoco_tmd_remove_one(struct pci_dev *pdev)
 {
 	struct orinoco_private *priv = pci_get_drvdata(pdev);
-	struct net_device *dev = priv->ndev;
 	struct orinoco_pci_card *card = priv->card;
 
-	unregister_netdev(dev);
+	orinoco_if_del(priv);
 	free_irq(pdev->irq, priv);
 	pci_set_drvdata(pdev, NULL);
 	free_orinocodev(priv);
diff --git a/drivers/net/wireless/orinoco/spectrum_cs.c b/drivers/net/wireless/orinoco/spectrum_cs.c
index 43e1aed..7b4a7e4 100644
--- a/drivers/net/wireless/orinoco/spectrum_cs.c
+++ b/drivers/net/wireless/orinoco/spectrum_cs.c
@@ -220,7 +220,7 @@ static void spectrum_cs_detach(struct pcmcia_device *link)
 	struct orinoco_private *priv = link->priv;
 
 	if (link->dev_node)
-		unregister_netdev(priv->ndev);
+		orinoco_if_del(priv);
 
 	spectrum_cs_release(link);
 
@@ -306,7 +306,6 @@ spectrum_cs_config(struct pcmcia_device *link)
 {
 	struct orinoco_private *priv = link->priv;
 	struct orinoco_pccard *card = priv->card;
-	struct net_device *dev = priv->ndev;
 	hermes_t *hw = &priv->hw;
 	int last_fn, last_ret;
 	void __iomem *mem;
@@ -360,8 +359,6 @@ spectrum_cs_config(struct pcmcia_device *link)
 		 pcmcia_request_configuration(link, &link->conf));
 
 	/* Ok, we have the configuration, prepare to register the netdev */
-	dev->base_addr = link->io.BasePort1;
-	dev->irq = link->irq.AssignedIRQ;
 	card->node.major = card->node.minor = 0;
 
 	/* Reset card */
@@ -374,26 +371,19 @@ spectrum_cs_config(struct pcmcia_device *link)
 		goto failed;
 	}
 
-	SET_NETDEV_DEV(dev, &handle_to_dev(link));
-	/* Tell the stack we exist */
-	if (register_netdev(dev) != 0) {
-		printk(KERN_ERR PFX "register_netdev() failed\n");
+	/* Register an interface with the stack */
+	if (orinoco_if_add(priv, link->io.BasePort1,
+			   link->irq.AssignedIRQ) != 0) {
+		printk(KERN_ERR PFX "orinoco_if_add() failed\n");
 		goto failed;
 	}
 
 	/* At this point, the dev_node_t structure(s) needs to be
 	 * initialized and arranged in a linked list at link->dev_node. */
-	strcpy(card->node.dev_name, dev->name);
+	strcpy(card->node.dev_name, priv->ndev->name);
 	link->dev_node = &card->node; /* link->dev_node being non-NULL is also
 				       * used to indicate that the
 				       * net_device has been registered */
-
-	/* Finally, report what we've done */
-	printk(KERN_DEBUG "%s: " DRIVER_NAME " at %s, irq %d, io "
-	       "0x%04x-0x%04x\n", dev->name, dev_name(dev->dev.parent),
-	       link->irq.AssignedIRQ, link->io.BasePort1,
-	       link->io.BasePort1 + link->io.NumPorts1 - 1);
-
 	return 0;
 
  cs_failed:
-- 
1.6.0.6

