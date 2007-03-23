Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:48993 "EHLO silver.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933277AbXCWUnb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 16:43:31 -0400
From: Jiri Benc <jbenc@suse.cz>
To: "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20070323214400.642621638.midnight@suse.cz>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 5/19] mac80211: Remove tx_timeout callback
Message-Id: <20070323204447.72BF5484B7@silver.suse.cz>
Date: Fri, 23 Mar 2007 21:44:47 +0100 (CET)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

This never worked in the first place and we can't use the network watchdog
anyway since that checks if the queue is stopped, but wireless devices can
have many queues. TX timeouts on virtual interfaces don't really make sense
either since they can't stall.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
Signed-off-by: Jiri Benc <jbenc@suse.cz>

---

 net/mac80211/ieee80211.c |   15 ---------------
 1 files changed, 0 insertions(+), 15 deletions(-)

3dcfdf95493a7317b1373d6212f4e7b3461b465d
diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index f3fc96b..18caa2b 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -2082,19 +2082,6 @@ #endif /* CONFIG_MAC80211_VERBOSE_DEBUG 
 }
 
 
-static void ieee80211_tx_timeout(struct net_device *dev)
-{
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-
-	printk(KERN_WARNING "%s: resetting interface.\n", dev->name);
-
-	if (local->ops->reset(local_to_hw(local)))
-		printk(KERN_ERR "%s: failed to reset interface.\n", dev->name);
-	else
-		netif_wake_queue(dev);
-}
-
-
 static int ieee80211_set_mac_address(struct net_device *dev, void *addr)
 {
 	struct sockaddr *a = addr;
@@ -4429,7 +4416,6 @@ void ieee80211_if_setup(struct net_devic
 	dev->set_mac_address = ieee80211_set_mac_address;
 	dev->set_multicast_list = ieee80211_set_multicast_list;
 	dev->change_mtu = ieee80211_change_mtu;
-	dev->tx_timeout = ieee80211_tx_timeout;
 	dev->get_stats = ieee80211_get_stats;
 	dev->open = ieee80211_open;
 	dev->stop = ieee80211_stop;
@@ -4594,7 +4580,6 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 	sta_info_init(local);
 
 	mdev->hard_start_xmit = ieee80211_master_start_xmit;
-	mdev->tx_timeout = ieee80211_tx_timeout;
 	mdev->get_stats = ieee80211_get_stats;
 	mdev->open = ieee80211_master_open;
 	mdev->stop = ieee80211_master_stop;
-- 
1.3.0

