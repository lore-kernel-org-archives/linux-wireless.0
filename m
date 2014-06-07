Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:39554 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931AbaFGPw0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Jun 2014 11:52:26 -0400
Received: by mail-pd0-f175.google.com with SMTP id z10so3617669pdj.6
        for <linux-wireless@vger.kernel.org>; Sat, 07 Jun 2014 08:52:26 -0700 (PDT)
From: Jahnavi Meher <jahnavi.meher@gmail.com>
To: <linux-wireless@vger.kernel.org>
Cc: Jahnavi Meher <jahnavi.meher@redpinesignals.com>,
	Jahnavi Meher <jahnavi.meher@gmail.com>
Subject: [PATCH 1/4] rsi: Fixes and clean up of code.
Date: Sun,  8 Jun 2014 02:51:47 +0530
Message-Id: <1402176107-8452-1-git-send-email-jahnavi.meher@gmail.com> (sfid-20140607_175238_673743_710B99EC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jahnavi Meher <jahnavi.meher@redpinesignals.com>

Changed the SDIO interrupt type variables according to the changes in firmware and some minor fixes and clean up of code.

Signed-off-by: Jahnavi Meher <jahnavi.meher@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_debugfs.c  |   10 +++---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c |    7 +---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     |   49 ++++++++-------------------
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c |    4 +-
 drivers/net/wireless/rsi/rsi_sdio.h         |    4 +-
 5 files changed, 25 insertions(+), 49 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_debugfs.c b/drivers/net/wireless/rsi/rsi_91x_debugfs.c
index c466246..828a042 100644
--- a/drivers/net/wireless/rsi/rsi_91x_debugfs.c
+++ b/drivers/net/wireless/rsi/rsi_91x_debugfs.c
@@ -145,7 +145,7 @@ static int rsi_stats_read(struct seq_file *seq, void *data)
 	seq_printf(seq, "total_mgmt_pkt_send : %d\n",
 		   common->tx_stats.total_tx_pkt_send[MGMT_SOFT_Q]);
 	seq_printf(seq, "total_mgmt_pkt_queued : %d\n",
-		   skb_queue_len(&common->tx_queue[4]));
+		   skb_queue_len(&common->tx_queue[MGMT_SOFT_Q]));
 	seq_printf(seq, "total_mgmt_pkt_freed  : %d\n",
 		   common->tx_stats.total_tx_pkt_freed[MGMT_SOFT_Q]);
 
@@ -153,25 +153,25 @@ static int rsi_stats_read(struct seq_file *seq, void *data)
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
 
diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index 54aaeb0..45bdb99 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -185,7 +185,7 @@ static void rsi_register_rates_channels(struct rsi_hw *adapter, int band)
 }
 
 /**
- * rsi_mac80211_attach() - This function is used to de-initialize the
+ * rsi_mac80211_detach() - This function is used to de-initialize the
  *			   Mac80211 stack.
  * @adapter: Pointer to the adapter structure.
  *
@@ -770,10 +770,7 @@ static void rsi_fill_rx_status(struct ieee80211_hw *hw,
 
 	rxs->signal = -(rssi);
 
-	if (channel <= 14)
-		rxs->band = IEEE80211_BAND_2GHZ;
-	else
-		rxs->band = IEEE80211_BAND_5GHZ;
+	rxs->band = common->band;
 
 	freq = ieee80211_channel_to_frequency(channel, rxs->band);
 
diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index 2eefbf1..be9f5ca 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -841,23 +841,6 @@ int rsi_set_channel(struct rsi_common *common, u16 channel)
 	rsi_dbg(MGMT_TX_ZONE,
 		"%s: Sending scan req frame\n", __func__);
 
-	if (common->band == IEEE80211_BAND_5GHZ) {
-		if ((channel >= 36) && (channel <= 64))
-			channel = ((channel - 32) / 4);
-		else if ((channel > 64) && (channel <= 140))
-			channel = ((channel - 102) / 4) + 8;
-		else if (channel >= 149)
-			channel = ((channel - 151) / 4) + 18;
-		else
-			return -EINVAL;
-	} else {
-		if (channel > 14) {
-			rsi_dbg(ERR_ZONE, "%s: Invalid chno %d, band = %d\n",
-				__func__, channel, common->band);
-			return -EINVAL;
-		}
-	}
-
 	skb = dev_alloc_skb(FRAME_DESC_SZ);
 	if (!skb) {
 		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of skb\n",
@@ -950,7 +933,7 @@ static int rsi_send_auto_rate_request(struct rsi_common *common)
 	struct ieee80211_hw *hw = common->priv->hw;
 	u8 band = hw->conf.chandef.chan->band;
 	u8 num_supported_rates = 0;
-	u8 rate_offset = 0;
+	u8 rate_table_offset, rate_offset = 0;
 	u32 rate_bitmap = common->bitrate_mask[band];
 
 	u16 *selected_rates, min_rate;
@@ -986,14 +969,18 @@ static int rsi_send_auto_rate_request(struct rsi_common *common)
 	if (common->channel_width == BW_40MHZ)
 		auto_rate->desc_word[7] |= cpu_to_le16(1);
 
-	if (band == IEEE80211_BAND_2GHZ)
-		min_rate = STD_RATE_01;
-	else
-		min_rate = STD_RATE_06;
+	if (band == IEEE80211_BAND_2GHZ) {
+		min_rate = RSI_RATE_1;
+		rate_table_offset = 0;
+	} else {
+		min_rate = RSI_RATE_6;
+		rate_table_offset = 4;
+	}
 
 	for (ii = 0, jj = 0; ii < ARRAY_SIZE(rsi_rates); ii++) {
 		if (rate_bitmap & BIT(ii)) {
-			selected_rates[jj++] = (rsi_rates[ii].bitrate / 5);
+			selected_rates[jj++] =
+			(rsi_rates[ii + rate_table_offset].bitrate / 5);
 			rate_offset++;
 		}
 	}
@@ -1006,13 +993,6 @@ static int rsi_send_auto_rate_request(struct rsi_common *common)
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
@@ -1028,10 +1008,6 @@ static int rsi_send_auto_rate_request(struct rsi_common *common)
 
 	/* loading HT rates in the bottom half of the auto rate table */
 	if (common->vif_info[0].is_ht) {
-		if (common->vif_info[0].sgi)
-			auto_rate->supported_rates[rate_offset++] =
-				cpu_to_le16(RSI_RATE_MCS7_SG);
-
 		for (ii = rate_offset, kk = ARRAY_SIZE(rsi_mcsrates) - 1;
 		     ii < rate_offset + 2 * ARRAY_SIZE(rsi_mcsrates); ii++) {
 			if (common->vif_info[0].sgi)
@@ -1041,12 +1017,15 @@ static int rsi_send_auto_rate_request(struct rsi_common *common)
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
diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
index 20d11cc..0828cc2 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
@@ -404,9 +404,9 @@ void rsi_interrupt_handler(struct rsi_hw *adapter)
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
diff --git a/drivers/net/wireless/rsi/rsi_sdio.h b/drivers/net/wireless/rsi/rsi_sdio.h
index df4b5e2..32744f5 100644
--- a/drivers/net/wireless/rsi/rsi_sdio.h
+++ b/drivers/net/wireless/rsi/rsi_sdio.h
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
-- 
1.7.1

