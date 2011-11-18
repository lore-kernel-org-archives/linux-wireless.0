Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756675Ab1KRIWZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:22:25 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAI8MOSr015822
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 03:22:25 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 43/77] iwlegacy: rename REPLY_ to N_ or C_
Date: Fri, 18 Nov 2011 09:22:05 +0100
Message-Id: <1321604559-10707-43-git-send-email-sgruszka@redhat.com> (sfid-20111118_092234_746781_027A079A)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945-mac.c     |   62 +++---
 drivers/net/wireless/iwlegacy/3945.c         |   24 ++--
 drivers/net/wireless/iwlegacy/4965-calib.c   |   12 +-
 drivers/net/wireless/iwlegacy/4965-mac.c     |   96 +++++-----
 drivers/net/wireless/iwlegacy/4965-rs.c      |    4 +-
 drivers/net/wireless/iwlegacy/4965.c         |   24 ++--
 drivers/net/wireless/iwlegacy/4965.h         |    4 +-
 drivers/net/wireless/iwlegacy/iwl-commands.h |  260 +++++++++++++-------------
 drivers/net/wireless/iwlegacy/iwl-core.c     |    6 +-
 drivers/net/wireless/iwlegacy/iwl-debugfs.c  |    2 +-
 drivers/net/wireless/iwlegacy/iwl-dev.h      |    8 +-
 drivers/net/wireless/iwlegacy/iwl-hcmd.c     |   86 +++++-----
 drivers/net/wireless/iwlegacy/iwl-power.c    |    2 +-
 drivers/net/wireless/iwlegacy/iwl-prph.h     |    2 +-
 drivers/net/wireless/iwlegacy/iwl-scan.c     |   18 +-
 drivers/net/wireless/iwlegacy/iwl-sta.c      |   20 +-
 drivers/net/wireless/iwlegacy/iwl-tx.c       |    4 +-
 17 files changed, 317 insertions(+), 317 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index 2ff8075..65cab84 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -348,7 +348,7 @@ static int il3945_send_beacon_cmd(struct il_priv *il)
 
 	frame_size = il3945_hw_get_beacon_cmd(il, frame, rate);
 
