Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:27262 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754997Ab0KICti (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Nov 2010 21:49:38 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH wireless-2.6] iwlwifi: dont use pci_dev before it being assign
Date: Mon,  8 Nov 2010 18:45:21 -0800
Message-Id: <1289270721-31421-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In order to use build-in debugging macro, pci_dev in priv need to be
assigned first.

This fix iwl3945 driver oopsed at boot with 2.6.37-rc1

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
this patch is also available from wireless-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl3945-base.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 193247a..43ff17a 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -4003,7 +4003,8 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	 * "the hard way", rather than using device's scan.
 	 */
 	if (iwl3945_mod_params.disable_hw_scan) {
-		IWL_ERR(priv, "sw scan support is deprecated\n");
+		dev_printk(KERN_DEBUG, &(pdev->dev),
+			"sw scan support is deprecated\n");
 		iwl3945_hw_ops.hw_scan = NULL;
 	}
 
-- 
1.7.0.4

