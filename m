Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:64046 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966073Ab2DLV6H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 17:58:07 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 02/24] iwlwifi: make iwl_sta_fill_lq static
Date: Thu, 12 Apr 2012 14:53:59 -0700
Message-Id: <1334267661-14654-3-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120412_235904_519459_AC0CBD5F)
In-Reply-To: <1334267661-14654-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334267661-14654-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

It's only used in a single place.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c |  100 ++++++++++++++--------------
 drivers/net/wireless/iwlwifi/iwl-agn.h     |    2 -
 2 files changed, 50 insertions(+), 52 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
index b74bb68..79cbaab 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -581,6 +581,56 @@ void iwl_deactivate_station(struct iwl_priv *priv, const u8 sta_id,
 	spin_unlock_bh(&priv->sta_lock);
 }
 
+static void iwl_sta_fill_lq(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
+			    u8 sta_id, struct iwl_link_quality_cmd *link_cmd)
+{
+	int i, r;
+	u32 rate_flags = 0;
+	__le32 rate_n_flags;
+
+	lockdep_assert_held(&priv->mutex);
+
+	memset(link_cmd, 0, sizeof(*link_cmd));
+
+	/* Set up the rate scaling to start at selected rate, fall back
+	 * all the way down to 1M in IEEE order, and then spin on 1M */
+	if (priv->band == IEEE80211_BAND_5GHZ)
+		r = IWL_RATE_6M_INDEX;
+	else if (ctx && ctx->vif && ctx->vif->p2p)
+		r = IWL_RATE_6M_INDEX;
+	else
+		r = IWL_RATE_1M_INDEX;
+
+	if (r >= IWL_FIRST_CCK_RATE && r <= IWL_LAST_CCK_RATE)
+		rate_flags |= RATE_MCS_CCK_MSK;
+
+	rate_flags |= first_antenna(priv->hw_params.valid_tx_ant) <<
+				RATE_MCS_ANT_POS;
+	rate_n_flags = iwl_hw_set_rate_n_flags(iwl_rates[r].plcp, rate_flags);
+	for (i = 0; i < LINK_QUAL_MAX_RETRY_NUM; i++)
+		link_cmd->rs_table[i].rate_n_flags = rate_n_flags;
+
+	link_cmd->general_params.single_stream_ant_msk =
+			first_antenna(priv->hw_params.valid_tx_ant);
+
+	link_cmd->general_params.dual_stream_ant_msk =
+		priv->hw_params.valid_tx_ant &
+		~first_antenna(priv->hw_params.valid_tx_ant);
+	if (!link_cmd->general_params.dual_stream_ant_msk) {
+		link_cmd->general_params.dual_stream_ant_msk = ANT_AB;
+	} else if (num_of_ant(priv->hw_params.valid_tx_ant) == 2) {
+		link_cmd->general_params.dual_stream_ant_msk =
+			priv->hw_params.valid_tx_ant;
+	}
+
+	link_cmd->agg_params.agg_dis_start_th =
+		LINK_QUAL_AGG_DISABLE_START_DEF;
+	link_cmd->agg_params.agg_time_limit =
+		cpu_to_le16(LINK_QUAL_AGG_TIME_LIMIT_DEF);
+
+	link_cmd->sta_id = sta_id;
+}
+
 /**
  * iwl_clear_ucode_stations - clear ucode station table bits
  *
@@ -841,56 +891,6 @@ int iwl_send_lq_cmd(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 }
 
 
-void iwl_sta_fill_lq(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
-		     u8 sta_id, struct iwl_link_quality_cmd *link_cmd)
-{
-	int i, r;
-	u32 rate_flags = 0;
-	__le32 rate_n_flags;
-
-	lockdep_assert_held(&priv->mutex);
-
-	memset(link_cmd, 0, sizeof(*link_cmd));
-
-	/* Set up the rate scaling to start at selected rate, fall back
-	 * all the way down to 1M in IEEE order, and then spin on 1M */
-	if (priv->band == IEEE80211_BAND_5GHZ)
-		r = IWL_RATE_6M_INDEX;
-	else if (ctx && ctx->vif && ctx->vif->p2p)
-		r = IWL_RATE_6M_INDEX;
-	else
-		r = IWL_RATE_1M_INDEX;
-
-	if (r >= IWL_FIRST_CCK_RATE && r <= IWL_LAST_CCK_RATE)
-		rate_flags |= RATE_MCS_CCK_MSK;
-
-	rate_flags |= first_antenna(priv->hw_params.valid_tx_ant) <<
-				RATE_MCS_ANT_POS;
-	rate_n_flags = iwl_hw_set_rate_n_flags(iwl_rates[r].plcp, rate_flags);
-	for (i = 0; i < LINK_QUAL_MAX_RETRY_NUM; i++)
-		link_cmd->rs_table[i].rate_n_flags = rate_n_flags;
-
-	link_cmd->general_params.single_stream_ant_msk =
-			first_antenna(priv->hw_params.valid_tx_ant);
-
-	link_cmd->general_params.dual_stream_ant_msk =
-		priv->hw_params.valid_tx_ant &
-		~first_antenna(priv->hw_params.valid_tx_ant);
-	if (!link_cmd->general_params.dual_stream_ant_msk) {
-		link_cmd->general_params.dual_stream_ant_msk = ANT_AB;
-	} else if (num_of_ant(priv->hw_params.valid_tx_ant) == 2) {
-		link_cmd->general_params.dual_stream_ant_msk =
-			priv->hw_params.valid_tx_ant;
-	}
-
-	link_cmd->agg_params.agg_dis_start_th =
-		LINK_QUAL_AGG_DISABLE_START_DEF;
-	link_cmd->agg_params.agg_time_limit =
-		cpu_to_le16(LINK_QUAL_AGG_TIME_LIMIT_DEF);
-
-	link_cmd->sta_id = sta_id;
-}
-
 static struct iwl_link_quality_cmd *
 iwl_sta_alloc_lq(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 		 u8 sta_id)
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index ae5cf54..9ee13f3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -256,8 +256,6 @@ void iwl_deactivate_station(struct iwl_priv *priv, const u8 sta_id,
 u8 iwl_prep_station(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 		    const u8 *addr, bool is_ap, struct ieee80211_sta *sta);
 
-void iwl_sta_fill_lq(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
-		     u8 sta_id, struct iwl_link_quality_cmd *link_cmd);
 int iwl_send_lq_cmd(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 		    struct iwl_link_quality_cmd *lq, u8 flags, bool init);
 int iwl_add_sta_callback(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb,
-- 
1.7.0.4

