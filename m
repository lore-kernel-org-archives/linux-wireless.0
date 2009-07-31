Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:24719 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845AbZGaV2K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 17:28:10 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/4] iwlwifi: Distinguish power amplifier for 6000 series
Date: Fri, 31 Jul 2009 14:28:07 -0700
Message-Id: <1249075689-8973-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1249075689-8973-1-git-send-email-reinette.chatre@intel.com>
References: <1249075689-8973-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

For 6x00 2x2 NIC, two types of Power Amplifier are available.
In order for uCode to apply correct tx power,
driver needs to program the CSR_GP_DRIVER_REG register and
let uCode know the type of PA.
If driver do not program CSR_GP_DRIVER_REG register (default to 0),
then it is uCode's decision for tx power

2x2 Hybrid card: use both internal and external PA
2x2 IPA(Internal Power Amplifier) card: internal PA only

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c |   14 ++++++++-
 drivers/net/wireless/iwlwifi/iwl-5000.c |    8 +----
 drivers/net/wireless/iwlwifi/iwl-6000.c |   50 +++++++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-agn.c  |    8 +++--
 drivers/net/wireless/iwlwifi/iwl-core.h |    3 ++
 drivers/net/wireless/iwlwifi/iwl-csr.h  |   10 +++++-
 drivers/net/wireless/iwlwifi/iwl-dev.h  |   16 +++++++++-
 7 files changed, 94 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 5f7c520..cf3fbc6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -73,6 +73,18 @@ static void iwl1000_set_ct_threshold(struct iwl_priv *priv)
 	priv->hw_params.ct_kill_exit_threshold = CT_KILL_EXIT_THRESHOLD;
 }
 
+/* NIC configuration for 1000 series */
+static void iwl1000_nic_config(struct iwl_priv *priv)
+{
+	iwl5000_nic_config(priv);
+
+	/* Setting digital SVR for 1000 card to 1.32V */
+	/* locking is acquired in iwl_set_bits_mask_prph() function */
+	iwl_set_bits_mask_prph(priv, APMG_DIGITAL_SVR_REG,
+				APMG_SVR_DIGITAL_VOLTAGE_1_32,
+				~APMG_SVR_VOLTAGE_CONFIG_BIT_MSK);
+}
+
 static struct iwl_lib_ops iwl1000_lib = {
 	.set_hw_params = iwl5000_hw_set_hw_params,
 	.txq_update_byte_cnt_tbl = iwl5000_txq_update_byte_cnt_tbl,
@@ -95,7 +107,7 @@ static struct iwl_lib_ops iwl1000_lib = {
 		.init =	iwl5000_apm_init,
 		.reset = iwl5000_apm_reset,
 		.stop = iwl5000_apm_stop,
-		.config = iwl5000_nic_config,
+		.config = iwl1000_nic_config,
 		.set_pwr_src = iwl_set_pwr_src,
 	},
 	.eeprom_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index ddd64fe..87957c0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -198,6 +198,7 @@ out:
 }
 
 
+/* NIC configuration for 5000 series and up */
 void iwl5000_nic_config(struct iwl_priv *priv)
 {
 	unsigned long flags;
@@ -239,18 +240,11 @@ void iwl5000_nic_config(struct iwl_priv *priv)
 				APMG_PS_CTRL_EARLY_PWR_OFF_RESET_DIS,
 				~APMG_PS_CTRL_EARLY_PWR_OFF_RESET_DIS);
 
-	if ((priv->hw_rev & CSR_HW_REV_TYPE_MSK) == CSR_HW_REV_TYPE_1000) {
-		/* Setting digital SVR for 1000 card to 1.32V */
-		iwl_set_bits_mask_prph(priv, APMG_DIGITAL_SVR_REG,
-					APMG_SVR_DIGITAL_VOLTAGE_1_32,
-					~APMG_SVR_VOLTAGE_CONFIG_BIT_MSK);
-	}
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
 
-
 /*
  * EEPROM
  */
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 59ff735..052a704 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -68,6 +68,24 @@ static void iwl6000_set_ct_threshold(struct iwl_priv *priv)
 	priv->hw_params.ct_kill_exit_threshold = CT_KILL_EXIT_THRESHOLD;
 }
 
