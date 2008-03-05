Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:18467 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756339AbYCECKP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2008 21:10:15 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 08/11] iwlwifi: Move HBUS address to iwl-csr.h
Date: Tue,  4 Mar 2008 18:09:29 -0800
Message-Id: <1204682972-26004-9-git-send-email-reinette.chatre@intel.com> (sfid-20080305_021043_326663_658779D7)
In-Reply-To: <1204682972-26004-8-git-send-email-reinette.chatre@intel.com>
References: <1204682972-26004-1-git-send-email-reinette.chatre@intel.com>
 <1204682972-26004-2-git-send-email-reinette.chatre@intel.com>
 <1204682972-26004-3-git-send-email-reinette.chatre@intel.com>
 <1204682972-26004-4-git-send-email-reinette.chatre@intel.com>
 <1204682972-26004-5-git-send-email-reinette.chatre@intel.com>
 <1204682972-26004-6-git-send-email-reinette.chatre@intel.com>
 <1204682972-26004-7-git-send-email-reinette.chatre@intel.com>
 <1204682972-26004-8-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

HBUS is accessed through CSR registers
moved to iwl-csr.h

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-hw.h |   39 ------------------------
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h |   44 ----------------------------
 drivers/net/wireless/iwlwifi/iwl-csr.h     |   42 ++++++++++++++++++++++++++
 3 files changed, 42 insertions(+), 83 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
