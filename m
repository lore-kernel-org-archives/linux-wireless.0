Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:21225 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161456Ab2COU2H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 16:28:07 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 19/26] iwlwifi: Move iwl_send_rxon_timing and make it static
Date: Thu, 15 Mar 2012 13:26:59 -0700
Message-Id: <1331843226-29860-20-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120315_212842_863229_A8ED1C16)
In-Reply-To: <1331843226-29860-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331843226-29860-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>

iwl_send_rxon_timing is used only in
iwl-agn-rxon.c, move it there and mark it
static.

Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |  103 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.c     |  102 --------------------------
 drivers/net/wireless/iwlwifi/iwl-core.h     |    2 -
 3 files changed, 103 insertions(+), 104 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 0a6b014..6a2fad3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -189,6 +189,109 @@ static int iwlagn_send_rxon_assoc(struct iwl_priv *priv,
 	return ret;
 }
 
+static u16 iwl_adjust_beacon_interval(u16 beacon_val, u16 max_beacon_val)
+{
+	u16 new_val;
+	u16 beacon_factor;
+
+	/*
+	 * If mac80211 hasn't given us a beacon interval, program
+	 * the default into the device (not checking this here
+	 * would cause the adjustment below to return the maximum
+	 * value, which may break PAN.)
+	 */
+	if (!beacon_val)
+		return DEFAULT_BEACON_INTERVAL;
+
+	/*
+	 * If the beacon interval we obtained from the peer
+	 * is too large, we'll have to wake up more often
+	 * (and in IBSS case, we'll beacon too much)
+	 *
+	 * For example, if max_beacon_val is 4096, and the
+	 * requested beacon interval is 7000, we'll have to
+	 * use 3500 to be able to wake up on the beacons.
+	 *
+	 * This could badly influence beacon detection stats.
+	 */
+
+	beacon_factor = (beacon_val + max_beacon_val) / max_beacon_val;
+	new_val = beacon_val / beacon_factor;
+
+	if (!new_val)
+		new_val = max_beacon_val;
+
+	return new_val;
+}
+
+static int iwl_send_rxon_timing(struct iwl_priv *priv,
+				struct iwl_rxon_context *ctx)
+{
+	u64 tsf;
+	s32 interval_tm, rem;
+	struct ieee80211_conf *conf = NULL;
+	u16 beacon_int;
+	struct ieee80211_vif *vif = ctx->vif;
+
+	conf = &priv->hw->conf;
+
+	lockdep_assert_held(&priv->mutex);
+
+	memset(&ctx->timing, 0, sizeof(struct iwl_rxon_time_cmd));
+
+	ctx->timing.timestamp = cpu_to_le64(priv->timestamp);
+	ctx->timing.listen_interval = cpu_to_le16(conf->listen_interval);
+
+	beacon_int = vif ? vif->bss_conf.beacon_int : 0;
+
+	/*
+	 * TODO: For IBSS we need to get atim_window from mac80211,
+	 *	 for now just always use 0
+	 */
+	ctx->timing.atim_window = 0;
+
+	if (ctx->ctxid == IWL_RXON_CTX_PAN &&
+	    (!ctx->vif || ctx->vif->type != NL80211_IFTYPE_STATION) &&
+	    iwl_is_associated(priv, IWL_RXON_CTX_BSS) &&
+	    priv->contexts[IWL_RXON_CTX_BSS].vif &&
+	    priv->contexts[IWL_RXON_CTX_BSS].vif->bss_conf.beacon_int) {
+		ctx->timing.beacon_interval =
+			priv->contexts[IWL_RXON_CTX_BSS].timing.beacon_interval;
+		beacon_int = le16_to_cpu(ctx->timing.beacon_interval);
+	} else if (ctx->ctxid == IWL_RXON_CTX_BSS &&
+		   iwl_is_associated(priv, IWL_RXON_CTX_PAN) &&
+		   priv->contexts[IWL_RXON_CTX_PAN].vif &&
+		   priv->contexts[IWL_RXON_CTX_PAN].vif->bss_conf.beacon_int &&
+		   (!iwl_is_associated_ctx(ctx) || !ctx->vif ||
+		    !ctx->vif->bss_conf.beacon_int)) {
+		ctx->timing.beacon_interval =
+			priv->contexts[IWL_RXON_CTX_PAN].timing.beacon_interval;
+		beacon_int = le16_to_cpu(ctx->timing.beacon_interval);
+	} else {
+		beacon_int = iwl_adjust_beacon_interval(beacon_int,
+			IWL_MAX_UCODE_BEACON_INTERVAL * TIME_UNIT);
+		ctx->timing.beacon_interval = cpu_to_le16(beacon_int);
+	}
+
+	ctx->beacon_int = beacon_int;
+
+	tsf = priv->timestamp; /* tsf is modifed by do_div: copy it */
+	interval_tm = beacon_int * TIME_UNIT;
+	rem = do_div(tsf, interval_tm);
+	ctx->timing.beacon_init_val = cpu_to_le32(interval_tm - rem);
+
+	ctx->timing.dtim_period = vif ? (vif->bss_conf.dtim_period ?: 1) : 1;
+
+	IWL_DEBUG_ASSOC(priv,
+			"beacon interval %d beacon timer %d beacon tim %d\n",
+			le16_to_cpu(ctx->timing.beacon_interval),
+			le32_to_cpu(ctx->timing.beacon_init_val),
+			le16_to_cpu(ctx->timing.atim_window));
+
+	return iwl_dvm_send_cmd_pdu(priv, ctx->rxon_timing_cmd,
+				CMD_SYNC, sizeof(ctx->timing), &ctx->timing);
+}
+
 static int iwlagn_rxon_disconn(struct iwl_priv *priv,
 			       struct iwl_rxon_context *ctx)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 06bcf27..796f4a1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -88,108 +88,6 @@ bool iwl_is_ht40_tx_allowed(struct iwl_priv *priv,
 			ctx->ht.extension_chan_offset);
 }
 
