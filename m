Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:34378 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748Ab1AIPGr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Jan 2011 10:06:47 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat-wireless: backport power api in atl1c
Date: Sun,  9 Jan 2011 16:06:21 +0100
Message-Id: <1294585581-9991-3-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1294585581-9991-1-git-send-email-hauke@hauke-m.de>
References: <1294585581-9991-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

atl1 now uses the new PCI power management. For older kernel version
the old API must be used.

In compat-wireless upstream it is commit:
	c7341cf985decfc1d3a570735f5509886212157f

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/11-dev-pm-ops.patch |   50 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 50 insertions(+), 0 deletions(-)

diff --git a/patches/11-dev-pm-ops.patch b/patches/11-dev-pm-ops.patch
index 0e4ca6a..42aaa33 100644
--- a/patches/11-dev-pm-ops.patch
+++ b/patches/11-dev-pm-ops.patch
@@ -7,6 +7,56 @@ calls on compat code with only slight modifications.
 
 [1] http://lxr.linux.no/#linux+v2.6.29/include/linux/pm.h#L170
 
+--- a/drivers/net/atl1c/atl1c_main.c
++++ b/drivers/net/atl1c/atl1c_main.c
+@@ -2881,6 +2881,34 @@
+ 	.resume = atl1c_io_resume,
+ };
+ 
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29))
++static int atl1c_suspend_compat(struct pci_dev *pdev, pm_message_t state)
++{
++	int r;
++
++	r = atl1c_suspend(&pdev->dev);
++	if (r)
++		return r;
++
++	pci_save_state(pdev);
++	pci_disable_device(pdev);
++	pci_set_power_state(pdev, PCI_D3hot);
++	return 0;
++}
++
++static int atl1c_resume_compat(struct pci_dev *pdev)
++{
++	int r;
++
++	pci_restore_state(pdev);
++	r = pci_enable_device(pdev);
++	if (r)
++		return r;
++
++	return atl1c_resume(&pdev->dev);
++}
++#endif
++
+ static SIMPLE_DEV_PM_OPS(atl1c_pm_ops, atl1c_suspend, atl1c_resume);
+ 
+ static struct pci_driver atl1c_driver = {
+@@ -2890,7 +2918,12 @@
+ 	.remove   = __devexit_p(atl1c_remove),
+ 	.shutdown = atl1c_shutdown,
+ 	.err_handler = &atl1c_err_handler,
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+ 	.driver.pm = &atl1c_pm_ops,
++#elif defined(CONFIG_PM_SLEEP)
++	.suspend        = atl1c_suspend_compat,
++	.resume         = atl1c_resume_compat,
++#endif
+ };
+ 
+ /*
 --- a/drivers/net/wireless/ath/ath5k/base.c
 +++ b/drivers/net/wireless/ath/ath5k/base.c
 @@ -3717,6 +3717,34 @@ static int ath5k_pci_resume(struct devic
-- 
1.7.1

