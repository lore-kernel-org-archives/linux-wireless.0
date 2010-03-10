Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:57656 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690Ab0CJFWF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 00:22:05 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 09/24] iwlwifi: remove priv->active_rate_basic
Date: Tue,  9 Mar 2010 21:21:37 -0800
Message-Id: <1268198512-6572-10-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1268198512-6572-1-git-send-email-reinette.chatre@intel.com>
References: <1268198512-6572-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This variable is assigned a default value,
but then assigned zero as soon as mac80211
calls a change channel (which will happen
right after the hw is started) and after
that it never changes again.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c   |    5 ---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.h   |    1 -
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    1 -
 drivers/net/wireless/iwlwifi/iwl-core.c     |   51 +++++---------------------
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    1 -
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    1 -
 6 files changed, 10 insertions(+), 50 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 696e668..84271cc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -597,10 +597,6 @@ static u16 rs_get_supported_rates(struct iwl_lq_sta *lq_sta,
 				  struct ieee80211_hdr *hdr,
 				  enum iwl_table_type rate_type)
 {
-	if (hdr && is_multicast_ether_addr(hdr->addr1) &&
-	    lq_sta->active_rate_basic)
-		return lq_sta->active_rate_basic;
-
 	if (is_legacy(rate_type)) {
 		return lq_sta->active_legacy_rate;
 	} else {
@@ -2552,7 +2548,6 @@ static void rs_rate_init(void *priv_r, struct ieee80211_supported_band *sband,
 	lq_sta->missed_rate_counter = IWL_MISSED_RATE_MAX;
 	lq_sta->is_green = rs_use_green(sta, &priv->current_ht_config);
 	lq_sta->active_legacy_rate = priv->active_rate & ~(0x1000);
-	lq_sta->active_rate_basic = priv->active_rate_basic;
 	lq_sta->band = priv->band;
 	/*
 	 * active_siso_rate mask includes 9 MBits (bit 5), and CCK (bits 0-3),
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
index e719239..e182f5a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
@@ -411,7 +411,6 @@ struct iwl_lq_sta {
 	u16 active_siso_rate;
 	u16 active_mimo2_rate;
 	u16 active_mimo3_rate;
-	u16 active_rate_basic;
 	s8 max_rate_idx;     /* Max rate set by user */
 	u8 missed_rate_counter;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index e7e4bf7..fbbe998 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2104,7 +2104,6 @@ static void iwl_alive_start(struct iwl_priv *priv)
 	ieee80211_wake_queues(priv->hw);
 
 	priv->active_rate = IWL_RATES_MASK;
-	priv->active_rate_basic = IWL_RATES_MASK & IWL_BASIC_RATES_MASK;
 
 	/* Configure Tx antenna selection based on H/W config */
 	if (priv->cfg->ops->hcmd->set_tx_ant)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 1cfcc9f..8e8f528 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -897,23 +897,10 @@ EXPORT_SYMBOL(iwl_full_rxon_required);
 
 u8 iwl_rate_get_lowest_plcp(struct iwl_priv *priv)
 {
-	int i;
-	int rate_mask;
-
-	/* Set rate mask*/
-	if (priv->staging_rxon.flags & RXON_FLG_BAND_24G_MSK)
-		rate_mask = priv->active_rate_basic & IWL_CCK_RATES_MASK;
-	else
-		rate_mask = priv->active_rate_basic & IWL_OFDM_RATES_MASK;
-
-	/* Find lowest valid rate */
-	for (i = IWL_RATE_1M_INDEX; i != IWL_RATE_INVALID;
-					i = iwl_rates[i].next_ieee) {
-		if (rate_mask & (1 << i))
-			return iwl_rates[i].plcp;
-	}
-
-	/* No valid rate was found. Assign the lowest one */
+	/*
+	 * Assign the lowest rate -- should really get this from
+	 * the beacon skb from mac80211.
+	 */
 	if (priv->staging_rxon.flags & RXON_FLG_BAND_24G_MSK)
 		return IWL_RATE_1M_PLCP;
 	else
@@ -1272,7 +1259,6 @@ static void iwl_set_rate(struct iwl_priv *priv)
 	}
 
 	priv->active_rate = 0;
-	priv->active_rate_basic = 0;
 
 	for (i = 0; i < hw->n_bitrates; i++) {
 		rate = &(hw->bitrates[i]);
@@ -1280,30 +1266,13 @@ static void iwl_set_rate(struct iwl_priv *priv)
 			priv->active_rate |= (1 << rate->hw_value);
 	}
 
-	IWL_DEBUG_RATE(priv, "Set active_rate = %0x, active_rate_basic = %0x\n",
-		       priv->active_rate, priv->active_rate_basic);
+	IWL_DEBUG_RATE(priv, "Set active_rate = %0x\n", priv->active_rate);
 
-	/*
-	 * If a basic rate is configured, then use it (adding IWL_RATE_1M_MASK)
-	 * otherwise set it to the default of all CCK rates and 6, 12, 24 for
-	 * OFDM
-	 */
-	if (priv->active_rate_basic & IWL_CCK_BASIC_RATES_MASK)
-		priv->staging_rxon.cck_basic_rates =
-		    ((priv->active_rate_basic &
-		      IWL_CCK_RATES_MASK) >> IWL_FIRST_CCK_RATE) & 0xF;
-	else
-		priv->staging_rxon.cck_basic_rates =
-		    (IWL_CCK_BASIC_RATES_MASK >> IWL_FIRST_CCK_RATE) & 0xF;
-
-	if (priv->active_rate_basic & IWL_OFDM_BASIC_RATES_MASK)
-		priv->staging_rxon.ofdm_basic_rates =
-		    ((priv->active_rate_basic &
-		      (IWL_OFDM_BASIC_RATES_MASK | IWL_RATE_6M_MASK)) >>
-		      IWL_FIRST_OFDM_RATE) & 0xFF;
-	else
-		priv->staging_rxon.ofdm_basic_rates =
-		   (IWL_OFDM_BASIC_RATES_MASK >> IWL_FIRST_OFDM_RATE) & 0xFF;
+	priv->staging_rxon.cck_basic_rates =
+	    (IWL_CCK_BASIC_RATES_MASK >> IWL_FIRST_CCK_RATE) & 0xF;
+
+	priv->staging_rxon.ofdm_basic_rates =
+	   (IWL_OFDM_BASIC_RATES_MASK >> IWL_FIRST_OFDM_RATE) & 0xFF;
 }
 
 void iwl_rx_csa(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 4d6558f..ba404b9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1168,7 +1168,6 @@ struct iwl_priv {
 	u64 led_tpt;
 
 	u16 active_rate;
-	u16 active_rate_basic;
 
 	u8 assoc_station_added;
 	u8 start_calib;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index b2b0505..9cc15f9 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2509,7 +2509,6 @@ static void iwl3945_alive_start(struct iwl_priv *priv)
 	ieee80211_wake_queues(priv->hw);
 
 	priv->active_rate = IWL_RATES_MASK;
-	priv->active_rate_basic = IWL_RATES_MASK & IWL_BASIC_RATES_MASK;
 
 	iwl_power_update_mode(priv, true);
 
-- 
1.6.3.3

