Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:63750 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008AbaJQTvQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Oct 2014 15:51:16 -0400
Received: by mail-wi0-f174.google.com with SMTP id h11so3253268wiw.7
        for <linux-wireless@vger.kernel.org>; Fri, 17 Oct 2014 12:51:14 -0700 (PDT)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Karl Beldan <karl.beldan@rivierawaves.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	karl.beldan@gmail.com, Felix Fietkau <nbd@openwrt.org>
Subject: [RESEND PATCH v2 4/4] mac80211: minstrel_ht: add basic support for VHT rates <= 3SS@80MHz
Date: Fri, 17 Oct 2014 21:50:59 +0200
Message-Id: <1413575459-29612-5-git-send-email-karl.beldan@gmail.com> (sfid-20141017_215123_894762_EBAED1AE)
In-Reply-To: <1413575459-29612-1-git-send-email-karl.beldan@gmail.com>
References: <1413570896-27740-5-git-send-email-karl.beldan@gmail.com>
 <1413575459-29612-1-git-send-email-karl.beldan@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karl Beldan <karl.beldan@rivierawaves.com>

When the new CONFIG_MAC80211_RC_MINSTREL_VHT is not set (default 'N'),
there is no behavioral change including in sampling and MCS_GROUP_RATES
remains 8.
Otherwise MCS_GROUP_RATES is 10, and a module parameter *vht_only*
(default 'true'), restricts the rates selection to VHT when vht is
supported.

Regarding the debugfs stats buffer:
It is explicitly increased from 8k to 32k to fit every rates incl. when
both ht and vht rates are enabled, as for the format, before:
type           rate     tpt eprob *prob ret  *ok(*cum)        ok(      cum)
HT20/LGI ABCDP MCS0     0.0   0.0   0.0   1    0(   0)         0(        0)
after:
 type           rate      tpt eprob *prob ret  *ok(*cum)        ok(      cum)
 HT20/LGI ABCDP MCS0      0.0   0.0   0.0   1    0(   0)         0(        0)
VHT40/LGI       MCS5/2    0.0   0.0   0.0   0    0(   0)         0(        0)

Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
Cc: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/Kconfig                       |   7 ++
 net/mac80211/rc80211_minstrel_ht.c         | 193 +++++++++++++++++++++++++++--
 net/mac80211/rc80211_minstrel_ht.h         |  16 ++-
 net/mac80211/rc80211_minstrel_ht_debugfs.c |  22 ++--
 4 files changed, 219 insertions(+), 19 deletions(-)

diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index aeb6a48..e8049ed 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -33,6 +33,13 @@ config MAC80211_RC_MINSTREL_HT
 	---help---
 	  This option enables the 'minstrel_ht' TX rate control algorithm
 
+config MAC80211_RC_MINSTREL_VHT
+	bool "Minstrel 802.11ac support" if EXPERT
+	depends on MAC80211_RC_MINSTREL_HT
+	default n
+	---help---
+	  This option enables vht in the 'minstrel_ht' TX rate control algorithm
+
 choice
 	prompt "Default rate control algorithm"
 	depends on MAC80211_HAS_RC
diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index e760d3d..07e9320 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -10,6 +10,7 @@
 #include <linux/skbuff.h>
 #include <linux/debugfs.h>
 #include <linux/random.h>
+#include <linux/moduleparam.h>
 #include <linux/ieee80211.h>
 #include <net/mac80211.h>
 #include "rate.h"
@@ -36,6 +37,7 @@
 
 #define BW_20			0
 #define BW_40			1
+#define BW_80			2
 
 /*
  * Define group sort order: HT40 -> SGI -> #streams
@@ -66,6 +68,37 @@
 	}								\
 }
 
+#define VHT_GROUP_IDX(_streams, _sgi, _bw)			\
+	(MINSTREL_VHT_GROUP_0 +					\
+	 MINSTREL_MAX_STREAMS * 2 * (_bw) +			\
+	 MINSTREL_MAX_STREAMS * (_sgi) +			\
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
 #define CCK_DURATION(_bitrate, _short, _len)		\
 	(1000 * (10 /* SIFS */ +			\
 	 (_short ? 72 + 24 : 144 + 48) +		\
@@ -91,6 +124,10 @@
 		}					\
 	}
 
