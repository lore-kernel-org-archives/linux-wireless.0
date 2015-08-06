Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:35204 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756071AbbHFVrn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2015 17:47:43 -0400
Received: by wibxm9 with SMTP id xm9so39048913wib.0
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2015 14:47:42 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH 4/4] mac80211: add rate mask logic for vht rates
Date: Thu,  6 Aug 2015 23:47:33 +0200
Message-Id: <1438897653-4629-5-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20150806_234748_907695_1EB50B1B)
In-Reply-To: <1438897653-4629-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1438897653-4629-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Define rc_rateidx_vht_mcs_mask array and rate_idx_match_vht_mcs_mask()
method in order to apply mcs mask for vht rates

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 net/mac80211/cfg.c            |  16 +++++--
 net/mac80211/debugfs_netdev.c |  34 ++++++++++++++
 net/mac80211/ieee80211_i.h    |   5 +++
 net/mac80211/iface.c          |  14 +++++-
 net/mac80211/rate.c           | 102 +++++++++++++++++++++++++++++++++++++-----
 net/mac80211/vht.c            |  27 +++++++++++
 6 files changed, 182 insertions(+), 16 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 5789d83..685ec13 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2504,16 +2504,26 @@ static int ieee80211_set_bitrate_mask(struct wiphy *wiphy,
 		sdata->rc_rateidx_mask[i] = mask->control[i].legacy;
 		memcpy(sdata->rc_rateidx_mcs_mask[i], mask->control[i].ht_mcs,
 		       sizeof(mask->control[i].ht_mcs));
+		memcpy(sdata->rc_rateidx_vht_mcs_mask[i],
+		       mask->control[i].vht_mcs,
+		       sizeof(mask->control[i].vht_mcs));
 
 		sdata->rc_has_mcs_mask[i] = false;
+		sdata->rc_has_vht_mcs_mask[i] = false;
 		if (!sband)
 			continue;
 
-		for (j = 0; j < IEEE80211_HT_MCS_MASK_LEN; j++)
-			if (~sdata->rc_rateidx_mcs_mask[i][j]) {
+		for (j = 0; j < IEEE80211_HT_MCS_MASK_LEN; j++) {
+			if (~sdata->rc_rateidx_mcs_mask[i][j])
 				sdata->rc_has_mcs_mask[i] = true;
+
+			if (~sdata->rc_rateidx_vht_mcs_mask[i][j])
+				sdata->rc_has_vht_mcs_mask[i] = true;
+
+			if (sdata->rc_has_mcs_mask[i] &&
+			    sdata->rc_has_vht_mcs_mask[i])
 				break;
-			}
+		}
 	}
 
 	return 0;
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index c09c013..1021e87 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -186,6 +186,38 @@ IEEE80211_IF_FILE(rc_rateidx_mcs_mask_2ghz,
 IEEE80211_IF_FILE(rc_rateidx_mcs_mask_5ghz,
 		  rc_rateidx_mcs_mask[IEEE80211_BAND_5GHZ], HEXARRAY);
 
+static ssize_t ieee80211_if_fmt_rc_rateidx_vht_mcs_mask_2ghz(
+				const struct ieee80211_sub_if_data *sdata,
+				char *buf, int buflen)
+{
+	int i, len = 0;
+	const u16 *mask = sdata->rc_rateidx_vht_mcs_mask[IEEE80211_BAND_2GHZ];
+
+	for (i = 0; i < NL80211_VHT_NSS_MAX; i++)
+		len += scnprintf(buf + len, buflen - len, "%04x ", mask[i]);
+	len += scnprintf(buf + len, buflen - len, "\n");
+
+	return len;
+}
+
+IEEE80211_IF_FILE_R(rc_rateidx_vht_mcs_mask_2ghz);
+
+static ssize_t ieee80211_if_fmt_rc_rateidx_vht_mcs_mask_5ghz(
+				const struct ieee80211_sub_if_data *sdata,
+				char *buf, int buflen)
+{
+	int i, len = 0;
+	const u16 *mask = sdata->rc_rateidx_vht_mcs_mask[IEEE80211_BAND_5GHZ];
+
+	for (i = 0; i < NL80211_VHT_NSS_MAX; i++)
+		len += scnprintf(buf + len, buflen - len, "%04x ", mask[i]);
+	len += scnprintf(buf + len, buflen - len, "\n");
+
+	return len;
+}
+
+IEEE80211_IF_FILE_R(rc_rateidx_vht_mcs_mask_5ghz);
+
 IEEE80211_IF_FILE(flags, flags, HEX);
 IEEE80211_IF_FILE(state, state, LHEX);
 IEEE80211_IF_FILE(txpower, vif.bss_conf.txpower, DEC);
@@ -565,6 +597,8 @@ static void add_common_files(struct ieee80211_sub_if_data *sdata)
 	DEBUGFS_ADD(rc_rateidx_mask_5ghz);
 	DEBUGFS_ADD(rc_rateidx_mcs_mask_2ghz);
 	DEBUGFS_ADD(rc_rateidx_mcs_mask_5ghz);
+	DEBUGFS_ADD(rc_rateidx_vht_mcs_mask_2ghz);
+	DEBUGFS_ADD(rc_rateidx_vht_mcs_mask_5ghz);
 	DEBUGFS_ADD(hw_queues);
 }
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 36f217e..6e52659 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -901,6 +901,9 @@ struct ieee80211_sub_if_data {
 	bool rc_has_mcs_mask[IEEE80211_NUM_BANDS];
 	u8  rc_rateidx_mcs_mask[IEEE80211_NUM_BANDS][IEEE80211_HT_MCS_MASK_LEN];
 
+	bool rc_has_vht_mcs_mask[IEEE80211_NUM_BANDS];
+	u16 rc_rateidx_vht_mcs_mask[IEEE80211_NUM_BANDS][NL80211_VHT_NSS_MAX];
+
 	union {
 		struct ieee80211_if_ap ap;
 		struct ieee80211_if_wds wds;
@@ -1713,6 +1716,8 @@ void ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
 				 enum ieee80211_band band, bool nss_only);
 void ieee80211_apply_vhtcap_overrides(struct ieee80211_sub_if_data *sdata,
 				      struct ieee80211_sta_vht_cap *vht_cap);
+void ieee80211_get_vht_mask_from_cap(__le16 vht_cap,
+				     u16 vht_mask[NL80211_VHT_NSS_MAX]);
 
 /* Spectrum management */
 void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 0fba7f9..6964fc6 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1788,13 +1788,23 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 		sband = local->hw.wiphy->bands[i];
 		sdata->rc_rateidx_mask[i] =
 			sband ? (1 << sband->n_bitrates) - 1 : 0;
-		if (sband)
+		if (sband) {
+			__le16 cap;
+			u16 *vht_rate_mask;
+
 			memcpy(sdata->rc_rateidx_mcs_mask[i],
 			       sband->ht_cap.mcs.rx_mask,
 			       sizeof(sdata->rc_rateidx_mcs_mask[i]));
-		else
+
+			cap = sband->vht_cap.vht_mcs.rx_mcs_map;
+			vht_rate_mask = sdata->rc_rateidx_vht_mcs_mask[i];
+			ieee80211_get_vht_mask_from_cap(cap, vht_rate_mask);
+		} else {
 			memset(sdata->rc_rateidx_mcs_mask[i], 0,
 			       sizeof(sdata->rc_rateidx_mcs_mask[i]));
+			memset(sdata->rc_rateidx_vht_mcs_mask[i], 0,
+			       sizeof(sdata->rc_rateidx_vht_mcs_mask[i]));
+		}
 	}
 
 	ieee80211_set_default_queues(sdata);
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 7e71de9..9857693 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -414,16 +414,77 @@ static bool rate_idx_match_mcs_mask(s8 *rate_idx, u8 *mcs_mask)
 	return false;
 }
 
