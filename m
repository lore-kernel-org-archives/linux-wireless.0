Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40032 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186AbZJGGbS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Oct 2009 02:31:18 -0400
Date: Wed, 7 Oct 2009 02:30:39 -0400
From: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Hin-Tak Leung <hintak.leung@gmail.com>,
	linux-wireless@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] compat-2.6: adding ethtool.h to compat-2.6.31.h
Message-ID: <20091007063039.GA19944@bombadil.infradead.org>
References: <1254886762-17211-1-git-send-email-HinTak.Leung@gmail.com> <3ace41890910062045s626777dew4b47fe18bc8d9aee@mail.gmail.com> <43e72e890910062241k3c4660eaobbcee4456485be93@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <43e72e890910062241k3c4660eaobbcee4456485be93@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 07, 2009 at 01:41:08AM -0400, Luis R. Rodriguez wrote:
> On Tue, Oct 6, 2009 at 11:45 PM, Hin-Tak Leung <hintak.leung@gmail.com> wrote:
> 
> > warning: type defaults to ‘int’ in declaration of ‘SIMPLE_DEV_PM_OPS’
> 
> Yeah we need to backport this stuff, it seems all drivers are intended
> to be moved to use these simple dev pm ops so we might as well.

OK I just committed this patch as a quick attempt to backport this. Testers
welcomed. You'll need the ethtool patch from Hin-Tak as John hasn't yet applied
his own on wireless-testing.

From: Luis R. Rodriguez <lrodriguez@atheros.com>
Subject: [PATCH] compat-2.6: backport dev_pm_ops stuff and SIMPLE_DEV_PM_OPS

The 2.6.29 kernel has new struct dev_pm_ops [1] which are used
on the pci device to distinguish power management hooks for suspend
to RAM and hibernation. Older kernels don't have these so we need
to resort back to the good ol' suspend/resume. Fortunately the calls
are not so different so it should be possible to resuse the same
calls on compat code with only slight modifications.

The SIMPLE_DEV_PM_OPS macro is used as a helper to make the regular
suspend/resume calls be linked to the equivalent hibernation calls
as that is the same behaviour in older kernels. We backport
SIMPLE_DEV_PM_OPS only for kernels 2.6.29..2.6.31 and for older
kernels this is a no-op.

[1] http://lxr.linux.no/#linux+v2.6.29/include/linux/pm.h#L170

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 compat/compat-2.6.32.h             |   26 ++++++++++++++++
 compat/patches/11-dev-pm-ops.patch |   57 ++++++++++++++++++++++++++++++++++++
 2 files changed, 83 insertions(+), 0 deletions(-)
 create mode 100644 compat/patches/11-dev-pm-ops.patch

diff --git a/compat/compat-2.6.32.h b/compat/compat-2.6.32.h
index 418b521..9c2dba9 100644
--- a/compat/compat-2.6.32.h
+++ b/compat/compat-2.6.32.h
@@ -8,6 +8,7 @@
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,32))
 
 #include <linux/netdevice.h>
+#include <linux/pm.h>
 
 #define SDIO_VENDOR_ID_INTEL			0x0089
 #define SDIO_DEVICE_ID_INTEL_IWMC3200WIMAX	0x1402
@@ -43,6 +44,31 @@ enum netdev_tx {
 typedef enum netdev_tx netdev_tx_t;
 #endif /* __KERNEL__ */
 
+
+/*
+ * dev_pm_ops is only available on kernels >= 2.6.29, for
+ * older kernels we rely on reverting the work to old
+ * power management style stuff.
+ */
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+/*
+ * Use this if you want to use the same suspend and resume callbacks for suspend
+ * to RAM and hibernation.
+ */
+#define SIMPLE_DEV_PM_OPS(name, suspend_fn, resume_fn) \
+struct dev_pm_ops name = { \
+	.suspend = suspend_fn, \
+	.resume = resume_fn, \
+	.freeze = suspend_fn, \
+	.thaw = resume_fn, \
+	.poweroff = suspend_fn, \
+	.restore = resume_fn, \
+}
+#else
+#define SIMPLE_DEV_PM_OPS(name, suspend_fn, resume_fn)
+#endif /* >= 2.6.29 */
+
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,32)) */
 
 #endif /* LINUX_26_32_COMPAT_H */
diff --git a/compat/patches/11-dev-pm-ops.patch b/compat/patches/11-dev-pm-ops.patch
new file mode 100644
index 0000000..e01eafc
--- /dev/null
+++ b/compat/patches/11-dev-pm-ops.patch
@@ -0,0 +1,57 @@
+The 2.6.29 kernel has new struct dev_pm_ops [1] which are used
+on the pci device to distinguish power management hooks for suspend
+to RAM and hibernation. Older kernels don't have these so we need
+to resort back to the good ol' suspend/resume. Fortunately the calls
+are not so different so it should be possible to resuse the same
+calls on compat code with only slight modifications.
+
+[1] http://lxr.linux.no/#linux+v2.6.29/include/linux/pm.h#L170
+
+--- a/drivers/net/wireless/ath/ath5k/base.c	2009-10-07 01:58:19.000000000 -0400
++++ b/drivers/net/wireless/ath/ath5k/base.c	2009-10-07 02:19:58.000000000 -0400
+@@ -197,6 +197,32 @@
+ #ifdef CONFIG_PM
+ static int		ath5k_pci_suspend(struct device *dev);
+ static int		ath5k_pci_resume(struct device *dev);
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29))
++#endif
++static int ath5k_pci_suspend_compat(struct pci_dev *pdev, pm_message_t state)
++{
++	int r;
++
++	r = ath5k_pci_suspend(pdev->dev);
++	if (r)
++		return r;
++
++	pci_save_state(pdev);
++	pci_disable_device(pdev);
++	pci_set_power_state(pdev, PCI_D3hot);
++}
++
++static int ath5k_pci_resume_compat(struct pci_dev *pdev)
++{
++	int r;
++
++	pci_restore_state(pdev);
++	r = pci_enable_device(pdev);
++	if (r)
++		return r;
++
++	return ath5k_pci_resume(pdev->dev);
++}
+ 
+ SIMPLE_DEV_PM_OPS(ath5k_pm_ops, ath5k_pci_suspend, ath5k_pci_resume);
+ #define ATH5K_PM_OPS	(&ath5k_pm_ops)
+@@ -209,7 +235,12 @@
+ 	.id_table	= ath5k_pci_id_table,
+ 	.probe		= ath5k_pci_probe,
+ 	.remove		= __devexit_p(ath5k_pci_remove),
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+ 	.driver.pm	= ATH5K_PM_OPS,
++#else
++	.suspend        = ath5k_pci_suspend_compat,
++	.resume         = ath5k_pci_resume_compat,
++#endif
+ };
+ 
+ 
-- 
1.6.0.4

