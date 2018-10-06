Return-Path: <SRS0=pQzZ=MS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE4F4C67871
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 17:35:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 636672147D
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 17:35:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="i1w9oYaI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 636672147D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nbd.name
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727994AbeJGAja (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 6 Oct 2018 20:39:30 -0400
Received: from nbd.name ([46.4.11.11]:35790 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727791AbeJGAjX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 6 Oct 2018 20:39:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=mtofDXVALpoBrcVl3IfWqOdsuiJzYVQn68cn2clqj08=; b=i1w9oYaIyY6C8Olb0+QRdMoNc5
        v04Bneb9K2q4xIzCOW8qX4vsEZLra43dEYmMMSPVfpkDikDYDGZSBqP/0dELsmRLQGWV7EhFeGVCd
        Lt4mepmD07Isri75wl8pLMjc+fgOn74RlSZvVpxj5wiHTzcDN+pGffB0CNrMSpL1SxpY=;
Received: by maeck.local (Postfix, from userid 501)
        id 28D033E6EAF1; Sat,  6 Oct 2018 19:35:07 +0200 (CEST)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net
Subject: [PATCH 4/9] mac80211: minstrel: reduce minstrel_mcs_groups size
Date:   Sat,  6 Oct 2018 19:35:02 +0200
Message-Id: <20181006173507.7316-4-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20181006173507.7316-1-nbd@nbd.name>
References: <20181006173507.7316-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

By storing a shift value for all duration values of a group, we can
reduce precision by a neglegible amount to make it fit into a u16 value.
This improves cache footprint and reduces size:

Before:
   text    data     bss     dec     hex filename
  10024     116       0   10140    279c rc80211_minstrel_ht.o

After:
   text    data     bss     dec     hex filename
   9368     116       0    9484    250c rc80211_minstrel_ht.o

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/rc80211_minstrel_ht.c         | 153 +++++++++++----------
 net/mac80211/rc80211_minstrel_ht.h         |   7 +-
 net/mac80211/rc80211_minstrel_ht_debugfs.c |  11 +-
 3 files changed, 93 insertions(+), 78 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 0aec00990d1e..38e17ed20d41 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -52,22 +52,23 @@
 	_streams - 1
 
 /* MCS rate information for an MCS group */
-#define MCS_GROUP(_streams, _sgi, _ht40)				\
+#define MCS_GROUP(_streams, _sgi, _ht40, _s)				\
 	[GROUP_IDX(_streams, _sgi, _ht40)] = {				\
 	.streams = _streams,						\
+	.shift = _s,							\
 	.flags =							\
 		IEEE80211_TX_RC_MCS |					\
 		(_sgi ? IEEE80211_TX_RC_SHORT_GI : 0) |			\
 		(_ht40 ? IEEE80211_TX_RC_40_MHZ_WIDTH : 0),		\
 	.duration = {							\
-		MCS_DURATION(_streams, _sgi, _ht40 ? 54 : 26),		\
-		MCS_DURATION(_streams, _sgi, _ht40 ? 108 : 52),		\
-		MCS_DURATION(_streams, _sgi, _ht40 ? 162 : 78),		\
-		MCS_DURATION(_streams, _sgi, _ht40 ? 216 : 104),	\
-		MCS_DURATION(_streams, _sgi, _ht40 ? 324 : 156),	\
-		MCS_DURATION(_streams, _sgi, _ht40 ? 432 : 208),	\
-		MCS_DURATION(_streams, _sgi, _ht40 ? 486 : 234),	\
-		MCS_DURATION(_streams, _sgi, _ht40 ? 540 : 260)		\
+		MCS_DURATION(_streams, _sgi, _ht40 ? 54 : 26) >> _s,	\
+		MCS_DURATION(_streams, _sgi, _ht40 ? 108 : 52) >> _s,	\
+		MCS_DURATION(_streams, _sgi, _ht40 ? 162 : 78) >> _s,	\
+		MCS_DURATION(_streams, _sgi, _ht40 ? 216 : 104) >> _s,	\
+		MCS_DURATION(_streams, _sgi, _ht40 ? 324 : 156) >> _s,	\
+		MCS_DURATION(_streams, _sgi, _ht40 ? 432 : 208) >> _s,	\
+		MCS_DURATION(_streams, _sgi, _ht40 ? 486 : 234) >> _s,	\
+		MCS_DURATION(_streams, _sgi, _ht40 ? 540 : 260) >> _s	\
 	}								\
 }
 
@@ -80,9 +81,10 @@
 #define BW2VBPS(_bw, r3, r2, r1)					\
 	(_bw == BW_80 ? r3 : _bw == BW_40 ? r2 : r1)
 
-#define VHT_GROUP(_streams, _sgi, _bw)					\
+#define VHT_GROUP(_streams, _sgi, _bw, _s)				\
 	[VHT_GROUP_IDX(_streams, _sgi, _bw)] = {			\
 	.streams = _streams,						\
+	.shift = _s,							\
 	.flags =							\
 		IEEE80211_TX_RC_VHT_MCS |				\
 		(_sgi ? IEEE80211_TX_RC_SHORT_GI : 0) |			\
@@ -90,25 +92,25 @@
 		 _bw == BW_40 ? IEEE80211_TX_RC_40_MHZ_WIDTH : 0),	\
 	.duration = {							\
 		MCS_DURATION(_streams, _sgi,				\
-			     BW2VBPS(_bw,  117,  54,  26)),		\
+			     BW2VBPS(_bw,  117,  54,  26)) >> _s,	\
 		MCS_DURATION(_streams, _sgi,				\
-			     BW2VBPS(_bw,  234, 108,  52)),		\
+			     BW2VBPS(_bw,  234, 108,  52)) >> _s,	\
 		MCS_DURATION(_streams, _sgi,				\
-			     BW2VBPS(_bw,  351, 162,  78)),		\
+			     BW2VBPS(_bw,  351, 162,  78)) >> _s,	\
 		MCS_DURATION(_streams, _sgi,				\
-			     BW2VBPS(_bw,  468, 216, 104)),		\
+			     BW2VBPS(_bw,  468, 216, 104)) >> _s,	\
 		MCS_DURATION(_streams, _sgi,				\
-			     BW2VBPS(_bw,  702, 324, 156)),		\
+			     BW2VBPS(_bw,  702, 324, 156)) >> _s,	\
 		MCS_DURATION(_streams, _sgi,				\
-			     BW2VBPS(_bw,  936, 432, 208)),		\
+			     BW2VBPS(_bw,  936, 432, 208)) >> _s,	\
 		MCS_DURATION(_streams, _sgi,				\
-			     BW2VBPS(_bw, 1053, 486, 234)),		\
+			     BW2VBPS(_bw, 1053, 486, 234)) >> _s,	\
 		MCS_DURATION(_streams, _sgi,				\
-			     BW2VBPS(_bw, 1170, 540, 260)),		\
+			     BW2VBPS(_bw, 1170, 540, 260)) >> _s,	\
 		MCS_DURATION(_streams, _sgi,				\
-			     BW2VBPS(_bw, 1404, 648, 312)),		\
+			     BW2VBPS(_bw, 1404, 648, 312)) >> _s,	\
 		MCS_DURATION(_streams, _sgi,				\
-			     BW2VBPS(_bw, 1560, 720, 346))		\
+			     BW2VBPS(_bw, 1560, 720, 346)) >> _s	\
 	}								\
 }
 
