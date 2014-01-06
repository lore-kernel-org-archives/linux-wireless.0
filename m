Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42969 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbaAFO6o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 09:58:44 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: ZHAO Gang <gamerh2o@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: handle station TX latency allocation errors
Date: Mon,  6 Jan 2014 15:58:40 +0100
Message-Id: <1389020320-30862-1-git-send-email-johannes@sipsolutions.net> (sfid-20140106_155847_722591_B67F56CA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When the station's TX latency data structures need to be
allocated, handle failures properly and also free all the
structures if there are any other problems.

Move the allocation code up so that allocation failures
don't trigger rate control algorithm calls.

Reported-by: ZHAO Gang <gamerh2o@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/sta_info.c | 70 ++++++++++++++++++++++++++++---------------------
 1 file changed, 40 insertions(+), 30 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 8da3af2..703081d 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -300,6 +300,35 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	if (!sta)
 		return NULL;
 
+	rcu_read_lock();
+	tx_latency = rcu_dereference(local->tx_latency);
+	/* init stations Tx latency statistics && TID bins */
+	if (tx_latency) {
+		sta->tx_lat = kzalloc(IEEE80211_NUM_TIDS *
+				      sizeof(struct ieee80211_tx_latency_stat),
+				      GFP_ATOMIC);
+		if (!sta->tx_lat) {
+			rcu_read_unlock();
+			goto free;
+		}
+
+		if (tx_latency->n_ranges) {
+			for (i = 0; i < IEEE80211_NUM_TIDS; i++) {
+				/* size of bins is size of the ranges +1 */
+				sta->tx_lat[i].bin_count =
+					tx_latency->n_ranges + 1;
+				sta->tx_lat[i].bins =
+					kcalloc(sta->tx_lat[i].bin_count,
+						sizeof(u32), GFP_ATOMIC);
+				if (!sta->tx_lat[i].bins) {
+					rcu_read_unlock();
+					goto free;
+				}
+			}
+		}
+	}
+	rcu_read_unlock();
+
 	spin_lock_init(&sta->lock);
 	INIT_WORK(&sta->drv_unblock_wk, sta_unblock);
 	INIT_WORK(&sta->ampdu_mlme.work, ieee80211_ba_session_work);
@@ -324,10 +353,8 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	for (i = 0; i < ARRAY_SIZE(sta->chain_signal_avg); i++)
 		ewma_init(&sta->chain_signal_avg[i], 1024, 8);
 
-	if (sta_prepare_rate_control(local, sta, gfp)) {
-		kfree(sta);
-		return NULL;
-	}
+	if (sta_prepare_rate_control(local, sta, gfp))
+		goto free;
 
 	for (i = 0; i < IEEE80211_NUM_TIDS; i++) {
 		/*
@@ -371,34 +398,17 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
-	rcu_read_lock();
-
-	tx_latency = rcu_dereference(local->tx_latency);
-	/* init stations Tx latency statistics && TID bins */
-	if (tx_latency)
-		sta->tx_lat = kzalloc(IEEE80211_NUM_TIDS *
-				      sizeof(struct ieee80211_tx_latency_stat),
-				      GFP_ATOMIC);
-
-	/*
-	 * if Tx latency and bins are enabled and the previous allocation
-	 * succeeded
-	 */
-	if (tx_latency && tx_latency->n_ranges && sta->tx_lat)
-		for (i = 0; i < IEEE80211_NUM_TIDS; i++) {
-			/* size of bins is size of the ranges +1 */
-			sta->tx_lat[i].bin_count =
-				tx_latency->n_ranges + 1;
-			sta->tx_lat[i].bins  = kcalloc(sta->tx_lat[i].bin_count,
-						       sizeof(u32),
-						       GFP_ATOMIC);
-		}
-
-	rcu_read_unlock();
-
 	sta_dbg(sdata, "Allocated STA %pM\n", sta->sta.addr);
-
 	return sta;
+
+free:
+	if (sta->tx_lat) {
+		for (i = 0; i < IEEE80211_NUM_TIDS; i++)
+			kfree(sta->tx_lat[i].bins);
+		kfree(sta->tx_lat);
+	}
+	kfree(sta);
+	return NULL;
 }
 
 static int sta_info_insert_check(struct sta_info *sta)
-- 
1.8.5.1

