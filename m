Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:47912 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756806AbZEHUiY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2009 16:38:24 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 06/11] iwl3945: read rev id in nic config
Date: Fri,  8 May 2009 13:44:41 -0700
Message-Id: <1241815486-13510-7-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1241815486-13510-6-git-send-email-reinette.chatre@intel.com>
References: <1241815486-13510-1-git-send-email-reinette.chatre@intel.com>
 <1241815486-13510-2-git-send-email-reinette.chatre@intel.com>
 <1241815486-13510-3-git-send-email-reinette.chatre@intel.com>
 <1241815486-13510-4-git-send-email-reinette.chatre@intel.com>
 <1241815486-13510-5-git-send-email-reinette.chatre@intel.com>
 <1241815486-13510-6-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

Read rev id in nic_config instead of nic_init.
Nic_config has some checking for rev_id but we actually don't read
the rev_id in there.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 41f1d66..5b0c6e5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -1110,6 +1110,11 @@ static void iwl3945_nic_config(struct iwl_priv *priv)
 
 	spin_lock_irqsave(&priv->lock, flags);
 
+	/* Determine HW type */
+	pci_read_config_byte(priv->pci_dev, PCI_REVISION_ID, &rev_id);
+
+	IWL_DEBUG_INFO(priv, "HW Revision ID = 0x%X\n", rev_id);
+
 	if (rev_id & PCI_CFG_REV_ID_BIT_RTP)
 		IWL_DEBUG_INFO(priv, "RTP type \n");
 	else if (rev_id & PCI_CFG_REV_ID_BIT_BASIC_SKU) {
@@ -1163,7 +1168,6 @@ static void iwl3945_nic_config(struct iwl_priv *priv)
 
 int iwl3945_hw_nic_init(struct iwl_priv *priv)
 {
-	u8 rev_id;
 	int rc;
 	unsigned long flags;
 	struct iwl_rx_queue *rxq = &priv->rxq;
@@ -1172,12 +1176,6 @@ int iwl3945_hw_nic_init(struct iwl_priv *priv)
 	priv->cfg->ops->lib->apm_ops.init(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	/* Determine HW type */
-	rc = pci_read_config_byte(priv->pci_dev, PCI_REVISION_ID, &rev_id);
-	if (rc)
-		return rc;
-	IWL_DEBUG_INFO(priv, "HW Revision ID = 0x%X\n", rev_id);
-
 	rc = priv->cfg->ops->lib->apm_ops.set_pwr_src(priv, IWL_PWR_SRC_VMAIN);
 	if (rc)
 		return rc;
-- 
1.5.6.3

