Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54414 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068AbZI3USM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2009 16:18:12 -0400
Subject: [PATCH 2.6.32] mac80211: fix vlan and optimise RX
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	=?UTF-8?Q?Bla=C5=BE_Ba=C4=8Dnik?= <bacnik@gmail.com>
In-Reply-To: <1254341787.3959.11.camel@johannes.local>
References: <57b62e7d0909291754x352ae254sa33ee7efb430d497@mail.gmail.com>
	 <1254341787.3959.11.camel@johannes.local>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Sep 2009 22:18:13 +0200
Message-Id: <1254341893.3959.13.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When receiving data frames, we can send them only to
the interface they belong to based on transmitting
station (this doesn't work for probe requests). Also,
don't try to handle other frames for AP_VLAN at all
since those interface should only receive data.

Additionally, the transmit side must check that the
station we're sending a frame to is actually on the
interface we're transmitting on, and not transmit
packets to functions that live on other interfaces,
so validate that as well.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: stable@kernel.org
---
 net/mac80211/rx.c |   10 ++++++++--
 net/mac80211/tx.c |    3 ++-
 2 files changed, 10 insertions(+), 3 deletions(-)

--- wireless-testing.orig/net/mac80211/rx.c	2009-09-30 21:38:59.000000000 +0200
+++ wireless-testing/net/mac80211/rx.c	2009-09-30 22:09:54.000000000 +0200
@@ -2164,11 +2164,17 @@ static void __ieee80211_rx_handle_packet
 
 	skb = rx.skb;
 
-	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+	if (rx.sdata && ieee80211_is_data(hdr->frame_control)) {
+		rx.flags |= IEEE80211_RX_RA_MATCH;
+		prepares = prepare_for_handlers(rx.sdata, &rx, hdr);
+		if (prepares)
+			prev = rx.sdata;
+	} else list_for_each_entry_rcu(sdata, &local->interfaces, list) {
 		if (!netif_running(sdata->dev))
 			continue;
 
-		if (sdata->vif.type == NL80211_IFTYPE_MONITOR)
+		if (sdata->vif.type == NL80211_IFTYPE_MONITOR ||
+		    sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 			continue;
 
 		rx.flags |= IEEE80211_RX_RA_MATCH;
--- wireless-testing.orig/net/mac80211/tx.c	2009-09-30 21:49:34.000000000 +0200
+++ wireless-testing/net/mac80211/tx.c	2009-09-30 22:04:25.000000000 +0200
@@ -1704,7 +1704,8 @@ netdev_tx_t ieee80211_subif_start_xmit(s
 	if (!is_multicast_ether_addr(hdr.addr1)) {
 		rcu_read_lock();
 		sta = sta_info_get(local, hdr.addr1);
-		if (sta)
+		/* XXX: in the future, use sdata to look up the sta */
+		if (sta && sta->sdata == sdata)
 			sta_flags = get_sta_flags(sta);
 		rcu_read_unlock();
 	}


