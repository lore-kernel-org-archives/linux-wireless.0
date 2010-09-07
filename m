Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49491 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756511Ab0IGL3o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Sep 2010 07:29:44 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-wireless@vger.kernel.org>, <linux-mmc@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	<akpm@linux-foundation.org>, San Mehat <san@google.com>,
	Roger Quadros <roger.quadros@nokia.com>,
	Nicolas Pitre <nico@fluxnic.net>,
	Gao Yunpeng <yunpeng.gao@intel.com>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH v1 4/8] mmc: add general Runtime PM support
Date: Tue,  7 Sep 2010 14:29:05 +0300
Message-Id: <1283858949-11073-5-git-send-email-ohad@wizery.com>
In-Reply-To: <1283858949-11073-1-git-send-email-ohad@wizery.com>
References: <1283858949-11073-1-git-send-email-ohad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add runtime PM handlers to mmc, which call mmc_power_save_host
and mmc_power_restore_host in response to runtime_suspend and
runtime_resume events.

Runtime PM is still disabled by default, so this patch alone
has no immediate effect.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/mmc/core/bus.c |   37 +++++++++++++++++++++++++++++++++++++
 1 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/core/bus.c b/drivers/mmc/core/bus.c
index 7cd9749..a302e57 100644
--- a/drivers/mmc/core/bus.c
+++ b/drivers/mmc/core/bus.c
@@ -14,6 +14,7 @@
 #include <linux/device.h>
 #include <linux/err.h>
 #include <linux/slab.h>
+#include <linux/pm_runtime.h>
 
 #include <linux/mmc/card.h>
 #include <linux/mmc/host.h>
@@ -142,6 +143,41 @@ static int mmc_bus_resume(struct device *dev)
 	return ret;
 }
 
+#ifdef CONFIG_PM_RUNTIME
+
+static int mmc_runtime_suspend(struct device *dev)
+{
+	struct mmc_card *card = dev_to_mmc_card(dev);
+
+	return mmc_power_save_host(card->host);
+}
+
+static int mmc_runtime_resume(struct device *dev)
+{
+	struct mmc_card *card = dev_to_mmc_card(dev);
+
+	return mmc_power_restore_host(card->host);
+}
+
+static int mmc_runtime_idle(struct device *dev)
+{
+	return pm_runtime_suspend(dev);
+}
+
+static const struct dev_pm_ops mmc_bus_pm_ops = {
+	.runtime_suspend	= mmc_runtime_suspend,
+	.runtime_resume		= mmc_runtime_resume,
+	.runtime_idle		= mmc_runtime_idle,
+};
+
+#define MMC_PM_OPS_PTR	(&mmc_bus_pm_ops)
+
+#else /* !CONFIG_PM_RUNTIME */
+
+#define MMC_PM_OPS_PTR	NULL
+
+#endif /* !CONFIG_PM_RUNTIME */
+
 static struct bus_type mmc_bus_type = {
 	.name		= "mmc",
 	.dev_attrs	= mmc_dev_attrs,
@@ -151,6 +187,7 @@ static struct bus_type mmc_bus_type = {
 	.remove		= mmc_bus_remove,
 	.suspend	= mmc_bus_suspend,
 	.resume		= mmc_bus_resume,
+	.pm		= MMC_PM_OPS_PTR,
 };
 
 int mmc_register_bus(void)
-- 
1.7.0.4

