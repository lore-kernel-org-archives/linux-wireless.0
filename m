Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:55527 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227Ab3FLUUU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jun 2013 16:20:20 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [RFC] mac80211:  Ensure tid_start_tx is protected by sta->lock.
Date: Wed, 12 Jun 2013 13:20:09 -0700
Message-Id: <1371068409-10407-1-git-send-email-greearb@candelatech.com> (sfid-20130612_222023_756658_E80BFC74)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

I believe this is more correct, though it did not fix the
memory leak I was chasing when I found this code.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 net/mac80211/ht.c       |    5 ++++-
 net/mac80211/sta_info.h |    1 +
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index 0db25d4..c6256b4 100644
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
@@ -301,6 +302,8 @@ void ieee80211_ba_session_work(struct work_struct *work)
 
 			ieee80211_tx_ba_session_handle_start(sta, tid);
 			continue;
+		} else {
+			spin_unlock_bh(&sta->lock);
 		}
 
 		tid_tx = rcu_dereference_protected_tid_tx(sta, tid);
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index c509423..0f85418 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -204,6 +204,7 @@ struct tid_ampdu_rx {
  *	driver requested to close until the work for it runs
  * @mtx: mutex to protect all TX data (except non-NULL assignments
  *	to tid_tx[idx], which are protected by the sta spinlock)
+ *      tid_start_tx is also protected by sta->lock.
  */
 struct sta_ampdu_mlme {
 	struct mutex mtx;
-- 
1.7.3.4

