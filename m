Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:39940 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754917AbZKTWCg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2009 17:02:36 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/3] [compat-2.6] Refresh patches
Date: Fri, 20 Nov 2009 23:01:53 +0100
Message-Id: <1258754513-4546-4-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1258754513-4546-1-git-send-email-hauke@hauke-m.de>
References: <1258754513-4546-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/patches/01-netdev.patch                     |   24 ++++++++++----------
 compat/patches/02-ksize.patch                      |    2 +-
 compat/patches/03-rfkill.patch                     |   20 ++++++++--------
 compat/patches/05-usb.patch                        |    2 +-
 compat/patches/06-header-changes.patch             |    2 +-
 compat/patches/08-rename-iwl4965-config.patch      |    2 +-
 .../patches/10-add-wext-handlers-to-netdev.patch   |    2 +-
 compat/patches/13-trace.patch                      |    2 +-
 compat/patches/14-device-type.patch                |    2 +-
 compat/patches/15-symbol-export-conflicts.patch    |    2 +-
 10 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/compat/patches/01-netdev.patch b/compat/patches/01-netdev.patch
index 37f2a9e..d66a2f4 100644
--- a/compat/patches/01-netdev.patch
+++ b/compat/patches/01-netdev.patch
@@ -72,7 +72,7 @@ without creating a headache on maintenance of the pathes.
  
 --- a/drivers/net/wireless/rndis_wlan.c	2009-09-02 14:08:52.418110490 -0700
 +++ b/drivers/net/wireless/rndis_wlan.c	2009-09-02 14:08:52.930092180 -0700
-@@ -2667,6 +2667,7 @@
+@@ -2669,6 +2669,7 @@
  	return 0;
  }
  
@@ -80,7 +80,7 @@ without creating a headache on maintenance of the pathes.
  /* same as rndis_netdev_ops but with local multicast handler */
  static const struct net_device_ops rndis_wlan_netdev_ops = {
  	.ndo_open		= usbnet_open,
-@@ -2677,6 +2678,7 @@
+@@ -2679,6 +2680,7 @@
  	.ndo_validate_addr	= eth_validate_addr,
  	.ndo_set_multicast_list	= rndis_wlan_set_multicast_list,
  };
@@ -88,7 +88,7 @@ without creating a headache on maintenance of the pathes.
  
  static int rndis_wlan_bind(struct usbnet *usbdev, struct usb_interface *intf)
  {
-@@ -2724,7 +2726,11 @@
+@@ -2726,7 +2728,11 @@
  	 * rndis_host wants to avoid all OID as much as possible
  	 * so do promisc/multicast handling in rndis_wlan.
  	 */
@@ -157,7 +157,7 @@ without creating a headache on maintenance of the pathes.
  		sdata->u.mntr_flags = MONITOR_FLAG_CONTROL |
  				      MONITOR_FLAG_OTHER_BSS;
  		break;
-@@ -777,6 +797,8 @@
+@@ -778,6 +798,8 @@
  		return -ENOMEM;
  	dev_net_set(ndev, wiphy_net(local->hw.wiphy));
  
@@ -166,7 +166,7 @@ without creating a headache on maintenance of the pathes.
  	ndev->needed_headroom = local->tx_headroom +
  				4*6 /* four MAC addresses */
  				+ 2 + 2 + 2 + 2 /* ctl, dur, seq, qos */
-@@ -785,6 +807,7 @@
+@@ -786,6 +808,7 @@
  				- ETH_HLEN /* ethernet hard_header_len */
  				+ IEEE80211_ENCRYPT_HEADROOM;
  	ndev->needed_tailroom = IEEE80211_ENCRYPT_TAILROOM;
@@ -174,7 +174,7 @@ without creating a headache on maintenance of the pathes.
  
  	ret = dev_alloc_name(ndev, ndev->name);
  	if (ret < 0)
-@@ -819,6 +842,10 @@
+@@ -826,6 +849,10 @@
  	if (ret)
  		goto fail;
  
@@ -335,7 +335,7 @@ without creating a headache on maintenance of the pathes.
  	priv->wireless_data.libipw = priv->ieee;
 --- a/drivers/net/wireless/ipw2x00/ipw2200.c	2009-11-13 11:37:43.000000000 -0800
 +++ b/drivers/net/wireless/ipw2x00/ipw2200.c	2009-11-13 11:37:43.000000000 -0800
-@@ -11631,6 +11631,7 @@
+@@ -11546,6 +11546,7 @@
  	return NETDEV_TX_OK;
  }
  
