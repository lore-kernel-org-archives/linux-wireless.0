Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52719 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab2L1JJW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Dec 2012 04:09:22 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/4] mac80211: split out aggregation TX removal
Date: Fri, 28 Dec 2012 10:09:39 +0100
Message-Id: <1356685781-6758-3-git-send-email-johannes@sipsolutions.net> (sfid-20121228_100932_482535_F2E083AC)
In-Reply-To: <1356685781-6758-1-git-send-email-johannes@sipsolutions.net>
References: <1356685781-6758-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Create the function ieee80211_remove_tid_tx to call
it from ___ieee80211_stop_tx_ba_session later.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/agg-tx.c | 48 ++++++++++++++++++++++++++++++------------------
 1 file changed, 30 insertions(+), 18 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index e0656d7..101bbfb 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -713,6 +713,35 @@ int ieee80211_stop_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid)
 }
 EXPORT_SYMBOL(ieee80211_stop_tx_ba_session);
 
+static void ieee80211_remove_tid_tx(struct sta_info *sta, int tid)
+{
+	struct tid_ampdu_tx *tid_tx;
+
+	lockdep_assert_held(&sta->ampdu_mlme.mtx);
+	lockdep_assert_held(&sta->lock);
+
+	tid_tx = rcu_dereference_protected_tid_tx(sta, tid);
+
+	/*
+	 * When we get here, the TX path will not be lockless any more wrt.
+	 * aggregation, since the OPERATIONAL bit has long been cleared.
+	 * Thus it will block on getting the lock, if it occurs. So if we
+	 * stop the queue now, we will not get any more packets, and any
+	 * that might be being processed will wait for us here, thereby
+	 * guaranteeing that no packets go to the tid_tx pending queue any
+	 * more.
+	 */
+
+	ieee80211_agg_splice_packets(sta->sdata, tid_tx, tid);
+
+	/* future packets must not find the tid_tx struct any more */
+	ieee80211_assign_tid_tx(sta, tid, NULL);
+
+	ieee80211_agg_splice_finish(sta->sdata, tid);
+
+	kfree_rcu(tid_tx, rcu_head);
+}
+
 void ieee80211_stop_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u8 tid)
 {
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
@@ -751,24 +780,7 @@ void ieee80211_stop_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u8 tid)
 		ieee80211_send_delba(sta->sdata, ra, tid,
 			WLAN_BACK_INITIATOR, WLAN_REASON_QSTA_NOT_USE);
 
-	/*
-	 * When we get here, the TX path will not be lockless any more wrt.
-	 * aggregation, since the OPERATIONAL bit has long been cleared.
-	 * Thus it will block on getting the lock, if it occurs. So if we
-	 * stop the queue now, we will not get any more packets, and any
-	 * that might be being processed will wait for us here, thereby
-	 * guaranteeing that no packets go to the tid_tx pending queue any
-	 * more.
-	 */
-
-	ieee80211_agg_splice_packets(sta->sdata, tid_tx, tid);
-
-	/* future packets must not find the tid_tx struct any more */
-	ieee80211_assign_tid_tx(sta, tid, NULL);
-
-	ieee80211_agg_splice_finish(sta->sdata, tid);
-
-	kfree_rcu(tid_tx, rcu_head);
+	ieee80211_remove_tid_tx(sta, tid);
 
  unlock_sta:
 	spin_unlock_bh(&sta->lock);
-- 
1.8.0

