Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:6527 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755921AbZFLUPw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 16:15:52 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 8/8] iwlwifi: remove disable_tx_power for device > 4965
Date: Fri, 12 Jun 2009 13:22:55 -0700
Message-Id: <1244838175-15491-9-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1244838175-15491-8-git-send-email-reinette.chatre@intel.com>
References: <1244838175-15491-1-git-send-email-reinette.chatre@intel.com>
 <1244838175-15491-2-git-send-email-reinette.chatre@intel.com>
 <1244838175-15491-3-git-send-email-reinette.chatre@intel.com>
 <1244838175-15491-4-git-send-email-reinette.chatre@intel.com>
 <1244838175-15491-5-git-send-email-reinette.chatre@intel.com>
 <1244838175-15491-6-git-send-email-reinette.chatre@intel.com>
 <1244838175-15491-7-git-send-email-reinette.chatre@intel.com>
 <1244838175-15491-8-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

After 4965, tx_power_calibration moved from driver to uCode.
remove "disable_tx_power" from debugfs to minimize the confusion.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 11e08c0..f32ac74 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -615,7 +615,10 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_BOOL(disable_sensitivity, rf, &priv->disable_sens_cal);
 	DEBUGFS_ADD_BOOL(disable_chain_noise, rf,
 			 &priv->disable_chain_noise_cal);
-	DEBUGFS_ADD_BOOL(disable_tx_power, rf, &priv->disable_tx_power_cal);
+	if (((priv->hw_rev & CSR_HW_REV_TYPE_MSK) == CSR_HW_REV_TYPE_4965) ||
+	    ((priv->hw_rev & CSR_HW_REV_TYPE_MSK) == CSR_HW_REV_TYPE_3945))
+		DEBUGFS_ADD_BOOL(disable_tx_power, rf,
+				&priv->disable_tx_power_cal);
 	return 0;
 
 err:
@@ -646,7 +649,9 @@ void iwl_dbgfs_unregister(struct iwl_priv *priv)
 	DEBUGFS_REMOVE(priv->dbgfs->dir_data);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_rf_files.file_disable_sensitivity);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_rf_files.file_disable_chain_noise);
-	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_rf_files.file_disable_tx_power);
+	if (((priv->hw_rev & CSR_HW_REV_TYPE_MSK) == CSR_HW_REV_TYPE_4965) ||
+	    ((priv->hw_rev & CSR_HW_REV_TYPE_MSK) == CSR_HW_REV_TYPE_3945))
+		DEBUGFS_REMOVE(priv->dbgfs->dbgfs_rf_files.file_disable_tx_power);
 	DEBUGFS_REMOVE(priv->dbgfs->dir_rf);
 	DEBUGFS_REMOVE(priv->dbgfs->dir_drv);
 	kfree(priv->dbgfs);
-- 
1.5.6.3

