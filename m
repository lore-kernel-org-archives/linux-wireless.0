Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757622Ab3KHTjo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Nov 2013 14:39:44 -0500
Message-ID: <1383939584.29096.10.camel@dcbw.foobar.com> (sfid-20131108_203947_114006_27341B5C)
Subject: [PATCH] prism54: set netdev type to "wlan"
From: Dan Williams <dcbw@redhat.com>
To: Frans Leerink <f.leerink@xs4all.nl>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 08 Nov 2013 13:39:44 -0600
In-Reply-To: <2774683.Pvb2zYysB7@md8338-opensuse-12-3.site>
References: <2774683.Pvb2zYysB7@md8338-opensuse-12-3.site>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Userspace uses the netdev devtype for stuff like device naming and type
detection.  Be nice and set it.  Remove the pointless #if/#endif around
SET_NETDEV_DEV too.

Signed-off-by: Dan Williams <dcbw@redhat.com>
---
diff --git a/drivers/net/wireless/prism54/islpci_dev.c b/drivers/net/wireless/prism54/islpci_dev.c
index 5970ff6..d498b02 100644
--- a/drivers/net/wireless/prism54/islpci_dev.c
+++ b/drivers/net/wireless/prism54/islpci_dev.c
@@ -807,27 +807,30 @@ static const struct net_device_ops islpci_netdev_ops = {
 	.ndo_start_xmit		= islpci_eth_transmit,
 	.ndo_tx_timeout		= islpci_eth_tx_timeout,
 	.ndo_set_mac_address 	= prism54_set_mac_address,
 	.ndo_change_mtu		= eth_change_mtu,
 	.ndo_validate_addr	= eth_validate_addr,
 };
 
+static struct device_type wlan_type = {
+	.name	= "wlan",
+};
+
 struct net_device *
 islpci_setup(struct pci_dev *pdev)
 {
 	islpci_private *priv;
 	struct net_device *ndev = alloc_etherdev(sizeof (islpci_private));
 
 	if (!ndev)
 		return ndev;
 
 	pci_set_drvdata(pdev, ndev);
-#if defined(SET_NETDEV_DEV)
 	SET_NETDEV_DEV(ndev, &pdev->dev);
-#endif
+	SET_NETDEV_DEVTYPE(ndev, &wlan_type);
 
 	/* setup the structure members */
 	ndev->base_addr = pci_resource_start(pdev, 0);
 	ndev->irq = pdev->irq;
 
 	/* initialize the function pointers */
 	ndev->netdev_ops = &islpci_netdev_ops;

