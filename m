Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:39384 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784Ab1AAO0m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Jan 2011 09:26:42 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 4/4] compat-wireless: use generic suspend resume
Date: Sat,  1 Jan 2011 15:26:21 +0100
Message-Id: <1293891981-22151-4-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1293891981-22151-1-git-send-email-hauke@hauke-m.de>
References: <1293891981-22151-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/11-dev-pm-ops.patch |  173 +++++++++++++++----------------------------
 1 files changed, 61 insertions(+), 112 deletions(-)

diff --git a/patches/11-dev-pm-ops.patch b/patches/11-dev-pm-ops.patch
index dea121a..4aa257f 100644
--- a/patches/11-dev-pm-ops.patch
+++ b/patches/11-dev-pm-ops.patch
@@ -7,9 +7,59 @@ calls on compat code with only slight modifications.
 
 [1] http://lxr.linux.no/#linux+v2.6.29/include/linux/pm.h#L170
 
+--- a/drivers/net/atl1c/atl1c_main.c
++++ b/drivers/net/atl1c/atl1c_main.c
+@@ -2879,6 +2879,9 @@ static struct pci_error_handlers atl1c_e
+ 
+ static SIMPLE_DEV_PM_OPS(atl1c_pm_ops, atl1c_suspend, atl1c_resume);
+ 
++compat_pci_suspend(atl1c_suspend)
++compat_pci_resume(atl1c_resume)
++
+ static struct pci_driver atl1c_driver = {
+ 	.name     = atl1c_driver_name,
+ 	.id_table = atl1c_pci_tbl,
+@@ -2886,7 +2889,12 @@ static struct pci_driver atl1c_driver =
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
+--- a/drivers/net/wireless/ath/ath5k/pci.c
++++ b/drivers/net/wireless/ath/ath5k/pci.c
+@@ -286,6 +286,9 @@ static int ath5k_pci_resume(struct devic
+ 	return 0;
+ }
+ 
++compat_pci_suspend(ath5k_pci_suspend)
++compat_pci_resume(ath5k_pci_resume)
++
+ static SIMPLE_DEV_PM_OPS(ath5k_pm_ops, ath5k_pci_suspend, ath5k_pci_resume);
+ #define ATH5K_PM_OPS	(&ath5k_pm_ops)
+ #else
+@@ -297,7 +300,12 @@ static struct pci_driver ath5k_pci_drive
+ 	.id_table	= ath5k_pci_id_table,
+ 	.probe		= ath5k_pci_probe,
+ 	.remove		= __devexit_p(ath5k_pci_remove),
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+ 	.driver.pm	= ATH5K_PM_OPS,
++#elif defined(CONFIG_PM_SLEEP)
++	.suspend        = ath5k_pci_suspend_compat,
++	.resume         = ath5k_pci_resume_compat,
++#endif
+ };
+ 
+ /*
 --- a/drivers/net/wireless/ath/ath9k/pci.c
 +++ b/drivers/net/wireless/ath/ath9k/pci.c
-@@ -315,14 +315,36 @@ static int ath_pci_resume(struct device
+@@ -326,14 +326,11 @@ static int ath_pci_resume(struct device
  	return 0;
  }
  
@@ -21,40 +71,15 @@ calls on compat code with only slight modifications.
 -	.poweroff = ath_pci_suspend,
 -	.restore = ath_pci_resume,
 -};
-+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29))
-+static int ath_pci_suspend_compat(struct pci_dev *pdev, pm_message_t state)
-+{
-+	int r;
 +
-+	r = ath_pci_suspend(&pdev->dev);
-+	if (r)
-+		return r;
-+
-+	pci_save_state(pdev);
-+	pci_disable_device(pdev);
-+	pci_set_power_state(pdev, PCI_D3hot);
-+
-+	return 0;
-+}
-+
-+static int ath_pci_resume_compat(struct pci_dev *pdev)
-+{
-+	int r;
-+
-+	pci_restore_state(pdev);
-+	r = pci_enable_device(pdev);
-+	if (r)
-+		return r;
-+
-+	return ath_pci_resume(&pdev->dev);
-+}
-+#endif
++compat_pci_suspend(ath_pci_suspend)
++compat_pci_resume(ath_pci_resume)
 +
 +static SIMPLE_DEV_PM_OPS(ath9k_pm_ops, ath_pci_suspend, ath_pci_resume);
  
  #define ATH9K_PM_OPS	(&ath9k_pm_ops)
  
-@@ -340,7 +362,12 @@ static struct pci_driver ath_pci_driver
+@@ -351,7 +348,12 @@ static struct pci_driver ath_pci_driver
  	.id_table   = ath_pci_id_table,
  	.probe      = ath_pci_probe,
  	.remove     = ath_pci_remove,
@@ -84,7 +109,7 @@ calls on compat code with only slight modifications.
  static int __init iwl_init(void)
 --- a/drivers/net/wireless/iwlwifi/iwl-core.c
 +++ b/drivers/net/wireless/iwlwifi/iwl-core.c
-@@ -2098,14 +2098,42 @@ int iwl_pci_resume(struct device *device
+@@ -2098,14 +2098,16 @@ int iwl_pci_resume(struct device *device
  }
  EXPORT_SYMBOL(iwl_pci_resume);
  
@@ -96,42 +121,16 @@ calls on compat code with only slight modifications.
 -	.poweroff = iwl_pci_suspend,
 -	.restore = iwl_pci_resume,
 -};
-+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29))
-+int iwl_pci_suspend_compat(struct pci_dev *pdev, pm_message_t state)
-+{
-+	int r;
-+
-+	r = iwl_pci_suspend(&pdev->dev);
-+	if (r)
-+		return r;
-+
-+	pci_save_state(pdev);
-+	pci_disable_device(pdev);
-+	pci_set_power_state(pdev, PCI_D3hot);
-+
-+	return 0;
-+}
-+EXPORT_SYMBOL(iwl_pci_suspend_compat);
-+
-+int iwl_pci_resume_compat(struct pci_dev *pdev)
-+{
-+	int r;
-+
-+	pci_set_power_state(pdev, PCI_D0);
-+	r = pci_enable_device(pdev);
-+	if (r)
-+		return r;
-+	pci_restore_state(pdev);
-+
-+	return iwl_pci_resume(&pdev->dev);
-+}
-+EXPORT_SYMBOL(iwl_pci_resume_compat);
-+#endif
-+
 +const SIMPLE_DEV_PM_OPS(iwl_pm_ops, iwl_pci_suspend, iwl_pci_resume);
 +
++compat_pci_suspend(iwl_pci_suspend)
++compat_pci_resume(iwl_pci_resume)
++
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
  EXPORT_SYMBOL(iwl_pm_ops);
++#else
++EXPORT_SYMBOL(iwl_pci_suspend_compat);
++EXPORT_SYMBOL(iwl_pci_resume_compat);
 +#endif
  
  #endif /* CONFIG_PM */
