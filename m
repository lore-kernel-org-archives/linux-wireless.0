Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:56827 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932227AbZE3RiE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 May 2009 13:38:04 -0400
Received: by mail-ew0-f176.google.com with SMTP id 24so6938274ewy.37
        for <linux-wireless@vger.kernel.org>; Sat, 30 May 2009 10:38:06 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@googlemail.com>
Subject: [RFC v2 18/23] orinoco: Handle suspend/restore in core driver
Date: Sat, 30 May 2009 18:36:52 +0100
Message-Id: <1243705017-8784-19-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1243705017-8784-1-git-send-email-kilroyd@googlemail.com>
References: <1243705017-8784-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Each device does almost exactly the same things on suspend and resume
when upping and downing the interface. So move this logic into a common
routine.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/airport.c     |   33 +--------------
 drivers/net/wireless/orinoco/main.c        |   61 +++++++++++++++++++++++++---
 drivers/net/wireless/orinoco/orinoco.h     |    5 +-
 drivers/net/wireless/orinoco/orinoco_cs.c  |   44 ++------------------
 drivers/net/wireless/orinoco/orinoco_pci.h |   47 +--------------------
 drivers/net/wireless/orinoco/spectrum_cs.c |   41 +-----------------
 6 files changed, 70 insertions(+), 161 deletions(-)

diff --git a/drivers/net/wireless/orinoco/airport.c b/drivers/net/wireless/orinoco/airport.c
index 70f1331..c60df2c 100644
--- a/drivers/net/wireless/orinoco/airport.c
+++ b/drivers/net/wireless/orinoco/airport.c
@@ -50,15 +50,7 @@ airport_suspend(struct macio_dev *mdev, pm_message_t state)
 		return 0;
 	}
 
-	err = __orinoco_down(priv);
-	if (err)
-		printk(KERN_WARNING "%s: PBOOK_SLEEP_NOW: Error %d downing interface\n",
-		       dev->name, err);
-
-	netif_device_detach(dev);
-
-	priv->hw_unavailable++;
-
+	orinoco_down(priv);
 	orinoco_unlock(priv, &flags);
 
 	disable_irq(card->irq);
@@ -85,30 +77,11 @@ airport_resume(struct macio_dev *mdev)
 
 	enable_irq(card->irq);
 
-	err = orinoco_reinit_firmware(priv);
-	if (err) {
-		printk(KERN_ERR "%s: Error %d re-initializing firmware on PBOOK_WAKE\n",
-		       dev->name, err);
-		return 0;
-	}
-
 	spin_lock_irqsave(&priv->lock, flags);
-
-	netif_device_attach(dev);
-
-	priv->hw_unavailable--;
-
-	if (priv->open && (!priv->hw_unavailable)) {
-		err = __orinoco_up(priv);
-		if (err)
-			printk(KERN_ERR "%s: Error %d restarting card on PBOOK_WAKE\n",
-			       dev->name, err);
-	}
-
-
+	err = orinoco_up(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	return 0;
+	return err;
 }
 
 static int
