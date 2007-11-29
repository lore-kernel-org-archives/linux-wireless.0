Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:4146 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755672AbXK2DKk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 22:10:40 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ben Cahill <ben.m.cahill@intel.com>, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 09/36] iwlwifi: Add comments to some driver data structures
Date: Thu, 29 Nov 2007 11:09:49 +0800
Message-Id: <1196305816-23023-10-git-send-email-yi.zhu@intel.com> (sfid-20071129_033541_183341_F27CA22E)
In-Reply-To: <1196305816-23023-9-git-send-email-yi.zhu@intel.com>
References: <1196305816-23023-1-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-2-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-3-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-4-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-5-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-6-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-7-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-8-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-9-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Cahill <ben.m.cahill@intel.com>

Add comments to some driver data structures

Remove unused "sched_retry" member from struct iwl3945_tx_queue

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.h |   35 ++++++++++++++++--
 drivers/net/wireless/iwlwifi/iwl-4965.h |   58 +++++++++++++++++++++++++++----
 2 files changed, 82 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 02040ef..607a1ed 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -130,6 +130,7 @@ struct iwl3945_queue {
 
 #define MAX_NUM_OF_TBS          (20)
 
+/* One for each TFD */
 struct iwl3945_tx_info {
 	struct ieee80211_tx_status status;
 	struct sk_buff *skb[MAX_NUM_OF_TBS];
@@ -137,10 +138,15 @@ struct iwl3945_tx_info {
 
 /**
  * struct iwl3945_tx_queue - Tx Queue for DMA
- * @need_update: need to update read/write index
- * @shed_retry: queue is HT AGG enabled
+ * @q: generic Rx/Tx queue descriptor
+ * @bd: base of circular buffer of TFDs
+ * @cmd: array of command/Tx buffers
+ * @dma_addr_cmd: physical address of cmd/tx buffer array
+ * @txb: array of per-TFD driver data
+ * @need_update: indicates need to update read/write index
  *
- * Queue consists of circular buffer of BD's and required locking structures.
+ * A Tx queue consists of circular buffer of BDs (a.k.a. TFDs, transmit frame
+ * descriptors) and required locking structures.
  */
 struct iwl3945_tx_queue {
 	struct iwl3945_queue q;
@@ -149,7 +155,6 @@ struct iwl3945_tx_queue {
 	dma_addr_t dma_addr_cmd;
 	struct iwl3945_tx_info *txb;
 	int need_update;
-	int sched_retry;
 	int active;
 };
 
@@ -325,6 +330,13 @@ struct iwl3945_cmd_meta {
 
 } __attribute__ ((packed));
 
+/**
+ * struct iwl3945_cmd
+ *
+ * For allocation of the command and tx queues, this establishes the overall
+ * size of the largest command we send to uCode, except for a scan command
+ * (which is relatively huge; space is allocated separately).
+ */
 struct iwl3945_cmd {
 	struct iwl3945_cmd_meta meta;
 	struct iwl3945_cmd_header hdr;
@@ -522,6 +534,19 @@ struct iwl3945_ibss_seq {
 	struct list_head list;
 };
 
+/**
+ * struct iwl4965_driver_hw_info
+ * @max_txq_num: Max # Tx queues supported
+ * @ac_queue_count: # Tx queues for EDCA Access Categories (AC)
+ * @tx_cmd_len: Size of Tx command (but not including frame itself)
+ * @max_rxq_size: Max # Rx frames in Rx queue (must be power-of-2)
+ * @rx_buffer_size:
+ * @max_rxq_log: Log-base-2 of max_rxq_size
+ * @max_stations:
+ * @bcast_sta_id:
+ * @shared_virt: Pointer to driver/uCode shared Tx Byte Counts and Rx status
+ * @shared_phys: Physical Pointer to Tx Byte Counts and Rx status
+ */
 struct iwl3945_driver_hw_info {
 	u16 max_txq_num;
 	u16 ac_queue_count;
@@ -857,6 +882,8 @@ struct iwl3945_priv {
 	u16 last_seq_num;
 	u16 last_frag_num;
 	unsigned long last_packet_time;
+
+	/* Hash table for finding stations in IBSS network */
 	struct list_head ibss_mac_hash[IWL_IBSS_MAC_HASH_SIZE];
 
 	/* eeprom */
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index d0abbb3..3000148 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -129,6 +129,7 @@ struct iwl4965_queue {
 
 #define MAX_NUM_OF_TBS          (20)
 
+/* One for each TFD */
 struct iwl4965_tx_info {
 	struct ieee80211_tx_status status;
 	struct sk_buff *skb[MAX_NUM_OF_TBS];
@@ -136,10 +137,16 @@ struct iwl4965_tx_info {
 
 /**
  * struct iwl4965_tx_queue - Tx Queue for DMA
- * @need_update: need to update read/write index
- * @shed_retry: queue is HT AGG enabled
+ * @q: generic Rx/Tx queue descriptor
+ * @bd: base of circular buffer of TFDs
+ * @cmd: array of command/Tx buffers
+ * @dma_addr_cmd: physical address of cmd/tx buffer array
+ * @txb: array of per-TFD driver data
+ * @need_update: indicates need to update read/write index
+ * @sched_retry: indicates queue is high-throughput aggregation (HT AGG) enabled
  *
- * Queue consists of circular buffer of BD's and required locking structures.
+ * A Tx queue consists of circular buffer of BDs (a.k.a. TFDs, transmit frame
+ * descriptors) and required locking structures.
  */
 struct iwl4965_tx_queue {
 	struct iwl4965_queue q;
@@ -332,9 +339,16 @@ struct iwl4965_cmd_meta {
 
 } __attribute__ ((packed));
 
+/**
+ * struct iwl4965_cmd
+ *
+ * For allocation of the command and tx queues, this establishes the overall
+ * size of the largest command we send to uCode, except for a scan command
+ * (which is relatively huge; space is allocated separately).
+ */
 struct iwl4965_cmd {
-	struct iwl4965_cmd_meta meta;
-	struct iwl4965_cmd_header hdr;
+	struct iwl4965_cmd_meta meta;	/* driver data */
+	struct iwl4965_cmd_header hdr;	/* uCode API */
 	union {
 		struct iwl4965_addsta_cmd addsta;
 		struct iwl4965_led_cmd led;
@@ -436,6 +450,20 @@ struct iwl4965_rx_queue {
 
 #ifdef CONFIG_IWL4965_HT
 #ifdef CONFIG_IWL4965_HT_AGG
+/**
+ * struct iwl4965_ht_agg -- aggregation status while waiting for block-ack
+ * @txq_id: Tx queue used for Tx attempt
+ * @frame_count: # frames attempted by Tx command
+ * @wait_for_ba: Expect block-ack before next Tx reply
+ * @start_idx: Index of 1st Transmit Frame Descriptor (TFD) in Tx window
+ * @bitmap0: Low order bitmap, one bit for each frame pending ACK in Tx window
+ * @bitmap1: High order, one bit for each frame pending ACK in Tx window
+ * @rate_n_flags: Rate at which Tx was attempted
+ *
+ * If REPLY_TX indicates that aggregation was attempted, driver must wait
+ * for block ack (REPLY_COMPRESSED_BA).  This struct stores tx reply info
+ * until block ack arrives.
+ */
 struct iwl4965_ht_agg {
 	u16 txq_id;
 	u16 frame_count;
@@ -566,6 +594,19 @@ struct iwl4965_ibss_seq {
 	struct list_head list;
 };
 
+/**
+ * struct iwl4965_driver_hw_info
+ * @max_txq_num: Max # Tx queues supported
+ * @ac_queue_count: # Tx queues for EDCA Access Categories (AC)
+ * @tx_cmd_len: Size of Tx command (but not including frame itself)
+ * @max_rxq_size: Max # Rx frames in Rx queue (must be power-of-2)
+ * @rx_buffer_size:
+ * @max_rxq_log: Log-base-2 of max_rxq_size
+ * @max_stations:
+ * @bcast_sta_id:
+ * @shared_virt: Pointer to driver/uCode shared Tx Byte Counts and Rx status
+ * @shared_phys: Physical Pointer to Tx Byte Counts and Rx status
+ */
 struct iwl4965_driver_hw_info {
 	u16 max_txq_num;
 	u16 ac_queue_count;
@@ -1149,10 +1190,11 @@ struct iwl4965_priv {
 	u8 call_post_assoc_from_beacon;
 	u8 assoc_station_added;
 	u8 use_ant_b_for_management_frame;	/* Tx antenna selection */
-	/* HT variables */
+
+	/* High Throughput (HT) variables */
 	u8 is_dup;
 	u8 is_ht_enabled;
-	u8 channel_width;	/* 0=20MHZ, 1=40MHZ */
+	u8 channel_width;	/* 0=20MHZ, 1=40MHZ supported */
 	u8 current_channel_width;
 	u8 valid_antenna;	/* Bit mask of antennas actually connected */
 #ifdef CONFIG_IWL4965_SENSITIVITY
@@ -1229,6 +1271,8 @@ struct iwl4965_priv {
 	u16 last_seq_num;
 	u16 last_frag_num;
 	unsigned long last_packet_time;
+
+	/* Hash table for finding stations in IBSS network */
 	struct list_head ibss_mac_hash[IWL_IBSS_MAC_HASH_SIZE];
 
 	/* eeprom */
-- 
1.5.3.6
