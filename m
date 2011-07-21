Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:47950 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137Ab1GUP0r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2011 11:26:47 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 15/25] iwlagn: testmode fixed rate available for testmode only
Date: Thu, 21 Jul 2011 07:50:18 -0700
Message-Id: <1311259828-8415-16-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110721_172735_307823_E5ACD6C4)
In-Reply-To: <1311259828-8415-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1311259828-8415-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move tm_fixed_rate inside CONFIG_IWLWIFI_DEVICE_SVTOOL and only
available when the option is enable.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |    8 ++++++--
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |    2 ++
 drivers/net/wireless/iwlwifi/iwl-dev.h    |    2 +-
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index ebcd13b..3789ff4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -354,9 +354,11 @@ static void rs_program_fix_rate(struct iwl_priv *priv,
 	lq_sta->active_mimo2_rate  = 0x1FD0;	/* 6 - 60 MBits, no 9, no CCK */
 	lq_sta->active_mimo3_rate  = 0x1FD0;	/* 6 - 60 MBits, no 9, no CCK */
 
+#ifdef CONFIG_IWLWIFI_DEVICE_SVTOOL
 	/* testmode has higher priority to overwirte the fixed rate */
 	if (priv->tm_fixed_rate)
 		lq_sta->dbg_fixed_rate = priv->tm_fixed_rate;
+#endif
 
 	IWL_DEBUG_RATE(priv, "sta_id %d rate 0x%X\n",
 		lq_sta->lq.sta_id, lq_sta->dbg_fixed_rate);
@@ -1080,7 +1082,8 @@ done:
 	/* See if there's a better rate or modulation mode to try. */
 	if (sta && sta->supp_rates[sband->band])
 		rs_rate_scale_perform(priv, skb, sta, lq_sta);
-#ifdef CONFIG_MAC80211_DEBUGFS
+
+#if defined(CONFIG_MAC80211_DEBUGFS) && defined(CONFIG_IWLWIFI_DEVICE_SVTOOL)
 	if ((priv->tm_fixed_rate) &&
 	    (priv->tm_fixed_rate != lq_sta->dbg_fixed_rate))
 		rs_program_fix_rate(priv, lq_sta);
@@ -2904,8 +2907,9 @@ void iwl_rs_rate_init(struct iwl_priv *priv, struct ieee80211_sta *sta, u8 sta_i
 	if (sband->band == IEEE80211_BAND_5GHZ)
 		lq_sta->last_txrate_idx += IWL_FIRST_OFDM_RATE;
 	lq_sta->is_agg = 0;
-
+#ifdef CONFIG_IWLWIFI_DEVICE_SVTOOL
 	priv->tm_fixed_rate = 0;
+#endif
 #ifdef CONFIG_MAC80211_DEBUGFS
 	lq_sta->dbg_fixed_rate = 0;
 #endif
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index a5295c1..53bb59e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -217,6 +217,7 @@ static void iwlagn_tx_cmd_build_rate(struct iwl_priv *priv,
 	if (ieee80211_is_data(fc)) {
 		tx_cmd->initial_rate_index = 0;
 		tx_cmd->tx_flags |= TX_CMD_FLG_STA_RATE_MSK;
+#ifdef CONFIG_IWLWIFI_DEVICE_SVTOOL
 		if (priv->tm_fixed_rate) {
 			/*
 			 * rate overwrite by testmode
@@ -227,6 +228,7 @@ static void iwlagn_tx_cmd_build_rate(struct iwl_priv *priv,
 			memcpy(&tx_cmd->rate_n_flags, &priv->tm_fixed_rate,
 			       sizeof(tx_cmd->rate_n_flags));
 		}
+#endif
 		return;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 964be57..72ef50e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1535,8 +1535,8 @@ struct iwl_priv {
 	bool led_registered;
 #ifdef CONFIG_IWLWIFI_DEVICE_SVTOOL
 	struct iwl_testmode_trace testmode_trace;
-#endif
 	u32 tm_fixed_rate;
+#endif
 
 }; /*iwl_priv */
 
-- 
1.7.0.4