+static bool minstrel_vht_only = true;
+module_param(minstrel_vht_only, bool, 0644);
+MODULE_PARM_DESC(minstrel_vht_only, "Use only VHT rates when VHT is supported by sta.");
+
 /*
  * To enable sufficiently targeted rate sampling, MCS rates are divided into
  * groups, based on the number of streams and flags (HT40, SGI) that they
@@ -124,9 +161,46 @@ const struct mcs_group minstrel_mcs_groups[] = {
 	MCS_GROUP(3, 1, BW_40),
 #endif
 
-	CCK_GROUP
-};
+	CCK_GROUP,
+
+#ifdef CONFIG_MAC80211_RC_MINSTREL_VHT
+	VHT_GROUP(1, 0, BW_20),
+	VHT_GROUP(2, 0, BW_20),
+#if MINSTREL_MAX_STREAMS >= 3
+	VHT_GROUP(3, 0, BW_20),
+#endif
+
+	VHT_GROUP(1, 1, BW_20),
+	VHT_GROUP(2, 1, BW_20),
+#if MINSTREL_MAX_STREAMS >= 3
+	VHT_GROUP(3, 1, BW_20),
+#endif
+
+	VHT_GROUP(1, 0, BW_40),
+	VHT_GROUP(2, 0, BW_40),
+#if MINSTREL_MAX_STREAMS >= 3
+	VHT_GROUP(3, 0, BW_40),
+#endif
 
+	VHT_GROUP(1, 1, BW_40),
+	VHT_GROUP(2, 1, BW_40),
+#if MINSTREL_MAX_STREAMS >= 3
+	VHT_GROUP(3, 1, BW_40),
+#endif
+
+	VHT_GROUP(1, 0, BW_80),
+	VHT_GROUP(2, 0, BW_80),
+#if MINSTREL_MAX_STREAMS >= 3
+	VHT_GROUP(3, 0, BW_80),
+#endif
+
+	VHT_GROUP(1, 1, BW_80),
+	VHT_GROUP(2, 1, BW_80),
+#if MINSTREL_MAX_STREAMS >= 3
+	VHT_GROUP(3, 1, BW_80),
+#endif
+#endif
+};
 
 static u8 sample_table[SAMPLE_COLUMNS][MCS_GROUP_RATES] __read_mostly;
 
@@ -134,6 +208,44 @@ static void
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
@@ -144,6 +256,15 @@ minstrel_ht_get_group_idx(struct ieee80211_tx_rate *rate)
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
@@ -153,6 +274,9 @@ minstrel_ht_get_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
 	if (rate->flags & IEEE80211_TX_RC_MCS) {
 		group = minstrel_ht_get_group_idx(rate);
 		idx = rate->idx % 8;
+	} else if (rate->flags & IEEE80211_TX_RC_VHT_MCS) {
+		group = minstrel_vht_get_group_idx(rate);
+		idx = ieee80211_rate_get_vht_mcs(rate);
 	} else {
 		group = MINSTREL_CCK_GROUP;
 
@@ -489,7 +613,8 @@ minstrel_ht_txstat_valid(struct minstrel_priv *mp, struct ieee80211_tx_rate *rat
 	if (!rate->count)
 		return false;
 
-	if (rate->flags & IEEE80211_TX_RC_MCS)
+	if (rate->flags & IEEE80211_TX_RC_MCS ||
+	    rate->flags & IEEE80211_TX_RC_VHT_MCS)
 		return true;
 
 	return rate->idx == mp->cck_rates[0] ||
@@ -736,6 +861,9 @@ minstrel_ht_set_rate(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
 
 	if (index / MCS_GROUP_RATES == MINSTREL_CCK_GROUP)
 		idx = mp->cck_rates[index % ARRAY_SIZE(mp->cck_rates)];
+	else if (flags & IEEE80211_TX_RC_VHT_MCS)
+		idx = ((group->streams - 1) << 4) |
+		      ((index % MCS_GROUP_RATES) & 0xF);
 	else
 		idx = index % MCS_GROUP_RATES + (group->streams - 1) * 8;
 
@@ -917,6 +1045,9 @@ minstrel_ht_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 	if (sample_idx / MCS_GROUP_RATES == MINSTREL_CCK_GROUP) {
 		int idx = sample_idx % ARRAY_SIZE(mp->cck_rates);
 		rate->idx = mp->cck_rates[idx];
+	} else if (sample_group->flags & IEEE80211_TX_RC_VHT_MCS) {
+		ieee80211_rate_set_vht(rate, sample_idx % MCS_GROUP_RATES,
+				       sample_group->streams);
 	} else {
 		rate->idx = sample_idx % MCS_GROUP_RATES +
 			    (sample_group->streams - 1) * 8;
@@ -962,6 +1093,8 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 	struct minstrel_ht_sta *mi = &msp->ht;
 	struct ieee80211_mcs_info *mcs = &sta->ht_cap.mcs;
 	u16 sta_cap = sta->ht_cap.cap;
+	struct ieee80211_sta_vht_cap *vht_cap = &sta->vht_cap;
+	int use_vht;
 	int n_supported = 0;
 	int ack_dur;
 	int stbc;
@@ -973,6 +1106,13 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 
 	BUILD_BUG_ON(ARRAY_SIZE(minstrel_mcs_groups) != MINSTREL_GROUPS_NB);
 
+#ifdef CONFIG_MAC80211_RC_MINSTREL_VHT
+	if (vht_cap->vht_supported)
+		use_vht = vht_cap->vht_mcs.tx_mcs_map != cpu_to_le16(~0);
+	else
+#endif
+	use_vht = 0;
+
 	msp->is_ht = true;
 	memset(mi, 0, sizeof(*mi));
 
@@ -996,12 +1136,15 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 	}
 	mi->sample_tries = 4;
 
-	stbc = (sta_cap & IEEE80211_HT_CAP_RX_STBC) >>
-		IEEE80211_HT_CAP_RX_STBC_SHIFT;
-	mi->tx_flags |= stbc << IEEE80211_TX_CTL_STBC_SHIFT;
+	/* TODO tx_flags for vht - ATM the RC API is not fine-grained enough */
+	if (!use_vht) {
+		stbc = (sta_cap & IEEE80211_HT_CAP_RX_STBC) >>
+			IEEE80211_HT_CAP_RX_STBC_SHIFT;
+		mi->tx_flags |= stbc << IEEE80211_TX_CTL_STBC_SHIFT;
 
-	if (sta_cap & IEEE80211_HT_CAP_LDPC_CODING)
-		mi->tx_flags |= IEEE80211_TX_CTL_LDPC;
+		if (sta_cap & IEEE80211_HT_CAP_LDPC_CODING)
+			mi->tx_flags |= IEEE80211_TX_CTL_LDPC;
+	}
 
 	for (i = 0; i < ARRAY_SIZE(mi->groups); i++) {
 		u32 gflags = minstrel_mcs_groups[i].flags;
@@ -1012,6 +1155,9 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 			continue;
 		}
 
