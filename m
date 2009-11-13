Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:31482 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932317AbZKMT4x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2009 14:56:53 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Ben Cahill <ben.m.cahill@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 16/16] iwlwifi: Add comments about CSR registers
Date: Fri, 13 Nov 2009 11:56:38 -0800
Message-Id: <1258142198-3223-17-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1258142198-3223-1-git-send-email-reinette.chatre@intel.com>
References: <1258142198-3223-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Cahill <ben.m.cahill@intel.com>

Also regroup CSR_EEPROM and CSR_OTP bit field definitions.

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-csr.h |  177 +++++++++++++++++++++++++++-----
 1 files changed, 150 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index b6ed5a3..68ed822 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -62,11 +62,29 @@
  *****************************************************************************/
 #ifndef __iwl_csr_h__
 #define __iwl_csr_h__
-/*=== CSR (control and status registers) ===*/
+/*
+ * CSR (control and status registers)
+ *
+ * CSR registers are mapped directly into PCI bus space, and are accessible
+ * whenever platform supplies power to device, even when device is in
+ * low power states due to driver-invoked device resets
+ * (e.g. CSR_RESET_REG_FLAG_SW_RESET) or uCode-driven power-saving modes.
+ *
+ * Use iwl_write32() and iwl_read32() family to access these registers;
+ * these provide simple PCI bus access, without waking up the MAC.
+ * Do not use iwl_write_direct32() family for these registers;
+ * no need to "grab nic access" via CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ.
+ * The MAC (uCode processor, etc.) does not need to be powered up for accessing
+ * the CSR registers.
+ *
+ * NOTE:  Newer devices using one-time-programmable (OTP) memory
+ *        require device to be awake in order to read this memory
+ *        via CSR_EEPROM and CSR_OTP registers
+ */
 #define CSR_BASE    (0x000)
 
 #define CSR_HW_IF_CONFIG_REG    (CSR_BASE+0x000) /* hardware interface config */
-#define CSR_INT_COALESCING     (CSR_BASE+0x004) /* accum ints, 32-usec units */
+#define CSR_INT_COALESCING      (CSR_BASE+0x004) /* accum ints, 32-usec units */
 #define CSR_INT                 (CSR_BASE+0x008) /* host interrupt status/ack */
 #define CSR_INT_MASK            (CSR_BASE+0x00c) /* host interrupt enable */
 #define CSR_FH_INT_STATUS       (CSR_BASE+0x010) /* busmaster int status/ack*/
@@ -74,42 +92,65 @@
 #define CSR_RESET               (CSR_BASE+0x020) /* busmaster enable, NMI, etc*/
 #define CSR_GP_CNTRL            (CSR_BASE+0x024)
 
+/* 2nd byte of CSR_INT_COALESCING, not accessible via iwl_write32()! */
+#define CSR_INT_PERIODIC_REG	(CSR_BASE+0x005)
+
 /*
  * Hardware revision info
  * Bit fields:
  * 31-8:  Reserved
- *  7-4:  Type of device:  0x0 = 4965, 0xd = 3945
+ *  7-4:  Type of device:  see CSR_HW_REV_TYPE_xxx definitions
  *  3-2:  Revision step:  0 = A, 1 = B, 2 = C, 3 = D
- *  1-0:  "Dash" value, as in A-1, etc.
+ *  1-0:  "Dash" (-) value, as in A-1, etc.
  *
  * NOTE:  Revision step affects calculation of CCK txpower for 4965.
+ * NOTE:  See also CSR_HW_REV_WA_REG (work-around for bug in 4965).
  */
 #define CSR_HW_REV              (CSR_BASE+0x028)
 
-/* EEPROM reads */
+/*
+ * EEPROM and OTP (one-time-programmable) memory reads
+ *
+ * NOTE:  For (newer) devices using OTP, device must be awake, initialized via
+ *        apm_ops.init() in order to read.  Older devices (3945/4965/5000)
+ *        use EEPROM and do not require this.
+ */
 #define CSR_EEPROM_REG          (CSR_BASE+0x02c)
 #define CSR_EEPROM_GP           (CSR_BASE+0x030)
 #define CSR_OTP_GP_REG   	(CSR_BASE+0x034)
+
 #define CSR_GIO_REG		(CSR_BASE+0x03C)
 #define CSR_GP_UCODE_REG	(CSR_BASE+0x048)
 #define CSR_GP_DRIVER_REG	(CSR_BASE+0x050)
