Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:47372 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754528Ab0CKVdK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Mar 2010 16:33:10 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/5] compat-wireless: add orinoco to compat-wireless
Date: Thu, 11 Mar 2010 22:32:44 +0100
Message-Id: <1268343167-2961-5-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1268343167-2961-1-git-send-email-hauke@hauke-m.de>
References: <1268343167-2961-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

orinoco now depends on cfg80211. If compat-wireless was installed it
will install its own version of cfg80211 and orinoco will not work any
more because it wants to use the version shipped with the kernel.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk                         |   14 +++++++
 patches/01-netdev.patch           |   73 ++++++++++++++++++++++++++++---------
 patches/02-ksize.patch            |   25 +++++++++++++
 patches/24-pcmcia.patch           |   14 +++++++
 patches/99-change-makefiles.patch |    8 ++---
 scripts/admin-update.sh           |    1 +
 6 files changed, 112 insertions(+), 23 deletions(-)
 create mode 100644 patches/24-pcmcia.patch

diff --git a/config.mk b/config.mk
index f4f019f..431940e 100644
--- a/config.mk
+++ b/config.mk
@@ -303,6 +303,20 @@ CONFIG_ATL2=m
 CONFIG_ATL1E=m
 CONFIG_ATL1C=m
 
+CONFIG_HERMES=m
+CONFIG_HERMES_CACHE_FW_ON_INIT=y
+ifneq ($(CONFIG_PPC_PMAC),)
+CONFIG_APPLE_AIRPORT=m
+endif
+CONFIG_PLX_HERMES=m
+CONFIG_TMD_HERMES=m
+CONFIG_NORTEL_HERMES=m
+CONFIG_PCI_HERMES=m
+ifneq ($(CONFIG_PCMCIA),)
+CONFIG_PCMCIA_HERMES=m
+CONFIG_PCMCIA_SPECTRUM=m
+endif
+
 endif
 ## end of PCI
 
diff --git a/patches/01-netdev.patch b/patches/01-netdev.patch
index 5ba7e41..f976013 100644
--- a/patches/01-netdev.patch
+++ b/patches/01-netdev.patch
@@ -72,7 +72,7 @@ without creating a headache on maintenance of the pathes.
  
 --- a/drivers/net/wireless/rndis_wlan.c
 +++ b/drivers/net/wireless/rndis_wlan.c
