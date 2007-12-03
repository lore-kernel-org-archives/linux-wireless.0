Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:32093 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753124AbXLCLpN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2007 06:45:13 -0500
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, yi.zhu@intel.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Ben Cahill <ben.m.cahill@intel.com>
Subject: [PATCH 22/34] iwlwifi: document keep-warm buffer
Date: Mon,  3 Dec 2007 13:43:34 +0200
Message-Id: <11966822311945-git-send-email-tomas.winkler@intel.com> (sfid-20071203_120600_367616_009F962A)
In-Reply-To: <11966822311498-git-send-email-tomas.winkler@intel.com>
References: <11966822261109-git-send-email-tomas.winkler@intel.com>
 <11966822291406-git-send-email-tomas.winkler@intel.com>
 <1196682229843-git-send-email-tomas.winkler@intel.com>
 <11966822293932-git-send-email-tomas.winkler@intel.com>
 <11966822291956-git-send-email-tomas.winkler@intel.com>
 <119668222978-git-send-email-tomas.winkler@intel.com>
 <11966822293340-git-send-email-tomas.winkler@intel.com>
 <11966822291143-git-send-email-tomas.winkler@intel.com>
 <11966822301152-git-send-email-tomas.winkler@intel.com>
 <11966822302864-git-send-email-tomas.winkler@intel.com>
 <1196682230902-git-send-email-tomas.winkler@intel.com>
 <11966822302932-git-send-email-tomas.winkler@intel.com>
 <11966822302681-git-send-email-tomas.winkler@intel.com>
 <11966822301936-git-send-email-tomas.winkler@intel.com>
 <11966822302007-git-send-email-tomas.winkler@intel.com>
 <1196682230754-git-send-email-tomas.winkler@intel.com>
 <1196682231211-git-send-email-tomas.winkler@intel.com>
 <11966822313647-git-send-email-tomas.winkler@intel.com>
 <11966822312049-git-send-email-tomas.winkler@intel.com>
 <11966822311588-git-send-email-tomas.winkler@intel.com>
 <11966822314158-git-send-email-tomas.winkler@intel.com>
 <11966822311498-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
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
index e02860c..cc348de 100644
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
1.5.2.2
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
