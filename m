Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:36290 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbaI2AjF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Sep 2014 20:39:05 -0400
Received: by mail-we0-f174.google.com with SMTP id w62so11599893wes.5
        for <linux-wireless@vger.kernel.org>; Sun, 28 Sep 2014 17:39:03 -0700 (PDT)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@gmail.com>,
	Karl Beldan <karl.beldan@rivierawaves.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH] mac80211: minstrel_ht: add basic support for VHT rates <= 80MHz@NSS2
Date: Mon, 29 Sep 2014 02:38:44 +0200
Message-Id: <1411951124-24490-1-git-send-email-karl.beldan@gmail.com> (sfid-20140929_023908_905601_B5D07635)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karl Beldan <karl.beldan@rivierawaves.com>

When the new CONFIG_MAC80211_RC_MINSTREL_VHT is not set, there is no
behavioral change including in sampling and MCS_GROUP_RATES remains 8.
When it is, MCS_GROUP_RATES is 10 and we restrict to VHT rates for stats
readability (though it is possible to use both HT and VHT (unset
vht_only)).
---
 net/mac80211/Kconfig                       |   7 +
 net/mac80211/rc80211_minstrel_ht.c         | 263 +++++++++++++++++++++++------
 net/mac80211/rc80211_minstrel_ht.h         |  33 +++-
 net/mac80211/rc80211_minstrel_ht_debugfs.c |  30 ++--
 4 files changed, 261 insertions(+), 72 deletions(-)

diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index aeb6a48..39095a9 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -33,6 +33,13 @@ config MAC80211_RC_MINSTREL_HT
 	---help---
 	  This option enables the 'minstrel_ht' TX rate control algorithm
 
+config MAC80211_RC_MINSTREL_VHT
+	bool "Minstrel 802.11vht support" if EXPERT
+	depends on MAC80211_RC_MINSTREL_HT
+	default n
+	---help---
+	  This option enables vht in the 'minstrel_ht' TX rate control algorithm
+
 choice
 	prompt "Default rate control algorithm"
 	depends on MAC80211_HAS_RC
diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 17ef54a..41522c7 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -34,12 +34,17 @@
 /* Transmit duration for the raw data part of an average sized packet */
 #define MCS_DURATION(streams, sgi, bps) MCS_SYMBOL_TIME(sgi, MCS_NSYMS((streams) * (bps)))
 
+#define BW_20			0
+#define BW_40			1
+#define BW_80			2
+
 /*
  * Define group sort order: HT40 -> SGI -> #streams
  */
 #define GROUP_IDX(_streams, _sgi, _ht40)	\
-	MINSTREL_MAX_STREAMS * 2 * _ht40 +	\
-	MINSTREL_MAX_STREAMS * _sgi +		\
+	MINSTREL_HT_GROUP_0 +			\
+	MINSTREL_HT_MAX_STREAMS * 2 * _ht40 +	\
+	MINSTREL_HT_MAX_STREAMS * _sgi +	\
 	_streams - 1
 
 /* MCS rate information for an MCS group */
@@ -47,6 +52,7 @@
 	[GROUP_IDX(_streams, _sgi, _ht40)] = {				\
 	.streams = _streams,						\
 	.flags =							\
+		IEEE80211_TX_RC_MCS |					\
 		(_sgi ? IEEE80211_TX_RC_SHORT_GI : 0) |			\
 		(_ht40 ? IEEE80211_TX_RC_40_MHZ_WIDTH : 0),		\
 	.duration = {							\
@@ -61,6 +67,38 @@
 	}								\
 }
 
