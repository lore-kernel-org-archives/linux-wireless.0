Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:56827 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763388AbZE3Rhk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 May 2009 13:37:40 -0400
Received: by mail-ew0-f176.google.com with SMTP id 24so6938274ewy.37
        for <linux-wireless@vger.kernel.org>; Sat, 30 May 2009 10:37:42 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@googlemail.com>
Subject: [RFC v2 11/23] orinoco: Replace net_device with orinoco_private in driver interfaces
Date: Sat, 30 May 2009 18:36:45 +0100
Message-Id: <1243705017-8784-12-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1243705017-8784-1-git-send-email-kilroyd@googlemail.com>
References: <1243705017-8784-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move away from using net_device as the main structure in orinoco
function calls. Use orinoco_private instead.

This makes more sense when we move to cfg80211, and we get wiphys as
well.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/airport.c        |   36 +++++++++++-----------
 drivers/net/wireless/orinoco/main.c           |   31 +++++++++----------
 drivers/net/wireless/orinoco/orinoco.h        |   10 +++---
 drivers/net/wireless/orinoco/orinoco_cs.c     |   39 +++++++++++-------------
 drivers/net/wireless/orinoco/orinoco_nortel.c |   24 +++++++-------
 drivers/net/wireless/orinoco/orinoco_pci.c    |   24 +++++++-------
 drivers/net/wireless/orinoco/orinoco_pci.h    |   18 +++++-----
 drivers/net/wireless/orinoco/orinoco_plx.c    |   24 +++++++-------
 drivers/net/wireless/orinoco/orinoco_tmd.c    |   24 +++++++-------
 drivers/net/wireless/orinoco/spectrum_cs.c    |   41 +++++++++++-------------
 10 files changed, 132 insertions(+), 139 deletions(-)

