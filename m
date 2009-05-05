Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:54556 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753821AbZEERfx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2009 13:35:53 -0400
Message-Id: <20090505173546.293873806@atheros.com>
References: <20090505173512.349795688@atheros.com>
Date: Tue, 05 May 2009 20:35:13 +0300
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCH 1/3] mac80211: Use a shared function to release frames from RX reorder buf
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No need to duplicate the same code in two places (and that would be
three after the followup patch).

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 net/mac80211/rx.c |   70 +++++++++++++++++++++++-------------------------------
 1 file changed, 31 insertions(+), 39 deletions(-)

--- wireless-testing.orig/net/mac80211/rx.c	2009-04-29 17:10:10.000000000 +0300
+++ wireless-testing/net/mac80211/rx.c	2009-05-05 20:26:33.000000000 +0300
@@ -2284,6 +2284,34 @@ static inline u16 seq_sub(u16 sq1, u16 s
 }
 
 
+static void ieee80211_release_reorder_frame(struct ieee80211_hw *hw,
+					    struct tid_ampdu_rx *tid_agg_rx,
+					    int index)
+{
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_rate *rate;
+	struct ieee80211_rx_status status;
+
+	if (!tid_agg_rx->reorder_buf[index])
+		goto no_frame;
+
+	/* release the reordered frames to stack */
+	memcpy(&status, tid_agg_rx->reorder_buf[index]->cb, sizeof(status));
+	sband = hw->wiphy->bands[status.band];
+	if (status.flag & RX_FLAG_HT)
+		rate = sband->bitrates; /* TODO: HT rates */
+	else
+		rate = &sband->bitrates[status.rate_idx];
+	__ieee80211_rx_handle_packet(hw, tid_agg_rx->reorder_buf[index],
+				     &status, rate);
+	tid_agg_rx->stored_mpdu_num--;
+	tid_agg_rx->reorder_buf[index] = NULL;
+
+no_frame:
+	tid_agg_rx->head_seq_num = seq_inc(tid_agg_rx->head_seq_num);
+}
+
+
 /*
  * As it function blongs to Rx path it must be called with
  * the proper rcu_read_lock protection for its flow.
@@ -2295,12 +2323,8 @@ static u8 ieee80211_sta_manage_reorder_b
 					   u16 mpdu_seq_num,
 					   int bar_req)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
-	struct ieee80211_rx_status status;
 	u16 head_seq_num, buf_size;
 	int index;
-	struct ieee80211_supported_band *sband;
-	struct ieee80211_rate *rate;
 
 	buf_size = tid_agg_rx->buf_size;
 	head_seq_num = tid_agg_rx->head_seq_num;
@@ -2325,28 +2349,8 @@ static u8 ieee80211_sta_manage_reorder_b
 			index = seq_sub(tid_agg_rx->head_seq_num,
 				tid_agg_rx->ssn)
 				% tid_agg_rx->buf_size;
-
-			if (tid_agg_rx->reorder_buf[index]) {
-				/* release the reordered frames to stack */
-				memcpy(&status,
-					tid_agg_rx->reorder_buf[index]->cb,
-					sizeof(status));
-				sband = local->hw.wiphy->bands[status.band];
-				if (status.flag & RX_FLAG_HT) {
-					/* TODO: HT rates */
-					rate = sband->bitrates;
-				} else {
-					rate = &sband->bitrates
-						[status.rate_idx];
-				}
-				__ieee80211_rx_handle_packet(hw,
-					tid_agg_rx->reorder_buf[index],
-					&status, rate);
-				tid_agg_rx->stored_mpdu_num--;
-				tid_agg_rx->reorder_buf[index] = NULL;
-			}
-			tid_agg_rx->head_seq_num =
-				seq_inc(tid_agg_rx->head_seq_num);
+			ieee80211_release_reorder_frame(hw, tid_agg_rx,
+							index);
 		}
 		if (bar_req)
 			return 1;
@@ -2380,19 +2384,7 @@ static u8 ieee80211_sta_manage_reorder_b
 	index = seq_sub(tid_agg_rx->head_seq_num, tid_agg_rx->ssn)
 						% tid_agg_rx->buf_size;
 	while (tid_agg_rx->reorder_buf[index]) {
-		/* release the reordered frame back to stack */
-		memcpy(&status, tid_agg_rx->reorder_buf[index]->cb,
-			sizeof(status));
-		sband = local->hw.wiphy->bands[status.band];
-		if (status.flag & RX_FLAG_HT)
-			rate = sband->bitrates; /* TODO: HT rates */
-		else
-			rate = &sband->bitrates[status.rate_idx];
-		__ieee80211_rx_handle_packet(hw, tid_agg_rx->reorder_buf[index],
-					     &status, rate);
-		tid_agg_rx->stored_mpdu_num--;
-		tid_agg_rx->reorder_buf[index] = NULL;
-		tid_agg_rx->head_seq_num = seq_inc(tid_agg_rx->head_seq_num);
+		ieee80211_release_reorder_frame(hw, tid_agg_rx, index);
 		index =	seq_sub(tid_agg_rx->head_seq_num,
 			tid_agg_rx->ssn) % tid_agg_rx->buf_size;
 	}

-- 

-- 
Jouni Malinen                                            PGP id EFC895FA
