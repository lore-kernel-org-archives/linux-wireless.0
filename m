Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:4146 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755966AbXK2DKt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 22:10:49 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Cahill, Ben M" <ben.m.cahill@intel.com>, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 14/36] iwlwifi: add comments, mostly on Tx queues
Date: Thu, 29 Nov 2007 11:09:54 +0800
Message-Id: <1196305816-23023-15-git-send-email-yi.zhu@intel.com> (sfid-20071129_033547_793619_B7A4706A)
In-Reply-To: <1196305816-23023-14-git-send-email-yi.zhu@intel.com>
References: <1196305816-23023-1-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-2-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-3-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-4-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-5-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-6-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-7-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-8-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-9-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-10-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-11-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-12-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-13-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-14-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Cahill, Ben M <ben.m.cahill@intel.com>

Add comments, mostly on Tx queues

Signed-off-by: Cahill, Ben M <ben.m.cahill@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |  252 +++++++++++++++++++++++----
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   18 ++-
 2 files changed, 231 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index d44166a..40c795e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -144,7 +144,7 @@ int iwl4965_hw_rxq_stop(struct iwl4965_priv *priv)
 		return rc;
 	}
 
-	/* stop HW */
+	/* stop Rx DMA */
 	iwl4965_write_direct32(priv, FH_MEM_RCSR_CHNL0_CONFIG_REG, 0);
 	rc = iwl4965_poll_direct_bit(priv, FH_MEM_RSSR_RX_STATUS_REG,
 				     (1 << 24), 1000);
@@ -234,17 +234,22 @@ static int iwl4965_rx_init(struct iwl4965_priv *priv, struct iwl4965_rx_queue *r
 		return rc;
 	}
 
-	/* stop HW */
+	/* Stop Rx DMA */
 	iwl4965_write_direct32(priv, FH_MEM_RCSR_CHNL0_CONFIG_REG, 0);
 
+	/* Reset driver's Rx queue write index */
 	iwl4965_write_direct32(priv, FH_RSCSR_CHNL0_RBDCB_WPTR_REG, 0);
+
+	/* Tell device where to find RBD circular buffer in DRAM */
 	iwl4965_write_direct32(priv, FH_RSCSR_CHNL0_RBDCB_BASE_REG,
 			     rxq->dma_addr >> 8);
 
+	/* Tell device where in DRAM to update its Rx status */
 	iwl4965_write_direct32(priv, FH_RSCSR_CHNL0_STTS_WPTR_REG,
 			     (priv->hw_setting.shared_phys +
 			      offsetof(struct iwl4965_shared, val0)) >> 4);
 
