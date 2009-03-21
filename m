Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from suva.vyatta.com ([76.74.103.44]:36681 "EHLO suva.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761088AbZCUFsV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Mar 2009 01:48:21 -0400
Message-Id: <20090321053717.126155878@vyatta.com> (sfid-20090321_065215_088763_2B130D8F)
References: <20090321053527.316395697@vyatta.com>
Date: Fri, 20 Mar 2009 22:36:27 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH 60/77] atmel: convert to net_device_ops
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

--- a/drivers/net/wireless/atmel.c	2009-03-20 22:14:19.375839873 -0700
+++ b/drivers/net/wireless/atmel.c	2009-03-20 22:25:54.642841540 -0700
@@ -1495,6 +1495,17 @@ static int atmel_read_proc(char *page, c
 	return len;
 }
 
+static const struct net_device_ops atmel_netdev_ops = {
+	.ndo_open 		= atmel_open,
+	.ndo_stop		= atmel_close,
+	.ndo_change_mtu 	= atmel_change_mtu,
+	.ndo_set_mac_address 	= atmel_set_mac_address,
+	.ndo_start_xmit 	= start_tx,
+	.ndo_do_ioctl 		= atmel_ioctl,
+	.ndo_change_mtu		= eth_change_mtu,
+	.ndo_validate_addr	= eth_validate_addr,
+};
+
 struct net_device *init_atmel_card(unsigned short irq, unsigned long port,
 				   const AtmelFWType fw_type,
 				   struct device *sys_dev,
@@ -1579,13 +1590,8 @@ struct net_device *init_atmel_card(unsig
 	priv->management_timer.function = atmel_management_timer;
 	priv->management_timer.data = (unsigned long) dev;
 
-	dev->open = atmel_open;
-	dev->stop = atmel_close;
-	dev->change_mtu = atmel_change_mtu;
-	dev->set_mac_address = atmel_set_mac_address;
-	dev->hard_start_xmit = start_tx;
-	dev->wireless_handlers = (struct iw_handler_def *)&atmel_handler_def;
-	dev->do_ioctl = atmel_ioctl;
+	dev->netdev_ops = &atmel_netdev_ops;
+	dev->wireless_handlers = &atmel_handler_def;
 	dev->irq = irq;
 	dev->base_addr = port;
 

-- 

