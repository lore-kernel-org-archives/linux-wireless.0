Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6116 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759807Ab1CDQwF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2011 11:52:05 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 1/3] iwlwifi: move rx handlers code to iwl-rx.c
Date: Fri,  4 Mar 2011 17:51:49 +0100
Message-Id: <1299257511-5241-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Put generic rx_handlers (except iwlagn_rx_reply_compressed_ba) to
iwl-rx.c . Make functions static and change prefix from iwlagn_ to
iwl_ . Beautify iwl_setup_rx_handlers and do some other minor coding
style changes.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |  235 -------------
 drivers/net/wireless/iwlwifi/iwl-agn.c     |  176 ----------
 drivers/net/wireless/iwlwifi/iwl-agn.h     |   13 +-
 drivers/net/wireless/iwlwifi/iwl-core.c    |   63 ----
 drivers/net/wireless/iwlwifi/iwl-core.h    |   18 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c      |  523 ++++++++++++++++++++++++++--
 6 files changed, 500 insertions(+), 528 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index fd142be..b889129 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -994,241 +994,6 @@ int iwlagn_hwrate_to_mac80211_idx(u32 rate_n_flags, enum ieee80211_band band)
 	return -1;
 }
 
-/* Calc max signal level (dBm) among 3 possible receivers */
-static inline int iwlagn_calc_rssi(struct iwl_priv *priv,
-				struct iwl_rx_phy_res *rx_resp)
-{
-	return priv->cfg->ops->utils->calc_rssi(priv, rx_resp);
-}
-
-static u32 iwlagn_translate_rx_status(struct iwl_priv *priv, u32 decrypt_in)
-{
-	u32 decrypt_out = 0;
-
-	if ((decrypt_in & RX_RES_STATUS_STATION_FOUND) ==
-					RX_RES_STATUS_STATION_FOUND)
-		decrypt_out |= (RX_RES_STATUS_STATION_FOUND |
-				RX_RES_STATUS_NO_STATION_INFO_MISMATCH);
-
-	decrypt_out |= (decrypt_in & RX_RES_STATUS_SEC_TYPE_MSK);
-
-	/* packet was not encrypted */
-	if ((decrypt_in & RX_RES_STATUS_SEC_TYPE_MSK) ==
-					RX_RES_STATUS_SEC_TYPE_NONE)
-		return decrypt_out;
-
-	/* packet was encrypted with unknown alg */
-	if ((decrypt_in & RX_RES_STATUS_SEC_TYPE_MSK) ==
-					RX_RES_STATUS_SEC_TYPE_ERR)
-		return decrypt_out;
-
-	/* decryption was not done in HW */
-	if ((decrypt_in & RX_MPDU_RES_STATUS_DEC_DONE_MSK) !=
-					RX_MPDU_RES_STATUS_DEC_DONE_MSK)
-		return decrypt_out;
-
-	switch (decrypt_in & RX_RES_STATUS_SEC_TYPE_MSK) {
-
-	case RX_RES_STATUS_SEC_TYPE_CCMP:
-		/* alg is CCM: check MIC only */
-		if (!(decrypt_in & RX_MPDU_RES_STATUS_MIC_OK))
-			/* Bad MIC */
-			decrypt_out |= RX_RES_STATUS_BAD_ICV_MIC;
-		else
-			decrypt_out |= RX_RES_STATUS_DECRYPT_OK;
-
-		break;
-
-	case RX_RES_STATUS_SEC_TYPE_TKIP:
-		if (!(decrypt_in & RX_MPDU_RES_STATUS_TTAK_OK)) {
-			/* Bad TTAK */
-			decrypt_out |= RX_RES_STATUS_BAD_KEY_TTAK;
-			break;
-		}
-		/* fall through if TTAK OK */
-	default:
-		if (!(decrypt_in & RX_MPDU_RES_STATUS_ICV_OK))
-			decrypt_out |= RX_RES_STATUS_BAD_ICV_MIC;
-		else
-			decrypt_out |= RX_RES_STATUS_DECRYPT_OK;
-		break;
-	}
-
-	IWL_DEBUG_RX(priv, "decrypt_in:0x%x  decrypt_out = 0x%x\n",
-					decrypt_in, decrypt_out);
-
-	return decrypt_out;
-}
-
-static void iwlagn_pass_packet_to_mac80211(struct iwl_priv *priv,
-					struct ieee80211_hdr *hdr,
-					u16 len,
-					u32 ampdu_status,
-					struct iwl_rx_mem_buffer *rxb,
-					struct ieee80211_rx_status *stats)
-{
-	struct sk_buff *skb;
-	__le16 fc = hdr->frame_control;
-
-	/* We only process data packets if the interface is open */
-	if (unlikely(!priv->is_open)) {
-		IWL_DEBUG_DROP_LIMIT(priv,
-		    "Dropping packet while interface is not open.\n");
-		return;
-	}
-
-	/* In case of HW accelerated crypto and bad decryption, drop */
-	if (!priv->cfg->mod_params->sw_crypto &&
-	    iwl_set_decrypted_flag(priv, hdr, ampdu_status, stats))
-		return;
-
-	skb = dev_alloc_skb(128);
-	if (!skb) {
-		IWL_ERR(priv, "dev_alloc_skb failed\n");
-		return;
-	}
-
-	skb_add_rx_frag(skb, 0, rxb->page, (void *)hdr - rxb_addr(rxb), len);
-
-	iwl_update_stats(priv, false, fc, len);
-	memcpy(IEEE80211_SKB_RXCB(skb), stats, sizeof(*stats));
-
-	ieee80211_rx(priv->hw, skb);
-	priv->alloc_rxb_page--;
-	rxb->page = NULL;
-}
-
-/* Called for REPLY_RX (legacy ABG frames), or
- * REPLY_RX_MPDU_CMD (HT high-throughput N frames). */
-void iwlagn_rx_reply_rx(struct iwl_priv *priv,
-				struct iwl_rx_mem_buffer *rxb)
-{
-	struct ieee80211_hdr *header;
-	struct ieee80211_rx_status rx_status;
-	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	struct iwl_rx_phy_res *phy_res;
-	__le32 rx_pkt_status;
-	struct iwl_rx_mpdu_res_start *amsdu;
-	u32 len;
-	u32 ampdu_status;
-	u32 rate_n_flags;
-
-	/**
-	 * REPLY_RX and REPLY_RX_MPDU_CMD are handled differently.
-	 *	REPLY_RX: physical layer info is in this buffer
-	 *	REPLY_RX_MPDU_CMD: physical layer info was sent in separate
-	 *		command and cached in priv->last_phy_res
-	 *
-	 * Here we set up local variables depending on which command is
-	 * received.
-	 */
-	if (pkt->hdr.cmd == REPLY_RX) {
-		phy_res = (struct iwl_rx_phy_res *)pkt->u.raw;
-		header = (struct ieee80211_hdr *)(pkt->u.raw + sizeof(*phy_res)
-				+ phy_res->cfg_phy_cnt);
-
-		len = le16_to_cpu(phy_res->byte_count);
-		rx_pkt_status = *(__le32 *)(pkt->u.raw + sizeof(*phy_res) +
-				phy_res->cfg_phy_cnt + len);
-		ampdu_status = le32_to_cpu(rx_pkt_status);
-	} else {
-		if (!priv->_agn.last_phy_res_valid) {
-			IWL_ERR(priv, "MPDU frame without cached PHY data\n");
-			return;
-		}
-		phy_res = &priv->_agn.last_phy_res;
-		amsdu = (struct iwl_rx_mpdu_res_start *)pkt->u.raw;
-		header = (struct ieee80211_hdr *)(pkt->u.raw + sizeof(*amsdu));
-		len = le16_to_cpu(amsdu->byte_count);
-		rx_pkt_status = *(__le32 *)(pkt->u.raw + sizeof(*amsdu) + len);
-		ampdu_status = iwlagn_translate_rx_status(priv,
-				le32_to_cpu(rx_pkt_status));
-	}
-
-	if ((unlikely(phy_res->cfg_phy_cnt > 20))) {
-		IWL_DEBUG_DROP(priv, "dsp size out of range [0,20]: %d/n",
-				phy_res->cfg_phy_cnt);
-		return;
-	}
-
-	if (!(rx_pkt_status & RX_RES_STATUS_NO_CRC32_ERROR) ||
-	    !(rx_pkt_status & RX_RES_STATUS_NO_RXE_OVERFLOW)) {
-		IWL_DEBUG_RX(priv, "Bad CRC or FIFO: 0x%08X.\n",
-				le32_to_cpu(rx_pkt_status));
-		return;
-	}
-
-	/* This will be used in several places later */
-	rate_n_flags = le32_to_cpu(phy_res->rate_n_flags);
-
-	/* rx_status carries information about the packet to mac80211 */
-	rx_status.mactime = le64_to_cpu(phy_res->timestamp);
-	rx_status.band = (phy_res->phy_flags & RX_RES_PHY_FLAGS_BAND_24_MSK) ?
-				IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ;
-	rx_status.freq =
-		ieee80211_channel_to_frequency(le16_to_cpu(phy_res->channel),
-					       rx_status.band);
-	rx_status.rate_idx =
-		iwlagn_hwrate_to_mac80211_idx(rate_n_flags, rx_status.band);
-	rx_status.flag = 0;
-
-	/* TSF isn't reliable. In order to allow smooth user experience,
-	 * this W/A doesn't propagate it to the mac80211 */
-	/*rx_status.flag |= RX_FLAG_MACTIME_MPDU;*/
-
-	priv->ucode_beacon_time = le32_to_cpu(phy_res->beacon_time_stamp);
-
-	/* Find max signal strength (dBm) among 3 antenna/receiver chains */
-	rx_status.signal = iwlagn_calc_rssi(priv, phy_res);
-
-	iwl_dbg_log_rx_data_frame(priv, len, header);
-	IWL_DEBUG_STATS_LIMIT(priv, "Rssi %d, TSF %llu\n",
-		rx_status.signal, (unsigned long long)rx_status.mactime);
-
-	/*
-	 * "antenna number"
-	 *
-	 * It seems that the antenna field in the phy flags value
-	 * is actually a bit field. This is undefined by radiotap,
-	 * it wants an actual antenna number but I always get "7"
-	 * for most legacy frames I receive indicating that the
-	 * same frame was received on all three RX chains.
-	 *
-	 * I think this field should be removed in favor of a
-	 * new 802.11n radiotap field "RX chains" that is defined
-	 * as a bitmask.
-	 */
-	rx_status.antenna =
-		(le16_to_cpu(phy_res->phy_flags) & RX_RES_PHY_FLAGS_ANTENNA_MSK)
-		>> RX_RES_PHY_FLAGS_ANTENNA_POS;
-
-	/* set the preamble flag if appropriate */
-	if (phy_res->phy_flags & RX_RES_PHY_FLAGS_SHORT_PREAMBLE_MSK)
-		rx_status.flag |= RX_FLAG_SHORTPRE;
-
-	/* Set up the HT phy flags */
-	if (rate_n_flags & RATE_MCS_HT_MSK)
-		rx_status.flag |= RX_FLAG_HT;
-	if (rate_n_flags & RATE_MCS_HT40_MSK)
-		rx_status.flag |= RX_FLAG_40MHZ;
-	if (rate_n_flags & RATE_MCS_SGI_MSK)
-		rx_status.flag |= RX_FLAG_SHORT_GI;
-
-	iwlagn_pass_packet_to_mac80211(priv, header, len, ampdu_status,
-				    rxb, &rx_status);
-}
-
-/* Cache phy data (Rx signal strength, etc) for HT frame (REPLY_RX_PHY_CMD).
- * This will be used later in iwl_rx_reply_rx() for REPLY_RX_MPDU_CMD. */
-void iwlagn_rx_reply_rx_phy(struct iwl_priv *priv,
-			    struct iwl_rx_mem_buffer *rxb)
-{
-	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	priv->_agn.last_phy_res_valid = true;
-	memcpy(&priv->_agn.last_phy_res, pkt->u.raw,
-	       sizeof(struct iwl_rx_phy_res));
-}
-
 static int iwl_get_single_channel_for_scan(struct iwl_priv *priv,
 					   struct ieee80211_vif *vif,
 					   enum ieee80211_band band,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index c96d4ad..6b6f2d8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -424,60 +424,6 @@ int iwl_hw_tx_queue_init(struct iwl_priv *priv,
 	return 0;
 }
 
-/******************************************************************************
- *
- * Generic RX handler implementations
- *
- ******************************************************************************/
-static void iwl_rx_reply_alive(struct iwl_priv *priv,
-				struct iwl_rx_mem_buffer *rxb)
-{
-	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	struct iwl_alive_resp *palive;
-	struct delayed_work *pwork;
-
-	palive = &pkt->u.alive_frame;
-
-	IWL_DEBUG_INFO(priv, "Alive ucode status 0x%08X revision "
-		       "0x%01X 0x%01X\n",
-		       palive->is_valid, palive->ver_type,
-		       palive->ver_subtype);
-
-	if (palive->ver_subtype == INITIALIZE_SUBTYPE) {
-		IWL_DEBUG_INFO(priv, "Initialization Alive received.\n");
-		memcpy(&priv->card_alive_init,
-		       &pkt->u.alive_frame,
-		       sizeof(struct iwl_init_alive_resp));
-		pwork = &priv->init_alive_start;
-	} else {
-		IWL_DEBUG_INFO(priv, "Runtime Alive received.\n");
-		memcpy(&priv->card_alive, &pkt->u.alive_frame,
-		       sizeof(struct iwl_alive_resp));
-		pwork = &priv->alive_start;
-	}
-
-	/* We delay the ALIVE response by 5ms to
-	 * give the HW RF Kill time to activate... */
-	if (palive->is_valid == UCODE_VALID_OK)
-		queue_delayed_work(priv->workqueue, pwork,
-				   msecs_to_jiffies(5));
-	else {
-		IWL_WARN(priv, "%s uCode did not respond OK.\n",
-			(palive->ver_subtype == INITIALIZE_SUBTYPE) ?
-			"init" : "runtime");
-		/*
-		 * If fail to load init uCode,
-		 * let's try to load the init uCode again.
-		 * We should not get into this situation, but if it
-		 * does happen, we should not move on and loading "runtime"
-		 * without proper calibrate the device.
-		 */
-		if (palive->ver_subtype == INITIALIZE_SUBTYPE)
-			priv->ucode_type = UCODE_NONE;
-		queue_work(priv->workqueue, &priv->restart);
-	}
-}
-
 static void iwl_bg_beacon_update(struct work_struct *work)
 {
 	struct iwl_priv *priv =
@@ -712,83 +658,6 @@ static void iwl_bg_ucode_trace(unsigned long data)
 	}
 }
 
