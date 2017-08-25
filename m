Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45722 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754839AbdHYIPp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Aug 2017 04:15:45 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 25 Aug 2017 11:15:33 +0300
Message-Id: <20170825081533.27916-1-luca@coelho.fi> (sfid-20170825_101550_536037_EA21D72D)
Subject: [PATCH] mac80211: Complete ampdu work schedule during session tear down
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Peer <ilan.peer@intel.com>

Commit 7a7c0a6438b8 ("mac80211: fix TX aggregation start/stop callback race")
added a cancellation of the ampdu work after the loop that stopped the
Tx and Rx BA sessions. However, in some cases, e.g., during HW reconfig,
the low level driver might call mac80211 APIs to complete the stopping
of the BA sessions, which would queue the ampdu work to handle the actual
completion. This work needs to be performed as otherwise mac80211 data
structures would not be properly synced.

Fix this by checking if BA session STOP_CB bit is set after the BA session
cancellation and properly clean the session.

Fixes: 7a7c0a6438b8 ("mac80211: fix TX aggregation start/stop callback race")
Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/mac80211/ht.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index c92df492e898..105e2802a48a 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -300,6 +300,21 @@ void ieee80211_sta_tear_down_BA_sessions(struct sta_info *sta,
 
 	/* stopping might queue the work again - so cancel only afterwards */
 	cancel_work_sync(&sta->ampdu_mlme.work);
+
+	/* In case the tear down is part of a reconfigure due to HW restart
+	 * request, it is possible that the low level driver requested to stop
+	 * the BA session, so handle it to properly clean tid_tx data.
+	 */
+	for (i = 0; i < IEEE80211_NUM_TIDS; i++) {
+		struct tid_ampdu_tx *tid_tx =
+			rcu_dereference_protected_tid_tx(sta, i);
+
+		if (!tid_tx)
+			continue;
+
+		if (test_and_clear_bit(HT_AGG_STATE_STOP_CB, &tid_tx->state))
+			ieee80211_stop_tx_ba_cb(sta, i, tid_tx);
+	}
 }
 
 void ieee80211_ba_session_work(struct work_struct *work)
-- 
2.14.1
