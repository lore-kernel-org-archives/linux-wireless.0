Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:46693 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753864Ab1KRToS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 14:44:18 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/3] compat-wireless: make patches apply again
Date: Fri, 18 Nov 2011 20:44:04 +0100
Message-Id: <1321645446-22527-1-git-send-email-hauke@hauke-m.de> (sfid-20111118_204421_175406_7253833F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/01-netdev.patch          |   28 ++++++++--------
 patches/29-sdio_no_suspend.patch |   64 +++++++++++++++++++++++++------------
 2 files changed, 57 insertions(+), 35 deletions(-)

diff --git a/patches/01-netdev.patch b/patches/01-netdev.patch
index 2927219..c01024a 100644
--- a/patches/01-netdev.patch
+++ b/patches/01-netdev.patch
@@ -34,18 +34,18 @@ without creating a headache on maintenance of the pathes.
  
 --- a/drivers/net/wireless/ath/ath6kl/main.c
 +++ b/drivers/net/wireless/ath/ath6kl/main.c
-@@ -1465,7 +1465,7 @@ static struct net_device_ops ath6kl_netd
+@@ -1114,7 +1114,7 @@ static struct net_device_ops ath6kl_netd
  
  void init_netdev(struct net_device *dev)
  {
 -	dev->netdev_ops = &ath6kl_netdev_ops;
 +	netdev_attach_ops(dev, &ath6kl_netdev_ops);
+ 	dev->destructor = free_netdev;
  	dev->watchdog_timeo = ATH6KL_TX_TIMEOUT;
  
- 	dev->needed_headroom = ETH_HLEN;
 --- a/drivers/net/wireless/rndis_wlan.c
 +++ b/drivers/net/wireless/rndis_wlan.c
-@@ -3439,7 +3439,7 @@ static int rndis_wlan_bind(struct usbnet
+@@ -3452,7 +3452,7 @@ static int rndis_wlan_bind(struct usbnet
  	 * rndis_host wants to avoid all OID as much as possible
  	 * so do promisc/multicast handling in rndis_wlan.
  	 */
@@ -56,7 +56,7 @@ without creating a headache on maintenance of the pathes.
  	retval = rndis_set_oid(usbdev, OID_GEN_CURRENT_PACKET_FILTER, &tmp,
 --- a/net/mac80211/iface.c
 +++ b/net/mac80211/iface.c
-@@ -697,7 +697,12 @@ static void ieee80211_if_setup(struct ne
+@@ -713,7 +713,12 @@ static void ieee80211_if_setup(struct ne
  {
  	ether_setup(dev);
  	dev->priv_flags &= ~IFF_TX_SKB_SHARING;
@@ -70,7 +70,7 @@ without creating a headache on maintenance of the pathes.
  	dev->destructor = free_netdev;
  }
  
-@@ -844,7 +849,7 @@ static void ieee80211_setup_sdata(struct
+@@ -860,7 +865,7 @@ static void ieee80211_setup_sdata(struct
  	/* and set some type-dependent values */
  	sdata->vif.type = type;
  	sdata->vif.p2p = false;
@@ -79,7 +79,7 @@ without creating a headache on maintenance of the pathes.
  	sdata->wdev.iftype = type;
  
  	sdata->control_port_protocol = cpu_to_be16(ETH_P_PAE);
-@@ -883,7 +888,7 @@ static void ieee80211_setup_sdata(struct
+@@ -899,7 +904,7 @@ static void ieee80211_setup_sdata(struct
  		break;
  	case NL80211_IFTYPE_MONITOR:
  		sdata->dev->type = ARPHRD_IEEE80211_RADIOTAP;
@@ -88,7 +88,7 @@ without creating a headache on maintenance of the pathes.
  		sdata->u.mntr_flags = MONITOR_FLAG_CONTROL |
  				      MONITOR_FLAG_OTHER_BSS;
  		break;
-@@ -1134,6 +1139,8 @@ int ieee80211_if_add(struct ieee80211_lo
+@@ -1150,6 +1155,8 @@ int ieee80211_if_add(struct ieee80211_lo
  		return -ENOMEM;
  	dev_net_set(ndev, wiphy_net(local->hw.wiphy));
  
@@ -97,7 +97,7 @@ without creating a headache on maintenance of the pathes.
  	ndev->needed_headroom = local->tx_headroom +
  				4*6 /* four MAC addresses */
  				+ 2 + 2 + 2 + 2 /* ctl, dur, seq, qos */
-@@ -1142,6 +1149,7 @@ int ieee80211_if_add(struct ieee80211_lo
+@@ -1158,6 +1165,7 @@ int ieee80211_if_add(struct ieee80211_lo
  				- ETH_HLEN /* ethernet hard_header_len */
  				+ IEEE80211_ENCRYPT_HEADROOM;
  	ndev->needed_tailroom = IEEE80211_ENCRYPT_TAILROOM;
@@ -186,7 +186,7 @@ without creating a headache on maintenance of the pathes.
  
 --- a/drivers/net/wireless/ipw2x00/ipw2100.c
 +++ b/drivers/net/wireless/ipw2x00/ipw2100.c
-@@ -6114,7 +6114,7 @@ static struct net_device *ipw2100_alloc_
+@@ -6115,7 +6115,7 @@ static struct net_device *ipw2100_alloc_
  	priv->ieee->perfect_rssi = -20;
  	priv->ieee->worst_rssi = -85;
  
@@ -197,7 +197,7 @@ without creating a headache on maintenance of the pathes.
  	priv->wireless_data.libipw = priv->ieee;
 --- a/drivers/net/wireless/ipw2x00/ipw2200.c
 +++ b/drivers/net/wireless/ipw2x00/ipw2200.c
-@@ -11673,7 +11673,7 @@ static int ipw_prom_alloc(struct ipw_pri
+@@ -11682,7 +11682,7 @@ static int ipw_prom_alloc(struct ipw_pri
  	memcpy(priv->prom_net_dev->dev_addr, priv->mac_addr, ETH_ALEN);
  
  	priv->prom_net_dev->type = ARPHRD_IEEE80211_RADIOTAP;
@@ -206,7 +206,7 @@ without creating a headache on maintenance of the pathes.
  
  	priv->prom_priv->ieee->iw_mode = IW_MODE_MONITOR;
  	SET_NETDEV_DEV(priv->prom_net_dev, &priv->pci_dev->dev);
-@@ -11812,7 +11812,7 @@ static int __devinit ipw_pci_probe(struc
+@@ -11821,7 +11821,7 @@ static int __devinit ipw_pci_probe(struc
  	priv->ieee->perfect_rssi = -20;
  	priv->ieee->worst_rssi = -85;
  
@@ -336,7 +336,7 @@ without creating a headache on maintenance of the pathes.
  }
 --- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
 +++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
-@@ -2231,7 +2231,7 @@ static int atl1e_init_netdev(struct net_
+@@ -2234,7 +2234,7 @@ static int atl1e_init_netdev(struct net_
  	pci_set_drvdata(pdev, netdev);
  
  	netdev->irq  = pdev->irq;
@@ -347,7 +347,7 @@ without creating a headache on maintenance of the pathes.
  	atl1e_set_ethtool_ops(netdev);
 --- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
 +++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
-@@ -2617,7 +2617,7 @@ static int atl1c_init_netdev(struct net_
+@@ -2620,7 +2620,7 @@ static int atl1c_init_netdev(struct net_
  	pci_set_drvdata(pdev, netdev);
  
  	netdev->irq  = pdev->irq;
@@ -369,7 +369,7 @@ without creating a headache on maintenance of the pathes.
  	netdev->ethtool_ops = &atl1_ethtool_ops;
 --- a/drivers/net/ethernet/atheros/atlx/atl2.c
 +++ b/drivers/net/ethernet/atheros/atlx/atl2.c
-@@ -1411,7 +1411,7 @@ static int __devinit atl2_probe(struct p
+@@ -1414,7 +1414,7 @@ static int __devinit atl2_probe(struct p
  
  	atl2_setup_pcicmd(pdev);
  
diff --git a/patches/29-sdio_no_suspend.patch b/patches/29-sdio_no_suspend.patch
index 934eb94..f5b85b7 100644
--- a/patches/29-sdio_no_suspend.patch
+++ b/patches/29-sdio_no_suspend.patch
@@ -5,66 +5,88 @@ suspend and resume that are not backported.
 
 --- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
 +++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
-@@ -1411,7 +1411,7 @@ static int ath6kl_flush_pmksa(struct wip
+@@ -1871,7 +1871,7 @@ int ath6kl_cfg80211_resume(struct ath6kl
  	return 0;
  }
  
 -#ifdef CONFIG_PM
 +#if defined(CONFIG_PM) && (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
- static int ar6k_cfg80211_suspend(struct wiphy *wiphy,
- 				 struct cfg80211_wowlan *wow)
- {
-@@ -1827,7 +1827,7 @@ static struct cfg80211_ops ath6kl_cfg802
+ 
+ /* hif layer decides what suspend mode to use */
+ static int __ath6kl_cfg80211_suspend(struct wiphy *wiphy,
+@@ -2346,7 +2346,7 @@ static struct cfg80211_ops ath6kl_cfg802
  	.del_pmksa = ath6kl_del_pmksa,
  	.flush_pmksa = ath6kl_flush_pmksa,
  	CFG80211_TESTMODE_CMD(ath6kl_tm_cmd)
 -#ifdef CONFIG_PM
 +#if defined(CONFIG_PM) && (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
- 	.suspend = ar6k_cfg80211_suspend,
+ 	.suspend = __ath6kl_cfg80211_suspend,
+ 	.resume = __ath6kl_cfg80211_resume,
  #endif
- 	.set_channel = ath6kl_set_channel,
 --- a/drivers/net/wireless/ath/ath6kl/hif-ops.h
 +++ b/drivers/net/wireless/ath/ath6kl/hif-ops.h
-@@ -69,9 +69,11 @@ static inline void ath6kl_hif_cleanup_sc
+@@ -83,6 +83,7 @@ static inline void ath6kl_hif_cleanup_sc
  	return ar->hif_ops->cleanup_scatter(ar);
  }
  
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
- static inline int ath6kl_hif_suspend(struct ath6kl *ar)
+ static inline int ath6kl_hif_suspend(struct ath6kl *ar,
+ 				     struct cfg80211_wowlan *wow)
  {
- 	return ar->hif_ops->suspend(ar);
+@@ -97,6 +98,7 @@ static inline int ath6kl_hif_resume(stru
+ 
+ 	return ar->hif_ops->resume(ar);
  }
 +#endif
  
- #endif
+ static inline int ath6kl_hif_power_on(struct ath6kl *ar)
+ {
 --- a/drivers/net/wireless/ath/ath6kl/sdio.c
 +++ b/drivers/net/wireless/ath/ath6kl/sdio.c
-@@ -724,6 +724,7 @@ static int ath6kl_sdio_enable_scatter(st
- 	return 0;
+@@ -774,6 +774,7 @@ out:
+ 	return ret;
  }
  
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
- static int ath6kl_sdio_suspend(struct ath6kl *ar)
+ static int ath6kl_sdio_suspend(struct ath6kl *ar, struct cfg80211_wowlan *wow)
  {
  	struct ath6kl_sdio *ar_sdio = ath6kl_sdio_priv(ar);
-@@ -751,6 +752,7 @@ static int ath6kl_sdio_suspend(struct at
+@@ -845,6 +846,7 @@ static int ath6kl_sdio_resume(struct ath
  
  	return 0;
  }
 +#endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34)) */
  
- static const struct ath6kl_hif_ops ath6kl_sdio_ops = {
- 	.read_write_sync = ath6kl_sdio_read_write_sync,
-@@ -762,7 +764,9 @@ static const struct ath6kl_hif_ops ath6k
+ static void ath6kl_sdio_stop(struct ath6kl *ar)
+ {
+@@ -888,14 +890,16 @@ static const struct ath6kl_hif_ops ath6k
  	.enable_scatter = ath6kl_sdio_enable_scatter,
  	.scat_req_rw = ath6kl_sdio_async_rw_scatter,
  	.cleanup_scatter = ath6kl_sdio_cleanup_scatter,
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
  	.suspend = ath6kl_sdio_suspend,
+ 	.resume = ath6kl_sdio_resume,
++#endif
+ 	.power_on = ath6kl_sdio_power_on,
+ 	.power_off = ath6kl_sdio_power_off,
+ 	.stop = ath6kl_sdio_stop,
+ };
+ 
+-#ifdef CONFIG_PM_SLEEP
++#if defined(CONFIG_PM_SLEEP) && (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
+ 
+ /*
+  * Empty handlers so that mmc subsystem doesn't remove us entirely during
+@@ -1037,7 +1041,9 @@ static struct sdio_driver ath6kl_sdio_dr
+ 	.id_table = ath6kl_sdio_devices,
+ 	.probe = ath6kl_sdio_probe,
+ 	.remove = ath6kl_sdio_remove,
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
+ 	.drv.pm = ATH6KL_SDIO_PM_OPS,
 +#endif
  };
  
- static int ath6kl_sdio_probe(struct sdio_func *func,
+ static int __init ath6kl_sdio_init(void)
 --- a/drivers/net/wireless/libertas/if_sdio.c
 +++ b/drivers/net/wireless/libertas/if_sdio.c
 @@ -1306,6 +1306,7 @@ static void if_sdio_remove(struct sdio_f
@@ -123,7 +145,7 @@ suspend and resume that are not backported.
  
  /* Device ID for SD8787 */
  #define SDIO_DEVICE_ID_MARVELL_8787   (0x9119)
-@@ -267,10 +271,12 @@ static const struct sdio_device_id mwifi
+@@ -270,10 +274,12 @@ static const struct sdio_device_id mwifi
  
  MODULE_DEVICE_TABLE(sdio, mwifiex_ids);
  
@@ -136,7 +158,7 @@ suspend and resume that are not backported.
  
  static struct sdio_driver mwifiex_sdio = {
  	.name = "mwifiex_sdio",
-@@ -279,7 +285,9 @@ static struct sdio_driver mwifiex_sdio =
+@@ -282,7 +288,9 @@ static struct sdio_driver mwifiex_sdio =
  	.remove = mwifiex_sdio_remove,
  	.drv = {
  		.owner = THIS_MODULE,
-- 
1.7.4.1

