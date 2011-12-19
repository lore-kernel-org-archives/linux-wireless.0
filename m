Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:58992 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189Ab1LSOPG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 09:15:06 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, Johannes Berg <johannes@sipsolutions.net>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: [PATCH 2/2] mac80211: add support for mcs masks
Date: Mon, 19 Dec 2011 15:14:57 +0100
Message-Id: <1324304099-18327-3-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20111219_151514_776835_ED64BC64)
In-Reply-To: <1324304099-18327-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1324304099-18327-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Handle MCS masks set by the user.
* Match rates provided by the rate control algorithm to the mask set,
  also in HT mode, and switch back to legacy mode if necessary.
* add debugfs files to observate the rate selection

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 include/net/mac80211.h        |    1 +
 net/mac80211/cfg.c            |    5 +-
 net/mac80211/debugfs_netdev.c |   34 +++++++++++
 net/mac80211/ieee80211_i.h    |    1 +
 net/mac80211/iface.c          |    3 +
 net/mac80211/rate.c           |  129 +++++++++++++++++++++++++++++++++++++----
 net/mac80211/tx.c             |    5 ++
 7 files changed, 165 insertions(+), 13 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 5b5c8a7..4bce803 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3537,6 +3537,7 @@ struct ieee80211_tx_rate_control {
 	bool rts, short_preamble;
 	u8 max_rate_idx;
 	u32 rate_idx_mask;
+	u8 rate_idx_mcs_mask[IEEE80211_HT_MCS_MASK_LEN];
 	bool bss;
 };
 
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 393b2a4..4862a73 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1865,8 +1865,11 @@ static int ieee80211_set_bitrate_mask(struct wiphy *wiphy,
 			return ret;
 	}
 
-	for (i = 0; i < IEEE80211_NUM_BANDS; i++)
+	for (i = 0; i < IEEE80211_NUM_BANDS; i++) {
 		sdata->rc_rateidx_mask[i] = mask->control[i].legacy;
+		memcpy(sdata->rc_rateidx_mcs_mask[i], mask->control[i].mcs,
+		       sizeof(mask->control[i].mcs));
+	}
 
 	return 0;
 }
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 8df2891..6e2ff9c 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -87,6 +87,21 @@ static ssize_t ieee80211_if_fmt_##name(					\
 #define IEEE80211_IF_FMT_SIZE(name, field)				\
 		IEEE80211_IF_FMT(name, field, "%zd\n")
 
+#define IEEE80211_IF_FMT_HEXARRAY(name, field)				\
+static ssize_t ieee80211_if_fmt_##name(					\
+	const struct ieee80211_sub_if_data *sdata,			\
+	char *buf, int buflen)						\
+{									\
+	char *p = buf;							\
+	int i;								\
+	for (i = 0; i < sizeof(sdata->field); i++) {			\
+		p += scnprintf(p, buflen + buf - p, "%.2x ",		\
+				 sdata->field[i]);			\
+	}								\
+	p += scnprintf(p, buflen + buf - p, "\n");			\
+	return p - buf;							\
+}
+
 #define IEEE80211_IF_FMT_ATOMIC(name, field)				\
 static ssize_t ieee80211_if_fmt_##name(					\
 	const struct ieee80211_sub_if_data *sdata,			\
@@ -148,6 +163,11 @@ IEEE80211_IF_FILE(rc_rateidx_mask_2ghz, rc_rateidx_mask[IEEE80211_BAND_2GHZ],
 		  HEX);
 IEEE80211_IF_FILE(rc_rateidx_mask_5ghz, rc_rateidx_mask[IEEE80211_BAND_5GHZ],
 		  HEX);
+IEEE80211_IF_FILE(rc_rateidx_mcs_mask_2ghz,
+		  rc_rateidx_mcs_mask[IEEE80211_BAND_2GHZ], HEXARRAY);
+IEEE80211_IF_FILE(rc_rateidx_mcs_mask_5ghz,
+		  rc_rateidx_mcs_mask[IEEE80211_BAND_5GHZ], HEXARRAY);
+
 IEEE80211_IF_FILE(flags, flags, HEX);
 IEEE80211_IF_FILE(state, state, LHEX);
 IEEE80211_IF_FILE(channel_type, vif.bss_conf.channel_type, DEC);
