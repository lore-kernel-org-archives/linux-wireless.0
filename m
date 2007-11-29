Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:25653 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756401AbXK2DLC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 22:11:02 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ben Cahill <ben.m.cahill@intel.com>, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 23/36] iwlwifi: document keep-warm buffer
Date: Thu, 29 Nov 2007 11:10:03 +0800
Message-Id: <1196305816-23023-24-git-send-email-yi.zhu@intel.com> (sfid-20071129_033546_613529_F955C113)
In-Reply-To: <1196305816-23023-23-git-send-email-yi.zhu@intel.com>
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
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Cahill <ben.m.cahill@intel.com>

Document keep-warm buffer

Consolidate flow handler address definitions

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h |   39 ++++++++++++++++++++--------
 1 files changed, 28 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
index 40666f8..3c78e2d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
@@ -1282,20 +1282,37 @@ enum {
 
 /********************* END TXPOWER *****************************************/
 
+/****************************/
 /* Flow Handler Definitions */
+/****************************/
 
-/**********************/
-/*     Addresses      */
-/**********************/
-
+/*
+ * This I/O area is directly read/writable by driver (e.g. Linux uses writel())
+ * Addresses are offsets from device's PCI hardware base address.
+ */
 #define FH_MEM_LOWER_BOUND                   (0x1000)
 #define FH_MEM_UPPER_BOUND                   (0x1EF0)
 
-#define IWL_FH_REGS_LOWER_BOUND		     (0x1000)
-#define IWL_FH_REGS_UPPER_BOUND		     (0x2000)
-
+/**
+ * Keep-Warm (KW) buffer base address.
+ *
+ * Driver must allocate a 4KByte buffer that is used by 4965 for keeping the
+ * host DRAM powered on (via dummy accesses to DRAM) to maintain low-latency
+ * DRAM access when 4965 is Txing or Rxing.  The dummy accesses prevent host
+ * from going into a power-savings mode that would cause higher DRAM latency,
+ * and possible data over/under-runs, before all Tx/Rx is complete.
+ *
+ * Driver loads IWL_FH_KW_MEM_ADDR_REG with the physical address (bits 35:4)
+ * of the buffer, which must be 4K aligned.  Once this is set up, the 4965
+ * automatically invokes keep-warm accesses when normal accesses might not
+ * be sufficient to maintain fast DRAM response.
+ *
+ * Bit fields:
+ *  31-0:  Keep-warm buffer physical base address [35:4], must be 4K aligned
+ */
 #define IWL_FH_KW_MEM_ADDR_REG		     (FH_MEM_LOWER_BOUND + 0x97C)
 
+
 /* CBBC Area - Circular buffers base address cache pointers table */
 #define FH_MEM_CBBC_LOWER_BOUND              (FH_MEM_LOWER_BOUND + 0x9D0)
 #define FH_MEM_CBBC_UPPER_BOUND              (FH_MEM_LOWER_BOUND + 0xA10)
@@ -1326,16 +1343,16 @@ enum {
 #define FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV  (FH_MEM_RSSR_LOWER_BOUND + 0x008)
 
 /* TCSR */
-#define IWL_FH_TCSR_LOWER_BOUND  (IWL_FH_REGS_LOWER_BOUND + 0xD00)
-#define IWL_FH_TCSR_UPPER_BOUND  (IWL_FH_REGS_LOWER_BOUND + 0xE60)
+#define IWL_FH_TCSR_LOWER_BOUND  (FH_MEM_LOWER_BOUND + 0xD00)
+#define IWL_FH_TCSR_UPPER_BOUND  (FH_MEM_LOWER_BOUND + 0xE60)
 
 #define IWL_FH_TCSR_CHNL_TX_CONFIG_REG(_chnl) \
 	(IWL_FH_TCSR_LOWER_BOUND + 0x20 * _chnl)
 
 /* TSSR Area - Tx shared status registers */
 /* TSSR */
-#define IWL_FH_TSSR_LOWER_BOUND		(IWL_FH_REGS_LOWER_BOUND + 0xEA0)
-#define IWL_FH_TSSR_UPPER_BOUND		(IWL_FH_REGS_LOWER_BOUND + 0xEC0)
+#define IWL_FH_TSSR_LOWER_BOUND		(FH_MEM_LOWER_BOUND + 0xEA0)
+#define IWL_FH_TSSR_UPPER_BOUND		(FH_MEM_LOWER_BOUND + 0xEC0)
 
 #define IWL_FH_TSSR_TX_STATUS_REG	(IWL_FH_TSSR_LOWER_BOUND + 0x010)
 
-- 
1.5.3.6
