Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:45233 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828Ab3F0Mom (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jun 2013 08:44:42 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv4 04/18] mac80211: select and adjust bitrates according to channel mode
Date: Thu, 27 Jun 2013 14:44:10 +0200
Message-Id: <1372337064-19254-5-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130627_144508_854753_9B8770F3)
In-Reply-To: <1372337064-19254-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1372337064-19254-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The various components accessing the bitrates table must use consider
the used channel bandwidth to select only available rates or calculate
the bitrate correctly.

There are some rates in reduced bandwidth modes which can't be
represented as multiples of 500kbps, like 2.25 MBit/s in 5 MHz mode. The
standard suggests to round up to the next multiple of 500kbps, just do
that in mac80211 as well.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
Changes to PATCHv3:
 * get divisor from flags in ieee80211_calculate_rx_timestamp
 * use sdata instead of local for sta_get_rates
 * don't access hw.conf (this would break chandef drivers)
 * put similar bitrate parsing functions into ieee80211_parse_bitrates()
---
 net/mac80211/cfg.c         |   47 ++++++-------
 net/mac80211/ibss.c        |   81 ++++++++++++++++------
 net/mac80211/ieee80211_i.h |   18 ++---
 net/mac80211/mesh.c        |    2 +-
 net/mac80211/mesh_plink.c  |    2 +-
 net/mac80211/mlme.c        |   93 ++++++++++++++------------
 net/mac80211/rate.c        |   50 +++++++-------
 net/mac80211/rx.c          |    7 +-
 net/mac80211/scan.c        |   27 +++++++-
 net/mac80211/status.c      |   17 +++--
 net/mac80211/tx.c          |   22 ++++--
 net/mac80211/util.c        |  159 +++++++++++++++++++++++++++++++++++---------
 12 files changed, 356 insertions(+), 169 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 082f270..0a5d6a5 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -395,9 +395,13 @@ void sta_set_rate_info_tx(struct sta_info *sta,
 		rinfo->nss = ieee80211_rate_get_vht_nss(rate);
 	} else {
 		struct ieee80211_supported_band *sband;
+		int divisor = ieee80211_vif_get_divisor(&sta->sdata->vif);
+		u16 brate;
+
 		sband = sta->local->hw.wiphy->bands[
 				ieee80211_get_sdata_band(sta->sdata)];
-		rinfo->legacy = sband->bitrates[rate->idx].bitrate;
+		brate = sband->bitrates[rate->idx].bitrate;
+		rinfo->legacy = DIV_ROUND_UP(brate, divisor);
 	}
 	if (rate->flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
 		rinfo->flags |= RATE_INFO_FLAGS_40_MHZ_WIDTH;
@@ -422,11 +426,14 @@ void sta_set_rate_info_rx(struct sta_info *sta, struct rate_info *rinfo)
 		rinfo->mcs = sta->last_rx_rate_idx;
 	} else {
 		struct ieee80211_supported_band *sband;
+		int divisor = ieee80211_vif_get_divisor(&sta->sdata->vif);
 
 		sband = sta->local->hw.wiphy->bands[
 				ieee80211_get_sdata_band(sta->sdata)];
 		rinfo->legacy =
-			sband->bitrates[sta->last_rx_rate_idx].bitrate;
+			DIV_ROUND_UP(sband->bitrates[
+					sta->last_rx_rate_idx].bitrate,
+				     divisor);
 	}
 
 	if (sta->last_rx_rate_flag & RX_FLAG_40MHZ)
@@ -1185,13 +1192,14 @@ static int sta_apply_auth_flags(struct ieee80211_local *local,
 	return 0;
 }
 
