Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:34030 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758648Ab1CaQWh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2011 12:22:37 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
	Vasily Khoruzhick <anarsoul@gmail.com>
Subject: [PATCH 3/5] compat-wirless: deactivate PM support for libertas_spi for kernel < 2.6.29
Date: Thu, 31 Mar 2011 18:22:05 +0200
Message-Id: <1301588527-16615-3-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1301588527-16615-1-git-send-email-hauke@hauke-m.de>
References: <1301588527-16615-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The power management interface changed in kernel 2.6.29 and this breaks
build on older kernels.

CC: Vasily Khoruzhick <anarsoul@gmail.com>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/11-dev-pm-ops.patch |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/patches/11-dev-pm-ops.patch b/patches/11-dev-pm-ops.patch
index 2922f7a..25759f5 100644
--- a/patches/11-dev-pm-ops.patch
+++ b/patches/11-dev-pm-ops.patch
@@ -117,6 +117,34 @@ calls on compat code with only slight modifications.
  };
  
  int ath_pci_init(void)
+--- a/drivers/net/wireless/libertas/if_spi.c
++++ b/drivers/net/wireless/libertas/if_spi.c
+@@ -1204,6 +1204,7 @@ static int __devexit libertas_spi_remove
+ 	return 0;
+ }
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+ static int if_spi_suspend(struct device *dev)
+ {
+ 	struct spi_device *spi = to_spi_device(dev);
+@@ -1237,6 +1238,7 @@ static const struct dev_pm_ops if_spi_pm
+ 	.suspend	= if_spi_suspend,
+ 	.resume		= if_spi_resume,
+ };
++#endif
+ 
+ static struct spi_driver libertas_spi_driver = {
+ 	.probe	= if_spi_probe,
+@@ -1245,7 +1247,9 @@ static struct spi_driver libertas_spi_dr
+ 		.name	= "libertas_spi",
+ 		.bus	= &spi_bus_type,
+ 		.owner	= THIS_MODULE,
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+ 		.pm	= &if_spi_pm_ops,
++#endif
+ 	},
+ };
+ 
 --- a/drivers/net/wireless/iwlegacy/iwl-core.c
 +++ b/drivers/net/wireless/iwlegacy/iwl-core.c
 @@ -2048,15 +2048,17 @@ int iwl_legacy_pci_resume(struct device
-- 
1.7.1

