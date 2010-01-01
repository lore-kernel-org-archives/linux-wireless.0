Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:42361 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047Ab0AAQZK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jan 2010 11:25:10 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 4/5] compat-wireless: Refresh patches
Date: Fri,  1 Jan 2010 17:21:11 +0100
Message-Id: <1262362872-10251-5-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1262362872-10251-1-git-send-email-hauke@hauke-m.de>
References: <1262362872-10251-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This was done with "./scripts/admin-refresh.sh refresh"

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/01-netdev.patch                      |  165 +++++-----
 patches/02-ksize.patch                       |    6 +-
 patches/03-rfkill.patch                      |   44 ++--
 patches/04-netns.patch                       |    6 +-
 patches/05-usb.patch                         |    6 +-
 patches/06-header-changes.patch              |   12 +-
 patches/07-change-default-rate-alg.patch     |    4 +-
 patches/08-rename-iwl4965-config.patch       |   10 +-
 patches/09-threaded-irq.patch                |   16 +-
 patches/10-add-wext-handlers-to-netdev.patch |    6 +-
 patches/11-dev-pm-ops.patch                  |    8 +-
 patches/12-iw_handler-changes.patch          |    6 +-
 patches/13-trace.patch                       |   10 +-
 patches/14-device-type.patch                 |   10 +-
 patches/15-symbol-export-conflicts.patch     |    6 +-
 patches/16-bluetooth.patch                   |  481 ++++++++++++--------------
 patches/17-netdev-queue.patch                |    8 +-
 patches/18-rename-usb-net-symbols.patch      |    6 -
 patches/19-kfifo.patch                       |    4 +-
 patches/99-change-makefiles.patch            |   14 +-
 20 files changed, 399 insertions(+), 429 deletions(-)

diff --git a/patches/01-netdev.patch b/patches/01-netdev.patch
index a970622..9fd8ff7 100644
--- a/patches/01-netdev.patch
+++ b/patches/01-netdev.patch
@@ -6,8 +6,8 @@ patch file which also addresses netns changes, we leave
 them separate as there is no easy way to split the stuff
 without creating a headache on maintenance of the pathes.
 
---- a/drivers/net/usb/rndis_host.c	2009-08-04 10:15:14.237993105 -0700
-+++ b/drivers/net/usb/rndis_host.c	2009-08-04 10:15:14.614020995 -0700
+--- a/drivers/net/usb/rndis_host.c
++++ b/drivers/net/usb/rndis_host.c
 @@ -274,6 +274,7 @@ response_error:
  	return -EDOM;
  }
