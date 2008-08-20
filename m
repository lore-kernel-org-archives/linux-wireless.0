Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:3175 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526AbYHTCFN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Aug 2008 22:05:13 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 7/7] iwlwifi: cleanup PCI register handling
Date: Wed, 20 Aug 2008 10:01:33 +0800
Message-Id: <1219197693-21407-8-git-send-email-yi.zhu@intel.com> (sfid-20080820_040520_243477_C9560EC7)
In-Reply-To: <1219197693-21407-7-git-send-email-yi.zhu@intel.com>
References: <1219197693-21407-1-git-send-email-yi.zhu@intel.com>
 <1219197693-21407-2-git-send-email-yi.zhu@intel.com>
 <1219197693-21407-3-git-send-email-yi.zhu@intel.com>
 <1219197693-21407-4-git-send-email-yi.zhu@intel.com>
 <1219197693-21407-5-git-send-email-yi.zhu@intel.com>
 <1219197693-21407-6-git-send-email-yi.zhu@intel.com>
 <1219197693-21407-7-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch cleans up pci registers handling. It also adds some work
around for interrupt handling on some platforms.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h  |   13 +++++++------
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   17 +++++++++++++----
 drivers/net/wireless/iwlwifi/iwl-commands.h |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-power.c    |   27 +++++++++++----------------
 6 files changed, 39 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
index fce950f..f4793a6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
@@ -98,16 +98,17 @@
 #define IWL_RSSI_OFFSET	44
 
 
-#include "iwl-commands.h"
 
 /* PCI registers */
-#define PCI_LINK_CTRL      0x0F0	/* 1 byte */
-#define PCI_POWER_SOURCE   0x0C8
-#define PCI_REG_WUM8       0x0E8
+#define PCI_CFG_RETRY_TIMEOUT	0x041
+#define PCI_CFG_POWER_SOURCE	0x0C8
+#define PCI_REG_WUM8		0x0E8
+#define PCI_CFG_LINK_CTRL	0x0F0
 
 /* PCI register values */
-#define PCI_LINK_VAL_L0S_EN	0x01
-#define PCI_LINK_VAL_L1_EN	0x02
+#define PCI_CFG_LINK_CTRL_VAL_L0S_EN	0x01
+#define PCI_CFG_LINK_CTRL_VAL_L1_EN	0x02
+#define PCI_CFG_CMD_REG_INT_DIS_MSK	0x04
 #define PCI_CFG_PMC_PME_FROM_D3COLD_SUPPORT         (0x80000000)
 
 #define TFD_QUEUE_SIZE_MAX      (256)
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 22bb269..aba173d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -400,7 +400,7 @@ static void iwl4965_nic_config(struct iwl_priv *priv)
 	unsigned long flags;
 	u32 val;
 	u16 radio_cfg;
-	u8 val_link;
+	u16 link;
 
 	spin_lock_irqsave(&priv->lock, flags);
 
@@ -411,10 +411,10 @@ static void iwl4965_nic_config(struct iwl_priv *priv)
 				       val & ~(1 << 11));
 	}
 
-	pci_read_config_byte(priv->pci_dev, PCI_LINK_CTRL, &val_link);
+	pci_read_config_word(priv->pci_dev, PCI_CFG_LINK_CTRL, &link);
 
 	/* L1 is enabled by BIOS */
