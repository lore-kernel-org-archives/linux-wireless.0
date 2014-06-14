Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:32796 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591AbaFNNz4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Jun 2014 09:55:56 -0400
Received: by mail-pb0-f44.google.com with SMTP id md12so2184386pbc.3
        for <linux-wireless@vger.kernel.org>; Sat, 14 Jun 2014 06:55:56 -0700 (PDT)
Received: from localhost.localdomain ([115.248.87.14])
        by mx.google.com with ESMTPSA id ox3sm9006665pbb.88.2014.06.14.06.55.54
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Sat, 14 Jun 2014 06:55:55 -0700 (PDT)
From: Jahnavi Meher <jahnavi.meher@gmail.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH 15/16] rsi: Adding support for host based bgscan.
Date: Sat, 14 Jun 2014 19:25:46 +0530
Message-Id: <1402754146-14290-1-git-send-email-jahnavi.meher@gmail.com> (sfid-20140614_155600_082388_4FDCB1D4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Added support for host based bgscan. The h/w queues are blocked
while bgscan is being performed and after coming to the connected
channel, the queues are unblocked.

Signed-off-by: Jahnavi Meher <jahnavi.meher@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c |  117 ++++++++++++++++++++++++---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     |   43 ++++++++++
 drivers/net/wireless/rsi/rsi_main.h         |    9 ++
 drivers/net/wireless/rsi/rsi_mgmt.h         |    3 +-
 4 files changed, 160 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index 4700714..1cb3164 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -341,6 +341,59 @@ static void rsi_mac80211_remove_interface(struct ieee80211_hw *hw,
 }
 
 /**
+ * rsi_channel_change() - This function is a performs the checks
+ *			  required for changing a channel and sets
+ *			  the channel accordingly.
+ * @hw: Pointer to the ieee80211_hw structure.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+static int rsi_channel_change(struct ieee80211_hw *hw)
+{
+	struct rsi_hw *adapter = hw->priv;
+	struct rsi_common *common = adapter->priv;
+	int status = -EOPNOTSUPP;
+	struct ieee80211_channel *curchan = hw->conf.chandef.chan;
+	u16 channel = curchan->hw_value;
+	struct ieee80211_bss_conf *bss = &adapter->vifs[0]->bss_conf;
+
+	rsi_dbg(INFO_ZONE,
+		"%s: Set channel: %d MHz type: %d channel_no %d\n",
+		__func__, curchan->center_freq,
+		curchan->flags, channel);
+
+	if (bss->assoc) {
+		if (!common->hw_data_qs_blocked &&
+		    (rsi_get_connected_channel(adapter) != channel)) {
+			rsi_dbg(INFO_ZONE, "blk data q %d\n", channel);
+			if (!rsi_send_block_unblock_frame(common, true))
+				common->hw_data_qs_blocked = true;
+		}
+	}
+
+	status = rsi_band_check(common);
+	if (!status)
+		status = rsi_set_channel(adapter->priv, channel);
+
+	if (bss->assoc) {
+		if (common->hw_data_qs_blocked &&
+		    (rsi_get_connected_channel(adapter) == channel)) {
+			rsi_dbg(INFO_ZONE, "unblk data q %d\n", channel);
+			if (!rsi_send_block_unblock_frame(common, false))
+				common->hw_data_qs_blocked = false;
+		}
+	} else {
+		if (common->hw_data_qs_blocked) {
+			rsi_dbg(INFO_ZONE, "unblk data q %d\n", channel);
+			if (!rsi_send_block_unblock_frame(common, false))
+				common->hw_data_qs_blocked = false;
+		}
+	}
+
+	return status;
+}
+
+/**
  * rsi_mac80211_config() - This function is a handler for configuration
  *			   requests. The stack calls this function to
  *			   change hardware configuration, e.g., channel.
@@ -357,17 +410,10 @@ static int rsi_mac80211_config(struct ieee80211_hw *hw,
 	int status = -EOPNOTSUPP;
 
 	mutex_lock(&common->mutex);
-	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
-		struct ieee80211_channel *curchan = hw->conf.chandef.chan;
-		u16 channel = curchan->hw_value;
-
-		rsi_dbg(INFO_ZONE,
-			"%s: Set channel: %d MHz type: %d channel_no %d\n",
-			__func__, curchan->center_freq,
-			curchan->flags, channel);
-		common->band = curchan->band;
-		status = rsi_set_channel(adapter->priv, channel);
-	}
+
+	if (changed & IEEE80211_CONF_CHANGE_CHANNEL)
+		status = rsi_channel_change(hw);
+
 	mutex_unlock(&common->mutex);
 
 	return status;
@@ -421,6 +467,15 @@ static void rsi_mac80211_bss_info_changed(struct ieee80211_hw *hw,
 				      bss_conf->qos,
 				      bss_conf->aid);
 	}
+
+	if (changed & BSS_CHANGED_CQM) {
+		common->cqm_info.last_cqm_event_rssi = 0;
+		common->cqm_info.rssi_thold = bss_conf->cqm_rssi_thold;
+		common->cqm_info.rssi_hyst = bss_conf->cqm_rssi_hyst;
+		rsi_dbg(INFO_ZONE, "RSSI throld & hysteresis are: %d %d\n",
+			common->cqm_info.rssi_thold,
+			common->cqm_info.rssi_hyst);
+	}
 	mutex_unlock(&common->mutex);
 }
 
@@ -741,6 +796,37 @@ static int rsi_mac80211_set_rate_mask(struct ieee80211_hw *hw,
 }
 
 /**
+ * rsi_perform_cqm() - This function performs cqm.
+ * @common: Pointer to the driver private structure.
+ * @bssid: pointer to the bssid.
+ * @rssi: RSSI value.
+ */
+static void rsi_perform_cqm(struct rsi_common *common,
+			    u8 *bssid,
+			    s8 rssi)
+{
+	struct rsi_hw *adapter = common->priv;
+	s8 last_event = common->cqm_info.last_cqm_event_rssi;
+	int thold = common->cqm_info.rssi_thold;
+	u32 hyst = common->cqm_info.rssi_hyst;
+	enum nl80211_cqm_rssi_threshold_event event;
+
+	if (rssi < thold && (last_event == 0 || rssi < (last_event - hyst)))
+		event = NL80211_CQM_RSSI_THRESHOLD_EVENT_LOW;
+	else if (rssi > thold &&
+		 (last_event == 0 || rssi > (last_event + hyst)))
+		event = NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH;
+	else
+		return;
+
+	common->cqm_info.last_cqm_event_rssi = rssi;
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
@@ -755,6 +841,7 @@ static void rsi_fill_rx_status(struct ieee80211_hw *hw,
 			       struct rsi_common *common,
 			       struct ieee80211_rx_status *rxs)
 {
+	struct ieee80211_bss_conf *bss = &common->priv->vifs[0]->bss_conf;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct skb_info *rx_params = (struct skb_info *)info->driver_data;
 	struct ieee80211_hdr *hdr;
@@ -789,6 +876,14 @@ static void rsi_fill_rx_status(struct ieee80211_hw *hw,
 		rxs->flag |= RX_FLAG_DECRYPTED;
 		rxs->flag |= RX_FLAG_IV_STRIPPED;
 	}
+
+	/* CQM only for connected AP beacons, the RSSI is a weighted avg */
+	if (bss->assoc && !(memcmp(bss->bssid, hdr->addr2, ETH_ALEN))) {
+		if (ieee80211_is_beacon(hdr->frame_control))
+			rsi_perform_cqm(common, hdr->addr2, rxs->signal);
+	}
+
+	return;
 }
 
 /**
diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index cbd5a7e..3ef3434 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -1201,6 +1201,49 @@ static int rsi_eeprom_read(struct rsi_common *common)
 }
 
 /**
+ * This function sends a frame to block/unblock
+ * data queues in the firmware
+ *
+ * @param common Pointer to the driver private structure.
+ * @param block event - block if true, unblock if false
+ * @return 0 on success, -1 on failure.
+ */
+int rsi_send_block_unblock_frame(struct rsi_common *common, bool block_event)
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
+		return -ENOMEM;
+	}
+
+	memset(skb->data, 0, FRAME_DESC_SZ);
+	mgmt_frame = (struct rsi_mac_frame *)skb->data;
+
+	mgmt_frame->desc_word[0] = cpu_to_le16(RSI_WIFI_MGMT_Q << 12);
+	mgmt_frame->desc_word[1] = cpu_to_le16(BLOCK_HW_QUEUE);
+
+	if (block_event == true) {
+		rsi_dbg(INFO_ZONE, "blocking the data qs\n");
+		mgmt_frame->desc_word[4] = cpu_to_le16(0xf);
+	} else {
+		rsi_dbg(INFO_ZONE, "unblocking the data qs\n");
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
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index 8629131..5baed94 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -142,6 +142,12 @@ struct rsi_thread {
 	atomic_t thread_done;
 };
 
+struct cqm_info {
+	s8 last_cqm_event_rssi;
+	int rssi_thold;
+	u32 rssi_hyst;
+};
+
 struct rsi_hw;
 
 struct rsi_common {
@@ -194,6 +200,9 @@ struct rsi_common {
 	u32 pkt_cnt;
 	u8 min_weight;
 
+	/* bgscan related */
+	struct cqm_info cqm_info;
+
 	bool hw_data_qs_blocked;
 };
 
diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index f10d6c6..3741173 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -168,7 +168,7 @@ enum cmd_frame_type {
 	SCAN_REQUEST,
 	TSF_UPDATE,
 	PEER_NOTIFY,
-	BLOCK_UNBLOCK,
+	BLOCK_HW_QUEUE,
 	SET_KEY_REQ,
 	AUTO_RATE_IND,
 	BOOTUP_PARAMS_REQUEST,
@@ -293,6 +293,7 @@ int rsi_send_aggregation_params_frame(struct rsi_common *common, u16 tid,
 int rsi_hal_load_key(struct rsi_common *common, u8 *data, u16 key_len,
 		     u8 key_type, u8 key_id, u32 cipher);
 int rsi_set_channel(struct rsi_common *common, u16 chno);
+int rsi_send_block_unblock_frame(struct rsi_common *common, bool event);
 void rsi_inform_bss_status(struct rsi_common *common, u8 status,
 			   const u8 *bssid, u8 qos_enable, u16 aid);
 void rsi_indicate_pkt_to_os(struct rsi_common *common, struct sk_buff *skb);
-- 
1.7.1

