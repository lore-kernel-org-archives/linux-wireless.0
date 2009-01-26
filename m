Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34389 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbZAZSwR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2009 13:52:17 -0500
Message-Id: <20090126184925.080610122@sipsolutions.net> (sfid-20090126_195229_004853_1B243251)
References: <20090126184740.036240879@sipsolutions.net>
Date: Mon, 26 Jan 2009 19:47:43 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@gmail.com, Sujith.Manoharan@atheros.com, tomasw@gmail.com
Subject: [RFC/RFT 3/7] mac80211: hardware should not deny going back to
	legacy
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Doing so would be an MLME protocol violation when the peer disabled
the aggregation session. Quick driver review indicates that there are
error codes passed all over the drivers but cannot ever be nonzero
except in error conditions that would indicate mac80211 bugs.

No real changes here, since no drivers currently can return -EBUSY.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/agg-tx.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- wireless-testing.orig/net/mac80211/agg-tx.c	2009-01-26 19:41:36.000000000 +0100
+++ wireless-testing/net/mac80211/agg-tx.c	2009-01-26 19:41:47.000000000 +0100
@@ -393,9 +393,8 @@ int ieee80211_stop_tx_ba_session(struct 
 		ret = local->ops->ampdu_action(hw, IEEE80211_AMPDU_TX_STOP,
 					       &sta->sta, tid, NULL);
 
-	/* case HW denied going back to legacy */
-	if (ret) {
-		WARN_ON(ret != -EBUSY);
+	/* HW shall not deny going back to legacy */
+	if (WARN_ON(ret)) {
 		*state = HT_AGG_STATE_OPERATIONAL;
 		if (hw->ampdu_queues)
 			ieee80211_wake_queue(hw, sta->tid_to_tx_q[tid]);

-- 

