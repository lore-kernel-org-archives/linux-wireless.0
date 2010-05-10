Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20482 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442Ab0EJW1p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 18:27:45 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH wireless-2.6] iwlagn: wait for asynchronous firmware loading
Date: Mon, 10 May 2010 15:27:42 -0700
Message-Id: <1273530462-11820-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When we kick off a firmware loading process,
and then unbind from the pci device right
away, we get into trouble. Avoid that by
waiting for the firmware loading to finish
(whether successfully or not) before the
unbind in iwl_pci_remove.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---

This patch is also available from wireless-2.6 branch on
git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-agn.c |    6 ++++++
 drivers/net/wireless/iwlwifi/iwl-dev.h |    2 ++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index ba0fdba..ae8eb09 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1741,6 +1741,7 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 
 	/* We have our copies now, allow OS release its copies */
 	release_firmware(ucode_raw);
+	complete(&priv->firmware_loading_complete);
 	return;
 
  try_again:
@@ -1754,6 +1755,7 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	IWL_ERR(priv, "failed to allocate pci memory\n");
 	iwl_dealloc_ucode_pci(priv);
  out_unbind:
+	complete(&priv->firmware_loading_complete);
 	device_release_driver(&priv->pci_dev->dev);
 	release_firmware(ucode_raw);
 }
@@ -3671,6 +3673,8 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	iwl_power_initialize(priv);
 	iwl_tt_initialize(priv);
 
+	init_completion(&priv->firmware_loading_complete);
+
 	err = iwl_request_firmware(priv, true);
 	if (err)
 		goto out_remove_sysfs;
@@ -3711,6 +3715,8 @@ static void __devexit iwl_pci_remove(struct pci_dev *pdev)
 	if (!priv)
 		return;
 
+	wait_for_completion(&priv->firmware_loading_complete);
+
 	IWL_DEBUG_INFO(priv, "*** UNLOAD DRIVER ***\n");
 
 	iwl_dbgfs_unregister(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index ef1720a..4d4c651 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1304,6 +1304,8 @@ struct iwl_priv {
 	struct delayed_work alive_start;
 	struct delayed_work scan_check;
 
+	struct completion firmware_loading_complete;
+
 	/*For 3945 only*/
 	struct delayed_work thermal_periodic;
 	struct delayed_work rfkill_poll;
-- 
1.6.3.3

