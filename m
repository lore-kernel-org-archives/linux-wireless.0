Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 30.mail-out.ovh.net ([213.186.62.213]:51642 "HELO
	30.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751427AbZAZLmh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2009 06:42:37 -0500
Date: Mon, 26 Jan 2009 12:44:53 +0100
From: Samuel Ortiz <samuel@sortiz.org>
To: Deuce <the_deuce@yahoo.com>
Cc: reinette chatre <reinette.chatre@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: kernel BUG at drivers/net/wireless/iwlwifi/iwl3945-base.c:3127!
Message-ID: <20090126114453.GB3197@sortiz.org> (sfid-20090126_124251_370964_8A6AE6AC)
Reply-To: Samuel Ortiz <samuel@sortiz.org>
References: <760481.57662.qm@web57614.mail.re1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <760481.57662.qm@web57614.mail.re1.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jason,

On Sat, Jan 17, 2009 at 04:06:57PM -0800, Deuce wrote:
> > > I'll look into actually triggering the BUG_ON proper.
> > 
> > These three 'bad' results are from a NULL pointer.  Again, not the BUG_ON from 
> > earlier.
> > 
> > That's all for now.  I can try further tracking down the BUG_ON later.
> 
> commit 738910c064ff461051cd37e17199f270ff88a9a3 iwl3945: use rx queue management infrastructure from iwlcore is the first to trigger the BUG_ON.  However, prior versions would dereference a NULL pointer before the driver could get far enough to trigger the BUG_ON.
> 
> Below is the git bisect log.  "Good" in this case meant not the BUG_ON (but the NULL pointer crash) and "bad" was the BUG_ON.  Attached is dmesg output of the BUG_ON with debug=0x43fff.
> 
Thanks a lot for the testing. My apologies for the late reply :-/
I will look at the dmesg, but I was suspecting this commit to be the guilty
one. I'll keep you posted.

Cheers,
Samuel.


> I'll try out the latest wireless-testing, but I am skeptical.
> 
> Jason
> 
> For completeness here is the lspci output:
> lspci -vv -s 03:00.0
> 03:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG [Golan] Network Connection (rev 02)
>         Subsystem: Intel Corporation Device 1010
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0, Cache Line Size: 64 bytes
>         Interrupt: pin A routed to IRQ 2296
>         Region 0: Memory at df3ff000 (32-bit, non-prefetchable) [size=4K]
>         Capabilities: [c8] Power Management version 2
>                 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>         Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable+
>                 Address: 00000000fee0300c  Data: 41a2
>         Capabilities: [e0] Express (v1) Legacy Endpoint, MSI 00
>                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 unlimited
>                         ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
>                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
>                         RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
>                         MaxPayload 128 bytes, MaxReadReq 128 bytes
>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend+
>                 LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <128ns, L1 <64us
>                         ClockPM+ Suprise- LLActRep- BwNot-
>                 LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
>                         ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
>                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
>         Capabilities: [100] Advanced Error Reporting <?>
>         Capabilities: [140] Device Serial Number 6e-a1-20-ff-ff-3c-1f-00
>         Kernel driver in use: iwl3945
>         Kernel modules: iwl3945
> 
> git bisect log
> # bad: [10bc72100559eae0e27f111be96b5e4afd07a1dc] p54: power save management
> # good: [cbd8b90ffd8a321ffb2a705733729f0d5ebb20f9] iwl3945: iwl3945_queue and iwl3945_channel_info replacement
> git-bisect start 'master-2009-01-06' 'cbd8b90ffd8a321ffb2a705733729f0d5ebb20f9' '--' 'drivers/net/wireless/iwlwifi/'
> # good: [a0dedce20b4db9e6a7200eacb4d10fc3ee4c1b6b] iwlwifi: replace IWL_ERROR with IWL_ERR
> git-bisect good a0dedce20b4db9e6a7200eacb4d10fc3ee4c1b6b
> # good: [9bfb965e2826a3cc2f6abbefe59b9c3e8f0a8294] iwl3945: use iwl_get_hw_mode
> git-bisect good 9bfb965e2826a3cc2f6abbefe59b9c3e8f0a8294
> # good: [ff5010c3e12f1d0da27a5f871c2e3d5333dfbe2f] iwl3945: sync tx queue data structure with iwlagn
> git-bisect good ff5010c3e12f1d0da27a5f871c2e3d5333dfbe2f
> # good: [fadd267e5f9c2319ad62edad30f7af07b6b368ef] iwl3945: use iwl3945_tx_cmd instead of iwl_tx_cmd
> git-bisect good fadd267e5f9c2319ad62edad30f7af07b6b368ef
> # bad: [91471525caf0e0596a36d6c41c5c4265d4e82662] iwlwifi: make use of conf_is_ht*() helpers
> git-bisect bad 91471525caf0e0596a36d6c41c5c4265d4e82662
> # bad: [738910c064ff461051cd37e17199f270ff88a9a3] iwl3945: use rx queue management infrastructure from iwlcore
> git-bisect bad 738910c064ff461051cd37e17199f270ff88a9a3
> 
> 
>       
> [    0.000000] BIOS EBDA/lowmem at: 0009d800/0009d800
> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 2.6.28 (captainamerica@rainbow) (gcc version 4.3.2 (Ubuntu 4.3.2-1ubuntu11) ) #23 SMP Fri Jan 16 17:08:57 EST 2009
> [    0.000000] Command line: root=UUID=b49fa89a-8364-4ea0-b712-438b002b45c1 ro debug netconsole=@169.254.1.1/eth0,@169.254.192.6/
> [    0.000000] KERNEL supported cpus:
> [    0.000000]   Intel GenuineIntel
> [    0.000000]   AMD AuthenticAMD
> [    0.000000]   Centaur CentaurHauls
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009d800 (usable)
> [    0.000000]  BIOS-e820: 000000000009d800 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000d2000 - 00000000000d4000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 00000000bf6b0000 (usable)
> [    0.000000]  BIOS-e820: 00000000bf6b0000 - 00000000bf6cc000 (ACPI data)
> [    0.000000]  BIOS-e820: 00000000bf6cc000 - 00000000bf700000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 00000000bf700000 - 00000000c0000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
> [    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
> [    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
> [    0.000000]  BIOS-e820: 0000000100000000 - 000000013c000000 (usable)
> [    0.000000] DMI present.
> [    0.000000] last_pfn = 0x13c000 max_arch_pfn = 0x3ffffffff
> [    0.000000] last_pfn = 0xbf6b0 max_arch_pfn = 0x3ffffffff
> [    0.000000] init_memory_mapping: 0000000000000000-00000000bf6b0000
> [    0.000000]  0000000000 - 00bf600000 page 2M
> [    0.000000]  00bf600000 - 00bf6b0000 page 4k
> [    0.000000] kernel direct mapping tables up to bf6b0000 @ 8000-d000
> [    0.000000] last_map_addr: bf6b0000 end: bf6b0000
> [    0.000000] init_memory_mapping: 0000000100000000-000000013c000000
> [    0.000000]  0100000000 - 013c000000 page 2M
> [    0.000000] kernel direct mapping tables up to 13c000000 @ b000-11000
> [    0.000000] last_map_addr: 13c000000 end: 13c000000
> [    0.000000] RAMDISK: 36a36000 - 37fefa3b
> [    0.000000] ACPI: RSDP 000F68D0, 0024 (r2 LENOVO)
> [    0.000000] ACPI: XSDT BF6BB74D, 0094 (r1 LENOVO TP-7L        2120  LTP        0)
> [    0.000000] ACPI: FACP BF6BB800, 00F4 (r3 LENOVO TP-7L        2120 LNVO        1)
> [    0.000000] ACPI Warning (tbfadt-0460): Optional field "Gpe1Block" has zero address or length: 000000000000102C/0 [20080926]
> [    0.000000] ACPI: DSDT BF6BBC1D, FF03 (r1 LENOVO TP-7L        2120 MSFT  3000000)
> [    0.000000] ACPI: FACS BF6E4000, 0040
> [    0.000000] ACPI: SSDT BF6BB9B4, 0269 (r1 LENOVO TP-7L        2120 MSFT  3000000)
> [    0.000000] ACPI: ECDT BF6CBB20, 0052 (r1 LENOVO TP-7L        2120 LNVO        1)
> [    0.000000] ACPI: TCPA BF6CBB72, 0032 (r2 LENOVO TP-7L        2120 LNVO        1)
> [    0.000000] ACPI: APIC BF6CBBA4, 0068 (r1 LENOVO TP-7L        2120 LNVO        1)
> [    0.000000] ACPI: MCFG BF6CBC0C, 003C (r1 LENOVO TP-7L        2120 LNVO        1)
> [    0.000000] ACPI: HPET BF6CBC48, 0038 (r1 LENOVO TP-7L        2120 LNVO        1)
> [    0.000000] ACPI: SLIC BF6CBDF0, 0176 (r1 LENOVO TP-7L        2120  LTP        0)
> [    0.000000] ACPI: BOOT BF6CBF66, 0028 (r1 LENOVO TP-7L        2120  LTP        1)
> [    0.000000] ACPI: ASF! BF6CBF8E, 0072 (r16 LENOVO TP-7L        2120 PTL         1)
> [    0.000000] ACPI: SSDT BF6E26D9, 025F (r1 LENOVO TP-7L        2120 INTL 20050513)
> [    0.000000] ACPI: SSDT BF6E2938, 00A6 (r1 LENOVO TP-7L        2120 INTL 20050513)
> [    0.000000] ACPI: SSDT BF6E29DE, 04F7 (r1 LENOVO TP-7L        2120 INTL 20050513)
> [    0.000000] ACPI: SSDT BF6E2ED5, 01D8 (r1 LENOVO TP-7L        2120 INTL 20050513)
> [    0.000000] ACPI: DMI detected: Lenovo ThinkPad T61
> [    0.000000] ACPI: Added _OSI(Linux)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] No NUMA configuration found
> [    0.000000] Faking a node at 0000000000000000-000000013c000000
> [    0.000000] Bootmem setup node 0 0000000000000000-000000013c000000
> [    0.000000]   NODE_DATA [0000000000001000 - 0000000000005fff]
> [    0.000000]   bootmap [000000000000c000 -  00000000000337ff] pages 28
> [    0.000000] (7 early reservations) ==> bootmem [0000000000 - 013c000000]
> [    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
> [    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
> [    0.000000]   #2 [0000200000 - 000090b73c]    TEXT DATA BSS ==> [0000200000 - 000090b73c]
> [    0.000000]   #3 [0036a36000 - 0037fefa3b]          RAMDISK ==> [0036a36000 - 0037fefa3b]
> [    0.000000]   #4 [000009d800 - 0000100000]    BIOS reserved ==> [000009d800 - 0000100000]
> [    0.000000]   #5 [0000008000 - 000000b000]          PGTABLE ==> [0000008000 - 000000b000]
> [    0.000000]   #6 [000000b000 - 000000c000]          PGTABLE ==> [000000b000 - 000000c000]
> [    0.000000] found SMP MP-table at [ffff8800000f6900] 000f6900
> [    0.000000]  [ffffe20000000000-ffffe200045fffff] PMD -> [ffff880028200000-ffff88002b9fffff] on node 0
> [    0.000000] Zone PFN ranges:
> [    0.000000]   DMA      0x00000000 -> 0x00001000
> [    0.000000]   DMA32    0x00001000 -> 0x00100000
> [    0.000000]   Normal   0x00100000 -> 0x0013c000
> [    0.000000] Movable zone start PFN for each node
> [    0.000000] early_node_map[3] active PFN ranges
> [    0.000000]     0: 0x00000000 -> 0x0000009d
> [    0.000000]     0: 0x00000100 -> 0x000bf6b0
> [    0.000000]     0: 0x00100000 -> 0x0013c000
> [    0.000000] On node 0 totalpages: 1029709
> [    0.000000]   DMA zone: 56 pages used for memmap
> [    0.000000]   DMA zone: 1910 pages reserved
> [    0.000000]   DMA zone: 2031 pages, LIFO batch:0
> [    0.000000]   DMA32 zone: 14280 pages used for memmap
> [    0.000000]   DMA32 zone: 765672 pages, LIFO batch:31
> [    0.000000]   Normal zone: 3360 pages used for memmap
> [    0.000000]   Normal zone: 242400 pages, LIFO batch:31
> [    0.000000]   Movable zone: 0 pages used for memmap
> [    0.000000] ACPI: PM-Timer IO Port: 0x1008
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
> [    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 1, version 0, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
> [    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
> [    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
> [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000d2000
> [    0.000000] PM: Registered nosave memory: 00000000000d2000 - 00000000000d4000
> [    0.000000] PM: Registered nosave memory: 00000000000d4000 - 00000000000e0000
> [    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
> [    0.000000] PM: Registered nosave memory: 00000000bf6b0000 - 00000000bf6cc000
> [    0.000000] PM: Registered nosave memory: 00000000bf6cc000 - 00000000bf700000
> [    0.000000] PM: Registered nosave memory: 00000000bf700000 - 00000000c0000000
> [    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000f0000000
> [    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000f4000000
> [    0.000000] PM: Registered nosave memory: 00000000f4000000 - 00000000fec00000
> [    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000
> [    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fed00000
> [    0.000000] PM: Registered nosave memory: 00000000fed00000 - 00000000fed14000
> [    0.000000] PM: Registered nosave memory: 00000000fed14000 - 00000000fed1a000
> [    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1c000
> [    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed90000
> [    0.000000] PM: Registered nosave memory: 00000000fed90000 - 00000000fee00000
> [    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
> [    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ff000000
> [    0.000000] PM: Registered nosave memory: 00000000ff000000 - 0000000100000000
> [    0.000000] Allocating PCI resources starting at c4000000 (gap: c0000000:30000000)
> [    0.000000] PERCPU: Allocating 65536 bytes of per cpu data
> [    0.000000] per cpu data for cpu0 on node0 at 0000000028022000
> [    0.000000] per cpu data for cpu1 on node0 at 0000000028032000
> [    0.000000] NR_CPUS: 64, nr_cpu_ids: 2, nr_node_ids 1
> [    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1010103
> [    0.000000] Policy zone: Normal
> [    0.000000] Kernel command line: root=UUID=b49fa89a-8364-4ea0-b712-438b002b45c1 ro debug netconsole=@169.254.1.1/eth0,@169.254.192.6/
> [    0.000000] Initializing CPU#0
> [    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
> [    0.000000] Extended CMOS year: 2000
> [    0.000000] Fast TSC calibration using PIT
> [    0.000000] Detected 2194.085 MHz processor.
> [    0.004000] Console: colour VGA+ 80x25
> [    0.004000] console [tty0] enabled
> [    0.004000] allocated 41943040 bytes of page_cgroup
> [    0.004000] please try cgroup_disable=memory option if you don't want
> [    0.004000] Checking aperture...
> [    0.004000] No AGP bridge found
> [    0.004000] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
> [    0.004000] Placing software IO TLB between 0x20000000 - 0x24000000
> [    0.004000] Memory: 3924736k/5177344k available (3154k kernel code, 1058508k absent, 194100k reserved, 1766k data, 552k init)
> [    0.004000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
> [    0.004000] hpet clockevent registered
> [    0.004000] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
> [    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 4388.17 BogoMIPS (lpj=8776340)
> [    0.004000] Security Framework initialized
> [    0.004000] SELinux:  Disabled at boot.
> [    0.004000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
> [    0.004000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
> [    0.004782] Mount-cache hash table entries: 256
> [    0.004999] Initializing cgroup subsys ns
> [    0.005058] Initializing cgroup subsys cpuacct
> [    0.005112] Initializing cgroup subsys memory
> [    0.005167] Initializing cgroup subsys freezer
> [    0.005231] CPU: L1 I cache: 32K, L1 D cache: 32K
> [    0.005925] CPU: L2 cache: 4096K
> [    0.005976] CPU 0/0x0 -> Node 0
> [    0.006029] CPU: Physical Processor ID: 0
> [    0.006080] CPU: Processor Core ID: 0
> [    0.006133] CPU0: Thermal monitoring enabled (TM2)
> [    0.006185] using mwait in idle threads.
> [    0.007943] ACPI: Core revision 20080926
> [    0.032056] Setting APIC routing to flat
> [    0.032604] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.072458] CPU0: Intel(R) Core(TM)2 Duo CPU     T7500  @ 2.20GHz stepping 0b
> [    0.076001] Booting processor 1 APIC 0x1 ip 0x6000
> [    0.004000] Initializing CPU#1
> [    0.004000] Calibrating delay using timer specific routine.. 4388.96 BogoMIPS (lpj=8777932)
> [    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
> [    0.004000] CPU: L2 cache: 4096K
> [    0.004000] CPU 1/0x1 -> Node 0
> [    0.004000] CPU: Physical Processor ID: 0
> [    0.004000] CPU: Processor Core ID: 1
> [    0.004000] CPU1: Thermal monitoring enabled (TM2)
> [    0.160560] CPU1: Intel(R) Core(TM)2 Duo CPU     T7500  @ 2.20GHz stepping 0b
> [    0.161226] checking TSC synchronization [CPU#0 -> CPU#1]:
> [    0.164001] Measured 359205 cycles TSC warp between CPUs, turning off TSC clock.
> [    0.164001] Marking TSC unstable due to check_tsc_sync_source failed
> [    0.164040] Brought up 2 CPUs
> [    0.164101] Total of 2 processors activated (8777.13 BogoMIPS).
> [    0.164227] CPU0 attaching sched-domain:
> [    0.164288]  domain 0: span 0-1 level MC
> [    0.164396]   groups: 0 1
> [    0.164596]   domain 1: span 0-1 level NODE
> [    0.164701]    groups: 0-1
> [    0.164856] CPU1 attaching sched-domain:
> [    0.164916]  domain 0: span 0-1 level MC
> [    0.165021]   groups: 1 0
> [    0.165217]   domain 1: span 0-1 level NODE
> [    0.165325]    groups: 0-1
> [    0.165544] net_namespace: 1400 bytes
> [    0.165544] Booting paravirtualized kernel on bare hardware
> [    0.165544] Time: 22:17:24  Date: 01/16/09
> [    0.165544] NET: Registered protocol family 16
> [    0.168012] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
> [    0.168091] ACPI: bus type pci registered
> [    0.168159] PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 63
> [    0.168159] PCI: MCFG area at f0000000 reserved in E820
> [    0.170552] PCI: Using MMCONFIG at f0000000 - f3ffffff
> [    0.170613] PCI: Using configuration type 1 for base access
> [    0.173273] ACPI: EC: EC description table is found, configuring boot EC
> [    0.180456] ACPI: BIOS _OSI(Linux) query honored via DMI
> [    0.180023] ACPI: EC: non-query interrupt received, switching to interrupt mode
> [    0.190196] ACPI: Interpreter enabled
> [    0.190256] ACPI: (supports S0 S3 S4 S5)
> [    0.190519] ACPI: Using IOAPIC for interrupt routing
> [    0.212428] ACPI: EC: GPE = 0x12, I/O: command/status = 0x66, data = 0x62
> [    0.212428] ACPI: EC: driver started in interrupt mode
> [    0.213434] ACPI: ACPI Dock Station Driver: 3 docks/bays found
> [    0.213509] ACPI: PCI Root Bridge [PCI0] (0000:00)
> [    0.213674] pci 0000:00:02.0: reg 10 64bit mmio: [0xf8100000-0xf81fffff]
> [    0.213745] pci 0000:00:02.0: reg 18 64bit mmio: [0xe0000000-0xefffffff]
> [    0.213811] pci 0000:00:02.0: reg 20 io port: [0x1800-0x1807]
> [    0.213897] pci 0000:00:02.1: reg 10 64bit mmio: [0xf8200000-0xf82fffff]
> [    0.214136] pci 0000:00:19.0: reg 10 32bit mmio: [0xfe000000-0xfe01ffff]
> [    0.214215] pci 0000:00:19.0: reg 14 32bit mmio: [0xfe025000-0xfe025fff]
> [    0.214294] pci 0000:00:19.0: reg 18 io port: [0x1840-0x185f]
> [    0.214422] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
> [    0.214489] pci 0000:00:19.0: PME# disabled
> [    0.214659] pci 0000:00:1a.0: reg 20 io port: [0x1860-0x187f]
> [    0.214846] pci 0000:00:1a.1: reg 20 io port: [0x1880-0x189f]
> [    0.215010] pci 0000:00:1a.7: reg 10 32bit mmio: [0xfe226c00-0xfe226fff]
> [    0.215145] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
> [    0.216010] pci 0000:00:1a.7: PME# disabled
> [    0.216172] pci 0000:00:1b.0: reg 10 64bit mmio: [0xfe020000-0xfe023fff]
> [    0.216312] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
> [    0.216385] pci 0000:00:1b.0: PME# disabled
> [    0.216551] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
> [    0.216620] pci 0000:00:1c.0: PME# disabled
> [    0.216798] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
> [    0.216870] pci 0000:00:1c.1: PME# disabled
> [    0.217048] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
> [    0.217119] pci 0000:00:1c.2: PME# disabled
> [    0.217295] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
> [    0.217367] pci 0000:00:1c.3: PME# disabled
> [    0.217545] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
> [    0.217612] pci 0000:00:1c.4: PME# disabled
> [    0.217787] pci 0000:00:1d.0: reg 20 io port: [0x18a0-0x18bf]
> [    0.217960] pci 0000:00:1d.1: reg 20 io port: [0x18c0-0x18df]
> [    0.218141] pci 0000:00:1d.2: reg 20 io port: [0x18e0-0x18ff]
> [    0.218328] pci 0000:00:1d.7: reg 10 32bit mmio: [0xfe227000-0xfe2273ff]
> [    0.218468] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
> [    0.218537] pci 0000:00:1d.7: PME# disabled
> [    0.218863] pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
> [    0.218940] pci 0000:00:1f.0: quirk: region 1180-11bf claimed by ICH6 GPIO
> [    0.219068] pci 0000:00:1f.1: reg 10 io port: [0x00-0x07]
> [    0.219143] pci 0000:00:1f.1: reg 14 io port: [0x00-0x03]
> [    0.219217] pci 0000:00:1f.1: reg 18 io port: [0x00-0x07]
> [    0.219293] pci 0000:00:1f.1: reg 1c io port: [0x00-0x03]
> [    0.219370] pci 0000:00:1f.1: reg 20 io port: [0x1c00-0x1c0f]
> [    0.219544] pci 0000:00:1f.2: reg 10 io port: [0x1c50-0x1c57]
> [    0.219615] pci 0000:00:1f.2: reg 14 io port: [0x1c44-0x1c47]
> [    0.219693] pci 0000:00:1f.2: reg 18 io port: [0x1c48-0x1c4f]
> [    0.219767] pci 0000:00:1f.2: reg 1c io port: [0x1c40-0x1c43]
> [    0.219840] pci 0000:00:1f.2: reg 20 io port: [0x1c20-0x1c3f]
> [    0.219909] pci 0000:00:1f.2: reg 24 32bit mmio: [0xfe226000-0xfe2267ff]
> [    0.220046] pci 0000:00:1f.2: PME# supported from D3hot
> [    0.220113] pci 0000:00:1f.2: PME# disabled
> [    0.220234] pci 0000:00:1f.3: reg 10 32bit mmio: [0xfe227400-0xfe2274ff]
> [    0.220331] pci 0000:00:1f.3: reg 20 io port: [0x1c60-0x1c7f]
> [    0.220551] pci 0000:00:1c.0: bridge io port: [0x2000-0x2fff]
> [    0.220623] pci 0000:00:1c.0: bridge 32bit mmio: [0xfc000000-0xfdffffff]
> [    0.220699] pci 0000:00:1c.0: bridge 64bit mmio pref: [0xf8000000-0xf80fffff]
> [    0.220959] pci 0000:03:00.0: reg 10 32bit mmio: [0xdf3ff000-0xdf3fffff]
> [    0.221175] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
> [    0.221237] pci 0000:03:00.0: PME# disabled
> [    0.221389] pci 0000:00:1c.1: bridge io port: [0x3000-0x3fff]
> [    0.221451] pci 0000:00:1c.1: bridge 32bit mmio: [0xdc000000-0xdf3fffff]
> [    0.221524] pci 0000:00:1c.1: bridge 64bit mmio pref: [0xdfe00000-0xdfefffff]
> [    0.221672] pci 0000:00:1c.2: bridge io port: [0x4000-0x4fff]
> [    0.221739] pci 0000:00:1c.2: bridge 32bit mmio: [0xd8000000-0xd9ffffff]
> [    0.221816] pci 0000:00:1c.2: bridge 64bit mmio pref: [0xdfb00000-0xdfbfffff]
> [    0.221955] pci 0000:00:1c.3: bridge io port: [0x5000-0x5fff]
> [    0.222024] pci 0000:00:1c.3: bridge 32bit mmio: [0xd4000000-0xd5ffffff]
> [    0.222106] pci 0000:00:1c.3: bridge 64bit mmio pref: [0xdf800000-0xdf8fffff]
> [    0.222243] pci 0000:00:1c.4: bridge io port: [0x6000-0x6fff]
> [    0.222316] pci 0000:00:1c.4: bridge 32bit mmio: [0xd0000000-0xd1ffffff]
> [    0.222392] pci 0000:00:1c.4: bridge 64bit mmio pref: [0xdf500000-0xdf5fffff]
> [    0.222541] pci 0000:15:00.0: reg 10 32bit mmio: [0xf8300000-0xf8300fff]
> [    0.222627] pci 0000:15:00.0: supports D1 D2
> [    0.222688] pci 0000:15:00.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.222760] pci 0000:15:00.0: PME# disabled
> [    0.222903] pci 0000:15:00.1: reg 10 32bit mmio: [0xf8301000-0xf83017ff]
> [    0.223059] pci 0000:15:00.1: supports D1 D2
> [    0.223116] pci 0000:15:00.1: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.223187] pci 0000:15:00.1: PME# disabled
> [    0.223361] pci 0000:00:1e.0: transparent bridge
> [    0.223426] pci 0000:00:1e.0: bridge io port: [0x7000-0xafff]
> [    0.223494] pci 0000:00:1e.0: bridge 32bit mmio: [0xf8300000-0xfbffffff]
> [    0.223569] pci 0000:00:1e.0: bridge 64bit mmio pref: [0xf4000000-0xf7ffffff]
> [    0.223751] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> [    0.224123] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
> [    0.224330] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
> [    0.224530] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
> [    0.224735] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
> [    0.224938] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP4._PRT]
> [    0.225142] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
> [    0.228173] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 *10 11)
> [    0.228922] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
> [    0.229668] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
> [    0.230424] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
> [    0.232572] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
> [    0.233310] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
> [    0.234053] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
> [    0.234798] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
> [    0.236084] ACPI: Power Resource [PUBS] (on)
> [    0.236200] PCI: Using ACPI for IRQ routing
> [    0.256018] NET: Registered protocol family 8
> [    0.256082] NET: Registered protocol family 20
> [    0.256153] NetLabel: Initializing
> [    0.256153] NetLabel:  domain hash size = 128
> [    0.256153] NetLabel:  protocols = UNLABELED CIPSOv4
> [    0.256206] NetLabel:  unlabeled traffic allowed by default
> [    0.256359] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
> [    0.256604] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
> [    0.264013] Switched to high resolution mode on CPU 0
> [    0.265512] Switched to high resolution mode on CPU 1
> [    0.276015] pnp: PnP ACPI init
> [    0.276080] ACPI: bus type pnp registered
> [    0.281966] pnp: PnP ACPI: found 11 devices
> [    0.282030] ACPI: ACPI bus type pnp unregistered
> [    0.282098] system 00:00: iomem range 0x0-0x9ffff could not be reserved
> [    0.282163] system 00:00: iomem range 0xc0000-0xc3fff has been reserved
> [    0.282230] system 00:00: iomem range 0xc4000-0xc7fff has been reserved
> [    0.282297] system 00:00: iomem range 0xc8000-0xcbfff has been reserved
> [    0.282361] system 00:00: iomem range 0xcc000-0xcffff has been reserved
> [    0.282428] system 00:00: iomem range 0xd0000-0xd3fff could not be reserved
> [    0.282492] system 00:00: iomem range 0xe0000-0xe3fff could not be reserved
> [    0.282557] system 00:00: iomem range 0xe4000-0xe7fff could not be reserved
> [    0.282622] system 00:00: iomem range 0xe8000-0xebfff could not be reserved
> [    0.283282] system 00:00: iomem range 0xec000-0xeffff could not be reserved
> [    0.283344] system 00:00: iomem range 0xf0000-0xfffff could not be reserved
> [    0.283407] system 00:00: iomem range 0x100000-0xbfffffff could not be reserved
> [    0.283483] system 00:00: iomem range 0xfec00000-0xfed3ffff could not be reserved
> [    0.283558] system 00:00: iomem range 0xfed4c000-0xffffffff could not be reserved
> [    0.283637] system 00:02: ioport range 0x164e-0x164f has been reserved
> [    0.283701] system 00:02: ioport range 0x1000-0x107f has been reserved
> [    0.283767] system 00:02: ioport range 0x1180-0x11bf has been reserved
> [    0.283830] system 00:02: ioport range 0x800-0x80f has been reserved
> [    0.283896] system 00:02: ioport range 0x15e0-0x15ef has been reserved
> [    0.283961] system 00:02: ioport range 0x1600-0x165f could not be reserved
> [    0.284043] system 00:02: iomem range 0xf0000000-0xf3ffffff has been reserved
> [    0.284109] system 00:02: iomem range 0xfed1c000-0xfed1ffff has been reserved
> [    0.284174] system 00:02: iomem range 0xfed14000-0xfed17fff has been reserved
> [    0.284242] system 00:02: iomem range 0xfed18000-0xfed18fff has been reserved
> [    0.284307] system 00:02: iomem range 0xfed19000-0xfed19fff has been reserved
> [    0.284373] system 00:02: iomem range 0xfed45000-0xfed4bfff has been reserved
> [    0.289606] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
> [    0.289674] pci 0000:00:1c.0:   IO window: 0x2000-0x2fff
> [    0.289742] pci 0000:00:1c.0:   MEM window: 0xfc000000-0xfdffffff
> [    0.289811] pci 0000:00:1c.0:   PREFETCH window: 0x000000f8000000-0x000000f80fffff
> [    0.289894] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
> [    0.289960] pci 0000:00:1c.1:   IO window: 0x3000-0x3fff
> [    0.290027] pci 0000:00:1c.1:   MEM window: 0xdc000000-0xdf3fffff
> [    0.290098] pci 0000:00:1c.1:   PREFETCH window: 0x000000dfe00000-0x000000dfefffff
> [    0.290181] pci 0000:00:1c.2: PCI bridge, secondary bus 0000:04
> [    0.290250] pci 0000:00:1c.2:   IO window: 0x4000-0x4fff
> [    0.290323] pci 0000:00:1c.2:   MEM window: 0xd8000000-0xd9ffffff
> [    0.290394] pci 0000:00:1c.2:   PREFETCH window: 0x000000dfb00000-0x000000dfbfffff
> [    0.290477] pci 0000:00:1c.3: PCI bridge, secondary bus 0000:05
> [    0.290544] pci 0000:00:1c.3:   IO window: 0x5000-0x5fff
> [    0.290618] pci 0000:00:1c.3:   MEM window: 0xd4000000-0xd5ffffff
> [    0.290683] pci 0000:00:1c.3:   PREFETCH window: 0x000000df800000-0x000000df8fffff
> [    0.290768] pci 0000:00:1c.4: PCI bridge, secondary bus 0000:0d
> [    0.290837] pci 0000:00:1c.4:   IO window: 0x6000-0x6fff
> [    0.290910] pci 0000:00:1c.4:   MEM window: 0xd0000000-0xd1ffffff
> [    0.290978] pci 0000:00:1c.4:   PREFETCH window: 0x000000df500000-0x000000df5fffff
> [    0.291063] pci 0000:15:00.0: CardBus bridge, secondary bus 0000:16
> [    0.291125] pci 0000:15:00.0:   IO window: 0x007000-0x0070ff
> [    0.291198] pci 0000:15:00.0:   IO window: 0x007400-0x0074ff
> [    0.291268] pci 0000:15:00.0:   PREFETCH window: 0xf4000000-0xf7ffffff
> [    0.291342] pci 0000:15:00.0:   MEM window: 0xc4000000-0xc7ffffff
> [    0.291409] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:15
> [    0.291475] pci 0000:00:1e.0:   IO window: 0x7000-0xafff
> [    0.291547] pci 0000:00:1e.0:   MEM window: 0xf8300000-0xfbffffff
> [    0.291617] pci 0000:00:1e.0:   PREFETCH window: 0x000000f4000000-0x000000f7ffffff
> [    0.291718] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
> [    0.291787] pci 0000:00:1c.0: setting latency timer to 64
> [    0.291866] pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
> [    0.291932] pci 0000:00:1c.1: setting latency timer to 64
> [    0.292007] pci 0000:00:1c.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
> [    0.292078] pci 0000:00:1c.2: setting latency timer to 64
> [    0.292158] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
> [    0.292229] pci 0000:00:1c.3: setting latency timer to 64
> [    0.292305] pci 0000:00:1c.4: PCI INT A -> GSI 20 (level, low) -> IRQ 20
> [    0.292375] pci 0000:00:1c.4: setting latency timer to 64
> [    0.292446] pci 0000:00:1e.0: enabling device (0005 -> 0007)
> [    0.292518] pci 0000:00:1e.0: setting latency timer to 64
> [    0.292596] pci 0000:15:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    0.292668] pci 0000:15:00.0: setting latency timer to 64
> [    0.292737] bus: 00 index 0 io port: [0x00-0xffff]
> [    0.292800] bus: 00 index 1 mmio: [0x000000-0xffffffffffffffff]
> [    0.292865] bus: 02 index 0 io port: [0x2000-0x2fff]
> [    0.292929] bus: 02 index 1 mmio: [0xfc000000-0xfdffffff]
> [    0.292995] bus: 02 index 2 mmio: [0xf8000000-0xf80fffff]
> [    0.293078] bus: 02 index 3 mmio: [0x0-0x0]
> [    0.293141] bus: 03 index 0 io port: [0x3000-0x3fff]
> [    0.293205] bus: 03 index 1 mmio: [0xdc000000-0xdf3fffff]
> [    0.293266] bus: 03 index 2 mmio: [0xdfe00000-0xdfefffff]
> [    0.293331] bus: 03 index 3 mmio: [0x0-0x0]
> [    0.293392] bus: 04 index 0 io port: [0x4000-0x4fff]
> [    0.293455] bus: 04 index 1 mmio: [0xd8000000-0xd9ffffff]
> [    0.293519] bus: 04 index 2 mmio: [0xdfb00000-0xdfbfffff]
> [    0.293584] bus: 04 index 3 mmio: [0x0-0x0]
> [    0.293645] bus: 05 index 0 io port: [0x5000-0x5fff]
> [    0.293707] bus: 05 index 1 mmio: [0xd4000000-0xd5ffffff]
> [    0.293768] bus: 05 index 2 mmio: [0xdf800000-0xdf8fffff]
> [    0.293831] bus: 05 index 3 mmio: [0x0-0x0]
> [    0.293891] bus: 0d index 0 io port: [0x6000-0x6fff]
> [    0.293953] bus: 0d index 1 mmio: [0xd0000000-0xd1ffffff]
> [    0.294014] bus: 0d index 2 mmio: [0xdf500000-0xdf5fffff]
> [    0.294077] bus: 0d index 3 mmio: [0x0-0x0]
> [    0.294138] bus: 15 index 0 io port: [0x7000-0xafff]
> [    0.294197] bus: 15 index 1 mmio: [0xf8300000-0xfbffffff]
> [    0.294263] bus: 15 index 2 mmio: [0xf4000000-0xf7ffffff]
> [    0.294326] bus: 15 index 3 io port: [0x00-0xffff]
> [    0.294388] bus: 15 index 4 mmio: [0x000000-0xffffffffffffffff]
> [    0.294453] bus: 16 index 0 io port: [0x7000-0x70ff]
> [    0.294513] bus: 16 index 1 io port: [0x7400-0x74ff]
> [    0.294573] bus: 16 index 2 mmio: [0xf4000000-0xf7ffffff]
> [    0.294635] bus: 16 index 3 mmio: [0xc4000000-0xc7ffffff]
> [    0.294704] NET: Registered protocol family 2
> [    0.333137] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
> [    0.334315] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
> [    0.338992] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
> [    0.339727] TCP: Hash tables configured (established 524288 bind 65536)
> [    0.339793] TCP reno registered
> [    0.349100] NET: Registered protocol family 1
> [    0.349269] checking if image is initramfs... it is
> [    2.351020] Freeing initrd memory: 22246k freed
> [    2.364561] Simple Boot Flag at 0x35 set to 0x1
> [    2.365792] audit: initializing netlink socket (disabled)
> [    2.365869] type=2000 audit(1232144246.364:1): initialized
> [    2.371771] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [    2.374073] VFS: Disk quotas dquot_6.5.1
> [    2.374208] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> [    2.374427] msgmni has been set to 7708
> [    2.374676] alg: No test for stdrng (krng)
> [    2.374747] io scheduler noop registered
> [    2.374809] io scheduler anticipatory registered
> [    2.374872] io scheduler deadline registered
> [    2.375031] io scheduler cfq registered (default)
> [    2.375101] pci 0000:00:02.0: Boot video device
> [    2.385825] pcieport-driver 0000:00:1c.0: setting latency timer to 64
> [    2.385974] pcieport-driver 0000:00:1c.0: found MSI capability
> [    2.386091] pcieport-driver 0000:00:1c.0: irq 2303 for MSI/MSI-X
> [    2.386176] pci_express 0000:00:1c.0:pcie00: allocate port service
> [    2.386286] pci_express 0000:00:1c.0:pcie02: allocate port service
> [    2.386389] pci_express 0000:00:1c.0:pcie03: allocate port service
> [    2.386612] pcieport-driver 0000:00:1c.1: setting latency timer to 64
> [    2.386767] pcieport-driver 0000:00:1c.1: found MSI capability
> [    2.386889] pcieport-driver 0000:00:1c.1: irq 2302 for MSI/MSI-X
> [    2.386973] pci_express 0000:00:1c.1:pcie00: allocate port service
> [    2.387076] pci_express 0000:00:1c.1:pcie02: allocate port service
> [    2.387180] pci_express 0000:00:1c.1:pcie03: allocate port service
> [    2.387382] pcieport-driver 0000:00:1c.2: setting latency timer to 64
> [    2.387523] pcieport-driver 0000:00:1c.2: found MSI capability
> [    2.387641] pcieport-driver 0000:00:1c.2: irq 2301 for MSI/MSI-X
> [    2.387730] pci_express 0000:00:1c.2:pcie00: allocate port service
> [    2.387838] pci_express 0000:00:1c.2:pcie02: allocate port service
> [    2.387942] pci_express 0000:00:1c.2:pcie03: allocate port service
> [    2.388142] pcieport-driver 0000:00:1c.3: setting latency timer to 64
> [    2.388290] pcieport-driver 0000:00:1c.3: found MSI capability
> [    2.388403] pcieport-driver 0000:00:1c.3: irq 2300 for MSI/MSI-X
> [    2.388494] pci_express 0000:00:1c.3:pcie00: allocate port service
> [    2.388601] pci_express 0000:00:1c.3:pcie02: allocate port service
> [    2.388705] pci_express 0000:00:1c.3:pcie03: allocate port service
> [    2.388905] pcieport-driver 0000:00:1c.4: setting latency timer to 64
> [    2.389083] pcieport-driver 0000:00:1c.4: found MSI capability
> [    2.389195] pcieport-driver 0000:00:1c.4: irq 2299 for MSI/MSI-X
> [    2.389287] pci_express 0000:00:1c.4:pcie00: allocate port service
> [    2.389401] pci_express 0000:00:1c.4:pcie02: allocate port service
> [    2.389505] pci_express 0000:00:1c.4:pcie03: allocate port service
> [    2.420101] Linux agpgart interface v0.103
> [    2.420172] Serial: 8250/16550 driver4 ports, IRQ sharing enabled
> [    2.422437] brd: module loaded
> [    2.422499] e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
> [    2.422562] e1000e: Copyright (c) 1999-2008 Intel Corporation.
> [    2.422671] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
> [    2.422749] e1000e 0000:00:19.0: setting latency timer to 64
> [    2.422994] e1000e 0000:00:19.0: irq 2298 for MSI/MSI-X
> [    2.626475] 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:1c:25:7e:69:03
> [    2.626549] 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
> [    2.626646] 0000:00:19.0: eth0: MAC: 5, PHY: 6, PBA No: 1008ff-0ff
> [    2.626768] netconsole: local port 6665
> [    2.626829] netconsole: local IP 169.254.1.1
> [    2.626890] netconsole: interface eth0
> [    2.626951] netconsole: remote port 6666
> [    2.627012] netconsole: remote IP 169.254.192.6
> [    2.627075] netconsole: remote ethernet address ff:ff:ff:ff:ff:ff
> [    2.627141] netconsole: device eth0 not up yet, forcing it
> [    2.764254] e1000e 0000:00:19.0: irq 2298 for MSI/MSI-X
> [    2.820115] e1000e 0000:00:19.0: irq 2298 for MSI/MSI-X
> [    6.825008] netconsole: timeout waiting for carrier
> [    6.825306] ------------[ cut here ]------------
> [    6.825371] WARNING: at drivers/net/e1000e/ich8lan.c:408 e1000_acquire_swflag_ich8lan+0x43/0x100()
> [    6.825450] e1000e mutex contention. Owned by pid 10
> [    6.826098] Modules linked in:
> [    6.826204] Pid: 9, comm: events/0 Not tainted 2.6.28 #23
> [    6.826270] Call Trace:
> [    6.826333]  [<ffffffff8024c557>] warn_slowpath+0xb7/0xf0
> [    6.826407]  [<ffffffff8023e07a>] ? enqueue_entity+0x11a/0x2a0
> [    6.826472]  [<ffffffff80239bf8>] ? update_curr+0xe8/0x170
> [    6.826534]  [<ffffffff8023c45b>] ? dequeue_entity+0x1b/0x240
> [    6.826600]  [<ffffffff802439bb>] ? dequeue_task_fair+0x8b/0x90
> [    6.826668]  [<ffffffff804338d3>] e1000_acquire_swflag_ich8lan+0x43/0x100
> [    6.826737]  [<ffffffff8043eb60>] ? e1000e_downshift_workaround+0x0/0x20
> [    6.826800]  [<ffffffff8043890b>] e1000e_read_kmrn_reg+0x2b/0x90
> [    6.826866]  [<ffffffff8043eb60>] ? e1000e_downshift_workaround+0x0/0x20
> [    6.826931]  [<ffffffff80433e47>] e1000e_gig_downshift_workaround_ich8lan+0x37/0x80
> [    6.827009]  [<ffffffff8043eb70>] e1000e_downshift_workaround+0x10/0x20
> [    6.827076]  [<ffffffff8025f75a>] run_workqueue+0xba/0x190
> [    6.827140]  [<ffffffff8025fa37>] worker_thread+0xa7/0x120
> [    6.827204]  [<ffffffff80263d40>] ? autoremove_wake_function+0x0/0x40
> [    6.827270]  [<ffffffff8025f990>] ? worker_thread+0x0/0x120
> [    6.827337]  [<ffffffff80263909>] kthread+0x49/0x90
> [    6.827399]  [<ffffffff802148a9>] child_rip+0xa/0x11
> [    6.827462]  [<ffffffff802638c0>] ? kthread+0x0/0x90
> [    6.827529]  [<ffffffff8021489f>] ? child_rip+0x0/0x11
> [    6.827596] ---[ end trace 89376d7b2f9fa5ab ]---
> [    6.837032] console [netcon0] enabled
> [    6.877259] netconsole: network logging started
> [    6.877454] PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
> [    6.887708] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    6.887774] serio: i8042 AUX port at 0x60,0x64 irq 12
> [    6.888023] mice: PS/2 mouse device common for all mice
> [    6.888177] rtc_cmos 00:07: RTC can wake from S4
> [    6.888304] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
> [    6.888402] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
> [    6.888507] cpuidle: using governor ladder
> [    6.888573] cpuidle: using governor menu
> [    6.888931] TCP cubic registered
> [    6.889177] registered taskstats version 1
> [    6.889372]   Magic number: 9:225:300
> [    6.889598] rtc_cmos 00:07: setting system clock to 2009-01-16 22:17:31 UTC (1232144251)
> [    6.889674] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
> [    6.889738] EDD information not available.
> [    6.889846] Freeing unused kernel memory: 552k freed
> [    6.890112] Write protecting the kernel read-only data: 4444k
> [    6.894435] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
> [    6.992505] fuse init (API version 7.10)
> [    7.002374] ACPI: SSDT BF6E1B32, 02C4 (r1  PmRef  Cpu0Ist      100 INTL 20050513)
> [    7.003176] ACPI: SSDT BF6E1E7B, 085E (r1  PmRef  Cpu0Cst      100 INTL 20050513)
> [    7.006639] Monitor-Mwait will be used to enter C-1 state
> [    7.006697] Monitor-Mwait will be used to enter C-2 state
> [    7.006760] Monitor-Mwait will be used to enter C-3 state
> [    7.007073] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
> [    7.007401] processor ACPI_CPU:00: registered as cooling_device0
> [    7.007471] ACPI: Processor [CPU0] (supports 8 throttling states)
> [    7.007963] ACPI: SSDT BF6E1A6A, 00C8 (r1  PmRef  Cpu1Ist      100 INTL 20050513)
> [    7.008631] ACPI: SSDT BF6E1DF6, 0085 (r1  PmRef  Cpu1Cst      100 INTL 20050513)
> [    7.010826] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
> [    7.011101] processor ACPI_CPU:01: registered as cooling_device1
> [    7.011162] ACPI: Processor [CPU1] (supports 8 throttling states)
> [    7.015182] thermal LNXTHERM:01: registered as thermal_zone0
> [    7.018428] ACPI: Thermal Zone [THM0] (47 C)
> [    7.019595] thermal LNXTHERM:02: registered as thermal_zone1
> [    7.020984] ACPI: Thermal Zone [THM1] (45 C)
> [    7.174894] usbcore: registered new interface driver usbfs
> [    7.174995] usbcore: registered new interface driver hub
> [    7.175226] usbcore: registered new device driver usb
> [    7.177092] uhci_hcd: USB Universal Host Controller Interface driver
> [    7.177206] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
> [    7.177285] uhci_hcd 0000:00:1a.0: setting latency timer to 64
> [    7.177365] uhci_hcd 0000:00:1a.0: UHCI Host Controller
> [    7.177490] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
> [    7.177651] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001860
> [    7.177913] usb usb1: configuration #1 chosen from 1 choice
> [    7.178017] hub 1-0:1.0: USB hub found
> [    7.178085] hub 1-0:1.0: 2 ports detected
> [    7.178804] uhci_hcd 0000:00:1a.1: power state changed by ACPI to D0
> [    7.178868] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
> [    7.178944] uhci_hcd 0000:00:1a.1: setting latency timer to 64
> [    7.179012] uhci_hcd 0000:00:1a.1: UHCI Host Controller
> [    7.179104] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
> [    7.179215] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001880
> [    7.179358] usb usb2: configuration #1 chosen from 1 choice
> [    7.179444] hub 2-0:1.0: USB hub found
> [    7.179494] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    7.179496] Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
> [    7.179674] hub 2-0:1.0: 2 ports detected
> [    7.180621] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
> [    7.180685] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
> [    7.180810] ehci_hcd 0000:00:1a.7: setting latency timer to 64
> [    7.180886] ehci_hcd 0000:00:1a.7: EHCI Host Controller
> [    7.180983] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 3
> [    7.184994] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
> [    7.185084] ehci_hcd 0000:00:1a.7: irq 22, io mem 0xfe226c00
> [    7.204069] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
> [    7.204267] usb usb3: configuration #1 chosen from 1 choice
> [    7.204358] hub 3-0:1.0: USB hub found
> [    7.204426] hub 3-0:1.0: 4 ports detected
> [    7.205003] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
> [    7.205079] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    7.205158] uhci_hcd 0000:00:1d.0: setting latency timer to 64
> [    7.205228] uhci_hcd 0000:00:1d.0: UHCI Host Controller
> [    7.205315] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 4
> [    7.205451] uhci_hcd 0000:00:1d.0: irq 16, io base 0x000018a0
> [    7.205611] usb usb4: configuration #1 chosen from 1 choice
> [    7.205704] hub 4-0:1.0: USB hub found
> [    7.205777] hub 4-0:1.0: 2 ports detected
> [    7.206612] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
> [    7.206676] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
> [    7.206767] ehci_hcd 0000:00:1d.7: setting latency timer to 64
> [    7.206837] ehci_hcd 0000:00:1d.7: EHCI Host Controller
> [    7.206925] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
> [    7.210941] ehci_hcd 0000:00:1d.7: debug port 1
> [    7.211047] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
> [    7.211161] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xfe227000
> [    7.221699] SCSI subsystem initialized
> [    7.228071] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
> [    7.228284] usb usb5: configuration #1 chosen from 1 choice
> [    7.228373] hub 5-0:1.0: USB hub found
> [    7.228445] hub 5-0:1.0: 6 ports detected
> [    7.228666] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
> [    7.229354] uhci_hcd 0000:00:1d.1: setting latency timer to 64
> [    7.229423] uhci_hcd 0000:00:1d.1: UHCI Host Controller
> [    7.229511] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
> [    7.229633] uhci_hcd 0000:00:1d.1: irq 17, io base 0x000018c0
> [    7.229776] usb usb6: configuration #1 chosen from 1 choice
> [    7.229861] hub 6-0:1.0: USB hub found
> [    7.229926] hub 6-0:1.0: 2 ports detected
> [    7.230927] uhci_hcd 0000:00:1d.2: power state changed by ACPI to D0
> [    7.230989] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> [    7.231064] uhci_hcd 0000:00:1d.2: setting latency timer to 64
> [    7.231131] uhci_hcd 0000:00:1d.2: UHCI Host Controller
> [    7.231215] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
> [    7.231330] uhci_hcd 0000:00:1d.2: irq 18, io base 0x000018e0
> [    7.231482] usb usb7: configuration #1 chosen from 1 choice
> [    7.231565] hub 7-0:1.0: USB hub found
> [    7.231635] hub 7-0:1.0: 2 ports detected
> [    7.254639] ohci1394 0000:15:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
> [    7.254723] ohci1394 0000:15:00.1: setting latency timer to 64
> [    7.307560] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[17]  MMIO=[f8301000-f83017ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
> [    7.311701] libata version 3.00 loaded.
> [    7.314900] ahci 0000:00:1f.2: version 3.0
> [    7.314993] ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
> [    7.315171] ahci 0000:00:1f.2: irq 2297 for MSI/MSI-X
> [    7.315322] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 1.5 Gbps 0x1 impl SATA mode
> [    7.315401] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part 
> [    7.315494] ahci 0000:00:1f.2: setting latency timer to 64
> [    7.315716] scsi0 : ahci
> [    7.315857] scsi1 : ahci
> [    7.315968] scsi2 : ahci
> [    7.316097] ata1: SATA max UDMA/133 abar m2048@0xfe226000 port 0xfe226100 irq 2297
> [    7.316162] ata2: DUMMY
> [    7.316228] ata3: DUMMY
> [    7.633061] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [    7.633823] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
> [    7.633884] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
> [    7.634009] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
> [    7.634075] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
> [    7.683823] ata1.00: ATA-8: WDC WD1200BEVS-08UST0, 02.01A02, max UDMA/133
> [    7.683885] ata1.00: 234441648 sectors, multi 16: LBA48 NCQ (depth 31/32)
> [    7.687900] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
> [    7.687975] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
> [    7.688215] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
> [    7.688269] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
> [    7.689995] ata1.00: configured for UDMA/133
> [    7.710014] ata1.00: configured for UDMA/133
> [    7.710081] ata1: EH complete
> [    7.710244] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1200BEVS-0 02.0 PQ: 0 ANSI: 5
> [    7.710525] pata_acpi 0000:00:1f.1: PCI INT C -> GSI 16 (level, low) -> IRQ 16
> [    7.710631] pata_acpi 0000:00:1f.1: setting latency timer to 64
> [    7.710712] pata_acpi 0000:00:1f.1: PCI INT C disabled
> [    7.714464] ata_piix 0000:00:1f.1: version 2.12
> [    7.714543] ata_piix 0000:00:1f.1: PCI INT C -> GSI 16 (level, low) -> IRQ 16
> [    7.714638] ata_piix 0000:00:1f.1: setting latency timer to 64
> [    7.716071] scsi3 : ata_piix
> [    7.716180] scsi4 : ata_piix
> [    7.717051] ata4: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1c00 irq 14
> [    7.717111] ata5: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1c08 irq 15
> [    7.726576] scsi 0:0:0:0: Attached scsi generic sg0 type 0
> [    7.736237] Driver 'sd' needs updating - please use bus_type methods
> [    7.736391] sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors: (120 GB/111 GiB)
> [    7.736472] sd 0:0:0:0: [sda] Write Protect is off
> [    7.736531] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    7.736614] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    7.736741] sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors: (120 GB/111 GiB)
> [    7.736831] sd 0:0:0:0: [sda] Write Protect is off
> [    7.736891] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    7.736966] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    7.737060]  sda: sda1 sda2 < sda5 >
> [    7.774340] sd 0:0:0:0: [sda] Attached SCSI disk
> [    7.881546] ata4.00: ATAPI: MATSHITADVD-RAM UJ-862, RB01, max UDMA/33
> [    7.897089] ata4.00: configured for UDMA/33
> [    7.897638] ata5: port disabled. ignoring.
> [    7.899868] scsi 3:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ-862   RB01 PQ: 0 ANSI: 5
> [    7.900111] scsi 3:0:0:0: Attached scsi generic sg1 type 5
> [    7.911424] Driver 'sr' needs updating - please use bus_type methods
> [    7.916395] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
> [    7.916465] Uniform CD-ROM driver Revision: 3.20
> [    7.916612] sr 3:0:0:0: Attached scsi CD-ROM sr0
> [    8.001023] Clocksource tsc unstable (delta = -181338810 ns)
> [    8.007330] PM: Starting manual resume from disk
> [    8.007394] PM: Resume from partition 8:5
> [    8.007442] PM: Checking hibernation image.
> [    8.007698] PM: Resume from disk failed.
> [    8.066750] kjournald starting.  Commit interval 5 seconds
> [    8.066837] EXT3-fs: mounted filesystem with ordered data mode.
> [    8.429000] 0000:00:19.0: eth0: Link is Up 100 Mbps Half Duplex, Flow Control: None
> [    8.429136] 0000:00:19.0: eth0: 10/100 speed: disabling TSO
> [    8.429429] 0000:00:19.0: eth0: Detected Tx Unit Hang:
> [    8.429430]   TDH                  <50>
> [    8.429430]   TDT                  <ec>
> [    8.429431]   next_to_use          <ec>
> [    8.429431]   next_to_clean        <41>
> [    8.429432] buffer_info[next_to_clean]:
> [    8.429432]   time_stamp           <fffee1b5>
> [    8.429433]   next_to_watch        <41>
> [    8.429433]   jiffies              <fffee343>
> [    8.429434]   next_to_watch.status <1>
> [    8.584407] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00016c00005ec9db]
> [   14.544688] udevd version 124 started
> [   15.042146] agpgart-intel 0000:00:00.0: Intel 965GM Chipset
> [   15.043252] agpgart-intel 0000:00:00.0: detected 7676K stolen memory
> [   15.046334] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
> [   15.067753] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
> [   15.077267] ACPI: Power Button (FF) [PWRF]
> [   15.077420] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input2
> [   15.077603] iTCO_vendor_support: vendor-support=0
> [   15.078022] ACPI: Lid Switch [LID]
> [   15.078141] input: Sleep Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input3
> [   15.089039] ACPI: Sleep Button (CM) [SLPB]
> [   15.122400] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.04
> [   15.122618] iTCO_wdt: Found a ICH8M-E TCO device (Version=2, TCOBASE=0x1060)
> [   15.122829] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
> [   15.144551] ACPI: WMI: Mapper loaded
> [   15.194329] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> [   15.239745] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
> [   15.283042] ACPI: AC Adapter [AC] (on-line)
> [   15.460639] yenta_cardbus 0000:15:00.0: CardBus bridge found [17aa:20c6]
> [   15.589919] acpi device:03: registered as cooling_device2
> [   15.590274] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:02/input/input4
> [   15.591450] yenta_cardbus 0000:15:00.0: ISA IRQ mask 0x0cb8, PCI irq 16
> [   15.591522] yenta_cardbus 0000:15:00.0: Socket status: 30000006
> [   15.591603] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge I/O window: 0x7000 - 0xafff
> [   15.591686] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge Memory window: 0xf8300000 - 0xfbffffff
> [   15.591765] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge Memory window: 0xf4000000 - 0xf7ffffff
> [   15.594891] input: PC Speaker as /devices/platform/pcspkr/input/input5
> [   15.597050] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
> [   15.620613] Non-volatile memory driver v1.2
> [   15.760712] ACPI: Battery Slot [BAT0] (battery present)
> [   15.810759] cfg80211: Using static regulatory domain info
> [   15.810837] cfg80211: Regulatory domain: US
> [   15.810898]  (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> [   15.810964]  (2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
> [   15.811026]  (5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
> [   15.811093]  (5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
> [   15.811161]  (5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
> [   15.811220]  (5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
> [   15.811281]  (5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
> [   15.811346] cfg80211: Calling CRDA for country: US
> [   15.968173] lib80211: common routines for IEEE802.11 drivers
> [   15.968277] lib80211_crypt: registered algorithm 'NULL'
> [   16.285122] thinkpad_acpi: ThinkPad ACPI Extras v0.21
> [   16.285201] thinkpad_acpi: http://ibm-acpi.sf.net/
> [   16.285270] thinkpad_acpi: ThinkPad BIOS 7LETB2WW (2.12 ), EC 7KHT24WW-1.08
> [   16.285340] thinkpad_acpi: Lenovo ThinkPad T61, model 7658CTO
> [   16.288253] thinkpad_acpi: ACPI backlight control delay disabled
> [   16.289112] thinkpad_acpi: radio switch found; radios are enabled
> [   16.289280] thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
> [   16.289363] thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
> [   16.296261] Registered led device: tpacpi::thinklight
> [   16.296366] Registered led device: tpacpi::power
> [   16.296457] Registered led device: tpacpi:orange:batt
> [   16.296544] Registered led device: tpacpi:green:batt
> [   16.296645] Registered led device: tpacpi::dock_active
> [   16.296737] Registered led device: tpacpi::bay_active
> [   16.296832] Registered led device: tpacpi::dock_batt
> [   16.296926] Registered led device: tpacpi::unknown_led
> [   16.297037] Registered led device: tpacpi::standby
> [   16.299392] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one.
> [   16.299781] input: ThinkPad Extra Buttons as /devices/virtual/input/input6
> [   16.696947] Synaptics Touchpad, model: 1, fw: 6.2, id: 0x81a0b1, caps: 0xa04791/0x300000
> [   16.697047] serio: Synaptics pass-through port at isa0060/serio1/input0
> [   16.741090] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input7
> [   16.839332] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, 1.2.26kds
> [   16.839421] iwl3945: Copyright(c) 2003-2008 Intel Corporation
> [   16.839620] iwl3945 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [   16.839688] iwl3945 0000:03:00.0: setting latency timer to 64
> [   16.839990] ieee80211 phy0: U iwl3945_pci_probe pci_resource_len = 0x00001000
> [   16.840067] ieee80211 phy0: U iwl3945_pci_probe pci_resource_base = ffffc200050b6000
> [   16.840205] ieee80211 phy0: U iwl3945_power_init_handle Initialize power 
> [   16.840267] ieee80211 phy0: U iwl3945_power_init_handle adjust power command flags
> [   16.899076] ieee80211 phy0: U iwl3945_pci_probe MAC address: 00:1f:3c:20:a1:6e
> [   16.899153] ieee80211 phy0: U iwl3945_init_channel_map Initializing regulatory info from EEPROM
> [   16.899219] ieee80211 phy0: U iwl3945_init_channel_map Parsing data for 56 channels.
> [   16.901659] ieee80211 phy0: U iwl3945_init_channel_map Ch. 1 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
> [   16.901734] ieee80211 phy0: U iwl3945_init_channel_map Ch. 2 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
> [   16.901811] ieee80211 phy0: U iwl3945_init_channel_map Ch. 3 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
> [   16.901886] ieee80211 phy0: U iwl3945_init_channel_map Ch. 4 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
> [   16.901961] ieee80211 phy0: U iwl3945_init_channel_map Ch. 5 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
> [   16.902029] ieee80211 phy0: U iwl3945_init_channel_map Ch. 6 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
> [   16.902097] ieee80211 phy0: U iwl3945_init_channel_map Ch. 7 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
> [   16.902166] ieee80211 phy0: U iwl3945_init_channel_map Ch. 8 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
> [   16.902254] ieee80211 phy0: U iwl3945_init_channel_map Ch. 9 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
> [   16.902323] ieee80211 phy0: U iwl3945_init_channel_map Ch. 10 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
> [   16.902392] ieee80211 phy0: U iwl3945_init_channel_map Ch. 11 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 14dBm): Ad-Hoc supported
> [   16.902465] ieee80211 phy0: U iwl3945_init_channel_map Ch. 12 Flags 0 [2.4GHz] - No traffic
> [   16.902534] ieee80211 phy0: U iwl3945_init_channel_map Ch. 13 Flags 0 [2.4GHz] - No traffic
> [   16.902598] ieee80211 phy0: U iwl3945_init_channel_map Ch. 14 Flags 0 [2.4GHz] - No traffic
> [   16.902662] ieee80211 phy0: U iwl3945_init_channel_map Ch. 183 Flags 0 [5.2GHz] - No traffic
> [   16.902733] ieee80211 phy0: U iwl3945_init_channel_map Ch. 184 Flags 0 [5.2GHz] - No traffic
> [   16.902809] ieee80211 phy0: U iwl3945_init_channel_map Ch. 185 Flags 0 [5.2GHz] - No traffic
> [   16.902874] ieee80211 phy0: U iwl3945_init_channel_map Ch. 187 Flags 0 [5.2GHz] - No traffic
> [   16.902938] ieee80211 phy0: U iwl3945_init_channel_map Ch. 188 Flags 0 [5.2GHz] - No traffic
> [   16.903009] ieee80211 phy0: U iwl3945_init_channel_map Ch. 189 Flags 0 [5.2GHz] - No traffic
> [   16.903077] ieee80211 phy0: U iwl3945_init_channel_map Ch. 192 Flags 0 [5.2GHz] - No traffic
> [   16.903141] ieee80211 phy0: U iwl3945_init_channel_map Ch. 196 Flags 0 [5.2GHz] - No traffic
> [   16.903206] ieee80211 phy0: U iwl3945_init_channel_map Ch. 7 Flags 0 [5.2GHz] - No traffic
> [   16.903276] ieee80211 phy0: U iwl3945_init_channel_map Ch. 8 Flags 0 [5.2GHz] - No traffic
> [   16.903353] ieee80211 phy0: U iwl3945_init_channel_map Ch. 11 Flags 0 [5.2GHz] - No traffic
> [   16.903418] ieee80211 phy0: U iwl3945_init_channel_map Ch. 12 Flags 0 [5.2GHz] - No traffic
> [   16.903482] ieee80211 phy0: U iwl3945_init_channel_map Ch. 16 Flags 0 [5.2GHz] - No traffic
> [   16.903553] ieee80211 phy0: U iwl3945_init_channel_map Ch. 34 Flags 0 [5.2GHz] - No traffic
> [   16.903622] ieee80211 phy0: U iwl3945_init_channel_map Ch. 36 [5.2GHz] VALID WIDE DFS (0xa1 14dBm): Ad-Hoc not supported
> [   16.903689] ieee80211 phy0: U iwl3945_init_channel_map Ch. 38 Flags 0 [5.2GHz] - No traffic
> [   16.903753] ieee80211 phy0: U iwl3945_init_channel_map Ch. 40 [5.2GHz] VALID WIDE DFS (0xa1 14dBm): Ad-Hoc not supported
> [   16.903827] ieee80211 phy0: U iwl3945_init_channel_map Ch. 42 Flags 0 [5.2GHz] - No traffic
> [   16.903905] ieee80211 phy0: U iwl3945_init_channel_map Ch. 44 [5.2GHz] VALID WIDE DFS (0xa1 14dBm): Ad-Hoc not supported
> [   16.903972] ieee80211 phy0: U iwl3945_init_channel_map Ch. 46 Flags 0 [5.2GHz] - No traffic
> [   16.904045] ieee80211 phy0: U iwl3945_init_channel_map Ch. 48 [5.2GHz] VALID WIDE DFS (0xa1 14dBm): Ad-Hoc not supported
> [   16.904144] ieee80211 phy0: U iwl3945_init_channel_map Ch. 52 [5.2GHz] VALID RADAR WIDE DFS (0xb1 14dBm): Ad-Hoc not supported
> [   16.904217] ieee80211 phy0: U iwl3945_init_channel_map Ch. 56 [5.2GHz] VALID RADAR WIDE DFS (0xb1 14dBm): Ad-Hoc not supported
> [   16.904292] ieee80211 phy0: U iwl3945_init_channel_map Ch. 60 [5.2GHz] VALID RADAR WIDE DFS (0xb1 14dBm): Ad-Hoc not supported
> [   16.904360] ieee80211 phy0: U iwl3945_init_channel_map Ch. 64 [5.2GHz] VALID RADAR WIDE DFS (0xb1 14dBm): Ad-Hoc not supported
> [   16.904432] ieee80211 phy0: U iwl3945_init_channel_map Ch. 100 Flags 0 [5.2GHz] - No traffic
> [   16.904497] ieee80211 phy0: U iwl3945_init_channel_map Ch. 104 Flags 0 [5.2GHz] - No traffic
> [   16.904561] ieee80211 phy0: U iwl3945_init_channel_map Ch. 108 Flags 0 [5.2GHz] - No traffic
> [   16.904641] ieee80211 phy0: U iwl3945_init_channel_map Ch. 112 Flags 0 [5.2GHz] - No traffic
> [   16.904715] ieee80211 phy0: U iwl3945_init_channel_map Ch. 116 Flags 0 [5.2GHz] - No traffic
> [   16.904783] ieee80211 phy0: U iwl3945_init_channel_map Ch. 120 Flags 0 [5.2GHz] - No traffic
> [   16.904849] ieee80211 phy0: U iwl3945_init_channel_map Ch. 124 Flags 0 [5.2GHz] - No traffic
> [   16.904921] ieee80211 phy0: U iwl3945_init_channel_map Ch. 128 Flags 0 [5.2GHz] - No traffic
> [   16.905005] ieee80211 phy0: U iwl3945_init_channel_map Ch. 132 Flags 0 [5.2GHz] - No traffic
> [   16.905091] ieee80211 phy0: U iwl3945_init_channel_map Ch. 136 Flags 0 [5.2GHz] - No traffic
> [   16.905155] ieee80211 phy0: U iwl3945_init_channel_map Ch. 140 Flags 0 [5.2GHz] - No traffic
> [   16.905220] ieee80211 phy0: U iwl3945_init_channel_map Ch. 145 Flags 0 [5.2GHz] - No traffic
> [   16.905289] ieee80211 phy0: U iwl3945_init_channel_map Ch. 149 [5.2GHz] VALID WIDE (0x21 16dBm): Ad-Hoc not supported
> [   16.905357] ieee80211 phy0: U iwl3945_init_channel_map Ch. 153 [5.2GHz] VALID WIDE (0x21 16dBm): Ad-Hoc not supported
> [   16.905424] ieee80211 phy0: U iwl3945_init_channel_map Ch. 157 [5.2GHz] VALID WIDE (0x21 16dBm): Ad-Hoc not supported
> [   16.905500] ieee80211 phy0: U iwl3945_init_channel_map Ch. 161 [5.2GHz] VALID WIDE (0x21 16dBm): Ad-Hoc not supported
> [   16.905576] ieee80211 phy0: U iwl3945_init_channel_map Ch. 165 [5.2GHz] VALID WIDE (0x21 16dBm): Ad-Hoc not supported
> [   16.905650] ieee80211 phy0: U iwl3945_hw_reg_txpower_get_temperature Temperature: 260
> [   16.905719] ieee80211 phy0: U iwl3945_hw_reg_init_channel_groups Initializing factory calib info from EEPROM
> [   16.905790] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl 1 mapped to grp 0
> [   16.905854] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta index for channel 1: -21 [260]
> [   16.905919] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl 2 mapped to grp 0
> [   16.905989] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta index for channel 2: -21 [260]
> [   16.906067] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl 3 mapped to grp 0
> [   16.906130] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta index for channel 3: -21 [260]
> [   16.906196] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl 4 mapped to grp 0
> [   16.906265] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta index for channel 4: -21 [260]
> [   16.906335] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl 5 mapped to grp 0
> [   16.906398] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta index for channel 5: -21 [260]
> [   16.906464] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl 6 mapped to grp 0
> [   16.906533] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta index for channel 6: -21 [260]
> [   16.906611] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl 7 mapped to grp 0
> [   16.906675] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta index for channel 7: -21 [260]
> [   16.906740] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl 8 mapped to grp 0
> [   16.907450] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta index for channel 8: -21 [260]
> [   16.907534] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl 9 mapped to grp 0
> [   16.907611] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta index for channel 9: -21 [260]
> [   16.907680] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl 10 mapped to grp 0
> [   16.907746] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta index for channel 10: -21 [260]
> [   16.907813] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl 11 mapped to grp 0
> [   16.907886] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta index for channel 11: -21 [260]
> [   16.907957] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl 36 mapped to grp 1
> [   16.908042] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta index for channel 36: -21 [260]
> [   16.908113] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl 40 mapped to grp 1
> [   16.908177] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta index for channel 40: -21 [260]
> [   16.908253] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl 44 mapped to grp 1
> [   16.908316] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta index for channel 44: -21 [260]
> [   16.908382] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl 48 mapped to grp 2
> [   16.908466] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta index for channel 48: -21 [260]
> [   16.908537] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl 52 mapped to grp 2
> [   16.908601] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta index for channel 52: -21 [260]
> [   16.908672] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl 56 mapped to grp 2
> [   16.908756] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta index for channel 56: -21 [260]
> [   16.908822] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl 60 mapped to grp 2
> [   16.908886] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta index for channel 60: -21 [260]
> [   16.908957] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl 64 mapped to grp 2
> [   16.909025] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta index for channel 64: -21 [260]
> [   16.909103] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl 149 mapped to grp 4
> [   16.909166] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta index for channel 149: -21 [260]
> [   16.909238] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl 153 mapped to grp 4
> [   16.909314] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta index for channel 153: -21 [260]
> [   16.909380] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl 157 mapped to grp 4
> [   16.909445] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta index for channel 157: -21 [260]
> [   16.909516] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl 161 mapped to grp 4
> [   16.909584] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta index for channel 161: -21 [260]
> [   16.909650] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl 165 mapped to grp 4
> [   16.909713] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta index for channel 165: -21 [260]
> [   16.909788] ieee80211 phy0: U iwl3945_init_geos Channel 1 Freq=2412[2.4GHz] valid flag=00
> [   16.909864] ieee80211 phy0: U iwl3945_init_geos Channel 2 Freq=2417[2.4GHz] valid flag=00
> [   16.909929] ieee80211 phy0: U iwl3945_init_geos Channel 3 Freq=2422[2.4GHz] valid flag=00
> [   16.909994] ieee80211 phy0: U iwl3945_init_geos Channel 4 Freq=2427[2.4GHz] valid flag=00
> [   16.910063] ieee80211 phy0: U iwl3945_init_geos Channel 5 Freq=2432[2.4GHz] valid flag=00
> [   16.910131] ieee80211 phy0: U iwl3945_init_geos Channel 6 Freq=2437[2.4GHz] valid flag=00
> [   16.910196] ieee80211 phy0: U iwl3945_init_geos Channel 7 Freq=2442[2.4GHz] valid flag=00
> [   16.910260] ieee80211 phy0: U iwl3945_init_geos Channel 8 Freq=2447[2.4GHz] valid flag=00
> [   16.910329] ieee80211 phy0: U iwl3945_init_geos Channel 9 Freq=2452[2.4GHz] valid flag=00
> [   16.910407] ieee80211 phy0: U iwl3945_init_geos Channel 10 Freq=2457[2.4GHz] valid flag=00
> [   16.910472] ieee80211 phy0: U iwl3945_init_geos Channel 11 Freq=2462[2.4GHz] valid flag=00
> [   16.910537] ieee80211 phy0: U iwl3945_init_geos Channel 36 Freq=5180[5.2GHz] valid flag=06
> [   16.910606] ieee80211 phy0: U iwl3945_init_geos Channel 40 Freq=5200[5.2GHz] valid flag=06
> [   16.910698] ieee80211 phy0: U iwl3945_init_geos Channel 44 Freq=5220[5.2GHz] valid flag=06
> [   16.910777] ieee80211 phy0: U iwl3945_init_geos Channel 48 Freq=5240[5.2GHz] valid flag=06
> [   16.910844] ieee80211 phy0: U iwl3945_init_geos Channel 52 Freq=5260[5.2GHz] valid flag=0E
> [   16.910921] ieee80211 phy0: U iwl3945_init_geos Channel 56 Freq=5280[5.2GHz] valid flag=0E
> [   16.910986] ieee80211 phy0: U iwl3945_init_geos Channel 60 Freq=5300[5.2GHz] valid flag=0E
> [   16.911056] ieee80211 phy0: U iwl3945_init_geos Channel 64 Freq=5320[5.2GHz] valid flag=0E
> [   16.911121] ieee80211 phy0: U iwl3945_init_geos Channel 149 Freq=5745[5.2GHz] valid flag=06
> [   16.911206] ieee80211 phy0: U iwl3945_init_geos Channel 153 Freq=5765[5.2GHz] valid flag=06
> [   16.911270] ieee80211 phy0: U iwl3945_init_geos Channel 157 Freq=5785[5.2GHz] valid flag=06
> [   16.911335] ieee80211 phy0: U iwl3945_init_geos Channel 161 Freq=5805[5.2GHz] valid flag=06
> [   16.911405] ieee80211 phy0: U iwl3945_init_geos Channel 165 Freq=5825[5.2GHz] valid flag=06
> [   16.911474] iwl3945 0000:03:00.0: Tunable channels: 11 802.11bg, 13 802.11a channels
> [   16.911537] iwl3945 0000:03:00.0: Detected Intel Wireless WiFi Link 3945ABG
> [   16.911605] ieee80211 phy0: U iwl3945_set_rxon_channel Staging channel set to 6 [0]
> [   16.911959] iwl3945 0000:03:00.0: PCI INT A disabled
> [   16.912329] phy0: Selected rate control algorithm 'iwl-3945-rs'
> [   17.523852] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
> [   17.523926] hda_intel: probe_mask set to 0x1 for device 17aa:20ac
> [   17.524188] HDA Intel 0000:00:1b.0: setting latency timer to 64
> [   27.963061] ieee80211 phy0: U iwl3945_mac_start enter
> [   28.014693] ieee80211 phy0: U iwl3945_read_ucode Got firmware 'iwlwifi-3945-2.ucode' file (149816 bytes) from disk
> [   28.014718] ieee80211 phy0: U iwl3945_read_ucode f/w package hdr ucode version raw = 0xf1c0208
> [   28.014725] ieee80211 phy0: U iwl3945_read_ucode f/w package hdr runtime inst size = 80684
> [   28.014733] ieee80211 phy0: U iwl3945_read_ucode f/w package hdr runtime data size = 32768
> [   28.014739] ieee80211 phy0: U iwl3945_read_ucode f/w package hdr init inst size = 2672
> [   28.014747] ieee80211 phy0: U iwl3945_read_ucode f/w package hdr init data size = 32768
> [   28.014755] ieee80211 phy0: U iwl3945_read_ucode f/w package hdr boot inst size = 900
> [   28.014900] ieee80211 phy0: U iwl3945_read_ucode Copying (but not loading) uCode instr len 80684
> [   28.014945] ieee80211 phy0: U iwl3945_read_ucode uCode instr buf vaddr = 0xffff8800bb880000, paddr = 0xbb880000
> [   28.014954] ieee80211 phy0: U iwl3945_read_ucode Copying (but not loading) uCode data len 32768
> [   28.015007] ieee80211 phy0: U iwl3945_read_ucode Copying (but not loading) init instr len 2672
> [   28.015016] ieee80211 phy0: U iwl3945_read_ucode Copying (but not loading) init data len 32768
> [   28.015047] ieee80211 phy0: U iwl3945_read_ucode Copying (but not loading) boot instr len 900
> [   28.015079] ieee80211 phy0: U iwl3945_power_init_handle Initialize power 
> [   28.015095] ieee80211 phy0: U iwl3945_power_init_handle adjust power command flags
> [   28.015213] ieee80211 phy0: U iwl3945_hw_nic_init HW Revision ID = 0x2
> [   28.015265] ieee80211 phy0: U iwl3945_nic_config 3945 RADIO-MM type
> [   28.015278] ieee80211 phy0: U iwl3945_nic_config SKU OP mode is basic
> [   28.015284] ieee80211 phy0: U iwl3945_nic_config 3945ABG revision is 0xF1
> [   28.015298] ieee80211 phy0: U iwl3945_nic_config Card M type B version is 0x3
> [   28.016564] ieee80211 phy0: U iwl3945_load_bsm Begin load bsm
> [   28.017829] ieee80211 phy0: U iwl3945_verify_bsm Begin verify bsm
> [   28.019985] ieee80211 phy0: U iwl3945_verify_bsm BSM bootstrap uCode image OK
> [   28.020065] ieee80211 phy0: U iwl3945_load_bsm BSM write complete, poll 1 iterations
> [   28.020087] ieee80211 phy0: U __iwl3945_up iwl3945 is coming up
> [   28.020096] ieee80211 phy0: U iwl3945_mac_start Start UP work.
> [   28.031580] ieee80211 phy0: I iwl3945_rx_handle r = 1, i = 0, REPLY_ALIVE, 0x01
> [   28.031598] ieee80211 phy0: I iwl3945_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x9
> [   28.031606] ieee80211 phy0: I iwl3945_rx_reply_alive Initialization Alive received.
> [   28.037092] ieee80211 phy0: U iwl3945_verify_inst_sparse ucode inst image size is 900
> [   28.037191] ieee80211 phy0: U iwl3945_verify_inst_sparse ucode inst image size is 2672
> [   28.037484] ieee80211 phy0: U iwl3945_verify_ucode Initialize uCode is good in inst SRAM
> [   28.037491] ieee80211 phy0: U iwl3945_init_alive_start Initialization Alive received.
> [   28.037541] ieee80211 phy0: U iwl3945_set_ucode_ptrs Runtime uCode pointers are set.
> [   28.041918] ieee80211 phy0: I iwl3945_rx_handle r = 2, i = 1, REPLY_ALIVE, 0x01
> [   28.041928] ieee80211 phy0: I iwl3945_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x0
> [   28.041936] ieee80211 phy0: I iwl3945_rx_reply_alive Runtime Alive received.
> [   28.041984] ieee80211 phy0: I iwl3945_disable_events Selected uCode log events may be disabled
> [   28.041991] ieee80211 phy0: I iwl3945_disable_events   by writing "1"s into disable bitmap
> [   28.041999] ieee80211 phy0: I iwl3945_disable_events   in SRAM at 0x8022c8, size 47 u32s
> [   28.049094] ieee80211 phy0: U iwl3945_alive_start Runtime Alive received.
> [   28.049104] ieee80211 phy0: U iwl3945_verify_inst_sparse ucode inst image size is 900
> [   28.049190] ieee80211 phy0: U iwl3945_verify_inst_sparse ucode inst image size is 2672
> [   28.049274] ieee80211 phy0: U iwl3945_verify_inst_sparse ucode inst image size is 80684
> [   28.056940] ieee80211 phy0: U iwl3945_verify_ucode Runtime uCode is good in inst SRAM
> [   28.056975] ieee80211 phy0: U iwl3945_alive_start RFKILL status: 0x1
> [   28.057015] ieee80211 phy0: U iwl3945_update_power_cmd Flags value = 0x00000009
> [   28.057022] ieee80211 phy0: U iwl3945_update_power_cmd Tx timeout = 102400
> [   28.057029] ieee80211 phy0: U iwl3945_update_power_cmd Rx timeout = 51200
> [   28.057036] ieee80211 phy0: U iwl3945_update_power_cmd Sleep interval vector = { 1 , 1 , 1 , 1 , 1 }
> [   28.057050] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command POWER_TABLE_CMD (#77), seq: 0x0400, 36 bytes at 0[0]:4
> [   28.057167] ieee80211 phy0: I iwl3945_rx_handle r 3 i 2 No handler needed for POWER_TABLE_CMD, 0x77
> [   28.060668] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_BT_CONFIG (#9b), seq: 0x0401, 16 bytes at 1[1]:4
> [   28.060727] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
> [   28.070322] ieee80211 phy0: I iwl3945_rx_handle r 4 i 3 No handler needed for REPLY_BT_CONFIG, 0x9b
> [   28.070387] ieee80211 phy0: U iwl3945_commit_rxon Sending RXON
> [   28.070389] * without RXON_FILTER_ASSOC_MSK
> [   28.070391] * channel = 1
> [   28.070392] * bssid = 00:00:00:00:00:00
> [   28.070414] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x0402, 48 bytes at 2[2]:4
> [   28.070429] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
> [   28.073440] ieee80211 phy0: I iwl3945_rx_handle r 5 i 4 No handler needed for REPLY_RXON, 0x10
> [   28.079619] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 187 dsp  99 rate code 0x0d
> [   28.079631] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 187 dsp  99 rate code 0x0f
> [   28.079639] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 187 dsp  99 rate code 0x05
> [   28.079647] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 187 dsp  99 rate code 0x07
> [   28.079655] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 187 dsp  99 rate code 0x09
> [   28.079664] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 187 dsp  99 rate code 0x0b
> [   28.079672] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 187 dsp  99 rate code 0x01
> [   28.079680] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 187 dsp  99 rate code 0x03
> [   28.079688] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 179 dsp 107 rate code 0x0a
> [   28.079696] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 179 dsp 107 rate code 0x14
> [   28.079704] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 179 dsp 107 rate code 0x37
> [   28.079713] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 179 dsp 107 rate code 0x6e
> [   28.079724] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0403, 56 bytes at 3[3]:4
> [   28.079781] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
> [   28.090317] ieee80211 phy0: I iwl3945_rx_handle r 6 i 5 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
> [   28.099201] ieee80211 phy0: U iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
> [   28.099217] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0404, 68 bytes at 4[4]:4
> [   28.099273] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
> [   28.109863] ieee80211 phy0: I iwl3945_rx_handle r = 7, i = 6, REPLY_ADD_STA, 0x18
> [   28.109904] ieee80211 phy0: U iwl3945_send_add_station REPLY_ADD_STA PASSED
> [   28.109919] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0405, 56 bytes at 5[5]:4
> [   28.109933] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
> [   28.112701] ieee80211 phy0: I iwl3945_rx_handle r 8 i 7 No handler needed for REPLY_RATE_SCALE, 0x47
> [   28.112738] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0406, 56 bytes at 6[6]:4
> [   28.112754] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
> [   28.115486] ieee80211 phy0: I iwl3945_rx_handle r 9 i 8 No handler needed for REPLY_RATE_SCALE, 0x47
> [   28.117777] ieee80211 phy0: U iwl3945_hw_reg_txpower_get_temperature Temperature: 70
> [   28.117788] ieee80211 phy0: U is_temp_calib_needed Getting cooler, delta -190,
> [   28.117795] ieee80211 phy0: U is_temp_calib_needed Timed thermal calib needed
> [   28.117815] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x0d
> [   28.117823] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x0f
> [   28.117831] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x05
> [   28.117839] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x07
> [   28.117848] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x09
> [   28.117856] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x0b
> [   28.117864] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x01
> [   28.117872] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x03
> [   28.117881] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 171 dsp  98 rate code 0x0a
> [   28.117889] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 171 dsp  98 rate code 0x14
> [   28.117897] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 171 dsp  98 rate code 0x37
> [   28.117905] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 171 dsp  98 rate code 0x6e
> [   28.117917] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0407, 56 bytes at 7[7]:4
> [   28.117973] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
> [   28.128494] ieee80211 phy0: I iwl3945_rx_handle r 10 i 9 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
> [   28.129729] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0408, 12 bytes at 8[8]:4
> [   28.129751] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
> [   28.129878] ieee80211 phy0: U iwl3945_alive_start ALIVE processing complete.
> [   28.129895] ieee80211 phy0: U iwl3945_mac_start leave
> [   28.129906] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0409, 12 bytes at 9[9]:4
> [   28.129922] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
> [   28.129938] ieee80211 phy0: U iwl3945_mac_add_interface enter: type 2
> [   28.129947] ieee80211 phy0: U iwl3945_mac_add_interface Set: 00:1f:3c:20:a1:6e
> [   28.129961] ieee80211 phy0: U iwl3945_commit_rxon Sending RXON
> [   28.129963] * without RXON_FILTER_ASSOC_MSK
> [   28.129965] * channel = 1
> [   28.129966] * bssid = 00:00:00:00:00:00
> [   28.129984] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x040A, 48 bytes at 10[10]:4
> [   28.130055] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
> [   28.131408] ieee80211 phy0: I iwl3945_rx_handle r 12 i 10 No handler needed for REPLY_LEDS_CMD, 0x48
> [   28.131432] ieee80211 phy0: I iwl3945_rx_handle r 12 i 11 No handler needed for REPLY_LEDS_CMD, 0x48
> [   28.131612] ieee80211 phy0: I iwl3945_rx_handle r 13 i 12 No handler needed for REPLY_RXON, 0x10
> [   28.131653] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x0d
> [   28.131664] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x0f
> [   28.131673] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x05
> [   28.131681] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x07
> [   28.131689] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x09
> [   28.131698] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x0b
> [   28.131706] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x01
> [   28.131714] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x03
> [   28.131723] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 171 dsp  98 rate code 0x0a
> [   28.131731] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 171 dsp  98 rate code 0x14
> [   28.131740] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 171 dsp  98 rate code 0x37
> [   28.131748] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 171 dsp  98 rate code 0x6e
> [   28.131759] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x040B, 56 bytes at 11[11]:4
> [   28.131775] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
> [   28.134402] ieee80211 phy0: I iwl3945_rx_handle r 14 i 13 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
> [   28.134434] ieee80211 phy0: U iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
> [   28.134446] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x040C, 68 bytes at 12[12]:4
> [   28.134460] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
> [   28.137652] ieee80211 phy0: I iwl3945_rx_handle r = 15, i = 14, REPLY_ADD_STA, 0x18
> [   28.137681] ieee80211 phy0: U iwl3945_send_add_station REPLY_ADD_STA PASSED
> [   28.137699] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x040D, 56 bytes at 13[13]:4
> [   28.137952] ieee80211 phy0: I iwl3945_rx_handle r 16 i 15 No handler needed for REPLY_RATE_SCALE, 0x47
> [   28.137974] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x040E, 56 bytes at 14[14]:4
> [   28.141225] ieee80211 phy0: I iwl3945_rx_handle r 17 i 16 No handler needed for REPLY_RATE_SCALE, 0x47
> [   28.141253] ieee80211 phy0: U iwl3945_mac_add_interface leave
> [   28.141263] ieee80211 phy0: U iwl3945_bss_info_changed changes = 0xE
> [   28.141270] ieee80211 phy0: U iwl3945_bss_info_changed ERP_PREAMBLE 0
> [   28.141276] ieee80211 phy0: U iwl3945_bss_info_changed ERP_CTS 0
> [   28.160049] ieee80211 phy0: I iwl3945_configure_filter Enter: changed: 0x0, total: 0x80000000
> [   28.161950] ieee80211 phy0: U iwl3945_mac_config enter to channel 1
> [   28.161970] ieee80211 phy0: U iwl3945_commit_rxon Sending RXON
> [   28.161972] * without RXON_FILTER_ASSOC_MSK
> [   28.161974] * channel = 1
> [   28.161975] * bssid = 00:00:00:00:00:00
> [   28.161996] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x040F, 48 bytes at 15[15]:4
> [   28.162052] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
> [   28.172727] ieee80211 phy0: I iwl3945_rx_handle r 18 i 17 No handler needed for REPLY_RXON, 0x10
> [   28.172785] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x0d
> [   28.172794] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x0f
> [   28.172802] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x05
> [   28.172810] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x07
> [   28.172818] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x09
> [   28.172826] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x0b
> [   28.172834] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x01
> [   28.172842] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x03
> [   28.172850] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 171 dsp  98 rate code 0x0a
> [   28.172859] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 171 dsp  98 rate code 0x14
> [   28.172868] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 171 dsp  98 rate code 0x37
> [   28.172876] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 171 dsp  98 rate code 0x6e
> [   28.172890] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0410, 56 bytes at 16[16]:4
> [   28.172907] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
> [   28.175538] ieee80211 phy0: I iwl3945_rx_handle r 19 i 18 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
> [   28.177076] ieee80211 phy0: U iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
> [   28.177094] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0411, 68 bytes at 17[17]:4
> [   28.177109] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
> [   28.178821] ieee80211 phy0: I iwl3945_rx_handle r = 20, i = 19, REPLY_ADD_STA, 0x18
> [   28.184271] ieee80211 phy0: U iwl3945_send_add_station REPLY_ADD_STA PASSED
> [   28.184289] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0412, 56 bytes at 18[18]:4
> [   28.184346] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
> [   28.194957] ieee80211 phy0: I iwl3945_rx_handle r 21 i 20 No handler needed for REPLY_RATE_SCALE, 0x47
> [   28.194997] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0413, 56 bytes at 19[19]:4
> [   28.195013] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
> [   28.197807] ieee80211 phy0: I iwl3945_rx_handle r 22 i 21 No handler needed for REPLY_RATE_SCALE, 0x47
> [   28.197843] ieee80211 phy0: U iwl3945_mac_config leave
> [   28.197853] ieee80211 phy0: U iwl3945_mac_conf_tx enter
> [   28.197860] ieee80211 phy0: U iwl3945_mac_conf_tx leave
> [   28.197866] ieee80211 phy0: U iwl3945_mac_conf_tx enter
> [   28.197872] ieee80211 phy0: U iwl3945_mac_conf_tx leave
> [   28.197879] ieee80211 phy0: U iwl3945_mac_conf_tx enter
> [   28.197885] ieee80211 phy0: U iwl3945_mac_conf_tx leave
> [   28.197891] ieee80211 phy0: U iwl3945_mac_conf_tx enter
> [   28.197898] ieee80211 phy0: U iwl3945_mac_conf_tx leave
> [   28.197914] ieee80211 phy0: I iwl3945_configure_filter Enter: changed: 0x0, total: 0x80000000
> [   28.197950] ieee80211 phy0: I iwl3945_configure_filter Enter: changed: 0x0, total: 0x80000000
> [   28.199837] ieee80211 phy0: I iwl3945_configure_filter Enter: changed: 0x0, total: 0x80000000
> [   28.213381] ieee80211 phy0: U iwl3945_mac_hw_scan enter
> [   28.213398] ieee80211 phy0: U iwl3945_scan_initiate Starting scan...
> [   28.213412] ieee80211 phy0: U iwl3945_mac_hw_scan leave
> [   28.213427] ieee80211 phy0: U iwl3945_bg_request_scan Kicking off one indirect scan.
> [   28.213438] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 1 [ACTIVE 39]
> [   28.213446] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 2 [ACTIVE 39]
> [   28.213453] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 3 [ACTIVE 39]
> [   28.213460] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 4 [ACTIVE 39]
> [   28.213469] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 5 [ACTIVE 39]
> [   28.213476] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 6 [ACTIVE 39]
> [   28.213484] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 7 [ACTIVE 39]
> [   28.213492] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 8 [ACTIVE 39]
> [   28.213500] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 9 [ACTIVE 39]
> [   28.213508] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 10 [ACTIVE 39]
> [   28.213515] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 11 [ACTIVE 39]
> [   28.213523] ieee80211 phy0: U iwl3945_get_channels_for_scan total channels to scan 11 
> [   28.213538] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x4414, 351 bytes at 20[32]:4
> [   28.213597] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
> [   28.224171] ieee80211 phy0: I iwl3945_rx_handle r = 23, i = 22, REPLY_SCAN_CMD, 0x80
> [   28.225264] ieee80211 phy0: I iwl3945_rx_handle r = 25, i = 23, STATISTICS_NOTIFICATION, 0x9d
> [   28.225284] ieee80211 phy0: I iwl3945_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0415, 12 bytes at 21[21]:4
> [   28.225338] ieee80211 phy0: I iwl3945_rx_handle r = 25, i = 24, SCAN_START_NOTIFICATION, 0x82
> [   28.225349] ieee80211 phy0: I iwl3945_rx_scan_start_notif Scan start: 1 [802.11bg] (TSF: 0x00000000:00002026) - 1 (beacon timer 94170)
> [   28.225857] ieee80211 phy0: I iwl3945_rx_handle r 26 i 25 No handler needed for REPLY_LEDS_CMD, 0x48
> [   28.227234] ieee80211 phy0: I iwl3945_rx_handle r = 27, i = 26, UNKNOWN, 0x1b
> [   28.228680] ieee80211 phy0: I iwl3945_rx_handle r = 28, i = 27, UNKNOWN, 0x1b
> [   28.230767] ieee80211 phy0: I iwl3945_rx_handle r = 29, i = 28, UNKNOWN, 0x1b
> [   28.232301] ieee80211 phy0: I iwl3945_rx_handle r = 30, i = 29, UNKNOWN, 0x1b
> [   28.234462] ieee80211 phy0: I iwl3945_rx_handle r = 31, i = 30, UNKNOWN, 0x1b
> [   28.236225] ieee80211 phy0: I iwl3945_rx_handle r = 32, i = 31, UNKNOWN, 0x1b
> [   28.240350] ieee80211 phy0: I iwl3945_rx_handle r = 33, i = 32, UNKNOWN, 0x1b
> [   28.257420] ieee80211 phy0: I iwl3945_rx_handle r = 34, i = 33, UNKNOWN, 0x1b
> [   28.265235] ieee80211 phy0: I iwl3945_rx_handle r = 35, i = 34, SCAN_RESULTS_NOTIFICATION, 0x83
> [   28.265249] ieee80211 phy0: I iwl3945_rx_scan_results_notif Scan ch.res: 1 [802.11bg] (TSF: 0x00000000:0000BC2E) - 8 elapsed=39944 usec (-271736ms since last)
> [   28.266297] ieee80211 phy0: I iwl3945_rx_handle r = 37, i = 35, STATISTICS_NOTIFICATION, 0x9d
> [   28.266320] ieee80211 phy0: I iwl3945_rx_handle r = 37, i = 36, SCAN_START_NOTIFICATION, 0x82
> [   28.266330] ieee80211 phy0: I iwl3945_rx_scan_start_notif Scan start: 2 [802.11bg] (TSF: 0x00000000:0000C058) - 1 (beacon timer 53160)
> [   28.279471] ieee80211 phy0: I iwl3945_rx_handle r = 38, i = 37, SCAN_RESULTS_NOTIFICATION, 0x83
> [   28.279484] ieee80211 phy0: I iwl3945_rx_scan_results_notif Scan ch.res: 2 [802.11bg] (TSF: 0x00000000:0000F3C7) - 0 elapsed=13167 usec (12ms since last)
> [   28.280512] ieee80211 phy0: I iwl3945_rx_handle r = 40, i = 38, STATISTICS_NOTIFICATION, 0x9d
> [   28.280539] ieee80211 phy0: I iwl3945_rx_handle r = 40, i = 39, SCAN_START_NOTIFICATION, 0x82
> [   28.280551] ieee80211 phy0: I iwl3945_rx_scan_start_notif Scan start: 3 [802.11bg] (TSF: 0x00000000:0000F7F3) - 1 (beacon timer 38924)
> [   28.284104] ieee80211 phy0: I iwl3945_rx_handle r = 41, i = 40, UNKNOWN, 0x1b
> [   28.293036] ieee80211 phy0: I iwl3945_rx_handle r = 42, i = 41, SCAN_RESULTS_NOTIFICATION, 0x83
> [   28.293051] ieee80211 phy0: I iwl3945_rx_scan_results_notif Scan ch.res: 3 [802.11bg] (TSF: 0x00000000:000128DA) - 1 elapsed=12519 usec (16ms since last)
> [   28.294102] ieee80211 phy0: I iwl3945_rx_handle r = 44, i = 42, STATISTICS_NOTIFICATION, 0x9d
> [   28.294124] ieee80211 phy0: I iwl3945_rx_handle r = 44, i = 43, SCAN_START_NOTIFICATION, 0x82
> [   28.294134] ieee80211 phy0: I iwl3945_rx_scan_start_notif Scan start: 4 [802.11bg] (TSF: 0x00000000:00012D0B) - 1 (beacon timer 25333)
> [   28.306579] ieee80211 phy0: I iwl3945_rx_handle r = 45, i = 44, SCAN_RESULTS_NOTIFICATION, 0x83
> [   28.306598] ieee80211 phy0: I iwl3945_rx_scan_results_notif Scan ch.res: 4 [802.11bg] (TSF: 0x00000000:00015DA7) - 1 elapsed=12444 usec (12ms since last)
> [   28.307536] ieee80211 phy0: I iwl3945_rx_handle r = 47, i = 45, STATISTICS_NOTIFICATION, 0x9d
> [   28.307558] ieee80211 phy0: I iwl3945_rx_handle r = 47, i = 46, SCAN_START_NOTIFICATION, 0x82
> [   28.307572] ieee80211 phy0: I iwl3945_rx_scan_start_notif Scan start: 5 [802.11bg] (TSF: 0x00000000:0001616D) - 1 (beacon timer 11923)
> [   28.311034] ieee80211 phy0: I iwl3945_rx_handle r = 48, i = 47, UNKNOWN, 0x1b
> [   28.313394] ieee80211 phy0: I iwl3945_rx_handle r = 49, i = 48, UNKNOWN, 0x1b
> [   28.315763] ieee80211 phy0: I iwl3945_rx_handle r = 50, i = 49, UNKNOWN, 0x1b
> [   28.317247] ieee80211 phy0: I iwl3945_rx_handle r = 51, i = 50, UNKNOWN, 0x1b
> [   28.318931] ieee80211 phy0: I iwl3945_rx_handle r = 52, i = 51, UNKNOWN, 0x1b
> [   28.321298] ieee80211 phy0: I iwl3945_rx_handle r = 53, i = 52, UNKNOWN, 0x1b
> [   28.323320] ieee80211 phy0: I iwl3945_rx_handle r = 54, i = 53, UNKNOWN, 0x1b
> [   28.326977] ieee80211 phy0: I iwl3945_rx_handle r = 55, i = 54, UNKNOWN, 0x1b
> [   28.332319] ieee80211 phy0: I iwl3945_rx_handle r = 56, i = 55, UNKNOWN, 0x1b
> [   28.333586] ieee80211 phy0: I iwl3945_rx_handle r = 57, i = 56, UNKNOWN, 0x1b
> [   28.347500] ieee80211 phy0: I iwl3945_rx_handle r = 58, i = 57, SCAN_RESULTS_NOTIFICATION, 0x83
> [   28.347515] ieee80211 phy0: I iwl3945_rx_scan_results_notif Scan ch.res: 5 [802.11bg] (TSF: 0x00000000:0001FD80) - 10 elapsed=39955 usec (40ms since last)
> [   28.348461] ieee80211 phy0: I iwl3945_rx_handle r = 60, i = 58, STATISTICS_NOTIFICATION, 0x9d
> [   28.348487] ieee80211 phy0: I iwl3945_rx_handle r = 60, i = 59, SCAN_START_NOTIFICATION, 0x82
> [   28.348498] ieee80211 phy0: I iwl3945_rx_scan_start_notif Scan start: 6 [802.11bg] (TSF: 0x00000000:00020147) - 1 (beacon timer 16850617)
> [   28.350510] ieee80211 phy0: I iwl3945_rx_handle r = 61, i = 60, UNKNOWN, 0x1b
> [   28.352814] ieee80211 phy0: I iwl3945_rx_handle r = 62, i = 61, UNKNOWN, 0x1b
> [   28.354496] ieee80211 phy0: I iwl3945_rx_handle r = 63, i = 62, UNKNOWN, 0x1b
> [   28.356598] ieee80211 phy0: I iwl3945_rx_handle r = 64, i = 63, UNKNOWN, 0x1b
> [   28.358202] ieee80211 phy0: I iwl3945_rx_handle r = 65, i = 64, UNKNOWN, 0x1b
> [   28.362241] ieee80211 phy0: I iwl3945_rx_handle r = 66, i = 65, UNKNOWN, 0x1b
> [   28.378258] ieee80211 phy0: I iwl3945_rx_handle r = 67, i = 66, UNKNOWN, 0x1b
> [   28.388411] ieee80211 phy0: I iwl3945_rx_handle r = 68, i = 67, SCAN_RESULTS_NOTIFICATION, 0x83
> [   28.388432] ieee80211 phy0: I iwl3945_rx_scan_results_notif Scan ch.res: 6 [802.11bg] (TSF: 0x00000000:00029D4E) - 9 elapsed=39943 usec (40ms since last)
> [   28.389393] ieee80211 phy0: I iwl3945_rx_handle r = 70, i = 68, STATISTICS_NOTIFICATION, 0x9d
> [   28.389420] ieee80211 phy0: I iwl3945_rx_handle r = 70, i = 69, SCAN_START_NOTIFICATION, 0x82
> [   28.389432] ieee80211 phy0: I iwl3945_rx_scan_start_notif Scan start: 7 [802.11bg] (TSF: 0x00000000:0002A15E) - 1 (beacon timer 16809634)
> [   28.391547] ieee80211 phy0: I iwl3945_rx_handle r = 71, i = 70, UNKNOWN, 0x1b
> [   28.394949] ieee80211 phy0: I iwl3945_rx_handle r = 72, i = 71, UNKNOWN, 0x1b
> [   28.429405] ieee80211 phy0: I iwl3945_rx_handle r = 73, i = 72, SCAN_RESULTS_NOTIFICATION, 0x83
> [   28.429420] ieee80211 phy0: I iwl3945_rx_scan_results_notif Scan ch.res: 7 [802.11bg] (TSF: 0x00000000:00033D6D) - 2 elapsed=39951 usec (44ms since last)
> [   28.430367] ieee80211 phy0: I iwl3945_rx_handle r = 75, i = 73, STATISTICS_NOTIFICATION, 0x9d
> [   28.430390] ieee80211 phy0: I iwl3945_rx_handle r = 75, i = 74, SCAN_START_NOTIFICATION, 0x82
> [   28.430400] ieee80211 phy0: I iwl3945_rx_scan_start_notif Scan start: 8 [802.11bg] (TSF: 0x00000000:00034134) - 1 (beacon timer 33648332)
> [   28.433225] ieee80211 phy0: I iwl3945_rx_handle r = 76, i = 75, UNKNOWN, 0x1b
> [   28.435645] ieee80211 phy0: I iwl3945_rx_handle r = 77, i = 76, UNKNOWN, 0x1b
> [   28.436866] ieee80211 phy0: I iwl3945_rx_handle r = 78, i = 77, UNKNOWN, 0x1b
> [   28.439525] ieee80211 phy0: I iwl3945_rx_handle r = 79, i = 78, UNKNOWN, 0x1b
> [   28.470325] ieee80211 phy0: I iwl3945_rx_handle r = 80, i = 79, SCAN_RESULTS_NOTIFICATION, 0x83
> [   28.470340] ieee80211 phy0: I iwl3945_rx_scan_results_notif Scan ch.res: 8 [802.11bg] (TSF: 0x00000000:0003DD42) - 4 elapsed=39950 usec (40ms since last)
> [   28.471262] ieee80211 phy0: I iwl3945_rx_handle r = 82, i = 80, STATISTICS_NOTIFICATION, 0x9d
> [   28.471289] ieee80211 phy0: I iwl3945_rx_handle r = 82, i = 81, SCAN_START_NOTIFICATION, 0x82
> [   28.471300] ieee80211 phy0: I iwl3945_rx_scan_start_notif Scan start: 9 [802.11bg] (TSF: 0x00000000:0003E109) - 1 (beacon timer 33607415)
> [   28.483608] ieee80211 phy0: I iwl3945_rx_handle r = 83, i = 82, SCAN_RESULTS_NOTIFICATION, 0x83
> [   28.483621] ieee80211 phy0: I iwl3945_rx_scan_results_notif Scan ch.res: 9 [802.11bg] (TSF: 0x00000000:00041147) - 0 elapsed=12350 usec (12ms since last)
> [   28.484579] ieee80211 phy0: I iwl3945_rx_handle r = 85, i = 83, STATISTICS_NOTIFICATION, 0x9d
> [   28.484605] ieee80211 phy0: I iwl3945_rx_handle r = 85, i = 84, SCAN_START_NOTIFICATION, 0x82
> [   28.484616] ieee80211 phy0: I iwl3945_rx_scan_start_notif Scan start: 10 [802.11bg] (TSF: 0x00000000:00041511) - 1 (beacon timer 33594095)
> [   28.494531] ieee80211 phy0: I iwl3945_rx_handle r = 86, i = 85, UNKNOWN, 0x1b
> [   28.496900] ieee80211 phy0: I iwl3945_rx_handle r = 87, i = 86, SCAN_RESULTS_NOTIFICATION, 0x83
> [   28.496913] ieee80211 phy0: I iwl3945_rx_scan_results_notif Scan ch.res: 10 [802.11bg] (TSF: 0x00000000:00044515) - 1 elapsed=12292 usec (16ms since last)
> [   28.497808] ieee80211 phy0: I iwl3945_rx_handle r = 89, i = 87, STATISTICS_NOTIFICATION, 0x9d
> [   28.497832] ieee80211 phy0: I iwl3945_rx_handle r = 89, i = 88, SCAN_START_NOTIFICATION, 0x82
> [   28.497842] ieee80211 phy0: I iwl3945_rx_scan_start_notif Scan start: 11 [802.11bg] (TSF: 0x00000000:000448DF) - 1 (beacon timer 33580832)
> [   28.499027] ieee80211 phy0: I iwl3945_rx_handle r = 90, i = 89, UNKNOWN, 0x1b
> [   28.500904] ieee80211 phy0: I iwl3945_rx_handle r = 91, i = 90, UNKNOWN, 0x1b
> [   28.503195] ieee80211 phy0: I iwl3945_rx_handle r = 92, i = 91, UNKNOWN, 0x1b
> [   28.505498] ieee80211 phy0: I iwl3945_rx_handle r = 93, i = 92, UNKNOWN, 0x1b
> [   28.537796] ieee80211 phy0: I iwl3945_rx_handle r = 94, i = 93, SCAN_RESULTS_NOTIFICATION, 0x83
> [   28.537813] ieee80211 phy0: I iwl3945_rx_scan_results_notif Scan ch.res: 11 [802.11bg] (TSF: 0x00000000:0004E4E8) - 4 elapsed=39945 usec (40ms since last)
> [   28.538874] ieee80211 phy0: I iwl3945_rx_handle r = 95, i = 94, SCAN_COMPLETE_NOTIFICATION, 0x84
> [   28.538889] ieee80211 phy0: I iwl3945_rx_scan_complete_notif Scan complete: 11 channels (TSF 0x0004E91D:00000000) - 1
> [   28.538898] ieee80211 phy0: I iwl3945_rx_scan_complete_notif Scan pass on 2.4GHz took 324ms
> [   28.538932] ieee80211 phy0: U iwl3945_bg_request_scan Kicking off one indirect scan.
> [   28.538946] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 36 [PASSIVE 110]
> [   28.538953] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 40 [PASSIVE 110]
> [   28.538960] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 44 [PASSIVE 110]
> [   28.538968] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 48 [PASSIVE 110]
> [   28.538976] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 52 [PASSIVE 110]
> [   28.538985] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 56 [PASSIVE 110]
> [   28.538992] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 60 [PASSIVE 110]
> [   28.539000] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 64 [PASSIVE 110]
> [   28.539009] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 149 [PASSIVE 110]
> [   28.539016] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 153 [PASSIVE 110]
> [   28.539025] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 157 [PASSIVE 110]
> [   28.539032] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 161 [PASSIVE 110]
> [   28.539040] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 165 [PASSIVE 110]
> [   28.539048] ieee80211 phy0: U iwl3945_get_channels_for_scan total channels to scan 13 
> [   28.539062] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x4416, 367 bytes at 22[32]:4
> [   28.539312] ieee80211 phy0: I iwl3945_rx_handle r = 96, i = 95, REPLY_SCAN_CMD, 0x80
> [   28.540203] ieee80211 phy0: I iwl3945_rx_handle r = 98, i = 96, STATISTICS_NOTIFICATION, 0x9d
> [   28.540228] ieee80211 phy0: I iwl3945_rx_handle r = 98, i = 97, SCAN_START_NOTIFICATION, 0x82
> [   28.540239] ieee80211 phy0: I iwl3945_rx_scan_start_notif Scan start: 36 [802.11a] (TSF: 0x00000000:0004EE7A) - 1 (beacon timer 50418054)
> [   28.652859] ieee80211 phy0: I iwl3945_rx_handle r = 99, i = 98, SCAN_RESULTS_NOTIFICATION, 0x83
> [   28.652876] ieee80211 phy0: I iwl3945_rx_scan_results_notif Scan ch.res: 36 [802.11a] (TSF: 0x00000000:0006A682) - 0 elapsed=112648 usec (112ms since last)
> [   28.653779] ieee80211 phy0: I iwl3945_rx_handle r = 101, i = 99, STATISTICS_NOTIFICATION, 0x9d
> [   28.653805] ieee80211 phy0: I iwl3945_rx_handle r = 101, i = 100, SCAN_START_NOTIFICATION, 0x82
> [   28.653816] ieee80211 phy0: I iwl3945_rx_scan_start_notif Scan start: 40 [802.11a] (TSF: 0x00000000:0006AA1F) - 1 (beacon timer 67184097)
> [   28.766492] ieee80211 phy0: I iwl3945_rx_handle r = 102, i = 101, SCAN_RESULTS_NOTIFICATION, 0x83
> [   28.766510] ieee80211 phy0: I iwl3945_rx_scan_results_notif Scan ch.res: 40 [802.11a] (TSF: 0x00000000:00086228) - 0 elapsed=112649 usec (116ms since last)
> [   28.767408] ieee80211 phy0: I iwl3945_rx_handle r = 104, i = 102, STATISTICS_NOTIFICATION, 0x9d
> [   28.767432] ieee80211 phy0: I iwl3945_rx_handle r = 104, i = 103, SCAN_START_NOTIFICATION, 0x82
> [   28.767442] ieee80211 phy0: I iwl3945_rx_scan_start_notif Scan start: 44 [802.11a] (TSF: 0x00000000:000865C4) - 1 (beacon timer 83950139)
> [   28.880085] ieee80211 phy0: I iwl3945_rx_handle r = 105, i = 104, SCAN_RESULTS_NOTIFICATION, 0x83
> [   28.880106] ieee80211 phy0: I iwl3945_rx_scan_results_notif Scan ch.res: 44 [802.11a] (TSF: 0x00000000:000A1DCD) - 0 elapsed=112649 usec (116ms since last)
> [   28.881019] ieee80211 phy0: I iwl3945_rx_handle r = 107, i = 105, STATISTICS_NOTIFICATION, 0x9d
> [   28.881042] ieee80211 phy0: I iwl3945_rx_handle r = 107, i = 106, SCAN_START_NOTIFICATION, 0x82
> [   28.881053] ieee80211 phy0: I iwl3945_rx_scan_start_notif Scan start: 48 [802.11a] (TSF: 0x00000000:000A2187) - 1 (beacon timer 100716152)
> [   28.993675] ieee80211 phy0: I iwl3945_rx_handle r = 108, i = 107, SCAN_RESULTS_NOTIFICATION, 0x83
> [   28.993690] ieee80211 phy0: I iwl3945_rx_scan_results_notif Scan ch.res: 48 [802.11a] (TSF: 0x00000000:000BD990) - 0 elapsed=112649 usec (112ms since last)
> [   28.994594] ieee80211 phy0: I iwl3945_rx_handle r = 110, i = 108, STATISTICS_NOTIFICATION, 0x9d
> [   28.994616] ieee80211 phy0: I iwl3945_rx_handle r = 110, i = 109, SCAN_START_NOTIFICATION, 0x82
> [   28.994626] ieee80211 phy0: I iwl3945_rx_scan_start_notif Scan start: 52 [802.11a] (TSF: 0x00000000:000BDD2D) - 1 (beacon timer 117482195)
> [   29.107250] ieee80211 phy0: I iwl3945_rx_handle r = 111, i = 110, SCAN_RESULTS_NOTIFICATION, 0x83
> [   29.107264] ieee80211 phy0: I iwl3945_rx_scan_results_notif Scan ch.res: 52 [802.11a] (TSF: 0x00000000:000D9536) - 0 elapsed=112649 usec (112ms since last)
> [   29.108151] ieee80211 phy0: I iwl3945_rx_handle r = 113, i = 111, STATISTICS_NOTIFICATION, 0x9d
> [   29.108177] ieee80211 phy0: I iwl3945_rx_handle r = 113, i = 112, SCAN_START_NOTIFICATION, 0x82
> [   29.108188] ieee80211 phy0: I iwl3945_rx_scan_start_notif Scan start: 56 [802.11a] (TSF: 0x00000000:000D98D2) - 1 (beacon timer 134248238)
> [   29.220805] ieee80211 phy0: I iwl3945_rx_handle r = 114, i = 113, SCAN_RESULTS_NOTIFICATION, 0x83
> [   29.220828] ieee80211 phy0: I iwl3945_rx_scan_results_notif Scan ch.res: 56 [802.11a] (TSF: 0x00000000:000F50DA) - 0 elapsed=112648 usec (112ms since last)
> [   29.221688] ieee80211 phy0: I iwl3945_rx_handle r = 116, i = 114, STATISTICS_NOTIFICATION, 0x9d
> [   29.221716] ieee80211 phy0: I iwl3945_rx_handle r = 116, i = 115, SCAN_START_NOTIFICATION, 0x82
> [   29.221728] ieee80211 phy0: I iwl3945_rx_scan_start_notif Scan start: 60 [802.11a] (TSF: 0x00000000:000F5477) - 1 (beacon timer 151014281)
> [   29.334349] ieee80211 phy0: I iwl3945_rx_handle r = 117, i = 116, SCAN_RESULTS_NOTIFICATION, 0x83
> [   29.334371] ieee80211 phy0: I iwl3945_rx_scan_results_notif Scan ch.res: 60 [802.11a] (TSF: 0x00000000:00110C7F) - 0 elapsed=112648 usec (116ms since last)
> [   29.335632] ieee80211 phy0: I iwl3945_rx_handle r = 119, i = 117, STATISTICS_NOTIFICATION, 0x9d
> [   29.335656] ieee80211 phy0: I iwl3945_rx_handle r = 119, i = 118, SCAN_START_NOTIFICATION, 0x82
> [   29.335668] ieee80211 phy0: I iwl3945_rx_scan_start_notif Scan start: 64 [802.11a] (TSF: 0x00000000:00111191) - 1 (beacon timer 167779951)
> [   29.448331] ieee80211 phy0: I iwl3945_rx_handle r = 120, i = 119, SCAN_RESULTS_NOTIFICATION, 0x83
> [   29.448339] ieee80211 phy0: I iwl3945_rx_scan_results_notif Scan ch.res: 64 [802.11a] (TSF: 0x00000000:0012C99A) - 0 elapsed=112649 usec (116ms since last)
> [   29.449625] ieee80211 phy0: I iwl3945_rx_handle r = 122, i = 120, STATISTICS_NOTIFICATION, 0x9d
> [   29.449636] ieee80211 phy0: I iwl3945_rx_handle r = 122, i = 121, SCAN_START_NOTIFICATION, 0x82
> [   29.449640] ieee80211 phy0: I iwl3945_rx_scan_start_notif Scan start: 149 [802.11a] (TSF: 0x00000000:0012CEAC) - 1 (beacon timer 201425236)
> [   29.562279] ieee80211 phy0: I iwl3945_rx_handle r = 123, i = 122, SCAN_RESULTS_NOTIFICATION, 0x83
> [   29.562303] ieee80211 phy0: I iwl3945_rx_scan_results_notif Scan ch.res: 149 [802.11a] (TSF: 0x00000000:001486B4) - 0 elapsed=112648 usec (112ms since last)
> [   29.563189] ieee80211 phy0: I iwl3945_rx_handle r = 125, i = 123, STATISTICS_NOTIFICATION, 0x9d
> [   29.563213] ieee80211 phy0: I iwl3945_rx_handle r = 125, i = 124, SCAN_START_NOTIFICATION, 0x82
> [   29.563223] ieee80211 phy0: I iwl3945_rx_scan_start_notif Scan start: 153 [802.11a] (TSF: 0x00000000:00148A51) - 1 (beacon timer 218191279)
> [   29.675876] ieee80211 phy0: I iwl3945_rx_handle r = 126, i = 125, SCAN_RESULTS_NOTIFICATION, 0x83
> [   29.675895] ieee80211 phy0: I iwl3945_rx_scan_results_notif Scan ch.res: 153 [802.11a] (TSF: 0x00000000:0016425A) - 0 elapsed=112649 usec (112ms since last)
> [   29.676768] ieee80211 phy0: I iwl3945_rx_handle r = 128, i = 126, STATISTICS_NOTIFICATION, 0x9d
> [   29.676797] ieee80211 phy0: I iwl3945_rx_handle r = 128, i = 127, SCAN_START_NOTIFICATION, 0x82
> [   29.676811] ieee80211 phy0: I iwl3945_rx_scan_start_notif Scan start: 157 [802.11a] (TSF: 0x00000000:001645F5) - 1 (beacon timer 234957323)
> [   29.789455] ieee80211 phy0: I iwl3945_rx_handle r = 129, i = 128, SCAN_RESULTS_NOTIFICATION, 0x83
> [   29.789476] ieee80211 phy0: I iwl3945_rx_scan_results_notif Scan ch.res: 157 [802.11a] (TSF: 0x00000000:0017FDFE) - 0 elapsed=112649 usec (116ms since last)
> [   29.790367] ieee80211 phy0: I iwl3945_rx_handle r = 131, i = 129, STATISTICS_NOTIFICATION, 0x9d
> [   29.790390] ieee80211 phy0: I iwl3945_rx_handle r = 131, i = 130, SCAN_START_NOTIFICATION, 0x82
> [   29.790401] ieee80211 phy0: I iwl3945_rx_scan_start_notif Scan start: 161 [802.11a] (TSF: 0x00000000:0018019B) - 1 (beacon timer 251723365)
> [   29.903026] ieee80211 phy0: I iwl3945_rx_handle r = 132, i = 131, SCAN_RESULTS_NOTIFICATION, 0x83
> [   29.903045] ieee80211 phy0: I iwl3945_rx_scan_results_notif Scan ch.res: 161 [802.11a] (TSF: 0x00000000:0019B9A3) - 0 elapsed=112648 usec (112ms since last)
> [   29.903939] ieee80211 phy0: I iwl3945_rx_handle r = 134, i = 132, STATISTICS_NOTIFICATION, 0x9d
> [   29.903963] ieee80211 phy0: I iwl3945_rx_handle r = 134, i = 133, SCAN_START_NOTIFICATION, 0x82
> [   29.903973] ieee80211 phy0: I iwl3945_rx_scan_start_notif Scan start: 165 [802.11a] (TSF: 0x00000000:0019BD3F) - 1 (beacon timer 268489409)
> [   30.016606] ieee80211 phy0: I iwl3945_rx_handle r = 135, i = 134, SCAN_RESULTS_NOTIFICATION, 0x83
> [   30.016625] ieee80211 phy0: I iwl3945_rx_scan_results_notif Scan ch.res: 165 [802.11a] (TSF: 0x00000000:001B7548) - 0 elapsed=112649 usec (116ms since last)
> [   30.017786] ieee80211 phy0: I iwl3945_rx_handle r = 136, i = 135, SCAN_COMPLETE_NOTIFICATION, 0x84
> [   30.017797] ieee80211 phy0: I iwl3945_rx_scan_complete_notif Scan complete: 13 channels (TSF 0x001B79ED:00000000) - 1
> [   30.017805] ieee80211 phy0: I iwl3945_rx_scan_complete_notif Scan pass on 5.2GHz took 1480ms
> [   30.017812] ieee80211 phy0: I iwl3945_rx_scan_complete_notif Setting scan to off
> [   30.017819] ieee80211 phy0: I iwl3945_rx_scan_complete_notif Scan took 1804ms
> [   30.017856] ieee80211 phy0: U iwl3945_bg_scan_completed SCAN complete scan
> [   30.017882] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x0d
> [   30.017891] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x0f
> [   30.017899] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x05
> [   30.017906] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x07
> [   30.017914] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x09
> [   30.017922] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x0b
> [   30.017929] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x01
> [   30.017939] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x03
> [   30.017947] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 171 dsp  98 rate code 0x0a
> [   30.017955] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 171 dsp  98 rate code 0x14
> [   30.017964] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 171 dsp  98 rate code 0x37
> [   30.017972] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 171 dsp  98 rate code 0x6e
> [   30.017986] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0417, 56 bytes at 23[23]:4
> [   30.018002] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
> [   30.020635] ieee80211 phy0: I iwl3945_rx_handle r 137 i 136 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
> [   30.020698] ieee80211 phy0: U iwl3945_mac_config enter to channel 11
> [   30.020710] ieee80211 phy0: U iwl3945_set_rxon_channel Staging channel set to 11 [0]
> [   30.020725] ieee80211 phy0: U iwl3945_commit_rxon Sending RXON
> [   30.020727] * without RXON_FILTER_ASSOC_MSK
> [   30.020729] * channel = 11
> [   30.020730] * bssid = 00:00:00:00:00:00
> [   30.020750] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x0418, 48 bytes at 24[24]:4
> [   30.020767] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
> [   30.024553] ieee80211 phy0: I iwl3945_rx_handle r 138 i 137 No handler needed for REPLY_RXON, 0x10
> [   30.028072] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0d
> [   30.028083] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0f
> [   30.028091] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x05
> [   30.028099] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x07
> [   30.028107] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x09
> [   30.028115] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0b
> [   30.028123] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x01
> [   30.028131] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x03
> [   30.028140] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x0a
> [   30.028148] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x14
> [   30.028156] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x37
> [   30.028165] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x6e
> [   30.028177] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0419, 56 bytes at 25[25]:4
> [   30.028192] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
> [   30.030517] ieee80211 phy0: I iwl3945_rx_handle r 139 i 138 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
> [   30.030582] ieee80211 phy0: U iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
> [   30.030596] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x041A, 68 bytes at 26[26]:4
> [   30.030612] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
> [   30.033283] ieee80211 phy0: I iwl3945_rx_handle r = 140, i = 139, REPLY_ADD_STA, 0x18
> [   30.034036] ieee80211 phy0: U iwl3945_send_add_station REPLY_ADD_STA PASSED
> [   30.034055] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x041B, 56 bytes at 27[27]:4
> [   30.034070] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
> [   30.036051] ieee80211 phy0: I iwl3945_rx_handle r 141 i 140 No handler needed for REPLY_RATE_SCALE, 0x47
> [   30.036138] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x041C, 56 bytes at 28[28]:4
> [   30.036155] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
> [   30.038809] ieee80211 phy0: I iwl3945_rx_handle r 142 i 141 No handler needed for REPLY_RATE_SCALE, 0x47
> [   30.038864] ieee80211 phy0: U iwl3945_mac_config leave
> [   30.038880] ieee80211 phy0: U iwl3945_mac_config_interface bssid: 00:30:bd:c0:90:24
> [   30.038891] ieee80211 phy0: U iwl3945_commit_rxon Sending RXON
> [   30.038893] * without RXON_FILTER_ASSOC_MSK
> [   30.038895] * channel = 11
> [   30.038896] * bssid = 00:30:bd:c0:90:24
> [   30.038917] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x041D, 48 bytes at 29[29]:4
> [   30.038931] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
> [   30.041769] ieee80211 phy0: I iwl3945_rx_handle r 143 i 142 No handler needed for REPLY_RXON, 0x10
> [   30.041804] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0d
> [   30.041813] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0f
> [   30.041821] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x05
> [   30.041829] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x07
> [   30.041837] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x09
> [   30.041846] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0b
> [   30.041855] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x01
> [   30.041863] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x03
> [   30.041872] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x0a
> [   30.041880] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x14
> [   30.041889] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x37
> [   30.041897] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x6e
> [   30.041909] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x041E, 56 bytes at 30[30]:4
> [   30.041923] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
> [   30.044509] ieee80211 phy0: I iwl3945_rx_handle r 144 i 143 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
> [   30.044542] ieee80211 phy0: U iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
> [   30.044555] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x041F, 68 bytes at 31[31]:4
> [   30.044569] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
> [   30.047275] ieee80211 phy0: I iwl3945_rx_handle r = 145, i = 144, REPLY_ADD_STA, 0x18
> [   30.047303] ieee80211 phy0: U iwl3945_send_add_station REPLY_ADD_STA PASSED
> [   30.047318] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0420, 56 bytes at 32[0]:4
> [   30.047333] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
> [   30.050049] ieee80211 phy0: I iwl3945_rx_handle r 146 i 145 No handler needed for REPLY_RATE_SCALE, 0x47
> [   30.050123] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0421, 56 bytes at 33[1]:4
> [   30.050140] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
> [   30.052817] ieee80211 phy0: I iwl3945_rx_handle r 147 i 146 No handler needed for REPLY_RATE_SCALE, 0x47
> [   30.052868] ieee80211 phy0: U iwl3945_mac_config_interface leave
> [   30.052879] ieee80211 phy0: U iwl3945_mac_conf_tx enter
> [   30.052885] ieee80211 phy0: U iwl3945_mac_conf_tx leave
> [   30.052891] ieee80211 phy0: U iwl3945_mac_conf_tx enter
> [   30.052958] ieee80211 phy0: U iwl3945_mac_conf_tx leave
> [   30.052967] ieee80211 phy0: U iwl3945_mac_conf_tx enter
> [   30.052975] ieee80211 phy0: U iwl3945_mac_conf_tx leave
> [   30.052981] ieee80211 phy0: U iwl3945_mac_conf_tx enter
> [   30.052987] ieee80211 phy0: U iwl3945_mac_conf_tx leave
> [   30.052996] ieee80211 phy0: U iwl3945_mac_reset_tsf enter
> [   30.053026] ieee80211 phy0: U iwl3945_commit_rxon Sending RXON
> [   30.053028] * without RXON_FILTER_ASSOC_MSK
> [   30.053030] * channel = 11
> [   30.053031] * bssid = 00:30:bd:c0:90:24
> [   30.053105] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x0422, 48 bytes at 34[2]:4
> [   30.053120] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
> [   30.055745] ieee80211 phy0: I iwl3945_rx_handle r 148 i 147 No handler needed for REPLY_RXON, 0x10
> [   30.057586] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0d
> [   30.057599] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0f
> [   30.057608] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x05
> [   30.057616] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x07
> [   30.057624] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x09
> [   30.057632] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0b
> [   30.057640] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x01
> [   30.057648] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x03
> [   30.057656] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x0a
> [   30.057664] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x14
> [   30.057672] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x37
> [   30.057681] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x6e
> [   30.057693] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0423, 56 bytes at 35[3]:4
> [   30.057750] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
> [   30.068227] ieee80211 phy0: I iwl3945_rx_handle r 149 i 148 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
> [   30.068267] ieee80211 phy0: U iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
> [   30.068283] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0424, 68 bytes at 36[4]:4
> [   30.068298] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
> [   30.070991] ieee80211 phy0: I iwl3945_rx_handle r = 150, i = 149, REPLY_ADD_STA, 0x18
> [   30.071017] ieee80211 phy0: U iwl3945_send_add_station REPLY_ADD_STA PASSED
> [   30.071033] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0425, 56 bytes at 37[5]:4
> [   30.071047] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
> [   30.073724] ieee80211 phy0: I iwl3945_rx_handle r 151 i 150 No handler needed for REPLY_RATE_SCALE, 0x47
> [   30.073782] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0426, 56 bytes at 38[6]:4
> [   30.073798] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
> [   30.076518] ieee80211 phy0: I iwl3945_rx_handle r 152 i 151 No handler needed for REPLY_RATE_SCALE, 0x47
> [   30.076545] ieee80211 phy0: U iwl3945_mac_reset_tsf leave - not in IBSS
> [   30.076578] ieee80211 phy0: I iwl3945_mac_tx enter
> [   30.076596] ieee80211 phy0: I iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
> [   30.076612] ieee80211 phy0: I iwl3945_mac_tx leave
> [   30.079437] ieee80211 phy0: I iwl3945_rx_handle r = 153, i = 152, REPLY_TX, 0x1c
> [   30.280131] ieee80211 phy0: I iwl3945_mac_tx enter
> [   30.280185] ieee80211 phy0: I iwl3945_mac_tx leave
> [   30.280272] iwl3945 0000:03:00.0: Microcode SW error detected. Restarting 0x82000008.
> [   30.280309] iwl3945 0000:03:00.0: Start IWL Error Log Dump:
> [   30.280317] iwl3945 0000:03:00.0: Status: 0x000302E4, count: 1
> [   30.280323] iwl3945 0000:03:00.0: Desc       Time       asrtPC  blink2 ilink1  nmiPC   Line
> [   30.280457] iwl3945 0000:03:00.0: SYSASSERT     (#5) 0000207283 0x0089A 0x0025E 0x00304 0x01BCC 78
> [   30.280459] 
> [   30.280529] iwl3945 0000:03:00.0: Start IWL Event Log Dump: display count 512, wraps 15
> [   30.280566] iwl3945 0000:03:00.0: 0000001092 0x00000000      1106
> [   30.280601] iwl3945 0000:03:00.0: 0000001096 0x00000000      1106
> [   30.280636] iwl3945 0000:03:00.0: 0000001100 0x00000000      1106
> [   30.280724] iwl3945 0000:03:00.0: 0000001105 0x00000000      1106
> [   30.280759] iwl3945 0000:03:00.0: 0000001109 0x00000000      1106
> [   30.280793] iwl3945 0000:03:00.0: 0000001113 0x00000000      1106
> [   30.280828] iwl3945 0000:03:00.0: 0000001117 0x00000000      1106
> [   30.280863] iwl3945 0000:03:00.0: 0000001122 0x00000000      1106
> [   30.280898] iwl3945 0000:03:00.0: 0000001126 0x00000000      1106
> [   30.280933] iwl3945 0000:03:00.0: 0000001130 0x00000000      1106
> [   30.280968] iwl3945 0000:03:00.0: 0000001134 0x00000000      1106
> [   30.281004] iwl3945 0000:03:00.0: 0000001139 0x00000000      1106
> [   30.281039] iwl3945 0000:03:00.0: 0000001143 0x00000000      1106
> [   30.281075] iwl3945 0000:03:00.0: 0000001147 0x00000000      1106
> [   30.281110] iwl3945 0000:03:00.0: 0000001152 0x00000000      1106
> [   30.281146] iwl3945 0000:03:00.0: 0000001156 0x00000000      1106
> [   30.281181] iwl3945 0000:03:00.0: 0000001160 0x00000000      1106
> [   30.281215] iwl3945 0000:03:00.0: 0000001164 0x00000000      1106
> [   30.281251] iwl3945 0000:03:00.0: 0000001169 0x00000000      1106
> [   30.281286] iwl3945 0000:03:00.0: 0000001173 0x00000000      1106
> [   30.281321] iwl3945 0000:03:00.0: 0000001177 0x00000000      1106
> [   30.281357] iwl3945 0000:03:00.0: 0000001181 0x00000000      1106
> [   30.281391] iwl3945 0000:03:00.0: 0000001186 0x00000000      1106
> [   30.281426] iwl3945 0000:03:00.0: 0000001190 0x00000000      1106
> [   30.281461] iwl3945 0000:03:00.0: 0000001194 0x00000000      1106
> [   30.281497] iwl3945 0000:03:00.0: 0000001199 0x00000000      1106
> [   30.281532] iwl3945 0000:03:00.0: 0000001203 0x00000000      1106
> [   30.281567] iwl3945 0000:03:00.0: 0000001207 0x00000000      1106
> [   30.281602] iwl3945 0000:03:00.0: 0000001211 0x00000000      1106
> [   30.281637] iwl3945 0000:03:00.0: 0000001216 0x00000000      1106
> [   30.281673] iwl3945 0000:03:00.0: 0000001220 0x00000000      1106
> [   30.281709] iwl3945 0000:03:00.0: 0000001224 0x00000001      1106
> [   30.281745] iwl3945 0000:03:00.0: 0000001225 0x0000000f      1106
> [   30.281780] iwl3945 0000:03:00.0: 0000001227 0x00000396      1105
> [   30.281816] iwl3945 0000:03:00.0: 0000001230 0x000004e8      1115
> [   30.281852] iwl3945 0000:03:00.0: 0000001234 0x0000000b      0463
> [   30.281887] iwl3945 0000:03:00.0: 0000001235 0x0000000b      0462
> [   30.281922] iwl3945 0000:03:00.0: 0000001246 0x0000010c      0601
> [   30.281957] iwl3945 0000:03:00.0: 0000001256 0x04230097      0401
> [   30.281993] iwl3945 0000:03:00.0: 0000001259 0x0000000b      0451
> [   30.282029] iwl3945 0000:03:00.0: 0000001278 0x00000000      0451
> [   30.282064] iwl3945 0000:03:00.0: 0000001291 0x0000010f      0603
> [   30.282099] iwl3945 0000:03:00.0: 0000001358 0x00000180      0604
> [   30.282134] iwl3945 0000:03:00.0: 0000001360 0x0000019c      0610
> [   30.282169] iwl3945 0000:03:00.0: 0000001361 0x00018ab0      0610
> [   30.282204] iwl3945 0000:03:00.0: 0000001362 0x00000000      0610
> [   30.282239] iwl3945 0000:03:00.0: 0000001410 0x00000500      0600
> [   30.282274] iwl3945 0000:03:00.0: 0000002912 0x000001ed      0616
> [   30.282309] iwl3945 0000:03:00.0: 0000001404 0x00018a84      0638
> [   30.282344] iwl3945 0000:03:00.0: 0000001427 0x0000001c      1101
> [   30.282384] iwl3945 0000:03:00.0: 0000001460 0x0000001a      1101
> [   30.282420] iwl3945 0000:03:00.0: 0000001487 0x000000ff      1103
> [   30.282455] iwl3945 0000:03:00.0: 0000001488 0xffff9111      1103
> [   30.282489] iwl3945 0000:03:00.0: 0000001490 0x00000010      1101
> [   30.282525] iwl3945 0000:03:00.0: 0000001508 0x00000011      1101
> [   30.282560] iwl3945 0000:03:00.0: 0000001521 0x00000000      1101
> [   30.282595] iwl3945 0000:03:00.0: 0000001522 0x00000000      1101
> [   30.282630] iwl3945 0000:03:00.0: 0000001524 0x000001d8      1101
> [   30.282664] iwl3945 0000:03:00.0: 0000001526 0x00000065      1104
> [   30.282700] iwl3945 0000:03:00.0: 0000001528 0x0000000e      1101
> [   30.282735] iwl3945 0000:03:00.0: 0000001529 0x00680034      1102
> [   30.282770] iwl3945 0000:03:00.0: 0000001530 0x00670035      1102
> [   30.282805] iwl3945 0000:03:00.0: 0000001532 0x007e0036      1102
> [   30.282840] iwl3945 0000:03:00.0: 0000001534 0x007c0037      1102
> [   30.282874] iwl3945 0000:03:00.0: 0000001535 0x00000038      1102
> [   30.282909] iwl3945 0000:03:00.0: 0000001537 0x00840052      1102
> [   30.282947] iwl3945 0000:03:00.0: 0000001538 0x00840053      1102
> [   30.282982] iwl3945 0000:03:00.0: 0000001540 0x007e0054      1102
> [   30.283017] iwl3945 0000:03:00.0: 0000001541 0x007d0055      1102
> [   30.283052] iwl3945 0000:03:00.0: 0000001543 0x00000056      1102
> [   30.283086] iwl3945 0000:03:00.0: 0000001544 0x00007050      1102
> [   30.283121] iwl3945 0000:03:00.0: 0000001546 0x00017051      1102
> [   30.283156] iwl3945 0000:03:00.0: 0000001548 0x00008204      1102
> [   30.283191] iwl3945 0000:03:00.0: 0000001550 0x00018205      1102
> [   30.283225] iwl3945 0000:03:00.0: 0000001553 0x00000001      1101
> [   30.283261] iwl3945 0000:03:00.0: 0000001554 0x008b0063      1102
> [   30.283295] iwl3945 0000:03:00.0: 0000001556 0x0000001d      1104
> [   30.283331] iwl3945 0000:03:00.0: 0000001558 0x00000069      1114
> [   30.283365] iwl3945 0000:03:00.0: 0000001579 0x0000020f      0605
> [   30.283400] iwl3945 0000:03:00.0: 0000001580 0x0000026b      0621
> [   30.283435] iwl3945 0000:03:00.0: 0000001584 0x0000010b      1108
> [   30.283471] iwl3945 0000:03:00.0: 0000001586 0x0000000e      1101
> [   30.283509] iwl3945 0000:03:00.0: 0000001587 0x00680034      1102
> [   30.283544] iwl3945 0000:03:00.0: 0000001588 0x00670035      1102
> [   30.283580] iwl3945 0000:03:00.0: 0000001590 0x007e0036      1102
> [   30.283614] iwl3945 0000:03:00.0: 0000001591 0x007c0037      1102
> [   30.283649] iwl3945 0000:03:00.0: 0000001593 0x00000038      1102
> [   30.283684] iwl3945 0000:03:00.0: 0000001594 0x00840052      1102
> [   30.283718] iwl3945 0000:03:00.0: 0000001596 0x00840053      1102
> [   30.283754] iwl3945 0000:03:00.0: 0000001597 0x007e0054      1102
> [   30.283788] iwl3945 0000:03:00.0: 0000001599 0x007d0055      1102
> [   30.283824] iwl3945 0000:03:00.0: 0000001600 0x00000056      1102
> [   30.283859] iwl3945 0000:03:00.0: 0000001602 0x00007050      1102
> [   30.283894] iwl3945 0000:03:00.0: 0000001604 0x00017051      1102
> [   30.283928] iwl3945 0000:03:00.0: 0000001606 0x00008204      1102
> [   30.283966] iwl3945 0000:03:00.0: 0000001608 0x00018205      1102
> [   30.284001] iwl3945 0000:03:00.0: 0000001611 0x00000001      1101
> [   30.284040] iwl3945 0000:03:00.0: 0000001612 0x008b0063      1102
> [   30.284075] iwl3945 0000:03:00.0: 0000001614 0x0000001c      1104
> [   30.284111] iwl3945 0000:03:00.0: 0000001615 0x00000002      1101
> [   30.284146] iwl3945 0000:03:00.0: 0000001616 0x0083903f      1102
> [   30.284181] iwl3945 0000:03:00.0: 0000001618 0x0001d213      1102
> [   30.284216] iwl3945 0000:03:00.0: 0000001621 0x00000002      1101
> [   30.284229] iwl3945 0000:03:00.0: 0000001622 0x0003d206      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000001624 0x0083903e      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000001628 0x00000059      1101
> [   30.284229] iwl3945 0000:03:00.0: 0000001728 0x00000013      1101
> [   30.284229] iwl3945 0000:03:00.0: 0000001746 0x00000005      1107
> [   30.284229] iwl3945 0000:03:00.0: 0000002314 0x000186f7      1110
> [   30.284229] iwl3945 0000:03:00.0: 0000002325 0xffffff4b      0454
> [   30.284229] iwl3945 0000:03:00.0: 0000002326 0x00000000      0472
> [   30.284229] iwl3945 0000:03:00.0: 0000002336 0x0000000b      0463
> [   30.284229] iwl3945 0000:03:00.0: 0000002339 0xffffff4b      1111
> [   30.284229] iwl3945 0000:03:00.0: 0000002344 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000002344 0x0000000e      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000002349 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000002353 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000002357 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000002361 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000002366 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000002370 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000002374 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000002379 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000002383 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000002387 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000002391 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000002396 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000002400 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000002404 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000002408 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000002413 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000002417 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000002421 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000002426 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000002430 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000002434 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000002438 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000002443 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000002447 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000002451 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000002455 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000002460 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000002464 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000002468 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000002473 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000002477 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000002481 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000002485 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000002490 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000002494 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000002498 0x00000001      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000002499 0x0000000f      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000002501 0x00000396      1105
> [   30.284229] iwl3945 0000:03:00.0: 0000002504 0x000004e8      1115
> [   30.284229] iwl3945 0000:03:00.0: 0000002508 0x0000000b      0463
> [   30.284229] iwl3945 0000:03:00.0: 0000002509 0x0000000b      0462
> [   30.284229] iwl3945 0000:03:00.0: 0000002520 0x0000010c      0601
> [   30.284229] iwl3945 0000:03:00.0: 0000002531 0x04240018      0401
> [   30.284229] iwl3945 0000:03:00.0: 0000002544 0x0000010f      0603
> [   30.284229] iwl3945 0000:03:00.0: 0000002613 0x00000180      0604
> [   30.284229] iwl3945 0000:03:00.0: 0000002615 0x0000019c      0610
> [   30.284229] iwl3945 0000:03:00.0: 0000002616 0x000185c8      0610
> [   30.284229] iwl3945 0000:03:00.0: 0000002617 0x00000000      0610
> [   30.284229] iwl3945 0000:03:00.0: 0000002665 0x00000500      0600
> [   30.284229] iwl3945 0000:03:00.0: 0000004165 0x000001ed      0616
> [   30.284229] iwl3945 0000:03:00.0: 0000002659 0x0001859d      0638
> [   30.284229] iwl3945 0000:03:00.0: 0000002682 0x0000001c      1101
> [   30.284229] iwl3945 0000:03:00.0: 0000002715 0x0000001a      1101
> [   30.284229] iwl3945 0000:03:00.0: 0000002742 0x000000ff      1103
> [   30.284229] iwl3945 0000:03:00.0: 0000002743 0xffff9111      1103
> [   30.284229] iwl3945 0000:03:00.0: 0000002745 0x00000010      1101
> [   30.284229] iwl3945 0000:03:00.0: 0000002763 0x00000011      1101
> [   30.284229] iwl3945 0000:03:00.0: 0000002776 0x00000000      1101
> [   30.284229] iwl3945 0000:03:00.0: 0000002777 0x00000000      1101
> [   30.284229] iwl3945 0000:03:00.0: 0000002779 0x000001d8      1101
> [   30.284229] iwl3945 0000:03:00.0: 0000002781 0x00000065      1104
> [   30.284229] iwl3945 0000:03:00.0: 0000002783 0x0000000e      1101
> [   30.284229] iwl3945 0000:03:00.0: 0000002784 0x00680034      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000002785 0x00670035      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000002787 0x007e0036      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000002789 0x007c0037      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000002790 0x00000038      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000002792 0x00840052      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000002793 0x00840053      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000002795 0x007e0054      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000002796 0x007d0055      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000002798 0x00000056      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000002799 0x00007050      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000002801 0x00017051      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000002803 0x00008204      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000002805 0x00018205      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000002808 0x00000001      1101
> [   30.284229] iwl3945 0000:03:00.0: 0000002809 0x008b0063      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000002811 0x0000001d      1104
> [   30.284229] iwl3945 0000:03:00.0: 0000002813 0x00000069      1114
> [   30.284229] iwl3945 0000:03:00.0: 0000002834 0x0000020f      0605
> [   30.284229] iwl3945 0000:03:00.0: 0000002835 0x0000026b      0621
> [   30.284229] iwl3945 0000:03:00.0: 0000002839 0x0000010b      1108
> [   30.284229] iwl3945 0000:03:00.0: 0000002841 0x0000000e      1101
> [   30.284229] iwl3945 0000:03:00.0: 0000002842 0x00680034      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000002843 0x00670035      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000002845 0x007e0036      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000002846 0x007c0037      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000002848 0x00000038      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000002849 0x00840052      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000002851 0x00840053      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000002852 0x007e0054      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000002854 0x007d0055      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000002855 0x00000056      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000002857 0x00007050      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000002859 0x00017051      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000002861 0x00008204      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000002863 0x00018205      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000002866 0x00000001      1101
> [   30.284229] iwl3945 0000:03:00.0: 0000002867 0x008b0063      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000002869 0x0000001c      1104
> [   30.284229] iwl3945 0000:03:00.0: 0000002870 0x00000002      1101
> [   30.284229] iwl3945 0000:03:00.0: 0000002871 0x0083903f      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000002873 0x0001d213      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000002876 0x00000002      1101
> [   30.284229] iwl3945 0000:03:00.0: 0000002877 0x0003d206      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000002879 0x0083903e      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000002883 0x00000059      1101
> [   30.284229] iwl3945 0000:03:00.0: 0000002983 0x00000013      1101
> [   30.284229] iwl3945 0000:03:00.0: 0000003001 0x00000005      1107
> [   30.284229] iwl3945 0000:03:00.0: 0000003569 0x00018210      1110
> [   30.284229] iwl3945 0000:03:00.0: 0000003580 0xffffff4b      0454
> [   30.284229] iwl3945 0000:03:00.0: 0000003581 0x00000000      0472
> [   30.284229] iwl3945 0000:03:00.0: 0000003591 0x0000000b      0463
> [   30.284229] iwl3945 0000:03:00.0: 0000003594 0xffffff4b      1111
> [   30.284229] iwl3945 0000:03:00.0: 0000003599 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000003599 0x0000000e      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000003604 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000003608 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000003612 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000003616 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000003621 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000003625 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000003629 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000003634 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000003638 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000003642 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000003646 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000003651 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000003655 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000003659 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000003663 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000003668 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000003672 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000003676 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000003681 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000003685 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000003689 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000003693 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000003698 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000003702 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000003706 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000003710 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000003715 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000003719 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000003723 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000003728 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000003732 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000003736 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000003740 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000003745 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000003749 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000003753 0x00000001      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000003754 0x0000000f      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000003756 0x00000396      1105
> [   30.284229] iwl3945 0000:03:00.0: 0000003759 0x000004e8      1115
> [   30.284229] iwl3945 0000:03:00.0: 0000003763 0x0000000b      0463
> [   30.284229] iwl3945 0000:03:00.0: 0000003764 0x0000000b      0462
> [   30.284229] iwl3945 0000:03:00.0: 0000003775 0x0000010c      0601
> [   30.284229] iwl3945 0000:03:00.0: 0000003786 0x04250047      0401
> [   30.284229] iwl3945 0000:03:00.0: 0000003796 0x0000010f      0603
> [   30.284229] iwl3945 0000:03:00.0: 0000003868 0x00000180      0604
> [   30.284229] iwl3945 0000:03:00.0: 0000003870 0x0000019c      0610
> [   30.284229] iwl3945 0000:03:00.0: 0000003871 0x000180e2      0610
> [   30.284229] iwl3945 0000:03:00.0: 0000003872 0x00000000      0610
> [   30.284229] iwl3945 0000:03:00.0: 0000003920 0x00000500      0600
> [   30.284229] iwl3945 0000:03:00.0: 0000005421 0x000001ed      0616
> [   30.284229] iwl3945 0000:03:00.0: 0000003914 0x000180b6      0638
> [   30.284229] iwl3945 0000:03:00.0: 0000003937 0x0000001c      1101
> [   30.284229] iwl3945 0000:03:00.0: 0000003970 0x0000001a      1101
> [   30.284229] iwl3945 0000:03:00.0: 0000003997 0x000000ff      1103
> [   30.284229] iwl3945 0000:03:00.0: 0000003998 0xffff9111      1103
> [   30.284229] iwl3945 0000:03:00.0: 0000004000 0x00000010      1101
> [   30.284229] iwl3945 0000:03:00.0: 0000004018 0x00000011      1101
> [   30.284229] iwl3945 0000:03:00.0: 0000004031 0x00000000      1101
> [   30.284229] iwl3945 0000:03:00.0: 0000004032 0x00000000      1101
> [   30.284229] iwl3945 0000:03:00.0: 0000004034 0x000001d8      1101
> [   30.284229] iwl3945 0000:03:00.0: 0000004036 0x00000065      1104
> [   30.284229] iwl3945 0000:03:00.0: 0000004038 0x0000000e      1101
> [   30.284229] iwl3945 0000:03:00.0: 0000004039 0x00680034      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000004040 0x00670035      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000004042 0x007e0036      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000004044 0x007c0037      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000004045 0x00000038      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000004047 0x00840052      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000004048 0x00840053      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000004050 0x007e0054      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000004051 0x007d0055      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000004053 0x00000056      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000004054 0x00007050      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000004056 0x00017051      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000004058 0x00008204      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000004060 0x00018205      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000004063 0x00000001      1101
> [   30.284229] iwl3945 0000:03:00.0: 0000004064 0x008b0063      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000004066 0x0000001d      1104
> [   30.284229] iwl3945 0000:03:00.0: 0000004068 0x00000069      1114
> [   30.284229] iwl3945 0000:03:00.0: 0000004089 0x0000020f      0605
> [   30.284229] iwl3945 0000:03:00.0: 0000004090 0x0000026b      0621
> [   30.284229] iwl3945 0000:03:00.0: 0000004094 0x0000010b      1108
> [   30.284229] iwl3945 0000:03:00.0: 0000004096 0x0000000e      1101
> [   30.284229] iwl3945 0000:03:00.0: 0000004097 0x00680034      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000004098 0x00670035      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000004100 0x007e0036      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000004101 0x007c0037      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000004103 0x00000038      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000004104 0x00840052      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000004106 0x00840053      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000004107 0x007e0054      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000004109 0x007d0055      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000004110 0x00000056      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000004112 0x00007050      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000004114 0x00017051      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000004116 0x00008204      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000004118 0x00018205      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000004121 0x00000001      1101
> [   30.284229] iwl3945 0000:03:00.0: 0000004122 0x008b0063      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000004124 0x0000001c      1104
> [   30.284229] iwl3945 0000:03:00.0: 0000004125 0x00000002      1101
> [   30.284229] iwl3945 0000:03:00.0: 0000004126 0x0083903f      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000004128 0x0001d213      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000004131 0x00000002      1101
> [   30.284229] iwl3945 0000:03:00.0: 0000004132 0x0003d206      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000004134 0x0083903e      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000004138 0x00000059      1101
> [   30.284229] iwl3945 0000:03:00.0: 0000004238 0x00000013      1101
> [   30.284229] iwl3945 0000:03:00.0: 0000004256 0x00000005      1107
> [   30.284229] iwl3945 0000:03:00.0: 0000004824 0x00017d29      1110
> [   30.284229] iwl3945 0000:03:00.0: 0000004835 0xffffff4a      0454
> [   30.284229] iwl3945 0000:03:00.0: 0000004836 0x00000000      0472
> [   30.284229] iwl3945 0000:03:00.0: 0000004846 0x0000000b      0463
> [   30.284229] iwl3945 0000:03:00.0: 0000004849 0xffffff4a      1111
> [   30.284229] iwl3945 0000:03:00.0: 0000004854 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000004854 0x0000000e      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000004859 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000004863 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000004867 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000004871 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000004876 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000004880 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000004884 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000004889 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000004893 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000004897 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000004901 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000004906 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000004910 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000004914 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000004918 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000004923 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000004927 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000004931 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000004936 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000004940 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000004944 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000004948 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000004953 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000004957 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000004961 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000004965 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000004970 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000004974 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000004978 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000004983 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000004987 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000004991 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000004995 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000005000 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000005004 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000005008 0x00000001      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000005009 0x0000000f      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000005011 0x00000396      1105
> [   30.284229] iwl3945 0000:03:00.0: 0000005014 0x000004e8      1115
> [   30.284229] iwl3945 0000:03:00.0: 0000005018 0x0000000b      0463
> [   30.284229] iwl3945 0000:03:00.0: 0000005019 0x0000000b      0462
> [   30.284229] iwl3945 0000:03:00.0: 0000005030 0x0000010c      0601
> [   30.284229] iwl3945 0000:03:00.0: 0000005041 0x04260047      0401
> [   30.284229] iwl3945 0000:03:00.0: 0000005051 0x0000010f      0603
> [   30.284229] iwl3945 0000:03:00.0: 0000005123 0x00000180      0604
> [   30.284229] iwl3945 0000:03:00.0: 0000005125 0x0000019c      0610
> [   30.284229] iwl3945 0000:03:00.0: 0000005126 0x00017bfa      0610
> [   30.284229] iwl3945 0000:03:00.0: 0000005127 0x00000000      0610
> [   30.284229] iwl3945 0000:03:00.0: 0000005175 0x00000500      0600
> [   30.284229] iwl3945 0000:03:00.0: 0000006677 0x000001ed      0616
> [   30.284229] iwl3945 0000:03:00.0: 0000005169 0x00017bcf      0638
> [   30.284229] iwl3945 0000:03:00.0: 0000005192 0x0000001c      1101
> [   30.284229] iwl3945 0000:03:00.0: 0000005225 0x0000001a      1101
> [   30.284229] iwl3945 0000:03:00.0: 0000005252 0x000000ff      1103
> [   30.284229] iwl3945 0000:03:00.0: 0000005253 0xffff9111      1103
> [   30.284229] iwl3945 0000:03:00.0: 0000005255 0x00000010      1101
> [   30.284229] iwl3945 0000:03:00.0: 0000005273 0x00000011      1101
> [   30.284229] iwl3945 0000:03:00.0: 0000005286 0x00000000      1101
> [   30.284229] iwl3945 0000:03:00.0: 0000005287 0x00000000      1101
> [   30.284229] iwl3945 0000:03:00.0: 0000005289 0x000001d8      1101
> [   30.284229] iwl3945 0000:03:00.0: 0000005291 0x00000065      1104
> [   30.284229] iwl3945 0000:03:00.0: 0000005293 0x0000000e      1101
> [   30.284229] iwl3945 0000:03:00.0: 0000005294 0x00680034      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000005295 0x00670035      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000005297 0x007e0036      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000005299 0x007c0037      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000005300 0x00000038      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000005302 0x00840052      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000005303 0x00840053      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000005305 0x007e0054      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000005306 0x007d0055      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000005308 0x00000056      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000005309 0x00007050      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000005311 0x00017051      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000005313 0x00008204      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000005315 0x00018205      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000005318 0x00000001      1101
> [   30.284229] iwl3945 0000:03:00.0: 0000005319 0x008b0063      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000005321 0x0000001d      1104
> [   30.284229] iwl3945 0000:03:00.0: 0000005323 0x00000069      1114
> [   30.284229] iwl3945 0000:03:00.0: 0000005344 0x0000020f      0605
> [   30.284229] iwl3945 0000:03:00.0: 0000005345 0x0000026b      0621
> [   30.284229] iwl3945 0000:03:00.0: 0000005349 0x0000010b      1108
> [   30.284229] iwl3945 0000:03:00.0: 0000005351 0x0000000e      1101
> [   30.284229] iwl3945 0000:03:00.0: 0000005352 0x00680034      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000005353 0x00670035      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000005355 0x007e0036      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000005356 0x007c0037      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000005358 0x00000038      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000005359 0x00840052      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000005361 0x00840053      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000005362 0x007e0054      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000005364 0x007d0055      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000005365 0x00000056      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000005367 0x00007050      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000005369 0x00017051      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000005371 0x00008204      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000005373 0x00018205      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000005376 0x00000001      1101
> [   30.284229] iwl3945 0000:03:00.0: 0000005377 0x008b0063      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000005379 0x0000001c      1104
> [   30.284229] iwl3945 0000:03:00.0: 0000005381 0x00000002      1101
> [   30.284229] iwl3945 0000:03:00.0: 0000005381 0x0083903f      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000005383 0x0001d213      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000005387 0x00000002      1101
> [   30.284229] iwl3945 0000:03:00.0: 0000005387 0x0003d206      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000005389 0x0083903e      1102
> [   30.284229] iwl3945 0000:03:00.0: 0000005393 0x00000059      1101
> [   30.284229] iwl3945 0000:03:00.0: 0000005493 0x00000013      1101
> [   30.284229] iwl3945 0000:03:00.0: 0000005511 0x00000005      1107
> [   30.284229] iwl3945 0000:03:00.0: 0000006079 0x00017842      1110
> [   30.284229] iwl3945 0000:03:00.0: 0000006090 0xffffff4b      0454
> [   30.284229] iwl3945 0000:03:00.0: 0000006091 0x00000000      0472
> [   30.284229] iwl3945 0000:03:00.0: 0000006101 0x0000000b      0463
> [   30.284229] iwl3945 0000:03:00.0: 0000006104 0xffffff4b      1111
> [   30.284229] iwl3945 0000:03:00.0: 0000006109 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000006109 0x0000000e      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000006114 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000006118 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000006122 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000006126 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000006131 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000006135 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000006139 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000006144 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000006148 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000006152 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000006156 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000006161 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000006165 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000006169 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000006173 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000006178 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000006182 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000006186 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000006191 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000006195 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000006199 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000006203 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000006208 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000006212 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000006216 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000006220 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000006225 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000006229 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000006233 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000006238 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000006242 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000006246 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000006250 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000006255 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000006259 0x00000000      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000006263 0x00000001      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000006264 0x0000000f      1106
> [   30.284229] iwl3945 0000:03:00.0: 0000006266 0x00000396      1105
> [   30.284229] iwl3945 0000:03:00.0: 0000006269 0x000004e8      1115
> [   30.284229] iwl3945 0000:03:00.0: 0000006273 0x0000000b      0463
> [   30.284229] iwl3945 0000:03:00.0: 0000006274 0x0000000b      0462
> [   30.284229] iwl3945 0000:03:00.0: 0000006285 0x0000010c      0601
> [   30.284229] iwl3945 0000:03:00.0: 0000006447 0x00010087      0250
> [   30.284229] iwl3945 0000:03:00.0: 0000006453 0x0000001c      0218
> [   30.284229] iwl3945 0000:03:00.0: 0000207282 0x00000002      0123
> [   30.284229] iwl3945 0000:03:00.0: 0000207284 0x00000100      0125
> [   30.284229] ieee80211 phy0: I iwl3945_print_rx_config_cmd RX CONFIG:
> [   30.284229] ieee80211 phy0: I iwl3945_print_rx_config_cmd u16 channel: 0xb
> [   30.284229] ieee80211 phy0: I iwl3945_print_rx_config_cmd u32 flags: 0x00008005
> [   30.284229] ieee80211 phy0: I iwl3945_print_rx_config_cmd u32 filter_flags: 0x00000004
> [   30.284229] ieee80211 phy0: I iwl3945_print_rx_config_cmd u8 dev_type: 0x3
> [   30.284229] ieee80211 phy0: I iwl3945_print_rx_config_cmd u8 ofdm_basic_rates: 0x15
> [   30.284229] ieee80211 phy0: I iwl3945_print_rx_config_cmd u8 cck_basic_rates: 0x03
> [   30.284229] ieee80211 phy0: I iwl3945_print_rx_config_cmd u8[6] node_addr: 00:1f:3c:20:a1:6e
> [   30.284229] ieee80211 phy0: I iwl3945_print_rx_config_cmd u8[6] bssid_addr: 00:30:bd:c0:90:24
> [   30.284229] ieee80211 phy0: I iwl3945_print_rx_config_cmd u16 assoc_id: 0x0
> [   30.284229] ieee80211 phy0: I iwl3945_irq_handle_error Restarting adapter due to uCode error.
> [   30.284229] ieee80211 phy0: I iwl3945_rx_handle r = 154, i = 153, REPLY_ERROR, 0x02
> [   30.284229] iwl3945 0000:03:00.0: Error Reply type 0x00000005 cmd REPLY_PHY_CALIBRATION_CMD (0xB0) seq 0x013A ser 0x004E0000
> [   30.325406] ieee80211 phy0: U iwl3945_verify_inst_sparse ucode inst image size is 900
> [   30.325511] ieee80211 phy0: U iwl3945_verify_inst_sparse ucode inst image size is 2672
> [   30.325807] ieee80211 phy0: U iwl3945_verify_ucode Initialize uCode is good in inst SRAM
> [   30.325866] ieee80211 phy0: U iwl3945_set_ucode_ptrs Runtime uCode pointers are set.
> [   30.330221] ieee80211 phy0: I iwl3945_rx_handle r = 2, i = 1, REPLY_ALIVE, 0x01
> [   30.330234] ieee80211 phy0: I iwl3945_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x0
> [   30.330242] ieee80211 phy0: I iwl3945_rx_reply_alive Runtime Alive received.
> [   30.330290] ieee80211 phy0: I iwl3945_disable_events Selected uCode log events may be disabled
> [   30.330298] ieee80211 phy0: I iwl3945_disable_events   by writing "1"s into disable bitmap
> [   30.330306] ieee80211 phy0: I iwl3945_disable_events   in SRAM at 0x8022c8, size 47 u32s
> [   30.340029] ieee80211 phy0: U iwl3945_alive_start Runtime Alive received.
> [   30.340041] ieee80211 phy0: U iwl3945_verify_inst_sparse ucode inst image size is 900
> [   30.340127] ieee80211 phy0: U iwl3945_verify_inst_sparse ucode inst image size is 2672
> [   30.340213] ieee80211 phy0: U iwl3945_verify_inst_sparse ucode inst image size is 80684
> [   30.347859] ieee80211 phy0: U iwl3945_verify_ucode Runtime uCode is good in inst SRAM
> [   30.347896] ieee80211 phy0: U iwl3945_alive_start RFKILL status: 0x1
> [   30.347927] ieee80211 phy0: U iwl3945_update_power_cmd Flags value = 0x00000009
> [   30.347935] ieee80211 phy0: U iwl3945_update_power_cmd Tx timeout = 102400
> [   30.347942] ieee80211 phy0: U iwl3945_update_power_cmd Rx timeout = 51200
> [   30.347950] ieee80211 phy0: U iwl3945_update_power_cmd Sleep interval vector = { 1 , 1 , 1 , 1 , 1 }
> [   30.347964] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command POWER_TABLE_CMD (#77), seq: 0x0400, 36 bytes at 0[0]:4
> [   30.348059] ieee80211 phy0: I iwl3945_rx_handle r 3 i 2 No handler needed for POWER_TABLE_CMD, 0x77
> [   30.348107] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_BT_CONFIG (#9b), seq: 0x0401, 16 bytes at 1[1]:4
> [   30.348126] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
> [   30.349922] ieee80211 phy0: I iwl3945_rx_handle r 4 i 3 No handler needed for REPLY_BT_CONFIG, 0x9b
> [   30.349981] ieee80211 phy0: U iwl3945_commit_rxon Sending RXON
> [   30.349983] * without RXON_FILTER_ASSOC_MSK
> [   30.349985] * channel = 11
> [   30.349986] * bssid = 00:00:00:00:00:00
> [   30.350005] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x0402, 48 bytes at 2[2]:4
> [   30.350020] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
> [   30.352902] ieee80211 phy0: I iwl3945_rx_handle r 5 i 4 No handler needed for REPLY_RXON, 0x10
> [   30.352963] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0d
> [   30.352974] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0f
> [   30.352982] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x05
> [   30.352990] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x07
> [   30.352998] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x09
> [   30.353032] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0b
> [   30.353041] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x01
> [   30.353049] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x03
> [   30.353057] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x0a
> [   30.353066] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x14
> [   30.353074] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x37
> [   30.353082] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x6e
> [   30.353094] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0403, 56 bytes at 3[3]:4
> [   30.353109] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
> [   30.355726] ieee80211 phy0: I iwl3945_rx_handle r 6 i 5 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
> [   30.355757] ieee80211 phy0: U iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
> [   30.355769] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0404, 68 bytes at 4[4]:4
> [   30.355784] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
> [   30.358461] ieee80211 phy0: I iwl3945_rx_handle r = 7, i = 6, REPLY_ADD_STA, 0x18
> [   30.358514] ieee80211 phy0: U iwl3945_send_add_station REPLY_ADD_STA PASSED
> [   30.358531] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0405, 56 bytes at 5[5]:4
> [   30.358546] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
> [   30.361254] ieee80211 phy0: I iwl3945_rx_handle r 8 i 7 No handler needed for REPLY_RATE_SCALE, 0x47
> [   30.361286] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0406, 56 bytes at 6[6]:4
> [   30.361301] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
> [   30.364015] ieee80211 phy0: I iwl3945_rx_handle r 9 i 8 No handler needed for REPLY_RATE_SCALE, 0x47
> [   30.364062] ieee80211 phy0: U iwl3945_hw_reg_txpower_get_temperature Temperature: 79
> [   30.364072] ieee80211 phy0: U is_temp_calib_needed Getting warmer, delta 9,
> [   30.364078] ieee80211 phy0: U is_temp_calib_needed Timed thermal calib needed
> [   30.364099] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x0d
> [   30.364107] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x0f
> [   30.364115] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x05
> [   30.364123] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x07
> [   30.364131] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x09
> [   30.364139] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x0b
> [   30.364148] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x01
> [   30.364155] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x03
> [   30.364164] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 139 dsp 116 rate code 0x0a
> [   30.364172] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 139 dsp 116 rate code 0x14
> [   30.364180] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 139 dsp 116 rate code 0x37
> [   30.364189] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 139 dsp 116 rate code 0x6e
> [   30.364200] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0407, 56 bytes at 7[7]:4
> [   30.364216] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
> [   30.366834] ieee80211 phy0: I iwl3945_rx_handle r 10 i 9 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
> [   30.366964] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0408, 12 bytes at 8[8]:4
> [   30.366982] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
> [   30.367106] ieee80211 phy0: U iwl3945_alive_start ALIVE processing complete.
> [   30.369973] ieee80211 phy0: I iwl3945_rx_handle r 11 i 10 No handler needed for REPLY_LEDS_CMD, 0x48
> [   30.476079] ieee80211 phy0: I iwl3945_mac_tx enter
> [   30.476150] ieee80211 phy0: I iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
> [   30.476164] ieee80211 phy0: I iwl3945_mac_tx leave
> [   30.486597] ieee80211 phy0: I iwl3945_rx_handle r = 12, i = 11, REPLY_TX, 0x1c
> [   48.511051] ieee80211 phy0: U iwl3945_mac_hw_scan enter
> [   48.511070] ieee80211 phy0: U iwl3945_scan_initiate Starting scan...
> [   48.511084] ieee80211 phy0: U iwl3945_mac_hw_scan leave
> [   48.511098] ieee80211 phy0: U iwl3945_bg_request_scan Kicking off one indirect scan.
> [   48.511110] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 1 [ACTIVE 39]
> [   48.511118] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 2 [ACTIVE 39]
> [   48.511126] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 3 [ACTIVE 39]
> [   48.511134] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 4 [ACTIVE 39]
> [   48.511142] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 5 [ACTIVE 39]
> [   48.511150] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 6 [ACTIVE 39]
> [   48.511157] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 7 [ACTIVE 39]
> [   48.511165] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 8 [ACTIVE 39]
> [   48.511173] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 9 [ACTIVE 39]
> [   48.511180] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 10 [ACTIVE 39]
> [   48.511189] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 11 [ACTIVE 39]
> [   48.511197] ieee80211 phy0: U iwl3945_get_channels_for_scan total channels to scan 11 
> [   48.511213] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x4409, 351 bytes at 9[32]:4
> [   49.008100] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms
> [   49.008121] ieee80211 phy0: U iwl3945_bg_scan_completed SCAN complete scan
> [   49.008147] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x0d
> [   49.008155] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x0f
> [   49.008163] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x05
> [   49.008171] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x07
> [   49.008179] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x09
> [   49.008187] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x0b
> [   49.008194] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x01
> [   49.008203] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x03
> [   49.008211] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 139 dsp 116 rate code 0x0a
> [   49.008219] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 139 dsp 116 rate code 0x14
> [   49.008228] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 139 dsp 116 rate code 0x37
> [   49.008236] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 139 dsp 116 rate code 0x6e
> [   49.008307] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x040A, 56 bytes at 10[10]:4
> [   49.508110] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms
> [   65.550924] ieee80211 phy0: U iwl3945_mac_hw_scan enter
> [   65.550957] ieee80211 phy0: U iwl3945_mac_hw_scan direct scan for WLAN [4]
> [   65.550960]  <3>ieee80211 phy0: U iwl3945_scan_initiate Starting scan...
> [   65.550982] ieee80211 phy0: U iwl3945_mac_hw_scan leave
> [   65.550997] ieee80211 phy0: U iwl3945_bg_request_scan Kicking off one direct scan for 'WLAN'
> [   65.551012] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 1 [ACTIVE 42]
> [   65.551020] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 2 [ACTIVE 42]
> [   65.551028] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 3 [ACTIVE 42]
> [   65.551036] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 4 [ACTIVE 42]
> [   65.551044] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 5 [ACTIVE 42]
> [   65.551053] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 6 [ACTIVE 42]
> [   65.551060] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 7 [ACTIVE 42]
> [   65.551068] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 8 [ACTIVE 42]
> [   65.551076] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 9 [ACTIVE 42]
> [   65.551084] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 10 [ACTIVE 42]
> [   65.551092] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 11 [ACTIVE 42]
> [   65.551101] ieee80211 phy0: U iwl3945_get_channels_for_scan total channels to scan 11 
> [   65.551173] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x440B, 351 bytes at 11[32]:4
> [   66.052122] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms
> [   66.052149] ieee80211 phy0: U iwl3945_bg_scan_completed SCAN complete scan
> [   66.052178] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x0d
> [   66.052187] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x0f
> [   66.052196] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x05
> [   66.052204] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x07
> [   66.052212] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x09
> [   66.052220] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x0b
> [   66.052229] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x01
> [   66.052237] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x03
> [   66.052246] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 139 dsp 116 rate code 0x0a
> [   66.052255] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 139 dsp 116 rate code 0x14
> [   66.052264] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 139 dsp 116 rate code 0x37
> [   66.052272] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 139 dsp 116 rate code 0x6e
> [   66.052287] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x040C, 56 bytes at 12[12]:4
> [   66.548122] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms
> [   71.053874] ieee80211 phy0: U iwl3945_mac_hw_scan enter
> [   71.053896] ieee80211 phy0: U iwl3945_scan_initiate Starting scan...
> [   71.053909] ieee80211 phy0: U iwl3945_mac_hw_scan leave
> [   71.053923] ieee80211 phy0: U iwl3945_bg_request_scan Kicking off one indirect scan.
> [   71.053935] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 1 [ACTIVE 39]
> [   71.053943] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 2 [ACTIVE 39]
> [   71.053951] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 3 [ACTIVE 39]
> [   71.053958] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 4 [ACTIVE 39]
> [   71.053966] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 5 [ACTIVE 39]
> [   71.053974] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 6 [ACTIVE 39]
> [   71.053996] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 7 [ACTIVE 39]
> [   71.054004] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 8 [ACTIVE 39]
> [   71.054011] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 9 [ACTIVE 39]
> [   71.054019] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 10 [ACTIVE 39]
> [   71.054027] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 11 [ACTIVE 39]
> [   71.054034] ieee80211 phy0: U iwl3945_get_channels_for_scan total channels to scan 11 
> [   71.054050] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x440D, 351 bytes at 13[32]:4
> [   71.552119] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms
> [   71.552137] ieee80211 phy0: U iwl3945_bg_scan_completed SCAN complete scan
> [   71.552159] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x0d
> [   71.552168] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x0f
> [   71.552176] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x05
> [   71.552184] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x07
> [   71.552192] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x09
> [   71.552199] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x0b
> [   71.552207] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x01
> [   71.552215] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x03
> [   71.552222] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 139 dsp 116 rate code 0x0a
> [   71.552230] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 139 dsp 116 rate code 0x14
> [   71.552238] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 139 dsp 116 rate code 0x37
> [   71.552248] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 139 dsp 116 rate code 0x6e
> [   71.552262] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x040E, 56 bytes at 14[14]:4
> [   72.052094] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms
> [   76.553935] ieee80211 phy0: U iwl3945_mac_hw_scan enter
> [   76.553957] ieee80211 phy0: U iwl3945_mac_hw_scan direct scan for WLAN [4]
> [   76.553960]  <3>ieee80211 phy0: U iwl3945_scan_initiate Starting scan...
> [   76.553981] ieee80211 phy0: U iwl3945_mac_hw_scan leave
> [   76.553995] ieee80211 phy0: U iwl3945_bg_request_scan Kicking off one direct scan for 'WLAN'
> [   76.554007] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 1 [ACTIVE 42]
> [   76.554014] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 2 [ACTIVE 42]
> [   76.554022] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 3 [ACTIVE 42]
> [   76.554029] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 4 [ACTIVE 42]
> [   76.554037] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 5 [ACTIVE 42]
> [   76.554044] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 6 [ACTIVE 42]
> [   76.554052] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 7 [ACTIVE 42]
> [   76.554060] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 8 [ACTIVE 42]
> [   76.554069] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 9 [ACTIVE 42]
> [   76.554077] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 10 [ACTIVE 42]
> [   76.554085] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 11 [ACTIVE 42]
> [   76.554093] ieee80211 phy0: U iwl3945_get_channels_for_scan total channels to scan 11 
> [   76.554165] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x440F, 351 bytes at 15[32]:4
> [   77.052096] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms
> [   77.052109] ieee80211 phy0: U iwl3945_bg_scan_completed SCAN complete scan
> [   77.052130] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x0d
> [   77.052139] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x0f
> [   77.052146] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x05
> [   77.052154] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x07
> [   77.052162] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x09
> [   77.052169] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x0b
> [   77.052177] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x01
> [   77.052184] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x03
> [   77.052192] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 139 dsp 116 rate code 0x0a
> [   77.052200] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 139 dsp 116 rate code 0x14
> [   77.052209] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 139 dsp 116 rate code 0x37
> [   77.052216] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 139 dsp 116 rate code 0x6e
> [   77.052229] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0410, 56 bytes at 16[16]:4
> [   77.552109] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms
> [   82.053669] ieee80211 phy0: U iwl3945_mac_hw_scan enter
> [   82.053688] ieee80211 phy0: U iwl3945_scan_initiate Starting scan...
> [   82.053702] ieee80211 phy0: U iwl3945_mac_hw_scan leave
> [   82.053716] ieee80211 phy0: U iwl3945_bg_request_scan Kicking off one indirect scan.
> [   82.053727] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 1 [ACTIVE 39]
> [   82.053735] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 2 [ACTIVE 39]
> [   82.053743] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 3 [ACTIVE 39]
> [   82.053751] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 4 [ACTIVE 39]
> [   82.053760] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 5 [ACTIVE 39]
> [   82.053767] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 6 [ACTIVE 39]
> [   82.053775] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 7 [ACTIVE 39]
> [   82.053782] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 8 [ACTIVE 39]
> [   82.053790] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 9 [ACTIVE 39]
> [   82.053798] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 10 [ACTIVE 39]
> [   82.053807] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 11 [ACTIVE 39]
> [   82.053871] ieee80211 phy0: U iwl3945_get_channels_for_scan total channels to scan 11 
> [   82.053886] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x4411, 351 bytes at 17[32]:4
> [   82.552135] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms
> [   82.552149] ieee80211 phy0: U iwl3945_bg_scan_completed SCAN complete scan
> [   82.552170] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x0d
> [   82.552178] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x0f
> [   82.552186] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x05
> [   82.552194] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x07
> [   82.552202] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x09
> [   82.552210] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x0b
> [   82.552217] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x01
> [   82.552226] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x03
> [   82.552233] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 139 dsp 116 rate code 0x0a
> [   82.552241] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 139 dsp 116 rate code 0x14
> [   82.552250] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 139 dsp 116 rate code 0x37
> [   82.552258] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 139 dsp 116 rate code 0x6e
> [   82.552271] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0412, 56 bytes at 18[18]:4
> [   83.052139] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms
> [   87.553651] ieee80211 phy0: U iwl3945_mac_hw_scan enter
> [   87.553671] ieee80211 phy0: U iwl3945_mac_hw_scan direct scan for WLAN [4]
> [   87.553674]  <3>ieee80211 phy0: U iwl3945_scan_initiate Starting scan...
> [   87.553694] ieee80211 phy0: U iwl3945_mac_hw_scan leave
> [   87.553708] ieee80211 phy0: U iwl3945_bg_request_scan Kicking off one direct scan for 'WLAN'
> [   87.553720] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 1 [ACTIVE 42]
> [   87.553728] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 2 [ACTIVE 42]
> [   87.553736] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 3 [ACTIVE 42]
> [   87.553743] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 4 [ACTIVE 42]
> [   87.553751] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 5 [ACTIVE 42]
> [   87.553758] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 6 [ACTIVE 42]
> [   87.553766] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 7 [ACTIVE 42]
> [   87.553791] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 8 [ACTIVE 42]
> [   87.553799] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 9 [ACTIVE 42]
> [   87.553807] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 10 [ACTIVE 42]
> [   87.553815] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 11 [ACTIVE 42]
> [   87.553822] ieee80211 phy0: U iwl3945_get_channels_for_scan total channels to scan 11 
> [   87.553838] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x4413, 351 bytes at 19[32]:4
> [   88.052118] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms
> [   88.052132] ieee80211 phy0: U iwl3945_bg_scan_completed SCAN complete scan
> [   88.052153] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x0d
> [   88.052162] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x0f
> [   88.052170] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x05
> [   88.052178] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x07
> [   88.052186] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x09
> [   88.052193] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x0b
> [   88.052201] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x01
> [   88.052208] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x03
> [   88.052216] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 139 dsp 116 rate code 0x0a
> [   88.052224] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 139 dsp 116 rate code 0x14
> [   88.052232] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 139 dsp 116 rate code 0x37
> [   88.052240] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 139 dsp 116 rate code 0x6e
> [   88.052253] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0414, 56 bytes at 20[20]:4
> [   88.552111] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms
> [   90.364122] ieee80211 phy0: U iwl3945_hw_reg_txpower_get_temperature Temperature: 78
> [   90.364135] ieee80211 phy0: U is_temp_calib_needed Getting cooler, delta -1,
> [   90.364142] ieee80211 phy0: U is_temp_calib_needed Timed thermal calib not needed
> [   93.053648] ieee80211 phy0: U iwl3945_mac_hw_scan enter
> [   93.053667] ieee80211 phy0: U iwl3945_scan_initiate Starting scan...
> [   93.053680] ieee80211 phy0: U iwl3945_mac_hw_scan leave
> [   93.053694] ieee80211 phy0: U iwl3945_bg_request_scan Kicking off one indirect scan.
> [   93.053716] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 1 [ACTIVE 39]
> [   93.053724] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 2 [ACTIVE 39]
> [   93.053731] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 3 [ACTIVE 39]
> [   93.053738] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 4 [ACTIVE 39]
> [   93.053746] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 5 [ACTIVE 39]
> [   93.053753] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 6 [ACTIVE 39]
> [   93.053760] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 7 [ACTIVE 39]
> [   93.053769] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 8 [ACTIVE 39]
> [   93.053777] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 9 [ACTIVE 39]
> [   93.053784] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 10 [ACTIVE 39]
> [   93.053793] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 11 [ACTIVE 39]
> [   93.053800] ieee80211 phy0: U iwl3945_get_channels_for_scan total channels to scan 11 
> [   93.053815] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x4415, 351 bytes at 21[32]:4
> [   93.552121] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms
> [   93.552134] ieee80211 phy0: U iwl3945_bg_scan_completed SCAN complete scan
> [   93.552155] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x0d
> [   93.552164] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x0f
> [   93.552172] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x05
> [   93.552180] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x07
> [   93.552187] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x09
> [   93.552195] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x0b
> [   93.552203] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x01
> [   93.552211] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x03
> [   93.552218] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 139 dsp 116 rate code 0x0a
> [   93.552226] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 139 dsp 116 rate code 0x14
> [   93.552234] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 139 dsp 116 rate code 0x37
> [   93.552243] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 139 dsp 116 rate code 0x6e
> [   93.552255] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0416, 56 bytes at 22[22]:4
> [   94.052138] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms
> [   98.553655] ieee80211 phy0: U iwl3945_mac_hw_scan enter
> [   98.553677] ieee80211 phy0: U iwl3945_mac_hw_scan direct scan for WLAN [4]
> [   98.553680]  <3>ieee80211 phy0: U iwl3945_scan_initiate Starting scan...
> [   98.553701] ieee80211 phy0: U iwl3945_mac_hw_scan leave
> [   98.553715] ieee80211 phy0: U iwl3945_bg_request_scan Kicking off one direct scan for 'WLAN'
> [   98.553739] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 1 [ACTIVE 42]
> [   98.553747] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 2 [ACTIVE 42]
> [   98.553755] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 3 [ACTIVE 42]
> [   98.553762] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 4 [ACTIVE 42]
> [   98.553769] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 5 [ACTIVE 42]
> [   98.553777] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 6 [ACTIVE 42]
> [   98.553784] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 7 [ACTIVE 42]
> [   98.553792] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 8 [ACTIVE 42]
> [   98.553799] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 9 [ACTIVE 42]
> [   98.553807] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 10 [ACTIVE 42]
> [   98.553815] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 11 [ACTIVE 42]
> [   98.553822] ieee80211 phy0: U iwl3945_get_channels_for_scan total channels to scan 11 
> [   98.553838] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x4417, 351 bytes at 23[32]:4
> [   99.052140] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms
> [   99.052155] ieee80211 phy0: U iwl3945_bg_scan_completed SCAN complete scan
> [   99.052176] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x0d
> [   99.052185] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x0f
> [   99.052193] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x05
> [   99.052200] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x07
> [   99.052208] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x09
> [   99.052216] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x0b
> [   99.052255] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x01
> [   99.052264] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x03
> [   99.052272] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 139 dsp 116 rate code 0x0a
> [   99.052280] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 139 dsp 116 rate code 0x14
> [   99.052288] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 139 dsp 116 rate code 0x37
> [   99.052296] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 139 dsp 116 rate code 0x6e
> [   99.052308] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0418, 56 bytes at 24[24]:4
> [   99.552140] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms
> [  104.053572] ieee80211 phy0: U iwl3945_mac_hw_scan enter
> [  104.053590] ieee80211 phy0: U iwl3945_scan_initiate Starting scan...
> [  104.053604] ieee80211 phy0: U iwl3945_mac_hw_scan leave
> [  104.053618] ieee80211 phy0: U iwl3945_bg_request_scan Kicking off one indirect scan.
> [  104.053641] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 1 [ACTIVE 39]
> [  104.053649] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 2 [ACTIVE 39]
> [  104.053656] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 3 [ACTIVE 39]
> [  104.053663] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 4 [ACTIVE 39]
> [  104.053670] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 5 [ACTIVE 39]
> [  104.053677] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 6 [ACTIVE 39]
> [  104.053685] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 7 [ACTIVE 39]
> [  104.053693] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 8 [ACTIVE 39]
> [  104.053700] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 9 [ACTIVE 39]
> [  104.053707] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 10 [ACTIVE 39]
> [  104.053715] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 11 [ACTIVE 39]
> [  104.053723] ieee80211 phy0: U iwl3945_get_channels_for_scan total channels to scan 11 
> [  104.053737] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x4419, 351 bytes at 25[32]:4
> [  104.552138] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms
> [  104.552152] ieee80211 phy0: U iwl3945_bg_scan_completed SCAN complete scan
> [  104.552173] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x0d
> [  104.552182] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x0f
> [  104.552190] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x05
> [  104.552198] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x07
> [  104.552205] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x09
> [  104.552213] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x0b
> [  104.552220] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x01
> [  104.552228] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x03
> [  104.552235] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 139 dsp 116 rate code 0x0a
> [  104.552243] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 139 dsp 116 rate code 0x14
> [  104.552251] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 139 dsp 116 rate code 0x37
> [  104.552260] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 139 dsp 116 rate code 0x6e
> [  104.552274] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x041A, 56 bytes at 26[26]:4
> [  105.052094] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms
> [  109.553704] ieee80211 phy0: U iwl3945_mac_hw_scan enter
> [  109.553723] ieee80211 phy0: U iwl3945_mac_hw_scan direct scan for WLAN [4]
> [  109.553726]  <3>ieee80211 phy0: U iwl3945_scan_initiate Starting scan...
> [  109.553746] ieee80211 phy0: U iwl3945_mac_hw_scan leave
> [  109.553771] ieee80211 phy0: U iwl3945_bg_request_scan Kicking off one direct scan for 'WLAN'
> [  109.553783] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 1 [ACTIVE 42]
> [  109.553790] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 2 [ACTIVE 42]
> [  109.553797] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 3 [ACTIVE 42]
> [  109.553804] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 4 [ACTIVE 42]
> [  109.553812] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 5 [ACTIVE 42]
> [  109.553819] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 6 [ACTIVE 42]
> [  109.553827] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 7 [ACTIVE 42]
> [  109.553835] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 8 [ACTIVE 42]
> [  109.553843] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 9 [ACTIVE 42]
> [  109.553850] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 10 [ACTIVE 42]
> [  109.553857] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 11 [ACTIVE 42]
> [  109.553865] ieee80211 phy0: U iwl3945_get_channels_for_scan total channels to scan 11 
> [  109.553880] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x441B, 351 bytes at 27[32]:4
> [  110.052111] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms
> [  110.052126] ieee80211 phy0: U iwl3945_bg_scan_completed SCAN complete scan
> [  110.052148] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x0d
> [  110.052156] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x0f
> [  110.052164] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x05
> [  110.052172] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x07
> [  110.052179] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x09
> [  110.052187] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x0b
> [  110.052195] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x01
> [  110.052203] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x03
> [  110.052211] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 139 dsp 116 rate code 0x0a
> [  110.052219] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 139 dsp 116 rate code 0x14
> [  110.052227] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 139 dsp 116 rate code 0x37
> [  110.052236] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 139 dsp 116 rate code 0x6e
> [  110.052249] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x041C, 56 bytes at 28[28]:4
> [  110.552108] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms
> [  115.053656] ieee80211 phy0: U iwl3945_mac_hw_scan enter
> [  115.053675] ieee80211 phy0: U iwl3945_scan_initiate Starting scan...
> [  115.053688] ieee80211 phy0: U iwl3945_mac_hw_scan leave
> [  115.053702] ieee80211 phy0: U iwl3945_bg_request_scan Kicking off one indirect scan.
> [  115.053713] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 1 [ACTIVE 39]
> [  115.053721] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 2 [ACTIVE 39]
> [  115.053729] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 3 [ACTIVE 39]
> [  115.053736] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 4 [ACTIVE 39]
> [  115.053743] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 5 [ACTIVE 39]
> [  115.053751] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 6 [ACTIVE 39]
> [  115.053758] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 7 [ACTIVE 39]
> [  115.053765] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 8 [ACTIVE 39]
> [  115.053773] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 9 [ACTIVE 39]
> [  115.053782] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 10 [ACTIVE 39]
> [  115.053791] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 11 [ACTIVE 39]
> [  115.053799] ieee80211 phy0: U iwl3945_get_channels_for_scan total channels to scan 11 
> [  115.053814] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x441D, 351 bytes at 29[32]:4
> [  115.552122] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms
> [  115.552136] ieee80211 phy0: U iwl3945_bg_scan_completed SCAN complete scan
> [  115.552158] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x0d
> [  115.552167] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x0f
> [  115.552175] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x05
> [  115.552183] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x07
> [  115.552191] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x09
> [  115.552200] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x0b
> [  115.552207] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x01
> [  115.552216] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x03
> [  115.552224] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 139 dsp 116 rate code 0x0a
> [  115.552232] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 139 dsp 116 rate code 0x14
> [  115.552240] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 139 dsp 116 rate code 0x37
> [  115.552249] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 139 dsp 116 rate code 0x6e
> [  115.552261] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x041E, 56 bytes at 30[30]:4
> [  116.052119] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms
> [  120.553648] ieee80211 phy0: U iwl3945_mac_hw_scan enter
> [  120.553663] ieee80211 phy0: U iwl3945_mac_hw_scan direct scan for WLAN [4]
> [  120.553666]  <3>ieee80211 phy0: U iwl3945_scan_initiate Starting scan...
> [  120.553685] ieee80211 phy0: U iwl3945_mac_hw_scan leave
> [  120.553697] ieee80211 phy0: U iwl3945_bg_request_scan Kicking off one direct scan for 'WLAN'
> [  120.553707] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 1 [ACTIVE 42]
> [  120.553715] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 2 [ACTIVE 42]
> [  120.553722] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 3 [ACTIVE 42]
> [  120.553729] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 4 [ACTIVE 42]
> [  120.553736] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 5 [ACTIVE 42]
> [  120.553743] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 6 [ACTIVE 42]
> [  120.553765] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 7 [ACTIVE 42]
> [  120.553772] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 8 [ACTIVE 42]
> [  120.553780] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 9 [ACTIVE 42]
> [  120.553787] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 10 [ACTIVE 42]
> [  120.553794] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 11 [ACTIVE 42]
> [  120.553801] ieee80211 phy0: U iwl3945_get_channels_for_scan total channels to scan 11 
> [  120.553815] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x441F, 351 bytes at 31[32]:4
> [  121.052164] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms
> [  121.052186] ieee80211 phy0: U iwl3945_bg_scan_completed SCAN complete scan
> [  121.052212] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x0d
> [  121.052221] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x0f
> [  121.052229] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x05
> [  121.052237] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x07
> [  121.052245] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x09
> [  121.052252] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x0b
> [  121.052260] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x01
> [  121.052268] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x03
> [  121.052310] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 139 dsp 116 rate code 0x0a
> [  121.052319] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 139 dsp 116 rate code 0x14
> [  121.052327] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 139 dsp 116 rate code 0x37
> [  121.052335] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 139 dsp 116 rate code 0x6e
> [  121.052349] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0420, 56 bytes at 32[0]:4
> [  121.552116] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms
> [  125.544380] ieee80211 phy0: U iwl3945_mac_config enter to channel 11
> [  125.544400] ieee80211 phy0: U iwl3945_commit_rxon Sending RXON
> [  125.544401] * without RXON_FILTER_ASSOC_MSK
> [  125.544401] * channel = 11
> [  125.544402] * bssid = 00:00:00:00:00:00
> [  125.544415] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x0421, 48 bytes at 33[1]:4
> [  126.040103] iwl3945 0000:03:00.0: Error sending REPLY_RXON: time out after 500ms
> [  126.040115] iwl3945 0000:03:00.0: Error setting new configuration (-110).
> [  126.040119] ieee80211 phy0: U iwl3945_mac_config leave
> [  126.040133] ieee80211 phy0: U iwl3945_mac_conf_tx enter
> [  126.040140] ieee80211 phy0: U iwl3945_mac_conf_tx leave
> [  126.040146] ieee80211 phy0: U iwl3945_mac_conf_tx enter
> [  126.040153] ieee80211 phy0: U iwl3945_mac_conf_tx leave
> [  126.040158] ieee80211 phy0: U iwl3945_mac_conf_tx enter
> [  126.040165] ieee80211 phy0: U iwl3945_mac_conf_tx leave
> [  126.040171] ieee80211 phy0: U iwl3945_mac_conf_tx enter
> [  126.040177] ieee80211 phy0: U iwl3945_mac_conf_tx leave
> [  126.040184] ieee80211 phy0: U iwl3945_mac_reset_tsf enter
> [  126.040199] ieee80211 phy0: U iwl3945_commit_rxon Sending RXON
> [  126.040201] * without RXON_FILTER_ASSOC_MSK
> [  126.040202] * channel = 11
> [  126.040204] * bssid = 00:00:00:00:00:00
> [  126.040229] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x0422, 48 bytes at 34[2]:4
> [  126.540041] iwl3945 0000:03:00.0: Error sending REPLY_RXON: time out after 500ms
> [  126.540065] iwl3945 0000:03:00.0: Error setting new configuration (-110).
> [  126.540076] ieee80211 phy0: U iwl3945_mac_reset_tsf leave - not in IBSS
> [  126.540115] ieee80211 phy0: I iwl3945_mac_tx enter
> [  126.540160] ieee80211 phy0: I iwl3945_mac_tx leave
> [  126.540218] iwl3945 0000:03:00.0: Microcode SW error detected. Restarting 0x82000008.
> [  126.540253] iwl3945 0000:03:00.0: Start IWL Error Log Dump:
> [  126.540260] iwl3945 0000:03:00.0: Status: 0x000302E4, count: 1
> [  126.540267] iwl3945 0000:03:00.0: Desc       Time       asrtPC  blink2 ilink1  nmiPC   Line
> [  126.540343] iwl3945 0000:03:00.0: SYSASSERT     (#5) 0096061946 0x0089A 0x0025E 0x00304 0x01BCC 78
> [  126.540346] 
> [  126.540416] iwl3945 0000:03:00.0: Start IWL Event Log Dump: display count 512, wraps 2
> [  126.540453] iwl3945 0000:03:00.0: 0000004728 0x00000000      1106
> [  126.540488] iwl3945 0000:03:00.0: 0000004732 0x00000000      1106
> [  126.540523] iwl3945 0000:03:00.0: 0000004736 0x00000000      1106
> [  126.540558] iwl3945 0000:03:00.0: 0000004741 0x00000000      1106
> [  126.540593] iwl3945 0000:03:00.0: 0000004745 0x00000000      1106
> [  126.540628] iwl3945 0000:03:00.0: 0000004749 0x00000000      1106
> [  126.540664] iwl3945 0000:03:00.0: 0000004754 0x00000000      1106
> [  126.540699] iwl3945 0000:03:00.0: 0000004758 0x00000000      1106
> [  126.540734] iwl3945 0000:03:00.0: 0000004762 0x00000000      1106
> [  126.540770] iwl3945 0000:03:00.0: 0000004766 0x00000000      1106
> [  126.540806] iwl3945 0000:03:00.0: 0000004771 0x00000000      1106
> [  126.540842] iwl3945 0000:03:00.0: 0000004775 0x00000000      1106
> [  126.540877] iwl3945 0000:03:00.0: 0000004779 0x00000000      1106
> [  126.540912] iwl3945 0000:03:00.0: 0000004783 0x00000000      1106
> [  126.540948] iwl3945 0000:03:00.0: 0000004788 0x00000000      1106
> [  126.540983] iwl3945 0000:03:00.0: 0000004792 0x00000000      1106
> [  126.541019] iwl3945 0000:03:00.0: 0000004796 0x00000000      1106
> [  126.541054] iwl3945 0000:03:00.0: 0000004801 0x00000000      1106
> [  126.541090] iwl3945 0000:03:00.0: 0000004805 0x00000000      1106
> [  126.541126] iwl3945 0000:03:00.0: 0000004809 0x00000000      1106
> [  126.541162] iwl3945 0000:03:00.0: 0000004813 0x00000000      1106
> [  126.541197] iwl3945 0000:03:00.0: 0000004818 0x00000000      1106
> [  126.541233] iwl3945 0000:03:00.0: 0000004822 0x00000000      1106
> [  126.541270] iwl3945 0000:03:00.0: 0000004826 0x00000001      1106
> [  126.541305] iwl3945 0000:03:00.0: 0000004827 0x0000000f      1106
> [  126.541342] iwl3945 0000:03:00.0: 0000004829 0x00000396      1105
> [  126.541377] iwl3945 0000:03:00.0: 0000004832 0x00000403      1115
> [  126.541413] iwl3945 0000:03:00.0: 0000004836 0x0000000b      0463
> [  126.541448] iwl3945 0000:03:00.0: 0000004837 0x0000000b      0462
> [  126.541483] iwl3945 0000:03:00.0: 0000004848 0x0000010c      0601
> [  126.541518] iwl3945 0000:03:00.0: 0000004858 0x04050047      0401
> [  126.541554] iwl3945 0000:03:00.0: 0000004868 0x0000010f      0603
> [  126.541589] iwl3945 0000:03:00.0: 0000004940 0x00000180      0604
> [  126.541624] iwl3945 0000:03:00.0: 0000004942 0x0000019c      0610
> [  126.541659] iwl3945 0000:03:00.0: 0000004943 0x00017cb2      0610
> [  126.541694] iwl3945 0000:03:00.0: 0000004944 0x00000000      0610
> [  126.541730] iwl3945 0000:03:00.0: 0000004992 0x00000500      0600
> [  126.541765] iwl3945 0000:03:00.0: 0000006493 0x000001ed      0616
> [  126.541800] iwl3945 0000:03:00.0: 0000004986 0x00017c86      0638
> [  126.541835] iwl3945 0000:03:00.0: 0000005009 0x0000001c      1101
> [  126.541875] iwl3945 0000:03:00.0: 0000005042 0x0000001a      1101
> [  126.541910] iwl3945 0000:03:00.0: 0000005069 0x000000ff      1103
> [  126.541946] iwl3945 0000:03:00.0: 0000005070 0xffff9111      1103
> [  126.541981] iwl3945 0000:03:00.0: 0000005072 0x00000010      1101
> [  126.542016] iwl3945 0000:03:00.0: 0000005090 0x00000011      1101
> [  126.542050] iwl3945 0000:03:00.0: 0000005103 0x00000000      1101
> [  126.542085] iwl3945 0000:03:00.0: 0000005104 0x00000000      1101
> [  126.542120] iwl3945 0000:03:00.0: 0000005106 0x000001d8      1101
> [  126.542155] iwl3945 0000:03:00.0: 0000005108 0x00000065      1104
> [  126.542190] iwl3945 0000:03:00.0: 0000005110 0x0000000e      1101
> [  126.542226] iwl3945 0000:03:00.0: 0000005111 0x00680034      1102
> [  126.542261] iwl3945 0000:03:00.0: 0000005112 0x00670035      1102
> [  126.542297] iwl3945 0000:03:00.0: 0000005114 0x007e0036      1102
> [  126.542332] iwl3945 0000:03:00.0: 0000005116 0x007c0037      1102
> [  126.542368] iwl3945 0000:03:00.0: 0000005117 0x00000038      1102
> [  126.542403] iwl3945 0000:03:00.0: 0000005119 0x00840052      1102
> [  126.542442] iwl3945 0000:03:00.0: 0000005120 0x00840053      1102
> [  126.542477] iwl3945 0000:03:00.0: 0000005122 0x007e0054      1102
> [  126.542512] iwl3945 0000:03:00.0: 0000005123 0x007d0055      1102
> [  126.542547] iwl3945 0000:03:00.0: 0000005125 0x00000056      1102
> [  126.542582] iwl3945 0000:03:00.0: 0000005126 0x00007050      1102
> [  126.542617] iwl3945 0000:03:00.0: 0000005128 0x00017051      1102
> [  126.542652] iwl3945 0000:03:00.0: 0000005130 0x00008204      1102
> [  126.542687] iwl3945 0000:03:00.0: 0000005132 0x00018205      1102
> [  126.542722] iwl3945 0000:03:00.0: 0000005135 0x00000001      1101
> [  126.542758] iwl3945 0000:03:00.0: 0000005136 0x008b0063      1102
> [  126.542793] iwl3945 0000:03:00.0: 0000005138 0x0000001d      1104
> [  126.542832] iwl3945 0000:03:00.0: 0000005140 0x00000069      1114
> [  126.542867] iwl3945 0000:03:00.0: 0000005161 0x0000020f      0605
> [  126.542901] iwl3945 0000:03:00.0: 0000005162 0x0000026b      0621
> [  126.542937] iwl3945 0000:03:00.0: 0000005166 0x0000010b      1108
> [  126.542971] iwl3945 0000:03:00.0: 0000005168 0x0000000e      1101
> [  126.543009] iwl3945 0000:03:00.0: 0000005169 0x00680034      1102
> [  126.543044] iwl3945 0000:03:00.0: 0000005170 0x00670035      1102
> [  126.543080] iwl3945 0000:03:00.0: 0000005172 0x007e0036      1102
> [  126.543115] iwl3945 0000:03:00.0: 0000005173 0x007c0037      1102
> [  126.543150] iwl3945 0000:03:00.0: 0000005175 0x00000038      1102
> [  126.543185] iwl3945 0000:03:00.0: 0000005176 0x00840052      1102
> [  126.543220] iwl3945 0000:03:00.0: 0000005178 0x00840053      1102
> [  126.543256] iwl3945 0000:03:00.0: 0000005179 0x007e0054      1102
> [  126.543292] iwl3945 0000:03:00.0: 0000005181 0x007d0055      1102
> [  126.543327] iwl3945 0000:03:00.0: 0000005182 0x00000056      1102
> [  126.543362] iwl3945 0000:03:00.0: 0000005184 0x00007050      1102
> [  126.543400] iwl3945 0000:03:00.0: 0000005186 0x00017051      1102
> [  126.543436] iwl3945 0000:03:00.0: 0000005188 0x00008204      1102
> [  126.543470] iwl3945 0000:03:00.0: 0000005190 0x00018205      1102
> [  126.543505] iwl3945 0000:03:00.0: 0000005193 0x00000001      1101
> [  126.543541] iwl3945 0000:03:00.0: 0000005194 0x008b0063      1102
> [  126.543579] iwl3945 0000:03:00.0: 0000005196 0x0000001c      1104
> [  126.543614] iwl3945 0000:03:00.0: 0000005197 0x00000002      1101
> [  126.543649] iwl3945 0000:03:00.0: 0000005198 0x0083903f      1102
> [  126.543684] iwl3945 0000:03:00.0: 0000005200 0x0001d213      1102
> [  126.543718] iwl3945 0000:03:00.0: 0000005203 0x00000002      1101
> [  126.543753] iwl3945 0000:03:00.0: 0000005204 0x0003d206      1102
> [  126.543788] iwl3945 0000:03:00.0: 0000005206 0x0083903e      1102
> [  126.543823] iwl3945 0000:03:00.0: 0000005210 0x00000059      1101
> [  126.543859] iwl3945 0000:03:00.0: 0000005310 0x00000013      1101
> [  126.543894] iwl3945 0000:03:00.0: 0000005328 0x00000005      1107
> [  126.543929] iwl3945 0000:03:00.0: 0000005896 0x000178f9      1110
> [  126.543967] iwl3945 0000:03:00.0: 0000005907 0xffffff4b      0454
> [  126.544002] iwl3945 0000:03:00.0: 0000005908 0x00000000      0472
> [  126.544009] iwl3945 0000:03:00.0: 0000005918 0x0000000b      0463
> [  126.544009] iwl3945 0000:03:00.0: 0000005921 0xffffff4b      1111
> [  126.544009] iwl3945 0000:03:00.0: 0000005926 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000005926 0x0000000e      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000005931 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000005935 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000005939 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000005943 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000005948 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000005952 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000005956 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000005961 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000005965 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000005969 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000005973 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000005978 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000005982 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000005986 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000005990 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000005995 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000005999 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000006003 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000006008 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000006012 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000006016 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000006020 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000006025 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000006029 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000006033 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000006037 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000006042 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000006046 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000006050 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000006055 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000006059 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000006063 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000006067 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000006072 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000006076 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000006080 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000006084 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000006089 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000006093 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000006097 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000006102 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000006106 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000006110 0x00000001      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000006111 0x0000000f      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000006113 0x000003b4      1105
> [  126.544009] iwl3945 0000:03:00.0: 0000006116 0x00000403      1115
> [  126.544009] iwl3945 0000:03:00.0: 0000006119 0x0000000b      0463
> [  126.544009] iwl3945 0000:03:00.0: 0000006121 0x0000000b      0462
> [  126.544009] iwl3945 0000:03:00.0: 0000006132 0x0000010c      0601
> [  126.544009] iwl3945 0000:03:00.0: 0000006142 0x04060047      0401
> [  126.544009] iwl3945 0000:03:00.0: 0000006152 0x0000010f      0603
> [  126.544009] iwl3945 0000:03:00.0: 0000006224 0x00000180      0604
> [  126.544009] iwl3945 0000:03:00.0: 0000006226 0x0000019c      0610
> [  126.544009] iwl3945 0000:03:00.0: 0000006227 0x000177ae      0610
> [  126.544009] iwl3945 0000:03:00.0: 0000006228 0x00000000      0610
> [  126.544009] iwl3945 0000:03:00.0: 0000006276 0x00000500      0600
> [  126.544009] iwl3945 0000:03:00.0: 0000007778 0x000001ed      0616
> [  126.544009] iwl3945 0000:03:00.0: 0000006270 0x00017782      0638
> [  126.544009] iwl3945 0000:03:00.0: 0000006293 0x0000001c      1101
> [  126.544009] iwl3945 0000:03:00.0: 0000006326 0x0000001a      1101
> [  126.544009] iwl3945 0000:03:00.0: 0000006353 0x000000ff      1103
> [  126.544009] iwl3945 0000:03:00.0: 0000006354 0xffff9111      1103
> [  126.544009] iwl3945 0000:03:00.0: 0000006356 0x00000010      1101
> [  126.544009] iwl3945 0000:03:00.0: 0000006374 0x00000011      1101
> [  126.544009] iwl3945 0000:03:00.0: 0000006387 0x00000000      1101
> [  126.544009] iwl3945 0000:03:00.0: 0000006388 0x00000000      1101
> [  126.544009] iwl3945 0000:03:00.0: 0000006390 0x000001d8      1101
> [  126.544009] iwl3945 0000:03:00.0: 0000006392 0x00000065      1104
> [  126.544009] iwl3945 0000:03:00.0: 0000006394 0x0000000e      1101
> [  126.544009] iwl3945 0000:03:00.0: 0000006395 0x00680034      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000006396 0x00670035      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000006398 0x007e0036      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000006400 0x007c0037      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000006401 0x00000038      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000006403 0x00840052      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000006404 0x00840053      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000006406 0x007e0054      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000006407 0x007d0055      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000006409 0x00000056      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000006410 0x00007050      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000006412 0x00017051      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000006414 0x00008204      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000006416 0x00018205      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000006419 0x00000001      1101
> [  126.544009] iwl3945 0000:03:00.0: 0000006420 0x008b0063      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000006422 0x0000001d      1104
> [  126.544009] iwl3945 0000:03:00.0: 0000006424 0x00000069      1114
> [  126.544009] iwl3945 0000:03:00.0: 0000006445 0x0000020f      0605
> [  126.544009] iwl3945 0000:03:00.0: 0000006446 0x0000026b      0621
> [  126.544009] iwl3945 0000:03:00.0: 0000006450 0x0000010b      1108
> [  126.544009] iwl3945 0000:03:00.0: 0000006452 0x0000000e      1101
> [  126.544009] iwl3945 0000:03:00.0: 0000006453 0x00680034      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000006454 0x00670035      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000006456 0x007e0036      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000006457 0x007c0037      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000006459 0x00000038      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000006460 0x00840052      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000006462 0x00840053      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000006463 0x007e0054      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000006465 0x007d0055      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000006466 0x00000056      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000006468 0x00007050      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000006470 0x00017051      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000006472 0x00008204      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000006474 0x00018205      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000006477 0x00000001      1101
> [  126.544009] iwl3945 0000:03:00.0: 0000006478 0x008b0063      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000006480 0x0000001c      1104
> [  126.544009] iwl3945 0000:03:00.0: 0000006481 0x00000002      1101
> [  126.544009] iwl3945 0000:03:00.0: 0000006482 0x0083903f      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000006484 0x0001d213      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000006487 0x00000002      1101
> [  126.544009] iwl3945 0000:03:00.0: 0000006488 0x0003d206      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000006490 0x0083903e      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000006494 0x00000059      1101
> [  126.544009] iwl3945 0000:03:00.0: 0000006594 0x00000013      1101
> [  126.544009] iwl3945 0000:03:00.0: 0000006612 0x00000005      1107
> [  126.544009] iwl3945 0000:03:00.0: 0000007180 0x000173f5      1110
> [  126.544009] iwl3945 0000:03:00.0: 0000007191 0xffffff4b      0454
> [  126.544009] iwl3945 0000:03:00.0: 0000007192 0x00000000      0472
> [  126.544009] iwl3945 0000:03:00.0: 0000007202 0x0000000b      0463
> [  126.544009] iwl3945 0000:03:00.0: 0000007205 0xffffff4b      1111
> [  126.544009] iwl3945 0000:03:00.0: 0000007210 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000007210 0x0000000e      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000007215 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000007219 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000007223 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000007227 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000007232 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000007236 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000007240 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000007245 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000007249 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000007253 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000007257 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000007262 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000007266 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000007270 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000007274 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000007279 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000007283 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000007287 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000007292 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000007296 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000007300 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000007304 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000007309 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000007313 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000007317 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000007321 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000007326 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000007330 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000007334 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000007339 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000007343 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000007347 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000007351 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000007356 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000007360 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000007364 0x00000001      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000007365 0x0000000f      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000007367 0x00000396      1105
> [  126.544009] iwl3945 0000:03:00.0: 0000007370 0x00000403      1115
> [  126.544009] iwl3945 0000:03:00.0: 0000007374 0x0000000b      0463
> [  126.544009] iwl3945 0000:03:00.0: 0000007375 0x0000000b      0462
> [  126.544009] iwl3945 0000:03:00.0: 0000007386 0x0000010c      0601
> [  126.544009] iwl3945 0000:03:00.0: 0000007397 0x04070097      0401
> [  126.544009] iwl3945 0000:03:00.0: 0000007399 0x0000000b      0451
> [  126.544009] iwl3945 0000:03:00.0: 0000007419 0x00000000      0451
> [  126.544009] iwl3945 0000:03:00.0: 0000007432 0x0000010f      0603
> [  126.544009] iwl3945 0000:03:00.0: 0000007498 0x00000180      0604
> [  126.544009] iwl3945 0000:03:00.0: 0000007500 0x0000019c      0610
> [  126.544009] iwl3945 0000:03:00.0: 0000007501 0x000172b4      0610
> [  126.544009] iwl3945 0000:03:00.0: 0000007502 0x00000000      0610
> [  126.544009] iwl3945 0000:03:00.0: 0000007550 0x00000500      0600
> [  126.544009] iwl3945 0000:03:00.0: 0000009052 0x000001ed      0616
> [  126.544009] iwl3945 0000:03:00.0: 0000007544 0x00017288      0638
> [  126.544009] iwl3945 0000:03:00.0: 0000007967 0x0000001c      1101
> [  126.544009] iwl3945 0000:03:00.0: 0000008000 0x0000001a      1101
> [  126.544009] iwl3945 0000:03:00.0: 0000008027 0x000000ff      1103
> [  126.544009] iwl3945 0000:03:00.0: 0000008028 0xffff9111      1103
> [  126.544009] iwl3945 0000:03:00.0: 0000008030 0x00000010      1101
> [  126.544009] iwl3945 0000:03:00.0: 0000008048 0x00000011      1101
> [  126.544009] iwl3945 0000:03:00.0: 0000008061 0x00000000      1101
> [  126.544009] iwl3945 0000:03:00.0: 0000008062 0x00000000      1101
> [  126.544009] iwl3945 0000:03:00.0: 0000008064 0x000001d8      1101
> [  126.544009] iwl3945 0000:03:00.0: 0000008066 0x00000065      1104
> [  126.544009] iwl3945 0000:03:00.0: 0000008068 0x0000000e      1101
> [  126.544009] iwl3945 0000:03:00.0: 0000008069 0x00680034      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000008070 0x00670035      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000008072 0x007e0036      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000008074 0x007c0037      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000008075 0x00000038      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000008077 0x00840052      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000008078 0x00840053      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000008080 0x007e0054      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000008081 0x007d0055      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000008083 0x00000056      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000008084 0x00007050      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000008086 0x00017051      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000008088 0x00008204      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000008090 0x00018205      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000008093 0x00000001      1101
> [  126.544009] iwl3945 0000:03:00.0: 0000008094 0x008b0063      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000008096 0x0000001d      1104
> [  126.544009] iwl3945 0000:03:00.0: 0000008098 0x00000069      1114
> [  126.544009] iwl3945 0000:03:00.0: 0000008119 0x0000020f      0605
> [  126.544009] iwl3945 0000:03:00.0: 0000008120 0x0000026b      0621
> [  126.544009] iwl3945 0000:03:00.0: 0000008124 0x0000010b      1108
> [  126.544009] iwl3945 0000:03:00.0: 0000008126 0x0000000e      1101
> [  126.544009] iwl3945 0000:03:00.0: 0000008127 0x00680034      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000008128 0x00670035      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000008130 0x007e0036      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000008131 0x007c0037      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000008133 0x00000038      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000008134 0x00840052      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000008136 0x00840053      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000008137 0x007e0054      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000008139 0x007d0055      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000008140 0x00000056      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000008142 0x00007050      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000008144 0x00017051      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000008146 0x00008204      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000008148 0x00018205      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000008151 0x00000001      1101
> [  126.544009] iwl3945 0000:03:00.0: 0000008152 0x008b0063      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000008154 0x0000001c      1104
> [  126.544009] iwl3945 0000:03:00.0: 0000008155 0x00000002      1101
> [  126.544009] iwl3945 0000:03:00.0: 0000008156 0x0083903f      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000008158 0x0001d213      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000008161 0x00000002      1101
> [  126.544009] iwl3945 0000:03:00.0: 0000008162 0x0003d206      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000008164 0x0083903e      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000008168 0x00000059      1101
> [  126.544009] iwl3945 0000:03:00.0: 0000008268 0x00000013      1101
> [  126.544009] iwl3945 0000:03:00.0: 0000008286 0x00000005      1107
> [  126.544009] iwl3945 0000:03:00.0: 0000008854 0x00016d6b      1110
> [  126.544009] iwl3945 0000:03:00.0: 0000008865 0xffffff4b      0454
> [  126.544009] iwl3945 0000:03:00.0: 0000008866 0x00000000      0472
> [  126.544009] iwl3945 0000:03:00.0: 0000008876 0x0000000b      0463
> [  126.544009] iwl3945 0000:03:00.0: 0000008879 0xffffff4b      1111
> [  126.544009] iwl3945 0000:03:00.0: 0000008884 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000008884 0x0000000e      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000008889 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000008893 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000008897 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000008901 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000008906 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000008910 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000008914 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000008919 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000008923 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000008927 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000008931 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000008936 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000008940 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000008944 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000008948 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000008953 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000008957 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000008961 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000008966 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000008970 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000008974 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000008978 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000008983 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000008987 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000008991 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000008995 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000009000 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000009004 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000009008 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000009013 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000009017 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000009021 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000009025 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000009030 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000009034 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000009038 0x00000001      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000009039 0x0000000f      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000009041 0x00000396      1105
> [  126.544009] iwl3945 0000:03:00.0: 0000009044 0x00000403      1115
> [  126.544009] iwl3945 0000:03:00.0: 0000009048 0x0000000b      0463
> [  126.544009] iwl3945 0000:03:00.0: 0000009049 0x0000000b      0462
> [  126.544009] iwl3945 0000:03:00.0: 0000009060 0x0000010c      0601
> [  126.544009] iwl3945 0000:03:00.0: 0000009070 0x04080048      0401
> [  126.544009] iwl3945 0000:03:00.0: 0000009081 0x0000010f      0603
> [  126.544009] iwl3945 0000:03:00.0: 0000009152 0x00000180      0604
> [  126.544009] iwl3945 0000:03:00.0: 0000009154 0x0000019c      0610
> [  126.544009] iwl3945 0000:03:00.0: 0000009155 0x00016c3e      0610
> [  126.544009] iwl3945 0000:03:00.0: 0000009156 0x00000000      0610
> [  126.544009] iwl3945 0000:03:00.0: 0000009204 0x00000500      0600
> [  126.544009] iwl3945 0000:03:00.0: 0000009198 0x00016c12      0638
> [  126.544009] iwl3945 0000:03:00.0: 0000009210 0x0000001c      1101
> [  126.544009] iwl3945 0000:03:00.0: 0000009242 0x0000001a      1101
> [  126.544009] iwl3945 0000:03:00.0: 0000009270 0x000000ff      1103
> [  126.544009] iwl3945 0000:03:00.0: 0000009271 0xffff9111      1103
> [  126.544009] iwl3945 0000:03:00.0: 0000009272 0x00000010      1101
> [  126.544009] iwl3945 0000:03:00.0: 0000009291 0x00000011      1101
> [  126.544009] iwl3945 0000:03:00.0: 0000009304 0x00000000      1101
> [  126.544009] iwl3945 0000:03:00.0: 0000009305 0x00000000      1101
> [  126.544009] iwl3945 0000:03:00.0: 0000009307 0x000001d8      1101
> [  126.544009] iwl3945 0000:03:00.0: 0000009309 0x00000064      1104
> [  126.544009] iwl3945 0000:03:00.0: 0000009311 0x0000000e      1101
> [  126.544009] iwl3945 0000:03:00.0: 0000009312 0x00680034      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000009313 0x00670035      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000009315 0x007e0036      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000009316 0x007c0037      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000009318 0x00000038      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000009319 0x00840052      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000009321 0x00840053      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000009322 0x007e0054      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000009324 0x007d0055      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000009325 0x00000056      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000009327 0x00007050      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000009329 0x00017051      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000009331 0x00008204      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000009333 0x00018205      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000009336 0x00000001      1101
> [  126.544009] iwl3945 0000:03:00.0: 0000009337 0x008b0063      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000009339 0x0000001c      1104
> [  126.544009] iwl3945 0000:03:00.0: 0000009341 0x00000069      1114
> [  126.544009] iwl3945 0000:03:00.0: 0000009379 0x02000000      0600
> [  126.544009] iwl3945 0000:03:00.0: 0000009385 0x00000000      0651
> [  126.544009] iwl3945 0000:03:00.0: 0000009386 0x00000259      0605
> [  126.544009] iwl3945 0000:03:00.0: 0000009388 0x0000026b      0621
> [  126.544009] iwl3945 0000:03:00.0: 0000009391 0x0000010b      1108
> [  126.544009] iwl3945 0000:03:00.0: 0000009393 0x0000000e      1101
> [  126.544009] iwl3945 0000:03:00.0: 0000009394 0x00680034      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000009396 0x00670035      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000009397 0x007e0036      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000009399 0x007c0037      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000009400 0x00000038      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000009402 0x00840052      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000009403 0x00840053      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000009405 0x007e0054      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000009406 0x007d0055      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000009408 0x00000056      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000009409 0x00007050      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000009411 0x00017051      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000009413 0x00008204      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000009415 0x00018205      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000009418 0x00000001      1101
> [  126.544009] iwl3945 0000:03:00.0: 0000009419 0x008b0063      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000009421 0x0000001d      1104
> [  126.544009] iwl3945 0000:03:00.0: 0000009423 0x00000002      1101
> [  126.544009] iwl3945 0000:03:00.0: 0000009424 0x0083903f      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000009426 0x0001d213      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000009429 0x00000002      1101
> [  126.544009] iwl3945 0000:03:00.0: 0000009430 0x0003d206      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000009432 0x0083903e      1102
> [  126.544009] iwl3945 0000:03:00.0: 0000009436 0x00000059      1101
> [  126.544009] iwl3945 0000:03:00.0: 0000009536 0x00000013      1101
> [  126.544009] iwl3945 0000:03:00.0: 0000009553 0x00000005      1107
> [  126.544009] iwl3945 0000:03:00.0: 0000010121 0x00016878      1110
> [  126.544009] iwl3945 0000:03:00.0: 0000010132 0xffffff4a      0454
> [  126.544009] iwl3945 0000:03:00.0: 0000010133 0x00000000      0472
> [  126.544009] iwl3945 0000:03:00.0: 0000010143 0x0000000b      0463
> [  126.544009] iwl3945 0000:03:00.0: 0000010146 0xffffff4a      1111
> [  126.544009] iwl3945 0000:03:00.0: 0000010151 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000010151 0x0000000e      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000010156 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000010160 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000010164 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000010168 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000010173 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000010177 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000010181 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000010186 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000010190 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000010194 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000010198 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000010203 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000010207 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000010211 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000010215 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000010220 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000010224 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000010228 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000010233 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000010237 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000010241 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000010245 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000010250 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000010254 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000010258 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000010263 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000010267 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000010271 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000010275 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000010280 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000010284 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000010288 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000010292 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000010297 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000010301 0x00000000      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000010305 0x00000001      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000010306 0x0000000f      1106
> [  126.544009] iwl3945 0000:03:00.0: 0000010308 0x00000396      1105
> [  126.544009] iwl3945 0000:03:00.0: 0000010311 0x00000403      1115
> [  126.544009] iwl3945 0000:03:00.0: 0000010315 0x0000000b      0463
> [  126.544009] iwl3945 0000:03:00.0: 0000010316 0x0000000b      0462
> [  126.544009] iwl3945 0000:03:00.0: 0000010327 0x0000010c      0601
> [  126.544009] iwl3945 0000:03:00.0: 0000010368 0x00010087      0250
> [  126.544009] iwl3945 0000:03:00.0: 0000010373 0x0000001c      0218
> [  126.544009] iwl3945 0000:03:00.0: 0096061945 0x00000002      0123
> [  126.544009] iwl3945 0000:03:00.0: 0096061947 0x00000100      0125
> [  126.544009] ieee80211 phy0: I iwl3945_print_rx_config_cmd RX CONFIG:
> [  126.544009] ieee80211 phy0: I iwl3945_print_rx_config_cmd u16 channel: 0xb
> [  126.544009] ieee80211 phy0: I iwl3945_print_rx_config_cmd u32 flags: 0x00008005
> [  126.544009] ieee80211 phy0: I iwl3945_print_rx_config_cmd u32 filter_flags: 0x00000004
> [  126.544009] ieee80211 phy0: I iwl3945_print_rx_config_cmd u8 dev_type: 0x3
> [  126.544009] ieee80211 phy0: I iwl3945_print_rx_config_cmd u8 ofdm_basic_rates: 0x15
> [  126.544009] ieee80211 phy0: I iwl3945_print_rx_config_cmd u8 cck_basic_rates: 0x03
> [  126.544009] ieee80211 phy0: I iwl3945_print_rx_config_cmd u8[6] node_addr: 00:1f:3c:20:a1:6e
> [  126.544009] ieee80211 phy0: I iwl3945_print_rx_config_cmd u8[6] bssid_addr: 00:00:00:00:00:00
> [  126.544009] ieee80211 phy0: I iwl3945_print_rx_config_cmd u16 assoc_id: 0x0
> [  126.544009] ieee80211 phy0: I iwl3945_irq_handle_error Restarting adapter due to uCode error.
> [  126.544009] ieee80211 phy0: I iwl3945_rx_handle r = 13, i = 12, REPLY_ERROR, 0x02
> [  126.544009] iwl3945 0000:03:00.0: Error Reply type 0x00000005 cmd REPLY_PHY_CALIBRATION_CMD (0xB0) seq 0x013A ser 0x004E0000
> [  126.562632] ieee80211 phy0: U __iwl3945_down iwl3945 is going down
> [  126.566783] iwl3945 0000:03:00.0: Can't stop Rx DMA.
> [  126.566849] ieee80211 phy0: U iwl3945_apm_stop_master stop master
> [  126.567085] ieee80211 phy0: U iwl3945_clear_free_frames 0 frames on pre-allocated heap on clear.
> [  126.567106] ieee80211 phy0: U iwl3945_power_init_handle Initialize power 
> [  126.567123] ieee80211 phy0: U iwl3945_power_init_handle adjust power command flags
> [  126.567225] ieee80211 phy0: U iwl3945_hw_nic_init HW Revision ID = 0x2
> [  126.567277] ieee80211 phy0: U iwl3945_nic_config 3945 RADIO-MM type
> [  126.567291] ieee80211 phy0: U iwl3945_nic_config SKU OP mode is basic
> [  126.567354] ieee80211 phy0: U iwl3945_nic_config 3945ABG revision is 0xF1
> [  126.567368] ieee80211 phy0: U iwl3945_nic_config Card M type B version is 0x3
> [  126.570944] ieee80211 phy0: U iwl3945_load_bsm Begin load bsm
> [  126.572215] ieee80211 phy0: U iwl3945_verify_bsm Begin verify bsm
> [  126.574377] ieee80211 phy0: U iwl3945_verify_bsm BSM bootstrap uCode image OK
> [  126.574437] ieee80211 phy0: U iwl3945_load_bsm BSM write complete, poll 1 iterations
> [  126.574457] ieee80211 phy0: U __iwl3945_up iwl3945 is coming up
> [  126.585884] ieee80211 phy0: I iwl3945_rx_handle r = 1, i = 0, REPLY_ALIVE, 0x01
> [  126.585903] ieee80211 phy0: I iwl3945_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x9
> [  126.585911] ieee80211 phy0: I iwl3945_rx_reply_alive Initialization Alive received.
> [  126.593080] ieee80211 phy0: U iwl3945_verify_inst_sparse ucode inst image size is 900
> [  126.593183] ieee80211 phy0: U iwl3945_verify_inst_sparse ucode inst image size is 2672
> [  126.593466] ieee80211 phy0: U iwl3945_verify_ucode Initialize uCode is good in inst SRAM
> [  126.593474] ieee80211 phy0: U iwl3945_init_alive_start Initialization Alive received.
> [  126.593525] ieee80211 phy0: U iwl3945_set_ucode_ptrs Runtime uCode pointers are set.
> [  126.597890] ieee80211 phy0: I iwl3945_rx_handle r = 2, i = 1, REPLY_ALIVE, 0x01
> [  126.597906] ieee80211 phy0: I iwl3945_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x0
> [  126.597914] ieee80211 phy0: I iwl3945_rx_reply_alive Runtime Alive received.
> [  126.597963] ieee80211 phy0: I iwl3945_disable_events Selected uCode log events may be disabled
> [  126.597970] ieee80211 phy0: I iwl3945_disable_events   by writing "1"s into disable bitmap
> [  126.597978] ieee80211 phy0: I iwl3945_disable_events   in SRAM at 0x8022c8, size 47 u32s
> [  126.604332] ieee80211 phy0: U iwl3945_alive_start Runtime Alive received.
> [  126.604346] ieee80211 phy0: U iwl3945_verify_inst_sparse ucode inst image size is 900
> [  126.604433] ieee80211 phy0: U iwl3945_verify_inst_sparse ucode inst image size is 2672
> [  126.604520] ieee80211 phy0: U iwl3945_verify_inst_sparse ucode inst image size is 80684
> [  126.612341] ieee80211 phy0: U iwl3945_verify_ucode Runtime uCode is good in inst SRAM
> [  126.612381] ieee80211 phy0: U iwl3945_alive_start RFKILL status: 0x1
> [  126.612416] ieee80211 phy0: U iwl3945_update_power_cmd Flags value = 0x00000009
> [  126.612423] ieee80211 phy0: U iwl3945_update_power_cmd Tx timeout = 102400
> [  126.612430] ieee80211 phy0: U iwl3945_update_power_cmd Rx timeout = 51200
> [  126.612438] ieee80211 phy0: U iwl3945_update_power_cmd Sleep interval vector = { 1 , 1 , 1 , 1 , 1 }
> [  126.612453] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command POWER_TABLE_CMD (#77), seq: 0x0400, 36 bytes at 0[0]:4
> [  126.612538] ieee80211 phy0: I iwl3945_rx_handle r 3 i 2 No handler needed for POWER_TABLE_CMD, 0x77
> [  126.612583] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_BT_CONFIG (#9b), seq: 0x0401, 16 bytes at 1[1]:4
> [  126.612600] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
> [  126.614372] ieee80211 phy0: I iwl3945_rx_handle r 4 i 3 No handler needed for REPLY_BT_CONFIG, 0x9b
> [  126.615108] ieee80211 phy0: U iwl3945_commit_rxon Sending RXON
> [  126.615111] * without RXON_FILTER_ASSOC_MSK
> [  126.615113] * channel = 11
> [  126.615114] * bssid = 00:00:00:00:00:00
> [  126.615134] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x0402, 48 bytes at 2[2]:4
> [  126.615149] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
> [  126.617370] ieee80211 phy0: I iwl3945_rx_handle r 5 i 4 No handler needed for REPLY_RXON, 0x10
> [  126.617686] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x0d
> [  126.617697] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x0f
> [  126.617706] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x05
> [  126.617713] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x07
> [  126.617721] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x09
> [  126.617729] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x0b
> [  126.617738] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x01
> [  126.617746] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 127 rate code 0x03
> [  126.617754] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 139 dsp 116 rate code 0x0a
> [  126.617762] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 139 dsp 116 rate code 0x14
> [  126.617770] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 139 dsp 116 rate code 0x37
> [  126.617778] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 139 dsp 116 rate code 0x6e
> [  126.617790] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0403, 56 bytes at 3[3]:4
> [  126.617806] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
> [  126.620177] ieee80211 phy0: I iwl3945_rx_handle r 6 i 5 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
> [  126.620343] ieee80211 phy0: U iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
> [  126.620358] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0404, 68 bytes at 4[4]:4
> [  126.620373] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
> [  126.623060] ieee80211 phy0: I iwl3945_rx_handle r = 7, i = 6, REPLY_ADD_STA, 0x18
> [  126.623655] ieee80211 phy0: U iwl3945_send_add_station REPLY_ADD_STA PASSED
> [  126.623672] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0405, 56 bytes at 5[5]:4
> [  126.623687] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
> [  126.625931] ieee80211 phy0: I iwl3945_rx_handle r 8 i 7 No handler needed for REPLY_RATE_SCALE, 0x47
> [  126.625954] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0406, 56 bytes at 6[6]:4
> [  126.625972] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
> [  126.628770] ieee80211 phy0: I iwl3945_rx_handle r 9 i 8 No handler needed for REPLY_RATE_SCALE, 0x47
> [  126.628796] ieee80211 phy0: U iwl3945_hw_reg_txpower_get_temperature Temperature: 106
> [  126.628807] ieee80211 phy0: U is_temp_calib_needed Getting warmer, delta 27,
> [  126.628813] ieee80211 phy0: U is_temp_calib_needed Timed thermal calib needed
> [  126.628833] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 235 dsp 121 rate code 0x0d
> [  126.628842] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 235 dsp 121 rate code 0x0f
> [  126.628849] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 235 dsp 121 rate code 0x05
> [  126.628857] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 235 dsp 121 rate code 0x07
> [  126.628865] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 235 dsp 121 rate code 0x09
> [  126.628874] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 235 dsp 121 rate code 0x0b
> [  126.628881] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 235 dsp 121 rate code 0x01
> [  126.628890] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 235 dsp 121 rate code 0x03
> [  126.628899] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 171 dsp 110 rate code 0x0a
> [  126.628907] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 171 dsp 110 rate code 0x14
> [  126.628915] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 171 dsp 110 rate code 0x37
> [  126.628924] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 171 dsp 110 rate code 0x6e
> [  126.628936] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0407, 56 bytes at 7[7]:4
> [  126.628952] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
> [  126.631601] ieee80211 phy0: I iwl3945_rx_handle r 10 i 9 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
> [  126.632215] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0408, 12 bytes at 8[8]:4
> [  126.632233] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
> [  126.632355] ieee80211 phy0: U iwl3945_alive_start ALIVE processing complete.
> [  126.634486] ieee80211 phy0: I iwl3945_rx_handle r 11 i 10 No handler needed for REPLY_LEDS_CMD, 0x48
> [  126.740175] ieee80211 phy0: I iwl3945_mac_tx enter
> [  126.740235] ieee80211 phy0: I iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
> [  126.740243] ieee80211 phy0: I iwl3945_mac_tx leave
> [  126.750986] ieee80211 phy0: I iwl3945_rx_handle r = 12, i = 11, REPLY_TX, 0x1c
> [  126.944117] ieee80211 phy0: I iwl3945_mac_tx enter
> [  126.944167] ieee80211 phy0: I iwl3945_mac_tx leave
> [  126.944226] ieee80211 phy0: I iwl3945_rx_handle r 14 i 12 No handler needed for UNKNOWN, 0x40
> [  126.944277] ------------[ cut here ]------------
> [  126.944282] kernel BUG at drivers/net/wireless/iwlwifi/iwl3945-base.c:3127!
> [  126.944288] invalid opcode: 0000 [#1] SMP 
> [  126.944298] last sysfs file: /sys/devices/pci0000:00/0000:00:1c.1/0000:03:00.0/rfkill/rfkill0/state
> [  126.944304] Dumping ftrace buffer:
> [  126.944309]    (ftrace buffer empty)
> [  126.944314] CPU 1 
> [  126.944320] Modules linked in: af_packet i915 drm binfmt_misc acpi_cpufreq cpufreq_ondemand cpufreq_stats cpufreq_powersave cpufreq_userspace cpufreq_conservative freq_table pci_slot sbs sbshc container iptable_filter ip_tables x_tables sbp2 snd_hda_intel snd_pcm_oss snd_mixer_oss arc4 ecb snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi joydev snd_rawmidi iwl3945 iwlcore snd_seq_midi_event mac80211 thinkpad_acpi snd_seq snd_timer snd_seq_device pcmcia psmouse rfkill lib80211 snd soundcore evdev led_class cfg80211 battery nvram serio_raw pcspkr video output yenta_socket rsrc_nonstatic pcmcia_core ac shpchp pci_hotplug wmi iTCO_wdt iTCO_vendor_support button intel_agp snd_page_alloc ext3 jbd mbcache sr_mod cdrom sd_mod crc_t10dif sg ata_piix ata_generic pata_acpi ahci ohci1394 ieee1394 libata scsi_mod ehci_hcd uhci_hcd usbcore thermal processor fan fuse
> [  126.944616] Pid: 5598, comm: apport-checkrep Tainted: G        W  2.6.28 #23
> [  126.944623] RIP: 0010:[<ffffffffa036efdd>]  [<ffffffffa036efdd>] iwl3945_irq_tasklet+0xf1d/0x1430 [iwl3945]
> [  126.944645] RSP: 0000:ffff88013b193e00  EFLAGS: 00010097
> [  126.944649] RAX: 0000000000000000 RBX: 0000000000000049 RCX: 0000000000000000
> [  126.944654] RDX: ffff88013894e700 RSI: 0000000000000082 RDI: 0000000000000082
> [  126.944658] RBP: ffff88013b193ec0 R08: 0000000000000000 R09: 0000000000000000
> [  126.944663] R10: ffff88013529d580 R11: 0000000000000000 R12: ffffffffa0349d90
> [  126.944667] R13: ffff8801358830e8 R14: ffff880135880080 R15: ffff880135881ae0
> [  126.944672] FS:  00007f7e333206e0(0000) GS:ffff88013bc03e00(0000) knlGS:0000000000000000
> [  126.944677] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  126.944684] CR2: 0000000000d22098 CR3: 00000001378b6000 CR4: 00000000000006e0
> [  126.944688] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  126.944693] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  126.944698] Process apport-checkrep (pid: 5598, threadinfo ffff880122d16000, task ffff88013606c350)
> [  126.944703] Stack:
> [  126.944706]  ffff88010000000c ffffffffa0349d90 0000000000000040 ffffffff00000040
> [  126.944721]  ffff880135882504 0001000000000000 0000000000000282 00ff880100000008
> [  126.944736]  0000000e00000001 ffff880135886928 ffff880135886950 ffff880135890f38
> [  126.944757] Call Trace:
> [  126.944762]  <IRQ> <0> [<ffffffff8026744b>] ? hrtimer_get_next_event+0xcb/0xe0
> [  126.944779]  [<ffffffff80251e56>] tasklet_action+0x86/0x110
> [  126.944789]  [<ffffffff8025256c>] __do_softirq+0x9c/0x170
> [  126.944797]  [<ffffffff80214d8c>] call_softirq+0x1c/0x30
> [  126.944807]  [<ffffffff802160bd>] do_softirq+0x5d/0xa0
> [  126.944815]  [<ffffffff802522ed>] irq_exit+0x8d/0xa0
> [  126.944822]  [<ffffffff80216389>] do_IRQ+0xc9/0x110
> [  126.944831]  [<ffffffff80213b23>] ret_from_intr+0x0/0x29
> [  126.944838]  <EOI> <0>Code: 48 89 c6 8b 4d c0 48 c7 c7 28 0e 38 a0 31 c0 e8 e3 af 19 e0 4c 89 ff e8 c2 c0 ff ff c7 85 68 ff ff ff 00 00 00 02 e9 7d f2 ff ff <0f> 0b eb fe 45 8b 87 9c 6f 00 00 41 8b 9f a0 6f 00 00 e9 5e f6 
> [  126.944986] RIP  [<ffffffffa036efdd>] iwl3945_irq_tasklet+0xf1d/0x1430 [iwl3945]
> [  126.945003]  RSP <ffff88013b193e00>
> [  126.945008] Kernel panic - not syncing: Fatal exception in interrupt
> [  126.945016] ------------[ cut here ]------------
> [  126.945023] WARNING: at kernel/smp.c:333 smp_call_function_mask+0x21a/0x220()
> [  126.945027] Modules linked in: af_packet i915 drm binfmt_misc acpi_cpufreq cpufreq_ondemand cpufreq_stats cpufreq_powersave cpufreq_userspace cpufreq_conservative freq_table pci_slot sbs sbshc container iptable_filter ip_tables x_tables sbp2 snd_hda_intel snd_pcm_oss snd_mixer_oss arc4 ecb snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi joydev snd_rawmidi iwl3945 iwlcore snd_seq_midi_event mac80211 thinkpad_acpi snd_seq snd_timer snd_seq_device pcmcia psmouse rfkill lib80211 snd soundcore evdev led_class cfg80211 battery nvram serio_raw pcspkr video output yenta_socket rsrc_nonstatic pcmcia_core ac shpchp pci_hotplug wmi iTCO_wdt iTCO_vendor_support button intel_agp snd_page_alloc ext3 jbd mbcache sr_mod cdrom sd_mod crc_t10dif sg ata_piix ata_generic pata_acpi ahci ohci1394 ieee1394 libata scsi_mod ehci_hcd uhci_hcd usbcore thermal processor fan fuse
> [  126.945081] Pid: 5598, comm: apport-checkrep Tainted: G      D W  2.6.28 #23
> [  126.945081] Call Trace:
> [  126.945081]  <IRQ>  [<ffffffff8024c5ef>] warn_on_slowpath+0x5f/0x90
> [  126.945081]  [<ffffffff8024ce6d>] ? release_console_sem+0x1cd/0x220
> [  126.945081]  [<ffffffff80274b6a>] smp_call_function_mask+0x21a/0x220
> [  126.945081]  [<ffffffff80225570>] ? stop_this_cpu+0x0/0x30
> [  126.945081]  [<ffffffff8050a010>] ? printk+0x67/0x6f
> [  126.945081]  [<ffffffff802807b4>] ? crash_kexec+0x74/0x100
> [  126.945081]  [<ffffffff80274b8b>] smp_call_function+0x1b/0x20
> [  126.945081]  [<ffffffff80225543>] native_smp_send_stop+0x23/0x50
> [  126.945081]  [<ffffffff80509eee>] panic+0xaf/0x16a
> [  126.945081]  [<ffffffff802807b4>] ? crash_kexec+0x74/0x100
> [  126.945081]  [<ffffffff80410dad>] ? do_unblank_screen+0x1d/0x150
> [  126.945081]  [<ffffffff80410eeb>] ? unblank_screen+0xb/0x10
> [  126.945081]  [<ffffffff8050e041>] oops_end+0xb1/0xc0
> [  126.945081]  [<ffffffff80216d5e>] die+0x5e/0x90
> [  126.945081]  [<ffffffff8050dae6>] do_trap+0x146/0x170
> [  126.945081]  [<ffffffff80510515>] ? atomic_notifier_call_chain+0x15/0x20
> [  126.945081]  [<ffffffff80215800>] do_invalid_op+0x90/0xb0
> [  126.945081]  [<ffffffffa036efdd>] ? iwl3945_irq_tasklet+0xf1d/0x1430 [iwl3945]
> [  126.945081]  [<ffffffff8050a010>] ? printk+0x67/0x6f
> [  126.945081]  [<ffffffff8050d1ba>] error_exit+0x0/0x70
> [  126.945081]  [<ffffffffa036efdd>] ? iwl3945_irq_tasklet+0xf1d/0x1430 [iwl3945]
> [  126.945081]  [<ffffffff8026744b>] ? hrtimer_get_next_event+0xcb/0xe0
> [  126.945081]  [<ffffffff80251e56>] tasklet_action+0x86/0x110
> [  126.945081]  [<ffffffff8025256c>] __do_softirq+0x9c/0x170
> [  126.945081]  [<ffffffff80214d8c>] call_softirq+0x1c/0x30
> [  126.945081]  [<ffffffff802160bd>] do_softirq+0x5d/0xa0
> [  126.945081]  [<ffffffff802522ed>] irq_exit+0x8d/0xa0
> [  126.945081]  [<ffffffff80216389>] do_IRQ+0xc9/0x110
> [  126.945081]  [<ffffffff80213b23>] ret_from_intr+0x0/0x29
> [  126.945081]  <EOI> <4>---[ end trace 89376d7b2f9fa5ab ]---
> [  126.945081] ------------[ cut here ]------------
> [  126.945081] WARNING: at kernel/smp.c:220 smp_call_function_single+0xda/0x100()
> [  126.945081] Modules linked in: af_packet i915 drm binfmt_misc acpi_cpufreq cpufreq_ondemand cpufreq_stats cpufreq_powersave cpufreq_userspace cpufreq_conservative freq_table pci_slot sbs sbshc container iptable_filter ip_tables x_tables sbp2 snd_hda_intel snd_pcm_oss snd_mixer_oss arc4 ecb snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi joydev snd_rawmidi iwl3945 iwlcore snd_seq_midi_event mac80211 thinkpad_acpi snd_seq snd_timer snd_seq_device pcmcia psmouse rfkill lib80211 snd soundcore evdev led_class cfg80211 battery nvram serio_raw pcspkr video output yenta_socket rsrc_nonstatic pcmcia_core ac shpchp pci_hotplug wmi iTCO_wdt iTCO_vendor_support button intel_agp snd_page_alloc ext3 jbd mbcache sr_mod cdrom sd_mod crc_t10dif sg ata_piix ata_generic pata_acpi ahci ohci1394 ieee1394 libata scsi_mod ehci_hcd uhci_hcd usbcore thermal processor fan fuse
> [  126.945081] Pid: 5598, comm: apport-checkrep Tainted: G      D W  2.6.28 #23
> [  126.945081] Call Trace:
> [  126.945081]  <IRQ>  [<ffffffff8024c5ef>] warn_on_slowpath+0x5f/0x90
> [  126.945081]  [<ffffffff80509e36>] ? dump_stack+0x72/0x7b
> [  126.945081]  [<ffffffff802758e7>] ? print_modules+0x57/0xb0
> [  126.945081]  [<ffffffff8024c49e>] ? print_oops_end_marker+0x1e/0x20
> [  126.945081]  [<ffffffff8024c5f5>] ? warn_on_slowpath+0x65/0x90
> [  126.945081]  [<ffffffff8024ce6d>] ? release_console_sem+0x1cd/0x220
> [  126.945081]  [<ffffffff8027492a>] smp_call_function_single+0xda/0x100
> [  126.945081]  [<ffffffff80274ae0>] smp_call_function_mask+0x190/0x220
> [  126.945081]  [<ffffffff80225570>] ? stop_this_cpu+0x0/0x30
> [  126.945081]  [<ffffffff8050a010>] ? printk+0x67/0x6f
> [  126.945081]  [<ffffffff802807b4>] ? crash_kexec+0x74/0x100
> [  126.945081]  [<ffffffff80274b8b>] smp_call_function+0x1b/0x20
> [  126.945081]  [<ffffffff80225543>] native_smp_send_stop+0x23/0x50
> [  126.945081]  [<ffffffff80509eee>] panic+0xaf/0x16a
> [  126.945081]  [<ffffffff802807b4>] ? crash_kexec+0x74/0x100
> [  126.945081]  [<ffffffff80410dad>] ? do_unblank_screen+0x1d/0x150
> [  126.945081]  [<ffffffff80410eeb>] ? unblank_screen+0xb/0x10
> [  126.945081]  [<ffffffff8050e041>] oops_end+0xb1/0xc0
> [  126.945081]  [<ffffffff80216d5e>] die+0x5e/0x90
> [  126.945081]  [<ffffffff8050dae6>] do_trap+0x146/0x170
> [  126.945081]  [<ffffffff80510515>] ? atomic_notifier_call_chain+0x15/0x20
> [  126.945081]  [<ffffffff80215800>] do_invalid_op+0x90/0xb0
> [  126.945081]  [<ffffffffa036efdd>] ? iwl3945_irq_tasklet+0xf1d/0x1430 [iwl3945]
> [  126.945081]  [<ffffffff8050a010>] ? printk+0x67/0x6f
> [  126.945081]  [<ffffffff8050d1ba>] error_exit+0x0/0x70
> [  126.945081]  [<ffffffffa036efdd>] ? iwl3945_irq_tasklet+0xf1d/0x1430 [iwl3945]
> [  126.945081]  [<ffffffff8026744b>] ? hrtimer_get_next_event+0xcb/0xe0
> [  126.945081]  [<ffffffff80251e56>] tasklet_action+0x86/0x110
> [  126.945081]  [<ffffffff8025256c>] __do_softirq+0x9c/0x170
> [  126.945081]  [<ffffffff80214d8c>] call_softirq+0x1c/0x30
> [  126.945081]  [<ffffffff802160bd>] do_softirq+0x5d/0xa0
> [  126.945081]  [<ffffffff802522ed>] irq_exit+0x8d/0xa0
> [  126.945081]  [<ffffffff80216389>] do_IRQ+0xc9/0x110
> [  126.945081]  [<ffffffff80213b23>] ret_from_intr+0x0/0x29
> [  126.945081]  <EOI> <4>---[ end trace 89376d7b2f9fa5ab ]---
> ^C punt!
> jason-andryuks-mac-mini:~ jasonandryuk$ 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
