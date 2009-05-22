Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:25545 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757660AbZEVRzW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2009 13:55:22 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 09/10] iwlagn: co-exist with AMT
Date: Fri, 22 May 2009 11:01:54 -0700
Message-Id: <1243015315-13848-10-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1243015315-13848-9-git-send-email-reinette.chatre@intel.com>
References: <1243015315-13848-1-git-send-email-reinette.chatre@intel.com>
 <1243015315-13848-2-git-send-email-reinette.chatre@intel.com>
 <1243015315-13848-3-git-send-email-reinette.chatre@intel.com>
 <1243015315-13848-4-git-send-email-reinette.chatre@intel.com>
 <1243015315-13848-5-git-send-email-reinette.chatre@intel.com>
 <1243015315-13848-6-git-send-email-reinette.chatre@intel.com>
 <1243015315-13848-7-git-send-email-reinette.chatre@intel.com>
 <1243015315-13848-8-git-send-email-reinette.chatre@intel.com>
 <1243015315-13848-9-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohamed Abbas <mohamed.abbas@intel.com>

 Enable using iwlwifi driver in AMT system.

Signed-off-by: Mohamed Abbas <mohamed.abbas@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |   56 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-csr.h |    6 ++--
 drivers/net/wireless/iwlwifi/iwl-dev.h |    2 +-
 3 files changed, 60 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 889574d..0a5507c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1792,6 +1792,49 @@ static void iwl_down(struct iwl_priv *priv)
 	iwl_cancel_deferred_work(priv);
 }
 
+#define HW_READY_TIMEOUT (50)
+
+static int iwl_set_hw_ready(struct iwl_priv *priv)
+{
+	int ret = 0;
+
+	iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
+		CSR_HW_IF_CONFIG_REG_BIT_NIC_READY);
+
+	/* See if we got it */
+	ret = iwl_poll_bit(priv, CSR_HW_IF_CONFIG_REG,
+				CSR_HW_IF_CONFIG_REG_BIT_NIC_READY,
+				CSR_HW_IF_CONFIG_REG_BIT_NIC_READY,
+				HW_READY_TIMEOUT);
+	if (ret != -ETIMEDOUT)
+		priv->hw_ready = true;
+	else
+		priv->hw_ready = false;
+
+	IWL_DEBUG_INFO(priv, "hardware %s\n",
+		      (priv->hw_ready == 1) ? "ready" : "not ready");
+	return ret;
+}
+
+static int iwl_prepare_card_hw(struct iwl_priv *priv)
+{
+	int ret = 0;
+
+	IWL_DEBUG_INFO(priv, "iwl_prepare_card_hw enter \n");
+
+	iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
+			CSR_HW_IF_CONFIG_REG_PREPARE);
+
+	ret = iwl_poll_bit(priv, CSR_HW_IF_CONFIG_REG,
+			~CSR_HW_IF_CONFIG_REG_BIT_NIC_PREPARE_DONE,
+			CSR_HW_IF_CONFIG_REG_BIT_NIC_PREPARE_DONE, 150000);
+
+	if (ret != -ETIMEDOUT)
+		iwl_set_hw_ready(priv);
+
+	return ret;
+}
+
 #define MAX_HW_RESTARTS 5
 
 static int __iwl_up(struct iwl_priv *priv)
@@ -1809,6 +1852,13 @@ static int __iwl_up(struct iwl_priv *priv)
 		return -EIO;
 	}
 
+	iwl_prepare_card_hw(priv);
+
+	if (!priv->hw_ready) {
+		IWL_WARN(priv, "Exit HW not ready\n");
+		return -EIO;
+	}
+
 	/* If platform's RF_KILL switch is NOT set to KILL */
 	if (iwl_read32(priv, CSR_GP_CNTRL) & CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW)
 		clear_bit(STATUS_RF_KILL_HW, &priv->status);
@@ -2896,6 +2946,12 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 * PCI Tx retries from interfering with C3 CPU state */
 	pci_write_config_byte(pdev, PCI_CFG_RETRY_TIMEOUT, 0x00);
 
+	iwl_prepare_card_hw(priv);
+	if (!priv->hw_ready) {
+		IWL_WARN(priv, "Failed, HW not ready\n");
+		goto out_iounmap;
+	}
+
 	/* amp init */
 	err = priv->cfg->ops->lib->apm_ops.init(priv);
 	if (err < 0) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index e2fafb8..f03dae1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -126,9 +126,9 @@
 
 #define CSR_HW_IF_CONFIG_REG_BIT_HAP_WAKE_L1A		(0x00080000)
 #define CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM		(0x00200000)
-#define CSR_HW_IF_CONFIG_REG_BIT_PCI_OWN_SEM		(0x00400000)
-#define CSR_HW_IF_CONFIG_REG_BIT_ME_OWN			(0x02000000)
-#define CSR_HW_IF_CONFIG_REG_BIT_WAKE_ME		(0x08000000)
+#define CSR_HW_IF_CONFIG_REG_BIT_NIC_READY		(0x00400000)
+#define CSR_HW_IF_CONFIG_REG_BIT_NIC_PREPARE_DONE	(0x02000000)
+#define CSR_HW_IF_CONFIG_REG_PREPARE			(0x08000000)
 
 #define CSR_INT_PERIODIC_DIS			(0x00)
 #define CSR_INT_PERIODIC_ENA			(0xFF)
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index f9a3fd6..2dafc26 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1113,7 +1113,7 @@ struct iwl_priv {
 	u32 disable_tx_power_cal;
 	struct work_struct run_time_calib_work;
 	struct timer_list statistics_periodic;
-
+	bool hw_ready;
 	/*For 3945*/
 #define IWL_DEFAULT_TX_POWER 0x0F
 
-- 
1.5.6.3

