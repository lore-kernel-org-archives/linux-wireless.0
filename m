Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58426 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758989AbXHUPKR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2007 11:10:17 -0400
Message-Id: <20070821150039.396311000@sipsolutions.net>
References: <20070821145905.689978000@sipsolutions.net>
Date: Tue, 21 Aug 2007 16:59:08 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 03/27] mac80211: avoid copying packets to interfaces that  are down
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Woodhouse noticed that under some circumstances the number of slab
allocations kept growing. After looking a bit, this seemed to happen
when you had a management mode interface that was *down*.

The reason for this is that when the device is down, all management
frames get queued to the in-kernel MLME (via ieee80211_sta_rx_mgmt) but
then the sta work is invoked but doesn't run when the netif is down.
When you then bring the interface up, all such frames are freed, but if
you change the mode all of them are lost because the skb queue is
reinitialised as soon as you go back to managed mode. The skb queue is
correctly cleared when the interface is brought down, but the code
doesn't account for the fact that it may be filled while it is not up.

This patch should fix the issue by simply ignoring all interfaces that
are down when going through the RX handlers.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/ieee80211.c |    9 +++++++++
 net/mac80211/rx.c        |    3 +++
 2 files changed, 12 insertions(+)

--- wireless-dev.orig/net/mac80211/rx.c	2007-08-21 14:39:40.425923881 +0200
+++ wireless-dev/net/mac80211/rx.c	2007-08-21 14:39:42.675923881 +0200
@@ -1521,6 +1521,9 @@ void __ieee80211_rx(struct ieee80211_hw 
 	list_for_each_entry(sdata, &local->sub_if_list, list) {
 		rx.u.rx.ra_match = 1;
 
+		if (!netif_running(sdata->dev))
+			continue;
+
 		prepres = prepare_for_handlers(sdata, bssid, &rx, hdr);
 		/* prepare_for_handlers can change sta */
 		sta = rx.sta;
--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-08-21 14:39:41.445923881 +0200
+++ wireless-dev/net/mac80211/ieee80211.c	2007-08-21 14:39:42.675923881 +0200
@@ -494,7 +494,16 @@ static void ieee80211_if_shutdown(struct
 		sdata->u.sta.state = IEEE80211_DISABLED;
 		del_timer_sync(&sdata->u.sta.timer);
 		del_timer_sync(&sdata->u.sta.admit_timer);
+		/*
+		 * Holding the sub_if_lock for writing here blocks
+		 * out the receive path and makes sure it's not
+		 * currently processing a packet that may get
+		 * added to the queue.
+		 */
+		write_lock_bh(&local->sub_if_lock);
 		skb_queue_purge(&sdata->u.sta.skb_queue);
+		write_unlock_bh(&local->sub_if_lock);
+
 		if (!local->ops->hw_scan &&
 		    local->scan_dev == sdata->dev) {
 			local->sta_scanning = 0;

-- 

