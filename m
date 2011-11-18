Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755480Ab1KRIV3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:21:29 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAI8LTQP022600
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 03:21:29 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 19/77] iwlegacy: partial rxon context cleanup
Date: Fri, 18 Nov 2011 09:21:41 +0100
Message-Id: <1321604559-10707-19-git-send-email-sgruszka@redhat.com> (sfid-20111118_092137_439799_21138F16)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/iwl-3945-rs.c    |    6 +-
 drivers/net/wireless/iwlegacy/iwl-3945.c       |   30 ++++----
 drivers/net/wireless/iwlegacy/iwl-4965-calib.c |    2 +-
 drivers/net/wireless/iwlegacy/iwl-4965-lib.c   |    4 +-
 drivers/net/wireless/iwlegacy/iwl-4965-tx.c    |    4 +-
 drivers/net/wireless/iwlegacy/iwl-4965.c       |   14 ++--
 drivers/net/wireless/iwlegacy/iwl-core.c       |   17 ++---
 drivers/net/wireless/iwlegacy/iwl-debugfs.c    |    6 +-
 drivers/net/wireless/iwlegacy/iwl-dev.h        |   27 ++------
 drivers/net/wireless/iwlegacy/iwl-rx.c         |    2 +-
 drivers/net/wireless/iwlegacy/iwl3945-base.c   |   84 +++++++++++------------
 drivers/net/wireless/iwlegacy/iwl4965-base.c   |   54 ++++++---------
 12 files changed, 111 insertions(+), 139 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-3945-rs.c b/drivers/net/wireless/iwlegacy/iwl-3945-rs.c
