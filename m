Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:49643 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932344AbXGaC7K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jul 2007 22:59:10 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 4/7] iwlwifi: Endainity fix for rx configuration
Date: Tue, 31 Jul 2007 10:56:33 +0800
Message-Id: <11858506033857-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11858506013260-git-send-email-yi.zhu@intel.com>
References: <11858505963374-git-send-email-yi.zhu@intel.com>
 <118585059814-git-send-email-yi.zhu@intel.com>
 <11858505994113-git-send-email-yi.zhu@intel.com>
 <11858506013260-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch fixes endianity issues in rx configuration
related code.

Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-4965.c |   26 ++++---
 drivers/net/wireless/iwl-base.c |  148 +++++++++++++++++++++------------------
 drivers/net/wireless/iwl-hw.h   |   10 ++--
 3 files changed, 101 insertions(+), 83 deletions(-)

diff --git a/drivers/net/wireless/iwl-4965.c b/drivers/net/wireless/iwl-4965.c
index 19591a6..786c5d0 100644
--- a/drivers/net/wireless/iwl-4965.c
+++ b/drivers/net/wireless/iwl-4965.c
@@ -3615,8 +3615,8 @@ static void iwl4965_handle_data_packet(struct iwl_priv *priv, int is_data,
 
 		hdr = (void *)(pkt->u.raw +
 			       sizeof(struct iwl4965_rx_mpdu_res_start));
-		rx_end = (u32 *) (((u8 *) hdr) + amsdu->byte_count);
 		len = amsdu->byte_count;
+		rx_end = (u32 *) (((u8 *) hdr) + len);
 		rx_start->byte_count = len;
 	}
 	if (len > 2342 || len < 16) {
@@ -4130,21 +4130,25 @@ static int iwl4965_tx_status_reply_compressed_ba(struct iwl_priv *priv,
 
 {
 	int i, sh, ack;
+	u16 ba_seq_ctl = le16_to_cpu(ba_resp->ba_seq_ctl);
 	u32 bitmap0, bitmap1;
+	u32 resp_bitmap0 = le32_to_cpu(ba_resp->ba_bitmap0);
+	u32 resp_bitmap1 = le32_to_cpu(ba_resp->ba_bitmap1);
+
 	if (unlikely(!agg->wait_for_ba))  {
 		IWL_ERROR("Received BA when not expected\n");
 		return -EINVAL;
 	}
 	agg->wait_for_ba = 0;
 	IWL_DEBUG_TX_REPLY("BA %d %d\n", agg->start_idx, ba_resp->ba_seq_ctl);
-	sh = agg->start_idx - SEQ_TO_INDEX(ba_resp->ba_seq_ctl>>4);
+	sh = agg->start_idx - SEQ_TO_INDEX(ba_seq_ctl>>4);
 	if (sh < 0) /* tbw something is wrong with indeces */
 		sh += 0x100;
 
 	/* don't use 64 bits for now */
-	bitmap0 = ba_resp->ba_bitmap0 >> sh;
-	bitmap1 = ba_resp->ba_bitmap1 >> sh;
-	bitmap0 |= (ba_resp->ba_bitmap1 & ((1<<sh)|((1<<sh)-1))) << (32 - sh);
+	bitmap0 = resp_bitmap0 >> sh;
+	bitmap1 = resp_bitmap1 >> sh;
+	bitmap0 |= (resp_bitmap1 & ((1<<sh)|((1<<sh)-1))) << (32 - sh);
 
 	if (agg->frame_count > (64 - sh)) {
 		IWL_DEBUG_TX_REPLY("more frames than bitmap size");
@@ -4184,15 +4188,17 @@ static void iwl4965_rx_reply_compressed_ba(struct iwl_priv *priv,
 	int index;
 	struct iwl_tx_queue *txq = NULL;
 	struct iwl_ht_agg *agg;
+	u16 ba_resp_scd_flow = le16_to_cpu(ba_resp->scd_flow);
+	u16 ba_resp_scd_ssn = le16_to_cpu(ba_resp->scd_ssn);
 
-	if (ba_resp->scd_flow >= ARRAY_SIZE(priv->txq)) {
+	if (ba_resp_scd_flow >= ARRAY_SIZE(priv->txq)) {
 		IWL_ERROR("BUG_ON scd_flow is bigger than number of queues");
 		return;
 	}
 
-	txq = &priv->txq[ba_resp->scd_flow];
+	txq = &priv->txq[ba_resp_scd_flow];
 	agg = &priv->stations[ba_resp->sta_id].tid[ba_resp->tid].agg;
-	index = iwl_queue_dec_wrap(ba_resp->scd_ssn & 0xff, txq->q.n_bd);
+	index = iwl_queue_dec_wrap(ba_resp_scd_ssn & 0xff, txq->q.n_bd);
 
 	/* TODO: Need to get this copy more sefely - now good for debug */
 /*
@@ -4216,8 +4222,8 @@ static void iwl4965_rx_reply_compressed_ba(struct iwl_priv *priv,
 */
 	iwl4965_tx_status_reply_compressed_ba(priv, agg, ba_resp);
 	/* releases all the TFDs until the SSN */
-	if (txq->q.last_used != (ba_resp->scd_ssn & 0xff))
-		iwl_tx_queue_reclaim(priv, ba_resp ->scd_flow, index);
+	if (txq->q.last_used != (ba_resp_scd_ssn & 0xff))
+		iwl_tx_queue_reclaim(priv, ba_resp_scd_flow, index);
 
 }
 
diff --git a/drivers/net/wireless/iwl-base.c b/drivers/net/wireless/iwl-base.c
index a2560d3..b7854b5 100644
--- a/drivers/net/wireless/iwl-base.c
+++ b/drivers/net/wireless/iwl-base.c
@@ -843,7 +843,7 @@ static int iwl_rxon_add_station(struct iwl_priv *priv,
  * NOTE:  Does not commit to the hardware; it sets appropriate bit fields
  * in the staging RXON flag structure based on the phymode
  */
-static int iwl_set_rxon_channel(struct iwl_priv *priv, u8 phymode, u8 channel)
+static int iwl_set_rxon_channel(struct iwl_priv *priv, u8 phymode, u16 channel)
 {
 	if (!iwl_get_channel_info(priv, phymode, channel)) {
 		IWL_DEBUG_INFO("Could not set channel to %d [%d]\n",
@@ -851,11 +851,11 @@ static int iwl_set_rxon_channel(struct iwl_priv *priv, u8 phymode, u8 channel)
 		return -EINVAL;
 	}
 
-	if ((priv->staging_rxon.channel == channel) &&
+	if ((le16_to_cpu(priv->staging_rxon.channel) == channel) &&
 	    (priv->phymode == phymode))
 		return 0;
 
-	priv->staging_rxon.channel = channel;
+	priv->staging_rxon.channel = cpu_to_le16(channel);
 	if ((phymode == MODE_IEEE80211A) ||
 	    (phymode == MODE_ATHEROS_TURBO))
 		priv->staging_rxon.flags &= ~RXON_FLG_BAND_24G_MSK;
@@ -882,18 +882,19 @@ static int iwl_check_rxon_cmd(struct iwl_rxon_cmd *rxon)
 	int counter = 1;
 
 	if (rxon->flags & RXON_FLG_BAND_24G_MSK) {
-		error |= (rxon->flags & RXON_FLG_TGJ_NARROW_BAND_MSK);
-		error |= (rxon->flags & RXON_FLG_RADAR_DETECT_MSK);
+		error |=
+			le32_to_cpu(rxon->flags & RXON_FLG_TGJ_NARROW_BAND_MSK);
+		error |= le32_to_cpu(rxon->flags & RXON_FLG_RADAR_DETECT_MSK);
 		if (error)
 			IWL_WARNING("check 24G fields %d | %d\n",
 				    counter++, error);
 	} else {
 		error |= ((rxon->flags & RXON_FLG_SHORT_SLOT_MSK) !=
-			  RXON_FLG_SHORT_SLOT_MSK);
+			RXON_FLG_SHORT_SLOT_MSK);
 		if (error)
 			IWL_WARNING("check 52 fields %d | %d\n",
 				    counter++, error);
-		error |= (rxon->flags & RXON_FLG_CCK_MSK);
+		error |= le32_to_cpu(rxon->flags & RXON_FLG_CCK_MSK);
 		if (error)
 			IWL_WARNING("check 52 CCK %d | %d\n",
 				    counter++, error);
@@ -905,11 +906,11 @@ static int iwl_check_rxon_cmd(struct iwl_rxon_cmd *rxon)
 
 	/* make sure basic rates 6Mbps and 1Mbps are supported */
 	error |= (((rxon->ofdm_basic_rates & IWL_RATE_6M_MASK) == 0) &&
-		  ((rxon->cck_basic_rates & IWL_RATE_1M_MASK) == 0));
+		((rxon->cck_basic_rates & IWL_RATE_1M_MASK) == 0));
 	if (error)
 		IWL_WARNING("check basic rate %d | %d\n", counter++, error);
 
-	error |= (rxon->assoc_id > 2007);
+	error |= (le16_to_cpu(rxon->assoc_id) > 2007);
 	if (error)
 		IWL_WARNING("check assoc id %d | %d\n", counter++, error);
 
@@ -2334,19 +2335,19 @@ static void iwl_sequence_reset(struct iwl_priv *priv)
 #else
 #define MAX_UCODE_BEACON_INTERVAL	1024
 #endif
-#define INTEL_CONN_LISTEN_INTERVAL	0xA
+#define INTEL_CONN_LISTEN_INTERVAL	__constant_cpu_to_le16(0xA)
 
-static u16 iwl_adjust_beacon_interval(u16 beacon_val)
+static __le16 iwl_adjust_beacon_interval(u16 beacon_val)
 {
 	u16 new_val = 0;
 	u16 beacon_factor = 0;
 
 	beacon_factor =
-	    (beacon_val +
-	     MAX_UCODE_BEACON_INTERVAL) / MAX_UCODE_BEACON_INTERVAL;
+	    (beacon_val + MAX_UCODE_BEACON_INTERVAL)
+		/ MAX_UCODE_BEACON_INTERVAL;
 	new_val = beacon_val / beacon_factor;
 
-	return new_val;
+	return cpu_to_le16(new_val);
 }
 
 static void iwl_setup_rxon_timing(struct iwl_priv *priv)
@@ -2360,8 +2361,8 @@ static void iwl_setup_rxon_timing(struct iwl_priv *priv)
 	conf = ieee80211_get_hw_conf(priv->hw);
 
 	spin_lock_irqsave(&priv->lock, flags);
-	priv->rxon_timing.timestamp.dw[1] = priv->timestamp1;
-	priv->rxon_timing.timestamp.dw[0] = priv->timestamp0;
+	priv->rxon_timing.timestamp.dw[1] = cpu_to_le32(priv->timestamp1);
+	priv->rxon_timing.timestamp.dw[0] = cpu_to_le32(priv->timestamp0);
 
 	priv->rxon_timing.listen_interval = INTEL_CONN_LISTEN_INTERVAL;
 
@@ -2373,13 +2374,14 @@ static void iwl_setup_rxon_timing(struct iwl_priv *priv)
 
 	if (priv->iw_mode == IEEE80211_IF_TYPE_STA) {
 		if (beacon_int == 0) {
-			priv->rxon_timing.beacon_interval = 100;
-			priv->rxon_timing.beacon_init_val = 102400;
+			priv->rxon_timing.beacon_interval = cpu_to_le16(100);
+			priv->rxon_timing.beacon_init_val = cpu_to_le32(102400);
 		} else {
-			priv->rxon_timing.beacon_interval = beacon_int;
+			priv->rxon_timing.beacon_interval =
+				cpu_to_le16(beacon_int);
 			priv->rxon_timing.beacon_interval =
 			    iwl_adjust_beacon_interval(
-				    priv->rxon_timing.beacon_interval);
+				le16_to_cpu(priv->rxon_timing.beacon_interval));
 		}
 
 		priv->rxon_timing.atim_window = 0;
@@ -2391,15 +2393,17 @@ static void iwl_setup_rxon_timing(struct iwl_priv *priv)
 		priv->rxon_timing.atim_window = 0;
 	}
 
-	interval_tm_unit = (priv->rxon_timing.beacon_interval * 1024);
+	interval_tm_unit =
+		(le16_to_cpu(priv->rxon_timing.beacon_interval) * 1024);
 	result = do_div(tsf, interval_tm_unit);
 	priv->rxon_timing.beacon_init_val =
-	    (u32) ((u64) interval_tm_unit - result);
+	    cpu_to_le32((u32) ((u64) interval_tm_unit - result));
 
 	IWL_DEBUG_ASSOC
 	    ("beacon interval %d beacon timer %d beacon tim %d\n",
-	     priv->rxon_timing.beacon_interval,
-	     priv->rxon_timing.beacon_init_val, priv->rxon_timing.atim_window);
+		le16_to_cpu(priv->rxon_timing.beacon_interval),
+		le32_to_cpu(priv->rxon_timing.beacon_init_val),
+		le16_to_cpu(priv->rxon_timing.atim_window));
 }
 
 static int iwl_scan_initiate(struct iwl_priv *priv)
@@ -2515,7 +2519,7 @@ static void iwl_connection_init_rx_config(struct iwl_priv *priv)
 #endif
 
 	ch_info = iwl_get_channel_info(priv, priv->phymode,
-				       priv->staging_rxon.channel);
+				       le16_to_cpu(priv->staging_rxon.channel));
 
 	if (!ch_info)
 		ch_info = &priv->channel_info[0];
@@ -2528,7 +2532,7 @@ static void iwl_connection_init_rx_config(struct iwl_priv *priv)
 	    !(is_channel_ibss(ch_info)))
 		ch_info = &priv->channel_info[0];
 
-	priv->staging_rxon.channel = ch_info->channel;
+	priv->staging_rxon.channel = cpu_to_le16(ch_info->channel);
 	if (is_channel_a_band(ch_info))
 		priv->phymode = MODE_IEEE80211A;
 	else
@@ -2560,12 +2564,12 @@ static int iwl_set_mode(struct iwl_priv *priv, int mode)
 		const struct iwl_channel_info *ch_info;
 
 		ch_info = iwl_get_channel_info(priv,
-					       priv->phymode,
-					       priv->staging_rxon.channel);
+			priv->phymode,
+			le16_to_cpu(priv->staging_rxon.channel));
 
 		if (!ch_info || !is_channel_ibss(ch_info)) {
 			IWL_ERROR("channel %d not IBSS channel\n",
-				  priv->staging_rxon.channel);
+				  le16_to_cpu(priv->staging_rxon.channel));
 			return -EINVAL;
 		}
 	}
