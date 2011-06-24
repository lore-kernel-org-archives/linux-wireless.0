Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:49635 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191Ab1FXTjI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jun 2011 15:39:08 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 1/5] iwlagn: use PM ops macro
Date: Fri, 24 Jun 2011 12:07:13 -0700
Message-Id: <1308942437-6039-2-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110624_213924_822858_A455A60B)
In-Reply-To: <1308942437-6039-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1308942437-6039-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Simplify the code and use SIMPLE_DEV_PM_OPS
to define iwl_dev_pm_ops instead of doing the
same thing manually.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-pci.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index 7328fbf..3927c80 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -530,14 +530,7 @@ static int iwl_pci_resume(struct device *device)
 	return iwl_resume(priv);
 }
 
-static const struct dev_pm_ops iwl_dev_pm_ops = {
-	.suspend = iwl_pci_suspend,
-	.resume = iwl_pci_resume,
-	.freeze = iwl_pci_suspend,
-	.thaw = iwl_pci_resume,
-	.poweroff = iwl_pci_suspend,
-	.restore = iwl_pci_resume,
-};
+static SIMPLE_DEV_PM_OPS(iwl_dev_pm_ops, iwl_pci_suspend, iwl_pci_resume);
 
 #define IWL_PM_OPS	(&iwl_dev_pm_ops)
 
-- 
1.7.0.4

