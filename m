Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51954 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467AbZBJUgO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2009 15:36:14 -0500
Message-Id: <20090210202554.811991593@sipsolutions.net> (sfid-20090210_213618_147788_CBEB71E0)
References: <20090210202536.425266119@sipsolutions.net>
Date: Tue, 10 Feb 2009 21:25:48 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 12/27] mac80211: hardware should not deny going back to
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

--- wireless-testing.orig/net/mac80211/agg-tx.c	2009-02-10 20:59:32.000000000 +0100
+++ wireless-testing/net/mac80211/agg-tx.c	2009-02-10 20:59:33.000000000 +0100
@@ -407,9 +407,8 @@ int ieee80211_stop_tx_ba_session(struct 
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