diff --git a/drivers/net/wireless/orinoco/main.c b/drivers/net/wireless/orinoco/main.c
index 8218f44..7667747 100644
--- a/drivers/net/wireless/orinoco/main.c
+++ b/drivers/net/wireless/orinoco/main.c
@@ -211,6 +211,8 @@ struct orinoco_rx_data {
 /********************************************************************/
 
 static void __orinoco_set_multicast_list(struct net_device *dev);
+static int __orinoco_up(struct orinoco_private *priv);
+static int __orinoco_down(struct orinoco_private *priv);
 
 /********************************************************************/
 /* Internal helper functions                                        */
@@ -1514,7 +1516,7 @@ static void __orinoco_ev_infdrop(struct net_device *dev, hermes_t *hw)
 /* Internal hardware control routines                               */
 /********************************************************************/
 
-int __orinoco_up(struct orinoco_private *priv)
+static int __orinoco_up(struct orinoco_private *priv)
 {
 	struct net_device *dev = priv->ndev;
 	struct hermes *hw = &priv->hw;
@@ -1542,9 +1544,8 @@ int __orinoco_up(struct orinoco_private *priv)
 
 	return 0;
 }
-EXPORT_SYMBOL(__orinoco_up);
 
-int __orinoco_down(struct orinoco_private *priv)
+static int __orinoco_down(struct orinoco_private *priv)
 {
 	struct net_device *dev = priv->ndev;
 	struct hermes *hw = &priv->hw;
@@ -1574,9 +1575,8 @@ int __orinoco_down(struct orinoco_private *priv)
 
 	return 0;
 }
-EXPORT_SYMBOL(__orinoco_down);
 
-int orinoco_reinit_firmware(struct orinoco_private *priv)
+static int orinoco_reinit_firmware(struct orinoco_private *priv)
 {
 	struct hermes *hw = &priv->hw;
 	int err;
@@ -1592,7 +1592,6 @@ int orinoco_reinit_firmware(struct orinoco_private *priv)
 
 	return err;
 }
-EXPORT_SYMBOL(orinoco_reinit_firmware);
 
 int __orinoco_program_rids(struct net_device *dev)
 {
@@ -2388,6 +2387,56 @@ void free_orinocodev(struct orinoco_private *priv)
 }
 EXPORT_SYMBOL(free_orinocodev);
 
+int orinoco_up(struct orinoco_private *priv)
+{
+	struct net_device *dev = priv->ndev;
+	unsigned long flags;
+	int err;
+
+	spin_lock_irqsave(&priv->lock, flags);
+
+	err = orinoco_reinit_firmware(priv);
+	if (err) {
+		printk(KERN_ERR "%s: Error %d re-initializing firmware\n",
+		       dev->name, err);
+		goto exit;
+	}
+
+	netif_device_attach(dev);
+	priv->hw_unavailable--;
+
+	if (priv->open && !priv->hw_unavailable) {
+		err = __orinoco_up(priv);
+		if (err)
+			printk(KERN_ERR "%s: Error %d restarting card\n",
+			       dev->name, err);
+	}
+
+exit:
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	return 0;
+}
+EXPORT_SYMBOL(orinoco_up);
+
+void orinoco_down(struct orinoco_private *priv)
+{
+	struct net_device *dev = priv->ndev;
+	unsigned long flags;
+	int err;
+
+	spin_lock_irqsave(&priv->lock, flags);
+	err = __orinoco_down(priv);
+	if (err)
+		printk(KERN_WARNING "%s: Error %d downing interface\n",
+		       dev->name, err);
+
+	netif_device_detach(dev);
+	priv->hw_unavailable++;
+	spin_unlock_irqrestore(&priv->lock, flags);
+}
+EXPORT_SYMBOL(orinoco_down);
+
 static void orinoco_get_drvinfo(struct net_device *dev,
 				struct ethtool_drvinfo *info)
 {
diff --git a/drivers/net/wireless/orinoco/orinoco.h b/drivers/net/wireless/orinoco/orinoco.h
index 45aa616..4ee85f8 100644
--- a/drivers/net/wireless/orinoco/orinoco.h
+++ b/drivers/net/wireless/orinoco/orinoco.h
@@ -197,9 +197,8 @@ extern int orinoco_if_add(struct orinoco_private *priv,
 			  unsigned long base_addr,
 			  unsigned int irq);
 extern void orinoco_if_del(struct orinoco_private *priv);
-extern int __orinoco_up(struct orinoco_private *priv);
-extern int __orinoco_down(struct orinoco_private *priv);
-extern int orinoco_reinit_firmware(struct orinoco_private *priv);
+extern int orinoco_up(struct orinoco_private *priv);
+extern void orinoco_down(struct orinoco_private *priv);
 extern irqreturn_t orinoco_interrupt(int irq, void *dev_id);
 
 /********************************************************************/
diff --git a/drivers/net/wireless/orinoco/orinoco_cs.c b/drivers/net/wireless/orinoco/orinoco_cs.c
index 4c29d36..38c1c9d 100644
--- a/drivers/net/wireless/orinoco/orinoco_cs.c
+++ b/drivers/net/wireless/orinoco/orinoco_cs.c
@@ -349,26 +349,12 @@ static int orinoco_cs_suspend(struct pcmcia_device *link)
 {
 	struct orinoco_private *priv = link->priv;
 	struct orinoco_pccard *card = priv->card;
-	struct net_device *dev = priv->ndev;
-	int err = 0;
-	unsigned long flags;
 
 	/* This is probably racy, but I can't think of
 	   a better way, short of rewriting the PCMCIA
 	   layer to not suck :-( */
-	if (!test_bit(0, &card->hard_reset_in_progress)) {
-		spin_lock_irqsave(&priv->lock, flags);
-
-		err = __orinoco_down(priv);
-		if (err)
-			printk(KERN_WARNING "%s: Error %d downing interface\n",
-			       dev->name, err);
-
-		netif_device_detach(dev);
-		priv->hw_unavailable++;
-
-		spin_unlock_irqrestore(&priv->lock, flags);
-	}
+	if (!test_bit(0, &card->hard_reset_in_progress))
+		orinoco_down(priv);
 
 	return 0;
 }
@@ -377,32 +363,10 @@ static int orinoco_cs_resume(struct pcmcia_device *link)
 {
 	struct orinoco_private *priv = link->priv;
 	struct orinoco_pccard *card = priv->card;
-	struct net_device *dev = priv->ndev;
 	int err = 0;
-	unsigned long flags;
 
-	if (!test_bit(0, &card->hard_reset_in_progress)) {
-		err = orinoco_reinit_firmware(priv);
-		if (err) {
-			printk(KERN_ERR "%s: Error %d re-initializing firmware\n",
-			       dev->name, err);
-			return -EIO;
-		}
-
-		spin_lock_irqsave(&priv->lock, flags);
-
-		netif_device_attach(dev);
-		priv->hw_unavailable--;
-
-		if (priv->open && !priv->hw_unavailable) {
-			err = __orinoco_up(priv);
-			if (err)
-				printk(KERN_ERR "%s: Error %d restarting card\n",
-				       dev->name, err);
-		}
-
-		spin_unlock_irqrestore(&priv->lock, flags);
-	}
+	if (!test_bit(0, &card->hard_reset_in_progress))
+		err = orinoco_up(priv);
 
 	return err;
 }
diff --git a/drivers/net/wireless/orinoco/orinoco_pci.h b/drivers/net/wireless/orinoco/orinoco_pci.h
index 22aa630..ea7231a 100644
--- a/drivers/net/wireless/orinoco/orinoco_pci.h
+++ b/drivers/net/wireless/orinoco/orinoco_pci.h
@@ -22,28 +22,8 @@ struct orinoco_pci_card {
 static int orinoco_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 {
 	struct orinoco_private *priv = pci_get_drvdata(pdev);
-	struct net_device *dev = priv->ndev;
-	unsigned long flags;
-	int err;
-
-	err = orinoco_lock(priv, &flags);
-	if (err) {
-		printk(KERN_ERR "%s: cannot lock hardware for suspend\n",
-		       dev->name);
-		return err;
-	}
-
-	err = __orinoco_down(priv);
-	if (err)
-		printk(KERN_WARNING "%s: error %d bringing interface down "
-		       "for suspend\n", dev->name, err);
-
-	netif_device_detach(dev);
-
-	priv->hw_unavailable++;
-
-	orinoco_unlock(priv, &flags);
 
+	orinoco_down(priv);
 	free_irq(pdev->irq, priv);
 	pci_save_state(pdev);
 	pci_disable_device(pdev);
@@ -56,7 +36,6 @@ static int orinoco_pci_resume(struct pci_dev *pdev)
 {
 	struct orinoco_private *priv = pci_get_drvdata(pdev);
 	struct net_device *dev = priv->ndev;
-	unsigned long flags;
 	int err;
 
 	pci_set_power_state(pdev, 0);
@@ -77,29 +56,9 @@ static int orinoco_pci_resume(struct pci_dev *pdev)
 		return -EBUSY;
 	}
 
-	err = orinoco_reinit_firmware(priv);
-	if (err) {
-		printk(KERN_ERR "%s: error %d re-initializing firmware "
-		       "on resume\n", dev->name, err);
-		return err;
-	}
-
-	spin_lock_irqsave(&priv->lock, flags);
-
-	netif_device_attach(dev);
+	err = orinoco_up(priv);
 
-	priv->hw_unavailable--;
-
-	if (priv->open && (!priv->hw_unavailable)) {
-		err = __orinoco_up(priv);
-		if (err)
-			printk(KERN_ERR "%s: Error %d restarting card on resume\n",
-			       dev->name, err);
-	}
-
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	return 0;
+	return err;
 }
 #else
 #define orinoco_pci_suspend NULL
diff --git a/drivers/net/wireless/orinoco/spectrum_cs.c b/drivers/net/wireless/orinoco/spectrum_cs.c
index 7b4a7e4..c361310 100644
--- a/drivers/net/wireless/orinoco/spectrum_cs.c
+++ b/drivers/net/wireless/orinoco/spectrum_cs.c
@@ -421,22 +421,10 @@ static int
 spectrum_cs_suspend(struct pcmcia_device *link)
 {
 	struct orinoco_private *priv = link->priv;
-	struct net_device *dev = priv->ndev;
-	unsigned long flags;
 	int err = 0;
 
 	/* Mark the device as stopped, to block IO until later */
-	spin_lock_irqsave(&priv->lock, flags);
-
-	err = __orinoco_down(priv);
-	if (err)
-		printk(KERN_WARNING "%s: Error %d downing interface\n",
-		       dev->name, err);
-
-	netif_device_detach(dev);
-	priv->hw_unavailable++;
-
-	spin_unlock_irqrestore(&priv->lock, flags);
+	orinoco_down(priv);
 
 	return err;
 }
@@ -445,32 +433,9 @@ static int
 spectrum_cs_resume(struct pcmcia_device *link)
 {
 	struct orinoco_private *priv = link->priv;
-	struct net_device *dev = priv->ndev;
-	unsigned long flags;
-	int err;
-
-	err = orinoco_reinit_firmware(priv);
-	if (err) {
-		printk(KERN_ERR "%s: Error %d re-initializing firmware\n",
-		       dev->name, err);
-		return -EIO;
-	}
+	int err = orinoco_up(priv);
 
-	spin_lock_irqsave(&priv->lock, flags);
-
-	netif_device_attach(dev);
-	priv->hw_unavailable--;
-
-	if (priv->open && !priv->hw_unavailable) {
-		err = __orinoco_up(priv);
-		if (err)
-			printk(KERN_ERR "%s: Error %d restarting card\n",
-			       dev->name, err);
-	}
-
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	return 0;
+	return err;
 }
 
 
-- 
1.6.0.6

