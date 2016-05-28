Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout2.hostsharing.net ([83.223.90.233]:43530 "EHLO
	mailout2.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbcE1Xfg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 May 2016 19:35:36 -0400
Message-Id: <82c2548dffc6cfbc484b9111b1073f407c946061.1464477483.git.lukas@wunner.de> (sfid-20160529_013559_873485_99D8AFFC)
From: Lukas Wunner <lukas@wunner.de>
Date: Sun, 29 May 2016 01:35:28 +0200
Subject: [PATCH] x86: Add early quirk to reset Apple AirPort card
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: Chris Milsted <cmilsted@redhat.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Andi Kleen <ak@linux.intel.com>, Michael Buesch <m@bues.ch>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Matt Fleming <matt@codeblueprint.co.uk>,
	Konstantin Simanov <k.simanov@stlk.ru>,
	Bryan Paradis <bryan.paradis@gmail.com>,
	Andrew Worsley <amworsley@gmail.com>,
	Chris Bainbridge <chris.bainbridge@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-pci@vger.kernel.org, linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org, zajec5@gmail.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The EFI firmware on Macs contains a full-fledged network stack for
downloading OS X images from osrecovery.apple.com. Unfortunately
on Macs introduced 2011 and 2012, EFI brings up the Broadcom 4331
wireless card on every boot and leaves it enabled even after
ExitBootServices has been called. The card continues to assert its IRQ
line, causing spurious interrupts if the IRQ is shared. It also corrupts
memory by DMAing received packets, allowing for remote code execution
over the air. This only stops when a driver is loaded for the wireless
card, which may be never if the driver is not installed or blacklisted.

The issue seems to be constrained to the Broadcom 4331. Chris Milsted
has verified that the newer Broadcom 4360 built into the MacBookPro11,3
(2013/2014) does not exhibit this behaviour. The chances that Apple will
ever supply a firmware fix for the older machines appear to be zero.

The solution is to reset the card on boot by writing to a reset bit in
its mmio space. This must be done as an early quirk and not as a plain
vanilla PCI quirk to successfully combat memory corruption by DMAed
packets: Matthew Garrett found out in 2012 that the packets are written
to EfiBootServicesData memory (http://mjg59.dreamwidth.org/11235.html).
This type of memory is made available to the page allocator by
efi_free_boot_services(). Plain vanilla PCI quirks run much later, in
subsys initcall level. In-between a time window would be open for memory
corruption. Random crashes occurring in this time window and attributed
to DMAed packets have indeed been observed in the wild by Chris
Bainbridge.

When Matthew Garrett analyzed the memory corruption issue in 2012, he
sought to fix it with a grub quirk which transitions the card to D3hot:
http://git.savannah.gnu.org/cgit/grub.git/commit/?id=9d34bb85da56

This approach does not help users with other bootloaders and while it
may prevent DMAed packets, it does not cure the spurious interrupts
emanating from the card. Unfortunately the card's mmio space is
inaccessible in D3hot, so to reset it, we have to undo the effect of
Matthew's grub patch and transition the card back to D0.

Since commit 8659c406ade3 ("x86: only scan the root bus in early PCI
quirks"), early quirks can only be applied to devices on the root bus.
However the Broadcom 4331 card is located on a secondary bus behind a
PCIe root port. The present commit therefore reintroduces scanning of
secondary buses. The primary motivation of 8659c406ade3 was to prevent
application of the nvidia_bugs() quirk on secondary buses. Amend the
quirk to open code this requirement.

A secondary motivation was to speed up PCI scanning. The algorithm used
prior to 8659c406ade3 was particularly time consuming because it scanned
buses 0 to 31 brute force. The recursive algorithm used by the present
commit only scans buses that are actually reachable from the root bus
and should thus be a bit faster. If this algorithm is found to
significantly impact boot time, it would be possible to limit its
recursion depth: The Apple AirPort quirk applies at depth 1, all others
at depth 0, so the bus need not be scanned deeper than that for now. An
alternative approach would be to continue scanning only the root bus,
and apply the AirPort quirk to the root ports 8086:1c12, 8086:1e12 and
8086:1e16. Apple always positioned the Broadcom 4331 behind one of these
three ports (see model list below). The quirk would then check presence
of the Broadcom 4331 in slot 0 below the root port and do its deed.

Note that the quirk takes a few shortcuts to reduce the amount of code:
The size of BAR 0 and the location of the PM capability is identical
on all affected machines and therefore hardcoded. Only the address of
BAR 0 differs between models. Also, it is assumed that the BCMA core
currently mapped is the 802.11 core. The EFI driver seems to always take
care of this.

Michael Büsch, Bjorn Helgaas and Matt Fleming contributed feedback
towards finding the best solution to this problem.

The following should be a comprehensive list of affected models:
    iMac13,1        2012  21.5"       [Root Port 00:1c.3 = 8086:1e16]
    iMac13,2        2012  27"         [Root Port 00:1c.3 = 8086:1e16]
    Macmini5,1      2011  i5 2.3 GHz  [Root Port 00:1c.1 = 8086:1c12]
    Macmini5,2      2011  i5 2.5 GHz  [Root Port 00:1c.1 = 8086:1c12]
    Macmini5,3      2011  i7 2.0 GHz  [Root Port 00:1c.1 = 8086:1c12]
    Macmini6,1      2012  i5 2.5 GHz  [Root Port 00:1c.1 = 8086:1e12]
    Macmini6,2      2012  i7 2.3 GHz  [Root Port 00:1c.1 = 8086:1e12]
    MacBookPro8,1   2011  13"         [Root Port 00:1c.1 = 8086:1c12]
    MacBookPro8,2   2011  15"         [Root Port 00:1c.1 = 8086:1c12]
    MacBookPro8,3   2011  17"         [Root Port 00:1c.1 = 8086:1c12]
    MacBookPro9,1   2012  15"         [Root Port 00:1c.1 = 8086:1e12]
    MacBookPro9,2   2012  13"         [Root Port 00:1c.1 = 8086:1e12]
    MacBookPro10,1  2012  15"         [Root Port 00:1c.1 = 8086:1e12]
    MacBookPro10,2  2012  13"         [Root Port 00:1c.1 = 8086:1e12]

For posterity, spurious interrupts caused by the Broadcom 4331 wireless
card resulted in splats like this (stacktrace omitted):
    irq 17: nobody cared (try booting with the "irqpoll" option)
    handlers:
    [<ffffffff81374370>] pcie_isr
    [<ffffffffc0704550>] sdhci_irq [sdhci] threaded [<ffffffffc07013c0>] sdhci_thread_irq [sdhci]
    [<ffffffffc0a0b960>] azx_interrupt [snd_hda_codec]
    Disabling IRQ #17

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=79301
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=111781
Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=728916
Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=895951#c16
Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1009819
Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1098621
Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1149632#c5
Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1279130
Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1332732
Cc: Chris Milsted <cmilsted@redhat.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Michael Buesch <m@bues.ch>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: x86@kernel.org
Cc: stable@vger.kernel.org
Tested-by: Konstantin Simanov <k.simanov@stlk.ru>        # [MacBookPro8,1]
Tested-by: Lukas Wunner <lukas@wunner.de>                # [MacBookPro9,1]
Tested-by: Bryan Paradis <bryan.paradis@gmail.com>       # [MacBookPro9,2]
Tested-by: Andrew Worsley <amworsley@gmail.com>          # [MacBookPro10,1]
Tested-by: Chris Bainbridge <chris.bainbridge@gmail.com> # [MacBookPro10,2]
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Acked-by: Rafał Miłecki <zajec5@gmail.com>
---
 arch/x86/kernel/early-quirks.c | 98 ++++++++++++++++++++++++++++++++++++------
 drivers/bcma/bcma_private.h    |  2 -
 include/linux/bcma/bcma.h      |  1 +
 3 files changed, 86 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index bca14c8..2d44f28 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -11,7 +11,11 @@
 
 #include <linux/pci.h>
 #include <linux/acpi.h>
+#include <linux/delay.h>
+#include <linux/dmi.h>
 #include <linux/pci_ids.h>
+#include <linux/bcma/bcma.h>
+#include <linux/bcma/bcma_regs.h>
 #include <drm/i915_drm.h>
 #include <asm/pci-direct.h>
 #include <asm/dma.h>
@@ -21,6 +25,7 @@
 #include <asm/iommu.h>
 #include <asm/gart.h>
 #include <asm/irq_remapping.h>
+#include <asm/early_ioremap.h>
 
 static void __init fix_hypertransport_config(int num, int slot, int func)
 {
@@ -76,6 +81,13 @@ static void __init nvidia_bugs(int num, int slot, int func)
 #ifdef CONFIG_ACPI
 #ifdef CONFIG_X86_IO_APIC
 	/*
+	 * Only applies to Nvidia root ports (bus 0) and not to
+	 * Nvidia graphics cards with PCI ports on secondary buses.
+	 */
+	if (num)
+		return;
+
+	/*
 	 * All timer overrides on Nvidia are
 	 * wrong unless HPET is enabled.
 	 * Unfortunately that's not true on many Asus boards.
@@ -590,6 +602,57 @@ static void __init force_disable_hpet(int num, int slot, int func)
 #endif
 }
 
+#define BCM4331_MMIO_SIZE	16384
+#define BCM4331_PM_CAP		0x40
+#define bcma_aread32(reg)	ioread32(mmio + 1 * BCMA_CORE_SIZE + reg)
+#define bcma_awrite32(reg, val)	iowrite32(val, mmio + 1 * BCMA_CORE_SIZE + reg)
+
+static void __init apple_airport_reset(int bus, int slot, int func)
+{
+	void __iomem *mmio;
+	u16 pmcsr;
+	u64 addr;
+	int i;
+
+	if (!dmi_match(DMI_SYS_VENDOR, "Apple Inc."))
+		return;
+
+	/* Card may have been put into PCI_D3hot by grub quirk */
+	pmcsr = read_pci_config_16(bus, slot, func,
+				   BCM4331_PM_CAP + PCI_PM_CTRL);
+	if ((pmcsr & PCI_PM_CTRL_STATE_MASK) != PCI_D0) {
+		pmcsr &= ~PCI_PM_CTRL_STATE_MASK;
+		write_pci_config_16(bus, slot, func,
+				    BCM4331_PM_CAP + PCI_PM_CTRL, pmcsr);
+		mdelay(10);
+		pmcsr = read_pci_config_16(bus, slot, func,
+					   BCM4331_PM_CAP + PCI_PM_CTRL);
+		if ((pmcsr & PCI_PM_CTRL_STATE_MASK) != PCI_D0) {
+			pr_err("Cannot power up Apple AirPort card\n");
+			return;
+		}
+	}
+
+	addr  =      read_pci_config(bus, slot, func, PCI_BASE_ADDRESS_0);
+	addr |= (u64)read_pci_config(bus, slot, func, PCI_BASE_ADDRESS_1) << 32;
+	addr &= PCI_BASE_ADDRESS_MEM_MASK;
+	mmio = early_ioremap(addr, BCM4331_MMIO_SIZE);
+	if (!mmio) {
+		pr_err("Cannot iomap Apple AirPort card\n");
+		return;
+	}
+
+	pr_info("Resetting Apple AirPort card\n");
+	for (i = 0; bcma_aread32(BCMA_RESET_ST) && i < 30; i++)
+		udelay(10);
+	bcma_awrite32(BCMA_RESET_CTL, BCMA_RESET_CTL_RESET);
+	bcma_aread32(BCMA_RESET_CTL);
+	udelay(1);
+	bcma_awrite32(BCMA_RESET_CTL, 0);
+	bcma_aread32(BCMA_RESET_CTL);
+	udelay(10);
+	early_iounmap(mmio, BCM4331_MMIO_SIZE);
+}
 
 #define QFLAG_APPLY_ONCE 	0x1
 #define QFLAG_APPLIED		0x2
@@ -603,12 +666,6 @@ struct chipset {
 	void (*f)(int num, int slot, int func);
 };
 
-/*
- * Only works for devices on the root bus. If you add any devices
- * not on bus 0 readd another loop level in early_quirks(). But
- * be careful because at least the Nvidia quirk here relies on
- * only matching on bus 0.
- */
 static struct chipset early_qrk[] __initdata = {
 	{ PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID,
 	  PCI_CLASS_BRIDGE_PCI, PCI_ANY_ID, QFLAG_APPLY_ONCE, nvidia_bugs },
@@ -638,9 +695,13 @@ static struct chipset early_qrk[] __initdata = {
 	 */
 	{ PCI_VENDOR_ID_INTEL, 0x0f00,
 		PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, force_disable_hpet},
+	{ PCI_VENDOR_ID_BROADCOM, 0x4331,
+	  PCI_CLASS_NETWORK_OTHER, PCI_ANY_ID, 0, apple_airport_reset},
 	{}
 };
 
+static void __init early_pci_scan_bus(int bus);
+
 /**
  * check_dev_quirk - apply early quirks to a given PCI device
  * @num: bus number
@@ -649,7 +710,7 @@ static struct chipset early_qrk[] __initdata = {
  *
  * Check the vendor & device ID against the early quirks table.
  *
- * If the device is single function, let early_quirks() know so we don't
+ * If the device is single function, let early_pci_scan_bus() know so we don't
  * poke at this device again.
  */
 static int __init check_dev_quirk(int num, int slot, int func)
@@ -658,6 +719,7 @@ static int __init check_dev_quirk(int num, int slot, int func)
 	u16 vendor;
 	u16 device;
 	u8 type;
+	u8 sec;
 	int i;
 
 	class = read_pci_config_16(num, slot, func, PCI_CLASS_DEVICE);
@@ -685,25 +747,35 @@ static int __init check_dev_quirk(int num, int slot, int func)
 
 	type = read_pci_config_byte(num, slot, func,
 				    PCI_HEADER_TYPE);
+
+	if ((type & 0x7f) == PCI_HEADER_TYPE_BRIDGE) {
+		sec = read_pci_config_byte(num, slot, func, PCI_SECONDARY_BUS);
+		early_pci_scan_bus(sec);
+	}
+
 	if (!(type & 0x80))
 		return -1;
 
 	return 0;
 }
 
-void __init early_quirks(void)
+static void __init early_pci_scan_bus(int bus)
 {
 	int slot, func;
 
-	if (!early_pci_allowed())
-		return;
-
 	/* Poor man's PCI discovery */
-	/* Only scan the root bus */
 	for (slot = 0; slot < 32; slot++)
 		for (func = 0; func < 8; func++) {
 			/* Only probe function 0 on single fn devices */
-			if (check_dev_quirk(0, slot, func))
+			if (check_dev_quirk(bus, slot, func))
 				break;
 		}
 }
+
+void __init early_quirks(void)
+{
+	if (!early_pci_allowed())
+		return;
+
+	early_pci_scan_bus(0);
+}
diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
index eda0909..f642c42 100644
--- a/drivers/bcma/bcma_private.h
+++ b/drivers/bcma/bcma_private.h
@@ -8,8 +8,6 @@
 #include <linux/bcma/bcma.h>
 #include <linux/delay.h>
 
-#define BCMA_CORE_SIZE		0x1000
-
 #define bcma_err(bus, fmt, ...) \
 	pr_err("bus%d: " fmt, (bus)->num, ##__VA_ARGS__)
 #define bcma_warn(bus, fmt, ...) \
diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index 0367c63..5c37b58 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -158,6 +158,7 @@ struct bcma_host_ops {
 #define BCMA_CORE_DEFAULT		0xFFF
 
 #define BCMA_MAX_NR_CORES		16
+#define BCMA_CORE_SIZE			0x1000
 
 /* Chip IDs of PCIe devices */
 #define BCMA_CHIP_ID_BCM4313	0x4313
-- 
2.8.1