+	/* Enable Rx DMA, enable host interrupt, Rx buffer size 4k, 256 RBDs */
 	iwl4965_write_direct32(priv, FH_MEM_RCSR_CHNL0_CONFIG_REG,
 			     FH_RCSR_RX_CONFIG_CHNL_EN_ENABLE_VAL |
 			     FH_RCSR_CHNL0_RX_CONFIG_IRQ_DEST_INT_HOST_VAL |
@@ -263,6 +268,7 @@ static int iwl4965_rx_init(struct iwl4965_priv *priv, struct iwl4965_rx_queue *r
 	return 0;
 }
 
+/* Tell 4965 where to find the "keep warm" buffer */
 static int iwl4965_kw_init(struct iwl4965_priv *priv)
 {
 	unsigned long flags;
@@ -297,6 +303,11 @@ static int iwl4965_kw_alloc(struct iwl4965_priv *priv)
 #define CHECK_AND_PRINT(x) ((eeprom_ch->flags & EEPROM_CHANNEL_##x) \
 			    ? # x " " : "")
 
+/**
+ * iwl4965_set_fat_chan_info - Copy fat channel info into driver's priv.
+ *
+ * Does not set up a command, or touch hardware.
+ */
 int iwl4965_set_fat_chan_info(struct iwl4965_priv *priv, int phymode, u16 channel,
 			      const struct iwl4965_eeprom_channel *eeprom_ch,
 			      u8 fat_extension_channel)
@@ -337,6 +348,9 @@ int iwl4965_set_fat_chan_info(struct iwl4965_priv *priv, int phymode, u16 channe
 	return 0;
 }
 
+/**
+ * iwl4965_kw_free - Free the "keep warm" buffer
+ */
 static void iwl4965_kw_free(struct iwl4965_priv *priv)
 {
 	struct pci_dev *dev = priv->pci_dev;
@@ -363,9 +377,10 @@ static int iwl4965_txq_ctx_reset(struct iwl4965_priv *priv)
 
 	iwl4965_kw_free(priv);
 
+	/* Free all tx/cmd queues and keep-warm buffer */
 	iwl4965_hw_txq_ctx_free(priv);
 
-	/* Tx CMD queue */
+	/* Alloc keep-warm buffer */
 	rc = iwl4965_kw_alloc(priv);
 	if (rc) {
 		IWL_ERROR("Keep Warm allocation failed");
@@ -381,17 +396,20 @@ static int iwl4965_txq_ctx_reset(struct iwl4965_priv *priv)
 		goto error_reset;
 	}
 
+	/* Turn off all Tx DMA channels */
 	iwl4965_write_prph(priv, KDR_SCD_TXFACT, 0);
 	iwl4965_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
+	/* Tell 4965 where to find the keep-warm buffer */
 	rc = iwl4965_kw_init(priv);
 	if (rc) {
 		IWL_ERROR("kw_init failed\n");
 		goto error_reset;
 	}
 
-	/* Tx queue(s) */
+	/* Alloc and init all (default 16) Tx queues,
+	 * including the command queue (#4) */
 	for (txq_id = 0; txq_id < priv->hw_setting.max_txq_num; txq_id++) {
 		slots_num = (txq_id == IWL_CMD_QUEUE_NUM) ?
 					TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
@@ -545,6 +563,8 @@ int iwl4965_hw_nic_init(struct iwl4965_priv *priv)
 	iwl4965_rx_queue_update_write_ptr(priv, rxq);
 
 	spin_unlock_irqrestore(&priv->lock, flags);
+
+	/* Allocate and init all Tx and Command queues */
 	rc = iwl4965_txq_ctx_reset(priv);
 	if (rc)
 		return rc;
@@ -593,13 +613,16 @@ int iwl4965_hw_nic_stop_master(struct iwl4965_priv *priv)
 	return rc;
 }
 
+/**
+ * iwl4965_hw_txq_ctx_stop - Stop all Tx DMA channels, free Tx queue memory
+ */
 void iwl4965_hw_txq_ctx_stop(struct iwl4965_priv *priv)
 {
 
 	int txq_id;
 	unsigned long flags;
 
-	/* reset TFD queues */
+	/* Stop each Tx DMA channel, and wait for it to be idle */
 	for (txq_id = 0; txq_id < priv->hw_setting.max_txq_num; txq_id++) {
 		spin_lock_irqsave(&priv->lock, flags);
 		if (iwl4965_grab_nic_access(priv)) {
@@ -617,6 +640,7 @@ void iwl4965_hw_txq_ctx_stop(struct iwl4965_priv *priv)
 		spin_unlock_irqrestore(&priv->lock, flags);
 	}
 
+	/* Deallocate memory for all Tx queues */
 	iwl4965_hw_txq_ctx_free(priv);
 }
 
@@ -1586,16 +1610,23 @@ static void iwl4965_set_wr_ptrs(struct iwl4965_priv *priv, int txq_id, u32 index
 	iwl4965_write_prph(priv, KDR_SCD_QUEUE_RDPTR(txq_id), index);
 }
 
-/*
- * Acquire priv->lock before calling this function !
+/**
+ * iwl4965_tx_queue_set_status - (optionally) start Tx/Cmd queue
+ * @tx_fifo_id: Tx DMA/FIFO channel (range 0-7) that the queue will feed
+ * @scd_retry: (1) Indicates queue will be used in aggregation mode
+ *
+ * NOTE:  Acquire priv->lock before calling this function !
  */
 static void iwl4965_tx_queue_set_status(struct iwl4965_priv *priv,
 					struct iwl4965_tx_queue *txq,
 					int tx_fifo_id, int scd_retry)
 {
 	int txq_id = txq->q.id;
+
+	/* Find out whether to activate Tx queue */
 	int active = test_bit(txq_id, &priv->txq_ctx_active_msk)?1:0;
 
+	/* Set up and activate */
 	iwl4965_write_prph(priv, KDR_SCD_QUEUE_STATUS_BITS(txq_id),
 				 (active << SCD_QUEUE_STTS_REG_POS_ACTIVE) |
 				 (tx_fifo_id << SCD_QUEUE_STTS_REG_POS_TXF) |
@@ -1606,7 +1637,7 @@ static void iwl4965_tx_queue_set_status(struct iwl4965_priv *priv,
 	txq->sched_retry = scd_retry;
 
 	IWL_DEBUG_INFO("%s %s Queue %d on AC %d\n",
-		       active ? "Activete" : "Deactivate",
+		       active ? "Activate" : "Deactivate",
 		       scd_retry ? "BA" : "AC", txq_id, tx_fifo_id);
 }
 
@@ -1654,6 +1685,7 @@ int iwl4965_alive_notify(struct iwl4965_priv *priv)
 		return rc;
 	}
 
+	/* Clear 4965's internal Tx Scheduler data base */
 	priv->scd_base_addr = iwl4965_read_prph(priv, KDR_SCD_SRAM_BASE_ADDR);
 	a = priv->scd_base_addr + SCD_CONTEXT_DATA_OFFSET;
 	for (; a < priv->scd_base_addr + SCD_TX_STTS_BITMAP_OFFSET; a += 4)
@@ -1663,20 +1695,29 @@ int iwl4965_alive_notify(struct iwl4965_priv *priv)
 	for (; a < sizeof(u16) * priv->hw_setting.max_txq_num; a += 4)
 		iwl4965_write_targ_mem(priv, a, 0);
 
+	/* Tel 4965 where to find Tx byte count tables */
 	iwl4965_write_prph(priv, KDR_SCD_DRAM_BASE_ADDR,
 		(priv->hw_setting.shared_phys +
 		 offsetof(struct iwl4965_shared, queues_byte_cnt_tbls)) >> 10);
+
+	/* Disable chain mode for all queues */
 	iwl4965_write_prph(priv, KDR_SCD_QUEUECHAIN_SEL, 0);
 
-	/* initiate the queues */
+	/* Initialize each Tx queue (including the command queue) */
 	for (i = 0; i < priv->hw_setting.max_txq_num; i++) {
+
+		/* TFD circular buffer read/write indexes */
 		iwl4965_write_prph(priv, KDR_SCD_QUEUE_RDPTR(i), 0);
 		iwl4965_write_direct32(priv, HBUS_TARG_WRPTR, 0 | (i << 8));
+
+		/* Max Tx Window size for Scheduler-ACK mode */
 		iwl4965_write_targ_mem(priv, priv->scd_base_addr +
 					SCD_CONTEXT_QUEUE_OFFSET(i),
 					(SCD_WIN_SIZE <<
 					SCD_QUEUE_CTX_REG1_WIN_SIZE_POS) &
 					SCD_QUEUE_CTX_REG1_WIN_SIZE_MSK);
+
+		/* Frame limit */
 		iwl4965_write_targ_mem(priv, priv->scd_base_addr +
 					SCD_CONTEXT_QUEUE_OFFSET(i) +
 					sizeof(u32),
@@ -1688,11 +1729,13 @@ int iwl4965_alive_notify(struct iwl4965_priv *priv)
 	iwl4965_write_prph(priv, KDR_SCD_INTERRUPT_MASK,
 				 (1 << priv->hw_setting.max_txq_num) - 1);
 
+	/* Activate all Tx DMA/FIFO channels */
 	iwl4965_write_prph(priv, KDR_SCD_TXFACT,
 				 SCD_TXFACT_REG_TXFIFO_MASK(0, 7));
 
 	iwl4965_set_wr_ptrs(priv, IWL_CMD_QUEUE_NUM, 0);
-	/* map qos queues to fifos one-to-one */
+
+	/* Map each Tx/cmd queue to its corresponding fifo */
 	for (i = 0; i < ARRAY_SIZE(default_queue_to_tx_fifo); i++) {
 		int ac = default_queue_to_tx_fifo[i];
 		iwl4965_txq_ctx_activate(priv, i);
@@ -1705,8 +1748,14 @@ int iwl4965_alive_notify(struct iwl4965_priv *priv)
 	return 0;
 }
 
+/**
+ * iwl4965_hw_set_hw_setting
+ *
+ * Called when initializing driver
+ */
 int iwl4965_hw_set_hw_setting(struct iwl4965_priv *priv)
 {
+	/* Allocate area for Tx byte count tables and Rx queue status */
 	priv->hw_setting.shared_virt =
 	    pci_alloc_consistent(priv->pci_dev,
 				 sizeof(struct iwl4965_shared),
@@ -1741,13 +1790,15 @@ void iwl4965_hw_txq_ctx_free(struct iwl4965_priv *priv)
 	for (txq_id = 0; txq_id < priv->hw_setting.max_txq_num; txq_id++)
 		iwl4965_tx_queue_free(priv, &priv->txq[txq_id]);
 
+	/* Keep-warm buffer */
 	iwl4965_kw_free(priv);
 }
 
 /**
- * iwl4965_hw_txq_free_tfd -  Free one TFD, those at index [txq->q.read_ptr]
+ * iwl4965_hw_txq_free_tfd - Free all chunks referenced by TFD [txq->q.read_ptr]
  *
- * Does NOT advance any indexes
+ * Does NOT advance any TFD circular buffer read/write indexes
+ * Does NOT free the TFD itself (which is within circular buffer)
  */
 int iwl4965_hw_txq_free_tfd(struct iwl4965_priv *priv, struct iwl4965_tx_queue *txq)
 {
@@ -1758,12 +1809,11 @@ int iwl4965_hw_txq_free_tfd(struct iwl4965_priv *priv, struct iwl4965_tx_queue *
 	int counter = 0;
 	int index, is_odd;
 
-	/* classify bd */
+	/* Host command buffers stay mapped in memory, nothing to clean */
 	if (txq->q.id == IWL_CMD_QUEUE_NUM)
-		/* nothing to cleanup after for host commands */
 		return 0;
 
-	/* sanity check */
+	/* Sanity check on number of chunks */
 	counter = IWL_GET_BITS(*bd, num_tbs);
 	if (counter > MAX_NUM_OF_TBS) {
 		IWL_ERROR("Too many chunks: %i\n", counter);
@@ -1771,8 +1821,8 @@ int iwl4965_hw_txq_free_tfd(struct iwl4965_priv *priv, struct iwl4965_tx_queue *
 		return 0;
 	}
 
-	/* unmap chunks if any */
-
+	/* Unmap chunks, if any.
+	 * TFD info for odd chunks is different format than for even chunks. */
 	for (i = 0; i < counter; i++) {
 		index = i / 2;
 		is_odd = i & 0x1;
@@ -1792,6 +1842,7 @@ int iwl4965_hw_txq_free_tfd(struct iwl4965_priv *priv, struct iwl4965_tx_queue *
 					 IWL_GET_BITS(bd->pa[index], tb1_len),
 					 PCI_DMA_TODEVICE);
 
+		/* Free SKB, if any, for this chunk */
 		if (txq->txb[txq->q.read_ptr].skb[i]) {
 			struct sk_buff *skb = txq->txb[txq->q.read_ptr].skb[i];
 
@@ -1826,6 +1877,17 @@ static s32 iwl4965_math_div_round(s32 num, s32 denom, s32 *res)
 	return 1;
 }
 
+/**
+ * iwl4965_get_voltage_compensation - Power supply voltage comp for txpower
+ *
+ * Determines power supply voltage compensation for txpower calculations.
+ * Returns number of 1/2-dB steps to subtract from gain table index,
+ * to compensate for difference between power supply voltage during
+ * factory measurements, vs. current power supply voltage.
+ *
+ * Voltage indication is higher for lower voltage.
+ * Lower voltage requires more gain (lower gain table index).
+ */
 static s32 iwl4965_get_voltage_compensation(s32 eeprom_voltage,
 					    s32 current_voltage)
 {
@@ -1913,6 +1975,14 @@ static s32 iwl4965_interpolate_value(s32 x, s32 x1, s32 y1, s32 x2, s32 y2)
 	}
 }
 
+/**
+ * iwl4965_interpolate_chan - Interpolate factory measurements for one channel
+ *
+ * Interpolates factory measurements from the two sample channels within a
+ * sub-band, to apply to channel of interest.  Interpolation is proportional to
+ * differences in channel frequencies, which is proportional to differences
+ * in channel number.
+ */
 static int iwl4965_interpolate_chan(struct iwl4965_priv *priv, u32 channel,
 				    struct iwl4965_eeprom_calib_ch_info *chan_info)
 {
@@ -2681,6 +2751,13 @@ unsigned int iwl4965_hw_get_beacon_cmd(struct iwl4965_priv *priv,
 	return (sizeof(*tx_beacon_cmd) + frame_size);
 }
 
+/*
+ * Tell 4965 where to find circular buffer of Tx Frame Descriptors for
+ * given Tx queue, and enable the DMA channel used for that queue.
+ *
+ * 4965 supports up to 16 Tx queues in DRAM, mapped to up to 8 Tx DMA
+ * channels supported in hardware.
+ */
 int iwl4965_hw_tx_queue_init(struct iwl4965_priv *priv, struct iwl4965_tx_queue *txq)
 {
 	int rc;
@@ -2694,8 +2771,11 @@ int iwl4965_hw_tx_queue_init(struct iwl4965_priv *priv, struct iwl4965_tx_queue
 		return rc;
 	}
 
+	/* Circular buffer (TFD queue in DRAM) physical base address */
 	iwl4965_write_direct32(priv, FH_MEM_CBBC_QUEUE(txq_id),
 			     txq->q.dma_addr >> 8);
+
+	/* Enable DMA channel, using same id as for TFD queue */
 	iwl4965_write_direct32(
 		priv, IWL_FH_TCSR_CHNL_TX_CONFIG_REG(txq_id),
 		IWL_FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE |
@@ -2718,6 +2798,7 @@ int iwl4965_hw_txq_attach_buf_to_tfd(struct iwl4965_priv *priv, void *ptr,
 	struct iwl4965_tfd_frame *tfd = ptr;
 	u32 num_tbs = IWL_GET_BITS(*tfd, num_tbs);
 
+	/* Each TFD can point to a maximum 20 Tx buffers */
 	if ((num_tbs >= MAX_NUM_OF_TBS) || (num_tbs < 0)) {
 		IWL_ERROR("Error can not send more than %d chunks\n",
 			  MAX_NUM_OF_TBS);
@@ -2759,6 +2840,9 @@ static void iwl4965_hw_card_show_info(struct iwl4965_priv *priv)
 #define IWL_TX_CRC_SIZE		4
 #define IWL_TX_DELIMITER_SIZE	4
 
+/**
+ * iwl4965_tx_queue_update_wr_ptr - Set up entry in Tx byte-count array
+ */
 int iwl4965_tx_queue_update_wr_ptr(struct iwl4965_priv *priv,
 				   struct iwl4965_tx_queue *txq, u16 byte_cnt)
 {
@@ -2771,9 +2855,11 @@ int iwl4965_tx_queue_update_wr_ptr(struct iwl4965_priv *priv,
 
 	len = byte_cnt + IWL_TX_CRC_SIZE + IWL_TX_DELIMITER_SIZE;
 
+	/* Set up byte count within first 256 entries */
 	IWL_SET_BITS16(shared_data->queues_byte_cnt_tbls[txq_id].
 		       tfd_offset[txq->q.write_ptr], byte_cnt, len);
 
+	/* If within first 64 entries, duplicate at end */
 	if (txq->q.write_ptr < IWL4965_MAX_WIN_SIZE)
 		IWL_SET_BITS16(shared_data->queues_byte_cnt_tbls[txq_id].
 			tfd_offset[IWL4965_QUEUE_SIZE + txq->q.write_ptr],
@@ -2782,8 +2868,12 @@ int iwl4965_tx_queue_update_wr_ptr(struct iwl4965_priv *priv,
 	return 0;
 }
 
-/* Set up Rx receiver/antenna/chain usage in "staging" RXON image.
- * This should not be used for scan command ... it puts data in wrong place.  */
+/**
+ * iwl4965_set_rxon_chain - Set up Rx chain usage in "staging" RXON image
+ *
+ * Selects how many and which Rx receivers/antennas/chains to use.
+ * This should not be used for scan command ... it puts data in wrong place.
+ */
 void iwl4965_set_rxon_chain(struct iwl4965_priv *priv)
 {
 	u8 is_single = is_single_stream(priv);
@@ -2931,6 +3021,9 @@ enum HT_STATUS {
 	BA_STATUS_ACTIVE,
 };
 
+/**
+ * iwl4964_tl_ba_avail - Find out if an unused aggregation queue is available
+ */
 static u8 iwl4964_tl_ba_avail(struct iwl4965_priv *priv)
 {
 	int i;
@@ -2939,6 +3032,8 @@ static u8 iwl4964_tl_ba_avail(struct iwl4965_priv *priv)
 	u16 msk;
 
 	lq = (struct iwl4965_lq_mngr *)&(priv->lq_mngr);
+
+	/* Find out how many agg queues are in use */
 	for (i = 0; i < TID_MAX_LOAD_COUNT ; i++) {
 		msk = 1 << i;
 		if ((lq->agg_ctrl.granted_ba & msk) ||
@@ -3080,6 +3175,9 @@ void iwl4965_turn_off_agg(struct iwl4965_priv *priv, u8 tid)
 	}
 }
 
+/**
+ * iwl4965_ba_status - Update driver's link quality mgr with tid's HT status
+ */
 static void iwl4965_ba_status(struct iwl4965_priv *priv,
 				u8 tid, enum HT_STATUS status)
 {
@@ -3301,11 +3399,12 @@ int iwl4965_get_temperature(const struct iwl4965_priv *priv)
 	}
 
 	/*
-	 * Temperature is only 23 bits so sign extend out to 32
+	 * Temperature is only 23 bits, so sign extend out to 32.
 	 *
 	 * NOTE If we haven't received a statistics notification yet
 	 * with an updated temperature, use R4 provided to us in the
-	 * ALIVE response. */
+	 * "initialize" ALIVE response.
+	 */
 	if (!test_bit(STATUS_TEMPERATURE, &priv->status))
 		vt = sign_extend(R4, 23);
 	else
@@ -4001,6 +4100,11 @@ static void iwl4965_rx_missed_beacon_notif(struct iwl4965_priv *priv,
 #ifdef CONFIG_IWL4965_HT
 #ifdef CONFIG_IWL4965_HT_AGG
 
+/**
+ * iwl4965_set_tx_status - Update driver's record of one Tx frame's status
+ *
+ * This will get sent to mac80211.
+ */
 static void iwl4965_set_tx_status(struct iwl4965_priv *priv, int txq_id, int idx,
 				  u32 status, u32 retry_count, u32 rate)
 {
@@ -4013,11 +4117,15 @@ static void iwl4965_set_tx_status(struct iwl4965_priv *priv, int txq_id, int idx
 }
 
 
+/**
+ * iwl4965_sta_modify_enable_tid_tx - Enable Tx for this TID in station table
+ */
 static void iwl4965_sta_modify_enable_tid_tx(struct iwl4965_priv *priv,
 					 int sta_id, int tid)
 {
 	unsigned long flags;
 
+	/* Remove "disable" flag, to enable Tx for this TID */
 	spin_lock_irqsave(&priv->sta_lock, flags);
 	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_TID_DISABLE_TX;
 	priv->stations[sta_id].sta.tid_disable_tx &= cpu_to_le16(~(1 << tid));
@@ -4028,6 +4136,12 @@ static void iwl4965_sta_modify_enable_tid_tx(struct iwl4965_priv *priv,
 }
 
 
+/**
+ * iwl4965_tx_status_reply_compressed_ba - Update tx status from block-ack
+ *
+ * Go through block-ack's bitmap of ACK'd frames, update driver's record of
+ * ACK vs. not.  This gets sent to mac80211, then to rate scaling algo.
+ */
 static int iwl4965_tx_status_reply_compressed_ba(struct iwl4965_priv *priv,
 						 struct iwl4965_ht_agg *agg,
 						 struct iwl4965_compressed_ba_resp*
@@ -4044,13 +4158,17 @@ static int iwl4965_tx_status_reply_compressed_ba(struct iwl4965_priv *priv,
 		IWL_ERROR("Received BA when not expected\n");
 		return -EINVAL;
 	}
+
+	/* Mark that the expected block-ack response arrived */
 	agg->wait_for_ba = 0;
 	IWL_DEBUG_TX_REPLY("BA %d %d\n", agg->start_idx, ba_resp->ba_seq_ctl);
+
+	/* Calculate shift to align block-ack bits with our Tx window bits */
 	sh = agg->start_idx - SEQ_TO_INDEX(ba_seq_ctl>>4);
 	if (sh < 0) /* tbw something is wrong with indices */
 		sh += 0x100;
 
-	/* don't use 64 bits for now */
+	/* don't use 64-bit values for now */
 	bitmap0 = resp_bitmap0 >> sh;
 	bitmap1 = resp_bitmap1 >> sh;
 	bitmap0 |= (resp_bitmap1 & ((1<<sh)|((1<<sh)-1))) << (32 - sh);
@@ -4061,10 +4179,12 @@ static int iwl4965_tx_status_reply_compressed_ba(struct iwl4965_priv *priv,
 	}
 
 	/* check for success or failure according to the
-	 * transmitted bitmap and back bitmap */
+	 * transmitted bitmap and block-ack bitmap */
 	bitmap0 &= agg->bitmap0;
 	bitmap1 &= agg->bitmap1;
 
+	/* For each frame attempted in aggregation,
+	 * update driver's record of tx frame's status. */
 	for (i = 0; i < agg->frame_count ; i++) {
 		int idx = (agg->start_idx + i) & 0xff;
 		ack = bitmap0 & (1 << i);
@@ -4080,11 +4200,22 @@ static int iwl4965_tx_status_reply_compressed_ba(struct iwl4965_priv *priv,
 	return 0;
 }
 
+/**
+ * iwl4965_queue_dec_wrap - Decrement queue index, wrap back to end if needed
+ * @index -- current index
+ * @n_bd -- total number of entries in queue (s/b power of 2)
+ */
 static inline int iwl4965_queue_dec_wrap(int index, int n_bd)
 {
 	return (index == 0) ? n_bd - 1 : index - 1;
 }
 
+/**
+ * iwl4965_rx_reply_compressed_ba - Handler for REPLY_COMPRESSED_BA
+ *
+ * Handles block-acknowledge notification from device, which reports success
+ * of frames sent via aggregation.
+ */
 static void iwl4965_rx_reply_compressed_ba(struct iwl4965_priv *priv,
 					   struct iwl4965_rx_mem_buffer *rxb)
 {
@@ -4093,7 +4224,12 @@ static void iwl4965_rx_reply_compressed_ba(struct iwl4965_priv *priv,
 	int index;
 	struct iwl4965_tx_queue *txq = NULL;
 	struct iwl4965_ht_agg *agg;
+
+	/* "flow" corresponds to Tx queue */
 	u16 ba_resp_scd_flow = le16_to_cpu(ba_resp->scd_flow);
+
+	/* "ssn" is start of block-ack Tx window, corresponds to index
+	 * (in Tx queue's circular buffer) of first TFD/frame in window */
 	u16 ba_resp_scd_ssn = le16_to_cpu(ba_resp->scd_ssn);
 
 	if (ba_resp_scd_flow >= ARRAY_SIZE(priv->txq)) {
@@ -4103,6 +4239,8 @@ static void iwl4965_rx_reply_compressed_ba(struct iwl4965_priv *priv,
 
 	txq = &priv->txq[ba_resp_scd_flow];
 	agg = &priv->stations[ba_resp->sta_id].tid[ba_resp->tid].agg;
+
+	/* Find index just before block-ack window */
 	index = iwl4965_queue_dec_wrap(ba_resp_scd_ssn & 0xff, txq->q.n_bd);
 
 	/* TODO: Need to get this copy more safely - now good for debug */
@@ -4128,22 +4266,35 @@ static void iwl4965_rx_reply_compressed_ba(struct iwl4965_priv *priv,
 			   agg->bitmap0);
 	}
 */
+
+	/* Update driver's record of ACK vs. not for each frame in window */
 	iwl4965_tx_status_reply_compressed_ba(priv, agg, ba_resp);
-	/* releases all the TFDs until the SSN */
+
+	/* Release all TFDs before the SSN, i.e. all TFDs in front of
+	 * block-ack window (we assume that they've been successfully
+	 * transmitted ... if not, it's too late anyway). */
 	if (txq->q.read_ptr != (ba_resp_scd_ssn & 0xff))
 		iwl4965_tx_queue_reclaim(priv, ba_resp_scd_flow, index);
 
 }
 
 
+/**
+ * iwl4965_tx_queue_stop_scheduler - Stop queue, but keep configuration
+ */
 static void iwl4965_tx_queue_stop_scheduler(struct iwl4965_priv *priv, u16 txq_id)
 {
+	/* Simply stop the queue, but don't change any configuration;
+	 * the SCD_ACT_EN bit is the write-enable mask for the ACTIVE bit. */
 	iwl4965_write_prph(priv,
 		KDR_SCD_QUEUE_STATUS_BITS(txq_id),
 		(0 << SCD_QUEUE_STTS_REG_POS_ACTIVE)|
 		(1 << SCD_QUEUE_STTS_REG_POS_SCD_ACT_EN));
 }
 
+/**
+ * iwl4965_tx_queue_set_q2ratid - Map unique receiver/tid combination to a queue
+ */
 static int iwl4965_tx_queue_set_q2ratid(struct iwl4965_priv *priv, u16 ra_tid,
 					u16 txq_id)
 {
@@ -4169,7 +4320,10 @@ static int iwl4965_tx_queue_set_q2ratid(struct iwl4965_priv *priv, u16 ra_tid,
 }
 
 /**
- * txq_id must be greater than IWL_BACK_QUEUE_FIRST_ID
+ * iwl4965_tx_queue_agg_enable - Set up & enable aggregation for selected queue
+ *
+ * NOTE:  txq_id must be greater than IWL_BACK_QUEUE_FIRST_ID,
+ *        i.e. it must be one of the higher queues used for aggregation
  */
 static int iwl4965_tx_queue_agg_enable(struct iwl4965_priv *priv, int txq_id,
 				       int tx_fifo, int sta_id, int tid,
@@ -4185,6 +4339,7 @@ static int iwl4965_tx_queue_agg_enable(struct iwl4965_priv *priv, int txq_id,
 
 	ra_tid = BUILD_RAxTID(sta_id, tid);
 
+	/* Modify device's station table to Tx this TID */
 	iwl4965_sta_modify_enable_tid_tx(priv, sta_id, tid);
 
 	spin_lock_irqsave(&priv->lock, flags);
@@ -4194,19 +4349,22 @@ static int iwl4965_tx_queue_agg_enable(struct iwl4965_priv *priv, int txq_id,
 		return rc;
 	}
 
+	/* Stop this Tx queue before configuring it */
 	iwl4965_tx_queue_stop_scheduler(priv, txq_id);
 
+	/* Map receiver-address / traffic-ID to this queue */
 	iwl4965_tx_queue_set_q2ratid(priv, ra_tid, txq_id);
 
-
+	/* Set this queue as a chain-building queue */
 	iwl4965_set_bits_prph(priv, KDR_SCD_QUEUECHAIN_SEL, (1<<txq_id));
 
+	/* Place first TFD at index corresponding to start sequence number.
+	 * Assumes that ssn_idx is valid (!= 0xFFF) */
 	priv->txq[txq_id].q.read_ptr = (ssn_idx & 0xff);
 	priv->txq[txq_id].q.write_ptr = (ssn_idx & 0xff);
-
-	/* supposes that ssn_idx is valid (!= 0xFFF) */
 	iwl4965_set_wr_ptrs(priv, txq_id, ssn_idx);
 
+	/* Set up Tx window size and frame limit for this queue */
 	iwl4965_write_targ_mem(priv,
 			priv->scd_base_addr + SCD_CONTEXT_QUEUE_OFFSET(txq_id),
 			(SCD_WIN_SIZE << SCD_QUEUE_CTX_REG1_WIN_SIZE_POS) &
@@ -4219,6 +4377,7 @@ static int iwl4965_tx_queue_agg_enable(struct iwl4965_priv *priv, int txq_id,
 
 	iwl4965_set_bits_prph(priv, KDR_SCD_INTERRUPT_MASK, (1 << txq_id));
 
+	/* Set up Status area in SRAM, map to Tx DMA/FIFO, activate the queue */
 	iwl4965_tx_queue_set_status(priv, &priv->txq[txq_id], tx_fifo, 1);
 
 	iwl4965_release_nic_access(priv);
@@ -4274,14 +4433,16 @@ static int iwl4965_tx_queue_agg_disable(struct iwl4965_priv *priv, u16 txq_id,
 /**
  * iwl4965_add_station - Initialize a station's hardware rate table
  *
- * The uCode contains a table of fallback rates and retries per rate
+ * The uCode's station table contains a table of fallback rates
  * for automatic fallback during transmission.
  *
- * NOTE: This initializes the table for a single retry per data rate
- * which is not optimal.  Setting up an intelligent retry per rate
- * requires feedback from transmission, which isn't exposed through
- * rc80211_simple which is what this driver is currently using.
+ * NOTE: This sets up a default set of values.  These will be replaced later
+ *       if the driver's iwl-4965-rs rate scaling algorithm is used, instead of
+ *       rc80211_simple.
  *
+ * NOTE: Run REPLY_ADD_STA command to set up station table entry, before
+ *       calling this function (which runs REPLY_TX_LINK_QUALITY_CMD,
+ *       which requires station table entry to exist).
  */
 void iwl4965_add_station(struct iwl4965_priv *priv, const u8 *addr, int is_ap)
 {
@@ -4291,8 +4452,8 @@ void iwl4965_add_station(struct iwl4965_priv *priv, const u8 *addr, int is_ap)
 	};
 	u16 rate_flags;
 
-	/* Set up the rate scaling to start at 54M and fallback
-	 * all the way to 1M in IEEE order and then spin on IEEE */
+	/* Set up the rate scaling to start at selected rate, fall back
+	 * all the way down to 1M in IEEE order, and then spin on 1M */
 	if (is_ap)
 		r = IWL_RATE_54M_INDEX;
 	else if (priv->phymode == MODE_IEEE80211A)
@@ -4305,8 +4466,10 @@ void iwl4965_add_station(struct iwl4965_priv *priv, const u8 *addr, int is_ap)
 		if (r >= IWL_FIRST_CCK_RATE && r <= IWL_LAST_CCK_RATE)
 			rate_flags |= RATE_MCS_CCK_MSK;
 
+		/* Use Tx antenna B only */
 		rate_flags |= RATE_MCS_ANT_B_MSK;
 		rate_flags &= ~RATE_MCS_ANT_A_MSK;
+
 		link_cmd.rs_table[i].rate_n_flags =
 			iwl4965_hw_set_rate_n_flags(iwl4965_rates[r].plcp, rate_flags);
 		r = iwl4965_get_prev_ieee_rate(r);
@@ -4374,6 +4537,7 @@ void iwl4965_set_rxon_ht(struct iwl4965_priv *priv, struct sta_ht_info *ht_info)
 	if (!ht_info->is_ht)
 		return;
 
+	/* Set up channel bandwidth:  20 MHz only, or 20/40 mixed if fat ok */
 	if (iwl4965_is_fat_tx_allowed(priv, ht_info))
 		rxon->flags |= RXON_FLG_CHANNEL_MODE_MIXED_MSK;
 	else
@@ -4388,7 +4552,7 @@ void iwl4965_set_rxon_ht(struct iwl4965_priv *priv, struct sta_ht_info *ht_info)
 		return;
 	}
 
-	/* Note: control channel is oposit to extension channel */
+	/* Note: control channel is opposite of extension channel */
 	switch (ht_info->extension_chan_offset) {
 	case IWL_EXT_CHANNEL_OFFSET_ABOVE:
 		rxon->flags &= ~(RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK);
@@ -4514,6 +4678,12 @@ static const u16 default_tid_to_tx_fifo[] = {
 	IWL_TX_FIFO_AC3
 };
 
+/*
+ * Find first available (lowest unused) Tx Queue, mark it "active".
+ * Called only when finding queue for aggregation.
+ * Should never return anything < 7, because they should already
+ * be in use as EDCA AC (0-3), Command (4), HCCA (5, 6).
+ */
 static int iwl4965_txq_ctx_activate_free(struct iwl4965_priv *priv)
 {
 	int txq_id;
@@ -4537,6 +4707,7 @@ int iwl4965_mac_ht_tx_agg_start(struct ieee80211_hw *hw, u8 *da, u16 tid,
 	struct iwl4965_tid_data *tid_data;
 	DECLARE_MAC_BUF(mac);
 
+	/* Determine Tx DMA/FIFO channel for this Traffic ID */
 	if (likely(tid < ARRAY_SIZE(default_tid_to_tx_fifo)))
 		tx_fifo = default_tid_to_tx_fifo[tid];
 	else
@@ -4545,22 +4716,31 @@ int iwl4965_mac_ht_tx_agg_start(struct ieee80211_hw *hw, u8 *da, u16 tid,
 	IWL_WARNING("iwl-AGG iwl4965_mac_ht_tx_agg_start on da=%s"
 		    " tid=%d\n", print_mac(mac, da), tid);
 
+	/* Get index into station table */
 	sta_id = iwl4965_hw_find_station(priv, da);
 	if (sta_id == IWL_INVALID_STATION)
 		return -ENXIO;
 
+	/* Find available Tx queue for aggregation */
 	txq_id = iwl4965_txq_ctx_activate_free(priv);
 	if (txq_id == -1)
 		return -ENXIO;
 
 	spin_lock_irqsave(&priv->sta_lock, flags);
 	tid_data = &priv->stations[sta_id].tid[tid];
+
+	/* Get starting sequence number for 1st frame in block ack window.
+	 * We'll use least signif byte as 1st frame's index into Tx queue. */
 	ssn = SEQ_TO_SN(tid_data->seq_number);
 	tid_data->agg.txq_id = txq_id;
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
 	*start_seq_num = ssn;
+
+	/* Update driver's link quality manager */
 	iwl4965_ba_status(priv, tid, BA_STATUS_ACTIVE);
+
+	/* Set up and enable aggregation for selected Tx queue and FIFO */
 	return iwl4965_tx_queue_agg_enable(priv, txq_id, tx_fifo,
 					   sta_id, tid, ssn);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index f2a3ecd..a840d5d 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -305,6 +305,9 @@ static int iwl4965_tx_queue_alloc(struct iwl4965_priv *priv,
 	return -ENOMEM;
 }
 
+/**
+ * iwl4965_tx_queue_init - Allocate and initialize one tx/cmd queue
+ */
 int iwl4965_tx_queue_init(struct iwl4965_priv *priv,
 		      struct iwl4965_tx_queue *txq, int slots_num, u32 txq_id)
 {
@@ -312,9 +315,14 @@ int iwl4965_tx_queue_init(struct iwl4965_priv *priv,
 	int len;
 	int rc = 0;
 
-	/* allocate command space + one big command for scan since scan
-	 * command is very huge the system will not have two scan at the
-	 * same time */
+	/*
+	 * Alloc buffer array for commands (Tx or other types of commands).
+	 * For the command queue (#4), allocate command space + one big
+	 * command for scan, since scan command is very huge; the system will
+	 * not have two scans at the same time, so only one is needed.
+	 * For normal Tx queues (all other queues), no super-size command
+	 * space is needed.
+	 */
 	len = sizeof(struct iwl4965_cmd) * slots_num;
 	if (txq_id == IWL_CMD_QUEUE_NUM)
 		len +=  IWL_MAX_SCAN_SIZE;
@@ -322,6 +330,7 @@ int iwl4965_tx_queue_init(struct iwl4965_priv *priv,
 	if (!txq->cmd)
 		return -ENOMEM;
 
+	/* Alloc driver data array and TFD circular buffer */
 	rc = iwl4965_tx_queue_alloc(priv, txq, txq_id);
 	if (rc) {
 		pci_free_consistent(dev, len, txq->cmd, txq->dma_addr_cmd);
@@ -333,8 +342,11 @@ int iwl4965_tx_queue_init(struct iwl4965_priv *priv,
 	/* TFD_QUEUE_SIZE_MAX must be power-of-two size, otherwise
 	 * iwl4965_queue_inc_wrap and iwl4965_queue_dec_wrap are broken. */
 	BUILD_BUG_ON(TFD_QUEUE_SIZE_MAX & (TFD_QUEUE_SIZE_MAX - 1));
+
+	/* Initialize queue's high/low-water marks, and head/tail indexes */
 	iwl4965_queue_init(priv, &txq->q, TFD_QUEUE_SIZE_MAX, slots_num, txq_id);
 
+	/* Tell device where to find queue */
 	iwl4965_hw_tx_queue_init(priv, txq);
 
 	return 0;
-- 
1.5.3.6
