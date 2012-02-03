Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18040 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754234Ab2BCMIW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 07:08:22 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 16/25] iwlegacy: move ht out of ctx structure
Date: Fri,  3 Feb 2012 13:07:16 +0100
Message-Id: <1328270845-16891-17-git-send-email-sgruszka@redhat.com> (sfid-20120203_130832_915344_98C8346A)
In-Reply-To: <1328270845-16891-1-git-send-email-sgruszka@redhat.com>
References: <1328270845-16891-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/4965-mac.c |   18 +++++-----
 drivers/net/wireless/iwlegacy/4965-rs.c  |   13 +++-----
 drivers/net/wireless/iwlegacy/common.c   |   49 ++++++++++++++---------------
 drivers/net/wireless/iwlegacy/common.h   |   15 +++++----
 4 files changed, 46 insertions(+), 49 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 1dd0014..94984c8 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -5793,23 +5793,23 @@ il4965_mac_channel_switch(struct ieee80211_hw *hw,
 	il->current_ht_config.smps = conf->smps_mode;
 
 	/* Configure HT40 channels */
-	ctx->ht.enabled = conf_is_ht(conf);
-	if (ctx->ht.enabled) {
+	il->ht.enabled = conf_is_ht(conf);
+	if (il->ht.enabled) {
 		if (conf_is_ht40_minus(conf)) {
-			ctx->ht.extension_chan_offset =
+			il->ht.extension_chan_offset =
 			    IEEE80211_HT_PARAM_CHA_SEC_BELOW;
-			ctx->ht.is_40mhz = true;
+			il->ht.is_40mhz = true;
 		} else if (conf_is_ht40_plus(conf)) {
-			ctx->ht.extension_chan_offset =
+			il->ht.extension_chan_offset =
 			    IEEE80211_HT_PARAM_CHA_SEC_ABOVE;
-			ctx->ht.is_40mhz = true;
+			il->ht.is_40mhz = true;
 		} else {
-			ctx->ht.extension_chan_offset =
+			il->ht.extension_chan_offset =
 			    IEEE80211_HT_PARAM_CHA_SEC_NONE;
-			ctx->ht.is_40mhz = false;
+			il->ht.is_40mhz = false;
 		}
 	} else
-		ctx->ht.is_40mhz = false;
+		il->ht.is_40mhz = false;
 
 	if ((le16_to_cpu(il->staging.channel) != ch))
 		il->staging.flags = 0;
diff --git a/drivers/net/wireless/iwlegacy/4965-rs.c b/drivers/net/wireless/iwlegacy/4965-rs.c
index 467d0cb..ad186d9 100644
--- a/drivers/net/wireless/iwlegacy/4965-rs.c
+++ b/drivers/net/wireless/iwlegacy/4965-rs.c
@@ -641,13 +641,10 @@ il4965_rs_toggle_antenna(u32 valid_ant, u32 *rate_n_flags,
  * there are no non-GF stations present in the BSS.
  */
 static bool
-il4965_rs_use_green(struct ieee80211_sta *sta)
+il4965_rs_use_green(struct il_priv *il, struct ieee80211_sta *sta)
 {
-	struct il_station_priv *sta_priv = (void *)sta->drv_priv;
-	struct il_rxon_context *ctx = sta_priv->common.ctx;
-
 	return (sta->ht_cap.cap & IEEE80211_HT_CAP_GRN_FLD) &&
-	    !(ctx->ht.non_gf_sta_present);
+	       !il->ht.non_gf_sta_present;
 }
 
 /**
@@ -1815,7 +1812,7 @@ il4965_rs_rate_scale_perform(struct il_priv *il, struct sk_buff *skb,
 	if (is_legacy(tbl->lq_type))
 		lq_sta->is_green = 0;
 	else
-		lq_sta->is_green = il4965_rs_use_green(sta);
+		lq_sta->is_green = il4965_rs_use_green(il, sta);
 	is_green = lq_sta->is_green;
 
 	/* current tx rate */
@@ -2166,7 +2163,7 @@ il4965_rs_initialize_lq(struct il_priv *il, struct ieee80211_conf *conf,
 	int rate_idx;
 	int i;
 	u32 rate;
-	u8 use_green = il4965_rs_use_green(sta);
+	u8 use_green = il4965_rs_use_green(il, sta);
 	u8 active_tbl = 0;
 	u8 valid_tx_ant;
 	struct il_station_priv *sta_priv;
@@ -2341,7 +2338,7 @@ il4965_rs_rate_init(struct il_priv *il, struct ieee80211_sta *sta, u8 sta_id)
 	lq_sta->is_dup = 0;
 	lq_sta->max_rate_idx = -1;
 	lq_sta->missed_rate_counter = IL_MISSED_RATE_MAX;
-	lq_sta->is_green = il4965_rs_use_green(sta);
+	lq_sta->is_green = il4965_rs_use_green(il, sta);
 	lq_sta->active_legacy_rate = il->active_rate & ~(0x1000);
 	lq_sta->band = il->band;
 	/*
diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index c93fa1b..db2e8bb 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -2352,7 +2352,7 @@ il_is_lq_table_valid(struct il_priv *il, struct il_rxon_context *ctx,
 {
 	int i;
 
-	if (ctx->ht.enabled)
+	if (il->ht.enabled)
 		return true;
 
 	D_INFO("Channel %u is not an HT channel\n", il->active.channel);
@@ -3559,7 +3559,7 @@ bool
 il_is_ht40_tx_allowed(struct il_priv *il, struct il_rxon_context *ctx,
 		      struct ieee80211_sta_ht_cap *ht_cap)
 {
-	if (!ctx->ht.enabled || !ctx->ht.is_40mhz)
+	if (!il->ht.enabled || !il->ht.is_40mhz)
 		return false;
 
 	/*
@@ -3576,7 +3576,7 @@ il_is_ht40_tx_allowed(struct il_priv *il, struct il_rxon_context *ctx,
 
 	return il_is_channel_extension(il, il->band,
 				       le16_to_cpu(il->staging.channel),
-				       ctx->ht.extension_chan_offset);
+				       il->ht.extension_chan_offset);
 }
 EXPORT_SYMBOL(il_is_ht40_tx_allowed);
 
@@ -3832,7 +3832,7 @@ _il_set_rxon_ht(struct il_priv *il, struct il_ht_config *ht_conf,
 {
 	struct il_rxon_cmd *rxon = &il->staging;
 
-	if (!ctx->ht.enabled) {
+	if (!il->ht.enabled) {
 		rxon->flags &=
 		    ~(RXON_FLG_CHANNEL_MODE_MSK |
 		      RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK | RXON_FLG_HT40_PROT_MSK
@@ -3841,7 +3841,7 @@ _il_set_rxon_ht(struct il_priv *il, struct il_ht_config *ht_conf,
 	}
 
 	rxon->flags |=
-	    cpu_to_le32(ctx->ht.protection << RXON_FLG_HT_OPERATING_MODE_POS);
+	    cpu_to_le32(il->ht.protection << RXON_FLG_HT_OPERATING_MODE_POS);
 
 	/* Set up channel bandwidth:
 	 * 20 MHz only, 20/40 mixed or pure 40 if ht40 ok */
@@ -3850,10 +3850,10 @@ _il_set_rxon_ht(struct il_priv *il, struct il_ht_config *ht_conf,
 	    ~(RXON_FLG_CHANNEL_MODE_MSK | RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK);
 	if (il_is_ht40_tx_allowed(il, ctx, NULL)) {
 		/* pure ht40 */
-		if (ctx->ht.protection == IEEE80211_HT_OP_MODE_PROTECTION_20MHZ) {
+		if (il->ht.protection == IEEE80211_HT_OP_MODE_PROTECTION_20MHZ) {
 			rxon->flags |= RXON_FLG_CHANNEL_MODE_PURE_40;
 			/* Note: control channel is opposite of extension channel */
-			switch (ctx->ht.extension_chan_offset) {
+			switch (il->ht.extension_chan_offset) {
 			case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
 				rxon->flags &=
 				    ~RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK;
@@ -3864,7 +3864,7 @@ _il_set_rxon_ht(struct il_priv *il, struct il_ht_config *ht_conf,
 			}
 		} else {
 			/* Note: control channel is opposite of extension channel */
-			switch (ctx->ht.extension_chan_offset) {
+			switch (il->ht.extension_chan_offset) {
 			case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
 				rxon->flags &=
 				    ~(RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK);
@@ -3890,7 +3890,7 @@ _il_set_rxon_ht(struct il_priv *il, struct il_ht_config *ht_conf,
 
 	D_ASSOC("rxon flags 0x%X operation mode :0x%X "
 		"extension channel offset 0x%x\n", le32_to_cpu(rxon->flags),
-		ctx->ht.protection, ctx->ht.extension_chan_offset);
+		il->ht.protection, il->ht.extension_chan_offset);
 }
 
 void
@@ -5236,7 +5236,7 @@ il_update_qos(struct il_priv *il, struct il_rxon_context *ctx)
 		il->qos_data.def_qos_parm.qos_flags |=
 		    QOS_PARAM_FLG_UPDATE_EDCA_MSK;
 
-	if (ctx->ht.enabled)
+	if (il->ht.enabled)
 		il->qos_data.def_qos_parm.qos_flags |= QOS_PARAM_FLG_TGN_MSK;
 
 	D_QOS("send QoS cmd with Qos active=%d FLAGS=0x%X\n",
@@ -5319,32 +5319,32 @@ il_mac_config(struct ieee80211_hw *hw, u32 changed)
 		spin_lock_irqsave(&il->lock, flags);
 
 		/* Configure HT40 channels */
-		if (ctx->ht.enabled != conf_is_ht(conf)) {
-			ctx->ht.enabled = conf_is_ht(conf);
+		if (il->ht.enabled != conf_is_ht(conf)) {
+			il->ht.enabled = conf_is_ht(conf);
 			ht_changed = true;
 		}
-		if (ctx->ht.enabled) {
+		if (il->ht.enabled) {
 			if (conf_is_ht40_minus(conf)) {
-				ctx->ht.extension_chan_offset =
+				il->ht.extension_chan_offset =
 				    IEEE80211_HT_PARAM_CHA_SEC_BELOW;
-				ctx->ht.is_40mhz = true;
+				il->ht.is_40mhz = true;
 			} else if (conf_is_ht40_plus(conf)) {
-				ctx->ht.extension_chan_offset =
+				il->ht.extension_chan_offset =
 				    IEEE80211_HT_PARAM_CHA_SEC_ABOVE;
-				ctx->ht.is_40mhz = true;
+				il->ht.is_40mhz = true;
 			} else {
-				ctx->ht.extension_chan_offset =
+				il->ht.extension_chan_offset =
 				    IEEE80211_HT_PARAM_CHA_SEC_NONE;
-				ctx->ht.is_40mhz = false;
+				il->ht.is_40mhz = false;
 			}
 		} else
-			ctx->ht.is_40mhz = false;
+			il->ht.is_40mhz = false;
 
 		/*
 		 * Default to no protection. Protection mode will
 		 * later be set from BSS config in il_ht_conf
 		 */
-		ctx->ht.protection = IEEE80211_HT_OP_MODE_PROTECTION_NONE;
+		il->ht.protection = IEEE80211_HT_OP_MODE_PROTECTION_NONE;
 
 		/* if we are switching from ht to 2.4 clear flags
 		 * from any ht related info since 2.4 does not
@@ -5460,16 +5460,15 @@ il_ht_conf(struct il_priv *il, struct ieee80211_vif *vif)
 	struct il_ht_config *ht_conf = &il->current_ht_config;
 	struct ieee80211_sta *sta;
 	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
-	struct il_rxon_context *ctx = il_rxon_ctx_from_vif(vif);
 
 	D_ASSOC("enter:\n");
 
-	if (!ctx->ht.enabled)
+	if (!il->ht.enabled)
 		return;
 
-	ctx->ht.protection =
+	il->ht.protection =
 	    bss_conf->ht_operation_mode & IEEE80211_HT_OP_MODE_PROTECTION;
-	ctx->ht.non_gf_sta_present =
+	il->ht.non_gf_sta_present =
 	    !!(bss_conf->
 	       ht_operation_mode & IEEE80211_HT_OP_MODE_NON_GF_STA_PRSNT);
 
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index 18375cb..df4d160 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -1164,13 +1164,6 @@ struct il_rxon_context {
 	 * we already removed the vif for type setting.
 	 */
 	bool always_active, is_active;
-
-	struct {
-		bool non_gf_sta_present;
-		u8 protection;
-		bool enabled, is_40mhz;
-		u8 extension_chan_offset;
-	} ht;
 };
 
 struct il_power_mgr {
@@ -1278,6 +1271,14 @@ struct il_priv {
 
 	struct il_qos_info qos_data;
 
+	struct {
+		bool enabled;
+		bool is_40mhz;
+		bool non_gf_sta_present;
+		u8 protection;
+		u8 extension_chan_offset;
+	} ht;
+
 	/*
 	 * We declare this const so it can only be
 	 * changed via explicit cast within the
-- 
1.7.1

