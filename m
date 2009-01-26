Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.vyatta.com ([76.74.103.46]:40934 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558AbZAZSaG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2009 13:30:06 -0500
Date: Tue, 27 Jan 2009 05:29:25 +1100
From: Stephen Hemminger <shemminger@vyatta.com>
To: johannes@sipsolutions.net, flamingice@sourmilk.net
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: convert to net_device_ops
Message-ID: <20090127052926.44d3fd5f@s6510> (sfid-20090126_193011_775193_C4373A95)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Convert to new net_device_ops in 2.6.28 and later.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

--- a/net/mac80211/iface.c	2009-01-17 12:27:00.000000000 +1100
+++ b/net/mac80211/iface.c	2009-01-25 21:03:03.737986092 +1100
@@ -569,18 +569,21 @@ static void ieee80211_set_multicast_list
 	dev_mc_sync(local->mdev, dev);
 }
 
+static const struct net_device_ops ieee80211_netdev_ops = {
+	.ndo_open		= ieee80211_open,
+	.ndo_stop		= ieee80211_stop,
+	.ndo_start_xmit		= ieee80211_subif_start_xmit,
+	.ndo_set_multicast_list = ieee80211_set_multicast_list,
+	.ndo_change_mtu 	= ieee80211_change_mtu,
+	.ndo_set_mac_address 	= eth_mac_addr,
+};
+
 static void ieee80211_if_setup(struct net_device *dev)
 {
 	ether_setup(dev);
-	dev->hard_start_xmit = ieee80211_subif_start_xmit;
+	dev->netdev_ops = &ieee80211_netdev_ops;
 	dev->wireless_handlers = &ieee80211_iw_handler_def;
-	dev->set_multicast_list = ieee80211_set_multicast_list;
-	dev->change_mtu = ieee80211_change_mtu;
-	dev->open = ieee80211_open;
-	dev->stop = ieee80211_stop;
 	dev->destructor = free_netdev;
-	/* we will validate the address ourselves in ->open */
-	dev->validate_addr = NULL;
 }
 /*
  * Called when the netdev is removed or, by the code below, before
