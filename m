Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:42813
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbXKFPiT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2007 10:38:19 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: b43: pcmcia-host initialization bugfixes
Date: Tue, 6 Nov 2007 16:36:41 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200711061636.41744.mb@bu3sch.de> (sfid-20071106_153822_727448_6919CBC9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix the initialization for PCMCIA devices.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-2.6/drivers/net/wireless/b43/pcmcia.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/pcmcia.c	2007-11-04 12:45:10.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/pcmcia.c	2007-11-04 12:46:24.000000000 +0100
@@ -65,12 +65,12 @@ static int __devinit b43_pcmcia_probe(st
 	tuple_t tuple;
 	cisparse_t parse;
 	int err = -ENOMEM;
-	int res;
+	int res = 0;
 	unsigned char buf[64];
 
 	ssb = kzalloc(sizeof(*ssb), GFP_KERNEL);
 	if (!ssb)
-		goto out;
+		goto out_error;
 
 	err = -ENODEV;
 	tuple.DesiredTuple = CISTPL_CONFIG;
@@ -96,10 +96,12 @@ static int __devinit b43_pcmcia_probe(st
 	dev->io.NumPorts2 = 0;
 	dev->io.Attributes2 = 0;
 
-	win.Attributes = WIN_MEMORY_TYPE_CM | WIN_ENABLE | WIN_USE_WAIT;
+	win.Attributes = WIN_ADDR_SPACE_MEM | WIN_MEMORY_TYPE_CM |
+			 WIN_ENABLE | WIN_DATA_WIDTH_16 |
+			 WIN_USE_WAIT;
 	win.Base = 0;
 	win.Size = SSB_CORE_SIZE;
-	win.AccessSpeed = 1000;
+	win.AccessSpeed = 250;
 	res = pcmcia_request_window(&dev, &win, &dev->win);
 	if (res != CS_SUCCESS)
 		goto err_kfree_ssb;
@@ -108,21 +110,26 @@ static int __devinit b43_pcmcia_probe(st
 	mem.Page = 0;
 	res = pcmcia_map_mem_page(dev->win, &mem);
 	if (res != CS_SUCCESS)
-		goto err_kfree_ssb;
+		goto err_disable;
 
 	res = pcmcia_request_configuration(dev, &dev->conf);
 	if (res != CS_SUCCESS)
 		goto err_disable;
 
 	err = ssb_bus_pcmciabus_register(ssb, dev, win.Base);
+	if (err)
+		goto err_disable;
 	dev->priv = ssb;
 
-      out:
-	return err;
-      err_disable:
+	return 0;
+
+err_disable:
 	pcmcia_disable_device(dev);
-      err_kfree_ssb:
+err_kfree_ssb:
 	kfree(ssb);
+out_error:
+	printk(KERN_ERR "b43-pcmcia: Initialization failed (%d, %d)\n",
+	       res, err);
 	return err;
 }
 
@@ -131,22 +138,21 @@ static void __devexit b43_pcmcia_remove(
 	struct ssb_bus *ssb = dev->priv;
 
 	ssb_bus_unregister(ssb);
-	pcmcia_release_window(dev->win);
 	pcmcia_disable_device(dev);
 	kfree(ssb);
 	dev->priv = NULL;
 }
 
 static struct pcmcia_driver b43_pcmcia_driver = {
-	.owner = THIS_MODULE,
-	.drv = {
-		.name = "b43-pcmcia",
-		},
-	.id_table = b43_pcmcia_tbl,
-	.probe = b43_pcmcia_probe,
-	.remove = b43_pcmcia_remove,
-	.suspend = b43_pcmcia_suspend,
-	.resume = b43_pcmcia_resume,
+	.owner		= THIS_MODULE,
+	.drv		= {
+				.name = "b43-pcmcia",
+			},
+	.id_table	= b43_pcmcia_tbl,
+	.probe		= b43_pcmcia_probe,
+	.remove		= __devexit_p(b43_pcmcia_remove),
+	.suspend	= b43_pcmcia_suspend,
+	.resume		= b43_pcmcia_resume,
 };
 
 int b43_pcmcia_init(void)
