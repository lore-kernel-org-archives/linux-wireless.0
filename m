Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:53340 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522Ab2DRTdv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 15:33:51 -0400
Received: by wgbdr13 with SMTP id dr13so7854208wgb.1
        for <linux-wireless@vger.kernel.org>; Wed, 18 Apr 2012 12:33:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5714877C-2465-4FD5-94A0-9D0806A803C4@gmail.com>
References: <2F08FF0B-5C29-4827-AA5F-B0F3847D0B83@gmail.com>
	<4F8DC25E.9090702@broadcom.com>
	<B9AA983D-A169-497D-9C8E-BDBEF2348BB6@gmail.com>
	<4F8E0CBE.6010103@sipsolutions.net>
	<0FC1AE2B-7E32-466B-AC33-F969F4E72B98@gmail.com>
	<CANUX_P38YDFtL-KzKnFHd0+Ca29SUXoY+mGKaDUjConXaf3c9A@mail.gmail.com>
	<4B048FDE-C784-4401-9FEC-16F8CC0B8D59@gmail.com>
	<CANUX_P0FO-P6ZFow15shNpZg6Z8FAPP7AovJH=xUKPyVEMtoBw@mail.gmail.com>
	<FC927BD3-30FD-4DF2-A65C-5BE785FB72BC@gmail.com>
	<CANUX_P0dR93vJicsrnpxPmOZvaxBvaONHQiFXOTcaP1Ax0LAnQ@mail.gmail.com>
	<816C5F70-E340-46F9-8206-2B230A27F3AD@gmail.com>
	<CANUX_P3=ttVKdLYBfAdGRhmfDRbPruogw8Eo_d09on0ajdTqUw@mail.gmail.com>
	<5714877C-2465-4FD5-94A0-9D0806A803C4@gmail.com>
Date: Wed, 18 Apr 2012 22:33:49 +0300
Message-ID: <CANUX_P27GoLY2q9jmsWw9Rzn9posf3mCjDa98+q4JP=83wYthg@mail.gmail.com> (sfid-20120418_213355_701273_FFDFF50B)
Subject: Re: wlan0 not present
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Dominik Feser <dominik.feser@googlemail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 18, 2012 at 22:28, Dominik Feser
<dominik.feser@googlemail.com> wrote:
> Thumb question but how do I compile the driver with debug support? I think its missing...
> In which file do I have to enable the debug stuff?
>
> # modprobe iwlwifi debug=0xffffffff
> FATAL: Error inserting iwlwifi (/lib/modules/2.6.32.12-0.7.1/updates/drivers/net/wireless/iwlwifi/iwlwifi.ko): Unknown symbol in module, or unknown parameter (see dmesg)
>
>

You need to enable CONFIG_IWLWIFI_DEBUG in your .config file.

