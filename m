Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hauke-m.de ([5.39.93.123]:37876 "EHLO hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232AbaIXWRh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Sep 2014 18:17:37 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Cc: zajec5@gmail.com, arend@broadcom.com,
	linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
	devicetree@vger.kernel.org, varkabhadram@gmail.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v5 2/2] bcma: get IRQ numbers from dt
Date: Thu, 25 Sep 2014 00:17:28 +0200
Message-Id: <1411597048-25470-2-git-send-email-hauke@hauke-m.de> (sfid-20140925_001741_538252_351F371B)
In-Reply-To: <1411597048-25470-1-git-send-email-hauke@hauke-m.de>
References: <1411597048-25470-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is not possible to auto detect the irq numbers used by the cores on
an arm SoC. If bcma was registered with device tree it will search for
some device tree nodes with the irq number and add it to the core
configuration.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 Documentation/devicetree/bindings/bus/bcma.txt | 24 +++++++++++++++
 drivers/bcma/main.c                            | 42 ++++++++++++++++++++++++++
 2 files changed, 66 insertions(+)

This is based on wireless-testing and should go into that tree.

changes since:
v4:
 - make use of interrupt-map
 - only do the irq stuff here

v2:
 - use of_translate_address() to support ranges

RFC:
 - add #ifdef CONFIG_OF

diff --git a/Documentation/devicetree/bindings/bus/bcma.txt b/Documentation/devicetree/bindings/bus/bcma.txt
index e9070c1..1dc75d3 100644
--- a/Documentation/devicetree/bindings/bus/bcma.txt
+++ b/Documentation/devicetree/bindings/bus/bcma.txt
@@ -8,6 +8,10 @@ Required properties:
 
 The cores on the AXI bus are automatically detected by bcma with the
 memory ranges they are using and they get registered afterwards.
+Automatic detection of the IRQ number is not reliable on
+BCM47xx/BCM53xx ARM SoCs. To assign IRQ numbers to the cores, provide
+them manually through device tree. The IRQ number and the device tree
+child entry will get assigned to the core with the matching reg address.
 
 Example:
 
@@ -17,4 +21,24 @@ Example:
 		ranges = <0x00000000 0x18000000 0x00100000>;
 		#address-cells = <1>;
 		#size-cells = <1>;
+
+		#interrupt-cells = <0>;
+		interrupt-map-mask = <0x000fffff>;
+		interrupt-map =
+			/* Ethernet Controller 0 */
+			<0x00024000 &gic GIC_SPI 147 IRQ_TYPE_LEVEL_HIGH>,
+
+			/* Ethernet Controller 1 */
+			<0x00025000 &gic GIC_SPI 148 IRQ_TYPE_LEVEL_HIGH>;
+
+		pcie@12000 {
+			interrupt-parent = <&gic>;
+			reg = <0x00012000 0x1000>;
+			interrupts = <GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 126 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 127 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 128 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 129 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 130 IRQ_TYPE_LEVEL_HIGH>;
+		};
 	};
diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index d1656c2..870f01d 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -11,6 +11,7 @@
 #include <linux/bcma/bcma.h>
 #include <linux/slab.h>
 #include <linux/of_address.h>
+#include <linux/of_irq.h>
 
 MODULE_DESCRIPTION("Broadcom's specific AMBA driver");
 MODULE_LICENSE("GPL");
@@ -153,6 +154,45 @@ static struct device_node *bcma_of_find_child_device(struct platform_device *par
 	return NULL;
 }
 
+static int bcma_of_irq_parse(struct platform_device *parent,
+			     struct bcma_device *core,
+			     struct of_phandle_args *out_irq)
+{
+	__be32 laddr[1];
+	int rc;
+
+	if (core->dev.of_node) {
+		rc = of_irq_parse_one(core->dev.of_node, 0, out_irq);
+		if (!rc)
+			return rc;
+	}
+
+	out_irq->np = parent->dev.of_node;
+	out_irq->args_count = 0;
+
+	laddr[0] = cpu_to_be32(core->addr);
+	return of_irq_parse_raw(laddr, out_irq);
+}
+
+static int bcma_of_get_irq(struct platform_device *parent,
+			   struct bcma_device *core)
+{
+	struct of_phandle_args out_irq;
+	int ret;
+
+	if (!parent || !parent->dev.of_node)
+		return 0;
+
+	ret = bcma_of_irq_parse(parent, core, &out_irq);
+	if (ret) {
+		bcma_debug(core->bus, "bcma_of_get_irq() failed with rc=%d\n",
+			   ret);
+		return 0;
+	}
+
+	return irq_create_of_mapping(&out_irq);
+}
+
 static void bcma_of_fill_device(struct platform_device *parent,
 				struct bcma_device *core)
 {
@@ -161,6 +201,8 @@ static void bcma_of_fill_device(struct platform_device *parent,
 	node = bcma_of_find_child_device(parent, core);
 	if (node)
 		core->dev.of_node = node;
+
+	core->irq = bcma_of_get_irq(parent, core);
 }
 #else
 static void bcma_of_fill_device(struct platform_device *parent,
-- 
1.9.1

