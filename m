Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:1940 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603Ab1ITXXb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 19:23:31 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 4/8] iwlagn: remove the callback in host commands
Date: Tue, 20 Sep 2011 15:37:23 -0700
Message-Id: <1316558247-10018-5-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110921_012342_935090_50CEBEEC)
In-Reply-To: <1316558247-10018-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1316558247-10018-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Before this patch, the upper layer could register a callback for each
host command. This mechanism allowed the upper layer to have
different callbacks for the same command ID. In fact, it wasn't used
and the rx_handlers is enough: same callback for all the command with
a specific command ID.

The iwl_send_add_station needs the access the command that was sent
while handling the response (regardless if the command was sent in
SYNC or ASYNC mode). So now, all the handlers receive the host
command that was sent. This implies a change in the handler signature.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c        |    8 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c         |   16 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c      |    8 +-
 drivers/net/wireless/iwlwifi/iwl-agn.h            |   18 +++--
 drivers/net/wireless/iwlwifi/iwl-dev.h            |    5 +-
 drivers/net/wireless/iwlwifi/iwl-led.c            |    1 -
 drivers/net/wireless/iwlwifi/iwl-rx.c             |   95 +++++++++++++-------
 drivers/net/wireless/iwlwifi/iwl-scan.c           |   25 ++++--
 drivers/net/wireless/iwlwifi/iwl-shared.h         |    5 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c            |   29 +++----
 drivers/net/wireless/iwlwifi/iwl-sta.h            |    3 +
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |   12 +---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c  |   17 +++-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c  |   42 ++--------
 drivers/net/wireless/iwlwifi/iwl-trans.h          |    7 +-
 15 files changed, 157 insertions(+), 134 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 0a1f331..d30714b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -705,8 +705,9 @@ static void iwlagn_set_kill_msk(struct iwl_priv *priv,
 	}
 }
 
-void iwlagn_bt_coex_profile_notif(struct iwl_priv *priv,
-					     struct iwl_rx_mem_buffer *rxb)
+int iwlagn_bt_coex_profile_notif(struct iwl_priv *priv,
+				  struct iwl_rx_mem_buffer *rxb,
+				  struct iwl_device_cmd *cmd)
 {
 	unsigned long flags;
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
@@ -715,7 +716,7 @@ void iwlagn_bt_coex_profile_notif(struct iwl_priv *priv,
 
 	if (priv->bt_enable_flag == IWLAGN_BT_FLAG_COEX_MODE_DISABLED) {
 		/* bt coex disabled */
-		return;
+		return 0;
 	}
 
 	IWL_DEBUG_COEX(priv, "BT Coex notification:\n");
@@ -757,6 +758,7 @@ void iwlagn_bt_coex_profile_notif(struct iwl_priv *priv,
 	spin_lock_irqsave(&priv->shrd->lock, flags);
 	priv->bt_ci_compliance = coex->bt_ci_compliance;
 	spin_unlock_irqrestore(&priv->shrd->lock, flags);
+	return 0;
 }
 
 void iwlagn_bt_rx_handler_setup(struct iwl_priv *priv)
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 459b82b..4aa414a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -736,7 +736,8 @@ static void iwl_check_abort_status(struct iwl_priv *priv,
 	}
 }
 
-void iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
+int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb,
+			       struct iwl_device_cmd *cmd)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
@@ -824,6 +825,7 @@ void iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 
 	iwl_check_abort_status(priv, tx_resp->frame_count, status);
 	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
+	return 0;
 }
 
 /**
@@ -832,8 +834,9 @@ void iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
  * Handles block-acknowledge notification from device, which reports success
  * of frames sent via aggregation.
  */
-void iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
-					   struct iwl_rx_mem_buffer *rxb)
+int iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
+				   struct iwl_rx_mem_buffer *rxb,
+				   struct iwl_device_cmd *cmd)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_compressed_ba_resp *ba_resp = &pkt->u.compressed_ba;
@@ -857,7 +860,7 @@ void iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 	if (scd_flow >= hw_params(priv).max_txq_num) {
 		IWL_ERR(priv,
 			"BUG_ON scd_flow is bigger than number of queues\n");
-		return;
+		return 0;
 	}
 
 	sta_id = ba_resp->sta_id;
@@ -877,14 +880,14 @@ void iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 			"BA scd_flow %d does not match txq_id %d\n",
 			scd_flow, agg->txq_id);
 		spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
-		return;
+		return 0;
 	}
 
 	if (unlikely(!agg->wait_for_ba)) {
 		if (unlikely(ba_resp->bitmap))
 			IWL_ERR(priv, "Received BA when not expected\n");
 		spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
-		return;
+		return 0;
 	}
 
 	IWL_DEBUG_TX_REPLY(priv, "REPLY_COMPRESSED_BA [%d] Received from %pM, "
@@ -955,4 +958,5 @@ void iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 	}
 
 	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
