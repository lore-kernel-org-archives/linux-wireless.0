Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:35035 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755908Ab3FLVNq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jun 2013 17:13:46 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH] mac80211: Ensure tid_start_tx is protected by sta->lock.
Date: Wed, 12 Jun 2013 14:08:44 -0700
Message-Id: <1371071324-12440-1-git-send-email-greearb@candelatech.com> (sfid-20130612_231349_459253_446F29CA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

All accesses of the tid_start_tx lock should be protected
by sta->lock if there is any chance that another thread
could still be accessing the sta object.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 net/mac80211/ht.c       |    4 +++-
 net/mac80211/sta_info.h |    1 +
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index 0db25d4..87b8b23 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -283,13 +283,14 @@ void ieee80211_ba_session_work(struct work_struct *work)
 				sta, tid, WLAN_BACK_RECIPIENT,
 				WLAN_REASON_UNSPECIFIED, true);
 
+		spin_lock_bh(&sta->lock);
+
 		tid_tx = sta->ampdu_mlme.tid_start_tx[tid];
 		if (tid_tx) {
 			/*
 			 * Assign it over to the normal tid_tx array
 			 * where it "goes live".
 			 */
-			spin_lock_bh(&sta->lock);
 
 			sta->ampdu_mlme.tid_start_tx[tid] = NULL;
 			/* could there be a race? */
@@ -302,6 +303,7 @@ void ieee80211_ba_session_work(struct work_struct *work)
 			ieee80211_tx_ba_session_handle_start(sta, tid);
 			continue;
 		}
+		spin_unlock_bh(&sta->lock);
 
 		tid_tx = rcu_dereference_protected_tid_tx(sta, tid);
 		if (tid_tx && test_and_clear_bit(HT_AGG_STATE_WANT_STOP,
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index c509423..de40c5b 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -204,6 +204,7 @@ struct tid_ampdu_rx {
  *	driver requested to close until the work for it runs
  * @mtx: mutex to protect all TX data (except non-NULL assignments
  *	to tid_tx[idx], which are protected by the sta spinlock)
+ *	tid_start_tx is also protected by sta->lock.
  */
 struct sta_ampdu_mlme {
 	struct mutex mtx;
-- 
1.7.3.4

