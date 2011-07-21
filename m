Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:53534 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752210Ab1GUP0w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2011 11:26:52 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 17/25] iwlagn: remove un-necessary "_agn"
Date: Thu, 21 Jul 2011 07:50:20 -0700
Message-Id: <1311259828-8415-18-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110721_172711_693865_F52EB6C5)
In-Reply-To: <1311259828-8415-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1311259828-8415-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After driver split, extra _agn in priv structure is no needed, remove it.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c       |   98 +++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c      |   10 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c           |   90 ++++++++++----------
 drivers/net/wireless/iwlwifi/iwl-core.c          |    8 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c       |   72 ++++++++--------
 drivers/net/wireless/iwlwifi/iwl-dev.h           |   98 ++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-rx.c            |   26 +++---
 drivers/net/wireless/iwlwifi/iwl-scan.c          |    6 +-
 drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c |  100 +++++++++++-----------
 10 files changed, 254 insertions(+), 256 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
index 204f0ec..72d6297 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
@@ -889,7 +889,7 @@ static void iwlagn_gain_computation(struct iwl_priv *priv,
 		memset(&cmd, 0, sizeof(cmd));
 
 		iwl_set_calib_hdr(&cmd.hdr,
-			priv->_agn.phy_calib_chain_noise_gain_cmd);
+			priv->phy_calib_chain_noise_gain_cmd);
 		cmd.delta_gain_1 = data->delta_gain_code[1];
 		cmd.delta_gain_2 = data->delta_gain_code[2];
 		trans_send_cmd_pdu(&priv->trans, REPLY_PHY_CALIBRATION_CMD,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 67b55c5..e77f913 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -53,73 +53,73 @@ static void iwlagn_count_tx_err_status(struct iwl_priv *priv, u16 status)
 
 	switch (status) {
 	case TX_STATUS_POSTPONE_DELAY:
-		priv->_agn.reply_tx_stats.pp_delay++;
+		priv->reply_tx_stats.pp_delay++;
 		break;
 	case TX_STATUS_POSTPONE_FEW_BYTES:
-		priv->_agn.reply_tx_stats.pp_few_bytes++;
+		priv->reply_tx_stats.pp_few_bytes++;
 		break;
 	case TX_STATUS_POSTPONE_BT_PRIO:
-		priv->_agn.reply_tx_stats.pp_bt_prio++;
+		priv->reply_tx_stats.pp_bt_prio++;
 		break;
 	case TX_STATUS_POSTPONE_QUIET_PERIOD:
-		priv->_agn.reply_tx_stats.pp_quiet_period++;
+		priv->reply_tx_stats.pp_quiet_period++;
 		break;
 	case TX_STATUS_POSTPONE_CALC_TTAK:
-		priv->_agn.reply_tx_stats.pp_calc_ttak++;
+		priv->reply_tx_stats.pp_calc_ttak++;
 		break;
 	case TX_STATUS_FAIL_INTERNAL_CROSSED_RETRY:
-		priv->_agn.reply_tx_stats.int_crossed_retry++;
+		priv->reply_tx_stats.int_crossed_retry++;
 		break;
 	case TX_STATUS_FAIL_SHORT_LIMIT:
-		priv->_agn.reply_tx_stats.short_limit++;
+		priv->reply_tx_stats.short_limit++;
 		break;
 	case TX_STATUS_FAIL_LONG_LIMIT:
-		priv->_agn.reply_tx_stats.long_limit++;
+		priv->reply_tx_stats.long_limit++;
 		break;
 	case TX_STATUS_FAIL_FIFO_UNDERRUN:
-		priv->_agn.reply_tx_stats.fifo_underrun++;
+		priv->reply_tx_stats.fifo_underrun++;
 		break;
 	case TX_STATUS_FAIL_DRAIN_FLOW:
-		priv->_agn.reply_tx_stats.drain_flow++;
+		priv->reply_tx_stats.drain_flow++;
 		break;
 	case TX_STATUS_FAIL_RFKILL_FLUSH:
-		priv->_agn.reply_tx_stats.rfkill_flush++;
+		priv->reply_tx_stats.rfkill_flush++;
 		break;
 	case TX_STATUS_FAIL_LIFE_EXPIRE:
-		priv->_agn.reply_tx_stats.life_expire++;
+		priv->reply_tx_stats.life_expire++;
 		break;
 	case TX_STATUS_FAIL_DEST_PS:
-		priv->_agn.reply_tx_stats.dest_ps++;
+		priv->reply_tx_stats.dest_ps++;
 		break;
 	case TX_STATUS_FAIL_HOST_ABORTED:
-		priv->_agn.reply_tx_stats.host_abort++;
+		priv->reply_tx_stats.host_abort++;
 		break;
 	case TX_STATUS_FAIL_BT_RETRY:
-		priv->_agn.reply_tx_stats.bt_retry++;
+		priv->reply_tx_stats.bt_retry++;
 		break;
 	case TX_STATUS_FAIL_STA_INVALID:
-		priv->_agn.reply_tx_stats.sta_invalid++;
+		priv->reply_tx_stats.sta_invalid++;
 		break;
 	case TX_STATUS_FAIL_FRAG_DROPPED:
-		priv->_agn.reply_tx_stats.frag_drop++;
+		priv->reply_tx_stats.frag_drop++;
 		break;
 	case TX_STATUS_FAIL_TID_DISABLE:
-		priv->_agn.reply_tx_stats.tid_disable++;
+		priv->reply_tx_stats.tid_disable++;
 		break;
 	case TX_STATUS_FAIL_FIFO_FLUSHED:
-		priv->_agn.reply_tx_stats.fifo_flush++;
+		priv->reply_tx_stats.fifo_flush++;
 		break;
 	case TX_STATUS_FAIL_INSUFFICIENT_CF_POLL:
-		priv->_agn.reply_tx_stats.insuff_cf_poll++;
+		priv->reply_tx_stats.insuff_cf_poll++;
 		break;
 	case TX_STATUS_FAIL_PASSIVE_NO_RX:
-		priv->_agn.reply_tx_stats.fail_hw_drop++;
+		priv->reply_tx_stats.fail_hw_drop++;
 		break;
 	case TX_STATUS_FAIL_NO_BEACON_ON_RADAR:
-		priv->_agn.reply_tx_stats.sta_color_mismatch++;
+		priv->reply_tx_stats.sta_color_mismatch++;
 		break;
 	default:
-		priv->_agn.reply_tx_stats.unknown++;
+		priv->reply_tx_stats.unknown++;
 		break;
 	}
 }
