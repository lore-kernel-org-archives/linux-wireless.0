Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:27309 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753642AbYJ2VF1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 17:05:27 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 4/7] iwlwifi: rename generic iwlagn functions that had a HW specific name
Date: Wed, 29 Oct 2008 14:05:46 -0700
Message-Id: <1225314349-11139-5-git-send-email-reinette.chatre@intel.com> (sfid-20081029_220537_912673_1042FB93)
In-Reply-To: <1225314349-11139-4-git-send-email-reinette.chatre@intel.com>
References: <>
 <1225314349-11139-1-git-send-email-reinette.chatre@intel.com>
 <1225314349-11139-2-git-send-email-reinette.chatre@intel.com>
 <1225314349-11139-3-git-send-email-reinette.chatre@intel.com>
 <1225314349-11139-4-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch renames functions that are generic in iwl-agn and had a iwl4965
prefix.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |    4 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c  |  402 +++++++++++++++---------------
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    4 +-
 4 files changed, 207 insertions(+), 207 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 0953a9c..157cad4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2323,7 +2323,7 @@ static struct iwl_lib_ops iwl4965_lib = {
 		.reset = iwl4965_apm_reset,
 		.stop = iwl4965_apm_stop,
 		.config = iwl4965_nic_config,
-		.set_pwr_src = iwl4965_set_pwr_src,
+		.set_pwr_src = iwl_set_pwr_src,
 	},
 	.eeprom_ops = {
 		.regulatory_bands = {
@@ -2342,7 +2342,7 @@ static struct iwl_lib_ops iwl4965_lib = {
 		.query_addr = iwlcore_eeprom_query_addr,
 	},
 	.send_tx_power	= iwl4965_send_tx_power,
-	.update_chain_flags = iwl4965_update_chain_flags,
+	.update_chain_flags = iwl_update_chain_flags,
 	.temperature = iwl4965_temperature_calib,
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 1608b28..31e62a8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1474,13 +1474,13 @@ static struct iwl_lib_ops iwl5000_lib = {
 	.alive_notify = iwl5000_alive_notify,
 	.send_tx_power = iwl5000_send_tx_power,
 	.temperature = iwl5000_temperature,
-	.update_chain_flags = iwl4965_update_chain_flags,
+	.update_chain_flags = iwl_update_chain_flags,
 	.apm_ops = {
 		.init =	iwl5000_apm_init,
 		.reset = iwl5000_apm_reset,
 		.stop = iwl5000_apm_stop,
 		.config = iwl5000_nic_config,
-		.set_pwr_src = iwl4965_set_pwr_src,
+		.set_pwr_src = iwl_set_pwr_src,
 	},
 	.eeprom_ops = {
 		.regulatory_bands = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 3eb3fea..97b4329 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -96,7 +96,7 @@ MODULE_ALIAS("iwl4965");
 
 
 
-static void iwl4965_set_rxon_hwcrypto(struct iwl_priv *priv, int hw_decrypt)
+static void iwl_set_rxon_hwcrypto(struct iwl_priv *priv, int hw_decrypt)
 {
 	struct iwl_rxon_cmd *rxon = &priv->staging_rxon;
 
@@ -108,13 +108,13 @@ static void iwl4965_set_rxon_hwcrypto(struct iwl_priv *priv, int hw_decrypt)
 }
 
 /**
- * iwl4965_check_rxon_cmd - validate RXON structure is valid
+ * iwl_check_rxon_cmd - validate RXON structure is valid
  *
  * NOTE:  This is really only useful during development and can eventually
  * be #ifdef'd out once the driver is stable and folks aren't actively
  * making changes
  */
-static int iwl4965_check_rxon_cmd(struct iwl_rxon_cmd *rxon)
+static int iwl_check_rxon_cmd(struct iwl_rxon_cmd *rxon)
 {
 	int error = 0;
 	int counter = 1;
@@ -174,7 +174,7 @@ static int iwl4965_check_rxon_cmd(struct iwl_rxon_cmd *rxon)
 			    le16_to_cpu(rxon->channel));
 
 	if (error) {
-		IWL_ERROR("Not a valid iwl4965_rxon_assoc_cmd field values\n");
+		IWL_ERROR("Not a valid iwl_rxon_assoc_cmd field values\n");
 		return -1;
 	}
 	return 0;
@@ -228,14 +228,14 @@ static int iwl_full_rxon_required(struct iwl_priv *priv)
 }
 
 /**
- * iwl4965_commit_rxon - commit staging_rxon to hardware
+ * iwl_commit_rxon - commit staging_rxon to hardware
  *
  * The RXON command in staging_rxon is committed to the hardware and
  * the active_rxon structure is updated with the new data.  This
  * function correctly transitions out of the RXON_ASSOC_MSK state if
  * a HW tune is required based on the RXON structure changes.
  */
-static int iwl4965_commit_rxon(struct iwl_priv *priv)
+static int iwl_commit_rxon(struct iwl_priv *priv)
 {
 	/* cast away the const for active_rxon in this function */
 	struct iwl_rxon_cmd *active_rxon = (void *)&priv->active_rxon;
@@ -253,14 +253,14 @@ static int iwl4965_commit_rxon(struct iwl_priv *priv)
 	 * 5000, but will not damage 4965 */
 	priv->staging_rxon.flags |= RXON_FLG_SELF_CTS_EN;
 
-	ret = iwl4965_check_rxon_cmd(&priv->staging_rxon);
+	ret = iwl_check_rxon_cmd(&priv->staging_rxon);
 	if (ret) {
 		IWL_ERROR("Invalid RXON configuration.  Not committing.\n");
 		return -EINVAL;
 	}
 
 	/* If we don't need to send a full RXON, we can use
-	 * iwl4965_rxon_assoc_cmd which is used to reconfigure filter
+	 * iwl_rxon_assoc_cmd which is used to reconfigure filter
 	 * and other flags for the current radio configuration. */
 	if (!iwl_full_rxon_required(priv)) {
 		ret = iwl_send_rxon_assoc(priv);
@@ -305,7 +305,7 @@ static int iwl4965_commit_rxon(struct iwl_priv *priv)
 		       le16_to_cpu(priv->staging_rxon.channel),
 		       print_mac(mac, priv->staging_rxon.bssid_addr));
 
-	iwl4965_set_rxon_hwcrypto(priv, !priv->hw_params.sw_crypto);
+	iwl_set_rxon_hwcrypto(priv, !priv->hw_params.sw_crypto);
 
 	/* Apply the new configuration
 	 * RXON unassoc clears the station table in uCode, send it before
@@ -375,14 +375,14 @@ static int iwl4965_commit_rxon(struct iwl_priv *priv)
 	return 0;
 }
 
-void iwl4965_update_chain_flags(struct iwl_priv *priv)
+void iwl_update_chain_flags(struct iwl_priv *priv)
 {
 
 	iwl_set_rxon_chain(priv);
-	iwl4965_commit_rxon(priv);
+	iwl_commit_rxon(priv);
 }
 
-static int iwl4965_send_bt_config(struct iwl_priv *priv)
+static int iwl_send_bt_config(struct iwl_priv *priv)
 {
 	struct iwl4965_bt_cmd bt_cmd = {
 		.flags = 3,
@@ -460,7 +460,7 @@ static unsigned int iwl_fill_beacon_frame(struct iwl_priv *priv,
 	return priv->ibss_beacon->len;
 }
 
-static u8 iwl4965_rate_get_lowest_plcp(struct iwl_priv *priv)
+static u8 iwl_rate_get_lowest_plcp(struct iwl_priv *priv)
 {
 	int i;
 	int rate_mask;
@@ -485,7 +485,7 @@ static u8 iwl4965_rate_get_lowest_plcp(struct iwl_priv *priv)
 		return IWL_RATE_6M_PLCP;
 }
 
-static unsigned int iwl4965_hw_get_beacon_cmd(struct iwl_priv *priv,
+static unsigned int iwl_hw_get_beacon_cmd(struct iwl_priv *priv,
 				       struct iwl_frame *frame, u8 rate)
 {
 	struct iwl_tx_beacon_cmd *tx_beacon_cmd;
@@ -517,7 +517,7 @@ static unsigned int iwl4965_hw_get_beacon_cmd(struct iwl_priv *priv,
 
 	return sizeof(*tx_beacon_cmd) + frame_size;
 }
-static int iwl4965_send_beacon_cmd(struct iwl_priv *priv)
+static int iwl_send_beacon_cmd(struct iwl_priv *priv)
 {
 	struct iwl_frame *frame;
 	unsigned int frame_size;
@@ -532,9 +532,9 @@ static int iwl4965_send_beacon_cmd(struct iwl_priv *priv)
 		return -ENOMEM;
 	}
 
-	rate = iwl4965_rate_get_lowest_plcp(priv);
+	rate = iwl_rate_get_lowest_plcp(priv);
 
-	frame_size = iwl4965_hw_get_beacon_cmd(priv, frame, rate);
+	frame_size = iwl_hw_get_beacon_cmd(priv, frame, rate);
 
 	rc = iwl_send_cmd_pdu(priv, REPLY_TX_BEACON, frame_size,
 			      &frame->u.cmd[0]);
@@ -550,7 +550,7 @@ static int iwl4965_send_beacon_cmd(struct iwl_priv *priv)
  *
  ******************************************************************************/
 
-static void iwl4965_ht_conf(struct iwl_priv *priv,
+static void iwl_ht_conf(struct iwl_priv *priv,
 			    struct ieee80211_bss_conf *bss_conf)
 {
 	struct ieee80211_sta_ht_cap *ht_conf;
@@ -709,7 +709,7 @@ static void iwl_set_flags_for_band(struct iwl_priv *priv,
 		      | RXON_FLG_CCK_MSK);
 		priv->staging_rxon.flags |= RXON_FLG_SHORT_SLOT_MSK;
 	} else {
-		/* Copied from iwl4965_post_associate() */
+		/* Copied from iwl_post_associate() */
 		if (priv->assoc_capability & WLAN_CAPABILITY_SHORT_SLOT_TIME)
 			priv->staging_rxon.flags |= RXON_FLG_SHORT_SLOT_MSK;
 		else
@@ -727,7 +727,7 @@ static void iwl_set_flags_for_band(struct iwl_priv *priv,
 /*
  * initialize rxon structure with default values from eeprom
  */
-static void iwl4965_connection_init_rx_config(struct iwl_priv *priv, int mode)
+static void iwl_connection_init_rx_config(struct iwl_priv *priv, int mode)
 {
 	const struct iwl_channel_info *ch_info;
 
@@ -802,9 +802,9 @@ static void iwl4965_connection_init_rx_config(struct iwl_priv *priv, int mode)
 	iwl_set_rxon_chain(priv);
 }
 
-static int iwl4965_set_mode(struct iwl_priv *priv, int mode)
+static int iwl_set_mode(struct iwl_priv *priv, int mode)
 {
-	iwl4965_connection_init_rx_config(priv, mode);
+	iwl_connection_init_rx_config(priv, mode);
 	memcpy(priv->staging_rxon.node_addr, priv->mac_addr, ETH_ALEN);
 
 	iwl_clear_stations_table(priv);
@@ -820,12 +820,12 @@ static int iwl4965_set_mode(struct iwl_priv *priv, int mode)
 		return -EAGAIN;
 	}
 
-	iwl4965_commit_rxon(priv);
+	iwl_commit_rxon(priv);
 
 	return 0;
 }
 
-static void iwl4965_set_rate(struct iwl_priv *priv)
+static void iwl_set_rate(struct iwl_priv *priv)
 {
 	const struct ieee80211_supported_band *hw = NULL;
 	struct ieee80211_rate *rate;
@@ -887,7 +887,7 @@ static void iwl4965_set_rate(struct iwl_priv *priv)
  * the lower 3 bytes is the time in usec within one beacon interval
  */
 
-static u32 iwl4965_usecs_to_beacons(u32 usec, u32 beacon_interval)
+static u32 iwl_usecs_to_beacons(u32 usec, u32 beacon_interval)
 {
 	u32 quot;
 	u32 rem;
@@ -906,7 +906,7 @@ static u32 iwl4965_usecs_to_beacons(u32 usec, u32 beacon_interval)
  * the same as HW timer counter counting down
  */
 
-static __le32 iwl4965_add_beacon_time(u32 base, u32 addon, u32 beacon_interval)
+static __le32 iwl_add_beacon_time(u32 base, u32 addon, u32 beacon_interval)
 {
 	u32 base_low = base & BEACON_TIME_MASK_LOW;
 	u32 addon_low = addon & BEACON_TIME_MASK_LOW;
@@ -925,7 +925,7 @@ static __le32 iwl4965_add_beacon_time(u32 base, u32 addon, u32 beacon_interval)
 	return cpu_to_le32(res);
 }
 
-static int iwl4965_get_measurement(struct iwl_priv *priv,
+static int iwl_get_measurement(struct iwl_priv *priv,
 			       struct ieee80211_measurement_params *params,
 			       u8 type)
 {
@@ -943,7 +943,7 @@ static int iwl4965_get_measurement(struct iwl_priv *priv,
 
 	if (iwl_is_associated(priv))
 		add_time =
-		    iwl4965_usecs_to_beacons(
+		    iwl_usecs_to_beacons(
 			le64_to_cpu(params->start_time) - priv->last_tsf,
 			le16_to_cpu(priv->rxon_timing.beacon_interval));
 
@@ -958,7 +958,7 @@ static int iwl4965_get_measurement(struct iwl_priv *priv,
 
 	if (iwl_is_associated(priv))
 		spectrum.start_time =
-		    iwl4965_add_beacon_time(priv->last_beacon_time,
+		    iwl_add_beacon_time(priv->last_beacon_time,
 				add_time,
 				le16_to_cpu(priv->rxon_timing.beacon_interval));
 	else
@@ -1046,7 +1046,7 @@ static void iwl_rx_reply_alive(struct iwl_priv *priv,
 		IWL_WARNING("uCode did not respond OK.\n");
 }
 
-static void iwl4965_rx_reply_error(struct iwl_priv *priv,
+static void iwl_rx_reply_error(struct iwl_priv *priv,
 				   struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
@@ -1062,7 +1062,7 @@ static void iwl4965_rx_reply_error(struct iwl_priv *priv,
 
 #define TX_STATUS_ENTRY(x) case TX_STATUS_FAIL_ ## x: return #x
 
-static void iwl4965_rx_csa(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
+static void iwl_rx_csa(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
 	struct iwl_rxon_cmd *rxon = (void *)&priv->active_rxon;
@@ -1073,7 +1073,7 @@ static void iwl4965_rx_csa(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 	priv->staging_rxon.channel = csa->channel;
 }
 
-static void iwl4965_rx_spectrum_measure_notif(struct iwl_priv *priv,
+static void iwl_rx_spectrum_measure_notif(struct iwl_priv *priv,
 					  struct iwl_rx_mem_buffer *rxb)
 {
 #ifdef CONFIG_IWLAGN_SPECTRUM_MEASUREMENT
@@ -1091,7 +1091,7 @@ static void iwl4965_rx_spectrum_measure_notif(struct iwl_priv *priv,
 #endif
 }
 
-static void iwl4965_rx_pm_sleep_notif(struct iwl_priv *priv,
+static void iwl_rx_pm_sleep_notif(struct iwl_priv *priv,
 				      struct iwl_rx_mem_buffer *rxb)
 {
 #ifdef CONFIG_IWLWIFI_DEBUG
@@ -1102,7 +1102,7 @@ static void iwl4965_rx_pm_sleep_notif(struct iwl_priv *priv,
 #endif
 }
 
-static void iwl4965_rx_pm_debug_statistics_notif(struct iwl_priv *priv,
+static void iwl_rx_pm_debug_statistics_notif(struct iwl_priv *priv,
 					     struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
@@ -1112,7 +1112,7 @@ static void iwl4965_rx_pm_debug_statistics_notif(struct iwl_priv *priv,
 	iwl_print_hex_dump(priv, IWL_DL_RADIO, pkt->u.raw, le32_to_cpu(pkt->len));
 }
 
-static void iwl4965_bg_beacon_update(struct work_struct *work)
+static void iwl_bg_beacon_update(struct work_struct *work)
 {
 	struct iwl_priv *priv =
 		container_of(work, struct iwl_priv, beacon_update);
@@ -1134,11 +1134,11 @@ static void iwl4965_bg_beacon_update(struct work_struct *work)
 	priv->ibss_beacon = beacon;
 	mutex_unlock(&priv->mutex);
 
-	iwl4965_send_beacon_cmd(priv);
+	iwl_send_beacon_cmd(priv);
 }
 
 /**
- * iwl4965_bg_statistics_periodic - Timer callback to queue statistics
+ * iwl_bg_statistics_periodic - Timer callback to queue statistics
  *
  * This callback is provided in order to send a statistics request.
  *
@@ -1147,7 +1147,7 @@ static void iwl4965_bg_beacon_update(struct work_struct *work)
  * was received.  We need to ensure we receive the statistics in order
  * to update the temperature used for calibrating the TXPOWER.
  */
-static void iwl4965_bg_statistics_periodic(unsigned long data)
+static void iwl_bg_statistics_periodic(unsigned long data)
 {
 	struct iwl_priv *priv = (struct iwl_priv *)data;
 
@@ -1157,7 +1157,7 @@ static void iwl4965_bg_statistics_periodic(unsigned long data)
 	iwl_send_statistics_request(priv, CMD_ASYNC);
 }
 
-static void iwl4965_rx_beacon_notif(struct iwl_priv *priv,
+static void iwl_rx_beacon_notif(struct iwl_priv *priv,
 				struct iwl_rx_mem_buffer *rxb)
 {
 #ifdef CONFIG_IWLWIFI_DEBUG
@@ -1181,7 +1181,7 @@ static void iwl4965_rx_beacon_notif(struct iwl_priv *priv,
 
 /* Handle notification from uCode that card's power state is changing
  * due to software, hardware, or critical temperature RFKILL */
-static void iwl4965_rx_card_state_notif(struct iwl_priv *priv,
+static void iwl_rx_card_state_notif(struct iwl_priv *priv,
 				    struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
@@ -1250,7 +1250,7 @@ static void iwl4965_rx_card_state_notif(struct iwl_priv *priv,
 		wake_up_interruptible(&priv->wait_command_queue);
 }
 
-int iwl4965_set_pwr_src(struct iwl_priv *priv, enum iwl_pwr_src src)
+int iwl_set_pwr_src(struct iwl_priv *priv, enum iwl_pwr_src src)
 {
 	int ret;
 	unsigned long flags;
@@ -1282,7 +1282,7 @@ err:
 }
 
 /**
- * iwl4965_setup_rx_handlers - Initialize Rx handler callbacks
+ * iwl_setup_rx_handlers - Initialize Rx handler callbacks
  *
  * Setup the RX handlers for each of the reply types sent from the uCode
  * to the host.
@@ -1293,14 +1293,14 @@ err:
 static void iwl_setup_rx_handlers(struct iwl_priv *priv)
 {
 	priv->rx_handlers[REPLY_ALIVE] = iwl_rx_reply_alive;
-	priv->rx_handlers[REPLY_ERROR] = iwl4965_rx_reply_error;
-	priv->rx_handlers[CHANNEL_SWITCH_NOTIFICATION] = iwl4965_rx_csa;
+	priv->rx_handlers[REPLY_ERROR] = iwl_rx_reply_error;
+	priv->rx_handlers[CHANNEL_SWITCH_NOTIFICATION] = iwl_rx_csa;
 	priv->rx_handlers[SPECTRUM_MEASURE_NOTIFICATION] =
-	    iwl4965_rx_spectrum_measure_notif;
-	priv->rx_handlers[PM_SLEEP_NOTIFICATION] = iwl4965_rx_pm_sleep_notif;
+	    iwl_rx_spectrum_measure_notif;
+	priv->rx_handlers[PM_SLEEP_NOTIFICATION] = iwl_rx_pm_sleep_notif;
 	priv->rx_handlers[PM_DEBUG_STATISTIC_NOTIFIC] =
-	    iwl4965_rx_pm_debug_statistics_notif;
-	priv->rx_handlers[BEACON_NOTIFICATION] = iwl4965_rx_beacon_notif;
+	    iwl_rx_pm_debug_statistics_notif;
+	priv->rx_handlers[BEACON_NOTIFICATION] = iwl_rx_beacon_notif;
 
 	/*
 	 * The same handler is used for both the REPLY to a discrete
@@ -1313,7 +1313,7 @@ static void iwl_setup_rx_handlers(struct iwl_priv *priv)
 	iwl_setup_rx_scan_handlers(priv);
 
 	/* status change handler */
-	priv->rx_handlers[CARD_STATE_NOTIFICATION] = iwl4965_rx_card_state_notif;
+	priv->rx_handlers[CARD_STATE_NOTIFICATION] = iwl_rx_card_state_notif;
 
 	priv->rx_handlers[MISSED_BEACONS_NOTIFICATION] =
 	    iwl_rx_missed_beacon_notif;
@@ -1397,7 +1397,7 @@ void iwl_rx_handle(struct iwl_priv *priv)
 
 		/* Based on type of command response or notification,
 		 *   handle those that need handling via function in
-		 *   rx_handlers table.  See iwl4965_setup_rx_handlers() */
+		 *   rx_handlers table.  See iwl_setup_rx_handlers() */
 		if (priv->rx_handlers[pkt->hdr.cmd]) {
 			IWL_DEBUG(IWL_DL_RX, "r = %d, i = %d, %s, 0x%02x\n", r,
 				i, get_cmd_string(pkt->hdr.cmd), pkt->hdr.cmd);
@@ -1454,7 +1454,7 @@ void iwl_rx_handle(struct iwl_priv *priv)
 }
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-static void iwl4965_print_rx_config_cmd(struct iwl_priv *priv)
+static void iwl_print_rx_config_cmd(struct iwl_priv *priv)
 {
 	struct iwl_rxon_cmd *rxon = &priv->staging_rxon;
 	DECLARE_MAC_BUF(mac);
@@ -1477,7 +1477,7 @@ static void iwl4965_print_rx_config_cmd(struct iwl_priv *priv)
 }
 #endif
 
-static void iwl4965_enable_interrupts(struct iwl_priv *priv)
+static void iwl_enable_interrupts(struct iwl_priv *priv)
 {
 	IWL_DEBUG_ISR("Enabling interrupts\n");
 	set_bit(STATUS_INT_ENABLED, &priv->status);
@@ -1492,7 +1492,7 @@ static inline void iwl_synchronize_irq(struct iwl_priv *priv)
 	tasklet_kill(&priv->irq_tasklet);
 }
 
-static inline void iwl4965_disable_interrupts(struct iwl_priv *priv)
+static inline void iwl_disable_interrupts(struct iwl_priv *priv)
 {
 	clear_bit(STATUS_INT_ENABLED, &priv->status);
 
@@ -1508,11 +1508,11 @@ static inline void iwl4965_disable_interrupts(struct iwl_priv *priv)
 
 
 /**
- * iwl4965_irq_handle_error - called for HW or SW error interrupt from card
+ * iwl_irq_handle_error - called for HW or SW error interrupt from card
  */
-static void iwl4965_irq_handle_error(struct iwl_priv *priv)
+static void iwl_irq_handle_error(struct iwl_priv *priv)
 {
-	/* Set the FW error flag -- cleared on iwl4965_down */
+	/* Set the FW error flag -- cleared on iwl_down */
 	set_bit(STATUS_FW_ERROR, &priv->status);
 
 	/* Cancel currently queued command. */
@@ -1522,7 +1522,7 @@ static void iwl4965_irq_handle_error(struct iwl_priv *priv)
 	if (priv->debug_level & IWL_DL_FW_ERRORS) {
 		iwl_dump_nic_error_log(priv);
 		iwl_dump_nic_event_log(priv);
-		iwl4965_print_rx_config_cmd(priv);
+		iwl_print_rx_config_cmd(priv);
 	}
 #endif
 
@@ -1546,14 +1546,14 @@ static void iwl4965_irq_handle_error(struct iwl_priv *priv)
 	}
 }
 
-static void iwl4965_error_recovery(struct iwl_priv *priv)
+static void iwl_error_recovery(struct iwl_priv *priv)
 {
 	unsigned long flags;
 
 	memcpy(&priv->staging_rxon, &priv->recovery_rxon,
 	       sizeof(priv->staging_rxon));
 	priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-	iwl4965_commit_rxon(priv);
+	iwl_commit_rxon(priv);
 
 	iwl_rxon_add_station(priv, priv->bssid, 1);
 
@@ -1563,7 +1563,7 @@ static void iwl4965_error_recovery(struct iwl_priv *priv)
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
-static void iwl4965_irq_tasklet(struct iwl_priv *priv)
+static void iwl_irq_tasklet(struct iwl_priv *priv)
 {
 	u32 inta, handled = 0;
 	u32 inta_fh;
@@ -1609,9 +1609,9 @@ static void iwl4965_irq_tasklet(struct iwl_priv *priv)
 		IWL_ERROR("Microcode HW error detected.  Restarting.\n");
 
 		/* Tell the device to stop sending interrupts */
-		iwl4965_disable_interrupts(priv);
+		iwl_disable_interrupts(priv);
 
-		iwl4965_irq_handle_error(priv);
+		iwl_irq_handle_error(priv);
 
 		handled |= CSR_INT_BIT_HW_ERR;
 
@@ -1665,7 +1665,7 @@ static void iwl4965_irq_tasklet(struct iwl_priv *priv)
 	if (inta & CSR_INT_BIT_SW_ERR) {
 		IWL_ERROR("Microcode SW error detected.  Restarting 0x%X.\n",
 			  inta);
-		iwl4965_irq_handle_error(priv);
+		iwl_irq_handle_error(priv);
 		handled |= CSR_INT_BIT_SW_ERR;
 	}
 
@@ -1711,7 +1711,7 @@ static void iwl4965_irq_tasklet(struct iwl_priv *priv)
 	/* Re-enable all interrupts */
 	/* only Re-enable if diabled by irq */
 	if (test_bit(STATUS_INT_ENABLED, &priv->status))
-		iwl4965_enable_interrupts(priv);
+		iwl_enable_interrupts(priv);
 
 #ifdef CONFIG_IWLWIFI_DEBUG
 	if (priv->debug_level & (IWL_DL_ISR)) {
@@ -1725,7 +1725,7 @@ static void iwl4965_irq_tasklet(struct iwl_priv *priv)
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
-static irqreturn_t iwl4965_isr(int irq, void *data)
+static irqreturn_t iwl_isr(int irq, void *data)
 {
 	struct iwl_priv *priv = data;
 	u32 inta, inta_mask;
@@ -1766,7 +1766,7 @@ static irqreturn_t iwl4965_isr(int irq, void *data)
 
 	inta &= ~CSR_INT_BIT_SCD;
 
-	/* iwl4965_irq_tasklet() will service interrupts and re-enable them */
+	/* iwl_irq_tasklet() will service interrupts and re-enable them */
 	if (likely(inta || inta_fh))
 		tasklet_schedule(&priv->irq_tasklet);
 
@@ -1778,7 +1778,7 @@ static irqreturn_t iwl4965_isr(int irq, void *data)
 	/* re-enable interrupts here since we don't have anything to service. */
 	/* only Re-enable if diabled by irq */
 	if (test_bit(STATUS_INT_ENABLED, &priv->status))
-		iwl4965_enable_interrupts(priv);
+		iwl_enable_interrupts(priv);
 	spin_unlock(&priv->lock);
 	return IRQ_NONE;
 }
@@ -1789,7 +1789,7 @@ static irqreturn_t iwl4965_isr(int irq, void *data)
  *
  ******************************************************************************/
 
-static void iwl4965_dealloc_ucode_pci(struct iwl_priv *priv)
+static void iwl_dealloc_ucode_pci(struct iwl_priv *priv)
 {
 	iwl_free_fw_desc(priv->pci_dev, &priv->ucode_code);
 	iwl_free_fw_desc(priv->pci_dev, &priv->ucode_data);
@@ -1799,7 +1799,7 @@ static void iwl4965_dealloc_ucode_pci(struct iwl_priv *priv)
 	iwl_free_fw_desc(priv->pci_dev, &priv->ucode_boot);
 }
 
-static void iwl4965_nic_start(struct iwl_priv *priv)
+static void iwl_nic_start(struct iwl_priv *priv)
 {
 	/* Remove all resets to allow NIC to operate */
 	iwl_write32(priv, CSR_RESET, 0);
@@ -1807,11 +1807,11 @@ static void iwl4965_nic_start(struct iwl_priv *priv)
 
 
 /**
- * iwl4965_read_ucode - Read uCode images from disk file.
+ * iwl_read_ucode - Read uCode images from disk file.
  *
  * Copy into buffers for card to fetch via bus-mastering
  */
-static int iwl4965_read_ucode(struct iwl_priv *priv)
+static int iwl_read_ucode(struct iwl_priv *priv)
 {
 	struct iwl_ucode *ucode;
 	int ret;
@@ -1955,7 +1955,7 @@ static int iwl4965_read_ucode(struct iwl_priv *priv)
 		priv->ucode_code.v_addr, (u32)priv->ucode_code.p_addr);
 
 	/* Runtime data (2nd block)
-	 * NOTE:  Copy into backup buffer will be done in iwl4965_up()  */
+	 * NOTE:  Copy into backup buffer will be done in iwl_up()  */
 	src = &ucode->data[inst_size];
 	len = priv->ucode_data.len;
 	IWL_DEBUG_INFO("Copying (but not loading) uCode data len %Zd\n", len);
@@ -1993,7 +1993,7 @@ static int iwl4965_read_ucode(struct iwl_priv *priv)
  err_pci_alloc:
 	IWL_ERROR("failed to allocate pci memory\n");
 	ret = -ENOMEM;
-	iwl4965_dealloc_ucode_pci(priv);
+	iwl_dealloc_ucode_pci(priv);
 
  err_release:
 	release_firmware(ucode_raw);
@@ -2038,7 +2038,7 @@ static void iwl_alive_start(struct iwl_priv *priv)
 		goto restart;
 	}
 
-	/* After the ALIVE response, we can send host commands to 4965 uCode */
+	/* After the ALIVE response, we can send host commands to the uCode */
 	set_bit(STATUS_ALIVE, &priv->status);
 
 	if (iwl_is_rfkill(priv))
@@ -2058,17 +2058,17 @@ static void iwl_alive_start(struct iwl_priv *priv)
 		active_rxon->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 	} else {
 		/* Initialize our rx_config data */
-		iwl4965_connection_init_rx_config(priv, priv->iw_mode);
+		iwl_connection_init_rx_config(priv, priv->iw_mode);
 		memcpy(priv->staging_rxon.node_addr, priv->mac_addr, ETH_ALEN);
 	}
 
 	/* Configure Bluetooth device coexistence support */
-	iwl4965_send_bt_config(priv);
+	iwl_send_bt_config(priv);
 
 	iwl_reset_run_time_calib(priv);
 
 	/* Configure the adapter for unassociated operation */
-	iwl4965_commit_rxon(priv);
+	iwl_commit_rxon(priv);
 
 	/* At this point, the NIC is initialized and operational */
 	iwl_rf_kill_ct_config(priv);
@@ -2080,13 +2080,13 @@ static void iwl_alive_start(struct iwl_priv *priv)
 	wake_up_interruptible(&priv->wait_command_queue);
 
 	if (priv->error_recovering)
-		iwl4965_error_recovery(priv);
+		iwl_error_recovery(priv);
 
 	iwl_power_update_mode(priv, 1);
 	ieee80211_notify_mac(priv->hw, IEEE80211_NOTIFY_RE_ASSOC);
 
 	if (test_and_clear_bit(STATUS_MODE_PENDING, &priv->status))
-		iwl4965_set_mode(priv, priv->iw_mode);
+		iwl_set_mode(priv, priv->iw_mode);
 
 	return;
 
@@ -2096,7 +2096,7 @@ static void iwl_alive_start(struct iwl_priv *priv)
 
 static void iwl_cancel_deferred_work(struct iwl_priv *priv);
 
-static void __iwl4965_down(struct iwl_priv *priv)
+static void __iwl_down(struct iwl_priv *priv)
 {
 	unsigned long flags;
 	int exit_pending = test_bit(STATUS_EXIT_PENDING, &priv->status);
@@ -2123,14 +2123,14 @@ static void __iwl4965_down(struct iwl_priv *priv)
 
 	/* tell the device to stop sending interrupts */
 	spin_lock_irqsave(&priv->lock, flags);
-	iwl4965_disable_interrupts(priv);
+	iwl_disable_interrupts(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 	iwl_synchronize_irq(priv);
 
 	if (priv->mac80211_registered)
 		ieee80211_stop_queues(priv->hw);
 
-	/* If we have not previously called iwl4965_init() then
+	/* If we have not previously called iwl_init() then
 	 * clear all bits but the RF Kill and SUSPEND bits and return */
 	if (!iwl_is_init(priv)) {
 		priv->status = test_bit(STATUS_RF_KILL_HW, &priv->status) <<
@@ -2197,10 +2197,10 @@ static void __iwl4965_down(struct iwl_priv *priv)
 	iwl_clear_free_frames(priv);
 }
 
-static void iwl4965_down(struct iwl_priv *priv)
+static void iwl_down(struct iwl_priv *priv)
 {
 	mutex_lock(&priv->mutex);
-	__iwl4965_down(priv);
+	__iwl_down(priv);
 	mutex_unlock(&priv->mutex);
 
 	iwl_cancel_deferred_work(priv);
@@ -2208,7 +2208,7 @@ static void iwl4965_down(struct iwl_priv *priv)
 
 #define MAX_HW_RESTARTS 5
 
-static int __iwl4965_up(struct iwl_priv *priv)
+static int __iwl_up(struct iwl_priv *priv)
 {
 	int i;
 	int ret;
@@ -2230,7 +2230,7 @@ static int __iwl4965_up(struct iwl_priv *priv)
 		set_bit(STATUS_RF_KILL_HW, &priv->status);
 
 	if (iwl_is_rfkill(priv)) {
-		iwl4965_enable_interrupts(priv);
+		iwl_enable_interrupts(priv);
 		IWL_WARNING("Radio disabled by %s RF Kill switch\n",
 		    test_bit(STATUS_RF_KILL_HW, &priv->status) ? "HW" : "SW");
 		return 0;
@@ -2257,7 +2257,7 @@ static int __iwl4965_up(struct iwl_priv *priv)
 
 	/* clear (again), then enable host interrupts */
 	iwl_write32(priv, CSR_INT, 0xFFFFFFFF);
-	iwl4965_enable_interrupts(priv);
+	iwl_enable_interrupts(priv);
 
 	/* really make sure rfkill handshake bits are cleared */
 	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
@@ -2287,7 +2287,7 @@ static int __iwl4965_up(struct iwl_priv *priv)
 		clear_bit(STATUS_FW_ERROR, &priv->status);
 
 		/* start card; "initialize" will load runtime ucode */
-		iwl4965_nic_start(priv);
+		iwl_nic_start(priv);
 
 		IWL_DEBUG_INFO(DRV_NAME " is coming up\n");
 
@@ -2295,7 +2295,7 @@ static int __iwl4965_up(struct iwl_priv *priv)
 	}
 
 	set_bit(STATUS_EXIT_PENDING, &priv->status);
-	__iwl4965_down(priv);
+	__iwl_down(priv);
 	clear_bit(STATUS_EXIT_PENDING, &priv->status);
 
 	/* tried to restart and config the device for as long as our
@@ -2337,7 +2337,7 @@ static void iwl_bg_alive_start(struct work_struct *data)
 	mutex_unlock(&priv->mutex);
 }
 
-static void iwl4965_bg_rf_kill(struct work_struct *work)
+static void iwl_bg_rf_kill(struct work_struct *work)
 {
 	struct iwl_priv *priv = container_of(work, struct iwl_priv, rf_kill);
 
@@ -2371,7 +2371,7 @@ static void iwl4965_bg_rf_kill(struct work_struct *work)
 	iwl_rfkill_set_hw_state(priv);
 }
 
-static void iwl4965_bg_set_monitor(struct work_struct *work)
+static void iwl_bg_set_monitor(struct work_struct *work)
 {
 	struct iwl_priv *priv = container_of(work,
 				struct iwl_priv, set_monitor);
@@ -2381,12 +2381,12 @@ static void iwl4965_bg_set_monitor(struct work_struct *work)
 
 	mutex_lock(&priv->mutex);
 
-	ret = iwl4965_set_mode(priv, NL80211_IFTYPE_MONITOR);
+	ret = iwl_set_mode(priv, NL80211_IFTYPE_MONITOR);
 	if (ret) {
 		if (ret == -EAGAIN)
 			IWL_DEBUG(IWL_DL_STATE, "leave - not ready\n");
 		else
-			IWL_ERROR("iwl4965_set_mode() failed ret = %d\n", ret);
+			IWL_ERROR("iwl_set_mode() failed ret = %d\n", ret);
 	}
 
 	mutex_unlock(&priv->mutex);
@@ -2416,7 +2416,7 @@ static void iwl_bg_run_time_calib_work(struct work_struct *work)
 	return;
 }
 
-static void iwl4965_bg_up(struct work_struct *data)
+static void iwl_bg_up(struct work_struct *data)
 {
 	struct iwl_priv *priv = container_of(data, struct iwl_priv, up);
 
@@ -2424,23 +2424,23 @@ static void iwl4965_bg_up(struct work_struct *data)
 		return;
 
 	mutex_lock(&priv->mutex);
-	__iwl4965_up(priv);
+	__iwl_up(priv);
 	mutex_unlock(&priv->mutex);
 	iwl_rfkill_set_hw_state(priv);
 }
 
-static void iwl4965_bg_restart(struct work_struct *data)
+static void iwl_bg_restart(struct work_struct *data)
 {
 	struct iwl_priv *priv = container_of(data, struct iwl_priv, restart);
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
-	iwl4965_down(priv);
+	iwl_down(priv);
 	queue_work(priv->workqueue, &priv->up);
 }
 
-static void iwl4965_bg_rx_replenish(struct work_struct *data)
+static void iwl_bg_rx_replenish(struct work_struct *data)
 {
 	struct iwl_priv *priv =
 	    container_of(data, struct iwl_priv, rx_replenish);
@@ -2455,7 +2455,7 @@ static void iwl4965_bg_rx_replenish(struct work_struct *data)
 
 #define IWL_DELAY_NEXT_SCAN (HZ*2)
 
-static void iwl4965_post_associate(struct iwl_priv *priv)
+static void iwl_post_associate(struct iwl_priv *priv)
 {
 	struct ieee80211_conf *conf = NULL;
 	int ret = 0;
@@ -2485,7 +2485,7 @@ static void iwl4965_post_associate(struct iwl_priv *priv)
 	conf = ieee80211_get_hw_conf(priv->hw);
 
 	priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-	iwl4965_commit_rxon(priv);
+	iwl_commit_rxon(priv);
 
 	iwl_setup_rxon_timing(priv);
 	ret = iwl_send_cmd_pdu(priv, REPLY_RXON_TIMING,
@@ -2520,7 +2520,7 @@ static void iwl4965_post_associate(struct iwl_priv *priv)
 
 	}
 
-	iwl4965_commit_rxon(priv);
+	iwl_commit_rxon(priv);
 
 	switch (priv->iw_mode) {
 	case NL80211_IFTYPE_STATION:
@@ -2532,7 +2532,7 @@ static void iwl4965_post_associate(struct iwl_priv *priv)
 		priv->assoc_id = 1;
 
 		iwl_rxon_add_station(priv, priv->bssid, 0);
-		iwl4965_send_beacon_cmd(priv);
+		iwl_send_beacon_cmd(priv);
 
 		break;
 
@@ -2569,7 +2569,7 @@ static void iwl4965_post_associate(struct iwl_priv *priv)
 
 #define UCODE_READY_TIMEOUT	(4 * HZ)
 
-static int iwl4965_mac_start(struct ieee80211_hw *hw)
+static int iwl_mac_start(struct ieee80211_hw *hw)
 {
 	struct iwl_priv *priv = hw->priv;
 	int ret;
@@ -2591,7 +2591,7 @@ static int iwl4965_mac_start(struct ieee80211_hw *hw)
 		pci_write_config_word(priv->pci_dev, PCI_COMMAND, pci_cmd);
 	}
 
-	ret = request_irq(priv->pci_dev->irq, iwl4965_isr, IRQF_SHARED,
+	ret = request_irq(priv->pci_dev->irq, iwl_isr, IRQF_SHARED,
 			  DRV_NAME, priv);
 	if (ret) {
 		IWL_ERROR("Error allocating IRQ %d\n", priv->pci_dev->irq);
@@ -2606,7 +2606,7 @@ static int iwl4965_mac_start(struct ieee80211_hw *hw)
 	 * ucode filename and max sizes are card-specific. */
 
 	if (!priv->ucode_code.len) {
-		ret = iwl4965_read_ucode(priv);
+		ret = iwl_read_ucode(priv);
 		if (ret) {
 			IWL_ERROR("Could not read microcode: %d\n", ret);
 			mutex_unlock(&priv->mutex);
@@ -2614,7 +2614,7 @@ static int iwl4965_mac_start(struct ieee80211_hw *hw)
 		}
 	}
 
-	ret = __iwl4965_up(priv);
+	ret = __iwl_up(priv);
 
 	mutex_unlock(&priv->mutex);
 
@@ -2660,7 +2660,7 @@ out_disable_msi:
 	return ret;
 }
 
-static void iwl4965_mac_stop(struct ieee80211_hw *hw)
+static void iwl_mac_stop(struct ieee80211_hw *hw)
 {
 	struct iwl_priv *priv = hw->priv;
 
@@ -2682,7 +2682,7 @@ static void iwl4965_mac_stop(struct ieee80211_hw *hw)
 		mutex_unlock(&priv->mutex);
 	}
 
-	iwl4965_down(priv);
+	iwl_down(priv);
 
 	flush_workqueue(priv->workqueue);
 	free_irq(priv->pci_dev->irq, priv);
@@ -2693,7 +2693,7 @@ static void iwl4965_mac_stop(struct ieee80211_hw *hw)
 	IWL_DEBUG_MAC80211("leave\n");
 }
 
-static int iwl4965_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
+static int iwl_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct iwl_priv *priv = hw->priv;
 
@@ -2709,7 +2709,7 @@ static int iwl4965_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	return 0;
 }
 
-static int iwl4965_mac_add_interface(struct ieee80211_hw *hw,
+static int iwl_mac_add_interface(struct ieee80211_hw *hw,
 				 struct ieee80211_if_init_conf *conf)
 {
 	struct iwl_priv *priv = hw->priv;
@@ -2736,7 +2736,7 @@ static int iwl4965_mac_add_interface(struct ieee80211_hw *hw,
 		memcpy(priv->mac_addr, conf->mac_addr, ETH_ALEN);
 	}
 
-	if (iwl4965_set_mode(priv, conf->type) == -EAGAIN)
+	if (iwl_set_mode(priv, conf->type) == -EAGAIN)
 		/* we are not ready, will run again when ready */
 		set_bit(STATUS_MODE_PENDING, &priv->status);
 
@@ -2747,13 +2747,13 @@ static int iwl4965_mac_add_interface(struct ieee80211_hw *hw,
 }
 
 /**
- * iwl4965_mac_config - mac80211 config callback
+ * iwl_mac_config - mac80211 config callback
  *
  * We ignore conf->flags & IEEE80211_CONF_SHORT_SLOT_TIME since it seems to
  * be set inappropriately and the driver currently sets the hardware up to
  * use it whenever needed.
  */
-static int iwl4965_mac_config(struct ieee80211_hw *hw, u32 changed)
+static int iwl_mac_config(struct ieee80211_hw *hw, u32 changed)
 {
 	struct iwl_priv *priv = hw->priv;
 	const struct iwl_channel_info *ch_info;
@@ -2824,13 +2824,13 @@ static int iwl4965_mac_config(struct ieee80211_hw *hw, u32 changed)
 	/* The list of supported rates and rate mask can be different
 	 * for each band; since the band may have changed, reset
 	 * the rate mask to what mac80211 lists */
-	iwl4965_set_rate(priv);
+	iwl_set_rate(priv);
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 #ifdef IEEE80211_CONF_CHANNEL_SWITCH
 	if (conf->flags & IEEE80211_CONF_CHANNEL_SWITCH) {
-		iwl4965_hw_channel_switch(priv, conf->channel);
+		iwl_hw_channel_switch(priv, conf->channel);
 		goto out;
 	}
 #endif
@@ -2858,11 +2858,11 @@ static int iwl4965_mac_config(struct ieee80211_hw *hw, u32 changed)
 
 	iwl_set_tx_power(priv, conf->power_level, false);
 
-	iwl4965_set_rate(priv);
+	iwl_set_rate(priv);
 
 	if (memcmp(&priv->active_rxon,
 		   &priv->staging_rxon, sizeof(priv->staging_rxon)))
-		iwl4965_commit_rxon(priv);
+		iwl_commit_rxon(priv);
 	else
 		IWL_DEBUG_INFO("No re-sending same RXON configuration.\n");
 
@@ -2873,7 +2873,7 @@ out:
 	return ret;
 }
 
-static void iwl4965_config_ap(struct iwl_priv *priv)
+static void iwl_config_ap(struct iwl_priv *priv)
 {
 	int ret = 0;
 	unsigned long flags;
@@ -2886,7 +2886,7 @@ static void iwl4965_config_ap(struct iwl_priv *priv)
 
 		/* RXON - unassoc (to set timing command) */
 		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-		iwl4965_commit_rxon(priv);
+		iwl_commit_rxon(priv);
 
 		/* RXON Timing */
 		iwl_setup_rxon_timing(priv);
@@ -2922,13 +2922,13 @@ static void iwl4965_config_ap(struct iwl_priv *priv)
 		}
 		/* restore RXON assoc */
 		priv->staging_rxon.filter_flags |= RXON_FILTER_ASSOC_MSK;
-		iwl4965_commit_rxon(priv);
+		iwl_commit_rxon(priv);
 		spin_lock_irqsave(&priv->lock, flags);
 		iwl_activate_qos(priv, 1);
 		spin_unlock_irqrestore(&priv->lock, flags);
 		iwl_rxon_add_station(priv, iwl_bcast_addr, 0);
 	}
-	iwl4965_send_beacon_cmd(priv);
+	iwl_send_beacon_cmd(priv);
 
 	/* FIXME - we need to add code here to detect a totally new
 	 * configuration, reset the AP, unassoc, rxon timing, assoc,
@@ -2936,9 +2936,9 @@ static void iwl4965_config_ap(struct iwl_priv *priv)
 }
 
 /* temporary */
-static int iwl4965_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb);
+static int iwl_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb);
 
-static int iwl4965_mac_config_interface(struct ieee80211_hw *hw,
+static int iwl_mac_config_interface(struct ieee80211_hw *hw,
 					struct ieee80211_vif *vif,
 				    struct ieee80211_if_conf *conf)
 {
@@ -2960,7 +2960,7 @@ static int iwl4965_mac_config_interface(struct ieee80211_hw *hw,
 		struct sk_buff *beacon = ieee80211_beacon_get(hw, vif);
 		if (!beacon)
 			return -ENOMEM;
-		rc = iwl4965_mac_beacon_update(hw, beacon);
+		rc = iwl_mac_beacon_update(hw, beacon);
 		if (rc)
 			return rc;
 	}
@@ -3024,9 +3024,9 @@ static int iwl4965_mac_config_interface(struct ieee80211_hw *hw,
 		memcpy(priv->bssid, conf->bssid, ETH_ALEN);
 
 		if (priv->iw_mode == NL80211_IFTYPE_AP)
-			iwl4965_config_ap(priv);
+			iwl_config_ap(priv);
 		else {
-			rc = iwl4965_commit_rxon(priv);
+			rc = iwl_commit_rxon(priv);
 			if ((priv->iw_mode == NL80211_IFTYPE_STATION) && rc)
 				iwl_rxon_add_station(
 					priv, priv->active_rxon.bssid_addr, 1);
@@ -3035,7 +3035,7 @@ static int iwl4965_mac_config_interface(struct ieee80211_hw *hw,
 	} else {
 		iwl_scan_cancel_timeout(priv, 100);
 		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-		iwl4965_commit_rxon(priv);
+		iwl_commit_rxon(priv);
 	}
 
  done:
@@ -3054,7 +3054,7 @@ static int iwl4965_mac_config_interface(struct ieee80211_hw *hw,
 	return 0;
 }
 
-static void iwl4965_configure_filter(struct ieee80211_hw *hw,
+static void iwl_configure_filter(struct ieee80211_hw *hw,
 				 unsigned int changed_flags,
 				 unsigned int *total_flags,
 				 int mc_count, struct dev_addr_list *mc_list)
@@ -3073,7 +3073,7 @@ static void iwl4965_configure_filter(struct ieee80211_hw *hw,
 			FIF_BCN_PRBRESP_PROMISC | FIF_CONTROL;
 }
 
-static void iwl4965_mac_remove_interface(struct ieee80211_hw *hw,
+static void iwl_mac_remove_interface(struct ieee80211_hw *hw,
 				     struct ieee80211_if_init_conf *conf)
 {
 	struct iwl_priv *priv = hw->priv;
@@ -3085,7 +3085,7 @@ static void iwl4965_mac_remove_interface(struct ieee80211_hw *hw,
 	if (iwl_is_ready_rf(priv)) {
 		iwl_scan_cancel_timeout(priv, 100);
 		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-		iwl4965_commit_rxon(priv);
+		iwl_commit_rxon(priv);
 	}
 	if (priv->vif == conf->vif) {
 		priv->vif = NULL;
@@ -3100,7 +3100,7 @@ static void iwl4965_mac_remove_interface(struct ieee80211_hw *hw,
 }
 
 #define IWL_DELAY_NEXT_SCAN_AFTER_ASSOC (HZ*6)
-static void iwl4965_bss_info_changed(struct ieee80211_hw *hw,
+static void iwl_bss_info_changed(struct ieee80211_hw *hw,
 				     struct ieee80211_vif *vif,
 				     struct ieee80211_bss_conf *bss_conf,
 				     u32 changes)
@@ -3127,7 +3127,7 @@ static void iwl4965_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	if (changes & BSS_CHANGED_HT) {
-		iwl4965_ht_conf(priv, bss_conf);
+		iwl_ht_conf(priv, bss_conf);
 		iwl_set_rxon_chain(priv);
 	}
 
@@ -3150,7 +3150,7 @@ static void iwl4965_bss_info_changed(struct ieee80211_hw *hw,
 			priv->next_scan_jiffies = jiffies +
 					IWL_DELAY_NEXT_SCAN_AFTER_ASSOC;
 			mutex_lock(&priv->mutex);
-			iwl4965_post_associate(priv);
+			iwl_post_associate(priv);
 			mutex_unlock(&priv->mutex);
 		} else {
 			priv->assoc_id = 0;
@@ -3226,7 +3226,7 @@ out_unlock:
 	return ret;
 }
 
-static void iwl4965_mac_update_tkip_key(struct ieee80211_hw *hw,
+static void iwl_mac_update_tkip_key(struct ieee80211_hw *hw,
 			struct ieee80211_key_conf *keyconf, const u8 *addr,
 			u32 iv32, u16 *phase1key)
 {
@@ -3274,7 +3274,7 @@ static void iwl4965_mac_update_tkip_key(struct ieee80211_hw *hw,
 	IWL_DEBUG_MAC80211("leave\n");
 }
 
-static int iwl4965_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
+static int iwl_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			   const u8 *local_addr, const u8 *addr,
 			   struct ieee80211_key_conf *key)
 {
@@ -3346,7 +3346,7 @@ static int iwl4965_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	return ret;
 }
 
-static int iwl4965_mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
+static int iwl_mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
 			   const struct ieee80211_tx_queue_params *params)
 {
 	struct iwl_priv *priv = hw->priv;
@@ -3394,7 +3394,7 @@ static int iwl4965_mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
 	return 0;
 }
 
-static int iwl4965_mac_ampdu_action(struct ieee80211_hw *hw,
+static int iwl_mac_ampdu_action(struct ieee80211_hw *hw,
 			     enum ieee80211_ampdu_mlme_action action,
 			     struct ieee80211_sta *sta, u16 tid, u16 *ssn)
 {
@@ -3427,7 +3427,7 @@ static int iwl4965_mac_ampdu_action(struct ieee80211_hw *hw,
 	}
 	return 0;
 }
-static int iwl4965_mac_get_tx_stats(struct ieee80211_hw *hw,
+static int iwl_mac_get_tx_stats(struct ieee80211_hw *hw,
 				struct ieee80211_tx_queue_stats *stats)
 {
 	struct iwl_priv *priv = hw->priv;
@@ -3462,7 +3462,7 @@ static int iwl4965_mac_get_tx_stats(struct ieee80211_hw *hw,
 	return 0;
 }
 
-static int iwl4965_mac_get_stats(struct ieee80211_hw *hw,
+static int iwl_mac_get_stats(struct ieee80211_hw *hw,
 			     struct ieee80211_low_level_stats *stats)
 {
 	struct iwl_priv *priv = hw->priv;
@@ -3474,7 +3474,7 @@ static int iwl4965_mac_get_stats(struct ieee80211_hw *hw,
 	return 0;
 }
 
-static void iwl4965_mac_reset_tsf(struct ieee80211_hw *hw)
+static void iwl_mac_reset_tsf(struct ieee80211_hw *hw)
 {
 	struct iwl_priv *priv = hw->priv;
 	unsigned long flags;
@@ -3518,7 +3518,7 @@ static void iwl4965_mac_reset_tsf(struct ieee80211_hw *hw)
 	if (priv->iw_mode != NL80211_IFTYPE_AP) {
 		iwl_scan_cancel_timeout(priv, 100);
 		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-		iwl4965_commit_rxon(priv);
+		iwl_commit_rxon(priv);
 	}
 
 	iwl_power_update_mode(priv, 0);
@@ -3541,14 +3541,14 @@ static void iwl4965_mac_reset_tsf(struct ieee80211_hw *hw)
 		return;
 	}
 
-	iwl4965_set_rate(priv);
+	iwl_set_rate(priv);
 
 	mutex_unlock(&priv->mutex);
 
 	IWL_DEBUG_MAC80211("leave\n");
 }
 
-static int iwl4965_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
+static int iwl_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct iwl_priv *priv = hw->priv;
 	unsigned long flags;
@@ -3585,7 +3585,7 @@ static int iwl4965_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *sk
 
 	iwl_reset_qos(priv);
 
-	iwl4965_post_associate(priv);
+	iwl_post_associate(priv);
 
 	mutex_unlock(&priv->mutex);
 
@@ -3739,7 +3739,7 @@ static ssize_t store_flags(struct device *d,
 		else {
 			IWL_DEBUG_INFO("Commit rxon.flags = 0x%04X\n", flags);
 			priv->staging_rxon.flags = cpu_to_le32(flags);
-			iwl4965_commit_rxon(priv);
+			iwl_commit_rxon(priv);
 		}
 	}
 	mutex_unlock(&priv->mutex);
@@ -3780,7 +3780,7 @@ static ssize_t store_filter_flags(struct device *d,
 				       "0x%04X\n", filter_flags);
 			priv->staging_rxon.filter_flags =
 				cpu_to_le32(filter_flags);
-			iwl4965_commit_rxon(priv);
+			iwl_commit_rxon(priv);
 		}
 	}
 	mutex_unlock(&priv->mutex);
@@ -3855,7 +3855,7 @@ static ssize_t store_measurement(struct device *d,
 
 	IWL_DEBUG_INFO("Invoking measurement of type %d on "
 		       "channel %d (for '%s')\n", type, params.channel, buf);
-	iwl4965_get_measurement(priv, &params, type);
+	iwl_get_measurement(priv, &params, type);
 
 	return count;
 }
@@ -4075,12 +4075,12 @@ static void iwl_setup_deferred_work(struct iwl_priv *priv)
 
 	init_waitqueue_head(&priv->wait_command_queue);
 
-	INIT_WORK(&priv->up, iwl4965_bg_up);
-	INIT_WORK(&priv->restart, iwl4965_bg_restart);
-	INIT_WORK(&priv->rx_replenish, iwl4965_bg_rx_replenish);
-	INIT_WORK(&priv->rf_kill, iwl4965_bg_rf_kill);
-	INIT_WORK(&priv->beacon_update, iwl4965_bg_beacon_update);
-	INIT_WORK(&priv->set_monitor, iwl4965_bg_set_monitor);
+	INIT_WORK(&priv->up, iwl_bg_up);
+	INIT_WORK(&priv->restart, iwl_bg_restart);
+	INIT_WORK(&priv->rx_replenish, iwl_bg_rx_replenish);
+	INIT_WORK(&priv->rf_kill, iwl_bg_rf_kill);
+	INIT_WORK(&priv->beacon_update, iwl_bg_beacon_update);
+	INIT_WORK(&priv->set_monitor, iwl_bg_set_monitor);
 	INIT_WORK(&priv->run_time_calib_work, iwl_bg_run_time_calib_work);
 	INIT_DELAYED_WORK(&priv->init_alive_start, iwl_bg_init_alive_start);
 	INIT_DELAYED_WORK(&priv->alive_start, iwl_bg_alive_start);
@@ -4093,10 +4093,10 @@ static void iwl_setup_deferred_work(struct iwl_priv *priv)
 
 	init_timer(&priv->statistics_periodic);
 	priv->statistics_periodic.data = (unsigned long)priv;
-	priv->statistics_periodic.function = iwl4965_bg_statistics_periodic;
+	priv->statistics_periodic.function = iwl_bg_statistics_periodic;
 
 	tasklet_init(&priv->irq_tasklet, (void (*)(unsigned long))
-		     iwl4965_irq_tasklet, (unsigned long)priv);
+		     iwl_irq_tasklet, (unsigned long)priv);
 }
 
 static void iwl_cancel_deferred_work(struct iwl_priv *priv)
@@ -4112,7 +4112,7 @@ static void iwl_cancel_deferred_work(struct iwl_priv *priv)
 	del_timer_sync(&priv->statistics_periodic);
 }
 
-static struct attribute *iwl4965_sysfs_entries[] = {
+static struct attribute *iwl_sysfs_entries[] = {
 	&dev_attr_channels.attr,
 	&dev_attr_flags.attr,
 	&dev_attr_filter_flags.attr,
@@ -4133,32 +4133,32 @@ static struct attribute *iwl4965_sysfs_entries[] = {
 	NULL
 };
 
-static struct attribute_group iwl4965_attribute_group = {
+static struct attribute_group iwl_attribute_group = {
 	.name = NULL,		/* put in device directory */
-	.attrs = iwl4965_sysfs_entries,
+	.attrs = iwl_sysfs_entries,
 };
 
-static struct ieee80211_ops iwl4965_hw_ops = {
-	.tx = iwl4965_mac_tx,
-	.start = iwl4965_mac_start,
-	.stop = iwl4965_mac_stop,
-	.add_interface = iwl4965_mac_add_interface,
-	.remove_interface = iwl4965_mac_remove_interface,
-	.config = iwl4965_mac_config,
-	.config_interface = iwl4965_mac_config_interface,
-	.configure_filter = iwl4965_configure_filter,
-	.set_key = iwl4965_mac_set_key,
-	.update_tkip_key = iwl4965_mac_update_tkip_key,
-	.get_stats = iwl4965_mac_get_stats,
-	.get_tx_stats = iwl4965_mac_get_tx_stats,
-	.conf_tx = iwl4965_mac_conf_tx,
-	.reset_tsf = iwl4965_mac_reset_tsf,
-	.bss_info_changed = iwl4965_bss_info_changed,
-	.ampdu_action = iwl4965_mac_ampdu_action,
+static struct ieee80211_ops iwl_hw_ops = {
+	.tx = iwl_mac_tx,
+	.start = iwl_mac_start,
+	.stop = iwl_mac_stop,
+	.add_interface = iwl_mac_add_interface,
+	.remove_interface = iwl_mac_remove_interface,
+	.config = iwl_mac_config,
+	.config_interface = iwl_mac_config_interface,
+	.configure_filter = iwl_configure_filter,
+	.set_key = iwl_mac_set_key,
+	.update_tkip_key = iwl_mac_update_tkip_key,
+	.get_stats = iwl_mac_get_stats,
+	.get_tx_stats = iwl_mac_get_tx_stats,
+	.conf_tx = iwl_mac_conf_tx,
+	.reset_tsf = iwl_mac_reset_tsf,
+	.bss_info_changed = iwl_bss_info_changed,
+	.ampdu_action = iwl_mac_ampdu_action,
 	.hw_scan = iwl_mac_hw_scan
 };
 
-static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
+static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	int err = 0;
 	struct iwl_priv *priv;
@@ -4177,10 +4177,10 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 		if (cfg->mod_params->debug & IWL_DL_INFO)
 			dev_printk(KERN_DEBUG, &(pdev->dev),
 				   "Disabling hw_scan\n");
-		iwl4965_hw_ops.hw_scan = NULL;
+		iwl_hw_ops.hw_scan = NULL;
 	}
 
-	hw = iwl_alloc_all(cfg, &iwl4965_hw_ops);
+	hw = iwl_alloc_all(cfg, &iwl_hw_ops);
 	if (!hw) {
 		err = -ENOMEM;
 		goto out;
@@ -4308,10 +4308,10 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	 * 8. Setup services
 	 ********************/
 	spin_lock_irqsave(&priv->lock, flags);
-	iwl4965_disable_interrupts(priv);
+	iwl_disable_interrupts(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	err = sysfs_create_group(&pdev->dev.kobj, &iwl4965_attribute_group);
+	err = sysfs_create_group(&pdev->dev.kobj, &iwl_attribute_group);
 	if (err) {
 		IWL_ERROR("failed to create sysfs device attributes\n");
 		goto out_uninit_drv;
@@ -4347,7 +4347,7 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	return 0;
 
  out_remove_sysfs:
-	sysfs_remove_group(&pdev->dev.kobj, &iwl4965_attribute_group);
+	sysfs_remove_group(&pdev->dev.kobj, &iwl_attribute_group);
  out_uninit_drv:
 	iwl_uninit_drv(priv);
  out_free_eeprom:
@@ -4365,7 +4365,7 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	return err;
 }
 
-static void __devexit iwl4965_pci_remove(struct pci_dev *pdev)
+static void __devexit iwl_pci_remove(struct pci_dev *pdev)
 {
 	struct iwl_priv *priv = pci_get_drvdata(pdev);
 	unsigned long flags;
@@ -4376,10 +4376,10 @@ static void __devexit iwl4965_pci_remove(struct pci_dev *pdev)
 	IWL_DEBUG_INFO("*** UNLOAD DRIVER ***\n");
 
 	iwl_dbgfs_unregister(priv);
-	sysfs_remove_group(&pdev->dev.kobj, &iwl4965_attribute_group);
+	sysfs_remove_group(&pdev->dev.kobj, &iwl_attribute_group);
 
-	/* ieee80211_unregister_hw call wil cause iwl4965_mac_stop to
-	 * to be called and iwl4965_down since we are removing the device
+	/* ieee80211_unregister_hw call wil cause iwl_mac_stop to
+	 * to be called and iwl_down since we are removing the device
 	 * we need to set STATUS_EXIT_PENDING bit.
 	 */
 	set_bit(STATUS_EXIT_PENDING, &priv->status);
@@ -4387,20 +4387,20 @@ static void __devexit iwl4965_pci_remove(struct pci_dev *pdev)
 		ieee80211_unregister_hw(priv->hw);
 		priv->mac80211_registered = 0;
 	} else {
-		iwl4965_down(priv);
+		iwl_down(priv);
 	}
 
 	/* make sure we flush any pending irq or
 	 * tasklet for the driver
 	 */
 	spin_lock_irqsave(&priv->lock, flags);
-	iwl4965_disable_interrupts(priv);
+	iwl_disable_interrupts(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	iwl_synchronize_irq(priv);
 
 	iwl_rfkill_unregister(priv);
-	iwl4965_dealloc_ucode_pci(priv);
+	iwl_dealloc_ucode_pci(priv);
 
 	if (priv->rxq.bd)
 		iwl_rx_queue_free(priv, &priv->rxq);
@@ -4413,7 +4413,7 @@ static void __devexit iwl4965_pci_remove(struct pci_dev *pdev)
 	/*netif_stop_queue(dev); */
 	flush_workqueue(priv->workqueue);
 
-	/* ieee80211_unregister_hw calls iwl4965_mac_stop, which flushes
+	/* ieee80211_unregister_hw calls iwl_mac_stop, which flushes
 	 * priv->workqueue... so we can't take down the workqueue
 	 * until now... */
 	destroy_workqueue(priv->workqueue);
@@ -4434,13 +4434,13 @@ static void __devexit iwl4965_pci_remove(struct pci_dev *pdev)
 
 #ifdef CONFIG_PM
 
-static int iwl4965_pci_suspend(struct pci_dev *pdev, pm_message_t state)
+static int iwl_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 {
 	struct iwl_priv *priv = pci_get_drvdata(pdev);
 
 	if (priv->is_open) {
 		set_bit(STATUS_IN_SUSPEND, &priv->status);
-		iwl4965_mac_stop(priv->hw);
+		iwl_mac_stop(priv->hw);
 		priv->is_open = 1;
 	}
 
@@ -4449,14 +4449,14 @@ static int iwl4965_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 	return 0;
 }
 
-static int iwl4965_pci_resume(struct pci_dev *pdev)
+static int iwl_pci_resume(struct pci_dev *pdev)
 {
 	struct iwl_priv *priv = pci_get_drvdata(pdev);
 
 	pci_set_power_state(pdev, PCI_D0);
 
 	if (priv->is_open)
-		iwl4965_mac_start(priv->hw);
+		iwl_mac_start(priv->hw);
 
 	clear_bit(STATUS_IN_SUSPEND, &priv->status);
 	return 0;
@@ -4499,15 +4499,15 @@ MODULE_DEVICE_TABLE(pci, iwl_hw_card_ids);
 static struct pci_driver iwl_driver = {
 	.name = DRV_NAME,
 	.id_table = iwl_hw_card_ids,
-	.probe = iwl4965_pci_probe,
-	.remove = __devexit_p(iwl4965_pci_remove),
+	.probe = iwl_pci_probe,
+	.remove = __devexit_p(iwl_pci_remove),
 #ifdef CONFIG_PM
-	.suspend = iwl4965_pci_suspend,
-	.resume = iwl4965_pci_resume,
+	.suspend = iwl_pci_suspend,
+	.resume = iwl_pci_resume,
 #endif
 };
 
-static int __init iwl4965_init(void)
+static int __init iwl_init(void)
 {
 
 	int ret;
@@ -4533,11 +4533,11 @@ error_register:
 	return ret;
 }
 
-static void __exit iwl4965_exit(void)
+static void __exit iwl_exit(void)
 {
 	pci_unregister_driver(&iwl_driver);
 	iwlagn_rate_control_unregister();
 }
 
-module_exit(iwl4965_exit);
-module_init(iwl4965_init);
+module_exit(iwl_exit);
+module_init(iwl_init);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index b58fcde..57323b1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -576,8 +576,8 @@ extern int iwl_send_add_sta(struct iwl_priv *priv,
 			    struct iwl_addsta_cmd *sta, u8 flags);
 extern u8 iwl_add_station_flags(struct iwl_priv *priv, const u8 *addr,
 			int is_ap, u8 flags, struct ieee80211_sta_ht_cap *ht_info);
-extern void iwl4965_update_chain_flags(struct iwl_priv *priv);
-extern int iwl4965_set_pwr_src(struct iwl_priv *priv, enum iwl_pwr_src src);
+extern void iwl_update_chain_flags(struct iwl_priv *priv);
+extern int iwl_set_pwr_src(struct iwl_priv *priv, enum iwl_pwr_src src);
 extern const u8 iwl_bcast_addr[ETH_ALEN];
 extern int iwl_rxq_stop(struct iwl_priv *priv);
 extern void iwl_txq_ctx_stop(struct iwl_priv *priv);
-- 
1.5.4.3

