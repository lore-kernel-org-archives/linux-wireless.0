Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:26968 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753087AbdIFMjt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Sep 2017 08:39:49 -0400
From: Ilan Peer <ilan.peer@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH v3] mac80211: Complete ampdu work schedule during session tear down
Date: Wed,  6 Sep 2017 17:32:40 +0300
Message-Id: <1504708360-28463-1-git-send-email-ilan.peer@intel.com> (sfid-20170906_144000_921943_4DF93185)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit 7a7c0a6438b8 ("mac80211: fix TX aggregation start/stop callback race")
added a cancellation of the ampdu work after the loop that stopped the
Tx and Rx BA sessions. However, in some cases, e.g., during HW reconfig,
the low level driver might call mac80211 APIs to complete the stopping
of the BA sessions, which would queue the ampdu work to handle the actual
completion. This work needs to be performed as otherwise mac80211 data
structures would not be properly synced.

Fix this by checking if BA session STOP_CB bit is set after the BA session
cancellation and properly clean the session.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
---
 net/mac80211/ht.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index c92df49..11d691c 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -300,6 +300,23 @@ void ieee80211_sta_tear_down_BA_sessions(struct sta_info *sta,
 
 	/* stopping might queue the work again - so cancel only afterwards */
 	cancel_work_sync(&sta->ampdu_mlme.work);
+
+	/* In case the tear down is part of a reconfigure due to HW restart
+	 * request, it is possible that the low level driver requested to stop
+	 * the BA session, so handle it to properly clean tid_tx data.
+	 */
+	mutex_lock(&sta->ampdu_mlme.mtx);
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
+	mutex_unlock(&sta->ampdu_mlme.mtx);
 }
 
 void ieee80211_ba_session_work(struct work_struct *work)
-- 
1.9.1