@@ -130,43 +130,43 @@ static void iwlagn_count_agg_tx_err_status(struct iwl_priv *priv, u16 status)
 
 	switch (status) {
 	case AGG_TX_STATE_UNDERRUN_MSK:
-		priv->_agn.reply_agg_tx_stats.underrun++;
+		priv->reply_agg_tx_stats.underrun++;
 		break;
 	case AGG_TX_STATE_BT_PRIO_MSK:
-		priv->_agn.reply_agg_tx_stats.bt_prio++;
+		priv->reply_agg_tx_stats.bt_prio++;
 		break;
 	case AGG_TX_STATE_FEW_BYTES_MSK:
-		priv->_agn.reply_agg_tx_stats.few_bytes++;
+		priv->reply_agg_tx_stats.few_bytes++;
 		break;
 	case AGG_TX_STATE_ABORT_MSK:
-		priv->_agn.reply_agg_tx_stats.abort++;
+		priv->reply_agg_tx_stats.abort++;
 		break;
 	case AGG_TX_STATE_LAST_SENT_TTL_MSK:
-		priv->_agn.reply_agg_tx_stats.last_sent_ttl++;
+		priv->reply_agg_tx_stats.last_sent_ttl++;
 		break;
 	case AGG_TX_STATE_LAST_SENT_TRY_CNT_MSK:
-		priv->_agn.reply_agg_tx_stats.last_sent_try++;
+		priv->reply_agg_tx_stats.last_sent_try++;
 		break;
 	case AGG_TX_STATE_LAST_SENT_BT_KILL_MSK:
-		priv->_agn.reply_agg_tx_stats.last_sent_bt_kill++;
+		priv->reply_agg_tx_stats.last_sent_bt_kill++;
 		break;
 	case AGG_TX_STATE_SCD_QUERY_MSK:
-		priv->_agn.reply_agg_tx_stats.scd_query++;
+		priv->reply_agg_tx_stats.scd_query++;
 		break;
 	case AGG_TX_STATE_TEST_BAD_CRC32_MSK:
-		priv->_agn.reply_agg_tx_stats.bad_crc32++;
+		priv->reply_agg_tx_stats.bad_crc32++;
 		break;
 	case AGG_TX_STATE_RESPONSE_MSK:
-		priv->_agn.reply_agg_tx_stats.response++;
+		priv->reply_agg_tx_stats.response++;
 		break;
 	case AGG_TX_STATE_DUMP_TX_MSK:
-		priv->_agn.reply_agg_tx_stats.dump_tx++;
+		priv->reply_agg_tx_stats.dump_tx++;
 		break;
 	case AGG_TX_STATE_DELAY_TX_MSK:
-		priv->_agn.reply_agg_tx_stats.delay_tx++;
+		priv->reply_agg_tx_stats.delay_tx++;
 		break;
 	default:
-		priv->_agn.reply_agg_tx_stats.unknown++;
+		priv->reply_agg_tx_stats.unknown++;
 		break;
 	}
 }
