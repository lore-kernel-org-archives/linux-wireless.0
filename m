Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:48336 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384AbZKZVbL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2009 16:31:11 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] [compat-2.6] refresh patches
Date: Thu, 26 Nov 2009 22:31:03 +0100
Message-Id: <1259271064-11298-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

net_device_ops backports for libipw where missing.
Backport net_device_ops in drivers/net/wireless/libertas/mesh.c

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/patches/01-netdev.patch                     |  115 +++++++++++---------
 compat/patches/03-rfkill.patch                     |    8 +-
 compat/patches/08-rename-iwl4965-config.patch      |    6 +-
 .../patches/10-add-wext-handlers-to-netdev.patch   |    2 +-
 compat/patches/12-iw_handler-changes.patch         |    2 +-
 compat/patches/13-trace.patch                      |    4 +-
 compat/patches/15-symbol-export-conflicts.patch    |    2 +-
 7 files changed, 77 insertions(+), 62 deletions(-)

diff --git a/compat/patches/01-netdev.patch b/compat/patches/01-netdev.patch
index d66a2f4..b66e9b0 100644
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
  
@@ -432,39 +445,7 @@ without creating a headache on maintenance of the pathes.
  	dev->watchdog_timeo = 5 * HZ;
  	dev->ethtool_ops = &lbs_ethtool_ops;
  #ifdef	WIRELESS_EXT