-	if ((val_link & PCI_LINK_VAL_L1_EN) == PCI_LINK_VAL_L1_EN)
+	if ((link & PCI_CFG_LINK_CTRL_VAL_L1_EN) == PCI_CFG_LINK_CTRL_VAL_L1_EN)
 		/* diable L0S disabled L1A enabled */
 		iwl_set_bit(priv, CSR_GIO_REG, CSR_GIO_REG_VAL_L0S_ENABLED);
 	else
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index f3d139b..f194447 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -209,14 +209,14 @@ static void iwl5000_nic_config(struct iwl_priv *priv)
 {
 	unsigned long flags;
 	u16 radio_cfg;
-	u8 val_link;
+	u16 link;
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	pci_read_config_byte(priv->pci_dev, PCI_LINK_CTRL, &val_link);
+	pci_read_config_word(priv->pci_dev, PCI_CFG_LINK_CTRL, &link);
 
 	/* L1 is enabled by BIOS */
-	if ((val_link & PCI_LINK_VAL_L1_EN) == PCI_LINK_VAL_L1_EN)
+	if ((link & PCI_CFG_LINK_CTRL_VAL_L1_EN) == PCI_CFG_LINK_CTRL_VAL_L1_EN)
 		/* diable L0S disabled L1A enabled */
 		iwl_set_bit(priv, CSR_GIO_REG, CSR_GIO_REG_VAL_L0S_ENABLED);
 	else
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 9c18b2f..11f8cc2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1273,7 +1273,7 @@ int iwl4965_set_pwr_src(struct iwl_priv *priv, enum iwl_pwr_src src)
 
 	if (src == IWL_PWR_SRC_VAUX) {
 		u32 val;
-		ret = pci_read_config_dword(priv->pci_dev, PCI_POWER_SOURCE,
+		ret = pci_read_config_dword(priv->pci_dev, PCI_CFG_POWER_SOURCE,
 					    &val);
 
 		if (val & PCI_CFG_PMC_PME_FROM_D3COLD_SUPPORT)
@@ -2602,6 +2602,7 @@ static int iwl4965_mac_start(struct ieee80211_hw *hw)
 {
 	struct iwl_priv *priv = hw->priv;
 	int ret;
+	u16 pci_cmd;
 
 	IWL_DEBUG_MAC80211("enter\n");
 
@@ -2612,6 +2613,13 @@ static int iwl4965_mac_start(struct ieee80211_hw *hw)
 	pci_restore_state(priv->pci_dev);
 	pci_enable_msi(priv->pci_dev);
 
+	/* enable interrupts if needed: hw bug w/a */
+	pci_read_config_word(priv->pci_dev, PCI_COMMAND, &pci_cmd);
+	if (pci_cmd & PCI_COMMAND_INTX_DISABLE) {
+		pci_cmd &= ~PCI_COMMAND_INTX_DISABLE;
+		pci_write_config_word(priv->pci_dev, PCI_COMMAND, pci_cmd);
+	}
+
 	ret = request_irq(priv->pci_dev->irq, iwl4965_isr, IRQF_SHARED,
 			  DRV_NAME, priv);
 	if (ret) {
@@ -4216,9 +4224,6 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 
 	pci_set_drvdata(pdev, priv);
 
-	/* We disable the RETRY_TIMEOUT register (0x41) to keep
-	 * PCI Tx retries from interfering with C3 CPU state */
-	pci_write_config_byte(pdev, 0x41, 0x00);
 
 	/***********************
 	 * 3. Read REV register
@@ -4238,6 +4243,10 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 		": Detected Intel Wireless WiFi Link %s REV=0x%X\n",
 		priv->cfg->name, priv->hw_rev);
 
+	/* We disable the RETRY_TIMEOUT register (0x41) to keep
+	 * PCI Tx retries from interfering with C3 CPU state */
+	pci_write_config_byte(pdev, PCI_CFG_RETRY_TIMEOUT, 0x00);
+
 	/* amp init */
 	err = priv->cfg->ops->lib->apm_ops.init(priv);
 	if (err < 0) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 28b5b09..fbd8cc1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -2026,8 +2026,8 @@ struct iwl4965_spectrum_notification {
  *   bit 2 - '0' PM have to walk up every DTIM
  *           '1' PM could sleep over DTIM till listen Interval.
  * PCI power managed
- *   bit 3 - '0' (PCI_LINK_CTRL & 0x1)
- *           '1' !(PCI_LINK_CTRL & 0x1)
+ *   bit 3 - '0' (PCI_CFG_LINK_CTRL & 0x1)
+ *           '1' !(PCI_CFG_LINK_CTRL & 0x1)
  * Force sleep Modes
  *   bit 31/30- '00' use both mac/xtal sleeps
  *              '01' force Mac sleep
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 028e305..a464ed4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -153,9 +153,10 @@ static u16 iwl_get_auto_power_mode(struct iwl_priv *priv)
 /* initialize to default */
 static int iwl_power_init_handle(struct iwl_priv *priv)
 {
-	int ret = 0, i;
 	struct iwl_power_mgr *pow_data;
 	int size = sizeof(struct iwl_power_vec_entry) * IWL_POWER_MAX;
+	struct iwl_powertable_cmd *cmd;
+	int i;
 	u16 pci_pm;
 
 	IWL_DEBUG_POWER("Initialize power \n");
@@ -168,25 +169,19 @@ static int iwl_power_init_handle(struct iwl_priv *priv)
 	memcpy(&pow_data->pwr_range_1[0], &range_1[0], size);
 	memcpy(&pow_data->pwr_range_2[0], &range_2[0], size);
 
-	ret = pci_read_config_word(priv->pci_dev,
-				  PCI_LINK_CTRL, &pci_pm);
-	if (ret != 0)
-		return 0;
-	else {
-		struct iwl_powertable_cmd *cmd;
+	pci_read_config_word(priv->pci_dev, PCI_CFG_LINK_CTRL, &pci_pm);
 
-		IWL_DEBUG_POWER("adjust power command flags\n");
+	IWL_DEBUG_POWER("adjust power command flags\n");
 
-		for (i = 0; i < IWL_POWER_MAX; i++) {
-			cmd = &pow_data->pwr_range_0[i].cmd;
+	for (i = 0; i < IWL_POWER_MAX; i++) {
+		cmd = &pow_data->pwr_range_0[i].cmd;
 
-			if (pci_pm & 0x1)
-				cmd->flags &= ~IWL_POWER_PCI_PM_MSK;
-			else
-				cmd->flags |= IWL_POWER_PCI_PM_MSK;
-		}
+		if (pci_pm & PCI_CFG_LINK_CTRL_VAL_L0S_EN)
+			cmd->flags &= ~IWL_POWER_PCI_PM_MSK;
+		else
+			cmd->flags |= IWL_POWER_PCI_PM_MSK;
 	}
-	return ret;
+	return 0;
 }
 
 /* adjust power command according to dtim period and power level*/
-- 
1.5.3.6

