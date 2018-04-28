Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-db5eur01on0052.outbound.protection.outlook.com ([104.47.2.52]:34640
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1759319AbeD1Cwe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Apr 2018 22:52:34 -0400
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
Subject: [PATCH v4 1/2] dma-mapping: move dma configuration to bus infrastructure
Date: Sat, 28 Apr 2018 08:21:58 +0530
Message-Id: <1524883919-29484-1-git-send-email-nipun.gupta@nxp.com> (sfid-20180428_045253_965656_4CF15410)
In-Reply-To: <1520868292-2479-1-git-send-email-nipun.gupta@nxp.com>
References: <1520868292-2479-1-git-send-email-nipun.gupta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is bus specific aspect to map a given device on the bus and
relevant firmware description of its DMA configuration.
So, this change introduces 'dma_configure' as bus callback
giving flexibility to busses for implementing its own dma
configuration function.

The change eases the addition of new busses w.r.t. adding the dma
configuration functionality.

This patch also updates the PCI, Platform, ACPI and host1x bus to
use new introduced callbacks.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nipun Gupta <nipun.gupta@nxp.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>  # PCI parts
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

Changes in v3:
  - Move dma_common_configure() within platform_dma_configure() and
    reuse platofrm_dma_configure() for AMBA bus too
  - Declare 'attr' in pci_dma_configure() inside the else statement
    where it is used.

Changes in v4:
  - Rebased on top of 4.17-rc2

 drivers/amba/bus.c              |  4 ++++
 drivers/base/dma-mapping.c      | 31 ++++---------------------------
 drivers/base/platform.c         | 17 +++++++++++++++++
 drivers/gpu/host1x/bus.c        |  8 ++++++++
 drivers/pci/pci-driver.c        | 32 ++++++++++++++++++++++++++++++++
 include/linux/device.h          |  4 ++++
 include/linux/platform_device.h |  2 ++
 7 files changed, 71 insertions(+), 27 deletions(-)

diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
index 594c228..867dc2b 100644
--- a/drivers/amba/bus.c
+++ b/drivers/amba/bus.c
@@ -20,6 +20,7 @@
 #include <linux/sizes.h>
 #include <linux/limits.h>
 #include <linux/clk/clk-conf.h>
+#include <linux/platform_device.h>
 
 #include <asm/irq.h>
 
@@ -188,12 +189,15 @@ static int amba_pm_runtime_resume(struct device *dev)
 /*
  * Primecells are part of the Advanced Microcontroller Bus Architecture,
  * so we call the bus "amba".
+ * DMA configuration for platform and AMBA bus is same. So here we reuse
+ * platform's DMA config routine.
  */
 struct bus_type amba_bustype = {
 	.name		= "amba",
 	.dev_groups	= amba_dev_groups,
 	.match		= amba_match,
 	.uevent		= amba_uevent,
+	.dma_configure	= platform_dma_configure,
 	.pm		= &amba_pm,
 	.force_dma	= true,
 };
diff --git a/drivers/base/dma-mapping.c b/drivers/base/dma-mapping.c
index d82566d..f831a58 100644
--- a/drivers/base/dma-mapping.c
+++ b/drivers/base/dma-mapping.c
@@ -329,36 +329,13 @@ void dma_common_free_remap(void *cpu_addr, size_t size, unsigned long vm_flags)
 #endif
 
 /*
- * Common configuration to enable DMA API use for a device
+ * enables DMA API use for a device
  */
-#include <linux/pci.h>
-
 int dma_configure(struct device *dev)
 {
-	struct device *bridge = NULL, *dma_dev = dev;
-	enum dev_dma_attr attr;
-	int ret = 0;
-
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
-		if (attr != DEV_DMA_NOT_SUPPORTED)
-			ret = acpi_dma_configure(dev, attr);
-	}
-
-	if (bridge)
-		pci_put_host_bridge_device(bridge);
-
-	return ret;
+	if (dev->bus->dma_configure)
+		return dev->bus->dma_configure(dev);
+	return 0;
 }
 
 void dma_deconfigure(struct device *dev)
diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 8075ddc..638d42e 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -1130,6 +1130,22 @@ int platform_pm_restore(struct device *dev)
 
 #endif /* CONFIG_HIBERNATE_CALLBACKS */
 
