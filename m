Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53154 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756442AbYEPXED (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2008 19:04:03 -0400
Message-Id: <20080516230007.165503000@sipsolutions.net> (sfid-20080517_010407_893973_6A92703B)
References: <20080516225712.794319000@sipsolutions.net>
Date: Sat, 17 May 2008 00:57:13 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
	Ron Rindjunksi <ron.rindjunski@intel.com>
Subject: [PATCH 1/2] mac80211: dont allow fragmentation and requeuing on
	A-MPDU queues
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There really is no reason for a driver to reject a frame on
an A-MPDU queue when it can stop that queue for any period
of time and is given frames one by one. Hence, disallow it
with a big warning and reduce mac80211-internal state.

Also add a warning when we try to fragment a frame destined
for an A-MPDU queue and drop it, the actual bug needs to be
fixed elsewhere but I'm not exactly sure how to yet.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Ron Rindjunski <ron.rindjunski@intel.com>
---
 include/net/mac80211.h     |    6 ++++--
 net/mac80211/ieee80211_i.h |    2 +-
 net/mac80211/tx.c          |   23 +++++++++++++++++++++--
 3 files changed, 26 insertions(+), 5 deletions(-)

--- everything.orig/net/mac80211/ieee80211_i.h	2008-05-16 15:39:55.000000000 +0200
+++ everything/net/mac80211/ieee80211_i.h	2008-05-16 15:40:03.000000000 +0200
@@ -596,7 +596,7 @@ struct ieee80211_local {
 	struct timer_list sta_cleanup;
 
 	unsigned long state[IEEE80211_MAX_QUEUES + IEEE80211_MAX_AMPDU_QUEUES];
-	struct ieee80211_tx_stored_packet pending_packet[IEEE80211_MAX_QUEUES + IEEE80211_MAX_AMPDU_QUEUES];
+	struct ieee80211_tx_stored_packet pending_packet[IEEE80211_MAX_QUEUES];
 	struct tasklet_struct tx_pending_tasklet;
 
 	/* number of interfaces with corresponding IFF_ flags */
--- everything.orig/net/mac80211/tx.c	2008-05-16 15:34:45.000000000 +0200
+++ everything/net/mac80211/tx.c	2008-05-16 15:42:16.000000000 +0200
@@ -673,6 +673,16 @@ ieee80211_tx_h_fragment(struct ieee80211
 	if (!(tx->flags & IEEE80211_TX_FRAGMENTED))
 		return TX_CONTINUE;
 
+	/*
+	 * Warn when submitting a fragmented A-MPDU frame and drop it.
+	 * This is an error and needs to be fixed elsewhere, but when
+	 * done needs to take care of monitor interfaces (injection)
+	 * etc.
+	 */
+	if (WARN_ON(tx->flags & IEEE80211_TX_CTL_AMPDU ||
+		    IEEE80211_SKB_CB(tx->skb)->queue >= tx->local->hw.queues))
+		return TX_DROP;
+
 	first = tx->skb;
 
 	hdrlen = ieee80211_get_hdrlen(tx->fc);
@@ -1216,8 +1226,17 @@ static int ieee80211_tx(struct net_devic
 retry:
 	ret = __ieee80211_tx(local, skb, &tx);
 	if (ret) {
-		struct ieee80211_tx_stored_packet *store =
-			&local->pending_packet[info->queue];
+		struct ieee80211_tx_stored_packet *store;
+
+		/*
+		 * Since there are no fragmented frames on A-MPDU
+		 * queues, there's no reason for a driver to reject
+		 * a frame there, warn and drop it.
+		 */
+		if (WARN_ON(queue >= local->hw.queues))
+			goto drop;
+
+		store = &local->pending_packet[queue];
 
 		if (ret == IEEE80211_TX_FRAG_AGAIN)
 			skb = NULL;
--- everything.orig/include/net/mac80211.h	2008-05-16 15:42:45.000000000 +0200
+++ everything/include/net/mac80211.h	2008-05-16 15:44:02.000000000 +0200
@@ -986,8 +986,10 @@ enum ieee80211_ampdu_mlme_action {
  * @tx: Handler that 802.11 module calls for each transmitted frame.
  *	skb contains the buffer starting from the IEEE 802.11 header.
  *	The low-level driver should send the frame out based on
- *	configuration in the TX control data. Must be implemented and
- *	atomic.
+ *	configuration in the TX control data. This handler should,
+ *	preferably, never fail and stop queues appropriately, more
+ *	importantly, however, it must never fail for A-MPDU-queues.
+ *	Must be implemented and atomic.
  *
  * @start: Called before the first netdevice attached to the hardware
  *	is enabled. This should turn on the hardware and must turn on

-- 

