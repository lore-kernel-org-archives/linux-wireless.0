Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59674 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370Ab1KNO2c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Nov 2011 09:28:32 -0500
Received: by fagn18 with SMTP id n18so3049954fag.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Nov 2011 06:28:31 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, nbd@openwrt.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH 3/3] mac80211: Get rid of search loop for rate group index
Date: Mon, 14 Nov 2011 15:28:20 +0100
Message-Id: <1321280900-24006-3-git-send-email-helmut.schaa@googlemail.com> (sfid-20111114_152835_280978_174F4F69)
In-Reply-To: <1321280900-24006-2-git-send-email-helmut.schaa@googlemail.com>
References: <1321280900-24006-1-git-send-email-helmut.schaa@googlemail.com>
 <1321280900-24006-2-git-send-email-helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Finding the group index for a specific rate is done by looping through
all groups and returning if the correct one is found. This code is
called for each tx'ed frame and thus it makes sense to reduce its
runtime.

Do this by calculating the group index by this formula based on the SGI
and HT40 flags as well as the stream number:

idx = (HT40 * 2 * MINSTREL_MAX_STREAMS) +
      (SGI * MINSTREL_MAX_STREAMS) +
      (streams - 1)

Hence, the groups are ordered by th HT40 flag first, then by the SGI
flag and afterwards by the number of used streams.

This should reduce the runtime of minstrel_ht_get_group_idx
considerable.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 net/mac80211/rc80211_minstrel_ht.c |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 3d76fd7..bb228e7 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -36,8 +36,17 @@
 /* Transmit duration for the raw data part of an average sized packet */
 #define MCS_DURATION(streams, sgi, bps) MCS_SYMBOL_TIME(sgi, MCS_NSYMS((streams) * (bps)))
 
+/*
+ * Define group sort order: HT40 -> SGI -> #streams
+ */
+#define GROUP_IDX(_streams, _sgi, _ht40)	\
+	MINSTREL_MAX_STREAMS * 2 * _ht40 +	\
+	MINSTREL_MAX_STREAMS * _sgi +		\
+	_streams - 1
+
 /* MCS rate information for an MCS group */
-#define MCS_GROUP(_streams, _sgi, _ht40) {				\
+#define MCS_GROUP(_streams, _sgi, _ht40)				\
+	[GROUP_IDX(_streams, _sgi, _ht40)] = {				\
 	.streams = _streams,						\
 	.flags =							\
 		(_sgi ? IEEE80211_TX_RC_SHORT_GI : 0) |			\
@@ -58,6 +67,9 @@
  * To enable sufficiently targeted rate sampling, MCS rates are divided into
  * groups, based on the number of streams and flags (HT40, SGI) that they
  * use.
+ *
+ * Sortorder has to be fixed for GROUP_IDX macro to be applicable:
+ * HT40 -> SGI -> #streams
  */
 const struct mcs_group minstrel_mcs_groups[] = {
 	MCS_GROUP(1, 0, 0),
@@ -102,21 +114,9 @@ minstrel_ewma(int old, int new, int weight)
 static int
 minstrel_ht_get_group_idx(struct ieee80211_tx_rate *rate)
 {
-	int streams = (rate->idx / MCS_GROUP_RATES) + 1;
-	u32 flags = IEEE80211_TX_RC_SHORT_GI | IEEE80211_TX_RC_40_MHZ_WIDTH;
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(minstrel_mcs_groups); i++) {
-		if (minstrel_mcs_groups[i].streams != streams)
-			continue;
-		if (minstrel_mcs_groups[i].flags != (rate->flags & flags))
-			continue;
-
-		return i;
-	}
-
-	WARN_ON(1);
-	return 0;
+	return GROUP_IDX((rate->idx / MCS_GROUP_RATES) + 1,
+			 !!(rate->flags & IEEE80211_TX_RC_SHORT_GI),
+			 !!(rate->flags & IEEE80211_TX_RC_40_MHZ_WIDTH));
 }
 
 static inline struct minstrel_rate_stats *
-- 
1.7.3.4

