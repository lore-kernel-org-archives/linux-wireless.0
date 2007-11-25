Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hermes.matws.net ([88.175.162.123]:57042 "EHLO smtp.matws.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754480AbXKYSZQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Nov 2007 13:25:16 -0500
Message-ID: <4749BE06.8050601@matws.net> (sfid-20071125_182524_249128_8E73451A)
Date: Sun, 25 Nov 2007 21:25:10 +0300
From: Matthieu PATOU <mat@matws.net>
MIME-Version: 1.0
To: Larry Finger <larry.finger@lwfinger.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: BCM4312 status
References: <47469E42.6050909@matws.net> <474984B1.90302@matws.net> <47499A1A.1060307@lwfinger.net>
In-Reply-To: <47499A1A.1060307@lwfinger.net>
Content-Type: multipart/mixed;
 boundary="------------010906060500040901040407"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010906060500040901040407
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Larry Finger a écrit :
> Matthieu PATOU wrote:
>> And it keeps looping around the same set of message.
>>
>> Any clue on to solve this problem ?
>> Any patch that i can test ?
> These messages should only arise if you were using an unpatched kernel. 
> Are you sure you put the patch in correctly?
The results reported was with your previous patch, because the second version didn't show good results when I first tried.
So I tried the previous, which obviously didn't do the job neither !

So i removed the first patch, applied the second, checked, rebuild the modules, reboot the notebook a couple of time but 
I still have DMA errors.
I attached the result of my dmesg and the patch I use in case i took the wrong one.
I checked right now that this patch is really applied with this command :

mat@ares:/usr/local/src/linux-2.6.24-git# patch -p1  --dry-run -R <../patchs/patch_bcm4312_2
patching file drivers/net/wireless/b43/dma.c
patching file drivers/net/wireless/b43/main.c
patching file drivers/net/wireless/b43/wa.c

HTH

Matthieu.


--------------010906060500040901040407
Content-Type: text/plain;
 name="patch_bcm4312_2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch_bcm4312_2"

 dma.c  |   86 ++++++++++++++++++++++++++++++++++-------------------------------
 main.c |    3 +-
 wa.c   |    1
 3 files changed, 49 insertions(+), 41 deletions(-)

Index: wireless-2.6/drivers/net/wireless/b43/dma.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/dma.c
+++ wireless-2.6/drivers/net/wireless/b43/dma.c
@@ -165,7 +165,7 @@ static void op64_fill_descriptor(struct 
 	addrhi = (((u64) dmaaddr >> 32) & ~SSB_DMA_TRANSLATION_MASK);
 	addrext = (((u64) dmaaddr >> 32) & SSB_DMA_TRANSLATION_MASK)
 	    >> SSB_DMA_TRANSLATION_SHIFT;
-	addrhi |= ssb_dma_translation(ring->dev->dev);
+	addrhi |= (ssb_dma_translation(ring->dev->dev) << 1);
 	if (slot == ring->nr_slots - 1)
 		ctl0 |= B43_DMA64_DCTL0_DTABLEEND;
 	if (start)
@@ -426,9 +426,20 @@ static inline
 static int alloc_ringmemory(struct b43_dmaring *ring)
 {
 	struct device *dev = ring->dev->dev->dev;
+	gfp_t flags = GFP_KERNEL;
 
+	/* The specs call for 4K buffers for 30- and 32-bit DMA
+	 * and 8K buffers for 64-bit DMA; however, 4K is sufficient for
+	 * the latter as long as the buffer does not cross an 8K boundary.
+	 *
+	 * For unknown reasons - possibly a hardware error - the BCM4311 rev
+	 * 02, which uses 64-bit DMA, needs the ring buffer in very low memory,
+	 * which accounts for the GFP_DMA flag below.
+	 */
+	if (ring->dma64)
+		flags = GFP_DMA;
 	ring->descbase = dma_alloc_coherent(dev, B43_DMA_RINGMEMSIZE,
-					    &(ring->dmabase), GFP_KERNEL);
+					    &(ring->dmabase), flags);
 	if (!ring->descbase) {
 		b43err(ring->dev->wl, "DMA ringmemory allocation failed\n");
 		return -ENOMEM;
@@ -483,7 +494,7 @@ int b43_dmacontroller_rx_reset(struct b4
 	return 0;
 }
 
-/* Reset the RX DMA channel */
+/* Reset the TX DMA channel */
 int b43_dmacontroller_tx_reset(struct b43_wldev *dev, u16 mmio_base, int dma64)
 {
 	int i;
@@ -636,18 +647,12 @@ static int dmacontroller_setup(struct b4
 		if (ring->dma64) {
 			u64 ringbase = (u64) (ring->dmabase);
 
-			addrext = ((ringbase >> 32) & SSB_DMA_TRANSLATION_MASK)
-			    >> SSB_DMA_TRANSLATION_SHIFT;
-			value = B43_DMA64_TXENABLE;
-			value |= (addrext << B43_DMA64_TXADDREXT_SHIFT)
-			    & B43_DMA64_TXADDREXT_MASK;
-			b43_dma_write(ring, B43_DMA64_TXCTL, value);
+			b43_dma_write(ring, B43_DMA64_TXCTL,
+				      B43_DMA64_TXENABLE);
 			b43_dma_write(ring, B43_DMA64_TXRINGLO,
 				      (ringbase & 0xFFFFFFFF));
 			b43_dma_write(ring, B43_DMA64_TXRINGHI,
-				      ((ringbase >> 32) &
-				       ~SSB_DMA_TRANSLATION_MASK)
-				      | trans);
+				      (ringbase >> 32));
 		} else {
 			u32 ringbase = (u32) (ring->dmabase);
 
@@ -668,20 +673,15 @@ static int dmacontroller_setup(struct b4
 		if (ring->dma64) {
 			u64 ringbase = (u64) (ring->dmabase);
 
-			addrext = ((ringbase >> 32) & SSB_DMA_TRANSLATION_MASK)
-			    >> SSB_DMA_TRANSLATION_SHIFT;
-			value = (ring->frameoffset << B43_DMA64_RXFROFF_SHIFT);
-			value |= B43_DMA64_RXENABLE;
-			value |= (addrext << B43_DMA64_RXADDREXT_SHIFT)
-			    & B43_DMA64_RXADDREXT_MASK;
+			value = (ring->frameoffset << B43_DMA64_RXFROFF_SHIFT)
+				| B43_DMA64_RXENABLE;
 			b43_dma_write(ring, B43_DMA64_RXCTL, value);
 			b43_dma_write(ring, B43_DMA64_RXRINGLO,
 				      (ringbase & 0xFFFFFFFF));
 			b43_dma_write(ring, B43_DMA64_RXRINGHI,
-				      ((ringbase >> 32) &
-				       ~SSB_DMA_TRANSLATION_MASK)
-				      | trans);
-			b43_dma_write(ring, B43_DMA64_RXINDEX, 200);
+				      (ringbase >> 32));
+			b43_dma_write(ring, B43_DMA64_RXINDEX, ring->nr_slots *
+				      sizeof(struct b43_dmadesc64));
 		} else {
 			u32 ringbase = (u32) (ring->dmabase);
 
@@ -695,11 +695,12 @@ static int dmacontroller_setup(struct b4
 			b43_dma_write(ring, B43_DMA32_RXRING,
 				      (ringbase & ~SSB_DMA_TRANSLATION_MASK)
 				      | trans);
-			b43_dma_write(ring, B43_DMA32_RXINDEX, 200);
+			b43_dma_write(ring, B43_DMA32_RXINDEX, ring->nr_slots *
+				      sizeof(struct b43_dmadesc32));
 		}
 	}
 
-      out:
+out:
 	return err;
 }
 
@@ -954,19 +955,21 @@ int b43_dma_init(struct b43_wldev *dev)
 
 	err = -ENOMEM;
 	/* setup TX DMA channels. */
-	ring = b43_setup_dmaring(dev, 0, 1, dma64);
+	ring = b43_setup_dmaring(dev, 1, 1, dma64);
 	if (!ring)
 		goto out;
-	dma->tx_ring0 = ring;
+	dma->tx_ring1 = ring;
 
-	ring = b43_setup_dmaring(dev, 1, 1, dma64);
+	/* The driver only uses ring1 for TX - skip setup for the rest */
+#if 0
+	ring = b43_setup_dmaring(dev, 0, 1, dma64);
 	if (!ring)
-		goto err_destroy_tx0;
-	dma->tx_ring1 = ring;
+		goto err_destroy_tx1;
+	dma->tx_ring0 = ring;
 
 	ring = b43_setup_dmaring(dev, 2, 1, dma64);
 	if (!ring)
-		goto err_destroy_tx1;
+		goto err_destroy_tx0;
 	dma->tx_ring2 = ring;
 
 	ring = b43_setup_dmaring(dev, 3, 1, dma64);
@@ -983,6 +986,7 @@ int b43_dma_init(struct b43_wldev *dev)
 	if (!ring)
 		goto err_destroy_tx4;
 	dma->tx_ring5 = ring;
+#endif
 
 	/* setup RX DMA channels. */
 	ring = b43_setup_dmaring(dev, 0, 0, dma64);
@@ -1001,30 +1005,32 @@ int b43_dma_init(struct b43_wldev *dev)
 	       (dmamask == DMA_64BIT_MASK) ? 64 :
 	       (dmamask == DMA_32BIT_MASK) ? 32 : 30);
 	err = 0;
-      out:
+out:
 	return err;
 
-      err_destroy_rx0:
+err_destroy_rx0:
 	b43_destroy_dmaring(dma->rx_ring0);
 	dma->rx_ring0 = NULL;
-      err_destroy_tx5:
+err_destroy_tx5:
+#if 0
 	b43_destroy_dmaring(dma->tx_ring5);
 	dma->tx_ring5 = NULL;
-      err_destroy_tx4:
+err_destroy_tx4:
 	b43_destroy_dmaring(dma->tx_ring4);
 	dma->tx_ring4 = NULL;
-      err_destroy_tx3:
+err_destroy_tx3:
 	b43_destroy_dmaring(dma->tx_ring3);
 	dma->tx_ring3 = NULL;
-      err_destroy_tx2:
+err_destroy_tx2:
 	b43_destroy_dmaring(dma->tx_ring2);
 	dma->tx_ring2 = NULL;
-      err_destroy_tx1:
-	b43_destroy_dmaring(dma->tx_ring1);
-	dma->tx_ring1 = NULL;
-      err_destroy_tx0:
+err_destroy_tx0:
 	b43_destroy_dmaring(dma->tx_ring0);
 	dma->tx_ring0 = NULL;
+err_destroy_tx1:
+#endif
+	b43_destroy_dmaring(dma->tx_ring1);
+	dma->tx_ring1 = NULL;
 	goto out;
 }
 
Index: wireless-2.6/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/main.c
+++ wireless-2.6/drivers/net/wireless/b43/main.c
@@ -93,6 +93,7 @@ static const struct ssb_device_id b43_ss
 	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 7),
 	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 9),
 	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 10),