+	return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index 634f18f..b4e1e7c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -228,8 +228,9 @@ static int iwlagn_send_calib_cfg(struct iwl_priv *priv)
 	return iwl_trans_send_cmd(trans(priv), &cmd);
 }
 
-void iwlagn_rx_calib_result(struct iwl_priv *priv,
-			     struct iwl_rx_mem_buffer *rxb)
+int iwlagn_rx_calib_result(struct iwl_priv *priv,
+			    struct iwl_rx_mem_buffer *rxb,
+			    struct iwl_device_cmd *cmd)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_calib_hdr *hdr = (struct iwl_calib_hdr *)pkt->u.raw;
@@ -262,9 +263,10 @@ void iwlagn_rx_calib_result(struct iwl_priv *priv,
 	default:
 		IWL_ERR(priv, "Unknown calibration notification %d\n",
 			  hdr->op_code);
-		return;
+		return -1;
 	}
 	iwl_calib_set(&priv->calib_results[index], pkt->u.raw, len);
+	return 0;
 }
 
 int iwlagn_init_alive_start(struct iwl_priv *priv)
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 5c4f8c7..2a297d1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -88,8 +88,9 @@ void iwlagn_bss_info_changed(struct ieee80211_hw *hw,
 			     u32 changes);
 
 /* uCode */
-void iwlagn_rx_calib_result(struct iwl_priv *priv,
-			 struct iwl_rx_mem_buffer *rxb);
+int iwlagn_rx_calib_result(struct iwl_priv *priv,
+			    struct iwl_rx_mem_buffer *rxb,
+			    struct iwl_device_cmd *cmd);
 int iwlagn_send_bt_env(struct iwl_priv *priv, u8 action, u8 type);
 void iwlagn_send_prio_tbl(struct iwl_priv *priv);
 int iwlagn_run_init_ucode(struct iwl_priv *priv);
@@ -116,9 +117,11 @@ int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
 			struct ieee80211_sta *sta, u16 tid, u16 *ssn);
 int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
 		       struct ieee80211_sta *sta, u16 tid);
