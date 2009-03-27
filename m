Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from suva.vyatta.com ([76.74.103.44]:43185 "EHLO suva.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755576AbZC0B14 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2009 21:27:56 -0400
Message-Id: <20090327011255.831891273@linux-foundation.org> (sfid-20090327_022802_644103_65C26BCF)
Date: Thu, 26 Mar 2009 18:11:26 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: David Miller <davem@davemloft.net>, linville@tuxdriver.com
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [patch 12/30] wireless: convert arlan to net_device_ops
References: <20090327011114.169107105@linux-foundation.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>


--- a/drivers/net/wireless/arlan-main.c	2009-03-21 12:37:00.000000000 -0700
+++ b/drivers/net/wireless/arlan-main.c	2009-03-26 15:46:23.278349900 -0700
@@ -1030,7 +1030,17 @@ static int arlan_mac_addr(struct net_dev
 	return 0;
 }
 
-
+static const struct net_device_ops arlan_netdev_ops = {
+	.ndo_open		= arlan_open,
+	.ndo_stop		= arlan_close,
+	.ndo_start_xmit		= arlan_tx,
+	.ndo_get_stats		= arlan_statistics,
+	.ndo_set_multicast_list = arlan_set_multicast,
+	.ndo_change_mtu		= arlan_change_mtu,
+	.ndo_set_mac_address	= arlan_mac_addr,
+	.ndo_tx_timeout		= arlan_tx_timeout,
+	.ndo_validate_addr	= eth_validate_addr,
+};
 
 static int __init arlan_setup_device(struct net_device *dev, int num)
 {
@@ -1042,14 +1052,7 @@ static int __init arlan_setup_device(str
 	ap->conf = (struct arlan_shmem *)(ap+1);
 
 	dev->tx_queue_len = tx_queue_len;
-	dev->open = arlan_open;
-	dev->stop = arlan_close;
-	dev->hard_start_xmit = arlan_tx;
-	dev->get_stats = arlan_statistics;
-	dev->set_multicast_list = arlan_set_multicast;
-	dev->change_mtu = arlan_change_mtu;
-	dev->set_mac_address = arlan_mac_addr;
-	dev->tx_timeout = arlan_tx_timeout;
+	dev->netdev_ops = &arlan_netdev_ops;
 	dev->watchdog_timeo = 3*HZ;
 	
 	ap->irq_test_done = 0;


