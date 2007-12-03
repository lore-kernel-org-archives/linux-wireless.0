Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:56602 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752961AbXLCLoi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2007 06:44:38 -0500
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, yi.zhu@intel.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 12/34] iwlwifi: Partially clean-up, add comments to iwl-*-hw.h
Date: Mon,  3 Dec 2007 13:43:24 +0200
Message-Id: <11966822302681-git-send-email-tomas.winkler@intel.com> (sfid-20071203_114443_599315_8706520F)
In-Reply-To: <11966822302932-git-send-email-tomas.winkler@intel.com>
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
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhu Yi <yi.zhu@intel.com>

Resend. Replace mail subject due to ML restriction for capital Triple-X
in subject.

On Thu, 2007-11-29 at 11:09 +0800, Zhu Yi wrote:
From: Ben Cahill <ben.m.cahill@intel.com>

Partially clean-up, add comments to iwl-XXXX-hw.h

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-hw.h |   66 ++++++++++++++++-------
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h |   78 ++++++++++++++++++----------
 2 files changed, 97 insertions(+), 47 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
index 6351df9..6e961ac 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
@@ -64,10 +64,11 @@
 #ifndef __iwl_3945_hw__
 #define __iwl_3945_hw__
 
-/* uCode queue management definitions */
+/*
+ * uCode queue management definitions ...
+ * Queue #4 is the command queue for 3945 and 4965.
+ */
 #define IWL_CMD_QUEUE_NUM       4
-#define IWL_CMD_FIFO_NUM        4
-#define IWL_BACK_QUEUE_FIRST_ID 7
 
 /* Tx rates */
 #define IWL_CCK_RATES 4