@@ -36,9 +36,9 @@ without creating a headache on maintenance of the pathes.
  
  	retval = rndis_command(dev, u.header, CONTROL_BUFFER_SIZE);
  	if (unlikely(retval < 0)) {
---- a/drivers/net/usb/usbnet.c	2009-12-10 08:40:23.000000000 -0800
-+++ b/drivers/net/usb/usbnet.c	2009-12-10 08:40:24.000000000 -0800
-@@ -1260,6 +1260,7 @@
+--- a/drivers/net/usb/usbnet.c
++++ b/drivers/net/usb/usbnet.c
+@@ -1260,6 +1260,7 @@ void usbnet_disconnect (struct usb_inter
  }
  EXPORT_SYMBOL_GPL(usbnet_disconnect);
  
@@ -46,7 +46,7 @@ without creating a headache on maintenance of the pathes.
  static const struct net_device_ops usbnet_netdev_ops = {
  	.ndo_open		= usbnet_open,
  	.ndo_stop		= usbnet_stop,
-@@ -1269,6 +1270,7 @@
+@@ -1269,6 +1270,7 @@ static const struct net_device_ops usbne
  	.ndo_set_mac_address 	= eth_mac_addr,
  	.ndo_validate_addr	= eth_validate_addr,
  };
@@ -54,7 +54,7 @@ without creating a headache on maintenance of the pathes.
  
  /*-------------------------------------------------------------------------*/
  
-@@ -1348,7 +1350,15 @@
+@@ -1348,7 +1350,15 @@ usbnet_probe (struct usb_interface *udev
  		net->features |= NETIF_F_HIGHDMA;
  #endif
  
@@ -70,8 +70,8 @@ without creating a headache on maintenance of the pathes.
  	net->watchdog_timeo = TX_TIMEOUT_JIFFIES;
  	net->ethtool_ops = &usbnet_ethtool_ops;
  
---- a/drivers/net/wireless/rndis_wlan.c	2009-12-28 17:39:01.000000000 -0800
-+++ b/drivers/net/wireless/rndis_wlan.c	2009-12-28 17:39:02.000000000 -0800
+--- a/drivers/net/wireless/rndis_wlan.c
++++ b/drivers/net/wireless/rndis_wlan.c
 @@ -2682,6 +2682,7 @@ static int bcm4320b_early_init(struct us
  	return 0;
  }
@@ -100,9 +100,9 @@ without creating a headache on maintenance of the pathes.
  
  	tmp = RNDIS_PACKET_TYPE_DIRECTED | RNDIS_PACKET_TYPE_BROADCAST;
  	retval = rndis_set_oid(usbdev, OID_GEN_CURRENT_PACKET_FILTER, &tmp,
---- a/net/mac80211/iface.c	2009-12-28 17:44:09.000000000 -0800
-+++ b/net/mac80211/iface.c	2009-12-28 17:44:10.000000000 -0800
-@@ -660,6 +660,7 @@ static void ieee80211_teardown_sdata(str
+--- a/net/mac80211/iface.c
++++ b/net/mac80211/iface.c
+@@ -657,6 +657,7 @@ static void ieee80211_teardown_sdata(str
  	WARN_ON(flushed);
  }
  
@@ -110,7 +110,7 @@ without creating a headache on maintenance of the pathes.
  static const struct net_device_ops ieee80211_dataif_ops = {
  	.ndo_open		= ieee80211_open,
  	.ndo_stop		= ieee80211_stop,
-@@ -679,11 +680,23 @@ static const struct net_device_ops ieee8
+@@ -676,11 +677,23 @@ static const struct net_device_ops ieee8
  	.ndo_change_mtu 	= ieee80211_change_mtu,
  	.ndo_set_mac_address 	= eth_mac_addr,
  };
@@ -134,7 +134,7 @@ without creating a headache on maintenance of the pathes.
  	dev->destructor = free_netdev;
  }
  
-@@ -698,7 +711,12 @@ static void ieee80211_setup_sdata(struct
+@@ -695,7 +708,12 @@ static void ieee80211_setup_sdata(struct
  
  	/* and set some type-dependent values */
  	sdata->vif.type = type;
@@ -147,7 +147,7 @@ without creating a headache on maintenance of the pathes.
  	sdata->wdev.iftype = type;
  
  	/* only monitor differs */
-@@ -721,7 +739,11 @@ static void ieee80211_setup_sdata(struct
+@@ -718,7 +736,11 @@ static void ieee80211_setup_sdata(struct
  		break;
  	case NL80211_IFTYPE_MONITOR:
  		sdata->dev->type = ARPHRD_IEEE80211_RADIOTAP;
@@ -159,7 +159,7 @@ without creating a headache on maintenance of the pathes.
  		sdata->u.mntr_flags = MONITOR_FLAG_CONTROL |
  				      MONITOR_FLAG_OTHER_BSS;
  		break;
-@@ -790,6 +812,8 @@ int ieee80211_if_add(struct ieee80211_lo
+@@ -787,6 +809,8 @@ int ieee80211_if_add(struct ieee80211_lo
  		return -ENOMEM;
  	dev_net_set(ndev, wiphy_net(local->hw.wiphy));
  
@@ -168,7 +168,7 @@ without creating a headache on maintenance of the pathes.
  	ndev->needed_headroom = local->tx_headroom +
  				4*6 /* four MAC addresses */
  				+ 2 + 2 + 2 + 2 /* ctl, dur, seq, qos */
-@@ -798,6 +822,7 @@ int ieee80211_if_add(struct ieee80211_lo
+@@ -795,6 +819,7 @@ int ieee80211_if_add(struct ieee80211_lo
  				- ETH_HLEN /* ethernet hard_header_len */
  				+ IEEE80211_ENCRYPT_HEADROOM;
  	ndev->needed_tailroom = IEEE80211_ENCRYPT_TAILROOM;
@@ -176,7 +176,7 @@ without creating a headache on maintenance of the pathes.
  
  	ret = dev_alloc_name(ndev, ndev->name);
  	if (ret < 0)
-@@ -839,6 +864,10 @@ int ieee80211_if_add(struct ieee80211_lo
+@@ -836,6 +861,10 @@ int ieee80211_if_add(struct ieee80211_lo
  	if (ret)
  		goto fail;
  
@@ -187,8 +187,8 @@ without creating a headache on maintenance of the pathes.
  	if (ieee80211_vif_is_mesh(&sdata->vif) &&
  	    params && params->mesh_id_len)
  		ieee80211_sdata_set_mesh_id(sdata,
---- a/drivers/net/b44.c	2009-12-11 13:23:58.000000000 -0800
-+++ b/drivers/net/b44.c	2009-12-11 13:23:58.000000000 -0800
+--- a/drivers/net/b44.c
++++ b/drivers/net/b44.c
 @@ -2115,6 +2115,7 @@ static int __devinit b44_get_invariants(
  	return err;
  }
@@ -234,7 +234,7 @@ without creating a headache on maintenance of the pathes.
  
 --- a/net/wireless/wext-core.c
 +++ b/net/wireless/wext-core.c
-@@ -340,6 +340,7 @@
+@@ -340,6 +340,7 @@ static const int compat_event_type_size[
  
  /* IW event code */
  
@@ -242,7 +242,7 @@ without creating a headache on maintenance of the pathes.
  static int __net_init wext_pernet_init(struct net *net)
  {
  	skb_queue_head_init(&net->wext_nlevents);
-@@ -382,6 +383,29 @@
+@@ -382,6 +383,29 @@ static void wireless_nlevent_process(str
  
  static DECLARE_WORK(wireless_nlevent_work, wireless_nlevent_process);
  
@@ -272,7 +272,7 @@ without creating a headache on maintenance of the pathes.
  static struct nlmsghdr *rtnetlink_ifinfo_prep(struct net_device *dev,
  					      struct sk_buff *skb)
  {
-@@ -592,8 +616,13 @@
+@@ -592,8 +616,13 @@ void wireless_send_event(struct net_devi
  
  	skb_shinfo(skb)->frag_list = compskb;
  #endif
@@ -286,7 +286,7 @@ without creating a headache on maintenance of the pathes.
  }
  EXPORT_SYMBOL(wireless_send_event);
  
-@@ -902,8 +931,13 @@
+@@ -902,8 +931,13 @@ static int wireless_process_ioctl(struct
  			return private(dev, iwr, cmd, info, handler);
  	}
  	/* Old driver API : call driver ioctl handler */
@@ -300,9 +300,9 @@ without creating a headache on maintenance of the pathes.
  	return -EOPNOTSUPP;
  }
  
---- a/drivers/net/wireless/ipw2x00/ipw2100.c	2009-09-02 14:12:00.958117808 -0700
-+++ b/drivers/net/wireless/ipw2x00/ipw2100.c	2009-09-02 14:12:01.382115761 -0700
-@@ -6091,6 +6091,7 @@
+--- a/drivers/net/wireless/ipw2x00/ipw2100.c
++++ b/drivers/net/wireless/ipw2x00/ipw2100.c
+@@ -6091,6 +6091,7 @@ static void ipw2100_rf_kill(struct work_
  
  static void ipw2100_irq_tasklet(struct ipw2100_priv *priv);
  
@@ -310,7 +310,7 @@ without creating a headache on maintenance of the pathes.
  static const struct net_device_ops ipw2100_netdev_ops = {
  	.ndo_open		= ipw2100_open,
  	.ndo_stop		= ipw2100_close,
-@@ -6101,6 +6102,7 @@
+@@ -6101,6 +6102,7 @@ static const struct net_device_ops ipw21
  	.ndo_set_mac_address	= ipw2100_set_address,
  	.ndo_validate_addr	= eth_validate_addr,
  };
@@ -318,7 +318,7 @@ without creating a headache on maintenance of the pathes.
  
  /* Look into using netdev destructor to shutdown ieee80211? */
  
-@@ -6126,7 +6128,16 @@
+@@ -6126,7 +6128,16 @@ static struct net_device *ipw2100_alloc_
  	priv->ieee->perfect_rssi = -20;
  	priv->ieee->worst_rssi = -85;
  
@@ -335,9 +335,9 @@ without creating a headache on maintenance of the pathes.
  	dev->ethtool_ops = &ipw2100_ethtool_ops;
  	dev->wireless_handlers = &ipw2100_wx_handler_def;
  	priv->wireless_data.libipw = priv->ieee;
---- a/drivers/net/wireless/ipw2x00/ipw2200.c	2009-11-13 11:37:43.000000000 -0800
-+++ b/drivers/net/wireless/ipw2x00/ipw2200.c	2009-11-13 11:37:43.000000000 -0800
-@@ -11635,6 +11635,7 @@
+--- a/drivers/net/wireless/ipw2x00/ipw2200.c
++++ b/drivers/net/wireless/ipw2x00/ipw2200.c
+@@ -11635,6 +11635,7 @@ static netdev_tx_t ipw_prom_hard_start_x
  	return NETDEV_TX_OK;
  }
  
@@ -345,7 +345,7 @@ without creating a headache on maintenance of the pathes.
  static const struct net_device_ops ipw_prom_netdev_ops = {
  	.ndo_open 		= ipw_prom_open,
  	.ndo_stop		= ipw_prom_stop,
-@@ -11643,6 +11644,7 @@
+@@ -11643,6 +11644,7 @@ static const struct net_device_ops ipw_p
  	.ndo_set_mac_address 	= eth_mac_addr,
  	.ndo_validate_addr	= eth_validate_addr,
  };
@@ -353,7 +353,7 @@ without creating a headache on maintenance of the pathes.
  
  static int ipw_prom_alloc(struct ipw_priv *priv)
  {
-@@ -11663,7 +11665,13 @@
+@@ -11663,7 +11665,13 @@ static int ipw_prom_alloc(struct ipw_pri
  	memcpy(priv->prom_net_dev->dev_addr, priv->mac_addr, ETH_ALEN);
  
  	priv->prom_net_dev->type = ARPHRD_IEEE80211_RADIOTAP;
@@ -367,7 +367,7 @@ without creating a headache on maintenance of the pathes.
  
  	priv->prom_priv->ieee->iw_mode = IW_MODE_MONITOR;
  	SET_NETDEV_DEV(priv->prom_net_dev, &priv->pci_dev->dev);
-@@ -11691,6 +11699,7 @@
+@@ -11691,6 +11699,7 @@ static void ipw_prom_free(struct ipw_pri
  
  #endif
  
@@ -375,7 +375,7 @@ without creating a headache on maintenance of the pathes.
  static const struct net_device_ops ipw_netdev_ops = {
  	.ndo_init		= ipw_net_init,
  	.ndo_open		= ipw_net_open,
-@@ -11701,6 +11710,7 @@
+@@ -11701,6 +11710,7 @@ static const struct net_device_ops ipw_n
  	.ndo_change_mtu		= libipw_change_mtu,
  	.ndo_validate_addr	= eth_validate_addr,
  };
@@ -383,7 +383,7 @@ without creating a headache on maintenance of the pathes.
  
  static int __devinit ipw_pci_probe(struct pci_dev *pdev,
  				   const struct pci_device_id *ent)
-@@ -11802,7 +11812,15 @@
+@@ -11802,7 +11812,15 @@ static int __devinit ipw_pci_probe(struc
  	priv->ieee->perfect_rssi = -20;
  	priv->ieee->worst_rssi = -85;
  
@@ -401,7 +401,7 @@ without creating a headache on maintenance of the pathes.
  	net_dev->wireless_handlers = &ipw_wx_handler_def;
 --- a/drivers/net/wireless/ipw2x00/libipw_module.c
 +++ b/drivers/net/wireless/ipw2x00/libipw_module.c
-@@ -157,6 +157,10 @@
+@@ -157,6 +157,10 @@ struct net_device *alloc_ieee80211(int s
  		goto failed;
  	}
  	ieee = netdev_priv(dev);
@@ -412,8 +412,8 @@ without creating a headache on maintenance of the pathes.
  
  	ieee->dev = dev;
  
---- a/drivers/net/wireless/libertas/main.c	2009-12-28 17:45:01.000000000 -0800
-+++ b/drivers/net/wireless/libertas/main.c	2009-12-28 17:45:02.000000000 -0800
+--- a/drivers/net/wireless/libertas/main.c
++++ b/drivers/net/wireless/libertas/main.c
 @@ -898,6 +898,7 @@ static void lbs_free_adapter(struct lbs_
  	lbs_deb_leave(LBS_DEB_MAIN);
  }
@@ -475,9 +475,9 @@ without creating a headache on maintenance of the pathes.
  	rtap_dev->ml_priv = priv;
  	SET_NETDEV_DEV(rtap_dev, priv->dev->dev.parent);
  
---- a/drivers/net/wireless/libertas/mesh.c	2009-12-28 17:47:21.000000000 -0800
-+++ b/drivers/net/wireless/libertas/mesh.c	2009-12-28 17:47:21.000000000 -0800
-@@ -331,6 +331,7 @@ static int lbs_mesh_dev_open(struct net_
+--- a/drivers/net/wireless/libertas/mesh.c
++++ b/drivers/net/wireless/libertas/mesh.c
+@@ -332,6 +332,7 @@ static int lbs_mesh_dev_open(struct net_
  	return ret;
  }
  
@@ -485,7 +485,7 @@ without creating a headache on maintenance of the pathes.
  static const struct net_device_ops mesh_netdev_ops = {
  	.ndo_open		= lbs_mesh_dev_open,
  	.ndo_stop 		= lbs_mesh_stop,
-@@ -338,6 +339,7 @@ static const struct net_device_ops mesh_
+@@ -339,6 +340,7 @@ static const struct net_device_ops mesh_
  	.ndo_set_mac_address	= lbs_set_mac_address,
  	.ndo_set_multicast_list = lbs_set_multicast_list,
  };
@@ -493,7 +493,7 @@ without creating a headache on maintenance of the pathes.
  
  /**
   * @brief This function adds mshX interface
-@@ -362,7 +364,15 @@ int lbs_add_mesh(struct lbs_private *pri
+@@ -363,7 +365,15 @@ int lbs_add_mesh(struct lbs_private *pri
  	mesh_dev->ml_priv = priv;
  	priv->mesh_dev = mesh_dev;
  
@@ -507,10 +507,10 @@ without creating a headache on maintenance of the pathes.
 +	mesh_dev->set_multicast_list = lbs_set_multicast_list;
 +#endif
  	mesh_dev->ethtool_ops = &lbs_ethtool_ops;
- 	memcpy(mesh_dev->dev_addr, priv->dev->dev_addr,
- 			sizeof(priv->dev->dev_addr));
---- a/drivers/net/wireless/libertas/defs.h	2009-07-08 14:04:29.692256519 -0700
-+++ b/drivers/net/wireless/libertas/defs.h	2009-07-08 14:03:26.712279246 -0700
+ 	memcpy(mesh_dev->dev_addr, priv->dev->dev_addr, ETH_ALEN);
+ 
+--- a/drivers/net/wireless/libertas/defs.h
++++ b/drivers/net/wireless/libertas/defs.h
 @@ -16,6 +16,14 @@
  #define DRV_NAME "libertas"
  #endif
@@ -526,9 +526,9 @@ without creating a headache on maintenance of the pathes.
  
  #define LBS_DEB_ENTER	0x00000001
  #define LBS_DEB_LEAVE	0x00000002
---- a/drivers/net/wireless/mac80211_hwsim.c	2009-12-28 17:48:02.000000000 -0800
-+++ b/drivers/net/wireless/mac80211_hwsim.c	2009-12-28 17:48:02.000000000 -0800
-@@ -943,16 +943,22 @@ static struct device_driver mac80211_hws
+--- a/drivers/net/wireless/mac80211_hwsim.c
++++ b/drivers/net/wireless/mac80211_hwsim.c
+@@ -954,16 +954,22 @@ static struct device_driver mac80211_hws
  	.name = "mac80211_hwsim"
  };
  
@@ -551,13 +551,12 @@ without creating a headache on maintenance of the pathes.
  	dev->destructor = free_netdev;
  	ether_setup(dev);
  	dev->tx_queue_len = 0;
-diff -Nur a/net/bluetooth/bnep/netdev.c b/net/bluetooth/bnep/netdev.c
---- a/net/bluetooth/bnep/netdev.c	2009-11-25 11:24:43.000000000 +0530
-+++ b/net/bluetooth/bnep/netdev.c	2009-11-27 19:35:33.000000000 +0530
-@@ -165,8 +165,12 @@
+--- a/net/bluetooth/bnep/netdev.c
++++ b/net/bluetooth/bnep/netdev.c
+@@ -165,8 +165,12 @@ static inline int bnep_net_proto_filter(
  }
  #endif
-
+ 
 -static netdev_tx_t bnep_net_xmit(struct sk_buff *skb,
 -				 struct net_device *dev)
 +#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,31))
@@ -567,19 +566,19 @@ diff -Nur a/net/bluetooth/bnep/netdev.c b/net/bluetooth/bnep/netdev.c
 +#endif
 +
  {
-	struct bnep_session *s = netdev_priv(dev);
-	struct sock *sk = s->sock->sk;
-@@ -207,6 +211,7 @@
-	return NETDEV_TX_OK;
+ 	struct bnep_session *s = netdev_priv(dev);
+ 	struct sock *sk = s->sock->sk;
+@@ -207,6 +211,7 @@ static netdev_tx_t bnep_net_xmit(struct 
+ 	return NETDEV_TX_OK;
  }
-
+ 
 +#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,28))
  static const struct net_device_ops bnep_netdev_ops = {
-	.ndo_open            = bnep_net_open,
-	.ndo_stop            = bnep_net_close,
-@@ -218,6 +223,16 @@
-	.ndo_change_mtu	     = eth_change_mtu,
-
+ 	.ndo_open            = bnep_net_open,
+ 	.ndo_stop            = bnep_net_close,
+@@ -218,6 +223,16 @@ static const struct net_device_ops bnep_
+ 	.ndo_change_mtu	     = eth_change_mtu,
+ 
  };
 +#else
 +static struct net_device_stats *bnep_net_get_stats(struct net_device *dev)
@@ -591,15 +590,15 @@ diff -Nur a/net/bluetooth/bnep/netdev.c b/net/bluetooth/bnep/netdev.c
 +	return -EINVAL;
 +}
 +#endif
-
+ 
  void bnep_net_setup(struct net_device *dev)
  {
-@@ -226,7 +241,18 @@
-	dev->addr_len = ETH_ALEN;
-
-	ether_setup(dev);
+@@ -226,7 +241,18 @@ void bnep_net_setup(struct net_device *d
+ 	dev->addr_len = ETH_ALEN;
+ 
+ 	ether_setup(dev);
 +#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,28))
-	dev->netdev_ops = &bnep_netdev_ops;
+ 	dev->netdev_ops = &bnep_netdev_ops;
 +#else
 +	dev->open            = bnep_net_open;
 +	dev->stop            = bnep_net_close;
@@ -610,11 +609,11 @@ diff -Nur a/net/bluetooth/bnep/netdev.c b/net/bluetooth/bnep/netdev.c
 +	dev->set_multicast_list = bnep_net_set_mc_list;
 +	dev->tx_timeout      = bnep_net_timeout;
 +#endif
-
-	dev->watchdog_timeo  = HZ * 2;
+ 
+ 	dev->watchdog_timeo  = HZ * 2;
  }
---- a/drivers/net/atl1e/atl1e_main.c	2009-12-11 21:11:18.000000000 -0800
-+++ b/drivers/net/atl1e/atl1e_main.c	2009-12-11 21:11:46.000000000 -0800
+--- a/drivers/net/atl1e/atl1e_main.c
++++ b/drivers/net/atl1e/atl1e_main.c
 @@ -2219,6 +2219,7 @@ static void atl1e_shutdown(struct pci_de
  	atl1e_suspend(pdev, PMSG_SUSPEND);
  }
@@ -655,8 +654,8 @@ diff -Nur a/net/bluetooth/bnep/netdev.c b/net/bluetooth/bnep/netdev.c
  
  	netdev->watchdog_timeo = AT_TX_WATCHDOG;
  	atl1e_set_ethtool_ops(netdev);
---- a/drivers/net/atl1c/atl1c_main.c	2009-12-11 20:28:31.000000000 -0800
-+++ b/drivers/net/atl1c/atl1c_main.c	2009-12-11 21:12:05.000000000 -0800
+--- a/drivers/net/atl1c/atl1c_main.c
++++ b/drivers/net/atl1c/atl1c_main.c
 @@ -2439,6 +2439,7 @@ static void atl1c_shutdown(struct pci_de
  	atl1c_suspend(pdev, PMSG_SUSPEND);
  }
@@ -697,8 +696,8 @@ diff -Nur a/net/bluetooth/bnep/netdev.c b/net/bluetooth/bnep/netdev.c
  	netdev->watchdog_timeo = AT_TX_WATCHDOG;
  	atl1c_set_ethtool_ops(netdev);
  
---- a/drivers/net/atlx/atl1.c	2009-12-11 21:14:54.000000000 -0800
-+++ b/drivers/net/atlx/atl1.c	2009-12-11 21:29:39.000000000 -0800
+--- a/drivers/net/atlx/atl1.c
++++ b/drivers/net/atlx/atl1.c
 @@ -2878,6 +2878,7 @@ static void atl1_poll_controller(struct 
  }
  #endif
@@ -738,8 +737,8 @@ diff -Nur a/net/bluetooth/bnep/netdev.c b/net/bluetooth/bnep/netdev.c
  	netdev->watchdog_timeo = 5 * HZ;
  
  	netdev->ethtool_ops = &atl1_ethtool_ops;
---- a/drivers/net/atlx/atl2.c	2009-12-11 21:21:51.000000000 -0800
-+++ b/drivers/net/atlx/atl2.c	2009-12-11 21:28:17.000000000 -0800
+--- a/drivers/net/atlx/atl2.c
++++ b/drivers/net/atlx/atl2.c
 @@ -1306,6 +1306,7 @@ static void atl2_poll_controller(struct 
  #endif
  
diff --git a/patches/02-ksize.patch b/patches/02-ksize.patch
index 48964e2..013c0b4 100644
--- a/patches/02-ksize.patch
+++ b/patches/02-ksize.patch
@@ -10,9 +10,9 @@ define ksize(bleh) SOME_LARGE_NUMBER
 but doing it this way emphasis careful review
 of the situation.
 
---- a/net/wireless/scan.c	2009-09-02 14:13:33.769092519 -0700
-+++ b/net/wireless/scan.c	2009-09-02 14:13:34.925094548 -0700
-@@ -423,7 +423,12 @@
+--- a/net/wireless/scan.c
++++ b/net/wireless/scan.c
+@@ -423,7 +423,12 @@ cfg80211_bss_update(struct cfg80211_regi
  			size_t used = dev->wiphy.bss_priv_size + sizeof(*res);
  			size_t ielen = res->pub.len_information_elements;
  
diff --git a/patches/03-rfkill.patch b/patches/03-rfkill.patch
index 2abc292..ac44545 100644
--- a/patches/03-rfkill.patch
+++ b/patches/03-rfkill.patch
@@ -40,8 +40,8 @@ This would do the policing from within mac80211.
 +rfkill_backport-y			+= core.o
 +rfkill_backport-$(CONFIG_RFKILL_BACKPORT_INPUT)	+= input.o
 +obj-$(CONFIG_RFKILL_BACKPORT)		+= rfkill_backport.o
---- a/net/rfkill/input.c	2009-07-07 17:27:09.290706860 -0700
-+++ b/net/rfkill/input.c	2009-07-07 17:26:57.195684653 -0700
+--- a/net/rfkill/input.c
++++ b/net/rfkill/input.c
 @@ -17,7 +17,11 @@
  #include <linux/slab.h>
  #include <linux/workqueue.h>
@@ -63,8 +63,8 @@ This would do the policing from within mac80211.
  
  	/* causes rfkill_start() to be called */
  	error = input_register_handle(handle);
---- a/net/rfkill/core.c	2009-10-06 12:53:52.000000000 -0400
-+++ b/net/rfkill/core.c	2009-10-06 12:53:53.000000000 -0400
+--- a/net/rfkill/core.c
++++ b/net/rfkill/core.c
 @@ -26,7 +26,7 @@
  #include <linux/capability.h>
  #include <linux/list.h>
@@ -74,7 +74,7 @@ This would do the policing from within mac80211.
  #include <linux/sched.h>
  #include <linux/spinlock.h>
  #include <linux/miscdevice.h>
-@@ -62,7 +62,7 @@
+@@ -62,7 +62,7 @@ struct rfkill {
  	const struct rfkill_ops	*ops;
  	void			*data;
  
@@ -83,7 +83,7 @@ This would do the policing from within mac80211.
  	struct led_trigger	led_trigger;
  	const char		*ledtrigname;
  #endif
-@@ -123,7 +123,7 @@
+@@ -123,7 +123,7 @@ static struct {
  static bool rfkill_epo_lock_active;
  
  
@@ -92,7 +92,7 @@ This would do the policing from within mac80211.
  static void rfkill_led_trigger_event(struct rfkill *rfkill)
  {
  	struct led_trigger *trigger;
-@@ -317,7 +317,7 @@
+@@ -317,7 +317,7 @@ static void rfkill_set_block(struct rfki
  	rfkill_event(rfkill);
  }
  
@@ -101,7 +101,7 @@ This would do the policing from within mac80211.
  static atomic_t rfkill_input_disabled = ATOMIC_INIT(0);
  
  /**
-@@ -779,7 +779,7 @@
+@@ -779,7 +779,7 @@ static int rfkill_resume(struct device *
  }
  
  static struct class rfkill_class = {
@@ -110,7 +110,7 @@ This would do the policing from within mac80211.
  	.dev_release	= rfkill_release,
  	.dev_attrs	= rfkill_dev_attrs,
  	.dev_uevent	= rfkill_dev_uevent,
-@@ -925,7 +925,7 @@
+@@ -925,7 +925,7 @@ int __must_check rfkill_register(struct 
  	if (!rfkill->persistent || rfkill_epo_lock_active) {
  		schedule_work(&rfkill->sync_work);
  	} else {
@@ -119,7 +119,7 @@ This would do the policing from within mac80211.
  		bool soft_blocked = !!(rfkill->state & RFKILL_BLOCK_SW);
  
  		if (!atomic_read(&rfkill_input_disabled))
-@@ -1153,7 +1153,7 @@
+@@ -1153,7 +1153,7 @@ static int rfkill_fop_release(struct ino
  	list_for_each_entry_safe(ev, tmp, &data->events, list)
  		kfree(ev);
  
@@ -128,7 +128,7 @@ This would do the policing from within mac80211.
  	if (data->input_handler)
  		if (atomic_dec_return(&rfkill_input_disabled) == 0)
  			printk(KERN_DEBUG "rfkill: input handler enabled\n");
-@@ -1164,7 +1164,7 @@
+@@ -1164,7 +1164,7 @@ static int rfkill_fop_release(struct ino
  	return 0;
  }
  
@@ -137,7 +137,7 @@ This would do the policing from within mac80211.
  static long rfkill_fop_ioctl(struct file *file, unsigned int cmd,
  			     unsigned long arg)
  {
-@@ -1197,7 +1197,7 @@
+@@ -1197,7 +1197,7 @@ static const struct file_operations rfki
  	.write		= rfkill_fop_write,
  	.poll		= rfkill_fop_poll,
  	.release	= rfkill_fop_release,
@@ -146,7 +146,7 @@ This would do the policing from within mac80211.
  	.unlocked_ioctl	= rfkill_fop_ioctl,
  	.compat_ioctl	= rfkill_fop_ioctl,
  #endif
-@@ -1227,7 +1227,7 @@
+@@ -1227,7 +1227,7 @@ static int __init rfkill_init(void)
  		goto out;
  	}
  
@@ -155,7 +155,7 @@ This would do the policing from within mac80211.
  	error = rfkill_handler_init();
  	if (error) {
  		misc_deregister(&rfkill_miscdev);
-@@ -1243,7 +1243,7 @@
+@@ -1243,7 +1243,7 @@ subsys_initcall(rfkill_init);
  
  static void __exit rfkill_exit(void)
  {
@@ -164,8 +164,8 @@ This would do the policing from within mac80211.
  	rfkill_handler_exit();
  #endif
  	misc_deregister(&rfkill_miscdev);
---- a/include/linux/rfkill_backport.h	2009-09-13 13:28:21.286436755 -0700
-+++ b/include/linux/rfkill_backport.h	2009-09-13 13:28:54.665495610 -0700
+--- a/include/linux/rfkill_backport.h
++++ b/include/linux/rfkill_backport.h
 @@ -20,6 +20,7 @@
   */
  
@@ -174,7 +174,7 @@ This would do the policing from within mac80211.
  
  /* define userspace visible states */
  #define RFKILL_STATE_SOFT_BLOCKED	0
-@@ -148,7 +149,7 @@
+@@ -148,7 +149,7 @@ struct rfkill_ops {
  	int	(*set_block)(void *data, bool blocked);
  };
  
@@ -183,7 +183,7 @@ This would do the policing from within mac80211.
  /**
   * rfkill_alloc - allocate rfkill structure
   * @name: name of the struct -- the string is not copied internally
-@@ -355,7 +356,7 @@
+@@ -355,7 +356,7 @@ static inline bool rfkill_blocked(struct
  #endif /* RFKILL || RFKILL_MODULE */
  
  
@@ -192,8 +192,8 @@ This would do the policing from within mac80211.
  /**
   * rfkill_get_led_trigger_name - Get the LED trigger name for the button's LED.
   * This function might return a NULL pointer if registering of the
---- a/net/wireless/core.h	2009-07-07 13:32:53.367707921 -0700
-+++ b/net/wireless/core.h	2009-07-07 13:32:53.943703622 -0700
+--- a/net/wireless/core.h
++++ b/net/wireless/core.h
 @@ -11,7 +11,11 @@
  #include <linux/kref.h>
  #include <linux/rbtree.h>
@@ -206,8 +206,8 @@ This would do the policing from within mac80211.
  #include <linux/workqueue.h>
  #include <net/genetlink.h>
  #include <net/cfg80211.h>
---- a/drivers/net/wireless/ath/ath9k/hw.c	2009-12-28 17:49:28.000000000 -0800
-+++ b/drivers/net/wireless/ath/ath9k/hw.c	2009-12-28 17:49:28.000000000 -0800
+--- a/drivers/net/wireless/ath/ath9k/hw.c
++++ b/drivers/net/wireless/ath/ath9k/hw.c
 @@ -3230,7 +3230,7 @@ int ath9k_hw_fill_cap_info(struct ath_hw
  
  	pCap->hw_caps |= ATH9K_HW_CAP_ENHANCEDPM;
diff --git a/patches/04-netns.patch b/patches/04-netns.patch
index 76833a4..f1096d8 100644
--- a/patches/04-netns.patch
+++ b/patches/04-netns.patch
@@ -4,9 +4,9 @@ for the other changes. It'd be nice to figure out a way to
 bring thise here cleanly and seprately but they touch the same
 files...
 
---- a/net/wireless/nl80211.c	2009-07-27 16:22:30.301045695 -0700
-+++ b/net/wireless/nl80211.c	2009-07-27 18:17:28.445046102 -0700
-@@ -29,7 +29,9 @@
+--- a/net/wireless/nl80211.c
++++ b/net/wireless/nl80211.c
+@@ -29,7 +29,9 @@ static struct genl_family nl80211_fam = 
  	.hdrsize = 0,		/* no private header */
  	.version = 1,		/* no particular meaning now */
  	.maxattr = NL80211_ATTR_MAX,
diff --git a/patches/05-usb.patch b/patches/05-usb.patch
index 9d13a13..4d3efea 100644
--- a/patches/05-usb.patch
+++ b/patches/05-usb.patch
@@ -1,8 +1,8 @@
 USB opt soft_unbid was added as of 2.6.27.
 
---- a/drivers/net/wireless/p54/p54usb.c	2009-09-23 10:28:04.963708264 -0700
-+++ b/drivers/net/wireless/p54/p54usb.c	2009-09-23 10:28:05.199734839 -0700
-@@ -1052,7 +1052,9 @@
+--- a/drivers/net/wireless/p54/p54usb.c
++++ b/drivers/net/wireless/p54/p54usb.c
+@@ -1052,7 +1052,9 @@ static struct usb_driver p54u_driver = {
  	.resume = p54u_resume,
  	.reset_resume = p54u_resume,
  #endif /* CONFIG_PM */
diff --git a/patches/06-header-changes.patch b/patches/06-header-changes.patch
index baebc17..ccc74db 100644
--- a/patches/06-header-changes.patch
+++ b/patches/06-header-changes.patch
@@ -28,8 +28,8 @@ cases.
  
  #include "assoc.h"
  #include "decl.h"
---- a/drivers/net/wireless/wl12xx/wl1251_main.c	2009-08-07 11:42:12.532495607 -0700
-+++ b/drivers/net/wireless/wl12xx/wl1251_main.c	2009-08-07 12:08:31.167548696 -0700
+--- a/drivers/net/wireless/wl12xx/wl1251_main.c
++++ b/drivers/net/wireless/wl12xx/wl1251_main.c
 @@ -26,6 +26,9 @@
  #include <linux/firmware.h>
  #include <linux/delay.h>
@@ -40,8 +40,8 @@ cases.
  #include <linux/crc32.h>
  #include <linux/etherdevice.h>
  #include <linux/vmalloc.h>
---- a/drivers/net/wireless/wl12xx/wl1251_spi.c	2009-08-07 12:24:58.907526225 -0700
-+++ b/drivers/net/wireless/wl12xx/wl1251_spi.c	2009-08-07 12:24:59.199494403 -0700
+--- a/drivers/net/wireless/wl12xx/wl1251_spi.c
++++ b/drivers/net/wireless/wl12xx/wl1251_spi.c
 @@ -24,6 +24,9 @@
  #include <linux/irq.h>
  #include <linux/module.h>
@@ -64,8 +64,8 @@ cases.
  
  /**
   * DOC: Key handling basics
---- a/drivers/net/wireless/iwlwifi/iwl-core.h	2009-12-10 22:29:01.000000000 -0800
-+++ b/drivers/net/wireless/iwlwifi/iwl-core.h	2009-12-10 22:47:19.000000000 -0800
+--- a/drivers/net/wireless/iwlwifi/iwl-core.h
++++ b/drivers/net/wireless/iwlwifi/iwl-core.h
 @@ -63,7 +63,11 @@
  #ifndef __iwl_core_h__
  #define __iwl_core_h__
diff --git a/patches/07-change-default-rate-alg.patch b/patches/07-change-default-rate-alg.patch
index 480f489..9c21825 100644
--- a/patches/07-change-default-rate-alg.patch
+++ b/patches/07-change-default-rate-alg.patch
@@ -10,8 +10,8 @@ and define CONFIG_COMPAT_MAC80211_RC_DEFAULT on config.mk.
 Through the compat autoconf we then get it also defined there
 at compilation time.
 
---- a/net/mac80211/rate.c	2009-12-11 13:25:55.000000000 -0800
-+++ b/net/mac80211/rate.c	2009-12-11 13:27:15.000000000 -0800
+--- a/net/mac80211/rate.c
++++ b/net/mac80211/rate.c
 @@ -22,7 +22,7 @@ struct rate_control_alg {
  static LIST_HEAD(rate_ctrl_algs);
  static DEFINE_MUTEX(rate_ctrl_mutex);
diff --git a/patches/08-rename-iwl4965-config.patch b/patches/08-rename-iwl4965-config.patch
index dda82d4..65c2e7b 100644
--- a/patches/08-rename-iwl4965-config.patch
+++ b/patches/08-rename-iwl4965-config.patch
@@ -3,9 +3,9 @@ module, but now it is directly included in the iwlagn.
 
 CONFIG_IWL4965 has to be set to y, to build correctly.
 
---- a/drivers/net/wireless/iwlwifi/Makefile	2009-10-06 12:57:49.000000000 -0400
-+++ b/drivers/net/wireless/iwlwifi/Makefile	2009-10-06 12:57:50.000000000 -0400
-@@ -12,7 +12,7 @@
+--- a/drivers/net/wireless/iwlwifi/Makefile
++++ b/drivers/net/wireless/iwlwifi/Makefile
+@@ -12,7 +12,7 @@ CFLAGS_iwl-devtrace.o := -I$(src)
  obj-$(CONFIG_IWLAGN)	+= iwlagn.o
  iwlagn-objs		:= iwl-agn.o iwl-agn-rs.o iwl-agn-led.o
  
@@ -14,8 +14,8 @@ CONFIG_IWL4965 has to be set to y, to build correctly.
  iwlagn-$(CONFIG_IWL5000) += iwl-5000.o
  iwlagn-$(CONFIG_IWL5000) += iwl-6000.o
  iwlagn-$(CONFIG_IWL5000) += iwl-1000.o
---- a/drivers/net/wireless/iwlwifi/iwl-agn.c	2009-12-28 17:50:16.000000000 -0800
-+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c	2009-12-28 17:50:16.000000000 -0800
+--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
++++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
 @@ -3767,10 +3767,10 @@ static void __devexit iwl_pci_remove(str
  
  /* Hardware specific file defines the PCI IDs table for that hardware module */
diff --git a/patches/09-threaded-irq.patch b/patches/09-threaded-irq.patch
index 3507597..03900b8 100644
--- a/patches/09-threaded-irq.patch
+++ b/patches/09-threaded-irq.patch
@@ -4,9 +4,9 @@ on older kernels we built our own struct compat_threaded_irq
 to queue_work() onto it as the kernel thread be running the
 thread in process context as well.
 
---- a/drivers/net/wireless/b43/main.c	2009-12-11 13:29:21.000000000 -0800
-+++ b/drivers/net/wireless/b43/main.c	2009-12-11 13:29:22.000000000 -0800
-@@ -3912,8 +3912,13 @@
+--- a/drivers/net/wireless/b43/main.c
++++ b/drivers/net/wireless/b43/main.c
+@@ -3915,8 +3915,13 @@ redo:
  	if (dev->dev->bus->bustype == SSB_BUSTYPE_SDIO) {
  		b43_sdio_free_irq(dev);
  	} else {
@@ -20,7 +20,7 @@ thread in process context as well.
  	}
  	mutex_lock(&wl->mutex);
  	dev = wl->current_dev;
-@@ -3953,9 +3958,17 @@
+@@ -3956,9 +3961,17 @@ static int b43_wireless_core_start(struc
  			goto out;
  		}
  	} else {
@@ -38,7 +38,7 @@ thread in process context as well.
  		if (err) {
  			b43err(dev->wl, "Cannot request IRQ-%d\n", dev->dev->irq);
  			goto out;
-@@ -4662,6 +4675,10 @@
+@@ -4665,6 +4678,10 @@ static int b43_setup_bands(struct b43_wl
  
  static void b43_wireless_core_detach(struct b43_wldev *dev)
  {
@@ -49,9 +49,9 @@ thread in process context as well.
  	/* We release firmware that late to not be required to re-request
  	 * is all the time when we reinit the core. */
  	b43_release_firmware(dev);
---- a/drivers/net/wireless/b43/b43.h	2009-10-19 11:36:44.000000000 +0900
-+++ b/drivers/net/wireless/b43/b43.h	2009-10-19 11:36:45.000000000 +0900
-@@ -745,6 +745,9 @@
+--- a/drivers/net/wireless/b43/b43.h
++++ b/drivers/net/wireless/b43/b43.h
+@@ -745,6 +745,9 @@ struct b43_wldev {
  	unsigned int tx_count;
  	unsigned int rx_count;
  #endif
diff --git a/patches/10-add-wext-handlers-to-netdev.patch b/patches/10-add-wext-handlers-to-netdev.patch
index e5ab4f1..1ea5abb 100644
--- a/patches/10-add-wext-handlers-to-netdev.patch
+++ b/patches/10-add-wext-handlers-to-netdev.patch
@@ -11,9 +11,9 @@ users use wext again.
 We only do this for kernels <= 2.6.32 as 2.6.33 will use
 the struct wiphy wireless handler.
 
---- a/net/wireless/core.c	2009-12-10 09:02:05.000000000 -0800
-+++ b/net/wireless/core.c	2009-12-10 09:02:08.000000000 -0800
-@@ -683,6 +683,10 @@
+--- a/net/wireless/core.c
++++ b/net/wireless/core.c
+@@ -683,6 +683,10 @@ static int cfg80211_netdev_notifier_call
  		wdev->sme_state = CFG80211_SME_IDLE;
  		mutex_unlock(&rdev->devlist_mtx);
  #ifdef CONFIG_CFG80211_WEXT
diff --git a/patches/11-dev-pm-ops.patch b/patches/11-dev-pm-ops.patch
index fc4de8f..7b3500a 100644
--- a/patches/11-dev-pm-ops.patch
+++ b/patches/11-dev-pm-ops.patch
@@ -7,9 +7,9 @@ calls on compat code with only slight modifications.
 
 [1] http://lxr.linux.no/#linux+v2.6.29/include/linux/pm.h#L170
 
---- a/drivers/net/wireless/ath/ath5k/base.c	2009-10-07 01:58:19.000000000 -0400
-+++ b/drivers/net/wireless/ath/ath5k/base.c	2009-10-07 02:19:58.000000000 -0400
-@@ -197,6 +197,33 @@
+--- a/drivers/net/wireless/ath/ath5k/base.c
++++ b/drivers/net/wireless/ath/ath5k/base.c
+@@ -197,6 +197,33 @@ static void __devexit	ath5k_pci_remove(s
  #ifdef CONFIG_PM
  static int		ath5k_pci_suspend(struct device *dev);
  static int		ath5k_pci_resume(struct device *dev);
@@ -43,7 +43,7 @@ calls on compat code with only slight modifications.
  
  SIMPLE_DEV_PM_OPS(ath5k_pm_ops, ath5k_pci_suspend, ath5k_pci_resume);
  #define ATH5K_PM_OPS	(&ath5k_pm_ops)
-@@ -209,7 +235,12 @@
+@@ -209,7 +236,12 @@ static struct pci_driver ath5k_pci_drive
  	.id_table	= ath5k_pci_id_table,
  	.probe		= ath5k_pci_probe,
  	.remove		= __devexit_p(ath5k_pci_remove),
diff --git a/patches/12-iw_handler-changes.patch b/patches/12-iw_handler-changes.patch
index fb97af5..ffbc2cb 100644
--- a/patches/12-iw_handler-changes.patch
+++ b/patches/12-iw_handler-changes.patch
@@ -1,6 +1,6 @@
---- a/drivers/net/wireless/ipw2x00/ipw2100.c	2009-10-08 11:01:52.000000000 -0400
-+++ b/drivers/net/wireless/ipw2x00/ipw2100.c	2009-10-08 11:01:43.000000000 -0400
-@@ -6140,7 +6140,11 @@
+--- a/drivers/net/wireless/ipw2x00/ipw2100.c
++++ b/drivers/net/wireless/ipw2x00/ipw2100.c
+@@ -6140,7 +6140,11 @@ static struct net_device *ipw2100_alloc_
  
  	dev->ethtool_ops = &ipw2100_ethtool_ops;
  	dev->wireless_handlers = &ipw2100_wx_handler_def;
diff --git a/patches/13-trace.patch b/patches/13-trace.patch
index 947346c..5bf597b 100644
--- a/patches/13-trace.patch
+++ b/patches/13-trace.patch
@@ -4,8 +4,8 @@ in or compat headers.
 
 [1] http://lxr.linux.no/#linux+v2.6.31/include/trace/define_trace.h
 
---- a/drivers/net/wireless/iwlwifi/iwl-devtrace.h	2009-12-28 17:50:51.000000000 -0800
-+++ b/drivers/net/wireless/iwlwifi/iwl-devtrace.h	2009-12-28 17:50:52.000000000 -0800
+--- a/drivers/net/wireless/iwlwifi/iwl-devtrace.h
++++ b/drivers/net/wireless/iwlwifi/iwl-devtrace.h
 @@ -1,7 +1,9 @@
  #if !defined(__IWLWIFI_DEVICE_TRACE) || defined(TRACE_HEADER_MULTI_READ)
  #define __IWLWIFI_DEVICE_TRACE
@@ -23,8 +23,8 @@ in or compat headers.
 +#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,30))
  #include <trace/define_trace.h>
 +#endif
---- a/net/mac80211/driver-trace.h	2009-12-28 17:52:08.000000000 -0800
-+++ b/net/mac80211/driver-trace.h	2009-12-28 17:52:09.000000000 -0800
+--- a/net/mac80211/driver-trace.h
++++ b/net/mac80211/driver-trace.h
 @@ -1,7 +1,9 @@
  #if !defined(__MAC80211_DRIVER_TRACE) || defined(TRACE_HEADER_MULTI_READ)
  #define __MAC80211_DRIVER_TRACE
@@ -35,7 +35,7 @@ in or compat headers.
  #include <net/mac80211.h>
  #include "ieee80211_i.h"
  
-@@ -696,4 +698,6 @@ TRACE_EVENT(drv_ampdu_action,
+@@ -717,4 +719,6 @@ TRACE_EVENT(drv_flush,
  #define TRACE_INCLUDE_PATH .
  #undef TRACE_INCLUDE_FILE
  #define TRACE_INCLUDE_FILE driver-trace
diff --git a/patches/14-device-type.patch b/patches/14-device-type.patch
index 9f2f433..fdd7b23 100644
--- a/patches/14-device-type.patch
+++ b/patches/14-device-type.patch
@@ -6,9 +6,9 @@ SET_NETDEV_DEVTYPE() be a no-op this means the wireless type
 we define is unused so we ucomment it simply to avoid a
 compile warning.
 
---- a/net/wireless/core.c	2009-12-10 09:17:21.000000000 -0800
-+++ b/net/wireless/core.c	2009-12-10 09:17:28.000000000 -0800
-@@ -635,9 +635,11 @@
+--- a/net/wireless/core.c
++++ b/net/wireless/core.c
+@@ -635,9 +635,11 @@ static void wdev_cleanup_work(struct wor
  	dev_put(wdev->netdev);
  }
  
@@ -20,8 +20,8 @@ compile warning.
  
  static int cfg80211_netdev_notifier_call(struct notifier_block * nb,
  					 unsigned long state,
---- a/net/bluetooth/bnep/core.c	2009-12-10 09:22:58.000000000 -0800
-+++ b/net/bluetooth/bnep/core.c	2009-12-10 09:22:59.000000000 -0800
+--- a/net/bluetooth/bnep/core.c
++++ b/net/bluetooth/bnep/core.c
 @@ -536,9 +536,11 @@ static struct device *bnep_get_device(st
  	return conn ? &conn->dev : NULL;
  }
diff --git a/patches/15-symbol-export-conflicts.patch b/patches/15-symbol-export-conflicts.patch
index 625fa4e..e93f070 100644
--- a/patches/15-symbol-export-conflicts.patch
+++ b/patches/15-symbol-export-conflicts.patch
@@ -1,9 +1,9 @@
 In kernel < 2.6.32 libipw also exports ieee80211_rx.
 To avoid conflicts with the other export we rename our.
 
---- a/net/mac80211/rx.c	2009-12-28 17:52:50.000000000 -0800
-+++ b/net/mac80211/rx.c	2009-12-28 17:52:51.000000000 -0800
-@@ -2465,7 +2465,12 @@ void ieee80211_rx(struct ieee80211_hw *h
+--- a/net/mac80211/rx.c
++++ b/net/mac80211/rx.c
+@@ -2470,7 +2470,12 @@ void ieee80211_rx(struct ieee80211_hw *h
   drop:
  	kfree_skb(skb);
  }
diff --git a/patches/16-bluetooth.patch b/patches/16-bluetooth.patch
index e75acda..19f2975 100644
--- a/patches/16-bluetooth.patch
+++ b/patches/16-bluetooth.patch
@@ -1,38 +1,74 @@
 These changes are required to backport blueooth. A lot can be optimized
 here still, but for now we keep this here.
 
-diff -Nur a/drivers/bluetooth/hci_ldisc.c b/drivers/bluetooth/hci_ldisc.c
---- a/drivers/bluetooth/hci_ldisc.c	2009-11-25 11:24:32.000000000 +0530
-+++ b/drivers/bluetooth/hci_ldisc.c	2009-11-28 10:56:22.000000000 +0530
-@@ -277,8 +277,13 @@
-	/* FIXME: why is this needed. Note don't use ldisc_ref here as the
-	   open path is before the ldisc is referencable */
-
+--- a/drivers/bluetooth/hci_ldisc.c
++++ b/drivers/bluetooth/hci_ldisc.c
+@@ -277,8 +277,13 @@ static int hci_uart_tty_open(struct tty_
+ 	/* FIXME: why is this needed. Note don't use ldisc_ref here as the
+ 	   open path is before the ldisc is referencable */
+ 
 +#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,30))
-	if (tty->ldisc->ops->flush_buffer)
-		tty->ldisc->ops->flush_buffer(tty);
+ 	if (tty->ldisc->ops->flush_buffer)
+ 		tty->ldisc->ops->flush_buffer(tty);
 +#else
 +	if (tty->ldisc.ops->flush_buffer)
 +		tty->ldisc.ops->flush_buffer(tty);
 +#endif
-	tty_driver_flush_buffer(tty);
-
-	return 0;
-@@ -478,7 +483,11 @@
-		return -EUNATCH;
-
-	default:
+ 	tty_driver_flush_buffer(tty);
+ 
+ 	return 0;
+@@ -478,7 +483,11 @@ static int hci_uart_tty_ioctl(struct tty
+ 		return -EUNATCH;
+ 
+ 	default:
 +#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,27))
-		err = n_tty_ioctl_helper(tty, file, cmd, arg);
+ 		err = n_tty_ioctl_helper(tty, file, cmd, arg);
 +#else
 +		err = n_tty_ioctl(tty, file, cmd, arg);
 +#endif
-		break;
-	};
-
---- a/net/bluetooth/af_bluetooth.c	2009-12-10 09:20:31.000000000 -0800
-+++ b/net/bluetooth/af_bluetooth.c	2009-12-10 09:20:33.000000000 -0800
-@@ -338,7 +338,11 @@ int bt_sock_ioctl(struct socket *sock, u
+ 		break;
+ 	};
+ 
+--- a/net/bluetooth/af_bluetooth.c
++++ b/net/bluetooth/af_bluetooth.c
+@@ -126,8 +126,12 @@ int bt_sock_unregister(int proto)
+ }
+ EXPORT_SYMBOL(bt_sock_unregister);
+ 
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32))
+ static int bt_sock_create(struct net *net, struct socket *sock, int proto,
+ 			  int kern)
++#else
++static int bt_sock_create(struct net *net, struct socket *sock, int proto)
++#endif
+ {
+ 	int err;
+ 
+@@ -145,7 +149,11 @@ static int bt_sock_create(struct net *ne
+ 	read_lock(&bt_proto_lock);
+ 
+ 	if (bt_proto[proto] && try_module_get(bt_proto[proto]->owner)) {
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32))
+ 		err = bt_proto[proto]->create(net, sock, proto, kern);
++#else
++		err = bt_proto[proto]->create(net, sock, proto);
++#endif
+ 		bt_sock_reclassify_lock(sock, proto);
+ 		module_put(bt_proto[proto]->owner);
+ 	}
+@@ -258,7 +266,11 @@ int bt_sock_recvmsg(struct kiocb *iocb, 
+ 	skb_reset_transport_header(skb);
+ 	err = skb_copy_datagram_iovec(skb, 0, msg->msg_iov, copied);
+ 	if (err == 0)
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32))
+ 		sock_recv_ts_and_drops(msg, sk, skb);
++#else
++	  sock_recv_timestamp(msg, sk, skb);
++#endif
+ 
+ 	skb_free_datagram(sk, skb);
+ 
+@@ -338,7 +350,11 @@ int bt_sock_ioctl(struct socket *sock, u
  		if (sk->sk_state == BT_LISTEN)
  			return -EINVAL;
  
@@ -44,24 +80,22 @@ diff -Nur a/drivers/bluetooth/hci_ldisc.c b/drivers/bluetooth/hci_ldisc.c
  		if (amount < 0)
  			amount = 0;
  		err = put_user(amount, (int __user *) arg);
-diff -Nur a/net/bluetooth/cmtp/capi.c b/net/bluetooth/cmtp/capi.c
---- a/net/bluetooth/cmtp/capi.c	2009-11-25 11:24:43.000000000 +0530
-+++ b/net/bluetooth/cmtp/capi.c	2009-11-26 16:43:42.000000000 +0530
-@@ -382,7 +382,11 @@
-
-	BT_DBG("ctrl %p", ctrl);
-
+--- a/net/bluetooth/cmtp/capi.c
++++ b/net/bluetooth/cmtp/capi.c
+@@ -382,7 +382,11 @@ static void cmtp_reset_ctr(struct capi_c
+ 
+ 	BT_DBG("ctrl %p", ctrl);
+ 
 +#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,30))
-	capi_ctr_down(ctrl);
+ 	capi_ctr_down(ctrl);
 +#else
 +	capi_ctr_reseted(ctrl);
 +#endif
-
-	atomic_inc(&session->terminate);
-	cmtp_schedule(session);
-diff -Nur a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
---- a/net/bluetooth/hci_core.c	2009-11-25 11:24:43.000000000 +0530
-+++ b/net/bluetooth/hci_core.c	2009-11-26 16:01:35.000000000 +0530
+ 
+ 	atomic_inc(&session->terminate);
+ 	cmtp_schedule(session);
+--- a/net/bluetooth/hci_core.c
++++ b/net/bluetooth/hci_core.c
 @@ -39,7 +39,12 @@
  #include <linux/skbuff.h>
  #include <linux/interrupt.h>
@@ -73,11 +107,11 @@ diff -Nur a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
 +#endif
 +
  #include <net/sock.h>
-
+ 
  #include <asm/system.h>
---- a/net/bluetooth/hci_sock.c	2009-12-10 09:40:08.000000000 -0800
-+++ b/net/bluetooth/hci_sock.c	2009-12-10 09:40:59.000000000 -0800
-@@ -471,7 +471,11 @@
+--- a/net/bluetooth/hci_sock.c
++++ b/net/bluetooth/hci_sock.c
+@@ -471,7 +471,11 @@ drop:
  	goto done;
  }
  
@@ -89,48 +123,75 @@ diff -Nur a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
  {
  	struct hci_ufilter uf = { .opcode = 0 };
  	struct sock *sk = sock->sk;
-diff -Nur a/net/bluetooth/hci_sysfs.c b/net/bluetooth/hci_sysfs.c
---- a/net/bluetooth/hci_sysfs.c	2009-11-25 11:24:43.000000000 +0530
-+++ b/net/bluetooth/hci_sysfs.c	2009-11-27 15:19:26.000000000 +0530
-@@ -68,7 +68,11 @@
-	.attrs = bt_link_attrs,
+@@ -626,8 +630,12 @@ static struct proto hci_sk_proto = {
+ 	.obj_size	= sizeof(struct hci_pinfo)
  };
-
+ 
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32))
+ static int hci_sock_create(struct net *net, struct socket *sock, int protocol,
+ 			   int kern)
++#else
++static int hci_sock_create(struct net *net, struct socket *sock, int protocol)
++#endif
+ {
+ 	struct sock *sk;
+ 
+--- a/net/bluetooth/hci_sysfs.c
++++ b/net/bluetooth/hci_sysfs.c
+@@ -68,7 +68,11 @@ static struct attribute_group bt_link_gr
+ 	.attrs = bt_link_attrs,
+ };
+ 
 +#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,31))
  static const struct attribute_group *bt_link_groups[] = {
 +#else
 +static struct attribute_group *bt_link_groups[] = {
 +#endif
-	&bt_link_group,
-	NULL
+ 	&bt_link_group,
+ 	NULL
  };
-@@ -126,7 +130,11 @@
-		dev = device_find_child(&conn->dev, NULL, __match_tty);
-		if (!dev)
-			break;
+@@ -126,7 +130,11 @@ static void del_conn(struct work_struct 
+ 		dev = device_find_child(&conn->dev, NULL, __match_tty);
+ 		if (!dev)
+ 			break;
 +#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,29))
-		device_move(dev, NULL, DPM_ORDER_DEV_LAST);
+ 		device_move(dev, NULL, DPM_ORDER_DEV_LAST);
 +#else
 +		device_move(dev, NULL);
 +#endif
-		put_device(dev);
-	}
-
-@@ -392,7 +400,11 @@
-	.attrs = bt_host_attrs,
+ 		put_device(dev);
+ 	}
+ 
+@@ -392,7 +400,11 @@ static struct attribute_group bt_host_gr
+ 	.attrs = bt_host_attrs,
  };
-
+ 
 +#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,31))
  static const struct attribute_group *bt_host_groups[] = {
 +#else
 +static struct attribute_group *bt_host_groups[] = {
 +#endif
-	&bt_host_group,
-	NULL
+ 	&bt_host_group,
+ 	NULL
  };
---- a/net/bluetooth/hidp/core.c	2009-12-10 09:43:25.000000000 -0800
-+++ b/net/bluetooth/hidp/core.c	2009-12-10 09:45:09.000000000 -0800
-@@ -583,10 +583,16 @@ static int hidp_session(void *arg)
+--- a/net/bluetooth/hidp/core.c
++++ b/net/bluetooth/hidp/core.c
+@@ -280,12 +280,14 @@ static int hidp_send_report(struct hidp_
+ 	return hidp_queue_report(session, buf, rsize);
+ }
+ 
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,27))
+ static int hidp_output_raw_report(struct hid_device *hid, unsigned char *data, size_t count)
+ {
+ 	if (hidp_queue_report(hid->driver_data, data, count))
+ 		return -ENOMEM;
+ 	return count;
+ }
++#endif
+ 
+ static void hidp_idle_timeout(unsigned long arg)
+ {
+@@ -583,10 +585,16 @@ static int hidp_session(void *arg)
  		session->input = NULL;
  	}
  
@@ -151,7 +212,7 @@ diff -Nur a/net/bluetooth/hci_sysfs.c b/net/bluetooth/hci_sysfs.c
  
  	/* Wakeup user-space polling for socket errors */
  	session->intr_sock->sk->sk_err = EUNATCH;
-@@ -698,6 +704,7 @@ static void hidp_close(struct hid_device
+@@ -698,6 +706,7 @@ static void hidp_close(struct hid_device
  {
  }
  
@@ -159,7 +220,7 @@ diff -Nur a/net/bluetooth/hci_sysfs.c b/net/bluetooth/hci_sysfs.c
  static int hidp_parse(struct hid_device *hid)
  {
  	struct hidp_session *session = hid->driver_data;
-@@ -762,15 +769,44 @@ static struct hid_ll_driver hidp_hid_dri
+@@ -762,15 +771,44 @@ static struct hid_ll_driver hidp_hid_dri
  };
  
  static int hidp_setup_hid(struct hidp_session *session,
@@ -205,7 +266,7 @@ diff -Nur a/net/bluetooth/hci_sysfs.c b/net/bluetooth/hci_sysfs.c
  
  	session->hid = hid;
  	session->req = req;
-@@ -789,6 +825,8 @@ static int hidp_setup_hid(struct hidp_se
+@@ -789,6 +827,8 @@ static int hidp_setup_hid(struct hidp_se
  	strncpy(hid->phys, batostr(&src), 64);
  	strncpy(hid->uniq, batostr(&dst), 64);
  
@@ -214,7 +275,7 @@ diff -Nur a/net/bluetooth/hci_sysfs.c b/net/bluetooth/hci_sysfs.c
  	hid->dev.parent = hidp_get_device(session);
  	hid->ll_driver = &hidp_hid_driver;
  
-@@ -805,6 +843,24 @@ failed:
+@@ -805,6 +845,24 @@ failed:
  	session->hid = NULL;
  
  	return err;
@@ -239,7 +300,7 @@ diff -Nur a/net/bluetooth/hci_sysfs.c b/net/bluetooth/hci_sysfs.c
  }
  
  int hidp_add_connection(struct hidp_connadd_req *req, struct socket *ctrl_sock, struct socket *intr_sock)
-@@ -824,6 +880,39 @@ int hidp_add_connection(struct hidp_conn
+@@ -824,6 +882,39 @@ int hidp_add_connection(struct hidp_conn
  
  	BT_DBG("rd_data %p rd_size %d", req->rd_data, req->rd_size);
  
@@ -279,7 +340,7 @@ diff -Nur a/net/bluetooth/hci_sysfs.c b/net/bluetooth/hci_sysfs.c
  	down_write(&hidp_session_sem);
  
  	s = __hidp_get_session(&bt_sk(ctrl_sock->sk)->dst);
-@@ -851,6 +940,7 @@ int hidp_add_connection(struct hidp_conn
+@@ -851,6 +942,7 @@ int hidp_add_connection(struct hidp_conn
  	session->flags   = req->flags & (1 << HIDP_BLUETOOTH_VENDOR_ID);
  	session->idle_to = req->idle_to;
  
@@ -287,7 +348,7 @@ diff -Nur a/net/bluetooth/hci_sysfs.c b/net/bluetooth/hci_sysfs.c
  	if (req->rd_size > 0) {
  		err = hidp_setup_hid(session, req);
  		if (err && err != -ENODEV)
-@@ -862,6 +952,16 @@ int hidp_add_connection(struct hidp_conn
+@@ -862,6 +954,16 @@ int hidp_add_connection(struct hidp_conn
  		if (err < 0)
  			goto purge;
  	}
@@ -304,7 +365,7 @@ diff -Nur a/net/bluetooth/hci_sysfs.c b/net/bluetooth/hci_sysfs.c
  
  	__hidp_link_session(session);
  
-@@ -893,6 +993,7 @@ unlink:
+@@ -893,6 +995,7 @@ unlink:
  		session->input = NULL;
  	}
  
@@ -312,7 +373,7 @@ diff -Nur a/net/bluetooth/hci_sysfs.c b/net/bluetooth/hci_sysfs.c
  	if (session->hid) {
  		hid_destroy_device(session->hid);
  		session->hid = NULL;
-@@ -901,10 +1002,15 @@ unlink:
+@@ -901,10 +1004,15 @@ unlink:
  purge:
  	skb_queue_purge(&session->ctrl_transmit);
  	skb_queue_purge(&session->intr_transmit);
@@ -328,7 +389,7 @@ diff -Nur a/net/bluetooth/hci_sysfs.c b/net/bluetooth/hci_sysfs.c
  	input_free_device(session->input);
  	kfree(session);
  	return err;
-@@ -994,6 +1100,7 @@ int hidp_get_conninfo(struct hidp_connin
+@@ -994,6 +1102,7 @@ int hidp_get_conninfo(struct hidp_connin
  	return err;
  }
  
@@ -336,7 +397,7 @@ diff -Nur a/net/bluetooth/hci_sysfs.c b/net/bluetooth/hci_sysfs.c
  static const struct hid_device_id hidp_table[] = {
  	{ HID_BLUETOOTH_DEVICE(HID_ANY_ID, HID_ANY_ID) },
  	{ }
-@@ -1003,6 +1110,7 @@ static struct hid_driver hidp_driver = {
+@@ -1003,6 +1112,7 @@ static struct hid_driver hidp_driver = {
  	.name = "generic-bluetooth",
  	.id_table = hidp_table,
  };
@@ -344,7 +405,7 @@ diff -Nur a/net/bluetooth/hci_sysfs.c b/net/bluetooth/hci_sysfs.c
  
  static int __init hidp_init(void)
  {
-@@ -1012,11 +1120,14 @@ static int __init hidp_init(void)
+@@ -1012,11 +1122,14 @@ static int __init hidp_init(void)
  
  	BT_INFO("HIDP (Human Interface Emulation) ver %s", VERSION);
  
@@ -359,7 +420,7 @@ diff -Nur a/net/bluetooth/hci_sysfs.c b/net/bluetooth/hci_sysfs.c
  	if (ret)
  		goto err_drv;
  
-@@ -1024,13 +1135,16 @@ static int __init hidp_init(void)
+@@ -1024,13 +1137,16 @@ static int __init hidp_init(void)
  err_drv:
  	hid_unregister_driver(&hidp_driver);
  err:
@@ -376,9 +437,35 @@ diff -Nur a/net/bluetooth/hci_sysfs.c b/net/bluetooth/hci_sysfs.c
  }
  
  module_init(hidp_init);
---- a/net/bluetooth/rfcomm/sock.c	2009-12-10 09:48:33.000000000 -0800
-+++ b/net/bluetooth/rfcomm/sock.c	2009-12-10 09:48:37.000000000 -0800
-@@ -767,7 +767,11 @@ static int rfcomm_sock_setsockopt_old(st
+--- a/net/bluetooth/rfcomm/sock.c
++++ b/net/bluetooth/rfcomm/sock.c
+@@ -323,8 +323,13 @@ static struct sock *rfcomm_sock_alloc(st
+ 	return sk;
+ }
+ 
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32))
+ static int rfcomm_sock_create(struct net *net, struct socket *sock,
+ 			      int protocol, int kern)
++#else
++static int rfcomm_sock_create(struct net *net, struct socket *sock,
++			      int protocol)
++#endif
+ {
+ 	struct sock *sk;
+ 
+@@ -704,7 +709,11 @@ static int rfcomm_sock_recvmsg(struct ki
+ 		copied += chunk;
+ 		size   -= chunk;
+ 
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32))
+ 		sock_recv_ts_and_drops(msg, sk, skb);
++#else
++		sock_recv_timestamp(msg, sk, skb);
++#endif
+ 
+ 		if (!(flags & MSG_PEEK)) {
+ 			atomic_sub(chunk, &sk->sk_rmem_alloc);
+@@ -767,7 +776,11 @@ static int rfcomm_sock_setsockopt_old(st
  	return err;
  }
  
@@ -390,37 +477,49 @@ diff -Nur a/net/bluetooth/hci_sysfs.c b/net/bluetooth/hci_sysfs.c
  {
  	struct sock *sk = sock->sk;
  	struct bt_security sec;
-diff -Nur a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
---- a/net/bluetooth/rfcomm/tty.c	2009-11-25 11:24:43.000000000 +0530
-+++ b/net/bluetooth/rfcomm/tty.c	2009-11-27 15:25:36.000000000 +0530
-@@ -731,8 +731,12 @@
-	remove_wait_queue(&dev->wait, &wait);
-
-	if (err == 0)
+--- a/net/bluetooth/rfcomm/tty.c
++++ b/net/bluetooth/rfcomm/tty.c
+@@ -731,8 +731,12 @@ static int rfcomm_tty_open(struct tty_st
+ 	remove_wait_queue(&dev->wait, &wait);
+ 
+ 	if (err == 0)
 +#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,29))
-		device_move(dev->tty_dev, rfcomm_get_device(dev),
-			    DPM_ORDER_DEV_AFTER_PARENT);
+ 		device_move(dev->tty_dev, rfcomm_get_device(dev),
+ 			    DPM_ORDER_DEV_AFTER_PARENT);
 +#else
 +		device_move(dev->tty_dev, rfcomm_get_device(dev));
 +#endif
-
-	rfcomm_tty_copy_pending(dev);
-
-@@ -752,7 +756,11 @@
-
-	if (atomic_dec_and_test(&dev->opened)) {
-		if (dev->tty_dev->parent)
+ 
+ 	rfcomm_tty_copy_pending(dev);
+ 
+@@ -752,7 +756,11 @@ static void rfcomm_tty_close(struct tty_
+ 
+ 	if (atomic_dec_and_test(&dev->opened)) {
+ 		if (dev->tty_dev->parent)
 +#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,29))
-			device_move(dev->tty_dev, NULL, DPM_ORDER_DEV_LAST);
+ 			device_move(dev->tty_dev, NULL, DPM_ORDER_DEV_LAST);
 +#else
 +			device_move(dev->tty_dev, NULL);
 +#endif
-
-		/* Close DLC and dettach TTY */
-		rfcomm_dlc_close(dev->dlc, 0);
---- a/net/bluetooth/sco.c	2009-12-10 09:49:34.000000000 -0800
-+++ b/net/bluetooth/sco.c	2009-12-10 09:49:36.000000000 -0800
-@@ -645,7 +645,11 @@ static int sco_sock_sendmsg(struct kiocb
+ 
+ 		/* Close DLC and dettach TTY */
+ 		rfcomm_dlc_close(dev->dlc, 0);
+--- a/net/bluetooth/sco.c
++++ b/net/bluetooth/sco.c
+@@ -430,8 +430,12 @@ static struct sock *sco_sock_alloc(struc
+ 	return sk;
+ }
+ 
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32))
+ static int sco_sock_create(struct net *net, struct socket *sock, int protocol,
+ 			   int kern)
++#else
++static int sco_sock_create(struct net *net, struct socket *sock, int protocol)
++#endif
+ {
+ 	struct sock *sk;
+ 
+@@ -645,7 +649,11 @@ static int sco_sock_sendmsg(struct kiocb
  	return err;
  }
  
@@ -432,130 +531,53 @@ diff -Nur a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
  {
  	struct sock *sk = sock->sk;
  	int err = 0;
-diff -Nur orig_bt/net/bluetooth/af_bluetooth.c mod_bt/net/bluetooth/af_bluetooth.c
---- orig_bt/net/bluetooth/af_bluetooth.c	2009-12-15 16:40:20.000000000 +0530
-+++ mod_bt/net/bluetooth/af_bluetooth.c	2009-12-15 16:46:50.000000000 +0530
-@@ -126,8 +126,12 @@
- }
- EXPORT_SYMBOL(bt_sock_unregister);
-
-+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32))
- static int bt_sock_create(struct net *net, struct socket *sock, int proto,
-			  int kern)
-+#else
-+static int bt_sock_create(struct net *net, struct socket *sock, int proto)
-+#endif
- {
-	int err;
-
-@@ -145,7 +149,11 @@
-	read_lock(&bt_proto_lock);
-
-	if (bt_proto[proto] && try_module_get(bt_proto[proto]->owner)) {
-+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32))
-		err = bt_proto[proto]->create(net, sock, proto, kern);
-+#else
-+		err = bt_proto[proto]->create(net, sock, proto);
-+#endif
-		bt_sock_reclassify_lock(sock, proto);
-		module_put(bt_proto[proto]->owner);
-	}
-@@ -258,7 +266,11 @@
-	skb_reset_transport_header(skb);
-	err = skb_copy_datagram_iovec(skb, 0, msg->msg_iov, copied);
-	if (err == 0)
-+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32))
-		sock_recv_ts_and_drops(msg, sk, skb);
-+#else
-+	  sock_recv_timestamp(msg, sk, skb);
-+#endif
-
-	skb_free_datagram(sk, skb);
-
-diff -Nur orig_bt/net/bluetooth/bnep/sock.c mod_bt/net/bluetooth/bnep/sock.c
---- orig_bt/net/bluetooth/bnep/sock.c	2009-12-15 16:40:59.000000000 +0530
-+++ mod_bt/net/bluetooth/bnep/sock.c	2009-12-15 16:48:19.000000000 +0530
-@@ -195,8 +195,12 @@
-	.obj_size	= sizeof(struct bt_sock)
+--- a/net/bluetooth/bnep/sock.c
++++ b/net/bluetooth/bnep/sock.c
+@@ -195,8 +195,12 @@ static struct proto bnep_proto = {
+ 	.obj_size	= sizeof(struct bt_sock)
  };
-
+ 
 +#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32))
  static int bnep_sock_create(struct net *net, struct socket *sock, int protocol,
-			    int kern)
+ 			    int kern)
 +#else
 +static int bnep_sock_create(struct net *net, struct socket *sock, int protocol)
 +#endif
  {
-	struct sock *sk;
-
-diff -Nur orig_bt/net/bluetooth/cmtp/sock.c mod_bt/net/bluetooth/cmtp/sock.c
---- orig_bt/net/bluetooth/cmtp/sock.c	2009-12-15 16:41:29.000000000 +0530
-+++ mod_bt/net/bluetooth/cmtp/sock.c	2009-12-15 16:48:31.000000000 +0530
-@@ -190,8 +190,12 @@
-	.obj_size	= sizeof(struct bt_sock)
+ 	struct sock *sk;
+ 
+--- a/net/bluetooth/cmtp/sock.c
++++ b/net/bluetooth/cmtp/sock.c
+@@ -190,8 +190,12 @@ static struct proto cmtp_proto = {
+ 	.obj_size	= sizeof(struct bt_sock)
  };
-
+ 
 +#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32))
  static int cmtp_sock_create(struct net *net, struct socket *sock, int protocol,
-			    int kern)
+ 			    int kern)
 +#else
 +static int cmtp_sock_create(struct net *net, struct socket *sock, int protocol)
 +#endif
  {
-	struct sock *sk;
-
-diff -Nur orig_bt/net/bluetooth/hci_sock.c mod_bt/net/bluetooth/hci_sock.c
---- orig_bt/net/bluetooth/hci_sock.c	2009-12-15 16:40:20.000000000 +0530
-+++ mod_bt/net/bluetooth/hci_sock.c	2009-12-15 16:47:47.000000000 +0530
-@@ -630,8 +630,12 @@
-	.obj_size	= sizeof(struct hci_pinfo)
- };
-
-+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32))
- static int hci_sock_create(struct net *net, struct socket *sock, int protocol,
-			   int kern)
-+#else
-+static int hci_sock_create(struct net *net, struct socket *sock, int protocol)
-+#endif
- {
-	struct sock *sk;
-
-diff -Nur orig_bt/net/bluetooth/hidp/core.c mod_bt/net/bluetooth/hidp/core.c
---- orig_bt/net/bluetooth/hidp/core.c	2009-12-15 16:41:45.000000000 +0530
-+++ mod_bt/net/bluetooth/hidp/core.c	2009-12-15 16:48:45.000000000 +0530
-@@ -280,12 +280,14 @@
-	return hidp_queue_report(session, buf, rsize);
- }
-
-+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,27))
- static int hidp_output_raw_report(struct hid_device *hid, unsigned char *data, size_t count)
- {
-	if (hidp_queue_report(hid->driver_data, data, count))
-		return -ENOMEM;
-	return count;
- }
-+#endif
-
- static void hidp_idle_timeout(unsigned long arg)
- {
-diff -Nur orig_bt/net/bluetooth/hidp/sock.c mod_bt/net/bluetooth/hidp/sock.c
---- orig_bt/net/bluetooth/hidp/sock.c	2009-12-15 16:41:45.000000000 +0530
-+++ mod_bt/net/bluetooth/hidp/sock.c	2009-12-15 16:48:51.000000000 +0530
-@@ -241,8 +241,12 @@
-	.obj_size	= sizeof(struct bt_sock)
+ 	struct sock *sk;
+ 
+--- a/net/bluetooth/hidp/sock.c
++++ b/net/bluetooth/hidp/sock.c
+@@ -241,8 +241,12 @@ static struct proto hidp_proto = {
+ 	.obj_size	= sizeof(struct bt_sock)
  };
-
+ 
 +#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32))
  static int hidp_sock_create(struct net *net, struct socket *sock, int protocol,
-			    int kern)
+ 			    int kern)
 +#else
 +static int hidp_sock_create(struct net *net, struct socket *sock, int protocol)
 +#endif
  {
-	struct sock *sk;
-
---- a/net/bluetooth/l2cap.c	2009-12-28 17:53:34.000000000 -0800
-+++ b/net/bluetooth/l2cap.c	2009-12-28 17:53:36.000000000 -0800
+ 	struct sock *sk;
+ 
+--- a/net/bluetooth/l2cap.c
++++ b/net/bluetooth/l2cap.c
 @@ -822,8 +822,12 @@ static struct sock *l2cap_sock_alloc(str
  	return sk;
  }
@@ -593,48 +615,3 @@ diff -Nur orig_bt/net/bluetooth/hidp/sock.c mod_bt/net/bluetooth/hidp/sock.c
  {
  	struct sock *sk = sock->sk;
  	struct bt_security sec;
-diff -Nur orig_bt/net/bluetooth/rfcomm/sock.c mod_bt/net/bluetooth/rfcomm/sock.c
---- orig_bt/net/bluetooth/rfcomm/sock.c	2009-12-15 16:42:14.000000000 +0530
-+++ mod_bt/net/bluetooth/rfcomm/sock.c	2009-12-15 16:49:07.000000000 +0530
-@@ -323,8 +323,13 @@
-	return sk;
- }
-
-+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32))
- static int rfcomm_sock_create(struct net *net, struct socket *sock,
-			      int protocol, int kern)
-+#else
-+static int rfcomm_sock_create(struct net *net, struct socket *sock,
-+			      int protocol)
-+#endif
- {
-	struct sock *sk;
-
-@@ -704,7 +709,11 @@
-		copied += chunk;
-		size   -= chunk;
-
-+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32))
-		sock_recv_ts_and_drops(msg, sk, skb);
-+#else
-+		sock_recv_timestamp(msg, sk, skb);
-+#endif
-
-		if (!(flags & MSG_PEEK)) {
-			atomic_sub(chunk, &sk->sk_rmem_alloc);
-diff -Nur orig_bt/net/bluetooth/sco.c mod_bt/net/bluetooth/sco.c
---- orig_bt/net/bluetooth/sco.c	2009-12-15 16:40:20.000000000 +0530
-+++ mod_bt/net/bluetooth/sco.c	2009-12-15 16:47:04.000000000 +0530
-@@ -430,8 +430,12 @@
-	return sk;
- }
-
-+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32))
- static int sco_sock_create(struct net *net, struct socket *sock, int protocol,
-			   int kern)
-+#else
-+static int sco_sock_create(struct net *net, struct socket *sock, int protocol)
-+#endif
- {
-	struct sock *sk;
-
diff --git a/patches/17-netdev-queue.patch b/patches/17-netdev-queue.patch
index 015f503..0ecc23f 100644
--- a/patches/17-netdev-queue.patch
+++ b/patches/17-netdev-queue.patch
@@ -12,9 +12,9 @@ The patch that introduced this on mac80211 was:
     Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
     Signed-off-by: John W. Linville <linville@tuxdriver.com>
 
---- a/net/mac80211/iface.c	2009-12-28 17:55:57.000000000 -0800
-+++ b/net/mac80211/iface.c	2009-12-28 17:55:58.000000000 -0800
-@@ -904,6 +904,7 @@ void ieee80211_if_remove(struct ieee8021
+--- a/net/mac80211/iface.c
++++ b/net/mac80211/iface.c
+@@ -901,6 +901,7 @@ void ieee80211_if_remove(struct ieee8021
   * Remove all interfaces, may only be called at hardware unregistration
   * time because it doesn't do RCU-safe list removals.
   */
@@ -22,7 +22,7 @@ The patch that introduced this on mac80211 was:
  void ieee80211_remove_interfaces(struct ieee80211_local *local)
  {
  	struct ieee80211_sub_if_data *sdata, *tmp;
-@@ -920,6 +921,22 @@ void ieee80211_remove_interfaces(struct 
+@@ -917,6 +918,22 @@ void ieee80211_remove_interfaces(struct 
  	mutex_unlock(&local->iflist_mtx);
  	unregister_netdevice_many(&unreg_list);
  }
diff --git a/patches/18-rename-usb-net-symbols.patch b/patches/18-rename-usb-net-symbols.patch
index d8f6ca3..5ac90e2 100644
--- a/patches/18-rename-usb-net-symbols.patch
+++ b/patches/18-rename-usb-net-symbols.patch
@@ -4,8 +4,6 @@ usb_autopm_put_interface_async and usb_autopm_get_interface_async are
 not backported to kernel 2.6.28 and earlier.
 Remove this patch if these symbols are backported.
 
-diff --git a/drivers/net/usb/Makefile b/drivers/net/usb/Makefile
-index e17afb7..ddea3ae 100644
 --- a/drivers/net/usb/Makefile
 +++ b/drivers/net/usb/Makefile
 @@ -8,18 +8,18 @@ obj-$(CONFIG_USB_PEGASUS)	+= pegasus.o
@@ -30,8 +28,6 @@ index e17afb7..ddea3ae 100644
  obj-$(CONFIG_USB_NET_INT51X1)	+= int51x1.o
  obj-$(CONFIG_USB_CDC_PHONET)	+= cdc-phonet.o
  
-diff --git a/drivers/net/usb/cdc_ether.c b/drivers/net/usb/cdc_ether.c
-index 21e183a..65c385f 100644
 --- a/drivers/net/usb/cdc_ether.c
 +++ b/drivers/net/usb/cdc_ether.c
 @@ -33,7 +33,7 @@
@@ -43,8 +39,6 @@ index 21e183a..65c385f 100644
  
  static int is_rndis(struct usb_interface_descriptor *desc)
  {
-diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
-index 5d4ce4d..d4e48bd 100644
 --- a/drivers/net/wireless/Makefile
 +++ b/drivers/net/wireless/Makefile
 @@ -29,7 +29,7 @@ obj-$(CONFIG_RTL8187)		+= rtl818x/
diff --git a/patches/19-kfifo.patch b/patches/19-kfifo.patch
index d59f76e..08420af 100644
--- a/patches/19-kfifo.patch
+++ b/patches/19-kfifo.patch
@@ -17,7 +17,7 @@ not be backported easily with defines in the compat module.
  	struct task_struct *main_thread;
 --- a/drivers/net/wireless/libertas/main.c
 +++ b/drivers/net/wireless/libertas/main.c
-@@ -872,8 +872,14 @@ static int lbs_init_adapter(struct lbs_private *priv)
+@@ -872,8 +872,14 @@ static int lbs_init_adapter(struct lbs_p
  	priv->resp_len[0] = priv->resp_len[1] = 0;
  
  	/* Create the event FIFO */
@@ -32,7 +32,7 @@ not be backported easily with defines in the compat module.
  		lbs_pr_err("Out of memory allocating event FIFO buffer\n");
  		goto out;
  	}
-@@ -889,7 +895,12 @@ static void lbs_free_adapter(struct lbs_private *priv)
+@@ -889,7 +895,12 @@ static void lbs_free_adapter(struct lbs_
  	lbs_deb_enter(LBS_DEB_MAIN);
  
  	lbs_free_cmd_buffer(priv);
diff --git a/patches/99-change-makefiles.patch b/patches/99-change-makefiles.patch
index c0752dc..2fe68e5 100644
--- a/patches/99-change-makefiles.patch
+++ b/patches/99-change-makefiles.patch
@@ -11,8 +11,8 @@ only the wireless stuff.
 -obj-$(CONFIG_EEPROM_LEGACY)	+= eeprom.o
 -obj-$(CONFIG_EEPROM_MAX6875)	+= max6875.o
  obj-$(CONFIG_EEPROM_93CX6)	+= eeprom_93cx6.o
---- a/drivers/net/usb/Makefile	2009-07-27 08:03:34.770077174 -0700
-+++ b/drivers/net/usb/Makefile	2009-07-27 08:04:22.594143560 -0700
+--- a/drivers/net/usb/Makefile
++++ b/drivers/net/usb/Makefile
 @@ -2,24 +2,7 @@
  # Makefile for USB Network drivers
  #
@@ -38,8 +38,8 @@ only the wireless stuff.
 -obj-$(CONFIG_USB_NET_INT51X1)	+= int51x1.o
 -obj-$(CONFIG_USB_CDC_PHONET)	+= cdc-phonet.o
  
---- a/drivers/net/wireless/Makefile	2009-12-10 22:57:15.000000000 -0800
-+++ b/drivers/net/wireless/Makefile	2009-12-10 22:57:16.000000000 -0800
+--- a/drivers/net/wireless/Makefile
++++ b/drivers/net/wireless/Makefile
 @@ -5,33 +5,16 @@
  obj-$(CONFIG_IPW2100) += ipw2x00/
  obj-$(CONFIG_IPW2200) += ipw2x00/
@@ -74,9 +74,9 @@ only the wireless stuff.
  obj-$(CONFIG_LIBERTAS)		+= libertas/
  
  obj-$(CONFIG_LIBERTAS_THINFIRM)	+= libertas_tf/
---- a/net/wireless/Makefile	2009-10-06 13:00:59.000000000 -0400
-+++ b/net/wireless/Makefile	2009-10-06 13:00:59.000000000 -0400
-@@ -4,11 +4,6 @@
+--- a/net/wireless/Makefile
++++ b/net/wireless/Makefile
+@@ -4,11 +4,6 @@ obj-$(CONFIG_LIB80211_CRYPT_WEP) += lib8
  obj-$(CONFIG_LIB80211_CRYPT_CCMP) += lib80211_crypt_ccmp.o
  obj-$(CONFIG_LIB80211_CRYPT_TKIP) += lib80211_crypt_tkip.o
  
-- 
1.6.3.3

