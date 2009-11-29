Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:56363 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624AbZK2WoY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Nov 2009 17:44:24 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, pat-lkml@erley.org,
	hintak.leung@gmail.com, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] [compat-2.6] Fix build problem.
Date: Sun, 29 Nov 2009 23:44:16 +0100
Message-Id: <1259534657-29043-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The mesh device in libertas uses the method lbs_mesh_dev_open and not lbs_dev_open
Add backport code for libipw_module.c

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
The older patch send by me does not apply, because I had some
problems with my local git tree.
 compat/patches/01-netdev.patch |   67 ++++++++++++++++++++++++----------------
 1 files changed, 40 insertions(+), 27 deletions(-)

diff --git a/compat/patches/01-netdev.patch b/compat/patches/01-netdev.patch
index 8286bb8..b66e9b0 100644
--- a/compat/patches/01-netdev.patch
+++ b/compat/patches/01-netdev.patch
@@ -72,7 +72,7 @@ without creating a headache on maintenance of the pathes.
  
 --- a/drivers/net/wireless/rndis_wlan.c	2009-09-02 14:08:52.418110490 -0700
 +++ b/drivers/net/wireless/rndis_wlan.c	2009-09-02 14:08:52.930092180 -0700
-@@ -2669,6 +2669,7 @@
+@@ -2670,6 +2670,7 @@
  	return 0;
  }
  
@@ -80,7 +80,7 @@ without creating a headache on maintenance of the pathes.
  /* same as rndis_netdev_ops but with local multicast handler */
  static const struct net_device_ops rndis_wlan_netdev_ops = {
  	.ndo_open		= usbnet_open,
-@@ -2679,6 +2680,7 @@
+@@ -2680,6 +2681,7 @@
  	.ndo_validate_addr	= eth_validate_addr,
  	.ndo_set_multicast_list	= rndis_wlan_set_multicast_list,
  };
@@ -88,7 +88,7 @@ without creating a headache on maintenance of the pathes.
  
  static int rndis_wlan_bind(struct usbnet *usbdev, struct usb_interface *intf)
  {
-@@ -2726,7 +2728,11 @@
+@@ -2727,7 +2729,11 @@
  	 * rndis_host wants to avoid all OID as much as possible
  	 * so do promisc/multicast handling in rndis_wlan.
  	 */
@@ -284,7 +284,7 @@ without creating a headache on maintenance of the pathes.
  }
  EXPORT_SYMBOL(wireless_send_event);
  
-@@ -901,8 +930,13 @@
+@@ -902,8 +931,13 @@
  			return private(dev, iwr, cmd, info, handler);
  	}
  	/* Old driver API : call driver ioctl handler */
@@ -300,7 +300,7 @@ without creating a headache on maintenance of the pathes.
  
 --- a/drivers/net/wireless/ipw2x00/ipw2100.c	2009-09-02 14:12:00.958117808 -0700
 +++ b/drivers/net/wireless/ipw2x00/ipw2100.c	2009-09-02 14:12:01.382115761 -0700
-@@ -6008,6 +6008,7 @@
+@@ -6091,6 +6091,7 @@
  
  static void ipw2100_irq_tasklet(struct ipw2100_priv *priv);
  
@@ -308,7 +308,7 @@ without creating a headache on maintenance of the pathes.
  static const struct net_device_ops ipw2100_netdev_ops = {
  	.ndo_open		= ipw2100_open,
  	.ndo_stop		= ipw2100_close,
-@@ -6018,6 +6019,7 @@
+@@ -6101,6 +6102,7 @@
  	.ndo_set_mac_address	= ipw2100_set_address,
  	.ndo_validate_addr	= eth_validate_addr,
  };
@@ -316,7 +316,7 @@ without creating a headache on maintenance of the pathes.
  
  /* Look into using netdev destructor to shutdown ieee80211? */
  
