Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:34727 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752352AbdA1WSW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 28 Jan 2017 17:18:22 -0500
Received: by mail-lf0-f67.google.com with SMTP id q89so28613736lfi.1
        for <linux-wireless@vger.kernel.org>; Sat, 28 Jan 2017 14:18:21 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH] bcma: make OF code more generic (not platform_device specific)
Date: Sat, 28 Jan 2017 23:11:34 +0100
Message-Id: <20170128221134.9028-1-zajec5@gmail.com> (sfid-20170128_231826_736508_74FF50BC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

OF allows not only specifying platform devices but also describing
devices on standard buses like PCI or USB. This change will allow
reading info from DT for bcma buses hosted on PCI cards.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/bcma/main.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index 38688236b3cd..12da68ec48ba 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -136,17 +136,17 @@ static bool bcma_is_core_needed_early(u16 core_id)
 	return false;
 }
 
-static struct device_node *bcma_of_find_child_device(struct platform_device *parent,
+static struct device_node *bcma_of_find_child_device(struct device *parent,
 						     struct bcma_device *core)
 {
 	struct device_node *node;
 	u64 size;
 	const __be32 *reg;
 
-	if (!parent || !parent->dev.of_node)
+	if (!parent->of_node)
 		return NULL;
 
-	for_each_child_of_node(parent->dev.of_node, node) {
+	for_each_child_of_node(parent->of_node, node) {
 		reg = of_get_address(node, 0, &size, NULL);
 		if (!reg)
 			continue;
@@ -156,7 +156,7 @@ static struct device_node *bcma_of_find_child_device(struct platform_device *par
 	return NULL;
 }
 
-static int bcma_of_irq_parse(struct platform_device *parent,
+static int bcma_of_irq_parse(struct device *parent,
 			     struct bcma_device *core,
 			     struct of_phandle_args *out_irq, int num)
 {
@@ -169,7 +169,7 @@ static int bcma_of_irq_parse(struct platform_device *parent,
 			return rc;
 	}
 
-	out_irq->np = parent->dev.of_node;
+	out_irq->np = parent->of_node;
 	out_irq->args_count = 1;
 	out_irq->args[0] = num;
 
@@ -177,13 +177,13 @@ static int bcma_of_irq_parse(struct platform_device *parent,
 	return of_irq_parse_raw(laddr, out_irq);
 }
 
-static unsigned int bcma_of_get_irq(struct platform_device *parent,
+static unsigned int bcma_of_get_irq(struct device *parent,
 				    struct bcma_device *core, int num)
 {
 	struct of_phandle_args out_irq;
 	int ret;
 
-	if (!IS_ENABLED(CONFIG_OF_IRQ) || !parent || !parent->dev.of_node)
+	if (!IS_ENABLED(CONFIG_OF_IRQ) || !parent->of_node)
 		return 0;
 
 	ret = bcma_of_irq_parse(parent, core, &out_irq, num);
@@ -196,7 +196,7 @@ static unsigned int bcma_of_get_irq(struct platform_device *parent,
 	return irq_create_of_mapping(&out_irq);
 }
 
-static void bcma_of_fill_device(struct platform_device *parent,
+static void bcma_of_fill_device(struct device *parent,
 				struct bcma_device *core)
 {
 	struct device_node *node;
@@ -227,7 +227,7 @@ unsigned int bcma_core_irq(struct bcma_device *core, int num)
 			return mips_irq <= 4 ? mips_irq + 2 : 0;
 		}
 		if (bus->host_pdev)
-			return bcma_of_get_irq(bus->host_pdev, core, num);
+			return bcma_of_get_irq(&bus->host_pdev->dev, core, num);
 		return 0;
 	case BCMA_HOSTTYPE_SDIO:
 		return 0;
@@ -253,7 +253,8 @@ void bcma_prepare_core(struct bcma_bus *bus, struct bcma_device *core)
 		if (IS_ENABLED(CONFIG_OF) && bus->host_pdev) {
 			core->dma_dev = &bus->host_pdev->dev;
 			core->dev.parent = &bus->host_pdev->dev;
-			bcma_of_fill_device(bus->host_pdev, core);
+			if (core->dev.parent)
+				bcma_of_fill_device(core->dev.parent, core);
 		} else {
 			core->dev.dma_mask = &core->dev.coherent_dma_mask;
 			core->dma_dev = &core->dev;
-- 
2.11.0
