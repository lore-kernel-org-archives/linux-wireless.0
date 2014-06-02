Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redpinesignals.com ([203.196.161.92]:2322 "EHLO
	mail.redpinesignals.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755000AbaFBO5e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jun 2014 10:57:34 -0400
Received: from localhost.localdomain ([192.168.40.102])
	(authenticated user jahnavi.meher@redpinesignals.com)
	by mail.redpinesignals.com
	for linux-wireless@vger.kernel.org;
	Mon, 2 Jun 2014 20:27:29 +0530
Message-ID: <538C910E.6090703@redpinesignals.com> (sfid-20140602_165739_129155_56072A61)
Date: Mon, 02 Jun 2014 20:28:22 +0530
From: Jahnavi Meher <jahnavi.meher@redpinesignals.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: [PATCH 1/1] rsi: Adding support for bgscan, 5GHz support and clean
 up of code
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


From: Jahnavi Meher <jahnavi.meher@redpinesignals.com>

This patch adds code for support of bgscan and 5GHz. It also contains
changes to the piece of code that determines the number of packets to 
be de-queued from soft queues - it is changed from a fixed number to
a count based on txop. There are also a number of small clean ups.

Signed-off-by: Jahnavi Meher <jahnavi.meher@redpinesignals.com>
---
 rsi_91x_core.c     |   81 ++++++++++++++++++++---------
 rsi_91x_debugfs.c  |   10 +--
 rsi_91x_mac80211.c |  110 +++++++++++++++++++++++++++++++++------
 rsi_91x_main.c     |    2 
 rsi_91x_mgmt.c     |  148 +++++++++++++++++++++++++++++++++++++++++++----------
 rsi_91x_sdio_ops.c |    4 -
 rsi_main.h         |   14 +++++
 rsi_mgmt.h         |    2 
 rsi_sdio.h         |    4 -
 9 files changed, 299 insertions(+), 76 deletions(-)

diff -uprN b/drivers/net/wireless/rsi/rsi_91x_core.c a/drivers/net/wireless/rsi/rsi_91x_core.c
--- b/drivers/net/wireless/rsi/rsi_91x_core.c	2014-06-02 19:45:25.337377135 +0530
+++ a/drivers/net/wireless/rsi/rsi_91x_core.c	2014-06-02 19:46:06.962374674 +0530
@@ -77,6 +77,50 @@ static bool rsi_recalculate_weights(stru
 }
 
 /**
+ * rsi_get_num_pkts_dequeue() - This function determines the number of
+ *		                packets to be dequeued based on the number
+ *			        of bytes calculated using txop.
+ *
+ * @common: Pointer to the driver private structure.
+ * @q_num: the queue from which pkts have to be dequeued
+ *
+ * Return: pkt_num: Number of pkts to be dequeued.
+ */
+static u32 rsi_get_num_pkts_dequeue(struct rsi_common *common, u8 q_num)
+{
+	struct rsi_hw *adapter = common->priv;
+	struct sk_buff *skb;
+	u32 pkt_cnt = 0;
+	s16 txop = common->tx_qinfo[q_num].txop * 32;
+	struct ieee80211_rate rate;
+	rate.bitrate = RSI_RATE_MCS0 * 5 * 10;
+
+	if (q_num == VI_Q)
+		txop = ((txop << 5) / 80);
+
+	if (skb_queue_len(&common->tx_queue[q_num]))
+		skb = skb_peek(&common->tx_queue[q_num]);
+	else
+		return 0;
+
+	do {
+		txop -= ieee80211_generic_frame_duration(adapter->hw,
+							adapter->vifs[0],
+							common->band,
+							skb->len, &rate);
+		pkt_cnt += 1;
+		/*checking if pkts are still there*/
+		if (skb_queue_len(&common->tx_queue[q_num]) - pkt_cnt)
+			skb = skb->next;
+		else
+			break;
+
+	} while (txop > 0);
+
+	return pkt_cnt;
+}
+
+/**
  * rsi_core_determine_hal_queue() - This function determines the queue from
  *				    which packet has to be dequeued.
  * @common: Pointer to the driver private structure.
@@ -88,7 +132,7 @@ static u8 rsi_core_determine_hal_queue(s
 	bool recontend_queue = false;
 	u32 q_len = 0;
 	u8 q_num = INVALID_QUEUE;
-	u8 ii = 0, min = 0;
+	u8 ii = 0;
 
 	if (skb_queue_len(&common->tx_queue[MGMT_SOFT_Q])) {
 		if (!common->mgmt_q_block)
@@ -106,14 +150,15 @@ get_queue_num:
 
 	q_num = rsi_determine_min_weight_queue(common);
 
-	q_len = skb_queue_len(&common->tx_queue[ii]);
 	ii = q_num;
 
 	/* Selecting the queue with least back off */
 	for (; ii < NUM_EDCA_QUEUES; ii++) {
+		q_len = skb_queue_len(&common->tx_queue[ii]);
 		if (((common->tx_qinfo[ii].pkt_contended) &&
-		     (common->tx_qinfo[ii].weight < min)) && q_len) {
-			min = common->tx_qinfo[ii].weight;
+		     (common->tx_qinfo[ii].weight < common->min_weight)) &&
+		      q_len) {
+			common->min_weight = common->tx_qinfo[ii].weight;
 			q_num = ii;
 		}
 	}
