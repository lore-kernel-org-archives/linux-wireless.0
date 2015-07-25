Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:35742 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755038AbbGYOcg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jul 2015 10:32:36 -0400
Received: by wibxm9 with SMTP id xm9so59847410wib.0
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2015 07:32:35 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [RFC 2/4] mac80211: remove ieee80211_tx_rate dependency in rate mask code
Date: Sat, 25 Jul 2015 16:32:27 +0200
Message-Id: <1437834749-23765-3-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20150725_163243_384492_68F5F2B2)
In-Reply-To: <1437834749-23765-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1437834749-23765-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove ieee80211_tx_rate dependency in rate_idx_match_legacy_mask(),
rate_idx_match_mcs_mask() and rate_idx_match_mask() in order to use the
previous logic to define a ratemask in rate_control_set_rates() for
station rate table. Moreover move rate mask definition logic in
rate_control_cap_mask()

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 net/mac80211/rate.c | 139 +++++++++++++++++++++++++++-------------------------
 1 file changed, 71 insertions(+), 68 deletions(-)

diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 4f02e07..4f61ca0 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -353,39 +353,37 @@ bool rate_control_send_low(struct ieee80211_sta *pubsta,
 }
 EXPORT_SYMBOL(rate_control_send_low);
 
-static bool rate_idx_match_legacy_mask(struct ieee80211_tx_rate *rate,
-				       int n_bitrates, u32 mask)
+static bool rate_idx_match_legacy_mask(s8 *rate_idx, int n_bitrates, u32 mask)
 {
 	int j;
 
 	/* See whether the selected rate or anything below it is allowed. */
-	for (j = rate->idx; j >= 0; j--) {
+	for (j = *rate_idx; j >= 0; j--) {
 		if (mask & (1 << j)) {
 			/* Okay, found a suitable rate. Use it. */
-			rate->idx = j;
+			*rate_idx = j;
 			return true;
 		}
 	}
 
 	/* Try to find a higher rate that would be allowed */
-	for (j = rate->idx + 1; j < n_bitrates; j++) {
+	for (j = *rate_idx + 1; j < n_bitrates; j++) {
 		if (mask & (1 << j)) {
 			/* Okay, found a suitable rate. Use it. */
-			rate->idx = j;
+			*rate_idx = j;
 			return true;
 		}
 	}
 	return false;
 }
 
-static bool rate_idx_match_mcs_mask(struct ieee80211_tx_rate *rate,
-				    u8 mcs_mask[IEEE80211_HT_MCS_MASK_LEN])
+static bool rate_idx_match_mcs_mask(s8 *rate_idx, u8 *mcs_mask)
 {
 	int i, j;
 	int ridx, rbit;
 
-	ridx = rate->idx / 8;
-	rbit = rate->idx % 8;
+	ridx = *rate_idx / 8;
+	rbit = *rate_idx % 8;
 
 	/* sanity check */
 	if (ridx < 0 || ridx >= IEEE80211_HT_MCS_MASK_LEN)
@@ -395,20 +393,20 @@ static bool rate_idx_match_mcs_mask(struct ieee80211_tx_rate *rate,
 	for (i = ridx; i >= 0; i--) {
 		for (j = rbit; j >= 0; j--)
 			if (mcs_mask[i] & BIT(j)) {
-				rate->idx = i * 8 + j;
+				*rate_idx = i * 8 + j;
 				return true;
 			}
 		rbit = 7;
 	}
 
 	/* Try to find a higher rate that would be allowed */
-	ridx = (rate->idx + 1) / 8;
-	rbit = (rate->idx + 1) % 8;
+	ridx = (*rate_idx + 1) / 8;
+	rbit = (*rate_idx + 1) % 8;
 
 	for (i = ridx; i < IEEE80211_HT_MCS_MASK_LEN; i++) {
 		for (j = rbit; j < 8; j++)
 			if (mcs_mask[i] & BIT(j)) {
-				rate->idx = i * 8 + j;
+				*rate_idx = i * 8 + j;
 				return true;
 			}
 		rbit = 0;
@@ -418,35 +416,30 @@ static bool rate_idx_match_mcs_mask(struct ieee80211_tx_rate *rate,
 
 
 
-static void rate_idx_match_mask(struct ieee80211_tx_rate *rate,
+static void rate_idx_match_mask(s8 *rate_idx, u16 *rate_flags,
 				struct ieee80211_supported_band *sband,
 				enum nl80211_chan_width chan_width,
 				u32 mask,
 				u8 mcs_mask[IEEE80211_HT_MCS_MASK_LEN])
 {
-	struct ieee80211_tx_rate alt_rate;
-
 	/* handle HT rates */
-	if (rate->flags & IEEE80211_TX_RC_MCS) {
-		if (rate_idx_match_mcs_mask(rate, mcs_mask))
+	if (*rate_flags & IEEE80211_TX_RC_MCS) {
+		if (rate_idx_match_mcs_mask(rate_idx, mcs_mask))
 			return;
 
 		/* also try the legacy rates. */
-		alt_rate.idx = 0;
+		*rate_idx = 0;
 		/* keep protection flags */
-		alt_rate.flags = rate->flags &
-				 (IEEE80211_TX_RC_USE_RTS_CTS |
-				  IEEE80211_TX_RC_USE_CTS_PROTECT |
-				  IEEE80211_TX_RC_USE_SHORT_PREAMBLE);
-		alt_rate.count = rate->count;
-		if (rate_idx_match_legacy_mask(&alt_rate,
-					       sband->n_bitrates, mask)) {
-			*rate = alt_rate;
+		*rate_flags &= (IEEE80211_TX_RC_USE_RTS_CTS |
+				IEEE80211_TX_RC_USE_CTS_PROTECT |
+				IEEE80211_TX_RC_USE_SHORT_PREAMBLE);
+		if (rate_idx_match_legacy_mask(rate_idx, sband->n_bitrates,
+					       mask))
 			return;
-		}
-	} else if (!(rate->flags & IEEE80211_TX_RC_VHT_MCS)) {
+	} else if (!(*rate_flags & IEEE80211_TX_RC_VHT_MCS)) {
 		/* handle legacy rates */
-		if (rate_idx_match_legacy_mask(rate, sband->n_bitrates, mask))
+		if (rate_idx_match_legacy_mask(rate_idx, sband->n_bitrates,
+					       mask))
 			return;
 
 		/* if HT BSS, and we handle a data frame, also try HT rates */
@@ -459,23 +452,19 @@ static void rate_idx_match_mask(struct ieee80211_tx_rate *rate,
 			break;
 		}
 
-		alt_rate.idx = 0;
+		*rate_idx = 0;
 		/* keep protection flags */
-		alt_rate.flags = rate->flags &
-				 (IEEE80211_TX_RC_USE_RTS_CTS |
-				  IEEE80211_TX_RC_USE_CTS_PROTECT |
-				  IEEE80211_TX_RC_USE_SHORT_PREAMBLE);
-		alt_rate.count = rate->count;
+		*rate_flags &= (IEEE80211_TX_RC_USE_RTS_CTS |
+				IEEE80211_TX_RC_USE_CTS_PROTECT |
+				IEEE80211_TX_RC_USE_SHORT_PREAMBLE);
 
-		alt_rate.flags |= IEEE80211_TX_RC_MCS;
+		*rate_flags |= IEEE80211_TX_RC_MCS;
 
 		if (chan_width == NL80211_CHAN_WIDTH_40)
-			alt_rate.flags |= IEEE80211_TX_RC_40_MHZ_WIDTH;
+			*rate_flags |= IEEE80211_TX_RC_40_MHZ_WIDTH;
 
-		if (rate_idx_match_mcs_mask(&alt_rate, mcs_mask)) {
-			*rate = alt_rate;
+		if (rate_idx_match_mcs_mask(rate_idx, mcs_mask))
 			return;
-		}
 	}
 
 	/*
@@ -628,6 +617,40 @@ static void rate_control_fill_sta_table(struct ieee80211_sta *sta,
 	}
 }
 
+static bool rate_control_cap_mask(struct ieee80211_sub_if_data *sdata,
+				  struct ieee80211_supported_band *sband,
+				  struct ieee80211_sta *sta, u32 *mask,
+				  u8 mcs_mask[IEEE80211_HT_MCS_MASK_LEN])
+{
+	u32 i, flags;
+
+	*mask = sdata->rc_rateidx_mask[sband->band];
+	flags = ieee80211_chandef_rate_flags(&sdata->vif.bss_conf.chandef);
+	for (i = 0; i < sband->n_bitrates; i++) {
+		if ((flags & sband->bitrates[i].flags) != flags)
+			*mask &= ~BIT(i);
+	}
+
+	if (*mask == (1 << sband->n_bitrates) - 1 &&
+	    !sdata->rc_has_mcs_mask[sband->band])
+		return false;
+
+	if (sdata->rc_has_mcs_mask[sband->band])
+		memcpy(mcs_mask, sdata->rc_rateidx_mcs_mask[sband->band],
+		       IEEE80211_HT_MCS_MASK_LEN);
+	else
+		memset(mcs_mask, 0xff, IEEE80211_HT_MCS_MASK_LEN);
+
+	if (sta) {
+		/* Filter out rates that the STA does not support */
+		*mask &= sta->supp_rates[sband->band];
+		for (i = 0; i < sizeof(mcs_mask); i++)
+			mcs_mask[i] &= sta->ht_cap.mcs.rx_mask[i];
+	}
+
+	return true;
+}
+
 static void rate_control_apply_mask(struct ieee80211_sub_if_data *sdata,
 				    struct ieee80211_sta *sta,
 				    struct ieee80211_supported_band *sband,
@@ -636,9 +659,8 @@ static void rate_control_apply_mask(struct ieee80211_sub_if_data *sdata,
 {
 	enum nl80211_chan_width chan_width;
 	u8 mcs_mask[IEEE80211_HT_MCS_MASK_LEN];
-	bool has_mcs_mask;
 	u32 mask;
-	u32 rate_flags;
+	u16 rate_flags;
 	int i;
 
 	/*
@@ -646,30 +668,9 @@ static void rate_control_apply_mask(struct ieee80211_sub_if_data *sdata,
 	 * default mask (allow all rates) is used to save some processing for
 	 * the common case.
 	 */
-	mask = sdata->rc_rateidx_mask[sband->band];
-	has_mcs_mask = sdata->rc_has_mcs_mask[sband->band];
-	rate_flags =
-		ieee80211_chandef_rate_flags(&sdata->vif.bss_conf.chandef);
-	for (i = 0; i < sband->n_bitrates; i++)
-		if ((rate_flags & sband->bitrates[i].flags) != rate_flags)
-			mask &= ~BIT(i);
-
-	if (mask == (1 << sband->n_bitrates) - 1 && !has_mcs_mask)
+	if (!rate_control_cap_mask(sdata, sband, sta, &mask, mcs_mask))
 		return;
 
-	if (has_mcs_mask)
-		memcpy(mcs_mask, sdata->rc_rateidx_mcs_mask[sband->band],
-		       sizeof(mcs_mask));
-	else
-		memset(mcs_mask, 0xff, sizeof(mcs_mask));
-
-	if (sta) {
-		/* Filter out rates that the STA does not support */
-		mask &= sta->supp_rates[sband->band];
-		for (i = 0; i < sizeof(mcs_mask); i++)
-			mcs_mask[i] &= sta->ht_cap.mcs.rx_mask[i];
-	}
-
 	/*
 	 * Make sure the rate index selected for each TX rate is
 	 * included in the configured mask and change the rate indexes
@@ -681,8 +682,10 @@ static void rate_control_apply_mask(struct ieee80211_sub_if_data *sdata,
 		if (rates[i].idx < 0)
 			break;
 
-		rate_idx_match_mask(&rates[i], sband, chan_width, mask,
-				    mcs_mask);
+		rate_flags = rates[i].flags;
+		rate_idx_match_mask(&rates[i].idx, &rate_flags, sband,
+				    chan_width, mask, mcs_mask);
+		rates[i].flags = rate_flags;
 	}
 }
 
-- 
2.1.4