diff --git a/drivers/net/wireless/orinoco/airport.c b/drivers/net/wireless/orinoco/airport.c
index 8c4065f..6559aee 100644
--- a/drivers/net/wireless/orinoco/airport.c
+++ b/drivers/net/wireless/orinoco/airport.c
@@ -34,8 +34,8 @@ struct airport {
 static int
 airport_suspend(struct macio_dev *mdev, pm_message_t state)
 {
-	struct net_device *dev = dev_get_drvdata(&mdev->ofdev.dev);
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = dev_get_drvdata(&mdev->ofdev.dev);
+	struct net_device *dev = priv->ndev;
 	unsigned long flags;
 	int err;
 
@@ -48,7 +48,7 @@ airport_suspend(struct macio_dev *mdev, pm_message_t state)
 		return 0;
 	}
 
-	err = __orinoco_down(dev);
+	err = __orinoco_down(priv);
 	if (err)
 		printk(KERN_WARNING "%s: PBOOK_SLEEP_NOW: Error %d downing interface\n",
 		       dev->name, err);
@@ -69,8 +69,8 @@ airport_suspend(struct macio_dev *mdev, pm_message_t state)
 static int
 airport_resume(struct macio_dev *mdev)
 {
-	struct net_device *dev = dev_get_drvdata(&mdev->ofdev.dev);
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = dev_get_drvdata(&mdev->ofdev.dev);
+	struct net_device *dev = priv->ndev;
 	unsigned long flags;
 	int err;
 
@@ -82,7 +82,7 @@ airport_resume(struct macio_dev *mdev)
 
 	enable_irq(dev->irq);
 
-	err = orinoco_reinit_firmware(dev);
+	err = orinoco_reinit_firmware(priv);
 	if (err) {
 		printk(KERN_ERR "%s: Error %d re-initializing firmware on PBOOK_WAKE\n",
 		       dev->name, err);
@@ -96,7 +96,7 @@ airport_resume(struct macio_dev *mdev)
 	priv->hw_unavailable--;
 
 	if (priv->open && (!priv->hw_unavailable)) {
-		err = __orinoco_up(dev);
+		err = __orinoco_up(priv);
 		if (err)
 			printk(KERN_ERR "%s: Error %d restarting card on PBOOK_WAKE\n",
 			       dev->name, err);
@@ -111,8 +111,8 @@ airport_resume(struct macio_dev *mdev)
 static int
 airport_detach(struct macio_dev *mdev)
 {
-	struct net_device *dev = dev_get_drvdata(&mdev->ofdev.dev);
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = dev_get_drvdata(&mdev->ofdev.dev);
+	struct net_device *dev = priv->ndev;
 	struct airport *card = priv->card;
 
 	if (card->ndev_registered)
@@ -120,7 +120,7 @@ airport_detach(struct macio_dev *mdev)
 	card->ndev_registered = 0;
 
 	if (card->irq_requested)
-		free_irq(dev->irq, dev);
+		free_irq(dev->irq, priv);
 	card->irq_requested = 0;
 
 	if (card->vaddr)
@@ -134,7 +134,7 @@ airport_detach(struct macio_dev *mdev)
 	ssleep(1);
 
 	macio_set_drvdata(mdev, NULL);
-	free_orinocodev(dev);
+	free_orinocodev(priv);
 
 	return 0;
 }
@@ -185,13 +185,13 @@ airport_attach(struct macio_dev *mdev, const struct of_device_id *match)
 	}
 
 	/* Allocate space for private device-specific data */
-	dev = alloc_orinocodev(sizeof(*card), &mdev->ofdev.dev,
-			       airport_hard_reset, NULL);
-	if (!dev) {
+	priv = alloc_orinocodev(sizeof(*card), &mdev->ofdev.dev,
+				airport_hard_reset, NULL);
+	if (!priv) {
 		printk(KERN_ERR PFX "Cannot allocate network device\n");
 		return -ENODEV;
 	}
-	priv = netdev_priv(dev);
+	dev = priv->ndev;
 	card = priv->card;
 
 	hw = &priv->hw;
@@ -199,13 +199,13 @@ airport_attach(struct macio_dev *mdev, const struct of_device_id *match)
 
 	if (macio_request_resource(mdev, 0, "airport")) {
 		printk(KERN_ERR PFX "can't request IO resource !\n");
-		free_orinocodev(dev);
+		free_orinocodev(priv);
 		return -EBUSY;
 	}
 
 	SET_NETDEV_DEV(dev, &mdev->ofdev.dev);
 
-	macio_set_drvdata(mdev, dev);
+	macio_set_drvdata(mdev, priv);
 
 	/* Setup interrupts & base address */
 	dev->irq = macio_irq(mdev, 0);
@@ -228,7 +228,7 @@ airport_attach(struct macio_dev *mdev, const struct of_device_id *match)
 	/* Reset it before we get the interrupt */
 	hermes_init(hw);
 
-	if (request_irq(dev->irq, orinoco_interrupt, 0, dev->name, dev)) {
+	if (request_irq(dev->irq, orinoco_interrupt, 0, dev->name, priv)) {
 		printk(KERN_ERR PFX "Couldn't get IRQ %d\n", dev->irq);
 		goto failed;
 	}
diff --git a/drivers/net/wireless/orinoco/main.c b/drivers/net/wireless/orinoco/main.c
index 58a48db..4fa8264 100644
--- a/drivers/net/wireless/orinoco/main.c
+++ b/drivers/net/wireless/orinoco/main.c
@@ -252,7 +252,7 @@ static int orinoco_open(struct net_device *dev)
 	if (orinoco_lock(priv, &flags) != 0)
 		return -EBUSY;
 
-	err = __orinoco_up(dev);
+	err = __orinoco_up(priv);
 
 	if (!err)
 		priv->open = 1;
@@ -274,7 +274,7 @@ static int orinoco_stop(struct net_device *dev)
 
 	priv->open = 0;
 
-	err = __orinoco_down(dev);
+	err = __orinoco_down(priv);
 
 	spin_unlock_irq(&priv->lock);
 
@@ -1511,9 +1511,9 @@ static void __orinoco_ev_infdrop(struct net_device *dev, hermes_t *hw)
 /* Internal hardware control routines                               */
 /********************************************************************/
 
-int __orinoco_up(struct net_device *dev)
+int __orinoco_up(struct orinoco_private *priv)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct net_device *dev = priv->ndev;
 	struct hermes *hw = &priv->hw;
 	int err;
 
@@ -1541,9 +1541,9 @@ int __orinoco_up(struct net_device *dev)
 }
 EXPORT_SYMBOL(__orinoco_up);
 
-int __orinoco_down(struct net_device *dev)
+int __orinoco_down(struct orinoco_private *priv)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct net_device *dev = priv->ndev;
 	struct hermes *hw = &priv->hw;
 	int err;
 
@@ -1573,9 +1573,8 @@ int __orinoco_down(struct net_device *dev)
 }
 EXPORT_SYMBOL(__orinoco_down);
 
-int orinoco_reinit_firmware(struct net_device *dev)
+int orinoco_reinit_firmware(struct orinoco_private *priv)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
 	struct hermes *hw = &priv->hw;
 	int err;
 
@@ -1887,7 +1886,7 @@ void orinoco_reset(struct work_struct *work)
 		}
 	}
 
-	err = orinoco_reinit_firmware(dev);
+	err = orinoco_reinit_firmware(priv);
 	if (err) {
 		printk(KERN_ERR "%s: orinoco_reset: Error %d re-initializing firmware\n",
 		       dev->name, err);
@@ -1902,7 +1901,7 @@ void orinoco_reset(struct work_struct *work)
 	/* priv->open or priv->hw_unavailable might have changed while
 	 * we dropped the lock */
 	if (priv->open && (!priv->hw_unavailable)) {
-		err = __orinoco_up(dev);
+		err = __orinoco_up(priv);
 		if (err) {
 			printk(KERN_ERR "%s: orinoco_reset: Error %d reenabling card\n",
 			       dev->name, err);
@@ -1938,8 +1937,8 @@ static void __orinoco_ev_wterr(struct net_device *dev, hermes_t *hw)
 
 irqreturn_t orinoco_interrupt(int irq, void *dev_id)
 {
-	struct net_device *dev = dev_id;
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = dev_id;
+	struct net_device *dev = priv->ndev;
 	hermes_t *hw = &priv->hw;
 	int count = MAX_IRQLOOPS_PER_IRQ;
 	u16 evstat, events;
@@ -2192,7 +2191,7 @@ static const struct net_device_ops orinoco_netdev_ops = {
 	.ndo_get_stats		= orinoco_get_stats,
 };
 
-struct net_device
+struct orinoco_private
 *alloc_orinocodev(int sizeof_card,
 		  struct device *device,
 		  int (*hard_reset)(struct orinoco_private *),
@@ -2255,13 +2254,13 @@ struct net_device
 	/* Register PM notifiers */
 	orinoco_register_pm_notifier(priv);
 
-	return dev;
+	return priv;
 }
 EXPORT_SYMBOL(alloc_orinocodev);
 
-void free_orinocodev(struct net_device *dev)
+void free_orinocodev(struct orinoco_private *priv)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct net_device *dev = priv->ndev;
 	struct orinoco_rx_data *rx_data, *temp;
 
 	/* If the tasklet is scheduled when we call tasklet_kill it
diff --git a/drivers/net/wireless/orinoco/orinoco.h b/drivers/net/wireless/orinoco/orinoco.h
index 8e5a72c..b93e86c 100644
--- a/drivers/net/wireless/orinoco/orinoco.h
+++ b/drivers/net/wireless/orinoco/orinoco.h
@@ -182,14 +182,14 @@ extern int orinoco_debug;
 /* Exported prototypes                                              */
 /********************************************************************/
 
-extern struct net_device *alloc_orinocodev(
+extern struct orinoco_private *alloc_orinocodev(
 	int sizeof_card, struct device *device,
 	int (*hard_reset)(struct orinoco_private *),
 	int (*stop_fw)(struct orinoco_private *, int));
-extern void free_orinocodev(struct net_device *dev);
-extern int __orinoco_up(struct net_device *dev);
-extern int __orinoco_down(struct net_device *dev);
-extern int orinoco_reinit_firmware(struct net_device *dev);
+extern void free_orinocodev(struct orinoco_private *priv);
+extern int __orinoco_up(struct orinoco_private *priv);
+extern int __orinoco_down(struct orinoco_private *priv);
+extern int orinoco_reinit_firmware(struct orinoco_private *priv);
 extern irqreturn_t orinoco_interrupt(int irq, void *dev_id);
 
 /********************************************************************/
diff --git a/drivers/net/wireless/orinoco/orinoco_cs.c b/drivers/net/wireless/orinoco/orinoco_cs.c
index b381aed..fa8fe5b 100644
--- a/drivers/net/wireless/orinoco/orinoco_cs.c
+++ b/drivers/net/wireless/orinoco/orinoco_cs.c
@@ -106,26 +106,24 @@ orinoco_cs_hard_reset(struct orinoco_private *priv)
 static int
 orinoco_cs_probe(struct pcmcia_device *link)
 {
-	struct net_device *dev;
 	struct orinoco_private *priv;
 	struct orinoco_pccard *card;
 
-	dev = alloc_orinocodev(sizeof(*card), &handle_to_dev(link),
-			       orinoco_cs_hard_reset, NULL);
-	if (!dev)
+	priv = alloc_orinocodev(sizeof(*card), &handle_to_dev(link),
+				orinoco_cs_hard_reset, NULL);
+	if (!priv)
 		return -ENOMEM;
-	priv = netdev_priv(dev);
 	card = priv->card;
 
 	/* Link both structures together */
 	card->p_dev = link;
-	link->priv = dev;
+	link->priv = priv;
 
 	/* Interrupt setup */
 	link->irq.Attributes = IRQ_TYPE_DYNAMIC_SHARING | IRQ_HANDLE_PRESENT;
 	link->irq.IRQInfo1 = IRQ_LEVEL_ID;
 	link->irq.Handler = orinoco_interrupt;
-	link->irq.Instance = dev;
+	link->irq.Instance = priv;
 
 	/* General socket configuration defaults can go here.  In this
 	 * client, we assume very little, and rely on the CIS for
@@ -146,14 +144,14 @@ orinoco_cs_probe(struct pcmcia_device *link)
  */
 static void orinoco_cs_detach(struct pcmcia_device *link)
 {
-	struct net_device *dev = link->priv;
+	struct orinoco_private *priv = link->priv;
 
 	if (link->dev_node)
-		unregister_netdev(dev);
+		unregister_netdev(priv->ndev);
 
 	orinoco_cs_release(link);
 
-	free_orinocodev(dev);
+	free_orinocodev(priv);
 }				/* orinoco_cs_detach */
 
 /*
@@ -239,9 +237,9 @@ next_entry:
 static int
 orinoco_cs_config(struct pcmcia_device *link)
 {
-	struct net_device *dev = link->priv;
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = link->priv;
 	struct orinoco_pccard *card = priv->card;
+	struct net_device *dev = priv->ndev;
 	hermes_t *hw = &priv->hw;
 	int last_fn, last_ret;
 	void __iomem *mem;
@@ -336,8 +334,7 @@ orinoco_cs_config(struct pcmcia_device *link)
 static void
 orinoco_cs_release(struct pcmcia_device *link)
 {
-	struct net_device *dev = link->priv;
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = link->priv;
 	unsigned long flags;
 
 	/* We're committed to taking the device away now, so mark the
@@ -353,9 +350,9 @@ orinoco_cs_release(struct pcmcia_device *link)
 
 static int orinoco_cs_suspend(struct pcmcia_device *link)
 {
-	struct net_device *dev = link->priv;
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = link->priv;
 	struct orinoco_pccard *card = priv->card;
+	struct net_device *dev = priv->ndev;
 	int err = 0;
 	unsigned long flags;
 
@@ -365,7 +362,7 @@ static int orinoco_cs_suspend(struct pcmcia_device *link)
 	if (!test_bit(0, &card->hard_reset_in_progress)) {
 		spin_lock_irqsave(&priv->lock, flags);
 
-		err = __orinoco_down(dev);
+		err = __orinoco_down(priv);
 		if (err)
 			printk(KERN_WARNING "%s: Error %d downing interface\n",
 			       dev->name, err);
@@ -381,14 +378,14 @@ static int orinoco_cs_suspend(struct pcmcia_device *link)
 
 static int orinoco_cs_resume(struct pcmcia_device *link)
 {
-	struct net_device *dev = link->priv;
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = link->priv;
 	struct orinoco_pccard *card = priv->card;
+	struct net_device *dev = priv->ndev;
 	int err = 0;
 	unsigned long flags;
 
 	if (!test_bit(0, &card->hard_reset_in_progress)) {
-		err = orinoco_reinit_firmware(dev);
+		err = orinoco_reinit_firmware(priv);
 		if (err) {
 			printk(KERN_ERR "%s: Error %d re-initializing firmware\n",
 			       dev->name, err);
@@ -401,7 +398,7 @@ static int orinoco_cs_resume(struct pcmcia_device *link)
 		priv->hw_unavailable--;
 
 		if (priv->open && !priv->hw_unavailable) {
-			err = __orinoco_up(dev);
+			err = __orinoco_up(priv);
 			if (err)
 				printk(KERN_ERR "%s: Error %d restarting card\n",
 				       dev->name, err);
diff --git a/drivers/net/wireless/orinoco/orinoco_nortel.c b/drivers/net/wireless/orinoco/orinoco_nortel.c
index b017262..4efd5a0 100644
--- a/drivers/net/wireless/orinoco/orinoco_nortel.c
+++ b/drivers/net/wireless/orinoco/orinoco_nortel.c
@@ -181,15 +181,15 @@ static int orinoco_nortel_init_one(struct pci_dev *pdev,
 	}
 
 	/* Allocate network device */
-	dev = alloc_orinocodev(sizeof(*card), &pdev->dev,
-			       orinoco_nortel_cor_reset, NULL);
-	if (!dev) {
+	priv = alloc_orinocodev(sizeof(*card), &pdev->dev,
+				orinoco_nortel_cor_reset, NULL);
+	if (!priv) {
 		printk(KERN_ERR PFX "Cannot allocate network device\n");
 		err = -ENOMEM;
 		goto fail_alloc;
 	}
 
-	priv = netdev_priv(dev);
+	dev = priv->ndev;
 	card = priv->card;
 	card->bridge_io = bridge_io;
 	card->attr_io = attr_io;
@@ -198,7 +198,7 @@ static int orinoco_nortel_init_one(struct pci_dev *pdev,
 	hermes_struct_init(&priv->hw, hermes_io, HERMES_16BIT_REGSPACING);
 
 	err = request_irq(pdev->irq, orinoco_interrupt, IRQF_SHARED,
-			  dev->name, dev);
+			  dev->name, priv);
 	if (err) {
 		printk(KERN_ERR PFX "Cannot allocate IRQ %d\n", pdev->irq);
 		err = -EBUSY;
@@ -223,18 +223,18 @@ static int orinoco_nortel_init_one(struct pci_dev *pdev,
 		goto fail;
 	}
 
-	pci_set_drvdata(pdev, dev);
+	pci_set_drvdata(pdev, priv);
 	printk(KERN_DEBUG "%s: " DRIVER_NAME " at %s\n", dev->name,
 	       pci_name(pdev));
 
 	return 0;
 
  fail:
-	free_irq(pdev->irq, dev);
+	free_irq(pdev->irq, priv);
 
  fail_irq:
 	pci_set_drvdata(pdev, NULL);
-	free_orinocodev(dev);
+	free_orinocodev(priv);
 
  fail_alloc:
 	pci_iounmap(pdev, hermes_io);
@@ -256,17 +256,17 @@ static int orinoco_nortel_init_one(struct pci_dev *pdev,
 
 static void __devexit orinoco_nortel_remove_one(struct pci_dev *pdev)
 {
-	struct net_device *dev = pci_get_drvdata(pdev);
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = pci_get_drvdata(pdev);
+	struct net_device *dev = priv->ndev;
 	struct orinoco_pci_card *card = priv->card;
 
 	/* Clear LEDs */
 	iowrite16(0, card->bridge_io + 10);
 
 	unregister_netdev(dev);
-	free_irq(pdev->irq, dev);
+	free_irq(pdev->irq, priv);
 	pci_set_drvdata(pdev, NULL);
-	free_orinocodev(dev);
+	free_orinocodev(priv);
 	pci_iounmap(pdev, priv->hw.iobase);
 	pci_iounmap(pdev, card->attr_io);
 	pci_iounmap(pdev, card->bridge_io);
diff --git a/drivers/net/wireless/orinoco/orinoco_pci.c b/drivers/net/wireless/orinoco/orinoco_pci.c
index 78cafff..12b9c6a 100644
--- a/drivers/net/wireless/orinoco/orinoco_pci.c
+++ b/drivers/net/wireless/orinoco/orinoco_pci.c
@@ -139,22 +139,22 @@ static int orinoco_pci_init_one(struct pci_dev *pdev,
 	}
 
 	/* Allocate network device */
-	dev = alloc_orinocodev(sizeof(*card), &pdev->dev,
-			       orinoco_pci_cor_reset, NULL);
-	if (!dev) {
+	priv = alloc_orinocodev(sizeof(*card), &pdev->dev,
+				orinoco_pci_cor_reset, NULL);
+	if (!priv) {
 		printk(KERN_ERR PFX "Cannot allocate network device\n");
 		err = -ENOMEM;
 		goto fail_alloc;
 	}
 
-	priv = netdev_priv(dev);
+	dev = priv->ndev;
 	card = priv->card;
 	SET_NETDEV_DEV(dev, &pdev->dev);
 
 	hermes_struct_init(&priv->hw, hermes_io, HERMES_32BIT_REGSPACING);
 
 	err = request_irq(pdev->irq, orinoco_interrupt, IRQF_SHARED,
-			  dev->name, dev);
+			  dev->name, priv);
 	if (err) {
 		printk(KERN_ERR PFX "Cannot allocate IRQ %d\n", pdev->irq);
 		err = -EBUSY;
@@ -173,18 +173,18 @@ static int orinoco_pci_init_one(struct pci_dev *pdev,
 		goto fail;
 	}
 
-	pci_set_drvdata(pdev, dev);
+	pci_set_drvdata(pdev, priv);
 	printk(KERN_DEBUG "%s: " DRIVER_NAME " at %s\n", dev->name,
 	       pci_name(pdev));
 
 	return 0;
 
  fail:
-	free_irq(pdev->irq, dev);
+	free_irq(pdev->irq, priv);
 
  fail_irq:
 	pci_set_drvdata(pdev, NULL);
-	free_orinocodev(dev);
+	free_orinocodev(priv);
 
  fail_alloc:
 	pci_iounmap(pdev, hermes_io);
@@ -200,13 +200,13 @@ static int orinoco_pci_init_one(struct pci_dev *pdev,
 
 static void __devexit orinoco_pci_remove_one(struct pci_dev *pdev)
 {
-	struct net_device *dev = pci_get_drvdata(pdev);
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = pci_get_drvdata(pdev);
+	struct net_device *dev = priv->ndev;
 
 	unregister_netdev(dev);
-	free_irq(pdev->irq, dev);
+	free_irq(pdev->irq, priv);
 	pci_set_drvdata(pdev, NULL);
-	free_orinocodev(dev);
+	free_orinocodev(priv);
 	pci_iounmap(pdev, priv->hw.iobase);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
diff --git a/drivers/net/wireless/orinoco/orinoco_pci.h b/drivers/net/wireless/orinoco/orinoco_pci.h
index c655b4a..22aa630 100644
--- a/drivers/net/wireless/orinoco/orinoco_pci.h
+++ b/drivers/net/wireless/orinoco/orinoco_pci.h
@@ -21,8 +21,8 @@ struct orinoco_pci_card {
 #ifdef CONFIG_PM
 static int orinoco_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 {
-	struct net_device *dev = pci_get_drvdata(pdev);
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = pci_get_drvdata(pdev);
+	struct net_device *dev = priv->ndev;
 	unsigned long flags;
 	int err;
 
@@ -33,7 +33,7 @@ static int orinoco_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 		return err;
 	}
 
-	err = __orinoco_down(dev);
+	err = __orinoco_down(priv);
 	if (err)
 		printk(KERN_WARNING "%s: error %d bringing interface down "
 		       "for suspend\n", dev->name, err);
@@ -44,7 +44,7 @@ static int orinoco_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 
 	orinoco_unlock(priv, &flags);
 
-	free_irq(pdev->irq, dev);
+	free_irq(pdev->irq, priv);
 	pci_save_state(pdev);
 	pci_disable_device(pdev);
 	pci_set_power_state(pdev, PCI_D3hot);
@@ -54,8 +54,8 @@ static int orinoco_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 
 static int orinoco_pci_resume(struct pci_dev *pdev)
 {
-	struct net_device *dev = pci_get_drvdata(pdev);
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = pci_get_drvdata(pdev);
+	struct net_device *dev = priv->ndev;
 	unsigned long flags;
 	int err;
 
@@ -69,7 +69,7 @@ static int orinoco_pci_resume(struct pci_dev *pdev)
 	pci_restore_state(pdev);
 
 	err = request_irq(pdev->irq, orinoco_interrupt, IRQF_SHARED,
-			  dev->name, dev);
+			  dev->name, priv);
 	if (err) {
 		printk(KERN_ERR "%s: cannot re-allocate IRQ on resume\n",
 		       dev->name);
@@ -77,7 +77,7 @@ static int orinoco_pci_resume(struct pci_dev *pdev)
 		return -EBUSY;
 	}
 
-	err = orinoco_reinit_firmware(dev);
+	err = orinoco_reinit_firmware(priv);
 	if (err) {
 		printk(KERN_ERR "%s: error %d re-initializing firmware "
 		       "on resume\n", dev->name, err);
@@ -91,7 +91,7 @@ static int orinoco_pci_resume(struct pci_dev *pdev)
 	priv->hw_unavailable--;
 
 	if (priv->open && (!priv->hw_unavailable)) {
-		err = __orinoco_up(dev);
+		err = __orinoco_up(priv);
 		if (err)
 			printk(KERN_ERR "%s: Error %d restarting card on resume\n",
 			       dev->name, err);
diff --git a/drivers/net/wireless/orinoco/orinoco_plx.c b/drivers/net/wireless/orinoco/orinoco_plx.c
index a2a4471..77d5668 100644
--- a/drivers/net/wireless/orinoco/orinoco_plx.c
+++ b/drivers/net/wireless/orinoco/orinoco_plx.c
@@ -220,15 +220,15 @@ static int orinoco_plx_init_one(struct pci_dev *pdev,
 	}
 
 	/* Allocate network device */
-	dev = alloc_orinocodev(sizeof(*card), &pdev->dev,
-			       orinoco_plx_cor_reset, NULL);
-	if (!dev) {
+	priv = alloc_orinocodev(sizeof(*card), &pdev->dev,
+				orinoco_plx_cor_reset, NULL);
+	if (!priv) {
 		printk(KERN_ERR PFX "Cannot allocate network device\n");
 		err = -ENOMEM;
 		goto fail_alloc;
 	}
 
-	priv = netdev_priv(dev);
+	dev = priv->ndev;
 	card = priv->card;
 	card->bridge_io = bridge_io;
 	card->attr_io = attr_io;
@@ -237,7 +237,7 @@ static int orinoco_plx_init_one(struct pci_dev *pdev,
 	hermes_struct_init(&priv->hw, hermes_io, HERMES_16BIT_REGSPACING);
 
 	err = request_irq(pdev->irq, orinoco_interrupt, IRQF_SHARED,
-			  dev->name, dev);
+			  dev->name, priv);
 	if (err) {
 		printk(KERN_ERR PFX "Cannot allocate IRQ %d\n", pdev->irq);
 		err = -EBUSY;
@@ -262,18 +262,18 @@ static int orinoco_plx_init_one(struct pci_dev *pdev,
 		goto fail;
 	}
 
-	pci_set_drvdata(pdev, dev);
+	pci_set_drvdata(pdev, priv);
 	printk(KERN_DEBUG "%s: " DRIVER_NAME " at %s\n", dev->name,
 	       pci_name(pdev));
 
 	return 0;
 
  fail:
-	free_irq(pdev->irq, dev);
+	free_irq(pdev->irq, priv);
 
  fail_irq:
 	pci_set_drvdata(pdev, NULL);
-	free_orinocodev(dev);
+	free_orinocodev(priv);
 
  fail_alloc:
 	pci_iounmap(pdev, hermes_io);
@@ -295,14 +295,14 @@ static int orinoco_plx_init_one(struct pci_dev *pdev,
 
 static void __devexit orinoco_plx_remove_one(struct pci_dev *pdev)
 {
-	struct net_device *dev = pci_get_drvdata(pdev);
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = pci_get_drvdata(pdev);
+	struct net_device *dev = priv->ndev;
 	struct orinoco_pci_card *card = priv->card;
 
 	unregister_netdev(dev);
-	free_irq(pdev->irq, dev);
+	free_irq(pdev->irq, priv);
 	pci_set_drvdata(pdev, NULL);
-	free_orinocodev(dev);
+	free_orinocodev(priv);
 	pci_iounmap(pdev, priv->hw.iobase);
 	pci_iounmap(pdev, card->attr_io);
 	pci_iounmap(pdev, card->bridge_io);
diff --git a/drivers/net/wireless/orinoco/orinoco_tmd.c b/drivers/net/wireless/orinoco/orinoco_tmd.c
index cda0e6e..5f24c03 100644
--- a/drivers/net/wireless/orinoco/orinoco_tmd.c
+++ b/drivers/net/wireless/orinoco/orinoco_tmd.c
@@ -124,15 +124,15 @@ static int orinoco_tmd_init_one(struct pci_dev *pdev,
 	}
 
 	/* Allocate network device */
-	dev = alloc_orinocodev(sizeof(*card), &pdev->dev,
-			       orinoco_tmd_cor_reset, NULL);
-	if (!dev) {
+	priv = alloc_orinocodev(sizeof(*card), &pdev->dev,
+				orinoco_tmd_cor_reset, NULL);
+	if (!priv) {
 		printk(KERN_ERR PFX "Cannot allocate network device\n");
 		err = -ENOMEM;
 		goto fail_alloc;
 	}
 
-	priv = netdev_priv(dev);
+	dev = priv->ndev;
 	card = priv->card;
 	card->bridge_io = bridge_io;
 	SET_NETDEV_DEV(dev, &pdev->dev);
@@ -140,7 +140,7 @@ static int orinoco_tmd_init_one(struct pci_dev *pdev,
 	hermes_struct_init(&priv->hw, hermes_io, HERMES_16BIT_REGSPACING);
 
 	err = request_irq(pdev->irq, orinoco_interrupt, IRQF_SHARED,
-			  dev->name, dev);
+			  dev->name, priv);
 	if (err) {
 		printk(KERN_ERR PFX "Cannot allocate IRQ %d\n", pdev->irq);
 		err = -EBUSY;
@@ -159,18 +159,18 @@ static int orinoco_tmd_init_one(struct pci_dev *pdev,
 		goto fail;
 	}
 
-	pci_set_drvdata(pdev, dev);
+	pci_set_drvdata(pdev, priv);
 	printk(KERN_DEBUG "%s: " DRIVER_NAME " at %s\n", dev->name,
 	       pci_name(pdev));
 
 	return 0;
 
  fail:
-	free_irq(pdev->irq, dev);
+	free_irq(pdev->irq, priv);
 
  fail_irq:
 	pci_set_drvdata(pdev, NULL);
-	free_orinocodev(dev);
+	free_orinocodev(priv);
 
  fail_alloc:
 	pci_iounmap(pdev, hermes_io);
@@ -189,14 +189,14 @@ static int orinoco_tmd_init_one(struct pci_dev *pdev,
 
 static void __devexit orinoco_tmd_remove_one(struct pci_dev *pdev)
 {
-	struct net_device *dev = pci_get_drvdata(pdev);
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = pci_get_drvdata(pdev);
+	struct net_device *dev = priv->ndev;
 	struct orinoco_pci_card *card = priv->card;
 
 	unregister_netdev(dev);
-	free_irq(pdev->irq, dev);
+	free_irq(pdev->irq, priv);
 	pci_set_drvdata(pdev, NULL);
-	free_orinocodev(dev);
+	free_orinocodev(priv);
 	pci_iounmap(pdev, priv->hw.iobase);
 	pci_iounmap(pdev, card->bridge_io);
 	pci_release_regions(pdev);
diff --git a/drivers/net/wireless/orinoco/spectrum_cs.c b/drivers/net/wireless/orinoco/spectrum_cs.c
index 38e5198..ce909e4 100644
--- a/drivers/net/wireless/orinoco/spectrum_cs.c
+++ b/drivers/net/wireless/orinoco/spectrum_cs.c
@@ -178,27 +178,25 @@ spectrum_cs_stop_firmware(struct orinoco_private *priv, int idle)
 static int
 spectrum_cs_probe(struct pcmcia_device *link)
 {
-	struct net_device *dev;
 	struct orinoco_private *priv;
 	struct orinoco_pccard *card;
 
-	dev = alloc_orinocodev(sizeof(*card), &handle_to_dev(link),
-			       spectrum_cs_hard_reset,
-			       spectrum_cs_stop_firmware);
-	if (!dev)
+	priv = alloc_orinocodev(sizeof(*card), &handle_to_dev(link),
+				spectrum_cs_hard_reset,
+				spectrum_cs_stop_firmware);
+	if (!priv)
 		return -ENOMEM;
-	priv = netdev_priv(dev);
 	card = priv->card;
 
 	/* Link both structures together */
 	card->p_dev = link;
-	link->priv = dev;
+	link->priv = priv;
 
 	/* Interrupt setup */
 	link->irq.Attributes = IRQ_TYPE_DYNAMIC_SHARING | IRQ_HANDLE_PRESENT;
 	link->irq.IRQInfo1 = IRQ_LEVEL_ID;
 	link->irq.Handler = orinoco_interrupt;
-	link->irq.Instance = dev;
+	link->irq.Instance = priv;
 
 	/* General socket configuration defaults can go here.  In this
 	 * client, we assume very little, and rely on the CIS for
@@ -219,14 +217,14 @@ spectrum_cs_probe(struct pcmcia_device *link)
  */
 static void spectrum_cs_detach(struct pcmcia_device *link)
 {
-	struct net_device *dev = link->priv;
+	struct orinoco_private *priv = link->priv;
 
 	if (link->dev_node)
-		unregister_netdev(dev);
+		unregister_netdev(priv->ndev);
 
 	spectrum_cs_release(link);
 
-	free_orinocodev(dev);
+	free_orinocodev(priv);
 }				/* spectrum_cs_detach */
 
 /*
@@ -306,9 +304,9 @@ next_entry:
 static int
 spectrum_cs_config(struct pcmcia_device *link)
 {
-	struct net_device *dev = link->priv;
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = link->priv;
 	struct orinoco_pccard *card = priv->card;
+	struct net_device *dev = priv->ndev;
 	hermes_t *hw = &priv->hw;
 	int last_fn, last_ret;
 	void __iomem *mem;
@@ -408,8 +406,7 @@ spectrum_cs_config(struct pcmcia_device *link)
 static void
 spectrum_cs_release(struct pcmcia_device *link)
 {
-	struct net_device *dev = link->priv;
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = link->priv;
 	unsigned long flags;
 
 	/* We're committed to taking the device away now, so mark the
@@ -427,15 +424,15 @@ spectrum_cs_release(struct pcmcia_device *link)
 static int
 spectrum_cs_suspend(struct pcmcia_device *link)
 {
-	struct net_device *dev = link->priv;
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = link->priv;
+	struct net_device *dev = priv->ndev;
 	unsigned long flags;
 	int err = 0;
 
 	/* Mark the device as stopped, to block IO until later */
 	spin_lock_irqsave(&priv->lock, flags);
 
-	err = __orinoco_down(dev);
+	err = __orinoco_down(priv);
 	if (err)
 		printk(KERN_WARNING "%s: Error %d downing interface\n",
 		       dev->name, err);
@@ -451,12 +448,12 @@ spectrum_cs_suspend(struct pcmcia_device *link)
 static int
 spectrum_cs_resume(struct pcmcia_device *link)
 {
-	struct net_device *dev = link->priv;
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = link->priv;
+	struct net_device *dev = priv->ndev;
 	unsigned long flags;
 	int err;
 
-	err = orinoco_reinit_firmware(dev);
+	err = orinoco_reinit_firmware(priv);
 	if (err) {
 		printk(KERN_ERR "%s: Error %d re-initializing firmware\n",
 		       dev->name, err);
@@ -469,7 +466,7 @@ spectrum_cs_resume(struct pcmcia_device *link)
 	priv->hw_unavailable--;
 
 	if (priv->open && !priv->hw_unavailable) {
-		err = __orinoco_up(dev);
+		err = __orinoco_up(priv);
 		if (err)
 			printk(KERN_ERR "%s: Error %d restarting card\n",
 			       dev->name, err);
-- 
1.6.0.6

