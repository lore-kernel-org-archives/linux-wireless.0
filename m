Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpe-075-189-159-031.nc.res.rr.com ([75.189.159.31]:44243 "EHLO
	jgpicker.rdu.redhat.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754395Ab3EMQoS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 May 2013 12:44:18 -0400
From: John Greene <jogreene@redhat.com>
To: rhkernel-list@redhat.com
Cc: John Greene <jogreene@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org,
	Yuanhan Liu <yuanhan.liu@linux.intel.com>,
	Fengguang Wu <fengguang.wu@intel.com>
Subject: [RHEL 6.5 PATCH 087/176] bcma: suspend/resume callbacks should be conditionally compiled on CONFIG_PM_SLEEP
Date: Mon, 13 May 2013 11:45:49 -0400
Message-Id: <1368460038-21195-88-git-send-email-jogreene@redhat.com> (sfid-20130513_184421_956755_CBCA996E)
In-Reply-To: <1368460038-21195-1-git-send-email-jogreene@redhat.com>
References: <1368460038-21195-1-git-send-email-jogreene@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bugzilla: 757944
Brew: <https://brewweb.devel.redhat.com/taskinfo?taskID=5738553>
Upstream Status: ccd609538e99d3465a8d498f3655098f44cd253b
Tested: By me. Acceptable. See BZ for details

This will fix warnings like following when CONFIG_PM_SLEEP is not set:

        warning: 'xxx_suspend' defined but not used [-Wunused-function]
        warning: 'xxx_resume' defined but not used [-Wunused-function]

Because
	SET_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn)

Only references the callbacks on CONFIG_PM_SLEEP (instead of CONFIG_PM).

Cc: John W. Linville <linville@tuxdriver.com>
Cc: "Rafał Miłecki" <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org
Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/bcma/host_pci.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/bcma/host_pci.c b/drivers/bcma/host_pci.c
index b6b4b5e..98fdc3e 100644
--- a/drivers/bcma/host_pci.c
+++ b/drivers/bcma/host_pci.c
@@ -238,7 +238,7 @@ static void __devexit bcma_host_pci_remove(struct pci_dev *dev)
 	pci_set_drvdata(dev, NULL);
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int bcma_host_pci_suspend(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
@@ -261,11 +261,11 @@ static SIMPLE_DEV_PM_OPS(bcma_pm_ops, bcma_host_pci_suspend,
 			 bcma_host_pci_resume);
 #define BCMA_PM_OPS	(&bcma_pm_ops)
 
-#else /* CONFIG_PM */
+#else /* CONFIG_PM_SLEEP */
 
 #define BCMA_PM_OPS     NULL
 
-#endif /* CONFIG_PM */
+#endif /* CONFIG_PM_SLEEP */
 
 static DEFINE_PCI_DEVICE_TABLE(bcma_pci_bridge_tbl) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x0576) },
-- 
1.7.11.7

