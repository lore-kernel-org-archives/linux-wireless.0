Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:30374 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750AbYKGR6Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2008 12:58:16 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 07/13] iwlwifi: revamp tx scheduler byte count tables handling
Date: Fri,  7 Nov 2008 09:58:40 -0800
Message-Id: <1226080726-24860-8-git-send-email-reinette.chatre@intel.com> (sfid-20081107_185825_668770_F9B4EA6D)
In-Reply-To: <1226080726-24860-7-git-send-email-reinette.chatre@intel.com>
References: <>
 <1226080726-24860-1-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-2-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-3-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-4-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-5-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-6-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-7-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This moves byte count tables to tx domain removing completely
ambivalent shared data. Changes handling of allocation
byte count tables and keep warm consistent memory
Moves general tx scheduler definitions from iwl-4956-hw.h
to iwl-fh.h

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h |   90 +---------------------------
 drivers/net/wireless/iwlwifi/iwl-4965.c    |   35 ++---------
 drivers/net/wireless/iwlwifi/iwl-5000-hw.h |    8 +--
 drivers/net/wireless/iwlwifi/iwl-5000.c    |   45 +++-----------
 drivers/net/wireless/iwlwifi/iwl-agn.c     |    8 ---
 drivers/net/wireless/iwlwifi/iwl-core.c    |   46 --------------
 drivers/net/wireless/iwlwifi/iwl-core.h    |    7 --
 drivers/net/wireless/iwlwifi/iwl-dev.h     |   21 +++----
 drivers/net/wireless/iwlwifi/iwl-fh.h      |   65 ++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-tx.c      |   48 +++++++++++----
 10 files changed, 129 insertions(+), 244 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
