Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:63195 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753854Ab2DJAuW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Apr 2012 20:50:22 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 04/11] iwlwifi: move queue watchdog into transport
Date: Mon,  9 Apr 2012 17:46:54 -0700
Message-Id: <1334018821-30416-5-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120410_025033_563175_D6C1B6A7)
In-Reply-To: <1334018821-30416-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334018821-30416-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This removes one of the two sources of device
restarts in the upper layer -- those are a bit
inconvenient because normal restarts originate
in the transport. By moving the watchdog down
it can be treated the same.

Also rewrite the watchdog logic. Timers are
much more efficient when they never fire, so
instead firing a timer every 500ms set up a
timer for each TX queue and fire it only when
the queue is really stuck. This avoids the CPU
waking up when everything is working well.

While at it, remove the wd_disable config item
and replace it by simply setting wd_timeout to
IWL_WATCHHDOG_DISABLED (0).

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c           |    3 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c           |    3 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c            |   18 ++----
 drivers/net/wireless/iwlwifi/iwl-core.c           |   68 ------------------
 drivers/net/wireless/iwlwifi/iwl-core.h           |    2 -
 drivers/net/wireless/iwlwifi/iwl-dev.h            |    2 +-
 drivers/net/wireless/iwlwifi/iwl-shared.h         |    4 -
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |   16 ++++-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c  |   27 +++++++-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c     |   77 +++++++++++----------
 drivers/net/wireless/iwlwifi/iwl-trans.h          |   12 +---
 11 files changed, 91 insertions(+), 141 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 95c59e3..3787f84 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -165,9 +165,8 @@ static const struct iwl_base_params iwl1000_base_params = {
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_EXT_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
-	.wd_timeout = IWL_DEF_WD_TIMEOUT,
+	.wd_timeout = IWL_WATCHHDOG_DISABLED,
 	.max_event_log_size = 128,
-	.wd_disable = true,
 };
 
 static const struct iwl_ht_params iwl1000_ht_params = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 34bc8dd..9f379d3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -312,10 +312,9 @@ static const struct iwl_base_params iwl5000_base_params = {
 	.led_compensation = 51,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
-	.wd_timeout = IWL_LONG_WD_TIMEOUT,
+	.wd_timeout = IWL_WATCHHDOG_DISABLED,
 	.max_event_log_size = 512,
 	.no_idle_support = true,
-	.wd_disable = true,
 };
 
 static const struct iwl_ht_params iwl5000_ht_params = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 0596c95..5971fc6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -738,9 +738,6 @@ int iwl_alive_start(struct iwl_priv *priv)
 	/* After the ALIVE response, we can send host commands to the uCode */
 	set_bit(STATUS_ALIVE, &priv->status);
 
-	/* Enable watchdog to monitor the driver tx queues */
-	iwl_setup_watchdog(priv);
-
 	if (iwl_is_rfkill(priv))
 		return -ERFKILL;
 
@@ -884,10 +881,6 @@ void iwl_down(struct iwl_priv *priv)
 	exit_pending =
 		test_and_set_bit(STATUS_EXIT_PENDING, &priv->status);
 
-	/* Stop TX queues watchdog. We need to have STATUS_EXIT_PENDING bit set
-	 * to prevent rearm timer */
-	del_timer_sync(&priv->watchdog);
-
 	iwl_clear_ucode_stations(priv, NULL);
 	iwl_dealloc_bcast_stations(priv);
 	iwl_clear_driver_stations(priv);
@@ -1089,10 +1082,6 @@ static void iwl_setup_deferred_work(struct iwl_priv *priv)
 	init_timer(&priv->ucode_trace);
 	priv->ucode_trace.data = (unsigned long)priv;
 	priv->ucode_trace.function = iwl_bg_ucode_trace;
-
-	init_timer(&priv->watchdog);
-	priv->watchdog.data = (unsigned long)priv;
-	priv->watchdog.function = iwl_bg_watchdog;
 }
 
 void iwl_cancel_deferred_work(struct iwl_priv *priv)
