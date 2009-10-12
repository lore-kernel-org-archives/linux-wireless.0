Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:47123 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758311AbZJLVUq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 17:20:46 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 8/9] [compat-2.6] refresh patches
Date: Mon, 12 Oct 2009 23:19:17 +0200
Message-Id: <1255382358-20760-10-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1255382358-20760-1-git-send-email-hauke@hauke-m.de>
References: <1255382358-20760-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/patches/01-netdev.patch                     |   42 ++++++++++----------
 compat/patches/08-rename-iwl4965-config.patch      |    2 +-
 compat/patches/09-threaded-irq.patch               |    4 +-
 .../patches/10-add-wext-handlers-to-netdev.patch   |    2 +-
 4 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/compat/patches/01-netdev.patch b/compat/patches/01-netdev.patch
index 6ec1827..dd2e33d 100644
--- a/compat/patches/01-netdev.patch
+++ b/compat/patches/01-netdev.patch
@@ -102,7 +102,7 @@ without creating a headache on maintenance of the pathes.
  	retval = rndis_set_oid(usbdev, OID_GEN_CURRENT_PACKET_FILTER, &tmp,
 --- a/net/mac80211/iface.c	2009-09-02 14:09:58.557123328 -0700
 +++ b/net/mac80211/iface.c	2009-09-02 14:10:02.137093336 -0700
-@@ -642,6 +642,7 @@
+@@ -644,6 +644,7 @@
  	WARN_ON(flushed);
  }
  
@@ -110,7 +110,7 @@ without creating a headache on maintenance of the pathes.
  static const struct net_device_ops ieee80211_dataif_ops = {
  	.ndo_open		= ieee80211_open,
  	.ndo_stop		= ieee80211_stop,
-@@ -661,11 +662,22 @@
+@@ -663,11 +664,22 @@
  	.ndo_change_mtu 	= ieee80211_change_mtu,
  	.ndo_set_mac_address 	= eth_mac_addr,
  };
@@ -133,7 +133,7 @@ without creating a headache on maintenance of the pathes.
  	dev->destructor = free_netdev;
  }
  
-@@ -680,7 +692,11 @@
+@@ -682,7 +694,11 @@
  
  	/* and set some type-dependent values */
  	sdata->vif.type = type;
@@ -145,7 +145,7 @@ without creating a headache on maintenance of the pathes.
  	sdata->wdev.iftype = type;
  
  	/* only monitor differs */
-@@ -703,7 +719,11 @@
+@@ -705,7 +721,11 @@
  		break;
  	case NL80211_IFTYPE_MONITOR:
  		sdata->dev->type = ARPHRD_IEEE80211_RADIOTAP;
@@ -157,7 +157,7 @@ without creating a headache on maintenance of the pathes.
  		sdata->u.mntr_flags = MONITOR_FLAG_CONTROL |
  				      MONITOR_FLAG_OTHER_BSS;
  		break;
-@@ -774,6 +794,8 @@
+@@ -776,6 +796,8 @@
  		return -ENOMEM;
  	dev_net_set(ndev, wiphy_net(local->hw.wiphy));
  
@@ -166,7 +166,7 @@ without creating a headache on maintenance of the pathes.
  	ndev->needed_headroom = local->tx_headroom +
  				4*6 /* four MAC addresses */
  				+ 2 + 2 + 2 + 2 /* ctl, dur, seq, qos */
-@@ -782,6 +804,7 @@
+@@ -784,6 +806,7 @@
  				- ETH_HLEN /* ethernet hard_header_len */
  				+ IEEE80211_ENCRYPT_HEADROOM;
  	ndev->needed_tailroom = IEEE80211_ENCRYPT_TAILROOM;
@@ -174,7 +174,7 @@ without creating a headache on maintenance of the pathes.
  
  	ret = dev_alloc_name(ndev, ndev->name);
  	if (ret < 0)
-@@ -815,6 +838,10 @@
+@@ -818,6 +841,10 @@
  	if (ret)
  		goto fail;
  
@@ -335,7 +335,7 @@ without creating a headache on maintenance of the pathes.
  	priv->wireless_data.libipw = priv->ieee;
 --- a/drivers/net/wireless/ipw2x00/ipw2200.c	2009-08-20 13:47:07.311291621 -0700
 +++ b/drivers/net/wireless/ipw2x00/ipw2200.c	2009-08-20 13:47:07.783268230 -0700