index 94ae1a8..fb0fd77 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
@@ -819,64 +819,6 @@ enum {
 #define IWL49_NUM_QUEUES	16
 #define IWL49_NUM_AMPDU_QUEUES	8
 
-#define IWL_TX_DMA_MASK        (DMA_BIT_MASK(36) & ~0x3)
-#define IWL_NUM_OF_TBS		20
-
-static inline u8 iwl_get_dma_hi_addr(dma_addr_t addr)
-{
-	return (sizeof(addr) > sizeof(u32) ? (addr >> 16) >> 16 : 0) & 0xF;
-}
-/**
- * struct iwl_tfd_tb transmit buffer descriptor within transmit frame descriptor
- *
- * This structure contains dma address and length of transmission address
- *
- * @lo: low [31:0] portion of the dma address of TX buffer
- * 	every even is unaligned on 16 bit boundary
- * @hi_n_len 0-3 [35:32] portion of dma
- *	     4-16 length of the tx buffer
- */
-struct iwl_tfd_tb {
-	__le32 lo;
-	__le16 hi_n_len;
-} __attribute__((packed));
-
-/**
- * struct iwl_tfd
- *
- * Transmit Frame Descriptor (TFD)
- *
- * @ __reserved1[3] reserved
- * @ num_tbs 0-5 number of active tbs
- * 	     6-7 padding (not used)
- * @ tbs[20]	transmit frame buffer descriptors
- * @ __pad 	padding
- *
- * Each Tx queue uses a circular buffer of 256 TFDs stored in host DRAM.
- * Both driver and device share these circular buffers, each of which must be
- * contiguous 256 TFDs x 128 bytes-per-TFD = 32 KBytes
- *
- * Driver must indicate the physical address of the base of each
- * circular buffer via the FH_MEM_CBBC_QUEUE registers.
- *
- * Each TFD contains pointer/size information for up to 20 data buffers
- * in host DRAM.  These buffers collectively contain the (one) frame described
- * by the TFD.  Each buffer must be a single contiguous block of memory within
- * itself, but buffers may be scattered in host DRAM.  Each buffer has max size
- * of (4K - 4).  The concatenates all of a TFD's buffers into a single
- * Tx frame, up to 8 KBytes in size.
- *
- * A maximum of 255 (not 256!) TFDs may be on a queue waiting for Tx.
- *
- * Bit fields in the control dword (val0):
- */
-struct iwl_tfd {
-	u8 __reserved1[3];
-	u8 num_tbs;
-	struct iwl_tfd_tb tbs[IWL_NUM_OF_TBS];
-	__le32 __pad;
-} __attribute__ ((packed));
-
 
 /**
  * struct iwl4965_schedq_bc_tbl
@@ -896,37 +838,9 @@ struct iwl_tfd {
  * padding puts each byte count table on a 1024-byte boundary;
  * 4965 assumes tables are separated by 1024 bytes.
  */
-struct iwl4965_schedq_bc_tbl {
+struct iwl4965_scd_bc_tbl {
 	__le16 tfd_offset[TFD_QUEUE_BC_SIZE];
 	u8 pad[1024 - (TFD_QUEUE_BC_SIZE) * sizeof(__le16)];
 } __attribute__ ((packed));
 
-
-/**
- * struct iwl4965_shared - handshake area for Tx and Rx
- *
- * For convenience in allocating memory, this structure combines 2 areas of
- * DRAM which must be shared between driver and 4965.  These do not need to
- * be combined, if better allocation would result from keeping them separate:
- *
- * 1)  The Tx byte count tables occupy 1024 bytes each (16 KBytes total for
- *     16 queues).  Driver uses SCD_DRAM_BASE_ADDR to tell 4965 where to find
- *     the first of these tables.  4965 assumes tables are 1024 bytes apart.
- *
- * 2)  The Rx status (val0 and val1) occupies only 8 bytes.  Driver uses
- *     FH_RSCSR_CHNL0_STTS_WPTR_REG to tell 4965 where to find this area.
- *     Driver reads val0 to determine the latest Receive Buffer Descriptor (RBD)
- *     that has been filled by the 4965.
- *
- * Bit fields val0:
- * 31-12:  Not used
- * 11- 0:  Index of last filled Rx buffer descriptor (4965 writes, driver reads)
- *
- * Bit fields val1:
- * 31- 0:  Not used
- */
-struct iwl4965_shared {
-	struct iwl4965_schedq_bc_tbl queues_bc_tbls[IWL49_NUM_QUEUES];
-} __attribute__ ((packed));
-
-#endif /* __iwl4965_4965_hw_h__ */
+#endif /* !__iwl_4965_hw_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 017e5ea..c43cf2f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -715,8 +715,7 @@ static int iwl4965_alive_notify(struct iwl_priv *priv)
 
 	/* Tel 4965 where to find Tx byte count tables */
 	iwl_write_prph(priv, IWL49_SCD_DRAM_BASE_ADDR,
-		(priv->shared_phys +
-		 offsetof(struct iwl4965_shared, queues_bc_tbls)) >> 10);
+			priv->scd_bc_tbls.dma >> 10);
 
 	/* Disable chain mode for all queues */
 	iwl_write_prph(priv, IWL49_SCD_QUEUECHAIN_SEL, 0);
@@ -804,6 +803,8 @@ static int iwl4965_hw_set_hw_params(struct iwl_priv *priv)
 	}
 
 	priv->hw_params.max_txq_num = priv->cfg->mod_params->num_of_queues;
+	priv->hw_params.scd_bc_tbls_size =
+			IWL49_NUM_QUEUES * sizeof(struct iwl4965_scd_bc_tbl);
 	priv->hw_params.max_stations = IWL4965_STATION_COUNT;
 	priv->hw_params.bcast_sta_id = IWL4965_BROADCAST_ID;
 	priv->hw_params.max_data_size = IWL49_RTC_DATA_SIZE;
@@ -1631,28 +1632,6 @@ static int iwl4965_hw_channel_switch(struct iwl_priv *priv, u16 channel)
 }
 #endif
 
-static int iwl4965_alloc_shared_mem(struct iwl_priv *priv)
-{
-	priv->shared_virt = pci_alloc_consistent(priv->pci_dev,
-					sizeof(struct iwl4965_shared),
-					&priv->shared_phys);
-	if (!priv->shared_virt)
-		return -ENOMEM;
-
-	memset(priv->shared_virt, 0, sizeof(struct iwl4965_shared));
-
-	return 0;
-}
-
-static void iwl4965_free_shared_mem(struct iwl_priv *priv)
-{
-	if (priv->shared_virt)
-		pci_free_consistent(priv->pci_dev,
-				    sizeof(struct iwl4965_shared),
-				    priv->shared_virt,
-				    priv->shared_phys);
-}
-
 /**
  * iwl4965_txq_update_byte_cnt_tbl - Set up entry in Tx byte-count array
  */
