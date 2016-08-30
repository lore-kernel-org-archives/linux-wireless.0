Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:41248 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1758217AbcH3LkU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Aug 2016 07:40:20 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 30 Aug 2016 14:39:01 +0300
Message-Id: <1472557142-14782-15-git-send-email-luca@coelho.fi> (sfid-20160830_134023_548498_EF3C416C)
In-Reply-To: <1472557142-14782-1-git-send-email-luca@coelho.fi>
References: <1472556999.27868.86.camel@coelho.fi>
 <1472557142-14782-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 15/16] iwlwifi: pcie: fix ucode load flow for a000 devices
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Turns out we should access TFH relative addresses.
Also, the FH_UCODE_LOAD_STATUS was replaced by
UREG_UCODE_LOAD_STATUS.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-fh.h     | 15 ++++++-----
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h   |  8 ++++++
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 33 +++++++++++++++++++------
 3 files changed, 40 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fh.h b/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
index 1d6f5d2..dd75ea7 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
@@ -77,7 +77,6 @@
  */
 #define FH_MEM_LOWER_BOUND                   (0x1000)
 #define FH_MEM_UPPER_BOUND                   (0x2000)
-#define TFH_MEM_LOWER_BOUND                  (0xA06000)
 
 /**
  * Keep-Warm (KW) buffer base address.
@@ -120,7 +119,7 @@
 #define FH_MEM_CBBC_20_31_LOWER_BOUND		(FH_MEM_LOWER_BOUND + 0xB20)
 #define FH_MEM_CBBC_20_31_UPPER_BOUND		(FH_MEM_LOWER_BOUND + 0xB80)
 /* a000 TFD table address, 64 bit */