-@@ -6043,7 +6045,16 @@
+@@ -6126,7 +6128,16 @@
  	priv->ieee->perfect_rssi = -20;
  	priv->ieee->worst_rssi = -85;
  
@@ -335,7 +335,7 @@ without creating a headache on maintenance of the pathes.
  	priv->wireless_data.libipw = priv->ieee;
 --- a/drivers/net/wireless/ipw2x00/ipw2200.c	2009-11-13 11:37:43.000000000 -0800
 +++ b/drivers/net/wireless/ipw2x00/ipw2200.c	2009-11-13 11:37:43.000000000 -0800
-@@ -11546,6 +11546,7 @@
+@@ -11635,6 +11635,7 @@
  	return NETDEV_TX_OK;
  }
  
@@ -343,7 +343,7 @@ without creating a headache on maintenance of the pathes.
  static const struct net_device_ops ipw_prom_netdev_ops = {
  	.ndo_open 		= ipw_prom_open,
  	.ndo_stop		= ipw_prom_stop,
-@@ -11554,6 +11555,7 @@
+@@ -11643,6 +11644,7 @@
  	.ndo_set_mac_address 	= eth_mac_addr,
  	.ndo_validate_addr	= eth_validate_addr,
  };
@@ -351,7 +351,7 @@ without creating a headache on maintenance of the pathes.
  
  static int ipw_prom_alloc(struct ipw_priv *priv)
  {
-@@ -11574,7 +11576,13 @@
+@@ -11663,7 +11665,13 @@
  	memcpy(priv->prom_net_dev->dev_addr, priv->mac_addr, ETH_ALEN);
  
  	priv->prom_net_dev->type = ARPHRD_IEEE80211_RADIOTAP;
@@ -365,7 +365,7 @@ without creating a headache on maintenance of the pathes.
  
  	priv->prom_priv->ieee->iw_mode = IW_MODE_MONITOR;
  	SET_NETDEV_DEV(priv->prom_net_dev, &priv->pci_dev->dev);
-@@ -11602,6 +11610,7 @@
+@@ -11691,6 +11699,7 @@
  
  #endif
  
@@ -373,7 +373,7 @@ without creating a headache on maintenance of the pathes.
  static const struct net_device_ops ipw_netdev_ops = {
  	.ndo_init		= ipw_net_init,
  	.ndo_open		= ipw_net_open,
-@@ -11612,6 +11621,7 @@
+@@ -11701,6 +11710,7 @@
  	.ndo_change_mtu		= libipw_change_mtu,
  	.ndo_validate_addr	= eth_validate_addr,
  };
@@ -381,7 +381,7 @@ without creating a headache on maintenance of the pathes.
  
  static int __devinit ipw_pci_probe(struct pci_dev *pdev,
  				   const struct pci_device_id *ent)
-@@ -11713,7 +11723,15 @@
+@@ -11802,7 +11812,15 @@
  	priv->ieee->perfect_rssi = -20;
  	priv->ieee->worst_rssi = -85;
  
@@ -397,9 +397,22 @@ without creating a headache on maintenance of the pathes.
  	priv->wireless_data.spy_data = &priv->ieee->spy_data;
  	net_dev->wireless_data = &priv->wireless_data;
  	net_dev->wireless_handlers = &ipw_wx_handler_def;
+--- a/drivers/net/wireless/ipw2x00/libipw_module.c
++++ b/drivers/net/wireless/ipw2x00/libipw_module.c
+@@ -157,6 +157,10 @@
+ 		goto failed;
+ 	}
+ 	ieee = netdev_priv(dev);
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29))
++	dev->hard_start_xmit = libipw_xmit;
++	dev->change_mtu = libipw_change_mtu;
++#endif
+ 
+ 	ieee->dev = dev;
+ 
 --- a/drivers/net/wireless/libertas/main.c	2009-11-02 08:04:43.000000000 -0800
 +++ b/drivers/net/wireless/libertas/main.c	2009-11-02 08:04:44.000000000 -0800
