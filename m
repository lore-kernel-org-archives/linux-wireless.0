Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:34000 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754370Ab1GRRhS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2011 13:37:18 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, arend@broadcom.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v2 2/2] compat-wireless: deactivate sido suspend for brcmfmac on older kernels.
Date: Mon, 18 Jul 2011 19:36:13 +0200
Message-Id: <1311010573-17015-1-git-send-email-hauke@hauke-m.de> (sfid-20110718_193722_940542_183052BB)
In-Reply-To: <4E240E32.2020109@broadcom.com>
References: <4E240E32.2020109@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With this patch the build does not break any more because of this commit:

commit da68c4eb258cd9f3f0b8aeb7e46b8118bb6358b6
Author: Nicolas Pitre <nico@fluxnic.net>
Date:   Fri Mar 5 13:43:31 2010 -0800

    sdio: introduce API for special power management features

This build error occurs without the patch on linux-2.6.32.
/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c: In function ‘brcmf_sdio_suspend’:
/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c:1087:2: error: ‘mmc_pm_flag_t’ undeclared (first use in this function)
/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c:1087:2: note: each undeclared identifier is reported only once for each function it appears in
/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c:1087:16: error: expected ‘;’ before ‘sdio_flags’
/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c:1088:2: warning: ISO C90 forbids mixed declarations and code
/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c:1092:2: error: ‘sdio_flags’ undeclared (first use in this function)
/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c:1092:2: error: implicit declaration of function ‘sdio_get_host_pm_caps’

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---

If someone wants to backport the the SDIO API for special power management features it will be nice.

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

