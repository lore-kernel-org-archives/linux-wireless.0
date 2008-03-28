Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:53837 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbYC1Kug (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2008 06:50:36 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Fix PCMCIA IRQ routing
Date: Fri, 28 Mar 2008 11:48:53 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200803281148.53300.mb@bu3sch.de> (sfid-20080328_105040_686445_9AC9BF2D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes the IRQ routing on PCMCIA devices.
With this patch the card will finally be able to receive IRQs.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

Please queue for 2.6.25

Index: wireless-testing/drivers/net/wireless/b43/pcmcia.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/pcmcia.c	2008-03-28 11:35:25.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/pcmcia.c	2008-03-28 11:38:14.000000000 +0100
@@ -88,12 +88,14 @@ static int __devinit b43_pcmcia_probe(st
 	res = pcmcia_parse_tuple(dev, &tuple, &parse);
 	if (res != CS_SUCCESS)
 		goto err_kfree_ssb;
 
 	dev->conf.ConfigBase = parse.config.base;
 	dev->conf.Present = parse.config.rmask[0];
+	dev->conf.Attributes = CONF_ENABLE_IRQ;
+	dev->conf.IntType = INT_MEMORY_AND_IO;
 
 	dev->io.BasePort2 = 0;
 	dev->io.NumPorts2 = 0;
 	dev->io.Attributes2 = 0;
 
 	win.Attributes = WIN_ADDR_SPACE_MEM | WIN_MEMORY_TYPE_CM |
@@ -109,14 +111,14 @@ static int __devinit b43_pcmcia_probe(st
 	mem.CardOffset = 0;
 	mem.Page = 0;
 	res = pcmcia_map_mem_page(dev->win, &mem);
 	if (res != CS_SUCCESS)
 		goto err_disable;
 
-	dev->irq.Attributes = IRQ_TYPE_DYNAMIC_SHARING | IRQ_FIRST_SHARED;
-	dev->irq.IRQInfo1 = IRQ_LEVEL_ID | IRQ_SHARE_ID;
+	dev->irq.Attributes = IRQ_TYPE_DYNAMIC_SHARING;
+	dev->irq.IRQInfo1 = IRQ_LEVEL_ID;
 	dev->irq.Handler = NULL; /* The handler is registered later. */
 	dev->irq.Instance = NULL;
 	res = pcmcia_request_irq(dev, &dev->irq);
 	if (res != CS_SUCCESS)
 		goto err_disable;
 
