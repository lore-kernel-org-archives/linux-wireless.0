Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45516 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756838Ab0EaKAP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 May 2010 06:00:15 -0400
Subject: [PATCH] mac80211: fix dialog token allocator
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 May 2010 12:00:12 +0200
Message-ID: <1275300012.3586.11.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The dialog token allocator has apparently been broken
since b83f4e15 ("mac80211: fix deadlock in sta->lock")
because it got moved out under the spinlock. Fix it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
Seems like a low-impact change ... could be backported to almost every
stable tree out there I guess since it was broken almost exactly three
years ago ... but does it matter? I guess not.

 net/mac80211/agg-tx.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- wireless-testing.orig/net/mac80211/agg-tx.c	2010-05-31 11:50:54.000000000 +0200
+++ wireless-testing/net/mac80211/agg-tx.c	2010-05-31 11:53:53.000000000 +0200
@@ -332,14 +332,16 @@ int ieee80211_start_tx_ba_session(struct
 		IEEE80211_QUEUE_STOP_REASON_AGGREGATION);
 
 	spin_unlock(&local->ampdu_lock);
-	spin_unlock_bh(&sta->lock);
 
-	/* send an addBA request */
+	/* prepare tid data */
 	sta->ampdu_mlme.dialog_token_allocator++;
 	sta->ampdu_mlme.tid_tx[tid]->dialog_token =
 			sta->ampdu_mlme.dialog_token_allocator;
 	sta->ampdu_mlme.tid_tx[tid]->ssn = start_seq_num;
 
+	spin_unlock_bh(&sta->lock);
+
+	/* send AddBA request */
 	ieee80211_send_addba_request(sdata, pubsta->addr, tid,
 			 sta->ampdu_mlme.tid_tx[tid]->dialog_token,
 			 sta->ampdu_mlme.tid_tx[tid]->ssn,