@@ -314,7 +315,6 @@ struct iwl3945_eeprom {
 
 	u8 reserved9[194];
 
-
 /*
  * 3945 Txpower calibration data.
  */
@@ -355,7 +355,18 @@ struct iwl3945_eeprom {
 #define CSR_GPIO_IN             (CSR_BASE+0x018) /* read external chip pins */
 #define CSR_RESET               (CSR_BASE+0x020) /* busmaster enable, NMI, etc*/
 #define CSR_GP_CNTRL            (CSR_BASE+0x024)
+
+/*
+ * Hardware revision info
+ * Bit fields:
+ * 31-8:  Reserved
+ *  7-4:  Type of device:  0x0 = 4965, 0xd = 3945
+ *  3-2:  Revision step:  0 = A, 1 = B, 2 = C, 3 = D
+ *  1-0:  "Dash" value, as in A-1, etc.
+ */
 #define CSR_HW_REV              (CSR_BASE+0x028)
+
+/* EEPROM reads */
 #define CSR_EEPROM_REG          (CSR_BASE+0x02c)
 #define CSR_EEPROM_GP           (CSR_BASE+0x030)
 #define CSR_GP_UCODE		(CSR_BASE+0x044)
@@ -363,13 +374,13 @@ struct iwl3945_eeprom {
 #define CSR_UCODE_DRV_GP1_SET   (CSR_BASE+0x058)
 #define CSR_UCODE_DRV_GP1_CLR   (CSR_BASE+0x05c)
 #define CSR_UCODE_DRV_GP2       (CSR_BASE+0x060)
-#define CSR_LED_REG		(CSR_BASE+0x094)
-#define CSR_DRAM_INT_TBL_CTL	(CSR_BASE+0x0A0)
 #define CSR_GIO_CHICKEN_BITS    (CSR_BASE+0x100)
+
+/* Analog phase-lock-loop configuration (3945 only)
+ * Set bit 24. */
 #define CSR_ANA_PLL_CFG         (CSR_BASE+0x20c)
-#define CSR_HW_REV_WA_REG	(CSR_BASE+0x22C)
 
-/* HW I/F configuration */
+/* Bits for CSR_HW_IF_CONFIG_REG */
 #define CSR_HW_IF_CONFIG_REG_BIT_ALMAGOR_MB         (0x00000100)
 #define CSR_HW_IF_CONFIG_REG_BIT_ALMAGOR_MM         (0x00000200)
 #define CSR_HW_IF_CONFIG_REG_BIT_SKU_MRC            (0x00000400)
@@ -468,31 +479,46 @@ struct iwl3945_eeprom {
 /* CSR_ANA_PLL_CFG */
 #define CSR_ANA_PLL_CFG_SH		(0x00880300)
 
-#define CSR_LED_REG_TRUN_ON		(0x00000078)
-#define CSR_LED_REG_TRUN_OFF		(0x00000038)
-#define CSR_LED_BSM_CTRL_MSK		(0xFFFFFFDF)
-
-/* DRAM_INT_TBL_CTRL */
-#define CSR_DRAM_INT_TBL_CTRL_EN	(1<<31)
-#define CSR_DRAM_INT_TBL_CTRL_WRAP_CHK	(1<<27)
-
 /*=== HBUS (Host-side Bus) ===*/
 #define HBUS_BASE	(0x400)
 
+/*
+ * Registers for accessing device's internal SRAM memory (e.g. SCD SRAM
+ * structures, error log, event log, verifying uCode load).
+ * First write to address register, then read from or write to data register
+ * to complete the job.  Once the address register is set up, accesses to
+ * data registers auto-increment the address by one dword.
+ * Bit usage for address registers (read or write):
+ *  0-31:  memory address within device
+ */
 #define HBUS_TARG_MEM_RADDR     (HBUS_BASE+0x00c)
 #define HBUS_TARG_MEM_WADDR     (HBUS_BASE+0x010)
 #define HBUS_TARG_MEM_WDAT      (HBUS_BASE+0x018)
 #define HBUS_TARG_MEM_RDAT      (HBUS_BASE+0x01c)
+
+/*
+ * Registers for accessing device's internal peripheral registers
+ * (e.g. SCD, BSM, etc.).  First write to address register,
+ * then read from or write to data register to complete the job.
+ * Bit usage for address registers (read or write):
+ *  0-15:  register address (offset) within device
+ * 24-25:  (# bytes - 1) to read or write (e.g. 3 for dword)
+ */
 #define HBUS_TARG_PRPH_WADDR    (HBUS_BASE+0x044)
 #define HBUS_TARG_PRPH_RADDR    (HBUS_BASE+0x048)
 #define HBUS_TARG_PRPH_WDAT     (HBUS_BASE+0x04c)
 #define HBUS_TARG_PRPH_RDAT     (HBUS_BASE+0x050)
-#define HBUS_TARG_WRPTR         (HBUS_BASE+0x060)
-
-#define HBUS_TARG_MBX_C         (HBUS_BASE+0x030)
 
+/*
+ * Per-Tx-queue write pointer (index, really!) (3945 and 4965).
+ * Indicates index to next TFD that driver will fill (1 past latest filled).
+ * Bit usage:
+ *  0-7:  queue write index
+ * 11-8:  queue selector
+ */
+#define HBUS_TARG_WRPTR         (HBUS_BASE+0x060)
 
-/* SCD (Scheduler) */
+/* SCD (3945 Tx Frame Scheduler) */
 #define SCD_BASE                        (CSR_BASE + 0x2E00)
 
 #define SCD_MODE_REG                    (SCD_BASE + 0x000)
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
index 65c2ae4..ad1e76c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
@@ -64,7 +64,12 @@
 #ifndef __iwl_4965_hw_h__
 #define __iwl_4965_hw_h__
 
-/* uCode queue management definitions */
+/*
+ * uCode queue management definitions ...
+ * Queue #4 is the command queue for 3945 and 4965; map it to Tx FIFO chnl 4.
+ * The first queue used for block-ack aggregation is #7 (4965 only).
+ * All block-ack aggregation queues should map to Tx DMA/FIFO channel 7.
+ */
 #define IWL_CMD_QUEUE_NUM       4
 #define IWL_CMD_FIFO_NUM        4
 #define IWL_BACK_QUEUE_FIRST_ID 7
@@ -444,7 +449,20 @@ struct iwl4965_eeprom {
 #define CSR_GPIO_IN             (CSR_BASE+0x018) /* read external chip pins */
 #define CSR_RESET               (CSR_BASE+0x020) /* busmaster enable, NMI, etc*/
 #define CSR_GP_CNTRL            (CSR_BASE+0x024)
+
+/*
+ * Hardware revision info
+ * Bit fields:
+ * 31-8:  Reserved
+ *  7-4:  Type of device:  0x0 = 4965, 0xd = 3945
+ *  3-2:  Revision step:  0 = A, 1 = B, 2 = C, 3 = D
+ *  1-0:  "Dash" value, as in A-1, etc.
+ *
+ * NOTE:  Revision step affects calculation of CCK txpower for 4965.
+ */
 #define CSR_HW_REV              (CSR_BASE+0x028)
+
+/* EEPROM reads */
 #define CSR_EEPROM_REG          (CSR_BASE+0x02c)
 #define CSR_EEPROM_GP           (CSR_BASE+0x030)
 #define CSR_GP_UCODE		(CSR_BASE+0x044)
@@ -452,10 +470,13 @@ struct iwl4965_eeprom {
 #define CSR_UCODE_DRV_GP1_SET   (CSR_BASE+0x058)
 #define CSR_UCODE_DRV_GP1_CLR   (CSR_BASE+0x05c)
 #define CSR_UCODE_DRV_GP2       (CSR_BASE+0x060)
-#define CSR_LED_REG		(CSR_BASE+0x094)
-#define CSR_DRAM_INT_TBL_CTL	(CSR_BASE+0x0A0)
 #define CSR_GIO_CHICKEN_BITS    (CSR_BASE+0x100)
-#define CSR_ANA_PLL_CFG         (CSR_BASE+0x20c)
+
+/*
+ * Indicates hardware rev, to determine CCK backoff for txpower calculation.
+ * Bit fields:
+ *  3-2:  0 = A, 1 = B, 2 = C, 3 = D step
+ */
 #define CSR_HW_REV_WA_REG	(CSR_BASE+0x22C)
 
 /* HW I/F configuration */
@@ -554,44 +575,47 @@ struct iwl4965_eeprom {
 #define CSR_GIO_CHICKEN_BITS_REG_BIT_L1A_NO_L0S_RX  (0x00800000)
 #define CSR_GIO_CHICKEN_BITS_REG_BIT_DIS_L0S_EXIT_TIMER  (0x20000000)
 
-/* CSR_ANA_PLL_CFG */
-#define CSR_ANA_PLL_CFG_SH		(0x00880300)
-
-#define CSR_LED_REG_TRUN_ON		(0x00000078)
-#define CSR_LED_REG_TRUN_OFF		(0x00000038)
-#define CSR_LED_BSM_CTRL_MSK		(0xFFFFFFDF)
-
-/* DRAM_INT_TBL_CTRL */
-#define CSR_DRAM_INT_TBL_CTRL_EN	(1<<31)
-#define CSR_DRAM_INT_TBL_CTRL_WRAP_CHK	(1<<27)
-
 /*=== HBUS (Host-side Bus) ===*/
 #define HBUS_BASE	(0x400)
 
+/*
+ * Registers for accessing device's internal SRAM memory (e.g. SCD SRAM
+ * structures, error log, event log, verifying uCode load).
+ * First write to address register, then read from or write to data register
+ * to complete the job.  Once the address register is set up, accesses to
+ * data registers auto-increment the address by one dword.
+ * Bit usage for address registers (read or write):
+ *  0-31:  memory address within device
+ */
 #define HBUS_TARG_MEM_RADDR     (HBUS_BASE+0x00c)
 #define HBUS_TARG_MEM_WADDR     (HBUS_BASE+0x010)
 #define HBUS_TARG_MEM_WDAT      (HBUS_BASE+0x018)
 #define HBUS_TARG_MEM_RDAT      (HBUS_BASE+0x01c)
+
+/*
+ * Registers for accessing device's internal peripheral registers
+ * (e.g. SCD, BSM, etc.).  First write to address register,
+ * then read from or write to data register to complete the job.
+ * Bit usage for address registers (read or write):
+ *  0-15:  register address (offset) within device
+ * 24-25:  (# bytes - 1) to read or write (e.g. 3 for dword)
+ */
 #define HBUS_TARG_PRPH_WADDR    (HBUS_BASE+0x044)
 #define HBUS_TARG_PRPH_RADDR    (HBUS_BASE+0x048)
 #define HBUS_TARG_PRPH_WDAT     (HBUS_BASE+0x04c)
 #define HBUS_TARG_PRPH_RDAT     (HBUS_BASE+0x050)
+
+/*
+ * Per-Tx-queue write pointer (index, really!) (3945 and 4965).
+ * Indicates index to next TFD that driver will fill (1 past latest filled).
+ * Bit usage:
+ *  0-7:  queue write index (0-255)
+ * 11-8:  queue selector (0-15)
+ */
 #define HBUS_TARG_WRPTR         (HBUS_BASE+0x060)
 
 #define HBUS_TARG_MBX_C         (HBUS_BASE+0x030)
 
-
-/* SCD (Scheduler) */
-#define SCD_BASE                        (CSR_BASE + 0x2E00)
-
-#define SCD_MODE_REG                    (SCD_BASE + 0x000)
-#define SCD_ARASTAT_REG                 (SCD_BASE + 0x004)
-#define SCD_TXFACT_REG                  (SCD_BASE + 0x010)
-#define SCD_TXF4MF_REG                  (SCD_BASE + 0x014)
-#define SCD_TXF5MF_REG                  (SCD_BASE + 0x020)
-#define SCD_SBYP_MODE_1_REG             (SCD_BASE + 0x02C)
-#define SCD_SBYP_MODE_2_REG             (SCD_BASE + 0x030)
-
 /*=== FH (data Flow Handler) ===*/
 #define FH_BASE     (0x800)
 
-- 
1.5.2.2
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