-void iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
-				struct iwl_rx_mem_buffer *rxb);
-void iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb);
+int iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
+				   struct iwl_rx_mem_buffer *rxb,
+				   struct iwl_device_cmd *cmd);
+int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb,
+			       struct iwl_device_cmd *cmd);
 
 static inline u32 iwl_tx_status_to_mac80211(u32 status)
 {
@@ -155,8 +158,9 @@ int iwlagn_manage_ibss_station(struct iwl_priv *priv,
 
 /* bt coex */
 void iwlagn_send_advance_bt_config(struct iwl_priv *priv);
-void iwlagn_bt_coex_profile_notif(struct iwl_priv *priv,
-				  struct iwl_rx_mem_buffer *rxb);
+int iwlagn_bt_coex_profile_notif(struct iwl_priv *priv,
+				  struct iwl_rx_mem_buffer *rxb,
+				  struct iwl_device_cmd *cmd);
 void iwlagn_bt_rx_handler_setup(struct iwl_priv *priv);
 void iwlagn_bt_setup_deferred_work(struct iwl_priv *priv);
 void iwlagn_bt_cancel_deferred_work(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 7f534c4..4ddaf2c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -841,8 +841,9 @@ struct iwl_priv {
 
 	void (*pre_rx_handler)(struct iwl_priv *priv,
 			       struct iwl_rx_mem_buffer *rxb);
-	void (*rx_handlers[REPLY_MAX])(struct iwl_priv *priv,
-				       struct iwl_rx_mem_buffer *rxb);
+	int (*rx_handlers[REPLY_MAX])(struct iwl_priv *priv,
+				       struct iwl_rx_mem_buffer *rxb,
+				       struct iwl_device_cmd *cmd);
 
 	struct ieee80211_supported_band bands[IEEE80211_NUM_BANDS];
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index 7dffed1..f149165 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -104,7 +104,6 @@ static int iwl_send_led_cmd(struct iwl_priv *priv, struct iwl_led_cmd *led_cmd)
 		.len = { sizeof(struct iwl_led_cmd), },
 		.data = { led_cmd, },
 		.flags = CMD_ASYNC,
-		.callback = NULL,
 	};
 	u32 reg;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 2ee6103..bcd7f64 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -130,8 +130,9 @@ const char *get_cmd_string(u8 cmd)
  *
  ******************************************************************************/
 
-static void iwl_rx_reply_error(struct iwl_priv *priv,
-			       struct iwl_rx_mem_buffer *rxb)
+static int iwl_rx_reply_error(struct iwl_priv *priv,
+			       struct iwl_rx_mem_buffer *rxb,
+			       struct iwl_device_cmd *cmd)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 
@@ -142,9 +143,11 @@ static void iwl_rx_reply_error(struct iwl_priv *priv,
 		pkt->u.err_resp.cmd_id,
 		le16_to_cpu(pkt->u.err_resp.bad_cmd_seq_num),
 		le32_to_cpu(pkt->u.err_resp.error_info));
+	return 0;
 }
 
-static void iwl_rx_csa(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
+static int iwl_rx_csa(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb,
+			       struct iwl_device_cmd *cmd)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_csa_notification *csa = &(pkt->u.csa_notif);
@@ -156,7 +159,7 @@ static void iwl_rx_csa(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 	struct iwl_rxon_cmd *rxon = (void *)&ctx->active;
 
 	if (!test_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->shrd->status))
-		return;
+		return 0;
 
 	if (!le32_to_cpu(csa->status) && csa->channel == priv->switch_channel) {
 		rxon->channel = csa->channel;
@@ -169,11 +172,13 @@ static void iwl_rx_csa(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 			le16_to_cpu(csa->channel));
 		iwl_chswitch_done(priv, false);
 	}
+	return 0;
 }
 
 
-static void iwl_rx_spectrum_measure_notif(struct iwl_priv *priv,
-					  struct iwl_rx_mem_buffer *rxb)
+static int iwl_rx_spectrum_measure_notif(struct iwl_priv *priv,
+					  struct iwl_rx_mem_buffer *rxb,
+					  struct iwl_device_cmd *cmd)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_spectrum_notification *report = &(pkt->u.spectrum_notif);
@@ -181,15 +186,17 @@ static void iwl_rx_spectrum_measure_notif(struct iwl_priv *priv,
 	if (!report->state) {
 		IWL_DEBUG_11H(priv,
 			"Spectrum Measure Notification: Start\n");
-		return;
+		return 0;
 	}
 
 	memcpy(&priv->measure_report, report, sizeof(*report));
 	priv->measurement_status |= MEASUREMENT_READY;
+	return 0;
 }
 
-static void iwl_rx_pm_sleep_notif(struct iwl_priv *priv,
-				  struct iwl_rx_mem_buffer *rxb)
+static int iwl_rx_pm_sleep_notif(struct iwl_priv *priv,
+				  struct iwl_rx_mem_buffer *rxb,
+				  struct iwl_device_cmd *cmd)
 {
 #ifdef CONFIG_IWLWIFI_DEBUG
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
@@ -197,10 +204,12 @@ static void iwl_rx_pm_sleep_notif(struct iwl_priv *priv,
 	IWL_DEBUG_RX(priv, "sleep mode: %d, src: %d\n",
 		     sleep->pm_sleep_mode, sleep->pm_wakeup_src);
 #endif
+	return 0;
 }
 
-static void iwl_rx_pm_debug_statistics_notif(struct iwl_priv *priv,
-					     struct iwl_rx_mem_buffer *rxb)
+static int iwl_rx_pm_debug_statistics_notif(struct iwl_priv *priv,
+					     struct iwl_rx_mem_buffer *rxb,
+					     struct iwl_device_cmd *cmd)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	u32 __maybe_unused len =
@@ -209,10 +218,12 @@ static void iwl_rx_pm_debug_statistics_notif(struct iwl_priv *priv,
 			"notification for %s:\n", len,
 			get_cmd_string(pkt->hdr.cmd));
 	iwl_print_hex_dump(priv, IWL_DL_RADIO, pkt->u.raw, len);
+	return 0;
 }
 
-static void iwl_rx_beacon_notif(struct iwl_priv *priv,
-				struct iwl_rx_mem_buffer *rxb)
+static int iwl_rx_beacon_notif(struct iwl_priv *priv,
+				struct iwl_rx_mem_buffer *rxb,
+				struct iwl_device_cmd *cmd)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwlagn_beacon_notif *beacon = (void *)pkt->u.raw;
@@ -233,6 +244,7 @@ static void iwl_rx_beacon_notif(struct iwl_priv *priv,
 
 	if (!test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
 		queue_work(priv->shrd->workqueue, &priv->beacon_update);
+	return 0;
 }
 
 /* the threshold ratio of actual_ack_cnt to expected_ack_cnt in percent */
@@ -475,8 +487,9 @@ iwl_accumulative_statistics(struct iwl_priv *priv,
 }
 #endif
 
-static void iwl_rx_statistics(struct iwl_priv *priv,
-			      struct iwl_rx_mem_buffer *rxb)
+static int iwl_rx_statistics(struct iwl_priv *priv,
+			      struct iwl_rx_mem_buffer *rxb,
+			      struct iwl_device_cmd *cmd)
 {
 	unsigned long stamp = jiffies;
 	const int reg_recalib_period = 60;
@@ -530,7 +543,7 @@ static void iwl_rx_statistics(struct iwl_priv *priv,
 		WARN_ONCE(1, "len %d doesn't match BT (%zu) or normal (%zu)\n",
 			  len, sizeof(struct iwl_bt_notif_statistics),
 			  sizeof(struct iwl_notif_statistics));
-		return;
+		return 0;
 	}
 
 	change = common->temperature != priv->statistics.common.temperature ||
@@ -573,10 +586,12 @@ static void iwl_rx_statistics(struct iwl_priv *priv,
 	}
 	if (priv->cfg->lib->temperature && change)
 		priv->cfg->lib->temperature(priv);
+	return 0;
 }
 
-static void iwl_rx_reply_statistics(struct iwl_priv *priv,
-				    struct iwl_rx_mem_buffer *rxb)
+static int iwl_rx_reply_statistics(struct iwl_priv *priv,
+				    struct iwl_rx_mem_buffer *rxb,
+				    struct iwl_device_cmd *cmd)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 
@@ -591,13 +606,15 @@ static void iwl_rx_reply_statistics(struct iwl_priv *priv,
 #endif
 		IWL_DEBUG_RX(priv, "Statistics have been cleared\n");
 	}
-	iwl_rx_statistics(priv, rxb);
+	iwl_rx_statistics(priv, rxb, cmd);
+	return 0;
 }
 
 /* Handle notification from uCode that card's power state is changing
  * due to software, hardware, or critical temperature RFKILL */
-static void iwl_rx_card_state_notif(struct iwl_priv *priv,
-				    struct iwl_rx_mem_buffer *rxb)
+static int iwl_rx_card_state_notif(struct iwl_priv *priv,
+				    struct iwl_rx_mem_buffer *rxb,
+				    struct iwl_device_cmd *cmd)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	u32 flags = le32_to_cpu(pkt->u.card_state_notif.flags);
@@ -645,10 +662,12 @@ static void iwl_rx_card_state_notif(struct iwl_priv *priv,
 			test_bit(STATUS_RF_KILL_HW, &priv->shrd->status));
 	else
 		wake_up(&priv->shrd->wait_command_queue);
+	return 0;
 }
 
-static void iwl_rx_missed_beacon_notif(struct iwl_priv *priv,
-				       struct iwl_rx_mem_buffer *rxb)
+static int iwl_rx_missed_beacon_notif(struct iwl_priv *priv,
+				       struct iwl_rx_mem_buffer *rxb,
+				       struct iwl_device_cmd *cmd)
 
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
@@ -666,18 +685,21 @@ static void iwl_rx_missed_beacon_notif(struct iwl_priv *priv,
 		if (!test_bit(STATUS_SCANNING, &priv->shrd->status))
 			iwl_init_sensitivity(priv);
 	}
+	return 0;
 }
 
 /* Cache phy data (Rx signal strength, etc) for HT frame (REPLY_RX_PHY_CMD).
  * This will be used later in iwl_rx_reply_rx() for REPLY_RX_MPDU_CMD. */