@@ -165,53 +164,3 @@ calls on compat code with only slight modifications.
  };
  
  static int __init iwl3945_init(void)
---- a/drivers/net/wireless/ath/ath5k/pci.c
-+++ b/drivers/net/wireless/ath/ath5k/pci.c
-@@ -286,6 +286,34 @@ static int ath5k_pci_resume(struct devic
- 	return 0;
- }
- 
-+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29))
-+static int ath5k_pci_suspend_compat(struct pci_dev *pdev, pm_message_t state)
-+{
-+	int r;
-+
-+	r = ath5k_pci_suspend(&pdev->dev);
-+	if (r)
-+		return r;
-+
-+	pci_save_state(pdev);
-+	pci_disable_device(pdev);
-+	pci_set_power_state(pdev, PCI_D3hot);
-+	return 0;
-+}
-+
-+static int ath5k_pci_resume_compat(struct pci_dev *pdev)
-+{
-+	int r;
-+
-+	pci_restore_state(pdev);
-+	r = pci_enable_device(pdev);
-+	if (r)
-+		return r;
-+
-+	return ath5k_pci_resume(&pdev->dev);
-+}
-+#endif
-+
- static SIMPLE_DEV_PM_OPS(ath5k_pm_ops, ath5k_pci_suspend, ath5k_pci_resume);
- #define ATH5K_PM_OPS	(&ath5k_pm_ops)
- #else
-@@ -297,7 +325,12 @@ static struct pci_driver ath5k_pci_drive
- 	.id_table	= ath5k_pci_id_table,
- 	.probe		= ath5k_pci_probe,
- 	.remove		= __devexit_p(ath5k_pci_remove),
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
- 	.driver.pm	= ATH5K_PM_OPS,
-+#elif defined(CONFIG_PM_SLEEP)
-+	.suspend        = ath5k_pci_suspend_compat,
-+	.resume         = ath5k_pci_resume_compat,
-+#endif
- };
- 
- /*
-- 
1.7.1

