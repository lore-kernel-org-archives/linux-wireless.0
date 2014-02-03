Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f181.google.com ([209.85.215.181]:41711 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbaBCU6X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:58:23 -0500
Received: by mail-ea0-f181.google.com with SMTP id m10so3996660eaj.40
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:58:22 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eran Harary <eran.harary@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 04/62] iwlwifi: pcie: disable APMG configurations for family 8000
Date: Mon,  3 Feb 2014 22:57:10 +0200
Message-Id: <1391461088-8082-4-git-send-email-egrumbach@gmail.com> (sfid-20140203_215827_602121_DD73AB91)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eran Harary <eran.harary@intel.com>

APMG HW block was removed in this NIC, hence, no need to
configure it.

Signed-off-by: Eran Harary <eran.harary@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/ops.c    |    7 ++++---
 drivers/net/wireless/iwlwifi/pcie/trans.c |   27 ++++++++++++++++-----------
 drivers/net/wireless/iwlwifi/pcie/tx.c    |    5 +++--
 3 files changed, 23 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 7a2e488..f38ed9f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -185,9 +185,10 @@ static void iwl_mvm_nic_config(struct iwl_op_mode *op_mode)
 	 * (PCIe power is lost before PERST# is asserted), causing ME FW
 	 * to lose ownership and not being able to obtain it back.
 	 */
-	iwl_set_bits_mask_prph(mvm->trans, APMG_PS_CTRL_REG,
-			       APMG_PS_CTRL_EARLY_PWR_OFF_RESET_DIS,
-			       ~APMG_PS_CTRL_EARLY_PWR_OFF_RESET_DIS);
+	if (mvm->trans->cfg->device_family != IWL_DEVICE_FAMILY_8000)
+		iwl_set_bits_mask_prph(mvm->trans, APMG_PS_CTRL_REG,
+				       APMG_PS_CTRL_EARLY_PWR_OFF_RESET_DIS,
+				       ~APMG_PS_CTRL_EARLY_PWR_OFF_RESET_DIS);
 }
 
 struct iwl_rx_handlers {
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index f950780..f7e85d3 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -203,19 +203,23 @@ static int iwl_pcie_apm_init(struct iwl_trans *trans)
 	/*
 	 * Enable DMA clock and wait for it to stabilize.
 	 *
-	 * Write to "CLK_EN_REG"; "1" bits enable clocks, while "0" bits
-	 * do not disable clocks.  This preserves any hardware bits already
-	 * set by default in "CLK_CTRL_REG" after reset.
+	 * Write to "CLK_EN_REG"; "1" bits enable clocks, while "0"
+	 * bits do not disable clocks.  This preserves any hardware
+	 * bits already set by default in "CLK_CTRL_REG" after reset.
 	 */
-	iwl_write_prph(trans, APMG_CLK_EN_REG, APMG_CLK_VAL_DMA_CLK_RQT);
-	udelay(20);
+	if (trans->cfg->device_family != IWL_DEVICE_FAMILY_8000) {
+		iwl_write_prph(trans, APMG_CLK_EN_REG,
+			       APMG_CLK_VAL_DMA_CLK_RQT);
+		udelay(20);
 
-	/* Disable L1-Active */
-	iwl_set_bits_prph(trans, APMG_PCIDEV_STT_REG,
-			  APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
+		/* Disable L1-Active */
+		iwl_set_bits_prph(trans, APMG_PCIDEV_STT_REG,
+				  APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
 
-	/* Clear the interrupt in APMG if the NIC is in RFKILL */
-	iwl_write_prph(trans, APMG_RTC_INT_STT_REG, APMG_RTC_INT_STT_RFKILL);
+		/* Clear the interrupt in APMG if the NIC is in RFKILL */
+		iwl_write_prph(trans, APMG_RTC_INT_STT_REG,
+			       APMG_RTC_INT_STT_RFKILL);
+	}
 
 	set_bit(STATUS_DEVICE_ENABLED, &trans->status);
 
@@ -273,7 +277,8 @@ static int iwl_pcie_nic_init(struct iwl_trans *trans)
 
 	spin_unlock(&trans_pcie->irq_lock);
 
-	iwl_pcie_set_pwr(trans, false);
+	if (trans->cfg->device_family != IWL_DEVICE_FAMILY_8000)
+		iwl_pcie_set_pwr(trans, false);
 
 	iwl_op_mode_nic_config(trans->op_mode);
 
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 3d54900..2541264 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -705,8 +705,9 @@ void iwl_pcie_tx_start(struct iwl_trans *trans, u32 scd_base_addr)
 			   reg_val | FH_TX_CHICKEN_BITS_SCD_AUTO_RETRY_EN);
 
 	/* Enable L1-Active */
-	iwl_clear_bits_prph(trans, APMG_PCIDEV_STT_REG,
-			    APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
+	if (trans->cfg->device_family != IWL_DEVICE_FAMILY_8000)
+		iwl_clear_bits_prph(trans, APMG_PCIDEV_STT_REG,
+				    APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
 }
 
 void iwl_trans_pcie_tx_reset(struct iwl_trans *trans)
-- 
1.7.9.5

