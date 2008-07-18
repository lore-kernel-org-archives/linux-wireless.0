Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:54091 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040AbYGRF42 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2008 01:56:28 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 08/13] iwlwifi: move iwl4965_set_pwr_src to iwl4965-base.c
Date: Fri, 18 Jul 2008 13:53:04 +0800
Message-Id: <1216360389-5352-9-git-send-email-yi.zhu@intel.com> (sfid-20080718_075631_927997_7259E736)
In-Reply-To: <1216360389-5352-8-git-send-email-yi.zhu@intel.com>
References: <1216360389-5352-1-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-2-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-3-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-4-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-5-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-6-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-7-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-8-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch moves iwl4965_set_pwr_src to iwl4965-base.c.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   33 ---------------------------
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   31 +++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 32baeb2..1463421 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -341,39 +341,6 @@ err:
 	return -EINVAL;
 
 }
-int iwl4965_set_pwr_src(struct iwl_priv *priv, enum iwl_pwr_src src)
-{
-	int ret;
-	unsigned long flags;
-
-	spin_lock_irqsave(&priv->lock, flags);
-	ret = iwl_grab_nic_access(priv);
-	if (ret) {
-		spin_unlock_irqrestore(&priv->lock, flags);
-		return ret;
-	}
-
-	if (src == IWL_PWR_SRC_VAUX) {
-		u32 val;
-		ret = pci_read_config_dword(priv->pci_dev, PCI_POWER_SOURCE,
-					    &val);
-
-		if (val & PCI_CFG_PMC_PME_FROM_D3COLD_SUPPORT) {
-			iwl_set_bits_mask_prph(priv, APMG_PS_CTRL_REG,
-					       APMG_PS_CTRL_VAL_PWR_SRC_VAUX,
-					       ~APMG_PS_CTRL_MSK_PWR_SRC);
-		}
-	} else {
-		iwl_set_bits_mask_prph(priv, APMG_PS_CTRL_REG,
-				       APMG_PS_CTRL_VAL_PWR_SRC_VMAIN,
-				       ~APMG_PS_CTRL_MSK_PWR_SRC);
-	}
-
-	iwl_release_nic_access(priv);
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	return ret;
-}
 
 /*
  * Activate/Deactivat Tx DMA/FIFO channels according tx fifos mask
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index e468936..2798ab7 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -1262,6 +1262,37 @@ static void iwl4965_rx_card_state_notif(struct iwl_priv *priv,
 		wake_up_interruptible(&priv->wait_command_queue);
 }
 
+int iwl4965_set_pwr_src(struct iwl_priv *priv, enum iwl_pwr_src src)
+{
+	int ret;
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->lock, flags);
+	ret = iwl_grab_nic_access(priv);
+	if (ret)
+		goto err;
+
+	if (src == IWL_PWR_SRC_VAUX) {
+		u32 val;
+		ret = pci_read_config_dword(priv->pci_dev, PCI_POWER_SOURCE,
+					    &val);
+
+		if (val & PCI_CFG_PMC_PME_FROM_D3COLD_SUPPORT)
+			iwl_set_bits_mask_prph(priv, APMG_PS_CTRL_REG,
+					       APMG_PS_CTRL_VAL_PWR_SRC_VAUX,
+					       ~APMG_PS_CTRL_MSK_PWR_SRC);
+	} else {
+		iwl_set_bits_mask_prph(priv, APMG_PS_CTRL_REG,
+				       APMG_PS_CTRL_VAL_PWR_SRC_VMAIN,
+				       ~APMG_PS_CTRL_MSK_PWR_SRC);
+	}
+
+	iwl_release_nic_access(priv);
+err:
+	spin_unlock_irqrestore(&priv->lock, flags);
+	return ret;
+}
+
 /**
  * iwl4965_setup_rx_handlers - Initialize Rx handler callbacks
  *
-- 
1.5.3.6

