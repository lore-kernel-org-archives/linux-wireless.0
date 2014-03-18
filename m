Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:37737 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901AbaCROpy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 10:45:54 -0400
Received: by mail-ee0-f47.google.com with SMTP id b15so5402489eek.6
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 07:45:53 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Alexander Bondar <alexander.bondar@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 07/35] iwlwifi: pcie: enable LP XTAL to reduce power consumption
Date: Tue, 18 Mar 2014 16:45:11 +0200
Message-Id: <1395153939-23897-7-git-send-email-egrumbach@gmail.com> (sfid-20140318_154601_123984_63FC4A63)
In-Reply-To: <53285AF8.7050305@gmail.com>
References: <53285AF8.7050305@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alexander Bondar <alexander.bondar@intel.com>

1. Enable LP XTAL to avoid HW bug where device may consume much
power if FW is not loaded after device reset. LP XTAL is
disabled by default after device HW reset. Configure device's
"persistence" mode to avoid resetting XTAL again when SHRD_HW_RST
occurs in S3.

2. Add methods to access SHR (shared block memory space) directly from PCI
bus w/o need to power up MAC HW.

Shared internal registers (e.g. SHR_APMG_GP1, SHR_APMG_XTAL_CFG)can be
accessed directly from PCI bus through SHR arbiter even when MAC HW is
powered down. This is possible due to indirect read/write via
HEEP_CTRL_WRD_PCIEX_CTRL (0xEC) and HEEP_CTRL_WRD_PCIEX_DATA (0xF4)
registers.

Use iwl_write32()/iwl_read32() family to access these registers. The MAC HW
need not be powered up so no "grab inc access" is required.

For example, to read from SHR_APMG_GP1 register (0x1DC),
first, write to the control register:
HEEP_CTRL_WRD_PCIEX_CTRL[15:0] = 0x1DC (offset of the SHR_APMG_GP1 register)
HEEP_CTRL_WRD_PCIEX_CTRL[29:28] = 2 (read access)
second, read from the data register HEEP_CTRL_WRD_PCIEX_DATA[31:0].

To write the register, first, write to the data register
HEEP_CTRL_WRD_PCIEX_DATA[31:0] and then:
HEEP_CTRL_WRD_PCIEX_CTRL[15:0] = 0x1DC (offset of the SHR_APMG_GP1 register)
HEEP_CTRL_WRD_PCIEX_CTRL[29:28] = 3 (write access)

Signed-off-by: Alexander Bondar <alexander.bondar@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-7000.c   |   4 +
 drivers/net/wireless/iwlwifi/iwl-config.h |   1 +
 drivers/net/wireless/iwlwifi/iwl-csr.h    |  38 +++++++++
 drivers/net/wireless/iwlwifi/iwl-io.c     |   4 +-
 drivers/net/wireless/iwlwifi/iwl-io.h     |   2 +
 drivers/net/wireless/iwlwifi/iwl-prph.h   |  23 +++++-
 drivers/net/wireless/iwlwifi/pcie/trans.c | 131 ++++++++++++++++++++++++++++++
 7 files changed, 200 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-7000.c b/drivers/net/wireless/iwlwifi/iwl-7000.c
