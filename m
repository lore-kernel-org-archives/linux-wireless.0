Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:56418 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936352AbZDITyT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Apr 2009 15:54:19 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] [compat-2.6]: Sync compat.diff with new wireless-testing master-2009-04-08. Most parts are backporting net_device_ops parts in drivers to older versions. This is working with kernel 2.6.27 and building at least with kernel 2.6.27 to 2.6.29.
Date: Thu,  9 Apr 2009 21:54:10 +0200
Message-Id: <1239306851-25030-1-git-send-email-hauke@hauke-m.de> (sfid-20090409_215426_365061_424B19D3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat.diff |  375 ++++++++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 320 insertions(+), 55 deletions(-)

diff --git a/compat/compat.diff b/compat/compat.diff
index f0ea11f..3a694c6 100644
--- a/compat/compat.diff
+++ b/compat/compat.diff
@@ -1,13 +1,13 @@
 --- a/include/net/cfg80211.h	2009-02-13 14:28:03.000000000 -0800
 +++ b/include/net/cfg80211.h	2009-02-13 14:28:04.000000000 -0800
-@@ -11,6 +11,7 @@
- #include <net/genetlink.h>
- /* remove once we remove the wext stuff */
+@@ -9,6 +9,7 @@
+ #include <linux/wireless.h>
  #include <net/iw_handler.h>
+ #include <net/genetlink.h>
 +#include <net/compat.h>
+ /* remove once we remove the wext stuff */
  
  /*
-  * 802.11 configuration in-kernel interface
 --- a/net/wireless/Makefile	2008-10-27 19:54:52.000000000 +0100
 +++ b/net/wireless/Makefile	2008-10-27 19:54:53.000000000 +0100
 @@ -1,11 +1,10 @@
@@ -47,6 +47,66 @@
 -obj-$(CONFIG_USB_NET_MCS7830)	+= mcs7830.o
  obj-$(CONFIG_USB_USBNET)	+= usbnet.o
  
+--- a/drivers/net/usb/rndis_host.c
++++ b/drivers/net/usb/rndis_host.c
+@@ -266,6 +266,7 @@ response_error:
+ 	return -EDOM;
+ }
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+ /* same as usbnet_netdev_ops but MTU change not allowed */
+ static const struct net_device_ops rndis_netdev_ops = {
+ 	.ndo_open		= usbnet_open,
+@@ -275,6 +276,7 @@ static const struct net_device_ops rndis_netdev_ops = {
+ 	.ndo_set_mac_address 	= eth_mac_addr,
+ 	.ndo_validate_addr	= eth_validate_addr,
+ };
++#endif
+ 
+ int
+ generic_rndis_bind(struct usbnet *dev, struct usb_interface *intf, int flags)
+@@ -337,7 +339,11 @@ generic_rndis_bind(struct usbnet *dev, struct usb_interface *intf, int flags)
+ 	dev->rx_urb_size &= ~(dev->maxpacket - 1);
+ 	u.init->max_transfer_size = cpu_to_le32(dev->rx_urb_size);
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+ 	net->netdev_ops = &rndis_netdev_ops;
++#else
++	net->change_mtu = NULL;
++#endif
+ 
+ 	retval = rndis_command(dev, u.header, CONTROL_BUFFER_SIZE);
+ 	if (unlikely(retval < 0)) {
+--- a/drivers/net/usb/usbnet.c
++++ b/drivers/net/usb/usbnet.c
+@@ -1106,6 +1106,7 @@ void usbnet_disconnect (struct usb_interface *intf)
+ }
+ EXPORT_SYMBOL_GPL(usbnet_disconnect);
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+ static const struct net_device_ops usbnet_netdev_ops = {
+ 	.ndo_open		= usbnet_open,
+ 	.ndo_stop		= usbnet_stop,
+@@ -1115,6 +1116,7 @@ static const struct net_device_ops usbnet_netdev_ops = {
+ 	.ndo_set_mac_address 	= eth_mac_addr,
+ 	.ndo_validate_addr	= eth_validate_addr,
+ };
++#endif
+ 
+ /*-------------------------------------------------------------------------*/
+ 
+@@ -1184,8 +1186,10 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
+ 		net->features |= NETIF_F_HIGHDMA;
+ #endif
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+ 	net->netdev_ops = &usbnet_netdev_ops;
+-#ifdef CONFIG_COMPAT_NET_DEV_OPS
++#else
++	net->change_mtu = usbnet_change_mtu;
+ 	net->hard_start_xmit = usbnet_start_xmit;
+ 	net->open = usbnet_open;
+ 	net->stop = usbnet_stop;
 diff --git a/drivers/net/wireless/b43/pcmcia.c b/drivers/net/wireless/b43/pcmcia.c
 index 3cfc303..33c76b0 100644
 --- a/drivers/net/wireless/b43/pcmcia.c
@@ -63,6 +123,105 @@ index 3cfc303..33c76b0 100644
  	if (res != 0)
  		goto err_kfree_ssb;
  
+--- a/drivers/net/wireless/ipw2x00/ipw2100.c
++++ b/drivers/net/wireless/ipw2x00/ipw2100.c
+@@ -6008,6 +6008,7 @@ static void ipw2100_rf_kill(struct work_struct *work)
+ 
+ static void ipw2100_irq_tasklet(struct ipw2100_priv *priv);
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+ static const struct net_device_ops ipw2100_netdev_ops = {
+ 	.ndo_open		= ipw2100_open,
+ 	.ndo_stop		= ipw2100_close,
+@@ -6018,6 +6019,7 @@ static const struct net_device_ops ipw2100_netdev_ops = {
+ 	.ndo_set_mac_address	= ipw2100_set_address,
+ 	.ndo_validate_addr	= eth_validate_addr,
+ };
++#endif
+ 
+ /* Look into using netdev destructor to shutdown ieee80211? */
+ 
+@@ -6043,7 +6045,16 @@ static struct net_device *ipw2100_alloc_device(struct pci_dev *pci_dev,
+ 	priv->ieee->perfect_rssi = -20;
+ 	priv->ieee->worst_rssi = -85;
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+ 	dev->netdev_ops = &ipw2100_netdev_ops;
++#else
++	dev->open = ipw2100_open;
++	dev->stop = ipw2100_close;
++	dev->init = ipw2100_net_init;
++	dev->tx_timeout = ipw2100_tx_timeout;
++	dev->set_mac_address = ipw2100_set_address;
++#endif
++
+ 	dev->ethtool_ops = &ipw2100_ethtool_ops;
+ 	dev->wireless_handlers = &ipw2100_wx_handler_def;
+ 	priv->wireless_data.ieee80211 = priv->ieee;
+--- a/drivers/net/wireless/ipw2x00/ipw2200.c
++++ b/drivers/net/wireless/ipw2x00/ipw2200.c
+@@ -11529,6 +11529,7 @@ static int ipw_prom_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
+ 	return -EOPNOTSUPP;
+ }
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+ static const struct net_device_ops ipw_prom_netdev_ops = {
+ 	.ndo_open 		= ipw_prom_open,
+ 	.ndo_stop		= ipw_prom_stop,
+@@ -11537,6 +11538,7 @@ static const struct net_device_ops ipw_prom_netdev_ops = {
+ 	.ndo_set_mac_address 	= eth_mac_addr,
+ 	.ndo_validate_addr	= eth_validate_addr,
+ };
++#endif
+ 
+ static int ipw_prom_alloc(struct ipw_priv *priv)
+ {
+@@ -11557,7 +11559,13 @@ static int ipw_prom_alloc(struct ipw_priv *priv)
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
+@@ -11585,6 +11593,7 @@ static void ipw_prom_free(struct ipw_priv *priv)
+ 
+ #endif
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+ static const struct net_device_ops ipw_netdev_ops = {
+ 	.ndo_init		= ipw_net_init,
+ 	.ndo_open		= ipw_net_open,
+@@ -11595,6 +11604,7 @@ static const struct net_device_ops ipw_netdev_ops = {
+ 	.ndo_change_mtu		= ieee80211_change_mtu,
+ 	.ndo_validate_addr	= eth_validate_addr,
+ };
++#endif
+ 
+ static int __devinit ipw_pci_probe(struct pci_dev *pdev,
+ 				   const struct pci_device_id *ent)
+@@ -11696,7 +11706,15 @@ static int __devinit ipw_pci_probe(struct pci_dev *pdev,
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
 diff --git a/drivers/net/wireless/libertas/if_cs.c b/drivers/net/wireless/libertas/if_cs.c
 index 842a08d..079c1fd 100644
 --- a/drivers/net/wireless/libertas/if_cs.c
@@ -79,6 +238,156 @@ index 842a08d..079c1fd 100644
  	{
  		lbs_pr_err("error in pcmcia_get_first_tuple etc\n");
  		goto out1;
+--- a/drivers/net/wireless/libertas/main.c
++++ b/drivers/net/wireless/libertas/main.c
+@@ -1148,6 +1148,7 @@ static void lbs_free_adapter(struct lbs_private *priv)
+ 	lbs_deb_leave(LBS_DEB_MAIN);
+ }
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+ static const struct net_device_ops lbs_netdev_ops = {
+ 	.ndo_open 		= lbs_dev_open,
+ 	.ndo_stop		= lbs_eth_stop,
+@@ -1158,6 +1159,7 @@ static const struct net_device_ops lbs_netdev_ops = {
+ 	.ndo_change_mtu		= eth_change_mtu,
+ 	.ndo_validate_addr	= eth_validate_addr,
+ };
++#endif
+ 
+ /**
+  * @brief This function adds the card. it will probe the
+@@ -1193,7 +1195,16 @@ struct lbs_private *lbs_add_card(void *card, struct device *dmdev)
+ 	priv->infra_open = 0;
+ 
+ 	/* Setup the OS Interface to our functions */
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+  	dev->netdev_ops = &lbs_netdev_ops;
++#else
++	dev->open = lbs_dev_open;
++	dev->hard_start_xmit = lbs_hard_start_xmit;
++	dev->stop = lbs_eth_stop;
++	dev->set_mac_address = lbs_set_mac_address;
++	dev->tx_timeout = lbs_tx_timeout;
++	dev->set_multicast_list = lbs_set_multicast_list;
++#endif
+ 	dev->watchdog_timeo = 5 * HZ;
+ 	dev->ethtool_ops = &lbs_ethtool_ops;
+ #ifdef	WIRELESS_EXT
+@@ -1419,6 +1430,7 @@ out:
+ EXPORT_SYMBOL_GPL(lbs_stop_card);
+ 
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+ static const struct net_device_ops mesh_netdev_ops = {
+ 	.ndo_open		= lbs_dev_open,
+ 	.ndo_stop 		= lbs_mesh_stop,
+@@ -1426,6 +1438,7 @@ static const struct net_device_ops mesh_netdev_ops = {
+ 	.ndo_set_mac_address	= lbs_set_mac_address,
+ 	.ndo_set_multicast_list = lbs_set_multicast_list,
+ };
++#endif
+ 
+ /**
+  * @brief This function adds mshX interface
+@@ -1449,7 +1462,15 @@ static int lbs_add_mesh(struct lbs_private *priv)
+ 	mesh_dev->ml_priv = priv;
+ 	priv->mesh_dev = mesh_dev;
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+ 	mesh_dev->netdev_ops = &mesh_netdev_ops;
++#else
++	mesh_dev->open = lbs_dev_open;
++	mesh_dev->hard_start_xmit = lbs_hard_start_xmit;
++	mesh_dev->stop = lbs_mesh_stop;
++	mesh_dev->set_mac_address = lbs_set_mac_address;
++	mesh_dev->set_multicast_list = lbs_set_multicast_list;
++#endif
+ 	mesh_dev->ethtool_ops = &lbs_ethtool_ops;
+ 	memcpy(mesh_dev->dev_addr, priv->dev->dev_addr,
+ 			sizeof(priv->dev->dev_addr));
+@@ -1664,11 +1685,13 @@ out:
+ 	lbs_deb_leave(LBS_DEB_MAIN);
+ }
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+ static const struct net_device_ops rtap_netdev_ops = {
+ 	.ndo_open = lbs_rtap_open,
+ 	.ndo_stop = lbs_rtap_stop,
+ 	.ndo_start_xmit = lbs_rtap_hard_start_xmit,
+ };
++#endif
+ 
+ static int lbs_add_rtap(struct lbs_private *priv)
+ {
+@@ -1689,7 +1712,13 @@ static int lbs_add_rtap(struct lbs_private *priv)
+ 
+ 	memcpy(rtap_dev->dev_addr, priv->current_addr, ETH_ALEN);
+ 	rtap_dev->type = ARPHRD_IEEE80211_RADIOTAP;
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+ 	rtap_dev->netdev_ops = &rtap_netdev_ops;
++#else
++	rtap_dev->open = lbs_rtap_open;
++	rtap_dev->stop = lbs_rtap_stop;
++	rtap_dev->hard_start_xmit = lbs_rtap_hard_start_xmit;
++#endif
+ 	rtap_dev->ml_priv = priv;
+ 	SET_NETDEV_DEV(rtap_dev, priv->dev->dev.parent);
+ 
+--- a/drivers/net/wireless/mac80211_hwsim.c
++++ b/drivers/net/wireless/mac80211_hwsim.c
+@@ -739,16 +739,22 @@ static struct device_driver mac80211_hwsim_driver = {
+ 	.name = "mac80211_hwsim"
+ };
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+ static const struct net_device_ops hwsim_netdev_ops = {
+ 	.ndo_start_xmit 	= hwsim_mon_xmit,
+ 	.ndo_change_mtu		= eth_change_mtu,
+ 	.ndo_set_mac_address 	= eth_mac_addr,
+ 	.ndo_validate_addr	= eth_validate_addr,
+ };
++#endif
+ 
+ static void hwsim_mon_setup(struct net_device *dev)
+ {
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+ 	dev->netdev_ops = &hwsim_netdev_ops;
++#else
++	dev->hard_start_xmit = hwsim_mon_xmit;
++#endif
+ 	dev->destructor = free_netdev;
+ 	ether_setup(dev);
+ 	dev->tx_queue_len = 0;
+--- a/drivers/net/wireless/rndis_wlan.c
++++ b/drivers/net/wireless/rndis_wlan.c
+@@ -2524,6 +2524,7 @@ static int bcm4320_early_init(struct usbnet *usbdev)
+ 	return 0;
+ }
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+ /* same as rndis_netdev_ops but with local multicast handler */
+ static const struct net_device_ops rndis_wext_netdev_ops = {
+ 	.ndo_open		= usbnet_open,
+@@ -2534,6 +2535,7 @@ static const struct net_device_ops rndis_wext_netdev_ops = {
+ 	.ndo_validate_addr	= eth_validate_addr,
+ 	.ndo_set_multicast_list	= rndis_wext_set_multicast_list,
+ };
++#endif
+ 
+ 
+ static int rndis_wext_bind(struct usbnet *usbdev, struct usb_interface *intf)
+@@ -2570,7 +2572,11 @@ static int rndis_wext_bind(struct usbnet *usbdev, struct usb_interface *intf)
+ 	 * rndis_host wants to avoid all OID as much as possible
+ 	 * so do promisc/multicast handling in rndis_wext.
+ 	 */
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+ 	usbdev->net->netdev_ops = &rndis_wext_netdev_ops;
++#else
++	usbdev->net->set_multicast_list = rndis_wext_set_multicast_list;
++#endif
+ 
+ 	tmp = RNDIS_PACKET_TYPE_DIRECTED | RNDIS_PACKET_TYPE_BROADCAST;
+ 	retval = rndis_set_oid(usbdev, OID_GEN_CURRENT_PACKET_FILTER, &tmp,
 diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
 index a0c860f..9c6f214 100644
 --- a/net/mac80211/wme.c
@@ -154,7 +463,7 @@ index a0c860f..9c6f214 100644
  obj-$(CONFIG_EEPROM_93CX6)	+= eeprom_93cx6.o
 --- a/net/mac80211/rx.c	2009-02-10 23:51:58.000000000 -0800
 +++ b/net/mac80211/rx.c	2009-02-10 23:52:04.000000000 -0800
-@@ -805,12 +805,17 @@
+@@ -806,12 +806,17 @@
  
  	/* Send all buffered frames to the station */
  	while ((skb = skb_dequeue(&sta->tx_filtered)) != NULL) {
@@ -172,7 +481,7 @@ index a0c860f..9c6f214 100644
  		sent++;
  #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
  		printk(KERN_DEBUG "%s: STA %pM aid %d send PS frame "
-@@ -819,6 +824,9 @@
+@@ -820,6 +825,9 @@
  #endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
  		skb->requeue = 1;
  		dev_queue_xmit(skb);
@@ -184,51 +493,7 @@ index a0c860f..9c6f214 100644
  	return sent;
 --- a/drivers/net/b44.c	2009-01-22 07:52:14.000000000 -0800
 +++ b/drivers/net/b44.c	2009-01-22 07:52:14.000000000 -0800
-@@ -846,6 +846,9 @@
- static int b44_poll(struct napi_struct *napi, int budget)
- {
- 	struct b44 *bp = container_of(napi, struct b44, napi);
-+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29))
-+	struct net_device *netdev = bp->dev;
-+#endif
- 	int work_done;
- 
- 	spin_lock_irq(&bp->lock);
-@@ -874,7 +877,11 @@
- 	}
- 
- 	if (work_done < budget) {
-+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29))
-+		netif_rx_complete(netdev, napi);
-+#else
- 		netif_rx_complete(napi);
-+#endif
- 		b44_enable_ints(bp);
- 	}
- 
-@@ -906,13 +913,21 @@
- 			goto irq_ack;
- 		}
- 
-+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29))
-+		if (netif_rx_schedule_prep(dev, &bp->napi)) {
-+#else
- 		if (netif_rx_schedule_prep(&bp->napi)) {
-+#endif
- 			/* NOTE: These writes are posted by the readback of
- 			 *       the ISTAT register below.
- 			 */
- 			bp->istat = istat;
- 			__b44_disable_ints(bp);
-+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29))
-+			__netif_rx_schedule(dev, &bp->napi);
-+#else
- 			__netif_rx_schedule(&bp->napi);
-+#endif
- 		} else {
- 			printk(KERN_ERR PFX "%s: Error, poll already scheduled\n",
- 			       dev->name);
-@@ -2112,6 +2127,7 @@
+@@ -2112,6 +2112,7 @@
  	return err;
  }
  
@@ -236,7 +501,7 @@ index a0c860f..9c6f214 100644
  static const struct net_device_ops b44_netdev_ops = {
  	.ndo_open		= b44_open,
  	.ndo_stop		= b44_close,
-@@ -2127,6 +2143,7 @@
+@@ -2127,6 +2128,7 @@
  	.ndo_poll_controller	= b44_poll_controller,
  #endif
  };
@@ -244,7 +509,7 @@ index a0c860f..9c6f214 100644
  
  static int __devinit b44_init_one(struct ssb_device *sdev,
  				  const struct ssb_device_id *ent)
-@@ -2166,9 +2183,26 @@
+@@ -2166,9 +2168,26 @@
  	bp->rx_pending = B44_DEF_RX_RING_PENDING;
  	bp->tx_pending = B44_DEF_TX_RING_PENDING;
  
@@ -357,7 +622,7 @@ index a0c860f..9c6f214 100644
  
  #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
  	if (net_ratelimit())
-@@ -796,6 +798,7 @@
+@@ -811,6 +813,7 @@
  }
  EXPORT_SYMBOL(ieee80211_alloc_hw);
  
@@ -365,7 +630,7 @@ index a0c860f..9c6f214 100644
  static const struct net_device_ops ieee80211_master_ops = {
  	.ndo_start_xmit = ieee80211_master_start_xmit,
  	.ndo_open = ieee80211_master_open,
-@@ -803,12 +806,22 @@
+@@ -818,12 +821,22 @@
  	.ndo_set_multicast_list = ieee80211_master_set_multicast_list,
  	.ndo_select_queue = ieee80211_select_queue,
  };
-- 
1.6.2.1

