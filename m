Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34376 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959Ab1CNNP1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Mar 2011 09:15:27 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH] iwl3945: do not deprecate software scan
Date: Mon, 14 Mar 2011 14:15:06 +0100
Message-Id: <1300108506-15490-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Software scanning can be used for workaround some performance problems,
so do not deprecate it.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/iwl3945-base.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl3945-base.c b/drivers/net/wireless/iwlegacy/iwl3945-base.c
index ab87e1b..b6c5209 100644
--- a/drivers/net/wireless/iwlegacy/iwl3945-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl3945-base.c
@@ -3960,8 +3960,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	 * "the hard way", rather than using device's scan.
 	 */
 	if (iwl3945_mod_params.disable_hw_scan) {
-		dev_printk(KERN_DEBUG, &(pdev->dev),
-			"sw scan support is deprecated\n");
+		IWL_DEBUG_INFO(priv, "Disabling hw_scan\n");
 		iwl3945_hw_ops.hw_scan = NULL;
 	}
 
@@ -4280,8 +4279,7 @@ MODULE_PARM_DESC(swcrypto,
 		"using software crypto (default 1 [software])");
 module_param_named(disable_hw_scan, iwl3945_mod_params.disable_hw_scan,
 		int, S_IRUGO);
-MODULE_PARM_DESC(disable_hw_scan,
-		"disable hardware scanning (default 0) (deprecated)");
+MODULE_PARM_DESC(disable_hw_scan, "disable hardware scanning (default 0)");
 #ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
 module_param_named(debug, iwlegacy_debug_level, uint, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(debug, "debug output mask");
-- 
1.7.1