@@ -749,7 +749,7 @@ static int iwl_get_channels_for_scan(struct iwl_priv *priv,
 
 static int iwl_fill_offch_tx(struct iwl_priv *priv, void *data, size_t maxlen)
 {
-	struct sk_buff *skb = priv->_agn.offchan_tx_skb;
+	struct sk_buff *skb = priv->offchan_tx_skb;
 
 	if (skb->len < maxlen)
 		maxlen = skb->len;
@@ -835,7 +835,7 @@ int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	} else if (priv->scan_type == IWL_SCAN_OFFCH_TX) {
 		scan->suspend_time = 0;
 		scan->max_out_time =
-			cpu_to_le32(1024 * priv->_agn.offchan_tx_timeout);
+			cpu_to_le32(1024 * priv->offchan_tx_timeout);
 	}
 
 	switch (priv->scan_type) {
@@ -1023,9 +1023,9 @@ int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 		scan_ch = (void *)&scan->data[cmd_len];
 		scan_ch->type = SCAN_CHANNEL_TYPE_ACTIVE;
 		scan_ch->channel =
-			cpu_to_le16(priv->_agn.offchan_tx_chan->hw_value);
+			cpu_to_le16(priv->offchan_tx_chan->hw_value);
 		scan_ch->active_dwell =
-			cpu_to_le16(priv->_agn.offchan_tx_timeout);
+			cpu_to_le16(priv->offchan_tx_timeout);
 		scan_ch->passive_dwell = 0;
 
 		/* Set txpower levels to defaults */
@@ -1035,7 +1035,7 @@ int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 		 * power level:
 		 * scan_ch->tx_gain = ((1 << 5) | (2 << 3)) | 3;
 		 */
-		if (priv->_agn.offchan_tx_chan->band == IEEE80211_BAND_5GHZ)
+		if (priv->offchan_tx_chan->band == IEEE80211_BAND_5GHZ)
 			scan_ch->tx_gain = ((1 << 5) | (3 << 3)) | 3;
 		else
 			scan_ch->tx_gain = ((1 << 5) | (5 << 3));
@@ -2004,9 +2004,9 @@ void iwlagn_init_notification_wait(struct iwl_priv *priv,
 	wait_entry->triggered = false;
 	wait_entry->aborted = false;
 
-	spin_lock_bh(&priv->_agn.notif_wait_lock);
-	list_add(&wait_entry->list, &priv->_agn.notif_waits);
-	spin_unlock_bh(&priv->_agn.notif_wait_lock);
+	spin_lock_bh(&priv->notif_wait_lock);
+	list_add(&wait_entry->list, &priv->notif_waits);
+	spin_unlock_bh(&priv->notif_wait_lock);
 }
 
 int iwlagn_wait_notification(struct iwl_priv *priv,
@@ -2015,13 +2015,13 @@ int iwlagn_wait_notification(struct iwl_priv *priv,
 {
 	int ret;
 
-	ret = wait_event_timeout(priv->_agn.notif_waitq,
+	ret = wait_event_timeout(priv->notif_waitq,
 				 wait_entry->triggered || wait_entry->aborted,
 				 timeout);
 
-	spin_lock_bh(&priv->_agn.notif_wait_lock);
+	spin_lock_bh(&priv->notif_wait_lock);
 	list_del(&wait_entry->list);
-	spin_unlock_bh(&priv->_agn.notif_wait_lock);
+	spin_unlock_bh(&priv->notif_wait_lock);
 
 	if (wait_entry->aborted)
 		return -EIO;
@@ -2035,7 +2035,7 @@ int iwlagn_wait_notification(struct iwl_priv *priv,
 void iwlagn_remove_notification(struct iwl_priv *priv,
 				struct iwl_notification_wait *wait_entry)
 {
-	spin_lock_bh(&priv->_agn.notif_wait_lock);
+	spin_lock_bh(&priv->notif_wait_lock);
 	list_del(&wait_entry->list);
-	spin_unlock_bh(&priv->_agn.notif_wait_lock);
+	spin_unlock_bh(&priv->notif_wait_lock);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 581534a..7148748 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -337,9 +337,9 @@ int iwlagn_set_pan_params(struct iwl_priv *priv)
 	cmd.slots[0].type = 0; /* BSS */
 	cmd.slots[1].type = 1; /* PAN */
 
-	if (priv->_agn.hw_roc_channel) {
+	if (priv->hw_roc_channel) {
 		/* both contexts must be used for this to happen */
-		slot1 = priv->_agn.hw_roc_duration;
+		slot1 = priv->hw_roc_duration;
 		slot0 = IWL_MIN_SLOT_TIME;
 	} else if (ctx_bss->vif && ctx_pan->vif) {
 		int bcnint = ctx_pan->vif->bss_conf.beacon_int;
@@ -438,8 +438,8 @@ int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	/* always get timestamp with Rx frame */
 	ctx->staging.flags |= RXON_FLG_TSF2HOST_MSK;
 
-	if (ctx->ctxid == IWL_RXON_CTX_PAN && priv->_agn.hw_roc_channel) {
-		struct ieee80211_channel *chan = priv->_agn.hw_roc_channel;
+	if (ctx->ctxid == IWL_RXON_CTX_PAN && priv->hw_roc_channel) {
+		struct ieee80211_channel *chan = priv->hw_roc_channel;
 
 		iwl_set_rxon_channel(priv, chan, ctx);
 		iwl_set_flags_for_band(priv, ctx, chan->band, NULL);
@@ -787,7 +787,7 @@ static void iwlagn_chain_noise_reset(struct iwl_priv *priv)
 
 		memset(&cmd, 0, sizeof(cmd));
 		iwl_set_calib_hdr(&cmd.hdr,
-			priv->_agn.phy_calib_chain_noise_reset_cmd);
+			priv->phy_calib_chain_noise_reset_cmd);
 		ret = trans_send_cmd_pdu(&priv->trans,
 					REPLY_PHY_CALIBRATION_CMD,
 					CMD_SYNC, sizeof(cmd), &cmd);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 8afdeca..6df2443 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1103,20 +1103,20 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	 * for each event, which is of mode 1 (including timestamp) for all
 	 * new microcodes that include this information.
 	 */
-	priv->_agn.init_evtlog_ptr = pieces.init_evtlog_ptr;
+	priv->init_evtlog_ptr = pieces.init_evtlog_ptr;
 	if (pieces.init_evtlog_size)
-		priv->_agn.init_evtlog_size = (pieces.init_evtlog_size - 16)/12;
+		priv->init_evtlog_size = (pieces.init_evtlog_size - 16)/12;
 	else
-		priv->_agn.init_evtlog_size =
+		priv->init_evtlog_size =
 			priv->cfg->base_params->max_event_log_size;
-	priv->_agn.init_errlog_ptr = pieces.init_errlog_ptr;
-	priv->_agn.inst_evtlog_ptr = pieces.inst_evtlog_ptr;
+	priv->init_errlog_ptr = pieces.init_errlog_ptr;
+	priv->inst_evtlog_ptr = pieces.inst_evtlog_ptr;
 	if (pieces.inst_evtlog_size)
-		priv->_agn.inst_evtlog_size = (pieces.inst_evtlog_size - 16)/12;
+		priv->inst_evtlog_size = (pieces.inst_evtlog_size - 16)/12;
 	else
-		priv->_agn.inst_evtlog_size =
+		priv->inst_evtlog_size =
 			priv->cfg->base_params->max_event_log_size;
-	priv->_agn.inst_errlog_ptr = pieces.inst_errlog_ptr;
+	priv->inst_errlog_ptr = pieces.inst_errlog_ptr;
 
 	priv->new_scan_threshold_behaviour =
 		!!(ucode_capa.flags & IWL_UCODE_TLV_FLAGS_NEWSCAN);
@@ -1142,9 +1142,9 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 		ucode_capa.standard_phy_calibration_size =
 			IWL_MAX_STANDARD_PHY_CALIBRATE_TBL_SIZE;
 
-	priv->_agn.phy_calib_chain_noise_reset_cmd =
+	priv->phy_calib_chain_noise_reset_cmd =
 		ucode_capa.standard_phy_calibration_size;
-	priv->_agn.phy_calib_chain_noise_gain_cmd =
+	priv->phy_calib_chain_noise_gain_cmd =
 		ucode_capa.standard_phy_calibration_size + 1;
 
 	/**************************************************
@@ -1169,7 +1169,7 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 
 	/* We have our copies now, allow OS release its copies */
 	release_firmware(ucode_raw);
-	complete(&priv->_agn.firmware_loading_complete);
+	complete(&priv->firmware_loading_complete);
 	return;
 
  try_again:
@@ -1183,7 +1183,7 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	IWL_ERR(priv, "failed to allocate pci memory\n");
 	iwl_dealloc_ucode(priv);
  out_unbind:
-	complete(&priv->_agn.firmware_loading_complete);
+	complete(&priv->firmware_loading_complete);
 	device_release_driver(priv->bus->dev);
 	release_firmware(ucode_raw);
 }
@@ -1265,10 +1265,10 @@ void iwl_dump_nic_error_log(struct iwl_priv *priv)
 	base = priv->device_pointers.error_event_table;
 	if (priv->ucode_type == IWL_UCODE_INIT) {
 		if (!base)
-			base = priv->_agn.init_errlog_ptr;
+			base = priv->init_errlog_ptr;
 	} else {
 		if (!base)
-			base = priv->_agn.inst_errlog_ptr;
+			base = priv->inst_errlog_ptr;
 	}
 
 	if (!iwlagn_hw_valid_rtc_data_addr(base)) {
@@ -1341,10 +1341,10 @@ static int iwl_print_event_log(struct iwl_priv *priv, u32 start_idx,
 	base = priv->device_pointers.log_event_table;
 	if (priv->ucode_type == IWL_UCODE_INIT) {
 		if (!base)
-			base = priv->_agn.init_evtlog_ptr;
+			base = priv->init_evtlog_ptr;
 	} else {
 		if (!base)
-			base = priv->_agn.inst_evtlog_ptr;
+			base = priv->inst_evtlog_ptr;
 	}
 
 	if (mode == 0)
@@ -1453,13 +1453,13 @@ int iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log,
 
 	base = priv->device_pointers.log_event_table;
 	if (priv->ucode_type == IWL_UCODE_INIT) {
-		logsize = priv->_agn.init_evtlog_size;
+		logsize = priv->init_evtlog_size;
 		if (!base)
-			base = priv->_agn.init_evtlog_ptr;
+			base = priv->init_evtlog_ptr;
 	} else {
-		logsize = priv->_agn.inst_evtlog_size;
+		logsize = priv->inst_evtlog_size;
 		if (!base)
-			base = priv->_agn.inst_evtlog_ptr;
+			base = priv->inst_evtlog_ptr;
 	}
 
 	if (!iwlagn_hw_valid_rtc_data_addr(base)) {
@@ -1964,7 +1964,7 @@ static int iwl_mac_offchannel_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 
 	/* TODO: queue up if scanning? */
 	if (test_bit(STATUS_SCANNING, &priv->status) ||
-	    priv->_agn.offchan_tx_skb) {
+	    priv->offchan_tx_skb) {
 		ret = -EBUSY;
 		goto out;
 	}
@@ -1978,14 +1978,14 @@ static int iwl_mac_offchannel_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 		goto out;
 	}
 
-	priv->_agn.offchan_tx_skb = skb;
-	priv->_agn.offchan_tx_timeout = wait;
-	priv->_agn.offchan_tx_chan = chan;
+	priv->offchan_tx_skb = skb;
+	priv->offchan_tx_timeout = wait;
+	priv->offchan_tx_chan = chan;
 
 	ret = iwl_scan_initiate(priv, priv->contexts[IWL_RXON_CTX_PAN].vif,
 				IWL_SCAN_OFFCH_TX, chan->band);
 	if (ret)
-		priv->_agn.offchan_tx_skb = NULL;
+		priv->offchan_tx_skb = NULL;
  out:
 	mutex_unlock(&priv->mutex);
  free:
@@ -2002,12 +2002,12 @@ static int iwl_mac_offchannel_tx_cancel_wait(struct ieee80211_hw *hw)
 
 	mutex_lock(&priv->mutex);
 
-	if (!priv->_agn.offchan_tx_skb) {
+	if (!priv->offchan_tx_skb) {
 		ret = -EINVAL;
 		goto unlock;
 	}
 
-	priv->_agn.offchan_tx_skb = NULL;
+	priv->offchan_tx_skb = NULL;
 
 	ret = iwl_scan_cancel_timeout(priv, 200);
 	if (ret)
@@ -2380,18 +2380,18 @@ static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 		IWL_DEBUG_HT(priv, "start Tx\n");
 		ret = iwlagn_tx_agg_start(priv, vif, sta, tid, ssn);
 		if (ret == 0) {
-			priv->_agn.agg_tids_count++;
-			IWL_DEBUG_HT(priv, "priv->_agn.agg_tids_count = %u\n",
-				     priv->_agn.agg_tids_count);
+			priv->agg_tids_count++;
+			IWL_DEBUG_HT(priv, "priv->agg_tids_count = %u\n",
+				     priv->agg_tids_count);
 		}
 		break;
 	case IEEE80211_AMPDU_TX_STOP:
 		IWL_DEBUG_HT(priv, "stop Tx\n");
 		ret = iwlagn_tx_agg_stop(priv, vif, sta, tid);
-		if ((ret == 0) && (priv->_agn.agg_tids_count > 0)) {
-			priv->_agn.agg_tids_count--;
-			IWL_DEBUG_HT(priv, "priv->_agn.agg_tids_count = %u\n",
-				     priv->_agn.agg_tids_count);
+		if ((ret == 0) && (priv->agg_tids_count > 0)) {
+			priv->agg_tids_count--;
+			IWL_DEBUG_HT(priv, "priv->agg_tids_count = %u\n",
+				     priv->agg_tids_count);
 		}
 		if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 			ret = 0;
@@ -2698,7 +2698,7 @@ static void iwlagn_disable_roc(struct iwl_priv *priv)
 	iwl_set_rxon_channel(priv, chan, ctx);
 	iwl_set_flags_for_band(priv, ctx, chan->band, NULL);
 
-	priv->_agn.hw_roc_channel = NULL;
+	priv->hw_roc_channel = NULL;
 
 	iwlagn_commit_rxon(priv, ctx);
 
@@ -2708,7 +2708,7 @@ static void iwlagn_disable_roc(struct iwl_priv *priv)
 static void iwlagn_bg_roc_done(struct work_struct *work)
 {
 	struct iwl_priv *priv = container_of(work, struct iwl_priv,
-					     _agn.hw_roc_work.work);
+					     hw_roc_work.work);
 
 	mutex_lock(&priv->mutex);
 	ieee80211_remain_on_channel_expired(priv->hw);
@@ -2740,11 +2740,11 @@ static int iwl_mac_remain_on_channel(struct ieee80211_hw *hw,
 	}
 
 	priv->contexts[IWL_RXON_CTX_PAN].is_active = true;
-	priv->_agn.hw_roc_channel = channel;
-	priv->_agn.hw_roc_chantype = channel_type;
-	priv->_agn.hw_roc_duration = DIV_ROUND_UP(duration * 1000, 1024);
+	priv->hw_roc_channel = channel;
+	priv->hw_roc_chantype = channel_type;
+	priv->hw_roc_duration = DIV_ROUND_UP(duration * 1000, 1024);
 	iwlagn_commit_rxon(priv, &priv->contexts[IWL_RXON_CTX_PAN]);
-	queue_delayed_work(priv->workqueue, &priv->_agn.hw_roc_work,
+	queue_delayed_work(priv->workqueue, &priv->hw_roc_work,
 			   msecs_to_jiffies(duration + 20));
 
 	msleep(IWL_MIN_SLOT_TIME); /* TU is almost ms */
@@ -2763,7 +2763,7 @@ static int iwl_mac_cancel_remain_on_channel(struct ieee80211_hw *hw)
 	if (!(priv->valid_contexts & BIT(IWL_RXON_CTX_PAN)))
 		return -EOPNOTSUPP;
 
-	cancel_delayed_work_sync(&priv->_agn.hw_roc_work);
+	cancel_delayed_work_sync(&priv->hw_roc_work);
 
 	mutex_lock(&priv->mutex);
 	iwlagn_disable_roc(priv);
@@ -2790,7 +2790,7 @@ static void iwl_setup_deferred_work(struct iwl_priv *priv)
 	INIT_WORK(&priv->tx_flush, iwl_bg_tx_flush);
 	INIT_WORK(&priv->bt_full_concurrency, iwl_bg_bt_full_concurrency);
 	INIT_WORK(&priv->bt_runtime_config, iwl_bg_bt_runtime_config);
-	INIT_DELAYED_WORK(&priv->_agn.hw_roc_work, iwlagn_bg_roc_done);
+	INIT_DELAYED_WORK(&priv->hw_roc_work, iwlagn_bg_roc_done);
 
 	iwl_setup_scan_deferred_work(priv);
 
@@ -2864,7 +2864,7 @@ static int iwl_init_drv(struct iwl_priv *priv)
 	priv->iw_mode = NL80211_IFTYPE_STATION;
 	priv->current_ht_config.smps = IEEE80211_SMPS_STATIC;
 	priv->missed_beacon_threshold = IWL_MISSED_BEACON_THRESHOLD_DEF;
-	priv->_agn.agg_tids_count = 0;
+	priv->agg_tids_count = 0;
 
 	/* initialize force reset */
 	priv->force_reset[IWL_RF_RESET].reset_duration =
@@ -3247,7 +3247,7 @@ int iwl_probe(struct iwl_bus *bus, struct iwl_cfg *cfg)
 	iwl_power_initialize(priv);
 	iwl_tt_initialize(priv);
 
-	init_completion(&priv->_agn.firmware_loading_complete);
+	init_completion(&priv->firmware_loading_complete);
 
 	err = iwl_request_firmware(priv, true);
 	if (err)
@@ -3274,7 +3274,7 @@ void __devexit iwl_remove(struct iwl_priv * priv)
 {
 	unsigned long flags;
 
-	wait_for_completion(&priv->_agn.firmware_loading_complete);
+	wait_for_completion(&priv->firmware_loading_complete);
 
 	IWL_DEBUG_INFO(priv, "*** UNLOAD DRIVER ***\n");
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 3be0111..9b9f462 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -840,12 +840,12 @@ static void iwlagn_abort_notification_waits(struct iwl_priv *priv)
 	unsigned long flags;
 	struct iwl_notification_wait *wait_entry;
 
-	spin_lock_irqsave(&priv->_agn.notif_wait_lock, flags);
-	list_for_each_entry(wait_entry, &priv->_agn.notif_waits, list)
+	spin_lock_irqsave(&priv->notif_wait_lock, flags);
+	list_for_each_entry(wait_entry, &priv->notif_waits, list)
 		wait_entry->aborted = true;
-	spin_unlock_irqrestore(&priv->_agn.notif_wait_lock, flags);
+	spin_unlock_irqrestore(&priv->notif_wait_lock, flags);
 
-	wake_up_all(&priv->_agn.notif_waitq);
+	wake_up_all(&priv->notif_waitq);
 }
 
 void iwlagn_fw_error(struct iwl_priv *priv, bool ondemand)
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 6f9ebae..17aebf0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -1915,121 +1915,121 @@ static ssize_t iwl_dbgfs_reply_tx_error_read(struct file *file,
 	pos += scnprintf(buf + pos, bufsz - pos, "Statistics_TX_Error:\n");
 	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t\t\t%u\n",
 			 iwl_get_tx_fail_reason(TX_STATUS_POSTPONE_DELAY),
-			 priv->_agn.reply_tx_stats.pp_delay);
+			 priv->reply_tx_stats.pp_delay);
 	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t\t%u\n",
 			 iwl_get_tx_fail_reason(TX_STATUS_POSTPONE_FEW_BYTES),
-			 priv->_agn.reply_tx_stats.pp_few_bytes);
+			 priv->reply_tx_stats.pp_few_bytes);
 	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t\t%u\n",
 			 iwl_get_tx_fail_reason(TX_STATUS_POSTPONE_BT_PRIO),
-			 priv->_agn.reply_tx_stats.pp_bt_prio);
+			 priv->reply_tx_stats.pp_bt_prio);
 	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t\t%u\n",
 			 iwl_get_tx_fail_reason(TX_STATUS_POSTPONE_QUIET_PERIOD),
-			 priv->_agn.reply_tx_stats.pp_quiet_period);
+			 priv->reply_tx_stats.pp_quiet_period);
 	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t\t%u\n",
 			 iwl_get_tx_fail_reason(TX_STATUS_POSTPONE_CALC_TTAK),
-			 priv->_agn.reply_tx_stats.pp_calc_ttak);
+			 priv->reply_tx_stats.pp_calc_ttak);
 	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t%u\n",
 			 iwl_get_tx_fail_reason(
 				TX_STATUS_FAIL_INTERNAL_CROSSED_RETRY),
-			 priv->_agn.reply_tx_stats.int_crossed_retry);
+			 priv->reply_tx_stats.int_crossed_retry);
 	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t\t%u\n",
 			 iwl_get_tx_fail_reason(TX_STATUS_FAIL_SHORT_LIMIT),
-			 priv->_agn.reply_tx_stats.short_limit);
+			 priv->reply_tx_stats.short_limit);
 	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t\t%u\n",
 			 iwl_get_tx_fail_reason(TX_STATUS_FAIL_LONG_LIMIT),
-			 priv->_agn.reply_tx_stats.long_limit);
+			 priv->reply_tx_stats.long_limit);
 	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t\t%u\n",
 			 iwl_get_tx_fail_reason(TX_STATUS_FAIL_FIFO_UNDERRUN),
