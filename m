Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:57769 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756202AbYC1Xd4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2008 19:33:56 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>
Subject: [PATCH 4/4] iwlwifi: Eliminate association from beacon
Date: Fri, 28 Mar 2008 16:33:35 -0700
Message-Id: <1206747215-10640-5-git-send-email-reinette.chatre@intel.com> (sfid-20080328_233400_818478_ED40A9ED)
In-Reply-To: <1206747215-10640-4-git-send-email-reinette.chatre@intel.com>
References: <1206747215-10640-1-git-send-email-reinette.chatre@intel.com>
 <1206747215-10640-2-git-send-email-reinette.chatre@intel.com>
 <1206747215-10640-3-git-send-email-reinette.chatre@intel.com>
 <1206747215-10640-4-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch removes association from beacon
using bss_info_change handler for association

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c     |  174 +--------------------------
 drivers/net/wireless/iwlwifi/iwl-4965.h     |    6 +-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   73 +++++++-----
 4 files changed, 51 insertions(+), 204 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
index 90ecf26..32eb414 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -275,7 +275,7 @@ static int rs_send_lq_cmd(struct iwl_priv *priv,
 	if (flags & CMD_ASYNC)
 		cmd.meta.u.callback = iwl4965_lq_sync_callback;
 
-	if (iwl4965_is_associated(priv) && priv->assoc_station_added &&
+	if (iwl_is_associated(priv) && priv->assoc_station_added &&
 	    priv->lq_mngr.lq_ready)
 		return  iwl_send_cmd(priv, &cmd);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 51a1449..733dee4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -1306,7 +1306,7 @@ void iwl4965_chain_noise_reset(struct iwl_priv *priv)
 	struct iwl4965_chain_noise_data *data = NULL;
 
 	data = &(priv->chain_noise_data);
-	if ((data->state == IWL_CHAIN_NOISE_ALIVE) && iwl4965_is_associated(priv)) {
+	if ((data->state == IWL_CHAIN_NOISE_ALIVE) && iwl_is_associated(priv)) {
 		struct iwl4965_calibration_cmd cmd;
 
 		memset(&cmd, 0, sizeof(cmd));
@@ -1581,7 +1581,7 @@ static void iwl4965_sensitivity_calibration(struct iwl_priv *priv,
 
 	data = &(priv->sensitivity_data);
 
-	if (!iwl4965_is_associated(priv)) {
+	if (!iwl_is_associated(priv)) {
 		IWL_DEBUG_CALIB("<< - not associated\n");
 		return;
 	}
@@ -3575,77 +3575,6 @@ static int iwl4965_calc_rssi(struct iwl4965_rx_phy_res *rx_resp)
 
 #ifdef CONFIG_IWL4965_HT
 
-/* Parsed Information Elements */
-struct ieee802_11_elems {
-	u8 *ds_params;
-	u8 ds_params_len;
-	u8 *tim;
-	u8 tim_len;
-	u8 *ibss_params;
-	u8 ibss_params_len;
-	u8 *erp_info;
-	u8 erp_info_len;
-	u8 *ht_cap_param;
-	u8 ht_cap_param_len;
-	u8 *ht_extra_param;
-	u8 ht_extra_param_len;
-};
-
-static int parse_elems(u8 *start, size_t len, struct ieee802_11_elems *elems)
-{
-	size_t left = len;
-	u8 *pos = start;
-	int unknown = 0;
-
-	memset(elems, 0, sizeof(*elems));
-
-	while (left >= 2) {
-		u8 id, elen;
-
-		id = *pos++;
-		elen = *pos++;
-		left -= 2;
-
-		if (elen > left)
-			return -1;
-
-		switch (id) {
-		case WLAN_EID_DS_PARAMS:
-			elems->ds_params = pos;
-			elems->ds_params_len = elen;
-			break;
-		case WLAN_EID_TIM:
-			elems->tim = pos;
-			elems->tim_len = elen;
-			break;
-		case WLAN_EID_IBSS_PARAMS:
-			elems->ibss_params = pos;
-			elems->ibss_params_len = elen;
-			break;
-		case WLAN_EID_ERP_INFO:
-			elems->erp_info = pos;
-			elems->erp_info_len = elen;
-			break;
-		case WLAN_EID_HT_CAPABILITY:
-			elems->ht_cap_param = pos;
-			elems->ht_cap_param_len = elen;
-			break;
-		case WLAN_EID_HT_EXTRA_INFO:
-			elems->ht_extra_param = pos;
-			elems->ht_extra_param_len = elen;
-			break;
-		default:
-			unknown++;
-			break;
-		}
-
-		left -= elen;
-		pos += elen;
-	}
-
-	return 0;
-}
-
 void iwl4965_init_ht_hw_capab(struct iwl_priv *priv,
 			      struct ieee80211_ht_info *ht_info,
 			      enum ieee80211_band band)
@@ -3862,7 +3791,6 @@ static inline void iwl4965_dbg_report_frame(struct iwl_priv *priv,
 #endif
 
 
-#define IWL_DELAY_NEXT_SCAN_AFTER_ASSOC (HZ*6)
 
 /* Called for REPLY_RX (legacy ABG frames), or
  * REPLY_RX_MPDU_CMD (HT high-throughput N frames). */
@@ -3951,7 +3879,7 @@ static void iwl4965_rx_reply_rx(struct iwl_priv *priv,
 	 *   which are gathered only when associated, and indicate noise
 	 *   only for the associated network channel ...
 	 * Ignore these noise values while scanning (other channels) */
-	if (iwl4965_is_associated(priv) &&
+	if (iwl_is_associated(priv) &&
 	    !test_bit(STATUS_SCANNING, &priv->status)) {
 		rx_status.noise = priv->last_rx_noise;
 		rx_status.signal = iwl4965_calc_sig_qual(rx_status.ssi,
@@ -3962,7 +3890,7 @@ static void iwl4965_rx_reply_rx(struct iwl_priv *priv,
 	}
 
 	/* Reset beacon noise level if not associated. */
-	if (!iwl4965_is_associated(priv))
+	if (!iwl_is_associated(priv))
 		priv->last_rx_noise = IWL_NOISE_MEAS_NOT_AVAILABLE;
 
 	/* Set "1" to report good data frames in groups of 100 */
@@ -3983,101 +3911,9 @@ static void iwl4965_rx_reply_rx(struct iwl_priv *priv,
 	fc = le16_to_cpu(header->frame_control);
 	switch (fc & IEEE80211_FCTL_FTYPE) {
 	case IEEE80211_FTYPE_MGMT:
-
 		if (priv->iw_mode == IEEE80211_IF_TYPE_AP)
 			iwl4965_update_ps_mode(priv, fc  & IEEE80211_FCTL_PM,
 						header->addr2);
-		switch (fc & IEEE80211_FCTL_STYPE) {
-		case IEEE80211_STYPE_PROBE_RESP:
-		case IEEE80211_STYPE_BEACON:
-			if ((priv->iw_mode == IEEE80211_IF_TYPE_STA &&
-			     !compare_ether_addr(header->addr2, priv->bssid)) ||
-			    (priv->iw_mode == IEEE80211_IF_TYPE_IBSS &&
-			     !compare_ether_addr(header->addr3, priv->bssid))) {
-				struct ieee80211_mgmt *mgmt =
-					(struct ieee80211_mgmt *)header;
-				u64 timestamp =
-					le64_to_cpu(mgmt->u.beacon.timestamp);
-
-				priv->timestamp0 = timestamp & 0xFFFFFFFF;
-				priv->timestamp1 =
-					(timestamp >> 32) & 0xFFFFFFFF;
-				priv->beacon_int = le16_to_cpu(
-				    mgmt->u.beacon.beacon_int);
-				if (priv->call_post_assoc_from_beacon &&
-				    (priv->iw_mode == IEEE80211_IF_TYPE_STA)) {
-					priv->call_post_assoc_from_beacon = 0;
-					queue_work(priv->workqueue,
-					    &priv->post_associate.work);
-				}
-			}
-			break;
-
-		case IEEE80211_STYPE_ACTION:
-			break;
-
-			/*
-			 * TODO: Use the new callback function from
-			 * mac80211 instead of sniffing these packets.
-			 */
-		case IEEE80211_STYPE_ASSOC_RESP:
-		case IEEE80211_STYPE_REASSOC_RESP:
-			if (network_packet) {
-#ifdef CONFIG_IWL4965_HT
-				u8 *pos = NULL;
-				struct ieee802_11_elems elems;
-#endif				/*CONFIG_IWL4965_HT */
-				struct ieee80211_mgmt *mgnt =
-					(struct ieee80211_mgmt *)header;
-
-				/* We have just associated, give some
-				 * time for the 4-way handshake if
-				 * any. Don't start scan too early. */
-				priv->next_scan_jiffies = jiffies +
-					IWL_DELAY_NEXT_SCAN_AFTER_ASSOC;
-
-				priv->assoc_id = (~((1 << 15) | (1 << 14))
-					& le16_to_cpu(mgnt->u.assoc_resp.aid));
-				priv->assoc_capability =
-					le16_to_cpu(
-						mgnt->u.assoc_resp.capab_info);
-#ifdef CONFIG_IWL4965_HT
-				pos = mgnt->u.assoc_resp.variable;
-				if (!parse_elems(pos,
-						 len - (pos - (u8 *) mgnt),
-						 &elems)) {
-					if (elems.ht_extra_param &&
-					    elems.ht_cap_param)
-						break;
-				}
-#endif				/*CONFIG_IWL4965_HT */
-				/* assoc_id is 0 no association */
-				if (!priv->assoc_id)
-					break;
-				if (priv->beacon_int)
-					queue_work(priv->workqueue,
-					    &priv->post_associate.work);
-				else
-					priv->call_post_assoc_from_beacon = 1;
-			}
-
-			break;
-
-		case IEEE80211_STYPE_PROBE_REQ:
-			if ((priv->iw_mode == IEEE80211_IF_TYPE_IBSS) &&
-			    !iwl4965_is_associated(priv)) {
-				DECLARE_MAC_BUF(mac1);
-				DECLARE_MAC_BUF(mac2);
-				DECLARE_MAC_BUF(mac3);
-
-				IWL_DEBUG_DROP("Dropping (non network): "
-					       "%s, %s, %s\n",
-					       print_mac(mac1, header->addr1),
-					       print_mac(mac2, header->addr2),
-					       print_mac(mac3, header->addr3));
-				return;
-			}
-		}
 		iwl4965_handle_data_packet(priv, 0, include_phy, rxb, &rx_status);
 		break;
 
@@ -4136,7 +3972,6 @@ static void iwl4965_rx_reply_rx_phy(struct iwl_priv *priv,
 	memcpy(&priv->last_phy_res[1], &(pkt->u.raw[0]),
 	       sizeof(struct iwl4965_rx_phy_res));
 }
-
 static void iwl4965_rx_missed_beacon_notif(struct iwl_priv *priv,
 					   struct iwl4965_rx_mem_buffer *rxb)
 
@@ -4158,7 +3993,6 @@ static void iwl4965_rx_missed_beacon_notif(struct iwl_priv *priv,
 	}
 #endif /*CONFIG_IWL4965_SENSITIVITY*/
 }
-
 #ifdef CONFIG_IWL4965_HT
 
 /**
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index 8c14e9a..c8e7028 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -1068,7 +1068,6 @@ struct iwl_priv {
 	u16 active_rate;
 	u16 active_rate_basic;
 
-	u8 call_post_assoc_from_beacon;
 	u8 assoc_station_added;
 	u8 use_ant_b_for_management_frame;	/* Tx antenna selection */
 	u8 valid_antenna;	/* Bit mask of antennas actually connected */
@@ -1161,8 +1160,7 @@ struct iwl_priv {
 	struct sk_buff *ibss_beacon;
 
 	/* Last Rx'd beacon timestamp */
-	u32 timestamp0;
-	u32 timestamp1;
+	u64 timestamp;
 	u16 beacon_int;
 	struct iwl4965_driver_hw_info hw_setting;
 	struct ieee80211_vif *vif;
@@ -1226,7 +1224,7 @@ struct iwl_priv {
 	struct timer_list statistics_periodic;
 }; /*iwl_priv */
 
-static inline int iwl4965_is_associated(struct iwl_priv *priv)
+static inline int iwl_is_associated(struct iwl_priv *priv)
 {
 	return (priv->active_rxon.filter_flags & RXON_FILTER_ASSOC_MSK) ? 1 : 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 8f4d2aa..385ec7a 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -901,7 +901,7 @@ static int iwl4965_commit_rxon(struct iwl_priv *priv)
 	 * an RXON_ASSOC and the new config wants the associated mask enabled,
 	 * we must clear the associated from the active configuration
 	 * before we apply the new config */
-	if (iwl4965_is_associated(priv) &&
+	if (iwl_is_associated(priv) &&
 	    (priv->staging_rxon.filter_flags & RXON_FILTER_ASSOC_MSK)) {
 		IWL_DEBUG_INFO("Toggling associated bit on current RXON\n");
 		active_rxon->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
@@ -967,7 +967,7 @@ static int iwl4965_commit_rxon(struct iwl_priv *priv)
 
 	/* If we have set the ASSOC_MSK and we are in BSS mode then
 	 * add the IWL_AP_ID to the station rate table */
-	if (iwl4965_is_associated(priv) &&
+	if (iwl_is_associated(priv) &&
 	    (priv->iw_mode == IEEE80211_IF_TYPE_STA)) {
 		if (iwl4965_rxon_add_station(priv, priv->active_rxon.bssid_addr, 1)
 		    == IWL_INVALID_STATION) {
@@ -1319,7 +1319,7 @@ unsigned int iwl4965_fill_beacon_frame(struct iwl_priv *priv,
 				const u8 *dest, int left)
 {
 
-	if (!iwl4965_is_associated(priv) || !priv->ibss_beacon ||
+	if (!iwl_is_associated(priv) || !priv->ibss_beacon ||
 	    ((priv->iw_mode != IEEE80211_IF_TYPE_IBSS) &&
 	     (priv->iw_mode != IEEE80211_IF_TYPE_AP)))
 		return 0;
@@ -1582,7 +1582,7 @@ static void iwl4965_activate_qos(struct iwl_priv *priv, u8 force)
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	if (force || iwl4965_is_associated(priv)) {
+	if (force || iwl_is_associated(priv)) {
 		IWL_DEBUG_QOS("send QoS cmd with Qos active=%d FLAGS=0x%X\n",
 				priv->qos_data.qos_active,
 				priv->qos_data.def_qos_parm.qos_flags);
@@ -1921,13 +1921,13 @@ static void iwl4965_setup_rxon_timing(struct iwl_priv *priv)
 	conf = ieee80211_get_hw_conf(priv->hw);
 
 	spin_lock_irqsave(&priv->lock, flags);
-	priv->rxon_timing.timestamp.dw[1] = cpu_to_le32(priv->timestamp1);
-	priv->rxon_timing.timestamp.dw[0] = cpu_to_le32(priv->timestamp0);
+	priv->rxon_timing.timestamp.dw[1] = cpu_to_le32(priv->timestamp >> 32);
+	priv->rxon_timing.timestamp.dw[0] =
+				cpu_to_le32(priv->timestamp & 0xFFFFFFFF);
 
 	priv->rxon_timing.listen_interval = INTEL_CONN_LISTEN_INTERVAL;
 
-	tsf = priv->timestamp1;
-	tsf = ((tsf << 32) | priv->timestamp0);
+	tsf = priv->timestamp;
 
 	beacon_int = priv->beacon_int;
 	spin_unlock_irqrestore(&priv->lock, flags);
@@ -2374,10 +2374,10 @@ static int iwl4965_tx_skb(struct iwl_priv *priv,
 
 	/* drop all data frame if we are not associated */
 	if (((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA) &&
-	   (!iwl4965_is_associated(priv) ||
+	   (!iwl_is_associated(priv) ||
 	    ((priv->iw_mode == IEEE80211_IF_TYPE_STA) && !priv->assoc_id) ||
 	    !priv->assoc_station_added)) {
-		IWL_DEBUG_DROP("Dropping - !iwl4965_is_associated\n");
+		IWL_DEBUG_DROP("Dropping - !iwl_is_associated\n");
 		goto drop_unlock;
 	}
 
@@ -2838,7 +2838,7 @@ static int iwl4965_get_measurement(struct iwl_priv *priv,
 	int spectrum_resp_status;
 	int duration = le16_to_cpu(params->duration);
 
-	if (iwl4965_is_associated(priv))
+	if (iwl_is_associated(priv))
 		add_time =
 		    iwl4965_usecs_to_beacons(
 			le64_to_cpu(params->start_time) - priv->last_tsf,
@@ -2853,7 +2853,7 @@ static int iwl4965_get_measurement(struct iwl_priv *priv,
 	cmd.len = sizeof(spectrum);
 	spectrum.len = cpu_to_le16(cmd.len - sizeof(spectrum.len));
 
-	if (iwl4965_is_associated(priv))
+	if (iwl_is_associated(priv))
 		spectrum.start_time =
 		    iwl4965_add_beacon_time(priv->last_beacon_time,
 				add_time,
@@ -4504,7 +4504,7 @@ static void iwl4965_irq_handle_error(struct iwl_priv *priv)
 		IWL_DEBUG(IWL_DL_INFO | IWL_DL_FW_ERRORS,
 			  "Restarting adapter due to uCode error.\n");
 
-		if (iwl4965_is_associated(priv)) {
+		if (iwl_is_associated(priv)) {
 			memcpy(&priv->recovery_rxon, &priv->active_rxon,
 			       sizeof(priv->recovery_rxon));
 			priv->error_recovering = 1;
@@ -4790,7 +4790,7 @@ static u16 iwl4965_get_passive_dwell_time(struct iwl_priv *priv,
 	    IWL_PASSIVE_DWELL_BASE + IWL_PASSIVE_DWELL_TIME_24 :
 	    IWL_PASSIVE_DWELL_BASE + IWL_PASSIVE_DWELL_TIME_52;
 
-	if (iwl4965_is_associated(priv)) {
+	if (iwl_is_associated(priv)) {
 		/* If we're associated, we clamp the maximum passive
 		 * dwell time to be 98% of the beacon interval (minus
 		 * 2 * channel tune time) */
@@ -4830,7 +4830,7 @@ static int iwl4965_get_channels_for_scan(struct iwl_priv *priv,
 	for (i = 0, added = 0; i < sband->n_channels; i++) {
 		if (ieee80211_frequency_to_channel(channels[i].center_freq) ==
 		    le16_to_cpu(priv->active_rxon.channel)) {
-			if (iwl4965_is_associated(priv)) {
+			if (iwl_is_associated(priv)) {
 				IWL_DEBUG_SCAN
 				    ("Skipping current channel %d\n",
 				     le16_to_cpu(priv->active_rxon.channel));
@@ -5711,7 +5711,7 @@ static void iwl4965_alive_start(struct iwl_priv *priv)
 
 	iwl4965_send_power_mode(priv, IWL_POWER_LEVEL(priv->power_mode));
 
-	if (iwl4965_is_associated(priv)) {
+	if (iwl_is_associated(priv)) {
 		struct iwl4965_rxon_cmd *active_rxon =
 				(struct iwl4965_rxon_cmd *)(&priv->active_rxon);
 
@@ -6130,7 +6130,7 @@ static void iwl4965_bg_request_scan(struct work_struct *data)
 	scan->quiet_plcp_th = IWL_PLCP_QUIET_THRESH;
 	scan->quiet_time = IWL_ACTIVE_QUIET_TIME;
 
-	if (iwl4965_is_associated(priv)) {
+	if (iwl_is_associated(priv)) {
 		u16 interval = 0;
 		u32 extra;
 		u32 suspend_time = 100;
@@ -6167,7 +6167,7 @@ static void iwl4965_bg_request_scan(struct work_struct *data)
 		memcpy(scan->direct_scan[0].ssid,
 		       priv->direct_ssid, priv->direct_ssid_len);
 		direct_mask = 1;
-	} else if (!iwl4965_is_associated(priv) && priv->essid_len) {
+	} else if (!iwl_is_associated(priv) && priv->essid_len) {
 		scan->direct_scan[0].id = WLAN_EID_SSID;
 		scan->direct_scan[0].len = priv->essid_len;
 		memcpy(scan->direct_scan[0].ssid, priv->essid, priv->essid_len);
@@ -7000,6 +7000,7 @@ static inline void iwl4965_ht_conf(struct iwl_priv *priv,
 }
 #endif
 
+#define IWL_DELAY_NEXT_SCAN_AFTER_ASSOC (HZ*6)
 static void iwl4965_bss_info_changed(struct ieee80211_hw *hw,
 				     struct ieee80211_vif *vif,
 				     struct ieee80211_bss_conf *bss_conf,
@@ -7007,7 +7008,11 @@ static void iwl4965_bss_info_changed(struct ieee80211_hw *hw,
 {
 	struct iwl_priv *priv = hw->priv;
 
+	IWL_DEBUG_MAC80211("changes = 0x%X\n", changes);
+
 	if (changes & BSS_CHANGED_ERP_PREAMBLE) {
+		IWL_DEBUG_MAC80211("ERP_PREAMBLE %d\n",
+				   bss_conf->use_short_preamble);
 		if (bss_conf->use_short_preamble)
 			priv->staging_rxon.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
 		else
@@ -7015,6 +7020,7 @@ static void iwl4965_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	if (changes & BSS_CHANGED_ERP_CTS_PROT) {
+		IWL_DEBUG_MAC80211("ERP_CTS %d\n", bss_conf->use_cts_prot);
 		if (bss_conf->use_cts_prot && (priv->band != IEEE80211_BAND_5GHZ))
 			priv->staging_rxon.flags |= RXON_FLG_TGG_PROTECT_MSK;
 		else
@@ -7022,19 +7028,30 @@ static void iwl4965_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	if (changes & BSS_CHANGED_HT) {
+		IWL_DEBUG_MAC80211("HT %d\n", bss_conf->assoc_ht);
 		iwl4965_ht_conf(priv, bss_conf);
 		iwl4965_set_rxon_chain(priv);
 	}
 
 	if (changes & BSS_CHANGED_ASSOC) {
-		/*
-		 * TODO:
-		 * do stuff instead of sniffing assoc resp
-		 */
+		IWL_DEBUG_MAC80211("ASSOC %d\n", bss_conf->assoc);
+		if (bss_conf->assoc) {
+			priv->assoc_id = bss_conf->aid;
+			priv->beacon_int = bss_conf->beacon_int;
+			priv->timestamp = bss_conf->timestamp;
+			priv->assoc_capability = bss_conf->assoc_capability;
+			priv->next_scan_jiffies = jiffies +
+					IWL_DELAY_NEXT_SCAN_AFTER_ASSOC;
+			queue_work(priv->workqueue, &priv->post_associate.work);
+		} else {
+			priv->assoc_id = 0;
+			IWL_DEBUG_MAC80211("DISASSOC %d\n", bss_conf->assoc);
+		}
+	} else if (changes && iwl_is_associated(priv) && priv->assoc_id) {
+			IWL_DEBUG_MAC80211("Associated Changes %d\n", changes);
+			iwl4965_send_rxon_assoc(priv);
 	}
 
-	if (iwl4965_is_associated(priv))
-		iwl4965_send_rxon_assoc(priv);
 }
 
 static int iwl4965_mac_hw_scan(struct ieee80211_hw *hw, u8 *ssid, size_t len)
@@ -7167,7 +7184,7 @@ static int iwl4965_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 	/* FIXME: need to differenciate between static and dynamic key
 	 * in the level of mac80211 */
-	static_key = !iwl4965_is_associated(priv);
+	static_key = !iwl_is_associated(priv);
 
 	if (!static_key) {
 		sta_id = iwl4965_hw_find_station(priv, addr);
@@ -7248,7 +7265,7 @@ static int iwl4965_mac_conf_tx(struct ieee80211_hw *hw, int queue,
 	mutex_lock(&priv->mutex);
 	if (priv->iw_mode == IEEE80211_IF_TYPE_AP)
 		iwl4965_activate_qos(priv, 1);
-	else if (priv->assoc_id && iwl4965_is_associated(priv))
+	else if (priv->assoc_id && iwl_is_associated(priv))
 		iwl4965_activate_qos(priv, 0);
 
 	mutex_unlock(&priv->mutex);
@@ -7331,7 +7348,6 @@ static void iwl4965_mac_reset_tsf(struct ieee80211_hw *hw)
 	spin_lock_irqsave(&priv->lock, flags);
 	priv->assoc_id = 0;
 	priv->assoc_capability = 0;
-	priv->call_post_assoc_from_beacon = 0;
 	priv->assoc_station_added = 0;
 
 	/* new association get rid of ibss beacon skb */
@@ -7341,8 +7357,7 @@ static void iwl4965_mac_reset_tsf(struct ieee80211_hw *hw)
 	priv->ibss_beacon = NULL;
 
 	priv->beacon_int = priv->hw->conf.beacon_int;
-	priv->timestamp1 = 0;
-	priv->timestamp0 = 0;
+	priv->timestamp = 0;
 	if ((priv->iw_mode == IEEE80211_IF_TYPE_STA))
 		priv->beacon_int = 0;
 
-- 
1.5.3.4

