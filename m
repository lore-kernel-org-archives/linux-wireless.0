Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:55496
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754399AbXKGSJX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Nov 2007 13:09:23 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: properly request pcmcia IRQ
Date: Wed, 7 Nov 2007 19:08:26 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200711071908.26195.mb@bu3sch.de> (sfid-20071107_180925_629942_5A13CC0A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PCMCIA needs an additional step to request the IRQ.

No need to add code to release the IRQ here, as that's done
automatically in pcmcia_disable_device().

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-2.6/drivers/net/wireless/b43/pcmcia.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/pcmcia.c	2007-11-07 15:54:21.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/pcmcia.c	2007-11-07 18:45:08.000000000 +0100
@@ -112,6 +112,14 @@ static int __devinit b43_pcmcia_probe(st
 	if (res != CS_SUCCESS)
 		goto err_disable;
 
+	dev->irq.Attributes = IRQ_TYPE_DYNAMIC_SHARING | IRQ_FIRST_SHARED;
+	dev->irq.IRQInfo1 = IRQ_LEVEL_ID | IRQ_SHARE_ID;
+	dev->irq.Handler = NULL; /* The handler is registered later. */
+	dev->irq.Instance = NULL;
+	res = pcmcia_request_irq(dev, &dev->irq);
+	if (res != CS_SUCCESS)
+		goto err_disable;
+
 	res = pcmcia_request_configuration(dev, &dev->conf);
 	if (res != CS_SUCCESS)
 		goto err_disable;
