Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47638 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754366Ab2BCQcd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 11:32:33 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH v2 01/25] iwlegacy: move rxon commands out of ctx structure
Date: Fri,  3 Feb 2012 17:31:37 +0100
Message-Id: <1328286721-11309-2-git-send-email-sgruszka@redhat.com> (sfid-20120203_173237_848081_DF376DBD)
In-Reply-To: <1328286721-11309-1-git-send-email-sgruszka@redhat.com>
References: <1328286721-11309-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945-mac.c   |   82 +++++++--------
 drivers/net/wireless/iwlegacy/3945-rs.c    |    2 +-
 drivers/net/wireless/iwlegacy/3945.c       |   22 ++--
 drivers/net/wireless/iwlegacy/4965-calib.c |    6 +-
 drivers/net/wireless/iwlegacy/4965-mac.c   |   31 +++---
 drivers/net/wireless/iwlegacy/4965.c       |   99 +++++++++---------
 drivers/net/wireless/iwlegacy/common.c     |  157 ++++++++++++++--------------
 drivers/net/wireless/iwlegacy/common.h     |   30 ++---
 drivers/net/wireless/iwlegacy/debug.c      |    4 +-
 9 files changed, 205 insertions(+), 228 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index 54b2d39..980566f 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -672,15 +672,13 @@ il3945_get_measurement(struct il_priv *il,
 	int rc;
 	int spectrum_resp_status;
 	int duration = le16_to_cpu(params->duration);
-	struct il_rxon_context *ctx = &il->ctx;
 
 	if (il_is_associated(il))
 		add_time =
 		    il_usecs_to_beacons(il,
 					le64_to_cpu(params->start_time) -
 					il->_3945.last_tsf,
-					le16_to_cpu(ctx->timing.
-						    beacon_interval));
+					le16_to_cpu(il->timing.beacon_interval));
 
 	memset(&spectrum, 0, sizeof(spectrum));
 
@@ -694,15 +692,14 @@ il3945_get_measurement(struct il_priv *il,
 	if (il_is_associated(il))
 		spectrum.start_time =
 		    il_add_beacon_time(il, il->_3945.last_beacon_time, add_time,
-				       le16_to_cpu(ctx->timing.
-						   beacon_interval));
+				       le16_to_cpu(il->timing.beacon_interval));
 	else
 		spectrum.start_time = 0;
 
 	spectrum.channels[0].duration = cpu_to_le32(duration * TIME_UNIT);
 	spectrum.channels[0].channel = params->channel;
 	spectrum.channels[0].type = type;
-	if (ctx->active.flags & RXON_FLG_BAND_24G_MSK)
+	if (il->active.flags & RXON_FLG_BAND_24G_MSK)
 		spectrum.flags |=
 		    RXON_FLG_BAND_24G_MSK | RXON_FLG_AUTO_DETECT_MSK |
 		    RXON_FLG_TGG_PROTECT_MSK;
@@ -2150,7 +2147,6 @@ il3945_alive_start(struct il_priv *il)
 {
 	int thermal_spin = 0;
 	u32 rfkill;
-	struct il_rxon_context *ctx = &il->ctx;
 
 	D_INFO("Runtime Alive received.\n");
 
@@ -2206,13 +2202,13 @@ il3945_alive_start(struct il_priv *il)
 
 	if (il_is_associated(il)) {
 		struct il3945_rxon_cmd *active_rxon =
-		    (struct il3945_rxon_cmd *)(&ctx->active);
+		    (struct il3945_rxon_cmd *)(&il->active);
 
-		ctx->staging.filter_flags |= RXON_FILTER_ASSOC_MSK;
+		il->staging.filter_flags |= RXON_FILTER_ASSOC_MSK;
 		active_rxon->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 	} else {
 		/* Initialize our rx_config data */
-		il_connection_init_rx_config(il, ctx);
+		il_connection_init_rx_config(il, &il->ctx);
 	}
 
 	/* Configure Bluetooth device coexistence support */
@@ -2221,7 +2217,7 @@ il3945_alive_start(struct il_priv *il)
 	set_bit(S_READY, &il->status);
 
 	/* Configure the adapter for unassociated operation */
-	il3945_commit_rxon(il, ctx);
+	il3945_commit_rxon(il, &il->ctx);
 
 	il3945_reg_txpower_periodic(il);
 
@@ -2670,7 +2666,7 @@ il3945_post_scan(struct il_priv *il)
 	 * Since setting the RXON may have been deferred while
 	 * performing the scan, fire one off if needed
 	 */
-	if (memcmp(&ctx->staging, &ctx->active, sizeof(ctx->staging)))
+	if (memcmp(&il->staging, &il->active, sizeof(il->staging)))
 		il3945_commit_rxon(il, ctx);
 }
 
@@ -2728,7 +2724,7 @@ il3945_post_associate(struct il_priv *il)
 		return;
 
 	D_ASSOC("Associated as %d to: %pM\n", ctx->vif->bss_conf.aid,
-		ctx->active.bssid_addr);
+		il->active.bssid_addr);
 
 	if (test_bit(S_EXIT_PENDING, &il->status))
 		return;
@@ -2737,30 +2733,30 @@ il3945_post_associate(struct il_priv *il)
 
 	conf = &il->hw->conf;
 
-	ctx->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
+	il->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 	il3945_commit_rxon(il, ctx);
 
 	rc = il_send_rxon_timing(il, ctx);
 	if (rc)
 		IL_WARN("C_RXON_TIMING failed - " "Attempting to continue.\n");
 
-	ctx->staging.filter_flags |= RXON_FILTER_ASSOC_MSK;
+	il->staging.filter_flags |= RXON_FILTER_ASSOC_MSK;
 
-	ctx->staging.assoc_id = cpu_to_le16(ctx->vif->bss_conf.aid);
+	il->staging.assoc_id = cpu_to_le16(ctx->vif->bss_conf.aid);
 
 	D_ASSOC("assoc id %d beacon interval %d\n", ctx->vif->bss_conf.aid,
 		ctx->vif->bss_conf.beacon_int);
 
 	if (ctx->vif->bss_conf.use_short_preamble)
-		ctx->staging.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
+		il->staging.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
 	else
-		ctx->staging.flags &= ~RXON_FLG_SHORT_PREAMBLE_MSK;
+		il->staging.flags &= ~RXON_FLG_SHORT_PREAMBLE_MSK;
 
