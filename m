Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve1eur01on0047.outbound.protection.outlook.com ([104.47.1.47]:3180
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751661AbeCUG4K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Mar 2018 02:56:10 -0400
From: Nipun Gupta <nipun.gupta@nxp.com>
To: robin.murphy@arm.com, hch@lst.de, linux@armlinux.org.uk,
        gregkh@linuxfoundation.org, m.szyprowski@samsung.com
Cc: bhelgaas@google.com, zajec5@gmail.com, andy.gross@linaro.org,
        david.brown@linaro.org, dan.j.williams@intel.com,
        vinod.koul@intel.com, thierry.reding@gmail.com, robh+dt@kernel.org,
        frowand.list@gmail.com, jarkko.sakkinen@linux.intel.com,
        rafael.j.wysocki@intel.com, dmitry.torokhov@gmail.com,
        johan@kernel.org, msuchanek@suse.de, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-wireless@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        dmaengine@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-tegra@vger.kernel.org, devicetree@vger.kernel.org,
        linux-pci@vger.kernel.org, bharat.bhushan@nxp.com,
        leoyang.li@nxp.com, Nipun Gupta <nipun.gupta@nxp.com>
Subject: [PATCH v2 1/2] dma-mapping: move dma configuration to bus infrastructure
Date: Wed, 21 Mar 2018 12:25:22 +0530
Message-Id: <1521615323-4752-1-git-send-email-nipun.gupta@nxp.com> (sfid-20180321_075619_801298_B0326B3C)
In-Reply-To: <1520868292-2479-1-git-send-email-nipun.gupta@nxp.com>
References: <1520868292-2479-1-git-send-email-nipun.gupta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's bus specific aspect to map a given device on the bus and
relevant firmware description of its DMA configuration.
So, this change introduces '/dma_configure/' as bus callback
giving flexibility to busses for implementing its own dma
configuration function.

The change eases the addition of new busses w.r.t. adding the dma
configuration functionality.

This patch also updates the PCI, Platform, ACPI and host1x bus to
use new introduced callbacks.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nipun Gupta <nipun.gupta@nxp.com>
---
 - The patches are based on the comments on:
   https://patchwork.kernel.org/patch/10259087/

Changes in v2:
  - Do not have dma_deconfigure callback
  - Have '/dma_common_configure/' API to provide a common DMA
    configuration which can be used by busses if it suits them.
  - Platform and ACPI bus to use '/dma_common_configure/' in
    '/dma_configure/' callback.
  - Updated commit message
  - Updated pci_dma_configure API with changes suggested by Robin

 drivers/amba/bus.c          |  7 +++++++
 drivers/base/dma-mapping.c  | 35 +++++++++++++++--------------------
 drivers/base/platform.c     |  6 ++++++
 drivers/gpu/host1x/bus.c    |  9 +++++++++
 drivers/pci/pci-driver.c    | 32 ++++++++++++++++++++++++++++++++
 include/linux/device.h      |  4 ++++
 include/linux/dma-mapping.h |  1 +
 7 files changed, 74 insertions(+), 20 deletions(-)

diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
index 594c228..2fa1e8b 100644
--- a/drivers/amba/bus.c
+++ b/drivers/amba/bus.c
@@ -20,6 +20,7 @@
 #include <linux/sizes.h>
 #include <linux/limits.h>
 #include <linux/clk/clk-conf.h>
+#include <linux/dma-mapping.h>
 
 #include <asm/irq.h>
 
@@ -171,6 +172,11 @@ static int amba_pm_runtime_resume(struct device *dev)
 }
 #endif /* CONFIG_PM */
 
