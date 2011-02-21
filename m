Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:36264 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828Ab1BUWbj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Feb 2011 17:31:39 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/7] compat-wireless: backport pm ops for atlx
Date: Mon, 21 Feb 2011 23:31:19 +0100
Message-Id: <1298327484-16938-3-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1298327484-16938-1-git-send-email-hauke@hauke-m.de>
References: <1298327484-16938-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/11-dev-pm-ops.patch |   33 +++++++++++++++++++++++++++++----
 1 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/patches/11-dev-pm-ops.patch b/patches/11-dev-pm-ops.patch
index 89a3edc..4f06028 100644
--- a/patches/11-dev-pm-ops.patch
+++ b/patches/11-dev-pm-ops.patch
@@ -32,6 +32,31 @@ calls on compat code with only slight modifications.
  };
  
  /*
+--- a/drivers/net/atlx/atl1.c
++++ b/drivers/net/atlx/atl1.c
+@@ -2839,6 +2839,9 @@ static int atl1_resume(struct device *de
+ 	return 0;
+ }
+ 
++compat_pci_suspend(atl1_suspend)
++compat_pci_resume(atl1_resume)
++
+ static SIMPLE_DEV_PM_OPS(atl1_pm_ops, atl1_suspend, atl1_resume);
+ #define ATL1_PM_OPS	(&atl1_pm_ops)
+ 
+@@ -3101,7 +3104,12 @@ static struct pci_driver atl1_driver = {
+ 	.probe = atl1_probe,
+ 	.remove = __devexit_p(atl1_remove),
+ 	.shutdown = atl1_shutdown,
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+ 	.driver.pm = ATL1_PM_OPS,
++#elif defined(CONFIG_PM_SLEEP)
++	.suspend        = atl1_suspend_compat,
++	.resume         = atl1_resume_compat,
++#endif
+ };
+ 
+ /*
 --- a/drivers/net/wireless/ath/ath5k/pci.c
 +++ b/drivers/net/wireless/ath/ath5k/pci.c
 @@ -287,6 +287,9 @@ static int ath5k_pci_resume(struct devic
@@ -94,7 +119,7 @@ calls on compat code with only slight modifications.
  int ath_pci_init(void)
 --- a/drivers/net/wireless/iwlwifi/iwl-agn.c
 +++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
-@@ -4663,7 +4663,12 @@ static struct pci_driver iwl_driver = {
+@@ -4704,7 +4704,12 @@ static struct pci_driver iwl_driver = {
  	.id_table = iwl_hw_card_ids,
  	.probe = iwl_pci_probe,
  	.remove = __devexit_p(iwl_pci_remove),
@@ -109,7 +134,7 @@ calls on compat code with only slight modifications.
  static int __init iwl_init(void)
 --- a/drivers/net/wireless/iwlwifi/iwl-core.c
 +++ b/drivers/net/wireless/iwlwifi/iwl-core.c
-@@ -2105,14 +2105,16 @@ int iwl_pci_resume(struct device *device
+@@ -2101,14 +2101,16 @@ int iwl_pci_resume(struct device *device
  }
  EXPORT_SYMBOL(iwl_pci_resume);
  
@@ -136,7 +161,7 @@ calls on compat code with only slight modifications.
  #endif /* CONFIG_PM */
 --- a/drivers/net/wireless/iwlwifi/iwl-core.h
 +++ b/drivers/net/wireless/iwlwifi/iwl-core.h
-@@ -620,7 +620,12 @@ __le32 iwl_add_beacon_time(struct iwl_pr
+@@ -621,7 +621,12 @@ __le32 iwl_add_beacon_time(struct iwl_pr
  #ifdef CONFIG_PM
  int iwl_pci_suspend(struct device *device);
  int iwl_pci_resume(struct device *device);
@@ -151,7 +176,7 @@ calls on compat code with only slight modifications.
  
 --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
 +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
-@@ -4271,7 +4271,12 @@ static struct pci_driver iwl3945_driver
+@@ -4277,7 +4277,12 @@ static struct pci_driver iwl3945_driver
  	.id_table = iwl3945_hw_card_ids,
  	.probe = iwl3945_pci_probe,
  	.remove = __devexit_p(iwl3945_pci_remove),
-- 
1.7.1

