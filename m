Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:54666 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753892Ab0IDPHO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Sep 2010 11:07:14 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/5] compat-wireless: make atk6kl build with older kernels
Date: Sat,  4 Sep 2010 17:06:47 +0200
Message-Id: <1283612809-6798-4-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1283612809-6798-1-git-send-email-hauke@hauke-m.de>
References: <1283612809-6798-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now it will be build for kernel < 2.6.28. CONFIG_STAGING was introduced
with that kernel version.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk                               |    2 -
 patches/33-autoconf.patch               |   15 ++++++++++
 patches/34-backport-bin_attribute.patch |   47 +++++++++++++++++++++++++++++++
 3 files changed, 62 insertions(+), 2 deletions(-)
 create mode 100644 patches/33-autoconf.patch
 create mode 100644 patches/34-backport-bin_attribute.patch

diff --git a/config.mk b/config.mk
index 9991bfa..3e09763 100644
--- a/config.mk
+++ b/config.mk
@@ -490,7 +490,6 @@ CONFIG_BT_HCIBTSDIO=m
 CONFIG_BT_MRVL_SDIO=m
 
 ifneq ($(CONFIG_COMPAT_STAGING),)
-ifdef CONFIG_COMPAT_KERNEL_32
 CONFIG_ATH6KL_CFG80211=y
 CONFIG_ATH6KL_DEBUG=y
 # CONFIG_ATH6KL_DISABLE_TARGET_DBGLOGS is not set
@@ -502,7 +501,6 @@ CONFIG_ATH6KL_ENABLE_TARGET_DEBUG_PRINTS=y
 # CONFIG_ATH6KL_SKIP_ABI_VERSION_CHECK is not set
 CONFIG_ATH6KL_VIRTUAL_SCATTER_GATHER=y
 CONFIG_ATH6K_LEGACY=m
-endif #CONFIG_COMPAT_KERNEL_32
 endif #CONFIG_MMC
 
 
diff --git a/patches/33-autoconf.patch b/patches/33-autoconf.patch
new file mode 100644
index 0000000..5d767fd
--- /dev/null
+++ b/patches/33-autoconf.patch
@@ -0,0 +1,15 @@
+--- a/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
++++ b/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
+@@ -27,7 +27,12 @@
+ #include <linux/version.h>
+ 
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,33))
+ #include <generated/autoconf.h>
++#else
++#include <linux/autoconf.h>
++#endif
++#include <linux/compat_autoconf.h>
+ #include <linux/init.h>
+ #include <linux/kernel.h>
+ #include <linux/sched.h>
diff --git a/patches/34-backport-bin_attribute.patch b/patches/34-backport-bin_attribute.patch
new file mode 100644
index 0000000..ce53635
--- /dev/null
+++ b/patches/34-backport-bin_attribute.patch
@@ -0,0 +1,47 @@
+--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
++++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+@@ -334,12 +334,20 @@ static void ar6000_refill_amsdu_rxbufs(A
+ static void ar6000_cleanup_amsdu_rxbufs(AR_SOFTC_T *ar);
+ 
+ static ssize_t
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,34))
+ ar6000_sysfs_bmi_read(struct file *fp, struct kobject *kobj,
++#else
++ar6000_sysfs_bmi_read(struct kobject *kobj,
++#endif
+                       struct bin_attribute *bin_attr,
+                       char *buf, loff_t pos, size_t count);
+ 
+ static ssize_t
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,34))
+ ar6000_sysfs_bmi_write(struct file *fp, struct kobject *kobj,
++#else
++ar6000_sysfs_bmi_write(struct kobject *kobj,
++#endif
+                        struct bin_attribute *bin_attr,
+                        char *buf, loff_t pos, size_t count);
+ 
+@@ -799,7 +807,11 @@ static struct bin_attribute bmi_attr = {
+ };
+ 
+ static ssize_t
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,34))
+ ar6000_sysfs_bmi_read(struct file *fp, struct kobject *kobj,
++#else
++ar6000_sysfs_bmi_read(struct kobject *kobj,
++#endif
+                       struct bin_attribute *bin_attr,
+                       char *buf, loff_t pos, size_t count)
+ {
+@@ -826,7 +838,11 @@ ar6000_sysfs_bmi_read(struct file *fp, s
+ }
+ 
+ static ssize_t
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,34))
+ ar6000_sysfs_bmi_write(struct file *fp, struct kobject *kobj,
++#else
++ar6000_sysfs_bmi_write(struct kobject *kobj,
++#endif
+                        struct bin_attribute *bin_attr,
+                        char *buf, loff_t pos, size_t count)
+ {
-- 
1.7.0.4

