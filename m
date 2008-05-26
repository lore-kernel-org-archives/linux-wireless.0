Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:30068 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756401AbYEZOJY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2008 10:09:24 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 1/1] mac80211: fix deadlock in sta->lock
Date: Mon, 26 May 2008 17:09:18 +0300
Message-Id: <1211810958-23095-1-git-send-email-tomas.winkler@intel.com> (sfid-20080526_160936_239975_94B16351)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch fixes a deadlock of sta->lock use, occuring while changing
tx aggregation states, as dev_queue_xmit end up in new function
test_and_clear_sta_flags that uses that lock thus leading to deadlock

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 net/mac80211/main.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index b0fddb7..5a9030c 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -662,6 +662,8 @@ int ieee80211_start_tx_ba_session(struct ieee80211_hw *hw, u8 *ra, u16 tid)
 		goto start_ba_err;
 	}
 
+	spin_unlock_bh(&sta->lock);
+
 	/* Will put all the packets in the new SW queue */
 	ieee80211_requeue(local, ieee802_1d_to_ac[tid]);
 	spin_unlock_bh(&local->mdev->queue_lock);
@@ -688,9 +690,9 @@ start_ba_err:
 	kfree(sta->ampdu_mlme.tid_tx[tid]);
 	sta->ampdu_mlme.tid_tx[tid] = NULL;
 	spin_unlock_bh(&local->mdev->queue_lock);
+	spin_unlock_bh(&sta->lock);
 	ret = -EBUSY;
 start_ba_exit:
-	spin_unlock_bh(&sta->lock);
 	rcu_read_unlock();
 	return ret;
 }
@@ -829,10 +831,11 @@ void ieee80211_stop_tx_ba_cb(struct ieee80211_hw *hw, u8 *ra, u8 tid)
 	}
 	state = &sta->ampdu_mlme.tid_state_tx[tid];
 
-	spin_lock_bh(&sta->lock);
+	/* no need to use sta->lock in this state check, as
+	 * ieee80211_stop_tx_ba_session will let only
+	 * one stop call to pass through per sta/tid */
 	if ((*state & HT_AGG_STATE_REQ_STOP_BA_MSK) == 0) {
 		printk(KERN_DEBUG "unexpected callback to A-MPDU stop\n");
-		spin_unlock_bh(&sta->lock);
 		rcu_read_unlock();
 		return;
 	}
@@ -855,6 +858,7 @@ void ieee80211_stop_tx_ba_cb(struct ieee80211_hw *hw, u8 *ra, u8 tid)
 	 * ieee80211_wake_queue is not used here as this queue is not
 	 * necessarily stopped */
 	netif_schedule(local->mdev);
+	spin_lock_bh(&sta->lock);
 	*state = HT_AGG_STATE_IDLE;
 	sta->ampdu_mlme.addba_req_num[tid] = 0;
 	kfree(sta->ampdu_mlme.tid_tx[tid]);
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

