Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:51870 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161498AbXDWS6S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2007 14:58:18 -0400
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 04/13] mac80211: disable tasklets on close
Date: Mon, 23 Apr 2007 14:48:13 -0400
To: Jiri Benc <jbenc@suse.cz>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Message-Id: <20070423184813.7029.71821.stgit@magic.sourmilk.net>
In-Reply-To: <20070423184811.7029.24949.stgit@magic.sourmilk.net>
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net>
Content-Type: text/plain;
  charset=utf-8;
  format=fixed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

This prevents all tasklets from running when the device is down.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 net/mac80211/ieee80211.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index bc89ac9..7743ca0 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -2276,7 +2276,6 @@ static int ieee80211_master_open(struct net_device *dev)
 	list_for_each_entry(sdata, &local->sub_if_list, list) {
 		if (sdata->dev != dev && netif_running(sdata->dev)) {
 			res = 0;
-			tasklet_enable(&local->tx_pending_tasklet);
 			break;
 		}
 	}
@@ -2289,7 +2288,6 @@ static int ieee80211_master_stop(struct net_device *dev)
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sub_if_data *sdata;
 
-	tasklet_disable(&local->tx_pending_tasklet);
 	read_lock(&local->sub_if_lock);
 	list_for_each_entry(sdata, &local->sub_if_list, list) {
 		if (sdata->dev != dev && netif_running(sdata->dev)) {
@@ -2401,6 +2399,8 @@ static int ieee80211_open(struct net_device *dev)
 
 	if (local->open_count == 0) {
 		res = 0;
+		tasklet_enable(&local->tx_pending_tasklet);
+		tasklet_enable(&local->tasklet);
 		if (local->ops->open)
 			res = local->ops->open(local_to_hw(local));
 		if (res == 0) {
@@ -2475,6 +2475,8 @@ static int ieee80211_stop(struct net_device *dev)
 			dev_close(local->apdev);
 		if (local->ops->stop)
 			local->ops->stop(local_to_hw(local));
+		tasklet_disable(&local->tx_pending_tasklet);
+		tasklet_disable(&local->tasklet);
 	}
 	if (local->ops->remove_interface) {
 		struct ieee80211_if_init_conf conf;
@@ -4713,6 +4715,8 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	tasklet_init(&local->tasklet,
 		     ieee80211_tasklet_handler,
 		     (unsigned long) local);
+	tasklet_disable(&local->tasklet);
+
 	skb_queue_head_init(&local->skb_queue);
 	skb_queue_head_init(&local->skb_queue_unreliable);
 

