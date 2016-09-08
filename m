Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:36861 "EHLO
        mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752180AbcIHGmu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Sep 2016 02:42:50 -0400
Received: by mail-pa0-f42.google.com with SMTP id id6so14273772pad.3
        for <linux-wireless@vger.kernel.org>; Wed, 07 Sep 2016 23:42:50 -0700 (PDT)
From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
To: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
        johannes.berg@intel.com, hofrat@osadl.org, xypron.glpk@gmx.de
Cc: prameela.j04cs@gmail.com,
        Prameela Rani Garnepudi <prameela.garnepudi@redpinesignals.com>
Subject: [PATCH] rsi: code clean-up
Date: Thu,  8 Sep 2016 11:06:57 +0530
Message-Id: <1473313017-4074-1-git-send-email-prameela.j04cs@gmail.com> (sfid-20160908_084256_478076_00288CD3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.garnepudi@redpinesignals.com>

Signed-off-by: Prameela Rani Garnepudi <prameela.garnepudi@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_core.c     |  18 ++--
 drivers/net/wireless/rsi/rsi_91x_debugfs.c  |  13 +--
 drivers/net/wireless/rsi/rsi_91x_mac80211.c |  81 +++++++++------
 drivers/net/wireless/rsi/rsi_91x_main.c     |  16 ++-
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     | 155 +++++++++++-----------------
 drivers/net/wireless/rsi/rsi_91x_sdio.c     |  14 +--
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c |  11 +-
 drivers/net/wireless/rsi/rsi_91x_usb.c      |  34 ++++--
 drivers/net/wireless/rsi/rsi_common.h       |   2 +-
 drivers/net/wireless/rsi/rsi_debugfs.h      |   3 +-
 drivers/net/wireless/rsi/rsi_main.h         |  36 ++++---
 drivers/net/wireless/rsi/rsi_mgmt.h         |  54 +++++-----
 drivers/net/wireless/rsi/rsi_sdio.h         |  18 ++--
 13 files changed, 228 insertions(+), 227 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_core.c b/drivers/net/wireless/rsi/rsi_91x_core.c
index f3d3995..c6db8a9 100644
--- a/drivers/net/wireless/rsi/rsi_91x_core.c
+++ b/drivers/net/wireless/rsi/rsi_91x_core.c
@@ -134,7 +134,7 @@ static u8 rsi_core_determine_hal_queue(struct rsi_common *common)
 	bool recontend_queue = false;
 	u32 q_len = 0;
 	u8 q_num = INVALID_QUEUE;
-	u8 ii = 0;
+	u8 ii;
 
 	if (skb_queue_len(&common->tx_queue[MGMT_SOFT_Q])) {
 		if (!common->mgmt_q_block)
@@ -142,8 +142,10 @@ static u8 rsi_core_determine_hal_queue(struct rsi_common *common)
 		return q_num;
 	}
 
-	if (common->hw_data_qs_blocked)
+	if (common->hw_data_qs_blocked) {
+		rsi_dbg(INFO_ZONE, "%s: data queue blocked\n", __func__);
 		return q_num;
+	}
 
 	if (common->pkt_cnt != 0) {
 		--common->pkt_cnt;
@@ -210,6 +212,7 @@ static void rsi_core_queue_pkt(struct rsi_common *common,
 			       struct sk_buff *skb)
 {
 	u8 q_num = skb->priority;
+
 	if (q_num >= NUM_SOFT_QUEUES) {
 		rsi_dbg(ERR_ZONE, "%s: Invalid Queue Number: q_num = %d\n",
 			__func__, q_num);
@@ -285,7 +288,7 @@ void rsi_core_qos_processor(struct rsi_common *common)
 		}
 
 		skb = rsi_core_dequeue_pkt(common, q_num);
-		if (skb == NULL) {
+		if (!skb) {
 			rsi_dbg(ERR_ZONE, "skb null\n");
 			mutex_unlock(&common->tx_rxlock);
 			break;
@@ -331,15 +334,16 @@ void rsi_core_xmit(struct rsi_common *common, struct sk_buff *skb)
 			__func__);
 		goto xmit_fail;
 	}
-	info = IEEE80211_SKB_CB(skb);
-	tx_params = (struct skb_info *)info->driver_data;
-	tmp_hdr = (struct ieee80211_hdr *)&skb->data[0];
 
 	if (common->fsm_state != FSM_MAC_INIT_DONE) {
 		rsi_dbg(ERR_ZONE, "%s: FSM state not open\n", __func__);
 		goto xmit_fail;
 	}
 
+	info = IEEE80211_SKB_CB(skb);
+	tx_params = (struct skb_info *)info->driver_data;
+	tmp_hdr = (struct ieee80211_hdr *)&skb->data[0];
+
 	if ((ieee80211_is_mgmt(tmp_hdr->frame_control)) ||
 	    (ieee80211_is_ctl(tmp_hdr->frame_control)) ||
 	    (ieee80211_is_qos_nullfunc(tmp_hdr->frame_control))) {
@@ -360,7 +364,7 @@ void rsi_core_xmit(struct rsi_common *common, struct sk_buff *skb)
 
 	if ((q_num != MGMT_SOFT_Q) &&
 	    ((skb_queue_len(&common->tx_queue[q_num]) + 1) >=
-	     DATA_QUEUE_WATER_MARK)) {
+		 DATA_QUEUE_WATER_MARK)) {
 		rsi_dbg(ERR_ZONE, "%s: sw queue full\n", __func__);
 		if (!ieee80211_queue_stopped(adapter->hw, WME_AC(q_num)))
 			ieee80211_stop_queue(adapter->hw, WME_AC(q_num));
diff --git a/drivers/net/wireless/rsi/rsi_91x_debugfs.c b/drivers/net/wireless/rsi/rsi_91x_debugfs.c
index 828a042..5ec7bce 100644
--- a/drivers/net/wireless/rsi/rsi_91x_debugfs.c
+++ b/drivers/net/wireless/rsi/rsi_91x_debugfs.c
@@ -59,7 +59,7 @@ static int rsi_sdio_stats_read(struct seq_file *seq, void *data)
 }
 
 /**
- * rsi_sdio_stats_open() - This funtion calls single open function of seq_file
+ * rsi_sdio_stats_open() - This function calls single open function of seq_file
  *			   to open file and read contents from it.
  * @inode: Pointer to the inode structure.
  * @file: Pointer to the file structure.
@@ -100,7 +100,7 @@ static int rsi_version_read(struct seq_file *seq, void *data)
 }
 
 /**
- * rsi_version_open() - This funtion calls single open function of seq_file to
+ * rsi_version_open() - This function calls single open function of seq_file to
  *			open file and read contents from it.
  * @inode: Pointer to the inode structure.
  * @file: Pointer to the file structure.
@@ -108,7 +108,7 @@ static int rsi_version_read(struct seq_file *seq, void *data)
  * Return: Pointer to the opened file status: 0 on success, ENOMEM on failure.
  */
 static int rsi_version_open(struct inode *inode,
-				 struct file *file)
+			    struct file *file)
 {
 	return single_open(file, rsi_version_read, inode->i_private);
 }
@@ -180,7 +180,7 @@ static int rsi_stats_read(struct seq_file *seq, void *data)
 }
 
 /**
- * rsi_stats_open() - This funtion calls single open function of seq_file to
+ * rsi_stats_open() - This function calls single open function of seq_file to
  *		      open file and read contents from it.
  * @inode: Pointer to the inode structure.
  * @file: Pointer to the file structure.
@@ -194,7 +194,8 @@ static int rsi_stats_open(struct inode *inode,
 }
 
 /**
- * rsi_debug_zone_read() - This function display the currently enabled debug zones.
+ * rsi_debug_zone_read() - This function display the currently
+ *			enabled debug zones.
  * @seq: Pointer to the sequence file structure.
  * @data: Pointer to the data.
  *
@@ -209,7 +210,7 @@ static int rsi_debug_zone_read(struct seq_file *seq, void *data)
 }
 
 /**
- * rsi_debug_read() - This funtion calls single open function of seq_file to
+ * rsi_debug_read() - This function calls single open function of seq_file to
  *		      open file and read contents from it.
  * @inode: Pointer to the inode structure.
  * @file: Pointer to the file structure.
diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index dbb2389..9c6fa61 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -194,6 +194,7 @@ static void rsi_register_rates_channels(struct rsi_hw *adapter, int band)
 void rsi_mac80211_detach(struct rsi_hw *adapter)
 {
 	struct ieee80211_hw *hw = adapter->hw;
+	int i;
 
 	if (hw) {
 		ieee80211_stop_queues(hw);
@@ -201,7 +202,17 @@ void rsi_mac80211_detach(struct rsi_hw *adapter)
 		ieee80211_free_hw(hw);
 	}
 
+	for (i = 0; i < 2; i++) {
+		struct ieee80211_supported_band *sbands = &adapter->sbands[i];
+
+		if (!sbands->channels)
+			kfree(sbands->channels);
+	}
+
+#ifdef CONFIG_RSI_DEBUGFS
 	rsi_remove_dbgfs(adapter);
+	kfree(adapter->dfsentry);
+#endif
 }
 EXPORT_SYMBOL_GPL(rsi_mac80211_detach);
 
@@ -429,9 +440,11 @@ static int rsi_mac80211_config(struct ieee80211_hw *hw,
 u16 rsi_get_connected_channel(struct rsi_hw *adapter)
 {
 	struct ieee80211_vif *vif = adapter->vifs[0];
+
 	if (vif) {
 		struct ieee80211_bss_conf *bss = &vif->bss_conf;
 		struct ieee80211_channel *channel = bss->chandef.chan;
+
 		return channel->hw_value;
 	}
 
@@ -667,15 +680,14 @@ static int rsi_mac80211_ampdu_action(struct ieee80211_hw *hw,
 				     struct ieee80211_vif *vif,
 				     struct ieee80211_ampdu_params *params)
 {
-	int status = -EOPNOTSUPP;
+	int status = 1;
 	struct rsi_hw *adapter = hw->priv;
 	struct rsi_common *common = adapter->priv;
-	u16 seq_no = 0;
+	u16 seq_no = params->ssn;
 	u8 ii = 0;
 	struct ieee80211_sta *sta = params->sta;
 	enum ieee80211_ampdu_mlme_action action = params->action;
 	u16 tid = params->tid;
-	u16 *ssn = &params->ssn;
 	u8 buf_size = params->buf_size;
 
 	for (ii = 0; ii < RSI_MAX_VIFS; ii++) {
@@ -684,28 +696,30 @@ static int rsi_mac80211_ampdu_action(struct ieee80211_hw *hw,
 	}
 
 	mutex_lock(&common->mutex);
-	rsi_dbg(INFO_ZONE, "%s: AMPDU action %d called\n", __func__, action);
-	if (ssn != NULL)
-		seq_no = *ssn;
 
 	switch (action) {
 	case IEEE80211_AMPDU_RX_START:
-		status = rsi_send_aggregation_params_frame(common,
-							   tid,
-							   seq_no,
-							   buf_size,
-							   STA_RX_ADDBA_DONE);
+		rsi_dbg(INFO_ZONE, "AMPDU action RX_START (%d)\n", action);
+		status = rsi_send_aggr_params_frame(common,
+						    tid,
+						    seq_no,
+						    buf_size,
+						    STA_RX_ADDBA_DONE);
 		break;
 
 	case IEEE80211_AMPDU_RX_STOP:
-		status = rsi_send_aggregation_params_frame(common,
-							   tid,
-							   0,
-							   buf_size,
-							   STA_RX_DELBA);
+		rsi_dbg(INFO_ZONE,
+			"AMPDU action RX_STOP (%d) called\n", action);
+		status = rsi_send_aggr_params_frame(common,
+						    tid,
+						    0,
+						    buf_size,
+						    STA_RX_DELBA);
 		break;
 
 	case IEEE80211_AMPDU_TX_START:
+		rsi_dbg(INFO_ZONE,
+			"AMPDU action TX_START (%d) called\n", action);
 		common->vif_info[ii].seq_start = seq_no;
 		ieee80211_start_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 		status = 0;
@@ -714,22 +728,27 @@ static int rsi_mac80211_ampdu_action(struct ieee80211_hw *hw,
 	case IEEE80211_AMPDU_TX_STOP_CONT:
 	case IEEE80211_AMPDU_TX_STOP_FLUSH:
 	case IEEE80211_AMPDU_TX_STOP_FLUSH_CONT:
-		status = rsi_send_aggregation_params_frame(common,
-							   tid,
-							   seq_no,
-							   buf_size,
-							   STA_TX_DELBA);
+		rsi_dbg(INFO_ZONE,
+			"AMPDU action TX_STOP_CONT / TX_STOP_FLUSH /"
+			" TX_STOP_FLUSH_CONT (%d) called\n", action);
+		status = rsi_send_aggr_params_frame(common,
+						    tid,
+						    seq_no,
+						    buf_size,
+						    STA_TX_DELBA);
 		if (!status)
 			ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 		break;
 
 	case IEEE80211_AMPDU_TX_OPERATIONAL:
-		status = rsi_send_aggregation_params_frame(common,
-							   tid,
-							   common->vif_info[ii]
-								.seq_start,
-							   buf_size,
-							   STA_TX_ADDBA_DONE);
+		rsi_dbg(INFO_ZONE,
+			"AMPDU action TX_OPERATIONAL(%d) called\n",
+			action);
+		status = rsi_send_aggr_params_frame(common,
+						tid,
+						common->vif_info[ii].seq_start,
+						buf_size,
+						STA_TX_ADDBA_DONE);
 		break;
 
 	default:
@@ -819,8 +838,6 @@ static void rsi_perform_cqm(struct rsi_common *common,
 	common->cqm_info.last_cqm_event_rssi = rssi;
 	rsi_dbg(INFO_ZONE, "CQM: Notifying event: %d\n", event);
 	ieee80211_cqm_rssi_notify(adapter->vifs[0], event, GFP_KERNEL);
-
-	return;
 }
 
 /**
@@ -875,16 +892,14 @@ static void rsi_fill_rx_status(struct ieee80211_hw *hw,
 	}
 
 	/* CQM only for connected AP beacons, the RSSI is a weighted avg */
-	if (bss->assoc && !(memcmp(bss->bssid, hdr->addr2, ETH_ALEN))) {
+	if (bss->assoc && ether_addr_equal(bss->bssid, hdr->addr2)) {
 		if (ieee80211_is_beacon(hdr->frame_control))
 			rsi_perform_cqm(common, hdr->addr2, rxs->signal);
 	}
-
-	return;
 }
 
 /**
- * rsi_indicate_pkt_to_os() - This function sends recieved packet to mac80211.
+ * rsi_indicate_pkt_to_os() - This function sends received packet to mac80211.
  * @common: Pointer to the driver private structure.
  * @skb: Pointer to the socket buffer structure.
  *
diff --git a/drivers/net/wireless/rsi/rsi_91x_main.c b/drivers/net/wireless/rsi/rsi_91x_main.c
index 8810862..f59a66a 100644
--- a/drivers/net/wireless/rsi/rsi_91x_main.c
+++ b/drivers/net/wireless/rsi/rsi_91x_main.c
@@ -86,7 +86,7 @@ static struct sk_buff *rsi_prepare_skb(struct rsi_common *common,
 
 	pkt_len -= extended_desc;
 	skb = dev_alloc_skb(pkt_len + FRAME_DESC_SZ);
-	if (skb == NULL)
+	if (!skb)
 		return NULL;
 
 	payload_offset = (extended_desc + FRAME_DESC_SZ);
@@ -111,11 +111,10 @@ static struct sk_buff *rsi_prepare_skb(struct rsi_common *common,
 int rsi_read_pkt(struct rsi_common *common, s32 rcv_pkt_len)
 {
 	u8 *frame_desc = NULL, extended_desc = 0;
-	u32 index, length = 0, queueno = 0;
+	u32 index = 0, length = 0, queueno = 0;
 	u16 actual_length = 0, offset;
 	struct sk_buff *skb = NULL;
 
-	index = 0;
 	do {
 		frame_desc = &common->rx_data_pkt[index];
 		actual_length = *(u16 *)&frame_desc[0];
@@ -131,7 +130,7 @@ int rsi_read_pkt(struct rsi_common *common, s32 rcv_pkt_len)
 					      (frame_desc + offset),
 					      length,
 					      extended_desc);
-			if (skb == NULL)
+			if (!skb)
 				goto fail;
 
 			rsi_indicate_pkt_to_os(common, skb);
@@ -198,15 +197,14 @@ struct rsi_hw *rsi_91x_init(void)
 		return NULL;
 
 	adapter->priv = kzalloc(sizeof(*common), GFP_KERNEL);
-	if (adapter->priv == NULL) {
-		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of memory\n",
+	if (!adapter->priv) {
+		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of priv\n",
 			__func__);
 		kfree(adapter);
 		return NULL;
-	} else {
-		common = adapter->priv;
-		common->priv = adapter;
 	}
+	common = adapter->priv;
+	common->priv = adapter;
 
 	for (ii = 0; ii < NUM_SOFT_QUEUES; ii++)
 		skb_queue_head_init(&common->tx_queue[ii]);
diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index 35c14cc..db96bd7 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -255,9 +255,9 @@ static int rsi_send_internal_mgmt_frame(struct rsi_common *common,
 {
 	struct skb_info *tx_params;
 
-	if (skb == NULL) {
+	if (!skb) {
 		rsi_dbg(ERR_ZONE, "%s: Unable to allocate skb\n", __func__);
-		return -ENOMEM;
+		return -EINVAL;
 	}
 	tx_params = (struct skb_info *)&IEEE80211_SKB_CB(skb)->driver_data;
 	tx_params->flags |= INTERNAL_MGMT_PKT;
@@ -290,12 +290,8 @@ static int rsi_load_radio_caps(struct rsi_common *common)
 	rsi_dbg(INFO_ZONE, "%s: Sending rate symbol req frame\n", __func__);
 
 	skb = dev_alloc_skb(sizeof(struct rsi_radio_caps));
-
-	if (!skb) {
-		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of skb\n",
-			__func__);
+	if (!skb)
 		return -ENOMEM;
-	}
 
 	memset(skb->data, 0, sizeof(struct rsi_radio_caps));
 	radio_caps = (struct rsi_radio_caps *)skb->data;
@@ -375,8 +371,8 @@ static int rsi_load_radio_caps(struct rsi_common *common)
  * rsi_mgmt_pkt_to_core() - This function is the entry point for Mgmt module.
  * @common: Pointer to the driver private structure.
  * @msg: Pointer to received packet.
- * @msg_len: Length of the recieved packet.
- * @type: Type of recieved packet.
+ * @msg_len: Length of the received packet.
+ * @type: Type of received packet.
  *
  * Return: 0 on success, -1 on failure.
  */
@@ -406,11 +402,8 @@ static int rsi_mgmt_pkt_to_core(struct rsi_common *common,
 		}
 
 		skb = dev_alloc_skb(msg_len);
-		if (!skb) {
-			rsi_dbg(ERR_ZONE, "%s: Failed to allocate skb\n",
-				__func__);
+		if (!skb)
 			return -ENOMEM;
-		}
 
 		buffer = skb_put(skb, msg_len);
 
@@ -425,9 +418,8 @@ static int rsi_mgmt_pkt_to_core(struct rsi_common *common,
 		rx_params->rssi = rsi_get_rssi(msg);
 		rx_params->channel = rsi_get_channel(msg);
 		rsi_indicate_pkt_to_os(common, skb);
-	} else {
+	} else
 		rsi_dbg(MGMT_TX_ZONE, "%s: Internal Packet\n", __func__);
-	}
 
 	return 0;
 }
