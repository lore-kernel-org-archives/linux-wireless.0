Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:40554 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752962Ab3BDLTX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2013 06:19:23 -0500
From: Amit Shakya <amit.shakya@stericsson.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amit Shakya <amit.shakya@stericsson.com>
Subject: [PATCH] mac80211: Fix PN corruption in case of multiple virtual interface
Date: Mon, 4 Feb 2013 16:48:57 +0530
Message-ID: <1359976737-28059-1-git-send-email-amit.shakya@stericsson.com> (sfid-20130204_121932_077461_638586DB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case of multiple virtual interface, if AES is configured on multiple
interface then there are chances of stored PN corruption, causing traffic
to stop.
In case, ieee80211_rx_handlers processing is going on for skbs received on
one vif and at the same time, rx aggregation reorder timer expires on
another vif then sta_rx_agg_reorder_timer_expired is invoked and it will
push skbs into the single queue (local->rx_skb_queue).
ieee80211_rx_handlers in the while loop assumes that the skbs are for the
same TID and same sta. This assumption doesn't hold good in this scenario
and the PN gets corrupted by PN received in other vif's skb, causing
traffic to stop due to PN mismatch.
This can be avoided by comparing source mac addres in received skb's with
the sta's mac address for which processing is going on, when de-queueing.

Signed-off-by: Amit Shakya <amit.shakya@stericsson.com>
---
 net/mac80211/rx.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 580704e..e6f1799 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2775,7 +2775,8 @@ static void ieee80211_rx_handlers_result(struct ieee80211_rx_data *rx,
 static void ieee80211_rx_handlers(struct ieee80211_rx_data *rx)
 {
 	ieee80211_rx_result res = RX_DROP_MONITOR;
-	struct sk_buff *skb;
+	struct sk_buff *skb, *tmp;
+	struct ieee80211_hdr *hdr;
 
 #define CALL_RXH(rxh)			\
 	do {				\
@@ -2790,7 +2791,20 @@ static void ieee80211_rx_handlers(struct ieee80211_rx_data *rx)
 
 	rx->local->running_rx_handler = true;
 
-	while ((skb = __skb_dequeue(&rx->local->rx_skb_queue))) {
+	skb_queue_walk_safe(&rx->local->rx_skb_queue, skb, tmp) {
+		if (!skb)
+			break;
+		hdr = (struct ieee80211_hdr *) skb->data;
+		/*
+		* Additional check to ensure that the packets corresponding
+		* to same sta entry as in rx->sta are de-queued. The queue
+		* can have different interface packets in case of multiple vifs
+		*/
+		if ((rx->sta && hdr) && (ieee80211_is_data(hdr->frame_control))
+			&& (memcmp(rx->sta->sta.addr, hdr->addr2, ETH_ALEN)))
+					continue;
+		__skb_unlink(skb, &rx->local->rx_skb_queue);
+
 		spin_unlock(&rx->local->rx_skb_queue.lock);
 
 		/*
-- 
1.7.4.1