-static void iwl_rx_reply_rx_phy(struct iwl_priv *priv,
-				struct iwl_rx_mem_buffer *rxb)
+static int iwl_rx_reply_rx_phy(struct iwl_priv *priv,
+				struct iwl_rx_mem_buffer *rxb,
+				struct iwl_device_cmd *cmd)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 
 	priv->last_phy_res_valid = true;
 	memcpy(&priv->last_phy_res, pkt->u.raw,
 	       sizeof(struct iwl_rx_phy_res));
+	return 0;
 }
 
 /*
@@ -892,8 +914,9 @@ static int iwlagn_calc_rssi(struct iwl_priv *priv,
 
 /* Called for REPLY_RX (legacy ABG frames), or
  * REPLY_RX_MPDU_CMD (HT high-throughput N frames). */
-static void iwl_rx_reply_rx(struct iwl_priv *priv,
-			    struct iwl_rx_mem_buffer *rxb)
+static int iwl_rx_reply_rx(struct iwl_priv *priv,
+			    struct iwl_rx_mem_buffer *rxb,
+			    struct iwl_device_cmd *cmd)
 {
 	struct ieee80211_hdr *header;
 	struct ieee80211_rx_status rx_status;
@@ -926,7 +949,7 @@ static void iwl_rx_reply_rx(struct iwl_priv *priv,
 	} else {
 		if (!priv->last_phy_res_valid) {
 			IWL_ERR(priv, "MPDU frame without cached PHY data\n");
-			return;
+			return 0;
 		}
 		phy_res = &priv->last_phy_res;
 		amsdu = (struct iwl_rx_mpdu_res_start *)pkt->u.raw;
@@ -940,14 +963,14 @@ static void iwl_rx_reply_rx(struct iwl_priv *priv,
 	if ((unlikely(phy_res->cfg_phy_cnt > 20))) {
 		IWL_DEBUG_DROP(priv, "dsp size out of range [0,20]: %d/n",
 				phy_res->cfg_phy_cnt);
-		return;
+		return 0;
 	}
 
 	if (!(rx_pkt_status & RX_RES_STATUS_NO_CRC32_ERROR) ||
 	    !(rx_pkt_status & RX_RES_STATUS_NO_RXE_OVERFLOW)) {
 		IWL_DEBUG_RX(priv, "Bad CRC or FIFO: 0x%08X.\n",
 				le32_to_cpu(rx_pkt_status));
-		return;
+		return 0;
 	}
 
 	/* This will be used in several places later */
@@ -1008,6 +1031,7 @@ static void iwl_rx_reply_rx(struct iwl_priv *priv,
 
 	iwl_pass_packet_to_mac80211(priv, header, len, ampdu_status,
 				    rxb, &rx_status);
+	return 0;
 }
 
 /**
@@ -1018,7 +1042,8 @@ static void iwl_rx_reply_rx(struct iwl_priv *priv,
  */
 void iwl_setup_rx_handlers(struct iwl_priv *priv)
 {
-	void (**handlers)(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb);
+	int (**handlers)(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb,
+			       struct iwl_device_cmd *cmd);
 
 	handlers = priv->rx_handlers;
 
@@ -1028,6 +1053,7 @@ void iwl_setup_rx_handlers(struct iwl_priv *priv)
 	handlers[PM_SLEEP_NOTIFICATION]		= iwl_rx_pm_sleep_notif;
 	handlers[PM_DEBUG_STATISTIC_NOTIFIC]	= iwl_rx_pm_debug_statistics_notif;
 	handlers[BEACON_NOTIFICATION]		= iwl_rx_beacon_notif;
+	handlers[REPLY_ADD_STA]			= iwl_add_sta_callback;
 
 	/*
 	 * The same handler is used for both the REPLY to a discrete
@@ -1065,9 +1091,11 @@ void iwl_setup_rx_handlers(struct iwl_priv *priv)
 
 }
 
-void iwl_rx_dispatch(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
+int iwl_rx_dispatch(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb,
+		     struct iwl_device_cmd *cmd)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	int err = 0;
 
 	/*
 	 * Do the notification wait before RX handlers so
@@ -1102,11 +1130,12 @@ void iwl_rx_dispatch(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 	 *   rx_handlers table.  See iwl_setup_rx_handlers() */
 	if (priv->rx_handlers[pkt->hdr.cmd]) {
 		priv->rx_handlers_stats[pkt->hdr.cmd]++;
-		priv->rx_handlers[pkt->hdr.cmd] (priv, rxb);
+		err = priv->rx_handlers[pkt->hdr.cmd] (priv, rxb, cmd);
 	} else {
 		/* No handling needed */
 		IWL_DEBUG_RX(priv,
 			"No handler needed for %s, 0x%02x\n",
 			get_cmd_string(pkt->hdr.cmd), pkt->hdr.cmd);
 	}
+	return err;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 8386a86..2b6db24 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -189,8 +189,9 @@ int iwl_scan_cancel_timeout(struct iwl_priv *priv, unsigned long ms)
 }
 
 /* Service response to REPLY_SCAN_CMD (0x80) */
-static void iwl_rx_reply_scan(struct iwl_priv *priv,
-			      struct iwl_rx_mem_buffer *rxb)
+static int iwl_rx_reply_scan(struct iwl_priv *priv,
+			      struct iwl_rx_mem_buffer *rxb,
+			      struct iwl_device_cmd *cmd)
 {
 #ifdef CONFIG_IWLWIFI_DEBUG
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
@@ -199,11 +200,13 @@ static void iwl_rx_reply_scan(struct iwl_priv *priv,
 
 	IWL_DEBUG_SCAN(priv, "Scan request status = 0x%x\n", notif->status);
 #endif
+	return 0;
 }
 
 /* Service SCAN_START_NOTIFICATION (0x82) */
-static void iwl_rx_scan_start_notif(struct iwl_priv *priv,
-				    struct iwl_rx_mem_buffer *rxb)
+static int iwl_rx_scan_start_notif(struct iwl_priv *priv,
+				    struct iwl_rx_mem_buffer *rxb,
+				    struct iwl_device_cmd *cmd)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_scanstart_notification *notif =
@@ -223,11 +226,14 @@ static void iwl_rx_scan_start_notif(struct iwl_priv *priv,
 		ieee80211_ready_on_channel(priv->hw);
 		priv->hw_roc_start_notified = true;
 	}
+
+	return 0;
 }
 
 /* Service SCAN_RESULTS_NOTIFICATION (0x83) */
-static void iwl_rx_scan_results_notif(struct iwl_priv *priv,
-				      struct iwl_rx_mem_buffer *rxb)
+static int iwl_rx_scan_results_notif(struct iwl_priv *priv,
+				      struct iwl_rx_mem_buffer *rxb,
+				      struct iwl_device_cmd *cmd)
 {
 #ifdef CONFIG_IWLWIFI_DEBUG
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
@@ -245,11 +251,13 @@ static void iwl_rx_scan_results_notif(struct iwl_priv *priv,
 		       le32_to_cpu(notif->statistics[0]),
 		       le32_to_cpu(notif->tsf_low) - priv->scan_start_tsf);
 #endif
+	return 0;
 }
 
 /* Service SCAN_COMPLETE_NOTIFICATION (0x84) */
-static void iwl_rx_scan_complete_notif(struct iwl_priv *priv,
-				       struct iwl_rx_mem_buffer *rxb)
+static int iwl_rx_scan_complete_notif(struct iwl_priv *priv,
+				       struct iwl_rx_mem_buffer *rxb,
+				       struct iwl_device_cmd *cmd)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_scancomplete_notification *scan_notif = (void *)pkt->u.raw;
@@ -289,6 +297,7 @@ static void iwl_rx_scan_complete_notif(struct iwl_priv *priv,
 		queue_work(priv->shrd->workqueue,
 			   &priv->bt_traffic_change_work);
 	}
+	return 0;
 }
 
 void iwl_setup_rx_scan_handlers(struct iwl_priv *priv)
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 40186a6..7abafe1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -423,8 +423,11 @@ enum iwl_rxon_context_id {
 int iwl_probe(struct iwl_bus *bus, const struct iwl_trans_ops *trans_ops,
 		struct iwl_cfg *cfg);
 void __devexit iwl_remove(struct iwl_priv * priv);
+struct iwl_device_cmd;
+int __must_check iwl_rx_dispatch(struct iwl_priv *priv,
+				 struct iwl_rx_mem_buffer *rxb,
+				 struct iwl_device_cmd *cmd);
 
-void iwl_rx_dispatch(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb);
 int iwlagn_hw_valid_rtc_data_addr(u32 addr);
 void iwl_start_tx_ba_trans_ready(struct iwl_priv *priv,
 				 enum iwl_rxon_context_id ctx,
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index f35cfa2..7028f90 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -59,8 +59,7 @@ static void iwl_sta_ucode_activate(struct iwl_priv *priv, u8 sta_id)
 
 static int iwl_process_add_sta_resp(struct iwl_priv *priv,
 				    struct iwl_addsta_cmd *addsta,
-				    struct iwl_rx_packet *pkt,
-				    bool sync)
+				    struct iwl_rx_packet *pkt)
 {
 	u8 sta_id = addsta->sta.sta_id;
 	unsigned long flags;
@@ -123,15 +122,14 @@ static int iwl_process_add_sta_resp(struct iwl_priv *priv,
 	return ret;
 }
 
-static void iwl_add_sta_callback(struct iwl_shared *shrd,
-				 struct iwl_device_cmd *cmd,
-				 struct iwl_rx_packet *pkt)
+int iwl_add_sta_callback(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb,
+			       struct iwl_device_cmd *cmd)
 {
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_addsta_cmd *addsta =
 		(struct iwl_addsta_cmd *)cmd->cmd.payload;
 
-	iwl_process_add_sta_resp(shrd->priv, addsta, pkt, false);
-
+	return iwl_process_add_sta_resp(priv, addsta, pkt);
 }
 
 static u16 iwlagn_build_addsta_hcmd(const struct iwl_addsta_cmd *cmd, u8 *data)
@@ -147,7 +145,6 @@ static u16 iwlagn_build_addsta_hcmd(const struct iwl_addsta_cmd *cmd, u8 *data)
 int iwl_send_add_sta(struct iwl_priv *priv,
 		     struct iwl_addsta_cmd *sta, u8 flags)
 {
-	struct iwl_rx_packet *pkt = NULL;
 	int ret = 0;
 	u8 data[sizeof(*sta)];
 	struct iwl_host_cmd cmd = {
@@ -160,9 +157,7 @@ int iwl_send_add_sta(struct iwl_priv *priv,
 	IWL_DEBUG_INFO(priv, "Adding sta %u (%pM) %ssynchronously\n",
 		       sta_id, sta->sta.addr, flags & CMD_ASYNC ?  "a" : "");
 
-	if (flags & CMD_ASYNC)
-		cmd.callback = iwl_add_sta_callback;
-	else {
+	if (!(flags & CMD_ASYNC)) {
 		cmd.flags |= CMD_WANT_SKB;
 		might_sleep();
 	}
@@ -172,14 +167,16 @@ int iwl_send_add_sta(struct iwl_priv *priv,
 
 	if (ret || (flags & CMD_ASYNC))
 		return ret;
+	/*else the command was successfully sent in SYNC mode, need to free
+	 * the reply page */
 
-	if (ret == 0) {
-		pkt = (struct iwl_rx_packet *)cmd.reply_page;
-		ret = iwl_process_add_sta_resp(priv, sta, pkt, true);
-	}
 	iwl_free_pages(priv->shrd, cmd.reply_page);
 
-	return ret;
+	if (cmd.handler_status)
+		IWL_ERR(priv, "%s - error in the CMD response %d", __func__,
+			cmd.handler_status);
+
+	return cmd.handler_status;
 }
 
 static void iwl_set_ht_add_station(struct iwl_priv *priv, u8 index,
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.h b/drivers/net/wireless/iwlwifi/iwl-sta.h
index 02491b9..1bca0da 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.h
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.h
@@ -61,6 +61,9 @@ u8 iwl_prep_station(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 int iwl_send_lq_cmd(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 		    struct iwl_link_quality_cmd *lq, u8 flags, bool init);
 void iwl_reprogram_ap_sta(struct iwl_priv *priv, struct iwl_rxon_context *ctx);
+int iwl_add_sta_callback(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb,
+			       struct iwl_device_cmd *cmd);
+
 
 /**
  * iwl_clear_driver_stations - clear knowledge of all stations from driver
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
index 49cd5a7..0e7d915 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
@@ -118,16 +118,6 @@ struct iwl_dma_ptr {
 struct iwl_cmd_meta {
 	/* only for SYNC commands, iff the reply skb is wanted */
 	struct iwl_host_cmd *source;
-	/*
-	 * only for ASYNC commands
-	 * (which is somewhat stupid -- look at iwl-sta.c for instance
-	 * which duplicates a bunch of code because the callback isn't
-	 * invoked for SYNC commands, if it were and its result passed
-	 * through it would be simpler...)
-	 */
-	void (*callback)(struct iwl_shared *shrd,
-			 struct iwl_device_cmd *cmd,
-			 struct iwl_rx_packet *pkt);
 
 	u32 flags;
 
@@ -288,7 +278,7 @@ int iwl_trans_pcie_send_cmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd);
 int __must_check iwl_trans_pcie_send_cmd_pdu(struct iwl_trans *trans, u8 id,
 			u32 flags, u16 len, const void *data);
 void iwl_tx_cmd_complete(struct iwl_trans *trans,
-			 struct iwl_rx_mem_buffer *rxb);
+			 struct iwl_rx_mem_buffer *rxb, int handler_status);
 void iwl_trans_txq_update_byte_cnt_tbl(struct iwl_trans *trans,
 					   struct iwl_tx_queue *txq,
 					   u16 byte_cnt);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index 6f3f07d..3ef9eac 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -372,12 +372,15 @@ static void iwl_rx_handle(struct iwl_trans *trans)
 	struct iwl_trans_pcie *trans_pcie =
 		IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_rx_queue *rxq = &trans_pcie->rxq;
+	struct iwl_tx_queue *txq = &trans_pcie->txq[trans->shrd->cmd_queue];
+	struct iwl_device_cmd *cmd;
 	u32 r, i;
 	int reclaim;
 	unsigned long flags;
 	u8 fill_rx = 0;
 	u32 count = 8;
 	int total_empty;
+	int index, cmd_index;
 
 	/* uCode's read index (stored in shared DRAM) indicates the last Rx
 	 * buffer that the driver may process (last buffer filled by ucode). */
@@ -397,7 +400,7 @@ static void iwl_rx_handle(struct iwl_trans *trans)
 		fill_rx = 1;
 
 	while (i != r) {
-		int len;
+		int len, err;
 		u16 txq_id, sequence;
 
 		rxb = rxq->queue[i];
@@ -439,7 +442,13 @@ static void iwl_rx_handle(struct iwl_trans *trans)
 			(pkt->hdr.cmd != REPLY_TX);
 
 		sequence = le16_to_cpu(pkt->hdr.sequence);
-		txq_id = SEQ_TO_QUEUE(le16_to_cpu(pkt->hdr.sequence));
+		index = SEQ_TO_INDEX(sequence);
+		cmd_index = get_cmd_index(&txq->q, index);
+
+		if (reclaim)
+			cmd = txq->cmd[cmd_index];
+		else
+			cmd = NULL;
 
 		/* warn if this is cmd response / notification and the uCode
 		 * didn't set the SEQ_RX_FRAME for a frame that is
@@ -449,7 +458,7 @@ static void iwl_rx_handle(struct iwl_trans *trans)
 		     "reclaim is false, SEQ_RX_FRAME unset: %s\n",
 		     get_cmd_string(pkt->hdr.cmd));
 
-		iwl_rx_dispatch(priv(trans), rxb);
+		err = iwl_rx_dispatch(priv(trans), rxb, cmd);
 
 		/*
 		 * XXX: After here, we should always check rxb->page
@@ -464,7 +473,7 @@ static void iwl_rx_handle(struct iwl_trans *trans)
 			 * iwl_trans_send_cmd()
 			 * as we reclaim the driver command queue */
 			if (rxb->page)
-				iwl_tx_cmd_complete(trans, rxb);
+				iwl_tx_cmd_complete(trans, rxb, err);
 			else
 				IWL_WARN(trans, "Claim null rxb?\n");
 		}
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index 031a291..48ef6c2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -762,8 +762,6 @@ static int iwl_enqueue_hcmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 	memset(out_meta, 0, sizeof(*out_meta));	/* re-initialize to NULL */
 	if (cmd->flags & CMD_WANT_SKB)
 		out_meta->source = cmd;
-	if (cmd->flags & CMD_ASYNC)
-		out_meta->callback = cmd->callback;
 
 	/* set up the header */
 
@@ -894,12 +892,15 @@ static void iwl_hcmd_queue_reclaim(struct iwl_trans *trans, int txq_id,
 /**
  * iwl_tx_cmd_complete - Pull unused buffers off the queue and reclaim them
  * @rxb: Rx buffer to reclaim
+ * @handler_status: return value of the handler of the command
+ *	(put in setup_rx_handlers)
  *
  * If an Rx buffer has an async callback associated with it the callback
  * will be executed.  The attached skb (if present) will only be freed
  * if the callback returns 1
  */
-void iwl_tx_cmd_complete(struct iwl_trans *trans, struct iwl_rx_mem_buffer *rxb)
+void iwl_tx_cmd_complete(struct iwl_trans *trans, struct iwl_rx_mem_buffer *rxb,
+			 int handler_status)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
@@ -936,9 +937,9 @@ void iwl_tx_cmd_complete(struct iwl_trans *trans, struct iwl_rx_mem_buffer *rxb)
 	/* Input error checking is done when commands are added to queue. */
 	if (meta->flags & CMD_WANT_SKB) {
 		meta->source->reply_page = (unsigned long)rxb_addr(rxb);
+		meta->source->handler_status = handler_status;
 		rxb->page = NULL;
-	} else if (meta->callback)
-		meta->callback(trans->shrd, cmd, pkt);
+	}
 
 	spin_lock_irqsave(&trans->hcmd_lock, flags);
 
@@ -958,30 +959,6 @@ void iwl_tx_cmd_complete(struct iwl_trans *trans, struct iwl_rx_mem_buffer *rxb)
 
 #define HOST_COMPLETE_TIMEOUT (2 * HZ)
 
-static void iwl_generic_cmd_callback(struct iwl_shared *shrd,
-				     struct iwl_device_cmd *cmd,
-				     struct iwl_rx_packet *pkt)
-{
-	if (pkt->hdr.flags & IWL_CMD_FAILED_MSK) {
-		IWL_ERR(shrd->trans, "Bad return from %s (0x%08X)\n",
-			get_cmd_string(cmd->hdr.cmd), pkt->hdr.flags);
-		return;
-	}
-
-#ifdef CONFIG_IWLWIFI_DEBUG
-	switch (cmd->hdr.cmd) {
-	case REPLY_TX_LINK_QUALITY_CMD:
-	case SENSITIVITY_CMD:
-		IWL_DEBUG_HC_DUMP(shrd->trans, "back from %s (0x%08X)\n",
-				get_cmd_string(cmd->hdr.cmd), pkt->hdr.flags);
-		break;
-	default:
-		IWL_DEBUG_HC(shrd->trans, "back from %s (0x%08X)\n",
-				get_cmd_string(cmd->hdr.cmd), pkt->hdr.flags);
-	}
-#endif
-}
-
 static int iwl_send_cmd_async(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 {
 	int ret;
@@ -990,9 +967,6 @@ static int iwl_send_cmd_async(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 	if (WARN_ON(cmd->flags & CMD_WANT_SKB))
 		return -EINVAL;
 
-	/* Assign a generic callback if one is not provided */
-	if (!cmd->callback)
-		cmd->callback = iwl_generic_cmd_callback;
 
 	if (test_bit(STATUS_EXIT_PENDING, &trans->shrd->status))
 		return -EBUSY;
@@ -1014,10 +988,6 @@ static int iwl_send_cmd_sync(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 
 	lockdep_assert_held(&trans->shrd->mutex);
 
-	 /* A synchronous command can not have a callback set. */
-	if (WARN_ON(cmd->callback))
-		return -EINVAL;
-
 	IWL_DEBUG_INFO(trans, "Attempting to send sync command %s\n",
 			get_cmd_string(cmd->id));
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 5b6e684..ddb7741 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -120,6 +120,8 @@ enum iwl_hcmd_dataflag {
  * struct iwl_host_cmd - Host command to the uCode
  * @data: array of chunks that composes the data of the host command
  * @reply_page: pointer to the page that holds the response to the host command
+ * @handler_status: return value of the handler of the command
+ *	(put in setup_rx_handlers) - valid for SYNC mode only
  * @callback:
  * @flags: can be CMD_* note CMD_WANT_SKB is incompatible withe CMD_ASYNC
  * @len: array of the lenths of the chunks in data
@@ -129,9 +131,8 @@ enum iwl_hcmd_dataflag {
 struct iwl_host_cmd {
 	const void *data[IWL_MAX_CMD_TFDS];
 	unsigned long reply_page;
-	void (*callback)(struct iwl_shared *shrd,
-			 struct iwl_device_cmd *cmd,
-			 struct iwl_rx_packet *pkt);
+	int handler_status;
+
 	u32 flags;
 	u16 len[IWL_MAX_CMD_TFDS];
 	u8 dataflags[IWL_MAX_CMD_TFDS];
-- 
1.7.0.4

