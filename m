Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39086 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757691AbYBAMJ2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2008 07:09:28 -0500
Message-Id: <20080131185053.674773000@sipsolutions.net> (sfid-20080201_120938_818746_3193A18B)
References: <20080131184819.103174000@sipsolutions.net>
Date: Thu, 31 Jan 2008 19:48:24 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 5/8] mac80211: clean up some things in the RX path
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Uninline ieee80211_invoke_rx_handlers to save .text space,
make the code more readable in some places and remove the
"optimisation" that is hit only very few times and unclear
to start with.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
I have a plan to add back such an optimisation but it is rather
involved requiring a scan handling change and per-sdata sta
structures.

 net/mac80211/rx.c |   37 ++++++++++---------------------------
 1 file changed, 10 insertions(+), 27 deletions(-)

--- everything.orig/net/mac80211/rx.c	2008-01-31 15:46:09.985793781 +0100
+++ everything/net/mac80211/rx.c	2008-01-31 15:46:12.415793891 +0100
@@ -1448,11 +1448,10 @@ ieee80211_rx_h_mgmt(struct ieee80211_txr
 	return RX_QUEUED;
 }
 
-static inline ieee80211_rx_result __ieee80211_invoke_rx_handlers(
-				struct ieee80211_local *local,
-				ieee80211_rx_handler *handlers,
-				struct ieee80211_txrx_data *rx,
-				struct sta_info *sta)
+static void ieee80211_invoke_rx_handlers(struct ieee80211_local *local,
+					 ieee80211_rx_handler *handlers,
+					 struct ieee80211_txrx_data *rx,
+					 struct sta_info *sta)
 {
 	ieee80211_rx_handler *handler;
 	ieee80211_rx_result res = RX_DROP_MONITOR;
@@ -1476,19 +1475,13 @@ static inline ieee80211_rx_result __ieee
 		break;
 	}
 
-	if (res == RX_DROP_UNUSABLE || res == RX_DROP_MONITOR)
-		dev_kfree_skb(rx->skb);
-	return res;
-}
-
-static inline void ieee80211_invoke_rx_handlers(struct ieee80211_local *local,
-						ieee80211_rx_handler *handlers,
-						struct ieee80211_txrx_data *rx,
-						struct sta_info *sta)
-{
-	if (__ieee80211_invoke_rx_handlers(local, handlers, rx, sta) ==
-	    RX_CONTINUE)
+	switch (res) {
+	case RX_DROP_MONITOR:
+	case RX_DROP_UNUSABLE:
+	case RX_CONTINUE:
 		dev_kfree_skb(rx->skb);
+		break;
+	}
 }
 
 static void ieee80211_rx_michael_mic_report(struct net_device *dev,
@@ -1718,16 +1711,6 @@ static void __ieee80211_rx_handle_packet
 
 	skb = rx.skb;
 
-	if (sta && !(sta->flags & (WLAN_STA_WDS | WLAN_STA_ASSOC_AP)) &&
-	    !atomic_read(&local->iff_promiscs) &&
-	    !is_multicast_ether_addr(hdr->addr1)) {
-		rx.flags |= IEEE80211_TXRXD_RXRA_MATCH;
-		ieee80211_invoke_rx_handlers(local, local->rx_handlers, &rx,
-					     rx.sta);
-		sta_info_put(sta);
-		return;
-	}
-
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
 		if (!netif_running(sdata->dev))
 			continue;

-- 