-@@ -11624,6 +11624,7 @@
+@@ -11626,6 +11626,7 @@
  	return NETDEV_TX_OK;
  }
  
@@ -343,7 +343,7 @@ without creating a headache on maintenance of the pathes.
  static const struct net_device_ops ipw_prom_netdev_ops = {
  	.ndo_open 		= ipw_prom_open,
  	.ndo_stop		= ipw_prom_stop,
-@@ -11632,6 +11633,7 @@
+@@ -11634,6 +11635,7 @@
  	.ndo_set_mac_address 	= eth_mac_addr,
  	.ndo_validate_addr	= eth_validate_addr,
  };
@@ -351,7 +351,7 @@ without creating a headache on maintenance of the pathes.
  
  static int ipw_prom_alloc(struct ipw_priv *priv)
  {
-@@ -11652,7 +11654,13 @@
+@@ -11654,7 +11656,13 @@
  	memcpy(priv->prom_net_dev->dev_addr, priv->mac_addr, ETH_ALEN);
  
  	priv->prom_net_dev->type = ARPHRD_IEEE80211_RADIOTAP;
@@ -365,7 +365,7 @@ without creating a headache on maintenance of the pathes.
  
  	priv->prom_priv->ieee->iw_mode = IW_MODE_MONITOR;
  	SET_NETDEV_DEV(priv->prom_net_dev, &priv->pci_dev->dev);
-@@ -11680,6 +11688,7 @@
+@@ -11682,6 +11690,7 @@
  
  #endif
  
@@ -373,7 +373,7 @@ without creating a headache on maintenance of the pathes.
  static const struct net_device_ops ipw_netdev_ops = {
  	.ndo_init		= ipw_net_init,
  	.ndo_open		= ipw_net_open,
-@@ -11690,6 +11699,7 @@
+@@ -11692,6 +11701,7 @@
  	.ndo_change_mtu		= libipw_change_mtu,
  	.ndo_validate_addr	= eth_validate_addr,
  };
@@ -381,7 +381,7 @@ without creating a headache on maintenance of the pathes.
  
  static int __devinit ipw_pci_probe(struct pci_dev *pdev,
  				   const struct pci_device_id *ent)
-@@ -11791,7 +11801,15 @@
+@@ -11793,7 +11803,15 @@
  	priv->ieee->perfect_rssi = -20;
  	priv->ieee->worst_rssi = -85;
  
@@ -399,7 +399,7 @@ without creating a headache on maintenance of the pathes.
  	net_dev->wireless_handlers = &ipw_wx_handler_def;
 --- a/drivers/net/wireless/libertas/main.c	2009-10-07 01:42:20.000000000 -0400
 +++ b/drivers/net/wireless/libertas/main.c	2009-10-07 01:42:21.000000000 -0400
-@@ -1227,6 +1227,7 @@
+@@ -1229,6 +1229,7 @@
  	lbs_deb_leave(LBS_DEB_MAIN);
  }
  
@@ -407,7 +407,7 @@ without creating a headache on maintenance of the pathes.
  static const struct net_device_ops lbs_netdev_ops = {
  	.ndo_open 		= lbs_dev_open,
  	.ndo_stop		= lbs_eth_stop,
-@@ -1237,6 +1238,7 @@
+@@ -1239,6 +1240,7 @@
  	.ndo_change_mtu		= eth_change_mtu,
  	.ndo_validate_addr	= eth_validate_addr,
  };