@@ -459,12 +451,8 @@ static int rsi_hal_send_sta_notify_frame(struct rsi_common *common,
 	rsi_dbg(MGMT_TX_ZONE, "%s: Sending sta notify frame\n", __func__);
 
 	skb = dev_alloc_skb(sizeof(struct rsi_peer_notify));
-
-	if (!skb) {
-		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of skb\n",
-			__func__);
+	if (!skb)
 		return -ENOMEM;
-	}
 
 	memset(skb->data, 0, sizeof(struct rsi_peer_notify));
 	peer_notify = (struct rsi_peer_notify *)skb->data;
@@ -505,7 +493,7 @@ static int rsi_hal_send_sta_notify_frame(struct rsi_common *common,
 }
 
 /**
- * rsi_send_aggregation_params_frame() - This function sends the ampdu
+ * rsi_send_aggr_params_frame() - This function sends the ampdu
  *					 indication frame to firmware.
  * @common: Pointer to the driver private structure.
  * @tid: traffic identifier.
@@ -515,28 +503,26 @@ static int rsi_hal_send_sta_notify_frame(struct rsi_common *common,
  *
  * Return: 0 on success, corresponding negative error code on failure.
  */
-int rsi_send_aggregation_params_frame(struct rsi_common *common,
-				      u16 tid,
-				      u16 ssn,
-				      u8 buf_size,
-				      u8 event)
+int rsi_send_aggr_params_frame(struct rsi_common *common,
+			       u16 tid,
+			       u16 ssn,
+			       u8 buf_size,
+			       u8 event)
 {
 	struct sk_buff *skb = NULL;
 	struct rsi_mac_frame *mgmt_frame;
 	u8 peer_id = 0;
 
 	skb = dev_alloc_skb(FRAME_DESC_SZ);
-
-	if (!skb) {
-		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of skb\n",
-			__func__);
+	if (!skb)
 		return -ENOMEM;
-	}
 
 	memset(skb->data, 0, FRAME_DESC_SZ);
 	mgmt_frame = (struct rsi_mac_frame *)skb->data;
 