index fbd262f..003a546 100644
--- a/drivers/net/wireless/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-7000.c
@@ -134,6 +134,7 @@ const struct iwl_cfg iwl7260_2ac_cfg = {
 	.nvm_ver = IWL7260_NVM_VERSION,
 	.nvm_calib_ver = IWL7260_TX_POWER_VERSION,
 	.host_interrupt_operation_mode = true,
+	.lp_xtal_workaround = true,
 };
 
 const struct iwl_cfg iwl7260_2ac_cfg_high_temp = {
@@ -145,6 +146,7 @@ const struct iwl_cfg iwl7260_2ac_cfg_high_temp = {
 	.nvm_calib_ver = IWL7260_TX_POWER_VERSION,
 	.high_temp = true,
 	.host_interrupt_operation_mode = true,
+	.lp_xtal_workaround = true,
 };
 
 const struct iwl_cfg iwl7260_2n_cfg = {
@@ -155,6 +157,7 @@ const struct iwl_cfg iwl7260_2n_cfg = {
 	.nvm_ver = IWL7260_NVM_VERSION,
 	.nvm_calib_ver = IWL7260_TX_POWER_VERSION,
 	.host_interrupt_operation_mode = true,
+	.lp_xtal_workaround = true,
 };
 
 const struct iwl_cfg iwl7260_n_cfg = {
@@ -165,6 +168,7 @@ const struct iwl_cfg iwl7260_n_cfg = {
 	.nvm_ver = IWL7260_NVM_VERSION,
 	.nvm_calib_ver = IWL7260_TX_POWER_VERSION,
 	.host_interrupt_operation_mode = true,
+	.lp_xtal_workaround = true,
 };
 
 const struct iwl_cfg iwl3160_2ac_cfg = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-config.h b/drivers/net/wireless/iwlwifi/iwl-config.h
index 13ec566..3f17dc3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -262,6 +262,7 @@ struct iwl_cfg {
 	bool high_temp;
 	bool d0i3;
 	u8   nvm_hw_section_num;
+	bool lp_xtal_workaround;
 	const struct iwl_pwr_tx_backoff *pwr_tx_backoffs;
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index f13dec9..fe129c9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -139,6 +139,13 @@
 #define CSR_ANA_PLL_CFG         (CSR_BASE+0x20c)
 
 /*
+ * CSR HW resources monitor registers
+ */
+#define CSR_MONITOR_CFG_REG		(CSR_BASE+0x214)
+#define CSR_MONITOR_STATUS_REG		(CSR_BASE+0x228)
+#define CSR_MONITOR_XTAL_RESOURCES	(0x00000010)
+
+/*
  * CSR Hardware Revision Workaround Register.  Indicates hardware rev;
  * "step" determines CCK backoff for txpower calculation.  Used for 4965 only.
  * See also CSR_HW_REV register.
@@ -173,6 +180,7 @@
 #define CSR_HW_IF_CONFIG_REG_BIT_NIC_READY	(0x00400000) /* PCI_OWN_SEM */
 #define CSR_HW_IF_CONFIG_REG_BIT_NIC_PREPARE_DONE (0x02000000) /* ME_OWN */
 #define CSR_HW_IF_CONFIG_REG_PREPARE		  (0x08000000) /* WAKE_ME */
+#define CSR_HW_IF_CONFIG_REG_PERSIST_MODE	  (0x40000000) /* PERSISTENCE */
 
 #define CSR_INT_PERIODIC_DIS			(0x00) /* disable periodic int*/
 #define CSR_INT_PERIODIC_ENA			(0xFF) /* 255*32 usec ~ 8 msec*/
@@ -240,6 +248,7 @@
  *         001 -- MAC power-down
  *         010 -- PHY (radio) power-down
  *         011 -- Error
+ *    10:  XTAL ON request
  *   9-6:  SYS_CONFIG
  *         Indicates current system configuration, reflecting pins on chip
  *         as forced high/low by device circuit board.
@@ -271,6 +280,7 @@
 #define CSR_GP_CNTRL_REG_FLAG_INIT_DONE              (0x00000004)
 #define CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ         (0x00000008)
 #define CSR_GP_CNTRL_REG_FLAG_GOING_TO_SLEEP         (0x00000010)
+#define CSR_GP_CNTRL_REG_FLAG_XTAL_ON		     (0x00000400)
 
 #define CSR_GP_CNTRL_REG_VAL_MAC_ACCESS_EN           (0x00000001)
 
@@ -396,6 +406,34 @@
 #define CSR_DRAM_INIT_TBL_WRAP_CHECK	(1 << 27)
 
 /*
+ * SHR target access (Shared block memory space)
+ *
+ * Shared internal registers can be accessed directly from PCI bus through SHR
+ * arbiter without need for the MAC HW to be powered up. This is possible due to
+ * indirect read/write via HEEP_CTRL_WRD_PCIEX_CTRL (0xEC) and
+ * HEEP_CTRL_WRD_PCIEX_DATA (0xF4) registers.
+ *
+ * Use iwl_write32()/iwl_read32() family to access these registers. The MAC HW
+ * need not be powered up so no "grab inc access" is required.
+ */
+
+/*
+ * Registers for accessing shared registers (e.g. SHR_APMG_GP1,
+ * SHR_APMG_XTAL_CFG). For example, to read from SHR_APMG_GP1 register (0x1DC),
+ * first, write to the control register:
+ * HEEP_CTRL_WRD_PCIEX_CTRL[15:0] = 0x1DC (offset of the SHR_APMG_GP1 register)
+ * HEEP_CTRL_WRD_PCIEX_CTRL[29:28] = 2 (read access)
+ * second, read from the data register HEEP_CTRL_WRD_PCIEX_DATA[31:0].
+ *
+ * To write the register, first, write to the data register
+ * HEEP_CTRL_WRD_PCIEX_DATA[31:0] and then:
+ * HEEP_CTRL_WRD_PCIEX_CTRL[15:0] = 0x1DC (offset of the SHR_APMG_GP1 register)
+ * HEEP_CTRL_WRD_PCIEX_CTRL[29:28] = 3 (write access)
+ */
+#define HEEP_CTRL_WRD_PCIEX_CTRL_REG	(CSR_BASE+0x0ec)
+#define HEEP_CTRL_WRD_PCIEX_DATA_REG	(CSR_BASE+0x0f4)
+
+/*
  * HBUS (Host-side Bus)
  *
  * HBUS registers are mapped directly into PCI bus space, but are used
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.c b/drivers/net/wireless/iwlwifi/iwl-io.c
index 07372f2..44cc3cf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/iwlwifi/iwl-io.c
@@ -93,14 +93,14 @@ int iwl_poll_direct_bit(struct iwl_trans *trans, u32 addr, u32 mask,
 }
 IWL_EXPORT_SYMBOL(iwl_poll_direct_bit);
 
-static inline u32 __iwl_read_prph(struct iwl_trans *trans, u32 ofs)
+u32 __iwl_read_prph(struct iwl_trans *trans, u32 ofs)
 {
 	u32 val = iwl_trans_read_prph(trans, ofs);
 	trace_iwlwifi_dev_ioread_prph32(trans->dev, ofs, val);
 	return val;
 }
 
-static inline void __iwl_write_prph(struct iwl_trans *trans, u32 ofs, u32 val)
+void __iwl_write_prph(struct iwl_trans *trans, u32 ofs, u32 val)
 {
 	trace_iwlwifi_dev_iowrite_prph32(trans->dev, ofs, val);
 	iwl_trans_write_prph(trans, ofs, val);
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.h b/drivers/net/wireless/iwlwifi/iwl-io.h
index 9e81b23..665ddd9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-io.h
@@ -70,7 +70,9 @@ u32 iwl_read_direct32(struct iwl_trans *trans, u32 reg);
 void iwl_write_direct32(struct iwl_trans *trans, u32 reg, u32 value);
 
 
+u32 __iwl_read_prph(struct iwl_trans *trans, u32 ofs);
 u32 iwl_read_prph(struct iwl_trans *trans, u32 ofs);
+void __iwl_write_prph(struct iwl_trans *trans, u32 ofs, u32 val);
 void iwl_write_prph(struct iwl_trans *trans, u32 ofs, u32 val);
 int iwl_poll_prph_bit(struct iwl_trans *trans, u32 addr,
 		      u32 bits, u32 mask, int timeout);
diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index 9c90186..5f657c5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -95,7 +95,8 @@
 #define APMG_SVR_VOLTAGE_CONFIG_BIT_MSK	(0x000001E0) /* bit 8:5 */
 #define APMG_SVR_DIGITAL_VOLTAGE_1_32		(0x00000060)
 
-#define APMG_PCIDEV_STT_VAL_L1_ACT_DIS		(0x00000800)
+#define APMG_PCIDEV_STT_VAL_PERSIST_DIS	(0x00000200)
+#define APMG_PCIDEV_STT_VAL_L1_ACT_DIS	(0x00000800)
 
 #define APMG_RTC_INT_STT_RFKILL		(0x10000000)
 
@@ -105,6 +106,26 @@
 /* Device NMI register */
 #define DEVICE_SET_NMI_REG 0x00a01c30
 
+/* Shared registers (0x0..0x3ff, via target indirect or periphery */
+#define SHR_BASE	0x00a10000
+
+/* Shared GP1 register */
+#define SHR_APMG_GP1_REG		0x01dc
+#define SHR_APMG_GP1_REG_PRPH		(SHR_BASE + SHR_APMG_GP1_REG)
+#define SHR_APMG_GP1_WF_XTAL_LP_EN	0x00000004
+#define SHR_APMG_GP1_CHICKEN_BIT_SELECT	0x80000000
+
+/* Shared DL_CFG register */
+#define SHR_APMG_DL_CFG_REG			0x01c4
+#define SHR_APMG_DL_CFG_REG_PRPH		(SHR_BASE + SHR_APMG_DL_CFG_REG)
+#define SHR_APMG_DL_CFG_RTCS_CLK_SELECTOR_MSK	0x000000c0
+#define SHR_APMG_DL_CFG_RTCS_CLK_INTERNAL_XTAL	0x00000080
+#define SHR_APMG_DL_CFG_DL_CLOCK_POWER_UP	0x00000100
+
+/* Shared APMG_XTAL_CFG register */
+#define SHR_APMG_XTAL_CFG_REG		0x1c0
+#define SHR_APMG_XTAL_CFG_XTAL_ON_REQ	0x80000000
+
 /*
  * Device reset for family 8000
  * write to bit 24 in order to reset the CPU
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 84d4712..32a5a9a 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -75,6 +75,20 @@
 #include "iwl-agn-hw.h"
 #include "internal.h"
 
+static u32 iwl_trans_pcie_read_shr(struct iwl_trans *trans, u32 reg)
+{
+	iwl_write32(trans, HEEP_CTRL_WRD_PCIEX_CTRL_REG,
+		    ((reg & 0x0000ffff) | (2 << 28)));
+	return iwl_read32(trans, HEEP_CTRL_WRD_PCIEX_DATA_REG);
+}
+
+static void iwl_trans_pcie_write_shr(struct iwl_trans *trans, u32 reg, u32 val)
+{
+	iwl_write32(trans, HEEP_CTRL_WRD_PCIEX_DATA_REG, val);
+	iwl_write32(trans, HEEP_CTRL_WRD_PCIEX_CTRL_REG,
+		    ((reg & 0x0000ffff) | (3 << 28)));
+}
+
 static void iwl_pcie_set_pwr(struct iwl_trans *trans, bool vaux)
 {
 	if (vaux && pci_pme_capable(to_pci_dev(trans->dev), PCI_D3cold))
@@ -229,6 +243,116 @@ out:
 	return ret;
 }
 
+/*
+ * Enable LP XTAL to avoid HW bug where device may consume much power if
+ * FW is not loaded after device reset. LP XTAL is disabled by default
+ * after device HW reset. Do it only if XTAL is fed by internal source.
+ * Configure device's "persistence" mode to avoid resetting XTAL again when
+ * SHRD_HW_RST occurs in S3.
+ */
+static void iwl_pcie_apm_lp_xtal_enable(struct iwl_trans *trans)
+{
+	int ret;
+	u32 apmg_gp1_reg;
+	u32 apmg_xtal_cfg_reg;
+	u32 dl_cfg_reg;
+
+	/* Force XTAL ON */
+	__iwl_trans_pcie_set_bit(trans, CSR_GP_CNTRL,
+				 CSR_GP_CNTRL_REG_FLAG_XTAL_ON);
+
+	/* Reset entire device - do controller reset (results in SHRD_HW_RST) */
+	iwl_set_bit(trans, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
+
+	udelay(10);
+
+	/*
+	 * Set "initialization complete" bit to move adapter from
+	 * D0U* --> D0A* (powered-up active) state.
+	 */
+	iwl_set_bit(trans, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
+
+	/*
+	 * Wait for clock stabilization; once stabilized, access to
+	 * device-internal resources is possible.
+	 */
+	ret = iwl_poll_bit(trans, CSR_GP_CNTRL,
+			   CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
+			   CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
+			   25000);
+	if (WARN_ON(ret < 0)) {
+		IWL_ERR(trans, "Access time out - failed to enable LP XTAL\n");
+		/* Release XTAL ON request */
+		__iwl_trans_pcie_clear_bit(trans, CSR_GP_CNTRL,
+					   CSR_GP_CNTRL_REG_FLAG_XTAL_ON);
+		return;
+	}
+
+	/*
+	 * Clear "disable persistence" to avoid LP XTAL resetting when
+	 * SHRD_HW_RST is applied in S3.
+	 */
+	iwl_clear_bits_prph(trans, APMG_PCIDEV_STT_REG,
+				    APMG_PCIDEV_STT_VAL_PERSIST_DIS);
+
+	/*
+	 * Force APMG XTAL to be active to prevent its disabling by HW
+	 * caused by APMG idle state.
+	 */
+	apmg_xtal_cfg_reg = iwl_trans_pcie_read_shr(trans,
+						    SHR_APMG_XTAL_CFG_REG);
+	iwl_trans_pcie_write_shr(trans, SHR_APMG_XTAL_CFG_REG,
+				 apmg_xtal_cfg_reg |
+				 SHR_APMG_XTAL_CFG_XTAL_ON_REQ);
+
+	/*
+	 * Reset entire device again - do controller reset (results in
+	 * SHRD_HW_RST). Turn MAC off before proceeding.
+	 */
+	iwl_set_bit(trans, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
+
+	udelay(10);
+
+	/* Enable LP XTAL by indirect access through CSR */
+	apmg_gp1_reg = iwl_trans_pcie_read_shr(trans, SHR_APMG_GP1_REG);
+	iwl_trans_pcie_write_shr(trans, SHR_APMG_GP1_REG, apmg_gp1_reg |
+				 SHR_APMG_GP1_WF_XTAL_LP_EN |
+				 SHR_APMG_GP1_CHICKEN_BIT_SELECT);
+
+	/* Clear delay line clock power up */
+	dl_cfg_reg = iwl_trans_pcie_read_shr(trans, SHR_APMG_DL_CFG_REG);
+	iwl_trans_pcie_write_shr(trans, SHR_APMG_DL_CFG_REG, dl_cfg_reg &
+				 ~SHR_APMG_DL_CFG_DL_CLOCK_POWER_UP);
+
+	/*
+	 * Enable persistence mode to avoid LP XTAL resetting when
+	 * SHRD_HW_RST is applied in S3.
+	 */
+	iwl_set_bit(trans, CSR_HW_IF_CONFIG_REG,
+		    CSR_HW_IF_CONFIG_REG_PERSIST_MODE);
+
+	/*
+	 * Clear "initialization complete" bit to move adapter from
+	 * D0A* (powered-up Active) --> D0U* (Uninitialized) state.
+	 */
+	iwl_clear_bit(trans, CSR_GP_CNTRL,
+		      CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
+
+	/* Activates XTAL resources monitor */
+	__iwl_trans_pcie_set_bit(trans, CSR_MONITOR_CFG_REG,
+				 CSR_MONITOR_XTAL_RESOURCES);
+
+	/* Release XTAL ON request */
+	__iwl_trans_pcie_clear_bit(trans, CSR_GP_CNTRL,
+				   CSR_GP_CNTRL_REG_FLAG_XTAL_ON);
+	udelay(10);
+
+	/* Release APMG XTAL */
+	iwl_trans_pcie_write_shr(trans, SHR_APMG_XTAL_CFG_REG,
+				 apmg_xtal_cfg_reg &
+				 ~SHR_APMG_XTAL_CFG_XTAL_ON_REQ);
+}
+
 static int iwl_pcie_apm_stop_master(struct iwl_trans *trans)
 {
 	int ret = 0;
@@ -256,6 +380,11 @@ static void iwl_pcie_apm_stop(struct iwl_trans *trans)
 	/* Stop device's DMA activity */
 	iwl_pcie_apm_stop_master(trans);
 
+	if (trans->cfg->lp_xtal_workaround) {
+		iwl_pcie_apm_lp_xtal_enable(trans);
+		return;
+	}
+
 	/* Reset the entire device */
 	iwl_set_bit(trans, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
 
@@ -1208,6 +1337,7 @@ static const char *get_csr_string(int cmd)
 	IWL_CMD(CSR_GIO_CHICKEN_BITS);
 	IWL_CMD(CSR_ANA_PLL_CFG);
 	IWL_CMD(CSR_HW_REV_WA_REG);
+	IWL_CMD(CSR_MONITOR_STATUS_REG);
 	IWL_CMD(CSR_DBG_HPET_MEM_REG);
 	default:
 		return "UNKNOWN";
@@ -1240,6 +1370,7 @@ void iwl_pcie_dump_csr(struct iwl_trans *trans)
 		CSR_DRAM_INT_TBL_REG,
 		CSR_GIO_CHICKEN_BITS,
 		CSR_ANA_PLL_CFG,
+		CSR_MONITOR_STATUS_REG,
 		CSR_HW_REV_WA_REG,
 		CSR_DBG_HPET_MEM_REG
 	};
-- 
1.8.3.2

