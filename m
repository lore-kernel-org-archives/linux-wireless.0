Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:64563 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756613AbZFRWWg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2009 18:22:36 -0400
Received: by mail-ew0-f210.google.com with SMTP id 6so1987323ewy.37
        for <linux-wireless@vger.kernel.org>; Thu, 18 Jun 2009 15:22:39 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 17/23] airport: store irq in card private structure
Date: Thu, 18 Jun 2009 23:21:29 +0100
Message-Id: <1245363695-8289-18-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1245363695-8289-1-git-send-email-kilroyd@googlemail.com>
References: <1245363695-8289-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

... instead of relying on the net_device fields.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/airport.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/orinoco/airport.c b/drivers/net/wireless/orinoco/airport.c
index e46e0d7..70f1331 100644
--- a/drivers/net/wireless/orinoco/airport.c
+++ b/drivers/net/wireless/orinoco/airport.c
@@ -27,6 +27,7 @@
 struct airport {
 	struct macio_dev *mdev;
 	void __iomem *vaddr;
+	unsigned int irq;
 	int irq_requested;
 	int ndev_registered;
 };
@@ -36,6 +37,7 @@ airport_suspend(struct macio_dev *mdev, pm_message_t state)
 {
 	struct orinoco_private *priv = dev_get_drvdata(&mdev->ofdev.dev);
 	struct net_device *dev = priv->ndev;
+	struct airport *card = priv->card;
 	unsigned long flags;
 	int err;
 
@@ -59,7 +61,7 @@ airport_suspend(struct macio_dev *mdev, pm_message_t state)
 
 	orinoco_unlock(priv, &flags);
 
-	disable_irq(dev->irq);
+	disable_irq(card->irq);
 	pmac_call_feature(PMAC_FTR_AIRPORT_ENABLE,
 			  macio_get_of_node(mdev), 0, 0);
 
@@ -71,6 +73,7 @@ airport_resume(struct macio_dev *mdev)
 {
 	struct orinoco_private *priv = dev_get_drvdata(&mdev->ofdev.dev);
 	struct net_device *dev = priv->ndev;
+	struct airport *card = priv->card;
 	unsigned long flags;
 	int err;
 
@@ -80,7 +83,7 @@ airport_resume(struct macio_dev *mdev)
 			  macio_get_of_node(mdev), 0, 1);
 	msleep(200);
 
-	enable_irq(dev->irq);
+	enable_irq(card->irq);
 
 	err = orinoco_reinit_firmware(priv);
 	if (err) {
@@ -112,7 +115,6 @@ static int
 airport_detach(struct macio_dev *mdev)
 {
 	struct orinoco_private *priv = dev_get_drvdata(&mdev->ofdev.dev);
-	struct net_device *dev = priv->ndev;
 	struct airport *card = priv->card;
 
 	if (card->ndev_registered)
@@ -120,7 +122,7 @@ airport_detach(struct macio_dev *mdev)
 	card->ndev_registered = 0;
 
 	if (card->irq_requested)
-		free_irq(dev->irq, priv);
+		free_irq(card->irq, priv);
 	card->irq_requested = 0;
 
 	if (card->vaddr)
@@ -146,7 +148,6 @@ static int airport_hard_reset(struct orinoco_private *priv)
 	 * re-initialize properly, it falls in a screaming heap
 	 * shortly afterwards. */
 #if 0
-	struct net_device *dev = priv->ndev;
 	struct airport *card = priv->card;
 
 	/* Vitally important.  If we don't do this it seems we get an
@@ -154,7 +155,7 @@ static int airport_hard_reset(struct orinoco_private *priv)
 	 * hw_unavailable is already set it doesn't get ACKed, we get
 	 * into an interrupt loop and the PMU decides to turn us
 	 * off. */
-	disable_irq(dev->irq);
+	disable_irq(card->irq);
 
 	pmac_call_feature(PMAC_FTR_AIRPORT_ENABLE,
 			  macio_get_of_node(card->mdev), 0, 0);
@@ -163,7 +164,7 @@ static int airport_hard_reset(struct orinoco_private *priv)
 			  macio_get_of_node(card->mdev), 0, 1);
 	ssleep(1);
 
-	enable_irq(dev->irq);
+	enable_irq(card->irq);
 	ssleep(1);
 #endif
 
@@ -176,7 +177,6 @@ airport_attach(struct macio_dev *mdev, const struct of_device_id *match)
 	struct orinoco_private *priv;
 	struct airport *card;
 	unsigned long phys_addr;
-	unsigned int irq;
 	hermes_t *hw;
 
 	if (macio_resource_count(mdev) < 1 || macio_irq_count(mdev) < 1) {
@@ -205,7 +205,7 @@ airport_attach(struct macio_dev *mdev, const struct of_device_id *match)
 	macio_set_drvdata(mdev, priv);
 
 	/* Setup interrupts & base address */
-	irq = macio_irq(mdev, 0);
+	card->irq = macio_irq(mdev, 0);
 	phys_addr = macio_resource_start(mdev, 0);  /* Physical address */
 	printk(KERN_DEBUG PFX "Physical address %lx\n", phys_addr);
 	card->vaddr = ioremap(phys_addr, AIRPORT_IO_LEN);
@@ -224,8 +224,8 @@ airport_attach(struct macio_dev *mdev, const struct of_device_id *match)
 	/* Reset it before we get the interrupt */
 	hermes_init(hw);
 
-	if (request_irq(irq, orinoco_interrupt, 0, DRIVER_NAME, priv)) {
-		printk(KERN_ERR PFX "Couldn't get IRQ %d\n", irq);
+	if (request_irq(card->irq, orinoco_interrupt, 0, DRIVER_NAME, priv)) {
+		printk(KERN_ERR PFX "Couldn't get IRQ %d\n", card->irq);
 		goto failed;
 	}
 	card->irq_requested = 1;
@@ -237,7 +237,7 @@ airport_attach(struct macio_dev *mdev, const struct of_device_id *match)
 	}
 
 	/* Register an interface with the stack */
-	if (orinoco_if_add(priv, phys_addr, irq) != 0) {
+	if (orinoco_if_add(priv, phys_addr, card->irq) != 0) {
 		printk(KERN_ERR PFX "orinoco_if_add() failed\n");
 		goto failed;
 	}
-- 
1.6.0.6