-			 priv->_agn.reply_tx_stats.fifo_underrun);
+			 priv->reply_tx_stats.fifo_underrun);
 	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t\t%u\n",
 			 iwl_get_tx_fail_reason(TX_STATUS_FAIL_DRAIN_FLOW),
-			 priv->_agn.reply_tx_stats.drain_flow);
+			 priv->reply_tx_stats.drain_flow);
 	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t\t%u\n",
 			 iwl_get_tx_fail_reason(TX_STATUS_FAIL_RFKILL_FLUSH),
-			 priv->_agn.reply_tx_stats.rfkill_flush);
+			 priv->reply_tx_stats.rfkill_flush);
 	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t\t%u\n",
 			 iwl_get_tx_fail_reason(TX_STATUS_FAIL_LIFE_EXPIRE),
-			 priv->_agn.reply_tx_stats.life_expire);
+			 priv->reply_tx_stats.life_expire);
 	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t\t%u\n",
 			 iwl_get_tx_fail_reason(TX_STATUS_FAIL_DEST_PS),
-			 priv->_agn.reply_tx_stats.dest_ps);
+			 priv->reply_tx_stats.dest_ps);
 	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t\t%u\n",
 			 iwl_get_tx_fail_reason(TX_STATUS_FAIL_HOST_ABORTED),
