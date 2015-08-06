Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50452 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756168AbbHFVGa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2015 17:06:30 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: mahfouz.saif.elyazal@gmail.com
Subject: [PATCH] orinoco: Do not call wiphy_unregister() from free_orinocodev()
Date: Thu,  6 Aug 2015 12:46:31 -0400
Message-Id: <1438879591-2849-1-git-send-email-Jes.Sorensen@redhat.com> (sfid-20150806_230644_508616_2B17FE1F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

alloc_orinocodev() would allocate the wiphy entry, but it would only get
registered much later in orinoco_init(). If something failed in the init
process inbetween the call to alloc_orinocodev() and the completion
of orinoco_init(), the drivers would end up calling wiphy_unregister()
with a NULL pointer causing beautiful OOPS fireworks.

Explicitly call wiphy_unregister() instead in the right places.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/orinoco/main.c           | 2 --
 drivers/net/wireless/orinoco/orinoco_cs.c     | 1 +
 drivers/net/wireless/orinoco/orinoco_nortel.c | 5 ++++-
 drivers/net/wireless/orinoco/orinoco_pci.c    | 5 ++++-
 drivers/net/wireless/orinoco/orinoco_plx.c    | 5 ++++-
 drivers/net/wireless/orinoco/orinoco_usb.c    | 2 ++
 6 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/orinoco/main.c b/drivers/net/wireless/orinoco/main.c
index 324ab71..32e9eef 100644
--- a/drivers/net/wireless/orinoco/main.c
+++ b/drivers/net/wireless/orinoco/main.c
@@ -2275,8 +2275,6 @@ void free_orinocodev(struct orinoco_private *priv)
 	struct orinoco_rx_data *rx_data, *temp;
 	struct orinoco_scan_data *sd, *sdtemp;
 
-	wiphy_unregister(wiphy);
-
 	/* If the tasklet is scheduled when we call tasklet_kill it
 	 * will run one final time. However the tasklet will only
 	 * drain priv->rx_list if the hw is still available. */
diff --git a/drivers/net/wireless/orinoco/orinoco_cs.c b/drivers/net/wireless/orinoco/orinoco_cs.c
index c0a2737..a956f96 100644
--- a/drivers/net/wireless/orinoco/orinoco_cs.c
+++ b/drivers/net/wireless/orinoco/orinoco_cs.c
@@ -118,6 +118,7 @@ static void orinoco_cs_detach(struct pcmcia_device *link)
 
 	orinoco_cs_release(link);
 
+	wiphy_unregister(priv_to_wiphy(priv));
 	free_orinocodev(priv);
 }				/* orinoco_cs_detach */
 
