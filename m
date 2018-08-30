Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:51602 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727211AbeH3M5H (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Aug 2018 08:57:07 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: always account for A-MSDU header changes
Date: Thu, 30 Aug 2018 10:55:49 +0200
Message-Id: <20180830085549.21955-1-johannes@sipsolutions.net> (sfid-20180830_105604_216531_F0625A1D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In the error path of changing the SKB headroom of the second
A-MSDU subframe, we would not account for the already-changed
length of the first frame that just got converted to be in
A-MSDU format and thus is a bit longer now.

Fix this by doing the necessary accounting.

It would be possible to reorder the operations, but that would
make the code more complex (to calculate the necessary pad),
and the headroom expansion should not fail frequently enough
to make that worthwhile.

Fixes: 6e0456b54545 ("mac80211: add A-MSDU tx support")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 1aac5e3c7eee..6ca0865de945 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3239,7 +3239,7 @@ static bool ieee80211_amsdu_aggregate(struct ieee80211_sub_if_data *sdata,
 
 	if (!ieee80211_amsdu_realloc_pad(local, skb, sizeof(rfc1042_header) +
 						     2 + pad))
-		goto out;
+		goto out_recalc;
 
 	ret = true;
 	data = skb_push(skb, ETH_ALEN + 2);
@@ -3256,11 +3256,13 @@ static bool ieee80211_amsdu_aggregate(struct ieee80211_sub_if_data *sdata,
 	head->data_len += skb->len;
 	*frag_tail = skb;
 
-	flow->backlog += head->len - orig_len;
-	tin->backlog_bytes += head->len - orig_len;
-
-	fq_recalc_backlog(fq, tin, flow);
+out_recalc:
+	if (head->len != orig_len) {
+		flow->backlog += head->len - orig_len;
+		tin->backlog_bytes += head->len - orig_len;
 
+		fq_recalc_backlog(fq, tin, flow);
+	}
 out:
 	spin_unlock_bh(&fq->lock);
 
-- 
2.14.4
