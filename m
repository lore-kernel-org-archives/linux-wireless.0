Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:52218 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752832AbeF3NYU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 30 Jun 2018 09:24:20 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Golan Ben Ami <golan.ben.ami@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat, 30 Jun 2018 16:23:29 +0300
Message-Id: <20180630132330.14928-15-luca@coelho.fi> (sfid-20180630_152423_123314_50ACB042)
In-Reply-To: <20180630132330.14928-1-luca@coelho.fi>
References: <20180630132330.14928-1-luca@coelho.fi>
Subject: [PATCH 14/15] iwlwifi: update registers changed for 22560 devices
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Golan Ben Ami <golan.ben.ami@intel.com>

In 22560 devices the firmware will do all the hw configurations,
but that's not ready yet.
Update the correct registers in the driver until the FW is ready
and does it by itself.

Signed-off-by: Golan Ben Ami <golan.ben.ami@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-fh.h  | 6 ++++--
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c | 7 ++++++-
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fh.h b/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
index f286fc7db7fd..df0e9ffff706 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
@@ -434,13 +434,15 @@ static inline unsigned int FH_MEM_CBBC_QUEUE(struct iwl_trans *trans,
  * RXF to DRAM.
  * Once the RXF-to-DRAM DMA is active, this flag is immediately turned off.
  */
-#define RFH_GEN_STATUS 0xA09808
+#define RFH_GEN_STATUS		0xA09808
+#define RFH_GEN_STATUS_GEN3	0xA07824
 #define RBD_FETCH_IDLE	BIT(29)
 #define SRAM_DMA_IDLE	BIT(30)
 #define RXF_DMA_IDLE	BIT(31)
 
 /* DMA configuration */
-#define RFH_RXF_DMA_CFG 0xA09820
+#define RFH_RXF_DMA_CFG		0xA09820
+#define RFH_RXF_DMA_CFG_GEN3	0xA07880
 /* RB size */
 #define RFH_RXF_DMA_RB_SIZE_MASK (0x000F0000) /* bits 16-19 */
 #define RFH_RXF_DMA_RB_SIZE_POS 16
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 707242f1ff0b..8cd0c3dac0ab 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -167,7 +167,12 @@ static inline __le32 iwl_pcie_dma_addr2rbd_ptr(dma_addr_t dma_addr)
  */
 int iwl_pcie_rx_stop(struct iwl_trans *trans)
 {
-	if (trans->cfg->mq_rx_supported) {
+	if (trans->cfg->device_family >= IWL_DEVICE_FAMILY_22560) {
+		/* TODO: remove this for 22560 once fw does it */
+		iwl_write_prph(trans, RFH_RXF_DMA_CFG_GEN3, 0);
+		return iwl_poll_prph_bit(trans, RFH_GEN_STATUS_GEN3,
+					 RXF_DMA_IDLE, RXF_DMA_IDLE, 1000);
+	} else if (trans->cfg->mq_rx_supported) {
 		iwl_write_prph(trans, RFH_RXF_DMA_CFG, 0);
 		return iwl_poll_prph_bit(trans, RFH_GEN_STATUS,
 					   RXF_DMA_IDLE, RXF_DMA_IDLE, 1000);
-- 
2.18.0
