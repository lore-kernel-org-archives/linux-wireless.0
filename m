Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:26494 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751670AbYKLVNu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2008 16:13:50 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 8/8] iwlwifi: iwl-fh.h cleanup
Date: Wed, 12 Nov 2008 13:14:11 -0800
Message-Id: <1226524451-3417-9-git-send-email-reinette.chatre@intel.com> (sfid-20081112_221400_306313_990AE160)
In-Reply-To: <1226524451-3417-8-git-send-email-reinette.chatre@intel.com>
References: <>
 <1226524451-3417-1-git-send-email-reinette.chatre@intel.com>
 <1226524451-3417-2-git-send-email-reinette.chatre@intel.com>
 <1226524451-3417-3-git-send-email-reinette.chatre@intel.com>
 <1226524451-3417-4-git-send-email-reinette.chatre@intel.com>
 <1226524451-3417-5-git-send-email-reinette.chatre@intel.com>
 <1226524451-3417-6-git-send-email-reinette.chatre@intel.com>
 <1226524451-3417-7-git-send-email-reinette.chatre@intel.com>
 <1226524451-3417-8-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch fix value of upper FH register bound plus
it reorders and groups registers in more readable way

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Acked-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fh.h |   41 +++++++++++++-------------------
 1 files changed, 17 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fh.h b/drivers/net/wireless/iwlwifi/iwl-fh.h
index 694ebb0..bc20acb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fh.h
@@ -72,7 +72,7 @@
  * Addresses are offsets from device's PCI hardware base address.
  */
 #define FH_MEM_LOWER_BOUND                   (0x1000)
-#define FH_MEM_UPPER_BOUND                   (0x1EF0)
+#define FH_MEM_UPPER_BOUND                   (0x2000)
 
 /**
  * Keep-Warm (KW) buffer base address.
@@ -268,6 +268,8 @@
 
 #define FH_RCSR_CHNL0_RX_CONFIG_SINGLE_FRAME	(0x00008000)
 
+#define FH_RSCSR_FRAME_SIZE_MSK	(0x00003FFF)	/* bits 0-13 */
+
 
 /**
  * Rx Shared Status Registers (RSSR)
@@ -294,6 +296,13 @@
 
 #define FH_MEM_TFDIB_REG1_ADDR_BITSHIFT	28
 
+/* TFDB  Area - TFDs buffer table */
+#define FH_MEM_TFDIB_DRAM_ADDR_LSB_MSK      (0xFFFFFFFF)
+#define FH_TFDIB_LOWER_BOUND       (FH_MEM_LOWER_BOUND + 0x900)
+#define FH_TFDIB_UPPER_BOUND       (FH_MEM_LOWER_BOUND + 0x958)
+#define FH_TFDIB_CTRL0_REG(_chnl)  (FH_TFDIB_LOWER_BOUND + 0x8 * (_chnl))
+#define FH_TFDIB_CTRL1_REG(_chnl)  (FH_TFDIB_LOWER_BOUND + 0x8 * (_chnl) + 0x4)
+
 /**
  * Transmit DMA Channel Control/Status Registers (TCSR)
  *
@@ -323,6 +332,7 @@
 #define FH49_TCSR_CHNL_NUM                            (7)
 #define FH50_TCSR_CHNL_NUM                            (8)
 
+/* TCSR: tx_config register values */
 #define FH_TCSR_CHNL_TX_CONFIG_REG(_chnl)	\
 		(FH_TCSR_LOWER_BOUND + 0x20 * (_chnl))
 #define FH_TCSR_CHNL_TX_CREDIT_REG(_chnl)	\
@@ -379,31 +389,13 @@
 	(FH_TSSR_TX_STATUS_REG_BIT_BUFS_EMPTY(_chnl) | \
 	FH_TSSR_TX_STATUS_REG_BIT_NO_PEND_REQ(_chnl))
 
-
-
-#define FH_REGS_LOWER_BOUND		     (0x1000)
-#define FH_REGS_UPPER_BOUND		     (0x2000)
-
 /* Tx service channels */
-#define FH_SRVC_CHNL                                (9)
-#define FH_SRVC_LOWER_BOUND          (FH_REGS_LOWER_BOUND + 0x9C8)
-#define FH_SRVC_UPPER_BOUND          (FH_REGS_LOWER_BOUND + 0x9D0)
+#define FH_SRVC_CHNL		(9)
+#define FH_SRVC_LOWER_BOUND	(FH_MEM_LOWER_BOUND + 0x9C8)
+#define FH_SRVC_UPPER_BOUND	(FH_MEM_LOWER_BOUND + 0x9D0)
 #define FH_SRVC_CHNL_SRAM_ADDR_REG(_chnl) \
 		(FH_SRVC_LOWER_BOUND + ((_chnl) - 9) * 0x4)
 
-/* TFDB  Area - TFDs buffer table */
-#define FH_MEM_TFDIB_DRAM_ADDR_LSB_MSK      (0xFFFFFFFF)
-#define FH_TFDIB_LOWER_BOUND       (FH_REGS_LOWER_BOUND + 0x900)
-#define FH_TFDIB_UPPER_BOUND       (FH_REGS_LOWER_BOUND + 0x958)
-#define FH_TFDIB_CTRL0_REG(_chnl)  (FH_TFDIB_LOWER_BOUND + 0x8 * (_chnl))
-#define FH_TFDIB_CTRL1_REG(_chnl)  (FH_TFDIB_LOWER_BOUND + 0x8 * (_chnl) + 0x4)
-
-/* TCSR: tx_config register values */
-#define FH_RSCSR_FRAME_SIZE_MSK	(0x00003FFF)	/* bits 0-13 */
-
-#define TFD_QUEUE_SIZE_MAX      (256)
-#define TFD_QUEUE_SIZE_BC_DUP	(64)
-#define TFD_QUEUE_BC_SIZE	(TFD_QUEUE_SIZE_MAX + TFD_QUEUE_SIZE_BC_DUP)
 
 /**
  * struct iwl_rb_status - reseve buffer status
@@ -423,9 +415,10 @@ struct iwl_rb_status {
 } __attribute__ ((packed));
 
 
-
+#define TFD_QUEUE_SIZE_MAX      (256)
+#define TFD_QUEUE_SIZE_BC_DUP	(64)
+#define TFD_QUEUE_BC_SIZE	(TFD_QUEUE_SIZE_MAX + TFD_QUEUE_SIZE_BC_DUP)
 #define IWL_TX_DMA_MASK        DMA_BIT_MASK(36)
-
 #define IWL_NUM_OF_TBS		20
 
 static inline u8 iwl_get_dma_hi_addr(dma_addr_t addr)
-- 
1.5.4.3