@@ -140,25 +185,11 @@ get_queue_num:
 	common->selected_qnum = q_num;
 	q_len = skb_queue_len(&common->tx_queue[q_num]);
 
-	switch (common->selected_qnum) {
-	case VO_Q:
-		if (q_len > MAX_CONTINUOUS_VO_PKTS)
-			common->pkt_cnt = (MAX_CONTINUOUS_VO_PKTS - 1);
-		else
-			common->pkt_cnt = --q_len;
-		break;
-
-	case VI_Q:
-		if (q_len > MAX_CONTINUOUS_VI_PKTS)
-			common->pkt_cnt = (MAX_CONTINUOUS_VI_PKTS - 1);
-		else
-			common->pkt_cnt = --q_len;
-
-		break;
-
-	default:
+	if (q_num == VO_Q || q_num == VI_Q) {
+		common->pkt_cnt = rsi_get_num_pkts_dequeue(common, q_num);
+		common->pkt_cnt -= 1;
+	} else {
 		common->pkt_cnt = 0;
-		break;
 	}
 
 	return q_num;
@@ -245,13 +276,16 @@ void rsi_core_qos_processor(struct rsi_c
 		if ((q_num < MGMT_SOFT_Q) &&
 		    ((skb_queue_len(&common->tx_queue[q_num])) <=
 		      MIN_DATA_QUEUE_WATER_MARK)) {
-			if (ieee80211_queue_stopped(adapter->hw, WME_AC(q_num)))
+			if (ieee80211_queue_stopped(adapter->hw,
+						    WME_AC(q_num))) {
 				ieee80211_wake_queue(adapter->hw,
 						     WME_AC(q_num));
+			}
 		}
 
 		skb = rsi_core_dequeue_pkt(common, q_num);
 		if (skb == NULL) {
+			rsi_dbg(ERR_ZONE, "skb null\n");
 			mutex_unlock(&common->tx_rxlock);
 			break;
 		}
@@ -325,6 +359,7 @@ void rsi_core_xmit(struct rsi_common *co
 	if ((q_num != MGMT_SOFT_Q) &&
 	    ((skb_queue_len(&common->tx_queue[q_num]) + 1) >=
 	     DATA_QUEUE_WATER_MARK)) {
+		rsi_dbg(ERR_ZONE, "%s: sw queue full\n", __func__);
 		if (!ieee80211_queue_stopped(adapter->hw, WME_AC(q_num)))
 			ieee80211_stop_queue(adapter->hw, WME_AC(q_num));
 		rsi_set_event(&common->tx_thread.event);
diff -uprN b/drivers/net/wireless/rsi/rsi_91x_debugfs.c a/drivers/net/wireless/rsi/rsi_91x_debugfs.c
--- b/drivers/net/wireless/rsi/rsi_91x_debugfs.c	2014-06-02 19:45:25.343377134 +0530
+++ a/drivers/net/wireless/rsi/rsi_91x_debugfs.c	2014-06-02 19:46:06.962374674 +0530
@@ -145,7 +145,7 @@ static int rsi_stats_read(struct seq_fil
 	seq_printf(seq, "total_mgmt_pkt_send : %d\n",
 		   common->tx_stats.total_tx_pkt_send[MGMT_SOFT_Q]);
 	seq_printf(seq, "total_mgmt_pkt_queued : %d\n",
-		   skb_queue_len(&common->tx_queue[4]));
+		   skb_queue_len(&common->tx_queue[MGMT_SOFT_Q]));
 	seq_printf(seq, "total_mgmt_pkt_freed  : %d\n",
 		   common->tx_stats.total_tx_pkt_freed[MGMT_SOFT_Q]);
 
@@ -153,25 +153,25 @@ static int rsi_stats_read(struct seq_fil
 	seq_printf(seq, "total_data_vo_pkt_send: %8d\t",
 		   common->tx_stats.total_tx_pkt_send[VO_Q]);
 	seq_printf(seq, "total_data_vo_pkt_queued:  %8d\t",
-		   skb_queue_len(&common->tx_queue[0]));
+		   skb_queue_len(&common->tx_queue[VO_Q]));
 	seq_printf(seq, "total_vo_pkt_freed: %8d\n",
 		   common->tx_stats.total_tx_pkt_freed[VO_Q]);
 	seq_printf(seq, "total_data_vi_pkt_send: %8d\t",
 		   common->tx_stats.total_tx_pkt_send[VI_Q]);
 	seq_printf(seq, "total_data_vi_pkt_queued:  %8d\t",
-		   skb_queue_len(&common->tx_queue[1]));
+		   skb_queue_len(&common->tx_queue[VI_Q]));
 	seq_printf(seq, "total_vi_pkt_freed: %8d\n",
 		   common->tx_stats.total_tx_pkt_freed[VI_Q]);
 	seq_printf(seq,  "total_data_be_pkt_send: %8d\t",
 		   common->tx_stats.total_tx_pkt_send[BE_Q]);
 	seq_printf(seq, "total_data_be_pkt_queued:  %8d\t",
-		   skb_queue_len(&common->tx_queue[2]));
+		   skb_queue_len(&common->tx_queue[BE_Q]));
 	seq_printf(seq, "total_be_pkt_freed: %8d\n",
 		   common->tx_stats.total_tx_pkt_freed[BE_Q]);
 	seq_printf(seq, "total_data_bk_pkt_send: %8d\t",
 		   common->tx_stats.total_tx_pkt_send[BK_Q]);
 	seq_printf(seq, "total_data_bk_pkt_queued:  %8d\t",
-		   skb_queue_len(&common->tx_queue[3]));
+		   skb_queue_len(&common->tx_queue[BK_Q]));
 	seq_printf(seq, "total_bk_pkt_freed: %8d\n",
 		   common->tx_stats.total_tx_pkt_freed[BK_Q]);
 
diff -uprN b/drivers/net/wireless/rsi/rsi_91x_mac80211.c a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
--- b/drivers/net/wireless/rsi/rsi_91x_mac80211.c	2014-06-02 19:45:25.337377135 +0530
+++ a/drivers/net/wireless/rsi/rsi_91x_mac80211.c	2014-06-02 19:46:06.962374674 +0530
@@ -243,8 +243,8 @@ static void rsi_mac80211_tx(struct ieee8
 {
 	struct rsi_hw *adapter = hw->priv;
 	struct rsi_common *common = adapter->priv;
-
 	rsi_core_xmit(common, skb);
+	return;
 }
 
 /**
@@ -357,16 +357,36 @@ static int rsi_mac80211_config(struct ie
 	int status = -EOPNOTSUPP;
 
 	mutex_lock(&common->mutex);
+
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
 		struct ieee80211_channel *curchan = hw->conf.chandef.chan;
 		u16 channel = curchan->hw_value;
+		struct ieee80211_bss_conf *bss = &adapter->vifs[0]->bss_conf;
 
 		rsi_dbg(INFO_ZONE,
 			"%s: Set channel: %d MHz type: %d channel_no %d\n",
 			__func__, curchan->center_freq,
 			curchan->flags, channel);
-		common->band = curchan->band;
-		status = rsi_set_channel(adapter->priv, channel);
+
+		if (bss->assoc && !common->block_state &&
+		    (rsi_get_connected_channel(adapter) != channel)) {
+			rsi_dbg(INFO_ZONE, "blk data q %d\n", channel);
+			if (!rsi_send_block_unblock_frame(common, true))
+				common->block_state = true;
+		}
+
+		status = rsi_band_check(common);
+		if (!status)
+			status = rsi_set_channel(adapter->priv, channel);
+
+		if ((bss->assoc && common->block_state &&
+		    (rsi_get_connected_channel(adapter) == channel)) ||
+		    (!bss->assoc && common->block_state)) {
+			rsi_dbg(INFO_ZONE, "unblk data q %d\n", channel);
+			if (!rsi_send_block_unblock_frame(common, false))
+				common->block_state = false;
+		}
+
 	}
 	mutex_unlock(&common->mutex);
 
@@ -388,8 +408,7 @@ u16 rsi_get_connected_channel(struct rsi
 		struct ieee80211_channel *channel = bss->chandef.chan;
 		return channel->hw_value;
 	}
-
-	return 0;
+	return -EOPNOTSUPP;
 }
 
 /**
@@ -421,6 +440,15 @@ static void rsi_mac80211_bss_info_change
 				      bss_conf->qos,
 				      bss_conf->aid);
 	}
+
+	if (changed & BSS_CHANGED_CQM) {
+		common->cqm_info.last_cqm_event = 0;
+		common->cqm_info.rssi_thold = bss_conf->cqm_rssi_thold;
+		common->cqm_info.rssi_hyst = bss_conf->cqm_rssi_hyst;
+		rsi_dbg(INFO_ZONE, "RSSI throld & hysteresis are: %d %d\n",
+			common->cqm_info.rssi_thold,
+			common->cqm_info.rssi_hyst);
+	}
 	mutex_unlock(&common->mutex);
 }
 
@@ -723,23 +751,62 @@ static int rsi_mac80211_set_rate_mask(st
 	struct rsi_hw *adapter = hw->priv;
 	struct rsi_common *common = adapter->priv;
 
-	mutex_lock(&common->mutex);
+	u8 band = hw->conf.chandef.chan->band;
 
-	common->fixedrate_mask[IEEE80211_BAND_2GHZ] = 0;
+	mutex_lock(&common->mutex);
+	common->fixedrate_mask[band] = 0;
 
-	if (mask->control[IEEE80211_BAND_2GHZ].legacy == 0xfff) {
-		common->fixedrate_mask[IEEE80211_BAND_2GHZ] =
-			(mask->control[IEEE80211_BAND_2GHZ].ht_mcs[0] << 12);
+	if (mask->control[band].legacy == 0xfff) {
+		common->fixedrate_mask[band] =
+			(mask->control[band].ht_mcs[0] << 12);
 	} else {
-		common->fixedrate_mask[IEEE80211_BAND_2GHZ] =
-			mask->control[IEEE80211_BAND_2GHZ].legacy;
+		common->fixedrate_mask[band] =
+			mask->control[band].legacy;
 	}
-	mutex_unlock(&common->mutex);
 
+	mutex_unlock(&common->mutex);
 	return 0;
 }
 
 /**
+ * rsi_perform_cqm() - This function performs cqm.
+ * @common: Pointer to the driver private structure.
+ * @bss: Pointer to the ieee80211_bss_conf structure.
+ * @bssid: pointer to the bssid.
+ * @rssi: RSSI value.
+ */
+static void rsi_perform_cqm(struct rsi_common *common,
+			    struct ieee80211_bss_conf *bss,
+			    unsigned char *bssid,
+			    char rssi)
+{
+	struct rsi_hw *adapter = common->priv;
+	char last_event = common->cqm_info.last_cqm_event;
+	int thold = common->cqm_info.rssi_thold;
+	u32 hyst = common->cqm_info.rssi_hyst;
+	enum nl80211_cqm_rssi_threshold_event event;
+
+	if (!bss->assoc)
+		return;
+
+	if (memcmp(bss->bssid, bssid, ETH_ALEN))
+		return;
+
+	if (rssi < thold && (last_event == 0 || rssi < last_event - hyst))
+		event = NL80211_CQM_RSSI_THRESHOLD_EVENT_LOW;
+	else if (rssi > thold && (last_event == 0 || rssi > last_event + hyst))
+		event = NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH;
+	else
+		return;
+
+	common->cqm_info.last_cqm_event = rssi;
+	rsi_dbg(INFO_ZONE, "CQM: Notifying event: %d\n", event);
+	ieee80211_cqm_rssi_notify(adapter->vifs[0], event, GFP_KERNEL);
+
+	return;
+}
+
+/**
  * rsi_fill_rx_status() - This function fills rx status in
  *			  ieee80211_rx_status structure.
  * @hw: Pointer to the ieee80211_hw structure.
@@ -754,6 +821,8 @@ static void rsi_fill_rx_status(struct ie
 			       struct rsi_common *common,
 			       struct ieee80211_rx_status *rxs)
 {
+	struct rsi_hw *adapter = common->priv;
+	struct ieee80211_bss_conf *bss = &adapter->vifs[0]->bss_conf;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct skb_info *rx_params = (struct skb_info *)info->driver_data;
 	struct ieee80211_hdr *hdr;
@@ -769,10 +838,7 @@ static void rsi_fill_rx_status(struct ie
 
 	rxs->signal = -(rssi);
 
-	if (channel <= 14)
-		rxs->band = IEEE80211_BAND_2GHZ;
-	else
-		rxs->band = IEEE80211_BAND_5GHZ;
+	rxs->band = common->band;
 
 	freq = ieee80211_channel_to_frequency(channel, rxs->band);
 
@@ -791,6 +857,13 @@ static void rsi_fill_rx_status(struct ie
 		rxs->flag |= RX_FLAG_DECRYPTED;
 		rxs->flag |= RX_FLAG_IV_STRIPPED;
 	}
+
+
+	/* CQM only for beacons as RSSI is weighted avg RSSI in beacons */
+	if (ieee80211_is_beacon(hdr->frame_control))
+		rsi_perform_cqm(common, bss, hdr->addr2, rxs->signal);
+
+	return;
 }
 
 /**
@@ -982,6 +1055,7 @@ int rsi_mac80211_attach(struct rsi_commo
 
 	hw->max_tx_aggregation_subframes = 6;
 	rsi_register_rates_channels(adapter, IEEE80211_BAND_2GHZ);
+	rsi_register_rates_channels(adapter, IEEE80211_BAND_5GHZ);
 	hw->rate_control_algorithm = "AARF";
 
 	SET_IEEE80211_PERM_ADDR(hw, common->mac_addr);
@@ -999,6 +1073,8 @@ int rsi_mac80211_attach(struct rsi_commo
 	wiphy->available_antennas_tx = 1;
 	wiphy->bands[IEEE80211_BAND_2GHZ] =
 		&adapter->sbands[IEEE80211_BAND_2GHZ];
+	wiphy->bands[IEEE80211_BAND_5GHZ] =
+		&adapter->sbands[IEEE80211_BAND_5GHZ];
 
 	status = ieee80211_register_hw(hw);
 	if (status)
diff -uprN b/drivers/net/wireless/rsi/rsi_91x_main.c a/drivers/net/wireless/rsi/rsi_91x_main.c
--- b/drivers/net/wireless/rsi/rsi_91x_main.c	2014-06-02 19:45:25.337377135 +0530
+++ a/drivers/net/wireless/rsi/rsi_91x_main.c	2014-06-02 19:46:06.962374674 +0530
@@ -21,7 +21,7 @@
 #include "rsi_mgmt.h"
 #include "rsi_common.h"
 
-u32 rsi_zone_enabled = /* INFO_ZONE |
+u32 rsi_zone_enabled =  /*INFO_ZONE |
 			INIT_ZONE |
 			MGMT_TX_ZONE |
 			MGMT_RX_ZONE |
diff -uprN b/drivers/net/wireless/rsi/rsi_91x_mgmt.c a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
--- b/drivers/net/wireless/rsi/rsi_91x_mgmt.c	2014-06-02 19:45:25.337377135 +0530
+++ a/drivers/net/wireless/rsi/rsi_91x_mgmt.c	2014-06-02 19:46:06.962374674 +0530
@@ -217,6 +217,7 @@ static void rsi_set_default_parameters(s
 	common->min_rate = 0xffff;
 	common->fsm_state = FSM_CARD_NOT_READY;
 	common->iface_down = true;
+	common->endpoint = 0;
 }
 
 /**
@@ -306,11 +307,15 @@ static int rsi_load_radio_caps(struct rs
 
 	if (common->channel_width == BW_40MHZ) {
 		radio_caps->desc_word[7] |= cpu_to_le16(RSI_LMAC_CLOCK_80MHZ);
+
 		radio_caps->desc_word[7] |= cpu_to_le16(RSI_ENABLE_40MHZ);
 		if (common->channel_width) {
+
 			radio_caps->desc_word[5] =
 				cpu_to_le16(common->channel_width << 12);
+
 			radio_caps->desc_word[5] |= cpu_to_le16(FULL40M_ENABLE);
+
 		}
 
 		if (conf_is_ht40_minus(conf)) {
@@ -330,8 +335,8 @@ static int rsi_load_radio_caps(struct rs
 		}
 	}
 
-	radio_caps->desc_word[7] |= cpu_to_le16(radio_id << 8);
 
+	radio_caps->desc_word[7] |= cpu_to_le16(radio_id << 8);
 	for (ii = 0; ii < MAX_HW_QUEUES; ii++) {
 		radio_caps->qos_params[ii].cont_win_min_q = cpu_to_le16(3);
 		radio_caps->qos_params[ii].cont_win_max_q = cpu_to_le16(0x3f);
@@ -588,7 +593,13 @@ static int rsi_program_bb_rf(struct rsi_
 
 	mgmt_frame->desc_word[0] = cpu_to_le16(RSI_WIFI_MGMT_Q << 12);
 	mgmt_frame->desc_word[1] = cpu_to_le16(BBP_PROG_IN_TA);
-	mgmt_frame->desc_word[4] = cpu_to_le16(common->endpoint << 8);
+
+	if (common->band == IEEE80211_BAND_2GHZ)
+		common->endpoint = 0;
+	else
+		common->endpoint = 2;
+
+	mgmt_frame->desc_word[4] = cpu_to_le16(common->endpoint);
 
 	if (common->rf_reset) {
 		mgmt_frame->desc_word[7] =  cpu_to_le16(RF_RESET_ENABLE);
@@ -827,6 +838,49 @@ static int rsi_send_reset_mac(struct rsi
 }
 
 /**
+ * rsi_band_check() - This function programs the band
+ * @common: Pointer to the driver private structure.
+ *
+ * Return: 0 on success, corresponding error code on failure.
+ */
+int rsi_band_check(struct rsi_common *common)
+{
+	struct rsi_hw *adapter = common->priv;
+	struct ieee80211_hw *hw = adapter->hw;
+	u8 band_width = common->channel_width;
+	struct ieee80211_channel *curchan = hw->conf.chandef.chan;
+
+	if (common->band != curchan->band) {
+		common->rf_reset = 1;
+		common->band = curchan->band;
+
+		if (common->band == IEEE80211_BAND_2GHZ)
+			common->endpoint = 0;
+		else
+			common->endpoint = 1;
+
+		if (rsi_program_bb_rf(common))
+			return -1;
+	}
+
+	if ((hw->conf.chandef.width == NL80211_CHAN_WIDTH_20_NOHT) ||
+	    (hw->conf.chandef.width == NL80211_CHAN_WIDTH_20))
+		common->channel_width = BW_20MHZ;
+	else
+		common->channel_width = BW_40MHZ;
+
+	if (band_width != common->channel_width) {
+		common->rf_reset = 1;
+		if (rsi_load_bootup_params(common))
+			return -1;
+		if (rsi_load_radio_caps(common))
+			return -1;
+	}
+
+	return 0;
+}
+
+/**
  * rsi_set_channel() - This function programs the channel.
  * @common: Pointer to the driver private structure.
  * @channel: Channel value to be set.
@@ -842,14 +896,12 @@ int rsi_set_channel(struct rsi_common *c
 		"%s: Sending scan req frame\n", __func__);
 
 	if (common->band == IEEE80211_BAND_5GHZ) {
-		if ((channel >= 36) && (channel <= 64))
-			channel = ((channel - 32) / 4);
-		else if ((channel > 64) && (channel <= 140))
-			channel = ((channel - 102) / 4) + 8;
-		else if (channel >= 149)
-			channel = ((channel - 151) / 4) + 18;
-		else
+		if (channel > 165) {
+			rsi_dbg(ERR_ZONE, "%s: Invalid chno %d, band = %d\n",
+				__func__, channel, common->band);
 			return -EINVAL;
+		}
+
 	} else {
 		if (channel > 14) {
 			rsi_dbg(ERR_ZONE, "%s: Invalid chno %d, band = %d\n",
@@ -987,14 +1039,23 @@ static int rsi_send_auto_rate_request(st
 		auto_rate->desc_word[7] |= cpu_to_le16(1);
 
 	if (band == IEEE80211_BAND_2GHZ)
-		min_rate = STD_RATE_01;
+		min_rate = RSI_RATE_1;
 	else
-		min_rate = STD_RATE_06;
+		min_rate = RSI_RATE_6;
 
 	for (ii = 0, jj = 0; ii < ARRAY_SIZE(rsi_rates); ii++) {
-		if (rate_bitmap & BIT(ii)) {
-			selected_rates[jj++] = (rsi_rates[ii].bitrate / 5);
-			rate_offset++;
+		if (band == IEEE80211_BAND_2GHZ) {
+			if (rate_bitmap & BIT(ii)) {
+				selected_rates[jj++] =
+				(rsi_rates[ii].bitrate / 5);
+				rate_offset++;
+			}
+		} else {
+			if (rate_bitmap & BIT(ii)) {
+				selected_rates[jj++] =
+				(rsi_rates[ii + 4].bitrate / 5);
+				rate_offset++;
+			}
 		}
 	}
 	num_supported_rates = jj;
@@ -1006,13 +1067,6 @@ static int rsi_send_auto_rate_request(st
 		rate_offset += ARRAY_SIZE(mcs);
 	}
 
-	if (rate_offset < (RSI_TBL_SZ / 2) - 1) {
-		for (ii = jj; ii < (RSI_TBL_SZ / 2); ii++) {
-			selected_rates[jj++] = min_rate;
-			rate_offset++;
-		}
-	}
-
 	sort(selected_rates, jj, sizeof(u16), &rsi_compare, NULL);
 
 	/* mapping the rates to RSI rates */
@@ -1028,10 +1082,6 @@ static int rsi_send_auto_rate_request(st
 
 	/* loading HT rates in the bottom half of the auto rate table */
 	if (common->vif_info[0].is_ht) {
-		if (common->vif_info[0].sgi)
-			auto_rate->supported_rates[rate_offset++] =
-				cpu_to_le16(RSI_RATE_MCS7_SG);
-
 		for (ii = rate_offset, kk = ARRAY_SIZE(rsi_mcsrates) - 1;
 		     ii < rate_offset + 2 * ARRAY_SIZE(rsi_mcsrates); ii++) {
 			if (common->vif_info[0].sgi)
@@ -1041,12 +1091,15 @@ static int rsi_send_auto_rate_request(st
 				cpu_to_le16(rsi_mcsrates[kk--]);
 		}
 
-		for (; ii < RSI_TBL_SZ; ii++) {
+		for (; ii < (RSI_TBL_SZ - 1); ii++) {
 			auto_rate->supported_rates[ii] =
 				cpu_to_le16(rsi_mcsrates[0]);
 		}
 	}
 
+	for (; ii < RSI_TBL_SZ; ii++)
+		auto_rate->supported_rates[ii] = min_rate;
+
 	auto_rate->num_supported_rates = cpu_to_le16(num_supported_rates * 2);
 	auto_rate->moderate_rate_inx = cpu_to_le16(num_supported_rates / 2);
 	auto_rate->desc_word[7] |= cpu_to_le16(0 << 8);
@@ -1141,6 +1194,49 @@ static int rsi_eeprom_read(struct rsi_co
 }
 
 /**
+ * This function sends a frame to block/unblock
+ * data queues in the firmware
+ *
+ * @param common Pointer to the driver private structure.
+ * @param block/unblock event
+ * @return 0 on success, -1 on failure.
+ */
+int rsi_send_block_unblock_frame(struct rsi_common *common, bool event)
+{
+	struct rsi_mac_frame *mgmt_frame;
+	struct sk_buff *skb;
+
+	rsi_dbg(MGMT_TX_ZONE, "%s: Sending block/unblock frame\n", __func__);
+
+	skb = dev_alloc_skb(FRAME_DESC_SZ);
+	if (!skb) {
+		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of skb\n",
+			__func__);
+		return -1;
+	}
+
+	memset(skb->data, 0, FRAME_DESC_SZ);
+	mgmt_frame = (struct rsi_mac_frame *)skb->data;
+
+	mgmt_frame->desc_word[0] = cpu_to_le16(RSI_WIFI_MGMT_Q << 12);
+	mgmt_frame->desc_word[1] = cpu_to_le16(BLOCK_UNBLOCK);
+
+	if (event) {
+		rsi_dbg(ERR_ZONE, "blocking the data qs\n");
+		mgmt_frame->desc_word[4] = cpu_to_le16(0xf);
+	} else {
+		rsi_dbg(ERR_ZONE, "unblocking the data qs\n");
+		mgmt_frame->desc_word[5] = cpu_to_le16(0xf);
+	}
+
+	skb_put(skb, FRAME_DESC_SZ);
+
+	return rsi_send_internal_mgmt_frame(common, skb);
+
+}
+
+
+/**
  * rsi_handle_ta_confirm_type() - This function handles the confirm frames.
  * @common: Pointer to the driver private structure.
  * @msg: Pointer to received packet.
diff -uprN b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
--- b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c	2014-06-02 19:45:25.343377134 +0530
+++ a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c	2014-06-02 19:46:06.963374674 +0530
@@ -404,9 +404,9 @@ void rsi_interrupt_handler(struct rsi_hw
 				dev->rx_info.mgmt_buffer_full = false;
 				rsi_sdio_ack_intr(common->priv,
 						  (1 << PKT_BUFF_AVAILABLE));
-				rsi_set_event((&common->tx_thread.event));
+				rsi_set_event(&common->tx_thread.event);
 				rsi_dbg(ISR_ZONE,
-					"%s: ==> BUFFER_AVILABLE <==\n",
+					"%s: ==> BUFFER_AVAILABLE <==\n",
 					__func__);
 				dev->rx_info.buf_avilable_counter++;
 				break;
diff -uprN b/drivers/net/wireless/rsi/rsi_main.h a/drivers/net/wireless/rsi/rsi_main.h
--- b/drivers/net/wireless/rsi/rsi_main.h	2014-06-02 19:45:25.337377135 +0530
+++ a/drivers/net/wireless/rsi/rsi_main.h	2014-06-02 19:46:06.963374674 +0530
@@ -19,6 +19,9 @@
 
 #include <linux/string.h>
 #include <linux/skbuff.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
 #include <net/mac80211.h>
 
 #define ERR_ZONE                        BIT(0)  /* For Error Msgs             */
@@ -115,6 +118,7 @@ struct wmm_qinfo {
 	s32 weight;
 	s32 wme_params;
 	s32 pkt_contended;
+	s32 txop;
 };
 
 struct transmit_q_stats {
@@ -141,6 +145,12 @@ struct rsi_thread {
 	atomic_t thread_done;
 };
 
+struct cqm_info {
+	char last_cqm_event;
+	int rssi_thold;
+	unsigned int rssi_hyst;
+};
+
 struct rsi_hw;
 
 struct rsi_common {
@@ -192,6 +202,10 @@ struct rsi_common {
 	u8 selected_qnum;
 	u32 pkt_cnt;
 	u8 min_weight;
+
+	/* bgscan related */
+	struct cqm_info cqm_info;
+	bool block_state;
 };
 
 struct rsi_hw {
diff -uprN b/drivers/net/wireless/rsi/rsi_mgmt.h a/drivers/net/wireless/rsi/rsi_mgmt.h
--- b/drivers/net/wireless/rsi/rsi_mgmt.h	2014-06-02 19:45:25.337377135 +0530
+++ a/drivers/net/wireless/rsi/rsi_mgmt.h	2014-06-02 19:46:06.963374674 +0530
@@ -271,6 +271,7 @@ int rsi_send_aggregation_params_frame(st
 int rsi_hal_load_key(struct rsi_common *common, u8 *data, u16 key_len,
 		     u8 key_type, u8 key_id, u32 cipher);
 int rsi_set_channel(struct rsi_common *common, u16 chno);
+int rsi_send_block_unblock_frame(struct rsi_common *common, bool event);
 void rsi_inform_bss_status(struct rsi_common *common, u8 status,
 			   const u8 *bssid, u8 qos_enable, u16 aid);
 void rsi_indicate_pkt_to_os(struct rsi_common *common, struct sk_buff *skb);
@@ -282,4 +283,5 @@ void rsi_core_qos_processor(struct rsi_c
 void rsi_core_xmit(struct rsi_common *common, struct sk_buff *skb);
 int rsi_send_mgmt_pkt(struct rsi_common *common, struct sk_buff *skb);
 int rsi_send_data_pkt(struct rsi_common *common, struct sk_buff *skb);
+int rsi_band_check(struct rsi_common *common);
 #endif
diff -uprN b/drivers/net/wireless/rsi/rsi_sdio.h a/drivers/net/wireless/rsi/rsi_sdio.h
--- b/drivers/net/wireless/rsi/rsi_sdio.h	2014-06-02 19:45:25.337377135 +0530
+++ a/drivers/net/wireless/rsi/rsi_sdio.h	2014-06-02 19:46:06.963374674 +0530
@@ -30,7 +30,7 @@
 
 enum sdio_interrupt_type {
 	BUFFER_FULL         = 0x0,
-	BUFFER_AVAILABLE    = 0x1,
+	BUFFER_AVAILABLE    = 0x2,
 	FIRMWARE_ASSERT_IND = 0x3,
 	MSDU_PACKET_PENDING = 0x4,
 	UNKNOWN_INT         = 0XE
@@ -42,7 +42,7 @@ enum sdio_interrupt_type {
 #define PKT_MGMT_BUFF_FULL                      2
 #define MSDU_PKT_PENDING                        3
 /* Interrupt Bit Related Macros */
-#define PKT_BUFF_AVAILABLE                      0
+#define PKT_BUFF_AVAILABLE                      1
 #define FW_ASSERT_IND                           2
 
 #define RSI_DEVICE_BUFFER_STATUS_REGISTER       0xf3





