Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:1472 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753616Ab0CJFWI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 00:22:08 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 23/24] iwlwifi: clean up queue/fifo handling
Date: Tue,  9 Mar 2010 21:21:51 -0800
Message-Id: <1268198512-6572-24-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1268198512-6572-1-git-send-email-reinette.chatre@intel.com>
References: <1268198512-6572-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

4965 hardware has 7 queues reserved and the
remaining ones used for aggregation, 5000
and higher need to have 10 reserved. This
is not very clear in the code right now,
unfortunately.

Introduce a new IWL_TX_FIFO_UNUSED constant
and make the queue/FIFO mapping arrays able
to hold that value, and change the setup
code to reserve all queues in the arrays
(the queue number is the index) and use the
new unused constant to not map those queues
to any FIFO.

Additionally, clear up the AC/queue mapping
code to be more understandable. The mapping
is the identity mapping right now, but with
the mapping function I think it's easier to
understand what happens there.

Finally, HCCA isn't implemented at all and
I think newer microcode removed it, so let's
remove all mention of it in the code, some
comments remain for 4965.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Acked-by: Shanyu Zhao <shanyu.zhao@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |   20 ++++--
 drivers/net/wireless/iwlwifi/iwl-5000.c |   35 +++++-----
 drivers/net/wireless/iwlwifi/iwl-dev.h  |   12 ++--
 drivers/net/wireless/iwlwifi/iwl-prph.h |   14 ++--
 drivers/net/wireless/iwlwifi/iwl-tx.c   |  105 ++++++++++++++++++++-----------
 5 files changed, 109 insertions(+), 77 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 1bd2cd8..644aacf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -502,14 +502,14 @@ static void iwl4965_tx_queue_set_status(struct iwl_priv *priv,
 		       scd_retry ? "BA" : "AC", txq_id, tx_fifo_id);
 }
 