+
+
+
 static int sta_apply_parameters(struct ieee80211_local *local,
 				struct sta_info *sta,
 				struct station_parameters *params)
 {
 	int ret = 0;
-	u32 rates;
-	int i, j;
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	enum ieee80211_band band = ieee80211_get_sdata_band(sdata);
@@ -1284,16 +1292,10 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 		sta->listen_interval = params->listen_interval;
 
 	if (params->supported_rates) {
-		rates = 0;
-
-		for (i = 0; i < params->supported_rates_len; i++) {
-			int rate = (params->supported_rates[i] & 0x7f) * 5;
-			for (j = 0; j < sband->n_bitrates; j++) {
-				if (sband->bitrates[j].bitrate == rate)
-					rates |= BIT(j);
-			}
-		}
-		sta->sta.supp_rates[band] = rates;
+		ieee80211_parse_bitrates(&sdata->vif.bss_conf.chandef,
+					 sband, params->supported_rates,
+					 params->supported_rates_len,
+					 &sta->sta.supp_rates[band]);
 	}
 
 	if (params->ht_capa)
@@ -1956,18 +1958,11 @@ static int ieee80211_change_bss(struct wiphy *wiphy,
 	}
 
 	if (params->basic_rates) {
-		int i, j;
-		u32 rates = 0;
-		struct ieee80211_supported_band *sband = wiphy->bands[band];
-
-		for (i = 0; i < params->basic_rates_len; i++) {
-			int rate = (params->basic_rates[i] & 0x7f) * 5;
-			for (j = 0; j < sband->n_bitrates; j++) {
-				if (sband->bitrates[j].bitrate == rate)
-					rates |= BIT(j);
-			}
-		}
-		sdata->vif.bss_conf.basic_rates = rates;
+		ieee80211_parse_bitrates(&sdata->vif.bss_conf.chandef,
+					 wiphy->bands[band],
+					 params->basic_rates,
+					 params->basic_rates_len,
+					 &sdata->vif.bss_conf.basic_rates);
 		changed |= BSS_CHANGED_BASIC_RATES;
 	}
 
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index eaacfd2..f3171fc 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -43,16 +43,17 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 	struct ieee80211_local *local = sdata->local;
-	int rates, i;
+	int rates_n = 0, i, ri;
 	struct ieee80211_mgmt *mgmt;
 	u8 *pos;
 	struct ieee80211_supported_band *sband;
 	struct cfg80211_bss *bss;
-	u32 bss_change;
+	u32 bss_change, rate_flags, rates = 0, rates_added = 0;
 	u8 supp_rates[IEEE80211_MAX_SUPP_RATES];
 	struct cfg80211_chan_def chandef;
 	struct beacon_data *presp;
 	int frame_len;
+	int divisor;
 
 	sdata_assert_lock(sdata);
 
@@ -99,6 +100,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	memcpy(ifibss->bssid, bssid, ETH_ALEN);
 
 	sband = local->hw.wiphy->bands[chan->band];
+	divisor = ieee80211_vif_get_divisor(&sdata->vif);
 
 	/* Build IBSS probe response */
 	frame_len = sizeof(struct ieee80211_hdr_3addr) +
@@ -134,15 +136,29 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	memcpy(pos, ifibss->ssid, ifibss->ssid_len);
 	pos += ifibss->ssid_len;
 
-	rates = min_t(int, 8, sband->n_bitrates);
+	rate_flags = ieee80211_chandef_rate_flags(&chandef);
+	for (i = 0; i < sband->n_bitrates; i++) {
+		if ((rate_flags & sband->bitrates[i].flags) != rate_flags)
+			continue;
+
+		rates |= BIT(i);
+		rates_n++;
+	}
+
 	*pos++ = WLAN_EID_SUPP_RATES;
-	*pos++ = rates;
-	for (i = 0; i < rates; i++) {
-		int rate = sband->bitrates[i].bitrate;
+	*pos++ = min_t(int, 8, rates_n);
+	for (ri = 0; ri < sband->n_bitrates; ri++) {
+		int rate = DIV_ROUND_UP(sband->bitrates[ri].bitrate,
+					5 * divisor);
 		u8 basic = 0;
-		if (basic_rates & BIT(i))
+		if (!(rates & BIT(ri)))
+			continue;
+
+		if (basic_rates & BIT(ri))
 			basic = 0x80;
-		*pos++ = basic | (u8) (rate / 5);
+		*pos++ = basic | (u8) rate;
+		if (++rates_added == 8)
+			break;
 	}
 
 	if (sband->band == IEEE80211_BAND_2GHZ) {
@@ -157,15 +173,20 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	*pos++ = 0;
 	*pos++ = 0;
 
-	if (sband->n_bitrates > 8) {
+	/* put the remaining rates in WLAN_EID_EXT_SUPP_RATES */
+	if (rates_n > 8) {
 		*pos++ = WLAN_EID_EXT_SUPP_RATES;
-		*pos++ = sband->n_bitrates - 8;
-		for (i = 8; i < sband->n_bitrates; i++) {
-			int rate = sband->bitrates[i].bitrate;
+		*pos++ = rates_n - 8;
+		for (; ri < sband->n_bitrates; ri++) {
+			int rate = DIV_ROUND_UP(sband->bitrates[ri].bitrate,
+						5 * divisor);
 			u8 basic = 0;
-			if (basic_rates & BIT(i))
+			if (!(rates & BIT(ri)))
+				continue;
+
+			if (basic_rates & BIT(ri))
 				basic = 0x80;
-			*pos++ = basic | (u8) (rate / 5);
+			*pos++ = basic | (u8) rate;
 		}
 	}
 
@@ -240,7 +261,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	sdata->vif.bss_conf.ibss_creator = creator;
 	ieee80211_bss_info_change_notify(sdata, bss_change);
 
-	ieee80211_sta_def_wmm_params(sdata, sband->n_bitrates, supp_rates);
+	ieee80211_sta_def_wmm_params(sdata, rates, supp_rates);
 
 	ifibss->state = IEEE80211_IBSS_MLME_JOINED;
 	mod_timer(&ifibss->timer,
@@ -264,6 +285,8 @@ static void ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	u16 beacon_int = cbss->beacon_interval;
 	const struct cfg80211_bss_ies *ies;
 	u64 tsf;
+	u32 rate_flags;
+	int divisor;
 
 	sdata_assert_lock(sdata);
 
@@ -271,15 +294,24 @@ static void ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 		beacon_int = 10;
 
 	sband = sdata->local->hw.wiphy->bands[cbss->channel->band];
+	rate_flags = ieee80211_chandef_rate_flags(&sdata->u.ibss.chandef);
+	divisor = ieee80211_vif_get_divisor(&sdata->vif);
 
 	basic_rates = 0;
 
 	for (i = 0; i < bss->supp_rates_len; i++) {
-		int rate = (bss->supp_rates[i] & 0x7f) * 5;
+		int rate = bss->supp_rates[i] & 0x7f;
 		bool is_basic = !!(bss->supp_rates[i] & 0x80);
 
 		for (j = 0; j < sband->n_bitrates; j++) {
-			if (sband->bitrates[j].bitrate == rate) {
+			int brate;
+			if ((rate_flags & sband->bitrates[j].flags)
+			    != rate_flags)
+				continue;
+
+			brate = DIV_ROUND_UP(sband->bitrates[j].bitrate,
+					     5 * divisor);
+			if (brate == rate) {
 				if (is_basic)
 					basic_rates |= BIT(j);
 				break;
@@ -488,7 +520,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 		sta = sta_info_get(sdata, mgmt->sa);
 
 		if (elems->supp_rates) {
-			supp_rates = ieee80211_sta_get_rates(local, elems,
+			supp_rates = ieee80211_sta_get_rates(sdata, elems,
 							     band, NULL);
 			if (sta) {
 				u32 prev_rates;
@@ -612,7 +644,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 			 "beacon TSF higher than local TSF - IBSS merge with BSSID %pM\n",
 			 mgmt->bssid);
 		ieee80211_sta_join_ibss(sdata, bss);
-		supp_rates = ieee80211_sta_get_rates(local, elems, band, NULL);
+		supp_rates = ieee80211_sta_get_rates(sdata, elems, band, NULL);
 		ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa,
 				       supp_rates, true);
 		rcu_read_unlock();
@@ -1047,6 +1079,9 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 			struct cfg80211_ibss_params *params)
 {
 	u32 changed = 0;
+	u32 rate_flags;
+	struct ieee80211_supported_band *sband;
+	int i;
 
 	if (params->bssid) {
 		memcpy(sdata->u.ibss.bssid, params->bssid, ETH_ALEN);
@@ -1057,6 +1092,14 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 	sdata->u.ibss.privacy = params->privacy;
 	sdata->u.ibss.control_port = params->control_port;
 	sdata->u.ibss.basic_rates = params->basic_rates;
+
+	/* fix basic_rates if channel does not support these rates */
+	rate_flags = ieee80211_chandef_rate_flags(&params->chandef);
+	sband = sdata->local->hw.wiphy->bands[params->chandef.chan->band];
+	for (i = 0; i < sband->n_bitrates; i++) {
+		if ((rate_flags & sband->bitrates[i].flags) != rate_flags)
+			sdata->u.ibss.basic_rates &= ~BIT(i);
+	}
 	memcpy(sdata->vif.bss_conf.mcast_rate, params->mcast_rate,
 	       sizeof(params->mcast_rate));
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 83c248a..fc15d12 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -811,7 +811,7 @@ ieee80211_get_sdata_band(struct ieee80211_sub_if_data *sdata)
 static inline int
 ieee80211_chandef_get_divisor(struct cfg80211_chan_def *chandef)
 {
-	switch (local->hw.conf.chandef.width) {
+	switch (chandef->width) {
 	case NL80211_CHAN_WIDTH_5:
 		return 4;
 	case NL80211_CHAN_WIDTH_10:
@@ -836,15 +836,6 @@ ieee80211_vif_get_divisor(struct ieee80211_vif *vif)
 	return divisor;
 }
 
-static inline int
-ieee80211_local_get_divisor(struct ieee80211_local *local)
-{
-	if (local->use_chanctx)
-		return 1;
-
-	return ieee80211_chandef_get_divisor(&local->hw.conf.chandef);
-}
-
 enum sdata_queue_type {
 	IEEE80211_SDATA_QUEUE_TYPE_FRAME	= 0,
 	IEEE80211_SDATA_QUEUE_AGG_START		= 1,
@@ -1606,7 +1597,7 @@ void ieee80211_send_deauth_disassoc(struct ieee80211_sub_if_data *sdata,
 int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
 			     size_t buffer_len, const u8 *ie, size_t ie_len,
 			     enum ieee80211_band band, u32 rate_mask,
-			     u8 channel);
+			     struct cfg80211_chan_def *chandef);
 struct sk_buff *ieee80211_build_probe_req(struct ieee80211_sub_if_data *sdata,
 					  u8 *dst, u32 ratemask,
 					  struct ieee80211_channel *chan,
@@ -1622,7 +1613,7 @@ void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
 void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data *sdata,
 				  const size_t supp_rates_len,
 				  const u8 *supp_rates);
-u32 ieee80211_sta_get_rates(struct ieee80211_local *local,
+u32 ieee80211_sta_get_rates(struct ieee80211_sub_if_data *sdata,
 			    struct ieee802_11_elems *elems,
 			    enum ieee80211_band band, u32 *basic_rates);
 int __ieee80211_request_smps(struct ieee80211_sub_if_data *sdata,
@@ -1639,6 +1630,9 @@ u8 *ieee80211_ie_build_ht_oper(u8 *pos, struct ieee80211_sta_ht_cap *ht_cap,
 			       u16 prot_mode);
 u8 *ieee80211_ie_build_vht_cap(u8 *pos, struct ieee80211_sta_vht_cap *vht_cap,
 			       u32 cap);
+int ieee80211_parse_bitrates(struct cfg80211_chan_def *chandef,
+			     const struct ieee80211_supported_band *sband,
+			     const u8 *srates, int srates_len, u32 *rates);
 int ieee80211_add_srates_ie(struct ieee80211_sub_if_data *sdata,
 			    struct sk_buff *skb, bool need_basic,
 			    enum ieee80211_band band);
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 5cb0e04..a31a825 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -85,7 +85,7 @@ bool mesh_matches_local(struct ieee80211_sub_if_data *sdata,
 	     (ifmsh->mesh_auth_id == ie->mesh_config->meshconf_auth)))
 		return false;
 
-	ieee80211_sta_get_rates(local, ie, ieee80211_get_sdata_band(sdata),
+	ieee80211_sta_get_rates(sdata, ie, ieee80211_get_sdata_band(sdata),
 				&basic_rates);
 
 	if (sdata->vif.bss_conf.basic_rates != basic_rates)
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 02c05fa..6b65d50 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -379,7 +379,7 @@ static void mesh_sta_info_init(struct ieee80211_sub_if_data *sdata,
 	u32 rates, basic_rates = 0, changed = 0;
 
 	sband = local->hw.wiphy->bands[band];
-	rates = ieee80211_sta_get_rates(local, elems, band, &basic_rates);
+	rates = ieee80211_sta_get_rates(sdata, elems, band, &basic_rates);
 
 	spin_lock_bh(&sta->lock);
 	sta->last_rx = jiffies;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index e23263ab..3848b8a 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -478,27 +478,6 @@ static int ieee80211_config_bw(struct ieee80211_sub_if_data *sdata,
 
 /* frame sending functions */
 
-static int ieee80211_compatible_rates(const u8 *supp_rates, int supp_rates_len,
-				      struct ieee80211_supported_band *sband,
-				      u32 *rates)
-{
-	int i, j, count;
-	*rates = 0;
-	count = 0;
-	for (i = 0; i < supp_rates_len; i++) {
-		int rate = (supp_rates[i] & 0x7F) * 5;
-
-		for (j = 0; j < sband->n_bitrates; j++)
-			if (sband->bitrates[j].bitrate == rate) {
-				*rates |= BIT(j);
-				count++;
-				break;
-			}
-	}
-
-	return count;
-}
-
 static void ieee80211_add_ht_ie(struct ieee80211_sub_if_data *sdata,
 				struct sk_buff *skb, u8 ap_ht_param,
 				struct ieee80211_supported_band *sband,
@@ -617,12 +596,12 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 	struct ieee80211_mgmt *mgmt;
 	u8 *pos, qos_info;
 	size_t offset = 0, noffset;
-	int i, count, rates_len, supp_rates_len;
+	int i, count, rates_len, supp_rates_len, divisor;
 	u16 capab;
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	struct ieee80211_channel *chan;
-	u32 rates = 0;
+	u32 rate_flags, rates = 0;
 
 	sdata_assert_lock(sdata);
 
@@ -633,8 +612,10 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 		return;
 	}
 	chan = chanctx_conf->def.chan;
+	rate_flags = ieee80211_chandef_rate_flags(&chanctx_conf->def);
 	rcu_read_unlock();
 	sband = local->hw.wiphy->bands[chan->band];
+	divisor = ieee80211_vif_get_divisor(&sdata->vif);
 
 	if (assoc_data->supp_rates_len) {
 		/*
@@ -643,17 +624,24 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 		 * in the association request (e.g. D-Link DAP 1353 in
 		 * b-only mode)...
 		 */
-		rates_len = ieee80211_compatible_rates(assoc_data->supp_rates,
-						       assoc_data->supp_rates_len,
-						       sband, &rates);
+		rates_len = ieee80211_parse_bitrates(&chanctx_conf->def, sband,
+						     assoc_data->supp_rates,
+						     assoc_data->supp_rates_len,
+						     &rates);
 	} else {
 		/*
 		 * In case AP not provide any supported rates information
 		 * before association, we send information element(s) with
 		 * all rates that we support.
 		 */
-		rates = ~0;
-		rates_len = sband->n_bitrates;
+		rates_len = 0;
+		for (i = 0; i < sband->n_bitrates; i++) {
+			if ((rate_flags & sband->bitrates[i].flags)
+			    != rate_flags)
+				continue;
+			rates |= BIT(i);
+			rates_len++;
+		}
 	}
 
 	skb = alloc_skb(local->hw.extra_tx_headroom +
@@ -730,8 +718,9 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 	count = 0;
 	for (i = 0; i < sband->n_bitrates; i++) {
 		if (BIT(i) & rates) {
-			int rate = sband->bitrates[i].bitrate;
-			*pos++ = (u8) (rate / 5);
+			int rate = DIV_ROUND_UP(sband->bitrates[i].bitrate,
+						5 * divisor);
+			*pos++ = (u8) rate;
 			if (++count == 8)
 				break;
 		}
@@ -744,8 +733,10 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 
 		for (i++; i < sband->n_bitrates; i++) {
 			if (BIT(i) & rates) {
-				int rate = sband->bitrates[i].bitrate;
-				*pos++ = (u8) (rate / 5);
+				int rate;
+				rate = DIV_ROUND_UP(sband->bitrates[i].bitrate,
+						    5 * divisor);
+				*pos++ = (u8) rate;
 			}
 		}
 	}
@@ -2428,15 +2419,16 @@ static void ieee80211_get_rates(struct ieee80211_supported_band *sband,
 				u8 *supp_rates, unsigned int supp_rates_len,
 				u32 *rates, u32 *basic_rates,
 				bool *have_higher_than_11mbit,
-				int *min_rate, int *min_rate_index)
+				int *min_rate, int *min_rate_index,
+				int divisor, u32 rate_flags)
 {
 	int i, j;
 
 	for (i = 0; i < supp_rates_len; i++) {
-		int rate = (supp_rates[i] & 0x7f) * 5;
+		int rate = supp_rates[i] & 0x7f;
 		bool is_basic = !!(supp_rates[i] & 0x80);
 
-		if (rate > 110)
+		if ((rate * 5 * divisor) > 110)
 			*have_higher_than_11mbit = true;
 
 		/*
@@ -2452,12 +2444,18 @@ static void ieee80211_get_rates(struct ieee80211_supported_band *sband,
 			continue;
 
 		for (j = 0; j < sband->n_bitrates; j++) {
-			if (sband->bitrates[j].bitrate == rate) {
+			struct ieee80211_rate *br;
+
+			br = &sband->bitrates[j];
+			if ((rate_flags & br->flags) != rate_flags)
+				continue;
+
+			if (DIV_ROUND_UP(br->bitrate, divisor * 5) == rate) {
 				*rates |= BIT(j);
 				if (is_basic)
 					*basic_rates |= BIT(j);
-				if (rate < *min_rate) {
-					*min_rate = rate;
+				if ((rate * 5) < *min_rate) {
+					*min_rate = rate * 5;
 					*min_rate_index = j;
 				}
 				break;
@@ -3882,27 +3880,40 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 		if (!new_sta)
 			return -ENOMEM;
 	}
-
 	if (new_sta) {
 		u32 rates = 0, basic_rates = 0;
 		bool have_higher_than_11mbit;
 		int min_rate = INT_MAX, min_rate_index = -1;
+		struct ieee80211_chanctx_conf *chanctx_conf;
 		struct ieee80211_supported_band *sband;
 		const struct cfg80211_bss_ies *ies;
+		int divisor;
+		u32 rate_flags;
 
 		sband = local->hw.wiphy->bands[cbss->channel->band];
 
 		err = ieee80211_prep_channel(sdata, cbss);
 		if (err) {
 			sta_info_free(local, new_sta);
-			return err;
+			return -EINVAL;
 		}
+		divisor = ieee80211_vif_get_divisor(&sdata->vif);
+
+		rcu_read_lock();
+		chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
+		if (WARN_ON(!chanctx_conf)) {
+			rcu_read_unlock();
+			return -EINVAL;
+		}
+		rate_flags = ieee80211_chandef_rate_flags(&chanctx_conf->def);
+		rcu_read_unlock();
 
 		ieee80211_get_rates(sband, bss->supp_rates,
 				    bss->supp_rates_len,
 				    &rates, &basic_rates,
 				    &have_higher_than_11mbit,
-				    &min_rate, &min_rate_index);
+				    &min_rate, &min_rate_index,
+				    divisor, rate_flags);
 
 		/*
 		 * This used to be a workaround for basic rates missing
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 30d58d2..ba63ac8 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -232,37 +232,28 @@ static void rc_send_low_broadcast(s8 *idx, u32 basic_rates,
 	/* could not find a basic rate; use original selection */
 }
 
-static inline s8
-rate_lowest_non_cck_index(struct ieee80211_supported_band *sband,
-			  struct ieee80211_sta *sta)
-{
-	int i;
-
-	for (i = 0; i < sband->n_bitrates; i++) {
-		struct ieee80211_rate *srate = &sband->bitrates[i];
-		if ((srate->bitrate == 10) || (srate->bitrate == 20) ||
-		    (srate->bitrate == 55) || (srate->bitrate == 110))
-			continue;
-
-		if (rate_supported(sta, sband->band, i))
-			return i;
-	}
-
-	/* No matching rate found */
-	return 0;
-}
-
 static void __rate_control_send_low(struct ieee80211_hw *hw,
 				    struct ieee80211_supported_band *sband,
 				    struct ieee80211_sta *sta,
 				    struct ieee80211_tx_info *info)
 {
-	if ((sband->band != IEEE80211_BAND_2GHZ) ||
-	    !(info->flags & IEEE80211_TX_CTL_NO_CCK_RATE))
-		info->control.rates[0].idx = rate_lowest_index(sband, sta);
-	else
-		info->control.rates[0].idx =
-			rate_lowest_non_cck_index(sband, sta);
+	int i;
+	u32 rate_flags =
+		ieee80211_chandef_rate_flags(&hw->conf.chandef);
+
+	if ((sband->band == IEEE80211_BAND_2GHZ) &&
+	    (info->flags & IEEE80211_TX_CTL_NO_CCK_RATE))
+		rate_flags |= IEEE80211_RATE_ERP_G;
+
+	info->control.rates[0].idx = 0;
+	for (i = 0; i < sband->n_bitrates; i++) {
+		if (!rate_supported(sta, sband->band, i))
+			continue;
+
+		info->control.rates[0].idx = i;
+		break;
+	}
+	WARN_ON_ONCE(i == sband->n_bitrates);
 
 	info->control.rates[0].count =
 		(info->flags & IEEE80211_TX_CTL_NO_ACK) ?
@@ -585,6 +576,7 @@ static void rate_control_apply_mask(struct ieee80211_sub_if_data *sdata,
 	u8 mcs_mask[IEEE80211_HT_MCS_MASK_LEN];
 	bool has_mcs_mask;
 	u32 mask;
+	u32 rate_flags;
 	int i;
 
 	/*
@@ -594,6 +586,12 @@ static void rate_control_apply_mask(struct ieee80211_sub_if_data *sdata,
 	 */
 	mask = sdata->rc_rateidx_mask[info->band];
 	has_mcs_mask = sdata->rc_has_mcs_mask[info->band];
+	rate_flags =
+		ieee80211_chandef_rate_flags(&sdata->vif.bss_conf.chandef);
+	for (i = 0; i < sband->n_bitrates; i++)
+		if ((rate_flags & sband->bitrates[i].flags) != rate_flags)
+			mask &= ~BIT(i);
+
 	if (mask == (1 << sband->n_bitrates) - 1 && !has_mcs_mask)
 		return;
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 23dbcfc..a45e934 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -207,8 +207,13 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 		 */
 		*pos = 0;
 	} else {
+		int divisor = 1;
 		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_RATE);
-		*pos = rate->bitrate / 5;
+		if (status->flag & RX_FLAG_10MHZ)
+			divisor = 2;
+		else if (status->flag & RX_FLAG_5MHZ)
+			divisor = 4;
+		*pos = DIV_ROUND_UP(rate->bitrate, 5 * divisor);
 	}
 	pos++;
 
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 99b10392..b1bfb05 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -195,10 +195,29 @@ void ieee80211_scan_rx(struct ieee80211_local *local, struct sk_buff *skb)
 		ieee80211_rx_bss_put(local, bss);
 }
 
+static void
+ieee80211_prepare_scan_chandef(struct cfg80211_chan_def *chandef,
+			       enum nl80211_bss_scan_width scan_width)
+{
+	memset(chandef, 0, sizeof(*chandef));
+	switch (scan_width) {
+	case NL80211_BSS_CHAN_WIDTH_5:
+		chandef->width = NL80211_CHAN_WIDTH_5;
+		break;
+	case NL80211_BSS_CHAN_WIDTH_10:
+		chandef->width = NL80211_CHAN_WIDTH_10;
+		break;
+	default:
+		chandef->width = NL80211_CHAN_WIDTH_20_NOHT;
+		break;
+	}
+}
+
 /* return false if no more work */
 static bool ieee80211_prep_hw_scan(struct ieee80211_local *local)
 {
 	struct cfg80211_scan_request *req = local->scan_req;
+	struct cfg80211_chan_def chandef;
 	enum ieee80211_band band;
 	int i, ielen, n_chans;
 
@@ -220,11 +239,12 @@ static bool ieee80211_prep_hw_scan(struct ieee80211_local *local)
 	} while (!n_chans);
 
 	local->hw_scan_req->n_channels = n_chans;
+	ieee80211_prepare_scan_chandef(&chandef, req->scan_width);
 
 	ielen = ieee80211_build_preq_ies(local, (u8 *)local->hw_scan_req->ie,
 					 local->hw_scan_ies_bufsize,
 					 req->ie, req->ie_len, band,
-					 req->rates[band], 0);
+					 req->rates[band], &chandef);
 	local->hw_scan_req->ie_len = ielen;
 	local->hw_scan_req->no_cck = req->no_cck;
 
@@ -903,6 +923,7 @@ int ieee80211_request_sched_scan_start(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_sched_scan_ies sched_scan_ies = {};
+	struct cfg80211_chan_def chandef;
 	int ret, i, iebufsz;
 
 	iebufsz = 2 + IEEE80211_MAX_SSID_LEN +
@@ -930,10 +951,12 @@ int ieee80211_request_sched_scan_start(struct ieee80211_sub_if_data *sdata,
 			goto out_free;
 		}
 
+		ieee80211_prepare_scan_chandef(&chandef, req->scan_width);
+
 		sched_scan_ies.len[i] =
 			ieee80211_build_preq_ies(local, sched_scan_ies.ie[i],
 						 iebufsz, req->ie, req->ie_len,
-						 i, (u32) -1, 0);
+						 i, (u32) -1, &chandef);
 	}
 
 	ret = drv_sched_scan_start(local, sdata, req, &sched_scan_ies);
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 4343920..1841481 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -252,9 +252,11 @@ static int ieee80211_tx_radiotap_len(struct ieee80211_tx_info *info)
 	return len;
 }
 
-static void ieee80211_add_tx_radiotap_header(struct ieee80211_supported_band
-					     *sband, struct sk_buff *skb,
-					     int retry_count, int rtap_len)
+static void
+ieee80211_add_tx_radiotap_header(struct ieee80211_sub_if_data *sdata,
+				 struct ieee80211_supported_band *sband,
+				 struct sk_buff *skb, int retry_count,
+				 int rtap_len)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
@@ -280,8 +282,12 @@ static void ieee80211_add_tx_radiotap_header(struct ieee80211_supported_band
 	/* IEEE80211_RADIOTAP_RATE */
 	if (info->status.rates[0].idx >= 0 &&
 	    !(info->status.rates[0].flags & IEEE80211_TX_RC_MCS)) {
+		int divisor = ieee80211_vif_get_divisor(&sdata->vif);
+		int rate;
+
 		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_RATE);
-		*pos = sband->bitrates[info->status.rates[0].idx].bitrate / 5;
+		rate = sband->bitrates[info->status.rates[0].idx].bitrate;
+		*pos = DIV_ROUND_UP(rate, 5 * divisor);
 		/* padding for tx flags */
 		pos += 2;
 	}
@@ -624,7 +630,8 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 		dev_kfree_skb(skb);
 		return;
 	}
-	ieee80211_add_tx_radiotap_header(sband, skb, retry_count, rtap_len);
+	ieee80211_add_tx_radiotap_header(sdata, sband, skb, retry_count,
+					 rtap_len);
 
 	/* XXX: is this sufficient for BPF? */
 	skb_set_mac_header(skb, 0);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 69f3363..5b0a82a 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -40,12 +40,23 @@ static __le16 ieee80211_duration(struct ieee80211_tx_data *tx,
 				 struct sk_buff *skb, int group_addr,
 				 int next_frag_len)
 {
-	int rate, mrate, erp, dur, i, divisor;
+	int rate, mrate, erp, dur, i;
 	struct ieee80211_rate *txrate;
 	struct ieee80211_local *local = tx->local;
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_hdr *hdr;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_chanctx_conf *chanctx_conf;
+	u32 rate_flags = 0;
+	int divisor = 1;
+
+	rcu_read_lock();
+	chanctx_conf = rcu_dereference(tx->sdata->vif.chanctx_conf);
+	if (chanctx_conf) {
+		divisor = ieee80211_chandef_get_divisor(&chanctx_conf->def);
+		rate_flags = ieee80211_chandef_rate_flags(&chanctx_conf->def);
+	}
+	rcu_read_unlock();
 
 	/* assume HW handles this */
 	if (tx->rate.flags & IEEE80211_TX_RC_MCS)
@@ -122,8 +133,11 @@ static __le16 ieee80211_duration(struct ieee80211_tx_data *tx,
 		if (r->bitrate > txrate->bitrate)
 			break;
 
+		if ((rate_flags & r->flags) != rate_flags)
+			continue;
+
 		if (tx->sdata->vif.bss_conf.basic_rates & BIT(i))
-			rate = r->bitrate;
+			rate = DIV_ROUND_UP(r->bitrate, divisor);
 
 		switch (sband->band) {
 		case IEEE80211_BAND_2GHZ: {
@@ -150,11 +164,9 @@ static __le16 ieee80211_duration(struct ieee80211_tx_data *tx,
 	if (rate == -1) {
 		/* No matching basic rate found; use highest suitable mandatory
 		 * PHY rate */
-		rate = mrate;
+		rate = DIV_ROUND_UP(mrate, divisor);
 	}
 
-	divisor = ieee80211_vif_get_divisor(&tx->sdata->vif);
-
 	/* Don't calculate ACKs for QoS Frames with NoAck Policy set */
 	if (ieee80211_is_data_qos(hdr->frame_control) &&
 	    *(ieee80211_get_qos_ctl(hdr)) & IEEE80211_QOS_CTL_ACK_POLICY_NOACK)
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 978c15e..fe7b1c8 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -141,14 +141,19 @@ int ieee80211_frame_duration(enum ieee80211_band band, size_t len,
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
+		/* rates should already consider the channel bandwidth,
+		 * don't apply divisor again.
+		 */
+		dur += 4 * DIV_ROUND_UP((16 + 8 * (len + 4) + 6) * 10,
+					4 * rate); /* T_SYM x N_SYM */
+
 	} else {
 		/*
 		 * 802.11b or 802.11g with 802.11b compatibility:
@@ -205,7 +210,7 @@ __le16 ieee80211_rts_duration(struct ieee80211_hw *hw,
 	struct ieee80211_rate *rate;
 	struct ieee80211_sub_if_data *sdata;
 	bool short_preamble;
-	int erp, divisor = 1;
+	int erp, divisor = 1, bitrate;
 	u16 dur;
 	struct ieee80211_supported_band *sband;
 
@@ -224,14 +229,16 @@ __le16 ieee80211_rts_duration(struct ieee80211_hw *hw,
 		divisor = ieee80211_vif_get_divisor(vif);
 	}
 
+	bitrate = DIV_ROUND_UP(rate->bitrate, divisor);
+
 	/* CTS duration */
-	dur = ieee80211_frame_duration(sband->band, 10, rate->bitrate,
+	dur = ieee80211_frame_duration(sband->band, 10, bitrate,
 				       erp, short_preamble, divisor);
 	/* Data frame duration */
-	dur += ieee80211_frame_duration(sband->band, frame_len, rate->bitrate,
+	dur += ieee80211_frame_duration(sband->band, frame_len, bitrate,
 					erp, short_preamble, divisor);
 	/* ACK duration */
-	dur += ieee80211_frame_duration(sband->band, 10, rate->bitrate,
+	dur += ieee80211_frame_duration(sband->band, 10, bitrate,
 					erp, short_preamble, divisor);
 
 	return cpu_to_le16(dur);
@@ -247,7 +254,7 @@ __le16 ieee80211_ctstoself_duration(struct ieee80211_hw *hw,
 	struct ieee80211_rate *rate;
 	struct ieee80211_sub_if_data *sdata;
 	bool short_preamble;
-	int erp, divisor = 1;
+	int erp, divisor = 1, bitrate;
 	u16 dur;
 	struct ieee80211_supported_band *sband;
 
@@ -265,12 +272,14 @@ __le16 ieee80211_ctstoself_duration(struct ieee80211_hw *hw,
 		divisor = ieee80211_vif_get_divisor(vif);
 	}
 
+	bitrate = DIV_ROUND_UP(rate->bitrate, divisor);
+
 	/* Data frame duration */
-	dur = ieee80211_frame_duration(sband->band, frame_len, rate->bitrate,
+	dur = ieee80211_frame_duration(sband->band, frame_len, bitrate,
 				       erp, short_preamble, divisor);
 	if (!(frame_txctl->flags & IEEE80211_TX_CTL_NO_ACK)) {
 		/* ACK duration */
-		dur += ieee80211_frame_duration(sband->band, 10, rate->bitrate,
+		dur += ieee80211_frame_duration(sband->band, 10, bitrate,
 						erp, short_preamble, divisor);
 	}
 
@@ -1175,7 +1184,7 @@ void ieee80211_send_deauth_disassoc(struct ieee80211_sub_if_data *sdata,
 int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
 			     size_t buffer_len, const u8 *ie, size_t ie_len,
 			     enum ieee80211_band band, u32 rate_mask,
-			     u8 channel)
+			     struct cfg80211_chan_def *chandef)
 {
 	struct ieee80211_supported_band *sband;
 	u8 *pos = buffer, *end = buffer + buffer_len;
@@ -1184,16 +1193,26 @@ int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
 	u8 rates[32];
 	int num_rates;
 	int ext_rates_len;
+	int divisor;
+	u32 rate_flags;
 
 	sband = local->hw.wiphy->bands[band];
 	if (WARN_ON_ONCE(!sband))
 		return 0;
 
+	rate_flags = ieee80211_chandef_rate_flags(chandef);
+	divisor = ieee80211_chandef_get_divisor(chandef);
+
 	num_rates = 0;
 	for (i = 0; i < sband->n_bitrates; i++) {
 		if ((BIT(i) & rate_mask) == 0)
 			continue; /* skip rate */
-		rates[num_rates++] = (u8) (sband->bitrates[i].bitrate / 5);
+		if ((rate_flags & sband->bitrates[i].flags) != rate_flags)
+			continue;
+
+		rates[num_rates++] =
+			(u8) DIV_ROUND_UP(sband->bitrates[i].bitrate,
+					  divisor * 5);
 	}
 
 	supp_rates_len = min_t(int, num_rates, 8);
@@ -1233,12 +1252,13 @@ int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
 		pos += ext_rates_len;
 	}
 
-	if (channel && sband->band == IEEE80211_BAND_2GHZ) {
+	if (chandef->chan && sband->band == IEEE80211_BAND_2GHZ) {
 		if (end - pos < 3)
 			goto out_err;
 		*pos++ = WLAN_EID_DS_PARAMS;
 		*pos++ = 1;
-		*pos++ = channel;
+		*pos++ = ieee80211_frequency_to_channel(
+				chandef->chan->center_freq);
 	}
 
 	/* insert custom IEs that go before HT */
@@ -1303,9 +1323,9 @@ struct sk_buff *ieee80211_build_probe_req(struct ieee80211_sub_if_data *sdata,
 					  bool directed)
 {
 	struct ieee80211_local *local = sdata->local;
+	struct cfg80211_chan_def chandef;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
-	u8 chan_no;
 	int ies_len;
 
 	/*
@@ -1313,10 +1333,11 @@ struct sk_buff *ieee80211_build_probe_req(struct ieee80211_sub_if_data *sdata,
 	 * in order to maximize the chance that we get a response.  Some
 	 * badly-behaved APs don't respond when this parameter is included.
 	 */
+	chandef.width = sdata->vif.bss_conf.chandef.width;
 	if (directed)
-		chan_no = 0;
+		chandef.chan = NULL;
 	else
-		chan_no = ieee80211_frequency_to_channel(chan->center_freq);
+		chandef.chan = chan;
 
 	skb = ieee80211_probereq_get(&local->hw, &sdata->vif,
 				     ssid, ssid_len, 100 + ie_len);
@@ -1326,7 +1347,7 @@ struct sk_buff *ieee80211_build_probe_req(struct ieee80211_sub_if_data *sdata,
 	ies_len = ieee80211_build_preq_ies(local, skb_tail_pointer(skb),
 					   skb_tailroom(skb),
 					   ie, ie_len, chan->band,
-					   ratemask, chan_no);
+					   ratemask, &chandef);
 	skb_put(skb, ies_len);
 
 	if (dst) {
@@ -1360,16 +1381,19 @@ void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
 	}
 }
 
-u32 ieee80211_sta_get_rates(struct ieee80211_local *local,
+u32 ieee80211_sta_get_rates(struct ieee80211_sub_if_data *sdata,
 			    struct ieee802_11_elems *elems,
 			    enum ieee80211_band band, u32 *basic_rates)
 {
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_rate *bitrates;
 	size_t num_rates;
-	u32 supp_rates;
-	int i, j;
-	sband = local->hw.wiphy->bands[band];
+	u32 supp_rates, rate_flags;
+	int i, j, divisor;
+	sband = sdata->local->hw.wiphy->bands[band];
+
+	rate_flags = ieee80211_chandef_rate_flags(&sdata->vif.bss_conf.chandef);
+	divisor = ieee80211_vif_get_divisor(&sdata->vif);
 
 	if (WARN_ON(!sband))
 		return 1;
@@ -1394,7 +1418,15 @@ u32 ieee80211_sta_get_rates(struct ieee80211_local *local,
 			continue;
 
 		for (j = 0; j < num_rates; j++) {
-			if (bitrates[j].bitrate == own_rate) {
+			int brate;
+			if ((rate_flags & sband->bitrates[j].flags)
+			    != rate_flags)
+				continue;
+
+			brate = DIV_ROUND_UP(sband->bitrates[j].bitrate,
+					     divisor);
+
+			if (brate == own_rate) {
 				supp_rates |= BIT(j);
 				if (basic_rates && is_basic)
 					*basic_rates |= BIT(j);
@@ -2017,18 +2049,55 @@ void ieee80211_ht_oper_to_chandef(struct ieee80211_channel *control_chan,
 	cfg80211_chandef_create(chandef, control_chan, channel_type);
 }
 
+int ieee80211_parse_bitrates(struct cfg80211_chan_def *chandef,
+			     const struct ieee80211_supported_band *sband,
+			     const u8 *srates, int srates_len, u32 *rates)
+{
+	u32 rate_flags = ieee80211_chandef_rate_flags(chandef);
+	int divisor = ieee80211_chandef_get_divisor(chandef);
+	struct ieee80211_rate *br;
+	int rate, i, j, count = 0;
+
+	*rates = 0;
+
+	for (i = 0; i < srates_len; i++) {
+		rate = srates[i] & 0x7f;
+
+		for (j = 0; j < sband->n_bitrates; j++) {
+			br = &sband->bitrates[j];
+			if ((rate_flags & br->flags) != rate_flags)
+				continue;
+
+			if (DIV_ROUND_UP(br->bitrate, divisor * 5) == rate) {
+				*rates |= BIT(j);
+				count++;
+				break;
+			}
+		}
+	}
+	return count;
+}
+
 int ieee80211_add_srates_ie(struct ieee80211_sub_if_data *sdata,
 			    struct sk_buff *skb, bool need_basic,
 			    enum ieee80211_band band)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_supported_band *sband;
-	int rate;
+	int rate, divisor;
 	u8 i, rates, *pos;
 	u32 basic_rates = sdata->vif.bss_conf.basic_rates;
+	u32 rate_flags;
 
+	divisor = ieee80211_vif_get_divisor(&sdata->vif);
+	rate_flags = ieee80211_chandef_rate_flags(&sdata->vif.bss_conf.chandef);
 	sband = local->hw.wiphy->bands[band];
-	rates = sband->n_bitrates;
+	rates = 0;
+	for (i = 0; i < sband->n_bitrates; i++) {
+		if ((rate_flags & sband->bitrates[i].flags) != rate_flags)
+			continue;
+		rates++;
+	}
 	if (rates > 8)
 		rates = 8;
 
@@ -2040,10 +2109,15 @@ int ieee80211_add_srates_ie(struct ieee80211_sub_if_data *sdata,
 	*pos++ = rates;
 	for (i = 0; i < rates; i++) {
 		u8 basic = 0;
+		if ((rate_flags & sband->bitrates[i].flags) != rate_flags)
+			continue;
+
 		if (need_basic && basic_rates & BIT(i))
 			basic = 0x80;
 		rate = sband->bitrates[i].bitrate;
-		*pos++ = basic | (u8) (rate / 5);
+		rate = DIV_ROUND_UP(sband->bitrates[i].bitrate,
+				    5 * divisor);
+		*pos++ = basic | (u8) rate;
 	}
 
 	return 0;
@@ -2055,12 +2129,22 @@ int ieee80211_add_ext_srates_ie(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_supported_band *sband;
-	int rate;
+	int rate, skip, divisor;
 	u8 i, exrates, *pos;
 	u32 basic_rates = sdata->vif.bss_conf.basic_rates;
+	u32 rate_flags;
+
+	rate_flags = ieee80211_chandef_rate_flags(&sdata->vif.bss_conf.chandef);
+	divisor = ieee80211_vif_get_divisor(&sdata->vif);
 
 	sband = local->hw.wiphy->bands[band];
-	exrates = sband->n_bitrates;
+	exrates = 0;
+	for (i = 0; i < sband->n_bitrates; i++) {
+		if ((rate_flags & sband->bitrates[i].flags) != rate_flags)
+			continue;
+		exrates++;
+	}
+
 	if (exrates > 8)
 		exrates -= 8;
 	else
@@ -2073,12 +2157,19 @@ int ieee80211_add_ext_srates_ie(struct ieee80211_sub_if_data *sdata,
 		pos = skb_put(skb, exrates + 2);
 		*pos++ = WLAN_EID_EXT_SUPP_RATES;
 		*pos++ = exrates;
+		skip = 0;
 		for (i = 8; i < sband->n_bitrates; i++) {
 			u8 basic = 0;
+			if ((rate_flags & sband->bitrates[i].flags)
+			    != rate_flags)
+				continue;
+			if (skip++ < 8)
+				continue;
 			if (need_basic && basic_rates & BIT(i))
 				basic = 0x80;
-			rate = sband->bitrates[i].bitrate;
-			*pos++ = basic | (u8) (rate / 5);
+			rate = DIV_ROUND_UP(sband->bitrates[i].bitrate,
+					    5 * divisor);
+			*pos++ = basic | (u8) rate;
 		}
 	}
 	return 0;
@@ -2162,9 +2253,17 @@ u64 ieee80211_calculate_rx_timestamp(struct ieee80211_local *local,
 			ri.flags |= RATE_INFO_FLAGS_SHORT_GI;
 	} else {
 		struct ieee80211_supported_band *sband;
+		int divisor = 1;
+		int bitrate;
+
+		if (status->flag & RX_FLAG_10MHZ)
+			divisor = 2;
+		if (status->flag & RX_FLAG_5MHZ)
+			divisor = 4;
 
 		sband = local->hw.wiphy->bands[status->band];
-		ri.legacy = sband->bitrates[status->rate_idx].bitrate;
+		bitrate = sband->bitrates[status->rate_idx].bitrate;
+		ri.legacy = DIV_ROUND_UP(bitrate, divisor);
 	}
 
 	rate = cfg80211_calculate_bitrate(&ri);
-- 
1.7.10.4

