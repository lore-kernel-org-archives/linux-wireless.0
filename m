Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:64563 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755924AbZFRWWT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2009 18:22:19 -0400
Received: by mail-ew0-f210.google.com with SMTP id 6so1987323ewy.37
        for <linux-wireless@vger.kernel.org>; Thu, 18 Jun 2009 15:22:21 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 12/23] orinoco: initialise independently of netdev
Date: Thu, 18 Jun 2009 23:21:24 +0100
Message-Id: <1245363695-8289-13-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1245363695-8289-1-git-send-email-kilroyd@googlemail.com>
References: <1245363695-8289-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Initialise the orinoco driver before registerring with netdev, which
will help when we get to cfg80211...

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/airport.c        |    6 +++
 drivers/net/wireless/orinoco/main.c           |   44 +++++++++++-------------
 drivers/net/wireless/orinoco/orinoco.h        |    1 +
 drivers/net/wireless/orinoco/orinoco_cs.c     |    6 +++
 drivers/net/wireless/orinoco/orinoco_nortel.c |    6 +++
 drivers/net/wireless/orinoco/orinoco_pci.c    |    6 +++
 drivers/net/wireless/orinoco/orinoco_plx.c    |    6 +++
 drivers/net/wireless/orinoco/orinoco_tmd.c    |    6 +++
 drivers/net/wireless/orinoco/spectrum_cs.c    |    6 +++
 9 files changed, 63 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/orinoco/airport.c b/drivers/net/wireless/orinoco/airport.c
index 6559aee..9f90337 100644
--- a/drivers/net/wireless/orinoco/airport.c
+++ b/drivers/net/wireless/orinoco/airport.c
@@ -234,6 +234,12 @@ airport_attach(struct macio_dev *mdev, const struct of_device_id *match)
 	}
 	card->irq_requested = 1;
 
+	/* Initialise the main driver */
+	if (orinoco_init(priv) != 0) {
+		printk(KERN_ERR PFX "orinoco_init() failed\n");
+		goto failed;
+	}
+
 	/* Tell the stack we exist */
 	if (register_netdev(dev) != 0) {
 		printk(KERN_ERR PFX "register_netdev() failed\n");
diff --git a/drivers/net/wireless/orinoco/main.c b/drivers/net/wireless/orinoco/main.c
index 4fa8264..ff869a2 100644
--- a/drivers/net/wireless/orinoco/main.c
+++ b/drivers/net/wireless/orinoco/main.c
@@ -80,6 +80,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/delay.h>
+#include <linux/device.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
@@ -2073,9 +2074,9 @@ static void orinoco_unregister_pm_notifier(struct orinoco_private *priv)
 /* Initialization                                                   */
 /********************************************************************/
 
-static int orinoco_init(struct net_device *dev)
+int orinoco_init(struct orinoco_private *priv)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct device *dev = priv->dev;
 	hermes_t *hw = &priv->hw;
 	int err = 0;
 
@@ -2086,15 +2087,14 @@ static int orinoco_init(struct net_device *dev)
 	/* Initialize the firmware */
 	err = hermes_init(hw);
 	if (err != 0) {
-		printk(KERN_ERR "%s: failed to initialize firmware (err = %d)\n",
-		       dev->name, err);
+		dev_err(dev, "Failed to initialize firmware (err = %d)\n",
+			err);
 		goto out;
 	}
 
 	err = determine_fw_capabilities(priv);
 	if (err != 0) {
-		printk(KERN_ERR "%s: Incompatible firmware, aborting\n",
-		       dev->name);
+		dev_err(dev, "Incompatible firmware, aborting\n");
 		goto out;
 	}
 
@@ -2110,27 +2110,23 @@ static int orinoco_init(struct net_device *dev)
 		/* Check firmware version again */
 		err = determine_fw_capabilities(priv);
 		if (err != 0) {
-			printk(KERN_ERR "%s: Incompatible firmware, aborting\n",
-			       dev->name);
+			dev_err(dev, "Incompatible firmware, aborting\n");
 			goto out;
 		}
 	}
 
 	if (priv->has_port3)
