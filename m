Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:56602 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393AbXLCLoj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2007 06:44:39 -0500
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, yi.zhu@intel.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Ben Cahill <ben.m.cahill@intel.com>
Subject: [PATCH 09/34] iwlwifi: Add comments to some driver data structures
Date: Mon,  3 Dec 2007 13:43:21 +0200
Message-Id: <11966822302864-git-send-email-tomas.winkler@intel.com> (sfid-20071203_114444_219250_7EA8566E)
In-Reply-To: <11966822301152-git-send-email-tomas.winkler@intel.com>
References: <11966822261109-git-send-email-tomas.winkler@intel.com>
 <11966822291406-git-send-email-tomas.winkler@intel.com>
 <1196682229843-git-send-email-tomas.winkler@intel.com>
 <11966822293932-git-send-email-tomas.winkler@intel.com>
 <11966822291956-git-send-email-tomas.winkler@intel.com>
 <119668222978-git-send-email-tomas.winkler@intel.com>
 <11966822293340-git-send-email-tomas.winkler@intel.com>
 <11966822291143-git-send-email-tomas.winkler@intel.com>
 <11966822301152-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Cahill <ben.m.cahill@intel.com>

Add comments to some driver data structures

Remove unused "sched_retry" member from struct iwl3945_tx_queue

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.h |   35 ++++++++++++++++++--
 drivers/net/wireless/iwlwifi/iwl-4965.h |   53 ++++++++++++++++++++++++++++---
 2 files changed, 79 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 38802ff..cb565a9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -131,6 +131,7 @@ struct iwl3945_queue {
 
 #define MAX_NUM_OF_TBS          (20)
 
+/* One for each TFD */
 struct iwl3945_tx_info {
 	struct ieee80211_tx_status status;
 	struct sk_buff *skb[MAX_NUM_OF_TBS];
@@ -138,10 +139,15 @@ struct iwl3945_tx_info {
 
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
@@ -150,7 +156,6 @@ struct iwl3945_tx_queue {
 	dma_addr_t dma_addr_cmd;
 	struct iwl3945_tx_info *txb;
 	int need_update;
-	int sched_retry;
 	int active;
 };
 
@@ -326,6 +331,13 @@ struct iwl3945_cmd_meta {
 
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
@@ -523,6 +535,19 @@ struct iwl3945_ibss_seq {
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
@@ -860,6 +885,8 @@ struct iwl3945_priv {
 	u16 last_seq_num;
 	u16 last_frag_num;
 	unsigned long last_packet_time;
+
+	/* Hash table for finding stations in IBSS network */
 	struct list_head ibss_mac_hash[IWL_IBSS_MAC_HASH_SIZE];
 
 	/* eeprom */
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index 9302125..028c66e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -130,6 +130,7 @@ struct iwl4965_queue {
 
 #define MAX_NUM_OF_TBS          (20)
 
+/* One for each TFD */
 struct iwl4965_tx_info {
 	struct ieee80211_tx_status status;
 	struct sk_buff *skb[MAX_NUM_OF_TBS];
@@ -137,10 +138,16 @@ struct iwl4965_tx_info {
 
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
@@ -333,9 +340,16 @@ struct iwl4965_cmd_meta {
 
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
@@ -437,6 +451,20 @@ struct iwl4965_rx_queue {
 
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
@@ -567,6 +595,19 @@ struct iwl4965_ibss_seq {
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
@@ -1226,6 +1267,8 @@ struct iwl4965_priv {
 	u16 last_seq_num;
 	u16 last_frag_num;
 	unsigned long last_packet_time;
+
+	/* Hash table for finding stations in IBSS network */
 	struct list_head ibss_mac_hash[IWL_IBSS_MAC_HASH_SIZE];
 
 	/* eeprom */
-- 
1.5.2.2
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
