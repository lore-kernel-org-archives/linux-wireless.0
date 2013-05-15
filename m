Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:40292 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759281Ab3EOOTj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 May 2013 10:19:39 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv2 06/18] mac80211: choose bitrate table according to bandwidth
Date: Wed, 15 May 2013 16:18:57 +0200
Message-Id: <1368627549-22518-7-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130515_162936_511722_7E7B9B98)
In-Reply-To: <1368627549-22518-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1368627549-22518-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For situations where a reduced bandwidth (5 MHz, 10 MHz) is used, the
bitrates used internally (for building/interpreting IEs, rate control,
etc) must change accordingly. Therefore add bitrates_half and
bitrates_quarter bitrate table according to the currently selected
mode. Only drivers which support these modes have to fill these
tables.

This patch touches a lot of components, but is usually only selecting
the right bitrate table, returning an error if this is not possible or
falls back to the standard bitrate table.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 include/net/mac80211.h             |   36 +++++++++++--
 net/mac80211/cfg.c                 |   50 +++++++++++++++---
 net/mac80211/ibss.c                |   28 ++++++++---
 net/mac80211/ieee80211_i.h         |    2 +
 net/mac80211/iface.c               |    5 ++
 net/mac80211/main.c                |    5 +-
 net/mac80211/mesh_plink.c          |   10 +++-
 net/mac80211/mlme.c                |   55 ++++++++++++++------
 net/mac80211/rate.c                |   94 +++++++++++++++++++++++-----------
 net/mac80211/rc80211_minstrel.c    |   47 +++++++++++------
 net/mac80211/rc80211_minstrel_ht.c |   18 +++++--
 net/mac80211/rc80211_pid.h         |    2 +
 net/mac80211/rc80211_pid_algo.c    |   68 +++++++++++++++++++------
 net/mac80211/rx.c                  |   29 +++++++++--
 net/mac80211/status.c              |   15 ++++--
 net/mac80211/tx.c                  |   33 +++++++++---
 net/mac80211/util.c                |   98 +++++++++++++++++++++++++++++-------
 17 files changed, 464 insertions(+), 131 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 04c2d46..3e52e22 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1648,27 +1648,54 @@ static inline struct ieee80211_rate *
 ieee80211_get_tx_rate(const struct ieee80211_hw *hw,
 		      const struct ieee80211_tx_info *c)
 {
+	struct ieee80211_rate *bitrates;
+	int n_bitrates;
+
 	if (WARN_ON_ONCE(c->control.rates[0].idx < 0))
 		return NULL;
-	return &hw->wiphy->bands[c->band]->bitrates[c->control.rates[0].idx];
+
+	if (WARN_ON(ieee80211_get_bitrates(hw->wiphy->bands[c->band],
+					   hw->conf.chandef.width,
+					   &bitrates, &n_bitrates)))
+		return NULL;
+
+	return &bitrates[c->control.rates[0].idx];
 }
 
 static inline struct ieee80211_rate *
 ieee80211_get_rts_cts_rate(const struct ieee80211_hw *hw,
 			   const struct ieee80211_tx_info *c)
 {
+	struct ieee80211_rate *bitrates;
+	int n_bitrates;
+
 	if (c->control.rts_cts_rate_idx < 0)
 		return NULL;
-	return &hw->wiphy->bands[c->band]->bitrates[c->control.rts_cts_rate_idx];
+
+	if (WARN_ON(ieee80211_get_bitrates(hw->wiphy->bands[c->band],
+					   hw->conf.chandef.width,
+					   &bitrates, &n_bitrates)))
+		return NULL;
+
+	return &bitrates[c->control.rts_cts_rate_idx];
 }
 
 static inline struct ieee80211_rate *
 ieee80211_get_alt_retry_rate(const struct ieee80211_hw *hw,
 			     const struct ieee80211_tx_info *c, int idx)
 {
+	struct ieee80211_rate *bitrates;
+	int n_bitrates;
+
 	if (c->control.rates[idx + 1].idx < 0)
 		return NULL;
-	return &hw->wiphy->bands[c->band]->bitrates[c->control.rates[idx + 1].idx];
+
+	if (WARN_ON(ieee80211_get_bitrates(hw->wiphy->bands[c->band],
+					   hw->conf.chandef.width,
+					   &bitrates, &n_bitrates)))
+		return NULL;
+
+	return &bitrates[c->control.rates[idx + 1].idx];
 }
 
 /**
@@ -4235,11 +4262,12 @@ bool rate_control_send_low(struct ieee80211_sta *sta,
 
 static inline s8
 rate_lowest_index(struct ieee80211_supported_band *sband,
+		  int n_bitrates,
 		  struct ieee80211_sta *sta)
 {
 	int i;
 
-	for (i = 0; i < sband->n_bitrates; i++)
+	for (i = 0; i < n_bitrates; i++)
 		if (rate_supported(sta, sband->band, i))
 			return i;
 
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 1a89c80..4657f1b 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -392,9 +392,19 @@ void sta_set_rate_info_tx(struct sta_info *sta,
 		rinfo->nss = ieee80211_rate_get_vht_nss(rate);
 	} else {
 		struct ieee80211_supported_band *sband;
+		struct ieee80211_hw *hw;
+		struct ieee80211_rate *bitrates;
+		int n_bitrates;
+
 		sband = sta->local->hw.wiphy->bands[
 				ieee80211_get_sdata_band(sta->sdata)];
-		rinfo->legacy = sband->bitrates[rate->idx].bitrate;
+		hw = &sta->sdata->local->hw;
+		if (ieee80211_get_bitrates(sband, hw->conf.chandef.width,
+					   &bitrates, &n_bitrates)) {
+			bitrates = sband->bitrates;
+			n_bitrates = sband->n_bitrates;
+		}
+		rinfo->legacy = bitrates[rate->idx].bitrate;
 	}
 	if (rate->flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
 		rinfo->flags |= RATE_INFO_FLAGS_40_MHZ_WIDTH;
@@ -419,11 +429,21 @@ void sta_set_rate_info_rx(struct sta_info *sta, struct rate_info *rinfo)
 		rinfo->mcs = sta->last_rx_rate_idx;
 	} else {
 		struct ieee80211_supported_band *sband;
+		struct ieee80211_rate *bitrates;
+		struct ieee80211_hw *hw;
+		int n_bitrates;
 
 		sband = sta->local->hw.wiphy->bands[
 				ieee80211_get_sdata_band(sta->sdata)];
+		hw = &sta->sdata->local->hw;
+		if (ieee80211_get_bitrates(sband, hw->conf.chandef.width,
+					   &bitrates, &n_bitrates)) {
+			bitrates = sband->bitrates;
+			n_bitrates = sband->n_bitrates;
+		}
+
 		rinfo->legacy =
-			sband->bitrates[sta->last_rx_rate_idx].bitrate;
+			bitrates[sta->last_rx_rate_idx].bitrate;
 	}
 
 	if (sta->last_rx_rate_flag & RX_FLAG_40MHZ)
@@ -1264,12 +1284,20 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 		sta->listen_interval = params->listen_interval;
 
 	if (params->supported_rates) {
+		struct ieee80211_rate *bitrates;
+		int n_bitrates;
 		rates = 0;
 
+		if (ieee80211_get_bitrates(sband, local->hw.conf.chandef.width,
+					   &bitrates, &n_bitrates)) {
+			bitrates = sband->bitrates;
+			n_bitrates = sband->n_bitrates;
+		}
+
 		for (i = 0; i < params->supported_rates_len; i++) {
 			int rate = (params->supported_rates[i] & 0x7f) * 5;
-			for (j = 0; j < sband->n_bitrates; j++) {
-				if (sband->bitrates[j].bitrate == rate)
+			for (j = 0; j < n_bitrates; j++) {
+				if (bitrates[j].bitrate == rate)
 					rates |= BIT(j);
 			}
 		}
@@ -1935,11 +1963,21 @@ static int ieee80211_change_bss(struct wiphy *wiphy,
 		int i, j;
 		u32 rates = 0;
 		struct ieee80211_supported_band *sband = wiphy->bands[band];
+		struct ieee80211_hw *hw;
+		struct ieee80211_rate *bitrates;
+		int n_bitrates;
+
+		hw = &sdata->local->hw;
+		if (ieee80211_get_bitrates(sband, hw->conf.chandef.width,
+					   &bitrates, &n_bitrates)) {
+			bitrates = sband->bitrates;
+			n_bitrates = sband->n_bitrates;
+		}
 
 		for (i = 0; i < params->basic_rates_len; i++) {
 			int rate = (params->basic_rates[i] & 0x7f) * 5;
-			for (j = 0; j < sband->n_bitrates; j++) {
-				if (sband->bitrates[j].bitrate == rate)
+			for (j = 0; j < n_bitrates; j++) {
+				if (bitrates[j].bitrate == rate)
 					rates |= BIT(j);
 			}
 		}
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 6a96663..3b55a43 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -53,6 +53,8 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	struct cfg80211_chan_def chandef;
 	struct beacon_data *presp;
 	int frame_len;
+	struct ieee80211_rate *bitrates;
+	int n_bitrates;
 
 	lockdep_assert_held(&ifibss->mtx);
 
@@ -100,6 +102,11 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 
 	sband = local->hw.wiphy->bands[chan->band];
 
+	if (WARN_ON(ieee80211_get_bitrates(sband, chandef.width,
+					   &bitrates, &n_bitrates)))
+		return;
+
+
 	/* Build IBSS probe response */
 	frame_len = sizeof(struct ieee80211_hdr_3addr) +
 		    12 /* struct ieee80211_mgmt.u.beacon */ +