-	rsi_dbg(MGMT_TX_ZONE, "%s: Sending AMPDU indication frame\n", __func__);
+	rsi_dbg(MGMT_TX_ZONE,
+		"%s: Sending AMPDU indication frame\n",
+		__func__);
 
 	mgmt_frame->desc_word[0] = cpu_to_le16(RSI_WIFI_MGMT_Q << 12);
 	mgmt_frame->desc_word[1] = cpu_to_le16(AMPDU_IND);
@@ -545,7 +531,9 @@ int rsi_send_aggregation_params_frame(struct rsi_common *common,
 		mgmt_frame->desc_word[4] = cpu_to_le16(ssn);
 		mgmt_frame->desc_word[5] = cpu_to_le16(buf_size);
 		mgmt_frame->desc_word[7] =
-		cpu_to_le16((tid | (START_AMPDU_AGGR << 4) | (peer_id << 8)));
+			cpu_to_le16((tid |
+				    (START_AMPDU_AGGR << 4) |
+				    (peer_id << 8)));
 	} else if (event == STA_RX_ADDBA_DONE) {
 		mgmt_frame->desc_word[4] = cpu_to_le16(ssn);
 		mgmt_frame->desc_word[7] = cpu_to_le16(tid |
@@ -583,11 +571,8 @@ static int rsi_program_bb_rf(struct rsi_common *common)
 	rsi_dbg(MGMT_TX_ZONE, "%s: Sending program BB/RF frame\n", __func__);
 
 	skb = dev_alloc_skb(FRAME_DESC_SZ);
-	if (!skb) {
-		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of skb\n",
-			__func__);
+	if (!skb)
 		return -ENOMEM;
-	}
 
 	memset(skb->data, 0, FRAME_DESC_SZ);
 	mgmt_frame = (struct rsi_mac_frame *)skb->data;
@@ -605,6 +590,7 @@ static int rsi_program_bb_rf(struct rsi_common *common)
 	common->bb_rf_prog_count = 1;
 	mgmt_frame->desc_word[7] |= cpu_to_le16(PUT_BBP_RESET |
 				     BBP_REG_WRITE | (RSI_RF_TYPE << 4));
+
 	skb_put(skb, FRAME_DESC_SZ);
 
 	return rsi_send_internal_mgmt_frame(common, skb);
@@ -617,7 +603,8 @@ static int rsi_program_bb_rf(struct rsi_common *common)
  *
  * Return: 0 on success, corresponding negative error code on failure.
  */
-int rsi_set_vap_capabilities(struct rsi_common *common, enum opmode mode)
+int rsi_set_vap_capabilities(struct rsi_common *common,
+			     enum opmode mode)
 {
 	struct sk_buff *skb = NULL;
 	struct rsi_vap_caps *vap_caps;
@@ -626,14 +613,12 @@ int rsi_set_vap_capabilities(struct rsi_common *common, enum opmode mode)
 	struct ieee80211_conf *conf = &hw->conf;
 	u16 vap_id = 0;
 
-	rsi_dbg(MGMT_TX_ZONE, "%s: Sending VAP capabilities frame\n", __func__);
+	rsi_dbg(MGMT_TX_ZONE,
+		"%s: Sending VAP capabilities frame\n", __func__);
 
 	skb = dev_alloc_skb(sizeof(struct rsi_vap_caps));
-	if (!skb) {
-		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of skb\n",
-			__func__);
+	if (!skb)
 		return -ENOMEM;
-	}
 
 	memset(skb->data, 0, sizeof(struct rsi_vap_caps));
 	vap_caps = (struct rsi_vap_caps *)skb->data;
@@ -705,11 +690,8 @@ int rsi_hal_load_key(struct rsi_common *common,
 	rsi_dbg(MGMT_TX_ZONE, "%s: Sending load key frame\n", __func__);
 
 	skb = dev_alloc_skb(sizeof(struct rsi_set_key));
-	if (!skb) {
-		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of skb\n",
-			__func__);
+	if (!skb)
 		return -ENOMEM;
-	}
 
 	memset(skb->data, 0, sizeof(struct rsi_set_key));
 	set_key = (struct rsi_set_key *)skb->data;
@@ -736,13 +718,10 @@ int rsi_hal_load_key(struct rsi_common *common,
 	set_key->desc_word[4] = cpu_to_le16(key_descriptor);
 
 	if ((cipher == WLAN_CIPHER_SUITE_WEP40) ||
-	    (cipher == WLAN_CIPHER_SUITE_WEP104)) {
-		memcpy(&set_key->key[key_id][1],
-		       data,
-		       key_len * 2);
-	} else {
+	    (cipher == WLAN_CIPHER_SUITE_WEP104))
+		memcpy(&set_key->key[key_id][1], data, key_len * 2);
+	else
 		memcpy(&set_key->key[0][0], data, key_len);
-	}
 
 	memcpy(set_key->tx_mic_key, &data[16], 8);
 	memcpy(set_key->rx_mic_key, &data[24], 8);
@@ -765,11 +744,8 @@ static int rsi_load_bootup_params(struct rsi_common *common)
 
 	rsi_dbg(MGMT_TX_ZONE, "%s: Sending boot params frame\n", __func__);
 	skb = dev_alloc_skb(sizeof(struct rsi_boot_params));
-	if (!skb) {
-		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of skb\n",
-			__func__);
+	if (!skb)
 		return -ENOMEM;
-	}
 
 	memset(skb->data, 0, sizeof(struct rsi_boot_params));
 	boot_params = (struct rsi_boot_params *)skb->data;
