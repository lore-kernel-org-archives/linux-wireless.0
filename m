Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:61613 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932710AbaJ2Lvj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 07:51:39 -0400
Received: by mail-wi0-f181.google.com with SMTP id n3so4319319wiv.14
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 04:51:38 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 24/25] iwlwifi: mvm: rs: add Tx STBC support
Date: Wed, 29 Oct 2014 13:50:45 +0200
Message-Id: <1414583446-11032-24-git-send-email-egrumbach@gmail.com> (sfid-20141029_131321_688637_A4A25433)
In-Reply-To: <CANUX_P0TURG9GNMRUOTGFfh=qzSNKkDh9Gm7Asq5jXr=0gQgLg@mail.gmail.com>
References: <CANUX_P0TURG9GNMRUOTGFfh=qzSNKkDh9Gm7Asq5jXr=0gQgLg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

STBC is enabled on HT/VHT SISO rates in case we don't care
about power consumption and it won't hurt BT.
This is done only in case the peer and our chip support STBC
of course.
While at it fixed a bug which was causing bw and ldpc
flags to be set incorrectly in the rate scale table in case
we are switching to a legacy Tx column. This had no real impact.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 75 ++++++++++++++++++++++++++++++-----
 drivers/net/wireless/iwlwifi/mvm/rs.h |  2 +
 2 files changed, 68 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 66e971a..ce88484 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -505,10 +505,11 @@ static const char *rs_pretty_lq_type(enum iwl_table_type type)
 static inline void rs_dump_rate(struct iwl_mvm *mvm, const struct rs_rate *rate,
 				const char *prefix)
 {
-	IWL_DEBUG_RATE(mvm, "%s: (%s: %d) ANT: %s BW: %d SGI: %d LDPC: %d\n",
+	IWL_DEBUG_RATE(mvm,
+		       "%s: (%s: %d) ANT: %s BW: %d SGI: %d LDPC: %d STBC %d\n",
 		       prefix, rs_pretty_lq_type(rate->type),
 		       rate->index, rs_pretty_ant(rate->ant),
-		       rate->bw, rate->sgi, rate->ldpc);
+		       rate->bw, rate->sgi, rate->ldpc, rate->stbc);
 }
 
 static void rs_rate_scale_clear_window(struct iwl_rate_scale_data *window)
@@ -741,6 +742,12 @@ static u32 ucode_rate_from_rs_rate(struct iwl_mvm *mvm,
 		IWL_ERR(mvm, "Invalid rate->type %d\n", rate->type);
 	}
 
+	if (is_siso(rate) && rate->stbc) {
+		/* To enable STBC we need to set both a flag and ANT_AB */
+		ucode_rate |= RATE_MCS_ANT_AB_MSK;
+		ucode_rate |= RATE_MCS_VHT_STBC_MSK;
+	}
+
 	ucode_rate |= rate->bw;
 	if (rate->sgi)
 		ucode_rate |= RATE_MCS_SGI_MSK;
