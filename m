Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f183.google.com ([209.85.223.183]:62481 "EHLO
	mail-iw0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab0AXXLY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jan 2010 18:11:24 -0500
Received: by iwn13 with SMTP id 13so2451742iwn.20
        for <linux-wireless@vger.kernel.org>; Sun, 24 Jan 2010 15:11:23 -0800 (PST)
Message-ID: <4B5CD1FF.4090209@twilightblue.net>
Date: Sun, 24 Jan 2010 17:04:31 -0600
From: Don Darling <darling.don@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Bug: 2.6.32 ath5k, associating with WEP128 AP is unreliable
Content-Type: multipart/mixed;
 boundary="------------060807020802090007050300"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060807020802090007050300
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello folks,

I recently tried upgrading to kernel version 2.6.32, but after this 
upgrade my wireless card became flaky when making connections. In cases 
where a connection can be established it is  stable, but there are 
problems when making wireless associations. Downgrading to kernel 
version 2.6.31 resolves this issue.  I'm not sure at the moment which 
versions of the ath5k driver maps to these kernel versions.

Here is a brief description of my system:

Machine:        Acer Aspire One D150 Netbook
Wireless Card:  Atheros AR5001. Full lspci dump is attached as 
"Atheros_AR5001.txt"
Driver:         ath5k
Kernel Log:     Attached as "messages.log"
Distro:         Arch Linux

I'm currently using netcfg 2.2.1 to establish a wireless connection.  
Immediately after system boot when it tries to connect, the wireless 
association fails, and the only message in the system log is:

Jan 24 11:47:04 aao1 kernel: ADDRCONF(NETDEV_UP): wlan0: link is not ready

If I try a second time, the connection succeeds, and is stable.  
However, if I then terminate the connection I cannot get it back no 
matter how many times I try.  From that point on, it will always report 
that it fails to get an IP address from the DHCP server.

I'm assuming this issue is related to the ath5k driver itself -- the 
network I'm using is only WEP128, and doesn't need wpa_supplicant.  In 
fact, I have fewer problems when I connect to WPA+TKIP networks with 
wpa_supplicant.

Reverting to 2.6.31 resolves this issue. It will connect the first time, 
and I can disconnect/re-connect several times without issue.

I initially reported on the Arch Linux Flyspray system at:

http://bugs.archlinux.org/task/17992

I was advised to report it upstream.

If there is some additional information I can easily gather for you, 
please let me know.  Unfortunately, right now I am probably not going to 
have the bandwidth to build a custom kernel or try bleeding edge drivers 
on this machine, but I at least wanted to do my part to make sure this 
issue was documented.

Thanks and best regards,
Don


--------------060807020802090007050300
Content-Type: text/plain;
 name="Atheros_AR5001.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="Atheros_AR5001.txt"

01:00.0 Ethernet controller: Atheros Communications Inc. AR5001 Wireless Network Adapter (rev 01)
	Subsystem: Foxconn International, Inc. Device e008
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at 55100000 (64-bit, non-prefetchable) [size=64K]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit-
		Address: 00000000  Data: 0000
	Capabilities: [60] Express (v1) Legacy Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <64us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM L1 Enabled; RCB 128 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [90] MSI-X: Enable- Count=1 Masked-
		Vector table: BAR=0 offset=00000000
		PBA: BAR=0 offset=00000000
	Capabilities: [100] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr+ BadTLP- BadDLLP- Rollover- Timeout+ NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		AERCap:	First Error Pointer: 14, GenCap+ CGenEn- ChkCap+ ChkEn-
	Capabilities: [140] Virtual Channel <?>
	Kernel driver in use: ath5k
	Kernel modules: ath5k

--------------060807020802090007050300
Content-Type: text/x-log;
 name="messages.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="messages.log"

Jan 24 11:46:57 aao1 kernel: Linux version 2.6.32-ARCH (tobias@T-POWA-LX) (gcc version 4.4.2 20091208 (prerelease) (GCC) ) #1 SMP PREEMPT Sat Jan 23 13:53:44 UTC 2010
Jan 24 11:46:57 aao1 kernel: KERNEL supported cpus:
Jan 24 11:46:57 aao1 kernel: Intel GenuineIntel
Jan 24 11:46:57 aao1 kernel: AMD AuthenticAMD
Jan 24 11:46:57 aao1 kernel: NSC Geode by NSC
Jan 24 11:46:57 aao1 kernel: Cyrix CyrixInstead
Jan 24 11:46:57 aao1 kernel: Centaur CentaurHauls
Jan 24 11:46:57 aao1 kernel: Transmeta GenuineTMx86
Jan 24 11:46:57 aao1 kernel: Transmeta TransmetaCPU
Jan 24 11:46:57 aao1 kernel: UMC UMC UMC UMC
Jan 24 11:46:57 aao1 kernel: BIOS-provided physical RAM map:
Jan 24 11:46:57 aao1 kernel: BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
Jan 24 11:46:57 aao1 kernel: BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
Jan 24 11:46:57 aao1 kernel: BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
Jan 24 11:46:57 aao1 kernel: BIOS-e820: 0000000000100000 - 000000003f576000 (usable)
Jan 24 11:46:57 aao1 kernel: BIOS-e820: 000000003f576000 - 000000003f5bf000 (reserved)
Jan 24 11:46:57 aao1 kernel: BIOS-e820: 000000003f5bf000 - 000000003f66d000 (usable)
Jan 24 11:46:57 aao1 kernel: BIOS-e820: 000000003f66d000 - 000000003f6bf000 (ACPI NVS)
Jan 24 11:46:57 aao1 kernel: BIOS-e820: 000000003f6bf000 - 000000003f6ef000 (usable)
Jan 24 11:46:57 aao1 kernel: BIOS-e820: 000000003f6ef000 - 000000003f6ff000 (ACPI data)
Jan 24 11:46:57 aao1 kernel: BIOS-e820: 000000003f6ff000 - 000000003f700000 (usable)
Jan 24 11:46:57 aao1 kernel: BIOS-e820: 000000003f700000 - 0000000040000000 (reserved)
Jan 24 11:46:57 aao1 kernel: BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
Jan 24 11:46:57 aao1 kernel: BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
Jan 24 11:46:57 aao1 kernel: BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
Jan 24 11:46:57 aao1 kernel: BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
Jan 24 11:46:57 aao1 kernel: BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
Jan 24 11:46:57 aao1 kernel: BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
Jan 24 11:46:57 aao1 kernel: DMI 2.4 present.
Jan 24 11:46:57 aao1 kernel: last_pfn = 0x3f700 max_arch_pfn = 0x100000
Jan 24 11:46:57 aao1 kernel: x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
Jan 24 11:46:57 aao1 kernel: Scanning 1 areas for low memory corruption
Jan 24 11:46:57 aao1 kernel: modified physical RAM map:
Jan 24 11:46:57 aao1 kernel: modified: 0000000000000000 - 0000000000002000 (usable)
Jan 24 11:46:57 aao1 kernel: modified: 0000000000002000 - 0000000000006000 (reserved)
Jan 24 11:46:57 aao1 kernel: modified: 0000000000006000 - 000000000009fc00 (usable)
Jan 24 11:46:57 aao1 kernel: modified: 000000000009fc00 - 00000000000a0000 (reserved)
Jan 24 11:46:57 aao1 kernel: modified: 00000000000e0000 - 0000000000100000 (reserved)
Jan 24 11:46:57 aao1 kernel: modified: 0000000000100000 - 000000003f576000 (usable)
Jan 24 11:46:57 aao1 kernel: modified: 000000003f576000 - 000000003f5bf000 (reserved)
Jan 24 11:46:57 aao1 kernel: modified: 000000003f5bf000 - 000000003f66d000 (usable)
Jan 24 11:46:57 aao1 kernel: modified: 000000003f66d000 - 000000003f6bf000 (ACPI NVS)
Jan 24 11:46:57 aao1 kernel: modified: 000000003f6bf000 - 000000003f6ef000 (usable)
Jan 24 11:46:57 aao1 kernel: modified: 000000003f6ef000 - 000000003f6ff000 (ACPI data)
Jan 24 11:46:57 aao1 kernel: modified: 000000003f6ff000 - 000000003f700000 (usable)
Jan 24 11:46:57 aao1 kernel: modified: 000000003f700000 - 0000000040000000 (reserved)
Jan 24 11:46:57 aao1 kernel: modified: 00000000e0000000 - 00000000f0000000 (reserved)
Jan 24 11:46:57 aao1 kernel: modified: 00000000fec00000 - 00000000fec01000 (reserved)
Jan 24 11:46:57 aao1 kernel: modified: 00000000fed14000 - 00000000fed1a000 (reserved)
Jan 24 11:46:57 aao1 kernel: modified: 00000000fed1c000 - 00000000fed20000 (reserved)
Jan 24 11:46:57 aao1 kernel: modified: 00000000fee00000 - 00000000fee01000 (reserved)
Jan 24 11:46:57 aao1 kernel: modified: 00000000fff00000 - 0000000100000000 (reserved)
Jan 24 11:46:57 aao1 kernel: init_memory_mapping: 0000000000000000-00000000377fe000
Jan 24 11:46:57 aao1 kernel: RAMDISK: 3f4b3000 - 3f565860
Jan 24 11:46:57 aao1 kernel: Allocated new RAMDISK: 00100000 - 001b2860
Jan 24 11:46:57 aao1 kernel: Move RAMDISK from 000000003f4b3000 - 000000003f56585f to 00100000 - 001b285f
Jan 24 11:46:57 aao1 kernel: ACPI: RSDP 000fe020 00024 (v02 ACER  )
Jan 24 11:46:57 aao1 kernel: ACPI: XSDT 3f6fe120 00064 (v01 ACER   ACER     00000001      01000013)
Jan 24 11:46:57 aao1 kernel: ACPI: FACP 3f6fc000 000F4 (v04 ACER   ACER     00000001 1025 01000013)
Jan 24 11:46:57 aao1 kernel: ACPI: DSDT 3f6f1000 06D44 (v01 ACER   ACER     00000001 1025 01000013)
Jan 24 11:46:57 aao1 kernel: ACPI: FACS 3f688000 00040
Jan 24 11:46:57 aao1 kernel: ACPI: SSDT 3f6fd000 004C4 (v02  PmRef    CpuPm 00003000 INTL 20051117)
Jan 24 11:46:57 aao1 kernel: ACPI: HPET 3f6fb000 00038 (v01 ACER   ACER     00000001 1025 01000013)
Jan 24 11:46:57 aao1 kernel: ACPI: APIC 3f6fa000 00068 (v02 ACER   ACER     00000001 1025 01000013)
Jan 24 11:46:57 aao1 kernel: ACPI: MCFG 3f6f9000 0003C (v01 ACER   ACER     00000001 1025 01000013)
Jan 24 11:46:57 aao1 kernel: ACPI: ASF! 3f6f8000 000A5 (v32 ACER   ACER     00000001 1025 01000013)
Jan 24 11:46:57 aao1 kernel: ACPI: SLIC 3f6f0000 00180 (v01 ACER   ACER     00000001 1025 01000013)
Jan 24 11:46:57 aao1 kernel: ACPI: BOOT 3f6ef000 00028 (v01 ACER   ACER     00000001 1025 01000013)
Jan 24 11:46:57 aao1 kernel: 127MB HIGHMEM available.
Jan 24 11:46:57 aao1 kernel: 887MB LOWMEM available.
Jan 24 11:46:57 aao1 kernel: mapped low ram: 0 - 377fe000
Jan 24 11:46:57 aao1 kernel: low ram: 0 - 377fe000
Jan 24 11:46:57 aao1 kernel: node 0 low ram: 00000000 - 377fe000
Jan 24 11:46:57 aao1 kernel: node 0 bootmap 00008000 - 0000ef00
Jan 24 11:46:57 aao1 kernel: (9 early reservations) ==> bootmem [0000000000 - 00377fe000]
Jan 24 11:46:57 aao1 kernel: #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
Jan 24 11:46:57 aao1 kernel: #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
Jan 24 11:46:57 aao1 kernel: #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
Jan 24 11:46:57 aao1 kernel: #3 [0001000000 - 000152c024]    TEXT DATA BSS ==> [0001000000 - 000152c024]
Jan 24 11:46:57 aao1 kernel: #4 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
Jan 24 11:46:57 aao1 kernel: #5 [000152d000 - 0001533148]              BRK ==> [000152d000 - 0001533148]
Jan 24 11:46:57 aao1 kernel: #6 [0000007000 - 0000008000]          PGTABLE ==> [0000007000 - 0000008000]
Jan 24 11:46:57 aao1 kernel: #7 [0000100000 - 00001b2860]      NEW RAMDISK ==> [0000100000 - 00001b2860]
Jan 24 11:46:57 aao1 kernel: #8 [0000008000 - 000000f000]          BOOTMAP ==> [0000008000 - 000000f000]
Jan 24 11:46:57 aao1 kernel: Zone PFN ranges:
Jan 24 11:46:57 aao1 kernel: DMA      0x00000000 -> 0x00001000
Jan 24 11:46:57 aao1 kernel: Normal   0x00001000 -> 0x000377fe
Jan 24 11:46:57 aao1 kernel: HighMem  0x000377fe -> 0x0003f700
Jan 24 11:46:57 aao1 kernel: Movable zone start PFN for each node
Jan 24 11:46:57 aao1 kernel: early_node_map[6] active PFN ranges
Jan 24 11:46:57 aao1 kernel: 0: 0x00000000 -> 0x00000002
Jan 24 11:46:57 aao1 kernel: 0: 0x00000006 -> 0x0000009f
Jan 24 11:46:57 aao1 kernel: 0: 0x00000100 -> 0x0003f576
Jan 24 11:46:57 aao1 kernel: 0: 0x0003f5bf -> 0x0003f66d
Jan 24 11:46:57 aao1 kernel: 0: 0x0003f6bf -> 0x0003f6ef
Jan 24 11:46:57 aao1 kernel: 0: 0x0003f6ff -> 0x0003f700
Jan 24 11:46:57 aao1 kernel: Using APIC driver default
Jan 24 11:46:57 aao1 kernel: ACPI: PM-Timer IO Port: 0x408
Jan 24 11:46:57 aao1 kernel: ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Jan 24 11:46:57 aao1 kernel: ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Jan 24 11:46:57 aao1 kernel: ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
Jan 24 11:46:57 aao1 kernel: ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
Jan 24 11:46:57 aao1 kernel: ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
Jan 24 11:46:57 aao1 kernel: IOAPIC[0]: apic_id 4, version 32, address 0xfec00000, GSI 0-23
Jan 24 11:46:57 aao1 kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
Jan 24 11:46:57 aao1 kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Jan 24 11:46:57 aao1 kernel: Enabling APIC mode:  Flat.  Using 1 I/O APICs
Jan 24 11:46:57 aao1 kernel: Using ACPI (MADT) for SMP configuration information
Jan 24 11:46:57 aao1 kernel: ACPI: HPET id: 0x8086a201 base: 0xfed00000
Jan 24 11:46:57 aao1 kernel: SMP: Allowing 2 CPUs, 0 hotplug CPUs
Jan 24 11:46:57 aao1 kernel: PM: Registered nosave memory: 0000000000002000 - 0000000000006000
Jan 24 11:46:57 aao1 kernel: PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
Jan 24 11:46:57 aao1 kernel: PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
Jan 24 11:46:57 aao1 kernel: PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
Jan 24 11:46:57 aao1 kernel: Allocating PCI resources starting at 40000000 (gap: 40000000:a0000000)
Jan 24 11:46:57 aao1 kernel: Booting paravirtualized kernel on bare hardware
Jan 24 11:46:57 aao1 kernel: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
Jan 24 11:46:57 aao1 kernel: PERCPU: Embedded 14 pages/cpu @c2000000 s34680 r0 d22664 u2097152
Jan 24 11:46:57 aao1 kernel: pcpu-alloc: s34680 r0 d22664 u2097152 alloc=1*4194304
Jan 24 11:46:57 aao1 kernel: pcpu-alloc: [0] 0 1 
Jan 24 11:46:57 aao1 kernel: Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 257537
Jan 24 11:46:57 aao1 kernel: Kernel command line: root=/dev/disk/by-uuid/0ebc9be7-c650-4257-95b7-a16e7416f9c4 ro snd-hda-intel.model=auto resume=/dev/disk/by-uuid/87f5b659-2ac1-4553-be61-30e3f720372c elevator=deadline vga=789
Jan 24 11:46:57 aao1 kernel: PID hash table entries: 4096 (order: 2, 16384 bytes)
Jan 24 11:46:57 aao1 kernel: Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Jan 24 11:46:57 aao1 kernel: Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Jan 24 11:46:57 aao1 kernel: Enabling fast FPU save and restore... done.
Jan 24 11:46:57 aao1 kernel: Enabling unmasked SIMD FPU exception support... done.
Jan 24 11:46:57 aao1 kernel: Initializing CPU#0
Jan 24 11:46:57 aao1 kernel: Initializing HighMem for node 0 (000377fe:0003f700)
Jan 24 11:46:57 aao1 kernel: Memory: 1022660k/1039360k available (2793k kernel code, 15120k reserved, 1180k data, 408k init, 129372k highmem)
Jan 24 11:46:57 aao1 kernel: virtual kernel memory layout:
Jan 24 11:46:57 aao1 kernel: fixmap  : 0xfff1e000 - 0xfffff000   ( 900 kB)
Jan 24 11:46:57 aao1 kernel: pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
Jan 24 11:46:57 aao1 kernel: vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
Jan 24 11:46:57 aao1 kernel: lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
Jan 24 11:46:57 aao1 kernel: .init : 0xc13e2000 - 0xc1448000   ( 408 kB)
Jan 24 11:46:57 aao1 kernel: .data : 0xc12ba77a - 0xc13e1908   (1180 kB)
Jan 24 11:46:57 aao1 kernel: .text : 0xc1000000 - 0xc12ba77a   (2793 kB)
Jan 24 11:46:57 aao1 kernel: Checking if this processor honours the WP bit even in supervisor mode...Ok.
Jan 24 11:46:57 aao1 kernel: SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
Jan 24 11:46:57 aao1 kernel: Hierarchical RCU implementation.
Jan 24 11:46:57 aao1 kernel: NR_IRQS:512
Jan 24 11:46:57 aao1 kernel: Console: colour dummy device 80x25
Jan 24 11:46:57 aao1 kernel: console [tty0] enabled
Jan 24 11:46:57 aao1 kernel: HPET: 3 timers in total, 0 timers will be used for per-cpu timer
Jan 24 11:46:57 aao1 kernel: Fast TSC calibration failed
Jan 24 11:46:57 aao1 kernel: TSC: PIT calibration matches HPET. 1 loops
Jan 24 11:46:57 aao1 kernel: Detected 1595.955 MHz processor.
Jan 24 11:46:57 aao1 kernel: Calibrating delay loop (skipped), value calculated using timer frequency.. 3193.90 BogoMIPS (lpj=5319850)
Jan 24 11:46:57 aao1 kernel: Security Framework initialized
Jan 24 11:46:57 aao1 kernel: Mount-cache hash table entries: 512
Jan 24 11:46:57 aao1 kernel: CPU: L1 I cache: 32K, L1 D cache: 24K
Jan 24 11:46:57 aao1 kernel: CPU: L2 cache: 512K
Jan 24 11:46:57 aao1 kernel: CPU: Physical Processor ID: 0
Jan 24 11:46:57 aao1 kernel: CPU: Processor Core ID: 0
Jan 24 11:46:57 aao1 kernel: mce: CPU supports 5 MCE banks
Jan 24 11:46:57 aao1 kernel: CPU0: Thermal monitoring enabled (TM2)
Jan 24 11:46:57 aao1 kernel: using mwait in idle threads.
Jan 24 11:46:57 aao1 kernel: Performance Events: Atom events, Intel PMU driver.
Jan 24 11:46:57 aao1 kernel: ... version:                3
Jan 24 11:46:57 aao1 kernel: ... bit width:              40
Jan 24 11:46:57 aao1 kernel: ... generic registers:      2
Jan 24 11:46:57 aao1 kernel: ... value mask:             000000ffffffffff
Jan 24 11:46:57 aao1 kernel: ... max period:             000000007fffffff
Jan 24 11:46:57 aao1 kernel: ... fixed-purpose events:   3
Jan 24 11:46:57 aao1 kernel: ... event mask:             0000000700000003
Jan 24 11:46:57 aao1 kernel: Checking 'hlt' instruction... OK.
Jan 24 11:46:57 aao1 kernel: ACPI: Core revision 20090903
Jan 24 11:46:57 aao1 kernel: ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
Jan 24 11:46:57 aao1 kernel: CPU0: Intel(R) Atom(TM) CPU N270   @ 1.60GHz stepping 02
Jan 24 11:46:57 aao1 kernel: Booting processor 1 APIC 0x1 ip 0x6000
Jan 24 11:46:57 aao1 kernel: Initializing CPU#1
Jan 24 11:46:57 aao1 kernel: Calibrating delay using timer specific routine.. 3193.98 BogoMIPS (lpj=5319968)
Jan 24 11:46:57 aao1 kernel: CPU: L1 I cache: 32K, L1 D cache: 24K
Jan 24 11:46:57 aao1 kernel: CPU: L2 cache: 512K
Jan 24 11:46:57 aao1 kernel: CPU: Physical Processor ID: 0
Jan 24 11:46:57 aao1 kernel: CPU: Processor Core ID: 0
Jan 24 11:46:57 aao1 kernel: CPU1: Thermal monitoring enabled (TM2)
Jan 24 11:46:57 aao1 kernel: CPU1: Intel(R) Atom(TM) CPU N270   @ 1.60GHz stepping 02
Jan 24 11:46:57 aao1 kernel: checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Jan 24 11:46:57 aao1 kernel: Brought up 2 CPUs
Jan 24 11:46:57 aao1 kernel: Total of 2 processors activated (6386.88 BogoMIPS).
Jan 24 11:46:57 aao1 kernel: NET: Registered protocol family 16
Jan 24 11:46:57 aao1 kernel: ACPI: bus type pci registered
Jan 24 11:46:57 aao1 kernel: PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
Jan 24 11:46:57 aao1 kernel: PCI: MCFG area at e0000000 reserved in E820
Jan 24 11:46:57 aao1 kernel: PCI: Using MMCONFIG for extended config space
Jan 24 11:46:57 aao1 kernel: PCI: Using configuration type 1 for base access
Jan 24 11:46:57 aao1 kernel: bio: create slab <bio-0> at 0
Jan 24 11:46:57 aao1 kernel: ACPI: Executed 1 blocks of module-level executable AML code
Jan 24 11:46:57 aao1 kernel: ACPI: BIOS _OSI(Linux) query ignored
Jan 24 11:46:57 aao1 kernel: ACPI: BIOS _OSI(Linux) query ignored
Jan 24 11:46:57 aao1 kernel: ACPI: Interpreter enabled
Jan 24 11:46:57 aao1 kernel: ACPI: (supports S0 S3 S4 S5)
Jan 24 11:46:57 aao1 kernel: ACPI: Using IOAPIC for interrupt routing
Jan 24 11:46:57 aao1 kernel: [Firmware Bug]: ACPI: ACPI brightness control misses _BQC function
Jan 24 11:46:57 aao1 kernel: ACPI: EC: GPE = 0x19, I/O: command/status = 0x66, data = 0x62
Jan 24 11:46:57 aao1 kernel: ACPI: Power Resource [FN00] (on)
Jan 24 11:46:57 aao1 kernel: ACPI: No dock devices found.
Jan 24 11:46:57 aao1 kernel: ACPI Error (dsfield-0143): [CAPB] Namespace lookup failure, AE_ALREADY_EXISTS
Jan 24 11:46:57 aao1 kernel: ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0._OSC] (Node f7016a38), AE_ALREADY_EXISTS
Jan 24 11:46:57 aao1 kernel: ACPI: Marking method _OSC as Serialized because of AE_ALREADY_EXISTS error
Jan 24 11:46:57 aao1 kernel: ACPI: PCI Root Bridge [PCI0] (0000:00)
Jan 24 11:46:57 aao1 kernel: pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
Jan 24 11:46:57 aao1 kernel: pci 0000:00:1b.0: PME# disabled
Jan 24 11:46:57 aao1 kernel: pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
Jan 24 11:46:57 aao1 kernel: pci 0000:00:1c.0: PME# disabled
Jan 24 11:46:57 aao1 kernel: pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
Jan 24 11:46:57 aao1 kernel: pci 0000:00:1c.1: PME# disabled
Jan 24 11:46:57 aao1 kernel: pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
Jan 24 11:46:57 aao1 kernel: pci 0000:00:1c.2: PME# disabled
Jan 24 11:46:57 aao1 kernel: pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
Jan 24 11:46:57 aao1 kernel: pci 0000:00:1d.7: PME# disabled
Jan 24 11:46:57 aao1 kernel: pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
Jan 24 11:46:57 aao1 kernel: pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
Jan 24 11:46:57 aao1 kernel: pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at ff2c (mask 0003)
Jan 24 11:46:57 aao1 kernel: pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0068 (mask 0007)
Jan 24 11:46:57 aao1 kernel: pci 0000:00:1f.2: PME# supported from D3hot
Jan 24 11:46:57 aao1 kernel: pci 0000:00:1f.2: PME# disabled
Jan 24 11:46:57 aao1 kernel: pci 0000:03:00.0: PME# supported from D3hot D3cold
Jan 24 11:46:57 aao1 kernel: pci 0000:03:00.0: PME# disabled
Jan 24 11:46:57 aao1 kernel: pci 0000:00:1e.0: transparent bridge
Jan 24 11:46:57 aao1 kernel: ACPI Error (dsfield-0143): [CAPB] Namespace lookup failure, AE_ALREADY_EXISTS
Jan 24 11:46:57 aao1 kernel: ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0._OSC] (Node f7016a38), AE_ALREADY_EXISTS
Jan 24 11:46:57 aao1 kernel: ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12)
Jan 24 11:46:57 aao1 kernel: ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 10 *11 12)
Jan 24 11:46:57 aao1 kernel: ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 10 *11 12)
Jan 24 11:46:57 aao1 kernel: ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 *11 12)
Jan 24 11:46:57 aao1 kernel: ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
Jan 24 11:46:57 aao1 kernel: ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
Jan 24 11:46:57 aao1 kernel: ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
Jan 24 11:46:57 aao1 kernel: ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
Jan 24 11:46:57 aao1 kernel: vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
Jan 24 11:46:57 aao1 kernel: vgaarb: loaded
Jan 24 11:46:57 aao1 kernel: PCI: Using ACPI for IRQ routing
Jan 24 11:46:57 aao1 kernel: NetLabel: Initializing
Jan 24 11:46:57 aao1 kernel: NetLabel:  domain hash size = 128
Jan 24 11:46:57 aao1 kernel: NetLabel:  protocols = UNLABELED CIPSOv4
Jan 24 11:46:57 aao1 kernel: NetLabel:  unlabeled traffic allowed by default
Jan 24 11:46:57 aao1 kernel: Switching to clocksource tsc
Jan 24 11:46:57 aao1 kernel: pnp: PnP ACPI init
Jan 24 11:46:57 aao1 kernel: ACPI: bus type pnp registered
Jan 24 11:46:57 aao1 kernel: pnp 00:01: io resource (0x164e-0x164f) overlaps 0000:00:1c.2 BAR 13 (0x1000-0x2fff), disabling
Jan 24 11:46:57 aao1 kernel: pnp: PnP ACPI: found 9 devices
Jan 24 11:46:57 aao1 kernel: ACPI: ACPI bus type pnp unregistered
Jan 24 11:46:57 aao1 kernel: system 00:01: ioport range 0x200-0x20f has been reserved
Jan 24 11:46:57 aao1 kernel: system 00:01: ioport range 0x600-0x60f has been reserved
Jan 24 11:46:57 aao1 kernel: system 00:01: ioport range 0x610-0x610 has been reserved
Jan 24 11:46:57 aao1 kernel: system 00:01: ioport range 0x800-0x80f has been reserved
Jan 24 11:46:57 aao1 kernel: system 00:01: ioport range 0x400-0x47f has been reserved
Jan 24 11:46:57 aao1 kernel: system 00:01: ioport range 0x500-0x53f has been reserved
Jan 24 11:46:57 aao1 kernel: system 00:01: ioport range 0xff2c-0xff2f has been reserved
Jan 24 11:46:57 aao1 kernel: system 00:01: iomem range 0xe0000000-0xefffffff has been reserved
Jan 24 11:46:57 aao1 kernel: system 00:01: iomem range 0xfed1c000-0xfed1ffff has been reserved
Jan 24 11:46:57 aao1 kernel: system 00:01: iomem range 0xfed14000-0xfed17fff has been reserved
Jan 24 11:46:57 aao1 kernel: system 00:01: iomem range 0xfed18000-0xfed18fff has been reserved
Jan 24 11:46:57 aao1 kernel: system 00:01: iomem range 0xfed19000-0xfed19fff has been reserved
Jan 24 11:46:57 aao1 kernel: system 00:01: iomem range 0xfec00000-0xfec00fff could not be reserved
Jan 24 11:46:57 aao1 kernel: system 00:01: iomem range 0xfee00000-0xfee00fff has been reserved
Jan 24 11:46:57 aao1 kernel: pci 0000:00:1c.0: PCI bridge, secondary bus 0000:01
Jan 24 11:46:57 aao1 kernel: pci 0000:00:1c.0:   IO window: 0x4000-0x4fff
Jan 24 11:46:57 aao1 kernel: pci 0000:00:1c.0:   MEM window: 0x55100000-0x561fffff
Jan 24 11:46:57 aao1 kernel: pci 0000:00:1c.0:   PREFETCH window: 0x00000050000000-0x00000050ffffff
Jan 24 11:46:57 aao1 kernel: pci 0000:00:1c.1: PCI bridge, secondary bus 0000:02
Jan 24 11:46:57 aao1 kernel: pci 0000:00:1c.1:   IO window: 0x3000-0x3fff
Jan 24 11:46:57 aao1 kernel: pci 0000:00:1c.1:   MEM window: 0x54100000-0x550fffff
Jan 24 11:46:57 aao1 kernel: pci 0000:00:1c.1:   PREFETCH window: 0x00000051000000-0x00000051ffffff
Jan 24 11:46:57 aao1 kernel: pci 0000:00:1c.2: PCI bridge, secondary bus 0000:03
Jan 24 11:46:57 aao1 kernel: pci 0000:00:1c.2:   IO window: 0x1000-0x2fff
Jan 24 11:46:57 aao1 kernel: pci 0000:00:1c.2:   MEM window: 0x53000000-0x540fffff
Jan 24 11:46:57 aao1 kernel: pci 0000:00:1c.2:   PREFETCH window: 0x00000052000000-0x00000052ffffff
Jan 24 11:46:57 aao1 kernel: pci 0000:00:1e.0: PCI bridge, secondary bus 0000:04
Jan 24 11:46:57 aao1 kernel: pci 0000:00:1e.0:   IO window: disabled
Jan 24 11:46:57 aao1 kernel: pci 0000:00:1e.0:   MEM window: disabled
Jan 24 11:46:57 aao1 kernel: pci 0000:00:1e.0:   PREFETCH window: disabled
Jan 24 11:46:57 aao1 kernel: pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Jan 24 11:46:57 aao1 kernel: pci 0000:00:1c.1: enabling device (0000 -> 0003)
Jan 24 11:46:57 aao1 kernel: pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
Jan 24 11:46:57 aao1 kernel: pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
Jan 24 11:46:57 aao1 kernel: NET: Registered protocol family 2
Jan 24 11:46:57 aao1 kernel: IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
Jan 24 11:46:57 aao1 kernel: TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
Jan 24 11:46:57 aao1 kernel: TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
Jan 24 11:46:57 aao1 kernel: TCP: Hash tables configured (established 131072 bind 65536)
Jan 24 11:46:57 aao1 kernel: TCP reno registered
Jan 24 11:46:57 aao1 kernel: NET: Registered protocol family 1
Jan 24 11:46:57 aao1 kernel: Unpacking initramfs...
Jan 24 11:46:57 aao1 kernel: Freeing initrd memory: 714k freed
Jan 24 11:46:57 aao1 kernel: Simple Boot Flag value 0x5 read from CMOS RAM was invalid
Jan 24 11:46:57 aao1 kernel: Simple Boot Flag at 0x44 set to 0x1
Jan 24 11:46:57 aao1 kernel: apm: BIOS not found.
Jan 24 11:46:57 aao1 kernel: Scanning for low memory corruption every 60 seconds
Jan 24 11:46:57 aao1 kernel: audit: initializing netlink socket (disabled)
Jan 24 11:46:57 aao1 kernel: type=2000 audit(1264355199.513:1): initialized
Jan 24 11:46:57 aao1 kernel: highmem bounce pool size: 64 pages
Jan 24 11:46:57 aao1 kernel: VFS: Disk quotas dquot_6.5.2
Jan 24 11:46:57 aao1 kernel: Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Jan 24 11:46:57 aao1 kernel: msgmni has been set to 1747
Jan 24 11:46:57 aao1 kernel: alg: No test for stdrng (krng)
Jan 24 11:46:57 aao1 kernel: Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
Jan 24 11:46:57 aao1 kernel: io scheduler noop registered
Jan 24 11:46:57 aao1 kernel: io scheduler anticipatory registered
Jan 24 11:46:57 aao1 kernel: io scheduler deadline registered (default)
Jan 24 11:46:57 aao1 kernel: io scheduler cfq registered
Jan 24 11:46:57 aao1 kernel: vesafb: framebuffer at 0x40000000, mapped to 0xf8080000, using 3750k, total 7872k
Jan 24 11:46:57 aao1 kernel: vesafb: mode is 800x600x32, linelength=3200, pages=3
Jan 24 11:46:57 aao1 kernel: vesafb: scrolling: redraw
Jan 24 11:46:57 aao1 kernel: vesafb: Truecolor: size=8:8:8:8, shift=24:16:8:0
Jan 24 11:46:57 aao1 kernel: Console: switching to colour frame buffer device 100x37
Jan 24 11:46:57 aao1 kernel: fb0: VESA VGA frame buffer device
Jan 24 11:46:57 aao1 kernel: isapnp: Scanning for PnP cards...
Jan 24 11:46:57 aao1 kernel: isapnp: No Plug & Play device found
Jan 24 11:46:57 aao1 kernel: Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
Jan 24 11:46:57 aao1 kernel: input: Macintosh mouse button emulation as /devices/virtual/input/input0
Jan 24 11:46:57 aao1 kernel: PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSS0] at 0x60,0x64 irq 1,12
Jan 24 11:46:57 aao1 kernel: serio: i8042 KBD port at 0x60,0x64 irq 1
Jan 24 11:46:57 aao1 kernel: serio: i8042 AUX port at 0x60,0x64 irq 12
Jan 24 11:46:57 aao1 kernel: mice: PS/2 mouse device common for all mice
Jan 24 11:46:57 aao1 kernel: cpuidle: using governor ladder
Jan 24 11:46:57 aao1 kernel: cpuidle: using governor menu
Jan 24 11:46:57 aao1 kernel: TCP cubic registered
Jan 24 11:46:57 aao1 kernel: NET: Registered protocol family 17
Jan 24 11:46:57 aao1 kernel: Using IPI No-Shortcut mode
Jan 24 11:46:57 aao1 kernel: input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
Jan 24 11:46:57 aao1 kernel: registered taskstats version 1
Jan 24 11:46:57 aao1 kernel: Initalizing network drop monitor service
Jan 24 11:46:57 aao1 kernel: Freeing unused kernel memory: 408k freed
Jan 24 11:46:57 aao1 kernel: SCSI subsystem initialized
Jan 24 11:46:57 aao1 kernel: pata_acpi 0000:00:1f.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Jan 24 11:46:57 aao1 kernel: pata_acpi 0000:00:1f.1: PCI INT A disabled
Jan 24 11:46:57 aao1 kernel: ata_piix 0000:00:1f.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Jan 24 11:46:57 aao1 kernel: scsi0 : ata_piix
Jan 24 11:46:57 aao1 kernel: scsi1 : ata_piix
Jan 24 11:46:57 aao1 kernel: ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x50c0 irq 14
Jan 24 11:46:57 aao1 kernel: ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x50c8 irq 15
Jan 24 11:46:57 aao1 kernel: ahci 0000:00:1f.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
Jan 24 11:46:57 aao1 kernel: ahci: SSS flag set, parallel bus scan disabled
Jan 24 11:46:57 aao1 kernel: ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 1.5 Gbps 0x5 impl SATA mode
Jan 24 11:46:57 aao1 kernel: ahci 0000:00:1f.2: flags: 64bit ncq ilck stag pm led clo pio slum part 
Jan 24 11:46:57 aao1 kernel: scsi2 : ahci
Jan 24 11:46:57 aao1 kernel: scsi3 : ahci
Jan 24 11:46:57 aao1 kernel: scsi4 : ahci
Jan 24 11:46:57 aao1 kernel: scsi5 : ahci
Jan 24 11:46:57 aao1 kernel: ata3: SATA max UDMA/133 abar m1024@0x56344000 port 0x56344100 irq 27
Jan 24 11:46:57 aao1 kernel: ata4: DUMMY
Jan 24 11:46:57 aao1 kernel: ata5: SATA max UDMA/133 abar m1024@0x56344000 port 0x56344200 irq 27
Jan 24 11:46:57 aao1 kernel: ata6: DUMMY
Jan 24 11:46:57 aao1 kernel: ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Jan 24 11:46:57 aao1 kernel: ata3.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
Jan 24 11:46:57 aao1 kernel: ata3.00: ATA-8: Hitachi HTS543216L9A300, FB2OC40C, max UDMA/133
Jan 24 11:46:57 aao1 kernel: ata3.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
Jan 24 11:46:57 aao1 kernel: ata3.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
Jan 24 11:46:57 aao1 kernel: ata3.00: configured for UDMA/133
Jan 24 11:46:57 aao1 kernel: scsi 2:0:0:0: Direct-Access     ATA      Hitachi HTS54321 FB2O PQ: 0 ANSI: 5
Jan 24 11:46:57 aao1 kernel: ata5: SATA link down (SStatus 0 SControl 300)
Jan 24 11:46:57 aao1 kernel: sd 2:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
Jan 24 11:46:57 aao1 kernel: sd 2:0:0:0: [sda] Write Protect is off
Jan 24 11:46:57 aao1 kernel: sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jan 24 11:46:57 aao1 kernel: sda: sda1 sda2 sda3 sda4
Jan 24 11:46:57 aao1 kernel: sd 2:0:0:0: [sda] Attached SCSI disk
Jan 24 11:46:57 aao1 kernel: PM: Starting manual resume from disk
Jan 24 11:46:57 aao1 kernel: EXT4-fs (sda3): mounted filesystem with ordered data mode
Jan 24 11:46:57 aao1 kernel: rtc_cmos 00:03: RTC can wake from S4
Jan 24 11:46:57 aao1 kernel: rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
Jan 24 11:46:57 aao1 kernel: rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
Jan 24 11:46:57 aao1 kernel: udev: starting version 146
Jan 24 11:46:57 aao1 kernel: ACPI: AC Adapter [AC] (on-line)
Jan 24 11:46:57 aao1 kernel: intel_rng: FWH not detected
Jan 24 11:46:57 aao1 kernel: usbcore: registered new interface driver usbfs
Jan 24 11:46:57 aao1 kernel: usbcore: registered new interface driver hub
Jan 24 11:46:57 aao1 kernel: usbcore: registered new device driver usb
Jan 24 11:46:57 aao1 kernel: ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Jan 24 11:46:57 aao1 kernel: ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Jan 24 11:46:57 aao1 kernel: ehci_hcd 0000:00:1d.7: EHCI Host Controller
Jan 24 11:46:57 aao1 kernel: ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
Jan 24 11:46:57 aao1 kernel: ehci_hcd 0000:00:1d.7: using broken periodic workaround
Jan 24 11:46:57 aao1 kernel: ehci_hcd 0000:00:1d.7: debug port 1
Jan 24 11:46:57 aao1 kernel: ehci_hcd 0000:00:1d.7: irq 16, io mem 0x56344400
Jan 24 11:46:57 aao1 kernel: uhci_hcd: USB Universal Host Controller Interface driver
Jan 24 11:46:57 aao1 kernel: ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
Jan 24 11:46:57 aao1 kernel: usb usb1: configuration #1 chosen from 1 choice
Jan 24 11:46:57 aao1 kernel: hub 1-0:1.0: USB hub found
Jan 24 11:46:57 aao1 kernel: hub 1-0:1.0: 8 ports detected
Jan 24 11:46:57 aao1 kernel: uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Jan 24 11:46:57 aao1 kernel: uhci_hcd 0000:00:1d.0: UHCI Host Controller
Jan 24 11:46:57 aao1 kernel: uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
Jan 24 11:46:57 aao1 kernel: uhci_hcd 0000:00:1d.0: irq 16, io base 0x000050a0
Jan 24 11:46:57 aao1 kernel: usb usb2: configuration #1 chosen from 1 choice
Jan 24 11:46:57 aao1 kernel: hub 2-0:1.0: USB hub found
Jan 24 11:46:57 aao1 kernel: hub 2-0:1.0: 2 ports detected
Jan 24 11:46:57 aao1 kernel: uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
Jan 24 11:46:57 aao1 kernel: uhci_hcd 0000:00:1d.1: UHCI Host Controller
Jan 24 11:46:57 aao1 kernel: uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
Jan 24 11:46:57 aao1 kernel: uhci_hcd 0000:00:1d.1: irq 17, io base 0x00005080
Jan 24 11:46:57 aao1 kernel: usb usb3: configuration #1 chosen from 1 choice
Jan 24 11:46:57 aao1 kernel: hub 3-0:1.0: USB hub found
Jan 24 11:46:57 aao1 kernel: hub 3-0:1.0: 2 ports detected
Jan 24 11:46:57 aao1 kernel: uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
Jan 24 11:46:57 aao1 kernel: uhci_hcd 0000:00:1d.2: UHCI Host Controller
Jan 24 11:46:57 aao1 kernel: uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
Jan 24 11:46:57 aao1 kernel: uhci_hcd 0000:00:1d.2: irq 18, io base 0x00005060
Jan 24 11:46:57 aao1 kernel: usb usb4: configuration #1 chosen from 1 choice
Jan 24 11:46:57 aao1 kernel: hub 4-0:1.0: USB hub found
Jan 24 11:46:57 aao1 kernel: hub 4-0:1.0: 2 ports detected
Jan 24 11:46:57 aao1 kernel: uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
Jan 24 11:46:57 aao1 kernel: uhci_hcd 0000:00:1d.3: UHCI Host Controller
Jan 24 11:46:57 aao1 kernel: uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
Jan 24 11:46:57 aao1 kernel: uhci_hcd 0000:00:1d.3: irq 19, io base 0x00005040
Jan 24 11:46:57 aao1 kernel: usb usb5: configuration #1 chosen from 1 choice
Jan 24 11:46:57 aao1 kernel: hub 5-0:1.0: USB hub found
Jan 24 11:46:57 aao1 kernel: hub 5-0:1.0: 2 ports detected
Jan 24 11:46:57 aao1 kernel: Linux agpgart interface v0.103
Jan 24 11:46:57 aao1 kernel: ACPI: WMI: Mapper loaded
Jan 24 11:46:57 aao1 kernel: ATL1E 0000:03:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
Jan 24 11:46:57 aao1 kernel: ACPI: Battery Slot [BAT0] (battery present)
Jan 24 11:46:57 aao1 kernel: i801_smbus 0000:00:1f.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
Jan 24 11:46:57 aao1 kernel: agpgart-intel 0000:00:00.0: Intel 945GME Chipset
Jan 24 11:46:57 aao1 kernel: agpgart-intel 0000:00:00.0: detected 7932K stolen memory
Jan 24 11:46:57 aao1 kernel: usb 1-2: new high speed USB device using ehci_hcd and address 2
Jan 24 11:46:57 aao1 kernel: agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0x40000000
Jan 24 11:46:57 aao1 kernel: iTCO_vendor_support: vendor-support=0
Jan 24 11:46:57 aao1 kernel: acer-wmi: Acer Laptop ACPI-WMI Extras
Jan 24 11:46:57 aao1 kernel: iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
Jan 24 11:46:57 aao1 kernel: iTCO_wdt: Found a ICH7-M or ICH7-U TCO device (Version=2, TCOBASE=0x0460)
Jan 24 11:46:57 aao1 kernel: iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
Jan 24 11:46:57 aao1 kernel: sd 2:0:0:0: Attached scsi generic sg0 type 0
Jan 24 11:46:57 aao1 kernel: input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input2
Jan 24 11:46:57 aao1 kernel: ACPI: Power Button [PWRB]
Jan 24 11:46:57 aao1 kernel: input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input3
Jan 24 11:46:57 aao1 kernel: ACPI: Lid Switch [LID0]
Jan 24 11:46:57 aao1 kernel: input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input4
Jan 24 11:46:57 aao1 kernel: ACPI: Sleep Button [SLPB]
Jan 24 11:46:57 aao1 kernel: input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input5
Jan 24 11:46:57 aao1 kernel: ACPI: Power Button [PWRF]
Jan 24 11:46:57 aao1 kernel: usb 1-2: configuration #1 chosen from 1 choice
Jan 24 11:46:57 aao1 kernel: fan PNP0C0B:00: registered as cooling_device0
Jan 24 11:46:57 aao1 kernel: ACPI: Fan [FAN] (on)
Jan 24 11:46:57 aao1 kernel: cfg80211: Calling CRDA to update world regulatory domain
Jan 24 11:46:57 aao1 kernel: thermal LNXTHERM:01: registered as thermal_zone0
Jan 24 11:46:57 aao1 kernel: ACPI: Thermal Zone [THRM] (27 C)
Jan 24 11:46:57 aao1 kernel: ACPI: SSDT 3f580c90 00239 (v02  PmRef  Cpu0Ist 00003000 INTL 20051117)
Jan 24 11:46:57 aao1 kernel: ACPI: SSDT 3f57fe10 001C7 (v02  PmRef  Cpu0Cst 00003001 INTL 20051117)
Jan 24 11:46:57 aao1 kernel: Marking TSC unstable due to TSC halts in idle
Jan 24 11:46:57 aao1 kernel: processor LNXCPU:00: registered as cooling_device1
Jan 24 11:46:57 aao1 kernel: ACPI: SSDT 3f580f10 000D0 (v02  PmRef  Cpu1Ist 00003000 INTL 20051117)
Jan 24 11:46:57 aao1 kernel: ACPI: SSDT 3f57ef10 00083 (v02  PmRef  Cpu1Cst 00003000 INTL 20051117)
Jan 24 11:46:57 aao1 kernel: processor LNXCPU:01: registered as cooling_device2
Jan 24 11:46:57 aao1 kernel: Switching to clocksource hpet
Jan 24 11:46:57 aao1 kernel: [Firmware Bug]: ACPI: ACPI brightness control misses _BQC function
Jan 24 11:46:57 aao1 kernel: acpi device:18: registered as cooling_device3
Jan 24 11:46:57 aao1 kernel: input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input6
Jan 24 11:46:57 aao1 kernel: ACPI: Video Device [OVGA] (multi-head: yes  rom: yes  post: no)
Jan 24 11:46:57 aao1 kernel: ath5k 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Jan 24 11:46:57 aao1 kernel: ath5k 0000:01:00.0: registered as 'phy0'
Jan 24 11:46:57 aao1 kernel: [drm] Initialized drm 1.1.0 20060810
Jan 24 11:46:57 aao1 kernel: Linux video capture interface: v2.00
Jan 24 11:46:57 aao1 kernel: Synaptics Touchpad, model: 1, fw: 7.2, id: 0x1c0b1, caps: 0xd04771/0xa40000
Jan 24 11:46:57 aao1 kernel: uvcvideo: Found UVC 1.00 device USB 2.0 Camera (0c45:62c0)
Jan 24 11:46:57 aao1 kernel: input: USB 2.0 Camera as /devices/pci0000:00/0000:00:1d.7/usb1/1-2/1-2:1.0/input/input7
Jan 24 11:46:57 aao1 kernel: usbcore: registered new interface driver uvcvideo
Jan 24 11:46:57 aao1 kernel: USB Video Class driver (v0.1.0)
Jan 24 11:46:57 aao1 kernel: input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input8
Jan 24 11:46:57 aao1 kernel: i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Jan 24 11:46:57 aao1 kernel: [drm] set up 7M of stolen space
Jan 24 11:46:57 aao1 kernel: pci_hotplug: PCI Hot Plug PCI Core version: 0.5
Jan 24 11:46:57 aao1 kernel: Registered led device: ath5k-phy0::rx
Jan 24 11:46:57 aao1 kernel: Registered led device: ath5k-phy0::tx
Jan 24 11:46:57 aao1 kernel: ath5k phy0: Atheros AR2425 chip found (MAC: 0xe2, PHY: 0x70)
Jan 24 11:46:57 aao1 kernel: Console: switching to colour dummy device 80x25
Jan 24 11:46:57 aao1 kernel: Console: switching to colour frame buffer device 128x37
Jan 24 11:46:57 aao1 kernel: [drm] LVDS-8: set mode 1024x600 e
Jan 24 11:46:57 aao1 kernel: fb0: inteldrmfb frame buffer device
Jan 24 11:46:57 aao1 kernel: registered panic notifier
Jan 24 11:46:57 aao1 kernel: [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
Jan 24 11:46:57 aao1 kernel: HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Jan 24 11:46:57 aao1 kernel: input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input9
Jan 24 11:46:57 aao1 kernel: shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
Jan 24 11:46:57 aao1 kernel: st: Version 20081215, fixed bufsize 32768, s/g segs 256
Jan 24 11:46:57 aao1 kernel: ACPI Error (dsfield-0143): [CAPB] Namespace lookup failure, AE_ALREADY_EXISTS
Jan 24 11:46:57 aao1 kernel: ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0._OSC] (Node f7016a38), AE_ALREADY_EXISTS
Jan 24 11:46:57 aao1 kernel: ACPI Error (dsfield-0143): [CAPB] Namespace lookup failure, AE_ALREADY_EXISTS
Jan 24 11:46:57 aao1 kernel: ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0._OSC] (Node f7016a38), AE_ALREADY_EXISTS
Jan 24 11:46:57 aao1 kernel: ACPI Error (dsfield-0143): [CAPB] Namespace lookup failure, AE_ALREADY_EXISTS
Jan 24 11:46:57 aao1 kernel: ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0._OSC] (Node f7016a38), AE_ALREADY_EXISTS
Jan 24 11:46:57 aao1 kernel: ACPI Error (dsfield-0143): [CAPB] Namespace lookup failure, AE_ALREADY_EXISTS
Jan 24 11:46:57 aao1 kernel: ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0._OSC] (Node f7016a38), AE_ALREADY_EXISTS
Jan 24 11:46:57 aao1 kernel: ACPI Error (dsfield-0143): [CAPB] Namespace lookup failure, AE_ALREADY_EXISTS
Jan 24 11:46:57 aao1 kernel: ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0._OSC] (Node f7016a38), AE_ALREADY_EXISTS
Jan 24 11:46:57 aao1 kernel: ACPI Error (dsfield-0143): [CAPB] Namespace lookup failure, AE_ALREADY_EXISTS
Jan 24 11:46:57 aao1 kernel: ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0._OSC] (Node f7016a38), AE_ALREADY_EXISTS
Jan 24 11:46:57 aao1 kernel: pciehp: PCI Express Hot Plug Controller Driver version: 0.4
Jan 24 11:46:57 aao1 kernel: fuse init (API version 7.13)
Jan 24 11:46:57 aao1 kernel: scsi6 : vhba
Jan 24 11:46:57 aao1 kernel: input: Acer hotkey driver as /devices/virtual/input/input10
Jan 24 11:46:57 aao1 kernel: acerhk: Could not find model string, will assume type 200 series
Jan 24 11:46:57 aao1 kernel: Acer Travelmate hotkey driver v0.5.35
Jan 24 11:46:57 aao1 kernel: EXT4-fs (sda4): mounted filesystem with ordered data mode
Jan 24 11:46:57 aao1 kernel: Adding 1574360k swap on /dev/sda2.  Priority:-1 extents:1 across:1574360k 
Jan 24 11:46:57 aao1 kernel: ip_tables: (C) 2000-2006 Netfilter Core Team
Jan 24 11:46:57 aao1 kernel: nf_conntrack version 0.5.0 (16004 buckets, 64016 max)
Jan 24 11:46:57 aao1 kernel: CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
Jan 24 11:46:57 aao1 kernel: nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module option or
Jan 24 11:46:57 aao1 kernel: sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
Jan 24 11:46:57 aao1 kernel: NET: Registered protocol family 10
Jan 24 11:46:57 aao1 kernel: lo: Disabled Privacy Extensions
Jan 24 11:46:57 aao1 kernel: ip6_tables: (C) 2000-2006 Netfilter Core Team
Jan 24 11:46:58 aao1 acpid: starting up
Jan 24 11:46:58 aao1 acpid: 4 rules loaded
Jan 24 11:46:58 aao1 acpid: waiting for events: event logging is off
Jan 24 11:46:58 aao1 laptop-mode: Laptop mode 
Jan 24 11:46:58 aao1 laptop-mode: enabled, not active
Jan 24 11:46:59 aao1 /dev/sda: 
Jan 24 11:46:59 aao1 setting: standby to 244 (2 hours)
Jan 24 11:46:47 aao1 load-modules.sh: 'acpi:LNXSYSTM:' is not a valid module or alias name
Jan 24 11:46:47 aao1 load-modules.sh: 'pci:v00008086d000027A6sv00001025sd0000019Cbc03sc80i00' is not a valid module or alias name
Jan 24 11:46:47 aao1 load-modules.sh: Not loading module 'pcspkr' for alias 'platform:pcspkr' because it is blacklisted
Jan 24 11:46:47 aao1 load-modules.sh: 'pci:v00008086d00002448sv00000000sd00000000bc06sc04i01' is not a valid module or alias name
Jan 24 11:46:47 aao1 load-modules.sh: 'acpi:LNXSYBUS:' is not a valid module or alias name
Jan 24 11:46:48 aao1 load-modules.sh: 'platform:iTCO_wdt' is not a valid module or alias name
Jan 24 11:46:48 aao1 load-modules.sh: 'acpi:device:' is not a valid module or alias name
Jan 24 11:46:48 aao1 load-modules.sh: 'acpi:device:' is not a valid module or alias name
Jan 24 11:46:48 aao1 load-modules.sh: 'acpi:device:' is not a valid module or alias name
Jan 24 11:46:48 aao1 load-modules.sh: 'acpi:device:' is not a valid module or alias name
Jan 24 11:46:48 aao1 load-modules.sh: 'acpi:device:' is not a valid module or alias name
Jan 24 11:46:48 aao1 load-modules.sh: 'acpi:device:' is not a valid module or alias name
Jan 24 11:46:48 aao1 load-modules.sh: 'acpi:device:' is not a valid module or alias name
Jan 24 11:46:48 aao1 load-modules.sh: 'acpi:device:' is not a valid module or alias name
Jan 24 11:46:48 aao1 load-modules.sh: 'acpi:device:' is not a valid module or alias name
Jan 24 11:46:48 aao1 load-modules.sh: 'acpi:device:' is not a valid module or alias name
Jan 24 11:46:48 aao1 load-modules.sh: 'acpi:device:' is not a valid module or alias name
Jan 24 11:46:48 aao1 load-modules.sh: 'acpi:device:' is not a valid module or alias name
Jan 24 11:46:48 aao1 load-modules.sh: 'acpi:device:' is not a valid module or alias name
Jan 24 11:46:48 aao1 load-modules.sh: 'acpi:device:' is not a valid module or alias name
Jan 24 11:46:48 aao1 load-modules.sh: 'acpi:device:' is not a valid module or alias name
Jan 24 11:46:48 aao1 load-modules.sh: 'acpi:device:' is not a valid module or alias name
Jan 24 11:46:48 aao1 load-modules.sh: 'usb:v0C45p62C0d0100dcEFdsc02dp01ic0Eisc02ip00' is not a valid module or alias name
Jan 24 11:46:49 aao1 load-modules.sh: 'platform:regulatory' is not a valid module or alias name
Jan 24 11:46:49 aao1 load-modules.sh: 'acpi:device:' is not a valid module or alias name
Jan 24 11:46:49 aao1 load-modules.sh: 'acpi:PNP0000:' is not a valid module or alias name
Jan 24 11:46:49 aao1 load-modules.sh: 'acpi:PNP0C02:' is not a valid module or alias name
Jan 24 11:46:49 aao1 load-modules.sh: 'acpi:PNP0103:' is not a valid module or alias name
Jan 24 11:46:49 aao1 load-modules.sh: 'acpi:PNP0100:' is not a valid module or alias name
Jan 24 11:46:49 aao1 load-modules.sh: 'acpi:device:' is not a valid module or alias name
Jan 24 11:46:49 aao1 load-modules.sh: 'acpi:PNP0303:' is not a valid module or alias name
Jan 24 11:46:49 aao1 load-modules.sh: 'acpi:device:' is not a valid module or alias name
Jan 24 11:46:49 aao1 load-modules.sh: 'acpi:PNP0200:' is not a valid module or alias name
Jan 24 11:46:49 aao1 load-modules.sh: 'acpi:device:' is not a valid module or alias name
Jan 24 11:46:49 aao1 load-modules.sh: 'acpi:device:' is not a valid module or alias name
Jan 24 11:46:49 aao1 load-modules.sh: 'acpi:device:' is not a valid module or alias name
Jan 24 11:46:49 aao1 load-modules.sh: 'acpi:device:' is not a valid module or alias name
Jan 24 11:46:49 aao1 load-modules.sh: 'acpi:PNP0C04:' is not a valid module or alias name
Jan 24 11:46:49 aao1 load-modules.sh: 'acpi:INT0800:' is not a valid module or alias name
Jan 24 11:46:49 aao1 load-modules.sh: 'acpi:SYN1B1C:SYN1B00:SYN0002:PNP0F13:' is not a valid module or alias name
Jan 24 11:46:49 aao1 load-modules.sh: 'acpi:device:' is not a valid module or alias name
Jan 24 11:46:49 aao1 load-modules.sh: 'acpi:device:' is not a valid module or alias name
Jan 24 11:46:49 aao1 load-modules.sh: 'acpi:device:' is not a valid module or alias name
Jan 24 11:46:49 aao1 load-modules.sh: 'acpi:device:' is not a valid module or alias name
Jan 24 11:46:49 aao1 load-modules.sh: 'acpi:device:' is not a valid module or alias name
Jan 24 11:46:49 aao1 load-modules.sh: 'acpi:device:' is not a valid module or alias name
Jan 24 11:46:49 aao1 load-modules.sh: 'acpi:device:' is not a valid module or alias name
Jan 24 11:46:49 aao1 load-modules.sh: 'acpi:device:' is not a valid module or alias name
Jan 24 11:46:49 aao1 load-modules.sh: 'acpi:device:' is not a valid module or alias name
Jan 24 11:46:50 aao1 load-modules.sh: 'acpi:device:' is not a valid module or alias name
Jan 24 11:46:50 aao1 load-modules.sh: 'acpi:device:' is not a valid module or alias name
Jan 24 11:46:50 aao1 load-modules.sh: 'acpi:device:' is not a valid module or alias name
Jan 24 11:46:50 aao1 load-modules.sh: 'acpi:device:' is not a valid module or alias name
Jan 24 11:46:50 aao1 load-modules.sh: 'acpi:device:' is not a valid module or alias name
Jan 24 11:46:50 aao1 load-modules.sh: 'acpi:device:' is not a valid module or alias name
Jan 24 11:46:50 aao1 load-modules.sh: 'acpi:device:' is not a valid module or alias name
Jan 24 11:46:50 aao1 load-modules.sh: 'acpi:device:' is not a valid module or alias name
Jan 24 11:46:56 aao1 init: Entering runlevel: 3
Jan 24 11:47:01 aao1 acpid: client connected from 4007[82:82]
Jan 24 11:47:01 aao1 acpid: 1 client rule loaded
Jan 24 11:47:01 aao1 kernel: loop: module loaded
Jan 24 11:47:02 aao1 cdemud[4047]: Starting daemon in daemon mode with following parameters:
Jan 24 11:47:02 aao1 cdemud[4047]:  - num devices: 1
Jan 24 11:47:02 aao1 cdemud[4047]:  - ctl device: /dev/vhba_ctl
Jan 24 11:47:02 aao1 cdemud[4047]:  - audio driver: null
Jan 24 11:47:02 aao1 cdemud[4047]:  - bus type: system
Jan 24 11:47:02 aao1 kernel: scsi 6:0:0:0: CD-ROM            CDEmu    Virt. CD/DVD-ROM 1.10 PQ: 0 ANSI: 0
Jan 24 11:47:02 aao1 kernel: scsi 6:0:0:0: Attached scsi generic sg1 type 5
Jan 24 11:47:02 aao1 kernel: sr0: scsi3-mmc drive: 40x/40x cd/rw xa/form2 cdda tray
Jan 24 11:47:02 aao1 kernel: Uniform CD-ROM driver Revision: 3.20
Jan 24 11:47:04 aao1 kernel: ADDRCONF(NETDEV_UP): wlan0: link is not ready

--------------060807020802090007050300--