-@@ -1109,6 +1109,7 @@
+@@ -911,6 +911,7 @@
  	lbs_deb_leave(LBS_DEB_MAIN);
  }
  
@@ -407,7 +420,7 @@ without creating a headache on maintenance of the pathes.
  static const struct net_device_ops lbs_netdev_ops = {
  	.ndo_open 		= lbs_dev_open,
  	.ndo_stop		= lbs_eth_stop,
-@@ -1119,6 +1120,7 @@
+@@ -921,6 +922,7 @@
  	.ndo_change_mtu		= eth_change_mtu,
  	.ndo_validate_addr	= eth_validate_addr,
  };
@@ -415,7 +428,7 @@ without creating a headache on maintenance of the pathes.
  
  /**
   * @brief This function adds the card. it will probe the
-@@ -1164,7 +1166,16 @@
+@@ -966,7 +968,16 @@
  	wdev->netdev = dev;
  	priv->dev = dev;
  
@@ -432,7 +445,7 @@ without creating a headache on maintenance of the pathes.
  	dev->watchdog_timeo = 5 * HZ;
  	dev->ethtool_ops = &lbs_ethtool_ops;
  #ifdef	WIRELESS_EXT
-@@ -1589,11 +1610,13 @@
+@@ -1262,11 +1273,13 @@
  	lbs_deb_leave(LBS_DEB_MAIN);
  }
  
@@ -446,7 +459,7 @@ without creating a headache on maintenance of the pathes.
  
  static int lbs_add_rtap(struct lbs_private *priv)
  {
-@@ -1614,7 +1637,13 @@
+@@ -1287,7 +1300,13 @@
  
  	memcpy(rtap_dev->dev_addr, priv->current_addr, ETH_ALEN);
  	rtap_dev->type = ARPHRD_IEEE80211_RADIOTAP;
@@ -460,17 +473,17 @@ without creating a headache on maintenance of the pathes.
  	rtap_dev->ml_priv = priv;
  	SET_NETDEV_DEV(rtap_dev, priv->dev->dev.parent);
  
---- a/drivers/net/wireless/libertas/mesh.c	2009-11-02 08:04:43.000000000 -0800
-+++ b/drivers/net/wireless/libertas/mesh.c	2009-11-02 08:04:44.000000000 -0800
-@@ -305,6 +316,7 @@
- EXPORT_SYMBOL_GPL(lbs_stop_card);
- 
+--- a/drivers/net/wireless/libertas/mesh.c
++++ b/drivers/net/wireless/libertas/mesh.c
+@@ -318,6 +318,7 @@
+ 	return ret;
+ }
  
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
  static const struct net_device_ops mesh_netdev_ops = {
- 	.ndo_open		= lbs_dev_open,
+ 	.ndo_open		= lbs_mesh_dev_open,
  	.ndo_stop 		= lbs_mesh_stop,
-@@ -312,6 +324,7 @@
+@@ -325,6 +326,7 @@
  	.ndo_set_mac_address	= lbs_set_mac_address,
  	.ndo_set_multicast_list = lbs_set_multicast_list,
  };
@@ -478,14 +491,14 @@ without creating a headache on maintenance of the pathes.
  
  /**
   * @brief This function adds mshX interface
-@@ -335,7 +348,15 @@
+@@ -349,7 +351,15 @@
  	mesh_dev->ml_priv = priv;
  	priv->mesh_dev = mesh_dev;
  
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
  	mesh_dev->netdev_ops = &mesh_netdev_ops;
 +#else
-+	mesh_dev->open = lbs_dev_open;
++	mesh_dev->open = lbs_mesh_dev_open;
 +	mesh_dev->hard_start_xmit = lbs_hard_start_xmit;
 +	mesh_dev->stop = lbs_mesh_stop;
 +	mesh_dev->set_mac_address = lbs_set_mac_address;
-- 
1.6.3.3