-#define TFH_TFDQ_CBB_TABLE			(TFH_MEM_LOWER_BOUND + 0x1C00)
+#define TFH_TFDQ_CBB_TABLE			(0x1C00)
 
 /* Find TFD CB base pointer for given queue */
 static inline unsigned int FH_MEM_CBBC_QUEUE(struct iwl_trans *trans,
@@ -156,7 +155,7 @@ static inline unsigned int FH_MEM_CBBC_QUEUE(struct iwl_trans *trans,
  * In case of DRAM read address which is not aligned to 128B, the TFH will
  * enable transfer size which doesn't cross 64B DRAM address boundary.
 */
-#define TFH_TRANSFER_MODE		(TFH_MEM_LOWER_BOUND + 0x1F40)
+#define TFH_TRANSFER_MODE		(0x1F40)
 #define TFH_TRANSFER_MAX_PENDING_REQ	0xc
 #define TFH_CHUNK_SIZE_128			BIT(8)
 #define TFH_CHUNK_SPLIT_MODE		BIT(10)
@@ -167,7 +166,7 @@ static inline unsigned int FH_MEM_CBBC_QUEUE(struct iwl_trans *trans,
  * the start of the TFD first TB.
  * In case of a DRAM Tx CMD update the TFH will update PN and Key ID
  */
-#define TFH_TXCMD_UPDATE_CFG		(TFH_MEM_LOWER_BOUND + 0x1F48)
+#define TFH_TXCMD_UPDATE_CFG		(0x1F48)
 /*
  * Controls TX DMA operation
  *
@@ -181,22 +180,22 @@ static inline unsigned int FH_MEM_CBBC_QUEUE(struct iwl_trans *trans,
  * set to 1 - interrupt is sent to the driver
  * Bit 0: Indicates the snoop configuration
 */
-#define TFH_SRV_DMA_CHNL0_CTRL	(TFH_MEM_LOWER_BOUND + 0x1F60)
+#define TFH_SRV_DMA_CHNL0_CTRL	(0x1F60)
 #define TFH_SRV_DMA_SNOOP	BIT(0)
 #define TFH_SRV_DMA_TO_DRIVER	BIT(24)
 #define TFH_SRV_DMA_START	BIT(31)
 
 /* Defines the DMA SRAM write start address to transfer a data block */
-#define TFH_SRV_DMA_CHNL0_SRAM_ADDR	(TFH_MEM_LOWER_BOUND + 0x1F64)
+#define TFH_SRV_DMA_CHNL0_SRAM_ADDR	(0x1F64)
 
 /* Defines the 64bits DRAM start address to read the DMA data block from */
-#define TFH_SRV_DMA_CHNL0_DRAM_ADDR	(TFH_MEM_LOWER_BOUND + 0x1F68)
+#define TFH_SRV_DMA_CHNL0_DRAM_ADDR	(0x1F68)
 
 /*
  * Defines the number of bytes to transfer from DRAM to SRAM.
  * Note that this register may be configured with non-dword aligned size.
  */
-#define TFH_SRV_DMA_CHNL0_BC	(TFH_MEM_LOWER_BOUND + 0x1F70)
+#define TFH_SRV_DMA_CHNL0_BC	(0x1F70)
 
 /**
  * Rx SRAM Control and Status Registers (RSCSR)
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
index 459bf73..849ee79 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
@@ -303,6 +303,14 @@
 
 #define FH_UCODE_LOAD_STATUS		(0x1AF0)
 #define CSR_UCODE_LOAD_STATUS_ADDR	(0x1E70)
+
+/*
+ * Replacing FH_UCODE_LOAD_STATUS
+ * This register is writen by driver and is read by uCode during boot flow.
+ * Note this address is cleared after MAC reset.
+ */
+#define UREG_UCODE_LOAD_STATUS		(0xa05c40)
+
 enum secure_load_status_reg {
 	LMPM_CPU_UCODE_LOADING_STARTED			= 0x00000001,
 	LMPM_CPU_HDRS_LOADING_COMPLETED			= 0x00000003,
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 559f118..039eeca 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -827,10 +827,16 @@ static int iwl_pcie_load_cpu_sections_8000(struct iwl_trans *trans,
 		if (ret)
 			return ret;
 
-		/* Notify the ucode of the loaded section number and status */
-		val = iwl_read_direct32(trans, FH_UCODE_LOAD_STATUS);
-		val = val | (sec_num << shift_param);
-		iwl_write_direct32(trans, FH_UCODE_LOAD_STATUS, val);
+		/* Notify ucode of loaded section number and status */
+		if (trans->cfg->use_tfh) {
+			val = iwl_read_prph(trans, UREG_UCODE_LOAD_STATUS);
+			val = val | (sec_num << shift_param);
+			iwl_write_prph(trans, UREG_UCODE_LOAD_STATUS, val);
+		} else {
+			val = iwl_read_direct32(trans, FH_UCODE_LOAD_STATUS);
+			val = val | (sec_num << shift_param);
+			iwl_write_direct32(trans, FH_UCODE_LOAD_STATUS, val);
+		}
 		sec_num = (sec_num << 1) | 0x1;
 	}
 
@@ -838,10 +844,21 @@ static int iwl_pcie_load_cpu_sections_8000(struct iwl_trans *trans,
 
 	iwl_enable_interrupts(trans);
 
-	if (cpu == 1)
-		iwl_write_direct32(trans, FH_UCODE_LOAD_STATUS, 0xFFFF);
-	else
-		iwl_write_direct32(trans, FH_UCODE_LOAD_STATUS, 0xFFFFFFFF);
+	if (trans->cfg->use_tfh) {
+		if (cpu == 1)
+			iwl_write_prph(trans, UREG_UCODE_LOAD_STATUS,
+				       0xFFFF);
+		else
+			iwl_write_prph(trans, UREG_UCODE_LOAD_STATUS,
+				       0xFFFFFFFF);
+	} else {
+		if (cpu == 1)
+			iwl_write_direct32(trans, FH_UCODE_LOAD_STATUS,
+					   0xFFFF);
+		else
+			iwl_write_direct32(trans, FH_UCODE_LOAD_STATUS,
+					   0xFFFFFFFF);
+	}
 
 	return 0;
 }
-- 
2.8.1