-	if (ctx->staging.flags & RXON_FLG_BAND_24G_MSK) {
+	if (il->staging.flags & RXON_FLG_BAND_24G_MSK) {
 		if (ctx->vif->bss_conf.use_short_slot)
-			ctx->staging.flags |= RXON_FLG_SHORT_SLOT_MSK;
+			il->staging.flags |= RXON_FLG_SHORT_SLOT_MSK;
 		else
-			ctx->staging.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
+			il->staging.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
 	}
 
 	il3945_commit_rxon(il, ctx);
@@ -2902,7 +2898,7 @@ il3945_config_ap(struct il_priv *il)
 	if (!(il_is_associated(il))) {
 
 		/* RXON - unassoc (to set timing command) */
-		ctx->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
+		il->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 		il3945_commit_rxon(il, ctx);
 
 		/* RXON Timing */
@@ -2911,21 +2907,21 @@ il3945_config_ap(struct il_priv *il)
 			IL_WARN("C_RXON_TIMING failed - "
 				"Attempting to continue.\n");
 
-		ctx->staging.assoc_id = 0;
+		il->staging.assoc_id = 0;
 
 		if (vif->bss_conf.use_short_preamble)
-			ctx->staging.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
+			il->staging.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
 		else
-			ctx->staging.flags &= ~RXON_FLG_SHORT_PREAMBLE_MSK;
+			il->staging.flags &= ~RXON_FLG_SHORT_PREAMBLE_MSK;
 
-		if (ctx->staging.flags & RXON_FLG_BAND_24G_MSK) {
+		if (il->staging.flags & RXON_FLG_BAND_24G_MSK) {
 			if (vif->bss_conf.use_short_slot)
-				ctx->staging.flags |= RXON_FLG_SHORT_SLOT_MSK;
+				il->staging.flags |= RXON_FLG_SHORT_SLOT_MSK;
 			else
-				ctx->staging.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
+				il->staging.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
 		}
 		/* restore RXON assoc */
-		ctx->staging.filter_flags |= RXON_FILTER_ASSOC_MSK;
+		il->staging.filter_flags |= RXON_FILTER_ASSOC_MSK;
 		il3945_commit_rxon(il, ctx);
 	}
 	il3945_send_beacon_cmd(il);
@@ -3032,7 +3028,6 @@ il3945_configure_filter(struct ieee80211_hw *hw, unsigned int changed_flags,
 {
 	struct il_priv *il = hw->priv;
 	__le32 filter_or = 0, filter_nand = 0;
-	struct il_rxon_context *ctx = &il->ctx;
 
 #define CHK(test, flag)	do { \
 	if (*total_flags & (test))		\
@@ -3052,8 +3047,8 @@ il3945_configure_filter(struct ieee80211_hw *hw, unsigned int changed_flags,
 
 	mutex_lock(&il->mutex);
 
-	ctx->staging.filter_flags &= ~filter_nand;
-	ctx->staging.filter_flags |= filter_or;
+	il->staging.filter_flags &= ~filter_nand;
+	il->staging.filter_flags |= filter_or;
 
 	/*
 	 * Not committing directly because hardware can perform a scan,
@@ -3170,9 +3165,8 @@ static ssize_t
 il3945_show_flags(struct device *d, struct device_attribute *attr, char *buf)
 {
 	struct il_priv *il = dev_get_drvdata(d);
-	struct il_rxon_context *ctx = &il->ctx;
 
-	return sprintf(buf, "0x%04X\n", ctx->active.flags);
+	return sprintf(buf, "0x%04X\n", il->active.flags);
 }
 
 static ssize_t
@@ -3181,17 +3175,16 @@ il3945_store_flags(struct device *d, struct device_attribute *attr,
 {
 	struct il_priv *il = dev_get_drvdata(d);
 	u32 flags = simple_strtoul(buf, NULL, 0);
-	struct il_rxon_context *ctx = &il->ctx;
 
 	mutex_lock(&il->mutex);
-	if (le32_to_cpu(ctx->staging.flags) != flags) {
+	if (le32_to_cpu(il->staging.flags) != flags) {
 		/* Cancel any currently running scans... */
 		if (il_scan_cancel_timeout(il, 100))
 			IL_WARN("Could not cancel scan.\n");
 		else {
 			D_INFO("Committing rxon.flags = 0x%04X\n", flags);
-			ctx->staging.flags = cpu_to_le32(flags);
-			il3945_commit_rxon(il, ctx);
+			il->staging.flags = cpu_to_le32(flags);
+			il3945_commit_rxon(il, &il->ctx);
 		}
 	}
 	mutex_unlock(&il->mutex);
@@ -3207,9 +3200,8 @@ il3945_show_filter_flags(struct device *d, struct device_attribute *attr,
 			 char *buf)
 {
 	struct il_priv *il = dev_get_drvdata(d);
-	struct il_rxon_context *ctx = &il->ctx;
 
-	return sprintf(buf, "0x%04X\n", le32_to_cpu(ctx->active.filter_flags));
+	return sprintf(buf, "0x%04X\n", le32_to_cpu(il->active.filter_flags));
 }
 
 static ssize_t
@@ -3217,19 +3209,18 @@ il3945_store_filter_flags(struct device *d, struct device_attribute *attr,
 			  const char *buf, size_t count)
 {
 	struct il_priv *il = dev_get_drvdata(d);
-	struct il_rxon_context *ctx = &il->ctx;
 	u32 filter_flags = simple_strtoul(buf, NULL, 0);
 
 	mutex_lock(&il->mutex);
-	if (le32_to_cpu(ctx->staging.filter_flags) != filter_flags) {
+	if (le32_to_cpu(il->staging.filter_flags) != filter_flags) {
 		/* Cancel any currently running scans... */
 		if (il_scan_cancel_timeout(il, 100))
 			IL_WARN("Could not cancel scan.\n");
 		else {
 			D_INFO("Committing rxon.filter_flags = " "0x%04X\n",
 			       filter_flags);
-			ctx->staging.filter_flags = cpu_to_le32(filter_flags);
-			il3945_commit_rxon(il, ctx);
+			il->staging.filter_flags = cpu_to_le32(filter_flags);
+			il3945_commit_rxon(il, &il->ctx);
 		}
 	}
 	mutex_unlock(&il->mutex);
@@ -3278,9 +3269,8 @@ il3945_store_measurement(struct device *d, struct device_attribute *attr,
 			 const char *buf, size_t count)
 {
 	struct il_priv *il = dev_get_drvdata(d);
-	struct il_rxon_context *ctx = &il->ctx;
 	struct ieee80211_measurement_params params = {
-		.channel = le16_to_cpu(ctx->active.channel),
+		.channel = le16_to_cpu(il->active.channel),
 		.start_time = cpu_to_le64(il->_3945.last_tsf),
 		.duration = cpu_to_le16(1),
 	};
diff --git a/drivers/net/wireless/iwlegacy/3945-rs.c b/drivers/net/wireless/iwlegacy/3945-rs.c
index d7a83f2..40d17d7 100644
--- a/drivers/net/wireless/iwlegacy/3945-rs.c
+++ b/drivers/net/wireless/iwlegacy/3945-rs.c
@@ -944,7 +944,7 @@ il3945_rate_scale_init(struct ieee80211_hw *hw, s32 sta_id)
 	switch (il->band) {
 	case IEEE80211_BAND_2GHZ:
 		/* TODO: this always does G, not a regression */
-		if (il->ctx.active.flags & RXON_FLG_TGG_PROTECT_MSK) {
+		if (il->active.flags & RXON_FLG_TGG_PROTECT_MSK) {
 			rs_sta->tgg = 1;
 			rs_sta->expected_tpt = il3945_expected_tpt_g_prot;
 		} else
diff --git a/drivers/net/wireless/iwlegacy/3945.c b/drivers/net/wireless/iwlegacy/3945.c
index 1489b15..dc0433f 100644
--- a/drivers/net/wireless/iwlegacy/3945.c
+++ b/drivers/net/wireless/iwlegacy/3945.c
@@ -1388,7 +1388,7 @@ il3945_send_tx_power(struct il_priv *il)
 	int rate_idx, i;
 	const struct il_channel_info *ch_info = NULL;
 	struct il3945_txpowertable_cmd txpower = {
-		.channel = il->ctx.active.channel,
+		.channel = il->active.channel,
 	};
 	u16 chan;
 
@@ -1397,7 +1397,7 @@ il3945_send_tx_power(struct il_priv *il)
 	     "TX Power requested while scanning!\n"))
 		return -EAGAIN;
 
-	chan = le16_to_cpu(il->ctx.active.channel);
+	chan = le16_to_cpu(il->active.channel);
 
 	txpower.band = (il->band == IEEE80211_BAND_5GHZ) ? 0 : 1;
 	ch_info = il_get_channel_info(il, il->band, chan);
@@ -1673,8 +1673,8 @@ il3945_send_rxon_assoc(struct il_priv *il, struct il_rxon_context *ctx)
 		.flags = CMD_WANT_SKB,
 		.data = &rxon_assoc,
 	};
-	const struct il_rxon_cmd *rxon1 = &ctx->staging;
-	const struct il_rxon_cmd *rxon2 = &ctx->active;
+	const struct il_rxon_cmd *rxon1 = &il->staging;
+	const struct il_rxon_cmd *rxon2 = &il->active;
 
 	if (rxon1->flags == rxon2->flags &&
 	    rxon1->filter_flags == rxon2->filter_flags &&
@@ -1684,10 +1684,10 @@ il3945_send_rxon_assoc(struct il_priv *il, struct il_rxon_context *ctx)
 		return 0;
 	}
 
-	rxon_assoc.flags = ctx->staging.flags;
-	rxon_assoc.filter_flags = ctx->staging.filter_flags;
-	rxon_assoc.ofdm_basic_rates = ctx->staging.ofdm_basic_rates;
-	rxon_assoc.cck_basic_rates = ctx->staging.cck_basic_rates;
+	rxon_assoc.flags = il->staging.flags;
+	rxon_assoc.filter_flags = il->staging.filter_flags;
+	rxon_assoc.ofdm_basic_rates = il->staging.ofdm_basic_rates;
+	rxon_assoc.cck_basic_rates = il->staging.cck_basic_rates;
 	rxon_assoc.reserved = 0;
 
 	rc = il_send_cmd_sync(il, &cmd);
@@ -1717,8 +1717,8 @@ int
 il3945_commit_rxon(struct il_priv *il, struct il_rxon_context *ctx)
 {
 	/* cast away the const for active_rxon in this function */
-	struct il3945_rxon_cmd *active_rxon = (void *)&ctx->active;
-	struct il3945_rxon_cmd *staging_rxon = (void *)&ctx->staging;
+	struct il3945_rxon_cmd *active_rxon = (void *)&il->active;
+	struct il3945_rxon_cmd *staging_rxon = (void *)&il->staging;
 	int rc = 0;
 	bool new_assoc = !!(staging_rxon->filter_flags & RXON_FILTER_ASSOC_MSK);
 
@@ -1776,7 +1776,7 @@ il3945_commit_rxon(struct il_priv *il, struct il_rxon_context *ctx)
 		active_rxon->reserved4 = 0;
 		active_rxon->reserved5 = 0;
 		rc = il_send_cmd_pdu(il, C_RXON, sizeof(struct il3945_rxon_cmd),
-				     &il->ctx.active);
+				     &il->active);
 
 		/* If the mask clearing failed then we set
 		 * active_rxon back to what it was previously */
diff --git a/drivers/net/wireless/iwlegacy/4965-calib.c b/drivers/net/wireless/iwlegacy/4965-calib.c
index d3248e3..f302a6a 100644
--- a/drivers/net/wireless/iwlegacy/4965-calib.c
+++ b/drivers/net/wireless/iwlegacy/4965-calib.c
@@ -806,8 +806,6 @@ il4965_chain_noise_calibration(struct il_priv *il, void *stat_resp)
 	unsigned long flags;
 	struct stats_rx_non_phy *rx_info;
 
-	struct il_rxon_context *ctx = &il->ctx;
-
 	if (il->disable_chain_noise_cal)
 		return;
 
@@ -833,8 +831,8 @@ il4965_chain_noise_calibration(struct il_priv *il, void *stat_resp)
 		return;
 	}
 
-	rxon_band24 = !!(ctx->staging.flags & RXON_FLG_BAND_24G_MSK);
-	rxon_chnum = le16_to_cpu(ctx->staging.channel);
+	rxon_band24 = !!(il->staging.flags & RXON_FLG_BAND_24G_MSK);
+	rxon_chnum = le16_to_cpu(il->staging.channel);
 
 	stat_band24 =
 	    !!(((struct il_notif_stats *)stat_resp)->
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 1667232..6a77f41 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -926,8 +926,7 @@ il4965_request_scan(struct il_priv *il, struct ieee80211_vif *vif)
 	case IEEE80211_BAND_2GHZ:
 		scan->flags = RXON_FLG_BAND_24G_MSK | RXON_FLG_AUTO_DETECT_MSK;
 		chan_mod =
-		    le32_to_cpu(il->ctx.active.
-				flags & RXON_FLG_CHANNEL_MODE_MSK) >>
+		    le32_to_cpu(il->active.flags & RXON_FLG_CHANNEL_MODE_MSK) >>
 		    RXON_FLG_CHANNEL_MODE_POS;
 		if (chan_mod == CHANNEL_MODE_PURE_40) {
 			rate = RATE_6M_PLCP;
@@ -1164,14 +1163,14 @@ il4965_set_rxon_chain(struct il_priv *il, struct il_rxon_context *ctx)
 	rx_chain |= active_rx_cnt << RXON_RX_CHAIN_MIMO_CNT_POS;
 	rx_chain |= idle_rx_cnt << RXON_RX_CHAIN_CNT_POS;
 
-	ctx->staging.rx_chain = cpu_to_le16(rx_chain);
+	il->staging.rx_chain = cpu_to_le16(rx_chain);
 
 	if (!is_single && active_rx_cnt >= IL_NUM_RX_CHAINS_SINGLE && is_cam)
-		ctx->staging.rx_chain |= RXON_RX_CHAIN_MIMO_FORCE_MSK;
+		il->staging.rx_chain |= RXON_RX_CHAIN_MIMO_FORCE_MSK;
 	else
-		ctx->staging.rx_chain &= ~RXON_RX_CHAIN_MIMO_FORCE_MSK;
+		il->staging.rx_chain &= ~RXON_RX_CHAIN_MIMO_FORCE_MSK;
 
-	D_ASSOC("rx_chain=0x%X active=%d idle=%d\n", ctx->staging.rx_chain,
+	D_ASSOC("rx_chain=0x%X active=%d idle=%d\n", il->staging.rx_chain,
 		active_rx_cnt, idle_rx_cnt);
 
 	WARN_ON(active_rx_cnt == 0 || idle_rx_cnt == 0 ||
@@ -3378,7 +3377,7 @@ il4965_update_chain_flags(struct il_priv *il)
 {
 	if (il->cfg->ops->hcmd->set_rxon_chain) {
 		il->cfg->ops->hcmd->set_rxon_chain(il, &il->ctx);
-		if (il->ctx.active.rx_chain != il->ctx.staging.rx_chain)
+		if (il->active.rx_chain != il->staging.rx_chain)
 			il_commit_rxon(il, &il->ctx);
 	}
 }
@@ -5019,11 +5018,11 @@ il4965_alive_start(struct il_priv *il)
 
 	il->active_rate = RATES_MASK;
 
-	if (il_is_associated_ctx(ctx)) {
+	if (il_is_associated(il)) {
 		struct il_rxon_cmd *active_rxon =
-		    (struct il_rxon_cmd *)&ctx->active;
+		    (struct il_rxon_cmd *)&il->active;
 		/* apply any changes in staging */
-		ctx->staging.filter_flags |= RXON_FILTER_ASSOC_MSK;
+		il->staging.filter_flags |= RXON_FILTER_ASSOC_MSK;
 		active_rxon->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 	} else {
 		/* Initialize our rx_config data */
@@ -5768,14 +5767,14 @@ il4965_mac_channel_switch(struct ieee80211_hw *hw,
 	    test_bit(S_CHANNEL_SWITCH_PENDING, &il->status))
 		goto out;
 
-	if (!il_is_associated_ctx(ctx))
+	if (!il_is_associated(il))
 		goto out;
 
 	if (!il->cfg->ops->lib->set_channel_switch)
 		goto out;
 
 	ch = channel->hw_value;
-	if (le16_to_cpu(ctx->active.channel) == ch)
+	if (le16_to_cpu(il->active.channel) == ch)
 		goto out;
 
 	ch_info = il_get_channel_info(il, channel->band, ch);
@@ -5807,8 +5806,8 @@ il4965_mac_channel_switch(struct ieee80211_hw *hw,
 	} else
 		ctx->ht.is_40mhz = false;
 
-	if ((le16_to_cpu(ctx->staging.channel) != ch))
-		ctx->staging.flags = 0;
+	if ((le16_to_cpu(il->staging.channel) != ch))
+		il->staging.flags = 0;
 
 	il_set_rxon_channel(il, channel, ctx);
 	il_set_rxon_ht(il, ht_conf);
@@ -5860,8 +5859,8 @@ il4965_configure_filter(struct ieee80211_hw *hw, unsigned int changed_flags,
 
 	mutex_lock(&il->mutex);
 
-	il->ctx.staging.filter_flags &= ~filter_nand;
-	il->ctx.staging.filter_flags |= filter_or;
+	il->staging.filter_flags &= ~filter_nand;
+	il->staging.filter_flags |= filter_or;
 
 	/*
 	 * Not committing directly because hardware can perform a scan,
diff --git a/drivers/net/wireless/iwlegacy/4965.c b/drivers/net/wireless/iwlegacy/4965.c
index cacbc03..b34de14 100644
--- a/drivers/net/wireless/iwlegacy/4965.c
+++ b/drivers/net/wireless/iwlegacy/4965.c
@@ -1342,7 +1342,6 @@ il4965_send_tx_power(struct il_priv *il)
 	u8 band = 0;
 	bool is_ht40 = false;
 	u8 ctrl_chan_high = 0;
-	struct il_rxon_context *ctx = &il->ctx;
 
 	if (WARN_ONCE
 	    (test_bit(S_SCAN_HW, &il->status),
@@ -1351,16 +1350,16 @@ il4965_send_tx_power(struct il_priv *il)
 
 	band = il->band == IEEE80211_BAND_2GHZ;
 
-	is_ht40 = iw4965_is_ht40_channel(ctx->active.flags);
+	is_ht40 = iw4965_is_ht40_channel(il->active.flags);
 
-	if (is_ht40 && (ctx->active.flags & RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK))
+	if (is_ht40 && (il->active.flags & RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK))
 		ctrl_chan_high = 1;
 
 	cmd.band = band;
-	cmd.channel = ctx->active.channel;
+	cmd.channel = il->active.channel;
 
 	ret =
-	    il4965_fill_txpower_tbl(il, band, le16_to_cpu(ctx->active.channel),
+	    il4965_fill_txpower_tbl(il, band, le16_to_cpu(il->active.channel),
 				    is_ht40, ctrl_chan_high, &cmd.tx_power);
 	if (ret)
 		goto out;
@@ -1376,8 +1375,8 @@ il4965_send_rxon_assoc(struct il_priv *il, struct il_rxon_context *ctx)
 {
 	int ret = 0;
 	struct il4965_rxon_assoc_cmd rxon_assoc;
-	const struct il_rxon_cmd *rxon1 = &ctx->staging;
-	const struct il_rxon_cmd *rxon2 = &ctx->active;
+	const struct il_rxon_cmd *rxon1 = &il->staging;
+	const struct il_rxon_cmd *rxon2 = &il->active;
 
 	if (rxon1->flags == rxon2->flags &&
 	    rxon1->filter_flags == rxon2->filter_flags &&
@@ -1392,16 +1391,16 @@ il4965_send_rxon_assoc(struct il_priv *il, struct il_rxon_context *ctx)
 		return 0;
 	}
 
-	rxon_assoc.flags = ctx->staging.flags;
-	rxon_assoc.filter_flags = ctx->staging.filter_flags;
-	rxon_assoc.ofdm_basic_rates = ctx->staging.ofdm_basic_rates;
-	rxon_assoc.cck_basic_rates = ctx->staging.cck_basic_rates;
+	rxon_assoc.flags = il->staging.flags;
+	rxon_assoc.filter_flags = il->staging.filter_flags;
+	rxon_assoc.ofdm_basic_rates = il->staging.ofdm_basic_rates;
+	rxon_assoc.cck_basic_rates = il->staging.cck_basic_rates;
 	rxon_assoc.reserved = 0;
 	rxon_assoc.ofdm_ht_single_stream_basic_rates =
-	    ctx->staging.ofdm_ht_single_stream_basic_rates;
+	    il->staging.ofdm_ht_single_stream_basic_rates;
 	rxon_assoc.ofdm_ht_dual_stream_basic_rates =
-	    ctx->staging.ofdm_ht_dual_stream_basic_rates;
-	rxon_assoc.rx_chain_select_flags = ctx->staging.rx_chain;
+	    il->staging.ofdm_ht_dual_stream_basic_rates;
+	rxon_assoc.rx_chain_select_flags = il->staging.rx_chain;
 
 	ret =
 	    il_send_cmd_pdu_async(il, C_RXON_ASSOC, sizeof(rxon_assoc),
@@ -1414,9 +1413,9 @@ static int
 il4965_commit_rxon(struct il_priv *il, struct il_rxon_context *ctx)
 {
 	/* cast away the const for active_rxon in this function */
-	struct il_rxon_cmd *active_rxon = (void *)&ctx->active;
+	struct il_rxon_cmd *active_rxon = (void *)&il->active;
 	int ret;
-	bool new_assoc = !!(ctx->staging.filter_flags & RXON_FILTER_ASSOC_MSK);
+	bool new_assoc = !!(il->staging.filter_flags & RXON_FILTER_ASSOC_MSK);
 
 	if (!il_is_alive(il))
 		return -EBUSY;
@@ -1425,7 +1424,7 @@ il4965_commit_rxon(struct il_priv *il, struct il_rxon_context *ctx)
 		return 0;
 
 	/* always get timestamp with Rx frame */
-	ctx->staging.flags |= RXON_FLG_TSF2HOST_MSK;
+	il->staging.flags |= RXON_FLG_TSF2HOST_MSK;
 
 	ret = il_check_rxon_cmd(il, ctx);
 	if (ret) {
@@ -1438,7 +1437,7 @@ il4965_commit_rxon(struct il_priv *il, struct il_rxon_context *ctx)
 	 * abort any previous channel switch if still in process
 	 */
 	if (test_bit(S_CHANNEL_SWITCH_PENDING, &il->status) &&
-	    il->switch_channel != ctx->staging.channel) {
+	    il->switch_channel != il->staging.channel) {
 		D_11H("abort channel switch on %d\n",
 		      le16_to_cpu(il->switch_channel));
 		il_chswitch_done(il, false);
@@ -1454,7 +1453,7 @@ il4965_commit_rxon(struct il_priv *il, struct il_rxon_context *ctx)
 			return ret;
 		}
 
-		memcpy(active_rxon, &ctx->staging, sizeof(*active_rxon));
+		memcpy(active_rxon, &il->staging, sizeof(*active_rxon));
 		il_print_rx_config_cmd(il, ctx);
 		/*
 		 * We do not commit tx power settings while channel changing,
@@ -1468,7 +1467,7 @@ il4965_commit_rxon(struct il_priv *il, struct il_rxon_context *ctx)
 	 * an RXON_ASSOC and the new config wants the associated mask enabled,
 	 * we must clear the associated from the active configuration
 	 * before we apply the new config */
-	if (il_is_associated_ctx(ctx) && new_assoc) {
+	if (il_is_associated(il) && new_assoc) {
 		D_INFO("Toggling associated bit on current RXON\n");
 		active_rxon->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 
@@ -1494,7 +1493,7 @@ il4965_commit_rxon(struct il_priv *il, struct il_rxon_context *ctx)
 
 	D_INFO("Sending RXON\n" "* with%s RXON_FILTER_ASSOC_MSK\n"
 	       "* channel = %d\n" "* bssid = %pM\n", (new_assoc ? "" : "out"),
-	       le16_to_cpu(ctx->staging.channel), ctx->staging.bssid_addr);
+	       le16_to_cpu(il->staging.channel), il->staging.bssid_addr);
 
 	il_set_rxon_hwcrypto(il, ctx, !il->cfg->mod_params->sw_crypto);
 
@@ -1505,13 +1504,13 @@ il4965_commit_rxon(struct il_priv *il, struct il_rxon_context *ctx)
 	if (!new_assoc) {
 		ret =
 		    il_send_cmd_pdu(il, ctx->rxon_cmd,
-				    sizeof(struct il_rxon_cmd), &ctx->staging);
+				    sizeof(struct il_rxon_cmd), &il->staging);
 		if (ret) {
 			IL_ERR("Error setting new RXON (%d)\n", ret);
 			return ret;
 		}
 		D_INFO("Return from !new_assoc RXON.\n");
-		memcpy(active_rxon, &ctx->staging, sizeof(*active_rxon));
+		memcpy(active_rxon, &il->staging, sizeof(*active_rxon));
 		il_clear_ucode_stations(il, ctx);
 		il_restore_stations(il, ctx);
 		ret = il4965_restore_default_wep_keys(il, ctx);
@@ -1527,12 +1526,12 @@ il4965_commit_rxon(struct il_priv *il, struct il_rxon_context *ctx)
 		 */
 		ret =
 		    il_send_cmd_pdu(il, ctx->rxon_cmd,
-				    sizeof(struct il_rxon_cmd), &ctx->staging);
+				    sizeof(struct il_rxon_cmd), &il->staging);
 		if (ret) {
 			IL_ERR("Error setting new RXON (%d)\n", ret);
 			return ret;
 		}
-		memcpy(active_rxon, &ctx->staging, sizeof(*active_rxon));
+		memcpy(active_rxon, &il->staging, sizeof(*active_rxon));
 	}
 	il_print_rx_config_cmd(il, ctx);
 
@@ -1564,21 +1563,21 @@ il4965_hw_channel_switch(struct il_priv *il,
 	u16 ch;
 	u32 tsf_low;
 	u8 switch_count;
-	u16 beacon_interval = le16_to_cpu(ctx->timing.beacon_interval);
+	u16 beacon_interval = le16_to_cpu(il->timing.beacon_interval);
 	struct ieee80211_vif *vif = ctx->vif;
 	band = il->band == IEEE80211_BAND_2GHZ;
 
-	is_ht40 = iw4965_is_ht40_channel(ctx->staging.flags);
+	is_ht40 = iw4965_is_ht40_channel(il->staging.flags);
 
-	if (is_ht40 && (ctx->staging.flags & RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK))
+	if (is_ht40 && (il->staging.flags & RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK))
 		ctrl_chan_high = 1;
 
 	cmd.band = band;
 	cmd.expect_beacon = 0;
 	ch = ch_switch->channel->hw_value;
 	cmd.channel = cpu_to_le16(ch);
-	cmd.rxon_flags = ctx->staging.flags;
-	cmd.rxon_filter_flags = ctx->staging.filter_flags;
+	cmd.rxon_flags = il->staging.flags;
+	cmd.rxon_filter_flags = il->staging.filter_flags;
 	switch_count = ch_switch->count;
 	tsf_low = ch_switch->timestamp & 0x0ffffffff;
 	/*
@@ -1611,7 +1610,7 @@ il4965_hw_channel_switch(struct il_priv *il,
 		cmd.expect_beacon = il_is_channel_radar(ch_info);
 	else {
 		IL_ERR("invalid channel switch from %u to %u\n",
-		       ctx->active.channel, ch);
+		       il->active.channel, ch);
 		return -EFAULT;
 	}
 
@@ -2139,7 +2138,7 @@ il4965_post_scan(struct il_priv *il)
 	 * Since setting the RXON may have been deferred while
 	 * performing the scan, fire one off if needed
 	 */
-	if (memcmp(&ctx->staging, &ctx->active, sizeof(ctx->staging)))
+	if (memcmp(&il->staging, &il->active, sizeof(il->staging)))
 		il_commit_rxon(il, ctx);
 }
 
@@ -2161,41 +2160,41 @@ il4965_post_associate(struct il_priv *il)
 
 	conf = &il->hw->conf;
 
-	ctx->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
+	il->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 	il_commit_rxon(il, ctx);
 
 	ret = il_send_rxon_timing(il, ctx);
 	if (ret)
 		IL_WARN("RXON timing - " "Attempting to continue.\n");
 
-	ctx->staging.filter_flags |= RXON_FILTER_ASSOC_MSK;
+	il->staging.filter_flags |= RXON_FILTER_ASSOC_MSK;
 
 	il_set_rxon_ht(il, &il->current_ht_config);
 
 	if (il->cfg->ops->hcmd->set_rxon_chain)
 		il->cfg->ops->hcmd->set_rxon_chain(il, ctx);
 
-	ctx->staging.assoc_id = cpu_to_le16(vif->bss_conf.aid);
+	il->staging.assoc_id = cpu_to_le16(vif->bss_conf.aid);
 
 	D_ASSOC("assoc id %d beacon interval %d\n", vif->bss_conf.aid,
 		vif->bss_conf.beacon_int);
 
 	if (vif->bss_conf.use_short_preamble)
-		ctx->staging.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
+		il->staging.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
 	else
-		ctx->staging.flags &= ~RXON_FLG_SHORT_PREAMBLE_MSK;
+		il->staging.flags &= ~RXON_FLG_SHORT_PREAMBLE_MSK;
 
-	if (ctx->staging.flags & RXON_FLG_BAND_24G_MSK) {
+	if (il->staging.flags & RXON_FLG_BAND_24G_MSK) {
 		if (vif->bss_conf.use_short_slot)
-			ctx->staging.flags |= RXON_FLG_SHORT_SLOT_MSK;
+			il->staging.flags |= RXON_FLG_SHORT_SLOT_MSK;
 		else
-			ctx->staging.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
+			il->staging.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
 	}
 
 	il_commit_rxon(il, ctx);
 
 	D_ASSOC("Associated as %d to: %pM\n", vif->bss_conf.aid,
-		ctx->active.bssid_addr);
+		il->active.bssid_addr);
 
 	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
@@ -2233,10 +2232,10 @@ il4965_config_ap(struct il_priv *il)
 		return;
 
 	/* The following should be done only at AP bring up */
-	if (!il_is_associated_ctx(ctx)) {
+	if (!il_is_associated(il)) {
 
 		/* RXON - unassoc (to set timing command) */
-		ctx->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
+		il->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 		il_commit_rxon(il, ctx);
 
 		/* RXON Timing */
@@ -2251,23 +2250,23 @@ il4965_config_ap(struct il_priv *il)
 		if (il->cfg->ops->hcmd->set_rxon_chain)
 			il->cfg->ops->hcmd->set_rxon_chain(il, ctx);
 
-		ctx->staging.assoc_id = 0;
+		il->staging.assoc_id = 0;
 
 		if (vif->bss_conf.use_short_preamble)
-			ctx->staging.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
+			il->staging.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
 		else
-			ctx->staging.flags &= ~RXON_FLG_SHORT_PREAMBLE_MSK;
+			il->staging.flags &= ~RXON_FLG_SHORT_PREAMBLE_MSK;
 
-		if (ctx->staging.flags & RXON_FLG_BAND_24G_MSK) {
+		if (il->staging.flags & RXON_FLG_BAND_24G_MSK) {
 			if (vif->bss_conf.use_short_slot)
-				ctx->staging.flags |= RXON_FLG_SHORT_SLOT_MSK;
+				il->staging.flags |= RXON_FLG_SHORT_SLOT_MSK;
 			else
-				ctx->staging.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
+				il->staging.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
 		}
 		/* need to send beacon cmd before committing assoc RXON! */
 		il4965_send_beacon_cmd(il);
 		/* restore RXON assoc */
-		ctx->staging.filter_flags |= RXON_FILTER_ASSOC_MSK;
+		il->staging.filter_flags |= RXON_FILTER_ASSOC_MSK;
 		il_commit_rxon(il, ctx);
 	}
 	il4965_send_beacon_cmd(il);
diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index 36454d0..2b56226 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -2361,7 +2361,7 @@ il_is_lq_table_valid(struct il_priv *il, struct il_rxon_context *ctx,
 	if (ctx->ht.enabled)
 		return true;
 
-	D_INFO("Channel %u is not an HT channel\n", ctx->active.channel);
+	D_INFO("Channel %u is not an HT channel\n", il->active.channel);
 	for (i = 0; i < LINK_QUAL_MAX_RETRY_NUM; i++) {
 		if (le32_to_cpu(lq->rs_table[i].rate_n_flags) & RATE_MCS_HT_MSK) {
 			D_INFO("idx %d of LQ expects HT channel\n", i);
@@ -2648,7 +2648,7 @@ il_set_decrypted_flag(struct il_priv *il, struct ieee80211_hdr *hdr,
 	 * All contexts have the same setting here due to it being
 	 * a module parameter, so OK to check any context.
 	 */
-	if (il->ctx.active.filter_flags & RXON_FILTER_DIS_DECRYPT_MSK)
+	if (il->active.filter_flags & RXON_FILTER_DIS_DECRYPT_MSK)
 		return 0;
 
 	if (!(fc & IEEE80211_FCTL_PROTECTED))
@@ -3581,7 +3581,7 @@ il_is_ht40_tx_allowed(struct il_priv *il, struct il_rxon_context *ctx,
 #endif
 
 	return il_is_channel_extension(il, il->band,
-				       le16_to_cpu(ctx->staging.channel),
+				       le16_to_cpu(il->staging.channel),
 				       ctx->ht.extension_chan_offset);
 }
 EXPORT_SYMBOL(il_is_ht40_tx_allowed);
@@ -3633,10 +3633,10 @@ il_send_rxon_timing(struct il_priv *il, struct il_rxon_context *ctx)
 
 	lockdep_assert_held(&il->mutex);
 
-	memset(&ctx->timing, 0, sizeof(struct il_rxon_time_cmd));
+	memset(&il->timing, 0, sizeof(struct il_rxon_time_cmd));
 
-	ctx->timing.timestamp = cpu_to_le64(il->timestamp);
-	ctx->timing.listen_interval = cpu_to_le16(conf->listen_interval);
+	il->timing.timestamp = cpu_to_le64(il->timestamp);
+	il->timing.listen_interval = cpu_to_le16(conf->listen_interval);
 
 	beacon_int = vif ? vif->bss_conf.beacon_int : 0;
 
@@ -3644,28 +3644,28 @@ il_send_rxon_timing(struct il_priv *il, struct il_rxon_context *ctx)
 	 * TODO: For IBSS we need to get atim_win from mac80211,
 	 *       for now just always use 0
 	 */
-	ctx->timing.atim_win = 0;
+	il->timing.atim_win = 0;
 
 	beacon_int =
 	    il_adjust_beacon_interval(beacon_int,
 				      il->hw_params.max_beacon_itrvl *
 				      TIME_UNIT);
-	ctx->timing.beacon_interval = cpu_to_le16(beacon_int);
+	il->timing.beacon_interval = cpu_to_le16(beacon_int);
 
 	tsf = il->timestamp;	/* tsf is modifed by do_div: copy it */
 	interval_tm = beacon_int * TIME_UNIT;
 	rem = do_div(tsf, interval_tm);
-	ctx->timing.beacon_init_val = cpu_to_le32(interval_tm - rem);
+	il->timing.beacon_init_val = cpu_to_le32(interval_tm - rem);
 
-	ctx->timing.dtim_period = vif ? (vif->bss_conf.dtim_period ? : 1) : 1;
+	il->timing.dtim_period = vif ? (vif->bss_conf.dtim_period ? : 1) : 1;
 
 	D_ASSOC("beacon interval %d beacon timer %d beacon tim %d\n",
-		le16_to_cpu(ctx->timing.beacon_interval),
-		le32_to_cpu(ctx->timing.beacon_init_val),
-		le16_to_cpu(ctx->timing.atim_win));
+		le16_to_cpu(il->timing.beacon_interval),
+		le32_to_cpu(il->timing.beacon_init_val),
+		le16_to_cpu(il->timing.atim_win));
 
-	return il_send_cmd_pdu(il, ctx->rxon_timing_cmd, sizeof(ctx->timing),
-			       &ctx->timing);
+	return il_send_cmd_pdu(il, il->ctx.rxon_timing_cmd, sizeof(il->timing),
+			       &il->timing);
 }
 EXPORT_SYMBOL(il_send_rxon_timing);
 
@@ -3673,7 +3673,7 @@ void
 il_set_rxon_hwcrypto(struct il_priv *il, struct il_rxon_context *ctx,
 		     int hw_decrypt)
 {
-	struct il_rxon_cmd *rxon = &ctx->staging;
+	struct il_rxon_cmd *rxon = &il->staging;
 
 	if (hw_decrypt)
 		rxon->filter_flags &= ~RXON_FILTER_DIS_DECRYPT_MSK;
@@ -3687,7 +3687,7 @@ EXPORT_SYMBOL(il_set_rxon_hwcrypto);
 int
 il_check_rxon_cmd(struct il_priv *il, struct il_rxon_context *ctx)
 {
-	struct il_rxon_cmd *rxon = &ctx->staging;
+	struct il_rxon_cmd *rxon = &il->staging;
 	bool error = false;
 
 	if (rxon->flags & RXON_FLG_BAND_24G_MSK) {
@@ -3767,8 +3767,8 @@ EXPORT_SYMBOL(il_check_rxon_cmd);
 int
 il_full_rxon_required(struct il_priv *il, struct il_rxon_context *ctx)
 {
-	const struct il_rxon_cmd *staging = &ctx->staging;
-	const struct il_rxon_cmd *active = &ctx->active;
+	const struct il_rxon_cmd *staging = &il->staging;
+	const struct il_rxon_cmd *active = &il->active;
 
 #define CHK(cond)							\
 	if ((cond)) {							\
@@ -3785,7 +3785,7 @@ il_full_rxon_required(struct il_priv *il, struct il_rxon_context *ctx)
 	}
 
 	/* These items are only settable from the full RXON command */
-	CHK(!il_is_associated_ctx(ctx));
+	CHK(!il_is_associated(il));
 	CHK(compare_ether_addr(staging->bssid_addr, active->bssid_addr));
 	CHK(compare_ether_addr(staging->node_addr, active->node_addr));
 	CHK(compare_ether_addr
@@ -3825,7 +3825,7 @@ il_get_lowest_plcp(struct il_priv *il, struct il_rxon_context *ctx)
 	 * Assign the lowest rate -- should really get this from
 	 * the beacon skb from mac80211.
 	 */
-	if (ctx->staging.flags & RXON_FLG_BAND_24G_MSK)
+	if (il->staging.flags & RXON_FLG_BAND_24G_MSK)
 		return RATE_1M_PLCP;
 	else
 		return RATE_6M_PLCP;
@@ -3836,7 +3836,7 @@ static void
 _il_set_rxon_ht(struct il_priv *il, struct il_ht_config *ht_conf,
 		struct il_rxon_context *ctx)
 {
-	struct il_rxon_cmd *rxon = &ctx->staging;
+	struct il_rxon_cmd *rxon = &il->staging;
 
 	if (!ctx->ht.enabled) {
 		rxon->flags &=
@@ -3925,7 +3925,7 @@ il_get_single_channel_number(struct il_priv *il, enum ieee80211_band band)
 
 	for (i = min; i < max; i++) {
 		channel = il->channel_info[i].channel;
-		if (channel == le16_to_cpu(il->ctx.staging.channel))
+		if (channel == le16_to_cpu(il->staging.channel))
 			continue;
 
 		ch_info = il_get_channel_info(il, band, channel);
@@ -3951,14 +3951,14 @@ il_set_rxon_channel(struct il_priv *il, struct ieee80211_channel *ch,
 	enum ieee80211_band band = ch->band;
 	u16 channel = ch->hw_value;
 
-	if (le16_to_cpu(ctx->staging.channel) == channel && il->band == band)
+	if (le16_to_cpu(il->staging.channel) == channel && il->band == band)
 		return 0;
 
-	ctx->staging.channel = cpu_to_le16(channel);
+	il->staging.channel = cpu_to_le16(channel);
 	if (band == IEEE80211_BAND_5GHZ)
-		ctx->staging.flags &= ~RXON_FLG_BAND_24G_MSK;
+		il->staging.flags &= ~RXON_FLG_BAND_24G_MSK;
 	else
-		ctx->staging.flags |= RXON_FLG_BAND_24G_MSK;
+		il->staging.flags |= RXON_FLG_BAND_24G_MSK;
 
 	il->band = band;
 
@@ -3973,20 +3973,20 @@ il_set_flags_for_band(struct il_priv *il, struct il_rxon_context *ctx,
 		      enum ieee80211_band band, struct ieee80211_vif *vif)
 {
 	if (band == IEEE80211_BAND_5GHZ) {
-		ctx->staging.flags &=
+		il->staging.flags &=
 		    ~(RXON_FLG_BAND_24G_MSK | RXON_FLG_AUTO_DETECT_MSK |
 		      RXON_FLG_CCK_MSK);
-		ctx->staging.flags |= RXON_FLG_SHORT_SLOT_MSK;
+		il->staging.flags |= RXON_FLG_SHORT_SLOT_MSK;
 	} else {
 		/* Copied from il_post_associate() */
 		if (vif && vif->bss_conf.use_short_slot)
-			ctx->staging.flags |= RXON_FLG_SHORT_SLOT_MSK;
+			il->staging.flags |= RXON_FLG_SHORT_SLOT_MSK;
 		else
-			ctx->staging.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
+			il->staging.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
 
-		ctx->staging.flags |= RXON_FLG_BAND_24G_MSK;
-		ctx->staging.flags |= RXON_FLG_AUTO_DETECT_MSK;
-		ctx->staging.flags &= ~RXON_FLG_CCK_MSK;
+		il->staging.flags |= RXON_FLG_BAND_24G_MSK;
+		il->staging.flags |= RXON_FLG_AUTO_DETECT_MSK;
+		il->staging.flags &= ~RXON_FLG_CCK_MSK;
 	}
 }
 EXPORT_SYMBOL(il_set_flags_for_band);
@@ -3999,22 +3999,22 @@ il_connection_init_rx_config(struct il_priv *il, struct il_rxon_context *ctx)
 {
 	const struct il_channel_info *ch_info;
 
-	memset(&ctx->staging, 0, sizeof(ctx->staging));
+	memset(&il->staging, 0, sizeof(il->staging));
 
 	if (!ctx->vif) {
-		ctx->staging.dev_type = ctx->unused_devtype;
+		il->staging.dev_type = ctx->unused_devtype;
 	} else
 		switch (ctx->vif->type) {
 
 		case NL80211_IFTYPE_STATION:
-			ctx->staging.dev_type = ctx->station_devtype;
-			ctx->staging.filter_flags = RXON_FILTER_ACCEPT_GRP_MSK;
+			il->staging.dev_type = ctx->station_devtype;
+			il->staging.filter_flags = RXON_FILTER_ACCEPT_GRP_MSK;
 			break;
 
 		case NL80211_IFTYPE_ADHOC:
-			ctx->staging.dev_type = ctx->ibss_devtype;
-			ctx->staging.flags = RXON_FLG_SHORT_PREAMBLE_MSK;
-			ctx->staging.filter_flags =
+			il->staging.dev_type = ctx->ibss_devtype;
+			il->staging.flags = RXON_FLG_SHORT_PREAMBLE_MSK;
+			il->staging.filter_flags =
 			    RXON_FILTER_BCON_AWARE_MSK |
 			    RXON_FILTER_ACCEPT_GRP_MSK;
 			break;
@@ -4029,35 +4029,35 @@ il_connection_init_rx_config(struct il_priv *il, struct il_rxon_context *ctx)
 	/* TODO:  Figure out when short_preamble would be set and cache from
 	 * that */
 	if (!hw_to_local(il->hw)->short_preamble)
-		ctx->staging.flags &= ~RXON_FLG_SHORT_PREAMBLE_MSK;
+		il->staging.flags &= ~RXON_FLG_SHORT_PREAMBLE_MSK;
 	else
-		ctx->staging.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
+		il->staging.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
 #endif
 
 	ch_info =
-	    il_get_channel_info(il, il->band, le16_to_cpu(ctx->active.channel));
+	    il_get_channel_info(il, il->band, le16_to_cpu(il->active.channel));
 
 	if (!ch_info)
 		ch_info = &il->channel_info[0];
 
-	ctx->staging.channel = cpu_to_le16(ch_info->channel);
+	il->staging.channel = cpu_to_le16(ch_info->channel);
 	il->band = ch_info->band;
 
 	il_set_flags_for_band(il, ctx, il->band, ctx->vif);
 
-	ctx->staging.ofdm_basic_rates =
+	il->staging.ofdm_basic_rates =
 	    (IL_OFDM_RATES_MASK >> IL_FIRST_OFDM_RATE) & 0xFF;
-	ctx->staging.cck_basic_rates =
+	il->staging.cck_basic_rates =
 	    (IL_CCK_RATES_MASK >> IL_FIRST_CCK_RATE) & 0xF;
 
 	/* clear both MIX and PURE40 mode flag */
-	ctx->staging.flags &=
+	il->staging.flags &=
 	    ~(RXON_FLG_CHANNEL_MODE_MIXED | RXON_FLG_CHANNEL_MODE_PURE_40);
 	if (ctx->vif)
-		memcpy(ctx->staging.node_addr, ctx->vif->addr, ETH_ALEN);
+		memcpy(il->staging.node_addr, ctx->vif->addr, ETH_ALEN);
 
-	ctx->staging.ofdm_ht_single_stream_basic_rates = 0xff;
-	ctx->staging.ofdm_ht_dual_stream_basic_rates = 0xff;
+	il->staging.ofdm_ht_single_stream_basic_rates = 0xff;
+	il->staging.ofdm_ht_dual_stream_basic_rates = 0xff;
 }
 EXPORT_SYMBOL(il_connection_init_rx_config);
 
@@ -4084,10 +4084,10 @@ il_set_rate(struct il_priv *il)
 
 	D_RATE("Set active_rate = %0x\n", il->active_rate);
 
-	il->ctx.staging.cck_basic_rates =
+	il->staging.cck_basic_rates =
 	    (IL_CCK_BASIC_RATES_MASK >> IL_FIRST_CCK_RATE) & 0xF;
 
-	il->ctx.staging.ofdm_basic_rates =
+	il->staging.ofdm_basic_rates =
 	    (IL_OFDM_BASIC_RATES_MASK >> IL_FIRST_OFDM_RATE) & 0xFF;
 }
 EXPORT_SYMBOL(il_set_rate);
@@ -4110,16 +4110,14 @@ il_hdl_csa(struct il_priv *il, struct il_rx_buf *rxb)
 {
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	struct il_csa_notification *csa = &(pkt->u.csa_notif);
-
-	struct il_rxon_context *ctx = &il->ctx;
-	struct il_rxon_cmd *rxon = (void *)&ctx->active;
+	struct il_rxon_cmd *rxon = (void *)&il->active;
 
 	if (!test_bit(S_CHANNEL_SWITCH_PENDING, &il->status))
 		return;
 
 	if (!le32_to_cpu(csa->status) && csa->channel == il->switch_channel) {
 		rxon->channel = csa->channel;
-		ctx->staging.channel = csa->channel;
+		il->staging.channel = csa->channel;
 		D_11H("CSA notif: channel %d\n", le16_to_cpu(csa->channel));
 		il_chswitch_done(il, true);
 	} else {
@@ -4134,7 +4132,7 @@ EXPORT_SYMBOL(il_hdl_csa);
 void
 il_print_rx_config_cmd(struct il_priv *il, struct il_rxon_context *ctx)
 {
-	struct il_rxon_cmd *rxon = &ctx->staging;
+	struct il_rxon_cmd *rxon = &il->staging;
 
 	D_RADIO("RX CONFIG:\n");
 	il_print_hex_dump(il, IL_DL_RADIO, (u8 *) rxon, sizeof(*rxon));
@@ -4347,7 +4345,6 @@ il_set_tx_power(struct il_priv *il, s8 tx_power, bool force)
 	int ret;
 	s8 prev_tx_power;
 	bool defer;
-	struct il_rxon_context *ctx = &il->ctx;
 
 	lockdep_assert_held(&il->mutex);
 
@@ -4378,7 +4375,7 @@ il_set_tx_power(struct il_priv *il, s8 tx_power, bool force)
 
 	/* do not set tx power when scanning or channel changing */
 	defer = test_bit(S_SCANNING, &il->status) ||
-	    memcmp(&ctx->active, &ctx->staging, sizeof(ctx->staging));
+	    memcmp(&il->active, &il->staging, sizeof(il->staging));
 	if (defer && !force) {
 		D_INFO("Deferring tx power set\n");
 		return 0;
@@ -5379,8 +5376,8 @@ il_mac_config(struct ieee80211_hw *hw, u32 changed)
 		/* if we are switching from ht to 2.4 clear flags
 		 * from any ht related info since 2.4 does not
 		 * support ht */
-		if ((le16_to_cpu(ctx->staging.channel) != ch))
-			ctx->staging.flags = 0;
+		if ((le16_to_cpu(il->staging.channel) != ch))
+			il->staging.flags = 0;
 
 		il_set_rxon_channel(il, channel, ctx);
 		il_set_rxon_ht(il, ht_conf);
@@ -5420,7 +5417,7 @@ set_ch_out:
 	if (scan_active)
 		goto out;
 
-	if (memcmp(&ctx->active, &ctx->staging, sizeof(ctx->staging)))
+	if (memcmp(&il->active, &il->staging, sizeof(il->staging)))
 		il_commit_rxon(il, ctx);
 	else
 		D_INFO("Not re-sending same RXON configuration.\n");
@@ -5473,7 +5470,7 @@ il_mac_reset_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	/* we are restarting association process
 	 * clear RXON_FILTER_ASSOC_MSK bit
 	 */
-	ctx->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
+	il->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 	il_commit_rxon(il, ctx);
 
 	il_set_rate(il);
@@ -5555,8 +5552,8 @@ il_set_no_assoc(struct il_priv *il, struct ieee80211_vif *vif)
 	 * association and that no more packets should be
 	 * sent
 	 */
-	ctx->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-	ctx->staging.assoc_id = 0;
+	il->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
+	il->staging.assoc_id = 0;
 	il_commit_rxon(il, ctx);
 }
 
@@ -5660,13 +5657,13 @@ il_mac_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 		/* mac80211 only sets assoc when in STATION mode */
 		if (vif->type == NL80211_IFTYPE_ADHOC || bss_conf->assoc) {
-			memcpy(ctx->staging.bssid_addr, bss_conf->bssid,
+			memcpy(il->staging.bssid_addr, bss_conf->bssid,
 			       ETH_ALEN);
 
 			/* currently needed in a few places */
 			memcpy(il->bssid, bss_conf->bssid, ETH_ALEN);
 		} else {
-			ctx->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
+			il->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 		}
 
 	}
@@ -5682,21 +5679,21 @@ il_mac_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	if (changes & BSS_CHANGED_ERP_PREAMBLE) {
 		D_MAC80211("ERP_PREAMBLE %d\n", bss_conf->use_short_preamble);
 		if (bss_conf->use_short_preamble)
-			ctx->staging.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
+			il->staging.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
 		else
-			ctx->staging.flags &= ~RXON_FLG_SHORT_PREAMBLE_MSK;
+			il->staging.flags &= ~RXON_FLG_SHORT_PREAMBLE_MSK;
 	}
 
 	if (changes & BSS_CHANGED_ERP_CTS_PROT) {
 		D_MAC80211("ERP_CTS %d\n", bss_conf->use_cts_prot);
 		if (bss_conf->use_cts_prot && il->band != IEEE80211_BAND_5GHZ)
-			ctx->staging.flags |= RXON_FLG_TGG_PROTECT_MSK;
+			il->staging.flags |= RXON_FLG_TGG_PROTECT_MSK;
 		else
-			ctx->staging.flags &= ~RXON_FLG_TGG_PROTECT_MSK;
+			il->staging.flags &= ~RXON_FLG_TGG_PROTECT_MSK;
 		if (bss_conf->use_cts_prot)
-			ctx->staging.flags |= RXON_FLG_SELF_CTS_EN;
+			il->staging.flags |= RXON_FLG_SELF_CTS_EN;
 		else
-			ctx->staging.flags &= ~RXON_FLG_SELF_CTS_EN;
+			il->staging.flags &= ~RXON_FLG_SELF_CTS_EN;
 	}
 
 	if (changes & BSS_CHANGED_BASIC_RATES) {
@@ -5706,12 +5703,12 @@ il_mac_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		 * like this here:
 		 *
 		 if (A-band)
-		 ctx->staging.ofdm_basic_rates =
+		 il->staging.ofdm_basic_rates =
 		 bss_conf->basic_rates;
 		 else
-		 ctx->staging.ofdm_basic_rates =
+		 il->staging.ofdm_basic_rates =
 		 bss_conf->basic_rates >> 4;
-		 ctx->staging.cck_basic_rates =
+		 il->staging.cck_basic_rates =
 		 bss_conf->basic_rates & 0xF;
 		 */
 	}
@@ -5734,19 +5731,19 @@ il_mac_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			il_set_no_assoc(il, vif);
 	}
 
-	if (changes && il_is_associated_ctx(ctx) && bss_conf->aid) {
+	if (changes && il_is_associated(il) && bss_conf->aid) {
 		D_MAC80211("Changes (%#x) while associated\n", changes);
 		ret = il_send_rxon_assoc(il, ctx);
 		if (!ret) {
 			/* Sync active_rxon with latest change. */
-			memcpy((void *)&ctx->active, &ctx->staging,
+			memcpy((void *)&il->active, &il->staging,
 			       sizeof(struct il_rxon_cmd));
 		}
 	}
 
 	if (changes & BSS_CHANGED_BEACON_ENABLED) {
 		if (vif->bss_conf.enable_beacon) {
-			memcpy(ctx->staging.bssid_addr, bss_conf->bssid,
+			memcpy(il->staging.bssid_addr, bss_conf->bssid,
 			       ETH_ALEN);
 			memcpy(il->bssid, bss_conf->bssid, ETH_ALEN);
 			il->cfg->ops->legacy->config_ap(il);
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index abfa388..ba801c7 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -1171,17 +1171,6 @@ struct il_rxon_context {
 	u32 interface_modes, exclusive_interface_modes;
 	u8 unused_devtype, ap_devtype, ibss_devtype, station_devtype;
 
-	/*
-	 * We declare this const so it can only be
-	 * changed via explicit cast within the
-	 * routines that actually update the physical
-	 * hardware.
-	 */
-	const struct il_rxon_cmd active;
-	struct il_rxon_cmd staging;
-
-	struct il_rxon_time_cmd timing;
-
 	struct il_qos_info qos_data;
 
 	u8 bcast_sta_id, ap_sta_id;
@@ -1306,6 +1295,17 @@ struct il_priv {
 
 	struct il_rxon_context ctx;
 
+	/*
+	 * We declare this const so it can only be
+	 * changed via explicit cast within the
+	 * routines that actually update the physical
+	 * hardware.
+	 */
+	const struct il_rxon_cmd active;
+	struct il_rxon_cmd staging;
+
+	struct il_rxon_time_cmd timing;
+
 	__le16 switch_channel;
 
 	/* 1st responses from initialize and runtime uCode images.
@@ -1530,7 +1530,7 @@ il_rxon_ctx_from_vif(struct ieee80211_vif *vif)
 static inline int
 il_is_associated(struct il_priv *il)
 {
-	return (il->ctx.active.filter_flags & RXON_FILTER_ASSOC_MSK) ? 1 : 0;
+	return (il->active.filter_flags & RXON_FILTER_ASSOC_MSK) ? 1 : 0;
 }
 
 static inline int
@@ -1540,12 +1540,6 @@ il_is_any_associated(struct il_priv *il)
 }
 
 static inline int
-il_is_associated_ctx(struct il_rxon_context *ctx)
-{
-	return (ctx->active.filter_flags & RXON_FILTER_ASSOC_MSK) ? 1 : 0;
-}
-
-static inline int
 il_is_channel_valid(const struct il_channel_info *ch_info)
 {
 	if (ch_info == NULL)
diff --git a/drivers/net/wireless/iwlegacy/debug.c b/drivers/net/wireless/iwlegacy/debug.c
index b1b8926..6e3841b 100644
--- a/drivers/net/wireless/iwlegacy/debug.c
+++ b/drivers/net/wireless/iwlegacy/debug.c
@@ -1153,7 +1153,7 @@ il_dbgfs_rxon_flags_read(struct file *file, char __user *user_buf,
 	int len = 0;
 	char buf[20];
 
-	len = sprintf(buf, "0x%04X\n", le32_to_cpu(il->ctx.active.flags));
+	len = sprintf(buf, "0x%04X\n", le32_to_cpu(il->active.flags));
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
 
@@ -1167,7 +1167,7 @@ il_dbgfs_rxon_filter_flags_read(struct file *file, char __user *user_buf,
 	char buf[20];
 
 	len =
-	    sprintf(buf, "0x%04X\n", le32_to_cpu(il->ctx.active.filter_flags));
+	    sprintf(buf, "0x%04X\n", le32_to_cpu(il->active.filter_flags));
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
 
-- 
1.7.1

