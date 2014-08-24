Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from test.hauke-m.de ([5.39.93.123]:43941 "EHLO test.hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753419AbaHXVZd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Aug 2014 17:25:33 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org
Cc: zajec5@gmail.com, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [RFC 4/7] bcma: register bcma as device tree driver
Date: Sun, 24 Aug 2014 23:24:42 +0200
Message-Id: <1408915485-8078-6-git-send-email-hauke@hauke-m.de> (sfid-20140824_232537_359921_DCFECA7A)
In-Reply-To: <1408915485-8078-1-git-send-email-hauke@hauke-m.de>
References: <1408915485-8078-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This driver is used by the bcm53xx ARM SoC code. Now it is possible to
give the address of the chipcommon core in device tree and bcma will
search for all the other cores.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 Documentation/devicetree/bindings/bus/bcma.txt | 46 +++++++++++++++++
 drivers/bcma/host_soc.c                        | 70 ++++++++++++++++++++++++++
 include/linux/bcma/bcma.h                      |  2 +
 3 files changed, 118 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/bus/bcma.txt

diff --git a/Documentation/devicetree/bindings/bus/bcma.txt b/Documentation/devicetree/bindings/bus/bcma.txt
new file mode 100644
index 0000000..52fb929
--- /dev/null
+++ b/Documentation/devicetree/bindings/bus/bcma.txt
@@ -0,0 +1,46 @@
+Broadcom AIX bcma bus driver
+
+
+Required properties:
+
+- compatible : brcm,bus-aix
+
+- reg : iomem address range of chipcommon core
+
+Optional properties:
+
+- sprom: reference to a sprom driver. This is needed for sprom less devices.
+	 Use bcm47xx_sprom for example.
+
+
+The cores on the AIX bus are auto detected by bcma. Detection of the
+IRQ number is not supported on BCM47xx/BCM53xx ARM SoCs, so it is
+possible to provide the IRQ number over device tree. The IRQ number and
+the device tree child entry will be added to the core with the matching
+reg address.
+
+Example:
+
+	aix@18000000 {
+		compatible = "brcm,bus-aix";
+		reg = <0x18000000 0x1000>;
+		ranges = <0x00000000 0x18000000 0x00100000>;
+		#address-cells = <1>;
+		#size-cells = <1>;
+		sprom = <&sprom0>;
+
+		gmac@0 {
+			reg = <0x18024000 0x1000>;
+			interrupts = <GIC_SPI 147 IRQ_TYPE_LEVEL_HIGH>;
+		};
+
+		gmac@1 {
+			reg = <0x18025000 0x1000>;
+			interrupts = <GIC_SPI 148 IRQ_TYPE_LEVEL_HIGH>;
+		};
+
+		pcie@0 {
+			reg = <0x18012000 0x1000>;
+			interrupts = <GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH>;
+		};
+	};
diff --git a/drivers/bcma/host_soc.c b/drivers/bcma/host_soc.c
index 3475e60..d009bc9 100644
--- a/drivers/bcma/host_soc.c
+++ b/drivers/bcma/host_soc.c
@@ -7,6 +7,9 @@
 
 #include "bcma_private.h"
 #include "scan.h"
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/of_address.h>
 #include <linux/bcma/bcma.h>
 #include <linux/bcma/bcma_soc.h>
 
@@ -173,6 +176,7 @@ int __init bcma_host_soc_register(struct bcma_soc *soc)
 	/* Host specific */
 	bus->hosttype = BCMA_HOSTTYPE_SOC;
 	bus->ops = &bcma_host_soc_ops;
+	bus->host_pdev = NULL;
 
 	/* Register */
 	err = bcma_bus_early_register(bus, &soc->core_cc, &soc->core_mips);
@@ -181,3 +185,69 @@ int __init bcma_host_soc_register(struct bcma_soc *soc)
 
 	return err;
 }
+
+#ifdef CONFIG_OF
+static int bcma_host_soc_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct device_node *np = dev->of_node;
+	struct bcma_bus *bus;
+	int err;
+
+	/* Alloc */
+	bus = devm_kzalloc(dev, sizeof(*bus), GFP_KERNEL);
+	if (!bus)
+		return -ENOMEM;
+
+	/* Map MMIO */
+	bus->mmio = of_iomap(np, 0);
+	if (!bus->mmio)
+		return -ENOMEM;
+
+	/* Host specific */
+	bus->hosttype = BCMA_HOSTTYPE_SOC;
+	bus->ops = &bcma_host_soc_ops;
+	bus->host_pdev = pdev;
+
+	/* Register */
+	err = bcma_bus_register(bus);
+	if (err)
+		goto err_unmap_mmio;
+
+	platform_set_drvdata(pdev, bus);
+
+	return err;
+
+err_unmap_mmio:
+	iounmap(bus->mmio);
+	return err;
+}
+
+static int bcma_host_soc_remove(struct platform_device *pdev)
+{
+	struct bcma_bus *bus = platform_get_drvdata(pdev);
+
+	bcma_bus_unregister(bus);
+	iounmap(bus->mmio);
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+static const struct of_device_id bcma_host_soc_of_match[] = {
+	{ .compatible = "brcm,bus-aix", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, bcma_host_soc_of_match);
+
+static struct platform_driver bcma_host_soc_driver = {
+	.driver = {
+		.name = "bcma-host-soc",
+		.owner = THIS_MODULE,
+		.of_match_table = bcma_host_soc_of_match,
+	},
+	.probe		= bcma_host_soc_probe,
+	.remove		= bcma_host_soc_remove,
+};
+module_platform_driver(bcma_host_soc_driver);
+#endif /* CONFIG_OF */
diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index 0272e49..7a10d6d 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -323,6 +323,8 @@ struct bcma_bus {
 		struct pci_dev *host_pci;
 		/* Pointer to the SDIO device (only for BCMA_HOSTTYPE_SDIO) */
 		struct sdio_func *host_sdio;
+		/* Pointer to platform device (only for BCMA_HOSTTYPE_SOC) */
+		struct platform_device *host_pdev;
 	};
 
 	struct bcma_chipinfo chipinfo;
-- 
1.9.1