@@ -1407,8 +1396,6 @@ static void iwl_set_hw_params(struct iwl_priv *priv)
 	if (iwlagn_mod_params.disable_11n & IWL_DISABLE_HT_ALL)
 		hw_params(priv).sku &= ~EEPROM_SKU_CAP_11N_ENABLE;
 
-	hw_params(priv).wd_timeout = cfg(priv)->base_params->wd_timeout;
-
 	/* Device-specific setup */
 	cfg(priv)->lib->set_hw_params(priv);
 }
@@ -1495,6 +1482,11 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	trans_cfg.no_reclaim_cmds = no_reclaim_cmds;
 	trans_cfg.n_no_reclaim_cmds = ARRAY_SIZE(no_reclaim_cmds);
 	trans_cfg.rx_buf_size_8k = iwlagn_mod_params.amsdu_size_8K;
+	if (!iwlagn_mod_params.wd_disable)
+		trans_cfg.queue_watchdog_timeout =
+			cfg(priv)->base_params->wd_timeout;
+	else
+		trans_cfg.queue_watchdog_timeout = IWL_WATCHHDOG_DISABLED;
 
 	ucode_flags = fw->ucode_capa.flags;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 88ea31d..6fc1841 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -837,74 +837,6 @@ int iwl_cmd_echo_test(struct iwl_priv *priv)
 	return ret;
 }
 
-static inline int iwl_check_stuck_queue(struct iwl_priv *priv, int txq)
-{
-	if (iwl_trans_check_stuck_queue(trans(priv), txq)) {
-		int ret;
-		ret = iwl_force_reset(priv, IWL_FW_RESET, false);
-		return (ret == -EAGAIN) ? 0 : 1;
-	}
-	return 0;
-}
-
-/*
- * Making watchdog tick be a quarter of timeout assure we will
- * discover the queue hung between timeout and 1.25*timeout
- */
-#define IWL_WD_TICK(timeout) ((timeout) / 4)
-
-/*
- * Watchdog timer callback, we check each tx queue for stuck, if if hung
- * we reset the firmware. If everything is fine just rearm the timer.
- */
-void iwl_bg_watchdog(unsigned long data)
-{
-	struct iwl_priv *priv = (struct iwl_priv *)data;
-	int cnt;
-	unsigned long timeout;
-
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-		return;
-
-	if (iwl_is_rfkill(priv))
-		return;
-
-	timeout = hw_params(priv).wd_timeout;
-	if (timeout == 0)
-		return;
-
-	/* monitor and check for stuck queues */
-	for (cnt = 0; cnt < cfg(priv)->base_params->num_of_queues; cnt++)
-		if (iwl_check_stuck_queue(priv, cnt))
-			return;
-
-	mod_timer(&priv->watchdog, jiffies +
-		  msecs_to_jiffies(IWL_WD_TICK(timeout)));
-}
-
-void iwl_setup_watchdog(struct iwl_priv *priv)
-{
-	unsigned int timeout = hw_params(priv).wd_timeout;
-
-	if (!iwlagn_mod_params.wd_disable) {
-		/* use system default */
-		if (timeout && !cfg(priv)->base_params->wd_disable)
-			mod_timer(&priv->watchdog,
-				jiffies +
-				msecs_to_jiffies(IWL_WD_TICK(timeout)));
-		else
-			del_timer(&priv->watchdog);
-	} else {
-		/* module parameter overwrite default configuration */
-		if (timeout && iwlagn_mod_params.wd_disable == 2)
-			mod_timer(&priv->watchdog,
-				jiffies +
-				msecs_to_jiffies(IWL_WD_TICK(timeout)));
-		else
-			del_timer(&priv->watchdog);
-	}
-}
-
 /**
  * iwl_beacon_time_mask_low - mask of lower 32 bit of beacon time
  * @priv -- pointer to iwl_priv data structure
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 7aa3060..f388dc4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -151,7 +151,6 @@ static inline void iwl_update_stats(struct iwl_priv *priv, bool is_tx,
 ******************************************************/
 void iwl_chswitch_done(struct iwl_priv *priv, bool is_success);
 
