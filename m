Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:40607 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758582Ab3CDSsg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 13:48:36 -0500
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	nbd@openwrt.org, thomas@net.t-labs.tu-berlin.de
Subject: [PATCH v3 4/7] mac80211: extend minstrel's rate sampling to avoid unsampled rates
Date: Mon,  4 Mar 2013 19:48:21 +0100
Message-Id: <1362422905-78079-5-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20130304_194848_907718_6C7D5142)
In-Reply-To: <1362422905-78079-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
References: <1362422905-78079-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Minstrel's decision which rate should be directly sampled within the
1st mrr stage is limited to such rates faster than the current max
throughput rate. All rates below the current max. throughput rate
are indirectly sampled via the 2nd mrr stage.
This approach leads to deprecated per rate statistics and therfore
a deprecated mrr chain setup.

This patch uses the sampling approach from minstrel_ht. A counter is
added to sum all indirect sample attempts per rate. After 20 indirect
sampling attempts the rate is directly sampled within the 1st mrr stage.
Therefore more up-to-date statistics for all rates are maintained and
used to setup the mrr chain.

Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
---
 net/mac80211/rc80211_minstrel.c | 13 +++++++++----
 net/mac80211/rc80211_minstrel.h |  1 +
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index 152bb0e..aa59f29 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -85,7 +85,8 @@ minstrel_update_stats(struct minstrel_priv *mp, struct minstrel_sta_info *mi)
 		if (!usecs)
 			usecs = 1000000;
 
-		if (mr->attempts) {
+		if (unlikely(mr->attempts > 0)) {
+			mr->sample_skipped = 0;
 			mr->cur_prob = MINSTREL_FRAC(mr->success, mr->attempts);
 			mr->succ_hist += mr->success;
 			mr->att_hist += mr->attempts;
@@ -93,7 +94,8 @@ minstrel_update_stats(struct minstrel_priv *mp, struct minstrel_sta_info *mi)
 							mr->cur_prob,
 							EWMA_LEVEL);
 			mr->cur_tp = mr->probability * (1000000 / usecs);
-		}
+		} else
+			mr->sample_skipped++;
 
 		mr->last_success = mr->success;
 		mr->last_attempts = mr->attempts;
@@ -282,9 +284,12 @@ minstrel_get_rate(void *priv, struct ieee80211_sta *sta,
 		rate_sampling = true;
 
 		/* Decide if direct ( 1st mrr stage) or indirect (2nd mrr stage)
-		 * rate sampling method should be used */
+		 * rate sampling method should be used.
+		 * Respect such rates that are not sampled for 20 interations.
+		 */
 		if (mrr_capable &&
-		    msr->perfect_tx_time > mi->r[ndx].perfect_tx_time)
+		    msr->perfect_tx_time > mi->r[ndx].perfect_tx_time &&
+		    msr->sample_skipped < 20)
 				indirect_rate_sampling = true;
 
 		if (!indirect_rate_sampling) {
diff --git a/net/mac80211/rc80211_minstrel.h b/net/mac80211/rc80211_minstrel.h
index 5fb5cb8..200b7e3 100644
--- a/net/mac80211/rc80211_minstrel.h
+++ b/net/mac80211/rc80211_minstrel.h
@@ -43,6 +43,7 @@ struct minstrel_rate {
 	u32 attempts;
 	u32 last_attempts;
 	u32 last_success;
+	u8 sample_skipped;
 
 	/* parts per thousand */
 	u32 cur_prob;
-- 
1.8.1.1

