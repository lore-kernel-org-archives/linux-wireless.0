Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:36760 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384AbYE2Ihy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2008 04:37:54 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 36/43] mac80211: fix deadlock in sta->lock
Date: Thu, 29 May 2008 16:35:21 +0800
Message-Id: <1212050128-17132-37-git-send-email-yi.zhu@intel.com> (sfid-20080529_103806_134442_74A014FD)
In-Reply-To: <1212050128-17132-36-git-send-email-yi.zhu@intel.com>
References: <1212050128-17132-1-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-2-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-3-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-4-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-5-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-6-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-7-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-8-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-9-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-10-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-11-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-12-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-13-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-14-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-15-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-16-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-17-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-18-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-19-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-20-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-21-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-22-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-23-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-24-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-25-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-26-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-27-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-28-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-29-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-30-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-31-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-32-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-33-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-34-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-35-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-36-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch fixes a deadlock of sta->lock use, occurring while changing
tx aggregation states, as dev_queue_xmit end up in new function
test_and_clear_sta_flags that uses that lock thus leading to deadlock.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 net/mac80211/main.c |   30 +++++++++++++++++-------------
 1 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index e5e4a1d..4b57de4 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -589,8 +589,8 @@ int ieee80211_start_tx_ba_session(struct ieee80211_hw *hw, u8 *ra, u16 tid)
 	sta = sta_info_get(local, ra);
 	if (!sta) {
 		printk(KERN_DEBUG "Could not find the station\n");
-		rcu_read_unlock();
-		return -ENOENT;
+		ret = -ENOENT;
+		goto exit;
 	}
 
 	spin_lock_bh(&sta->lock);
@@ -598,7 +598,7 @@ int ieee80211_start_tx_ba_session(struct ieee80211_hw *hw, u8 *ra, u16 tid)
 	/* we have tried too many times, receiver does not want A-MPDU */
 	if (sta->ampdu_mlme.addba_req_num[tid] > HT_AGG_MAX_RETRIES) {
 		ret = -EBUSY;
-		goto start_ba_exit;
+		goto err_unlock_sta;
 	}
 
 	state = &sta->ampdu_mlme.tid_state_tx[tid];
@@ -609,7 +609,7 @@ int ieee80211_start_tx_ba_session(struct ieee80211_hw *hw, u8 *ra, u16 tid)
 				 "idle on tid %u\n", tid);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
 		ret = -EAGAIN;
-		goto start_ba_exit;
+		goto err_unlock_sta;
 	}
 
 	/* prepare A-MPDU MLME for Tx aggregation */
@@ -620,7 +620,7 @@ int ieee80211_start_tx_ba_session(struct ieee80211_hw *hw, u8 *ra, u16 tid)
 			printk(KERN_ERR "allocate tx mlme to tid %d failed\n",
 					tid);
 		ret = -ENOMEM;
-		goto start_ba_exit;
+		goto err_unlock_sta;
 	}
 	/* Tx timer */
 	sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer.function =
@@ -643,7 +643,7 @@ int ieee80211_start_tx_ba_session(struct ieee80211_hw *hw, u8 *ra, u16 tid)
 		printk(KERN_DEBUG "BA request denied - queue unavailable for"
 					" tid %d\n", tid);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
-		goto start_ba_err;
+		goto err_unlock_queue;
 	}
 	sdata = sta->sdata;
 
@@ -665,12 +665,13 @@ int ieee80211_start_tx_ba_session(struct ieee80211_hw *hw, u8 *ra, u16 tid)
 					" tid %d\n", tid);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
 		*state = HT_AGG_STATE_IDLE;
-		goto start_ba_err;
+		goto err_unlock_queue;
 	}
 
 	/* Will put all the packets in the new SW queue */
 	ieee80211_requeue(local, ieee802_1d_to_ac[tid]);
 	spin_unlock_bh(&local->mdev->queue_lock);
+	spin_unlock_bh(&sta->lock);
 
 	/* send an addBA request */
 	sta->ampdu_mlme.dialog_token_allocator++;
@@ -678,25 +679,26 @@ int ieee80211_start_tx_ba_session(struct ieee80211_hw *hw, u8 *ra, u16 tid)
 			sta->ampdu_mlme.dialog_token_allocator;
 	sta->ampdu_mlme.tid_tx[tid]->ssn = start_seq_num;
 
+
 	ieee80211_send_addba_request(sta->sdata->dev, ra, tid,
 			 sta->ampdu_mlme.tid_tx[tid]->dialog_token,
 			 sta->ampdu_mlme.tid_tx[tid]->ssn,
 			 0x40, 5000);
-
 	/* activate the timer for the recipient's addBA response */
 	sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer.expires =
 				jiffies + ADDBA_RESP_INTERVAL;
 	add_timer(&sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer);
 	printk(KERN_DEBUG "activated addBA response timer on tid %d\n", tid);
-	goto start_ba_exit;
+	goto exit;
 
-start_ba_err:
+err_unlock_queue:
 	kfree(sta->ampdu_mlme.tid_tx[tid]);
 	sta->ampdu_mlme.tid_tx[tid] = NULL;
 	spin_unlock_bh(&local->mdev->queue_lock);
 	ret = -EBUSY;
-start_ba_exit:
+err_unlock_sta:
 	spin_unlock_bh(&sta->lock);
+exit:
 	rcu_read_unlock();
 	return ret;
 }
@@ -835,10 +837,11 @@ void ieee80211_stop_tx_ba_cb(struct ieee80211_hw *hw, u8 *ra, u8 tid)
 	}
 	state = &sta->ampdu_mlme.tid_state_tx[tid];
 
-	spin_lock_bh(&sta->lock);
+	/* NOTE: no need to use sta->lock in this state check, as
+	 * ieee80211_stop_tx_ba_session will let only
+	 * one stop call to pass through per sta/tid */
 	if ((*state & HT_AGG_STATE_REQ_STOP_BA_MSK) == 0) {
 		printk(KERN_DEBUG "unexpected callback to A-MPDU stop\n");
-		spin_unlock_bh(&sta->lock);
 		rcu_read_unlock();
 		return;
 	}
@@ -861,6 +864,7 @@ void ieee80211_stop_tx_ba_cb(struct ieee80211_hw *hw, u8 *ra, u8 tid)
 	 * ieee80211_wake_queue is not used here as this queue is not
 	 * necessarily stopped */
 	netif_schedule(local->mdev);
+	spin_lock_bh(&sta->lock);
 	*state = HT_AGG_STATE_IDLE;
 	sta->ampdu_mlme.addba_req_num[tid] = 0;
 	kfree(sta->ampdu_mlme.tid_tx[tid]);
-- 
1.5.3.6

