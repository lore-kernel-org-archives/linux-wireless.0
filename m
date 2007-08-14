Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37533 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885AbXHNO0g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2007 10:26:36 -0400
Subject: [PATCH] mac80211: don't send packets to interfaces that are down
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>,
	David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain
Date: Tue, 14 Aug 2007 16:28:41 +0200
Message-Id: <1187101721.4069.48.camel@johannes.berg>
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

--- wireless-dev.orig/net/mac80211/rx.c	2007-08-14 16:18:10.924225996 +0200
+++ wireless-dev/net/mac80211/rx.c	2007-08-14 16:18:27.014225996 +0200
@@ -1511,6 +1511,9 @@ void __ieee80211_rx(struct ieee80211_hw 
 	list_for_each_entry(sdata, &local->sub_if_list, list) {
 		rx.u.rx.ra_match = 1;
 
+		if (!netif_running(sdata->dev))
+			continue;
+
 		prepres = prepare_for_handlers(sdata, bssid, &rx, hdr);
 		/* prepare_for_handlers can change sta */
 		sta = rx.sta;


