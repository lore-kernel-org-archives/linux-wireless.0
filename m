Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:38791 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758436AbXHHHh3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 03:37:29 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 11/28] iwlwifi: add name for some PCI configuration space registers
Date: Wed,  8 Aug 2007 15:33:28 +0800
Message-Id: <11865584521358-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11865584503648-git-send-email-yi.zhu@intel.com>
References: <11865584251026-git-send-email-yi.zhu@intel.com>
 <11865584292234-git-send-email-yi.zhu@intel.com>
 <1186558432932-git-send-email-yi.zhu@intel.com>
 <11865584342308-git-send-email-yi.zhu@intel.com>
 <11865584363863-git-send-email-yi.zhu@intel.com>
 <11865584392893-git-send-email-yi.zhu@intel.com>
 <11865584413292-git-send-email-yi.zhu@intel.com>
 <1186558443548-git-send-email-yi.zhu@intel.com>
 <11865584452614-git-send-email-yi.zhu@intel.com>
 <11865584473732-git-send-email-yi.zhu@intel.com>
 <11865584503648-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-3945.c |    3 ++-
 drivers/net/wireless/iwl-4965.c |    8 +++++---
 drivers/net/wireless/iwl-hw.h   |    2 ++
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwl-3945.c b/drivers/net/wireless/iwl-3945.c
index 8e78ad5..50c21aa 100644
--- a/drivers/net/wireless/iwl-3945.c
+++ b/drivers/net/wireless/iwl-3945.c
@@ -721,7 +721,8 @@ static int iwl3945_nic_set_pwr_src(struct iwl_priv *priv, int pwr_max)
 
 	if (!pwr_max) {
 		u32 val;
-		rc = pci_read_config_dword(priv->pci_dev, 0x0C8, &val);
+		rc = pci_read_config_dword(priv->pci_dev, PCI_POWER_SOURCE,
+					   &val);
 		if (val & PCI_CFG_PMC_PME_FROM_D3COLD_SUPPORT) {
 			iwl_set_bits_mask_restricted_reg(
 				priv, ALM_APMG_PS_CTL,
diff --git a/drivers/net/wireless/iwl-4965.c b/drivers/net/wireless/iwl-4965.c
index 8175b48..d334951 100644
--- a/drivers/net/wireless/iwl-4965.c
+++ b/drivers/net/wireless/iwl-4965.c
@@ -203,7 +203,8 @@ static int iwl4965_nic_set_pwr_src(struct iwl_priv *priv, int pwr_max)
 
 	if (!pwr_max) {
 		u32 val;
-		rc = pci_read_config_dword(priv->pci_dev, 0x0C8, &val);
+		rc = pci_read_config_dword(priv->pci_dev, PCI_POWER_SOURCE,
+					   &val);
 
 		if (val & PCI_CFG_PMC_PME_FROM_D3COLD_SUPPORT)
 			iwl_set_bits_mask_restricted_reg(
@@ -476,9 +477,10 @@ int iwl_hw_nic_init(struct iwl_priv *priv)
 	spin_lock_irqsave(&priv->lock, flags);
 
 	if ((rev_id & 0x80) == 0x80 && (rev_id & 0x7f) < 8) {
-		pci_read_config_dword(priv->pci_dev, 0xe8, &val);
+		pci_read_config_dword(priv->pci_dev, PCI_REG_WUM8, &val);
 		/* Enable No Snoop field */
-		pci_write_config_dword(priv->pci_dev, 0xe8, val & ~(1 << 11));
+		pci_write_config_dword(priv->pci_dev, PCI_REG_WUM8,
+				       val & ~(1 << 11));
 	}
 
 	spin_unlock_irqrestore(&priv->lock, flags);
diff --git a/drivers/net/wireless/iwl-hw.h b/drivers/net/wireless/iwl-hw.h
index e01f29c..f371794 100644
--- a/drivers/net/wireless/iwl-hw.h
+++ b/drivers/net/wireless/iwl-hw.h
@@ -179,6 +179,8 @@ struct iwl_error_resp {
 } __attribute__ ((packed));
 
 #define PCI_LINK_CTRL      0x0F0
+#define PCI_POWER_SOURCE   0x0C8
+#define PCI_REG_WUM8       0x0E8
 
 /*
  * Rx config defines & structure
-- 
1.5.2
