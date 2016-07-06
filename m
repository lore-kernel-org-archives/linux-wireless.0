Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33494 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753813AbcGFKo6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 06:44:58 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  6 Jul 2016 13:40:11 +0300
Message-Id: <1467801651-1816-16-git-send-email-luca@coelho.fi> (sfid-20160706_124502_868512_A01C9ADE)
In-Reply-To: <1467801452.25088.20.camel@coelho.fi>
References: <1467801452.25088.20.camel@coelho.fi>
Subject: [PATCH 16/56] iwlwifi: pcie: poll RFH for RX DMA stop
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Somehow we ended up stopping RX using legacy RX registers
even for devices that support RFH. Fix it.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-fh.h  | 26 ++++++++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c | 13 ++++++++++---
 2 files changed, 36 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fh.h b/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
index f08cdee..73f0ed8 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
@@ -344,6 +344,32 @@ static inline unsigned int FH_MEM_CBBC_QUEUE(unsigned int chnl)
 #define RFH_RBDBUF_RBD0_LSB 0xA08300
 #define RFH_RBDBUF_RBD_LSB(q) (RFH_RBDBUF_RBD0_LSB + (q) * 8)
 
+/**
+ * RFH Status Register
+ *
+ * Bit fields:
+ *
+ * Bit 29: RBD_FETCH_IDLE
+ * This status flag is set by the RFH when there is no active RBD fetch from
+ * DRAM.
+ * Once the RFH RBD controller starts fetching (or when there is a pending
+ * RBD read response from DRAM), this flag is immediately turned off.
+ *
+ * Bit 30: SRAM_DMA_IDLE
+ * This status flag is set by the RFH when there is no active transaction from
+ * SRAM to DRAM.
+ * Once the SRAM to DRAM DMA is active, this flag is immediately turned off.
+ *
+ * Bit 31: RXF_DMA_IDLE
+ * This status flag is set by the RFH when there is no active transaction from
+ * RXF to DRAM.
+ * Once the RXF-to-DRAM DMA is active, this flag is immediately turned off.
+ */
+#define RFH_GEN_STATUS 0xA09808
+#define RBD_FETCH_IDLE	BIT(29)
+#define SRAM_DMA_IDLE	BIT(30)
+#define RXF_DMA_IDLE	BIT(31)
+
 /* DMA configuration */
 #define RFH_RXF_DMA_CFG 0xA09820
 /* RB size */
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 8d4a60d..c1c3c6a 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -173,9 +173,16 @@ static void iwl_pcie_write_prph_64_no_grab(struct iwl_trans *trans, u64 ofs,
  */
 int iwl_pcie_rx_stop(struct iwl_trans *trans)
 {
-	iwl_write_direct32(trans, FH_MEM_RCSR_CHNL0_CONFIG_REG, 0);
-	return iwl_poll_direct_bit(trans, FH_MEM_RSSR_RX_STATUS_REG,
-				   FH_RSSR_CHNL0_RX_STATUS_CHNL_IDLE, 1000);
+	if (trans->cfg->mq_rx_supported) {
+		iwl_write_prph(trans, RFH_RXF_DMA_CFG, 0);
+		return iwl_poll_prph_bit(trans, RFH_GEN_STATUS,
+					   RXF_DMA_IDLE, RXF_DMA_IDLE, 1000);
+	} else {
+		iwl_write_direct32(trans, FH_MEM_RCSR_CHNL0_CONFIG_REG, 0);
+		return iwl_poll_direct_bit(trans, FH_MEM_RSSR_RX_STATUS_REG,
+					   FH_RSSR_CHNL0_RX_STATUS_CHNL_IDLE,
+					   1000);
+	}
 }
 
 /*
-- 
2.8.1

