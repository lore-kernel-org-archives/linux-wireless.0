Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57879 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118AbZA3Mf2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2009 07:35:28 -0500
Subject: [PATCH] mac80211: convert to net_device_ops
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Stephen Hemminger <shemminger@vyatta.com>
Content-Type: text/plain
Date: Fri, 30 Jan 2009 13:35:22 +0100
Message-Id: <1233318922.4201.1.camel@johannes.local> (sfid-20090130_133548_601377_8E915BE4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Convert to new net_device_ops in 2.6.28 and later.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Fixed version of the original patch.

 net/mac80211/iface.c |   47 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 17 deletions(-)

--- wireless-testing.orig/net/mac80211/iface.c	2009-01-30 13:10:16.000000000 +0100
+++ wireless-testing/net/mac80211/iface.c	2009-01-30 13:10:18.000000000 +0100
@@ -591,19 +591,6 @@ static void ieee80211_set_multicast_list
 	dev_mc_sync(local->mdev, dev);
 }
 
-static void ieee80211_if_setup(struct net_device *dev)
-{
-	ether_setup(dev);
-	dev->hard_start_xmit = ieee80211_subif_start_xmit;
-	dev->wireless_handlers = &ieee80211_iw_handler_def;
-	dev->set_multicast_list = ieee80211_set_multicast_list;
-	dev->change_mtu = ieee80211_change_mtu;
-	dev->open = ieee80211_open;
-	dev->stop = ieee80211_stop;
-	dev->destructor = free_netdev;
-	/* we will validate the address ourselves in ->open */
-	dev->validate_addr = NULL;
-}
 /*
  * Called when the netdev is removed or, by the code below, before
  * the interface type changes.
@@ -671,6 +658,34 @@ static void ieee80211_teardown_sdata(str
 	WARN_ON(flushed);
 }
 
+static const struct net_device_ops ieee80211_dataif_ops = {
+	.ndo_open		= ieee80211_open,
+	.ndo_stop		= ieee80211_stop,
+	.ndo_uninit		= ieee80211_teardown_sdata,
+	.ndo_start_xmit		= ieee80211_subif_start_xmit,
+	.ndo_set_multicast_list = ieee80211_set_multicast_list,
+	.ndo_change_mtu 	= ieee80211_change_mtu,
+	.ndo_set_mac_address 	= eth_mac_addr,
+};
+
+static const struct net_device_ops ieee80211_monitorif_ops = {
+	.ndo_open		= ieee80211_open,
+	.ndo_stop		= ieee80211_stop,
+	.ndo_uninit		= ieee80211_teardown_sdata,
+	.ndo_start_xmit		= ieee80211_monitor_start_xmit,
+	.ndo_set_multicast_list = ieee80211_set_multicast_list,
+	.ndo_change_mtu 	= ieee80211_change_mtu,
+	.ndo_set_mac_address 	= eth_mac_addr,
+};
+
+static void ieee80211_if_setup(struct net_device *dev)
+{
+	ether_setup(dev);
+	dev->netdev_ops = &ieee80211_dataif_ops;
+	dev->wireless_handlers = &ieee80211_iw_handler_def;
+	dev->destructor = free_netdev;
+}
+
 /*
  * Helper function to initialise an interface to a specific type.
  */
@@ -682,7 +697,7 @@ static void ieee80211_setup_sdata(struct
 
 	/* and set some type-dependent values */
 	sdata->vif.type = type;
-	sdata->dev->hard_start_xmit = ieee80211_subif_start_xmit;
+	sdata->dev->netdev_ops = &ieee80211_dataif_ops;
 	sdata->wdev.iftype = type;
 
 	/* only monitor differs */
@@ -703,7 +718,7 @@ static void ieee80211_setup_sdata(struct
 		break;
 	case NL80211_IFTYPE_MONITOR:
 		sdata->dev->type = ARPHRD_IEEE80211_RADIOTAP;
-		sdata->dev->hard_start_xmit = ieee80211_monitor_start_xmit;
+		sdata->dev->netdev_ops = &ieee80211_monitorif_ops;
 		sdata->u.mntr_flags = MONITOR_FLAG_CONTROL |
 				      MONITOR_FLAG_OTHER_BSS;
 		break;
@@ -809,8 +824,6 @@ int ieee80211_if_add(struct ieee80211_lo
 	if (ret)
 		goto fail;
 
-	ndev->uninit = ieee80211_teardown_sdata;
-
 	if (ieee80211_vif_is_mesh(&sdata->vif) &&
 	    params && params->mesh_id_len)
 		ieee80211_sdata_set_mesh_id(sdata,


