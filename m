Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43843 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763219AbXHOO4A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2007 10:56:00 -0400
Message-Id: <20070815145048.965414000@sipsolutions.net>
References: <20070815144920.135826000@sipsolutions.net>
Date: Wed, 15 Aug 2007 16:49:37 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 17/20] mac80211: avoid copying packets to interfaces that  are down
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
Is there a possibility of a race condition here? If the interface is
brought down right after this check the SKB could be copied to that
interface after the skb queue has been flushed.

 net/mac80211/rx.c |    3 +++
 1 file changed, 3 insertions(+)

--- wireless-dev.orig/net/mac80211/rx.c	2007-08-15 14:13:28.596516958 +0200
+++ wireless-dev/net/mac80211/rx.c	2007-08-15 14:13:30.866516958 +0200
@@ -1522,6 +1522,9 @@ void __ieee80211_rx(struct ieee80211_hw 
 	list_for_each_entry(sdata, &local->sub_if_list, list) {
 		rx.u.rx.ra_match = 1;
 
+		if (!netif_running(sdata->dev))
+			continue;
+
 		prepres = prepare_for_handlers(sdata, bssid, &rx, hdr);
 		/* prepare_for_handlers can change sta */
 		sta = rx.sta;

-- 

