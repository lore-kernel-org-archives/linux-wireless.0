Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:14438 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757121AbZCYMoa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2009 08:44:30 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 25 Mar 2009 05:44:29 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <stable@kernel.org>
Subject: [PATCH V3] mac80211: Fix bug in getting rx status for frames pending in reorder buffer
Date: Wed, 25 Mar 2009 18:10:18 +0530
Message-ID: <1237984818-7333-1-git-send-email-vasanth@atheros.com> (sfid-20090325_134442_839265_9F3DB0BA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently rx status for frames which are completed from reorder buffer
is taken from it's cb area which is not always right, cb is not holding
the rx status when driver uses mac80211's non-irq rx handler to pass it's
received frames. This results in dropping almost all frames from reorder 
buffer when security is enabled by doing double decryption (first in hw, 
second in sw because of wrong rx status). This patch copies rx status into 
cb area before the frame is put into reorder buffer. After this patch, 
there is a significant improvement in throughput with ath9k + WPA2(AES).

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
Cc: stable@kernel.org
---

 net/mac80211/rx.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 64ebe66..5fa7aed 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -29,6 +29,7 @@
 static u8 ieee80211_sta_manage_reorder_buf(struct ieee80211_hw *hw,
 					   struct tid_ampdu_rx *tid_agg_rx,
 					   struct sk_buff *skb,
+					   struct ieee80211_rx_status *status,
 					   u16 mpdu_seq_num,
 					   int bar_req);
 /*
@@ -1688,7 +1689,7 @@ ieee80211_rx_h_ctrl(struct ieee80211_rx_data *rx)
 		/* manage reordering buffer according to requested */
 		/* sequence number */
 		rcu_read_lock();
-		ieee80211_sta_manage_reorder_buf(hw, tid_agg_rx, NULL,
+		ieee80211_sta_manage_reorder_buf(hw, tid_agg_rx, NULL, NULL,
 						 start_seq_num, 1);
 		rcu_read_unlock();
 		return RX_DROP_UNUSABLE;
@@ -2293,6 +2294,7 @@ static inline u16 seq_sub(u16 sq1, u16 sq2)
 static u8 ieee80211_sta_manage_reorder_buf(struct ieee80211_hw *hw,
 					   struct tid_ampdu_rx *tid_agg_rx,
 					   struct sk_buff *skb,
+					   struct ieee80211_rx_status *rxstatus,
 					   u16 mpdu_seq_num,
 					   int bar_req)
 {
@@ -2374,6 +2376,8 @@ static u8 ieee80211_sta_manage_reorder_buf(struct ieee80211_hw *hw,
 
 	/* put the frame in the reordering buffer */
 	tid_agg_rx->reorder_buf[index] = skb;
+	memcpy(tid_agg_rx->reorder_buf[index]->cb, rxstatus,
+	       sizeof(*rxstatus));
 	tid_agg_rx->stored_mpdu_num++;
 	/* release the buffer until next missing frame */
 	index = seq_sub(tid_agg_rx->head_seq_num, tid_agg_rx->ssn)
@@ -2399,7 +2403,8 @@ static u8 ieee80211_sta_manage_reorder_buf(struct ieee80211_hw *hw,
 }
 
 static u8 ieee80211_rx_reorder_ampdu(struct ieee80211_local *local,
-				     struct sk_buff *skb)
+				     struct sk_buff *skb,
+				     struct ieee80211_rx_status *status)
 {
 	struct ieee80211_hw *hw = &local->hw;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
@@ -2448,7 +2453,7 @@ static u8 ieee80211_rx_reorder_ampdu(struct ieee80211_local *local,
 
 	/* according to mpdu sequence number deal with reordering buffer */
 	mpdu_seq_num = (sc & IEEE80211_SCTL_SEQ) >> 4;
-	ret = ieee80211_sta_manage_reorder_buf(hw, tid_agg_rx, skb,
+	ret = ieee80211_sta_manage_reorder_buf(hw, tid_agg_rx, skb, status,
 						mpdu_seq_num, 0);
  end_reorder:
 	return ret;
@@ -2512,7 +2517,7 @@ void __ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb,
 		return;
 	}
 
-	if (!ieee80211_rx_reorder_ampdu(local, skb))
+	if (!ieee80211_rx_reorder_ampdu(local, skb, status))
 		__ieee80211_rx_handle_packet(hw, skb, status, rate);
 
 	rcu_read_unlock();
-- 
1.5.5.1