-@@ -1405,6 +1416,7 @@
- EXPORT_SYMBOL_GPL(lbs_stop_card);
- 
- 
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
- static const struct net_device_ops mesh_netdev_ops = {
- 	.ndo_open		= lbs_dev_open,
- 	.ndo_stop 		= lbs_mesh_stop,
-@@ -1412,6 +1424,7 @@
- 	.ndo_set_mac_address	= lbs_set_mac_address,
- 	.ndo_set_multicast_list = lbs_set_multicast_list,
- };
-+#endif
- 
- /**
-  * @brief This function adds mshX interface
-@@ -1435,7 +1448,15 @@
- 	mesh_dev->ml_priv = priv;
- 	priv->mesh_dev = mesh_dev;
- 
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
- 	mesh_dev->netdev_ops = &mesh_netdev_ops;
-+#else
-+	mesh_dev->open = lbs_dev_open;
-+	mesh_dev->hard_start_xmit = lbs_hard_start_xmit;
-+	mesh_dev->stop = lbs_mesh_stop;
-+	mesh_dev->set_mac_address = lbs_set_mac_address;
-+	mesh_dev->set_multicast_list = lbs_set_multicast_list;
-+#endif
- 	mesh_dev->ethtool_ops = &lbs_ethtool_ops;
- 	memcpy(mesh_dev->dev_addr, priv->dev->dev_addr,
- 			sizeof(priv->dev->dev_addr));
-@@ -1589,11 +1610,13 @@
+@@ -1262,11 +1273,13 @@
  	lbs_deb_leave(LBS_DEB_MAIN);
  }
  
@@ -478,7 +459,7 @@ without creating a headache on maintenance of the pathes.
  
  static int lbs_add_rtap(struct lbs_private *priv)
  {
-@@ -1614,7 +1637,13 @@
+@@ -1287,7 +1300,13 @@
  
  	memcpy(rtap_dev->dev_addr, priv->current_addr, ETH_ALEN);
  	rtap_dev->type = ARPHRD_IEEE80211_RADIOTAP;
@@ -492,6 +473,40 @@ without creating a headache on maintenance of the pathes.
  	rtap_dev->ml_priv = priv;
  	SET_NETDEV_DEV(rtap_dev, priv->dev->dev.parent);
  
+--- a/drivers/net/wireless/libertas/mesh.c
++++ b/drivers/net/wireless/libertas/mesh.c
+@@ -318,6 +318,7 @@
+ 	return ret;
+ }
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+ static const struct net_device_ops mesh_netdev_ops = {
+ 	.ndo_open		= lbs_mesh_dev_open,
+ 	.ndo_stop 		= lbs_mesh_stop,
+@@ -325,6 +326,7 @@
+ 	.ndo_set_mac_address	= lbs_set_mac_address,
+ 	.ndo_set_multicast_list = lbs_set_multicast_list,
+ };
++#endif
+ 
+ /**
+  * @brief This function adds mshX interface
+@@ -349,7 +351,15 @@
+ 	mesh_dev->ml_priv = priv;
+ 	priv->mesh_dev = mesh_dev;
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+ 	mesh_dev->netdev_ops = &mesh_netdev_ops;
++#else
++	mesh_dev->open = lbs_mesh_dev_open;
++	mesh_dev->hard_start_xmit = lbs_hard_start_xmit;
++	mesh_dev->stop = lbs_mesh_stop;
++	mesh_dev->set_mac_address = lbs_set_mac_address;
++	mesh_dev->set_multicast_list = lbs_set_multicast_list;
++#endif
+ 	mesh_dev->ethtool_ops = &lbs_ethtool_ops;
+ 	memcpy(mesh_dev->dev_addr, priv->dev->dev_addr,
+ 			sizeof(priv->dev->dev_addr));
 --- a/drivers/net/wireless/libertas/defs.h	2009-07-08 14:04:29.692256519 -0700
 +++ b/drivers/net/wireless/libertas/defs.h	2009-07-08 14:03:26.712279246 -0700
 @@ -16,6 +16,14 @@
diff --git a/compat/patches/03-rfkill.patch b/compat/patches/03-rfkill.patch
index e87f69c..a444a65 100644
--- a/compat/patches/03-rfkill.patch
+++ b/compat/patches/03-rfkill.patch
@@ -137,7 +137,7 @@ This would do the policing from within mac80211.
  static long rfkill_fop_ioctl(struct file *file, unsigned int cmd,
  			     unsigned long arg)
  {
-@@ -1196,7 +1196,7 @@
+@@ -1197,7 +1197,7 @@
  	.write		= rfkill_fop_write,
  	.poll		= rfkill_fop_poll,
  	.release	= rfkill_fop_release,
@@ -146,7 +146,7 @@ This would do the policing from within mac80211.
  	.unlocked_ioctl	= rfkill_fop_ioctl,
  	.compat_ioctl	= rfkill_fop_ioctl,
  #endif
-@@ -1226,7 +1226,7 @@
+@@ -1227,7 +1227,7 @@
  		goto out;
  	}
  
@@ -155,7 +155,7 @@ This would do the policing from within mac80211.
  	error = rfkill_handler_init();
  	if (error) {
  		misc_deregister(&rfkill_miscdev);
-@@ -1242,7 +1242,7 @@
+@@ -1243,7 +1243,7 @@
  
  static void __exit rfkill_exit(void)
  {
@@ -208,7 +208,7 @@ This would do the policing from within mac80211.
  #include <net/cfg80211.h>
 --- a/drivers/net/wireless/ath/ath9k/hw.c	2009-11-02 08:06:38.000000000 -0800
 +++ b/drivers/net/wireless/ath/ath9k/hw.c	2009-11-02 08:06:39.000000000 -0800
-@@ -3246,7 +3246,7 @@
+@@ -3251,7 +3251,7 @@
  
  	pCap->hw_caps |= ATH9K_HW_CAP_ENHANCEDPM;
  
diff --git a/compat/patches/08-rename-iwl4965-config.patch b/compat/patches/08-rename-iwl4965-config.patch
index 475c15f..f896939 100644
--- a/compat/patches/08-rename-iwl4965-config.patch
+++ b/compat/patches/08-rename-iwl4965-config.patch
@@ -16,7 +16,7 @@ CONFIG_IWL4965 has to be set to y, to build correctly.
  iwlagn-$(CONFIG_IWL5000) += iwl-1000.o
 --- a/drivers/net/wireless/iwlwifi/iwl-agn.c	2009-11-13 11:38:35.000000000 -0800
 +++ b/drivers/net/wireless/iwlwifi/iwl-agn.c	2009-11-13 11:38:36.000000000 -0800
-@@ -3534,10 +3534,10 @@
+@@ -3586,10 +3586,10 @@
  
  /* Hardware specific file defines the PCI IDs table for that hardware module */
  static struct pci_device_id iwl_hw_card_ids[] = {
@@ -27,5 +27,5 @@ CONFIG_IWL4965 has to be set to y, to build correctly.
 -#endif /* CONFIG_IWL4965 */
 +#endif /* CONFIG_COMPAT_IWL4965 */
  #ifdef CONFIG_IWL5000
- 	{IWL_PCI_DEVICE(0x4232, 0x1205, iwl5100_bg_cfg)},
- 	{IWL_PCI_DEVICE(0x4232, 0x1305, iwl5100_bg_cfg)},
+ /* 5100 Series WiFi */
+ 	{IWL_PCI_DEVICE(0x4232, 0x1201, iwl5100_agn_cfg)}, /* Mini Card */
diff --git a/compat/patches/10-add-wext-handlers-to-netdev.patch b/compat/patches/10-add-wext-handlers-to-netdev.patch
index 9159613..e5112e3 100644
--- a/compat/patches/10-add-wext-handlers-to-netdev.patch
+++ b/compat/patches/10-add-wext-handlers-to-netdev.patch
@@ -13,7 +13,7 @@ the struct wiphy wireless handler.
 
 --- a/net/wireless/core.c	2009-11-02 08:08:20.000000000 -0800
 +++ b/net/wireless/core.c	2009-11-02 08:08:21.000000000 -0800
-@@ -673,6 +673,10 @@
+@@ -676,6 +676,10 @@
  		wdev->sme_state = CFG80211_SME_IDLE;
  		mutex_unlock(&rdev->devlist_mtx);
  #ifdef CONFIG_CFG80211_WEXT
diff --git a/compat/patches/12-iw_handler-changes.patch b/compat/patches/12-iw_handler-changes.patch
index 7a700b1..fb97af5 100644
--- a/compat/patches/12-iw_handler-changes.patch
+++ b/compat/patches/12-iw_handler-changes.patch
@@ -1,6 +1,6 @@
 --- a/drivers/net/wireless/ipw2x00/ipw2100.c	2009-10-08 11:01:52.000000000 -0400
 +++ b/drivers/net/wireless/ipw2x00/ipw2100.c	2009-10-08 11:01:43.000000000 -0400
-@@ -6057,7 +6057,11 @@
+@@ -6140,7 +6140,11 @@
  
  	dev->ethtool_ops = &ipw2100_ethtool_ops;
  	dev->wireless_handlers = &ipw2100_wx_handler_def;
diff --git a/compat/patches/13-trace.patch b/compat/patches/13-trace.patch
index d3a3dcd..7668d50 100644
--- a/compat/patches/13-trace.patch
+++ b/compat/patches/13-trace.patch
@@ -16,7 +16,7 @@ in or compat headers.
  #include "iwl-dev.h"
  
  #if !defined(CONFIG_IWLWIFI_DEVICE_TRACING) || defined(__CHECKER__)
-@@ -175,4 +175,6 @@
+@@ -194,4 +196,6 @@ TRACE_EVENT(iwlwifi_dev_ucode_event,
  #define TRACE_INCLUDE_PATH .
  #undef TRACE_INCLUDE_FILE
  #define TRACE_INCLUDE_FILE iwl-devtrace
@@ -35,7 +35,7 @@ in or compat headers.
  #include <net/mac80211.h>
  #include "ieee80211_i.h"
  
-@@ -672,4 +674,6 @@ TRACE_EVENT(drv_ampdu_action,
+@@ -694,4 +696,6 @@ TRACE_EVENT(drv_ampdu_action,
  #define TRACE_INCLUDE_PATH .
  #undef TRACE_INCLUDE_FILE
  #define TRACE_INCLUDE_FILE driver-trace
diff --git a/compat/patches/15-symbol-export-conflicts.patch b/compat/patches/15-symbol-export-conflicts.patch
index 2cc25cc..0538671 100644
--- a/compat/patches/15-symbol-export-conflicts.patch
+++ b/compat/patches/15-symbol-export-conflicts.patch
@@ -3,7 +3,7 @@ To avoid conflicts with the other export we rename our.
 
 --- a/net/mac80211/rx.c	2009-11-13 11:41:29.000000000 -0800
 +++ b/net/mac80211/rx.c	2009-11-13 11:41:30.000000000 -0800
-@@ -2516,7 +2516,12 @@
+@@ -2537,7 +2537,12 @@
   drop:
  	kfree_skb(skb);
  }
-- 
1.6.3.3