@@ -780,7 +756,8 @@ static int rsi_load_bootup_params(struct rsi_common *common)
 		memcpy(&boot_params->bootup_params,
 		       &boot_params_40,
 		       sizeof(struct bootup_params));
-		rsi_dbg(MGMT_TX_ZONE, "%s: Packet 40MHZ <=== %d\n", __func__,
+		rsi_dbg(MGMT_TX_ZONE,
+			"%s: Packet 40MHZ <=== %d\n", __func__,
 			UMAC_CLK_40BW);
 		boot_params->desc_word[7] = cpu_to_le16(UMAC_CLK_40BW);
 	} else {
@@ -828,11 +805,8 @@ static int rsi_send_reset_mac(struct rsi_common *common)
 	rsi_dbg(MGMT_TX_ZONE, "%s: Sending reset MAC frame\n", __func__);
 
 	skb = dev_alloc_skb(FRAME_DESC_SZ);
-	if (!skb) {
-		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of skb\n",
-			__func__);
+	if (!skb)
 		return -ENOMEM;
-	}
 
 	memset(skb->data, 0, FRAME_DESC_SZ);
 	mgmt_frame = (struct rsi_mac_frame *)skb->data;
@@ -919,11 +893,8 @@ int rsi_set_channel(struct rsi_common *common, u16 channel)
 		"%s: Sending scan req frame\n", __func__);
 
 	skb = dev_alloc_skb(FRAME_DESC_SZ);
