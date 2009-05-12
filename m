Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:42892 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832AbZELUex (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2009 16:34:53 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v2] compat-2.6: update compat.diff
Date: Tue, 12 May 2009 22:34:45 +0200
Message-Id: <1242160485-7395-1-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1241727955-2228-1-git-send-email-hauke@hauke-m.de>
References: <1241727955-2228-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will fix the make clean problem reported by Brett D. Ussher.

wl12xx will be removed from Makefile. I do not think wl12xx needs to be integrated,
because it is not rely widely used.
If needed it will not be very hard to integrate it.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat.diff |   47 +++++++++++++++++++++++++++--------------------
 1 files changed, 27 insertions(+), 20 deletions(-)

diff --git a/compat/compat.diff b/compat/compat.diff
index 68bfd81..725aadf 100644
--- a/compat/compat.diff
+++ b/compat/compat.diff
@@ -52,7 +52,7 @@
  
 --- a/drivers/net/usb/Makefile
 +++ b/drivers/net/usb/Makefile
-@@ -2,21 +2,7 @@
+@@ -2,22 +2,7 @@
  # Makefile for USB Network drivers
  #
  
@@ -63,6 +63,7 @@
 -obj-$(CONFIG_USB_HSO)		+= hso.o
 -obj-$(CONFIG_USB_NET_AX8817X)	+= asix.o
  obj-$(CONFIG_USB_NET_CDCETHER)	+= cdc_ether.o
+-obj-$(CONFIG_USB_NET_CDC_EEM)	+= cdc_eem.o
 -obj-$(CONFIG_USB_NET_DM9601)	+= dm9601.o
 -obj-$(CONFIG_USB_NET_SMSC95XX)	+= smsc95xx.o
 -obj-$(CONFIG_USB_NET_GL620A)	+= gl620a.o
@@ -180,6 +181,12 @@
  obj-$(CONFIG_LIBERTAS)		+= libertas/
  
  obj-$(CONFIG_LIBERTAS_THINFIRM)	+= libertas_tf/
+@@ -58,5 +32,3 @@ obj-$(CONFIG_P54_COMMON)	+= p54/
+ obj-$(CONFIG_ATH_COMMON)	+= ath/
+ 
+ obj-$(CONFIG_MAC80211_HWSIM)	+= mac80211_hwsim.o
+-
+-obj-$(CONFIG_WL12XX)	+= wl12xx/
 --- a/drivers/net/wireless/b43/pcmcia.c
 +++ b/drivers/net/wireless/b43/pcmcia.c
 @@ -87,7 +87,11 @@ static int __devinit b43_pcmcia_probe(struct pcmcia_device *dev)
@@ -231,7 +238,7 @@
  	priv->wireless_data.ieee80211 = priv->ieee;
 --- a/drivers/net/wireless/ipw2x00/ipw2200.c
 +++ b/drivers/net/wireless/ipw2x00/ipw2200.c
-@@ -11529,6 +11529,7 @@ static int ipw_prom_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
+@@ -11530,6 +11530,7 @@ static int ipw_prom_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
  	return -EOPNOTSUPP;
  }
  
