Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:43933 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753634Ab2E2WkP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 18:40:15 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 7/8] compat-wireless: add bluetooth to sdio suspend remove patch
Date: Wed, 30 May 2012 00:39:41 +0200
Message-Id: <1338331182-29589-8-git-send-email-hauke@hauke-m.de> (sfid-20120530_004025_325756_9DE8F5C1)
In-Reply-To: <1338331182-29589-1-git-send-email-hauke@hauke-m.de>
References: <1338331182-29589-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/29-sdio_no_suspend.patch |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/patches/29-sdio_no_suspend.patch b/patches/29-sdio_no_suspend.patch
index 4d4986c..2a47d37 100644
--- a/patches/29-sdio_no_suspend.patch
+++ b/patches/29-sdio_no_suspend.patch
@@ -169,3 +169,31 @@ suspend and resume that are not backported.
  	.drv = {
  		.pm = &brcmf_sdio_pm_ops,
  	},
+--- a/drivers/bluetooth/btmrvl_sdio.c
++++ b/drivers/bluetooth/btmrvl_sdio.c
+@@ -1049,6 +1049,7 @@ static void btmrvl_sdio_remove(struct sd
+ 	}
+ }
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
+ static int btmrvl_sdio_suspend(struct device *dev)
+ {
+ 	struct sdio_func *func = dev_to_sdio_func(dev);
+@@ -1144,6 +1145,7 @@ static const struct dev_pm_ops btmrvl_sd
+ 	.suspend	= btmrvl_sdio_suspend,
+ 	.resume		= btmrvl_sdio_resume,
+ };
++#endif
+ 
+ static struct sdio_driver bt_mrvl_sdio = {
+ 	.name		= "btmrvl_sdio",
+@@ -1152,7 +1154,9 @@ static struct sdio_driver bt_mrvl_sdio =
+ 	.remove		= btmrvl_sdio_remove,
+ 	.drv = {
+ 		.owner = THIS_MODULE,
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
+ 		.pm = &btmrvl_sdio_pm_ops,
++#endif
+ 	}
+ };
+ 
-- 
1.7.9.5

