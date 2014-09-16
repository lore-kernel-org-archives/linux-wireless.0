Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hauke-m.de ([5.39.93.123]:57354 "EHLO hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753944AbaIPV4d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2014 17:56:33 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Cc: zajec5@gmail.com, arend@broadcom.com,
	linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
	devicetree@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v2 2/2] bcma: get IRQ numbers from dt
Date: Tue, 16 Sep 2014 23:56:22 +0200
Message-Id: <1410904582-6519-2-git-send-email-hauke@hauke-m.de> (sfid-20140916_235639_561381_754CB008)
In-Reply-To: <1410904582-6519-1-git-send-email-hauke@hauke-m.de>
References: <1410904582-6519-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is not possible to auto detect the irq numbers used by the cores on
an arm SoC. If bcma was registered with device tree it will search for
some device tree nodes with the irq number and add it to the core
configuration.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/main.c | 49 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 48 insertions(+), 1 deletion(-)

This is based on wireless-testing and should go into that tree.

changes since:
RFC:
 - add #ifdef CONFIG_OF

diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index e5d578c..b8731ee 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -10,6 +10,8 @@
 #include <linux/platform_device.h>
 #include <linux/bcma/bcma.h>
 #include <linux/slab.h>
+#include <linux/of_irq.h>
+#include <linux/of_address.h>
 
 MODULE_DESCRIPTION("Broadcom's specific AMBA driver");
 MODULE_LICENSE("GPL");
@@ -131,6 +133,45 @@ static bool bcma_is_core_needed_early(u16 core_id)
 	return false;
 }
 
+#ifdef CONFIG_OF
+static struct device_node *bcma_of_find_child_device(struct platform_device *parent,
+						     struct bcma_device *core)
+{
+	struct device_node *node;
+	u64 size;
+	const __be32 *reg;
+
+	if (!parent || !parent->dev.of_node)
+		return NULL;
+
+	for_each_child_of_node(parent->dev.of_node, node) {
+		reg = of_get_address(node, 0, &size, NULL);
+		if (!reg)
+			continue;
+		if (be32_to_cpup(reg) == core->addr)
+			return node;
+	}
+	return NULL;
+}
+
+static void bcma_of_fill_device(struct platform_device *parent,
+				struct bcma_device *core)
+{
+	struct device_node *node;
+
+	node = bcma_of_find_child_device(parent, core);
+	if (!node)
+		return;
+	core->dev.of_node = node;
+	core->irq = irq_of_parse_and_map(node, 0);
+}
+#else
+static void bcma_of_fill_device(struct platform_device *parent,
+				struct bcma_device *core)
+{
+}
+#endif /* CONFIG_OF */
+
 static void bcma_register_core(struct bcma_bus *bus, struct bcma_device *core)
 {
 	int err;
@@ -147,7 +188,13 @@ static void bcma_register_core(struct bcma_bus *bus, struct bcma_device *core)
 		break;
 	case BCMA_HOSTTYPE_SOC:
 		core->dev.dma_mask = &core->dev.coherent_dma_mask;
-		core->dma_dev = &core->dev;
+		if (bus->host_pdev) {
+			core->dma_dev = &bus->host_pdev->dev;
+			core->dev.parent = &bus->host_pdev->dev;
+			bcma_of_fill_device(bus->host_pdev, core);
+		} else {
+			core->dma_dev = &core->dev;
+		}
 		break;
 	case BCMA_HOSTTYPE_SDIO:
 		break;
-- 
1.9.1

