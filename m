Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:34409 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760448Ab1F1SjR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jun 2011 14:39:17 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/3] compat-wireless: make patches apply again
Date: Tue, 28 Jun 2011 20:38:50 +0200
Message-Id: <1309286332-12470-1-git-send-email-hauke@hauke-m.de> (sfid-20110628_205713_432559_4E77D596)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/11-dev-pm-ops.patch |   21 ++++++---------------
 1 files changed, 6 insertions(+), 15 deletions(-)

diff --git a/patches/11-dev-pm-ops.patch b/patches/11-dev-pm-ops.patch
index b36c48b..c64a6e2 100644
--- a/patches/11-dev-pm-ops.patch
+++ b/patches/11-dev-pm-ops.patch
@@ -219,26 +219,17 @@ calls on compat code with only slight modifications.
  static int __init iwl4965_init(void)
 --- a/drivers/net/wireless/iwlwifi/iwl-pci.c
 +++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
-@@ -530,14 +530,10 @@ static int iwl_pci_resume(struct device
- 	return iwl_resume(priv);
- }
+@@ -527,6 +527,9 @@ static int iwl_pci_resume(struct device
+ 
+ static SIMPLE_DEV_PM_OPS(iwl_dev_pm_ops, iwl_pci_suspend, iwl_pci_resume);
  
--static const struct dev_pm_ops iwl_dev_pm_ops = {
--	.suspend = iwl_pci_suspend,
--	.resume = iwl_pci_resume,
--	.freeze = iwl_pci_suspend,
--	.thaw = iwl_pci_resume,
--	.poweroff = iwl_pci_suspend,
--	.restore = iwl_pci_resume,
--};
-+const SIMPLE_DEV_PM_OPS(iwl_dev_pm_ops, iwl_pci_suspend, iwl_pci_resume);
-+
 +compat_pci_suspend(iwl_pci_suspend)
 +compat_pci_resume(iwl_pci_resume)
- 
++
  #define IWL_PM_OPS	(&iwl_dev_pm_ops)
  
-@@ -552,7 +548,12 @@ static struct pci_driver iwl_pci_driver
+ #else
+@@ -540,7 +543,12 @@ static struct pci_driver iwl_pci_driver
  	.id_table = iwl_hw_card_ids,
  	.probe = iwl_pci_probe,
  	.remove = __devexit_p(iwl_pci_remove),
-- 
1.7.4.1