+
+/*
+ * UCODE-DRIVER GP (general purpose) mailbox registers.
+ * SET/CLR registers set/clear bit(s) if "1" is written.
+ */
 #define CSR_UCODE_DRV_GP1       (CSR_BASE+0x054)
 #define CSR_UCODE_DRV_GP1_SET   (CSR_BASE+0x058)
 #define CSR_UCODE_DRV_GP1_CLR   (CSR_BASE+0x05c)
 #define CSR_UCODE_DRV_GP2       (CSR_BASE+0x060)
+
 #define CSR_LED_REG             (CSR_BASE+0x094)
 #define CSR_DRAM_INT_TBL_REG	(CSR_BASE+0x0A0)
+
+/* GIO Chicken Bits (PCI Express bus link power management) */
 #define CSR_GIO_CHICKEN_BITS    (CSR_BASE+0x100)
 
-#define CSR_INT_PERIODIC_REG	(CSR_BASE+0x005)
 /* Analog phase-lock-loop configuration  */
 #define CSR_ANA_PLL_CFG         (CSR_BASE+0x20c)
+
 /*
- * Indicates hardware rev, to determine CCK backoff for txpower calculation.
+ * CSR Hardware Revision Workaround Register.  Indicates hardware rev;
+ * "step" determines CCK backoff for txpower calculation.  Used for 4965 only.
+ * See also CSR_HW_REV register.
  * Bit fields:
  *  3-2:  0 = A, 1 = B, 2 = C, 3 = D step
+ *  1-0:  "Dash" (-) value, as in C-1, etc.
  */
 #define CSR_HW_REV_WA_REG		(CSR_BASE+0x22C)
+
 #define CSR_DBG_HPET_MEM_REG		(CSR_BASE+0x240)
 #define CSR_DBG_LINK_PWR_MGMT_REG	(CSR_BASE+0x250)
 
@@ -126,11 +167,11 @@
 #define CSR39_HW_IF_CONFIG_REG_BITS_SILICON_TYPE_A    (0x00000000)
 #define CSR39_HW_IF_CONFIG_REG_BITS_SILICON_TYPE_B    (0x00001000)
 
-#define CSR_HW_IF_CONFIG_REG_BIT_HAP_WAKE_L1A		(0x00080000)
-#define CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM		(0x00200000)
-#define CSR_HW_IF_CONFIG_REG_BIT_NIC_READY		(0x00400000)
-#define CSR_HW_IF_CONFIG_REG_BIT_NIC_PREPARE_DONE	(0x02000000)
-#define CSR_HW_IF_CONFIG_REG_PREPARE			(0x08000000)
+#define CSR_HW_IF_CONFIG_REG_BIT_HAP_WAKE_L1A	(0x00080000)
+#define CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM	(0x00200000)
+#define CSR_HW_IF_CONFIG_REG_BIT_NIC_READY	(0x00400000) /* PCI_OWN_SEM */
+#define CSR_HW_IF_CONFIG_REG_BIT_NIC_PREPARE_DONE (0x02000000) /* ME_OWN */
+#define CSR_HW_IF_CONFIG_REG_PREPARE		  (0x08000000) /* WAKE_ME */
 
 #define CSR_INT_PERIODIC_DIS			(0x00)
 #define CSR_INT_PERIODIC_ENA			(0xFF)
@@ -198,7 +239,44 @@
 #define CSR_RESET_REG_FLAG_STOP_MASTER               (0x00000200)
 #define CSR_RESET_LINK_PWR_MGMT_DISABLED             (0x80000000)
 
