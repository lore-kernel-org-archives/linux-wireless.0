Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:54400 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290Ab0H0Q4n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 12:56:43 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 01/27] iwlwifi: initial contextification
Date: Fri, 27 Aug 2010 09:59:29 -0700
Message-Id: <1282928395-32762-2-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282928395-32762-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282928395-32762-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In order to support multiple interfaces, we must move
a lot of data into per-context structures so we can
use the contexts the device offers. To start with,
this makes a lot of code context-aware, more changes
will move more things into the context structure.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c   |    3 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c      |   53 ++--
 drivers/net/wireless/iwlwifi/iwl-4965.c      |   46 ++--
 drivers/net/wireless/iwlwifi/iwl-5000.c      |   15 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c      |   15 +-
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c |   12 +-
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c  |   27 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c   |    6 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tt.c    |   26 ++-
 drivers/net/wireless/iwlwifi/iwl-agn.c       |  172 +++++++-----
 drivers/net/wireless/iwlwifi/iwl-agn.h       |    3 +-
 drivers/net/wireless/iwlwifi/iwl-core.c      |  391 +++++++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-core.h      |   38 ++-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c   |    7 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h       |   62 ++++-
 drivers/net/wireless/iwlwifi/iwl-rx.c        |    9 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c      |    9 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c       |    6 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c  |  111 +++++---
 19 files changed, 611 insertions(+), 400 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
index 8e84a08..08f53f8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
@@ -949,7 +949,8 @@ void iwl3945_rate_scale_init(struct ieee80211_hw *hw, s32 sta_id)
 	switch (priv->band) {
 	case IEEE80211_BAND_2GHZ:
 		/* TODO: this always does G, not a regression */
-		if (priv->active_rxon.flags & RXON_FLG_TGG_PROTECT_MSK) {
+		if (priv->contexts[IWL_RXON_CTX_BSS].active.flags &
+						RXON_FLG_TGG_PROTECT_MSK) {
 			rs_sta->tgg = 1;
 			rs_sta->expected_tpt = iwl3945_expected_tpt_g_prot;
 		} else
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 8ccfcd0..f4aa229 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -245,7 +245,7 @@ int iwl3945_rs_next_rate(struct iwl_priv *priv, int rate)
 		break;
 	case IEEE80211_BAND_2GHZ:
 		if (!(priv->_3945.sta_supp_rates & IWL_OFDM_RATES_MASK) &&
-		    iwl_is_associated(priv)) {
+		    iwl_is_associated(priv, IWL_RXON_CTX_BSS)) {
 			if (rate == IWL_RATE_11M_INDEX)
 				next_rate = IWL_RATE_5M_INDEX;
 		}
@@ -1439,17 +1439,18 @@ static int iwl3945_send_tx_power(struct iwl_priv *priv)
 	int rate_idx, i;
 	const struct iwl_channel_info *ch_info = NULL;
 	struct iwl3945_txpowertable_cmd txpower = {
-		.channel = priv->active_rxon.channel,
+		.channel = priv->contexts[IWL_RXON_CTX_BSS].active.channel,
 	};
+	u16 chan;
+
+	chan = le16_to_cpu(priv->contexts[IWL_RXON_CTX_BSS].active.channel);
 
 	txpower.band = (priv->band == IEEE80211_BAND_5GHZ) ? 0 : 1;
-	ch_info = iwl_get_channel_info(priv,
-				       priv->band,
-				       le16_to_cpu(priv->active_rxon.channel));
+	ch_info = iwl_get_channel_info(priv, priv->band, chan);
 	if (!ch_info) {
 		IWL_ERR(priv,
 			"Failed to get channel info for channel %d [%d]\n",
-			le16_to_cpu(priv->active_rxon.channel), priv->band);
+			chan, priv->band);
 		return -EINVAL;
 	}
 
@@ -1710,7 +1711,8 @@ int iwl3945_hw_reg_set_txpower(struct iwl_priv *priv, s8 power)
 	return 0;
 }
 
-static int iwl3945_send_rxon_assoc(struct iwl_priv *priv)
+static int iwl3945_send_rxon_assoc(struct iwl_priv *priv,
+				   struct iwl_rxon_context *ctx)
 {
 	int rc = 0;
 	struct iwl_rx_packet *pkt;
@@ -1721,8 +1723,8 @@ static int iwl3945_send_rxon_assoc(struct iwl_priv *priv)
 		.flags = CMD_WANT_SKB,
 		.data = &rxon_assoc,
 	};
-	const struct iwl_rxon_cmd *rxon1 = &priv->staging_rxon;
-	const struct iwl_rxon_cmd *rxon2 = &priv->active_rxon;
+	const struct iwl_rxon_cmd *rxon1 = &ctx->staging;
+	const struct iwl_rxon_cmd *rxon2 = &ctx->active;
 
 	if ((rxon1->flags == rxon2->flags) &&
 	    (rxon1->filter_flags == rxon2->filter_flags) &&
@@ -1732,10 +1734,10 @@ static int iwl3945_send_rxon_assoc(struct iwl_priv *priv)
 		return 0;
 	}
 
-	rxon_assoc.flags = priv->staging_rxon.flags;
-	rxon_assoc.filter_flags = priv->staging_rxon.filter_flags;
-	rxon_assoc.ofdm_basic_rates = priv->staging_rxon.ofdm_basic_rates;
-	rxon_assoc.cck_basic_rates = priv->staging_rxon.cck_basic_rates;
+	rxon_assoc.flags = ctx->staging.flags;
+	rxon_assoc.filter_flags = ctx->staging.filter_flags;
+	rxon_assoc.ofdm_basic_rates = ctx->staging.ofdm_basic_rates;
+	rxon_assoc.cck_basic_rates = ctx->staging.cck_basic_rates;
 	rxon_assoc.reserved = 0;
 
 	rc = iwl_send_cmd_sync(priv, &cmd);
@@ -1761,14 +1763,14 @@ static int iwl3945_send_rxon_assoc(struct iwl_priv *priv)
  * function correctly transitions out of the RXON_ASSOC_MSK state if
  * a HW tune is required based on the RXON structure changes.
  */
