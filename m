Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout1.hostsharing.net ([83.223.95.204]:41632 "EHLO
	mailout1.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933812AbcDLS3x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2016 14:29:53 -0400
Date: Tue, 12 Apr 2016 20:32:02 +0200
From: Lukas Wunner <lukas@wunner.de>
To: Andrew Worsley <amworsley@gmail.com>
Cc: b43-dev@lists.infradead.org, linux-pci@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] PCI: Add Broadcom 4331 reset quirk to prevent IRQ storm
Message-ID: <20160412183202.GC13637@wunner.de> (sfid-20160412_202957_415246_84D5C061)
References: <E1akxli-00030z-BC@bombadil.infradead.org>
 <CA+Y=x3=cLDHc7PK5h9n=ixdgVKWdVSu_v+-7jHJ-vBnDrv4sgg@mail.gmail.com>
 <20160403114912.GA11540@wunner.de>
 <CA+Y=x3nfe7CniNhruOhGmdxY3g4B1n3YRVWChoVYJns7D8pNEg@mail.gmail.com>
 <CA+Y=x3mVrSKMgzy74xtO5ZOc5kYLYU=iKZgqyjn0j94bXoebjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <CA+Y=x3mVrSKMgzy74xtO5ZOc5kYLYU=iKZgqyjn0j94bXoebjg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andrew,

thank you for the extensive testing.

On Sun, Apr 10, 2016 at 08:09:29PM +1000, Andrew Worsley wrote:
> Further testing Broadcom 4331 reset quirk to prevent IRQ storm patch
> testing reveals that:
>   1. quirk is run on initial boot up and this time appears to have
> vastly reduced the interrupts (only 81 this time):
> cat /proc/interrupts| grep 17
>  17:         81          0          0          0          0          0
>          0          0   IO-APIC-fasteoi   snd_hda_intel

Something in the ballpark of 81 interrupt requests is fine.

The kernel will print the error message about spurious interrupts and
switch to polling at 100000 requests. But even 20000 is way too much.
This just means that b43 loaded quickly enough to stop the interrupts
before the kernel limit of 100000 was reached, but the wireless card
wasn't reset early on as it should have been.

It looks like the patch didn't work at all on your machine for some
reason. Do you see a message "cannot iomap device, IRQ storm ahead"
in dmesg?

Included below is a slightly different patch which is based on the
3.16.7-ckt tree (so it should apply cleanly to your kernel version).
This version prints a message when the wireless card is reset. Please
verify that you see the message "b43 quirk: resetting controller" in
dmesg with this patch. This version of the patch also resets the card
a bit earlier in the boot process than the previous version did.
Please let me know if this improves the situation on your machine.

You might also want to try a newer kernel version, 3.16 is very old
and I'm not sure if there have been any changes since which might
negatively impact proper functioning of the patch. There are also
official 4.4 kernels available for Jessie. Canonical ends support
for the 3.16.y-ckt series anyway this month.


> Presently I have a grub work around for black screen as described here:
>   http://askubuntu.com/questions/264247/proprietary-nvidia-drivers-with-efi-on-mac-to-prevent-overheating/613573#613573
> 
> which basically involves adding a grub scriptlet to enable PCI-E bus
> mastering on graphics cards:
> 
> In /etc/grub.d/01_enable_vga.conf:
> 
> setpci -s "00:01.0" 3e.b=8
> setpci -s "01:00.0" 04.b=7

I think you need to upgrade to a newer version of the Nvidia driver,
I have just verified that 352.63 will set the busmaster bit if it's
cleared.


> Can we do some similar magic setpci commands to disable 04:00.0
> which is my BCM4331

I think grub is also able to write to mmio space of a PCI device,
which is what's necessary to reset the wireless card, so theoretically
yes, but the right place to fix this is in the kernel since not
everyone is using grub.

Best regards,

Lukas

-- >8 --
Subject: [PATCH] PCI: Add Broadcom 4331 reset quirk to prevent IRQ storm

