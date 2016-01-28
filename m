Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20530 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755477AbcA1OTa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2016 09:19:30 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/3] mac80211: change ieee80211_rx_reorder_ready() arguments
Date: Thu, 28 Jan 2016 16:19:24 +0200
Message-Id: <1453990766-2065-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160128_152050_872632_9F5706B9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Clean up ieee80211_rx_reorder_ready() callers by passing the RX
TID struct and the index, instead of the frames list. This will
make it more extensible as well.

While at it, move the inline to rx.c as it's only used there.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h | 14 --------------
 net/mac80211/rx.c          | 33 ++++++++++++++++++++++++---------
 2 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index a29f61d..5ea9514 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1837,20 +1837,6 @@ static inline void ieee802_11_parse_elems(const u8 *start, size_t len,
 	ieee802_11_parse_elems_crc(start, len, action, elems, 0, 0);
 }
 
-static inline bool ieee80211_rx_reorder_ready(struct sk_buff_head *frames)
-{
-	struct sk_buff *tail = skb_peek_tail(frames);
-	struct ieee80211_rx_status *status;
-
-	if (!tail)
-		return false;
-
-	status = IEEE80211_SKB_RXCB(tail);
-	if (status->flag & RX_FLAG_AMSDU_MORE)
-		return false;
-
-	return true;
-}
 
 extern const int ieee802_1d_to_ac[8];
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index ae993ed..a607518 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -4,6 +4,7 @@
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2007-2010	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
+ * Copyright(c) 2015 - 2016 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -798,6 +799,23 @@ static ieee80211_rx_result ieee80211_rx_mesh_check(struct ieee80211_rx_data *rx)
 	return RX_CONTINUE;
 }
 
+static inline bool ieee80211_rx_reorder_ready(struct tid_ampdu_rx *tid_agg_rx,
+					      int index)
+{
+	struct sk_buff_head *frames = &tid_agg_rx->reorder_buf[index];
+	struct sk_buff *tail = skb_peek_tail(frames);
+	struct ieee80211_rx_status *status;
+
+	if (!tail)
+		return false;
+
+	status = IEEE80211_SKB_RXCB(tail);
+	if (status->flag & RX_FLAG_AMSDU_MORE)
+		return false;
+
+	return true;
+}
+
 static void ieee80211_release_reorder_frame(struct ieee80211_sub_if_data *sdata,
 					    struct tid_ampdu_rx *tid_agg_rx,
 					    int index,
@@ -812,7 +830,7 @@ static void ieee80211_release_reorder_frame(struct ieee80211_sub_if_data *sdata,
 	if (skb_queue_empty(skb_list))
 		goto no_frame;
 
-	if (!ieee80211_rx_reorder_ready(skb_list)) {
+	if (!ieee80211_rx_reorder_ready(tid_agg_rx, index)) {
 		__skb_queue_purge(skb_list);
 		goto no_frame;
 	}
@@ -866,7 +884,7 @@ static void ieee80211_sta_reorder_release(struct ieee80211_sub_if_data *sdata,
 
 	/* release the buffer until next missing frame */
 	index = tid_agg_rx->head_seq_num % tid_agg_rx->buf_size;
-	if (!ieee80211_rx_reorder_ready(&tid_agg_rx->reorder_buf[index]) &&
+	if (!ieee80211_rx_reorder_ready(tid_agg_rx, index) &&
 	    tid_agg_rx->stored_mpdu_num) {
 		/*
 		 * No buffers ready to be released, but check whether any
@@ -875,8 +893,7 @@ static void ieee80211_sta_reorder_release(struct ieee80211_sub_if_data *sdata,
 		int skipped = 1;
 		for (j = (index + 1) % tid_agg_rx->buf_size; j != index;
 		     j = (j + 1) % tid_agg_rx->buf_size) {
-			if (!ieee80211_rx_reorder_ready(
-					&tid_agg_rx->reorder_buf[j])) {
+			if (!ieee80211_rx_reorder_ready(tid_agg_rx, j)) {
 				skipped++;
 				continue;
 			}
@@ -903,8 +920,7 @@ static void ieee80211_sta_reorder_release(struct ieee80211_sub_if_data *sdata,
 				 skipped) & IEEE80211_SN_MASK;
 			skipped = 0;
 		}
-	} else while (ieee80211_rx_reorder_ready(
-				&tid_agg_rx->reorder_buf[index])) {
+	} else while (ieee80211_rx_reorder_ready(tid_agg_rx, index)) {
 		ieee80211_release_reorder_frame(sdata, tid_agg_rx, index,
 						frames);
 		index =	tid_agg_rx->head_seq_num % tid_agg_rx->buf_size;
@@ -915,8 +931,7 @@ static void ieee80211_sta_reorder_release(struct ieee80211_sub_if_data *sdata,
 
 		for (; j != (index - 1) % tid_agg_rx->buf_size;
 		     j = (j + 1) % tid_agg_rx->buf_size) {
-			if (ieee80211_rx_reorder_ready(
-					&tid_agg_rx->reorder_buf[j]))
+			if (ieee80211_rx_reorder_ready(tid_agg_rx, j))
 				break;
 		}
 
@@ -987,7 +1002,7 @@ static bool ieee80211_sta_manage_reorder_buf(struct ieee80211_sub_if_data *sdata
 	index = mpdu_seq_num % tid_agg_rx->buf_size;
 
 	/* check if we already stored this frame */
-	if (ieee80211_rx_reorder_ready(&tid_agg_rx->reorder_buf[index])) {
+	if (ieee80211_rx_reorder_ready(tid_agg_rx, index)) {
 		dev_kfree_skb(skb);
 		goto out;
 	}
-- 
2.5.0

