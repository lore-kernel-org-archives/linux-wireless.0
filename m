Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:46100 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756693Ab2AET6Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jan 2012 14:58:16 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, Johannes Berg <johannes@sipsolutions.net>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: [PATCHv2 2/2] mac80211: add support for mcs masks
Date: Thu,  5 Jan 2012 20:58:08 +0100
Message-Id: <1325793490-21501-3-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20120105_205822_986972_C0AEB58E)
In-Reply-To: <1325793490-21501-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1325793490-21501-1-git-send-email-siwu@hrz.tu-chemnitz.de>
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
 net/mac80211/iface.c          |    7 ++
 net/mac80211/rate.c           |  124 ++++++++++++++++++++++++++++++++++++++---
 net/mac80211/tx.c             |    5 ++
 7 files changed, 168 insertions(+), 9 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 2a7523e..eaeaf56 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3540,6 +3540,7 @@ struct ieee80211_tx_rate_control {
 	bool rts, short_preamble;
 	u8 max_rate_idx;
 	u32 rate_idx_mask;
+	u8 rate_idx_mcs_mask[IEEE80211_HT_MCS_MASK_LEN];
 	bool bss;
 };
 
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 850bb96..cffcd92 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1907,8 +1907,11 @@ static int ieee80211_set_bitrate_mask(struct wiphy *wiphy,
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
index 176c08f..94987ac 100644
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
@@ -441,6 +461,8 @@ static void add_sta_files(struct ieee80211_sub_if_data *sdata)
 	DEBUGFS_ADD(channel_type);
 	DEBUGFS_ADD(rc_rateidx_mask_2ghz);
 	DEBUGFS_ADD(rc_rateidx_mask_5ghz);
+	DEBUGFS_ADD(rc_rateidx_mcs_mask_2ghz);
+	DEBUGFS_ADD(rc_rateidx_mcs_mask_5ghz);
 
 	DEBUGFS_ADD(bssid);
 	DEBUGFS_ADD(aid);
@@ -458,6 +480,8 @@ static void add_ap_files(struct ieee80211_sub_if_data *sdata)
 	DEBUGFS_ADD(channel_type);
 	DEBUGFS_ADD(rc_rateidx_mask_2ghz);
 	DEBUGFS_ADD(rc_rateidx_mask_5ghz);
+	DEBUGFS_ADD(rc_rateidx_mcs_mask_2ghz);
+	DEBUGFS_ADD(rc_rateidx_mcs_mask_5ghz);
 
 	DEBUGFS_ADD(num_sta_authorized);
 	DEBUGFS_ADD(num_sta_ps);
@@ -468,6 +492,12 @@ static void add_ap_files(struct ieee80211_sub_if_data *sdata)
 
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
 
@@ -479,6 +509,8 @@ static void add_wds_files(struct ieee80211_sub_if_data *sdata)
 	DEBUGFS_ADD(channel_type);
 	DEBUGFS_ADD(rc_rateidx_mask_2ghz);
 	DEBUGFS_ADD(rc_rateidx_mask_5ghz);
+	DEBUGFS_ADD(rc_rateidx_mcs_mask_2ghz);
+	DEBUGFS_ADD(rc_rateidx_mcs_mask_5ghz);
 
 	DEBUGFS_ADD(peer);
 }
@@ -491,6 +523,8 @@ static void add_vlan_files(struct ieee80211_sub_if_data *sdata)
 	DEBUGFS_ADD(channel_type);
 	DEBUGFS_ADD(rc_rateidx_mask_2ghz);
 	DEBUGFS_ADD(rc_rateidx_mask_5ghz);
