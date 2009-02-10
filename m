Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51858 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbZBJUdg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2009 15:33:36 -0500
Message-Id: <20090210202553.874683796@sipsolutions.net> (sfid-20090210_213339_457417_4BBE00C5)
References: <20090210202536.425266119@sipsolutions.net>
Date: Tue, 10 Feb 2009 21:25:43 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 07/27] mac80211: remove bssid argument from
	prepare_for_handlers
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's a little confusing to get the BSSID outside the function
and pass it in, when it's only needed for this function, so
change that.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/rx.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- wireless-testing.orig/net/mac80211/rx.c	2009-02-10 20:59:27.000000000 +0100
+++ wireless-testing/net/mac80211/rx.c	2009-02-10 20:59:31.000000000 +0100
@@ -2030,9 +2030,10 @@ static void ieee80211_invoke_rx_handlers
 /* main receive path */
 
 static int prepare_for_handlers(struct ieee80211_sub_if_data *sdata,
-				u8 *bssid, struct ieee80211_rx_data *rx,
+				struct ieee80211_rx_data *rx,
 				struct ieee80211_hdr *hdr)
 {
+	u8 *bssid = ieee80211_get_bssid(hdr, rx->skb->len, sdata->vif.type);
 	int multicast = is_multicast_ether_addr(hdr->addr1);
 
 	switch (sdata->vif.type) {
@@ -2135,7 +2136,6 @@ static void __ieee80211_rx_handle_packet
 	int prepares;
 	struct ieee80211_sub_if_data *prev = NULL;
 	struct sk_buff *skb_new;
-	u8 *bssid;
 
 	hdr = (struct ieee80211_hdr *)skb->data;
 	memset(&rx, 0, sizeof(rx));
@@ -2174,9 +2174,8 @@ static void __ieee80211_rx_handle_packet
 		if (sdata->vif.type == NL80211_IFTYPE_MONITOR)
 			continue;
 
-		bssid = ieee80211_get_bssid(hdr, skb->len, sdata->vif.type);
 		rx.flags |= IEEE80211_RX_RA_MATCH;
-		prepares = prepare_for_handlers(sdata, bssid, &rx, hdr);
+		prepares = prepare_for_handlers(sdata, &rx, hdr);
 
 		if (!prepares)
 			continue;

-- 