-/* GP (general purpose) CONTROL */
+/*
+ * GP (general purpose) CONTROL REGISTER
+ * Bit fields:
+ *    27:  HW_RF_KILL_SW
+ *         Indicates state of (platform's) hardware RF-Kill switch
+ * 26-24:  POWER_SAVE_TYPE
+ *         Indicates current power-saving mode:
+ *         000 -- No power saving
+ *         001 -- MAC power-down
+ *         010 -- PHY (radio) power-down
+ *         011 -- Error
+ *   9-6:  SYS_CONFIG
+ *         Indicates current system configuration, reflecting pins on chip
+ *         as forced high/low by device circuit board.
+ *     4:  GOING_TO_SLEEP
+ *         Indicates MAC is entering a power-saving sleep power-down.
+ *         Not a good time to access device-internal resources.
+ *     3:  MAC_ACCESS_REQ
+ *         Host sets this to request and maintain MAC wakeup, to allow host
+ *         access to device-internal resources.  Host must wait for
+ *         MAC_CLOCK_READY (and !GOING_TO_SLEEP) before accessing non-CSR
+ *         device registers.
+ *     2:  INIT_DONE
+ *         Host sets this to put device into fully operational D0 power mode.
+ *         Host resets this after SW_RESET to put device into low power mode.
+ *     0:  MAC_CLOCK_READY
+ *         Indicates MAC (ucode processor, etc.) is powered up and can run.
+ *         Internal resources are accessible.
+ *         NOTE:  This does not indicate that the processor is actually running.
+ *         NOTE:  This does not indicate that 4965 or 3945 has completed
+ *                init or post-power-down restore of internal SRAM memory.
+ *                Use CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP as indication that
+ *                SRAM is restored and uCode is in normal operation mode.
+ *                Later devices (5xxx/6xxx/1xxx) use non-volatile SRAM, and
+ *                do not need to save/restore it.
+ *         NOTE:  After device reset, this bit remains "0" until host sets
+ *                INIT_DONE
+ */
 #define CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY        (0x00000001)
 #define CSR_GP_CNTRL_REG_FLAG_INIT_DONE              (0x00000004)
 #define CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ         (0x00000008)
@@ -231,28 +309,58 @@
 #define CSR_EEPROM_REG_MSK_DATA		(0xFFFF0000)
 
 /* EEPROM GP */
-#define CSR_EEPROM_GP_VALID_MSK		(0x00000007)
+#define CSR_EEPROM_GP_VALID_MSK		(0x00000007) /* signature */
 #define CSR_EEPROM_GP_IF_OWNER_MSK	(0x00000180)
+#define CSR_EEPROM_GP_BAD_SIGNATURE_BOTH_EEP_AND_OTP	(0x00000000)
+#define CSR_EEPROM_GP_BAD_SIG_EEP_GOOD_SIG_OTP		(0x00000001)
+#define CSR_EEPROM_GP_GOOD_SIG_EEP_LESS_THAN_4K		(0x00000002)
+#define CSR_EEPROM_GP_GOOD_SIG_EEP_MORE_THAN_4K		(0x00000004)
+
+/* One-time-programmable memory general purpose reg */
 #define CSR_OTP_GP_REG_DEVICE_SELECT	(0x00010000) /* 0 - EEPROM, 1 - OTP */
 #define CSR_OTP_GP_REG_OTP_ACCESS_MODE	(0x00020000) /* 0 - absolute, 1 - relative */
 #define CSR_OTP_GP_REG_ECC_CORR_STATUS_MSK          (0x00100000) /* bit 20 */
 #define CSR_OTP_GP_REG_ECC_UNCORR_STATUS_MSK        (0x00200000) /* bit 21 */
+
+/* GP REG */
 #define CSR_GP_REG_POWER_SAVE_STATUS_MSK            (0x03000000) /* bit 24/25 */
 #define CSR_GP_REG_NO_POWER_SAVE            (0x00000000)
 #define CSR_GP_REG_MAC_POWER_SAVE           (0x01000000)
 #define CSR_GP_REG_PHY_POWER_SAVE           (0x02000000)
 #define CSR_GP_REG_POWER_SAVE_ERROR         (0x03000000)
 
-/* EEPROM signature */
-#define CSR_EEPROM_GP_BAD_SIGNATURE_BOTH_EEP_AND_OTP	(0x00000000)
-#define CSR_EEPROM_GP_BAD_SIG_EEP_GOOD_SIG_OTP		(0x00000001)
-#define CSR_EEPROM_GP_GOOD_SIG_EEP_LESS_THAN_4K		(0x00000002)
-#define CSR_EEPROM_GP_GOOD_SIG_EEP_MORE_THAN_4K		(0x00000004)
 
 /* CSR GIO */
 #define CSR_GIO_REG_VAL_L0S_ENABLED	(0x00000002)
 
