Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:21627 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552AbYDPXex (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Apr 2008 19:34:53 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 3/3] iwlwifi: cleanup set_pwr_src
Date: Wed, 16 Apr 2008 16:34:49 -0700
Message-Id: <1208388889-32131-4-git-send-email-reinette.chatre@intel.com> (sfid-20080417_003459_738753_5A4B9A63)
In-Reply-To: <1208388889-32131-3-git-send-email-reinette.chatre@intel.com>
References: <1208388889-32131-1-git-send-email-reinette.chatre@intel.com>
 <1208388889-32131-2-git-send-email-reinette.chatre@intel.com>
 <1208388889-32131-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch cleans up semantic of set_pwr_src
set_pwr_src is now part of apm handlers group
in iwlcore

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |   27 ++++++++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-4965.h |    5 +++++
 drivers/net/wireless/iwlwifi/iwl-core.h |    3 +++
 drivers/net/wireless/iwlwifi/iwl-csr.h  |    9 ++++-----
 4 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index f318c50..69a355b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -492,7 +492,7 @@ int iwl4965_hw_rxq_stop(struct iwl_priv *priv)
 	return 0;
 }
 
-static int iwl4965_nic_set_pwr_src(struct iwl_priv *priv, int pwr_max)
+static int iwl4965_set_pwr_src(struct iwl_priv *priv, enum iwl_pwr_src src)
 {
 	int ret;
 	unsigned long flags;
@@ -504,20 +504,21 @@ static int iwl4965_nic_set_pwr_src(struct iwl_priv *priv, int pwr_max)
 		return ret;
 	}
 
-	if (!pwr_max) {
+	if (src == IWL_PWR_SRC_VAUX) {
 		u32 val;
-
 		ret = pci_read_config_dword(priv->pci_dev, PCI_POWER_SOURCE,
-					   &val);
+					    &val);
 
-		if (val & PCI_CFG_PMC_PME_FROM_D3COLD_SUPPORT)
+		if (val & PCI_CFG_PMC_PME_FROM_D3COLD_SUPPORT) {
 			iwl_set_bits_mask_prph(priv, APMG_PS_CTRL_REG,
-				APMG_PS_CTRL_VAL_PWR_SRC_VAUX,
-				~APMG_PS_CTRL_MSK_PWR_SRC);
-	} else
+					       APMG_PS_CTRL_VAL_PWR_SRC_VAUX,
+					       ~APMG_PS_CTRL_MSK_PWR_SRC);
+		}
+	} else {
 		iwl_set_bits_mask_prph(priv, APMG_PS_CTRL_REG,
-			APMG_PS_CTRL_VAL_PWR_SRC_VMAIN,
-			~APMG_PS_CTRL_MSK_PWR_SRC);
+				       APMG_PS_CTRL_VAL_PWR_SRC_VMAIN,
+				       ~APMG_PS_CTRL_MSK_PWR_SRC);
+	}
 
 	iwl_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
@@ -747,7 +748,8 @@ int iwl4965_hw_nic_init(struct iwl_priv *priv)
 
 	IWL_DEBUG_INFO("HW Revision ID = 0x%X\n", rev_id);
 
-	iwl4965_nic_set_pwr_src(priv, 1);
+	rc = priv->cfg->ops->lib->apm_ops.set_pwr_src(priv, IWL_PWR_SRC_VMAIN);
+
 	spin_lock_irqsave(&priv->lock, flags);
 
 	if ((rev_id & 0x80) == 0x80 && (rev_id & 0x7f) < 8) {
@@ -4272,6 +4274,9 @@ static struct iwl_lib_ops iwl4965_lib = {
 	.is_valid_rtc_data_addr = iwl4965_hw_valid_rtc_data_addr,
 	.alive_notify = iwl4965_alive_notify,
 	.load_ucode = iwl4965_load_bsm,
+	.apm_ops = {
+		.set_pwr_src = iwl4965_set_pwr_src,
+	},
 	.eeprom_ops = {
 		.verify_signature  = iwlcore_eeprom_verify_signature,
 		.acquire_semaphore = iwlcore_eeprom_acquire_semaphore,
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index e4674c2..547c313 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -252,6 +252,11 @@ struct iwl4965_clip_group {
 
 /* Power management (not Tx power) structures */
 
+enum iwl_pwr_src {
+	IWL_PWR_SRC_VMAIN,
+	IWL_PWR_SRC_VAUX,
+};
+
 struct iwl4965_power_vec_entry {
 	struct iwl4965_powertable_cmd cmd;
 	u8 no_dtim;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index dcbd411..51f61fb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -115,6 +115,9 @@ struct iwl_lib_ops {
 	int (*load_ucode)(struct iwl_priv *priv);
 	/* rfkill */
 	void (*radio_kill_sw)(struct iwl_priv *priv, int disable_radio);
+	struct {
+		int (*set_pwr_src)(struct iwl_priv *priv, enum iwl_pwr_src src);
+	} apm_ops;
 	/* eeprom operations (as defined in iwl-eeprom.h) */
 	struct iwl_eeprom_ops eeprom_ops;
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index 1272579..a59f48b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -170,6 +170,10 @@
 #define CSR49_FH_INT_TX_MASK	(CSR_FH_INT_BIT_TX_CHNL1 | \
 				 CSR_FH_INT_BIT_TX_CHNL0)
 
+/* GPIO */
+#define CSR_GPIO_IN_BIT_AUX_POWER                   (0x00000200)
+#define CSR_GPIO_IN_VAL_VAUX_PWR_SRC                (0x00000000)
+#define CSR_GPIO_IN_VAL_VMAIN_PWR_SRC               (0x00000200)
 
 /* RESET */
 #define CSR_RESET_REG_FLAG_NEVO_RESET                (0x00000001)
@@ -206,11 +210,6 @@
 #define CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED           (0x00000004)
 #define CSR_UCODE_DRV_GP1_REG_BIT_CT_KILL_EXIT      (0x00000008)
 
-/* GPIO */
-#define CSR_GPIO_IN_BIT_AUX_POWER                   (0x00000200)
-#define CSR_GPIO_IN_VAL_VAUX_PWR_SRC                (0x00000000)
-#define CSR_GPIO_IN_VAL_VMAIN_PWR_SRC		CSR_GPIO_IN_BIT_AUX_POWER
-
 /* GI Chicken Bits */
 #define CSR_GIO_CHICKEN_BITS_REG_BIT_L1A_NO_L0S_RX  (0x00800000)
 #define CSR_GIO_CHICKEN_BITS_REG_BIT_DIS_L0S_EXIT_TIMER  (0x20000000)
-- 
1.5.3.4

