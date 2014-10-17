Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:44907 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008AbaJQTvN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Oct 2014 15:51:13 -0400
Received: by mail-wi0-f169.google.com with SMTP id h11so4924189wiw.0
        for <linux-wireless@vger.kernel.org>; Fri, 17 Oct 2014 12:51:11 -0700 (PDT)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Karl Beldan <karl.beldan@rivierawaves.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	karl.beldan@gmail.com, Felix Fietkau <nbd@openwrt.org>
Subject: [RESEND PATCH v2 2/4] mac80211: minstrel_ht: macros adjustments for future VHT_GROUPs
Date: Fri, 17 Oct 2014 21:50:57 +0200
Message-Id: <1413575459-29612-3-git-send-email-karl.beldan@gmail.com> (sfid-20141017_215123_127718_92ABF6B2)
In-Reply-To: <1413575459-29612-1-git-send-email-karl.beldan@gmail.com>
References: <1413570896-27740-5-git-send-email-karl.beldan@gmail.com>
 <1413575459-29612-1-git-send-email-karl.beldan@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karl Beldan <karl.beldan@rivierawaves.com>

No functional change.

Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
Cc: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/rc80211_minstrel_ht.c         | 51 +++++++++++++++---------------
 net/mac80211/rc80211_minstrel_ht.h         | 14 ++++++--
 net/mac80211/rc80211_minstrel_ht_debugfs.c | 10 +++---
 3 files changed, 41 insertions(+), 34 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index ccec718..a48eb76 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -34,12 +34,16 @@
 /* Transmit duration for the raw data part of an average sized packet */
 #define MCS_DURATION(streams, sgi, bps) MCS_SYMBOL_TIME(sgi, MCS_NSYMS((streams) * (bps)))
 
+#define BW_20			0
+#define BW_40			1
+
 /*
  * Define group sort order: HT40 -> SGI -> #streams
  */
 #define GROUP_IDX(_streams, _sgi, _ht40)	\
+	MINSTREL_HT_GROUP_0 +			\
 	MINSTREL_MAX_STREAMS * 2 * _ht40 +	\
-	MINSTREL_MAX_STREAMS * _sgi +		\
+	MINSTREL_MAX_STREAMS * _sgi +	\
 	_streams - 1
 
 /* MCS rate information for an MCS group */
@@ -76,13 +80,13 @@
 	CCK_ACK_DURATION(55, _short),			\
 	CCK_ACK_DURATION(110, _short)
 
-#define CCK_GROUP						\
-	[MINSTREL_MAX_STREAMS * MINSTREL_STREAM_GROUPS] = {	\
-		.streams = 0,					\
-		.duration = {					\
-			CCK_DURATION_LIST(false),		\
-			CCK_DURATION_LIST(true)			\
-		}						\
+#define CCK_GROUP					\
+	[MINSTREL_CCK_GROUP] = {			\
+		.streams = 0,				\
+		.duration = {				\
+			CCK_DURATION_LIST(false),	\
+			CCK_DURATION_LIST(true)		\
+		}					\
 	}
 
 /*
@@ -91,38 +95,36 @@
  * use.
  *
  * Sortorder has to be fixed for GROUP_IDX macro to be applicable:
- * HT40 -> SGI -> #streams
+ * BW -> SGI -> #streams
  */
 const struct mcs_group minstrel_mcs_groups[] = {
-	MCS_GROUP(1, 0, 0),
-	MCS_GROUP(2, 0, 0),
+	MCS_GROUP(1, 0, BW_20),
+	MCS_GROUP(2, 0, BW_20),
 #if MINSTREL_MAX_STREAMS >= 3
-	MCS_GROUP(3, 0, 0),
+	MCS_GROUP(3, 0, BW_20),
 #endif
 
-	MCS_GROUP(1, 1, 0),
-	MCS_GROUP(2, 1, 0),
+	MCS_GROUP(1, 1, BW_20),
+	MCS_GROUP(2, 1, BW_20),
 #if MINSTREL_MAX_STREAMS >= 3
-	MCS_GROUP(3, 1, 0),
+	MCS_GROUP(3, 1, BW_20),
 #endif
 
-	MCS_GROUP(1, 0, 1),
-	MCS_GROUP(2, 0, 1),
+	MCS_GROUP(1, 0, BW_40),
+	MCS_GROUP(2, 0, BW_40),
 #if MINSTREL_MAX_STREAMS >= 3
-	MCS_GROUP(3, 0, 1),
+	MCS_GROUP(3, 0, BW_40),
 #endif
 
-	MCS_GROUP(1, 1, 1),
-	MCS_GROUP(2, 1, 1),
+	MCS_GROUP(1, 1, BW_40),
+	MCS_GROUP(2, 1, BW_40),
 #if MINSTREL_MAX_STREAMS >= 3
-	MCS_GROUP(3, 1, 1),
+	MCS_GROUP(3, 1, BW_40),
 #endif
 
-	/* must be last */
 	CCK_GROUP
 };
 
-#define MINSTREL_CCK_GROUP	(ARRAY_SIZE(minstrel_mcs_groups) - 1)
 
 static u8 sample_table[SAMPLE_COLUMNS][MCS_GROUP_RATES] __read_mostly;
 
@@ -971,8 +973,7 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 	if (!sta->ht_cap.ht_supported)
 		goto use_legacy;
 
-	BUILD_BUG_ON(ARRAY_SIZE(minstrel_mcs_groups) !=
-		MINSTREL_MAX_STREAMS * MINSTREL_STREAM_GROUPS + 1);
+	BUILD_BUG_ON(ARRAY_SIZE(minstrel_mcs_groups) != MINSTREL_GROUPS_NB);
 
 	msp->is_ht = true;
 	memset(mi, 0, sizeof(*mi));
diff --git a/net/mac80211/rc80211_minstrel_ht.h b/net/mac80211/rc80211_minstrel_ht.h
index 8b54e89..7b46592 100644
--- a/net/mac80211/rc80211_minstrel_ht.h
+++ b/net/mac80211/rc80211_minstrel_ht.h
@@ -13,8 +13,16 @@
  * The number of streams can be changed to 2 to reduce code
  * size and memory footprint.
  */
-#define MINSTREL_MAX_STREAMS	3
-#define MINSTREL_STREAM_GROUPS	4
+#define MINSTREL_MAX_STREAMS		3
+#define MINSTREL_HT_STREAM_GROUPS	4 /* BW(=2) * SGI(=2) */
+
+#define MINSTREL_HT_GROUPS_NB	(MINSTREL_MAX_STREAMS * MINSTREL_HT_STREAM_GROUPS)
+#define MINSTREL_CCK_GROUPS_NB	1
+#define MINSTREL_GROUPS_NB	(MINSTREL_HT_GROUPS_NB +	\
+				 MINSTREL_CCK_GROUPS_NB)
+
+#define MINSTREL_HT_GROUP_0	0
+#define MINSTREL_CCK_GROUP	(MINSTREL_HT_GROUP_0 + MINSTREL_HT_GROUPS_NB)
 
 #define MCS_GROUP_RATES	8
 
