Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:56413 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936345AbZDITyS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Apr 2009 15:54:18 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] [compat-2.6] Sorted compat.diff with the help of git. The content of compat.diff was only sorted with this patch there are no really changes to it.
Date: Thu,  9 Apr 2009 21:54:11 +0200
Message-Id: <1239306851-25030-2-git-send-email-hauke@hauke-m.de> (sfid-20090409_215425_669866_A84D60DB)
In-Reply-To: <1239306851-25030-1-git-send-email-hauke@hauke-m.de>
References: <1239306851-25030-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat.diff |  378 ++++++++++++++++++++++++++--------------------------
 1 files changed, 186 insertions(+), 192 deletions(-)

diff --git a/compat/compat.diff b/compat/compat.diff
index 3a694c6..9476083 100644
--- a/compat/compat.diff
+++ b/compat/compat.diff
@@ -1,30 +1,57 @@
---- a/include/net/cfg80211.h	2009-02-13 14:28:03.000000000 -0800
-+++ b/include/net/cfg80211.h	2009-02-13 14:28:04.000000000 -0800
-@@ -9,6 +9,7 @@
- #include <linux/wireless.h>
- #include <net/iw_handler.h>
- #include <net/genetlink.h>
-+#include <net/compat.h>
- /* remove once we remove the wext stuff */
+--- a/drivers/misc/eeprom/Makefile
++++ b/drivers/misc/eeprom/Makefile
+@@ -1,4 +1 @@
+-obj-$(CONFIG_EEPROM_AT24)	+= at24.o
+-obj-$(CONFIG_EEPROM_AT25)	+= at25.o
+-obj-$(CONFIG_EEPROM_LEGACY)	+= eeprom.o
+ obj-$(CONFIG_EEPROM_93CX6)	+= eeprom_93cx6.o
+--- a/drivers/net/b44.c
++++ b/drivers/net/b44.c
+@@ -2112,6 +2112,7 @@ static int __devinit b44_get_invariants(struct b44 *bp)
+ 	return err;
+ }
  
