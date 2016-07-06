Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33534 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932076AbcGFKpM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 06:45:12 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  6 Jul 2016 13:40:47 +0300
Message-Id: <1467801651-1816-52-git-send-email-luca@coelho.fi> (sfid-20160706_124525_820401_5933C92A)
In-Reply-To: <1467801452.25088.20.camel@coelho.fi>
References: <1467801452.25088.20.camel@coelho.fi>
Subject: [PATCH 52/56] iwlwifi: pcie: initialize a000 device's TFD table
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

For a000 device the FH was replaced by the TFH.
This is the first patch in a series introducing the
changes stemming from this change.
This patch initializes the TFQ queue table with the new
64 bit register and the relevant TFH configuration
registers.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-a000.c   |  3 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h |  3 +-
 drivers/net/wireless/intel/iwlwifi/iwl-fh.h     | 40 ++++++++++++++++++++++++-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c    | 27 +++++++++++++----
 4 files changed, 65 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-a000.c b/drivers/net/wireless/intel/iwlwifi/iwl-a000.c
index 220767e..4d78232 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-a000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-a000.c
@@ -115,7 +115,8 @@ static const struct iwl_ht_params iwl_a000_ht_params = {
 	.apmg_not_supported = true,					\
 	.mq_rx_supported = true,					\
 	.vht_mu_mimo_supported = true,					\
-	.mac_addr_from_csr = true
+	.mac_addr_from_csr = true,					\
+	.use_tfh = true
 
 const struct iwl_cfg iwla000_2ac_cfg = {
 		.name = "Intel(R) Dual Band Wireless AC a000",
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 64108cc..423b233 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -365,7 +365,8 @@ struct iwl_cfg {
 	    mq_rx_supported:1,
 	    vht_mu_mimo_supported:1,
 	    rf_id:1,
-	    integrated:1;
+	    integrated:1,
+	    use_tfh:1;
 	u8 valid_tx_ant;
 	u8 valid_rx_ant;
 	u8 non_shared_ant;
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fh.h b/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
index 73f0ed8..3b73467 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
@@ -77,6 +77,7 @@
  */
 #define FH_MEM_LOWER_BOUND                   (0x1000)
 #define FH_MEM_UPPER_BOUND                   (0x2000)
+#define TFH_MEM_LOWER_BOUND                  (0xA06000)
 
 /**
  * Keep-Warm (KW) buffer base address.
@@ -118,10 +119,17 @@
 #define FH_MEM_CBBC_16_19_UPPER_BOUND		(FH_MEM_LOWER_BOUND + 0xC00)
 #define FH_MEM_CBBC_20_31_LOWER_BOUND		(FH_MEM_LOWER_BOUND + 0xB20)
 #define FH_MEM_CBBC_20_31_UPPER_BOUND		(FH_MEM_LOWER_BOUND + 0xB80)
+/* a000 TFD table address, 64 bit */
+#define TFH_TFDQ_CBB_TABLE			(TFH_MEM_LOWER_BOUND + 0x1C00)
 
 /* Find TFD CB base pointer for given queue */
-static inline unsigned int FH_MEM_CBBC_QUEUE(unsigned int chnl)
+static inline unsigned int FH_MEM_CBBC_QUEUE(struct iwl_trans *trans,
+					     unsigned int chnl)
 {
+	if (trans->cfg->use_tfh) {
+		WARN_ON_ONCE(chnl >= 64);
+		return TFH_TFDQ_CBB_TABLE + 8 * chnl;
+	}
 	if (chnl < 16)
 		return FH_MEM_CBBC_0_15_LOWER_BOUND + 4 * chnl;
 	if (chnl < 20)
@@ -130,6 +138,36 @@ static inline unsigned int FH_MEM_CBBC_QUEUE(unsigned int chnl)
 	return FH_MEM_CBBC_20_31_LOWER_BOUND + 4 * (chnl - 20);
 }
 
+/* a000 configuration registers */
+
+/*
+ * TFH Configuration register.
+ *
+ * BIT fields:
+ *
+ * Bits 3:0:
+ * Define the maximum number of pending read requests.
+ * Maximum configration value allowed is 0xC
+ * Bits 9:8:
+ * Define the maximum transfer size. (64 / 128 / 256)
+ * Bit 10:
+ * When bit is set and transfer size is set to 128B, the TFH will enable
+ * reading chunks of more than 64B only if the read address is aligned to 128B.
+ * In case of DRAM read address which is not aligned to 128B, the TFH will
+ * enable transfer size which doesn't cross 64B DRAM address boundary.
+*/
+#define TFH_TRANSFER_MODE		(TFH_MEM_LOWER_BOUND + 0x1F40)
+#define TFH_TRANSFER_MAX_PENDING_REQ	0xc
+#define TFH_CHUNK_SIZE_128			BIT(8)
+#define TFH_CHUNK_SPLIT_MODE		BIT(10)
+/*
+ * Defines the offset address in dwords referring from the beginning of the
+ * Tx CMD which will be updated in DRAM.
+ * Note that the TFH offset address for Tx CMD update is always referring to
+ * the start of the TFD first TB.
+ * In case of a DRAM Tx CMD update the TFH will update PN and Key ID
+ */
+#define TFH_TXCMD_UPDATE_CFG		(TFH_MEM_LOWER_BOUND + 0x1F48)
 
 /**
  * Rx SRAM Control and Status Registers (RSCSR)
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index 9a1c006..d88d64c 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -70,6 +70,7 @@
  * Tx queue resumed.
  *
  ***************************************************/
+
 static int iwl_queue_space(const struct iwl_queue *q)
 {
 	unsigned int max;
@@ -575,8 +576,13 @@ static int iwl_pcie_txq_init(struct iwl_trans *trans, struct iwl_txq *txq,
 	 * Tell nic where to find circular buffer of Tx Frame Descriptors for
 	 * given Tx queue, and enable the DMA channel used for that queue.
 	 * Circular buffer (TFD queue in DRAM) physical base address */
-	iwl_write_direct32(trans, FH_MEM_CBBC_QUEUE(txq_id),
-			   txq->q.dma_addr >> 8);
+	if (trans->cfg->use_tfh)
+		iwl_write_direct64(trans,
+				   FH_MEM_CBBC_QUEUE(trans, txq_id),
+				   txq->q.dma_addr);
+	else
+		iwl_write_direct32(trans, FH_MEM_CBBC_QUEUE(trans, txq_id),
+				   txq->q.dma_addr >> 8);
 
 	return 0;
 }
@@ -783,9 +789,14 @@ void iwl_trans_pcie_tx_reset(struct iwl_trans *trans)
 	for (txq_id = 0; txq_id < trans->cfg->base_params->num_of_queues;
 	     txq_id++) {
 		struct iwl_txq *txq = &trans_pcie->txq[txq_id];
-
-		iwl_write_direct32(trans, FH_MEM_CBBC_QUEUE(txq_id),
-				   txq->q.dma_addr >> 8);
+		if (trans->cfg->use_tfh)
+			iwl_write_direct64(trans,
+					   FH_MEM_CBBC_QUEUE(trans, txq_id),
+					   txq->q.dma_addr);
+		else
+			iwl_write_direct32(trans,
+					   FH_MEM_CBBC_QUEUE(trans, txq_id),
+					   txq->q.dma_addr >> 8);
 		iwl_pcie_txq_unmap(trans, txq_id);
 		txq->q.read_ptr = 0;
 		txq->q.write_ptr = 0;
@@ -993,6 +1004,12 @@ int iwl_pcie_tx_init(struct iwl_trans *trans)
 		}
 	}
 
+	if (trans->cfg->use_tfh)
+		iwl_write_direct32(trans, TFH_TRANSFER_MODE,
+				   TFH_TRANSFER_MAX_PENDING_REQ |
+				   TFH_CHUNK_SIZE_128 |
+				   TFH_CHUNK_SPLIT_MODE);
+
 	iwl_set_bits_prph(trans, SCD_GP_CTRL, SCD_GP_CTRL_AUTO_ACTIVE_MODE);
 	if (trans->cfg->base_params->num_of_queues > 20)
 		iwl_set_bits_prph(trans, SCD_GP_CTRL,
-- 
2.8.1

