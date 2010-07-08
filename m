Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:44986 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753498Ab0GHVN5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jul 2010 17:13:57 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat-wireless: fix build problems
Date: Thu,  8 Jul 2010 23:13:48 +0200
Message-Id: <1278623628-25477-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1278623628-25477-1-git-send-email-hauke@hauke-m.de>
References: <1278623628-25477-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix some minor build problems in patch.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/28-pm-qos-params.patch |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/patches/28-pm-qos-params.patch b/patches/28-pm-qos-params.patch
index c5f8fd2..438bdd8 100644
--- a/patches/28-pm-qos-params.patch
+++ b/patches/28-pm-qos-params.patch
@@ -47,9 +47,9 @@ little wierd.
  	spin_unlock_irqrestore(&priv->low_lock, flags);
  
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
-+	pm_qos_update_request(ipw2100_pm_qos_req, PM_QOS_DEFAULT_VALUE);
-+#elif (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
  	pm_qos_update_request(&ipw2100_pm_qos_req, PM_QOS_DEFAULT_VALUE);
++#elif (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
++	pm_qos_update_request(ipw2100_pm_qos_req, PM_QOS_DEFAULT_VALUE);
 +#else
 +	pm_qos_update_requirement(PM_QOS_CPU_DMA_LATENCY, "ipw2100",
 +				  PM_QOS_DEFAULT_VALUE);
@@ -83,7 +83,7 @@ little wierd.
 +#elif (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
 +	pm_qos_remove_request(ipw2100_pm_qos_req);
 +#else
-+	pm_qos_remove_requirement(PM_QOS_CPU_DMA_LATENCY, "ipw2100")
++	pm_qos_remove_requirement(PM_QOS_CPU_DMA_LATENCY, "ipw2100");
 +#endif
  }
  
-- 
1.7.0.4

