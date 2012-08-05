Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:49687 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754554Ab2HEOyx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Aug 2012 10:54:53 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, zajec5@gmail.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v2] bcma: make some functions static
Date: Sun,  5 Aug 2012 16:54:41 +0200
Message-Id: <1344178481-24023-1-git-send-email-hauke@hauke-m.de> (sfid-20120805_165459_164095_C8955B51)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The functions and structs are not used in an other file and the
prototypes are in no header file, just make them static so the compiler
is able to optimize them better.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/driver_chipcommon_pmu.c |    4 ++--
 drivers/bcma/host_pci.c              |   11 ++++++-----
 drivers/bcma/host_soc.c              |    2 +-
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/bcma/driver_chipcommon_pmu.c b/drivers/bcma/driver_chipcommon_pmu.c
index c9a4f46..8b8f2f3 100644
--- a/drivers/bcma/driver_chipcommon_pmu.c
+++ b/drivers/bcma/driver_chipcommon_pmu.c
@@ -101,7 +101,7 @@ void bcma_chipco_bcm4331_ext_pa_lines_ctl(struct bcma_drv_cc *cc, bool enable)
 	bcma_cc_write32(cc, BCMA_CC_CHIPCTL, val);
 }
 
-void bcma_pmu_workarounds(struct bcma_drv_cc *cc)
+static void bcma_pmu_workarounds(struct bcma_drv_cc *cc)
 {
 	struct bcma_bus *bus = cc->core->bus;
 
@@ -257,7 +257,7 @@ static u32 bcma_pmu_clock_bcm4706(struct bcma_drv_cc *cc, u32 pll0, u32 m)
 }
 
 /* query bus clock frequency for PMU-enabled chipcommon */
-u32 bcma_pmu_get_clockcontrol(struct bcma_drv_cc *cc)
+static u32 bcma_pmu_get_clockcontrol(struct bcma_drv_cc *cc)
 {
 	struct bcma_bus *bus = cc->core->bus;
 
diff --git a/drivers/bcma/host_pci.c b/drivers/bcma/host_pci.c
index a6e5672..f7b0af7 100644
--- a/drivers/bcma/host_pci.c
+++ b/drivers/bcma/host_pci.c
@@ -77,8 +77,8 @@ static void bcma_host_pci_write32(struct bcma_device *core, u16 offset,
 }
 
 #ifdef CONFIG_BCMA_BLOCKIO
-void bcma_host_pci_block_read(struct bcma_device *core, void *buffer,
-			      size_t count, u16 offset, u8 reg_width)
+static void bcma_host_pci_block_read(struct bcma_device *core, void *buffer,
+				     size_t count, u16 offset, u8 reg_width)
 {
 	void __iomem *addr = core->bus->mmio + offset;
 	if (core->bus->mapped_core != core)
@@ -100,8 +100,9 @@ void bcma_host_pci_block_read(struct bcma_device *core, void *buffer,
 	}
 }
 
-void bcma_host_pci_block_write(struct bcma_device *core, const void *buffer,
-			       size_t count, u16 offset, u8 reg_width)
+static void bcma_host_pci_block_write(struct bcma_device *core,
+				      const void *buffer, size_t count,
+				      u16 offset, u8 reg_width)
 {
 	void __iomem *addr = core->bus->mmio + offset;
 	if (core->bus->mapped_core != core)
@@ -139,7 +140,7 @@ static void bcma_host_pci_awrite32(struct bcma_device *core, u16 offset,
 	iowrite32(value, core->bus->mmio + (1 * BCMA_CORE_SIZE) + offset);
 }
 
-const struct bcma_host_ops bcma_host_pci_ops = {
+static const struct bcma_host_ops bcma_host_pci_ops = {
 	.read8		= bcma_host_pci_read8,
 	.read16		= bcma_host_pci_read16,
 	.read32		= bcma_host_pci_read32,
diff --git a/drivers/bcma/host_soc.c b/drivers/bcma/host_soc.c
index 3c381fb..3475e60 100644
--- a/drivers/bcma/host_soc.c
+++ b/drivers/bcma/host_soc.c
@@ -143,7 +143,7 @@ static void bcma_host_soc_awrite32(struct bcma_device *core, u16 offset,
 	writel(value, core->io_wrap + offset);
 }
 
-const struct bcma_host_ops bcma_host_soc_ops = {
+static const struct bcma_host_ops bcma_host_soc_ops = {
 	.read8		= bcma_host_soc_read8,
 	.read16		= bcma_host_soc_read16,
 	.read32		= bcma_host_soc_read32,
-- 
1.7.9.5