@@ -239,7 +246,7 @@
  static const struct net_device_ops ipw_prom_netdev_ops = {
  	.ndo_open 		= ipw_prom_open,
  	.ndo_stop		= ipw_prom_stop,
-@@ -11537,6 +11538,7 @@ static const struct net_device_ops ipw_prom_netdev_ops = {
+@@ -11538,6 +11539,7 @@ static const struct net_device_ops ipw_prom_netdev_ops = {
  	.ndo_set_mac_address 	= eth_mac_addr,
  	.ndo_validate_addr	= eth_validate_addr,
  };
@@ -247,7 +254,7 @@
  
  static int ipw_prom_alloc(struct ipw_priv *priv)
  {
-@@ -11557,7 +11559,13 @@ static int ipw_prom_alloc(struct ipw_priv *priv)
+@@ -11558,7 +11560,13 @@ static int ipw_prom_alloc(struct ipw_priv *priv)
  	memcpy(priv->prom_net_dev->dev_addr, priv->mac_addr, ETH_ALEN);
  
  	priv->prom_net_dev->type = ARPHRD_IEEE80211_RADIOTAP;
@@ -261,7 +268,7 @@
  
  	priv->prom_priv->ieee->iw_mode = IW_MODE_MONITOR;
  	SET_NETDEV_DEV(priv->prom_net_dev, &priv->pci_dev->dev);
-@@ -11585,6 +11593,7 @@ static void ipw_prom_free(struct ipw_priv *priv)
+@@ -11586,6 +11594,7 @@ static void ipw_prom_free(struct ipw_priv *priv)
  
  #endif
  
@@ -269,7 +276,7 @@
  static const struct net_device_ops ipw_netdev_ops = {
  	.ndo_init		= ipw_net_init,
  	.ndo_open		= ipw_net_open,
-@@ -11595,6 +11604,7 @@ static const struct net_device_ops ipw_netdev_ops = {
+@@ -11596,6 +11605,7 @@ static const struct net_device_ops ipw_netdev_ops = {
  	.ndo_change_mtu		= ieee80211_change_mtu,
  	.ndo_validate_addr	= eth_validate_addr,
  };
@@ -277,7 +284,7 @@
  
  static int __devinit ipw_pci_probe(struct pci_dev *pdev,
  				   const struct pci_device_id *ent)
-@@ -11696,7 +11706,15 @@ static int __devinit ipw_pci_probe(struct pci_dev *pdev,
+@@ -11697,7 +11707,15 @@ static int __devinit ipw_pci_probe(struct pci_dev *pdev,
  	priv->ieee->perfect_rssi = -20;
  	priv->ieee->worst_rssi = -85;
  
@@ -404,7 +411,7 @@
  
 --- a/drivers/net/wireless/mac80211_hwsim.c	2009-04-28 15:35:05.000000000 -0700
 +++ b/drivers/net/wireless/mac80211_hwsim.c	2009-04-28 15:35:06.000000000 -0700
-@@ -732,16 +732,22 @@
+@@ -734,16 +734,22 @@
  	.name = "mac80211_hwsim"
  };
  
@@ -469,7 +476,7 @@
  /*
 --- a/net/mac80211/iface.c	2009-04-28 15:34:50.000000000 -0700
 +++ b/net/mac80211/iface.c	2009-04-28 15:35:06.000000000 -0700
-@@ -667,6 +667,7 @@
+@@ -671,6 +671,7 @@
  	WARN_ON(flushed);
  }
  
@@ -477,7 +484,7 @@
  static const struct net_device_ops ieee80211_dataif_ops = {
  	.ndo_open		= ieee80211_open,
  	.ndo_stop		= ieee80211_stop,
-@@ -686,11 +687,22 @@
+@@ -690,11 +691,22 @@
  	.ndo_change_mtu 	= ieee80211_change_mtu,
  	.ndo_set_mac_address 	= eth_mac_addr,
  };
@@ -500,7 +507,7 @@
  	dev->wireless_handlers = &ieee80211_iw_handler_def;
  	dev->destructor = free_netdev;
  }
-@@ -706,7 +718,11 @@
+@@ -710,7 +722,11 @@
  
  	/* and set some type-dependent values */
  	sdata->vif.type = type;
@@ -512,7 +519,7 @@
  	sdata->wdev.iftype = type;
  
  	/* only monitor differs */
-@@ -729,7 +745,11 @@
+@@ -733,7 +749,11 @@
  		break;
  	case NL80211_IFTYPE_MONITOR:
  		sdata->dev->type = ARPHRD_IEEE80211_RADIOTAP;
@@ -524,7 +531,7 @@
  		sdata->u.mntr_flags = MONITOR_FLAG_CONTROL |
  				      MONITOR_FLAG_OTHER_BSS;
  		break;
-@@ -836,6 +856,10 @@
+@@ -840,6 +860,10 @@
  	if (ret)
  		goto fail;
  
@@ -537,7 +544,7 @@
  		ieee80211_sdata_set_mesh_id(sdata,
 --- a/net/mac80211/main.c	2009-04-28 15:34:50.000000000 -0700
 +++ b/net/mac80211/main.c	2009-04-28 15:35:06.000000000 -0700
-@@ -467,6 +467,7 @@
+@@ -469,6 +469,7 @@
  		return;
  	}
  
@@ -545,7 +552,7 @@
  	if (!test_sta_flags(sta, WLAN_STA_PS) && !skb->requeue) {
  		/* Software retry the packet once */
  		skb->requeue = 1;
-@@ -474,6 +475,7 @@
+@@ -476,6 +477,7 @@
  		dev_queue_xmit(skb);
  		return;
  	}
@@ -553,7 +560,7 @@
  
  #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
  	if (net_ratelimit())
-@@ -805,6 +807,7 @@
+@@ -808,6 +810,7 @@
  }
  EXPORT_SYMBOL(ieee80211_alloc_hw);
  
@@ -561,7 +568,7 @@
  static const struct net_device_ops ieee80211_master_ops = {
  	.ndo_start_xmit = ieee80211_master_start_xmit,
  	.ndo_open = ieee80211_master_open,
-@@ -812,12 +815,22 @@
+@@ -815,12 +818,22 @@
  	.ndo_set_multicast_list = ieee80211_master_set_multicast_list,
  	.ndo_select_queue = ieee80211_select_queue,
  };
@@ -608,7 +615,7 @@
  }
 --- a/net/mac80211/rx.c	2009-04-28 15:34:51.000000000 -0700
 +++ b/net/mac80211/rx.c	2009-04-28 15:35:06.000000000 -0700
-@@ -803,12 +803,17 @@
+@@ -815,12 +815,17 @@
  
  	/* Send all buffered frames to the station */
  	while ((skb = skb_dequeue(&sta->tx_filtered)) != NULL) {
@@ -626,7 +633,7 @@
  		sent++;
  #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
  		printk(KERN_DEBUG "%s: STA %pM aid %d send PS frame "
-@@ -817,6 +822,9 @@
+@@ -829,6 +834,9 @@
  #endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
  		skb->requeue = 1;
  		dev_queue_xmit(skb);
@@ -725,7 +732,7 @@
  
  		/* overwrite IEs */
  		if (overwrite) {
-@@ -397,6 +412,7 @@
+@@ -398,6 +413,7 @@
  			}
  		}
  
-- 
1.6.2.1

