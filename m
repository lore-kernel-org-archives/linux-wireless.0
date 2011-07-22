Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:60011 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752952Ab1GVQu0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 12:50:26 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/5] compat-wireless: make patches apply again
Date: Fri, 22 Jul 2011 18:50:11 +0200
Message-Id: <1311353415-30952-1-git-send-email-hauke@hauke-m.de> (sfid-20110722_185029_784567_4C512C9D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/01-netdev.patch              |   12 ++++++------
 patches/25-multicast-list_head.patch |   28 ++++++++++++----------------
 2 files changed, 18 insertions(+), 22 deletions(-)

diff --git a/patches/01-netdev.patch b/patches/01-netdev.patch
index 61c8be5..9fcf6f5 100644
--- a/patches/01-netdev.patch
+++ b/patches/01-netdev.patch
@@ -228,15 +228,15 @@ without creating a headache on maintenance of the pathes.
  	dev->flags |= IFF_BROADCAST | IFF_MULTICAST;
 --- a/drivers/net/wireless/libertas/mesh.c
 +++ b/drivers/net/wireless/libertas/mesh.c
-@@ -388,7 +388,7 @@ int lbs_add_mesh(struct lbs_private *pri
- 	mesh_dev->ml_priv = priv;
+@@ -1040,7 +1040,7 @@ static int lbs_add_mesh(struct lbs_priva
  	priv->mesh_dev = mesh_dev;
+ 	priv->mesh_channel = 1;
  
 -	mesh_dev->netdev_ops = &mesh_netdev_ops;
 +	netdev_attach_ops(mesh_dev, &mesh_netdev_ops);
+ 	mesh_dev->wireless_handlers = &mesh_iw_handler_def;
  	mesh_dev->ethtool_ops = &lbs_ethtool_ops;
  	memcpy(mesh_dev->dev_addr, priv->dev->dev_addr, ETH_ALEN);
- 
 --- a/drivers/net/wireless/libertas/defs.h
 +++ b/drivers/net/wireless/libertas/defs.h
 @@ -16,6 +16,14 @@
@@ -325,7 +325,7 @@ without creating a headache on maintenance of the pathes.
  }
 --- a/drivers/net/atl1e/atl1e_main.c
 +++ b/drivers/net/atl1e/atl1e_main.c
-@@ -2211,7 +2211,7 @@ static int atl1e_init_netdev(struct net_
+@@ -2232,7 +2232,7 @@ static int atl1e_init_netdev(struct net_
  	pci_set_drvdata(pdev, netdev);
  
  	netdev->irq  = pdev->irq;
@@ -336,7 +336,7 @@ without creating a headache on maintenance of the pathes.
  	atl1e_set_ethtool_ops(netdev);
 --- a/drivers/net/atl1c/atl1c_main.c
 +++ b/drivers/net/atl1c/atl1c_main.c
-@@ -2600,7 +2600,7 @@ static int atl1c_init_netdev(struct net_
+@@ -2618,7 +2618,7 @@ static int atl1c_init_netdev(struct net_
  	pci_set_drvdata(pdev, netdev);
  
  	netdev->irq  = pdev->irq;
@@ -358,7 +358,7 @@ without creating a headache on maintenance of the pathes.
  	netdev->ethtool_ops = &atl1_ethtool_ops;
 --- a/drivers/net/atlx/atl2.c
 +++ b/drivers/net/atlx/atl2.c
-@@ -1393,7 +1393,7 @@ static int __devinit atl2_probe(struct p
+@@ -1411,7 +1411,7 @@ static int __devinit atl2_probe(struct p
  
  	atl2_setup_pcicmd(pdev);
  
diff --git a/patches/25-multicast-list_head.patch b/patches/25-multicast-list_head.patch
index 43069c8..9e683ea 100644
--- a/patches/25-multicast-list_head.patch
+++ b/patches/25-multicast-list_head.patch
@@ -124,7 +124,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  	return mc_filter[0] | ((u64)(mc_filter[1]) << 32);
 --- a/drivers/net/wireless/ath/ath5k/mac80211-ops.c
 +++ b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
-@@ -329,20 +329,42 @@ ath5k_bss_info_changed(struct ieee80211_
+@@ -313,20 +313,42 @@ ath5k_bss_info_changed(struct ieee80211_
  
  static u64
  ath5k_prepare_multicast(struct ieee80211_hw *hw,
@@ -167,7 +167,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  		pos ^= (val >> 18) ^ (val >> 12) ^ (val >> 6) ^ val;
  		pos &= 0x3f;
  		mfilt[pos / 32] |= (1 << (pos % 32));
-@@ -351,6 +373,9 @@ ath5k_prepare_multicast(struct ieee80211
+@@ -335,6 +357,9 @@ ath5k_prepare_multicast(struct ieee80211
  		* need to inform below not to reset the mcast */
  		/* ath5k_hw_set_mcast_filterindex(ah,
  		 *      ha->addr[5]); */
@@ -307,18 +307,14 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  }
 --- a/drivers/net/wireless/mwifiex/debugfs.c
 +++ b/drivers/net/wireless/mwifiex/debugfs.c
-@@ -235,9 +235,15 @@ mwifiex_info_read(struct file *file, cha
+@@ -228,7 +228,11 @@ mwifiex_info_read(struct file *file, cha
+ 
  		netdev_for_each_mc_addr(ha, netdev)
- 			p += sprintf(p, "multicast_address[%d]="
- 				     "\"%02x:%02x:%02x:%02x:%02x:%02x\"\n", i++,
+ 			p += sprintf(p, "multicast_address[%d]=\"%pM\"\n",
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
- 				     ha->addr[0], ha->addr[1],
- 				     ha->addr[2], ha->addr[3],
- 				     ha->addr[4], ha->addr[5]);
+ 					i++, ha->addr);
 +#else
-+				     ha->dmi_addr[0], ha->dmi_addr[1],
-+				     ha->dmi_addr[2], ha->dmi_addr[3],
-+				     ha->dmi_addr[4], ha->dmi_addr[5]);
++					i++, ha->dmi_addr);
 +#endif
  	}
  
@@ -655,9 +651,9 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  	}
 --- a/include/net/mac80211.h
 +++ b/include/net/mac80211.h
-@@ -1902,7 +1902,11 @@ struct ieee80211_ops {
- 				 struct ieee80211_bss_conf *info,
- 				 u32 changed);
+@@ -1944,7 +1944,11 @@ struct ieee80211_ops {
+ 			       enum ieee80211_tx_sync_type type);
+ 
  	u64 (*prepare_multicast)(struct ieee80211_hw *hw,
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
  				 struct netdev_hw_addr_list *mc_list);
@@ -685,7 +681,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  		}
 --- a/net/mac80211/driver-ops.h
 +++ b/net/mac80211/driver-ops.h
-@@ -131,14 +131,28 @@ static inline void drv_bss_info_changed(
+@@ -162,14 +162,28 @@ static inline void drv_finish_tx_sync(st
  }
  
  static inline u64 drv_prepare_multicast(struct ieee80211_local *local,
@@ -716,7 +712,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  
 --- a/net/mac80211/ieee80211_i.h
 +++ b/net/mac80211/ieee80211_i.h
-@@ -769,7 +769,12 @@ struct ieee80211_local {
+@@ -772,7 +772,12 @@ struct ieee80211_local {
  	struct work_struct recalc_smps;
  
  	/* aggregated multicast list */
-- 
1.7.4.1