index 269224b..7dc1913 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
@@ -321,45 +321,6 @@ struct iwl3945_eeprom {
 #define PCI_REG_WUM8       0x0E8
 #define PCI_CFG_PMC_PME_FROM_D3COLD_SUPPORT         (0x80000000)
 
-/*=== HBUS (Host-side Bus) ===*/
-#define HBUS_BASE	(0x400)
-
-/*
- * Registers for accessing device's internal SRAM memory (e.g. SCD SRAM
- * structures, error log, event log, verifying uCode load).
- * First write to address register, then read from or write to data register
- * to complete the job.  Once the address register is set up, accesses to
- * data registers auto-increment the address by one dword.
- * Bit usage for address registers (read or write):
- *  0-31:  memory address within device
- */
-#define HBUS_TARG_MEM_RADDR     (HBUS_BASE+0x00c)
-#define HBUS_TARG_MEM_WADDR     (HBUS_BASE+0x010)
-#define HBUS_TARG_MEM_WDAT      (HBUS_BASE+0x018)
-#define HBUS_TARG_MEM_RDAT      (HBUS_BASE+0x01c)
-
-/*
- * Registers for accessing device's internal peripheral registers
- * (e.g. SCD, BSM, etc.).  First write to address register,
- * then read from or write to data register to complete the job.
- * Bit usage for address registers (read or write):
- *  0-15:  register address (offset) within device
- * 24-25:  (# bytes - 1) to read or write (e.g. 3 for dword)
- */
-#define HBUS_TARG_PRPH_WADDR    (HBUS_BASE+0x044)
-#define HBUS_TARG_PRPH_RADDR    (HBUS_BASE+0x048)
-#define HBUS_TARG_PRPH_WDAT     (HBUS_BASE+0x04c)
-#define HBUS_TARG_PRPH_RDAT     (HBUS_BASE+0x050)
-
-/*
- * Per-Tx-queue write pointer (index, really!) (3945 and 4965).
- * Indicates index to next TFD that driver will fill (1 past latest filled).
- * Bit usage:
- *  0-7:  queue write index
- * 11-8:  queue selector
- */
-#define HBUS_TARG_WRPTR         (HBUS_BASE+0x060)
-
 /* SCD (3945 Tx Frame Scheduler) */
 #define SCD_BASE                        (CSR_BASE + 0x2E00)
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
index 7e8cc99..24413a4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
@@ -410,50 +410,6 @@ struct iwl4965_eeprom {
 #define PCI_REG_WUM8       0x0E8
 #define PCI_CFG_PMC_PME_FROM_D3COLD_SUPPORT         (0x80000000)
 
-/*=== HBUS (Host-side Bus) ===*/
-#define HBUS_BASE	(0x400)
-
-/*
- * Registers for accessing device's internal SRAM memory (e.g. SCD SRAM
- * structures, error log, event log, verifying uCode load).
- * First write to address register, then read from or write to data register
- * to complete the job.  Once the address register is set up, accesses to
- * data registers auto-increment the address by one dword.
- * Bit usage for address registers (read or write):
- *  0-31:  memory address within device
- */
-#define HBUS_TARG_MEM_RADDR     (HBUS_BASE+0x00c)
-#define HBUS_TARG_MEM_WADDR     (HBUS_BASE+0x010)
-#define HBUS_TARG_MEM_WDAT      (HBUS_BASE+0x018)
-#define HBUS_TARG_MEM_RDAT      (HBUS_BASE+0x01c)
-
-/*
- * Registers for accessing device's internal peripheral registers
- * (e.g. SCD, BSM, etc.).  First write to address register,
- * then read from or write to data register to complete the job.
- * Bit usage for address registers (read or write):
- *  0-15:  register address (offset) within device
- * 24-25:  (# bytes - 1) to read or write (e.g. 3 for dword)
- */
-#define HBUS_TARG_PRPH_WADDR    (HBUS_BASE+0x044)
-#define HBUS_TARG_PRPH_RADDR    (HBUS_BASE+0x048)
-#define HBUS_TARG_PRPH_WDAT     (HBUS_BASE+0x04c)
-#define HBUS_TARG_PRPH_RDAT     (HBUS_BASE+0x050)
-
-/*
- * Per-Tx-queue write pointer (index, really!) (3945 and 4965).
- * Driver sets this to indicate index to next TFD that driver will fill
- * (1 past latest filled).
- * Bit usage:
- *  0-7:  queue write index (0-255)
- * 11-8:  queue selector (0-15)
- */
-#define HBUS_TARG_WRPTR         (HBUS_BASE+0x060)
-
-#define HBUS_TARG_MBX_C         (HBUS_BASE+0x030)
-
-#define HBUS_TARG_MBX_C_REG_BIT_CMD_BLOCKED         (0x00000004)
-
 #define TFD_QUEUE_SIZE_MAX      (256)
 
 #define IWL_NUM_SCAN_RATES         (2)
diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index 276ba28..7016e5b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -214,4 +214,46 @@
 #define CSR_GIO_CHICKEN_BITS_REG_BIT_L1A_NO_L0S_RX  (0x00800000)
 #define CSR_GIO_CHICKEN_BITS_REG_BIT_DIS_L0S_EXIT_TIMER  (0x20000000)
 
+/*=== HBUS (Host-side Bus) ===*/
+#define HBUS_BASE	(0x400)
+/*
+ * Registers for accessing device's internal SRAM memory (e.g. SCD SRAM
+ * structures, error log, event log, verifying uCode load).
+ * First write to address register, then read from or write to data register
+ * to complete the job.  Once the address register is set up, accesses to
+ * data registers auto-increment the address by one dword.
+ * Bit usage for address registers (read or write):
+ *  0-31:  memory address within device
+ */
+#define HBUS_TARG_MEM_RADDR     (HBUS_BASE+0x00c)
+#define HBUS_TARG_MEM_WADDR     (HBUS_BASE+0x010)
+#define HBUS_TARG_MEM_WDAT      (HBUS_BASE+0x018)
+#define HBUS_TARG_MEM_RDAT      (HBUS_BASE+0x01c)
+
+/*
+ * Registers for accessing device's internal peripheral registers
+ * (e.g. SCD, BSM, etc.).  First write to address register,
+ * then read from or write to data register to complete the job.
+ * Bit usage for address registers (read or write):
+ *  0-15:  register address (offset) within device
+ * 24-25:  (# bytes - 1) to read or write (e.g. 3 for dword)
+ */
+#define HBUS_TARG_PRPH_WADDR    (HBUS_BASE+0x044)
+#define HBUS_TARG_PRPH_RADDR    (HBUS_BASE+0x048)
+#define HBUS_TARG_PRPH_WDAT     (HBUS_BASE+0x04c)
+#define HBUS_TARG_PRPH_RDAT     (HBUS_BASE+0x050)
+
+/*
+ * Per-Tx-queue write pointer (index, really!) (3945 and 4965).
+ * Indicates index to next TFD that driver will fill (1 past latest filled).
+ * Bit usage:
+ *  0-7:  queue write index
+ * 11-8:  queue selector
+ */
+#define HBUS_TARG_WRPTR         (HBUS_BASE+0x060)
+#define HBUS_TARG_MBX_C         (HBUS_BASE+0x030)
+
+#define HBUS_TARG_MBX_C_REG_BIT_CMD_BLOCKED         (0x00000004)
+
+
 
-- 
1.5.3.4

