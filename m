Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34686 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754857Ab1KRIVE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:21:04 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAI8L4Y8022528
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 03:21:04 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 07/77] iwlegacy: rename IL_DEBUG_ to D_
Date: Fri, 18 Nov 2011 09:21:29 +0100
Message-Id: <1321604559-10707-7-git-send-email-sgruszka@redhat.com> (sfid-20111118_092112_099486_4B4AD3CA)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/iwl-3945-rs.c    |   64 ++++----
 drivers/net/wireless/iwlegacy/iwl-3945.c       |  102 ++++++------
 drivers/net/wireless/iwlegacy/iwl-4965-calib.c |   80 +++++-----
 drivers/net/wireless/iwlegacy/iwl-4965-lib.c   |   38 ++--
 drivers/net/wireless/iwlegacy/iwl-4965-rs.c    |  106 ++++++------
 drivers/net/wireless/iwlegacy/iwl-4965-rx.c    |    8 +-
 drivers/net/wireless/iwlegacy/iwl-4965-sta.c   |   18 +-
 drivers/net/wireless/iwlegacy/iwl-4965-tx.c    |   52 +++---
 drivers/net/wireless/iwlegacy/iwl-4965-ucode.c |   12 +-
 drivers/net/wireless/iwlegacy/iwl-4965.c       |  114 ++++++------
 drivers/net/wireless/iwlegacy/iwl-core.c       |  136 +++++++-------
 drivers/net/wireless/iwlegacy/iwl-debug.h      |   76 ++++----
 drivers/net/wireless/iwlegacy/iwl-eeprom.c     |   18 +-
 drivers/net/wireless/iwlegacy/iwl-hcmd.c       |   10 +-
 drivers/net/wireless/iwlegacy/iwl-helpers.h    |    6 +-
 drivers/net/wireless/iwlegacy/iwl-led.c        |    2 +-
 drivers/net/wireless/iwlegacy/iwl-power.c      |   16 +-
 drivers/net/wireless/iwlegacy/iwl-rx.c         |   10 +-
 drivers/net/wireless/iwlegacy/iwl-scan.c       |   52 +++---
 drivers/net/wireless/iwlegacy/iwl-sta.c        |   72 ++++----
 drivers/net/wireless/iwlegacy/iwl-tx.c         |    8 +-
 drivers/net/wireless/iwlegacy/iwl3945-base.c   |  222 ++++++++++++------------
 drivers/net/wireless/iwlegacy/iwl4965-base.c   |  148 ++++++++--------
 23 files changed, 685 insertions(+), 685 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-3945-rs.c b/drivers/net/wireless/iwlegacy/iwl-3945-rs.c