@@ -3139,6 +3143,7 @@ void iwl_handle_data_packet_monitor(struct iwl_priv *priv,
 	s8 noise = 0;
 	int rate = stats->rate;
 	u64 tsf = stats->mactime;
+	__le16 phy_flags_hw = cpu_to_le16(phy_flags);
 
 	/* We received data from the HW, so stop the watchdog */
 	if (len > IWL_RX_BUF_SIZE - sizeof(*iwl_rt)) {
@@ -3180,16 +3185,15 @@ void iwl_handle_data_packet_monitor(struct iwl_priv *priv,
 
 	/* Convert the channel frequency and set the flags */
 	iwl_rt->rt_channelMHz = cpu_to_le16(stats->freq);
-	if (!(phy_flags & RX_RES_PHY_FLAGS_BAND_24_MSK)) {
+	if (!(phy_flags_hw & RX_RES_PHY_FLAGS_BAND_24_MSK))
 		iwl_rt->rt_chbitmask =
 		    cpu_to_le16((IEEE80211_CHAN_OFDM | IEEE80211_CHAN_5GHZ));
-	} else if (phy_flags & RX_RES_PHY_FLAGS_MOD_CCK_MSK) {
+	else if (phy_flags_hw & RX_RES_PHY_FLAGS_MOD_CCK_MSK)
 		iwl_rt->rt_chbitmask =
 		    cpu_to_le16((IEEE80211_CHAN_CCK | IEEE80211_CHAN_2GHZ));
-	} else {		/* 802.11g */
+	else	/* 802.11g */
 		iwl_rt->rt_chbitmask =
 		    cpu_to_le16((IEEE80211_CHAN_OFDM | IEEE80211_CHAN_2GHZ));
-	}
 
 	rate = iwl_rate_index_from_plcp(rate);
 	if (rate == -1)
@@ -3198,10 +3202,11 @@ void iwl_handle_data_packet_monitor(struct iwl_priv *priv,
 		iwl_rt->rt_rate = iwl_rates[rate].ieee;
 
 	/* antenna number */
-	iwl_rt->rt_antenna = (phy_flags & RX_RES_PHY_FLAGS_ANTENNA_MSK) >> 4;
+	iwl_rt->rt_antenna =
+		le16_to_cpu(phy_flags_hw & RX_RES_PHY_FLAGS_ANTENNA_MSK) >> 4;
 
 	/* set the preamble flag if we have it */
-	if (phy_flags & RX_RES_PHY_FLAGS_SHORT_PREAMBLE_MSK)
+	if (phy_flags_hw & RX_RES_PHY_FLAGS_SHORT_PREAMBLE_MSK)
 		iwl_rt->rt_flags |= IEEE80211_RADIOTAP_F_SHORTPRE;
 
 	IWL_DEBUG_RX("Rx packet of %d bytes.\n", rxb->skb->len);
@@ -3315,7 +3320,7 @@ static u32 iwl_usecs_to_beacons(u32 usec, u32 beacon_interval)
  * the same as HW timer counter counting down
  */
 
-static u32 iwl_add_beacon_time(u32 base, u32 addon, u32 beacon_interval)
+static __le32 iwl_add_beacon_time(u32 base, u32 addon, u32 beacon_interval)
 {
 	u32 base_low = base & BEACON_TIME_MASK_LOW;
 	u32 addon_low = addon & BEACON_TIME_MASK_LOW;
@@ -3331,7 +3336,7 @@ static u32 iwl_add_beacon_time(u32 base, u32 addon, u32 beacon_interval)
 	} else
 		res += (1 << 24);
 
-	return res;
+	return cpu_to_le32(res);
 }
 
 static int iwl_get_measurement(struct iwl_priv *priv,
@@ -3345,32 +3350,35 @@ static int iwl_get_measurement(struct iwl_priv *priv,
 		.data = (void *)&spectrum,
 		.meta.flags = CMD_WANT_SKB,
 	};
-	u32 add_time = params->start_time;
+	u32 add_time = le64_to_cpu(params->start_time);
 	int rc;
+	int spectrum_resp_status;
+	int duration = le16_to_cpu(params->duration);
 
 	if (iwl_is_associated(priv))
 		add_time =
-		    iwl_usecs_to_beacons(params->start_time - priv->last_tsf,
-					 priv->rxon_timing.beacon_interval);
+		    iwl_usecs_to_beacons(
+			le64_to_cpu(params->start_time) - priv->last_tsf,
+			le16_to_cpu(priv->rxon_timing.beacon_interval));
 
 	memset(&spectrum, 0, sizeof(spectrum));
 
-	spectrum.channel_count = cpu_to_le32(1);
+	spectrum.channel_count = cpu_to_le16(1);
 	spectrum.flags =
 	    RXON_FLG_TSF2HOST_MSK | RXON_FLG_ANT_A_MSK | RXON_FLG_DIS_DIV_MSK;
 	spectrum.filter_flags = MEASUREMENT_FILTER_FLAG;
 	cmd.len = sizeof(spectrum);
-	spectrum.len = cmd.len - sizeof(spectrum.len);
+	spectrum.len = cpu_to_le16(cmd.len - sizeof(spectrum.len));
 
 	if (iwl_is_associated(priv))
 		spectrum.start_time =
 		    iwl_add_beacon_time(priv->last_beacon_time,
-					add_time,
-					priv->rxon_timing.beacon_interval);
+				add_time,
+				le16_to_cpu(priv->rxon_timing.beacon_interval));
 	else
 		spectrum.start_time = params->start_time;
 
-	spectrum.channels[0].duration = params->duration * TIME_UNIT;
+	spectrum.channels[0].duration = cpu_to_le32(duration * TIME_UNIT);
 	spectrum.channels[0].channel = params->channel;
 	spectrum.channels[0].type = type;
 	if (priv->active_rxon.flags & RXON_FLG_BAND_24G_MSK)
@@ -3387,7 +3395,8 @@ static int iwl_get_measurement(struct iwl_priv *priv,
 		rc = -EIO;
 	}
 
-	switch (res->u.spectrum.status) {
+	spectrum_resp_status = le16_to_cpu(res->u.spectrum.status);
+	switch (spectrum_resp_status) {
 	case 0:		/* Command will be handled */
 		if (res->u.spectrum.id != 0xff) {
 			IWL_DEBUG_INFO
@@ -3799,13 +3808,13 @@ static void iwl_rx_reply_error(struct iwl_priv *priv,
 			       struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
-	u32 err_type = pkt->u.err_resp.error_type;
-	u8 cmd_id = pkt->u.err_resp.cmd_id;
-	u16 seq = pkt->u.err_resp.bad_cmd_seq_num;
-	u32 ser = pkt->u.err_resp.error_info;
 	IWL_ERROR("Error Reply type 0x%08X cmd %s (0x%02X) "
-		  "seq 0x%04X ser 0x%08X\n",
-		  err_type, get_cmd_string(cmd_id), cmd_id, seq, ser);
+		"seq 0x%04X ser 0x%08X\n",
+		le32_to_cpu(pkt->u.err_resp.error_type),
+		get_cmd_string(pkt->u.err_resp.cmd_id),
+		pkt->u.err_resp.cmd_id,
+		le16_to_cpu(pkt->u.err_resp.bad_cmd_seq_num),
+		le32_to_cpu(pkt->u.err_resp.error_info));
 	return;
 }
 
@@ -3817,8 +3826,9 @@ static void iwl_rx_csa(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 	struct iwl_rxon_cmd *rxon = (void *)&priv->active_rxon;
 	struct iwl_csa_notification *csa = &(pkt->u.csa_notif);
 	IWL_DEBUG_11H("CSA notif: channel %d, status %d\n",
-		      csa->channel, csa->status);
-	rxon->channel = priv->staging_rxon.channel = cpu_to_le16(csa->channel);
+		      le16_to_cpu(csa->channel), le32_to_cpu(csa->status));
+	rxon->channel = csa->channel;
+	priv->staging_rxon.channel = csa->channel;
 }
 
 static void iwl_rx_spectrum_measure_notif(struct iwl_priv *priv,
@@ -3872,11 +3882,12 @@ static void iwl_rx_beacon_notif(struct iwl_priv *priv,
 	u8 rate = beacon->beacon_notify_hdr.rate.s.rate;
 #endif
 	IWL_DEBUG_RX("beacon status %x retries %d iss %d "
-		     "tsf %d %d rate %d\n",
-		     beacon->beacon_notify_hdr.status & TX_STATUS_MSK,
-		     beacon->beacon_notify_hdr.failure_frame,
-		     beacon->ibss_mgr_status,
-		     beacon->high_tsf, beacon->low_tsf, rate);
+		"tsf %d %d rate %d\n",
+		le32_to_cpu(beacon->beacon_notify_hdr.status & TX_STATUS_MSK),
+		beacon->beacon_notify_hdr.failure_frame,
+		le32_to_cpu(beacon->ibss_mgr_status),
+		le32_to_cpu(beacon->high_tsf),
+		le32_to_cpu(beacon->low_tsf), rate);
 #endif
 }
 
@@ -3895,7 +3906,7 @@ static void iwl_rx_scan_start_notif(struct iwl_priv *priv,
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
 	struct iwl_scanstart_notification *notif =
 	    (struct iwl_scanstart_notification *)pkt->u.raw;
-	priv->scan_start_tsf = notif->tsf_low;
+	priv->scan_start_tsf = le32_to_cpu(notif->tsf_low);
 	IWL_DEBUG_SCAN("Scan start: "
 		       "%d [802.11%s] "
 		       "(TSF: 0x%08X:%08X) - %d (beacon timer %u)\n",
@@ -3918,10 +3929,10 @@ static void iwl_rx_scan_results_notif(struct iwl_priv *priv,
 		       "elapsed=%lu usec (%dms since last)\n",
 		       notif->channel,
 		       notif->band ? "bg" : "a",
-		       notif->tsf_high,
-		       notif->tsf_low,
-		       notif->statistics[0],
-		       notif->tsf_low - priv->scan_start_tsf,
+		       le32_to_cpu(notif->tsf_high),
+		       le32_to_cpu(notif->tsf_low),
+		       le32_to_cpu(notif->statistics[0]),
+		       le32_to_cpu(notif->tsf_low) - priv->scan_start_tsf,
 		       jiffies_to_msecs(elapsed_jiffies
 					(priv->last_scan_jiffies, jiffies)));
 
@@ -7139,9 +7150,10 @@ static void iwl_bg_request_scan(struct work_struct *data)
 	scan->channel_count =
 		iwl_get_channels_for_scan(
 			priv, phymode, 1, /* active */
-			direct_mask, (void *)&scan->data[scan->tx_cmd.len]);
+			direct_mask,
+			(void *)&scan->data[le16_to_cpu(scan->tx_cmd.len)]);
 
-	cmd.len += scan->tx_cmd.len +
+	cmd.len += le16_to_cpu(scan->tx_cmd.len) +
 	    scan->channel_count * sizeof(struct iwl_scan_channel);
 	cmd.data = scan;
 	scan->len = cmd.len;
@@ -8404,12 +8416,12 @@ static ssize_t store_tune(struct device *d,
 	char *p = (char *)buf;
 	u16 tune = simple_strtoul(p, &p, 0);
 	u8 phymode = (tune >> 8) & 0xff;
-	u8 channel = tune & 0xff;
+	u16 channel = tune & 0xff;
 
 	IWL_DEBUG_INFO("Tune request to:%d channel:%d\n", phymode, channel);
 
 	mutex_lock(&priv->mutex);
-	if ((priv->staging_rxon.channel != channel) ||
+	if ((le16_to_cpu(priv->staging_rxon.channel) != channel) ||
 	    (priv->phymode != phymode)) {
 		const struct iwl_channel_info *ch_info;
 
diff --git a/drivers/net/wireless/iwl-hw.h b/drivers/net/wireless/iwl-hw.h
index 25a4728..0cc341b 100644
--- a/drivers/net/wireless/iwl-hw.h
+++ b/drivers/net/wireless/iwl-hw.h
@@ -368,10 +368,10 @@ struct iwl_rx_frame_hdr {
 #define	RX_RES_STATUS_NO_RXE_OVERFLOW	__constant_cpu_to_le32(1 << 1)
 
 #define	RX_RES_PHY_FLAGS_BAND_24_MSK	__constant_cpu_to_le16(1 << 0)
-#define	RX_RES_PHY_FLAGS_MOD_CCK_MSK		(1 << 1)
-#define	RX_RES_PHY_FLAGS_SHORT_PREAMBLE_MSK	(1 << 2)
-#define	RX_RES_PHY_FLAGS_NARROW_BAND_MSK	(1 << 3)
-#define	RX_RES_PHY_FLAGS_ANTENNA_MSK		0xf0
+#define	RX_RES_PHY_FLAGS_MOD_CCK_MSK		__constant_cpu_to_le16(1 << 1)
+#define	RX_RES_PHY_FLAGS_SHORT_PREAMBLE_MSK	__constant_cpu_to_le16(1 << 2)
+#define	RX_RES_PHY_FLAGS_NARROW_BAND_MSK	__constant_cpu_to_le16(1 << 3)
+#define	RX_RES_PHY_FLAGS_ANTENNA_MSK		__constant_cpu_to_le16(0xf0)
 
 #define	RX_RES_STATUS_SEC_TYPE_MSK	(0x7 << 8)
 #define	RX_RES_STATUS_SEC_TYPE_NONE	(0x0 << 8)
@@ -422,7 +422,7 @@ struct iwl_txpowertable_cmd {
  */
 
 /* Can abort will notify by complete notification with abort status. */
-#define CAN_ABORT_STATUS        0x1
+#define CAN_ABORT_STATUS	__constant_cpu_to_le32(0x1)
 
 struct iwl_scanreq_notification {
 	__le32 status;
-- 
1.5.2