-static u16 iwl_adjust_beacon_interval(u16 beacon_val, u16 max_beacon_val)
-{
-	u16 new_val;
-	u16 beacon_factor;
-
-	/*
-	 * If mac80211 hasn't given us a beacon interval, program
-	 * the default into the device (not checking this here
-	 * would cause the adjustment below to return the maximum
-	 * value, which may break PAN.)
-	 */
-	if (!beacon_val)
-		return DEFAULT_BEACON_INTERVAL;
-
-	/*
-	 * If the beacon interval we obtained from the peer
-	 * is too large, we'll have to wake up more often
-	 * (and in IBSS case, we'll beacon too much)
-	 *
-	 * For example, if max_beacon_val is 4096, and the
-	 * requested beacon interval is 7000, we'll have to
-	 * use 3500 to be able to wake up on the beacons.
-	 *
-	 * This could badly influence beacon detection stats.
-	 */
-
-	beacon_factor = (beacon_val + max_beacon_val) / max_beacon_val;
-	new_val = beacon_val / beacon_factor;
-
-	if (!new_val)
-		new_val = max_beacon_val;
-
-	return new_val;
-}
-
-int iwl_send_rxon_timing(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
-{
-	u64 tsf;
-	s32 interval_tm, rem;
-	struct ieee80211_conf *conf = NULL;
-	u16 beacon_int;
-	struct ieee80211_vif *vif = ctx->vif;
-
-	conf = &priv->hw->conf;
-
-	lockdep_assert_held(&priv->mutex);
-
-	memset(&ctx->timing, 0, sizeof(struct iwl_rxon_time_cmd));
-
-	ctx->timing.timestamp = cpu_to_le64(priv->timestamp);
-	ctx->timing.listen_interval = cpu_to_le16(conf->listen_interval);
-
-	beacon_int = vif ? vif->bss_conf.beacon_int : 0;
-
-	/*
-	 * TODO: For IBSS we need to get atim_window from mac80211,
-	 *	 for now just always use 0
-	 */
-	ctx->timing.atim_window = 0;
-
-	if (ctx->ctxid == IWL_RXON_CTX_PAN &&
-	    (!ctx->vif || ctx->vif->type != NL80211_IFTYPE_STATION) &&
-	    iwl_is_associated(priv, IWL_RXON_CTX_BSS) &&
-	    priv->contexts[IWL_RXON_CTX_BSS].vif &&
-	    priv->contexts[IWL_RXON_CTX_BSS].vif->bss_conf.beacon_int) {
-		ctx->timing.beacon_interval =
-			priv->contexts[IWL_RXON_CTX_BSS].timing.beacon_interval;
-		beacon_int = le16_to_cpu(ctx->timing.beacon_interval);
-	} else if (ctx->ctxid == IWL_RXON_CTX_BSS &&
-		   iwl_is_associated(priv, IWL_RXON_CTX_PAN) &&
-		   priv->contexts[IWL_RXON_CTX_PAN].vif &&
-		   priv->contexts[IWL_RXON_CTX_PAN].vif->bss_conf.beacon_int &&
-		   (!iwl_is_associated_ctx(ctx) || !ctx->vif ||
-		    !ctx->vif->bss_conf.beacon_int)) {
-		ctx->timing.beacon_interval =
-			priv->contexts[IWL_RXON_CTX_PAN].timing.beacon_interval;
-		beacon_int = le16_to_cpu(ctx->timing.beacon_interval);
-	} else {
-		beacon_int = iwl_adjust_beacon_interval(beacon_int,
-			IWL_MAX_UCODE_BEACON_INTERVAL * TIME_UNIT);
-		ctx->timing.beacon_interval = cpu_to_le16(beacon_int);
-	}
-
-	ctx->beacon_int = beacon_int;
-
-	tsf = priv->timestamp; /* tsf is modifed by do_div: copy it */
-	interval_tm = beacon_int * TIME_UNIT;
-	rem = do_div(tsf, interval_tm);
-	ctx->timing.beacon_init_val = cpu_to_le32(interval_tm - rem);
-
-	ctx->timing.dtim_period = vif ? (vif->bss_conf.dtim_period ?: 1) : 1;
-
-	IWL_DEBUG_ASSOC(priv,
-			"beacon interval %d beacon timer %d beacon tim %d\n",
-			le16_to_cpu(ctx->timing.beacon_interval),
-			le32_to_cpu(ctx->timing.beacon_init_val),
-			le16_to_cpu(ctx->timing.atim_window));
-
-	return iwl_dvm_send_cmd_pdu(priv, ctx->rxon_timing_cmd,
-				CMD_SYNC, sizeof(ctx->timing), &ctx->timing);
-}
-
 void iwl_set_rxon_hwcrypto(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 			   int hw_decrypt)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 8a7d6fc..7217be8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -208,8 +208,6 @@ extern void iwl_send_bt_config(struct iwl_priv *priv);
 extern int iwl_send_statistics_request(struct iwl_priv *priv,
 				       u8 flags, bool clear);
 
-int iwl_send_rxon_timing(struct iwl_priv *priv, struct iwl_rxon_context *ctx);
-
 static inline const struct ieee80211_supported_band *iwl_get_hw_mode(
 			struct iwl_priv *priv, enum ieee80211_band band)
 {
-- 
1.7.0.4

