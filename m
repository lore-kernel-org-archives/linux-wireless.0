Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:39362 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610Ab1AAO0f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Jan 2011 09:26:35 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/4] compat-wireless: fix power managemnet backport
Date: Sat,  1 Jan 2011 15:26:18 +0100
Message-Id: <1293891981-22151-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Include backported power management support under the same condition as
the new one is integrated.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/11-dev-pm-ops.patch |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/patches/11-dev-pm-ops.patch b/patches/11-dev-pm-ops.patch
index f30baf8..dea121a 100644
--- a/patches/11-dev-pm-ops.patch
+++ b/patches/11-dev-pm-ops.patch
@@ -60,7 +60,7 @@ calls on compat code with only slight modifications.
  	.remove     = ath_pci_remove,
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
  	.driver.pm  = ATH9K_PM_OPS,
-+#elif defined(CONFIG_PM_SLEEP)
++#elif defined(CONFIG_PM)
 +	.suspend    = ath_pci_suspend_compat,
 +	.resume     = ath_pci_resume_compat,
 +#endif
@@ -75,7 +75,7 @@ calls on compat code with only slight modifications.
  	.remove = __devexit_p(iwl_pci_remove),
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
  	.driver.pm = IWL_PM_OPS,
-+#elif defined(CONFIG_PM_SLEEP)
++#elif defined(CONFIG_PM)
 +	.suspend = iwl_pci_suspend_compat,
 +	.resume = iwl_pci_resume_compat,
 +#endif
@@ -158,7 +158,7 @@ calls on compat code with only slight modifications.
  	.remove = __devexit_p(iwl3945_pci_remove),
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
  	.driver.pm = IWL_PM_OPS,
-+#elif defined(CONFIG_PM_SLEEP)
++#elif defined(CONFIG_PM)
 +	.suspend = iwl_pci_suspend_compat,
 +	.resume = iwl_pci_resume_compat,
 +#endif
-- 
1.7.1