diff --git a/drivers/net/wireless/orinoco/orinoco_nortel.c b/drivers/net/wireless/orinoco/orinoco_nortel.c
index 1b543e3..048693b 100644
--- a/drivers/net/wireless/orinoco/orinoco_nortel.c
+++ b/drivers/net/wireless/orinoco/orinoco_nortel.c
@@ -223,13 +223,15 @@ static int orinoco_nortel_init_one(struct pci_dev *pdev,
 	err = orinoco_if_add(priv, 0, 0, NULL);
 	if (err) {
 		printk(KERN_ERR PFX "orinoco_if_add() failed\n");
-		goto fail;
+		goto fail_wiphy;
 	}
 
 	pci_set_drvdata(pdev, priv);
 
 	return 0;
 
+ fail_wiphy:
+	wiphy_unregister(priv_to_wiphy(priv));
  fail:
 	free_irq(pdev->irq, priv);
 
@@ -263,6 +265,7 @@ static void orinoco_nortel_remove_one(struct pci_dev *pdev)
 	iowrite16(0, card->bridge_io + 10);
 
 	orinoco_if_del(priv);
+	wiphy_unregister(priv_to_wiphy(priv));
 	free_irq(pdev->irq, priv);
 	free_orinocodev(priv);
 	pci_iounmap(pdev, priv->hw.iobase);
diff --git a/drivers/net/wireless/orinoco/orinoco_pci.c b/drivers/net/wireless/orinoco/orinoco_pci.c
index 74219d5..4938a22 100644
--- a/drivers/net/wireless/orinoco/orinoco_pci.c
+++ b/drivers/net/wireless/orinoco/orinoco_pci.c
@@ -173,13 +173,15 @@ static int orinoco_pci_init_one(struct pci_dev *pdev,
 	err = orinoco_if_add(priv, 0, 0, NULL);
 	if (err) {
 		printk(KERN_ERR PFX "orinoco_if_add() failed\n");
-		goto fail;
+		goto fail_wiphy;
 	}
 
 	pci_set_drvdata(pdev, priv);
 
 	return 0;
 
+ fail_wiphy:
+	wiphy_unregister(priv_to_wiphy(priv));
  fail:
 	free_irq(pdev->irq, priv);
 
@@ -203,6 +205,7 @@ static void orinoco_pci_remove_one(struct pci_dev *pdev)
 	struct orinoco_private *priv = pci_get_drvdata(pdev);
 
 	orinoco_if_del(priv);
+	wiphy_unregister(priv_to_wiphy(priv));
 	free_irq(pdev->irq, priv);
 	free_orinocodev(priv);
 	pci_iounmap(pdev, priv->hw.iobase);
diff --git a/drivers/net/wireless/orinoco/orinoco_plx.c b/drivers/net/wireless/orinoco/orinoco_plx.c
index 8b04523..2213520 100644
--- a/drivers/net/wireless/orinoco/orinoco_plx.c
+++ b/drivers/net/wireless/orinoco/orinoco_plx.c
@@ -262,13 +262,15 @@ static int orinoco_plx_init_one(struct pci_dev *pdev,
 	err = orinoco_if_add(priv, 0, 0, NULL);
 	if (err) {
 		printk(KERN_ERR PFX "orinoco_if_add() failed\n");
-		goto fail;
+		goto fail_wiphy;
 	}
 
 	pci_set_drvdata(pdev, priv);
 
 	return 0;
 
+ fail_wiphy:
+	wiphy_unregister(priv_to_wiphy(priv));
  fail:
 	free_irq(pdev->irq, priv);
 
@@ -299,6 +301,7 @@ static void orinoco_plx_remove_one(struct pci_dev *pdev)
 	struct orinoco_pci_card *card = priv->card;
 
 	orinoco_if_del(priv);
+	wiphy_unregister(priv_to_wiphy(priv));
 	free_irq(pdev->irq, priv);
 	free_orinocodev(priv);
 	pci_iounmap(pdev, priv->hw.iobase);
diff --git a/drivers/net/wireless/orinoco/orinoco_usb.c b/drivers/net/wireless/orinoco/orinoco_usb.c
index 91f0544..26a57d7 100644
--- a/drivers/net/wireless/orinoco/orinoco_usb.c
+++ b/drivers/net/wireless/orinoco/orinoco_usb.c
@@ -1502,6 +1502,7 @@ static inline void ezusb_delete(struct ezusb_priv *upriv)
 	if (upriv->dev) {
 		struct orinoco_private *priv = ndev_priv(upriv->dev);
 		orinoco_if_del(priv);
+		wiphy_unregister(priv_to_wiphy(upriv));
 		free_orinocodev(priv);
 	}
 }
@@ -1695,6 +1696,7 @@ static int ezusb_probe(struct usb_interface *interface,
 	if (orinoco_if_add(priv, 0, 0, &ezusb_netdev_ops) != 0) {
 		upriv->dev = NULL;
 		err("%s: orinoco_if_add() failed", __func__);
+		wiphy_unregister(priv_to_wiphy(priv));
 		goto error;
 	}
 	upriv->dev = priv->ndev;
-- 
1.8.3.1

