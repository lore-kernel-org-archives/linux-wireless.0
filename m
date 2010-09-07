Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49491 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756521Ab0IGL3r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Sep 2010 07:29:47 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-wireless@vger.kernel.org>, <linux-mmc@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	<akpm@linux-foundation.org>, San Mehat <san@google.com>,
	Roger Quadros <roger.quadros@nokia.com>,
	Nicolas Pitre <nico@fluxnic.net>,
	Gao Yunpeng <yunpeng.gao@intel.com>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH v1 5/8] sdio: add general runtime PM support
Date: Tue,  7 Sep 2010 14:29:06 +0300
Message-Id: <1283858949-11073-6-git-send-email-ohad@wizery.com>
In-Reply-To: <1283858949-11073-1-git-send-email-ohad@wizery.com>
References: <1283858949-11073-1-git-send-email-ohad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add generic runtime PM handlers to sdio.

Those handlers invoke the relevant SDIO function drivers' handlers, if
such exist. If not they just return success.

Runtime PM is still disabled by default, so this patch alone
has no immediate effect.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/mmc/core/sdio_bus.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/core/sdio_bus.c b/drivers/mmc/core/sdio_bus.c
index 4a890dc..256a968 100644
--- a/drivers/mmc/core/sdio_bus.c
+++ b/drivers/mmc/core/sdio_bus.c
@@ -14,6 +14,7 @@
 #include <linux/device.h>
 #include <linux/err.h>
 #include <linux/slab.h>
+#include <linux/pm_runtime.h>
 
 #include <linux/mmc/card.h>
 #include <linux/mmc/sdio_func.h>
@@ -154,6 +155,24 @@ static int sdio_bus_remove(struct device *dev)
 	return 0;
 }
 
+#ifdef CONFIG_PM_RUNTIME
+
+static const struct dev_pm_ops sdio_bus_pm_ops = {
+	SET_RUNTIME_PM_OPS(
+		pm_generic_runtime_suspend,
+		pm_generic_runtime_resume,
+		pm_generic_runtime_idle
+	)
+};
+
+#define SDIO_PM_OPS_PTR	(&sdio_bus_pm_ops)
+
+#else /* !CONFIG_PM_RUNTIME */
+
+#define SDIO_PM_OPS_PTR	NULL
+
+#endif /* !CONFIG_PM_RUNTIME */
+
 static struct bus_type sdio_bus_type = {
 	.name		= "sdio",
 	.dev_attrs	= sdio_dev_attrs,
@@ -161,6 +180,7 @@ static struct bus_type sdio_bus_type = {
 	.uevent		= sdio_bus_uevent,
 	.probe		= sdio_bus_probe,
 	.remove		= sdio_bus_remove,
+	.pm		= SDIO_PM_OPS_PTR,
 };
 
 int sdio_register_bus(void)
-- 
1.7.0.4

