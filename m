Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:59796 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756726Ab1CILKV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2011 06:10:21 -0500
Received: by pvg12 with SMTP id 12so63144pvg.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 Mar 2011 03:10:21 -0800 (PST)
From: Daniel Halperin <dhalperi@cs.washington.edu>
Content-Type: text/plain; charset=us-ascii
Subject: [PATCH try2] mac80211: update minstrel_ht sample rate when probe is set
Date: Wed, 9 Mar 2011 03:10:18 -0800
Message-Id: <97370256-1296-46A6-8B3C-1DD0C760C81A@cs.washington.edu>
To: linux-wireless <linux-wireless@vger.kernel.org>
Mime-Version: 1.0 (Apple Message framework v1082)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Waiting until the status is received can cause the same rate to be
probed multiple times consecutively.

Cc: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Daniel Halperin <dhalperi@cs.washington.edu>
---
 net/mac80211/rc80211_minstrel_ht.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 775cf15..bce14fb 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -415,10 +415,8 @@ minstrel_ht_tx_status(void *priv, struct ieee80211_supported_band *sband,
 		mi->sample_count--;
 	}
 
-	if (info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE) {
+	if (info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE)
 		mi->sample_packets += info->status.ampdu_len;
-		minstrel_next_sample_idx(mi);
-	}
 
 	for (i = 0; !last; i++) {
 		last = (i == IEEE80211_TX_MAX_RATES - 1) ||
@@ -551,13 +549,14 @@ minstrel_get_sample_rate(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 	sample_idx = sample_table[mg->column][mg->index];
 	mr = &mg->rates[sample_idx];
 	sample_idx += mi->sample_group * MCS_GROUP_RATES;
+	minstrel_next_sample_idx(mi);
 
 	/*
 	 * When not using MRR, do not sample if the probability is already
 	 * higher than 95% to avoid wasting airtime
 	 */
 	if (!mp->has_mrr && (mr->probability > MINSTREL_FRAC(95, 100)))
-		goto next;
+		return -1;
 
 	/*
 	 * Make sure that lower rates get sampled only occasionally,
@@ -566,17 +565,13 @@ minstrel_get_sample_rate(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 	if (minstrel_get_duration(sample_idx) >
 	    minstrel_get_duration(mi->max_tp_rate)) {
 		if (mr->sample_skipped < 20)
-			goto next;
+			return -1;
 
 		if (mi->sample_slow++ > 2)
-			goto next;
+			return -1;
 	}
 
 	return sample_idx;
-
-next:
-	minstrel_next_sample_idx(mi);
-	return -1;
 }
 
 static void
-- 
1.7.0.4