- /*
---- a/net/wireless/Makefile	2008-10-27 19:54:52.000000000 +0100
-+++ b/net/wireless/Makefile	2008-10-27 19:54:53.000000000 +0100
-@@ -1,11 +1,10 @@
--obj-$(CONFIG_WIRELESS_EXT) += wext.o
- obj-$(CONFIG_CFG80211) += cfg80211.o
- obj-$(CONFIG_LIB80211) += lib80211.o
- obj-$(CONFIG_LIB80211_CRYPT_WEP) += lib80211_crypt_wep.o
- obj-$(CONFIG_LIB80211_CRYPT_CCMP) += lib80211_crypt_ccmp.o
- obj-$(CONFIG_LIB80211_CRYPT_TKIP) += lib80211_crypt_tkip.o
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+ static const struct net_device_ops b44_netdev_ops = {
+ 	.ndo_open		= b44_open,
+ 	.ndo_stop		= b44_close,
+@@ -2127,6 +2128,7 @@ static const struct net_device_ops b44_netdev_ops = {
+ 	.ndo_poll_controller	= b44_poll_controller,
+ #endif
+ };
++#endif
  
--cfg80211-y += core.o sysfs.o radiotap.o util.o reg.o scan.o nl80211.o mlme.o
-+cfg80211-y += core.o sysfs.o radiotap.o util.o reg.o scan.o nl80211.o mlme.o compat.o
- cfg80211-$(CONFIG_WIRELESS_EXT) += wext-compat.o
+ static int __devinit b44_init_one(struct ssb_device *sdev,
+ 				  const struct ssb_device_id *ent)
+@@ -2166,9 +2168,26 @@ static int __devinit b44_init_one(struct ssb_device *sdev,
+ 	bp->rx_pending = B44_DEF_RX_RING_PENDING;
+ 	bp->tx_pending = B44_DEF_TX_RING_PENDING;
  
- ccflags-y += -D__CHECK_ENDIAN__
---- a/drivers/net/usb/Makefile	2008-10-27 09:41:27.000000000 -0700
-+++ b/drivers/net/usb/Makefile	2008-10-27 09:43:01.000000000 -0700
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29))
++	dev->open = b44_open;
++	dev->stop = b44_close;
++	dev->hard_start_xmit = b44_start_xmit;
++	dev->get_stats = b44_get_stats;
++	dev->set_multicast_list = b44_set_rx_mode;
++	dev->set_mac_address = b44_set_mac_addr;
++	dev->do_ioctl = b44_ioctl;
++	dev->tx_timeout = b44_tx_timeout;
++	netif_napi_add(dev, &bp->napi, b44_poll, 64);
++	dev->watchdog_timeo = B44_TX_TIMEOUT;
++#ifdef CONFIG_NET_POLL_CONTROLLER
++	dev->poll_controller = b44_poll_controller;
++#endif
++	dev->change_mtu = b44_change_mtu;
++#else
+ 	dev->netdev_ops = &b44_netdev_ops;
+ 	netif_napi_add(dev, &bp->napi, b44_poll, 64);
+ 	dev->watchdog_timeo = B44_TX_TIMEOUT;
++#endif
+ 	dev->irq = sdev->irq;
+ 	SET_ETHTOOL_OPS(dev, &b44_ethtool_ops);
+ 
+--- a/drivers/net/usb/Makefile
++++ b/drivers/net/usb/Makefile
 @@ -2,21 +2,7 @@
  # Makefile for USB Network drivers
  #
@@ -107,8 +134,52 @@
  	net->hard_start_xmit = usbnet_start_xmit;
  	net->open = usbnet_open;
  	net->stop = usbnet_stop;
-diff --git a/drivers/net/wireless/b43/pcmcia.c b/drivers/net/wireless/b43/pcmcia.c
-index 3cfc303..33c76b0 100644
+--- a/drivers/net/wireless/Makefile
++++ b/drivers/net/wireless/Makefile
+@@ -5,43 +5,17 @@
+ obj-$(CONFIG_IPW2100) += ipw2x00/
+ obj-$(CONFIG_IPW2200) += ipw2x00/
+ 
+-obj-$(CONFIG_STRIP) += strip.o
+-obj-$(CONFIG_ARLAN) += arlan.o 
+-
+-arlan-objs := arlan-main.o arlan-proc.o
+-
+-# Obsolete cards
+-obj-$(CONFIG_WAVELAN)		+= wavelan.o
+-obj-$(CONFIG_PCMCIA_NETWAVE)	+= netwave_cs.o
+-obj-$(CONFIG_PCMCIA_WAVELAN)	+= wavelan_cs.o
+-
+-obj-$(CONFIG_HERMES)		+= orinoco/
+-
+-obj-$(CONFIG_AIRO)		+= airo.o
+-obj-$(CONFIG_AIRO_CS)		+= airo_cs.o airo.o
+-
+-obj-$(CONFIG_ATMEL)             += atmel.o
+-obj-$(CONFIG_PCI_ATMEL)         += atmel_pci.o 
+-obj-$(CONFIG_PCMCIA_ATMEL)      += atmel_cs.o
+-
+ obj-$(CONFIG_AT76C50X_USB)      += at76c50x-usb.o
+ 
+-obj-$(CONFIG_PRISM54)		+= prism54/
+-
+-obj-$(CONFIG_HOSTAP)		+= hostap/
+ obj-$(CONFIG_B43)		+= b43/
+ obj-$(CONFIG_B43LEGACY)		+= b43legacy/
+ obj-$(CONFIG_ZD1211RW)		+= zd1211rw/
+ obj-$(CONFIG_RTL8180)		+= rtl818x/
+ obj-$(CONFIG_RTL8187)		+= rtl818x/
+ 
+-# 16-bit wireless PCMCIA client drivers
+-obj-$(CONFIG_PCMCIA_RAYCS)	+= ray_cs.o
+-obj-$(CONFIG_PCMCIA_WL3501)	+= wl3501_cs.o
+ 
+ obj-$(CONFIG_USB_NET_RNDIS_WLAN)	+= rndis_wlan.o
+ 
+-obj-$(CONFIG_USB_ZD1201)	+= zd1201.o
+ obj-$(CONFIG_LIBERTAS)		+= libertas/
+ 
+ obj-$(CONFIG_LIBERTAS_THINFIRM)	+= libertas_tf/
 --- a/drivers/net/wireless/b43/pcmcia.c
 +++ b/drivers/net/wireless/b43/pcmcia.c
 @@ -87,7 +87,11 @@ static int __devinit b43_pcmcia_probe(struct pcmcia_device *dev)
@@ -222,8 +293,6 @@ index 3cfc303..33c76b0 100644
  	priv->wireless_data.spy_data = &priv->ieee->spy_data;
  	net_dev->wireless_data = &priv->wireless_data;
  	net_dev->wireless_handlers = &ipw_wx_handler_def;
-diff --git a/drivers/net/wireless/libertas/if_cs.c b/drivers/net/wireless/libertas/if_cs.c
-index 842a08d..079c1fd 100644
 --- a/drivers/net/wireless/libertas/if_cs.c
 +++ b/drivers/net/wireless/libertas/if_cs.c
 @@ -791,7 +791,11 @@ static int if_cs_probe(struct pcmcia_device *p_dev)
@@ -388,157 +457,19 @@ index 842a08d..079c1fd 100644
  
  	tmp = RNDIS_PACKET_TYPE_DIRECTED | RNDIS_PACKET_TYPE_BROADCAST;
  	retval = rndis_set_oid(usbdev, OID_GEN_CURRENT_PACKET_FILTER, &tmp,
-diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
-index a0c860f..9c6f214 100644
---- a/net/mac80211/wme.c
-+++ b/net/mac80211/wme.c
-@@ -125,6 +125,7 @@ u16 ieee80211_select_queue(struct net_device *dev, struct sk_buff *skb)
- 	if (unlikely(queue >= local->hw.queues))
- 		queue = local->hw.queues - 1;
- 
-+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,28))
- 	/*
- 	 * Now we know the 1d priority, fill in the QoS header if
- 	 * there is one (and we haven't done this before).
-@@ -140,6 +141,7 @@ u16 ieee80211_select_queue(struct net_device *dev, struct sk_buff *skb)
- 		*p++ = ack_policy | tid;
- 		*p = 0;
- 	}
-+#endif
- 
- 	return queue;
- }
---- a/drivers/net/wireless/Makefile	2008-11-10 12:55:55.000000000 -0800
-+++ b/drivers/net/wireless/Makefile	2008-11-10 12:57:30.000000000 -0800
-@@ -5,43 +5,17 @@
- obj-$(CONFIG_IPW2100) += ipw2x00/
- obj-$(CONFIG_IPW2200) += ipw2x00/
- 
--obj-$(CONFIG_STRIP) += strip.o
--obj-$(CONFIG_ARLAN) += arlan.o 
--
--arlan-objs := arlan-main.o arlan-proc.o
--
--# Obsolete cards
--obj-$(CONFIG_WAVELAN)		+= wavelan.o
--obj-$(CONFIG_PCMCIA_NETWAVE)	+= netwave_cs.o
--obj-$(CONFIG_PCMCIA_WAVELAN)	+= wavelan_cs.o
--
--obj-$(CONFIG_HERMES)		+= orinoco/
--
--obj-$(CONFIG_AIRO)		+= airo.o
--obj-$(CONFIG_AIRO_CS)		+= airo_cs.o airo.o
--
--obj-$(CONFIG_ATMEL)             += atmel.o
--obj-$(CONFIG_PCI_ATMEL)         += atmel_pci.o 
--obj-$(CONFIG_PCMCIA_ATMEL)      += atmel_cs.o
--
- obj-$(CONFIG_AT76C50X_USB)      += at76c50x-usb.o
- 
--obj-$(CONFIG_PRISM54)		+= prism54/
--
--obj-$(CONFIG_HOSTAP)		+= hostap/
- obj-$(CONFIG_B43)		+= b43/
- obj-$(CONFIG_B43LEGACY)		+= b43legacy/
- obj-$(CONFIG_ZD1211RW)		+= zd1211rw/
- obj-$(CONFIG_RTL8180)		+= rtl818x/
- obj-$(CONFIG_RTL8187)		+= rtl818x/
- 
--# 16-bit wireless PCMCIA client drivers
--obj-$(CONFIG_PCMCIA_RAYCS)	+= ray_cs.o
--obj-$(CONFIG_PCMCIA_WL3501)	+= wl3501_cs.o
- 
- obj-$(CONFIG_USB_NET_RNDIS_WLAN)	+= rndis_wlan.o
- 
--obj-$(CONFIG_USB_ZD1201)	+= zd1201.o
- obj-$(CONFIG_LIBERTAS)		+= libertas/
- 
- obj-$(CONFIG_LIBERTAS_THINFIRM)	+= libertas_tf/
---- a/drivers/misc/eeprom/Makefile	2009-01-22 07:51:17.000000000 -0800
-+++ b/drivers/misc/eeprom/Makefile	2009-01-22 07:51:26.000000000 -0800
-@@ -1,4 +1 @@
--obj-$(CONFIG_EEPROM_AT24)	+= at24.o
--obj-$(CONFIG_EEPROM_AT25)	+= at25.o
--obj-$(CONFIG_EEPROM_LEGACY)	+= eeprom.o
- obj-$(CONFIG_EEPROM_93CX6)	+= eeprom_93cx6.o
---- a/net/mac80211/rx.c	2009-02-10 23:51:58.000000000 -0800
-+++ b/net/mac80211/rx.c	2009-02-10 23:52:04.000000000 -0800
-@@ -806,12 +806,17 @@
- 
- 	/* Send all buffered frames to the station */
- 	while ((skb = skb_dequeue(&sta->tx_filtered)) != NULL) {
-+#if (LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,28))
-+		dev_kfree_skb(skb);
-+#else
- 		sent++;
- 		skb->requeue = 1;
- 		dev_queue_xmit(skb);
-+#endif
- 	}
- 	while ((skb = skb_dequeue(&sta->ps_tx_buf)) != NULL) {
- 		local->total_ps_buffered--;
-+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,28))
- 		sent++;
- #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
- 		printk(KERN_DEBUG "%s: STA %pM aid %d send PS frame "
-@@ -820,6 +825,9 @@
- #endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
- 		skb->requeue = 1;
- 		dev_queue_xmit(skb);
-+#else
-+		dev_kfree_skb(skb);
-+#endif
- 	}
- 
- 	return sent;
---- a/drivers/net/b44.c	2009-01-22 07:52:14.000000000 -0800
-+++ b/drivers/net/b44.c	2009-01-22 07:52:14.000000000 -0800
-@@ -2112,6 +2112,7 @@
- 	return err;
- }
- 
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
- static const struct net_device_ops b44_netdev_ops = {
- 	.ndo_open		= b44_open,
- 	.ndo_stop		= b44_close,
-@@ -2127,6 +2128,7 @@
- 	.ndo_poll_controller	= b44_poll_controller,
- #endif
- };
-+#endif
- 
- static int __devinit b44_init_one(struct ssb_device *sdev,
- 				  const struct ssb_device_id *ent)
-@@ -2166,9 +2168,26 @@
- 	bp->rx_pending = B44_DEF_RX_RING_PENDING;
- 	bp->tx_pending = B44_DEF_TX_RING_PENDING;
- 
-+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29))
-+	dev->open = b44_open;
-+	dev->stop = b44_close;
-+	dev->hard_start_xmit = b44_start_xmit;
-+	dev->get_stats = b44_get_stats;
-+	dev->set_multicast_list = b44_set_rx_mode;
-+	dev->set_mac_address = b44_set_mac_addr;
-+	dev->do_ioctl = b44_ioctl;
-+	dev->tx_timeout = b44_tx_timeout;
-+	netif_napi_add(dev, &bp->napi, b44_poll, 64);
-+	dev->watchdog_timeo = B44_TX_TIMEOUT;
-+#ifdef CONFIG_NET_POLL_CONTROLLER
-+	dev->poll_controller = b44_poll_controller;
-+#endif
-+	dev->change_mtu = b44_change_mtu;
-+#else
- 	dev->netdev_ops = &b44_netdev_ops;
- 	netif_napi_add(dev, &bp->napi, b44_poll, 64);
- 	dev->watchdog_timeo = B44_TX_TIMEOUT;
-+#endif
- 	dev->irq = sdev->irq;
- 	SET_ETHTOOL_OPS(dev, &b44_ethtool_ops);
+--- a/include/net/cfg80211.h
++++ b/include/net/cfg80211.h
+@@ -9,6 +9,7 @@
+ #include <linux/wireless.h>
+ #include <net/iw_handler.h>
+ #include <net/genetlink.h>
++#include <net/compat.h>
+ /* remove once we remove the wext stuff */
  