-			 priv->_agn.reply_tx_stats.host_abort);
+			 priv->reply_tx_stats.host_abort);
 	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t\t%u\n",
 			 iwl_get_tx_fail_reason(TX_STATUS_FAIL_BT_RETRY),
-			 priv->_agn.reply_tx_stats.pp_delay);
+			 priv->reply_tx_stats.pp_delay);
 	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t\t%u\n",
 			 iwl_get_tx_fail_reason(TX_STATUS_FAIL_STA_INVALID),
-			 priv->_agn.reply_tx_stats.sta_invalid);
+			 priv->reply_tx_stats.sta_invalid);
 	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t\t%u\n",
 			 iwl_get_tx_fail_reason(TX_STATUS_FAIL_FRAG_DROPPED),
-			 priv->_agn.reply_tx_stats.frag_drop);
+			 priv->reply_tx_stats.frag_drop);
 	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t\t%u\n",
 			 iwl_get_tx_fail_reason(TX_STATUS_FAIL_TID_DISABLE),
-			 priv->_agn.reply_tx_stats.tid_disable);
+			 priv->reply_tx_stats.tid_disable);
 	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t\t%u\n",
 			 iwl_get_tx_fail_reason(TX_STATUS_FAIL_FIFO_FLUSHED),
-			 priv->_agn.reply_tx_stats.fifo_flush);
+			 priv->reply_tx_stats.fifo_flush);
 	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t%u\n",
 			 iwl_get_tx_fail_reason(
 				TX_STATUS_FAIL_INSUFFICIENT_CF_POLL),
-			 priv->_agn.reply_tx_stats.insuff_cf_poll);
+			 priv->reply_tx_stats.insuff_cf_poll);
 	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t\t%u\n",
 			 iwl_get_tx_fail_reason(TX_STATUS_FAIL_PASSIVE_NO_RX),
-			 priv->_agn.reply_tx_stats.fail_hw_drop);
+			 priv->reply_tx_stats.fail_hw_drop);
 	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t%u\n",
 			 iwl_get_tx_fail_reason(
 				TX_STATUS_FAIL_NO_BEACON_ON_RADAR),
-			 priv->_agn.reply_tx_stats.sta_color_mismatch);
+			 priv->reply_tx_stats.sta_color_mismatch);
 	pos += scnprintf(buf + pos, bufsz - pos, "UNKNOWN:\t\t\t%u\n",
-			 priv->_agn.reply_tx_stats.unknown);
+			 priv->reply_tx_stats.unknown);
 
 	pos += scnprintf(buf + pos, bufsz - pos,
 			 "\nStatistics_Agg_TX_Error:\n");
 
 	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t\t%u\n",
 			 iwl_get_agg_tx_fail_reason(AGG_TX_STATE_UNDERRUN_MSK),
-			 priv->_agn.reply_agg_tx_stats.underrun);
+			 priv->reply_agg_tx_stats.underrun);
 	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t\t%u\n",
 			 iwl_get_agg_tx_fail_reason(AGG_TX_STATE_BT_PRIO_MSK),
-			 priv->_agn.reply_agg_tx_stats.bt_prio);
+			 priv->reply_agg_tx_stats.bt_prio);
 	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t\t%u\n",
 			 iwl_get_agg_tx_fail_reason(AGG_TX_STATE_FEW_BYTES_MSK),
-			 priv->_agn.reply_agg_tx_stats.few_bytes);
+			 priv->reply_agg_tx_stats.few_bytes);
 	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t\t%u\n",
 			 iwl_get_agg_tx_fail_reason(AGG_TX_STATE_ABORT_MSK),
-			 priv->_agn.reply_agg_tx_stats.abort);
+			 priv->reply_agg_tx_stats.abort);
 	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t%u\n",
 			 iwl_get_agg_tx_fail_reason(
 				AGG_TX_STATE_LAST_SENT_TTL_MSK),
-			 priv->_agn.reply_agg_tx_stats.last_sent_ttl);
+			 priv->reply_agg_tx_stats.last_sent_ttl);
 	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t%u\n",
 			 iwl_get_agg_tx_fail_reason(
 				AGG_TX_STATE_LAST_SENT_TRY_CNT_MSK),