Broadcom 4331 wireless cards built into Apple Macs unleash an IRQ storm
on boot until they are reset, causing spurious interrupts if the IRQ is
shared. Apparently the EFI bootloader enables the device and does not
disable it before passing control to the OS. The bootloader contains a
driver for the wireless card which allows it to phone home to Cupertino.
This is used for Internet Recovery (download and install OS X images)
and probably also for Back to My Mac (remote access, RFC 6281) and to
discover stolen hardware.

The issue is most pronounced on 2011 and 2012 MacBook Pros where the IRQ
is shared with 3 other devices (Light Ridge Thunderbolt controller, SDXC
reader, HDA card on discrete GPU). As soon as an interrupt handler is
installed for one of these devices, the ensuing storm of spurious IRQs
causes the kernel to disable the IRQ and switch to polling. This lasts
until the b43 driver loads and resets the device.

Loading the b43 driver first is not always an option, in particular with
the Light Ridge Thunderbolt controller: The PCI hotplug IRQ handler gets
installed early on because it is built in, unlike b43 which is usually
a module.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=79301
Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=895951
Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1009819
Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1149632
Cc: <stable@vger.kernel.org>
Tested-by: Lukas Wunner <lukas@wunner.de> [MacBookPro9,1]
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Acked-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/bcma_private.h |  2 --
 drivers/pci/quirks.c        | 28 ++++++++++++++++++++++++++++
 include/linux/bcma/bcma.h   |  1 +
 3 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
index 09b632a..7ded994 100644
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
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 1f5ea24..5a33924 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -25,6 +25,8 @@
 #include <linux/sched.h>
 #include <linux/ktime.h>
 #include <linux/mm.h>
+#include <linux/bcma/bcma.h>
+#include <linux/bcma/bcma_regs.h>
 #include <asm/dma.h>	/* isa_dma_bridge_buggy */
 #include "pci.h"
 
@@ -3082,6 +3084,32 @@ static void quirk_no_bus_reset(struct pci_dev *dev)
  */
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x0030, quirk_no_bus_reset);
 
+/*
+ * Broadcom 4331 wireless cards built into Apple Macs unleash an IRQ storm
+ * on boot until they are reset, causing spurious interrupts if the IRQ is
+ * shared. Apparently the EFI bootloader enables the device to phone home
+ * to Cupertino and does not disable it before passing control to the OS.
+ */
+static void quirk_apple_b43_reset(struct pci_dev *dev)
+{
+	void __iomem *mmio;
+
+	if (!dmi_match(DMI_SYS_VENDOR, "Apple Inc.") || !dev->bus->self ||
+	    pci_pcie_type(dev->bus->self) != PCI_EXP_TYPE_ROOT_PORT)
+		return;
+
+	mmio = pci_iomap(dev, 0, 0);
+	if (!mmio) {
+		dev_err(&dev->dev, "b43 quirk: cannot iomap device, IRQ storm ahead\n");
+		return;
+	}
+	dev_info(&dev->dev, "b43 quirk: resetting controller\n");
+	iowrite32(BCMA_RESET_CTL_RESET,
+		  mmio + (1 * BCMA_CORE_SIZE) + BCMA_RESET_CTL);
+	pci_iounmap(dev, mmio);
+}
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_BROADCOM, 0x4331, quirk_apple_b43_reset);
+
 static void pci_do_fixups(struct pci_dev *dev, struct pci_fixup *f,
 			  struct pci_fixup *end)
 {
diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index 0b3bb16..b19c7ed 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -153,6 +153,7 @@ struct bcma_host_ops {
 #define BCMA_CORE_DEFAULT		0xFFF
 
 #define BCMA_MAX_NR_CORES		16
+#define BCMA_CORE_SIZE			0x1000
 
 /* Chip IDs of PCIe devices */
 #define BCMA_CHIP_ID_BCM4313	0x4313
-- 
1.8.5.2 (Apple Git-48)