@@ -80,7 +88,7 @@ struct minstrel_ht_sta {
 	u8 cck_supported_short;
 
 	/* MCS rate group info and statistics */
-	struct minstrel_mcs_group_data groups[MINSTREL_MAX_STREAMS * MINSTREL_STREAM_GROUPS + 1];
+	struct minstrel_mcs_group_data groups[MINSTREL_GROUPS_NB];
 };
 
 struct minstrel_ht_sta_priv {
diff --git a/net/mac80211/rc80211_minstrel_ht_debugfs.c b/net/mac80211/rc80211_minstrel_ht_debugfs.c
index b51b4ec..64a7984 100644
--- a/net/mac80211/rc80211_minstrel_ht_debugfs.c
+++ b/net/mac80211/rc80211_minstrel_ht_debugfs.c
@@ -18,7 +18,6 @@
 static char *
 minstrel_ht_stats_dump(struct minstrel_ht_sta *mi, int i, char *p)
 {
-	unsigned int max_mcs = MINSTREL_MAX_STREAMS * MINSTREL_STREAM_GROUPS;
 	const struct mcs_group *mg;
 	unsigned int j, tp, prob, eprob;
 	char htmode = '2';
@@ -41,7 +40,7 @@ minstrel_ht_stats_dump(struct minstrel_ht_sta *mi, int i, char *p)
 		if (!(mi->groups[i].supported & BIT(j)))
 			continue;
 
-		if (i == max_mcs)
+		if (i == MINSTREL_CCK_GROUP)
 			p += sprintf(p, "CCK/%cP   ", j < 4 ? 'L' : 'S');
 		else
 			p += sprintf(p, "HT%c0/%cGI ", htmode, gimode);
@@ -52,7 +51,7 @@ minstrel_ht_stats_dump(struct minstrel_ht_sta *mi, int i, char *p)
 		*(p++) = (idx == mi->max_tp_rate[3]) ? 'D' : ' ';
 		*(p++) = (idx == mi->max_prob_rate) ? 'P' : ' ';
 
-		if (i == max_mcs) {
+		if (i == MINSTREL_CCK_GROUP) {
 			int r = bitrates[j % 4];
 			p += sprintf(p, " %2u.%1uM", r / 10, r % 10);
 		} else {
@@ -85,7 +84,6 @@ minstrel_ht_stats_open(struct inode *inode, struct file *file)
 	struct minstrel_ht_sta *mi = &msp->ht;
 	struct minstrel_debugfs_info *ms;
 	unsigned int i;
-	unsigned int max_mcs = MINSTREL_MAX_STREAMS * MINSTREL_STREAM_GROUPS;
 	char *p;
 	int ret;
 
@@ -106,8 +104,8 @@ minstrel_ht_stats_open(struct inode *inode, struct file *file)
 			"ret  *ok(*cum)        ok(      cum)\n");
 
 
-	p = minstrel_ht_stats_dump(mi, max_mcs, p);
-	for (i = 0; i < max_mcs; i++)
+	p = minstrel_ht_stats_dump(mi, MINSTREL_CCK_GROUP, p);
+	for (i = 0; i < MINSTREL_CCK_GROUP; i++)
 		p = minstrel_ht_stats_dump(mi, i, p);
 
 	p += sprintf(p, "\nTotal packet count::    ideal %d      "
-- 
2.0.1