@@ -1660,7 +1639,7 @@ static void iwl4965_txq_update_byte_cnt_tbl(struct iwl_priv *priv,
 					    struct iwl_tx_queue *txq,
 					    u16 byte_cnt)
 {
-	struct iwl4965_shared *shared_data = priv->shared_virt;
+	struct iwl4965_scd_bc_tbl *scd_bc_tbl = priv->scd_bc_tbls.addr;
 	int txq_id = txq->q.id;
 	int write_ptr = txq->q.write_ptr;
 	int len = byte_cnt + IWL_TX_CRC_SIZE + IWL_TX_DELIMITER_SIZE;
@@ -1670,11 +1649,11 @@ static void iwl4965_txq_update_byte_cnt_tbl(struct iwl_priv *priv,
 
 	bc_ent = cpu_to_le16(len & 0xFFF);
 	/* Set up byte count within first 256 entries */
-	shared_data->queues_bc_tbls[txq_id].tfd_offset[write_ptr] = bc_ent;
+	scd_bc_tbl[txq_id].tfd_offset[write_ptr] = bc_ent;
 
 	/* If within first 64 entries, duplicate at end */
 	if (write_ptr < TFD_QUEUE_SIZE_BC_DUP)
-		shared_data->queues_bc_tbls[txq_id].
+		scd_bc_tbl[txq_id].
 			tfd_offset[TFD_QUEUE_SIZE_MAX + write_ptr] = bc_ent;
 }
 
@@ -2296,8 +2275,6 @@ static struct iwl_hcmd_utils_ops iwl4965_hcmd_utils = {
 
 static struct iwl_lib_ops iwl4965_lib = {
 	.set_hw_params = iwl4965_hw_set_hw_params,
-	.alloc_shared_mem = iwl4965_alloc_shared_mem,
-	.free_shared_mem = iwl4965_free_shared_mem,
 	.txq_update_byte_cnt_tbl = iwl4965_txq_update_byte_cnt_tbl,
 	.txq_set_sched = iwl4965_txq_set_sched,
 	.txq_agg_enable = iwl4965_txq_agg_enable,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000-hw.h b/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
index 8f9edc7..c6595e8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
@@ -90,16 +90,10 @@
  * @tfd_offset  0-12 - tx command byte count
  *	       12-16 - station index
  */
-struct iwl5000_schedq_bc_tbl {
+struct iwl5000_scd_bc_tbl {
 	__le16 tfd_offset[TFD_QUEUE_BC_SIZE];
 } __attribute__ ((packed));
 
-/**
- * struct iwl5000_shared
- */
-struct iwl5000_shared {
-	struct iwl5000_schedq_bc_tbl queues_bc_tbls[IWL50_NUM_QUEUES];
-} __attribute__ ((packed));
 
 #endif /* __iwl_5000_hw_h__ */
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index e81000c..ee3613d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -721,11 +721,9 @@ static int iwl5000_alive_notify(struct iwl_priv *priv)
 		iwl_write_targ_mem(priv, a, 0);
 
 	iwl_write_prph(priv, IWL50_SCD_DRAM_BASE_ADDR,
-		(priv->shared_phys +
-		 offsetof(struct iwl5000_shared, queues_bc_tbls)) >> 10);
+		       priv->scd_bc_tbls.dma >> 10);
 	iwl_write_prph(priv, IWL50_SCD_QUEUECHAIN_SEL,
-		IWL50_SCD_QUEUECHAIN_SEL_ALL(
-			priv->hw_params.max_txq_num));
+		IWL50_SCD_QUEUECHAIN_SEL_ALL(priv->hw_params.max_txq_num));
 	iwl_write_prph(priv, IWL50_SCD_AGGR_SEL, 0);
 
 	/* initiate the queues */
@@ -788,6 +786,8 @@ static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 	}
 
 	priv->hw_params.max_txq_num = priv->cfg->mod_params->num_of_queues;
+	priv->hw_params.scd_bc_tbls_size =
+			IWL50_NUM_QUEUES * sizeof(struct iwl5000_scd_bc_tbl);
 	priv->hw_params.max_stations = IWL5000_STATION_COUNT;
 	priv->hw_params.bcast_sta_id = IWL5000_BROADCAST_ID;
 	priv->hw_params.max_data_size = IWL50_RTC_DATA_SIZE;
@@ -853,28 +853,6 @@ static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 	return 0;
 }
 
