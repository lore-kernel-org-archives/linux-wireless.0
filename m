Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:63019 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbaJTNqY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 09:46:24 -0400
Received: by mail-wi0-f182.google.com with SMTP id n3so6351086wiv.15
        for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2014 06:46:22 -0700 (PDT)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Karl Beldan <karl.beldan@rivierawaves.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	karl.beldan@gmail.com, Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH v5 1/4] mac80211: minstrel_ht: Increase the range of handled rate indexes
Date: Mon, 20 Oct 2014 15:45:59 +0200
Message-Id: <1413812762-6605-2-git-send-email-karl.beldan@gmail.com> (sfid-20141020_154627_051243_68B073D3)
In-Reply-To: <1413812762-6605-1-git-send-email-karl.beldan@gmail.com>
References: <1413812762-6605-1-git-send-email-karl.beldan@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karl Beldan <karl.beldan@rivierawaves.com>

Since 5935839ad735 ("mac80211: improve minstrel_ht rate sorting by
throughput & probability"), the rate indexes are manipulated via u8's
and hence allow for a maximum of 256 mcs_group entries in
minstrel_mcs_groups.

ATM, minstrel_ht advertizes support up to 3HTSS@40MHz, consuming:
8(MCS_GROUP_RATES) * (3(SS)*2(GI)*2(BW)+1(CCK)), i.e. 104 entries.

Support for 3VHTSS@80MHz will require:
10(MCS_GROUP_RATES) * (3(SS)*2(GI)*2(BW)+1(CCK)) +
10(MCS_GROUP_RATES) * (3(SS)*2(GI)*3(BW)), i.e. 130 + 180 entries.

This change moves from u8s to u16s where necessary.

Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
Cc: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/rc80211_minstrel_ht.c | 16 ++++++++--------
 net/mac80211/rc80211_minstrel_ht.h |  8 ++++----
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 17ef54a..ccec718 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -240,8 +240,8 @@ minstrel_ht_calc_tp(struct minstrel_ht_sta *mi, int group, int rate)
  * MCS groups, CCK rates do not provide aggregation and are therefore at last.
  */
 static void
-minstrel_ht_sort_best_tp_rates(struct minstrel_ht_sta *mi, u8 index,
-			       u8 *tp_list)
+minstrel_ht_sort_best_tp_rates(struct minstrel_ht_sta *mi, u16 index,
+			       u16 *tp_list)
 {
 	int cur_group, cur_idx, cur_thr, cur_prob;
 	int tmp_group, tmp_idx, tmp_thr, tmp_prob;
@@ -278,7 +278,7 @@ minstrel_ht_sort_best_tp_rates(struct minstrel_ht_sta *mi, u8 index,
  * Find and set the topmost probability rate per sta and per group
  */
 static void
-minstrel_ht_set_best_prob_rate(struct minstrel_ht_sta *mi, u8 index)
+minstrel_ht_set_best_prob_rate(struct minstrel_ht_sta *mi, u16 index)
 {
 	struct minstrel_mcs_group_data *mg;
 	struct minstrel_rate_stats *mr;
@@ -321,8 +321,8 @@ minstrel_ht_set_best_prob_rate(struct minstrel_ht_sta *mi, u8 index)
  */
 static void
 minstrel_ht_assign_best_tp_rates(struct minstrel_ht_sta *mi,
-				 u8 tmp_mcs_tp_rate[MAX_THR_RATES],
-				 u8 tmp_cck_tp_rate[MAX_THR_RATES])
+				 u16 tmp_mcs_tp_rate[MAX_THR_RATES],
+				 u16 tmp_cck_tp_rate[MAX_THR_RATES])
 {
 	unsigned int tmp_group, tmp_idx, tmp_cck_tp, tmp_mcs_tp;
 	int i;
@@ -386,8 +386,8 @@ minstrel_ht_update_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 	struct minstrel_mcs_group_data *mg;
 	struct minstrel_rate_stats *mr;
 	int group, i, j;
-	u8 tmp_mcs_tp_rate[MAX_THR_RATES], tmp_group_tp_rate[MAX_THR_RATES];
-	u8 tmp_cck_tp_rate[MAX_THR_RATES], index;
+	u16 tmp_mcs_tp_rate[MAX_THR_RATES], tmp_group_tp_rate[MAX_THR_RATES];
+	u16 tmp_cck_tp_rate[MAX_THR_RATES], index;
 
 	if (mi->ampdu_packets > 0) {
 		mi->avg_ampdu_len = minstrel_ewma(mi->avg_ampdu_len,
@@ -517,7 +517,7 @@ minstrel_next_sample_idx(struct minstrel_ht_sta *mi)
 }
 
 static void
-minstrel_downgrade_rate(struct minstrel_ht_sta *mi, u8 *idx, bool primary)
+minstrel_downgrade_rate(struct minstrel_ht_sta *mi, u16 *idx, bool primary)
 {
 	int group, orig_group;
 
diff --git a/net/mac80211/rc80211_minstrel_ht.h b/net/mac80211/rc80211_minstrel_ht.h
index 01570e0..8b54e89 100644
--- a/net/mac80211/rc80211_minstrel_ht.h
+++ b/net/mac80211/rc80211_minstrel_ht.h
@@ -34,8 +34,8 @@ struct minstrel_mcs_group_data {
 	u8 supported;
 
 	/* sorted rate set within a MCS group*/
-	u8 max_group_tp_rate[MAX_THR_RATES];
-	u8 max_group_prob_rate;
+	u16 max_group_tp_rate[MAX_THR_RATES];
+	u16 max_group_prob_rate;
 
 	/* MCS rate statistics */
 	struct minstrel_rate_stats rates[MCS_GROUP_RATES];
@@ -52,8 +52,8 @@ struct minstrel_ht_sta {
 	unsigned int avg_ampdu_len;
 
 	/* overall sorted rate set */
-	u8 max_tp_rate[MAX_THR_RATES];
-	u8 max_prob_rate;
+	u16 max_tp_rate[MAX_THR_RATES];
+	u16 max_prob_rate;
 
 	/* time of last status update */
 	unsigned long stats_update;
-- 
2.0.1

