Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:35029 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753137AbZLZVqJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Dec 2009 16:46:09 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat-wireless: Backport net_device_ops set_mac_address
Date: Sat, 26 Dec 2009 22:46:00 +0100
Message-Id: <1261863960-2789-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1261863960-2789-1-git-send-email-hauke@hauke-m.de>
References: <1261863960-2789-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adds ieee80211_change_mac and eth_mac_addr into the backport code for net_device_ops

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/01-netdev.patch |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/patches/01-netdev.patch b/patches/01-netdev.patch
index 2c0aa06..5f849e0 100644
--- a/patches/01-netdev.patch
+++ b/patches/01-netdev.patch
@@ -110,7 +110,7 @@ without creating a headache on maintenance of the pathes.
  static const struct net_device_ops ieee80211_dataif_ops = {
  	.ndo_open		= ieee80211_open,
  	.ndo_stop		= ieee80211_stop,
-@@ -663,11 +664,22 @@
+@@ -663,11 +664,23 @@
  	.ndo_change_mtu 	= ieee80211_change_mtu,
  	.ndo_set_mac_address 	= eth_mac_addr,
  };
@@ -125,6 +125,7 @@ without creating a headache on maintenance of the pathes.
 +	dev->hard_start_xmit = ieee80211_subif_start_xmit;
 +	dev->set_multicast_list = ieee80211_set_multicast_list;
 +	dev->change_mtu = ieee80211_change_mtu;
++	dev->set_mac_address = ieee80211_change_mac;
 +	dev->open = ieee80211_open;
 +	dev->stop = ieee80211_stop;
 +	/* we will validate the address ourselves in ->open */
@@ -133,7 +134,7 @@ without creating a headache on maintenance of the pathes.
  	dev->destructor = free_netdev;
  }
  
-@@ -682,7 +694,11 @@
+@@ -682,7 +694,12 @@
  
  	/* and set some type-dependent values */
  	sdata->vif.type = type;
@@ -141,6 +142,7 @@ without creating a headache on maintenance of the pathes.
  	sdata->dev->netdev_ops = &ieee80211_dataif_ops;
 +#else
 +	sdata->dev->hard_start_xmit = ieee80211_subif_start_xmit;
++	sdata->dev->set_mac_address = eth_mac_addr;
 +#endif
  	sdata->wdev.iftype = type;
  
-- 
1.6.3.3