@@ -343,7 +343,7 @@ without creating a headache on maintenance of the pathes.
  static const struct net_device_ops ipw_prom_netdev_ops = {
  	.ndo_open 		= ipw_prom_open,
  	.ndo_stop		= ipw_prom_stop,
-@@ -11639,6 +11640,7 @@
+@@ -11554,6 +11555,7 @@
  	.ndo_set_mac_address 	= eth_mac_addr,
  	.ndo_validate_addr	= eth_validate_addr,
  };
@@ -351,7 +351,7 @@ without creating a headache on maintenance of the pathes.
  
  static int ipw_prom_alloc(struct ipw_priv *priv)
  {
-@@ -11659,7 +11661,13 @@
+@@ -11574,7 +11576,13 @@
  	memcpy(priv->prom_net_dev->dev_addr, priv->mac_addr, ETH_ALEN);
  
  	priv->prom_net_dev->type = ARPHRD_IEEE80211_RADIOTAP;
@@ -365,7 +365,7 @@ without creating a headache on maintenance of the pathes.
  
  	priv->prom_priv->ieee->iw_mode = IW_MODE_MONITOR;
  	SET_NETDEV_DEV(priv->prom_net_dev, &priv->pci_dev->dev);
-@@ -11687,6 +11695,7 @@
+@@ -11602,6 +11610,7 @@
  
  #endif
  
@@ -373,7 +373,7 @@ without creating a headache on maintenance of the pathes.
  static const struct net_device_ops ipw_netdev_ops = {
  	.ndo_init		= ipw_net_init,
  	.ndo_open		= ipw_net_open,
-@@ -11697,6 +11706,7 @@
+@@ -11612,6 +11621,7 @@
  	.ndo_change_mtu		= libipw_change_mtu,
  	.ndo_validate_addr	= eth_validate_addr,
  };
@@ -381,7 +381,7 @@ without creating a headache on maintenance of the pathes.
  
  static int __devinit ipw_pci_probe(struct pci_dev *pdev,
  				   const struct pci_device_id *ent)
-@@ -11798,7 +11808,15 @@
+@@ -11713,7 +11723,15 @@
  	priv->ieee->perfect_rssi = -20;
  	priv->ieee->worst_rssi = -85;
  
diff --git a/compat/patches/02-ksize.patch b/compat/patches/02-ksize.patch
index 6d97675..48964e2 100644
--- a/compat/patches/02-ksize.patch
+++ b/compat/patches/02-ksize.patch
@@ -12,7 +12,7 @@ of the situation.
 
 --- a/net/wireless/scan.c	2009-09-02 14:13:33.769092519 -0700
 +++ b/net/wireless/scan.c	2009-09-02 14:13:34.925094548 -0700
-@@ -422,7 +422,12 @@
+@@ -423,7 +423,12 @@
  			size_t used = dev->wiphy.bss_priv_size + sizeof(*res);
  			size_t ielen = res->pub.len_information_elements;
  
diff --git a/compat/patches/03-rfkill.patch b/compat/patches/03-rfkill.patch
index 28e0b18..e87f69c 100644
--- a/compat/patches/03-rfkill.patch
+++ b/compat/patches/03-rfkill.patch
@@ -101,7 +101,7 @@ This would do the policing from within mac80211.
  static atomic_t rfkill_input_disabled = ATOMIC_INIT(0);
  
  /**
-@@ -777,7 +777,7 @@
+@@ -779,7 +779,7 @@
  }
  
  static struct class rfkill_class = {
@@ -110,7 +110,7 @@ This would do the policing from within mac80211.
  	.dev_release	= rfkill_release,
  	.dev_attrs	= rfkill_dev_attrs,
  	.dev_uevent	= rfkill_dev_uevent,
-@@ -923,7 +923,7 @@
+@@ -925,7 +925,7 @@
  	if (!rfkill->persistent || rfkill_epo_lock_active) {
  		schedule_work(&rfkill->sync_work);
  	} else {
@@ -119,7 +119,7 @@ This would do the policing from within mac80211.
  		bool soft_blocked = !!(rfkill->state & RFKILL_BLOCK_SW);
  
  		if (!atomic_read(&rfkill_input_disabled))
-@@ -1151,7 +1151,7 @@
+@@ -1153,7 +1153,7 @@
  	list_for_each_entry_safe(ev, tmp, &data->events, list)
  		kfree(ev);
  
@@ -128,7 +128,7 @@ This would do the policing from within mac80211.
  	if (data->input_handler)
  		if (atomic_dec_return(&rfkill_input_disabled) == 0)
  			printk(KERN_DEBUG "rfkill: input handler enabled\n");
-@@ -1162,7 +1162,7 @@
+@@ -1164,7 +1164,7 @@
  	return 0;
  }
  
@@ -137,7 +137,7 @@ This would do the policing from within mac80211.
  static long rfkill_fop_ioctl(struct file *file, unsigned int cmd,
  			     unsigned long arg)
  {
-@@ -1194,7 +1194,7 @@
+@@ -1196,7 +1196,7 @@
  	.write		= rfkill_fop_write,
  	.poll		= rfkill_fop_poll,
  	.release	= rfkill_fop_release,
@@ -146,7 +146,7 @@ This would do the policing from within mac80211.
  	.unlocked_ioctl	= rfkill_fop_ioctl,
  	.compat_ioctl	= rfkill_fop_ioctl,
  #endif
-@@ -1224,7 +1224,7 @@
+@@ -1226,7 +1226,7 @@
  		goto out;
  	}
  
@@ -155,7 +155,7 @@ This would do the policing from within mac80211.
  	error = rfkill_handler_init();
  	if (error) {
  		misc_deregister(&rfkill_miscdev);
-@@ -1240,7 +1240,7 @@
+@@ -1242,7 +1242,7 @@
  
  static void __exit rfkill_exit(void)
  {
@@ -174,7 +174,7 @@ This would do the policing from within mac80211.
  
  /* define userspace visible states */
  #define RFKILL_STATE_SOFT_BLOCKED	0
-@@ -145,7 +146,7 @@
+@@ -148,7 +149,7 @@
  	int	(*set_block)(void *data, bool blocked);
  };
  