+static bool rate_idx_match_vht_mcs_mask(s8 *rate_idx, u16 *vht_mask)
+{
+	int i, j;
+	int ridx, rbit;
+
+	ridx = *rate_idx >> 4;
+	rbit = *rate_idx & 0xf;
+
+	if (ridx < 0 || ridx >= NL80211_VHT_NSS_MAX)
+		return false;
 
+	/* See whether the selected rate or anything below it is allowed. */
+	for (i = ridx; i >= 0; i--) {
+		for (j = rbit; j >= 0; j--) {
+			if (vht_mask[i] & BIT(j)) {
+				*rate_idx = (i << 4) | j;
+				return true;
+			}
+		}
+		rbit = 15;
+	}
+
+	/* Try to find a higher rate that would be allowed */
+	ridx = (*rate_idx + 1) >> 4;
+	rbit = (*rate_idx + 1) & 0xf;
+
+	for (i = ridx; i < NL80211_VHT_NSS_MAX; i++) {
+		for (j = rbit; j < 16; j++) {
+			if (vht_mask[i] & BIT(j)) {
+				*rate_idx = (i << 4) | j;
+				return true;
+			}
+		}
+		rbit = 0;
+	}
+	return false;
+}
 
 static void rate_idx_match_mask(s8 *rate_idx, u16 *rate_flags,
 				struct ieee80211_supported_band *sband,
 				enum nl80211_chan_width chan_width,
 				u32 mask,
-				u8 mcs_mask[IEEE80211_HT_MCS_MASK_LEN])
+				u8 mcs_mask[IEEE80211_HT_MCS_MASK_LEN],
+				u16 vht_mask[NL80211_VHT_NSS_MAX])
 {
-	/* handle HT rates */
-	if (*rate_flags & IEEE80211_TX_RC_MCS) {
+	if (*rate_flags & IEEE80211_TX_RC_VHT_MCS) {
+		/* handle VHT rates */
+		if (rate_idx_match_vht_mcs_mask(rate_idx, vht_mask))
+			return;
+
+		*rate_idx = 0;
+		/* keep protection flags */
+		*rate_flags &= (IEEE80211_TX_RC_USE_RTS_CTS |
+				IEEE80211_TX_RC_USE_CTS_PROTECT |
+				IEEE80211_TX_RC_USE_SHORT_PREAMBLE);
+
+		*rate_flags |= IEEE80211_TX_RC_MCS;
+		if (chan_width == NL80211_CHAN_WIDTH_40)
+			*rate_flags |= IEEE80211_TX_RC_40_MHZ_WIDTH;
+
+		if (rate_idx_match_mcs_mask(rate_idx, mcs_mask))
+			return;
+
+		/* also try the legacy rates. */
+		*rate_flags &= ~(IEEE80211_TX_RC_MCS |
+				 IEEE80211_TX_RC_40_MHZ_WIDTH);
+		if (rate_idx_match_legacy_mask(rate_idx, sband->n_bitrates,
+					       mask))
+			return;
+	} else if (*rate_flags & IEEE80211_TX_RC_MCS) {
+		/* handle HT rates */
 		if (rate_idx_match_mcs_mask(rate_idx, mcs_mask))
 			return;
 
@@ -436,7 +497,7 @@ static void rate_idx_match_mask(s8 *rate_idx, u16 *rate_flags,
 		if (rate_idx_match_legacy_mask(rate_idx, sband->n_bitrates,
 					       mask))
 			return;
-	} else if (!(*rate_flags & IEEE80211_TX_RC_VHT_MCS)) {
+	} else {
 		/* handle legacy rates */
 		if (rate_idx_match_legacy_mask(rate_idx, sband->n_bitrates,
 					       mask))
@@ -620,7 +681,8 @@ static void rate_control_fill_sta_table(struct ieee80211_sta *sta,
 static bool rate_control_cap_mask(struct ieee80211_sub_if_data *sdata,
 				  struct ieee80211_supported_band *sband,
 				  struct ieee80211_sta *sta, u32 *mask,
-				  u8 mcs_mask[IEEE80211_HT_MCS_MASK_LEN])
+				  u8 mcs_mask[IEEE80211_HT_MCS_MASK_LEN],
+				  u16 vht_mask[NL80211_VHT_NSS_MAX])
 {
 	u32 i, flags;
 
@@ -632,7 +694,8 @@ static bool rate_control_cap_mask(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (*mask == (1 << sband->n_bitrates) - 1 &&
-	    !sdata->rc_has_mcs_mask[sband->band])
+	    !sdata->rc_has_mcs_mask[sband->band] &&
+	    !sdata->rc_has_vht_mcs_mask[sband->band])
 		return false;
 
 	if (sdata->rc_has_mcs_mask[sband->band])
@@ -641,11 +704,25 @@ static bool rate_control_cap_mask(struct ieee80211_sub_if_data *sdata,
 	else
 		memset(mcs_mask, 0xff, IEEE80211_HT_MCS_MASK_LEN);
 
+	if (sdata->rc_has_vht_mcs_mask[sband->band])
+		memcpy(vht_mask, sdata->rc_rateidx_vht_mcs_mask[sband->band],
+		       sizeof(u16) * NL80211_VHT_NSS_MAX);
+	else
+		memset(vht_mask, 0xff, sizeof(u16) * NL80211_VHT_NSS_MAX);
+
 	if (sta) {
+		__le16 sta_vht_cap;
+		u16 sta_vht_mask[NL80211_VHT_NSS_MAX];
+
 		/* Filter out rates that the STA does not support */
 		*mask &= sta->supp_rates[sband->band];
 		for (i = 0; i < sizeof(mcs_mask); i++)
 			mcs_mask[i] &= sta->ht_cap.mcs.rx_mask[i];
+
+		sta_vht_cap = sta->vht_cap.vht_mcs.rx_mcs_map;
+		ieee80211_get_vht_mask_from_cap(sta_vht_cap, sta_vht_mask);
+		for (i = 0; i < NL80211_VHT_NSS_MAX; i++)
+			vht_mask[i] &= sta_vht_mask[i];
 	}
 
 	return true;
@@ -659,10 +736,11 @@ rate_control_apply_mask_ratetbl(struct sta_info *sta,
 	int i;
 	u32 mask;
 	u8 mcs_mask[IEEE80211_HT_MCS_MASK_LEN];
+	u16 vht_mask[NL80211_VHT_NSS_MAX];
 	enum nl80211_chan_width chan_width;
 
 	if (!rate_control_cap_mask(sta->sdata, sband, &sta->sta, &mask,
-				   mcs_mask))
+				   mcs_mask, vht_mask))
 		return;
 
 	chan_width = sta->sdata->vif.bss_conf.chandef.width;
@@ -671,7 +749,8 @@ rate_control_apply_mask_ratetbl(struct sta_info *sta,
 			break;
 
 		rate_idx_match_mask(&rates->rate[i].idx, &rates->rate[i].flags,
-				    sband, chan_width, mask, mcs_mask);
+				    sband, chan_width, mask, mcs_mask,
+				    vht_mask);
 	}
 }
 
@@ -684,7 +763,7 @@ static void rate_control_apply_mask(struct ieee80211_sub_if_data *sdata,
 	enum nl80211_chan_width chan_width;
 	u8 mcs_mask[IEEE80211_HT_MCS_MASK_LEN];
 	u32 mask;
-	u16 rate_flags;
+	u16 rate_flags, vht_mask[NL80211_VHT_NSS_MAX];
 	int i;
 
 	/*
@@ -692,7 +771,8 @@ static void rate_control_apply_mask(struct ieee80211_sub_if_data *sdata,
 	 * default mask (allow all rates) is used to save some processing for
 	 * the common case.
 	 */
-	if (!rate_control_cap_mask(sdata, sband, sta, &mask, mcs_mask))
+	if (!rate_control_cap_mask(sdata, sband, sta, &mask, mcs_mask,
+				   vht_mask))
 		return;
 
 	/*
@@ -708,7 +788,7 @@ static void rate_control_apply_mask(struct ieee80211_sub_if_data *sdata,
 
 		rate_flags = rates[i].flags;
 		rate_idx_match_mask(&rates[i].idx, &rate_flags, sband,
-				    chan_width, mask, mcs_mask);
+				    chan_width, mask, mcs_mask, vht_mask);
 		rates[i].flags = rate_flags;
 	}
 }
diff --git a/net/mac80211/vht.c b/net/mac80211/vht.c
index f05808d..cfe583a 100644
--- a/net/mac80211/vht.c
+++ b/net/mac80211/vht.c
@@ -426,3 +426,30 @@ void ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
 	if (changed > 0)
 		rate_control_rate_update(local, sband, sta, changed);
 }
+
+void ieee80211_get_vht_mask_from_cap(__le16 vht_cap,
+				     u16 vht_mask[NL80211_VHT_NSS_MAX])
+{
+	int i;
+	u16 mask, cap = le16_to_cpu(vht_cap);
+
+	for (i = 0; i < NL80211_VHT_NSS_MAX; i++) {
+		mask = (cap >> i * 2) & IEEE80211_VHT_MCS_NOT_SUPPORTED;
+		switch (mask) {
+		case IEEE80211_VHT_MCS_SUPPORT_0_7:
+			vht_mask[i] = 0x00FF;
+			break;
+		case IEEE80211_VHT_MCS_SUPPORT_0_8:
+			vht_mask[i] = 0x01FF;
+			break;
+		case IEEE80211_VHT_MCS_SUPPORT_0_9:
+			vht_mask[i] = 0x03FF;
+			break;
+		case IEEE80211_VHT_MCS_NOT_SUPPORTED:
+		default:
+			vht_mask[i] = 0;
+			break;
+		}
+	}
+}
+
-- 
2.1.4