>
> Am 18.04.2012 um 21:25 schrieb Emmanuel Grumbach:
>
>> On Wed, Apr 18, 2012 at 19:56, Dominik Feser
>> <dominik.feser@googlemail.com> wrote:
>>> OK, that was the firmware I had tried before. I deleted it because it did not work, too.
>>>
>>> Here is the output you wanted:
>>> # ls /lib/firmware/iwlwifi-6000*
>>> /lib/firmware/iwlwifi-6000g2a-5.ucode
>>>
>>> After copying the firmware there again and rebooting dmesg looks like this:
>>> # dmesg | grep iwl
>>> iwlwifi 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
>>> iwlwifi 0000:02:00.0: setting latency timer to 64
>>> iwlwifi 0000:02:00.0: pci_resource_len = 0x00002000
>>> iwlwifi 0000:02:00.0: pci_resource_base = f2478000
>>> iwlwifi 0000:02:00.0: HW Revision ID = 0x34
>>> iwlwifi 0000:02:00.0: irq 1277 (277) for MSI/MSI-X
>>> iwlwifi 0000:02:00.0: ea4b7e1c
>>>
>>> Still no wlan0 for me...
>>>
>>> Full dmesg:
>>> # dmesg
>>> Reserving virtual address space above 0xff400000
>>> Linux version 2.6.32.12-0.7.1 (geeko@buildhost) (gcc version 4.1.2 20080704 (Red Hat 4.1.2-48)) #6 SMP Mon Apr 16 19:31:06 EDT 2012
>>> KERNEL supported cpus:
>>>  Intel GenuineIntel
>>>  AMD AuthenticAMD
>>>  NSC Geode by NSC
>>>  Cyrix CyrixInstead
>>>  Centaur CentaurHauls
>>>  Transmeta GenuineTMx86
>>>  Transmeta TransmetaCPU
>>> Xen-provided machine memory map:
>>>  BIOS: 0000000000000000 - 000000000009a800 (usable)
>>>  BIOS: 000000000009a800 - 00000000000a0000 (reserved)
>>>  BIOS: 00000000000e0000 - 0000000000100000 (reserved)
>>>  BIOS: 0000000000100000 - 0000000020000000 (usable)
>>>  BIOS: 0000000020000000 - 0000000020200000 (reserved)
>>>  BIOS: 0000000020200000 - 0000000040000000 (usable)
>>>  BIOS: 0000000040000000 - 0000000040200000 (reserved)
>>>  BIOS: 0000000040200000 - 00000000caa25000 (usable)
>>>  BIOS: 00000000caa25000 - 00000000caa69000 (reserved)
>>>  BIOS: 00000000caa69000 - 00000000cadb7000 (usable)
>>>  BIOS: 00000000cadb7000 - 00000000cade7000 (reserved)
>>>  BIOS: 00000000cade7000 - 00000000cafe7000 (ACPI NVS)
>>>  BIOS: 00000000cafe7000 - 00000000cafff000 (ACPI data)
>>>  BIOS: 00000000cafff000 - 00000000cb000000 (usable)
>>>  BIOS: 00000000cb800000 - 00000000cfa00000 (reserved)
>>>  BIOS: 00000000fec00000 - 00000000fec01000 (reserved)
>>>  BIOS: 00000000fed1c000 - 00000000fed20000 (reserved)
>>>  BIOS: 00000000fee00000 - 00000000fee01000 (reserved)
>>>  BIOS: 00000000ffc00000 - 00000000ffc20000 (reserved)
>>>  BIOS: 0000000100000000 - 000000022e000000 (usable)
>>> Xen-provided physical RAM map:
>>>  Xen: 0000000000000000 - 000000002f800000 (usable)
>>> DMI 2.6 present.
>>> last_pfn = 0x2f800 max_arch_pfn = 0x10000000
>>> initial memory mapped : 0 - 00000000
>>> init_memory_mapping: 0000000000000000-000000002f800000
>>> NX (Execute Disable) protection: active
>>>  0000000000 - 002f800000 page 4k
>>> kernel direct mapping tables up to 2f800000 @ e4e000-fcf000
>>> RAMDISK: 005f9000 - 00d80e00
>>> ACPI: RSDP 000fe300 00024 (v02 DELL  )
>>> ACPI: XSDT caffde18 0007C (v01 DELL    CBX3    06222004 MSFT 00010013)
>>> ACPI: FACP caf87d98 000F4 (v04 DELL    CBX3    06222004 MSFT 00010013)
>>> ACPI Warning: 32/64 FACS address mismatch in FADT - two FACS tables! (20090903/tbfadt-369)
>>> ACPI Warning: 32/64X FACS address mismatch in FADT - CAFE4E40/00000000CAFE4D40, using 32 (20090903/tbfadt-486)
>>> ACPI: DSDT caf55018 087F6 (v02 INT430 SYSFexxx 00001001 INTL 20090903)
>>> ACPI: FACS cafe4e40 00040
>>> ACPI: APIC caffcf18 000CC (v02 DELL    CBX3    06222004 MSFT 00010013)
>>> ACPI: TCPA cafe5d18 00032 (v02                 00000000      00000000)
>>> ACPI: SSDT caf88a98 002F9 (v01 DELLTP      TPM 00003000 INTL 20090903)
>>> ACPI: MCFG cafe5c98 0003C (v01 DELL   SNDYBRDG 06222004 MSFT 00000097)
>>> ACPI: HPET cafe5c18 00038 (v01 A M I   PCHHPET 06222004 AMI. 00000003)
>>> ACPI: BOOT cafe5b98 00028 (v01 DELL   CBX3     06222004 AMI  00010013)
>>> ACPI: SSDT caf6c018 00888 (v01  PmRef  Cpu0Ist 00003000 INTL 20090903)
>>> ACPI: SSDT caf6b018 00996 (v01  PmRef    CpuPm 00003000 INTL 20090903)
>>> ACPI: XMAR caf87c18 000E8 (v01 INTEL      SNB  00000001 INTL 00000001)
>>> ACPI: SLIC caf75c18 00176 (v03 DELL    CBX3    06222004 MSFT 00010013)
>>> 0MB HIGHMEM available.
>>> 760MB LOWMEM available.
>>>  mapped low ram: 0 - 2f800000
>>>  low ram: 0 - 2f800000
>>>  node 0 low ram: 00000000 - 2f000000
>>>  node 0 bootmap 00000000 - 00005e00
>>> (5 early reservations) ==> bootmem [0000000000 - 002f000000]
>>>  #0 [0000100000 - 00005d8284]    TEXT DATA BSS ==> [0000100000 - 00005d8284]
>>>  #1 [00005f9000 - 0000e4e000]     Xen provided ==> [00005f9000 - 0000e4e000]
>>>  #2 [00005d9000 - 00005d91b3]              BRK ==> [00005d9000 - 00005d91b3]
>>>  #3 [0000e4e000 - 0000fc4000]          PGTABLE ==> [0000e4e000 - 0000fc4000]
>>>  #4 [0000000000 - 0000006000]          BOOTMAP ==> [0000000000 - 0000006000]
>>> found SMP MP-table at [ff3eca70] 000f1a70
>>> Zone PFN ranges:
>>>  DMA      0x00000000 -> 0x00001000
>>>  Normal   0x00001000 -> 0x0002f800
>>>  HighMem  0x0002f800 -> 0x0002f800
>>> Movable zone start PFN for each node
>>> early_node_map[2] active PFN ranges
>>>    0: 0x00000000 -> 0x0002f000
>>>    0: 0x0002f800 -> 0x0002f800
>>> On node 0 totalpages: 192512
>>> free_area_init_node: node 0, pgdat c04ef300, node_mem_map c1002000
>>>  DMA zone: 32 pages used for memmap
>>>  DMA zone: 0 pages reserved
>>>  DMA zone: 4064 pages, LIFO batch:0
>>>  Normal zone: 1488 pages used for memmap
>>>  Normal zone: 186928 pages, LIFO batch:31
>>> ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
>>> ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
>>> ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
>>> ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
>>> ACPI: LAPIC (acpi_id[0x05] lapic_id[0x04] disabled)
>>> ACPI: LAPIC (acpi_id[0x06] lapic_id[0x05] disabled)
>>> ACPI: LAPIC (acpi_id[0x07] lapic_id[0x06] disabled)
>>> ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] disabled)
>>> ACPI: LAPIC (acpi_id[0x09] lapic_id[0x08] disabled)
>>> ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x09] disabled)
>>> ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x0a] disabled)
>>> ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x0b] disabled)
>>> ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x0c] disabled)
>>> ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x0d] disabled)
>>> ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x0e] disabled)
>>> ACPI: LAPIC (acpi_id[0x10] lapic_id[0x0f] disabled)
>>> ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
>>> IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
>>> ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
>>> ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
>>> ACPI: IRQ0 used by override.
>>> ACPI: IRQ2 used by override.
>>> ACPI: IRQ9 used by override.
>>> Using ACPI (MADT) for SMP configuration information
>>> Allocating PCI resources starting at cfa00000 (gap: cfa00000:2f200000)
>>> NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:4 nr_node_ids:1
>>> PERCPU: Embedded 9 pages/cpu @c16b9000 s13720 r0 d23144 u65536
>>> pcpu-alloc: s13720 r0 d23144 u65536 alloc=16*4096
>>> pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3
>>> Swapping MFNs for PFN 544 and 16bb (MFN c9544 and c9f33)
>>> Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 190992
>>> Kernel command line: root=LABEL=root-hwkkxaxy ro xencons=hvc console=hvc0 console=tty0 quiet vga=785 splash
>>> PID hash table entries: 4096 (order: 2, 16384 bytes)
>>> Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
>>> Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
>>> Enabling fast FPU save and restore... done.
>>> Enabling unmasked SIMD FPU exception support... done.
>>> Initializing CPU#0
>>> Software IO TLB enabled:
>>>  Aperture:     64 megabytes
>>>  Address size: 28 bits
>>>  Kernel range: c17b2000 - c57b2000
>>> PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
>>> Initializing HighMem for node 0 (00000000:00000000)
>>> Memory: 681820k/778240k available (2591k kernel code, 88012k reserved, 1466k data, 316k init, 0k highmem)
>>> virtual kernel memory layout:
>>>    fixmap  : 0xff077000 - 0xff3ff000   (3616 kB)
>>>    pkmap   : 0xfec00000 - 0xfee00000   (2048 kB)
>>>    vmalloc : 0xf0000000 - 0xfebfe000   ( 235 MB)
>>>    lowmem  : 0xc0000000 - 0xef800000   ( 760 MB)
>>>      .init : 0xc04f7000 - 0xc0546000   ( 316 kB)
>>>      .data : 0xc0387d67 - 0xc04f66f8   (1466 kB)
>>>      .text : 0xc0100000 - 0xc0387d67   (2591 kB)
>>> Checking if this processor honours the WP bit even in supervisor mode...Ok.
>>> Hierarchical RCU implementation.
>>> NR_IRQS:2048
>>> Extended CMOS year: 2000
>>> Xen reported: 2793.780 MHz processor.
>>> Console: colour dummy device 80x25
>>> console [tty0] enabled
>>> console [hvc0] enabled
>>> Calibrating delay using timer specific routine.. 5616.72 BogoMIPS (lpj=28083614)
>>> pid_max: default: 32768 minimum: 301
>>> Security Framework initialized
>>> Mount-cache hash table entries: 512
>>> mce: CPU supports 7 MCE banks
>>> Checking 'hlt' instruction... OK.
>>> SMP alternatives: switching to UP code
>>> ACPI: Core revision 20090903
>>> SMP alternatives: switching to SMP code
>>> Initializing CPU#1
>>> Initializing CPU#2
>>> Brought up 4 CPUs
>>> Initializing CPU#3
>>> Grant table version 2
>>> NET: Registered protocol family 16
>>> ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
>>> ACPI: bus type pci registered
>>> PCI: MCFG configuration 0: base f8000000 segment 0 buses 0 - 63
>>> PCI: Not using MMCONFIG.
>>> PCI: Using configuration type 1 for base access
>>> bio: create slab <bio-0> at 0
>>> ACPI: EC: Look up EC in DSDT
>>> ACPI: BIOS _OSI(Linux) query ignored
>>> ACPI: BIOS _OSI(Linux) query ignored
>>> ACPI: Interpreter enabled
>>> ACPI: (supports S0 S5)
>>> ACPI: Using IOAPIC for interrupt routing
>>> PCI: MCFG configuration 0: base f8000000 segment 0 buses 0 - 63
>>> PCI: MCFG area at f8000000 reserved in ACPI motherboard resources
>>> PCI: Using MMCONFIG for extended config space
>>> ACPI: EC: GPE = 0x10, I/O: command/status = 0x934, data = 0x930
>>> ACPI: No dock devices found.
>>> PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
>>> _OSC invalid UUID
>>> ACPI: PCI Root Bridge [PCI0] (0000:00)
>>> pci 0000:00:02.0: reg 10 64bit mmio: [0xe1400000-0xe17fffff]
>>> pci 0000:00:02.0: reg 18 64bit mmio pref: [0xd0000000-0xdfffffff]
>>> pci 0000:00:02.0: reg 20 io port: [0x4000-0x403f]
>>> pci 0000:00:16.0: reg 10 64bit mmio: [0xe2eb0000-0xe2eb000f]
>>> pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
>>> pci 0000:00:16.0: PME# disabled
>>> pci 0000:00:16.3: reg 10 io port: [0x40e0-0x40e7]
>>> pci 0000:00:16.3: reg 14 32bit mmio: [0xe2e90000-0xe2e90fff]
>>> pci 0000:00:19.0: reg 10 32bit mmio: [0xe2e00000-0xe2e1ffff]
>>> pci 0000:00:19.0: reg 14 32bit mmio: [0xe2e80000-0xe2e80fff]
>>> pci 0000:00:19.0: reg 18 io port: [0x4080-0x409f]
>>> pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
>>> pci 0000:00:19.0: PME# disabled
>>> pci 0000:00:1a.0: reg 10 32bit mmio: [0xe2e70000-0xe2e703ff]
>>> pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
>>> pci 0000:00:1a.0: PME# disabled
>>> pci 0000:00:1b.0: reg 10 64bit mmio: [0xe2e60000-0xe2e63fff]
>>> pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
>>> pci 0000:00:1b.0: PME# disabled
>>> pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
>>> pci 0000:00:1c.0: PME# disabled
>>> pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
>>> pci 0000:00:1c.1: PME# disabled
>>> pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
>>> pci 0000:00:1c.2: PME# disabled
>>> pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
>>> pci 0000:00:1c.3: PME# disabled
>>> pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
>>> pci 0000:00:1c.5: PME# disabled
>>> pci 0000:00:1d.0: reg 10 32bit mmio: [0xe2e50000-0xe2e503ff]
>>> pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
>>> pci 0000:00:1d.0: PME# disabled
>>> pci 0000:00:1f.2: reg 10 io port: [0x40d0-0x40d7]
>>> pci 0000:00:1f.2: reg 14 io port: [0x40c0-0x40c3]
>>> pci 0000:00:1f.2: reg 18 io port: [0x40b0-0x40b7]
>>> pci 0000:00:1f.2: reg 1c io port: [0x40a0-0x40a3]
>>> pci 0000:00:1f.2: reg 20 io port: [0x4060-0x407f]
>>> pci 0000:00:1f.2: reg 24 32bit mmio: [0xe2e40000-0xe2e407ff]
>>> pci 0000:00:1f.2: PME# supported from D3hot
>>> pci 0000:00:1f.2: PME# disabled
>>> pci 0000:00:1f.3: reg 10 64bit mmio: [0xe2e30000-0xe2e300ff]
>>> pci 0000:00:1f.3: reg 20 io port: [0x4040-0x405f]
>>> pci 0000:00:1c.0: PCI bridge to [bus 01-01]
>>> pci 0000:02:00.0: reg 10 64bit mmio: [0xe2d00000-0xe2d01fff]
>>> pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
>>> pci 0000:02:00.0: PME# disabled
>>> pci 0000:00:1c.1: PCI bridge to [bus 02-02]
>>> pci 0000:00:1c.1: bridge 32bit mmio: [0xe2d00000-0xe2dfffff]
>>> pci 0000:00:1c.2: PCI bridge to [bus 03-08]
>>> pci 0000:00:1c.2: bridge io port: [0x3000-0x3fff]
>>> pci 0000:00:1c.2: bridge 32bit mmio: [0xe2200000-0xe2bfffff]
>>> pci 0000:00:1c.2: bridge 64bit mmio pref: [0xe0a00000-0xe13fffff]
>>> pci 0000:00:1c.3: PCI bridge to [bus 09-09]
>>> pci 0000:00:1c.3: bridge io port: [0x2000-0x2fff]
>>> pci 0000:00:1c.3: bridge 32bit mmio: [0xe1800000-0xe21fffff]
>>> pci 0000:00:1c.3: bridge 64bit mmio pref: [0xe0000000-0xe09fffff]
>>> pci 0000:0a:00.0: reg 10 32bit mmio: [0xe2c20000-0xe2c201ff]
>>> pci 0000:0a:00.0: supports D1 D2
>>> pci 0000:0a:00.0: PME# supported from D0 D1 D2 D3hot D3cold
>>> pci 0000:0a:00.0: PME# disabled
>>> pci 0000:0a:00.1: reg 10 32bit mmio: [0xe2c10000-0xe2c10fff]
>>> pci 0000:0a:00.1: reg 18 32bit mmio: [0xe2c00000-0xe2c007ff]
>>> pci 0000:0a:00.1: supports D1 D2
>>> pci 0000:0a:00.1: PME# supported from D0 D1 D2 D3hot D3cold
>>> pci 0000:0a:00.1: PME# disabled
>>> pci 0000:00:1c.5: PCI bridge to [bus 0a-0a]
>>> pci 0000:00:1c.5: bridge 32bit mmio: [0xe2c00000-0xe2cfffff]
>>> pci_bus 0000:00: on NUMA node 0
>>> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
>>> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
>>> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
>>> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
>>> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP06._PRT]
>>> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
>>> _OSC invalid UUID
>>> ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
>>> ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
>>> ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
>>> ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
>>> ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 *5 6 7 10 12 14 15)
>>> ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
>>> ACPI: PCI Interrupt Link [LNKG] (IRQs 1 *3 4 5 6 7 10 12 14 15)
>>> ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
>>> xen_mem: Initialising balloon driver.
>>> vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
>>> vgaarb: loaded
>>> PCI: Using ACPI for IRQ routing
>>> Switching to clocksource xen
>>> pnp: PnP ACPI init
>>> ACPI: bus type pnp registered
>>> pnp: PnP ACPI: found 13 devices
>>> ACPI: ACPI bus type pnp unregistered
>>> system 00:03: iomem range 0xfed00000-0xfed003ff has been reserved
>>> system 00:05: ioport range 0x680-0x69f has been reserved
>>> system 00:05: ioport range 0x1000-0x100f has been reserved
>>> system 00:05: ioport range 0xffff-0xffff has been reserved
>>> system 00:05: ioport range 0xffff-0xffff has been reserved
>>> system 00:05: ioport range 0x400-0x47f has been reserved
>>> system 00:05: ioport range 0x500-0x57f has been reserved
>>> system 00:05: ioport range 0x164e-0x164f has been reserved
>>> system 00:0a: iomem range 0xfed1c000-0xfed1ffff has been reserved
>>> system 00:0a: iomem range 0xfed10000-0xfed17fff has been reserved
>>> system 00:0a: iomem range 0xfed18000-0xfed18fff has been reserved
>>> system 00:0a: iomem range 0xfed19000-0xfed19fff has been reserved
>>> system 00:0a: iomem range 0xf8000000-0xfbffffff has been reserved
>>> system 00:0a: iomem range 0xfed20000-0xfed3ffff has been reserved
>>> system 00:0a: iomem range 0xfed90000-0xfed93fff has been reserved
>>> system 00:0a: iomem range 0xfed45000-0xfed8ffff has been reserved
>>> system 00:0a: iomem range 0xff000000-0xffffffff could not be reserved
>>> system 00:0a: iomem range 0xfee00000-0xfeefffff could not be reserved
>>> system 00:0c: iomem range 0x20000000-0x201fffff has been reserved
>>> system 00:0c: iomem range 0x40000000-0x401fffff has been reserved
>>> pci 0000:00:1c.0: PCI bridge, secondary bus 0000:01
>>> pci 0000:00:1c.0:   IO window: disabled
>>> pci 0000:00:1c.0:   MEM window: disabled
>>> pci 0000:00:1c.0:   PREFETCH window: disabled
>>> pci 0000:00:1c.1: PCI bridge, secondary bus 0000:02
>>> pci 0000:00:1c.1:   IO window: disabled
>>> pci 0000:00:1c.1:   MEM window: 0xe2d00000-0xe2dfffff
>>> pci 0000:00:1c.1:   PREFETCH window: disabled
>>> pci 0000:00:1c.2: PCI bridge, secondary bus 0000:03
>>> pci 0000:00:1c.2:   IO window: 0x3000-0x3fff
>>> pci 0000:00:1c.2:   MEM window: 0xe2200000-0xe2bfffff
>>> pci 0000:00:1c.2:   PREFETCH window: 0x000000e0a00000-0x000000e13fffff
>>> pci 0000:00:1c.3: PCI bridge, secondary bus 0000:09
>>> pci 0000:00:1c.3:   IO window: 0x2000-0x2fff
>>> pci 0000:00:1c.3:   MEM window: 0xe1800000-0xe21fffff
>>> pci 0000:00:1c.3:   PREFETCH window: 0x000000e0000000-0x000000e09fffff
>>> pci 0000:00:1c.5: PCI bridge, secondary bus 0000:0a
>>> pci 0000:00:1c.5:   IO window: disabled
>>> pci 0000:00:1c.5:   MEM window: 0xe2c00000-0xe2cfffff
>>> pci 0000:00:1c.5:   PREFETCH window: disabled
>>> pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
>>> pci 0000:00:1c.0: setting latency timer to 64
>>> pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
>>> pci 0000:00:1c.1: setting latency timer to 64
>>> pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
>>> pci 0000:00:1c.2: setting latency timer to 64
>>> pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
>>> pci 0000:00:1c.3: setting latency timer to 64
>>> pci 0000:00:1c.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
>>> pci 0000:00:1c.5: setting latency timer to 64
>>> pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
>>> pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
>>> pci_bus 0000:02: resource 1 mem: [0xe2d00000-0xe2dfffff]
>>> pci_bus 0000:03: resource 0 io:  [0x3000-0x3fff]
>>> pci_bus 0000:03: resource 1 mem: [0xe2200000-0xe2bfffff]
>>> pci_bus 0000:03: resource 2 pref mem [0xe0a00000-0xe13fffff]
>>> pci_bus 0000:09: resource 0 io:  [0x2000-0x2fff]
>>> pci_bus 0000:09: resource 1 mem: [0xe1800000-0xe21fffff]
>>> pci_bus 0000:09: resource 2 pref mem [0xe0000000-0xe09fffff]
>>> pci_bus 0000:0a: resource 1 mem: [0xe2c00000-0xe2cfffff]
>>> NET: Registered protocol family 2
>>> IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
>>> TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
>>> TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
>>> TCP: Hash tables configured (established 131072 bind 65536)
>>> TCP reno registered
>>> NET: Registered protocol family 1
>>> pci 0000:00:02.0: Boot video device
>>> Trying to unpack rootfs image as initramfs...
>>> Freeing initrd memory: 7711k freed
>>> Simple Boot Flag at 0xf3 set to 0x1
>>> MCE: bind virq for DOM0 logging
>>> MCE_DOM0_LOG: enter dom0 mce vIRQ handler
>>> MCE_DOM0_LOG: No more urgent data
>>> MCE_DOM0_LOG: No more nonurgent data
>>> VFS: Disk quotas dquot_6.5.2
>>> Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
>>> msgmni has been set to 379
>>> alg: No test for stdrng (krng)
>>> Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
>>> io scheduler noop registered
>>> io scheduler anticipatory registered
>>> io scheduler deadline registered
>>> io scheduler cfq registered (default)
>>> vesafb: framebuffer at 0xd0000000, mapped to 0xf0080000, using 1200k, total 65472k
>>> vesafb: mode is 640x480x16, linelength=1280, pages=0
>>> vesafb: scrolling: redraw
>>> vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
>>> fb0: VESA VGA frame buffer device
>>> floppy0: Unable to grab DMA2 for the floppy driver
>>> floppy0: no floppy controllers found
>>> brd: module loaded
>>> loop: module loaded
>>> Xen virtual console successfully installed as hvc0
>>> Event-channel device installed.
>>> blktap_device_init: blktap device major 253
>>> blktap_ring_init: blktap ring major: 253
>>> netfront: Initialising virtual ethernet driver.
>>> Uniform Multi-Platform E-IDE driver
>>> PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
>>> i8042.c: Warning: Keylock active.
>>> serio: i8042 KBD port at 0x60,0x64 irq 1
>>> serio: i8042 AUX port at 0x60,0x64 irq 12
>>> mice: PS/2 mouse device common for all mice
>>> NET: Registered protocol family 17
>>> registered taskstats version 1
>>> input: AT Translated Set 2 keyboard as /class/input/input0
>>> PCI IO multiplexer device installed.
>>> BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
>>> Freeing unused kernel memory: 316k freed
>>> Console: switching to colour frame buffer device 80x30
>>> usbcore: registered new interface driver usbfs
>>> usbcore: registered new interface driver hub
>>> usbcore: registered new device driver usb
>>> ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
>>> ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
>>> ehci_hcd 0000:00:1a.0: setting latency timer to 64
>>> ehci_hcd 0000:00:1a.0: EHCI Host Controller
>>> ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
>>> ehci_hcd 0000:00:1a.0: debug port 2
>>> ehci_hcd 0000:00:1a.0: cache line size of 32 is not supported
>>> ehci_hcd 0000:00:1a.0: irq 16, io mem 0xe2e70000
>>> ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
>>> usb usb1: configuration #1 chosen from 1 choice
>>> hub 1-0:1.0: USB hub found
>>> hub 1-0:1.0: 3 ports detected
>>> ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
>>> ehci_hcd 0000:00:1d.0: setting latency timer to 64
>>> ehci_hcd 0000:00:1d.0: EHCI Host Controller
>>> ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
>>> ehci_hcd 0000:00:1d.0: debug port 2
>>> ehci_hcd 0000:00:1d.0: cache line size of 32 is not supported
>>> ehci_hcd 0000:00:1d.0: irq 17, io mem 0xe2e50000
>>> ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
>>> usb usb2: configuration #1 chosen from 1 choice
>>> hub 2-0:1.0: USB hub found
>>> hub 2-0:1.0: 3 ports detected
>>> ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
>>> uhci_hcd: USB Universal Host Controller Interface driver
>>> SCSI subsystem initialized
>>> libata version 3.00 loaded.
>>> ahci 0000:00:1f.2: version 3.0
>>> ahci 0000:00:1f.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
>>> ahci 0000:00:1f.2: irq 1279 (279) for MSI/MSI-X
>>> ahci: SSS flag set, parallel bus scan disabled
>>> ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x3b impl SATA mode
>>> ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ems sxs apst
>>> ahci 0000:00:1f.2: setting latency timer to 64
>>> scsi0 : ahci
>>> scsi1 : ahci
>>> scsi2 : ahci
>>> scsi3 : ahci
>>> scsi4 : ahci
>>> scsi5 : ahci
>>> ata1: SATA max UDMA/133 abar m2048@0xe2e40000 port 0xe2e40100 irq 1279
>>> ata2: SATA max UDMA/133 abar m2048@0xe2e40000 port 0xe2e40180 irq 1279
>>> ata3: DUMMY
>>> ata4: SATA max UDMA/133 abar m2048@0xe2e40000 port 0xe2e40280 irq 1279
>>> ata5: SATA max UDMA/133 abar m2048@0xe2e40000 port 0xe2e40300 irq 1279
>>> ata6: SATA max UDMA/133 abar m2048@0xe2e40000 port 0xe2e40380 irq 1279
>>> input: PS/2 Generic Mouse as /class/input/input1
>>> usb 1-1: new high speed USB device using ehci_hcd and address 2
>>> usb 1-1: configuration #1 chosen from 1 choice
>>> hub 1-1:1.0: USB hub found
>>> hub 1-1:1.0: 6 ports detected
>>> ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>>> usb 2-1: new high speed USB device using ehci_hcd and address 2
>>> ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
>>> ata1.00: ATA-8: ST9500423AS, 0002DEM1, max UDMA/133
>>> ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
>>> ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
>>> ata1.00: configured for UDMA/133
>>> scsi 0:0:0:0: Direct-Access     ATA      ST9500423AS      0002 PQ: 0 ANSI: 5
>>> sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
>>> sd 0:0:0:0: [sda] 4096-byte physical blocks
>>> sd 0:0:0:0: [sda] Write Protect is off
>>> sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
>>> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>>>  sda: sda1 sda2 sda3
>>> sd 0:0:0:0: [sda] Attached SCSI disk
>>> usb 2-1: configuration #1 chosen from 1 choice
>>> hub 2-1:1.0: USB hub found
>>> hub 2-1:1.0: 8 ports detected
>>> usb 1-1.4: new full speed USB device using ehci_hcd and address 3
>>> usb 1-1.4: configuration #1 chosen from 1 choice
>>> usb 1-1.5: new high speed USB device using ehci_hcd and address 4
>>> usb 1-1.5: configuration #1 chosen from 1 choice
>>> ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>>> ata2.00: ATAPI: HL-DT-ST DVD+/-RW GU60N, A102, max UDMA/133, ATAPI AN
>>> ata2.00: configured for UDMA/133
>>> scsi 1:0:0:0: CD-ROM            HL-DT-ST DVD+-RW GU60N    A102 PQ: 0 ANSI: 5
>>> usb 2-1.8: new full speed USB device using ehci_hcd and address 3
>>> usb 2-1.8: configuration #0 chosen from 1 choice
>>> usb 2-1.8: config 0 descriptor??
>>> ata4: SATA link down (SStatus 0 SControl 300)
>>> ata5: SATA link down (SStatus 0 SControl 300)
>>> ata6: SATA link down (SStatus 0 SControl 300)
>>> device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
>>> kjournald starting.  Commit interval 15 seconds
>>> EXT3-fs: mounted filesystem with ordered data mode.
>>> input: PC Speaker as /class/input/input2
>>> Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
>>> serial 0000:00:16.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
>>> 0000:00:16.3: ttyS0 at I/O 0x40e0 (irq = 17) is a 16550A
>>> e1000e: Intel(R) PRO/1000 Network Driver - 1.2.20-NAPI
>>> e1000e: Copyright(c) 1999 - 2010 Intel Corporation.
>>> e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
>>> e1000e 0000:00:19.0: setting latency timer to 64
>>> e1000e 0000:00:19.0: irq 1278 (278) for MSI/MSI-X
>>> rtc_cmos 00:06: RTC can wake from S4
>>> rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
>>> rtc0: alarms up to one year, y3k, 242 bytes nvram
>>> parport_pc 00:08: activated
>>> parport_pc 00:08: reported by Plug and Play ACPI
>>> parport_pc 00:08: disabled
>>> e1000e 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) d4:be:d9:0f:d0:6c
>>> e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
>>> e1000e 0000:00:19.0: eth0: MAC: 11, PHY: 11, PBA No: 3041FF-0FF
>>> i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
>>> ACPI: I/O resource 0000:00:1f.3 [0x4040-0x405f] conflicts with ACPI region SMBI [0x4040-0x404f]
>>> ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
>>> ACPI: SSDT cadd7798 00727 (v01  PmRef  Cpu0Cst 00003001 INTL 20090903)
>>> ACPI: SSDT cadd8a98 00303 (v01  PmRef    ApIst 00003000 INTL 20090903)
>>> ACPI: SSDT cadd6d98 00119 (v01  PmRef    ApCst 00003000 INTL 20090903)
>>> input: Lid Switch as /class/input/input3
>>> ACPI: Lid Switch [LID]
>>> input: Power Button as /class/input/input4
>>> ACPI: Power Button [PBTN]
>>> input: Sleep Button as /class/input/input5
>>> ACPI: Sleep Button [SBTN]
>>> input: Power Button as /class/input/input6
>>> ACPI: Power Button [PWRF]
>>> thermal LNXTHERM:01: registered as thermal_zone0
>>> ACPI: Thermal Zone [THM] (25 C)
>>> sr0: scsi3-mmc drive: 24x/8x writer dvd-ram cd/rw xa/form2 cdda tray
>>> Uniform CD-ROM driver Revision: 3.20
>>> sr 1:0:0:0: Attached scsi CD-ROM sr0
>>> Compat-wireless backport release: compat-wireless-v3.4-rc1-2
>>> Backport based on linux-stable.git v3.4-rc1
>>> cfg80211: Calling CRDA to update world regulatory domain
>>> ACPI: AC Adapter [AC] (on-line)
>>> sd 0:0:0:0: Attached scsi generic sg0 type 0
>>> sr 1:0:0:0: Attached scsi generic sg1 type 5
>>> ACPI: Battery Slot [BAT0] (battery present)
>>> ACPI: Battery Slot [BAT1] (battery absent)
>>> ACPI: Battery Slot [BAT2] (battery absent)
>>> Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
>>> Copyright(c) 2003-2012 Intel Corporation
>>> iwlwifi 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
>>> iwlwifi 0000:02:00.0: setting latency timer to 64
>>> iwlwifi 0000:02:00.0: pci_resource_len = 0x00002000
>>> iwlwifi 0000:02:00.0: pci_resource_base = f2478000
>>> iwlwifi 0000:02:00.0: HW Revision ID = 0x34
>>> iwlwifi 0000:02:00.0: irq 1277 (277) for MSI/MSI-X
>>> acpi device:37: registered as cooling_device8
>>> input: Video Bus as /class/input/input7
>>> ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
>>> Non-volatile memory driver v1.3
>>> lp: driver loaded but no devices found
>>> md: Autodetecting RAID arrays.
>>> md: Scanned 0 and added 0 devices.
>>> md: autorun ...
>>> md: ... autorun DONE.
>>> EXT3 FS on sda1, internal journal
>>> ISO 9660 Extensions: Microsoft Joliet Level 3
>>> ISO 9660 Extensions: RRIP_1991A
>>> Adding 524280k swap on /var/swap/swap.001.  Priority:-1 extents:137 across:637248k
>>> Microcode Update Driver: v2.00-xen <tigran@aivazian.fsnet.co.uk>, Peter Oruba
>>> Microcode Update Driver: v2.00-xen removed.
>>> ip_tables: (C) 2000-2006 Netfilter Core Team
>>> nf_conntrack version 0.5.0 (12157 buckets, 48628 max)
>>> e1000e 0000:00:19.0: irq 1278 (278) for MSI/MSI-X
>>> e1000e 0000:00:19.0: irq 1278 (278) for MSI/MSI-X
>>> 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
>>> All bugs added by David S. Miller <davem@redhat.com>
>>> device xenbr0 entered promiscuous mode
>>> device eth0 entered promiscuous mode
>>> e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
>>> e1000e 0000:00:19.0: eth0: 10/100 speed: disabling TSO
>>> RPC: Registered udp transport module.
>>> RPC: Registered tcp transport module.
>>> RPC: Registered tcp NFSv4.1 backchannel transport module.
>>> warning: `ntpdate' uses 32-bit capabilities (legacy support in use)
>>> suspend: event channel 38
>>> kjournald starting.  Commit interval 15 seconds
>>> EXT3 FS on dm-0, internal journal
>>> EXT3-fs: mounted filesystem with ordered data mode.
>>> iwlwifi 0000:02:00.0: ea4b7e1c
>>> iwlwifi 0000:02:00.0: ca253e1c
>>> iwlwifi 0000:02:00.0: ca253de8
>>> iwlwifi 0000:02:00.0: PCI INT A disabled
>>>
>>>
>>
>> Ok, can you please set all the debug flags. Since nothing happens here
>> we shouldn't' see that many debug prints:
>>
>> modprobe iwlwifi debug=0xffffffff
>>