-		printk(KERN_DEBUG "%s: Ad-hoc demo mode supported\n",
-		       dev->name);
+		dev_info(dev, "Ad-hoc demo mode supported\n");
 	if (priv->has_ibss)
-		printk(KERN_DEBUG "%s: IEEE standard IBSS ad-hoc mode supported\n",
-		       dev->name);
-	if (priv->has_wep) {
-		printk(KERN_DEBUG "%s: WEP supported, %s-bit key\n", dev->name,
-		       priv->has_big_wep ? "104" : "40");
-	}
+		dev_info(dev, "IEEE standard IBSS ad-hoc mode supported\n");
+	if (priv->has_wep)
+		dev_info(dev, "WEP supported, %s-bit key\n",
+			 priv->has_big_wep ? "104" : "40");
 	if (priv->has_wpa) {
-		printk(KERN_DEBUG "%s: WPA-PSK supported\n", dev->name);
+		dev_info(dev, "WPA-PSK supported\n");
 		if (orinoco_mic_init(priv)) {
-			printk(KERN_ERR "%s: Failed to setup MIC crypto "
-			       "algorithm. Disabling WPA support\n", dev->name);
+			dev_err(dev, "Failed to setup MIC crypto algorithm. "
+				"Disabling WPA support\n");
 			priv->has_wpa = 0;
 		}
 	}
@@ -2141,14 +2137,14 @@ static int orinoco_init(struct net_device *dev)
 		goto out;
 	orinoco_bss_data_init(priv);
 
-	err = orinoco_hw_read_card_settings(priv, dev->dev_addr);
+	/* Netdev has not initialised, but we have allocated the buffer. */
+	err = orinoco_hw_read_card_settings(priv, priv->ndev->dev_addr);
 	if (err)
 		goto out;
 
 	err = orinoco_hw_allocate_fid(priv);
 	if (err) {
-		printk(KERN_ERR "%s: failed to allocate NIC buffer!\n",
-		       dev->name);
+		dev_err(dev, "Failed to allocate NIC buffer!\n");
 		goto out;
 	}
 
@@ -2174,14 +2170,14 @@ static int orinoco_init(struct net_device *dev)
 	priv->hw_unavailable--;
 	spin_unlock_irq(&priv->lock);
 
-	printk(KERN_DEBUG "%s: ready\n", dev->name);
+	dev_dbg(dev, "Ready\n");
 
  out:
 	return err;
 }
