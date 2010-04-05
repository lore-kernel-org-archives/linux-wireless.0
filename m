Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:52592 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756368Ab0DEVDj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Apr 2010 17:03:39 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] compat-wireless: Backport changes in pcmcia system
Date: Mon,  5 Apr 2010 23:03:29 +0200
Message-Id: <1270501410-3956-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Backport commit 83319eda6b2c6380f0152e22f33c947506c448c4 from linux-next

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/24-pcmcia.patch |  299 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 299 insertions(+), 0 deletions(-)

diff --git a/patches/24-pcmcia.patch b/patches/24-pcmcia.patch
index 40c8fc8..283b30d 100644
--- a/patches/24-pcmcia.patch
+++ b/patches/24-pcmcia.patch
@@ -1,3 +1,212 @@
+--- a/drivers/bluetooth/bluecard_cs.c
++++ b/drivers/bluetooth/bluecard_cs.c
+@@ -869,6 +869,12 @@ static int bluecard_probe(struct pcmcia_
+ 	link->io.Attributes1 = IO_DATA_PATH_WIDTH_8;
+ 	link->io.NumPorts1 = 8;
+ 
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,35))
++	link->irq.Attributes = IRQ_TYPE_DYNAMIC_SHARING;
++
++	link->irq.Handler = bluecard_interrupt;
++#endif
++
+ 	link->conf.Attributes = CONF_ENABLE_IRQ;
+ 	link->conf.IntType = INT_MEMORY_AND_IO;
+ 
+@@ -904,9 +910,15 @@ static int bluecard_config(struct pcmcia
+ 	if (i != 0)
+ 		goto failed;
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
+ 	i = pcmcia_request_irq(link, bluecard_interrupt);
+ 	if (i != 0)
+ 		goto failed;
++#else
++	i = pcmcia_request_irq(link, &link->irq);
++	if (i != 0)
++		link->irq.AssignedIRQ = 0;
++#endif
+ 
+ 	i = pcmcia_request_configuration(link, &link->conf);
+ 	if (i != 0)
+--- a/drivers/bluetooth/bt3c_cs.c
++++ b/drivers/bluetooth/bt3c_cs.c
+@@ -661,6 +661,12 @@ static int bt3c_probe(struct pcmcia_devi
+ 	link->io.Attributes1 = IO_DATA_PATH_WIDTH_8;
+ 	link->io.NumPorts1 = 8;
+ 
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,35))
++	link->irq.Attributes = IRQ_TYPE_DYNAMIC_SHARING;
++
++	link->irq.Handler = bt3c_interrupt;
++#endif
++
+ 	link->conf.Attributes = CONF_ENABLE_IRQ;
+ 	link->conf.IntType = INT_MEMORY_AND_IO;
+ 
+@@ -739,9 +745,15 @@ static int bt3c_config(struct pcmcia_dev
+ 	goto failed;
+ 
+ found_port:
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
+ 	i = pcmcia_request_irq(link, &bt3c_interrupt);
+ 	if (i != 0)
+ 		goto failed;
++#else
++	i = pcmcia_request_irq(link, &link->irq);
++	if (i != 0)
++		link->irq.AssignedIRQ = 0;
++#endif
+ 
+ 	i = pcmcia_request_configuration(link, &link->conf);
+ 	if (i != 0)
+--- a/drivers/bluetooth/btuart_cs.c
++++ b/drivers/bluetooth/btuart_cs.c
+@@ -590,6 +590,12 @@ static int btuart_probe(struct pcmcia_de
+ 	link->io.Attributes1 = IO_DATA_PATH_WIDTH_8;
+ 	link->io.NumPorts1 = 8;
+ 
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,35))
++	link->irq.Attributes = IRQ_TYPE_DYNAMIC_SHARING;
++
++	link->irq.Handler = btuart_interrupt;
++#endif
++
+ 	link->conf.Attributes = CONF_ENABLE_IRQ;
+ 	link->conf.IntType = INT_MEMORY_AND_IO;
+ 
+@@ -668,9 +674,15 @@ static int btuart_config(struct pcmcia_d
+ 	goto failed;
+ 
+ found_port:
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
+ 	i = pcmcia_request_irq(link, btuart_interrupt);
+ 	if (i != 0)
+ 		goto failed;
++#else
++	i = pcmcia_request_irq(link, &link->irq);
++	if (i != 0)
++		link->irq.AssignedIRQ = 0;
++#endif
+ 
+ 	i = pcmcia_request_configuration(link, &link->conf);
+ 	if (i != 0)
+--- a/drivers/bluetooth/dtl1_cs.c
++++ b/drivers/bluetooth/dtl1_cs.c
+@@ -574,6 +574,11 @@ static int dtl1_probe(struct pcmcia_devi
+ 
+ 	link->io.Attributes1 = IO_DATA_PATH_WIDTH_8;
+ 	link->io.NumPorts1 = 8;
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,35))
++	link->irq.Attributes = IRQ_TYPE_DYNAMIC_SHARING;
++
++	link->irq.Handler = dtl1_interrupt;
++#endif
+ 
+ 	link->conf.Attributes = CONF_ENABLE_IRQ;
+ 	link->conf.IntType = INT_MEMORY_AND_IO;
+@@ -617,9 +622,15 @@ static int dtl1_config(struct pcmcia_dev
+ 	if (pcmcia_loop_config(link, dtl1_confcheck, NULL) < 0)
+ 		goto failed;
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
+ 	i = pcmcia_request_irq(link, dtl1_interrupt);
+ 	if (i != 0)
+ 		goto failed;
++#else
++	i = pcmcia_request_irq(link, &link->irq);
++	if (i != 0)
++		link->irq.AssignedIRQ = 0;
++#endif
+ 
+ 	i = pcmcia_request_configuration(link, &link->conf);
+ 	if (i != 0)
+--- a/drivers/net/wireless/b43/pcmcia.c
++++ b/drivers/net/wireless/b43/pcmcia.c
+@@ -98,7 +98,14 @@ static int __devinit b43_pcmcia_probe(st
+ 	if (res != 0)
+ 		goto err_disable;
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
+ 	if (!dev->irq)
++#else
++	dev->irq.Attributes = IRQ_TYPE_DYNAMIC_SHARING;
++	dev->irq.Handler = NULL; /* The handler is registered later. */
++	res = pcmcia_request_irq(dev, &dev->irq);
++	if (res != 0)
++#endif
+ 		goto err_disable;
+ 
+ 	res = pcmcia_request_configuration(dev, &dev->conf);
+--- a/drivers/net/wireless/libertas/if_cs.c
++++ b/drivers/net/wireless/libertas/if_cs.c
+@@ -777,7 +777,11 @@ static void if_cs_release(struct pcmcia_
+ 
+ 	lbs_deb_enter(LBS_DEB_CS);
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
+ 	free_irq(p_dev->irq, card);
++#else
++	free_irq(p_dev->irq.AssignedIRQ, card);
++#endif
+ 	pcmcia_disable_device(p_dev);
+ 	if (card->iobase)
+ 		ioport_unmap(card->iobase);
+@@ -836,6 +840,11 @@ static int if_cs_probe(struct pcmcia_dev
+ 	card->p_dev = p_dev;
+ 	p_dev->priv = card;
+ 
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,35))
++	p_dev->irq.Attributes = IRQ_TYPE_DYNAMIC_SHARING;
++	p_dev->irq.Handler = NULL;
++#endif
++
+ 	p_dev->conf.Attributes = 0;
+ 	p_dev->conf.IntType = INT_MEMORY_AND_IO;
+ 
+@@ -850,8 +859,18 @@ static int if_cs_probe(struct pcmcia_dev
+ 	 * a handler to the interrupt, unless the 'Handler' member of
+ 	 * the irq structure is initialized.
+ 	 */
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
+ 	if (!p_dev->irq)
+ 		goto out1;
++#else
++	if (p_dev->conf.Attributes & CONF_ENABLE_IRQ) {
++		ret = pcmcia_request_irq(p_dev, &p_dev->irq);
++		if (ret) {
++			lbs_pr_err("error in pcmcia_request_irq\n");
++			goto out1;
++		}
++	}
++#endif
+ 
+ 	/* Initialize io access */
+ 	card->iobase = ioport_map(p_dev->io.BasePort1, p_dev->io.NumPorts1);
+@@ -874,7 +893,11 @@ static int if_cs_probe(struct pcmcia_dev
+ 
+ 	/* Finally, report what we've done */
+ 	lbs_deb_cs("irq %d, io 0x%04x-0x%04x\n",
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
+ 	       p_dev->irq, p_dev->io.BasePort1,
++#else
++	       p_dev->irq.AssignedIRQ, p_dev->io.BasePort1,
++#endif
+ 	       p_dev->io.BasePort1 + p_dev->io.NumPorts1 - 1);
+ 
+ 	/*
+@@ -931,7 +954,11 @@ static int if_cs_probe(struct pcmcia_dev
+ 	priv->fw_ready = 1;
+ 
+ 	/* Now actually get the IRQ */
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
+ 	ret = request_irq(p_dev->irq, if_cs_interrupt,
++#else
++	ret = request_irq(p_dev->irq.AssignedIRQ, if_cs_interrupt,
++#endif
+ 		IRQF_SHARED, DRV_NAME, card);
+ 	if (ret) {
+ 		lbs_pr_err("error in request_irq\n");
 --- a/drivers/net/wireless/orinoco/orinoco_cs.c
 +++ b/drivers/net/wireless/orinoco/orinoco_cs.c
 @@ -80,7 +80,11 @@ orinoco_cs_hard_reset(struct orinoco_pri
@@ -12,3 +221,93 @@
  	if (err)
  		return err;
  
+@@ -118,6 +122,12 @@ orinoco_cs_probe(struct pcmcia_device *l
+ 	card->p_dev = link;
+ 	link->priv = priv;
+ 
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,35))
++	/* Interrupt setup */
++	link->irq.Attributes = IRQ_TYPE_DYNAMIC_SHARING;
++	link->irq.Handler = orinoco_interrupt;
++#endif
++
+ 	/* General socket configuration defaults can go here.  In this
+ 	 * client, we assume very little, and rely on the CIS for
+ 	 * almost everything.  In most clients, many details (i.e.,
+@@ -251,7 +261,11 @@ orinoco_cs_config(struct pcmcia_device *
+ 		goto failed;
+ 	}
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
+ 	ret = pcmcia_request_irq(link, orinoco_interrupt);
++#else
++	ret = pcmcia_request_irq(link, &link->irq);
++#endif
+ 	if (ret)
+ 		goto failed;
+ 
+@@ -281,7 +295,11 @@ orinoco_cs_config(struct pcmcia_device *
+ 
+ 	/* Register an interface with the stack */
+ 	if (orinoco_if_add(priv, link->io.BasePort1,
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
+ 			   link->irq) != 0) {
++#else
++			   link->irq.AssignedIRQ) != 0) {
++#endif
+ 		printk(KERN_ERR PFX "orinoco_if_add() failed\n");
+ 		goto failed;
+ 	}
+--- a/drivers/net/wireless/orinoco/spectrum_cs.c
++++ b/drivers/net/wireless/orinoco/spectrum_cs.c
+@@ -192,6 +192,12 @@ spectrum_cs_probe(struct pcmcia_device *
+ 	card->p_dev = link;
+ 	link->priv = priv;
+ 
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,35))
++	/* Interrupt setup */
++	link->irq.Attributes = IRQ_TYPE_DYNAMIC_SHARING;
++	link->irq.Handler = orinoco_interrupt;
++#endif
++
+ 	/* General socket configuration defaults can go here.  In this
+ 	 * client, we assume very little, and rely on the CIS for
+ 	 * almost everything.  In most clients, many details (i.e.,
+@@ -325,7 +331,11 @@ spectrum_cs_config(struct pcmcia_device 
+ 		goto failed;
+ 	}
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
+ 	ret = pcmcia_request_irq(link, orinoco_interrupt);
++#else
++	ret = pcmcia_request_irq(link, &link->irq);
++#endif
+ 	if (ret)
+ 		goto failed;
+ 
+@@ -359,7 +369,11 @@ spectrum_cs_config(struct pcmcia_device 
+ 
+ 	/* Register an interface with the stack */
+ 	if (orinoco_if_add(priv, link->io.BasePort1,
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
+ 			   link->irq) != 0) {
++#else
++			   link->irq.AssignedIRQ) != 0) {
++#endif
+ 		printk(KERN_ERR PFX "orinoco_if_add() failed\n");
+ 		goto failed;
+ 	}
+--- a/drivers/ssb/main.c
++++ b/drivers/ssb/main.c
+@@ -490,7 +490,11 @@ static int ssb_devices_register(struct s
+ 			break;
+ 		case SSB_BUSTYPE_PCMCIA:
+ #ifdef CONFIG_SSB_PCMCIAHOST
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
+ 			sdev->irq = bus->host_pcmcia->irq;
++#else
++			sdev->irq = bus->host_pcmcia->irq.AssignedIRQ;
++#endif
+ 			dev->parent = &bus->host_pcmcia->dev;
+ #endif
+ 			break;
-- 
1.6.3.3

