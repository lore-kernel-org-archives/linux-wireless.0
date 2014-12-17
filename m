Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:45734
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750895AbaLQMii (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2014 07:38:38 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH v2 3.19] mac80211: minstrel: reduce size of struct minstrel_rate_stats
Date: Wed, 17 Dec 2014 13:38:34 +0100
Message-Id: <1418819914-9535-1-git-send-email-nbd@openwrt.org> (sfid-20141217_133841_601607_3B3D4597)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On minstrel_ht, the size of the per-sta struct is almost 18k, making it
an order-3 allocation.
A few fields inside the per-rate statistics are bigger than they need to
be. This patch reduces the size enough to cut down the per-sta struct to
about 13k (order-2 allocation).

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/rc80211_minstrel.c |  6 +++---
 net/mac80211/rc80211_minstrel.h | 15 ++++++++-------
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index d51f6b1..7c86a00 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -263,12 +263,12 @@ static inline unsigned int
 minstrel_get_retry_count(struct minstrel_rate *mr,
 			 struct ieee80211_tx_info *info)
 {
-	unsigned int retry = mr->adjusted_retry_count;
+	u8 retry = mr->adjusted_retry_count;
 
 	if (info->control.use_rts)
-		retry = max(2U, min(mr->stats.retry_count_rtscts, retry));
+		retry = max_t(u8, 2, min(mr->stats.retry_count_rtscts, retry));
 	else if (info->control.use_cts_prot)
-		retry = max(2U, min(mr->retry_count_cts, retry));
+		retry = max_t(u8, 2, min(mr->retry_count_cts, retry));
 	return retry;
 }
 
diff --git a/net/mac80211/rc80211_minstrel.h b/net/mac80211/rc80211_minstrel.h
index 97eca86..410efe6 100644
--- a/net/mac80211/rc80211_minstrel.h
+++ b/net/mac80211/rc80211_minstrel.h
@@ -33,8 +33,8 @@ minstrel_ewma(int old, int new, int weight)
 
 struct minstrel_rate_stats {
 	/* current / last sampling period attempts/success counters */
-	unsigned int attempts, last_attempts;
-	unsigned int success, last_success;
+	u16 attempts, last_attempts;
+	u16 success, last_success;
 
 	/* total attempts/success counters */
 	u64 att_hist, succ_hist;
@@ -46,8 +46,8 @@ struct minstrel_rate_stats {
 	unsigned int cur_prob, probability;
 
 	/* maximum retry counts */
-	unsigned int retry_count;
-	unsigned int retry_count_rtscts;
+	u8 retry_count;
+	u8 retry_count_rtscts;
 
 	u8 sample_skipped;
 	bool retry_updated;
@@ -55,14 +55,15 @@ struct minstrel_rate_stats {
 
 struct minstrel_rate {
 	int bitrate;
-	int rix;
+
+	s8 rix;
+	u8 retry_count_cts;
+	u8 adjusted_retry_count;
 
 	unsigned int perfect_tx_time;
 	unsigned int ack_time;
 
 	int sample_limit;
-	unsigned int retry_count_cts;
-	unsigned int adjusted_retry_count;
 
 	struct minstrel_rate_stats stats;
 };
-- 
2.1.2