-@@ -2703,6 +2703,7 @@ static int bcm4320b_early_init(struct us
+@@ -3047,6 +3047,7 @@ static int bcm4320b_early_init(struct us
  	return 0;
  }
  
@@ -80,7 +80,7 @@ without creating a headache on maintenance of the pathes.
  /* same as rndis_netdev_ops but with local multicast handler */
  static const struct net_device_ops rndis_wlan_netdev_ops = {
  	.ndo_open		= usbnet_open,
-@@ -2713,6 +2714,7 @@ static const struct net_device_ops rndis
+@@ -3057,6 +3058,7 @@ static const struct net_device_ops rndis
  	.ndo_validate_addr	= eth_validate_addr,
  	.ndo_set_multicast_list	= rndis_wlan_set_multicast_list,
  };
@@ -88,7 +88,7 @@ without creating a headache on maintenance of the pathes.
  
  static int rndis_wlan_bind(struct usbnet *usbdev, struct usb_interface *intf)
  {
-@@ -2760,7 +2762,11 @@ static int rndis_wlan_bind(struct usbnet
+@@ -3104,7 +3106,11 @@ static int rndis_wlan_bind(struct usbnet
  	 * rndis_host wants to avoid all OID as much as possible
  	 * so do promisc/multicast handling in rndis_wlan.
  	 */
@@ -181,7 +181,7 @@ without creating a headache on maintenance of the pathes.
  		sdata->u.mntr_flags = MONITOR_FLAG_CONTROL |
  				      MONITOR_FLAG_OTHER_BSS;
  		break;
-@@ -831,6 +858,8 @@ int ieee80211_if_add(struct ieee80211_lo
+@@ -943,6 +970,8 @@ int ieee80211_if_add(struct ieee80211_lo
  		return -ENOMEM;
  	dev_net_set(ndev, wiphy_net(local->hw.wiphy));
  
@@ -190,7 +190,7 @@ without creating a headache on maintenance of the pathes.
  	ndev->needed_headroom = local->tx_headroom +
  				4*6 /* four MAC addresses */
  				+ 2 + 2 + 2 + 2 /* ctl, dur, seq, qos */
-@@ -839,6 +868,7 @@ int ieee80211_if_add(struct ieee80211_lo
+@@ -951,6 +980,7 @@ int ieee80211_if_add(struct ieee80211_lo
  				- ETH_HLEN /* ethernet hard_header_len */
  				+ IEEE80211_ENCRYPT_HEADROOM;
  	ndev->needed_tailroom = IEEE80211_ENCRYPT_TAILROOM;
@@ -198,7 +198,7 @@ without creating a headache on maintenance of the pathes.
  
  	ret = dev_alloc_name(ndev, ndev->name);
  	if (ret < 0)
-@@ -884,6 +914,10 @@ int ieee80211_if_add(struct ieee80211_lo
+@@ -996,6 +1026,10 @@ int ieee80211_if_add(struct ieee80211_lo
  	if (ret)
  		goto fail;
  
@@ -359,7 +359,7 @@ without creating a headache on maintenance of the pathes.
  	priv->wireless_data.libipw = priv->ieee;
 --- a/drivers/net/wireless/ipw2x00/ipw2200.c
 +++ b/drivers/net/wireless/ipw2x00/ipw2200.c
-@@ -11635,6 +11635,7 @@ static netdev_tx_t ipw_prom_hard_start_x
+@@ -11650,6 +11650,7 @@ static netdev_tx_t ipw_prom_hard_start_x
  	return NETDEV_TX_OK;
  }
  
@@ -367,7 +367,7 @@ without creating a headache on maintenance of the pathes.
  static const struct net_device_ops ipw_prom_netdev_ops = {
  	.ndo_open 		= ipw_prom_open,
  	.ndo_stop		= ipw_prom_stop,
-@@ -11643,6 +11644,7 @@ static const struct net_device_ops ipw_p
+@@ -11658,6 +11659,7 @@ static const struct net_device_ops ipw_p
  	.ndo_set_mac_address 	= eth_mac_addr,
  	.ndo_validate_addr	= eth_validate_addr,
  };
@@ -375,7 +375,7 @@ without creating a headache on maintenance of the pathes.
  
  static int ipw_prom_alloc(struct ipw_priv *priv)
  {
-@@ -11663,7 +11665,13 @@ static int ipw_prom_alloc(struct ipw_pri
+@@ -11678,7 +11680,13 @@ static int ipw_prom_alloc(struct ipw_pri
  	memcpy(priv->prom_net_dev->dev_addr, priv->mac_addr, ETH_ALEN);
  
  	priv->prom_net_dev->type = ARPHRD_IEEE80211_RADIOTAP;
@@ -389,7 +389,7 @@ without creating a headache on maintenance of the pathes.
  
  	priv->prom_priv->ieee->iw_mode = IW_MODE_MONITOR;
  	SET_NETDEV_DEV(priv->prom_net_dev, &priv->pci_dev->dev);
-@@ -11691,6 +11699,7 @@ static void ipw_prom_free(struct ipw_pri
+@@ -11706,6 +11714,7 @@ static void ipw_prom_free(struct ipw_pri
  
  #endif
  
@@ -397,7 +397,7 @@ without creating a headache on maintenance of the pathes.
  static const struct net_device_ops ipw_netdev_ops = {
  	.ndo_init		= ipw_net_init,
  	.ndo_open		= ipw_net_open,
-@@ -11701,6 +11710,7 @@ static const struct net_device_ops ipw_n
+@@ -11716,6 +11725,7 @@ static const struct net_device_ops ipw_n
  	.ndo_change_mtu		= libipw_change_mtu,
  	.ndo_validate_addr	= eth_validate_addr,
  };
@@ -405,7 +405,7 @@ without creating a headache on maintenance of the pathes.
  
  static int __devinit ipw_pci_probe(struct pci_dev *pdev,
  				   const struct pci_device_id *ent)
-@@ -11802,7 +11812,15 @@ static int __devinit ipw_pci_probe(struc
+@@ -11817,7 +11827,15 @@ static int __devinit ipw_pci_probe(struc
  	priv->ieee->perfect_rssi = -20;
  	priv->ieee->worst_rssi = -85;
  
@@ -423,7 +423,7 @@ without creating a headache on maintenance of the pathes.
  	net_dev->wireless_handlers = &ipw_wx_handler_def;
 --- a/drivers/net/wireless/ipw2x00/libipw_module.c
 +++ b/drivers/net/wireless/ipw2x00/libipw_module.c
-@@ -157,6 +157,10 @@ struct net_device *alloc_ieee80211(int s
+@@ -154,6 +154,10 @@ struct net_device *alloc_ieee80211(int s
  		goto failed;
  	}
  	ieee = netdev_priv(dev);
@@ -436,7 +436,7 @@ without creating a headache on maintenance of the pathes.
  
 --- a/drivers/net/wireless/libertas/main.c
 +++ b/drivers/net/wireless/libertas/main.c
-@@ -881,6 +881,7 @@ static void lbs_free_adapter(struct lbs_
+@@ -885,6 +885,7 @@ static void lbs_free_adapter(struct lbs_
  	lbs_deb_leave(LBS_DEB_MAIN);
  }
  
@@ -444,7 +444,7 @@ without creating a headache on maintenance of the pathes.
  static const struct net_device_ops lbs_netdev_ops = {
  	.ndo_open 		= lbs_dev_open,
  	.ndo_stop		= lbs_eth_stop,
-@@ -891,6 +892,7 @@ static const struct net_device_ops lbs_n
+@@ -895,6 +896,7 @@ static const struct net_device_ops lbs_n
  	.ndo_change_mtu		= eth_change_mtu,
  	.ndo_validate_addr	= eth_validate_addr,
  };
@@ -452,7 +452,7 @@ without creating a headache on maintenance of the pathes.
  
  /**
   * @brief This function adds the card. it will probe the
-@@ -936,7 +938,16 @@ struct lbs_private *lbs_add_card(void *c
+@@ -940,7 +942,16 @@ struct lbs_private *lbs_add_card(void *c
  	wdev->netdev = dev;
  	priv->dev = dev;
  
@@ -469,7 +469,7 @@ without creating a headache on maintenance of the pathes.
  	dev->watchdog_timeo = 5 * HZ;
  	dev->ethtool_ops = &lbs_ethtool_ops;
  #ifdef	WIRELESS_EXT
-@@ -1242,11 +1253,13 @@ out:
+@@ -1246,11 +1257,13 @@ out:
  	lbs_deb_leave(LBS_DEB_MAIN);
  }
  
@@ -483,7 +483,7 @@ without creating a headache on maintenance of the pathes.
  
  static int lbs_add_rtap(struct lbs_private *priv)
  {
-@@ -1267,7 +1280,13 @@ static int lbs_add_rtap(struct lbs_priva
+@@ -1271,7 +1284,13 @@ static int lbs_add_rtap(struct lbs_priva
  
  	memcpy(rtap_dev->dev_addr, priv->current_addr, ETH_ALEN);
  	rtap_dev->type = ARPHRD_IEEE80211_RADIOTAP;
@@ -573,6 +573,43 @@ without creating a headache on maintenance of the pathes.
  	dev->destructor = free_netdev;
  	ether_setup(dev);
  	dev->tx_queue_len = 0;
+--- a/drivers/net/wireless/orinoco/main.c
++++ b/drivers/net/wireless/orinoco/main.c
+@@ -2077,6 +2077,7 @@ int orinoco_init(struct orinoco_private 
+ }
+ EXPORT_SYMBOL(orinoco_init);
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+ static const struct net_device_ops orinoco_netdev_ops = {
+ 	.ndo_open		= orinoco_open,
+ 	.ndo_stop		= orinoco_stop,
+@@ -2088,6 +2089,7 @@ static const struct net_device_ops orino
+ 	.ndo_tx_timeout		= orinoco_tx_timeout,
+ 	.ndo_get_stats		= orinoco_get_stats,
+ };
++#endif
+ 
+ /* Allocate private data.
+  *
+@@ -2210,7 +2212,18 @@ int orinoco_if_add(struct orinoco_privat
+ 
+ 	/* Setup / override net_device fields */
+ 	dev->ieee80211_ptr = wdev;
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+ 	dev->netdev_ops = &orinoco_netdev_ops;
++#else
++	dev->open = orinoco_open;
++	dev->stop = orinoco_stop;
++	dev->hard_start_xmit = orinoco_xmit;
++	dev->set_multicast_list = orinoco_set_multicast_list;
++	dev->change_mtu = orinoco_change_mtu;
++	dev->set_mac_address = eth_mac_addr;
++	dev->tx_timeout = orinoco_tx_timeout;
++	dev->get_stats = orinoco_get_stats;
++#endif
+ 	dev->watchdog_timeo = HZ; /* 1 second timeout */
+ 	dev->wireless_handlers = &orinoco_handler_def;
+ #ifdef WIRELESS_SPY
 --- a/net/bluetooth/bnep/netdev.c
 +++ b/net/bluetooth/bnep/netdev.c
 @@ -167,8 +167,12 @@ static inline int bnep_net_proto_filter(
diff --git a/patches/02-ksize.patch b/patches/02-ksize.patch
index 28bacba..5f4e039 100644
--- a/patches/02-ksize.patch
+++ b/patches/02-ksize.patch
@@ -10,6 +10,31 @@ define ksize(bleh) SOME_LARGE_NUMBER
 but doing it this way emphasis careful review
 of the situation.
 
+--- a/drivers/net/wireless/orinoco/wext.c
++++ b/drivers/net/wireless/orinoco/wext.c
+@@ -28,8 +28,22 @@ static int orinoco_set_key(struct orinoc
+ 			   enum orinoco_alg alg, const u8 *key, int key_len,
+ 			   const u8 *seq, int seq_len)
+ {
++#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,28)
++	int len;
++	if (!unlikely(ZERO_OR_NULL_PTR(priv->keys[index].key))) {
++		len = priv->keys[index].key_len;
++		memset(priv->keys[index].key, 0, len);
++		kfree(priv->keys[index].key);
++	}
++	if (!unlikely(ZERO_OR_NULL_PTR(priv->keys[index].seq))) {
++		len = priv->keys[index].seq_len;
++		memset(priv->keys[index].seq, 0, len);
++		kfree(priv->keys[index].seq);
++	}
++#else
+ 	kzfree(priv->keys[index].key);
+ 	kzfree(priv->keys[index].seq);
++#endif
+ 
+ 	if (key_len) {
+ 		priv->keys[index].key = kzalloc(key_len, GFP_ATOMIC);
 --- a/net/wireless/scan.c
 +++ b/net/wireless/scan.c
 @@ -426,9 +426,14 @@ cfg80211_bss_update(struct cfg80211_regi
diff --git a/patches/24-pcmcia.patch b/patches/24-pcmcia.patch
new file mode 100644
index 0000000..5ffaa7a
--- /dev/null
+++ b/patches/24-pcmcia.patch
@@ -0,0 +1,14 @@
+--- a/drivers/net/wireless/orinoco/orinoco_cs.c
++++ b/drivers/net/wireless/orinoco/orinoco_cs.c
+@@ -81,7 +81,11 @@ orinoco_cs_hard_reset(struct orinoco_pri
+ 	/* We need atomic ops here, because we're not holding the lock */
+ 	set_bit(0, &card->hard_reset_in_progress);
+ 
++#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,27)
++	err = pcmcia_reset_card(link, NULL);
++#else
+ 	err = pcmcia_reset_card(link->socket);
++#endif
+ 	if (err)
+ 		return err;
+ 
diff --git a/patches/99-change-makefiles.patch b/patches/99-change-makefiles.patch
index 2fe68e5..7d59537 100644
--- a/patches/99-change-makefiles.patch
+++ b/patches/99-change-makefiles.patch
@@ -40,12 +40,10 @@ only the wireless stuff.
  
 --- a/drivers/net/wireless/Makefile
 +++ b/drivers/net/wireless/Makefile
-@@ -5,33 +5,16 @@
- obj-$(CONFIG_IPW2100) += ipw2x00/
- obj-$(CONFIG_IPW2200) += ipw2x00/
+@@ -7,31 +7,16 @@ obj-$(CONFIG_IPW2200) += ipw2x00/
+ 
+ obj-$(CONFIG_HERMES)		+= orinoco/
  
--obj-$(CONFIG_HERMES)		+= orinoco/
--
 -obj-$(CONFIG_AIRO)		+= airo.o
 -obj-$(CONFIG_AIRO_CS)		+= airo_cs.o airo.o
 -
diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index c75af30..29dd460 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -96,6 +96,7 @@ DRIVERS="$DRIVERS drivers/net/wireless/libertas_tf"
 DRIVERS="$DRIVERS drivers/net/wireless/ipw2x00"
 DRIVERS="$DRIVERS drivers/net/wireless/wl12xx"
 DRIVERS="$DRIVERS drivers/net/wireless/iwmc3200wifi"
+DRIVERS="$DRIVERS drivers/net/wireless/orinoco"
 
 # Ethernet drivers
 DRIVERS="$DRIVERS drivers/net/atl1c"
-- 
1.6.3.3

