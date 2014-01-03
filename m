Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:56876 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbaACQoA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jan 2014 11:44:00 -0500
Received: by mail-pa0-f51.google.com with SMTP id fa1so15889406pad.24
        for <linux-wireless@vger.kernel.org>; Fri, 03 Jan 2014 08:43:59 -0800 (PST)
From: ZHAO Gang <gamerh2o@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: add handler for memeory allocation failure
Date: Sat,  4 Jan 2014 00:42:52 +0800
Message-Id: <46c874024953fa47667455051f304041827748e0.1388766243.git.gamerh2o@gmail.com> (sfid-20140103_174404_594893_07C11E2F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: ZHAO Gang <gamerh2o@gmail.com>
---
 net/mac80211/sta_info.c | 26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 4576ba0..c600caf 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -325,8 +325,7 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 		ewma_init(&sta->chain_signal_avg[i], 1024, 8);
 
 	if (sta_prepare_rate_control(local, sta, gfp)) {
-		kfree(sta);
-		return NULL;
+		goto free_sta;
 	}
 
 	for (i = 0; i < IEEE80211_NUM_TIDS; i++) {
@@ -375,10 +374,15 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 
 	tx_latency = rcu_dereference(local->tx_latency);
 	/* init stations Tx latency statistics && TID bins */
-	if (tx_latency)
+	if (tx_latency) {
 		sta->tx_lat = kzalloc(IEEE80211_NUM_TIDS *
 				      sizeof(struct ieee80211_tx_latency_stat),
 				      GFP_ATOMIC);
+		if (!sta->tx_lat) {
+			rcu_read_unlock();
+			goto free_rate_ctrl;
+		}
+	}
 
 	/*
 	 * if Tx latency and bins are enabled and the previous allocation
@@ -392,12 +396,28 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 			sta->tx_lat[i].bins  = kcalloc(sta->tx_lat[i].bin_count,
 						       sizeof(u32),
 						       GFP_ATOMIC);
+			if (!sta->tx_lat[i].bins) {
+				rcu_read_unlock();
+				goto free_bins;
+			}
 		}
 
 	rcu_read_unlock();
 
 	sta_dbg(sdata, "Allocated STA %pM\n", sta->sta.addr);
+	goto out;
 
+free_bins:
+	while (i > 0)
+		kfree(sta->tx_lat[--i].bins);
+	kfree(sta->tx_lat);
+free_rate_ctrl:
+	if (sta->rate_ctrl)
+		rate_control_free_sta(sta);
+free_sta:
+	kfree(sta);
+	sta = NULL;
+out:
 	return sta;
 }
 
-- 
1.8.4.2

