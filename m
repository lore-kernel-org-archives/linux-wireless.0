Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43982 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757088AbYFOMzu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Jun 2008 08:55:50 -0400
Subject: [PATCH v2] mac80211: detect driver tx bugs
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1213534025.3803.2.camel@johannes.berg> (sfid-20080615_144745_622030_910244B5)
References: <1213534025.3803.2.camel@johannes.berg>
	 (sfid-20080615_144745_622030_910244B5)
Content-Type: text/plain
Date: Sun, 15 Jun 2008 14:55:40 +0200
Message-Id: <1213534540.3803.5.camel@johannes.berg> (sfid-20080615_145613_932431_D2E4E6A8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a driver rejects a frame in it's ->tx() callback, it must also
stop queues, otherwise mac80211 can go into a loop here. Detect this
situation and abort the loop after five retries, warning about the
driver bug.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
v2: Michael suggested to use WARN_ON_ONCE instead

 net/mac80211/tx.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- everything.orig/net/mac80211/tx.c	2008-06-15 14:19:10.000000000 +0200
+++ everything/net/mac80211/tx.c	2008-06-15 14:53:52.000000000 +0200
@@ -1091,7 +1091,7 @@ static int ieee80211_tx(struct net_devic
 	struct ieee80211_tx_data tx;
 	ieee80211_tx_result res = TX_DROP, res_prepare;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	int ret, i;
+	int ret, i, retries = 0;
 	u16 queue;
 
 	queue = skb_get_queue_mapping(skb);
@@ -1189,6 +1189,13 @@ retry:
 		 */
 		if (!__netif_subqueue_stopped(local->mdev, queue)) {
 			clear_bit(queue, local->queues_pending);
+			retries++;
+			/*
+			 * Driver bug, it's rejecting packets but
+			 * not stopping queues.
+			 */
+			if (WARN_ON_ONCE(retries > 5))
+				goto drop;
 			goto retry;
 		}
 		store->skb = skb;


