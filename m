Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42351 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbZKPWUm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2009 17:20:42 -0500
Subject: [PATCH] mac80211: remove dev_hold/put calls
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Nov 2009 23:20:41 +0100
Message-ID: <1258410041.1375.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If we move the rcu sections a little, there's
no need to touch the device refcount.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/tx.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

--- wireless-testing.orig/net/mac80211/tx.c	2009-11-16 23:11:54.000000000 +0100
+++ wireless-testing/net/mac80211/tx.c	2009-11-16 23:12:02.000000000 +0100
@@ -1431,8 +1431,6 @@ static void ieee80211_xmit(struct ieee80
 	int headroom;
 	bool may_encrypt;
 
-	dev_hold(sdata->dev);
-
 	if (need_dynamic_ps(local)) {
 		if (local->hw.conf.flags & IEEE80211_CONF_PS) {
 			ieee80211_stop_queues_by_reason(&local->hw,
@@ -1447,6 +1445,8 @@ static void ieee80211_xmit(struct ieee80
 
 	info->flags |= IEEE80211_TX_CTL_REQ_TX_STATUS;
 
+	rcu_read_lock();
+
 	if (unlikely(sdata->vif.type == NL80211_IFTYPE_MONITOR)) {
 		int hdrlen;
 		u16 len_rthdr;
@@ -1469,7 +1469,6 @@ static void ieee80211_xmit(struct ieee80
 			 * support we will need a different mechanism.
 			 */
 
-			rcu_read_lock();
 			list_for_each_entry_rcu(tmp_sdata, &local->interfaces,
 						list) {
 				if (!netif_running(tmp_sdata->dev))
@@ -1478,13 +1477,10 @@ static void ieee80211_xmit(struct ieee80
 					continue;
 				if (compare_ether_addr(tmp_sdata->dev->dev_addr,
 						       hdr->addr2) == 0) {
-					dev_hold(tmp_sdata->dev);
-					dev_put(sdata->dev);
 					sdata = tmp_sdata;
 					break;
 				}
 			}
-			rcu_read_unlock();
 		}
 	}
 
@@ -1498,7 +1494,7 @@ static void ieee80211_xmit(struct ieee80
 
 	if (ieee80211_skb_resize(local, skb, headroom, may_encrypt)) {
 		dev_kfree_skb(skb);
-		dev_put(sdata->dev);
+		rcu_read_unlock();
 		return;
 	}
 
@@ -1509,13 +1505,13 @@ static void ieee80211_xmit(struct ieee80
 		!is_multicast_ether_addr(hdr->addr1))
 			if (mesh_nexthop_lookup(skb, sdata)) {
 				/* skb queued: don't free */
-				dev_put(sdata->dev);
+				rcu_read_unlock();
 				return;
 			}
 
 	ieee80211_select_queue(local, skb);
 	ieee80211_tx(sdata, skb, false);
-	dev_put(sdata->dev);
+	rcu_read_unlock();
 }
 
 netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
@@ -1965,12 +1961,10 @@ void ieee80211_tx_pending(unsigned long 
 			}
 
 			sdata = vif_to_sdata(info->control.vif);
-			dev_hold(sdata->dev);
 			spin_unlock_irqrestore(&local->queue_stop_reason_lock,
 						flags);
 
 			txok = ieee80211_tx_pending_skb(local, skb);
-			dev_put(sdata->dev);
 			if (!txok)
 				__skb_queue_head(&local->pending[i], skb);
 			spin_lock_irqsave(&local->queue_stop_reason_lock,