@@ -134,11 +141,11 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	memcpy(pos, ifibss->ssid, ifibss->ssid_len);
 	pos += ifibss->ssid_len;
 
-	rates = min_t(int, 8, sband->n_bitrates);
+	rates = min_t(int, 8, n_bitrates);
 	*pos++ = WLAN_EID_SUPP_RATES;
 	*pos++ = rates;
 	for (i = 0; i < rates; i++) {
-		int rate = sband->bitrates[i].bitrate;
+		int rate = bitrates[i].bitrate;
 		u8 basic = 0;
 		if (basic_rates & BIT(i))
 			basic = 0x80;
@@ -157,11 +164,11 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	*pos++ = 0;
 	*pos++ = 0;
 
-	if (sband->n_bitrates > 8) {
+	if (n_bitrates > 8) {
 		*pos++ = WLAN_EID_EXT_SUPP_RATES;
 		*pos++ = sband->n_bitrates - 8;
-		for (i = 8; i < sband->n_bitrates; i++) {
-			int rate = sband->bitrates[i].bitrate;
+		for (i = 8; i < n_bitrates; i++) {
+			int rate = bitrates[i].bitrate;
 			u8 basic = 0;
 			if (basic_rates & BIT(i))
 				basic = 0x80;
@@ -240,7 +247,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	sdata->vif.bss_conf.ibss_creator = creator;
 	ieee80211_bss_info_change_notify(sdata, bss_change);
 
-	ieee80211_sta_def_wmm_params(sdata, sband->n_bitrates, supp_rates);
+	ieee80211_sta_def_wmm_params(sdata, n_bitrates, supp_rates);
 
 	ifibss->state = IEEE80211_IBSS_MLME_JOINED;
 	mod_timer(&ifibss->timer,
@@ -263,6 +270,8 @@ static void ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	int i, j;
 	u16 beacon_int = cbss->beacon_interval;
 	const struct cfg80211_bss_ies *ies;
+	struct ieee80211_rate *bitrates;
+	int n_bitrates;
 	u64 tsf;
 
 	lockdep_assert_held(&sdata->u.ibss.mtx);
@@ -271,6 +280,9 @@ static void ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 		beacon_int = 10;
 
 	sband = sdata->local->hw.wiphy->bands[cbss->channel->band];
+	if (WARN_ON(ieee80211_get_bitrates(sband, sdata->u.ibss.chandef.width,
+					   &bitrates, &n_bitrates)))
+		return;
 
 	basic_rates = 0;
 
@@ -278,8 +290,8 @@ static void ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 		int rate = bss->supp_rates[i] & 0x7f;
 		bool is_basic = !!(bss->supp_rates[i] & 0x80);
 
-		for (j = 0; j < sband->n_bitrates; j++) {
-			if ((sband->bitrates[j].bitrate + 4) / 5 == rate) {
+		for (j = 0; j < n_bitrates; j++) {
+			if ((bitrates[j].bitrate + 4) / 5 == rate) {
 				if (is_basic)
 					basic_rates |= BIT(j);
 				break;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 0e8f2d0..3258039 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -741,6 +741,8 @@ struct ieee80211_sub_if_data {
 
 	/* bitmap of allowed (non-MCS) rate indexes for rate control */
 	u32 rc_rateidx_mask[IEEE80211_NUM_BANDS];
+	u32 rc_rateidx_mask_half[IEEE80211_NUM_BANDS];
+	u32 rc_rateidx_mask_quarter[IEEE80211_NUM_BANDS];
 
 	bool rc_has_mcs_mask[IEEE80211_NUM_BANDS];
 	u8  rc_rateidx_mcs_mask[IEEE80211_NUM_BANDS][IEEE80211_HT_MCS_MASK_LEN];
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 60f1ce5..28a38a7 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1615,6 +1615,11 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 		sband = local->hw.wiphy->bands[i];
 		sdata->rc_rateidx_mask[i] =
 			sband ? (1 << sband->n_bitrates) - 1 : 0;
+		sdata->rc_rateidx_mask_half[i] =
+			sband ? (1 << sband->n_bitrates_half) - 1 : 0;
+		sdata->rc_rateidx_mask_quarter[i] =
+			sband ? (1 << sband->n_bitrates_quarter) - 1 : 0;
+
 		if (sband)
 			memcpy(sdata->rc_rateidx_mcs_mask[i],
 			       sband->ht_cap.mcs.rx_mask,
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 8a7bfc4..f6b6b57 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -761,8 +761,9 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 
 		channels += sband->n_channels;
 
-		if (max_bitrates < sband->n_bitrates)
-			max_bitrates = sband->n_bitrates;
+		max_bitrates = max(max_bitrates, sband->n_bitrates);
+		max_bitrates = max(max_bitrates, sband->n_bitrates_quarter);
+		max_bitrates = max(max_bitrates, sband->n_bitrates_half);
 		supp_ht = supp_ht || sband->ht_cap.ht_supported;
 		supp_vht = supp_vht || sband->vht_cap.vht_supported;
 
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 02c05fa..2f07985 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -92,6 +92,8 @@ static u32 mesh_set_short_slot_time(struct ieee80211_sub_if_data *sdata)
 	struct ieee80211_local *local = sdata->local;
 	enum ieee80211_band band = ieee80211_get_sdata_band(sdata);
 	struct ieee80211_supported_band *sband = local->hw.wiphy->bands[band];
+	struct ieee80211_rate *bitrates;
+	int n_bitrates;
 	struct sta_info *sta;
 	u32 erp_rates = 0, changed = 0;
 	int i;
@@ -106,8 +108,12 @@ static u32 mesh_set_short_slot_time(struct ieee80211_sub_if_data *sdata)
 		    local->hw.flags & IEEE80211_HW_2GHZ_SHORT_SLOT_INCAPABLE))
 		goto out;
 
-	for (i = 0; i < sband->n_bitrates; i++)
-		if (sband->bitrates[i].flags & IEEE80211_RATE_ERP_G)
+	if (ieee80211_get_bitrates(sband, local->hw.conf.chandef.width,
+				   &bitrates, &n_bitrates))
+		goto out;
+
+	for (i = 0; i < n_bitrates; i++)
+		if (bitrates[i].flags & IEEE80211_RATE_ERP_G)
 			erp_rates |= BIT(i);
 
 	if (!erp_rates)
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 03c1b73..837a580 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -513,8 +513,8 @@ static int ieee80211_config_bw(struct ieee80211_sub_if_data *sdata,
 /* frame sending functions */
 
 static int ieee80211_compatible_rates(const u8 *supp_rates, int supp_rates_len,
-				      struct ieee80211_supported_band *sband,
-				      u32 *rates)
+				      struct ieee80211_rate *bitrates,
+				      int n_bitrates, u32 *rates)
 {
 	int i, j, count;
 	*rates = 0;
@@ -522,8 +522,8 @@ static int ieee80211_compatible_rates(const u8 *supp_rates, int supp_rates_len,
 	for (i = 0; i < supp_rates_len; i++) {
 		int rate = supp_rates[i] & 0x7F;
 
-		for (j = 0; j < sband->n_bitrates; j++)
-			if ((sband->bitrates[j].bitrate + 4) / 5 == rate) {
+		for (j = 0; j < n_bitrates; j++)
+			if ((bitrates[j].bitrate + 4) / 5 == rate) {
 				*rates |= BIT(j);
 				count++;
 				break;
@@ -656,6 +656,8 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	struct ieee80211_channel *chan;
+	struct ieee80211_rate *bitrates;
+	int n_bitrates;
 	u32 rates = 0;
 
 	lockdep_assert_held(&ifmgd->mtx);
@@ -667,8 +669,13 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 		return;
 	}
 	chan = chanctx_conf->def.chan;
-	rcu_read_unlock();
 	sband = local->hw.wiphy->bands[chan->band];
+	if (WARN_ON(ieee80211_get_bitrates(sband, chanctx_conf->def.width,
+					   &bitrates, &n_bitrates))) {
+		bitrates = sband->bitrates;
+		n_bitrates = sband->n_bitrates;
+	}
+	rcu_read_unlock();
 
 	if (assoc_data->supp_rates_len) {
 		/*
@@ -679,7 +686,8 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 		 */
 		rates_len = ieee80211_compatible_rates(assoc_data->supp_rates,
 						       assoc_data->supp_rates_len,
-						       sband, &rates);
+						       bitrates, n_bitrates,
+						       &rates);
 	} else {
 		/*
 		 * In case AP not provide any supported rates information
@@ -687,7 +695,7 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 		 * all rates that we support.
 		 */
 		rates = ~0;
-		rates_len = sband->n_bitrates;
+		rates_len = n_bitrates;
 	}
 
 	skb = alloc_skb(local->hw.extra_tx_headroom +
@@ -762,9 +770,9 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 	*pos++ = supp_rates_len;
 
 	count = 0;
-	for (i = 0; i < sband->n_bitrates; i++) {
+	for (i = 0; i < n_bitrates; i++) {
 		if (BIT(i) & rates) {
-			int rate = sband->bitrates[i].bitrate;
+			int rate = bitrates[i].bitrate;
 			*pos++ = (u8) ((rate + 4) / 5);
 			if (++count == 8)
 				break;
@@ -776,9 +784,9 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 		*pos++ = WLAN_EID_EXT_SUPP_RATES;
 		*pos++ = rates_len - count;
 
-		for (i++; i < sband->n_bitrates; i++) {
+		for (i++; i < n_bitrates; i++) {
 			if (BIT(i) & rates) {
-				int rate = sband->bitrates[i].bitrate;
+				int rate = bitrates[i].bitrate;
 				*pos++ = (u8) ((rate + 4) / 5);
 			}
 		}
@@ -2439,7 +2447,8 @@ ieee80211_rx_mgmt_disassoc(struct ieee80211_sub_if_data *sdata,
 	return RX_MGMT_CFG80211_DISASSOC;
 }
 
-static void ieee80211_get_rates(struct ieee80211_supported_band *sband,
+static void ieee80211_get_rates(struct ieee80211_rate *bitrates,
+				int n_bitrates,
 				u8 *supp_rates, unsigned int supp_rates_len,
 				u32 *rates, u32 *basic_rates,
 				bool *have_higher_than_11mbit,
@@ -2466,8 +2475,8 @@ static void ieee80211_get_rates(struct ieee80211_supported_band *sband,
 		    (supp_rates[i] & 0x7f) == BSS_MEMBERSHIP_SELECTOR_HT_PHY)
 			continue;
 
-		for (j = 0; j < sband->n_bitrates; j++) {
-			if ((sband->bitrates[j].bitrate + 4) / 5 == rate) {
+		for (j = 0; j < n_bitrates; j++) {
+			if ((bitrates[j].bitrate + 4) / 5 == rate) {
 				*rates |= BIT(j);
 				if (is_basic)
 					*basic_rates |= BIT(j);
@@ -3860,6 +3869,9 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 		int min_rate = INT_MAX, min_rate_index = -1;
 		struct ieee80211_supported_band *sband;
 		const struct cfg80211_bss_ies *ies;
+		struct ieee80211_chanctx_conf *chanctx_conf;
+		struct ieee80211_rate *bitrates;
+		int n_bitrates;
 
 		sband = local->hw.wiphy->bands[cbss->channel->band];
 
@@ -3868,8 +3880,21 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 			sta_info_free(local, new_sta);
 			return err;
 		}
+		rcu_read_lock();
+		chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
+		if (WARN_ON(!chanctx_conf)) {
+			rcu_read_unlock();
+			return err;
+		}
+		if (WARN_ON(ieee80211_get_bitrates(sband,
+						   chanctx_conf->def.width,
+						   &bitrates, &n_bitrates))) {
+			rcu_read_unlock();
+			return err;
+		}
+		rcu_read_unlock();
 
-		ieee80211_get_rates(sband, bss->supp_rates,
+		ieee80211_get_rates(bitrates, n_bitrates, bss->supp_rates,
 				    bss->supp_rates_len,
 				    &rates, &basic_rates,
 				    &have_higher_than_11mbit,
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 1ca7ded..99a3fbd 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -211,7 +211,8 @@ static bool rc_no_data_or_no_ack_use_min(struct ieee80211_tx_rate_control *txrc)
 }
 
 static void rc_send_low_broadcast(s8 *idx, u32 basic_rates,
-				  struct ieee80211_supported_band *sband)
+				  struct ieee80211_rate *bitrates,
+				  int n_bitrates)
 {
 	u8 i;
 
@@ -222,7 +223,7 @@ static void rc_send_low_broadcast(s8 *idx, u32 basic_rates,
 	if (basic_rates & (1 << *idx))
 		return; /* selected rate is a basic rate */
 
-	for (i = *idx + 1; i <= sband->n_bitrates; i++) {
+	for (i = *idx + 1; i <= n_bitrates; i++) {
 		if (basic_rates & (1 << i)) {
 			*idx = i;
 			return;
@@ -234,12 +235,14 @@ static void rc_send_low_broadcast(s8 *idx, u32 basic_rates,
 
 static inline s8
 rate_lowest_non_cck_index(struct ieee80211_supported_band *sband,
+			  struct ieee80211_rate *bitrates,
+			  int n_bitrates,
 			  struct ieee80211_sta *sta)
 {
 	int i;
 
-	for (i = 0; i < sband->n_bitrates; i++) {
-		struct ieee80211_rate *srate = &sband->bitrates[i];
+	for (i = 0; i < n_bitrates; i++) {
+		struct ieee80211_rate *srate = &bitrates[i];
 		if ((srate->bitrate == 10) || (srate->bitrate == 20) ||
 		    (srate->bitrate == 55) || (srate->bitrate == 110))
 			continue;
@@ -254,15 +257,19 @@ rate_lowest_non_cck_index(struct ieee80211_supported_band *sband,
 
 static void __rate_control_send_low(struct ieee80211_hw *hw,
 				    struct ieee80211_supported_band *sband,
+				    struct ieee80211_rate *bitrates,
+				    int n_bitrates,
 				    struct ieee80211_sta *sta,
 				    struct ieee80211_tx_info *info)
 {
 	if ((sband->band != IEEE80211_BAND_2GHZ) ||
 	    !(info->flags & IEEE80211_TX_CTL_NO_CCK_RATE))
-		info->control.rates[0].idx = rate_lowest_index(sband, sta);
+		info->control.rates[0].idx =
+			rate_lowest_index(sband, n_bitrates, sta);
 	else
 		info->control.rates[0].idx =
-			rate_lowest_non_cck_index(sband, sta);
+			rate_lowest_non_cck_index(sband, bitrates, n_bitrates,
+						  sta);
 
 	info->control.rates[0].count =
 		(info->flags & IEEE80211_TX_CTL_NO_ACK) ?
@@ -278,10 +285,18 @@ bool rate_control_send_low(struct ieee80211_sta *sta,
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(txrc->skb);
 	struct ieee80211_supported_band *sband = txrc->sband;
+	struct ieee80211_rate *bitrates;
+	int n_bitrates;
 	int mcast_rate;
 
+	if (WARN_ON(ieee80211_get_bitrates(sband,
+					   txrc->hw->conf.chandef.width,
+					   &bitrates, &n_bitrates)))
+		return false;
+
 	if (!sta || !priv_sta || rc_no_data_or_no_ack_use_min(txrc)) {
-		__rate_control_send_low(txrc->hw, sband, sta, info);
+		__rate_control_send_low(txrc->hw, sband, bitrates, n_bitrates,
+					sta, info);
 
 		if (!sta && txrc->bss) {
 			mcast_rate = txrc->bss_conf->mcast_rate[sband->band];
@@ -292,7 +307,7 @@ bool rate_control_send_low(struct ieee80211_sta *sta,
 
 			rc_send_low_broadcast(&info->control.rates[0].idx,
 					      txrc->bss_conf->basic_rates,
-					      sband);
+					      bitrates, n_bitrates);
 		}
 		return true;
 	}
@@ -366,7 +381,8 @@ static bool rate_idx_match_mcs_mask(struct ieee80211_tx_rate *rate,
 
 
 static void rate_idx_match_mask(struct ieee80211_tx_rate *rate,
-				struct ieee80211_supported_band *sband,
+				struct ieee80211_rate *bitrates,
+				int n_bitrates,
 				enum nl80211_chan_width chan_width,
 				u32 mask,
 				u8 mcs_mask[IEEE80211_HT_MCS_MASK_LEN])
@@ -387,13 +403,13 @@ static void rate_idx_match_mask(struct ieee80211_tx_rate *rate,
 				  IEEE80211_TX_RC_USE_SHORT_PREAMBLE);
 		alt_rate.count = rate->count;
 		if (rate_idx_match_legacy_mask(&alt_rate,
-					       sband->n_bitrates, mask)) {
+					       n_bitrates, mask)) {
 			*rate = alt_rate;
 			return;
 		}
 	} else {
 		/* handle legacy rates */
-		if (rate_idx_match_legacy_mask(rate, sband->n_bitrates, mask))
+		if (rate_idx_match_legacy_mask(rate, n_bitrates, mask))
 			return;
 
 		/* if HT BSS, and we handle a data frame, also try HT rates */
@@ -435,7 +451,8 @@ static void rate_idx_match_mask(struct ieee80211_tx_rate *rate,
 }
 
 static void rate_fixup_ratelist(struct ieee80211_vif *vif,
-				struct ieee80211_supported_band *sband,
+				struct ieee80211_rate *bitrates,
+				int n_bitrates,
 				struct ieee80211_tx_info *info,
 				struct ieee80211_tx_rate *rates,
 				int max_rates)
@@ -456,18 +473,18 @@ static void rate_fixup_ratelist(struct ieee80211_vif *vif,
 		u32 basic_rates = vif->bss_conf.basic_rates;
 		s8 baserate = basic_rates ? ffs(basic_rates - 1) : 0;
 
-		rate = &sband->bitrates[rates[0].idx];
+		rate = &bitrates[rates[0].idx];
 
-		for (i = 0; i < sband->n_bitrates; i++) {
+		for (i = 0; i < n_bitrates; i++) {
 			/* must be a basic rate */
 			if (!(basic_rates & BIT(i)))
 				continue;
 			/* must not be faster than the data rate */
-			if (sband->bitrates[i].bitrate > rate->bitrate)
+			if (bitrates[i].bitrate > rate->bitrate)
 				continue;
 			/* maximum */
-			if (sband->bitrates[baserate].bitrate <
-			     sband->bitrates[i].bitrate)
+			if (bitrates[baserate].bitrate <
+			     bitrates[i].bitrate)
 				baserate = i;
 		}
 
@@ -515,12 +532,12 @@ static void rate_fixup_ratelist(struct ieee80211_vif *vif,
 		}
 
 		/* RC is busted */
-		if (WARN_ON_ONCE(rates[i].idx >= sband->n_bitrates)) {
+		if (WARN_ON_ONCE(rates[i].idx >= n_bitrates)) {
 			rates[i].idx = -1;
 			continue;
 		}
 
-		rate = &sband->bitrates[rates[i].idx];
+		rate = &bitrates[rates[i].idx];
 
 		/* set up short preamble */
 		if (info->control.short_preamble &&
@@ -576,7 +593,8 @@ static void rate_control_fill_sta_table(struct ieee80211_sta *sta,
 
 static void rate_control_apply_mask(struct ieee80211_sub_if_data *sdata,
 				    struct ieee80211_sta *sta,
-				    struct ieee80211_supported_band *sband,
+				    struct ieee80211_rate *bitrates,
+				    int n_bitrates,
 				    struct ieee80211_tx_info *info,
 				    struct ieee80211_tx_rate *rates,
 				    int max_rates)
@@ -592,9 +610,20 @@ static void rate_control_apply_mask(struct ieee80211_sub_if_data *sdata,
 	 * default mask (allow all rates) is used to save some processing for
 	 * the common case.
 	 */
-	mask = sdata->rc_rateidx_mask[info->band];
+	chan_width = sdata->vif.bss_conf.chandef.width;
+	switch (chan_width) {
+	case NL80211_CHAN_WIDTH_5:
+		mask = sdata->rc_rateidx_mask_quarter[info->band];
+		break;
+	case NL80211_CHAN_WIDTH_10:
+		mask = sdata->rc_rateidx_mask_half[info->band];
+		break;
+	default:
+		mask = sdata->rc_rateidx_mask[info->band];
+		break;
+	}
 	has_mcs_mask = sdata->rc_has_mcs_mask[info->band];
-	if (mask == (1 << sband->n_bitrates) - 1 && !has_mcs_mask)
+	if (mask == (1 << n_bitrates) - 1 && !has_mcs_mask)
 		return;
 
 	if (has_mcs_mask)
@@ -615,14 +644,13 @@ static void rate_control_apply_mask(struct ieee80211_sub_if_data *sdata,
 	 * included in the configured mask and change the rate indexes
 	 * if needed.
 	 */
-	chan_width = sdata->vif.bss_conf.chandef.width;
 	for (i = 0; i < max_rates; i++) {
 		/* Skip invalid rates */
 		if (rates[i].idx < 0)
 			break;
 
-		rate_idx_match_mask(&rates[i], sband, mask, chan_width,
-				    mcs_mask);
+		rate_idx_match_mask(&rates[i], bitrates, n_bitrates, mask,
+				    chan_width, mcs_mask);
 	}
 }
 
@@ -636,6 +664,8 @@ void ieee80211_get_tx_rates(struct ieee80211_vif *vif,
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_supported_band *sband;
+	struct ieee80211_rate *bitrates;
+	int n_bitrates;
 
 	rate_control_fill_sta_table(sta, info, dest, max_rates);
 
@@ -645,14 +675,22 @@ void ieee80211_get_tx_rates(struct ieee80211_vif *vif,
 	sdata = vif_to_sdata(vif);
 	sband = sdata->local->hw.wiphy->bands[info->band];
 
+	if (WARN_ON(ieee80211_get_bitrates(sband,
+					   sdata->local->hw.conf.chandef.width,
+					   &bitrates, &n_bitrates)))
+		return;
+
 	if (ieee80211_is_data(hdr->frame_control))
-		rate_control_apply_mask(sdata, sta, sband, info, dest, max_rates);
+		rate_control_apply_mask(sdata, sta, bitrates, n_bitrates, info,
+					dest, max_rates);
 
 	if (dest[0].idx < 0)
-		__rate_control_send_low(&sdata->local->hw, sband, sta, info);
+		__rate_control_send_low(&sdata->local->hw, sband, bitrates,
+					n_bitrates, sta, info);
 
 	if (sta)
-		rate_fixup_ratelist(vif, sband, info, dest, max_rates);
+		rate_fixup_ratelist(vif, bitrates, n_bitrates, info, dest,
+				    max_rates);
 }
 EXPORT_SYMBOL(ieee80211_get_tx_rates);
 
diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index 6c89c29..00024c8 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -427,10 +427,19 @@ minstrel_rate_init(void *priv, struct ieee80211_supported_band *sband,
 	struct ieee80211_rate *ctl_rate;
 	unsigned int i, n = 0;
 	unsigned int t_slot = 9; /* FIXME: get real slot time */
+	struct ieee80211_rate *bitrates;
+	int n_bitrates;
+
+	if (WARN_ON(ieee80211_get_bitrates(sband,
+					   mp->hw->conf.chandef.width,
+					   &bitrates, &n_bitrates))) {
+		bitrates = sband->bitrates;
+		n_bitrates = sband->n_bitrates;
+	}
 
 	mi->sta = sta;
-	mi->lowest_rix = rate_lowest_index(sband, sta);
-	ctl_rate = &sband->bitrates[mi->lowest_rix];
+	mi->lowest_rix = rate_lowest_index(sband, n_bitrates, sta);
+	ctl_rate = &bitrates[mi->lowest_rix];
 	mi->sp_ack_dur = ieee80211_frame_duration(sband->band, 10,
 				ctl_rate->bitrate,
 				!!(ctl_rate->flags & IEEE80211_RATE_ERP_G), 1,
@@ -439,7 +448,7 @@ minstrel_rate_init(void *priv, struct ieee80211_supported_band *sband,
 	memset(mi->max_tp_rate, 0, sizeof(mi->max_tp_rate));
 	mi->max_prob_rate = 0;
 
-	for (i = 0; i < sband->n_bitrates; i++) {
+	for (i = 0; i < n_bitrates; i++) {
 		struct minstrel_rate *mr = &mi->r[n];
 		unsigned int tx_time = 0, tx_time_cts = 0, tx_time_rtscts = 0;
 		unsigned int tx_time_single;
@@ -451,8 +460,8 @@ minstrel_rate_init(void *priv, struct ieee80211_supported_band *sband,
 		memset(mr, 0, sizeof(*mr));
 
 		mr->rix = i;
-		mr->bitrate = (sband->bitrates[i].bitrate + 4) / 5;
-		calc_rate_durations(sband->band, mr, &sband->bitrates[i], mp);
+		mr->bitrate = (bitrates[i].bitrate + 4) / 5;
+		calc_rate_durations(sband->band, mr, &bitrates[i], mp);
 
 		/* calculate maximum number of retransmissions before
 		 * fallback (based on maximum segment size) */
@@ -481,11 +490,11 @@ minstrel_rate_init(void *priv, struct ieee80211_supported_band *sband,
 		} while ((tx_time < mp->segment_size) &&
 				(++mr->retry_count < mp->max_retry));
 		mr->adjusted_retry_count = mr->retry_count;
-		if (!(sband->bitrates[i].flags & IEEE80211_RATE_ERP_G))
+		if (!(bitrates[i].flags & IEEE80211_RATE_ERP_G))
 			mr->retry_count_cts = mr->retry_count;
 	}
 
-	for (i = n; i < sband->n_bitrates; i++) {
+	for (i = n; i < n_bitrates; i++) {
 		struct minstrel_rate *mr = &mi->r[i];
 		mr->rix = -1;
 	}
@@ -513,8 +522,12 @@ minstrel_alloc_sta(void *priv, struct ieee80211_sta *sta, gfp_t gfp)
 
 	for (i = 0; i < IEEE80211_NUM_BANDS; i++) {
 		sband = hw->wiphy->bands[i];
-		if (sband && sband->n_bitrates > max_rates)
-			max_rates = sband->n_bitrates;
+		if (!sband)
+			continue;
+
+		max_rates = max(sband->n_bitrates, max_rates);
+		max_rates = max(sband->n_bitrates_half, max_rates);
+		max_rates = max(sband->n_bitrates_quarter, max_rates);
 	}
 
 	mi->r = kzalloc(sizeof(struct minstrel_rate) * max_rates, gfp);
@@ -548,22 +561,28 @@ minstrel_free_sta(void *priv, struct ieee80211_sta *sta, void *priv_sta)
 static void
 minstrel_init_cck_rates(struct minstrel_priv *mp)
 {
-	static const int bitrates[4] = { 10, 20, 55, 110 };
+	static const int cck_bitrates[4] = { 10, 20, 55, 110 };
 	struct ieee80211_supported_band *sband;
+	struct ieee80211_rate *bitrates;
+	int n_bitrates;
 	int i, j;
 
 	sband = mp->hw->wiphy->bands[IEEE80211_BAND_2GHZ];
 	if (!sband)
 		return;
 
-	for (i = 0, j = 0; i < sband->n_bitrates; i++) {
-		struct ieee80211_rate *rate = &sband->bitrates[i];
+	if (ieee80211_get_bitrates(sband, mp->hw->conf.chandef.width,
+				   &bitrates, &n_bitrates))
+		return;
+
+	for (i = 0, j = 0; i < n_bitrates; i++) {
+		struct ieee80211_rate *rate = &bitrates[i];
 
 		if (rate->flags & IEEE80211_RATE_ERP_G)
 			continue;
 
-		for (j = 0; j < ARRAY_SIZE(bitrates); j++) {
-			if (rate->bitrate != bitrates[j])
+		for (j = 0; j < ARRAY_SIZE(cck_bitrates); j++) {
+			if (rate->bitrate != cck_bitrates[j])
 				continue;
 
 			mp->cck_rates[j] = i;
diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index f05eeff..21688ac 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -815,19 +815,25 @@ minstrel_ht_update_cck(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
 		       struct ieee80211_supported_band *sband,
 		       struct ieee80211_sta *sta)
 {
-	int i;
+	struct ieee80211_rate *bitrates;
+	int i, n_bitrates;
+
 
 	if (sband->band != IEEE80211_BAND_2GHZ)
 		return;
 
 	mi->cck_supported = 0;
 	mi->cck_supported_short = 0;
+	if (ieee80211_get_bitrates(sband, mp->hw->conf.chandef.width,
+				   &bitrates, &n_bitrates))
+		return;
+
 	for (i = 0; i < 4; i++) {
 		if (!rate_supported(sta, sband->band, mp->cck_rates[i]))
 			continue;
 
 		mi->cck_supported |= BIT(i);
-		if (sband->bitrates[i].flags & IEEE80211_RATE_SHORT_PREAMBLE)
+		if (bitrates[i].flags & IEEE80211_RATE_SHORT_PREAMBLE)
 			mi->cck_supported_short |= BIT(i);
 	}
 
@@ -963,8 +969,12 @@ minstrel_ht_alloc_sta(void *priv, struct ieee80211_sta *sta, gfp_t gfp)
 
 	for (i = 0; i < IEEE80211_NUM_BANDS; i++) {
 		sband = hw->wiphy->bands[i];
-		if (sband && sband->n_bitrates > max_rates)
-			max_rates = sband->n_bitrates;
+		if (!sband)
+			continue;
+
+		max_rates = max(sband->n_bitrates, max_rates);
+		max_rates = max(sband->n_bitrates_half, max_rates);
+		max_rates = max(sband->n_bitrates_quarter, max_rates);
 	}
 
 	msp = kzalloc(sizeof(*msp), gfp);
diff --git a/net/mac80211/rc80211_pid.h b/net/mac80211/rc80211_pid.h
index 19111c7..dc48981 100644
--- a/net/mac80211/rc80211_pid.h
+++ b/net/mac80211/rc80211_pid.h
@@ -269,6 +269,8 @@ struct rc_pid_info {
 	/* Index of the last used rate. */
 	int oldrate;
 
+	struct ieee80211_hw *hw;
+
 #ifdef CONFIG_MAC80211_DEBUGFS
 	/* Debugfs entries created for the parameters above. */
 	struct rc_pid_debugfs_entries dentries;
diff --git a/net/mac80211/rc80211_pid_algo.c b/net/mac80211/rc80211_pid_algo.c
index 502d3ec..cb9ee86 100644
--- a/net/mac80211/rc80211_pid_algo.c
+++ b/net/mac80211/rc80211_pid_algo.c
@@ -72,13 +72,14 @@
 static void rate_control_pid_adjust_rate(struct ieee80211_supported_band *sband,
 					 struct ieee80211_sta *sta,
 					 struct rc_pid_sta_info *spinfo, int adj,
-					 struct rc_pid_rateinfo *rinfo)
+					 struct rc_pid_rateinfo *rinfo,
+					 struct ieee80211_rate *bitrates,
+					 int n_bitrates)
 {
-	int cur_sorted, new_sorted, probe, tmp, n_bitrates, band;
+	int cur_sorted, new_sorted, probe, tmp, band;
 	int cur = spinfo->txrate_idx;
 
 	band = sband->band;
-	n_bitrates = sband->n_bitrates;
 
 	/* Map passed arguments to sorted values. */
 	cur_sorted = rinfo[cur].rev_index;
@@ -121,7 +122,7 @@ static void rate_control_pid_adjust_rate(struct ieee80211_supported_band *sband,
 #ifdef CONFIG_MAC80211_DEBUGFS
 	rate_control_pid_event_rate_change(&spinfo->events,
 		spinfo->txrate_idx,
-		sband->bitrates[spinfo->txrate_idx].bitrate);
+		bitrates[spinfo->txrate_idx].bitrate);
 #endif
 }
 
@@ -155,6 +156,15 @@ static void rate_control_pid_sample(struct rc_pid_info *pinfo,
 	u32 err_der;
 	int adj, i, j, tmp;
 	unsigned long period;
+	struct ieee80211_rate *bitrates;
+	int n_bitrates;
+
+	if (WARN_ON(ieee80211_get_bitrates(sband,
+					   pinfo->hw->conf.chandef.width,
+					   &bitrates, &n_bitrates))) {
+		bitrates = sband->bitrates;
+		n_bitrates = sband->n_bitrates;
+	}
 
 	/* In case nothing happened during the previous control interval, turn
 	 * the sharpening factor on. */
@@ -186,7 +196,7 @@ static void rate_control_pid_sample(struct rc_pid_info *pinfo,
 		rinfo[j].diff = rinfo[i].diff + tmp;
 		pinfo->oldrate = spinfo->txrate_idx;
 	}
-	rate_control_pid_normalize(pinfo, sband->n_bitrates);
+	rate_control_pid_normalize(pinfo, n_bitrates);
 
 	/* Compute the proportional, integral and derivative errors. */
 	err_prop = (pinfo->target - pf) << RC_PID_ARITH_SHIFT;
@@ -213,7 +223,8 @@ static void rate_control_pid_sample(struct rc_pid_info *pinfo,
 
 	/* Change rate. */
 	if (adj)
-		rate_control_pid_adjust_rate(sband, sta, spinfo, adj, rinfo);
+		rate_control_pid_adjust_rate(sband, sta, spinfo, adj, rinfo,
+					     bitrates, n_bitrates);
 }
 
 static void rate_control_pid_tx_status(void *priv, struct ieee80211_supported_band *sband,
@@ -265,7 +276,16 @@ rate_control_pid_get_rate(void *priv, struct ieee80211_sta *sta,
 	struct ieee80211_supported_band *sband = txrc->sband;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct rc_pid_sta_info *spinfo = priv_sta;
-	int rateidx;
+	struct ieee80211_rate *bitrates;
+	int rateidx, n_bitrates;
+
+	if (WARN_ON(ieee80211_get_bitrates(sband,
+					   txrc->hw->conf.chandef.width,
+					   &bitrates, &n_bitrates))) {
+		bitrates = sband->bitrates;
+		n_bitrates = sband->n_bitrates;
+	}
+
 
 	if (txrc->rts)
 		info->control.rates[0].count =
@@ -280,14 +300,14 @@ rate_control_pid_get_rate(void *priv, struct ieee80211_sta *sta,
 
 	rateidx = spinfo->txrate_idx;
 
-	if (rateidx >= sband->n_bitrates)
-		rateidx = sband->n_bitrates - 1;
+	if (rateidx >= n_bitrates)
+		rateidx = n_bitrates - 1;
 
 	info->control.rates[0].idx = rateidx;
 
 #ifdef CONFIG_MAC80211_DEBUGFS
 	rate_control_pid_event_tx_rate(&spinfo->events,
-		rateidx, sband->bitrates[rateidx].bitrate);
+		rateidx, bitrates[rateidx].bitrate);
 #endif
 }
 
@@ -298,6 +318,8 @@ rate_control_pid_rate_init(void *priv, struct ieee80211_supported_band *sband,
 	struct rc_pid_sta_info *spinfo = priv_sta;
 	struct rc_pid_info *pinfo = priv;
 	struct rc_pid_rateinfo *rinfo = pinfo->rinfo;
+	struct ieee80211_rate *bitrates;
+	int n_bitrates;
 	int i, j, tmp;
 	bool s;
 
@@ -309,7 +331,15 @@ rate_control_pid_rate_init(void *priv, struct ieee80211_supported_band *sband,
 	/* Sort the rates. This is optimized for the most common case (i.e.
 	 * almost-sorted CCK+OFDM rates). Kind of bubble-sort with reversed
 	 * mapping too. */
-	for (i = 0; i < sband->n_bitrates; i++) {
+
+	if (WARN_ON(ieee80211_get_bitrates(sband,
+					   pinfo->hw->conf.chandef.width,
+					   &bitrates, &n_bitrates))) {
+		bitrates = sband->bitrates;
+		n_bitrates = sband->n_bitrates;
+	}
+
+	for (i = 0; i < n_bitrates; i++) {
 		rinfo[i].index = i;
 		rinfo[i].rev_index = i;
 		if (RC_PID_FAST_START)
@@ -320,8 +350,8 @@ rate_control_pid_rate_init(void *priv, struct ieee80211_supported_band *sband,
 	for (i = 1; i < sband->n_bitrates; i++) {
 		s = false;
 		for (j = 0; j < sband->n_bitrates - i; j++)
-			if (unlikely(sband->bitrates[rinfo[j].index].bitrate >
-				     sband->bitrates[rinfo[j + 1].index].bitrate)) {
+			if (unlikely(bitrates[rinfo[j].index].bitrate >
+				     bitrates[rinfo[j + 1].index].bitrate)) {
 				tmp = rinfo[j].index;
 				rinfo[j].index = rinfo[j + 1].index;
 				rinfo[j + 1].index = tmp;
@@ -333,7 +363,7 @@ rate_control_pid_rate_init(void *priv, struct ieee80211_supported_band *sband,
 			break;
 	}
 
-	spinfo->txrate_idx = rate_lowest_index(sband, sta);
+	spinfo->txrate_idx = rate_lowest_index(sband, n_bitrates, sta);
 }
 
 static void *rate_control_pid_alloc(struct ieee80211_hw *hw,
@@ -351,10 +381,16 @@ static void *rate_control_pid_alloc(struct ieee80211_hw *hw,
 	if (!pinfo)
 		return NULL;
 
+	pinfo->hw = hw;
+
 	for (i = 0; i < IEEE80211_NUM_BANDS; i++) {
 		sband = hw->wiphy->bands[i];
-		if (sband && sband->n_bitrates > max_rates)
-			max_rates = sband->n_bitrates;
+		if (!sband)
+			continue;
+
+		max_rates = max(sband->n_bitrates, max_rates);
+		max_rates = max(sband->n_bitrates_half, max_rates);
+		max_rates = max(sband->n_bitrates_quarter, max_rates);
 	}
 
 	rinfo = kmalloc(sizeof(*rinfo) * max_rates, GFP_ATOMIC);
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 06f71c6..b0834a9 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2832,13 +2832,23 @@ static void ieee80211_rx_handlers_result(struct ieee80211_rx_data *rx,
 		struct ieee80211_rate *rate = NULL;
 		struct ieee80211_supported_band *sband;
 		struct ieee80211_rx_status *status;
+		struct ieee80211_rate *bitrates;
+		int n_bitrates;
+		enum nl80211_chan_width width;
 
 		status = IEEE80211_SKB_RXCB((rx->skb));
 
 		sband = rx->local->hw.wiphy->bands[status->band];
 		if (!(status->flag & RX_FLAG_HT) &&
-		    !(status->flag & RX_FLAG_VHT))
-			rate = &sband->bitrates[status->rate_idx];
+		    !(status->flag & RX_FLAG_VHT)) {
+			width = rx->sdata->local->hw.conf.chandef.width;
+			if (WARN_ON(ieee80211_get_bitrates(sband, width,
+							   &bitrates,
+							   &n_bitrates)))
+				bitrates = sband->bitrates;
+
+			rate = &bitrates[status->rate_idx];
+		}
 
 		ieee80211_rx_cooked_monitor(rx, rate);
 		break;
@@ -3293,9 +3303,20 @@ void ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb)
 				      status->rate_idx, status->vht_nss))
 				goto drop;
 		} else {
-			if (WARN_ON(status->rate_idx >= sband->n_bitrates))
+			struct ieee80211_rate *bitrates;
+			int n_bitrates;
+			enum nl80211_chan_width width;
+
+			width = local->hw.conf.chandef.width;
+
+			if (WARN_ON(ieee80211_get_bitrates(sband, width,
+							   &bitrates,
+							   &n_bitrates)))
 				goto drop;
-			rate = &sband->bitrates[status->rate_idx];
+
+			if (WARN_ON(status->rate_idx >= n_bitrates))
+				goto drop;
+			rate = &bitrates[status->rate_idx];
 		}
 	}
 
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index f62e4f6..41805ed 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -253,7 +253,8 @@ static int ieee80211_tx_radiotap_len(struct ieee80211_tx_info *info)
 }
 
 static void ieee80211_add_tx_radiotap_header(struct ieee80211_supported_band
-					     *sband, struct sk_buff *skb,
+					     *sband, struct ieee80211_hw *hw,
+					     struct sk_buff *skb,
 					     int retry_count, int rtap_len)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
@@ -280,10 +281,18 @@ static void ieee80211_add_tx_radiotap_header(struct ieee80211_supported_band
 	/* IEEE80211_RADIOTAP_RATE */
 	if (info->status.rates[0].idx >= 0 &&
 	    !(info->status.rates[0].flags & IEEE80211_TX_RC_MCS)) {
+		struct ieee80211_rate *bitrates;
+		int n_bitrates;
 		int rate;
 
+		if (ieee80211_get_bitrates(sband, hw->conf.chandef.width,
+					   &bitrates, &n_bitrates)) {
+			bitrates = sband->bitrates;
+			n_bitrates = sband->n_bitrates;
+		}
+
 		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_RATE);
-		rate = sband->bitrates[info->status.rates[0].idx].bitrate;
+		rate = bitrates[info->status.rates[0].idx].bitrate;
 		*pos = (rate + 4) / 5;
 		/* padding for tx flags */
 		pos += 2;
@@ -627,7 +636,7 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 		dev_kfree_skb(skb);
 		return;
 	}
-	ieee80211_add_tx_radiotap_header(sband, skb, retry_count, rtap_len);
+	ieee80211_add_tx_radiotap_header(sband, hw, skb, retry_count, rtap_len);
 
 	/* XXX: is this sufficient for BPF? */
 	skb_set_mac_header(skb, 0);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index e1f18a8..e8ef0bd 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -46,6 +46,8 @@ static __le16 ieee80211_duration(struct ieee80211_tx_data *tx,
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_hdr *hdr;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_rate *bitrates;
+	int n_bitrates;
 
 	/* assume HW handles this */
 	if (tx->rate.flags & IEEE80211_TX_RC_MCS)
@@ -56,7 +58,12 @@ static __le16 ieee80211_duration(struct ieee80211_tx_data *tx,
 		return 0;
 
 	sband = local->hw.wiphy->bands[info->band];
-	txrate = &sband->bitrates[tx->rate.idx];
+	if (WARN_ON(ieee80211_get_bitrates(sband,
+					   local->hw.conf.chandef.width,
+					   &bitrates, &n_bitrates)))
+		return 0;
+
+	txrate = &bitrates[tx->rate.idx];
 
 	erp = txrate->flags & IEEE80211_RATE_ERP_G;
 
@@ -115,9 +122,9 @@ static __le16 ieee80211_duration(struct ieee80211_tx_data *tx,
 	 */
 	rate = -1;
 	/* use lowest available if everything fails */
-	mrate = sband->bitrates[0].bitrate;
-	for (i = 0; i < sband->n_bitrates; i++) {
-		struct ieee80211_rate *r = &sband->bitrates[i];
+	mrate = bitrates[0].bitrate;
+	for (i = 0; i < n_bitrates; i++) {
+		struct ieee80211_rate *r = &bitrates[i];
 
 		if (r->bitrate > txrate->bitrate)
 			break;
@@ -624,6 +631,8 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 	u32 len;
 	struct ieee80211_tx_rate_control txrc;
 	struct ieee80211_sta_rates *ratetbl = NULL;
+	struct ieee80211_rate *bitrates;
+	int n_bitrates;
 	bool assoc = false;
 
 	memset(&txrc, 0, sizeof(txrc));
@@ -633,6 +642,11 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 	len = min_t(u32, tx->skb->len + FCS_LEN,
 			 tx->local->hw.wiphy->frag_threshold);
 
+	if (WARN_ON(ieee80211_get_bitrates(sband,
+					   tx->local->hw.conf.chandef.width,
+					   &bitrates, &n_bitrates)))
+		return TX_DROP;
+
 	/* set up the tx rate control struct we give the RC algo */
 	txrc.hw = &tx->local->hw;
 	txrc.sband = sband;
@@ -640,7 +654,7 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 	txrc.skb = tx->skb;
 	txrc.reported_rate.idx = -1;
 	txrc.rate_idx_mask = tx->sdata->rc_rateidx_mask[info->band];
-	if (txrc.rate_idx_mask == (1 << sband->n_bitrates) - 1)
+	if (txrc.rate_idx_mask == (1 << n_bitrates) - 1)
 		txrc.max_rate_idx = -1;
 	else
 		txrc.max_rate_idx = fls(txrc.rate_idx_mask) - 1;
@@ -2340,6 +2354,8 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 	enum ieee80211_band band;
 	struct ieee80211_tx_rate_control txrc;
 	struct ieee80211_chanctx_conf *chanctx_conf;
+	struct ieee80211_rate *bitrates;
+	int n_bitrates;
 
 	rcu_read_lock();
 
@@ -2431,6 +2447,11 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 
 	band = chanctx_conf->def.chan->band;
 
+	if (WARN_ON(ieee80211_get_bitrates(local->hw.wiphy->bands[band],
+					   chanctx_conf->def.width,
+					   &bitrates, &n_bitrates)))
+		goto out;
+
 	info = IEEE80211_SKB_CB(skb);
 
 	info->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
@@ -2444,7 +2465,7 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 	txrc.skb = skb;
 	txrc.reported_rate.idx = -1;
 	txrc.rate_idx_mask = sdata->rc_rateidx_mask[band];
-	if (txrc.rate_idx_mask == (1 << txrc.sband->n_bitrates) - 1)
+	if (txrc.rate_idx_mask == (1 << n_bitrates) - 1)
 		txrc.max_rate_idx = -1;
 	else
 		txrc.max_rate_idx = fls(txrc.rate_idx_mask) - 1;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 9d04989..617364d 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -141,14 +141,21 @@ int ieee80211_frame_duration(enum ieee80211_band band, size_t len,
 		dur = 16; /* SIFS + signal ext */
 		dur += 16; /* IEEE 802.11-2012 18.3.2.4: T_PREAMBLE = 16 usec */
 		dur += 4; /* IEEE 802.11-2012 18.3.2.4: T_SIGNAL = 4 usec */
-		dur += 4 * DIV_ROUND_UP((16 + 8 * (len + 4) + 6) * 10,
-					4 * rate); /* T_SYM x N_SYM */
 
 		/* IEEE 802.11-2012 18.3.2.4: all values above are:
 		 *  * times 4 for 5 MHz
 		 *  * times 2 for 10 MHz
 		 */
 		dur *= divisor;
+
+		/*
+		 * rates should already consider the channel bandwidth,
+		 * don't apply divisor again.
+		 */
+		dur += 4 * DIV_ROUND_UP((16 + 8 * (len + 4) + 6) * 10,
+					4 * rate); /* T_SYM x N_SYM */
+
+
 	} else {
 		/*
 		 * 802.11b or 802.11g with 802.11b compatibility:
@@ -204,6 +211,8 @@ __le16 ieee80211_rts_duration(struct ieee80211_hw *hw,
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_rate *rate;
 	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_rate *bitrates;
+	int n_bitrates;
 	bool short_preamble;
 	int erp, divisor = 1;
 	u16 dur;
@@ -213,7 +222,13 @@ __le16 ieee80211_rts_duration(struct ieee80211_hw *hw,
 
 	short_preamble = false;
 
-	rate = &sband->bitrates[frame_txctl->control.rts_cts_rate_idx];
+	if (WARN_ON(ieee80211_get_bitrates(sband, hw->conf.chandef.width,
+					   &bitrates, &n_bitrates))) {
+		bitrates = sband->bitrates;
+		n_bitrates = sband->n_bitrates;
+	}
+
+	rate = &bitrates[frame_txctl->control.rts_cts_rate_idx];
 
 	erp = 0;
 	if (vif) {
@@ -248,6 +263,8 @@ __le16 ieee80211_ctstoself_duration(struct ieee80211_hw *hw,
 	struct ieee80211_sub_if_data *sdata;
 	bool short_preamble;
 	int erp, divisor = 1;
+	struct ieee80211_rate *bitrates;
+	int n_bitrates;
 	u16 dur;
 	struct ieee80211_supported_band *sband;
 
@@ -255,7 +272,13 @@ __le16 ieee80211_ctstoself_duration(struct ieee80211_hw *hw,
 
 	short_preamble = false;
 
-	rate = &sband->bitrates[frame_txctl->control.rts_cts_rate_idx];
+	if (WARN_ON(ieee80211_get_bitrates(sband, hw->conf.chandef.width,
+					   &bitrates, &n_bitrates))) {
+		bitrates = sband->bitrates;
+		n_bitrates = sband->n_bitrates;
+	}
+
+	rate = &bitrates[frame_txctl->control.rts_cts_rate_idx];
 	erp = 0;
 	if (vif) {
 		sdata = vif_to_sdata(vif);
@@ -1092,20 +1115,26 @@ u32 ieee80211_mandatory_rates(struct ieee80211_local *local,
 	struct ieee80211_rate *bitrates;
 	u32 mandatory_rates;
 	enum ieee80211_rate_flags mandatory_flag;
-	int i;
+	int i, n_bitrates;
 
 	sband = local->hw.wiphy->bands[band];
 	if (WARN_ON(!sband))
 		return 1;
 
+	if (WARN_ON(ieee80211_get_bitrates(sband,
+					   local->hw.conf.chandef.width,
+					   &bitrates, &n_bitrates))) {
+		bitrates = sband->bitrates;
+		n_bitrates = sband->n_bitrates;
+	}
+
 	if (band == IEEE80211_BAND_2GHZ)
 		mandatory_flag = IEEE80211_RATE_MANDATORY_B;
 	else
 		mandatory_flag = IEEE80211_RATE_MANDATORY_A;
 
-	bitrates = sband->bitrates;
 	mandatory_rates = 0;
-	for (i = 0; i < sband->n_bitrates; i++)
+	for (i = 0; i < n_bitrates; i++)
 		if (bitrates[i].flags & mandatory_flag)
 			mandatory_rates |= BIT(i);
 	return mandatory_rates;
@@ -1198,6 +1227,8 @@ int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
 			     u8 channel)
 {
 	struct ieee80211_supported_band *sband;
+	struct ieee80211_rate *bitrates;
+	int n_bitrates;
 	u8 *pos = buffer, *end = buffer + buffer_len;
 	size_t offset = 0, noffset;
 	int supp_rates_len, i;
@@ -1209,12 +1240,17 @@ int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
 	if (WARN_ON_ONCE(!sband))
 		return 0;
 
+	if (WARN_ON(ieee80211_get_bitrates(sband,
+					   local->hw.conf.chandef.width,
+					   &bitrates, &n_bitrates)))
+		return 0;
+
 	num_rates = 0;
-	for (i = 0; i < sband->n_bitrates; i++) {
+	for (i = 0; i < n_bitrates; i++) {
 		if ((BIT(i) & rate_mask) == 0)
 			continue; /* skip rate */
 		rates[num_rates++] = (u8)
-			((sband->bitrates[i].bitrate + 4) / 5);
+			((bitrates[i].bitrate + 4) / 5);
 	}
 
 	supp_rates_len = min_t(int, num_rates, 8);
@@ -1395,8 +1431,11 @@ u32 ieee80211_sta_get_rates(struct ieee80211_local *local,
 	if (WARN_ON(!sband))
 		return 1;
 
-	bitrates = sband->bitrates;
-	num_rates = sband->n_bitrates;
+	if (WARN_ON(ieee80211_get_bitrates(sband,
+					   local->hw.conf.chandef.width,
+					   &bitrates, &num_rates)))
+		return 1;
+
 	supp_rates = 0;
 	for (i = 0; i < elems->supp_rates_len +
 		     elems->ext_supp_rates_len; i++) {
@@ -2036,12 +2075,18 @@ int ieee80211_add_srates_ie(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_supported_band *sband;
-	int rate;
-	u8 i, rates, *pos;
+	struct ieee80211_rate *bitrates;
+	int rate, rates;
+	u8 i, *pos;
 	u32 basic_rates = sdata->vif.bss_conf.basic_rates;
 
 	sband = local->hw.wiphy->bands[band];
-	rates = sband->n_bitrates;
+
+	if (WARN_ON(ieee80211_get_bitrates(sband,
+					   sdata->local->hw.conf.chandef.width,
+					   &bitrates, &rates)))
+		return -EINVAL;
+
 	if (rates > 8)
 		rates = 8;
 
@@ -2055,7 +2100,7 @@ int ieee80211_add_srates_ie(struct ieee80211_sub_if_data *sdata,
 		u8 basic = 0;
 		if (need_basic && basic_rates & BIT(i))
 			basic = 0x80;
-		rate = sband->bitrates[i].bitrate;
+		rate = bitrates[i].bitrate;
 		*pos++ = basic | (u8) ((rate + 4) / 5);
 	}
 
@@ -2068,11 +2113,17 @@ int ieee80211_add_ext_srates_ie(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_supported_band *sband;
-	int rate;
+	struct ieee80211_rate *bitrates;
+	int n_bitrates, rate;
 	u8 i, exrates, *pos;
 	u32 basic_rates = sdata->vif.bss_conf.basic_rates;
 
 	sband = local->hw.wiphy->bands[band];
+	if (WARN_ON(ieee80211_get_bitrates(sband,
+					   sdata->local->hw.conf.chandef.width,
+					   &bitrates, &n_bitrates)))
+		return -EINVAL;
+
 	exrates = sband->n_bitrates;
 	if (exrates > 8)
 		exrates -= 8;
@@ -2086,11 +2137,11 @@ int ieee80211_add_ext_srates_ie(struct ieee80211_sub_if_data *sdata,
 		pos = skb_put(skb, exrates + 2);
 		*pos++ = WLAN_EID_EXT_SUPP_RATES;
 		*pos++ = exrates;
-		for (i = 8; i < sband->n_bitrates; i++) {
+		for (i = 8; i < n_bitrates; i++) {
 			u8 basic = 0;
 			if (need_basic && basic_rates & BIT(i))
 				basic = 0x80;
-			rate = sband->bitrates[i].bitrate;
+			rate = bitrates[i].bitrate;
 			*pos++ = basic | (u8) ((rate + 4) / 5);
 		}
 	}
@@ -2175,9 +2226,18 @@ u64 ieee80211_calculate_rx_timestamp(struct ieee80211_local *local,
 			ri.flags |= RATE_INFO_FLAGS_SHORT_GI;
 	} else {
 		struct ieee80211_supported_band *sband;
+		struct ieee80211_rate *bitrates;
+		int n_bitrates;
 
 		sband = local->hw.wiphy->bands[status->band];
-		ri.legacy = sband->bitrates[status->rate_idx].bitrate;
+		if (WARN_ON(ieee80211_get_bitrates(sband,
+						   local->hw.conf.chandef.width,
+						   &bitrates, &n_bitrates))) {
+			bitrates = sband->bitrates;
+			n_bitrates = sband->n_bitrates;
+		}
+
+		ri.legacy = bitrates[status->rate_idx].bitrate;
 	}
 
 	rate = cfg80211_calculate_bitrate(&ri);
-- 
1.7.10.4

