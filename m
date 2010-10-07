Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:59924 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653Ab0JGXIs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 19:08:48 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 04/22] iwlwifi: move chain settings to agn
Date: Thu,  7 Oct 2010 16:07:43 -0700
Message-Id: <1286492881-15743-5-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1286492881-15743-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1286492881-15743-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The core module doesn't need to carry around
the code for chain settings that is used for
HT drivers (agn) only.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |  140 ++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.h      |    1 +
 drivers/net/wireless/iwlwifi/iwl-core.c     |  141 ---------------------------
 drivers/net/wireless/iwlwifi/iwl-core.h     |    1 -
 6 files changed, 144 insertions(+), 145 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index e161f5d..20626c9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2217,7 +2217,7 @@ static void iwl4965_cancel_deferred_work(struct iwl_priv *priv)
 static struct iwl_hcmd_ops iwl4965_hcmd = {
 	.rxon_assoc = iwl4965_send_rxon_assoc,
 	.commit_rxon = iwlagn_commit_rxon,
-	.set_rxon_chain = iwl_set_rxon_chain,
+	.set_rxon_chain = iwlagn_set_rxon_chain,
 	.send_bt_config = iwl_send_bt_config,
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
index 634177d..ffb2f41 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
@@ -361,7 +361,7 @@ static int iwlagn_set_pan_params(struct iwl_priv *priv)
 struct iwl_hcmd_ops iwlagn_hcmd = {
 	.rxon_assoc = iwlagn_send_rxon_assoc,
 	.commit_rxon = iwlagn_commit_rxon,
-	.set_rxon_chain = iwl_set_rxon_chain,
+	.set_rxon_chain = iwlagn_set_rxon_chain,
 	.set_tx_ant = iwlagn_send_tx_ant_config,
 	.send_bt_config = iwl_send_bt_config,
 	.set_pan_params = iwlagn_set_pan_params,
@@ -370,7 +370,7 @@ struct iwl_hcmd_ops iwlagn_hcmd = {
 struct iwl_hcmd_ops iwlagn_bt_hcmd = {
 	.rxon_assoc = iwlagn_send_rxon_assoc,
 	.commit_rxon = iwlagn_commit_rxon,
-	.set_rxon_chain = iwl_set_rxon_chain,
+	.set_rxon_chain = iwlagn_set_rxon_chain,
 	.set_tx_ant = iwlagn_send_tx_ant_config,
 	.send_bt_config = iwlagn_send_advance_bt_config,
 	.set_pan_params = iwlagn_set_pan_params,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 3fa2c5c..0b45bce 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -2065,3 +2065,143 @@ void iwlagn_bt_cancel_deferred_work(struct iwl_priv *priv)
 {
 	cancel_work_sync(&priv->bt_traffic_change_work);
 }
+
+static bool is_single_rx_stream(struct iwl_priv *priv)
+{
+	return priv->current_ht_config.smps == IEEE80211_SMPS_STATIC ||
+	       priv->current_ht_config.single_chain_sufficient;
+}
+
+#define IWL_NUM_RX_CHAINS_MULTIPLE	3
+#define IWL_NUM_RX_CHAINS_SINGLE	2
+#define IWL_NUM_IDLE_CHAINS_DUAL	2
+#define IWL_NUM_IDLE_CHAINS_SINGLE	1
+
+/*
+ * Determine how many receiver/antenna chains to use.
+ *
+ * More provides better reception via diversity.  Fewer saves power
+ * at the expense of throughput, but only when not in powersave to
+ * start with.
+ *
+ * MIMO (dual stream) requires at least 2, but works better with 3.
+ * This does not determine *which* chains to use, just how many.
+ */
+static int iwl_get_active_rx_chain_count(struct iwl_priv *priv)
+{
+	if (priv->cfg->bt_params &&
+	    priv->cfg->bt_params->advanced_bt_coexist &&
+	    (priv->bt_full_concurrent ||
+	     priv->bt_traffic_load >= IWL_BT_COEX_TRAFFIC_LOAD_HIGH)) {
+		/*
+		 * only use chain 'A' in bt high traffic load or
+		 * full concurrency mode
+		 */
+		return IWL_NUM_RX_CHAINS_SINGLE;
+	}
+	/* # of Rx chains to use when expecting MIMO. */
+	if (is_single_rx_stream(priv))
+		return IWL_NUM_RX_CHAINS_SINGLE;
+	else
+		return IWL_NUM_RX_CHAINS_MULTIPLE;
+}
+
+/*
+ * When we are in power saving mode, unless device support spatial
+ * multiplexing power save, use the active count for rx chain count.
+ */
+static int iwl_get_idle_rx_chain_count(struct iwl_priv *priv, int active_cnt)
+{
+	/* # Rx chains when idling, depending on SMPS mode */
+	switch (priv->current_ht_config.smps) {
+	case IEEE80211_SMPS_STATIC:
+	case IEEE80211_SMPS_DYNAMIC:
+		return IWL_NUM_IDLE_CHAINS_SINGLE;
+	case IEEE80211_SMPS_OFF:
+		return active_cnt;
+	default:
+		WARN(1, "invalid SMPS mode %d",
+		     priv->current_ht_config.smps);
+		return active_cnt;
+	}
+}
+
+/* up to 4 chains */
+static u8 iwl_count_chain_bitmap(u32 chain_bitmap)
+{
+	u8 res;
+	res = (chain_bitmap & BIT(0)) >> 0;
+	res += (chain_bitmap & BIT(1)) >> 1;
+	res += (chain_bitmap & BIT(2)) >> 2;
+	res += (chain_bitmap & BIT(3)) >> 3;
+	return res;
+}
+
+/**
+ * iwlagn_set_rxon_chain - Set up Rx chain usage in "staging" RXON image
+ *
+ * Selects how many and which Rx receivers/antennas/chains to use.
+ * This should not be used for scan command ... it puts data in wrong place.
+ */
+void iwlagn_set_rxon_chain(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
+{
+	bool is_single = is_single_rx_stream(priv);
+	bool is_cam = !test_bit(STATUS_POWER_PMI, &priv->status);
+	u8 idle_rx_cnt, active_rx_cnt, valid_rx_cnt;
+	u32 active_chains;
+	u16 rx_chain;
+
+	/* Tell uCode which antennas are actually connected.
+	 * Before first association, we assume all antennas are connected.
+	 * Just after first association, iwl_chain_noise_calibration()
+	 *    checks which antennas actually *are* connected. */
+	if (priv->chain_noise_data.active_chains)
+		active_chains = priv->chain_noise_data.active_chains;
+	else
+		active_chains = priv->hw_params.valid_rx_ant;
+
+	if (priv->cfg->bt_params &&
+	    priv->cfg->bt_params->advanced_bt_coexist &&
+	    (priv->bt_full_concurrent ||
+	     priv->bt_traffic_load >= IWL_BT_COEX_TRAFFIC_LOAD_HIGH)) {
+		/*
+		 * only use chain 'A' in bt high traffic load or
+		 * full concurrency mode
+		 */
+		active_chains = first_antenna(active_chains);
+	}
+
+	rx_chain = active_chains << RXON_RX_CHAIN_VALID_POS;
+
+	/* How many receivers should we use? */
+	active_rx_cnt = iwl_get_active_rx_chain_count(priv);
+	idle_rx_cnt = iwl_get_idle_rx_chain_count(priv, active_rx_cnt);
+
+
+	/* correct rx chain count according hw settings
+	 * and chain noise calibration
+	 */
+	valid_rx_cnt = iwl_count_chain_bitmap(active_chains);
+	if (valid_rx_cnt < active_rx_cnt)
+		active_rx_cnt = valid_rx_cnt;
+
+	if (valid_rx_cnt < idle_rx_cnt)
+		idle_rx_cnt = valid_rx_cnt;
+
+	rx_chain |= active_rx_cnt << RXON_RX_CHAIN_MIMO_CNT_POS;
+	rx_chain |= idle_rx_cnt  << RXON_RX_CHAIN_CNT_POS;
+
+	ctx->staging.rx_chain = cpu_to_le16(rx_chain);
+
+	if (!is_single && (active_rx_cnt >= IWL_NUM_RX_CHAINS_SINGLE) && is_cam)
+		ctx->staging.rx_chain |= RXON_RX_CHAIN_MIMO_FORCE_MSK;
+	else
+		ctx->staging.rx_chain &= ~RXON_RX_CHAIN_MIMO_FORCE_MSK;
+
+	IWL_DEBUG_ASSOC(priv, "rx_chain=0x%X active=%d idle=%d\n",
+			ctx->staging.rx_chain,
+			active_rx_cnt, idle_rx_cnt);
+
+	WARN_ON(active_rx_cnt == 0 || idle_rx_cnt == 0 ||
+		active_rx_cnt < idle_rx_cnt);
+}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 960fe2e..5d5cacb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -131,6 +131,7 @@ void iwl_free_tfds_in_queue(struct iwl_priv *priv,
 
 /* RXON */
 int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx);
+void iwlagn_set_rxon_chain(struct iwl_priv *priv, struct iwl_rxon_context *ctx);
 
 /* uCode */
 int iwlagn_load_ucode(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 516c55a..dd7c3cb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -439,12 +439,6 @@ void iwlcore_tx_cmd_protection(struct iwl_priv *priv,
 EXPORT_SYMBOL(iwlcore_tx_cmd_protection);
 
 
-static bool is_single_rx_stream(struct iwl_priv *priv)
-{
-	return priv->current_ht_config.smps == IEEE80211_SMPS_STATIC ||
-	       priv->current_ht_config.single_chain_sufficient;
-}
-
 static bool iwl_is_channel_extension(struct iwl_priv *priv,
 				     enum ieee80211_band band,
 				     u16 channel, u8 extension_chan_offset)
@@ -834,141 +828,6 @@ void iwl_set_rxon_ht(struct iwl_priv *priv, struct iwl_ht_config *ht_conf)
 }
 EXPORT_SYMBOL(iwl_set_rxon_ht);
 
-#define IWL_NUM_RX_CHAINS_MULTIPLE	3
-#define IWL_NUM_RX_CHAINS_SINGLE	2
-#define IWL_NUM_IDLE_CHAINS_DUAL	2
-#define IWL_NUM_IDLE_CHAINS_SINGLE	1
-
-/*
- * Determine how many receiver/antenna chains to use.
- *
- * More provides better reception via diversity.  Fewer saves power
- * at the expense of throughput, but only when not in powersave to
- * start with.
- *
- * MIMO (dual stream) requires at least 2, but works better with 3.
- * This does not determine *which* chains to use, just how many.
- */
-static int iwl_get_active_rx_chain_count(struct iwl_priv *priv)
-{
-	if (priv->cfg->bt_params &&
-	    priv->cfg->bt_params->advanced_bt_coexist &&
-	    (priv->bt_full_concurrent ||
-	     priv->bt_traffic_load >= IWL_BT_COEX_TRAFFIC_LOAD_HIGH)) {
-		/*
-		 * only use chain 'A' in bt high traffic load or
-		 * full concurrency mode
-		 */
-		return IWL_NUM_RX_CHAINS_SINGLE;
-	}
-	/* # of Rx chains to use when expecting MIMO. */
-	if (is_single_rx_stream(priv))
-		return IWL_NUM_RX_CHAINS_SINGLE;
-	else
-		return IWL_NUM_RX_CHAINS_MULTIPLE;
-}
-
-/*
- * When we are in power saving mode, unless device support spatial
- * multiplexing power save, use the active count for rx chain count.
- */
-static int iwl_get_idle_rx_chain_count(struct iwl_priv *priv, int active_cnt)
-{
-	/* # Rx chains when idling, depending on SMPS mode */
-	switch (priv->current_ht_config.smps) {
-	case IEEE80211_SMPS_STATIC:
-	case IEEE80211_SMPS_DYNAMIC:
-		return IWL_NUM_IDLE_CHAINS_SINGLE;
-	case IEEE80211_SMPS_OFF:
-		return active_cnt;
-	default:
-		WARN(1, "invalid SMPS mode %d",
-		     priv->current_ht_config.smps);
-		return active_cnt;
-	}
-}
-
-/* up to 4 chains */
-static u8 iwl_count_chain_bitmap(u32 chain_bitmap)
-{
-	u8 res;
-	res = (chain_bitmap & BIT(0)) >> 0;
-	res += (chain_bitmap & BIT(1)) >> 1;
-	res += (chain_bitmap & BIT(2)) >> 2;
-	res += (chain_bitmap & BIT(3)) >> 3;
-	return res;
-}
-
-/**
- * iwl_set_rxon_chain - Set up Rx chain usage in "staging" RXON image
- *
- * Selects how many and which Rx receivers/antennas/chains to use.
- * This should not be used for scan command ... it puts data in wrong place.
- */
-void iwl_set_rxon_chain(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
-{
-	bool is_single = is_single_rx_stream(priv);
-	bool is_cam = !test_bit(STATUS_POWER_PMI, &priv->status);
-	u8 idle_rx_cnt, active_rx_cnt, valid_rx_cnt;
-	u32 active_chains;
-	u16 rx_chain;
-
-	/* Tell uCode which antennas are actually connected.
-	 * Before first association, we assume all antennas are connected.
-	 * Just after first association, iwl_chain_noise_calibration()
-	 *    checks which antennas actually *are* connected. */
-	if (priv->chain_noise_data.active_chains)
-		active_chains = priv->chain_noise_data.active_chains;
-	else
-		active_chains = priv->hw_params.valid_rx_ant;
-
-	if (priv->cfg->bt_params &&
-	    priv->cfg->bt_params->advanced_bt_coexist &&
-	    (priv->bt_full_concurrent ||
-	     priv->bt_traffic_load >= IWL_BT_COEX_TRAFFIC_LOAD_HIGH)) {
-		/*
-		 * only use chain 'A' in bt high traffic load or
-		 * full concurrency mode
-		 */
-		active_chains = first_antenna(active_chains);
-	}
-
-	rx_chain = active_chains << RXON_RX_CHAIN_VALID_POS;
-
-	/* How many receivers should we use? */
-	active_rx_cnt = iwl_get_active_rx_chain_count(priv);
-	idle_rx_cnt = iwl_get_idle_rx_chain_count(priv, active_rx_cnt);
-
-
-	/* correct rx chain count according hw settings
-	 * and chain noise calibration
-	 */
-	valid_rx_cnt = iwl_count_chain_bitmap(active_chains);
-	if (valid_rx_cnt < active_rx_cnt)
-		active_rx_cnt = valid_rx_cnt;
-
-	if (valid_rx_cnt < idle_rx_cnt)
-		idle_rx_cnt = valid_rx_cnt;
-
-	rx_chain |= active_rx_cnt << RXON_RX_CHAIN_MIMO_CNT_POS;
-	rx_chain |= idle_rx_cnt  << RXON_RX_CHAIN_CNT_POS;
-
-	ctx->staging.rx_chain = cpu_to_le16(rx_chain);
-
-	if (!is_single && (active_rx_cnt >= IWL_NUM_RX_CHAINS_SINGLE) && is_cam)
-		ctx->staging.rx_chain |= RXON_RX_CHAIN_MIMO_FORCE_MSK;
-	else
-		ctx->staging.rx_chain &= ~RXON_RX_CHAIN_MIMO_FORCE_MSK;
-
-	IWL_DEBUG_ASSOC(priv, "rx_chain=0x%X active=%d idle=%d\n",
-			ctx->staging.rx_chain,
-			active_rx_cnt, idle_rx_cnt);
-
-	WARN_ON(active_rx_cnt == 0 || idle_rx_cnt == 0 ||
-		active_rx_cnt < idle_rx_cnt);
-}
-EXPORT_SYMBOL(iwl_set_rxon_chain);
-
 /* Return valid, unused, channel for a passive scan to reset the RF */
 u8 iwl_get_single_channel_number(struct iwl_priv *priv,
 				 enum ieee80211_band band)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 09908f6..50a3c26 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -407,7 +407,6 @@ void iwl_set_rxon_hwcrypto(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 			   int hw_decrypt);
 int iwl_check_rxon_cmd(struct iwl_priv *priv, struct iwl_rxon_context *ctx);
 int iwl_full_rxon_required(struct iwl_priv *priv, struct iwl_rxon_context *ctx);
-void iwl_set_rxon_chain(struct iwl_priv *priv, struct iwl_rxon_context *ctx);
 int iwl_set_rxon_channel(struct iwl_priv *priv, struct ieee80211_channel *ch,
 			 struct iwl_rxon_context *ctx);
 void iwl_set_flags_for_band(struct iwl_priv *priv,
-- 
1.7.0.4

