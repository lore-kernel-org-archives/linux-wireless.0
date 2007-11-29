Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:56161 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756478AbXK2DLF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 22:11:05 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ben Cahill <ben.m.cahill@intel.com>, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 25/36] iwlwifi: document Tx registers
Date: Thu, 29 Nov 2007 11:10:05 +0800
Message-Id: <1196305816-23023-26-git-send-email-yi.zhu@intel.com> (sfid-20071129_033548_443720_3EB4A88A)
In-Reply-To: <1196305816-23023-25-git-send-email-yi.zhu@intel.com>
References: <1196305816-23023-1-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-2-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-3-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-4-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-5-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-6-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-7-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-8-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-9-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-10-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-11-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-12-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-13-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-14-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-15-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-16-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-17-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-18-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-19-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-20-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-21-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-22-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-23-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-24-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-25-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Cahill <ben.m.cahill@intel.com>

Document Tx registers

Clean up unused definitions

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-hw.h |    2 -
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h |   72 ++++++++++++++++++----------
 2 files changed, 46 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
index 42da5be..f754d4a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
@@ -610,8 +610,6 @@ struct iwl3945_eeprom {
 #define PCI_CFG_REV_ID_BIT_BASIC_SKU                (0x40)	/* bit 6    */
 #define PCI_CFG_REV_ID_BIT_RTP                      (0x80)	/* bit 7    */
 
-#define HBUS_TARG_MBX_C_REG_BIT_CMD_BLOCKED         (0x00000004)
-
 #define TFD_QUEUE_MIN           0
 #define TFD_QUEUE_MAX           6
 #define TFD_QUEUE_SIZE_MAX      (256)
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
index dfd2852..d8a01b1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
@@ -567,7 +567,8 @@ struct iwl4965_eeprom {
 
 /*
  * Per-Tx-queue write pointer (index, really!) (3945 and 4965).
- * Indicates index to next TFD that driver will fill (1 past latest filled).
+ * Driver sets this to indicate index to next TFD that driver will fill
+ * (1 past latest filled).
  * Bit usage:
  *  0-7:  queue write index (0-255)
  * 11-8:  queue selector (0-15)
@@ -576,25 +577,6 @@ struct iwl4965_eeprom {
 
 #define HBUS_TARG_MBX_C         (HBUS_BASE+0x030)
 
-/*=== FH (data Flow Handler) ===*/
-#define FH_BASE     (0x800)
-
-#define FH_RSCSR_CHNL0_WPTR        (FH_RSCSR_CHNL0_RBDCB_WPTR_REG)
-
-/* RSSR */
-#define FH_RSSR_CTRL            (FH_RSSR_TABLE+0x000)
-#define FH_RSSR_STATUS          (FH_RSSR_TABLE+0x004)
-/* TCSR */
-#define FH_TCSR(_channel)           (FH_TCSR_TABLE+(_channel)*0x20)
-#define FH_TCSR_CONFIG(_channel)    (FH_TCSR(_channel)+0x00)
-#define FH_TCSR_CREDIT(_channel)    (FH_TCSR(_channel)+0x04)
-#define FH_TCSR_BUFF_STTS(_channel) (FH_TCSR(_channel)+0x08)
-/* TSSR */
-#define FH_TSSR_CBB_BASE        (FH_TSSR_TABLE+0x000)
-#define FH_TSSR_MSG_CONFIG      (FH_TSSR_TABLE+0x008)
-#define FH_TSSR_TX_STATUS       (FH_TSSR_TABLE+0x010)
-
-
 #define HBUS_TARG_MBX_C_REG_BIT_CMD_BLOCKED         (0x00000004)
 
 #define TFD_QUEUE_SIZE_MAX      (256)
@@ -1425,6 +1407,7 @@ enum {
  *         NOTE:  For 256-entry circular buffer, use only bits [7:0].
  */
 #define FH_RSCSR_CHNL0_RBDCB_WPTR_REG		(FH_MEM_RSCSR_CHNL0 + 0x008)
+#define FH_RSCSR_CHNL0_WPTR        (FH_RSCSR_CHNL0_RBDCB_WPTR_REG)
 
 
 /**
@@ -1500,15 +1483,55 @@ enum {
 
 #define FH_RSSR_CHNL0_RX_STATUS_CHNL_IDLE	(0x01000000)
 
-/* TCSR */
+
+/**
+ * Transmit DMA Channel Control/Status Registers (TCSR)
+ *
+ * 4965 has one configuration register for each of 8 Tx DMA/FIFO channels
+ * supported in hardware (don't confuse these with the 16 Tx queues in DRAM,
+ * which feed the DMA/FIFO channels); config regs are separated by 0x20 bytes.
+ *
+ * To use a Tx DMA channel, driver must initialize its
+ * IWL_FH_TCSR_CHNL_TX_CONFIG_REG(chnl) with:
+ *
+ * IWL_FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE |
+ * IWL_FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_ENABLE_VAL
+ *
+ * All other bits should be 0.
+ *
+ * Bit fields:
+ * 31-30: Tx DMA channel enable: '00' off/pause, '01' pause at end of frame,
+ *        '10' operate normally
+ * 29- 4: Reserved, set to "0"
+ *     3: Enable internal DMA requests (1, normal operation), disable (0)
+ *  2- 0: Reserved, set to "0"
+ */
 #define IWL_FH_TCSR_LOWER_BOUND  (FH_MEM_LOWER_BOUND + 0xD00)
 #define IWL_FH_TCSR_UPPER_BOUND  (FH_MEM_LOWER_BOUND + 0xE60)
 
+/* Find Control/Status reg for given Tx DMA/FIFO channel */
 #define IWL_FH_TCSR_CHNL_TX_CONFIG_REG(_chnl) \
 	(IWL_FH_TCSR_LOWER_BOUND + 0x20 * _chnl)
 
-/* TSSR Area - Tx shared status registers */
-/* TSSR */
+#define IWL_FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_DISABLE_VAL    (0x00000000)
+#define IWL_FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_ENABLE_VAL     (0x00000008)
+
+#define IWL_FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_PAUSE            (0x00000000)
+#define IWL_FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_PAUSE_EOF        (0x40000000)
+#define IWL_FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE           (0x80000000)
+
+/**
+ * Tx Shared Status Registers (TSSR)
+ *
+ * After stopping Tx DMA channel (writing 0 to
+ * IWL_FH_TCSR_CHNL_TX_CONFIG_REG(chnl)), driver must poll
+ * IWL_FH_TSSR_TX_STATUS_REG until selected Tx channel is idle
+ * (channel's buffers empty | no pending requests).
+ *
+ * Bit fields:
+ * 31-24:  1 = Channel buffers empty (channel 7:0)
+ * 23-16:  1 = No pending requests (channel 7:0)
+ */
 #define IWL_FH_TSSR_LOWER_BOUND		(FH_MEM_LOWER_BOUND + 0xEA0)
 #define IWL_FH_TSSR_UPPER_BOUND		(FH_MEM_LOWER_BOUND + 0xEC0)
 
@@ -1523,9 +1546,6 @@ enum {
 	(IWL_FH_TSSR_TX_STATUS_REG_BIT_BUFS_EMPTY(_chnl) | \
 	IWL_FH_TSSR_TX_STATUS_REG_BIT_NO_PEND_REQ(_chnl))
 
-#define IWL_FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_ENABLE_VAL     (0x00000008)
-
-#define IWL_FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE           (0x80000000)
 
 #define SCD_WIN_SIZE				64
 #define SCD_FRAME_LIMIT				64
-- 
1.5.3.6
