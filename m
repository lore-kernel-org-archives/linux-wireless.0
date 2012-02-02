Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:7687 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755210Ab2BCAQx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 19:16:53 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 13/28] iwlwifi: move apm_init to start_hw
Date: Thu,  2 Feb 2012 15:09:04 -0800
Message-Id: <1328224159-18134-14-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120203_011755_096866_9CEB6BB3)
In-Reply-To: <1328224159-18134-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1328224159-18134-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This is transport related

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c        |    2 -
 drivers/net/wireless/iwlwifi/iwl-core.c       |   85 ------------------------
 drivers/net/wireless/iwlwifi/iwl-shared.h     |    1 -
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |   88 ++++++++++++++++++++++++-
 4 files changed, 87 insertions(+), 89 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 5ab7f68..3aeaa89 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1836,8 +1836,6 @@ int iwl_probe(struct iwl_bus *bus, const struct iwl_trans_ops *trans_ops,
 	/*****************
 	 * 4. Read EEPROM
 	 *****************/
-	/* switch the NIC on before accessing the EEPROM */
-	iwl_apm_init(priv);
 	/* Read the EEPROM */
 	err = iwl_eeprom_init(priv, hw_rev);
 	/* Reset chip to save power until we load uCode during "up". */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index c9022c5..3ba59fa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -923,91 +923,6 @@ void iwl_apm_stop(struct iwl_priv *priv)
 		      CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
 }
 
