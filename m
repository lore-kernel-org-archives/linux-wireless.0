Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:24096 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754158AbYEECYI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 May 2008 22:24:08 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 04/25] iwlwifi: remove 4965 from station_entry
Date: Mon,  5 May 2008 10:22:31 +0800
Message-Id: <1209954172-3092-5-git-send-email-yi.zhu@intel.com> (sfid-20080505_042355_703874_4BB757D4)
In-Reply-To: <1209954172-3092-4-git-send-email-yi.zhu@intel.com>
References: <1209954172-3092-1-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-2-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-3-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-4-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch removes 4965 mark form the station entry structure.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   10 +++++-----
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   18 +++++++++---------
 drivers/net/wireless/iwlwifi/iwl-sta.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    8 ++++----
 5 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index ca33346..efe4793 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -3333,7 +3333,7 @@ static void iwl4965_sta_modify_enable_tid_tx(struct iwl_priv *priv,
  * ACK vs. not.  This gets sent to mac80211, then to rate scaling algo.
  */
 static int iwl4965_tx_status_reply_compressed_ba(struct iwl_priv *priv,
-						 struct iwl4965_ht_agg *agg,
+						 struct iwl_ht_agg *agg,
 						 struct iwl4965_compressed_ba_resp*
 						 ba_resp)
 
@@ -3450,7 +3450,7 @@ int iwl4965_check_empty_hw_queue(struct iwl_priv *priv, int sta_id,
 {
 	struct iwl4965_queue *q = &priv->txq[txq_id].q;
 	u8 *addr = priv->stations[sta_id].sta.sta.addr;
-	struct iwl4965_tid_data *tid_data = &priv->stations[sta_id].tid[tid];
+	struct iwl_tid_data *tid_data = &priv->stations[sta_id].tid[tid];
 
 	switch (priv->stations[sta_id].tid[tid].agg.state) {
 	case IWL_EMPTYING_HW_QUEUE_DELBA:
@@ -3502,7 +3502,7 @@ static void iwl4965_rx_reply_compressed_ba(struct iwl_priv *priv,
 	struct iwl4965_compressed_ba_resp *ba_resp = &pkt->u.compressed_ba;
 	int index;
 	struct iwl4965_tx_queue *txq = NULL;
-	struct iwl4965_ht_agg *agg;
+	struct iwl_ht_agg *agg;
 	DECLARE_MAC_BUF(mac);
 
 	/* "flow" corresponds to Tx queue */
@@ -3926,7 +3926,7 @@ static int iwl4965_tx_agg_start(struct ieee80211_hw *hw, const u8 *ra,
 	int ssn = -1;
 	int ret = 0;
 	unsigned long flags;
-	struct iwl4965_tid_data *tid_data;
+	struct iwl_tid_data *tid_data;
 	DECLARE_MAC_BUF(mac);
 
 	if (likely(tid < ARRAY_SIZE(default_tid_to_tx_fifo)))
@@ -3979,7 +3979,7 @@ static int iwl4965_tx_agg_stop(struct ieee80211_hw *hw, const u8 *ra, u16 tid)
 {
 	struct iwl_priv *priv = hw->priv;
 	int tx_fifo_id, txq_id, sta_id, ssn = -1;
-	struct iwl4965_tid_data *tid_data;
+	struct iwl_tid_data *tid_data;
 	int ret, write_ptr, read_ptr;
 	unsigned long flags;
 	DECLARE_MAC_BUF(mac);
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 392cd41..e28c31d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -206,7 +206,7 @@ static ssize_t iwl_dbgfs_stations_read(struct file *file, char __user *user_buf,
 					size_t count, loff_t *ppos)
 {
 	struct iwl_priv *priv = (struct iwl_priv *)file->private_data;
-	struct iwl4965_station_entry *station;
+	struct iwl_station_entry *station;
 	int max_sta = priv->hw_params.max_stations;
 	char *buf;
 	int i, j, pos = 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 1d80ad7..07eff75 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -401,7 +401,7 @@ struct iwl_rx_queue {
 
 #ifdef CONFIG_IWL4965_HT
 /**
- * struct iwl4965_ht_agg -- aggregation status while waiting for block-ack
+ * struct iwl_ht_agg -- aggregation status while waiting for block-ack
  * @txq_id: Tx queue used for Tx attempt
  * @frame_count: # frames attempted by Tx command
  * @wait_for_ba: Expect block-ack before next Tx reply
@@ -414,7 +414,7 @@ struct iwl_rx_queue {
  * for block ack (REPLY_COMPRESSED_BA).  This struct stores tx reply info
  * until block ack arrives.
  */
-struct iwl4965_ht_agg {
+struct iwl_ht_agg {
 	u16 txq_id;
 	u16 frame_count;
 	u16 wait_for_ba;
@@ -430,15 +430,15 @@ struct iwl4965_ht_agg {
 
 #endif /* CONFIG_IWL4965_HT */
 
-struct iwl4965_tid_data {
+struct iwl_tid_data {
 	u16 seq_number;
 	u16 tfds_in_queue;
 #ifdef CONFIG_IWL4965_HT
-	struct iwl4965_ht_agg agg;
+	struct iwl_ht_agg agg;
 #endif /* CONFIG_IWL4965_HT */
 };
 
-struct iwl4965_hw_key {
+struct iwl_hw_key {
 	enum ieee80211_key_alg alg;
 	int keylen;
 	u8 keyidx;
@@ -510,12 +510,12 @@ struct iwl4965_qos_info {
 #define STA_PS_STATUS_WAKE             0
 #define STA_PS_STATUS_SLEEP            1
 
-struct iwl4965_station_entry {
+struct iwl_station_entry {
 	struct iwl4965_addsta_cmd sta;
-	struct iwl4965_tid_data tid[MAX_TID_COUNT];
+	struct iwl_tid_data tid[MAX_TID_COUNT];
 	u8 used;
 	u8 ps_status;
-	struct iwl4965_hw_key keyinfo;
+	struct iwl_hw_key keyinfo;
 };
 
 /* one for each uCode image (inst/data, boot/init/runtime) */
@@ -1107,7 +1107,7 @@ struct iwl_priv {
 	/*station table variables */
 	spinlock_t sta_lock;
 	int num_stations;
-	struct iwl4965_station_entry stations[IWL_STATION_COUNT];
+	struct iwl_station_entry stations[IWL_STATION_COUNT];
 	struct iwl_wep_key wep_keys[WEP_KEYS_MAX];
 	u8 default_wep_key;
 	u8 key_mapping_key;
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 31b37a1..0148d49 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -333,7 +333,7 @@ int iwl_remove_dynamic_key(struct iwl_priv *priv,
 		IWL_ERROR("index %d not used in uCode key table.\n",
 			priv->stations[sta_id].sta.key.key_offset);
 	memset(&priv->stations[sta_id].keyinfo, 0,
-					sizeof(struct iwl4965_hw_key));
+					sizeof(struct iwl_hw_key));
 	memset(&priv->stations[sta_id].sta.key, 0,
 					sizeof(struct iwl4965_keyinfo));
 	priv->stations[sta_id].sta.key.key_flags =
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index ccbe09e..c23a123 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -433,7 +433,7 @@ u8 iwl4965_add_station_flags(struct iwl_priv *priv, const u8 *addr,
 {
 	int i;
 	int index = IWL_INVALID_STATION;
-	struct iwl4965_station_entry *station;
+	struct iwl_station_entry *station;
 	unsigned long flags_spin;
 	DECLARE_MAC_BUF(mac);
 
@@ -1783,7 +1783,7 @@ static void iwl4965_build_tx_cmd_hwcrypto(struct iwl_priv *priv,
 				      struct sk_buff *skb_frag,
 				      int sta_id)
 {
-	struct iwl4965_hw_key *keyinfo = &priv->stations[sta_id].keyinfo;
+	struct iwl_hw_key *keyinfo = &priv->stations[sta_id].keyinfo;
 	struct iwl_wep_key *wepkey;
 	int keyidx = 0;
 
@@ -2623,7 +2623,7 @@ static inline u32 iwl4965_get_scd_ssn(struct iwl4965_tx_resp *tx_resp)
  * iwl4965_tx_status_reply_tx - Handle Tx rspnse for frames in aggregation queue
  */
 static int iwl4965_tx_status_reply_tx(struct iwl_priv *priv,
-				      struct iwl4965_ht_agg *agg,
+				      struct iwl_ht_agg *agg,
 				      struct iwl4965_tx_resp_agg *tx_resp,
 				      u16 start_idx)
 {
@@ -2781,7 +2781,7 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 
 	if (txq->sched_retry) {
 		const u32 scd_ssn = iwl4965_get_scd_ssn(tx_resp);
-		struct iwl4965_ht_agg *agg = NULL;
+		struct iwl_ht_agg *agg = NULL;
 
 		if (!qc)
 			return;
-- 
1.5.3.6