-static int iwl5000_alloc_shared_mem(struct iwl_priv *priv)
-{
-	priv->shared_virt = pci_alloc_consistent(priv->pci_dev,
-					sizeof(struct iwl5000_shared),
-					&priv->shared_phys);
-	if (!priv->shared_virt)
-		return -ENOMEM;
-
-	memset(priv->shared_virt, 0, sizeof(struct iwl5000_shared));
-
-	return 0;
-}
-
-static void iwl5000_free_shared_mem(struct iwl_priv *priv)
-{
-	if (priv->shared_virt)
-		pci_free_consistent(priv->pci_dev,
-				    sizeof(struct iwl5000_shared),
-				    priv->shared_virt,
-				    priv->shared_phys);
-}
-
 /**
  * iwl5000_txq_update_byte_cnt_tbl - Set up entry in Tx byte-count array
  */
@@ -882,7 +860,7 @@ static void iwl5000_txq_update_byte_cnt_tbl(struct iwl_priv *priv,
 					    struct iwl_tx_queue *txq,
 					    u16 byte_cnt)
 {
-	struct iwl5000_shared *shared_data = priv->shared_virt;
+	struct iwl5000_scd_bc_tbl *scd_bc_tbl = priv->scd_bc_tbls.addr;
 	int write_ptr = txq->q.write_ptr;
 	int txq_id = txq->q.id;
 	u8 sec_ctl = 0;
@@ -911,17 +889,17 @@ static void iwl5000_txq_update_byte_cnt_tbl(struct iwl_priv *priv,
 
 	bc_ent = cpu_to_le16((len & 0xFFF) | (sta_id << 12));
 
-	shared_data->queues_bc_tbls[txq_id].tfd_offset[write_ptr] = bc_ent;
+	scd_bc_tbl[txq_id].tfd_offset[write_ptr] = bc_ent;
 
 	if (txq->q.write_ptr < TFD_QUEUE_SIZE_BC_DUP)
-		shared_data->queues_bc_tbls[txq_id].
+		scd_bc_tbl[txq_id].
 			tfd_offset[TFD_QUEUE_SIZE_MAX + write_ptr] = bc_ent;
 }
 
 static void iwl5000_txq_inval_byte_cnt_tbl(struct iwl_priv *priv,
 					   struct iwl_tx_queue *txq)
 {
-	struct iwl5000_shared *shared_data = priv->shared_virt;
+	struct iwl5000_scd_bc_tbl *scd_bc_tbl = priv->scd_bc_tbls.addr;
 	int txq_id = txq->q.id;
 	int read_ptr = txq->q.read_ptr;
 	u8 sta_id = 0;
@@ -933,11 +911,10 @@ static void iwl5000_txq_inval_byte_cnt_tbl(struct iwl_priv *priv,
 		sta_id = txq->cmd[read_ptr]->cmd.tx.sta_id;
 
 	bc_ent =  cpu_to_le16(1 | (sta_id << 12));
-	shared_data->queues_bc_tbls[txq_id].
-			tfd_offset[read_ptr] = bc_ent;
+	scd_bc_tbl[txq_id].tfd_offset[read_ptr] = bc_ent;
 
 	if (txq->q.write_ptr < TFD_QUEUE_SIZE_BC_DUP)
-		shared_data->queues_bc_tbls[txq_id].
+		scd_bc_tbl[txq_id].
 			tfd_offset[TFD_QUEUE_SIZE_MAX + read_ptr] =  bc_ent;
 }
 
@@ -1450,8 +1427,6 @@ static struct iwl_hcmd_utils_ops iwl5000_hcmd_utils = {
 
 static struct iwl_lib_ops iwl5000_lib = {
 	.set_hw_params = iwl5000_hw_set_hw_params,
-	.alloc_shared_mem = iwl5000_alloc_shared_mem,
-	.free_shared_mem = iwl5000_free_shared_mem,
 	.txq_update_byte_cnt_tbl = iwl5000_txq_update_byte_cnt_tbl,
 	.txq_inval_byte_cnt_tbl = iwl5000_txq_inval_byte_cnt_tbl,
 	.txq_set_sched = iwl5000_txq_set_sched,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 1adda56..bf736e7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2200,8 +2200,6 @@ static void __iwl_down(struct iwl_priv *priv)
 		priv->cfg->ops->lib->apm_ops.stop(priv);
 	else
 		priv->cfg->ops->lib->apm_ops.reset(priv);
-	priv->cfg->ops->lib->free_shared_mem(priv);
-
  exit:
 	memset(&priv->card_alive, 0, sizeof(struct iwl_alive_resp));
 
@@ -2254,12 +2252,6 @@ static int __iwl_up(struct iwl_priv *priv)
 
 	iwl_write32(priv, CSR_INT, 0xFFFFFFFF);
 
-	ret = priv->cfg->ops->lib->alloc_shared_mem(priv);
-	if (ret) {
-		IWL_ERROR("Unable to allocate shared memory\n");
-		return ret;
-	}
-
 	ret = iwl_hw_nic_init(priv);
 	if (ret) {
 		IWL_ERROR("Unable to init nic\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index ec474db..8bd4d08 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -189,52 +189,6 @@ void iwl_hw_detect(struct iwl_priv *priv)
 }
 EXPORT_SYMBOL(iwl_hw_detect);
 
-/* Tell nic where to find the "keep warm" buffer */
-int iwl_kw_init(struct iwl_priv *priv)
-{
-	unsigned long flags;
-	int ret;
-
-	spin_lock_irqsave(&priv->lock, flags);
-	ret = iwl_grab_nic_access(priv);
-	if (ret)
-		goto out;
-
-	iwl_write_direct32(priv, FH_KW_MEM_ADDR_REG,
-			     priv->kw.dma_addr >> 4);
-	iwl_release_nic_access(priv);
-out:
-	spin_unlock_irqrestore(&priv->lock, flags);
-	return ret;
-}
-
-int iwl_kw_alloc(struct iwl_priv *priv)
-{
-	struct pci_dev *dev = priv->pci_dev;
-	struct iwl_kw *kw = &priv->kw;
-
-	kw->size = IWL_KW_SIZE;
-	kw->v_addr = pci_alloc_consistent(dev, kw->size, &kw->dma_addr);
-	if (!kw->v_addr)
-		return -ENOMEM;
-
-	return 0;
-}
-
-/**
- * iwl_kw_free - Free the "keep warm" buffer
- */
-void iwl_kw_free(struct iwl_priv *priv)
-{
-	struct pci_dev *dev = priv->pci_dev;
-	struct iwl_kw *kw = &priv->kw;
-
-	if (kw->v_addr) {
-		pci_free_consistent(dev, kw->size, kw->v_addr, kw->dma_addr);
-		memset(kw, 0, sizeof(*kw));
-	}
-}
-
 int iwl_hw_nic_init(struct iwl_priv *priv)
 {
 	unsigned long flags;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 1dca9d3..1ae7a11 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -102,9 +102,6 @@ struct iwl_hcmd_utils_ops {
 struct iwl_lib_ops {
 	/* set hw dependent parameters */
 	int (*set_hw_params)(struct iwl_priv *priv);
-	/* ucode shared memory */
-	int (*alloc_shared_mem)(struct iwl_priv *priv);
-	void (*free_shared_mem)(struct iwl_priv *priv);
 	/* Handling TX */
 	void (*txq_update_byte_cnt_tbl)(struct iwl_priv *priv,
 					struct iwl_tx_queue *txq,
@@ -197,10 +194,6 @@ int iwl_setup_mac(struct iwl_priv *priv);
 int iwl_set_hw_params(struct iwl_priv *priv);
 int iwl_init_drv(struct iwl_priv *priv);
 void iwl_uninit_drv(struct iwl_priv *priv);
-/* "keep warm" functions */
-int iwl_kw_init(struct iwl_priv *priv);
-int iwl_kw_alloc(struct iwl_priv *priv);
-void iwl_kw_free(struct iwl_priv *priv);
 
 /*****************************************************
 * RX
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index f4e81a4..4126a4c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -506,6 +506,7 @@ struct iwl_sensitivity_ranges {
 /**
  * struct iwl_hw_params
  * @max_txq_num: Max # Tx queues supported
+ * @scd_bc_tbls_size: size of scheduler byte count tables
  * @tx/rx_chains_num: Number of TX/RX chains
  * @valid_tx/rx_ant: usable antennas
  * @max_rxq_size: Max # Rx frames in Rx queue (must be power-of-2)
@@ -523,6 +524,7 @@ struct iwl_sensitivity_ranges {
  */
 struct iwl_hw_params {
 	u16 max_txq_num;
+	u16 scd_bc_tbls_size;
 	u8  tx_chains_num;
 	u8  rx_chains_num;
 	u8  valid_tx_ant;
@@ -604,13 +606,9 @@ static inline u8 get_cmd_index(struct iwl_queue *q, u32 index, int is_huge)
 struct iwl_priv;
 
 
-/* Structures, enum, and defines specific to the 4965 */
-
-#define IWL_KW_SIZE 0x1000	/*4k */
-
-struct iwl_kw {
-	dma_addr_t dma_addr;
-	void *v_addr;
+struct iwl_dma_ptr {
+	dma_addr_t dma;
+	void *addr;
 	size_t size;
 };
 
@@ -906,7 +904,9 @@ struct iwl_priv {
 	struct iwl_rx_queue rxq;
 	struct iwl_tx_queue txq[IWL_MAX_NUM_QUEUES];
 	unsigned long txq_ctx_active_msk;
-	struct iwl_kw kw;	/* keep warm address */
+	struct iwl_dma_ptr  kw;	/* keep warm address */
+	struct iwl_dma_ptr  scd_bc_tbls;
+
 	u32 scd_base_addr;	/* scheduler sram base address */
 
 	unsigned long status;
@@ -966,10 +966,7 @@ struct iwl_priv {
 	struct ieee80211_vif *vif;
 
 	struct iwl_hw_params hw_params;
-	/* driver/uCode shared Tx Byte Counts */
-	void *shared_virt;
-	/* Physical Pointer to Tx Byte Counts */
-	dma_addr_t shared_phys;
+
 
 	/* Current association information needed to configure the
 	 * hardware */
diff --git a/drivers/net/wireless/iwlwifi/iwl-fh.h b/drivers/net/wireless/iwlwifi/iwl-fh.h
index 1537542..2c5f919 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fh.h
@@ -420,4 +420,69 @@ struct iwl_rb_status {
 	__le16 finished_fr_nam;
 } __attribute__ ((packed));
 
+
+
+#define IWL_TX_DMA_MASK        DMA_BIT_MASK(36)
+
+#define IWL_NUM_OF_TBS		20
+
+static inline u8 iwl_get_dma_hi_addr(dma_addr_t addr)
+{
+	return (sizeof(addr) > sizeof(u32) ? (addr >> 16) >> 16 : 0) & 0xF;
+}
+/**
+ * struct iwl_tfd_tb transmit buffer descriptor within transmit frame descriptor
+ *
+ * This structure contains dma address and length of transmission address
+ *
+ * @lo: low [31:0] portion of the dma address of TX buffer
+ * 	every even is unaligned on 16 bit boundary
+ * @hi_n_len 0-3 [35:32] portion of dma
+ *	     4-16 length of the tx buffer
+ */
+struct iwl_tfd_tb {
+	__le32 lo;
+	__le16 hi_n_len;
+} __attribute__((packed));
+
+/**
+ * struct iwl_tfd
+ *
+ * Transmit Frame Descriptor (TFD)
+ *
+ * @ __reserved1[3] reserved
+ * @ num_tbs 0-5 number of active tbs
+ * 	     6-7 padding (not used)
+ * @ tbs[20]	transmit frame buffer descriptors
+ * @ __pad 	padding
+ *
+ * Each Tx queue uses a circular buffer of 256 TFDs stored in host DRAM.
+ * Both driver and device share these circular buffers, each of which must be
+ * contiguous 256 TFDs x 128 bytes-per-TFD = 32 KBytes
+ *
+ * Driver must indicate the physical address of the base of each
+ * circular buffer via the FH_MEM_CBBC_QUEUE registers.
+ *
+ * Each TFD contains pointer/size information for up to 20 data buffers
+ * in host DRAM.  These buffers collectively contain the (one) frame described
+ * by the TFD.  Each buffer must be a single contiguous block of memory within
+ * itself, but buffers may be scattered in host DRAM.  Each buffer has max size
+ * of (4K - 4).  The concatenates all of a TFD's buffers into a single
+ * Tx frame, up to 8 KBytes in size.
+ *
+ * A maximum of 255 (not 256!) TFDs may be on a queue waiting for Tx.
+ *
+ * Bit fields in the control dword (val0):
+ */
+struct iwl_tfd {
+	u8 __reserved1[3];
+	u8 num_tbs;
+	struct iwl_tfd_tb tbs[IWL_NUM_OF_TBS];
+	__le32 __pad;
+} __attribute__ ((packed));
+
+
+/* Keep Warm Size */
+#define IWL_KW_SIZE 0x1000	/*4k */
+
 #endif /* !__iwl_fh_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 785da5e..1ae93bc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -56,6 +56,26 @@ static const u16 default_tid_to_tx_fifo[] = {
 	IWL_TX_FIFO_AC3
 };
 
+static inline int iwl_alloc_dma_ptr(struct iwl_priv *priv,
+				    struct iwl_dma_ptr *ptr, size_t size)
+{
+	ptr->addr = pci_alloc_consistent(priv->pci_dev, size, &ptr->dma);
+	if (!ptr->addr)
+		return -ENOMEM;
+	ptr->size = size;
+	return 0;
+}
+
+static inline void iwl_free_dma_ptr(struct iwl_priv *priv,
+				    struct iwl_dma_ptr *ptr)
+{
+	if (unlikely(!ptr->addr))
+		return;
+
+	pci_free_consistent(priv->pci_dev, ptr->size, ptr->addr, ptr->dma);
+	memset(ptr, 0, sizeof(*ptr));
+}
+
 static inline dma_addr_t iwl_tfd_tb_get_addr(struct iwl_tfd *tfd, u8 idx)
 {
 	struct iwl_tfd_tb *tb = &tfd->tbs[idx];
@@ -517,8 +537,9 @@ void iwl_hw_txq_ctx_free(struct iwl_priv *priv)
 		else
 			iwl_tx_queue_free(priv, txq_id);
 
-	/* Keep-warm buffer */
-	iwl_kw_free(priv);
+	iwl_free_dma_ptr(priv, &priv->kw);
+
+	iwl_free_dma_ptr(priv, &priv->scd_bc_tbls);
 }
 EXPORT_SYMBOL(iwl_hw_txq_ctx_free);
 
@@ -535,13 +556,17 @@ int iwl_txq_ctx_reset(struct iwl_priv *priv)
 	int txq_id, slots_num;
 	unsigned long flags;
 
-	iwl_kw_free(priv);
-
 	/* Free all tx/cmd queues and keep-warm buffer */
 	iwl_hw_txq_ctx_free(priv);
 
+	ret = iwl_alloc_dma_ptr(priv, &priv->scd_bc_tbls,
+				priv->hw_params.scd_bc_tbls_size);
+	if (ret) {
+		IWL_ERROR("Scheduler BC Table allocation failed\n");
+		goto error_bc_tbls;
+	}
 	/* Alloc keep-warm buffer */
-	ret = iwl_kw_alloc(priv);
+	ret = iwl_alloc_dma_ptr(priv, &priv->kw, IWL_KW_SIZE);
 	if (ret) {
 		IWL_ERROR("Keep Warm allocation failed\n");
 		goto error_kw;
@@ -556,16 +581,13 @@ int iwl_txq_ctx_reset(struct iwl_priv *priv)
 	/* Turn off all Tx DMA fifos */
 	priv->cfg->ops->lib->txq_set_sched(priv, 0);
 
+	/* Tell NIC where to find the "keep warm" buffer */
+	iwl_write_direct32(priv, FH_KW_MEM_ADDR_REG, priv->kw.dma >> 4);
+
 	iwl_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 
-	/* Tell nic where to find the keep-warm buffer */
-	ret = iwl_kw_init(priv);
-	if (ret) {
-		IWL_ERROR("kw_init failed\n");
-		goto error_reset;
-	}
 
 	/* Alloc and init all Tx queues, including the command queue (#4) */
 	for (txq_id = 0; txq_id < priv->hw_params.max_txq_num; txq_id++) {
@@ -584,8 +606,10 @@ int iwl_txq_ctx_reset(struct iwl_priv *priv)
  error:
 	iwl_hw_txq_ctx_free(priv);
  error_reset:
-	iwl_kw_free(priv);
+	iwl_free_dma_ptr(priv, &priv->kw);
  error_kw:
+	iwl_free_dma_ptr(priv, &priv->scd_bc_tbls);
+ error_bc_tbls:
 	return ret;
 }
 
-- 
1.5.4.3

