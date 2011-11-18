Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29312 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755970Ab1KRIVr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:21:47 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAI8Llqe026153
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 03:21:47 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 27/77] iwlegacy: remove for_each_context
Date: Fri, 18 Nov 2011 09:21:49 +0100
Message-Id: <1321604559-10707-27-git-send-email-sgruszka@redhat.com> (sfid-20111118_092155_090543_8878E388)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We do not support many contexts.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/iwl-4965-sta.c |   11 +--
 drivers/net/wireless/iwlegacy/iwl-core.c     |  204 ++++++++++----------------
 drivers/net/wireless/iwlegacy/iwl-debugfs.c  |   28 ++--
 drivers/net/wireless/iwlegacy/iwl-scan.c     |   20 +--
 drivers/net/wireless/iwlegacy/iwl-sta.h      |   22 ++--
 drivers/net/wireless/iwlegacy/iwl3945-base.c |    4 +-
 drivers/net/wireless/iwlegacy/iwl4965-base.c |   52 ++-----
 7 files changed, 127 insertions(+), 214 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-sta.c b/drivers/net/wireless/iwlegacy/iwl-4965-sta.c
index 4cda277..337bf0c 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-sta.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-sta.c
@@ -615,16 +615,7 @@ static int il4965_update_bcast_station(struct il_priv *il,
 
 int il4965_update_bcast_stations(struct il_priv *il)
 {
-	struct il_rxon_context *ctx;
-	int ret = 0;
-
-	for_each_context(il, ctx) {
-		ret = il4965_update_bcast_station(il, ctx);
-		if (ret)
-			break;
-	}
-
-	return ret;
+	return il4965_update_bcast_station(il, &il->ctx);
 }
 
 /**
diff --git a/drivers/net/wireless/iwlegacy/iwl-core.c b/drivers/net/wireless/iwlegacy/iwl-core.c
index de952fb..bd222f5 100644
--- a/drivers/net/wireless/iwlegacy/iwl-core.c
+++ b/drivers/net/wireless/iwlegacy/iwl-core.c
@@ -646,10 +646,7 @@ static void _il_set_rxon_ht(struct il_priv *il,
 
 void il_set_rxon_ht(struct il_priv *il, struct il_ht_config *ht_conf)
 {
-	struct il_rxon_context *ctx;
-
-	for_each_context(il, ctx)
-		_il_set_rxon_ht(il, ht_conf, ctx);
+	_il_set_rxon_ht(il, ht_conf, &il->ctx);
 }
 EXPORT_SYMBOL(il_set_rxon_ht);
 
@@ -661,7 +658,6 @@ u8 il_get_single_channel_number(struct il_priv *il,
 	int i;
 	u8 channel = 0;
 	u8 min, max;
-	struct il_rxon_context *ctx;
 
 	if (band == IEEE80211_BAND_5GHZ) {
 		min = 14;
@@ -672,19 +668,10 @@ u8 il_get_single_channel_number(struct il_priv *il,
 	}
 
 	for (i = min; i < max; i++) {
-		bool busy = false;
-
-		for_each_context(il, ctx) {
-			busy = il->channel_info[i].channel ==
-				le16_to_cpu(ctx->staging.channel);
-			if (busy)
-				break;
-		}
-
-		if (busy)
+		channel = il->channel_info[i].channel;
+		if (channel == le16_to_cpu(il->ctx.staging.channel))
 			continue;
 
-		channel = il->channel_info[i].channel;
 		ch_info = il_get_channel_info(il, band, channel);
 		if (il_is_channel_valid(ch_info))
 			break;
@@ -822,7 +809,6 @@ void il_set_rate(struct il_priv *il)
 {
 	const struct ieee80211_supported_band *hw = NULL;
 	struct ieee80211_rate *rate;
-	struct il_rxon_context *ctx;
 	int i;
 
 	hw = il_get_hw_mode(il, il->band);
@@ -841,13 +827,11 @@ void il_set_rate(struct il_priv *il)
 
 	D_RATE("Set active_rate = %0x\n", il->active_rate);
 
-	for_each_context(il, ctx) {
-		ctx->staging.cck_basic_rates =
+	il->ctx.staging.cck_basic_rates =
 		    (IL_CCK_BASIC_RATES_MASK >> IL_FIRST_CCK_RATE) & 0xF;
 
-		ctx->staging.ofdm_basic_rates =
+	il->ctx.staging.ofdm_basic_rates =
 		   (IL_OFDM_BASIC_RATES_MASK >> IL_FIRST_OFDM_RATE) & 0xFF;
-	}
 }
 EXPORT_SYMBOL(il_set_rate);
 
@@ -1254,7 +1238,6 @@ int il_mac_conf_tx(struct ieee80211_hw *hw,
 			   const struct ieee80211_tx_queue_params *params)
 {
 	struct il_priv *il = hw->priv;
-	struct il_rxon_context *ctx;
 	unsigned long flags;
 	int q;
 
@@ -1274,17 +1257,15 @@ int il_mac_conf_tx(struct ieee80211_hw *hw,
 
 	spin_lock_irqsave(&il->lock, flags);
 
-	for_each_context(il, ctx) {
-		ctx->qos_data.def_qos_parm.ac[q].cw_min =
+	il->ctx.qos_data.def_qos_parm.ac[q].cw_min =
 			cpu_to_le16(params->cw_min);
-		ctx->qos_data.def_qos_parm.ac[q].cw_max =
+	il->ctx.qos_data.def_qos_parm.ac[q].cw_max =
 			cpu_to_le16(params->cw_max);
-		ctx->qos_data.def_qos_parm.ac[q].aifsn = params->aifs;
-		ctx->qos_data.def_qos_parm.ac[q].edca_txop =
+	il->ctx.qos_data.def_qos_parm.ac[q].aifsn = params->aifs;
+	il->ctx.qos_data.def_qos_parm.ac[q].edca_txop =
 				cpu_to_le16((params->txop * 32));
 
-		ctx->qos_data.def_qos_parm.ac[q].reserved1 = 0;
-	}
+	il->ctx.qos_data.def_qos_parm.ac[q].reserved1 = 0;
 
 	spin_unlock_irqrestore(&il->lock, flags);
 
@@ -1344,8 +1325,8 @@ il_mac_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
 	struct il_priv *il = hw->priv;
 	struct il_vif_priv *vif_priv = (void *)vif->drv_priv;
-	struct il_rxon_context *tmp, *ctx = NULL;
 	int err;
+	u32 modes;
 
 	D_MAC80211("enter: type %d, addr %pM\n",
 			   vif->type, vif->addr);
@@ -1358,42 +1339,29 @@ il_mac_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 		goto out;
 	}
 
-	for_each_context(il, tmp) {
-		u32 possible_modes =
-			tmp->interface_modes | tmp->exclusive_interface_modes;
-
-		if (tmp->vif) {
-			/* check if this busy context is exclusive */
-			if (tmp->exclusive_interface_modes &
-						BIT(tmp->vif->type)) {
-				err = -EINVAL;
-				goto out;
-			}
-			continue;
-		}
 
