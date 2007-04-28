Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:52982 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965965AbXD1QmI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Apr 2007 12:42:08 -0400
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 2/7] mac80211: kill ieee80211_set_mac_address
Date: Sat, 28 Apr 2007 12:36:01 -0400
To: Jiri Benc <jbenc@suse.cz>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Message-Id: <20070428163601.27203.42856.stgit@magic.sourmilk.net>
In-Reply-To: <20070428163601.27203.32016.stgit@magic.sourmilk.net>
References: <20070428163601.27203.32016.stgit@magic.sourmilk.net>
Content-Type: text/plain;
  charset=utf-8;
  format=fixed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

ieee80211_set_mac_address does exactly the same thing that eth_mac_addr
does. This patch removes it.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 net/mac80211/ieee80211.c |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 851400a..4d7c035 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -2147,17 +2147,6 @@ static int ieee80211_change_mtu_apdev(struct net_device *dev, int new_mtu)
 }
 
 
-static int ieee80211_set_mac_address(struct net_device *dev, void *addr)
-{
-	struct sockaddr *a = addr;
-
-	if (netif_running(dev))
-		return -EBUSY;
-
-	memcpy(dev->dev_addr, a->sa_data, ETH_ALEN);
-	return 0;
-}
-
 static void ieee80211_set_multicast_list(struct net_device *dev)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
@@ -4555,7 +4544,6 @@ void ieee80211_if_setup(struct net_device *dev)
 	dev->hard_start_xmit = ieee80211_subif_start_xmit;
 	dev->wireless_handlers = &ieee80211_iw_handler_def;
 	dev->do_ioctl = ieee80211_ioctl;
-	dev->set_mac_address = ieee80211_set_mac_address;
 	dev->set_multicast_list = ieee80211_set_multicast_list;
 	dev->change_mtu = ieee80211_change_mtu;
 	dev->get_stats = ieee80211_get_stats;

