Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms13.Sony.CO.JP ([211.125.136.230]:46001 "EHLO ms13.sony.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760387AbZAPJ4B (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 04:56:01 -0500
Received: from ms6.sony.co.jp (ms6.Sony.CO.JP [211.125.136.204])
 by ms13.sony.co.jp (R8/Sony) with ESMTP id n0G8nV6m012299
 for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2009 17:49:31 +0900 (JST)
Date: Fri, 16 Jan 2009 17:47:29 +0900
From: Masakazu Mokuno <mokuno@sm.sony.co.jp>
To: jgarzik@pobox.com, linville@tuxdriver.com
Subject: [PATCH 1/2] PS3: gelic: convert the ethernet part to net_device_ops
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	Geoff Levand <geoffrey.levand@am.sony.com>
Message-Id: <20090116174555.0B6E.40F06B3A@sm.sony.co.jp> (sfid-20090116_105607_934024_77D7D41C)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Convert the gelic driver to net_device_ops

Signed-off-by: Masakazu Mokuno <mokuno@sm.sony.co.jp>
---
 V2: added setting for ndo_validate_addr

 drivers/net/ps3_gelic_net.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

--- a/drivers/net/ps3_gelic_net.c
+++ b/drivers/net/ps3_gelic_net.c
@@ -1403,6 +1403,19 @@ void gelic_net_tx_timeout(struct net_dev
 		atomic_dec(&card->tx_timeout_task_counter);
 }
 
+static const struct net_device_ops gelic_netdevice_ops = {
+	.ndo_open = gelic_net_open,
+	.ndo_stop = gelic_net_stop,
+	.ndo_start_xmit = gelic_net_xmit,
+	.ndo_set_multicast_list = gelic_net_set_multi,
+	.ndo_change_mtu = gelic_net_change_mtu,
+	.ndo_tx_timeout = gelic_net_tx_timeout,
+	.ndo_validate_addr = eth_validate_addr,
+#ifdef CONFIG_NET_POLL_CONTROLLER
+	.ndo_poll_controller = gelic_net_poll_controller,
+#endif
+};
+
 /**
  * gelic_ether_setup_netdev_ops - initialization of net_device operations
  * @netdev: net_device structure
@@ -1412,21 +1425,12 @@ void gelic_net_tx_timeout(struct net_dev
 static void gelic_ether_setup_netdev_ops(struct net_device *netdev,
 					 struct napi_struct *napi)
 {
-	netdev->open = &gelic_net_open;
-	netdev->stop = &gelic_net_stop;
-	netdev->hard_start_xmit = &gelic_net_xmit;
-	netdev->set_multicast_list = &gelic_net_set_multi;
-	netdev->change_mtu = &gelic_net_change_mtu;
-	/* tx watchdog */
-	netdev->tx_timeout = &gelic_net_tx_timeout;
 	netdev->watchdog_timeo = GELIC_NET_WATCHDOG_TIMEOUT;
 	/* NAPI */
 	netif_napi_add(netdev, napi,
 		       gelic_net_poll, GELIC_NET_NAPI_WEIGHT);
 	netdev->ethtool_ops = &gelic_ether_ethtool_ops;
-#ifdef CONFIG_NET_POLL_CONTROLLER
-	netdev->poll_controller = gelic_net_poll_controller;
-#endif
+	netdev->netdev_ops = &gelic_netdevice_ops;
 }
 
 /**

-- 
Masakazu Mokuno