+	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 13),
 	SSB_DEVTABLE_END
 };
 
@@ -3064,7 +3065,7 @@ static int b43_phy_versioning(struct b43
 			unsupported = 1;
 		break;
 	case B43_PHYTYPE_G:
-		if (phy_rev > 8)
+		if (phy_rev > 9)
 			unsupported = 1;
 		break;
 	default:
Index: wireless-2.6/drivers/net/wireless/b43/wa.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/wa.c
+++ wireless-2.6/drivers/net/wireless/b43/wa.c
@@ -642,6 +642,7 @@ void b43_wa_all(struct b43_wldev *dev)
 		case 6:
 		case 7:
 		case 8:
+		case 9:
 			b43_wa_tr_ltov(dev);
 			b43_wa_crs_ed(dev);
 			b43_wa_rssi_lt(dev);
-

--------------010906060500040901040407
Content-Type: text/plain;
 name="load_b43"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="load_b43"

[    0.000000] Linux version 2.6.24-rc3-ares (root@ares) (gcc version 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)) #1 SMP Thu Nov 22 20:31:05 MSK 2007
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 0000000077fb0000 (usable)
[    0.000000]  BIOS-e820: 0000000077fb0000 - 0000000077fc8000 (reserved)
[    0.000000]  BIOS-e820: 0000000077fc8000 - 0000000077fe7fb8 (ACPI NVS)
[    0.000000]  BIOS-e820: 0000000077fe7fb8 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec02000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffbc0000 - 00000000ffcc0000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000] 1023MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] Entering add_active_range(0, 0, 491440) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->   491440
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   491440
[    0.000000] On node 0 totalpages: 491440
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 1760 pages used for memmap
[    0.000000]   Normal zone: 223520 pages, LIFO batch:31
[    0.000000]   HighMem zone: 2047 pages used for memmap
[    0.000000]   HighMem zone: 260017 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] DMI 2.4 present.
[    0.000000] ACPI: RSDP 000FE0B0, 0024 (r2 HP    )
[    0.000000] ACPI: XSDT 77FC81BC, 0064 (r1 HPQOEM SLIC-MPC        1 HP          1)
[    0.000000] ACPI: FACP 77FC8084, 00F4 (r4 HP     0944            3 HP          1)
[    0.000000] ACPI Error (tbfadt-0453): 32/64X address mismatch in "Pm2ControlBlock": [00008800] [0000000000008100], using 64X [20070126]
[    0.000000] ACPI: DSDT 77FC84A4, 11437 (r1 HP        SB400    10000 MSFT  3000001)
[    0.000000] ACPI: FACS 77FE7D80, 0040
[    0.000000] ACPI: SLIC 77FC8220, 0176 (r1 HPQOEM SLIC-MPC        1 HP          1)
[    0.000000] ACPI: EPTH 77FC8398, 0038 (r1 HP     0944            1 HP          1)
[    0.000000] ACPI: APIC 77FC83D0, 0062 (r1 HP     0944            1 HP          1)
[    0.000000] ACPI: MCFG 77FC8434, 003C (r1 HP     0944            1 HP          1)
[    0.000000] ACPI: TCPA 77FC8470, 0032 (r2 HP     0944            1 HP          1)
[    0.000000] ACPI: SSDT 77FD98DB, 0059 (r1 HP       HPQNLP        1 MSFT  3000001)
[    0.000000] ACPI: SSDT 77FD9934, 0206 (r1 HP     PSSTBLID        1 HP          1)
[    0.000000] ATI board detected. Disabling timer routing over 8254.
[    0.000000] ACPI: PM-Timer IO Port: 0x8008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 15:8 APIC version 16
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] Processor #1 15:8 APIC version 16
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 88000000 (gap: 80000000:60000000)
[    0.000000] swsusp: Registered nosave memory region: 000000000009f000 - 00000000000a0000
[    0.000000] swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000e0000
[    0.000000] swsusp: Registered nosave memory region: 00000000000e0000 - 0000000000100000
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 487601
[    0.000000] Kernel command line: root=UUID=c7767a2d-354a-4a6a-b52a-43e1cae66973 ro 
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 1995.037 MHz processor.
[   26.365127] Console: colour VGA+ 80x25
[   26.365130] console [tty0] enabled
[   26.370562] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[   26.371358] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[   26.524443] Memory: 1940136k/1965760k available (1949k kernel code, 24424k reserved, 946k data, 220k init, 1048256k highmem)
[   26.524545] virtual kernel memory layout:
[   26.524546]     fixmap  : 0xfff4d000 - 0xfffff000   ( 712 kB)
[   26.524547]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[   26.524548]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
[   26.524550]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[   26.524551]       .init : 0xc03d9000 - 0xc0410000   ( 220 kB)
[   26.524552]       .data : 0xc02e74f6 - 0xc03d3d84   ( 946 kB)
[   26.524553]       .text : 0xc0100000 - 0xc02e74f6   (1949 kB)
[   26.525176] Checking if this processor honours the WP bit even in supervisor mode... Ok.
[   26.525401] SLUB: Genslabs=11, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
[   26.605477] Calibrating delay using timer specific routine.. 3997.94 BogoMIPS (lpj=7995896)
[   26.605676] Security Framework initialized
[   26.605751] SELinux:  Disabled at boot.
[   26.605849] Mount-cache hash table entries: 512
[   26.606141] CPU: After generic identify, caps: 178bfbff ebd3fbff 00000000 00000000 00002001 00000000 0000011f 00000000
[   26.606165] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[   26.606240] CPU: L2 Cache: 512K (64 bytes/line)
[   26.606330] CPU: After all inits, caps: 178bfbff ebd3fbff 00000000 00000410 00002001 00000000 0000011f 00000000
[   26.606338] Compat vDSO mapped to ffffe000.
[   26.606435] Checking 'hlt' instruction... OK.
[   26.621954] SMP alternatives: switching to UP code
[   26.622912] ACPI: Core revision 20070126
[   26.711975] CPU0: AMD Turion(tm) 64 X2 Mobile Technology TL-60 stepping 01
[   26.712093] SMP alternatives: switching to SMP code
[   26.712493] Booting processor 1/1 eip 3000
[   26.721030] Initializing CPU#1
[   26.799856] Calibrating delay using timer specific routine.. 3990.34 BogoMIPS (lpj=7980692)
[   26.799862] CPU: After generic identify, caps: 178bfbff ebd3fbff 00000000 00000000 00002001 00000000 0000011f 00000000
[   26.799867] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[   26.799869] CPU: L2 Cache: 512K (64 bytes/line)
[   26.799871] AMD C1E detected late. 	Force timer broadcast.
[   26.799873] CPU: After all inits, caps: 178bfbff ebd3fbff 00000000 00000410 00002001 00000000 0000011f 00000000
[   26.801583] CPU1: AMD Turion(tm) 64 X2 Mobile Technology TL-60 stepping 01
[   26.801876] Total of 2 processors activated (7988.29 BogoMIPS).
[   26.802055] ENABLING IO-APIC IRQs
[   26.802256] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[   26.842039] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
[   26.842077] ...trying to set up timer (IRQ0) through the 8259A ...  failed.
[   26.842146] ...trying to set up timer as Virtual Wire IRQ... works.
[   26.882076] Brought up 2 CPUs
[   26.882131] CPU0 attaching sched-domain:
[   26.882133]  domain 0: span 03
[   26.882135]   groups: 01 02
[   26.882138] CPU1 attaching sched-domain:
[   26.882139]  domain 0: span 03
[   26.882141]   groups: 02 01
[   26.882327] net_namespace: 64 bytes
[   26.882373] HP Compaq Laptop series board detected. Selecting BIOS-method for reboots.
[   26.882863] NET: Registered protocol family 16
[   26.883037] ACPI: bus type pci registered
[   26.883151] PCI: Using MMCONFIG
[   26.883222] PCI: No mmconfig possible on device 00:18
[   26.883827] Setting up standard PCI resources
[   26.885605] ACPI: EC: Look up EC in DSDT
[   26.884739] ACPI: EC: non-query interrupt received, switching to interrupt mode
[   27.125082] ACPI: Interpreter enabled
[   27.125120] ACPI: (supports S0 S3 S4 S5)
[   27.125287] ACPI: Using IOAPIC for interrupt routing
[   27.132662] ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[   27.132702] ACPI: EC: driver started in interrupt mode
[   27.132787] ACPI: PCI Root Bridge [C08B] (0000:00)
[   27.134272] PCI: Transparent bridge - 0000:00:14.4
[   27.134401] ACPI: PCI Interrupt Routing Table [\_SB_.C08B._PRT]
[   27.134665] ACPI: PCI Interrupt Routing Table [\_SB_.C08B.C08C._PRT]
[   27.134770] ACPI: PCI Interrupt Routing Table [\_SB_.C08B.C0FC._PRT]
[   27.153338] ACPI: PCI Interrupt Link [C145] (IRQs 10 11) *0, disabled.
[   27.153706] ACPI: PCI Interrupt Link [C146] (IRQs 10 11) *0, disabled.
[   27.154069] ACPI: PCI Interrupt Link [C147] (IRQs 10 11) *0, disabled.
[   27.154434] ACPI: PCI Interrupt Link [C148] (IRQs 10 11) *0, disabled.
[   27.154800] ACPI: PCI Interrupt Link [C149] (IRQs 10 11) *0, disabled.
[   27.155164] ACPI: PCI Interrupt Link [C14A] (IRQs 9) *0, disabled.
[   27.155499] ACPI: PCI Interrupt Link [C14B] (IRQs 10 11) *0, disabled.
[   27.155863] ACPI: PCI Interrupt Link [C14C] (IRQs 10 11) *0, disabled.
[   27.156203] ACPI: Power Resource [C171] (off)
[   27.156287] ACPI: Power Resource [C24C] (on)
[   27.156433] ACPI: Power Resource [C395] (off)
[   27.156556] ACPI: Power Resource [C396] (off)
[   27.156679] ACPI: Power Resource [C397] (off)
[   27.156802] ACPI: Power Resource [C398] (off)
[   27.156884] Linux Plug and Play Support v0.97 (c) Adam Belay
[   27.156946] pnp: PnP ACPI init
[   27.156987] ACPI: bus type pnp registered
[   27.163088] pnp: PnP ACPI: found 12 devices
[   27.163126] ACPI: ACPI bus type pnp unregistered
[   27.163264] PCI: Using ACPI for IRQ routing
[   27.163301] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[   27.163373] PCI: Cannot allocate resource region 0 of device 0000:00:14.2
[   27.192337] system 00:00: iomem range 0x0-0x9ffff could not be reserved
[   27.192377] system 00:00: iomem range 0xe0000-0xfffff could not be reserved
[   27.192415] system 00:00: iomem range 0x100000-0xffffffff could not be reserved
[   27.192463] system 00:08: ioport range 0x40b-0x40b has been reserved
[   27.192502] system 00:08: ioport range 0x4d0-0x4d1 has been reserved
[   27.192542] system 00:08: iomem range 0xffb00000-0xffbfffff could not be reserved
[   27.192585] system 00:08: iomem range 0xfff00000-0xffffffff could not be reserved
[   27.192630] system 00:0a: ioport range 0x8000-0x802f has been reserved
[   27.192669] system 00:0a: ioport range 0x8100-0x811f has been reserved
[   27.192708] system 00:0a: iomem range 0xe0000000-0xefffffff could not be reserved
[   27.192751] system 00:0a: iomem range 0xfec00000-0xfec000ff could not be reserved
[   27.192794] system 00:0a: iomem range 0xfed45000-0xfed8ffff has been reserved
[   27.192836] system 00:0b: iomem range 0xcd400-0xcffff has been reserved
[   27.192875] system 00:0b: iomem range 0x0-0x7ffffff could not be reserved
[   27.192914] system 00:0b: iomem range 0xfee00000-0xfee00fff has been reserved
[   27.223313] PCI: Bridge: 0000:00:01.0
[   27.223351]   IO window: 4000-4fff
[   27.223389]   MEM window: d0400000-d05fffff
[   27.223426]   PREFETCH window: c0000000-c7ffffff
[   27.223465] PCI: Bridge: 0000:00:04.0
[   27.223501]   IO window: disabled.
[   27.223540]   MEM window: d0000000-d00fffff
[   27.223577]   PREFETCH window: disabled.
[   27.223614] PCI: Bridge: 0000:00:05.0
[   27.223652]   IO window: 2000-3fff
[   27.223689]   MEM window: cc000000-cfffffff
[   27.223726]   PREFETCH window: disabled.
[   27.223764] PCI: Bridge: 0000:00:06.0
[   27.223801]   IO window: disabled.
[   27.223838]   MEM window: c8000000-c80fffff
[   27.223876]   PREFETCH window: disabled.
[   27.223917] PCI: Bus 3, cardbus bridge: 0000:02:04.0
[   27.223956]   IO window: 00001000-000010ff
[   27.225808] Time: acpi_pm clocksource has been installed.
[   27.225811] Clockevents: could not switch to one-shot mode: lapic is not functional.
[   27.225813] Could not switch to high resolution mode on CPU 0
[   27.224904] Clockevents: could not switch to one-shot mode: lapic is not functional.
[   27.224978] Could not switch to high resolution mode on CPU 1
[   27.225019]   IO window: 00001400-000014ff
[   27.225059]   PREFETCH window: 8c000000-8fffffff
[   27.225099]   MEM window: 90000000-93ffffff
[   27.225138] PCI: Bridge: 0000:00:14.4
[   27.225174]   IO window: disabled.
[   27.225213]   MEM window: d0100000-d03fffff
[   27.225252]   PREFETCH window: disabled.
[   27.225302] PCI: Setting latency timer of device 0000:00:04.0 to 64
[   27.225308] PCI: Setting latency timer of device 0000:00:05.0 to 64
[   27.225314] PCI: Setting latency timer of device 0000:00:06.0 to 64
[   27.225335] ACPI: PCI Interrupt 0000:02:04.0[A] -> GSI 20 (level, low) -> IRQ 16
[   27.225422] NET: Registered protocol family 2
[   27.268347] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[   27.268667] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[   27.269360] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[   27.269704] TCP: Hash tables configured (established 131072 bind 65536)
[   27.269745] TCP reno registered
[   27.280398] checking if image is initramfs... it is
[   27.651295] Freeing initrd memory: 4498k freed
[   27.651962] audit: initializing netlink socket (disabled)
[   27.652010] audit(1196014372.020:1): initialized
[   27.652194] highmem bounce pool size: 64 pages
[   27.653998] io scheduler noop registered
[   27.654035] io scheduler anticipatory registered
[   27.654072] io scheduler deadline registered
[   27.654159] io scheduler cfq registered (default)
[   27.654261] Boot video device is 0000:01:05.0
[   27.654364] PCI: Setting latency timer of device 0000:00:04.0 to 64
[   27.654380] assign_interrupt_mode Found MSI capability
[   27.654418] Allocate Port Service[0000:00:04.0:pcie00]
[   27.654449] Allocate Port Service[0000:00:04.0:pcie03]
[   27.654499] PCI: Setting latency timer of device 0000:00:05.0 to 64
[   27.654514] assign_interrupt_mode Found MSI capability
[   27.654553] Allocate Port Service[0000:00:05.0:pcie00]
[   27.654585] Allocate Port Service[0000:00:05.0:pcie03]
[   27.654635] PCI: Setting latency timer of device 0000:00:06.0 to 64
[   27.654649] assign_interrupt_mode Found MSI capability
[   27.654688] Allocate Port Service[0000:00:06.0:pcie00]
[   27.654719] Allocate Port Service[0000:00:06.0:pcie03]
[   27.677129] Real Time Clock Driver v1.12ac
[   27.677274] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
[   27.678313] RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
[   27.678360] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
[   27.678399] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
[   27.678686] PNP: PS/2 Controller [PNP0303:C249,PNP0f13:C24A] at 0x60,0x64 irq 1,12
[   27.680633] i8042.c: Detected active multiplexing controller, rev 1.1.
[   27.681441] serio: i8042 KBD port at 0x60,0x64 irq 1
[   27.681483] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[   27.681522] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[   27.681564] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[   27.681605] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[   27.681724] mice: PS/2 mouse device common for all mice
[   27.681872] cpuidle: using governor ladder
[   27.681910] cpuidle: using governor menu
[   27.682016] TCP cubic registered
[   27.682061] NET: Registered protocol family 1
[   27.682117] Starting balanced_irq
[   27.682171] Using IPI No-Shortcut mode
[   27.682217] registered taskstats version 1
[   27.682556] Freeing unused kernel memory: 220k freed
[   27.705191] input: AT Translated Set 2 keyboard as /class/input/input0
[   27.833398] fuse init (API version 7.9)
[   27.836268] ACPI: Fan [C399] (off)
[   27.836403] ACPI: Fan [C39A] (off)
[   27.836529] ACPI: Fan [C39B] (off)
[   27.836658] ACPI: Fan [C39C] (off)
[   27.840819] ACPI: Processor [C000] (supports 8 throttling states)
[   27.840938] ACPI: Processor [C001] (supports 8 throttling states)
[   27.849623] ACPI: Thermal Zone [TZ1] (52 C)
[   27.858144] device-mapper: ioctl: 4.12.0-ioctl (2007-10-02) initialised: dm-devel@redhat.com
[   28.323941] tg3.c:v3.86 (November 9, 2007)
[   28.324049] ACPI: PCI Interrupt 0000:10:00.0[A] -> GSI 16 (level, low) -> IRQ 17
[   28.324166] PCI: Setting latency timer of device 0000:10:00.0 to 64
[   28.329849] SCSI subsystem initialized
[   28.337076] usbcore: registered new interface driver usbfs
[   28.337143] usbcore: registered new interface driver hub
[   28.337521] usbcore: registered new device driver usb
[   28.354467] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[   28.360411] libata version 3.00 loaded.
[   29.155875] eth0: Tigon3 [partno(none) rev b002 PHY(5787)] (PCI Express) 10/100/1000Base-T Ethernet 00:1a:4b:61:68:b6
[   29.156108] eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[1]
[   29.156150] eth0: dma_rwctrl[76180000] dma_mask[64-bit]
[   29.157725] ACPI: PCI Interrupt 0000:00:13.0[A] -> GSI 23 (level, low) -> IRQ 18
[   29.157816] ohci_hcd 0000:00:13.0: OHCI Host Controller
[   29.158048] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 1
[   29.158111] ohci_hcd 0000:00:13.0: irq 18, io mem 0xd0601000
[   29.216892] usb usb1: configuration #1 chosen from 1 choice
[   29.216957] hub 1-0:1.0: USB hub found
[   29.217000] hub 1-0:1.0: 2 ports detected
[   29.320846] ACPI: PCI Interrupt 0000:00:13.1[B] -> GSI 17 (level, low) -> IRQ 19
[   29.320933] ohci_hcd 0000:00:13.1: OHCI Host Controller
[   29.320999] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 2
[   29.321056] ohci_hcd 0000:00:13.1: irq 19, io mem 0xd0602000
[   29.380792] usb usb2: configuration #1 chosen from 1 choice
[   29.380856] hub 2-0:1.0: USB hub found
[   29.380899] hub 2-0:1.0: 2 ports detected
[   29.484747] ACPI: PCI Interrupt 0000:00:13.2[C] -> GSI 17 (level, low) -> IRQ 19
[   29.484831] ohci_hcd 0000:00:13.2: OHCI Host Controller
[   29.484888] ohci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 3
[   29.484941] ohci_hcd 0000:00:13.2: irq 19, io mem 0xd0603000
[   29.544705] usb usb3: configuration #1 chosen from 1 choice
[   29.544771] hub 3-0:1.0: USB hub found
[   29.544813] hub 3-0:1.0: 2 ports detected
[   29.632586] usb 1-2: new full speed USB device using ohci_hcd and address 2
[   29.648666] ACPI: PCI Interrupt 0000:00:13.3[B] -> GSI 17 (level, low) -> IRQ 19
[   29.648750] ohci_hcd 0000:00:13.3: OHCI Host Controller
[   29.648806] ohci_hcd 0000:00:13.3: new USB bus registered, assigned bus number 4
[   29.648864] ohci_hcd 0000:00:13.3: irq 19, io mem 0xd0604000
[   29.708619] usb usb4: configuration #1 chosen from 1 choice
[   29.708679] hub 4-0:1.0: USB hub found
[   29.708721] hub 4-0:1.0: 2 ports detected
[   29.812567] ACPI: PCI Interrupt 0000:00:13.4[C] -> GSI 17 (level, low) -> IRQ 19
[   29.812649] ohci_hcd 0000:00:13.4: OHCI Host Controller
[   29.812706] ohci_hcd 0000:00:13.4: new USB bus registered, assigned bus number 5
[   29.812758] ohci_hcd 0000:00:13.4: irq 19, io mem 0xd0605000
[   29.860533] usb 1-2: configuration #1 chosen from 1 choice
[   29.872534] usb usb5: configuration #1 chosen from 1 choice
[   29.872593] hub 5-0:1.0: USB hub found
[   29.872635] hub 5-0:1.0: 2 ports detected
[   29.975350] ACPI: PCI Interrupt 0000:00:13.5[D] -> GSI 23 (level, low) -> IRQ 18
[   29.975439] ehci_hcd 0000:00:13.5: EHCI Host Controller
[   29.975511] ehci_hcd 0000:00:13.5: new USB bus registered, assigned bus number 6
[   29.975590] ehci_hcd 0000:00:13.5: debug port 1
[   29.975635] ehci_hcd 0000:00:13.5: irq 18, io mem 0xd0606000
[   29.975682] ehci_hcd 0000:00:13.5: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   29.977227] usb 1-2: USB disconnect, address 2
[   29.977149] usb usb6: configuration #1 chosen from 1 choice
[   29.977227] hub 6-0:1.0: USB hub found
[   29.977269] hub 6-0:1.0: 10 ports detected
[   30.079049] SB600_PATA: IDE controller (0x1002:0x438c rev 0x00) at  PCI slot 0000:00:14.1
[   30.079108] ACPI: PCI Interrupt 0000:00:14.1[A] -> GSI 16 (level, low) -> IRQ 17
[   30.079188] SB600_PATA: not 100% native mode: will probe irqs later
[   30.079233]     ide0: BM-DMA at 0x5040-0x5047, BIOS settings: hda:DMA, hdb:pio
[   30.079344] Probing IDE interface ide0...
[   30.811996] usb 1-2: new full speed USB device using ohci_hcd and address 3
[   31.045887] usb 1-2: configuration #1 chosen from 1 choice
[   31.486513] hda: TSSTcorpCD/DVDW TS-L632D, ATAPI CD/DVD-ROM drive
[   31.486673] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[   31.487224] hda: MW DMA 2 mode selected
[   31.487673] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[   31.512925] ACPI: PCI Interrupt 0000:02:04.1[B] -> GSI 21 (level, low) -> IRQ 20
[   31.564831] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[20]  MMIO=[d0101000-d01017ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
[   31.567456] ahci 0000:00:12.0: version 3.0
[   31.567478] ACPI: PCI Interrupt 0000:00:12.0[A] -> GSI 16 (level, low) -> IRQ 17
[   31.567567] ahci 0000:00:12.0: controller can't do 64bit DMA, forcing 32bit
[   31.567605] ahci 0000:00:12.0: controller can't do PMP, turning off CAP_PMP
[   31.567644] ahci 0000:00:12.0: nr_ports (4) and implemented port map (0x1) don't match, using nr_ports
[   31.567687] ahci 0000:00:12.0: forcing PORTS_IMPL to 0xf
[   32.569674] ahci 0000:00:12.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
[   32.569723] ahci 0000:00:12.0: flags: ncq sntf ilck pm led clo pio slum part 
[   32.570113] scsi0 : ahci
[   32.570385] scsi1 : ahci
[   32.570543] scsi2 : ahci
[   32.571494] scsi3 : ahci
[   32.571587] ata1: SATA max UDMA/133 abar m1024@0xd0609000 port 0xd0609100 irq 17
[   32.571630] ata2: SATA max UDMA/133 abar m1024@0xd0609000 port 0xd0609180 irq 17
[   32.571674] ata3: SATA max UDMA/133 abar m1024@0xd0609000 port 0xd0609200 irq 17
[   32.571718] ata4: SATA max UDMA/133 abar m1024@0xd0609000 port 0xd0609280 irq 17
[   32.839104] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00023f9929fd360e]
[   33.046897] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   33.045929] ata1.00: ATA-7: TOSHIBA MK1637GSX, DL032C, max UDMA/100
[   33.045972] ata1.00: 312581808 sectors, multi 16: LBA48 
[   33.048041] ata1.00: configured for UDMA/100
[   33.358740] ata2: SATA link down (SStatus 0 SControl 0)
[   33.670585] ata3: SATA link down (SStatus 0 SControl 0)
[   33.982430] ata4: SATA link down (SStatus 0 SControl 0)
[   33.981071] scsi 0:0:0:0: Direct-Access     ATA      TOSHIBA MK1637GS DL03 PQ: 0 ANSI: 5
[   33.998480] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
[   33.998533] sd 0:0:0:0: [sda] Write Protect is off
[   33.998571] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   33.998584] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   33.998671] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
[   33.998719] sd 0:0:0:0: [sda] Write Protect is off
[   33.998756] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   33.998768] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   33.998811]  sda:<6>hda: ATAPI 24X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache, DMA
[   34.005351] Uniform CD-ROM driver Revision: 3.20
[   34.063398]  sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 >
[   34.106759] sd 0:0:0:0: [sda] Attached SCSI disk
[   34.108912] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   34.676046] Attempting manual resume
[   34.688164] SGI XFS with ACLs, security attributes, realtime, no debug enabled
[   34.688984] SGI XFS Quota Management subsystem
[   34.775235] XFS mounting filesystem sda7
[   34.975307] Ending clean XFS mount for filesystem: sda7
[   43.376260] Linux agpgart interface v0.102
[   43.636018] ACPI: Battery Slot [C1ED] (battery present)
[   43.636282] ACPI: Battery Slot [C1EC] (battery absent)
[   43.644645] ACPI: AC Adapter [C1EB] (on-line)
[   43.694218] input: Power Button (FF) as /class/input/input1
[   43.745578] ACPI: Power Button (FF) [PWRF]
[   43.745714] input: Sleep Button (CM) as /class/input/input2
[   43.809545] ACPI: Sleep Button (CM) [C28D]
[   43.809642] input: Lid Switch as /class/input/input3
[   43.841635] ACPI: Lid Switch [C265]
[   43.881231] input: Video Bus as /class/input/input4
[   43.937596] ACPI: Video Device [C08D] (multi-head: yes  rom: no  post: no)
[   44.487274] ACPI: PCI Interrupt 0000:30:00.0[A] -> GSI 18 (level, low) -> IRQ 21
[   44.487359] PCI: Setting latency timer of device 0000:30:00.0 to 64
[   44.526926] ssb: SPROM revision 3 detected.
[   44.545198] ssb: Sonics Silicon Backplane found on PCI device 0000:30:00.0
[   44.545270] piix4_smbus 0000:00:14.0: Found 0000:00:14.0 device
[   44.557282] input: PC Speaker as /class/input/input5
[   44.697815] Yenta: CardBus bridge found at 0000:02:04.0 [103c:30c2]
[   44.734686] Bluetooth: Core ver 2.11
[   44.735231] NET: Registered protocol family 31
[   44.735269] Bluetooth: HCI device and connection manager initialized
[   44.735309] Bluetooth: HCI socket layer initialized
[   44.756837] hci_usb: Unknown symbol hci_suspend_dev
[   44.756906] hci_usb: Unknown symbol hci_free_dev
[   44.757243] hci_usb: Unknown symbol hci_resume_dev
[   44.757341] hci_usb: Unknown symbol hci_alloc_dev
[   44.757487] hci_usb: Unknown symbol hci_unregister_dev
[   44.757591] hci_usb: Unknown symbol hci_recv_fragment
[   44.757685] hci_usb: Unknown symbol hci_register_dev
[   44.791380] Bluetooth: HCI USB driver ver 2.9
[   44.793355] usbcore: registered new interface driver hci_usb
[   44.825719] Yenta: ISA IRQ mask 0x0cb8, PCI irq 16
[   44.825763] Socket status: 30000006
[   44.825800] Yenta: Raising subordinate bus# of parent bus (#02) from #03 to #06
[   44.825847] pcmcia: parent PCI bridge Memory window: 0xd0100000 - 0xd03fffff
[   44.943956] ACPI: PCI Interrupt 0000:00:14.2[A] -> GSI 16 (level, low) -> IRQ 17
[   45.221096] Synaptics Touchpad, model: 1, fw: 6.2, id: 0x2580b1, caps: 0xa04793/0x300000
[   45.221145] serio: Synaptics pass-through port at isa0060/serio4/input0
[   45.261056] input: SynPS/2 Synaptics TouchPad as /class/input/input6
[   45.864452] si3054: cannot initialize. EXT MID = 0000
[   46.169816] Adding 1959888k swap on /dev/sda6.  Priority:-1 extents:1 across:1959888k
[   47.034313] kjournald starting.  Commit interval 5 seconds
[   47.036031] EXT3 FS on sda5, internal journal
[   47.036037] EXT3-fs: mounted filesystem with ordered data mode.
[   47.482189] Filesystem "dm-0": Disabling barriers, not supported by the underlying device
[   47.491975] XFS mounting filesystem dm-0
[   47.565937] Ending clean XFS mount for filesystem: dm-0
[   47.605595] Filesystem "dm-4": Disabling barriers, not supported by the underlying device
[   47.614285] XFS mounting filesystem dm-4
[   47.672307] Ending clean XFS mount for filesystem: dm-4
[   47.719837] Filesystem "dm-3": Disabling barriers, not supported by the underlying device
[   47.720018] XFS mounting filesystem dm-3
[   47.951644] Ending clean XFS mount for filesystem: dm-3
[   47.991811] Filesystem "dm-1": Disabling barriers, not supported by the underlying device
[   48.006627] XFS mounting filesystem dm-1
[   48.117096] Ending clean XFS mount for filesystem: dm-1
[   49.724522] No dock devices found.
[   49.858478] powernow-k8: Found 1 AMD Turion(tm) 64 X2 Mobile Technology TL-60 processors (2 cpu cores) (version 2.20.00)
[   49.860042] powernow-k8:    0 : fid 0xc (2000 MHz), vid 0x13
[   49.860047] powernow-k8:    1 : fid 0xa (1800 MHz), vid 0x14
[   49.860049] powernow-k8:    2 : fid 0x8 (1600 MHz), vid 0x15
[   49.860051] powernow-k8:    3 : fid 0x0 (800 MHz), vid 0x1e
[   49.860094] powernow-k8: ph2 null fid transition 0xc
[   51.003081] NET: Registered protocol family 10
[   51.003293] lo: Disabled Privacy Extensions
[   51.083479] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   58.303943] Clocksource tsc unstable (delta = -100023885 ns)
[   60.646152] hda-intel: Invalid position buffer, using LPIB read method instead.
[   65.756020] b43-phy0: Broadcom 4311 WLAN found
[   65.772223] b43-phy0 debug: Found PHY: Analog 4, Type 2, Revision 9
[   65.772235] b43-phy0 debug: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
[   65.781839] b43-phy0 debug: DebugFS (CONFIG_DEBUG_FS) not enabled in kernel config
[   65.782751] phy0: Selected rate control algorithm 'simple'
[   65.898377] b43-phy0 debug: Loading firmware version 351.126 (2006-07-29 05:54:02)
[   66.359374] b43-phy0 debug: Chip initialized
[   66.359467] b43-phy0 debug: 64-bit DMA initialized
[   66.367521] b43-phy0 ERROR: PHY transmission error
[   66.367557] b43-phy0 ERROR: Fatal DMA error: 0x00000400, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000
[   66.367597] b43-phy0: Controller RESET (DMA error) ...
[   66.367602] b43-phy0 debug: Wireless interface started
[   66.367621] b43-phy0 debug: Wireless interface stopped
[   66.367639] b43-phy0 debug: DMA-64 0x0200 (RX) max used slots: 0/64
[   66.367664] b43-phy0 debug: DMA-64 0x0240 (TX) max used slots: 0/128
[   66.412570] b43-phy0 debug: Loading firmware version 351.126 (2006-07-29 05:54:02)
[   67.508775] b43-phy0 debug: Chip initialized
[   67.508869] b43-phy0 debug: 64-bit DMA initialized
[   67.529149] b43-phy0 debug: Wireless interface started
[   67.529154] b43-phy0: Controller restarted
[   67.529157] b43-phy0 debug: Adding Interface type 2
[   67.530653] b43-phy0 ERROR: Fatal DMA error: 0x00000400, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000
[   67.530735] b43-phy0: Controller RESET (DMA error) ...
[   67.530722] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   67.576525] b43-phy0 debug: Wireless interface stopped
[   67.576569] b43-phy0 debug: DMA-64 0x0200 (RX) max used slots: 0/64
[   67.576606] b43-phy0 debug: DMA-64 0x0240 (TX) max used slots: 0/128
[   67.689561] b43-phy0 debug: Loading firmware version 351.126 (2006-07-29 05:54:02)
[   68.808150] b43-phy0 debug: Chip initialized
[   68.808256] b43-phy0 debug: 64-bit DMA initialized
[   68.828515] b43-phy0 debug: Wireless interface started
[   68.828519] b43-phy0: Controller restarted
[   68.829900] b43-phy0 ERROR: Fatal DMA error: 0x00000400, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000
[   68.829981] b43-phy0: Controller RESET (DMA error) ...
[   68.875876] b43-phy0 debug: Wireless interface stopped
[   68.875901] b43-phy0 debug: DMA-64 0x0200 (RX) max used slots: 0/64
[   68.875925] b43-phy0 debug: DMA-64 0x0240 (TX) max used slots: 0/128
[   68.988878] b43-phy0 debug: Loading firmware version 351.126 (2006-07-29 05:54:02)
[   70.107490] b43-phy0 debug: Chip initialized
[   70.107582] b43-phy0 debug: 64-bit DMA initialized
[   70.127862] b43-phy0 debug: Wireless interface started
[   70.127866] b43-phy0: Controller restarted
[   70.187227] b43-phy0 debug: Wireless interface stopped
[   70.187250] b43-phy0 debug: DMA-64 0x0200 (RX) max used slots: 0/64
[   70.187276] b43-phy0 debug: DMA-64 0x0240 (TX) max used slots: 0/128
[   70.300230] b43-phy0 debug: Loading firmware version 351.126 (2006-07-29 05:54:02)
[   71.444084] b43-phy0 debug: Chip initialized
[   71.444408] b43-phy0 debug: 64-bit DMA initialized
[   71.465992] printk: 2 messages suppressed.
[   71.465997] b43-phy0 ERROR: Fatal DMA error: 0x00000400, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000
[   71.466083] b43-phy0 debug: Wireless interface started
[   71.466754] b43-phy0 debug: Wireless interface stopped
[   71.466984] b43-phy0 debug: DMA-64 0x0200 (RX) max used slots: 0/64
[   71.467226] b43-phy0 debug: DMA-64 0x0240 (TX) max used slots: 2/128
[   71.576882] b43-phy0 debug: Loading firmware version 351.126 (2006-07-29 05:54:02)
[   72.699479] b43-phy0 debug: Chip initialized
[   72.699719] b43-phy0 debug: 64-bit DMA initialized
[   72.721354] b43-phy0 debug: Wireless interface started
[   72.731286] b43-phy0 debug: Wireless interface stopped
[   72.731469] b43-phy0 debug: DMA-64 0x0200 (RX) max used slots: 0/64
[   72.731677] b43-phy0 debug: DMA-64 0x0240 (TX) max used slots: 0/128
[   72.844255] b43-phy0 debug: Loading firmware version 351.126 (2006-07-29 05:54:02)
[   73.950862] b43-phy0 debug: Chip initialized
[   73.951100] b43-phy0 debug: 64-bit DMA initialized
[   73.972470] b43-phy0 debug: Wireless interface started
[   73.972685] b43-phy0 debug: Wireless interface stopped
[   73.972861] b43-phy0 debug: DMA-64 0x0200 (RX) max used slots: 0/64
[   73.973069] b43-phy0 debug: DMA-64 0x0240 (TX) max used slots: 2/128
[   74.083641] b43-phy0 debug: Loading firmware version 351.126 (2006-07-29 05:54:02)
[   75.206225] b43-phy0 debug: Chip initialized
[   75.206501] b43-phy0 debug: 64-bit DMA initialized
[   75.227920] b43-phy0 debug: Wireless interface started
[   75.238044] b43-phy0 debug: Wireless interface stopped
[   75.238229] b43-phy0 debug: DMA-64 0x0200 (RX) max used slots: 0/64
[   75.238438] b43-phy0 debug: DMA-64 0x0240 (TX) max used slots: 0/128
[   75.351013] b43-phy0 debug: Loading firmware version 351.126 (2006-07-29 05:54:02)
[   76.473611] b43-phy0 debug: Chip initialized
[   76.473853] b43-phy0 debug: 64-bit DMA initialized
[   76.495226] printk: 11 messages suppressed.
[   76.495230] b43-phy0 ERROR: Fatal DMA error: 0x00000400, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000
[   76.495317] b43-phy0 debug: Wireless interface started
[   76.495890] b43-phy0 debug: Wireless interface stopped
[   76.496067] b43-phy0 debug: DMA-64 0x0200 (RX) max used slots: 0/64
[   76.496274] b43-phy0 debug: DMA-64 0x0240 (TX) max used slots: 2/128
[   76.606393] b43-phy0 debug: Loading firmware version 351.126 (2006-07-29 05:54:02)
[   77.724992] b43-phy0 debug: Chip initialized
[   77.725230] b43-phy0 debug: 64-bit DMA initialized
[   77.745393] b43-phy0 debug: Wireless interface started
[   77.812708] b43-phy0 debug: Wireless interface stopped
[   77.812882] b43-phy0 debug: DMA-64 0x0200 (RX) max used slots: 0/64
[   77.813082] b43-phy0 debug: DMA-64 0x0240 (TX) max used slots: 0/128
[   77.925728] b43-phy0 debug: Loading firmware version 351.126 (2006-07-29 05:54:02)
[   79.052335] b43-phy0 debug: Chip initialized
[   79.052549] b43-phy0 debug: 64-bit DMA initialized
[   79.072691] b43-phy0 debug: Wireless interface started
[   79.120059] b43-phy0 debug: Wireless interface stopped
[   79.120225] b43-phy0 debug: DMA-64 0x0200 (RX) max used slots: 0/64
[   79.120420] b43-phy0 debug: DMA-64 0x0240 (TX) max used slots: 2/128
[   79.233092] b43-phy0 debug: Loading firmware version 351.126 (2006-07-29 05:54:02)
[   80.353635] b43-phy0 debug: Chip initialized
[   80.353758] b43-phy0 debug: 64-bit DMA initialized
[   80.375580] b43-phy0 debug: Wireless interface started
[   80.441369] b43-phy0 debug: Wireless interface stopped
[   80.441405] b43-phy0 debug: DMA-64 0x0200 (RX) max used slots: 0/64
[   80.441446] b43-phy0 debug: DMA-64 0x0240 (TX) max used slots: 0/128
[   80.554412] b43-phy0 debug: Loading firmware version 351.126 (2006-07-29 05:54:02)
[   81.665001] b43-phy0 debug: Chip initialized
[   81.665117] b43-phy0 debug: 64-bit DMA initialized
[   81.686879] b43-phy0 debug: Wireless interface started
[   81.686889] printk: 11 messages suppressed.
[   81.686890] b43-phy0: Controller restarted
[   81.732732] b43-phy0 debug: Wireless interface stopped
[   81.732769] b43-phy0 debug: DMA-64 0x0200 (RX) max used slots: 0/64
[   81.732807] b43-phy0 debug: DMA-64 0x0240 (TX) max used slots: 2/128
[   81.845741] b43-phy0 debug: Loading firmware version 351.126 (2006-07-29 05:54:02)
[   82.960342] b43-phy0 debug: Chip initialized
[   82.960459] b43-phy0 debug: 64-bit DMA initialized
[   82.982244] b43-phy0 debug: Wireless interface started
[   83.028088] b43-phy0 debug: Wireless interface stopped
[   83.028124] b43-phy0 debug: DMA-64 0x0200 (RX) max used slots: 0/64
[   83.028163] b43-phy0 debug: DMA-64 0x0240 (TX) max used slots: 0/128
[   83.141133] b43-phy0 debug: Loading firmware version 351.126 (2006-07-29 05:54:02)
[   84.263697] b43-phy0 debug: Chip initialized
[   84.263813] b43-phy0 debug: 64-bit DMA initialized
[   84.285594] b43-phy0 debug: Wireless interface started
[   84.331442] b43-phy0 debug: Wireless interface stopped
[   84.331477] b43-phy0 debug: DMA-64 0x0200 (RX) max used slots: 0/64
[   84.331513] b43-phy0 debug: DMA-64 0x0240 (TX) max used slots: 2/128
[   84.444486] b43-phy0 debug: Loading firmware version 351.126 (2006-07-29 05:54:02)
[   85.571070] b43-phy0 debug: Chip initialized
[   85.571186] b43-phy0 debug: 64-bit DMA initialized
[   85.592944] b43-phy0 debug: Wireless interface started
[   85.650789] b43-phy0 debug: Wireless interface stopped
[   85.650823] b43-phy0 debug: DMA-64 0x0200 (RX) max used slots: 0/64
[   85.650861] b43-phy0 debug: DMA-64 0x0240 (TX) max used slots: 0/128
[   85.763834] b43-phy0 debug: Loading firmware version 351.126 (2006-07-29 05:54:02)
[   86.894395] b43-phy0 debug: Chip initialized
[   86.894511] b43-phy0 debug: 64-bit DMA initialized
[   86.916299] b43-phy0 debug: Wireless interface started
[   86.916308] printk: 11 messages suppressed.
[   86.916310] b43-phy0: Controller restarted
[   86.962140] b43-phy0 debug: Wireless interface stopped
[   86.962174] b43-phy0 debug: DMA-64 0x0200 (RX) max used slots: 0/64
[   86.962211] b43-phy0 debug: DMA-64 0x0240 (TX) max used slots: 2/128
[   87.075186] b43-phy0 debug: Loading firmware version 351.126 (2006-07-29 05:54:02)
[   88.193769] b43-phy0 debug: Chip initialized
[   88.193884] b43-phy0 debug: 64-bit DMA initialized
[   88.215643] b43-phy0 debug: Wireless interface started
[   88.273491] b43-phy0 debug: Wireless interface stopped
[   88.273525] b43-phy0 debug: DMA-64 0x0200 (RX) max used slots: 0/64
[   88.273563] b43-phy0 debug: DMA-64 0x0240 (TX) max used slots: 0/128
[   88.386536] b43-phy0 debug: Loading firmware version 351.126 (2006-07-29 05:54:02)
[   89.509101] b43-phy0 debug: Chip initialized
[   89.509219] b43-phy0 debug: 64-bit DMA initialized
[   89.530982] b43-phy0 debug: Wireless interface started
[   89.576845] b43-phy0 debug: Wireless interface stopped
[   89.576878] b43-phy0 debug: DMA-64 0x0200 (RX) max used slots: 0/64
[   89.576915] b43-phy0 debug: DMA-64 0x0240 (TX) max used slots: 2/128
[   89.689891] b43-phy0 debug: Loading firmware version 351.126 (2006-07-29 05:54:02)
[   90.804459] b43-phy0 debug: Chip initialized
[   90.804573] b43-phy0 debug: 64-bit DMA initialized
[   90.826538] b43-phy0 debug: Wireless interface started
[   90.884198] b43-phy0 debug: Wireless interface stopped
[   90.884233] b43-phy0 debug: DMA-64 0x0200 (RX) max used slots: 0/64
[   90.884270] b43-phy0 debug: DMA-64 0x0240 (TX) max used slots: 0/128
[   90.997245] b43-phy0 debug: Loading firmware version 351.126 (2006-07-29 05:54:02)

--------------010906060500040901040407--