+	DEBUGFS_ADD(rc_rateidx_mcs_mask_2ghz);
+	DEBUGFS_ADD(rc_rateidx_mcs_mask_5ghz);
 }
 
 static void add_monitor_files(struct ieee80211_sub_if_data *sdata)
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index c3f3e43..e040e90 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -646,6 +646,7 @@ struct ieee80211_sub_if_data {
 
 	/* bitmap of allowed (non-MCS) rate indexes for rate control */
 	u32 rc_rateidx_mask[IEEE80211_NUM_BANDS];
+	u8  rc_rateidx_mcs_mask[IEEE80211_NUM_BANDS][IEEE80211_HT_MCS_MASK_LEN];
 
 	union {
 		struct ieee80211_if_ap ap;
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index e47768c..1094a58 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1181,6 +1181,13 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 		sband = local->hw.wiphy->bands[i];
 		sdata->rc_rateidx_mask[i] =
 			sband ? (1 << sband->n_bitrates) - 1 : 0;
+		if (sband)
+			memcpy(sdata->rc_rateidx_mcs_mask[i],
+			       sband->ht_cap.mcs.rx_mask,
+			       sizeof(sdata->rc_rateidx_mcs_mask[i]));
+		else
+			memset(sdata->rc_rateidx_mcs_mask[i], 0,
+			       sizeof(sdata->rc_rateidx_mcs_mask[i]));
 	}
 
 	/* setup type-dependent data */
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 5a5a776..ebec8e2 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -293,8 +293,8 @@ bool rate_control_send_low(struct ieee80211_sta *sta,
 }
 EXPORT_SYMBOL(rate_control_send_low);
 
-static void rate_idx_match_mask(struct ieee80211_tx_rate *rate,
-				int n_bitrates, u32 mask)
+static bool rate_idx_match_legacy_mask(struct ieee80211_tx_rate *rate,
+				       int n_bitrates, u32 mask)
 {
 	int j;
 
@@ -303,7 +303,7 @@ static void rate_idx_match_mask(struct ieee80211_tx_rate *rate,
 		if (mask & (1 << j)) {
 			/* Okay, found a suitable rate. Use it. */
 			rate->idx = j;
-			return;
+			return true;
 		}
 	}
 
@@ -312,6 +312,112 @@ static void rate_idx_match_mask(struct ieee80211_tx_rate *rate,
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
+	/* sanity check */
+	if (ridx < 0 || ridx > IEEE80211_HT_MCS_MASK_LEN)
+		return false;
+
+	/* See whether the selected rate or anything below it is allowed. */
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
@@ -335,6 +441,7 @@ void rate_control_get_rate(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(txrc->skb);
 	int i;
 	u32 mask;
+	u8 mcs_mask[IEEE80211_HT_MCS_MASK_LEN];
 
 	if (sta) {
 		ista = &sta->sta;
@@ -358,10 +465,14 @@ void rate_control_get_rate(struct ieee80211_sub_if_data *sdata,
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
@@ -372,11 +483,8 @@ void rate_control_get_rate(struct ieee80211_sub_if_data *sdata,
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
index edcd1c7..23b3cf2 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -635,6 +635,9 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 		txrc.max_rate_idx = -1;
 	else
 		txrc.max_rate_idx = fls(txrc.rate_idx_mask) - 1;
+	memcpy(txrc.rate_idx_mcs_mask,
+	       tx->sdata->rc_rateidx_mcs_mask[tx->channel->band],
+	       sizeof(txrc.rate_idx_mcs_mask));
 	txrc.bss = (tx->sdata->vif.type == NL80211_IFTYPE_AP ||
 		    tx->sdata->vif.type == NL80211_IFTYPE_MESH_POINT ||
 		    tx->sdata->vif.type == NL80211_IFTYPE_ADHOC);
@@ -2439,6 +2442,8 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 		txrc.max_rate_idx = -1;
 	else
 		txrc.max_rate_idx = fls(txrc.rate_idx_mask) - 1;
+	memcpy(txrc.rate_idx_mcs_mask, sdata->rc_rateidx_mcs_mask[band],
+	       sizeof(txrc.rate_idx_mcs_mask));
 	txrc.bss = true;
 	rate_control_get_rate(sdata, NULL, &txrc);
 
-- 
1.7.7.3