+EXPORT_SYMBOL(orinoco_init);
 
 static const struct net_device_ops orinoco_netdev_ops = {
-	.ndo_init		= orinoco_init,
 	.ndo_open		= orinoco_open,
 	.ndo_stop		= orinoco_stop,
 	.ndo_start_xmit		= orinoco_xmit,
diff --git a/drivers/net/wireless/orinoco/orinoco.h b/drivers/net/wireless/orinoco/orinoco.h
index b93e86c..2e9d33f 100644
--- a/drivers/net/wireless/orinoco/orinoco.h
+++ b/drivers/net/wireless/orinoco/orinoco.h
@@ -187,6 +187,7 @@ extern struct orinoco_private *alloc_orinocodev(
 	int (*hard_reset)(struct orinoco_private *),
 	int (*stop_fw)(struct orinoco_private *, int));
 extern void free_orinocodev(struct orinoco_private *priv);
+extern int orinoco_init(struct orinoco_private *priv);
 extern int __orinoco_up(struct orinoco_private *priv);
 extern int __orinoco_down(struct orinoco_private *priv);
 extern int orinoco_reinit_firmware(struct orinoco_private *priv);
diff --git a/drivers/net/wireless/orinoco/orinoco_cs.c b/drivers/net/wireless/orinoco/orinoco_cs.c
index fa8fe5b..20abf02 100644
--- a/drivers/net/wireless/orinoco/orinoco_cs.c
+++ b/drivers/net/wireless/orinoco/orinoco_cs.c
@@ -297,6 +297,12 @@ orinoco_cs_config(struct pcmcia_device *link)
 	dev->irq = link->irq.AssignedIRQ;
 	card->node.major = card->node.minor = 0;
 
+	/* Initialise the main driver */
+	if (orinoco_init(priv) != 0) {
+		printk(KERN_ERR PFX "orinoco_init() failed\n");
+		goto failed;
+	}
+
 	SET_NETDEV_DEV(dev, &handle_to_dev(link));
 	/* Tell the stack we exist */
 	if (register_netdev(dev) != 0) {
diff --git a/drivers/net/wireless/orinoco/orinoco_nortel.c b/drivers/net/wireless/orinoco/orinoco_nortel.c
index 4efd5a0..45cef81 100644
--- a/drivers/net/wireless/orinoco/orinoco_nortel.c
+++ b/drivers/net/wireless/orinoco/orinoco_nortel.c
@@ -217,6 +217,12 @@ static int orinoco_nortel_init_one(struct pci_dev *pdev,
 		goto fail;
 	}
 
+	err = orinoco_init(priv);
+	if (err) {
+		printk(KERN_ERR PFX "orinoco_init() failed\n");
+		goto fail;
+	}
+
 	err = register_netdev(dev);
 	if (err) {
 		printk(KERN_ERR PFX "Cannot register network device\n");
diff --git a/drivers/net/wireless/orinoco/orinoco_pci.c b/drivers/net/wireless/orinoco/orinoco_pci.c
index 12b9c6a..d0eb4ae 100644
--- a/drivers/net/wireless/orinoco/orinoco_pci.c
+++ b/drivers/net/wireless/orinoco/orinoco_pci.c
@@ -167,6 +167,12 @@ static int orinoco_pci_init_one(struct pci_dev *pdev,
 		goto fail;
 	}
 
+	err = orinoco_init(priv);
+	if (err) {
+		printk(KERN_ERR PFX "orinoco_init() failed\n");
+		goto fail;
+	}
+
 	err = register_netdev(dev);
 	if (err) {
 		printk(KERN_ERR PFX "Cannot register network device\n");
diff --git a/drivers/net/wireless/orinoco/orinoco_plx.c b/drivers/net/wireless/orinoco/orinoco_plx.c
index 77d5668..8f225d0 100644
--- a/drivers/net/wireless/orinoco/orinoco_plx.c
+++ b/drivers/net/wireless/orinoco/orinoco_plx.c
@@ -256,6 +256,12 @@ static int orinoco_plx_init_one(struct pci_dev *pdev,
 		goto fail;
 	}
 
+	err = orinoco_init(priv);
+	if (err) {
+		printk(KERN_ERR PFX "orinoco_init() failed\n");
+		goto fail;
+	}
+
 	err = register_netdev(dev);
 	if (err) {
 		printk(KERN_ERR PFX "Cannot register network device\n");
diff --git a/drivers/net/wireless/orinoco/orinoco_tmd.c b/drivers/net/wireless/orinoco/orinoco_tmd.c
index 5f24c03..3c04fae 100644
--- a/drivers/net/wireless/orinoco/orinoco_tmd.c
+++ b/drivers/net/wireless/orinoco/orinoco_tmd.c
@@ -153,6 +153,12 @@ static int orinoco_tmd_init_one(struct pci_dev *pdev,
 		goto fail;
 	}
 
+	err = orinoco_init(priv);
+	if (err) {
+		printk(KERN_ERR PFX "orinoco_init() failed\n");
+		goto fail;
+	}
+
 	err = register_netdev(dev);
 	if (err) {
 		printk(KERN_ERR PFX "Cannot register network device\n");
diff --git a/drivers/net/wireless/orinoco/spectrum_cs.c b/drivers/net/wireless/orinoco/spectrum_cs.c
index ce909e4..43e1aed 100644
--- a/drivers/net/wireless/orinoco/spectrum_cs.c
+++ b/drivers/net/wireless/orinoco/spectrum_cs.c
@@ -368,6 +368,12 @@ spectrum_cs_config(struct pcmcia_device *link)
 	if (spectrum_cs_hard_reset(priv) != 0)
 		goto failed;
 
+	/* Initialise the main driver */
+	if (orinoco_init(priv) != 0) {
+		printk(KERN_ERR PFX "orinoco_init() failed\n");
+		goto failed;
+	}
+
 	SET_NETDEV_DEV(dev, &handle_to_dev(link));
 	/* Tell the stack we exist */
 	if (register_netdev(dev) != 0) {
-- 
1.6.0.6

