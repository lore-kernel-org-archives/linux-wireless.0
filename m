Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27154 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbbLDNSF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Dec 2015 08:18:05 -0500
Date: Fri, 4 Dec 2015 16:17:46 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jouni Malinen <j@w1.fi>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [patch] hostap: fix an error code in prism2_config()
Message-ID: <20151204131746.GE12792@mwanda> (sfid-20151204_141811_556833_CB6578D6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current code returns success if prism2_init_local_data() fails, but
we want to return an error code.  Also we can remove the bogus
ret initializer because it is wrong and never used.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/intersil/hostap/hostap_cs.c b/drivers/net/wireless/intersil/hostap/hostap_cs.c
index 50033aa..74f63b7 100644
--- a/drivers/net/wireless/intersil/hostap/hostap_cs.c
+++ b/drivers/net/wireless/intersil/hostap/hostap_cs.c
@@ -473,7 +473,7 @@ static int prism2_config(struct pcmcia_device *link)
 	struct net_device *dev;
 	struct hostap_interface *iface;
 	local_info_t *local;
-	int ret = 1;
+	int ret;
 	struct hostap_cs_priv *hw_priv;
 	unsigned long flags;
 
@@ -502,8 +502,10 @@ static int prism2_config(struct pcmcia_device *link)
 	/* Need to allocate net_device before requesting IRQ handler */
 	dev = prism2_init_local_data(&prism2_pccard_funcs, 0,
 				     &link->dev);
-	if (dev == NULL)
+	if (!dev) {
+		ret = -ENOMEM;
 		goto failed;
+	}
 	link->priv = dev;
 
 	iface = netdev_priv(dev);