@@ -121,19 +123,20 @@
 	(CCK_DURATION((_bitrate > 10 ? 20 : 10), false, 60) +	\
 	 CCK_DURATION(_bitrate, _short, AVG_PKT_SIZE))
 
-#define CCK_DURATION_LIST(_short)			\
-	CCK_ACK_DURATION(10, _short),			\
-	CCK_ACK_DURATION(20, _short),			\
-	CCK_ACK_DURATION(55, _short),			\
-	CCK_ACK_DURATION(110, _short)
+#define CCK_DURATION_LIST(_short, _s)			\
+	CCK_ACK_DURATION(10, _short) >> _s,		\
+	CCK_ACK_DURATION(20, _short) >> _s,		\
+	CCK_ACK_DURATION(55, _short) >> _s,		\
+	CCK_ACK_DURATION(110, _short) >> _s
 
-#define CCK_GROUP					\
+#define CCK_GROUP(_s)					\
 	[MINSTREL_CCK_GROUP] = {			\
 		.streams = 0,				\
 		.flags = 0,				\
+		.shift = _s,				\
 		.duration = {				\
-			CCK_DURATION_LIST(false),	\
-			CCK_DURATION_LIST(true)		\
+			CCK_DURATION_LIST(false, _s),	\
+			CCK_DURATION_LIST(true, _s)	\
 		}					\
 	}
 