@@ -785,6 +792,8 @@ static int rs_rate_from_ucode_rate(const u32 ucode_rate,
 		rate->sgi = true;
 	if (ucode_rate & RATE_MCS_LDPC_MSK)
 		rate->ldpc = true;
+	if (ucode_rate & RATE_MCS_VHT_STBC_MSK)
+		rate->stbc = true;
 
 	rate->bw = ucode_rate & RATE_MCS_CHAN_WIDTH_MSK;
 
@@ -794,7 +803,7 @@ static int rs_rate_from_ucode_rate(const u32 ucode_rate,
 
 		if (nss == 1) {
 			rate->type = LQ_HT_SISO;
-			WARN_ON_ONCE(num_of_ant != 1);
+			WARN_ON_ONCE(!rate->stbc && num_of_ant != 1);
 		} else if (nss == 2) {
 			rate->type = LQ_HT_MIMO2;
 			WARN_ON_ONCE(num_of_ant != 2);
@@ -992,7 +1001,15 @@ static void rs_get_lower_rate_down_column(struct iwl_lq_sta *lq_sta,
 static inline bool rs_rate_match(struct rs_rate *a,
 				 struct rs_rate *b)
 {
-	return (a->type == b->type) && (a->ant == b->ant) && (a->sgi == b->sgi);
+	bool ant_match;
+
+	if (a->stbc)
+		ant_match = (b->ant == ANT_A || b->ant == ANT_B);
+	else
+		ant_match = (a->ant == b->ant);
+
+	return (a->type == b->type) && (a->bw == b->bw) && (a->sgi == b->sgi)
+		&& ant_match;
 }
 
 static u32 rs_ch_width_from_mac_flags(enum mac80211_rate_control_flags flags)
@@ -1623,6 +1640,8 @@ static int rs_switch_to_column(struct iwl_mvm *mvm,
 		else
 			rate->type = LQ_LEGACY_G;
 
+		rate->bw = RATE_MCS_CHAN_WIDTH_20;
+		rate->ldpc = false;
 		rate_mask = lq_sta->active_legacy_rate;
 	} else if (column->mode == RS_SISO) {
 		rate->type = lq_sta->is_vht ? LQ_VHT_SISO : LQ_HT_SISO;
@@ -1634,8 +1653,11 @@ static int rs_switch_to_column(struct iwl_mvm *mvm,
 		WARN_ON_ONCE("Bad column mode");
 	}
 
-	rate->bw = rs_bw_from_sta_bw(sta);
-	rate->ldpc = lq_sta->ldpc;
+	if (column->mode != RS_LEGACY) {
+		rate->bw = rs_bw_from_sta_bw(sta);
+		rate->ldpc = lq_sta->ldpc;
+	}
+
 	search_tbl->column = col_id;
 	rs_set_expected_tpt_table(lq_sta, search_tbl);
 
@@ -1754,6 +1776,29 @@ out:
 	return action;
 }
 
+static bool rs_stbc_allow(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
+			  struct iwl_lq_sta *lq_sta)
+{
+	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
+	struct ieee80211_vif *vif = mvmsta->vif;
+	bool sta_ps_disabled = (vif->type == NL80211_IFTYPE_STATION &&
+				!vif->bss_conf.ps);
+
+	/* Our chip supports Tx STBC and the peer is an HT/VHT STA which
+	 * supports STBC of at least 1*SS
+	 */
+	if (!lq_sta->stbc)
+		return false;
+
+	if (!mvm->ps_disabled && !sta_ps_disabled)
+		return false;
+
+	if (!iwl_mvm_bt_coex_is_mimo_allowed(mvm, sta))
+		return false;
+
+	return true;
+}
+
 static void rs_get_adjacent_txp(struct iwl_mvm *mvm, int index,
 				int *weaker, int *stronger)
 {
@@ -2675,6 +2720,11 @@ void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 		if (mvm->cfg->ht_params->ldpc &&
 		    (ht_cap->cap & IEEE80211_HT_CAP_LDPC_CODING))
 			lq_sta->ldpc = true;
+
+		if (mvm->cfg->ht_params->stbc &&
+		    (num_of_ant(mvm->fw->valid_tx_ant) > 1) &&
+		    (ht_cap->cap & IEEE80211_HT_CAP_RX_STBC))
+			lq_sta->stbc = true;
 	} else {
 		rs_vht_set_enabled_rates(sta, vht_cap, lq_sta);
 		lq_sta->is_vht = true;
@@ -2682,6 +2732,11 @@ void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 		if (mvm->cfg->ht_params->ldpc &&
 		    (vht_cap->cap & IEEE80211_VHT_CAP_RXLDPC))
 			lq_sta->ldpc = true;
+
+		if (mvm->cfg->ht_params->stbc &&
+		    (num_of_ant(mvm->fw->valid_tx_ant) > 1) &&
+		    (vht_cap->cap & IEEE80211_VHT_CAP_RXSTBC_MASK))
+			lq_sta->stbc = true;
 	}
 
 	if (IWL_MVM_RS_DISABLE_MIMO)
@@ -2695,11 +2750,11 @@ void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 						   BITS_PER_LONG);
 
 	IWL_DEBUG_RATE(mvm,
-		       "RATE MASK: LEGACY=%lX SISO=%lX MIMO2=%lX VHT=%d LDPC=%d\n",
+		       "RATE MASK: LEGACY=%lX SISO=%lX MIMO2=%lX VHT=%d LDPC=%d STBC%d\n",
 		       lq_sta->active_legacy_rate,
 		       lq_sta->active_siso_rate,
 		       lq_sta->active_mimo2_rate,
-		       lq_sta->is_vht, lq_sta->ldpc);
+		       lq_sta->is_vht, lq_sta->ldpc, lq_sta->stbc);
 	IWL_DEBUG_RATE(mvm, "MAX RATE: LEGACY=%d SISO=%d MIMO2=%d\n",
 		       lq_sta->max_legacy_rate_idx,
 		       lq_sta->max_siso_rate_idx,
@@ -2823,6 +2878,7 @@ static void rs_fill_rates_for_column(struct iwl_mvm *mvm,
  * rate[15] 0x800D Legacy | ANT: B Rate: 6 Mbps
  */
 static void rs_build_rates_table(struct iwl_mvm *mvm,
+				 struct ieee80211_sta *sta,
 				 struct iwl_lq_sta *lq_sta,
 				 const struct rs_rate *initial_rate)
 {
@@ -2835,6 +2891,7 @@ static void rs_build_rates_table(struct iwl_mvm *mvm,
 	memcpy(&rate, initial_rate, sizeof(rate));
 
 	valid_tx_ant = mvm->fw->valid_tx_ant;
+	rate.stbc = rs_stbc_allow(mvm, sta, lq_sta);
 
 	if (is_siso(&rate)) {
 		num_rates = RS_INITIAL_SISO_NUM_RATES;
@@ -2906,7 +2963,7 @@ static void rs_fill_lq_cmd(struct iwl_mvm *mvm,
 	if (WARN_ON_ONCE(!sta || !initial_rate))
 		return;
 
-	rs_build_rates_table(mvm, lq_sta, initial_rate);
+	rs_build_rates_table(mvm, sta, lq_sta, initial_rate);
 
 	if (num_of_ant(initial_rate->ant) == 1)
 		lq_cmd->single_stream_ant_msk = initial_rate->ant;
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.h b/drivers/net/wireless/iwlwifi/mvm/rs.h
index eb34c12..defd70a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.h
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.h
@@ -208,6 +208,7 @@ struct rs_rate {
 	u32 bw;
 	bool sgi;
 	bool ldpc;
+	bool stbc;
 };
 
 
@@ -331,6 +332,7 @@ struct iwl_lq_sta {
 	u64 last_tx;
 	bool is_vht;
 	bool ldpc;              /* LDPC Rx is supported by the STA */
+	bool stbc;              /* Tx STBC is supported by chip and Rx by STA */
 	enum ieee80211_band band;
 
 	/* The following are bitmaps of rates; IWL_RATE_6M_MASK, etc. */
-- 
1.9.1