+/* NIC configuration for 6000 series */
+static void iwl6000_nic_config(struct iwl_priv *priv)
+{
+	iwl5000_nic_config(priv);
+
+	/* no locking required for register write */
+	if (priv->cfg->pa_type == IWL_PA_HYBRID) {
+		/* 2x2 hybrid phy type */
+		iwl_write32(priv, CSR_GP_DRIVER_REG,
+			     CSR_GP_DRIVER_REG_BIT_RADIO_SKU_2x2_HYB);
+	} else if (priv->cfg->pa_type == IWL_PA_INTERNAL) {
+		/* 2x2 IPA phy type */
+		iwl_write32(priv, CSR_GP_DRIVER_REG,
+			     CSR_GP_DRIVER_REG_BIT_RADIO_SKU_2x2_IPA);
+	}
+	/* else do nothing, uCode configured */
+}
+
 static struct iwl_lib_ops iwl6000_lib = {
 	.set_hw_params = iwl5000_hw_set_hw_params,
 	.txq_update_byte_cnt_tbl = iwl5000_txq_update_byte_cnt_tbl,
@@ -90,7 +108,7 @@ static struct iwl_lib_ops iwl6000_lib = {
 		.init =	iwl5000_apm_init,
 		.reset = iwl5000_apm_reset,
 		.stop = iwl5000_apm_stop,
-		.config = iwl5000_nic_config,
+		.config = iwl6000_nic_config,
 		.set_pwr_src = iwl_set_pwr_src,
 	},
 	.eeprom_ops = {
@@ -146,9 +164,13 @@ struct iwl_cfg iwl6000_2ag_cfg = {
 	.valid_tx_ant = ANT_BC,
 	.valid_rx_ant = ANT_BC,
 	.need_pll_cfg = false,
+	.pa_type = IWL_PA_SYSTEM,
 };
 
-struct iwl_cfg iwl6000_2agn_cfg = {
+/*
+ * "h": Hybrid configuration, use both internal and external Power Amplifier
+ */
+struct iwl_cfg iwl6000h_2agn_cfg = {
 	.name = "6000 Series 2x2 AGN",
 	.fw_name_pre = IWL6000_FW_PRE,
 	.ucode_api_max = IWL6000_UCODE_API_MAX,
@@ -162,6 +184,27 @@ struct iwl_cfg iwl6000_2agn_cfg = {
 	.valid_tx_ant = ANT_AB,
 	.valid_rx_ant = ANT_AB,
 	.need_pll_cfg = false,
+	.pa_type = IWL_PA_HYBRID,
+};
+
+/*
+ * "i": Internal configuration, use internal Power Amplifier
+ */
+struct iwl_cfg iwl6000i_2agn_cfg = {
+	.name = "6000 Series 2x2 AGN",
+	.fw_name_pre = IWL6000_FW_PRE,
+	.ucode_api_max = IWL6000_UCODE_API_MAX,
+	.ucode_api_min = IWL6000_UCODE_API_MIN,
+	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
+	.ops = &iwl6000_ops,
+	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
+	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
+	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
+	.mod_params = &iwl50_mod_params,
+	.valid_tx_ant = ANT_BC,
+	.valid_rx_ant = ANT_BC,
+	.need_pll_cfg = false,
+	.pa_type = IWL_PA_INTERNAL,
 };
 
 struct iwl_cfg iwl6050_2agn_cfg = {
@@ -178,6 +221,7 @@ struct iwl_cfg iwl6050_2agn_cfg = {
 	.valid_tx_ant = ANT_AB,
 	.valid_rx_ant = ANT_AB,
 	.need_pll_cfg = false,
+	.pa_type = IWL_PA_SYSTEM,
 };
 
 struct iwl_cfg iwl6000_3agn_cfg = {
@@ -194,6 +238,7 @@ struct iwl_cfg iwl6000_3agn_cfg = {
 	.valid_tx_ant = ANT_ABC,
 	.valid_rx_ant = ANT_ABC,
 	.need_pll_cfg = false,
+	.pa_type = IWL_PA_SYSTEM,
 };
 
 struct iwl_cfg iwl6050_3agn_cfg = {
@@ -210,6 +255,7 @@ struct iwl_cfg iwl6050_3agn_cfg = {
 	.valid_tx_ant = ANT_ABC,
 	.valid_rx_ant = ANT_ABC,
 	.need_pll_cfg = false,
+	.pa_type = IWL_PA_SYSTEM,
 };
 
 MODULE_FIRMWARE(IWL6000_MODULE_FIRMWARE(IWL6000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 4cb1a1b..a54330b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3142,11 +3142,13 @@ static struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x0082, 0x1102, iwl6000_2ag_cfg)},
 	{IWL_PCI_DEVICE(0x0085, 0x1112, iwl6000_2ag_cfg)},
 	{IWL_PCI_DEVICE(0x0082, 0x1122, iwl6000_2ag_cfg)},
+	{IWL_PCI_DEVICE(0x008D, PCI_ANY_ID, iwl6000h_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x008E, PCI_ANY_ID, iwl6000h_2agn_cfg)},
 	{IWL_PCI_DEVICE(0x422B, PCI_ANY_ID, iwl6000_3agn_cfg)},
-	{IWL_PCI_DEVICE(0x422C, PCI_ANY_ID, iwl6000_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x422C, PCI_ANY_ID, iwl6000i_2agn_cfg)},
 	{IWL_PCI_DEVICE(0x4238, PCI_ANY_ID, iwl6000_3agn_cfg)},
-	{IWL_PCI_DEVICE(0x4239, PCI_ANY_ID, iwl6000_2agn_cfg)},
-	{IWL_PCI_DEVICE(0x0082, PCI_ANY_ID, iwl6000_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x4239, PCI_ANY_ID, iwl6000i_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x0082, PCI_ANY_ID, iwl6000h_2agn_cfg)},
 	{IWL_PCI_DEVICE(0x0085, PCI_ANY_ID, iwl6000_3agn_cfg)},
 	{IWL_PCI_DEVICE(0x0086, PCI_ANY_ID, iwl6050_3agn_cfg)},
 	{IWL_PCI_DEVICE(0x0087, PCI_ANY_ID, iwl6050_2agn_cfg)},
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index febcf76..10ddcdd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -206,6 +206,7 @@ struct iwl_mod_params {
  * 	filename is constructed as fw_name_pre<api>.ucode.
  * @ucode_api_max: Highest version of uCode API supported by driver.
  * @ucode_api_min: Lowest version of uCode API supported by driver.
+ * @pa_type: used by 6000 series only to identify the type of Power Amplifier
  *
  * We enable the driver to be backward compatible wrt API version. The
  * driver specifies which APIs it supports (with @ucode_api_max being the
@@ -226,6 +227,7 @@ struct iwl_mod_params {
  * iwl_hcmd_utils_ops etc. we accommodate different command structures
  * and flows between hardware versions (4965/5000) as well as their API
  * versions.
+ *
  */
 struct iwl_cfg {
 	const char *name;
@@ -242,6 +244,7 @@ struct iwl_cfg {
 	u8   valid_rx_ant;
 	bool need_pll_cfg;
 	bool use_isr_legacy;
+	enum iwl_pa_type pa_type;
 };
 
 /***************************
diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index f03dae1..06437d1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -91,7 +91,8 @@
 #define CSR_EEPROM_GP           (CSR_BASE+0x030)
 #define CSR_OTP_GP_REG   	(CSR_BASE+0x034)
 #define CSR_GIO_REG		(CSR_BASE+0x03C)
-#define CSR_GP_UCODE		(CSR_BASE+0x044)
+#define CSR_GP_UCODE_REG	(CSR_BASE+0x048)
+#define CSR_GP_DRIVER_REG	(CSR_BASE+0x050)
 #define CSR_UCODE_DRV_GP1       (CSR_BASE+0x054)
 #define CSR_UCODE_DRV_GP1_SET   (CSR_BASE+0x058)
 #define CSR_UCODE_DRV_GP1_CLR   (CSR_BASE+0x05c)
@@ -245,6 +246,13 @@
 #define CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED           (0x00000004)
 #define CSR_UCODE_DRV_GP1_REG_BIT_CT_KILL_EXIT      (0x00000008)
 
+/* GP Driver */
+#define CSR_GP_DRIVER_REG_BIT_RADIO_SKU_MSK	    (0x00000003)
+#define CSR_GP_DRIVER_REG_BIT_RADIO_SKU_3x3_HYB	    (0x00000000)
+#define CSR_GP_DRIVER_REG_BIT_RADIO_SKU_2x2_HYB	    (0x00000001)
+#define CSR_GP_DRIVER_REG_BIT_RADIO_SKU_2x2_IPA	    (0x00000002)
+
+
 /* GI Chicken Bits */
 #define CSR_GIO_CHICKEN_BITS_REG_BIT_L1A_NO_L0S_RX  (0x00800000)
 #define CSR_GIO_CHICKEN_BITS_REG_BIT_DIS_L0S_EXIT_TIMER  (0x20000000)
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 0ee3ad2..335a8f3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -57,7 +57,8 @@ extern struct iwl_cfg iwl5100_bg_cfg;
 extern struct iwl_cfg iwl5100_abg_cfg;
 extern struct iwl_cfg iwl5150_agn_cfg;
 extern struct iwl_cfg iwl6000_2ag_cfg;
-extern struct iwl_cfg iwl6000_2agn_cfg;
+extern struct iwl_cfg iwl6000h_2agn_cfg;
+extern struct iwl_cfg iwl6000i_2agn_cfg;
 extern struct iwl_cfg iwl6000_3agn_cfg;
 extern struct iwl_cfg iwl6050_2agn_cfg;
 extern struct iwl_cfg iwl6050_3agn_cfg;
@@ -888,6 +889,19 @@ enum iwl_nvm_type {
 	NVM_DEVICE_TYPE_OTP,
 };
 
+
+/**
+ * enum iwl_pa_type - Power Amplifier type
+ * @IWL_PA_SYSTEM:  based on uCode configuration
+ * @IWL_PA_HYBRID: use both Internal and external PA
+ * @IWL_PA_INTERNAL: use Internal only
+ */
+enum iwl_pa_type {
+	IWL_PA_SYSTEM = 0,
+	IWL_PA_HYBRID = 1,
+	IWL_PA_INTERNAL = 2,
+};
+
 /* interrupt statistics */
 struct isr_statistics {
 	u32 hw;
-- 
1.5.6.3