+int platform_dma_configure(struct device *dev)
+{
+	enum dev_dma_attr attr;
+	int ret = 0;
+
+	if (dev->of_node) {
+		ret = of_dma_configure(dev, dev->of_node);
+	} else if (has_acpi_companion(dev)) {
+		attr = acpi_get_dma_attr(to_acpi_device_node(dev->fwnode));
+		if (attr != DEV_DMA_NOT_SUPPORTED)
+			ret = acpi_dma_configure(dev, attr);
+	}
+
+	return ret;
+}
+
 static const struct dev_pm_ops platform_dev_pm_ops = {
 	.runtime_suspend = pm_generic_runtime_suspend,
 	.runtime_resume = pm_generic_runtime_resume,
@@ -1141,6 +1157,7 @@ struct bus_type platform_bus_type = {
 	.dev_groups	= platform_dev_groups,
 	.match		= platform_match,
 	.uevent		= platform_uevent,
+	.dma_configure	= platform_dma_configure,
 	.pm		= &platform_dev_pm_ops,
 	.force_dma	= true,
 };
diff --git a/drivers/gpu/host1x/bus.c b/drivers/gpu/host1x/bus.c
index 88a3558..a9ec99d 100644
--- a/drivers/gpu/host1x/bus.c
+++ b/drivers/gpu/host1x/bus.c
@@ -314,6 +314,13 @@ static int host1x_device_match(struct device *dev, struct device_driver *drv)
 	return strcmp(dev_name(dev), drv->name) == 0;
 }
 
+static int host1x_dma_configure(struct device *dev)
+{
+	if (dev->of_node)
+		return of_dma_configure(dev, dev->of_node);
+	return 0;
+}
+
 static const struct dev_pm_ops host1x_device_pm_ops = {
 	.suspend = pm_generic_suspend,
 	.resume = pm_generic_resume,
@@ -326,6 +333,7 @@ static int host1x_device_match(struct device *dev, struct device_driver *drv)
 struct bus_type host1x_bus_type = {
 	.name = "host1x",
 	.match = host1x_device_match,
+	.dma_configure	= host1x_dma_configure,
 	.pm = &host1x_device_pm_ops,
 	.force_dma = true,
 };
diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index b9a1311..ba8c6b4 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -16,6 +16,8 @@
 #include <linux/pm_runtime.h>
 #include <linux/suspend.h>
 #include <linux/kexec.h>
+#include <linux/of_device.h>
+#include <linux/acpi.h>
 #include "pci.h"
 #include "pcie/portdrv.h"
 
@@ -1577,6 +1579,35 @@ static int pci_bus_num_vf(struct device *dev)
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
+	int ret = 0;
+
+	bridge = pci_get_host_bridge_device(to_pci_dev(dev));
+
+	if (IS_ENABLED(CONFIG_OF) && bridge->parent &&
+	    bridge->parent->of_node) {
+		ret = of_dma_configure(dev, bridge->parent->of_node);
+	} else if (has_acpi_companion(bridge)) {
+		struct acpi_device *adev = to_acpi_device_node(bridge->fwnode);
+		enum dev_dma_attr attr = acpi_get_dma_attr(adev);
+
+		if (attr != DEV_DMA_NOT_SUPPORTED)
+			ret = acpi_dma_configure(dev, attr);
+	}
+
+	pci_put_host_bridge_device(bridge);
+	return ret;
+}
+
 struct bus_type pci_bus_type = {
 	.name		= "pci",
 	.match		= pci_bus_match,
@@ -1589,6 +1620,7 @@ struct bus_type pci_bus_type = {
 	.drv_groups	= pci_drv_groups,
 	.pm		= PCI_PM_OPS_PTR,
 	.num_vf		= pci_bus_num_vf,
+	.dma_configure	= pci_dma_configure,
 	.force_dma	= true,
 };
 EXPORT_SYMBOL(pci_bus_type);
diff --git a/include/linux/device.h b/include/linux/device.h
index 0059b99..607c7eb 100644
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
diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index 49f634d..3097c94 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -356,6 +356,8 @@ static inline char *early_platform_driver_setup_func(void)		\
 #define platform_pm_restore		NULL
 #endif
 
+extern int platform_dma_configure(struct device *dev);
+
 #ifdef CONFIG_PM_SLEEP
 #define USE_PLATFORM_PM_SLEEP_OPS \
 	.suspend = platform_pm_suspend, \
-- 
1.9.1
