Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:55576 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756676AbZDTVbD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2009 17:31:03 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 05/11] iwl3945: add debugfs to 3945
Date: Mon, 20 Apr 2009 14:36:58 -0700
Message-Id: <1240263424-8495-6-git-send-email-reinette.chatre@intel.com> (sfid-20090420_233114_605268_F81E6E17)
In-Reply-To: <1240263424-8495-5-git-send-email-reinette.chatre@intel.com>
References: <1240263424-8495-1-git-send-email-reinette.chatre@intel.com>
 <1240263424-8495-2-git-send-email-reinette.chatre@intel.com>
 <1240263424-8495-3-git-send-email-reinette.chatre@intel.com>
 <1240263424-8495-4-git-send-email-reinette.chatre@intel.com>
 <1240263424-8495-5-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

Patch adds debugfs to 3945. Also fix debugfs registration in iwlagn
to return error code if it fails.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    6 ++++++
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 12de63e..2751736 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2829,7 +2829,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	err = iwl_dbgfs_register(priv, DRV_NAME);
 	if (err)
-		IWL_ERR(priv, "failed to create debugfs files\n");
+		IWL_ERR(priv, "failed to create debugfs files. Ignoring error: %d\n", err);
 
 	/* If platform's RF_KILL switch is NOT set to KILL */
 	if (iwl_read32(priv, CSR_GP_CNTRL) & CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW)
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 5520a79..4e1331d 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -4346,6 +4346,10 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	if (err)
 		goto  out_remove_sysfs;
 
+	err = iwl_dbgfs_register(priv, DRV_NAME);
+	if (err)
+		IWL_ERR(priv, "failed to create debugfs files. Ignoring error: %d\n", err);
+
 	err = iwl_rfkill_init(priv);
 	if (err)
 		IWL_ERR(priv, "Unable to initialize RFKILL system. "
@@ -4396,6 +4400,8 @@ static void __devexit iwl3945_pci_remove(struct pci_dev *pdev)
 
 	IWL_DEBUG_INFO(priv, "*** UNLOAD DRIVER ***\n");
 
+	iwl_dbgfs_unregister(priv);
+
 	set_bit(STATUS_EXIT_PENDING, &priv->status);
 
 	if (priv->mac80211_registered) {
-- 
1.5.6.3