-/* UCODE DRV GP */
+/*
+ * UCODE-DRIVER GP (general purpose) mailbox register 1
+ * Host driver and uCode write and/or read this register to communicate with
+ * each other.
+ * Bit fields:
+ *     4:  UCODE_DISABLE
+ *         Host sets this to request permanent halt of uCode, same as
+ *         sending CARD_STATE command with "halt" bit set.
+ *     3:  CT_KILL_EXIT
+ *         Host sets this to request exit from CT_KILL state, i.e. host thinks
+ *         device temperature is low enough to continue normal operation.
+ *     2:  CMD_BLOCKED
+ *         Host sets this during RF KILL power-down sequence (HW, SW, CT KILL)
+ *         to release uCode to clear all Tx and command queues, enter
+ *         unassociated mode, and power down.
+ *         NOTE:  Some devices also use HBUS_TARG_MBX_C register for this bit.
+ *     1:  SW_BIT_RFKILL
+ *         Host sets this when issuing CARD_STATE command to request
+ *         device sleep.
+ *     0:  MAC_SLEEP
+ *         uCode sets this when preparing a power-saving power-down.
+ *         uCode resets this when power-up is complete and SRAM is sane.
+ *         NOTE:  3945/4965 saves internal SRAM data to host when powering down,
+ *                and must restore this data after powering back up.
+ *                MAC_SLEEP is the best indication that restore is complete.
+ *                Later devices (5xxx/6xxx/1xxx) use non-volatile SRAM, and
+ *                do not need to save/restore it.
+ */
 #define CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP             (0x00000001)
 #define CSR_UCODE_SW_BIT_RFKILL                     (0x00000002)
 #define CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED           (0x00000004)
@@ -265,7 +373,7 @@
 #define CSR_GP_DRIVER_REG_BIT_RADIO_SKU_2x2_IPA	    (0x00000002)
 
 
-/* GI Chicken Bits */
+/* GIO Chicken Bits (PCI Express bus link power management) */
 #define CSR_GIO_CHICKEN_BITS_REG_BIT_L1A_NO_L0S_RX  (0x00800000)
 #define CSR_GIO_CHICKEN_BITS_REG_BIT_DIS_L0S_EXIT_TIMER  (0x20000000)
 
@@ -285,8 +393,23 @@
 #define CSR_DRAM_INT_TBL_ENABLE		(1 << 31)
 #define CSR_DRAM_INIT_TBL_WRAP_CHECK	(1 << 27)
 
-/*=== HBUS (Host-side Bus) ===*/
+/*
+ * HBUS (Host-side Bus)
+ *
+ * HBUS registers are mapped directly into PCI bus space, but are used
+ * to indirectly access device's internal memory or registers that
+ * may be powered-down.
+ *
+ * Use iwl_write_direct32()/iwl_read_direct32() family for these registers;
+ * host must "grab nic access" via CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ
+ * to make sure the MAC (uCode processor, etc.) is powered up for accessing
+ * internal resources.
+ *
+ * Do not use iwl_write32()/iwl_read32() family to access these registers;
+ * these provide only simple PCI bus access, without waking up the MAC.
+ */
 #define HBUS_BASE	(0x400)
+
 /*
  * Registers for accessing device's internal SRAM memory (e.g. SCD SRAM
  * structures, error log, event log, verifying uCode load).
@@ -301,6 +424,10 @@
 #define HBUS_TARG_MEM_WDAT      (HBUS_BASE+0x018)
 #define HBUS_TARG_MEM_RDAT      (HBUS_BASE+0x01c)
 
+/* Mailbox C, used as workaround alternative to CSR_UCODE_DRV_GP1 mailbox */
+#define HBUS_TARG_MBX_C         (HBUS_BASE+0x030)
+#define HBUS_TARG_MBX_C_REG_BIT_CMD_BLOCKED         (0x00000004)
+
 /*
  * Registers for accessing device's internal peripheral registers
  * (e.g. SCD, BSM, etc.).  First write to address register,
@@ -315,16 +442,12 @@
 #define HBUS_TARG_PRPH_RDAT     (HBUS_BASE+0x050)
 
 /*
- * Per-Tx-queue write pointer (index, really!) (3945 and 4965).
+ * Per-Tx-queue write pointer (index, really!)
  * Indicates index to next TFD that driver will fill (1 past latest filled).
  * Bit usage:
  *  0-7:  queue write index
  * 11-8:  queue selector
  */
 #define HBUS_TARG_WRPTR         (HBUS_BASE+0x060)
-#define HBUS_TARG_MBX_C         (HBUS_BASE+0x030)
-
-#define HBUS_TARG_MBX_C_REG_BIT_CMD_BLOCKED         (0x00000004)
-
 
 #endif /* !__iwl_csr_h__ */
-- 
1.5.6.3