-	rc = il_send_cmd_pdu(il, REPLY_TX_BEACON, frame_size,
+	rc = il_send_cmd_pdu(il, C_TX_BEACON, frame_size,
 			      &frame->u.cmd[0]);
 
 	il3945_free_frame(il, frame);
@@ -406,7 +406,7 @@ static void il3945_build_tx_cmd_hwcrypto(struct il_priv *il,
 }
 
 /*
- * handle build REPLY_TX command notification.
+ * handle build C_TX command notification.
  */
 static void il3945_build_tx_cmd_basic(struct il_priv *il,
 				  struct il_device_cmd *cmd,
@@ -460,7 +460,7 @@ static void il3945_build_tx_cmd_basic(struct il_priv *il,
 }
 
 /*
- * start REPLY_TX command process
+ * start C_TX command process
  */
 static int il3945_tx_skb(struct il_priv *il, struct sk_buff *skb)
 {
@@ -560,7 +560,7 @@ static int il3945_tx_skb(struct il_priv *il, struct sk_buff *skb)
 	 * after Tx, uCode's Tx response will return this value so driver can
 	 * locate the frame within the tx queue and do post-tx processing.
 	 */
-	out_cmd->hdr.cmd = REPLY_TX;
+	out_cmd->hdr.cmd = C_TX;
 	out_cmd->hdr.sequence = cpu_to_le16((u16)(QUEUE_TO_SEQ(txq_id) |
 				IDX_TO_SEQ(q->write_ptr)));
 
@@ -672,7 +672,7 @@ static int il3945_get_measurement(struct il_priv *il,
 	struct il_spectrum_cmd spectrum;
 	struct il_rx_pkt *pkt;
 	struct il_host_cmd cmd = {
-		.id = REPLY_SPECTRUM_MEASUREMENT_CMD,
+		.id = C_SPECTRUM_MEASUREMENT,
 		.data = (void *)&spectrum,
 		.flags = CMD_WANT_SKB,
 	};
@@ -717,7 +717,7 @@ static int il3945_get_measurement(struct il_priv *il,
 
 	pkt = (struct il_rx_pkt *)cmd.reply_page;
 	if (pkt->hdr.flags & IL_CMD_FAILED_MSK) {
-		IL_ERR("Bad return from REPLY_RX_ON_ASSOC command\n");
+		IL_ERR("Bad return from N_RX_ON_ASSOC command\n");
 		rc = -EIO;
 	}
 
@@ -786,7 +786,7 @@ static void il3945_rx_reply_add_sta(struct il_priv *il,
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
 #endif
 
-	D_RX("Received REPLY_ADD_STA: 0x%02X\n", pkt->u.status);
+	D_RX("Received C_ADD_STA: 0x%02X\n", pkt->u.status);
 }
 
 static void il3945_rx_beacon_notif(struct il_priv *il,
@@ -853,27 +853,27 @@ static void il3945_rx_card_state_notif(struct il_priv *il,
  */
 static void il3945_setup_rx_handlers(struct il_priv *il)
 {
-	il->rx_handlers[REPLY_ALIVE] = il3945_rx_reply_alive;
-	il->rx_handlers[REPLY_ADD_STA] = il3945_rx_reply_add_sta;
-	il->rx_handlers[REPLY_ERROR] = il_rx_reply_error;
-	il->rx_handlers[CHANNEL_SWITCH_NOTIFICATION] = il_rx_csa;
-	il->rx_handlers[SPECTRUM_MEASURE_NOTIFICATION] =
+	il->rx_handlers[N_ALIVE] = il3945_rx_reply_alive;
+	il->rx_handlers[C_ADD_STA] = il3945_rx_reply_add_sta;
+	il->rx_handlers[N_ERROR] = il_rx_reply_error;
+	il->rx_handlers[N_CHANNEL_SWITCH] = il_rx_csa;
+	il->rx_handlers[N_SPECTRUM_MEASUREMENT] =
 			il_rx_spectrum_measure_notif;
-	il->rx_handlers[PM_SLEEP_NOTIFICATION] = il_rx_pm_sleep_notif;
-	il->rx_handlers[PM_DEBUG_STATISTIC_NOTIFIC] =
+	il->rx_handlers[N_PM_SLEEP] = il_rx_pm_sleep_notif;
+	il->rx_handlers[N_PM_DEBUG_STATS] =
 	    il_rx_pm_debug_stats_notif;
-	il->rx_handlers[BEACON_NOTIFICATION] = il3945_rx_beacon_notif;
+	il->rx_handlers[N_BEACON] = il3945_rx_beacon_notif;
 
 	/*
 	 * The same handler is used for both the REPLY to a discrete
 	 * stats request from the host as well as for the periodic
 	 * stats notifications (after received beacons) from the uCode.
 	 */
-	il->rx_handlers[REPLY_STATS_CMD] = il3945_reply_stats;
-	il->rx_handlers[STATS_NOTIFICATION] = il3945_hw_rx_stats;
+	il->rx_handlers[C_STATS] = il3945_reply_stats;
+	il->rx_handlers[N_STATS] = il3945_hw_rx_stats;
 
 	il_setup_rx_scan_handlers(il);
-	il->rx_handlers[CARD_STATE_NOTIFICATION] = il3945_rx_card_state_notif;
+	il->rx_handlers[N_CARD_STATE] = il3945_rx_card_state_notif;
 
 	/* Set up hardware specific Rx handlers */
 	il3945_hw_rx_handler_setup(il);
@@ -1253,8 +1253,8 @@ static void il3945_rx_handle(struct il_priv *il)
 		 * Ucode should set SEQ_RX_FRAME bit if ucode-originated,
 		 *   but apparently a few don't get set; catch them here. */
 		reclaim = !(pkt->hdr.sequence & SEQ_RX_FRAME) &&
-			pkt->hdr.cmd != STATS_NOTIFICATION &&
-			pkt->hdr.cmd != REPLY_TX;
+			pkt->hdr.cmd != N_STATS &&
+			pkt->hdr.cmd != C_TX;
 
 		/* Based on type of command response or notification,
 		 *   handle those that need handling via function in
@@ -2137,9 +2137,9 @@ static int il3945_set_ucode_ptrs(struct il_priv *il)
 }
 
 /**
- * il3945_init_alive_start - Called after REPLY_ALIVE notification received
+ * il3945_init_alive_start - Called after N_ALIVE notification received
  *
- * Called after REPLY_ALIVE notification received from "initialize" uCode.
+ * Called after N_ALIVE notification received from "initialize" uCode.
  *
  * Tell "initialize" uCode to go ahead and load the runtime uCode.
  */
@@ -2180,7 +2180,7 @@ static void il3945_init_alive_start(struct il_priv *il)
 }
 
 /**
- * il3945_alive_start - called after REPLY_ALIVE notification received
+ * il3945_alive_start - called after N_ALIVE notification received
  *                   from protocol/runtime uCode (initialization uCode's
  *                   Alive gets handled by il3945_init_alive_start()).
  */
@@ -2553,7 +2553,7 @@ static void il3945_rfkill_poll(struct work_struct *data)
 int il3945_request_scan(struct il_priv *il, struct ieee80211_vif *vif)
 {
 	struct il_host_cmd cmd = {
-		.id = REPLY_SCAN_CMD,
+		.id = C_SCAN,
 		.len = sizeof(struct il3945_scan_cmd),
 		.flags = CMD_SIZE_HUGE,
 	};
@@ -2767,7 +2767,7 @@ void il3945_post_associate(struct il_priv *il)
 
 	rc = il_send_rxon_timing(il, ctx);
 	if (rc)
-		IL_WARN("REPLY_RXON_TIMING failed - "
+		IL_WARN("C_RXON_TIMING failed - "
 			    "Attempting to continue.\n");
 
 	ctx->staging.filter_flags |= RXON_FILTER_ASSOC_MSK;
@@ -2931,7 +2931,7 @@ void il3945_config_ap(struct il_priv *il)
 		/* RXON Timing */
 		rc = il_send_rxon_timing(il, ctx);
 		if (rc)
-			IL_WARN("REPLY_RXON_TIMING failed - "
+			IL_WARN("C_RXON_TIMING failed - "
 					"Attempting to continue.\n");
 
 		ctx->staging.assoc_id = 0;
@@ -3657,12 +3657,12 @@ static int il3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *en
 
 	il->ctx.ctxid = 0;
 
-	il->ctx.rxon_cmd = REPLY_RXON;
-	il->ctx.rxon_timing_cmd = REPLY_RXON_TIMING;
-	il->ctx.rxon_assoc_cmd = REPLY_RXON_ASSOC;
-	il->ctx.qos_cmd = REPLY_QOS_PARAM;
+	il->ctx.rxon_cmd = C_RXON;
+	il->ctx.rxon_timing_cmd = C_RXON_TIMING;
+	il->ctx.rxon_assoc_cmd = C_RXON_ASSOC;
+	il->ctx.qos_cmd = C_QOS_PARAM;
 	il->ctx.ap_sta_id = IL_AP_ID;
-	il->ctx.wep_key_cmd = REPLY_WEPKEY;
+	il->ctx.wep_key_cmd = C_WEPKEY;
 	il->ctx.interface_modes =
 		BIT(NL80211_IFTYPE_STATION) |
 		BIT(NL80211_IFTYPE_ADHOC);
diff --git a/drivers/net/wireless/iwlegacy/3945.c b/drivers/net/wireless/iwlegacy/3945.c
index 82534a2..ba250f7 100644
--- a/drivers/net/wireless/iwlegacy/3945.c
+++ b/drivers/net/wireless/iwlegacy/3945.c
@@ -53,7 +53,7 @@ static int il3945_send_led_cmd(struct il_priv *il,
 				struct il_led_cmd *led_cmd)
 {
 	struct il_host_cmd cmd = {
-		.id = REPLY_LEDS_CMD,
+		.id = C_LEDS,
 		.len = sizeof(struct il_led_cmd),
 		.data = led_cmd,
 		.flags = CMD_ASYNC,
@@ -1444,7 +1444,7 @@ static int il3945_send_tx_power(struct il_priv *il)
 				txpower.power[i].rate);
 	}
 
-	return il_send_cmd_pdu(il, REPLY_TX_PWR_TBL_CMD,
+	return il_send_cmd_pdu(il, C_TX_PWR_TBL,
 				sizeof(struct il3945_txpowertable_cmd),
 				&txpower);
 
@@ -1673,7 +1673,7 @@ static int il3945_send_rxon_assoc(struct il_priv *il,
 	struct il_rx_pkt *pkt;
 	struct il3945_rxon_assoc_cmd rxon_assoc;
 	struct il_host_cmd cmd = {
-		.id = REPLY_RXON_ASSOC,
+		.id = C_RXON_ASSOC,
 		.len = sizeof(rxon_assoc),
 		.flags = CMD_WANT_SKB,
 		.data = &rxon_assoc,
@@ -1701,7 +1701,7 @@ static int il3945_send_rxon_assoc(struct il_priv *il,
 
 	pkt = (struct il_rx_pkt *)cmd.reply_page;
 	if (pkt->hdr.flags & IL_CMD_FAILED_MSK) {
-		IL_ERR("Bad return from REPLY_RXON_ASSOC command\n");
+		IL_ERR("Bad return from C_RXON_ASSOC command\n");
 		rc = -EIO;
 	}
 
@@ -1782,7 +1782,7 @@ int il3945_commit_rxon(struct il_priv *il, struct il_rxon_context *ctx)
 		 */
 		active_rxon->reserved4 = 0;
 		active_rxon->reserved5 = 0;
-		rc = il_send_cmd_pdu(il, REPLY_RXON,
+		rc = il_send_cmd_pdu(il, C_RXON,
 				      sizeof(struct il3945_rxon_cmd),
 				      &il->ctx.active);
 
@@ -1818,7 +1818,7 @@ int il3945_commit_rxon(struct il_priv *il, struct il_rxon_context *ctx)
 	il_set_rxon_hwcrypto(il, ctx, !il3945_mod_params.sw_crypto);
 
 	/* Apply the new configuration */
-	rc = il_send_cmd_pdu(il, REPLY_RXON,
+	rc = il_send_cmd_pdu(il, C_RXON,
 			      sizeof(struct il3945_rxon_cmd),
 			      staging_rxon);
 	if (rc) {
@@ -2237,9 +2237,9 @@ int il3945_hw_tx_queue_init(struct il_priv *il, struct il_tx_queue *txq)
 static u16 il3945_get_hcmd_size(u8 cmd_id, u16 len)
 {
 	switch (cmd_id) {
-	case REPLY_RXON:
+	case C_RXON:
 		return sizeof(struct il3945_rxon_cmd);
-	case POWER_TBL_CMD:
+	case C_POWER_TBL:
 		return sizeof(struct il3945_powertable_cmd);
 	default:
 		return len;
@@ -2383,14 +2383,14 @@ int il3945_init_hw_rate_table(struct il_priv *il)
 
 	/* Update the rate scaling for control frame Tx */
 	rate_cmd.table_id = 0;
-	rc = il_send_cmd_pdu(il, REPLY_RATE_SCALE, sizeof(rate_cmd),
+	rc = il_send_cmd_pdu(il, C_RATE_SCALE, sizeof(rate_cmd),
 			      &rate_cmd);
 	if (rc)
 		return rc;
 
 	/* Update the rate scaling for data frame Tx */
 	rate_cmd.table_id = 1;
-	return il_send_cmd_pdu(il, REPLY_RATE_SCALE, sizeof(rate_cmd),
+	return il_send_cmd_pdu(il, C_RATE_SCALE, sizeof(rate_cmd),
 				&rate_cmd);
 }
 
@@ -2464,8 +2464,8 @@ unsigned int il3945_hw_get_beacon_cmd(struct il_priv *il,
 
 void il3945_hw_rx_handler_setup(struct il_priv *il)
 {
-	il->rx_handlers[REPLY_TX] = il3945_rx_reply_tx;
-	il->rx_handlers[REPLY_3945_RX] = il3945_rx_reply_rx;
+	il->rx_handlers[C_TX] = il3945_rx_reply_tx;
+	il->rx_handlers[N_3945_RX] = il3945_rx_reply_rx;
 }
 
 void il3945_hw_setup_deferred_work(struct il_priv *il)
diff --git a/drivers/net/wireless/iwlegacy/4965-calib.c b/drivers/net/wireless/iwlegacy/4965-calib.c
index cd61050..c5dcc52 100644
--- a/drivers/net/wireless/iwlegacy/4965-calib.c
+++ b/drivers/net/wireless/iwlegacy/4965-calib.c
@@ -410,13 +410,13 @@ static void il4965_prepare_legacy_sensitivity_tbl(struct il_priv *il,
 			data->nrg_th_cck);
 }
 
-/* Prepare a SENSITIVITY_CMD, send to uCode if values have changed */
+/* Prepare a C_SENSITIVITY, send to uCode if values have changed */
 static int il4965_sensitivity_write(struct il_priv *il)
 {
 	struct il_sensitivity_cmd cmd;
 	struct il_sensitivity_data *data = NULL;
 	struct il_host_cmd cmd_out = {
-		.id = SENSITIVITY_CMD,
+		.id = C_SENSITIVITY,
 		.len = sizeof(struct il_sensitivity_cmd),
 		.flags = CMD_ASYNC,
 		.data = &cmd,
@@ -429,12 +429,12 @@ static int il4965_sensitivity_write(struct il_priv *il)
 	il4965_prepare_legacy_sensitivity_tbl(il, data, &cmd.table[0]);
 
 	/* Update uCode's "work" table, and copy it to DSP */
-	cmd.control = SENSITIVITY_CMD_CONTROL_WORK_TBL;
+	cmd.control = C_SENSITIVITY_CONTROL_WORK_TBL;
 
 	/* Don't send command to uCode if nothing has changed */
 	if (!memcmp(&cmd.table[0], &(il->sensitivity_tbl[0]),
 		    sizeof(u16)*HD_TBL_SIZE)) {
-		D_CALIB("No change in SENSITIVITY_CMD\n");
+		D_CALIB("No change in C_SENSITIVITY\n");
 		return 0;
 	}
 
@@ -776,11 +776,11 @@ static void il4965_gain_computation(struct il_priv *il,
 		cmd.diff_gain_a = data->delta_gain_code[0];
 		cmd.diff_gain_b = data->delta_gain_code[1];
 		cmd.diff_gain_c = data->delta_gain_code[2];
-		ret = il_send_cmd_pdu(il, REPLY_PHY_CALIBRATION_CMD,
+		ret = il_send_cmd_pdu(il, C_PHY_CALIBRATION,
 				      sizeof(cmd), &cmd);
 		if (ret)
 			D_CALIB("fail sending cmd "
-				     "REPLY_PHY_CALIBRATION_CMD\n");
+				     "C_PHY_CALIBRATION\n");
 
 		/* TODO we might want recalculate
 		 * rx_chain in rxon cmd */
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index c3f8137..098d863 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -608,8 +608,8 @@ static void il4965_pass_packet_to_mac80211(struct il_priv *il,
 	rxb->page = NULL;
 }
 
-/* Called for REPLY_RX (legacy ABG frames), or
- * REPLY_RX_MPDU_CMD (HT high-throughput N frames). */
+/* Called for N_RX (legacy ABG frames), or
+ * N_RX_MPDU (HT high-throughput N frames). */
 void il4965_rx_reply_rx(struct il_priv *il,
 				struct il_rx_buf *rxb)
 {
@@ -624,15 +624,15 @@ void il4965_rx_reply_rx(struct il_priv *il,
 	u32 rate_n_flags;
 
 	/**
-	 * REPLY_RX and REPLY_RX_MPDU_CMD are handled differently.
-	 *	REPLY_RX: physical layer info is in this buffer
-	 *	REPLY_RX_MPDU_CMD: physical layer info was sent in separate
+	 * N_RX and N_RX_MPDU are handled differently.
+	 *	N_RX: physical layer info is in this buffer
+	 *	N_RX_MPDU: physical layer info was sent in separate
 	 *		command and cached in il->last_phy_res
 	 *
 	 * Here we set up local variables depending on which command is
 	 * received.
 	 */
-	if (pkt->hdr.cmd == REPLY_RX) {
+	if (pkt->hdr.cmd == N_RX) {
 		phy_res = (struct il_rx_phy_res *)pkt->u.raw;
 		header = (struct ieee80211_hdr *)(pkt->u.raw + sizeof(*phy_res)
 				+ phy_res->cfg_phy_cnt);
@@ -728,8 +728,8 @@ void il4965_rx_reply_rx(struct il_priv *il,
 				    rxb, &rx_status);
 }
 
-/* Cache phy data (Rx signal strength, etc) for HT frame (REPLY_RX_PHY_CMD).
- * This will be used later in il_rx_reply_rx() for REPLY_RX_MPDU_CMD. */
+/* Cache phy data (Rx signal strength, etc) for HT frame (N_RX_PHY).
+ * This will be used later in il_rx_reply_rx() for N_RX_MPDU. */
 void il4965_rx_reply_rx_phy(struct il_priv *il,
 			    struct il_rx_buf *rxb)
 {
@@ -827,7 +827,7 @@ static inline u32 il4965_ant_idx_to_flags(u8 ant_idx)
 int il4965_request_scan(struct il_priv *il, struct ieee80211_vif *vif)
 {
 	struct il_host_cmd cmd = {
-		.id = REPLY_SCAN_CMD,
+		.id = C_SCAN,
 		.len = sizeof(struct il_scan_cmd),
 		.flags = CMD_SIZE_HUGE,
 	};
@@ -1388,7 +1388,7 @@ void il4965_rx_stats(struct il_priv *il,
 		  msecs_to_jiffies(REG_RECALIB_PERIOD * 1000));
 
 	if (unlikely(!test_bit(S_SCANNING, &il->status)) &&
-	    (pkt->hdr.cmd == STATS_NOTIFICATION)) {
+	    (pkt->hdr.cmd == N_STATS)) {
 		il4965_rx_calc_noise(il);
 		queue_work(il->workqueue, &il->run_time_calib_work);
 	}
@@ -1473,7 +1473,7 @@ il4965_get_fifo_from_tid(struct il_rxon_context *ctx, u16 tid)
 }
 
 /*
- * handle build REPLY_TX command notification.
+ * handle build C_TX command notification.
  */
 static void il4965_tx_cmd_build_basic(struct il_priv *il,
 					struct sk_buff *skb,
@@ -1640,7 +1640,7 @@ static void il4965_tx_cmd_build_hwcrypto(struct il_priv *il,
 }
 
 /*
- * start REPLY_TX command process
+ * start C_TX command process
  */
 int il4965_tx_skb(struct il_priv *il, struct sk_buff *skb)
 {
@@ -1797,7 +1797,7 @@ int il4965_tx_skb(struct il_priv *il, struct sk_buff *skb)
 	 * after Tx, uCode's Tx response will return this value so driver can
 	 * locate the frame within the tx queue and do post-tx processing.
 	 */
-	out_cmd->hdr.cmd = REPLY_TX;
+	out_cmd->hdr.cmd = C_TX;
 	out_cmd->hdr.sequence = cpu_to_le16((u16)(QUEUE_TO_SEQ(txq_id) |
 				IDX_TO_SEQ(q->write_ptr)));
 
@@ -2616,7 +2616,7 @@ void il4965_hwrate_to_tx_control(struct il_priv *il, u32 rate_n_flags,
 }
 
 /**
- * il4965_rx_reply_compressed_ba - Handler for REPLY_COMPRESSED_BA
+ * il4965_rx_reply_compressed_ba - Handler for N_COMPRESSED_BA
  *
  * Handles block-acknowledge notification from device, which reports success
  * of frames sent via aggregation.
@@ -2668,7 +2668,7 @@ void il4965_rx_reply_compressed_ba(struct il_priv *il,
 
 	spin_lock_irqsave(&il->sta_lock, flags);
 
-	D_TX_REPLY("REPLY_COMPRESSED_BA [%d] Received from %pM, "
+	D_TX_REPLY("N_COMPRESSED_BA [%d] Received from %pM, "
 			   "sta_id = %d\n",
 			   agg->wait_for_ba,
 			   (u8 *) &ba_resp->sta_addr_lo32,
@@ -2917,7 +2917,7 @@ int il4965_remove_default_wep_key(struct il_priv *il,
 	memset(&ctx->wep_keys[keyconf->keyidx], 0, sizeof(ctx->wep_keys[0]));
 	if (il_is_rfkill(il)) {
 		D_WEP(
-		"Not sending REPLY_WEPKEY command due to RFKILL.\n");
+		"Not sending C_WEPKEY command due to RFKILL.\n");
 		/* but keys in device are clear anyway so return success */
 		return 0;
 	}
@@ -3201,7 +3201,7 @@ int il4965_remove_dynamic_key(struct il_priv *il,
 
 	if (il_is_rfkill(il)) {
 		D_WEP(
-		 "Not sending REPLY_ADD_STA command because RFKILL enabled.\n");
+		 "Not sending C_ADD_STA command because RFKILL enabled.\n");
 		spin_unlock_irqrestore(&il->sta_lock, flags);
 		return 0;
 	}
@@ -3598,7 +3598,7 @@ int il4965_send_beacon_cmd(struct il_priv *il)
 		return -EINVAL;
 	}
 
-	rc = il_send_cmd_pdu(il, REPLY_TX_BEACON, frame_size,
+	rc = il_send_cmd_pdu(il, C_TX_BEACON, frame_size,
 			      &frame->u.cmd[0]);
 
 	il4965_free_frame(il, frame);
@@ -3801,7 +3801,7 @@ static void il4965_rx_reply_alive(struct il_priv *il,
  * This callback is provided in order to send a stats request.
  *
  * This timer function is continually reset to execute within
- * REG_RECALIB_PERIOD seconds since the last STATS_NOTIFICATION
+ * REG_RECALIB_PERIOD seconds since the last N_STATS
  * was received.  We need to ensure we receive the stats in order
  * to update the temperature used for calibrating the TXPOWER.
  */
@@ -3921,37 +3921,37 @@ static void il4965_rx_card_state_notif(struct il_priv *il,
  */
 static void il4965_setup_rx_handlers(struct il_priv *il)
 {
-	il->rx_handlers[REPLY_ALIVE] = il4965_rx_reply_alive;
-	il->rx_handlers[REPLY_ERROR] = il_rx_reply_error;
-	il->rx_handlers[CHANNEL_SWITCH_NOTIFICATION] = il_rx_csa;
-	il->rx_handlers[SPECTRUM_MEASURE_NOTIFICATION] =
+	il->rx_handlers[N_ALIVE] = il4965_rx_reply_alive;
+	il->rx_handlers[N_ERROR] = il_rx_reply_error;
+	il->rx_handlers[N_CHANNEL_SWITCH] = il_rx_csa;
+	il->rx_handlers[N_SPECTRUM_MEASUREMENT] =
 			il_rx_spectrum_measure_notif;
-	il->rx_handlers[PM_SLEEP_NOTIFICATION] = il_rx_pm_sleep_notif;
-	il->rx_handlers[PM_DEBUG_STATISTIC_NOTIFIC] =
+	il->rx_handlers[N_PM_SLEEP] = il_rx_pm_sleep_notif;
+	il->rx_handlers[N_PM_DEBUG_STATS] =
 	    il_rx_pm_debug_stats_notif;
-	il->rx_handlers[BEACON_NOTIFICATION] = il4965_rx_beacon_notif;
+	il->rx_handlers[N_BEACON] = il4965_rx_beacon_notif;
 
 	/*
 	 * The same handler is used for both the REPLY to a discrete
 	 * stats request from the host as well as for the periodic
 	 * stats notifications (after received beacons) from the uCode.
 	 */
-	il->rx_handlers[REPLY_STATS_CMD] = il4965_reply_stats;
-	il->rx_handlers[STATS_NOTIFICATION] = il4965_rx_stats;
+	il->rx_handlers[C_STATS] = il4965_reply_stats;
+	il->rx_handlers[N_STATS] = il4965_rx_stats;
 
 	il_setup_rx_scan_handlers(il);
 
 	/* status change handler */
-	il->rx_handlers[CARD_STATE_NOTIFICATION] =
+	il->rx_handlers[N_CARD_STATE] =
 					il4965_rx_card_state_notif;
 
-	il->rx_handlers[MISSED_BEACONS_NOTIFICATION] =
+	il->rx_handlers[N_MISSED_BEACONS] =
 	    il4965_rx_missed_beacon_notif;
 	/* Rx handlers */
-	il->rx_handlers[REPLY_RX_PHY_CMD] = il4965_rx_reply_rx_phy;
-	il->rx_handlers[REPLY_RX_MPDU_CMD] = il4965_rx_reply_rx;
+	il->rx_handlers[N_RX_PHY] = il4965_rx_reply_rx_phy;
+	il->rx_handlers[N_RX_MPDU] = il4965_rx_reply_rx;
 	/* block ack */
-	il->rx_handlers[REPLY_COMPRESSED_BA] = il4965_rx_reply_compressed_ba;
+	il->rx_handlers[N_COMPRESSED_BA] = il4965_rx_reply_compressed_ba;
 	/* Set up hardware specific Rx handlers */
 	il->cfg->ops->lib->rx_handler_setup(il);
 }
@@ -4019,12 +4019,12 @@ void il4965_rx_handle(struct il_priv *il)
 		 * Ucode should set SEQ_RX_FRAME bit if ucode-originated,
 		 *   but apparently a few don't get set; catch them here. */
 		reclaim = !(pkt->hdr.sequence & SEQ_RX_FRAME) &&
-			(pkt->hdr.cmd != REPLY_RX_PHY_CMD) &&
-			(pkt->hdr.cmd != REPLY_RX) &&
-			(pkt->hdr.cmd != REPLY_RX_MPDU_CMD) &&
-			(pkt->hdr.cmd != REPLY_COMPRESSED_BA) &&
-			(pkt->hdr.cmd != STATS_NOTIFICATION) &&
-			(pkt->hdr.cmd != REPLY_TX);
+			(pkt->hdr.cmd != N_RX_PHY) &&
+			(pkt->hdr.cmd != N_RX) &&
+			(pkt->hdr.cmd != N_RX_MPDU) &&
+			(pkt->hdr.cmd != N_COMPRESSED_BA) &&
+			(pkt->hdr.cmd != N_STATS) &&
+			(pkt->hdr.cmd != C_TX);
 
 		/* Based on type of command response or notification,
 		 *   handle those that need handling via function in
@@ -4923,12 +4923,12 @@ static void il4965_rf_kill_ct_config(struct il_priv *il)
 	cmd.critical_temperature_R =
 		cpu_to_le32(il->hw_params.ct_kill_threshold);
 
-	ret = il_send_cmd_pdu(il, REPLY_CT_KILL_CONFIG_CMD,
+	ret = il_send_cmd_pdu(il, C_CT_KILL_CONFIG,
 			       sizeof(cmd), &cmd);
 	if (ret)
-		IL_ERR("REPLY_CT_KILL_CONFIG_CMD failed\n");
+		IL_ERR("C_CT_KILL_CONFIG failed\n");
 	else
-		D_INFO("REPLY_CT_KILL_CONFIG_CMD "
+		D_INFO("C_CT_KILL_CONFIG "
 				"succeeded, "
 				"critical temperature is %d\n",
 				il->hw_params.ct_kill_threshold);
@@ -5042,7 +5042,7 @@ static int il4965_alive_notify(struct il_priv *il)
 }
 
 /**
- * il4965_alive_start - called after REPLY_ALIVE notification received
+ * il4965_alive_start - called after N_ALIVE notification received
  *                   from protocol/runtime uCode (initialization uCode's
  *                   Alive gets handled by il_init_alive_start()).
  */
@@ -6200,12 +6200,12 @@ il4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	il->ctx.always_active = true;
 	il->ctx.is_active = true;
-	il->ctx.rxon_cmd = REPLY_RXON;
-	il->ctx.rxon_timing_cmd = REPLY_RXON_TIMING;
-	il->ctx.rxon_assoc_cmd = REPLY_RXON_ASSOC;
-	il->ctx.qos_cmd = REPLY_QOS_PARAM;
+	il->ctx.rxon_cmd = C_RXON;
+	il->ctx.rxon_timing_cmd = C_RXON_TIMING;
+	il->ctx.rxon_assoc_cmd = C_RXON_ASSOC;
+	il->ctx.qos_cmd = C_QOS_PARAM;
 	il->ctx.ap_sta_id = IL_AP_ID;
-	il->ctx.wep_key_cmd = REPLY_WEPKEY;
+	il->ctx.wep_key_cmd = C_WEPKEY;
 	il->ctx.ac_to_fifo = il4965_bss_ac_to_fifo;
 	il->ctx.ac_to_queue = il4965_bss_ac_to_queue;
 	il->ctx.exclusive_interface_modes =
diff --git a/drivers/net/wireless/iwlegacy/4965-rs.c b/drivers/net/wireless/iwlegacy/4965-rs.c
index c4bf4aa..4809a9d 100644
--- a/drivers/net/wireless/iwlegacy/4965-rs.c
+++ b/drivers/net/wireless/iwlegacy/4965-rs.c
@@ -2172,8 +2172,8 @@ out:
  *       if the driver's iwl-4965-rs rate scaling algorithm is used, instead of
  *       rc80211_simple.
  *
- * NOTE: Run REPLY_ADD_STA command to set up station table entry, before
- *       calling this function (which runs REPLY_TX_LINK_QUALITY_CMD,
+ * NOTE: Run C_ADD_STA command to set up station table entry, before
+ *       calling this function (which runs C_TX_LINK_QUALITY_CMD,
  *       which requires station table entry to exist).
  */
 static void il4965_rs_initialize_lq(struct il_priv *il,
diff --git a/drivers/net/wireless/iwlegacy/4965.c b/drivers/net/wireless/iwlegacy/4965.c
index 361a1ca..3b101c1 100644
--- a/drivers/net/wireless/iwlegacy/4965.c
+++ b/drivers/net/wireless/iwlegacy/4965.c
@@ -249,7 +249,7 @@ static int
 il4965_send_led_cmd(struct il_priv *il, struct il_led_cmd *led_cmd)
 {
 	struct il_host_cmd cmd = {
-		.id = REPLY_LEDS_CMD,
+		.id = C_LEDS,
 		.len = sizeof(struct il_led_cmd),
 		.data = led_cmd,
 		.flags = CMD_ASYNC,
@@ -465,9 +465,9 @@ static int il4965_set_ucode_ptrs(struct il_priv *il)
 }
 
 /**
- * il4965_init_alive_start - Called after REPLY_ALIVE notification received
+ * il4965_init_alive_start - Called after N_ALIVE notification received
  *
- * Called after REPLY_ALIVE notification received from "initialize" uCode.
+ * Called after N_ALIVE notification received from "initialize" uCode.
  *
  * The 4965 "initialize" ALIVE reply contains calibration data for:
  *   Voltage, temperature, and MIMO tx gain correction, now stored in il
@@ -567,10 +567,10 @@ static void il4965_chain_noise_reset(struct il_priv *il)
 		cmd.diff_gain_a = 0;
 		cmd.diff_gain_b = 0;
 		cmd.diff_gain_c = 0;
-		if (il_send_cmd_pdu(il, REPLY_PHY_CALIBRATION_CMD,
+		if (il_send_cmd_pdu(il, C_PHY_CALIBRATION,
 				 sizeof(cmd), &cmd))
 			IL_ERR(
-				"Could not send REPLY_PHY_CALIBRATION_CMD\n");
+				"Could not send C_PHY_CALIBRATION\n");
 		data->state = IL_CHAIN_NOISE_ACCUMULATE;
 		D_CALIB("Run chain_noise_calibrate\n");
 	}
@@ -1370,7 +1370,7 @@ static int il4965_send_tx_power(struct il_priv *il)
 		goto out;
 
 	ret = il_send_cmd_pdu(il,
-			 REPLY_TX_PWR_TBL_CMD, sizeof(cmd), &cmd);
+			 C_TX_PWR_TBL, sizeof(cmd), &cmd);
 
 out:
 	return ret;
@@ -1408,7 +1408,7 @@ static int il4965_send_rxon_assoc(struct il_priv *il,
 	    ctx->staging.ofdm_ht_dual_stream_basic_rates;
 	rxon_assoc.rx_chain_select_flags = ctx->staging.rx_chain;
 
-	ret = il_send_cmd_pdu_async(il, REPLY_RXON_ASSOC,
+	ret = il_send_cmd_pdu_async(il, C_RXON_ASSOC,
 				     sizeof(rxon_assoc), &rxon_assoc, NULL);
 
 	return ret;
@@ -1632,7 +1632,7 @@ static int il4965_hw_channel_switch(struct il_priv *il,
 	}
 
 	return il_send_cmd_pdu(il,
-			 REPLY_CHANNEL_SWITCH, sizeof(cmd), &cmd);
+			 C_CHANNEL_SWITCH, sizeof(cmd), &cmd);
 }
 
 /**
@@ -1795,7 +1795,7 @@ static void il4965_temperature_calib(struct il_priv *il)
 static u16 il4965_get_hcmd_size(u8 cmd_id, u16 len)
 {
 	switch (cmd_id) {
-	case REPLY_RXON:
+	case C_RXON:
 		return (u16) sizeof(struct il4965_rxon_cmd);
 	default:
 		return len;
@@ -2145,10 +2145,10 @@ static void il4965_rx_beacon_notif(struct il_priv *il,
 static void il4965_rx_handler_setup(struct il_priv *il)
 {
 	/* Legacy Rx frames */
-	il->rx_handlers[REPLY_RX] = il4965_rx_reply_rx;
+	il->rx_handlers[N_RX] = il4965_rx_reply_rx;
 	/* Tx response */
-	il->rx_handlers[REPLY_TX] = il4965_rx_reply_tx;
-	il->rx_handlers[BEACON_NOTIFICATION] = il4965_rx_beacon_notif;
+	il->rx_handlers[C_TX] = il4965_rx_reply_tx;
+	il->rx_handlers[N_BEACON] = il4965_rx_beacon_notif;
 }
 
 static struct il_hcmd_ops il4965_hcmd = {
diff --git a/drivers/net/wireless/iwlegacy/4965.h b/drivers/net/wireless/iwlegacy/4965.h
index 85c3a49..94cf7e7 100644
--- a/drivers/net/wireless/iwlegacy/4965.h
+++ b/drivers/net/wireless/iwlegacy/4965.h
@@ -278,8 +278,8 @@ static inline int il4965_hw_valid_rtc_data_addr(u32 addr)
  * uCode provides all 4 values to the driver via the "initialize alive"
  * notification (see struct il4965_init_alive_resp).  After the runtime uCode
  * image loads, uCode updates the R4 value via stats notifications
- * (see STATS_NOTIFICATION), which occur after each received beacon
- * when associated, or can be requested via REPLY_STATS_CMD.
+ * (see N_STATS), which occur after each received beacon
+ * when associated, or can be requested via C_STATS.
  *
  * NOTE:  uCode provides the R4 value as a 23-bit signed value.  Driver
  *        must sign-extend to 32 bits before applying formula below.
diff --git a/drivers/net/wireless/iwlegacy/iwl-commands.h b/drivers/net/wireless/iwlegacy/iwl-commands.h
index 1a6ca36..8df4d25 100644
--- a/drivers/net/wireless/iwlegacy/iwl-commands.h
+++ b/drivers/net/wireless/iwlegacy/iwl-commands.h
@@ -84,76 +84,76 @@ struct il_priv;
 #define IL_MAX_RATES	(IL_CCK_RATES + IL_OFDM_RATES)
 
 enum {
-	REPLY_ALIVE = 0x1,
-	REPLY_ERROR = 0x2,
+	N_ALIVE = 0x1,
+	N_ERROR = 0x2,
 
 	/* RXON and QOS commands */
-	REPLY_RXON = 0x10,
-	REPLY_RXON_ASSOC = 0x11,
-	REPLY_QOS_PARAM = 0x13,
-	REPLY_RXON_TIMING = 0x14,
+	C_RXON = 0x10,
+	C_RXON_ASSOC = 0x11,
+	C_QOS_PARAM = 0x13,
+	C_RXON_TIMING = 0x14,
 
 	/* Multi-Station support */
-	REPLY_ADD_STA = 0x18,
-	REPLY_REMOVE_STA = 0x19,
+	C_ADD_STA = 0x18,
+	C_REM_STA = 0x19,
 
 	/* Security */
-	REPLY_WEPKEY = 0x20,
+	C_WEPKEY = 0x20,
 
 	/* RX, TX, LEDs */
-	REPLY_3945_RX = 0x1b,           /* 3945 only */
-	REPLY_TX = 0x1c,
-	REPLY_RATE_SCALE = 0x47,	/* 3945 only */
-	REPLY_LEDS_CMD = 0x48,
-	REPLY_TX_LINK_QUALITY_CMD = 0x4e, /* for 4965 and up */
+	N_3945_RX = 0x1b,           /* 3945 only */
+	C_TX = 0x1c,
+	C_RATE_SCALE = 0x47,	/* 3945 only */
+	C_LEDS = 0x48,
+	C_TX_LINK_QUALITY_CMD = 0x4e, /* for 4965 */
 
 	/* 802.11h related */
-	REPLY_CHANNEL_SWITCH = 0x72,
-	CHANNEL_SWITCH_NOTIFICATION = 0x73,
-	REPLY_SPECTRUM_MEASUREMENT_CMD = 0x74,
-	SPECTRUM_MEASURE_NOTIFICATION = 0x75,
+	C_CHANNEL_SWITCH = 0x72,
+	N_CHANNEL_SWITCH = 0x73,
+	C_SPECTRUM_MEASUREMENT = 0x74,
+	N_SPECTRUM_MEASUREMENT = 0x75,
 
 	/* Power Management */
-	POWER_TBL_CMD = 0x77,
-	PM_SLEEP_NOTIFICATION = 0x7A,
-	PM_DEBUG_STATISTIC_NOTIFIC = 0x7B,
+	C_POWER_TBL = 0x77,
+	N_PM_SLEEP = 0x7A,
+	N_PM_DEBUG_STATS = 0x7B,
 
 	/* Scan commands and notifications */
-	REPLY_SCAN_CMD = 0x80,
-	REPLY_SCAN_ABORT_CMD = 0x81,
-	SCAN_START_NOTIFICATION = 0x82,
-	SCAN_RESULTS_NOTIFICATION = 0x83,
-	SCAN_COMPLETE_NOTIFICATION = 0x84,
+	C_SCAN = 0x80,
+	C_SCAN_ABORT = 0x81,
+	N_SCAN_START = 0x82,
+	N_SCAN_RESULTS = 0x83,
+	N_SCAN_COMPLETE = 0x84,
 
 	/* IBSS/AP commands */
-	BEACON_NOTIFICATION = 0x90,
-	REPLY_TX_BEACON = 0x91,
+	N_BEACON = 0x90,
+	C_TX_BEACON= 0x91,
 
 	/* Miscellaneous commands */
-	REPLY_TX_PWR_TBL_CMD = 0x97,
+	C_TX_PWR_TBL = 0x97,
 
 	/* Bluetooth device coexistence config command */
-	REPLY_BT_CONFIG = 0x9b,
+	C_BT_CONFIG = 0x9b,
 
 	/* Statistics */
-	REPLY_STATS_CMD = 0x9c,
-	STATS_NOTIFICATION = 0x9d,
+	C_STATS = 0x9c,
+	N_STATS = 0x9d,
 
 	/* RF-KILL commands and notifications */
-	CARD_STATE_NOTIFICATION = 0xa1,
+	N_CARD_STATE = 0xa1,
 
 	/* Missed beacons notification */
-	MISSED_BEACONS_NOTIFICATION = 0xa2,
+	N_MISSED_BEACONS = 0xa2,
 
-	REPLY_CT_KILL_CONFIG_CMD = 0xa4,
-	SENSITIVITY_CMD = 0xa8,
-	REPLY_PHY_CALIBRATION_CMD = 0xb0,
-	REPLY_RX_PHY_CMD = 0xc0,
-	REPLY_RX_MPDU_CMD = 0xc1,
-	REPLY_RX = 0xc3,
-	REPLY_COMPRESSED_BA = 0xc5,
+	C_CT_KILL_CONFIG = 0xa4,
+	C_SENSITIVITY = 0xa8,
+	C_PHY_CALIBRATION = 0xb0,
+	N_RX_PHY = 0xc0,
+	N_RX_MPDU = 0xc1,
+	N_RX = 0xc3,
+	N_COMPRESSED_BA = 0xc5,
 
-	REPLY_MAX = 0xff
+	IL_CN_MAX = 0xff
 };
 
 /******************************************************************************
@@ -180,7 +180,7 @@ enum {
  * driver, and each response/notification received from uCode.
  */
 struct il_cmd_header {
-	u8 cmd;		/* Command ID:  REPLY_RXON, etc. */
+	u8 cmd;		/* Command ID:  C_RXON, etc. */
 	u8 flags;	/* 0:5 reserved, 6 abort, 7 internal */
 	/*
 	 * The driver sets up the sequence number to values of its choosing.
@@ -192,7 +192,7 @@ struct il_cmd_header {
 	 * There is one exception:  uCode sets bit 15 when it originates
 	 * the response/notification, i.e. when the response/notification
 	 * is not a direct response to a command sent by the driver.  For
-	 * example, uCode issues REPLY_3945_RX when it sends a received frame
+	 * example, uCode issues N_3945_RX when it sends a received frame
 	 * to the driver; it is not a direct response to any driver command.
 	 *
 	 * The Linux driver uses the following format:
@@ -214,7 +214,7 @@ struct il_cmd_header {
 /**
  * struct il3945_tx_power
  *
- * Used in REPLY_TX_PWR_TBL_CMD, REPLY_SCAN_CMD, REPLY_CHANNEL_SWITCH
+ * Used in C_TX_PWR_TBL, C_SCAN, C_CHANNEL_SWITCH
  *
  * Each entry contains two values:
  * 1)  DSP gain (or sometimes called DSP attenuation).  This is a fine-grained
@@ -233,7 +233,7 @@ struct il3945_tx_power {
 /**
  * struct il3945_power_per_rate
  *
- * Used in REPLY_TX_PWR_TBL_CMD, REPLY_CHANNEL_SWITCH
+ * Used in C_TX_PWR_TBL, C_CHANNEL_SWITCH
  */
 struct il3945_power_per_rate {
 	u8 rate;		/* plcp */
@@ -245,10 +245,10 @@ struct il3945_power_per_rate {
  * iwl4965 rate_n_flags bit fields
  *
  * rate_n_flags format is used in following iwl4965 commands:
- *  REPLY_RX (response only)
- *  REPLY_RX_MPDU (response only)
- *  REPLY_TX (both command and response)
- *  REPLY_TX_LINK_QUALITY_CMD
+ *  N_RX (response only)
+ *  N_RX_MPDU (response only)
+ *  C_TX (both command and response)
+ *  C_TX_LINK_QUALITY_CMD
  *
  * High-throughput (HT) rate format for bits 7:0 (bit 8 must be "1"):
  *  2-0:  0)   6 Mbps
@@ -336,7 +336,7 @@ struct il3945_power_per_rate {
 /**
  * union il4965_tx_power_dual_stream
  *
- * Host format used for REPLY_TX_PWR_TBL_CMD, REPLY_CHANNEL_SWITCH
+ * Host format used for C_TX_PWR_TBL, C_CHANNEL_SWITCH
  * Use __le32 version (struct tx_power_dual_stream) when building command.
  *
  * Driver provides radio gain and DSP attenuation settings to device in pairs,
@@ -360,7 +360,7 @@ union il4965_tx_power_dual_stream {
 /**
  * struct tx_power_dual_stream
  *
- * Table entries in REPLY_TX_PWR_TBL_CMD, REPLY_CHANNEL_SWITCH
+ * Table entries in C_TX_PWR_TBL, C_CHANNEL_SWITCH
  *
  * Same format as il_tx_power_dual_stream, but __le32
  */
@@ -371,7 +371,7 @@ struct tx_power_dual_stream {
 /**
  * struct il4965_tx_power_db
  *
- * Entire table within REPLY_TX_PWR_TBL_CMD, REPLY_CHANNEL_SWITCH
+ * Entire table within C_TX_PWR_TBL, C_CHANNEL_SWITCH
  */
 struct il4965_tx_power_db {
 	struct tx_power_dual_stream power_tbl[POWER_TBL_NUM_ENTRIES];
@@ -387,7 +387,7 @@ struct il4965_tx_power_db {
 #define INITIALIZE_SUBTYPE    (9)
 
 /*
- * ("Initialize") REPLY_ALIVE = 0x1 (response only, not a command)
+ * ("Initialize") N_ALIVE = 0x1 (response only, not a command)
  *
  * uCode issues this "initialize alive" notification once the initialization
  * uCode image has completed its work, and is ready to load the runtime image.
@@ -435,7 +435,7 @@ struct il_init_alive_resp {
 
 
 /**
- * REPLY_ALIVE = 0x1 (response only, not a command)
+ * N_ALIVE = 0x1 (response only, not a command)
  *
  * uCode issues this "alive" notification once the runtime image is ready
  * to receive commands from the driver.  This is the *second* "alive"
@@ -526,7 +526,7 @@ struct il_alive_resp {
 } __packed;
 
 /*
- * REPLY_ERROR = 0x2 (response only, not a command)
+ * N_ERROR = 0x2 (response only, not a command)
  */
 struct il_error_resp {
 	__le32 error_type;
@@ -640,7 +640,7 @@ enum {
 #define RXON_FILTER_BCON_AWARE_MSK      cpu_to_le32(1 << 6)
 
 /**
- * REPLY_RXON = 0x10 (command, has simple generic response)
+ * C_RXON = 0x10 (command, has simple generic response)
  *
  * RXON tunes the radio tuner to a service channel, and sets up a number
  * of parameters that are used primarily for Rx, but also for Tx operations.
@@ -653,7 +653,7 @@ enum {
  *        channel.
  *
  * NOTE:  All RXONs wipe clean the internal txpower table.  Driver must
- *        issue a new REPLY_TX_PWR_TBL_CMD after each REPLY_RXON (0x10),
+ *        issue a new C_TX_PWR_TBL after each C_RXON (0x10),
  *        regardless of whether RXON_FILTER_ASSOC_MSK is set.
  */
 
@@ -723,7 +723,7 @@ struct il_rxon_cmd {
 
 
 /*
- * REPLY_RXON_ASSOC = 0x11 (command, has simple generic response)
+ * C_RXON_ASSOC = 0x11 (command, has simple generic response)
  */
 struct il3945_rxon_assoc_cmd {
 	__le32 flags;
@@ -749,7 +749,7 @@ struct il4965_rxon_assoc_cmd {
 #define IL39_MAX_UCODE_BEACON_INTERVAL	1 /* 1024 */
 
 /*
- * REPLY_RXON_TIMING = 0x14 (command, has simple generic response)
+ * C_RXON_TIMING = 0x14 (command, has simple generic response)
  */
 struct il_rxon_time_cmd {
 	__le64 timestamp;
@@ -762,7 +762,7 @@ struct il_rxon_time_cmd {
 } __packed;
 
 /*
- * REPLY_CHANNEL_SWITCH = 0x72 (command, has simple generic response)
+ * C_CHANNEL_SWITCH = 0x72 (command, has simple generic response)
  */
 struct il3945_channel_switch_cmd {
 	u8 band;
@@ -785,7 +785,7 @@ struct il4965_channel_switch_cmd {
 } __packed;
 
 /*
- * CHANNEL_SWITCH_NOTIFICATION = 0x73 (notification only, not a command)
+ * N_CHANNEL_SWITCH = 0x73 (notification only, not a command)
  */
 struct il_csa_notification {
 	__le16 band;
@@ -800,7 +800,7 @@ struct il_csa_notification {
  *****************************************************************************/
 
 /**
- * struct il_ac_qos -- QOS timing params for REPLY_QOS_PARAM
+ * struct il_ac_qos -- QOS timing params for C_QOS_PARAM
  * One for each of 4 EDCA access categories in struct il_qosparam_cmd
  *
  * @cw_min: Contention win, start value in numbers of slots.
@@ -832,7 +832,7 @@ struct il_ac_qos {
 #define AC_NUM                4
 
 /*
- * REPLY_QOS_PARAM = 0x13 (command, has simple generic response)
+ * C_QOS_PARAM = 0x13 (command, has simple generic response)
  *
  * This command sets up timings for each of the 4 prioritized EDCA Tx FIFOs
  * 0: Background, 1: Best Effort, 2: Video, 3: Voice.
@@ -936,15 +936,15 @@ struct sta_id_modify {
 } __packed;
 
 /*
- * REPLY_ADD_STA = 0x18 (command)
+ * C_ADD_STA = 0x18 (command)
  *
  * The device contains an internal table of per-station information,
  * with info on security keys, aggregation parameters, and Tx rates for
  * initial Tx attempt and any retries (4965 devices uses
- * REPLY_TX_LINK_QUALITY_CMD,
- * 3945 uses REPLY_RATE_SCALE to set up rate tables).
+ * C_TX_LINK_QUALITY_CMD,
+ * 3945 uses C_RATE_SCALE to set up rate tables).
  *
- * REPLY_ADD_STA sets up the table entry for one station, either creating
+ * C_ADD_STA sets up the table entry for one station, either creating
  * a new entry, or modifying a pre-existing one.
  *
  * NOTE:  RXON command (without "associated" bit set) wipes the station table
@@ -1071,7 +1071,7 @@ struct il_addsta_cmd {
 #define ADD_STA_NO_BLOCK_ACK_RESOURCE	0x4
 #define ADD_STA_MODIFY_NON_EXIST_STA	0x8
 /*
- * REPLY_ADD_STA = 0x18 (response)
+ * C_ADD_STA = 0x18 (response)
  */
 struct il_add_sta_resp {
 	u8 status;	/* ADD_STA_* */
@@ -1079,14 +1079,14 @@ struct il_add_sta_resp {
 
 #define REM_STA_SUCCESS_MSK              0x1
 /*
- *  REPLY_REM_STA = 0x19 (response)
+ *  C_REM_STA = 0x19 (response)
  */
 struct il_rem_sta_resp {
 	u8 status;
 } __packed;
 
 /*
- *  REPLY_REM_STA = 0x19 (command)
+ *  C_REM_STA = 0x19 (command)
  */
 struct il_rem_sta_cmd {
 	u8 num_sta;     /* number of removed stations */
@@ -1195,7 +1195,7 @@ struct il3945_rx_frame_end {
 } __packed;
 
 /*
- * REPLY_3945_RX = 0x1b (response only, not a command)
+ * N_3945_RX = 0x1b (response only, not a command)
  *
  * NOTE:  DO NOT dereference from casts to this structure
  * It is provided only for calculating minimum data set size.
@@ -1226,7 +1226,7 @@ struct il4965_rx_non_cfg_phy {
 
 
 /*
- * REPLY_RX = 0xc3 (response only, not a command)
+ * N_RX = 0xc3 (response only, not a command)
  * Used only for legacy (non 11n) frames.
  */
 struct il_rx_phy_res {
@@ -1254,7 +1254,7 @@ struct il_rx_mpdu_res_start {
  * (5)
  * Tx Commands & Responses:
  *
- * Driver must place each REPLY_TX command into one of the prioritized Tx
+ * Driver must place each C_TX command into one of the prioritized Tx
  * queues in host DRAM, shared between driver and device (see comments for
  * SCD registers and Tx/Rx Queues).  When the device's Tx scheduler and uCode
  * are preparing to transmit, the device pulls the Tx command over the PCI
@@ -1264,18 +1264,18 @@ struct il_rx_mpdu_res_start {
  * uCode handles all timing and protocol related to control frames
  * (RTS/CTS/ACK), based on flags in the Tx command.  uCode and Tx scheduler
  * handle reception of block-acks; uCode updates the host driver via
- * REPLY_COMPRESSED_BA.
+ * N_COMPRESSED_BA.
  *
  * uCode handles retrying Tx when an ACK is expected but not received.
  * This includes trying lower data rates than the one requested in the Tx
- * command, as set up by the REPLY_RATE_SCALE (for 3945) or
- * REPLY_TX_LINK_QUALITY_CMD (4965).
+ * command, as set up by the C_RATE_SCALE (for 3945) or
+ * C_TX_LINK_QUALITY_CMD (4965).
  *
- * Driver sets up transmit power for various rates via REPLY_TX_PWR_TBL_CMD.
+ * Driver sets up transmit power for various rates via C_TX_PWR_TBL.
  * This command must be executed after every RXON command, before Tx can occur.
  *****************************************************************************/
 
-/* REPLY_TX Tx flags field */
+/* C_TX Tx flags field */
 
 /*
  * 1: Use Request-To-Send protocol before this frame.
@@ -1296,7 +1296,7 @@ struct il_rx_mpdu_res_start {
 #define TX_CMD_FLG_ACK_MSK cpu_to_le32(1 << 3)
 
 /* For 4965 devices:
- * 1: Use rate scale table (see REPLY_TX_LINK_QUALITY_CMD).
+ * 1: Use rate scale table (see C_TX_LINK_QUALITY_CMD).
  *    Tx command's initial_rate_idx indicates first rate to try;
  *    uCode walks through table for additional Tx attempts.
  * 0: Use Tx rate/MCS from Tx command's rate_n_flags field.
@@ -1322,7 +1322,7 @@ struct il_rx_mpdu_res_start {
 /* 1: uCode overrides sequence control field in MAC header.
  * 0: Driver provides sequence control field in MAC header.
  * Set this for management frames, non-QOS data frames, non-unicast frames,
- * and also in Tx command embedded in REPLY_SCAN_CMD for active scans. */
+ * and also in Tx command embedded in C_SCAN for active scans. */
 #define TX_CMD_FLG_SEQ_CTL_MSK cpu_to_le32(1 << 13)
 
 /* 1: This frame is non-last MPDU; more fragments are coming.
@@ -1369,7 +1369,7 @@ struct il_rx_mpdu_res_start {
 #define TKIP_ICV_LEN 4
 
 /*
- * REPLY_TX = 0x1c (command)
+ * C_TX = 0x1c (command)
  */
 
 struct il3945_tx_cmd {
@@ -1434,7 +1434,7 @@ struct il3945_tx_cmd {
 } __packed;
 
 /*
- * REPLY_TX = 0x1c (response)
+ * C_TX = 0x1c (response)
  */
 struct il3945_tx_resp {
 	u8 failure_rts;
@@ -1493,7 +1493,7 @@ struct il_tx_cmd {
 	u8 sec_ctl;		/* TX_CMD_SEC_* */
 
 	/*
-	 * Index into rate table (see REPLY_TX_LINK_QUALITY_CMD) for initial
+	 * Index into rate table (see C_TX_LINK_QUALITY_CMD) for initial
 	 * Tx attempt, if TX_CMD_FLG_STA_RATE_MSK is set.  Normally "0" for
 	 * data frames, this field may be used to selectively reduce initial
 	 * rate (via non-0 value) for special frames (e.g. management), while
@@ -1671,7 +1671,7 @@ enum {
 #define AGG_TX_STATE_SEQ_NUM_MSK 0xffff0000
 
 /*
- * REPLY_TX = 0x1c (response)
+ * C_TX = 0x1c (response)
  *
  * This response may be in one of two slightly different formats, indicated
  * by the frame_count field:
@@ -1735,7 +1735,7 @@ struct il4965_tx_resp {
 } __packed;
 
 /*
- * REPLY_COMPRESSED_BA = 0xc5 (response only, not a command)
+ * N_COMPRESSED_BA = 0xc5 (response only, not a command)
  *
  * Reports Block-Acknowledge from recipient station
  */
@@ -1754,7 +1754,7 @@ struct il_compressed_ba_resp {
 } __packed;
 
 /*
- * REPLY_TX_PWR_TBL_CMD = 0x97 (command, has simple generic response)
+ * C_TX_PWR_TBL = 0x97 (command, has simple generic response)
  *
  * See details under "TXPOWER" in 4965.h.
  */
@@ -1777,7 +1777,7 @@ struct il4965_txpowertable_cmd {
 /**
  * struct il3945_rate_scaling_cmd - Rate Scaling Command & Response
  *
- * REPLY_RATE_SCALE = 0x47 (command, has simple generic response)
+ * C_RATE_SCALE = 0x47 (command, has simple generic response)
  *
  * NOTE: The table of rates passed to the uCode via the
  * RATE_SCALE command sets up the corresponding order of
@@ -1786,7 +1786,7 @@ struct il4965_txpowertable_cmd {
  *
  * For example, if you set 9MB (PLCP 0x0f) as the first
  * rate in the rate table, the bit mask for that rate
- * when passed through ofdm_basic_rates on the REPLY_RXON
+ * when passed through ofdm_basic_rates on the C_RXON
  * command would be bit 0 (1 << 0)
  */
 struct il3945_rate_scaling_info {
@@ -1820,7 +1820,7 @@ struct il3945_rate_scaling_cmd {
 /**
  * struct il_link_qual_general_params
  *
- * Used in REPLY_TX_LINK_QUALITY_CMD
+ * Used in C_TX_LINK_QUALITY_CMD
  */
 struct il_link_qual_general_params {
 	u8 flags;
@@ -1863,7 +1863,7 @@ struct il_link_qual_general_params {
 /**
  * struct il_link_qual_agg_params
  *
- * Used in REPLY_TX_LINK_QUALITY_CMD
+ * Used in C_TX_LINK_QUALITY_CMD
  */
 struct il_link_qual_agg_params {
 
@@ -1892,9 +1892,9 @@ struct il_link_qual_agg_params {
 } __packed;
 
 /*
- * REPLY_TX_LINK_QUALITY_CMD = 0x4e (command, has simple generic response)
+ * C_TX_LINK_QUALITY_CMD = 0x4e (command, has simple generic response)
  *
- * For 4965 devices only; 3945 uses REPLY_RATE_SCALE.
+ * For 4965 devices only; 3945 uses C_RATE_SCALE.
  *
  * Each station in the 4965 device's internal station table has its own table
  * of 16
@@ -1903,7 +1903,7 @@ struct il_link_qual_agg_params {
  * one station.
  *
  * NOTE:  Station must already be in 4965 device's station table.
- *	  Use REPLY_ADD_STA.
+ *	  Use C_ADD_STA.
  *
  * The rate scaling procedures described below work well.  Of course, other
  * procedures are possible, and may work better for particular environments.
@@ -2117,7 +2117,7 @@ struct il_link_quality_cmd {
 #define BT_MAX_KILL_DEF (0x5)
 
 /*
- * REPLY_BT_CONFIG = 0x9b (command, has simple generic response)
+ * C_BT_CONFIG = 0x9b (command, has simple generic response)
  *
  * 3945 and 4965 devices support hardware handshake with Bluetooth device on
  * same platform.  Bluetooth device alerts wireless device when it will Tx;
@@ -2159,7 +2159,7 @@ struct il_measure_channel {
 } __packed;
 
 /*
- * REPLY_SPECTRUM_MEASUREMENT_CMD = 0x74 (command)
+ * C_SPECTRUM_MEASUREMENT = 0x74 (command)
  */
 struct il_spectrum_cmd {
 	__le16 len;		/* number of bytes starting from token */
@@ -2178,7 +2178,7 @@ struct il_spectrum_cmd {
 } __packed;
 
 /*
- * REPLY_SPECTRUM_MEASUREMENT_CMD = 0x74 (response)
+ * C_SPECTRUM_MEASUREMENT = 0x74 (response)
  */
 struct il_spectrum_resp {
 	u8 token;
@@ -2228,7 +2228,7 @@ enum il_measure_type {
 };
 
 /*
- * SPECTRUM_MEASURE_NOTIFICATION = 0x75 (notification only, not a command)
+ * N_SPECTRUM_MEASUREMENT = 0x75 (notification only, not a command)
  */
 struct il_spectrum_notification {
 	u8 id;			/* measurement id -- 0 or 1 */
@@ -2263,7 +2263,7 @@ struct il_spectrum_notification {
  * struct il_powertable_cmd - Power Table Command
  * @flags: See below:
  *
- * POWER_TBL_CMD = 0x77 (command, has simple generic response)
+ * C_POWER_TBL = 0x77 (command, has simple generic response)
  *
  * PM allow:
  *   bit 0 - '0' Driver not allow power management
@@ -2318,7 +2318,7 @@ struct il_powertable_cmd {
 } __packed;
 
 /*
- * PM_SLEEP_NOTIFICATION = 0x7A (notification only, not a command)
+ * N_PM_SLEEP = 0x7A (notification only, not a command)
  * all devices identical.
  */
 struct il_sleep_notification {
@@ -2346,7 +2346,7 @@ enum {
 };
 
 /*
- * CARD_STATE_NOTIFICATION = 0xa1 (notification only, not a command)
+ * N_CARD_STATE = 0xa1 (notification only, not a command)
  */
 struct il_card_state_notif {
 	__le32 flags;
@@ -2373,7 +2373,7 @@ struct il_ct_kill_config {
 #define SCAN_CHANNEL_TYPE_ACTIVE  cpu_to_le32(1)
 
 /**
- * struct il_scan_channel - entry in REPLY_SCAN_CMD channel table
+ * struct il_scan_channel - entry in C_SCAN channel table
  *
  * One for each channel in the scan list.
  * Each channel can independently select:
@@ -2431,7 +2431,7 @@ struct il_scan_channel {
 /**
  * struct il_ssid_ie - directed scan network information element
  *
- * Up to 20 of these may appear in REPLY_SCAN_CMD (Note: Only 4 are in
+ * Up to 20 of these may appear in C_SCAN (Note: Only 4 are in
  * 3945 SCAN api), selected by "type" bit field in struct il_scan_channel;
  * each channel may select different ssids from among the 20 (4) entries.
  * SSID IEs get transmitted in reverse order of entry.
@@ -2452,7 +2452,7 @@ struct il_ssid_ie {
 #define IL_MAX_CMD_SIZE 4096
 
 /*
- * REPLY_SCAN_CMD = 0x80 (command)
+ * C_SCAN = 0x80 (command)
  *
  * The hardware scan command is very powerful; the driver can set it up to
  * maintain (relatively) normal network traffic while doing a scan in the
@@ -2542,7 +2542,7 @@ struct il3945_scan_cmd {
 	 *
 	 * NOTE:  Only one band of channels can be scanned per pass.  You
 	 * must not mix 2.4GHz channels and 5.2GHz channels, and you must wait
-	 * for one scan to complete (i.e. receive SCAN_COMPLETE_NOTIFICATION)
+	 * for one scan to complete (i.e. receive N_SCAN_COMPLETE)
 	 * before requesting another scan.
 	 */
 	u8 data[0];
@@ -2586,7 +2586,7 @@ struct il_scan_cmd {
 	 *
 	 * NOTE:  Only one band of channels can be scanned per pass.  You
 	 * must not mix 2.4GHz channels and 5.2GHz channels, and you must wait
-	 * for one scan to complete (i.e. receive SCAN_COMPLETE_NOTIFICATION)
+	 * for one scan to complete (i.e. receive N_SCAN_COMPLETE)
 	 * before requesting another scan.
 	 */
 	u8 data[0];
@@ -2598,14 +2598,14 @@ struct il_scan_cmd {
 #define ABORT_STATUS            0x2
 
 /*
- * REPLY_SCAN_CMD = 0x80 (response)
+ * C_SCAN = 0x80 (response)
  */
 struct il_scanreq_notification {
 	__le32 status;		/* 1: okay, 2: cannot fulfill request */
 } __packed;
 
 /*
- * SCAN_START_NOTIFICATION = 0x82 (notification only, not a command)
+ * N_SCAN_START = 0x82 (notification only, not a command)
  */
 struct il_scanstart_notification {
 	__le32 tsf_low;
@@ -2628,7 +2628,7 @@ struct il_scanstart_notification {
 
 #define NUMBER_OF_STATS 1	/* first __le32 is good CRC */
 /*
- * SCAN_RESULTS_NOTIFICATION = 0x83 (notification only, not a command)
+ * N_SCAN_RESULTS = 0x83 (notification only, not a command)
  */
 struct il_scanresults_notification {
 	u8 channel;
@@ -2641,7 +2641,7 @@ struct il_scanresults_notification {
 } __packed;
 
 /*
- * SCAN_COMPLETE_NOTIFICATION = 0x84 (notification only, not a command)
+ * N_SCAN_COMPLETE = 0x84 (notification only, not a command)
  */
 struct il_scancomplete_notification {
 	u8 scanned_channels;
@@ -2664,7 +2664,7 @@ enum il_ibss_manager {
 };
 
 /*
- * BEACON_NOTIFICATION = 0x90 (notification only, not a command)
+ * N_BEACON = 0x90 (notification only, not a command)
  */
 
 struct il3945_beacon_notif {
@@ -2682,7 +2682,7 @@ struct il4965_beacon_notif {
 } __packed;
 
 /*
- * REPLY_TX_BEACON = 0x91 (command, has simple generic response)
+ * C_TX_BEACON= 0x91 (command, has simple generic response)
  */
 
 struct il3945_tx_beacon_cmd {
@@ -2963,19 +2963,19 @@ struct stats_general {
 #define UCODE_STATS_NARROW_BAND_MSK	(0x1 << 2)
 
 /*
- * REPLY_STATS_CMD = 0x9c,
+ * C_STATS = 0x9c,
  * all devices identical.
  *
  * This command triggers an immediate response containing uCode stats.
- * The response is in the same format as STATS_NOTIFICATION 0x9d, below.
+ * The response is in the same format as N_STATS 0x9d, below.
  *
  * If the CLEAR_STATS configuration flag is set, uCode will clear its
  * internal copy of the stats (counters) after issuing the response.
- * This flag does not affect STATS_NOTIFICATIONs after beacons (see below).
+ * This flag does not affect N_STATSs after beacons (see below).
  *
  * If the DISABLE_NOTIF configuration flag is set, uCode will not issue
- * STATS_NOTIFICATIONs after received beacons (see below).  This flag
- * does not affect the response to the REPLY_STATS_CMD 0x9c itself.
+ * N_STATSs after received beacons (see below).  This flag
+ * does not affect the response to the C_STATS 0x9c itself.
  */
 #define IL_STATS_CONF_CLEAR_STATS cpu_to_le32(0x1)	/* see above */
 #define IL_STATS_CONF_DISABLE_NOTIF cpu_to_le32(0x2)/* see above */
@@ -2984,14 +2984,14 @@ struct il_stats_cmd {
 } __packed;
 
 /*
- * STATS_NOTIFICATION = 0x9d (notification only, not a command)
+ * N_STATS = 0x9d (notification only, not a command)
  *
  * By default, uCode issues this notification after receiving a beacon
  * while associated.  To disable this behavior, set DISABLE_NOTIF flag in the
- * REPLY_STATS_CMD 0x9c, above.
+ * C_STATS 0x9c, above.
  *
  * Statistics counters continue to increment beacon after beacon, but are
- * cleared when changing channels or when driver issues REPLY_STATS_CMD
+ * cleared when changing channels or when driver issues C_STATS
  * 0x9c with CLEAR_STATS bit set (see above).
  *
  * uCode also issues this notification during scans.  uCode clears stats
@@ -3016,9 +3016,9 @@ struct il_notif_stats {
 } __packed;
 
 /*
- * MISSED_BEACONS_NOTIFICATION = 0xa2 (notification only, not a command)
+ * N_MISSED_BEACONS = 0xa2 (notification only, not a command)
  *
- * uCode send MISSED_BEACONS_NOTIFICATION to driver when detect beacon missed
+ * uCode send N_MISSED_BEACONS to driver when detect beacon missed
  * in regardless of how many missed beacons, which mean when driver receive the
  * notification, inside the command, it can find all the beacons information
  * which include number of total missed beacons, number of consecutive missed
@@ -3062,7 +3062,7 @@ struct il_missed_beacon_notif {
  *****************************************************************************/
 
 /**
- * SENSITIVITY_CMD = 0xa8 (command, has simple generic response)
+ * C_SENSITIVITY = 0xa8 (command, has simple generic response)
  *
  * This command sets up the Rx signal detector for a sensitivity level that
  * is high enough to lock onto all signals within the associated network,
@@ -3076,7 +3076,7 @@ struct il_missed_beacon_notif {
  * time listening, not transmitting).  Driver must adjust sensitivity so that
  * the ratio of actual false alarms to actual Rx time falls within this range.
  *
- * While associated, uCode delivers STATS_NOTIFICATIONs after each
+ * While associated, uCode delivers N_STATSs after each
  * received beacon.  These provide information to the driver to analyze the
  * sensitivity.  Don't analyze stats that come in from scanning, or any
  * other non-associated-network source.  Pertinent stats include:
@@ -3217,7 +3217,7 @@ struct il_missed_beacon_notif {
  */
 
 /*
- * Table entries in SENSITIVITY_CMD (struct il_sensitivity_cmd)
+ * Table entries in C_SENSITIVITY (struct il_sensitivity_cmd)
  */
 #define HD_TBL_SIZE  (11)	/* number of entries */
 #define HD_MIN_ENERGY_CCK_DET_IDX                 (0)	/* table idxes */
@@ -3233,8 +3233,8 @@ struct il_missed_beacon_notif {
 #define HD_OFDM_ENERGY_TH_IN_IDX                  (10)
 
 /* Control field in struct il_sensitivity_cmd */
-#define SENSITIVITY_CMD_CONTROL_DEFAULT_TBL	cpu_to_le16(0)
-#define SENSITIVITY_CMD_CONTROL_WORK_TBL	cpu_to_le16(1)
+#define C_SENSITIVITY_CONTROL_DEFAULT_TBL	cpu_to_le16(0)
+#define C_SENSITIVITY_CONTROL_WORK_TBL	cpu_to_le16(1)
 
 /**
  * struct il_sensitivity_cmd
@@ -3250,12 +3250,12 @@ struct il_sensitivity_cmd {
 
 
 /**
- * REPLY_PHY_CALIBRATION_CMD = 0xb0 (command, has simple generic response)
+ * C_PHY_CALIBRATION = 0xb0 (command, has simple generic response)
  *
  * This command sets the relative gains of 4965 device's 3 radio receiver chains.
  *
  * After the first association, driver should accumulate signal and noise
- * stats from the STATS_NOTIFICATIONs that follow the first 20
+ * stats from the N_STATSs that follow the first 20
  * beacons from the associated network (don't collect stats that come
  * in from scanning, or any other non-network source).
  *
@@ -3338,7 +3338,7 @@ struct il_calib_diff_gain_cmd {
 
 /*
  * LEDs Command & Response
- * REPLY_LEDS_CMD = 0x48 (command, has simple generic response)
+ * C_LEDS = 0x48 (command, has simple generic response)
  *
  * For each of 3 possible LEDs (Activity/Link/Tech, selected by "id" field),
  * this command turns it on or off, or sets up a periodic blinking cycle.
diff --git a/drivers/net/wireless/iwlegacy/iwl-core.c b/drivers/net/wireless/iwlegacy/iwl-core.c
index e6c7d5f..baed3dc 100644
--- a/drivers/net/wireless/iwlegacy/iwl-core.c
+++ b/drivers/net/wireless/iwlegacy/iwl-core.c
@@ -1165,7 +1165,7 @@ void il_send_bt_config(struct il_priv *il)
 	D_INFO("BT coex %s\n",
 		(bt_cmd.flags == BT_COEX_DISABLE) ? "disable" : "active");
 
-	if (il_send_cmd_pdu(il, REPLY_BT_CONFIG,
+	if (il_send_cmd_pdu(il, C_BT_CONFIG,
 			     sizeof(struct il_bt_cmd), &bt_cmd))
 		IL_ERR("failed to send BT Coex Config\n");
 }
@@ -1179,11 +1179,11 @@ int il_send_stats_request(struct il_priv *il, u8 flags, bool clear)
 	};
 
 	if (flags & CMD_ASYNC)
-		return il_send_cmd_pdu_async(il, REPLY_STATS_CMD,
+		return il_send_cmd_pdu_async(il, C_STATS,
 					sizeof(struct il_stats_cmd),
 					&stats_cmd, NULL);
 	else
-		return il_send_cmd_pdu(il, REPLY_STATS_CMD,
+		return il_send_cmd_pdu(il, C_STATS,
 					sizeof(struct il_stats_cmd),
 					&stats_cmd);
 }
diff --git a/drivers/net/wireless/iwlegacy/iwl-debugfs.c b/drivers/net/wireless/iwlegacy/iwl-debugfs.c
index b9888ac..4076b79 100644
--- a/drivers/net/wireless/iwlegacy/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlegacy/iwl-debugfs.c
@@ -554,7 +554,7 @@ static ssize_t il_dbgfs_interrupt_read(struct file *file,
 	pos += scnprintf(buf + pos, bufsz - pos,
 		"Rx command responses:\t\t %u\n",
 		il->isr_stats.rx);
-	for (cnt = 0; cnt < REPLY_MAX; cnt++) {
+	for (cnt = 0; cnt < IL_CN_MAX; cnt++) {
 		if (il->isr_stats.rx_handlers[cnt] > 0)
 			pos += scnprintf(buf + pos, bufsz - pos,
 				"\tRx handler[%36s]:\t\t %u\n",
diff --git a/drivers/net/wireless/iwlegacy/iwl-dev.h b/drivers/net/wireless/iwlegacy/iwl-dev.h
index f7c3b43..1bc4a71 100644
--- a/drivers/net/wireless/iwlegacy/iwl-dev.h
+++ b/drivers/net/wireless/iwlegacy/iwl-dev.h
@@ -383,8 +383,8 @@ struct il_rx_queue {
  * @bitmap1: High order, one bit for each frame pending ACK in Tx win
  * @rate_n_flags: Rate at which Tx was attempted
  *
- * If REPLY_TX indicates that aggregation was attempted, driver must wait
- * for block ack (REPLY_COMPRESSED_BA).  This struct stores tx reply info
+ * If C_TX indicates that aggregation was attempted, driver must wait
+ * for block ack (N_COMPRESSED_BA).  This struct stores tx reply info
  * until block ack arrives.
  */
 struct il_ht_agg {
@@ -813,7 +813,7 @@ struct isr_stats {
 	u32 ctkill;
 	u32 wakeup;
 	u32 rx;
-	u32 rx_handlers[REPLY_MAX];
+	u32 rx_handlers[IL_CN_MAX];
 	u32 tx;
 	u32 unhandled;
 };
@@ -968,7 +968,7 @@ struct il_priv {
 	enum ieee80211_band band;
 	int alloc_rxb_page;
 
-	void (*rx_handlers[REPLY_MAX])(struct il_priv *il,
+	void (*rx_handlers[IL_CN_MAX])(struct il_priv *il,
 				       struct il_rx_buf *rxb);
 
 	struct ieee80211_supported_band bands[IEEE80211_NUM_BANDS];
diff --git a/drivers/net/wireless/iwlegacy/iwl-hcmd.c b/drivers/net/wireless/iwlegacy/iwl-hcmd.c
index 19a5955..670a398 100644
--- a/drivers/net/wireless/iwlegacy/iwl-hcmd.c
+++ b/drivers/net/wireless/iwlegacy/iwl-hcmd.c
@@ -40,47 +40,47 @@
 const char *il_get_cmd_string(u8 cmd)
 {
 	switch (cmd) {
-		IL_CMD(REPLY_ALIVE);
-		IL_CMD(REPLY_ERROR);
-		IL_CMD(REPLY_RXON);
-		IL_CMD(REPLY_RXON_ASSOC);
-		IL_CMD(REPLY_QOS_PARAM);
-		IL_CMD(REPLY_RXON_TIMING);
-		IL_CMD(REPLY_ADD_STA);
-		IL_CMD(REPLY_REMOVE_STA);
-		IL_CMD(REPLY_WEPKEY);
-		IL_CMD(REPLY_3945_RX);
-		IL_CMD(REPLY_TX);
-		IL_CMD(REPLY_RATE_SCALE);
-		IL_CMD(REPLY_LEDS_CMD);
-		IL_CMD(REPLY_TX_LINK_QUALITY_CMD);
-		IL_CMD(REPLY_CHANNEL_SWITCH);
-		IL_CMD(CHANNEL_SWITCH_NOTIFICATION);
-		IL_CMD(REPLY_SPECTRUM_MEASUREMENT_CMD);
-		IL_CMD(SPECTRUM_MEASURE_NOTIFICATION);
-		IL_CMD(POWER_TBL_CMD);
-		IL_CMD(PM_SLEEP_NOTIFICATION);
-		IL_CMD(PM_DEBUG_STATISTIC_NOTIFIC);
-		IL_CMD(REPLY_SCAN_CMD);
-		IL_CMD(REPLY_SCAN_ABORT_CMD);
-		IL_CMD(SCAN_START_NOTIFICATION);
-		IL_CMD(SCAN_RESULTS_NOTIFICATION);
-		IL_CMD(SCAN_COMPLETE_NOTIFICATION);
-		IL_CMD(BEACON_NOTIFICATION);
-		IL_CMD(REPLY_TX_BEACON);
-		IL_CMD(REPLY_TX_PWR_TBL_CMD);
-		IL_CMD(REPLY_BT_CONFIG);
-		IL_CMD(REPLY_STATS_CMD);
-		IL_CMD(STATS_NOTIFICATION);
-		IL_CMD(CARD_STATE_NOTIFICATION);
-		IL_CMD(MISSED_BEACONS_NOTIFICATION);
-		IL_CMD(REPLY_CT_KILL_CONFIG_CMD);
-		IL_CMD(SENSITIVITY_CMD);
-		IL_CMD(REPLY_PHY_CALIBRATION_CMD);
-		IL_CMD(REPLY_RX_PHY_CMD);
-		IL_CMD(REPLY_RX_MPDU_CMD);
-		IL_CMD(REPLY_RX);
-		IL_CMD(REPLY_COMPRESSED_BA);
+		IL_CMD(N_ALIVE);
+		IL_CMD(N_ERROR);
+		IL_CMD(C_RXON);
+		IL_CMD(C_RXON_ASSOC);
+		IL_CMD(C_QOS_PARAM);
+		IL_CMD(C_RXON_TIMING);
+		IL_CMD(C_ADD_STA);
+		IL_CMD(C_REM_STA);
+		IL_CMD(C_WEPKEY);
+		IL_CMD(N_3945_RX);
+		IL_CMD(C_TX);
+		IL_CMD(C_RATE_SCALE);
+		IL_CMD(C_LEDS);
+		IL_CMD(C_TX_LINK_QUALITY_CMD);
+		IL_CMD(C_CHANNEL_SWITCH);
+		IL_CMD(N_CHANNEL_SWITCH);
+		IL_CMD(C_SPECTRUM_MEASUREMENT);
+		IL_CMD(N_SPECTRUM_MEASUREMENT);
+		IL_CMD(C_POWER_TBL);
+		IL_CMD(N_PM_SLEEP);
+		IL_CMD(N_PM_DEBUG_STATS);
+		IL_CMD(C_SCAN);
+		IL_CMD(C_SCAN_ABORT);
+		IL_CMD(N_SCAN_START);
+		IL_CMD(N_SCAN_RESULTS);
+		IL_CMD(N_SCAN_COMPLETE);
+		IL_CMD(N_BEACON);
+		IL_CMD(C_TX_BEACON);
+		IL_CMD(C_TX_PWR_TBL);
+		IL_CMD(C_BT_CONFIG);
+		IL_CMD(C_STATS);
+		IL_CMD(N_STATS);
+		IL_CMD(N_CARD_STATE);
+		IL_CMD(N_MISSED_BEACONS);
+		IL_CMD(C_CT_KILL_CONFIG);
+		IL_CMD(C_SENSITIVITY);
+		IL_CMD(C_PHY_CALIBRATION);
+		IL_CMD(N_RX_PHY);
+		IL_CMD(N_RX_MPDU);
+		IL_CMD(N_RX);
+		IL_CMD(N_COMPRESSED_BA);
 	default:
 		return "UNKNOWN";
 
@@ -102,8 +102,8 @@ static void il_generic_cmd_callback(struct il_priv *il,
 
 #ifdef CONFIG_IWLEGACY_DEBUG
 	switch (cmd->hdr.cmd) {
-	case REPLY_TX_LINK_QUALITY_CMD:
-	case SENSITIVITY_CMD:
+	case C_TX_LINK_QUALITY_CMD:
+	case C_SENSITIVITY:
 		D_HC_DUMP("back from %s (0x%08X)\n",
 		il_get_cmd_string(cmd->hdr.cmd), pkt->hdr.flags);
 		break;
diff --git a/drivers/net/wireless/iwlegacy/iwl-power.c b/drivers/net/wireless/iwlegacy/iwl-power.c
index c66a0f7..2b06a95 100644
--- a/drivers/net/wireless/iwlegacy/iwl-power.c
+++ b/drivers/net/wireless/iwlegacy/iwl-power.c
@@ -88,7 +88,7 @@ il_set_power(struct il_priv *il, struct il_powertable_cmd *cmd)
 			le32_to_cpu(cmd->sleep_interval[3]),
 			le32_to_cpu(cmd->sleep_interval[4]));
 
-	return il_send_cmd_pdu(il, POWER_TBL_CMD,
+	return il_send_cmd_pdu(il, C_POWER_TBL,
 				sizeof(struct il_powertable_cmd), cmd);
 }
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-prph.h b/drivers/net/wireless/iwlegacy/iwl-prph.h
index b0bf684..029ea8a 100644
--- a/drivers/net/wireless/iwlegacy/iwl-prph.h
+++ b/drivers/net/wireless/iwlegacy/iwl-prph.h
@@ -189,7 +189,7 @@
  *        procedure.
  *
  * This save/restore method is mostly for autonomous power management during
- * normal operation (result of POWER_TBL_CMD).  Platform suspend/resume and
+ * normal operation (result of C_POWER_TBL).  Platform suspend/resume and
  * RFKILL should use complete restarts (with total re-initialization) of uCode,
  * allowing total shutdown (including BSM memory).
  *
diff --git a/drivers/net/wireless/iwlegacy/iwl-scan.c b/drivers/net/wireless/iwlegacy/iwl-scan.c
index 6d20f2b..1f81d56 100644
--- a/drivers/net/wireless/iwlegacy/iwl-scan.c
+++ b/drivers/net/wireless/iwlegacy/iwl-scan.c
@@ -59,7 +59,7 @@ static int il_send_scan_abort(struct il_priv *il)
 	int ret;
 	struct il_rx_pkt *pkt;
 	struct il_host_cmd cmd = {
-		.id = REPLY_SCAN_ABORT_CMD,
+		.id = C_SCAN_ABORT,
 		.flags = CMD_WANT_SKB,
 	};
 
@@ -181,7 +181,7 @@ int il_scan_cancel_timeout(struct il_priv *il, unsigned long ms)
 }
 EXPORT_SYMBOL(il_scan_cancel_timeout);
 
-/* Service response to REPLY_SCAN_CMD (0x80) */
+/* Service response to C_SCAN (0x80) */
 static void il_rx_reply_scan(struct il_priv *il,
 			      struct il_rx_buf *rxb)
 {
@@ -194,7 +194,7 @@ static void il_rx_reply_scan(struct il_priv *il,
 #endif
 }
 
-/* Service SCAN_START_NOTIFICATION (0x82) */
+/* Service N_SCAN_START (0x82) */
 static void il_rx_scan_start_notif(struct il_priv *il,
 				    struct il_rx_buf *rxb)
 {
@@ -212,7 +212,7 @@ static void il_rx_scan_start_notif(struct il_priv *il,
 		       notif->status, notif->beacon_timer);
 }
 
-/* Service SCAN_RESULTS_NOTIFICATION (0x83) */
+/* Service N_SCAN_RESULTS (0x83) */
 static void il_rx_scan_results_notif(struct il_priv *il,
 				      struct il_rx_buf *rxb)
 {
@@ -234,7 +234,7 @@ static void il_rx_scan_results_notif(struct il_priv *il,
 #endif
 }
 
-/* Service SCAN_COMPLETE_NOTIFICATION (0x84) */
+/* Service N_SCAN_COMPLETE (0x84) */
 static void il_rx_scan_complete_notif(struct il_priv *il,
 				       struct il_rx_buf *rxb)
 {
@@ -263,12 +263,12 @@ static void il_rx_scan_complete_notif(struct il_priv *il,
 void il_setup_rx_scan_handlers(struct il_priv *il)
 {
 	/* scan handlers */
-	il->rx_handlers[REPLY_SCAN_CMD] = il_rx_reply_scan;
-	il->rx_handlers[SCAN_START_NOTIFICATION] =
+	il->rx_handlers[C_SCAN] = il_rx_reply_scan;
+	il->rx_handlers[N_SCAN_START] =
 					il_rx_scan_start_notif;
-	il->rx_handlers[SCAN_RESULTS_NOTIFICATION] =
+	il->rx_handlers[N_SCAN_RESULTS] =
 					il_rx_scan_results_notif;
-	il->rx_handlers[SCAN_COMPLETE_NOTIFICATION] =
+	il->rx_handlers[N_SCAN_COMPLETE] =
 					il_rx_scan_complete_notif;
 }
 EXPORT_SYMBOL(il_setup_rx_scan_handlers);
diff --git a/drivers/net/wireless/iwlegacy/iwl-sta.c b/drivers/net/wireless/iwlegacy/iwl-sta.c
index ffb966b..58762e7 100644
--- a/drivers/net/wireless/iwlegacy/iwl-sta.c
+++ b/drivers/net/wireless/iwlegacy/iwl-sta.c
@@ -67,7 +67,7 @@ static int il_process_add_sta_resp(struct il_priv *il,
 	int ret = -EIO;
 
 	if (pkt->hdr.flags & IL_CMD_FAILED_MSK) {
-		IL_ERR("Bad return from REPLY_ADD_STA (0x%08X)\n",
+		IL_ERR("Bad return from C_ADD_STA (0x%08X)\n",
 			pkt->hdr.flags);
 		return ret;
 	}
@@ -79,7 +79,7 @@ static int il_process_add_sta_resp(struct il_priv *il,
 
 	switch (pkt->u.add_sta.status) {
 	case ADD_STA_SUCCESS_MSK:
-		D_INFO("REPLY_ADD_STA PASSED\n");
+		D_INFO("C_ADD_STA PASSED\n");
 		il_sta_ucode_activate(il, sta_id);
 		ret = 0;
 		break;
@@ -97,7 +97,7 @@ static int il_process_add_sta_resp(struct il_priv *il,
 			sta_id);
 		break;
 	default:
-		D_ASSOC("Received REPLY_ADD_STA:(0x%08X)\n",
+		D_ASSOC("Received C_ADD_STA:(0x%08X)\n",
 				pkt->u.add_sta.status);
 		break;
 	}
@@ -142,7 +142,7 @@ int il_send_add_sta(struct il_priv *il,
 	int ret = 0;
 	u8 data[sizeof(*sta)];
 	struct il_host_cmd cmd = {
-		.id = REPLY_ADD_STA,
+		.id = C_ADD_STA,
 		.flags = flags,
 		.data = data,
 	};
@@ -290,7 +290,7 @@ u8 il_prep_station(struct il_priv *il, struct il_rxon_context *ctx,
 			sta_id, addr);
 	il->num_stations++;
 
-	/* Set up the REPLY_ADD_STA command to send to device */
+	/* Set up the C_ADD_STA command to send to device */
 	memset(&station->sta, 0, sizeof(struct il_addsta_cmd));
 	memcpy(station->sta.sta.addr, addr, ETH_ALEN);
 	station->sta.mode = 0;
@@ -421,7 +421,7 @@ static int il_send_remove_station(struct il_priv *il,
 	struct il_rem_sta_cmd rm_sta_cmd;
 
 	struct il_host_cmd cmd = {
-		.id = REPLY_REMOVE_STA,
+		.id = C_REM_STA,
 		.len = sizeof(struct il_rem_sta_cmd),
 		.flags = CMD_SYNC,
 		.data = &rm_sta_cmd,
@@ -440,7 +440,7 @@ static int il_send_remove_station(struct il_priv *il,
 
 	pkt = (struct il_rx_pkt *)cmd.reply_page;
 	if (pkt->hdr.flags & IL_CMD_FAILED_MSK) {
-		IL_ERR("Bad return from REPLY_REMOVE_STA (0x%08X)\n",
+		IL_ERR("Bad return from C_REM_STA (0x%08X)\n",
 			  pkt->hdr.flags);
 		ret = -EIO;
 	}
@@ -454,11 +454,11 @@ static int il_send_remove_station(struct il_priv *il,
 				spin_unlock_irqrestore(&il->sta_lock,
 								flags_spin);
 			}
-			D_ASSOC("REPLY_REMOVE_STA PASSED\n");
+			D_ASSOC("C_REM_STA PASSED\n");
 			break;
 		default:
 			ret = -EIO;
-			IL_ERR("REPLY_REMOVE_STA failed\n");
+			IL_ERR("C_REM_STA failed\n");
 			break;
 		}
 	}
@@ -753,7 +753,7 @@ int il_send_lq_cmd(struct il_priv *il, struct il_rxon_context *ctx,
 	unsigned long flags_spin;
 
 	struct il_host_cmd cmd = {
-		.id = REPLY_TX_LINK_QUALITY_CMD,
+		.id = C_TX_LINK_QUALITY_CMD,
 		.len = sizeof(struct il_link_quality_cmd),
 		.flags = flags,
 		.data = lq,
diff --git a/drivers/net/wireless/iwlegacy/iwl-tx.c b/drivers/net/wireless/iwlegacy/iwl-tx.c
index 3f97d09..3b588b3 100644
--- a/drivers/net/wireless/iwlegacy/iwl-tx.c
+++ b/drivers/net/wireless/iwlegacy/iwl-tx.c
@@ -509,8 +509,8 @@ int il_enqueue_hcmd(struct il_priv *il, struct il_host_cmd *cmd)
 
 #ifdef CONFIG_IWLEGACY_DEBUG
 	switch (out_cmd->hdr.cmd) {
-	case REPLY_TX_LINK_QUALITY_CMD:
-	case SENSITIVITY_CMD:
+	case C_TX_LINK_QUALITY_CMD:
+	case C_SENSITIVITY:
 		D_HC_DUMP(
 				"Sending command %s (#%x), seq: 0x%04X, "
 				"%d bytes at %d[%d]:%d\n",
-- 
1.7.1