+		if (minstrel_vht_only && !(gflags & IEEE80211_TX_RC_VHT_MCS))
+			continue;
+
 		if (gflags & IEEE80211_TX_RC_SHORT_GI) {
 			if (gflags & IEEE80211_TX_RC_40_MHZ_WIDTH) {
 				if (!(sta_cap & IEEE80211_HT_CAP_SGI_40))
@@ -1031,8 +1177,35 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
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
index 7b46592..72fd0a5 100644
--- a/net/mac80211/rc80211_minstrel_ht.h
+++ b/net/mac80211/rc80211_minstrel_ht.h
@@ -15,16 +15,28 @@
  */
 #define MINSTREL_MAX_STREAMS		3
 #define MINSTREL_HT_STREAM_GROUPS	4 /* BW(=2) * SGI(=2) */
+#ifdef CONFIG_MAC80211_RC_MINSTREL_VHT
+#define MINSTREL_VHT_STREAM_GROUPS	6 /* BW(=3) * SGI(=2) */
+#else
+#define MINSTREL_VHT_STREAM_GROUPS	0
+#endif
 
 #define MINSTREL_HT_GROUPS_NB	(MINSTREL_MAX_STREAMS * MINSTREL_HT_STREAM_GROUPS)
+#define MINSTREL_VHT_GROUPS_NB	(MINSTREL_MAX_STREAMS * MINSTREL_VHT_STREAM_GROUPS)
 #define MINSTREL_CCK_GROUPS_NB	1
 #define MINSTREL_GROUPS_NB	(MINSTREL_HT_GROUPS_NB +	\
+				 MINSTREL_VHT_GROUPS_NB +	\
 				 MINSTREL_CCK_GROUPS_NB)
 
 #define MINSTREL_HT_GROUP_0	0
 #define MINSTREL_CCK_GROUP	(MINSTREL_HT_GROUP_0 + MINSTREL_HT_GROUPS_NB)
+#define MINSTREL_VHT_GROUP_0	(MINSTREL_CCK_GROUP + 1)
 
-#define MCS_GROUP_RATES	8
+#ifdef CONFIG_MAC80211_RC_MINSTREL_VHT
+#define MCS_GROUP_RATES		10
+#else
+#define MCS_GROUP_RATES		8
+#endif
 
 struct mcs_group {
 	u32 flags;
@@ -39,7 +51,7 @@ struct minstrel_mcs_group_data {
 	u8 column;
 
 	/* bitfield of supported MCS rates of this group */
-	u8 supported;
+	u16 supported;
 
 	/* sorted rate set within a MCS group*/
 	u16 max_group_tp_rate[MAX_THR_RATES];
diff --git a/net/mac80211/rc80211_minstrel_ht_debugfs.c b/net/mac80211/rc80211_minstrel_ht_debugfs.c
index 64a7984..e011f7f 100644
--- a/net/mac80211/rc80211_minstrel_ht_debugfs.c
+++ b/net/mac80211/rc80211_minstrel_ht_debugfs.c
@@ -29,6 +29,8 @@ minstrel_ht_stats_dump(struct minstrel_ht_sta *mi, int i, char *p)
 	mg = &minstrel_mcs_groups[i];
 	if (mg->flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
 		htmode = '4';
+	else if (mg->flags & IEEE80211_TX_RC_80_MHZ_WIDTH)
+		htmode = '8';
 	if (mg->flags & IEEE80211_TX_RC_SHORT_GI)
 		gimode = 'S';
 
@@ -41,9 +43,11 @@ minstrel_ht_stats_dump(struct minstrel_ht_sta *mi, int i, char *p)
 			continue;
 
 		if (i == MINSTREL_CCK_GROUP)
-			p += sprintf(p, "CCK/%cP   ", j < 4 ? 'L' : 'S');
+			p += sprintf(p, " CCK/%cP   ", j < 4 ? 'L' : 'S');
+		else if (i >= MINSTREL_VHT_GROUP_0)
+			p += sprintf(p, "VHT%c0/%cGI ", htmode, gimode/*, mg->streams*/);
 		else
-			p += sprintf(p, "HT%c0/%cGI ", htmode, gimode);
+			p += sprintf(p, " HT%c0/%cGI ", htmode, gimode);
 
 		*(p++) = (idx == mi->max_tp_rate[0]) ? 'A' : ' ';
 		*(p++) = (idx == mi->max_tp_rate[1]) ? 'B' : ' ';
@@ -53,9 +57,11 @@ minstrel_ht_stats_dump(struct minstrel_ht_sta *mi, int i, char *p)
 
 		if (i == MINSTREL_CCK_GROUP) {
 			int r = bitrates[j % 4];
-			p += sprintf(p, " %2u.%1uM", r / 10, r % 10);
+			p += sprintf(p, " %2u.%1uM ", r / 10, r % 10);
+		} else if (i >= MINSTREL_VHT_GROUP_0) {
+			p += sprintf(p, " MCS%-1u/%1u", j, mg->streams);
 		} else {
-			p += sprintf(p, " MCS%-2u", (mg->streams - 1) * 8 + j);
+			p += sprintf(p, " MCS%-2u ", (mg->streams - 1) * 8 + j);
 		}
 
 		tp = mr->cur_tp / 10;
@@ -94,19 +100,21 @@ minstrel_ht_stats_open(struct inode *inode, struct file *file)
 		return ret;
 	}
 
-	ms = kmalloc(8192, GFP_KERNEL);
+	ms = kmalloc(32768, GFP_KERNEL);
 	if (!ms)
 		return -ENOMEM;
 
 	file->private_data = ms;
 	p = ms->buf;
-	p += sprintf(p, "type           rate     tpt eprob *prob "
+	p += sprintf(p, " type           rate      tpt eprob *prob "
 			"ret  *ok(*cum)        ok(      cum)\n");
 
 
 	p = minstrel_ht_stats_dump(mi, MINSTREL_CCK_GROUP, p);
 	for (i = 0; i < MINSTREL_CCK_GROUP; i++)
 		p = minstrel_ht_stats_dump(mi, i, p);
+	for (i++; i < ARRAY_SIZE(mi->groups); i++)
+		p = minstrel_ht_stats_dump(mi, i, p);
 
 	p += sprintf(p, "\nTotal packet count::    ideal %d      "
 			"lookaround %d\n",
@@ -117,7 +125,7 @@ minstrel_ht_stats_open(struct inode *inode, struct file *file)
 		MINSTREL_TRUNC(mi->avg_ampdu_len * 10) % 10);
 	ms->len = p - ms->buf;
 
-	WARN_ON(ms->len > 8192 - sizeof(*ms));
+	WARN_ON(ms->len > 32768 - sizeof(*ms));
 
 	return nonseekable_open(inode, file);
 }
-- 
2.0.1