-static void iwlagn_rx_beacon_notif(struct iwl_priv *priv,
-				   struct iwl_rx_mem_buffer *rxb)
-{
-	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	struct iwlagn_beacon_notif *beacon = (void *)pkt->u.raw;
-#ifdef CONFIG_IWLWIFI_DEBUG
-	u16 status = le16_to_cpu(beacon->beacon_notify_hdr.status.status);
-	u8 rate = iwl_hw_get_rate(beacon->beacon_notify_hdr.rate_n_flags);
-
-	IWL_DEBUG_RX(priv, "beacon status %#x, retries:%d ibssmgr:%d "
-		"tsf:0x%.8x%.8x rate:%d\n",
-		status & TX_STATUS_MSK,
-		beacon->beacon_notify_hdr.failure_frame,
-		le32_to_cpu(beacon->ibss_mgr_status),
-		le32_to_cpu(beacon->high_tsf),
-		le32_to_cpu(beacon->low_tsf), rate);
-#endif
-
-	priv->ibss_manager = le32_to_cpu(beacon->ibss_mgr_status);
-
-	if (!test_bit(STATUS_EXIT_PENDING, &priv->status))
-		queue_work(priv->workqueue, &priv->beacon_update);
-}
-
-/* Handle notification from uCode that card's power state is changing
- * due to software, hardware, or critical temperature RFKILL */
-static void iwl_rx_card_state_notif(struct iwl_priv *priv,
-				    struct iwl_rx_mem_buffer *rxb)
-{
-	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	u32 flags = le32_to_cpu(pkt->u.card_state_notif.flags);
-	unsigned long status = priv->status;
-
-	IWL_DEBUG_RF_KILL(priv, "Card state received: HW:%s SW:%s CT:%s\n",
-			  (flags & HW_CARD_DISABLED) ? "Kill" : "On",
-			  (flags & SW_CARD_DISABLED) ? "Kill" : "On",
-			  (flags & CT_CARD_DISABLED) ?
-			  "Reached" : "Not reached");
-
-	if (flags & (SW_CARD_DISABLED | HW_CARD_DISABLED |
-		     CT_CARD_DISABLED)) {
-
-		iwl_write32(priv, CSR_UCODE_DRV_GP1_SET,
-			    CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED);
-
-		iwl_write_direct32(priv, HBUS_TARG_MBX_C,
-					HBUS_TARG_MBX_C_REG_BIT_CMD_BLOCKED);
-
-		if (!(flags & RXON_CARD_DISABLED)) {
-			iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR,
-				    CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED);
-			iwl_write_direct32(priv, HBUS_TARG_MBX_C,
-					HBUS_TARG_MBX_C_REG_BIT_CMD_BLOCKED);
-		}
-		if (flags & CT_CARD_DISABLED)
-			iwl_tt_enter_ct_kill(priv);
-	}
-	if (!(flags & CT_CARD_DISABLED))
-		iwl_tt_exit_ct_kill(priv);
-
-	if (flags & HW_CARD_DISABLED)
-		set_bit(STATUS_RF_KILL_HW, &priv->status);
-	else
-		clear_bit(STATUS_RF_KILL_HW, &priv->status);
-
-
-	if (!(flags & RXON_CARD_DISABLED))
-		iwl_scan_cancel(priv);
-
-	if ((test_bit(STATUS_RF_KILL_HW, &status) !=
-	     test_bit(STATUS_RF_KILL_HW, &priv->status)))
-		wiphy_rfkill_set_hw_state(priv->hw->wiphy,
-			test_bit(STATUS_RF_KILL_HW, &priv->status));
-	else
-		wake_up_interruptible(&priv->wait_command_queue);
-}
-
 static void iwl_bg_tx_flush(struct work_struct *work)
 {
 	struct iwl_priv *priv =
@@ -808,51 +677,6 @@ static void iwl_bg_tx_flush(struct work_struct *work)
 }
 
 /**
- * iwl_setup_rx_handlers - Initialize Rx handler callbacks
- *
- * Setup the RX handlers for each of the reply types sent from the uCode
- * to the host.
- *
- * This function chains into the hardware specific files for them to setup
- * any hardware specific handlers as well.
- */
-static void iwl_setup_rx_handlers(struct iwl_priv *priv)
-{
-	priv->rx_handlers[REPLY_ALIVE] = iwl_rx_reply_alive;
-	priv->rx_handlers[REPLY_ERROR] = iwl_rx_reply_error;
-	priv->rx_handlers[CHANNEL_SWITCH_NOTIFICATION] = iwl_rx_csa;
-	priv->rx_handlers[SPECTRUM_MEASURE_NOTIFICATION] =
-			iwl_rx_spectrum_measure_notif;
-	priv->rx_handlers[PM_SLEEP_NOTIFICATION] = iwl_rx_pm_sleep_notif;
-	priv->rx_handlers[PM_DEBUG_STATISTIC_NOTIFIC] =
-	    iwl_rx_pm_debug_statistics_notif;
-	priv->rx_handlers[BEACON_NOTIFICATION] = iwlagn_rx_beacon_notif;
-
-	/*
-	 * The same handler is used for both the REPLY to a discrete
-	 * statistics request from the host as well as for the periodic
-	 * statistics notifications (after received beacons) from the uCode.
-	 */
-	priv->rx_handlers[REPLY_STATISTICS_CMD] = iwl_reply_statistics;
-	priv->rx_handlers[STATISTICS_NOTIFICATION] = iwl_rx_statistics;
-
-	iwl_setup_rx_scan_handlers(priv);
-
-	/* status change handler */
-	priv->rx_handlers[CARD_STATE_NOTIFICATION] = iwl_rx_card_state_notif;
-
-	priv->rx_handlers[MISSED_BEACONS_NOTIFICATION] =
-	    iwl_rx_missed_beacon_notif;
-	/* Rx handlers */
-	priv->rx_handlers[REPLY_RX_PHY_CMD] = iwlagn_rx_reply_rx_phy;
-	priv->rx_handlers[REPLY_RX_MPDU_CMD] = iwlagn_rx_reply_rx;
-	/* block ack */
-	priv->rx_handlers[REPLY_COMPRESSED_BA] = iwlagn_rx_reply_compressed_ba;
-	/* Set up hardware specific Rx handlers */
-	priv->cfg->ops->lib->rx_handler_setup(priv);
-}
-
-/**
  * iwl_rx_handle - Main entry function for receiving responses from uCode
  *
  * Uses the priv->rx_handlers callback function array to invoke
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index b5a169b..20f8e41 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -190,10 +190,7 @@ void iwlagn_rx_replenish_now(struct iwl_priv *priv);
 void iwlagn_rx_queue_free(struct iwl_priv *priv, struct iwl_rx_queue *rxq);
 int iwlagn_rxq_stop(struct iwl_priv *priv);
 int iwlagn_hwrate_to_mac80211_idx(u32 rate_n_flags, enum ieee80211_band band);
-void iwlagn_rx_reply_rx(struct iwl_priv *priv,
-		     struct iwl_rx_mem_buffer *rxb);
-void iwlagn_rx_reply_rx_phy(struct iwl_priv *priv,
-			 struct iwl_rx_mem_buffer *rxb);
+void iwl_setup_rx_handlers(struct iwl_priv *priv);
 
 /* tx */
 void iwl_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq);