+static int amba_dma_configure(struct device *dev)
+{
+	return dma_common_configure(dev);
+}
+
 static const struct dev_pm_ops amba_pm = {
 	.suspend	= pm_generic_suspend,
 	.resume		= pm_generic_resume,
@@ -194,6 +200,7 @@ struct bus_type amba_bustype = {
 	.dev_groups	= amba_dev_groups,
 	.match		= amba_match,
 	.uevent		= amba_uevent,
+	.dma_configure	= amba_dma_configure,
 	.pm		= &amba_pm,
 	.force_dma	= true,
 };
diff --git a/drivers/base/dma-mapping.c b/drivers/base/dma-mapping.c
index 3b11835..48f9af0 100644
--- a/drivers/base/dma-mapping.c
+++ b/drivers/base/dma-mapping.c
@@ -331,38 +331,33 @@ void dma_common_free_remap(void *cpu_addr, size_t size, unsigned long vm_flags)
 #endif
 
 /*
- * Common configuration to enable DMA API use for a device
+ * Common configuration to enable DMA API use for a device.
+ * A bus can use this function in its 'dma_configure' callback, if
+ * suitable for the bus.
  */
-#include <linux/pci.h>
-
-int dma_configure(struct device *dev)
+int dma_common_configure(struct device *dev)
 {
-	struct device *bridge = NULL, *dma_dev = dev;
 	enum dev_dma_attr attr;
 	int ret = 0;
 
-	if (dev_is_pci(dev)) {
-		bridge = pci_get_host_bridge_device(to_pci_dev(dev));
-		dma_dev = bridge;
-		if (IS_ENABLED(CONFIG_OF) && dma_dev->parent &&
-		    dma_dev->parent->of_node)
-			dma_dev = dma_dev->parent;
-	}
-
-	if (dma_dev->of_node) {
-		ret = of_dma_configure(dev, dma_dev->of_node);
-	} else if (has_acpi_companion(dma_dev)) {
-		attr = acpi_get_dma_attr(to_acpi_device_node(dma_dev->fwnode));
+	if (dev->of_node) {
+		ret = of_dma_configure(dev, dev->of_node);
+	} else if (has_acpi_companion(dev)) {
+		attr = acpi_get_dma_attr(to_acpi_device_node(dev->fwnode));
 		if (attr != DEV_DMA_NOT_SUPPORTED)
 			ret = acpi_dma_configure(dev, attr);
 	}
 
-	if (bridge)
-		pci_put_host_bridge_device(bridge);
-
 	return ret;
 }
 
+int dma_configure(struct device *dev)
+{
+	if (dev->bus->dma_configure)
+		return dev->bus->dma_configure(dev);
+
+	return 0;
+}
 void dma_deconfigure(struct device *dev)
 {
 	of_dma_deconfigure(dev);
diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index f1bf7b3..d2d5891 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -1130,6 +1130,11 @@ int platform_pm_restore(struct device *dev)
 
 #endif /* CONFIG_HIBERNATE_CALLBACKS */
 
+static int platform_dma_configure(struct device *dev)
+{
+	return dma_common_configure(dev);
+}
+
 static const struct dev_pm_ops platform_dev_pm_ops = {
 	.runtime_suspend = pm_generic_runtime_suspend,
 	.runtime_resume = pm_generic_runtime_resume,
@@ -1141,6 +1146,7 @@ struct bus_type platform_bus_type = {
 	.dev_groups	= platform_dev_groups,
 	.match		= platform_match,
 	.uevent		= platform_uevent,
+	.dma_configure	= platform_dma_configure,
 	.pm		= &platform_dev_pm_ops,
 	.force_dma	= true,
 };
diff --git a/drivers/gpu/host1x/bus.c b/drivers/gpu/host1x/bus.c
index 88a3558..fa9896d 100644
--- a/drivers/gpu/host1x/bus.c
+++ b/drivers/gpu/host1x/bus.c
@@ -314,6 +314,14 @@ static int host1x_device_match(struct device *dev, struct device_driver *drv)
 	return strcmp(dev_name(dev), drv->name) == 0;
 }
 
+static int host1x_dma_configure(struct device *dev)
+{
+	if (dev->of_node)
+		return of_dma_configure(dev, dev->of_node);
+
+	return 0;
+}
+
 static const struct dev_pm_ops host1x_device_pm_ops = {
 	.suspend = pm_generic_suspend,
 	.resume = pm_generic_resume,
@@ -326,6 +334,7 @@ static int host1x_device_match(struct device *dev, struct device_driver *drv)
 struct bus_type host1x_bus_type = {
 	.name = "host1x",
 	.match = host1x_device_match,
+	.dma_configure	= host1x_dma_configure,
 	.pm = &host1x_device_pm_ops,
 	.force_dma = true,
 };
diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 3bed6be..b473a4c 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -18,6 +18,8 @@
 #include <linux/pm_runtime.h>
 #include <linux/suspend.h>
 #include <linux/kexec.h>
+#include <linux/of_device.h>
+#include <linux/acpi.h>
 #include "pci.h"
 
 struct pci_dynid {
@@ -1522,6 +1524,35 @@ static int pci_bus_num_vf(struct device *dev)
 	return pci_num_vf(to_pci_dev(dev));
 }
 
+/**
+ * pci_dma_configure - Setup DMA configuration
+ * @dev: ptr to dev structure
+ *
+ * Function to update PCI devices's DMA configuration using the same
+ * info from the OF node or ACPI node of host bridge's parent (if any).
+ */
+static int pci_dma_configure(struct device *dev)
+{
+	struct device *bridge;
+	enum dev_dma_attr attr;
+	int ret = 0;
+
+	bridge = pci_get_host_bridge_device(to_pci_dev(dev));
+
+	if (IS_ENABLED(CONFIG_OF) && bridge->parent &&
+	    bridge->parent->of_node) {
+		ret = of_dma_configure(dev, bridge->parent->of_node);
+	} else if (has_acpi_companion(bridge)) {
+		attr = acpi_get_dma_attr(to_acpi_device_node(bridge->fwnode));
+		if (attr != DEV_DMA_NOT_SUPPORTED)
+			ret = acpi_dma_configure(dev, attr);
+	}
+
+	pci_put_host_bridge_device(bridge);
+
+	return ret;
+}
+
 struct bus_type pci_bus_type = {
 	.name		= "pci",
 	.match		= pci_bus_match,
@@ -1534,6 +1565,7 @@ struct bus_type pci_bus_type = {
 	.drv_groups	= pci_drv_groups,
 	.pm		= PCI_PM_OPS_PTR,
 	.num_vf		= pci_bus_num_vf,
+	.dma_configure	= pci_dma_configure,
 	.force_dma	= true,
 };
 EXPORT_SYMBOL(pci_bus_type);
diff --git a/include/linux/device.h b/include/linux/device.h
index b093405..1832d90 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -88,6 +88,8 @@ extern int __must_check bus_create_file(struct bus_type *,
  * @resume:	Called to bring a device on this bus out of sleep mode.
  * @num_vf:	Called to find out how many virtual functions a device on this
  *		bus supports.
+ * @dma_configure:	Called to setup DMA configuration on a device on
+			this bus.
  * @pm:		Power management operations of this bus, callback the specific
  *		device driver's pm-ops.
  * @iommu_ops:  IOMMU specific operations for this bus, used to attach IOMMU
@@ -130,6 +132,8 @@ struct bus_type {
 
 	int (*num_vf)(struct device *dev);
 
+	int (*dma_configure)(struct device *dev);
+
 	const struct dev_pm_ops *pm;
 
 	const struct iommu_ops *iommu_ops;
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index eb9eab4..c15986b 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -761,6 +761,7 @@ void *dma_mark_declared_memory_occupied(struct device *dev,
 }
 #endif /* CONFIG_HAVE_GENERIC_DMA_COHERENT */
 
+int dma_common_configure(struct device *dev);
 #ifdef CONFIG_HAS_DMA
 int dma_configure(struct device *dev);
 void dma_deconfigure(struct device *dev);
-- 
1.9.1