-
-/*
- * Start up NIC's basic functionality after it has been reset
- * (e.g. after platform boot, or shutdown via iwl_apm_stop())
- * NOTE:  This does not load uCode nor start the embedded processor
- */
-int iwl_apm_init(struct iwl_priv *priv)
-{
-	int ret = 0;
-	IWL_DEBUG_INFO(priv, "Init card's basic functions\n");
-
-	/*
-	 * Use "set_bit" below rather than "write", to preserve any hardware
-	 * bits already set by default after reset.
-	 */
-
-	/* Disable L0S exit timer (platform NMI Work/Around) */
-	iwl_set_bit(trans(priv), CSR_GIO_CHICKEN_BITS,
-			  CSR_GIO_CHICKEN_BITS_REG_BIT_DIS_L0S_EXIT_TIMER);
-
-	/*
-	 * Disable L0s without affecting L1;
-	 *  don't wait for ICH L0s (ICH bug W/A)
-	 */
-	iwl_set_bit(trans(priv), CSR_GIO_CHICKEN_BITS,
-			  CSR_GIO_CHICKEN_BITS_REG_BIT_L1A_NO_L0S_RX);
-
-	/* Set FH wait threshold to maximum (HW error during stress W/A) */
-	iwl_set_bit(trans(priv), CSR_DBG_HPET_MEM_REG,
-		    CSR_DBG_HPET_MEM_REG_VAL);
-
-	/*
-	 * Enable HAP INTA (interrupt from management bus) to
-	 * wake device's PCI Express link L1a -> L0s
-	 */
-	iwl_set_bit(trans(priv), CSR_HW_IF_CONFIG_REG,
-				    CSR_HW_IF_CONFIG_REG_BIT_HAP_WAKE_L1A);
-
-	bus_apm_config(bus(priv));
-
-	/* Configure analog phase-lock-loop before activating to D0A */
-	if (cfg(priv)->base_params->pll_cfg_val)
-		iwl_set_bit(trans(priv), CSR_ANA_PLL_CFG,
-			    cfg(priv)->base_params->pll_cfg_val);
-
-	/*
-	 * Set "initialization complete" bit to move adapter from
-	 * D0U* --> D0A* (powered-up active) state.
-	 */
-	iwl_set_bit(trans(priv), CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
-
-	/*
-	 * Wait for clock stabilization; once stabilized, access to
-	 * device-internal resources is supported, e.g. iwl_write_prph()
-	 * and accesses to uCode SRAM.
-	 */
-	ret = iwl_poll_bit(trans(priv), CSR_GP_CNTRL,
-			CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
-			CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
-	if (ret < 0) {
-		IWL_DEBUG_INFO(priv, "Failed to init the card\n");
-		goto out;
-	}
-
-	/*
-	 * Enable DMA clock and wait for it to stabilize.
-	 *
-	 * Write to "CLK_EN_REG"; "1" bits enable clocks, while "0" bits
-	 * do not disable clocks.  This preserves any hardware bits already
-	 * set by default in "CLK_CTRL_REG" after reset.
-	 */
-	iwl_write_prph(trans(priv), APMG_CLK_EN_REG, APMG_CLK_VAL_DMA_CLK_RQT);
-	udelay(20);
-
-	/* Disable L1-Active */
-	iwl_set_bits_prph(trans(priv), APMG_PCIDEV_STT_REG,
-			  APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
-
-	set_bit(STATUS_DEVICE_ENABLED, &priv->shrd->status);
-
-out:
-	return ret;
-}
-
-
 int iwl_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force)
 {
 	int ret;
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 04975b7..338a55f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -544,7 +544,6 @@ void iwl_set_hw_rfkill_state(struct iwl_priv *priv, bool state);
 void iwl_nic_config(struct iwl_priv *priv);
 void iwl_free_skb(struct iwl_priv *priv, struct sk_buff *skb);
 void iwl_apm_stop(struct iwl_priv *priv);
-int iwl_apm_init(struct iwl_priv *priv);
 void iwlagn_fw_error(struct iwl_priv *priv, bool ondemand);
 const char *get_cmd_string(u8 cmd);
 bool iwl_check_for_ct_kill(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index d1ab57a..335d4b1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -74,6 +74,7 @@
 #include "iwl-shared.h"
 #include "iwl-eeprom.h"
 #include "iwl-agn-hw.h"
+#include "iwl-core.h"
 
 static int iwl_trans_rx_alloc(struct iwl_trans *trans)
 {
@@ -631,13 +632,95 @@ static void iwl_set_pwr_vmain(struct iwl_trans *trans)
 			       ~APMG_PS_CTRL_MSK_PWR_SRC);
 }
 
+/*
+ * Start up NIC's basic functionality after it has been reset
+ * (e.g. after platform boot, or shutdown via iwl_apm_stop())
+ * NOTE:  This does not load uCode nor start the embedded processor
+ */
+static int iwl_apm_init(struct iwl_trans *trans)
+{
+	int ret = 0;
+	IWL_DEBUG_INFO(trans, "Init card's basic functions\n");
+
+	/*
+	 * Use "set_bit" below rather than "write", to preserve any hardware
+	 * bits already set by default after reset.
+	 */
+
+	/* Disable L0S exit timer (platform NMI Work/Around) */
+	iwl_set_bit(trans, CSR_GIO_CHICKEN_BITS,
+			  CSR_GIO_CHICKEN_BITS_REG_BIT_DIS_L0S_EXIT_TIMER);
+
+	/*
+	 * Disable L0s without affecting L1;
+	 *  don't wait for ICH L0s (ICH bug W/A)
+	 */
+	iwl_set_bit(trans, CSR_GIO_CHICKEN_BITS,
+			  CSR_GIO_CHICKEN_BITS_REG_BIT_L1A_NO_L0S_RX);
+
+	/* Set FH wait threshold to maximum (HW error during stress W/A) */
+	iwl_set_bit(trans, CSR_DBG_HPET_MEM_REG, CSR_DBG_HPET_MEM_REG_VAL);
+
+	/*
+	 * Enable HAP INTA (interrupt from management bus) to
+	 * wake device's PCI Express link L1a -> L0s
+	 */
+	iwl_set_bit(trans, CSR_HW_IF_CONFIG_REG,
+				    CSR_HW_IF_CONFIG_REG_BIT_HAP_WAKE_L1A);
+
+	bus_apm_config(bus(trans));
+
+	/* Configure analog phase-lock-loop before activating to D0A */
+	if (cfg(trans)->base_params->pll_cfg_val)
+		iwl_set_bit(trans, CSR_ANA_PLL_CFG,
+			    cfg(trans)->base_params->pll_cfg_val);
+
+	/*
+	 * Set "initialization complete" bit to move adapter from
+	 * D0U* --> D0A* (powered-up active) state.
+	 */
+	iwl_set_bit(trans, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
+
+	/*
+	 * Wait for clock stabilization; once stabilized, access to
+	 * device-internal resources is supported, e.g. iwl_write_prph()
+	 * and accesses to uCode SRAM.
+	 */
+	ret = iwl_poll_bit(trans, CSR_GP_CNTRL,
+			CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
+			CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
+	if (ret < 0) {
+		IWL_DEBUG_INFO(trans, "Failed to init the card\n");
+		goto out;
+	}
+
+	/*
+	 * Enable DMA clock and wait for it to stabilize.
+	 *
+	 * Write to "CLK_EN_REG"; "1" bits enable clocks, while "0" bits
+	 * do not disable clocks.  This preserves any hardware bits already
+	 * set by default in "CLK_CTRL_REG" after reset.
+	 */
+	iwl_write_prph(trans, APMG_CLK_EN_REG, APMG_CLK_VAL_DMA_CLK_RQT);
+	udelay(20);
+
+	/* Disable L1-Active */
+	iwl_set_bits_prph(trans, APMG_PCIDEV_STT_REG,
+			  APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
+
+	set_bit(STATUS_DEVICE_ENABLED, &trans->shrd->status);
+
+out:
+	return ret;
+}
+
 static int iwl_nic_init(struct iwl_trans *trans)
 {
 	unsigned long flags;
 
 	/* nic_init */
 	spin_lock_irqsave(&trans->shrd->lock, flags);
-	iwl_apm_init(priv(trans));
+	iwl_apm_init(trans);
 
 	/* Set interrupt coalescing calibration timer to default (512 usecs) */
 	iwl_write8(trans, CSR_INT_COALESCING,
@@ -1267,6 +1350,9 @@ static int iwl_trans_pcie_start_hw(struct iwl_trans *trans)
 		IWL_ERR(trans, "Error while preparing HW: %d", err);
 		goto error;
 	}
+
+	iwl_apm_init(trans);
+
 	return err;
 
 error:
-- 
1.7.0.4

