Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:45053 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135Ab0ALWqh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2010 17:46:37 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] compat-wireless: Backport netdev_ops select_queue
Date: Tue, 12 Jan 2010 23:46:26 +0100
Message-Id: <1263336387-30707-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

eth_mac_addr was added to dataif, but it should be monitor

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/01-netdev.patch |   42 ++++++++++++++++++++++++++++++++----------
 1 files changed, 32 insertions(+), 10 deletions(-)

diff --git a/patches/01-netdev.patch b/patches/01-netdev.patch
index 3ae81e4..0246e3b 100644
--- a/patches/01-netdev.patch
+++ b/patches/01-netdev.patch
@@ -100,9 +100,9 @@ without creating a headache on maintenance of the pathes.
  
  	tmp = RNDIS_PACKET_TYPE_DIRECTED | RNDIS_PACKET_TYPE_BROADCAST;
  	retval = rndis_set_oid(usbdev, OID_GEN_CURRENT_PACKET_FILTER, &tmp,
---- a/net/mac80211/iface.c	2010-01-11 09:20:07.000000000 -0800
-+++ b/net/mac80211/iface.c	2010-01-11 09:20:07.000000000 -0800
-@@ -666,6 +666,7 @@
+--- a/net/mac80211/iface.c
++++ b/net/mac80211/iface.c
+@@ -666,6 +666,7 @@ static u16 ieee80211_netdev_select_queue
  	return ieee80211_select_queue(IEEE80211_DEV_TO_SUB_IF(dev), skb);
  }
  
@@ -110,7 +110,23 @@ without creating a headache on maintenance of the pathes.
  static const struct net_device_ops ieee80211_dataif_ops = {
  	.ndo_open		= ieee80211_open,
  	.ndo_stop		= ieee80211_stop,
-@@ -713,11 +714,23 @@
+@@ -676,6 +677,7 @@ static const struct net_device_ops ieee8
+ 	.ndo_set_mac_address 	= ieee80211_change_mac,
+ 	.ndo_select_queue	= ieee80211_netdev_select_queue,
+ };
++#endif
+ 
+ static u16 ieee80211_monitor_select_queue(struct net_device *dev,
+ 					  struct sk_buff *skb)
+@@ -703,6 +705,7 @@ static u16 ieee80211_monitor_select_queu
+ 	return ieee80211_downgrade_queue(local, skb);
+ }
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+ static const struct net_device_ops ieee80211_monitorif_ops = {
+ 	.ndo_open		= ieee80211_open,
+ 	.ndo_stop		= ieee80211_stop,
+@@ -713,14 +716,28 @@ static const struct net_device_ops ieee8
  	.ndo_set_mac_address 	= eth_mac_addr,
  	.ndo_select_queue	= ieee80211_monitor_select_queue,
  };
@@ -126,6 +142,7 @@ without creating a headache on maintenance of the pathes.
 +	dev->set_multicast_list = ieee80211_set_multicast_list;
 +	dev->change_mtu = ieee80211_change_mtu;
 +	dev->set_mac_address = ieee80211_change_mac;
++	dev->select_queue = ieee80211_netdev_select_queue;
 +	dev->open = ieee80211_open;
 +	dev->stop = ieee80211_stop;
 +	/* we will validate the address ourselves in ->open */
@@ -134,7 +151,11 @@ without creating a headache on maintenance of the pathes.
  	dev->destructor = free_netdev;
  }
  
-@@ -732,7 +745,12 @@
++
+ /*
+  * Helper function to initialise an interface to a specific type.
+  */
+@@ -732,7 +749,11 @@ static void ieee80211_setup_sdata(struct
  
  	/* and set some type-dependent values */
  	sdata->vif.type = type;
@@ -142,12 +163,11 @@ without creating a headache on maintenance of the pathes.
  	sdata->dev->netdev_ops = &ieee80211_dataif_ops;
 +#else
 +	sdata->dev->hard_start_xmit = ieee80211_subif_start_xmit;
-+	sdata->dev->set_mac_address = eth_mac_addr;
 +#endif
  	sdata->wdev.iftype = type;
  
  	/* only monitor differs */
-@@ -755,7 +773,11 @@
+@@ -755,7 +776,13 @@ static void ieee80211_setup_sdata(struct
  		break;
  	case NL80211_IFTYPE_MONITOR:
  		sdata->dev->type = ARPHRD_IEEE80211_RADIOTAP;
@@ -155,11 +175,13 @@ without creating a headache on maintenance of the pathes.
  		sdata->dev->netdev_ops = &ieee80211_monitorif_ops;
 +#else
 +		sdata->dev->hard_start_xmit = ieee80211_monitor_start_xmit;
++		sdata->dev->select_queue = ieee80211_monitor_select_queue;
++		sdata->dev->set_mac_address = eth_mac_addr;
 +#endif
  		sdata->u.mntr_flags = MONITOR_FLAG_CONTROL |
  				      MONITOR_FLAG_OTHER_BSS;
  		break;
-@@ -824,6 +846,8 @@
+@@ -824,6 +851,8 @@ int ieee80211_if_add(struct ieee80211_lo
  		return -ENOMEM;
  	dev_net_set(ndev, wiphy_net(local->hw.wiphy));
  
@@ -168,7 +190,7 @@ without creating a headache on maintenance of the pathes.
  	ndev->needed_headroom = local->tx_headroom +
  				4*6 /* four MAC addresses */
  				+ 2 + 2 + 2 + 2 /* ctl, dur, seq, qos */
-@@ -832,6 +856,7 @@
+@@ -832,6 +861,7 @@ int ieee80211_if_add(struct ieee80211_lo
  				- ETH_HLEN /* ethernet hard_header_len */
  				+ IEEE80211_ENCRYPT_HEADROOM;
  	ndev->needed_tailroom = IEEE80211_ENCRYPT_TAILROOM;
@@ -176,7 +198,7 @@ without creating a headache on maintenance of the pathes.
  
  	ret = dev_alloc_name(ndev, ndev->name);
  	if (ret < 0)
-@@ -873,6 +898,10 @@
+@@ -873,6 +903,10 @@ int ieee80211_if_add(struct ieee80211_lo
  	if (ret)
  		goto fail;
  
-- 
1.6.3.3

