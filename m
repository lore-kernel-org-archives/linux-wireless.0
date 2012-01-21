Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:39162 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777Ab2AUNnq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jan 2012 08:43:46 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/3] compat-wireless: backport dev_pm_ops for bcma
Date: Sat, 21 Jan 2012 14:43:34 +0100
Message-Id: <1327153416-27834-1-git-send-email-hauke@hauke-m.de> (sfid-20120121_144351_737474_E67DB5AB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

bcma now also uses dev_pm_ops which does not work with older kernel
versions. Just backport it like it was done for the other drivers.

This should also go into compat-wireless-stable-3.3.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/11-dev-pm-ops.patch |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/patches/11-dev-pm-ops.patch b/patches/11-dev-pm-ops.patch
index d0446d8..6dd3e6c 100644
--- a/patches/11-dev-pm-ops.patch
+++ b/patches/11-dev-pm-ops.patch
@@ -7,6 +7,32 @@ calls on compat code with only slight modifications.
 
 [1] http://lxr.linux.no/#linux+v2.6.29/include/linux/pm.h#L170
 
+--- a/drivers/bcma/host_pci.c
++++ b/drivers/bcma/host_pci.c
+@@ -255,6 +255,10 @@ static int bcma_host_pci_resume(struct d
+ 
+ static SIMPLE_DEV_PM_OPS(bcma_pm_ops, bcma_host_pci_suspend,
+ 			 bcma_host_pci_resume);
++
++compat_pci_suspend(bcma_host_pci_suspend)
++compat_pci_resume(bcma_host_pci_resume)
++
+ #define BCMA_PM_OPS	(&bcma_pm_ops)
+ 
+ #else /* CONFIG_PM */
+@@ -278,7 +282,12 @@ static struct pci_driver bcma_pci_bridge
+ 	.id_table = bcma_pci_bridge_tbl,
+ 	.probe = bcma_host_pci_probe,
+ 	.remove = bcma_host_pci_remove,
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+ 	.driver.pm = BCMA_PM_OPS,
++#elif defined(CONFIG_PM)
++	.suspend = bcma_host_pci_suspend_compat,
++	.resume = bcma_host_pci_resume_compat,
++#endif
+ };
+ 
+ int __init bcma_host_pci_init(void)
 --- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
 +++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
 @@ -2900,6 +2900,9 @@ static struct pci_error_handlers atl1c_e
-- 
1.7.5.4

