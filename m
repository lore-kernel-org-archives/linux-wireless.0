Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hauke-m.de ([5.39.93.123]:46668 "EHLO hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754100AbaKAPzF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Nov 2014 11:55:05 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Cc: zajec5@gmail.com, arnd@arndb.de, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v7 2/2] bcma: get IRQ numbers from dt
Date: Sat,  1 Nov 2014 16:54:56 +0100
Message-Id: <1414857296-1287-3-git-send-email-hauke@hauke-m.de> (sfid-20141101_165517_708426_282FA77B)
In-Reply-To: <1414857296-1287-1-git-send-email-hauke@hauke-m.de>
References: <1414857296-1287-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is not possible to auto detect the irq numbers used by the cores on
an arm SoC. If bcma was registered with device tree it will search for
some device tree nodes with the irq number and add it to the core
configuration.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 Documentation/devicetree/bindings/bus/bcma.txt | 21 +++++++++++
 drivers/bcma/main.c                            | 52 +++++++++++++++++++++++++-
 2 files changed, 72 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/bus/bcma.txt b/Documentation/devicetree/bindings/bus/bcma.txt
index 62a4834..edd44d8 100644
--- a/Documentation/devicetree/bindings/bus/bcma.txt
+++ b/Documentation/devicetree/bindings/bus/bcma.txt
@@ -8,6 +8,11 @@ Required properties:
 
 The cores on the AXI bus are automatically detected by bcma with the
 memory ranges they are using and they get registered afterwards.
+Automatic detection of the IRQ number is not working on
+BCM47xx/BCM53xx ARM SoCs. To assign IRQ numbers to the cores, provide
+them manually through device tree. Use an interrupt-map to specify the
+IRQ used by the devices on the bus. The first address is just an index,
+because we do not have any special register.
 
 The top-level axi bus may contain children representing attached cores
 (devices). This is needed since some hardware details can't be auto
@@ -22,6 +27,22 @@ Example:
 		ranges = <0x00000000 0x18000000 0x00100000>;
 		#address-cells = <1>;
 		#size-cells = <1>;
+		#interrupt-cells = <1>;
+		interrupt-map-mask = <0x000fffff 0xffff>;
+		interrupt-map =
+			/* Ethernet Controller 0 */
+			<0x00024000 0 &gic GIC_SPI 147 IRQ_TYPE_LEVEL_HIGH>,
+
+			/* Ethernet Controller 1 */
+			<0x00025000 0 &gic GIC_SPI 148 IRQ_TYPE_LEVEL_HIGH>;
+
+			/* PCIe Controller 0 */
+			<0x00012000 0 &gic GIC_SPI 126 IRQ_TYPE_LEVEL_HIGH>,
+			<0x00012000 1 &gic GIC_SPI 127 IRQ_TYPE_LEVEL_HIGH>,
+			<0x00012000 2 &gic GIC_SPI 128 IRQ_TYPE_LEVEL_HIGH>,
+			<0x00012000 3 &gic GIC_SPI 129 IRQ_TYPE_LEVEL_HIGH>,
+			<0x00012000 4 &gic GIC_SPI 130 IRQ_TYPE_LEVEL_HIGH>,
+			<0x00012000 5 &gic GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH>;
 
 		chipcommon {
 			reg = <0x00000000 0x1000>;
diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index 03cd421..534e133 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -11,6 +11,7 @@
 #include <linux/bcma/bcma.h>
 #include <linux/slab.h>
 #include <linux/of_address.h>
+#include <linux/of_irq.h>
 
 MODULE_DESCRIPTION("Broadcom's specific AMBA driver");
 MODULE_LICENSE("GPL");
@@ -153,6 +154,46 @@ static struct device_node *bcma_of_find_child_device(struct platform_device *par
 	return NULL;
 }
 
+static int bcma_of_irq_parse(struct platform_device *parent,
+			     struct bcma_device *core,
+			     struct of_phandle_args *out_irq, int num)
+{
+	__be32 laddr[1];
+	int rc;
+
+	if (core->dev.of_node) {
+		rc = of_irq_parse_one(core->dev.of_node, num, out_irq);
+		if (!rc)
+			return rc;
+	}
+
+	out_irq->np = parent->dev.of_node;
+	out_irq->args_count = 1;
+	out_irq->args[0] = num;
+
+	laddr[0] = cpu_to_be32(core->addr);
+	return of_irq_parse_raw(laddr, out_irq);
+}
+
+static unsigned int bcma_of_get_irq(struct platform_device *parent,
+				    struct bcma_device *core, int num)
+{
+	struct of_phandle_args out_irq;
+	int ret;
+
+	if (!parent || !parent->dev.of_node)
+		return 0;
+
+	ret = bcma_of_irq_parse(parent, core, &out_irq, num);
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
@@ -161,12 +202,19 @@ static void bcma_of_fill_device(struct platform_device *parent,
 	node = bcma_of_find_child_device(parent, core);
 	if (node)
 		core->dev.of_node = node;
+
+	core->irq = bcma_of_get_irq(parent, core, 0);
 }
 #else
 static void bcma_of_fill_device(struct platform_device *parent,
 				struct bcma_device *core)
 {
 }
+static inline unsigned int bcma_of_get_irq(struct platform_device *parent,
+					   struct bcma_device *core, int num)
+{
+	return 0;
+}
 #endif /* CONFIG_OF */
 
 unsigned int bcma_core_irq(struct bcma_device *core, int num)
@@ -182,7 +230,9 @@ unsigned int bcma_core_irq(struct bcma_device *core, int num)
 			mips_irq = bcma_core_mips_irq(core);
 			return mips_irq <= 4 ? mips_irq + 2 : 0;
 		}
-		break;
+		if (bus->host_pdev)
+			return bcma_of_get_irq(bus->host_pdev, core, num);
+		return 0;
 	case BCMA_HOSTTYPE_SDIO:
 		return 0;
 	}
-- 
1.9.1

