Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:63195 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966080Ab2DLV6H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 17:58:07 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 03/24] iwlwifi: calculate active legacy rates per station
Date: Thu, 12 Apr 2012 14:54:00 -0700
Message-Id: <1334267661-14654-4-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120412_235904_585401_65D649AB)
In-Reply-To: <1334267661-14654-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334267661-14654-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Not all stations are guaranteed to have the same
active (available) legacy rates, so calculate them
on rate control init instead of hard-coding them
based on our own available rates. I have no idea
why that was done here before.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |   12 ++++++++++--
 drivers/net/wireless/iwlwifi/iwl-agn.c    |    2 --
 drivers/net/wireless/iwlwifi/iwl-core.c   |   19 -------------------
 drivers/net/wireless/iwlwifi/iwl-dev.h    |    2 --
 4 files changed, 10 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 08419e8..8b13b6c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -2826,6 +2826,7 @@ void iwl_rs_rate_init(struct iwl_priv *priv, struct ieee80211_sta *sta, u8 sta_i
 	struct iwl_station_priv *sta_priv;
 	struct iwl_lq_sta *lq_sta;
 	struct ieee80211_supported_band *sband;
+	unsigned long supp; /* must be unsigned long for for_each_set_bit */
 
 	sta_priv = (struct iwl_station_priv *) sta->drv_priv;
 	lq_sta = &sta_priv->lq_sta;
@@ -2855,8 +2856,15 @@ void iwl_rs_rate_init(struct iwl_priv *priv, struct ieee80211_sta *sta, u8 sta_i
 	lq_sta->max_rate_idx = -1;
 	lq_sta->missed_rate_counter = IWL_MISSED_RATE_MAX;
 	lq_sta->is_green = rs_use_green(sta);
-	lq_sta->active_legacy_rate = priv->active_rate & ~(0x1000);
-	lq_sta->band = priv->band;
+	lq_sta->band = sband->band;
+	/*
+	 * active legacy rates as per supported rates bitmap
+	 */
+	supp = sta->supp_rates[sband->band];
+	lq_sta->active_legacy_rate = 0;
+	for_each_set_bit(i, &supp, BITS_PER_LONG)
+		lq_sta->active_legacy_rate |= BIT(sband->bitrates[i].hw_value);
+
 	/*
 	 * active_siso_rate mask includes 9 MBits (bit 5), and CCK (bits 0-3),
 	 * supp_rates[] does not; shift to convert format, force 9 MBits off.
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index b507ee6..208b827 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -790,8 +790,6 @@ int iwl_alive_start(struct iwl_priv *priv)
 
 	ieee80211_wake_queues(priv->hw);
 
-	priv->active_rate = IWL_RATES_MASK;
-
 	/* Configure Tx antenna selection based on H/W config */
 	iwlagn_send_tx_ant_config(priv, priv->hw_params.valid_tx_ant);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 6a02ade..0f86f1c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -287,26 +287,7 @@ void iwl_connection_init_rx_config(struct iwl_priv *priv,
 
 void iwl_set_rate(struct iwl_priv *priv)
 {
-	const struct ieee80211_supported_band *hw = NULL;
-	struct ieee80211_rate *rate;
 	struct iwl_rxon_context *ctx;
-	int i;
-
-	hw = iwl_get_hw_mode(priv, priv->band);
-	if (!hw) {
-		IWL_ERR(priv, "Failed to set rate: unable to get hw mode\n");
-		return;
-	}
-
-	priv->active_rate = 0;
-
-	for (i = 0; i < hw->n_bitrates; i++) {
-		rate = &(hw->bitrates[i]);
-		if (rate->hw_value < IWL_RATE_COUNT_LEGACY)
-			priv->active_rate |= (1 << rate->hw_value);
-	}
-
-	IWL_DEBUG_RATE(priv, "Set active_rate = %0x\n", priv->active_rate);
 
 	for_each_context(priv, ctx) {
 		ctx->staging.cck_basic_rates =
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 2c41423..d8dd9ac 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -861,8 +861,6 @@ struct iwl_priv {
 
 	__le16 switch_channel;
 
-	u16 active_rate;
-
 	u8 start_calib;
 	struct iwl_sensitivity_data sensitivity_data;
 	struct iwl_chain_noise_data chain_noise_data;
-- 
1.7.0.4