@@ -415,7 +415,7 @@ without creating a headache on maintenance of the pathes.
  
  /**
   * @brief This function adds the card. it will probe the
-@@ -1283,7 +1285,16 @@
+@@ -1284,7 +1286,16 @@
  	wdev->netdev = dev;
  	priv->dev = dev;
  
@@ -432,7 +432,7 @@ without creating a headache on maintenance of the pathes.
  	dev->watchdog_timeo = 5 * HZ;
  	dev->ethtool_ops = &lbs_ethtool_ops;
  #ifdef	WIRELESS_EXT
-@@ -1530,6 +1541,7 @@
+@@ -1531,6 +1542,7 @@
  EXPORT_SYMBOL_GPL(lbs_stop_card);
  
  
@@ -440,7 +440,7 @@ without creating a headache on maintenance of the pathes.
  static const struct net_device_ops mesh_netdev_ops = {
  	.ndo_open		= lbs_dev_open,
  	.ndo_stop 		= lbs_mesh_stop,
-@@ -1537,6 +1549,7 @@
+@@ -1538,6 +1550,7 @@
  	.ndo_set_mac_address	= lbs_set_mac_address,
  	.ndo_set_multicast_list = lbs_set_multicast_list,
  };
@@ -448,7 +448,7 @@ without creating a headache on maintenance of the pathes.
  
  /**
   * @brief This function adds mshX interface
-@@ -1560,7 +1573,15 @@
+@@ -1561,7 +1574,15 @@
  	mesh_dev->ml_priv = priv;
  	priv->mesh_dev = mesh_dev;
  
@@ -464,7 +464,7 @@ without creating a headache on maintenance of the pathes.
  	mesh_dev->ethtool_ops = &lbs_ethtool_ops;
  	memcpy(mesh_dev->dev_addr, priv->dev->dev_addr,
  			sizeof(priv->dev->dev_addr));
-@@ -1776,11 +1797,13 @@
+@@ -1777,11 +1798,13 @@
  	lbs_deb_leave(LBS_DEB_MAIN);
  }
  
@@ -478,7 +478,7 @@ without creating a headache on maintenance of the pathes.
  
  static int lbs_add_rtap(struct lbs_private *priv)
  {
-@@ -1801,7 +1824,13 @@
+@@ -1802,7 +1825,13 @@
  
  	memcpy(rtap_dev->dev_addr, priv->current_addr, ETH_ALEN);
  	rtap_dev->type = ARPHRD_IEEE80211_RADIOTAP;
diff --git a/compat/patches/08-rename-iwl4965-config.patch b/compat/patches/08-rename-iwl4965-config.patch
index cbb47a7..b0add39 100644
--- a/compat/patches/08-rename-iwl4965-config.patch
+++ b/compat/patches/08-rename-iwl4965-config.patch
@@ -16,7 +16,7 @@ CONFIG_IWL4965 has to be set to y, to build correctly.
  iwlagn-$(CONFIG_IWL5000) += iwl-1000.o
 --- a/drivers/net/wireless/iwlwifi/iwl-agn.c	2009-10-06 12:57:49.000000000 -0400
 +++ b/drivers/net/wireless/iwlwifi/iwl-agn.c	2009-10-06 12:57:50.000000000 -0400
-@@ -3244,10 +3244,10 @@
+@@ -3239,10 +3239,10 @@
  
  /* Hardware specific file defines the PCI IDs table for that hardware module */
  static struct pci_device_id iwl_hw_card_ids[] = {
diff --git a/compat/patches/09-threaded-irq.patch b/compat/patches/09-threaded-irq.patch
index 6658e2f..68689e2 100644
--- a/compat/patches/09-threaded-irq.patch
+++ b/compat/patches/09-threaded-irq.patch
@@ -52,7 +52,7 @@ thread in process context as well.
  static inline struct b43_wl *hw_to_b43_wl(struct ieee80211_hw *hw)
 --- a/drivers/net/wireless/b43/b43.h	2009-10-07 01:45:01.000000000 -0400
 +++ b/drivers/net/wireless/b43/b43.h	2009-10-07 01:45:02.000000000 -0400
-@@ -831,6 +831,9 @@
+@@ -747,6 +747,9 @@
  	unsigned int tx_count;
  	unsigned int rx_count;
  #endif
@@ -61,4 +61,4 @@ thread in process context as well.
 +#endif
  };
  
- static inline struct b43_wl *hw_to_b43_wl(struct ieee80211_hw *hw)
+ /*
diff --git a/compat/patches/10-add-wext-handlers-to-netdev.patch b/compat/patches/10-add-wext-handlers-to-netdev.patch
index 9172c20..ec2249c 100644
--- a/compat/patches/10-add-wext-handlers-to-netdev.patch
+++ b/compat/patches/10-add-wext-handlers-to-netdev.patch
@@ -13,7 +13,7 @@ the struct wiphy wireless handler.
 
 --- a/net/wireless/core.c	2009-10-06 13:23:34.000000000 -0400
 +++ b/net/wireless/core.c	2009-10-06 13:25:31.000000000 -0400
-@@ -671,6 +671,10 @@
+@@ -672,6 +672,10 @@
  		wdev->sme_state = CFG80211_SME_IDLE;
  		mutex_unlock(&rdev->devlist_mtx);
  #ifdef CONFIG_CFG80211_WEXT
-- 
1.6.2.1

