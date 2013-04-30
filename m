Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32477 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586Ab3D3H5d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Apr 2013 03:57:33 -0400
Date: Tue, 30 Apr 2013 10:57:05 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Simon Kelley <simon@thekelleys.org.uk>,
	David Howells <dhowells@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] atmel: printing bogus information
Message-ID: <20130430075704.GH7237@elgon.mountain> (sfid-20130430_095738_928995_CD32B50D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There was an extra ';' character added to the end of the if statement
which means that it always prints that the /proc entry wasn't created
even though it was.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/atmel.c b/drivers/net/wireless/atmel.c
index 23a3498..2876b90 100644
--- a/drivers/net/wireless/atmel.c
+++ b/drivers/net/wireless/atmel.c
@@ -1624,7 +1624,7 @@ struct net_device *init_atmel_card(unsigned short irq, unsigned long port,
 
 	netif_carrier_off(dev);
 
-	if (!proc_create_data("driver/atmel", 0, NULL, &atmel_proc_fops, priv));
+	if (!proc_create_data("driver/atmel", 0, NULL, &atmel_proc_fops, priv))
 		printk(KERN_WARNING "atmel: unable to create /proc entry.\n");
 
 	printk(KERN_INFO "%s: Atmel at76c50x. Version %d.%d. MAC %pM\n",