+#define VHT_GROUP_IDX(_streams, _sgi, _bw)			\
+	(MINSTREL_VHT_GROUP_0 +					\
+	 MINSTREL_VHT_MAX_STREAMS * 2 * (_bw) +			\
+	 MINSTREL_VHT_MAX_STREAMS * (_sgi) +			\
+	 (_streams) - 1)
+
+#define BW2VBPS(_bw, r3, r2, r1)						\
+	(_bw == BW_80 ? r3 : _bw == BW_40 ? r2 : r1)
+
+#define VHT_GROUP(_streams, _sgi, _bw)						\
+	[VHT_GROUP_IDX(_streams, _sgi, _bw)] = {				\
+	.streams = _streams,							\
+	.flags =								\
+		IEEE80211_TX_RC_VHT_MCS |					\
+		(_sgi ? IEEE80211_TX_RC_SHORT_GI : 0) |				\
+		(_bw == BW_80 ? IEEE80211_TX_RC_80_MHZ_WIDTH :			\
+		 _bw == BW_40 ? IEEE80211_TX_RC_40_MHZ_WIDTH : 0),		\
+	.duration = {								\
+		MCS_DURATION(_streams, _sgi, BW2VBPS(_bw,  117,  54,  26)),	\
+		MCS_DURATION(_streams, _sgi, BW2VBPS(_bw,  234, 108,  52)),	\
+		MCS_DURATION(_streams, _sgi, BW2VBPS(_bw,  351, 162,  78)),	\
+		MCS_DURATION(_streams, _sgi, BW2VBPS(_bw,  468, 216, 104)),	\
+		MCS_DURATION(_streams, _sgi, BW2VBPS(_bw,  702, 324, 156)),	\
+		MCS_DURATION(_streams, _sgi, BW2VBPS(_bw,  936, 432, 208)),	\
+		MCS_DURATION(_streams, _sgi, BW2VBPS(_bw, 1053, 486, 234)),	\
+		MCS_DURATION(_streams, _sgi, BW2VBPS(_bw, 1170, 540, 260)),	\
+		MCS_DURATION(_streams, _sgi, BW2VBPS(_bw, 1404, 648, 312)),	\
+		MCS_DURATION(_streams, _sgi, BW2VBPS(_bw, 1560, 720, 346))	\
+	}									\
+}
+
+
 #define CCK_DURATION(_bitrate, _short, _len)		\
 	(1000 * (10 /* SIFS */ +			\
 	 (_short ? 72 + 24 : 144 + 48) +		\
@@ -76,13 +114,14 @@
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
+		.flags = 0,				\
+		.duration = {				\
+			CCK_DURATION_LIST(false),	\
+			CCK_DURATION_LIST(true)		\
+		}					\
 	}
 
 /*
@@ -91,38 +130,55 @@
  * use.
  *
  * Sortorder has to be fixed for GROUP_IDX macro to be applicable:
- * HT40 -> SGI -> #streams
+ * BW -> SGI -> #streams
  */
 const struct mcs_group minstrel_mcs_groups[] = {
-	MCS_GROUP(1, 0, 0),
-	MCS_GROUP(2, 0, 0),
-#if MINSTREL_MAX_STREAMS >= 3
-	MCS_GROUP(3, 0, 0),
+	MCS_GROUP(1, 0, BW_20),
+	MCS_GROUP(2, 0, BW_20),
+#if MINSTREL_HT_MAX_STREAMS >= 3
+	MCS_GROUP(3, 0, BW_20),
 #endif
 
-	MCS_GROUP(1, 1, 0),
-	MCS_GROUP(2, 1, 0),
-#if MINSTREL_MAX_STREAMS >= 3
-	MCS_GROUP(3, 1, 0),
+	MCS_GROUP(1, 1, BW_20),
+	MCS_GROUP(2, 1, BW_20),
+#if MINSTREL_HT_MAX_STREAMS >= 3
+	MCS_GROUP(3, 1, BW_20),
 #endif
 
-	MCS_GROUP(1, 0, 1),
-	MCS_GROUP(2, 0, 1),
-#if MINSTREL_MAX_STREAMS >= 3
-	MCS_GROUP(3, 0, 1),
+	MCS_GROUP(1, 0, BW_40),
+	MCS_GROUP(2, 0, BW_40),
+#if MINSTREL_HT_MAX_STREAMS >= 3
+	MCS_GROUP(3, 0, BW_40),
 #endif
 
-	MCS_GROUP(1, 1, 1),
-	MCS_GROUP(2, 1, 1),
-#if MINSTREL_MAX_STREAMS >= 3
-	MCS_GROUP(3, 1, 1),
+	MCS_GROUP(1, 1, BW_40),
+	MCS_GROUP(2, 1, BW_40),
+#if MINSTREL_HT_MAX_STREAMS >= 3
+	MCS_GROUP(3, 1, BW_40),
 #endif
 
-	/* must be last */
-	CCK_GROUP
-};
+	CCK_GROUP,
+
+#ifdef CONFIG_MAC80211_RC_MINSTREL_VHT
+	VHT_GROUP(1, 0, BW_20),
+	VHT_GROUP(2, 0, BW_20),
 
-#define MINSTREL_CCK_GROUP	(ARRAY_SIZE(minstrel_mcs_groups) - 1)
+	VHT_GROUP(1, 1, BW_20),
+	VHT_GROUP(2, 1, BW_20),
+
+	VHT_GROUP(1, 0, BW_40),
+	VHT_GROUP(2, 0, BW_40),
+
+	VHT_GROUP(1, 1, BW_40),
+	VHT_GROUP(2, 1, BW_40),
+
+	VHT_GROUP(1, 0, BW_80),
+	VHT_GROUP(2, 0, BW_80),
+
+	VHT_GROUP(1, 1, BW_80),
+	VHT_GROUP(2, 1, BW_80),
+#endif
+};
 
 static u8 sample_table[SAMPLE_COLUMNS][MCS_GROUP_RATES] __read_mostly;
 
