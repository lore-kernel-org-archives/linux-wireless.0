Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:38799 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752930AbcJKJ2l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Oct 2016 05:28:41 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, toke@toke.dk
Subject: [PATCH] mac80211: fix sequence number allocation regression
Date: Tue, 11 Oct 2016 11:28:31 +0200
Message-Id: <20161011092831.85565-1-nbd@nbd.name> (sfid-20161011_112859_873333_292D0DA2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The recent commit that moved around TX handlers dropped the sequence
number allocation at the end of ieee80211_tx_dequeue and calls
ieee80211_tx_h_sequence instead (for the non-fast-xmit case).
However, it did not change the fast-xmit sequence allocation condition
in ieee80211_xmit_fast_finish, which skipped seqno alloc if intermediate
tx queues are being used.

Drop the now obsolete condition.

Fixes: bb42f2d13ffc ("mac80211: Move reorder-sensitive TX handlers to after TXQ dequeue")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/tx.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index dc60784..8ff81fd 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3212,7 +3212,6 @@ static void ieee80211_xmit_fast_finish(struct ieee80211_sub_if_data *sdata,
 				       struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_hdr *hdr = (void *)skb->data;
 	u8 tid = IEEE80211_NUM_TIDS;
 
@@ -3224,8 +3223,7 @@ static void ieee80211_xmit_fast_finish(struct ieee80211_sub_if_data *sdata,
 	if (hdr->frame_control & cpu_to_le16(IEEE80211_STYPE_QOS_DATA)) {
 		tid = skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
 		*ieee80211_get_qos_ctl(hdr) = tid;
-		if (!ieee80211_get_txq(local, &sdata->vif, &sta->sta, skb))
-			hdr->seq_ctrl = ieee80211_tx_next_seq(sta, tid);
+		hdr->seq_ctrl = ieee80211_tx_next_seq(sta, tid);
 	} else {
 		info->flags |= IEEE80211_TX_CTL_ASSIGN_SEQ;
 		hdr->seq_ctrl = cpu_to_le16(sdata->sequence_number);
-- 
2.10.1