-		if (!(possible_modes & BIT(vif->type)))
-			continue;
-
-		/* have maybe usable context w/o interface */
-		ctx = tmp;
-		break;
+	/* check if busy context is exclusive */
+	if (il->ctx.vif &&
+	    (il->ctx.exclusive_interface_modes & BIT(il->ctx.vif->type))) {
+		err = -EINVAL;
+		goto out;
 	}
 
-	if (!ctx) {
+	modes = il->ctx.interface_modes | il->ctx.exclusive_interface_modes;
+	if (!(modes & BIT(vif->type))) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
 
-	vif_priv->ctx = ctx;
-	ctx->vif = vif;
+	vif_priv->ctx = &il->ctx;
+	il->ctx.vif = vif;
 
-	err = il_setup_interface(il, ctx);
-	if (!err)
-		goto out;
+	err = il_setup_interface(il, &il->ctx);
+	if (err) {
+		il->ctx.vif = NULL;
+		il->iw_mode = NL80211_IFTYPE_STATION;
+	}
 
-	ctx->vif = NULL;
-	il->iw_mode = NL80211_IFTYPE_STATION;
  out:
 	mutex_unlock(&il->mutex);
 
@@ -1764,8 +1732,7 @@ il_mac_change_interface(struct ieee80211_hw *hw,
 {
 	struct il_priv *il = hw->priv;
 	struct il_rxon_context *ctx = il_rxon_ctx_from_vif(vif);
-	struct il_rxon_context *tmp;
-	u32 interface_modes;
+	u32 modes;
 	int err;
 
 	newtype = ieee80211_iftype_p2p(newtype, newp2p);
@@ -1781,28 +1748,16 @@ il_mac_change_interface(struct ieee80211_hw *hw,
 		goto out;
 	}
 
-	interface_modes = ctx->interface_modes | ctx->exclusive_interface_modes;
-
-	if (!(interface_modes & BIT(newtype))) {
-		err = -EBUSY;
+	modes = ctx->interface_modes | ctx->exclusive_interface_modes;
+	if (!(modes & BIT(newtype))) {
+		err = -EOPNOTSUPP;
 		goto out;
 	}
 
-	if (ctx->exclusive_interface_modes & BIT(newtype)) {
-		for_each_context(il, tmp) {
-			if (ctx == tmp)
-				continue;
-
-			if (!tmp->vif)
-				continue;
-
-			/*
-			 * The current mode switch would be exclusive, but
-			 * another context is active ... refuse the switch.
-			 */
-			err = -EBUSY;
-			goto out;
-		}
+	if ((il->ctx.exclusive_interface_modes & BIT(il->ctx.vif->type)) ||
+	    (il->ctx.exclusive_interface_modes & BIT(newtype))) {
+		err = -EINVAL;
+		goto out;
 	}
 
 	/* success */
@@ -2064,7 +2019,7 @@ int il_mac_config(struct ieee80211_hw *hw, u32 changed)
 	struct ieee80211_conf *conf = &hw->conf;
 	struct ieee80211_channel *channel = conf->channel;
 	struct il_ht_config *ht_conf = &il->current_ht_config;
-	struct il_rxon_context *ctx;
+	struct il_rxon_context *ctx = &il->ctx;
 	unsigned long flags = 0;
 	int ret = 0;
 	u16 ch;
@@ -2097,14 +2052,14 @@ int il_mac_config(struct ieee80211_hw *hw, u32 changed)
 		 * configured.
 		 */
 		if (il->cfg->ops->hcmd->set_rxon_chain)
-			for_each_context(il, ctx)
-				il->cfg->ops->hcmd->set_rxon_chain(il, ctx);
+			il->cfg->ops->hcmd->set_rxon_chain(il, &il->ctx);
 	}
 
 	/* during scanning mac80211 will delay channel setting until
 	 * scan finish with changed = 0
 	 */
 	if (!changed || (changed & IEEE80211_CONF_CHANGE_CHANNEL)) {
+
 		if (scan_active)
 			goto set_ch_out;
 
@@ -2125,48 +2080,46 @@ int il_mac_config(struct ieee80211_hw *hw, u32 changed)
 
 		spin_lock_irqsave(&il->lock, flags);
 
-		for_each_context(il, ctx) {
-			/* Configure HT40 channels */
-			if (ctx->ht.enabled != conf_is_ht(conf)) {
-				ctx->ht.enabled = conf_is_ht(conf);
-				ht_changed = true;
-			}
-			if (ctx->ht.enabled) {
-				if (conf_is_ht40_minus(conf)) {
-					ctx->ht.extension_chan_offset =
-					IEEE80211_HT_PARAM_CHA_SEC_BELOW;
-					ctx->ht.is_40mhz = true;
-				} else if (conf_is_ht40_plus(conf)) {
-					ctx->ht.extension_chan_offset =
-					IEEE80211_HT_PARAM_CHA_SEC_ABOVE;
-					ctx->ht.is_40mhz = true;
-				} else {
-					ctx->ht.extension_chan_offset =
-					IEEE80211_HT_PARAM_CHA_SEC_NONE;
-					ctx->ht.is_40mhz = false;
-				}
-			} else
+		/* Configure HT40 channels */
+		if (ctx->ht.enabled != conf_is_ht(conf)) {
+			ctx->ht.enabled = conf_is_ht(conf);
+			ht_changed = true;
+		}
+		if (ctx->ht.enabled) {
+			if (conf_is_ht40_minus(conf)) {
+				ctx->ht.extension_chan_offset =
+				IEEE80211_HT_PARAM_CHA_SEC_BELOW;
+				ctx->ht.is_40mhz = true;
+			} else if (conf_is_ht40_plus(conf)) {
+				ctx->ht.extension_chan_offset =
+				IEEE80211_HT_PARAM_CHA_SEC_ABOVE;
+				ctx->ht.is_40mhz = true;
+			} else {
+				ctx->ht.extension_chan_offset =
+				IEEE80211_HT_PARAM_CHA_SEC_NONE;
 				ctx->ht.is_40mhz = false;
+			}
+		} else
+			ctx->ht.is_40mhz = false;
 
-			/*
-			 * Default to no protection. Protection mode will
-			 * later be set from BSS config in il_ht_conf
-			 */
-			ctx->ht.protection =
-					IEEE80211_HT_OP_MODE_PROTECTION_NONE;
+		/*
+		 * Default to no protection. Protection mode will
+		 * later be set from BSS config in il_ht_conf
+		 */
+		ctx->ht.protection =
+				IEEE80211_HT_OP_MODE_PROTECTION_NONE;
 
-			/* if we are switching from ht to 2.4 clear flags
-			 * from any ht related info since 2.4 does not
-			 * support ht */
-			if ((le16_to_cpu(ctx->staging.channel) != ch))
-				ctx->staging.flags = 0;
+		/* if we are switching from ht to 2.4 clear flags
+		 * from any ht related info since 2.4 does not
+		 * support ht */
+		if ((le16_to_cpu(ctx->staging.channel) != ch))
+			ctx->staging.flags = 0;
 
-			il_set_rxon_channel(il, channel, ctx);
-			il_set_rxon_ht(il, ht_conf);
+		il_set_rxon_channel(il, channel, ctx);
+		il_set_rxon_ht(il, ht_conf);
 
-			il_set_flags_for_band(il, ctx, channel->band,
-					       ctx->vif);
-		}
+		il_set_flags_for_band(il, ctx, channel->band,
+				       ctx->vif);
 
 		spin_unlock_irqrestore(&il->lock, flags);
 
@@ -2203,15 +2156,12 @@ int il_mac_config(struct ieee80211_hw *hw, u32 changed)
 	if (scan_active)
 		goto out;
 
-	for_each_context(il, ctx) {
-		if (memcmp(&ctx->active, &ctx->staging, sizeof(ctx->staging)))
-			il_commit_rxon(il, ctx);
-		else
-			D_INFO(
-				"Not re-sending same RXON configuration.\n");
-		if (ht_changed)
-			il_update_qos(il, ctx);
-	}
+	if (memcmp(&ctx->active, &ctx->staging, sizeof(ctx->staging)))
+		il_commit_rxon(il, ctx);
+	else
+		D_INFO("Not re-sending same RXON configuration.\n");
+	if (ht_changed)
+		il_update_qos(il, ctx);
 
 out:
 	D_MAC80211("leave\n");
diff --git a/drivers/net/wireless/iwlegacy/iwl-debugfs.c b/drivers/net/wireless/iwlegacy/iwl-debugfs.c
index e8153b0..8448db7 100644
--- a/drivers/net/wireless/iwlegacy/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlegacy/iwl-debugfs.c
@@ -599,26 +599,24 @@ il_dbgfs_qos_read(struct file *file, char __user *user_buf,
 				       size_t count, loff_t *ppos)
 {
 	struct il_priv *il = file->private_data;
-	struct il_rxon_context *ctx;
+	struct il_rxon_context *ctx = &il->ctx;
 	int pos = 0, i;
 	char buf[256];
 	const size_t bufsz = sizeof(buf);
 
-	for_each_context(il, ctx) {
-		pos += scnprintf(buf + pos, bufsz - pos, "context %d:\n",
-				 ctx->ctxid);
-		for (i = 0; i < AC_NUM; i++) {
-			pos += scnprintf(buf + pos, bufsz - pos,
-				"\tcw_min\tcw_max\taifsn\ttxop\n");
-			pos += scnprintf(buf + pos, bufsz - pos,
-				"AC[%d]\t%u\t%u\t%u\t%u\n", i,
-				ctx->qos_data.def_qos_parm.ac[i].cw_min,
-				ctx->qos_data.def_qos_parm.ac[i].cw_max,
-				ctx->qos_data.def_qos_parm.ac[i].aifsn,
-				ctx->qos_data.def_qos_parm.ac[i].edca_txop);
-		}
-		pos += scnprintf(buf + pos, bufsz - pos, "\n");
+	pos += scnprintf(buf + pos, bufsz - pos, "context %d:\n",
+			 ctx->ctxid);
+	for (i = 0; i < AC_NUM; i++) {
+		pos += scnprintf(buf + pos, bufsz - pos,
+			"\tcw_min\tcw_max\taifsn\ttxop\n");
+		pos += scnprintf(buf + pos, bufsz - pos,
+			"AC[%d]\t%u\t%u\t%u\t%u\n", i,
+			ctx->qos_data.def_qos_parm.ac[i].cw_min,
+			ctx->qos_data.def_qos_parm.ac[i].cw_max,
+			ctx->qos_data.def_qos_parm.ac[i].aifsn,
+			ctx->qos_data.def_qos_parm.ac[i].edca_txop);
 	}
+
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-scan.c b/drivers/net/wireless/iwlegacy/iwl-scan.c
index 71b2fac..18226d1 100644
--- a/drivers/net/wireless/iwlegacy/iwl-scan.c
+++ b/drivers/net/wireless/iwlegacy/iwl-scan.c
@@ -290,7 +290,9 @@ u16 il_get_passive_dwell_time(struct il_priv *il,
 			       enum ieee80211_band band,
 			       struct ieee80211_vif *vif)
 {
-	struct il_rxon_context *ctx;
+	struct il_rxon_context *ctx = &il->ctx;
+	u16 value;
+
 	u16 passive = (band == IEEE80211_BAND_2GHZ) ?
 	    IL_PASSIVE_DWELL_BASE + IL_PASSIVE_DWELL_TIME_24 :
 	    IL_PASSIVE_DWELL_BASE + IL_PASSIVE_DWELL_TIME_52;
@@ -301,17 +303,11 @@ u16 il_get_passive_dwell_time(struct il_priv *il,
 		 * dwell time to be 98% of the smallest beacon interval
 		 * (minus 2 * channel tune time)
 		 */
-		for_each_context(il, ctx) {
-			u16 value;
-
-			if (!il_is_associated_ctx(ctx))
-				continue;
-			value = ctx->vif ? ctx->vif->bss_conf.beacon_int : 0;
-			if (value > IL_PASSIVE_DWELL_BASE || !value)
-				value = IL_PASSIVE_DWELL_BASE;
-			value = (value * 98) / 100 - IL_CHANNEL_TUNE_TIME * 2;
-			passive = min(value, passive);
-		}
+		value = ctx->vif ? ctx->vif->bss_conf.beacon_int : 0;
+		if (value > IL_PASSIVE_DWELL_BASE || !value)
+			value = IL_PASSIVE_DWELL_BASE;
+		value = (value * 98) / 100 - IL_CHANNEL_TUNE_TIME * 2;
+		passive = min(value, passive);
 	}
 
 	return passive;
diff --git a/drivers/net/wireless/iwlegacy/iwl-sta.h b/drivers/net/wireless/iwlegacy/iwl-sta.h
index f07cd7f..afd3003 100644
--- a/drivers/net/wireless/iwlegacy/iwl-sta.h
+++ b/drivers/net/wireless/iwlegacy/iwl-sta.h
@@ -84,7 +84,7 @@ int il_send_lq_cmd(struct il_priv *il,
 static inline void il_clear_driver_stations(struct il_priv *il)
 {
 	unsigned long flags;
-	struct il_rxon_context *ctx;
+	struct il_rxon_context *ctx = &il->ctx;
 
 	spin_lock_irqsave(&il->sta_lock, flags);
 	memset(il->stations, 0, sizeof(il->stations));
@@ -92,17 +92,15 @@ static inline void il_clear_driver_stations(struct il_priv *il)
 
 	il->ucode_key_table = 0;
 
-	for_each_context(il, ctx) {
-		/*
-		 * Remove all key information that is not stored as part
-		 * of station information since mac80211 may not have had
-		 * a chance to remove all the keys. When device is
-		 * reconfigured by mac80211 after an error all keys will
-		 * be reconfigured.
-		 */
-		memset(ctx->wep_keys, 0, sizeof(ctx->wep_keys));
-		ctx->key_mapping_keys = 0;
-	}
+	/*
+	 * Remove all key information that is not stored as part
+	 * of station information since mac80211 may not have had
+	 * a chance to remove all the keys. When device is
+	 * reconfigured by mac80211 after an error all keys will
+	 * be reconfigured.
+	 */
+	memset(ctx->wep_keys, 0, sizeof(ctx->wep_keys));
+	ctx->key_mapping_keys = 0;
 
 	spin_unlock_irqrestore(&il->sta_lock, flags);
 }
diff --git a/drivers/net/wireless/iwlegacy/iwl3945-base.c b/drivers/net/wireless/iwlegacy/iwl3945-base.c
index 41104e7..151c8fa 100644
--- a/drivers/net/wireless/iwlegacy/iwl3945-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl3945-base.c
@@ -2710,10 +2710,8 @@ static void il3945_bg_restart(struct work_struct *data)
 		return;
 
 	if (test_and_clear_bit(STATUS_FW_ERROR, &il->status)) {
-		struct il_rxon_context *ctx;
 		mutex_lock(&il->mutex);
-		for_each_context(il, ctx)
-			ctx->vif = NULL;
+		il->ctx.vif = NULL;
 		il->is_open = 0;
 		mutex_unlock(&il->mutex);
 		il3945_down(il);
diff --git a/drivers/net/wireless/iwlegacy/iwl4965-base.c b/drivers/net/wireless/iwlegacy/iwl4965-base.c
index 043d51e..df86431 100644
--- a/drivers/net/wireless/iwlegacy/iwl4965-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl4965-base.c
@@ -89,14 +89,10 @@ MODULE_ALIAS("iwl4965");
 
 void il4965_update_chain_flags(struct il_priv *il)
 {
-	struct il_rxon_context *ctx;
-
 	if (il->cfg->ops->hcmd->set_rxon_chain) {
-		for_each_context(il, ctx) {
-			il->cfg->ops->hcmd->set_rxon_chain(il, ctx);
-			if (ctx->active.rx_chain != ctx->staging.rx_chain)
-				il_commit_rxon(il, ctx);
-		}
+		il->cfg->ops->hcmd->set_rxon_chain(il, &il->ctx);
+		if (il->ctx.active.rx_chain != il->ctx.staging.rx_chain)
+			il_commit_rxon(il, &il->ctx);
 	}
 }
 
@@ -1766,10 +1762,8 @@ static void il4965_alive_start(struct il_priv *il)
 		ctx->staging.filter_flags |= RXON_FILTER_ASSOC_MSK;
 		active_rxon->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 	} else {
-		struct il_rxon_context *tmp;
 		/* Initialize our rx_config data */
-		for_each_context(il, tmp)
-			il_connection_init_rx_config(il, tmp);
+		il_connection_init_rx_config(il, &il->ctx);
 
 		if (il->cfg->ops->hcmd->set_rxon_chain)
 			il->cfg->ops->hcmd->set_rxon_chain(il, ctx);
@@ -1950,7 +1944,6 @@ static int il4965_prepare_card_hw(struct il_priv *il)
 
 static int __il4965_up(struct il_priv *il)
 {
-	struct il_rxon_context *ctx;
 	int i;
 	int ret;
 
@@ -1964,12 +1957,10 @@ static int __il4965_up(struct il_priv *il)
 		return -EIO;
 	}
 
-	for_each_context(il, ctx) {
-		ret = il4965_alloc_bcast_station(il, ctx);
-		if (ret) {
-			il_dealloc_bcast_stations(il);
-			return ret;
-		}
+	ret = il4965_alloc_bcast_station(il, &il->ctx);
+	if (ret) {
+		il_dealloc_bcast_stations(il);
+		return ret;
 	}
 
 	il4965_prepare_card_hw(il);
@@ -2121,11 +2112,8 @@ static void il4965_bg_restart(struct work_struct *data)
 		return;
 
 	if (test_and_clear_bit(STATUS_FW_ERROR, &il->status)) {
-		struct il_rxon_context *ctx;
-
 		mutex_lock(&il->mutex);
-		for_each_context(il, ctx)
-			ctx->vif = NULL;
+		il->ctx.vif = NULL;
 		il->is_open = 0;
 
 		__il4965_down(il);
@@ -2177,7 +2165,6 @@ static int il4965_mac_setup_register(struct il_priv *il,
 {
 	int ret;
 	struct ieee80211_hw *hw = il->hw;
-	struct il_rxon_context *ctx;
 
 	hw->rate_control_algorithm = "iwl-4965-rs";
 
@@ -2195,10 +2182,8 @@ static int il4965_mac_setup_register(struct il_priv *il,
 	hw->sta_data_size = sizeof(struct il_station_priv);
 	hw->vif_data_size = sizeof(struct il_vif_priv);
 
-	for_each_context(il, ctx) {
-		hw->wiphy->interface_modes |= ctx->interface_modes;
-		hw->wiphy->interface_modes |= ctx->exclusive_interface_modes;
-	}
+	hw->wiphy->interface_modes |= il->ctx.interface_modes;
+	hw->wiphy->interface_modes |= il->ctx.exclusive_interface_modes;
 
 	hw->wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY |
 			    WIPHY_FLAG_DISABLE_BEACON_HINTS;
@@ -2590,7 +2575,6 @@ void il4965_configure_filter(struct ieee80211_hw *hw,
 {
 	struct il_priv *il = hw->priv;
 	__le32 filter_or = 0, filter_nand = 0;
-	struct il_rxon_context *ctx;
 
 #define CHK(test, flag)	do { \
 	if (*total_flags & (test))		\
@@ -2611,15 +2595,13 @@ void il4965_configure_filter(struct ieee80211_hw *hw,
 
 	mutex_lock(&il->mutex);
 
-	for_each_context(il, ctx) {
-		ctx->staging.filter_flags &= ~filter_nand;
-		ctx->staging.filter_flags |= filter_or;
+	il->ctx.staging.filter_flags &= ~filter_nand;
+	il->ctx.staging.filter_flags |= filter_or;
 
-		/*
-		 * Not committing directly because hardware can perform a scan,
-		 * but we'll eventually commit the filter flags change anyway.
-		 */
-	}
+	/*
+	 * Not committing directly because hardware can perform a scan,
+	 * but we'll eventually commit the filter flags change anyway.
+	 */
 
 	mutex_unlock(&il->mutex);
 
-- 
1.7.1

