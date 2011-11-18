Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60509 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755413Ab1KRIVW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:21:22 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAI8LMjW026083
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 03:21:22 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 16/77] iwlegacy: remove not needed parentheses
Date: Fri, 18 Nov 2011 09:21:38 +0100
Message-Id: <1321604559-10707-16-git-send-email-sgruszka@redhat.com> (sfid-20111118_092130_662465_730137D2)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/iwl-3945-hw.h    |    4 +-
 drivers/net/wireless/iwlegacy/iwl-3945-rs.c    |   40 ++++----
 drivers/net/wireless/iwlegacy/iwl-3945.c       |   25 +++---
 drivers/net/wireless/iwlegacy/iwl-4965-calib.c |   27 +++---
 drivers/net/wireless/iwlegacy/iwl-4965-hw.h    |    8 +-
 drivers/net/wireless/iwlegacy/iwl-4965-lib.c   |    6 +-
 drivers/net/wireless/iwlegacy/iwl-4965-rs.c    |  125 +++++++++++-------------
 drivers/net/wireless/iwlegacy/iwl-4965-tx.c    |   19 ++--
 drivers/net/wireless/iwlegacy/iwl-4965.c       |   44 ++++----
 drivers/net/wireless/iwlegacy/iwl-4965.h       |    4 +-
 drivers/net/wireless/iwlegacy/iwl-core.c       |   18 ++--
 drivers/net/wireless/iwlegacy/iwl-io.h         |    2 +-
 drivers/net/wireless/iwlegacy/iwl-legacy-rs.h  |    2 +-
 drivers/net/wireless/iwlegacy/iwl-scan.c       |    2 +-
 drivers/net/wireless/iwlegacy/iwl-sta.c        |    2 +-
 drivers/net/wireless/iwlegacy/iwl-tx.c         |    2 +-
 drivers/net/wireless/iwlegacy/iwl3945-base.c   |   20 ++--
 17 files changed, 168 insertions(+), 182 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-3945-hw.h b/drivers/net/wireless/iwlegacy/iwl-3945-hw.h
