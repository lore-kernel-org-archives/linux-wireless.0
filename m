Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:52466 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755300Ab3KLObO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Nov 2013 09:31:14 -0500
Received: by mail-wg0-f45.google.com with SMTP id a1so2179377wgh.24
        for <linux-wireless@vger.kernel.org>; Tue, 12 Nov 2013 06:31:12 -0800 (PST)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@gmail.com>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: [RFC 2/2] fixup! mac80211: minstrel_ht: add basic support for VHT rates <= 80MHz
Date: Tue, 12 Nov 2013 15:30:25 +0100
Message-Id: <1384266625-22431-2-git-send-email-karl.beldan@gmail.com> (sfid-20131112_153117_833750_B1CD9826)
In-Reply-To: <1384266625-22431-1-git-send-email-karl.beldan@gmail.com>
References: <1384266625-22431-1-git-send-email-karl.beldan@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karl Beldan <karl.beldan@rivierawaves.com>

Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
---
 net/mac80211/rc80211_minstrel_ht.c | 34 ++++++++++++++--------------------
 1 file changed, 14 insertions(+), 20 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index dd81516..c3aa1a9 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -52,6 +52,7 @@
 	[GROUP_IDX(_streams, _sgi, _ht40)] = {				\
 	.streams = _streams,						\
 	.flags =							\
+		IEEE80211_TX_RC_MCS |					\
 		(_sgi ? IEEE80211_TX_RC_SHORT_GI : 0) |			\
 		(_ht40 ? IEEE80211_TX_RC_40_MHZ_WIDTH : 0),		\
 	.duration = {							\
@@ -79,6 +80,7 @@
 	[VHT_GROUP_IDX(_streams, _sgi, _bw)] = {				\
 	.streams = _streams,							\
 	.flags =								\
+		IEEE80211_TX_RC_VHT_MCS |					\
 		(_sgi ? IEEE80211_TX_RC_SHORT_GI : 0) |				\
 		(_bw == BW_80 ? IEEE80211_TX_RC_80_MHZ_WIDTH :			\
 		 _bw == BW_40 ? IEEE80211_TX_RC_40_MHZ_WIDTH : 0),		\
@@ -115,6 +117,7 @@
 #define CCK_GROUP					\
 	[MINSTREL_CCK_GROUP] = {			\
 		.streams = 0,				\
+		.flags = 0,				\
 		.duration = {				\
 			CCK_DURATION_LIST(false),	\
 			CCK_DURATION_LIST(true)		\
@@ -721,7 +724,7 @@ minstrel_ht_set_rate(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
 	const struct mcs_group *group = &minstrel_mcs_groups[index / MCS_GROUP_RATES];
 	struct minstrel_rate_stats *mr;
 	u8 idx;
-	u16 flags;
+	u16 flags = group->flags;
 
 	mr = minstrel_get_ratestats(mi, index);
 	if (!mr->retry_updated)
@@ -737,17 +740,13 @@ minstrel_ht_set_rate(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
 		ratetbl->rate[offset].count_rts = mr->retry_count_rtscts;
 	}
 
-	if (index / MCS_GROUP_RATES == MINSTREL_CCK_GROUP) {
+	if (index / MCS_GROUP_RATES == MINSTREL_CCK_GROUP)
 		idx = mp->cck_rates[index % ARRAY_SIZE(mp->cck_rates)];
-		flags = 0;
-	} else if (index / MCS_GROUP_RATES >= MINSTREL_VHT_GROUP_0) {
+	else if (flags & IEEE80211_TX_RC_VHT_MCS)
 		idx = ((group->streams - 1) << 4) |
 		      ((index % MCS_GROUP_RATES) & ~0xF);
-		flags = IEEE80211_TX_RC_VHT_MCS | group->flags;
-	} else {
+	else
 		idx = index % MCS_GROUP_RATES + (group->streams - 1) * 8;
-		flags = IEEE80211_TX_RC_MCS | group->flags;
-	}
 
 	if (offset > 0) {
 		ratetbl->rate[offset].count = ratetbl->rate[offset].count_rts;
@@ -924,18 +923,15 @@ minstrel_ht_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 	if (sample_idx / MCS_GROUP_RATES == MINSTREL_CCK_GROUP) {
 		int idx = sample_idx % ARRAY_SIZE(mp->cck_rates);
 		rate->idx = mp->cck_rates[idx];
-		rate->flags = 0;
-		return;
-	} else if (sample_idx / MCS_GROUP_RATES >= MINSTREL_VHT_GROUP_0) {
-		rate->flags = IEEE80211_TX_RC_VHT_MCS | sample_group->flags;
+	} else if (sample_group->flags & IEEE80211_TX_RC_VHT_MCS) {
 		ieee80211_rate_set_vht(rate, sample_idx % MCS_GROUP_RATES,
 				       sample_group->streams);
-		return;
+	} else {
+		rate->idx = sample_idx % MCS_GROUP_RATES +
+			(sample_group->streams - 1) * 8;
 	}
 
-	rate->idx = sample_idx % MCS_GROUP_RATES +
-		    (sample_group->streams - 1) * 8;
-	rate->flags = IEEE80211_TX_RC_MCS | sample_group->flags;
+	rate->flags = sample_group->flags;
 }
 
 static void
@@ -1033,10 +1029,8 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 			continue;
 		}
 
-#ifdef CONFIG_MAC80211_RC_MINSTREL_VHT /* FIXME otherwise MINSTREL_VHT_GROUP_0 is 0 */
-		if (vht_only && i < MINSTREL_VHT_GROUP_0)
+		if (vht_only && !(gflags & IEEE80211_TX_RC_VHT_MCS))
 			continue;
-#endif
 
 		if (gflags & IEEE80211_TX_RC_SHORT_GI) {
 			if (gflags & IEEE80211_TX_RC_40_MHZ_WIDTH) {
@@ -1057,7 +1051,7 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 		    minstrel_mcs_groups[i].streams > 1)
 			continue;
 
-		if (i >= MINSTREL_VHT_GROUP_0) {
+		if (gflags & IEEE80211_TX_RC_VHT_MCS) {
 			int bw;
 			if (!vht_cap->vht_supported)
 				continue;
-- 
1.8.2

