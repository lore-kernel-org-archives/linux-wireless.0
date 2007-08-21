Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54210 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286AbXHUKH5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2007 06:07:57 -0400
Subject: [PATCH 17/20 v2] mac80211: avoid copying packets to interfaces  that are down
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: John Linville <linville@tuxdriver.com>, Jiri Benc <jbenc@suse.cz>,
	linux-wireless@vger.kernel.org,
	David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <200708152148.58436.flamingice@sourmilk.net>
References: <20070815144920.135826000@sipsolutions.net>
	 <20070815145048.965414000@sipsolutions.net>
	 <200708152148.58436.flamingice@sourmilk.net>
Content-Type: text/plain
Date: Tue, 21 Aug 2007 10:50:13 +0200
Message-Id: <1187686213.28717.5.camel@johannes.berg>
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

--- wireless-dev.orig/net/mac80211/rx.c	2007-08-21 02:10:22.456915818 +0200
+++ wireless-dev/net/mac80211/rx.c	2007-08-21 10:45:58.276912218 +0200
@@ -1522,6 +1522,9 @@ void __ieee80211_rx(struct ieee80211_hw 
 	list_for_each_entry(sdata, &local->sub_if_list, list) {
 		rx.u.rx.ra_match = 1;
 
+		if (!netif_running(sdata->dev))
+			continue;
+
 		prepres = prepare_for_handlers(sdata, bssid, &rx, hdr);
 		/* prepare_for_handlers can change sta */
 		sta = rx.sta;
--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-08-21 10:36:42.236912218 +0200
+++ wireless-dev/net/mac80211/ieee80211.c	2007-08-21 10:48:05.176912218 +0200
@@ -466,7 +466,16 @@ static void ieee80211_if_shutdown(struct
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