-			 priv->_agn.reply_agg_tx_stats.last_sent_try);
+			 priv->reply_agg_tx_stats.last_sent_try);
 	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t%u\n",
 			 iwl_get_agg_tx_fail_reason(
 				AGG_TX_STATE_LAST_SENT_BT_KILL_MSK),
-			 priv->_agn.reply_agg_tx_stats.last_sent_bt_kill);
+			 priv->reply_agg_tx_stats.last_sent_bt_kill);
 	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t\t%u\n",
 			 iwl_get_agg_tx_fail_reason(AGG_TX_STATE_SCD_QUERY_MSK),
-			 priv->_agn.reply_agg_tx_stats.scd_query);
+			 priv->reply_agg_tx_stats.scd_query);
 	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t%u\n",
 			 iwl_get_agg_tx_fail_reason(
 				AGG_TX_STATE_TEST_BAD_CRC32_MSK),
-			 priv->_agn.reply_agg_tx_stats.bad_crc32);
+			 priv->reply_agg_tx_stats.bad_crc32);
 	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t\t%u\n",
 			 iwl_get_agg_tx_fail_reason(AGG_TX_STATE_RESPONSE_MSK),
-			 priv->_agn.reply_agg_tx_stats.response);
+			 priv->reply_agg_tx_stats.response);
 	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t\t%u\n",
 			 iwl_get_agg_tx_fail_reason(AGG_TX_STATE_DUMP_TX_MSK),
-			 priv->_agn.reply_agg_tx_stats.dump_tx);
+			 priv->reply_agg_tx_stats.dump_tx);
 	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t\t%u\n",
 			 iwl_get_agg_tx_fail_reason(AGG_TX_STATE_DELAY_TX_MSK),
-			 priv->_agn.reply_agg_tx_stats.delay_tx);
+			 priv->reply_agg_tx_stats.delay_tx);
 	pos += scnprintf(buf + pos, bufsz - pos, "UNKNOWN:\t\t\t%u\n",
-			 priv->_agn.reply_agg_tx_stats.unknown);
+			 priv->reply_agg_tx_stats.unknown);
 
 	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 	kfree(buf);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index da90488..c273804 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1391,56 +1391,54 @@ struct iwl_priv {
 	} accum_stats, delta_stats, max_delta_stats;
 #endif
 
