Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53312 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857Ab0IWTcY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Sep 2010 15:32:24 -0400
Message-Id: <20100923193137.867101720@sipsolutions.net>
Date: Thu, 23 Sep 2010 21:31:00 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [RFC 1/3] mac80211: remove prepare_for_handlers sdata argument
References: <20100923193059.805312839@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The first argument to prepare_for_handlers is always
the sdata that can just be stored in rx data directly
(and even already is, in two of four code paths.)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- wireless-testing.orig/net/mac80211/rx.c	2010-09-23 20:58:22.000000000 +0200
+++ wireless-testing/net/mac80211/rx.c	2010-09-23 21:27:20.000000000 +0200
@@ -2517,10 +2517,10 @@ void ieee80211_release_reorder_timeout(s
 
 /* main receive path */
 
-static int prepare_for_handlers(struct ieee80211_sub_if_data *sdata,
-				struct ieee80211_rx_data *rx,
+static int prepare_for_handlers(struct ieee80211_rx_data *rx,
 				struct ieee80211_hdr *hdr)
 {
+	struct ieee80211_sub_if_data *sdata = rx->sdata;
 	struct sk_buff *skb = rx->skb;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	u8 *bssid = ieee80211_get_bssid(hdr, skb->len, sdata->vif.type);
@@ -2660,7 +2660,7 @@ static void __ieee80211_rx_handle_packet
 			rx.sdata = prev_sta->sdata;
 
 			status->rx_flags |= IEEE80211_RX_RA_MATCH;
-			prepares = prepare_for_handlers(rx.sdata, &rx, hdr);
+			prepares = prepare_for_handlers(&rx, hdr);
 			if (!prepares)
 				goto next_sta;
 
@@ -2694,7 +2694,7 @@ next_sta:
 			rx.sdata = prev_sta->sdata;
 
 			status->rx_flags |= IEEE80211_RX_RA_MATCH;
-			prepares = prepare_for_handlers(rx.sdata, &rx, hdr);
+			prepares = prepare_for_handlers(&rx, hdr);
 			if (!prepares)
 				prev_sta = NULL;
 
@@ -2737,15 +2737,15 @@ next_sta:
 			}
 
 			rx.sta = sta_info_get_bss(prev, hdr->addr2);
+			rx.sdata = prev;
 
 			status->rx_flags |= IEEE80211_RX_RA_MATCH;
-			prepares = prepare_for_handlers(prev, &rx, hdr);
+			prepares = prepare_for_handlers(&rx, hdr);
 
 			if (!prepares)
 				goto next;
 
 			if (status->flag & RX_FLAG_MMIC_ERROR) {
-				rx.sdata = prev;
 				if (status->rx_flags & IEEE80211_RX_RA_MATCH)
 					ieee80211_rx_michael_mic_report(hdr,
 									&rx);
@@ -2772,15 +2772,15 @@ next:
 
 		if (prev) {
 			rx.sta = sta_info_get_bss(prev, hdr->addr2);
+			rx.sdata = prev;
 
 			status->rx_flags |= IEEE80211_RX_RA_MATCH;
-			prepares = prepare_for_handlers(prev, &rx, hdr);
+			prepares = prepare_for_handlers(&rx, hdr);
 
 			if (!prepares)
 				prev = NULL;
 
 			if (prev && status->flag & RX_FLAG_MMIC_ERROR) {
-				rx.sdata = prev;
 				if (status->rx_flags & IEEE80211_RX_RA_MATCH)
 					ieee80211_rx_michael_mic_report(hdr,
 									&rx);


