Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:36617 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754103Ab0FOU47 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jun 2010 16:56:59 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat-wireless: refresh patches:
Date: Tue, 15 Jun 2010 22:56:35 +0200
Message-Id: <1276635395-27923-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

make the patches apply against recent linux-next.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---

Luis please remove all patches from linux-next-pending, because they are in
linux-next now.

 patches/01-netdev.patch                  |   16 +++++---------
 patches/03-rfkill.patch                  |    2 +-
 patches/04-netns.patch                   |    2 +-
 patches/08-rename-iwl4965-config.patch   |    2 +-
 patches/15-symbol-export-conflicts.patch |    2 +-
 patches/17-netdev-queue.patch            |    4 +-
 patches/20-pcidev.patch                  |    2 +-
 patches/22-multiqueue.patch              |    4 +-
 patches/25-multicast-list_head.patch     |   32 +++++++++++++++---------------
 9 files changed, 31 insertions(+), 35 deletions(-)

diff --git a/patches/01-netdev.patch b/patches/01-netdev.patch
index daa75b7..98cb477 100644
--- a/patches/01-netdev.patch
+++ b/patches/01-netdev.patch
@@ -45,7 +45,7 @@ without creating a headache on maintenance of the pathes.
  	retval = rndis_set_oid(usbdev, OID_GEN_CURRENT_PACKET_FILTER, &tmp,
 --- a/net/mac80211/iface.c
 +++ b/net/mac80211/iface.c
-@@ -713,10 +713,16 @@ static const struct net_device_ops ieee8
+@@ -697,7 +697,12 @@ static const struct net_device_ops ieee8
  static void ieee80211_if_setup(struct net_device *dev)
  {
  	ether_setup(dev);
@@ -59,11 +59,7 @@ without creating a headache on maintenance of the pathes.
  	dev->destructor = free_netdev;
  }
  
-+
- /*
-  * Helper function to initialise an interface to a specific type.
-  */
-@@ -728,7 +734,7 @@ static void ieee80211_setup_sdata(struct
+@@ -842,7 +847,7 @@ static void ieee80211_setup_sdata(struct
  
  	/* and set some type-dependent values */
  	sdata->vif.type = type;
@@ -72,7 +68,7 @@ without creating a headache on maintenance of the pathes.
  	sdata->wdev.iftype = type;
  
  	/* only monitor differs */
-@@ -751,7 +757,7 @@ static void ieee80211_setup_sdata(struct
+@@ -868,7 +873,7 @@ static void ieee80211_setup_sdata(struct
  		break;
  	case NL80211_IFTYPE_MONITOR:
  		sdata->dev->type = ARPHRD_IEEE80211_RADIOTAP;
@@ -81,7 +77,7 @@ without creating a headache on maintenance of the pathes.
  		sdata->u.mntr_flags = MONITOR_FLAG_CONTROL |
  				      MONITOR_FLAG_OTHER_BSS;
  		break;
-@@ -932,6 +938,8 @@ int ieee80211_if_add(struct ieee80211_lo
+@@ -1049,6 +1054,8 @@ int ieee80211_if_add(struct ieee80211_lo
  		return -ENOMEM;
  	dev_net_set(ndev, wiphy_net(local->hw.wiphy));
  
@@ -90,7 +86,7 @@ without creating a headache on maintenance of the pathes.
  	ndev->needed_headroom = local->tx_headroom +
  				4*6 /* four MAC addresses */
  				+ 2 + 2 + 2 + 2 /* ctl, dur, seq, qos */
-@@ -940,6 +948,7 @@ int ieee80211_if_add(struct ieee80211_lo
+@@ -1057,6 +1064,7 @@ int ieee80211_if_add(struct ieee80211_lo
  				- ETH_HLEN /* ethernet hard_header_len */
  				+ IEEE80211_ENCRYPT_HEADROOM;
  	ndev->needed_tailroom = IEEE80211_ENCRYPT_TAILROOM;
@@ -98,7 +94,7 @@ without creating a headache on maintenance of the pathes.
  
  	ret = dev_alloc_name(ndev, ndev->name);
  	if (ret < 0)
-@@ -985,6 +994,10 @@ int ieee80211_if_add(struct ieee80211_lo
+@@ -1105,6 +1113,10 @@ int ieee80211_if_add(struct ieee80211_lo
  	if (ret)
  		goto fail;
  
diff --git a/patches/03-rfkill.patch b/patches/03-rfkill.patch
index fed0382..c7c242b 100644
--- a/patches/03-rfkill.patch
+++ b/patches/03-rfkill.patch
@@ -208,7 +208,7 @@ This would do the policing from within mac80211.
  #include <net/cfg80211.h>
 --- a/drivers/net/wireless/ath/ath9k/hw.c
 +++ b/drivers/net/wireless/ath/ath9k/hw.c
-@@ -2168,7 +2168,7 @@ int ath9k_hw_fill_cap_info(struct ath_hw
+@@ -2171,7 +2171,7 @@ int ath9k_hw_fill_cap_info(struct ath_hw
  
  	pCap->hw_caps |= ATH9K_HW_CAP_ENHANCEDPM;
  
diff --git a/patches/04-netns.patch b/patches/04-netns.patch
index 84deeab..d685f18 100644
--- a/patches/04-netns.patch
+++ b/patches/04-netns.patch
@@ -16,7 +16,7 @@ files...
  };
  
  /* internal helper: get rdev and dev */
-@@ -4294,7 +4296,9 @@ static int nl80211_wiphy_netns(struct sk
+@@ -4343,7 +4345,9 @@ static int nl80211_wiphy_netns(struct sk
  
  	err = cfg80211_switch_netns(rdev, net);
   out_put_net:
diff --git a/patches/08-rename-iwl4965-config.patch b/patches/08-rename-iwl4965-config.patch
index 969227b..1329994 100644
--- a/patches/08-rename-iwl4965-config.patch
+++ b/patches/08-rename-iwl4965-config.patch
@@ -16,7 +16,7 @@ CONFIG_IWL4965 has to be set to y, to build correctly.
  iwlagn-$(CONFIG_IWL5000) += iwl-1000.o
 --- a/drivers/net/wireless/iwlwifi/iwl-agn.c
 +++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
-@@ -4072,10 +4072,10 @@ static void __devexit iwl_pci_remove(str
+@@ -4080,10 +4080,10 @@ static void __devexit iwl_pci_remove(str
  
  /* Hardware specific file defines the PCI IDs table for that hardware module */
  static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
diff --git a/patches/15-symbol-export-conflicts.patch b/patches/15-symbol-export-conflicts.patch
index 10eb4f0..49d9b18 100644
--- a/patches/15-symbol-export-conflicts.patch
+++ b/patches/15-symbol-export-conflicts.patch
@@ -3,7 +3,7 @@ To avoid conflicts with the other export we rename our.
 
 --- a/net/mac80211/rx.c
 +++ b/net/mac80211/rx.c
-@@ -2629,7 +2629,12 @@ void ieee80211_rx(struct ieee80211_hw *h
+@@ -2661,7 +2661,12 @@ void ieee80211_rx(struct ieee80211_hw *h
   drop:
  	kfree_skb(skb);
  }
diff --git a/patches/17-netdev-queue.patch b/patches/17-netdev-queue.patch
index 2389f22..1bbd079 100644
--- a/patches/17-netdev-queue.patch
+++ b/patches/17-netdev-queue.patch
@@ -14,7 +14,7 @@ The patch that introduced this on mac80211 was:
 
 --- a/net/mac80211/iface.c
 +++ b/net/mac80211/iface.c
-@@ -1034,6 +1034,7 @@ void ieee80211_if_remove(struct ieee8021
+@@ -1153,6 +1153,7 @@ void ieee80211_if_remove(struct ieee8021
   * Remove all interfaces, may only be called at hardware unregistration
   * time because it doesn't do RCU-safe list removals.
   */
@@ -22,7 +22,7 @@ The patch that introduced this on mac80211 was:
  void ieee80211_remove_interfaces(struct ieee80211_local *local)
  {
  	struct ieee80211_sub_if_data *sdata, *tmp;
-@@ -1050,6 +1051,22 @@ void ieee80211_remove_interfaces(struct 
+@@ -1169,6 +1170,22 @@ void ieee80211_remove_interfaces(struct 
  	mutex_unlock(&local->iflist_mtx);
  	unregister_netdevice_many(&unreg_list);
  }
diff --git a/patches/20-pcidev.patch b/patches/20-pcidev.patch
index cb7f1ca..e892dcc 100644
--- a/patches/20-pcidev.patch
+++ b/patches/20-pcidev.patch
@@ -4,7 +4,7 @@ compat_is_pcie() when needed.
 
 --- a/drivers/net/wireless/ath/ath9k/pci.c
 +++ b/drivers/net/wireless/ath/ath9k/pci.c
-@@ -79,7 +79,11 @@ static void ath_pci_bt_coex_prep(struct 
+@@ -80,7 +80,11 @@ static void ath_pci_bt_coex_prep(struct 
  	struct pci_dev *pdev = to_pci_dev(sc->dev);
  	u8 aspm;
  
diff --git a/patches/22-multiqueue.patch b/patches/22-multiqueue.patch
index c377355..24ac885 100644
--- a/patches/22-multiqueue.patch
+++ b/patches/22-multiqueue.patch
@@ -96,7 +96,7 @@ queue by using skb_set_queue_mapping(skb, 0) through ieee80211_tx_skb()
  
 --- a/net/mac80211/tx.c
 +++ b/net/mac80211/tx.c
-@@ -1571,6 +1571,10 @@ static void ieee80211_xmit(struct ieee80
+@@ -1604,6 +1604,10 @@ static void ieee80211_xmit(struct ieee80
  				return;
  			}
  
@@ -107,7 +107,7 @@ queue by using skb_set_queue_mapping(skb, 0) through ieee80211_tx_skb()
  	ieee80211_set_qos_hdr(local, skb);
  	ieee80211_tx(sdata, skb, false);
  	rcu_read_unlock();
-@@ -2040,8 +2044,15 @@ void ieee80211_tx_pending(unsigned long 
+@@ -2073,8 +2077,15 @@ void ieee80211_tx_pending(unsigned long 
  
  		if (skb_queue_empty(&local->pending[i]))
  			list_for_each_entry_rcu(sdata, &local->interfaces, list)
diff --git a/patches/25-multicast-list_head.patch b/patches/25-multicast-list_head.patch
index 5fbc1eb..aed1ccb 100644
--- a/patches/25-multicast-list_head.patch
+++ b/patches/25-multicast-list_head.patch
@@ -576,9 +576,9 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  	return hash.low | ((u64)hash.high << 32);
 --- a/include/net/mac80211.h
 +++ b/include/net/mac80211.h
-@@ -1682,7 +1682,11 @@ struct ieee80211_ops {
- 				    struct ieee80211_vif *vif,
- 				    struct in_ifaddr *ifa_list);
+@@ -1689,7 +1689,11 @@ struct ieee80211_ops {
+ 				 struct ieee80211_bss_conf *info,
+ 				 u32 changed);
  	u64 (*prepare_multicast)(struct ieee80211_hw *hw,
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
  				 struct netdev_hw_addr_list *mc_list);
@@ -606,7 +606,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  	}
 --- a/net/mac80211/driver-ops.h
 +++ b/net/mac80211/driver-ops.h
-@@ -101,14 +101,28 @@ static inline int drv_configure_arp_filt
+@@ -90,14 +90,28 @@ static inline void drv_bss_info_changed(
  }
  
  static inline u64 drv_prepare_multicast(struct ieee80211_local *local,
@@ -619,6 +619,12 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  {
  	u64 ret = 0;
  
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
+ 	trace_drv_prepare_multicast(local, mc_list->count);
++#else
++	trace_drv_prepare_multicast(local, mc_count);
++#endif
+ 
  	if (local->ops->prepare_multicast)
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
  		ret = local->ops->prepare_multicast(&local->hw, mc_list);
@@ -627,17 +633,11 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
 +						    mc_list);
 +#endif
  
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
- 	trace_drv_prepare_multicast(local, mc_list->count, ret);
-+#else
-+	trace_drv_prepare_multicast(local, mc_count, ret);
-+#endif
+ 	trace_drv_return_u64(local, ret);
  
- 	return ret;
- }
 --- a/net/mac80211/ieee80211_i.h
 +++ b/net/mac80211/ieee80211_i.h
-@@ -665,7 +665,12 @@ struct ieee80211_local {
+@@ -668,7 +668,12 @@ struct ieee80211_local {
  	struct work_struct recalc_smps;
  
  	/* aggregated multicast list */
@@ -652,7 +652,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  
 --- a/net/mac80211/iface.c
 +++ b/net/mac80211/iface.c
-@@ -403,7 +403,12 @@ static int ieee80211_stop(struct net_dev
+@@ -390,7 +390,12 @@ static int ieee80211_stop(struct net_dev
  
  	netif_addr_lock_bh(dev);
  	spin_lock_bh(&local->filter_lock);
@@ -665,7 +665,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  	spin_unlock_bh(&local->filter_lock);
  	netif_addr_unlock_bh(dev);
  
-@@ -586,7 +591,12 @@ static void ieee80211_set_multicast_list
+@@ -570,7 +575,12 @@ static void ieee80211_set_multicast_list
  		sdata->flags ^= IEEE80211_SDATA_PROMISC;
  	}
  	spin_lock_bh(&local->filter_lock);
@@ -680,7 +680,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  }
 --- a/net/mac80211/main.c
 +++ b/net/mac80211/main.c
-@@ -71,7 +71,11 @@ void ieee80211_configure_filter(struct i
+@@ -72,7 +72,11 @@ void ieee80211_configure_filter(struct i
  	spin_lock_bh(&local->filter_lock);
  	changed_flags = local->filter_flags ^ new_flags;
  
@@ -692,7 +692,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  	spin_unlock_bh(&local->filter_lock);
  
  	/* be a bit nasty */
-@@ -447,9 +451,11 @@ struct ieee80211_hw *ieee80211_alloc_hw(
+@@ -448,9 +452,11 @@ struct ieee80211_hw *ieee80211_alloc_hw(
  	local->uapsd_max_sp_len = IEEE80211_DEFAULT_MAX_SP_LEN;
  
  	INIT_LIST_HEAD(&local->interfaces);
-- 
1.7.0.4