@@ -151,47 +154,47 @@ MODULE_PARM_DESC(minstrel_vht_only,
  * BW -> SGI -> #streams
  */
 const struct mcs_group minstrel_mcs_groups[] = {
-	MCS_GROUP(1, 0, BW_20),
-	MCS_GROUP(2, 0, BW_20),
-	MCS_GROUP(3, 0, BW_20),
+	MCS_GROUP(1, 0, BW_20, 5),
+	MCS_GROUP(2, 0, BW_20, 4),
+	MCS_GROUP(3, 0, BW_20, 4),
 
-	MCS_GROUP(1, 1, BW_20),
-	MCS_GROUP(2, 1, BW_20),
-	MCS_GROUP(3, 1, BW_20),
+	MCS_GROUP(1, 1, BW_20, 5),
+	MCS_GROUP(2, 1, BW_20, 4),
+	MCS_GROUP(3, 1, BW_20, 4),
 
-	MCS_GROUP(1, 0, BW_40),
-	MCS_GROUP(2, 0, BW_40),
-	MCS_GROUP(3, 0, BW_40),
+	MCS_GROUP(1, 0, BW_40, 4),
+	MCS_GROUP(2, 0, BW_40, 4),
+	MCS_GROUP(3, 0, BW_40, 4),
 
-	MCS_GROUP(1, 1, BW_40),
-	MCS_GROUP(2, 1, BW_40),
-	MCS_GROUP(3, 1, BW_40),
+	MCS_GROUP(1, 1, BW_40, 4),
+	MCS_GROUP(2, 1, BW_40, 4),
+	MCS_GROUP(3, 1, BW_40, 4),
 
-	CCK_GROUP,
+	CCK_GROUP(8),
 
-	VHT_GROUP(1, 0, BW_20),
-	VHT_GROUP(2, 0, BW_20),
-	VHT_GROUP(3, 0, BW_20),
+	VHT_GROUP(1, 0, BW_20, 5),
+	VHT_GROUP(2, 0, BW_20, 4),
+	VHT_GROUP(3, 0, BW_20, 4),
 
-	VHT_GROUP(1, 1, BW_20),
-	VHT_GROUP(2, 1, BW_20),
-	VHT_GROUP(3, 1, BW_20),
+	VHT_GROUP(1, 1, BW_20, 5),
+	VHT_GROUP(2, 1, BW_20, 4),
+	VHT_GROUP(3, 1, BW_20, 4),
 
-	VHT_GROUP(1, 0, BW_40),
-	VHT_GROUP(2, 0, BW_40),
-	VHT_GROUP(3, 0, BW_40),
+	VHT_GROUP(1, 0, BW_40, 4),
+	VHT_GROUP(2, 0, BW_40, 4),
+	VHT_GROUP(3, 0, BW_40, 4),
 
-	VHT_GROUP(1, 1, BW_40),
-	VHT_GROUP(2, 1, BW_40),
-	VHT_GROUP(3, 1, BW_40),
+	VHT_GROUP(1, 1, BW_40, 4),
+	VHT_GROUP(2, 1, BW_40, 4),
+	VHT_GROUP(3, 1, BW_40, 4),
 
-	VHT_GROUP(1, 0, BW_80),
-	VHT_GROUP(2, 0, BW_80),
-	VHT_GROUP(3, 0, BW_80),
+	VHT_GROUP(1, 0, BW_80, 4),
+	VHT_GROUP(2, 0, BW_80, 4),
+	VHT_GROUP(3, 0, BW_80, 4),
 
-	VHT_GROUP(1, 1, BW_80),
-	VHT_GROUP(2, 1, BW_80),
-	VHT_GROUP(3, 1, BW_80),
+	VHT_GROUP(1, 1, BW_80, 4),
+	VHT_GROUP(2, 1, BW_80, 4),
+	VHT_GROUP(3, 1, BW_80, 4),
 };
 
 static u8 sample_table[SAMPLE_COLUMNS][MCS_GROUP_RATES] __read_mostly;
@@ -307,7 +310,8 @@ minstrel_ht_get_tp_avg(struct minstrel_ht_sta *mi, int group, int rate,
 	if (group != MINSTREL_CCK_GROUP)
 		nsecs = 1000 * mi->overhead / MINSTREL_TRUNC(mi->avg_ampdu_len);
 
-	nsecs += minstrel_mcs_groups[group].duration[rate];
+	nsecs += minstrel_mcs_groups[group].duration[rate] <<
+		 minstrel_mcs_groups[group].shift;
 
 	/*
 	 * For the throughput calculation, limit the probability value to 90% to
@@ -755,12 +759,19 @@ minstrel_ht_tx_status(void *priv, struct ieee80211_supported_band *sband,
 		minstrel_ht_update_rates(mp, mi);
 }
 
+static inline int
+minstrel_get_duration(int index)
+{
+	const struct mcs_group *group = &minstrel_mcs_groups[index / MCS_GROUP_RATES];
+	unsigned int duration = group->duration[index % MCS_GROUP_RATES];
+	return duration << group->shift;
+}
+
 static void
 minstrel_calc_retransmit(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
                          int index)
 {
 	struct minstrel_rate_stats *mrs;
-	const struct mcs_group *group;
 	unsigned int tx_time, tx_time_rtscts, tx_time_data;
 	unsigned int cw = mp->cw_min;
 	unsigned int ctime = 0;
@@ -779,8 +790,7 @@ minstrel_calc_retransmit(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
 	mrs->retry_count_rtscts = 2;
 	mrs->retry_updated = true;
 
-	group = &minstrel_mcs_groups[index / MCS_GROUP_RATES];
-	tx_time_data = group->duration[index % MCS_GROUP_RATES] * ampdu_len / 1000;
+	tx_time_data = minstrel_get_duration(index) * ampdu_len / 1000;
 
 	/* Contention time for first 2 tries */
 	ctime = (t_slot * cw) >> 1;
@@ -874,20 +884,24 @@ minstrel_ht_get_max_amsdu_len(struct minstrel_ht_sta *mi)
 	int group = mi->max_prob_rate / MCS_GROUP_RATES;
 	const struct mcs_group *g = &minstrel_mcs_groups[group];
 	int rate = mi->max_prob_rate % MCS_GROUP_RATES;
+	unsigned int duration;
 
 	/* Disable A-MSDU if max_prob_rate is bad */
 	if (mi->groups[group].rates[rate].prob_ewma < MINSTREL_FRAC(50, 100))
 		return 1;
 
+	duration = g->duration[rate];
+	duration <<= g->shift;
+
 	/* If the rate is slower than single-stream MCS1, make A-MSDU limit small */
-	if (g->duration[rate] > MCS_DURATION(1, 0, 52))
+	if (duration > MCS_DURATION(1, 0, 52))
 		return 500;
 
 	/*
 	 * If the rate is slower than single-stream MCS4, limit A-MSDU to usual
 	 * data packet size
 	 */
-	if (g->duration[rate] > MCS_DURATION(1, 0, 104))
+	if (duration > MCS_DURATION(1, 0, 104))
 		return 1600;
 
 	/*
@@ -895,7 +909,7 @@ minstrel_ht_get_max_amsdu_len(struct minstrel_ht_sta *mi)
 	 * rate success probability is less than 75%, limit A-MSDU to twice the usual
 	 * data packet size
 	 */
-	if (g->duration[rate] > MCS_DURATION(1, 0, 260) ||
+	if (duration > MCS_DURATION(1, 0, 260) ||
 	    (minstrel_ht_get_prob_ewma(mi, mi->max_tp_rate[0]) <
 	     MINSTREL_FRAC(75, 100)))
 		return 3200;
@@ -942,13 +956,6 @@ minstrel_ht_update_rates(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 	rate_control_set_rates(mp->hw, mi->sta, rates);
 }
 
-static inline int
-minstrel_get_duration(int index)
-{
-	const struct mcs_group *group = &minstrel_mcs_groups[index / MCS_GROUP_RATES];
-	return group->duration[index % MCS_GROUP_RATES];
-}
-
 static int
 minstrel_get_sample_rate(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 {
diff --git a/net/mac80211/rc80211_minstrel_ht.h b/net/mac80211/rc80211_minstrel_ht.h
index ad17df10a947..26b7a3244b47 100644
--- a/net/mac80211/rc80211_minstrel_ht.h
+++ b/net/mac80211/rc80211_minstrel_ht.h
@@ -33,9 +33,10 @@
 #define MCS_GROUP_RATES		10
 
 struct mcs_group {
-	u32 flags;
-	unsigned int streams;
-	unsigned int duration[MCS_GROUP_RATES];
+	u16 flags;
+	u8 streams;
+	u8 shift;
+	u16 duration[MCS_GROUP_RATES];
 };
 
 extern const struct mcs_group minstrel_mcs_groups[];
diff --git a/net/mac80211/rc80211_minstrel_ht_debugfs.c b/net/mac80211/rc80211_minstrel_ht_debugfs.c
index 5db0f4228875..8065da2cf0f1 100644
--- a/net/mac80211/rc80211_minstrel_ht_debugfs.c
+++ b/net/mac80211/rc80211_minstrel_ht_debugfs.c
@@ -58,6 +58,7 @@ minstrel_ht_stats_dump(struct minstrel_ht_sta *mi, int i, char *p)
 		static const int bitrates[4] = { 10, 20, 55, 110 };
 		int idx = i * MCS_GROUP_RATES + j;
 		unsigned int prob_ewmsd;
+		unsigned int duration;
 
 		if (!(mi->supported[i] & BIT(j)))
 			continue;
@@ -95,7 +96,9 @@ minstrel_ht_stats_dump(struct minstrel_ht_sta *mi, int i, char *p)
 		p += sprintf(p, "  %3u  ", idx);
 
 		/* tx_time[rate(i)] in usec */
-		tx_time = DIV_ROUND_CLOSEST(mg->duration[j], 1000);
+		duration = mg->duration[j];
+		duration <<= mg->shift;
+		tx_time = DIV_ROUND_CLOSEST(duration, 1000);
 		p += sprintf(p, "%6u  ", tx_time);
 
 		tp_max = minstrel_ht_get_tp_avg(mi, i, j, MINSTREL_FRAC(100, 100));
@@ -204,6 +207,7 @@ minstrel_ht_stats_csv_dump(struct minstrel_ht_sta *mi, int i, char *p)
 		static const int bitrates[4] = { 10, 20, 55, 110 };
 		int idx = i * MCS_GROUP_RATES + j;
 		unsigned int prob_ewmsd;
+		unsigned int duration;
 
 		if (!(mi->supported[i] & BIT(j)))
 			continue;
@@ -238,7 +242,10 @@ minstrel_ht_stats_csv_dump(struct minstrel_ht_sta *mi, int i, char *p)
 		}
 
 		p += sprintf(p, "%u,", idx);
-		tx_time = DIV_ROUND_CLOSEST(mg->duration[j], 1000);
+
+		duration = mg->duration[j];
+		duration <<= mg->shift;
+		tx_time = DIV_ROUND_CLOSEST(duration, 1000);
 		p += sprintf(p, "%u,", tx_time);
 
 		tp_max = minstrel_ht_get_tp_avg(mi, i, j, MINSTREL_FRAC(100, 100));
-- 
2.17.0