@@ -243,14 +240,6 @@ static inline bool iwl_is_tx_success(u32 status)
 
 u8 iwl_toggle_tx_ant(struct iwl_priv *priv, u8 ant_idx, u8 valid);
 
-/* rx */
-void iwl_rx_missed_beacon_notif(struct iwl_priv *priv,
-				struct iwl_rx_mem_buffer *rxb);
-void iwl_rx_statistics(struct iwl_priv *priv,
-		       struct iwl_rx_mem_buffer *rxb);
-void iwl_reply_statistics(struct iwl_priv *priv,
-			  struct iwl_rx_mem_buffer *rxb);
-
 /* scan */
 int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif);
 void iwlagn_post_scan(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 4bd3420..6c30fa6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -869,33 +869,6 @@ void iwl_chswitch_done(struct iwl_priv *priv, bool is_success)
 	}
 }
 
-void iwl_rx_csa(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
-{
-	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	struct iwl_csa_notification *csa = &(pkt->u.csa_notif);
-	/*
-	 * MULTI-FIXME
-	 * See iwl_mac_channel_switch.
-	 */
-	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
-	struct iwl_rxon_cmd *rxon = (void *)&ctx->active;
-
-	if (priv->switch_rxon.switch_in_progress) {
-		if (!le32_to_cpu(csa->status) &&
-		    (csa->channel == priv->switch_rxon.channel)) {
-			rxon->channel = csa->channel;
-			ctx->staging.channel = csa->channel;
-			IWL_DEBUG_11H(priv, "CSA notif: channel %d\n",
-			      le16_to_cpu(csa->channel));
-			iwl_chswitch_done(priv, true);
-		} else {
-			IWL_ERR(priv, "CSA notif (fail) : channel %d\n",
-			      le16_to_cpu(csa->channel));
-			iwl_chswitch_done(priv, false);
-		}
-	}
-}
-
 #ifdef CONFIG_IWLWIFI_DEBUG
 void iwl_print_rx_config_cmd(struct iwl_priv *priv,
 			     struct iwl_rxon_context *ctx)
@@ -1245,42 +1218,6 @@ int iwl_send_statistics_request(struct iwl_priv *priv, u8 flags, bool clear)
 					&statistics_cmd);
 }
 