@@ -130,6 +186,44 @@ static void
 minstrel_ht_update_rates(struct minstrel_priv *mp, struct minstrel_ht_sta *mi);
 
 /*
+ * Some VHT MCSes are invalid (when Ndbps / Nes is not an integer)
+ * e.g for MCS9@20MHzx1Nss: Ndbps=8x52*(5/6) Nes=1
+ *
+ * Returns the valid mcs map for struct minstrel_mcs_group_data.supported
+ */
+static u16
+minstrel_get_valid_vht_rates(int bw, int nss, u16 mcs_map)
+{
+	u16 mask = 0;
+
+	if (bw == BW_20) {
+		if (nss != 3 && nss != 6)
+			mask = BIT(9);
+	} else if (bw == BW_80) {
+		if (nss == 3 || nss == 7)
+			mask = BIT(6);
+		else if (nss == 6)
+			mask = BIT(9);
+	} else
+		WARN_ON(bw != BW_40);
+
+	switch ((le16_to_cpu(mcs_map) >> (2 * (nss - 1))) & 3) {
+	case IEEE80211_VHT_MCS_SUPPORT_0_7:
+		mask |= 0x300;
+		break;
+	case IEEE80211_VHT_MCS_SUPPORT_0_8:
+		mask |= 0x200;
+		break;
+	case IEEE80211_VHT_MCS_SUPPORT_0_9:
+		break;
+	default:
+		mask = 0x3ff;
+	}
+
+	return 0x3ff & ~mask;
+}
+
+/*
  * Look up an MCS group index based on mac80211 rate information
  */
 static int
@@ -140,6 +234,15 @@ minstrel_ht_get_group_idx(struct ieee80211_tx_rate *rate)
 			 !!(rate->flags & IEEE80211_TX_RC_40_MHZ_WIDTH));
 }
 
+static int
+minstrel_vht_get_group_idx(struct ieee80211_tx_rate *rate)
+{
+	return VHT_GROUP_IDX(ieee80211_rate_get_vht_nss(rate),
+			     !!(rate->flags & IEEE80211_TX_RC_SHORT_GI),
+			     !!(rate->flags & IEEE80211_TX_RC_40_MHZ_WIDTH) +
+			     2*!!(rate->flags & IEEE80211_TX_RC_80_MHZ_WIDTH));
+}
+
 static struct minstrel_rate_stats *
 minstrel_ht_get_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
 		      struct ieee80211_tx_rate *rate)