---- a/net/mac80211/iface.c	2009-03-24 18:33:11.000000000 -0700
-+++ b/net/mac80211/iface.c	2009-03-24 18:33:18.000000000 -0700
-@@ -671,6 +671,7 @@
+ /*
+--- a/net/mac80211/iface.c
++++ b/net/mac80211/iface.c
+@@ -671,6 +671,7 @@ static void ieee80211_teardown_sdata(struct net_device *dev)
  	WARN_ON(flushed);
  }
  
@@ -546,7 +477,7 @@ index a0c860f..9c6f214 100644
  static const struct net_device_ops ieee80211_dataif_ops = {
  	.ndo_open		= ieee80211_open,
  	.ndo_stop		= ieee80211_stop,
-@@ -690,11 +691,22 @@
+@@ -690,11 +691,22 @@ static const struct net_device_ops ieee80211_monitorif_ops = {
  	.ndo_change_mtu 	= ieee80211_change_mtu,
  	.ndo_set_mac_address 	= eth_mac_addr,
  };
@@ -569,7 +500,7 @@ index a0c860f..9c6f214 100644
  	dev->wireless_handlers = &ieee80211_iw_handler_def;
  	dev->destructor = free_netdev;
  }
-@@ -710,7 +722,11 @@
+@@ -710,7 +722,11 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
  
  	/* and set some type-dependent values */
  	sdata->vif.type = type;