-	if (!skb) {
-		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of skb\n",
-			__func__);
+	if (!skb)
 		return -ENOMEM;
-	}
 
 	memset(skb->data, 0, FRAME_DESC_SZ);
 	mgmt_frame = (struct rsi_mac_frame *)skb->data;
@@ -980,6 +951,7 @@ static int rsi_compare(const void *a, const void *b)
 static bool rsi_map_rates(u16 rate, int *offset)
 {
 	int kk;
+
 	for (kk = 0; kk < ARRAY_SIZE(rsi_mcsrates); kk++) {
 		if (rate == mcs[kk]) {
 			*offset = kk;
@@ -1013,20 +985,14 @@ static int rsi_send_auto_rate_request(struct rsi_common *common)
 	u8 num_supported_rates = 0;
 	u8 rate_table_offset, rate_offset = 0;
 	u32 rate_bitmap = common->bitrate_mask[band];
-
 	u16 *selected_rates, min_rate;
 
 	skb = dev_alloc_skb(sizeof(struct rsi_auto_rate));
-	if (!skb) {
-		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of skb\n",
-			__func__);
+	if (!skb)
 		return -ENOMEM;
-	}
 
 	selected_rates = kzalloc(2 * RSI_TBL_SZ, GFP_KERNEL);
 	if (!selected_rates) {
-		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of mem\n",
-			__func__);
 		dev_kfree_skb(skb);
 		return -ENOMEM;
 	}
@@ -1140,14 +1106,17 @@ void rsi_inform_bss_status(struct rsi_common *common,
 			   u16 aid)
 {
 	if (status) {
+		common->hw_data_qs_blocked = true;
 		rsi_hal_send_sta_notify_frame(common,
 					      RSI_IFTYPE_STATION,
 					      STA_CONNECTED,
 					      bssid,
 					      qos_enable,
 					      aid);
-		if (common->min_rate == 0xffff)
+		if (common->min_rate == 0xffff) {
+			rsi_dbg(INFO_ZONE, "Send auto rate request\n");
 			rsi_send_auto_rate_request(common);
+		}
 	} else {
 		rsi_hal_send_sta_notify_frame(common,
 					      RSI_IFTYPE_STATION,
@@ -1170,14 +1139,12 @@ static int rsi_eeprom_read(struct rsi_common *common)
 	struct rsi_mac_frame *mgmt_frame;
 	struct sk_buff *skb;
 
-	rsi_dbg(MGMT_TX_ZONE, "%s: Sending EEPROM read req frame\n", __func__);
+	rsi_dbg(MGMT_TX_ZONE,
+		"%s: Sending EEPROM read req frame\n", __func__);
 
 	skb = dev_alloc_skb(FRAME_DESC_SZ);
-	if (!skb) {
-		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of skb\n",
-			__func__);
+	if (!skb)
 		return -ENOMEM;
-	}
 
 	memset(skb->data, 0, FRAME_DESC_SZ);
 	mgmt_frame = (struct rsi_mac_frame *)skb->data;
@@ -1214,11 +1181,8 @@ int rsi_send_block_unblock_frame(struct rsi_common *common, bool block_event)
 	rsi_dbg(MGMT_TX_ZONE, "%s: Sending block/unblock frame\n", __func__);
 
 	skb = dev_alloc_skb(FRAME_DESC_SZ);
-	if (!skb) {
-		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of skb\n",
-			__func__);
+	if (!skb)
 		return -ENOMEM;
-	}
 
 	memset(skb->data, 0, FRAME_DESC_SZ);
 	mgmt_frame = (struct rsi_mac_frame *)skb->data;
@@ -1261,9 +1225,8 @@ static int rsi_handle_ta_confirm_type(struct rsi_common *common,
 			if (rsi_eeprom_read(common)) {
 				common->fsm_state = FSM_CARD_NOT_READY;
 				goto out;
-			} else {
+			} else
 				common->fsm_state = FSM_EEPROM_READ_MAC_ADDR;
-			}
 		} else {
 			rsi_dbg(INFO_ZONE,
 				"%s: Received bootup params cfm in %d state\n",
@@ -1273,6 +1236,9 @@ static int rsi_handle_ta_confirm_type(struct rsi_common *common,
 		break;
 
 	case EEPROM_READ_TYPE:
+		rsi_dbg(FSM_ZONE,
+			"%s: EEPROM READ confirm received\n",
+			__func__);
 		if (common->fsm_state == FSM_EEPROM_READ_MAC_ADDR) {
 			if (msg[16] == MAGIC_WORD) {
 				u8 offset = (FRAME_DESC_SZ + WLAN_HOST_MODE_LEN
@@ -1324,7 +1290,8 @@ static int rsi_handle_ta_confirm_type(struct rsi_common *common,
 				goto out;
 			} else {
 				common->fsm_state = FSM_BB_RF_PROG_SENT;
-				rsi_dbg(FSM_ZONE, "%s: Radio cap cfm received\n",
+				rsi_dbg(FSM_ZONE,
+					"%s: Radio cap cfm received\n",
 					__func__);
 			}
 		} else {
@@ -1347,27 +1314,29 @@ static int rsi_handle_ta_confirm_type(struct rsi_common *common,
 			}
 		} else {
 			rsi_dbg(INFO_ZONE,
-				"%s: Received bbb_rf cfm in %d state\n",
+				"%s: Received bb_rf cfm in %d state\n",
 				 __func__, common->fsm_state);
 			return 0;
 		}
 		break;
 
 	default:
-		rsi_dbg(INFO_ZONE, "%s: Invalid TA confirm pkt received\n",
+		rsi_dbg(INFO_ZONE,
+			"%s: Invalid TA confirm pkt received\n",
 			__func__);
 		break;
 	}
 	return 0;
 out:
-	rsi_dbg(ERR_ZONE, "%s: Unable to send pkt/Invalid frame received\n",
+	rsi_dbg(ERR_ZONE,
+		"%s: Unable to send pkt/Invalid frame received\n",
 		__func__);
 	return -EINVAL;
 }
 
 /**
  * rsi_mgmt_pkt_recv() - This function processes the management packets
- *			 recieved from the hardware.
+ *			 received from the hardware.
  * @common: Pointer to the driver private structure.
  * @msg: Pointer to the received packet.
  *
@@ -1376,7 +1345,7 @@ out:
 int rsi_mgmt_pkt_recv(struct rsi_common *common, u8 *msg)
 {
 	s32 msg_len = (le16_to_cpu(*(__le16 *)&msg[0]) & 0x0fff);
-	u16 msg_type = (msg[2]);
+	u16 msg_type = msg[2];
 	int ret;
 
 	rsi_dbg(FSM_ZONE, "%s: Msg Len: %d, Msg Type: %4x\n",
@@ -1404,8 +1373,8 @@ int rsi_mgmt_pkt_recv(struct rsi_common *common, u8 *msg)
 			rsi_dbg(FSM_ZONE, "%s: Probe confirm received\n",
 				__func__);
 		}
-	} else {
+	} else
 		return rsi_mgmt_pkt_to_core(common, msg, msg_len, msg_type);
-	}
+
 	return 0;
 }
diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index 8428858..331865b 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -1,6 +1,8 @@
 /**
  * Copyright (c) 2014 Redpine Signals Inc.
  *
+ * Developers:
+ *		Fariya Fathima	2014 <fariya.f@redpinesignals.com>
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
  * copyright notice and this permission notice appear in all copies.
@@ -128,7 +130,7 @@ static int rsi_issue_sdiocommand(struct sdio_func *func,
 }
 
 /**
- * rsi_handle_interrupt() - This function is called upon the occurence
+ * rsi_handle_interrupt() - This function is called upon the occurrence
  *			    of an interrupt.
  * @function: Pointer to the sdio_func structure.
  *
@@ -183,7 +185,7 @@ static void rsi_reset_card(struct sdio_func *pfunction)
 	host->ios.timing = MMC_TIMING_LEGACY;
 	host->ops->set_ios(host, &host->ios);
 
-	/*
+	/**
 	 * This delay should be sufficient to allow the power supply
 	 * to reach the minimum voltage.
 	 */
@@ -193,7 +195,7 @@ static void rsi_reset_card(struct sdio_func *pfunction)
 	host->ios.power_mode = MMC_POWER_ON;
 	host->ops->set_ios(host, &host->ios);
 
-	/*
+	/**
 	 * This delay must be at least 74 clock sizes, or 1 ms, or the
 	 * time required to reach a stable voltage.
 	 */
@@ -361,6 +363,7 @@ static int rsi_setblocklength(struct rsi_hw *adapter, u32 length)
 	struct rsi_91x_sdiodev *dev =
 		(struct rsi_91x_sdiodev *)adapter->rsi_dev;
 	int status;
+
 	rsi_dbg(INIT_ZONE, "%s: Setting the block length\n", __func__);
 
 	status = sdio_set_block_size(dev->pfunction, length);
@@ -464,6 +467,7 @@ int rsi_sdio_write_register(struct rsi_hw *adapter,
 void rsi_sdio_ack_intr(struct rsi_hw *adapter, u8 int_bit)
 {
 	int status;
+
 	status = rsi_sdio_write_register(adapter,
 					 1,
 					 (SDIO_FUN1_INTR_CLR_REG |
@@ -473,8 +477,6 @@ void rsi_sdio_ack_intr(struct rsi_hw *adapter, u8 int_bit)
 		rsi_dbg(ERR_ZONE, "%s: unable to send ack\n", __func__);
 }
 
-
-
 /**
  * rsi_sdio_read_register_multiple() - This function read multiple bytes of
  *				       information from the SD card.
@@ -667,7 +669,7 @@ static int rsi_init_sdio_interface(struct rsi_hw *adapter,
 		goto fail;
 	}
 
-	rsi_dbg(INIT_ZONE, "%s: Setup card succesfully\n", __func__);
+	rsi_dbg(INIT_ZONE, "%s: Setup card successfully\n", __func__);
 
 	status = rsi_init_sdio_slave_regs(adapter);
 	if (status) {
diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
index 40d7231..ae42391 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
@@ -252,11 +252,8 @@ static int rsi_process_pkt(struct rsi_common *common)
 	rcv_pkt_len = (num_blks * 256);
 
 	common->rx_data_pkt = kmalloc(rcv_pkt_len, GFP_KERNEL);
-	if (!common->rx_data_pkt) {
-		rsi_dbg(ERR_ZONE, "%s: Failed in memory allocation\n",
-			__func__);
+	if (!common->rx_data_pkt)
 		return -ENOMEM;
-	}
 
 	status = rsi_sdio_host_intf_read_pkt(adapter,
 					     common->rx_data_pkt,
@@ -426,8 +423,8 @@ void rsi_interrupt_handler(struct rsi_hw *adapter)
 					"%s: ==> FIRMWARE Assert <==\n",
 					__func__);
 				status = rsi_sdio_read_register(common->priv,
-							SDIO_FW_STATUS_REG,
-							&fw_status);
+								SDIO_FW_STATUS_REG,
+								&fw_status);
 				if (status) {
 					rsi_dbg(ERR_ZONE,
 						"%s: Failed to read f/w reg\n",
@@ -435,7 +432,7 @@ void rsi_interrupt_handler(struct rsi_hw *adapter)
 				} else {
 					rsi_dbg(ERR_ZONE,
 						"%s: Firmware Status is 0x%x\n",
-						__func__ , fw_status);
+						__func__, fw_status);
 					rsi_sdio_ack_intr(common->priv,
 							  (1 << FW_ASSERT_IND));
 				}
diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index ef5d394..2b322e5 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -1,6 +1,9 @@
 /**
  * Copyright (c) 2014 Redpine Signals Inc.
  *
+ * Developers:
+ *	Prameela Rani Garnepudi	2016 <prameela.garnepudi@redpinesignals.com>
+ *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
  * copyright notice and this permission notice appear in all copies.
@@ -43,7 +46,6 @@ static int rsi_usb_card_write(struct rsi_hw *adapter,
 			      len,
 			      &transfer,
 			      HZ * 5);
-
 	if (status < 0) {
 		rsi_dbg(ERR_ZONE,
 			"Card write failed with error code :%10d\n", status);
@@ -275,11 +277,11 @@ static int rsi_rx_urb_submit(struct rsi_hw *adapter)
 
 /**
  * rsi_usb_write_register_multiple() - This function writes multiple bytes of
- *				       information to multiple registers.
- * @adapter: Pointer to the adapter structure.
- * @addr: Address of the register.
- * @data: Pointer to the data that has to be written.
- * @count: Number of multiple bytes to be written on to the registers.
+ *				       information to the given address.
+ * @adapter:	Pointer to the adapter structure.
+ * @addr:	Address of the register.
+ * @data:	Pointer to the data that has to be written.
+ * @count:	Number of multiple bytes to be written on to the registers.
  *
  * Return: status: 0 on success, a negative error code on failure.
  */
@@ -392,11 +394,8 @@ static int rsi_init_usb_interface(struct rsi_hw *adapter,
 	usb_set_intfdata(pfunction, adapter);
 
 	common->rx_data_pkt = kmalloc(2048, GFP_KERNEL);
-	if (!common->rx_data_pkt) {
-		rsi_dbg(ERR_ZONE, "%s: Failed to allocate memory\n",
-			__func__);
+	if (!common->rx_data_pkt)
 		return -ENOMEM;
-	}
 
 	rsi_dev->tx_buffer = kmalloc(2048, GFP_KERNEL);
 	if (!rsi_dev->tx_buffer) {
@@ -568,7 +567,20 @@ static struct usb_driver rsi_driver = {
 #endif
 };
 
-module_usb_driver(rsi_driver);
+static int __init rsi_usb_module_init(void)
+{
+	rsi_dbg(INIT_ZONE,
+		"=====> RSI USB Module Initialize <=====\n");
+	return usb_register(&rsi_driver);
+}
+
+static void __exit rsi_usb_module_exit(void)
+{
+	usb_deregister(&rsi_driver);
+}
+
+module_init(rsi_usb_module_init);
+module_exit(rsi_usb_module_exit);
 
 MODULE_AUTHOR("Redpine Signals Inc");
 MODULE_DESCRIPTION("Common USB layer for RSI drivers");
diff --git a/drivers/net/wireless/rsi/rsi_common.h b/drivers/net/wireless/rsi/rsi_common.h
index d3fbe33..ad1be13 100644
--- a/drivers/net/wireless/rsi/rsi_common.h
+++ b/drivers/net/wireless/rsi/rsi_common.h
@@ -38,7 +38,7 @@ static inline int rsi_wait_event(struct rsi_event *event, u32 timeout)
 
 	if (!timeout)
 		status = wait_event_interruptible(event->event_queue,
-				(atomic_read(&event->event_condition) == 0));
+				(!atomic_read(&event->event_condition)));
 	else
 		status = wait_event_interruptible_timeout(event->event_queue,
 				(atomic_read(&event->event_condition) == 0),
diff --git a/drivers/net/wireless/rsi/rsi_debugfs.h b/drivers/net/wireless/rsi/rsi_debugfs.h
index 580ad3b..8b64944 100644
--- a/drivers/net/wireless/rsi/rsi_debugfs.h
+++ b/drivers/net/wireless/rsi/rsi_debugfs.h
@@ -23,12 +23,10 @@
 #ifndef CONFIG_RSI_DEBUGFS
 static inline int rsi_init_dbgfs(struct rsi_hw *adapter)
 {
-	return 0;
 }
 
 static inline void rsi_remove_dbgfs(struct rsi_hw *adapter)
 {
-	return;
 }
 #else
 struct rsi_dbg_files {
@@ -42,6 +40,7 @@ struct rsi_debugfs {
 	struct rsi_dbg_ops *dfs_get_ops;
 	struct dentry *rsi_files[MAX_DEBUGFS_ENTRIES];
 };
+
 int rsi_init_dbgfs(struct rsi_hw *adapter);
 void rsi_remove_dbgfs(struct rsi_hw *adapter);
 #endif
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index dcd0957..cde1a75 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -21,23 +21,25 @@
 #include <linux/skbuff.h>
 #include <net/mac80211.h>
 
-#define ERR_ZONE                        BIT(0)  /* For Error Msgs             */
-#define INFO_ZONE                       BIT(1)  /* For General Status Msgs    */
-#define INIT_ZONE                       BIT(2)  /* For Driver Init Seq Msgs   */
-#define MGMT_TX_ZONE                    BIT(3)  /* For TX Mgmt Path Msgs      */
-#define MGMT_RX_ZONE                    BIT(4)  /* For RX Mgmt Path Msgs      */
-#define DATA_TX_ZONE                    BIT(5)  /* For TX Data Path Msgs      */
-#define DATA_RX_ZONE                    BIT(6)  /* For RX Data Path Msgs      */
-#define FSM_ZONE                        BIT(7)  /* For State Machine Msgs     */
-#define ISR_ZONE                        BIT(8)  /* For Interrupt Msgs         */
+#define ERR_ZONE                        BIT(0) /* Error Msgs		*/
+#define INFO_ZONE                       BIT(1) /* General Debug Msgs	*/
+#define INIT_ZONE                       BIT(2) /* Driver Init Msgs	*/
+#define MGMT_TX_ZONE                    BIT(3) /* TX Mgmt Path Msgs	*/
+#define MGMT_RX_ZONE                    BIT(4) /* RX Mgmt Path Msgs	*/
+#define DATA_TX_ZONE                    BIT(5) /* TX Data Path Msgs	*/
+#define DATA_RX_ZONE                    BIT(6) /* RX Data Path Msgs	*/
+#define FSM_ZONE                        BIT(7) /* State Machine Msgs	*/
+#define ISR_ZONE                        BIT(8) /* Interrupt Msgs	*/
 
 #define FSM_CARD_NOT_READY              0
-#define FSM_BOOT_PARAMS_SENT            1
-#define FSM_EEPROM_READ_MAC_ADDR        2
-#define FSM_RESET_MAC_SENT              3
-#define FSM_RADIO_CAPS_SENT             4
-#define FSM_BB_RF_PROG_SENT             5
-#define FSM_MAC_INIT_DONE               6
+#define FSM_COMMON_DEV_PARAMS_SENT	1
+#define FSM_BOOT_PARAMS_SENT            2
+#define FSM_EEPROM_READ_MAC_ADDR        3
+#define FSM_EEPROM_READ_RF_TYPE		4
+#define FSM_RESET_MAC_SENT              5
+#define FSM_RADIO_CAPS_SENT             6
+#define FSM_BB_RF_PROG_SENT             7
+#define FSM_MAC_INIT_DONE               8
 
 extern u32 rsi_zone_enabled;
 extern __printf(2, 3) void rsi_dbg(u32 zone, const char *fmt, ...);
@@ -206,12 +208,14 @@ struct rsi_common {
 	bool hw_data_qs_blocked;
 };
 
+#define IEEE80211_NUM_BANDS 2
+
 struct rsi_hw {
 	struct rsi_common *priv;
 	struct ieee80211_hw *hw;
 	struct ieee80211_vif *vifs[RSI_MAX_VIFS];
 	struct ieee80211_tx_queue_params edca_params[NUM_EDCA_QUEUES];
-	struct ieee80211_supported_band sbands[NUM_NL80211_BANDS];
+	struct ieee80211_supported_band sbands[IEEE80211_NUM_BANDS];
 
 	struct device *device;
 	u8 sc_nvifs;
diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index 3741173..ed3aa83 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -71,31 +71,31 @@
 #define RSI_ENABLE_40MHZ                (0x1 << 3)
 #define ENABLE_SHORTGI_RATE		BIT(9)
 
-#define RX_BA_INDICATION                1
-#define RSI_TBL_SZ                      40
-#define MAX_RETRIES                     8
+#define RX_BA_INDICATION		1
+#define RSI_TBL_SZ			40
+#define MAX_RETRIES			8
 #define RSI_IFTYPE_STATION		 0
 
-#define STD_RATE_MCS7                   0x07
-#define STD_RATE_MCS6                   0x06
-#define STD_RATE_MCS5                   0x05
-#define STD_RATE_MCS4                   0x04
-#define STD_RATE_MCS3                   0x03
-#define STD_RATE_MCS2                   0x02
-#define STD_RATE_MCS1                   0x01
-#define STD_RATE_MCS0                   0x00
-#define STD_RATE_54                     0x6c
-#define STD_RATE_48                     0x60
-#define STD_RATE_36                     0x48
-#define STD_RATE_24                     0x30
-#define STD_RATE_18                     0x24
-#define STD_RATE_12                     0x18
-#define STD_RATE_11                     0x16
-#define STD_RATE_09                     0x12
-#define STD_RATE_06                     0x0C
-#define STD_RATE_5_5                    0x0B
-#define STD_RATE_02                     0x04
-#define STD_RATE_01                     0x02
+#define STD_RATE_MCS7			0x07
+#define STD_RATE_MCS6			0x06
+#define STD_RATE_MCS5			0x05
+#define STD_RATE_MCS4			0x04
+#define STD_RATE_MCS3			0x03
+#define STD_RATE_MCS2			0x02
+#define STD_RATE_MCS1			0x01
+#define STD_RATE_MCS0			0x00
+#define STD_RATE_54			0x6c
+#define STD_RATE_48			0x60
+#define STD_RATE_36			0x48
+#define STD_RATE_24			0x30
+#define STD_RATE_18			0x24
+#define STD_RATE_12			0x18
+#define STD_RATE_11			0x16
+#define STD_RATE_09			0x12
+#define STD_RATE_06			0x0C
+#define STD_RATE_5_5			0x0B
+#define STD_RATE_02			0x04
+#define STD_RATE_01			0x02
 
 #define RSI_RF_TYPE                     1
 #define RSI_RATE_00                     0x00
@@ -173,9 +173,9 @@ enum cmd_frame_type {
 	AUTO_RATE_IND,
 	BOOTUP_PARAMS_REQUEST,
 	VAP_CAPABILITIES,
-	EEPROM_READ_TYPE ,
+	EEPROM_READ_TYPE,
 	EEPROM_WRITE,
-	GPIO_PIN_CONFIG ,
+	GPIO_PIN_CONFIG,
 	SET_RX_FILTER,
 	AMPDU_IND,
 	STATS_REQUEST_FRAME,
@@ -288,8 +288,8 @@ static inline u8 rsi_get_channel(u8 *addr)
 
 int rsi_mgmt_pkt_recv(struct rsi_common *common, u8 *msg);
 int rsi_set_vap_capabilities(struct rsi_common *common, enum opmode mode);
-int rsi_send_aggregation_params_frame(struct rsi_common *common, u16 tid,
-				      u16 ssn, u8 buf_size, u8 event);
+int rsi_send_aggr_params_frame(struct rsi_common *common, u16 tid,
+			       u16 ssn, u8 buf_size, u8 event);
 int rsi_hal_load_key(struct rsi_common *common, u8 *data, u16 key_len,
 		     u8 key_type, u8 key_id, u32 cipher);
 int rsi_set_channel(struct rsi_common *common, u16 chno);
diff --git a/drivers/net/wireless/rsi/rsi_sdio.h b/drivers/net/wireless/rsi/rsi_sdio.h
index c7e8f2b..33a657c 100644
--- a/drivers/net/wireless/rsi/rsi_sdio.h
+++ b/drivers/net/wireless/rsi/rsi_sdio.h
@@ -37,17 +37,17 @@ enum sdio_interrupt_type {
 };
 
 /* Buffer status register related info */
-#define PKT_BUFF_SEMI_FULL                      0
-#define PKT_BUFF_FULL                           1
-#define PKT_MGMT_BUFF_FULL                      2
-#define MSDU_PKT_PENDING                        3
+#define PKT_BUFF_SEMI_FULL			0
+#define PKT_BUFF_FULL				1
+#define PKT_MGMT_BUFF_FULL			2
+#define MSDU_PKT_PENDING			3
 /* Interrupt Bit Related Macros */
-#define PKT_BUFF_AVAILABLE                      1
-#define FW_ASSERT_IND                           2
+#define PKT_BUFF_AVAILABLE			1
+#define FW_ASSERT_IND				2
 
-#define RSI_DEVICE_BUFFER_STATUS_REGISTER       0xf3
-#define RSI_FN1_INT_REGISTER                    0xf9
-#define RSI_SD_REQUEST_MASTER                   0x10000
+#define RSI_DEVICE_BUFFER_STATUS_REGISTER	0xf3
+#define RSI_FN1_INT_REGISTER			0xf9
+#define RSI_SD_REQUEST_MASTER			0x10000
 
 /* FOR SD CARD ONLY */
 #define SDIO_RX_NUM_BLOCKS_REG                  0x000F1
-- 
2.4.11