@@ -149,6 +252,9 @@ minstrel_ht_get_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
 	if (rate->flags & IEEE80211_TX_RC_MCS) {
 		group = minstrel_ht_get_group_idx(rate);
 		idx = rate->idx % 8;
+	} else if (rate->flags & IEEE80211_TX_RC_VHT_MCS) {
+		group = minstrel_vht_get_group_idx(rate);
+		idx = ieee80211_rate_get_vht_mcs(rate);
 	} else {
 		group = MINSTREL_CCK_GROUP;
 
@@ -485,7 +591,8 @@ minstrel_ht_txstat_valid(struct minstrel_priv *mp, struct ieee80211_tx_rate *rat
 	if (!rate->count)
 		return false;
 
-	if (rate->flags & IEEE80211_TX_RC_MCS)
+	if (rate->flags & IEEE80211_TX_RC_MCS ||
+	    rate->flags & IEEE80211_TX_RC_VHT_MCS)
 		return true;
 
 	return rate->idx == mp->cck_rates[0] ||
@@ -714,7 +821,7 @@ minstrel_ht_set_rate(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
 	const struct mcs_group *group = &minstrel_mcs_groups[index / MCS_GROUP_RATES];
 	struct minstrel_rate_stats *mr;
 	u8 idx;
-	u16 flags;
+	u16 flags = group->flags;
 
 	mr = minstrel_get_ratestats(mi, index);
 	if (!mr->retry_updated)
@@ -730,13 +837,13 @@ minstrel_ht_set_rate(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
 		ratetbl->rate[offset].count_rts = mr->retry_count_rtscts;
 	}
 
-	if (index / MCS_GROUP_RATES == MINSTREL_CCK_GROUP) {
+	if (index / MCS_GROUP_RATES == MINSTREL_CCK_GROUP)
 		idx = mp->cck_rates[index % ARRAY_SIZE(mp->cck_rates)];
-		flags = 0;
-	} else {
+	else if (flags & IEEE80211_TX_RC_VHT_MCS)
+		idx = ((group->streams - 1) << 4) |
+		      ((index % MCS_GROUP_RATES) & 0xF);
+	else
 		idx = index % MCS_GROUP_RATES + (group->streams - 1) * 8;
-		flags = IEEE80211_TX_RC_MCS | group->flags;
-	}
 
 	if (offset > 0) {
 		ratetbl->rate[offset].count = ratetbl->rate[offset].count_rts;
@@ -916,13 +1023,15 @@ minstrel_ht_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 	if (sample_idx / MCS_GROUP_RATES == MINSTREL_CCK_GROUP) {
 		int idx = sample_idx % ARRAY_SIZE(mp->cck_rates);
 		rate->idx = mp->cck_rates[idx];
-		rate->flags = 0;
-		return;
+	} else if (sample_group->flags & IEEE80211_TX_RC_VHT_MCS) {
+		ieee80211_rate_set_vht(rate, sample_idx % MCS_GROUP_RATES,
+				       sample_group->streams);
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
@@ -962,6 +1071,8 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 	struct minstrel_ht_sta *mi = &msp->ht;
 	struct ieee80211_mcs_info *mcs = &sta->ht_cap.mcs;
 	u16 sta_cap = sta->ht_cap.cap;
+	struct ieee80211_sta_vht_cap *vht_cap = &sta->vht_cap;
+	int vht_only, use_vht;
 	int n_supported = 0;
 	int ack_dur;
 	int stbc;
@@ -971,8 +1082,16 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 	if (!sta->ht_cap.ht_supported)
 		goto use_legacy;
 
-	BUILD_BUG_ON(ARRAY_SIZE(minstrel_mcs_groups) !=
-		MINSTREL_MAX_STREAMS * MINSTREL_STREAM_GROUPS + 1);
+	BUILD_BUG_ON(ARRAY_SIZE(minstrel_mcs_groups) != MINSTREL_GROUPS_NB);
+
+#ifdef CONFIG_MAC80211_RC_MINSTREL_VHT
+	if (vht_cap->vht_supported)
+		use_vht = vht_cap->vht_mcs.tx_mcs_map != cpu_to_le16(~0);
+	else
+#endif
+	use_vht = 0;
+	/* Be less verbose and disable ht rates for a vht sta */
+	vht_only = use_vht;
 
 	msp->is_ht = true;
 	memset(mi, 0, sizeof(*mi));
@@ -997,22 +1116,29 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 	}
 	mi->sample_tries = 4;
 
-	stbc = (sta_cap & IEEE80211_HT_CAP_RX_STBC) >>
-		IEEE80211_HT_CAP_RX_STBC_SHIFT;
-	mi->tx_flags |= stbc << IEEE80211_TX_CTL_STBC_SHIFT;
-
-	if (sta_cap & IEEE80211_HT_CAP_LDPC_CODING)
-		mi->tx_flags |= IEEE80211_TX_CTL_LDPC;
+	/* TODO tx_flags for vht - ATM the RC API is not fine-grained enough */
+	if (!use_vht) {
+		stbc = (sta_cap & IEEE80211_HT_CAP_RX_STBC) >>
+			IEEE80211_HT_CAP_RX_STBC_SHIFT;
+		mi->tx_flags |= stbc << IEEE80211_TX_CTL_STBC_SHIFT;
+		if (sta_cap & IEEE80211_HT_CAP_LDPC_CODING)
+			mi->tx_flags |= IEEE80211_TX_CTL_LDPC;
+	}
 
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
+		if (vht_only && !(gflags & IEEE80211_TX_RC_VHT_MCS))
+			continue;
+
+		if (gflags & IEEE80211_TX_RC_SHORT_GI) {
+			if (gflags & IEEE80211_TX_RC_40_MHZ_WIDTH) {
 				if (!(sta_cap & IEEE80211_HT_CAP_SGI_40))
 					continue;
 			} else {
@@ -1021,7 +1147,7 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 			}
 		}
 
-		if (minstrel_mcs_groups[i].flags & IEEE80211_TX_RC_40_MHZ_WIDTH &&
+		if (gflags & IEEE80211_TX_RC_40_MHZ_WIDTH &&
 		    sta->bandwidth < IEEE80211_STA_RX_BW_40)
 			continue;
 
@@ -1030,8 +1156,35 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 		    minstrel_mcs_groups[i].streams > 1)
 			continue;
 
-		mi->groups[i].supported =
-			mcs->rx_mask[minstrel_mcs_groups[i].streams - 1];
+		if (gflags & IEEE80211_TX_RC_VHT_MCS) {
+			int bw;
+			if (!vht_cap->vht_supported)
+				continue;
+			if (gflags & IEEE80211_TX_RC_80_MHZ_WIDTH) {
+
+				if (sta->bandwidth < IEEE80211_STA_RX_BW_80 ||
+				    ((gflags & IEEE80211_TX_RC_SHORT_GI) &&
+				     !(vht_cap->cap & IEEE80211_VHT_CAP_SHORT_GI_80))) {
+					continue;
+				}
+			}
+			if (WARN_ON(gflags & IEEE80211_TX_RC_160_MHZ_WIDTH))
+				continue;
+
+			if (gflags & IEEE80211_TX_RC_40_MHZ_WIDTH)
+				bw = BW_40;
+			else if (gflags & IEEE80211_TX_RC_80_MHZ_WIDTH)
+				bw = BW_80;
+			else
+				bw = BW_20;
+			mi->groups[i].supported =
+				minstrel_get_valid_vht_rates(bw,
+						minstrel_mcs_groups[i].streams,
+						vht_cap->vht_mcs.tx_mcs_map);
+		} else {
+			mi->groups[i].supported =
+				mcs->rx_mask[minstrel_mcs_groups[i].streams - 1];
+		}
 
 		if (mi->groups[i].supported)
 			n_supported++;
diff --git a/net/mac80211/rc80211_minstrel_ht.h b/net/mac80211/rc80211_minstrel_ht.h
index 01570e0..7856062 100644
--- a/net/mac80211/rc80211_minstrel_ht.h
+++ b/net/mac80211/rc80211_minstrel_ht.h
@@ -13,10 +13,33 @@
  * The number of streams can be changed to 2 to reduce code
  * size and memory footprint.
  */
-#define MINSTREL_MAX_STREAMS	3
-#define MINSTREL_STREAM_GROUPS	4
+#ifdef CONFIG_MAC80211_RC_MINSTREL_VHT
+#define MINSTREL_VHT_MAX_STREAMS	2
+#else
+#define MINSTREL_VHT_MAX_STREAMS	0
+#endif
+#define MINSTREL_VHT_STREAM_GROUPS	6 /* BW(=3) * SGI(=2) */
+
+#define MINSTREL_HT_MAX_STREAMS		3
+#define MINSTREL_HT_STREAM_GROUPS	4 /* BW(=2) * SGI(=2) */
+
 
-#define MCS_GROUP_RATES	8
+#define MINSTREL_HT_GROUPS_NB	(MINSTREL_HT_MAX_STREAMS * MINSTREL_HT_STREAM_GROUPS)
+#define MINSTREL_VHT_GROUPS_NB	(MINSTREL_VHT_MAX_STREAMS * MINSTREL_VHT_STREAM_GROUPS)
+#define MINSTREL_CCK_GROUPS_NB	1
+#define MINSTREL_GROUPS_NB	(MINSTREL_HT_GROUPS_NB +	\
+				 MINSTREL_VHT_GROUPS_NB +	\
+				 MINSTREL_CCK_GROUPS_NB)
+
+#define MINSTREL_HT_GROUP_0	0
+#define MINSTREL_CCK_GROUP	(MINSTREL_HT_GROUP_0 + MINSTREL_HT_GROUPS_NB)
+#define MINSTREL_VHT_GROUP_0	(MINSTREL_CCK_GROUP + 1)
+
+#ifdef CONFIG_MAC80211_RC_MINSTREL_VHT
+#define MCS_GROUP_RATES		10
+#else
+#define MCS_GROUP_RATES		8
+#endif
 
 struct mcs_group {
 	u32 flags;
@@ -31,7 +54,7 @@ struct minstrel_mcs_group_data {
 	u8 column;
 
 	/* bitfield of supported MCS rates of this group */
-	u8 supported;
+	u16 supported;
 
 	/* sorted rate set within a MCS group*/
 	u8 max_group_tp_rate[MAX_THR_RATES];
@@ -80,7 +103,7 @@ struct minstrel_ht_sta {
 	u8 cck_supported_short;
 
 	/* MCS rate group info and statistics */
-	struct minstrel_mcs_group_data groups[MINSTREL_MAX_STREAMS * MINSTREL_STREAM_GROUPS + 1];
+	struct minstrel_mcs_group_data groups[MINSTREL_GROUPS_NB];
 };
 
 struct minstrel_ht_sta_priv {
diff --git a/net/mac80211/rc80211_minstrel_ht_debugfs.c b/net/mac80211/rc80211_minstrel_ht_debugfs.c
index a72ad46..60c7ca8 100644
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
@@ -30,6 +29,8 @@ minstrel_ht_stats_dump(struct minstrel_ht_sta *mi, int i, char *p)
 	mg = &minstrel_mcs_groups[i];
 	if (mg->flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
 		htmode = '4';
+	else if (mg->flags & IEEE80211_TX_RC_80_MHZ_WIDTH)
+		htmode = '8';
 	if (mg->flags & IEEE80211_TX_RC_SHORT_GI)
 		gimode = 'S';
 
@@ -41,10 +42,12 @@ minstrel_ht_stats_dump(struct minstrel_ht_sta *mi, int i, char *p)
 		if (!(mi->groups[i].supported & BIT(j)))
 			continue;
 
-		if (i == max_mcs)
-			p += sprintf(p, "CCK/%cP   ", j < 4 ? 'L' : 'S');
+		if (i == MINSTREL_CCK_GROUP)
+			p += sprintf(p, " CCK/%cP   ", j < 4 ? 'L' : 'S');
+		else if (i >= MINSTREL_VHT_GROUP_0)
+			p += sprintf(p, "VHT%c0/%cGI ", htmode, gimode);
 		else
-			p += sprintf(p, "HT%c0/%cGI ", htmode, gimode);
+			p += sprintf(p, " HT%c0/%cGI ", htmode, gimode);
 
 		*(p++) = (idx == mi->max_tp_rate[0]) ? 'A' : ' ';
 		*(p++) = (idx == mi->max_tp_rate[1]) ? 'B' : ' ';
@@ -52,11 +55,13 @@ minstrel_ht_stats_dump(struct minstrel_ht_sta *mi, int i, char *p)
 		*(p++) = (idx == mi->max_tp_rate[3]) ? 'D' : ' ';
 		*(p++) = (idx == mi->max_prob_rate) ? 'P' : ' ';
 
-		if (i == max_mcs) {
+		if (i == MINSTREL_CCK_GROUP) {
 			int r = bitrates[j % 4];
-			p += sprintf(p, " %2u.%1uM", r / 10, r % 10);
+			p += sprintf(p, " %2u.%1uM    ", r / 10, r % 10);
+		} else if (i >= MINSTREL_VHT_GROUP_0) {
+			p += sprintf(p, " MCS%-2u   %1u", j, mg->streams);
 		} else {
-			p += sprintf(p, " MCS%-2u", (mg->streams - 1) * 8 + j);
+			p += sprintf(p, " MCS%-2u    ", (mg->streams - 1) * 8 + j);
 		}
 
 		tp = mr->cur_tp / 10;
@@ -64,7 +69,7 @@ minstrel_ht_stats_dump(struct minstrel_ht_sta *mi, int i, char *p)
 		eprob = MINSTREL_TRUNC(mr->probability * 1000);
 
 		p += sprintf(p, "      %6u.%1u   %6u.%1u    %6u.%1u    "
-				"%3u            %3u(%3u)  %8llu    %8llu\n",
+				"%3u          %4u(%4u)  %8llu    %8llu\n",
 				tp / 10, tp % 10,
 				eprob / 10, eprob % 10,
 				prob / 10, prob % 10,
@@ -85,7 +90,6 @@ minstrel_ht_stats_open(struct inode *inode, struct file *file)
 	struct minstrel_ht_sta *mi = &msp->ht;
 	struct minstrel_debugfs_info *ms;
 	unsigned int i;
-	unsigned int max_mcs = MINSTREL_MAX_STREAMS * MINSTREL_STREAM_GROUPS;
 	char *p;
 	int ret;
 
@@ -102,11 +106,13 @@ minstrel_ht_stats_open(struct inode *inode, struct file *file)
 
 	file->private_data = ms;
 	p = ms->buf;
-	p += sprintf(p, "type           rate     throughput  ewma prob   "
+	p += sprintf(p, "type            rate  nss    throughput  ewma prob   "
 		     "this prob  retry   this succ/attempt   success    attempts\n");
 
-	p = minstrel_ht_stats_dump(mi, max_mcs, p);
-	for (i = 0; i < max_mcs; i++)
+	p = minstrel_ht_stats_dump(mi, MINSTREL_CCK_GROUP, p);
+	for (i = 0; i < MINSTREL_CCK_GROUP; i++)
+		p = minstrel_ht_stats_dump(mi, i, p);
+	for (i++; i < ARRAY_SIZE(mi->groups); i++)
 		p = minstrel_ht_stats_dump(mi, i, p);
 
 	p += sprintf(p, "\nTotal packet count::    ideal %d      "
-- 
2.0.1

