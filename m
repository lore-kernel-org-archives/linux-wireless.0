Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37953 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755058Ab2CHVfY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2012 16:35:24 -0500
Subject: Re: [PATCH RESEND 29/35] iwlwifi: move command queue number out of
 the iwl_shared struct
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
In-Reply-To: <20120308191926.GA2469@tuxdriver.com>
References: <1331142764-5750-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1331142764-5750-30-git-send-email-wey-yi.w.guy@intel.com>
	 <20120308191926.GA2469@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Mar 2012 12:21:33 -0800
Message-ID: <1331238093.12612.61.camel@wwguy-huron> (sfid-20120308_223528_656752_3C8762ED)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

I push the revised version of patch, is it works for you?

Thanks
Wey

On Thu, 2012-03-08 at 14:19 -0500, John W. Linville wrote:
> This one didn't apply...
> 
> On Wed, Mar 07, 2012 at 09:52:38AM -0800, Wey-Yi Guy wrote:
> > From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
> > 
> > The command queue number is required by the transport
> > layer, but it can be determined only by the op mode.
> > Move this parameter to the dvm op mode, and configure
> > the transport layer using an API.
> > 
> > Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
> > Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> > ---
> >  drivers/net/wireless/iwlwifi/iwl-agn.c            |   16 +++++-----
> >  drivers/net/wireless/iwlwifi/iwl-shared.h         |    2 -
> >  drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |    2 +
> >  drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c  |    2 +-
> >  drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c  |   24 +++++++-------
> >  drivers/net/wireless/iwlwifi/iwl-trans-pcie.c     |   34 +++++++++++++-------
> >  drivers/net/wireless/iwlwifi/iwl-trans.h          |    9 +++++
> >  7 files changed, 54 insertions(+), 35 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
> > index d45def3..76ee2dd 100644
> > --- a/drivers/net/wireless/iwlwifi/iwl-agn.c
> > +++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
> > @@ -1236,6 +1236,14 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
> >  	 */
> >  	trans_cfg.op_mode = op_mode;
> >  
> > +	if (ucode_flags & IWL_UCODE_TLV_FLAGS_PAN) {
> > +		priv->sta_key_max_num = STA_KEY_MAX_NUM_PAN;
> > +		trans_cfg.cmd_queue = IWL_IPAN_CMD_QUEUE_NUM;
> > +	} else {
> > +		priv->sta_key_max_num = STA_KEY_MAX_NUM;
> > +		trans_cfg.cmd_queue = IWL_DEFAULT_CMD_QUEUE_NUM;
> > +	}
> > +
> >  	/* Configure transport layer */
> >  	iwl_trans_configure(trans(priv), &trans_cfg);
> >  
> > @@ -1336,14 +1344,6 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
> >  	priv->new_scan_threshold_behaviour =
> >  		!!(ucode_flags & IWL_UCODE_TLV_FLAGS_NEWSCAN);
> >  
> > -	if (ucode_flags & IWL_UCODE_TLV_FLAGS_PAN) {
> > -		priv->sta_key_max_num = STA_KEY_MAX_NUM_PAN;
> > -		priv->shrd->cmd_queue = IWL_IPAN_CMD_QUEUE_NUM;
> > -	} else {
> > -		priv->sta_key_max_num = STA_KEY_MAX_NUM;
> > -		priv->shrd->cmd_queue = IWL_DEFAULT_CMD_QUEUE_NUM;
> > -	}
> > -
> >  	priv->phy_calib_chain_noise_reset_cmd =
> >  		fw->ucode_capa.standard_phy_calibration_size;
> >  	priv->phy_calib_chain_noise_gain_cmd =
> > diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
> > index 0e24803..cf34087 100644
> > --- a/drivers/net/wireless/iwlwifi/iwl-shared.h
> > +++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
> > @@ -366,7 +366,6 @@ struct iwl_cfg {
> >  /**
> >   * struct iwl_shared - shared fields for all the layers of the driver
> >   *
> > - * @cmd_queue: command queue number
> >   * @status: STATUS_*
> >   * @wowlan: are we running wowlan uCode
> >   * @valid_contexts: microcode/device supports multiple contexts
> > @@ -383,7 +382,6 @@ struct iwl_cfg {
> >   * @device_pointers: pointers to ucode event tables
> >   */
> >  struct iwl_shared {
> > -	u8 cmd_queue;
> >  	unsigned long status;
> >  	u8 valid_contexts;
> >  
> > diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
> > index dd64e69..14e5d52 100644
> > --- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
> > +++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
> > @@ -248,6 +248,7 @@ struct iwl_tx_queue {
> >   * @ucode_write_complete: indicates that the ucode has been copied.
> >   * @ucode_write_waitq: wait queue for uCode load
> >   * @status - transport specific status flags
> > + * @cmd_queue - command queue number
> >   */
> >  struct iwl_trans_pcie {
> >  	struct iwl_rx_queue rxq;
> > @@ -289,6 +290,7 @@ struct iwl_trans_pcie {
> >  	bool ucode_write_complete;
> >  	wait_queue_head_t ucode_write_waitq;
> >  	unsigned long status;
> > +	u8 cmd_queue;
> >  };
> >  
> >  #define IWL_TRANS_GET_PCIE_TRANS(_iwl_trans) \
> > diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
> > index 17e1487..9bc3c73 100644
> > --- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
> > +++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
> > @@ -361,7 +361,7 @@ static void iwl_rx_handle_rxbuf(struct iwl_trans *trans,
> >  {
> >  	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
> >  	struct iwl_rx_queue *rxq = &trans_pcie->rxq;
> > -	struct iwl_tx_queue *txq = &trans_pcie->txq[trans->shrd->cmd_queue];
> > +	struct iwl_tx_queue *txq = &trans_pcie->txq[trans_pcie->cmd_queue];
> >  	struct iwl_device_cmd *cmd;
> >  	unsigned long flags;
> >  	int len, err;
> > diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
> > index 8d13362..565c664 100644
> > --- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
> > +++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
> > @@ -397,7 +397,7 @@ static void iwlagn_txq_inval_byte_cnt_tbl(struct iwl_trans *trans,
> >  
> >  	WARN_ON(read_ptr >= TFD_QUEUE_SIZE_MAX);
> >  
> > -	if (txq_id != trans->shrd->cmd_queue)
> > +	if (txq_id != trans_pcie->cmd_queue)
> >  		sta_id = tx_cmd->sta_id;
> >  
> >  	bc_ent = cpu_to_le16(1 | (sta_id << 12));
> > @@ -665,7 +665,7 @@ int iwl_trans_pcie_tx_agg_disable(struct iwl_trans *trans, int sta_id, int tid)
> >  static int iwl_enqueue_hcmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
> >  {
> >  	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
> > -	struct iwl_tx_queue *txq = &trans_pcie->txq[trans->shrd->cmd_queue];
> > +	struct iwl_tx_queue *txq = &trans_pcie->txq[trans_pcie->cmd_queue];
> >  	struct iwl_queue *q = &txq->q;
> >  	struct iwl_device_cmd *out_cmd;
> >  	struct iwl_cmd_meta *out_meta;
> > @@ -738,7 +738,7 @@ static int iwl_enqueue_hcmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
> >  	out_cmd->hdr.cmd = cmd->id;
> >  	out_cmd->hdr.flags = 0;
> >  	out_cmd->hdr.sequence =
> > -		cpu_to_le16(QUEUE_TO_SEQ(trans->shrd->cmd_queue) |
> > +		cpu_to_le16(QUEUE_TO_SEQ(trans_pcie->cmd_queue) |
> >  					 INDEX_TO_SEQ(q->write_ptr));
> >  
> >  	/* and copy the data that needs to be copied */
> > @@ -758,7 +758,7 @@ static int iwl_enqueue_hcmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
> >  			get_cmd_string(out_cmd->hdr.cmd),
> >  			out_cmd->hdr.cmd,
> >  			le16_to_cpu(out_cmd->hdr.sequence), cmd_size,
> > -			q->write_ptr, idx, trans->shrd->cmd_queue);
> > +			q->write_ptr, idx, trans_pcie->cmd_queue);
> >  
> >  	phys_addr = dma_map_single(trans->dev, &out_cmd->hdr, copy_size,
> >  				DMA_BIDIRECTIONAL);
> > @@ -882,16 +882,16 @@ void iwl_tx_cmd_complete(struct iwl_trans *trans, struct iwl_rx_cmd_buffer *rxb,
> >  	struct iwl_device_cmd *cmd;
> >  	struct iwl_cmd_meta *meta;
> >  	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
> > -	struct iwl_tx_queue *txq = &trans_pcie->txq[trans->shrd->cmd_queue];
> > +	struct iwl_tx_queue *txq = &trans_pcie->txq[trans_pcie->cmd_queue];
> >  
> >  	/* If a Tx command is being handled and it isn't in the actual
> >  	 * command queue then there a command routing bug has been introduced
> >  	 * in the queue management code. */
> > -	if (WARN(txq_id != trans->shrd->cmd_queue,
> > +	if (WARN(txq_id != trans_pcie->cmd_queue,
> >  		 "wrong command queue %d (should be %d), sequence 0x%X readp=%d writep=%d\n",
> > -		  txq_id, trans->shrd->cmd_queue, sequence,
> > -		  trans_pcie->txq[trans->shrd->cmd_queue].q.read_ptr,
> > -		  trans_pcie->txq[trans->shrd->cmd_queue].q.write_ptr)) {
> > +		  txq_id, trans_pcie->cmd_queue, sequence,
> > +		  trans_pcie->txq[trans_pcie->cmd_queue].q.read_ptr,
> > +		  trans_pcie->txq[trans_pcie->cmd_queue].q.write_ptr)) {
> >  		iwl_print_hex_error(trans, pkt, 32);
> >  		return;
> >  	}
> > @@ -998,7 +998,7 @@ static int iwl_send_cmd_sync(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
> >  	if (!ret) {
> >  		if (test_bit(STATUS_HCMD_ACTIVE, &trans->shrd->status)) {
> >  			struct iwl_tx_queue *txq =
> > -				&trans_pcie->txq[trans->shrd->cmd_queue];
> > +				&trans_pcie->txq[trans_pcie->cmd_queue];
> >  			struct iwl_queue *q = &txq->q;
> >  
> >  			IWL_ERR(trans,
> > @@ -1035,7 +1035,7 @@ cancel:
> >  		 * in later, it will possibly set an invalid
> >  		 * address (cmd->meta.source).
> >  		 */
> > -		trans_pcie->txq[trans->shrd->cmd_queue].meta[cmd_idx].flags &=
> > +		trans_pcie->txq[trans_pcie->cmd_queue].meta[cmd_idx].flags &=
> >  							~CMD_WANT_SKB;
> >  	}
> >  
> > @@ -1066,7 +1066,7 @@ int iwl_tx_queue_reclaim(struct iwl_trans *trans, int txq_id, int index,
> >  	int freed = 0;
> >  
> >  	/* This function is not meant to release cmd queue*/
> > -	if (WARN_ON(txq_id == trans->shrd->cmd_queue))
> > +	if (WARN_ON(txq_id == trans_pcie->cmd_queue))
> >  		return 0;
> >  
> >  	lockdep_assert_held(&txq->lock);
> > diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
> > index b0d34f7..f28f4cb 100644
> > --- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
> > +++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
> > @@ -78,9 +78,9 @@
> >  
> >  #define IWL_MASK(lo, hi) ((1 << (hi)) | ((1 << (hi)) - (1 << (lo))))
> >  
> > -#define SCD_QUEUECHAIN_SEL_ALL(trans)	\
> > +#define SCD_QUEUECHAIN_SEL_ALL(trans, trans_pcie)	\
> >  	(((1<<cfg(trans)->base_params->num_of_queues) - 1) &\
> > -	(~(1<<(trans)->shrd->cmd_queue)))
> > +	(~(1<<(trans_pcie)->cmd_queue)))
> >  
> >  
> >  static int iwl_trans_rx_alloc(struct iwl_trans *trans)
> > @@ -306,6 +306,7 @@ static int iwl_trans_txq_alloc(struct iwl_trans *trans,
> >  {
> >  	size_t tfd_sz = sizeof(struct iwl_tfd) * TFD_QUEUE_SIZE_MAX;
> >  	int i;
> > +	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
> >  
> >  	if (WARN_ON(txq->meta || txq->cmd || txq->skbs || txq->tfds))
> >  		return -EINVAL;
> > @@ -318,7 +319,7 @@ static int iwl_trans_txq_alloc(struct iwl_trans *trans,
> >  	if (!txq->meta || !txq->cmd)
> >  		goto error;
> >  
> > -	if (txq_id == trans->shrd->cmd_queue)
> > +	if (txq_id == trans_pcie->cmd_queue)
> >  		for (i = 0; i < slots_num; i++) {
> >  			txq->cmd[i] = kmalloc(sizeof(struct iwl_device_cmd),
> >  						GFP_KERNEL);
> > @@ -329,7 +330,7 @@ static int iwl_trans_txq_alloc(struct iwl_trans *trans,
> >  	/* Alloc driver data array and TFD circular buffer */
> >  	/* Driver private data, only for Tx (not command) queues,
> >  	 * not shared with device. */
> > -	if (txq_id != trans->shrd->cmd_queue) {
> > +	if (txq_id != trans_pcie->cmd_queue) {
> >  		txq->skbs = kcalloc(TFD_QUEUE_SIZE_MAX, sizeof(txq->skbs[0]),
> >  				    GFP_KERNEL);
> >  		if (!txq->skbs) {
> > @@ -357,7 +358,7 @@ error:
> >  	txq->skbs = NULL;
> >  	/* since txq->cmd has been zeroed,
> >  	 * all non allocated cmd[i] will be NULL */
> > -	if (txq->cmd && txq_id == trans->shrd->cmd_queue)
> > +	if (txq->cmd && txq_id == trans_pcie->cmd_queue)
> >  		for (i = 0; i < slots_num; i++)
> >  			kfree(txq->cmd[i]);
> >  	kfree(txq->meta);
> > @@ -423,7 +424,7 @@ static void iwl_tx_queue_unmap(struct iwl_trans *trans, int txq_id)
> >  	/* In the command queue, all the TBs are mapped as BIDI
> >  	 * so unmap them as such.
> >  	 */
> > -	if (txq_id == trans->shrd->cmd_queue)
> > +	if (txq_id == trans_pcie->cmd_queue)
> >  		dma_dir = DMA_BIDIRECTIONAL;
> >  	else
> >  		dma_dir = DMA_TO_DEVICE;
> > @@ -459,7 +460,7 @@ static void iwl_tx_queue_free(struct iwl_trans *trans, int txq_id)
> >  
> >  	/* De-alloc array of command/tx buffers */
> >  
> > -	if (txq_id == trans->shrd->cmd_queue)
> > +	if (txq_id == trans_pcie->cmd_queue)
> >  		for (i = 0; i < txq->q.n_window; i++)
> >  			kfree(txq->cmd[i]);
> >  
> > @@ -557,7 +558,7 @@ static int iwl_trans_tx_alloc(struct iwl_trans *trans)
> >  	/* Alloc and init all Tx queues, including the command queue (#4/#9) */
> >  	for (txq_id = 0; txq_id < cfg(trans)->base_params->num_of_queues;
> >  	     txq_id++) {
> > -		slots_num = (txq_id == trans->shrd->cmd_queue) ?
> > +		slots_num = (txq_id == trans_pcie->cmd_queue) ?
> >  					TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
> >  		ret = iwl_trans_txq_alloc(trans, &trans_pcie->txq[txq_id],
> >  					  slots_num, txq_id);
> > @@ -603,7 +604,7 @@ static int iwl_tx_init(struct iwl_trans *trans)
> >  	/* Alloc and init all Tx queues, including the command queue (#4/#9) */
> >  	for (txq_id = 0; txq_id < cfg(trans)->base_params->num_of_queues;
> >  	     txq_id++) {
> > -		slots_num = (txq_id == trans->shrd->cmd_queue) ?
> > +		slots_num = (txq_id == trans_pcie->cmd_queue) ?
> >  					TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
> >  		ret = iwl_trans_txq_init(trans, &trans_pcie->txq[txq_id],
> >  					 slots_num, txq_id);
> > @@ -1138,7 +1139,7 @@ static void iwl_tx_start(struct iwl_trans *trans)
> >  			   reg_val | FH_TX_CHICKEN_BITS_SCD_AUTO_RETRY_EN);
> >  
> >  	iwl_write_prph(trans, SCD_QUEUECHAIN_SEL,
> > -		SCD_QUEUECHAIN_SEL_ALL(trans));
> > +		SCD_QUEUECHAIN_SEL_ALL(trans, trans_pcie));
> >  	iwl_write_prph(trans, SCD_AGGR_SEL, 0);
> >  
> >  	/* initiate the queues */
> > @@ -1170,7 +1171,7 @@ static void iwl_tx_start(struct iwl_trans *trans)
> >  	else
> >  		queue_to_fifo = iwlagn_default_queue_to_tx_fifo;
> >  
> > -	iwl_trans_set_wr_ptrs(trans, trans->shrd->cmd_queue, 0);
> > +	iwl_trans_set_wr_ptrs(trans, trans_pcie->cmd_queue, 0);
> >  
> >  	/* make sure all queue are not stopped */
> >  	memset(&trans_pcie->queue_stopped[0], 0,
> > @@ -1622,6 +1623,14 @@ static u32 iwl_trans_pcie_read32(struct iwl_trans *trans, u32 ofs)
> >  	return readl(IWL_TRANS_GET_PCIE_TRANS(trans)->hw_base + ofs);
> >  }
> >  
> > +static void iwl_trans_pcie_configure(struct iwl_trans *trans,
> > +			      const struct iwl_trans_config *trans_cfg)
> > +{
> > +	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
> > +
> > +	trans_pcie->cmd_queue = trans_cfg->cmd_queue;
> > +}
> > +
> >  static void iwl_trans_pcie_free(struct iwl_trans *trans)
> >  {
> >  	struct iwl_trans_pcie *trans_pcie =
> > @@ -1682,7 +1691,7 @@ static int iwl_trans_pcie_wait_tx_queue_empty(struct iwl_trans *trans)
> >  
> >  	/* waiting for all the tx frames complete might take a while */
> >  	for (cnt = 0; cnt < cfg(trans)->base_params->num_of_queues; cnt++) {
> > -		if (cnt == trans->shrd->cmd_queue)
> > +		if (cnt == trans_pcie->cmd_queue)
> >  			continue;
> >  		txq = &trans_pcie->txq[cnt];
> >  		q = &txq->q;
> > @@ -2213,6 +2222,7 @@ const struct iwl_trans_ops trans_ops_pcie = {
> >  	.write8 = iwl_trans_pcie_write8,
> >  	.write32 = iwl_trans_pcie_write32,
> >  	.read32 = iwl_trans_pcie_read32,
> > +	.configure = iwl_trans_pcie_configure,
> >  };
> >  
> >  struct iwl_trans *iwl_trans_pcie_alloc(struct iwl_shared *shrd,
> > diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
> > index b6fd427..a40c272 100644
> > --- a/drivers/net/wireless/iwlwifi/iwl-trans.h
> > +++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
> > @@ -279,9 +279,12 @@ static inline struct page *rxb_steal_page(struct iwl_rx_cmd_buffer *r)
> >   *
> >   * @op_mode: pointer to the upper layer.
> >   *	Must be set before any other call.
> > + * @cmd_queue: the index of the command queue.
> > + *	Must be set before start_fw.
> >   */
> >  struct iwl_trans_config {
> >  	struct iwl_op_mode *op_mode;
> > +	u8 cmd_queue;
> >  };
> >  
> >  /**
> > @@ -331,6 +334,8 @@ struct iwl_trans_config {
> >   * @write8: write a u8 to a register at offset ofs from the BAR
> >   * @write32: write a u32 to a register at offset ofs from the BAR
> >   * @read32: read a u32 register at offset ofs from the BAR
> > + * @configure: configure parameters required by the transport layer from
> > + *	the op_mode.
> >   */
> >  struct iwl_trans_ops {
> >  
> > @@ -370,6 +375,8 @@ struct iwl_trans_ops {
> >  	void (*write8)(struct iwl_trans *trans, u32 ofs, u8 val);
> >  	void (*write32)(struct iwl_trans *trans, u32 ofs, u32 val);
> >  	u32 (*read32)(struct iwl_trans *trans, u32 ofs);
> > +	void (*configure)(struct iwl_trans *trans,
> > +			  const struct iwl_trans_config *trans_cfg);
> >  };
> >  
> >  /**
> > @@ -425,6 +432,8 @@ static inline void iwl_trans_configure(struct iwl_trans *trans,
> >  	 * more
> >  	 */
> >  	trans->op_mode = trans_cfg->op_mode;
> > +
> > +	trans->ops->configure(trans, trans_cfg);
> >  }
> >  
> >  static inline int iwl_trans_start_hw(struct iwl_trans *trans)
> > -- 
> > 1.7.0.4
> > 
> > 
> 


