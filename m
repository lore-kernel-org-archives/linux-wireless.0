Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:38995 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726383AbeH2BAl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 21:00:41 -0400
Received: by mail-wm0-f68.google.com with SMTP id q8-v6so3380083wmq.4
        for <linux-wireless@vger.kernel.org>; Tue, 28 Aug 2018 14:07:14 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, nbd@nbd.name
Subject: [PATCH] mac80211: do not aggregate frames if max_frags is set to one
Date: Tue, 28 Aug 2018 23:07:07 +0200
Message-Id: <d67c1a6772d46f449dbb74d61ddf4d80dee7a350.1535489707.git.lorenzo.bianconi@redhat.com> (sfid-20180828_230722_944932_72B9EE71)
In-Reply-To: <cover.1535489707.git.lorenzo.bianconi@redhat.com>
References: <cover.1535489707.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do not try to aggregate packets in a A-MSDU frame if max_tx_fragments
or max_amsdu_subframes is set to 1. Moreover take into account
tail padding added on the first frame into flow backlog if
ieee80211_amsdu_realloc_pad routine on the second frame fails.
This patch fixes a kernel freeze that occasionally occurs running
iperf tests using mt76 driver

Fixes: 6e0456b54545 ("mac80211: add A-MSDU tx support")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 net/mac80211/tx.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 093108077edc..a5701573c83b 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3185,11 +3185,11 @@ static bool ieee80211_amsdu_aggregate(struct ieee80211_sub_if_data *sdata,
 	u8 max_subframes = sta->sta.max_amsdu_subframes;
 	int max_frags = local->hw.max_tx_fragments;
 	int max_amsdu_len = sta->sta.max_amsdu_len;
+	int n = 1, nfrags, delta;
 	__be16 len;
 	void *data;
 	bool ret = false;
 	unsigned int orig_len;
-	int n = 1, nfrags;
 
 	if (!ieee80211_hw_check(&local->hw, TX_AMSDU))
 		return false;
@@ -3222,9 +3222,6 @@ static bool ieee80211_amsdu_aggregate(struct ieee80211_sub_if_data *sdata,
 	if (skb->len + head->len > max_amsdu_len)
 		goto out;
 
-	if (!ieee80211_amsdu_prepare_head(sdata, fast_tx, head))
-		goto out;
-
 	nfrags = 1 + skb_shinfo(skb)->nr_frags;
 	nfrags += 1 + skb_shinfo(head)->nr_frags;
 	frag_tail = &skb_shinfo(head)->frag_list;
@@ -3240,10 +3237,15 @@ static bool ieee80211_amsdu_aggregate(struct ieee80211_sub_if_data *sdata,
 	if (max_frags && nfrags > max_frags)
 		goto out;
 
-	if (!ieee80211_amsdu_realloc_pad(local, skb, sizeof(rfc1042_header) + 2,
-					 &subframe_len))
+	if (!ieee80211_amsdu_prepare_head(sdata, fast_tx, head))
 		goto out;
 
+	if (!ieee80211_amsdu_realloc_pad(local, skb, sizeof(rfc1042_header) + 2,
+					 &subframe_len)) {
+		delta = head->len - orig_len;
+		goto update_backlog;
+	}
+
 	ret = true;
 	data = skb_push(skb, ETH_ALEN + 2);
 	memmove(data, data + ETH_ALEN + 2, 2 * ETH_ALEN);
@@ -3256,11 +3258,14 @@ static bool ieee80211_amsdu_aggregate(struct ieee80211_sub_if_data *sdata,
 	head->len += skb->len;
 	head->data_len += skb->len;
 	*frag_tail = skb;
+	delta = head->len - orig_len;
 
-	flow->backlog += head->len - orig_len;
-	tin->backlog_bytes += head->len - orig_len;
-
-	fq_recalc_backlog(fq, tin, flow);
+update_backlog:
+	if (delta > 0) {
+		flow->backlog += delta;
+		tin->backlog_bytes += delta;
+		fq_recalc_backlog(fq, tin, flow);
+	}
 
 out:
 	spin_unlock_bh(&fq->lock);
-- 
2.17.1
