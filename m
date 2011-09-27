Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13110 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752766Ab1I0LOQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 07:14:16 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [RFC] mac80211: remove per band sta supported rates
Date: Tue, 27 Sep 2011 13:12:50 +0200
Message-Id: <1317121970-3638-1-git-send-email-sgruszka@redhat.com> (sfid-20110927_131424_873707_53011148)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is not possible to connect to remote station on two bands
at once, or I'm wrong?

As side effect this patch fix warning in
rate_control_send_low (or rather mask the real problem):

https://bugzilla.redhat.com/show_bug.cgi?id=731365

Which may happen when we are just after disassociation and changed
channel/band, but still want send some frames (namely delBA) to old
sta. Right fix should prevent to change channel before we fully
dissassocate, or prevent to send frames after connection is lost,
or both, but I don't know how to correctly do this so far.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    2 +-
 drivers/net/wireless/ath/ath9k/rc.c           |    2 +-
 drivers/net/wireless/iwlegacy/iwl-3945-rs.c   |    6 +++---
 drivers/net/wireless/iwlegacy/iwl-4965-rs.c   |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c     |    6 +++---
 drivers/net/wireless/mwl8k.c                  |   13 ++++++-------
 drivers/net/wireless/rtlwifi/core.c           |    8 ++++----
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c   |    8 ++++----
 drivers/net/wireless/rtlwifi/rtl8192de/hw.c   |    8 ++++----
 drivers/net/wireless/rtlwifi/rtl8192se/hw.c   |    8 ++++----
 drivers/net/wireless/wl12xx/cmd.c             |    2 +-
 drivers/net/wireless/wl12xx/main.c            |    2 +-
 include/net/mac80211.h                        |    9 ++++-----
 net/mac80211/cfg.c                            |    2 +-
 net/mac80211/ibss.c                           |    8 ++++----
 net/mac80211/mesh_plink.c                     |    4 ++--
 net/mac80211/mlme.c                           |    2 +-
 net/mac80211/rate.c                           |    2 +-
 net/mac80211/rc80211_minstrel.c               |    2 +-
 net/mac80211/rc80211_pid_algo.c               |    9 ++++-----
 20 files changed, 53 insertions(+), 56 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 495fdf6..bc0af82 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -602,7 +602,7 @@ static void ath9k_htc_setup_rate(struct ath9k_htc_priv *priv,
 	sband = priv->hw->wiphy->bands[priv->hw->conf.channel->band];
 
 	for (i = 0, j = 0; i < sband->n_bitrates; i++) {
-		if (sta->supp_rates[sband->band] & BIT(i)) {
+		if (sta->supp_rates & BIT(i)) {
 			trate->rates.legacy_rates.rs_rates[j]
 				= (sband->bitrates[i].bitrate * 2) / 10;
 			j++;
diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 4f13018..6d264d5 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -1406,7 +1406,7 @@ static void ath_rate_init(void *priv, struct ieee80211_supported_band *sband,
 	int i, j = 0;
 
 	for (i = 0; i < sband->n_bitrates; i++) {
-		if (sta->supp_rates[sband->band] & BIT(i)) {
+		if (sta->supp_rates & BIT(i)) {
 			ath_rc_priv->neg_rates.rs_rates[j]
 				= (sband->bitrates[i].bitrate * 2) / 10;
 			j++;
diff --git a/drivers/net/wireless/iwlegacy/iwl-3945-rs.c b/drivers/net/wireless/iwlegacy/iwl-3945-rs.c
index 8faeaf2..0d65706 100644
--- a/drivers/net/wireless/iwlegacy/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlegacy/iwl-3945-rs.c
@@ -373,13 +373,13 @@ void iwl3945_rs_rate_init(struct iwl_priv *priv, struct ieee80211_sta *sta, u8 s
 	 * after assoc.. */
 
 	for (i = sband->n_bitrates - 1; i >= 0; i--) {
-		if (sta->supp_rates[sband->band] & (1 << i)) {
+		if (sta->supp_rates & (1 << i)) {
 			rs_sta->last_txrate_idx = i;
 			break;
 		}
 	}
 
-	priv->_3945.sta_supp_rates = sta->supp_rates[sband->band];
+	priv->_3945.sta_supp_rates = sta->supp_rates;
 	/* For 5 GHz band it start at IWL_FIRST_OFDM_RATE */
 	if (sband->band == IEEE80211_BAND_5GHZ) {
 		rs_sta->last_txrate_idx += IWL_FIRST_OFDM_RATE;
@@ -659,7 +659,7 @@ static void iwl3945_rs_get_rate(void *priv_r, struct ieee80211_sta *sta,
 	if (rate_control_send_low(sta, priv_sta, txrc))
 		return;
 
-	rate_mask = sta->supp_rates[sband->band];
+	rate_mask = sta->supp_rates;
 
 	/* get user max rate if set */
 	max_rate_idx = txrc->max_rate_idx;
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-rs.c b/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
index 57ebe21..d4731fc 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
@@ -989,7 +989,7 @@ iwl4965_rs_tx_status(void *priv_r, struct ieee80211_supported_band *sband,
 	lq_sta->last_rate_n_flags = tx_rate;
 done:
 	/* See if there's a better rate or modulation mode to try. */
-	if (sta && sta->supp_rates[sband->band])
+	if (sta && sta->supp_rates)
 		iwl4965_rs_rate_scale_perform(priv, skb, sta, lq_sta);
 }
 
@@ -1794,7 +1794,7 @@ static void iwl4965_rs_rate_scale_perform(struct iwl_priv *priv,
 	if (!sta || !lq_sta)
 		return;
 
-	lq_sta->supp_rates = sta->supp_rates[lq_sta->band];
+	lq_sta->supp_rates = sta->supp_rates;
 
 	tid = iwl4965_rs_tl_add_packet(lq_sta, hdr);
 	if ((tid != MAX_TID_COUNT) && (lq_sta->tx_agg_tid_en & (1 << tid))) {
@@ -2359,7 +2359,7 @@ iwl4965_rs_rate_init(struct iwl_priv *priv,
 					&lq_sta->lq_info[j].win[i]);
 
 	lq_sta->flush_timer = 0;
-	lq_sta->supp_rates = sta->supp_rates[sband->band];
+	lq_sta->supp_rates = sta->supp_rates;
 	for (j = 0; j < LQ_SIZE; j++)
 		for (i = 0; i < IWL_RATE_COUNT; i++)
 			iwl4965_rs_rate_scale_clear_window(
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index c14f8d6..c2cb9f6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -1079,7 +1079,7 @@ static void rs_tx_status(void *priv_r, struct ieee80211_supported_band *sband,
 	lq_sta->last_rate_n_flags = tx_rate;
 done:
 	/* See if there's a better rate or modulation mode to try. */
-	if (sta && sta->supp_rates[sband->band])
+	if (sta && sta->supp_rates)
 		rs_rate_scale_perform(priv, skb, sta, lq_sta);
 
 #if defined(CONFIG_MAC80211_DEBUGFS) && defined(CONFIG_IWLWIFI_DEVICE_SVTOOL)
@@ -2276,7 +2276,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 	if (!sta || !lq_sta)
 		return;
 
-	lq_sta->supp_rates = sta->supp_rates[lq_sta->band];
+	lq_sta->supp_rates = sta->supp_rates;
 
 	tid = rs_tl_add_packet(lq_sta, hdr);
 	if ((tid != IWL_MAX_TID_COUNT) &&
@@ -2848,7 +2848,7 @@ void iwl_rs_rate_init(struct iwl_priv *priv, struct ieee80211_sta *sta, u8 sta_i
 			rs_rate_scale_clear_window(&lq_sta->lq_info[j].win[i]);
 
 	lq_sta->flush_timer = 0;
-	lq_sta->supp_rates = sta->supp_rates[sband->band];
+	lq_sta->supp_rates = sta->supp_rates;
 	for (j = 0; j < LQ_SIZE; j++)
 		for (i = 0; i < IWL_RATE_COUNT; i++)
 			rs_rate_scale_clear_window(&lq_sta->lq_info[j].win[i]);
diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index ea1395a..f6a82bd 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -3776,9 +3776,9 @@ static int mwl8k_cmd_set_new_stn_add(struct ieee80211_hw *hw,
 	cmd->stn_id = cpu_to_le16(sta->aid);
 	cmd->action = cpu_to_le16(MWL8K_STA_ACTION_ADD);
 	if (hw->conf.channel->band == IEEE80211_BAND_2GHZ)
-		rates = sta->supp_rates[IEEE80211_BAND_2GHZ];
+		rates = sta->supp_rates;
 	else
-		rates = sta->supp_rates[IEEE80211_BAND_5GHZ] << 5;
+		rates = sta->supp_rates << 5;
 	cmd->legacy_rates = cpu_to_le32(rates);
 	if (sta->ht_cap.ht_supported) {
 		cmd->ht_rates[0] = sta->ht_cap.mcs.rx_mask[0];
@@ -4187,9 +4187,9 @@ static int mwl8k_cmd_update_stadb_add(struct ieee80211_hw *hw,
 	p->extended_ht_caps = (sta->ht_cap.ampdu_factor & 3) |
 		((sta->ht_cap.ampdu_density & 7) << 2);
 	if (hw->conf.channel->band == IEEE80211_BAND_2GHZ)
-		rates = sta->supp_rates[IEEE80211_BAND_2GHZ];
+		rates = sta->supp_rates;
 	else
-		rates = sta->supp_rates[IEEE80211_BAND_5GHZ] << 5;
+		rates = sta->supp_rates << 5;
 	legacy_rate_mask_to_array(p->legacy_rates, rates);
 	memcpy(p->ht_rates, sta->ht_cap.mcs.rx_mask, 16);
 	p->interop = 1;
@@ -4601,10 +4601,9 @@ mwl8k_bss_info_changed_sta(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		}
 
 		if (hw->conf.channel->band == IEEE80211_BAND_2GHZ) {
-			ap_legacy_rates = ap->supp_rates[IEEE80211_BAND_2GHZ];
+			ap_legacy_rates = ap->supp_rates;
 		} else {
-			ap_legacy_rates =
-				ap->supp_rates[IEEE80211_BAND_5GHZ] << 5;
+			ap_legacy_rates = ap->supp_rates << 5;
 		}
 		memcpy(ap_mcs_rates, ap->ht_cap.mcs.rx_mask, 16);
 
diff --git a/drivers/net/wireless/rtlwifi/core.c b/drivers/net/wireless/rtlwifi/core.c
index 04c4e9e..67d0df2 100644
--- a/drivers/net/wireless/rtlwifi/core.c
+++ b/drivers/net/wireless/rtlwifi/core.c
@@ -441,7 +441,7 @@ static int rtl_op_sta_add(struct ieee80211_hw *hw,
 		sta_entry = (struct rtl_sta_info *) sta->drv_priv;
 		if (rtlhal->current_bandtype == BAND_ON_2_4G) {
 			sta_entry->wireless_mode = WIRELESS_MODE_G;
-			if (sta->supp_rates[0] <= 0xf)
+			if (sta->supp_rates <= 0xf)
 				sta_entry->wireless_mode = WIRELESS_MODE_B;
 			if (sta->ht_cap.ht_supported)
 				sta_entry->wireless_mode = WIRELESS_MODE_N_24G;
@@ -699,7 +699,7 @@ static void rtl_op_bss_info_changed(struct ieee80211_hw *hw,
 		if (rtlhal->current_bandtype == BAND_ON_5G) {
 			mac->mode = WIRELESS_MODE_A;
 		} else {
-			if (sta->supp_rates[0] <= 0xf)
+			if (sta->supp_rates <= 0xf)
 				mac->mode = WIRELESS_MODE_B;
 			else
 				mac->mode = WIRELESS_MODE_G;
@@ -735,9 +735,9 @@ static void rtl_op_bss_info_changed(struct ieee80211_hw *hw,
 			/* for 5G must << RATE_6M_INDEX=4,
 			 * because 5G have no cck rate*/
 			if (rtlhal->current_bandtype == BAND_ON_5G)
-				basic_rates = sta->supp_rates[1] << 4;
+				basic_rates = sta->supp_rates << 4;
 			else
-				basic_rates = sta->supp_rates[0];
+				basic_rates = sta->supp_rates;
 
 			mac->basic_rates = basic_rates;
 			rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_BASIC_RATE,
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
index a3deaef..49fbea6 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
@@ -1721,9 +1721,9 @@ static void rtl92ce_update_hal_rate_table(struct ieee80211_hw *hw,
 	enum wireless_mode wirelessmode = mac->mode;
 
 	if (rtlhal->current_bandtype == BAND_ON_5G)
-		ratr_value = sta->supp_rates[1] << 4;
+		ratr_value = sta->supp_rates << 4;
 	else
-		ratr_value = sta->supp_rates[0];
+		ratr_value = sta->supp_rates;
 	ratr_value |= (sta->ht_cap.mcs.rx_mask[1] << 20 |
 			sta->ht_cap.mcs.rx_mask[0] << 12);
 	switch (wirelessmode) {
@@ -1825,9 +1825,9 @@ static void rtl92ce_update_hal_rate_mask(struct ieee80211_hw *hw,
 		macid = sta->aid + 1;
 
 	if (rtlhal->current_bandtype == BAND_ON_5G)
-		ratr_bitmap = sta->supp_rates[1] << 4;
+		ratr_bitmap = sta->supp_rates << 4;
 	else
-		ratr_bitmap = sta->supp_rates[0];
+		ratr_bitmap = sta->supp_rates;
 	ratr_bitmap |= (sta->ht_cap.mcs.rx_mask[1] << 20 |
 			sta->ht_cap.mcs.rx_mask[0] << 12);
 	switch (wirelessmode) {
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/hw.c b/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
index 0073cf1..755af01 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
@@ -1902,9 +1902,9 @@ static void rtl92de_update_hal_rate_table(struct ieee80211_hw *hw,
 	enum wireless_mode wirelessmode = mac->mode;
 
 	if (rtlhal->current_bandtype == BAND_ON_5G)
-		ratr_value = sta->supp_rates[1] << 4;
+		ratr_value = sta->supp_rates << 4;
 	else
-		ratr_value = sta->supp_rates[0];
+		ratr_value = sta->supp_rates;
 	ratr_value |= (sta->ht_cap.mcs.rx_mask[1] << 20 |
 		       sta->ht_cap.mcs.rx_mask[0] << 12);
 	switch (wirelessmode) {
@@ -1995,9 +1995,9 @@ static void rtl92de_update_hal_rate_mask(struct ieee80211_hw *hw,
 		macid = sta->aid + 1;
 
 	if (rtlhal->current_bandtype == BAND_ON_5G)
-		ratr_bitmap = sta->supp_rates[1] << 4;
+		ratr_bitmap = sta->supp_rates << 4;
 	else
-		ratr_bitmap = sta->supp_rates[0];
+		ratr_bitmap = sta->supp_rates;
 	ratr_bitmap |= (sta->ht_cap.mcs.rx_mask[1] << 20 |
 			sta->ht_cap.mcs.rx_mask[0] << 12);
 	switch (wirelessmode) {
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/hw.c b/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
index d59f66c..a48df97 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
@@ -1997,9 +1997,9 @@ static void rtl92se_update_hal_rate_table(struct ieee80211_hw *hw,
 	enum wireless_mode wirelessmode = mac->mode;
 
 	if (rtlhal->current_bandtype == BAND_ON_5G)
-		ratr_value = sta->supp_rates[1] << 4;
+		ratr_value = sta->supp_rates << 4;
 	else
-		ratr_value = sta->supp_rates[0];
+		ratr_value = sta->supp_rates;
 	ratr_value |= (sta->ht_cap.mcs.rx_mask[1] << 20 |
 			sta->ht_cap.mcs.rx_mask[0] << 12);
 	switch (wirelessmode) {
@@ -2111,9 +2111,9 @@ static void rtl92se_update_hal_rate_mask(struct ieee80211_hw *hw,
 		macid = sta->aid + 1;
 
 	if (rtlhal->current_bandtype == BAND_ON_5G)
-		ratr_bitmap = sta->supp_rates[1] << 4;
+		ratr_bitmap = sta->supp_rates << 4;
 	else
-		ratr_bitmap = sta->supp_rates[0];
+		ratr_bitmap = sta->supp_rates;
 	ratr_bitmap |= (sta->ht_cap.mcs.rx_mask[1] << 20 |
 			sta->ht_cap.mcs.rx_mask[0] << 12);
 	switch (wirelessmode) {
diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index 084262f..7dc4c04 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -1437,7 +1437,7 @@ int wl12xx_cmd_add_peer(struct wl1271 *wl, struct ieee80211_sta *sta, u8 hlid)
 		else
 			cmd->psd_type[i] = WL1271_PSD_LEGACY;
 
-	sta_rates = sta->supp_rates[wl->band];
+	sta_rates = sta->supp_rates;
 	if (sta->ht_cap.ht_supported)
 		sta_rates |= sta->ht_cap.mcs.rx_mask[0] << HW_HT_RATES_OFFSET;
 
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 680f558..69c5c41 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -3340,7 +3340,7 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 			goto sta_not_found;
 
 		/* save the supp_rates of the ap */
-		sta_rate_set = sta->supp_rates[wl->hw->conf.channel->band];
+		sta_rate_set = sta->supp_rates;
 		if (sta->ht_cap.ht_supported)
 			sta_rate_set |=
 			    (sta->ht_cap.mcs.rx_mask[0] << HW_HT_RATES_OFFSET);
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index c0f63fd..76bc230 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -960,7 +960,7 @@ enum set_key_cmd {
  * @max_sp: max Service Period. Only valid if wme is supported.
  */
 struct ieee80211_sta {
-	u32 supp_rates[IEEE80211_NUM_BANDS];
+	u32 supp_rates;
 	u8 addr[ETH_ALEN];
 	u16 aid;
 	struct ieee80211_sta_ht_cap ht_cap;
@@ -3322,10 +3322,9 @@ struct rate_control_ops {
 };
 
 static inline int rate_supported(struct ieee80211_sta *sta,
-				 enum ieee80211_band band,
 				 int index)
 {
-	return (sta == NULL || sta->supp_rates[band] & BIT(index));
+	return (sta == NULL || sta->supp_rates & BIT(index));
 }
 
 /**
@@ -3358,7 +3357,7 @@ rate_lowest_index(struct ieee80211_supported_band *sband,
 	int i;
 
 	for (i = 0; i < sband->n_bitrates; i++)
-		if (rate_supported(sta, sband->band, i))
+		if (rate_supported(sta, i))
 			return i;
 
 	/* warn when we cannot find a rate. */
@@ -3374,7 +3373,7 @@ bool rate_usable_index_exists(struct ieee80211_supported_band *sband,
 	unsigned int i;
 
 	for (i = 0; i < sband->n_bitrates; i++)
-		if (rate_supported(sta, sband->band, i))
+		if (rate_supported(sta, i))
 			return true;
 	return false;
 }
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index b57ddf9..0c4649d 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -744,7 +744,7 @@ static void sta_apply_parameters(struct ieee80211_local *local,
 					rates |= BIT(j);
 			}
 		}
-		sta->sta.supp_rates[local->oper_channel->band] = rates;
+		sta->sta.supp_rates = rates;
 	}
 
 	if (params->ht_capa)
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 836b275..d787092 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -290,12 +290,12 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 			if (sta) {
 				u32 prev_rates;
 
-				prev_rates = sta->sta.supp_rates[band];
+				prev_rates = sta->sta.supp_rates;
 				/* make sure mandatory rates are always added */
-				sta->sta.supp_rates[band] = supp_rates |
+				sta->sta.supp_rates = supp_rates |
 					ieee80211_mandatory_rates(local, band);
 
-				if (sta->sta.supp_rates[band] != prev_rates) {
+				if (sta->sta.supp_rates != prev_rates) {
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
 					printk(KERN_DEBUG
 						"%s: updated supp_rates set "
@@ -455,7 +455,7 @@ struct sta_info *ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
 	set_sta_flags(sta, WLAN_STA_AUTHORIZED);
 
 	/* make sure mandatory rates are always added */
-	sta->sta.supp_rates[band] = supp_rates |
+	sta->sta.supp_rates = supp_rates |
 			ieee80211_mandatory_rates(local, band);
 
 	rate_control_rate_init(sta);
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 1213a23..8b1ceab 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -93,7 +93,7 @@ static struct sta_info *mesh_plink_alloc(struct ieee80211_sub_if_data *sdata,
 		return NULL;
 
 	sta->flags = WLAN_STA_AUTHORIZED | WLAN_STA_AUTH | WLAN_STA_WME;
-	sta->sta.supp_rates[local->hw.conf.channel->band] = rates;
+	sta->sta.supp_rates = rates;
 	rate_control_rate_init(sta);
 
 	return sta;
@@ -269,7 +269,7 @@ void mesh_neighbour_update(u8 *hw_addr, u32 rates,
 	}
 
 	sta->last_rx = jiffies;
-	sta->sta.supp_rates[local->hw.conf.channel->band] = rates;
+	sta->sta.supp_rates = rates;
 	if (mesh_peer_accepts_plinks(elems) &&
 			sta->plink_state == NL80211_PLINK_LISTEN &&
 			sdata->u.mesh.accepting_plinks &&
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 1a59fb6..58e961e 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1555,7 +1555,7 @@ static bool ieee80211_assoc_success(struct ieee80211_work *wk,
 		}
 	}
 
-	sta->sta.supp_rates[wk->chan->band] = rates;
+	sta->sta.supp_rates = rates;
 	sdata->vif.bss_conf.basic_rates = basic_rates;
 
 	/* cf. IEEE 802.11 9.2.12 */
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 3d5a2cb..aa38625 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -331,7 +331,7 @@ void rate_control_get_rate(struct ieee80211_sub_if_data *sdata,
 	if (mask != (1 << txrc->sband->n_bitrates) - 1) {
 		if (sta) {
 			/* Filter out rates that the STA does not support */
-			mask &= sta->sta.supp_rates[info->band];
+			mask &= sta->sta.supp_rates;
 		}
 		/*
 		 * Make sure the rate index selected for each TX rate is
diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index 58a8955..4565a3c 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -395,7 +395,7 @@ minstrel_rate_init(void *priv, struct ieee80211_supported_band *sband,
 		unsigned int tx_time_single;
 		unsigned int cw = mp->cw_min;
 
-		if (!rate_supported(sta, sband->band, i))
+		if (!rate_supported(sta, i))
 			continue;
 		n++;
 		memset(mr, 0, sizeof(*mr));
diff --git a/net/mac80211/rc80211_pid_algo.c b/net/mac80211/rc80211_pid_algo.c
index aeda654..bb235b5 100644
--- a/net/mac80211/rc80211_pid_algo.c
+++ b/net/mac80211/rc80211_pid_algo.c
@@ -74,10 +74,9 @@ static void rate_control_pid_adjust_rate(struct ieee80211_supported_band *sband,
 					 struct rc_pid_sta_info *spinfo, int adj,
 					 struct rc_pid_rateinfo *rinfo)
 {
-	int cur_sorted, new_sorted, probe, tmp, n_bitrates, band;
+	int cur_sorted, new_sorted, probe, tmp, n_bitrates;
 	int cur = spinfo->txrate_idx;
 
-	band = sband->band;
 	n_bitrates = sband->n_bitrates;
 
 	/* Map passed arguments to sorted values. */
@@ -96,19 +95,19 @@ static void rate_control_pid_adjust_rate(struct ieee80211_supported_band *sband,
 		/* Ensure that the rate decrease isn't disadvantageous. */
 		for (probe = cur_sorted; probe >= new_sorted; probe--)
 			if (rinfo[probe].diff <= rinfo[cur_sorted].diff &&
-			    rate_supported(sta, band, rinfo[probe].index))
+			    rate_supported(sta, rinfo[probe].index))
 				tmp = probe;
 	} else {
 		/* Look for rate increase with zero (or below) cost. */
 		for (probe = new_sorted + 1; probe < n_bitrates; probe++)
 			if (rinfo[probe].diff <= rinfo[new_sorted].diff &&
-			    rate_supported(sta, band, rinfo[probe].index))
+			    rate_supported(sta, rinfo[probe].index))
 				tmp = probe;
 	}
 
 	/* Fit the rate found to the nearest supported rate. */
 	do {
-		if (rate_supported(sta, band, rinfo[tmp].index)) {
+		if (rate_supported(sta, rinfo[tmp].index)) {
 			spinfo->txrate_idx = rinfo[tmp].index;
 			break;
 		}
-- 
1.7.1

