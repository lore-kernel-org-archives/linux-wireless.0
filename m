Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:43471 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756214Ab1GQU5l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jul 2011 16:57:41 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat-wireless: deactivate sido suspend for brcmfmac on older kernels.
Date: Sun, 17 Jul 2011 22:57:30 +0200
Message-Id: <1310936250-10224-2-git-send-email-hauke@hauke-m.de> (sfid-20110717_225747_773010_A64B2A7D)
In-Reply-To: <1310936250-10224-1-git-send-email-hauke@hauke-m.de>
References: <1310936250-10224-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/29-sdio_no_suspend.patch |   38 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/patches/29-sdio_no_suspend.patch b/patches/29-sdio_no_suspend.patch
index d6a6713..e940745 100644
--- a/patches/29-sdio_no_suspend.patch
+++ b/patches/29-sdio_no_suspend.patch
@@ -84,3 +84,41 @@ suspend and resume that are not backported.
  	}
  };
  
+--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
++++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+@@ -127,7 +127,7 @@ static int brcmf_ops_sdio_probe(struct s
+ 				const struct sdio_device_id *id);
+ static void brcmf_ops_sdio_remove(struct sdio_func *func);
+ 
+-#ifdef CONFIG_PM
++#if defined(CONFIG_PM) && (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
+ static int brcmf_sdio_suspend(struct device *dev);
+ static int brcmf_sdio_resume(struct device *dev);
+ #endif /* CONFIG_PM */
+@@ -157,7 +157,7 @@ static const struct sdio_device_id brcmf
+ 	{ /* end: all zeroes */ },
+ };
+ 
+-#ifdef CONFIG_PM
++#if defined(CONFIG_PM) && (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
+ static const struct dev_pm_ops brcmf_sdio_pm_ops = {
+ 	.suspend	= brcmf_sdio_suspend,
+ 	.resume		= brcmf_sdio_resume,
+@@ -169,7 +169,7 @@ static struct sdio_driver brcmf_sdmmc_dr
+ 	.remove = brcmf_ops_sdio_remove,
+ 	.name = "brcmfmac",
+ 	.id_table = brcmf_sdmmc_ids,
+-#ifdef CONFIG_PM
++#if defined(CONFIG_PM) && (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
+ 	.drv = {
+ 		.pm = &brcmf_sdio_pm_ops,
+ 	},
+@@ -1081,7 +1081,7 @@ static void brcmf_ops_sdio_remove(struct
+ }
+ 
+ 
+-#ifdef CONFIG_PM
++#if defined(CONFIG_PM) && (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
+ static int brcmf_sdio_suspend(struct device *dev)
+ {
+ 	mmc_pm_flag_t sdio_flags;
-- 
1.7.4.1

