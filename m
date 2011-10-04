Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:41075 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755800Ab1JDLLU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 07:11:20 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] compat-wireless: make patches apply again
Date: Tue,  4 Oct 2011 13:11:09 +0200
Message-Id: <1317726670-23319-1-git-send-email-hauke@hauke-m.de> (sfid-20111004_131124_199509_63F8F738)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/29-sdio_no_suspend.patch |   50 +++++++++++++++++++-------------------
 1 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/patches/29-sdio_no_suspend.patch b/patches/29-sdio_no_suspend.patch
index cb2fbed..5cc26a1 100644
--- a/patches/29-sdio_no_suspend.patch
+++ b/patches/29-sdio_no_suspend.patch
@@ -86,39 +86,39 @@ suspend and resume that are not backported.
  
 --- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
 +++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
-@@ -45,7 +45,7 @@ static int brcmf_ops_sdio_probe(struct s
- 				const struct sdio_device_id *id);
- static void brcmf_ops_sdio_remove(struct sdio_func *func);
- 
--#ifdef CONFIG_PM
-+#if defined(CONFIG_PM) && (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
- static int brcmf_sdio_suspend(struct device *dev);
- static int brcmf_sdio_resume(struct device *dev);
- #endif /* CONFIG_PM */
-@@ -58,7 +58,7 @@ static const struct sdio_device_id brcmf
- 	{ /* end: all zeroes */ },
- };
- 
+@@ -55,7 +55,7 @@ static bool
+ brcmf_pm_resume_error(struct brcmf_sdio_dev *sdiodev)
+ {
+ 	bool is_err = false;
 -#ifdef CONFIG_PM_SLEEP
 +#if defined(CONFIG_PM_SLEEP) && (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
- static const struct dev_pm_ops brcmf_sdio_pm_ops = {
- 	.suspend	= brcmf_sdio_suspend,
- 	.resume		= brcmf_sdio_resume,
-@@ -70,7 +70,7 @@ static struct sdio_driver brcmf_sdmmc_dr
- 	.remove = brcmf_ops_sdio_remove,
- 	.name = "brcmfmac",
- 	.id_table = brcmf_sdmmc_ids,
+ 	is_err = atomic_read(&sdiodev->suspend);
+ #endif
+ 	return is_err;
+@@ -64,7 +64,7 @@ brcmf_pm_resume_error(struct brcmf_sdio_
+ static void
+ brcmf_pm_resume_wait(struct brcmf_sdio_dev *sdiodev, wait_queue_head_t *wq)
+ {
 -#ifdef CONFIG_PM_SLEEP
 +#if defined(CONFIG_PM_SLEEP) && (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
- 	.drv = {
- 		.pm = &brcmf_sdio_pm_ops,
- 	},
-@@ -623,7 +623,7 @@ static void brcmf_ops_sdio_remove(struct
+ 	int retry = 0;
+ 	while (atomic_read(&sdiodev->suspend) && retry++ != 30)
+ 		wait_event_timeout(*wq, false, HZ/100);
+@@ -564,7 +564,7 @@ static void brcmf_ops_sdio_remove(struct
+ 	}
  }
  
- 
 -#ifdef CONFIG_PM_SLEEP
 +#if defined(CONFIG_PM_SLEEP) && (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
  static int brcmf_sdio_suspend(struct device *dev)
  {
  	mmc_pm_flag_t sdio_flags;
+@@ -617,7 +617,7 @@ static struct sdio_driver brcmf_sdmmc_dr
+ 	.remove = brcmf_ops_sdio_remove,
+ 	.name = "brcmfmac",
+ 	.id_table = brcmf_sdmmc_ids,
+-#ifdef CONFIG_PM_SLEEP
++#if defined(CONFIG_PM_SLEEP) && (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
+ 	.drv = {
+ 		.pm = &brcmf_sdio_pm_ops,
+ 	},
-- 
1.7.4.1