-void iwl_rx_pm_sleep_notif(struct iwl_priv *priv,
-			   struct iwl_rx_mem_buffer *rxb)
-{
-#ifdef CONFIG_IWLWIFI_DEBUG
-	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	struct iwl_sleep_notification *sleep = &(pkt->u.sleep_notif);
-	IWL_DEBUG_RX(priv, "sleep mode: %d, src: %d\n",
-		     sleep->pm_sleep_mode, sleep->pm_wakeup_src);
-#endif
-}
-
-void iwl_rx_pm_debug_statistics_notif(struct iwl_priv *priv,
-				      struct iwl_rx_mem_buffer *rxb)
-{
-	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	u32 len = le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
-	IWL_DEBUG_RADIO(priv, "Dumping %d bytes of unhandled "
-			"notification for %s:\n", len,
-			get_cmd_string(pkt->hdr.cmd));
-	iwl_print_hex_dump(priv, IWL_DL_RADIO, pkt->u.raw, len);
-}
-
-void iwl_rx_reply_error(struct iwl_priv *priv,
-			struct iwl_rx_mem_buffer *rxb)
-{
-	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-
-	IWL_ERR(priv, "Error Reply type 0x%08X cmd %s (0x%02X) "
-		"seq 0x%04X ser 0x%08X\n",
-		le32_to_cpu(pkt->u.err_resp.error_type),
-		get_cmd_string(pkt->u.err_resp.cmd_id),
-		pkt->u.err_resp.cmd_id,
-		le16_to_cpu(pkt->u.err_resp.bad_cmd_seq_num),
-		le32_to_cpu(pkt->u.err_resp.error_info));
-}
-
 void iwl_clear_isr_stats(struct iwl_priv *priv)
 {
 	memset(&priv->isr_stats, 0, sizeof(priv->isr_stats));
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index d47f3a8..af47750 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -441,10 +441,6 @@ bool iwl_is_ht40_tx_allowed(struct iwl_priv *priv,
 void iwl_connection_init_rx_config(struct iwl_priv *priv,
 				   struct iwl_rxon_context *ctx);
 void iwl_set_rate(struct iwl_priv *priv);
-int iwl_set_decrypted_flag(struct iwl_priv *priv,
-			   struct ieee80211_hdr *hdr,
-			   u32 decrypt_res,
-			   struct ieee80211_rx_status *stats);
 void iwl_irq_handle_error(struct iwl_priv *priv);
 int iwl_mac_add_interface(struct ieee80211_hw *hw,
 			  struct ieee80211_vif *vif);
@@ -493,15 +489,6 @@ static inline void iwl_update_stats(struct iwl_priv *priv, bool is_tx,
 {
 }
 #endif
-/*****************************************************
- * RX handlers.
- * **************************************************/
-void iwl_rx_pm_sleep_notif(struct iwl_priv *priv,
-			   struct iwl_rx_mem_buffer *rxb);
-void iwl_rx_pm_debug_statistics_notif(struct iwl_priv *priv,
-				      struct iwl_rx_mem_buffer *rxb);
-void iwl_rx_reply_error(struct iwl_priv *priv,
-			struct iwl_rx_mem_buffer *rxb);
 
 /*****************************************************
 * RX
@@ -513,11 +500,8 @@ void iwl_rx_queue_update_write_ptr(struct iwl_priv *priv,
 				  struct iwl_rx_queue *q);
 int iwl_rx_queue_space(const struct iwl_rx_queue *q);
 void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb);
-/* Handlers */
-void iwl_rx_spectrum_measure_notif(struct iwl_priv *priv,
-					  struct iwl_rx_mem_buffer *rxb);
+
 void iwl_chswitch_done(struct iwl_priv *priv, bool is_success);
-void iwl_rx_csa(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb);
 
 /* TX helpers */
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 566e2d9..8dc1294 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -38,7 +38,14 @@
 #include "iwl-io.h"
 #include "iwl-helpers.h"
 #include "iwl-agn-calib.h"
-/************************** RX-FUNCTIONS ****************************/
+#include "iwl-agn.h"
+
+/******************************************************************************
+ *
+ * RX path functions
+ *
+ ******************************************************************************/
+
 /*
  * Rx theory of operation
  *
@@ -211,7 +218,104 @@ err_bd:
 	return -ENOMEM;
 }
 
-void iwl_rx_spectrum_measure_notif(struct iwl_priv *priv,
+/******************************************************************************
+ *
+ * Generic RX handler implementations
+ *
+ ******************************************************************************/
+
+static void iwl_rx_reply_alive(struct iwl_priv *priv,
+			       struct iwl_rx_mem_buffer *rxb)
+{
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	struct iwl_alive_resp *palive;
+	struct delayed_work *pwork;
+
+	palive = &pkt->u.alive_frame;
+
+	IWL_DEBUG_INFO(priv, "Alive ucode status 0x%08X revision "
+		       "0x%01X 0x%01X\n",
+		       palive->is_valid, palive->ver_type,
+		       palive->ver_subtype);
+
+	if (palive->ver_subtype == INITIALIZE_SUBTYPE) {
+		IWL_DEBUG_INFO(priv, "Initialization Alive received.\n");
+		memcpy(&priv->card_alive_init,
+		       &pkt->u.alive_frame,
+		       sizeof(struct iwl_init_alive_resp));
+		pwork = &priv->init_alive_start;
+	} else {
+		IWL_DEBUG_INFO(priv, "Runtime Alive received.\n");
+		memcpy(&priv->card_alive, &pkt->u.alive_frame,
+		       sizeof(struct iwl_alive_resp));
+		pwork = &priv->alive_start;
+	}
+
+	/* We delay the ALIVE response by 5ms to
+	 * give the HW RF Kill time to activate... */
+	if (palive->is_valid == UCODE_VALID_OK)
+		queue_delayed_work(priv->workqueue, pwork,
+				   msecs_to_jiffies(5));
+	else {
+		IWL_WARN(priv, "%s uCode did not respond OK.\n",
+			(palive->ver_subtype == INITIALIZE_SUBTYPE) ?
+			"init" : "runtime");
+		/*
+		 * If fail to load init uCode,
+		 * let's try to load the init uCode again.
+		 * We should not get into this situation, but if it
+		 * does happen, we should not move on and loading "runtime"
+		 * without proper calibrate the device.
+		 */
+		if (palive->ver_subtype == INITIALIZE_SUBTYPE)
+			priv->ucode_type = UCODE_NONE;
+		queue_work(priv->workqueue, &priv->restart);
+	}
+}
+
+static void iwl_rx_reply_error(struct iwl_priv *priv,
+			       struct iwl_rx_mem_buffer *rxb)
+{
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+
+	IWL_ERR(priv, "Error Reply type 0x%08X cmd %s (0x%02X) "
+		"seq 0x%04X ser 0x%08X\n",
+		le32_to_cpu(pkt->u.err_resp.error_type),
+		get_cmd_string(pkt->u.err_resp.cmd_id),
+		pkt->u.err_resp.cmd_id,
+		le16_to_cpu(pkt->u.err_resp.bad_cmd_seq_num),
+		le32_to_cpu(pkt->u.err_resp.error_info));
+}
+
+static void iwl_rx_csa(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
+{
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	struct iwl_csa_notification *csa = &(pkt->u.csa_notif);
+	/*
+	 * MULTI-FIXME
+	 * See iwl_mac_channel_switch.
+	 */
+	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
+	struct iwl_rxon_cmd *rxon = (void *)&ctx->active;
+
+	if (priv->switch_rxon.switch_in_progress) {
+		if (!le32_to_cpu(csa->status) &&
+		    (csa->channel == priv->switch_rxon.channel)) {
+			rxon->channel = csa->channel;
+			ctx->staging.channel = csa->channel;
+			IWL_DEBUG_11H(priv, "CSA notif: channel %d\n",
+			      le16_to_cpu(csa->channel));
+			iwl_chswitch_done(priv, true);
+		} else {
+			IWL_ERR(priv, "CSA notif (fail) : channel %d\n",
+			      le16_to_cpu(csa->channel));
+			iwl_chswitch_done(priv, false);
+		}
+	}
+}
+
+
+static void iwl_rx_spectrum_measure_notif(struct iwl_priv *priv,
 					  struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
@@ -227,6 +331,52 @@ void iwl_rx_spectrum_measure_notif(struct iwl_priv *priv,
 	priv->measurement_status |= MEASUREMENT_READY;
 }
 
+static void iwl_rx_pm_sleep_notif(struct iwl_priv *priv,
+				  struct iwl_rx_mem_buffer *rxb)
+{
+#ifdef CONFIG_IWLWIFI_DEBUG
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	struct iwl_sleep_notification *sleep = &(pkt->u.sleep_notif);
+	IWL_DEBUG_RX(priv, "sleep mode: %d, src: %d\n",
+		     sleep->pm_sleep_mode, sleep->pm_wakeup_src);
+#endif
+}
+
+static void iwl_rx_pm_debug_statistics_notif(struct iwl_priv *priv,
+					     struct iwl_rx_mem_buffer *rxb)
+{
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	u32 len = le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
+	IWL_DEBUG_RADIO(priv, "Dumping %d bytes of unhandled "
+			"notification for %s:\n", len,
+			get_cmd_string(pkt->hdr.cmd));
+	iwl_print_hex_dump(priv, IWL_DL_RADIO, pkt->u.raw, len);
+}
+
+static void iwl_rx_beacon_notif(struct iwl_priv *priv,
+				struct iwl_rx_mem_buffer *rxb)
+{
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	struct iwlagn_beacon_notif *beacon = (void *)pkt->u.raw;
+#ifdef CONFIG_IWLWIFI_DEBUG
+	u16 status = le16_to_cpu(beacon->beacon_notify_hdr.status.status);
+	u8 rate = iwl_hw_get_rate(beacon->beacon_notify_hdr.rate_n_flags);
+
+	IWL_DEBUG_RX(priv, "beacon status %#x, retries:%d ibssmgr:%d "
+		"tsf:0x%.8x%.8x rate:%d\n",
+		status & TX_STATUS_MSK,
+		beacon->beacon_notify_hdr.failure_frame,
+		le32_to_cpu(beacon->ibss_mgr_status),
+		le32_to_cpu(beacon->high_tsf),
+		le32_to_cpu(beacon->low_tsf), rate);
+#endif
+
+	priv->ibss_manager = le32_to_cpu(beacon->ibss_mgr_status);
+
+	if (!test_bit(STATUS_EXIT_PENDING, &priv->status))
+		queue_work(priv->workqueue, &priv->beacon_update);
+}
+
 /* the threshold ratio of actual_ack_cnt to expected_ack_cnt in percent */
 #define ACK_CNT_RATIO (50)
 #define BA_TIMEOUT_CNT (5)
@@ -298,7 +448,8 @@ static bool iwl_good_ack_health(struct iwl_priv *priv, struct iwl_rx_packet *pkt
  * When the plcp error is exceeding the thresholds, reset the radio
  * to improve the throughput.
  */
-static bool iwl_good_plcp_health(struct iwl_priv *priv, struct iwl_rx_packet *pkt)
+static bool iwl_good_plcp_health(struct iwl_priv *priv,
+				 struct iwl_rx_packet *pkt)
 {
 	bool rc = true;
 	int combined_plcp_delta;
@@ -378,7 +529,8 @@ static bool iwl_good_plcp_health(struct iwl_priv *priv, struct iwl_rx_packet *pk
 	return rc;
 }
 
-static void iwl_recover_from_statistics(struct iwl_priv *priv, struct iwl_rx_packet *pkt)
+static void iwl_recover_from_statistics(struct iwl_priv *priv,
+					struct iwl_rx_packet *pkt)
 {
 	const struct iwl_mod_params *mod_params = priv->cfg->mod_params;
 
@@ -442,7 +594,6 @@ static void iwl_rx_calc_noise(struct iwl_priv *priv)
 			last_rx_noise);
 }
 
-#ifdef CONFIG_IWLWIFI_DEBUGFS
 /*
  *  based on the assumption of all statistics counter are in DWORD
  *  FIXME: This function is for debugging, do not deal with
@@ -451,6 +602,7 @@ static void iwl_rx_calc_noise(struct iwl_priv *priv)
 static void iwl_accumulative_statistics(struct iwl_priv *priv,
 					__le32 *stats)
 {
+#ifdef CONFIG_IWLWIFI_DEBUGFS
 	int i, size;
 	__le32 *prev_stats;
 	u32 *accum_stats;
@@ -498,14 +650,13 @@ static void iwl_accumulative_statistics(struct iwl_priv *priv,
 	accum_tx->tx_power.ant_a = tx->tx_power.ant_a;
 	accum_tx->tx_power.ant_b = tx->tx_power.ant_b;
 	accum_tx->tx_power.ant_c = tx->tx_power.ant_c;
-}
 #endif
+}
 
-#define REG_RECALIB_PERIOD (60)
-
-void iwl_rx_statistics(struct iwl_priv *priv,
+static void iwl_rx_statistics(struct iwl_priv *priv,
 			      struct iwl_rx_mem_buffer *rxb)
 {
+	const int reg_recalib_period = 60;
 	int change;
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 
@@ -522,10 +673,8 @@ void iwl_rx_statistics(struct iwl_priv *priv,
 			   STATISTICS_REPLY_FLG_HT40_MODE_MSK) !=
 			   (pkt->u.stats_bt.flag &
 			   STATISTICS_REPLY_FLG_HT40_MODE_MSK)));
-#ifdef CONFIG_IWLWIFI_DEBUGFS
-		iwl_accumulative_statistics(priv, (__le32 *)&pkt->u.stats_bt);
-#endif
 
+		iwl_accumulative_statistics(priv, (__le32 *)&pkt->u.stats_bt);
 	} else {
 		IWL_DEBUG_RX(priv,
 			     "Statistics notification received (%d vs %d).\n",
@@ -539,10 +688,8 @@ void iwl_rx_statistics(struct iwl_priv *priv,
 			   STATISTICS_REPLY_FLG_HT40_MODE_MSK) !=
 			   (pkt->u.stats.flag &
 			   STATISTICS_REPLY_FLG_HT40_MODE_MSK)));
-#ifdef CONFIG_IWLWIFI_DEBUGFS
-		iwl_accumulative_statistics(priv, (__le32 *)&pkt->u.stats);
-#endif
 
+		iwl_accumulative_statistics(priv, (__le32 *)&pkt->u.stats);
 	}
 
 	iwl_recover_from_statistics(priv, pkt);
@@ -557,11 +704,11 @@ void iwl_rx_statistics(struct iwl_priv *priv,
 	set_bit(STATUS_STATISTICS, &priv->status);
 
 	/* Reschedule the statistics timer to occur in
-	 * REG_RECALIB_PERIOD seconds to ensure we get a
+	 * reg_recalib_period seconds to ensure we get a
 	 * thermal update even if the uCode doesn't give
 	 * us one */
 	mod_timer(&priv->statistics_periodic, jiffies +
-		  msecs_to_jiffies(REG_RECALIB_PERIOD * 1000));
+		  msecs_to_jiffies(reg_recalib_period * 1000));
 
 	if (unlikely(!test_bit(STATUS_SCANNING, &priv->status)) &&
 	    (pkt->hdr.cmd == STATISTICS_NOTIFICATION)) {
@@ -572,8 +719,8 @@ void iwl_rx_statistics(struct iwl_priv *priv,
 		priv->cfg->ops->lib->temp_ops.temperature(priv);
 }
 
-void iwl_reply_statistics(struct iwl_priv *priv,
-			      struct iwl_rx_mem_buffer *rxb)
+static void iwl_rx_reply_statistics(struct iwl_priv *priv,
+				    struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 
@@ -597,8 +744,61 @@ void iwl_reply_statistics(struct iwl_priv *priv,
 	iwl_rx_statistics(priv, rxb);
 }
 
-void iwl_rx_missed_beacon_notif(struct iwl_priv *priv,
-				struct iwl_rx_mem_buffer *rxb)
+/* Handle notification from uCode that card's power state is changing
+ * due to software, hardware, or critical temperature RFKILL */
+static void iwl_rx_card_state_notif(struct iwl_priv *priv,
+				    struct iwl_rx_mem_buffer *rxb)
+{
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	u32 flags = le32_to_cpu(pkt->u.card_state_notif.flags);
+	unsigned long status = priv->status;
+
+	IWL_DEBUG_RF_KILL(priv, "Card state received: HW:%s SW:%s CT:%s\n",
+			  (flags & HW_CARD_DISABLED) ? "Kill" : "On",
+			  (flags & SW_CARD_DISABLED) ? "Kill" : "On",
+			  (flags & CT_CARD_DISABLED) ?
+			  "Reached" : "Not reached");
+
+	if (flags & (SW_CARD_DISABLED | HW_CARD_DISABLED |
+		     CT_CARD_DISABLED)) {
+
+		iwl_write32(priv, CSR_UCODE_DRV_GP1_SET,
+			    CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED);
+
+		iwl_write_direct32(priv, HBUS_TARG_MBX_C,
+					HBUS_TARG_MBX_C_REG_BIT_CMD_BLOCKED);
+
+		if (!(flags & RXON_CARD_DISABLED)) {
+			iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR,
+				    CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED);
+			iwl_write_direct32(priv, HBUS_TARG_MBX_C,
+					HBUS_TARG_MBX_C_REG_BIT_CMD_BLOCKED);
+		}
+		if (flags & CT_CARD_DISABLED)
+			iwl_tt_enter_ct_kill(priv);
+	}
+	if (!(flags & CT_CARD_DISABLED))
+		iwl_tt_exit_ct_kill(priv);
+
+	if (flags & HW_CARD_DISABLED)
+		set_bit(STATUS_RF_KILL_HW, &priv->status);
+	else
+		clear_bit(STATUS_RF_KILL_HW, &priv->status);
+
+
+	if (!(flags & RXON_CARD_DISABLED))
+		iwl_scan_cancel(priv);
+
+	if ((test_bit(STATUS_RF_KILL_HW, &status) !=
+	     test_bit(STATUS_RF_KILL_HW, &priv->status)))
+		wiphy_rfkill_set_hw_state(priv->hw->wiphy,
+			test_bit(STATUS_RF_KILL_HW, &priv->status));
+	else
+		wake_up_interruptible(&priv->wait_command_queue);
+}
+
+static void iwl_rx_missed_beacon_notif(struct iwl_priv *priv,
+				       struct iwl_rx_mem_buffer *rxb)
 
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
@@ -618,13 +818,25 @@ void iwl_rx_missed_beacon_notif(struct iwl_priv *priv,
 	}
 }
 
+/* Cache phy data (Rx signal strength, etc) for HT frame (REPLY_RX_PHY_CMD).
+ * This will be used later in iwl_rx_reply_rx() for REPLY_RX_MPDU_CMD. */
+static void iwl_rx_reply_rx_phy(struct iwl_priv *priv,
+				struct iwl_rx_mem_buffer *rxb)
+{
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+
+	priv->_agn.last_phy_res_valid = true;
+	memcpy(&priv->_agn.last_phy_res, pkt->u.raw,
+	       sizeof(struct iwl_rx_phy_res));
+}
+
 /*
  * returns non-zero if packet should be dropped
  */
-int iwl_set_decrypted_flag(struct iwl_priv *priv,
-			   struct ieee80211_hdr *hdr,
-			   u32 decrypt_res,
-			   struct ieee80211_rx_status *stats)
+static int iwl_set_decrypted_flag(struct iwl_priv *priv,
+				  struct ieee80211_hdr *hdr,
+				  u32 decrypt_res,
+				  struct ieee80211_rx_status *stats)
 {
 	u16 fc = le16_to_cpu(hdr->frame_control);
 
@@ -669,3 +881,264 @@ int iwl_set_decrypted_flag(struct iwl_priv *priv,
 	}
 	return 0;
 }
+
+static void iwl_pass_packet_to_mac80211(struct iwl_priv *priv,
+					struct ieee80211_hdr *hdr,
+					u16 len,
+					u32 ampdu_status,
+					struct iwl_rx_mem_buffer *rxb,
+					struct ieee80211_rx_status *stats)
+{
+	struct sk_buff *skb;
+	__le16 fc = hdr->frame_control;
+
+	/* We only process data packets if the interface is open */
+	if (unlikely(!priv->is_open)) {
+		IWL_DEBUG_DROP_LIMIT(priv,
+		    "Dropping packet while interface is not open.\n");
+		return;
+	}
+
+	/* In case of HW accelerated crypto and bad decryption, drop */
+	if (!priv->cfg->mod_params->sw_crypto &&
+	    iwl_set_decrypted_flag(priv, hdr, ampdu_status, stats))
+		return;
+
+	skb = dev_alloc_skb(128);
+	if (!skb) {
+		IWL_ERR(priv, "dev_alloc_skb failed\n");
+		return;
+	}
+
+	skb_add_rx_frag(skb, 0, rxb->page, (void *)hdr - rxb_addr(rxb), len);
+
+	iwl_update_stats(priv, false, fc, len);
+	memcpy(IEEE80211_SKB_RXCB(skb), stats, sizeof(*stats));
+
+	ieee80211_rx(priv->hw, skb);
+	priv->alloc_rxb_page--;
+	rxb->page = NULL;
+}
+
+static u32 iwl_translate_rx_status(struct iwl_priv *priv, u32 decrypt_in)
+{
+	u32 decrypt_out = 0;
+
+	if ((decrypt_in & RX_RES_STATUS_STATION_FOUND) ==
+					RX_RES_STATUS_STATION_FOUND)
+		decrypt_out |= (RX_RES_STATUS_STATION_FOUND |
+				RX_RES_STATUS_NO_STATION_INFO_MISMATCH);
+
+	decrypt_out |= (decrypt_in & RX_RES_STATUS_SEC_TYPE_MSK);
+
+	/* packet was not encrypted */
+	if ((decrypt_in & RX_RES_STATUS_SEC_TYPE_MSK) ==
+					RX_RES_STATUS_SEC_TYPE_NONE)
+		return decrypt_out;
+
+	/* packet was encrypted with unknown alg */
+	if ((decrypt_in & RX_RES_STATUS_SEC_TYPE_MSK) ==
+					RX_RES_STATUS_SEC_TYPE_ERR)
+		return decrypt_out;
+
+	/* decryption was not done in HW */
+	if ((decrypt_in & RX_MPDU_RES_STATUS_DEC_DONE_MSK) !=
+					RX_MPDU_RES_STATUS_DEC_DONE_MSK)
+		return decrypt_out;
+
+	switch (decrypt_in & RX_RES_STATUS_SEC_TYPE_MSK) {
+
+	case RX_RES_STATUS_SEC_TYPE_CCMP:
+		/* alg is CCM: check MIC only */
+		if (!(decrypt_in & RX_MPDU_RES_STATUS_MIC_OK))
+			/* Bad MIC */
+			decrypt_out |= RX_RES_STATUS_BAD_ICV_MIC;
+		else
+			decrypt_out |= RX_RES_STATUS_DECRYPT_OK;
+
+		break;
+
+	case RX_RES_STATUS_SEC_TYPE_TKIP:
+		if (!(decrypt_in & RX_MPDU_RES_STATUS_TTAK_OK)) {
+			/* Bad TTAK */
+			decrypt_out |= RX_RES_STATUS_BAD_KEY_TTAK;
+			break;
+		}
+		/* fall through if TTAK OK */
+	default:
+		if (!(decrypt_in & RX_MPDU_RES_STATUS_ICV_OK))
+			decrypt_out |= RX_RES_STATUS_BAD_ICV_MIC;
+		else
+			decrypt_out |= RX_RES_STATUS_DECRYPT_OK;
+		break;
+	}
+
+	IWL_DEBUG_RX(priv, "decrypt_in:0x%x  decrypt_out = 0x%x\n",
+					decrypt_in, decrypt_out);
+
+	return decrypt_out;
+}
+
+/* Called for REPLY_RX (legacy ABG frames), or
+ * REPLY_RX_MPDU_CMD (HT high-throughput N frames). */
+static void iwl_rx_reply_rx(struct iwl_priv *priv,
+			    struct iwl_rx_mem_buffer *rxb)
+{
+	struct ieee80211_hdr *header;
+	struct ieee80211_rx_status rx_status;
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	struct iwl_rx_phy_res *phy_res;
+	__le32 rx_pkt_status;
+	struct iwl_rx_mpdu_res_start *amsdu;
+	u32 len;
+	u32 ampdu_status;
+	u32 rate_n_flags;
+
+	/**
+	 * REPLY_RX and REPLY_RX_MPDU_CMD are handled differently.
+	 *	REPLY_RX: physical layer info is in this buffer
+	 *	REPLY_RX_MPDU_CMD: physical layer info was sent in separate
+	 *		command and cached in priv->last_phy_res
+	 *
+	 * Here we set up local variables depending on which command is
+	 * received.
+	 */
+	if (pkt->hdr.cmd == REPLY_RX) {
+		phy_res = (struct iwl_rx_phy_res *)pkt->u.raw;
+		header = (struct ieee80211_hdr *)(pkt->u.raw + sizeof(*phy_res)
+				+ phy_res->cfg_phy_cnt);
+
+		len = le16_to_cpu(phy_res->byte_count);
+		rx_pkt_status = *(__le32 *)(pkt->u.raw + sizeof(*phy_res) +
+				phy_res->cfg_phy_cnt + len);
+		ampdu_status = le32_to_cpu(rx_pkt_status);
+	} else {
+		if (!priv->_agn.last_phy_res_valid) {
+			IWL_ERR(priv, "MPDU frame without cached PHY data\n");
+			return;
+		}
+		phy_res = &priv->_agn.last_phy_res;
+		amsdu = (struct iwl_rx_mpdu_res_start *)pkt->u.raw;
+		header = (struct ieee80211_hdr *)(pkt->u.raw + sizeof(*amsdu));
+		len = le16_to_cpu(amsdu->byte_count);
+		rx_pkt_status = *(__le32 *)(pkt->u.raw + sizeof(*amsdu) + len);
+		ampdu_status = iwl_translate_rx_status(priv,
+						le32_to_cpu(rx_pkt_status));
+	}
+
+	if ((unlikely(phy_res->cfg_phy_cnt > 20))) {
+		IWL_DEBUG_DROP(priv, "dsp size out of range [0,20]: %d/n",
+				phy_res->cfg_phy_cnt);
+		return;
+	}
+
+	if (!(rx_pkt_status & RX_RES_STATUS_NO_CRC32_ERROR) ||
+	    !(rx_pkt_status & RX_RES_STATUS_NO_RXE_OVERFLOW)) {
+		IWL_DEBUG_RX(priv, "Bad CRC or FIFO: 0x%08X.\n",
+				le32_to_cpu(rx_pkt_status));
+		return;
+	}
+
+	/* This will be used in several places later */
+	rate_n_flags = le32_to_cpu(phy_res->rate_n_flags);
+
+	/* rx_status carries information about the packet to mac80211 */
+	rx_status.mactime = le64_to_cpu(phy_res->timestamp);
+	rx_status.band = (phy_res->phy_flags & RX_RES_PHY_FLAGS_BAND_24_MSK) ?
+				IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ;
+	rx_status.freq =
+		ieee80211_channel_to_frequency(le16_to_cpu(phy_res->channel),
+					       rx_status.band);
+	rx_status.rate_idx =
+		iwlagn_hwrate_to_mac80211_idx(rate_n_flags, rx_status.band);
+	rx_status.flag = 0;
+
+	/* TSF isn't reliable. In order to allow smooth user experience,
+	 * this W/A doesn't propagate it to the mac80211 */
+	/*rx_status.flag |= RX_FLAG_MACTIME_MPDU;*/
+
+	priv->ucode_beacon_time = le32_to_cpu(phy_res->beacon_time_stamp);
+
+	/* Find max signal strength (dBm) among 3 antenna/receiver chains */
+	rx_status.signal = priv->cfg->ops->utils->calc_rssi(priv, phy_res);
+
+	iwl_dbg_log_rx_data_frame(priv, len, header);
+	IWL_DEBUG_STATS_LIMIT(priv, "Rssi %d, TSF %llu\n",
+		rx_status.signal, (unsigned long long)rx_status.mactime);
+
+	/*
+	 * "antenna number"
+	 *
+	 * It seems that the antenna field in the phy flags value
+	 * is actually a bit field. This is undefined by radiotap,
+	 * it wants an actual antenna number but I always get "7"
+	 * for most legacy frames I receive indicating that the
+	 * same frame was received on all three RX chains.
+	 *
+	 * I think this field should be removed in favor of a
+	 * new 802.11n radiotap field "RX chains" that is defined
+	 * as a bitmask.
+	 */
+	rx_status.antenna =
+		(le16_to_cpu(phy_res->phy_flags) & RX_RES_PHY_FLAGS_ANTENNA_MSK)
+		>> RX_RES_PHY_FLAGS_ANTENNA_POS;
+
+	/* set the preamble flag if appropriate */
+	if (phy_res->phy_flags & RX_RES_PHY_FLAGS_SHORT_PREAMBLE_MSK)
+		rx_status.flag |= RX_FLAG_SHORTPRE;
+
+	/* Set up the HT phy flags */
+	if (rate_n_flags & RATE_MCS_HT_MSK)
+		rx_status.flag |= RX_FLAG_HT;
+	if (rate_n_flags & RATE_MCS_HT40_MSK)
+		rx_status.flag |= RX_FLAG_40MHZ;
+	if (rate_n_flags & RATE_MCS_SGI_MSK)
+		rx_status.flag |= RX_FLAG_SHORT_GI;
+
+	iwl_pass_packet_to_mac80211(priv, header, len, ampdu_status,
+				    rxb, &rx_status);
+}
+
+/**
+ * iwl_setup_rx_handlers - Initialize Rx handler callbacks
+ *
+ * Setup the RX handlers for each of the reply types sent from the uCode
+ * to the host.
+ */
+void iwl_setup_rx_handlers(struct iwl_priv *priv)
+{
+	void (**handlers)(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb);
+
+	handlers = priv->rx_handlers;
+
+	handlers[REPLY_ALIVE]			= iwl_rx_reply_alive;
+	handlers[REPLY_ERROR]			= iwl_rx_reply_error;
+	handlers[CHANNEL_SWITCH_NOTIFICATION]	= iwl_rx_csa;
+	handlers[SPECTRUM_MEASURE_NOTIFICATION]	= iwl_rx_spectrum_measure_notif;
+	handlers[PM_SLEEP_NOTIFICATION]		= iwl_rx_pm_sleep_notif;
+	handlers[PM_DEBUG_STATISTIC_NOTIFIC]	= iwl_rx_pm_debug_statistics_notif;
+	handlers[BEACON_NOTIFICATION]		= iwl_rx_beacon_notif;
+
+	/*
+	 * The same handler is used for both the REPLY to a discrete
+	 * statistics request from the host as well as for the periodic
+	 * statistics notifications (after received beacons) from the uCode.
+	 */
+	handlers[REPLY_STATISTICS_CMD]		= iwl_rx_reply_statistics;
+	handlers[STATISTICS_NOTIFICATION]	= iwl_rx_statistics;
+
+	iwl_setup_rx_scan_handlers(priv);
+
+	handlers[CARD_STATE_NOTIFICATION]	= iwl_rx_card_state_notif;
+	handlers[MISSED_BEACONS_NOTIFICATION]	= iwl_rx_missed_beacon_notif;
+
+	/* Rx handlers */
+	handlers[REPLY_RX_PHY_CMD]		= iwl_rx_reply_rx_phy;
+	handlers[REPLY_RX_MPDU_CMD]		= iwl_rx_reply_rx;
+
+	/* block ack */
+	handlers[REPLY_COMPRESSED_BA]		= iwlagn_rx_reply_compressed_ba;
+
+	/* Set up hardware specific Rx handlers */
+	priv->cfg->ops->lib->rx_handler_setup(priv);
+}
-- 
1.7.1