@@ -440,6 +460,8 @@ static void add_sta_files(struct ieee80211_sub_if_data *sdata)
 	DEBUGFS_ADD(channel_type);
 	DEBUGFS_ADD(rc_rateidx_mask_2ghz);
 	DEBUGFS_ADD(rc_rateidx_mask_5ghz);
+	DEBUGFS_ADD(rc_rateidx_mcs_mask_2ghz);
+	DEBUGFS_ADD(rc_rateidx_mcs_mask_5ghz);
 
 	DEBUGFS_ADD(bssid);
 	DEBUGFS_ADD(aid);
@@ -457,6 +479,8 @@ static void add_ap_files(struct ieee80211_sub_if_data *sdata)
 	DEBUGFS_ADD(channel_type);
 	DEBUGFS_ADD(rc_rateidx_mask_2ghz);
 	DEBUGFS_ADD(rc_rateidx_mask_5ghz);
+	DEBUGFS_ADD(rc_rateidx_mcs_mask_2ghz);
+	DEBUGFS_ADD(rc_rateidx_mcs_mask_5ghz);
 
 	DEBUGFS_ADD(num_sta_ps);
 	DEBUGFS_ADD(dtim_count);
@@ -466,6 +490,12 @@ static void add_ap_files(struct ieee80211_sub_if_data *sdata)
 
 static void add_ibss_files(struct ieee80211_sub_if_data *sdata)
 {
+	DEBUGFS_ADD(channel_type);
+	DEBUGFS_ADD(rc_rateidx_mask_2ghz);
+	DEBUGFS_ADD(rc_rateidx_mask_5ghz);
+	DEBUGFS_ADD(rc_rateidx_mcs_mask_2ghz);
+	DEBUGFS_ADD(rc_rateidx_mcs_mask_5ghz);
+
 	DEBUGFS_ADD_MODE(tsf, 0600);
 }
 
@@ -477,6 +507,8 @@ static void add_wds_files(struct ieee80211_sub_if_data *sdata)
 	DEBUGFS_ADD(channel_type);
 	DEBUGFS_ADD(rc_rateidx_mask_2ghz);
 	DEBUGFS_ADD(rc_rateidx_mask_5ghz);
+	DEBUGFS_ADD(rc_rateidx_mcs_mask_2ghz);
+	DEBUGFS_ADD(rc_rateidx_mcs_mask_5ghz);
 
 	DEBUGFS_ADD(peer);
 }
@@ -489,6 +521,8 @@ static void add_vlan_files(struct ieee80211_sub_if_data *sdata)
 	DEBUGFS_ADD(channel_type);
 	DEBUGFS_ADD(rc_rateidx_mask_2ghz);
 	DEBUGFS_ADD(rc_rateidx_mask_5ghz);