-static const u16 default_queue_to_tx_fifo[] = {
-	IWL_TX_FIFO_AC3,
-	IWL_TX_FIFO_AC2,
-	IWL_TX_FIFO_AC1,
-	IWL_TX_FIFO_AC0,
+static const s8 default_queue_to_tx_fifo[] = {
+	IWL_TX_FIFO_VO,
+	IWL_TX_FIFO_VI,
+	IWL_TX_FIFO_BE,
+	IWL_TX_FIFO_BK,
 	IWL49_CMD_FIFO_NUM,
-	IWL_TX_FIFO_HCCA_1,
-	IWL_TX_FIFO_HCCA_2
+	IWL_TX_FIFO_UNUSED,
+	IWL_TX_FIFO_UNUSED,
 };
 
 static int iwl4965_alive_notify(struct iwl_priv *priv)
@@ -589,9 +589,15 @@ static int iwl4965_alive_notify(struct iwl_priv *priv)
 	/* reset to 0 to enable all the queue first */
 	priv->txq_ctx_active_msk = 0;
 	/* Map each Tx/cmd queue to its corresponding fifo */
+	BUILD_BUG_ON(ARRAY_SIZE(default_queue_to_tx_fifo) != 7);
 	for (i = 0; i < ARRAY_SIZE(default_queue_to_tx_fifo); i++) {
 		int ac = default_queue_to_tx_fifo[i];
+
 		iwl_txq_ctx_activate(priv, i);
+
+		if (ac == IWL_TX_FIFO_UNUSED)
+			continue;
+
 		iwl4965_tx_queue_set_status(priv, &priv->txq[i], ac, 0);
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 4c0ef01..37e1e77 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -64,14 +64,17 @@
 #define _IWL5150_MODULE_FIRMWARE(api) IWL5150_FW_PRE #api ".ucode"
 #define IWL5150_MODULE_FIRMWARE(api) _IWL5150_MODULE_FIRMWARE(api)
 
-static const u16 iwl5000_default_queue_to_tx_fifo[] = {
-	IWL_TX_FIFO_AC3,
-	IWL_TX_FIFO_AC2,
-	IWL_TX_FIFO_AC1,
-	IWL_TX_FIFO_AC0,
+static const s8 iwl5000_default_queue_to_tx_fifo[] = {
+	IWL_TX_FIFO_VO,
+	IWL_TX_FIFO_VI,
+	IWL_TX_FIFO_BE,
+	IWL_TX_FIFO_BK,
 	IWL50_CMD_FIFO_NUM,
-	IWL_TX_FIFO_HCCA_1,
-	IWL_TX_FIFO_HCCA_2
+	IWL_TX_FIFO_UNUSED,
+	IWL_TX_FIFO_UNUSED,
+	IWL_TX_FIFO_UNUSED,
+	IWL_TX_FIFO_UNUSED,
+	IWL_TX_FIFO_UNUSED,
 };
 
 /* NIC configuration for 5000 series */
@@ -657,25 +660,21 @@ int iwl5000_alive_notify(struct iwl_priv *priv)
 	/* reset to 0 to enable all the queue first */
 	priv->txq_ctx_active_msk = 0;
 	/* map qos queues to fifos one-to-one */
+	BUILD_BUG_ON(ARRAY_SIZE(iwl5000_default_queue_to_tx_fifo) != 10);
+
 	for (i = 0; i < ARRAY_SIZE(iwl5000_default_queue_to_tx_fifo); i++) {
 		int ac = iwl5000_default_queue_to_tx_fifo[i];
+
 		iwl_txq_ctx_activate(priv, i);
+
+		if (ac == IWL_TX_FIFO_UNUSED)
+			continue;
+
 		iwl5000_tx_queue_set_status(priv, &priv->txq[i], ac, 0);
 	}
 
-	/*
-	 * TODO - need to initialize these queues and map them to FIFOs
-	 * in the loop above, not only mark them as active. We do this
-	 * because we want the first aggregation queue to be queue #10,
-	 * but do not use 8 or 9 otherwise yet.
-	 */
-	iwl_txq_ctx_activate(priv, 7);
-	iwl_txq_ctx_activate(priv, 8);
-	iwl_txq_ctx_activate(priv, 9);
-
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-
 	iwl_send_wimax_coex(priv);
 
 	iwl5000_set_Xtal_calib(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index bac8e7c..2e4d47c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -304,13 +304,11 @@ struct iwl_channel_info {
 	struct iwl3945_scan_power_info scan_pwr_info[IWL_NUM_SCAN_RATES];
 };
 
-#define IWL_TX_FIFO_AC0	0
-#define IWL_TX_FIFO_AC1	1
-#define IWL_TX_FIFO_AC2	2
-#define IWL_TX_FIFO_AC3	3
-#define IWL_TX_FIFO_HCCA_1	5
-#define IWL_TX_FIFO_HCCA_2	6
-#define IWL_TX_FIFO_NONE	7
+#define IWL_TX_FIFO_BK		0
+#define IWL_TX_FIFO_BE		1
+#define IWL_TX_FIFO_VI		2
+#define IWL_TX_FIFO_VO		3
+#define IWL_TX_FIFO_UNUSED	-1
 
 /* Minimum number of queues. MAX_NUM is defined in hw specific files.
  * Set the minimum to accommodate the 4 standard TX queues, 1 command
diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index d2d2a91..5944de7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -254,7 +254,7 @@
  * device.  A queue maps to only one (selectable by driver) Tx DMA channel,
  * but one DMA channel may take input from several queues.
  *
- * Tx DMA channels have dedicated purposes.  For 4965, they are used as follows
+ * Tx DMA FIFOs have dedicated purposes.  For 4965, they are used as follows
  * (cf. default_queue_to_tx_fifo in iwl-4965.c):
  *
  * 0 -- EDCA BK (background) frames, lowest priority
@@ -262,20 +262,20 @@
  * 2 -- EDCA VI (video) frames, higher priority
  * 3 -- EDCA VO (voice) and management frames, highest priority
  * 4 -- Commands (e.g. RXON, etc.)
- * 5 -- HCCA short frames
- * 6 -- HCCA long frames
+ * 5 -- unused (HCCA)
+ * 6 -- unused (HCCA)
  * 7 -- not used by driver (device-internal only)
  *
- * For 5000 series and up, they are used slightly differently
+ * For 5000 series and up, they are used differently
  * (cf. iwl5000_default_queue_to_tx_fifo in iwl-5000.c):
  *
  * 0 -- EDCA BK (background) frames, lowest priority
  * 1 -- EDCA BE (best effort) frames, normal priority
  * 2 -- EDCA VI (video) frames, higher priority
  * 3 -- EDCA VO (voice) and management frames, highest priority
- * 4 -- (TBD)
- * 5 -- HCCA short frames
- * 6 -- HCCA long frames
+ * 4 -- unused
+ * 5 -- unused
+ * 6 -- unused
  * 7 -- Commands
  *
  * Driver should normally map queues 0-6 to Tx DMA/FIFO channels 0-6.
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 08b33fc..045e4a6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -37,26 +37,63 @@
 #include "iwl-io.h"
 #include "iwl-helpers.h"
 
-static const u16 default_tid_to_tx_fifo[] = {
-	IWL_TX_FIFO_AC1,
-	IWL_TX_FIFO_AC0,
-	IWL_TX_FIFO_AC0,
-	IWL_TX_FIFO_AC1,
-	IWL_TX_FIFO_AC2,
-	IWL_TX_FIFO_AC2,
-	IWL_TX_FIFO_AC3,
-	IWL_TX_FIFO_AC3,
-	IWL_TX_FIFO_NONE,
-	IWL_TX_FIFO_NONE,
-	IWL_TX_FIFO_NONE,
-	IWL_TX_FIFO_NONE,
-	IWL_TX_FIFO_NONE,
-	IWL_TX_FIFO_NONE,
-	IWL_TX_FIFO_NONE,
-	IWL_TX_FIFO_NONE,
-	IWL_TX_FIFO_AC3
+/*
+ * mac80211 queues, ACs, hardware queues, FIFOs.
+ *
+ * Cf. http://wireless.kernel.org/en/developers/Documentation/mac80211/queues
+ *
+ * Mac80211 uses the following numbers, which we get as from it
+ * by way of skb_get_queue_mapping(skb):
+ *
+ *	VO	0
+ *	VI	1
+ *	BE	2
+ *	BK	3
+ *
+ *
+ * Regular (not A-MPDU) frames are put into hardware queues corresponding
+ * to the FIFOs, see comments in iwl-prph.h. Aggregated frames get their
+ * own queue per aggregation session (RA/TID combination), such queues are
+ * set up to map into FIFOs too, for which we need an AC->FIFO mapping. In
+ * order to map frames to the right queue, we also need an AC->hw queue
+ * mapping. This is implemented here.
+ *
+ * Due to the way hw queues are set up (by the hw specific modules like
+ * iwl-4965.c, iwl-5000.c etc.), the AC->hw queue mapping is the identity
+ * mapping.
+ */
+
+static const u8 tid_to_ac[] = {
+	/* this matches the mac80211 numbers */
+	2, 3, 3, 2, 1, 1, 0, 0
+};
+
+static const u8 ac_to_fifo[] = {
+	IWL_TX_FIFO_VO,
+	IWL_TX_FIFO_VI,
+	IWL_TX_FIFO_BE,
+	IWL_TX_FIFO_BK,
 };
 
+static inline int get_fifo_from_ac(u8 ac)
+{
+	return ac_to_fifo[ac];
+}
+
+static inline int get_queue_from_ac(u16 ac)
+{
+	return ac;
+}
+
+static inline int get_fifo_from_tid(u16 tid)
+{
+	if (likely(tid < ARRAY_SIZE(tid_to_ac)))
+		return get_fifo_from_ac(tid_to_ac[tid]);
+
+	/* no support for TIDs 8-15 yet */
+	return -EINVAL;
+}
+
 static inline int iwl_alloc_dma_ptr(struct iwl_priv *priv,
 				    struct iwl_dma_ptr *ptr, size_t size)
 {
@@ -591,13 +628,12 @@ static void iwl_tx_cmd_build_basic(struct iwl_priv *priv,
 	tx_cmd->next_frame_len = 0;
 }
 
-#define RTS_HCCA_RETRY_LIMIT		3
 #define RTS_DFAULT_RETRY_LIMIT		60
 
 static void iwl_tx_cmd_build_rate(struct iwl_priv *priv,
 			      struct iwl_tx_cmd *tx_cmd,
 			      struct ieee80211_tx_info *info,
-			      __le16 fc, int is_hcca)
+			      __le16 fc)
 {
 	u32 rate_flags;
 	int rate_idx;
@@ -613,8 +649,7 @@ static void iwl_tx_cmd_build_rate(struct iwl_priv *priv,
 	tx_cmd->data_retry_limit = data_retry_limit;
 
 	/* Set retry limit on RTS packets */
-	rts_retry_limit = (is_hcca) ?  RTS_HCCA_RETRY_LIMIT :
-		RTS_DFAULT_RETRY_LIMIT;
+	rts_retry_limit = RTS_DFAULT_RETRY_LIMIT;
 	if (data_retry_limit < rts_retry_limit)
 		rts_retry_limit = data_retry_limit;
 	tx_cmd->rts_retry_limit = rts_retry_limit;
@@ -794,7 +829,7 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 		iwl_sta_modify_sleep_tx_count(priv, sta_id, 1);
 	}
 
-	txq_id = skb_get_queue_mapping(skb);
+	txq_id = get_queue_from_ac(skb_get_queue_mapping(skb));
 	if (ieee80211_is_data_qos(fc)) {
 		qc = ieee80211_get_qos_ctl(hdr);
 		tid = qc[0] & IEEE80211_QOS_CTL_TID_MASK;
@@ -859,8 +894,7 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	iwl_tx_cmd_build_basic(priv, tx_cmd, info, hdr, sta_id);
 	iwl_dbg_log_tx_data_frame(priv, len, hdr);
 
-	/* set is_hcca to 0; it probably will never be implemented */
-	iwl_tx_cmd_build_rate(priv, tx_cmd, info, fc, 0);
+	iwl_tx_cmd_build_rate(priv, tx_cmd, info, fc);
 
 	iwl_update_stats(priv, true, fc, len);
 	/*
@@ -1260,7 +1294,7 @@ EXPORT_SYMBOL(iwl_tx_cmd_complete);
  * Find first available (lowest unused) Tx Queue, mark it "active".
  * Called only when finding queue for aggregation.
  * Should never return anything < 7, because they should already
- * be in use as EDCA AC (0-3), Command (4), HCCA (5, 6).
+ * be in use as EDCA AC (0-3), Command (4), reserved (5, 6)
  */
 static int iwl_txq_ctx_activate_free(struct iwl_priv *priv)
 {
@@ -1281,10 +1315,9 @@ int iwl_tx_agg_start(struct iwl_priv *priv, const u8 *ra, u16 tid, u16 *ssn)
 	unsigned long flags;
 	struct iwl_tid_data *tid_data;
 
-	if (likely(tid < ARRAY_SIZE(default_tid_to_tx_fifo)))
-		tx_fifo = default_tid_to_tx_fifo[tid];
-	else
-		return -EINVAL;
+	tx_fifo = get_fifo_from_tid(tid);
+	if (unlikely(tx_fifo < 0))
+		return tx_fifo;
 
 	IWL_WARN(priv, "%s on ra = %pM tid = %d\n",
 			__func__, ra, tid);
@@ -1345,13 +1378,9 @@ int iwl_tx_agg_stop(struct iwl_priv *priv , const u8 *ra, u16 tid)
 		return -EINVAL;
 	}
 
-	if (unlikely(tid >= MAX_TID_COUNT))
-		return -EINVAL;
-
-	if (likely(tid < ARRAY_SIZE(default_tid_to_tx_fifo)))
-		tx_fifo_id = default_tid_to_tx_fifo[tid];
-	else
-		return -EINVAL;
+	tx_fifo_id = get_fifo_from_tid(tid);
+	if (unlikely(tx_fifo_id < 0))
+		return tx_fifo_id;
 
 	sta_id = iwl_find_station(priv, ra);
 
@@ -1419,7 +1448,7 @@ int iwl_txq_check_empty(struct iwl_priv *priv, int sta_id, u8 tid, int txq_id)
 		if ((txq_id  == tid_data->agg.txq_id) &&
 		    (q->read_ptr == q->write_ptr)) {
 			u16 ssn = SEQ_TO_SN(tid_data->seq_number);
-			int tx_fifo = default_tid_to_tx_fifo[tid];
+			int tx_fifo = get_fifo_from_tid(tid);
 			IWL_DEBUG_HT(priv, "HW queue empty: continue DELBA flow\n");
 			priv->cfg->ops->lib->txq_agg_disable(priv, txq_id,
 							     ssn, tx_fifo);
-- 
1.6.3.3