@@ -581,7 +512,7 @@ index a0c860f..9c6f214 100644
  	sdata->wdev.iftype = type;
  
  	/* only monitor differs */
-@@ -733,7 +749,11 @@
+@@ -733,7 +749,11 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
  		break;
  	case NL80211_IFTYPE_MONITOR:
  		sdata->dev->type = ARPHRD_IEEE80211_RADIOTAP;
@@ -593,7 +524,7 @@ index a0c860f..9c6f214 100644
  		sdata->u.mntr_flags = MONITOR_FLAG_CONTROL |
  				      MONITOR_FLAG_OTHER_BSS;
  		break;
-@@ -840,6 +860,10 @@
+@@ -840,6 +860,10 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
  	if (ret)
  		goto fail;
  
@@ -604,9 +535,9 @@ index a0c860f..9c6f214 100644
  	if (ieee80211_vif_is_mesh(&sdata->vif) &&
  	    params && params->mesh_id_len)
  		ieee80211_sdata_set_mesh_id(sdata,
---- a/net/mac80211/main.c	2009-02-13 14:25:06.000000000 -0800
-+++ b/net/mac80211/main.c	2009-02-13 14:25:08.000000000 -0800
-@@ -482,6 +482,7 @@
+--- a/net/mac80211/main.c
++++ b/net/mac80211/main.c
+@@ -482,6 +482,7 @@ static void ieee80211_handle_filtered_frame(struct ieee80211_local *local,
  		return;
  	}
  
@@ -614,7 +545,7 @@ index a0c860f..9c6f214 100644
  	if (!test_sta_flags(sta, WLAN_STA_PS) && !skb->requeue) {
  		/* Software retry the packet once */
  		skb->requeue = 1;
-@@ -489,6 +490,7 @@
+@@ -489,6 +490,7 @@ static void ieee80211_handle_filtered_frame(struct ieee80211_local *local,
  		dev_queue_xmit(skb);
  		return;
  	}
@@ -622,7 +553,7 @@ index a0c860f..9c6f214 100644
  
  #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
  	if (net_ratelimit())
-@@ -811,6 +813,7 @@
+@@ -811,6 +813,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
  }
  EXPORT_SYMBOL(ieee80211_alloc_hw);
  
@@ -630,7 +561,7 @@ index a0c860f..9c6f214 100644
  static const struct net_device_ops ieee80211_master_ops = {
  	.ndo_start_xmit = ieee80211_master_start_xmit,
  	.ndo_open = ieee80211_master_open,
-@@ -818,12 +821,22 @@
+@@ -818,12 +821,22 @@ static const struct net_device_ops ieee80211_master_ops = {
  	.ndo_set_multicast_list = ieee80211_master_set_multicast_list,
  	.ndo_select_queue = ieee80211_select_queue,
  };
@@ -653,9 +584,9 @@ index a0c860f..9c6f214 100644
  	mdev->tx_queue_len = 1000;
  	mdev->addr_len = ETH_ALEN;
  }
---- a/net/mac80211/rate.c	2009-02-06 17:12:28.000000000 -0800
-+++ b/net/mac80211/rate.c	2009-02-06 17:12:51.000000000 -0800
-@@ -22,7 +22,7 @@
+--- a/net/mac80211/rate.c
++++ b/net/mac80211/rate.c
+@@ -22,7 +22,7 @@ struct rate_control_alg {
  static LIST_HEAD(rate_ctrl_algs);
  static DEFINE_MUTEX(rate_ctrl_mutex);
  
@@ -664,7 +595,7 @@ index a0c860f..9c6f214 100644
  module_param(ieee80211_default_rc_algo, charp, 0644);
  MODULE_PARM_DESC(ieee80211_default_rc_algo,
  		 "Default rate control algorithm for mac80211 to use");
-@@ -117,8 +117,8 @@
+@@ -117,8 +117,8 @@ ieee80211_rate_control_ops_get(const char *name)
  		ops = ieee80211_try_rate_control_ops_get(ieee80211_default_rc_algo);
  
  	/* try built-in one if specific alg requested but not found */
@@ -675,3 +606,66 @@ index a0c860f..9c6f214 100644
  
  	return ops;
  }
+--- a/net/mac80211/rx.c
++++ b/net/mac80211/rx.c
+@@ -806,12 +806,17 @@ static int ap_sta_ps_end(struct sta_info *sta)
+ 
+ 	/* Send all buffered frames to the station */
+ 	while ((skb = skb_dequeue(&sta->tx_filtered)) != NULL) {
++#if (LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,28))
++		dev_kfree_skb(skb);
++#else
+ 		sent++;
+ 		skb->requeue = 1;
+ 		dev_queue_xmit(skb);
++#endif
+ 	}
+ 	while ((skb = skb_dequeue(&sta->ps_tx_buf)) != NULL) {
+ 		local->total_ps_buffered--;
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,28))
+ 		sent++;
+ #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
+ 		printk(KERN_DEBUG "%s: STA %pM aid %d send PS frame "
+@@ -820,6 +825,9 @@ static int ap_sta_ps_end(struct sta_info *sta)
+ #endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
+ 		skb->requeue = 1;
+ 		dev_queue_xmit(skb);
++#else
++		dev_kfree_skb(skb);
++#endif
+ 	}
+ 
+ 	return sent;
+--- a/net/mac80211/wme.c
++++ b/net/mac80211/wme.c
+@@ -125,6 +125,7 @@ u16 ieee80211_select_queue(struct net_device *dev, struct sk_buff *skb)
+ 	if (unlikely(queue >= local->hw.queues))
+ 		queue = local->hw.queues - 1;
+ 
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,28))
+ 	/*
+ 	 * Now we know the 1d priority, fill in the QoS header if
+ 	 * there is one (and we haven't done this before).
+@@ -140,6 +141,7 @@ u16 ieee80211_select_queue(struct net_device *dev, struct sk_buff *skb)
+ 		*p++ = ack_policy | tid;
+ 		*p = 0;
+ 	}
++#endif
+ 
+ 	return queue;
+ }
+--- a/net/wireless/Makefile
++++ b/net/wireless/Makefile
+@@ -1,11 +1,10 @@
+-obj-$(CONFIG_WIRELESS_EXT) += wext.o
+ obj-$(CONFIG_CFG80211) += cfg80211.o
+ obj-$(CONFIG_LIB80211) += lib80211.o
+ obj-$(CONFIG_LIB80211_CRYPT_WEP) += lib80211_crypt_wep.o
+ obj-$(CONFIG_LIB80211_CRYPT_CCMP) += lib80211_crypt_ccmp.o
+ obj-$(CONFIG_LIB80211_CRYPT_TKIP) += lib80211_crypt_tkip.o
+ 
+-cfg80211-y += core.o sysfs.o radiotap.o util.o reg.o scan.o nl80211.o mlme.o
++cfg80211-y += core.o sysfs.o radiotap.o util.o reg.o scan.o nl80211.o mlme.o compat.o
+ cfg80211-$(CONFIG_WIRELESS_EXT) += wext-compat.o
+ 
+ ccflags-y += -D__CHECK_ENDIAN__
-- 
1.6.2.1

