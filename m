Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from suva.vyatta.com ([76.74.103.44]:36671 "EHLO suva.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761041AbZCUFsU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Mar 2009 01:48:20 -0400
Message-Id: <20090321053716.812675897@vyatta.com> (sfid-20090321_065216_799090_4F63E50C)
References: <20090321053527.316395697@vyatta.com>
Date: Fri, 20 Mar 2009 22:36:23 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH 56/77] strip: convert to net_device_ops
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

--- a/drivers/net/wireless/strip.c	2009-03-20 22:14:24.337964494 -0700
+++ b/drivers/net/wireless/strip.c	2009-03-20 22:16:04.157965087 -0700
@@ -2477,6 +2477,16 @@ static const struct header_ops strip_hea
 	.rebuild = strip_rebuild_header,
 };
 
+
+static const struct net_device_ops strip_netdev_ops = {
+	.ndo_open 	= strip_open_low,
+	.ndo_stop 	= strip_close_low,
+	.ndo_start_xmit = strip_xmit,
+	.ndo_set_mac_address = strip_set_mac_address,
+	.ndo_get_stats	= strip_get_stats,
+	.ndo_change_mtu = strip_change_mtu,
+};
+
 /*
  * This routine is called by DDI when the
  * (dynamically assigned) device is registered
@@ -2503,18 +2513,8 @@ static void strip_dev_setup(struct net_d
 	dev->dev_addr[0] = 0;
 	dev->addr_len = sizeof(MetricomAddress);
 
-	/*
-	 * Pointers to interface service routines.
-	 */
-
-	dev->open = strip_open_low;
-	dev->stop = strip_close_low;
-	dev->hard_start_xmit = strip_xmit;
-	dev->header_ops = &strip_header_ops;
-
-	dev->set_mac_address = strip_set_mac_address;
-	dev->get_stats = strip_get_stats;
-	dev->change_mtu = strip_change_mtu;
+	dev->header_ops = &strip_header_ops,
+	dev->netdev_ops = &strip_netdev_ops;
 }
 
 /*

-- 

