Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39103 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758476AbYBAMJq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2008 07:09:46 -0500
Message-Id: <20080131185054.167645000@sipsolutions.net> (sfid-20080201_120950_879057_BAFE5D33)
References: <20080131184819.103174000@sipsolutions.net>
Date: Thu, 31 Jan 2008 19:48:25 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 6/8] mac80211: remove "dynamic" RX/TX handlers
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It doesn't really make sense to have extra pointers to the RX/TX
handler arrays instead of just using the arrays directly, that
also allows us to make them static.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211.c   |    2 -
 net/mac80211/ieee80211_i.h |   13 -------
 net/mac80211/rx.c          |   80 +++++++++++++++++++++------------------------
 net/mac80211/tx.c          |    9 ++---
 4 files changed, 43 insertions(+), 61 deletions(-)

--- everything.orig/net/mac80211/ieee80211.c	2008-01-31 15:46:11.615800454 +0100
+++ everything/net/mac80211/ieee80211.c	2008-01-31 15:46:13.125794378 +0100
@@ -1426,8 +1426,6 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 	local->hw.queues = 1; /* default */
 
 	local->mdev = mdev;
-	local->rx_handlers = ieee80211_rx_handlers;
-	local->tx_handlers = ieee80211_tx_handlers;
 
 	local->bridge_packets = 1;
 
--- everything.orig/net/mac80211/ieee80211_i.h	2008-01-31 15:46:11.615800454 +0100
+++ everything/net/mac80211/ieee80211_i.h	2008-01-31 15:46:13.135794379 +0100
@@ -190,12 +190,6 @@ struct ieee80211_tx_stored_packet {
 	unsigned int last_frag_rate_ctrl_probe;
 };
 
