Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42945 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755994Ab1K2Qu5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Nov 2011 11:50:57 -0500
Subject: [RFC] mac80211: fix another race in aggregation start
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Nikolay Martynov <mar.kolya@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Nov 2011 17:50:53 +0100
Message-ID: <1322585453.4110.24.camel@jlt3.sipsolutions.net> (sfid-20111129_175100_439723_5B996661)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Noticed by looking at the code: if packets are
being processed while we clear the WANT_START
bit, they might see it clear and queue up on
tid_tx->pending. If the driver rejects the new
aggregation session then, we leak the packet.

Cc: stable@vger.kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/agg-tx.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/net/mac80211/agg-tx.c	2011-11-29 17:23:40.000000000 +0100
+++ b/net/mac80211/agg-tx.c	2011-11-29 17:48:16.000000000 +0100
@@ -324,14 +324,19 @@ void ieee80211_tx_ba_session_handle_star
 	 */
 	ieee80211_stop_queue_agg(local, tid);
 
-	clear_bit(HT_AGG_STATE_WANT_START, &tid_tx->state);
-
 	/*
-	 * make sure no packets are being processed to get
-	 * valid starting sequence number
+	 * Make sure no packets are being processed. This ensures that
+	 *  a) we have a valid starting sequence number and it's really
+	 *     the next frame and that
+	 *  b) there's no packet that sees WANT_START cleared and queues
+	 *     up on tid_tx->pending which would cause us to lose it if
+	 *     the driver rejects the session and probably confuse the
+	 *     driver otherwise.
 	 */
 	synchronize_net();
 
+	clear_bit(HT_AGG_STATE_WANT_START, &tid_tx->state);
+
 	start_seq_num = sta->tid_seq[tid] >> 4;
 
 	ret = drv_ampdu_action(local, sdata, IEEE80211_AMPDU_TX_START,