index ad05093..67650ff 100644
--- a/drivers/net/wireless/iwlegacy/iwl-3945-hw.h
+++ b/drivers/net/wireless/iwlegacy/iwl-3945-hw.h
@@ -264,8 +264,8 @@ struct il3945_eeprom {
 
 static inline int il3945_hw_valid_rtc_data_addr(u32 addr)
 {
-	return (addr >= IWL39_RTC_DATA_LOWER_BOUND) &&
-	       (addr < IWL39_RTC_DATA_UPPER_BOUND);
+	return (addr >= IWL39_RTC_DATA_LOWER_BOUND &&
+		addr < IWL39_RTC_DATA_UPPER_BOUND);
 }
 
 /* Base physical address of il3945_shared is provided to FH_TSSR_CBB_BASE
diff --git a/drivers/net/wireless/iwlegacy/iwl-3945-rs.c b/drivers/net/wireless/iwlegacy/iwl-3945-rs.c
index d05da7a..afa6be8 100644
--- a/drivers/net/wireless/iwlegacy/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlegacy/iwl-3945-rs.c
@@ -104,7 +104,7 @@ static u8 il3945_get_rate_index_by_rssi(s32 rssi, enum ieee80211_band band)
 	u32 table_size = 0;
 	struct il3945_tpt_entry *tpt_table = NULL;
 
-	if ((rssi < IL_MIN_RSSI_VAL) || (rssi > IL_MAX_RSSI_VAL))
+	if (rssi < IL_MIN_RSSI_VAL || rssi > IL_MAX_RSSI_VAL)
 		rssi = IL_MIN_RSSI_VAL;
 
 	switch (band) {
@@ -123,7 +123,7 @@ static u8 il3945_get_rate_index_by_rssi(s32 rssi, enum ieee80211_band band)
 		break;
 	}
 
-	while ((index < table_size) && (rssi < tpt_table[index].min_rssi))
+	while (index < table_size && rssi < tpt_table[index].min_rssi)
 		index++;
 
 	index = min(index, (table_size - 1));
@@ -315,8 +315,8 @@ static void il3945_collect_tx_data(struct il3945_rs_sta *rs_sta,
 	fail_count = window->counter - window->success_counter;
 
 	/* Calculate average throughput, if we have enough history. */
-	if ((fail_count >= IL_RATE_MIN_FAILURE_TH) ||
-	    (window->success_counter >= IL_RATE_MIN_SUCCESS_TH))
+	if (fail_count >= IL_RATE_MIN_FAILURE_TH ||
+	    window->success_counter >= IL_RATE_MIN_SUCCESS_TH)
 		window->average_tpt = ((window->success_ratio *
 				rs_sta->expected_tpt[index] + 64) / 128);
 	else
@@ -461,7 +461,7 @@ static void il3945_rs_tx_status(void *il_rate, struct ieee80211_supported_band *
 		retries = IL_RATE_RETRY_TH;
 
 	first_index = sband->bitrates[info->status.rates[0].idx].hw_value;
-	if ((first_index < 0) || (first_index >= IL_RATE_COUNT_3945)) {
+	if (first_index < 0 || first_index >= IL_RATE_COUNT_3945) {
 		D_RATE("leave: Rate out of bounds: %d\n", first_index);
 		return;
 	}
@@ -663,9 +663,9 @@ static void il3945_rs_get_rate(void *il_r, struct ieee80211_sta *sta,
 
 	/* get user max rate if set */
 	max_rate_idx = txrc->max_rate_idx;
-	if ((sband->band == IEEE80211_BAND_5GHZ) && (max_rate_idx != -1))
+	if (sband->band == IEEE80211_BAND_5GHZ && max_rate_idx != -1)
 		max_rate_idx += IL_FIRST_OFDM_RATE;
-	if ((max_rate_idx < 0) || (max_rate_idx >= IL_RATE_COUNT))
+	if (max_rate_idx < 0 || max_rate_idx >= IL_RATE_COUNT)
 		max_rate_idx = -1;
 
 	index = min(rs_sta->last_txrate_idx & 0xffff, IL_RATE_COUNT_3945 - 1);
@@ -686,7 +686,7 @@ static void il3945_rs_get_rate(void *il_r, struct ieee80211_sta *sta,
 	}
 
 	/* force user max rate if set by user */
-	if ((max_rate_idx != -1) && (max_rate_idx < index)) {
+	if (max_rate_idx != -1 && max_rate_idx < index) {
 		if (rate_mask & (1 << max_rate_idx))
 			index = max_rate_idx;
 	}
@@ -695,8 +695,8 @@ static void il3945_rs_get_rate(void *il_r, struct ieee80211_sta *sta,
 
 	fail_count = window->counter - window->success_counter;
 
-	if (((fail_count < IL_RATE_MIN_FAILURE_TH) &&
-	     (window->success_counter < IL_RATE_MIN_SUCCESS_TH))) {
+	if (fail_count < IL_RATE_MIN_FAILURE_TH &&
+	    window->success_counter < IL_RATE_MIN_SUCCESS_TH) {
 		spin_unlock_irqrestore(&rs_sta->lock, flags);
 
 		D_RATE("Invalid average_tpt on rate %d: "
@@ -721,7 +721,7 @@ static void il3945_rs_get_rate(void *il_r, struct ieee80211_sta *sta,
 	high = (high_low >> 8) & 0xff;
 
 	/* If user set max rate, dont allow higher than user constrain */
-	if ((max_rate_idx != -1) && (max_rate_idx < high))
+	if (max_rate_idx != -1 && max_rate_idx < high)
 		high = IL_RATE_INVALID;
 
 	/* Collect Measured throughputs of adjacent rates */
@@ -736,13 +736,13 @@ static void il3945_rs_get_rate(void *il_r, struct ieee80211_sta *sta,
 	scale_action = 0;
 
 	/* Low success ratio , need to drop the rate */
-	if ((window->success_ratio < IL_RATE_DECREASE_TH) || !current_tpt) {
+	if (window->success_ratio < IL_RATE_DECREASE_TH || !current_tpt) {
 		D_RATE("decrease rate because of low success_ratio\n");
 		scale_action = -1;
 	/* No throughput measured yet for adjacent rates,
 	 * try increase */
-	} else if ((low_tpt == IL_INVALID_VALUE) &&
-		   (high_tpt == IL_INVALID_VALUE)) {
+	} else if (low_tpt == IL_INVALID_VALUE &&
+		   high_tpt == IL_INVALID_VALUE) {
 
 		if (high != IL_RATE_INVALID && window->success_ratio >= IL_RATE_INCREASE_TH)
 			scale_action = 1;
@@ -752,9 +752,9 @@ static void il3945_rs_get_rate(void *il_r, struct ieee80211_sta *sta,
 	/* Both adjacent throughputs are measured, but neither one has
 	 * better throughput; we're using the best rate, don't change
 	 * it! */
-	} else if ((low_tpt != IL_INVALID_VALUE) &&
-		 (high_tpt != IL_INVALID_VALUE) &&
-		 (low_tpt < current_tpt) && (high_tpt < current_tpt)) {
+	} else if (low_tpt != IL_INVALID_VALUE &&
+		 high_tpt != IL_INVALID_VALUE &&
+		 low_tpt < current_tpt && high_tpt < current_tpt) {
 
 		D_RATE("No action -- low [%d] & high [%d] < "
 			       "current_tpt [%d]\n",
@@ -790,9 +790,9 @@ static void il3945_rs_get_rate(void *il_r, struct ieee80211_sta *sta,
 
 	/* Sanity check; asked for decrease, but success rate or throughput
 	 * has been good at old rate.  Don't change it. */
-	if ((scale_action == -1) && (low != IL_RATE_INVALID) &&
-		    ((window->success_ratio > IL_RATE_HIGH_TH) ||
-		     (current_tpt > (100 * rs_sta->expected_tpt[low]))))
+	if (scale_action == -1 && low != IL_RATE_INVALID &&
+	    (window->success_ratio > IL_RATE_HIGH_TH ||
+	     current_tpt > 100 * rs_sta->expected_tpt[low]))
 		scale_action = 0;
 
 	switch (scale_action) {
diff --git a/drivers/net/wireless/iwlegacy/iwl-3945.c b/drivers/net/wireless/iwlegacy/iwl-3945.c
index cdea5b0..fb69b74 100644
--- a/drivers/net/wireless/iwlegacy/iwl-3945.c
+++ b/drivers/net/wireless/iwlegacy/iwl-3945.c
@@ -173,7 +173,7 @@ void il3945_disable_events(struct il_priv *il)
 	disable_ptr = il_read_targ_mem(il, base + (4 * sizeof(u32)));
 	array_size = il_read_targ_mem(il, base + (5 * sizeof(u32)));
 
-	if (IL_EVT_DISABLE && (array_size == IL_EVT_DISABLE_SIZE)) {
+	if (IL_EVT_DISABLE && array_size == IL_EVT_DISABLE_SIZE) {
 		D_INFO("Disabling selected uCode log events at 0x%x\n",
 			       disable_ptr);
 		for (i = 0; i < IL_EVT_DISABLE_SIZE; i++)
@@ -293,9 +293,8 @@ static void il3945_tx_queue_reclaim(struct il_priv *il,
 		il->cfg->ops->lib->txq_free_tfd(il, txq);
 	}
 
-	if (il_queue_space(q) > q->low_mark && (txq_id >= 0) &&
-			(txq_id != IWL39_CMD_QUEUE_NUM) &&
-			il->mac80211_registered)
+	if (il_queue_space(q) > q->low_mark && txq_id >= 0 &&
+	    txq_id != IWL39_CMD_QUEUE_NUM && il->mac80211_registered)
 		il_wake_queue(il, txq);
 }
 
@@ -316,7 +315,7 @@ static void il3945_rx_reply_tx(struct il_priv *il,
 	int rate_idx;
 	int fail;
 
-	if ((index >= txq->q.n_bd) || (il_queue_used(&txq->q, index) == 0)) {
+	if (index >= txq->q.n_bd || il_queue_used(&txq->q, index) == 0) {
 		IL_ERR("Read index for DMA queue txq_id (%d) index %d "
 			  "is out of range [0-%d] %d %d\n", txq_id,
 			  index, txq->q.n_bd, txq->q.write_ptr,
@@ -544,8 +543,8 @@ static void il3945_rx_reply_rx(struct il_priv *il,
 		return;
 	}
 
-	if (!(rx_end->status & RX_RES_STATUS_NO_CRC32_ERROR)
-	    || !(rx_end->status & RX_RES_STATUS_NO_RXE_OVERFLOW)) {
+	if (!(rx_end->status & RX_RES_STATUS_NO_CRC32_ERROR) ||
+	    !(rx_end->status & RX_RES_STATUS_NO_RXE_OVERFLOW)) {
 		D_RX("Bad CRC or FIFO: 0x%08X.\n", rx_end->status);
 		return;
 	}
@@ -599,7 +598,7 @@ int il3945_hw_txq_attach_buf_to_tfd(struct il_priv *il,
 
 	count = TFD_CTL_COUNT_GET(le32_to_cpu(tfd->control_flags));
 
-	if ((count >= NUM_TFD_CHUNKS) || (count < 0)) {
+	if (count >= NUM_TFD_CHUNKS || count < 0) {
 		IL_ERR("Error can not send more than %d chunks\n",
 			  NUM_TFD_CHUNKS);
 		return -EINVAL;
@@ -1053,7 +1052,7 @@ static int il3945_hw_reg_adjust_power_by_temp(int new_reading, int old_reading)
  */
 static inline int il3945_hw_reg_temp_out_of_range(int temperature)
 {
-	return ((temperature < -260) || (temperature > 25)) ? 1 : 0;
+	return (temperature < -260 || temperature > 25) ? 1 : 0;
 }
 
 int il3945_hw_get_temperature(struct il_priv *il)
@@ -1666,10 +1665,10 @@ static int il3945_send_rxon_assoc(struct il_priv *il,
 	const struct il_rxon_cmd *rxon1 = &ctx->staging;
 	const struct il_rxon_cmd *rxon2 = &ctx->active;
 
-	if ((rxon1->flags == rxon2->flags) &&
-	    (rxon1->filter_flags == rxon2->filter_flags) &&
-	    (rxon1->cck_basic_rates == rxon2->cck_basic_rates) &&
-	    (rxon1->ofdm_basic_rates == rxon2->ofdm_basic_rates)) {
+	if (rxon1->flags == rxon2->flags &&
+	    rxon1->filter_flags == rxon2->filter_flags &&
+	    rxon1->cck_basic_rates == rxon2->cck_basic_rates &&
+	    rxon1->ofdm_basic_rates == rxon2->ofdm_basic_rates) {
 		D_INFO("Using current RXON_ASSOC.  Not resending.\n");
 		return 0;
 	}
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-calib.c b/drivers/net/wireless/iwlegacy/iwl-4965-calib.c
index 7f85834..c055a15 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-calib.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-calib.c
@@ -198,8 +198,8 @@ static int il4965_sens_energy_cck(struct il_priv *il,
 			data->num_in_cck_no_fa);
 
 	/* If we got too many false alarms this time, reduce sensitivity */
-	if ((false_alarms > max_false_alarms) &&
-		(data->auto_corr_cck > AUTO_CORR_MAX_TH_CCK)) {
+	if (false_alarms > max_false_alarms &&
+	    data->auto_corr_cck > AUTO_CORR_MAX_TH_CCK) {
 		D_CALIB("norm FA %u > max FA %u\n",
 		     false_alarms, max_false_alarms);
 		D_CALIB("... reducing sensitivity\n");
@@ -230,9 +230,9 @@ static int il4965_sens_energy_cck(struct il_priv *il,
 		 *      from a previous beacon with too many, or healthy # FAs
 		 * OR 2) We've seen a lot of beacons (100) with too few
 		 *       false alarms */
-		if ((data->nrg_prev_state != IL_FA_TOO_MANY) &&
-			((data->nrg_auto_corr_silence_diff > NRG_DIFF) ||
-			(data->num_in_cck_no_fa > MAX_NUMBER_CCK_NO_FA))) {
+		if (data->nrg_prev_state != IL_FA_TOO_MANY &&
+		    (data->nrg_auto_corr_silence_diff > NRG_DIFF ||
+		     data->num_in_cck_no_fa > MAX_NUMBER_CCK_NO_FA)) {
 
 			D_CALIB("... increasing sensitivity\n");
 			/* Increase nrg value to increase sensitivity */
@@ -289,9 +289,9 @@ static int il4965_sens_energy_cck(struct il_priv *il,
 		val = data->auto_corr_cck_mrc + AUTO_CORR_STEP_CCK;
 		data->auto_corr_cck_mrc =
 			min((u32)ranges->auto_corr_max_cck_mrc, val);
-	} else if ((false_alarms < min_false_alarms) &&
-	   ((data->nrg_auto_corr_silence_diff > NRG_DIFF) ||
-	   (data->num_in_cck_no_fa > MAX_NUMBER_CCK_NO_FA))) {
+	} else if (false_alarms < min_false_alarms &&
+		   (data->nrg_auto_corr_silence_diff > NRG_DIFF ||
+		    data->num_in_cck_no_fa > MAX_NUMBER_CCK_NO_FA)) {
 
 		/* Decrease auto_corr values to increase sensitivity */
 		val = data->auto_corr_cck - AUTO_CORR_STEP_CCK;
@@ -747,9 +747,8 @@ static void il4965_gain_computation(struct il_priv *il,
 	for (i = default_chain; i < NUM_RX_CHAINS; i++) {
 		s32 delta_g = 0;
 
-		if (!(data->disconn_array[i]) &&
-		    (data->delta_gain_code[i] ==
-			     CHAIN_NOISE_DELTA_GAIN_INIT_VAL)) {
+		if (!data->disconn_array[i] &&
+		    data->delta_gain_code[i] == CHAIN_NOISE_DELTA_GAIN_INIT_VAL) {
 			delta_g = average_noise[i] - min_average_noise;
 			data->delta_gain_code[i] = (u8)((delta_g * 10) / 15);
 			data->delta_gain_code[i] =
@@ -860,7 +859,7 @@ void il4965_chain_noise_calibration(struct il_priv *il, void *stat_resp)
 
 	/* Make sure we accumulate data for just the associated channel
 	 *   (even if scanning). */
-	if ((rxon_chnum != stat_chnum) || (rxon_band24 != stat_band24)) {
+	if (rxon_chnum != stat_chnum || rxon_band24 != stat_band24) {
 		D_CALIB("Stats not from chan=%d, band24=%d\n",
 				rxon_chnum, rxon_band24);
 		spin_unlock_irqrestore(&il->lock, flags);
@@ -920,8 +919,8 @@ void il4965_chain_noise_calibration(struct il_priv *il, void *stat_resp)
 			   il->cfg->base_params->chain_noise_num_beacons;
 
 	for (i = 0; i < NUM_RX_CHAINS; i++) {
-		if (!(data->disconn_array[i]) &&
-		   (average_noise[i] <= min_average_noise)) {
+		if (!data->disconn_array[i] &&
+		    average_noise[i] <= min_average_noise) {
 			/* This means that chain i is active and has
 			 * lower noise values so far: */
 			min_average_noise = average_noise[i];
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-hw.h b/drivers/net/wireless/iwlegacy/iwl-4965-hw.h
index b6b7fe2..b21c004 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-hw.h
@@ -102,8 +102,8 @@
 
 static inline int il4965_hw_valid_rtc_data_addr(u32 addr)
 {
-	return (addr >= IWL49_RTC_DATA_LOWER_BOUND) &&
-	       (addr < IWL49_RTC_DATA_UPPER_BOUND);
+	return (addr >= IWL49_RTC_DATA_LOWER_BOUND &&
+		addr < IWL49_RTC_DATA_UPPER_BOUND);
 }
 
 /********************* START TEMPERATURE *************************************/
@@ -147,8 +147,8 @@ static inline int il4965_hw_valid_rtc_data_addr(u32 addr)
 #define IL_TX_POWER_TEMPERATURE_MAX  (410)
 
 #define IL_TX_POWER_TEMPERATURE_OUT_OF_RANGE(t) \
-	(((t) < IL_TX_POWER_TEMPERATURE_MIN) || \
-	 ((t) > IL_TX_POWER_TEMPERATURE_MAX))
+	((t) < IL_TX_POWER_TEMPERATURE_MIN || \
+	 (t) > IL_TX_POWER_TEMPERATURE_MAX)
 
 /********************* END TEMPERATURE ***************************************/
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-lib.c b/drivers/net/wireless/iwlegacy/iwl-4965-lib.c
index 8fafd20..8bb2b62 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-lib.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-lib.c
@@ -234,7 +234,7 @@ void il4965_rx_queue_restock(struct il_priv *il)
 	unsigned long flags;
 
 	spin_lock_irqsave(&rxq->lock, flags);
-	while ((il_rx_queue_space(rxq) > 0) && (rxq->free_count)) {
+	while (il_rx_queue_space(rxq) > 0 && rxq->free_count) {
 		/* The overwritten rxb must be a used one */
 		rxb = rxq->queue[rxq->write];
 		BUG_ON(rxb && rxb->page);
@@ -307,7 +307,7 @@ static void il4965_rx_allocate(struct il_priv *il, gfp_t priority)
 					       "order: %d\n",
 					       il->hw_params.rx_page_order);
 
-			if ((rxq->free_count <= RX_LOW_WATERMARK) &&
+			if (rxq->free_count <= RX_LOW_WATERMARK &&
 			    net_ratelimit())
 				IL_ERR(
 					"Failed to alloc_pages with %s. "
@@ -1106,7 +1106,7 @@ void il4965_set_rxon_chain(struct il_priv *il, struct il_rxon_context *ctx)
 
 	ctx->staging.rx_chain = cpu_to_le16(rx_chain);
 
-	if (!is_single && (active_rx_cnt >= IL_NUM_RX_CHAINS_SINGLE) && is_cam)
+	if (!is_single && active_rx_cnt >= IL_NUM_RX_CHAINS_SINGLE && is_cam)
 		ctx->staging.rx_chain |= RXON_RX_CHAIN_MIMO_FORCE_MSK;
 	else
 		ctx->staging.rx_chain &= ~RXON_RX_CHAIN_MIMO_FORCE_MSK;
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-rs.c b/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
index 93bb31d..c2f4230 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
@@ -127,7 +127,7 @@ static int il4965_hwrate_to_plcp_idx(u32 rate_n_flags)
 		/* skip 9M not supported in ht*/
 		if (idx >= IL_RATE_9M_INDEX)
 			idx += 1;
-		if ((idx >= IL_FIRST_OFDM_RATE) && (idx <= IL_LAST_OFDM_RATE))
+		if (idx >= IL_FIRST_OFDM_RATE && idx <= IL_LAST_OFDM_RATE)
 			return idx;
 
 	/* legacy rate format, search for match in table */
@@ -251,8 +251,7 @@ il4965_rs_tl_rm_old_stats(struct il_traffic_load *tl, u32 curr_time)
 	/* The oldest age we want to keep */
 	u32 oldest_time = curr_time - TID_MAX_TIME_DIFF;
 
-	while (tl->queue_count &&
-	       (tl->time_stamp < oldest_time)) {
+	while (tl->queue_count && tl->time_stamp < oldest_time) {
 		tl->total -= tl->packet_count[tl->head];
 		tl->packet_count[tl->head] = 0;
 		tl->time_stamp += TID_QUEUE_CELL_SPACING;
@@ -477,8 +476,8 @@ static int il4965_rs_collect_tx_data(struct il_scale_tbl_info *tbl,
 	fail_count = window->counter - window->success_counter;
 
 	/* Calculate average throughput, if we have enough history. */
-	if ((fail_count >= IL_RATE_MIN_FAILURE_TH) ||
-	    (window->success_counter >= IL_RATE_MIN_SUCCESS_TH))
+	if (fail_count >= IL_RATE_MIN_FAILURE_TH ||
+	    window->success_counter >= IL_RATE_MIN_SUCCESS_TH)
 		window->average_tpt = (window->success_ratio * tpt + 64) / 128;
 	else
 		window->average_tpt = IL_INVALID_VALUE;
@@ -619,7 +618,7 @@ static int il4965_rs_toggle_antenna(u32 valid_ant, u32 *rate_n_flags,
 
 	new_ant_type = ant_toggle_lookup[tbl->ant_type];
 
-	while ((new_ant_type != tbl->ant_type) &&
+	while (new_ant_type != tbl->ant_type &&
 	       !il4965_rs_is_valid_ant(valid_ant, new_ant_type))
 		new_ant_type = ant_toggle_lookup[new_ant_type];
 
@@ -790,8 +789,8 @@ out:
 static bool il4965_table_type_matches(struct il_scale_tbl_info *a,
 			       struct il_scale_tbl_info *b)
 {
-	return (a->lq_type == b->lq_type) && (a->ant_type == b->ant_type) &&
-		(a->is_SGI == b->is_SGI);
+	return (a->lq_type == b->lq_type && a->ant_type == b->ant_type &&
+		a->is_SGI == b->is_SGI);
 }
 
 /*
@@ -830,7 +829,7 @@ il4965_rs_tx_status(void *il_r, struct ieee80211_supported_band *sband,
 	}
 
 	if (!ieee80211_is_data(hdr->frame_control) ||
-	    info->flags & IEEE80211_TX_CTL_NO_ACK)
+	    (info->flags & IEEE80211_TX_CTL_NO_ACK))
 		return;
 
 	/* This packet was aggregated but doesn't carry status info */
@@ -867,19 +866,14 @@ il4965_rs_tx_status(void *il_r, struct ieee80211_supported_band *sband,
 			mac_index += IL_FIRST_OFDM_RATE;
 	}
 	/* Here we actually compare this rate to the latest LQ command */
-	if ((mac_index < 0) ||
-	    (tbl_type.is_SGI !=
-			!!(mac_flags & IEEE80211_TX_RC_SHORT_GI)) ||
-	    (tbl_type.is_ht40 !=
-			!!(mac_flags & IEEE80211_TX_RC_40_MHZ_WIDTH)) ||
-	    (tbl_type.is_dup !=
-			!!(mac_flags & IEEE80211_TX_RC_DUP_DATA)) ||
-	    (tbl_type.ant_type != info->antenna_sel_tx) ||
-	    (!!(tx_rate & RATE_MCS_HT_MSK) !=
-			!!(mac_flags & IEEE80211_TX_RC_MCS)) ||
-	    (!!(tx_rate & RATE_MCS_GF_MSK) !=
-			!!(mac_flags & IEEE80211_TX_RC_GREEN_FIELD)) ||
-	    (rs_index != mac_index)) {
+	if (mac_index < 0 ||
+	    tbl_type.is_SGI != !!(mac_flags & IEEE80211_TX_RC_SHORT_GI) ||
+	    tbl_type.is_ht40 != !!(mac_flags & IEEE80211_TX_RC_40_MHZ_WIDTH) ||
+	    tbl_type.is_dup != !!(mac_flags & IEEE80211_TX_RC_DUP_DATA) ||
+	    tbl_type.ant_type != info->antenna_sel_tx ||
+	    !!(tx_rate & RATE_MCS_HT_MSK) != !!(mac_flags & IEEE80211_TX_RC_MCS) ||
+	    !!(tx_rate & RATE_MCS_GF_MSK) != !!(mac_flags & IEEE80211_TX_RC_GREEN_FIELD) ||
+	    rs_index != mac_index) {
 		D_RATE(
 		"initial rate %d does not match %d (0x%x)\n",
 			 mac_index, rs_index, tx_rate);
@@ -1119,12 +1113,12 @@ static s32 il4965_rs_get_best_rate(struct il_priv *il,
 		 *    conditions) at candidate rate is above expected
 		 *    "active" throughput (under perfect conditions).
 		 */
-		if ((((100 * tpt_tbl[rate]) > lq_sta->last_tpt) &&
-		     ((active_sr > IL_RATE_DECREASE_TH) &&
-		      (active_sr <= IL_RATE_HIGH_TH) &&
-		      (tpt_tbl[rate] <= active_tpt))) ||
-		    ((active_sr >= IL_RATE_SCALE_SWITCH) &&
-		     (tpt_tbl[rate] > active_tpt))) {
+		if ((100 * tpt_tbl[rate] > lq_sta->last_tpt &&
+		     (active_sr > IL_RATE_DECREASE_TH &&
+		      active_sr <= IL_RATE_HIGH_TH &&
+		      tpt_tbl[rate] <= active_tpt)) ||
+		    (active_sr >= IL_RATE_SCALE_SWITCH &&
+		     tpt_tbl[rate] > active_tpt)) {
 
 			/* (2nd or later pass)
 			 * If we've already tried to raise the rate, and are
@@ -1213,7 +1207,7 @@ static int il4965_rs_switch_to_mimo2(struct il_priv *il,
 
 	D_RATE("LQ: MIMO2 best rate %d mask %X\n",
 				rate, rate_mask);
-	if ((rate == IL_RATE_INVALID) || !((1 << rate) & rate_mask)) {
+	if (rate == IL_RATE_INVALID || !((1 << rate) & rate_mask)) {
 		D_RATE(
 				"Can't switch with index %d rate mask %x\n",
 						rate, rate_mask);
@@ -1265,7 +1259,7 @@ static int il4965_rs_switch_to_siso(struct il_priv *il,
 	rate = il4965_rs_get_best_rate(il, lq_sta, tbl, rate_mask, index);
 
 	D_RATE("LQ: get best rate %d mask %X\n", rate, rate_mask);
-	if ((rate == IL_RATE_INVALID) || !((1 << rate) & rate_mask)) {
+	if (rate == IL_RATE_INVALID || !((1 << rate) & rate_mask)) {
 		D_RATE(
 			"can not switch with index %d rate mask %x\n",
 			     rate, rate_mask);
@@ -1680,10 +1674,10 @@ il4965_rs_stay_in_table(struct il_lq_sta *lq_sta, bool force_search)
 		 * stats in active history.
 		 */
 		if (force_search ||
-		    (lq_sta->total_failed > lq_sta->max_failure_limit) ||
-		    (lq_sta->total_success > lq_sta->max_success_limit) ||
-		    ((!lq_sta->search_better_tbl) && (lq_sta->flush_timer)
-		     && (flush_interval_passed))) {
+		    lq_sta->total_failed > lq_sta->max_failure_limit ||
+		    lq_sta->total_success > lq_sta->max_success_limit ||
+		    (!lq_sta->search_better_tbl && lq_sta->flush_timer &&
+		     flush_interval_passed)) {
 			D_RATE("LQ: stay is expired %d %d %d\n:",
 				     lq_sta->total_failed,
 				     lq_sta->total_success,
@@ -1788,7 +1782,7 @@ static void il4965_rs_rate_scale_perform(struct il_priv *il,
 	/* Send management frames and NO_ACK data using lowest rate. */
 	/* TODO: this could probably be improved.. */
 	if (!ieee80211_is_data(hdr->frame_control) ||
-	    info->flags & IEEE80211_TX_CTL_NO_ACK)
+	    (info->flags & IEEE80211_TX_CTL_NO_ACK))
 		return;
 
 	if (!sta || !lq_sta)
@@ -1797,7 +1791,7 @@ static void il4965_rs_rate_scale_perform(struct il_priv *il,
 	lq_sta->supp_rates = sta->supp_rates[lq_sta->band];
 
 	tid = il4965_rs_tl_add_packet(lq_sta, hdr);
-	if ((tid != MAX_TID_COUNT) && (lq_sta->tx_agg_tid_en & (1 << tid))) {
+	if (tid != MAX_TID_COUNT && (lq_sta->tx_agg_tid_en & (1 << tid))) {
 		tid_data = &il->stations[lq_sta->lq.sta_id].tid[tid];
 		if (tid_data->agg.state == IL_AGG_OFF)
 			lq_sta->is_agg = 0;
@@ -1872,8 +1866,8 @@ static void il4965_rs_rate_scale_perform(struct il_priv *il,
 	}
 
 	/* force user max rate if set by user */
-	if ((lq_sta->max_rate_idx != -1) &&
-	    (lq_sta->max_rate_idx < index)) {
+	if (lq_sta->max_rate_idx != -1 &&
+	    lq_sta->max_rate_idx < index) {
 		index = lq_sta->max_rate_idx;
 		update_lq = 1;
 		window = &(tbl->win[index]);
@@ -1890,8 +1884,8 @@ static void il4965_rs_rate_scale_perform(struct il_priv *il,
 	 * in current association (use new rate found above).
 	 */
 	fail_count = window->counter - window->success_counter;
-	if ((fail_count < IL_RATE_MIN_FAILURE_TH) &&
-			(window->success_counter < IL_RATE_MIN_SUCCESS_TH)) {
+	if (fail_count < IL_RATE_MIN_FAILURE_TH &&
+	    window->success_counter < IL_RATE_MIN_SUCCESS_TH) {
 		D_RATE("LQ: still below TH. succ=%d total=%d "
 			       "for index %d\n",
 			       window->success_counter, window->counter, index);
@@ -1975,8 +1969,8 @@ static void il4965_rs_rate_scale_perform(struct il_priv *il,
 	high = (high_low >> 8) & 0xff;
 
 	/* If user set max rate, dont allow higher than user constrain */
-	if ((lq_sta->max_rate_idx != -1) &&
-	    (lq_sta->max_rate_idx < high))
+	if (lq_sta->max_rate_idx != -1 &&
+	    lq_sta->max_rate_idx < high)
 		high = IL_RATE_INVALID;
 
 	sr = window->success_ratio;
@@ -1991,14 +1985,14 @@ static void il4965_rs_rate_scale_perform(struct il_priv *il,
 	scale_action = 0;
 
 	/* Too many failures, decrease rate */
-	if ((sr <= IL_RATE_DECREASE_TH) || (current_tpt == 0)) {
+	if (sr <= IL_RATE_DECREASE_TH || current_tpt == 0) {
 		D_RATE(
 			"decrease rate because of low success_ratio\n");
 		scale_action = -1;
 
 	/* No throughput measured yet for adjacent rates; try increase. */
-	} else if ((low_tpt == IL_INVALID_VALUE) &&
-		   (high_tpt == IL_INVALID_VALUE)) {
+	} else if (low_tpt == IL_INVALID_VALUE &&
+		   high_tpt == IL_INVALID_VALUE) {
 
 		if (high != IL_RATE_INVALID && sr >= IL_RATE_INCREASE_TH)
 			scale_action = 1;
@@ -2008,10 +2002,8 @@ static void il4965_rs_rate_scale_perform(struct il_priv *il,
 
 	/* Both adjacent throughputs are measured, but neither one has better
 	 * throughput; we're using the best rate, don't change it! */
-	else if ((low_tpt != IL_INVALID_VALUE) &&
-		 (high_tpt != IL_INVALID_VALUE) &&
-		 (low_tpt < current_tpt) &&
-		 (high_tpt < current_tpt))
+	else if (low_tpt != IL_INVALID_VALUE && high_tpt != IL_INVALID_VALUE &&
+		 low_tpt < current_tpt && high_tpt < current_tpt)
 		scale_action = 0;
 
 	/* At least one adjacent rate's throughput is measured,
@@ -2021,7 +2013,7 @@ static void il4965_rs_rate_scale_perform(struct il_priv *il,
 		if (high_tpt != IL_INVALID_VALUE) {
 			/* Higher rate has better throughput */
 			if (high_tpt > current_tpt &&
-					sr >= IL_RATE_INCREASE_TH) {
+			    sr >= IL_RATE_INCREASE_TH) {
 				scale_action = 1;
 			} else {
 				scale_action = 0;
@@ -2042,9 +2034,8 @@ static void il4965_rs_rate_scale_perform(struct il_priv *il,
 
 	/* Sanity check; asked for decrease, but success rate or throughput
 	 * has been good at old rate.  Don't change it. */
-	if ((scale_action == -1) && (low != IL_RATE_INVALID) &&
-		    ((sr > IL_RATE_HIGH_TH) ||
-		     (current_tpt > (100 * tbl->expected_tpt[low]))))
+	if (scale_action == -1 && low != IL_RATE_INVALID &&
+	    (sr > IL_RATE_HIGH_TH || current_tpt > 100 * tbl->expected_tpt[low]))
 		scale_action = 0;
 
 	switch (scale_action) {
@@ -2090,8 +2081,8 @@ lq_update:
 	 * 2)  Not just finishing up a search
 	 * 3)  Allowing a new search
 	 */
-	if (!update_lq && !done_search &&
-		!lq_sta->stay_in_tbl && window->counter) {
+	if (!update_lq && !done_search && !lq_sta->stay_in_tbl &&
+	    window->counter) {
 		/* Save current throughput to compare with "search" throughput*/
 		lq_sta->last_tpt = current_tpt;
 
@@ -2146,10 +2137,10 @@ lq_update:
 		 * have been tried and compared, stay in this best modulation
 		 * mode for a while before next round of mode comparisons. */
 		if (lq_sta->enable_counter &&
-		    (lq_sta->action_counter >= tbl1->max_search)) {
-			if ((lq_sta->last_tpt > IL_AGG_TPT_THREHOLD) &&
+		    lq_sta->action_counter >= tbl1->max_search) {
+			if (lq_sta->last_tpt > IL_AGG_TPT_THREHOLD &&
 			    (lq_sta->tx_agg_tid_en & (1 << tid)) &&
-			    (tid != MAX_TID_COUNT)) {
+			    tid != MAX_TID_COUNT) {
 				tid_data =
 				   &il->stations[lq_sta->lq.sta_id].tid[tid];
 				if (tid_data->agg.state == IL_AGG_OFF) {
@@ -2217,7 +2208,7 @@ static void il4965_rs_initialize_lq(struct il_priv *il,
 
 	tbl = &(lq_sta->lq_info[active_tbl]);
 
-	if ((i < 0) || (i >= IL_RATE_COUNT))
+	if (i < 0 || i >= IL_RATE_COUNT)
 		i = 0;
 
 	rate = il_rates[i].plcp;
@@ -2256,11 +2247,11 @@ il4965_rs_get_rate(void *il_r, struct ieee80211_sta *sta, void *il_sta,
 	/* Get max rate if user set max rate */
 	if (lq_sta) {
 		lq_sta->max_rate_idx = txrc->max_rate_idx;
-		if ((sband->band == IEEE80211_BAND_5GHZ) &&
-		    (lq_sta->max_rate_idx != -1))
+		if (sband->band == IEEE80211_BAND_5GHZ &&
+		    lq_sta->max_rate_idx != -1)
 			lq_sta->max_rate_idx += IL_FIRST_OFDM_RATE;
-		if ((lq_sta->max_rate_idx < 0) ||
-		    (lq_sta->max_rate_idx >= IL_RATE_COUNT))
+		if (lq_sta->max_rate_idx < 0 ||
+		    lq_sta->max_rate_idx >= IL_RATE_COUNT)
 			lq_sta->max_rate_idx = -1;
 	}
 
@@ -2301,9 +2292,9 @@ il4965_rs_get_rate(void *il_r, struct ieee80211_sta *sta, void *il_sta,
 					IEEE80211_TX_RC_GREEN_FIELD;
 	} else {
 		/* Check for invalid rates */
-		if ((rate_idx < 0) || (rate_idx >= IL_RATE_COUNT_LEGACY) ||
-				((sband->band == IEEE80211_BAND_5GHZ) &&
-				 (rate_idx < IL_FIRST_OFDM_RATE)))
+		if (rate_idx < 0 || rate_idx >= IL_RATE_COUNT_LEGACY ||
+		    (sband->band == IEEE80211_BAND_5GHZ &&
+		     rate_idx < IL_FIRST_OFDM_RATE))
 			rate_idx = rate_lowest_index(sband, sta);
 		/* On valid 5 GHz rate, adjust index */
 		else if (sband->band == IEEE80211_BAND_5GHZ)
@@ -2475,7 +2466,7 @@ static void il4965_rs_fill_link_cmd(struct il_priv *il,
 		/* Repeat initial/next rate.
 		 * For legacy IL_NUMBER_TRY == 1, this loop will not execute.
 		 * For HT IL_HT_NUMBER_TRY == 3, this executes twice. */
-		while (repeat_rate > 0 && (index < LINK_QUAL_MAX_RETRY_NUM)) {
+		while (repeat_rate > 0 && index < LINK_QUAL_MAX_RETRY_NUM) {
 			if (is_legacy(tbl_type.lq_type)) {
 				if (ant_toggle_cnt < NUM_TRY_BEFORE_ANT_TOGGLE)
 					ant_toggle_cnt++;
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-tx.c b/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
index f86a3b9..a32a4f3 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
@@ -195,8 +195,8 @@ static void il4965_tx_cmd_build_rate(struct il_priv *il,
 	 * index is invalid.
 	 */
 	rate_idx = info->control.rates[0].idx;
-	if (info->control.rates[0].flags & IEEE80211_TX_RC_MCS ||
-			(rate_idx < 0) || (rate_idx > IL_RATE_COUNT_LEGACY))
+	if ((info->control.rates[0].flags & IEEE80211_TX_RC_MCS) ||
+	    rate_idx < 0 || rate_idx > IL_RATE_COUNT_LEGACY)
 		rate_idx = rate_lowest_index(&il->bands[info->band],
 				info->control.sta);
 	/* For 5 GHZ band, remap mac80211 rate indices into driver indices */
@@ -208,7 +208,7 @@ static void il4965_tx_cmd_build_rate(struct il_priv *il,
 	rate_flags = 0;
 
 	/* Set CCK flag as needed */
-	if ((rate_idx >= IL_FIRST_CCK_RATE) && (rate_idx <= IL_LAST_CCK_RATE))
+	if (rate_idx >= IL_FIRST_CCK_RATE && rate_idx <= IL_LAST_CCK_RATE)
 		rate_flags |= RATE_MCS_CCK_MSK;
 
 	/* Set up antennas */
@@ -535,8 +535,7 @@ int il4965_tx_skb(struct il_priv *il, struct sk_buff *skb)
 	if (sta_priv && sta_priv->client && !is_agg)
 		atomic_inc(&sta_priv->pending_frames);
 
-	if ((il_queue_space(q) < q->high_mark) &&
-			il->mac80211_registered) {
+	if (il_queue_space(q) < q->high_mark && il->mac80211_registered) {
 		if (wait_write_ptr) {
 			spin_lock_irqsave(&il->lock, flags);
 			txq->need_update = 1;
@@ -1050,8 +1049,8 @@ int il4965_txq_check_empty(struct il_priv *il,
 	case IL_EMPTYING_HW_QUEUE_DELBA:
 		/* We are reclaiming the last packet of the */
 		/* aggregated HW queue */
-		if ((txq_id  == tid_data->agg.txq_id) &&
-		    (q->read_ptr == q->write_ptr)) {
+		if (txq_id  == tid_data->agg.txq_id &&
+		    q->read_ptr == q->write_ptr) {
 			u16 ssn = SEQ_TO_SN(tid_data->seq_number);
 			int tx_fifo = il4965_get_fifo_from_tid(ctx, tid);
 			D_HT(
@@ -1114,7 +1113,7 @@ int il4965_tx_queue_reclaim(struct il_priv *il, int txq_id, int index)
 	int nfreed = 0;
 	struct ieee80211_hdr *hdr;
 
-	if ((index >= q->n_bd) || (il_queue_used(q, index) == 0)) {
+	if (index >= q->n_bd || il_queue_used(q, index) == 0) {
 		IL_ERR("Read index for DMA queue txq id (%d), index %d, "
 			  "is out of range [0-%d] %d %d.\n", txq_id,
 			  index, q->n_bd, q->write_ptr, q->read_ptr);
@@ -1321,9 +1320,9 @@ void il4965_rx_reply_compressed_ba(struct il_priv *il,
 		int freed = il4965_tx_queue_reclaim(il, scd_flow, index);
 		il4965_free_tfds_in_queue(il, sta_id, tid, freed);
 
-		if ((il_queue_space(&txq->q) > txq->q.low_mark) &&
+		if (il_queue_space(&txq->q) > txq->q.low_mark &&
 		    il->mac80211_registered &&
-		    (agg->state != IL_EMPTYING_HW_QUEUE_DELBA))
+		    agg->state != IL_EMPTYING_HW_QUEUE_DELBA)
 			il_wake_queue(il, txq);
 
 		il4965_txq_check_empty(il, sta_id, tid, scd_flow);
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965.c b/drivers/net/wireless/iwlegacy/iwl-4965.c
index a745032..3706e47 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965.c
@@ -284,8 +284,8 @@ static bool iw4965_is_ht40_channel(__le32 rxon_flags)
 {
 	int chan_mod = le32_to_cpu(rxon_flags & RXON_FLG_CHANNEL_MODE_MSK)
 				    >> RXON_FLG_CHANNEL_MODE_POS;
-	return ((chan_mod == CHANNEL_MODE_PURE_40) ||
-		  (chan_mod == CHANNEL_MODE_MIXED));
+	return (chan_mod == CHANNEL_MODE_PURE_40 ||
+		chan_mod == CHANNEL_MODE_MIXED);
 }
 
 static void il4965_nic_config(struct il_priv *il)
@@ -323,7 +323,7 @@ static void il4965_chain_noise_reset(struct il_priv *il)
 {
 	struct il_chain_noise_data *data = &(il->chain_noise_data);
 
-	if ((data->state == IL_CHAIN_NOISE_ALIVE) &&
+	if (data->state == IL_CHAIN_NOISE_ALIVE &&
 	    il_is_any_associated(il)) {
 		struct il_calib_diff_gain_cmd cmd;
 
@@ -458,8 +458,8 @@ static s32 il4965_get_voltage_compensation(s32 eeprom_voltage,
 {
 	s32 comp = 0;
 
-	if ((TX_POWER_IL_ILLEGAL_VOLTAGE == eeprom_voltage) ||
-	    (TX_POWER_IL_ILLEGAL_VOLTAGE == current_voltage))
+	if (TX_POWER_IL_ILLEGAL_VOLTAGE == eeprom_voltage ||
+	    TX_POWER_IL_ILLEGAL_VOLTAGE == current_voltage)
 		return 0;
 
 	il4965_math_div_round(current_voltage - eeprom_voltage,
@@ -506,8 +506,8 @@ static u32 il4965_get_sub_band(const struct il_priv *il, u32 channel)
 		if (il->calib_info->band_info[b].ch_from == 0)
 			continue;
 
-		if ((channel >= il->calib_info->band_info[b].ch_from)
-		    && (channel <= il->calib_info->band_info[b].ch_to))
+		if (channel >= il->calib_info->band_info[b].ch_from &&
+		    channel <= il->calib_info->band_info[b].ch_to)
 			break;
 	}
 
@@ -1158,15 +1158,15 @@ static int il4965_send_rxon_assoc(struct il_priv *il,
 	const struct il_rxon_cmd *rxon1 = &ctx->staging;
 	const struct il_rxon_cmd *rxon2 = &ctx->active;
 
-	if ((rxon1->flags == rxon2->flags) &&
-	    (rxon1->filter_flags == rxon2->filter_flags) &&
-	    (rxon1->cck_basic_rates == rxon2->cck_basic_rates) &&
-	    (rxon1->ofdm_ht_single_stream_basic_rates ==
-	     rxon2->ofdm_ht_single_stream_basic_rates) &&
-	    (rxon1->ofdm_ht_dual_stream_basic_rates ==
-	     rxon2->ofdm_ht_dual_stream_basic_rates) &&
-	    (rxon1->rx_chain == rxon2->rx_chain) &&
-	    (rxon1->ofdm_basic_rates == rxon2->ofdm_basic_rates)) {
+	if (rxon1->flags == rxon2->flags &&
+	    rxon1->filter_flags == rxon2->filter_flags &&
+	    rxon1->cck_basic_rates == rxon2->cck_basic_rates &&
+	    rxon1->ofdm_ht_single_stream_basic_rates ==
+		rxon2->ofdm_ht_single_stream_basic_rates &&
+	    rxon1->ofdm_ht_dual_stream_basic_rates ==
+		rxon2->ofdm_ht_dual_stream_basic_rates &&
+	    rxon1->rx_chain == rxon2->rx_chain &&
+	    rxon1->ofdm_basic_rates == rxon2->ofdm_basic_rates) {
 		D_INFO("Using current RXON_ASSOC.  Not resending.\n");
 		return 0;
 	}
@@ -1216,7 +1216,7 @@ static int il4965_commit_rxon(struct il_priv *il, struct il_rxon_context *ctx)
 	 * abort any previous channel switch if still in process
 	 */
 	if (test_bit(STATUS_CHANNEL_SWITCH_PENDING, &il->status) &&
-	    (il->switch_channel != ctx->staging.channel)) {
+	    il->switch_channel != ctx->staging.channel) {
 		D_11H("abort channel switch on %d\n",
 		      le16_to_cpu(il->switch_channel));
 		il_chswitch_done(il, false);
@@ -1366,7 +1366,7 @@ static int il4965_hw_channel_switch(struct il_priv *il,
 	 * calculate the ucode channel switch time
 	 * adding TSF as one of the factor for when to switch
 	 */
-	if ((il->ucode_beacon_time > tsf_low) && beacon_interval) {
+	if (il->ucode_beacon_time > tsf_low && beacon_interval) {
 		if (switch_count > ((il->ucode_beacon_time - tsf_low) /
 		    beacon_interval)) {
 			switch_count -= (il->ucode_beacon_time -
@@ -1789,7 +1789,7 @@ static void il4965_rx_reply_tx(struct il_priv *il,
 	u8 *qc = NULL;
 	unsigned long flags;
 
-	if ((index >= txq->q.n_bd) || (il_queue_used(&txq->q, index) == 0)) {
+	if (index >= txq->q.n_bd || il_queue_used(&txq->q, index) == 0) {
 		IL_ERR("Read index for DMA queue txq_id (%d) index %d "
 			  "is out of range [0-%d] %d %d\n", txq_id,
 			  index, txq->q.n_bd, txq->q.write_ptr,
@@ -1838,8 +1838,8 @@ static void il4965_rx_reply_tx(struct il_priv *il,
 						       tid, freed);
 
 			if (il->mac80211_registered &&
-			    (il_queue_space(&txq->q) > txq->q.low_mark)
-				 && (agg->state != IL_EMPTYING_HW_QUEUE_DELBA))
+			    il_queue_space(&txq->q) > txq->q.low_mark &&
+			    agg->state != IL_EMPTYING_HW_QUEUE_DELBA)
 				il_wake_queue(il, txq);
 		}
 	} else {
@@ -1863,7 +1863,7 @@ static void il4965_rx_reply_tx(struct il_priv *il,
 			D_TX_REPLY("Station not known\n");
 
 		if (il->mac80211_registered &&
-		    (il_queue_space(&txq->q) > txq->q.low_mark))
+		    il_queue_space(&txq->q) > txq->q.low_mark)
 			il_wake_queue(il, txq);
 	}
 	if (qc && likely(sta_id != IL_INVALID_STATION))
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965.h b/drivers/net/wireless/iwlegacy/iwl-4965.h
index ea2a98e..56bfdb0 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965.h
+++ b/drivers/net/wireless/iwlegacy/iwl-4965.h
@@ -163,8 +163,8 @@ static inline u32 il4965_tx_status_to_mac80211(u32 status)
 static inline bool il4965_is_tx_success(u32 status)
 {
 	status &= TX_STATUS_MSK;
-	return (status == TX_STATUS_SUCCESS) ||
-	       (status == TX_STATUS_DIRECT_DONE);
+	return (status == TX_STATUS_SUCCESS ||
+		status == TX_STATUS_DIRECT_DONE);
 }
 
 u8 il4965_toggle_tx_ant(struct il_priv *il, u8 ant_idx, u8 valid);
diff --git a/drivers/net/wireless/iwlegacy/iwl-core.c b/drivers/net/wireless/iwlegacy/iwl-core.c
index ed44159..acbd5a8 100644
--- a/drivers/net/wireless/iwlegacy/iwl-core.c
+++ b/drivers/net/wireless/iwlegacy/iwl-core.c
@@ -251,8 +251,8 @@ int il_init_geos(struct il_priv *il)
 	il->tx_power_user_lmt = max_tx_power;
 	il->tx_power_next = max_tx_power;
 
-	if ((il->bands[IEEE80211_BAND_5GHZ].n_channels == 0) &&
-	     il->cfg->sku & IL_SKU_A) {
+	if (il->bands[IEEE80211_BAND_5GHZ].n_channels == 0 &&
+	    (il->cfg->sku & IL_SKU_A)) {
 		IL_INFO("Incorrectly detected BG card as ABG. "
 			"Please send your PCI ID 0x%04X:0x%04X to maintainer.\n",
 			   il->pci_dev->device,
@@ -708,8 +708,7 @@ il_set_rxon_channel(struct il_priv *il, struct ieee80211_channel *ch,
 	enum ieee80211_band band = ch->band;
 	u16 channel = ch->hw_value;
 
-	if ((le16_to_cpu(ctx->staging.channel) == channel) &&
-	    (il->band == band))
+	if (le16_to_cpu(ctx->staging.channel) == channel && il->band == band)
 		return 0;
 
 	ctx->staging.channel = cpu_to_le16(channel);
@@ -2306,8 +2305,8 @@ static void il_ht_conf(struct il_priv *il,
 				>> IEEE80211_HT_MCS_TX_MAX_STREAMS_SHIFT;
 			maxstreams += 1;
 
-			if ((ht_cap->mcs.rx_mask[1] == 0) &&
-			    (ht_cap->mcs.rx_mask[2] == 0))
+			if (ht_cap->mcs.rx_mask[1] == 0 &&
+			    ht_cap->mcs.rx_mask[2] == 0)
 				ht_conf->single_chain_sufficient = true;
 			if (maxstreams <= 1)
 				ht_conf->single_chain_sufficient = true;
@@ -2467,7 +2466,7 @@ void il_mac_bss_info_changed(struct ieee80211_hw *hw,
 	 * mac80211 decides to do both changes at once because
 	 * it will invoke post_associate.
 	 */
-	if (vif->type == NL80211_IFTYPE_ADHOC && changes & BSS_CHANGED_BEACON)
+	if (vif->type == NL80211_IFTYPE_ADHOC && (changes & BSS_CHANGED_BEACON))
 		il_beacon_update(hw, vif);
 
 	if (changes & BSS_CHANGED_ERP_PREAMBLE) {
@@ -2482,8 +2481,7 @@ void il_mac_bss_info_changed(struct ieee80211_hw *hw,
 	if (changes & BSS_CHANGED_ERP_CTS_PROT) {
 		D_MAC80211(
 			"ERP_CTS %d\n", bss_conf->use_cts_prot);
-		if (bss_conf->use_cts_prot &&
-			(il->band != IEEE80211_BAND_5GHZ))
+		if (bss_conf->use_cts_prot && il->band != IEEE80211_BAND_5GHZ)
 			ctx->staging.flags |= RXON_FLG_TGG_PROTECT_MSK;
 		else
 			ctx->staging.flags &= ~RXON_FLG_TGG_PROTECT_MSK;
@@ -2596,7 +2594,7 @@ irqreturn_t il_isr(int irq, void *data)
 		goto none;
 	}
 
-	if ((inta == 0xFFFFFFFF) || ((inta & 0xFFFFFFF0) == 0xa5a5a5a0)) {
+	if (inta == 0xFFFFFFFF || (inta & 0xFFFFFFF0) == 0xa5a5a5a0) {
 		/* Hardware disappeared. It might have already raised
 		 * an interrupt */
 		IL_WARN("HARDWARE GONE?? INTA == 0x%08x\n", inta);
diff --git a/drivers/net/wireless/iwlegacy/iwl-io.h b/drivers/net/wireless/iwlegacy/iwl-io.h
index 8cb924d..9d33da8 100644
--- a/drivers/net/wireless/iwlegacy/iwl-io.h
+++ b/drivers/net/wireless/iwlegacy/iwl-io.h
@@ -176,7 +176,7 @@ static inline void il_write_reg_buf(struct il_priv *il,
 {
 	u32 count = sizeof(u32);
 
-	if ((il != NULL) && (values != NULL)) {
+	if (il != NULL && values != NULL) {
 		for (; 0 < len; len -= count, reg += count, values++)
 			il_wr(il, reg, *values);
 	}
diff --git a/drivers/net/wireless/iwlegacy/iwl-legacy-rs.h b/drivers/net/wireless/iwlegacy/iwl-legacy-rs.h
index 744829a..5da7d41 100644
--- a/drivers/net/wireless/iwlegacy/iwl-legacy-rs.h
+++ b/drivers/net/wireless/iwlegacy/iwl-legacy-rs.h
@@ -279,7 +279,7 @@ enum il_table_type {
 	LQ_MAX,
 };
 
-#define is_legacy(tbl) (((tbl) == LQ_G) || ((tbl) == LQ_A))
+#define is_legacy(tbl) ((tbl) == LQ_G || (tbl) == LQ_A)
 #define is_siso(tbl) ((tbl) == LQ_SISO)
 #define is_mimo2(tbl) ((tbl) == LQ_MIMO2)
 #define is_mimo(tbl) (is_mimo2(tbl))
diff --git a/drivers/net/wireless/iwlegacy/iwl-scan.c b/drivers/net/wireless/iwlegacy/iwl-scan.c
index 3687104..e352a18 100644
--- a/drivers/net/wireless/iwlegacy/iwl-scan.c
+++ b/drivers/net/wireless/iwlegacy/iwl-scan.c
@@ -307,7 +307,7 @@ u16 il_get_passive_dwell_time(struct il_priv *il,
 			if (!il_is_associated_ctx(ctx))
 				continue;
 			value = ctx->vif ? ctx->vif->bss_conf.beacon_int : 0;
-			if ((value > IL_PASSIVE_DWELL_BASE) || !value)
+			if (value > IL_PASSIVE_DWELL_BASE || !value)
 				value = IL_PASSIVE_DWELL_BASE;
 			value = (value * 98) / 100 - IL_CHANNEL_TUNE_TIME * 2;
 			passive = min(value, passive);
diff --git a/drivers/net/wireless/iwlegacy/iwl-sta.c b/drivers/net/wireless/iwlegacy/iwl-sta.c
index 42033d2..cca467c 100644
--- a/drivers/net/wireless/iwlegacy/iwl-sta.c
+++ b/drivers/net/wireless/iwlegacy/iwl-sta.c
@@ -595,7 +595,7 @@ il_restore_stations(struct il_priv *il, struct il_rxon_context *ctx)
 		if (ctx->ctxid != il->stations[i].ctxid)
 			continue;
 		if ((il->stations[i].used & IL_STA_DRIVER_ACTIVE) &&
-			    !(il->stations[i].used & IL_STA_UCODE_ACTIVE)) {
+		    !(il->stations[i].used & IL_STA_UCODE_ACTIVE)) {
 			D_ASSOC("Restoring sta %pM\n",
 					il->stations[i].sta.sta.addr);
 			il->stations[i].sta.mode = 0;
diff --git a/drivers/net/wireless/iwlegacy/iwl-tx.c b/drivers/net/wireless/iwlegacy/iwl-tx.c
index fa23c98..0d3515d 100644
--- a/drivers/net/wireless/iwlegacy/iwl-tx.c
+++ b/drivers/net/wireless/iwlegacy/iwl-tx.c
@@ -565,7 +565,7 @@ static void il_hcmd_queue_reclaim(struct il_priv *il, int txq_id,
 	struct il_queue *q = &txq->q;
 	int nfreed = 0;
 
-	if ((idx >= q->n_bd) || (il_queue_used(q, idx) == 0)) {
+	if (idx >= q->n_bd || il_queue_used(q, idx) == 0) {
 		IL_ERR("Read index for DMA queue txq id (%d), index %d, "
 			  "is out of range [0-%d] %d %d.\n", txq_id,
 			  idx, q->n_bd, q->write_ptr, q->read_ptr);
diff --git a/drivers/net/wireless/iwlegacy/iwl3945-base.c b/drivers/net/wireless/iwlegacy/iwl3945-base.c
index 5037216..ec9a93c 100644
--- a/drivers/net/wireless/iwlegacy/iwl3945-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl3945-base.c
@@ -646,7 +646,7 @@ static int il3945_tx_skb(struct il_priv *il, struct sk_buff *skb)
 	il_txq_update_write_ptr(il, txq);
 	spin_unlock_irqrestore(&il->lock, flags);
 
-	if ((il_queue_space(q) < q->high_mark)
+	if (il_queue_space(q) < q->high_mark
 	    && il->mac80211_registered) {
 		if (wait_write_ptr) {
 			spin_lock_irqsave(&il->lock, flags);
@@ -974,7 +974,7 @@ static void il3945_rx_queue_restock(struct il_priv *il)
 
 	spin_lock_irqsave(&rxq->lock, flags);
 	write = rxq->write & ~0x7;
-	while ((il_rx_queue_space(rxq) > 0) && (rxq->free_count)) {
+	while (il_rx_queue_space(rxq) > 0 && rxq->free_count) {
 		/* Get next free Rx buffer, remove from free list */
 		element = rxq->rx_free.next;
 		rxb = list_entry(element, struct il_rx_mem_buffer, list);
@@ -995,8 +995,8 @@ static void il3945_rx_queue_restock(struct il_priv *il)
 
 	/* If we've added more space for the firmware to place data, tell it.
 	 * Increment device's write pointer in multiples of 8. */
-	if ((rxq->write_actual != (rxq->write & ~0x7))
-	    || (abs(rxq->write - rxq->read) > 7)) {
+	if (rxq->write_actual != (rxq->write & ~0x7) ||
+	    abs(rxq->write - rxq->read) > 7) {
 		spin_lock_irqsave(&rxq->lock, flags);
 		rxq->need_update = 1;
 		spin_unlock_irqrestore(&rxq->lock, flags);
@@ -1041,7 +1041,7 @@ static void il3945_rx_allocate(struct il_priv *il, gfp_t priority)
 		if (!page) {
 			if (net_ratelimit())
 				D_INFO("Failed to allocate SKB buffer.\n");
-			if ((rxq->free_count <= RX_LOW_WATERMARK) &&
+			if (rxq->free_count <= RX_LOW_WATERMARK &&
 			    net_ratelimit())
 				IL_ERR("Failed to allocate SKB buffer with %s. Only %u free buffers remaining.\n",
 					 priority == GFP_ATOMIC ?  "GFP_ATOMIC" : "GFP_KERNEL",
@@ -1254,8 +1254,8 @@ static void il3945_rx_handle(struct il_priv *il)
 		 * Ucode should set SEQ_RX_FRAME bit if ucode-originated,
 		 *   but apparently a few don't get set; catch them here. */
 		reclaim = !(pkt->hdr.sequence & SEQ_RX_FRAME) &&
-			(pkt->hdr.cmd != STATISTICS_NOTIFICATION) &&
-			(pkt->hdr.cmd != REPLY_TX);
+			pkt->hdr.cmd != STATISTICS_NOTIFICATION &&
+			pkt->hdr.cmd != REPLY_TX;
 
 		/* Based on type of command response or notification,
 		 *   handle those that need handling via function in
@@ -1659,7 +1659,7 @@ static void il3945_init_hw_rates(struct il_priv *il,
 		rates[i].hw_value = i; /* Rate scaling will work on indexes */
 		rates[i].hw_value_short = i;
 		rates[i].flags = 0;
-		if ((i > IWL39_LAST_OFDM_RATE) || (i < IL_FIRST_OFDM_RATE)) {
+		if (i > IWL39_LAST_OFDM_RATE || i < IL_FIRST_OFDM_RATE) {
 			/*
 			 * If CCK != 1M then set short preamble rate flag.
 			 */
@@ -3294,7 +3294,7 @@ static ssize_t il3945_show_measurement(struct device *d,
 	il->measurement_status = 0;
 	spin_unlock_irqrestore(&il->lock, flags);
 
-	while (size && (PAGE_SIZE - len)) {
+	while (size && PAGE_SIZE - len) {
 		hex_dump_to_buffer(data + ofs, size, 16, 1, buf + len,
 				   PAGE_SIZE - len, 1);
 		len = strlen(buf);
@@ -3406,7 +3406,7 @@ static ssize_t il3945_store_antenna(struct device *d,
 		return count;
 	}
 
-	if ((ant >= 0) && (ant <= 2)) {
+	if (ant >= 0 && ant <= 2) {
 		D_INFO("Setting antenna select to %d.\n", ant);
 		il3945_mod_params.antenna = (enum il3945_antenna)ant;
 	} else
-- 
1.7.1

