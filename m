Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:57915 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbZICOcB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Sep 2009 10:32:01 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [compat-2.6] readd netdev_ops backport to ipw2200.c
Date: Thu,  3 Sep 2009 16:31:56 +0200
Message-Id: <1251988316-30031-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes building of ipw2200.c for kernel < 2.6.29.
It was introduced in 203a12ff5a432e2ee4a83b38e698bff0dd4efead

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/patches/01-netdev.patch |   64 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 64 insertions(+), 0 deletions(-)

diff --git a/compat/patches/01-netdev.patch b/compat/patches/01-netdev.patch
index 767bcc9..6d37bb7 100644
--- a/compat/patches/01-netdev.patch
+++ b/compat/patches/01-netdev.patch
@@ -333,6 +333,70 @@ without creating a headache on maintenance of the pathes.
  	dev->ethtool_ops = &ipw2100_ethtool_ops;
  	dev->wireless_handlers = &ipw2100_wx_handler_def;
  	priv->wireless_data.libipw = priv->ieee;
+--- a/drivers/net/wireless/ipw2x00/ipw2200.c	2009-08-20 13:47:07.311291621 -0700
++++ b/drivers/net/wireless/ipw2x00/ipw2200.c	2009-08-20 13:47:07.783268230 -0700
+@@ -11623,6 +11623,7 @@
+ 	return NETDEV_TX_OK;
+ }
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+ static const struct net_device_ops ipw_prom_netdev_ops = {
+ 	.ndo_open 		= ipw_prom_open,
+ 	.ndo_stop		= ipw_prom_stop,
+@@ -11631,6 +11632,7 @@
+ 	.ndo_set_mac_address 	= eth_mac_addr,
+ 	.ndo_validate_addr	= eth_validate_addr,
+ };
++#endif
+ 
+ static int ipw_prom_alloc(struct ipw_priv *priv)
+ {
+@@ -11651,7 +11653,13 @@
+ 	memcpy(priv->prom_net_dev->dev_addr, priv->mac_addr, ETH_ALEN);
+ 
+ 	priv->prom_net_dev->type = ARPHRD_IEEE80211_RADIOTAP;
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+ 	priv->prom_net_dev->netdev_ops = &ipw_prom_netdev_ops;
++#else
++	priv->prom_net_dev->open = ipw_prom_open;
++	priv->prom_net_dev->stop = ipw_prom_stop;
++	priv->prom_net_dev->hard_start_xmit = ipw_prom_hard_start_xmit;
++#endif
+ 
+ 	priv->prom_priv->ieee->iw_mode = IW_MODE_MONITOR;
+ 	SET_NETDEV_DEV(priv->prom_net_dev, &priv->pci_dev->dev);
+@@ -11679,6 +11687,7 @@
+ 
+ #endif
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+ static const struct net_device_ops ipw_netdev_ops = {
+ 	.ndo_init		= ipw_net_init,
+ 	.ndo_open		= ipw_net_open,
+@@ -11689,6 +11698,7 @@
+ 	.ndo_change_mtu		= libipw_change_mtu,
+ 	.ndo_validate_addr	= eth_validate_addr,
+ };
++#endif
+ 
+ static int __devinit ipw_pci_probe(struct pci_dev *pdev,
+ 				   const struct pci_device_id *ent)
+@@ -11790,7 +11800,15 @@
+ 	priv->ieee->perfect_rssi = -20;
+ 	priv->ieee->worst_rssi = -85;
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+ 	net_dev->netdev_ops = &ipw_netdev_ops;
++#else
++	net_dev->open = ipw_net_open;
++	net_dev->stop = ipw_net_stop;
++	net_dev->init = ipw_net_init;
++	net_dev->set_multicast_list = ipw_net_set_multicast_list;
++	net_dev->set_mac_address = ipw_net_set_mac_address;
++#endif
+ 	priv->wireless_data.spy_data = &priv->ieee->spy_data;
+ 	net_dev->wireless_data = &priv->wireless_data;
+ 	net_dev->wireless_handlers = &ipw_wx_handler_def;
 --- a/drivers/net/wireless/libertas/main.c	2009-08-18 16:17:34.669375612 -0700
 +++ b/drivers/net/wireless/libertas/main.c	2009-08-18 16:17:35.277375431 -0700
 @@ -1148,6 +1148,7 @@
-- 
1.6.2.1

