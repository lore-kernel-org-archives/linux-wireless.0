Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:49635 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130Ab1FXTjJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jun 2011 15:39:09 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 4/5] iwlagn: fill beacon TX rate properly
Date: Fri, 24 Jun 2011 12:07:16 -0700
Message-Id: <1308942437-6039-5-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110624_213925_899920_F19406E7)
In-Reply-To: <1308942437-6039-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1308942437-6039-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Use the rate that mac80211 requested to fill the
uCode TX command for the beacon. Unfortunately,
the uCode is (currently?) ignoring it, but now
at least fill it properly.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c  |   26 ++++++++++++++++++++++----
 drivers/net/wireless/iwlwifi/iwl-core.c |   13 -------------
 drivers/net/wireless/iwlwifi/iwl-core.h |    7 -------
 3 files changed, 22 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 77ceb8d..e2f6b2a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -132,6 +132,7 @@ int iwlagn_send_beacon_cmd(struct iwl_priv *priv)
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_TX_BEACON,
 	};
+	struct ieee80211_tx_info *info;
 	u32 frame_size;
 	u32 rate_flags;
 	u32 rate;
@@ -172,14 +173,31 @@ int iwlagn_send_beacon_cmd(struct iwl_priv *priv)
 			   frame_size);
 
 	/* Set up packet rate and flags */
-	rate = iwl_rate_get_lowest_plcp(priv, priv->beacon_ctx);
+	info = IEEE80211_SKB_CB(priv->beacon_skb);
+
+	/*
+	 * Let's set up the rate at least somewhat correctly;
+	 * it will currently not actually be used by the uCode,
+	 * it uses the broadcast station's rate instead.
+	 */
+	if (info->control.rates[0].idx < 0 ||
+	    info->control.rates[0].flags & IEEE80211_TX_RC_MCS)
+		rate = 0;
+	else
+		rate = info->control.rates[0].idx;
+
 	priv->mgmt_tx_ant = iwl_toggle_tx_ant(priv, priv->mgmt_tx_ant,
 					      priv->hw_params.valid_tx_ant);
 	rate_flags = iwl_ant_idx_to_flags(priv->mgmt_tx_ant);
-	if ((rate >= IWL_FIRST_CCK_RATE) && (rate <= IWL_LAST_CCK_RATE))
+
+	/* In mac80211, rates for 5 GHz start at 0 */
+	if (info->band == IEEE80211_BAND_5GHZ)
+		rate += IWL_FIRST_OFDM_RATE;
+	else if (rate >= IWL_FIRST_CCK_RATE && rate <= IWL_LAST_CCK_RATE)
 		rate_flags |= RATE_MCS_CCK_MSK;
-	tx_beacon_cmd->tx.rate_n_flags = iwl_hw_set_rate_n_flags(rate,
-			rate_flags);
+
+	tx_beacon_cmd->tx.rate_n_flags =
+			iwl_hw_set_rate_n_flags(rate, rate_flags);
 
 	/* Submit command */
 	cmd.len[0] = sizeof(*tx_beacon_cmd);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index cde7253..f0eabbc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -526,19 +526,6 @@ int iwl_full_rxon_required(struct iwl_priv *priv,
 	return 0;
 }
 
-u8 iwl_rate_get_lowest_plcp(struct iwl_priv *priv,
-			    struct iwl_rxon_context *ctx)
-{
-	/*
-	 * Assign the lowest rate -- should really get this from
-	 * the beacon skb from mac80211.
-	 */
-	if (ctx->staging.flags & RXON_FLG_BAND_24G_MSK)
-		return IWL_RATE_1M_PLCP;
-	else
-		return IWL_RATE_6M_PLCP;
-}
-
 static void _iwl_set_rxon_ht(struct iwl_priv *priv,
 			     struct iwl_ht_config *ht_conf,
 			     struct iwl_rxon_context *ctx)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index adf9f9b..f881678 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -409,13 +409,6 @@ void iwl_setup_watchdog(struct iwl_priv *priv);
 int iwl_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force);
 
 /*******************************************************************************
- * Rate
- ******************************************************************************/
-
-u8 iwl_rate_get_lowest_plcp(struct iwl_priv *priv,
-			    struct iwl_rxon_context *ctx);
-
-/*******************************************************************************
  * Scanning
  ******************************************************************************/
 void iwl_init_scan_params(struct iwl_priv *priv);
-- 
1.7.0.4

