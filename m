Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38571 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019AbXIZNZJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2007 09:25:09 -0400
Message-Id: <20070926132135.353162000@sipsolutions.net>
References: <20070926131938.575572000@sipsolutions.net>
Date: Wed, 26 Sep 2007 15:19:47 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, flamingice@sourmilk.net
Subject: [patch 09/12] mac80211: fix iff_promiscs, iff_allmultis race
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we update the counters iff_promiscs and iff_allmultis
in struct ieee80211_local we have no common lock held to
protect them. The problem is that the update to each counter
may not be atomic, so we could end up with iff_promiscs == -1
in unfortunate conditions. To fix it, use atomic_t values.
It doesn't matter whether the two counters are updated
together atomically or not, if there are two invocations
of set_multicast_list we will end up with multiple
configure_filter() invocations of which the latter will always
be correct.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/ieee80211.c   |   12 ++++++------
 net/mac80211/ieee80211_i.h |    5 ++---
 net/mac80211/rx.c          |    3 ++-
 3 files changed, 10 insertions(+), 10 deletions(-)

--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-09-25 23:29:36.561571777 +0200
+++ wireless-dev/net/mac80211/ieee80211.c	2007-09-25 23:29:39.261570204 +0200
@@ -59,10 +59,10 @@ static void ieee80211_configure_filter(s
 	unsigned int changed_flags;
 	unsigned int new_flags = 0;
 
-	if (local->iff_promiscs)
+	if (atomic_read(&local->iff_promiscs))
 		new_flags |= FIF_PROMISC_IN_BSS;
 
-	if (local->iff_allmultis)
+	if (atomic_read(&local->iff_allmultis))
 		new_flags |= FIF_ALLMULTI;
 
 	if (local->monitors)
@@ -522,17 +522,17 @@ static void ieee80211_set_multicast_list
 
 	if (allmulti != sdata_allmulti) {
 		if (dev->flags & IFF_ALLMULTI)
-			local->iff_allmultis++;
+			atomic_inc(&local->iff_allmultis);
 		else
-			local->iff_allmultis--;
+			atomic_dec(&local->iff_allmultis);
 		sdata->flags ^= IEEE80211_SDATA_ALLMULTI;
 	}
 
 	if (promisc != sdata_promisc) {
 		if (dev->flags & IFF_PROMISC)
-			local->iff_promiscs++;
+			atomic_inc(&local->iff_promiscs);
 		else
-			local->iff_promiscs--;
+			atomic_dec(&local->iff_promiscs);
 		sdata->flags ^= IEEE80211_SDATA_PROMISC;
 	}
 
--- wireless-dev.orig/net/mac80211/ieee80211_i.h	2007-09-25 23:29:37.921572374 +0200
+++ wireless-dev/net/mac80211/ieee80211_i.h	2007-09-25 23:29:39.261570204 +0200
@@ -444,9 +444,8 @@ struct ieee80211_local {
 	struct ieee80211_tx_stored_packet pending_packet[NUM_TX_DATA_QUEUES];
 	struct tasklet_struct tx_pending_tasklet;
 
-	int mc_count;	/* total count of multicast entries in all interfaces */
-	int iff_allmultis, iff_promiscs;
-			/* number of interfaces with corresponding IFF_ flags */
+	/* number of interfaces with corresponding IFF_ flags */
+	atomic_t iff_allmultis, iff_promiscs;
 
 	struct rate_control_ref *rate_ctrl;
 
--- wireless-dev.orig/net/mac80211/rx.c	2007-09-25 23:29:36.571573405 +0200
+++ wireless-dev/net/mac80211/rx.c	2007-09-25 23:29:39.271572319 +0200
@@ -1531,7 +1531,8 @@ void __ieee80211_rx(struct ieee80211_hw 
 	skb = rx.skb;
 
 	if (sta && !(sta->flags & (WLAN_STA_WDS | WLAN_STA_ASSOC_AP)) &&
-	    !local->iff_promiscs && !is_multicast_ether_addr(hdr->addr1)) {
+	    !atomic_read(&local->iff_promiscs) &&
+	    !is_multicast_ether_addr(hdr->addr1)) {
 		rx.flags |= IEEE80211_TXRXD_RXRA_MATCH;
 		ieee80211_invoke_rx_handlers(local, local->rx_handlers, &rx,
 					     rx.sta);

-- 

