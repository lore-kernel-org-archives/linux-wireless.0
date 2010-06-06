Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:40558 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754361Ab0FFJMQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jun 2010 05:12:16 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/3] compat-wireless: deactivate libertas sdio suspend for < 2.6.34
Date: Sun,  6 Jun 2010 11:11:56 +0200
Message-Id: <1275815518-30281-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

libertas sdio suspend and resume depends on some new features of the
sdio framework in kernel 2.6.34.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/29-libertas_sdio_no_suspend.patch |   34 +++++++++++++++++++++++++++++
 1 files changed, 34 insertions(+), 0 deletions(-)
 create mode 100644 patches/29-libertas_sdio_no_suspend.patch

diff --git a/patches/29-libertas_sdio_no_suspend.patch b/patches/29-libertas_sdio_no_suspend.patch
new file mode 100644
index 0000000..f5dc993
--- /dev/null
+++ b/patches/29-libertas_sdio_no_suspend.patch
@@ -0,0 +1,34 @@
+Starting with commit 66fceb69b72ff7e9cd8da2ca70033982d5376e0e
+"libertas: Added callback functions to support SDIO suspend/resume."
+libertas uses new functions from the in kernel sdio framework for
+suspend and resume that are not backported.
+
+--- a/drivers/net/wireless/libertas/if_sdio.c
++++ b/drivers/net/wireless/libertas/if_sdio.c
+@@ -1212,6 +1212,7 @@ static void if_sdio_remove(struct sdio_f
+ 	lbs_deb_leave(LBS_DEB_SDIO);
+ }
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
+ static int if_sdio_suspend(struct device *dev)
+ {
+ 	struct sdio_func *func = dev_to_sdio_func(dev);
+@@ -1266,15 +1267,18 @@ static const struct dev_pm_ops if_sdio_p
+ 	.suspend	= if_sdio_suspend,
+ 	.resume		= if_sdio_resume,
+ };
++#endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34)) */
+ 
+ static struct sdio_driver if_sdio_driver = {
+ 	.name		= "libertas_sdio",
+ 	.id_table	= if_sdio_ids,
+ 	.probe		= if_sdio_probe,
+ 	.remove		= if_sdio_remove,
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
+ 	.drv = {
+ 		.pm = &if_sdio_pm_ops,
+ 	},
++#endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34)) */
+ };
+ 
+ /*******************************************************************/
-- 
1.7.0.4