-static int iwl3945_commit_rxon(struct iwl_priv *priv)
+static int iwl3945_commit_rxon(struct iwl_priv *priv,
+			       struct iwl_rxon_context *ctx)
 {
 	/* cast away the const for active_rxon in this function */
-	struct iwl3945_rxon_cmd *active_rxon = (void *)&priv->active_rxon;
-	struct iwl3945_rxon_cmd *staging_rxon = (void *)&priv->staging_rxon;
+	struct iwl3945_rxon_cmd *active_rxon = (void *)&ctx->active;
+	struct iwl3945_rxon_cmd *staging_rxon = (void *)&ctx->staging;
 	int rc = 0;
-	bool new_assoc =
-		!!(priv->staging_rxon.filter_flags & RXON_FILTER_ASSOC_MSK);
+	bool new_assoc = !!(staging_rxon->filter_flags & RXON_FILTER_ASSOC_MSK);
 
 	if (!iwl_is_alive(priv))
 		return -1;
@@ -1781,7 +1783,7 @@ static int iwl3945_commit_rxon(struct iwl_priv *priv)
 	    ~(RXON_FLG_DIS_DIV_MSK | RXON_FLG_ANT_SEL_MSK);
 	staging_rxon->flags |= iwl3945_get_antenna_flags(priv);
 
-	rc = iwl_check_rxon_cmd(priv);
+	rc = iwl_check_rxon_cmd(priv, ctx);
 	if (rc) {
 		IWL_ERR(priv, "Invalid RXON configuration.  Not committing.\n");
 		return -EINVAL;
@@ -1790,8 +1792,9 @@ static int iwl3945_commit_rxon(struct iwl_priv *priv)
 	/* If we don't need to send a full RXON, we can use
 	 * iwl3945_rxon_assoc_cmd which is used to reconfigure filter
 	 * and other flags for the current radio configuration. */
-	if (!iwl_full_rxon_required(priv)) {
-		rc = iwl_send_rxon_assoc(priv);
+	if (!iwl_full_rxon_required(priv, &priv->contexts[IWL_RXON_CTX_BSS])) {
+		rc = iwl_send_rxon_assoc(priv,
+					 &priv->contexts[IWL_RXON_CTX_BSS]);
 		if (rc) {
 			IWL_ERR(priv, "Error setting RXON_ASSOC "
 				  "configuration (%d).\n", rc);
@@ -1807,7 +1810,7 @@ static int iwl3945_commit_rxon(struct iwl_priv *priv)
 	 * an RXON_ASSOC and the new config wants the associated mask enabled,
 	 * we must clear the associated from the active configuration
 	 * before we apply the new config */
-	if (iwl_is_associated(priv) && new_assoc) {
+	if (iwl_is_associated(priv, IWL_RXON_CTX_BSS) && new_assoc) {
 		IWL_DEBUG_INFO(priv, "Toggling associated bit on current RXON\n");
 		active_rxon->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 
@@ -1819,7 +1822,7 @@ static int iwl3945_commit_rxon(struct iwl_priv *priv)
 		active_rxon->reserved5 = 0;
 		rc = iwl_send_cmd_pdu(priv, REPLY_RXON,
 				      sizeof(struct iwl3945_rxon_cmd),
-				      &priv->active_rxon);
+				      &priv->contexts[IWL_RXON_CTX_BSS].active);
 
 		/* If the mask clearing failed then we set
 		 * active_rxon back to what it was previously */
@@ -1848,7 +1851,7 @@ static int iwl3945_commit_rxon(struct iwl_priv *priv)
 	staging_rxon->reserved4 = 0;
 	staging_rxon->reserved5 = 0;
 
-	iwl_set_rxon_hwcrypto(priv, !iwl3945_mod_params.sw_crypto);
+	iwl_set_rxon_hwcrypto(priv, ctx, !iwl3945_mod_params.sw_crypto);
 
 	/* Apply the new configuration */
 	rc = iwl_send_cmd_pdu(priv, REPLY_RXON,
@@ -2366,7 +2369,7 @@ int iwl3945_init_hw_rate_table(struct iwl_priv *priv)
 		 * 1M CCK rates */
 
 		if (!(priv->_3945.sta_supp_rates & IWL_OFDM_RATES_MASK) &&
-		    iwl_is_associated(priv)) {
+		    iwl_is_associated(priv, IWL_RXON_CTX_BSS)) {
 
 			index = IWL_FIRST_CCK_RATE;
 			for (i = IWL_RATE_6M_INDEX_TABLE;
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index f0a47f4..82f3230 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -347,7 +347,7 @@ static void iwl4965_chain_noise_reset(struct iwl_priv *priv)
 	struct iwl_chain_noise_data *data = &(priv->chain_noise_data);
 
 	if ((data->state == IWL_CHAIN_NOISE_ALIVE) &&
-	     iwl_is_associated(priv)) {
+	    iwl_is_any_associated(priv)) {
 		struct iwl_calib_diff_gain_cmd cmd;
 
 		/* clear data for chain noise calibration algorithm */
@@ -1374,6 +1374,7 @@ static int iwl4965_send_tx_power(struct iwl_priv *priv)
 	u8 band = 0;
 	bool is_ht40 = false;
 	u8 ctrl_chan_high = 0;
+	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 
 	if (test_bit(STATUS_SCANNING, &priv->status)) {
 		/* If this gets hit a lot, switch it to a BUG() and catch
@@ -1385,17 +1386,16 @@ static int iwl4965_send_tx_power(struct iwl_priv *priv)
 
 	band = priv->band == IEEE80211_BAND_2GHZ;
 
-	is_ht40 =  is_ht40_channel(priv->active_rxon.flags);
+	is_ht40 = is_ht40_channel(ctx->active.flags);
 
-	if (is_ht40 &&
-	    (priv->active_rxon.flags & RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK))
+	if (is_ht40 && (ctx->active.flags & RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK))
 		ctrl_chan_high = 1;
 
 	cmd.band = band;
-	cmd.channel = priv->active_rxon.channel;
+	cmd.channel = ctx->active.channel;
 
 	ret = iwl4965_fill_txpower_tbl(priv, band,
-				le16_to_cpu(priv->active_rxon.channel),
+				le16_to_cpu(ctx->active.channel),
 				is_ht40, ctrl_chan_high, &cmd.tx_power);
 	if (ret)
 		goto out;
@@ -1406,12 +1406,13 @@ out:
 	return ret;
 }
 
-static int iwl4965_send_rxon_assoc(struct iwl_priv *priv)
+static int iwl4965_send_rxon_assoc(struct iwl_priv *priv,
+				   struct iwl_rxon_context *ctx)
 {
 	int ret = 0;
 	struct iwl4965_rxon_assoc_cmd rxon_assoc;
-	const struct iwl_rxon_cmd *rxon1 = &priv->staging_rxon;
-	const struct iwl_rxon_cmd *rxon2 = &priv->active_rxon;
+	const struct iwl_rxon_cmd *rxon1 = &ctx->staging;
+	const struct iwl_rxon_cmd *rxon2 = &ctx->active;
 
 	if ((rxon1->flags == rxon2->flags) &&
 	    (rxon1->filter_flags == rxon2->filter_flags) &&
@@ -1426,16 +1427,16 @@ static int iwl4965_send_rxon_assoc(struct iwl_priv *priv)
 		return 0;
 	}
 
-	rxon_assoc.flags = priv->staging_rxon.flags;
-	rxon_assoc.filter_flags = priv->staging_rxon.filter_flags;
-	rxon_assoc.ofdm_basic_rates = priv->staging_rxon.ofdm_basic_rates;
-	rxon_assoc.cck_basic_rates = priv->staging_rxon.cck_basic_rates;
+	rxon_assoc.flags = ctx->staging.flags;
+	rxon_assoc.filter_flags = ctx->staging.filter_flags;
+	rxon_assoc.ofdm_basic_rates = ctx->staging.ofdm_basic_rates;
+	rxon_assoc.cck_basic_rates = ctx->staging.cck_basic_rates;
 	rxon_assoc.reserved = 0;
 	rxon_assoc.ofdm_ht_single_stream_basic_rates =
-	    priv->staging_rxon.ofdm_ht_single_stream_basic_rates;
+	    ctx->staging.ofdm_ht_single_stream_basic_rates;
 	rxon_assoc.ofdm_ht_dual_stream_basic_rates =
-	    priv->staging_rxon.ofdm_ht_dual_stream_basic_rates;
-	rxon_assoc.rx_chain_select_flags = priv->staging_rxon.rx_chain;
+	    ctx->staging.ofdm_ht_dual_stream_basic_rates;
+	rxon_assoc.rx_chain_select_flags = ctx->staging.rx_chain;
 
 	ret = iwl_send_cmd_pdu_async(priv, REPLY_RXON_ASSOC,
 				     sizeof(rxon_assoc), &rxon_assoc, NULL);
@@ -1448,6 +1449,7 @@ static int iwl4965_send_rxon_assoc(struct iwl_priv *priv)
 static int iwl4965_hw_channel_switch(struct iwl_priv *priv,
 				     struct ieee80211_channel_switch *ch_switch)
 {
+	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 	int rc;
 	u8 band = 0;
 	bool is_ht40 = false;
@@ -1458,22 +1460,22 @@ static int iwl4965_hw_channel_switch(struct iwl_priv *priv,
 	u16 ch;
 	u32 tsf_low;
 	u8 switch_count;
-	u16 beacon_interval = le16_to_cpu(priv->rxon_timing.beacon_interval);
+	u16 beacon_interval = le16_to_cpu(ctx->timing.beacon_interval);
 	struct ieee80211_vif *vif = priv->vif;
 	band = priv->band == IEEE80211_BAND_2GHZ;
 
-	is_ht40 = is_ht40_channel(priv->staging_rxon.flags);
+	is_ht40 = is_ht40_channel(ctx->staging.flags);
 
 	if (is_ht40 &&
-	    (priv->staging_rxon.flags & RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK))
+	    (ctx->staging.flags & RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK))
 		ctrl_chan_high = 1;
 
 	cmd.band = band;
 	cmd.expect_beacon = 0;
 	ch = ch_switch->channel->hw_value;
 	cmd.channel = cpu_to_le16(ch);
-	cmd.rxon_flags = priv->staging_rxon.flags;
-	cmd.rxon_filter_flags = priv->staging_rxon.filter_flags;
+	cmd.rxon_flags = ctx->staging.flags;
+	cmd.rxon_filter_flags = ctx->staging.filter_flags;
 	switch_count = ch_switch->count;
 	tsf_low = ch_switch->timestamp & 0x0ffffffff;
 	/*
@@ -1508,7 +1510,7 @@ static int iwl4965_hw_channel_switch(struct iwl_priv *priv,
 		cmd.expect_beacon = is_channel_radar(ch_info);
 	else {
 		IWL_ERR(priv, "invalid channel switch from %u to %u\n",
-			priv->active_rxon.channel, ch);
+			ctx->active.channel, ch);
 		return -EFAULT;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 013f3da..8536f19 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -275,13 +275,18 @@ static void iwl5150_temperature(struct iwl_priv *priv)
 static int iwl5000_hw_channel_switch(struct iwl_priv *priv,
 				     struct ieee80211_channel_switch *ch_switch)
 {
+	/*
+	 * MULTI-FIXME
+	 * See iwl_mac_channel_switch.
+	 */
+	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 	struct iwl5000_channel_switch_cmd cmd;
 	const struct iwl_channel_info *ch_info;
 	u32 switch_time_in_usec, ucode_switch_time;
 	u16 ch;
 	u32 tsf_low;
 	u8 switch_count;
-	u16 beacon_interval = le16_to_cpu(priv->rxon_timing.beacon_interval);
+	u16 beacon_interval = le16_to_cpu(ctx->timing.beacon_interval);
 	struct ieee80211_vif *vif = priv->vif;
 	struct iwl_host_cmd hcmd = {
 		.id = REPLY_CHANNEL_SWITCH,
@@ -293,10 +298,10 @@ static int iwl5000_hw_channel_switch(struct iwl_priv *priv,
 	cmd.band = priv->band == IEEE80211_BAND_2GHZ;
 	ch = ch_switch->channel->hw_value;
 	IWL_DEBUG_11H(priv, "channel switch from %d to %d\n",
-		priv->active_rxon.channel, ch);
+		      ctx->active.channel, ch);
 	cmd.channel = cpu_to_le16(ch);
-	cmd.rxon_flags = priv->staging_rxon.flags;
-	cmd.rxon_filter_flags = priv->staging_rxon.filter_flags;
+	cmd.rxon_flags = ctx->staging.flags;
+	cmd.rxon_filter_flags = ctx->staging.filter_flags;
 	switch_count = ch_switch->count;
 	tsf_low = ch_switch->timestamp & 0x0ffffffff;
 	/*
@@ -331,7 +336,7 @@ static int iwl5000_hw_channel_switch(struct iwl_priv *priv,
 		cmd.expect_beacon = is_channel_radar(ch_info);
 	else {
 		IWL_ERR(priv, "invalid channel switch from %u to %u\n",
-			priv->active_rxon.channel, ch);
+			ctx->active.channel, ch);
 		return -EFAULT;
 	}
 	priv->switch_rxon.channel = cmd.channel;
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index fc9344b..bf1fe25 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -198,13 +198,18 @@ static int iwl6000_hw_set_hw_params(struct iwl_priv *priv)
 static int iwl6000_hw_channel_switch(struct iwl_priv *priv,
 				     struct ieee80211_channel_switch *ch_switch)
 {
+	/*
+	 * MULTI-FIXME
+	 * See iwl_mac_channel_switch.
+	 */
+	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 	struct iwl6000_channel_switch_cmd cmd;
 	const struct iwl_channel_info *ch_info;
 	u32 switch_time_in_usec, ucode_switch_time;
 	u16 ch;
 	u32 tsf_low;
 	u8 switch_count;
-	u16 beacon_interval = le16_to_cpu(priv->rxon_timing.beacon_interval);
+	u16 beacon_interval = le16_to_cpu(ctx->timing.beacon_interval);
 	struct ieee80211_vif *vif = priv->vif;
 	struct iwl_host_cmd hcmd = {
 		.id = REPLY_CHANNEL_SWITCH,
@@ -216,10 +221,10 @@ static int iwl6000_hw_channel_switch(struct iwl_priv *priv,
 	cmd.band = priv->band == IEEE80211_BAND_2GHZ;
 	ch = ch_switch->channel->hw_value;
 	IWL_DEBUG_11H(priv, "channel switch from %u to %u\n",
-		      priv->active_rxon.channel, ch);
+		      ctx->active.channel, ch);
 	cmd.channel = cpu_to_le16(ch);
-	cmd.rxon_flags = priv->staging_rxon.flags;
-	cmd.rxon_filter_flags = priv->staging_rxon.filter_flags;
+	cmd.rxon_flags = ctx->staging.flags;
+	cmd.rxon_filter_flags = ctx->staging.filter_flags;
 	switch_count = ch_switch->count;
 	tsf_low = ch_switch->timestamp & 0x0ffffffff;
 	/*
@@ -254,7 +259,7 @@ static int iwl6000_hw_channel_switch(struct iwl_priv *priv,
 		cmd.expect_beacon = is_channel_radar(ch_info);
 	else {
 		IWL_ERR(priv, "invalid channel switch from %u to %u\n",
-			priv->active_rxon.channel, ch);
+			ctx->active.channel, ch);
 		return -EFAULT;
 	}
 	priv->switch_rxon.channel = cmd.channel;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
index 156b125..84ad629 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
@@ -625,7 +625,7 @@ void iwl_sensitivity_calibration(struct iwl_priv *priv, void *resp)
 
 	data = &(priv->sensitivity_data);
 
-	if (!iwl_is_associated(priv)) {
+	if (!iwl_is_any_associated(priv)) {
 		IWL_DEBUG_CALIB(priv, "<< - not associated\n");
 		return;
 	}
@@ -763,6 +763,12 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv, void *stat_resp)
 	unsigned long flags;
 	struct statistics_rx_non_phy *rx_info;
 	u8 first_chain;
+	/*
+	 * MULTI-FIXME:
+	 * When we support multiple interfaces on different channels,
+	 * this must be modified/fixed.
+	 */
+	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 
 	if (priv->disable_chain_noise_cal)
 		return;
@@ -793,8 +799,8 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv, void *stat_resp)
 		return;
 	}
 
-	rxon_band24 = !!(priv->staging_rxon.flags & RXON_FLG_BAND_24G_MSK);
-	rxon_chnum = le16_to_cpu(priv->staging_rxon.channel);
+	rxon_band24 = !!(ctx->staging.flags & RXON_FLG_BAND_24G_MSK);
+	rxon_chnum = le16_to_cpu(ctx->staging.channel);
 	if (priv->cfg->bt_statistics) {
 		stat_band24 = !!(((struct iwl_bt_notif_statistics *)
 				 stat_resp)->flag &
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
index 84fe06a..3e50699 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
@@ -37,12 +37,13 @@
 #include "iwl-io.h"
 #include "iwl-agn.h"
 
-int iwlagn_send_rxon_assoc(struct iwl_priv *priv)
+int iwlagn_send_rxon_assoc(struct iwl_priv *priv,
+			   struct iwl_rxon_context *ctx)
 {
 	int ret = 0;
 	struct iwl5000_rxon_assoc_cmd rxon_assoc;
-	const struct iwl_rxon_cmd *rxon1 = &priv->staging_rxon;
-	const struct iwl_rxon_cmd *rxon2 = &priv->active_rxon;
+	const struct iwl_rxon_cmd *rxon1 = &ctx->staging;
+	const struct iwl_rxon_cmd *rxon2 = &ctx->active;
 
 	if ((rxon1->flags == rxon2->flags) &&
 	    (rxon1->filter_flags == rxon2->filter_flags) &&
@@ -60,21 +61,21 @@ int iwlagn_send_rxon_assoc(struct iwl_priv *priv)
 		return 0;
 	}
 
-	rxon_assoc.flags = priv->staging_rxon.flags;
-	rxon_assoc.filter_flags = priv->staging_rxon.filter_flags;
-	rxon_assoc.ofdm_basic_rates = priv->staging_rxon.ofdm_basic_rates;
-	rxon_assoc.cck_basic_rates = priv->staging_rxon.cck_basic_rates;
+	rxon_assoc.flags = ctx->staging.flags;
+	rxon_assoc.filter_flags = ctx->staging.filter_flags;
+	rxon_assoc.ofdm_basic_rates = ctx->staging.ofdm_basic_rates;
+	rxon_assoc.cck_basic_rates = ctx->staging.cck_basic_rates;
 	rxon_assoc.reserved1 = 0;
 	rxon_assoc.reserved2 = 0;
 	rxon_assoc.reserved3 = 0;
 	rxon_assoc.ofdm_ht_single_stream_basic_rates =
-	    priv->staging_rxon.ofdm_ht_single_stream_basic_rates;
+	    ctx->staging.ofdm_ht_single_stream_basic_rates;
 	rxon_assoc.ofdm_ht_dual_stream_basic_rates =
-	    priv->staging_rxon.ofdm_ht_dual_stream_basic_rates;
-	rxon_assoc.rx_chain_select_flags = priv->staging_rxon.rx_chain;
+	    ctx->staging.ofdm_ht_dual_stream_basic_rates;
+	rxon_assoc.rx_chain_select_flags = ctx->staging.rx_chain;
 	rxon_assoc.ofdm_ht_triple_stream_basic_rates =
-		 priv->staging_rxon.ofdm_ht_triple_stream_basic_rates;
-	rxon_assoc.acquisition_data = priv->staging_rxon.acquisition_data;
+		 ctx->staging.ofdm_ht_triple_stream_basic_rates;
+	rxon_assoc.acquisition_data = ctx->staging.acquisition_data;
 
 	ret = iwl_send_cmd_pdu_async(priv, REPLY_RXON_ASSOC,
 				     sizeof(rxon_assoc), &rxon_assoc, NULL);
@@ -184,7 +185,7 @@ static void iwlagn_chain_noise_reset(struct iwl_priv *priv)
 	int ret;
 
 	if ((data->state == IWL_CHAIN_NOISE_ALIVE) &&
-	     iwl_is_associated(priv)) {
+	    iwl_is_any_associated(priv)) {
 		struct iwl_calib_chain_noise_reset_cmd cmd;
 
 		/* clear data for chain noise calibration algorithm */
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index a9e69a6..531a7dc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1232,7 +1232,7 @@ void iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	scan->quiet_plcp_th = IWL_PLCP_QUIET_THRESH;
 	scan->quiet_time = IWL_ACTIVE_QUIET_TIME;
 
-	if (iwl_is_associated(priv)) {
+	if (iwl_is_any_associated(priv)) {
 		u16 interval = 0;
 		u32 extra;
 		u32 suspend_time = 100;
@@ -1289,7 +1289,9 @@ void iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	switch (priv->scan_band) {
 	case IEEE80211_BAND_2GHZ:
 		scan->flags = RXON_FLG_BAND_24G_MSK | RXON_FLG_AUTO_DETECT_MSK;
-		chan_mod = le32_to_cpu(priv->active_rxon.flags & RXON_FLG_CHANNEL_MODE_MSK)
+		chan_mod = le32_to_cpu(
+			priv->contexts[IWL_RXON_CTX_BSS].active.flags &
+						RXON_FLG_CHANNEL_MODE_MSK)
 				       >> RXON_FLG_CHANNEL_MODE_POS;
 		if (chan_mod == CHANNEL_MODE_PURE_40) {
 			rate = IWL_RATE_6M_PLCP;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tt.c b/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
index 30298ea..07b2c6c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
@@ -416,18 +416,26 @@ static void iwl_advance_tt_handler(struct iwl_priv *priv, s32 temp, bool force)
 	/* stop ct_kill_waiting_tm timer */
 	del_timer_sync(&priv->thermal_throttle.ct_kill_waiting_tm);
 	if (changed) {
-		struct iwl_rxon_cmd *rxon = &priv->staging_rxon;
-
 		if (tt->state >= IWL_TI_1) {
 			/* force PI = IWL_POWER_INDEX_5 in the case of TI > 0 */
 			tt->tt_power_mode = IWL_POWER_INDEX_5;
-			if (!iwl_ht_enabled(priv))
-				/* disable HT */
-				rxon->flags &= ~(RXON_FLG_CHANNEL_MODE_MSK |
-					RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK |
-					RXON_FLG_HT40_PROT_MSK |
-					RXON_FLG_HT_PROT_MSK);
-			else {
+
+			if (!iwl_ht_enabled(priv)) {
+				struct iwl_rxon_context *ctx;
+
+				for_each_context(priv, ctx) {
+					struct iwl_rxon_cmd *rxon;
+
+					rxon = &ctx->staging;
+
+					/* disable HT */
+					rxon->flags &= ~(
+						RXON_FLG_CHANNEL_MODE_MSK |
+						RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK |
+						RXON_FLG_HT40_PROT_MSK |
+						RXON_FLG_HT_PROT_MSK);
+				}
+			} else {
 				/* check HT capability and set
 				 * according to the system HT capability
 				 * in case get disabled before */
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 5e0d0d5..e073069 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -98,21 +98,21 @@ static bool iwlagn_bt_ch_announce = 1;
  * function correctly transitions out of the RXON_ASSOC_MSK state if
  * a HW tune is required based on the RXON structure changes.
  */
-int iwl_commit_rxon(struct iwl_priv *priv)
+int iwl_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 {
 	/* cast away the const for active_rxon in this function */
-	struct iwl_rxon_cmd *active_rxon = (void *)&priv->active_rxon;
+	struct iwl_rxon_cmd *active_rxon = (void *)&ctx->active;
 	int ret;
 	bool new_assoc =
-		!!(priv->staging_rxon.filter_flags & RXON_FILTER_ASSOC_MSK);
+		!!(ctx->staging.filter_flags & RXON_FILTER_ASSOC_MSK);
 
 	if (!iwl_is_alive(priv))
 		return -EBUSY;
 
 	/* always get timestamp with Rx frame */
-	priv->staging_rxon.flags |= RXON_FLG_TSF2HOST_MSK;
+	ctx->staging.flags |= RXON_FLG_TSF2HOST_MSK;
 
-	ret = iwl_check_rxon_cmd(priv);
+	ret = iwl_check_rxon_cmd(priv, ctx);
 	if (ret) {
 		IWL_ERR(priv, "Invalid RXON configuration.  Not committing.\n");
 		return -EINVAL;
@@ -123,7 +123,7 @@ int iwl_commit_rxon(struct iwl_priv *priv)
 	 * abort any previous channel switch if still in process
 	 */
 	if (priv->switch_rxon.switch_in_progress &&
-	    (priv->switch_rxon.channel != priv->staging_rxon.channel)) {
+	    (priv->switch_rxon.channel != ctx->staging.channel)) {
 		IWL_DEBUG_11H(priv, "abort channel switch on %d\n",
 		      le16_to_cpu(priv->switch_rxon.channel));
 		iwl_chswitch_done(priv, false);
@@ -132,15 +132,15 @@ int iwl_commit_rxon(struct iwl_priv *priv)
 	/* If we don't need to send a full RXON, we can use
 	 * iwl_rxon_assoc_cmd which is used to reconfigure filter
 	 * and other flags for the current radio configuration. */
-	if (!iwl_full_rxon_required(priv)) {
-		ret = iwl_send_rxon_assoc(priv);
+	if (!iwl_full_rxon_required(priv, ctx)) {
+		ret = iwl_send_rxon_assoc(priv, ctx);
 		if (ret) {
 			IWL_ERR(priv, "Error setting RXON_ASSOC (%d)\n", ret);
 			return ret;
 		}
 
-		memcpy(active_rxon, &priv->staging_rxon, sizeof(*active_rxon));
-		iwl_print_rx_config_cmd(priv);
+		memcpy(active_rxon, &ctx->staging, sizeof(*active_rxon));
+		iwl_print_rx_config_cmd(priv, ctx);
 		return 0;
 	}
 
@@ -148,13 +148,13 @@ int iwl_commit_rxon(struct iwl_priv *priv)
 	 * an RXON_ASSOC and the new config wants the associated mask enabled,
 	 * we must clear the associated from the active configuration
 	 * before we apply the new config */
-	if (iwl_is_associated(priv) && new_assoc) {
+	if (iwl_is_associated_ctx(ctx) && new_assoc) {
 		IWL_DEBUG_INFO(priv, "Toggling associated bit on current RXON\n");
 		active_rxon->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 
 		ret = iwl_send_cmd_pdu(priv, REPLY_RXON,
-				      sizeof(struct iwl_rxon_cmd),
-				      &priv->active_rxon);
+				       sizeof(struct iwl_rxon_cmd),
+				       active_rxon);
 
 		/* If the mask clearing failed then we set
 		 * active_rxon back to what it was previously */
@@ -177,10 +177,10 @@ int iwl_commit_rxon(struct iwl_priv *priv)
 		       "* channel = %d\n"
 		       "* bssid = %pM\n",
 		       (new_assoc ? "" : "out"),
-		       le16_to_cpu(priv->staging_rxon.channel),
-		       priv->staging_rxon.bssid_addr);
+		       le16_to_cpu(ctx->staging.channel),
+		       ctx->staging.bssid_addr);
 
-	iwl_set_rxon_hwcrypto(priv, !priv->cfg->mod_params->sw_crypto);
+	iwl_set_rxon_hwcrypto(priv, ctx, !priv->cfg->mod_params->sw_crypto);
 
 	/* Apply the new configuration
 	 * RXON unassoc clears the station table in uCode so restoration of
@@ -188,13 +188,13 @@ int iwl_commit_rxon(struct iwl_priv *priv)
 	 */
 	if (!new_assoc) {
 		ret = iwl_send_cmd_pdu(priv, REPLY_RXON,
-			      sizeof(struct iwl_rxon_cmd), &priv->staging_rxon);
+			      sizeof(struct iwl_rxon_cmd), &ctx->staging);
 		if (ret) {
 			IWL_ERR(priv, "Error setting new RXON (%d)\n", ret);
 			return ret;
 		}
 		IWL_DEBUG_INFO(priv, "Return from !new_assoc RXON.\n");
-		memcpy(active_rxon, &priv->staging_rxon, sizeof(*active_rxon));
+		memcpy(active_rxon, &ctx->staging, sizeof(*active_rxon));
 		iwl_clear_ucode_stations(priv);
 		iwl_restore_stations(priv);
 		ret = iwl_restore_default_wep_keys(priv);
@@ -210,14 +210,14 @@ int iwl_commit_rxon(struct iwl_priv *priv)
 		 * RXON assoc doesn't clear the station table in uCode,
 		 */
 		ret = iwl_send_cmd_pdu(priv, REPLY_RXON,
-			      sizeof(struct iwl_rxon_cmd), &priv->staging_rxon);
+			      sizeof(struct iwl_rxon_cmd), &ctx->staging);
 		if (ret) {
 			IWL_ERR(priv, "Error setting new RXON (%d)\n", ret);
 			return ret;
 		}
-		memcpy(active_rxon, &priv->staging_rxon, sizeof(*active_rxon));
+		memcpy(active_rxon, &ctx->staging, sizeof(*active_rxon));
 	}
-	iwl_print_rx_config_cmd(priv);
+	iwl_print_rx_config_cmd(priv, ctx);
 
 	iwl_init_sensitivity(priv);
 
@@ -234,10 +234,14 @@ int iwl_commit_rxon(struct iwl_priv *priv)
 
 void iwl_update_chain_flags(struct iwl_priv *priv)
 {
+	struct iwl_rxon_context *ctx;
 
-	if (priv->cfg->ops->hcmd->set_rxon_chain)
-		priv->cfg->ops->hcmd->set_rxon_chain(priv);
-	iwlcore_commit_rxon(priv);
+	if (priv->cfg->ops->hcmd->set_rxon_chain) {
+		for_each_context(priv, ctx) {
+			priv->cfg->ops->hcmd->set_rxon_chain(priv, ctx);
+			iwlcore_commit_rxon(priv, ctx);
+		}
+	}
 }
 
 static void iwl_clear_free_frames(struct iwl_priv *priv)
@@ -633,6 +637,7 @@ static void iwl_bg_bt_full_concurrency(struct work_struct *work)
 {
 	struct iwl_priv *priv =
 		container_of(work, struct iwl_priv, bt_full_concurrency);
+	struct iwl_rxon_context *ctx;
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
@@ -649,9 +654,13 @@ static void iwl_bg_bt_full_concurrency(struct work_struct *work)
 	 * LQ & RXON updated cmds must be sent before BT Config cmd
 	 * to avoid 3-wire collisions
 	 */
-	if (priv->cfg->ops->hcmd->set_rxon_chain)
-		priv->cfg->ops->hcmd->set_rxon_chain(priv);
-	iwlcore_commit_rxon(priv);
+	mutex_lock(&priv->mutex);
+	for_each_context(priv, ctx) {
+		if (priv->cfg->ops->hcmd->set_rxon_chain)
+			priv->cfg->ops->hcmd->set_rxon_chain(priv, ctx);
+		iwlcore_commit_rxon(priv, ctx);
+	}
+	mutex_unlock(&priv->mutex);
 
 	priv->cfg->ops->hcmd->send_bt_config(priv);
 }
@@ -2710,6 +2719,7 @@ static void iwl_rf_kill_ct_config(struct iwl_priv *priv)
 static void iwl_alive_start(struct iwl_priv *priv)
 {
 	int ret = 0;
+	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 
 	IWL_DEBUG_INFO(priv, "Runtime Alive received.\n");
 
@@ -2758,18 +2768,18 @@ static void iwl_alive_start(struct iwl_priv *priv)
 	if (priv->cfg->ops->hcmd->set_tx_ant)
 		priv->cfg->ops->hcmd->set_tx_ant(priv, priv->cfg->valid_tx_ant);
 
-	if (iwl_is_associated(priv)) {
+	if (iwl_is_associated_ctx(ctx)) {
 		struct iwl_rxon_cmd *active_rxon =
-				(struct iwl_rxon_cmd *)&priv->active_rxon;
+				(struct iwl_rxon_cmd *)&ctx->active;
 		/* apply any changes in staging */
-		priv->staging_rxon.filter_flags |= RXON_FILTER_ASSOC_MSK;
+		ctx->staging.filter_flags |= RXON_FILTER_ASSOC_MSK;
 		active_rxon->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 	} else {
 		/* Initialize our rx_config data */
 		iwl_connection_init_rx_config(priv, NULL);
 
 		if (priv->cfg->ops->hcmd->set_rxon_chain)
-			priv->cfg->ops->hcmd->set_rxon_chain(priv);
+			priv->cfg->ops->hcmd->set_rxon_chain(priv, ctx);
 	}
 
 	if (!priv->cfg->advanced_bt_coexist) {
@@ -2780,7 +2790,7 @@ static void iwl_alive_start(struct iwl_priv *priv)
 	iwl_reset_run_time_calib(priv);
 
 	/* Configure the adapter for unassociated operation */
-	iwlcore_commit_rxon(priv);
+	iwlcore_commit_rxon(priv, ctx);
 
 	/* At this point, the NIC is initialized and operational */
 	iwl_rf_kill_ct_config(priv);
@@ -3195,12 +3205,15 @@ static void iwl_bg_rx_replenish(struct work_struct *data)
 
 void iwl_post_associate(struct iwl_priv *priv, struct ieee80211_vif *vif)
 {
+	struct iwl_rxon_context *ctx;
 	struct ieee80211_conf *conf = NULL;
 	int ret = 0;
 
 	if (!vif || !priv->is_open)
 		return;
 
+	ctx = iwl_rxon_ctx_from_vif(vif);
+
 	if (vif->type == NL80211_IFTYPE_AP) {
 		IWL_ERR(priv, "%s Should not be called in AP mode\n", __func__);
 		return;
@@ -3213,42 +3226,42 @@ void iwl_post_associate(struct iwl_priv *priv, struct ieee80211_vif *vif)
 
 	conf = ieee80211_get_hw_conf(priv->hw);
 
-	priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-	iwlcore_commit_rxon(priv);
+	ctx->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
+	iwlcore_commit_rxon(priv, ctx);
 
 	ret = iwl_send_rxon_timing(priv, vif);
 	if (ret)
 		IWL_WARN(priv, "REPLY_RXON_TIMING failed - "
 			    "Attempting to continue.\n");
 
-	priv->staging_rxon.filter_flags |= RXON_FILTER_ASSOC_MSK;
+	ctx->staging.filter_flags |= RXON_FILTER_ASSOC_MSK;
 
 	iwl_set_rxon_ht(priv, &priv->current_ht_config);
 
 	if (priv->cfg->ops->hcmd->set_rxon_chain)
-		priv->cfg->ops->hcmd->set_rxon_chain(priv);
+		priv->cfg->ops->hcmd->set_rxon_chain(priv, ctx);
 
-	priv->staging_rxon.assoc_id = cpu_to_le16(vif->bss_conf.aid);
+	ctx->staging.assoc_id = cpu_to_le16(vif->bss_conf.aid);
 
 	IWL_DEBUG_ASSOC(priv, "assoc id %d beacon interval %d\n",
 			vif->bss_conf.aid, vif->bss_conf.beacon_int);
 
 	if (vif->bss_conf.use_short_preamble)
-		priv->staging_rxon.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
+		ctx->staging.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
 	else
-		priv->staging_rxon.flags &= ~RXON_FLG_SHORT_PREAMBLE_MSK;
+		ctx->staging.flags &= ~RXON_FLG_SHORT_PREAMBLE_MSK;
 
-	if (priv->staging_rxon.flags & RXON_FLG_BAND_24G_MSK) {
+	if (ctx->staging.flags & RXON_FLG_BAND_24G_MSK) {
 		if (vif->bss_conf.use_short_slot)
-			priv->staging_rxon.flags |= RXON_FLG_SHORT_SLOT_MSK;
+			ctx->staging.flags |= RXON_FLG_SHORT_SLOT_MSK;
 		else
-			priv->staging_rxon.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
+			ctx->staging.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
 	}
 
-	iwlcore_commit_rxon(priv);
+	iwlcore_commit_rxon(priv, ctx);
 
 	IWL_DEBUG_ASSOC(priv, "Associated as %d to: %pM\n",
-			vif->bss_conf.aid, priv->active_rxon.bssid_addr);
+			vif->bss_conf.aid, ctx->active.bssid_addr);
 
 	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
@@ -3439,17 +3452,18 @@ static int iwl_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 void iwl_config_ap(struct iwl_priv *priv, struct ieee80211_vif *vif)
 {
+	struct iwl_rxon_context *ctx = iwl_rxon_ctx_from_vif(vif);
 	int ret = 0;
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
 	/* The following should be done only at AP bring up */
-	if (!iwl_is_associated(priv)) {
+	if (!iwl_is_associated_ctx(ctx)) {
 
 		/* RXON - unassoc (to set timing command) */
-		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-		iwlcore_commit_rxon(priv);
+		ctx->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
+		iwlcore_commit_rxon(priv, ctx);
 
 		/* RXON Timing */
 		ret = iwl_send_rxon_timing(priv, vif);
@@ -3462,28 +3476,28 @@ void iwl_config_ap(struct iwl_priv *priv, struct ieee80211_vif *vif)
 			priv->hw_params.valid_rx_ant;
 		iwl_set_rxon_ht(priv, &priv->current_ht_config);
 		if (priv->cfg->ops->hcmd->set_rxon_chain)
-			priv->cfg->ops->hcmd->set_rxon_chain(priv);
+			priv->cfg->ops->hcmd->set_rxon_chain(priv, ctx);
 
-		priv->staging_rxon.assoc_id = 0;
+		ctx->staging.assoc_id = 0;
 
 		if (vif->bss_conf.use_short_preamble)
-			priv->staging_rxon.flags |=
+			ctx->staging.flags |=
 				RXON_FLG_SHORT_PREAMBLE_MSK;
 		else
-			priv->staging_rxon.flags &=
+			ctx->staging.flags &=
 				~RXON_FLG_SHORT_PREAMBLE_MSK;
 
-		if (priv->staging_rxon.flags & RXON_FLG_BAND_24G_MSK) {
+		if (ctx->staging.flags & RXON_FLG_BAND_24G_MSK) {
 			if (vif->bss_conf.use_short_slot)
-				priv->staging_rxon.flags |=
+				ctx->staging.flags |=
 					RXON_FLG_SHORT_SLOT_MSK;
 			else
-				priv->staging_rxon.flags &=
+				ctx->staging.flags &=
 					~RXON_FLG_SHORT_SLOT_MSK;
 		}
 		/* restore RXON assoc */
-		priv->staging_rxon.filter_flags |= RXON_FILTER_ASSOC_MSK;
-		iwlcore_commit_rxon(priv);
+		ctx->staging.filter_flags |= RXON_FILTER_ASSOC_MSK;
+		iwlcore_commit_rxon(priv, ctx);
 	}
 	iwl_send_beacon_cmd(priv);
 
@@ -3737,6 +3751,15 @@ static void iwl_mac_channel_switch(struct ieee80211_hw *hw,
 	struct ieee80211_conf *conf = &hw->conf;
 	struct ieee80211_channel *channel = ch_switch->channel;
 	struct iwl_ht_config *ht_conf = &priv->current_ht_config;
+	/*
+	 * MULTI-FIXME
+	 * When we add support for multiple interfaces, we need to
+	 * revisit this. The channel switch command in the device
+	 * only affects the BSS context, but what does that really
+	 * mean? And what if we get a CSA on the second interface?
+	 * This needs a lot of work.
+	 */
+	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 	u16 ch;
 	unsigned long flags = 0;
 
@@ -3749,7 +3772,7 @@ static void iwl_mac_channel_switch(struct ieee80211_hw *hw,
 	    test_bit(STATUS_SCANNING, &priv->status))
 		goto out_exit;
 
-	if (!iwl_is_associated(priv))
+	if (!iwl_is_associated_ctx(ctx))
 		goto out_exit;
 
 	/* channel switch in progress */
@@ -3760,7 +3783,7 @@ static void iwl_mac_channel_switch(struct ieee80211_hw *hw,
 	if (priv->cfg->ops->lib->set_channel_switch) {
 
 		ch = channel->hw_value;
-		if (le16_to_cpu(priv->active_rxon.channel) != ch) {
+		if (le16_to_cpu(ctx->active.channel) != ch) {
 			ch_info = iwl_get_channel_info(priv,
 						       channel->band,
 						       ch);
@@ -3791,12 +3814,12 @@ static void iwl_mac_channel_switch(struct ieee80211_hw *hw,
 			} else
 				ht_conf->is_40mhz = false;
 
-			if (le16_to_cpu(priv->staging_rxon.channel) != ch)
-				priv->staging_rxon.flags = 0;
+			if ((le16_to_cpu(ctx->staging.channel) != ch))
+				ctx->staging.flags = 0;
 
-			iwl_set_rxon_channel(priv, channel);
+			iwl_set_rxon_channel(priv, channel, ctx);
 			iwl_set_rxon_ht(priv, ht_conf);
-			iwl_set_flags_for_band(priv, channel->band,
+			iwl_set_flags_for_band(priv, ctx, channel->band,
 					       priv->vif);
 			spin_unlock_irqrestore(&priv->lock, flags);
 
@@ -3825,6 +3848,7 @@ static void iwlagn_configure_filter(struct ieee80211_hw *hw,
 {
 	struct iwl_priv *priv = hw->priv;
 	__le32 filter_or = 0, filter_nand = 0;
+	struct iwl_rxon_context *ctx;
 
 #define CHK(test, flag)	do { \
 	if (*total_flags & (test))		\
@@ -3844,10 +3868,11 @@ static void iwlagn_configure_filter(struct ieee80211_hw *hw,
 
 	mutex_lock(&priv->mutex);
 
-	priv->staging_rxon.filter_flags &= ~filter_nand;
-	priv->staging_rxon.filter_flags |= filter_or;
-
-	iwlcore_commit_rxon(priv);
+	for_each_context(priv, ctx) {
+		ctx->staging.filter_flags &= ~filter_nand;
+		ctx->staging.filter_flags |= filter_or;
+		iwlcore_commit_rxon(priv, ctx);
+	}
 
 	mutex_unlock(&priv->mutex);
 
@@ -4018,7 +4043,8 @@ static int iwl_init_drv(struct iwl_priv *priv)
 
 	/* Choose which receivers/antennas to use */
 	if (priv->cfg->ops->hcmd->set_rxon_chain)
-		priv->cfg->ops->hcmd->set_rxon_chain(priv);
+		priv->cfg->ops->hcmd->set_rxon_chain(priv,
+					&priv->contexts[IWL_RXON_CTX_BSS]);
 
 	iwl_init_scan_params(priv);
 
@@ -4118,7 +4144,7 @@ static int iwl_set_hw_params(struct iwl_priv *priv)
 
 static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	int err = 0;
+	int err = 0, i;
 	struct iwl_priv *priv;
 	struct ieee80211_hw *hw;
 	struct iwl_cfg *cfg = (struct iwl_cfg *)(ent->driver_data);
@@ -4146,6 +4172,16 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	priv = hw->priv;
 	/* At this point both hw and priv are allocated. */
 
+	/*
+	 * The default context is always valid,
+	 * more may be discovered when firmware
+	 * is loaded.
+	 */
+	priv->valid_contexts = BIT(IWL_RXON_CTX_BSS);
+
+	for (i = 0; i < NUM_IWL_RXON_CTX; i++)
+		priv->contexts[i].ctxid = i;
+
 	SET_IEEE80211_DEV(hw, &pdev->dev);
 
 	IWL_DEBUG_INFO(priv, "*** LOAD DRIVER ***\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 1a7f70f..7c542a8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -224,7 +224,8 @@ int iwlagn_manage_ibss_station(struct iwl_priv *priv,
 			       struct ieee80211_vif *vif, bool add);
 
 /* hcmd */
-int iwlagn_send_rxon_assoc(struct iwl_priv *priv);
+int iwlagn_send_rxon_assoc(struct iwl_priv *priv,
+			   struct iwl_rxon_context *ctx);
 int iwlagn_send_tx_ant_config(struct iwl_priv *priv, u8 valid_tx_ant);
 
 /* bt coex */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index c43124c..cc88401 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -465,6 +465,9 @@ u8 iwl_is_ht40_tx_allowed(struct iwl_priv *priv,
 			 struct ieee80211_sta_ht_cap *sta_ht_inf)
 {
 	struct iwl_ht_config *ht_conf = &priv->current_ht_config;
+#if !TODO
+	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
+#endif
 
 	if (!ht_conf->is_ht || !ht_conf->is_40mhz)
 		return 0;
@@ -481,7 +484,7 @@ u8 iwl_is_ht40_tx_allowed(struct iwl_priv *priv,
 		return 0;
 #endif
 	return iwl_is_channel_extension(priv, priv->band,
-			le16_to_cpu(priv->staging_rxon.channel),
+			le16_to_cpu(ctx->staging.channel),
 			ht_conf->extension_chan_offset);
 }
 EXPORT_SYMBOL(iwl_is_ht40_tx_allowed);
@@ -506,49 +509,51 @@ int iwl_send_rxon_timing(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	s32 interval_tm, rem;
 	struct ieee80211_conf *conf = NULL;
 	u16 beacon_int;
+	struct iwl_rxon_context *ctx = iwl_rxon_ctx_from_vif(vif);
 
 	conf = ieee80211_get_hw_conf(priv->hw);
 
 	lockdep_assert_held(&priv->mutex);
 
-	memset(&priv->rxon_timing, 0, sizeof(struct iwl_rxon_time_cmd));
+	memset(&ctx->timing, 0, sizeof(struct iwl_rxon_time_cmd));
 
-	priv->rxon_timing.timestamp = cpu_to_le64(priv->timestamp);
-	priv->rxon_timing.listen_interval = cpu_to_le16(conf->listen_interval);
+	ctx->timing.timestamp = cpu_to_le64(priv->timestamp);
+	ctx->timing.listen_interval = cpu_to_le16(conf->listen_interval);
 
 	beacon_int = vif->bss_conf.beacon_int;
 
 	if (vif->type == NL80211_IFTYPE_ADHOC) {
 		/* TODO: we need to get atim_window from upper stack
 		 * for now we set to 0 */
-		priv->rxon_timing.atim_window = 0;
+		ctx->timing.atim_window = 0;
 	} else {
-		priv->rxon_timing.atim_window = 0;
+		ctx->timing.atim_window = 0;
 	}
 
 	beacon_int = iwl_adjust_beacon_interval(beacon_int,
 				priv->hw_params.max_beacon_itrvl * TIME_UNIT);
-	priv->rxon_timing.beacon_interval = cpu_to_le16(beacon_int);
+	ctx->timing.beacon_interval = cpu_to_le16(beacon_int);
 
 	tsf = priv->timestamp; /* tsf is modifed by do_div: copy it */
 	interval_tm = beacon_int * TIME_UNIT;
 	rem = do_div(tsf, interval_tm);
-	priv->rxon_timing.beacon_init_val = cpu_to_le32(interval_tm - rem);
+	ctx->timing.beacon_init_val = cpu_to_le32(interval_tm - rem);
 
 	IWL_DEBUG_ASSOC(priv,
 			"beacon interval %d beacon timer %d beacon tim %d\n",
-			le16_to_cpu(priv->rxon_timing.beacon_interval),
-			le32_to_cpu(priv->rxon_timing.beacon_init_val),
-			le16_to_cpu(priv->rxon_timing.atim_window));
+			le16_to_cpu(ctx->timing.beacon_interval),
+			le32_to_cpu(ctx->timing.beacon_init_val),
+			le16_to_cpu(ctx->timing.atim_window));
 
 	return iwl_send_cmd_pdu(priv, REPLY_RXON_TIMING,
-				sizeof(priv->rxon_timing), &priv->rxon_timing);
+				sizeof(ctx->timing), &ctx->timing);
 }
 EXPORT_SYMBOL(iwl_send_rxon_timing);
 
-void iwl_set_rxon_hwcrypto(struct iwl_priv *priv, int hw_decrypt)
+void iwl_set_rxon_hwcrypto(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
+			   int hw_decrypt)
 {
-	struct iwl_rxon_cmd *rxon = &priv->staging_rxon;
+	struct iwl_rxon_cmd *rxon = &ctx->staging;
 
 	if (hw_decrypt)
 		rxon->filter_flags &= ~RXON_FILTER_DIS_DECRYPT_MSK;
@@ -565,11 +570,11 @@ EXPORT_SYMBOL(iwl_set_rxon_hwcrypto);
  * be #ifdef'd out once the driver is stable and folks aren't actively
  * making changes
  */
-int iwl_check_rxon_cmd(struct iwl_priv *priv)
+int iwl_check_rxon_cmd(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 {
 	int error = 0;
 	int counter = 1;
-	struct iwl_rxon_cmd *rxon = &priv->staging_rxon;
+	struct iwl_rxon_cmd *rxon = &ctx->staging;
 
 	if (rxon->flags & RXON_FLG_BAND_24G_MSK) {
 		error |= le32_to_cpu(rxon->flags &
@@ -641,43 +646,57 @@ EXPORT_SYMBOL(iwl_check_rxon_cmd);
  * or is clearing the RXON_FILTER_ASSOC_MSK, then return 1 to indicate that
  * a new tune (full RXON command, rather than RXON_ASSOC cmd) is required.
  */
-int iwl_full_rxon_required(struct iwl_priv *priv)
+int iwl_full_rxon_required(struct iwl_priv *priv,
+			   struct iwl_rxon_context *ctx)
 {
+	const struct iwl_rxon_cmd *staging = &ctx->staging;
+	const struct iwl_rxon_cmd *active = &ctx->active;
+
+#define CHK(cond)							\
+	if ((cond)) {							\
+		IWL_DEBUG_INFO(priv, "need full RXON - " #cond "\n");	\
+		return 1;						\
+	}
+
+#define CHK_NEQ(c1, c2)						\
+	if ((c1) != (c2)) {					\
+		IWL_DEBUG_INFO(priv, "need full RXON - "	\
+			       #c1 " != " #c2 " - %d != %d\n",	\
+			       (c1), (c2));			\
+		return 1;					\
+	}
 
 	/* These items are only settable from the full RXON command */
-	if (!(iwl_is_associated(priv)) ||
-	    compare_ether_addr(priv->staging_rxon.bssid_addr,
-			       priv->active_rxon.bssid_addr) ||
-	    compare_ether_addr(priv->staging_rxon.node_addr,
-			       priv->active_rxon.node_addr) ||
-	    compare_ether_addr(priv->staging_rxon.wlap_bssid_addr,
-			       priv->active_rxon.wlap_bssid_addr) ||
-	    (priv->staging_rxon.dev_type != priv->active_rxon.dev_type) ||
-	    (priv->staging_rxon.channel != priv->active_rxon.channel) ||
-	    (priv->staging_rxon.air_propagation !=
-	     priv->active_rxon.air_propagation) ||
-	    (priv->staging_rxon.ofdm_ht_single_stream_basic_rates !=
-	     priv->active_rxon.ofdm_ht_single_stream_basic_rates) ||
-	    (priv->staging_rxon.ofdm_ht_dual_stream_basic_rates !=
-	     priv->active_rxon.ofdm_ht_dual_stream_basic_rates) ||
-	    (priv->staging_rxon.ofdm_ht_triple_stream_basic_rates !=
-	     priv->active_rxon.ofdm_ht_triple_stream_basic_rates) ||
-	    (priv->staging_rxon.assoc_id != priv->active_rxon.assoc_id))
-		return 1;
+	CHK(!iwl_is_associated_ctx(ctx));
+	CHK(compare_ether_addr(staging->bssid_addr, active->bssid_addr));
+	CHK(compare_ether_addr(staging->node_addr, active->node_addr));
+	CHK(compare_ether_addr(staging->wlap_bssid_addr,
+				active->wlap_bssid_addr));
+	CHK_NEQ(staging->dev_type, active->dev_type);
+	CHK_NEQ(staging->channel, active->channel);
+	CHK_NEQ(staging->air_propagation, active->air_propagation);
+	CHK_NEQ(staging->ofdm_ht_single_stream_basic_rates,
+		active->ofdm_ht_single_stream_basic_rates);
+	CHK_NEQ(staging->ofdm_ht_dual_stream_basic_rates,
+		active->ofdm_ht_dual_stream_basic_rates);
+	CHK_NEQ(staging->ofdm_ht_triple_stream_basic_rates,
+		active->ofdm_ht_triple_stream_basic_rates);
+	CHK_NEQ(staging->assoc_id, active->assoc_id);
 
 	/* flags, filter_flags, ofdm_basic_rates, and cck_basic_rates can
 	 * be updated with the RXON_ASSOC command -- however only some
 	 * flag transitions are allowed using RXON_ASSOC */
 
 	/* Check if we are not switching bands */
-	if ((priv->staging_rxon.flags & RXON_FLG_BAND_24G_MSK) !=
-	    (priv->active_rxon.flags & RXON_FLG_BAND_24G_MSK))
-		return 1;
+	CHK_NEQ(staging->flags & RXON_FLG_BAND_24G_MSK,
+		active->flags & RXON_FLG_BAND_24G_MSK);
 
 	/* Check if we are switching association toggle */
-	if ((priv->staging_rxon.filter_flags & RXON_FILTER_ASSOC_MSK) !=
-		(priv->active_rxon.filter_flags & RXON_FILTER_ASSOC_MSK))
-		return 1;
+	CHK_NEQ(staging->filter_flags & RXON_FILTER_ASSOC_MSK,
+		active->filter_flags & RXON_FILTER_ASSOC_MSK);
+
+#undef CHK
+#undef CHK_NEQ
 
 	return 0;
 }
@@ -685,20 +704,25 @@ EXPORT_SYMBOL(iwl_full_rxon_required);
 
 u8 iwl_rate_get_lowest_plcp(struct iwl_priv *priv)
 {
+#if !TODO
+	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
+#endif
 	/*
 	 * Assign the lowest rate -- should really get this from
 	 * the beacon skb from mac80211.
 	 */
-	if (priv->staging_rxon.flags & RXON_FLG_BAND_24G_MSK)
+	if (ctx->staging.flags & RXON_FLG_BAND_24G_MSK)
 		return IWL_RATE_1M_PLCP;
 	else
 		return IWL_RATE_6M_PLCP;
 }
 EXPORT_SYMBOL(iwl_rate_get_lowest_plcp);
 
-void iwl_set_rxon_ht(struct iwl_priv *priv, struct iwl_ht_config *ht_conf)
+static void _iwl_set_rxon_ht(struct iwl_priv *priv,
+			     struct iwl_ht_config *ht_conf,
+			     struct iwl_rxon_context *ctx)
 {
-	struct iwl_rxon_cmd *rxon = &priv->staging_rxon;
+	struct iwl_rxon_cmd *rxon = &ctx->staging;
 
 	if (!ht_conf->is_ht) {
 		rxon->flags &= ~(RXON_FLG_CHANNEL_MODE_MSK |
@@ -754,13 +778,21 @@ void iwl_set_rxon_ht(struct iwl_priv *priv, struct iwl_ht_config *ht_conf)
 	}
 
 	if (priv->cfg->ops->hcmd->set_rxon_chain)
-		priv->cfg->ops->hcmd->set_rxon_chain(priv);
+		priv->cfg->ops->hcmd->set_rxon_chain(priv, ctx);
 
 	IWL_DEBUG_ASSOC(priv, "rxon flags 0x%X operation mode :0x%X "
 			"extension channel offset 0x%x\n",
 			le32_to_cpu(rxon->flags), ht_conf->ht_protection,
 			ht_conf->extension_chan_offset);
 }
+
+void iwl_set_rxon_ht(struct iwl_priv *priv, struct iwl_ht_config *ht_conf)
+{
+	struct iwl_rxon_context *ctx;
+
+	for_each_context(priv, ctx)
+		_iwl_set_rxon_ht(priv, ht_conf, ctx);
+}
 EXPORT_SYMBOL(iwl_set_rxon_ht);
 
 #define IWL_NUM_RX_CHAINS_MULTIPLE	3
@@ -832,7 +864,7 @@ static u8 iwl_count_chain_bitmap(u32 chain_bitmap)
  * Selects how many and which Rx receivers/antennas/chains to use.
  * This should not be used for scan command ... it puts data in wrong place.
  */
-void iwl_set_rxon_chain(struct iwl_priv *priv)
+void iwl_set_rxon_chain(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 {
 	bool is_single = is_single_rx_stream(priv);
 	bool is_cam = !test_bit(STATUS_POWER_PMI, &priv->status);
@@ -878,15 +910,15 @@ void iwl_set_rxon_chain(struct iwl_priv *priv)
 	rx_chain |= active_rx_cnt << RXON_RX_CHAIN_MIMO_CNT_POS;
 	rx_chain |= idle_rx_cnt  << RXON_RX_CHAIN_CNT_POS;
 
-	priv->staging_rxon.rx_chain = cpu_to_le16(rx_chain);
+	ctx->staging.rx_chain = cpu_to_le16(rx_chain);
 
 	if (!is_single && (active_rx_cnt >= IWL_NUM_RX_CHAINS_SINGLE) && is_cam)
-		priv->staging_rxon.rx_chain |= RXON_RX_CHAIN_MIMO_FORCE_MSK;
+		ctx->staging.rx_chain |= RXON_RX_CHAIN_MIMO_FORCE_MSK;
 	else
-		priv->staging_rxon.rx_chain &= ~RXON_RX_CHAIN_MIMO_FORCE_MSK;
+		ctx->staging.rx_chain &= ~RXON_RX_CHAIN_MIMO_FORCE_MSK;
 
 	IWL_DEBUG_ASSOC(priv, "rx_chain=0x%X active=%d idle=%d\n",
-			priv->staging_rxon.rx_chain,
+			ctx->staging.rx_chain,
 			active_rx_cnt, idle_rx_cnt);
 
 	WARN_ON(active_rx_cnt == 0 || idle_rx_cnt == 0 ||
@@ -894,39 +926,41 @@ void iwl_set_rxon_chain(struct iwl_priv *priv)
 }
 EXPORT_SYMBOL(iwl_set_rxon_chain);
 
-/* Return valid channel */
+/* Return valid, unused, channel for a passive scan to reset the RF */
 u8 iwl_get_single_channel_number(struct iwl_priv *priv,
-				  enum ieee80211_band band)
+				 enum ieee80211_band band)
 {
 	const struct iwl_channel_info *ch_info;
 	int i;
 	u8 channel = 0;
+	u8 min, max;
+	struct iwl_rxon_context *ctx;
 
-	/* only scan single channel, good enough to reset the RF */
-	/* pick the first valid not in-use channel */
 	if (band == IEEE80211_BAND_5GHZ) {
-		for (i = 14; i < priv->channel_count; i++) {
-			if (priv->channel_info[i].channel !=
-			    le16_to_cpu(priv->staging_rxon.channel)) {
-				channel = priv->channel_info[i].channel;
-				ch_info = iwl_get_channel_info(priv,
-					band, channel);
-				if (is_channel_valid(ch_info))
-					break;
-			}
-		}
+		min = 14;
+		max = priv->channel_count;
 	} else {
-		for (i = 0; i < 14; i++) {
-			if (priv->channel_info[i].channel !=
-			    le16_to_cpu(priv->staging_rxon.channel)) {
-					channel =
-						priv->channel_info[i].channel;
-					ch_info = iwl_get_channel_info(priv,
-						band, channel);
-					if (is_channel_valid(ch_info))
-						break;
-			}
+		min = 0;
+		max = 14;
+	}
+
+	for (i = min; i < max; i++) {
+		bool busy = false;
+
+		for_each_context(priv, ctx) {
+			busy = priv->channel_info[i].channel ==
+				le16_to_cpu(ctx->staging.channel);
+			if (busy)
+				break;
 		}
+
+		if (busy)
+			continue;
+
+		channel = priv->channel_info[i].channel;
+		ch_info = iwl_get_channel_info(priv, band, channel);
+		if (is_channel_valid(ch_info))
+			break;
 	}
 
 	return channel;
@@ -937,25 +971,24 @@ EXPORT_SYMBOL(iwl_get_single_channel_number);
  * iwl_set_rxon_channel - Set the band and channel values in staging RXON
  * @ch: requested channel as a pointer to struct ieee80211_channel
 
- * In addition to setting the staging RXON, priv->band is also set.
- *
  * NOTE:  Does not commit to the hardware; it sets appropriate bit fields
  * in the staging RXON flag structure based on the ch->band
  */
-int iwl_set_rxon_channel(struct iwl_priv *priv, struct ieee80211_channel *ch)
+int iwl_set_rxon_channel(struct iwl_priv *priv, struct ieee80211_channel *ch,
+			 struct iwl_rxon_context *ctx)
 {
 	enum ieee80211_band band = ch->band;
 	u16 channel = ch->hw_value;
 
-	if ((le16_to_cpu(priv->staging_rxon.channel) == channel) &&
+	if ((le16_to_cpu(ctx->staging.channel) == channel) &&
 	    (priv->band == band))
 		return 0;
 
-	priv->staging_rxon.channel = cpu_to_le16(channel);
+	ctx->staging.channel = cpu_to_le16(channel);
 	if (band == IEEE80211_BAND_5GHZ)
-		priv->staging_rxon.flags &= ~RXON_FLG_BAND_24G_MSK;
+		ctx->staging.flags &= ~RXON_FLG_BAND_24G_MSK;
 	else
-		priv->staging_rxon.flags |= RXON_FLG_BAND_24G_MSK;
+		ctx->staging.flags |= RXON_FLG_BAND_24G_MSK;
 
 	priv->band = band;
 
@@ -966,24 +999,25 @@ int iwl_set_rxon_channel(struct iwl_priv *priv, struct ieee80211_channel *ch)
 EXPORT_SYMBOL(iwl_set_rxon_channel);
 
 void iwl_set_flags_for_band(struct iwl_priv *priv,
+			    struct iwl_rxon_context *ctx,
 			    enum ieee80211_band band,
 			    struct ieee80211_vif *vif)
 {
 	if (band == IEEE80211_BAND_5GHZ) {
-		priv->staging_rxon.flags &=
+		ctx->staging.flags &=
 		    ~(RXON_FLG_BAND_24G_MSK | RXON_FLG_AUTO_DETECT_MSK
 		      | RXON_FLG_CCK_MSK);
-		priv->staging_rxon.flags |= RXON_FLG_SHORT_SLOT_MSK;
+		ctx->staging.flags |= RXON_FLG_SHORT_SLOT_MSK;
 	} else {
 		/* Copied from iwl_post_associate() */
 		if (vif && vif->bss_conf.use_short_slot)
-			priv->staging_rxon.flags |= RXON_FLG_SHORT_SLOT_MSK;
+			ctx->staging.flags |= RXON_FLG_SHORT_SLOT_MSK;
 		else
-			priv->staging_rxon.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
+			ctx->staging.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
 
-		priv->staging_rxon.flags |= RXON_FLG_BAND_24G_MSK;
-		priv->staging_rxon.flags |= RXON_FLG_AUTO_DETECT_MSK;
-		priv->staging_rxon.flags &= ~RXON_FLG_CCK_MSK;
+		ctx->staging.flags |= RXON_FLG_BAND_24G_MSK;
+		ctx->staging.flags |= RXON_FLG_AUTO_DETECT_MSK;
+		ctx->staging.flags &= ~RXON_FLG_CCK_MSK;
 	}
 }
 EXPORT_SYMBOL(iwl_set_flags_for_band);
@@ -996,26 +1030,29 @@ void iwl_connection_init_rx_config(struct iwl_priv *priv,
 {
 	const struct iwl_channel_info *ch_info;
 	enum nl80211_iftype type = NL80211_IFTYPE_STATION;
+	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 
-	if (vif)
+	if (vif) {
 		type = vif->type;
+		ctx = iwl_rxon_ctx_from_vif(vif);
+	}
 
-	memset(&priv->staging_rxon, 0, sizeof(priv->staging_rxon));
+	memset(&ctx->staging, 0, sizeof(ctx->staging));
 
 	switch (type) {
 	case NL80211_IFTYPE_AP:
-		priv->staging_rxon.dev_type = RXON_DEV_TYPE_AP;
+		ctx->staging.dev_type = RXON_DEV_TYPE_AP;
 		break;
 
 	case NL80211_IFTYPE_STATION:
-		priv->staging_rxon.dev_type = RXON_DEV_TYPE_ESS;
-		priv->staging_rxon.filter_flags = RXON_FILTER_ACCEPT_GRP_MSK;
+		ctx->staging.dev_type = RXON_DEV_TYPE_ESS;
+		ctx->staging.filter_flags = RXON_FILTER_ACCEPT_GRP_MSK;
 		break;
 
 	case NL80211_IFTYPE_ADHOC:
-		priv->staging_rxon.dev_type = RXON_DEV_TYPE_IBSS;
-		priv->staging_rxon.flags = RXON_FLG_SHORT_PREAMBLE_MSK;
-		priv->staging_rxon.filter_flags = RXON_FILTER_BCON_AWARE_MSK |
+		ctx->staging.dev_type = RXON_DEV_TYPE_IBSS;
+		ctx->staging.flags = RXON_FLG_SHORT_PREAMBLE_MSK;
+		ctx->staging.filter_flags = RXON_FILTER_BCON_AWARE_MSK |
 						  RXON_FILTER_ACCEPT_GRP_MSK;
 		break;
 
@@ -1028,37 +1065,36 @@ void iwl_connection_init_rx_config(struct iwl_priv *priv,
 	/* TODO:  Figure out when short_preamble would be set and cache from
 	 * that */
 	if (!hw_to_local(priv->hw)->short_preamble)
-		priv->staging_rxon.flags &= ~RXON_FLG_SHORT_PREAMBLE_MSK;
+		ctx->staging.flags &= ~RXON_FLG_SHORT_PREAMBLE_MSK;
 	else
-		priv->staging_rxon.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
+		ctx->staging.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
 #endif
 
 	ch_info = iwl_get_channel_info(priv, priv->band,
-				       le16_to_cpu(priv->active_rxon.channel));
+				       le16_to_cpu(ctx->active.channel));
 
 	if (!ch_info)
 		ch_info = &priv->channel_info[0];
 
-	priv->staging_rxon.channel = cpu_to_le16(ch_info->channel);
+	ctx->staging.channel = cpu_to_le16(ch_info->channel);
 	priv->band = ch_info->band;
 
-	iwl_set_flags_for_band(priv, priv->band, vif);
+	iwl_set_flags_for_band(priv, ctx, priv->band, vif);
 
-	priv->staging_rxon.ofdm_basic_rates =
+	ctx->staging.ofdm_basic_rates =
 	    (IWL_OFDM_RATES_MASK >> IWL_FIRST_OFDM_RATE) & 0xFF;
-	priv->staging_rxon.cck_basic_rates =
+	ctx->staging.cck_basic_rates =
 	    (IWL_CCK_RATES_MASK >> IWL_FIRST_CCK_RATE) & 0xF;
 
 	/* clear both MIX and PURE40 mode flag */
-	priv->staging_rxon.flags &= ~(RXON_FLG_CHANNEL_MODE_MIXED |
+	ctx->staging.flags &= ~(RXON_FLG_CHANNEL_MODE_MIXED |
 					RXON_FLG_CHANNEL_MODE_PURE_40);
-
 	if (vif)
-		memcpy(priv->staging_rxon.node_addr, vif->addr, ETH_ALEN);
+		memcpy(ctx->staging.node_addr, vif->addr, ETH_ALEN);
 
-	priv->staging_rxon.ofdm_ht_single_stream_basic_rates = 0xff;
-	priv->staging_rxon.ofdm_ht_dual_stream_basic_rates = 0xff;
-	priv->staging_rxon.ofdm_ht_triple_stream_basic_rates = 0xff;
+	ctx->staging.ofdm_ht_single_stream_basic_rates = 0xff;
+	ctx->staging.ofdm_ht_dual_stream_basic_rates = 0xff;
+	ctx->staging.ofdm_ht_triple_stream_basic_rates = 0xff;
 }
 EXPORT_SYMBOL(iwl_connection_init_rx_config);
 
@@ -1066,6 +1102,7 @@ void iwl_set_rate(struct iwl_priv *priv)
 {
 	const struct ieee80211_supported_band *hw = NULL;
 	struct ieee80211_rate *rate;
+	struct iwl_rxon_context *ctx;
 	int i;
 
 	hw = iwl_get_hw_mode(priv, priv->band);
@@ -1084,11 +1121,13 @@ void iwl_set_rate(struct iwl_priv *priv)
 
 	IWL_DEBUG_RATE(priv, "Set active_rate = %0x\n", priv->active_rate);
 
-	priv->staging_rxon.cck_basic_rates =
-	    (IWL_CCK_BASIC_RATES_MASK >> IWL_FIRST_CCK_RATE) & 0xF;
+	for_each_context(priv, ctx) {
+		ctx->staging.cck_basic_rates =
+		    (IWL_CCK_BASIC_RATES_MASK >> IWL_FIRST_CCK_RATE) & 0xF;
 
-	priv->staging_rxon.ofdm_basic_rates =
-	   (IWL_OFDM_BASIC_RATES_MASK >> IWL_FIRST_OFDM_RATE) & 0xFF;
+		ctx->staging.ofdm_basic_rates =
+		   (IWL_OFDM_BASIC_RATES_MASK >> IWL_FIRST_OFDM_RATE) & 0xFF;
+	}
 }
 EXPORT_SYMBOL(iwl_set_rate);
 
@@ -1109,14 +1148,17 @@ EXPORT_SYMBOL(iwl_chswitch_done);
 void iwl_rx_csa(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	struct iwl_rxon_cmd *rxon = (void *)&priv->active_rxon;
 	struct iwl_csa_notification *csa = &(pkt->u.csa_notif);
+#if !TODO
+	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
+#endif
+	struct iwl_rxon_cmd *rxon = (void *)&ctx->active;
 
 	if (priv->switch_rxon.switch_in_progress) {
 		if (!le32_to_cpu(csa->status) &&
 		    (csa->channel == priv->switch_rxon.channel)) {
 			rxon->channel = csa->channel;
-			priv->staging_rxon.channel = csa->channel;
+			ctx->staging.channel = csa->channel;
 			IWL_DEBUG_11H(priv, "CSA notif: channel %d\n",
 			      le16_to_cpu(csa->channel));
 			iwl_chswitch_done(priv, true);
@@ -1130,9 +1172,10 @@ void iwl_rx_csa(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 EXPORT_SYMBOL(iwl_rx_csa);
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-void iwl_print_rx_config_cmd(struct iwl_priv *priv)
+void iwl_print_rx_config_cmd(struct iwl_priv *priv,
+			     struct iwl_rxon_context *ctx)
 {
-	struct iwl_rxon_cmd *rxon = &priv->staging_rxon;
+	struct iwl_rxon_cmd *rxon = &ctx->staging;
 
 	IWL_DEBUG_RADIO(priv, "RX CONFIG:\n");
 	iwl_print_hex_dump(priv, IWL_DL_RADIO, (u8 *) rxon, sizeof(*rxon));
@@ -1172,7 +1215,8 @@ void iwl_irq_handle_error(struct iwl_priv *priv)
 	priv->cfg->ops->lib->dump_nic_event_log(priv, false, NULL, false);
 #ifdef CONFIG_IWLWIFI_DEBUG
 	if (iwl_get_debug_level(priv) & IWL_DL_FW_ERRORS)
-		iwl_print_rx_config_cmd(priv);
+		iwl_print_rx_config_cmd(priv,
+					&priv->contexts[IWL_RXON_CTX_BSS]);
 #endif
 
 	wake_up_interruptible(&priv->wait_command_queue);
@@ -1640,18 +1684,20 @@ static void iwl_ht_conf(struct iwl_priv *priv,
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
 
-static inline void iwl_set_no_assoc(struct iwl_priv *priv)
+static inline void iwl_set_no_assoc(struct iwl_priv *priv,
+				    struct ieee80211_vif *vif)
 {
+	struct iwl_rxon_context *ctx = iwl_rxon_ctx_from_vif(vif);
+
 	iwl_led_disassociate(priv);
 	/*
 	 * inform the ucode that there is no longer an
 	 * association and that no more packets should be
 	 * sent
 	 */
-	priv->staging_rxon.filter_flags &=
-		~RXON_FILTER_ASSOC_MSK;
-	priv->staging_rxon.assoc_id = 0;
-	iwlcore_commit_rxon(priv);
+	ctx->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
+	ctx->staging.assoc_id = 0;
+	iwlcore_commit_rxon(priv, ctx);
 }
 
 static int iwl_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
@@ -1691,6 +1737,7 @@ void iwl_bss_info_changed(struct ieee80211_hw *hw,
 			  u32 changes)
 {
 	struct iwl_priv *priv = hw->priv;
+	struct iwl_rxon_context *ctx = iwl_rxon_ctx_from_vif(vif);
 	int ret;
 
 	IWL_DEBUG_MAC80211(priv, "changes = 0x%X\n", changes);
@@ -1735,13 +1782,13 @@ void iwl_bss_info_changed(struct ieee80211_hw *hw,
 
 		/* mac80211 only sets assoc when in STATION mode */
 		if (vif->type == NL80211_IFTYPE_ADHOC || bss_conf->assoc) {
-			memcpy(priv->staging_rxon.bssid_addr,
+			memcpy(ctx->staging.bssid_addr,
 			       bss_conf->bssid, ETH_ALEN);
 
 			/* currently needed in a few places */
 			memcpy(priv->bssid, bss_conf->bssid, ETH_ALEN);
 		} else {
-			priv->staging_rxon.filter_flags &=
+			ctx->staging.filter_flags &=
 				~RXON_FILTER_ASSOC_MSK;
 		}
 
@@ -1764,21 +1811,21 @@ void iwl_bss_info_changed(struct ieee80211_hw *hw,
 		IWL_DEBUG_MAC80211(priv, "ERP_PREAMBLE %d\n",
 				   bss_conf->use_short_preamble);
 		if (bss_conf->use_short_preamble)
-			priv->staging_rxon.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
+			ctx->staging.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
 		else
-			priv->staging_rxon.flags &= ~RXON_FLG_SHORT_PREAMBLE_MSK;
+			ctx->staging.flags &= ~RXON_FLG_SHORT_PREAMBLE_MSK;
 	}
 
 	if (changes & BSS_CHANGED_ERP_CTS_PROT) {
 		IWL_DEBUG_MAC80211(priv, "ERP_CTS %d\n", bss_conf->use_cts_prot);
 		if (bss_conf->use_cts_prot && (priv->band != IEEE80211_BAND_5GHZ))
-			priv->staging_rxon.flags |= RXON_FLG_TGG_PROTECT_MSK;
+			ctx->staging.flags |= RXON_FLG_TGG_PROTECT_MSK;
 		else
-			priv->staging_rxon.flags &= ~RXON_FLG_TGG_PROTECT_MSK;
+			ctx->staging.flags &= ~RXON_FLG_TGG_PROTECT_MSK;
 		if (bss_conf->use_cts_prot)
-			priv->staging_rxon.flags |= RXON_FLG_SELF_CTS_EN;
+			ctx->staging.flags |= RXON_FLG_SELF_CTS_EN;
 		else
-			priv->staging_rxon.flags &= ~RXON_FLG_SELF_CTS_EN;
+			ctx->staging.flags &= ~RXON_FLG_SELF_CTS_EN;
 	}
 
 	if (changes & BSS_CHANGED_BASIC_RATES) {
@@ -1788,12 +1835,12 @@ void iwl_bss_info_changed(struct ieee80211_hw *hw,
 		 * like this here:
 		 *
 		if (A-band)
-			priv->staging_rxon.ofdm_basic_rates =
+			ctx->staging.ofdm_basic_rates =
 				bss_conf->basic_rates;
 		else
-			priv->staging_rxon.ofdm_basic_rates =
+			ctx->staging.ofdm_basic_rates =
 				bss_conf->basic_rates >> 4;
-			priv->staging_rxon.cck_basic_rates =
+			ctx->staging.cck_basic_rates =
 				bss_conf->basic_rates & 0xF;
 		 */
 	}
@@ -1802,7 +1849,7 @@ void iwl_bss_info_changed(struct ieee80211_hw *hw,
 		iwl_ht_conf(priv, vif);
 
 		if (priv->cfg->ops->hcmd->set_rxon_chain)
-			priv->cfg->ops->hcmd->set_rxon_chain(priv);
+			priv->cfg->ops->hcmd->set_rxon_chain(priv, ctx);
 	}
 
 	if (changes & BSS_CHANGED_ASSOC) {
@@ -1815,29 +1862,29 @@ void iwl_bss_info_changed(struct ieee80211_hw *hw,
 			if (!iwl_is_rfkill(priv))
 				priv->cfg->ops->lib->post_associate(priv, vif);
 		} else
-			iwl_set_no_assoc(priv);
+			iwl_set_no_assoc(priv, vif);
 	}
 
-	if (changes && iwl_is_associated(priv) && bss_conf->aid) {
+	if (changes && iwl_is_associated_ctx(ctx) && bss_conf->aid) {
 		IWL_DEBUG_MAC80211(priv, "Changes (%#x) while associated\n",
 				   changes);
-		ret = iwl_send_rxon_assoc(priv);
+		ret = iwl_send_rxon_assoc(priv, ctx);
 		if (!ret) {
 			/* Sync active_rxon with latest change. */
-			memcpy((void *)&priv->active_rxon,
-				&priv->staging_rxon,
+			memcpy((void *)&ctx->active,
+				&ctx->staging,
 				sizeof(struct iwl_rxon_cmd));
 		}
 	}
 
 	if (changes & BSS_CHANGED_BEACON_ENABLED) {
 		if (vif->bss_conf.enable_beacon) {
-			memcpy(priv->staging_rxon.bssid_addr,
+			memcpy(ctx->staging.bssid_addr,
 			       bss_conf->bssid, ETH_ALEN);
 			memcpy(priv->bssid, bss_conf->bssid, ETH_ALEN);
 			iwlcore_config_ap(priv, vif);
 		} else
-			iwl_set_no_assoc(priv);
+			iwl_set_no_assoc(priv, vif);
 	}
 
 	if (changes & BSS_CHANGED_IBSS) {
@@ -1857,17 +1904,20 @@ EXPORT_SYMBOL(iwl_bss_info_changed);
 
 static int iwl_set_mode(struct iwl_priv *priv, struct ieee80211_vif *vif)
 {
+	struct iwl_rxon_context *ctx = iwl_rxon_ctx_from_vif(vif);
+
 	iwl_connection_init_rx_config(priv, vif);
 
 	if (priv->cfg->ops->hcmd->set_rxon_chain)
-		priv->cfg->ops->hcmd->set_rxon_chain(priv);
+		priv->cfg->ops->hcmd->set_rxon_chain(priv, ctx);
 
-	return iwlcore_commit_rxon(priv);
+	return iwlcore_commit_rxon(priv, ctx);
 }
 
 int iwl_mac_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
 	struct iwl_priv *priv = hw->priv;
+	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
 	int err = 0;
 
 	IWL_DEBUG_MAC80211(priv, "enter: type %d, addr %pM\n",
@@ -1875,6 +1925,8 @@ int iwl_mac_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 
 	mutex_lock(&priv->mutex);
 
+	vif_priv->ctx = &priv->contexts[IWL_RXON_CTX_BSS];
+
 	if (WARN_ON(!iwl_is_ready_rf(priv))) {
 		err = -EINVAL;
 		goto out;
@@ -1920,6 +1972,7 @@ void iwl_mac_remove_interface(struct ieee80211_hw *hw,
 			      struct ieee80211_vif *vif)
 {
 	struct iwl_priv *priv = hw->priv;
+	struct iwl_rxon_context *ctx = iwl_rxon_ctx_from_vif(vif);
 	bool scan_completed = false;
 
 	IWL_DEBUG_MAC80211(priv, "enter\n");
@@ -1928,8 +1981,8 @@ void iwl_mac_remove_interface(struct ieee80211_hw *hw,
 
 	if (iwl_is_ready_rf(priv)) {
 		iwl_scan_cancel_timeout(priv, 100);
-		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-		iwlcore_commit_rxon(priv);
+		ctx->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
+		iwlcore_commit_rxon(priv, ctx);
 	}
 	if (priv->vif == vif) {
 		priv->vif = NULL;
@@ -1971,6 +2024,7 @@ int iwl_mac_config(struct ieee80211_hw *hw, u32 changed)
 	struct ieee80211_conf *conf = &hw->conf;
 	struct ieee80211_channel *channel = conf->channel;
 	struct iwl_ht_config *ht_conf = &priv->current_ht_config;
+	struct iwl_rxon_context *ctx;
 	unsigned long flags = 0;
 	int ret = 0;
 	u16 ch;
@@ -2000,7 +2054,8 @@ int iwl_mac_config(struct ieee80211_hw *hw, u32 changed)
 		 * configured.
 		 */
 		if (priv->cfg->ops->hcmd->set_rxon_chain)
-			priv->cfg->ops->hcmd->set_rxon_chain(priv);
+			for_each_context(priv, ctx)
+				priv->cfg->ops->hcmd->set_rxon_chain(priv, ctx);
 	}
 
 	/* during scanning mac80211 will delay channel setting until
@@ -2042,13 +2097,20 @@ int iwl_mac_config(struct ieee80211_hw *hw, u32 changed)
 		 * from BSS config in iwl_ht_conf */
 		ht_conf->ht_protection = IEEE80211_HT_OP_MODE_PROTECTION_NONE;
 
-		if ((le16_to_cpu(priv->staging_rxon.channel) != ch))
-			priv->staging_rxon.flags = 0;
+		for_each_context(priv, ctx) {
+			/* if we are switching from ht to 2.4 clear flags
+			 * from any ht related info since 2.4 does not
+			 * support ht */
+			if ((le16_to_cpu(ctx->staging.channel) != ch))
+				ctx->staging.flags = 0;
 
-		iwl_set_rxon_channel(priv, channel);
-		iwl_set_rxon_ht(priv, ht_conf);
+			iwl_set_rxon_channel(priv, channel, ctx);
+			iwl_set_rxon_ht(priv, ht_conf);
+
+			iwl_set_flags_for_band(priv, ctx, channel->band,
+					       priv->vif);
+		}
 
-		iwl_set_flags_for_band(priv, channel->band, priv->vif);
 		spin_unlock_irqrestore(&priv->lock, flags);
 
 		if (priv->cfg->ops->lib->update_bcast_station)
@@ -2083,12 +2145,13 @@ int iwl_mac_config(struct ieee80211_hw *hw, u32 changed)
 	if (scan_active)
 		goto out;
 
-	if (memcmp(&priv->active_rxon,
-		   &priv->staging_rxon, sizeof(priv->staging_rxon)))
-		iwlcore_commit_rxon(priv);
-	else
-		IWL_DEBUG_INFO(priv, "Not re-sending same RXON configuration.\n");
-
+	for_each_context(priv, ctx) {
+		if (memcmp(&ctx->active, &ctx->staging, sizeof(ctx->staging)))
+			iwlcore_commit_rxon(priv, ctx);
+		else
+			IWL_DEBUG_INFO(priv,
+				"Not re-sending same RXON configuration.\n");
+	}
 
 out:
 	IWL_DEBUG_MAC80211(priv, "leave\n");
@@ -2101,6 +2164,8 @@ void iwl_mac_reset_tsf(struct ieee80211_hw *hw)
 {
 	struct iwl_priv *priv = hw->priv;
 	unsigned long flags;
+	/* IBSS can only be the IWL_RXON_CTX_BSS context */
+	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 
 	mutex_lock(&priv->mutex);
 	IWL_DEBUG_MAC80211(priv, "enter\n");
@@ -2131,8 +2196,8 @@ void iwl_mac_reset_tsf(struct ieee80211_hw *hw)
 	 * clear RXON_FILTER_ASSOC_MSK bit
 	 */
 	iwl_scan_cancel_timeout(priv, 100);
-	priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-	iwlcore_commit_rxon(priv);
+	ctx->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
+	iwlcore_commit_rxon(priv, ctx);
 
 	iwl_set_rate(priv);
 
@@ -2541,7 +2606,7 @@ static void iwl_force_rf_reset(struct iwl_priv *priv)
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
-	if (!iwl_is_associated(priv)) {
+	if (!iwl_is_any_associated(priv)) {
 		IWL_DEBUG_SCAN(priv, "force reset rejected: not associated\n");
 		return;
 	}
@@ -2696,7 +2761,7 @@ void iwl_bg_monitor_recover(unsigned long data)
 		return;
 
 	/* monitor and check for other stuck queues */
-	if (iwl_is_associated(priv)) {
+	if (iwl_is_any_associated(priv)) {
 		for (cnt = 0; cnt < priv->hw_params.max_txq_num; cnt++) {
 			/* skip as we already checked the command queue */
 			if (cnt == IWL_CMD_QUEUE_NUM)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index de2e39f..80c2562 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -88,9 +88,10 @@ struct iwl_cmd;
 #define IWL_CMD(x) case x: return #x
 
 struct iwl_hcmd_ops {
-	int (*rxon_assoc)(struct iwl_priv *priv);
-	int (*commit_rxon)(struct iwl_priv *priv);
-	void (*set_rxon_chain)(struct iwl_priv *priv);
+	int (*rxon_assoc)(struct iwl_priv *priv, struct iwl_rxon_context *ctx);
+	int (*commit_rxon)(struct iwl_priv *priv, struct iwl_rxon_context *ctx);
+	void (*set_rxon_chain)(struct iwl_priv *priv,
+			       struct iwl_rxon_context *ctx);
 	int (*set_tx_ant)(struct iwl_priv *priv, u8 valid_tx_ant);
 	void (*send_bt_config)(struct iwl_priv *priv);
 };
@@ -374,12 +375,15 @@ void iwl_activate_qos(struct iwl_priv *priv);
 int iwl_mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
 		    const struct ieee80211_tx_queue_params *params);
 int iwl_mac_tx_last_beacon(struct ieee80211_hw *hw);
-void iwl_set_rxon_hwcrypto(struct iwl_priv *priv, int hw_decrypt);
-int iwl_check_rxon_cmd(struct iwl_priv *priv);
-int iwl_full_rxon_required(struct iwl_priv *priv);
-void iwl_set_rxon_chain(struct iwl_priv *priv);
-int iwl_set_rxon_channel(struct iwl_priv *priv, struct ieee80211_channel *ch);
+void iwl_set_rxon_hwcrypto(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
+			   int hw_decrypt);
+int iwl_check_rxon_cmd(struct iwl_priv *priv, struct iwl_rxon_context *ctx);
+int iwl_full_rxon_required(struct iwl_priv *priv, struct iwl_rxon_context *ctx);
+void iwl_set_rxon_chain(struct iwl_priv *priv, struct iwl_rxon_context *ctx);
+int iwl_set_rxon_channel(struct iwl_priv *priv, struct ieee80211_channel *ch,
+			 struct iwl_rxon_context *ctx);
 void iwl_set_flags_for_band(struct iwl_priv *priv,
+			    struct iwl_rxon_context *ctx,
 			    enum ieee80211_band band,
 			    struct ieee80211_vif *vif);
 u8 iwl_get_single_channel_number(struct iwl_priv *priv,
@@ -400,7 +404,7 @@ void iwl_bss_info_changed(struct ieee80211_hw *hw,
 				     struct ieee80211_vif *vif,
 				     struct ieee80211_bss_conf *bss_conf,
 				     u32 changes);
-int iwl_commit_rxon(struct iwl_priv *priv);
+int iwl_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx);
 int iwl_mac_add_interface(struct ieee80211_hw *hw,
 			  struct ieee80211_vif *vif);
 void iwl_mac_remove_interface(struct ieee80211_hw *hw,
@@ -632,9 +636,11 @@ int iwl_dump_nic_event_log(struct iwl_priv *priv,
 void iwl_dump_csr(struct iwl_priv *priv);
 int iwl_dump_fh(struct iwl_priv *priv, char **buf, bool display);
 #ifdef CONFIG_IWLWIFI_DEBUG
-void iwl_print_rx_config_cmd(struct iwl_priv *priv);
+void iwl_print_rx_config_cmd(struct iwl_priv *priv,
+			     struct iwl_rxon_context *ctx);
 #else
-static inline void iwl_print_rx_config_cmd(struct iwl_priv *priv)
+static inline void iwl_print_rx_config_cmd(struct iwl_priv *priv,
+					   struct iwl_rxon_context *ctx)
 {
 }
 #endif
@@ -720,13 +726,15 @@ void iwl_apm_stop(struct iwl_priv *priv);
 int iwl_apm_init(struct iwl_priv *priv);
 
 int iwl_send_rxon_timing(struct iwl_priv *priv, struct ieee80211_vif *vif);
-static inline int iwl_send_rxon_assoc(struct iwl_priv *priv)
+static inline int iwl_send_rxon_assoc(struct iwl_priv *priv,
+				      struct iwl_rxon_context *ctx)
 {
-	return priv->cfg->ops->hcmd->rxon_assoc(priv);
+	return priv->cfg->ops->hcmd->rxon_assoc(priv, ctx);
 }
-static inline int iwlcore_commit_rxon(struct iwl_priv *priv)
+static inline int iwlcore_commit_rxon(struct iwl_priv *priv,
+				      struct iwl_rxon_context *ctx)
 {
-	return priv->cfg->ops->hcmd->commit_rxon(priv);
+	return priv->cfg->ops->hcmd->commit_rxon(priv, ctx);
 }
 static inline void iwlcore_config_ap(struct iwl_priv *priv,
 				     struct ieee80211_vif *vif)
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index ef78790..d36418c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -730,7 +730,7 @@ static ssize_t iwl_dbgfs_disable_ht40_write(struct file *file,
 		return -EFAULT;
 	if (sscanf(buf, "%d", &ht40) != 1)
 		return -EFAULT;
-	if (!iwl_is_associated(priv))
+	if (!iwl_is_any_associated(priv))
 		priv->disable_ht40 = ht40 ? true : false;
 	else {
 		IWL_ERR(priv, "Sta associated with AP - "
@@ -1319,7 +1319,8 @@ static ssize_t iwl_dbgfs_rxon_flags_read(struct file *file,
 	int len = 0;
 	char buf[20];
 
-	len = sprintf(buf, "0x%04X\n", le32_to_cpu(priv->active_rxon.flags));
+	len = sprintf(buf, "0x%04X\n",
+		le32_to_cpu(priv->contexts[IWL_RXON_CTX_BSS].active.flags));
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
 
@@ -1332,7 +1333,7 @@ static ssize_t iwl_dbgfs_rxon_filter_flags_read(struct file *file,
 	char buf[20];
 
 	len = sprintf(buf, "0x%04X\n",
-		      le32_to_cpu(priv->active_rxon.filter_flags));
+		le32_to_cpu(priv->contexts[IWL_RXON_CTX_BSS].active.filter_flags));
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 8d5201a..6b18892 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -519,6 +519,7 @@ struct iwl_station_priv {
  * space for us to put data into.
  */
 struct iwl_vif_priv {
+	struct iwl_rxon_context *ctx;
 	u8 ibss_bssid_sta_id;
 };
 
@@ -1097,6 +1098,26 @@ struct iwl_force_reset {
  */
 #define IWLAGN_EXT_BEACON_TIME_POS	22
 
+enum iwl_rxon_context_id {
+	IWL_RXON_CTX_BSS,
+
+	NUM_IWL_RXON_CTX
+};
+
+struct iwl_rxon_context {
+	enum iwl_rxon_context_id ctxid;
+	/*
+	 * We declare this const so it can only be
+	 * changed via explicit cast within the
+	 * routines that actually update the physical
+	 * hardware.
+	 */
+	const struct iwl_rxon_cmd active;
+	struct iwl_rxon_cmd staging;
+
+	struct iwl_rxon_time_cmd timing;
+};
+
 struct iwl_priv {
 
 	/* ieee device used by generic ieee processing code */
@@ -1173,6 +1194,9 @@ struct iwl_priv {
 	u32  hw_wa_rev;
 	u8   rev_id;
 
+	/* microcode/device supports multiple contexts */
+	u8 valid_contexts;
+
 	/* EEPROM MAC addresses */
 	struct mac_address addresses[2];
 
@@ -1190,15 +1214,7 @@ struct iwl_priv {
 	u8 ucode_write_complete;	/* the image write is complete */
 	char firmware_name[25];
 
-
-	struct iwl_rxon_time_cmd rxon_timing;
-
-	/* We declare this const so it can only be
-	 * changed via explicit cast within the
-	 * routines that actually update the physical
-	 * hardware */
-	const struct iwl_rxon_cmd active_rxon;
-	struct iwl_rxon_cmd staging_rxon;
+	struct iwl_rxon_context contexts[NUM_IWL_RXON_CTX];
 
 	struct iwl_switch_rxon switch_rxon;
 
@@ -1490,10 +1506,34 @@ static inline struct ieee80211_hdr *iwl_tx_queue_get_hdr(struct iwl_priv *priv,
 	return NULL;
 }
 
+static inline struct iwl_rxon_context *
+iwl_rxon_ctx_from_vif(struct ieee80211_vif *vif)
+{
+	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
+
+	return vif_priv->ctx;
+}
+
+#define for_each_context(priv, ctx)				\
+	for (ctx = &priv->contexts[IWL_RXON_CTX_BSS];		\
+	     ctx < &priv->contexts[NUM_IWL_RXON_CTX]; ctx++)	\
+		if (priv->valid_contexts & BIT(ctx->ctxid))
+
+static inline int iwl_is_associated(struct iwl_priv *priv,
+				    enum iwl_rxon_context_id ctxid)
+{
+	return (priv->contexts[ctxid].active.filter_flags &
+			RXON_FILTER_ASSOC_MSK) ? 1 : 0;
+}
+
+static inline int iwl_is_any_associated(struct iwl_priv *priv)
+{
+	return iwl_is_associated(priv, IWL_RXON_CTX_BSS);
+}
 
-static inline int iwl_is_associated(struct iwl_priv *priv)
+static inline int iwl_is_associated_ctx(struct iwl_rxon_context *ctx)
 {
-	return (priv->active_rxon.filter_flags & RXON_FILTER_ASSOC_MSK) ? 1 : 0;
+	return (ctx->active.filter_flags & RXON_FILTER_ASSOC_MSK) ? 1 : 0;
 }
 
 static inline int is_channel_valid(const struct iwl_channel_info *ch_info)
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 79773e3..10be197 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -228,7 +228,7 @@ void iwl_recover_from_statistics(struct iwl_priv *priv,
 {
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
-	if (iwl_is_associated(priv)) {
+	if (iwl_is_any_associated(priv)) {
 		if (priv->cfg->ops->lib->check_ack_health) {
 			if (!priv->cfg->ops->lib->check_ack_health(
 			    priv, pkt)) {
@@ -266,7 +266,12 @@ int iwl_set_decrypted_flag(struct iwl_priv *priv,
 {
 	u16 fc = le16_to_cpu(hdr->frame_control);
 
-	if (priv->active_rxon.filter_flags & RXON_FILTER_DIS_DECRYPT_MSK)
+	/*
+	 * All contexts have the same setting here due to it being
+	 * a module parameter, so OK to check any context.
+	 */
+	if (priv->contexts[IWL_RXON_CTX_BSS].active.filter_flags &
+						RXON_FILTER_DIS_DECRYPT_MSK)
 		return 0;
 
 	if (!(fc & IEEE80211_FCTL_PROTECTED))
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 2939699..fe4cb57 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -290,7 +290,8 @@ u16 iwl_get_passive_dwell_time(struct iwl_priv *priv,
 	    IWL_PASSIVE_DWELL_BASE + IWL_PASSIVE_DWELL_TIME_24 :
 	    IWL_PASSIVE_DWELL_BASE + IWL_PASSIVE_DWELL_TIME_52;
 
-	if (iwl_is_associated(priv)) {
+	if (iwl_is_any_associated(priv)) {
+		/* TODO: should use minimum of all contexts */
 		/* If we're associated, we clamp the maximum passive
 		 * dwell time to be 98% of the beacon interval (minus
 		 * 2 * channel tune time) */
@@ -527,6 +528,7 @@ static void iwl_bg_scan_completed(struct work_struct *work)
 	    container_of(work, struct iwl_priv, scan_completed);
 	bool internal = false;
 	bool scan_completed = false;
+	struct iwl_rxon_context *ctx;
 
 	IWL_DEBUG_SCAN(priv, "SCAN complete scan\n");
 
@@ -557,9 +559,8 @@ static void iwl_bg_scan_completed(struct work_struct *work)
 	 * Since setting the RXON may have been deferred while
 	 * performing the scan, fire one off if needed
 	 */
-	if (memcmp(&priv->active_rxon,
-		   &priv->staging_rxon, sizeof(priv->staging_rxon)))
-		iwlcore_commit_rxon(priv);
+	for_each_context(priv, ctx)
+		iwlcore_commit_rxon(priv, ctx);
 
  out:
 	mutex_unlock(&priv->mutex);
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index d5e8db3..43afb8f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -1153,12 +1153,16 @@ static bool is_lq_table_valid(struct iwl_priv *priv,
 {
 	int i;
 	struct iwl_ht_config *ht_conf = &priv->current_ht_config;
+#if !TODO
+	struct iwl_rxon_context *ctx =
+			&priv->contexts[IWL_RXON_CTX_BSS];
+#endif
 
 	if (ht_conf->is_ht)
 		return true;
 
 	IWL_DEBUG_INFO(priv, "Channel %u is not an HT channel\n",
-		       priv->active_rxon.channel);
+		       ctx->active.channel);
 	for (i = 0; i < LINK_QUAL_MAX_RETRY_NUM; i++) {
 		if (le32_to_cpu(lq->rs_table[i].rate_n_flags) & RATE_MCS_HT_MSK) {
 			IWL_DEBUG_INFO(priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 53e6cbb..234d6b4 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -317,7 +317,7 @@ unsigned int iwl3945_fill_beacon_frame(struct iwl_priv *priv,
 				int left)
 {
 
-	if (!iwl_is_associated(priv) || !priv->ibss_beacon)
+	if (!iwl_is_associated(priv, IWL_RXON_CTX_BSS) || !priv->ibss_beacon)
 		return 0;
 
 	if (priv->ibss_beacon->len > left)
@@ -683,11 +683,12 @@ static int iwl3945_get_measurement(struct iwl_priv *priv,
 	int rc;
 	int spectrum_resp_status;
 	int duration = le16_to_cpu(params->duration);
+	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 
-	if (iwl_is_associated(priv))
+	if (iwl_is_associated(priv, IWL_RXON_CTX_BSS))
 		add_time = iwl_usecs_to_beacons(priv,
 			le64_to_cpu(params->start_time) - priv->_3945.last_tsf,
-			le16_to_cpu(priv->rxon_timing.beacon_interval));
+			le16_to_cpu(ctx->timing.beacon_interval));
 
 	memset(&spectrum, 0, sizeof(spectrum));
 
@@ -698,18 +699,18 @@ static int iwl3945_get_measurement(struct iwl_priv *priv,
 	cmd.len = sizeof(spectrum);
 	spectrum.len = cpu_to_le16(cmd.len - sizeof(spectrum.len));
 
-	if (iwl_is_associated(priv))
+	if (iwl_is_associated(priv, IWL_RXON_CTX_BSS))
 		spectrum.start_time =
 			iwl_add_beacon_time(priv,
 				priv->_3945.last_beacon_time, add_time,
-				le16_to_cpu(priv->rxon_timing.beacon_interval));
+				le16_to_cpu(ctx->timing.beacon_interval));
 	else
 		spectrum.start_time = 0;
 
 	spectrum.channels[0].duration = cpu_to_le32(duration * TIME_UNIT);
 	spectrum.channels[0].channel = params->channel;
 	spectrum.channels[0].type = type;
-	if (priv->active_rxon.flags & RXON_FLG_BAND_24G_MSK)
+	if (ctx->active.flags & RXON_FLG_BAND_24G_MSK)
 		spectrum.flags |= RXON_FLG_BAND_24G_MSK |
 		    RXON_FLG_AUTO_DETECT_MSK | RXON_FLG_TGG_PROTECT_MSK;
 
@@ -2468,6 +2469,7 @@ static void iwl3945_alive_start(struct iwl_priv *priv)
 {
 	int thermal_spin = 0;
 	u32 rfkill;
+	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 
 	IWL_DEBUG_INFO(priv, "Runtime Alive received.\n");
 
@@ -2525,11 +2527,11 @@ static void iwl3945_alive_start(struct iwl_priv *priv)
 
 	iwl_power_update_mode(priv, true);
 
-	if (iwl_is_associated(priv)) {
+	if (iwl_is_associated(priv, IWL_RXON_CTX_BSS)) {
 		struct iwl3945_rxon_cmd *active_rxon =
-				(struct iwl3945_rxon_cmd *)(&priv->active_rxon);
+				(struct iwl3945_rxon_cmd *)(&ctx->active);
 
-		priv->staging_rxon.filter_flags |= RXON_FILTER_ASSOC_MSK;
+		ctx->staging.filter_flags |= RXON_FILTER_ASSOC_MSK;
 		active_rxon->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 	} else {
 		/* Initialize our rx_config data */
@@ -2540,7 +2542,7 @@ static void iwl3945_alive_start(struct iwl_priv *priv)
 	priv->cfg->ops->hcmd->send_bt_config(priv);
 
 	/* Configure the adapter for unassociated operation */
-	iwlcore_commit_rxon(priv);
+	iwlcore_commit_rxon(priv, ctx);
 
 	iwl3945_reg_txpower_periodic(priv);
 
@@ -2883,7 +2885,7 @@ void iwl3945_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	scan->quiet_plcp_th = IWL_PLCP_QUIET_THRESH;
 	scan->quiet_time = IWL_ACTIVE_QUIET_TIME;
 
-	if (iwl_is_associated(priv)) {
+	if (iwl_is_associated(priv, IWL_RXON_CTX_BSS)) {
 		u16 interval = 0;
 		u32 extra;
 		u32 suspend_time = 100;
@@ -3077,6 +3079,7 @@ void iwl3945_post_associate(struct iwl_priv *priv, struct ieee80211_vif *vif)
 {
 	int rc = 0;
 	struct ieee80211_conf *conf = NULL;
+	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 
 	if (!vif || !priv->is_open)
 		return;
@@ -3087,7 +3090,7 @@ void iwl3945_post_associate(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	}
 
 	IWL_DEBUG_ASSOC(priv, "Associated as %d to: %pM\n",
-			vif->bss_conf.aid, priv->active_rxon.bssid_addr);
+			vif->bss_conf.aid, ctx->active.bssid_addr);
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
@@ -3096,34 +3099,34 @@ void iwl3945_post_associate(struct iwl_priv *priv, struct ieee80211_vif *vif)
 
 	conf = ieee80211_get_hw_conf(priv->hw);
 
-	priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-	iwlcore_commit_rxon(priv);
+	ctx->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
+	iwlcore_commit_rxon(priv, ctx);
 
 	rc = iwl_send_rxon_timing(priv, vif);
 	if (rc)
 		IWL_WARN(priv, "REPLY_RXON_TIMING failed - "
 			    "Attempting to continue.\n");
 
-	priv->staging_rxon.filter_flags |= RXON_FILTER_ASSOC_MSK;
+	ctx->staging.filter_flags |= RXON_FILTER_ASSOC_MSK;
 
-	priv->staging_rxon.assoc_id = cpu_to_le16(vif->bss_conf.aid);
+	ctx->staging.assoc_id = cpu_to_le16(vif->bss_conf.aid);
 
 	IWL_DEBUG_ASSOC(priv, "assoc id %d beacon interval %d\n",
 			vif->bss_conf.aid, vif->bss_conf.beacon_int);
 
 	if (vif->bss_conf.use_short_preamble)
-		priv->staging_rxon.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
+		ctx->staging.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
 	else
-		priv->staging_rxon.flags &= ~RXON_FLG_SHORT_PREAMBLE_MSK;
+		ctx->staging.flags &= ~RXON_FLG_SHORT_PREAMBLE_MSK;
 
-	if (priv->staging_rxon.flags & RXON_FLG_BAND_24G_MSK) {
+	if (ctx->staging.flags & RXON_FLG_BAND_24G_MSK) {
 		if (vif->bss_conf.use_short_slot)
-			priv->staging_rxon.flags |= RXON_FLG_SHORT_SLOT_MSK;
+			ctx->staging.flags |= RXON_FLG_SHORT_SLOT_MSK;
 		else
-			priv->staging_rxon.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
+			ctx->staging.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
 	}
 
-	iwlcore_commit_rxon(priv);
+	iwlcore_commit_rxon(priv, ctx);
 
 	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
@@ -3260,17 +3263,18 @@ static int iwl3945_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 void iwl3945_config_ap(struct iwl_priv *priv, struct ieee80211_vif *vif)
 {
+	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 	int rc = 0;
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
 	/* The following should be done only at AP bring up */
-	if (!(iwl_is_associated(priv))) {
+	if (!(iwl_is_associated(priv, IWL_RXON_CTX_BSS))) {
 
 		/* RXON - unassoc (to set timing command) */
-		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-		iwlcore_commit_rxon(priv);
+		ctx->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
+		iwlcore_commit_rxon(priv, ctx);
 
 		/* RXON Timing */
 		rc = iwl_send_rxon_timing(priv, vif);
@@ -3278,26 +3282,26 @@ void iwl3945_config_ap(struct iwl_priv *priv, struct ieee80211_vif *vif)
 			IWL_WARN(priv, "REPLY_RXON_TIMING failed - "
 					"Attempting to continue.\n");
 
-		priv->staging_rxon.assoc_id = 0;
+		ctx->staging.assoc_id = 0;
 
 		if (vif->bss_conf.use_short_preamble)
-			priv->staging_rxon.flags |=
+			ctx->staging.flags |=
 				RXON_FLG_SHORT_PREAMBLE_MSK;
 		else
-			priv->staging_rxon.flags &=
+			ctx->staging.flags &=
 				~RXON_FLG_SHORT_PREAMBLE_MSK;
 
-		if (priv->staging_rxon.flags & RXON_FLG_BAND_24G_MSK) {
+		if (ctx->staging.flags & RXON_FLG_BAND_24G_MSK) {
 			if (vif->bss_conf.use_short_slot)
-				priv->staging_rxon.flags |=
+				ctx->staging.flags |=
 					RXON_FLG_SHORT_SLOT_MSK;
 			else
-				priv->staging_rxon.flags &=
+				ctx->staging.flags &=
 					~RXON_FLG_SHORT_SLOT_MSK;
 		}
 		/* restore RXON assoc */
-		priv->staging_rxon.filter_flags |= RXON_FILTER_ASSOC_MSK;
-		iwlcore_commit_rxon(priv);
+		ctx->staging.filter_flags |= RXON_FILTER_ASSOC_MSK;
+		iwlcore_commit_rxon(priv, ctx);
 	}
 	iwl3945_send_beacon_cmd(priv);
 
@@ -3323,7 +3327,7 @@ static int iwl3945_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		return -EOPNOTSUPP;
 	}
 
-	static_key = !iwl_is_associated(priv);
+	static_key = !iwl_is_associated(priv, IWL_RXON_CTX_BSS);
 
 	if (!static_key) {
 		sta_id = iwl_sta_id_or_broadcast(priv, sta);
@@ -3405,6 +3409,7 @@ static void iwl3945_configure_filter(struct ieee80211_hw *hw,
 {
 	struct iwl_priv *priv = hw->priv;
 	__le32 filter_or = 0, filter_nand = 0;
+	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 
 #define CHK(test, flag)	do { \
 	if (*total_flags & (test))		\
@@ -3424,8 +3429,8 @@ static void iwl3945_configure_filter(struct ieee80211_hw *hw,
 
 	mutex_lock(&priv->mutex);
 
-	priv->staging_rxon.filter_flags &= ~filter_nand;
-	priv->staging_rxon.filter_flags |= filter_or;
+	ctx->staging.filter_flags &= ~filter_nand;
+	ctx->staging.filter_flags |= filter_or;
 
 	/*
 	 * Committing directly here breaks for some reason,
@@ -3539,8 +3544,9 @@ static ssize_t show_flags(struct device *d,
 			  struct device_attribute *attr, char *buf)
 {
 	struct iwl_priv *priv = dev_get_drvdata(d);
+	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 
-	return sprintf(buf, "0x%04X\n", priv->active_rxon.flags);
+	return sprintf(buf, "0x%04X\n", ctx->active.flags);
 }
 
 static ssize_t store_flags(struct device *d,
@@ -3549,17 +3555,18 @@ static ssize_t store_flags(struct device *d,
 {
 	struct iwl_priv *priv = dev_get_drvdata(d);
 	u32 flags = simple_strtoul(buf, NULL, 0);
+	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 
 	mutex_lock(&priv->mutex);
-	if (le32_to_cpu(priv->staging_rxon.flags) != flags) {
+	if (le32_to_cpu(ctx->staging.flags) != flags) {
 		/* Cancel any currently running scans... */
 		if (iwl_scan_cancel_timeout(priv, 100))
 			IWL_WARN(priv, "Could not cancel scan.\n");
 		else {
 			IWL_DEBUG_INFO(priv, "Committing rxon.flags = 0x%04X\n",
 				       flags);
-			priv->staging_rxon.flags = cpu_to_le32(flags);
-			iwlcore_commit_rxon(priv);
+			ctx->staging.flags = cpu_to_le32(flags);
+			iwlcore_commit_rxon(priv, ctx);
 		}
 	}
 	mutex_unlock(&priv->mutex);
@@ -3573,9 +3580,10 @@ static ssize_t show_filter_flags(struct device *d,
 				 struct device_attribute *attr, char *buf)
 {
 	struct iwl_priv *priv = dev_get_drvdata(d);
+	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 
 	return sprintf(buf, "0x%04X\n",
-		le32_to_cpu(priv->active_rxon.filter_flags));
+		le32_to_cpu(ctx->active.filter_flags));
 }
 
 static ssize_t store_filter_flags(struct device *d,
@@ -3583,19 +3591,20 @@ static ssize_t store_filter_flags(struct device *d,
 				  const char *buf, size_t count)
 {
 	struct iwl_priv *priv = dev_get_drvdata(d);
+	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 	u32 filter_flags = simple_strtoul(buf, NULL, 0);
 
 	mutex_lock(&priv->mutex);
-	if (le32_to_cpu(priv->staging_rxon.filter_flags) != filter_flags) {
+	if (le32_to_cpu(ctx->staging.filter_flags) != filter_flags) {
 		/* Cancel any currently running scans... */
 		if (iwl_scan_cancel_timeout(priv, 100))
 			IWL_WARN(priv, "Could not cancel scan.\n");
 		else {
 			IWL_DEBUG_INFO(priv, "Committing rxon.filter_flags = "
 				       "0x%04X\n", filter_flags);
-			priv->staging_rxon.filter_flags =
+			ctx->staging.filter_flags =
 				cpu_to_le32(filter_flags);
-			iwlcore_commit_rxon(priv);
+			iwlcore_commit_rxon(priv, ctx);
 		}
 	}
 	mutex_unlock(&priv->mutex);
@@ -3643,8 +3652,9 @@ static ssize_t store_measurement(struct device *d,
 				 const char *buf, size_t count)
 {
 	struct iwl_priv *priv = dev_get_drvdata(d);
+	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 	struct ieee80211_measurement_params params = {
-		.channel = le16_to_cpu(priv->active_rxon.channel),
+		.channel = le16_to_cpu(ctx->active.channel),
 		.start_time = cpu_to_le64(priv->_3945.last_tsf),
 		.duration = cpu_to_le16(1),
 	};
@@ -3969,7 +3979,7 @@ static int iwl3945_setup_mac(struct iwl_priv *priv)
 
 static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	int err = 0;
+	int err = 0, i;
 	struct iwl_priv *priv;
 	struct ieee80211_hw *hw;
 	struct iwl_cfg *cfg = (struct iwl_cfg *)(ent->driver_data);
@@ -3991,6 +4001,12 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	priv = hw->priv;
 	SET_IEEE80211_DEV(hw, &pdev->dev);
 
+	/* 3945 has only one valid context */
+	priv->valid_contexts = BIT(IWL_RXON_CTX_BSS);
+
+	for (i = 0; i < NUM_IWL_RXON_CTX; i++)
+		priv->contexts[i].ctxid = i;
+
 	/*
 	 * Disabling hardware scan means that mac80211 will perform scans
 	 * "the hard way", rather than using device's scan.
@@ -4126,7 +4142,8 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	}
 
 	iwl_set_rxon_channel(priv,
-			     &priv->bands[IEEE80211_BAND_2GHZ].channels[5]);
+			     &priv->bands[IEEE80211_BAND_2GHZ].channels[5],
+			     &priv->contexts[IWL_RXON_CTX_BSS]);
 	iwl3945_setup_deferred_work(priv);
 	iwl3945_setup_rx_handlers(priv);
 	iwl_power_initialize(priv);
-- 
1.7.0.4

