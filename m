Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:39709 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbaJRRN4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Oct 2014 13:13:56 -0400
Received: by mail-wi0-f181.google.com with SMTP id hi2so3391502wib.8
        for <linux-wireless@vger.kernel.org>; Sat, 18 Oct 2014 10:13:55 -0700 (PDT)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Karl Beldan <karl.beldan@rivierawaves.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	karl.beldan@gmail.com, Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH v3 3/4] mac80211: minstrel_ht: include type (cck/ht) in rates flag
Date: Sat, 18 Oct 2014 19:13:43 +0200
Message-Id: <1413652424-14345-4-git-send-email-karl.beldan@gmail.com> (sfid-20141018_191402_093789_78835045)
In-Reply-To: <1413652424-14345-1-git-send-email-karl.beldan@gmail.com>
References: <1413575459-29612-5-git-send-email-karl.beldan@gmail.com>
 <1413652424-14345-1-git-send-email-karl.beldan@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karl Beldan <karl.beldan@rivierawaves.com>

ATM, we grep cck rates idx with idx / MCS_GROUP_RATES ==
MINSTREL_CCK_GROUP.
Matching neither-cck-non-ht rates could be done by replacing '==' with
'>', however it would be less versatile or explicit.
This will allow to match VHT rates with IEEE80211_TX_RC_VHT_MCS.

Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
Cc: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/rc80211_minstrel_ht.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index a48eb76..e760d3d 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -51,6 +51,7 @@
 	[GROUP_IDX(_streams, _sgi, _ht40)] = {				\
 	.streams = _streams,						\
 	.flags =							\
+		IEEE80211_TX_RC_MCS |					\
 		(_sgi ? IEEE80211_TX_RC_SHORT_GI : 0) |			\
 		(_ht40 ? IEEE80211_TX_RC_40_MHZ_WIDTH : 0),		\
 	.duration = {							\
@@ -83,6 +84,7 @@
 #define CCK_GROUP					\
 	[MINSTREL_CCK_GROUP] = {			\
 		.streams = 0,				\
+		.flags = 0,				\
 		.duration = {				\
 			CCK_DURATION_LIST(false),	\
 			CCK_DURATION_LIST(true)		\
@@ -716,7 +718,7 @@ minstrel_ht_set_rate(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
 	const struct mcs_group *group = &minstrel_mcs_groups[index / MCS_GROUP_RATES];
 	struct minstrel_rate_stats *mr;
 	u8 idx;
-	u16 flags;
+	u16 flags = group->flags;
 
 	mr = minstrel_get_ratestats(mi, index);
 	if (!mr->retry_updated)
@@ -732,13 +734,10 @@ minstrel_ht_set_rate(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
 		ratetbl->rate[offset].count_rts = mr->retry_count_rtscts;
 	}
 
-	if (index / MCS_GROUP_RATES == MINSTREL_CCK_GROUP) {
+	if (index / MCS_GROUP_RATES == MINSTREL_CCK_GROUP)
 		idx = mp->cck_rates[index % ARRAY_SIZE(mp->cck_rates)];
-		flags = 0;
-	} else {
+	else
 		idx = index % MCS_GROUP_RATES + (group->streams - 1) * 8;
-		flags = IEEE80211_TX_RC_MCS | group->flags;
-	}
 
 	if (offset > 0) {
 		ratetbl->rate[offset].count = ratetbl->rate[offset].count_rts;
@@ -918,13 +917,12 @@ minstrel_ht_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 	if (sample_idx / MCS_GROUP_RATES == MINSTREL_CCK_GROUP) {
 		int idx = sample_idx % ARRAY_SIZE(mp->cck_rates);
 		rate->idx = mp->cck_rates[idx];
-		rate->flags = 0;
-		return;
+	} else {
+		rate->idx = sample_idx % MCS_GROUP_RATES +
+			    (sample_group->streams - 1) * 8;
 	}
 
-	rate->idx = sample_idx % MCS_GROUP_RATES +
-		    (sample_group->streams - 1) * 8;
-	rate->flags = IEEE80211_TX_RC_MCS | sample_group->flags;
+	rate->flags = sample_group->flags;
 }
 
 static void
@@ -1006,14 +1004,16 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 		mi->tx_flags |= IEEE80211_TX_CTL_LDPC;
 
 	for (i = 0; i < ARRAY_SIZE(mi->groups); i++) {
+		u32 gflags = minstrel_mcs_groups[i].flags;
+
 		mi->groups[i].supported = 0;
 		if (i == MINSTREL_CCK_GROUP) {
 			minstrel_ht_update_cck(mp, mi, sband, sta);
 			continue;
 		}
 
-		if (minstrel_mcs_groups[i].flags & IEEE80211_TX_RC_SHORT_GI) {
-			if (minstrel_mcs_groups[i].flags & IEEE80211_TX_RC_40_MHZ_WIDTH) {
+		if (gflags & IEEE80211_TX_RC_SHORT_GI) {
+			if (gflags & IEEE80211_TX_RC_40_MHZ_WIDTH) {
 				if (!(sta_cap & IEEE80211_HT_CAP_SGI_40))
 					continue;
 			} else {
@@ -1022,7 +1022,7 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 			}
 		}
 
-		if (minstrel_mcs_groups[i].flags & IEEE80211_TX_RC_40_MHZ_WIDTH &&
+		if (gflags & IEEE80211_TX_RC_40_MHZ_WIDTH &&
 		    sta->bandwidth < IEEE80211_STA_RX_BW_40)
 			continue;
 
-- 
2.0.1

