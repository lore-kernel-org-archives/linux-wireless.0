Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from suva.vyatta.com ([76.74.103.44]:36707 "EHLO suva.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760320AbZCUFsY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Mar 2009 01:48:24 -0400
Message-Id: <20090321053717.682860987@vyatta.com> (sfid-20090321_065120_534694_F852C1AD)
References: <20090321053527.316395697@vyatta.com>
Date: Fri, 20 Mar 2009 22:36:34 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: David Miller <davem@davemloft.net>, mcgrof@gmail.com
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH 67/77] prism54: convert to net_device_ops
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also, make ethtool_ops const as it should be, and get rid
of useless cast.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>


--- a/drivers/net/wireless/prism54/islpci_dev.c	2009-03-20 21:45:40.782964097 -0700
+++ b/drivers/net/wireless/prism54/islpci_dev.c	2009-03-20 22:26:05.140779360 -0700
@@ -804,10 +804,23 @@ static void islpci_ethtool_get_drvinfo(s
 	strcpy(info->version, DRV_VERSION);
 }
 
-static struct ethtool_ops islpci_ethtool_ops = {
+static const struct ethtool_ops islpci_ethtool_ops = {
 	.get_drvinfo = islpci_ethtool_get_drvinfo,
 };
 
+static const struct net_device_ops islpci_netdev_ops = {
+	.ndo_open 		= islpci_open,
+	.ndo_stop		= islpci_close,
+	.ndo_get_stats		= islpci_statistics,
+	.ndo_do_ioctl		= prism54_ioctl,
+	.ndo_start_xmit		= islpci_eth_transmit,
+	.ndo_tx_timeout		= islpci_eth_tx_timeout,
+	.ndo_set_mac_address 	= prism54_set_mac_address,
+	.ndo_change_mtu		= eth_change_mtu,
+	.ndo_set_mac_address 	= eth_mac_addr,
+	.ndo_validate_addr	= eth_validate_addr,
+};
+
 struct net_device *
 islpci_setup(struct pci_dev *pdev)
 {
@@ -827,25 +840,16 @@ islpci_setup(struct pci_dev *pdev)
 	ndev->irq = pdev->irq;
 
 	/* initialize the function pointers */
-	ndev->open = &islpci_open;
-	ndev->stop = &islpci_close;
-	ndev->get_stats = &islpci_statistics;
-	ndev->do_ioctl = &prism54_ioctl;
-	ndev->wireless_handlers =
-	    (struct iw_handler_def *) &prism54_handler_def;
+	ndev->netdev_ops = &islpci_netdev_ops;
+	ndev->wireless_handlers = &prism54_handler_def;
 	ndev->ethtool_ops = &islpci_ethtool_ops;
 
-	ndev->hard_start_xmit = &islpci_eth_transmit;
 	/* ndev->set_multicast_list = &islpci_set_multicast_list; */
 	ndev->addr_len = ETH_ALEN;
-	ndev->set_mac_address = &prism54_set_mac_address;
 	/* Get a non-zero dummy MAC address for nameif. Jean II */
 	memcpy(ndev->dev_addr, dummy_mac, 6);
 
-#ifdef HAVE_TX_TIMEOUT
 	ndev->watchdog_timeo = ISLPCI_TX_TIMEOUT;
-	ndev->tx_timeout = &islpci_eth_tx_timeout;
-#endif
 
 	/* allocate a private device structure to the network device  */
 	priv = netdev_priv(ndev);

-- 

