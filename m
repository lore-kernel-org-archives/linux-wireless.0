Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:11395 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756809Ab0JFPXw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 11:23:52 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 1/6] iwlwifi: schedule to deprecate software scan support
Date: Wed,  6 Oct 2010 08:23:08 -0700
Message-Id: <1286378593-7509-2-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1286378593-7509-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1286378593-7509-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hardware scan is the prefer method for all iwlwifi devices;
especially for dual-mode functions. Schedule to deprecate the
software scan support in kernel 2.6.40

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 Documentation/feature-removal-schedule.txt  |   10 ++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    8 ++++----
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    5 +++--
 3 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index be7030e..cd89d1e 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -563,3 +563,13 @@ Why:	superseded by acpi_sleep=nonvs
 Who:	Rafael J. Wysocki <rjw@sisk.pl>
 
 ----------------------------
+
+What:	iwlwifi disable_hw_scan module parameters
+When:	2.6.40
+Why:	Hareware scan is the prefer method for iwlwifi devices for
+	scanning operation. Remove software scan support for all the
+	iwlwifi devices.
+
+Who:	Wey-Yi Guy <wey-yi.w.guy@intel.com>
+
+----------------------------
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index e23c554..e7dc8b9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -4296,9 +4296,8 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* Disabling hardware scan means that mac80211 will perform scans
 	 * "the hard way", rather than using device's scan. */
 	if (cfg->mod_params->disable_hw_scan) {
-		if (iwl_debug_level & IWL_DL_INFO)
-			dev_printk(KERN_DEBUG, &(pdev->dev),
-				   "Disabling hw_scan\n");
+		dev_printk(KERN_DEBUG, &(pdev->dev),
+			"sw scan support is deprecated\n");
 		iwl_hw_ops.hw_scan = NULL;
 	}
 
@@ -4905,7 +4904,8 @@ module_param_named(fw_restart, iwlagn_mod_params.restart_fw, int, S_IRUGO);
 MODULE_PARM_DESC(fw_restart, "restart firmware in case of error");
 module_param_named(
 	disable_hw_scan, iwlagn_mod_params.disable_hw_scan, int, S_IRUGO);
-MODULE_PARM_DESC(disable_hw_scan, "disable hardware scanning (default 0)");
+MODULE_PARM_DESC(disable_hw_scan,
+		 "disable hardware scanning (default 0) (deprecated)");
 
 module_param_named(ucode_alternative, iwlagn_wanted_ucode_alternative, int,
 		   S_IRUGO);
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 1167771..8b6aa3d 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3966,7 +3966,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	 * "the hard way", rather than using device's scan.
 	 */
 	if (iwl3945_mod_params.disable_hw_scan) {
-		IWL_DEBUG_INFO(priv, "Disabling hw_scan\n");
+		IWL_ERR(priv, "sw scan support is deprecated\n");
 		iwl3945_hw_ops.hw_scan = NULL;
 	}
 
@@ -4291,7 +4291,8 @@ MODULE_PARM_DESC(debug, "debug output mask");
 #endif
 module_param_named(disable_hw_scan, iwl3945_mod_params.disable_hw_scan,
 		   int, S_IRUGO);
-MODULE_PARM_DESC(disable_hw_scan, "disable hardware scanning (default 0)");
+MODULE_PARM_DESC(disable_hw_scan,
+		 "disable hardware scanning (default 0) (deprecated)");
 module_param_named(fw_restart3945, iwl3945_mod_params.restart_fw, int, S_IRUGO);
 MODULE_PARM_DESC(fw_restart3945, "restart firmware in case of error");
 
-- 
1.7.0.4