-void iwl_setup_watchdog(struct iwl_priv *priv);
 /*****************************************************
  * TX power
  ****************************************************/
@@ -193,7 +192,6 @@ int __must_check iwl_scan_initiate(struct iwl_priv *priv,
  *   S e n d i n g     H o s t     C o m m a n d s   *
  *****************************************************/
 
-void iwl_bg_watchdog(unsigned long data);
 u32 iwl_usecs_to_beacons(struct iwl_priv *priv, u32 usec, u32 beacon_interval);
 __le32 iwl_add_beacon_time(struct iwl_priv *priv, u32 base,
 			   u32 addon, u32 beacon_interval);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 99be589..780bcf3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -585,6 +585,7 @@ struct iwl_event_log {
 #define IWL_DELAY_NEXT_FORCE_FW_RELOAD (HZ*5)
 
 /* TX queue watchdog timeouts in mSecs */
+#define IWL_WATCHHDOG_DISABLED	(0)
 #define IWL_DEF_WD_TIMEOUT	(2000)
 #define IWL_LONG_WD_TIMEOUT	(10000)
 #define IWL_MAX_WD_TIMEOUT	(120000)
@@ -973,7 +974,6 @@ struct iwl_priv {
 	struct work_struct run_time_calib_work;
 	struct timer_list statistics_periodic;
 	struct timer_list ucode_trace;
-	struct timer_list watchdog;
 
 	struct iwl_event_log event_log;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index c2e5ce9..c6049cf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -169,7 +169,6 @@ struct iwl_mod_params {
  * @ct_kill_threshold: temperature threshold - in hw dependent unit
  * @ct_kill_exit_threshold: when to reeable the device - in hw dependent unit
  *	relevant for 1000, 6000 and up
- * @wd_timeout: TX queues watchdog timeout
  * @struct iwl_sensitivity_ranges: range of sensitivity values
  * @use_rts_for_aggregation: use rts/cts protection for HT traffic
  */
@@ -183,7 +182,6 @@ struct iwl_hw_params {
 	u16 sku;
 	u32 ct_kill_threshold;
 	u32 ct_kill_exit_threshold;
-	unsigned int wd_timeout;
 
 	const struct iwl_sensitivity_ranges *sens;
 };
@@ -221,7 +219,6 @@ enum iwl_led_mode {
  * @shadow_reg_enable: HW shadhow register bit
  * @hd_v2: v2 of enhanced sensitivity value, used for 2000 series and up
  * @no_idle_support: do not support idle mode
- * wd_disable: disable watchdog timer
  */
 struct iwl_base_params {
 	int eeprom_size;
@@ -241,7 +238,6 @@ struct iwl_base_params {
 	const bool shadow_reg_enable;
 	const bool hd_v2;
 	const bool no_idle_support;
-	const bool wd_disable;
 };
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
index a1fc439..731d275 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
@@ -34,6 +34,7 @@
 #include <linux/skbuff.h>
 #include <linux/wait.h>
 #include <linux/pci.h>
+#include <linux/timer.h>
 
 #include "iwl-fh.h"
 #include "iwl-csr.h"
@@ -204,7 +205,8 @@ struct iwl_tx_queue {
 	struct iwl_cmd_meta *meta;
 	struct sk_buff **skbs;
 	spinlock_t lock;
-	unsigned long time_stamp;
+	struct timer_list stuck_timer;
+	struct iwl_trans_pcie *trans_pcie;
 	u8 need_update;
 	u8 active;
 };
@@ -227,6 +229,7 @@ struct iwl_tx_queue {
  * @cmd_queue - command queue number
  * @rx_buf_size_8k: 8 kB RX buffer size
  * @rx_page_order: page order for receive buffer size
+ * @wd_timeout: queue watchdog timeout (jiffies)
  */
 struct iwl_trans_pcie {
 	struct iwl_rx_queue rxq;
@@ -269,11 +272,22 @@ struct iwl_trans_pcie {
 
 	bool rx_buf_size_8k;
 	u32 rx_page_order;
+
+
+	/* queue watchdog */
+	unsigned long wd_timeout;
 };
 
 #define IWL_TRANS_GET_PCIE_TRANS(_iwl_trans) \
 	((struct iwl_trans_pcie *) ((_iwl_trans)->trans_specific))
 
+static inline struct iwl_trans *
+iwl_trans_pcie_get_trans(struct iwl_trans_pcie *trans_pcie)
+{
+	return container_of((void *)trans_pcie, struct iwl_trans,
+			    trans_specific);
+}
+
 /*****************************************************
 * RX
 ******************************************************/
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index d35d0b8..c34eac0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -668,6 +668,10 @@ static int iwl_enqueue_hcmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 			       trace_bufs[2], trace_lens[2]);
 #endif
 
+	/* start timer if queue currently empty */
+	if (q->read_ptr == q->write_ptr && trans_pcie->wd_timeout)
+		mod_timer(&txq->stuck_timer, jiffies + trans_pcie->wd_timeout);
+
 	/* Increment and update queue's write index */
 	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
 	iwl_txq_update_write_ptr(trans, txq);
@@ -677,6 +681,22 @@ static int iwl_enqueue_hcmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 	return idx;
 }
 
+static inline void iwl_queue_progress(struct iwl_trans_pcie *trans_pcie,
+				      struct iwl_tx_queue *txq)
+{
+	if (!trans_pcie->wd_timeout)
+		return;
+
+	/*
+	 * if empty delete timer, otherwise move timer forward
+	 * since we're making progress on this queue
+	 */
+	if (txq->q.read_ptr == txq->q.write_ptr)
+		del_timer(&txq->stuck_timer);
+	else
+		mod_timer(&txq->stuck_timer, jiffies + trans_pcie->wd_timeout);
+}
+
 /**
  * iwl_hcmd_queue_reclaim - Reclaim TX command queue entries already Tx'd
  *
@@ -711,6 +731,8 @@ static void iwl_hcmd_queue_reclaim(struct iwl_trans *trans, int txq_id,
 		}
 
 	}
+
+	iwl_queue_progress(trans_pcie, txq);
 }
 
 /**
@@ -754,8 +776,6 @@ void iwl_tx_cmd_complete(struct iwl_trans *trans, struct iwl_rx_cmd_buffer *rxb,
 	cmd = txq->cmd[cmd_index];
 	meta = &txq->meta[cmd_index];
 
-	txq->time_stamp = jiffies;
-
 	iwlagn_unmap_tfd(trans, meta, &txq->tfds[index],
 			 DMA_BIDIRECTIONAL);
 
@@ -949,5 +969,8 @@ int iwl_tx_queue_reclaim(struct iwl_trans *trans, int txq_id, int index,
 		iwlagn_txq_free_tfd(trans, txq, txq->q.read_ptr, DMA_TO_DEVICE);
 		freed++;
 	}
+
+	iwl_queue_progress(trans_pcie, txq);
+
 	return freed;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 17fec08..0220d7f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -299,6 +299,33 @@ static inline void iwlagn_free_dma_ptr(struct iwl_trans *trans,
 	memset(ptr, 0, sizeof(*ptr));
 }
 
+static void iwl_trans_pcie_queue_stuck_timer(unsigned long data)
+{
+	struct iwl_tx_queue *txq = (void *)data;
+	struct iwl_trans_pcie *trans_pcie = txq->trans_pcie;
+	struct iwl_trans *trans = iwl_trans_pcie_get_trans(trans_pcie);
+
+	spin_lock(&txq->lock);
+	/* check if triggered erroneously */
+	if (txq->q.read_ptr == txq->q.write_ptr) {
+		spin_unlock(&txq->lock);
+		return;
+	}
+	spin_unlock(&txq->lock);
+
+
+	IWL_ERR(trans, "Queue %d stuck for %u ms.\n", txq->q.id,
+		jiffies_to_msecs(trans_pcie->wd_timeout));
+	IWL_ERR(trans, "Current SW read_ptr %d write_ptr %d\n",
+		txq->q.read_ptr, txq->q.write_ptr);
+	IWL_ERR(trans, "Current HW read_ptr %d write_ptr %d\n",
+		iwl_read_prph(trans, SCD_QUEUE_RDPTR(txq->q.id))
+					& (TFD_QUEUE_SIZE_MAX - 1),
+		iwl_read_prph(trans, SCD_QUEUE_WRPTR(txq->q.id)));
+
+	iwl_op_mode_nic_error(trans->op_mode);
+}
+
 static int iwl_trans_txq_alloc(struct iwl_trans *trans,
 				struct iwl_tx_queue *txq, int slots_num,
 				u32 txq_id)
@@ -310,6 +337,10 @@ static int iwl_trans_txq_alloc(struct iwl_trans *trans,
 	if (WARN_ON(txq->meta || txq->cmd || txq->skbs || txq->tfds))
 		return -EINVAL;
 
+	setup_timer(&txq->stuck_timer, iwl_trans_pcie_queue_stuck_timer,
+		    (unsigned long)txq);
+	txq->trans_pcie = trans_pcie;
+
 	txq->q.n_window = slots_num;
 
 	txq->meta = kcalloc(slots_num, sizeof(txq->meta[0]), GFP_KERNEL);
@@ -472,6 +503,8 @@ static void iwl_tx_queue_free(struct iwl_trans *trans, int txq_id)
 	txq->cmd = NULL;
 	txq->meta = NULL;
 
+	del_timer_sync(&txq->stuck_timer);
+
 	/* 0-fill queue descriptor structure */
 	memset(txq, 0, sizeof(*txq));
 }
@@ -1347,6 +1380,10 @@ static int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 			     &dev_cmd->hdr, firstlen,
 			     skb->data + hdr_len, secondlen);
 
+	/* start timer if queue currently empty */
+	if (q->read_ptr == q->write_ptr && trans_pcie->wd_timeout)
+		mod_timer(&txq->stuck_timer, jiffies + trans_pcie->wd_timeout);
+
 	/* Tell device the write index *just past* this latest filled TFD */
 	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
 	iwl_txq_update_write_ptr(trans, txq);
@@ -1442,8 +1479,6 @@ static void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int txq_id, int ssn,
 
 	spin_lock(&txq->lock);
 
-	txq->time_stamp = jiffies;
-
 	if (txq->q.read_ptr != tfd_num) {
 		IWL_DEBUG_TX_REPLY(trans, "[Q %d] %d -> %d (%d)\n",
 				   txq_id, txq->q.read_ptr, tfd_num, ssn);
@@ -1500,6 +1535,9 @@ static void iwl_trans_pcie_configure(struct iwl_trans *trans,
 		trans_pcie->rx_page_order = get_order(8 * 1024);
 	else
 		trans_pcie->rx_page_order = get_order(4 * 1024);
+
+	trans_pcie->wd_timeout =
+		msecs_to_jiffies(trans_cfg->queue_watchdog_timeout);
 }
 
 static void iwl_trans_pcie_free(struct iwl_trans *trans)
@@ -1589,40 +1627,6 @@ static int iwl_trans_pcie_wait_tx_queue_empty(struct iwl_trans *trans)
 	return ret;
 }
 
-/*
- * On every watchdog tick we check (latest) time stamp. If it does not
- * change during timeout period and queue is not empty we reset firmware.
- */
-static int iwl_trans_pcie_check_stuck_queue(struct iwl_trans *trans, int cnt)
-{
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct iwl_tx_queue *txq = &trans_pcie->txq[cnt];
-	struct iwl_queue *q = &txq->q;
-	unsigned long timeout;
-
-	if (q->read_ptr == q->write_ptr) {
-		txq->time_stamp = jiffies;
-		return 0;
-	}
-
-	timeout = txq->time_stamp +
-		  msecs_to_jiffies(hw_params(trans).wd_timeout);
-
-	if (time_after(jiffies, timeout)) {
-		IWL_ERR(trans, "Queue %d stuck for %u ms.\n", q->id,
-			hw_params(trans).wd_timeout);
-		IWL_ERR(trans, "Current SW read_ptr %d write_ptr %d\n",
-			q->read_ptr, q->write_ptr);
-		IWL_ERR(trans, "Current HW read_ptr %d write_ptr %d\n",
-			iwl_read_prph(trans, SCD_QUEUE_RDPTR(cnt))
-				& (TFD_QUEUE_SIZE_MAX - 1),
-			iwl_read_prph(trans, SCD_QUEUE_WRPTR(cnt)));
-		return 1;
-	}
-
-	return 0;
-}
-
 static const char *get_fh_string(int cmd)
 {
 	switch (cmd) {
@@ -2045,7 +2049,6 @@ const struct iwl_trans_ops trans_ops_pcie = {
 	.dbgfs_register = iwl_trans_pcie_dbgfs_register,
 
 	.wait_tx_queue_empty = iwl_trans_pcie_wait_tx_queue_empty,
-	.check_stuck_queue = iwl_trans_pcie_check_stuck_queue,
 
 #ifdef CONFIG_PM_SLEEP
 	.suspend = iwl_trans_pcie_suspend,
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 46be59f..a6598a2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -307,6 +307,8 @@ static inline struct page *rxb_steal_page(struct iwl_rx_cmd_buffer *r)
  * @n_no_reclaim_cmds: # of commands in list
  * @rx_buf_size_8k: 8 kB RX buffer size needed for A-MSDUs,
  *	if unset 4k will be the RX buffer size
+ * @queue_watchdog_timeout: time (in ms) after which queues
+ *	are considered stuck and will trigger device restart
  */
 struct iwl_trans_config {
 	struct iwl_op_mode *op_mode;
@@ -318,6 +320,7 @@ struct iwl_trans_config {
 	int n_no_reclaim_cmds;
 
 	bool rx_buf_size_8k;
+	unsigned int queue_watchdog_timeout;
 };
 
 /**
@@ -355,7 +358,6 @@ struct iwl_trans_config {
  *	irq, tasklet etc... From this point on, the device may not issue
  *	any interrupt (incl. RFKILL).
  *	May sleep
- * @check_stuck_queue: check if a specific queue is stuck
  * @wait_tx_queue_empty: wait until all tx queues are empty
  *	May sleep
  * @dbgfs_register: add the dbgfs files under this directory. Files will be
@@ -394,7 +396,6 @@ struct iwl_trans_ops {
 	void (*free)(struct iwl_trans *trans);
 
 	int (*dbgfs_register)(struct iwl_trans *trans, struct dentry* dir);
-	int (*check_stuck_queue)(struct iwl_trans *trans, int q);
 	int (*wait_tx_queue_empty)(struct iwl_trans *trans);
 #ifdef CONFIG_PM_SLEEP
 	int (*suspend)(struct iwl_trans *trans);
@@ -577,13 +578,6 @@ static inline int iwl_trans_wait_tx_queue_empty(struct iwl_trans *trans)
 	return trans->ops->wait_tx_queue_empty(trans);
 }
 
-static inline int iwl_trans_check_stuck_queue(struct iwl_trans *trans, int q)
-{
-	WARN_ONCE(trans->state != IWL_TRANS_FW_ALIVE,
-		  "%s bad state = %d", __func__, trans->state);
-
-	return trans->ops->check_stuck_queue(trans, q);
-}
 static inline int iwl_trans_dbgfs_register(struct iwl_trans *trans,
 					    struct dentry *dir)
 {
-- 
1.7.0.4