+	DEBUGFS_ADD(rc_rateidx_mcs_mask_2ghz);
+	DEBUGFS_ADD(rc_rateidx_mcs_mask_5ghz);
 }
 
 static void add_monitor_files(struct ieee80211_sub_if_data *sdata)
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 96fe754..bff632f 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -642,6 +642,7 @@ struct ieee80211_sub_if_data {
 
 	/* bitmap of allowed (non-MCS) rate indexes for rate control */
 	u32 rc_rateidx_mask[IEEE80211_NUM_BANDS];
+	u8  rc_rateidx_mcs_mask[IEEE80211_NUM_BANDS][IEEE80211_HT_MCS_MASK_LEN];
 
 	union {
 		struct ieee80211_if_ap ap;
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 3d3bb5e..93328c9 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1180,6 +1180,9 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 		sband = local->hw.wiphy->bands[i];
 		sdata->rc_rateidx_mask[i] =
 			sband ? (1 << sband->n_bitrates) - 1 : 0;
+		memset(sdata->rc_rateidx_mcs_mask[i], sband ? 0xff : 0,
+		       sizeof(sdata->rc_rateidx_mcs_mask[i]));
+
 	}
 
 	/* setup type-dependent data */
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 5a5a776..3b6ace2 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -267,10 +267,10 @@ bool rate_control_send_low(struct ieee80211_sta *sta,
 
 	if (!sta || !priv_sta || rc_no_data_or_no_ack_use_min(txrc)) {
 		if ((sband->band != IEEE80211_BAND_2GHZ) ||
-		    !(info->flags & IEEE80211_TX_CTL_NO_CCK_RATE))
+		    !(info->flags & IEEE80211_TX_CTL_NO_CCK_RATE)) {
 			info->control.rates[0].idx =
 				rate_lowest_index(txrc->sband, sta);
-		else
+		} else
 			info->control.rates[0].idx =
 				rate_lowest_non_cck_index(txrc->sband, sta);
 		info->control.rates[0].count =
@@ -293,25 +293,128 @@ bool rate_control_send_low(struct ieee80211_sta *sta,
 }
 EXPORT_SYMBOL(rate_control_send_low);
 
-static void rate_idx_match_mask(struct ieee80211_tx_rate *rate,
-				int n_bitrates, u32 mask)
+static bool rate_idx_match_legacy_mask(struct ieee80211_tx_rate *rate,
+				       int n_bitrates, u32 mask)
 {
 	int j;
 
-	/* See whether the selected rate or anything below it is allowed. */
+	/* See whether the selected rate or anything below
+	 * it is allowed. */
 	for (j = rate->idx; j >= 0; j--) {
 		if (mask & (1 << j)) {
 			/* Okay, found a suitable rate. Use it. */
 			rate->idx = j;
-			return;
+			return true;
 		}
 	}
-
 	/* Try to find a higher rate that would be allowed */
 	for (j = rate->idx + 1; j < n_bitrates; j++) {
 		if (mask & (1 << j)) {
 			/* Okay, found a suitable rate. Use it. */
 			rate->idx = j;
+			return true;
+		}
+	}
+	return false;
+}
+
+static bool rate_idx_match_mcs_mask(struct ieee80211_tx_rate *rate,
+				    u8 mcs_mask[IEEE80211_HT_MCS_MASK_LEN])
+{
+	int i, j;
+	int ridx, rbit;
+
+	ridx = rate->idx / 8;
+	rbit = rate->idx % 8;
+
+	/* See whether the selected rate or anything below
+	 * it is allowed. */
+	for (i = ridx; i >= 0; i--) {
+		for (j = rbit; j >= 0; j--)
+			if (mcs_mask[i] & BIT(j)) {
+				rate->idx = i * 8 + j;
+				return true;
+			}
+		rbit = 7;
+	}
+
+	/* Try to find a higher rate that would be allowed */
+	ridx = (rate->idx + 1) / 8;
+	rbit = (rate->idx + 1) % 8;
+
+	for (i = ridx; i < IEEE80211_HT_MCS_MASK_LEN; i++) {
+		for (j = rbit; j < 8; j++)
+			if (mcs_mask[i] & BIT(j)) {
+				rate->idx = i * 8 + j;
+				return true;
+			}
+		rbit = 0;
+	}
+	return false;
+}
+
+
+
+static void rate_idx_match_mask(struct ieee80211_tx_rate *rate,
+				struct ieee80211_tx_rate_control *txrc,
+				u32 mask,
+				u8 mcs_mask[IEEE80211_HT_MCS_MASK_LEN])
+{
+	struct ieee80211_tx_rate alt_rate;
+
+	/* handle HT rates */
+	if (rate->flags & IEEE80211_TX_RC_MCS) {
+		if (rate_idx_match_mcs_mask(rate, mcs_mask))
+			return;
+
+		/* also try the legacy rates. */
+		alt_rate.idx = 0;
+		/* keep protection flags */
+		alt_rate.flags = rate->flags &
+				 (IEEE80211_TX_RC_USE_RTS_CTS |
+				  IEEE80211_TX_RC_USE_CTS_PROTECT |
+				  IEEE80211_TX_RC_USE_SHORT_PREAMBLE);
+		alt_rate.count = rate->count;
+		if (rate_idx_match_legacy_mask(&alt_rate,
+					       txrc->sband->n_bitrates,
+					       mask)) {
+			*rate = alt_rate;
+			return;
+		}
+	} else {
+		struct sk_buff *skb = txrc->skb;
+		struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+		__le16 fc;
+
+		/* handle legacy rates */
+		if (rate_idx_match_legacy_mask(rate, txrc->sband->n_bitrates,
+					       mask))
+			return;
+
+		/* if HT BSS, and we handle a data frame, also try HT rates */
+		if (txrc->bss_conf->channel_type == NL80211_CHAN_NO_HT)
+			return;
+
+		fc = hdr->frame_control;
+		if (!ieee80211_is_data(fc))
+			return;
+
+		alt_rate.idx = 0;
+		/* keep protection flags */
+		alt_rate.flags = rate->flags &
+				 (IEEE80211_TX_RC_USE_RTS_CTS |
+				  IEEE80211_TX_RC_USE_CTS_PROTECT |
+				  IEEE80211_TX_RC_USE_SHORT_PREAMBLE);
+		alt_rate.count = rate->count;
+
+		alt_rate.flags |= IEEE80211_TX_RC_MCS;
+
+		if ((txrc->bss_conf->channel_type == NL80211_CHAN_HT40MINUS) ||
+		    (txrc->bss_conf->channel_type == NL80211_CHAN_HT40PLUS))
+			alt_rate.flags |= IEEE80211_TX_RC_40_MHZ_WIDTH;
+
+		if (rate_idx_match_mcs_mask(&alt_rate, mcs_mask)) {
+			*rate = alt_rate;
 			return;
 		}
 	}
@@ -335,6 +438,7 @@ void rate_control_get_rate(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(txrc->skb);
 	int i;
 	u32 mask;
+	u8 mcs_mask[IEEE80211_HT_MCS_MASK_LEN];
 
 	if (sta) {
 		ista = &sta->sta;
@@ -358,10 +462,14 @@ void rate_control_get_rate(struct ieee80211_sub_if_data *sdata,
 	 * the common case.
 	 */
 	mask = sdata->rc_rateidx_mask[info->band];
+	memcpy(mcs_mask, sdata->rc_rateidx_mcs_mask[info->band],
+	       sizeof(mcs_mask));
 	if (mask != (1 << txrc->sband->n_bitrates) - 1) {
 		if (sta) {
 			/* Filter out rates that the STA does not support */
 			mask &= sta->sta.supp_rates[info->band];
+			for (i = 0; i < sizeof(mcs_mask); i++)
+				mcs_mask[i] &= sta->sta.ht_cap.mcs.rx_mask[i];
 		}
 		/*
 		 * Make sure the rate index selected for each TX rate is
@@ -372,11 +480,8 @@ void rate_control_get_rate(struct ieee80211_sub_if_data *sdata,
 			/* Skip invalid rates */
 			if (info->control.rates[i].idx < 0)
 				break;
-			/* Rate masking supports only legacy rates for now */
-			if (info->control.rates[i].flags & IEEE80211_TX_RC_MCS)
-				continue;
-			rate_idx_match_mask(&info->control.rates[i],
-					    txrc->sband->n_bitrates, mask);
+			rate_idx_match_mask(&info->control.rates[i], txrc,
+					    mask, mcs_mask);
 		}
 	}
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index e74652d..5d8210c 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -639,6 +639,9 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 		txrc.max_rate_idx = -1;
 	else
 		txrc.max_rate_idx = fls(txrc.rate_idx_mask) - 1;
+	memcpy(txrc.rate_idx_mcs_mask,
+	       tx->sdata->rc_rateidx_mcs_mask[tx->channel->band],
+	       sizeof(txrc.rate_idx_mcs_mask));
 	txrc.bss = (tx->sdata->vif.type == NL80211_IFTYPE_AP ||
 		    tx->sdata->vif.type == NL80211_IFTYPE_MESH_POINT ||
 		    tx->sdata->vif.type == NL80211_IFTYPE_ADHOC);
@@ -2443,6 +2446,8 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 		txrc.max_rate_idx = -1;
 	else
 		txrc.max_rate_idx = fls(txrc.rate_idx_mask) - 1;
+	memcpy(txrc.rate_idx_mcs_mask, sdata->rc_rateidx_mcs_mask[band],
+	       sizeof(txrc.rate_idx_mcs_mask));
 	txrc.bss = true;
 	rate_control_get_rate(sdata, NULL, &txrc);
 
-- 
1.7.7.3

