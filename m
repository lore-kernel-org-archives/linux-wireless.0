Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55762 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753313AbZLVPVf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Dec 2009 10:21:35 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/3] compat-wireless: Add more functions into netdev oops backport
Date: Tue, 22 Dec 2009 16:20:04 +0100
Message-Id: <1261495204-28966-6-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1261495204-28966-1-git-send-email-hauke@hauke-m.de>
References: <1261495204-28966-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add netdev->poll_controller, netdev->vlan_rx_register and netdev->set_multicast_list into the netdev_ops backport code in driver atl1c, atl1e and atlx.

This is compiling, but not really tested because I do not have these devices.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/01-netdev.patch |   28 ++++++++++++++++++++++++----
 1 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/patches/01-netdev.patch b/patches/01-netdev.patch
index 1ddae28..2c0aa06 100644
--- a/patches/01-netdev.patch
+++ b/patches/01-netdev.patch
@@ -629,7 +629,7 @@ diff -Nur a/net/bluetooth/bnep/netdev.c b/net/bluetooth/bnep/netdev.c
  
  static int atl1e_init_netdev(struct net_device *netdev, struct pci_dev *pdev)
  {
-@@ -2243,7 +2245,18 @@ static int atl1e_init_netdev(struct net_
+@@ -2243,7 +2245,23 @@ static int atl1e_init_netdev(struct net_
  	pci_set_drvdata(pdev, netdev);
  
  	netdev->irq  = pdev->irq;
@@ -644,6 +644,11 @@ diff -Nur a/net/bluetooth/bnep/netdev.c b/net/bluetooth/bnep/netdev.c
 +	netdev->set_mac_address = atl1e_set_mac_addr;
 +	netdev->do_ioctl = atl1e_ioctl;
 +	netdev->get_stats = atl1e_get_stats;
++	netdev->set_multicast_list = atl1e_set_multi;
++	netdev->vlan_rx_register = atl1e_vlan_rx_register;
++#ifdef CONFIG_NET_POLL_CONTROLLER
++	netdev->poll_controller = atl1e_netpoll;
++#endif
 +#endif
  
  	netdev->watchdog_timeo = AT_TX_WATCHDOG;
@@ -666,7 +671,7 @@ diff -Nur a/net/bluetooth/bnep/netdev.c b/net/bluetooth/bnep/netdev.c
  
  static int atl1c_init_netdev(struct net_device *netdev, struct pci_dev *pdev)
  {
-@@ -2462,7 +2464,18 @@ static int atl1c_init_netdev(struct net_
+@@ -2462,7 +2464,23 @@ static int atl1c_init_netdev(struct net_
  	pci_set_drvdata(pdev, netdev);
  
  	netdev->irq  = pdev->irq;
@@ -681,6 +686,11 @@ diff -Nur a/net/bluetooth/bnep/netdev.c b/net/bluetooth/bnep/netdev.c
 +	netdev->set_mac_address = atl1c_set_mac_addr;
 +	netdev->do_ioctl = atl1c_ioctl;
 +	netdev->get_stats = atl1c_get_stats;
++	netdev->set_multicast_list = atl1c_set_multi;
++	netdev->vlan_rx_register = atl1c_vlan_rx_register;
++#ifdef CONFIG_NET_POLL_CONTROLLER
++	netdev->poll_controller = atl1c_netpoll;
++#endif
 +#endif
  	netdev->watchdog_timeo = AT_TX_WATCHDOG;
  	atl1c_set_ethtool_ops(netdev);
@@ -703,7 +713,7 @@ diff -Nur a/net/bluetooth/bnep/netdev.c b/net/bluetooth/bnep/netdev.c
  
  /*
   * atl1_probe - Device Initialization Routine
-@@ -2981,7 +2983,17 @@ static int __devinit atl1_probe(struct p
+@@ -2981,7 +2983,22 @@ static int __devinit atl1_probe(struct p
  	adapter->mii.phy_id_mask = 0x1f;
  	adapter->mii.reg_num_mask = 0x1f;
  
@@ -717,6 +727,11 @@ diff -Nur a/net/bluetooth/bnep/netdev.c b/net/bluetooth/bnep/netdev.c
 +	netdev->tx_timeout = atlx_tx_timeout;
 +	netdev->set_mac_address = atl1_set_mac;
 +	netdev->do_ioctl = atlx_ioctl;
++	netdev->set_multicast_list = atlx_set_multi;
++	netdev->vlan_rx_register = atlx_vlan_rx_register;
++#ifdef CONFIG_NET_POLL_CONTROLLER
++	netdev->poll_controller = atl1_poll_controller;
++#endif
 +#endif
  	netdev->watchdog_timeo = 5 * HZ;
  
@@ -739,7 +754,7 @@ diff -Nur a/net/bluetooth/bnep/netdev.c b/net/bluetooth/bnep/netdev.c
  
  /*
   * atl2_probe - Device Initialization Routine
-@@ -1395,7 +1397,17 @@ static int __devinit atl2_probe(struct p
+@@ -1395,7 +1397,22 @@ static int __devinit atl2_probe(struct p
  
  	atl2_setup_pcicmd(pdev);
  
@@ -753,6 +768,11 @@ diff -Nur a/net/bluetooth/bnep/netdev.c b/net/bluetooth/bnep/netdev.c
 +	netdev->tx_timeout = atl2_tx_timeout;
 +	netdev->set_mac_address = atl2_set_mac;
 +	netdev->do_ioctl = atl2_ioctl;
++	netdev->set_multicast_list = atl2_set_multi;
++	netdev->vlan_rx_register = atl2_vlan_rx_register;
++#ifdef CONFIG_NET_POLL_CONTROLLER
++	netdev->poll_controller = atl2_poll_controller;
++#endif
 +#endif
  	atl2_set_ethtool_ops(netdev);
  	netdev->watchdog_timeo = 5 * HZ;
-- 
1.6.3.3

