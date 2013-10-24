Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:38736 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754937Ab3JXNxZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Oct 2013 09:53:25 -0400
Received: by mail-we0-f182.google.com with SMTP id t61so2408187wes.27
        for <linux-wireless@vger.kernel.org>; Thu, 24 Oct 2013 06:53:23 -0700 (PDT)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@gmail.com>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: [PATCH] mac80211: do not compute offset from ssn in Rx AMPDU reordering buffer
Date: Thu, 24 Oct 2013 15:53:32 +0200
Message-Id: <1382622812-18253-1-git-send-email-karl.beldan@gmail.com> (sfid-20131024_155328_531966_2621FD07)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karl Beldan <karl.beldan@rivierawaves.com>

ATM, frames with SN sn are mapped into the sta reordering buffer
sta->ampdu_mlme->tid_rx->reorder_buf at index
ieee80211_sn_sub(sn, tid_rx->ssn) % tid_rx->buf_size.
This offset calculation is useless, and this change replaces the index
with sn % tid_rx->buf_size.

Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
---
 net/mac80211/rx.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 23f49e8..3cec926 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -729,9 +729,7 @@ static void ieee80211_release_reorder_frames(struct ieee80211_sub_if_data *sdata
 	lockdep_assert_held(&tid_agg_rx->reorder_lock);
 
 	while (ieee80211_sn_less(tid_agg_rx->head_seq_num, head_seq_num)) {
-		index = ieee80211_sn_sub(tid_agg_rx->head_seq_num,
-					 tid_agg_rx->ssn) %
-							tid_agg_rx->buf_size;
+		index = tid_agg_rx->head_seq_num % tid_agg_rx->buf_size;
 		ieee80211_release_reorder_frame(sdata, tid_agg_rx, index,
 						frames);
 	}
@@ -757,8 +755,7 @@ static void ieee80211_sta_reorder_release(struct ieee80211_sub_if_data *sdata,
 	lockdep_assert_held(&tid_agg_rx->reorder_lock);
 
 	/* release the buffer until next missing frame */
-	index = ieee80211_sn_sub(tid_agg_rx->head_seq_num,
-				 tid_agg_rx->ssn) % tid_agg_rx->buf_size;
+	index = tid_agg_rx->head_seq_num % tid_agg_rx->buf_size;
 	if (!tid_agg_rx->reorder_buf[index] &&
 	    tid_agg_rx->stored_mpdu_num) {
 		/*
@@ -793,15 +790,11 @@ static void ieee80211_sta_reorder_release(struct ieee80211_sub_if_data *sdata,
 	} else while (tid_agg_rx->reorder_buf[index]) {
 		ieee80211_release_reorder_frame(sdata, tid_agg_rx, index,
 						frames);
-		index =	ieee80211_sn_sub(tid_agg_rx->head_seq_num,
-					 tid_agg_rx->ssn) %
-							tid_agg_rx->buf_size;
+		index =	tid_agg_rx->head_seq_num % tid_agg_rx->buf_size;
 	}
 
 	if (tid_agg_rx->stored_mpdu_num) {
-		j = index = ieee80211_sn_sub(tid_agg_rx->head_seq_num,
-					     tid_agg_rx->ssn) %
-							tid_agg_rx->buf_size;
+		j = index = tid_agg_rx->head_seq_num % tid_agg_rx->buf_size;
 
 		for (; j != (index - 1) % tid_agg_rx->buf_size;
 		     j = (j + 1) % tid_agg_rx->buf_size) {
@@ -861,8 +854,7 @@ static bool ieee80211_sta_manage_reorder_buf(struct ieee80211_sub_if_data *sdata
 
 	/* Now the new frame is always in the range of the reordering buffer */
 
-	index = ieee80211_sn_sub(mpdu_seq_num,
-				 tid_agg_rx->ssn) % tid_agg_rx->buf_size;
+	index = mpdu_seq_num % tid_agg_rx->buf_size;
 
 	/* check if we already stored this frame */
 	if (tid_agg_rx->reorder_buf[index]) {
-- 
1.8.2

