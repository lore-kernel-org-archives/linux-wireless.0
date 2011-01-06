Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:4184 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410Ab1AFVnn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jan 2011 16:43:43 -0500
From: Tim Gardner <tim.gardner@canonical.com>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Tim Gardner <tim.gardner@canonical.com>
Subject: [PATCH] compat-wireless linux-2.6.37.y, fix compile error for pm_qos_add_request()
Date: Thu,  6 Jan 2011 14:18:45 -0700
Message-Id: <1294348725-31239-1-git-send-email-tim.gardner@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rtg
----
>From 927d0fb9413a2822c7465b4f2408b16acb24d7c5 Mon Sep 17 00:00:00 2001
From: Tim Gardner <tim.gardner@canonical.com>
Date: Thu, 6 Jan 2011 12:07:37 -0700
Subject: [PATCH] compat-wireless: pm_qos_add_request() was changed for 2.6.35

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 patches/28-pm-qos-params.patch |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/patches/28-pm-qos-params.patch b/patches/28-pm-qos-params.patch
index efe3926..7c9dd9e 100644
--- a/patches/28-pm-qos-params.patch
+++ b/patches/28-pm-qos-params.patch
@@ -20,9 +20,9 @@ little wierd.
  #define DRV_DESCRIPTION	"Intel(R) PRO/Wireless 2100 Network Driver"
  #define DRV_COPYRIGHT	"Copyright(c) 2003-2006 Intel Corporation"
  
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
  static struct pm_qos_request_list ipw2100_pm_qos_req;
-+#elif (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
++#else
 +static struct pm_qos_request_list *ipw2100_pm_qos_req;
 +#endif
  
@@ -32,9 +32,9 @@ little wierd.
  	/* the ipw2100 hardware really doesn't want power management delays
  	 * longer than 175usec
  	 */
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
  	pm_qos_update_request(&ipw2100_pm_qos_req, 175);
-+#elif (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
++#elif (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
 +	pm_qos_update_request(ipw2100_pm_qos_req, 175);
 +#else
 +	pm_qos_update_requirement(PM_QOS_CPU_DMA_LATENCY, "ipw2100", 175);
@@ -46,9 +46,9 @@ little wierd.
  	ipw2100_disable_interrupts(priv);
  	spin_unlock_irqrestore(&priv->low_lock, flags);
  
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
  	pm_qos_update_request(&ipw2100_pm_qos_req, PM_QOS_DEFAULT_VALUE);
-+#elif (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
++#elif (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
 +	pm_qos_update_request(ipw2100_pm_qos_req, PM_QOS_DEFAULT_VALUE);
 +#else
 +	pm_qos_update_requirement(PM_QOS_CPU_DMA_LATENCY, "ipw2100",
@@ -61,10 +61,10 @@ little wierd.
  	printk(KERN_INFO DRV_NAME ": %s, %s\n", DRV_DESCRIPTION, DRV_VERSION);
  	printk(KERN_INFO DRV_NAME ": %s\n", DRV_COPYRIGHT);
  
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
  	pm_qos_add_request(&ipw2100_pm_qos_req, PM_QOS_CPU_DMA_LATENCY,
  			   PM_QOS_DEFAULT_VALUE);
-+#elif (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
++#elif (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
 +	ipw2100_pm_qos_req = pm_qos_add_request(PM_QOS_CPU_DMA_LATENCY,
 +						PM_QOS_DEFAULT_VALUE);
 +#else
@@ -78,9 +78,9 @@ little wierd.
  			   &driver_attr_debug_level);
  #endif
  	pci_unregister_driver(&ipw2100_pci_driver);
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
  	pm_qos_remove_request(&ipw2100_pm_qos_req);
-+#elif (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
++#elif (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
 +	pm_qos_remove_request(ipw2100_pm_qos_req);
 +#else
 +	pm_qos_remove_requirement(PM_QOS_CPU_DMA_LATENCY, "ipw2100");
-- 
1.7.0.4