index 345beb7..0707301 100644
--- a/drivers/net/wireless/iwlegacy/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlegacy/iwl-3945-rs.c
@@ -342,7 +342,7 @@ void il3945_rs_rate_init(struct il_priv *il, struct ieee80211_sta *sta, u8 sta_i
 	int i;
 
 	D_INFO("enter\n");
-	if (sta_id == il->contexts[IL_RXON_CTX_BSS].bcast_sta_id)
+	if (sta_id == il->ctx.bcast_sta_id)
 		goto out;
 
 	psta = (struct il3945_sta_priv *) sta->drv_priv;
@@ -936,7 +936,7 @@ void il3945_rate_scale_init(struct ieee80211_hw *hw, s32 sta_id)
 
 	rcu_read_lock();
 
-	sta = ieee80211_find_sta(il->contexts[IL_RXON_CTX_BSS].vif,
+	sta = ieee80211_find_sta(il->ctx.vif,
 				 il->stations[sta_id].sta.sta.addr);
 	if (!sta) {
 		D_RATE("Unable to find station to initialize rate scaling.\n");
@@ -953,7 +953,7 @@ void il3945_rate_scale_init(struct ieee80211_hw *hw, s32 sta_id)
 	switch (il->band) {
 	case IEEE80211_BAND_2GHZ:
 		/* TODO: this always does G, not a regression */
-		if (il->contexts[IL_RXON_CTX_BSS].active.flags &
+		if (il->ctx.active.flags &
 						RXON_FLG_TGG_PROTECT_MSK) {
 			rs_sta->tgg = 1;
 			rs_sta->expected_tpt = il3945_expected_tpt_g_prot;
diff --git a/drivers/net/wireless/iwlegacy/iwl-3945.c b/drivers/net/wireless/iwlegacy/iwl-3945.c
index 98c74e0..ff006e7 100644
--- a/drivers/net/wireless/iwlegacy/iwl-3945.c
+++ b/drivers/net/wireless/iwlegacy/iwl-3945.c
@@ -253,7 +253,7 @@ int il3945_rs_next_rate(struct il_priv *il, int rate)
 		break;
 	case IEEE80211_BAND_2GHZ:
 		if (!(il->_3945.sta_supp_rates & IL_OFDM_RATES_MASK) &&
-		    il_is_associated(il, IL_RXON_CTX_BSS)) {
+		    il_is_associated(il)) {
 			if (rate == IL_RATE_11M_INDEX)
 				next_rate = IL_RATE_5M_INDEX;
 		}
@@ -1374,7 +1374,7 @@ static int il3945_send_tx_power(struct il_priv *il)
 	int rate_idx, i;
 	const struct il_channel_info *ch_info = NULL;
 	struct il3945_txpowertable_cmd txpower = {
-		.channel = il->contexts[IL_RXON_CTX_BSS].active.channel,
+		.channel = il->ctx.active.channel,
 	};
 	u16 chan;
 
@@ -1382,7 +1382,7 @@ static int il3945_send_tx_power(struct il_priv *il)
 		      "TX Power requested while scanning!\n"))
 		return -EAGAIN;
 
-	chan = le16_to_cpu(il->contexts[IL_RXON_CTX_BSS].active.channel);
+	chan = le16_to_cpu(il->ctx.active.channel);
 
 	txpower.band = (il->band == IEEE80211_BAND_5GHZ) ? 0 : 1;
 	ch_info = il_get_channel_info(il, il->band, chan);
@@ -1734,9 +1734,9 @@ int il3945_commit_rxon(struct il_priv *il, struct il_rxon_context *ctx)
 	 * il3945_rxon_assoc_cmd which is used to reconfigure filter
 	 * and other flags for the current radio configuration. */
 	if (!il_full_rxon_required(il,
-			&il->contexts[IL_RXON_CTX_BSS])) {
+			&il->ctx)) {
 		rc = il_send_rxon_assoc(il,
-					 &il->contexts[IL_RXON_CTX_BSS]);
+					 &il->ctx);
 		if (rc) {
 			IL_ERR("Error setting RXON_ASSOC "
 				  "configuration (%d).\n", rc);
@@ -1756,7 +1756,7 @@ int il3945_commit_rxon(struct il_priv *il, struct il_rxon_context *ctx)
 	 * an RXON_ASSOC and the new config wants the associated mask enabled,
 	 * we must clear the associated from the active configuration
 	 * before we apply the new config */
-	if (il_is_associated(il, IL_RXON_CTX_BSS) && new_assoc) {
+	if (il_is_associated(il) && new_assoc) {
 		D_INFO("Toggling associated bit on current RXON\n");
 		active_rxon->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 
@@ -1768,7 +1768,7 @@ int il3945_commit_rxon(struct il_priv *il, struct il_rxon_context *ctx)
 		active_rxon->reserved5 = 0;
 		rc = il_send_cmd_pdu(il, REPLY_RXON,
 				      sizeof(struct il3945_rxon_cmd),
-				      &il->contexts[IL_RXON_CTX_BSS].active);
+				      &il->ctx.active);
 
 		/* If the mask clearing failed then we set
 		 * active_rxon back to what it was previously */
@@ -1779,9 +1779,9 @@ int il3945_commit_rxon(struct il_priv *il, struct il_rxon_context *ctx)
 			return rc;
 		}
 		il_clear_ucode_stations(il,
-					 &il->contexts[IL_RXON_CTX_BSS]);
+					 &il->ctx);
 		il_restore_stations(il,
-					 &il->contexts[IL_RXON_CTX_BSS]);
+					 &il->ctx);
 	}
 
 	D_INFO("Sending RXON\n"
@@ -1814,9 +1814,9 @@ int il3945_commit_rxon(struct il_priv *il, struct il_rxon_context *ctx)
 
 	if (!new_assoc) {
 		il_clear_ucode_stations(il,
-					 &il->contexts[IL_RXON_CTX_BSS]);
+					 &il->ctx);
 		il_restore_stations(il,
-					&il->contexts[IL_RXON_CTX_BSS]);
+					&il->ctx);
 	}
 
 	/* If we issue a new RXON command which required a tune then we must
@@ -2252,7 +2252,7 @@ static u16 il3945_build_addsta_hcmd(const struct il_addsta_cmd *cmd,
 static int il3945_add_bssid_station(struct il_priv *il,
 				     const u8 *addr, u8 *sta_id_r)
 {
-	struct il_rxon_context *ctx = &il->contexts[IL_RXON_CTX_BSS];
+	struct il_rxon_context *ctx = &il->ctx;
 	int ret;
 	u8 sta_id;
 	unsigned long flags;
@@ -2346,7 +2346,7 @@ int il3945_init_hw_rate_table(struct il_priv *il)
 		 * 1M CCK rates */
 
 		if (!(il->_3945.sta_supp_rates & IL_OFDM_RATES_MASK) &&
-		    il_is_associated(il, IL_RXON_CTX_BSS)) {
+		    il_is_associated(il)) {
 
 			index = IL_FIRST_CCK_RATE;
 			for (i = IL_RATE_6M_INDEX_TABLE;
@@ -2401,7 +2401,7 @@ int il3945_hw_set_hw_params(struct il_priv *il)
 	il->hw_params.max_rxq_size = RX_QUEUE_SIZE;
 	il->hw_params.max_rxq_log = RX_QUEUE_SIZE_LOG;
 	il->hw_params.max_stations = IL3945_STATION_COUNT;
-	il->contexts[IL_RXON_CTX_BSS].bcast_sta_id = IL3945_BROADCAST_ID;
+	il->ctx.bcast_sta_id = IL3945_BROADCAST_ID;
 
 	il->sta_key_max_num = STA_KEY_MAX_NUM;
 
@@ -2422,7 +2422,7 @@ unsigned int il3945_hw_get_beacon_cmd(struct il_priv *il,
 	memset(tx_beacon_cmd, 0, sizeof(*tx_beacon_cmd));
 
 	tx_beacon_cmd->tx.sta_id =
-		il->contexts[IL_RXON_CTX_BSS].bcast_sta_id;
+		il->ctx.bcast_sta_id;
 	tx_beacon_cmd->tx.stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
 
 	frame_size = il3945_fill_beacon_frame(il,
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-calib.c b/drivers/net/wireless/iwlegacy/iwl-4965-calib.c
index c055a15..4c2b491 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-calib.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-calib.c
@@ -820,7 +820,7 @@ void il4965_chain_noise_calibration(struct il_priv *il, void *stat_resp)
 	unsigned long flags;
 	struct statistics_rx_non_phy *rx_info;
 
-	struct il_rxon_context *ctx = &il->contexts[IL_RXON_CTX_BSS];
+	struct il_rxon_context *ctx = &il->ctx;
 
 	if (il->disable_chain_noise_cal)
 		return;
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-lib.c b/drivers/net/wireless/iwlegacy/iwl-4965-lib.c
index da4ea24..1182bc0 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-lib.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-lib.c
@@ -782,7 +782,7 @@ int il4965_request_scan(struct il_priv *il, struct ieee80211_vif *vif)
 		.flags = CMD_SIZE_HUGE,
 	};
 	struct il_scan_cmd *scan;
-	struct il_rxon_context *ctx = &il->contexts[IL_RXON_CTX_BSS];
+	struct il_rxon_context *ctx = &il->ctx;
 	u32 rate_flags = 0;
 	u16 cmd_len;
 	u16 rx_chain = 0;
@@ -866,7 +866,7 @@ int il4965_request_scan(struct il_priv *il, struct ieee80211_vif *vif)
 	case IEEE80211_BAND_2GHZ:
 		scan->flags = RXON_FLG_BAND_24G_MSK | RXON_FLG_AUTO_DETECT_MSK;
 		chan_mod = le32_to_cpu(
-			il->contexts[IL_RXON_CTX_BSS].active.flags &
+			il->ctx.active.flags &
 						RXON_FLG_CHANNEL_MODE_MSK)
 				       >> RXON_FLG_CHANNEL_MODE_POS;
 		if (chan_mod == CHANNEL_MODE_PURE_40) {
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-tx.c b/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
index cbc6feb..94d77e2 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
@@ -277,7 +277,7 @@ int il4965_tx_skb(struct il_priv *il, struct sk_buff *skb)
 	struct il_device_cmd *out_cmd;
 	struct il_cmd_meta *out_meta;
 	struct il_tx_cmd *tx_cmd;
-	struct il_rxon_context *ctx = &il->contexts[IL_RXON_CTX_BSS];
+	struct il_rxon_context *ctx = &il->ctx;
 	int txq_id;
 	dma_addr_t phys_addr;
 	dma_addr_t txcmd_phys;
@@ -1041,7 +1041,7 @@ int il4965_txq_check_empty(struct il_priv *il,
 	struct il_tid_data *tid_data = &il->stations[sta_id].tid[tid];
 	struct il_rxon_context *ctx;
 
-	ctx = &il->contexts[il->stations[sta_id].ctxid];
+	ctx = &il->ctx;
 
 	lockdep_assert_held(&il->sta_lock);
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965.c b/drivers/net/wireless/iwlegacy/iwl-4965.c
index 4917b0d..457aa40 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965.c
@@ -403,7 +403,7 @@ static int il4965_hw_set_hw_params(struct il_priv *il)
 			sizeof(struct il4965_scd_bc_tbl);
 	il->hw_params.tfd_size = sizeof(struct il_tfd);
 	il->hw_params.max_stations = IL4965_STATION_COUNT;
-	il->contexts[IL_RXON_CTX_BSS].bcast_sta_id = IL4965_BROADCAST_ID;
+	il->ctx.bcast_sta_id = IL4965_BROADCAST_ID;
 	il->hw_params.max_data_size = IL49_RTC_DATA_SIZE;
 	il->hw_params.max_inst_size = IL49_RTC_INST_SIZE;
 	il->hw_params.max_bsm_size = BSM_SRAM_SIZE;
@@ -1121,7 +1121,7 @@ static int il4965_send_tx_power(struct il_priv *il)
 	u8 band = 0;
 	bool is_ht40 = false;
 	u8 ctrl_chan_high = 0;
-	struct il_rxon_context *ctx = &il->contexts[IL_RXON_CTX_BSS];
+	struct il_rxon_context *ctx = &il->ctx;
 
 	if (WARN_ONCE(test_bit(STATUS_SCAN_HW, &il->status),
 		      "TX Power requested while scanning!\n"))
@@ -1333,7 +1333,7 @@ static int il4965_commit_rxon(struct il_priv *il, struct il_rxon_context *ctx)
 static int il4965_hw_channel_switch(struct il_priv *il,
 				     struct ieee80211_channel_switch *ch_switch)
 {
-	struct il_rxon_context *ctx = &il->contexts[IL_RXON_CTX_BSS];
+	struct il_rxon_context *ctx = &il->ctx;
 	int rc;
 	u8 band = 0;
 	bool is_ht40 = false;
@@ -1726,7 +1726,7 @@ static u8 il4965_find_station(struct il_priv *il, const u8 *addr)
 		start = IL_STA_ID;
 
 	if (is_broadcast_ether_addr(addr))
-		return il->contexts[IL_RXON_CTX_BSS].bcast_sta_id;
+		return il->ctx.bcast_sta_id;
 
 	spin_lock_irqsave(&il->sta_lock, flags);
 	for (i = start; i < il->hw_params.max_stations; i++)
@@ -1911,7 +1911,7 @@ static struct il_hcmd_ops il4965_hcmd = {
 
 static void il4965_post_scan(struct il_priv *il)
 {
-	struct il_rxon_context *ctx = &il->contexts[IL_RXON_CTX_BSS];
+	struct il_rxon_context *ctx = &il->ctx;
 
 	/*
 	 * Since setting the RXON may have been deferred while
@@ -1923,7 +1923,7 @@ static void il4965_post_scan(struct il_priv *il)
 
 static void il4965_post_associate(struct il_priv *il)
 {
-	struct il_rxon_context *ctx = &il->contexts[IL_RXON_CTX_BSS];
+	struct il_rxon_context *ctx = &il->ctx;
 	struct ieee80211_vif *vif = ctx->vif;
 	struct ieee80211_conf *conf = NULL;
 	int ret = 0;
@@ -2000,7 +2000,7 @@ static void il4965_post_associate(struct il_priv *il)
 
 static void il4965_config_ap(struct il_priv *il)
 {
-	struct il_rxon_context *ctx = &il->contexts[IL_RXON_CTX_BSS];
+	struct il_rxon_context *ctx = &il->ctx;
 	struct ieee80211_vif *vif = ctx->vif;
 	int ret = 0;
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-core.c b/drivers/net/wireless/iwlegacy/iwl-core.c
index e9ca265..7afdd80 100644
--- a/drivers/net/wireless/iwlegacy/iwl-core.c
+++ b/drivers/net/wireless/iwlegacy/iwl-core.c
@@ -853,7 +853,7 @@ EXPORT_SYMBOL(il_set_rate);
 
 void il_chswitch_done(struct il_priv *il, bool is_success)
 {
-	struct il_rxon_context *ctx = &il->contexts[IL_RXON_CTX_BSS];
+	struct il_rxon_context *ctx = &il->ctx;
 
 	if (test_bit(STATUS_EXIT_PENDING, &il->status))
 		return;
@@ -868,7 +868,7 @@ void il_rx_csa(struct il_priv *il, struct il_rx_mem_buffer *rxb)
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	struct il_csa_notification *csa = &(pkt->u.csa_notif);
 
-	struct il_rxon_context *ctx = &il->contexts[IL_RXON_CTX_BSS];
+	struct il_rxon_context *ctx = &il->ctx;
 	struct il_rxon_cmd *rxon = (void *)&ctx->active;
 
 	if (!test_bit(STATUS_CHANNEL_SWITCH_PENDING, &il->status))
@@ -933,7 +933,7 @@ void il_irq_handle_error(struct il_priv *il)
 #ifdef CONFIG_IWLEGACY_DEBUG
 	if (il_get_debug_level(il) & IL_DL_FW_ERRORS)
 		il_print_rx_config_cmd(il,
-					&il->contexts[IL_RXON_CTX_BSS]);
+					&il->ctx);
 #endif
 
 	wake_up(&il->wait_command_queue);
@@ -1110,7 +1110,7 @@ int il_set_tx_power(struct il_priv *il, s8 tx_power, bool force)
 	int ret;
 	s8 prev_tx_power;
 	bool defer;
-	struct il_rxon_context *ctx = &il->contexts[IL_RXON_CTX_BSS];
+	struct il_rxon_context *ctx = &il->ctx;
 
 	lockdep_assert_held(&il->mutex);
 
@@ -2069,7 +2069,7 @@ int il_mac_config(struct ieee80211_hw *hw, u32 changed)
 	int ret = 0;
 	u16 ch;
 	int scan_active = 0;
-	bool ht_changed[NUM_IL_RXON_CTX] = {};
+	bool ht_changed = false;
 
 	if (WARN_ON(!il->cfg->ops->legacy))
 		return -EOPNOTSUPP;
@@ -2129,7 +2129,7 @@ int il_mac_config(struct ieee80211_hw *hw, u32 changed)
 			/* Configure HT40 channels */
 			if (ctx->ht.enabled != conf_is_ht(conf)) {
 				ctx->ht.enabled = conf_is_ht(conf);
-				ht_changed[ctx->ctxid] = true;
+				ht_changed = true;
 			}
 			if (ctx->ht.enabled) {
 				if (conf_is_ht40_minus(conf)) {
@@ -2209,7 +2209,7 @@ int il_mac_config(struct ieee80211_hw *hw, u32 changed)
 		else
 			D_INFO(
 				"Not re-sending same RXON configuration.\n");
-		if (ht_changed[ctx->ctxid])
+		if (ht_changed)
 			il_update_qos(il, ctx);
 	}
 
@@ -2225,8 +2225,7 @@ void il_mac_reset_tsf(struct ieee80211_hw *hw,
 {
 	struct il_priv *il = hw->priv;
 	unsigned long flags;
-	/* IBSS can only be the IL_RXON_CTX_BSS context */
-	struct il_rxon_context *ctx = &il->contexts[IL_RXON_CTX_BSS];
+	struct il_rxon_context *ctx = &il->ctx;
 
 	if (WARN_ON(!il->cfg->ops->legacy))
 		return;
diff --git a/drivers/net/wireless/iwlegacy/iwl-debugfs.c b/drivers/net/wireless/iwlegacy/iwl-debugfs.c
index 736b00b..a4b1f37 100644
--- a/drivers/net/wireless/iwlegacy/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlegacy/iwl-debugfs.c
@@ -601,7 +601,7 @@ il_dbgfs_qos_read(struct file *file, char __user *user_buf,
 	struct il_priv *il = file->private_data;
 	struct il_rxon_context *ctx;
 	int pos = 0, i;
-	char buf[256 * NUM_IL_RXON_CTX];
+	char buf[256];
 	const size_t bufsz = sizeof(buf);
 
 	for_each_context(il, ctx) {
@@ -1064,7 +1064,7 @@ static ssize_t il_dbgfs_rxon_flags_read(struct file *file,
 	char buf[20];
 
 	len = sprintf(buf, "0x%04X\n",
-		le32_to_cpu(il->contexts[IL_RXON_CTX_BSS].active.flags));
+		le32_to_cpu(il->ctx.active.flags));
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
 
@@ -1077,7 +1077,7 @@ static ssize_t il_dbgfs_rxon_filter_flags_read(struct file *file,
 	char buf[20];
 
 	len = sprintf(buf, "0x%04X\n",
-	le32_to_cpu(il->contexts[IL_RXON_CTX_BSS].active.filter_flags));
+	le32_to_cpu(il->ctx.active.filter_flags));
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-dev.h b/drivers/net/wireless/iwlegacy/iwl-dev.h
index 4c7ccd5..d15dcbd 100644
--- a/drivers/net/wireless/iwlegacy/iwl-dev.h
+++ b/drivers/net/wireless/iwlegacy/iwl-dev.h
@@ -899,12 +899,6 @@ struct il_force_reset {
  */
 #define IL4965_EXT_BEACON_TIME_POS	22
 
-enum il_rxon_context_id {
-	IL_RXON_CTX_BSS,
-
-	NUM_IL_RXON_CTX
-};
-
 struct il_rxon_context {
 	struct ieee80211_vif *vif;
 
@@ -921,7 +915,7 @@ struct il_rxon_context {
 
 	bool ht_need_multiple_chains;
 
-	enum il_rxon_context_id ctxid;
+	int ctxid;
 
 	u32 interface_modes, exclusive_interface_modes;
 	u8 unused_devtype, ap_devtype, ibss_devtype, station_devtype;
@@ -1029,9 +1023,6 @@ struct il_priv {
 	u32  hw_wa_rev;
 	u8   rev_id;
 
-	/* microcode/device supports multiple contexts */
-	u8 valid_contexts;
-
 	/* command queue number */
 	u8 cmd_queue;
 
@@ -1055,7 +1046,7 @@ struct il_priv {
 	u8 ucode_write_complete;	/* the image write is complete */
 	char firmware_name[25];
 
-	struct il_rxon_context contexts[NUM_IL_RXON_CTX];
+	struct il_rxon_context ctx;
 
 	__le16 switch_channel;
 
@@ -1298,21 +1289,17 @@ il_rxon_ctx_from_vif(struct ieee80211_vif *vif)
 	return vif_priv->ctx;
 }
 
-#define for_each_context(il, ctx)				\
-	for (ctx = &il->contexts[IL_RXON_CTX_BSS];		\
-	     ctx < &il->contexts[NUM_IL_RXON_CTX]; ctx++)	\
-		if (il->valid_contexts & BIT(ctx->ctxid))
+#define for_each_context(il, _ctx) \
+	for (_ctx = &il->ctx; _ctx == &il->ctx; _ctx++)
 
-static inline int il_is_associated(struct il_priv *il,
-				    enum il_rxon_context_id ctxid)
+static inline int il_is_associated(struct il_priv *il)
 {
-	return (il->contexts[ctxid].active.filter_flags &
-			RXON_FILTER_ASSOC_MSK) ? 1 : 0;
+	return (il->ctx.active.filter_flags & RXON_FILTER_ASSOC_MSK) ? 1 : 0;
 }
 
 static inline int il_is_any_associated(struct il_priv *il)
 {
-	return il_is_associated(il, IL_RXON_CTX_BSS);
+	return il_is_associated(il);
 }
 
 static inline int il_is_associated_ctx(struct il_rxon_context *ctx)
diff --git a/drivers/net/wireless/iwlegacy/iwl-rx.c b/drivers/net/wireless/iwlegacy/iwl-rx.c
index 746b5a7..2e7c87f 100644
--- a/drivers/net/wireless/iwlegacy/iwl-rx.c
+++ b/drivers/net/wireless/iwlegacy/iwl-rx.c
@@ -241,7 +241,7 @@ int il_set_decrypted_flag(struct il_priv *il,
 	 * All contexts have the same setting here due to it being
 	 * a module parameter, so OK to check any context.
 	 */
-	if (il->contexts[IL_RXON_CTX_BSS].active.filter_flags &
+	if (il->ctx.active.filter_flags &
 						RXON_FILTER_DIS_DECRYPT_MSK)
 		return 0;
 
diff --git a/drivers/net/wireless/iwlegacy/iwl3945-base.c b/drivers/net/wireless/iwlegacy/iwl3945-base.c
index 216c86f..dd8ce29 100644
--- a/drivers/net/wireless/iwlegacy/iwl3945-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl3945-base.c
@@ -144,7 +144,7 @@ static int il3945_set_ccmp_dynamic_key_info(struct il_priv *il,
 	key_flags |= (STA_KEY_FLG_CCMP | STA_KEY_FLG_MAP_KEY_MSK);
 	key_flags |= cpu_to_le16(keyconf->keyidx << STA_KEY_FLG_KEYID_POS);
 
-	if (sta_id == il->contexts[IL_RXON_CTX_BSS].bcast_sta_id)
+	if (sta_id == il->ctx.bcast_sta_id)
 		key_flags |= STA_KEY_MULTICAST_MSK;
 
 	keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
@@ -318,7 +318,7 @@ unsigned int il3945_fill_beacon_frame(struct il_priv *il,
 				int left)
 {
 
-	if (!il_is_associated(il, IL_RXON_CTX_BSS) || !il->beacon_skb)
+	if (!il_is_associated(il) || !il->beacon_skb)
 		return 0;
 
 	if (il->beacon_skb->len > left)
@@ -345,7 +345,7 @@ static int il3945_send_beacon_cmd(struct il_priv *il)
 	}
 
 	rate = il_get_lowest_plcp(il,
-				&il->contexts[IL_RXON_CTX_BSS]);
+				&il->ctx);
 
 	frame_size = il3945_hw_get_beacon_cmd(il, frame, rate);
 
@@ -515,7 +515,7 @@ static int il3945_tx_skb(struct il_priv *il, struct sk_buff *skb)
 
 	/* Find index into station table for destination station */
 	sta_id = il_sta_id_or_broadcast(
-			il, &il->contexts[IL_RXON_CTX_BSS],
+			il, &il->ctx,
 			info->control.sta);
 	if (sta_id == IL_INVALID_STATION) {
 		D_DROP("Dropping - INVALID STATION: %pM\n",
@@ -546,7 +546,7 @@ static int il3945_tx_skb(struct il_priv *il, struct sk_buff *skb)
 	/* Set up driver data for this TFD */
 	memset(&(txq->txb[q->write_ptr]), 0, sizeof(struct il_tx_info));
 	txq->txb[q->write_ptr].skb = skb;
-	txq->txb[q->write_ptr].ctx = &il->contexts[IL_RXON_CTX_BSS];
+	txq->txb[q->write_ptr].ctx = &il->ctx;
 
 	/* Init first empty entry in queue's array of Tx/cmd buffers */
 	out_cmd = txq->cmd[idx];
@@ -681,9 +681,9 @@ static int il3945_get_measurement(struct il_priv *il,
 	int rc;
 	int spectrum_resp_status;
 	int duration = le16_to_cpu(params->duration);
-	struct il_rxon_context *ctx = &il->contexts[IL_RXON_CTX_BSS];
+	struct il_rxon_context *ctx = &il->ctx;
 
-	if (il_is_associated(il, IL_RXON_CTX_BSS))
+	if (il_is_associated(il))
 		add_time = il_usecs_to_beacons(il,
 			le64_to_cpu(params->start_time) - il->_3945.last_tsf,
 			le16_to_cpu(ctx->timing.beacon_interval));
@@ -697,7 +697,7 @@ static int il3945_get_measurement(struct il_priv *il,
 	cmd.len = sizeof(spectrum);
 	spectrum.len = cpu_to_le16(cmd.len - sizeof(spectrum.len));
 
-	if (il_is_associated(il, IL_RXON_CTX_BSS))
+	if (il_is_associated(il))
 		spectrum.start_time =
 			il_add_beacon_time(il,
 				il->_3945.last_beacon_time, add_time,
@@ -2189,7 +2189,7 @@ static void il3945_alive_start(struct il_priv *il)
 {
 	int thermal_spin = 0;
 	u32 rfkill;
-	struct il_rxon_context *ctx = &il->contexts[IL_RXON_CTX_BSS];
+	struct il_rxon_context *ctx = &il->ctx;
 
 	D_INFO("Runtime Alive received.\n");
 
@@ -2243,7 +2243,7 @@ static void il3945_alive_start(struct il_priv *il)
 
 	il_power_update_mode(il, true);
 
-	if (il_is_associated(il, IL_RXON_CTX_BSS)) {
+	if (il_is_associated(il)) {
 		struct il3945_rxon_cmd *active_rxon =
 				(struct il3945_rxon_cmd *)(&ctx->active);
 
@@ -2372,7 +2372,7 @@ static void il3945_down(struct il_priv *il)
 
 static int il3945_alloc_bcast_station(struct il_priv *il)
 {
-	struct il_rxon_context *ctx = &il->contexts[IL_RXON_CTX_BSS];
+	struct il_rxon_context *ctx = &il->ctx;
 	unsigned long flags;
 	u8 sta_id;
 
@@ -2581,7 +2581,7 @@ int il3945_request_scan(struct il_priv *il, struct ieee80211_vif *vif)
 	scan->quiet_plcp_th = IL_PLCP_QUIET_THRESH;
 	scan->quiet_time = IL_ACTIVE_QUIET_TIME;
 
-	if (il_is_associated(il, IL_RXON_CTX_BSS)) {
+	if (il_is_associated(il)) {
 		u16 interval;
 		u32 extra;
 		u32 suspend_time = 100;
@@ -2634,7 +2634,7 @@ int il3945_request_scan(struct il_priv *il, struct ieee80211_vif *vif)
 	/* We don't build a direct scan probe request; the uCode will do
 	 * that based on the direct_mask added to each channel entry */
 	scan->tx_cmd.tx_flags = TX_CMD_FLG_SEQ_CTL_MSK;
-	scan->tx_cmd.sta_id = il->contexts[IL_RXON_CTX_BSS].bcast_sta_id;
+	scan->tx_cmd.sta_id = il->ctx.bcast_sta_id;
 	scan->tx_cmd.stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
 
 	/* flags + rate selection */
@@ -2692,7 +2692,7 @@ int il3945_request_scan(struct il_priv *il, struct ieee80211_vif *vif)
 
 void il3945_post_scan(struct il_priv *il)
 {
-	struct il_rxon_context *ctx = &il->contexts[IL_RXON_CTX_BSS];
+	struct il_rxon_context *ctx = &il->ctx;
 
 	/*
 	 * Since setting the RXON may have been deferred while
@@ -2750,7 +2750,7 @@ void il3945_post_associate(struct il_priv *il)
 {
 	int rc = 0;
 	struct ieee80211_conf *conf = NULL;
-	struct il_rxon_context *ctx = &il->contexts[IL_RXON_CTX_BSS];
+	struct il_rxon_context *ctx = &il->ctx;
 
 	if (!ctx->vif || !il->is_open)
 		return;
@@ -2917,7 +2917,7 @@ static void il3945_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 void il3945_config_ap(struct il_priv *il)
 {
-	struct il_rxon_context *ctx = &il->contexts[IL_RXON_CTX_BSS];
+	struct il_rxon_context *ctx = &il->ctx;
 	struct ieee80211_vif *vif = ctx->vif;
 	int rc = 0;
 
@@ -2925,7 +2925,7 @@ void il3945_config_ap(struct il_priv *il)
 		return;
 
 	/* The following should be done only at AP bring up */
-	if (!(il_is_associated(il, IL_RXON_CTX_BSS))) {
+	if (!(il_is_associated(il))) {
 
 		/* RXON - unassoc (to set timing command) */
 		ctx->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
@@ -2986,11 +2986,11 @@ static int il3945_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	    !(key->flags & IEEE80211_KEY_FLAG_PAIRWISE))
 		return -EOPNOTSUPP;
 
-	static_key = !il_is_associated(il, IL_RXON_CTX_BSS);
+	static_key = !il_is_associated(il);
 
 	if (!static_key) {
 		sta_id = il_sta_id_or_broadcast(
-				il, &il->contexts[IL_RXON_CTX_BSS], sta);
+				il, &il->ctx, sta);
 		if (sta_id == IL_INVALID_STATION)
 			return -EINVAL;
 	}
@@ -3042,7 +3042,7 @@ static int il3945_mac_sta_add(struct ieee80211_hw *hw,
 
 
 	ret = il_add_station_common(il,
-				&il->contexts[IL_RXON_CTX_BSS],
+				&il->ctx,
 				     sta->addr, is_ap, sta, &sta_id);
 	if (ret) {
 		IL_ERR("Unable to add station %pM (%d)\n",
@@ -3070,7 +3070,7 @@ static void il3945_configure_filter(struct ieee80211_hw *hw,
 {
 	struct il_priv *il = hw->priv;
 	__le32 filter_or = 0, filter_nand = 0;
-	struct il_rxon_context *ctx = &il->contexts[IL_RXON_CTX_BSS];
+	struct il_rxon_context *ctx = &il->ctx;
 
 #define CHK(test, flag)	do { \
 	if (*total_flags & (test))		\
@@ -3205,7 +3205,7 @@ static ssize_t il3945_show_flags(struct device *d,
 			  struct device_attribute *attr, char *buf)
 {
 	struct il_priv *il = dev_get_drvdata(d);
-	struct il_rxon_context *ctx = &il->contexts[IL_RXON_CTX_BSS];
+	struct il_rxon_context *ctx = &il->ctx;
 
 	return sprintf(buf, "0x%04X\n", ctx->active.flags);
 }
@@ -3216,7 +3216,7 @@ static ssize_t il3945_store_flags(struct device *d,
 {
 	struct il_priv *il = dev_get_drvdata(d);
 	u32 flags = simple_strtoul(buf, NULL, 0);
-	struct il_rxon_context *ctx = &il->contexts[IL_RXON_CTX_BSS];
+	struct il_rxon_context *ctx = &il->ctx;
 
 	mutex_lock(&il->mutex);
 	if (le32_to_cpu(ctx->staging.flags) != flags) {
@@ -3241,7 +3241,7 @@ static ssize_t il3945_show_filter_flags(struct device *d,
 				 struct device_attribute *attr, char *buf)
 {
 	struct il_priv *il = dev_get_drvdata(d);
-	struct il_rxon_context *ctx = &il->contexts[IL_RXON_CTX_BSS];
+	struct il_rxon_context *ctx = &il->ctx;
 
 	return sprintf(buf, "0x%04X\n",
 		le32_to_cpu(ctx->active.filter_flags));
@@ -3252,7 +3252,7 @@ static ssize_t il3945_store_filter_flags(struct device *d,
 				  const char *buf, size_t count)
 {
 	struct il_priv *il = dev_get_drvdata(d);
-	struct il_rxon_context *ctx = &il->contexts[IL_RXON_CTX_BSS];
+	struct il_rxon_context *ctx = &il->ctx;
 	u32 filter_flags = simple_strtoul(buf, NULL, 0);
 
 	mutex_lock(&il->mutex);
@@ -3313,7 +3313,7 @@ static ssize_t il3945_store_measurement(struct device *d,
 				 const char *buf, size_t count)
 {
 	struct il_priv *il = dev_get_drvdata(d);
-	struct il_rxon_context *ctx = &il->contexts[IL_RXON_CTX_BSS];
+	struct il_rxon_context *ctx = &il->ctx;
 	struct ieee80211_measurement_params params = {
 		.channel = le16_to_cpu(ctx->active.channel),
 		.start_time = cpu_to_le64(il->_3945.last_tsf),
@@ -3599,7 +3599,7 @@ static int il3945_setup_mac(struct il_priv *il)
 		    IEEE80211_HW_SPECTRUM_MGMT;
 
 	hw->wiphy->interface_modes =
-		il->contexts[IL_RXON_CTX_BSS].interface_modes;
+		il->ctx.interface_modes;
 
 	hw->wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY |
 			    WIPHY_FLAG_DISABLE_BEACON_HINTS |
@@ -3634,7 +3634,7 @@ static int il3945_setup_mac(struct il_priv *il)
 
 static int il3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	int err = 0, i;
+	int err = 0;
 	struct il_priv *il;
 	struct ieee80211_hw *hw;
 	struct il_cfg *cfg = (struct il_cfg *)(ent->driver_data);
@@ -3658,24 +3658,20 @@ static int il3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *en
 
 	il->cmd_queue = IL39_CMD_QUEUE_NUM;
 
-	/* 3945 has only one valid context */
-	il->valid_contexts = BIT(IL_RXON_CTX_BSS);
+	il->ctx.ctxid = 0;
 
-	for (i = 0; i < NUM_IL_RXON_CTX; i++)
-		il->contexts[i].ctxid = i;
-
-	il->contexts[IL_RXON_CTX_BSS].rxon_cmd = REPLY_RXON;
-	il->contexts[IL_RXON_CTX_BSS].rxon_timing_cmd = REPLY_RXON_TIMING;
-	il->contexts[IL_RXON_CTX_BSS].rxon_assoc_cmd = REPLY_RXON_ASSOC;
-	il->contexts[IL_RXON_CTX_BSS].qos_cmd = REPLY_QOS_PARAM;
-	il->contexts[IL_RXON_CTX_BSS].ap_sta_id = IL_AP_ID;
-	il->contexts[IL_RXON_CTX_BSS].wep_key_cmd = REPLY_WEPKEY;
-	il->contexts[IL_RXON_CTX_BSS].interface_modes =
+	il->ctx.rxon_cmd = REPLY_RXON;
+	il->ctx.rxon_timing_cmd = REPLY_RXON_TIMING;
+	il->ctx.rxon_assoc_cmd = REPLY_RXON_ASSOC;
+	il->ctx.qos_cmd = REPLY_QOS_PARAM;
+	il->ctx.ap_sta_id = IL_AP_ID;
+	il->ctx.wep_key_cmd = REPLY_WEPKEY;
+	il->ctx.interface_modes =
 		BIT(NL80211_IFTYPE_STATION) |
 		BIT(NL80211_IFTYPE_ADHOC);
-	il->contexts[IL_RXON_CTX_BSS].ibss_devtype = RXON_DEV_TYPE_IBSS;
-	il->contexts[IL_RXON_CTX_BSS].station_devtype = RXON_DEV_TYPE_ESS;
-	il->contexts[IL_RXON_CTX_BSS].unused_devtype = RXON_DEV_TYPE_ESS;
+	il->ctx.ibss_devtype = RXON_DEV_TYPE_IBSS;
+	il->ctx.station_devtype = RXON_DEV_TYPE_ESS;
+	il->ctx.unused_devtype = RXON_DEV_TYPE_ESS;
 
 	/*
 	 * Disabling hardware scan means that mac80211 will perform scans
@@ -3812,7 +3808,7 @@ static int il3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *en
 
 	il_set_rxon_channel(il,
 			     &il->bands[IEEE80211_BAND_2GHZ].channels[5],
-			     &il->contexts[IL_RXON_CTX_BSS]);
+			     &il->ctx);
 	il3945_setup_deferred_work(il);
 	il3945_setup_rx_handlers(il);
 	il_power_initialize(il);
diff --git a/drivers/net/wireless/iwlegacy/iwl4965-base.c b/drivers/net/wireless/iwlegacy/iwl4965-base.c
index d5f9180..131d6e9 100644
--- a/drivers/net/wireless/iwlegacy/iwl4965-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl4965-base.c
@@ -1717,7 +1717,7 @@ static int il4965_alive_notify(struct il_priv *il)
 static void il4965_alive_start(struct il_priv *il)
 {
 	int ret = 0;
-	struct il_rxon_context *ctx = &il->contexts[IL_RXON_CTX_BSS];
+	struct il_rxon_context *ctx = &il->ctx;
 
 	D_INFO("Runtime Alive received.\n");
 
@@ -2502,7 +2502,7 @@ void il4965_mac_channel_switch(struct ieee80211_hw *hw,
 	struct ieee80211_channel *channel = ch_switch->channel;
 	struct il_ht_config *ht_conf = &il->current_ht_config;
 
-	struct il_rxon_context *ctx = &il->contexts[IL_RXON_CTX_BSS];
+	struct il_rxon_context *ctx = &il->ctx;
 	u16 ch;
 
 	D_MAC80211("enter\n");
@@ -2786,7 +2786,7 @@ static int il4965_init_drv(struct il_priv *il)
 	/* Choose which receivers/antennas to use */
 	if (il->cfg->ops->hcmd->set_rxon_chain)
 		il->cfg->ops->hcmd->set_rxon_chain(il,
-					&il->contexts[IL_RXON_CTX_BSS]);
+					&il->ctx);
 
 	il_init_scan_params(il);
 
@@ -2859,7 +2859,7 @@ static const u8 il4965_bss_ac_to_queue[] = {
 static int
 il4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	int err = 0, i;
+	int err = 0;
 	struct il_priv *il;
 	struct ieee80211_hw *hw;
 	struct il_cfg *cfg = (struct il_cfg *)(ent->driver_data);
@@ -2878,36 +2878,26 @@ il4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	il = hw->priv;
 	/* At this point both hw and il are allocated. */
 
-	/*
-	 * The default context is always valid,
-	 * more may be discovered when firmware
-	 * is loaded.
-	 */
-	il->valid_contexts = BIT(IL_RXON_CTX_BSS);
-
-	for (i = 0; i < NUM_IL_RXON_CTX; i++)
-		il->contexts[i].ctxid = i;
-
-	il->contexts[IL_RXON_CTX_BSS].always_active = true;
-	il->contexts[IL_RXON_CTX_BSS].is_active = true;
-	il->contexts[IL_RXON_CTX_BSS].rxon_cmd = REPLY_RXON;
-	il->contexts[IL_RXON_CTX_BSS].rxon_timing_cmd = REPLY_RXON_TIMING;
-	il->contexts[IL_RXON_CTX_BSS].rxon_assoc_cmd = REPLY_RXON_ASSOC;
-	il->contexts[IL_RXON_CTX_BSS].qos_cmd = REPLY_QOS_PARAM;
-	il->contexts[IL_RXON_CTX_BSS].ap_sta_id = IL_AP_ID;
-	il->contexts[IL_RXON_CTX_BSS].wep_key_cmd = REPLY_WEPKEY;
-	il->contexts[IL_RXON_CTX_BSS].ac_to_fifo = il4965_bss_ac_to_fifo;
-	il->contexts[IL_RXON_CTX_BSS].ac_to_queue = il4965_bss_ac_to_queue;
-	il->contexts[IL_RXON_CTX_BSS].exclusive_interface_modes =
+	il->ctx.ctxid = 0;
+
+	il->ctx.always_active = true;
+	il->ctx.is_active = true;
+	il->ctx.rxon_cmd = REPLY_RXON;
+	il->ctx.rxon_timing_cmd = REPLY_RXON_TIMING;
+	il->ctx.rxon_assoc_cmd = REPLY_RXON_ASSOC;
+	il->ctx.qos_cmd = REPLY_QOS_PARAM;
+	il->ctx.ap_sta_id = IL_AP_ID;
+	il->ctx.wep_key_cmd = REPLY_WEPKEY;
+	il->ctx.ac_to_fifo = il4965_bss_ac_to_fifo;
+	il->ctx.ac_to_queue = il4965_bss_ac_to_queue;
+	il->ctx.exclusive_interface_modes =
 		BIT(NL80211_IFTYPE_ADHOC);
-	il->contexts[IL_RXON_CTX_BSS].interface_modes =
+	il->ctx.interface_modes =
 		BIT(NL80211_IFTYPE_STATION);
-	il->contexts[IL_RXON_CTX_BSS].ap_devtype = RXON_DEV_TYPE_AP;
-	il->contexts[IL_RXON_CTX_BSS].ibss_devtype = RXON_DEV_TYPE_IBSS;
-	il->contexts[IL_RXON_CTX_BSS].station_devtype = RXON_DEV_TYPE_ESS;
-	il->contexts[IL_RXON_CTX_BSS].unused_devtype = RXON_DEV_TYPE_ESS;
-
-	BUILD_BUG_ON(NUM_IL_RXON_CTX != 1);
+	il->ctx.ap_devtype = RXON_DEV_TYPE_AP;
+	il->ctx.ibss_devtype = RXON_DEV_TYPE_IBSS;
+	il->ctx.station_devtype = RXON_DEV_TYPE_ESS;
+	il->ctx.unused_devtype = RXON_DEV_TYPE_ESS;
 
 	SET_IEEE80211_DEV(hw, &pdev->dev);
 
-- 
1.7.1

