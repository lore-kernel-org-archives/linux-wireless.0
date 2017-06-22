Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:34418 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753701AbdFVVWa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Jun 2017 17:22:30 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 23 Jun 2017 00:20:46 +0300
Message-Id: <20170622212101.16422-11-luca@coelho.fi> (sfid-20170622_232235_359748_56764A8B)
In-Reply-To: <20170622212101.16422-1-luca@coelho.fi>
References: <20170622212101.16422-1-luca@coelho.fi>
Subject: [PATCH 10/25] iwlwifi: use bitfield.h for some registers
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Letting the preprocessor/compiler generate the shift/mask by itself
is a win for readability, so use bitfield.h for some registers.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-fh.h   | 10 +++++-----
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h | 17 +++++++++--------
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c  | 14 +++++++-------
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c  |  6 ++----
 4 files changed, 23 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fh.h b/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
index 2a992277c671..77be149276b6 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
@@ -66,6 +66,7 @@
 #define __iwl_fh_h__
 
 #include <linux/types.h>
+#include <linux/bitfield.h>
 
 /****************************/
 /* Flow Handler Definitions */
@@ -478,13 +479,12 @@ static inline unsigned int FH_MEM_CBBC_QUEUE(struct iwl_trans *trans,
 #define RFH_GEN_CFG	0xA09800
 #define RFH_GEN_CFG_SERVICE_DMA_SNOOP	BIT(0)
 #define RFH_GEN_CFG_RFH_DMA_SNOOP	BIT(1)
-#define RFH_GEN_CFG_RB_CHUNK_SIZE_POS	4
+#define RFH_GEN_CFG_RB_CHUNK_SIZE	BIT(4)
 #define RFH_GEN_CFG_RB_CHUNK_SIZE_128	1
 #define RFH_GEN_CFG_RB_CHUNK_SIZE_64	0
-#define RFH_GEN_CFG_DEFAULT_RXQ_NUM_MASK 0xF00
-#define RFH_GEN_CFG_DEFAULT_RXQ_NUM_POS 8
-
-#define DEFAULT_RXQ_NUM			0
+/* the driver assumes everywhere that the default RXQ is 0 */
+#define RFH_GEN_CFG_DEFAULT_RXQ_NUM	0xF00
+#define RFH_GEN_CFG_VAL(_n, _v)		FIELD_PREP(RFH_GEN_CFG_ ## _n, _v)
 
 /* end of 9000 rx series registers */
 
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
index 77efbb78e867..6772c59b7764 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
@@ -66,6 +66,7 @@
 
 #ifndef	__iwl_prph_h__
 #define __iwl_prph_h__
+#include <linux/bitfield.h>
 
 /*
  * Registers in this file are internal, not PCI bus memory mapped.
@@ -247,14 +248,14 @@
 #define SCD_QUEUE_STTS_REG_POS_SCD_ACT_EN (19)
 #define SCD_QUEUE_STTS_REG_MSK		(0x017F0000)
 
-#define SCD_QUEUE_CTX_REG1_CREDIT_POS		(8)
-#define SCD_QUEUE_CTX_REG1_CREDIT_MSK		(0x00FFFF00)
-#define SCD_QUEUE_CTX_REG1_SUPER_CREDIT_POS	(24)
-#define SCD_QUEUE_CTX_REG1_SUPER_CREDIT_MSK	(0xFF000000)
-#define SCD_QUEUE_CTX_REG2_WIN_SIZE_POS		(0)
-#define SCD_QUEUE_CTX_REG2_WIN_SIZE_MSK		(0x0000007F)
-#define SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS	(16)
-#define SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK	(0x007F0000)
+#define SCD_QUEUE_CTX_REG1_CREDIT		(0x00FFFF00)
+#define SCD_QUEUE_CTX_REG1_SUPER_CREDIT		(0xFF000000)
+#define SCD_QUEUE_CTX_REG1_VAL(_n, _v)		FIELD_PREP(SCD_QUEUE_CTX_REG1_ ## _n, _v)
+
+#define SCD_QUEUE_CTX_REG2_WIN_SIZE		(0x0000007F)
+#define SCD_QUEUE_CTX_REG2_FRAME_LIMIT		(0x007F0000)
+#define SCD_QUEUE_CTX_REG2_VAL(_n, _v)		FIELD_PREP(SCD_QUEUE_CTX_REG2_ ## _n, _v)
+
 #define SCD_GP_CTRL_ENABLE_31_QUEUES		BIT(0)
 #define SCD_GP_CTRL_AUTO_ACTIVE_MODE		BIT(18)
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 1da2de205cdf..293f4b2c1955 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -845,14 +845,14 @@ static void iwl_pcie_rx_mq_hw_init(struct iwl_trans *trans)
 	 * Set RX DMA chunk size to 64B for IOSF and 128B for PCIe
 	 * Default queue is 0
 	 */
-	iwl_write_prph_no_grab(trans, RFH_GEN_CFG, RFH_GEN_CFG_RFH_DMA_SNOOP |
-			       (DEFAULT_RXQ_NUM <<
-				RFH_GEN_CFG_DEFAULT_RXQ_NUM_POS) |
+	iwl_write_prph_no_grab(trans, RFH_GEN_CFG,
+			       RFH_GEN_CFG_RFH_DMA_SNOOP |
+			       RFH_GEN_CFG_VAL(DEFAULT_RXQ_NUM, 0) |
 			       RFH_GEN_CFG_SERVICE_DMA_SNOOP |
-			       (trans->cfg->integrated ?
-				RFH_GEN_CFG_RB_CHUNK_SIZE_64 :
-				RFH_GEN_CFG_RB_CHUNK_SIZE_128) <<
-			       RFH_GEN_CFG_RB_CHUNK_SIZE_POS);
+			       RFH_GEN_CFG_VAL(RB_CHUNK_SIZE,
+					       trans->cfg->integrated ?
+					       RFH_GEN_CFG_RB_CHUNK_SIZE_64 :
+					       RFH_GEN_CFG_RB_CHUNK_SIZE_128));
 	/* Enable the relevant rx queues */
 	iwl_write_prph_no_grab(trans, RFH_RXF_RXQ_ACTIVE, enabled);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index 61b171ee32ba..94ab01164f66 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -1344,10 +1344,8 @@ void iwl_trans_pcie_txq_enable(struct iwl_trans *trans, int txq_id, u16 ssn,
 		iwl_trans_write_mem32(trans,
 			trans_pcie->scd_base_addr +
 			SCD_CONTEXT_QUEUE_OFFSET(txq_id) + sizeof(u32),
-			((frame_limit << SCD_QUEUE_CTX_REG2_WIN_SIZE_POS) &
-					SCD_QUEUE_CTX_REG2_WIN_SIZE_MSK) |
-			((frame_limit << SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS) &
-					SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK));
+			SCD_QUEUE_CTX_REG2_VAL(WIN_SIZE, frame_limit) |
+			SCD_QUEUE_CTX_REG2_VAL(FRAME_LIMIT, frame_limit));
 
 		/* Set up status area in SRAM, map to Tx DMA/FIFO, activate */
 		iwl_write_prph(trans, SCD_QUEUE_STATUS_BITS(txq_id),
-- 
2.11.0
