Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42606 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200Ab1IFMNN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Sep 2011 08:13:13 -0400
Subject: [PATCH] mac80211: further optimise buffer expiry timer
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Juuso Oikarinen <juuso.oikarinen@nokia.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Sep 2011 14:13:06 +0200
Message-ID: <1315311186.3900.6.camel@jlt3.sipsolutions.net> (sfid-20110906_141316_656185_C69691BC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Juuso optimised the timer to not run all the
time in commit 3393a608c4979a94d1887efc05b7.
However, after that it will still run once
more even if all frames just expired. Fixing
that also makes the function return value a
little clearer in the process.

Also, while at it, change the return value
to bool (instead of int).

Cc: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/sta_info.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/net/mac80211/sta_info.c	2011-09-06 09:48:48.000000000 +0200
+++ b/net/mac80211/sta_info.c	2011-09-06 11:36:26.000000000 +0200
@@ -691,14 +691,13 @@ void sta_info_clear_tim_bit(struct sta_i
 	spin_unlock_irqrestore(&sta->local->sta_lock, flags);
 }
 
-static int sta_info_buffer_expired(struct sta_info *sta,
-				   struct sk_buff *skb)
+static bool sta_info_buffer_expired(struct sta_info *sta, struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *info;
 	int timeout;
 
 	if (!skb)
-		return 0;
+		return false;
 
 	info = IEEE80211_SKB_CB(skb);
 
@@ -718,9 +717,6 @@ static bool sta_info_cleanup_expire_buff
 	unsigned long flags;
 	struct sk_buff *skb;
 
-	if (skb_queue_empty(&sta->ps_tx_buf))
-		return false;
-
 	for (;;) {
 		spin_lock_irqsave(&sta->ps_tx_buf.lock, flags);
 		skb = skb_peek(&sta->ps_tx_buf);
@@ -745,7 +741,7 @@ static bool sta_info_cleanup_expire_buff
 			sta_info_clear_tim_bit(sta);
 	}
 
-	return true;
+	return !skb_queue_empty(&sta->ps_tx_buf);
 }
 
 static int __must_check __sta_info_destroy(struct sta_info *sta)


