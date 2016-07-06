Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33428 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753579AbcGFKoe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 06:44:34 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  6 Jul 2016 13:40:48 +0300
Message-Id: <1467801651-1816-53-git-send-email-luca@coelho.fi> (sfid-20160706_125026_600478_832937A0)
In-Reply-To: <1467801452.25088.20.camel@coelho.fi>
References: <1467801452.25088.20.camel@coelho.fi>
Subject: [PATCH 53/56] iwlwifi: pcie: load FW chunk for a000 devices
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Update the firmware load flow for TFH hardware.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-fh.h     | 29 +++++++++++++
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 57 ++++++++++++++++++++-----
 2 files changed, 75 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fh.h b/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
index 3b73467..1d6f5d2 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
@@ -168,6 +168,35 @@ static inline unsigned int FH_MEM_CBBC_QUEUE(struct iwl_trans *trans,
  * In case of a DRAM Tx CMD update the TFH will update PN and Key ID
  */
 #define TFH_TXCMD_UPDATE_CFG		(TFH_MEM_LOWER_BOUND + 0x1F48)
+/*
+ * Controls TX DMA operation
+ *
+ * BIT fields:
+ *
+ * Bits 31:30: Enable the SRAM DMA channel.
+ * Turning on bit 31 will kick the SRAM2DRAM DMA.
+ * Note that the sram2dram may be enabled only after configuring the DRAM and
+ * SRAM addresses registers and the byte count register.
+ * Bits 25:24: Defines the interrupt target upon dram2sram transfer done. When
+ * set to 1 - interrupt is sent to the driver
+ * Bit 0: Indicates the snoop configuration
+*/
+#define TFH_SRV_DMA_CHNL0_CTRL	(TFH_MEM_LOWER_BOUND + 0x1F60)
+#define TFH_SRV_DMA_SNOOP	BIT(0)
+#define TFH_SRV_DMA_TO_DRIVER	BIT(24)
+#define TFH_SRV_DMA_START	BIT(31)
+
+/* Defines the DMA SRAM write start address to transfer a data block */
+#define TFH_SRV_DMA_CHNL0_SRAM_ADDR	(TFH_MEM_LOWER_BOUND + 0x1F64)
+
+/* Defines the 64bits DRAM start address to read the DMA data block from */
+#define TFH_SRV_DMA_CHNL0_DRAM_ADDR	(TFH_MEM_LOWER_BOUND + 0x1F68)
+
+/*
+ * Defines the number of bytes to transfer from DRAM to SRAM.
+ * Note that this register may be configured with non-dword aligned size.
+ */
+#define TFH_SRV_DMA_CHNL0_BC	(TFH_MEM_LOWER_BOUND + 0x1F70)
 
 /**
  * Rx SRAM Control and Status Registers (RSCSR)
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 9e953a4..af04dad 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -608,18 +608,10 @@ static int iwl_pcie_prepare_card_hw(struct iwl_trans *trans)
 /*
  * ucode
  */
-static int iwl_pcie_load_firmware_chunk(struct iwl_trans *trans, u32 dst_addr,
-				   dma_addr_t phy_addr, u32 byte_cnt)
+static void iwl_pcie_load_firmware_chunk_fh(struct iwl_trans *trans,
+					    u32 dst_addr, dma_addr_t phy_addr,
+					    u32 byte_cnt)
 {
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	unsigned long flags;
-	int ret;
-
-	trans_pcie->ucode_write_complete = false;
-
-	if (!iwl_trans_grab_nic_access(trans, &flags))
-		return -EIO;
-
 	iwl_write32(trans, FH_TCSR_CHNL_TX_CONFIG_REG(FH_SRVC_CHNL),
 		    FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_PAUSE);
 
@@ -642,7 +634,50 @@ static int iwl_pcie_load_firmware_chunk(struct iwl_trans *trans, u32 dst_addr,
 		    FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE |
 		    FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_DISABLE |
 		    FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_HOST_ENDTFD);
+}
+
+static void iwl_pcie_load_firmware_chunk_tfh(struct iwl_trans *trans,
+					     u32 dst_addr, dma_addr_t phy_addr,
+					     u32 byte_cnt)
+{
+	/* Stop DMA channel */
+	iwl_write32(trans, TFH_SRV_DMA_CHNL0_CTRL, 0);
+
+	/* Configure SRAM address */
+	iwl_write32(trans, TFH_SRV_DMA_CHNL0_SRAM_ADDR,
+		    dst_addr);
+
+	/* Configure DRAM address - 64 bit */
+	iwl_write64(trans, TFH_SRV_DMA_CHNL0_DRAM_ADDR, phy_addr);
 
+	/* Configure byte count to transfer */
+	iwl_write32(trans, TFH_SRV_DMA_CHNL0_BC, byte_cnt);
+
+	/* Enable the DRAM2SRAM to start */
+	iwl_write32(trans, TFH_SRV_DMA_CHNL0_CTRL, TFH_SRV_DMA_SNOOP |
+						   TFH_SRV_DMA_TO_DRIVER |
+						   TFH_SRV_DMA_START);
+}
+
+static int iwl_pcie_load_firmware_chunk(struct iwl_trans *trans,
+					u32 dst_addr, dma_addr_t phy_addr,
+					u32 byte_cnt)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	unsigned long flags;
+	int ret;
+
+	trans_pcie->ucode_write_complete = false;
+
+	if (!iwl_trans_grab_nic_access(trans, &flags))
+		return -EIO;
+
+	if (trans->cfg->use_tfh)
+		iwl_pcie_load_firmware_chunk_tfh(trans, dst_addr, phy_addr,
+						 byte_cnt);
+	else
+		iwl_pcie_load_firmware_chunk_fh(trans, dst_addr, phy_addr,
+						byte_cnt);
 	iwl_trans_release_nic_access(trans, &flags);
 
 	ret = wait_event_timeout(trans_pcie->ucode_write_waitq,
-- 
2.8.1