-typedef ieee80211_tx_result (*ieee80211_tx_handler)
-(struct ieee80211_txrx_data *tx);
-
-typedef ieee80211_rx_result (*ieee80211_rx_handler)
-(struct ieee80211_txrx_data *rx);
-
 struct beacon_data {
 	u8 *head, *tail;
 	int head_len, tail_len;
@@ -477,9 +471,6 @@ struct ieee80211_local {
 			     * deliver multicast frames both back to wireless
 			     * media and to the local net stack */
 
-	ieee80211_rx_handler *rx_handlers;
-	ieee80211_tx_handler *tx_handlers;
-
 	struct list_head interfaces;
 
 	bool sta_sw_scanning;
@@ -779,11 +770,7 @@ int ieee80211_if_remove(struct net_devic
 void ieee80211_if_free(struct net_device *dev);
 void ieee80211_if_sdata_init(struct ieee80211_sub_if_data *sdata);
 
-/* rx handling */
-extern ieee80211_rx_handler ieee80211_rx_handlers[];
-
 /* tx handling */
-extern ieee80211_tx_handler ieee80211_tx_handlers[];
 void ieee80211_clear_tx_pending(struct ieee80211_local *local);
 void ieee80211_tx_pending(unsigned long data);
 int ieee80211_master_start_xmit(struct sk_buff *skb, struct net_device *dev);
--- everything.orig/net/mac80211/rx.c	2008-01-31 15:46:12.415793891 +0100
+++ everything/net/mac80211/rx.c	2008-01-31 15:46:13.135794379 +0100
@@ -1448,42 +1448,6 @@ ieee80211_rx_h_mgmt(struct ieee80211_txr
 	return RX_QUEUED;
 }
 
-static void ieee80211_invoke_rx_handlers(struct ieee80211_local *local,
-					 ieee80211_rx_handler *handlers,
-					 struct ieee80211_txrx_data *rx,
-					 struct sta_info *sta)
-{
-	ieee80211_rx_handler *handler;
-	ieee80211_rx_result res = RX_DROP_MONITOR;
-
-	for (handler = handlers; *handler != NULL; handler++) {
-		res = (*handler)(rx);
-
-		switch (res) {
-		case RX_CONTINUE:
-			continue;
-		case RX_DROP_UNUSABLE:
-		case RX_DROP_MONITOR:
-			I802_DEBUG_INC(local->rx_handlers_drop);
-			if (sta)
-				sta->rx_dropped++;
-			break;
-		case RX_QUEUED:
-			I802_DEBUG_INC(local->rx_handlers_queued);
-			break;
-		}
-		break;
-	}
-
-	switch (res) {
-	case RX_DROP_MONITOR:
-	case RX_DROP_UNUSABLE:
-	case RX_CONTINUE:
-		dev_kfree_skb(rx->skb);
-		break;
-	}
-}
-
 static void ieee80211_rx_michael_mic_report(struct net_device *dev,
 					    struct ieee80211_hdr *hdr,
 					    struct sta_info *sta,
@@ -1557,7 +1521,8 @@ static void ieee80211_rx_michael_mic_rep
 	rx->skb = NULL;
 }
 
-ieee80211_rx_handler ieee80211_rx_handlers[] =
+typedef ieee80211_rx_result (*ieee80211_rx_handler)(struct ieee80211_txrx_data *);
+static ieee80211_rx_handler ieee80211_rx_handlers[] =
 {
 	ieee80211_rx_h_if_stats,
 	ieee80211_rx_h_passive_scan,
@@ -1579,6 +1544,41 @@ ieee80211_rx_handler ieee80211_rx_handle
 	NULL
 };
 
+static void ieee80211_invoke_rx_handlers(struct ieee80211_local *local,
+					 struct ieee80211_txrx_data *rx,
+					 struct sta_info *sta)
+{
+	ieee80211_rx_handler *handler;
+	ieee80211_rx_result res = RX_DROP_MONITOR;
+
+	for (handler = ieee80211_rx_handlers; *handler != NULL; handler++) {
+		res = (*handler)(rx);
+
+		switch (res) {
+		case RX_CONTINUE:
+			continue;
+		case RX_DROP_UNUSABLE:
+		case RX_DROP_MONITOR:
+			I802_DEBUG_INC(local->rx_handlers_drop);
+			if (sta)
+				sta->rx_dropped++;
+			break;
+		case RX_QUEUED:
+			I802_DEBUG_INC(local->rx_handlers_queued);
+			break;
+		}
+		break;
+	}
+
+	switch (res) {
+	case RX_DROP_MONITOR:
+	case RX_DROP_UNUSABLE:
+	case RX_CONTINUE:
+		dev_kfree_skb(rx->skb);
+		break;
+	}
+}
+
 /* main receive path */
 
 static int prepare_for_handlers(struct ieee80211_sub_if_data *sdata,
@@ -1756,8 +1756,7 @@ static void __ieee80211_rx_handle_packet
 		rx.skb = skb_new;
 		rx.dev = prev->dev;
 		rx.sdata = prev;
-		ieee80211_invoke_rx_handlers(local, local->rx_handlers,
-					     &rx, sta);
+		ieee80211_invoke_rx_handlers(local, &rx, sta);
 		prev = sdata;
 	}
 	if (prev) {
@@ -1765,8 +1764,7 @@ static void __ieee80211_rx_handle_packet
 		rx.skb = skb;
 		rx.dev = prev->dev;
 		rx.sdata = prev;
-		ieee80211_invoke_rx_handlers(local, local->rx_handlers,
-					     &rx, sta);
+		ieee80211_invoke_rx_handlers(local, &rx, sta);
 	} else
 		dev_kfree_skb(skb);
 
--- everything.orig/net/mac80211/tx.c	2008-01-31 15:46:09.035794161 +0100
+++ everything/net/mac80211/tx.c	2008-01-31 15:46:13.135794379 +0100
@@ -813,10 +813,9 @@ ieee80211_tx_h_load_stats(struct ieee802
 	return TX_CONTINUE;
 }
 
-/* TODO: implement register/unregister functions for adding TX/RX handlers
- * into ordered list */
 
-ieee80211_tx_handler ieee80211_tx_handlers[] =
+typedef ieee80211_tx_result (*ieee80211_tx_handler)(struct ieee80211_txrx_data *);
+static ieee80211_tx_handler ieee80211_tx_handlers[] =
 {
 	ieee80211_tx_h_check_assoc,
 	ieee80211_tx_h_sequence,
@@ -1158,7 +1157,7 @@ static int ieee80211_tx(struct net_devic
 	sta = tx.sta;
 	tx.u.tx.channel = local->hw.conf.channel;
 
-	for (handler = local->tx_handlers; *handler != NULL;
+	for (handler = ieee80211_tx_handlers; *handler != NULL;
 	     handler++) {
 		res = (*handler)(&tx);
 		if (res != TX_CONTINUE)
@@ -1914,7 +1913,7 @@ ieee80211_get_buffered_bc(struct ieee802
 	tx.flags |= IEEE80211_TXRXD_TXPS_BUFFERED;
 	tx.u.tx.channel = local->hw.conf.channel;
 
-	for (handler = local->tx_handlers; *handler != NULL; handler++) {
+	for (handler = ieee80211_tx_handlers; *handler != NULL; handler++) {
 		res = (*handler)(&tx);
 		if (res == TX_DROP || res == TX_QUEUED)
 			break;

-- 