-	struct {
-		/* INT ICT Table */
-		__le32 *ict_tbl;
-		void *ict_tbl_vir;
-		dma_addr_t ict_tbl_dma;
-		dma_addr_t aligned_ict_tbl_dma;
-		int ict_index;
-		u32 inta;
-		bool use_ict;
-		/*
-		 * reporting the number of tids has AGG on. 0 means
-		 * no AGGREGATION
-		 */
-		u8 agg_tids_count;
-
-		struct iwl_rx_phy_res last_phy_res;
-		bool last_phy_res_valid;
-
-		struct completion firmware_loading_complete;
-
-		u32 init_evtlog_ptr, init_evtlog_size, init_errlog_ptr;
-		u32 inst_evtlog_ptr, inst_evtlog_size, inst_errlog_ptr;
-
-		/*
-		 * chain noise reset and gain commands are the
-		 * two extra calibration commands follows the standard
-		 * phy calibration commands
-		 */
-		u8 phy_calib_chain_noise_reset_cmd;
-		u8 phy_calib_chain_noise_gain_cmd;
-
-		/* counts reply_tx error */
-		struct reply_tx_error_statistics reply_tx_stats;
-		struct reply_agg_tx_error_statistics reply_agg_tx_stats;
-		/* notification wait support */
-		struct list_head notif_waits;
-		spinlock_t notif_wait_lock;
-		wait_queue_head_t notif_waitq;
-
-		/* remain-on-channel offload support */
-		struct ieee80211_channel *hw_roc_channel;
-		struct delayed_work hw_roc_work;
-		enum nl80211_channel_type hw_roc_chantype;
-		int hw_roc_duration;
-		bool hw_roc_setup;
-
-		struct sk_buff *offchan_tx_skb;
-		int offchan_tx_timeout;
-		struct ieee80211_channel *offchan_tx_chan;
-	} _agn;
+	/* INT ICT Table */
+	__le32 *ict_tbl;
+	void *ict_tbl_vir;
+	dma_addr_t ict_tbl_dma;
+	dma_addr_t aligned_ict_tbl_dma;
+	int ict_index;
+	u32 inta;
+	bool use_ict;
+	/*
+	 * reporting the number of tids has AGG on. 0 means
+	 * no AGGREGATION
+	 */
+	u8 agg_tids_count;
+
+	struct iwl_rx_phy_res last_phy_res;
+	bool last_phy_res_valid;
+
+	struct completion firmware_loading_complete;
+
+	u32 init_evtlog_ptr, init_evtlog_size, init_errlog_ptr;
+	u32 inst_evtlog_ptr, inst_evtlog_size, inst_errlog_ptr;
+
+	/*
+	 * chain noise reset and gain commands are the
+	 * two extra calibration commands follows the standard
+	 * phy calibration commands
+	 */
+	u8 phy_calib_chain_noise_reset_cmd;
+	u8 phy_calib_chain_noise_gain_cmd;
+
+	/* counts reply_tx error */
+	struct reply_tx_error_statistics reply_tx_stats;
+	struct reply_agg_tx_error_statistics reply_agg_tx_stats;
+	/* notification wait support */
+	struct list_head notif_waits;
+	spinlock_t notif_wait_lock;
+	wait_queue_head_t notif_waitq;
+
+	/* remain-on-channel offload support */
+	struct ieee80211_channel *hw_roc_channel;
+	struct delayed_work hw_roc_work;
+	enum nl80211_channel_type hw_roc_chantype;
+	int hw_roc_duration;
+	bool hw_roc_setup;
+
+	struct sk_buff *offchan_tx_skb;
+	int offchan_tx_timeout;
+	struct ieee80211_channel *offchan_tx_chan;
 
 	/* bt coex */
 	u8 bt_enable_flag;
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index f67931d..8e31400 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -170,7 +170,7 @@ static bool iwl_good_ack_health(struct iwl_priv *priv,
 	int actual_delta, expected_delta, ba_timeout_delta;
 	struct statistics_tx *old;
 
-	if (priv->_agn.agg_tids_count)
+	if (priv->agg_tids_count)
 		return true;
 
 	old = &priv->statistics.tx;
@@ -592,8 +592,8 @@ static void iwl_rx_reply_rx_phy(struct iwl_priv *priv,
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 
-	priv->_agn.last_phy_res_valid = true;
-	memcpy(&priv->_agn.last_phy_res, pkt->u.raw,
+	priv->last_phy_res_valid = true;
+	memcpy(&priv->last_phy_res, pkt->u.raw,
 	       sizeof(struct iwl_rx_phy_res));
 }
 
@@ -841,11 +841,11 @@ static void iwl_rx_reply_rx(struct iwl_priv *priv,
 				phy_res->cfg_phy_cnt + len);
 		ampdu_status = le32_to_cpu(rx_pkt_status);
 	} else {
-		if (!priv->_agn.last_phy_res_valid) {
+		if (!priv->last_phy_res_valid) {
 			IWL_ERR(priv, "MPDU frame without cached PHY data\n");
 			return;
 		}
-		phy_res = &priv->_agn.last_phy_res;
+		phy_res = &priv->last_phy_res;
 		amsdu = (struct iwl_rx_mpdu_res_start *)pkt->u.raw;
 		header = (struct ieee80211_hdr *)(pkt->u.raw + sizeof(*amsdu));
 		len = le16_to_cpu(amsdu->byte_count);
@@ -972,9 +972,9 @@ void iwl_setup_rx_handlers(struct iwl_priv *priv)
 	priv->rx_handlers[REPLY_TX] = iwlagn_rx_reply_tx;
 
 	/* set up notification wait support */
-	spin_lock_init(&priv->_agn.notif_wait_lock);
-	INIT_LIST_HEAD(&priv->_agn.notif_waits);
-	init_waitqueue_head(&priv->_agn.notif_waitq);
+	spin_lock_init(&priv->notif_wait_lock);
+	INIT_LIST_HEAD(&priv->notif_waits);
+	init_waitqueue_head(&priv->notif_waitq);
 
 	/* Set up BT Rx handlers */
 	if (priv->cfg->lib->bt_rx_handler_setup)
@@ -991,11 +991,11 @@ void iwl_rx_dispatch(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 	 * even if the RX handler consumes the RXB we have
 	 * access to it in the notification wait entry.
 	 */
-	if (!list_empty(&priv->_agn.notif_waits)) {
+	if (!list_empty(&priv->notif_waits)) {
 		struct iwl_notification_wait *w;
 
-		spin_lock(&priv->_agn.notif_wait_lock);
-		list_for_each_entry(w, &priv->_agn.notif_waits, list) {
+		spin_lock(&priv->notif_wait_lock);
+		list_for_each_entry(w, &priv->notif_waits, list) {
 			if (w->cmd != pkt->hdr.cmd)
 				continue;
 			IWL_DEBUG_RX(priv,
@@ -1006,9 +1006,9 @@ void iwl_rx_dispatch(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 			if (w->fn)
 				w->fn(priv, pkt, w->fn_data);
 		}
-		spin_unlock(&priv->_agn.notif_wait_lock);
+		spin_unlock(&priv->notif_wait_lock);
 
-		wake_up_all(&priv->_agn.notif_waitq);
+		wake_up_all(&priv->notif_waitq);
 	}
 
 	if (priv->pre_rx_handler)
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 0505b1a..dd6937e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -565,10 +565,10 @@ static void iwl_bg_scan_completed(struct work_struct *work)
 		goto out_settings;
 	}
 
-	if (priv->scan_type == IWL_SCAN_OFFCH_TX && priv->_agn.offchan_tx_skb) {
+	if (priv->scan_type == IWL_SCAN_OFFCH_TX && priv->offchan_tx_skb) {
 		ieee80211_tx_status_irqsafe(priv->hw,
-					    priv->_agn.offchan_tx_skb);
-		priv->_agn.offchan_tx_skb = NULL;
+					    priv->offchan_tx_skb);
+		priv->offchan_tx_skb = NULL;
 	}
 
 	if (priv->scan_type != IWL_SCAN_NORMAL && !aborted) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
index 7434358..4748602 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
@@ -510,9 +510,9 @@ void iwl_irq_tasklet(struct iwl_priv *priv)
 	 * hardware bugs here by ACKing all the possible interrupts so that
 	 * interrupt coalescing can still be achieved.
 	 */
-	iwl_write32(priv, CSR_INT, priv->_agn.inta | ~priv->inta_mask);
+	iwl_write32(priv, CSR_INT, priv->inta | ~priv->inta_mask);
 
-	inta = priv->_agn.inta;
+	inta = priv->inta;
 
 #ifdef CONFIG_IWLWIFI_DEBUG
 	if (iwl_get_debug_level(priv) & IWL_DL_ISR) {
@@ -525,8 +525,8 @@ void iwl_irq_tasklet(struct iwl_priv *priv)
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	/* saved interrupt in inta variable now we can reset priv->_agn.inta */
-	priv->_agn.inta = 0;
+	/* saved interrupt in inta variable now we can reset priv->inta */
+	priv->inta = 0;
 
 	/* Now service all interrupt bits discovered above. */
 	if (inta & CSR_INT_BIT_HW_ERR) {
@@ -703,16 +703,16 @@ void iwl_irq_tasklet(struct iwl_priv *priv)
 /* Free dram table */
 void iwl_free_isr_ict(struct iwl_priv *priv)
 {
-	if (priv->_agn.ict_tbl_vir) {
+	if (priv->ict_tbl_vir) {
 		dma_free_coherent(priv->bus->dev,
 				  (sizeof(u32) * ICT_COUNT) + PAGE_SIZE,
-				  priv->_agn.ict_tbl_vir,
-				  priv->_agn.ict_tbl_dma);
-		priv->_agn.ict_tbl_vir = NULL;
-		memset(&priv->_agn.ict_tbl_dma, 0,
-			sizeof(priv->_agn.ict_tbl_dma));
-		memset(&priv->_agn.aligned_ict_tbl_dma, 0,
-			sizeof(priv->_agn.aligned_ict_tbl_dma));
+				  priv->ict_tbl_vir,
+				  priv->ict_tbl_dma);
+		priv->ict_tbl_vir = NULL;
+		memset(&priv->ict_tbl_dma, 0,
+			sizeof(priv->ict_tbl_dma));
+		memset(&priv->aligned_ict_tbl_dma, 0,
+			sizeof(priv->aligned_ict_tbl_dma));
 	}
 }
 
@@ -724,36 +724,36 @@ int iwl_alloc_isr_ict(struct iwl_priv *priv)
 {
 
 	/* allocate shrared data table */
-	priv->_agn.ict_tbl_vir =
+	priv->ict_tbl_vir =
 		dma_alloc_coherent(priv->bus->dev,
 				   (sizeof(u32) * ICT_COUNT) + PAGE_SIZE,
-				   &priv->_agn.ict_tbl_dma, GFP_KERNEL);
-	if (!priv->_agn.ict_tbl_vir)
+				   &priv->ict_tbl_dma, GFP_KERNEL);
+	if (!priv->ict_tbl_vir)
 		return -ENOMEM;
 
 	/* align table to PAGE_SIZE boundary */
-	priv->_agn.aligned_ict_tbl_dma =
-		ALIGN(priv->_agn.ict_tbl_dma, PAGE_SIZE);
+	priv->aligned_ict_tbl_dma =
+		ALIGN(priv->ict_tbl_dma, PAGE_SIZE);
 
 	IWL_DEBUG_ISR(priv, "ict dma addr %Lx dma aligned %Lx diff %d\n",
-			     (unsigned long long)priv->_agn.ict_tbl_dma,
-			     (unsigned long long)priv->_agn.aligned_ict_tbl_dma,
-			     (int)(priv->_agn.aligned_ict_tbl_dma -
-			     priv->_agn.ict_tbl_dma));
+			     (unsigned long long)priv->ict_tbl_dma,
+			     (unsigned long long)priv->aligned_ict_tbl_dma,
+			     (int)(priv->aligned_ict_tbl_dma -
+			     priv->ict_tbl_dma));
 
-	priv->_agn.ict_tbl =  priv->_agn.ict_tbl_vir +
-			  (priv->_agn.aligned_ict_tbl_dma -
-			  priv->_agn.ict_tbl_dma);
+	priv->ict_tbl =  priv->ict_tbl_vir +
+			  (priv->aligned_ict_tbl_dma -
+			  priv->ict_tbl_dma);
 
 	IWL_DEBUG_ISR(priv, "ict vir addr %p vir aligned %p diff %d\n",
-			     priv->_agn.ict_tbl, priv->_agn.ict_tbl_vir,
-			(int)(priv->_agn.aligned_ict_tbl_dma -
-			    priv->_agn.ict_tbl_dma));
+			     priv->ict_tbl, priv->ict_tbl_vir,
+			(int)(priv->aligned_ict_tbl_dma -
+			    priv->ict_tbl_dma));
 
 	/* reset table and index to all 0 */
-	memset(priv->_agn.ict_tbl_vir, 0,
+	memset(priv->ict_tbl_vir, 0,
 		(sizeof(u32) * ICT_COUNT) + PAGE_SIZE);
-	priv->_agn.ict_index = 0;
+	priv->ict_index = 0;
 
 	/* add periodic RX interrupt */
 	priv->inta_mask |= CSR_INT_BIT_RX_PERIODIC;
@@ -768,15 +768,15 @@ int iwl_reset_ict(struct iwl_priv *priv)
 	u32 val;
 	unsigned long flags;
 
-	if (!priv->_agn.ict_tbl_vir)
+	if (!priv->ict_tbl_vir)
 		return 0;
 
 	spin_lock_irqsave(&priv->lock, flags);
 	iwl_disable_interrupts(priv);
 
-	memset(&priv->_agn.ict_tbl[0], 0, sizeof(u32) * ICT_COUNT);
+	memset(&priv->ict_tbl[0], 0, sizeof(u32) * ICT_COUNT);
 
-	val = priv->_agn.aligned_ict_tbl_dma >> PAGE_SHIFT;
+	val = priv->aligned_ict_tbl_dma >> PAGE_SHIFT;
 
 	val |= CSR_DRAM_INT_TBL_ENABLE;
 	val |= CSR_DRAM_INIT_TBL_WRAP_CHECK;
@@ -784,11 +784,11 @@ int iwl_reset_ict(struct iwl_priv *priv)
 	IWL_DEBUG_ISR(priv, "CSR_DRAM_INT_TBL_REG =0x%X "
 			"aligned dma address %Lx\n",
 			val,
-			(unsigned long long)priv->_agn.aligned_ict_tbl_dma);
+			(unsigned long long)priv->aligned_ict_tbl_dma);
 
 	iwl_write32(priv, CSR_DRAM_INT_TBL_REG, val);
-	priv->_agn.use_ict = true;
-	priv->_agn.ict_index = 0;
+	priv->use_ict = true;
+	priv->ict_index = 0;
 	iwl_write32(priv, CSR_INT, priv->inta_mask);
 	iwl_enable_interrupts(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
@@ -802,7 +802,7 @@ void iwl_disable_ict(struct iwl_priv *priv)
 	unsigned long flags;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	priv->_agn.use_ict = false;
+	priv->use_ict = false;
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
@@ -852,12 +852,12 @@ static irqreturn_t iwl_isr(int irq, void *data)
 	}
 #endif
 
-	priv->_agn.inta |= inta;
+	priv->inta |= inta;
 	/* iwl_irq_tasklet() will service interrupts and re-enable them */
 	if (likely(inta))
 		tasklet_schedule(&priv->irq_tasklet);
 	else if (test_bit(STATUS_INT_ENABLED, &priv->status) &&
-			!priv->_agn.inta)
+			!priv->inta)
 		iwl_enable_interrupts(priv);
 
  unplugged:
@@ -867,7 +867,7 @@ static irqreturn_t iwl_isr(int irq, void *data)
  none:
 	/* re-enable interrupts here since we don't have anything to service. */
 	/* only Re-enable if disabled by irq  and no schedules tasklet. */
-	if (test_bit(STATUS_INT_ENABLED, &priv->status) && !priv->_agn.inta)
+	if (test_bit(STATUS_INT_ENABLED, &priv->status) && !priv->inta)
 		iwl_enable_interrupts(priv);
 
 	spin_unlock_irqrestore(&priv->lock, flags);
@@ -895,7 +895,7 @@ irqreturn_t iwl_isr_ict(int irq, void *data)
 	/* dram interrupt table not set yet,
 	 * use legacy interrupt.
 	 */
-	if (!priv->_agn.use_ict)
+	if (!priv->use_ict)
 		return iwl_isr(irq, data);
 
 	spin_lock_irqsave(&priv->lock, flags);
@@ -912,21 +912,21 @@ irqreturn_t iwl_isr_ict(int irq, void *data)
 	/* Ignore interrupt if there's nothing in NIC to service.
 	 * This may be due to IRQ shared with another device,
 	 * or due to sporadic interrupts thrown from our NIC. */
-	if (!priv->_agn.ict_tbl[priv->_agn.ict_index]) {
+	if (!priv->ict_tbl[priv->ict_index]) {
 		IWL_DEBUG_ISR(priv, "Ignore interrupt, inta == 0\n");
 		goto none;
 	}
 
 	/* read all entries that not 0 start with ict_index */
-	while (priv->_agn.ict_tbl[priv->_agn.ict_index]) {
+	while (priv->ict_tbl[priv->ict_index]) {
 
-		val |= le32_to_cpu(priv->_agn.ict_tbl[priv->_agn.ict_index]);
+		val |= le32_to_cpu(priv->ict_tbl[priv->ict_index]);
 		IWL_DEBUG_ISR(priv, "ICT index %d value 0x%08X\n",
-				priv->_agn.ict_index,
+				priv->ict_index,
 				le32_to_cpu(
-				    priv->_agn.ict_tbl[priv->_agn.ict_index]));
-		priv->_agn.ict_tbl[priv->_agn.ict_index] = 0;
-		priv->_agn.ict_index = iwl_queue_inc_wrap(priv->_agn.ict_index,
+				    priv->ict_tbl[priv->ict_index]));
+		priv->ict_tbl[priv->ict_index] = 0;
+		priv->ict_index = iwl_queue_inc_wrap(priv->ict_index,
 						     ICT_COUNT);
 
 	}
@@ -950,13 +950,13 @@ irqreturn_t iwl_isr_ict(int irq, void *data)
 			inta, inta_mask, val);
 
 	inta &= priv->inta_mask;
-	priv->_agn.inta |= inta;
+	priv->inta |= inta;
 
 	/* iwl_irq_tasklet() will service interrupts and re-enable them */
 	if (likely(inta))
 		tasklet_schedule(&priv->irq_tasklet);
 	else if (test_bit(STATUS_INT_ENABLED, &priv->status) &&
-			!priv->_agn.inta) {
+			!priv->inta) {
 		/* Allow interrupt if was disabled by this handler and
 		 * no tasklet was schedules, We should not enable interrupt,
 		 * tasklet will enable it.
@@ -971,7 +971,7 @@ irqreturn_t iwl_isr_ict(int irq, void *data)
 	/* re-enable interrupts here since we don't have anything to service.
 	 * only Re-enable if disabled by irq.
 	 */
-	if (test_bit(STATUS_INT_ENABLED, &priv->status) && !priv->_agn.inta)
+	if (test_bit(STATUS_INT_ENABLED, &priv->status) && !priv->inta)
 		iwl_enable_interrupts(priv);
 
 	spin_unlock_irqrestore(&priv->lock, flags);
-- 
1.7.0.4

