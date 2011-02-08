Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23836 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754162Ab1BHNgw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Feb 2011 08:36:52 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [RFC/RFT] iwl3945: use software scanning by default
Date: Tue,  8 Feb 2011 14:36:51 +0100
Message-Id: <1297172211-17448-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Looking for some more testing and opinions.

Patch fixes:
https://bugzilla.redhat.com/show_bug.cgi?id=671366
and probably some other "very poor performance" bugs reported
elsewhere.

Sometimes after hardware scanning device is unable to receive frames
at higher rate, what cause that very slow speed is observed by the users.

To workaround problem we can use software scanning. Patch remove
"deprecated" warning and make sw scan be used by default on 3945.

On older kernels, in particular 2.6.35, software scanning does not
fix problem. On my setup, not affected by bug, I can see slow speed
with software scans on 2.6.35 as well. I'm not quite sure why. Anyway
on upstream patch works good for me and bug reporter.

---
 drivers/net/wireless/iwlwifi/iwl-core.h     |    4 ++--
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   14 +++-----------
 2 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 6e14a7b..9e7a6d1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -254,8 +254,8 @@ struct iwl_ops {
 };
 
 struct iwl_mod_params {
-	int sw_crypto;		/* def: 0 = using hardware encryption */
-	int disable_hw_scan;	/* def: 0 = use h/w scan */
+	int sw_crypto;		/* def: HW dependent */
+	int disable_hw_scan;	/* def: HW dependent */
 	int num_of_queues;	/* def: HW dependent */
 	int disable_11n;	/* def: 0 = 11n capabilities enabled */
 	int amsdu_size_8K;	/* def: 1 = enable 8K amsdu size */
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 10e8034..7d9e234 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -94,6 +94,7 @@ MODULE_LICENSE("GPL");
 struct iwl_mod_params iwl3945_mod_params = {
 	.sw_crypto = 1,
 	.restart_fw = 1,
+	.disable_hw_scan = 1,
 	/* the rest are 0 by default */
 };
 
@@ -3996,16 +3997,8 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	priv->contexts[IWL_RXON_CTX_BSS].station_devtype = RXON_DEV_TYPE_ESS;
 	priv->contexts[IWL_RXON_CTX_BSS].unused_devtype = RXON_DEV_TYPE_ESS;
 
-	/*
-	 * Disabling hardware scan means that mac80211 will perform scans
-	 * "the hard way", rather than using device's scan.
-	 */
-	if (iwl3945_mod_params.disable_hw_scan) {
-		dev_printk(KERN_DEBUG, &(pdev->dev),
-			"sw scan support is deprecated\n");
+	if (iwl3945_mod_params.disable_hw_scan)
 		iwl3945_hw_ops.hw_scan = NULL;
-	}
-
 
 	IWL_DEBUG_INFO(priv, "*** LOAD DRIVER ***\n");
 	priv->cfg = cfg;
@@ -4326,8 +4319,7 @@ MODULE_PARM_DESC(debug, "debug output mask");
 #endif
 module_param_named(disable_hw_scan, iwl3945_mod_params.disable_hw_scan,
 		   int, S_IRUGO);
-MODULE_PARM_DESC(disable_hw_scan,
-		 "disable hardware scanning (default 0) (deprecated)");
+MODULE_PARM_DESC(disable_hw_scan, "disable hardware scanning (default 1)");
 module_param_named(fw_restart3945, iwl3945_mod_params.restart_fw, int, S_IRUGO);
 MODULE_PARM_DESC(fw_restart3945, "restart firmware in case of error");
 
-- 
1.7.1