index 38f1b82..d05da7a 100644
--- a/drivers/net/wireless/iwlegacy/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlegacy/iwl-3945-rs.c
@@ -167,7 +167,7 @@ static int il3945_rate_scale_flush_windows(struct il3945_rs_sta *rs_sta)
 		spin_lock_irqsave(&rs_sta->lock, flags);
 		if (time_after(jiffies, rs_sta->win[i].stamp +
 			       IL_RATE_WIN_FLUSH)) {
-			IL_DEBUG_RATE(il, "flushing %d samples of rate "
+			D_RATE("flushing %d samples of rate "
 				       "index %d\n",
 				       rs_sta->win[i].counter, i);
 			il3945_clear_window(&rs_sta->win[i]);
@@ -191,7 +191,7 @@ static void il3945_bg_rate_scale_flush(unsigned long data)
 	unsigned long flags;
 	u32 packet_count, duration, pps;
 
-	IL_DEBUG_RATE(il, "enter\n");
+	D_RATE("enter\n");
 
 	unflushed = il3945_rate_scale_flush_windows(rs_sta);
 
@@ -206,7 +206,7 @@ static void il3945_bg_rate_scale_flush(unsigned long data)
 		duration =
 		    jiffies_to_msecs(jiffies - rs_sta->last_partial_flush);
 
-		IL_DEBUG_RATE(il, "Tx'd %d packets in %dms\n",
+		D_RATE("Tx'd %d packets in %dms\n",
 			       packet_count, duration);
 
 		/* Determine packets per second */
@@ -226,7 +226,7 @@ static void il3945_bg_rate_scale_flush(unsigned long data)
 
 		rs_sta->flush_time = msecs_to_jiffies(duration);
 
-		IL_DEBUG_RATE(il, "new flush period: %d msec ave %d\n",
+		D_RATE("new flush period: %d msec ave %d\n",
 			       duration, packet_count);
 
 		mod_timer(&rs_sta->rate_scale_flush, jiffies +
@@ -244,7 +244,7 @@ static void il3945_bg_rate_scale_flush(unsigned long data)
 
 	spin_unlock_irqrestore(&rs_sta->lock, flags);
 
-	IL_DEBUG_RATE(il, "leave\n");
+	D_RATE("leave\n");
 }
 
 /**
@@ -263,7 +263,7 @@ static void il3945_collect_tx_data(struct il3945_rs_sta *rs_sta,
 	struct il_priv *il __maybe_unused = rs_sta->il;
 
 	if (!retries) {
-		IL_DEBUG_RATE(il, "leave: retries == 0 -- should be at least 1\n");
+		D_RATE("leave: retries == 0 -- should be at least 1\n");
 		return;
 	}
 
@@ -341,7 +341,7 @@ void il3945_rs_rate_init(struct il_priv *il, struct ieee80211_sta *sta, u8 sta_i
 	struct ieee80211_supported_band *sband;
 	int i;
 
-	IL_DEBUG_INFO(il, "enter\n");
+	D_INFO("enter\n");
 	if (sta_id == il->contexts[IL_RXON_CTX_BSS].bcast_sta_id)
 		goto out;
 
@@ -390,7 +390,7 @@ void il3945_rs_rate_init(struct il_priv *il, struct ieee80211_sta *sta, u8 sta_i
 out:
 	il->stations[sta_id].used &= ~IL_STA_UCODE_INPROGRESS;
 
-	IL_DEBUG_INFO(il, "leave\n");
+	D_INFO("leave\n");
 }
 
 static void *il3945_rs_alloc(struct ieee80211_hw *hw, struct dentry *debugfsdir)
@@ -410,14 +410,14 @@ static void *il3945_rs_alloc_sta(void *il_priv, struct ieee80211_sta *sta, gfp_t
 	struct il3945_sta_priv *psta = (void *) sta->drv_priv;
 	struct il_priv *il __maybe_unused = il_priv;
 
-	IL_DEBUG_RATE(il, "enter\n");
+	D_RATE("enter\n");
 
 	rs_sta = &psta->rs_sta;
 
 	spin_lock_init(&rs_sta->lock);
 	init_timer(&rs_sta->rate_scale_flush);
 
-	IL_DEBUG_RATE(il, "leave\n");
+	D_RATE("leave\n");
 
 	return rs_sta;
 }
@@ -453,7 +453,7 @@ static void il3945_rs_tx_status(void *il_rate, struct ieee80211_supported_band *
 	struct il3945_rs_sta *rs_sta = il_sta;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 
-	IL_DEBUG_RATE(il, "enter\n");
+	D_RATE("enter\n");
 
 	retries = info->status.rates[0].count;
 	/* Sanity Check for retries */
@@ -462,18 +462,18 @@ static void il3945_rs_tx_status(void *il_rate, struct ieee80211_supported_band *
 
 	first_index = sband->bitrates[info->status.rates[0].idx].hw_value;
 	if ((first_index < 0) || (first_index >= IL_RATE_COUNT_3945)) {
-		IL_DEBUG_RATE(il, "leave: Rate out of bounds: %d\n", first_index);
+		D_RATE("leave: Rate out of bounds: %d\n", first_index);
 		return;
 	}
 
 	if (!il_sta) {
-		IL_DEBUG_RATE(il, "leave: No STA il data to update!\n");
+		D_RATE("leave: No STA il data to update!\n");
 		return;
 	}
 
 	/* Treat uninitialized rate scaling data same as non-existing. */
 	if (!rs_sta->il) {
-		IL_DEBUG_RATE(il, "leave: STA il data uninitialized!\n");
+		D_RATE("leave: STA il data uninitialized!\n");
 		return;
 	}
 
@@ -508,7 +508,7 @@ static void il3945_rs_tx_status(void *il_rate, struct ieee80211_supported_band *
 		il3945_collect_tx_data(rs_sta,
 				    &rs_sta->win[scale_rate_index],
 				    0, current_count, scale_rate_index);
-		IL_DEBUG_RATE(il, "Update rate %d for %d retries.\n",
+		D_RATE("Update rate %d for %d retries.\n",
 			       scale_rate_index, current_count);
 
 		retries -= current_count;
@@ -518,7 +518,7 @@ static void il3945_rs_tx_status(void *il_rate, struct ieee80211_supported_band *
 
 
 	/* Update the last index window with success/failure based on ACK */
-	IL_DEBUG_RATE(il, "Update rate %d with %s.\n",
+	D_RATE("Update rate %d with %s.\n",
 		       last_index,
 		       (info->flags & IEEE80211_TX_STAT_ACK) ?
 		       "success" : "failure");
@@ -543,7 +543,7 @@ static void il3945_rs_tx_status(void *il_rate, struct ieee80211_supported_band *
 
 	spin_unlock_irqrestore(&rs_sta->lock, flags);
 
-	IL_DEBUG_RATE(il, "leave\n");
+	D_RATE("leave\n");
 }
 
 static u16 il3945_get_adjacent_rate(struct il3945_rs_sta *rs_sta,
@@ -591,7 +591,7 @@ static u16 il3945_get_adjacent_rate(struct il3945_rs_sta *rs_sta,
 			break;
 		if (rate_mask & (1 << low))
 			break;
-		IL_DEBUG_RATE(il, "Skipping masked lower rate: %d\n", low);
+		D_RATE("Skipping masked lower rate: %d\n", low);
 	}
 
 	high = index;
@@ -604,7 +604,7 @@ static u16 il3945_get_adjacent_rate(struct il3945_rs_sta *rs_sta,
 			break;
 		if (rate_mask & (1 << high))
 			break;
-		IL_DEBUG_RATE(il, "Skipping masked higher rate: %d\n", high);
+		D_RATE("Skipping masked higher rate: %d\n", high);
 	}
 
 	return (high << 8) | low;
@@ -648,11 +648,11 @@ static void il3945_rs_get_rate(void *il_r, struct ieee80211_sta *sta,
 	struct il_priv *il __maybe_unused = (struct il_priv *)il_r;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 
-	IL_DEBUG_RATE(il, "enter\n");
+	D_RATE("enter\n");
 
 	/* Treat uninitialized rate scaling data same as non-existing. */
 	if (rs_sta && !rs_sta->il) {
-		IL_DEBUG_RATE(il, "Rate scaling information not initialized yet.\n");
+		D_RATE("Rate scaling information not initialized yet.\n");
 		il_sta = NULL;
 	}
 
@@ -699,7 +699,7 @@ static void il3945_rs_get_rate(void *il_r, struct ieee80211_sta *sta,
 	     (window->success_counter < IL_RATE_MIN_SUCCESS_TH))) {
 		spin_unlock_irqrestore(&rs_sta->lock, flags);
 
-		IL_DEBUG_RATE(il, "Invalid average_tpt on rate %d: "
+		D_RATE("Invalid average_tpt on rate %d: "
 			       "counter: %d, success_counter: %d, "
 			       "expected_tpt is %sNULL\n",
 			       index,
@@ -737,7 +737,7 @@ static void il3945_rs_get_rate(void *il_r, struct ieee80211_sta *sta,
 
 	/* Low success ratio , need to drop the rate */
 	if ((window->success_ratio < IL_RATE_DECREASE_TH) || !current_tpt) {
-		IL_DEBUG_RATE(il, "decrease rate because of low success_ratio\n");
+		D_RATE("decrease rate because of low success_ratio\n");
 		scale_action = -1;
 	/* No throughput measured yet for adjacent rates,
 	 * try increase */
@@ -756,7 +756,7 @@ static void il3945_rs_get_rate(void *il_r, struct ieee80211_sta *sta,
 		 (high_tpt != IL_INVALID_VALUE) &&
 		 (low_tpt < current_tpt) && (high_tpt < current_tpt)) {
 
-		IL_DEBUG_RATE(il, "No action -- low [%d] & high [%d] < "
+		D_RATE("No action -- low [%d] & high [%d] < "
 			       "current_tpt [%d]\n",
 			       low_tpt, high_tpt, current_tpt);
 		scale_action = 0;
@@ -771,13 +771,13 @@ static void il3945_rs_get_rate(void *il_r, struct ieee80211_sta *sta,
 				window->success_ratio >= IL_RATE_INCREASE_TH)
 				scale_action = 1;
 			else {
-				IL_DEBUG_RATE(il,
+				D_RATE(
 				    "decrease rate because of high tpt\n");
 				scale_action = 0;
 			}
 		} else if (low_tpt != IL_INVALID_VALUE) {
 			if (low_tpt > current_tpt) {
-				IL_DEBUG_RATE(il,
+				D_RATE(
 				    "decrease rate because of low tpt\n");
 				scale_action = -1;
 			} else if (window->success_ratio >= IL_RATE_INCREASE_TH) {
@@ -816,7 +816,7 @@ static void il3945_rs_get_rate(void *il_r, struct ieee80211_sta *sta,
 		break;
 	}
 
-	IL_DEBUG_RATE(il, "Selected %d (action %d) - low %d high %d\n",
+	D_RATE("Selected %d (action %d) - low %d high %d\n",
 		       index, scale_action, low, high);
 
  out:
@@ -831,7 +831,7 @@ static void il3945_rs_get_rate(void *il_r, struct ieee80211_sta *sta,
 		info->control.rates[0].idx = rs_sta->last_txrate_idx;
 	}
 
-	IL_DEBUG_RATE(il, "leave: %d\n", index);
+	D_RATE("leave: %d\n", index);
 }
 
 #ifdef CONFIG_MAC80211_DEBUGFS
@@ -932,14 +932,14 @@ void il3945_rate_scale_init(struct ieee80211_hw *hw, s32 sta_id)
 	struct ieee80211_sta *sta;
 	struct il3945_sta_priv *psta;
 
-	IL_DEBUG_RATE(il, "enter\n");
+	D_RATE("enter\n");
 
 	rcu_read_lock();
 
 	sta = ieee80211_find_sta(il->contexts[IL_RXON_CTX_BSS].vif,
 				 il->stations[sta_id].sta.sta.addr);
 	if (!sta) {
-		IL_DEBUG_RATE(il, "Unable to find station to initialize rate scaling.\n");
+		D_RATE("Unable to find station to initialize rate scaling.\n");
 		rcu_read_unlock();
 		return;
 	}
@@ -975,11 +975,11 @@ void il3945_rate_scale_init(struct ieee80211_hw *hw, s32 sta_id)
 	if (rssi == 0)
 		rssi = IL_MIN_RSSI_VAL;
 
-	IL_DEBUG_RATE(il, "Network RSSI: %d\n", rssi);
+	D_RATE("Network RSSI: %d\n", rssi);
 
 	rs_sta->start_rate = il3945_get_rate_index_by_rssi(rssi, il->band);
 
-	IL_DEBUG_RATE(il, "leave: rssi %d assign rate index: "
+	D_RATE("leave: rssi %d assign rate index: "
 		       "%d (plcp 0x%x)\n", rssi, rs_sta->start_rate,
 		       il3945_rates[rs_sta->start_rate].plcp);
 	rcu_read_unlock();
diff --git a/drivers/net/wireless/iwlegacy/iwl-3945.c b/drivers/net/wireless/iwlegacy/iwl-3945.c
index 628adf5..a1e2a42 100644
--- a/drivers/net/wireless/iwlegacy/iwl-3945.c
+++ b/drivers/net/wireless/iwlegacy/iwl-3945.c
@@ -174,7 +174,7 @@ void il3945_disable_events(struct il_priv *il)
 	array_size = il_read_targ_mem(il, base + (5 * sizeof(u32)));
 
 	if (IL_EVT_DISABLE && (array_size == IL_EVT_DISABLE_SIZE)) {
-		IL_DEBUG_INFO(il, "Disabling selected uCode log events at 0x%x\n",
+		D_INFO("Disabling selected uCode log events at 0x%x\n",
 			       disable_ptr);
 		for (i = 0; i < IL_EVT_DISABLE_SIZE; i++)
 			il_write_targ_mem(il,
@@ -182,9 +182,9 @@ void il3945_disable_events(struct il_priv *il)
 					   evt_disable[i]);
 
 	} else {
-		IL_DEBUG_INFO(il, "Selected uCode log events may be disabled\n");
-		IL_DEBUG_INFO(il, "  by writing \"1\"s into disable bitmap\n");
-		IL_DEBUG_INFO(il, "  in SRAM at 0x%x, size %d u32s\n",
+		D_INFO("Selected uCode log events may be disabled\n");
+		D_INFO("  by writing \"1\"s into disable bitmap\n");
+		D_INFO("  in SRAM at 0x%x, size %d u32s\n",
 			       disable_ptr, array_size);
 	}
 
@@ -342,11 +342,11 @@ static void il3945_rx_reply_tx(struct il_priv *il,
 	info->flags |= ((status & TX_STATUS_MSK) == TX_STATUS_SUCCESS) ?
 				IEEE80211_TX_STAT_ACK : 0;
 
-	IL_DEBUG_TX(il, "Tx queue %d Status %s (0x%08x) plcp rate %d retries %d\n",
+	D_TX("Tx queue %d Status %s (0x%08x) plcp rate %d retries %d\n",
 			txq_id, il3945_get_tx_fail_reason(status), status,
 			tx_resp->rate, tx_resp->failure_frame);
 
-	IL_DEBUG_TX_REPLY(il, "Tx queue reclaim %d\n", index);
+	D_TX_REPLY("Tx queue reclaim %d\n", index);
 	il3945_tx_queue_reclaim(il, txq_id, index);
 
 	if (status & TX_ABORT_REQUIRED_MSK)
@@ -401,7 +401,7 @@ void il3945_hw_rx_statistics(struct il_priv *il,
 {
 	struct il_rx_packet *pkt = rxb_addr(rxb);
 
-	IL_DEBUG_RX(il, "Statistics notification received (%d vs %d).\n",
+	D_RX("Statistics notification received (%d vs %d).\n",
 		     (int)sizeof(struct il3945_notif_statistics),
 		     le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK);
 #ifdef CONFIG_IWLWIFI_LEGACY_DEBUGFS
@@ -426,7 +426,7 @@ void il3945_reply_statistics(struct il_priv *il,
 		memset(&il->_3945.max_delta, 0,
 			sizeof(struct il3945_notif_statistics));
 #endif
-		IL_DEBUG_RX(il, "Statistics have been cleared\n");
+		D_RX("Statistics have been cleared\n");
 	}
 	il3945_hw_rx_statistics(il, rxb);
 }
@@ -471,13 +471,13 @@ static void il3945_pass_packet_to_mac80211(struct il_priv *il,
 	/* We received data from the HW, so stop the watchdog */
 	if (unlikely(len + IWL39_RX_FRAME_SIZE >
 		     PAGE_SIZE << il->hw_params.rx_page_order)) {
-		IL_DEBUG_DROP(il, "Corruption detected!\n");
+		D_DROP("Corruption detected!\n");
 		return;
 	}
 
 	/* We only process data packets if the interface is open */
 	if (unlikely(!il->is_open)) {
-		IL_DEBUG_DROP(il,
+		D_DROP(
 			"Dropping packet while interface is not open.\n");
 		return;
 	}
@@ -539,14 +539,14 @@ static void il3945_rx_reply_rx(struct il_priv *il,
 		rx_status.flag |= RX_FLAG_SHORTPRE;
 
 	if ((unlikely(rx_stats->phy_count > 20))) {
-		IL_DEBUG_DROP(il, "dsp size out of range [0,20]: %d/n",
+		D_DROP("dsp size out of range [0,20]: %d/n",
 				rx_stats->phy_count);
 		return;
 	}
 
 	if (!(rx_end->status & RX_RES_STATUS_NO_CRC32_ERROR)
 	    || !(rx_end->status & RX_RES_STATUS_NO_RXE_OVERFLOW)) {
-		IL_DEBUG_RX(il, "Bad CRC or FIFO: 0x%08X.\n", rx_end->status);
+		D_RX("Bad CRC or FIFO: 0x%08X.\n", rx_end->status);
 		return;
 	}
 
@@ -555,7 +555,7 @@ static void il3945_rx_reply_rx(struct il_priv *il,
 	/* Convert 3945's rssi indicator to dBm */
 	rx_status.signal = rx_stats->rssi - IWL39_RSSI_OFFSET;
 
-	IL_DEBUG_STATS(il, "Rssi %d sig_avg %d noise_diff %d\n",
+	D_STATS("Rssi %d sig_avg %d noise_diff %d\n",
 			rx_status.signal, rx_stats_sig_avg,
 			rx_stats_noise_diff);
 
@@ -563,7 +563,7 @@ static void il3945_rx_reply_rx(struct il_priv *il,
 
 	network_packet = il3945_is_network_packet(il, header);
 
-	IL_DEBUG_STATS(il, "[%c] %d RSSI:%d Signal:%u, Rate:%u\n",
+	D_STATS("[%c] %d RSSI:%d Signal:%u, Rate:%u\n",
 			      network_packet ? '*' : ' ',
 			      le16_to_cpu(rx_hdr->channel),
 			      rx_status.signal, rx_status.signal,
@@ -718,7 +718,7 @@ void il3945_hw_build_tx_cmd_rate(struct il_priv *il,
 	/* CCK */
 	tx_cmd->supp_rates[1] = (rate_mask & 0xF);
 
-	IL_DEBUG_RATE(il, "Tx sta id: %d, rate: %d (plcp), flags: 0x%4X "
+	D_RATE("Tx sta id: %d, rate: %d (plcp), flags: 0x%4X "
 		       "cck/ofdm mask: 0x%x/0x%x\n", sta_id,
 		       tx_cmd->rate, le32_to_cpu(tx_cmd->tx_flags),
 		       tx_cmd->supp_rates[1], tx_cmd->supp_rates[0]);
@@ -741,7 +741,7 @@ static u8 il3945_sync_sta(struct il_priv *il, int sta_id, u16 tx_rate)
 	il_send_add_sta(il, &station->sta, CMD_ASYNC);
 	spin_unlock_irqrestore(&il->sta_lock, flags_spin);
 
-	IL_DEBUG_RATE(il, "SCALE sync station %d to rate %d\n",
+	D_RATE("SCALE sync station %d to rate %d\n",
 			sta_id, tx_rate);
 	return sta_id;
 }
@@ -900,34 +900,34 @@ static void il3945_nic_config(struct il_priv *il)
 	spin_lock_irqsave(&il->lock, flags);
 
 	/* Determine HW type */
-	IL_DEBUG_INFO(il, "HW Revision ID = 0x%X\n", rev_id);
+	D_INFO("HW Revision ID = 0x%X\n", rev_id);
 
 	if (rev_id & PCI_CFG_REV_ID_BIT_RTP)
-		IL_DEBUG_INFO(il, "RTP type\n");
+		D_INFO("RTP type\n");
 	else if (rev_id & PCI_CFG_REV_ID_BIT_BASIC_SKU) {
-		IL_DEBUG_INFO(il, "3945 RADIO-MB type\n");
+		D_INFO("3945 RADIO-MB type\n");
 		il_set_bit(il, CSR_HW_IF_CONFIG_REG,
 			    CSR39_HW_IF_CONFIG_REG_BIT_3945_MB);
 	} else {
-		IL_DEBUG_INFO(il, "3945 RADIO-MM type\n");
+		D_INFO("3945 RADIO-MM type\n");
 		il_set_bit(il, CSR_HW_IF_CONFIG_REG,
 			    CSR39_HW_IF_CONFIG_REG_BIT_3945_MM);
 	}
 
 	if (EEPROM_SKU_CAP_OP_MODE_MRC == eeprom->sku_cap) {
-		IL_DEBUG_INFO(il, "SKU OP mode is mrc\n");
+		D_INFO("SKU OP mode is mrc\n");
 		il_set_bit(il, CSR_HW_IF_CONFIG_REG,
 			    CSR39_HW_IF_CONFIG_REG_BIT_SKU_MRC);
 	} else
-		IL_DEBUG_INFO(il, "SKU OP mode is basic\n");
+		D_INFO("SKU OP mode is basic\n");
 
 	if ((eeprom->board_revision & 0xF0) == 0xD0) {
-		IL_DEBUG_INFO(il, "3945ABG revision is 0x%X\n",
+		D_INFO("3945ABG revision is 0x%X\n",
 			       eeprom->board_revision);
 		il_set_bit(il, CSR_HW_IF_CONFIG_REG,
 			    CSR39_HW_IF_CONFIG_REG_BIT_BOARD_TYPE);
 	} else {
-		IL_DEBUG_INFO(il, "3945ABG revision is 0x%X\n",
+		D_INFO("3945ABG revision is 0x%X\n",
 			       eeprom->board_revision);
 		il_clear_bit(il, CSR_HW_IF_CONFIG_REG,
 			      CSR39_HW_IF_CONFIG_REG_BIT_BOARD_TYPE);
@@ -936,10 +936,10 @@ static void il3945_nic_config(struct il_priv *il)
 	if (eeprom->almgor_m_version <= 1) {
 		il_set_bit(il, CSR_HW_IF_CONFIG_REG,
 			    CSR39_HW_IF_CONFIG_REG_BITS_SILICON_TYPE_A);
-		IL_DEBUG_INFO(il, "Card M type A version is 0x%X\n",
+		D_INFO("Card M type A version is 0x%X\n",
 			       eeprom->almgor_m_version);
 	} else {
-		IL_DEBUG_INFO(il, "Card M type B version is 0x%X\n",
+		D_INFO("Card M type B version is 0x%X\n",
 			       eeprom->almgor_m_version);
 		il_set_bit(il, CSR_HW_IF_CONFIG_REG,
 			    CSR39_HW_IF_CONFIG_REG_BITS_SILICON_TYPE_B);
@@ -947,10 +947,10 @@ static void il3945_nic_config(struct il_priv *il)
 	spin_unlock_irqrestore(&il->lock, flags);
 
 	if (eeprom->sku_cap & EEPROM_SKU_CAP_SW_RF_KILL_ENABLE)
-		IL_DEBUG_RF_KILL(il, "SW RF KILL supported in EEPROM.\n");
+		D_RF_KILL("SW RF KILL supported in EEPROM.\n");
 
 	if (eeprom->sku_cap & EEPROM_SKU_CAP_HW_RF_KILL_ENABLE)
-		IL_DEBUG_RF_KILL(il, "HW RF KILL supported in EEPROM.\n");
+		D_RF_KILL("HW RF KILL supported in EEPROM.\n");
 }
 
 int il3945_hw_nic_init(struct il_priv *il)
@@ -1074,7 +1074,7 @@ static int il3945_hw_reg_txpower_get_temperature(struct il_priv *il)
 
 	/* driver's okay range is -260 to +25.
 	 *   human readable okay range is 0 to +285 */
-	IL_DEBUG_INFO(il, "Temperature: %d\n", temperature + IL_TEMP_CONVERT);
+	D_INFO("Temperature: %d\n", temperature + IL_TEMP_CONVERT);
 
 	/* handle insane temp reading */
 	if (il3945_hw_reg_temp_out_of_range(temperature)) {
@@ -1111,20 +1111,20 @@ static int il3945_is_temp_calib_needed(struct il_priv *il)
 
 	/* get absolute value */
 	if (temp_diff < 0) {
-		IL_DEBUG_POWER(il, "Getting cooler, delta %d,\n", temp_diff);
+		D_POWER("Getting cooler, delta %d,\n", temp_diff);
 		temp_diff = -temp_diff;
 	} else if (temp_diff == 0)
-		IL_DEBUG_POWER(il, "Same temp,\n");
+		D_POWER("Same temp,\n");
 	else
-		IL_DEBUG_POWER(il, "Getting warmer, delta %d,\n", temp_diff);
+		D_POWER("Getting warmer, delta %d,\n", temp_diff);
 
 	/* if we don't need calibration, *don't* update last_temperature */
 	if (temp_diff < IL_TEMPERATURE_LIMIT_TIMER) {
-		IL_DEBUG_POWER(il, "Timed thermal calib not needed\n");
+		D_POWER("Timed thermal calib not needed\n");
 		return 0;
 	}
 
-	IL_DEBUG_POWER(il, "Timed thermal calib needed\n");
+	D_POWER("Timed thermal calib needed\n");
 
 	/* assume that caller will actually do calib ...
 	 *   update the "last temperature" value */
@@ -1395,7 +1395,7 @@ static int il3945_send_tx_power(struct il_priv *il)
 	}
 
 	if (!il_is_channel_valid(ch_info)) {
-		IL_DEBUG_POWER(il, "Not calling TX_PWR_TABLE_CMD on "
+		D_POWER("Not calling TX_PWR_TABLE_CMD on "
 				"non-Tx channel.\n");
 		return 0;
 	}
@@ -1408,7 +1408,7 @@ static int il3945_send_tx_power(struct il_priv *il)
 		txpower.power[i].tpc = ch_info->power_info[i].tpc;
 		txpower.power[i].rate = il3945_rates[rate_idx].plcp;
 
-		IL_DEBUG_POWER(il, "ch %d:%d rf %d dsp %3d rate code 0x%02x\n",
+		D_POWER("ch %d:%d rf %d dsp %3d rate code 0x%02x\n",
 				le16_to_cpu(txpower.channel),
 				txpower.band,
 				txpower.power[i].tpc.tx_gain,
@@ -1421,7 +1421,7 @@ static int il3945_send_tx_power(struct il_priv *il)
 		txpower.power[i].tpc = ch_info->power_info[i].tpc;
 		txpower.power[i].rate = il3945_rates[rate_idx].plcp;
 
-		IL_DEBUG_POWER(il, "ch %d:%d rf %d dsp %3d rate code 0x%02x\n",
+		D_POWER("ch %d:%d rf %d dsp %3d rate code 0x%02x\n",
 				le16_to_cpu(txpower.channel),
 				txpower.band,
 				txpower.power[i].tpc.tx_gain,
@@ -1617,12 +1617,12 @@ int il3945_hw_reg_set_txpower(struct il_priv *il, s8 power)
 	u8 i;
 
 	if (il->tx_power_user_lmt == power) {
-		IL_DEBUG_POWER(il, "Requested Tx power same as current "
+		D_POWER("Requested Tx power same as current "
 				"limit: %ddBm.\n", power);
 		return 0;
 	}
 
-	IL_DEBUG_POWER(il, "Setting upper limit clamp to %ddBm.\n", power);
+	D_POWER("Setting upper limit clamp to %ddBm.\n", power);
 	il->tx_power_user_lmt = power;
 
 	/* set up new Tx powers for each and every channel, 2.4 and 5.x */
@@ -1670,7 +1670,7 @@ static int il3945_send_rxon_assoc(struct il_priv *il,
 	    (rxon1->filter_flags == rxon2->filter_flags) &&
 	    (rxon1->cck_basic_rates == rxon2->cck_basic_rates) &&
 	    (rxon1->ofdm_basic_rates == rxon2->ofdm_basic_rates)) {
-		IL_DEBUG_INFO(il, "Using current RXON_ASSOC.  Not resending.\n");
+		D_INFO("Using current RXON_ASSOC.  Not resending.\n");
 		return 0;
 	}
 
@@ -1758,7 +1758,7 @@ int il3945_commit_rxon(struct il_priv *il, struct il_rxon_context *ctx)
 	 * we must clear the associated from the active configuration
 	 * before we apply the new config */
 	if (il_is_associated(il, IL_RXON_CTX_BSS) && new_assoc) {
-		IL_DEBUG_INFO(il, "Toggling associated bit on current RXON\n");
+		D_INFO("Toggling associated bit on current RXON\n");
 		active_rxon->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 
 		/*
@@ -1785,7 +1785,7 @@ int il3945_commit_rxon(struct il_priv *il, struct il_rxon_context *ctx)
 					 &il->contexts[IL_RXON_CTX_BSS]);
 	}
 
-	IL_DEBUG_INFO(il, "Sending RXON\n"
+	D_INFO("Sending RXON\n"
 		       "* with%s RXON_FILTER_ASSOC_MSK\n"
 		       "* channel = %d\n"
 		       "* bssid = %pM\n",
@@ -1913,7 +1913,7 @@ static u16 il3945_hw_reg_get_ch_grp_index(struct il_priv *il,
 	} else
 		group_index = 0;	/* 2.4 GHz, group 0 */
 
-	IL_DEBUG_POWER(il, "Chnl %d mapped to grp %d\n", ch_info->channel,
+	D_POWER("Chnl %d mapped to grp %d\n", ch_info->channel,
 			group_index);
 	return group_index;
 }
@@ -1980,7 +1980,7 @@ static void il3945_hw_reg_init_channel_groups(struct il_priv *il)
 	struct il3945_eeprom *eeprom = (struct il3945_eeprom *)il->eeprom;
 	const struct il3945_eeprom_txpower_group *group;
 
-	IL_DEBUG_POWER(il, "Initializing factory calib info from EEPROM\n");
+	D_POWER("Initializing factory calib info from EEPROM\n");
 
 	for (i = 0; i < IL_NUM_TX_CALIB_GROUPS; i++) {
 		s8 *clip_pwrs;	/* table of power levels for each rate */
@@ -2096,7 +2096,7 @@ int il3945_txpower_set_from_eeprom(struct il_priv *il)
 				eeprom->groups[ch_info->group_index].
 				temperature);
 
-		IL_DEBUG_POWER(il, "Delta index for channel %d: %d [%d]\n",
+		D_POWER("Delta index for channel %d: %d [%d]\n",
 				ch_info->channel, delta_index, temperature +
 				IL_TEMP_CONVERT);
 
@@ -2324,7 +2324,7 @@ int il3945_init_hw_rate_table(struct il_priv *il)
 
 	switch (il->band) {
 	case IEEE80211_BAND_5GHZ:
-		IL_DEBUG_RATE(il, "Select A mode rate scale\n");
+		D_RATE("Select A mode rate scale\n");
 		/* If one of the following CCK rates is used,
 		 * have it fall back to the 6M OFDM rate */
 		for (i = IL_RATE_1M_INDEX_TABLE;
@@ -2342,7 +2342,7 @@ int il3945_init_hw_rate_table(struct il_priv *il)
 		break;
 
 	case IEEE80211_BAND_2GHZ:
-		IL_DEBUG_RATE(il, "Select B/G mode rate scale\n");
+		D_RATE("Select B/G mode rate scale\n");
 		/* If an OFDM rate is used, have it fall back to the
 		 * 1M CCK rates */
 
@@ -2472,7 +2472,7 @@ static int il3945_verify_bsm(struct il_priv *il)
 	u32 reg;
 	u32 val;
 
-	IL_DEBUG_INFO(il, "Begin verify bsm\n");
+	D_INFO("Begin verify bsm\n");
 
 	/* verify BSM SRAM contents */
 	val = il_read_prph(il, BSM_WR_DWCOUNT_REG);
@@ -2490,7 +2490,7 @@ static int il3945_verify_bsm(struct il_priv *il)
 		}
 	}
 
-	IL_DEBUG_INFO(il, "BSM bootstrap uCode image OK\n");
+	D_INFO("BSM bootstrap uCode image OK\n");
 
 	return 0;
 }
@@ -2567,7 +2567,7 @@ static int il3945_load_bsm(struct il_priv *il)
 	u32 done;
 	u32 reg_offset;
 
-	IL_DEBUG_INFO(il, "Begin load bsm\n");
+	D_INFO("Begin load bsm\n");
 
 	/* make sure bootstrap program is no larger than BSM's SRAM size */
 	if (len > IWL39_MAX_BSM_SIZE)
@@ -2618,7 +2618,7 @@ static int il3945_load_bsm(struct il_priv *il)
 		udelay(10);
 	}
 	if (i < 100)
-		IL_DEBUG_INFO(il, "BSM write complete, poll %d iterations\n", i);
+		D_INFO("BSM write complete, poll %d iterations\n", i);
 	else {
 		IL_ERR(il, "BSM write did not complete!\n");
 		return -EIO;
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-calib.c b/drivers/net/wireless/iwlegacy/iwl-4965-calib.c
index 7807dc5..7f85834 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-calib.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-calib.c
@@ -160,7 +160,7 @@ static int il4965_sens_energy_cck(struct il_priv *il,
 		val = data->nrg_silence_rssi[i];
 		silence_ref = max(silence_ref, val);
 	}
-	IL_DEBUG_CALIB(il, "silence a %u, b %u, c %u, 20-bcn max %u\n",
+	D_CALIB("silence a %u, b %u, c %u, 20-bcn max %u\n",
 			silence_rssi_a, silence_rssi_b, silence_rssi_c,
 			silence_ref);
 
@@ -184,7 +184,7 @@ static int il4965_sens_energy_cck(struct il_priv *il,
 		max_nrg_cck = (u32) max(max_nrg_cck, (data->nrg_value[i]));
 	max_nrg_cck += 6;
 
-	IL_DEBUG_CALIB(il, "rx energy a %u, b %u, c %u, 10-bcn max/min %u\n",
+	D_CALIB("rx energy a %u, b %u, c %u, 10-bcn max/min %u\n",
 			rx_info->beacon_energy_a, rx_info->beacon_energy_b,
 			rx_info->beacon_energy_c, max_nrg_cck - 6);
 
@@ -194,15 +194,15 @@ static int il4965_sens_energy_cck(struct il_priv *il,
 		data->num_in_cck_no_fa++;
 	else
 		data->num_in_cck_no_fa = 0;
-	IL_DEBUG_CALIB(il, "consecutive bcns with few false alarms = %u\n",
+	D_CALIB("consecutive bcns with few false alarms = %u\n",
 			data->num_in_cck_no_fa);
 
 	/* If we got too many false alarms this time, reduce sensitivity */
 	if ((false_alarms > max_false_alarms) &&
 		(data->auto_corr_cck > AUTO_CORR_MAX_TH_CCK)) {
-		IL_DEBUG_CALIB(il, "norm FA %u > max FA %u\n",
+		D_CALIB("norm FA %u > max FA %u\n",
 		     false_alarms, max_false_alarms);
-		IL_DEBUG_CALIB(il, "... reducing sensitivity\n");
+		D_CALIB("... reducing sensitivity\n");
 		data->nrg_curr_state = IL_FA_TOO_MANY;
 		/* Store for "fewer than desired" on later beacon */
 		data->nrg_silence_ref = silence_ref;
@@ -219,7 +219,7 @@ static int il4965_sens_energy_cck(struct il_priv *il,
 		data->nrg_auto_corr_silence_diff = (s32)data->nrg_silence_ref -
 						   (s32)silence_ref;
 
-		IL_DEBUG_CALIB(il,
+		D_CALIB(
 			 "norm FA %u < min FA %u, silence diff %d\n",
 			 false_alarms, min_false_alarms,
 			 data->nrg_auto_corr_silence_diff);
@@ -234,18 +234,18 @@ static int il4965_sens_energy_cck(struct il_priv *il,
 			((data->nrg_auto_corr_silence_diff > NRG_DIFF) ||
 			(data->num_in_cck_no_fa > MAX_NUMBER_CCK_NO_FA))) {
 
-			IL_DEBUG_CALIB(il, "... increasing sensitivity\n");
+			D_CALIB("... increasing sensitivity\n");
 			/* Increase nrg value to increase sensitivity */
 			val = data->nrg_th_cck + NRG_STEP_CCK;
 			data->nrg_th_cck = min((u32)ranges->min_nrg_cck, val);
 		} else {
-			IL_DEBUG_CALIB(il,
+			D_CALIB(
 					 "... but not changing sensitivity\n");
 		}
 
 	/* Else we got a healthy number of false alarms, keep status quo */
 	} else {
-		IL_DEBUG_CALIB(il, " FA in safe zone\n");
+		D_CALIB(" FA in safe zone\n");
 		data->nrg_curr_state = IL_FA_GOOD_RANGE;
 
 		/* Store for use in "fewer than desired" with later beacon */
@@ -255,7 +255,7 @@ static int il4965_sens_energy_cck(struct il_priv *il,
 		 *   give it some extra margin by reducing sensitivity again
 		 *   (but don't go below measured energy of desired Rx) */
 		if (IL_FA_TOO_MANY == data->nrg_prev_state) {
-			IL_DEBUG_CALIB(il, "... increasing margin\n");
+			D_CALIB("... increasing margin\n");
 			if (data->nrg_th_cck > (max_nrg_cck + NRG_MARGIN))
 				data->nrg_th_cck -= NRG_MARGIN;
 			else
@@ -269,7 +269,7 @@ static int il4965_sens_energy_cck(struct il_priv *il,
 	 * Lower value is higher energy, so we use max()!
 	 */
 	data->nrg_th_cck = max(max_nrg_cck, data->nrg_th_cck);
-	IL_DEBUG_CALIB(il, "new nrg_th_cck %u\n", data->nrg_th_cck);
+	D_CALIB("new nrg_th_cck %u\n", data->nrg_th_cck);
 
 	data->nrg_prev_state = data->nrg_curr_state;
 
@@ -322,7 +322,7 @@ static int il4965_sens_auto_corr_ofdm(struct il_priv *il,
 	/* If we got too many false alarms this time, reduce sensitivity */
 	if (false_alarms > max_false_alarms) {
 
-		IL_DEBUG_CALIB(il, "norm FA %u > max FA %u)\n",
+		D_CALIB("norm FA %u > max FA %u)\n",
 			     false_alarms, max_false_alarms);
 
 		val = data->auto_corr_ofdm + AUTO_CORR_STEP_OFDM;
@@ -345,7 +345,7 @@ static int il4965_sens_auto_corr_ofdm(struct il_priv *il,
 	/* Else if we got fewer than desired, increase sensitivity */
 	else if (false_alarms < min_false_alarms) {
 
-		IL_DEBUG_CALIB(il, "norm FA %u < min FA %u\n",
+		D_CALIB("norm FA %u < min FA %u\n",
 			     false_alarms, min_false_alarms);
 
 		val = data->auto_corr_ofdm - AUTO_CORR_STEP_OFDM;
@@ -364,7 +364,7 @@ static int il4965_sens_auto_corr_ofdm(struct il_priv *il,
 		data->auto_corr_ofdm_mrc_x1 =
 			max((u32)ranges->auto_corr_min_ofdm_mrc_x1, val);
 	} else {
-		IL_DEBUG_CALIB(il, "min FA %u < norm FA %u < max FA %u OK\n",
+		D_CALIB("min FA %u < norm FA %u < max FA %u OK\n",
 			 min_false_alarms, false_alarms, max_false_alarms);
 	}
 	return 0;
@@ -400,12 +400,12 @@ static void il4965_prepare_legacy_sensitivity_tbl(struct il_priv *il,
 	tbl[HD_OFDM_ENERGY_TH_IN_INDEX] =
 				cpu_to_le16(data->nrg_th_cca);
 
-	IL_DEBUG_CALIB(il, "ofdm: ac %u mrc %u x1 %u mrc_x1 %u thresh %u\n",
+	D_CALIB("ofdm: ac %u mrc %u x1 %u mrc_x1 %u thresh %u\n",
 			data->auto_corr_ofdm, data->auto_corr_ofdm_mrc,
 			data->auto_corr_ofdm_x1, data->auto_corr_ofdm_mrc_x1,
 			data->nrg_th_ofdm);
 
-	IL_DEBUG_CALIB(il, "cck: ac %u mrc %u thresh %u\n",
+	D_CALIB("cck: ac %u mrc %u thresh %u\n",
 			data->auto_corr_cck, data->auto_corr_cck_mrc,
 			data->nrg_th_cck);
 }
@@ -434,7 +434,7 @@ static int il4965_sensitivity_write(struct il_priv *il)
 	/* Don't send command to uCode if nothing has changed */
 	if (!memcmp(&cmd.table[0], &(il->sensitivity_tbl[0]),
 		    sizeof(u16)*HD_TABLE_SIZE)) {
-		IL_DEBUG_CALIB(il, "No change in SENSITIVITY_CMD\n");
+		D_CALIB("No change in SENSITIVITY_CMD\n");
 		return 0;
 	}
 
@@ -455,7 +455,7 @@ void il4965_init_sensitivity(struct il_priv *il)
 	if (il->disable_sens_cal)
 		return;
 
-	IL_DEBUG_CALIB(il, "Start il4965_init_sensitivity\n");
+	D_CALIB("Start il4965_init_sensitivity\n");
 
 	/* Clear driver's sensitivity algo data */
 	data = &(il->sensitivity_data);
@@ -496,7 +496,7 @@ void il4965_init_sensitivity(struct il_priv *il)
 	data->last_fa_cnt_cck = 0;
 
 	ret |= il4965_sensitivity_write(il);
-	IL_DEBUG_CALIB(il, "<<return 0x%X\n", ret);
+	D_CALIB("<<return 0x%X\n", ret);
 }
 
 void il4965_sensitivity_calibration(struct il_priv *il, void *resp)
@@ -520,7 +520,7 @@ void il4965_sensitivity_calibration(struct il_priv *il, void *resp)
 	data = &(il->sensitivity_data);
 
 	if (!il_is_any_associated(il)) {
-		IL_DEBUG_CALIB(il, "<< - not associated\n");
+		D_CALIB("<< - not associated\n");
 		return;
 	}
 
@@ -531,7 +531,7 @@ void il4965_sensitivity_calibration(struct il_priv *il, void *resp)
 	cck = &(((struct il_notif_statistics *)resp)->rx.cck);
 
 	if (rx_info->interference_data_flag != INTERFERENCE_DATA_AVAILABLE) {
-		IL_DEBUG_CALIB(il, "<< invalid data.\n");
+		D_CALIB("<< invalid data.\n");
 		spin_unlock_irqrestore(&il->lock, flags);
 		return;
 	}
@@ -558,10 +558,10 @@ void il4965_sensitivity_calibration(struct il_priv *il, void *resp)
 
 	spin_unlock_irqrestore(&il->lock, flags);
 
-	IL_DEBUG_CALIB(il, "rx_enable_time = %u usecs\n", rx_enable_time);
+	D_CALIB("rx_enable_time = %u usecs\n", rx_enable_time);
 
 	if (!rx_enable_time) {
-		IL_DEBUG_CALIB(il, "<< RX Enable Time == 0!\n");
+		D_CALIB("<< RX Enable Time == 0!\n");
 		return;
 	}
 
@@ -600,7 +600,7 @@ void il4965_sensitivity_calibration(struct il_priv *il, void *resp)
 	norm_fa_ofdm = fa_ofdm + bad_plcp_ofdm;
 	norm_fa_cck = fa_cck + bad_plcp_cck;
 
-	IL_DEBUG_CALIB(il,
+	D_CALIB(
 			 "cck: fa %u badp %u  ofdm: fa %u badp %u\n", fa_cck,
 			bad_plcp_cck, fa_ofdm, bad_plcp_ofdm);
 
@@ -657,9 +657,9 @@ il4965_find_disconn_antenna(struct il_priv *il, u32* average_sig,
 		active_chains = (1 << max_average_sig_antenna_i);
 	}
 
-	IL_DEBUG_CALIB(il, "average_sig: a %d b %d c %d\n",
+	D_CALIB("average_sig: a %d b %d c %d\n",
 		     average_sig[0], average_sig[1], average_sig[2]);
-	IL_DEBUG_CALIB(il, "max_average_sig = %d, antenna %d\n",
+	D_CALIB("max_average_sig = %d, antenna %d\n",
 		     max_average_sig, max_average_sig_antenna_i);
 
 	/* Compare signal strengths for all 3 receivers. */
@@ -673,7 +673,7 @@ il4965_find_disconn_antenna(struct il_priv *il, u32* average_sig,
 				data->disconn_array[i] = 1;
 			else
 				active_chains |= (1 << i);
-			IL_DEBUG_CALIB(il, "i = %d  rssiDelta = %d  "
+			D_CALIB("i = %d  rssiDelta = %d  "
 			     "disconn_array[i] = %d\n",
 			     i, rssi_delta, data->disconn_array[i]);
 		}
@@ -713,7 +713,7 @@ il4965_find_disconn_antenna(struct il_priv *il, u32* average_sig,
 			il4965_find_first_chain(il->cfg->valid_tx_ant);
 			data->disconn_array[first_chain] = 0;
 			active_chains |= BIT(first_chain);
-			IL_DEBUG_CALIB(il,
+			D_CALIB(
 					"All Tx chains are disconnected W/A - declare %d as connected\n",
 					first_chain);
 			break;
@@ -722,14 +722,14 @@ il4965_find_disconn_antenna(struct il_priv *il, u32* average_sig,
 
 	if (active_chains != il->hw_params.valid_rx_ant &&
 	    active_chains != il->chain_noise_data.active_chains)
-		IL_DEBUG_CALIB(il,
+		D_CALIB(
 				"Detected that not all antennas are connected! "
 				"Connected: %#x, valid: %#x.\n",
 				active_chains, il->hw_params.valid_rx_ant);
 
 	/* Save for use within RXON, TX, SCAN commands, etc. */
 	data->active_chains = active_chains;
-	IL_DEBUG_CALIB(il, "active_chains (bitwise) = 0x%x\n",
+	D_CALIB("active_chains (bitwise) = 0x%x\n",
 			active_chains);
 }
 
@@ -762,7 +762,7 @@ static void il4965_gain_computation(struct il_priv *il,
 			data->delta_gain_code[i] = 0;
 		}
 	}
-	IL_DEBUG_CALIB(il, "delta_gain_codes: a %d b %d c %d\n",
+	D_CALIB("delta_gain_codes: a %d b %d c %d\n",
 		     data->delta_gain_code[0],
 		     data->delta_gain_code[1],
 		     data->delta_gain_code[2]);
@@ -780,7 +780,7 @@ static void il4965_gain_computation(struct il_priv *il,
 		ret = il_send_cmd_pdu(il, REPLY_PHY_CALIBRATION_CMD,
 				      sizeof(cmd), &cmd);
 		if (ret)
-			IL_DEBUG_CALIB(il, "fail sending cmd "
+			D_CALIB("fail sending cmd "
 				     "REPLY_PHY_CALIBRATION_CMD\n");
 
 		/* TODO we might want recalculate
@@ -834,7 +834,7 @@ void il4965_chain_noise_calibration(struct il_priv *il, void *stat_resp)
 	 */
 	if (data->state != IL_CHAIN_NOISE_ACCUMULATE) {
 		if (data->state == IL_CHAIN_NOISE_ALIVE)
-			IL_DEBUG_CALIB(il, "Wait for noise calib reset\n");
+			D_CALIB("Wait for noise calib reset\n");
 		return;
 	}
 
@@ -844,7 +844,7 @@ void il4965_chain_noise_calibration(struct il_priv *il, void *stat_resp)
 		      rx.general);
 
 	if (rx_info->interference_data_flag != INTERFERENCE_DATA_AVAILABLE) {
-		IL_DEBUG_CALIB(il, " << Interference data unavailable\n");
+		D_CALIB(" << Interference data unavailable\n");
 		spin_unlock_irqrestore(&il->lock, flags);
 		return;
 	}
@@ -861,7 +861,7 @@ void il4965_chain_noise_calibration(struct il_priv *il, void *stat_resp)
 	/* Make sure we accumulate data for just the associated channel
 	 *   (even if scanning). */
 	if ((rxon_chnum != stat_chnum) || (rxon_band24 != stat_band24)) {
-		IL_DEBUG_CALIB(il, "Stats not from chan=%d, band24=%d\n",
+		D_CALIB("Stats not from chan=%d, band24=%d\n",
 				rxon_chnum, rxon_band24);
 		spin_unlock_irqrestore(&il->lock, flags);
 		return;
@@ -894,11 +894,11 @@ void il4965_chain_noise_calibration(struct il_priv *il, void *stat_resp)
 	data->chain_signal_b = (chain_sig_b + data->chain_signal_b);
 	data->chain_signal_c = (chain_sig_c + data->chain_signal_c);
 
-	IL_DEBUG_CALIB(il, "chan=%d, band24=%d, beacon=%d\n",
+	D_CALIB("chan=%d, band24=%d, beacon=%d\n",
 			rxon_chnum, rxon_band24, data->beacon_count);
-	IL_DEBUG_CALIB(il, "chain_sig: a %d b %d c %d\n",
+	D_CALIB("chain_sig: a %d b %d c %d\n",
 			chain_sig_a, chain_sig_b, chain_sig_c);
-	IL_DEBUG_CALIB(il, "chain_noise: a %d b %d c %d\n",
+	D_CALIB("chain_noise: a %d b %d c %d\n",
 			chain_noise_a, chain_noise_b, chain_noise_c);
 
 	/* If this is the "chain_noise_num_beacons", determine:
@@ -929,11 +929,11 @@ void il4965_chain_noise_calibration(struct il_priv *il, void *stat_resp)
 		}
 	}
 
-	IL_DEBUG_CALIB(il, "average_noise: a %d b %d c %d\n",
+	D_CALIB("average_noise: a %d b %d c %d\n",
 			average_noise[0], average_noise[1],
 			average_noise[2]);
 
-	IL_DEBUG_CALIB(il, "min_average_noise = %d, antenna %d\n",
+	D_CALIB("min_average_noise = %d, antenna %d\n",
 			min_average_noise, min_average_noise_antenna_i);
 
 	il4965_gain_computation(il, average_noise,
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-lib.c b/drivers/net/wireless/iwlegacy/iwl-4965-lib.c
index 1564629..b51ae3d 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-lib.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-lib.c
@@ -303,7 +303,7 @@ static void il4965_rx_allocate(struct il_priv *il, gfp_t priority)
 		page = alloc_pages(gfp_mask, il->hw_params.rx_page_order);
 		if (!page) {
 			if (net_ratelimit())
-				IL_DEBUG_INFO(il, "alloc_pages failed, "
+				D_INFO("alloc_pages failed, "
 					       "order: %d\n",
 					       il->hw_params.rx_page_order);
 
@@ -456,7 +456,7 @@ static int il4965_calc_rssi(struct il_priv *il,
 		if (valid_antennae & (1 << i))
 			max_rssi = max(ncphy->rssi_info[i << 1], max_rssi);
 
-	IL_DEBUG_STATS(il, "Rssi In A %d B %d C %d Max %d AGC dB %d\n",
+	D_STATS("Rssi In A %d B %d C %d Max %d AGC dB %d\n",
 		ncphy->rssi_info[0], ncphy->rssi_info[2], ncphy->rssi_info[4],
 		max_rssi, agc);
 
@@ -519,7 +519,7 @@ static u32 il4965_translate_rx_status(struct il_priv *il, u32 decrypt_in)
 		break;
 	}
 
-	IL_DEBUG_RX(il, "decrypt_in:0x%x  decrypt_out = 0x%x\n",
+	D_RX("decrypt_in:0x%x  decrypt_out = 0x%x\n",
 					decrypt_in, decrypt_out);
 
 	return decrypt_out;
@@ -537,7 +537,7 @@ static void il4965_pass_packet_to_mac80211(struct il_priv *il,
 
 	/* We only process data packets if the interface is open */
 	if (unlikely(!il->is_open)) {
-		IL_DEBUG_DROP(il,
+		D_DROP(
 		    "Dropping packet while interface is not open.\n");
 		return;
 	}
@@ -611,14 +611,14 @@ void il4965_rx_reply_rx(struct il_priv *il,
 	}
 
 	if ((unlikely(phy_res->cfg_phy_cnt > 20))) {
-		IL_DEBUG_DROP(il, "dsp size out of range [0,20]: %d/n",
+		D_DROP("dsp size out of range [0,20]: %d/n",
 				phy_res->cfg_phy_cnt);
 		return;
 	}
 
 	if (!(rx_pkt_status & RX_RES_STATUS_NO_CRC32_ERROR) ||
 	    !(rx_pkt_status & RX_RES_STATUS_NO_RXE_OVERFLOW)) {
-		IL_DEBUG_RX(il, "Bad CRC or FIFO: 0x%08X.\n",
+		D_RX("Bad CRC or FIFO: 0x%08X.\n",
 				le32_to_cpu(rx_pkt_status));
 		return;
 	}
@@ -647,7 +647,7 @@ void il4965_rx_reply_rx(struct il_priv *il,
 	rx_status.signal = il4965_calc_rssi(il, phy_res);
 
 	il_dbg_log_rx_data_frame(il, len, header);
-	IL_DEBUG_STATS(il, "Rssi %d, TSF %llu\n",
+	D_STATS("Rssi %d, TSF %llu\n",
 		rx_status.signal, (unsigned long long)rx_status.mactime);
 
 	/*
@@ -729,7 +729,7 @@ static int il4965_get_channels_for_scan(struct il_priv *il,
 
 		ch_info = il_get_channel_info(il, band, channel);
 		if (!il_is_channel_valid(ch_info)) {
-			IL_DEBUG_SCAN(il,
+			D_SCAN(
 				 "Channel %d is INVALID for this band.\n",
 					channel);
 			continue;
@@ -759,7 +759,7 @@ static int il4965_get_channels_for_scan(struct il_priv *il,
 		else
 			scan_ch->tx_gain = ((1 << 5) | (5 << 3));
 
-		IL_DEBUG_SCAN(il, "Scanning ch=%d prob=0x%X [%s %d]\n",
+		D_SCAN("Scanning ch=%d prob=0x%X [%s %d]\n",
 			       channel, le32_to_cpu(scan_ch->type),
 			       (scan_ch->type & SCAN_CHANNEL_TYPE_ACTIVE) ?
 				"ACTIVE" : "PASSIVE",
@@ -770,7 +770,7 @@ static int il4965_get_channels_for_scan(struct il_priv *il,
 		added++;
 	}
 
-	IL_DEBUG_SCAN(il, "total channels to scan %d\n", added);
+	D_SCAN("total channels to scan %d\n", added);
 	return added;
 }
 
@@ -805,7 +805,7 @@ int il4965_request_scan(struct il_priv *il, struct ieee80211_vif *vif)
 		il->scan_cmd = kmalloc(sizeof(struct il_scan_cmd) +
 					 IL_MAX_SCAN_SIZE, GFP_KERNEL);
 		if (!il->scan_cmd) {
-			IL_DEBUG_SCAN(il,
+			D_SCAN(
 				       "fail to allocate memory for scan\n");
 			return -ENOMEM;
 		}
@@ -822,7 +822,7 @@ int il4965_request_scan(struct il_priv *il, struct ieee80211_vif *vif)
 		u32 suspend_time = 100;
 		u32 scan_suspend_time = 100;
 
-		IL_DEBUG_INFO(il, "Scanning while associated...\n");
+		D_INFO("Scanning while associated...\n");
 		interval = vif->bss_conf.beacon_int;
 
 		scan->suspend_time = 0;
@@ -834,13 +834,13 @@ int il4965_request_scan(struct il_priv *il, struct ieee80211_vif *vif)
 		scan_suspend_time = (extra |
 		    ((suspend_time % interval) * 1024));
 		scan->suspend_time = cpu_to_le32(scan_suspend_time);
-		IL_DEBUG_SCAN(il, "suspend_time 0x%X beacon interval %d\n",
+		D_SCAN("suspend_time 0x%X beacon interval %d\n",
 			       scan_suspend_time, interval);
 	}
 
 	if (il->scan_request->n_ssids) {
 		int i, p = 0;
-		IL_DEBUG_SCAN(il, "Kicking off active scan\n");
+		D_SCAN("Kicking off active scan\n");
 		for (i = 0; i < il->scan_request->n_ssids; i++) {
 			/* always does wildcard anyway */
 			if (!il->scan_request->ssids[i].ssid_len)
@@ -856,7 +856,7 @@ int il4965_request_scan(struct il_priv *il, struct ieee80211_vif *vif)
 		}
 		is_active = true;
 	} else
-		IL_DEBUG_SCAN(il, "Start passive scan.\n");
+		D_SCAN("Start passive scan.\n");
 
 	scan->tx_cmd.tx_flags = TX_CMD_FLG_SEQ_CTL_MSK;
 	scan->tx_cmd.sta_id = ctx->bcast_sta_id;
@@ -923,7 +923,7 @@ int il4965_request_scan(struct il_priv *il, struct ieee80211_vif *vif)
 		if (!active_chains)
 			active_chains = rx_ant;
 
-		IL_DEBUG_SCAN(il, "chain_noise_data.active_chains: %u\n",
+		D_SCAN("chain_noise_data.active_chains: %u\n",
 				il->chain_noise_data.active_chains);
 
 		rx_ant = il4965_first_antenna(active_chains);
@@ -951,7 +951,7 @@ int il4965_request_scan(struct il_priv *il, struct ieee80211_vif *vif)
 						is_active, n_probes,
 						(void *)&scan->data[cmd_len]);
 	if (scan->channel_count == 0) {
-		IL_DEBUG_SCAN(il, "channel count %d\n", scan->channel_count);
+		D_SCAN("channel count %d\n", scan->channel_count);
 		return -EIO;
 	}
 
@@ -990,7 +990,7 @@ void il4965_free_tfds_in_queue(struct il_priv *il,
 	if (il->stations[sta_id].tid[tid].tfds_in_queue >= freed)
 		il->stations[sta_id].tid[tid].tfds_in_queue -= freed;
 	else {
-		IL_DEBUG_TX(il, "free more than tfds_in_queue (%u:%d)\n",
+		D_TX("free more than tfds_in_queue (%u:%d)\n",
 			il->stations[sta_id].tid[tid].tfds_in_queue,
 			freed);
 		il->stations[sta_id].tid[tid].tfds_in_queue = 0;
@@ -1111,7 +1111,7 @@ void il4965_set_rxon_chain(struct il_priv *il, struct il_rxon_context *ctx)
 	else
 		ctx->staging.rx_chain &= ~RXON_RX_CHAIN_MIMO_FORCE_MSK;
 
-	IL_DEBUG_ASSOC(il, "rx_chain=0x%X active=%d idle=%d\n",
+	D_ASSOC("rx_chain=0x%X active=%d idle=%d\n",
 			ctx->staging.rx_chain,
 			active_rx_cnt, idle_rx_cnt);
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-rs.c b/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
index 782ec77..b53cf1b 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
@@ -358,7 +358,7 @@ static int il4965_rs_tl_turn_on_agg_for_tid(struct il_priv *il,
 	load = il4965_rs_tl_get_load(lq_data, tid);
 
 	if (load > IL_AGG_LOAD_THRESHOLD) {
-		IL_DEBUG_HT(il, "Starting Tx agg: STA: %pM tid: %d\n",
+		D_HT("Starting Tx agg: STA: %pM tid: %d\n",
 				sta->addr, tid);
 		ret = ieee80211_start_tx_ba_session(sta, tid, 5000);
 		if (ret == -EAGAIN) {
@@ -707,7 +707,7 @@ il4965_rs_get_adjacent_rate(struct il_priv *il, u8 index, u16 rate_mask,
 			break;
 		if (rate_mask & (1 << low))
 			break;
-		IL_DEBUG_RATE(il, "Skipping masked lower rate: %d\n", low);
+		D_RATE("Skipping masked lower rate: %d\n", low);
 	}
 
 	high = index;
@@ -717,7 +717,7 @@ il4965_rs_get_adjacent_rate(struct il_priv *il, u8 index, u16 rate_mask,
 			break;
 		if (rate_mask & (1 << high))
 			break;
-		IL_DEBUG_RATE(il, "Skipping masked higher rate: %d\n", high);
+		D_RATE("Skipping masked higher rate: %d\n", high);
 	}
 
 	return (high << 8) | low;
@@ -817,15 +817,15 @@ il4965_rs_tx_status(void *il_r, struct ieee80211_supported_band *sband,
 	struct il_station_priv *sta_priv = (void *)sta->drv_priv;
 	struct il_rxon_context *ctx = sta_priv->common.ctx;
 
-	IL_DEBUG_RATE(il,
+	D_RATE(
 		"get frame ack response, update rate scale window\n");
 
 	/* Treat uninitialized rate scaling data same as non-existing. */
 	if (!lq_sta) {
-		IL_DEBUG_RATE(il, "Station rate scaling not created yet.\n");
+		D_RATE("Station rate scaling not created yet.\n");
 		return;
 	} else if (!lq_sta->drv) {
-		IL_DEBUG_RATE(il, "Rate scaling not initialized yet.\n");
+		D_RATE("Rate scaling not initialized yet.\n");
 		return;
 	}
 
@@ -880,7 +880,7 @@ il4965_rs_tx_status(void *il_r, struct ieee80211_supported_band *sband,
 	    (!!(tx_rate & RATE_MCS_GF_MSK) !=
 			!!(mac_flags & IEEE80211_TX_RC_GREEN_FIELD)) ||
 	    (rs_index != mac_index)) {
-		IL_DEBUG_RATE(il,
+		D_RATE(
 		"initial rate %d does not match %d (0x%x)\n",
 			 mac_index, rs_index, tx_rate);
 		/*
@@ -910,15 +910,15 @@ il4965_rs_tx_status(void *il_r, struct ieee80211_supported_band *sband,
 		curr_tbl = &(lq_sta->lq_info[1 - lq_sta->active_tbl]);
 		other_tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);
 	} else {
-		IL_DEBUG_RATE(il,
+		D_RATE(
 			"Neither active nor search matches tx rate\n");
 		tmp_tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);
-		IL_DEBUG_RATE(il, "active- lq:%x, ant:%x, SGI:%d\n",
+		D_RATE("active- lq:%x, ant:%x, SGI:%d\n",
 			tmp_tbl->lq_type, tmp_tbl->ant_type, tmp_tbl->is_SGI);
 		tmp_tbl = &(lq_sta->lq_info[1 - lq_sta->active_tbl]);
-		IL_DEBUG_RATE(il, "search- lq:%x, ant:%x, SGI:%d\n",
+		D_RATE("search- lq:%x, ant:%x, SGI:%d\n",
 			tmp_tbl->lq_type, tmp_tbl->ant_type, tmp_tbl->is_SGI);
-		IL_DEBUG_RATE(il, "actual- lq:%x, ant:%x, SGI:%d\n",
+		D_RATE("actual- lq:%x, ant:%x, SGI:%d\n",
 			tbl_type.lq_type, tbl_type.ant_type, tbl_type.is_SGI);
 		/*
 		 * no matching table found, let's by-pass the data collection
@@ -1004,7 +1004,7 @@ done:
 static void il4965_rs_set_stay_in_table(struct il_priv *il, u8 is_legacy,
 				 struct il_lq_sta *lq_sta)
 {
-	IL_DEBUG_RATE(il, "we are staying in the same table\n");
+	D_RATE("we are staying in the same table\n");
 	lq_sta->stay_in_tbl = 1;	/* only place this gets set */
 	if (is_legacy) {
 		lq_sta->table_count_limit = IL_LEGACY_TABLE_COUNT;
@@ -1194,7 +1194,7 @@ static int il4965_rs_switch_to_mimo2(struct il_priv *il,
 	if (il->hw_params.tx_chains_num < 2)
 		return -1;
 
-	IL_DEBUG_RATE(il, "LQ: try to switch to MIMO2\n");
+	D_RATE("LQ: try to switch to MIMO2\n");
 
 	tbl->lq_type = LQ_MIMO2;
 	tbl->is_dup = lq_sta->is_dup;
@@ -1211,10 +1211,10 @@ static int il4965_rs_switch_to_mimo2(struct il_priv *il,
 
 	rate = il4965_rs_get_best_rate(il, lq_sta, tbl, rate_mask, index);
 
-	IL_DEBUG_RATE(il, "LQ: MIMO2 best rate %d mask %X\n",
+	D_RATE("LQ: MIMO2 best rate %d mask %X\n",
 				rate, rate_mask);
 	if ((rate == IL_RATE_INVALID) || !((1 << rate) & rate_mask)) {
-		IL_DEBUG_RATE(il,
+		D_RATE(
 				"Can't switch with index %d rate mask %x\n",
 						rate, rate_mask);
 		return -1;
@@ -1222,7 +1222,7 @@ static int il4965_rs_switch_to_mimo2(struct il_priv *il,
 	tbl->current_rate = il4965_rate_n_flags_from_tbl(il,
 						 tbl, rate, is_green);
 
-	IL_DEBUG_RATE(il, "LQ: Switch to new mcs %X index is green %X\n",
+	D_RATE("LQ: Switch to new mcs %X index is green %X\n",
 		     tbl->current_rate, is_green);
 	return 0;
 }
@@ -1245,7 +1245,7 @@ static int il4965_rs_switch_to_siso(struct il_priv *il,
 	if (!conf_is_ht(conf) || !sta->ht_cap.ht_supported)
 		return -1;
 
-	IL_DEBUG_RATE(il, "LQ: try to switch to SISO\n");
+	D_RATE("LQ: try to switch to SISO\n");
 
 	tbl->is_dup = lq_sta->is_dup;
 	tbl->lq_type = LQ_SISO;
@@ -1264,16 +1264,16 @@ static int il4965_rs_switch_to_siso(struct il_priv *il,
 	il4965_rs_set_expected_tpt_table(lq_sta, tbl);
 	rate = il4965_rs_get_best_rate(il, lq_sta, tbl, rate_mask, index);
 
-	IL_DEBUG_RATE(il, "LQ: get best rate %d mask %X\n", rate, rate_mask);
+	D_RATE("LQ: get best rate %d mask %X\n", rate, rate_mask);
 	if ((rate == IL_RATE_INVALID) || !((1 << rate) & rate_mask)) {
-		IL_DEBUG_RATE(il,
+		D_RATE(
 			"can not switch with index %d rate mask %x\n",
 			     rate, rate_mask);
 		return -1;
 	}
 	tbl->current_rate = il4965_rate_n_flags_from_tbl(il,
 						tbl, rate, is_green);
-	IL_DEBUG_RATE(il, "LQ: Switch to new mcs %X index is green %X\n",
+	D_RATE("LQ: Switch to new mcs %X index is green %X\n",
 		     tbl->current_rate, is_green);
 	return 0;
 }
@@ -1307,7 +1307,7 @@ static int il4965_rs_move_legacy_other(struct il_priv *il,
 		switch (tbl->action) {
 		case IL_LEGACY_SWITCH_ANTENNA1:
 		case IL_LEGACY_SWITCH_ANTENNA2:
-			IL_DEBUG_RATE(il, "LQ: Legacy toggle Antenna\n");
+			D_RATE("LQ: Legacy toggle Antenna\n");
 
 			if ((tbl->action == IL_LEGACY_SWITCH_ANTENNA1 &&
 							tx_chains_num <= 1) ||
@@ -1331,7 +1331,7 @@ static int il4965_rs_move_legacy_other(struct il_priv *il,
 			}
 			break;
 		case IL_LEGACY_SWITCH_SISO:
-			IL_DEBUG_RATE(il, "LQ: Legacy switch to SISO\n");
+			D_RATE("LQ: Legacy switch to SISO\n");
 
 			/* Set up search table to try SISO */
 			memcpy(search_tbl, tbl, sz);
@@ -1347,7 +1347,7 @@ static int il4965_rs_move_legacy_other(struct il_priv *il,
 		case IL_LEGACY_SWITCH_MIMO2_AB:
 		case IL_LEGACY_SWITCH_MIMO2_AC:
 		case IL_LEGACY_SWITCH_MIMO2_BC:
-			IL_DEBUG_RATE(il, "LQ: Legacy switch to MIMO2\n");
+			D_RATE("LQ: Legacy switch to MIMO2\n");
 
 			/* Set up search table to try MIMO */
 			memcpy(search_tbl, tbl, sz);
@@ -1424,7 +1424,7 @@ static int il4965_rs_move_siso_to_other(struct il_priv *il,
 		switch (tbl->action) {
 		case IL_SISO_SWITCH_ANTENNA1:
 		case IL_SISO_SWITCH_ANTENNA2:
-			IL_DEBUG_RATE(il, "LQ: SISO toggle Antenna\n");
+			D_RATE("LQ: SISO toggle Antenna\n");
 			if ((tbl->action == IL_SISO_SWITCH_ANTENNA1 &&
 						tx_chains_num <= 1) ||
 			    (tbl->action == IL_SISO_SWITCH_ANTENNA2 &&
@@ -1444,7 +1444,7 @@ static int il4965_rs_move_siso_to_other(struct il_priv *il,
 		case IL_SISO_SWITCH_MIMO2_AB:
 		case IL_SISO_SWITCH_MIMO2_AC:
 		case IL_SISO_SWITCH_MIMO2_BC:
-			IL_DEBUG_RATE(il, "LQ: SISO switch to MIMO2\n");
+			D_RATE("LQ: SISO switch to MIMO2\n");
 			memcpy(search_tbl, tbl, sz);
 			search_tbl->is_SGI = 0;
 
@@ -1473,7 +1473,7 @@ static int il4965_rs_move_siso_to_other(struct il_priv *il,
 						IEEE80211_HT_CAP_SGI_40))
 				break;
 
-			IL_DEBUG_RATE(il, "LQ: SISO toggle SGI/NGI\n");
+			D_RATE("LQ: SISO toggle SGI/NGI\n");
 
 			memcpy(search_tbl, tbl, sz);
 			if (is_green) {
@@ -1545,7 +1545,7 @@ static int il4965_rs_move_mimo2_to_other(struct il_priv *il,
 		switch (tbl->action) {
 		case IL_MIMO2_SWITCH_ANTENNA1:
 		case IL_MIMO2_SWITCH_ANTENNA2:
-			IL_DEBUG_RATE(il, "LQ: MIMO2 toggle Antennas\n");
+			D_RATE("LQ: MIMO2 toggle Antennas\n");
 
 			if (tx_chains_num <= 2)
 				break;
@@ -1563,7 +1563,7 @@ static int il4965_rs_move_mimo2_to_other(struct il_priv *il,
 		case IL_MIMO2_SWITCH_SISO_A:
 		case IL_MIMO2_SWITCH_SISO_B:
 		case IL_MIMO2_SWITCH_SISO_C:
-			IL_DEBUG_RATE(il, "LQ: MIMO2 switch to SISO\n");
+			D_RATE("LQ: MIMO2 switch to SISO\n");
 
 			/* Set up new search table for SISO */
 			memcpy(search_tbl, tbl, sz);
@@ -1595,7 +1595,7 @@ static int il4965_rs_move_mimo2_to_other(struct il_priv *il,
 						IEEE80211_HT_CAP_SGI_40))
 				break;
 
-			IL_DEBUG_RATE(il, "LQ: MIMO2 toggle SGI/NGI\n");
+			D_RATE("LQ: MIMO2 toggle SGI/NGI\n");
 
 			/* Set up new search table for MIMO2 */
 			memcpy(search_tbl, tbl, sz);
@@ -1684,7 +1684,7 @@ il4965_rs_stay_in_table(struct il_lq_sta *lq_sta, bool force_search)
 		    (lq_sta->total_success > lq_sta->max_success_limit) ||
 		    ((!lq_sta->search_better_tbl) && (lq_sta->flush_timer)
 		     && (flush_interval_passed))) {
-			IL_DEBUG_RATE(il, "LQ: stay is expired %d %d %d\n:",
+			D_RATE("LQ: stay is expired %d %d %d\n:",
 				     lq_sta->total_failed,
 				     lq_sta->total_success,
 				     flush_interval_passed);
@@ -1707,7 +1707,7 @@ il4965_rs_stay_in_table(struct il_lq_sta *lq_sta, bool force_search)
 			    lq_sta->table_count_limit) {
 				lq_sta->table_count = 0;
 
-				IL_DEBUG_RATE(il,
+				D_RATE(
 					"LQ: stay in table clear win\n");
 				for (i = 0; i < IL_RATE_COUNT; i++)
 					il4965_rs_rate_scale_clear_window(
@@ -1783,7 +1783,7 @@ static void il4965_rs_rate_scale_perform(struct il_priv *il,
 	struct il_station_priv *sta_priv = (void *)sta->drv_priv;
 	struct il_rxon_context *ctx = sta_priv->common.ctx;
 
-	IL_DEBUG_RATE(il, "rate scale calculate new rate for skb\n");
+	D_RATE("rate scale calculate new rate for skb\n");
 
 	/* Send management frames and NO_ACK data using lowest rate. */
 	/* TODO: this could probably be improved.. */
@@ -1826,13 +1826,13 @@ static void il4965_rs_rate_scale_perform(struct il_priv *il,
 	/* current tx rate */
 	index = lq_sta->last_txrate_idx;
 
-	IL_DEBUG_RATE(il, "Rate scale index %d for type %d\n", index,
+	D_RATE("Rate scale index %d for type %d\n", index,
 		       tbl->lq_type);
 
 	/* rates available for this association, and for modulation mode */
 	rate_mask = il4965_rs_get_supported_rates(lq_sta, hdr, tbl->lq_type);
 
-	IL_DEBUG_RATE(il, "mask 0x%04X\n", rate_mask);
+	D_RATE("mask 0x%04X\n", rate_mask);
 
 	/* mask with station rate restriction */
 	if (is_legacy(tbl->lq_type)) {
@@ -1892,7 +1892,7 @@ static void il4965_rs_rate_scale_perform(struct il_priv *il,
 	fail_count = window->counter - window->success_counter;
 	if ((fail_count < IL_RATE_MIN_FAILURE_TH) &&
 			(window->success_counter < IL_RATE_MIN_SUCCESS_TH)) {
-		IL_DEBUG_RATE(il, "LQ: still below TH. succ=%d total=%d "
+		D_RATE("LQ: still below TH. succ=%d total=%d "
 			       "for index %d\n",
 			       window->success_counter, window->counter, index);
 
@@ -1922,7 +1922,7 @@ static void il4965_rs_rate_scale_perform(struct il_priv *il,
 		 * continuing to use the setup that we've been trying. */
 		if (window->average_tpt > lq_sta->last_tpt) {
 
-			IL_DEBUG_RATE(il, "LQ: SWITCHING TO NEW TABLE "
+			D_RATE("LQ: SWITCHING TO NEW TABLE "
 					"suc=%d cur-tpt=%d old-tpt=%d\n",
 					window->success_ratio,
 					window->average_tpt,
@@ -1938,7 +1938,7 @@ static void il4965_rs_rate_scale_perform(struct il_priv *il,
 		/* Else poor success; go back to mode in "active" table */
 		} else {
 
-			IL_DEBUG_RATE(il, "LQ: GOING BACK TO THE OLD TABLE "
+			D_RATE("LQ: GOING BACK TO THE OLD TABLE "
 					"suc=%d cur-tpt=%d old-tpt=%d\n",
 					window->success_ratio,
 					window->average_tpt,
@@ -1992,7 +1992,7 @@ static void il4965_rs_rate_scale_perform(struct il_priv *il,
 
 	/* Too many failures, decrease rate */
 	if ((sr <= IL_RATE_DECREASE_TH) || (current_tpt == 0)) {
-		IL_DEBUG_RATE(il,
+		D_RATE(
 			"decrease rate because of low success_ratio\n");
 		scale_action = -1;
 
@@ -2031,7 +2031,7 @@ static void il4965_rs_rate_scale_perform(struct il_priv *il,
 		} else if (low_tpt != IL_INVALID_VALUE) {
 			/* Lower rate has better throughput */
 			if (low_tpt > current_tpt) {
-				IL_DEBUG_RATE(il,
+				D_RATE(
 				    "decrease rate because of low tpt\n");
 				scale_action = -1;
 			} else if (sr >= IL_RATE_INCREASE_TH) {
@@ -2070,7 +2070,7 @@ static void il4965_rs_rate_scale_perform(struct il_priv *il,
 		break;
 	}
 
-	IL_DEBUG_RATE(il, "choose rate scale index %d action %d low %d "
+	D_RATE("choose rate scale index %d action %d low %d "
 		    "high %d type %d\n",
 		     index, scale_action, low, high, tbl->lq_type);
 
@@ -2118,7 +2118,7 @@ lq_update:
 			/* Use new "search" start rate */
 			index = il4965_hwrate_to_plcp_idx(tbl->current_rate);
 
-			IL_DEBUG_RATE(il,
+			D_RATE(
 				"Switch current  mcs: %X index: %d\n",
 				     tbl->current_rate, index);
 			il4965_rs_fill_link_cmd(il, lq_sta,
@@ -2138,7 +2138,7 @@ lq_update:
 		tbl1 = &(lq_sta->lq_info[lq_sta->active_tbl]);
 		if (is_legacy(tbl1->lq_type) && !conf_is_ht(conf) &&
 		    lq_sta->action_counter > tbl1->max_search) {
-			IL_DEBUG_RATE(il, "LQ: STAY in legacy table\n");
+			D_RATE("LQ: STAY in legacy table\n");
 			il4965_rs_set_stay_in_table(il, 1, lq_sta);
 		}
 
@@ -2153,7 +2153,7 @@ lq_update:
 				tid_data =
 				   &il->stations[lq_sta->lq.sta_id].tid[tid];
 				if (tid_data->agg.state == IL_AGG_OFF) {
-					IL_DEBUG_RATE(il,
+					D_RATE(
 						       "try to aggregate tid %d\n",
 						       tid);
 					il4965_rs_tl_turn_on_agg(il, tid,
@@ -2251,7 +2251,7 @@ il4965_rs_get_rate(void *il_r, struct ieee80211_sta *sta, void *il_sta,
 	struct il_lq_sta *lq_sta = il_sta;
 	int rate_idx;
 
-	IL_DEBUG_RATE(il, "rate scale calculate new rate for skb\n");
+	D_RATE("rate scale calculate new rate for skb\n");
 
 	/* Get max rate if user set max rate */
 	if (lq_sta) {
@@ -2266,7 +2266,7 @@ il4965_rs_get_rate(void *il_r, struct ieee80211_sta *sta, void *il_sta,
 
 	/* Treat uninitialized rate scaling data same as non-existing. */
 	if (lq_sta && !lq_sta->drv) {
-		IL_DEBUG_RATE(il, "Rate scaling not initialized yet.\n");
+		D_RATE("Rate scaling not initialized yet.\n");
 		il_sta = NULL;
 	}
 
@@ -2323,7 +2323,7 @@ static void *il4965_rs_alloc_sta(void *il_rate, struct ieee80211_sta *sta,
 	struct il_priv *il;
 
 	il = (struct il_priv *)il_rate;
-	IL_DEBUG_RATE(il, "create station rate scale window\n");
+	D_RATE("create station rate scale window\n");
 
 	lq_sta = &sta_priv->lq_sta;
 
@@ -2365,7 +2365,7 @@ il4965_rs_rate_init(struct il_priv *il,
 			il4965_rs_rate_scale_clear_window(
 					&lq_sta->lq_info[j].win[i]);
 
-	IL_DEBUG_RATE(il, "LQ:"
+	D_RATE("LQ:"
 			"*** rate scale station global init for station %d ***\n",
 		       sta_id);
 	/* TODO: what is a good starting rate for STA? About middle? Maybe not
@@ -2561,8 +2561,8 @@ static void il4965_rs_free_sta(void *il_r, struct ieee80211_sta *sta,
 {
 	struct il_priv *il __maybe_unused = il_r;
 
-	IL_DEBUG_RATE(il, "enter\n");
-	IL_DEBUG_RATE(il, "leave\n");
+	D_RATE("enter\n");
+	D_RATE("leave\n");
 }
 
 
@@ -2587,16 +2587,16 @@ static void il4965_rs_dbgfs_set_mcs(struct il_lq_sta *lq_sta,
 		  >> RATE_MCS_ANT_POS);
 		if ((valid_tx_ant & ant_sel_tx) == ant_sel_tx) {
 			*rate_n_flags = lq_sta->dbg_fixed_rate;
-			IL_DEBUG_RATE(il, "Fixed rate ON\n");
+			D_RATE("Fixed rate ON\n");
 		} else {
 			lq_sta->dbg_fixed_rate = 0;
 			IL_ERR(il,
 			    "Invalid antenna selection 0x%X, Valid is 0x%X\n",
 			    ant_sel_tx, valid_tx_ant);
-			IL_DEBUG_RATE(il, "Fixed rate OFF\n");
+			D_RATE("Fixed rate OFF\n");
 		}
 	} else {
-		IL_DEBUG_RATE(il, "Fixed rate OFF\n");
+		D_RATE("Fixed rate OFF\n");
 	}
 }
 
@@ -2627,7 +2627,7 @@ static ssize_t il4965_rs_sta_dbgfs_scale_table_write(struct file *file,
 	lq_sta->active_siso_rate   = 0x1FD0;	/* 6 - 60 MBits, no 9, no CCK */
 	lq_sta->active_mimo2_rate  = 0x1FD0;	/* 6 - 60 MBits, no 9, no CCK */
 
-	IL_DEBUG_RATE(il, "sta_id %d rate 0x%X\n",
+	D_RATE("sta_id %d rate 0x%X\n",
 		lq_sta->lq.sta_id, lq_sta->dbg_fixed_rate);
 
 	if (lq_sta->dbg_fixed_rate) {
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-rx.c b/drivers/net/wireless/iwlegacy/iwl-4965-rx.c
index c987c80..45e8a24 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-rx.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-rx.c
@@ -51,7 +51,7 @@ void il4965_rx_missed_beacon_notif(struct il_priv *il,
 	missed_beacon = &pkt->u.missed_beacon;
 	if (le32_to_cpu(missed_beacon->consecutive_missed_beacons) >
 	    il->missed_beacon_threshold) {
-		IL_DEBUG_CALIB(il,
+		D_CALIB(
 		    "missed bcn cnsq %d totl %d rcd %d expctd %d\n",
 		    le32_to_cpu(missed_beacon->consecutive_missed_beacons),
 		    le32_to_cpu(missed_beacon->total_missed_becons),
@@ -100,7 +100,7 @@ static void il4965_rx_calc_noise(struct il_priv *il)
 	else
 		last_rx_noise = IL_NOISE_MEAS_NOT_AVAILABLE;
 
-	IL_DEBUG_CALIB(il, "inband silence a %u, b %u, c %u, dBm %d\n",
+	D_CALIB("inband silence a %u, b %u, c %u, dBm %d\n",
 			bcn_silence_a, bcn_silence_b, bcn_silence_c,
 			last_rx_noise);
 }
@@ -157,7 +157,7 @@ void il4965_rx_statistics(struct il_priv *il,
 	int change;
 	struct il_rx_packet *pkt = rxb_addr(rxb);
 
-	IL_DEBUG_RX(il,
+	D_RX(
 		     "Statistics notification received (%d vs %d).\n",
 		     (int)sizeof(struct il_notif_statistics),
 		     le32_to_cpu(pkt->len_n_flags) &
@@ -209,7 +209,7 @@ void il4965_reply_statistics(struct il_priv *il,
 		memset(&il->_4965.max_delta, 0,
 			sizeof(struct il_notif_statistics));
 #endif
-		IL_DEBUG_RX(il, "Statistics have been cleared\n");
+		D_RX("Statistics have been cleared\n");
 	}
 	il4965_rx_statistics(il, rxb);
 }
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-sta.c b/drivers/net/wireless/iwlegacy/iwl-4965-sta.c
index 0fbc991..3019baf 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-sta.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-sta.c
@@ -199,18 +199,18 @@ int il4965_remove_default_wep_key(struct il_priv *il,
 
 	lockdep_assert_held(&il->mutex);
 
-	IL_DEBUG_WEP(il, "Removing default WEP key: idx=%d\n",
+	D_WEP("Removing default WEP key: idx=%d\n",
 		      keyconf->keyidx);
 
 	memset(&ctx->wep_keys[keyconf->keyidx], 0, sizeof(ctx->wep_keys[0]));
 	if (il_is_rfkill(il)) {
-		IL_DEBUG_WEP(il,
+		D_WEP(
 		"Not sending REPLY_WEPKEY command due to RFKILL.\n");
 		/* but keys in device are clear anyway so return success */
 		return 0;
 	}
 	ret = il4965_static_wepkey_cmd(il, ctx, 1);
-	IL_DEBUG_WEP(il, "Remove default WEP key: idx=%d ret=%d\n",
+	D_WEP("Remove default WEP key: idx=%d ret=%d\n",
 		      keyconf->keyidx, ret);
 
 	return ret;
@@ -226,7 +226,7 @@ int il4965_set_default_wep_key(struct il_priv *il,
 
 	if (keyconf->keylen != WEP_KEY_LEN_128 &&
 	    keyconf->keylen != WEP_KEY_LEN_64) {
-		IL_DEBUG_WEP(il, "Bad WEP key length %d\n", keyconf->keylen);
+		D_WEP("Bad WEP key length %d\n", keyconf->keylen);
 		return -EINVAL;
 	}
 
@@ -239,7 +239,7 @@ int il4965_set_default_wep_key(struct il_priv *il,
 							keyconf->keylen);
 
 	ret = il4965_static_wepkey_cmd(il, ctx, false);
-	IL_DEBUG_WEP(il, "Set default WEP key: len=%d idx=%d ret=%d\n",
+	D_WEP("Set default WEP key: len=%d idx=%d ret=%d\n",
 		keyconf->keylen, keyconf->keyidx, ret);
 
 	return ret;
@@ -453,7 +453,7 @@ int il4965_remove_dynamic_key(struct il_priv *il,
 	key_flags = le16_to_cpu(il->stations[sta_id].sta.key.key_flags);
 	keyidx = (key_flags >> STA_KEY_FLG_KEYID_POS) & 0x3;
 
-	IL_DEBUG_WEP(il, "Remove dynamic key: idx=%d sta=%d\n",
+	D_WEP("Remove dynamic key: idx=%d sta=%d\n",
 		      keyconf->keyidx, sta_id);
 
 	if (keyconf->keyidx != keyidx) {
@@ -488,7 +488,7 @@ int il4965_remove_dynamic_key(struct il_priv *il,
 	il->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
 
 	if (il_is_rfkill(il)) {
-		IL_DEBUG_WEP(il,
+		D_WEP(
 		 "Not sending REPLY_ADD_STA command because RFKILL enabled.\n");
 		spin_unlock_irqrestore(&il->sta_lock, flags);
 		return 0;
@@ -531,7 +531,7 @@ int il4965_set_dynamic_key(struct il_priv *il, struct il_rxon_context *ctx,
 		ret = -EINVAL;
 	}
 
-	IL_DEBUG_WEP(il,
+	D_WEP(
 		"Set dynamic key: cipher=%x len=%d idx=%d sta=%d ret=%d\n",
 		      keyconf->cipher, keyconf->keylen, keyconf->keyidx,
 		      sta_id, ret);
@@ -605,7 +605,7 @@ static int il4965_update_bcast_station(struct il_priv *il,
 	if (il->stations[sta_id].lq)
 		kfree(il->stations[sta_id].lq);
 	else
-		IL_DEBUG_INFO(il,
+		D_INFO(
 		"Bcast station rate scaling has not been initialized yet.\n");
 	il->stations[sta_id].lq = link_cmd;
 	spin_unlock_irqrestore(&il->sta_lock, flags);
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-tx.c b/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
index fcc938e..efc21be 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
@@ -235,13 +235,13 @@ static void il4965_tx_cmd_build_hwcrypto(struct il_priv *il,
 		memcpy(tx_cmd->key, keyconf->key, keyconf->keylen);
 		if (info->flags & IEEE80211_TX_CTL_AMPDU)
 			tx_cmd->tx_flags |= TX_CMD_FLG_AGG_CCMP_MSK;
-		IL_DEBUG_TX(il, "tx_cmd with AES hwcrypto\n");
+		D_TX("tx_cmd with AES hwcrypto\n");
 		break;
 
 	case WLAN_CIPHER_SUITE_TKIP:
 		tx_cmd->sec_ctl = TX_CMD_SEC_TKIP;
 		ieee80211_get_tkip_p2k(keyconf, skb_frag, tx_cmd->key);
-		IL_DEBUG_TX(il, "tx_cmd with tkip hwcrypto\n");
+		D_TX("tx_cmd with tkip hwcrypto\n");
 		break;
 
 	case WLAN_CIPHER_SUITE_WEP104:
@@ -253,7 +253,7 @@ static void il4965_tx_cmd_build_hwcrypto(struct il_priv *il,
 
 		memcpy(&tx_cmd->key[3], keyconf->key, keyconf->keylen);
 
-		IL_DEBUG_TX(il, "Configuring packet for WEP encryption "
+		D_TX("Configuring packet for WEP encryption "
 			     "with key %d\n", keyconf->keyidx);
 		break;
 
@@ -298,7 +298,7 @@ int il4965_tx_skb(struct il_priv *il, struct sk_buff *skb)
 
 	spin_lock_irqsave(&il->lock, flags);
 	if (il_is_rfkill(il)) {
-		IL_DEBUG_DROP(il, "Dropping - RF KILL\n");
+		D_DROP("Dropping - RF KILL\n");
 		goto drop_unlock;
 	}
 
@@ -306,11 +306,11 @@ int il4965_tx_skb(struct il_priv *il, struct sk_buff *skb)
 
 #ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
 	if (ieee80211_is_auth(fc))
-		IL_DEBUG_TX(il, "Sending AUTH frame\n");
+		D_TX("Sending AUTH frame\n");
 	else if (ieee80211_is_assoc_req(fc))
-		IL_DEBUG_TX(il, "Sending ASSOC frame\n");
+		D_TX("Sending ASSOC frame\n");
 	else if (ieee80211_is_reassoc_req(fc))
-		IL_DEBUG_TX(il, "Sending REASSOC frame\n");
+		D_TX("Sending REASSOC frame\n");
 #endif
 
 	hdr_len = ieee80211_hdrlen(fc);
@@ -323,13 +323,13 @@ int il4965_tx_skb(struct il_priv *il, struct sk_buff *skb)
 		sta_id = il_sta_id_or_broadcast(il, ctx, info->control.sta);
 
 		if (sta_id == IL_INVALID_STATION) {
-			IL_DEBUG_DROP(il, "Dropping - INVALID STATION: %pM\n",
+			D_DROP("Dropping - INVALID STATION: %pM\n",
 				       hdr->addr1);
 			goto drop_unlock;
 		}
 	}
 
-	IL_DEBUG_TX(il, "station Id %d\n", sta_id);
+	D_TX("station Id %d\n", sta_id);
 
 	if (sta)
 		sta_priv = (void *)sta->drv_priv;
@@ -499,9 +499,9 @@ int il4965_tx_skb(struct il_priv *il, struct sk_buff *skb)
 	tx_cmd->dram_lsb_ptr = cpu_to_le32(scratch_phys);
 	tx_cmd->dram_msb_ptr = il_get_dma_hi_addr(scratch_phys);
 
-	IL_DEBUG_TX(il, "sequence nr = 0X%x\n",
+	D_TX("sequence nr = 0X%x\n",
 		     le16_to_cpu(out_cmd->hdr.sequence));
-	IL_DEBUG_TX(il, "tx_flags = 0X%x\n", le32_to_cpu(tx_cmd->tx_flags));
+	D_TX("tx_flags = 0X%x\n", le32_to_cpu(tx_cmd->tx_flags));
 	il_print_hex_dump(il, IL_DL_TX, (u8 *)tx_cmd, sizeof(*tx_cmd));
 	il_print_hex_dump(il, IL_DL_TX, (u8 *)tx_cmd->hdr, hdr_len);
 
@@ -909,11 +909,11 @@ int il4965_tx_agg_start(struct il_priv *il, struct ieee80211_vif *vif,
 	spin_lock_irqsave(&il->sta_lock, flags);
 	tid_data = &il->stations[sta_id].tid[tid];
 	if (tid_data->tfds_in_queue == 0) {
-		IL_DEBUG_HT(il, "HW queue is empty\n");
+		D_HT("HW queue is empty\n");
 		tid_data->agg.state = IL_AGG_ON;
 		ieee80211_start_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 	} else {
-		IL_DEBUG_HT(il,
+		D_HT(
 			"HW queue is NOT empty: %d packets in HW queue\n",
 			     tid_data->tfds_in_queue);
 		tid_data->agg.state = IL_EMPTYING_HW_QUEUE_ADDBA;
@@ -991,7 +991,7 @@ int il4965_tx_agg_stop(struct il_priv *il, struct ieee80211_vif *vif,
 		 * queue we selected previously, i.e. before the
 		 * session was really started completely.
 		 */
-		IL_DEBUG_HT(il, "AGG stop before setup done\n");
+		D_HT("AGG stop before setup done\n");
 		goto turn_off;
 	case IL_AGG_ON:
 		break;
@@ -1004,14 +1004,14 @@ int il4965_tx_agg_stop(struct il_priv *il, struct ieee80211_vif *vif,
 
 	/* The queue is not empty */
 	if (write_ptr != read_ptr) {
-		IL_DEBUG_HT(il, "Stopping a non empty AGG HW QUEUE\n");
+		D_HT("Stopping a non empty AGG HW QUEUE\n");
 		il->stations[sta_id].tid[tid].agg.state =
 				IL_EMPTYING_HW_QUEUE_DELBA;
 		spin_unlock_irqrestore(&il->sta_lock, flags);
 		return 0;
 	}
 
-	IL_DEBUG_HT(il, "HW queue is empty\n");
+	D_HT("HW queue is empty\n");
  turn_off:
 	il->stations[sta_id].tid[tid].agg.state = IL_AGG_OFF;
 
@@ -1054,7 +1054,7 @@ int il4965_txq_check_empty(struct il_priv *il,
 		    (q->read_ptr == q->write_ptr)) {
 			u16 ssn = SEQ_TO_SN(tid_data->seq_number);
 			int tx_fifo = il4965_get_fifo_from_tid(ctx, tid);
-			IL_DEBUG_HT(il,
+			D_HT(
 				"HW queue empty: continue DELBA flow\n");
 			il4965_txq_agg_disable(il, txq_id, ssn, tx_fifo);
 			tid_data->agg.state = IL_AGG_OFF;
@@ -1064,7 +1064,7 @@ int il4965_txq_check_empty(struct il_priv *il,
 	case IL_EMPTYING_HW_QUEUE_ADDBA:
 		/* We are reclaiming the last packet of the queue */
 		if (tid_data->tfds_in_queue == 0) {
-			IL_DEBUG_HT(il,
+			D_HT(
 				"HW queue empty: continue ADDBA flow\n");
 			tid_data->agg.state = IL_AGG_ON;
 			ieee80211_start_tx_ba_cb_irqsafe(ctx->vif, addr, tid);
@@ -1169,7 +1169,7 @@ static int il4965_tx_status_reply_compressed_ba(struct il_priv *il,
 
 	/* Mark that the expected block-ack response arrived */
 	agg->wait_for_ba = 0;
-	IL_DEBUG_TX_REPLY(il, "BA %d %d\n", agg->start_idx,
+	D_TX_REPLY("BA %d %d\n", agg->start_idx,
 							ba_resp->seq_ctl);
 
 	/* Calculate shift to align block-ack bits with our Tx window bits */
@@ -1178,7 +1178,7 @@ static int il4965_tx_status_reply_compressed_ba(struct il_priv *il,
 		sh += 0x100;
 
 	if (agg->frame_count > (64 - sh)) {
-		IL_DEBUG_TX_REPLY(il, "more frames than bitmap size");
+		D_TX_REPLY("more frames than bitmap size");
 		return -1;
 	}
 
@@ -1195,7 +1195,7 @@ static int il4965_tx_status_reply_compressed_ba(struct il_priv *il,
 	while (sent_bitmap) {
 		ack = sent_bitmap & 1ULL;
 		successes += ack;
-		IL_DEBUG_TX_REPLY(il, "%s ON i=%d idx=%d raw=%d\n",
+		D_TX_REPLY("%s ON i=%d idx=%d raw=%d\n",
 			ack ? "ACK" : "NACK", i,
 			(agg->start_idx + i) & 0xff,
 			agg->start_idx + i);
@@ -1203,7 +1203,7 @@ static int il4965_tx_status_reply_compressed_ba(struct il_priv *il,
 		++i;
 	}
 
-	IL_DEBUG_TX_REPLY(il, "Bitmap %llx\n",
+	D_TX_REPLY("Bitmap %llx\n",
 				   (unsigned long long)bitmap);
 
 	info = IEEE80211_SKB_CB(il->txq[scd_flow].txb[agg->start_idx].skb);
@@ -1282,7 +1282,7 @@ void il4965_rx_reply_compressed_ba(struct il_priv *il,
 		 * since it is possible happen very often and in order
 		 * not to fill the syslog, don't enable the logging by default
 		 */
-		IL_DEBUG_TX_REPLY(il,
+		D_TX_REPLY(
 			"BA scd_flow %d does not match txq_id %d\n",
 			scd_flow, agg->txq_id);
 		return;
@@ -1293,12 +1293,12 @@ void il4965_rx_reply_compressed_ba(struct il_priv *il,
 
 	spin_lock_irqsave(&il->sta_lock, flags);
 
-	IL_DEBUG_TX_REPLY(il, "REPLY_COMPRESSED_BA [%d] Received from %pM, "
+	D_TX_REPLY("REPLY_COMPRESSED_BA [%d] Received from %pM, "
 			   "sta_id = %d\n",
 			   agg->wait_for_ba,
 			   (u8 *) &ba_resp->sta_addr_lo32,
 			   ba_resp->sta_id);
-	IL_DEBUG_TX_REPLY(il, "TID = %d, SeqCtl = %d, bitmap = 0x%llx,"
+	D_TX_REPLY("TID = %d, SeqCtl = %d, bitmap = 0x%llx,"
 			"scd_flow = "
 			   "%d, scd_ssn = %d\n",
 			   ba_resp->tid,
@@ -1306,7 +1306,7 @@ void il4965_rx_reply_compressed_ba(struct il_priv *il,
 			   (unsigned long long)le64_to_cpu(ba_resp->bitmap),
 			   ba_resp->scd_flow,
 			   ba_resp->scd_ssn);
-	IL_DEBUG_TX_REPLY(il, "DAT start_idx = %d, bitmap = 0x%llx\n",
+	D_TX_REPLY("DAT start_idx = %d, bitmap = 0x%llx\n",
 			   agg->start_idx,
 			   (unsigned long long)agg->bitmap);
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-ucode.c b/drivers/net/wireless/iwlegacy/iwl-4965-ucode.c
index d4dc597..d1e1775 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-ucode.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-ucode.c
@@ -55,7 +55,7 @@ il4965_verify_inst_sparse(struct il_priv *il, __le32 *image, u32 len)
 	u32 errcnt = 0;
 	u32 i;
 
-	IL_DEBUG_INFO(il, "ucode inst image size is %u\n", len);
+	D_INFO("ucode inst image size is %u\n", len);
 
 	for (i = 0; i < len; i += 100, image += 100/sizeof(u32)) {
 		/* read data comes through single port, auto-incr addr */
@@ -87,7 +87,7 @@ static int il4965_verify_inst_full(struct il_priv *il, __le32 *image,
 	int ret = 0;
 	u32 errcnt;
 
-	IL_DEBUG_INFO(il, "ucode inst image size is %u\n", len);
+	D_INFO("ucode inst image size is %u\n", len);
 
 	il_write_direct32(il, HBUS_TARG_MEM_RADDR,
 			   IWL4965_RTC_INST_LOWER_BOUND);
@@ -110,7 +110,7 @@ static int il4965_verify_inst_full(struct il_priv *il, __le32 *image,
 	}
 
 	if (!errcnt)
-		IL_DEBUG_INFO(il,
+		D_INFO(
 		    "ucode image in INSTRUCTION memory is good\n");
 
 	return ret;
@@ -131,7 +131,7 @@ int il4965_verify_ucode(struct il_priv *il)
 	len = il->ucode_boot.len;
 	ret = il4965_verify_inst_sparse(il, image, len);
 	if (!ret) {
-		IL_DEBUG_INFO(il, "Bootstrap uCode is good in inst SRAM\n");
+		D_INFO("Bootstrap uCode is good in inst SRAM\n");
 		return 0;
 	}
 
@@ -140,7 +140,7 @@ int il4965_verify_ucode(struct il_priv *il)
 	len = il->ucode_init.len;
 	ret = il4965_verify_inst_sparse(il, image, len);
 	if (!ret) {
-		IL_DEBUG_INFO(il, "Initialize uCode is good in inst SRAM\n");
+		D_INFO("Initialize uCode is good in inst SRAM\n");
 		return 0;
 	}
 
@@ -149,7 +149,7 @@ int il4965_verify_ucode(struct il_priv *il)
 	len = il->ucode_code.len;
 	ret = il4965_verify_inst_sparse(il, image, len);
 	if (!ret) {
-		IL_DEBUG_INFO(il, "Runtime uCode is good in inst SRAM\n");
+		D_INFO("Runtime uCode is good in inst SRAM\n");
 		return 0;
 	}
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965.c b/drivers/net/wireless/iwlegacy/iwl-4965.c
index 01fa6c8..cc28e0e 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965.c
@@ -69,7 +69,7 @@ static int il4965_verify_bsm(struct il_priv *il)
 	u32 reg;
 	u32 val;
 
-	IL_DEBUG_INFO(il, "Begin verify bsm\n");
+	D_INFO("Begin verify bsm\n");
 
 	/* verify BSM SRAM contents */
 	val = il_read_prph(il, BSM_WR_DWCOUNT_REG);
@@ -87,7 +87,7 @@ static int il4965_verify_bsm(struct il_priv *il)
 		}
 	}
 
-	IL_DEBUG_INFO(il, "BSM bootstrap uCode image OK\n");
+	D_INFO("BSM bootstrap uCode image OK\n");
 
 	return 0;
 }
@@ -137,7 +137,7 @@ static int il4965_load_bsm(struct il_priv *il)
 	u32 reg_offset;
 	int ret;
 
-	IL_DEBUG_INFO(il, "Begin load bsm\n");
+	D_INFO("Begin load bsm\n");
 
 	il->ucode_type = UCODE_RT;
 
@@ -189,7 +189,7 @@ static int il4965_load_bsm(struct il_priv *il)
 		udelay(10);
 	}
 	if (i < 100)
-		IL_DEBUG_INFO(il, "BSM write complete, poll %d iterations\n", i);
+		D_INFO("BSM write complete, poll %d iterations\n", i);
 	else {
 		IL_ERR(il, "BSM write did not complete!\n");
 		return -EIO;
@@ -233,7 +233,7 @@ static int il4965_set_ucode_ptrs(struct il_priv *il)
 	 *   that all new ptr/size info is in place */
 	il_write_prph(il, BSM_DRAM_INST_BYTECOUNT_REG,
 				 il->ucode_code.len | BSM_DRAM_INST_LOAD);
-	IL_DEBUG_INFO(il, "Runtime uCode pointers are set.\n");
+	D_INFO("Runtime uCode pointers are set.\n");
 
 	return ret;
 }
@@ -257,7 +257,7 @@ static void il4965_init_alive_start(struct il_priv *il)
 	if (il4965_verify_ucode(il)) {
 		/* Runtime instruction load was bad;
 		 * take it all the way back down so we can try again */
-		IL_DEBUG_INFO(il, "Bad \"initialize\" uCode load.\n");
+		D_INFO("Bad \"initialize\" uCode load.\n");
 		goto restart;
 	}
 
@@ -267,11 +267,11 @@ static void il4965_init_alive_start(struct il_priv *il)
 	/* Send pointers to protocol/runtime uCode image ... init code will
 	 * load and launch runtime uCode, which will send us another "Alive"
 	 * notification. */
-	IL_DEBUG_INFO(il, "Initialization Alive received.\n");
+	D_INFO("Initialization Alive received.\n");
 	if (il4965_set_ucode_ptrs(il)) {
 		/* Runtime instruction load won't happen;
 		 * take it all the way back down so we can try again */
-		IL_DEBUG_INFO(il, "Couldn't set up uCode pointers.\n");
+		D_INFO("Couldn't set up uCode pointers.\n");
 		goto restart;
 	}
 	return;
@@ -346,7 +346,7 @@ static void il4965_chain_noise_reset(struct il_priv *il)
 			IL_ERR(il,
 				"Could not send REPLY_PHY_CALIBRATION_CMD\n");
 		data->state = IL_CHAIN_NOISE_ACCUMULATE;
-		IL_DEBUG_CALIB(il, "Run chain_noise_calibrate\n");
+		D_CALIB("Run chain_noise_calibrate\n");
 	}
 }
 
@@ -556,7 +556,7 @@ static int il4965_interpolate_chan(struct il_priv *il, u32 channel,
 	ch_i2 = il->calib_info->band_info[s].ch2.ch_num;
 	chan_info->ch_num = (u8) channel;
 
-	IL_DEBUG_TXPOWER(il, "channel %d subband %d factory cal ch %d & %d\n",
+	D_TXPOWER("channel %d subband %d factory cal ch %d & %d\n",
 			  channel, s, ch_i1, ch_i2);
 
 	for (c = 0; c < EEPROM_TX_POWER_TX_CHAINS; c++) {
@@ -586,16 +586,16 @@ static int il4965_interpolate_chan(struct il_priv *il, u32 channel,
 							   m1->pa_det, ch_i2,
 							   m2->pa_det);
 
-			IL_DEBUG_TXPOWER(il,
+			D_TXPOWER(
 				"chain %d meas %d AP1=%d AP2=%d AP=%d\n", c, m,
 				m1->actual_pow, m2->actual_pow, omeas->actual_pow);
-			IL_DEBUG_TXPOWER(il,
+			D_TXPOWER(
 				"chain %d meas %d NI1=%d NI2=%d NI=%d\n", c, m,
 				m1->gain_idx, m2->gain_idx, omeas->gain_idx);
-			IL_DEBUG_TXPOWER(il,
+			D_TXPOWER(
 				"chain %d meas %d PA1=%d PA2=%d PA=%d\n", c, m,
 				m1->pa_det, m2->pa_det, omeas->pa_det);
-			IL_DEBUG_TXPOWER(il,
+			D_TXPOWER(
 				"chain %d meas %d  T1=%d  T2=%d  T=%d\n", c, m,
 				m1->temperature, m2->temperature,
 				omeas->temperature);
@@ -900,7 +900,7 @@ static int il4965_fill_txpower_tbl(struct il_priv *il, u8 band, u16 channel,
 	user_target_power = 2 * il->tx_power_user_lmt;
 
 	/* Get current (RXON) channel, band, width */
-	IL_DEBUG_TXPOWER(il, "chan %d band %d is_ht40 %d\n", channel, band,
+	D_TXPOWER("chan %d band %d is_ht40 %d\n", channel, band,
 			  is_ht40);
 
 	ch_info = il_get_channel_info(il, il->band, channel);
@@ -917,7 +917,7 @@ static int il4965_fill_txpower_tbl(struct il_priv *il, u8 band, u16 channel,
 		return txatten_grp;
 	}
 
-	IL_DEBUG_TXPOWER(il, "channel %d belongs to txatten group %d\n",
+	D_TXPOWER("channel %d belongs to txatten group %d\n",
 			  channel, txatten_grp);
 
 	if (is_ht40) {
@@ -967,7 +967,7 @@ static int il4965_fill_txpower_tbl(struct il_priv *il, u8 band, u16 channel,
 	voltage_compensation =
 	    il4965_get_voltage_compensation(voltage, init_voltage);
 
-	IL_DEBUG_TXPOWER(il, "curr volt %d eeprom volt %d volt comp %d\n",
+	D_TXPOWER("curr volt %d eeprom volt %d volt comp %d\n",
 			  init_voltage,
 			  voltage, voltage_compensation);
 
@@ -998,13 +998,13 @@ static int il4965_fill_txpower_tbl(struct il_priv *il, u8 band, u16 channel,
 		factory_gain_index[c] = measurement->gain_idx;
 		factory_actual_pwr[c] = measurement->actual_pow;
 
-		IL_DEBUG_TXPOWER(il, "chain = %d\n", c);
-		IL_DEBUG_TXPOWER(il, "fctry tmp %d, "
+		D_TXPOWER("chain = %d\n", c);
+		D_TXPOWER("fctry tmp %d, "
 				  "curr tmp %d, comp %d steps\n",
 				  factory_temp, current_temp,
 				  temperature_comp[c]);
 
-		IL_DEBUG_TXPOWER(il, "fctry idx %d, fctry pwr %d\n",
+		D_TXPOWER("fctry idx %d, fctry pwr %d\n",
 				  factory_gain_index[c],
 				  factory_actual_pwr[c]);
 	}
@@ -1037,7 +1037,7 @@ static int il4965_fill_txpower_tbl(struct il_priv *il, u8 band, u16 channel,
 		if (target_power > power_limit)
 			target_power = power_limit;
 
-		IL_DEBUG_TXPOWER(il, "rate %d sat %d reg %d usr %d tgt %d\n",
+		D_TXPOWER("rate %d sat %d reg %d usr %d tgt %d\n",
 				  i, saturation_power - back_off_table[i],
 				  current_regulatory, user_target_power,
 				  target_power);
@@ -1061,7 +1061,7 @@ static int il4965_fill_txpower_tbl(struct il_priv *il, u8 band, u16 channel,
 					    voltage_compensation +
 					    atten_value);
 
-/*			IL_DEBUG_TXPOWER(il, "calculated txpower index %d\n",
+/*			D_TXPOWER("calculated txpower index %d\n",
 						power_index); */
 
 			if (power_index < get_min_power_index(i, band))
@@ -1094,7 +1094,7 @@ static int il4965_fill_txpower_tbl(struct il_priv *il, u8 band, u16 channel,
 			tx_power.s.dsp_predis_atten[c] =
 				gain_table[band][power_index].dsp;
 
-			IL_DEBUG_TXPOWER(il, "chain %d mimo %d index %d "
+			D_TXPOWER("chain %d mimo %d index %d "
 					  "gain 0x%02x dsp %d\n",
 					  c, atten_value, power_index,
 					tx_power.s.radio_tx_gain[c],
@@ -1167,7 +1167,7 @@ static int il4965_send_rxon_assoc(struct il_priv *il,
 	     rxon2->ofdm_ht_dual_stream_basic_rates) &&
 	    (rxon1->rx_chain == rxon2->rx_chain) &&
 	    (rxon1->ofdm_basic_rates == rxon2->ofdm_basic_rates)) {
-		IL_DEBUG_INFO(il, "Using current RXON_ASSOC.  Not resending.\n");
+		D_INFO("Using current RXON_ASSOC.  Not resending.\n");
 		return 0;
 	}
 
@@ -1217,7 +1217,7 @@ static int il4965_commit_rxon(struct il_priv *il, struct il_rxon_context *ctx)
 	 */
 	if (test_bit(STATUS_CHANNEL_SWITCH_PENDING, &il->status) &&
 	    (il->switch_channel != ctx->staging.channel)) {
-		IL_DEBUG_11H(il, "abort channel switch on %d\n",
+		D_11H("abort channel switch on %d\n",
 		      le16_to_cpu(il->switch_channel));
 		il_chswitch_done(il, false);
 	}
@@ -1247,7 +1247,7 @@ static int il4965_commit_rxon(struct il_priv *il, struct il_rxon_context *ctx)
 	 * we must clear the associated from the active configuration
 	 * before we apply the new config */
 	if (il_is_associated_ctx(ctx) && new_assoc) {
-		IL_DEBUG_INFO(il, "Toggling associated bit on current RXON\n");
+		D_INFO("Toggling associated bit on current RXON\n");
 		active_rxon->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 
 		ret = il_send_cmd_pdu(il, ctx->rxon_cmd,
@@ -1270,7 +1270,7 @@ static int il4965_commit_rxon(struct il_priv *il, struct il_rxon_context *ctx)
 		}
 	}
 
-	IL_DEBUG_INFO(il, "Sending RXON\n"
+	D_INFO("Sending RXON\n"
 		       "* with%s RXON_FILTER_ASSOC_MSK\n"
 		       "* channel = %d\n"
 		       "* bssid = %pM\n",
@@ -1292,7 +1292,7 @@ static int il4965_commit_rxon(struct il_priv *il, struct il_rxon_context *ctx)
 			IL_ERR(il, "Error setting new RXON (%d)\n", ret);
 			return ret;
 		}
-		IL_DEBUG_INFO(il, "Return from !new_assoc RXON.\n");
+		D_INFO("Return from !new_assoc RXON.\n");
 		memcpy(active_rxon, &ctx->staging, sizeof(*active_rxon));
 		il_clear_ucode_stations(il, ctx);
 		il_restore_stations(il, ctx);
@@ -1387,7 +1387,7 @@ static int il4965_hw_channel_switch(struct il_priv *il,
 						      ucode_switch_time,
 						      beacon_interval);
 	}
-	IL_DEBUG_11H(il, "uCode time for the switch is 0x%x\n",
+	D_11H("uCode time for the switch is 0x%x\n",
 		      cmd.switch_time);
 	ch_info = il_get_channel_info(il, il->band, ch);
 	if (ch_info)
@@ -1401,7 +1401,7 @@ static int il4965_hw_channel_switch(struct il_priv *il,
 	rc = il4965_fill_txpower_tbl(il, band, ch, is_ht40,
 				      ctrl_chan_high, &cmd.tx_power);
 	if (rc) {
-		IL_DEBUG_11H(il, "error:%d  fill txpower_tbl\n", rc);
+		D_11H("error:%d  fill txpower_tbl\n", rc);
 		return rc;
 	}
 
@@ -1450,13 +1450,13 @@ static int il4965_hw_get_temperature(struct il_priv *il)
 	if (test_bit(STATUS_TEMPERATURE, &il->status) &&
 	    (il->_4965.statistics.flag &
 			STATISTICS_REPLY_FLG_HT40_MODE_MSK)) {
-		IL_DEBUG_TEMP(il, "Running HT40 temperature calibration\n");
+		D_TEMP("Running HT40 temperature calibration\n");
 		R1 = (s32)le32_to_cpu(il->card_alive_init.therm_r1[1]);
 		R2 = (s32)le32_to_cpu(il->card_alive_init.therm_r2[1]);
 		R3 = (s32)le32_to_cpu(il->card_alive_init.therm_r3[1]);
 		R4 = le32_to_cpu(il->card_alive_init.therm_r4[1]);
 	} else {
-		IL_DEBUG_TEMP(il, "Running temperature calibration\n");
+		D_TEMP("Running temperature calibration\n");
 		R1 = (s32)le32_to_cpu(il->card_alive_init.therm_r1[0]);
 		R2 = (s32)le32_to_cpu(il->card_alive_init.therm_r2[0]);
 		R3 = (s32)le32_to_cpu(il->card_alive_init.therm_r3[0]);
@@ -1476,7 +1476,7 @@ static int il4965_hw_get_temperature(struct il_priv *il)
 		vt = sign_extend32(le32_to_cpu(il->_4965.statistics.
 				 general.common.temperature), 23);
 
-	IL_DEBUG_TEMP(il, "Calib values R[1-3]: %d %d %d R4: %d\n", R1, R2, R3, vt);
+	D_TEMP("Calib values R[1-3]: %d %d %d R4: %d\n", R1, R2, R3, vt);
 
 	if (R3 == R1) {
 		IL_ERR(il, "Calibration conflict R1 == R3\n");
@@ -1489,7 +1489,7 @@ static int il4965_hw_get_temperature(struct il_priv *il)
 	temperature /= (R3 - R1);
 	temperature = (temperature * 97) / 100 + TEMPERATURE_CALIB_KELVIN_OFFSET;
 
-	IL_DEBUG_TEMP(il, "Calibrated temperature: %dK, %dC\n",
+	D_TEMP("Calibrated temperature: %dK, %dC\n",
 			temperature, KELVIN_TO_CELSIUS(temperature));
 
 	return temperature;
@@ -1512,7 +1512,7 @@ static int il4965_is_temp_calib_needed(struct il_priv *il)
 	int temp_diff;
 
 	if (!test_bit(STATUS_STATISTICS, &il->status)) {
-		IL_DEBUG_TEMP(il, "Temperature not updated -- no statistics.\n");
+		D_TEMP("Temperature not updated -- no statistics.\n");
 		return 0;
 	}
 
@@ -1520,19 +1520,19 @@ static int il4965_is_temp_calib_needed(struct il_priv *il)
 
 	/* get absolute value */
 	if (temp_diff < 0) {
-		IL_DEBUG_POWER(il, "Getting cooler, delta %d\n", temp_diff);
+		D_POWER("Getting cooler, delta %d\n", temp_diff);
 		temp_diff = -temp_diff;
 	} else if (temp_diff == 0)
-		IL_DEBUG_POWER(il, "Temperature unchanged\n");
+		D_POWER("Temperature unchanged\n");
 	else
-		IL_DEBUG_POWER(il, "Getting warmer, delta %d\n", temp_diff);
+		D_POWER("Getting warmer, delta %d\n", temp_diff);
 
 	if (temp_diff < IL_TEMPERATURE_THRESHOLD) {
-		IL_DEBUG_POWER(il, " => thermal txpower calib not needed\n");
+		D_POWER(" => thermal txpower calib not needed\n");
 		return 0;
 	}
 
-	IL_DEBUG_POWER(il, " => thermal txpower calib needed\n");
+	D_POWER(" => thermal txpower calib needed\n");
 
 	return 1;
 }
@@ -1547,12 +1547,12 @@ static void il4965_temperature_calib(struct il_priv *il)
 
 	if (il->temperature != temp) {
 		if (il->temperature)
-			IL_DEBUG_TEMP(il, "Temperature changed "
+			D_TEMP("Temperature changed "
 				       "from %dC to %dC\n",
 				       KELVIN_TO_CELSIUS(il->temperature),
 				       KELVIN_TO_CELSIUS(temp));
 		else
-			IL_DEBUG_TEMP(il, "Temperature "
+			D_TEMP("Temperature "
 				       "initialized to %dC\n",
 				       KELVIN_TO_CELSIUS(temp));
 	}
@@ -1617,7 +1617,7 @@ static int il4965_tx_status_reply_tx(struct il_priv *il,
 	int i, sh, idx;
 	u16 seq;
 	if (agg->wait_for_ba)
-		IL_DEBUG_TX_REPLY(il, "got tx response w/o block-ack\n");
+		D_TX_REPLY("got tx response w/o block-ack\n");
 
 	agg->frame_count = tx_resp->frame_count;
 	agg->start_idx = start_idx;
@@ -1630,7 +1630,7 @@ static int il4965_tx_status_reply_tx(struct il_priv *il,
 		status = le16_to_cpu(frame_status[0].status);
 		idx = start_idx;
 
-		IL_DEBUG_TX_REPLY(il, "FrameCnt = %d, StartIdx=%d idx=%d\n",
+		D_TX_REPLY("FrameCnt = %d, StartIdx=%d idx=%d\n",
 				   agg->frame_count, agg->start_idx, idx);
 
 		info = IEEE80211_SKB_CB(il->txq[txq_id].txb[idx].skb);
@@ -1639,9 +1639,9 @@ static int il4965_tx_status_reply_tx(struct il_priv *il,
 		info->flags |= il4965_tx_status_to_mac80211(status);
 		il4965_hwrate_to_tx_control(il, rate_n_flags, info);
 
-		IL_DEBUG_TX_REPLY(il, "1 Frame 0x%x failure :%d\n",
+		D_TX_REPLY("1 Frame 0x%x failure :%d\n",
 				    status & 0xff, tx_resp->failure_frame);
-		IL_DEBUG_TX_REPLY(il, "Rate Info rate_n_flags=%x\n", rate_n_flags);
+		D_TX_REPLY("Rate Info rate_n_flags=%x\n", rate_n_flags);
 
 		agg->wait_for_ba = 0;
 	} else {
@@ -1661,7 +1661,7 @@ static int il4965_tx_status_reply_tx(struct il_priv *il,
 				      AGG_TX_STATE_ABORT_MSK))
 				continue;
 
-			IL_DEBUG_TX_REPLY(il, "FrameCnt = %d, txq_id=%d idx=%d\n",
+			D_TX_REPLY("FrameCnt = %d, txq_id=%d idx=%d\n",
 					   agg->frame_count, txq_id, idx);
 
 			hdr = il_tx_queue_get_hdr(il, txq_id, idx);
@@ -1681,7 +1681,7 @@ static int il4965_tx_status_reply_tx(struct il_priv *il,
 				return -1;
 			}
 
-			IL_DEBUG_TX_REPLY(il, "AGG Frame i=%d idx %d seq=%d\n",
+			D_TX_REPLY("AGG Frame i=%d idx %d seq=%d\n",
 					   i, idx, SEQ_TO_SN(sc));
 
 			sh = idx - start;
@@ -1699,13 +1699,13 @@ static int il4965_tx_status_reply_tx(struct il_priv *il,
 				sh = 0;
 			}
 			bitmap |= 1ULL << sh;
-			IL_DEBUG_TX_REPLY(il, "start=%d bitmap=0x%llx\n",
+			D_TX_REPLY("start=%d bitmap=0x%llx\n",
 					   start, (unsigned long long)bitmap);
 		}
 
 		agg->bitmap = bitmap;
 		agg->start_idx = start;
-		IL_DEBUG_TX_REPLY(il, "Frames %d start_idx=%d bitmap=0x%llx\n",
+		D_TX_REPLY("Frames %d start_idx=%d bitmap=0x%llx\n",
 				   agg->frame_count, agg->start_idx,
 				   (unsigned long long)agg->bitmap);
 
@@ -1737,7 +1737,7 @@ static u8 il4965_find_station(struct il_priv *il, const u8 *addr)
 			goto out;
 		}
 
-	IL_DEBUG_ASSOC(il, "can not find STA %pM total %d\n",
+	D_ASSOC("can not find STA %pM total %d\n",
 			      addr, il->num_stations);
 
  out:
@@ -1830,7 +1830,7 @@ static void il4965_rx_reply_tx(struct il_priv *il,
 		if (txq->q.read_ptr != (scd_ssn & 0xff)) {
 			index = il_queue_dec_wrap(scd_ssn & 0xff,
 								txq->q.n_bd);
-			IL_DEBUG_TX_REPLY(il, "Retry scheduler reclaim scd_ssn "
+			D_TX_REPLY("Retry scheduler reclaim scd_ssn "
 					   "%d index %d\n", scd_ssn , index);
 			freed = il4965_tx_queue_reclaim(il, txq_id, index);
 			if (qc)
@@ -1849,7 +1849,7 @@ static void il4965_rx_reply_tx(struct il_priv *il,
 					le32_to_cpu(tx_resp->rate_n_flags),
 					info);
 
-		IL_DEBUG_TX_REPLY(il, "TXQ %d status %s (0x%08x) "
+		D_TX_REPLY("TXQ %d status %s (0x%08x) "
 				   "rate_n_flags 0x%x retries %d\n",
 				   txq_id,
 				   il4965_get_tx_fail_reason(status), status,
@@ -1860,7 +1860,7 @@ static void il4965_rx_reply_tx(struct il_priv *il,
 		if (qc && likely(sta_id != IL_INVALID_STATION))
 			il4965_free_tfds_in_queue(il, sta_id, tid, freed);
 		else if (sta_id == IL_INVALID_STATION)
-			IL_DEBUG_TX_REPLY(il, "Station not known\n");
+			D_TX_REPLY("Station not known\n");
 
 		if (il->mac80211_registered &&
 		    (il_queue_space(&txq->q) > txq->q.low_mark))
@@ -1882,7 +1882,7 @@ static void il4965_rx_beacon_notif(struct il_priv *il,
 	u8 rate __maybe_unused =
 		il4965_hw_get_rate(beacon->beacon_notify_hdr.rate_n_flags);
 
-	IL_DEBUG_RX(il, "beacon status %#x, retries:%d ibssmgr:%d "
+	D_RX("beacon status %#x, retries:%d ibssmgr:%d "
 		"tsf:0x%.8x%.8x rate:%d\n",
 		le32_to_cpu(beacon->beacon_notify_hdr.u.status) & TX_STATUS_MSK,
 		beacon->beacon_notify_hdr.failure_frame,
@@ -1955,7 +1955,7 @@ static void il4965_post_associate(struct il_priv *il)
 
 	ctx->staging.assoc_id = cpu_to_le16(vif->bss_conf.aid);
 
-	IL_DEBUG_ASSOC(il, "assoc id %d beacon interval %d\n",
+	D_ASSOC("assoc id %d beacon interval %d\n",
 			vif->bss_conf.aid, vif->bss_conf.beacon_int);
 
 	if (vif->bss_conf.use_short_preamble)
@@ -1972,7 +1972,7 @@ static void il4965_post_associate(struct il_priv *il)
 
 	il_commit_rxon(il, ctx);
 
-	IL_DEBUG_ASSOC(il, "Associated as %d to: %pM\n",
+	D_ASSOC("Associated as %d to: %pM\n",
 			vif->bss_conf.aid, ctx->active.bssid_addr);
 
 	switch (vif->type) {
diff --git a/drivers/net/wireless/iwlegacy/iwl-core.c b/drivers/net/wireless/iwlegacy/iwl-core.c
index a768e78..e6c7e9d 100644
--- a/drivers/net/wireless/iwlegacy/iwl-core.c
+++ b/drivers/net/wireless/iwlegacy/iwl-core.c
@@ -164,7 +164,7 @@ int il_init_geos(struct il_priv *il)
 
 	if (il->bands[IEEE80211_BAND_2GHZ].n_bitrates ||
 	    il->bands[IEEE80211_BAND_5GHZ].n_bitrates) {
-		IL_DEBUG_INFO(il, "Geography modes already initialized.\n");
+		D_INFO("Geography modes already initialized.\n");
 		set_bit(STATUS_GEO_CONFIGURED, &il->status);
 		return 0;
 	}
@@ -239,7 +239,7 @@ int il_init_geos(struct il_priv *il)
 			geo_ch->flags |= IEEE80211_CHAN_DISABLED;
 		}
 
-		IL_DEBUG_INFO(il, "Channel %d Freq=%d[%sGHz] %s flag=0x%X\n",
+		D_INFO("Channel %d Freq=%d[%sGHz] %s flag=0x%X\n",
 				ch->channel, geo_ch->center_freq,
 				il_is_channel_a_band(ch) ?  "5.2" : "2.4",
 				geo_ch->flags & IEEE80211_CHAN_DISABLED ?
@@ -396,7 +396,7 @@ il_send_rxon_timing(struct il_priv *il, struct il_rxon_context *ctx)
 
 	ctx->timing.dtim_period = vif ? (vif->bss_conf.dtim_period ?: 1) : 1;
 
-	IL_DEBUG_ASSOC(il,
+	D_ASSOC(
 			"beacon interval %d beacon timer %d beacon tim %d\n",
 			le16_to_cpu(ctx->timing.beacon_interval),
 			le32_to_cpu(ctx->timing.beacon_init_val),
@@ -512,13 +512,13 @@ int il_full_rxon_required(struct il_priv *il,
 
 #define CHK(cond)							\
 	if ((cond)) {							\
-		IL_DEBUG_INFO(il, "need full RXON - " #cond "\n");	\
+		D_INFO("need full RXON - " #cond "\n");	\
 		return 1;						\
 	}
 
 #define CHK_NEQ(c1, c2)						\
 	if ((c1) != (c2)) {					\
-		IL_DEBUG_INFO(il, "need full RXON - "	\
+		D_INFO("need full RXON - "	\
 			       #c1 " != " #c2 " - %d != %d\n",	\
 			       (c1), (c2));			\
 		return 1;					\
@@ -638,7 +638,7 @@ static void _il_set_rxon_ht(struct il_priv *il,
 	if (il->cfg->ops->hcmd->set_rxon_chain)
 		il->cfg->ops->hcmd->set_rxon_chain(il, ctx);
 
-	IL_DEBUG_ASSOC(il, "rxon flags 0x%X operation mode :0x%X "
+	D_ASSOC("rxon flags 0x%X operation mode :0x%X "
 			"extension channel offset 0x%x\n",
 			le32_to_cpu(rxon->flags), ctx->ht.protection,
 			ctx->ht.extension_chan_offset);
@@ -720,7 +720,7 @@ il_set_rxon_channel(struct il_priv *il, struct ieee80211_channel *ch,
 
 	il->band = band;
 
-	IL_DEBUG_INFO(il, "Staging channel set to %d [%d]\n", channel, band);
+	D_INFO("Staging channel set to %d [%d]\n", channel, band);
 
 	return 0;
 }
@@ -840,7 +840,7 @@ void il_set_rate(struct il_priv *il)
 			il->active_rate |= (1 << rate->hw_value);
 	}
 
-	IL_DEBUG_RATE(il, "Set active_rate = %0x\n", il->active_rate);
+	D_RATE("Set active_rate = %0x\n", il->active_rate);
 
 	for_each_context(il, ctx) {
 		ctx->staging.cck_basic_rates =
@@ -878,7 +878,7 @@ void il_rx_csa(struct il_priv *il, struct il_rx_mem_buffer *rxb)
 	if (!le32_to_cpu(csa->status) && csa->channel == il->switch_channel) {
 		rxon->channel = csa->channel;
 		ctx->staging.channel = csa->channel;
-		IL_DEBUG_11H(il, "CSA notif: channel %d\n",
+		D_11H("CSA notif: channel %d\n",
 			      le16_to_cpu(csa->channel));
 		il_chswitch_done(il, true);
 	} else {
@@ -895,21 +895,21 @@ void il_print_rx_config_cmd(struct il_priv *il,
 {
 	struct il_rxon_cmd *rxon = &ctx->staging;
 
-	IL_DEBUG_RADIO(il, "RX CONFIG:\n");
+	D_RADIO("RX CONFIG:\n");
 	il_print_hex_dump(il, IL_DL_RADIO, (u8 *) rxon, sizeof(*rxon));
-	IL_DEBUG_RADIO(il, "u16 channel: 0x%x\n",
+	D_RADIO("u16 channel: 0x%x\n",
 				le16_to_cpu(rxon->channel));
-	IL_DEBUG_RADIO(il, "u32 flags: 0x%08X\n", le32_to_cpu(rxon->flags));
-	IL_DEBUG_RADIO(il, "u32 filter_flags: 0x%08x\n",
+	D_RADIO("u32 flags: 0x%08X\n", le32_to_cpu(rxon->flags));
+	D_RADIO("u32 filter_flags: 0x%08x\n",
 				le32_to_cpu(rxon->filter_flags));
-	IL_DEBUG_RADIO(il, "u8 dev_type: 0x%x\n", rxon->dev_type);
-	IL_DEBUG_RADIO(il, "u8 ofdm_basic_rates: 0x%02x\n",
+	D_RADIO("u8 dev_type: 0x%x\n", rxon->dev_type);
+	D_RADIO("u8 ofdm_basic_rates: 0x%02x\n",
 			rxon->ofdm_basic_rates);
-	IL_DEBUG_RADIO(il, "u8 cck_basic_rates: 0x%02x\n",
+	D_RADIO("u8 cck_basic_rates: 0x%02x\n",
 				rxon->cck_basic_rates);
-	IL_DEBUG_RADIO(il, "u8[6] node_addr: %pM\n", rxon->node_addr);
-	IL_DEBUG_RADIO(il, "u8[6] bssid_addr: %pM\n", rxon->bssid_addr);
-	IL_DEBUG_RADIO(il, "u16 assoc_id: 0x%x\n",
+	D_RADIO("u8[6] node_addr: %pM\n", rxon->node_addr);
+	D_RADIO("u8[6] bssid_addr: %pM\n", rxon->bssid_addr);
+	D_RADIO("u16 assoc_id: 0x%x\n",
 				le16_to_cpu(rxon->assoc_id));
 }
 EXPORT_SYMBOL(il_print_rx_config_cmd);
@@ -944,7 +944,7 @@ void il_irq_handle_error(struct il_priv *il)
 	clear_bit(STATUS_READY, &il->status);
 
 	if (!test_bit(STATUS_EXIT_PENDING, &il->status)) {
-		IL_DEBUG(il, IL_DL_FW_ERRORS,
+		IL_DBG(IL_DL_FW_ERRORS,
 			  "Restarting adapter due to uCode error.\n");
 
 		if (il->cfg->mod_params->restart_fw)
@@ -965,14 +965,14 @@ static int il_apm_stop_master(struct il_priv *il)
 	if (ret)
 		IL_WARN(il, "Master Disable Timed Out, 100 usec\n");
 
-	IL_DEBUG_INFO(il, "stop master\n");
+	D_INFO("stop master\n");
 
 	return ret;
 }
 
 void il_apm_stop(struct il_priv *il)
 {
-	IL_DEBUG_INFO(il, "Stop card, put in low power state\n");
+	D_INFO("Stop card, put in low power state\n");
 
 	/* Stop device's DMA activity */
 	il_apm_stop_master(il);
@@ -1002,7 +1002,7 @@ int il_apm_init(struct il_priv *il)
 	int ret = 0;
 	u16 lctl;
 
-	IL_DEBUG_INFO(il, "Init card's basic functions\n");
+	D_INFO("Init card's basic functions\n");
 
 	/*
 	 * Use "set_bit" below rather than "write", to preserve any hardware
@@ -1047,12 +1047,12 @@ int il_apm_init(struct il_priv *il)
 			/* L1-ASPM enabled; disable(!) L0S  */
 			il_set_bit(il, CSR_GIO_REG,
 					CSR_GIO_REG_VAL_L0S_ENABLED);
-			IL_DEBUG_POWER(il, "L1 Enabled; Disabling L0S\n");
+			D_POWER("L1 Enabled; Disabling L0S\n");
 		} else {
 			/* L1-ASPM disabled; enable(!) L0S */
 			il_clear_bit(il, CSR_GIO_REG,
 					CSR_GIO_REG_VAL_L0S_ENABLED);
-			IL_DEBUG_POWER(il, "L1 Disabled; Enabling L0S\n");
+			D_POWER("L1 Disabled; Enabling L0S\n");
 		}
 	}
 
@@ -1076,7 +1076,7 @@ int il_apm_init(struct il_priv *il)
 			CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
 			CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
 	if (ret < 0) {
-		IL_DEBUG_INFO(il, "Failed to init the card\n");
+		D_INFO("Failed to init the card\n");
 		goto out;
 	}
 
@@ -1147,7 +1147,7 @@ int il_set_tx_power(struct il_priv *il, s8 tx_power, bool force)
 	defer = test_bit(STATUS_SCANNING, &il->status) ||
 		memcmp(&ctx->active, &ctx->staging, sizeof(ctx->staging));
 	if (defer && !force) {
-		IL_DEBUG_INFO(il, "Deferring tx power set\n");
+		D_INFO("Deferring tx power set\n");
 		return 0;
 	}
 
@@ -1179,7 +1179,7 @@ void il_send_bt_config(struct il_priv *il)
 	else
 		bt_cmd.flags = BT_COEX_ENABLE;
 
-	IL_DEBUG_INFO(il, "BT coex %s\n",
+	D_INFO("BT coex %s\n",
 		(bt_cmd.flags == BT_COEX_DISABLE) ? "disable" : "active");
 
 	if (il_send_cmd_pdu(il, REPLY_BT_CONFIG,
@@ -1212,7 +1212,7 @@ void il_rx_pm_sleep_notif(struct il_priv *il,
 #ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
 	struct il_rx_packet *pkt = rxb_addr(rxb);
 	struct il_sleep_notification *sleep = &(pkt->u.sleep_notif);
-	IL_DEBUG_RX(il, "sleep mode: %d, src: %d\n",
+	D_RX("sleep mode: %d, src: %d\n",
 		     sleep->pm_sleep_mode, sleep->pm_wakeup_src);
 #endif
 }
@@ -1223,7 +1223,7 @@ void il_rx_pm_debug_statistics_notif(struct il_priv *il,
 {
 	struct il_rx_packet *pkt = rxb_addr(rxb);
 	u32 len = le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
-	IL_DEBUG_RADIO(il, "Dumping %d bytes of unhandled "
+	D_RADIO("Dumping %d bytes of unhandled "
 			"notification for %s:\n", len,
 			il_get_cmd_string(pkt->hdr.cmd));
 	il_print_hex_dump(il, IL_DL_RADIO, pkt->u.raw, len);
@@ -1259,15 +1259,15 @@ int il_mac_conf_tx(struct ieee80211_hw *hw,
 	unsigned long flags;
 	int q;
 
-	IL_DEBUG_MAC80211(il, "enter\n");
+	D_MAC80211("enter\n");
 
 	if (!il_is_ready_rf(il)) {
-		IL_DEBUG_MAC80211(il, "leave - RF not ready\n");
+		D_MAC80211("leave - RF not ready\n");
 		return -EIO;
 	}
 
 	if (queue >= AC_NUM) {
-		IL_DEBUG_MAC80211(il, "leave - queue >= AC_NUM %d\n", queue);
+		D_MAC80211("leave - queue >= AC_NUM %d\n", queue);
 		return 0;
 	}
 
@@ -1289,7 +1289,7 @@ int il_mac_conf_tx(struct ieee80211_hw *hw,
 
 	spin_unlock_irqrestore(&il->lock, flags);
 
-	IL_DEBUG_MAC80211(il, "leave\n");
+	D_MAC80211("leave\n");
 	return 0;
 }
 EXPORT_SYMBOL(il_mac_conf_tx);
@@ -1348,7 +1348,7 @@ il_mac_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	struct il_rxon_context *tmp, *ctx = NULL;
 	int err;
 
-	IL_DEBUG_MAC80211(il, "enter: type %d, addr %pM\n",
+	D_MAC80211("enter: type %d, addr %pM\n",
 			   vif->type, vif->addr);
 
 	mutex_lock(&il->mutex);
@@ -1398,7 +1398,7 @@ il_mac_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
  out:
 	mutex_unlock(&il->mutex);
 
-	IL_DEBUG_MAC80211(il, "leave\n");
+	D_MAC80211("leave\n");
 	return err;
 }
 EXPORT_SYMBOL(il_mac_add_interface);
@@ -1429,7 +1429,7 @@ void il_mac_remove_interface(struct ieee80211_hw *hw,
 	struct il_priv *il = hw->priv;
 	struct il_rxon_context *ctx = il_rxon_ctx_from_vif(vif);
 
-	IL_DEBUG_MAC80211(il, "enter\n");
+	D_MAC80211("enter\n");
 
 	mutex_lock(&il->mutex);
 
@@ -1441,7 +1441,7 @@ void il_mac_remove_interface(struct ieee80211_hw *hw,
 	memset(il->bssid, 0, ETH_ALEN);
 	mutex_unlock(&il->mutex);
 
-	IL_DEBUG_MAC80211(il, "leave\n");
+	D_MAC80211("leave\n");
 
 }
 EXPORT_SYMBOL(il_mac_remove_interface);
@@ -1720,7 +1720,7 @@ int il_force_reset(struct il_priv *il, bool external)
 		if (force_reset->last_force_reset_jiffies &&
 		    time_after(force_reset->last_force_reset_jiffies +
 		    force_reset->reset_duration, jiffies)) {
-			IL_DEBUG_INFO(il, "force reset rejected\n");
+			D_INFO("force reset rejected\n");
 			force_reset->reset_reject_count++;
 			return -EAGAIN;
 		}
@@ -1738,7 +1738,7 @@ int il_force_reset(struct il_priv *il, bool external)
 	 */
 
 	if (!external && !il->cfg->mod_params->restart_fw) {
-		IL_DEBUG_INFO(il, "Cancel firmware reload based on "
+		D_INFO("Cancel firmware reload based on "
 			       "module parameter setting\n");
 		return 0;
 	}
@@ -2046,7 +2046,7 @@ il_update_qos(struct il_priv *il, struct il_rxon_context *ctx)
 	if (ctx->ht.enabled)
 		ctx->qos_data.def_qos_parm.qos_flags |= QOS_PARAM_FLG_TGN_MSK;
 
-	IL_DEBUG_QOS(il, "send QoS cmd with Qos active=%d FLAGS=0x%X\n",
+	D_QOS("send QoS cmd with Qos active=%d FLAGS=0x%X\n",
 		      ctx->qos_data.qos_active,
 		      ctx->qos_data.def_qos_parm.qos_flags);
 
@@ -2077,12 +2077,12 @@ int il_mac_config(struct ieee80211_hw *hw, u32 changed)
 
 	mutex_lock(&il->mutex);
 
-	IL_DEBUG_MAC80211(il, "enter to channel %d changed 0x%X\n",
+	D_MAC80211("enter to channel %d changed 0x%X\n",
 					channel->hw_value, changed);
 
 	if (unlikely(test_bit(STATUS_SCANNING, &il->status))) {
 		scan_active = 1;
-		IL_DEBUG_MAC80211(il, "scan active\n");
+		D_MAC80211("scan active\n");
 	}
 
 	if (changed & (IEEE80211_CONF_CHANGE_SMPS |
@@ -2112,14 +2112,14 @@ int il_mac_config(struct ieee80211_hw *hw, u32 changed)
 		ch = channel->hw_value;
 		ch_info = il_get_channel_info(il, channel->band, ch);
 		if (!il_is_channel_valid(ch_info)) {
-			IL_DEBUG_MAC80211(il, "leave - invalid channel\n");
+			D_MAC80211("leave - invalid channel\n");
 			ret = -EINVAL;
 			goto set_ch_out;
 		}
 
 		if (il->iw_mode == NL80211_IFTYPE_ADHOC &&
 		    !il_is_channel_ibss(ch_info)) {
-			IL_DEBUG_MAC80211(il, "leave - not IBSS channel\n");
+			D_MAC80211("leave - not IBSS channel\n");
 			ret = -EINVAL;
 			goto set_ch_out;
 		}
@@ -2186,18 +2186,18 @@ int il_mac_config(struct ieee80211_hw *hw, u32 changed)
 			IEEE80211_CONF_CHANGE_IDLE)) {
 		ret = il_power_update_mode(il, false);
 		if (ret)
-			IL_DEBUG_MAC80211(il, "Error setting sleep level\n");
+			D_MAC80211("Error setting sleep level\n");
 	}
 
 	if (changed & IEEE80211_CONF_CHANGE_POWER) {
-		IL_DEBUG_MAC80211(il, "TX Power old=%d new=%d\n",
+		D_MAC80211("TX Power old=%d new=%d\n",
 			il->tx_power_user_lmt, conf->power_level);
 
 		il_set_tx_power(il, conf->power_level, false);
 	}
 
 	if (!il_is_ready(il)) {
-		IL_DEBUG_MAC80211(il, "leave - not ready\n");
+		D_MAC80211("leave - not ready\n");
 		goto out;
 	}
 
@@ -2208,14 +2208,14 @@ int il_mac_config(struct ieee80211_hw *hw, u32 changed)
 		if (memcmp(&ctx->active, &ctx->staging, sizeof(ctx->staging)))
 			il_commit_rxon(il, ctx);
 		else
-			IL_DEBUG_INFO(il,
+			D_INFO(
 				"Not re-sending same RXON configuration.\n");
 		if (ht_changed[ctx->ctxid])
 			il_update_qos(il, ctx);
 	}
 
 out:
-	IL_DEBUG_MAC80211(il, "leave\n");
+	D_MAC80211("leave\n");
 	mutex_unlock(&il->mutex);
 	return ret;
 }
@@ -2233,7 +2233,7 @@ void il_mac_reset_tsf(struct ieee80211_hw *hw,
 		return;
 
 	mutex_lock(&il->mutex);
-	IL_DEBUG_MAC80211(il, "enter\n");
+	D_MAC80211("enter\n");
 
 	spin_lock_irqsave(&il->lock, flags);
 	memset(&il->current_ht_config, 0, sizeof(struct il_ht_config));
@@ -2253,7 +2253,7 @@ void il_mac_reset_tsf(struct ieee80211_hw *hw,
 
 	il_scan_cancel_timeout(il, 100);
 	if (!il_is_ready_rf(il)) {
-		IL_DEBUG_MAC80211(il, "leave - not ready\n");
+		D_MAC80211("leave - not ready\n");
 		mutex_unlock(&il->mutex);
 		return;
 	}
@@ -2268,7 +2268,7 @@ void il_mac_reset_tsf(struct ieee80211_hw *hw,
 
 	mutex_unlock(&il->mutex);
 
-	IL_DEBUG_MAC80211(il, "leave\n");
+	D_MAC80211("leave\n");
 }
 EXPORT_SYMBOL(il_mac_reset_tsf);
 
@@ -2280,7 +2280,7 @@ static void il_ht_conf(struct il_priv *il,
 	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
 	struct il_rxon_context *ctx = il_rxon_ctx_from_vif(vif);
 
-	IL_DEBUG_ASSOC(il, "enter:\n");
+	D_ASSOC("enter:\n");
 
 	if (!ctx->ht.enabled)
 		return;
@@ -2329,7 +2329,7 @@ static void il_ht_conf(struct il_priv *il,
 		break;
 	}
 
-	IL_DEBUG_ASSOC(il, "leave\n");
+	D_ASSOC("leave\n");
 }
 
 static inline void il_set_no_assoc(struct il_priv *il,
@@ -2358,7 +2358,7 @@ static void il_beacon_update(struct ieee80211_hw *hw,
 	if (!skb)
 		return;
 
-	IL_DEBUG_MAC80211(il, "enter\n");
+	D_MAC80211("enter\n");
 
 	lockdep_assert_held(&il->mutex);
 
@@ -2378,11 +2378,11 @@ static void il_beacon_update(struct ieee80211_hw *hw,
 	timestamp = ((struct ieee80211_mgmt *)skb->data)->u.beacon.timestamp;
 	il->timestamp = le64_to_cpu(timestamp);
 
-	IL_DEBUG_MAC80211(il, "leave\n");
+	D_MAC80211("leave\n");
 	spin_unlock_irqrestore(&il->lock, flags);
 
 	if (!il_is_ready_rf(il)) {
-		IL_DEBUG_MAC80211(il, "leave - RF not ready\n");
+		D_MAC80211("leave - RF not ready\n");
 		return;
 	}
 
@@ -2401,7 +2401,7 @@ void il_mac_bss_info_changed(struct ieee80211_hw *hw,
 	if (WARN_ON(!il->cfg->ops->legacy))
 		return;
 
-	IL_DEBUG_MAC80211(il, "changes = 0x%X\n", changes);
+	D_MAC80211("changes = 0x%X\n", changes);
 
 	mutex_lock(&il->mutex);
 
@@ -2432,7 +2432,7 @@ void il_mac_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	if (changes & BSS_CHANGED_BSSID) {
-		IL_DEBUG_MAC80211(il, "BSSID %pM\n", bss_conf->bssid);
+		D_MAC80211("BSSID %pM\n", bss_conf->bssid);
 
 		/*
 		 * If there is currently a HW scan going on in the
@@ -2442,7 +2442,7 @@ void il_mac_bss_info_changed(struct ieee80211_hw *hw,
 		if (il_scan_cancel_timeout(il, 100)) {
 			IL_WARN(il,
 				"Aborted scan still in progress after 100ms\n");
-			IL_DEBUG_MAC80211(il,
+			D_MAC80211(
 				"leaving - scan abort failed.\n");
 			mutex_unlock(&il->mutex);
 			return;
@@ -2471,7 +2471,7 @@ void il_mac_bss_info_changed(struct ieee80211_hw *hw,
 		il_beacon_update(hw, vif);
 
 	if (changes & BSS_CHANGED_ERP_PREAMBLE) {
-		IL_DEBUG_MAC80211(il, "ERP_PREAMBLE %d\n",
+		D_MAC80211("ERP_PREAMBLE %d\n",
 				   bss_conf->use_short_preamble);
 		if (bss_conf->use_short_preamble)
 			ctx->staging.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
@@ -2480,7 +2480,7 @@ void il_mac_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	if (changes & BSS_CHANGED_ERP_CTS_PROT) {
-		IL_DEBUG_MAC80211(il,
+		D_MAC80211(
 			"ERP_CTS %d\n", bss_conf->use_cts_prot);
 		if (bss_conf->use_cts_prot &&
 			(il->band != IEEE80211_BAND_5GHZ))
@@ -2518,7 +2518,7 @@ void il_mac_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	if (changes & BSS_CHANGED_ASSOC) {
-		IL_DEBUG_MAC80211(il, "ASSOC %d\n", bss_conf->assoc);
+		D_MAC80211("ASSOC %d\n", bss_conf->assoc);
 		if (bss_conf->assoc) {
 			il->timestamp = bss_conf->timestamp;
 
@@ -2529,7 +2529,7 @@ void il_mac_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	if (changes && il_is_associated_ctx(ctx) && bss_conf->aid) {
-		IL_DEBUG_MAC80211(il, "Changes (%#x) while associated\n",
+		D_MAC80211("Changes (%#x) while associated\n",
 				   changes);
 		ret = il_send_rxon_assoc(il, ctx);
 		if (!ret) {
@@ -2561,7 +2561,7 @@ void il_mac_bss_info_changed(struct ieee80211_hw *hw,
 
 	mutex_unlock(&il->mutex);
 
-	IL_DEBUG_MAC80211(il, "leave\n");
+	D_MAC80211("leave\n");
 }
 EXPORT_SYMBOL(il_mac_bss_info_changed);
 
@@ -2591,7 +2591,7 @@ irqreturn_t il_isr(int irq, void *data)
 	 * This may be due to IRQ shared with another device,
 	 * or due to sporadic interrupts thrown from our NIC. */
 	if (!inta && !inta_fh) {
-		IL_DEBUG_ISR(il,
+		D_ISR(
 			"Ignore interrupt, inta == 0, inta_fh == 0\n");
 		goto none;
 	}
@@ -2603,7 +2603,7 @@ irqreturn_t il_isr(int irq, void *data)
 		goto unplugged;
 	}
 
-	IL_DEBUG_ISR(il, "ISR inta 0x%08x, enabled 0x%08x, fh 0x%08x\n",
+	D_ISR("ISR inta 0x%08x, enabled 0x%08x, fh 0x%08x\n",
 		      inta, inta_mask, inta_fh);
 
 	inta &= ~CSR_INT_BIT_SCD;
diff --git a/drivers/net/wireless/iwlegacy/iwl-debug.h b/drivers/net/wireless/iwlegacy/iwl-debug.h
index c6dcbf3..2c5c42f 100644
--- a/drivers/net/wireless/iwlegacy/iwl-debug.h
+++ b/drivers/net/wireless/iwlegacy/iwl-debug.h
@@ -37,17 +37,17 @@ extern u32 il_debug_level;
 #define IL_INFO(p, f, a...) dev_info(&((p)->pci_dev->dev), f, ## a)
 #define IL_CRIT(p, f, a...) dev_crit(&((p)->pci_dev->dev), f, ## a)
 
-#define il_print_hex_error(il, p, len)				 \
+#define il_print_hex_error(il, p, len)					\
 do {									\
 	print_hex_dump(KERN_ERR, "iwl data: ",				\
 		       DUMP_PREFIX_OFFSET, 16, 1, p, len, 1);		\
 } while (0)
 
 #ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
-#define IL_DEBUG(__priv, level, fmt, args...)				\
+#define IL_DBG(level, fmt, args...)					\
 do {									\
-	if (il_get_debug_level(__priv) & (level))			\
-		dev_printk(KERN_ERR, &(__priv->hw->wiphy->dev),		\
+	if (il_get_debug_level(il) & level)				\
+		dev_printk(KERN_ERR, &il->hw->wiphy->dev,		\
 			 "%c %s " fmt, in_interrupt() ? 'I' : 'U',	\
 			__func__ , ## args);				\
 } while (0)
@@ -60,7 +60,7 @@ do {									\
 } while (0)
 
 #else
-#define IL_DEBUG(__priv, level, fmt, args...)
+#define IL_DBG(level, fmt, args...)
 static inline void il_print_hex_dump(struct il_priv *il, int level,
 				      const void *p, u32 len)
 {}
@@ -91,12 +91,12 @@ static inline void il_dbgfs_unregister(struct il_priv *il)
  * where xxxx should be the name of the classification (for example, WEP).
  *
  * You then need to either add a IL_xxxx_DEBUG() macro definition for your
- * classification, or use IL_DEBUG(IL_DL_xxxx, ...) whenever you want
+ * classification, or use IL_DBG(IL_DL_xxxx, ...) whenever you want
  * to send output to that classification.
  *
  * The active debug levels can be accessed via files
  *
- * 	/sys/module/iwl4965/parameters/debug{50}
+ * 	/sys/module/iwl4965/parameters/debug
  *	/sys/module/iwl3945/parameters/debug
  * 	/sys/class/net/wlan0/device/debug_level
  *
@@ -110,7 +110,7 @@ static inline void il_dbgfs_unregister(struct il_priv *il)
 #define IL_DL_STATE		(1 << 3)
 /* 0x000000F0 - 0x00000010 */
 #define IL_DL_MACDUMP		(1 << 4)
-#define IL_DL_HCMD_DUMP	(1 << 5)
+#define IL_DL_HCMD_DUMP		(1 << 5)
 #define IL_DL_EEPROM		(1 << 6)
 #define IL_DL_RADIO		(1 << 7)
 /* 0x00000F00 - 0x00000100 */
@@ -126,7 +126,7 @@ static inline void il_dbgfs_unregister(struct il_priv *il)
 /* 0x000F0000 - 0x00010000 */
 #define IL_DL_FW		(1 << 16)
 #define IL_DL_RF_KILL		(1 << 17)
-#define IL_DL_FW_ERRORS	(1 << 18)
+#define IL_DL_FW_ERRORS		(1 << 18)
 #define IL_DL_LED		(1 << 19)
 /* 0x00F00000 - 0x00100000 */
 #define IL_DL_RATE		(1 << 20)
@@ -143,34 +143,34 @@ static inline void il_dbgfs_unregister(struct il_priv *il)
 #define IL_DL_TX_REPLY		(1 << 30)
 #define IL_DL_QOS		(1 << 31)
 
-#define IL_DEBUG_INFO(p, f, a...)	IL_DEBUG(p, IL_DL_INFO, f, ## a)
-#define IL_DEBUG_MAC80211(p, f, a...)	IL_DEBUG(p, IL_DL_MAC80211, f, ## a)
-#define IL_DEBUG_MACDUMP(p, f, a...)	IL_DEBUG(p, IL_DL_MACDUMP, f, ## a)
-#define IL_DEBUG_TEMP(p, f, a...)	IL_DEBUG(p, IL_DL_TEMP, f, ## a)
-#define IL_DEBUG_SCAN(p, f, a...)	IL_DEBUG(p, IL_DL_SCAN, f, ## a)
-#define IL_DEBUG_RX(p, f, a...)	IL_DEBUG(p, IL_DL_RX, f, ## a)
-#define IL_DEBUG_TX(p, f, a...)	IL_DEBUG(p, IL_DL_TX, f, ## a)
-#define IL_DEBUG_ISR(p, f, a...)	IL_DEBUG(p, IL_DL_ISR, f, ## a)
-#define IL_DEBUG_LED(p, f, a...)	IL_DEBUG(p, IL_DL_LED, f, ## a)
-#define IL_DEBUG_WEP(p, f, a...)	IL_DEBUG(p, IL_DL_WEP, f, ## a)
-#define IL_DEBUG_HC(p, f, a...)	IL_DEBUG(p, IL_DL_HCMD, f, ## a)
-#define IL_DEBUG_HC_DUMP(p, f, a...)	IL_DEBUG(p, IL_DL_HCMD_DUMP, f, ## a)
-#define IL_DEBUG_EEPROM(p, f, a...)	IL_DEBUG(p, IL_DL_EEPROM, f, ## a)
-#define IL_DEBUG_CALIB(p, f, a...)	IL_DEBUG(p, IL_DL_CALIB, f, ## a)
-#define IL_DEBUG_FW(p, f, a...)	IL_DEBUG(p, IL_DL_FW, f, ## a)
-#define IL_DEBUG_RF_KILL(p, f, a...)	IL_DEBUG(p, IL_DL_RF_KILL, f, ## a)
-#define IL_DEBUG_DROP(p, f, a...)	IL_DEBUG(p, IL_DL_DROP, f, ## a)
-#define IL_DEBUG_AP(p, f, a...)	IL_DEBUG(p, IL_DL_AP, f, ## a)
-#define IL_DEBUG_TXPOWER(p, f, a...)	IL_DEBUG(p, IL_DL_TXPOWER, f, ## a)
-#define IL_DEBUG_RATE(p, f, a...)	IL_DEBUG(p, IL_DL_RATE, f, ## a)
-#define IL_DEBUG_NOTIF(p, f, a...)	IL_DEBUG(p, IL_DL_NOTIF, f, ## a)
-#define IL_DEBUG_ASSOC(p, f, a...)	IL_DEBUG(p, IL_DL_ASSOC, f, ## a)
-#define IL_DEBUG_HT(p, f, a...)	IL_DEBUG(p, IL_DL_HT, f, ## a)
-#define IL_DEBUG_STATS(p, f, a...)	IL_DEBUG(p, IL_DL_STATS, f, ## a)
-#define IL_DEBUG_TX_REPLY(p, f, a...)	IL_DEBUG(p, IL_DL_TX_REPLY, f, ## a)
-#define IL_DEBUG_QOS(p, f, a...)	IL_DEBUG(p, IL_DL_QOS, f, ## a)
-#define IL_DEBUG_RADIO(p, f, a...)	IL_DEBUG(p, IL_DL_RADIO, f, ## a)
-#define IL_DEBUG_POWER(p, f, a...)	IL_DEBUG(p, IL_DL_POWER, f, ## a)
-#define IL_DEBUG_11H(p, f, a...)	IL_DEBUG(p, IL_DL_11H, f, ## a)
+#define D_INFO(f, a...)		IL_DBG(IL_DL_INFO, f, ## a)
+#define D_MAC80211(f, a...)	IL_DBG(IL_DL_MAC80211, f, ## a)
+#define D_MACDUMP(f, a...)	IL_DBG(IL_DL_MACDUMP, f, ## a)
+#define D_TEMP(f, a...)		IL_DBG(IL_DL_TEMP, f, ## a)
+#define D_SCAN(f, a...)		IL_DBG(IL_DL_SCAN, f, ## a)
+#define D_RX(f, a...)		IL_DBG(IL_DL_RX, f, ## a)
+#define D_TX(f, a...)		IL_DBG(IL_DL_TX, f, ## a)
+#define D_ISR(f, a...)		IL_DBG(IL_DL_ISR, f, ## a)
+#define D_LED(f, a...)		IL_DBG(IL_DL_LED, f, ## a)
+#define D_WEP(f, a...)		IL_DBG(IL_DL_WEP, f, ## a)
+#define D_HC(f, a...)		IL_DBG(IL_DL_HCMD, f, ## a)
+#define D_HC_DUMP(f, a...)	IL_DBG(IL_DL_HCMD_DUMP, f, ## a)
+#define D_EEPROM(f, a...)	IL_DBG(IL_DL_EEPROM, f, ## a)
+#define D_CALIB(f, a...)	IL_DBG(IL_DL_CALIB, f, ## a)
+#define D_FW(f, a...)		IL_DBG(IL_DL_FW, f, ## a)
+#define D_RF_KILL(f, a...)	IL_DBG(IL_DL_RF_KILL, f, ## a)
+#define D_DROP(f, a...)		IL_DBG(IL_DL_DROP, f, ## a)
+#define D_AP(f, a...)		IL_DBG(IL_DL_AP, f, ## a)
+#define D_TXPOWER(f, a...)	IL_DBG(IL_DL_TXPOWER, f, ## a)
+#define D_RATE(f, a...)		IL_DBG(IL_DL_RATE, f, ## a)
+#define D_NOTIF(f, a...)	IL_DBG(IL_DL_NOTIF, f, ## a)
+#define D_ASSOC(f, a...)	IL_DBG(IL_DL_ASSOC, f, ## a)
+#define D_HT(f, a...)		IL_DBG(IL_DL_HT, f, ## a)
+#define D_STATS(f, a...)	IL_DBG(IL_DL_STATS, f, ## a)
+#define D_TX_REPLY(f, a...)	IL_DBG(IL_DL_TX_REPLY, f, ## a)
+#define D_QOS(f, a...)		IL_DBG(IL_DL_QOS, f, ## a)
+#define D_RADIO(f, a...)	IL_DBG(IL_DL_RADIO, f, ## a)
+#define D_POWER(f, a...)	IL_DBG(IL_DL_POWER, f, ## a)
+#define D_11H(f, a...)		IL_DBG(IL_DL_11H, f, ## a)
 
 #endif
diff --git a/drivers/net/wireless/iwlegacy/iwl-eeprom.c b/drivers/net/wireless/iwlegacy/iwl-eeprom.c
index f6b9d6d..33fe598 100644
--- a/drivers/net/wireless/iwlegacy/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlegacy/iwl-eeprom.c
@@ -147,7 +147,7 @@ static int il_eeprom_verify_signature(struct il_priv *il)
 	u32 gp = il_read32(il, CSR_EEPROM_GP) & CSR_EEPROM_GP_VALID_MSK;
 	int ret = 0;
 
-	IL_DEBUG_EEPROM(il, "EEPROM signature=0x%08x\n", gp);
+	D_EEPROM("EEPROM signature=0x%08x\n", gp);
 	switch (gp) {
 	case CSR_EEPROM_GP_GOOD_SIG_EEP_LESS_THAN_4K:
 	case CSR_EEPROM_GP_GOOD_SIG_EEP_MORE_THAN_4K:
@@ -194,7 +194,7 @@ int il_eeprom_init(struct il_priv *il)
 
 	/* allocate eeprom */
 	sz = il->cfg->base_params->eeprom_size;
-	IL_DEBUG_EEPROM(il, "NVM size = %d\n", sz);
+	D_EEPROM("NVM size = %d\n", sz);
 	il->eeprom = kzalloc(sz, GFP_KERNEL);
 	if (!il->eeprom) {
 		ret = -ENOMEM;
@@ -239,7 +239,7 @@ int il_eeprom_init(struct il_priv *il)
 		e[addr / 2] = cpu_to_le16(r >> 16);
 	}
 
-	IL_DEBUG_EEPROM(il, "NVM Type: %s, version: 0x%x\n",
+	D_EEPROM("NVM Type: %s, version: 0x%x\n",
 		       "EEPROM",
 		       il_eeprom_query16(il, EEPROM_VERSION));
 
@@ -339,7 +339,7 @@ static int il_mod_ht40_chan_info(struct il_priv *il,
 	if (!il_is_channel_valid(ch_info))
 		return -1;
 
-	IL_DEBUG_EEPROM(il, "HT40 Ch. %d [%sGHz] %s%s%s%s%s(0x%02x %ddBm):"
+	D_EEPROM("HT40 Ch. %d [%sGHz] %s%s%s%s%s(0x%02x %ddBm):"
 			" Ad-Hoc %ssupported\n",
 			ch_info->channel,
 			il_is_channel_a_band(ch_info) ?
@@ -380,11 +380,11 @@ int il_init_channel_map(struct il_priv *il)
 	struct il_channel_info *ch_info;
 
 	if (il->channel_count) {
-		IL_DEBUG_EEPROM(il, "Channel map already initialized.\n");
+		D_EEPROM("Channel map already initialized.\n");
 		return 0;
 	}
 
-	IL_DEBUG_EEPROM(il, "Initializing regulatory info from EEPROM\n");
+	D_EEPROM("Initializing regulatory info from EEPROM\n");
 
 	il->channel_count =
 	    ARRAY_SIZE(il_eeprom_band_1) +
@@ -393,7 +393,7 @@ int il_init_channel_map(struct il_priv *il)
 	    ARRAY_SIZE(il_eeprom_band_4) +
 	    ARRAY_SIZE(il_eeprom_band_5);
 
-	IL_DEBUG_EEPROM(il, "Parsing data for %d channels.\n",
+	D_EEPROM("Parsing data for %d channels.\n",
 			il->channel_count);
 
 	il->channel_info = kzalloc(sizeof(struct il_channel_info) *
@@ -433,7 +433,7 @@ int il_init_channel_map(struct il_priv *il)
 					IEEE80211_CHAN_NO_HT40;
 
 			if (!(il_is_channel_valid(ch_info))) {
-				IL_DEBUG_EEPROM(il,
+				D_EEPROM(
 					       "Ch. %d Flags %x [%sGHz] - "
 					       "No traffic\n",
 					       ch_info->channel,
@@ -450,7 +450,7 @@ int il_init_channel_map(struct il_priv *il)
 			ch_info->scan_power = eeprom_ch_info[ch].max_power_avg;
 			ch_info->min_power = 0;
 
-			IL_DEBUG_EEPROM(il, "Ch. %d [%sGHz] "
+			D_EEPROM("Ch. %d [%sGHz] "
 				       "%s%s%s%s%s%s(0x%02x %ddBm):"
 				       " Ad-Hoc %ssupported\n",
 				       ch_info->channel,
diff --git a/drivers/net/wireless/iwlegacy/iwl-hcmd.c b/drivers/net/wireless/iwlegacy/iwl-hcmd.c
index f16e311..61cf0d8 100644
--- a/drivers/net/wireless/iwlegacy/iwl-hcmd.c
+++ b/drivers/net/wireless/iwlegacy/iwl-hcmd.c
@@ -104,11 +104,11 @@ static void il_generic_cmd_callback(struct il_priv *il,
 	switch (cmd->hdr.cmd) {
 	case REPLY_TX_LINK_QUALITY_CMD:
 	case SENSITIVITY_CMD:
-		IL_DEBUG_HC_DUMP(il, "back from %s (0x%08X)\n",
+		D_HC_DUMP("back from %s (0x%08X)\n",
 		il_get_cmd_string(cmd->hdr.cmd), pkt->hdr.flags);
 		break;
 	default:
-		IL_DEBUG_HC(il, "back from %s (0x%08X)\n",
+		D_HC("back from %s (0x%08X)\n",
 		il_get_cmd_string(cmd->hdr.cmd), pkt->hdr.flags);
 	}
 #endif
@@ -152,11 +152,11 @@ int il_send_cmd_sync(struct il_priv *il, struct il_host_cmd *cmd)
 	 /* A synchronous command can not have a callback set. */
 	BUG_ON(cmd->callback);
 
-	IL_DEBUG_INFO(il, "Attempting to send sync command %s\n",
+	D_INFO("Attempting to send sync command %s\n",
 			il_get_cmd_string(cmd->id));
 
 	set_bit(STATUS_HCMD_ACTIVE, &il->status);
-	IL_DEBUG_INFO(il, "Setting HCMD_ACTIVE for command %s\n",
+	D_INFO("Setting HCMD_ACTIVE for command %s\n",
 			il_get_cmd_string(cmd->id));
 
 	cmd_idx = il_enqueue_hcmd(il, cmd);
@@ -178,7 +178,7 @@ int il_send_cmd_sync(struct il_priv *il, struct il_host_cmd *cmd)
 				jiffies_to_msecs(HOST_COMPLETE_TIMEOUT));
 
 			clear_bit(STATUS_HCMD_ACTIVE, &il->status);
-			IL_DEBUG_INFO(il,
+			D_INFO(
 				"Clearing HCMD_ACTIVE for command %s\n",
 				       il_get_cmd_string(cmd->id));
 			ret = -ETIMEDOUT;
diff --git a/drivers/net/wireless/iwlegacy/iwl-helpers.h b/drivers/net/wireless/iwlegacy/iwl-helpers.h
index e55f2ef..a0a84b2 100644
--- a/drivers/net/wireless/iwlegacy/iwl-helpers.h
+++ b/drivers/net/wireless/iwlegacy/iwl-helpers.h
@@ -155,18 +155,18 @@ static inline void il_disable_interrupts(struct il_priv *il)
 	 * from uCode or flow handler (Rx/Tx DMA) */
 	il_write32(il, CSR_INT, 0xffffffff);
 	il_write32(il, CSR_FH_INT_STATUS, 0xffffffff);
-	IL_DEBUG_ISR(il, "Disabled interrupts\n");
+	D_ISR("Disabled interrupts\n");
 }
 
 static inline void il_enable_rfkill_int(struct il_priv *il)
 {
-	IL_DEBUG_ISR(il, "Enabling rfkill interrupt\n");
+	D_ISR("Enabling rfkill interrupt\n");
 	il_write32(il, CSR_INT_MASK, CSR_INT_BIT_RF_KILL);
 }
 
 static inline void il_enable_interrupts(struct il_priv *il)
 {
-	IL_DEBUG_ISR(il, "Enabling interrupts\n");
+	D_ISR("Enabling interrupts\n");
 	set_bit(STATUS_INT_ENABLED, &il->status);
 	il_write32(il, CSR_INT_MASK, il->inta_mask);
 }
diff --git a/drivers/net/wireless/iwlegacy/iwl-led.c b/drivers/net/wireless/iwlegacy/iwl-led.c
index 13add43..b4d71cf 100644
--- a/drivers/net/wireless/iwlegacy/iwl-led.c
+++ b/drivers/net/wireless/iwlegacy/iwl-led.c
@@ -118,7 +118,7 @@ static int il_led_cmd(struct il_priv *il,
 		on = IL_LED_SOLID;
 	}
 
-	IL_DEBUG_LED(il, "Led blink time compensation=%u\n",
+	D_LED("Led blink time compensation=%u\n",
 			il->cfg->base_params->led_compensation);
 	led_cmd.on = il_blink_compensation(il, on,
 				il->cfg->base_params->led_compensation);
diff --git a/drivers/net/wireless/iwlegacy/iwl-power.c b/drivers/net/wireless/iwlegacy/iwl-power.c
index 6386246..33aec39 100644
--- a/drivers/net/wireless/iwlegacy/iwl-power.c
+++ b/drivers/net/wireless/iwlegacy/iwl-power.c
@@ -68,19 +68,19 @@ static void il_power_sleep_cam_cmd(struct il_priv *il,
 	if (il->power_data.pci_pm)
 		cmd->flags |= IL_POWER_PCI_PM_MSK;
 
-	IL_DEBUG_POWER(il, "Sleep command for CAM\n");
+	D_POWER("Sleep command for CAM\n");
 }
 
 static int
 il_set_power(struct il_priv *il, struct il_powertable_cmd *cmd)
 {
-	IL_DEBUG_POWER(il, "Sending power/sleep command\n");
-	IL_DEBUG_POWER(il, "Flags value = 0x%08X\n", cmd->flags);
-	IL_DEBUG_POWER(il, "Tx timeout = %u\n",
+	D_POWER("Sending power/sleep command\n");
+	D_POWER("Flags value = 0x%08X\n", cmd->flags);
+	D_POWER("Tx timeout = %u\n",
 					le32_to_cpu(cmd->tx_data_timeout));
-	IL_DEBUG_POWER(il, "Rx timeout = %u\n",
+	D_POWER("Rx timeout = %u\n",
 					le32_to_cpu(cmd->rx_data_timeout));
-	IL_DEBUG_POWER(il,
+	D_POWER(
 			"Sleep interval vector = { %d , %d , %d , %d , %d }\n",
 			le32_to_cpu(cmd->sleep_interval[0]),
 			le32_to_cpu(cmd->sleep_interval[1]),
@@ -114,7 +114,7 @@ il_power_set_mode(struct il_priv *il, struct il_powertable_cmd *cmd,
 	/* scan complete use sleep_power_next, need to be updated */
 	memcpy(&il->power_data.sleep_cmd_next, cmd, sizeof(*cmd));
 	if (test_bit(STATUS_SCANNING, &il->status) && !force) {
-		IL_DEBUG_INFO(il, "Defer power set mode while scanning\n");
+		D_INFO("Defer power set mode while scanning\n");
 		return 0;
 	}
 
@@ -129,7 +129,7 @@ il_power_set_mode(struct il_priv *il, struct il_powertable_cmd *cmd,
 		if (il->cfg->ops->lib->update_chain_flags && update_chains)
 			il->cfg->ops->lib->update_chain_flags(il);
 		else if (il->cfg->ops->lib->update_chain_flags)
-			IL_DEBUG_POWER(il,
+			D_POWER(
 					"Cannot update the power, chain noise "
 					"calibration running: %d\n",
 					il->chain_noise_data.state);
diff --git a/drivers/net/wireless/iwlegacy/iwl-rx.c b/drivers/net/wireless/iwlegacy/iwl-rx.c
index b6c5dd0..183acdc 100644
--- a/drivers/net/wireless/iwlegacy/iwl-rx.c
+++ b/drivers/net/wireless/iwlegacy/iwl-rx.c
@@ -141,7 +141,7 @@ il_rx_queue_update_write_ptr(struct il_priv *il,
 		reg = il_read32(il, CSR_UCODE_DRV_GP1);
 
 		if (reg & CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP) {
-			IL_DEBUG_INFO(il,
+			D_INFO(
 				"Rx queue requesting wakeup,"
 				" GP1 = 0x%x\n", reg);
 			il_set_bit(il, CSR_GP_CNTRL,
@@ -217,7 +217,7 @@ void il_rx_spectrum_measure_notif(struct il_priv *il,
 	struct il_spectrum_notification *report = &(pkt->u.spectrum_notif);
 
 	if (!report->state) {
-		IL_DEBUG_11H(il,
+		D_11H(
 			"Spectrum Measure Notification: Start\n");
 		return;
 	}
@@ -248,7 +248,7 @@ int il_set_decrypted_flag(struct il_priv *il,
 	if (!(fc & IEEE80211_FCTL_PROTECTED))
 		return 0;
 
-	IL_DEBUG_RX(il, "decrypt_res:0x%x\n", decrypt_res);
+	D_RX("decrypt_res:0x%x\n", decrypt_res);
 	switch (decrypt_res & RX_RES_STATUS_SEC_TYPE_MSK) {
 	case RX_RES_STATUS_SEC_TYPE_TKIP:
 		/* The uCode has got a bad phase 1 Key, pushes the packet.
@@ -262,13 +262,13 @@ int il_set_decrypted_flag(struct il_priv *il,
 		    RX_RES_STATUS_BAD_ICV_MIC) {
 			/* bad ICV, the packet is destroyed since the
 			 * decryption is inplace, drop it */
-			IL_DEBUG_RX(il, "Packet destroyed\n");
+			D_RX("Packet destroyed\n");
 			return -1;
 		}
 	case RX_RES_STATUS_SEC_TYPE_CCMP:
 		if ((decrypt_res & RX_RES_STATUS_DECRYPT_TYPE_MSK) ==
 		    RX_RES_STATUS_DECRYPT_OK) {
-			IL_DEBUG_RX(il, "hw decrypt successfully!!!\n");
+			D_RX("hw decrypt successfully!!!\n");
 			stats->flag |= RX_FLAG_DECRYPTED;
 		}
 		break;
diff --git a/drivers/net/wireless/iwlegacy/iwl-scan.c b/drivers/net/wireless/iwlegacy/iwl-scan.c
index 5a967d2..c534dce 100644
--- a/drivers/net/wireless/iwlegacy/iwl-scan.c
+++ b/drivers/net/wireless/iwlegacy/iwl-scan.c
@@ -85,7 +85,7 @@ static int il_send_scan_abort(struct il_priv *il)
 		 * can occur if we send the scan abort before we
 		 * the microcode has notified us that a scan is
 		 * completed. */
-		IL_DEBUG_SCAN(il, "SCAN_ABORT ret %d.\n", pkt->u.status);
+		D_SCAN("SCAN_ABORT ret %d.\n", pkt->u.status);
 		ret = -EIO;
 	}
 
@@ -97,7 +97,7 @@ static void il_complete_scan(struct il_priv *il, bool aborted)
 {
 	/* check if scan was requested from mac80211 */
 	if (il->scan_request) {
-		IL_DEBUG_SCAN(il, "Complete scan in mac80211\n");
+		D_SCAN("Complete scan in mac80211\n");
 		ieee80211_scan_completed(il->hw, aborted);
 	}
 
@@ -110,11 +110,11 @@ void il_force_scan_end(struct il_priv *il)
 	lockdep_assert_held(&il->mutex);
 
 	if (!test_bit(STATUS_SCANNING, &il->status)) {
-		IL_DEBUG_SCAN(il, "Forcing scan end while not scanning\n");
+		D_SCAN("Forcing scan end while not scanning\n");
 		return;
 	}
 
-	IL_DEBUG_SCAN(il, "Forcing scan end\n");
+	D_SCAN("Forcing scan end\n");
 	clear_bit(STATUS_SCANNING, &il->status);
 	clear_bit(STATUS_SCAN_HW, &il->status);
 	clear_bit(STATUS_SCAN_ABORTING, &il->status);
@@ -128,21 +128,21 @@ static void il_do_scan_abort(struct il_priv *il)
 	lockdep_assert_held(&il->mutex);
 
 	if (!test_bit(STATUS_SCANNING, &il->status)) {
-		IL_DEBUG_SCAN(il, "Not performing scan to abort\n");
+		D_SCAN("Not performing scan to abort\n");
 		return;
 	}
 
 	if (test_and_set_bit(STATUS_SCAN_ABORTING, &il->status)) {
-		IL_DEBUG_SCAN(il, "Scan abort in progress\n");
+		D_SCAN("Scan abort in progress\n");
 		return;
 	}
 
 	ret = il_send_scan_abort(il);
 	if (ret) {
-		IL_DEBUG_SCAN(il, "Send scan abort failed %d\n", ret);
+		D_SCAN("Send scan abort failed %d\n", ret);
 		il_force_scan_end(il);
 	} else
-		IL_DEBUG_SCAN(il, "Successfully send scan abort\n");
+		D_SCAN("Successfully send scan abort\n");
 }
 
 /**
@@ -150,7 +150,7 @@ static void il_do_scan_abort(struct il_priv *il)
  */
 int il_scan_cancel(struct il_priv *il)
 {
-	IL_DEBUG_SCAN(il, "Queuing abort scan\n");
+	D_SCAN("Queuing abort scan\n");
 	queue_work(il->workqueue, &il->abort_scan);
 	return 0;
 }
@@ -167,7 +167,7 @@ int il_scan_cancel_timeout(struct il_priv *il, unsigned long ms)
 
 	lockdep_assert_held(&il->mutex);
 
-	IL_DEBUG_SCAN(il, "Scan cancel timeout\n");
+	D_SCAN("Scan cancel timeout\n");
 
 	il_do_scan_abort(il);
 
@@ -190,7 +190,7 @@ static void il_rx_reply_scan(struct il_priv *il,
 	struct il_scanreq_notification *notif =
 	    (struct il_scanreq_notification *)pkt->u.raw;
 
-	IL_DEBUG_SCAN(il, "Scan request status = 0x%x\n", notif->status);
+	D_SCAN("Scan request status = 0x%x\n", notif->status);
 #endif
 }
 
@@ -202,7 +202,7 @@ static void il_rx_scan_start_notif(struct il_priv *il,
 	struct il_scanstart_notification *notif =
 	    (struct il_scanstart_notification *)pkt->u.raw;
 	il->scan_start_tsf = le32_to_cpu(notif->tsf_low);
-	IL_DEBUG_SCAN(il, "Scan start: "
+	D_SCAN("Scan start: "
 		       "%d [802.11%s] "
 		       "(TSF: 0x%08X:%08X) - %d (beacon timer %u)\n",
 		       notif->channel,
@@ -221,7 +221,7 @@ static void il_rx_scan_results_notif(struct il_priv *il,
 	struct il_scanresults_notification *notif =
 	    (struct il_scanresults_notification *)pkt->u.raw;
 
-	IL_DEBUG_SCAN(il, "Scan ch.res: "
+	D_SCAN("Scan ch.res: "
 		       "%d [802.11%s] "
 		       "(TSF: 0x%08X:%08X) - %d "
 		       "elapsed=%lu usec\n",
@@ -244,7 +244,7 @@ static void il_rx_scan_complete_notif(struct il_priv *il,
 	struct il_scancomplete_notification *scan_notif = (void *)pkt->u.raw;
 #endif
 
-	IL_DEBUG_SCAN(il,
+	D_SCAN(
 			"Scan complete: %d channels (TSF 0x%08X:%08X) - %d\n",
 		       scan_notif->scanned_channels,
 		       scan_notif->tsf_low,
@@ -253,7 +253,7 @@ static void il_rx_scan_complete_notif(struct il_priv *il,
 	/* The HW is no longer scanning */
 	clear_bit(STATUS_SCAN_HW, &il->status);
 
-	IL_DEBUG_SCAN(il, "Scan on %sGHz took %dms\n",
+	D_SCAN("Scan on %sGHz took %dms\n",
 		       (il->scan_band == IEEE80211_BAND_2GHZ) ? "2.4" : "5.2",
 		       jiffies_to_msecs(jiffies - il->scan_start));
 
@@ -346,17 +346,17 @@ static int il_scan_initiate(struct il_priv *il,
 	}
 
 	if (test_bit(STATUS_SCAN_HW, &il->status)) {
-		IL_DEBUG_SCAN(il,
+		D_SCAN(
 			"Multiple concurrent scan requests in parallel.\n");
 		return -EBUSY;
 	}
 
 	if (test_bit(STATUS_SCAN_ABORTING, &il->status)) {
-		IL_DEBUG_SCAN(il, "Scan request while abort pending.\n");
+		D_SCAN("Scan request while abort pending.\n");
 		return -EBUSY;
 	}
 
-	IL_DEBUG_SCAN(il, "Starting scan...\n");
+	D_SCAN("Starting scan...\n");
 
 	set_bit(STATUS_SCANNING, &il->status);
 	il->scan_start = jiffies;
@@ -380,7 +380,7 @@ int il_mac_hw_scan(struct ieee80211_hw *hw,
 	struct il_priv *il = hw->priv;
 	int ret;
 
-	IL_DEBUG_MAC80211(il, "enter\n");
+	D_MAC80211("enter\n");
 
 	if (req->n_channels == 0)
 		return -EINVAL;
@@ -388,7 +388,7 @@ int il_mac_hw_scan(struct ieee80211_hw *hw,
 	mutex_lock(&il->mutex);
 
 	if (test_bit(STATUS_SCANNING, &il->status)) {
-		IL_DEBUG_SCAN(il, "Scan already in progress.\n");
+		D_SCAN("Scan already in progress.\n");
 		ret = -EAGAIN;
 		goto out_unlock;
 	}
@@ -400,7 +400,7 @@ int il_mac_hw_scan(struct ieee80211_hw *hw,
 
 	ret = il_scan_initiate(il, vif);
 
-	IL_DEBUG_MAC80211(il, "leave\n");
+	D_MAC80211("leave\n");
 
 out_unlock:
 	mutex_unlock(&il->mutex);
@@ -414,7 +414,7 @@ static void il_bg_scan_check(struct work_struct *data)
 	struct il_priv *il =
 	    container_of(data, struct il_priv, scan_check.work);
 
-	IL_DEBUG_SCAN(il, "Scan check work\n");
+	D_SCAN("Scan check work\n");
 
 	/* Since we are here firmware does not finish scan and
 	 * most likely is in bad shape, so we don't bother to
@@ -477,7 +477,7 @@ static void il_bg_abort_scan(struct work_struct *work)
 {
 	struct il_priv *il = container_of(work, struct il_priv, abort_scan);
 
-	IL_DEBUG_SCAN(il, "Abort scan work\n");
+	D_SCAN("Abort scan work\n");
 
 	/* We keep scan_check work queued in case when firmware will not
 	 * report back scan completed notification */
@@ -492,7 +492,7 @@ static void il_bg_scan_completed(struct work_struct *work)
 	    container_of(work, struct il_priv, scan_completed);
 	bool aborted;
 
-	IL_DEBUG_SCAN(il, "Completed scan.\n");
+	D_SCAN("Completed scan.\n");
 
 	cancel_delayed_work(&il->scan_check);
 
@@ -500,10 +500,10 @@ static void il_bg_scan_completed(struct work_struct *work)
 
 	aborted = test_and_clear_bit(STATUS_SCAN_ABORTING, &il->status);
 	if (aborted)
-		IL_DEBUG_SCAN(il, "Aborted scan completed.\n");
+		D_SCAN("Aborted scan completed.\n");
 
 	if (!test_and_clear_bit(STATUS_SCANNING, &il->status)) {
-		IL_DEBUG_SCAN(il, "Scan already completed.\n");
+		D_SCAN("Scan already completed.\n");
 		goto out_settings;
 	}
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-sta.c b/drivers/net/wireless/iwlegacy/iwl-sta.c
index 7d66e79..a48af85 100644
--- a/drivers/net/wireless/iwlegacy/iwl-sta.c
+++ b/drivers/net/wireless/iwlegacy/iwl-sta.c
@@ -46,13 +46,13 @@ static void il_sta_ucode_activate(struct il_priv *il, u8 sta_id)
 			sta_id, il->stations[sta_id].sta.sta.addr);
 
 	if (il->stations[sta_id].used & IL_STA_UCODE_ACTIVE) {
-		IL_DEBUG_ASSOC(il,
+		D_ASSOC(
 			"STA id %u addr %pM already present"
 			" in uCode (according to driver)\n",
 			sta_id, il->stations[sta_id].sta.sta.addr);
 	} else {
 		il->stations[sta_id].used |= IL_STA_UCODE_ACTIVE;
-		IL_DEBUG_ASSOC(il, "Added STA id %u addr %pM to uCode\n",
+		D_ASSOC("Added STA id %u addr %pM to uCode\n",
 				sta_id, il->stations[sta_id].sta.sta.addr);
 	}
 }
@@ -72,14 +72,14 @@ static int il_process_add_sta_resp(struct il_priv *il,
 		return ret;
 	}
 
-	IL_DEBUG_INFO(il, "Processing response for adding station %u\n",
+	D_INFO("Processing response for adding station %u\n",
 		       sta_id);
 
 	spin_lock_irqsave(&il->sta_lock, flags);
 
 	switch (pkt->u.add_sta.status) {
 	case ADD_STA_SUCCESS_MSK:
-		IL_DEBUG_INFO(il, "REPLY_ADD_STA PASSED\n");
+		D_INFO("REPLY_ADD_STA PASSED\n");
 		il_sta_ucode_activate(il, sta_id);
 		ret = 0;
 		break;
@@ -97,12 +97,12 @@ static int il_process_add_sta_resp(struct il_priv *il,
 			sta_id);
 		break;
 	default:
-		IL_DEBUG_ASSOC(il, "Received REPLY_ADD_STA:(0x%08X)\n",
+		D_ASSOC("Received REPLY_ADD_STA:(0x%08X)\n",
 				pkt->u.add_sta.status);
 		break;
 	}
 
-	IL_DEBUG_INFO(il, "%s station id %u addr %pM\n",
+	D_INFO("%s station id %u addr %pM\n",
 		       il->stations[sta_id].sta.mode ==
 		       STA_CONTROL_MODIFY_MSK ?  "Modified" : "Added",
 		       sta_id, il->stations[sta_id].sta.sta.addr);
@@ -115,7 +115,7 @@ static int il_process_add_sta_resp(struct il_priv *il,
 	 * issue has not yet been resolved and this debugging is left to
 	 * observe the problem.
 	 */
-	IL_DEBUG_INFO(il, "%s station according to cmd buffer %pM\n",
+	D_INFO("%s station according to cmd buffer %pM\n",
 		       il->stations[sta_id].sta.mode ==
 		       STA_CONTROL_MODIFY_MSK ? "Modified" : "Added",
 		       addsta->sta.addr);
@@ -148,7 +148,7 @@ int il_send_add_sta(struct il_priv *il,
 	};
 	u8 sta_id __maybe_unused = sta->sta.sta_id;
 
-	IL_DEBUG_INFO(il, "Adding sta %u (%pM) %ssynchronously\n",
+	D_INFO("Adding sta %u (%pM) %ssynchronously\n",
 		       sta_id, sta->sta.addr, flags & CMD_ASYNC ?  "a" : "");
 
 	if (flags & CMD_ASYNC)
@@ -186,7 +186,7 @@ static void il_set_ht_add_station(struct il_priv *il, u8 index,
 		goto done;
 
 	mimo_ps_mode = (sta_ht_inf->cap & IEEE80211_HT_CAP_SM_PS) >> 2;
-	IL_DEBUG_ASSOC(il, "spatial multiplexing power save mode: %s\n",
+	D_ASSOC("spatial multiplexing power save mode: %s\n",
 			(mimo_ps_mode == WLAN_HT_CAP_SM_PS_STATIC) ?
 			"static" :
 			(mimo_ps_mode == WLAN_HT_CAP_SM_PS_DYNAMIC) ?
@@ -269,7 +269,7 @@ u8 il_prep_station(struct il_priv *il, struct il_rxon_context *ctx,
 	 * another.
 	 */
 	if (il->stations[sta_id].used & IL_STA_UCODE_INPROGRESS) {
-		IL_DEBUG_INFO(il,
+		D_INFO(
 				"STA %d already in process of being added.\n",
 				sta_id);
 		return sta_id;
@@ -278,7 +278,7 @@ u8 il_prep_station(struct il_priv *il, struct il_rxon_context *ctx,
 	if ((il->stations[sta_id].used & IL_STA_DRIVER_ACTIVE) &&
 	    (il->stations[sta_id].used & IL_STA_UCODE_ACTIVE) &&
 	    !compare_ether_addr(il->stations[sta_id].sta.sta.addr, addr)) {
-		IL_DEBUG_ASSOC(il,
+		D_ASSOC(
 				"STA %d (%pM) already added, not adding again.\n",
 				sta_id, addr);
 		return sta_id;
@@ -286,7 +286,7 @@ u8 il_prep_station(struct il_priv *il, struct il_rxon_context *ctx,
 
 	station = &il->stations[sta_id];
 	station->used = IL_STA_DRIVER_ACTIVE;
-	IL_DEBUG_ASSOC(il, "Add STA to driver ID %d: %pM\n",
+	D_ASSOC("Add STA to driver ID %d: %pM\n",
 			sta_id, addr);
 	il->num_stations++;
 
@@ -355,7 +355,7 @@ il_add_station_common(struct il_priv *il,
 	 * another.
 	 */
 	if (il->stations[sta_id].used & IL_STA_UCODE_INPROGRESS) {
-		IL_DEBUG_INFO(il,
+		D_INFO(
 			"STA %d already in process of being added.\n",
 		       sta_id);
 		spin_unlock_irqrestore(&il->sta_lock, flags_spin);
@@ -364,7 +364,7 @@ il_add_station_common(struct il_priv *il,
 
 	if ((il->stations[sta_id].used & IL_STA_DRIVER_ACTIVE) &&
 	    (il->stations[sta_id].used & IL_STA_UCODE_ACTIVE)) {
-		IL_DEBUG_ASSOC(il,
+		D_ASSOC(
 			"STA %d (%pM) already added, not adding again.\n",
 			sta_id, addr);
 		spin_unlock_irqrestore(&il->sta_lock, flags_spin);
@@ -407,7 +407,7 @@ static void il_sta_ucode_deactivate(struct il_priv *il, u8 sta_id)
 	il->stations[sta_id].used &= ~IL_STA_UCODE_ACTIVE;
 
 	memset(&il->stations[sta_id], 0, sizeof(struct il_station_entry));
-	IL_DEBUG_ASSOC(il, "Removed STA %u\n", sta_id);
+	D_ASSOC("Removed STA %u\n", sta_id);
 }
 
 static int il_send_remove_station(struct il_priv *il,
@@ -454,7 +454,7 @@ static int il_send_remove_station(struct il_priv *il,
 				spin_unlock_irqrestore(&il->sta_lock,
 								flags_spin);
 			}
-			IL_DEBUG_ASSOC(il, "REPLY_REMOVE_STA PASSED\n");
+			D_ASSOC("REPLY_REMOVE_STA PASSED\n");
 			break;
 		default:
 			ret = -EIO;
@@ -476,7 +476,7 @@ int il_remove_station(struct il_priv *il, const u8 sta_id,
 	unsigned long flags;
 
 	if (!il_is_ready(il)) {
-		IL_DEBUG_INFO(il,
+		D_INFO(
 			"Unable to remove station %pM, device not ready.\n",
 			addr);
 		/*
@@ -487,7 +487,7 @@ int il_remove_station(struct il_priv *il, const u8 sta_id,
 		return 0;
 	}
 
-	IL_DEBUG_ASSOC(il, "Removing STA from driver:%d  %pM\n",
+	D_ASSOC("Removing STA from driver:%d  %pM\n",
 			sta_id, addr);
 
 	if (WARN_ON(sta_id == IL_INVALID_STATION))
@@ -496,13 +496,13 @@ int il_remove_station(struct il_priv *il, const u8 sta_id,
 	spin_lock_irqsave(&il->sta_lock, flags);
 
 	if (!(il->stations[sta_id].used & IL_STA_DRIVER_ACTIVE)) {
-		IL_DEBUG_INFO(il, "Removing %pM but non DRIVER active\n",
+		D_INFO("Removing %pM but non DRIVER active\n",
 				addr);
 		goto out_err;
 	}
 
 	if (!(il->stations[sta_id].used & IL_STA_UCODE_ACTIVE)) {
-		IL_DEBUG_INFO(il, "Removing %pM but non UCODE active\n",
+		D_INFO("Removing %pM but non UCODE active\n",
 				addr);
 		goto out_err;
 	}
@@ -542,7 +542,7 @@ void il_clear_ucode_stations(struct il_priv *il,
 	unsigned long flags_spin;
 	bool cleared = false;
 
-	IL_DEBUG_INFO(il, "Clearing ucode stations in driver\n");
+	D_INFO("Clearing ucode stations in driver\n");
 
 	spin_lock_irqsave(&il->sta_lock, flags_spin);
 	for (i = 0; i < il->hw_params.max_stations; i++) {
@@ -550,7 +550,7 @@ void il_clear_ucode_stations(struct il_priv *il,
 			continue;
 
 		if (il->stations[i].used & IL_STA_UCODE_ACTIVE) {
-			IL_DEBUG_INFO(il,
+			D_INFO(
 				"Clearing ucode active for station %d\n", i);
 			il->stations[i].used &= ~IL_STA_UCODE_ACTIVE;
 			cleared = true;
@@ -559,7 +559,7 @@ void il_clear_ucode_stations(struct il_priv *il,
 	spin_unlock_irqrestore(&il->sta_lock, flags_spin);
 
 	if (!cleared)
-		IL_DEBUG_INFO(il,
+		D_INFO(
 			"No active stations found to be cleared\n");
 }
 EXPORT_SYMBOL(il_clear_ucode_stations);
@@ -584,19 +584,19 @@ il_restore_stations(struct il_priv *il, struct il_rxon_context *ctx)
 	bool send_lq;
 
 	if (!il_is_ready(il)) {
-		IL_DEBUG_INFO(il,
+		D_INFO(
 			"Not ready yet, not restoring any stations.\n");
 		return;
 	}
 
-	IL_DEBUG_ASSOC(il, "Restoring all known stations ... start.\n");
+	D_ASSOC("Restoring all known stations ... start.\n");
 	spin_lock_irqsave(&il->sta_lock, flags_spin);
 	for (i = 0; i < il->hw_params.max_stations; i++) {
 		if (ctx->ctxid != il->stations[i].ctxid)
 			continue;
 		if ((il->stations[i].used & IL_STA_DRIVER_ACTIVE) &&
 			    !(il->stations[i].used & IL_STA_UCODE_ACTIVE)) {
-			IL_DEBUG_ASSOC(il, "Restoring sta %pM\n",
+			D_ASSOC("Restoring sta %pM\n",
 					il->stations[i].sta.sta.addr);
 			il->stations[i].sta.mode = 0;
 			il->stations[i].used |= IL_STA_UCODE_INPROGRESS;
@@ -641,10 +641,10 @@ il_restore_stations(struct il_priv *il, struct il_rxon_context *ctx)
 
 	spin_unlock_irqrestore(&il->sta_lock, flags_spin);
 	if (!found)
-		IL_DEBUG_INFO(il, "Restoring all known stations"
+		D_INFO("Restoring all known stations"
 				" .... no stations to be restored.\n");
 	else
-		IL_DEBUG_INFO(il, "Restoring all known stations"
+		D_INFO("Restoring all known stations"
 				" .... complete.\n");
 }
 EXPORT_SYMBOL(il_restore_stations);
@@ -686,13 +686,13 @@ static void il_dump_lq_cmd(struct il_priv *il,
 			   struct il_link_quality_cmd *lq)
 {
 	int i;
-	IL_DEBUG_RATE(il, "lq station id 0x%x\n", lq->sta_id);
-	IL_DEBUG_RATE(il, "lq ant 0x%X 0x%X\n",
+	D_RATE("lq station id 0x%x\n", lq->sta_id);
+	D_RATE("lq ant 0x%X 0x%X\n",
 		       lq->general_params.single_stream_ant_msk,
 		       lq->general_params.dual_stream_ant_msk);
 
 	for (i = 0; i < LINK_QUAL_MAX_RETRY_NUM; i++)
-		IL_DEBUG_RATE(il, "lq index %d 0x%X\n",
+		D_RATE("lq index %d 0x%X\n",
 			       i, lq->rs_table[i].rate_n_flags);
 }
 #else
@@ -722,12 +722,12 @@ static bool il_is_lq_table_valid(struct il_priv *il,
 	if (ctx->ht.enabled)
 		return true;
 
-	IL_DEBUG_INFO(il, "Channel %u is not an HT channel\n",
+	D_INFO("Channel %u is not an HT channel\n",
 		       ctx->active.channel);
 	for (i = 0; i < LINK_QUAL_MAX_RETRY_NUM; i++) {
 		if (le32_to_cpu(lq->rs_table[i].rate_n_flags) &
 						RATE_MCS_HT_MSK) {
-			IL_DEBUG_INFO(il,
+			D_INFO(
 				       "index %d of LQ expects HT channel\n",
 				       i);
 			return false;
@@ -782,7 +782,7 @@ int il_send_lq_cmd(struct il_priv *il, struct il_rxon_context *ctx,
 		return ret;
 
 	if (init) {
-		IL_DEBUG_INFO(il, "init LQ command complete,"
+		D_INFO("init LQ command complete,"
 				" clearing sta addition status for sta %d\n",
 			       lq->sta_id);
 		spin_lock_irqsave(&il->sta_lock, flags_spin);
@@ -801,10 +801,10 @@ int il_mac_sta_remove(struct ieee80211_hw *hw,
 	struct il_station_priv_common *sta_common = (void *)sta->drv_priv;
 	int ret;
 
-	IL_DEBUG_INFO(il, "received request to remove station %pM\n",
+	D_INFO("received request to remove station %pM\n",
 			sta->addr);
 	mutex_lock(&il->mutex);
-	IL_DEBUG_INFO(il, "proceeding to remove station %pM\n",
+	D_INFO("proceeding to remove station %pM\n",
 			sta->addr);
 	ret = il_remove_station(il, sta_common->sta_id, sta->addr);
 	if (ret)
diff --git a/drivers/net/wireless/iwlegacy/iwl-tx.c b/drivers/net/wireless/iwlegacy/iwl-tx.c
index af6ac4f..22617c4 100644
--- a/drivers/net/wireless/iwlegacy/iwl-tx.c
+++ b/drivers/net/wireless/iwlegacy/iwl-tx.c
@@ -58,7 +58,7 @@ il_txq_update_write_ptr(struct il_priv *il, struct il_tx_queue *txq)
 		reg = il_read32(il, CSR_UCODE_DRV_GP1);
 
 		if (reg & CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP) {
-			IL_DEBUG_INFO(il,
+			D_INFO(
 					"Tx queue %d requesting wakeup,"
 					" GP1 = 0x%x\n", txq_id, reg);
 			il_set_bit(il, CSR_GP_CNTRL,
@@ -511,7 +511,7 @@ int il_enqueue_hcmd(struct il_priv *il, struct il_host_cmd *cmd)
 	switch (out_cmd->hdr.cmd) {
 	case REPLY_TX_LINK_QUALITY_CMD:
 	case SENSITIVITY_CMD:
-		IL_DEBUG_HC_DUMP(il,
+		D_HC_DUMP(
 				"Sending command %s (#%x), seq: 0x%04X, "
 				"%d bytes at %d[%d]:%d\n",
 				il_get_cmd_string(out_cmd->hdr.cmd),
@@ -520,7 +520,7 @@ int il_enqueue_hcmd(struct il_priv *il, struct il_host_cmd *cmd)
 				q->write_ptr, idx, il->cmd_queue);
 		break;
 	default:
-		IL_DEBUG_HC(il, "Sending command %s (#%x), seq: 0x%04X, "
+		D_HC("Sending command %s (#%x), seq: 0x%04X, "
 				"%d bytes at %d[%d]:%d\n",
 				il_get_cmd_string(out_cmd->hdr.cmd),
 				out_cmd->hdr.cmd,
@@ -642,7 +642,7 @@ il_tx_cmd_complete(struct il_priv *il, struct il_rx_mem_buffer *rxb)
 
 	if (!(meta->flags & CMD_ASYNC)) {
 		clear_bit(STATUS_HCMD_ACTIVE, &il->status);
-		IL_DEBUG_INFO(il, "Clearing HCMD_ACTIVE for command %s\n",
+		D_INFO("Clearing HCMD_ACTIVE for command %s\n",
 			       il_get_cmd_string(cmd->hdr.cmd));
 		wake_up(&il->wait_command_queue);
 	}
diff --git a/drivers/net/wireless/iwlegacy/iwl3945-base.c b/drivers/net/wireless/iwlegacy/iwl3945-base.c
index af3f194..8aa22a0 100644
--- a/drivers/net/wireless/iwlegacy/iwl3945-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl3945-base.c
@@ -174,7 +174,7 @@ static int il3945_set_ccmp_dynamic_key_info(struct il_priv *il,
 	il->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
 	il->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
 
-	IL_DEBUG_INFO(il, "hwcrypto: modify ucode station key info\n");
+	D_INFO("hwcrypto: modify ucode station key info\n");
 
 	ret = il_send_add_sta(il,
 				&il->stations[sta_id].sta, CMD_ASYNC);
@@ -213,7 +213,7 @@ static int il3945_clear_sta_key_info(struct il_priv *il, u8 sta_id)
 	memcpy(&sta_cmd, &il->stations[sta_id].sta, sizeof(struct il_addsta_cmd));
 	spin_unlock_irqrestore(&il->sta_lock, flags);
 
-	IL_DEBUG_INFO(il, "hwcrypto: clear ucode station key info\n");
+	D_INFO("hwcrypto: clear ucode station key info\n");
 	return il_send_add_sta(il, &sta_cmd, CMD_SYNC);
 }
 
@@ -241,7 +241,7 @@ static int il3945_set_dynamic_key(struct il_priv *il,
 		ret = -EINVAL;
 	}
 
-	IL_DEBUG_WEP(il, "Set dynamic key: alg=%x len=%d idx=%d sta=%d ret=%d\n",
+	D_WEP("Set dynamic key: alg=%x len=%d idx=%d sta=%d ret=%d\n",
 		      keyconf->cipher, keyconf->keylen, keyconf->keyidx,
 		      sta_id, ret);
 
@@ -270,7 +270,7 @@ static void il3945_clear_free_frames(struct il_priv *il)
 {
 	struct list_head *element;
 
-	IL_DEBUG_INFO(il, "%d frames on pre-allocated heap on clear.\n",
+	D_INFO("%d frames on pre-allocated heap on clear.\n",
 		       il->frames_count);
 
 	while (!list_empty(&il->free_frames)) {
@@ -381,7 +381,7 @@ static void il3945_build_tx_cmd_hwcrypto(struct il_priv *il,
 	case WLAN_CIPHER_SUITE_CCMP:
 		tx_cmd->sec_ctl = TX_CMD_SEC_CCM;
 		memcpy(tx_cmd->key, keyinfo->key, keyinfo->keylen);
-		IL_DEBUG_TX(il, "tx_cmd with AES hwcrypto\n");
+		D_TX("tx_cmd with AES hwcrypto\n");
 		break;
 
 	case WLAN_CIPHER_SUITE_TKIP:
@@ -396,7 +396,7 @@ static void il3945_build_tx_cmd_hwcrypto(struct il_priv *il,
 
 		memcpy(&tx_cmd->key[3], keyinfo->key, keyinfo->keylen);
 
-		IL_DEBUG_TX(il, "Configuring packet for WEP encryption "
+		D_TX("Configuring packet for WEP encryption "
 			     "with key %d\n", info->control.hw_key->hw_key_idx);
 		break;
 
@@ -486,7 +486,7 @@ static int il3945_tx_skb(struct il_priv *il, struct sk_buff *skb)
 
 	spin_lock_irqsave(&il->lock, flags);
 	if (il_is_rfkill(il)) {
-		IL_DEBUG_DROP(il, "Dropping - RF KILL\n");
+		D_DROP("Dropping - RF KILL\n");
 		goto drop_unlock;
 	}
 
@@ -502,11 +502,11 @@ static int il3945_tx_skb(struct il_priv *il, struct sk_buff *skb)
 
 #ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
 	if (ieee80211_is_auth(fc))
-		IL_DEBUG_TX(il, "Sending AUTH frame\n");
+		D_TX("Sending AUTH frame\n");
 	else if (ieee80211_is_assoc_req(fc))
-		IL_DEBUG_TX(il, "Sending ASSOC frame\n");
+		D_TX("Sending ASSOC frame\n");
 	else if (ieee80211_is_reassoc_req(fc))
-		IL_DEBUG_TX(il, "Sending REASSOC frame\n");
+		D_TX("Sending REASSOC frame\n");
 #endif
 
 	spin_unlock_irqrestore(&il->lock, flags);
@@ -518,12 +518,12 @@ static int il3945_tx_skb(struct il_priv *il, struct sk_buff *skb)
 			il, &il->contexts[IL_RXON_CTX_BSS],
 			info->control.sta);
 	if (sta_id == IL_INVALID_STATION) {
-		IL_DEBUG_DROP(il, "Dropping - INVALID STATION: %pM\n",
+		D_DROP("Dropping - INVALID STATION: %pM\n",
 			       hdr->addr1);
 		goto drop;
 	}
 
-	IL_DEBUG_RATE(il, "station Id %d\n", sta_id);
+	D_RATE("station Id %d\n", sta_id);
 
 	if (ieee80211_is_data_qos(fc)) {
 		u8 *qc = ieee80211_get_qos_ctl(hdr);
@@ -594,9 +594,9 @@ static int il3945_tx_skb(struct il_priv *il, struct sk_buff *skb)
 		txq->need_update = 0;
 	}
 
-	IL_DEBUG_TX(il, "sequence nr = 0X%x\n",
+	D_TX("sequence nr = 0X%x\n",
 		     le16_to_cpu(out_cmd->hdr.sequence));
-	IL_DEBUG_TX(il, "tx_flags = 0X%x\n", le32_to_cpu(tx_cmd->tx_flags));
+	D_TX("tx_flags = 0X%x\n", le32_to_cpu(tx_cmd->tx_flags));
 	il_print_hex_dump(il, IL_DL_TX, tx_cmd, sizeof(*tx_cmd));
 	il_print_hex_dump(il, IL_DL_TX, (u8 *)tx_cmd->hdr,
 			   ieee80211_hdrlen(fc));
@@ -726,7 +726,7 @@ static int il3945_get_measurement(struct il_priv *il,
 	switch (spectrum_resp_status) {
 	case 0:		/* Command will be handled */
 		if (pkt->u.spectrum.id != 0xff) {
-			IL_DEBUG_INFO(il, "Replaced existing measurement: %d\n",
+			D_INFO("Replaced existing measurement: %d\n",
 						pkt->u.spectrum.id);
 			il->measurement_status &= ~MEASUREMENT_READY;
 		}
@@ -753,18 +753,18 @@ static void il3945_rx_reply_alive(struct il_priv *il,
 
 	palive = &pkt->u.alive_frame;
 
-	IL_DEBUG_INFO(il, "Alive ucode status 0x%08X revision "
+	D_INFO("Alive ucode status 0x%08X revision "
 		       "0x%01X 0x%01X\n",
 		       palive->is_valid, palive->ver_type,
 		       palive->ver_subtype);
 
 	if (palive->ver_subtype == INITIALIZE_SUBTYPE) {
-		IL_DEBUG_INFO(il, "Initialization Alive received.\n");
+		D_INFO("Initialization Alive received.\n");
 		memcpy(&il->card_alive_init, &pkt->u.alive_frame,
 		       sizeof(struct il_alive_resp));
 		pwork = &il->init_alive_start;
 	} else {
-		IL_DEBUG_INFO(il, "Runtime Alive received.\n");
+		D_INFO("Runtime Alive received.\n");
 		memcpy(&il->card_alive, &pkt->u.alive_frame,
 		       sizeof(struct il_alive_resp));
 		pwork = &il->alive_start;
@@ -787,7 +787,7 @@ static void il3945_rx_reply_add_sta(struct il_priv *il,
 	struct il_rx_packet *pkt = rxb_addr(rxb);
 #endif
 
-	IL_DEBUG_RX(il, "Received REPLY_ADD_STA: 0x%02X\n", pkt->u.status);
+	D_RX("Received REPLY_ADD_STA: 0x%02X\n", pkt->u.status);
 }
 
 static void il3945_rx_beacon_notif(struct il_priv *il,
@@ -798,7 +798,7 @@ static void il3945_rx_beacon_notif(struct il_priv *il,
 #ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
 	u8 rate = beacon->beacon_notify_hdr.rate;
 
-	IL_DEBUG_RX(il, "beacon status %x retries %d iss %d "
+	D_RX("beacon status %x retries %d iss %d "
 		"tsf %d %d rate %d\n",
 		le32_to_cpu(beacon->beacon_notify_hdr.status) & TX_STATUS_MSK,
 		beacon->beacon_notify_hdr.failure_frame,
@@ -1040,7 +1040,7 @@ static void il3945_rx_allocate(struct il_priv *il, gfp_t priority)
 		page = alloc_pages(gfp_mask, il->hw_params.rx_page_order);
 		if (!page) {
 			if (net_ratelimit())
-				IL_DEBUG_INFO(il, "Failed to allocate SKB buffer.\n");
+				D_INFO("Failed to allocate SKB buffer.\n");
 			if ((rxq->free_count <= RX_LOW_WATERMARK) &&
 			    net_ratelimit())
 				IL_CRIT(il, "Failed to allocate SKB buffer with %s. Only %u free buffers remaining.\n",
@@ -1225,7 +1225,7 @@ static void il3945_rx_handle(struct il_priv *il)
 		fill_rx = 1;
 	/* Rx interrupt, but nothing sent from uCode */
 	if (i == r)
-		IL_DEBUG_RX(il, "r = %d, i = %d\n", r, i);
+		D_RX("r = %d, i = %d\n", r, i);
 
 	while (i != r) {
 		int len;
@@ -1261,13 +1261,13 @@ static void il3945_rx_handle(struct il_priv *il)
 		 *   handle those that need handling via function in
 		 *   rx_handlers table.  See il3945_setup_rx_handlers() */
 		if (il->rx_handlers[pkt->hdr.cmd]) {
-			IL_DEBUG_RX(il, "r = %d, i = %d, %s, 0x%02x\n", r, i,
+			D_RX("r = %d, i = %d, %s, 0x%02x\n", r, i,
 			il_get_cmd_string(pkt->hdr.cmd), pkt->hdr.cmd);
 			il->isr_stats.rx_handlers[pkt->hdr.cmd]++;
 			il->rx_handlers[pkt->hdr.cmd] (il, rxb);
 		} else {
 			/* No handling needed */
-			IL_DEBUG_RX(il,
+			D_RX(
 				"r %d i %d No handler needed for %s, 0x%02x\n",
 				r, i, il_get_cmd_string(pkt->hdr.cmd),
 				pkt->hdr.cmd);
@@ -1432,7 +1432,7 @@ static void il3945_irq_tasklet(struct il_priv *il)
 	if (il_get_debug_level(il) & IL_DL_ISR) {
 		/* just for debug */
 		inta_mask = il_read32(il, CSR_INT_MASK);
-		IL_DEBUG_ISR(il, "inta 0x%08x, enabled 0x%08x, fh 0x%08x\n",
+		D_ISR("inta 0x%08x, enabled 0x%08x, fh 0x%08x\n",
 			      inta, inta_mask, inta_fh);
 	}
 #endif
@@ -1467,14 +1467,14 @@ static void il3945_irq_tasklet(struct il_priv *il)
 	if (il_get_debug_level(il) & (IL_DL_ISR)) {
 		/* NIC fires this, but we don't use it, redundant with WAKEUP */
 		if (inta & CSR_INT_BIT_SCD) {
-			IL_DEBUG_ISR(il, "Scheduler finished to transmit "
+			D_ISR("Scheduler finished to transmit "
 				      "the frame/frames.\n");
 			il->isr_stats.sch++;
 		}
 
 		/* Alive notification via Rx interrupt will do the real work */
 		if (inta & CSR_INT_BIT_ALIVE) {
-			IL_DEBUG_ISR(il, "Alive interrupt\n");
+			D_ISR("Alive interrupt\n");
 			il->isr_stats.alive++;
 		}
 	}
@@ -1493,7 +1493,7 @@ static void il3945_irq_tasklet(struct il_priv *il)
 
 	/* uCode wakes up after power-down sleep */
 	if (inta & CSR_INT_BIT_WAKEUP) {
-		IL_DEBUG_ISR(il, "Wakeup interrupt\n");
+		D_ISR("Wakeup interrupt\n");
 		il_rx_queue_update_write_ptr(il, &il->rxq);
 		il_txq_update_write_ptr(il, &il->txq[0]);
 		il_txq_update_write_ptr(il, &il->txq[1]);
@@ -1516,7 +1516,7 @@ static void il3945_irq_tasklet(struct il_priv *il)
 	}
 
 	if (inta & CSR_INT_BIT_FH_TX) {
-		IL_DEBUG_ISR(il, "Tx interrupt\n");
+		D_ISR("Tx interrupt\n");
 		il->isr_stats.tx++;
 
 		il_write32(il, CSR_FH_INT_STATUS, (1 << 6));
@@ -1546,7 +1546,7 @@ static void il3945_irq_tasklet(struct il_priv *il)
 		inta = il_read32(il, CSR_INT);
 		inta_mask = il_read32(il, CSR_INT_MASK);
 		inta_fh = il_read32(il, CSR_FH_INT_STATUS);
-		IL_DEBUG_ISR(il, "End inta 0x%08x, enabled 0x%08x, fh 0x%08x, "
+		D_ISR("End inta 0x%08x, enabled 0x%08x, fh 0x%08x, "
 			"flags 0x%08lx\n", inta, inta_mask, inta_fh, flags);
 	}
 #endif
@@ -1586,7 +1586,7 @@ static int il3945_get_channels_for_scan(struct il_priv *il,
 		ch_info = il_get_channel_info(il, band,
 							scan_ch->channel);
 		if (!il_is_channel_valid(ch_info)) {
-			IL_DEBUG_SCAN(il,
+			D_SCAN(
 				"Channel %d is INVALID for this band.\n",
 			       scan_ch->channel);
 			continue;
@@ -1635,7 +1635,7 @@ static int il3945_get_channels_for_scan(struct il_priv *il,
 			 */
 		}
 
-		IL_DEBUG_SCAN(il, "Scanning %d [%s %d]\n",
+		D_SCAN("Scanning %d [%s %d]\n",
 			       scan_ch->channel,
 			       (scan_ch->type & 1) ? "ACTIVE" : "PASSIVE",
 			       (scan_ch->type & 1) ?
@@ -1645,7 +1645,7 @@ static int il3945_get_channels_for_scan(struct il_priv *il,
 		added++;
 	}
 
-	IL_DEBUG_SCAN(il, "total channels to scan %d\n", added);
+	D_SCAN("total channels to scan %d\n", added);
 	return added;
 }
 
@@ -1696,7 +1696,7 @@ static int il3945_verify_inst_full(struct il_priv *il, __le32 *image, u32 len)
 	int rc = 0;
 	u32 errcnt;
 
-	IL_DEBUG_INFO(il, "ucode inst image size is %u\n", len);
+	D_INFO("ucode inst image size is %u\n", len);
 
 	il_write_direct32(il, HBUS_TARG_MEM_RADDR,
 			       IWL39_RTC_INST_LOWER_BOUND);
@@ -1720,7 +1720,7 @@ static int il3945_verify_inst_full(struct il_priv *il, __le32 *image, u32 len)
 
 
 	if (!errcnt)
-		IL_DEBUG_INFO(il,
+		D_INFO(
 			"ucode image in INSTRUCTION memory is good\n");
 
 	return rc;
@@ -1739,7 +1739,7 @@ static int il3945_verify_inst_sparse(struct il_priv *il, __le32 *image, u32 len)
 	u32 errcnt = 0;
 	u32 i;
 
-	IL_DEBUG_INFO(il, "ucode inst image size is %u\n", len);
+	D_INFO("ucode inst image size is %u\n", len);
 
 	for (i = 0; i < len; i += 100, image += 100/sizeof(u32)) {
 		/* read data comes through single port, auto-incr addr */
@@ -1780,7 +1780,7 @@ static int il3945_verify_ucode(struct il_priv *il)
 	len = il->ucode_boot.len;
 	rc = il3945_verify_inst_sparse(il, image, len);
 	if (rc == 0) {
-		IL_DEBUG_INFO(il, "Bootstrap uCode is good in inst SRAM\n");
+		D_INFO("Bootstrap uCode is good in inst SRAM\n");
 		return 0;
 	}
 
@@ -1789,7 +1789,7 @@ static int il3945_verify_ucode(struct il_priv *il)
 	len = il->ucode_init.len;
 	rc = il3945_verify_inst_sparse(il, image, len);
 	if (rc == 0) {
-		IL_DEBUG_INFO(il, "Initialize uCode is good in inst SRAM\n");
+		D_INFO("Initialize uCode is good in inst SRAM\n");
 		return 0;
 	}
 
@@ -1798,7 +1798,7 @@ static int il3945_verify_ucode(struct il_priv *il)
 	len = il->ucode_code.len;
 	rc = il3945_verify_inst_sparse(il, image, len);
 	if (rc == 0) {
-		IL_DEBUG_INFO(il, "Runtime uCode is good in inst SRAM\n");
+		D_INFO("Runtime uCode is good in inst SRAM\n");
 		return 0;
 	}
 
@@ -1879,7 +1879,7 @@ static int il3945_read_ucode(struct il_priv *il)
 					"which is deprecated. "
 					" Please use API v%u instead.\n",
 					  buf, api_max);
-			IL_DEBUG_INFO(il, "Got firmware '%s' file "
+			D_INFO("Got firmware '%s' file "
 				       "(%zd bytes) from disk\n",
 				       buf, ucode_raw->size);
 			break;
@@ -1940,17 +1940,17 @@ static int il3945_read_ucode(struct il_priv *il)
 		 IL_UCODE_API(il->ucode_ver),
 		 IL_UCODE_SERIAL(il->ucode_ver));
 
-	IL_DEBUG_INFO(il, "f/w package hdr ucode version raw = 0x%x\n",
+	D_INFO("f/w package hdr ucode version raw = 0x%x\n",
 		       il->ucode_ver);
-	IL_DEBUG_INFO(il, "f/w package hdr runtime inst size = %u\n",
+	D_INFO("f/w package hdr runtime inst size = %u\n",
 		       inst_size);
-	IL_DEBUG_INFO(il, "f/w package hdr runtime data size = %u\n",
+	D_INFO("f/w package hdr runtime data size = %u\n",
 		       data_size);
-	IL_DEBUG_INFO(il, "f/w package hdr init inst size = %u\n",
+	D_INFO("f/w package hdr init inst size = %u\n",
 		       init_size);
-	IL_DEBUG_INFO(il, "f/w package hdr init data size = %u\n",
+	D_INFO("f/w package hdr init data size = %u\n",
 		       init_data_size);
-	IL_DEBUG_INFO(il, "f/w package hdr boot inst size = %u\n",
+	D_INFO("f/w package hdr boot inst size = %u\n",
 		       boot_size);
 
 
@@ -1959,7 +1959,7 @@ static int il3945_read_ucode(struct il_priv *il)
 		inst_size + data_size + init_size +
 		init_data_size + boot_size) {
 
-		IL_DEBUG_INFO(il,
+		D_INFO(
 			"uCode file size %zd does not match expected size\n",
 			ucode_raw->size);
 		ret = -EINVAL;
@@ -1968,34 +1968,34 @@ static int il3945_read_ucode(struct il_priv *il)
 
 	/* Verify that uCode images will fit in card's SRAM */
 	if (inst_size > IWL39_MAX_INST_SIZE) {
-		IL_DEBUG_INFO(il, "uCode instr len %d too large to fit in\n",
+		D_INFO("uCode instr len %d too large to fit in\n",
 			       inst_size);
 		ret = -EINVAL;
 		goto err_release;
 	}
 
 	if (data_size > IWL39_MAX_DATA_SIZE) {
-		IL_DEBUG_INFO(il, "uCode data len %d too large to fit in\n",
+		D_INFO("uCode data len %d too large to fit in\n",
 			       data_size);
 		ret = -EINVAL;
 		goto err_release;
 	}
 	if (init_size > IWL39_MAX_INST_SIZE) {
-		IL_DEBUG_INFO(il,
+		D_INFO(
 				"uCode init instr len %d too large to fit in\n",
 				init_size);
 		ret = -EINVAL;
 		goto err_release;
 	}
 	if (init_data_size > IWL39_MAX_DATA_SIZE) {
-		IL_DEBUG_INFO(il,
+		D_INFO(
 				"uCode init data len %d too large to fit in\n",
 				init_data_size);
 		ret = -EINVAL;
 		goto err_release;
 	}
 	if (boot_size > IWL39_MAX_BSM_SIZE) {
-		IL_DEBUG_INFO(il,
+		D_INFO(
 				"uCode boot instr len %d too large to fit in\n",
 				boot_size);
 		ret = -EINVAL;
@@ -2045,18 +2045,18 @@ static int il3945_read_ucode(struct il_priv *il)
 
 	/* Runtime instructions (first block of data in file) */
 	len = inst_size;
-	IL_DEBUG_INFO(il,
+	D_INFO(
 		"Copying (but not loading) uCode instr len %zd\n", len);
 	memcpy(il->ucode_code.v_addr, src, len);
 	src += len;
 
-	IL_DEBUG_INFO(il, "uCode instr buf vaddr = 0x%p, paddr = 0x%08x\n",
+	D_INFO("uCode instr buf vaddr = 0x%p, paddr = 0x%08x\n",
 		il->ucode_code.v_addr, (u32)il->ucode_code.p_addr);
 
 	/* Runtime data (2nd block)
 	 * NOTE:  Copy into backup buffer will be done in il3945_up()  */
 	len = data_size;
-	IL_DEBUG_INFO(il,
+	D_INFO(
 		"Copying (but not loading) uCode data len %zd\n", len);
 	memcpy(il->ucode_data.v_addr, src, len);
 	memcpy(il->ucode_data_backup.v_addr, src, len);
@@ -2065,7 +2065,7 @@ static int il3945_read_ucode(struct il_priv *il)
 	/* Initialization instructions (3rd block) */
 	if (init_size) {
 		len = init_size;
-		IL_DEBUG_INFO(il,
+		D_INFO(
 			"Copying (but not loading) init instr len %zd\n", len);
 		memcpy(il->ucode_init.v_addr, src, len);
 		src += len;
@@ -2074,7 +2074,7 @@ static int il3945_read_ucode(struct il_priv *il)
 	/* Initialization data (4th block) */
 	if (init_data_size) {
 		len = init_data_size;
-		IL_DEBUG_INFO(il,
+		D_INFO(
 			"Copying (but not loading) init data len %zd\n", len);
 		memcpy(il->ucode_init_data.v_addr, src, len);
 		src += len;
@@ -2082,7 +2082,7 @@ static int il3945_read_ucode(struct il_priv *il)
 
 	/* Bootstrap instructions (5th block) */
 	len = boot_size;
-	IL_DEBUG_INFO(il,
+	D_INFO(
 		"Copying (but not loading) boot instr len %zd\n", len);
 	memcpy(il->ucode_boot.v_addr, src, len);
 
@@ -2132,7 +2132,7 @@ static int il3945_set_ucode_ptrs(struct il_priv *il)
 	il_write_prph(il, BSM_DRAM_INST_BYTECOUNT_REG,
 				 il->ucode_code.len | BSM_DRAM_INST_LOAD);
 
-	IL_DEBUG_INFO(il, "Runtime uCode pointers are set.\n");
+	D_INFO("Runtime uCode pointers are set.\n");
 
 	return 0;
 }
@@ -2150,7 +2150,7 @@ static void il3945_init_alive_start(struct il_priv *il)
 	if (il->card_alive_init.is_valid != UCODE_VALID_OK) {
 		/* We had an error bringing up the hardware, so take it
 		 * all the way back down so we can try again */
-		IL_DEBUG_INFO(il, "Initialize Alive failed.\n");
+		D_INFO("Initialize Alive failed.\n");
 		goto restart;
 	}
 
@@ -2160,18 +2160,18 @@ static void il3945_init_alive_start(struct il_priv *il)
 	if (il3945_verify_ucode(il)) {
 		/* Runtime instruction load was bad;
 		 * take it all the way back down so we can try again */
-		IL_DEBUG_INFO(il, "Bad \"initialize\" uCode load.\n");
+		D_INFO("Bad \"initialize\" uCode load.\n");
 		goto restart;
 	}
 
 	/* Send pointers to protocol/runtime uCode image ... init code will
 	 * load and launch runtime uCode, which will send us another "Alive"
 	 * notification. */
-	IL_DEBUG_INFO(il, "Initialization Alive received.\n");
+	D_INFO("Initialization Alive received.\n");
 	if (il3945_set_ucode_ptrs(il)) {
 		/* Runtime instruction load won't happen;
 		 * take it all the way back down so we can try again */
-		IL_DEBUG_INFO(il, "Couldn't set up uCode pointers.\n");
+		D_INFO("Couldn't set up uCode pointers.\n");
 		goto restart;
 	}
 	return;
@@ -2191,12 +2191,12 @@ static void il3945_alive_start(struct il_priv *il)
 	u32 rfkill;
 	struct il_rxon_context *ctx = &il->contexts[IL_RXON_CTX_BSS];
 
-	IL_DEBUG_INFO(il, "Runtime Alive received.\n");
+	D_INFO("Runtime Alive received.\n");
 
 	if (il->card_alive.is_valid != UCODE_VALID_OK) {
 		/* We had an error bringing up the hardware, so take it
 		 * all the way back down so we can try again */
-		IL_DEBUG_INFO(il, "Alive failed.\n");
+		D_INFO("Alive failed.\n");
 		goto restart;
 	}
 
@@ -2206,12 +2206,12 @@ static void il3945_alive_start(struct il_priv *il)
 	if (il3945_verify_ucode(il)) {
 		/* Runtime instruction load was bad;
 		 * take it all the way back down so we can try again */
-		IL_DEBUG_INFO(il, "Bad runtime uCode load.\n");
+		D_INFO("Bad runtime uCode load.\n");
 		goto restart;
 	}
 
 	rfkill = il_read_prph(il, APMG_RFKILL_REG);
-	IL_DEBUG_INFO(il, "RFKILL status: 0x%x\n", rfkill);
+	D_INFO("RFKILL status: 0x%x\n", rfkill);
 
 	if (rfkill & 0x1) {
 		clear_bit(STATUS_RF_KILL_HW, &il->status);
@@ -2223,7 +2223,7 @@ static void il3945_alive_start(struct il_priv *il)
 		}
 
 		if (thermal_spin)
-			IL_DEBUG_INFO(il, "Thermal calibration took %dus\n",
+			D_INFO("Thermal calibration took %dus\n",
 				       thermal_spin * 10);
 	} else
 		set_bit(STATUS_RF_KILL_HW, &il->status);
@@ -2264,7 +2264,7 @@ static void il3945_alive_start(struct il_priv *il)
 
 	il3945_reg_txpower_periodic(il);
 
-	IL_DEBUG_INFO(il, "ALIVE processing complete.\n");
+	D_INFO("ALIVE processing complete.\n");
 	wake_up(&il->wait_command_queue);
 
 	return;
@@ -2280,7 +2280,7 @@ static void __il3945_down(struct il_priv *il)
 	unsigned long flags;
 	int exit_pending;
 
-	IL_DEBUG_INFO(il, DRV_NAME " is going down\n");
+	D_INFO(DRV_NAME " is going down\n");
 
 	il_scan_cancel_timeout(il, 200);
 
@@ -2468,7 +2468,7 @@ static int __il3945_up(struct il_priv *il)
 		/* start card; "initialize" will load runtime ucode */
 		il3945_nic_start(il);
 
-		IL_DEBUG_INFO(il, DRV_NAME " is coming up\n");
+		D_INFO(DRV_NAME " is coming up\n");
 
 		return 0;
 	}
@@ -2540,7 +2540,7 @@ static void il3945_rfkill_poll(struct work_struct *data)
 
 		wiphy_rfkill_set_hw_state(il->hw->wiphy, new_rfkill);
 
-		IL_DEBUG_RF_KILL(il, "RF_KILL bit toggled to %s.\n",
+		D_RF_KILL("RF_KILL bit toggled to %s.\n",
 				new_rfkill ? "disable radio" : "enable radio");
 	}
 
@@ -2571,7 +2571,7 @@ int il3945_request_scan(struct il_priv *il, struct ieee80211_vif *vif)
 		il->scan_cmd = kmalloc(sizeof(struct il3945_scan_cmd) +
 					 IL_MAX_SCAN_SIZE, GFP_KERNEL);
 		if (!il->scan_cmd) {
-			IL_DEBUG_SCAN(il, "Fail to allocate scan memory\n");
+			D_SCAN("Fail to allocate scan memory\n");
 			return -ENOMEM;
 		}
 	}
@@ -2587,7 +2587,7 @@ int il3945_request_scan(struct il_priv *il, struct ieee80211_vif *vif)
 		u32 suspend_time = 100;
 		u32 scan_suspend_time = 100;
 
-		IL_DEBUG_INFO(il, "Scanning while associated...\n");
+		D_INFO("Scanning while associated...\n");
 
 		interval = vif->bss_conf.beacon_int;
 
@@ -2607,13 +2607,13 @@ int il3945_request_scan(struct il_priv *il, struct ieee80211_vif *vif)
 		    (extra | ((suspend_time % interval) * 1024));
 
 		scan->suspend_time = cpu_to_le32(scan_suspend_time);
-		IL_DEBUG_SCAN(il, "suspend_time 0x%X beacon interval %d\n",
+		D_SCAN("suspend_time 0x%X beacon interval %d\n",
 			       scan_suspend_time, interval);
 	}
 
 	if (il->scan_request->n_ssids) {
 		int i, p = 0;
-		IL_DEBUG_SCAN(il, "Kicking off active scan\n");
+		D_SCAN("Kicking off active scan\n");
 		for (i = 0; i < il->scan_request->n_ssids; i++) {
 			/* always does wildcard anyway */
 			if (!il->scan_request->ssids[i].ssid_len)
@@ -2629,7 +2629,7 @@ int il3945_request_scan(struct il_priv *il, struct ieee80211_vif *vif)
 		}
 		is_active = true;
 	} else
-		IL_DEBUG_SCAN(il, "Kicking off passive scan.\n");
+		D_SCAN("Kicking off passive scan.\n");
 
 	/* We don't build a direct scan probe request; the uCode will do
 	 * that based on the direct_mask added to each channel entry */
@@ -2674,7 +2674,7 @@ int il3945_request_scan(struct il_priv *il, struct ieee80211_vif *vif)
 	scan->channel_count = il3945_get_channels_for_scan(il, band, is_active, n_probes,
 							    (void *)&scan->data[len], vif);
 	if (scan->channel_count == 0) {
-		IL_DEBUG_SCAN(il, "channel count %d\n", scan->channel_count);
+		D_SCAN("channel count %d\n", scan->channel_count);
 		return -EIO;
 	}
 
@@ -2755,7 +2755,7 @@ void il3945_post_associate(struct il_priv *il)
 	if (!ctx->vif || !il->is_open)
 		return;
 
-	IL_DEBUG_ASSOC(il, "Associated as %d to: %pM\n",
+	D_ASSOC("Associated as %d to: %pM\n",
 			ctx->vif->bss_conf.aid, ctx->active.bssid_addr);
 
 	if (test_bit(STATUS_EXIT_PENDING, &il->status))
@@ -2777,7 +2777,7 @@ void il3945_post_associate(struct il_priv *il)
 
 	ctx->staging.assoc_id = cpu_to_le16(ctx->vif->bss_conf.aid);
 
-	IL_DEBUG_ASSOC(il, "assoc id %d beacon interval %d\n",
+	D_ASSOC("assoc id %d beacon interval %d\n",
 			ctx->vif->bss_conf.aid, ctx->vif->bss_conf.beacon_int);
 
 	if (ctx->vif->bss_conf.use_short_preamble)
@@ -2821,7 +2821,7 @@ static int il3945_mac_start(struct ieee80211_hw *hw)
 	struct il_priv *il = hw->priv;
 	int ret;
 
-	IL_DEBUG_MAC80211(il, "enter\n");
+	D_MAC80211("enter\n");
 
 	/* we should be verifying the device is ready to be opened */
 	mutex_lock(&il->mutex);
@@ -2845,7 +2845,7 @@ static int il3945_mac_start(struct ieee80211_hw *hw)
 	if (ret)
 		goto out_release_irq;
 
-	IL_DEBUG_INFO(il, "Start UP work.\n");
+	D_INFO("Start UP work.\n");
 
 	/* Wait for START_ALIVE from ucode. Otherwise callbacks from
 	 * mac80211 will not be run successfully. */
@@ -2867,12 +2867,12 @@ static int il3945_mac_start(struct ieee80211_hw *hw)
 	cancel_delayed_work(&il->_3945.rfkill_poll);
 
 	il->is_open = 1;
-	IL_DEBUG_MAC80211(il, "leave\n");
+	D_MAC80211("leave\n");
 	return 0;
 
 out_release_irq:
 	il->is_open = 0;
-	IL_DEBUG_MAC80211(il, "leave - failed\n");
+	D_MAC80211("leave - failed\n");
 	return ret;
 }
 
@@ -2880,10 +2880,10 @@ static void il3945_mac_stop(struct ieee80211_hw *hw)
 {
 	struct il_priv *il = hw->priv;
 
-	IL_DEBUG_MAC80211(il, "enter\n");
+	D_MAC80211("enter\n");
 
 	if (!il->is_open) {
-		IL_DEBUG_MAC80211(il, "leave - skip\n");
+		D_MAC80211("leave - skip\n");
 		return;
 	}
 
@@ -2897,22 +2897,22 @@ static void il3945_mac_stop(struct ieee80211_hw *hw)
 	queue_delayed_work(il->workqueue, &il->_3945.rfkill_poll,
 			   round_jiffies_relative(2 * HZ));
 
-	IL_DEBUG_MAC80211(il, "leave\n");
+	D_MAC80211("leave\n");
 }
 
 static void il3945_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct il_priv *il = hw->priv;
 
-	IL_DEBUG_MAC80211(il, "enter\n");
+	D_MAC80211("enter\n");
 
-	IL_DEBUG_TX(il, "dev->xmit(%d bytes) at rate 0x%02x\n", skb->len,
+	D_TX("dev->xmit(%d bytes) at rate 0x%02x\n", skb->len,
 		     ieee80211_get_tx_rate(hw, IEEE80211_SKB_CB(skb))->bitrate);
 
 	if (il3945_tx_skb(il, skb))
 		dev_kfree_skb_any(skb);
 
-	IL_DEBUG_MAC80211(il, "leave\n");
+	D_MAC80211("leave\n");
 }
 
 void il3945_config_ap(struct il_priv *il)
@@ -2971,10 +2971,10 @@ static int il3945_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	u8 sta_id = IL_INVALID_STATION;
 	u8 static_key;
 
-	IL_DEBUG_MAC80211(il, "enter\n");
+	D_MAC80211("enter\n");
 
 	if (il3945_mod_params.sw_crypto) {
-		IL_DEBUG_MAC80211(il, "leave - hwcrypto disabled\n");
+		D_MAC80211("leave - hwcrypto disabled\n");
 		return -EOPNOTSUPP;
 	}
 
@@ -3004,21 +3004,21 @@ static int il3945_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			ret = il3945_set_static_key(il, key);
 		else
 			ret = il3945_set_dynamic_key(il, key, sta_id);
-		IL_DEBUG_MAC80211(il, "enable hwcrypto key\n");
+		D_MAC80211("enable hwcrypto key\n");
 		break;
 	case DISABLE_KEY:
 		if (static_key)
 			ret = il3945_remove_static_key(il);
 		else
 			ret = il3945_clear_sta_key_info(il, sta_id);
-		IL_DEBUG_MAC80211(il, "disable hwcrypto key\n");
+		D_MAC80211("disable hwcrypto key\n");
 		break;
 	default:
 		ret = -EINVAL;
 	}
 
 	mutex_unlock(&il->mutex);
-	IL_DEBUG_MAC80211(il, "leave\n");
+	D_MAC80211("leave\n");
 
 	return ret;
 }
@@ -3033,10 +3033,10 @@ static int il3945_mac_sta_add(struct ieee80211_hw *hw,
 	bool is_ap = vif->type == NL80211_IFTYPE_STATION;
 	u8 sta_id;
 
-	IL_DEBUG_INFO(il, "received request to add station %pM\n",
+	D_INFO("received request to add station %pM\n",
 			sta->addr);
 	mutex_lock(&il->mutex);
-	IL_DEBUG_INFO(il, "proceeding to add station %pM\n",
+	D_INFO("proceeding to add station %pM\n",
 			sta->addr);
 	sta_priv->common.sta_id = IL_INVALID_STATION;
 
@@ -3055,7 +3055,7 @@ static int il3945_mac_sta_add(struct ieee80211_hw *hw,
 	sta_priv->common.sta_id = sta_id;
 
 	/* Initialize rate scaling */
-	IL_DEBUG_INFO(il, "Initializing rate scaling for station %pM\n",
+	D_INFO("Initializing rate scaling for station %pM\n",
 		       sta->addr);
 	il3945_rs_rate_init(il, sta, sta_id);
 	mutex_unlock(&il->mutex);
@@ -3079,7 +3079,7 @@ static void il3945_configure_filter(struct ieee80211_hw *hw,
 		filter_nand |= (flag);		\
 	} while (0)
 
-	IL_DEBUG_MAC80211(il, "Enter: changed: 0x%x, total: 0x%x\n",
+	D_MAC80211("Enter: changed: 0x%x, total: 0x%x\n",
 			changed_flags, *total_flags);
 
 	CHK(FIF_OTHER_BSS | FIF_PROMISC_IN_BSS, RXON_FILTER_PROMISC_MSK);
@@ -3224,7 +3224,7 @@ static ssize_t il3945_store_flags(struct device *d,
 		if (il_scan_cancel_timeout(il, 100))
 			IL_WARN(il, "Could not cancel scan.\n");
 		else {
-			IL_DEBUG_INFO(il, "Committing rxon.flags = 0x%04X\n",
+			D_INFO("Committing rxon.flags = 0x%04X\n",
 				       flags);
 			ctx->staging.flags = cpu_to_le32(flags);
 			il3945_commit_rxon(il, ctx);
@@ -3261,7 +3261,7 @@ static ssize_t il3945_store_filter_flags(struct device *d,
 		if (il_scan_cancel_timeout(il, 100))
 			IL_WARN(il, "Could not cancel scan.\n");
 		else {
-			IL_DEBUG_INFO(il, "Committing rxon.filter_flags = "
+			D_INFO("Committing rxon.filter_flags = "
 				       "0x%04X\n", filter_flags);
 			ctx->staging.filter_flags =
 				cpu_to_le32(filter_flags);
@@ -3337,7 +3337,7 @@ static ssize_t il3945_store_measurement(struct device *d,
 			type = simple_strtoul(p + 1, NULL, 0);
 	}
 
-	IL_DEBUG_INFO(il, "Invoking measurement of type %d on "
+	D_INFO("Invoking measurement of type %d on "
 		       "channel %d (for '%s')\n", type, params.channel, buf);
 	il3945_get_measurement(il, &params, type);
 
@@ -3402,15 +3402,15 @@ static ssize_t il3945_store_antenna(struct device *d,
 		return 0;
 
 	if (sscanf(buf, "%1i", &ant) != 1) {
-		IL_DEBUG_INFO(il, "not in hex or decimal form.\n");
+		D_INFO("not in hex or decimal form.\n");
 		return count;
 	}
 
 	if ((ant >= 0) && (ant <= 2)) {
-		IL_DEBUG_INFO(il, "Setting antenna select to %d.\n", ant);
+		D_INFO("Setting antenna select to %d.\n", ant);
 		il3945_mod_params.antenna = (enum il3945_antenna)ant;
 	} else
-		IL_DEBUG_INFO(il, "Bad antenna select value %d.\n", ant);
+		D_INFO("Bad antenna select value %d.\n", ant);
 
 
 	return count;
@@ -3682,11 +3682,11 @@ static int il3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *en
 	 * "the hard way", rather than using device's scan.
 	 */
 	if (il3945_mod_params.disable_hw_scan) {
-		IL_DEBUG_INFO(il, "Disabling hw_scan\n");
+		D_INFO("Disabling hw_scan\n");
 		il3945_hw_ops.hw_scan = NULL;
 	}
 
-	IL_DEBUG_INFO(il, "*** LOAD DRIVER ***\n");
+	D_INFO("*** LOAD DRIVER ***\n");
 	il->cfg = cfg;
 	il->pci_dev = pdev;
 	il->inta_mask = CSR_INI_SET_MASK;
@@ -3729,9 +3729,9 @@ static int il3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *en
 		goto out_pci_release_regions;
 	}
 
-	IL_DEBUG_INFO(il, "pci_resource_len = 0x%08llx\n",
+	D_INFO("pci_resource_len = 0x%08llx\n",
 			(unsigned long long) pci_resource_len(pdev, 0));
-	IL_DEBUG_INFO(il, "pci_resource_base = %p\n", il->hw_base);
+	D_INFO("pci_resource_base = %p\n", il->hw_base);
 
 	/* We disable the RETRY_TIMEOUT register (0x41) to keep
 	 * PCI Tx retries from interfering with C3 CPU state */
@@ -3762,7 +3762,7 @@ static int il3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *en
 	}
 	/* MAC Address location in EEPROM same for 3945/4965 */
 	eeprom = (struct il3945_eeprom *)il->eeprom;
-	IL_DEBUG_INFO(il, "MAC address: %pM\n", eeprom->mac_address);
+	D_INFO("MAC address: %pM\n", eeprom->mac_address);
 	SET_IEEE80211_PERM_ADDR(il->hw, eeprom->mac_address);
 
 	/***********************
@@ -3873,7 +3873,7 @@ static void __devexit il3945_pci_remove(struct pci_dev *pdev)
 	if (!il)
 		return;
 
-	IL_DEBUG_INFO(il, "*** UNLOAD DRIVER ***\n");
+	D_INFO("*** UNLOAD DRIVER ***\n");
 
 	il_dbgfs_unregister(il);
 
diff --git a/drivers/net/wireless/iwlegacy/iwl4965-base.c b/drivers/net/wireless/iwlegacy/iwl4965-base.c
index d4eacc3..88dc8db 100644
--- a/drivers/net/wireless/iwlegacy/iwl4965-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl4965-base.c
@@ -104,7 +104,7 @@ static void il4965_clear_free_frames(struct il_priv *il)
 {
 	struct list_head *element;
 
-	IL_DEBUG_INFO(il, "%d frames on pre-allocated heap on clear.\n",
+	D_INFO("%d frames on pre-allocated heap on clear.\n",
 		       il->frames_count);
 
 	while (!list_empty(&il->free_frames)) {
@@ -436,19 +436,19 @@ static void il4965_rx_reply_alive(struct il_priv *il,
 
 	palive = &pkt->u.alive_frame;
 
-	IL_DEBUG_INFO(il, "Alive ucode status 0x%08X revision "
+	D_INFO("Alive ucode status 0x%08X revision "
 		       "0x%01X 0x%01X\n",
 		       palive->is_valid, palive->ver_type,
 		       palive->ver_subtype);
 
 	if (palive->ver_subtype == INITIALIZE_SUBTYPE) {
-		IL_DEBUG_INFO(il, "Initialization Alive received.\n");
+		D_INFO("Initialization Alive received.\n");
 		memcpy(&il->card_alive_init,
 		       &pkt->u.alive_frame,
 		       sizeof(struct il_init_alive_resp));
 		pwork = &il->init_alive_start;
 	} else {
-		IL_DEBUG_INFO(il, "Runtime Alive received.\n");
+		D_INFO("Runtime Alive received.\n");
 		memcpy(&il->card_alive, &pkt->u.alive_frame,
 		       sizeof(struct il_alive_resp));
 		pwork = &il->alive_start;
@@ -496,7 +496,7 @@ static void il4965_rx_beacon_notif(struct il_priv *il,
 #ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
 	u8 rate = il4965_hw_get_rate(beacon->beacon_notify_hdr.rate_n_flags);
 
-	IL_DEBUG_RX(il, "beacon status %x retries %d iss %d "
+	D_RX("beacon status %x retries %d iss %d "
 		"tsf %d %d rate %d\n",
 		le32_to_cpu(beacon->beacon_notify_hdr.u.status) & TX_STATUS_MSK,
 		beacon->beacon_notify_hdr.failure_frame,
@@ -512,7 +512,7 @@ static void il4965_perform_ct_kill_task(struct il_priv *il)
 {
 	unsigned long flags;
 
-	IL_DEBUG_POWER(il, "Stop all queues\n");
+	D_POWER("Stop all queues\n");
 
 	if (il->mac80211_registered)
 		ieee80211_stop_queues(il->hw);
@@ -536,7 +536,7 @@ static void il4965_rx_card_state_notif(struct il_priv *il,
 	u32 flags = le32_to_cpu(pkt->u.card_state_notif.flags);
 	unsigned long status = il->status;
 
-	IL_DEBUG_RF_KILL(il, "Card state received: HW:%s SW:%s CT:%s\n",
+	D_RF_KILL("Card state received: HW:%s SW:%s CT:%s\n",
 			  (flags & HW_CARD_DISABLED) ? "Kill" : "On",
 			  (flags & SW_CARD_DISABLED) ? "Kill" : "On",
 			  (flags & CT_CARD_DISABLED) ?
@@ -650,7 +650,7 @@ void il4965_rx_handle(struct il_priv *il)
 
 	/* Rx interrupt, but nothing sent from uCode */
 	if (i == r)
-		IL_DEBUG_RX(il, "r = %d, i = %d\n", r, i);
+		D_RX("r = %d, i = %d\n", r, i);
 
 	/* calculate total frames need to be restock after handling RX */
 	total_empty = r - rxq->write_actual;
@@ -698,14 +698,14 @@ void il4965_rx_handle(struct il_priv *il)
 		 *   handle those that need handling via function in
 		 *   rx_handlers table.  See il4965_setup_rx_handlers() */
 		if (il->rx_handlers[pkt->hdr.cmd]) {
-			IL_DEBUG_RX(il, "r = %d, i = %d, %s, 0x%02x\n", r,
+			D_RX("r = %d, i = %d, %s, 0x%02x\n", r,
 				i, il_get_cmd_string(pkt->hdr.cmd),
 				pkt->hdr.cmd);
 			il->isr_stats.rx_handlers[pkt->hdr.cmd]++;
 			il->rx_handlers[pkt->hdr.cmd] (il, rxb);
 		} else {
 			/* No handling needed */
-			IL_DEBUG_RX(il,
+			D_RX(
 				"r %d i %d No handler needed for %s, 0x%02x\n",
 				r, i, il_get_cmd_string(pkt->hdr.cmd),
 				pkt->hdr.cmd);
@@ -800,7 +800,7 @@ static void il4965_irq_tasklet(struct il_priv *il)
 	if (il_get_debug_level(il) & IL_DL_ISR) {
 		/* just for debug */
 		inta_mask = il_read32(il, CSR_INT_MASK);
-		IL_DEBUG_ISR(il, "inta 0x%08x, enabled 0x%08x, fh 0x%08x\n",
+		D_ISR("inta 0x%08x, enabled 0x%08x, fh 0x%08x\n",
 			      inta, inta_mask, inta_fh);
 	}
 #endif
@@ -835,14 +835,14 @@ static void il4965_irq_tasklet(struct il_priv *il)
 	if (il_get_debug_level(il) & (IL_DL_ISR)) {
 		/* NIC fires this, but we don't use it, redundant with WAKEUP */
 		if (inta & CSR_INT_BIT_SCD) {
-			IL_DEBUG_ISR(il, "Scheduler finished to transmit "
+			D_ISR("Scheduler finished to transmit "
 				      "the frame/frames.\n");
 			il->isr_stats.sch++;
 		}
 
 		/* Alive notification via Rx interrupt will do the real work */
 		if (inta & CSR_INT_BIT_ALIVE) {
-			IL_DEBUG_ISR(il, "Alive interrupt\n");
+			D_ISR("Alive interrupt\n");
 			il->isr_stats.alive++;
 		}
 	}
@@ -900,7 +900,7 @@ static void il4965_irq_tasklet(struct il_priv *il)
 	 * and about any Rx buffers made available while asleep.
 	 */
 	if (inta & CSR_INT_BIT_WAKEUP) {
-		IL_DEBUG_ISR(il, "Wakeup interrupt\n");
+		D_ISR("Wakeup interrupt\n");
 		il_rx_queue_update_write_ptr(il, &il->rxq);
 		for (i = 0; i < il->hw_params.max_txq_num; i++)
 			il_txq_update_write_ptr(il, &il->txq[i]);
@@ -919,7 +919,7 @@ static void il4965_irq_tasklet(struct il_priv *il)
 
 	/* This "Tx" DMA channel is used only for loading uCode */
 	if (inta & CSR_INT_BIT_FH_TX) {
-		IL_DEBUG_ISR(il, "uCode load interrupt\n");
+		D_ISR("uCode load interrupt\n");
 		il->isr_stats.tx++;
 		handled |= CSR_INT_BIT_FH_TX;
 		/* Wake up uCode load routine, now that load is complete */
@@ -951,7 +951,7 @@ static void il4965_irq_tasklet(struct il_priv *il)
 		inta = il_read32(il, CSR_INT);
 		inta_mask = il_read32(il, CSR_INT_MASK);
 		inta_fh = il_read32(il, CSR_FH_INT_STATUS);
-		IL_DEBUG_ISR(il,
+		D_ISR(
 			"End inta 0x%08x, enabled 0x%08x, fh 0x%08x, "
 			"flags 0x%08lx\n", inta, inta_mask, inta_fh, flags);
 	}
@@ -1120,7 +1120,7 @@ static int __must_check il4965_request_firmware(struct il_priv *il, bool first)
 
 	sprintf(il->firmware_name, "%s%s%s", name_pre, tag, ".ucode");
 
-	IL_DEBUG_INFO(il, "attempting to load firmware '%s'\n",
+	D_INFO("attempting to load firmware '%s'\n",
 		       il->firmware_name);
 
 	return request_firmware_nowait(THIS_MODULE, 1, il->firmware_name,
@@ -1220,7 +1220,7 @@ il4965_ucode_callback(const struct firmware *ucode_raw, void *context)
 		goto try_again;
 	}
 
-	IL_DEBUG_INFO(il, "Loaded firmware file '%s' (%zd bytes).\n",
+	D_INFO("Loaded firmware file '%s' (%zd bytes).\n",
 		       il->firmware_name, ucode_raw->size);
 
 	/* Make sure that we got at least the API version number */
@@ -1279,17 +1279,17 @@ il4965_ucode_callback(const struct firmware *ucode_raw, void *context)
 	 * user just got a corrupted version of the latest API.
 	 */
 
-	IL_DEBUG_INFO(il, "f/w package hdr ucode version raw = 0x%x\n",
+	D_INFO("f/w package hdr ucode version raw = 0x%x\n",
 		       il->ucode_ver);
-	IL_DEBUG_INFO(il, "f/w package hdr runtime inst size = %Zd\n",
+	D_INFO("f/w package hdr runtime inst size = %Zd\n",
 		       pieces.inst_size);
-	IL_DEBUG_INFO(il, "f/w package hdr runtime data size = %Zd\n",
+	D_INFO("f/w package hdr runtime data size = %Zd\n",
 		       pieces.data_size);
-	IL_DEBUG_INFO(il, "f/w package hdr init inst size = %Zd\n",
+	D_INFO("f/w package hdr init inst size = %Zd\n",
 		       pieces.init_size);
-	IL_DEBUG_INFO(il, "f/w package hdr init data size = %Zd\n",
+	D_INFO("f/w package hdr init data size = %Zd\n",
 		       pieces.init_data_size);
-	IL_DEBUG_INFO(il, "f/w package hdr boot inst size = %Zd\n",
+	D_INFO("f/w package hdr boot inst size = %Zd\n",
 		       pieces.boot_size);
 
 	/* Verify that uCode images will fit in card's SRAM */
@@ -1369,25 +1369,25 @@ il4965_ucode_callback(const struct firmware *ucode_raw, void *context)
 	/* Copy images into buffers for card's bus-master reads ... */
 
 	/* Runtime instructions (first block of data in file) */
-	IL_DEBUG_INFO(il, "Copying (but not loading) uCode instr len %Zd\n",
+	D_INFO("Copying (but not loading) uCode instr len %Zd\n",
 			pieces.inst_size);
 	memcpy(il->ucode_code.v_addr, pieces.inst, pieces.inst_size);
 
-	IL_DEBUG_INFO(il, "uCode instr buf vaddr = 0x%p, paddr = 0x%08x\n",
+	D_INFO("uCode instr buf vaddr = 0x%p, paddr = 0x%08x\n",
 		il->ucode_code.v_addr, (u32)il->ucode_code.p_addr);
 
 	/*
 	 * Runtime data
 	 * NOTE:  Copy into backup buffer will be done in il_up()
 	 */
-	IL_DEBUG_INFO(il, "Copying (but not loading) uCode data len %Zd\n",
+	D_INFO("Copying (but not loading) uCode data len %Zd\n",
 			pieces.data_size);
 	memcpy(il->ucode_data.v_addr, pieces.data, pieces.data_size);
 	memcpy(il->ucode_data_backup.v_addr, pieces.data, pieces.data_size);
 
 	/* Initialization instructions */
 	if (pieces.init_size) {
-		IL_DEBUG_INFO(il,
+		D_INFO(
 				"Copying (but not loading) init instr len %Zd\n",
 				pieces.init_size);
 		memcpy(il->ucode_init.v_addr, pieces.init, pieces.init_size);
@@ -1395,7 +1395,7 @@ il4965_ucode_callback(const struct firmware *ucode_raw, void *context)
 
 	/* Initialization data */
 	if (pieces.init_data_size) {
-		IL_DEBUG_INFO(il,
+		D_INFO(
 				"Copying (but not loading) init data len %Zd\n",
 			       pieces.init_data_size);
 		memcpy(il->ucode_init_data.v_addr, pieces.init_data,
@@ -1403,7 +1403,7 @@ il4965_ucode_callback(const struct firmware *ucode_raw, void *context)
 	}
 
 	/* Bootstrap instructions */
-	IL_DEBUG_INFO(il, "Copying (but not loading) boot instr len %Zd\n",
+	D_INFO("Copying (but not loading) boot instr len %Zd\n",
 			pieces.boot_size);
 	memcpy(il->ucode_boot.v_addr, pieces.boot, pieces.boot_size);
 
@@ -1596,7 +1596,7 @@ static void il4965_rf_kill_ct_config(struct il_priv *il)
 	if (ret)
 		IL_ERR(il, "REPLY_CT_KILL_CONFIG_CMD failed\n");
 	else
-		IL_DEBUG_INFO(il, "REPLY_CT_KILL_CONFIG_CMD "
+		D_INFO("REPLY_CT_KILL_CONFIG_CMD "
 				"succeeded, "
 				"critical temperature is %d\n",
 				il->hw_params.ct_kill_threshold);
@@ -1719,12 +1719,12 @@ static void il4965_alive_start(struct il_priv *il)
 	int ret = 0;
 	struct il_rxon_context *ctx = &il->contexts[IL_RXON_CTX_BSS];
 
-	IL_DEBUG_INFO(il, "Runtime Alive received.\n");
+	D_INFO("Runtime Alive received.\n");
 
 	if (il->card_alive.is_valid != UCODE_VALID_OK) {
 		/* We had an error bringing up the hardware, so take it
 		 * all the way back down so we can try again */
-		IL_DEBUG_INFO(il, "Alive failed.\n");
+		D_INFO("Alive failed.\n");
 		goto restart;
 	}
 
@@ -1734,7 +1734,7 @@ static void il4965_alive_start(struct il_priv *il)
 	if (il4965_verify_ucode(il)) {
 		/* Runtime instruction load was bad;
 		 * take it all the way back down so we can try again */
-		IL_DEBUG_INFO(il, "Bad runtime uCode load.\n");
+		D_INFO("Bad runtime uCode load.\n");
 		goto restart;
 	}
 
@@ -1788,11 +1788,11 @@ static void il4965_alive_start(struct il_priv *il)
 	/* At this point, the NIC is initialized and operational */
 	il4965_rf_kill_ct_config(il);
 
-	IL_DEBUG_INFO(il, "ALIVE processing complete.\n");
+	D_INFO("ALIVE processing complete.\n");
 	wake_up(&il->wait_command_queue);
 
 	il_power_update_mode(il, true);
-	IL_DEBUG_INFO(il, "Updated power mode\n");
+	D_INFO("Updated power mode\n");
 
 	return;
 
@@ -1807,7 +1807,7 @@ static void __il4965_down(struct il_priv *il)
 	unsigned long flags;
 	int exit_pending;
 
-	IL_DEBUG_INFO(il, DRV_NAME " is going down\n");
+	D_INFO(DRV_NAME " is going down\n");
 
 	il_scan_cancel_timeout(il, 200);
 
@@ -1916,7 +1916,7 @@ static int il4965_set_hw_ready(struct il_priv *il)
 	else
 		il->hw_ready = false;
 
-	IL_DEBUG_INFO(il, "hardware %s\n",
+	D_INFO("hardware %s\n",
 		      (il->hw_ready == 1) ? "ready" : "not ready");
 	return ret;
 }
@@ -1925,7 +1925,7 @@ static int il4965_prepare_card_hw(struct il_priv *il)
 {
 	int ret = 0;
 
-	IL_DEBUG_INFO(il, "il4965_prepare_card_hw enter\n");
+	D_INFO("il4965_prepare_card_hw enter\n");
 
 	ret = il4965_set_hw_ready(il);
 	if (il->hw_ready)
@@ -2040,7 +2040,7 @@ static int __il4965_up(struct il_priv *il)
 		/* start card; "initialize" will load runtime ucode */
 		il4965_nic_start(il);
 
-		IL_DEBUG_INFO(il, DRV_NAME " is coming up\n");
+		D_INFO(DRV_NAME " is coming up\n");
 
 		return 0;
 	}
@@ -2243,7 +2243,7 @@ int il4965_mac_start(struct ieee80211_hw *hw)
 	struct il_priv *il = hw->priv;
 	int ret;
 
-	IL_DEBUG_MAC80211(il, "enter\n");
+	D_MAC80211("enter\n");
 
 	/* we should be verifying the device is ready to be opened */
 	mutex_lock(&il->mutex);
@@ -2256,7 +2256,7 @@ int il4965_mac_start(struct ieee80211_hw *hw)
 	if (il_is_rfkill(il))
 		goto out;
 
-	IL_DEBUG_INFO(il, "Start UP work done.\n");
+	D_INFO("Start UP work done.\n");
 
 	/* Wait for START_ALIVE from Run Time ucode. Otherwise callbacks from
 	 * mac80211 will not be run successfully. */
@@ -2275,7 +2275,7 @@ int il4965_mac_start(struct ieee80211_hw *hw)
 
 out:
 	il->is_open = 1;
-	IL_DEBUG_MAC80211(il, "leave\n");
+	D_MAC80211("leave\n");
 	return 0;
 }
 
@@ -2283,7 +2283,7 @@ void il4965_mac_stop(struct ieee80211_hw *hw)
 {
 	struct il_priv *il = hw->priv;
 
-	IL_DEBUG_MAC80211(il, "enter\n");
+	D_MAC80211("enter\n");
 
 	if (!il->is_open)
 		return;
@@ -2299,22 +2299,22 @@ void il4965_mac_stop(struct ieee80211_hw *hw)
 	il_write32(il, CSR_INT, 0xFFFFFFFF);
 	il_enable_rfkill_int(il);
 
-	IL_DEBUG_MAC80211(il, "leave\n");
+	D_MAC80211("leave\n");
 }
 
 void il4965_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct il_priv *il = hw->priv;
 
-	IL_DEBUG_MACDUMP(il, "enter\n");
+	D_MACDUMP("enter\n");
 
-	IL_DEBUG_TX(il, "dev->xmit(%d bytes) at rate 0x%02x\n", skb->len,
+	D_TX("dev->xmit(%d bytes) at rate 0x%02x\n", skb->len,
 		     ieee80211_get_tx_rate(hw, IEEE80211_SKB_CB(skb))->bitrate);
 
 	if (il4965_tx_skb(il, skb))
 		dev_kfree_skb_any(skb);
 
-	IL_DEBUG_MACDUMP(il, "leave\n");
+	D_MACDUMP("leave\n");
 }
 
 void il4965_mac_update_tkip_key(struct ieee80211_hw *hw,
@@ -2326,12 +2326,12 @@ void il4965_mac_update_tkip_key(struct ieee80211_hw *hw,
 	struct il_priv *il = hw->priv;
 	struct il_vif_priv *vif_priv = (void *)vif->drv_priv;
 
-	IL_DEBUG_MAC80211(il, "enter\n");
+	D_MAC80211("enter\n");
 
 	il4965_update_tkip_key(il, vif_priv->ctx, keyconf, sta,
 			    iv32, phase1key);
 
-	IL_DEBUG_MAC80211(il, "leave\n");
+	D_MAC80211("leave\n");
 }
 
 int il4965_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
@@ -2345,10 +2345,10 @@ int il4965_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	u8 sta_id;
 	bool is_default_wep_key = false;
 
-	IL_DEBUG_MAC80211(il, "enter\n");
+	D_MAC80211("enter\n");
 
 	if (il->cfg->mod_params->sw_crypto) {
-		IL_DEBUG_MAC80211(il, "leave - hwcrypto disabled\n");
+		D_MAC80211("leave - hwcrypto disabled\n");
 		return -EOPNOTSUPP;
 	}
 
@@ -2384,7 +2384,7 @@ int il4965_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			ret = il4965_set_dynamic_key(il, vif_priv->ctx,
 						  key, sta_id);
 
-		IL_DEBUG_MAC80211(il, "enable hwcrypto key\n");
+		D_MAC80211("enable hwcrypto key\n");
 		break;
 	case DISABLE_KEY:
 		if (is_default_wep_key)
@@ -2393,14 +2393,14 @@ int il4965_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			ret = il4965_remove_dynamic_key(il, ctx,
 							key, sta_id);
 
-		IL_DEBUG_MAC80211(il, "disable hwcrypto key\n");
+		D_MAC80211("disable hwcrypto key\n");
 		break;
 	default:
 		ret = -EINVAL;
 	}
 
 	mutex_unlock(&il->mutex);
-	IL_DEBUG_MAC80211(il, "leave\n");
+	D_MAC80211("leave\n");
 
 	return ret;
 }
@@ -2414,7 +2414,7 @@ int il4965_mac_ampdu_action(struct ieee80211_hw *hw,
 	struct il_priv *il = hw->priv;
 	int ret = -EINVAL;
 
-	IL_DEBUG_HT(il, "A-MPDU action on addr %pM tid %d\n",
+	D_HT("A-MPDU action on addr %pM tid %d\n",
 		     sta->addr, tid);
 
 	if (!(il->cfg->sku & IL_SKU_N))
@@ -2424,21 +2424,21 @@ int il4965_mac_ampdu_action(struct ieee80211_hw *hw,
 
 	switch (action) {
 	case IEEE80211_AMPDU_RX_START:
-		IL_DEBUG_HT(il, "start Rx\n");
+		D_HT("start Rx\n");
 		ret = il4965_sta_rx_agg_start(il, sta, tid, *ssn);
 		break;
 	case IEEE80211_AMPDU_RX_STOP:
-		IL_DEBUG_HT(il, "stop Rx\n");
+		D_HT("stop Rx\n");
 		ret = il4965_sta_rx_agg_stop(il, sta, tid);
 		if (test_bit(STATUS_EXIT_PENDING, &il->status))
 			ret = 0;
 		break;
 	case IEEE80211_AMPDU_TX_START:
-		IL_DEBUG_HT(il, "start Tx\n");
+		D_HT("start Tx\n");
 		ret = il4965_tx_agg_start(il, vif, sta, tid, ssn);
 		break;
 	case IEEE80211_AMPDU_TX_STOP:
-		IL_DEBUG_HT(il, "stop Tx\n");
+		D_HT("stop Tx\n");
 		ret = il4965_tx_agg_stop(il, vif, sta, tid);
 		if (test_bit(STATUS_EXIT_PENDING, &il->status))
 			ret = 0;
@@ -2463,10 +2463,10 @@ int il4965_mac_sta_add(struct ieee80211_hw *hw,
 	int ret;
 	u8 sta_id;
 
-	IL_DEBUG_INFO(il, "received request to add station %pM\n",
+	D_INFO("received request to add station %pM\n",
 			sta->addr);
 	mutex_lock(&il->mutex);
-	IL_DEBUG_INFO(il, "proceeding to add station %pM\n",
+	D_INFO("proceeding to add station %pM\n",
 			sta->addr);
 	sta_priv->common.sta_id = IL_INVALID_STATION;
 
@@ -2485,7 +2485,7 @@ int il4965_mac_sta_add(struct ieee80211_hw *hw,
 	sta_priv->common.sta_id = sta_id;
 
 	/* Initialize rate scaling */
-	IL_DEBUG_INFO(il, "Initializing rate scaling for station %pM\n",
+	D_INFO("Initializing rate scaling for station %pM\n",
 		       sta->addr);
 	il4965_rs_rate_init(il, sta, sta_id);
 	mutex_unlock(&il->mutex);
@@ -2505,7 +2505,7 @@ void il4965_mac_channel_switch(struct ieee80211_hw *hw,
 	struct il_rxon_context *ctx = &il->contexts[IL_RXON_CTX_BSS];
 	u16 ch;
 
-	IL_DEBUG_MAC80211(il, "enter\n");
+	D_MAC80211("enter\n");
 
 	mutex_lock(&il->mutex);
 
@@ -2529,7 +2529,7 @@ void il4965_mac_channel_switch(struct ieee80211_hw *hw,
 
 	ch_info = il_get_channel_info(il, channel->band, ch);
 	if (!il_is_channel_valid(ch_info)) {
-		IL_DEBUG_MAC80211(il, "invalid channel\n");
+		D_MAC80211("invalid channel\n");
 		goto out;
 	}
 
@@ -2580,7 +2580,7 @@ void il4965_mac_channel_switch(struct ieee80211_hw *hw,
 
 out:
 	mutex_unlock(&il->mutex);
-	IL_DEBUG_MAC80211(il, "leave\n");
+	D_MAC80211("leave\n");
 }
 
 void il4965_configure_filter(struct ieee80211_hw *hw,
@@ -2599,7 +2599,7 @@ void il4965_configure_filter(struct ieee80211_hw *hw,
 		filter_nand |= (flag);		\
 	} while (0)
 
-	IL_DEBUG_MAC80211(il, "Enter: changed: 0x%x, total: 0x%x\n",
+	D_MAC80211("Enter: changed: 0x%x, total: 0x%x\n",
 			changed_flags, *total_flags);
 
 	CHK(FIF_OTHER_BSS | FIF_PROMISC_IN_BSS, RXON_FILTER_PROMISC_MSK);
@@ -2755,7 +2755,7 @@ void il4965_tx_queue_set_status(struct il_priv *il,
 
 	txq->sched_retry = scd_retry;
 
-	IL_DEBUG_INFO(il, "%s %s Queue %d on AC %d\n",
+	D_INFO("%s %s Queue %d on AC %d\n",
 		       active ? "Activate" : "Deactivate",
 		       scd_retry ? "BA" : "AC", txq_id, tx_fifo_id);
 }
@@ -2824,7 +2824,7 @@ static void il4965_hw_detect(struct il_priv *il)
 	il->hw_rev = _il_read32(il, CSR_HW_REV);
 	il->hw_wa_rev = _il_read32(il, CSR_HW_REV_WA_REG);
 	il->rev_id = il->pci_dev->revision;
-	IL_DEBUG_INFO(il, "HW Revision ID = 0x%X\n", il->rev_id);
+	D_INFO("HW Revision ID = 0x%X\n", il->rev_id);
 }
 
 static int il4965_set_hw_params(struct il_priv *il)
@@ -2911,7 +2911,7 @@ il4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	SET_IEEE80211_DEV(hw, &pdev->dev);
 
-	IL_DEBUG_INFO(il, "*** LOAD DRIVER ***\n");
+	D_INFO("*** LOAD DRIVER ***\n");
 	il->cfg = cfg;
 	il->pci_dev = pdev;
 	il->inta_mask = CSR_INI_SET_MASK;
@@ -2963,9 +2963,9 @@ il4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_pci_release_regions;
 	}
 
-	IL_DEBUG_INFO(il, "pci_resource_len = 0x%08llx\n",
+	D_INFO("pci_resource_len = 0x%08llx\n",
 		(unsigned long long) pci_resource_len(pdev, 0));
-	IL_DEBUG_INFO(il, "pci_resource_base = %p\n", il->hw_base);
+	D_INFO("pci_resource_base = %p\n", il->hw_base);
 
 	/* these spin locks will be used in apm_ops.init and EEPROM access
 	 * we should init now
@@ -3012,7 +3012,7 @@ il4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	/* extract MAC Address */
 	il4965_eeprom_get_mac(il, il->addresses[0].addr);
-	IL_DEBUG_INFO(il, "MAC address: %pM\n", il->addresses[0].addr);
+	D_INFO("MAC address: %pM\n", il->addresses[0].addr);
 	il->hw->wiphy->addresses = il->addresses;
 	il->hw->wiphy->n_addresses = 1;
 
@@ -3118,7 +3118,7 @@ static void __devexit il4965_pci_remove(struct pci_dev *pdev)
 
 	wait_for_completion(&il->_4965.firmware_loading_complete);
 
-	IL_DEBUG_INFO(il, "*** UNLOAD DRIVER ***\n");
+	D_INFO("*** UNLOAD DRIVER ***\n");
 
 	il_dbgfs_unregister(il);
 	sysfs_remove_group(&pdev->dev.kobj, &il_attribute_group);
-- 
1.7.1

