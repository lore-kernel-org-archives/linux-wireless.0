Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:34250 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753070AbcCBH5B (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2016 02:57:01 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 09/43] iwlwifi: pcie: aggregate Flow Handler configuration writes
Date: Wed,  2 Mar 2016 09:56:10 +0200
Message-Id: <1456905404-14435-9-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160302_085707_560966_67FE10A2)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of waking up the device each time we write a
register, wake it up once, and writes the registers
at once.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 56 ++++++++++++-------------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 58591ca..cda678d 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -616,38 +616,38 @@ static int iwl_pcie_load_firmware_chunk(struct iwl_trans *trans, u32 dst_addr,
 				   dma_addr_t phy_addr, u32 byte_cnt)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	unsigned long flags;
 	int ret;
 
 	trans_pcie->ucode_write_complete = false;
 
-	iwl_write_direct32(trans,
-			   FH_TCSR_CHNL_TX_CONFIG_REG(FH_SRVC_CHNL),
-			   FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_PAUSE);
-
-	iwl_write_direct32(trans,
-			   FH_SRVC_CHNL_SRAM_ADDR_REG(FH_SRVC_CHNL),
-			   dst_addr);
-
-	iwl_write_direct32(trans,
-			   FH_TFDIB_CTRL0_REG(FH_SRVC_CHNL),
-			   phy_addr & FH_MEM_TFDIB_DRAM_ADDR_LSB_MSK);
-
-	iwl_write_direct32(trans,
-			   FH_TFDIB_CTRL1_REG(FH_SRVC_CHNL),
-			   (iwl_get_dma_hi_addr(phy_addr)
-				<< FH_MEM_TFDIB_REG1_ADDR_BITSHIFT) | byte_cnt);
-
-	iwl_write_direct32(trans,
-			   FH_TCSR_CHNL_TX_BUF_STS_REG(FH_SRVC_CHNL),
-			   1 << FH_TCSR_CHNL_TX_BUF_STS_REG_POS_TB_NUM |
-			   1 << FH_TCSR_CHNL_TX_BUF_STS_REG_POS_TB_IDX |
-			   FH_TCSR_CHNL_TX_BUF_STS_REG_VAL_TFDB_VALID);
-
-	iwl_write_direct32(trans,
-			   FH_TCSR_CHNL_TX_CONFIG_REG(FH_SRVC_CHNL),
-			   FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE	|
-			   FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_DISABLE	|
-			   FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_HOST_ENDTFD);
+	if (!iwl_trans_grab_nic_access(trans, &flags))
+		return -EIO;
+
+	iwl_write32(trans, FH_TCSR_CHNL_TX_CONFIG_REG(FH_SRVC_CHNL),
+		    FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_PAUSE);
+
+	iwl_write32(trans, FH_SRVC_CHNL_SRAM_ADDR_REG(FH_SRVC_CHNL),
+		    dst_addr);
+
+	iwl_write32(trans, FH_TFDIB_CTRL0_REG(FH_SRVC_CHNL),
+		    phy_addr & FH_MEM_TFDIB_DRAM_ADDR_LSB_MSK);
+
+	iwl_write32(trans, FH_TFDIB_CTRL1_REG(FH_SRVC_CHNL),
+		    (iwl_get_dma_hi_addr(phy_addr)
+			<< FH_MEM_TFDIB_REG1_ADDR_BITSHIFT) | byte_cnt);
+
+	iwl_write32(trans, FH_TCSR_CHNL_TX_BUF_STS_REG(FH_SRVC_CHNL),
+		    BIT(FH_TCSR_CHNL_TX_BUF_STS_REG_POS_TB_NUM) |
+		    BIT(FH_TCSR_CHNL_TX_BUF_STS_REG_POS_TB_IDX) |
+		    FH_TCSR_CHNL_TX_BUF_STS_REG_VAL_TFDB_VALID);
+
+	iwl_write32(trans, FH_TCSR_CHNL_TX_CONFIG_REG(FH_SRVC_CHNL),
+		    FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE |
+		    FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_DISABLE |
+		    FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_HOST_ENDTFD);
+
+	iwl_trans_release_nic_access(trans, &flags);
 
 	ret = wait_event_timeout(trans_pcie->ucode_write_waitq,
 				 trans_pcie->ucode_write_complete, 5 * HZ);
-- 
2.5.0

