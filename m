Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:40055 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756404AbZBJXPV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2009 18:15:21 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/3] iwlwifi: use pci registers defined in pci_regs.h
Date: Tue, 10 Feb 2009 15:19:02 -0800
Message-Id: <1234307944-21820-2-git-send-email-reinette.chatre@intel.com> (sfid-20090211_001541_172285_8F00CCF7)
In-Reply-To: <1234307944-21820-1-git-send-email-reinette.chatre@intel.com>
References: <>
 <1234307944-21820-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch replaces where possible usage of pci register
defined in the driver by ones defined in pci_regs.h

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-hw.h |    6 ------
 drivers/net/wireless/iwlwifi/iwl-3945.c    |   19 ++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h |    7 -------
 drivers/net/wireless/iwlwifi/iwl-4965.c    |   23 +++++++++++++----------
 drivers/net/wireless/iwlwifi/iwl-5000.c    |   13 +++++++------
 drivers/net/wireless/iwlwifi/iwl-agn.c     |    6 +-----
 drivers/net/wireless/iwlwifi/iwl-core.h    |    8 ++++++++
 drivers/net/wireless/iwlwifi/iwl-power.c   |    6 +++---
 8 files changed, 40 insertions(+), 48 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
index 1327b2a..205603d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
@@ -229,12 +229,6 @@ struct iwl3945_eeprom {
 
 /* End of EEPROM */
 
-
-#define PCI_LINK_CTRL      0x0F0
-#define PCI_POWER_SOURCE   0x0C8
-#define PCI_REG_WUM8       0x0E8
-#define PCI_CFG_PMC_PME_FROM_D3COLD_SUPPORT         (0x80000000)
-
 #define PCI_CFG_REV_ID_BIT_BASIC_SKU                (0x40)	/* bit 6    */
 #define PCI_CFG_REV_ID_BIT_RTP                      (0x80)	/* bit 7    */
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index cb6db45..d2df494 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -905,22 +905,18 @@ u8 iwl3945_sync_sta(struct iwl_priv *priv, int sta_id, u16 tx_rate, u8 flags)
 
 static int iwl3945_set_pwr_src(struct iwl_priv *priv, enum iwl_pwr_src src)
 {
-	int rc;
+	int ret;
 	unsigned long flags;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	rc = iwl_grab_nic_access(priv);
-	if (rc) {
+	ret = iwl_grab_nic_access(priv);
+	if (ret) {
 		spin_unlock_irqrestore(&priv->lock, flags);
-		return rc;
+		return ret;
 	}
 
 	if (src == IWL_PWR_SRC_VAUX) {
-		u32 val;
-
-		rc = pci_read_config_dword(priv->pci_dev,
-				PCI_POWER_SOURCE, &val);
-		if (val & PCI_CFG_PMC_PME_FROM_D3COLD_SUPPORT) {
+		if (pci_pme_capable(priv->pci_dev, PCI_D3cold)) {
 			iwl_set_bits_mask_prph(priv, APMG_PS_CTRL_REG,
 					APMG_PS_CTRL_VAL_PWR_SRC_VAUX,
 					~APMG_PS_CTRL_MSK_PWR_SRC);
@@ -929,8 +925,9 @@ static int iwl3945_set_pwr_src(struct iwl_priv *priv, enum iwl_pwr_src src)
 			iwl_poll_bit(priv, CSR_GPIO_IN,
 				     CSR_GPIO_IN_VAL_VAUX_PWR_SRC,
 				     CSR_GPIO_IN_BIT_AUX_POWER, 5000);
-		} else
+		} else {
 			iwl_release_nic_access(priv);
+		}
 	} else {
 		iwl_set_bits_mask_prph(priv, APMG_PS_CTRL_REG,
 				APMG_PS_CTRL_VAL_PWR_SRC_VMAIN,
@@ -942,7 +939,7 @@ static int iwl3945_set_pwr_src(struct iwl_priv *priv, enum iwl_pwr_src src)
 	}
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	return rc;
+	return ret;
 }
 
 static int iwl3945_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
index af4c1bb..a71a489 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
@@ -92,19 +92,12 @@
 #define IWL49_RSSI_OFFSET	44
 
 
-
 /* PCI registers */
 #define PCI_CFG_RETRY_TIMEOUT	0x041
-#define PCI_CFG_POWER_SOURCE	0x0C8
-#define PCI_REG_WUM8		0x0E8
-#define PCI_CFG_LINK_CTRL	0x0F0
 
 /* PCI register values */
 #define PCI_CFG_LINK_CTRL_VAL_L0S_EN	0x01
 #define PCI_CFG_LINK_CTRL_VAL_L1_EN	0x02
-#define PCI_CFG_CMD_REG_INT_DIS_MSK	0x04
-#define PCI_CFG_PMC_PME_FROM_D3COLD_SUPPORT         (0x80000000)
-
 
 #define IWL_NUM_SCAN_RATES         (2)
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 0638f3e..ead947b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -381,27 +381,30 @@ out:
 static void iwl4965_nic_config(struct iwl_priv *priv)
 {
 	unsigned long flags;
-	u32 val;
+	u16 dctl;
 	u16 radio_cfg;
-	u16 link;
+	u16 lctl;
 
 	spin_lock_irqsave(&priv->lock, flags);
 
 	if ((priv->rev_id & 0x80) == 0x80 && (priv->rev_id & 0x7f) < 8) {
-		pci_read_config_dword(priv->pci_dev, PCI_REG_WUM8, &val);
+		int pos = pci_find_capability(priv->pci_dev, PCI_CAP_ID_EXP);
+		pci_read_config_word(priv->pci_dev, pos + PCI_EXP_DEVCTL, &dctl);
+
 		/* Enable No Snoop field */
-		pci_write_config_dword(priv->pci_dev, PCI_REG_WUM8,
-				       val & ~(1 << 11));
+		pci_write_config_word(priv->pci_dev, pos + PCI_EXP_DEVCTL,
+					dctl & ~PCI_EXP_DEVCTL_NOSNOOP_EN);
 	}
 
-	pci_read_config_word(priv->pci_dev, PCI_CFG_LINK_CTRL, &link);
+	lctl = iwl_pcie_link_ctl(priv);
 
-	/* L1 is enabled by BIOS */
-	if ((link & PCI_CFG_LINK_CTRL_VAL_L1_EN) == PCI_CFG_LINK_CTRL_VAL_L1_EN)
-		/* disable L0S disabled L1A enabled */
+	/* HW bug W/A - negligible power consumption */
+	/* L1-ASPM is enabled by BIOS */
+	if ((lctl & PCI_CFG_LINK_CTRL_VAL_L1_EN) == PCI_CFG_LINK_CTRL_VAL_L1_EN)
+		/* L1-ASPM enabled: disable L0S  */
 		iwl_set_bit(priv, CSR_GIO_REG, CSR_GIO_REG_VAL_L0S_ENABLED);
 	else
-		/* L0S enabled L1A disabled */
+		/* L1-ASPM disabled: enable L0S */
 		iwl_clear_bit(priv, CSR_GIO_REG, CSR_GIO_REG_VAL_L0S_ENABLED);
 
 	radio_cfg = iwl_eeprom_query16(priv, EEPROM_RADIO_CONFIG);
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index e3cba61..ab39f4a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -219,18 +219,19 @@ static void iwl5000_nic_config(struct iwl_priv *priv)
 {
 	unsigned long flags;
 	u16 radio_cfg;
-	u16 link;
+	u16 lctl;
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	pci_read_config_word(priv->pci_dev, PCI_CFG_LINK_CTRL, &link);
+	lctl = iwl_pcie_link_ctl(priv);
 
-	/* L1 is enabled by BIOS */
-	if ((link & PCI_CFG_LINK_CTRL_VAL_L1_EN) == PCI_CFG_LINK_CTRL_VAL_L1_EN)
-		/* disable L0S disabled L1A enabled */
+	/* HW bug W/A */
+	/* L1-ASPM is enabled by BIOS */
+	if ((lctl & PCI_CFG_LINK_CTRL_VAL_L1_EN) == PCI_CFG_LINK_CTRL_VAL_L1_EN)
+		/* L1-APSM enabled: disable L0S  */
 		iwl_set_bit(priv, CSR_GIO_REG, CSR_GIO_REG_VAL_L0S_ENABLED);
 	else
-		/* L0S enabled L1A disabled */
+		/* L1-ASPM disabled: enable L0S */
 		iwl_clear_bit(priv, CSR_GIO_REG, CSR_GIO_REG_VAL_L0S_ENABLED);
 
 	radio_cfg = iwl_eeprom_query16(priv, EEPROM_RADIO_CONFIG);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index c196abc..3f92d03 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -940,11 +940,7 @@ int iwl_set_pwr_src(struct iwl_priv *priv, enum iwl_pwr_src src)
 		goto err;
 
 	if (src == IWL_PWR_SRC_VAUX) {
-		u32 val;
-		ret = pci_read_config_dword(priv->pci_dev, PCI_CFG_POWER_SOURCE,
-					    &val);
-
-		if (val & PCI_CFG_PMC_PME_FROM_D3COLD_SUPPORT)
+		if (pci_pme_capable(priv->pci_dev, PCI_D3cold))
 			iwl_set_bits_mask_prph(priv, APMG_PS_CTRL_REG,
 					       APMG_PS_CTRL_VAL_PWR_SRC_VAUX,
 					       ~APMG_PS_CTRL_MSK_PWR_SRC);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index d79912b..9d464ec 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -410,6 +410,14 @@ int iwl_send_card_state(struct iwl_priv *priv, u32 flags,
  *****************************************************/
 void iwl_disable_interrupts(struct iwl_priv *priv);
 void iwl_enable_interrupts(struct iwl_priv *priv);
+static inline u16 iwl_pcie_link_ctl(struct iwl_priv *priv)
+{
+	int pos;
+	u16 pci_lnk_ctl;
+	pos = pci_find_capability(priv->pci_dev, PCI_CAP_ID_EXP);
+	pci_read_config_word(priv->pci_dev, pos + PCI_EXP_LNKCTL, &pci_lnk_ctl);
+	return pci_lnk_ctl;
+}
 
 /*****************************************************
 *  Error Handling Debugging
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 4c5a775..18b7e41 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -141,7 +141,7 @@ static void iwl_power_init_handle(struct iwl_priv *priv)
 	int size = sizeof(struct iwl_power_vec_entry) * IWL_POWER_MAX;
 	struct iwl_powertable_cmd *cmd;
 	int i;
-	u16 pci_pm;
+	u16 lctl;
 
 	IWL_DEBUG_POWER(priv, "Initialize power \n");
 
@@ -153,14 +153,14 @@ static void iwl_power_init_handle(struct iwl_priv *priv)
 	memcpy(&pow_data->pwr_range_1[0], &range_1[0], size);
 	memcpy(&pow_data->pwr_range_2[0], &range_2[0], size);
 
-	pci_read_config_word(priv->pci_dev, PCI_CFG_LINK_CTRL, &pci_pm);
+	lctl = iwl_pcie_link_ctl(priv);
 
 	IWL_DEBUG_POWER(priv, "adjust power command flags\n");
 
 	for (i = 0; i < IWL_POWER_MAX; i++) {
 		cmd = &pow_data->pwr_range_0[i].cmd;
 
-		if (pci_pm & PCI_CFG_LINK_CTRL_VAL_L0S_EN)
+		if (lctl & PCI_CFG_LINK_CTRL_VAL_L0S_EN)
 			cmd->flags &= ~IWL_POWER_PCI_PM_MSK;
 		else
 			cmd->flags |= IWL_POWER_PCI_PM_MSK;
-- 
1.5.4.3

