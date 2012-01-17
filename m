Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42911 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab2AQJbe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jan 2012 04:31:34 -0500
Subject: [PATCH] mac80211: clean up aggregation destruction
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Yogesh Ashok Powar <yogesh.powar@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Jan 2012 10:31:30 +0100
Message-ID: <1326792690.3342.5.camel@jlt3.sipsolutions.net> (sfid-20120117_103139_114874_83D99F38)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Yogesh's patch to destroy aggregation sessions when
stations are destroyed was needed, but unnecessarily
complex. Clean up this code.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
(resent to include the list)

 net/mac80211/sta_info.c |   31 ++++++++-----------------------
 1 file changed, 8 insertions(+), 23 deletions(-)

--- a/net/mac80211/sta_info.c	2012-01-17 10:23:59.000000000 +0100
+++ b/net/mac80211/sta_info.c	2012-01-17 10:28:14.000000000 +0100
@@ -763,35 +763,20 @@ int __must_check __sta_info_destroy(stru
 	}
 #endif
 
-	/* There could be some memory leaks because of ampdu tx pending queue
-	 * not being freed before destroying the station info.
-	 *
-	 * Make sure that such queues are purged before freeing the station
-	 * info.
-	 * TODO: We have to somehow postpone the full destruction
-	 * until the aggregation stop completes. Refer
-	 * http://thread.gmane.org/gmane.linux.kernel.wireless.general/81936
+	/*
+	 * Destroy aggregation state here. It would be nice to wait for the
+	 * driver to finish aggregation stop and then clean up, but for now
+	 * drivers have to handle aggregation stop being requested, followed
+	 * directly by station destruction.
 	 */
-
-	mutex_lock(&sta->ampdu_mlme.mtx);
-
 	for (i = 0; i < STA_TID_NUM; i++) {
-		tid_tx = rcu_dereference_protected_tid_tx(sta, i);
+		tid_tx = rcu_dereference_raw(sta->ampdu_mlme.tid_tx[i]);
 		if (!tid_tx)
 			continue;
-		if (skb_queue_len(&tid_tx->pending)) {
-#ifdef CONFIG_MAC80211_HT_DEBUG
-			wiphy_debug(local->hw.wiphy, "TX A-MPDU  purging %d "
-				"packets for tid=%d\n",
-				skb_queue_len(&tid_tx->pending), i);
-#endif /* CONFIG_MAC80211_HT_DEBUG */
-			__skb_queue_purge(&tid_tx->pending);
-		}
-		kfree_rcu(tid_tx, rcu_head);
+		__skb_queue_purge(&tid_tx->pending);
+		kfree(tid_tx);
 	}
 
-	mutex_unlock(&sta->ampdu_mlme.mtx);
-
 	sta_info_free(local, sta);
 
 	return 0;



