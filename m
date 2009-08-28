Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:5799 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959AbZH1Qos (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2009 12:44:48 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Daniel C Halperin <daniel.c.halperin@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/5] iwlwifi: remove 60 Mbps from sband bitrates table
Date: Fri, 28 Aug 2009 09:44:45 -0700
Message-Id: <1251477889-13732-2-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1251477889-13732-1-git-send-email-reinette.chatre@intel.com>
References: <1251477889-13732-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel C Halperin <daniel.c.halperin@intel.com>

ieee80211_supported_band is supposed to only contain legacy rates in the
bitrates table (HT rates go in the ieee80211_sta_ht_cap substruct).  Make
iwlwifi driver obey this restriction by removing the 60 Mbps rate. Also, clean
up a few pieces of other code that formerly relied on 60 Mbps being in
sband->bitrates.

Signed-off-by: Daniel C Halperin <daniel.c.halperin@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |   48 ++++++++++++-----------------
 drivers/net/wireless/iwlwifi/iwl-agn-rs.h |    1 +
 drivers/net/wireless/iwlwifi/iwl-core.c   |   12 +++---
 3 files changed, 27 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 26ec969..8239e55 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -818,15 +818,15 @@ static void rs_tx_status(void *priv_r, struct ieee80211_supported_band *sband,
 {
 	int status;
 	u8 retries;
-	int rs_index, index = 0;
+	int rs_index, mac_index, index = 0;
 	struct iwl_lq_sta *lq_sta = priv_sta;
 	struct iwl_link_quality_cmd *table;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct iwl_priv *priv = (struct iwl_priv *)priv_r;
-	struct ieee80211_hw *hw = priv->hw;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct iwl_rate_scale_data *window = NULL;
 	struct iwl_rate_scale_data *search_win = NULL;
+	enum mac80211_rate_control_flags mac_flags;
 	u32 tx_rate;
 	struct iwl_scale_tbl_info tbl_type;
 	struct iwl_scale_tbl_info *curr_tbl, *search_tbl;
@@ -876,16 +876,17 @@ static void rs_tx_status(void *priv_r, struct ieee80211_supported_band *sband,
 	rs_get_tbl_info_from_mcs(tx_rate, priv->band, &tbl_type, &rs_index);
 	if (priv->band == IEEE80211_BAND_5GHZ)
 		rs_index -= IWL_FIRST_OFDM_RATE;
+	mac_flags = info->status.rates[0].flags;
+	mac_index = info->status.rates[0].idx;
 
-	if ((info->status.rates[0].idx < 0) ||
-	    (tbl_type.is_SGI != !!(info->status.rates[0].flags & IEEE80211_TX_RC_SHORT_GI)) ||
-	    (tbl_type.is_ht40 != !!(info->status.rates[0].flags & IEEE80211_TX_RC_40_MHZ_WIDTH)) ||
-	    (tbl_type.is_dup != !!(info->status.rates[0].flags & IEEE80211_TX_RC_DUP_DATA)) ||
+	if ((mac_index < 0) ||
+	    (tbl_type.is_SGI != !!(mac_flags & IEEE80211_TX_RC_SHORT_GI)) ||
+	    (tbl_type.is_ht40 != !!(mac_flags & IEEE80211_TX_RC_40_MHZ_WIDTH)) ||
+	    (tbl_type.is_dup != !!(mac_flags & IEEE80211_TX_RC_DUP_DATA)) ||
 	    (tbl_type.ant_type != info->antenna_sel_tx) ||
-	    (!!(tx_rate & RATE_MCS_HT_MSK) != !!(info->status.rates[0].flags & IEEE80211_TX_RC_MCS)) ||
-	    (!!(tx_rate & RATE_MCS_GF_MSK) != !!(info->status.rates[0].flags & IEEE80211_TX_RC_GREEN_FIELD)) ||
-	    (hw->wiphy->bands[priv->band]->bitrates[rs_index].bitrate !=
-	     hw->wiphy->bands[info->band]->bitrates[info->status.rates[0].idx].bitrate)) {
+	    (!!(tx_rate & RATE_MCS_HT_MSK) != !!(mac_flags & IEEE80211_TX_RC_MCS)) ||
+	    (!!(tx_rate & RATE_MCS_GF_MSK) != !!(mac_flags & IEEE80211_TX_RC_GREEN_FIELD)) ||
+	    rs_index != mac_index) {
 		IWL_DEBUG_RATE(priv, "initial rate does not match 0x%x\n", tx_rate);
 		/* the last LQ command could failed so the LQ in ucode not
 		 * the same in driver sync up
@@ -2542,8 +2543,12 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta, void *priv_sta,
 		if (lq_sta->last_rate_n_flags & RATE_MCS_GF_MSK)
 			info->control.rates[0].flags |= IEEE80211_TX_RC_GREEN_FIELD;
 	} else {
-		if (rate_idx < 0 || rate_idx > IWL_RATE_COUNT)
+		/* Check for invalid rates */
+		if ((rate_idx < 0) || (rate_idx >= IWL_RATE_COUNT_LEGACY) ||
+				((sband->band == IEEE80211_BAND_5GHZ) &&
+				 (rate_idx < IWL_FIRST_OFDM_RATE)))
 			rate_idx = rate_lowest_index(sband, sta);
+		/* On valid 5 GHz rate, adjust index */
 		else if (sband->band == IEEE80211_BAND_5GHZ)
 			rate_idx -= IWL_FIRST_OFDM_RATE;
 		info->control.rates[0].flags = 0;
@@ -2584,9 +2589,6 @@ static void rs_rate_init(void *priv_r, struct ieee80211_supported_band *sband,
 	struct ieee80211_conf *conf = &priv->hw->conf;
 	struct ieee80211_sta_ht_cap *ht_cap = &sta->ht_cap;
 	struct iwl_lq_sta *lq_sta = priv_sta;
-	u16 mask_bit = 0;
-	int count;
-	int start_rate = 0;
 
 	lq_sta->flush_timer = 0;
 	lq_sta->supp_rates = sta->supp_rates[sband->band];
@@ -2661,20 +2663,10 @@ static void rs_rate_init(void *priv_r, struct ieee80211_supported_band *sband,
 	lq_sta->tx_agg_tid_en = IWL_AGG_ALL_TID;
 	lq_sta->drv = priv;
 
-	/* Find highest tx rate supported by hardware and destination station */
-	mask_bit = sta->supp_rates[sband->band];
-	count = sband->n_bitrates;
-	if (sband->band == IEEE80211_BAND_5GHZ) {
-		count += IWL_FIRST_OFDM_RATE;
-		start_rate = IWL_FIRST_OFDM_RATE;
-		mask_bit <<= IWL_FIRST_OFDM_RATE;
-	}
-
-	mask_bit = mask_bit & lq_sta->active_legacy_rate;
-	lq_sta->last_txrate_idx = 4;
-	for (i = start_rate; i < count; i++)
-		if (mask_bit & BIT(i))
-			lq_sta->last_txrate_idx = i;
+	/* Set last_txrate_idx to lowest rate */
+	lq_sta->last_txrate_idx = rate_lowest_index(sband, sta);
+	if (sband->band == IEEE80211_BAND_5GHZ)
+		lq_sta->last_txrate_idx += IWL_FIRST_OFDM_RATE;
 
 	rs_initialize_lq(priv, conf, sta, lq_sta);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
index 25050bf..9fac530 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
@@ -73,6 +73,7 @@ enum {
 	IWL_RATE_54M_INDEX,
 	IWL_RATE_60M_INDEX,
 	IWL_RATE_COUNT, /*FIXME:RS:change to IWL_RATE_INDEX_COUNT,*/
+	IWL_RATE_COUNT_LEGACY = IWL_RATE_COUNT - 1,	/* Excluding 60M */
 	IWL_RATE_COUNT_3945 = IWL_RATE_COUNT - 1,
 	IWL_RATE_INVM_INDEX = IWL_RATE_COUNT,
 	IWL_RATE_INVALID = IWL_RATE_COUNT,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index c62c081..ad32a11 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -439,12 +439,12 @@ static void iwlcore_init_hw_rates(struct iwl_priv *priv,
 {
 	int i;
 
-	for (i = 0; i < IWL_RATE_COUNT; i++) {
+	for (i = 0; i < IWL_RATE_COUNT_LEGACY; i++) {
 		rates[i].bitrate = iwl_rates[i].ieee * 5;
 		rates[i].hw_value = i; /* Rate scaling will work on indexes */
 		rates[i].hw_value_short = i;
 		rates[i].flags = 0;
-		if ((i > IWL_LAST_OFDM_RATE) || (i < IWL_FIRST_OFDM_RATE)) {
+		if ((i >= IWL_FIRST_CCK_RATE) && (i <= IWL_LAST_CCK_RATE)) {
 			/*
 			 * If CCK != 1M then set short preamble rate flag.
 			 */
@@ -480,7 +480,7 @@ int iwlcore_init_geos(struct iwl_priv *priv)
 	if (!channels)
 		return -ENOMEM;
 
-	rates = kzalloc((sizeof(struct ieee80211_rate) * (IWL_RATE_COUNT + 1)),
+	rates = kzalloc((sizeof(struct ieee80211_rate) * IWL_RATE_COUNT_LEGACY),
 			GFP_KERNEL);
 	if (!rates) {
 		kfree(channels);
@@ -492,7 +492,7 @@ int iwlcore_init_geos(struct iwl_priv *priv)
 	sband->channels = &channels[ARRAY_SIZE(iwl_eeprom_band_1)];
 	/* just OFDM */
 	sband->bitrates = &rates[IWL_FIRST_OFDM_RATE];
-	sband->n_bitrates = IWL_RATE_COUNT - IWL_FIRST_OFDM_RATE;
+	sband->n_bitrates = IWL_RATE_COUNT_LEGACY - IWL_FIRST_OFDM_RATE;
 
 	if (priv->cfg->sku & IWL_SKU_N)
 		iwlcore_init_ht_hw_capab(priv, &sband->ht_cap,
@@ -502,7 +502,7 @@ int iwlcore_init_geos(struct iwl_priv *priv)
 	sband->channels = channels;
 	/* OFDM & CCK */
 	sband->bitrates = rates;
-	sband->n_bitrates = IWL_RATE_COUNT;
+	sband->n_bitrates = IWL_RATE_COUNT_LEGACY;
 
 	if (priv->cfg->sku & IWL_SKU_N)
 		iwlcore_init_ht_hw_capab(priv, &sband->ht_cap,
@@ -1231,7 +1231,7 @@ static void iwl_set_rate(struct iwl_priv *priv)
 
 	for (i = 0; i < hw->n_bitrates; i++) {
 		rate = &(hw->bitrates[i]);
-		if (rate->hw_value < IWL_RATE_COUNT)
+		if (rate->hw_value < IWL_RATE_COUNT_LEGACY)
 			priv->active_rate |= (1 << rate->hw_value);
 	}
 
-- 
1.5.6.3