@@ -183,7 +183,7 @@ This would do the policing from within mac80211.
  /**
   * rfkill_alloc - allocate rfkill structure
   * @name: name of the struct -- the string is not copied internally
-@@ -352,7 +353,7 @@
+@@ -355,7 +356,7 @@
  #endif /* RFKILL || RFKILL_MODULE */
  
  
@@ -208,7 +208,7 @@ This would do the policing from within mac80211.
  #include <net/cfg80211.h>
 --- a/drivers/net/wireless/ath/ath9k/hw.c	2009-11-02 08:06:38.000000000 -0800
 +++ b/drivers/net/wireless/ath/ath9k/hw.c	2009-11-02 08:06:39.000000000 -0800
-@@ -3254,7 +3254,7 @@
+@@ -3246,7 +3246,7 @@
  
  	pCap->hw_caps |= ATH9K_HW_CAP_ENHANCEDPM;
  
diff --git a/compat/patches/05-usb.patch b/compat/patches/05-usb.patch
index 174f6ee..9d13a13 100644
--- a/compat/patches/05-usb.patch
+++ b/compat/patches/05-usb.patch
@@ -2,7 +2,7 @@ USB opt soft_unbid was added as of 2.6.27.
 
 --- a/drivers/net/wireless/p54/p54usb.c	2009-09-23 10:28:04.963708264 -0700
 +++ b/drivers/net/wireless/p54/p54usb.c	2009-09-23 10:28:05.199734839 -0700
-@@ -1048,7 +1048,9 @@
+@@ -1052,7 +1052,9 @@
  	.resume = p54u_resume,
  	.reset_resume = p54u_resume,
  #endif /* CONFIG_PM */
diff --git a/compat/patches/06-header-changes.patch b/compat/patches/06-header-changes.patch
index 14e544a..44f43cf 100644
--- a/compat/patches/06-header-changes.patch
+++ b/compat/patches/06-header-changes.patch
@@ -39,7 +39,7 @@ cases.
 +#endif
  #include <linux/crc32.h>
  #include <linux/etherdevice.h>
- 
+ #include <linux/vmalloc.h>
 --- a/drivers/net/wireless/wl12xx/wl1251_spi.c	2009-08-07 12:24:58.907526225 -0700
 +++ b/drivers/net/wireless/wl12xx/wl1251_spi.c	2009-08-07 12:24:59.199494403 -0700
 @@ -24,6 +24,9 @@
diff --git a/compat/patches/08-rename-iwl4965-config.patch b/compat/patches/08-rename-iwl4965-config.patch
index 997028a..475c15f 100644
--- a/compat/patches/08-rename-iwl4965-config.patch
+++ b/compat/patches/08-rename-iwl4965-config.patch
@@ -16,7 +16,7 @@ CONFIG_IWL4965 has to be set to y, to build correctly.
  iwlagn-$(CONFIG_IWL5000) += iwl-1000.o
 --- a/drivers/net/wireless/iwlwifi/iwl-agn.c	2009-11-13 11:38:35.000000000 -0800
 +++ b/drivers/net/wireless/iwlwifi/iwl-agn.c	2009-11-13 11:38:36.000000000 -0800
-@@ -3449,10 +3449,10 @@
+@@ -3534,10 +3534,10 @@
  
  /* Hardware specific file defines the PCI IDs table for that hardware module */
  static struct pci_device_id iwl_hw_card_ids[] = {
diff --git a/compat/patches/10-add-wext-handlers-to-netdev.patch b/compat/patches/10-add-wext-handlers-to-netdev.patch
index a85aa82..9159613 100644
--- a/compat/patches/10-add-wext-handlers-to-netdev.patch
+++ b/compat/patches/10-add-wext-handlers-to-netdev.patch
@@ -13,7 +13,7 @@ the struct wiphy wireless handler.
 
 --- a/net/wireless/core.c	2009-11-02 08:08:20.000000000 -0800
 +++ b/net/wireless/core.c	2009-11-02 08:08:21.000000000 -0800
-@@ -671,6 +671,10 @@
+@@ -673,6 +673,10 @@
  		wdev->sme_state = CFG80211_SME_IDLE;
  		mutex_unlock(&rdev->devlist_mtx);
  #ifdef CONFIG_CFG80211_WEXT
diff --git a/compat/patches/13-trace.patch b/compat/patches/13-trace.patch
index 144cae5..d3a3dcd 100644
--- a/compat/patches/13-trace.patch
+++ b/compat/patches/13-trace.patch
@@ -35,7 +35,7 @@ in or compat headers.
  #include <net/mac80211.h>
  #include "ieee80211_i.h"
  
-@@ -669,4 +671,6 @@ TRACE_EVENT(drv_ampdu_action,
+@@ -672,4 +674,6 @@ TRACE_EVENT(drv_ampdu_action,
  #define TRACE_INCLUDE_PATH .
  #undef TRACE_INCLUDE_FILE
  #define TRACE_INCLUDE_FILE driver-trace
diff --git a/compat/patches/14-device-type.patch b/compat/patches/14-device-type.patch
index e1eaf34..e8b97e3 100644
--- a/compat/patches/14-device-type.patch
+++ b/compat/patches/14-device-type.patch
@@ -8,7 +8,7 @@ compile warning.
 
 --- a/net/mac80211/iface.c	2009-11-13 11:40:39.000000000 -0800
 +++ b/net/mac80211/iface.c	2009-11-13 11:40:39.000000000 -0800
-@@ -777,9 +777,11 @@
+@@ -778,9 +778,11 @@
  	return 0;
  }
  
diff --git a/compat/patches/15-symbol-export-conflicts.patch b/compat/patches/15-symbol-export-conflicts.patch
index a7a35d8..2cc25cc 100644
--- a/compat/patches/15-symbol-export-conflicts.patch
+++ b/compat/patches/15-symbol-export-conflicts.patch
@@ -3,7 +3,7 @@ To avoid conflicts with the other export we rename our.
 
 --- a/net/mac80211/rx.c	2009-11-13 11:41:29.000000000 -0800
 +++ b/net/mac80211/rx.c	2009-11-13 11:41:30.000000000 -0800
-@@ -2508,7 +2508,12 @@
+@@ -2516,7 +2516,12 @@
   drop:
  	kfree_skb(skb);
  }
-- 
1.6.3.3

