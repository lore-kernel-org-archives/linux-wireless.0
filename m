Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:55445 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbZA0DNQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2009 22:13:16 -0500
Received: by yx-out-2324.google.com with SMTP id 8so2707000yxm.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 Jan 2009 19:13:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090126114453.GB3197@sortiz.org>
References: <760481.57662.qm@web57614.mail.re1.yahoo.com>
	 <20090126114453.GB3197@sortiz.org>
Date: Mon, 26 Jan 2009 22:13:13 -0500
Message-ID: <c4d76b3b0901261913s23427b19tbbe34ee7b4261068@mail.gmail.com> (sfid-20090127_041334_844120_B6F00009)
Subject: Re: kernel BUG at drivers/net/wireless/iwlwifi/iwl3945-base.c:3127!
From: Jason Andryuk <jandryuk@gmail.com>
To: Samuel Ortiz <samuel@sortiz.org>
Cc: reinette chatre <reinette.chatre@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I was away from the computer, so I would not have been able to test
anything anyway.

I tested  wireless-testings of  master-2009-01-23 and had the same
inability to authenticate.  The WARNING (previous BUG) was triggered.
Below are the logs.

I see wireless-testing merged some of your commits, so I'll go try those out.

Jason

(I switched email addresses)

Jan 26 21:28:58 rainbow kernel: Inspecting /boot/System.map-2.6.29-rc2-wl
Jan 26 21:28:59 rainbow kernel: Cannot find map file.
Jan 26 21:28:59 rainbow kernel: Loaded 54213 symbols from 87 modules.
Jan 26 21:28:59 rainbow kernel: [    0.000000] Initializing cgroup subsys cpuset
Jan 26 21:28:59 rainbow kernel: [    0.000000] Initializing cgroup subsys cpu
Jan 26 21:28:59 rainbow kernel: [    0.000000] Linux version
2.6.29-rc2-wl (captainamerica@rainbow) (gcc version 4.3.2 (Ubuntu
4.3.2-1ubuntu11) ) #25 SMP Sun Jan 25 21:29:18 EST 2009
Jan 26 21:28:59 rainbow kernel: [    0.000000] Command line:
root=UUID=b49fa89a-8364-4ea0-b712-438b002b45c1 ro debug
netconsole=@169.254.1.1/eth0,@169.254.242.220/
Jan 26 21:28:59 rainbow kernel: [    0.000000] KERNEL supported cpus:
Jan 26 21:28:59 rainbow kernel: [    0.000000]   Intel GenuineIntel
Jan 26 21:28:59 rainbow kernel: [    0.000000]   AMD AuthenticAMD
Jan 26 21:28:59 rainbow kernel: [    0.000000]   Centaur CentaurHauls
Jan 26 21:28:59 rainbow kernel: [    0.000000] BIOS-provided physical RAM map:
Jan 26 21:28:59 rainbow kernel: [    0.000000]  BIOS-e820:
0000000000000000 - 000000000009d800 (usable)
Jan 26 21:28:59 rainbow kernel: [    0.000000]  BIOS-e820:
000000000009d800 - 00000000000a0000 (reserved)
Jan 26 21:28:59 rainbow kernel: [    0.000000]  BIOS-e820:
00000000000d2000 - 00000000000d4000 (reserved)
Jan 26 21:28:59 rainbow kernel: [    0.000000]  BIOS-e820:
00000000000e0000 - 0000000000100000 (reserved)
Jan 26 21:28:59 rainbow kernel: [    0.000000]  BIOS-e820:
0000000000100000 - 00000000bf6b0000 (usable)
Jan 26 21:28:59 rainbow kernel: [    0.000000]  BIOS-e820:
00000000bf6b0000 - 00000000bf6cc000 (ACPI data)
Jan 26 21:28:59 rainbow kernel: [    0.000000]  BIOS-e820:
00000000bf6cc000 - 00000000bf700000 (ACPI NVS)
Jan 26 21:28:59 rainbow kernel: [    0.000000]  BIOS-e820:
00000000bf700000 - 00000000c0000000 (reserved)
Jan 26 21:28:59 rainbow kernel: [    0.000000]  BIOS-e820:
00000000f0000000 - 00000000f4000000 (reserved)
Jan 26 21:28:59 rainbow kernel: [    0.000000]  BIOS-e820:
00000000fec00000 - 00000000fec10000 (reserved)
Jan 26 21:28:59 rainbow kernel: [    0.000000]  BIOS-e820:
00000000fed00000 - 00000000fed00400 (reserved)
Jan 26 21:28:59 rainbow kernel: [    0.000000]  BIOS-e820:
00000000fed14000 - 00000000fed1a000 (reserved)
Jan 26 21:28:59 rainbow kernel: [    0.000000]  BIOS-e820:
00000000fed1c000 - 00000000fed90000 (reserved)
Jan 26 21:28:59 rainbow kernel: [    0.000000]  BIOS-e820:
00000000fee00000 - 00000000fee01000 (reserved)
Jan 26 21:28:59 rainbow kernel: [    0.000000]  BIOS-e820:
00000000ff000000 - 0000000100000000 (reserved)
Jan 26 21:28:59 rainbow kernel: [    0.000000]  BIOS-e820:
0000000100000000 - 000000013c000000 (usable)
Jan 26 21:28:59 rainbow kernel: [    0.000000] DMI present.
Jan 26 21:28:59 rainbow kernel: [    0.000000] last_pfn = 0x13c000
max_arch_pfn = 0x100000000
Jan 26 21:28:59 rainbow kernel: [    0.000000] last_pfn = 0xbf6b0
max_arch_pfn = 0x100000000
Jan 26 21:28:59 rainbow kernel: [    0.000000] init_memory_mapping:
0000000000000000-00000000bf6b0000
Jan 26 21:28:59 rainbow kernel: [    0.000000]  0000000000 - 00bf600000 page 2M
Jan 26 21:28:59 rainbow kernel: [    0.000000]  00bf600000 - 00bf6b0000 page 4k
Jan 26 21:28:59 rainbow kernel: [    0.000000] kernel direct mapping
tables up to bf6b0000 @ 8000-d000
Jan 26 21:28:59 rainbow kernel: [    0.000000] last_map_addr: bf6b0000
end: bf6b0000
Jan 26 21:28:59 rainbow kernel: [    0.000000] init_memory_mapping:
0000000100000000-000000013c000000
Jan 26 21:28:59 rainbow kernel: [    0.000000]  0100000000 - 013c000000 page 2M
Jan 26 21:28:59 rainbow kernel: [    0.000000] kernel direct mapping
tables up to 13c000000 @ b000-11000
Jan 26 21:28:59 rainbow kernel: [    0.000000] last_map_addr:
13c000000 end: 13c000000
Jan 26 21:28:59 rainbow kernel: [    0.000000] RAMDISK: 369d7000 - 37fef8f3
Jan 26 21:28:59 rainbow kernel: [    0.000000] ACPI: RSDP 000F68D0,
0024 (r2 LENOVO)
Jan 26 21:28:59 rainbow kernel: [    0.000000] ACPI: XSDT BF6BB74D,
0094 (r1 LENOVO TP-7L        2120  LTP        0)
Jan 26 21:28:59 rainbow kernel: [    0.000000] ACPI: FACP BF6BB800,
00F4 (r3 LENOVO TP-7L        2120 LNVO        1)
Jan 26 21:28:59 rainbow kernel: [    0.000000] ACPI Warning
(tbfadt-0568): 32/64X length mismatch in Gpe0Block: 64/32 [20081204]
Jan 26 21:28:59 rainbow kernel: [    0.000000] ACPI Warning
(tbfadt-0568): 32/64X length mismatch in Gpe1Block: 0/32 [20081204]
Jan 26 21:28:59 rainbow kernel: [    0.000000] ACPI Warning
(tbfadt-0596): Optional field Gpe1Block has zero address or length:
000000000000102C/0 [20081204]
Jan 26 21:28:59 rainbow kernel: [    0.000000] FADT:
X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
Jan 26 21:28:59 rainbow kernel: [    0.000000] ACPI: DSDT BF6BBC1D,
FF03 (r1 LENOVO TP-7L        2120 MSFT  3000000)
Jan 26 21:28:59 rainbow kernel: [    0.000000] ACPI: FACS BF6E4000, 0040
Jan 26 21:28:59 rainbow kernel: [    0.000000] ACPI: SSDT BF6BB9B4,
0269 (r1 LENOVO TP-7L        2120 MSFT  3000000)
Jan 26 21:28:59 rainbow kernel: [    0.000000] ACPI: ECDT BF6CBB20,
0052 (r1 LENOVO TP-7L        2120 LNVO        1)
Jan 26 21:28:59 rainbow kernel: [    0.000000] ACPI: TCPA BF6CBB72,
0032 (r2 LENOVO TP-7L        2120 LNVO        1)
Jan 26 21:28:59 rainbow kernel: [    0.000000] ACPI: APIC BF6CBBA4,
0068 (r1 LENOVO TP-7L        2120 LNVO        1)
Jan 26 21:28:59 rainbow kernel: [    0.000000] ACPI: MCFG BF6CBC0C,
003C (r1 LENOVO TP-7L        2120 LNVO        1)
Jan 26 21:28:59 rainbow kernel: [    0.000000] ACPI: HPET BF6CBC48,
0038 (r1 LENOVO TP-7L        2120 LNVO        1)
Jan 26 21:28:59 rainbow kernel: [    0.000000] ACPI: SLIC BF6CBDF0,
0176 (r1 LENOVO TP-7L        2120  LTP        0)
Jan 26 21:28:59 rainbow kernel: [    0.000000] ACPI: BOOT BF6CBF66,
0028 (r1 LENOVO TP-7L        2120  LTP        1)
Jan 26 21:28:59 rainbow kernel: [    0.000000] ACPI: ASF! BF6CBF8E,
0072 (r16 LENOVO TP-7L        2120 PTL         1)
Jan 26 21:28:59 rainbow kernel: [    0.000000] ACPI: SSDT BF6E26D9,
025F (r1 LENOVO TP-7L        2120 INTL 20050513)
Jan 26 21:28:59 rainbow kernel: [    0.000000] ACPI: SSDT BF6E2938,
00A6 (r1 LENOVO TP-7L        2120 INTL 20050513)
Jan 26 21:28:59 rainbow kernel: [    0.000000] ACPI: SSDT BF6E29DE,
04F7 (r1 LENOVO TP-7L        2120 INTL 20050513)
Jan 26 21:28:59 rainbow kernel: [    0.000000] ACPI: SSDT BF6E2ED5,
01D8 (r1 LENOVO TP-7L        2120 INTL 20050513)
Jan 26 21:28:59 rainbow kernel: [    0.000000] ACPI: DMI detected:
Lenovo ThinkPad T61
Jan 26 21:28:59 rainbow kernel: [    0.000000] ACPI: Added _OSI(Linux)
Jan 26 21:28:59 rainbow kernel: [    0.000000] ACPI: Local APIC
address 0xfee00000
Jan 26 21:28:59 rainbow kernel: [    0.000000] No NUMA configuration found
Jan 26 21:28:59 rainbow kernel: [    0.000000] Faking a node at
0000000000000000-000000013c000000
Jan 26 21:28:59 rainbow kernel: [    0.000000] Bootmem setup node 0
0000000000000000-000000013c000000
Jan 26 21:28:59 rainbow kernel: [    0.000000]   NODE_DATA
[0000000000001000 - 0000000000005fff]
Jan 26 21:28:59 rainbow kernel: [    0.000000]   bootmap
[000000000000c000 -  00000000000337ff] pages 28
Jan 26 21:28:59 rainbow kernel: [    0.000000] (7 early reservations)
==> bootmem [0000000000 - 013c000000]
Jan 26 21:28:59 rainbow kernel: [    0.000000]   #0 [0000000000 -
0000001000]   BIOS data page ==> [0000000000 - 0000001000]
Jan 26 21:28:59 rainbow kernel: [    0.000000]   #1 [0000006000 -
0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
Jan 26 21:28:59 rainbow kernel: [    0.000000]   #2 [0000200000 -
00008ec840]    TEXT DATA BSS ==> [0000200000 - 00008ec840]
Jan 26 21:28:59 rainbow kernel: [    0.000000]   #3 [00369d7000 -
0037fef8f3]          RAMDISK ==> [00369d7000 - 0037fef8f3]
Jan 26 21:28:59 rainbow kernel: [    0.000000]   #4 [000009d800 -
0000100000]    BIOS reserved ==> [000009d800 - 0000100000]
Jan 26 21:28:59 rainbow kernel: [    0.000000]   #5 [0000008000 -
000000b000]          PGTABLE ==> [0000008000 - 000000b000]
Jan 26 21:28:59 rainbow kernel: [    0.000000]   #6 [000000b000 -
000000c000]          PGTABLE ==> [000000b000 - 000000c000]
Jan 26 21:28:59 rainbow kernel: [    0.000000] found SMP MP-table at
[ffff8800000f6900] 000f6900
Jan 26 21:28:59 rainbow kernel: [    0.000000]
[ffffe20000000000-ffffe200045fffff] PMD ->
[ffff880028200000-ffff88002b9fffff] on node 0
Jan 26 21:28:59 rainbow kernel: [    0.000000] Zone PFN ranges:
Jan 26 21:28:59 rainbow kernel: [    0.000000]   DMA      0x00000000
-> 0x00001000
Jan 26 21:28:59 rainbow kernel: [    0.000000]   DMA32    0x00001000
-> 0x00100000
Jan 26 21:28:59 rainbow kernel: [    0.000000]   Normal   0x00100000
-> 0x0013c000
Jan 26 21:28:59 rainbow kernel: [    0.000000] Movable zone start PFN
for each node
Jan 26 21:28:59 rainbow kernel: [    0.000000] early_node_map[3]
active PFN ranges
Jan 26 21:28:59 rainbow kernel: [    0.000000]     0: 0x00000000 -> 0x0000009d
Jan 26 21:28:59 rainbow kernel: [    0.000000]     0: 0x00000100 -> 0x000bf6b0
Jan 26 21:28:59 rainbow kernel: [    0.000000]     0: 0x00100000 -> 0x0013c000
Jan 26 21:28:59 rainbow kernel: [    0.000000] On node 0 totalpages: 1029709
Jan 26 21:28:59 rainbow kernel: [    0.000000]   DMA zone: 56 pages
used for memmap
Jan 26 21:28:59 rainbow kernel: [    0.000000]   DMA zone: 1879 pages reserved
Jan 26 21:28:59 rainbow kernel: [    0.000000]   DMA zone: 2062 pages,
LIFO batch:0
Jan 26 21:28:59 rainbow kernel: [    0.000000]   DMA32 zone: 14280
pages used for memmap
Jan 26 21:28:59 rainbow kernel: [    0.000000]   DMA32 zone: 765672
pages, LIFO batch:31
Jan 26 21:28:59 rainbow kernel: [    0.000000]   Normal zone: 3360
pages used for memmap
Jan 26 21:28:59 rainbow kernel: [    0.000000]   Normal zone: 242400
pages, LIFO batch:31
Jan 26 21:28:59 rainbow kernel: [    0.000000] ACPI: PM-Timer IO Port: 0x1008
Jan 26 21:28:59 rainbow kernel: [    0.000000] ACPI: Local APIC
address 0xfee00000
Jan 26 21:28:59 rainbow kernel: [    0.000000] ACPI: LAPIC
(acpi_id[0x00] lapic_id[0x00] enabled)
Jan 26 21:28:59 rainbow kernel: [    0.000000] ACPI: LAPIC
(acpi_id[0x01] lapic_id[0x01] enabled)
Jan 26 21:28:59 rainbow kernel: [    0.000000] ACPI: LAPIC_NMI
(acpi_id[0x00] high edge lint[0x1])
Jan 26 21:28:59 rainbow kernel: [    0.000000] ACPI: LAPIC_NMI
(acpi_id[0x01] high edge lint[0x1])
Jan 26 21:28:59 rainbow kernel: [    0.000000] ACPI: IOAPIC (id[0x01]
address[0xfec00000] gsi_base[0])
Jan 26 21:28:59 rainbow kernel: [    0.000000] IOAPIC[0]: apic_id 1,
version 0, address 0xfec00000, GSI 0-23
Jan 26 21:28:59 rainbow kernel: [    0.000000] ACPI: INT_SRC_OVR (bus
0 bus_irq 0 global_irq 2 dfl dfl)
Jan 26 21:28:59 rainbow kernel: [    0.000000] ACPI: INT_SRC_OVR (bus
0 bus_irq 9 global_irq 9 high level)
Jan 26 21:28:59 rainbow kernel: [    0.000000] ACPI: IRQ0 used by override.
Jan 26 21:28:59 rainbow kernel: [    0.000000] ACPI: IRQ2 used by override.
Jan 26 21:28:59 rainbow kernel: [    0.000000] ACPI: IRQ9 used by override.
Jan 26 21:28:59 rainbow kernel: [    0.000000] Using ACPI (MADT) for
SMP configuration information
Jan 26 21:28:59 rainbow kernel: [    0.000000] ACPI: HPET id:
0x8086a201 base: 0xfed00000
Jan 26 21:28:59 rainbow kernel: [    0.000000] SMP: Allowing 2 CPUs, 0
hotplug CPUs
Jan 26 21:28:59 rainbow kernel: [    0.000000] PM: Registered nosave
memory: 000000000009d000 - 000000000009e000
Jan 26 21:28:59 rainbow kernel: [    0.000000] PM: Registered nosave
memory: 000000000009e000 - 00000000000a0000
Jan 26 21:28:59 rainbow kernel: [    0.000000] PM: Registered nosave
memory: 00000000000a0000 - 00000000000d2000
Jan 26 21:28:59 rainbow kernel: [    0.000000] PM: Registered nosave
memory: 00000000000d2000 - 00000000000d4000
Jan 26 21:28:59 rainbow kernel: [    0.000000] PM: Registered nosave
memory: 00000000000d4000 - 00000000000e0000
Jan 26 21:28:59 rainbow kernel: [    0.000000] PM: Registered nosave
memory: 00000000000e0000 - 0000000000100000
Jan 26 21:28:59 rainbow kernel: [    0.000000] PM: Registered nosave
memory: 00000000bf6b0000 - 00000000bf6cc000
Jan 26 21:28:59 rainbow kernel: [    0.000000] PM: Registered nosave
memory: 00000000bf6cc000 - 00000000bf700000
Jan 26 21:28:59 rainbow kernel: [    0.000000] PM: Registered nosave
memory: 00000000bf700000 - 00000000c0000000
Jan 26 21:28:59 rainbow kernel: [    0.000000] PM: Registered nosave
memory: 00000000c0000000 - 00000000f0000000
Jan 26 21:28:59 rainbow kernel: [    0.000000] PM: Registered nosave
memory: 00000000f0000000 - 00000000f4000000
Jan 26 21:28:59 rainbow kernel: [    0.000000] PM: Registered nosave
memory: 00000000f4000000 - 00000000fec00000
Jan 26 21:28:59 rainbow kernel: [    0.000000] PM: Registered nosave
memory: 00000000fec00000 - 00000000fec10000
Jan 26 21:28:59 rainbow kernel: [    0.000000] PM: Registered nosave
memory: 00000000fec10000 - 00000000fed00000
Jan 26 21:28:59 rainbow kernel: [    0.000000] PM: Registered nosave
memory: 00000000fed00000 - 00000000fed14000
Jan 26 21:28:59 rainbow kernel: [    0.000000] PM: Registered nosave
memory: 00000000fed14000 - 00000000fed1a000
Jan 26 21:28:59 rainbow kernel: [    0.000000] PM: Registered nosave
memory: 00000000fed1a000 - 00000000fed1c000
Jan 26 21:28:59 rainbow kernel: [    0.000000] PM: Registered nosave
memory: 00000000fed1c000 - 00000000fed90000
Jan 26 21:28:59 rainbow kernel: [    0.000000] PM: Registered nosave
memory: 00000000fed90000 - 00000000fee00000
Jan 26 21:28:59 rainbow kernel: [    0.000000] PM: Registered nosave
memory: 00000000fee00000 - 00000000fee01000
Jan 26 21:28:59 rainbow kernel: [    0.000000] PM: Registered nosave
memory: 00000000fee01000 - 00000000ff000000
Jan 26 21:28:59 rainbow kernel: [    0.000000] PM: Registered nosave
memory: 00000000ff000000 - 0000000100000000
Jan 26 21:28:59 rainbow kernel: [    0.000000] Allocating PCI
resources starting at c4000000 (gap: c0000000:30000000)
Jan 26 21:28:59 rainbow kernel: [    0.000000] NR_CPUS:64
nr_cpumask_bits:64 nr_cpu_ids:2 nr_node_ids:1
Jan 26 21:28:59 rainbow kernel: [    0.000000] PERCPU: Allocating
65536 bytes of per cpu data
Jan 26 21:28:59 rainbow kernel: [    0.000000] Built 1 zonelists in
Node order, mobility grouping on.  Total pages: 1010134
Jan 26 21:28:59 rainbow kernel: [    0.000000] Policy zone: Normal
Jan 26 21:28:59 rainbow kernel: [    0.000000] Kernel command line:
root=UUID=b49fa89a-8364-4ea0-b712-438b002b45c1 ro debug
netconsole=@169.254.1.1/eth0,@169.254.242.220/
Jan 26 21:28:59 rainbow kernel: [    0.000000] Initializing CPU#0
Jan 26 21:28:59 rainbow kernel: [    0.000000] PID hash table entries:
4096 (order: 12, 32768 bytes)
Jan 26 21:28:59 rainbow kernel: [    0.000000] Extended CMOS year: 2000
Jan 26 21:28:59 rainbow kernel: [    0.000000] Fast TSC calibration using PIT
Jan 26 21:28:59 rainbow kernel: [    0.000000] Detected 2194.420 MHz processor.
Jan 26 21:28:59 rainbow kernel: [    0.004000] Console: colour VGA+ 80x25
Jan 26 21:28:59 rainbow kernel: [    0.004000] console [tty0] enabled
Jan 26 21:28:59 rainbow kernel: [    0.004000] allocated 41943040
bytes of page_cgroup
Jan 26 21:28:59 rainbow kernel: [    0.004000] please try
cgroup_disable=memory option if you don't want
Jan 26 21:28:59 rainbow kernel: [    0.004000] Checking aperture...
Jan 26 21:28:59 rainbow kernel: [    0.004000] No AGP bridge found
Jan 26 21:28:59 rainbow kernel: [    0.004000] PCI-DMA: Using software
bounce buffering for IO (SWIOTLB)
Jan 26 21:28:59 rainbow kernel: [    0.004000] Placing 64MB software
IO TLB between ffff880020000000 - ffff880024000000
Jan 26 21:28:59 rainbow kernel: [    0.004000] software IO TLB at phys
0x20000000 - 0x24000000
Jan 26 21:28:59 rainbow kernel: [    0.004000] Memory:
3924480k/5177344k available (3232k kernel code, 1058508k absent,
194356k reserved, 1772k data, 552k init)
Jan 26 21:28:59 rainbow kernel: [    0.004000] SLUB: Genslabs=13,
HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
Jan 26 21:28:59 rainbow kernel: [    0.004000] hpet clockevent registered
Jan 26 21:28:59 rainbow kernel: [    0.004000] HPET: 3 timers in
total, 0 timers will be used for per-cpu timer
Jan 26 21:28:59 rainbow kernel: [    0.004000] Calibrating delay loop
(skipped), value calculated using timer frequency.. 4388.84 BogoMIPS
(lpj=8777680)
Jan 26 21:28:59 rainbow kernel: [    0.004000] Security Framework initialized
Jan 26 21:28:59 rainbow kernel: [    0.004000] SELinux:  Disabled at boot.
Jan 26 21:28:59 rainbow kernel: [    0.004000] Dentry cache hash table
entries: 524288 (order: 10, 4194304 bytes)
Jan 26 21:28:59 rainbow kernel: [    0.004000] Inode-cache hash table
entries: 262144 (order: 9, 2097152 bytes)
Jan 26 21:28:59 rainbow kernel: [    0.004797] Mount-cache hash table
entries: 256
Jan 26 21:28:59 rainbow kernel: [    0.005008] Initializing cgroup subsys ns
Jan 26 21:28:59 rainbow kernel: [    0.005685] Initializing cgroup
subsys cpuacct
Jan 26 21:28:59 rainbow kernel: [    0.005741] Initializing cgroup subsys memory
Jan 26 21:28:59 rainbow kernel: [    0.005796] Initializing cgroup
subsys freezer
Jan 26 21:28:59 rainbow kernel: [    0.005860] CPU: L1 I cache: 32K,
L1 D cache: 32K
Jan 26 21:28:59 rainbow kernel: [    0.005949] CPU: L2 cache: 4096K
Jan 26 21:28:59 rainbow kernel: [    0.006003] [ds] using core 2 configuration
Jan 26 21:28:59 rainbow kernel: [    0.006057] CPU 0/0x0 -> Node 0
Jan 26 21:28:59 rainbow kernel: [    0.006109] CPU: Physical Processor ID: 0
Jan 26 21:28:59 rainbow kernel: [    0.006163] CPU: Processor Core ID: 0
Jan 26 21:28:59 rainbow kernel: [    0.006222] CPU0: Thermal
monitoring enabled (TM2)
Jan 26 21:28:59 rainbow kernel: [    0.006273] using mwait in idle threads.
Jan 26 21:28:59 rainbow kernel: [    0.008091] ACPI: Core revision 20081204
Jan 26 21:28:59 rainbow kernel: [    0.032059] Setting APIC routing to flat
Jan 26 21:28:59 rainbow kernel: [    0.032656] ..TIMER: vector=0x30
apic1=0 pin1=2 apic2=-1 pin2=-1
Jan 26 21:28:59 rainbow kernel: [    0.074255] CPU0: Intel(R)
Core(TM)2 Duo CPU     T7500  @ 2.20GHz stepping 0b
Jan 26 21:28:59 rainbow kernel: [    0.076001] Booting processor 1
APIC 0x1 ip 0x6000
Jan 26 21:28:59 rainbow kernel: [    0.004000] Initializing CPU#1
Jan 26 21:28:59 rainbow kernel: [    0.004000] Calibrating delay using
timer specific routine.. 4388.96 BogoMIPS (lpj=8777920)
Jan 26 21:28:59 rainbow kernel: [    0.004000] CPU: L1 I cache: 32K,
L1 D cache: 32K
Jan 26 21:28:59 rainbow kernel: [    0.004000] CPU: L2 cache: 4096K
Jan 26 21:28:59 rainbow kernel: [    0.004000] [ds] using core 2 configuration
Jan 26 21:28:59 rainbow kernel: [    0.004000] CPU 1/0x1 -> Node 0
Jan 26 21:28:59 rainbow kernel: [    0.004000] CPU: Physical Processor ID: 0
Jan 26 21:28:59 rainbow kernel: [    0.004000] CPU: Processor Core ID: 1
Jan 26 21:28:59 rainbow kernel: [    0.004000] CPU1: Thermal
monitoring enabled (TM2)
Jan 26 21:28:59 rainbow kernel: [    0.160613] CPU1: Intel(R)
Core(TM)2 Duo CPU     T7500  @ 2.20GHz stepping 0b
Jan 26 21:28:59 rainbow kernel: [    0.161378] checking TSC
synchronization [CPU#0 -> CPU#1]:
Jan 26 21:28:59 rainbow kernel: [    0.164001] Measured 1223145 cycles
TSC warp between CPUs, turning off TSC clock.
Jan 26 21:28:59 rainbow kernel: [    0.164001] Marking TSC unstable
due to check_tsc_sync_source failed
Jan 26 21:28:59 rainbow kernel: [    0.164095] Brought up 2 CPUs
Jan 26 21:28:59 rainbow kernel: [    0.164161] Total of 2 processors
activated (8777.80 BogoMIPS).
Jan 26 21:28:59 rainbow kernel: [    0.164290] CPU0 attaching sched-domain:
Jan 26 21:28:59 rainbow kernel: [    0.164355]  domain 0: span 0-1 level MC
Jan 26 21:28:59 rainbow kernel: [    0.164464]   groups: 0 1
Jan 26 21:28:59 rainbow kernel: [    0.164670] CPU1 attaching sched-domain:
Jan 26 21:28:59 rainbow kernel: [    0.164734]  domain 0: span 0-1 level MC
Jan 26 21:28:59 rainbow kernel: [    0.164851]   groups: 1 0
Jan 26 21:28:59 rainbow kernel: [    0.165117] net_namespace: 1840 bytes
Jan 26 21:28:59 rainbow kernel: [    0.165117] Booting paravirtualized
kernel on bare hardware
Jan 26 21:28:59 rainbow kernel: [    0.165117] Time:  2:28:39  Date: 01/27/09
Jan 26 21:28:59 rainbow kernel: [    0.165117] NET: Registered
protocol family 16
Jan 26 21:28:59 rainbow kernel: [    0.165117] ACPI FADT declares the
system doesn't support PCIe ASPM, so disable it
Jan 26 21:28:59 rainbow kernel: [    0.165117] ACPI: bus type pci registered
Jan 26 21:28:59 rainbow kernel: [    0.165117] PCI: MCFG configuration
0: base f0000000 segment 0 buses 0 - 63
Jan 26 21:28:59 rainbow kernel: [    0.168004] PCI: MCFG area at
f0000000 reserved in E820
Jan 26 21:28:59 rainbow kernel: [    0.170585] PCI: Using MMCONFIG at
f0000000 - f3ffffff
Jan 26 21:28:59 rainbow kernel: [    0.170653] PCI: Using
configuration type 1 for base access
Jan 26 21:28:59 rainbow kernel: [    0.170726] bio: create slab <bio-0> at 0
Jan 26 21:28:59 rainbow kernel: [    0.173344] ACPI: EC: EC
description table is found, configuring boot EC
Jan 26 21:28:59 rainbow kernel: [    0.180529] ACPI: BIOS _OSI(Linux)
query honored via DMI
Jan 26 21:28:59 rainbow kernel: [    0.180026] ACPI: EC: non-query
interrupt received, switching to interrupt mode
Jan 26 21:28:59 rainbow kernel: [    0.190234] ACPI: Interpreter enabled
Jan 26 21:28:59 rainbow kernel: [    0.190298] ACPI: (supports S0 S3 S4 S5)
Jan 26 21:28:59 rainbow kernel: [    0.190558] ACPI: Using IOAPIC for
interrupt routing
Jan 26 21:28:59 rainbow kernel: [    0.209094] ACPI: EC: GPE = 0x12,
I/O: command/status = 0x66, data = 0x62
Jan 26 21:28:59 rainbow kernel: [    0.209162] ACPI: EC: driver
started in interrupt mode
Jan 26 21:28:59 rainbow kernel: [    0.212993] ACPI: ACPI Dock Station
Driver: 3 docks/bays found
Jan 26 21:28:59 rainbow kernel: [    0.213440] ACPI: PCI Root Bridge
[PCI0] (0000:00)
Jan 26 21:28:59 rainbow kernel: [    0.213535] pci 0000:00:02.0: reg
10 64bit mmio: [0xf8100000-0xf81fffff]
Jan 26 21:28:59 rainbow kernel: [    0.213535] pci 0000:00:02.0: reg
18 64bit mmio: [0xe0000000-0xefffffff]
Jan 26 21:28:59 rainbow kernel: [    0.213535] pci 0000:00:02.0: reg
20 io port: [0x1800-0x1807]
Jan 26 21:28:59 rainbow kernel: [    0.213535] pci 0000:00:02.1: reg
10 64bit mmio: [0xf8200000-0xf82fffff]
Jan 26 21:28:59 rainbow kernel: [    0.213535] pci 0000:00:19.0: reg
10 32bit mmio: [0xfe000000-0xfe01ffff]
Jan 26 21:28:59 rainbow kernel: [    0.213535] pci 0000:00:19.0: reg
14 32bit mmio: [0xfe025000-0xfe025fff]
Jan 26 21:28:59 rainbow kernel: [    0.213535] pci 0000:00:19.0: reg
18 io port: [0x1840-0x185f]
Jan 26 21:28:59 rainbow kernel: [    0.213535] pci 0000:00:19.0: PME#
supported from D0 D3hot D3cold
Jan 26 21:28:59 rainbow kernel: [    0.213535] pci 0000:00:19.0: PME# disabled
Jan 26 21:28:59 rainbow kernel: [    0.213535] pci 0000:00:1a.0: reg
20 io port: [0x1860-0x187f]
Jan 26 21:28:59 rainbow kernel: [    0.213535] pci 0000:00:1a.1: reg
20 io port: [0x1880-0x189f]
Jan 26 21:28:59 rainbow kernel: [    0.216116] pci 0000:00:1a.7: reg
10 32bit mmio: [0xfe226c00-0xfe226fff]
Jan 26 21:28:59 rainbow kernel: [    0.216274] pci 0000:00:1a.7: PME#
supported from D0 D3hot D3cold
Jan 26 21:28:59 rainbow kernel: [    0.216345] pci 0000:00:1a.7: PME# disabled
Jan 26 21:28:59 rainbow kernel: [    0.216507] pci 0000:00:1b.0: reg
10 64bit mmio: [0xfe020000-0xfe023fff]
Jan 26 21:28:59 rainbow kernel: [    0.216682] pci 0000:00:1b.0: PME#
supported from D0 D3hot D3cold
Jan 26 21:28:59 rainbow kernel: [    0.216750] pci 0000:00:1b.0: PME# disabled
Jan 26 21:28:59 rainbow kernel: [    0.216950] pci 0000:00:1c.0: PME#
supported from D0 D3hot D3cold
Jan 26 21:28:59 rainbow kernel: [    0.217028] pci 0000:00:1c.0: PME# disabled
Jan 26 21:28:59 rainbow kernel: [    0.217238] pci 0000:00:1c.1: PME#
supported from D0 D3hot D3cold
Jan 26 21:28:59 rainbow kernel: [    0.217309] pci 0000:00:1c.1: PME# disabled
Jan 26 21:28:59 rainbow kernel: [    0.217516] pci 0000:00:1c.2: PME#
supported from D0 D3hot D3cold
Jan 26 21:28:59 rainbow kernel: [    0.217590] pci 0000:00:1c.2: PME# disabled
Jan 26 21:28:59 rainbow kernel: [    0.217798] pci 0000:00:1c.3: PME#
supported from D0 D3hot D3cold
Jan 26 21:28:59 rainbow kernel: [    0.217874] pci 0000:00:1c.3: PME# disabled
Jan 26 21:28:59 rainbow kernel: [    0.218082] pci 0000:00:1c.4: PME#
supported from D0 D3hot D3cold
Jan 26 21:28:59 rainbow kernel: [    0.218158] pci 0000:00:1c.4: PME# disabled
Jan 26 21:28:59 rainbow kernel: [    0.218341] pci 0000:00:1d.0: reg
20 io port: [0x18a0-0x18bf]
Jan 26 21:28:59 rainbow kernel: [    0.218536] pci 0000:00:1d.1: reg
20 io port: [0x18c0-0x18df]
Jan 26 21:28:59 rainbow kernel: [    0.218729] pci 0000:00:1d.2: reg
20 io port: [0x18e0-0x18ff]
Jan 26 21:28:59 rainbow kernel: [    0.218921] pci 0000:00:1d.7: reg
10 32bit mmio: [0xfe227000-0xfe2273ff]
Jan 26 21:28:59 rainbow kernel: [    0.219101] pci 0000:00:1d.7: PME#
supported from D0 D3hot D3cold
Jan 26 21:28:59 rainbow kernel: [    0.219175] pci 0000:00:1d.7: PME# disabled
Jan 26 21:28:59 rainbow kernel: [    0.219522] pci 0000:00:1f.0:
quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
Jan 26 21:28:59 rainbow kernel: [    0.219604] pci 0000:00:1f.0:
quirk: region 1180-11bf claimed by ICH6 GPIO
Jan 26 21:28:59 rainbow kernel: [    0.219679] pci 0000:00:1f.0: ICH7
LPC Generic IO decode 1 PIO at 1600 (mask 007f)
Jan 26 21:28:59 rainbow kernel: [    0.219762] pci 0000:00:1f.0: ICH7
LPC Generic IO decode 2 PIO at 15e0 (mask 000f)
Jan 26 21:28:59 rainbow kernel: [    0.219842] pci 0000:00:1f.0: ICH7
LPC Generic IO decode 3 PIO at 1680 (mask 001f)
Jan 26 21:28:59 rainbow kernel: [    0.220058] pci 0000:00:1f.1: reg
10 io port: [0x00-0x07]
Jan 26 21:28:59 rainbow kernel: [    0.220137] pci 0000:00:1f.1: reg
14 io port: [0x00-0x03]
Jan 26 21:28:59 rainbow kernel: [    0.220219] pci 0000:00:1f.1: reg
18 io port: [0x00-0x07]
Jan 26 21:28:59 rainbow kernel: [    0.220296] pci 0000:00:1f.1: reg
1c io port: [0x00-0x03]
Jan 26 21:28:59 rainbow kernel: [    0.220370] pci 0000:00:1f.1: reg
20 io port: [0x1c00-0x1c0f]
Jan 26 21:28:59 rainbow kernel: [    0.220561] pci 0000:00:1f.2: reg
10 io port: [0x1c50-0x1c57]
Jan 26 21:28:59 rainbow kernel: [    0.220637] pci 0000:00:1f.2: reg
14 io port: [0x1c44-0x1c47]
Jan 26 21:28:59 rainbow kernel: [    0.220710] pci 0000:00:1f.2: reg
18 io port: [0x1c48-0x1c4f]
Jan 26 21:28:59 rainbow kernel: [    0.220787] pci 0000:00:1f.2: reg
1c io port: [0x1c40-0x1c43]
Jan 26 21:28:59 rainbow kernel: [    0.220864] pci 0000:00:1f.2: reg
20 io port: [0x1c20-0x1c3f]
Jan 26 21:28:59 rainbow kernel: [    0.220951] pci 0000:00:1f.2: reg
24 32bit mmio: [0xfe226000-0xfe2267ff]
Jan 26 21:28:59 rainbow kernel: [    0.221068] pci 0000:00:1f.2: PME#
supported from D3hot
Jan 26 21:28:59 rainbow kernel: [    0.221145] pci 0000:00:1f.2: PME# disabled
Jan 26 21:28:59 rainbow kernel: [    0.221264] pci 0000:00:1f.3: reg
10 32bit mmio: [0xfe227400-0xfe2274ff]
Jan 26 21:28:59 rainbow kernel: [    0.221370] pci 0000:00:1f.3: reg
20 io port: [0x1c60-0x1c7f]
Jan 26 21:28:59 rainbow kernel: [    0.221556] pci 0000:00:1c.0:
bridge io port: [0x2000-0x2fff]
Jan 26 21:28:59 rainbow kernel: [    0.221632] pci 0000:00:1c.0:
bridge 32bit mmio: [0xfc000000-0xfdffffff]
Jan 26 21:28:59 rainbow kernel: [    0.221708] pci 0000:00:1c.0:
bridge 64bit mmio pref: [0xf8000000-0xf80fffff]
Jan 26 21:28:59 rainbow kernel: [    0.221968] pci 0000:03:00.0: reg
10 32bit mmio: [0xdf3ff000-0xdf3fffff]
Jan 26 21:28:59 rainbow kernel: [    0.222264] pci 0000:03:00.0: PME#
supported from D0 D3hot D3cold
Jan 26 21:28:59 rainbow kernel: [    0.222327] pci 0000:03:00.0: PME# disabled
Jan 26 21:28:59 rainbow kernel: [    0.222478] pci 0000:00:1c.1:
bridge io port: [0x3000-0x3fff]
Jan 26 21:28:59 rainbow kernel: [    0.222544] pci 0000:00:1c.1:
bridge 32bit mmio: [0xdc000000-0xdf3fffff]
Jan 26 21:28:59 rainbow kernel: [    0.222618] pci 0000:00:1c.1:
bridge 64bit mmio pref: [0xdfe00000-0xdfefffff]
Jan 26 21:28:59 rainbow kernel: [    0.222765] pci 0000:00:1c.2:
bridge io port: [0x4000-0x4fff]
Jan 26 21:28:59 rainbow kernel: [    0.222835] pci 0000:00:1c.2:
bridge 32bit mmio: [0xd8000000-0xd9ffffff]
Jan 26 21:28:59 rainbow kernel: [    0.222910] pci 0000:00:1c.2:
bridge 64bit mmio pref: [0xdfb00000-0xdfbfffff]
Jan 26 21:28:59 rainbow kernel: [    0.223075] pci 0000:00:1c.3:
bridge io port: [0x5000-0x5fff]
Jan 26 21:28:59 rainbow kernel: [    0.223147] pci 0000:00:1c.3:
bridge 32bit mmio: [0xd4000000-0xd5ffffff]
Jan 26 21:28:59 rainbow kernel: [    0.223227] pci 0000:00:1c.3:
bridge 64bit mmio pref: [0xdf800000-0xdf8fffff]
Jan 26 21:28:59 rainbow kernel: [    0.223376] pci 0000:00:1c.4:
bridge io port: [0x6000-0x6fff]
Jan 26 21:28:59 rainbow kernel: [    0.223446] pci 0000:00:1c.4:
bridge 32bit mmio: [0xd0000000-0xd1ffffff]
Jan 26 21:28:59 rainbow kernel: [    0.223523] pci 0000:00:1c.4:
bridge 64bit mmio pref: [0xdf500000-0xdf5fffff]
Jan 26 21:28:59 rainbow kernel: [    0.223677] pci 0000:15:00.0: reg
10 32bit mmio: [0xf8300000-0xf8300fff]
Jan 26 21:28:59 rainbow kernel: [    0.223792] pci 0000:15:00.0: supports D1 D2
Jan 26 21:28:59 rainbow kernel: [    0.223855] pci 0000:15:00.0: PME#
supported from D0 D1 D2 D3hot D3cold
Jan 26 21:28:59 rainbow kernel: [    0.223928] pci 0000:15:00.0: PME# disabled
Jan 26 21:28:59 rainbow kernel: [    0.224078] pci 0000:15:00.1: reg
10 32bit mmio: [0xf8301000-0xf83017ff]
Jan 26 21:28:59 rainbow kernel: [    0.224261] pci 0000:15:00.1: supports D1 D2
Jan 26 21:28:59 rainbow kernel: [    0.224324] pci 0000:15:00.1: PME#
supported from D0 D1 D2 D3hot D3cold
Jan 26 21:28:59 rainbow kernel: [    0.224399] pci 0000:15:00.1: PME# disabled
Jan 26 21:28:59 rainbow kernel: [    0.224588] pci 0000:00:1e.0:
transparent bridge
Jan 26 21:28:59 rainbow kernel: [    0.224658] pci 0000:00:1e.0:
bridge io port: [0x7000-0xafff]
Jan 26 21:28:59 rainbow kernel: [    0.224734] pci 0000:00:1e.0:
bridge 32bit mmio: [0xf8300000-0xfbffffff]
Jan 26 21:28:59 rainbow kernel: [    0.224815] pci 0000:00:1e.0:
bridge 64bit mmio pref: [0xf4000000-0xf7ffffff]
Jan 26 21:28:59 rainbow kernel: [    0.224985] ACPI: PCI Interrupt
Routing Table [\_SB_.PCI0._PRT]
Jan 26 21:28:59 rainbow kernel: [    0.225211] ACPI: PCI Interrupt
Routing Table [\_SB_.PCI0.EXP0._PRT]
Jan 26 21:28:59 rainbow kernel: [    0.225357] ACPI: PCI Interrupt
Routing Table [\_SB_.PCI0.EXP1._PRT]
Jan 26 21:28:59 rainbow kernel: [    0.225503] ACPI: PCI Interrupt
Routing Table [\_SB_.PCI0.EXP2._PRT]
Jan 26 21:28:59 rainbow kernel: [    0.225649] ACPI: PCI Interrupt
Routing Table [\_SB_.PCI0.EXP3._PRT]
Jan 26 21:28:59 rainbow kernel: [    0.225796] ACPI: PCI Interrupt
Routing Table [\_SB_.PCI0.EXP4._PRT]
Jan 26 21:28:59 rainbow kernel: [    0.225945] ACPI: PCI Interrupt
Routing Table [\_SB_.PCI0.PCI1._PRT]
Jan 26 21:28:59 rainbow kernel: [    0.232182] ACPI: PCI Interrupt
Link [LNKA] (IRQs 3 4 5 6 7 9 *10 11)
Jan 26 21:28:59 rainbow kernel: [    0.232974] ACPI: PCI Interrupt
Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
Jan 26 21:28:59 rainbow kernel: [    0.233767] ACPI: PCI Interrupt
Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
Jan 26 21:28:59 rainbow kernel: [    0.234560] ACPI: PCI Interrupt
Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
Jan 26 21:28:59 rainbow kernel: [    0.235323] ACPI: PCI Interrupt
Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
Jan 26 21:28:59 rainbow kernel: [    0.236168] ACPI: PCI Interrupt
Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
Jan 26 21:28:59 rainbow kernel: [    0.236958] ACPI: PCI Interrupt
Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
Jan 26 21:28:59 rainbow kernel: [    0.237741] ACPI: PCI Interrupt
Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
Jan 26 21:28:59 rainbow kernel: [    0.238374] ACPI: Power Resource [PUBS] (on)
Jan 26 21:28:59 rainbow kernel: [    0.238374] PCI: Using ACPI for IRQ routing
Jan 26 21:28:59 rainbow kernel: [    0.252030] NET: Registered protocol family 8
Jan 26 21:28:59 rainbow kernel: [    0.252094] NET: Registered
protocol family 20
Jan 26 21:28:59 rainbow kernel: [    0.252175] NetLabel: Initializing
Jan 26 21:28:59 rainbow kernel: [    0.252175] NetLabel:  domain hash size = 128
Jan 26 21:28:59 rainbow kernel: [    0.252175] NetLabel:  protocols =
UNLABELED CIPSOv4
Jan 26 21:28:59 rainbow kernel: [    0.252205] NetLabel:  unlabeled
traffic allowed by default
Jan 26 21:28:59 rainbow kernel: [    0.252360] hpet0: at MMIO
0xfed00000, IRQs 2, 8, 0
Jan 26 21:28:59 rainbow kernel: [    0.252622] hpet0: 3 comparators,
64-bit 14.318180 MHz counter
Jan 26 21:28:59 rainbow kernel: [    0.260012] Switched to high
resolution mode on CPU 0
Jan 26 21:28:59 rainbow kernel: [    0.261737] Switched to high
resolution mode on CPU 1
Jan 26 21:28:59 rainbow kernel: [    0.269021] pnp: PnP ACPI init
Jan 26 21:28:59 rainbow kernel: [    0.269091] ACPI: bus type pnp registered
Jan 26 21:28:59 rainbow kernel: [    0.275257] pnp: PnP ACPI: found 11 devices
Jan 26 21:28:59 rainbow kernel: [    0.275324] ACPI: ACPI bus type pnp
unregistered
Jan 26 21:28:59 rainbow kernel: [    0.275997] system 00:00: iomem
range 0x0-0x9ffff could not be reserved
Jan 26 21:28:59 rainbow kernel: [    0.276082] system 00:00: iomem
range 0xc0000-0xc3fff has been reserved
Jan 26 21:28:59 rainbow kernel: [    0.276152] system 00:00: iomem
range 0xc4000-0xc7fff has been reserved
Jan 26 21:28:59 rainbow kernel: [    0.276222] system 00:00: iomem
range 0xc8000-0xcbfff has been reserved
Jan 26 21:28:59 rainbow kernel: [    0.276292] system 00:00: iomem
range 0xcc000-0xcffff has been reserved
Jan 26 21:28:59 rainbow kernel: [    0.276362] system 00:00: iomem
range 0xd0000-0xd3fff could not be reserved
Jan 26 21:28:59 rainbow kernel: [    0.276431] system 00:00: iomem
range 0xe0000-0xe3fff could not be reserved
Jan 26 21:28:59 rainbow kernel: [    0.276501] system 00:00: iomem
range 0xe4000-0xe7fff could not be reserved
Jan 26 21:28:59 rainbow kernel: [    0.276570] system 00:00: iomem
range 0xe8000-0xebfff could not be reserved
Jan 26 21:28:59 rainbow kernel: [    0.276638] system 00:00: iomem
range 0xec000-0xeffff could not be reserved
Jan 26 21:28:59 rainbow kernel: [    0.276707] system 00:00: iomem
range 0xf0000-0xfffff could not be reserved
Jan 26 21:28:59 rainbow kernel: [    0.276774] system 00:00: iomem
range 0x100000-0xbfffffff could not be reserved
Jan 26 21:28:59 rainbow kernel: [    0.276853] system 00:00: iomem
range 0xfec00000-0xfed3ffff could not be reserved
Jan 26 21:28:59 rainbow kernel: [    0.276928] system 00:00: iomem
range 0xfed4c000-0xffffffff could not be reserved
Jan 26 21:28:59 rainbow kernel: [    0.277009] system 00:02: ioport
range 0x164e-0x164f has been reserved
Jan 26 21:28:59 rainbow kernel: [    0.277083] system 00:02: ioport
range 0x1000-0x107f has been reserved
Jan 26 21:28:59 rainbow kernel: [    0.277147] system 00:02: ioport
range 0x1180-0x11bf has been reserved
Jan 26 21:28:59 rainbow kernel: [    0.277214] system 00:02: ioport
range 0x800-0x80f has been reserved
Jan 26 21:28:59 rainbow kernel: [    0.277280] system 00:02: ioport
range 0x15e0-0x15ef has been reserved
Jan 26 21:28:59 rainbow kernel: [    0.277345] system 00:02: ioport
range 0x1600-0x165f could not be reserved
Jan 26 21:28:59 rainbow kernel: [    0.277414] system 00:02: iomem
range 0xf0000000-0xf3ffffff has been reserved
Jan 26 21:28:59 rainbow kernel: [    0.277481] system 00:02: iomem
range 0xfed1c000-0xfed1ffff has been reserved
Jan 26 21:28:59 rainbow kernel: [    0.277549] system 00:02: iomem
range 0xfed14000-0xfed17fff has been reserved
Jan 26 21:28:59 rainbow kernel: [    0.277618] system 00:02: iomem
range 0xfed18000-0xfed18fff has been reserved
Jan 26 21:28:59 rainbow kernel: [    0.277685] system 00:02: iomem
range 0xfed19000-0xfed19fff has been reserved
Jan 26 21:28:59 rainbow kernel: [    0.277758] system 00:02: iomem
range 0xfed45000-0xfed4bfff has been reserved
Jan 26 21:28:59 rainbow kernel: [    0.282936] pci 0000:00:1c.0: PCI
bridge, secondary bus 0000:02
Jan 26 21:28:59 rainbow kernel: [    0.283004] pci 0000:00:1c.0:   IO
window: 0x2000-0x2fff
Jan 26 21:28:59 rainbow kernel: [    0.283080] pci 0000:00:1c.0:   MEM
window: 0xfc000000-0xfdffffff
Jan 26 21:28:59 rainbow kernel: [    0.283150] pci 0000:00:1c.0:
PREFETCH window: 0x000000f8000000-0x000000f80fffff
Jan 26 21:28:59 rainbow kernel: [    0.283238] pci 0000:00:1c.1: PCI
bridge, secondary bus 0000:03
Jan 26 21:28:59 rainbow kernel: [    0.283307] pci 0000:00:1c.1:   IO
window: 0x3000-0x3fff
Jan 26 21:28:59 rainbow kernel: [    0.283383] pci 0000:00:1c.1:   MEM
window: 0xdc000000-0xdf3fffff
Jan 26 21:28:59 rainbow kernel: [    0.283454] pci 0000:00:1c.1:
PREFETCH window: 0x000000dfe00000-0x000000dfefffff
Jan 26 21:28:59 rainbow kernel: [    0.283547] pci 0000:00:1c.2: PCI
bridge, secondary bus 0000:04
Jan 26 21:28:59 rainbow kernel: [    0.283622] pci 0000:00:1c.2:   IO
window: 0x4000-0x4fff
Jan 26 21:28:59 rainbow kernel: [    0.283696] pci 0000:00:1c.2:   MEM
window: 0xd8000000-0xd9ffffff
Jan 26 21:28:59 rainbow kernel: [    0.283769] pci 0000:00:1c.2:
PREFETCH window: 0x000000dfb00000-0x000000dfbfffff
Jan 26 21:28:59 rainbow kernel: [    0.283856] pci 0000:00:1c.3: PCI
bridge, secondary bus 0000:05
Jan 26 21:28:59 rainbow kernel: [    0.283929] pci 0000:00:1c.3:   IO
window: 0x5000-0x5fff
Jan 26 21:28:59 rainbow kernel: [    0.284019] pci 0000:00:1c.3:   MEM
window: 0xd4000000-0xd5ffffff
Jan 26 21:28:59 rainbow kernel: [    0.284094] pci 0000:00:1c.3:
PREFETCH window: 0x000000df800000-0x000000df8fffff
Jan 26 21:28:59 rainbow kernel: [    0.284185] pci 0000:00:1c.4: PCI
bridge, secondary bus 0000:0d
Jan 26 21:28:59 rainbow kernel: [    0.284254] pci 0000:00:1c.4:   IO
window: 0x6000-0x6fff
Jan 26 21:28:59 rainbow kernel: [    0.284328] pci 0000:00:1c.4:   MEM
window: 0xd0000000-0xd1ffffff
Jan 26 21:28:59 rainbow kernel: [    0.284402] pci 0000:00:1c.4:
PREFETCH window: 0x000000df500000-0x000000df5fffff
Jan 26 21:28:59 rainbow kernel: [    0.284491] pci 0000:15:00.0:
CardBus bridge, secondary bus 0000:16
Jan 26 21:28:59 rainbow kernel: [    0.284562] pci 0000:15:00.0:   IO
window: 0x007000-0x0070ff
Jan 26 21:28:59 rainbow kernel: [    0.284629] pci 0000:15:00.0:   IO
window: 0x007400-0x0074ff
Jan 26 21:28:59 rainbow kernel: [    0.284703] pci 0000:15:00.0:
PREFETCH window: 0xf4000000-0xf7ffffff
Jan 26 21:28:59 rainbow kernel: [    0.284771] pci 0000:15:00.0:   MEM
window: 0xc4000000-0xc7ffffff
Jan 26 21:28:59 rainbow kernel: [    0.284844] pci 0000:00:1e.0: PCI
bridge, secondary bus 0000:15
Jan 26 21:28:59 rainbow kernel: [    0.284917] pci 0000:00:1e.0:   IO
window: 0x7000-0xafff
Jan 26 21:28:59 rainbow kernel: [    0.284993] pci 0000:00:1e.0:   MEM
window: 0xf8300000-0xfbffffff
Jan 26 21:28:59 rainbow kernel: [    0.285065] pci 0000:00:1e.0:
PREFETCH window: 0x000000f4000000-0x000000f7ffffff
Jan 26 21:28:59 rainbow kernel: [    0.285167] pci 0000:00:1c.0: PCI
INT A -> GSI 20 (level, low) -> IRQ 20
Jan 26 21:28:59 rainbow kernel: [    0.285243] pci 0000:00:1c.0:
setting latency timer to 64
Jan 26 21:28:59 rainbow kernel: [    0.285325] pci 0000:00:1c.1: PCI
INT B -> GSI 21 (level, low) -> IRQ 21
Jan 26 21:28:59 rainbow kernel: [    0.285402] pci 0000:00:1c.1:
setting latency timer to 64
Jan 26 21:28:59 rainbow kernel: [    0.285480] pci 0000:00:1c.2: PCI
INT C -> GSI 22 (level, low) -> IRQ 22
Jan 26 21:28:59 rainbow kernel: [    0.285552] pci 0000:00:1c.2:
setting latency timer to 64
Jan 26 21:28:59 rainbow kernel: [    0.285630] pci 0000:00:1c.3: PCI
INT D -> GSI 23 (level, low) -> IRQ 23
Jan 26 21:28:59 rainbow kernel: [    0.285702] pci 0000:00:1c.3:
setting latency timer to 64
Jan 26 21:28:59 rainbow kernel: [    0.285781] pci 0000:00:1c.4: PCI
INT A -> GSI 20 (level, low) -> IRQ 20
Jan 26 21:28:59 rainbow kernel: [    0.285855] pci 0000:00:1c.4:
setting latency timer to 64
Jan 26 21:28:59 rainbow kernel: [    0.285926] pci 0000:00:1e.0:
enabling device (0005 -> 0007)
Jan 26 21:28:59 rainbow kernel: [    0.286003] pci 0000:00:1e.0:
setting latency timer to 64
Jan 26 21:28:59 rainbow kernel: [    0.286081] pci 0000:15:00.0: PCI
INT A -> GSI 16 (level, low) -> IRQ 16
Jan 26 21:28:59 rainbow kernel: [    0.286157] pci 0000:15:00.0:
setting latency timer to 64
Jan 26 21:28:59 rainbow kernel: [    0.286230] pci_bus 0000:00:
resource 0 io:  [0x00-0xffff]
Jan 26 21:28:59 rainbow kernel: [    0.286300] pci_bus 0000:00:
resource 1 mem: [0x000000-0xffffffffffffffff]
Jan 26 21:28:59 rainbow kernel: [    0.286367] pci_bus 0000:02:
resource 0 io:  [0x2000-0x2fff]
Jan 26 21:28:59 rainbow kernel: [    0.286435] pci_bus 0000:02:
resource 1 mem: [0xfc000000-0xfdffffff]
Jan 26 21:28:59 rainbow kernel: [    0.286503] pci_bus 0000:02:
resource 2 mem: [0xf8000000-0xf80fffff]
Jan 26 21:28:59 rainbow kernel: [    0.286572] pci_bus 0000:02:
resource 3 mem: [0x0-0x0]
Jan 26 21:28:59 rainbow kernel: [    0.286642] pci_bus 0000:03:
resource 0 io:  [0x3000-0x3fff]
Jan 26 21:28:59 rainbow kernel: [    0.286705] pci_bus 0000:03:
resource 1 mem: [0xdc000000-0xdf3fffff]
Jan 26 21:28:59 rainbow kernel: [    0.286776] pci_bus 0000:03:
resource 2 mem: [0xdfe00000-0xdfefffff]
Jan 26 21:28:59 rainbow kernel: [    0.286845] pci_bus 0000:03:
resource 3 mem: [0x0-0x0]
Jan 26 21:28:59 rainbow kernel: [    0.286908] pci_bus 0000:04:
resource 0 io:  [0x4000-0x4fff]
Jan 26 21:28:59 rainbow kernel: [    0.286974] pci_bus 0000:04:
resource 1 mem: [0xd8000000-0xd9ffffff]
Jan 26 21:28:59 rainbow kernel: [    0.287037] pci_bus 0000:04:
resource 2 mem: [0xdfb00000-0xdfbfffff]
Jan 26 21:28:59 rainbow kernel: [    0.287106] pci_bus 0000:04:
resource 3 mem: [0x0-0x0]
Jan 26 21:28:59 rainbow kernel: [    0.287177] pci_bus 0000:05:
resource 0 io:  [0x5000-0x5fff]
Jan 26 21:28:59 rainbow kernel: [    0.287242] pci_bus 0000:05:
resource 1 mem: [0xd4000000-0xd5ffffff]
Jan 26 21:28:59 rainbow kernel: [    0.287310] pci_bus 0000:05:
resource 2 mem: [0xdf800000-0xdf8fffff]
Jan 26 21:28:59 rainbow kernel: [    0.287382] pci_bus 0000:05:
resource 3 mem: [0x0-0x0]
Jan 26 21:28:59 rainbow kernel: [    0.287448] pci_bus 0000:0d:
resource 0 io:  [0x6000-0x6fff]
Jan 26 21:28:59 rainbow kernel: [    0.287512] pci_bus 0000:0d:
resource 1 mem: [0xd0000000-0xd1ffffff]
Jan 26 21:28:59 rainbow kernel: [    0.287583] pci_bus 0000:0d:
resource 2 mem: [0xdf500000-0xdf5fffff]
Jan 26 21:28:59 rainbow kernel: [    0.287654] pci_bus 0000:0d:
resource 3 mem: [0x0-0x0]
Jan 26 21:28:59 rainbow kernel: [    0.287720] pci_bus 0000:15:
resource 0 io:  [0x7000-0xafff]
Jan 26 21:28:59 rainbow kernel: [    0.287785] pci_bus 0000:15:
resource 1 mem: [0xf8300000-0xfbffffff]
Jan 26 21:28:59 rainbow kernel: [    0.287854] pci_bus 0000:15:
resource 2 mem: [0xf4000000-0xf7ffffff]
Jan 26 21:28:59 rainbow kernel: [    0.287921] pci_bus 0000:15:
resource 3 io:  [0x00-0xffff]
Jan 26 21:28:59 rainbow kernel: [    0.287988] pci_bus 0000:15:
resource 4 mem: [0x000000-0xffffffffffffffff]
Jan 26 21:28:59 rainbow kernel: [    0.288073] pci_bus 0000:16:
resource 0 io:  [0x7000-0x70ff]
Jan 26 21:28:59 rainbow kernel: [    0.288141] pci_bus 0000:16:
resource 1 io:  [0x7400-0x74ff]
Jan 26 21:28:59 rainbow kernel: [    0.288206] pci_bus 0000:16:
resource 2 mem: [0xf4000000-0xf7ffffff]
Jan 26 21:28:59 rainbow kernel: [    0.288274] pci_bus 0000:16:
resource 3 mem: [0xc4000000-0xc7ffffff]
Jan 26 21:28:59 rainbow kernel: [    0.288364] NET: Registered protocol family 2
Jan 26 21:28:59 rainbow kernel: [    0.336144] IP route cache hash
table entries: 131072 (order: 8, 1048576 bytes)
Jan 26 21:28:59 rainbow kernel: [    0.337368] TCP established hash
table entries: 524288 (order: 11, 8388608 bytes)
Jan 26 21:28:59 rainbow kernel: [    0.342041] TCP bind hash table
entries: 65536 (order: 8, 1048576 bytes)
Jan 26 21:28:59 rainbow kernel: [    0.342780] TCP: Hash tables
configured (established 524288 bind 65536)
Jan 26 21:28:59 rainbow kernel: [    0.342851] TCP reno registered
Jan 26 21:28:59 rainbow kernel: [    0.352118] NET: Registered protocol family 1
Jan 26 21:28:59 rainbow kernel: [    0.352294] checking if image is
initramfs... it is
Jan 26 21:28:59 rainbow kernel: [    2.396036] Freeing initrd memory:
22626k freed
Jan 26 21:28:59 rainbow kernel: [    2.409856] Simple Boot Flag at
0x35 set to 0x1
Jan 26 21:28:59 rainbow kernel: [    2.411044] audit: initializing
netlink socket (disabled)
Jan 26 21:28:59 rainbow kernel: [    2.411127] type=2000
audit(1233023321.408:1): initialized
Jan 26 21:28:59 rainbow kernel: [    2.417105] HugeTLB registered 2 MB
page size, pre-allocated 0 pages
Jan 26 21:28:59 rainbow kernel: [    2.420197] VFS: Disk quotas dquot_6.5.2
Jan 26 21:28:59 rainbow kernel: [    2.420345] Dquot-cache hash table
entries: 512 (order 0, 4096 bytes)
Jan 26 21:28:59 rainbow kernel: [    2.420603] msgmni has been set to 7709
Jan 26 21:28:59 rainbow kernel: [    2.420852] alg: No test for stdrng (krng)
Jan 26 21:28:59 rainbow kernel: [    2.420924] io scheduler noop registered
Jan 26 21:28:59 rainbow kernel: [    2.420990] io scheduler
anticipatory registered
Jan 26 21:28:59 rainbow kernel: [    2.421058] io scheduler deadline registered
Jan 26 21:28:59 rainbow kernel: [    2.421243] io scheduler cfq
registered (default)
Jan 26 21:28:59 rainbow kernel: [    2.421321] pci 0000:00:02.0: Boot
video device
Jan 26 21:28:59 rainbow kernel: [    2.421707] pcieport-driver
0000:00:1c.0: setting latency timer to 64
Jan 26 21:28:59 rainbow kernel: [    2.421913] pcieport-driver
0000:00:1c.0: irq 24 for MSI/MSI-X
Jan 26 21:28:59 rainbow kernel: [    2.422232] pcieport-driver
0000:00:1c.1: setting latency timer to 64
Jan 26 21:28:59 rainbow kernel: [    2.422421] pcieport-driver
0000:00:1c.1: irq 25 for MSI/MSI-X
Jan 26 21:28:59 rainbow kernel: [    2.422737] pcieport-driver
0000:00:1c.2: setting latency timer to 64
Jan 26 21:28:59 rainbow kernel: [    2.422938] pcieport-driver
0000:00:1c.2: irq 26 for MSI/MSI-X
Jan 26 21:28:59 rainbow kernel: [    2.423258] pcieport-driver
0000:00:1c.3: setting latency timer to 64
Jan 26 21:28:59 rainbow kernel: [    2.423459] pcieport-driver
0000:00:1c.3: irq 27 for MSI/MSI-X
Jan 26 21:28:59 rainbow kernel: [    2.423785] pcieport-driver
0000:00:1c.4: setting latency timer to 64
Jan 26 21:28:59 rainbow kernel: [    2.423983] pcieport-driver
0000:00:1c.4: irq 28 for MSI/MSI-X
Jan 26 21:28:59 rainbow kernel: [    2.458054] Linux agpgart interface v0.103
Jan 26 21:28:59 rainbow kernel: [    2.458121] Serial: 8250/16550
driver, 4 ports, IRQ sharing enabled
Jan 26 21:28:59 rainbow kernel: [    2.460715] brd: module loaded
Jan 26 21:28:59 rainbow kernel: [    2.460777] e1000e: Intel(R)
PRO/1000 Network Driver - 0.3.3.3-k6
Jan 26 21:28:59 rainbow kernel: [    2.460839] e1000e: Copyright (c)
1999-2008 Intel Corporation.
Jan 26 21:28:59 rainbow kernel: [    2.460960] e1000e 0000:00:19.0:
PCI INT A -> GSI 20 (level, low) -> IRQ 20
Jan 26 21:28:59 rainbow kernel: [    2.461050] e1000e 0000:00:19.0:
setting latency timer to 64
Jan 26 21:28:59 rainbow kernel: [    2.461310] e1000e 0000:00:19.0:
irq 29 for MSI/MSI-X
Jan 26 21:28:59 rainbow kernel: [    2.670497] 0000:00:19.0: eth0:
(PCI Express:2.5GB/s:Width x1) 00:1c:25:7e:69:03
Jan 26 21:28:59 rainbow kernel: [    2.670571] 0000:00:19.0: eth0:
Intel(R) PRO/1000 Network Connection
Jan 26 21:28:59 rainbow kernel: [    2.670672] 0000:00:19.0: eth0:
MAC: 5, PHY: 6, PBA No: 1008ff-0ff
Jan 26 21:28:59 rainbow kernel: [    2.670812] netconsole: local port 6665
Jan 26 21:28:59 rainbow kernel: [    2.670880] netconsole: local IP 169.254.1.1
Jan 26 21:28:59 rainbow kernel: [    2.670945] netconsole: interface eth0
Jan 26 21:28:59 rainbow kernel: [    2.671005] netconsole: remote port 6666
Jan 26 21:28:59 rainbow kernel: [    2.671064] netconsole: remote IP
169.254.242.220
Jan 26 21:28:59 rainbow kernel: [    2.671126] netconsole: remote
ethernet address ff:ff:ff:ff:ff:ff
Jan 26 21:28:59 rainbow kernel: [    2.671190] netconsole: device eth0
not up yet, forcing it
Jan 26 21:28:59 rainbow kernel: [    2.808232] e1000e 0000:00:19.0:
irq 29 for MSI/MSI-X
Jan 26 21:28:59 rainbow kernel: [    2.864107] e1000e 0000:00:19.0:
irq 29 for MSI/MSI-X
Jan 26 21:28:59 rainbow kernel: [    4.233915] e1000e: eth0 NIC Link
is Up 100 Mbps Half Duplex, Flow Control: None
Jan 26 21:28:59 rainbow kernel: [    4.234048] 0000:00:19.0: eth0:
10/100 speed: disabling TSO
Jan 26 21:28:59 rainbow kernel: [    4.244036] console [netcon0] enabled
Jan 26 21:28:59 rainbow kernel: [    4.278333] netconsole: network
logging started
Jan 26 21:28:59 rainbow kernel: [    4.278543] PNP: PS/2 Controller
[PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
Jan 26 21:28:59 rainbow kernel: [    4.288081] serio: i8042 KBD port
at 0x60,0x64 irq 1
Jan 26 21:28:59 rainbow kernel: [    4.288152] serio: i8042 AUX port
at 0x60,0x64 irq 12
Jan 26 21:28:59 rainbow kernel: [    4.288403] mice: PS/2 mouse device
common for all mice
Jan 26 21:28:59 rainbow kernel: [    4.288546] rtc_cmos 00:07: RTC can
wake from S4
Jan 26 21:28:59 rainbow kernel: [    4.288692] rtc_cmos 00:07: rtc
core: registered rtc_cmos as rtc0
Jan 26 21:28:59 rainbow kernel: [    4.288807] rtc0: alarms up to one
month, y3k, 114 bytes nvram, hpet irqs
Jan 26 21:28:59 rainbow kernel: [    4.288918] cpuidle: using governor ladder
Jan 26 21:28:59 rainbow kernel: [    4.288981] cpuidle: using governor menu
Jan 26 21:28:59 rainbow kernel: [    4.289340] TCP cubic registered
Jan 26 21:28:59 rainbow kernel: [    4.289654] registered taskstats version 1
Jan 26 21:28:59 rainbow kernel: [    4.289855]   Magic number: 9:133:461
Jan 26 21:28:59 rainbow kernel: [    4.290048] rtc_cmos 00:07: setting
system clock to 2009-01-27 02:28:44 UTC (1233023324)
Jan 26 21:28:59 rainbow kernel: [    4.290132] BIOS EDD facility v0.16
2004-Jun-25, 0 devices found
Jan 26 21:28:59 rainbow kernel: [    4.290198] EDD information not available.
Jan 26 21:28:59 rainbow kernel: [    4.290307] Freeing unused kernel
memory: 552k freed
Jan 26 21:28:59 rainbow kernel: [    4.290574] Write protecting the
kernel read-only data: 4544k
Jan 26 21:28:59 rainbow kernel: [    4.294300] input: AT Translated
Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
Jan 26 21:28:59 rainbow kernel: [    4.395765] fuse init (API version 7.11)
Jan 26 21:28:59 rainbow kernel: [    4.406361] ACPI: SSDT BF6E1B32,
02C4 (r1  PmRef  Cpu0Ist      100 INTL 20050513)
Jan 26 21:28:59 rainbow kernel: [    4.407176] ACPI: SSDT BF6E1E7B,
085E (r1  PmRef  Cpu0Cst      100 INTL 20050513)
Jan 26 21:28:59 rainbow kernel: [    4.410663] Monitor-Mwait will be
used to enter C-1 state
Jan 26 21:28:59 rainbow kernel: [    4.410735] Monitor-Mwait will be
used to enter C-2 state
Jan 26 21:28:59 rainbow kernel: [    4.410801] Monitor-Mwait will be
used to enter C-3 state
Jan 26 21:28:59 rainbow kernel: [    4.411128] ACPI: CPU0 (power
states: C1[C1] C2[C2] C3[C3])
Jan 26 21:28:59 rainbow kernel: [    4.411479] processor ACPI_CPU:00:
registered as cooling_device0
Jan 26 21:28:59 rainbow kernel: [    4.411546] ACPI: Processor [CPU0]
(supports 8 throttling states)
Jan 26 21:28:59 rainbow kernel: [    4.412073] ACPI: SSDT BF6E1A6A,
00C8 (r1  PmRef  Cpu1Ist      100 INTL 20050513)
Jan 26 21:28:59 rainbow kernel: [    4.412707] ACPI: SSDT BF6E1DF6,
0085 (r1  PmRef  Cpu1Cst      100 INTL 20050513)
Jan 26 21:28:59 rainbow kernel: [    4.414905] ACPI: CPU1 (power
states: C1[C1] C2[C2] C3[C3])
Jan 26 21:28:59 rainbow kernel: [    4.415196] processor ACPI_CPU:01:
registered as cooling_device1
Jan 26 21:28:59 rainbow kernel: [    4.415277] ACPI: Processor [CPU1]
(supports 8 throttling states)
Jan 26 21:28:59 rainbow kernel: [    4.419555] thermal LNXTHERM:01:
registered as thermal_zone0
Jan 26 21:28:59 rainbow kernel: [    4.422812] ACPI: Thermal Zone [THM0] (44 C)
Jan 26 21:28:59 rainbow kernel: [    4.423992] thermal LNXTHERM:02:
registered as thermal_zone1
Jan 26 21:28:59 rainbow kernel: [    4.425410] ACPI: Thermal Zone [THM1] (47 C)
Jan 26 21:28:59 rainbow kernel: [    4.573983] usbcore: registered new
interface driver usbfs
Jan 26 21:28:59 rainbow kernel: [    4.574084] usbcore: registered new
interface driver hub
Jan 26 21:28:59 rainbow kernel: [    4.574178] usbcore: registered new
device driver usb
Jan 26 21:28:59 rainbow kernel: [    4.576397] uhci_hcd: USB Universal
Host Controller Interface driver
Jan 26 21:28:59 rainbow kernel: [    4.576577] uhci_hcd 0000:00:1a.0:
PCI INT A -> GSI 20 (level, low) -> IRQ 20
Jan 26 21:28:59 rainbow kernel: [    4.576666] uhci_hcd 0000:00:1a.0:
setting latency timer to 64
Jan 26 21:28:59 rainbow kernel: [    4.576742] uhci_hcd 0000:00:1a.0:
UHCI Host Controller
Jan 26 21:28:59 rainbow kernel: [    4.576869] uhci_hcd 0000:00:1a.0:
new USB bus registered, assigned bus number 1
Jan 26 21:28:59 rainbow kernel: [    4.577023] uhci_hcd 0000:00:1a.0:
irq 20, io base 0x00001860
Jan 26 21:28:59 rainbow kernel: [    4.577293] usb usb1: configuration
#1 chosen from 1 choice
Jan 26 21:28:59 rainbow kernel: [    4.577396] hub 1-0:1.0: USB hub found
Jan 26 21:28:59 rainbow kernel: [    4.577468] hub 1-0:1.0: 2 ports detected
Jan 26 21:28:59 rainbow kernel: [    4.579189] ehci_hcd: USB 2.0
'Enhanced' Host Controller (EHCI) Driver
Jan 26 21:28:59 rainbow kernel: [    4.579282] Warning! ehci_hcd
should always be loaded before uhci_hcd and ohci_hcd, not after
Jan 26 21:28:59 rainbow kernel: [    4.579897] uhci_hcd 0000:00:1a.1:
power state changed by ACPI to D0
Jan 26 21:28:59 rainbow kernel: [    4.579958] uhci_hcd 0000:00:1a.1:
PCI INT B -> GSI 21 (level, low) -> IRQ 21
Jan 26 21:28:59 rainbow kernel: [    4.580069] uhci_hcd 0000:00:1a.1:
setting latency timer to 64
Jan 26 21:28:59 rainbow kernel: [    4.580144] uhci_hcd 0000:00:1a.1:
UHCI Host Controller
Jan 26 21:28:59 rainbow kernel: [    4.580236] uhci_hcd 0000:00:1a.1:
new USB bus registered, assigned bus number 2
Jan 26 21:28:59 rainbow kernel: [    4.580366] uhci_hcd 0000:00:1a.1:
irq 21, io base 0x00001880
Jan 26 21:28:59 rainbow kernel: [    4.580531] usb usb2: configuration
#1 chosen from 1 choice
Jan 26 21:28:59 rainbow kernel: [    4.580621] hub 2-0:1.0: USB hub found
Jan 26 21:28:59 rainbow kernel: [    4.580687] hub 2-0:1.0: 2 ports detected
Jan 26 21:28:59 rainbow kernel: [    4.581554] ehci_hcd 0000:00:1a.7:
power state changed by ACPI to D0
Jan 26 21:28:59 rainbow kernel: [    4.581624] ehci_hcd 0000:00:1a.7:
PCI INT C -> GSI 22 (level, low) -> IRQ 22
Jan 26 21:28:59 rainbow kernel: [    4.581772] ehci_hcd 0000:00:1a.7:
setting latency timer to 64
Jan 26 21:28:59 rainbow kernel: [    4.581841] ehci_hcd 0000:00:1a.7:
EHCI Host Controller
Jan 26 21:28:59 rainbow kernel: [    4.581934] ehci_hcd 0000:00:1a.7:
new USB bus registered, assigned bus number 3
Jan 26 21:28:59 rainbow kernel: [    4.585952] ehci_hcd 0000:00:1a.7:
cache line size of 32 is not supported
Jan 26 21:28:59 rainbow kernel: [    4.586038] ehci_hcd 0000:00:1a.7:
irq 22, io mem 0xfe226c00
Jan 26 21:28:59 rainbow kernel: [    4.604174] ehci_hcd 0000:00:1a.7:
USB 2.0 started, EHCI 1.00
Jan 26 21:28:59 rainbow kernel: [    4.604355] usb usb3: configuration
#1 chosen from 1 choice
Jan 26 21:28:59 rainbow kernel: [    4.604462] hub 3-0:1.0: USB hub found
Jan 26 21:28:59 rainbow kernel: [    4.604527] hub 3-0:1.0: 4 ports detected
Jan 26 21:28:59 rainbow kernel: [    4.605544] uhci_hcd 0000:00:1d.0:
power state changed by ACPI to D0
Jan 26 21:28:59 rainbow kernel: [    4.605605] uhci_hcd 0000:00:1d.0:
PCI INT A -> GSI 16 (level, low) -> IRQ 16
Jan 26 21:28:59 rainbow kernel: [    4.605682] uhci_hcd 0000:00:1d.0:
setting latency timer to 64
Jan 26 21:28:59 rainbow kernel: [    4.605753] uhci_hcd 0000:00:1d.0:
UHCI Host Controller
Jan 26 21:28:59 rainbow kernel: [    4.605850] uhci_hcd 0000:00:1d.0:
new USB bus registered, assigned bus number 4
Jan 26 21:28:59 rainbow kernel: [    4.605972] uhci_hcd 0000:00:1d.0:
irq 16, io base 0x000018a0
Jan 26 21:28:59 rainbow kernel: [    4.606119] usb usb4: configuration
#1 chosen from 1 choice
Jan 26 21:28:59 rainbow kernel: [    4.606211] hub 4-0:1.0: USB hub found
Jan 26 21:28:59 rainbow kernel: [    4.606285] hub 4-0:1.0: 2 ports detected
Jan 26 21:28:59 rainbow kernel: [    4.607274] ehci_hcd 0000:00:1d.7:
power state changed by ACPI to D0
Jan 26 21:28:59 rainbow kernel: [    4.607354] ehci_hcd 0000:00:1d.7:
PCI INT D -> GSI 19 (level, low) -> IRQ 19
Jan 26 21:28:59 rainbow kernel: [    4.607434] ehci_hcd 0000:00:1d.7:
setting latency timer to 64
Jan 26 21:28:59 rainbow kernel: [    4.607500] ehci_hcd 0000:00:1d.7:
EHCI Host Controller
Jan 26 21:28:59 rainbow kernel: [    4.607589] ehci_hcd 0000:00:1d.7:
new USB bus registered, assigned bus number 5
Jan 26 21:28:59 rainbow kernel: [    4.611615] ehci_hcd 0000:00:1d.7:
debug port 1
Jan 26 21:28:59 rainbow kernel: [    4.611687] ehci_hcd 0000:00:1d.7:
cache line size of 32 is not supported
Jan 26 21:28:59 rainbow kernel: [    4.611768] ehci_hcd 0000:00:1d.7:
irq 19, io mem 0xfe227000
Jan 26 21:28:59 rainbow kernel: [    4.628033] ehci_hcd 0000:00:1d.7:
USB 2.0 started, EHCI 1.00
Jan 26 21:28:59 rainbow kernel: [    4.628227] usb usb5: configuration
#1 chosen from 1 choice
Jan 26 21:28:59 rainbow kernel: [    4.628319] hub 5-0:1.0: USB hub found
Jan 26 21:28:59 rainbow kernel: [    4.628405] hub 5-0:1.0: 6 ports detected
Jan 26 21:28:59 rainbow kernel: [    4.628903] uhci_hcd 0000:00:1d.1:
PCI INT B -> GSI 17 (level, low) -> IRQ 17
Jan 26 21:28:59 rainbow kernel: [    4.628978] uhci_hcd 0000:00:1d.1:
setting latency timer to 64
Jan 26 21:28:59 rainbow kernel: [    4.629057] uhci_hcd 0000:00:1d.1:
UHCI Host Controller
Jan 26 21:28:59 rainbow kernel: [    4.629143] uhci_hcd 0000:00:1d.1:
new USB bus registered, assigned bus number 6
Jan 26 21:28:59 rainbow kernel: [    4.629263] uhci_hcd 0000:00:1d.1:
irq 17, io base 0x000018c0
Jan 26 21:28:59 rainbow kernel: [    4.629414] usb usb6: configuration
#1 chosen from 1 choice
Jan 26 21:28:59 rainbow kernel: [    4.629510] hub 6-0:1.0: USB hub found
Jan 26 21:28:59 rainbow kernel: [    4.629577] hub 6-0:1.0: 2 ports detected
Jan 26 21:28:59 rainbow kernel: [    4.630370] uhci_hcd 0000:00:1d.2:
power state changed by ACPI to D0
Jan 26 21:28:59 rainbow kernel: [    4.630453] uhci_hcd 0000:00:1d.2:
PCI INT C -> GSI 18 (level, low) -> IRQ 18
Jan 26 21:28:59 rainbow kernel: [    4.630527] uhci_hcd 0000:00:1d.2:
setting latency timer to 64
Jan 26 21:28:59 rainbow kernel: [    4.630598] uhci_hcd 0000:00:1d.2:
UHCI Host Controller
Jan 26 21:28:59 rainbow kernel: [    4.630685] uhci_hcd 0000:00:1d.2:
new USB bus registered, assigned bus number 7
Jan 26 21:28:59 rainbow kernel: [    4.630811] uhci_hcd 0000:00:1d.2:
irq 18, io base 0x000018e0
Jan 26 21:28:59 rainbow kernel: [    4.630972] usb usb7: configuration
#1 chosen from 1 choice
Jan 26 21:28:59 rainbow kernel: [    4.631060] hub 7-0:1.0: USB hub found
Jan 26 21:28:59 rainbow kernel: [    4.631130] hub 7-0:1.0: 2 ports detected
Jan 26 21:28:59 rainbow kernel: [    4.663646] SCSI subsystem initialized
Jan 26 21:28:59 rainbow kernel: [    4.668635] ohci1394 0000:15:00.1:
PCI INT B -> GSI 17 (level, low) -> IRQ 17
Jan 26 21:28:59 rainbow kernel: [    4.668723] ohci1394 0000:15:00.1:
setting latency timer to 64
Jan 26 21:28:59 rainbow kernel: [    4.683640] libata version 3.00 loaded.
Jan 26 21:28:59 rainbow kernel: [    4.730156] ohci1394: fw-host0:
OHCI-1394 1.1 (PCI): IRQ=[17]  MMIO=[f8301000-f83017ff]  Max
Packet=[2048]  IR/IT contexts=[4/4]
Jan 26 21:28:59 rainbow kernel: [    4.734553] pata_acpi 0000:00:1f.1:
PCI INT C -> GSI 16 (level, low) -> IRQ 16
Jan 26 21:28:59 rainbow kernel: [    4.734813] pata_acpi 0000:00:1f.1:
setting latency timer to 64
Jan 26 21:28:59 rainbow kernel: [    4.734906] pata_acpi 0000:00:1f.1:
PCI INT C disabled
Jan 26 21:28:59 rainbow kernel: [    4.735358] ahci 0000:00:1f.2: version 3.0
Jan 26 21:28:59 rainbow kernel: [    4.735454] ahci 0000:00:1f.2: PCI
INT B -> GSI 16 (level, low) -> IRQ 16
Jan 26 21:28:59 rainbow kernel: [    4.735642] ahci 0000:00:1f.2: irq
30 for MSI/MSI-X
Jan 26 21:28:59 rainbow kernel: [    4.735787] ahci 0000:00:1f.2: AHCI
0001.0100 32 slots 3 ports 1.5 Gbps 0x1 impl SATA mode
Jan 26 21:28:59 rainbow kernel: [    4.735854] ahci 0000:00:1f.2:
flags: 64bit ncq sntf pm led clo pio slum part
Jan 26 21:28:59 rainbow kernel: [    4.735933] ahci 0000:00:1f.2:
setting latency timer to 64
Jan 26 21:28:59 rainbow kernel: [    4.736898] scsi0 : ahci
Jan 26 21:28:59 rainbow kernel: [    4.737089] scsi1 : ahci
Jan 26 21:28:59 rainbow kernel: [    4.737240] scsi2 : ahci
Jan 26 21:28:59 rainbow kernel: [    4.737389] ata1: SATA max UDMA/133
abar m2048@0xfe226000 port 0xfe226100 irq 30
Jan 26 21:28:59 rainbow kernel: [    4.737454] ata2: DUMMY
Jan 26 21:28:59 rainbow kernel: [    4.737501] ata3: DUMMY
Jan 26 21:28:59 rainbow kernel: [    5.057111] ata1: SATA link up 1.5
Gbps (SStatus 113 SControl 300)
Jan 26 21:28:59 rainbow kernel: [    5.057945] ata1.00: ACPI cmd
ef/02:00:00:00:00:a0 succeeded
Jan 26 21:28:59 rainbow kernel: [    5.058030] ata1.00: ACPI cmd
f5/00:00:00:00:00:a0 filtered out
Jan 26 21:28:59 rainbow kernel: [    5.058155] ata1.00: ACPI cmd
ef/5f:00:00:00:00:a0 succeeded
Jan 26 21:28:59 rainbow kernel: [    5.058217] ata1.00: ACPI cmd
ef/10:03:00:00:00:a0 filtered out
Jan 26 21:28:59 rainbow kernel: [    5.104308] ata1.00: ATA-8: WDC
WD1200BEVS-08UST0, 02.01A02, max UDMA/133
Jan 26 21:28:59 rainbow kernel: [    5.104385] ata1.00: 234441648
sectors, multi 16: LBA48 NCQ (depth 31/32)
Jan 26 21:28:59 rainbow kernel: [    5.105506] ata1.00: ACPI cmd
ef/02:00:00:00:00:a0 succeeded
Jan 26 21:28:59 rainbow kernel: [    5.105597] ata1.00: ACPI cmd
f5/00:00:00:00:00:a0 filtered out
Jan 26 21:28:59 rainbow kernel: [    5.105775] ata1.00: ACPI cmd
ef/5f:00:00:00:00:a0 succeeded
Jan 26 21:28:59 rainbow kernel: [    5.105850] ata1.00: ACPI cmd
ef/10:03:00:00:00:a0 filtered out
Jan 26 21:28:59 rainbow kernel: [    5.106621] ata1.00: configured for UDMA/133
Jan 26 21:28:59 rainbow kernel: [    5.122803] ata1.00: configured for UDMA/133
Jan 26 21:28:59 rainbow kernel: [    5.122859] ata1: EH complete
Jan 26 21:28:59 rainbow kernel: [    5.123007] scsi 0:0:0:0:
Direct-Access     ATA      WDC WD1200BEVS-0 02.0 PQ: 0 ANSI: 5
Jan 26 21:28:59 rainbow kernel: [    5.126634] ata_piix 0000:00:1f.1:
version 2.12
Jan 26 21:28:59 rainbow kernel: [    5.126729] ata_piix 0000:00:1f.1:
PCI INT C -> GSI 16 (level, low) -> IRQ 16
Jan 26 21:28:59 rainbow kernel: [    5.126854] ata_piix 0000:00:1f.1:
setting latency timer to 64
Jan 26 21:28:59 rainbow kernel: [    5.128200] scsi3 : ata_piix
Jan 26 21:28:59 rainbow kernel: [    5.130742] scsi4 : ata_piix
Jan 26 21:28:59 rainbow kernel: [    5.130890] scsi 0:0:0:0: Attached
scsi generic sg0 type 0
Jan 26 21:28:59 rainbow kernel: [    5.131894] ata4: PATA max UDMA/100
cmd 0x1f0 ctl 0x3f6 bmdma 0x1c00 irq 14
Jan 26 21:28:59 rainbow kernel: [    5.131953] ata5: PATA max UDMA/100
cmd 0x170 ctl 0x376 bmdma 0x1c08 irq 15
Jan 26 21:28:59 rainbow kernel: [    5.141869] Driver 'sd' needs
updating - please use bus_type methods
Jan 26 21:28:59 rainbow kernel: [    5.142030] sd 0:0:0:0: [sda]
234441648 512-byte hardware sectors: (120 GB/111 GiB)
Jan 26 21:28:59 rainbow kernel: [    5.142121] sd 0:0:0:0: [sda] Write
Protect is off
Jan 26 21:28:59 rainbow kernel: [    5.142182] sd 0:0:0:0: [sda] Mode
Sense: 00 3a 00 00
Jan 26 21:28:59 rainbow kernel: [    5.142260] sd 0:0:0:0: [sda] Write
cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jan 26 21:28:59 rainbow kernel: [    5.142418] sd 0:0:0:0: [sda]
234441648 512-byte hardware sectors: (120 GB/111 GiB)
Jan 26 21:28:59 rainbow kernel: [    5.143144] sd 0:0:0:0: [sda] Write
Protect is off
Jan 26 21:28:59 rainbow kernel: [    5.143209] sd 0:0:0:0: [sda] Mode
Sense: 00 3a 00 00
Jan 26 21:28:59 rainbow kernel: [    5.143301] sd 0:0:0:0: [sda] Write
cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jan 26 21:28:59 rainbow kernel: [    5.143376]  sda: sda1 sda2 < sda5 >
Jan 26 21:28:59 rainbow kernel: [    5.183646] sd 0:0:0:0: [sda]
Attached SCSI disk
Jan 26 21:28:59 rainbow kernel: [    5.293671] ata4.00: ATAPI:
MATSHITADVD-RAM UJ-862, RB01, max UDMA/33
Jan 26 21:28:59 rainbow kernel: [    5.309338] ata4.00: configured for UDMA/33
Jan 26 21:28:59 rainbow kernel: [    5.312074] scsi 3:0:0:0: CD-ROM
        MATSHITA DVD-RAM UJ-862   RB01 PQ: 0 ANSI: 5
Jan 26 21:28:59 rainbow kernel: [    5.312752] scsi 3:0:0:0: Attached
scsi generic sg1 type 5
Jan 26 21:28:59 rainbow kernel: [    5.312908] ata5: port disabled. ignoring.
Jan 26 21:28:59 rainbow kernel: [    5.327036] Driver 'sr' needs
updating - please use bus_type methods
Jan 26 21:28:59 rainbow kernel: [    5.331858] sr0: scsi3-mmc drive:
24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Jan 26 21:28:59 rainbow kernel: [    5.331943] Uniform CD-ROM driver
Revision: 3.20
Jan 26 21:28:59 rainbow kernel: [    5.332105] sr 3:0:0:0: Attached
scsi CD-ROM sr0
Jan 26 21:28:59 rainbow kernel: [    5.412506] PM: Starting manual
resume from disk
Jan 26 21:28:59 rainbow kernel: [    5.412574] PM: Resume from partition 8:5
Jan 26 21:28:59 rainbow kernel: [    5.412639] PM: Checking hibernation image.
Jan 26 21:28:59 rainbow kernel: [    5.412867] PM: Resume from disk failed.
Jan 26 21:28:59 rainbow kernel: [    5.476024] kjournald starting.
Commit interval 5 seconds
Jan 26 21:28:59 rainbow kernel: [    5.476110] EXT3-fs: mounted
filesystem with ordered data mode.
Jan 26 21:28:59 rainbow kernel: [    5.504035] Clocksource tsc
unstable (delta = -229087461 ns)
Jan 26 21:28:59 rainbow kernel: [    6.004188] ieee1394: Host added:
ID:BUS[0-00:1023]  GUID[00016c00005ec9db]
Jan 26 21:28:59 rainbow kernel: [   12.343428] udevd version 124 started
Jan 26 21:28:59 rainbow kernel: [   12.588326] input: Power Button
(FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
Jan 26 21:28:59 rainbow kernel: [   12.601052] ACPI: Power Button (FF) [PWRF]
Jan 26 21:28:59 rainbow kernel: [   12.601203] input: Lid Switch as
/devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input2
Jan 26 21:28:59 rainbow kernel: [   12.601778] ACPI: Lid Switch [LID]
Jan 26 21:28:59 rainbow kernel: [   12.601885] input: Sleep Button
(CM) as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input3
Jan 26 21:28:59 rainbow kernel: [   12.617056] ACPI: Sleep Button (CM) [SLPB]
Jan 26 21:28:59 rainbow kernel: [   12.671621] pci_hotplug: PCI Hot
Plug PCI Core version: 0.5
Jan 26 21:28:59 rainbow kernel: [   12.745173] shpchp: Standard Hot
Plug PCI Controller Driver version: 0.4
Jan 26 21:28:59 rainbow kernel: [   12.772093] ACPI: WMI: Mapper loaded
Jan 26 21:28:59 rainbow kernel: [   12.955957] ACPI: AC Adapter [AC] (on-line)
Jan 26 21:28:59 rainbow kernel: [   13.034511] ACPI: Battery Slot
[BAT0] (battery present)
Jan 26 21:28:59 rainbow kernel: [   13.037841] acpi device:03:
registered as cooling_device2
Jan 26 21:28:59 rainbow kernel: [   13.038130] input: Video Bus as
/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:02/input/input4
Jan 26 21:28:59 rainbow kernel: [   13.053070] ACPI: Video Device
[VID] (multi-head: yes  rom: no  post: no)
Jan 26 21:28:59 rainbow kernel: [   13.103969] iTCO_vendor_support:
vendor-support=0
Jan 26 21:28:59 rainbow kernel: [   13.119392] iTCO_wdt: Intel TCO
WatchDog Timer Driver v1.04
Jan 26 21:28:59 rainbow kernel: [   13.119611] iTCO_wdt: Found a
ICH8M-E TCO device (Version=2, TCOBASE=0x1060)
Jan 26 21:28:59 rainbow kernel: [   13.119807] iTCO_wdt: initialized.
heartbeat=30 sec (nowayout=0)
Jan 26 21:28:59 rainbow kernel: [   13.168548] Non-volatile memory driver v1.3
Jan 26 21:28:59 rainbow kernel: [   13.247839] input: PC Speaker as
/devices/platform/pcspkr/input/input5
Jan 26 21:28:59 rainbow kernel: [   13.317811] yenta_cardbus
0000:15:00.0: CardBus bridge found [17aa:20c6]
Jan 26 21:28:59 rainbow kernel: [   13.445272] yenta_cardbus
0000:15:00.0: ISA IRQ mask 0x0cb8, PCI irq 16
Jan 26 21:28:59 rainbow kernel: [   13.445350] yenta_cardbus
0000:15:00.0: Socket status: 30000006
Jan 26 21:28:59 rainbow kernel: [   13.445421] yenta_cardbus
0000:15:00.0: pcmcia: parent PCI bridge I/O window: 0x7000 - 0xafff
Jan 26 21:28:59 rainbow kernel: [   13.445497] yenta_cardbus
0000:15:00.0: pcmcia: parent PCI bridge Memory window: 0xf8300000 -
0xfbffffff
Jan 26 21:28:59 rainbow kernel: [   13.445580] yenta_cardbus
0000:15:00.0: pcmcia: parent PCI bridge Memory window: 0xf4000000 -
0xf7ffffff
Jan 26 21:28:59 rainbow kernel: [   13.573128] cfg80211: Using static
regulatory domain info
Jan 26 21:28:59 rainbow kernel: [   13.573200] cfg80211: Regulatory domain: US
Jan 26 21:28:59 rainbow kernel: [   13.573262] ^I(start_freq -
end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Jan 26 21:28:59 rainbow kernel: [   13.573333] ^I(2402000 KHz -
2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
Jan 26 21:28:59 rainbow kernel: [   13.573399] ^I(5170000 KHz -
5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
Jan 26 21:28:59 rainbow kernel: [   13.573460] ^I(5190000 KHz -
5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
Jan 26 21:28:59 rainbow kernel: [   13.573531] ^I(5210000 KHz -
5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
Jan 26 21:28:59 rainbow kernel: [   13.573598] ^I(5230000 KHz -
5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
Jan 26 21:28:59 rainbow kernel: [   13.573675] ^I(5735000 KHz -
5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
Jan 26 21:28:59 rainbow kernel: [   13.573742] cfg80211: Calling CRDA
for country: US
Jan 26 21:28:59 rainbow kernel: [   13.584871] agpgart-intel
0000:00:00.0: Intel 965GM Chipset
Jan 26 21:28:59 rainbow kernel: [   13.585919] agpgart-intel
0000:00:00.0: detected 7676K stolen memory
Jan 26 21:28:59 rainbow kernel: [   13.589555] agpgart-intel
0000:00:00.0: AGP aperture is 256M @ 0xe0000000
Jan 26 21:28:59 rainbow kernel: [   13.635323] thinkpad_acpi: ThinkPad
ACPI Extras v0.22
Jan 26 21:28:59 rainbow kernel: [   13.635401] thinkpad_acpi:
http://ibm-acpi.sf.net/
Jan 26 21:28:59 rainbow kernel: [   13.635463] thinkpad_acpi: ThinkPad
BIOS 7LETB2WW (2.12 ), EC 7KHT24WW-1.08
Jan 26 21:28:59 rainbow kernel: [   13.635530] thinkpad_acpi: Lenovo
ThinkPad T61, model 7658CTO
Jan 26 21:28:59 rainbow kernel: [   13.637251] thinkpad_acpi: ACPI
backlight control delay disabled
Jan 26 21:28:59 rainbow kernel: [   13.638166] thinkpad_acpi: radio
switch found; radios are enabled
Jan 26 21:28:59 rainbow kernel: [   13.638338] thinkpad_acpi: This
ThinkPad has standard ACPI backlight brightness control, supported by
the ACPI video driver
Jan 26 21:28:59 rainbow kernel: [   13.638425] thinkpad_acpi:
Disabling thinkpad-acpi brightness events by default...
Jan 26 21:28:59 rainbow kernel: [   13.644881] Registered led device:
tpacpi::thinklight
Jan 26 21:28:59 rainbow kernel: [   13.644979] Registered led device:
tpacpi::power
Jan 26 21:28:59 rainbow kernel: [   13.645099] Registered led device:
tpacpi:orange:batt
Jan 26 21:28:59 rainbow kernel: [   13.645202] Registered led device:
tpacpi:green:batt
Jan 26 21:28:59 rainbow kernel: [   13.645293] Registered led device:
tpacpi::dock_active
Jan 26 21:28:59 rainbow kernel: [   13.645386] Registered led device:
tpacpi::bay_active
Jan 26 21:28:59 rainbow kernel: [   13.645477] Registered led device:
tpacpi::dock_batt
Jan 26 21:28:59 rainbow kernel: [   13.645574] Registered led device:
tpacpi::unknown_led
Jan 26 21:28:59 rainbow kernel: [   13.645665] Registered led device:
tpacpi::standby
Jan 26 21:28:59 rainbow kernel: [   13.648388] thinkpad_acpi: Standard
ACPI backlight interface available, not loading native one.
Jan 26 21:28:59 rainbow kernel: [   13.648744] input: ThinkPad Extra
Buttons as /devices/virtual/input/input6
Jan 26 21:28:59 rainbow kernel: [   13.727316] Synaptics Touchpad,
model: 1, fw: 6.2, id: 0x81a0b1, caps: 0xa04791/0x300000
Jan 26 21:28:59 rainbow kernel: [   13.727407] serio: Synaptics
pass-through port at isa0060/serio1/input0
Jan 26 21:28:59 rainbow kernel: [   13.749399] lib80211: common
routines for IEEE802.11 drivers
Jan 26 21:28:59 rainbow kernel: [   13.749482] lib80211_crypt:
registered algorithm 'NULL'
Jan 26 21:28:59 rainbow kernel: [   13.770896] input: SynPS/2
Synaptics TouchPad as /devices/platform/i8042/serio1/input/input7
Jan 26 21:28:59 rainbow kernel: [   14.794557] HDA Intel 0000:00:1b.0:
PCI INT B -> GSI 17 (level, low) -> IRQ 17
Jan 26 21:28:59 rainbow kernel: [   14.794657] hda_intel: probe_mask
set to 0x1 for device 17aa:20ac
Jan 26 21:28:59 rainbow kernel: [   14.794917] HDA Intel 0000:00:1b.0:
setting latency timer to 64
Jan 26 21:28:59 rainbow kernel: [   14.999625] iwl3945: Intel(R)
PRO/Wireless 3945ABG/BG Network Connection driver for Linux, 1.2.26kds
Jan 26 21:28:59 rainbow kernel: [   14.999730] iwl3945: Copyright(c)
2003-2009 Intel Corporation
Jan 26 21:28:59 rainbow kernel: [   15.408396] iwl3945 0000:03:00.0:
PCI INT A -> GSI 17 (level, low) -> IRQ 17
Jan 26 21:28:59 rainbow kernel: [   15.408471] iwl3945 0000:03:00.0:
setting latency timer to 64
Jan 26 21:28:59 rainbow kernel: [   15.408613] ieee80211 phy0: U
iwl3945_pci_probe pci_resource_len = 0x00001000
Jan 26 21:28:59 rainbow kernel: [   15.408681] ieee80211 phy0: U
iwl3945_pci_probe pci_resource_base = ffffc200050b2000
Jan 26 21:28:59 rainbow kernel: [   15.408813] ieee80211 phy0: U
iwl3945_power_init_handle Initialize power
Jan 26 21:28:59 rainbow kernel: [   15.408873] ieee80211 phy0: U
iwl3945_power_init_handle adjust power command flags
Jan 26 21:28:59 rainbow kernel: [   15.467678] ieee80211 phy0: U
iwl3945_pci_probe MAC address: 00:1f:3c:20:a1:6e
Jan 26 21:28:59 rainbow kernel: [   15.467747] ieee80211 phy0: U
iwl3945_init_channel_map Initializing regulatory info from EEPROM
Jan 26 21:28:59 rainbow kernel: [   15.467812] ieee80211 phy0: U
iwl3945_init_channel_map Parsing data for 56 channels.
Jan 26 21:28:59 rainbow kernel: [   15.469242] ieee80211 phy0: U
iwl3945_init_channel_map Ch. 1 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b
15dBm): Ad-Hoc supported
Jan 26 21:28:59 rainbow kernel: [   15.469316] ieee80211 phy0: U
iwl3945_init_channel_map Ch. 2 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b
15dBm): Ad-Hoc supported
Jan 26 21:28:59 rainbow kernel: [   15.469386] ieee80211 phy0: U
iwl3945_init_channel_map Ch. 3 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b
15dBm): Ad-Hoc supported
Jan 26 21:28:59 rainbow kernel: [   15.469455] ieee80211 phy0: U
iwl3945_init_channel_map Ch. 4 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b
15dBm): Ad-Hoc supported
Jan 26 21:28:59 rainbow kernel: [   15.469524] ieee80211 phy0: U
iwl3945_init_channel_map Ch. 5 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b
15dBm): Ad-Hoc supported
Jan 26 21:28:59 rainbow kernel: [   15.469601] ieee80211 phy0: U
iwl3945_init_channel_map Ch. 6 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b
15dBm): Ad-Hoc supported
Jan 26 21:28:59 rainbow kernel: [   15.469671] ieee80211 phy0: U
iwl3945_init_channel_map Ch. 7 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b
15dBm): Ad-Hoc supported
Jan 26 21:28:59 rainbow kernel: [   15.469742] ieee80211 phy0: U
iwl3945_init_channel_map Ch. 8 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b
15dBm): Ad-Hoc supported
Jan 26 21:28:59 rainbow kernel: [   15.469814] ieee80211 phy0: U
iwl3945_init_channel_map Ch. 9 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b
15dBm): Ad-Hoc supported
Jan 26 21:28:59 rainbow kernel: [   15.469885] ieee80211 phy0: U
iwl3945_init_channel_map Ch. 10 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b
15dBm): Ad-Hoc supported
Jan 26 21:28:59 rainbow kernel: [   15.469956] ieee80211 phy0: U
iwl3945_init_channel_map Ch. 11 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b
14dBm): Ad-Hoc supported
Jan 26 21:28:59 rainbow kernel: [   15.470026] ieee80211 phy0: U
iwl3945_init_channel_map Ch. 12 Flags 0 [2.4GHz] - No traffic
Jan 26 21:28:59 rainbow kernel: [   15.470099] ieee80211 phy0: U
iwl3945_init_channel_map Ch. 13 Flags 0 [2.4GHz] - No traffic
Jan 26 21:28:59 rainbow kernel: [   15.470166] ieee80211 phy0: U
iwl3945_init_channel_map Ch. 14 Flags 0 [2.4GHz] - No traffic
Jan 26 21:28:59 rainbow kernel: [   15.470234] ieee80211 phy0: U
iwl3945_init_channel_map Ch. 183 Flags 0 [5.2GHz] - No traffic
Jan 26 21:28:59 rainbow kernel: [   15.470302] ieee80211 phy0: U
iwl3945_init_channel_map Ch. 184 Flags 0 [5.2GHz] - No traffic
Jan 26 21:28:59 rainbow kernel: [   15.470369] ieee80211 phy0: U
iwl3945_init_channel_map Ch. 185 Flags 0 [5.2GHz] - No traffic
Jan 26 21:28:59 rainbow kernel: [   15.470438] ieee80211 phy0: U
iwl3945_init_channel_map Ch. 187 Flags 0 [5.2GHz] - No traffic
Jan 26 21:28:59 rainbow kernel: [   15.470503] ieee80211 phy0: U
iwl3945_init_channel_map Ch. 188 Flags 0 [5.2GHz] - No traffic
Jan 26 21:28:59 rainbow kernel: [   15.470578] ieee80211 phy0: U
iwl3945_init_channel_map Ch. 189 Flags 0 [5.2GHz] - No traffic
Jan 26 21:28:59 rainbow kernel: [   15.470645] ieee80211 phy0: U
iwl3945_init_channel_map Ch. 192 Flags 0 [5.2GHz] - No traffic
Jan 26 21:28:59 rainbow kernel: [   15.470711] ieee80211 phy0: U
iwl3945_init_channel_map Ch. 196 Flags 0 [5.2GHz] - No traffic
Jan 26 21:28:59 rainbow kernel: [   15.470777] ieee80211 phy0: U
iwl3945_init_channel_map Ch. 7 Flags 0 [5.2GHz] - No traffic
Jan 26 21:28:59 rainbow kernel: [   15.470844] ieee80211 phy0: U
iwl3945_init_channel_map Ch. 8 Flags 0 [5.2GHz] - No traffic
Jan 26 21:28:59 rainbow kernel: [   15.471546] ieee80211 phy0: U
iwl3945_init_channel_map Ch. 11 Flags 0 [5.2GHz] - No traffic
Jan 26 21:28:59 rainbow kernel: [   15.471612] ieee80211 phy0: U
iwl3945_init_channel_map Ch. 12 Flags 0 [5.2GHz] - No traffic
Jan 26 21:28:59 rainbow kernel: [   15.471683] ieee80211 phy0: U
iwl3945_init_channel_map Ch. 16 Flags 0 [5.2GHz] - No traffic
Jan 26 21:28:59 rainbow kernel: [   15.471750] ieee80211 phy0: U
iwl3945_init_channel_map Ch. 34 Flags 0 [5.2GHz] - No traffic
Jan 26 21:28:59 rainbow kernel: [   15.471822] ieee80211 phy0: U
iwl3945_init_channel_map Ch. 36 [5.2GHz] VALID WIDE DFS (0xa1 14dBm):
Ad-Hoc not supported
Jan 26 21:28:59 rainbow kernel: [   15.471894] ieee80211 phy0: U
iwl3945_init_channel_map Ch. 38 Flags 0 [5.2GHz] - No traffic
Jan 26 21:28:59 rainbow kernel: [   15.471961] ieee80211 phy0: U
iwl3945_init_channel_map Ch. 40 [5.2GHz] VALID WIDE DFS (0xa1 14dBm):
Ad-Hoc not supported
Jan 26 21:28:59 rainbow kernel: [   15.472076] ieee80211 phy0: U
iwl3945_init_channel_map Ch. 42 Flags 0 [5.2GHz] - No traffic
Jan 26 21:28:59 rainbow kernel: [   15.472147] ieee80211 phy0: U
iwl3945_init_channel_map Ch. 44 [5.2GHz] VALID WIDE DFS (0xa1 14dBm):
Ad-Hoc not supported
Jan 26 21:28:59 rainbow kernel: [   15.472215] ieee80211 phy0: U
iwl3945_init_channel_map Ch. 46 Flags 0 [5.2GHz] - No traffic
Jan 26 21:28:59 rainbow kernel: [   15.472280] ieee80211 phy0: U
iwl3945_init_channel_map Ch. 48 [5.2GHz] VALID WIDE DFS (0xa1 14dBm):
Ad-Hoc not supported
Jan 26 21:28:59 rainbow kernel: [   15.472348] ieee80211 phy0: U
iwl3945_init_channel_map Ch. 52 [5.2GHz] VALID RADAR WIDE DFS (0xb1
14dBm): Ad-Hoc not supported
Jan 26 21:28:59 rainbow kernel: [   15.472422] ieee80211 phy0: U
iwl3945_init_channel_map Ch. 56 [5.2GHz] VALID RADAR WIDE DFS (0xb1
14dBm): Ad-Hoc not supported
Jan 26 21:28:59 rainbow kernel: [   15.472491] ieee80211 phy0: U
iwl3945_init_channel_map Ch. 60 [5.2GHz] VALID RADAR WIDE DFS (0xb1
14dBm): Ad-Hoc not supported
Jan 26 21:28:59 rainbow kernel: [   15.472560] ieee80211 phy0: U
iwl3945_init_channel_map Ch. 64 [5.2GHz] VALID RADAR WIDE DFS (0xb1
14dBm): Ad-Hoc not supported
Jan 26 21:28:59 rainbow kernel: [   15.472636] ieee80211 phy0: U
iwl3945_init_channel_map Ch. 100 Flags 0 [5.2GHz] - No traffic
Jan 26 21:28:59 rainbow kernel: [   15.472708] ieee80211 phy0: U
iwl3945_init_channel_map Ch. 104 Flags 0 [5.2GHz] - No traffic
Jan 26 21:28:59 rainbow kernel: [   15.472773] ieee80211 phy0: U
iwl3945_init_channel_map Ch. 108 Flags 0 [5.2GHz] - No traffic
Jan 26 21:28:59 rainbow kernel: [   15.472838] ieee80211 phy0: U
iwl3945_init_channel_map Ch. 112 Flags 0 [5.2GHz] - No traffic
Jan 26 21:28:59 rainbow kernel: [   15.472912] ieee80211 phy0: U
iwl3945_init_channel_map Ch. 116 Flags 0 [5.2GHz] - No traffic
Jan 26 21:28:59 rainbow kernel: [   15.472977] ieee80211 phy0: U
iwl3945_init_channel_map Ch. 120 Flags 0 [5.2GHz] - No traffic
Jan 26 21:28:59 rainbow kernel: [   15.473066] ieee80211 phy0: U
iwl3945_init_channel_map Ch. 124 Flags 0 [5.2GHz] - No traffic
Jan 26 21:28:59 rainbow kernel: [   15.473135] ieee80211 phy0: U
iwl3945_init_channel_map Ch. 128 Flags 0 [5.2GHz] - No traffic
Jan 26 21:28:59 rainbow kernel: [   15.473200] ieee80211 phy0: U
iwl3945_init_channel_map Ch. 132 Flags 0 [5.2GHz] - No traffic
Jan 26 21:28:59 rainbow kernel: [   15.473270] ieee80211 phy0: U
iwl3945_init_channel_map Ch. 136 Flags 0 [5.2GHz] - No traffic
Jan 26 21:28:59 rainbow kernel: [   15.473334] ieee80211 phy0: U
iwl3945_init_channel_map Ch. 140 Flags 0 [5.2GHz] - No traffic
Jan 26 21:28:59 rainbow kernel: [   15.473419] ieee80211 phy0: U
iwl3945_init_channel_map Ch. 145 Flags 0 [5.2GHz] - No traffic
Jan 26 21:28:59 rainbow kernel: [   15.473485] ieee80211 phy0: U
iwl3945_init_channel_map Ch. 149 [5.2GHz] VALID WIDE (0x21 16dBm):
Ad-Hoc not supported
Jan 26 21:28:59 rainbow kernel: [   15.473552] ieee80211 phy0: U
iwl3945_init_channel_map Ch. 153 [5.2GHz] VALID WIDE (0x21 16dBm):
Ad-Hoc not supported
Jan 26 21:28:59 rainbow kernel: [   15.473626] ieee80211 phy0: U
iwl3945_init_channel_map Ch. 157 [5.2GHz] VALID WIDE (0x21 16dBm):
Ad-Hoc not supported
Jan 26 21:28:59 rainbow kernel: [   15.473697] ieee80211 phy0: U
iwl3945_init_channel_map Ch. 161 [5.2GHz] VALID WIDE (0x21 16dBm):
Ad-Hoc not supported
Jan 26 21:28:59 rainbow kernel: [   15.473765] ieee80211 phy0: U
iwl3945_init_channel_map Ch. 165 [5.2GHz] VALID WIDE (0x21 16dBm):
Ad-Hoc not supported
Jan 26 21:28:59 rainbow kernel: [   15.473840] ieee80211 phy0: U
iwl3945_hw_reg_txpower_get_temperature Temperature: 260
Jan 26 21:28:59 rainbow kernel: [   15.473916] ieee80211 phy0: U
iwl3945_hw_reg_init_channel_groups Initializing factory calib info
from EEPROM
Jan 26 21:28:59 rainbow kernel: [   15.473988] ieee80211 phy0: U
iwl3945_hw_reg_get_ch_grp_index Chnl 1 mapped to grp 0
Jan 26 21:28:59 rainbow kernel: [   15.474052] ieee80211 phy0: U
iwl3945_txpower_set_from_eeprom Delta index for channel 1: -21 [260]
Jan 26 21:28:59 rainbow kernel: [   15.474123] ieee80211 phy0: U
iwl3945_hw_reg_get_ch_grp_index Chnl 2 mapped to grp 0
Jan 26 21:28:59 rainbow kernel: [   15.474191] ieee80211 phy0: U
iwl3945_txpower_set_from_eeprom Delta index for channel 2: -21 [260]
Jan 26 21:28:59 rainbow kernel: [   15.474257] ieee80211 phy0: U
iwl3945_hw_reg_get_ch_grp_index Chnl 3 mapped to grp 0
Jan 26 21:28:59 rainbow kernel: [   15.474320] ieee80211 phy0: U
iwl3945_txpower_set_from_eeprom Delta index for channel 3: -21 [260]
Jan 26 21:28:59 rainbow kernel: [   15.474391] ieee80211 phy0: U
iwl3945_hw_reg_get_ch_grp_index Chnl 4 mapped to grp 0
Jan 26 21:28:59 rainbow kernel: [   15.474468] ieee80211 phy0: U
iwl3945_txpower_set_from_eeprom Delta index for channel 4: -21 [260]
Jan 26 21:28:59 rainbow kernel: [   15.474534] ieee80211 phy0: U
iwl3945_hw_reg_get_ch_grp_index Chnl 5 mapped to grp 0
Jan 26 21:28:59 rainbow kernel: [   15.474598] ieee80211 phy0: U
iwl3945_txpower_set_from_eeprom Delta index for channel 5: -21 [260]
Jan 26 21:28:59 rainbow kernel: [   15.474669] ieee80211 phy0: U
iwl3945_hw_reg_get_ch_grp_index Chnl 6 mapped to grp 0
Jan 26 21:28:59 rainbow kernel: [   15.474737] ieee80211 phy0: U
iwl3945_txpower_set_from_eeprom Delta index for channel 6: -21 [260]
Jan 26 21:28:59 rainbow kernel: [   15.474802] ieee80211 phy0: U
iwl3945_hw_reg_get_ch_grp_index Chnl 7 mapped to grp 0
Jan 26 21:28:59 rainbow kernel: [   15.474866] ieee80211 phy0: U
iwl3945_txpower_set_from_eeprom Delta index for channel 7: -21 [260]
Jan 26 21:28:59 rainbow kernel: [   15.474937] ieee80211 phy0: U
iwl3945_hw_reg_get_ch_grp_index Chnl 8 mapped to grp 0
Jan 26 21:28:59 rainbow kernel: [   15.475020] ieee80211 phy0: U
iwl3945_txpower_set_from_eeprom Delta index for channel 8: -21 [260]
Jan 26 21:28:59 rainbow kernel: [   15.475099] ieee80211 phy0: U
iwl3945_hw_reg_get_ch_grp_index Chnl 9 mapped to grp 0
Jan 26 21:28:59 rainbow kernel: [   15.475167] ieee80211 phy0: U
iwl3945_txpower_set_from_eeprom Delta index for channel 9: -21 [260]
Jan 26 21:28:59 rainbow kernel: [   15.475234] ieee80211 phy0: U
iwl3945_hw_reg_get_ch_grp_index Chnl 10 mapped to grp 0
Jan 26 21:28:59 rainbow kernel: [   15.475307] ieee80211 phy0: U
iwl3945_txpower_set_from_eeprom Delta index for channel 10: -21 [260]
Jan 26 21:28:59 rainbow kernel: [   15.475373] ieee80211 phy0: U
iwl3945_hw_reg_get_ch_grp_index Chnl 11 mapped to grp 0
Jan 26 21:28:59 rainbow kernel: [   15.475443] ieee80211 phy0: U
iwl3945_txpower_set_from_eeprom Delta index for channel 11: -21 [260]
Jan 26 21:28:59 rainbow kernel: [   15.475512] ieee80211 phy0: U
iwl3945_hw_reg_get_ch_grp_index Chnl 36 mapped to grp 1
Jan 26 21:28:59 rainbow kernel: [   15.475576] ieee80211 phy0: U
iwl3945_txpower_set_from_eeprom Delta index for channel 36: -21 [260]
Jan 26 21:28:59 rainbow kernel: [   15.475641] ieee80211 phy0: U
iwl3945_hw_reg_get_ch_grp_index Chnl 40 mapped to grp 1
Jan 26 21:28:59 rainbow kernel: [   15.475705] ieee80211 phy0: U
iwl3945_txpower_set_from_eeprom Delta index for channel 40: -21 [260]
Jan 26 21:28:59 rainbow kernel: [   15.475778] ieee80211 phy0: U
iwl3945_hw_reg_get_ch_grp_index Chnl 44 mapped to grp 1
Jan 26 21:28:59 rainbow kernel: [   15.475851] ieee80211 phy0: U
iwl3945_txpower_set_from_eeprom Delta index for channel 44: -21 [260]
Jan 26 21:28:59 rainbow kernel: [   15.475917] ieee80211 phy0: U
iwl3945_hw_reg_get_ch_grp_index Chnl 48 mapped to grp 2
Jan 26 21:28:59 rainbow kernel: [   15.475981] ieee80211 phy0: U
iwl3945_txpower_set_from_eeprom Delta index for channel 48: -21 [260]
Jan 26 21:28:59 rainbow kernel: [   15.476053] ieee80211 phy0: U
iwl3945_hw_reg_get_ch_grp_index Chnl 52 mapped to grp 2
Jan 26 21:28:59 rainbow kernel: [   15.476133] ieee80211 phy0: U
iwl3945_txpower_set_from_eeprom Delta index for channel 52: -21 [260]
Jan 26 21:28:59 rainbow kernel: [   15.476199] ieee80211 phy0: U
iwl3945_hw_reg_get_ch_grp_index Chnl 56 mapped to grp 2
Jan 26 21:28:59 rainbow kernel: [   15.476268] ieee80211 phy0: U
iwl3945_txpower_set_from_eeprom Delta index for channel 56: -21 [260]
Jan 26 21:28:59 rainbow kernel: [   15.476347] ieee80211 phy0: U
iwl3945_hw_reg_get_ch_grp_index Chnl 60 mapped to grp 2
Jan 26 21:28:59 rainbow kernel: [   15.476411] ieee80211 phy0: U
iwl3945_txpower_set_from_eeprom Delta index for channel 60: -21 [260]
Jan 26 21:28:59 rainbow kernel: [   15.476477] ieee80211 phy0: U
iwl3945_hw_reg_get_ch_grp_index Chnl 64 mapped to grp 2
Jan 26 21:28:59 rainbow kernel: [   15.476546] ieee80211 phy0: U
iwl3945_txpower_set_from_eeprom Delta index for channel 64: -21 [260]
Jan 26 21:28:59 rainbow kernel: [   15.476616] ieee80211 phy0: U
iwl3945_hw_reg_get_ch_grp_index Chnl 149 mapped to grp 4
Jan 26 21:28:59 rainbow kernel: [   15.476680] ieee80211 phy0: U
iwl3945_txpower_set_from_eeprom Delta index for channel 149: -21 [260]
Jan 26 21:28:59 rainbow kernel: [   15.476746] ieee80211 phy0: U
iwl3945_hw_reg_get_ch_grp_index Chnl 153 mapped to grp 4
Jan 26 21:28:59 rainbow kernel: [   15.476815] ieee80211 phy0: U
iwl3945_txpower_set_from_eeprom Delta index for channel 153: -21 [260]
Jan 26 21:28:59 rainbow kernel: [   15.476894] ieee80211 phy0: U
iwl3945_hw_reg_get_ch_grp_index Chnl 157 mapped to grp 4
Jan 26 21:28:59 rainbow kernel: [   15.476958] ieee80211 phy0: U
iwl3945_txpower_set_from_eeprom Delta index for channel 157: -21 [260]
Jan 26 21:28:59 rainbow kernel: [   15.477027] ieee80211 phy0: U
iwl3945_hw_reg_get_ch_grp_index Chnl 161 mapped to grp 4
Jan 26 21:28:59 rainbow kernel: [   15.477121] ieee80211 phy0: U
iwl3945_txpower_set_from_eeprom Delta index for channel 161: -21 [260]
Jan 26 21:28:59 rainbow kernel: [   15.477195] ieee80211 phy0: U
iwl3945_hw_reg_get_ch_grp_index Chnl 165 mapped to grp 4
Jan 26 21:28:59 rainbow kernel: [   15.477259] ieee80211 phy0: U
iwl3945_txpower_set_from_eeprom Delta index for channel 165: -21 [260]
Jan 26 21:28:59 rainbow kernel: [   15.477333] ieee80211 phy0: U
iwl3945_init_geos Channel 1 Freq=2412[2.4GHz] valid flag=00
Jan 26 21:28:59 rainbow kernel: [   15.477401] ieee80211 phy0: U
iwl3945_init_geos Channel 2 Freq=2417[2.4GHz] valid flag=00
Jan 26 21:28:59 rainbow kernel: [   15.477465] ieee80211 phy0: U
iwl3945_init_geos Channel 3 Freq=2422[2.4GHz] valid flag=00
Jan 26 21:28:59 rainbow kernel: [   15.477530] ieee80211 phy0: U
iwl3945_init_geos Channel 4 Freq=2427[2.4GHz] valid flag=00
Jan 26 21:28:59 rainbow kernel: [   15.477594] ieee80211 phy0: U
iwl3945_init_geos Channel 5 Freq=2432[2.4GHz] valid flag=00
Jan 26 21:28:59 rainbow kernel: [   15.477679] ieee80211 phy0: U
iwl3945_init_geos Channel 6 Freq=2437[2.4GHz] valid flag=00
Jan 26 21:28:59 rainbow kernel: [   15.477743] ieee80211 phy0: U
iwl3945_init_geos Channel 7 Freq=2442[2.4GHz] valid flag=00
Jan 26 21:28:59 rainbow kernel: [   15.477808] ieee80211 phy0: U
iwl3945_init_geos Channel 8 Freq=2447[2.4GHz] valid flag=00
Jan 26 21:28:59 rainbow kernel: [   15.478518] ieee80211 phy0: U
iwl3945_init_geos Channel 9 Freq=2452[2.4GHz] valid flag=00
Jan 26 21:28:59 rainbow kernel: [   15.478596] ieee80211 phy0: U
iwl3945_init_geos Channel 10 Freq=2457[2.4GHz] valid flag=00
Jan 26 21:28:59 rainbow kernel: [   15.478667] ieee80211 phy0: U
iwl3945_init_geos Channel 11 Freq=2462[2.4GHz] valid flag=00
Jan 26 21:28:59 rainbow kernel: [   15.478736] ieee80211 phy0: U
iwl3945_init_geos Channel 36 Freq=5180[5.2GHz] valid flag=06
Jan 26 21:28:59 rainbow kernel: [   15.478806] ieee80211 phy0: U
iwl3945_init_geos Channel 40 Freq=5200[5.2GHz] valid flag=06
Jan 26 21:28:59 rainbow kernel: [   15.478871] ieee80211 phy0: U
iwl3945_init_geos Channel 44 Freq=5220[5.2GHz] valid flag=06
Jan 26 21:28:59 rainbow kernel: [   15.478935] ieee80211 phy0: U
iwl3945_init_geos Channel 48 Freq=5240[5.2GHz] valid flag=06
Jan 26 21:28:59 rainbow kernel: [   15.479019] ieee80211 phy0: U
iwl3945_init_geos Channel 52 Freq=5260[5.2GHz] valid flag=0E
Jan 26 21:28:59 rainbow kernel: [   15.479084] ieee80211 phy0: U
iwl3945_init_geos Channel 56 Freq=5280[5.2GHz] valid flag=0E
Jan 26 21:28:59 rainbow kernel: [   15.479149] ieee80211 phy0: U
iwl3945_init_geos Channel 60 Freq=5300[5.2GHz] valid flag=0E
Jan 26 21:28:59 rainbow kernel: [   15.479218] ieee80211 phy0: U
iwl3945_init_geos Channel 64 Freq=5320[5.2GHz] valid flag=0E
Jan 26 21:28:59 rainbow kernel: [   15.479287] ieee80211 phy0: U
iwl3945_init_geos Channel 149 Freq=5745[5.2GHz] valid flag=06
Jan 26 21:28:59 rainbow kernel: [   15.479351] ieee80211 phy0: U
iwl3945_init_geos Channel 153 Freq=5765[5.2GHz] valid flag=06
Jan 26 21:28:59 rainbow kernel: [   15.479416] ieee80211 phy0: U
iwl3945_init_geos Channel 157 Freq=5785[5.2GHz] valid flag=06
Jan 26 21:28:59 rainbow kernel: [   15.479480] ieee80211 phy0: U
iwl3945_init_geos Channel 161 Freq=5805[5.2GHz] valid flag=06
Jan 26 21:28:59 rainbow kernel: [   15.479565] ieee80211 phy0: U
iwl3945_init_geos Channel 165 Freq=5825[5.2GHz] valid flag=06
Jan 26 21:28:59 rainbow kernel: [   15.479630] iwl3945 0000:03:00.0:
Tunable channels: 11 802.11bg, 13 802.11a channels
Jan 26 21:28:59 rainbow kernel: [   15.479694] iwl3945 0000:03:00.0:
Detected Intel Wireless WiFi Link 3945ABG
Jan 26 21:28:59 rainbow kernel: [   15.479883] iwl3945 0000:03:00.0:
irq 31 for MSI/MSI-X
Jan 26 21:28:59 rainbow kernel: [   15.480041] ieee80211 phy0: U
iwl3945_set_rxon_channel Staging channel set to 6 [0]
Jan 26 21:28:59 rainbow kernel: [   15.481883] wmaster0 (iwl3945): not
using net_device_ops yet
Jan 26 21:28:59 rainbow kernel: [   15.482151] phy0: Selected rate
control algorithm 'iwl-3945-rs'
Jan 26 21:28:59 rainbow kernel: [   15.581245] wlan0 (iwl3945): not
using net_device_ops yet
Jan 26 21:28:59 rainbow kernel: [   16.372946] Adding 4803392k swap on
/dev/sda5.  Priority:-1 extents:1 across:4803392k
Jan 26 21:28:59 rainbow kernel: [   16.820167] EXT3 FS on sda1, internal journal
Jan 26 21:28:59 rainbow kernel: [   17.334028] ip_tables: (C)
2000-2006 Netfilter Core Team
Jan 26 21:28:59 rainbow kernel: [   19.225302] IBM TrackPoint
firmware: 0x0e, buttons: 3/3
Jan 26 21:28:59 rainbow kernel: [   19.457539] input: TPPS/2 IBM
TrackPoint as /devices/platform/i8042/serio1/serio2/input/input8
Jan 26 21:28:59 rainbow kernel: [   19.554738] warning: `avahi-daemon'
uses 32-bit capabilities (legacy support in use)
Jan 26 21:29:00 rainbow kernel: [   20.204667] NET: Registered
protocol family 10
Jan 26 21:29:00 rainbow kernel: [   20.205396] lo: Disabled Privacy Extensions
Jan 26 21:29:05 rainbow kernel: [   25.565215] [drm] Initialized drm
1.1.0 20060810
Jan 26 21:29:05 rainbow kernel: [   25.756487] pci 0000:00:02.0: power
state changed by ACPI to D0
Jan 26 21:29:05 rainbow kernel: [   25.756507] pci 0000:00:02.0: PCI
INT A -> GSI 16 (level, low) -> IRQ 16
Jan 26 21:29:05 rainbow kernel: [   25.756517] pci 0000:00:02.0:
setting latency timer to 64
Jan 26 21:29:05 rainbow kernel: [   25.765693] pci 0000:00:02.0: irq
32 for MSI/MSI-X
Jan 26 21:29:05 rainbow kernel: [   25.765733] [drm] Initialized i915
1.6.0 20080730 on minor 0
Jan 26 21:29:05 rainbow kernel: [   25.802041] mtrr: type mismatch for
e0000000,10000000 old: write-back new: write-combining
Jan 26 21:29:06 rainbow kernel: [   26.661703] ieee80211 phy0: U
iwl3945_mac_start enter
Jan 26 21:29:06 rainbow kernel: [   26.661723] iwl3945 0000:03:00.0:
firmware: requesting iwlwifi-3945-2.ucode
Jan 26 21:29:06 rainbow kernel: [   26.703939] ieee80211 phy0: U
iwl3945_read_ucode Got firmware 'iwlwifi-3945-2.ucode' file (149816
bytes) from disk
Jan 26 21:29:06 rainbow kernel: [   26.703959] iwl3945 0000:03:00.0:
loaded firmware version 15.28.2.8
Jan 26 21:29:06 rainbow kernel: [   26.703965] ieee80211 phy0: U
iwl3945_read_ucode f/w package hdr ucode version raw = 0xf1c0208
Jan 26 21:29:06 rainbow kernel: [   26.703973] ieee80211 phy0: U
iwl3945_read_ucode f/w package hdr runtime inst size = 80684
Jan 26 21:29:06 rainbow kernel: [   26.703981] ieee80211 phy0: U
iwl3945_read_ucode f/w package hdr runtime data size = 32768
Jan 26 21:29:06 rainbow kernel: [   26.703989] ieee80211 phy0: U
iwl3945_read_ucode f/w package hdr init inst size = 2672
Jan 26 21:29:06 rainbow kernel: [   26.703997] ieee80211 phy0: U
iwl3945_read_ucode f/w package hdr init data size = 32768
Jan 26 21:29:06 rainbow kernel: [   26.704029] ieee80211 phy0: U
iwl3945_read_ucode f/w package hdr boot inst size = 900
Jan 26 21:29:06 rainbow kernel: [   26.704185] ieee80211 phy0: U
iwl3945_read_ucode Copying (but not loading) uCode instr len 80684
Jan 26 21:29:06 rainbow kernel: [   26.704228] ieee80211 phy0: U
iwl3945_read_ucode uCode instr buf vaddr = 0xffff8800bb880000, paddr =
0xbb880000
Jan 26 21:29:06 rainbow kernel: [   26.704239] ieee80211 phy0: U
iwl3945_read_ucode Copying (but not loading) uCode data len 32768
Jan 26 21:29:06 rainbow kernel: [   26.704291] ieee80211 phy0: U
iwl3945_read_ucode Copying (but not loading) init instr len 2672
Jan 26 21:29:06 rainbow kernel: [   26.704303] ieee80211 phy0: U
iwl3945_read_ucode Copying (but not loading) init data len 32768
Jan 26 21:29:06 rainbow kernel: [   26.704336] ieee80211 phy0: U
iwl3945_read_ucode Copying (but not loading) boot instr len 900
Jan 26 21:29:06 rainbow kernel: [   26.704376] ieee80211 phy0: U
iwl3945_power_init_handle Initialize power
Jan 26 21:29:06 rainbow kernel: [   26.704394] ieee80211 phy0: U
iwl3945_power_init_handle adjust power command flags
Jan 26 21:29:06 rainbow kernel: [   26.704500] ieee80211 phy0: U
iwl3945_hw_nic_init HW Revision ID = 0x2
Jan 26 21:29:06 rainbow kernel: [   26.704554] ieee80211 phy0: U
iwl3945_nic_config 3945 RADIO-MM type
Jan 26 21:29:06 rainbow kernel: [   26.704569] ieee80211 phy0: U
iwl3945_nic_config SKU OP mode is basic
Jan 26 21:29:06 rainbow kernel: [   26.704578] ieee80211 phy0: U
iwl3945_nic_config 3945ABG revision is 0xF1
Jan 26 21:29:06 rainbow kernel: [   26.704593] ieee80211 phy0: U
iwl3945_nic_config Card M type B version is 0x3
Jan 26 21:29:06 rainbow kernel: [   26.705802] ieee80211 phy0: U
iwl3945_load_bsm Begin load bsm
Jan 26 21:29:06 rainbow kernel: [   26.707067] ieee80211 phy0: U
iwl3945_verify_bsm Begin verify bsm
Jan 26 21:29:06 rainbow kernel: [   26.709264] ieee80211 phy0: U
iwl3945_verify_bsm BSM bootstrap uCode image OK
Jan 26 21:29:06 rainbow kernel: [   26.709324] ieee80211 phy0: U
iwl3945_load_bsm BSM write complete, poll 1 iterations
Jan 26 21:29:06 rainbow kernel: [   26.709343] ieee80211 phy0: U
__iwl3945_up iwl3945 is coming up
Jan 26 21:29:06 rainbow kernel: [   26.709351] ieee80211 phy0: U
iwl3945_mac_start Start UP work.
Jan 26 21:29:06 rainbow kernel: [   26.720831] ieee80211 phy0: I
iwl3945_rx_handle r = 1, i = 0, REPLY_ALIVE, 0x01
Jan 26 21:29:06 rainbow kernel: [   26.720848] ieee80211 phy0: I
iwl3945_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x9
Jan 26 21:29:06 rainbow kernel: [   26.720856] ieee80211 phy0: I
iwl3945_rx_reply_alive Initialization Alive received.
Jan 26 21:29:06 rainbow kernel: [   26.728090] ieee80211 phy0: U
iwl3945_verify_inst_sparse ucode inst image size is 900
Jan 26 21:29:06 rainbow kernel: [   26.728190] ieee80211 phy0: U
iwl3945_verify_inst_sparse ucode inst image size is 2672
Jan 26 21:29:06 rainbow kernel: [   26.728476] ieee80211 phy0: U
iwl3945_verify_ucode Initialize uCode is good in inst SRAM
Jan 26 21:29:06 rainbow kernel: [   26.728484] ieee80211 phy0: U
iwl3945_init_alive_start Initialization Alive received.
Jan 26 21:29:06 rainbow kernel: [   26.728534] ieee80211 phy0: U
iwl3945_set_ucode_ptrs Runtime uCode pointers are set.
Jan 26 21:29:06 rainbow kernel: [   26.732956] ieee80211 phy0: I
iwl3945_rx_handle r = 2, i = 1, REPLY_ALIVE, 0x01
Jan 26 21:29:06 rainbow kernel: [   26.732971] ieee80211 phy0: I
iwl3945_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x0
Jan 26 21:29:06 rainbow kernel: [   26.732981] ieee80211 phy0: I
iwl3945_rx_reply_alive Runtime Alive received.
Jan 26 21:29:06 rainbow kernel: [   26.733031] ieee80211 phy0: I
iwl3945_disable_events Selected uCode log events may be disabled
Jan 26 21:29:06 rainbow kernel: [   26.733040] ieee80211 phy0: I
iwl3945_disable_events   by writing "1"s into disable bitmap
Jan 26 21:29:06 rainbow kernel: [   26.733050] ieee80211 phy0: I
iwl3945_disable_events   in SRAM at 0x8022c8, size 47 u32s
Jan 26 21:29:06 rainbow kernel: [   26.741086] ieee80211 phy0: U
iwl3945_alive_start Runtime Alive received.
Jan 26 21:29:06 rainbow kernel: [   26.741096] ieee80211 phy0: U
iwl3945_verify_inst_sparse ucode inst image size is 900
Jan 26 21:29:06 rainbow kernel: [   26.741182] ieee80211 phy0: U
iwl3945_verify_inst_sparse ucode inst image size is 2672
Jan 26 21:29:06 rainbow kernel: [   26.741277] ieee80211 phy0: U
iwl3945_verify_inst_sparse ucode inst image size is 80684
Jan 26 21:29:06 rainbow kernel: [   26.749067] ieee80211 phy0: U
iwl3945_verify_ucode Runtime uCode is good in inst SRAM
Jan 26 21:29:06 rainbow kernel: [   26.749103] ieee80211 phy0: U
iwl3945_alive_start RFKILL status: 0x1
Jan 26 21:29:06 rainbow kernel: [   26.749129] ieee80211 phy0: U
iwl3945_update_power_cmd Flags value = 0x00000008
Jan 26 21:29:06 rainbow kernel: [   26.749136] ieee80211 phy0: U
iwl3945_update_power_cmd Tx timeout = 0
Jan 26 21:29:06 rainbow kernel: [   26.749143] ieee80211 phy0: U
iwl3945_update_power_cmd Rx timeout = 0
Jan 26 21:29:06 rainbow kernel: [   26.749151] ieee80211 phy0: U
iwl3945_update_power_cmd Sleep interval vector = { 0 , 0 , 0 , 0 , 0 }
Jan 26 21:29:06 rainbow kernel: [   26.749167] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command POWER_TABLE_CMD (#77), seq: 0x0400,
36 bytes at 0[0]:4
Jan 26 21:29:06 rainbow kernel: [   26.749290] ieee80211 phy0: I
iwl3945_rx_handle r 3 i 2 No handler needed for POWER_TABLE_CMD, 0x77
Jan 26 21:29:06 rainbow kernel: [   26.749327] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_BT_CONFIG (#9b), seq: 0x0401,
16 bytes at 1[1]:4
Jan 26 21:29:06 rainbow kernel: [   26.749432] ieee80211 phy0: I
iwl3945_rx_handle r 4 i 3 No handler needed for REPLY_BT_CONFIG, 0x9b
Jan 26 21:29:06 rainbow kernel: [   26.749486] ieee80211 phy0: U
iwl3945_commit_rxon Sending RXON
Jan 26 21:29:06 rainbow kernel: [   26.749488] * without RXON_FILTER_ASSOC_MSK
Jan 26 21:29:06 rainbow kernel: [   26.749490] * channel = 1
Jan 26 21:29:06 rainbow kernel: [   26.749491] * bssid = 00:00:00:00:00:00
Jan 26 21:29:06 rainbow kernel: [   26.749510] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x0402, 48
bytes at 2[2]:4
Jan 26 21:29:06 rainbow kernel: [   26.752089] ieee80211 phy0: I
iwl3945_rx_handle r 5 i 4 No handler needed for REPLY_RXON, 0x10
Jan 26 21:29:06 rainbow kernel: [   26.752128] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 187 dsp  99 rate code 0x0d
Jan 26 21:29:06 rainbow kernel: [   26.752140] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 187 dsp  99 rate code 0x0f
Jan 26 21:29:06 rainbow kernel: [   26.752150] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 187 dsp  99 rate code 0x05
Jan 26 21:29:06 rainbow kernel: [   26.752160] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 187 dsp  99 rate code 0x07
Jan 26 21:29:06 rainbow kernel: [   26.752170] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 187 dsp  99 rate code 0x09
Jan 26 21:29:06 rainbow kernel: [   26.752180] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 187 dsp  99 rate code 0x0b
Jan 26 21:29:06 rainbow kernel: [   26.752190] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 187 dsp  99 rate code 0x01
Jan 26 21:29:06 rainbow kernel: [   26.752199] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 187 dsp  99 rate code 0x03
Jan 26 21:29:06 rainbow kernel: [   26.752209] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 179 dsp 107 rate code 0x0a
Jan 26 21:29:06 rainbow kernel: [   26.752220] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 179 dsp 107 rate code 0x14
Jan 26 21:29:06 rainbow kernel: [   26.752231] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 179 dsp 107 rate code 0x37
Jan 26 21:29:06 rainbow kernel: [   26.752241] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 179 dsp 107 rate code 0x6e
Jan 26 21:29:06 rainbow kernel: [   26.752261] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq:
0x0403, 56 bytes at 3[3]:4
Jan 26 21:29:06 rainbow kernel: [   26.752549] ieee80211 phy0: I
iwl3945_rx_handle r 6 i 5 No handler needed for
REPLY_TX_PWR_TABLE_CMD, 0x97
Jan 26 21:29:06 rainbow kernel: [   26.752601] ieee80211 phy0: U
iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
Jan 26 21:29:06 rainbow kernel: [   26.752615] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0404, 68
bytes at 4[4]:4
Jan 26 21:29:06 rainbow kernel: [   26.753811] ieee80211 phy0: I
iwl3945_rx_handle r = 8, i = 6, REPLY_3945_RX, 0x1b
Jan 26 21:29:06 rainbow kernel: [   26.753824] ieee80211 phy0: I
iwl3945_pass_packet_to_mac80211 Dropping packet while interface is not
open.
Jan 26 21:29:06 rainbow kernel: [   26.753849] ieee80211 phy0: I
iwl3945_rx_handle r = 8, i = 7, REPLY_ADD_STA, 0x18
Jan 26 21:29:06 rainbow kernel: [   26.753877] ieee80211 phy0: U
iwl3945_send_add_station REPLY_ADD_STA PASSED
Jan 26 21:29:06 rainbow kernel: [   26.753892] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0405,
56 bytes at 5[5]:4
Jan 26 21:29:06 rainbow kernel: [   26.753968] ieee80211 phy0: I
iwl3945_rx_handle r 9 i 8 No handler needed for REPLY_RATE_SCALE, 0x47
Jan 26 21:29:06 rainbow kernel: [   26.754022] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0406,
56 bytes at 6[6]:4
Jan 26 21:29:06 rainbow kernel: [   26.754098] ieee80211 phy0: I
iwl3945_rx_handle r 10 i 9 No handler needed for REPLY_RATE_SCALE,
0x47
Jan 26 21:29:06 rainbow kernel: [   26.754157] ieee80211 phy0: U
iwl3945_hw_reg_txpower_get_temperature Temperature: 41
Jan 26 21:29:06 rainbow kernel: [   26.754167] ieee80211 phy0: U
is_temp_calib_needed Getting cooler, delta -219,
Jan 26 21:29:06 rainbow kernel: [   26.754176] ieee80211 phy0: U
is_temp_calib_needed Timed thermal calib needed
Jan 26 21:29:06 rainbow kernel: [   26.754198] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 203 dsp 115 rate code 0x0d
Jan 26 21:29:06 rainbow kernel: [   26.754208] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 203 dsp 115 rate code 0x0f
Jan 26 21:29:06 rainbow kernel: [   26.754218] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 203 dsp 115 rate code 0x05
Jan 26 21:29:06 rainbow kernel: [   26.754228] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 203 dsp 115 rate code 0x07
Jan 26 21:29:06 rainbow kernel: [   26.754238] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 203 dsp 115 rate code 0x09
Jan 26 21:29:06 rainbow kernel: [   26.754248] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 203 dsp 115 rate code 0x0b
Jan 26 21:29:06 rainbow kernel: [   26.754258] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 203 dsp 115 rate code 0x01
Jan 26 21:29:06 rainbow kernel: [   26.754268] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 203 dsp 115 rate code 0x03
Jan 26 21:29:06 rainbow kernel: [   26.754279] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 227 dsp 119 rate code 0x0a
Jan 26 21:29:06 rainbow kernel: [   26.754303] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 227 dsp 119 rate code 0x14
Jan 26 21:29:06 rainbow kernel: [   26.754313] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 227 dsp 119 rate code 0x37
Jan 26 21:29:06 rainbow kernel: [   26.754323] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 227 dsp 119 rate code 0x6e
Jan 26 21:29:06 rainbow kernel: [   26.754335] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq:
0x0407, 56 bytes at 7[7]:4
Jan 26 21:29:06 rainbow kernel: [   26.754433] ieee80211 phy0: I
iwl3945_rx_handle r 11 i 10 No handler needed for
REPLY_TX_PWR_TABLE_CMD, 0x97
Jan 26 21:29:06 rainbow kernel: [   26.754570] Registered led device:
iwl-phy0:radio
Jan 26 21:29:06 rainbow kernel: [   26.754581] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0408, 12
bytes at 8[8]:4
Jan 26 21:29:06 rainbow kernel: [   26.754626] Registered led device:
iwl-phy0:assoc
Jan 26 21:29:06 rainbow kernel: [   26.754658] ieee80211 phy0: I
iwl3945_rx_handle r 12 i 11 No handler needed for REPLY_LEDS_CMD, 0x48
Jan 26 21:29:06 rainbow kernel: [   26.754667] Registered led device:
iwl-phy0:RX
Jan 26 21:29:06 rainbow kernel: [   26.754702] Registered led device:
iwl-phy0:TX
Jan 26 21:29:06 rainbow kernel: [   26.754708] ieee80211 phy0: U
iwl3945_alive_start ALIVE processing complete.
Jan 26 21:29:06 rainbow kernel: [   26.760019] ieee80211 phy0: U
iwl3945_mac_start leave
Jan 26 21:29:06 rainbow kernel: [   26.760033] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0409, 12
bytes at 9[9]:4
Jan 26 21:29:06 rainbow kernel: [   26.760043] ieee80211 phy0: U
iwl3945_mac_add_interface enter: type 2
Jan 26 21:29:06 rainbow kernel: [   26.760051] ieee80211 phy0: U
iwl3945_mac_add_interface Set: 00:1f:3c:20:a1:6e
Jan 26 21:29:06 rainbow kernel: [   26.760064] ieee80211 phy0: U
iwl3945_commit_rxon Sending RXON
Jan 26 21:29:06 rainbow kernel: [   26.760066] * without RXON_FILTER_ASSOC_MSK
Jan 26 21:29:06 rainbow kernel: [   26.760067] * channel = 1
Jan 26 21:29:06 rainbow kernel: [   26.760069] * bssid = 00:00:00:00:00:00
Jan 26 21:29:06 rainbow kernel: [   26.760086] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x040A, 48
bytes at 10[10]:4
Jan 26 21:29:06 rainbow kernel: [   26.760143] ieee80211 phy0: I
iwl3945_rx_handle r 13 i 12 No handler needed for REPLY_LEDS_CMD, 0x48
Jan 26 21:29:06 rainbow kernel: [   26.760355] ieee80211 phy0: I
iwl3945_rx_handle r 14 i 13 No handler needed for REPLY_RXON, 0x10
Jan 26 21:29:06 rainbow kernel: [   26.760392] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 203 dsp 115 rate code 0x0d
Jan 26 21:29:06 rainbow kernel: [   26.760402] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 203 dsp 115 rate code 0x0f
Jan 26 21:29:06 rainbow kernel: [   26.760410] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 203 dsp 115 rate code 0x05
Jan 26 21:29:06 rainbow kernel: [   26.760417] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 203 dsp 115 rate code 0x07
Jan 26 21:29:06 rainbow kernel: [   26.760425] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 203 dsp 115 rate code 0x09
Jan 26 21:29:06 rainbow kernel: [   26.760433] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 203 dsp 115 rate code 0x0b
Jan 26 21:29:06 rainbow kernel: [   26.760441] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 203 dsp 115 rate code 0x01
Jan 26 21:29:06 rainbow kernel: [   26.760449] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 203 dsp 115 rate code 0x03
Jan 26 21:29:06 rainbow kernel: [   26.760457] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 227 dsp 119 rate code 0x0a
Jan 26 21:29:06 rainbow kernel: [   26.760465] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 227 dsp 119 rate code 0x14
Jan 26 21:29:06 rainbow kernel: [   26.760473] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 227 dsp 119 rate code 0x37
Jan 26 21:29:06 rainbow kernel: [   26.760482] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 227 dsp 119 rate code 0x6e
Jan 26 21:29:06 rainbow kernel: [   26.760493] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq:
0x040B, 56 bytes at 11[11]:4
Jan 26 21:29:06 rainbow kernel: [   26.760594] ieee80211 phy0: I
iwl3945_rx_handle r 15 i 14 No handler needed for
REPLY_TX_PWR_TABLE_CMD, 0x97
Jan 26 21:29:06 rainbow kernel: [   26.760660] ieee80211 phy0: U
iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
Jan 26 21:29:06 rainbow kernel: [   26.760672] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x040C, 68
bytes at 12[12]:4
Jan 26 21:29:06 rainbow kernel: [   26.760752] ieee80211 phy0: I
iwl3945_rx_handle r = 16, i = 15, REPLY_ADD_STA, 0x18
Jan 26 21:29:06 rainbow kernel: [   26.760805] ieee80211 phy0: U
iwl3945_send_add_station REPLY_ADD_STA PASSED
Jan 26 21:29:06 rainbow kernel: [   26.760819] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x040D,
56 bytes at 13[13]:4
Jan 26 21:29:06 rainbow kernel: [   26.760926] ieee80211 phy0: I
iwl3945_rx_handle r 17 i 16 No handler needed for REPLY_RATE_SCALE,
0x47
Jan 26 21:29:06 rainbow kernel: [   26.760958] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x040E,
56 bytes at 14[14]:4
Jan 26 21:29:06 rainbow kernel: [   26.761054] ieee80211 phy0: I
iwl3945_rx_handle r 18 i 17 No handler needed for REPLY_RATE_SCALE,
0x47
Jan 26 21:29:06 rainbow kernel: [   26.761081] ieee80211 phy0: U
iwl3945_mac_add_interface leave
Jan 26 21:29:06 rainbow kernel: [   26.761090] ieee80211 phy0: U
iwl3945_bss_info_changed changes = 0xE
Jan 26 21:29:06 rainbow kernel: [   26.761097] ieee80211 phy0: U
iwl3945_bss_info_changed ERP_PREAMBLE 0
Jan 26 21:29:06 rainbow kernel: [   26.761104] ieee80211 phy0: U
iwl3945_bss_info_changed ERP_CTS 0
Jan 26 21:29:06 rainbow kernel: [   26.772921] ieee80211 phy0: I
iwl3945_rx_handle r = 19, i = 18, REPLY_3945_RX, 0x1b
Jan 26 21:29:06 rainbow kernel: [   26.773065] ieee80211 phy0: I
iwl3945_configure_filter Enter: changed: 0x0, total: 0x80000000
Jan 26 21:29:06 rainbow kernel: [   26.774163] ieee80211 phy0: U
iwl3945_mac_config enter to channel 1
Jan 26 21:29:06 rainbow kernel: [   26.774178] ieee80211 phy0: U
iwl3945_commit_rxon Sending RXON
Jan 26 21:29:06 rainbow kernel: [   26.774182] * without RXON_FILTER_ASSOC_MSK
Jan 26 21:29:06 rainbow kernel: [   26.774184] * channel = 1
Jan 26 21:29:06 rainbow kernel: [   26.774186] * bssid = 00:00:00:00:00:00
Jan 26 21:29:06 rainbow kernel: [   26.774207] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x040F, 48
bytes at 15[15]:4
Jan 26 21:29:06 rainbow kernel: [   26.774427] ieee80211 phy0: I
iwl3945_rx_handle r 20 i 19 No handler needed for REPLY_RXON, 0x10
Jan 26 21:29:06 rainbow kernel: [   26.774461] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 203 dsp 115 rate code 0x0d
Jan 26 21:29:06 rainbow kernel: [   26.774472] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 203 dsp 115 rate code 0x0f
Jan 26 21:29:06 rainbow kernel: [   26.774481] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 203 dsp 115 rate code 0x05
Jan 26 21:29:06 rainbow kernel: [   26.774489] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 203 dsp 115 rate code 0x07
Jan 26 21:29:06 rainbow kernel: [   26.774499] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 203 dsp 115 rate code 0x09
Jan 26 21:29:06 rainbow kernel: [   26.774507] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 203 dsp 115 rate code 0x0b
Jan 26 21:29:06 rainbow kernel: [   26.774516] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 203 dsp 115 rate code 0x01
Jan 26 21:29:06 rainbow kernel: [   26.774526] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 203 dsp 115 rate code 0x03
Jan 26 21:29:06 rainbow kernel: [   26.774534] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 227 dsp 119 rate code 0x0a
Jan 26 21:29:06 rainbow kernel: [   26.774542] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 227 dsp 119 rate code 0x14
Jan 26 21:29:06 rainbow kernel: [   26.774552] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 227 dsp 119 rate code 0x37
Jan 26 21:29:06 rainbow kernel: [   26.774561] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 227 dsp 119 rate code 0x6e
Jan 26 21:29:06 rainbow kernel: [   26.774573] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq:
0x0410, 56 bytes at 16[16]:4
Jan 26 21:29:06 rainbow kernel: [   26.774703] ieee80211 phy0: I
iwl3945_rx_handle r 21 i 20 No handler needed for
REPLY_TX_PWR_TABLE_CMD, 0x97
Jan 26 21:29:06 rainbow kernel: [   26.774734] ieee80211 phy0: U
iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
Jan 26 21:29:06 rainbow kernel: [   26.774746] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0411, 68
bytes at 17[17]:4
Jan 26 21:29:06 rainbow kernel: [   26.774855] ieee80211 phy0: I
iwl3945_rx_handle r = 22, i = 21, REPLY_ADD_STA, 0x18
Jan 26 21:29:06 rainbow kernel: [   26.774883] ieee80211 phy0: U
iwl3945_send_add_station REPLY_ADD_STA PASSED
Jan 26 21:29:06 rainbow kernel: [   26.774900] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0412,
56 bytes at 18[18]:4
Jan 26 21:29:06 rainbow kernel: [   26.775011] ieee80211 phy0: I
iwl3945_rx_handle r 23 i 22 No handler needed for REPLY_RATE_SCALE,
0x47
Jan 26 21:29:06 rainbow kernel: [   26.775042] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0413,
56 bytes at 19[19]:4
Jan 26 21:29:06 rainbow kernel: [   26.775149] ieee80211 phy0: I
iwl3945_rx_handle r 24 i 23 No handler needed for REPLY_RATE_SCALE,
0x47
Jan 26 21:29:06 rainbow kernel: [   26.775178] ieee80211 phy0: U
iwl3945_mac_config leave
Jan 26 21:29:06 rainbow kernel: [   26.775187] ieee80211 phy0: U
iwl3945_mac_conf_tx enter
Jan 26 21:29:06 rainbow kernel: [   26.775196] ieee80211 phy0: U
iwl3945_mac_conf_tx leave
Jan 26 21:29:06 rainbow kernel: [   26.775202] ieee80211 phy0: U
iwl3945_mac_conf_tx enter
Jan 26 21:29:06 rainbow kernel: [   26.775209] ieee80211 phy0: U
iwl3945_mac_conf_tx leave
Jan 26 21:29:06 rainbow kernel: [   26.775215] ieee80211 phy0: U
iwl3945_mac_conf_tx enter
Jan 26 21:29:06 rainbow kernel: [   26.775223] ieee80211 phy0: U
iwl3945_mac_conf_tx leave
Jan 26 21:29:06 rainbow kernel: [   26.775230] ieee80211 phy0: U
iwl3945_mac_conf_tx enter
Jan 26 21:29:06 rainbow kernel: [   26.775238] ieee80211 phy0: U
iwl3945_mac_conf_tx leave
Jan 26 21:29:06 rainbow kernel: [   26.775254] ieee80211 phy0: I
iwl3945_configure_filter Enter: changed: 0x0, total: 0x80000000
Jan 26 21:29:06 rainbow kernel: [   26.775281] ieee80211 phy0: I
iwl3945_configure_filter Enter: changed: 0x0, total: 0x80000000
Jan 26 21:29:06 rainbow kernel: [   26.776305] ADDRCONF(NETDEV_UP):
wlan0: link is not ready
Jan 26 21:29:06 rainbow kernel: [   26.776312] ieee80211 phy0: I
iwl3945_configure_filter Enter: changed: 0x0, total: 0x80000000
Jan 26 21:29:06 rainbow kernel: [   26.779897] ieee80211 phy0: U
iwl3945_mac_hw_scan enter
Jan 26 21:29:06 rainbow kernel: [   26.779912] ieee80211 phy0: U
iwl3945_scan_initiate Starting scan...
Jan 26 21:29:06 rainbow kernel: [   26.779925] ieee80211 phy0: U
iwl3945_mac_hw_scan leave
Jan 26 21:29:06 rainbow kernel: [   26.779939] ieee80211 phy0: U
iwl3945_bg_request_scan Kicking off one indirect scan.
Jan 26 21:29:06 rainbow kernel: [   26.779950] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 1 [ACTIVE 39]
Jan 26 21:29:06 rainbow kernel: [   26.779958] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 2 [ACTIVE 39]
Jan 26 21:29:06 rainbow kernel: [   26.779967] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 3 [ACTIVE 39]
Jan 26 21:29:06 rainbow kernel: [   26.779975] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 4 [ACTIVE 39]
Jan 26 21:29:06 rainbow kernel: [   26.779982] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 5 [ACTIVE 39]
Jan 26 21:29:06 rainbow kernel: [   26.779993] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 6 [ACTIVE 39]
Jan 26 21:29:06 rainbow kernel: [   26.780001] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 7 [ACTIVE 39]
Jan 26 21:29:06 rainbow kernel: [   26.780009] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 8 [ACTIVE 39]
Jan 26 21:29:06 rainbow kernel: [   26.780017] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 9 [ACTIVE 39]
Jan 26 21:29:06 rainbow kernel: [   26.780025] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 10 [ACTIVE 39]
Jan 26 21:29:06 rainbow kernel: [   26.780034] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 11 [ACTIVE 39]
Jan 26 21:29:06 rainbow kernel: [   26.780043] ieee80211 phy0: U
iwl3945_get_channels_for_scan total channels to scan 11
Jan 26 21:29:06 rainbow kernel: [   26.780058] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x4414,
351 bytes at 20[32]:4
Jan 26 21:29:06 rainbow kernel: [   26.780199] ieee80211 phy0: I
iwl3945_rx_handle r = 25, i = 24, REPLY_SCAN_CMD, 0x80
Jan 26 21:29:06 rainbow kernel: [   26.781235] ieee80211 phy0: I
iwl3945_rx_handle r = 27, i = 25, STATISTICS_NOTIFICATION, 0x9d
Jan 26 21:29:06 rainbow kernel: [   26.781254] ieee80211 phy0: I
iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0415, 12
bytes at 21[21]:4
Jan 26 21:29:06 rainbow kernel: [   26.781280] ieee80211 phy0: I
iwl3945_rx_handle r = 27, i = 26, SCAN_START_NOTIFICATION, 0x82
Jan 26 21:29:06 rainbow kernel: [   26.781294] ieee80211 phy0: I
iwl3945_rx_scan_start_notif Scan start: 1 [802.11bg] (TSF:
0x00000000:00001AD9) - 1 (beacon timer 95527)
Jan 26 21:29:06 rainbow kernel: [   26.781857] ieee80211 phy0: I
iwl3945_rx_handle r 28 i 27 No handler needed for REPLY_LEDS_CMD, 0x48
Jan 26 21:29:06 rainbow kernel: [   26.783200] ieee80211 phy0: I
iwl3945_rx_handle r = 29, i = 28, REPLY_3945_RX, 0x1b
Jan 26 21:29:06 rainbow kernel: [   26.784788] ieee80211 phy0: I
iwl3945_rx_handle r = 30, i = 29, REPLY_3945_RX, 0x1b
Jan 26 21:29:06 rainbow kernel: [   26.787782] ieee80211 phy0: I
iwl3945_rx_handle r = 31, i = 30, REPLY_3945_RX, 0x1b
Jan 26 21:29:06 rainbow kernel: [   26.790092] ieee80211 phy0: I
iwl3945_rx_handle r = 32, i = 31, REPLY_3945_RX, 0x1b
Jan 26 21:29:06 rainbow kernel: [   26.793591] ieee80211 phy0: I
iwl3945_rx_handle r = 33, i = 32, REPLY_3945_RX, 0x1b
Jan 26 21:29:06 rainbow kernel: [   26.795126] ieee80211 phy0: I
iwl3945_rx_handle r = 34, i = 33, REPLY_3945_RX, 0x1b
Jan 26 21:29:06 rainbow kernel: [   26.821186] ieee80211 phy0: I
iwl3945_rx_handle r = 35, i = 34, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 21:29:06 rainbow kernel: [   26.821205] ieee80211 phy0: I
iwl3945_rx_scan_results_notif Scan ch.res: 1 [802.11bg] (TSF:
0x00000000:0000B6E4) - 6 elapsed=39947 usec (-273180ms since last)
Jan 26 21:29:06 rainbow kernel: [   26.822214] ieee80211 phy0: I
iwl3945_rx_handle r = 37, i = 35, STATISTICS_NOTIFICATION, 0x9d
Jan 26 21:29:06 rainbow kernel: [   26.822243] ieee80211 phy0: I
iwl3945_rx_handle r = 37, i = 36, SCAN_START_NOTIFICATION, 0x82
Jan 26 21:29:06 rainbow kernel: [   26.822257] ieee80211 phy0: I
iwl3945_rx_scan_start_notif Scan start: 2 [802.11bg] (TSF:
0x00000000:0000BAF0) - 1 (beacon timer 54544)
Jan 26 21:29:06 rainbow kernel: [   26.834616] ieee80211 phy0: I
iwl3945_rx_handle r = 38, i = 37, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 21:29:06 rainbow kernel: [   26.834637] ieee80211 phy0: I
iwl3945_rx_scan_results_notif Scan ch.res: 2 [802.11bg] (TSF:
0x00000000:0000EB57) - 0 elapsed=12391 usec (12ms since last)
Jan 26 21:29:06 rainbow kernel: [   26.835643] ieee80211 phy0: I
iwl3945_rx_handle r = 40, i = 38, STATISTICS_NOTIFICATION, 0x9d
Jan 26 21:29:06 rainbow kernel: [   26.835669] ieee80211 phy0: I
iwl3945_rx_handle r = 40, i = 39, SCAN_START_NOTIFICATION, 0x82
Jan 26 21:29:06 rainbow kernel: [   26.835681] ieee80211 phy0: I
iwl3945_rx_scan_start_notif Scan start: 3 [802.11bg] (TSF:
0x00000000:0000EF65) - 1 (beacon timer 41114)
Jan 26 21:29:06 rainbow kernel: [   26.848102] ieee80211 phy0: I
iwl3945_rx_handle r = 41, i = 40, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 21:29:06 rainbow kernel: [   26.848122] ieee80211 phy0: I
iwl3945_rx_scan_results_notif Scan ch.res: 3 [802.11bg] (TSF:
0x00000000:00012009) - 0 elapsed=12452 usec (16ms since last)
Jan 26 21:29:06 rainbow kernel: [   26.849137] ieee80211 phy0: I
iwl3945_rx_handle r = 43, i = 41, STATISTICS_NOTIFICATION, 0x9d
Jan 26 21:29:06 rainbow kernel: [   26.849165] ieee80211 phy0: I
iwl3945_rx_handle r = 43, i = 42, SCAN_START_NOTIFICATION, 0x82
Jan 26 21:29:06 rainbow kernel: [   26.849178] ieee80211 phy0: I
iwl3945_rx_scan_start_notif Scan start: 4 [802.11bg] (TSF:
0x00000000:00012417) - 1 (beacon timer 27624)
Jan 26 21:29:06 rainbow kernel: [   26.852639] ieee80211 phy0: I
iwl3945_rx_handle r = 44, i = 43, REPLY_3945_RX, 0x1b
Jan 26 21:29:06 rainbow kernel: [   26.853928] ieee80211 phy0: I
iwl3945_rx_handle r = 45, i = 44, REPLY_3945_RX, 0x1b
Jan 26 21:29:06 rainbow kernel: [   26.855674] ieee80211 phy0: I
iwl3945_rx_handle r = 46, i = 45, REPLY_3945_RX, 0x1b
Jan 26 21:29:06 rainbow kernel: [   26.857886] ieee80211 phy0: I
iwl3945_rx_handle r = 47, i = 46, REPLY_3945_RX, 0x1b
Jan 26 21:29:06 rainbow kernel: [   26.861146] ieee80211 phy0: I
iwl3945_rx_handle r = 48, i = 47, REPLY_3945_RX, 0x1b
Jan 26 21:29:06 rainbow kernel: [   26.863260] ieee80211 phy0: I
iwl3945_rx_handle r = 49, i = 48, REPLY_3945_RX, 0x1b
Jan 26 21:29:06 rainbow kernel: [   26.874480] ieee80211 phy0: I
iwl3945_rx_handle r = 50, i = 49, REPLY_3945_RX, 0x1b
Jan 26 21:29:06 rainbow kernel: [   26.882991] ieee80211 phy0: I
iwl3945_rx_handle r = 51, i = 50, REPLY_3945_RX, 0x1b
Jan 26 21:29:06 rainbow kernel: [   26.889083] ieee80211 phy0: I
iwl3945_rx_handle r = 52, i = 51, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 21:29:06 rainbow kernel: [   26.889099] ieee80211 phy0: I
iwl3945_rx_scan_results_notif Scan ch.res: 4 [802.11bg] (TSF:
0x00000000:0001C01F) - 7 elapsed=39944 usec (40ms since last)
Jan 26 21:29:06 rainbow kernel: [   26.890123] ieee80211 phy0: I
iwl3945_rx_handle r = 54, i = 52, STATISTICS_NOTIFICATION, 0x9d
Jan 26 21:29:06 rainbow kernel: [   26.890148] ieee80211 phy0: I
iwl3945_rx_handle r = 54, i = 53, SCAN_START_NOTIFICATION, 0x82
Jan 26 21:29:06 rainbow kernel: [   26.890161] ieee80211 phy0: I
iwl3945_rx_scan_start_notif Scan start: 5 [802.11bg] (TSF:
0x00000000:0001C437) - 1 (beacon timer 16866248)
Jan 26 21:29:06 rainbow kernel: [   26.892599] ieee80211 phy0: I
iwl3945_rx_handle r = 55, i = 54, REPLY_3945_RX, 0x1b
Jan 26 21:29:06 rainbow kernel: [   26.895672] ieee80211 phy0: I
iwl3945_rx_handle r = 56, i = 55, REPLY_3945_RX, 0x1b
Jan 26 21:29:06 rainbow kernel: [   26.896618] ieee80211 phy0: I
iwl3945_rx_handle r = 57, i = 56, REPLY_3945_RX, 0x1b
Jan 26 21:29:06 rainbow kernel: [   26.911051] ieee80211 phy0: I
iwl3945_rx_handle r = 58, i = 57, REPLY_3945_RX, 0x1b
Jan 26 21:29:06 rainbow kernel: [   26.926243] ieee80211 phy0: I
iwl3945_rx_handle r = 59, i = 58, REPLY_3945_RX, 0x1b
Jan 26 21:29:06 rainbow kernel: [   26.927925] ieee80211 phy0: I
iwl3945_rx_handle r = 60, i = 59, REPLY_3945_RX, 0x1b
Jan 26 21:29:06 rainbow kernel: [   26.930071] ieee80211 phy0: I
iwl3945_rx_handle r = 61, i = 60, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 21:29:06 rainbow kernel: [   26.930077] ieee80211 phy0: I
iwl3945_rx_scan_results_notif Scan ch.res: 5 [802.11bg] (TSF:
0x00000000:00026048) - 5 elapsed=39953 usec (40ms since last)
Jan 26 21:29:06 rainbow kernel: [   26.931408] ieee80211 phy0: I
iwl3945_rx_handle r = 63, i = 61, STATISTICS_NOTIFICATION, 0x9d
Jan 26 21:29:06 rainbow kernel: [   26.931418] ieee80211 phy0: I
iwl3945_rx_handle r = 63, i = 62, SCAN_START_NOTIFICATION, 0x82
Jan 26 21:29:06 rainbow kernel: [   26.931423] ieee80211 phy0: I
iwl3945_rx_scan_start_notif Scan start: 6 [802.11bg] (TSF:
0x00000000:00026585) - 1 (beacon timer 16824955)
Jan 26 21:29:06 rainbow kernel: [   26.933520] ieee80211 phy0: I
iwl3945_rx_handle r = 64, i = 63, REPLY_3945_RX, 0x1b
Jan 26 21:29:06 rainbow kernel: [   26.935172] ieee80211 phy0: I
iwl3945_rx_handle r = 65, i = 64, REPLY_3945_RX, 0x1b
Jan 26 21:29:06 rainbow kernel: [   26.937355] ieee80211 phy0: I
iwl3945_rx_handle r = 66, i = 65, REPLY_3945_RX, 0x1b
Jan 26 21:29:06 rainbow kernel: [   26.939615] ieee80211 phy0: I
iwl3945_rx_handle r = 67, i = 66, REPLY_3945_RX, 0x1b
Jan 26 21:29:06 rainbow kernel: [   26.940898] ieee80211 phy0: I
iwl3945_rx_handle r = 68, i = 67, REPLY_3945_RX, 0x1b
Jan 26 21:29:06 rainbow kernel: [   26.942351] ieee80211 phy0: I
iwl3945_rx_handle r = 69, i = 68, REPLY_3945_RX, 0x1b
Jan 26 21:29:06 rainbow kernel: [   26.946327] NET: Registered
protocol family 17
Jan 26 21:29:06 rainbow kernel: [   26.963585] ieee80211 phy0: I
iwl3945_rx_handle r = 70, i = 69, REPLY_3945_RX, 0x1b
Jan 26 21:29:06 rainbow kernel: [   26.971410] ieee80211 phy0: I
iwl3945_rx_handle r = 71, i = 70, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 21:29:06 rainbow kernel: [   26.971416] ieee80211 phy0: I
iwl3945_rx_scan_results_notif Scan ch.res: 6 [802.11bg] (TSF:
0x00000000:0003018E) - 7 elapsed=39945 usec (40ms since last)
Jan 26 21:29:06 rainbow kernel: [   26.972460] ieee80211 phy0: I
iwl3945_rx_handle r = 73, i = 71, STATISTICS_NOTIFICATION, 0x9d
Jan 26 21:29:06 rainbow kernel: [   26.972470] ieee80211 phy0: I
iwl3945_rx_handle r = 73, i = 72, SCAN_START_NOTIFICATION, 0x82
Jan 26 21:29:06 rainbow kernel: [   26.972475] ieee80211 phy0: I
iwl3945_rx_scan_start_notif Scan start: 7 [802.11bg] (TSF:
0x00000000:000305B6) - 1 (beacon timer 16783946)
Jan 26 21:29:06 rainbow kernel: [   26.974556] ieee80211 phy0: I
iwl3945_rx_handle r = 74, i = 73, REPLY_3945_RX, 0x1b
Jan 26 21:29:06 rainbow kernel: [   26.976811] ieee80211 phy0: I
iwl3945_rx_handle r = 75, i = 74, REPLY_3945_RX, 0x1b
Jan 26 21:29:06 rainbow kernel: [   26.979017] ieee80211 phy0: I
iwl3945_rx_handle r = 76, i = 75, REPLY_3945_RX, 0x1b
Jan 26 21:29:06 rainbow kernel: [   26.999019] ieee80211 phy0: I
iwl3945_rx_handle r = 77, i = 76, REPLY_3945_RX, 0x1b
Jan 26 21:29:06 rainbow kernel: [   27.005773] ieee80211 phy0: I
iwl3945_rx_handle r = 78, i = 77, REPLY_3945_RX, 0x1b
Jan 26 21:29:06 rainbow kernel: [   27.012866] ieee80211 phy0: I
iwl3945_rx_handle r = 79, i = 78, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 21:29:06 rainbow kernel: [   27.012872] ieee80211 phy0: I
iwl3945_rx_scan_results_notif Scan ch.res: 7 [802.11bg] (TSF:
0x00000000:0003A37F) - 5 elapsed=40393 usec (44ms since last)
Jan 26 21:29:06 rainbow kernel: [   27.013923] ieee80211 phy0: I
iwl3945_rx_handle r = 81, i = 79, STATISTICS_NOTIFICATION, 0x9d
Jan 26 21:29:06 rainbow kernel: [   27.013932] ieee80211 phy0: I
iwl3945_rx_handle r = 81, i = 80, SCAN_START_NOTIFICATION, 0x82
Jan 26 21:29:06 rainbow kernel: [   27.013936] ieee80211 phy0: I
iwl3945_rx_scan_start_notif Scan start: 8 [802.11bg] (TSF:
0x00000000:0003A7A5) - 1 (beacon timer 33622107)
Jan 26 21:29:06 rainbow kernel: [   27.016030] ieee80211 phy0: I
iwl3945_rx_handle r = 82, i = 81, REPLY_3945_RX, 0x1b
Jan 26 21:29:06 rainbow kernel: [   27.018337] ieee80211 phy0: I
iwl3945_rx_handle r = 83, i = 82, REPLY_3945_RX, 0x1b
Jan 26 21:29:06 rainbow kernel: [   27.020531] ieee80211 phy0: I
iwl3945_rx_handle r = 84, i = 83, REPLY_3945_RX, 0x1b
Jan 26 21:29:06 rainbow kernel: [   27.053880] ieee80211 phy0: I
iwl3945_rx_handle r = 85, i = 84, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 21:29:06 rainbow kernel: [   27.053887] ieee80211 phy0: I
iwl3945_rx_scan_results_notif Scan ch.res: 8 [802.11bg] (TSF:
0x00000000:000443B2) - 3 elapsed=39949 usec (40ms since last)
Jan 26 21:29:06 rainbow kernel: [   27.054942] ieee80211 phy0: I
iwl3945_rx_handle r = 87, i = 85, STATISTICS_NOTIFICATION, 0x9d
Jan 26 21:29:06 rainbow kernel: [   27.054950] ieee80211 phy0: I
iwl3945_rx_handle r = 87, i = 86, SCAN_START_NOTIFICATION, 0x82
Jan 26 21:29:06 rainbow kernel: [   27.054956] ieee80211 phy0: I
iwl3945_rx_scan_start_notif Scan start: 9 [802.11bg] (TSF:
0x00000000:000447DB) - 1 (beacon timer 33581092)
Jan 26 21:29:06 rainbow kernel: [   27.066828] ieee80211 phy0: I
iwl3945_rx_handle r = 88, i = 87, REPLY_3945_RX, 0x1b
Jan 26 21:29:06 rainbow kernel: [   27.067453] ieee80211 phy0: I
iwl3945_rx_handle r = 89, i = 88, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 21:29:06 rainbow kernel: [   27.067464] ieee80211 phy0: I
iwl3945_rx_scan_results_notif Scan ch.res: 9 [802.11bg] (TSF:
0x00000000:000478C5) - 0 elapsed=12522 usec (12ms since last)
Jan 26 21:29:06 rainbow kernel: [   27.068515] ieee80211 phy0: I
iwl3945_rx_handle r = 91, i = 89, STATISTICS_NOTIFICATION, 0x9d
Jan 26 21:29:06 rainbow kernel: [   27.068538] ieee80211 phy0: I
iwl3945_rx_handle r = 91, i = 90, SCAN_START_NOTIFICATION, 0x82
Jan 26 21:29:06 rainbow kernel: [   27.068549] ieee80211 phy0: I
iwl3945_rx_scan_start_notif Scan start: 10 [802.11bg] (TSF:
0x00000000:00047CED) - 1 (beacon timer 33567507)
Jan 26 21:29:06 rainbow kernel: [   27.081195] ieee80211 phy0: I
iwl3945_rx_handle r = 93, i = 91, REPLY_3945_RX, 0x1b
Jan 26 21:29:06 rainbow kernel: [   27.081223] ieee80211 phy0: I
iwl3945_rx_handle r = 93, i = 92, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 21:29:06 rainbow kernel: [   27.081235] ieee80211 phy0: I
iwl3945_rx_scan_results_notif Scan ch.res: 10 [802.11bg] (TSF:
0x00000000:0004AE83) - 1 elapsed=12694 usec (16ms since last)
Jan 26 21:29:06 rainbow kernel: [   27.082306] ieee80211 phy0: I
iwl3945_rx_handle r = 95, i = 93, STATISTICS_NOTIFICATION, 0x9d
Jan 26 21:29:06 rainbow kernel: [   27.082329] ieee80211 phy0: I
iwl3945_rx_handle r = 95, i = 94, SCAN_START_NOTIFICATION, 0x82
Jan 26 21:29:06 rainbow kernel: [   27.082342] ieee80211 phy0: I
iwl3945_rx_scan_start_notif Scan start: 11 [802.11bg] (TSF:
0x00000000:0004B2B0) - 1 (beacon timer 50433360)
Jan 26 21:29:06 rainbow kernel: [   27.084527] ieee80211 phy0: I
iwl3945_rx_handle r = 96, i = 95, REPLY_3945_RX, 0x1b
Jan 26 21:29:06 rainbow kernel: [   27.085705] ieee80211 phy0: I
iwl3945_rx_handle r = 97, i = 96, REPLY_3945_RX, 0x1b
Jan 26 21:29:06 rainbow kernel: [   27.087438] ieee80211 phy0: I
iwl3945_rx_handle r = 98, i = 97, REPLY_3945_RX, 0x1b
Jan 26 21:29:06 rainbow kernel: [   27.089405] ieee80211 phy0: I
iwl3945_rx_handle r = 99, i = 98, REPLY_3945_RX, 0x1b
Jan 26 21:29:06 rainbow kernel: [   27.091584] ieee80211 phy0: I
iwl3945_rx_handle r = 100, i = 99, REPLY_3945_RX, 0x1b
Jan 26 21:29:06 rainbow kernel: [   27.092968] ieee80211 phy0: I
iwl3945_rx_handle r = 101, i = 100, REPLY_3945_RX, 0x1b
Jan 26 21:29:06 rainbow kernel: [   27.094809] ieee80211 phy0: I
iwl3945_rx_handle r = 102, i = 101, REPLY_3945_RX, 0x1b
Jan 26 21:29:06 rainbow kernel: [   27.096617] ieee80211 phy0: I
iwl3945_rx_handle r = 103, i = 102, REPLY_3945_RX, 0x1b
Jan 26 21:29:06 rainbow kernel: [   27.098806] ieee80211 phy0: I
iwl3945_rx_handle r = 104, i = 103, REPLY_3945_RX, 0x1b
Jan 26 21:29:06 rainbow kernel: [   27.117422] ieee80211 phy0: I
iwl3945_rx_handle r = 105, i = 104, REPLY_3945_RX, 0x1b
Jan 26 21:29:06 rainbow kernel: [   27.122258] ieee80211 phy0: I
iwl3945_rx_handle r = 106, i = 105, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 21:29:06 rainbow kernel: [   27.122270] ieee80211 phy0: I
iwl3945_rx_scan_results_notif Scan ch.res: 11 [802.11bg] (TSF:
0x00000000:00054EC0) - 10 elapsed=39952 usec (40ms since last)
Jan 26 21:29:06 rainbow kernel: [   27.123309] ieee80211 phy0: I
iwl3945_rx_handle r = 107, i = 106, SCAN_COMPLETE_NOTIFICATION, 0x84
Jan 26 21:29:06 rainbow kernel: [   27.123320] ieee80211 phy0: I
iwl3945_rx_scan_complete_notif Scan complete: 11 channels (TSF
0x000552DB:00000000) - 1
Jan 26 21:29:06 rainbow kernel: [   27.123330] ieee80211 phy0: I
iwl3945_rx_scan_complete_notif Scan pass on 2.4GHz took 344ms
Jan 26 21:29:06 rainbow kernel: [   27.123362] ieee80211 phy0: U
iwl3945_bg_request_scan Kicking off one indirect scan.
Jan 26 21:29:06 rainbow kernel: [   27.123376] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 36 [PASSIVE 110]
Jan 26 21:29:06 rainbow kernel: [   27.123384] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 40 [PASSIVE 110]
Jan 26 21:29:06 rainbow kernel: [   27.123392] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 44 [PASSIVE 110]
Jan 26 21:29:06 rainbow kernel: [   27.123399] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 48 [PASSIVE 110]
Jan 26 21:29:06 rainbow kernel: [   27.123407] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 52 [PASSIVE 110]
Jan 26 21:29:06 rainbow kernel: [   27.123414] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 56 [PASSIVE 110]
Jan 26 21:29:06 rainbow kernel: [   27.123422] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 60 [PASSIVE 110]
Jan 26 21:29:06 rainbow kernel: [   27.123430] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 64 [PASSIVE 110]
Jan 26 21:29:06 rainbow kernel: [   27.123439] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 149 [PASSIVE 110]
Jan 26 21:29:06 rainbow kernel: [   27.123446] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 153 [PASSIVE 110]
Jan 26 21:29:06 rainbow kernel: [   27.123454] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 157 [PASSIVE 110]
Jan 26 21:29:06 rainbow kernel: [   27.123462] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 161 [PASSIVE 110]
Jan 26 21:29:06 rainbow kernel: [   27.123470] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 165 [PASSIVE 110]
Jan 26 21:29:06 rainbow kernel: [   27.123477] ieee80211 phy0: U
iwl3945_get_channels_for_scan total channels to scan 13
Jan 26 21:29:06 rainbow kernel: [   27.123493] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x4416,
367 bytes at 22[32]:4
Jan 26 21:29:06 rainbow kernel: [   27.123719] ieee80211 phy0: I
iwl3945_rx_handle r = 108, i = 107, REPLY_SCAN_CMD, 0x80
Jan 26 21:29:06 rainbow kernel: [   27.124609] ieee80211 phy0: I
iwl3945_rx_handle r = 110, i = 108, STATISTICS_NOTIFICATION, 0x9d
Jan 26 21:29:06 rainbow kernel: [   27.124636] ieee80211 phy0: I
iwl3945_rx_handle r = 110, i = 109, SCAN_START_NOTIFICATION, 0x82
Jan 26 21:29:06 rainbow kernel: [   27.124650] ieee80211 phy0: I
iwl3945_rx_scan_start_notif Scan start: 36 [802.11a] (TSF:
0x00000000:00055825) - 1 (beacon timer 50391003)
Jan 26 21:29:07 rainbow kernel: [   27.237326] ieee80211 phy0: I
iwl3945_rx_handle r = 111, i = 110, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 21:29:07 rainbow kernel: [   27.237349] ieee80211 phy0: I
iwl3945_rx_scan_results_notif Scan ch.res: 36 [802.11a] (TSF:
0x00000000:0007102D) - 0 elapsed=112648 usec (116ms since last)
Jan 26 21:29:07 rainbow kernel: [   27.238217] ieee80211 phy0: I
iwl3945_rx_handle r = 113, i = 111, STATISTICS_NOTIFICATION, 0x9d
Jan 26 21:29:07 rainbow kernel: [   27.238244] ieee80211 phy0: I
iwl3945_rx_handle r = 113, i = 112, SCAN_START_NOTIFICATION, 0x82
Jan 26 21:29:07 rainbow kernel: [   27.238256] ieee80211 phy0: I
iwl3945_rx_scan_start_notif Scan start: 40 [802.11a] (TSF:
0x00000000:000713CA) - 1 (beacon timer 67157046)
Jan 26 21:29:07 rainbow kernel: [   27.350895] ieee80211 phy0: I
iwl3945_rx_handle r = 114, i = 113, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 21:29:07 rainbow kernel: [   27.350913] ieee80211 phy0: I
iwl3945_rx_scan_results_notif Scan ch.res: 40 [802.11a] (TSF:
0x00000000:0008CBD3) - 0 elapsed=112649 usec (112ms since last)
Jan 26 21:29:07 rainbow kernel: [   27.351813] ieee80211 phy0: I
iwl3945_rx_handle r = 116, i = 114, STATISTICS_NOTIFICATION, 0x9d
Jan 26 21:29:07 rainbow kernel: [   27.351837] ieee80211 phy0: I
iwl3945_rx_handle r = 116, i = 115, SCAN_START_NOTIFICATION, 0x82
Jan 26 21:29:07 rainbow kernel: [   27.351847] ieee80211 phy0: I
iwl3945_rx_scan_start_notif Scan start: 44 [802.11a] (TSF:
0x00000000:0008CF6F) - 1 (beacon timer 83923088)
Jan 26 21:29:07 rainbow kernel: [   27.464480] ieee80211 phy0: I
iwl3945_rx_handle r = 117, i = 116, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 21:29:07 rainbow kernel: [   27.464497] ieee80211 phy0: I
iwl3945_rx_scan_results_notif Scan ch.res: 44 [802.11a] (TSF:
0x00000000:000A8778) - 0 elapsed=112649 usec (116ms since last)
Jan 26 21:29:07 rainbow kernel: [   27.465423] ieee80211 phy0: I
iwl3945_rx_handle r = 119, i = 117, STATISTICS_NOTIFICATION, 0x9d
Jan 26 21:29:07 rainbow kernel: [   27.465447] ieee80211 phy0: I
iwl3945_rx_handle r = 119, i = 118, SCAN_START_NOTIFICATION, 0x82
Jan 26 21:29:07 rainbow kernel: [   27.465458] ieee80211 phy0: I
iwl3945_rx_scan_start_notif Scan start: 48 [802.11a] (TSF:
0x00000000:000A8B32) - 1 (beacon timer 100689101)
Jan 26 21:29:07 rainbow kernel: [   27.578081] ieee80211 phy0: I
iwl3945_rx_handle r = 120, i = 119, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 21:29:07 rainbow kernel: [   27.578100] ieee80211 phy0: I
iwl3945_rx_scan_results_notif Scan ch.res: 48 [802.11a] (TSF:
0x00000000:000C433B) - 0 elapsed=112649 usec (112ms since last)
Jan 26 21:29:07 rainbow kernel: [   27.578998] ieee80211 phy0: I
iwl3945_rx_handle r = 122, i = 120, STATISTICS_NOTIFICATION, 0x9d
Jan 26 21:29:07 rainbow kernel: [   27.579021] ieee80211 phy0: I
iwl3945_rx_handle r = 122, i = 121, SCAN_START_NOTIFICATION, 0x82
Jan 26 21:29:07 rainbow kernel: [   27.579032] ieee80211 phy0: I
iwl3945_rx_scan_start_notif Scan start: 52 [802.11a] (TSF:
0x00000000:000C46D8) - 1 (beacon timer 117455144)
Jan 26 21:29:07 rainbow kernel: [   27.691654] ieee80211 phy0: I
iwl3945_rx_handle r = 123, i = 122, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 21:29:07 rainbow kernel: [   27.691675] ieee80211 phy0: I
iwl3945_rx_scan_results_notif Scan ch.res: 52 [802.11a] (TSF:
0x00000000:000DFEE1) - 0 elapsed=112649 usec (112ms since last)
Jan 26 21:29:07 rainbow kernel: [   27.692546] ieee80211 phy0: I
iwl3945_rx_handle r = 125, i = 123, STATISTICS_NOTIFICATION, 0x9d
Jan 26 21:29:07 rainbow kernel: [   27.692576] ieee80211 phy0: I
iwl3945_rx_handle r = 125, i = 124, SCAN_START_NOTIFICATION, 0x82
Jan 26 21:29:07 rainbow kernel: [   27.692591] ieee80211 phy0: I
iwl3945_rx_scan_start_notif Scan start: 56 [802.11a] (TSF:
0x00000000:000E027C) - 1 (beacon timer 134221188)
Jan 26 21:29:07 rainbow kernel: [   27.805227] ieee80211 phy0: I
iwl3945_rx_handle r = 126, i = 125, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 21:29:07 rainbow kernel: [   27.805243] ieee80211 phy0: I
iwl3945_rx_scan_results_notif Scan ch.res: 56 [802.11a] (TSF:
0x00000000:000FBA84) - 0 elapsed=112648 usec (116ms since last)
Jan 26 21:29:07 rainbow kernel: [   27.806147] ieee80211 phy0: I
iwl3945_rx_handle r = 128, i = 126, STATISTICS_NOTIFICATION, 0x9d
Jan 26 21:29:07 rainbow kernel: [   27.806171] ieee80211 phy0: I
iwl3945_rx_handle r = 128, i = 127, SCAN_START_NOTIFICATION, 0x82
Jan 26 21:29:07 rainbow kernel: [   27.806182] ieee80211 phy0: I
iwl3945_rx_scan_start_notif Scan start: 60 [802.11a] (TSF:
0x00000000:000FBE21) - 1 (beacon timer 167866847)
Jan 26 21:29:07 rainbow kernel: [   27.918773] ieee80211 phy0: I
iwl3945_rx_handle r = 129, i = 128, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 21:29:07 rainbow kernel: [   27.918788] ieee80211 phy0: I
iwl3945_rx_scan_results_notif Scan ch.res: 60 [802.11a] (TSF:
0x00000000:00117629) - 0 elapsed=112648 usec (112ms since last)
Jan 26 21:29:07 rainbow kernel: [   27.920086] ieee80211 phy0: I
iwl3945_rx_handle r = 131, i = 129, STATISTICS_NOTIFICATION, 0x9d
Jan 26 21:29:07 rainbow kernel: [   27.920109] ieee80211 phy0: I
iwl3945_rx_handle r = 131, i = 130, SCAN_START_NOTIFICATION, 0x82
Jan 26 21:29:07 rainbow kernel: [   27.920120] ieee80211 phy0: I
iwl3945_rx_scan_start_notif Scan start: 64 [802.11a] (TSF:
0x00000000:00117B3B) - 1 (beacon timer 184632517)
Jan 26 21:29:07 rainbow kernel: [   28.032731] ieee80211 phy0: I
iwl3945_rx_handle r = 132, i = 131, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 21:29:07 rainbow kernel: [   28.032754] ieee80211 phy0: I
iwl3945_rx_scan_results_notif Scan ch.res: 64 [802.11a] (TSF:
0x00000000:00133344) - 0 elapsed=112649 usec (112ms since last)
Jan 26 21:29:07 rainbow kernel: [   28.034014] ieee80211 phy0: I
iwl3945_rx_handle r = 134, i = 132, STATISTICS_NOTIFICATION, 0x9d
Jan 26 21:29:07 rainbow kernel: [   28.034038] ieee80211 phy0: I
iwl3945_rx_handle r = 134, i = 133, SCAN_START_NOTIFICATION, 0x82
Jan 26 21:29:07 rainbow kernel: [   28.034049] ieee80211 phy0: I
iwl3945_rx_scan_start_notif Scan start: 149 [802.11a] (TSF:
0x00000000:00133856) - 1 (beacon timer 201398186)
Jan 26 21:29:08 rainbow kernel: [   28.146717] ieee80211 phy0: I
iwl3945_rx_handle r = 135, i = 134, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 21:29:08 rainbow kernel: [   28.146738] ieee80211 phy0: I
iwl3945_rx_scan_results_notif Scan ch.res: 149 [802.11a] (TSF:
0x00000000:0014F06F) - 0 elapsed=112665 usec (116ms since last)
Jan 26 21:29:08 rainbow kernel: [   28.147631] ieee80211 phy0: I
iwl3945_rx_handle r = 137, i = 135, STATISTICS_NOTIFICATION, 0x9d
Jan 26 21:29:08 rainbow kernel: [   28.147655] ieee80211 phy0: I
iwl3945_rx_handle r = 137, i = 136, SCAN_START_NOTIFICATION, 0x82
Jan 26 21:29:08 rainbow kernel: [   28.147666] ieee80211 phy0: I
iwl3945_rx_scan_start_notif Scan start: 153 [802.11a] (TSF:
0x00000000:0014F40C) - 1 (beacon timer 218164212)
Jan 26 21:29:08 rainbow kernel: [   28.260251] ieee80211 phy0: I
iwl3945_rx_handle r = 138, i = 137, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 21:29:08 rainbow kernel: [   28.260277] ieee80211 phy0: I
iwl3945_rx_scan_results_notif Scan ch.res: 153 [802.11a] (TSF:
0x00000000:0016AC21) - 0 elapsed=112661 usec (116ms since last)
Jan 26 21:29:08 rainbow kernel: [   28.261165] ieee80211 phy0: I
iwl3945_rx_handle r = 140, i = 138, STATISTICS_NOTIFICATION, 0x9d
Jan 26 21:29:08 rainbow kernel: [   28.261193] ieee80211 phy0: I
iwl3945_rx_handle r = 140, i = 139, SCAN_START_NOTIFICATION, 0x82
Jan 26 21:29:08 rainbow kernel: [   28.261207] ieee80211 phy0: I
iwl3945_rx_scan_start_notif Scan start: 157 [802.11a] (TSF:
0x00000000:0016AFBC) - 1 (beacon timer 234930244)
Jan 26 21:29:08 rainbow kernel: [   28.373863] ieee80211 phy0: I
iwl3945_rx_handle r = 141, i = 140, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 21:29:08 rainbow kernel: [   28.373875] ieee80211 phy0: I
iwl3945_rx_scan_results_notif Scan ch.res: 157 [802.11a] (TSF:
0x00000000:001867D7) - 0 elapsed=112667 usec (112ms since last)
Jan 26 21:29:08 rainbow kernel: [   28.374777] ieee80211 phy0: I
iwl3945_rx_handle r = 143, i = 141, STATISTICS_NOTIFICATION, 0x9d
Jan 26 21:29:08 rainbow kernel: [   28.374788] ieee80211 phy0: I
iwl3945_rx_handle r = 143, i = 142, SCAN_START_NOTIFICATION, 0x82
Jan 26 21:29:08 rainbow kernel: [   28.374794] ieee80211 phy0: I
iwl3945_rx_scan_start_notif Scan start: 161 [802.11a] (TSF:
0x00000000:00186B74) - 1 (beacon timer 251696268)
Jan 26 21:29:08 rainbow kernel: [   28.487479] ieee80211 phy0: I
iwl3945_rx_handle r = 144, i = 143, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 21:29:08 rainbow kernel: [   28.487499] ieee80211 phy0: I
iwl3945_rx_scan_results_notif Scan ch.res: 161 [802.11a] (TSF:
0x00000000:001A237D) - 0 elapsed=112649 usec (112ms since last)
Jan 26 21:29:08 rainbow kernel: [   28.488391] ieee80211 phy0: I
iwl3945_rx_handle r = 146, i = 144, STATISTICS_NOTIFICATION, 0x9d
Jan 26 21:29:08 rainbow kernel: [   28.488418] ieee80211 phy0: I
iwl3945_rx_handle r = 146, i = 145, SCAN_START_NOTIFICATION, 0x82
Jan 26 21:29:08 rainbow kernel: [   28.488430] ieee80211 phy0: I
iwl3945_rx_scan_start_notif Scan start: 165 [802.11a] (TSF:
0x00000000:001A2719) - 1 (beacon timer 268462311)
Jan 26 21:29:08 rainbow kernel: [   28.601053] ieee80211 phy0: I
iwl3945_rx_handle r = 147, i = 146, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 21:29:08 rainbow kernel: [   28.601074] ieee80211 phy0: I
iwl3945_rx_scan_results_notif Scan ch.res: 165 [802.11a] (TSF:
0x00000000:001BDF28) - 0 elapsed=112655 usec (116ms since last)
Jan 26 21:29:08 rainbow kernel: [   28.602220] ieee80211 phy0: I
iwl3945_rx_handle r = 148, i = 147, SCAN_COMPLETE_NOTIFICATION, 0x84
Jan 26 21:29:08 rainbow kernel: [   28.602235] ieee80211 phy0: I
iwl3945_rx_scan_complete_notif Scan complete: 13 channels (TSF
0x001BE3B8:00000000) - 1
Jan 26 21:29:08 rainbow kernel: [   28.602246] ieee80211 phy0: I
iwl3945_rx_scan_complete_notif Scan pass on 5.2GHz took 1480ms
Jan 26 21:29:08 rainbow kernel: [   28.602253] ieee80211 phy0: I
iwl3945_rx_scan_complete_notif Setting scan to off
Jan 26 21:29:08 rainbow kernel: [   28.602261] ieee80211 phy0: I
iwl3945_rx_scan_complete_notif Scan took 1824ms
Jan 26 21:29:08 rainbow kernel: [   28.602289] ieee80211 phy0: U
iwl3945_bg_scan_completed SCAN complete scan
Jan 26 21:29:08 rainbow kernel: [   28.602316] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 203 dsp 115 rate code 0x0d
Jan 26 21:29:08 rainbow kernel: [   28.602325] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 203 dsp 115 rate code 0x0f
Jan 26 21:29:08 rainbow kernel: [   28.602333] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 203 dsp 115 rate code 0x05
Jan 26 21:29:08 rainbow kernel: [   28.602343] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 203 dsp 115 rate code 0x07
Jan 26 21:29:08 rainbow kernel: [   28.602351] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 203 dsp 115 rate code 0x09
Jan 26 21:29:08 rainbow kernel: [   28.602359] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 203 dsp 115 rate code 0x0b
Jan 26 21:29:08 rainbow kernel: [   28.602367] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 203 dsp 115 rate code 0x01
Jan 26 21:29:08 rainbow kernel: [   28.602375] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 203 dsp 115 rate code 0x03
Jan 26 21:29:08 rainbow kernel: [   28.602384] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 227 dsp 119 rate code 0x0a
Jan 26 21:29:08 rainbow kernel: [   28.602393] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 227 dsp 119 rate code 0x14
Jan 26 21:29:08 rainbow kernel: [   28.602402] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 227 dsp 119 rate code 0x37
Jan 26 21:29:08 rainbow kernel: [   28.602411] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 1:1 rf 227 dsp 119 rate code 0x6e
Jan 26 21:29:08 rainbow kernel: [   28.602426] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq:
0x0417, 56 bytes at 23[23]:4
Jan 26 21:29:08 rainbow kernel: [   28.602528] ieee80211 phy0: I
iwl3945_rx_handle r 149 i 148 No handler needed for
REPLY_TX_PWR_TABLE_CMD, 0x97
Jan 26 21:29:08 rainbow kernel: [   28.603109] ieee80211 phy0: U
iwl3945_mac_config enter to channel 11
Jan 26 21:29:08 rainbow kernel: [   28.603123] ieee80211 phy0: U
iwl3945_set_rxon_channel Staging channel set to 11 [0]
Jan 26 21:29:08 rainbow kernel: [   28.603136] ieee80211 phy0: U
iwl3945_commit_rxon Sending RXON
Jan 26 21:29:08 rainbow kernel: [   28.603138] * without RXON_FILTER_ASSOC_MSK
Jan 26 21:29:08 rainbow kernel: [   28.603140] * channel = 11
Jan 26 21:29:08 rainbow kernel: [   28.603141] * bssid = 00:00:00:00:00:00
Jan 26 21:29:08 rainbow kernel: [   28.603162] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x0418, 48
bytes at 24[24]:4
Jan 26 21:29:08 rainbow kernel: [   28.604307] ieee80211 phy0: I
iwl3945_rx_handle r 150 i 149 No handler needed for REPLY_RXON, 0x10
Jan 26 21:29:08 rainbow kernel: [   28.604363] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 102 rate code 0x0d
Jan 26 21:29:08 rainbow kernel: [   28.604375] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 102 rate code 0x0f
Jan 26 21:29:08 rainbow kernel: [   28.604385] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 102 rate code 0x05
Jan 26 21:29:08 rainbow kernel: [   28.604395] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 102 rate code 0x07
Jan 26 21:29:08 rainbow kernel: [   28.604406] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 102 rate code 0x09
Jan 26 21:29:08 rainbow kernel: [   28.604416] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 102 rate code 0x0b
Jan 26 21:29:08 rainbow kernel: [   28.604426] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 102 rate code 0x01
Jan 26 21:29:08 rainbow kernel: [   28.604437] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 102 rate code 0x03
Jan 26 21:29:08 rainbow kernel: [   28.604447] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 107 rate code 0x0a
Jan 26 21:29:08 rainbow kernel: [   28.604458] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 107 rate code 0x14
Jan 26 21:29:08 rainbow kernel: [   28.604468] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 107 rate code 0x37
Jan 26 21:29:08 rainbow kernel: [   28.604479] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 107 rate code 0x6e
Jan 26 21:29:08 rainbow kernel: [   28.604493] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq:
0x0419, 56 bytes at 25[25]:4
Jan 26 21:29:08 rainbow kernel: [   28.604593] ieee80211 phy0: I
iwl3945_rx_handle r 151 i 150 No handler needed for
REPLY_TX_PWR_TABLE_CMD, 0x97
Jan 26 21:29:08 rainbow kernel: [   28.604645] ieee80211 phy0: U
iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
Jan 26 21:29:08 rainbow kernel: [   28.604660] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x041A, 68
bytes at 26[26]:4
Jan 26 21:29:08 rainbow kernel: [   28.604773] ieee80211 phy0: I
iwl3945_rx_handle r = 152, i = 151, REPLY_ADD_STA, 0x18
Jan 26 21:29:08 rainbow kernel: [   28.604802] ieee80211 phy0: U
iwl3945_send_add_station REPLY_ADD_STA PASSED
Jan 26 21:29:08 rainbow kernel: [   28.604818] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x041B,
56 bytes at 27[27]:4
Jan 26 21:29:08 rainbow kernel: [   28.604928] ieee80211 phy0: I
iwl3945_rx_handle r 153 i 152 No handler needed for REPLY_RATE_SCALE,
0x47
Jan 26 21:29:08 rainbow kernel: [   28.604963] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x041C,
56 bytes at 28[28]:4
Jan 26 21:29:08 rainbow kernel: [   28.605054] ieee80211 phy0: I
iwl3945_rx_handle r 154 i 153 No handler needed for REPLY_RATE_SCALE,
0x47
Jan 26 21:29:08 rainbow kernel: [   28.605089] ieee80211 phy0: U
iwl3945_mac_config leave
Jan 26 21:29:08 rainbow kernel: [   28.605104] ieee80211 phy0: U
iwl3945_mac_config_interface bssid: 00:30:bd:c0:90:24
Jan 26 21:29:08 rainbow kernel: [   28.605116] ieee80211 phy0: U
iwl3945_commit_rxon Sending RXON
Jan 26 21:29:08 rainbow kernel: [   28.605119] * without RXON_FILTER_ASSOC_MSK
Jan 26 21:29:08 rainbow kernel: [   28.605121] * channel = 11
Jan 26 21:29:08 rainbow kernel: [   28.605123] * bssid = 00:00:00:00:00:00
Jan 26 21:29:08 rainbow kernel: [   28.605142] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x041D, 48
bytes at 29[29]:4
Jan 26 21:29:08 rainbow kernel: [   28.605379] ieee80211 phy0: I
iwl3945_rx_handle r 155 i 154 No handler needed for REPLY_RXON, 0x10
Jan 26 21:29:08 rainbow kernel: [   28.605433] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 102 rate code 0x0d
Jan 26 21:29:08 rainbow kernel: [   28.605447] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 102 rate code 0x0f
Jan 26 21:29:08 rainbow kernel: [   28.605460] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 102 rate code 0x05
Jan 26 21:29:08 rainbow kernel: [   28.605472] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 102 rate code 0x07
Jan 26 21:29:08 rainbow kernel: [   28.605484] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 102 rate code 0x09
Jan 26 21:29:08 rainbow kernel: [   28.605496] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 102 rate code 0x0b
Jan 26 21:29:08 rainbow kernel: [   28.605508] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 102 rate code 0x01
Jan 26 21:29:08 rainbow kernel: [   28.605520] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 102 rate code 0x03
Jan 26 21:29:08 rainbow kernel: [   28.605532] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 107 rate code 0x0a
Jan 26 21:29:08 rainbow kernel: [   28.605544] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 107 rate code 0x14
Jan 26 21:29:08 rainbow kernel: [   28.605557] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 107 rate code 0x37
Jan 26 21:29:08 rainbow kernel: [   28.605569] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 107 rate code 0x6e
Jan 26 21:29:08 rainbow kernel: [   28.605584] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq:
0x041E, 56 bytes at 30[30]:4
Jan 26 21:29:08 rainbow kernel: [   28.605682] ieee80211 phy0: I
iwl3945_rx_handle r 156 i 155 No handler needed for
REPLY_TX_PWR_TABLE_CMD, 0x97
Jan 26 21:29:08 rainbow kernel: [   28.605733] ieee80211 phy0: U
iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
Jan 26 21:29:08 rainbow kernel: [   28.605748] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x041F, 68
bytes at 31[31]:4
Jan 26 21:29:08 rainbow kernel: [   28.605860] ieee80211 phy0: I
iwl3945_rx_handle r = 157, i = 156, REPLY_ADD_STA, 0x18
Jan 26 21:29:08 rainbow kernel: [   28.605887] ieee80211 phy0: U
iwl3945_send_add_station REPLY_ADD_STA PASSED
Jan 26 21:29:08 rainbow kernel: [   28.605902] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0420,
56 bytes at 32[0]:4
Jan 26 21:29:08 rainbow kernel: [   28.606011] ieee80211 phy0: I
iwl3945_rx_handle r 158 i 157 No handler needed for REPLY_RATE_SCALE,
0x47
Jan 26 21:29:08 rainbow kernel: [   28.606045] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0421,
56 bytes at 33[1]:4
Jan 26 21:29:08 rainbow kernel: [   28.606122] ieee80211 phy0: I
iwl3945_rx_handle r 159 i 158 No handler needed for REPLY_RATE_SCALE,
0x47
Jan 26 21:29:08 rainbow kernel: [   28.606153] ieee80211 phy0: U
iwl3945_mac_config_interface leave
Jan 26 21:29:08 rainbow kernel: [   28.606164] ieee80211 phy0: U
iwl3945_mac_conf_tx enter
Jan 26 21:29:08 rainbow kernel: [   28.606172] ieee80211 phy0: U
iwl3945_mac_conf_tx leave
Jan 26 21:29:08 rainbow kernel: [   28.606180] ieee80211 phy0: U
iwl3945_mac_conf_tx enter
Jan 26 21:29:08 rainbow kernel: [   28.606187] ieee80211 phy0: U
iwl3945_mac_conf_tx leave
Jan 26 21:29:08 rainbow kernel: [   28.606195] ieee80211 phy0: U
iwl3945_mac_conf_tx enter
Jan 26 21:29:08 rainbow kernel: [   28.606203] ieee80211 phy0: U
iwl3945_mac_conf_tx leave
Jan 26 21:29:08 rainbow kernel: [   28.606211] ieee80211 phy0: U
iwl3945_mac_conf_tx enter
Jan 26 21:29:08 rainbow kernel: [   28.606219] ieee80211 phy0: U
iwl3945_mac_conf_tx leave
Jan 26 21:29:08 rainbow kernel: [   28.606227] ieee80211 phy0: U
iwl3945_mac_reset_tsf enter
Jan 26 21:29:08 rainbow kernel: [   28.606239] ieee80211 phy0: U
iwl3945_commit_rxon Sending RXON
Jan 26 21:29:08 rainbow kernel: [   28.606242] * without RXON_FILTER_ASSOC_MSK
Jan 26 21:29:08 rainbow kernel: [   28.606245] * channel = 11
Jan 26 21:29:08 rainbow kernel: [   28.606247] * bssid = 00:00:00:00:00:00
Jan 26 21:29:08 rainbow kernel: [   28.606265] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x0422, 48
bytes at 34[2]:4
Jan 26 21:29:08 rainbow kernel: [   28.606482] ieee80211 phy0: I
iwl3945_rx_handle r 160 i 159 No handler needed for REPLY_RXON, 0x10
Jan 26 21:29:08 rainbow kernel: [   28.606516] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 102 rate code 0x0d
Jan 26 21:29:08 rainbow kernel: [   28.606527] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 102 rate code 0x0f
Jan 26 21:29:08 rainbow kernel: [   28.606537] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 102 rate code 0x05
Jan 26 21:29:08 rainbow kernel: [   28.606547] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 102 rate code 0x07
Jan 26 21:29:08 rainbow kernel: [   28.606557] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 102 rate code 0x09
Jan 26 21:29:08 rainbow kernel: [   28.606567] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 102 rate code 0x0b
Jan 26 21:29:08 rainbow kernel: [   28.606577] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 102 rate code 0x01
Jan 26 21:29:08 rainbow kernel: [   28.606587] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 102 rate code 0x03
Jan 26 21:29:08 rainbow kernel: [   28.606598] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 107 rate code 0x0a
Jan 26 21:29:08 rainbow kernel: [   28.606608] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 107 rate code 0x14
Jan 26 21:29:08 rainbow kernel: [   28.606618] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 107 rate code 0x37
Jan 26 21:29:08 rainbow kernel: [   28.606628] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 107 rate code 0x6e
Jan 26 21:29:08 rainbow kernel: [   28.606641] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq:
0x0423, 56 bytes at 35[3]:4
Jan 26 21:29:08 rainbow kernel: [   28.606738] ieee80211 phy0: I
iwl3945_rx_handle r 161 i 160 No handler needed for
REPLY_TX_PWR_TABLE_CMD, 0x97
Jan 26 21:29:08 rainbow kernel: [   28.606788] ieee80211 phy0: U
iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
Jan 26 21:29:08 rainbow kernel: [   28.606802] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0424, 68
bytes at 36[4]:4
Jan 26 21:29:08 rainbow kernel: [   28.606880] ieee80211 phy0: I
iwl3945_rx_handle r = 162, i = 161, REPLY_ADD_STA, 0x18
Jan 26 21:29:08 rainbow kernel: [   28.606931] ieee80211 phy0: U
iwl3945_send_add_station REPLY_ADD_STA PASSED
Jan 26 21:29:08 rainbow kernel: [   28.606947] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0425,
56 bytes at 37[5]:4
Jan 26 21:29:08 rainbow kernel: [   28.607056] ieee80211 phy0: I
iwl3945_rx_handle r 163 i 162 No handler needed for REPLY_RATE_SCALE,
0x47
Jan 26 21:29:08 rainbow kernel: [   28.607089] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0426,
56 bytes at 38[6]:4
Jan 26 21:29:08 rainbow kernel: [   28.607199] ieee80211 phy0: I
iwl3945_rx_handle r 164 i 163 No handler needed for REPLY_RATE_SCALE,
0x47
Jan 26 21:29:08 rainbow kernel: [   28.607227] ieee80211 phy0: U
iwl3945_mac_reset_tsf leave - not in IBSS
Jan 26 21:29:08 rainbow kernel: [   28.607238] wlan0: authenticate
with AP 00:30:bd:c0:90:24
Jan 26 21:29:08 rainbow kernel: [   28.607261] ieee80211 phy0: I
iwl3945_mac_tx enter
Jan 26 21:29:08 rainbow kernel: [   28.607276] ieee80211 phy0: I
iwl3945_mac_tx leave
Jan 26 21:29:08 rainbow kernel: [   28.607394] ieee80211 phy0: I
iwl3945_rx_handle r = 165, i = 164, REPLY_TX, 0x1c
Jan 26 21:29:08 rainbow kernel: [   28.805155] wlan0: authenticate
with AP 00:30:bd:c0:90:24
Jan 26 21:29:08 rainbow kernel: [   28.805186] ieee80211 phy0: I
iwl3945_mac_tx enter
Jan 26 21:29:08 rainbow kernel: [   28.805209] ieee80211 phy0: I
iwl3945_mac_tx leave
Jan 26 21:29:08 rainbow kernel: [   28.807392] iwl3945 0000:03:00.0:
Microcode SW error detected. Restarting 0x82000008.
Jan 26 21:29:08 rainbow kernel: [   28.807430] iwl3945 0000:03:00.0:
Start IWL Error Log Dump:
Jan 26 21:29:08 rainbow kernel: [   28.807438] iwl3945 0000:03:00.0:
Status: 0x000202E4, count: 1
Jan 26 21:29:08 rainbow kernel: [   28.807444] iwl3945 0000:03:00.0:
Desc       Time       asrtPC  blink2 ilink1  nmiPC   Line
Jan 26 21:29:08 rainbow kernel: [   28.807521] iwl3945 0000:03:00.0:
SYSASSERT     (#5) 0000200924 0x0089A 0x0025E 0x00304 0x04BC6 78
Jan 26 21:29:08 rainbow kernel: [   28.807524]
Jan 26 21:29:08 rainbow kernel: [   28.807595] iwl3945 0000:03:00.0:
Start IWL Event Log Dump: display count 512, wraps 7
Jan 26 21:29:08 rainbow kernel: [   28.807632] iwl3945 0000:03:00.0:
0001373163^I0x00000912^I1115
Jan 26 21:29:08 rainbow kernel: [   28.807667] iwl3945 0000:03:00.0:
0001373170^I0x00000099^I0464
Jan 26 21:29:08 rainbow kernel: [   28.807759] iwl3945 0000:03:00.0:
0001373171^I0x00000099^I0462
Jan 26 21:29:08 rainbow kernel: [   28.807794] iwl3945 0000:03:00.0:
0001458547^I0x000000d9^I0106
Jan 26 21:29:08 rainbow kernel: [   28.807829] iwl3945 0000:03:00.0:
0001458549^I0x00000000^I0302
Jan 26 21:29:08 rainbow kernel: [   28.807864] iwl3945 0000:03:00.0:
0001458588^I0x00000001^I0353
Jan 26 21:29:08 rainbow kernel: [   28.807900] iwl3945 0000:03:00.0:
0001458617^I0x000000d9^I0106
Jan 26 21:29:08 rainbow kernel: [   28.807934] iwl3945 0000:03:00.0:
0001458619^I0x00000000^I0302
Jan 26 21:29:08 rainbow kernel: [   28.807970] iwl3945 0000:03:00.0:
0001458628^I0x00008000^I0350
Jan 26 21:29:08 rainbow kernel: [   28.808005] iwl3945 0000:03:00.0:
0001485869^I0x0000009d^I1108
Jan 26 21:29:08 rainbow kernel: [   28.808040] iwl3945 0000:03:00.0:
0001485871^I0x0000000e^I1101
Jan 26 21:29:08 rainbow kernel: [   28.808076] iwl3945 0000:03:00.0:
0001485872^I0x00680034^I1102
Jan 26 21:29:08 rainbow kernel: [   28.808112] iwl3945 0000:03:00.0:
0001485874^I0x00680035^I1102
Jan 26 21:29:08 rainbow kernel: [   28.808148] iwl3945 0000:03:00.0:
0001485875^I0x007c0036^I1102
Jan 26 21:29:08 rainbow kernel: [   28.808184] iwl3945 0000:03:00.0:
0001485877^I0x007d0037^I1102
Jan 26 21:29:08 rainbow kernel: [   28.808220] iwl3945 0000:03:00.0:
0001485878^I0x00000038^I1102
Jan 26 21:29:08 rainbow kernel: [   28.808255] iwl3945 0000:03:00.0:
0001485880^I0x00830052^I1102
Jan 26 21:29:08 rainbow kernel: [   28.808291] iwl3945 0000:03:00.0:
0001485881^I0x00830053^I1102
Jan 26 21:29:08 rainbow kernel: [   28.808327] iwl3945 0000:03:00.0:
0001485883^I0x007f0054^I1102
Jan 26 21:29:08 rainbow kernel: [   28.808363] iwl3945 0000:03:00.0:
0001485884^I0x007d0055^I1102
Jan 26 21:29:08 rainbow kernel: [   28.808398] iwl3945 0000:03:00.0:
0001485886^I0x00000056^I1102
Jan 26 21:29:08 rainbow kernel: [   28.808433] iwl3945 0000:03:00.0:
0001485887^I0x00007050^I1102
Jan 26 21:29:08 rainbow kernel: [   28.808469] iwl3945 0000:03:00.0:
0001485889^I0x00017051^I1102
Jan 26 21:29:08 rainbow kernel: [   28.808504] iwl3945 0000:03:00.0:
0001485891^I0x00008204^I1102
Jan 26 21:29:08 rainbow kernel: [   28.808540] iwl3945 0000:03:00.0:
0001485893^I0x00018205^I1102
Jan 26 21:29:08 rainbow kernel: [   28.808576] iwl3945 0000:03:00.0:
0001485896^I0x00000001^I1101
Jan 26 21:29:08 rainbow kernel: [   28.808612] iwl3945 0000:03:00.0:
0001485897^I0x008b0063^I1102
Jan 26 21:29:08 rainbow kernel: [   28.808648] iwl3945 0000:03:00.0:
0001485899^I0x0000001d^I1104
Jan 26 21:29:08 rainbow kernel: [   28.808684] iwl3945 0000:03:00.0:
0001485901^I0x00000002^I1101
Jan 26 21:29:08 rainbow kernel: [   28.808719] iwl3945 0000:03:00.0:
0001485902^I0x0082903f^I1102
Jan 26 21:29:08 rainbow kernel: [   28.808755] iwl3945 0000:03:00.0:
0001485904^I0x0000d213^I1102
Jan 26 21:29:08 rainbow kernel: [   28.808791] iwl3945 0000:03:00.0:
0001485907^I0x00000002^I1101
Jan 26 21:29:08 rainbow kernel: [   28.808826] iwl3945 0000:03:00.0:
0001485908^I0x0005d206^I1102
Jan 26 21:29:08 rainbow kernel: [   28.808867] iwl3945 0000:03:00.0:
0001485910^I0x0087903e^I1102
Jan 26 21:29:08 rainbow kernel: [   28.808903] iwl3945 0000:03:00.0:
0001485914^I0x0000005a^I1101
Jan 26 21:29:08 rainbow kernel: [   28.808939] iwl3945 0000:03:00.0:
0001486015^I0x00000013^I1101
Jan 26 21:29:08 rainbow kernel: [   28.808974] iwl3945 0000:03:00.0:
0001486032^I0x0000000e^I1107
Jan 26 21:29:08 rainbow kernel: [   28.809010] iwl3945 0000:03:00.0:
0001486548^I0x0e00c12c^I1110
Jan 26 21:29:08 rainbow kernel: [   28.809046] iwl3945 0000:03:00.0:
0001486560^I0xffffff33^I0454
Jan 26 21:29:08 rainbow kernel: [   28.809082] iwl3945 0000:03:00.0:
0001486561^I0x00000000^I0472
Jan 26 21:29:08 rainbow kernel: [   28.809117] iwl3945 0000:03:00.0:
0001486573^I0x00000099^I0464
Jan 26 21:29:08 rainbow kernel: [   28.809153] iwl3945 0000:03:00.0:
0001486575^I0xffffff33^I1111
Jan 26 21:29:08 rainbow kernel: [   28.809190] iwl3945 0000:03:00.0:
0001486598^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.809228] iwl3945 0000:03:00.0:
0001486598^I0x0000000e^I1106
Jan 26 21:29:08 rainbow kernel: [   28.809263] iwl3945 0000:03:00.0:
0001486603^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.809299] iwl3945 0000:03:00.0:
0001486607^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.809336] iwl3945 0000:03:00.0:
0001486611^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.809372] iwl3945 0000:03:00.0:
0001486615^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.809408] iwl3945 0000:03:00.0:
0001486620^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.809447] iwl3945 0000:03:00.0:
0001486624^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.809484] iwl3945 0000:03:00.0:
0001486628^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.809520] iwl3945 0000:03:00.0:
0001486633^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.809557] iwl3945 0000:03:00.0:
0001486637^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.809592] iwl3945 0000:03:00.0:
0001486641^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.809628] iwl3945 0000:03:00.0:
0001486645^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.809663] iwl3945 0000:03:00.0:
0001486650^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.809699] iwl3945 0000:03:00.0:
0001486654^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.809736] iwl3945 0000:03:00.0:
0001486658^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.809774] iwl3945 0000:03:00.0:
0001486662^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.809811] iwl3945 0000:03:00.0:
0001486667^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.809846] iwl3945 0000:03:00.0:
0001486671^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.809882] iwl3945 0000:03:00.0:
0001486675^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.809918] iwl3945 0000:03:00.0:
0001486680^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.809954] iwl3945 0000:03:00.0:
0001486684^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.809991] iwl3945 0000:03:00.0:
0001486688^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.810029] iwl3945 0000:03:00.0:
0001486692^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.810067] iwl3945 0000:03:00.0:
0001486697^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.810102] iwl3945 0000:03:00.0:
0001486701^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.810138] iwl3945 0000:03:00.0:
0001486705^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.810175] iwl3945 0000:03:00.0:
0001486709^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.810211] iwl3945 0000:03:00.0:
0001486714^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.810246] iwl3945 0000:03:00.0:
0001486718^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.810282] iwl3945 0000:03:00.0:
0001486722^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.810318] iwl3945 0000:03:00.0:
0001486727^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.810358] iwl3945 0000:03:00.0:
0001486731^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.810393] iwl3945 0000:03:00.0:
0001486735^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.810430] iwl3945 0000:03:00.0:
0001486739^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.810465] iwl3945 0000:03:00.0:
0001486744^I0x00000001^I1106
Jan 26 21:29:08 rainbow kernel: [   28.810501] iwl3945 0000:03:00.0:
0001486744^I0x0000000f^I1106
Jan 26 21:29:08 rainbow kernel: [   28.810537] iwl3945 0000:03:00.0:
0001486746^I0x00000370^I1105
Jan 26 21:29:08 rainbow kernel: [   28.810573] iwl3945 0000:03:00.0:
0001486749^I0x00000912^I1115
Jan 26 21:29:08 rainbow kernel: [   28.810612] iwl3945 0000:03:00.0:
0001486754^I0x0000009d^I0464
Jan 26 21:29:08 rainbow kernel: [   28.810649] iwl3945 0000:03:00.0:
0001486755^I0x0000009d^I0462
Jan 26 21:29:08 rainbow kernel: [   28.810686] iwl3945 0000:03:00.0:
0001569371^I0x000000d9^I0106
Jan 26 21:29:08 rainbow kernel: [   28.810721] iwl3945 0000:03:00.0:
0001569373^I0x00000000^I0302
Jan 26 21:29:08 rainbow kernel: [   28.810757] iwl3945 0000:03:00.0:
0001569411^I0x00000001^I0353
Jan 26 21:29:08 rainbow kernel: [   28.810794] iwl3945 0000:03:00.0:
0001569437^I0x000000d9^I0106
Jan 26 21:29:08 rainbow kernel: [   28.810829] iwl3945 0000:03:00.0:
0001569438^I0x00000000^I0302
Jan 26 21:29:08 rainbow kernel: [   28.810865] iwl3945 0000:03:00.0:
0001569478^I0x00000002^I0353
Jan 26 21:29:08 rainbow kernel: [   28.810902] iwl3945 0000:03:00.0:
0001569489^I0x00000000^I0302
Jan 26 21:29:08 rainbow kernel: [   28.810940] iwl3945 0000:03:00.0:
0001569498^I0x00008000^I0350
Jan 26 21:29:08 rainbow kernel: [   28.810978] iwl3945 0000:03:00.0:
0001599460^I0x000000a1^I1108
Jan 26 21:29:08 rainbow kernel: [   28.811013] iwl3945 0000:03:00.0:
0001599462^I0x0000000e^I1101
Jan 26 21:29:08 rainbow kernel: [   28.811049] iwl3945 0000:03:00.0:
0001599463^I0x00680034^I1102
Jan 26 21:29:08 rainbow kernel: [   28.811085] iwl3945 0000:03:00.0:
0001599464^I0x00680035^I1102
Jan 26 21:29:08 rainbow kernel: [   28.811121] iwl3945 0000:03:00.0:
0001599466^I0x007c0036^I1102
Jan 26 21:29:08 rainbow kernel: [   28.811158] iwl3945 0000:03:00.0:
0001599467^I0x007d0037^I1102
Jan 26 21:29:08 rainbow kernel: [   28.811196] iwl3945 0000:03:00.0:
0001599469^I0x00000038^I1102
Jan 26 21:29:08 rainbow kernel: [   28.811232] iwl3945 0000:03:00.0:
0001599470^I0x00830052^I1102
Jan 26 21:29:08 rainbow kernel: [   28.811269] iwl3945 0000:03:00.0:
0001599472^I0x00830053^I1102
Jan 26 21:29:08 rainbow kernel: [   28.811305] iwl3945 0000:03:00.0:
0001599473^I0x007f0054^I1102
Jan 26 21:29:08 rainbow kernel: [   28.811341] iwl3945 0000:03:00.0:
0001599475^I0x007d0055^I1102
Jan 26 21:29:08 rainbow kernel: [   28.811350] iwl3945 0000:03:00.0:
0001599477^I0x00000056^I1102
Jan 26 21:29:08 rainbow kernel: [   28.811350] iwl3945 0000:03:00.0:
0001599478^I0x00007050^I1102
Jan 26 21:29:08 rainbow kernel: [   28.811350] iwl3945 0000:03:00.0:
0001599480^I0x00017051^I1102
Jan 26 21:29:08 rainbow kernel: [   28.811350] iwl3945 0000:03:00.0:
0001599482^I0x00008204^I1102
Jan 26 21:29:08 rainbow kernel: [   28.811350] iwl3945 0000:03:00.0:
0001599484^I0x00018205^I1102
Jan 26 21:29:08 rainbow kernel: [   28.811350] iwl3945 0000:03:00.0:
0001599487^I0x00000001^I1101
Jan 26 21:29:08 rainbow kernel: [   28.811350] iwl3945 0000:03:00.0:
0001599488^I0x008b0063^I1102
Jan 26 21:29:08 rainbow kernel: [   28.811350] iwl3945 0000:03:00.0:
0001599490^I0x0000001d^I1104
Jan 26 21:29:08 rainbow kernel: [   28.811350] iwl3945 0000:03:00.0:
0001599492^I0x00000002^I1101
Jan 26 21:29:08 rainbow kernel: [   28.811350] iwl3945 0000:03:00.0:
0001599493^I0x0082903f^I1102
Jan 26 21:29:08 rainbow kernel: [   28.811350] iwl3945 0000:03:00.0:
0001599495^I0x0000d213^I1102
Jan 26 21:29:08 rainbow kernel: [   28.811350] iwl3945 0000:03:00.0:
0001599498^I0x00000002^I1101
Jan 26 21:29:08 rainbow kernel: [   28.811350] iwl3945 0000:03:00.0:
0001599499^I0x0005d206^I1102
Jan 26 21:29:08 rainbow kernel: [   28.811350] iwl3945 0000:03:00.0:
0001599500^I0x0087903e^I1102
Jan 26 21:29:08 rainbow kernel: [   28.811350] iwl3945 0000:03:00.0:
0001599504^I0x0000005a^I1101
Jan 26 21:29:08 rainbow kernel: [   28.811350] iwl3945 0000:03:00.0:
0001599606^I0x00000013^I1101
Jan 26 21:29:08 rainbow kernel: [   28.811350] iwl3945 0000:03:00.0:
0001599622^I0x0000000e^I1107
Jan 26 21:29:08 rainbow kernel: [   28.811350] iwl3945 0000:03:00.0:
0001600139^I0x0f009575^I1110
Jan 26 21:29:08 rainbow kernel: [   28.811350] iwl3945 0000:03:00.0:
0001600151^I0xffffff34^I0454
Jan 26 21:29:08 rainbow kernel: [   28.811350] iwl3945 0000:03:00.0:
0001600152^I0x00000000^I0472
Jan 26 21:29:08 rainbow kernel: [   28.811350] iwl3945 0000:03:00.0:
0001600163^I0x0000009d^I0464
Jan 26 21:29:08 rainbow kernel: [   28.811350] iwl3945 0000:03:00.0:
0001600165^I0xffffff34^I1111
Jan 26 21:29:08 rainbow kernel: [   28.811350] iwl3945 0000:03:00.0:
0001600188^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.812189] iwl3945 0000:03:00.0:
0001600188^I0x0000000e^I1106
Jan 26 21:29:08 rainbow kernel: [   28.812189] iwl3945 0000:03:00.0:
0001600193^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.812189] iwl3945 0000:03:00.0:
0001600197^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.812189] iwl3945 0000:03:00.0:
0001600201^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.812189] iwl3945 0000:03:00.0:
0001600205^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.812189] iwl3945 0000:03:00.0:
0001600210^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.812189] iwl3945 0000:03:00.0:
0001600214^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.812189] iwl3945 0000:03:00.0:
0001600218^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.812189] iwl3945 0000:03:00.0:
0001600223^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.812189] iwl3945 0000:03:00.0:
0001600227^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.812189] iwl3945 0000:03:00.0:
0001600231^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.812189] iwl3945 0000:03:00.0:
0001600235^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.812189] iwl3945 0000:03:00.0:
0001600240^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.812189] iwl3945 0000:03:00.0:
0001600244^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.812189] iwl3945 0000:03:00.0:
0001600248^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.812189] iwl3945 0000:03:00.0:
0001600252^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.812189] iwl3945 0000:03:00.0:
0001600257^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.812189] iwl3945 0000:03:00.0:
0001600261^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.812189] iwl3945 0000:03:00.0:
0001600265^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.812189] iwl3945 0000:03:00.0:
0001600270^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.812909] iwl3945 0000:03:00.0:
0001600274^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.812909] iwl3945 0000:03:00.0:
0001600278^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.812909] iwl3945 0000:03:00.0:
0001600282^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.812909] iwl3945 0000:03:00.0:
0001600287^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.812909] iwl3945 0000:03:00.0:
0001600291^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.812909] iwl3945 0000:03:00.0:
0001600295^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.812909] iwl3945 0000:03:00.0:
0001600299^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.812909] iwl3945 0000:03:00.0:
0001600304^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.812909] iwl3945 0000:03:00.0:
0001600308^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.812909] iwl3945 0000:03:00.0:
0001600312^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.812909] iwl3945 0000:03:00.0:
0001600317^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.812909] iwl3945 0000:03:00.0:
0001600321^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.812909] iwl3945 0000:03:00.0:
0001600325^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.812909] iwl3945 0000:03:00.0:
0001600329^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.812909] iwl3945 0000:03:00.0:
0001600334^I0x00000001^I1106
Jan 26 21:29:08 rainbow kernel: [   28.812909] iwl3945 0000:03:00.0:
0001600334^I0x0000000f^I1106
Jan 26 21:29:08 rainbow kernel: [   28.812909] iwl3945 0000:03:00.0:
0001600336^I0x00000370^I1105
Jan 26 21:29:08 rainbow kernel: [   28.812909] iwl3945 0000:03:00.0:
0001600339^I0x00000912^I1115
Jan 26 21:29:08 rainbow kernel: [   28.812909] iwl3945 0000:03:00.0:
0001600346^I0x000000a1^I0464
Jan 26 21:29:08 rainbow kernel: [   28.812909] iwl3945 0000:03:00.0:
0001600347^I0x000000a1^I0462
Jan 26 21:29:08 rainbow kernel: [   28.812909] iwl3945 0000:03:00.0:
0001709627^I0x000000d9^I0106
Jan 26 21:29:08 rainbow kernel: [   28.813705] iwl3945 0000:03:00.0:
0001709628^I0x00000000^I0302
Jan 26 21:29:08 rainbow kernel: [   28.813705] iwl3945 0000:03:00.0:
0001709637^I0x00008000^I0350
Jan 26 21:29:08 rainbow kernel: [   28.813705] iwl3945 0000:03:00.0:
0001713034^I0x000000a5^I1108
Jan 26 21:29:08 rainbow kernel: [   28.813705] iwl3945 0000:03:00.0:
0001713036^I0x0000000e^I1101
Jan 26 21:29:08 rainbow kernel: [   28.813705] iwl3945 0000:03:00.0:
0001713037^I0x00680034^I1102
Jan 26 21:29:08 rainbow kernel: [   28.813705] iwl3945 0000:03:00.0:
0001713038^I0x00680035^I1102
Jan 26 21:29:08 rainbow kernel: [   28.813705] iwl3945 0000:03:00.0:
0001713040^I0x007c0036^I1102
Jan 26 21:29:08 rainbow kernel: [   28.813705] iwl3945 0000:03:00.0:
0001713041^I0x007d0037^I1102
Jan 26 21:29:08 rainbow kernel: [   28.813705] iwl3945 0000:03:00.0:
0001713043^I0x00000038^I1102
Jan 26 21:29:08 rainbow kernel: [   28.813705] iwl3945 0000:03:00.0:
0001713044^I0x00830052^I1102
Jan 26 21:29:08 rainbow kernel: [   28.813705] iwl3945 0000:03:00.0:
0001713046^I0x00830053^I1102
Jan 26 21:29:08 rainbow kernel: [   28.813705] iwl3945 0000:03:00.0:
0001713047^I0x007f0054^I1102
Jan 26 21:29:08 rainbow kernel: [   28.813705] iwl3945 0000:03:00.0:
0001713049^I0x007d0055^I1102
Jan 26 21:29:08 rainbow kernel: [   28.813705] iwl3945 0000:03:00.0:
0001713050^I0x00000056^I1102
Jan 26 21:29:08 rainbow kernel: [   28.813705] iwl3945 0000:03:00.0:
0001713052^I0x00007050^I1102
Jan 26 21:29:08 rainbow kernel: [   28.813705] iwl3945 0000:03:00.0:
0001713054^I0x00017051^I1102
Jan 26 21:29:08 rainbow kernel: [   28.813705] iwl3945 0000:03:00.0:
0001713056^I0x00008204^I1102
Jan 26 21:29:08 rainbow kernel: [   28.813705] iwl3945 0000:03:00.0:
0001713058^I0x00018205^I1102
Jan 26 21:29:08 rainbow kernel: [   28.813705] iwl3945 0000:03:00.0:
0001713061^I0x00000001^I1101
Jan 26 21:29:08 rainbow kernel: [   28.813705] iwl3945 0000:03:00.0:
0001713062^I0x008b0063^I1102
Jan 26 21:29:08 rainbow kernel: [   28.813705] iwl3945 0000:03:00.0:
0001713064^I0x0000001c^I1104
Jan 26 21:29:08 rainbow kernel: [   28.813705] iwl3945 0000:03:00.0:
0001713065^I0x00000002^I1101
Jan 26 21:29:08 rainbow kernel: [   28.813705] iwl3945 0000:03:00.0:
0001713066^I0x0082903f^I1102
Jan 26 21:29:08 rainbow kernel: [   28.813705] iwl3945 0000:03:00.0:
0001713068^I0x0000d213^I1102
Jan 26 21:29:08 rainbow kernel: [   28.813705] iwl3945 0000:03:00.0:
0001713071^I0x00000002^I1101
Jan 26 21:29:08 rainbow kernel: [   28.813705] iwl3945 0000:03:00.0:
0001713072^I0x0005d206^I1102
Jan 26 21:29:08 rainbow kernel: [   28.813705] iwl3945 0000:03:00.0:
0001713074^I0x0087903e^I1102
Jan 26 21:29:08 rainbow kernel: [   28.813705] iwl3945 0000:03:00.0:
0001713078^I0x0000005a^I1101
Jan 26 21:29:08 rainbow kernel: [   28.813705] iwl3945 0000:03:00.0:
0001713179^I0x00000013^I1101
Jan 26 21:29:08 rainbow kernel: [   28.814760] iwl3945 0000:03:00.0:
0001713196^I0x0000000e^I1107
Jan 26 21:29:08 rainbow kernel: [   28.814760] iwl3945 0000:03:00.0:
0001713713^I0x100069cf^I1110
Jan 26 21:29:08 rainbow kernel: [   28.814760] iwl3945 0000:03:00.0:
0001713725^I0xffffff34^I0454
Jan 26 21:29:08 rainbow kernel: [   28.814760] iwl3945 0000:03:00.0:
0001713726^I0x00000000^I0472
Jan 26 21:29:08 rainbow kernel: [   28.814760] iwl3945 0000:03:00.0:
0001713738^I0x000000a1^I0464
Jan 26 21:29:08 rainbow kernel: [   28.814760] iwl3945 0000:03:00.0:
0001713740^I0xffffff34^I1111
Jan 26 21:29:08 rainbow kernel: [   28.814760] iwl3945 0000:03:00.0:
0001713762^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.814760] iwl3945 0000:03:00.0:
0001713762^I0x0000000e^I1106
Jan 26 21:29:08 rainbow kernel: [   28.814760] iwl3945 0000:03:00.0:
0001713767^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.814760] iwl3945 0000:03:00.0:
0001713771^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.814760] iwl3945 0000:03:00.0:
0001713775^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.814760] iwl3945 0000:03:00.0:
0001713779^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.814760] iwl3945 0000:03:00.0:
0001713784^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.814760] iwl3945 0000:03:00.0:
0001713788^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.814760] iwl3945 0000:03:00.0:
0001713792^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.814760] iwl3945 0000:03:00.0:
0001713797^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.814760] iwl3945 0000:03:00.0:
0001713801^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.814760] iwl3945 0000:03:00.0:
0001713805^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.814760] iwl3945 0000:03:00.0:
0001713809^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.814760] iwl3945 0000:03:00.0:
0001713814^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.814760] iwl3945 0000:03:00.0:
0001713818^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.814760] iwl3945 0000:03:00.0:
0001713822^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.814760] iwl3945 0000:03:00.0:
0001713826^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.814760] iwl3945 0000:03:00.0:
0001713831^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.814760] iwl3945 0000:03:00.0:
0001713835^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.814760] iwl3945 0000:03:00.0:
0001713839^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.814760] iwl3945 0000:03:00.0:
0001713844^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.814760] iwl3945 0000:03:00.0:
0001713848^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.814760] iwl3945 0000:03:00.0:
0001713852^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.814760] iwl3945 0000:03:00.0:
0001713856^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.814760] iwl3945 0000:03:00.0:
0001713861^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.814760] iwl3945 0000:03:00.0:
0001713865^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.815906] iwl3945 0000:03:00.0:
0001713869^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.815906] iwl3945 0000:03:00.0:
0001713873^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.815906] iwl3945 0000:03:00.0:
0001713878^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.815906] iwl3945 0000:03:00.0:
0001713882^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.815906] iwl3945 0000:03:00.0:
0001713886^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.815906] iwl3945 0000:03:00.0:
0001713891^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.816140] iwl3945 0000:03:00.0:
0001713895^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.816140] iwl3945 0000:03:00.0:
0001713899^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.816140] iwl3945 0000:03:00.0:
0001713903^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.816140] iwl3945 0000:03:00.0:
0001713908^I0x00000001^I1106
Jan 26 21:29:08 rainbow kernel: [   28.816140] iwl3945 0000:03:00.0:
0001713908^I0x0000000f^I1106
Jan 26 21:29:08 rainbow kernel: [   28.816140] iwl3945 0000:03:00.0:
0001713910^I0x00000370^I1105
Jan 26 21:29:08 rainbow kernel: [   28.816140] iwl3945 0000:03:00.0:
0001713913^I0x00000912^I1115
Jan 26 21:29:08 rainbow kernel: [   28.816140] iwl3945 0000:03:00.0:
0001713919^I0x000000a5^I0464
Jan 26 21:29:08 rainbow kernel: [   28.816140] iwl3945 0000:03:00.0:
0001713920^I0x000000a5^I0462
Jan 26 21:29:08 rainbow kernel: [   28.816140] iwl3945 0000:03:00.0:
0001769323^I0x000000d9^I0106
Jan 26 21:29:08 rainbow kernel: [   28.816140] iwl3945 0000:03:00.0:
0001769325^I0x00000000^I0302
Jan 26 21:29:08 rainbow kernel: [   28.816140] iwl3945 0000:03:00.0:
0001769333^I0x00008000^I0350
Jan 26 21:29:08 rainbow kernel: [   28.816140] iwl3945 0000:03:00.0:
0001769428^I0x000000d9^I0106
Jan 26 21:29:08 rainbow kernel: [   28.816140] iwl3945 0000:03:00.0:
0001769429^I0x00000000^I0302
Jan 26 21:29:08 rainbow kernel: [   28.816140] iwl3945 0000:03:00.0:
0001769438^I0x00008000^I0350
Jan 26 21:29:08 rainbow kernel: [   28.816140] iwl3945 0000:03:00.0:
0001769567^I0x000000d9^I0106
Jan 26 21:29:08 rainbow kernel: [   28.816140] iwl3945 0000:03:00.0:
0001769569^I0x00000000^I0302
Jan 26 21:29:08 rainbow kernel: [   28.816140] iwl3945 0000:03:00.0:
0001769610^I0x00000001^I0353
Jan 26 21:29:08 rainbow kernel: [   28.816140] iwl3945 0000:03:00.0:
0001769670^I0x000000d9^I0106
Jan 26 21:29:08 rainbow kernel: [   28.816140] iwl3945 0000:03:00.0:
0001769672^I0x00000000^I0302
Jan 26 21:29:08 rainbow kernel: [   28.816140] iwl3945 0000:03:00.0:
0001769680^I0x00008000^I0350
Jan 26 21:29:08 rainbow kernel: [   28.816140] iwl3945 0000:03:00.0:
0001826603^I0x000001b8^I1005
Jan 26 21:29:08 rainbow kernel: [   28.816140] iwl3945 0000:03:00.0:
0001826607^I0x00000101^I1108
Jan 26 21:29:08 rainbow kernel: [   28.816140] iwl3945 0000:03:00.0:
0001826609^I0x0000000e^I1101
Jan 26 21:29:08 rainbow kernel: [   28.816140] iwl3945 0000:03:00.0:
0001826610^I0x00680034^I1102
Jan 26 21:29:08 rainbow kernel: [   28.816140] iwl3945 0000:03:00.0:
0001826611^I0x00670035^I1102
Jan 26 21:29:08 rainbow kernel: [   28.817189] iwl3945 0000:03:00.0:
0001826613^I0x007e0036^I1102
Jan 26 21:29:08 rainbow kernel: [   28.817189] iwl3945 0000:03:00.0:
0001826614^I0x007c0037^I1102
Jan 26 21:29:08 rainbow kernel: [   28.817189] iwl3945 0000:03:00.0:
0001826616^I0x00000038^I1102
Jan 26 21:29:08 rainbow kernel: [   28.817189] iwl3945 0000:03:00.0:
0001826617^I0x00840052^I1102
Jan 26 21:29:08 rainbow kernel: [   28.817189] iwl3945 0000:03:00.0:
0001826619^I0x00840053^I1102
Jan 26 21:29:08 rainbow kernel: [   28.817189] iwl3945 0000:03:00.0:
0001826621^I0x007e0054^I1102
Jan 26 21:29:08 rainbow kernel: [   28.817189] iwl3945 0000:03:00.0:
0001826622^I0x007d0055^I1102
Jan 26 21:29:08 rainbow kernel: [   28.817189] iwl3945 0000:03:00.0:
0001826624^I0x00000056^I1102
Jan 26 21:29:08 rainbow kernel: [   28.817189] iwl3945 0000:03:00.0:
0001826625^I0x00007050^I1102
Jan 26 21:29:08 rainbow kernel: [   28.817189] iwl3945 0000:03:00.0:
0001826627^I0x00017051^I1102
Jan 26 21:29:08 rainbow kernel: [   28.817189] iwl3945 0000:03:00.0:
0001826629^I0x00008204^I1102
Jan 26 21:29:08 rainbow kernel: [   28.817189] iwl3945 0000:03:00.0:
0001826631^I0x00018205^I1102
Jan 26 21:29:08 rainbow kernel: [   28.817189] iwl3945 0000:03:00.0:
0001826634^I0x00000001^I1101
Jan 26 21:29:08 rainbow kernel: [   28.817189] iwl3945 0000:03:00.0:
0001826635^I0x008b0063^I1102
Jan 26 21:29:08 rainbow kernel: [   28.817189] iwl3945 0000:03:00.0:
0001826637^I0x0000001d^I1104
Jan 26 21:29:08 rainbow kernel: [   28.817189] iwl3945 0000:03:00.0:
0001826639^I0x00000002^I1101
Jan 26 21:29:08 rainbow kernel: [   28.817189] iwl3945 0000:03:00.0:
0001826640^I0x0083903f^I1102
Jan 26 21:29:08 rainbow kernel: [   28.817189] iwl3945 0000:03:00.0:
0001826642^I0x0001d213^I1102
Jan 26 21:29:08 rainbow kernel: [   28.817189] iwl3945 0000:03:00.0:
0001826645^I0x00000002^I1101
Jan 26 21:29:08 rainbow kernel: [   28.817189] iwl3945 0000:03:00.0:
0001826646^I0x0003d206^I1102
Jan 26 21:29:08 rainbow kernel: [   28.817189] iwl3945 0000:03:00.0:
0001826648^I0x0083903e^I1102
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001826651^I0x00000059^I1101
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001826752^I0x00000013^I1101
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001826769^I0x00000004^I1107
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827285^I0x11003e2b^I1110
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827297^I0xffffff33^I0454
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827298^I0x00000000^I0472
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827309^I0x000000a5^I0464
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827312^I0xffffff33^I1111
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827338^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827339^I0x0000000e^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827343^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827348^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827352^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827356^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827361^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827365^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827369^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827373^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827378^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827382^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827386^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827390^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827395^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827399^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827403^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827408^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827412^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827416^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827420^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827425^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827429^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827433^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827438^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827442^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827446^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827450^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827455^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827459^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827463^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827467^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827472^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827476^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827480^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827485^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827489^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827493^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827497^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827502^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827506^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827510^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827515^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827519^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827523^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827527^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827532^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827536^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827540^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827544^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827549^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827553^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827557^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827562^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827566^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827570^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827574^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827579^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827583^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827587^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827591^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827596^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827600^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827604^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827609^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827613^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827617^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827621^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827626^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827630^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827634^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827638^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827643^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827647^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827651^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827656^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827660^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827664^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827668^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827673^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827677^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827681^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827686^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827690^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827694^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827698^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827703^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827707^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827711^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827715^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827720^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827724^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827728^I0x00000001^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827729^I0x0000000f^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827731^I0x00000465^I1105
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827734^I0x00000912^I1115
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827738^I0x00000001^I0463
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001827739^I0x00000001^I0462
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001828111^I0x04170097^I0401
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001828114^I0x00000001^I0451
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001828134^I0x00000000^I0451
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001828848^I0x04180010^I0401
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001828904^I0x00000175^I1005
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001828905^I0x00000000^I1001
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0001828906^I0x00000000^I1002
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000012^I0x000001b8^I1005
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000024^I0x0000010b^I1108
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000026^I0x0000000e^I1101
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000027^I0x00680034^I1102
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000028^I0x00670035^I1102
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000030^I0x007e0036^I1102
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000031^I0x007c0037^I1102
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000033^I0x00000038^I1102
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000034^I0x00840052^I1102
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000036^I0x00840053^I1102
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000037^I0x007e0054^I1102
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000039^I0x007d0055^I1102
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000040^I0x00000056^I1102
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000042^I0x00007050^I1102
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000044^I0x00017051^I1102
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000046^I0x00008204^I1102
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000048^I0x00018205^I1102
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000051^I0x00000001^I1101
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000052^I0x008b0063^I1102
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000054^I0x0000001c^I1104
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000056^I0x00000002^I1101
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000056^I0x0083903f^I1102
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000058^I0x0001d213^I1102
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000062^I0x00000002^I1101
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000062^I0x0003d206^I1102
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000064^I0x0083903e^I1102
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000068^I0x00000059^I1101
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000168^I0x00000013^I1101
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000186^I0x00000005^I1107
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000754^I0x00018d0f^I1110
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000765^I0xffffff33^I0454
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000766^I0x00000000^I0472
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000776^I0x00000001^I0463
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000779^I0xffffff33^I1111
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000784^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000784^I0x0000000e^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000789^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000793^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000797^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000801^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000806^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000810^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000814^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000819^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000823^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000827^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000831^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000836^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000840^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000844^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000848^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000853^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000857^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000861^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000866^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000870^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000874^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000878^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000883^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000887^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000891^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000895^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000900^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000904^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000908^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000913^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000917^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000921^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000925^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000930^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000934^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000938^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000943^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000947^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000951^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000955^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000960^I0x00000000^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000964^I0x00000001^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000965^I0x0000000f^I1106
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000966^I0x000003b0^I1105
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000970^I0x00000912^I1115
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000974^I0x0000000b^I0463
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000975^I0x0000000b^I0462
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000996^I0x000000aa^I0103
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000001260^I0x04190097^I0401
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000001263^I0x0000000b^I0451
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000001283^I0x00000000^I0451
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000001427^I0x041a0018^I0401
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000001585^I0x041b0047^I0401
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000001731^I0x041c0047^I0401
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000001908^I0x041d0010^I0401
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000001965^I0x00000175^I1005
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000001966^I0x00000000^I1001
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000001967^I0x00000000^I1002
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000012^I0x000001b8^I1005
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000040^I0x000000aa^I0103
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000320^I0x041e0097^I0401
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000322^I0x0000000b^I0451
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000342^I0x00000000^I0451
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000482^I0x041f0018^I0401
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000637^I0x04200047^I0401
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000781^I0x04210047^I0401
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000001000^I0x04220010^I0401
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000001057^I0x00000175^I1005
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000001058^I0x00000000^I1001
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000001059^I0x00000000^I1002
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000012^I0x000001b8^I1005
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000040^I0x000000aa^I0103
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000305^I0x04230097^I0401
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000307^I0x0000000b^I0451
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000327^I0x00000000^I0451
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000466^I0x04240018^I0401
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000610^I0x04250047^I0401
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000753^I0x04260047^I0401
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000941^I0x0000000b^I0463
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000944^I0x00010087^I0250
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000000950^I0x0000001c^I0218
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000200922^I0x00000002^I0123
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
0000200925^I0x00000100^I0125
Jan 26 21:29:08 rainbow kernel: [   28.817932] ieee80211 phy0: I
iwl3945_print_rx_config_cmd RX CONFIG:
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl data: 00000000: 00
1f 3c 20 a1 6e 00 00 00 30 bd c0 90 24 00 00  ..< .n...0...$..
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl data: 00000010: 00
00 00 00 00 00 00 00 03 00 00 00 15 03 00 00  ................
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl data: 00000020: 05
80 00 00 04 00 00 00 0b 00 00 00              ............
Jan 26 21:29:08 rainbow kernel: [   28.817932] ieee80211 phy0: I
iwl3945_print_rx_config_cmd u16 channel: 0xb
Jan 26 21:29:08 rainbow kernel: [   28.817932] ieee80211 phy0: I
iwl3945_print_rx_config_cmd u32 flags: 0x00008005
Jan 26 21:29:08 rainbow kernel: [   28.817932] ieee80211 phy0: I
iwl3945_print_rx_config_cmd u32 filter_flags: 0x00000004
Jan 26 21:29:08 rainbow kernel: [   28.817932] ieee80211 phy0: I
iwl3945_print_rx_config_cmd u8 dev_type: 0x3
Jan 26 21:29:08 rainbow kernel: [   28.817932] ieee80211 phy0: I
iwl3945_print_rx_config_cmd u8 ofdm_basic_rates: 0x15
Jan 26 21:29:08 rainbow kernel: [   28.817932] ieee80211 phy0: I
iwl3945_print_rx_config_cmd u8 cck_basic_rates: 0x03
Jan 26 21:29:08 rainbow kernel: [   28.817932] ieee80211 phy0: I
iwl3945_print_rx_config_cmd u8[6] node_addr: 00:1f:3c:20:a1:6e
Jan 26 21:29:08 rainbow kernel: [   28.817932] ieee80211 phy0: I
iwl3945_print_rx_config_cmd u8[6] bssid_addr: 00:30:bd:c0:90:24
Jan 26 21:29:08 rainbow kernel: [   28.817932] ieee80211 phy0: I
iwl3945_print_rx_config_cmd u16 assoc_id: 0x0
Jan 26 21:29:08 rainbow kernel: [   28.817932] ieee80211 phy0: I
iwl3945_irq_handle_error Restarting adapter due to uCode error.
Jan 26 21:29:08 rainbow kernel: [   28.817932] ieee80211 phy0: I
iwl3945_rx_handle r = 166, i = 165, REPLY_ERROR, 0x02
Jan 26 21:29:08 rainbow kernel: [   28.817932] iwl3945 0000:03:00.0:
Error Reply type 0x00000005 cmd REPLY_PHY_CALIBRATION_CMD (0xB0) seq
0x013A ser 0x004E0000
Jan 26 21:29:08 rainbow kernel: [   28.837164] ieee80211 phy0: U
__iwl3945_down iwl3945 is going down
Jan 26 21:29:08 rainbow kernel: [   28.838999] ieee80211 phy0: U
iwl3945_apm_stop_master stop master
Jan 26 21:29:08 rainbow kernel: [   28.839714] ieee80211 phy0: U
iwl3945_apm_stop_master stop master
Jan 26 21:29:08 rainbow kernel: [   28.839828] ieee80211 phy0: U
iwl3945_clear_free_frames 0 frames on pre-allocated heap on clear.
Jan 26 21:29:08 rainbow kernel: [   28.839851] ieee80211 phy0: U
iwl3945_power_init_handle Initialize power
Jan 26 21:29:08 rainbow kernel: [   28.839868] ieee80211 phy0: U
iwl3945_power_init_handle adjust power command flags
Jan 26 21:29:08 rainbow kernel: [   28.839970] ieee80211 phy0: U
iwl3945_hw_nic_init HW Revision ID = 0x2
Jan 26 21:29:08 rainbow kernel: [   28.840043] ieee80211 phy0: U
iwl3945_nic_config 3945 RADIO-MM type
Jan 26 21:29:08 rainbow kernel: [   28.840058] ieee80211 phy0: U
iwl3945_nic_config SKU OP mode is basic
Jan 26 21:29:08 rainbow kernel: [   28.840067] ieee80211 phy0: U
iwl3945_nic_config 3945ABG revision is 0xF1
Jan 26 21:29:08 rainbow kernel: [   28.840080] ieee80211 phy0: U
iwl3945_nic_config Card M type B version is 0x3
Jan 26 21:29:08 rainbow kernel: [   28.843266] ieee80211 phy0: U
iwl3945_load_bsm Begin load bsm
Jan 26 21:29:08 rainbow kernel: [   28.844543] ieee80211 phy0: U
iwl3945_verify_bsm Begin verify bsm
Jan 26 21:29:08 rainbow kernel: [   28.846722] ieee80211 phy0: U
iwl3945_verify_bsm BSM bootstrap uCode image OK
Jan 26 21:29:08 rainbow kernel: [   28.846782] ieee80211 phy0: U
iwl3945_load_bsm BSM write complete, poll 1 iterations
Jan 26 21:29:08 rainbow kernel: [   28.846803] ieee80211 phy0: U
__iwl3945_up iwl3945 is coming up
Jan 26 21:29:08 rainbow kernel: [   28.858240] ieee80211 phy0: I
iwl3945_rx_handle r = 1, i = 0, REPLY_ALIVE, 0x01
Jan 26 21:29:08 rainbow kernel: [   28.858258] ieee80211 phy0: I
iwl3945_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x9
Jan 26 21:29:08 rainbow kernel: [   28.858267] ieee80211 phy0: I
iwl3945_rx_reply_alive Initialization Alive received.
Jan 26 21:29:08 rainbow kernel: [   28.865031] ieee80211 phy0: U
iwl3945_verify_inst_sparse ucode inst image size is 900
Jan 26 21:29:08 rainbow kernel: [   28.865133] ieee80211 phy0: U
iwl3945_verify_inst_sparse ucode inst image size is 2672
Jan 26 21:29:08 rainbow kernel: [   28.865420] ieee80211 phy0: U
iwl3945_verify_ucode Initialize uCode is good in inst SRAM
Jan 26 21:29:08 rainbow kernel: [   28.865428] ieee80211 phy0: U
iwl3945_init_alive_start Initialization Alive received.
Jan 26 21:29:08 rainbow kernel: [   28.865478] ieee80211 phy0: U
iwl3945_set_ucode_ptrs Runtime uCode pointers are set.
Jan 26 21:29:08 rainbow kernel: [   28.869841] ieee80211 phy0: I
iwl3945_rx_handle r = 2, i = 1, REPLY_ALIVE, 0x01
Jan 26 21:29:08 rainbow kernel: [   28.869854] ieee80211 phy0: I
iwl3945_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x0
Jan 26 21:29:08 rainbow kernel: [   28.869862] ieee80211 phy0: I
iwl3945_rx_reply_alive Runtime Alive received.
Jan 26 21:29:08 rainbow kernel: [   28.869910] ieee80211 phy0: I
iwl3945_disable_events Selected uCode log events may be disabled
Jan 26 21:29:08 rainbow kernel: [   28.869918] ieee80211 phy0: I
iwl3945_disable_events   by writing "1"s into disable bitmap
Jan 26 21:29:08 rainbow kernel: [   28.869926] ieee80211 phy0: I
iwl3945_disable_events   in SRAM at 0x8022c8, size 47 u32s
Jan 26 21:29:08 rainbow kernel: [   28.877028] ieee80211 phy0: U
iwl3945_alive_start Runtime Alive received.
Jan 26 21:29:08 rainbow kernel: [   28.877042] ieee80211 phy0: U
iwl3945_verify_inst_sparse ucode inst image size is 900
Jan 26 21:29:08 rainbow kernel: [   28.877129] ieee80211 phy0: U
iwl3945_verify_inst_sparse ucode inst image size is 2672
Jan 26 21:29:08 rainbow kernel: [   28.877215] ieee80211 phy0: U
iwl3945_verify_inst_sparse ucode inst image size is 80684
Jan 26 21:29:08 rainbow kernel: [   28.884973] ieee80211 phy0: U
iwl3945_verify_ucode Runtime uCode is good in inst SRAM
Jan 26 21:29:08 rainbow kernel: [   28.885028] ieee80211 phy0: U
iwl3945_alive_start RFKILL status: 0x1
Jan 26 21:29:08 rainbow kernel: [   28.885059] ieee80211 phy0: U
iwl3945_update_power_cmd Flags value = 0x00000008
Jan 26 21:29:08 rainbow kernel: [   28.885067] ieee80211 phy0: U
iwl3945_update_power_cmd Tx timeout = 0
Jan 26 21:29:08 rainbow kernel: [   28.885073] ieee80211 phy0: U
iwl3945_update_power_cmd Rx timeout = 0
Jan 26 21:29:08 rainbow kernel: [   28.885081] ieee80211 phy0: U
iwl3945_update_power_cmd Sleep interval vector = { 0 , 0 , 0 , 0 , 0 }
Jan 26 21:29:08 rainbow kernel: [   28.885097] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command POWER_TABLE_CMD (#77), seq: 0x0400,
36 bytes at 0[0]:4
Jan 26 21:29:08 rainbow kernel: [   28.885213] ieee80211 phy0: I
iwl3945_rx_handle r 3 i 2 No handler needed for POWER_TABLE_CMD, 0x77
Jan 26 21:29:08 rainbow kernel: [   28.885306] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_BT_CONFIG (#9b), seq: 0x0401,
16 bytes at 1[1]:4
Jan 26 21:29:08 rainbow kernel: [   28.885412] ieee80211 phy0: I
iwl3945_rx_handle r 4 i 3 No handler needed for REPLY_BT_CONFIG, 0x9b
Jan 26 21:29:08 rainbow kernel: [   28.885434] ieee80211 phy0: U
iwl3945_commit_rxon Sending RXON
Jan 26 21:29:08 rainbow kernel: [   28.885436] * without RXON_FILTER_ASSOC_MSK
Jan 26 21:29:08 rainbow kernel: [   28.885438] * channel = 11
Jan 26 21:29:08 rainbow kernel: [   28.885439] * bssid = 00:00:00:00:00:00
Jan 26 21:29:08 rainbow kernel: [   28.885457] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x0402, 48
bytes at 2[2]:4
Jan 26 21:29:08 rainbow kernel: [   28.886588] ieee80211 phy0: I
iwl3945_rx_handle r 5 i 4 No handler needed for REPLY_RXON, 0x10
Jan 26 21:29:08 rainbow kernel: [   28.886610] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 102 rate code 0x0d
Jan 26 21:29:08 rainbow kernel: [   28.886621] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 102 rate code 0x0f
Jan 26 21:29:08 rainbow kernel: [   28.886629] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 102 rate code 0x05
Jan 26 21:29:08 rainbow kernel: [   28.886637] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 102 rate code 0x07
Jan 26 21:29:08 rainbow kernel: [   28.886645] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 102 rate code 0x09
Jan 26 21:29:08 rainbow kernel: [   28.886653] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 102 rate code 0x0b
Jan 26 21:29:08 rainbow kernel: [   28.886661] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 102 rate code 0x01
Jan 26 21:29:08 rainbow kernel: [   28.886668] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 102 rate code 0x03
Jan 26 21:29:08 rainbow kernel: [   28.886677] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 107 rate code 0x0a
Jan 26 21:29:08 rainbow kernel: [   28.886685] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 107 rate code 0x14
Jan 26 21:29:08 rainbow kernel: [   28.886693] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 107 rate code 0x37
Jan 26 21:29:08 rainbow kernel: [   28.886701] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 107 rate code 0x6e
Jan 26 21:29:08 rainbow kernel: [   28.886713] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq:
0x0403, 56 bytes at 3[3]:4
Jan 26 21:29:08 rainbow kernel: [   28.886813] ieee80211 phy0: I
iwl3945_rx_handle r 6 i 5 No handler needed for
REPLY_TX_PWR_TABLE_CMD, 0x97
Jan 26 21:29:08 rainbow kernel: [   28.886843] ieee80211 phy0: U
iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
Jan 26 21:29:08 rainbow kernel: [   28.886856] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0404, 68
bytes at 4[4]:4
Jan 26 21:29:08 rainbow kernel: [   28.886939] ieee80211 phy0: I
iwl3945_rx_handle r = 7, i = 6, REPLY_ADD_STA, 0x18
Jan 26 21:29:08 rainbow kernel: [   28.886961] ieee80211 phy0: U
iwl3945_send_add_station REPLY_ADD_STA PASSED
Jan 26 21:29:08 rainbow kernel: [   28.886978] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0405,
56 bytes at 5[5]:4
Jan 26 21:29:08 rainbow kernel: [   28.887086] ieee80211 phy0: I
iwl3945_rx_handle r 8 i 7 No handler needed for REPLY_RATE_SCALE, 0x47
Jan 26 21:29:08 rainbow kernel: [   28.887105] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0406,
56 bytes at 6[6]:4
Jan 26 21:29:08 rainbow kernel: [   28.887216] ieee80211 phy0: I
iwl3945_rx_handle r 9 i 8 No handler needed for REPLY_RATE_SCALE, 0x47
Jan 26 21:29:08 rainbow kernel: [   28.887239] ieee80211 phy0: U
iwl3945_hw_reg_txpower_get_temperature Temperature: 51
Jan 26 21:29:08 rainbow kernel: [   28.887248] ieee80211 phy0: U
is_temp_calib_needed Getting warmer, delta 10,
Jan 26 21:29:08 rainbow kernel: [   28.887255] ieee80211 phy0: U
is_temp_calib_needed Timed thermal calib needed
Jan 26 21:29:08 rainbow kernel: [   28.887275] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x0d
Jan 26 21:29:08 rainbow kernel: [   28.887283] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x0f
Jan 26 21:29:08 rainbow kernel: [   28.887291] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x05
Jan 26 21:29:08 rainbow kernel: [   28.887299] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x07
Jan 26 21:29:08 rainbow kernel: [   28.887306] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x09
Jan 26 21:29:08 rainbow kernel: [   28.887315] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x0b
Jan 26 21:29:08 rainbow kernel: [   28.887322] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x01
Jan 26 21:29:08 rainbow kernel: [   28.887331] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x03
Jan 26 21:29:08 rainbow kernel: [   28.887356] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 119 rate code 0x0a
Jan 26 21:29:08 rainbow kernel: [   28.887364] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 119 rate code 0x14
Jan 26 21:29:08 rainbow kernel: [   28.887372] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 119 rate code 0x37
Jan 26 21:29:08 rainbow kernel: [   28.887381] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 119 rate code 0x6e
Jan 26 21:29:08 rainbow kernel: [   28.887392] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq:
0x0407, 56 bytes at 7[7]:4
Jan 26 21:29:08 rainbow kernel: [   28.887531] ieee80211 phy0: I
iwl3945_rx_handle r 10 i 9 No handler needed for
REPLY_TX_PWR_TABLE_CMD, 0x97
Jan 26 21:29:08 rainbow kernel: [   28.887638] Registered led device:
iwl-phy0:radio
Jan 26 21:29:08 rainbow kernel: [   28.887647] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0408, 12
bytes at 8[8]:4
Jan 26 21:29:08 rainbow kernel: [   28.887693] Registered led device:
iwl-phy0:assoc
Jan 26 21:29:08 rainbow kernel: [   28.887730] ieee80211 phy0: I
iwl3945_rx_handle r 11 i 10 No handler needed for REPLY_LEDS_CMD, 0x48
Jan 26 21:29:08 rainbow kernel: [   28.887732] Registered led device:
iwl-phy0:RX
Jan 26 21:29:08 rainbow kernel: [   28.887766] Registered led device:
iwl-phy0:TX
Jan 26 21:29:08 rainbow kernel: [   28.887770] ieee80211 phy0: U
iwl3945_alive_start ALIVE processing complete.
Jan 26 21:29:08 rainbow kernel: [   28.909018] ieee80211 phy0: I
iwl3945_rx_handle r = 12, i = 11, REPLY_3945_RX, 0x1b
Jan 26 21:29:08 rainbow kernel: [   28.924395] ieee80211 phy0: I
iwl3945_rx_handle r = 13, i = 12, REPLY_3945_RX, 0x1b
Jan 26 21:29:08 rainbow kernel: [   28.932302] ieee80211 phy0: I
iwl3945_rx_handle r = 14, i = 13, REPLY_3945_RX, 0x1b
Jan 26 21:29:08 rainbow kernel: [   28.936164] ieee80211 phy0: I
iwl3945_rx_handle r = 15, i = 14, REPLY_3945_RX, 0x1b
Jan 26 21:29:08 rainbow kernel: [   28.938383] ieee80211 phy0: I
iwl3945_rx_handle r = 16, i = 15, REPLY_3945_RX, 0x1b
Jan 26 21:29:08 rainbow kernel: [   28.943181] ieee80211 phy0: I
iwl3945_rx_handle r = 17, i = 16, REPLY_3945_RX, 0x1b
Jan 26 21:29:08 rainbow kernel: [   28.960632] ieee80211 phy0: I
iwl3945_rx_handle r = 18, i = 17, REPLY_3945_RX, 0x1b
Jan 26 21:29:08 rainbow kernel: [   28.974198] ieee80211 phy0: I
iwl3945_rx_handle r = 19, i = 18, REPLY_3945_RX, 0x1b
Jan 26 21:29:08 rainbow kernel: [   29.005025] wlan0: authenticate
with AP 00:30:bd:c0:90:24
Jan 26 21:29:08 rainbow kernel: [   29.005039] ieee80211 phy0: I
iwl3945_mac_tx enter
Jan 26 21:29:08 rainbow kernel: [   29.005049] ieee80211 phy0: I
iwl3945_mac_tx leave
Jan 26 21:29:08 rainbow kernel: [   29.005131] ieee80211 phy0: I
iwl3945_rx_handle r = 20, i = 19, REPLY_TX, 0x1c
Jan 26 21:29:09 rainbow kernel: [   29.205097] wlan0: authentication
with AP 00:30:bd:c0:90:24 timed out
Jan 26 21:29:10 rainbow kernel: [   30.244018] eth0: no IPv6 routers present
Jan 26 21:29:26 rainbow kernel: [   46.990640] ieee80211 phy0: U
iwl3945_mac_hw_scan enter
Jan 26 21:29:26 rainbow kernel: [   46.990661] ieee80211 phy0: U
iwl3945_scan_initiate Starting scan...
Jan 26 21:29:26 rainbow kernel: [   46.990673] ieee80211 phy0: U
iwl3945_mac_hw_scan leave
Jan 26 21:29:26 rainbow kernel: [   46.990687] ieee80211 phy0: U
iwl3945_bg_request_scan Kicking off one indirect scan.
Jan 26 21:29:26 rainbow kernel: [   46.990699] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 1 [ACTIVE 39]
Jan 26 21:29:26 rainbow kernel: [   46.990707] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 2 [ACTIVE 39]
Jan 26 21:29:26 rainbow kernel: [   46.990715] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 3 [ACTIVE 39]
Jan 26 21:29:26 rainbow kernel: [   46.990722] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 4 [ACTIVE 39]
Jan 26 21:29:26 rainbow kernel: [   46.990730] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 5 [ACTIVE 39]
Jan 26 21:29:26 rainbow kernel: [   46.990737] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 6 [ACTIVE 39]
Jan 26 21:29:26 rainbow kernel: [   46.990745] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 7 [ACTIVE 39]
Jan 26 21:29:26 rainbow kernel: [   46.990754] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 8 [ACTIVE 39]
Jan 26 21:29:26 rainbow kernel: [   46.990762] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 9 [ACTIVE 39]
Jan 26 21:29:26 rainbow kernel: [   46.990788] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 10 [ACTIVE 39]
Jan 26 21:29:26 rainbow kernel: [   46.990796] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 11 [ACTIVE 39]
Jan 26 21:29:26 rainbow kernel: [   46.990804] ieee80211 phy0: U
iwl3945_get_channels_for_scan total channels to scan 11
Jan 26 21:29:26 rainbow kernel: [   46.990822] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x4409,
351 bytes at 9[32]:4
Jan 26 21:29:27 rainbow kernel: [   47.488104] iwl3945 0000:03:00.0:
Error sending REPLY_SCAN_CMD: time out after 500ms.
Jan 26 21:29:27 rainbow kernel: [   47.488127] ieee80211 phy0: U
iwl3945_bg_scan_completed SCAN complete scan
Jan 26 21:29:27 rainbow kernel: [   47.488154] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x0d
Jan 26 21:29:27 rainbow kernel: [   47.488163] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x0f
Jan 26 21:29:27 rainbow kernel: [   47.488170] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x05
Jan 26 21:29:27 rainbow kernel: [   47.488179] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x07
Jan 26 21:29:27 rainbow kernel: [   47.488187] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x09
Jan 26 21:29:27 rainbow kernel: [   47.488195] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x0b
Jan 26 21:29:27 rainbow kernel: [   47.488203] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x01
Jan 26 21:29:27 rainbow kernel: [   47.488211] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x03
Jan 26 21:29:27 rainbow kernel: [   47.488220] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 119 rate code 0x0a
Jan 26 21:29:27 rainbow kernel: [   47.488229] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 119 rate code 0x14
Jan 26 21:29:27 rainbow kernel: [   47.488238] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 119 rate code 0x37
Jan 26 21:29:27 rainbow kernel: [   47.488247] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 119 rate code 0x6e
Jan 26 21:29:27 rainbow kernel: [   47.488263] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq:
0x040A, 56 bytes at 10[10]:4
Jan 26 21:29:27 rainbow kernel: [   47.988109] iwl3945 0000:03:00.0:
Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms.
Jan 26 21:29:42 rainbow kernel: [   62.652580] ieee80211 phy0: U
iwl3945_mac_hw_scan enter
Jan 26 21:29:42 rainbow kernel: [   62.652607] ieee80211 phy0: U
iwl3945_mac_hw_scan direct scan for WLAN [4]
Jan 26 21:29:42 rainbow kernel: [   62.652610]  <3>ieee80211 phy0: U
iwl3945_scan_initiate Starting scan...
Jan 26 21:29:42 rainbow kernel: [   62.652632] ieee80211 phy0: U
iwl3945_mac_hw_scan leave
Jan 26 21:29:42 rainbow kernel: [   62.652648] ieee80211 phy0: U
iwl3945_bg_request_scan Kicking off one direct scan for 'WLAN'
Jan 26 21:29:42 rainbow kernel: [   62.652661] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 1 [ACTIVE 42]
Jan 26 21:29:42 rainbow kernel: [   62.652670] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 2 [ACTIVE 42]
Jan 26 21:29:42 rainbow kernel: [   62.652679] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 3 [ACTIVE 42]
Jan 26 21:29:42 rainbow kernel: [   62.652687] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 4 [ACTIVE 42]
Jan 26 21:29:42 rainbow kernel: [   62.652695] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 5 [ACTIVE 42]
Jan 26 21:29:42 rainbow kernel: [   62.652703] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 6 [ACTIVE 42]
Jan 26 21:29:42 rainbow kernel: [   62.652711] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 7 [ACTIVE 42]
Jan 26 21:29:42 rainbow kernel: [   62.652721] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 8 [ACTIVE 42]
Jan 26 21:29:42 rainbow kernel: [   62.652728] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 9 [ACTIVE 42]
Jan 26 21:29:42 rainbow kernel: [   62.652737] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 10 [ACTIVE 42]
Jan 26 21:29:42 rainbow kernel: [   62.652745] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 11 [ACTIVE 42]
Jan 26 21:29:42 rainbow kernel: [   62.652753] ieee80211 phy0: U
iwl3945_get_channels_for_scan total channels to scan 11
Jan 26 21:29:42 rainbow kernel: [   62.652772] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x440B,
351 bytes at 11[32]:4
Jan 26 21:29:43 rainbow kernel: [   63.149042] iwl3945 0000:03:00.0:
Error sending REPLY_SCAN_CMD: time out after 500ms.
Jan 26 21:29:43 rainbow kernel: [   63.149071] ieee80211 phy0: U
iwl3945_bg_scan_completed SCAN complete scan
Jan 26 21:29:43 rainbow kernel: [   63.149115] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x0d
Jan 26 21:29:43 rainbow kernel: [   63.149124] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x0f
Jan 26 21:29:43 rainbow kernel: [   63.149132] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x05
Jan 26 21:29:43 rainbow kernel: [   63.149140] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x07
Jan 26 21:29:43 rainbow kernel: [   63.149150] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x09
Jan 26 21:29:43 rainbow kernel: [   63.149159] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x0b
Jan 26 21:29:43 rainbow kernel: [   63.149167] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x01
Jan 26 21:29:43 rainbow kernel: [   63.149175] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x03
Jan 26 21:29:43 rainbow kernel: [   63.149183] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 119 rate code 0x0a
Jan 26 21:29:43 rainbow kernel: [   63.149192] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 119 rate code 0x14
Jan 26 21:29:43 rainbow kernel: [   63.149200] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 119 rate code 0x37
Jan 26 21:29:43 rainbow kernel: [   63.149208] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 119 rate code 0x6e
Jan 26 21:29:43 rainbow kernel: [   63.149224] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq:
0x040C, 56 bytes at 12[12]:4
Jan 26 21:29:43 rainbow kernel: [   63.649097] iwl3945 0000:03:00.0:
Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms.
Jan 26 21:29:48 rainbow kernel: [   68.150627] ieee80211 phy0: U
iwl3945_mac_hw_scan enter
Jan 26 21:29:48 rainbow kernel: [   68.150653] ieee80211 phy0: U
iwl3945_scan_initiate Starting scan...
Jan 26 21:29:48 rainbow kernel: [   68.150665] ieee80211 phy0: U
iwl3945_mac_hw_scan leave
Jan 26 21:29:48 rainbow kernel: [   68.150680] ieee80211 phy0: U
iwl3945_bg_request_scan Kicking off one indirect scan.
Jan 26 21:29:48 rainbow kernel: [   68.150693] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 1 [ACTIVE 39]
Jan 26 21:29:48 rainbow kernel: [   68.150702] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 2 [ACTIVE 39]
Jan 26 21:29:48 rainbow kernel: [   68.150710] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 3 [ACTIVE 39]
Jan 26 21:29:48 rainbow kernel: [   68.150718] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 4 [ACTIVE 39]
Jan 26 21:29:48 rainbow kernel: [   68.150726] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 5 [ACTIVE 39]
Jan 26 21:29:48 rainbow kernel: [   68.150734] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 6 [ACTIVE 39]
Jan 26 21:29:48 rainbow kernel: [   68.150743] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 7 [ACTIVE 39]
Jan 26 21:29:48 rainbow kernel: [   68.150751] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 8 [ACTIVE 39]
Jan 26 21:29:48 rainbow kernel: [   68.150760] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 9 [ACTIVE 39]
Jan 26 21:29:48 rainbow kernel: [   68.150769] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 10 [ACTIVE 39]
Jan 26 21:29:48 rainbow kernel: [   68.150776] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 11 [ACTIVE 39]
Jan 26 21:29:48 rainbow kernel: [   68.150784] ieee80211 phy0: U
iwl3945_get_channels_for_scan total channels to scan 11
Jan 26 21:29:48 rainbow kernel: [   68.150802] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x440D,
351 bytes at 13[32]:4
Jan 26 21:29:48 rainbow kernel: [   68.648105] iwl3945 0000:03:00.0:
Error sending REPLY_SCAN_CMD: time out after 500ms.
Jan 26 21:29:48 rainbow kernel: [   68.648131] ieee80211 phy0: U
iwl3945_bg_scan_completed SCAN complete scan
Jan 26 21:29:48 rainbow kernel: [   68.648158] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x0d
Jan 26 21:29:48 rainbow kernel: [   68.648167] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x0f
Jan 26 21:29:48 rainbow kernel: [   68.648175] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x05
Jan 26 21:29:48 rainbow kernel: [   68.648183] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x07
Jan 26 21:29:48 rainbow kernel: [   68.648191] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x09
Jan 26 21:29:48 rainbow kernel: [   68.648200] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x0b
Jan 26 21:29:48 rainbow kernel: [   68.648208] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x01
Jan 26 21:29:48 rainbow kernel: [   68.648216] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x03
Jan 26 21:29:48 rainbow kernel: [   68.648225] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 119 rate code 0x0a
Jan 26 21:29:48 rainbow kernel: [   68.648233] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 119 rate code 0x14
Jan 26 21:29:48 rainbow kernel: [   68.648243] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 119 rate code 0x37
Jan 26 21:29:48 rainbow kernel: [   68.648251] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 119 rate code 0x6e
Jan 26 21:29:48 rainbow kernel: [   68.648267] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq:
0x040E, 56 bytes at 14[14]:4
Jan 26 21:29:49 rainbow kernel: [   69.148119] iwl3945 0000:03:00.0:
Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms.
Jan 26 21:29:53 rainbow kernel: [   73.649684] ieee80211 phy0: U
iwl3945_mac_hw_scan enter
Jan 26 21:29:53 rainbow kernel: [   73.649706] ieee80211 phy0: U
iwl3945_mac_hw_scan direct scan for WLAN [4]
Jan 26 21:29:53 rainbow kernel: [   73.649708]  <3>ieee80211 phy0: U
iwl3945_scan_initiate Starting scan...
Jan 26 21:29:53 rainbow kernel: [   73.649727] ieee80211 phy0: U
iwl3945_mac_hw_scan leave
Jan 26 21:29:53 rainbow kernel: [   73.649742] ieee80211 phy0: U
iwl3945_bg_request_scan Kicking off one direct scan for 'WLAN'
Jan 26 21:29:53 rainbow kernel: [   73.649755] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 1 [ACTIVE 42]
Jan 26 21:29:53 rainbow kernel: [   73.649763] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 2 [ACTIVE 42]
Jan 26 21:29:53 rainbow kernel: [   73.649771] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 3 [ACTIVE 42]
Jan 26 21:29:53 rainbow kernel: [   73.649778] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 4 [ACTIVE 42]
Jan 26 21:29:53 rainbow kernel: [   73.649788] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 5 [ACTIVE 42]
Jan 26 21:29:53 rainbow kernel: [   73.649796] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 6 [ACTIVE 42]
Jan 26 21:29:53 rainbow kernel: [   73.649804] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 7 [ACTIVE 42]
Jan 26 21:29:53 rainbow kernel: [   73.649812] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 8 [ACTIVE 42]
Jan 26 21:29:53 rainbow kernel: [   73.649820] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 9 [ACTIVE 42]
Jan 26 21:29:53 rainbow kernel: [   73.649829] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 10 [ACTIVE 42]
Jan 26 21:29:53 rainbow kernel: [   73.649837] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 11 [ACTIVE 42]
Jan 26 21:29:53 rainbow kernel: [   73.649845] ieee80211 phy0: U
iwl3945_get_channels_for_scan total channels to scan 11
Jan 26 21:29:53 rainbow kernel: [   73.649863] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x440F,
351 bytes at 15[32]:4
Jan 26 21:29:54 rainbow kernel: [   74.149099] iwl3945 0000:03:00.0:
Error sending REPLY_SCAN_CMD: time out after 500ms.
Jan 26 21:29:54 rainbow kernel: [   74.149113] ieee80211 phy0: U
iwl3945_bg_scan_completed SCAN complete scan
Jan 26 21:29:54 rainbow kernel: [   74.149136] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x0d
Jan 26 21:29:54 rainbow kernel: [   74.149145] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x0f
Jan 26 21:29:54 rainbow kernel: [   74.149153] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x05
Jan 26 21:29:54 rainbow kernel: [   74.149161] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x07
Jan 26 21:29:54 rainbow kernel: [   74.149169] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x09
Jan 26 21:29:54 rainbow kernel: [   74.149177] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x0b
Jan 26 21:29:54 rainbow kernel: [   74.149185] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x01
Jan 26 21:29:54 rainbow kernel: [   74.149193] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x03
Jan 26 21:29:54 rainbow kernel: [   74.149201] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 119 rate code 0x0a
Jan 26 21:29:54 rainbow kernel: [   74.149210] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 119 rate code 0x14
Jan 26 21:29:54 rainbow kernel: [   74.149218] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 119 rate code 0x37
Jan 26 21:29:54 rainbow kernel: [   74.149226] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 119 rate code 0x6e
Jan 26 21:29:54 rainbow kernel: [   74.149239] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq:
0x0410, 56 bytes at 16[16]:4
Jan 26 21:29:54 rainbow kernel: [   74.648098] iwl3945 0000:03:00.0:
Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms.
Jan 26 21:29:59 rainbow kernel: [   79.150651] ieee80211 phy0: U
iwl3945_mac_hw_scan enter
Jan 26 21:29:59 rainbow kernel: [   79.150669] ieee80211 phy0: U
iwl3945_scan_initiate Starting scan...
Jan 26 21:29:59 rainbow kernel: [   79.150681] ieee80211 phy0: U
iwl3945_mac_hw_scan leave
Jan 26 21:29:59 rainbow kernel: [   79.150693] ieee80211 phy0: U
iwl3945_bg_request_scan Kicking off one indirect scan.
Jan 26 21:29:59 rainbow kernel: [   79.150706] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 1 [ACTIVE 39]
Jan 26 21:29:59 rainbow kernel: [   79.150713] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 2 [ACTIVE 39]
Jan 26 21:29:59 rainbow kernel: [   79.150721] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 3 [ACTIVE 39]
Jan 26 21:29:59 rainbow kernel: [   79.150729] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 4 [ACTIVE 39]
Jan 26 21:29:59 rainbow kernel: [   79.150737] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 5 [ACTIVE 39]
Jan 26 21:29:59 rainbow kernel: [   79.150744] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 6 [ACTIVE 39]
Jan 26 21:29:59 rainbow kernel: [   79.150752] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 7 [ACTIVE 39]
Jan 26 21:29:59 rainbow kernel: [   79.150760] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 8 [ACTIVE 39]
Jan 26 21:29:59 rainbow kernel: [   79.150767] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 9 [ACTIVE 39]
Jan 26 21:29:59 rainbow kernel: [   79.150775] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 10 [ACTIVE 39]
Jan 26 21:29:59 rainbow kernel: [   79.150784] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 11 [ACTIVE 39]
Jan 26 21:29:59 rainbow kernel: [   79.150793] ieee80211 phy0: U
iwl3945_get_channels_for_scan total channels to scan 11
Jan 26 21:29:59 rainbow kernel: [   79.150809] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x4411,
351 bytes at 17[32]:4
Jan 26 21:29:59 rainbow kernel: [   79.648107] iwl3945 0000:03:00.0:
Error sending REPLY_SCAN_CMD: time out after 500ms.
Jan 26 21:29:59 rainbow kernel: [   79.648120] ieee80211 phy0: U
iwl3945_bg_scan_completed SCAN complete scan
Jan 26 21:29:59 rainbow kernel: [   79.648141] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x0d
Jan 26 21:29:59 rainbow kernel: [   79.648150] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x0f
Jan 26 21:29:59 rainbow kernel: [   79.648158] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x05
Jan 26 21:29:59 rainbow kernel: [   79.648167] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x07
Jan 26 21:29:59 rainbow kernel: [   79.648174] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x09
Jan 26 21:29:59 rainbow kernel: [   79.648183] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x0b
Jan 26 21:29:59 rainbow kernel: [   79.648192] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x01
Jan 26 21:29:59 rainbow kernel: [   79.648200] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x03
Jan 26 21:29:59 rainbow kernel: [   79.648209] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 119 rate code 0x0a
Jan 26 21:29:59 rainbow kernel: [   79.648217] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 119 rate code 0x14
Jan 26 21:29:59 rainbow kernel: [   79.648226] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 119 rate code 0x37
Jan 26 21:29:59 rainbow kernel: [   79.648234] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 119 rate code 0x6e
Jan 26 21:29:59 rainbow kernel: [   79.648247] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq:
0x0412, 56 bytes at 18[18]:4
Jan 26 21:30:00 rainbow kernel: [   80.148099] iwl3945 0000:03:00.0:
Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms.
Jan 26 21:30:04 rainbow kernel: [   84.649599] ieee80211 phy0: U
iwl3945_mac_hw_scan enter
Jan 26 21:30:04 rainbow kernel: [   84.649619] ieee80211 phy0: U
iwl3945_mac_hw_scan direct scan for WLAN [4]
Jan 26 21:30:04 rainbow kernel: [   84.649622]  <3>ieee80211 phy0: U
iwl3945_scan_initiate Starting scan...
Jan 26 21:30:04 rainbow kernel: [   84.649641] ieee80211 phy0: U
iwl3945_mac_hw_scan leave
Jan 26 21:30:04 rainbow kernel: [   84.649654] ieee80211 phy0: U
iwl3945_bg_request_scan Kicking off one direct scan for 'WLAN'
Jan 26 21:30:04 rainbow kernel: [   84.649667] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 1 [ACTIVE 42]
Jan 26 21:30:04 rainbow kernel: [   84.649675] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 2 [ACTIVE 42]
Jan 26 21:30:04 rainbow kernel: [   84.649683] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 3 [ACTIVE 42]
Jan 26 21:30:04 rainbow kernel: [   84.649690] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 4 [ACTIVE 42]
Jan 26 21:30:04 rainbow kernel: [   84.649698] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 5 [ACTIVE 42]
Jan 26 21:30:04 rainbow kernel: [   84.649706] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 6 [ACTIVE 42]
Jan 26 21:30:04 rainbow kernel: [   84.649713] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 7 [ACTIVE 42]
Jan 26 21:30:04 rainbow kernel: [   84.649721] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 8 [ACTIVE 42]
Jan 26 21:30:04 rainbow kernel: [   84.649730] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 9 [ACTIVE 42]
Jan 26 21:30:04 rainbow kernel: [   84.649738] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 10 [ACTIVE 42]
Jan 26 21:30:04 rainbow kernel: [   84.649746] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 11 [ACTIVE 42]
Jan 26 21:30:04 rainbow kernel: [   84.649755] ieee80211 phy0: U
iwl3945_get_channels_for_scan total channels to scan 11
Jan 26 21:30:04 rainbow kernel: [   84.649772] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x4413,
351 bytes at 19[32]:4
Jan 26 21:30:05 rainbow kernel: [   85.148103] iwl3945 0000:03:00.0:
Error sending REPLY_SCAN_CMD: time out after 500ms.
Jan 26 21:30:05 rainbow kernel: [   85.148119] ieee80211 phy0: U
iwl3945_bg_scan_completed SCAN complete scan
Jan 26 21:30:05 rainbow kernel: [   85.148144] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x0d
Jan 26 21:30:05 rainbow kernel: [   85.148153] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x0f
Jan 26 21:30:05 rainbow kernel: [   85.148161] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x05
Jan 26 21:30:05 rainbow kernel: [   85.148169] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x07
Jan 26 21:30:05 rainbow kernel: [   85.148177] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x09
Jan 26 21:30:05 rainbow kernel: [   85.148186] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x0b
Jan 26 21:30:05 rainbow kernel: [   85.148251] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x01
Jan 26 21:30:05 rainbow kernel: [   85.148259] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x03
Jan 26 21:30:05 rainbow kernel: [   85.148267] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 119 rate code 0x0a
Jan 26 21:30:05 rainbow kernel: [   85.148276] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 119 rate code 0x14
Jan 26 21:30:05 rainbow kernel: [   85.148285] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 119 rate code 0x37
Jan 26 21:30:05 rainbow kernel: [   85.148294] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 119 rate code 0x6e
Jan 26 21:30:05 rainbow kernel: [   85.148307] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq:
0x0414, 56 bytes at 20[20]:4
Jan 26 21:30:05 rainbow kernel: [   85.648099] iwl3945 0000:03:00.0:
Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms.
Jan 26 21:30:08 rainbow kernel: [   88.884104] ieee80211 phy0: U
iwl3945_hw_reg_txpower_get_temperature Temperature: 51
Jan 26 21:30:08 rainbow kernel: [   88.884116] ieee80211 phy0: U
is_temp_calib_needed Same temp,
Jan 26 21:30:08 rainbow kernel: [   88.884123] ieee80211 phy0: U
is_temp_calib_needed Timed thermal calib not needed
Jan 26 21:30:10 rainbow kernel: [   90.149722] ieee80211 phy0: U
iwl3945_mac_hw_scan enter
Jan 26 21:30:10 rainbow kernel: [   90.149741] ieee80211 phy0: U
iwl3945_scan_initiate Starting scan...
Jan 26 21:30:10 rainbow kernel: [   90.149752] ieee80211 phy0: U
iwl3945_mac_hw_scan leave
Jan 26 21:30:10 rainbow kernel: [   90.149765] ieee80211 phy0: U
iwl3945_bg_request_scan Kicking off one indirect scan.
Jan 26 21:30:10 rainbow kernel: [   90.149777] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 1 [ACTIVE 39]
Jan 26 21:30:10 rainbow kernel: [   90.149785] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 2 [ACTIVE 39]
Jan 26 21:30:10 rainbow kernel: [   90.149792] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 3 [ACTIVE 39]
Jan 26 21:30:10 rainbow kernel: [   90.149800] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 4 [ACTIVE 39]
Jan 26 21:30:10 rainbow kernel: [   90.149808] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 5 [ACTIVE 39]
Jan 26 21:30:10 rainbow kernel: [   90.149815] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 6 [ACTIVE 39]
Jan 26 21:30:10 rainbow kernel: [   90.149823] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 7 [ACTIVE 39]
Jan 26 21:30:10 rainbow kernel: [   90.149831] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 8 [ACTIVE 39]
Jan 26 21:30:10 rainbow kernel: [   90.149839] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 9 [ACTIVE 39]
Jan 26 21:30:10 rainbow kernel: [   90.149846] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 10 [ACTIVE 39]
Jan 26 21:30:10 rainbow kernel: [   90.149855] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 11 [ACTIVE 39]
Jan 26 21:30:10 rainbow kernel: [   90.149862] ieee80211 phy0: U
iwl3945_get_channels_for_scan total channels to scan 11
Jan 26 21:30:10 rainbow kernel: [   90.149935] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x4415,
351 bytes at 21[32]:4
Jan 26 21:30:10 rainbow kernel: [   90.648097] iwl3945 0000:03:00.0:
Error sending REPLY_SCAN_CMD: time out after 500ms.
Jan 26 21:30:10 rainbow kernel: [   90.648112] ieee80211 phy0: U
iwl3945_bg_scan_completed SCAN complete scan
Jan 26 21:30:10 rainbow kernel: [   90.648135] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x0d
Jan 26 21:30:10 rainbow kernel: [   90.648144] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x0f
Jan 26 21:30:10 rainbow kernel: [   90.648152] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x05
Jan 26 21:30:10 rainbow kernel: [   90.648159] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x07
Jan 26 21:30:10 rainbow kernel: [   90.648167] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x09
Jan 26 21:30:10 rainbow kernel: [   90.648176] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x0b
Jan 26 21:30:10 rainbow kernel: [   90.648184] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x01
Jan 26 21:30:10 rainbow kernel: [   90.648193] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x03
Jan 26 21:30:10 rainbow kernel: [   90.648201] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 119 rate code 0x0a
Jan 26 21:30:10 rainbow kernel: [   90.648209] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 119 rate code 0x14
Jan 26 21:30:10 rainbow kernel: [   90.648218] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 119 rate code 0x37
Jan 26 21:30:10 rainbow kernel: [   90.648226] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 119 rate code 0x6e
Jan 26 21:30:10 rainbow kernel: [   90.648239] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq:
0x0416, 56 bytes at 22[22]:4
Jan 26 21:30:11 rainbow kernel: [   91.148099] iwl3945 0000:03:00.0:
Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms.
Jan 26 21:30:15 rainbow kernel: [   95.649586] ieee80211 phy0: U
iwl3945_mac_hw_scan enter
Jan 26 21:30:15 rainbow kernel: [   95.649607] ieee80211 phy0: U
iwl3945_mac_hw_scan direct scan for WLAN [4]
Jan 26 21:30:15 rainbow kernel: [   95.649610]  <3>ieee80211 phy0: U
iwl3945_scan_initiate Starting scan...
Jan 26 21:30:15 rainbow kernel: [   95.649628] ieee80211 phy0: U
iwl3945_mac_hw_scan leave
Jan 26 21:30:15 rainbow kernel: [   95.649642] ieee80211 phy0: U
iwl3945_bg_request_scan Kicking off one direct scan for 'WLAN'
Jan 26 21:30:15 rainbow kernel: [   95.649669] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 1 [ACTIVE 42]
Jan 26 21:30:15 rainbow kernel: [   95.649677] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 2 [ACTIVE 42]
Jan 26 21:30:15 rainbow kernel: [   95.649685] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 3 [ACTIVE 42]
Jan 26 21:30:15 rainbow kernel: [   95.649693] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 4 [ACTIVE 42]
Jan 26 21:30:15 rainbow kernel: [   95.649700] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 5 [ACTIVE 42]
Jan 26 21:30:15 rainbow kernel: [   95.649708] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 6 [ACTIVE 42]
Jan 26 21:30:15 rainbow kernel: [   95.649715] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 7 [ACTIVE 42]
Jan 26 21:30:15 rainbow kernel: [   95.649723] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 8 [ACTIVE 42]
Jan 26 21:30:15 rainbow kernel: [   95.649731] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 9 [ACTIVE 42]
Jan 26 21:30:15 rainbow kernel: [   95.649739] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 10 [ACTIVE 42]
Jan 26 21:30:15 rainbow kernel: [   95.649748] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 11 [ACTIVE 42]
Jan 26 21:30:15 rainbow kernel: [   95.649755] ieee80211 phy0: U
iwl3945_get_channels_for_scan total channels to scan 11
Jan 26 21:30:15 rainbow kernel: [   95.649772] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x4417,
351 bytes at 23[32]:4
Jan 26 21:30:16 rainbow kernel: [   96.148112] iwl3945 0000:03:00.0:
Error sending REPLY_SCAN_CMD: time out after 500ms.
Jan 26 21:30:16 rainbow kernel: [   96.148127] ieee80211 phy0: U
iwl3945_bg_scan_completed SCAN complete scan
Jan 26 21:30:16 rainbow kernel: [   96.148148] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x0d
Jan 26 21:30:16 rainbow kernel: [   96.148157] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x0f
Jan 26 21:30:16 rainbow kernel: [   96.148164] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x05
Jan 26 21:30:16 rainbow kernel: [   96.148172] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x07
Jan 26 21:30:16 rainbow kernel: [   96.148181] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x09
Jan 26 21:30:16 rainbow kernel: [   96.148189] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x0b
Jan 26 21:30:16 rainbow kernel: [   96.148198] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x01
Jan 26 21:30:16 rainbow kernel: [   96.148206] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x03
Jan 26 21:30:16 rainbow kernel: [   96.148214] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 119 rate code 0x0a
Jan 26 21:30:16 rainbow kernel: [   96.148222] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 119 rate code 0x14
Jan 26 21:30:16 rainbow kernel: [   96.148230] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 119 rate code 0x37
Jan 26 21:30:16 rainbow kernel: [   96.148239] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 119 rate code 0x6e
Jan 26 21:30:16 rainbow kernel: [   96.148252] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq:
0x0418, 56 bytes at 24[24]:4
Jan 26 21:30:16 rainbow kernel: [   96.648145] iwl3945 0000:03:00.0:
Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms.
Jan 26 21:30:21 rainbow kernel: [  101.149633] ieee80211 phy0: U
iwl3945_mac_hw_scan enter
Jan 26 21:30:21 rainbow kernel: [  101.149649] ieee80211 phy0: U
iwl3945_scan_initiate Starting scan...
Jan 26 21:30:21 rainbow kernel: [  101.149660] ieee80211 phy0: U
iwl3945_mac_hw_scan leave
Jan 26 21:30:21 rainbow kernel: [  101.149672] ieee80211 phy0: U
iwl3945_bg_request_scan Kicking off one indirect scan.
Jan 26 21:30:21 rainbow kernel: [  101.149684] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 1 [ACTIVE 39]
Jan 26 21:30:21 rainbow kernel: [  101.149693] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 2 [ACTIVE 39]
Jan 26 21:30:21 rainbow kernel: [  101.149701] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 3 [ACTIVE 39]
Jan 26 21:30:21 rainbow kernel: [  101.149709] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 4 [ACTIVE 39]
Jan 26 21:30:21 rainbow kernel: [  101.149718] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 5 [ACTIVE 39]
Jan 26 21:30:21 rainbow kernel: [  101.149781] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 6 [ACTIVE 39]
Jan 26 21:30:21 rainbow kernel: [  101.149789] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 7 [ACTIVE 39]
Jan 26 21:30:21 rainbow kernel: [  101.149797] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 8 [ACTIVE 39]
Jan 26 21:30:21 rainbow kernel: [  101.149805] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 9 [ACTIVE 39]
Jan 26 21:30:21 rainbow kernel: [  101.149813] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 10 [ACTIVE 39]
Jan 26 21:30:21 rainbow kernel: [  101.149821] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 11 [ACTIVE 39]
Jan 26 21:30:21 rainbow kernel: [  101.149829] ieee80211 phy0: U
iwl3945_get_channels_for_scan total channels to scan 11
Jan 26 21:30:21 rainbow kernel: [  101.149844] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x4419,
351 bytes at 25[32]:4
Jan 26 21:30:21 rainbow kernel: [  101.648104] iwl3945 0000:03:00.0:
Error sending REPLY_SCAN_CMD: time out after 500ms.
Jan 26 21:30:21 rainbow kernel: [  101.648127] ieee80211 phy0: U
iwl3945_bg_scan_completed SCAN complete scan
Jan 26 21:30:21 rainbow kernel: [  101.648153] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x0d
Jan 26 21:30:21 rainbow kernel: [  101.648161] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x0f
Jan 26 21:30:21 rainbow kernel: [  101.648169] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x05
Jan 26 21:30:21 rainbow kernel: [  101.648177] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x07
Jan 26 21:30:21 rainbow kernel: [  101.648185] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x09
Jan 26 21:30:21 rainbow kernel: [  101.648193] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x0b
Jan 26 21:30:21 rainbow kernel: [  101.648201] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x01
Jan 26 21:30:21 rainbow kernel: [  101.648209] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x03
Jan 26 21:30:21 rainbow kernel: [  101.648218] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 119 rate code 0x0a
Jan 26 21:30:21 rainbow kernel: [  101.648227] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 119 rate code 0x14
Jan 26 21:30:21 rainbow kernel: [  101.648235] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 119 rate code 0x37
Jan 26 21:30:21 rainbow kernel: [  101.648244] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 119 rate code 0x6e
Jan 26 21:30:21 rainbow kernel: [  101.648259] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq:
0x041A, 56 bytes at 26[26]:4
Jan 26 21:30:22 rainbow kernel: [  102.148110] iwl3945 0000:03:00.0:
Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms.
Jan 26 21:30:26 rainbow kernel: [  106.649640] ieee80211 phy0: U
iwl3945_mac_hw_scan enter
Jan 26 21:30:26 rainbow kernel: [  106.649656] ieee80211 phy0: U
iwl3945_mac_hw_scan direct scan for WLAN [4]
Jan 26 21:30:26 rainbow kernel: [  106.649659]  <3>ieee80211 phy0: U
iwl3945_scan_initiate Starting scan...
Jan 26 21:30:26 rainbow kernel: [  106.649677] ieee80211 phy0: U
iwl3945_mac_hw_scan leave
Jan 26 21:30:26 rainbow kernel: [  106.649689] ieee80211 phy0: U
iwl3945_bg_request_scan Kicking off one direct scan for 'WLAN'
Jan 26 21:30:26 rainbow kernel: [  106.649715] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 1 [ACTIVE 42]
Jan 26 21:30:26 rainbow kernel: [  106.649724] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 2 [ACTIVE 42]
Jan 26 21:30:26 rainbow kernel: [  106.649731] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 3 [ACTIVE 42]
Jan 26 21:30:26 rainbow kernel: [  106.649738] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 4 [ACTIVE 42]
Jan 26 21:30:26 rainbow kernel: [  106.649746] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 5 [ACTIVE 42]
Jan 26 21:30:26 rainbow kernel: [  106.649753] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 6 [ACTIVE 42]
Jan 26 21:30:26 rainbow kernel: [  106.649761] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 7 [ACTIVE 42]
Jan 26 21:30:26 rainbow kernel: [  106.649769] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 8 [ACTIVE 42]
Jan 26 21:30:26 rainbow kernel: [  106.649777] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 9 [ACTIVE 42]
Jan 26 21:30:26 rainbow kernel: [  106.649786] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 10 [ACTIVE 42]
Jan 26 21:30:26 rainbow kernel: [  106.649793] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 11 [ACTIVE 42]
Jan 26 21:30:26 rainbow kernel: [  106.649801] ieee80211 phy0: U
iwl3945_get_channels_for_scan total channels to scan 11
Jan 26 21:30:26 rainbow kernel: [  106.649817] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x441B,
351 bytes at 27[32]:4
Jan 26 21:30:27 rainbow kernel: [  107.148098] iwl3945 0000:03:00.0:
Error sending REPLY_SCAN_CMD: time out after 500ms.
Jan 26 21:30:27 rainbow kernel: [  107.148111] ieee80211 phy0: U
iwl3945_bg_scan_completed SCAN complete scan
Jan 26 21:30:27 rainbow kernel: [  107.148131] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x0d
Jan 26 21:30:27 rainbow kernel: [  107.148139] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x0f
Jan 26 21:30:27 rainbow kernel: [  107.148147] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x05
Jan 26 21:30:27 rainbow kernel: [  107.148155] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x07
Jan 26 21:30:27 rainbow kernel: [  107.148162] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x09
Jan 26 21:30:27 rainbow kernel: [  107.148170] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x0b
Jan 26 21:30:27 rainbow kernel: [  107.148179] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x01
Jan 26 21:30:27 rainbow kernel: [  107.148187] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x03
Jan 26 21:30:27 rainbow kernel: [  107.148195] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 119 rate code 0x0a
Jan 26 21:30:27 rainbow kernel: [  107.148204] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 119 rate code 0x14
Jan 26 21:30:27 rainbow kernel: [  107.148212] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 119 rate code 0x37
Jan 26 21:30:27 rainbow kernel: [  107.148220] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 119 rate code 0x6e
Jan 26 21:30:27 rainbow kernel: [  107.148234] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq:
0x041C, 56 bytes at 28[28]:4
Jan 26 21:30:27 rainbow kernel: [  107.648101] iwl3945 0000:03:00.0:
Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms.
Jan 26 21:30:32 rainbow kernel: [  112.150035] ieee80211 phy0: U
iwl3945_mac_hw_scan enter
Jan 26 21:30:32 rainbow kernel: [  112.150052] ieee80211 phy0: U
iwl3945_scan_initiate Starting scan...
Jan 26 21:30:32 rainbow kernel: [  112.150065] ieee80211 phy0: U
iwl3945_mac_hw_scan leave
Jan 26 21:30:32 rainbow kernel: [  112.150079] ieee80211 phy0: U
iwl3945_bg_request_scan Kicking off one indirect scan.
Jan 26 21:30:32 rainbow kernel: [  112.150091] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 1 [ACTIVE 39]
Jan 26 21:30:32 rainbow kernel: [  112.150099] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 2 [ACTIVE 39]
Jan 26 21:30:32 rainbow kernel: [  112.150107] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 3 [ACTIVE 39]
Jan 26 21:30:32 rainbow kernel: [  112.150115] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 4 [ACTIVE 39]
Jan 26 21:30:32 rainbow kernel: [  112.150123] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 5 [ACTIVE 39]
Jan 26 21:30:32 rainbow kernel: [  112.150131] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 6 [ACTIVE 39]
Jan 26 21:30:32 rainbow kernel: [  112.150139] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 7 [ACTIVE 39]
Jan 26 21:30:32 rainbow kernel: [  112.150147] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 8 [ACTIVE 39]
Jan 26 21:30:32 rainbow kernel: [  112.150155] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 9 [ACTIVE 39]
Jan 26 21:30:32 rainbow kernel: [  112.150163] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 10 [ACTIVE 39]
Jan 26 21:30:32 rainbow kernel: [  112.150209] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 11 [ACTIVE 39]
Jan 26 21:30:32 rainbow kernel: [  112.150217] ieee80211 phy0: U
iwl3945_get_channels_for_scan total channels to scan 11
Jan 26 21:30:32 rainbow kernel: [  112.150234] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x441D,
351 bytes at 29[32]:4
Jan 26 21:30:32 rainbow kernel: [  112.648097] iwl3945 0000:03:00.0:
Error sending REPLY_SCAN_CMD: time out after 500ms.
Jan 26 21:30:32 rainbow kernel: [  112.648111] ieee80211 phy0: U
iwl3945_bg_scan_completed SCAN complete scan
Jan 26 21:30:32 rainbow kernel: [  112.648135] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x0d
Jan 26 21:30:32 rainbow kernel: [  112.648143] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x0f
Jan 26 21:30:32 rainbow kernel: [  112.648151] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x05
Jan 26 21:30:32 rainbow kernel: [  112.648159] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x07
Jan 26 21:30:32 rainbow kernel: [  112.648167] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x09
Jan 26 21:30:32 rainbow kernel: [  112.648175] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x0b
Jan 26 21:30:32 rainbow kernel: [  112.648183] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x01
Jan 26 21:30:32 rainbow kernel: [  112.648191] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x03
Jan 26 21:30:32 rainbow kernel: [  112.648198] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 119 rate code 0x0a
Jan 26 21:30:32 rainbow kernel: [  112.648206] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 119 rate code 0x14
Jan 26 21:30:32 rainbow kernel: [  112.648215] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 119 rate code 0x37
Jan 26 21:30:32 rainbow kernel: [  112.648222] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 119 rate code 0x6e
Jan 26 21:30:32 rainbow kernel: [  112.648236] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq:
0x041E, 56 bytes at 30[30]:4
Jan 26 21:30:33 rainbow kernel: [  113.148144] iwl3945 0000:03:00.0:
Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms.
Jan 26 21:30:37 rainbow kernel: [  117.649231] ieee80211 phy0: U
iwl3945_mac_hw_scan enter
Jan 26 21:30:37 rainbow kernel: [  117.649250] ieee80211 phy0: U
iwl3945_mac_hw_scan direct scan for WLAN [4]
Jan 26 21:30:37 rainbow kernel: [  117.649253]  <3>ieee80211 phy0: U
iwl3945_scan_initiate Starting scan...
Jan 26 21:30:37 rainbow kernel: [  117.649272] ieee80211 phy0: U
iwl3945_mac_hw_scan leave
Jan 26 21:30:37 rainbow kernel: [  117.649286] ieee80211 phy0: U
iwl3945_bg_request_scan Kicking off one direct scan for 'WLAN'
Jan 26 21:30:37 rainbow kernel: [  117.649299] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 1 [ACTIVE 42]
Jan 26 21:30:37 rainbow kernel: [  117.649307] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 2 [ACTIVE 42]
Jan 26 21:30:37 rainbow kernel: [  117.649315] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 3 [ACTIVE 42]
Jan 26 21:30:37 rainbow kernel: [  117.649323] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 4 [ACTIVE 42]
Jan 26 21:30:37 rainbow kernel: [  117.649331] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 5 [ACTIVE 42]
Jan 26 21:30:37 rainbow kernel: [  117.649339] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 6 [ACTIVE 42]
Jan 26 21:30:37 rainbow kernel: [  117.649347] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 7 [ACTIVE 42]
Jan 26 21:30:37 rainbow kernel: [  117.649355] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 8 [ACTIVE 42]
Jan 26 21:30:37 rainbow kernel: [  117.649364] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 9 [ACTIVE 42]
Jan 26 21:30:37 rainbow kernel: [  117.649371] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 10 [ACTIVE 42]
Jan 26 21:30:37 rainbow kernel: [  117.649379] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 11 [ACTIVE 42]
Jan 26 21:30:37 rainbow kernel: [  117.649387] ieee80211 phy0: U
iwl3945_get_channels_for_scan total channels to scan 11
Jan 26 21:30:37 rainbow kernel: [  117.649404] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x441F,
351 bytes at 31[32]:4
Jan 26 21:30:38 rainbow kernel: [  118.148109] iwl3945 0000:03:00.0:
Error sending REPLY_SCAN_CMD: time out after 500ms.
Jan 26 21:30:38 rainbow kernel: [  118.148122] ieee80211 phy0: U
iwl3945_bg_scan_completed SCAN complete scan
Jan 26 21:30:38 rainbow kernel: [  118.148144] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x0d
Jan 26 21:30:38 rainbow kernel: [  118.148153] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x0f
Jan 26 21:30:38 rainbow kernel: [  118.148160] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x05
Jan 26 21:30:38 rainbow kernel: [  118.148168] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x07
Jan 26 21:30:38 rainbow kernel: [  118.148176] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x09
Jan 26 21:30:38 rainbow kernel: [  118.148184] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x0b
Jan 26 21:30:38 rainbow kernel: [  118.148194] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x01
Jan 26 21:30:38 rainbow kernel: [  118.148202] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x03
Jan 26 21:30:38 rainbow kernel: [  118.148210] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 119 rate code 0x0a
Jan 26 21:30:38 rainbow kernel: [  118.148219] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 119 rate code 0x14
Jan 26 21:30:38 rainbow kernel: [  118.148227] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 119 rate code 0x37
Jan 26 21:30:38 rainbow kernel: [  118.148235] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 119 rate code 0x6e
Jan 26 21:30:38 rainbow kernel: [  118.148248] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq:
0x0420, 56 bytes at 32[0]:4
Jan 26 21:30:38 rainbow kernel: [  118.648100] iwl3945 0000:03:00.0:
Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms.
Jan 26 21:30:42 rainbow kernel: [  122.654357] ieee80211 phy0: U
iwl3945_mac_config enter to channel 11
Jan 26 21:30:42 rainbow kernel: [  122.654383] ieee80211 phy0: U
iwl3945_commit_rxon Sending RXON
Jan 26 21:30:42 rainbow kernel: [  122.654385] * without RXON_FILTER_ASSOC_MSK
Jan 26 21:30:42 rainbow kernel: [  122.654387] * channel = 11
Jan 26 21:30:42 rainbow kernel: [  122.654389] * bssid = 00:00:00:00:00:00
Jan 26 21:30:42 rainbow kernel: [  122.654413] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x0421, 48
bytes at 33[1]:4
Jan 26 21:30:43 rainbow kernel: [  123.153099] iwl3945 0000:03:00.0:
Error sending REPLY_RXON: time out after 500ms.
Jan 26 21:30:43 rainbow kernel: [  123.153116] iwl3945 0000:03:00.0:
Error setting new configuration (-110).
Jan 26 21:30:43 rainbow kernel: [  123.153125] ieee80211 phy0: U
iwl3945_mac_config leave
Jan 26 21:30:43 rainbow kernel: [  123.153135] ieee80211 phy0: U
iwl3945_mac_conf_tx enter
Jan 26 21:30:43 rainbow kernel: [  123.153141] ieee80211 phy0: U
iwl3945_mac_conf_tx leave
Jan 26 21:30:43 rainbow kernel: [  123.153148] ieee80211 phy0: U
iwl3945_mac_conf_tx enter
Jan 26 21:30:43 rainbow kernel: [  123.153154] ieee80211 phy0: U
iwl3945_mac_conf_tx leave
Jan 26 21:30:43 rainbow kernel: [  123.153160] ieee80211 phy0: U
iwl3945_mac_conf_tx enter
Jan 26 21:30:43 rainbow kernel: [  123.153167] ieee80211 phy0: U
iwl3945_mac_conf_tx leave
Jan 26 21:30:43 rainbow kernel: [  123.153174] ieee80211 phy0: U
iwl3945_mac_conf_tx enter
Jan 26 21:30:43 rainbow kernel: [  123.153180] ieee80211 phy0: U
iwl3945_mac_conf_tx leave
Jan 26 21:30:43 rainbow kernel: [  123.153188] ieee80211 phy0: U
iwl3945_mac_reset_tsf enter
Jan 26 21:30:43 rainbow kernel: [  123.153200] ieee80211 phy0: U
iwl3945_commit_rxon Sending RXON
Jan 26 21:30:43 rainbow kernel: [  123.153203] * without RXON_FILTER_ASSOC_MSK
Jan 26 21:30:43 rainbow kernel: [  123.153204] * channel = 11
Jan 26 21:30:43 rainbow kernel: [  123.153206] * bssid = 00:00:00:00:00:00
Jan 26 21:30:43 rainbow kernel: [  123.153228] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x0422, 48
bytes at 34[2]:4
Jan 26 21:30:43 rainbow kernel: [  123.652321] iwl3945 0000:03:00.0:
Error sending REPLY_RXON: time out after 500ms.
Jan 26 21:30:43 rainbow kernel: [  123.652348] iwl3945 0000:03:00.0:
Error setting new configuration (-110).
Jan 26 21:30:43 rainbow kernel: [  123.652361] ieee80211 phy0: U
iwl3945_mac_reset_tsf leave - not in IBSS
Jan 26 21:30:43 rainbow kernel: [  123.652373] wlan0: direct probe to
AP 00:30:bd:c0:90:24 try 1
Jan 26 21:30:43 rainbow kernel: [  123.652402] ieee80211 phy0: I
iwl3945_mac_tx enter
Jan 26 21:30:43 rainbow kernel: [  123.652419] ieee80211 phy0: I
iwl3945_mac_tx leave
Jan 26 21:30:43 rainbow kernel: [  123.652487] iwl3945 0000:03:00.0:
Microcode SW error detected. Restarting 0x82000008.
Jan 26 21:30:43 rainbow kernel: [  123.652522] iwl3945 0000:03:00.0:
Start IWL Error Log Dump:
Jan 26 21:30:43 rainbow kernel: [  123.652530] iwl3945 0000:03:00.0:
Status: 0x000202E4, count: 1
Jan 26 21:30:43 rainbow kernel: [  123.652537] iwl3945 0000:03:00.0:
Desc       Time       asrtPC  blink2 ilink1  nmiPC   Line
Jan 26 21:30:43 rainbow kernel: [  123.652615] iwl3945 0000:03:00.0:
SYSASSERT     (#5) 0094764953 0x0089A 0x0025E 0x00300 0x01BCC 78
Jan 26 21:30:43 rainbow kernel: [  123.652618]
Jan 26 21:30:43 rainbow kernel: [  123.652689] iwl3945 0000:03:00.0:
Start IWL Event Log Dump: display count 512, wraps 1
Jan 26 21:30:43 rainbow kernel: [  123.652727] iwl3945 0000:03:00.0:
0000001191^I0x0000000b^I0451
Jan 26 21:30:43 rainbow kernel: [  123.652763] iwl3945 0000:03:00.0:
0000001211^I0x00000000^I0451
Jan 26 21:30:43 rainbow kernel: [  123.652799] iwl3945 0000:03:00.0:
0000001334^I0x04040018^I0401
Jan 26 21:30:43 rainbow kernel: [  123.652835] iwl3945 0000:03:00.0:
0000001454^I0x04050047^I0401
Jan 26 21:30:43 rainbow kernel: [  123.652870] iwl3945 0000:03:00.0:
0000001584^I0x04060047^I0401
Jan 26 21:30:43 rainbow kernel: [  123.652906] iwl3945 0000:03:00.0:
0000001869^I0x04070097^I0401
Jan 26 21:30:43 rainbow kernel: [  123.652941] iwl3945 0000:03:00.0:
0000001872^I0x0000000b^I0451
Jan 26 21:30:43 rainbow kernel: [  123.652977] iwl3945 0000:03:00.0:
0000001875^I0x0024cb73^I0450
Jan 26 21:30:43 rainbow kernel: [  123.653013] iwl3945 0000:03:00.0:
0000001878^I0x0024cb73^I0450
Jan 26 21:30:43 rainbow kernel: [  123.653048] iwl3945 0000:03:00.0:
0000001880^I0x0024cb73^I0450
Jan 26 21:30:43 rainbow kernel: [  123.653084] iwl3945 0000:03:00.0:
0000001882^I0x0024cb73^I0450
Jan 26 21:30:43 rainbow kernel: [  123.653120] iwl3945 0000:03:00.0:
0000001885^I0x0024cb73^I0450
Jan 26 21:30:43 rainbow kernel: [  123.653156] iwl3945 0000:03:00.0:
0000001887^I0x0024cb73^I0450
Jan 26 21:30:43 rainbow kernel: [  123.653193] iwl3945 0000:03:00.0:
0000001890^I0x0024cb73^I0450
Jan 26 21:30:43 rainbow kernel: [  123.653228] iwl3945 0000:03:00.0:
0000001892^I0x0024cb73^I0450
Jan 26 21:30:43 rainbow kernel: [  123.653264] iwl3945 0000:03:00.0:
0000001899^I0x000000ff^I0451
Jan 26 21:30:43 rainbow kernel: [  123.653299] iwl3945 0000:03:00.0:
0000002125^I0x04080048^I0401
Jan 26 21:30:43 rainbow kernel: [  123.653344] iwl3945 0000:03:00.0:
0000004726^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.653380] iwl3945 0000:03:00.0:
0000004727^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.653416] iwl3945 0000:03:00.0:
0000004801^I0x00000001^I0353
Jan 26 21:30:43 rainbow kernel: [  123.653452] iwl3945 0000:03:00.0:
0000004811^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  123.653487] iwl3945 0000:03:00.0:
0000004819^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.653522] iwl3945 0000:03:00.0:
0000004821^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.653558] iwl3945 0000:03:00.0:
0000004890^I0x00000002^I0353
Jan 26 21:30:43 rainbow kernel: [  123.653594] iwl3945 0000:03:00.0:
0000004900^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  123.653629] iwl3945 0000:03:00.0:
0000004907^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.653664] iwl3945 0000:03:00.0:
0000004909^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.653701] iwl3945 0000:03:00.0:
0000004981^I0x00000003^I0353
Jan 26 21:30:43 rainbow kernel: [  123.653736] iwl3945 0000:03:00.0:
0000004991^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  123.653771] iwl3945 0000:03:00.0:
0000004998^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.653807] iwl3945 0000:03:00.0:
0000004999^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.653843] iwl3945 0000:03:00.0:
0000005072^I0x00000004^I0353
Jan 26 21:30:43 rainbow kernel: [  123.653878] iwl3945 0000:03:00.0:
0000005082^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  123.653917] iwl3945 0000:03:00.0:
0000005091^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.653953] iwl3945 0000:03:00.0:
0000005093^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.653989] iwl3945 0000:03:00.0:
0000005166^I0x00000005^I0353
Jan 26 21:30:43 rainbow kernel: [  123.654025] iwl3945 0000:03:00.0:
0000005177^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  123.654060] iwl3945 0000:03:00.0:
0000005184^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.654095] iwl3945 0000:03:00.0:
0000005185^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.654131] iwl3945 0000:03:00.0:
0000005258^I0x00000006^I0353
Jan 26 21:30:43 rainbow kernel: [  123.654171] iwl3945 0000:03:00.0:
0000005268^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  123.654207] iwl3945 0000:03:00.0:
0000005275^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.654243] iwl3945 0000:03:00.0:
0000005277^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.654278] iwl3945 0000:03:00.0:
0000005347^I0x00000007^I0353
Jan 26 21:30:43 rainbow kernel: [  123.654314] iwl3945 0000:03:00.0:
0000005357^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  123.654349] iwl3945 0000:03:00.0:
0000005364^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.654384] iwl3945 0000:03:00.0:
0000005366^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.654420] iwl3945 0000:03:00.0:
0000005435^I0x00000008^I0353
Jan 26 21:30:43 rainbow kernel: [  123.654456] iwl3945 0000:03:00.0:
0000005445^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  123.654495] iwl3945 0000:03:00.0:
0000005455^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.654531] iwl3945 0000:03:00.0:
0000005457^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.654566] iwl3945 0000:03:00.0:
0000005531^I0x00000009^I0353
Jan 26 21:30:43 rainbow kernel: [  123.654602] iwl3945 0000:03:00.0:
0000005542^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  123.654638] iwl3945 0000:03:00.0:
0000005548^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.654674] iwl3945 0000:03:00.0:
0000005550^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.654710] iwl3945 0000:03:00.0:
0000005622^I0x0000000a^I0353
Jan 26 21:30:43 rainbow kernel: [  123.654749] iwl3945 0000:03:00.0:
0000005632^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  123.654784] iwl3945 0000:03:00.0:
0000005639^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.654820] iwl3945 0000:03:00.0:
0000005641^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.654855] iwl3945 0000:03:00.0:
0000005732^I0x0000000b^I0353
Jan 26 21:30:43 rainbow kernel: [  123.654891] iwl3945 0000:03:00.0:
0000005743^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  123.654927] iwl3945 0000:03:00.0:
0000005750^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.654963] iwl3945 0000:03:00.0:
0000005751^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.654999] iwl3945 0000:03:00.0:
0000005824^I0x0000000c^I0353
Jan 26 21:30:43 rainbow kernel: [  123.655034] iwl3945 0000:03:00.0:
0000005834^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  123.655073] iwl3945 0000:03:00.0:
0000005841^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.655109] iwl3945 0000:03:00.0:
0000005843^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.655144] iwl3945 0000:03:00.0:
0000005850^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.655180] iwl3945 0000:03:00.0:
0000008877^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.655216] iwl3945 0000:03:00.0:
0000008878^I0x00000000^I0302
Jan 26 21:30:43 rainbow kernel: [  123.655251] iwl3945 0000:03:00.0:
0000008887^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.655287] iwl3945 0000:03:00.0:
0000009025^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.655327] iwl3945 0000:03:00.0:
0000009027^I0x00000000^I0302
Jan 26 21:30:43 rainbow kernel: [  123.655362] iwl3945 0000:03:00.0:
0000009035^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.655398] iwl3945 0000:03:00.0:
0000009402^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.655434] iwl3945 0000:03:00.0:
0000009404^I0x00000000^I0302
Jan 26 21:30:43 rainbow kernel: [  123.655469] iwl3945 0000:03:00.0:
0000009444^I0x00000001^I0353
Jan 26 21:30:43 rainbow kernel: [  123.655505] iwl3945 0000:03:00.0:
0000009473^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.655540] iwl3945 0000:03:00.0:
0000009475^I0x00000000^I0302
Jan 26 21:30:43 rainbow kernel: [  123.655576] iwl3945 0000:03:00.0:
0000009483^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.655611] iwl3945 0000:03:00.0:
0000009658^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.655650] iwl3945 0000:03:00.0:
0000009660^I0x00000000^I0302
Jan 26 21:30:43 rainbow kernel: [  123.655686] iwl3945 0000:03:00.0:
0000009668^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.655721] iwl3945 0000:03:00.0:
0000009676^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.655757] iwl3945 0000:03:00.0:
0000009677^I0x00000000^I0302
Jan 26 21:30:43 rainbow kernel: [  123.655792] iwl3945 0000:03:00.0:
0000009686^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.655828] iwl3945 0000:03:00.0:
0000009701^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.655863] iwl3945 0000:03:00.0:
0000009703^I0x00000000^I0302
Jan 26 21:30:43 rainbow kernel: [  123.655902] iwl3945 0000:03:00.0:
0000009712^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.655938] iwl3945 0000:03:00.0:
0000009755^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.655973] iwl3945 0000:03:00.0:
0000009757^I0x00000000^I0302
Jan 26 21:30:43 rainbow kernel: [  123.656008] iwl3945 0000:03:00.0:
0000009765^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.656043] iwl3945 0000:03:00.0:
0000009773^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656079] iwl3945 0000:03:00.0:
0000009775^I0x00000000^I0302
Jan 26 21:30:43 rainbow kernel: [  123.656115] iwl3945 0000:03:00.0:
0000009782^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.656151] iwl3945 0000:03:00.0:
0000009800^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000009801^I0x00000000^I0302
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000009810^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000017406^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000017408^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000017482^I0x0000000d^I0353
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000017492^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000017620^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000017622^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000017696^I0x0000000e^I0353
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000017707^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000017918^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000017919^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000017992^I0x0000000f^I0353
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000018003^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000019967^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000019969^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000020205^I0x00000010^I0353
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000020215^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000022241^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000022243^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000022318^I0x00000011^I0353
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000022334^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000022336^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000022681^I0x00000000^I0356
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000023410^I0x00000003^I0310
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000023554^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000023556^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000023565^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000025793^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000025795^I0x00000000^I0302
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000025803^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000025879^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000025881^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000025890^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000025923^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000025925^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000025934^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000026039^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000026041^I0x00000000^I0302
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000026049^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000026057^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000026059^I0x00000000^I0302
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000026080^I0x00000002^I0353
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000026097^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000026099^I0x00000000^I0302
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000026138^I0x00000003^I0353
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000026160^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000026162^I0x00000000^I0302
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000026170^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000026178^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000026180^I0x00000000^I0302
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000026188^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000026232^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000026234^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000026244^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000026264^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000026266^I0x00000000^I0302
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000026308^I0x00000004^I0353
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000026323^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000026325^I0x00000000^I0302
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000026330^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000026347^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000026348^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000026358^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000026435^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000026436^I0x00000000^I0302
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000026445^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000033878^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000033879^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000033969^I0x00000012^I0353
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000033979^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000034015^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000034017^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000034137^I0x00000013^I0353
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000034147^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000034205^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000034206^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000034288^I0x00000014^I0353
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000034298^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000034322^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000034323^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000034397^I0x00000015^I0353
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000034407^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000034416^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000034418^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000034497^I0x00000016^I0353
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000034507^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000034551^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000034553^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000034631^I0x00000017^I0353
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000034642^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000034670^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000034672^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000034777^I0x00000018^I0353
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000034787^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000034804^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000034805^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000034879^I0x00000019^I0353
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000034889^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000034987^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000034988^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000035062^I0x0000001a^I0353
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000035072^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000038110^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000038112^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000038493^I0x00000000^I0356
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000038794^I0x00000003^I0310
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000039104^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000039106^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000039179^I0x0000001b^I0353
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000039190^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000039197^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000039199^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000039289^I0x0000001c^I0353
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000039300^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000039346^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000039348^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000039422^I0x0000001d^I0353
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000039433^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000039440^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000039441^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000039512^I0x0000001e^I0353
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000039523^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000039657^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000039659^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000039733^I0x0000001f^I0353
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000039743^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000042283^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000042285^I0x00000000^I0302
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000042294^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000042323^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000042324^I0x00000000^I0302
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000042333^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000042402^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000042404^I0x00000000^I0302
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000042412^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000042427^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000042428^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000042438^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000042452^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000042454^I0x00000000^I0302
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000042494^I0x00000005^I0353
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000042608^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000042610^I0x00000000^I0302
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000042650^I0x00000006^I0353
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000042692^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000042694^I0x00000000^I0302
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000042702^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000042784^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000042785^I0x00000000^I0302
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000042794^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000043030^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000043031^I0x00000000^I0302
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000043040^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000043051^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000043052^I0x00000000^I0302
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000043061^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000043121^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000043122^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000043132^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000043145^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000043147^I0x00000000^I0302
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000043156^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000045615^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000045617^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000045998^I0x00000000^I0356
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000046711^I0x00000003^I0310
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000049627^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000049628^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000050009^I0x00000000^I0356
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000050575^I0x00000003^I0310
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000051441^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000051443^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000051639^I0x000000c4^I0303
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000051642^I0x00000001^I0357
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000051700^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000051701^I0x00000000^I0302
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000051730^I0x000000d4^I0303
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000051881^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000051882^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000052263^I0x00000000^I0356
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000052792^I0x00000003^I0310
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000053485^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000053487^I0x00000000^I0302
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000053495^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000053589^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000053590^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000053684^I0x00000020^I0353
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000053694^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000053830^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000053832^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000053909^I0x00000021^I0353
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000053920^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000055025^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000055026^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000055099^I0x00000022^I0353
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000055109^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000056682^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000056684^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000057067^I0x00000000^I0356
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000057592^I0x00000003^I0310
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000057728^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000057730^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000057811^I0x00000023^I0353
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000057822^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000057853^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000057854^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000057864^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000058889^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000058891^I0x00000000^I0302
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000058936^I0x00000007^I0353
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000058956^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000058958^I0x00000000^I0302
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000058967^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000058976^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000058978^I0x00000000^I0302
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000058986^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000059061^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000059062^I0x00000000^I0302
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000059103^I0x00000008^I0353
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000059173^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000059175^I0x00000000^I0302
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000059183^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000059292^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000059293^I0x00000000^I0302
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000059302^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000059341^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000059342^I0x00000000^I0302
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000059351^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000059385^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000059387^I0x00000000^I0302
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000059428^I0x00000009^I0353
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000059577^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000059579^I0x00000000^I0302
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000059588^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000059627^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000059628^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000059638^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000059659^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000059660^I0x00000000^I0302
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000059669^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000059690^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000059692^I0x00000000^I0302
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000059700^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000059725^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000059727^I0x00000000^I0302
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000059752^I0x0000000a^I0353
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000059827^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000059829^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000059838^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000072032^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000072033^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000072415^I0x00000000^I0356
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000075040^I0x00000003^I0310
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000075846^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000075848^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000075857^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000075871^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000075873^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000075882^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000075891^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000075892^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000075902^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000075916^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000075918^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000075927^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000075936^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000075938^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000075947^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000075958^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000075960^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000075969^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000075987^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000075989^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000075998^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000076011^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000076013^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000076022^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000076042^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000076044^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000076054^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000076095^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000076096^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000076106^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000084697^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000084698^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000084798^I0x00000024^I0353
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000084808^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000087173^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000087175^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000087252^I0x00000025^I0353
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000087263^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000087582^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000087584^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000087964^I0x00000000^I0356
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000088601^I0x00000003^I0310
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000089599^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000089600^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000089675^I0x00000026^I0353
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000089685^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000089978^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000089979^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000090053^I0x00000027^I0353
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000090063^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000090225^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000090227^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000090300^I0x00000028^I0353
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000090310^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000090386^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000090388^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000090462^I0x00000029^I0353
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000090472^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000090542^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000090544^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000090615^I0x0000002a^I0353
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000090625^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000090646^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000090648^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000090723^I0x0000002b^I0353
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000090733^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000090740^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000090742^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000090814^I0x0000002c^I0353
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000090824^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000105788^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000105789^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000105799^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000105860^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000105862^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000105871^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000105880^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000105882^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000105891^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000105916^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000105917^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000105927^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000105941^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000105942^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000105952^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000105972^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000105974^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000105984^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000105995^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000105997^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000106006^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000106023^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000106025^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000106034^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000106043^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000106044^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000106054^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000106063^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000106065^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000106075^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000106087^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000106089^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000106099^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000106113^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000106115^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000106124^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000107127^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000107129^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000107203^I0x0000002d^I0353
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000107213^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000107221^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000107223^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000107291^I0x0000002e^I0353
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000107301^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000107308^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000107310^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000107383^I0x0000002f^I0353
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000107393^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000107400^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000107402^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000107473^I0x00000030^I0353
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000107483^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000107490^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000107491^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000107579^I0x00000031^I0353
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000107590^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000107596^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000107598^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000107669^I0x00000032^I0353
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000107679^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000107686^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000107687^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000107765^I0x00000033^I0353
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000107775^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000107782^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000107783^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000107853^I0x00000034^I0353
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000107863^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000107870^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000107872^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000107945^I0x00000035^I0353
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000107956^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000107963^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000107964^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000108033^I0x00000036^I0353
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000108044^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000108051^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000108052^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000108122^I0x00000037^I0353
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000108133^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000108139^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000108141^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000108230^I0x00000038^I0353
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000108240^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000108247^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000108249^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000108319^I0x00000039^I0353
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000108329^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000119529^I0x00010087^I0250
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0000119535^I0x0000001c^I0218
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0094764951^I0x00000002^I0123
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
0094764954^I0x00000100^I0125
Jan 26 21:30:43 rainbow kernel: [  123.656183] ieee80211 phy0: I
iwl3945_print_rx_config_cmd RX CONFIG:
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl data: 00000000: 00
1f 3c 20 a1 6e 00 00 00 00 00 00 00 00 00 00  ..< .n..........
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl data: 00000010: 00
00 00 00 00 00 00 00 03 00 00 00 15 03 00 00  ................
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl data: 00000020: 05
80 00 00 04 00 00 00 0b 00 00 00              ............
Jan 26 21:30:43 rainbow kernel: [  123.656183] ieee80211 phy0: I
iwl3945_print_rx_config_cmd u16 channel: 0xb
Jan 26 21:30:43 rainbow kernel: [  123.656183] ieee80211 phy0: I
iwl3945_print_rx_config_cmd u32 flags: 0x00008005
Jan 26 21:30:43 rainbow kernel: [  123.656183] ieee80211 phy0: I
iwl3945_print_rx_config_cmd u32 filter_flags: 0x00000004
Jan 26 21:30:43 rainbow kernel: [  123.656183] ieee80211 phy0: I
iwl3945_print_rx_config_cmd u8 dev_type: 0x3
Jan 26 21:30:43 rainbow kernel: [  123.656183] ieee80211 phy0: I
iwl3945_print_rx_config_cmd u8 ofdm_basic_rates: 0x15
Jan 26 21:30:43 rainbow kernel: [  123.656183] ieee80211 phy0: I
iwl3945_print_rx_config_cmd u8 cck_basic_rates: 0x03
Jan 26 21:30:43 rainbow kernel: [  123.656183] ieee80211 phy0: I
iwl3945_print_rx_config_cmd u8[6] node_addr: 00:1f:3c:20:a1:6e
Jan 26 21:30:43 rainbow kernel: [  123.656183] ieee80211 phy0: I
iwl3945_print_rx_config_cmd u8[6] bssid_addr: 00:00:00:00:00:00
Jan 26 21:30:43 rainbow kernel: [  123.656183] ieee80211 phy0: I
iwl3945_print_rx_config_cmd u16 assoc_id: 0x0
Jan 26 21:30:43 rainbow kernel: [  123.656183] ieee80211 phy0: I
iwl3945_irq_handle_error Restarting adapter due to uCode error.
Jan 26 21:30:43 rainbow kernel: [  123.656183] ieee80211 phy0: I
iwl3945_rx_handle r = 21, i = 20, REPLY_ERROR, 0x02
Jan 26 21:30:43 rainbow kernel: [  123.656183] iwl3945 0000:03:00.0:
Error Reply type 0x00000005 cmd REPLY_PHY_CALIBRATION_CMD (0xB0) seq
0x013A ser 0x004E0000
Jan 26 21:30:43 rainbow kernel: [  123.717881] ieee80211 phy0: U
__iwl3945_down iwl3945 is going down
Jan 26 21:30:43 rainbow kernel: [  123.718171] ieee80211 phy0: U
iwl3945_apm_stop_master stop master
Jan 26 21:30:43 rainbow kernel: [  123.718874] ieee80211 phy0: U
iwl3945_apm_stop_master stop master
Jan 26 21:30:43 rainbow kernel: [  123.718988] ieee80211 phy0: U
iwl3945_clear_free_frames 0 frames on pre-allocated heap on clear.
Jan 26 21:30:43 rainbow kernel: [  123.719009] ieee80211 phy0: U
iwl3945_power_init_handle Initialize power
Jan 26 21:30:43 rainbow kernel: [  123.719026] ieee80211 phy0: U
iwl3945_power_init_handle adjust power command flags
Jan 26 21:30:43 rainbow kernel: [  123.719138] ieee80211 phy0: U
iwl3945_hw_nic_init HW Revision ID = 0x2
Jan 26 21:30:43 rainbow kernel: [  123.719191] ieee80211 phy0: U
iwl3945_nic_config 3945 RADIO-MM type
Jan 26 21:30:43 rainbow kernel: [  123.719203] ieee80211 phy0: U
iwl3945_nic_config SKU OP mode is basic
Jan 26 21:30:43 rainbow kernel: [  123.719210] ieee80211 phy0: U
iwl3945_nic_config 3945ABG revision is 0xF1
Jan 26 21:30:43 rainbow kernel: [  123.719223] ieee80211 phy0: U
iwl3945_nic_config Card M type B version is 0x3
Jan 26 21:30:43 rainbow kernel: [  123.722834] ieee80211 phy0: U
iwl3945_load_bsm Begin load bsm
Jan 26 21:30:43 rainbow kernel: [  123.724106] ieee80211 phy0: U
iwl3945_verify_bsm Begin verify bsm
Jan 26 21:30:43 rainbow kernel: [  123.726341] ieee80211 phy0: U
iwl3945_verify_bsm BSM bootstrap uCode image OK
Jan 26 21:30:43 rainbow kernel: [  123.726401] ieee80211 phy0: U
iwl3945_load_bsm BSM write complete, poll 1 iterations
Jan 26 21:30:43 rainbow kernel: [  123.726421] ieee80211 phy0: U
__iwl3945_up iwl3945 is coming up
Jan 26 21:30:43 rainbow kernel: [  123.737852] ieee80211 phy0: I
iwl3945_rx_handle r = 1, i = 0, REPLY_ALIVE, 0x01
Jan 26 21:30:43 rainbow kernel: [  123.737872] ieee80211 phy0: I
iwl3945_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x9
Jan 26 21:30:43 rainbow kernel: [  123.737882] ieee80211 phy0: I
iwl3945_rx_reply_alive Initialization Alive received.
Jan 26 21:30:43 rainbow kernel: [  123.748038] ieee80211 phy0: U
iwl3945_verify_inst_sparse ucode inst image size is 900
Jan 26 21:30:43 rainbow kernel: [  123.748142] ieee80211 phy0: U
iwl3945_verify_inst_sparse ucode inst image size is 2672
Jan 26 21:30:43 rainbow kernel: [  123.748439] ieee80211 phy0: U
iwl3945_verify_ucode Initialize uCode is good in inst SRAM
Jan 26 21:30:43 rainbow kernel: [  123.748447] ieee80211 phy0: U
iwl3945_init_alive_start Initialization Alive received.
Jan 26 21:30:43 rainbow kernel: [  123.748497] ieee80211 phy0: U
iwl3945_set_ucode_ptrs Runtime uCode pointers are set.
Jan 26 21:30:43 rainbow kernel: [  123.752858] ieee80211 phy0: I
iwl3945_rx_handle r = 2, i = 1, REPLY_ALIVE, 0x01
Jan 26 21:30:43 rainbow kernel: [  123.752876] ieee80211 phy0: I
iwl3945_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x0
Jan 26 21:30:43 rainbow kernel: [  123.752886] ieee80211 phy0: I
iwl3945_rx_reply_alive Runtime Alive received.
Jan 26 21:30:43 rainbow kernel: [  123.752935] ieee80211 phy0: I
iwl3945_disable_events Selected uCode log events may be disabled
Jan 26 21:30:43 rainbow kernel: [  123.752944] ieee80211 phy0: I
iwl3945_disable_events   by writing "1"s into disable bitmap
Jan 26 21:30:43 rainbow kernel: [  123.752952] ieee80211 phy0: I
iwl3945_disable_events   in SRAM at 0x8022c8, size 47 u32s
Jan 26 21:30:43 rainbow kernel: [  123.760026] ieee80211 phy0: U
iwl3945_alive_start Runtime Alive received.
Jan 26 21:30:43 rainbow kernel: [  123.760041] ieee80211 phy0: U
iwl3945_verify_inst_sparse ucode inst image size is 900
Jan 26 21:30:43 rainbow kernel: [  123.760130] ieee80211 phy0: U
iwl3945_verify_inst_sparse ucode inst image size is 2672
Jan 26 21:30:43 rainbow kernel: [  123.760217] ieee80211 phy0: U
iwl3945_verify_inst_sparse ucode inst image size is 80684
Jan 26 21:30:43 rainbow kernel: [  123.767880] ieee80211 phy0: U
iwl3945_verify_ucode Runtime uCode is good in inst SRAM
Jan 26 21:30:43 rainbow kernel: [  123.767917] ieee80211 phy0: U
iwl3945_alive_start RFKILL status: 0x1
Jan 26 21:30:43 rainbow kernel: [  123.767949] ieee80211 phy0: U
iwl3945_update_power_cmd Flags value = 0x00000008
Jan 26 21:30:43 rainbow kernel: [  123.767957] ieee80211 phy0: U
iwl3945_update_power_cmd Tx timeout = 0
Jan 26 21:30:43 rainbow kernel: [  123.767965] ieee80211 phy0: U
iwl3945_update_power_cmd Rx timeout = 0
Jan 26 21:30:43 rainbow kernel: [  123.767973] ieee80211 phy0: U
iwl3945_update_power_cmd Sleep interval vector = { 0 , 0 , 0 , 0 , 0 }
Jan 26 21:30:43 rainbow kernel: [  123.767989] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command POWER_TABLE_CMD (#77), seq: 0x0400,
36 bytes at 0[0]:4
Jan 26 21:30:43 rainbow kernel: [  123.768076] ieee80211 phy0: I
iwl3945_rx_handle r 3 i 2 No handler needed for POWER_TABLE_CMD, 0x77
Jan 26 21:30:43 rainbow kernel: [  123.768108] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_BT_CONFIG (#9b), seq: 0x0401,
16 bytes at 1[1]:4
Jan 26 21:30:43 rainbow kernel: [  123.768182] ieee80211 phy0: I
iwl3945_rx_handle r 4 i 3 No handler needed for REPLY_BT_CONFIG, 0x9b
Jan 26 21:30:43 rainbow kernel: [  123.768206] ieee80211 phy0: U
iwl3945_commit_rxon Sending RXON
Jan 26 21:30:43 rainbow kernel: [  123.768208] * without RXON_FILTER_ASSOC_MSK
Jan 26 21:30:43 rainbow kernel: [  123.768211] * channel = 11
Jan 26 21:30:43 rainbow kernel: [  123.768212] * bssid = 00:00:00:00:00:00
Jan 26 21:30:43 rainbow kernel: [  123.768233] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x0402, 48
bytes at 2[2]:4
Jan 26 21:30:43 rainbow kernel: [  123.769460] ieee80211 phy0: I
iwl3945_rx_handle r 5 i 4 No handler needed for REPLY_RXON, 0x10
Jan 26 21:30:43 rainbow kernel: [  123.769489] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x0d
Jan 26 21:30:43 rainbow kernel: [  123.769500] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x0f
Jan 26 21:30:43 rainbow kernel: [  123.769509] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x05
Jan 26 21:30:43 rainbow kernel: [  123.769517] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x07
Jan 26 21:30:43 rainbow kernel: [  123.769527] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x09
Jan 26 21:30:43 rainbow kernel: [  123.769535] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x0b
Jan 26 21:30:43 rainbow kernel: [  123.769543] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x01
Jan 26 21:30:43 rainbow kernel: [  123.769554] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 115 rate code 0x03
Jan 26 21:30:43 rainbow kernel: [  123.769562] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 119 rate code 0x0a
Jan 26 21:30:43 rainbow kernel: [  123.769571] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 119 rate code 0x14
Jan 26 21:30:43 rainbow kernel: [  123.769581] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 119 rate code 0x37
Jan 26 21:30:43 rainbow kernel: [  123.769589] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 119 rate code 0x6e
Jan 26 21:30:43 rainbow kernel: [  123.769601] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq:
0x0403, 56 bytes at 3[3]:4
Jan 26 21:30:43 rainbow kernel: [  123.769703] ieee80211 phy0: I
iwl3945_rx_handle r 6 i 5 No handler needed for
REPLY_TX_PWR_TABLE_CMD, 0x97
Jan 26 21:30:43 rainbow kernel: [  123.769726] ieee80211 phy0: U
iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
Jan 26 21:30:43 rainbow kernel: [  123.769741] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0404, 68
bytes at 4[4]:4
Jan 26 21:30:43 rainbow kernel: [  123.769821] ieee80211 phy0: I
iwl3945_rx_handle r = 7, i = 6, REPLY_ADD_STA, 0x18
Jan 26 21:30:43 rainbow kernel: [  123.769840] ieee80211 phy0: U
iwl3945_send_add_station REPLY_ADD_STA PASSED
Jan 26 21:30:43 rainbow kernel: [  123.769862] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0405,
56 bytes at 5[5]:4
Jan 26 21:30:43 rainbow kernel: [  123.769937] ieee80211 phy0: I
iwl3945_rx_handle r 8 i 7 No handler needed for REPLY_RATE_SCALE, 0x47
Jan 26 21:30:43 rainbow kernel: [  123.769962] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0406,
56 bytes at 6[6]:4
Jan 26 21:30:43 rainbow kernel: [  123.770092] ieee80211 phy0: I
iwl3945_rx_handle r 9 i 8 No handler needed for REPLY_RATE_SCALE, 0x47
Jan 26 21:30:43 rainbow kernel: [  123.770122] ieee80211 phy0: U
iwl3945_hw_reg_txpower_get_temperature Temperature: 92
Jan 26 21:30:43 rainbow kernel: [  123.770131] ieee80211 phy0: U
is_temp_calib_needed Getting warmer, delta 41,
Jan 26 21:30:43 rainbow kernel: [  123.770139] ieee80211 phy0: U
is_temp_calib_needed Timed thermal calib needed
Jan 26 21:30:43 rainbow kernel: [  123.770160] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 235 dsp 109 rate code 0x0d
Jan 26 21:30:43 rainbow kernel: [  123.770168] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 235 dsp 109 rate code 0x0f
Jan 26 21:30:43 rainbow kernel: [  123.770179] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 235 dsp 109 rate code 0x05
Jan 26 21:30:43 rainbow kernel: [  123.770187] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 235 dsp 109 rate code 0x07
Jan 26 21:30:43 rainbow kernel: [  123.770196] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 235 dsp 109 rate code 0x09
Jan 26 21:30:43 rainbow kernel: [  123.770205] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 235 dsp 109 rate code 0x0b
Jan 26 21:30:43 rainbow kernel: [  123.770214] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 235 dsp 109 rate code 0x01
Jan 26 21:30:43 rainbow kernel: [  123.770222] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 235 dsp 109 rate code 0x03
Jan 26 21:30:43 rainbow kernel: [  123.770232] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 171 dsp  98 rate code 0x0a
Jan 26 21:30:43 rainbow kernel: [  123.770241] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 171 dsp  98 rate code 0x14
Jan 26 21:30:43 rainbow kernel: [  123.770249] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 171 dsp  98 rate code 0x37
Jan 26 21:30:43 rainbow kernel: [  123.770259] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 171 dsp  98 rate code 0x6e
Jan 26 21:30:43 rainbow kernel: [  123.770324] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq:
0x0407, 56 bytes at 7[7]:4
Jan 26 21:30:43 rainbow kernel: [  123.770436] ieee80211 phy0: I
iwl3945_rx_handle r 10 i 9 No handler needed for
REPLY_TX_PWR_TABLE_CMD, 0x97
Jan 26 21:30:43 rainbow kernel: [  123.770548] Registered led device:
iwl-phy0:radio
Jan 26 21:30:43 rainbow kernel: [  123.770557] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0408, 12
bytes at 8[8]:4
Jan 26 21:30:43 rainbow kernel: [  123.770636] ieee80211 phy0: I
iwl3945_rx_handle r 11 i 10 No handler needed for REPLY_LEDS_CMD, 0x48
Jan 26 21:30:43 rainbow kernel: [  123.770671] Registered led device:
iwl-phy0:assoc
Jan 26 21:30:43 rainbow kernel: [  123.770710] Registered led device:
iwl-phy0:RX
Jan 26 21:30:43 rainbow kernel: [  123.770745] Registered led device:
iwl-phy0:TX
Jan 26 21:30:43 rainbow kernel: [  123.770750] ieee80211 phy0: U
iwl3945_alive_start ALIVE processing complete.
Jan 26 21:30:43 rainbow kernel: [  123.785388] ieee80211 phy0: I
iwl3945_rx_handle r = 12, i = 11, REPLY_3945_RX, 0x1b
Jan 26 21:30:43 rainbow kernel: [  123.837564] ieee80211 phy0: I
iwl3945_rx_handle r = 13, i = 12, REPLY_3945_RX, 0x1b
Jan 26 21:30:43 rainbow kernel: [  123.850659] ieee80211 phy0: I
iwl3945_rx_handle r = 14, i = 13, REPLY_3945_RX, 0x1b
Jan 26 21:30:43 rainbow kernel: [  123.853017] wlan0: direct probe to
AP 00:30:bd:c0:90:24 try 2
Jan 26 21:30:43 rainbow kernel: [  123.853032] ieee80211 phy0: I
iwl3945_mac_tx enter
Jan 26 21:30:43 rainbow kernel: [  123.853043] ieee80211 phy0: I
iwl3945_mac_tx leave
Jan 26 21:30:43 rainbow kernel: [  123.853124] ieee80211 phy0: I
iwl3945_rx_handle r = 15, i = 14, REPLY_TX, 0x1c
Jan 26 21:30:43 rainbow kernel: [  124.052027] wlan0: direct probe to
AP 00:30:bd:c0:90:24 try 3
Jan 26 21:30:43 rainbow kernel: [  124.052045] ieee80211 phy0: I
iwl3945_mac_tx enter
Jan 26 21:30:43 rainbow kernel: [  124.052060] ieee80211 phy0: I
iwl3945_mac_tx leave
Jan 26 21:30:43 rainbow kernel: [  124.052127] ieee80211 phy0: I
iwl3945_rx_handle r 17 i 15 No handler needed for UNKNOWN, 0x40
Jan 26 21:30:43 rainbow kernel: [  124.052146] ------------[ cut here
]------------
Jan 26 21:30:43 rainbow kernel: [  124.052148] WARNING: at
drivers/net/wireless/iwlwifi/iwl3945-base.c:2804
iwl3945_irq_tasklet+0x10e2/0x1500 [iwl3945]()
Jan 26 21:30:43 rainbow kernel: [  124.052151] Hardware name: 7658CTO
Jan 26 21:30:43 rainbow kernel: [  124.052153] wrong command queue 0,
sequence 0x0 readp=9 writep=9
Jan 26 21:30:43 rainbow kernel: [  124.052156] Modules linked in:
af_packet i915 drm i2c_algo_bit i2c_core binfmt_misc ipv6 acpi_cpufreq
cpufreq_ondemand cpufreq_stats cpufreq_powersave cpufreq_userspace
cpufreq_conservative freq_table pci_slot sbs sbshc container
iptable_filter ip_tables x_tables sbp2 arc4 ecb snd_hda_codec_analog
iwl3945 iwlcore snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss
snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi mac80211 snd_rawmidi
snd_seq_midi_event joydev snd_seq lib80211 pcmcia evdev snd_timer
snd_seq_device thinkpad_acpi rfkill intel_agp cfg80211 snd soundcore
led_class yenta_socket rsrc_nonstatic serio_raw pcspkr snd_page_alloc
nvram pcmcia_core iTCO_wdt iTCO_vendor_support psmouse video output
battery ac wmi shpchp pci_hotplug button ext3 jbd mbcache sr_mod cdrom
sd_mod crc_t10dif sg ata_piix ata_generic ahci pata_acpi libata
ohci1394 scsi_mod ieee1394 ehci_hcd uhci_hcd usbcore thermal processor
fan fuse
Jan 26 21:30:43 rainbow kernel: [  124.052235] Pid: 5851, comm:
apt-check Not tainted 2.6.29-rc2-wl #25
Jan 26 21:30:43 rainbow kernel: [  124.052238] Call Trace:
Jan 26 21:30:43 rainbow kernel: [  124.052241]  <IRQ>
[<ffffffff80250440>] warn_slowpath+0xd0/0x130
Jan 26 21:30:43 rainbow kernel: [  124.052253]  [<ffffffff8023cc2d>] ?
resched_task+0x2d/0x90
Jan 26 21:30:43 rainbow kernel: [  124.052259]  [<ffffffff8051d9a0>] ?
printk+0x67/0x6f
Jan 26 21:30:43 rainbow kernel: [  124.052264]  [<ffffffff80246ded>] ?
default_wake_function+0xd/0x10
Jan 26 21:30:43 rainbow kernel: [  124.052269]  [<ffffffff803bbc41>] ?
swiotlb_bounce+0x21/0x50
Jan 26 21:30:43 rainbow kernel: [  124.052272]  [<ffffffff803bbd05>] ?
sync_single+0x95/0xb0
Jan 26 21:30:43 rainbow kernel: [  124.052275]  [<ffffffff803bbf60>] ?
swiotlb_sync_single+0x60/0x70
Jan 26 21:30:43 rainbow kernel: [  124.052286]  [<ffffffffa03debf2>]
iwl3945_irq_tasklet+0x10e2/0x1500 [iwl3945]
Jan 26 21:30:43 rainbow kernel: [  124.052292]  [<ffffffff8025b5e0>] ?
run_timer_softirq+0x220/0x260
Jan 26 21:30:43 rainbow kernel: [  124.052296]  [<ffffffff80255e36>]
tasklet_action+0x86/0x110
Jan 26 21:30:43 rainbow kernel: [  124.052299]  [<ffffffff802567ac>]
__do_softirq+0x9c/0x170
Jan 26 21:30:43 rainbow kernel: [  124.052303]  [<ffffffff80214a5c>]
call_softirq+0x1c/0x30
Jan 26 21:30:43 rainbow kernel: [  124.052306]  [<ffffffff80215f4d>]
do_softirq+0x5d/0xa0
Jan 26 21:30:43 rainbow kernel: [  124.052309]  [<ffffffff80256505>]
irq_exit+0x75/0xa0
Jan 26 21:30:43 rainbow kernel: [  124.052312]  [<ffffffff802161d6>]
do_IRQ+0x86/0x110
Jan 26 21:30:43 rainbow kernel: [  124.052315]  [<ffffffff802141d3>]
ret_from_intr+0x0/0x29
Jan 26 21:30:43 rainbow kernel: [  124.052317]  <EOI> <4>---[ end
trace b56d100a0de59941 ]---
Jan 26 21:30:43 rainbow kernel: [  124.052322] iwl data: 00000000: 00
60 34 20 00 00 00 00 00 00 00 00 00 00 00 00  .`4 ............
Jan 26 21:30:43 rainbow kernel: [  124.052325] iwl data: 00000010: 00
80 97 35 01 88 ff ff 00 01 10 00 00 00 00 00  ...5............
Jan 26 21:30:43 rainbow kernel: [  124.052336] ieee80211 phy0: I
iwl3945_rx_handle r 17 i 16 No handler needed for UNKNOWN, 0x00
Jan 26 21:30:43 rainbow kernel: [  124.052348] ------------[ cut here
]------------
Jan 26 21:30:43 rainbow kernel: [  124.052351] WARNING: at
drivers/net/wireless/iwlwifi/iwl3945-base.c:2804
iwl3945_irq_tasklet+0x10e2/0x1500 [iwl3945]()
Jan 26 21:30:43 rainbow kernel: [  124.052353] Hardware name: 7658CTO
Jan 26 21:30:43 rainbow kernel: [  124.052355] wrong command queue 0,
sequence 0x0 readp=9 writep=9
Jan 26 21:30:43 rainbow kernel: [  124.052357] Modules linked in:
af_packet i915 drm i2c_algo_bit i2c_core binfmt_misc ipv6 acpi_cpufreq
cpufreq_ondemand cpufreq_stats cpufreq_powersave cpufreq_userspace
cpufreq_conservative freq_table pci_slot sbs sbshc container
iptable_filter ip_tables x_tables sbp2 arc4 ecb snd_hda_codec_analog
iwl3945 iwlcore snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss
snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi mac80211 snd_rawmidi
snd_seq_midi_event joydev snd_seq lib80211 pcmcia evdev snd_timer
snd_seq_device thinkpad_acpi rfkill intel_agp cfg80211 snd soundcore
led_class yenta_socket rsrc_nonstatic serio_raw pcspkr snd_page_alloc
nvram pcmcia_core iTCO_wdt iTCO_vendor_support psmouse video output
battery ac wmi shpchp pci_hotplug button ext3 jbd mbcache sr_mod cdrom
sd_mod crc_t10dif sg ata_piix ata_generic ahci pata_acpi libata
ohci1394 scsi_mod ieee1394 ehci_hcd uhci_hcd usbcore thermal processor
fan fuse
Jan 26 21:30:43 rainbow kernel: [  124.052424] Pid: 5851, comm:
apt-check Tainted: G        W  2.6.29-rc2-wl #25
Jan 26 21:30:43 rainbow kernel: [  124.052426] Call Trace:
Jan 26 21:30:43 rainbow kernel: [  124.052427]  <IRQ>
[<ffffffff80250440>] warn_slowpath+0xd0/0x130
Jan 26 21:30:43 rainbow kernel: [  124.052438]  [<ffffffff8051d9a0>] ?
printk+0x67/0x6f
Jan 26 21:30:43 rainbow kernel: [  124.052442]  [<ffffffff803bc0de>] ?
unmap_single+0x13e/0x170
Jan 26 21:30:43 rainbow kernel: [  124.052446]  [<ffffffff803bbc41>] ?
swiotlb_bounce+0x21/0x50
Jan 26 21:30:43 rainbow kernel: [  124.052449]  [<ffffffff803bbd05>] ?
sync_single+0x95/0xb0
Jan 26 21:30:43 rainbow kernel: [  124.052452]  [<ffffffff803bbf60>] ?
swiotlb_sync_single+0x60/0x70
Jan 26 21:30:43 rainbow kernel: [  124.052464]  [<ffffffffa03debf2>]
iwl3945_irq_tasklet+0x10e2/0x1500 [iwl3945]
Jan 26 21:30:43 rainbow kernel: [  124.052469]  [<ffffffff8025b5e0>] ?
run_timer_softirq+0x220/0x260
Jan 26 21:30:43 rainbow kernel: [  124.052472]  [<ffffffff80255e36>]
tasklet_action+0x86/0x110
Jan 26 21:30:43 rainbow kernel: [  124.052475]  [<ffffffff802567ac>]
__do_softirq+0x9c/0x170
Jan 26 21:30:43 rainbow kernel: [  124.052479]  [<ffffffff80214a5c>]
call_softirq+0x1c/0x30
Jan 26 21:30:43 rainbow kernel: [  124.052482]  [<ffffffff80215f4d>]
do_softirq+0x5d/0xa0
Jan 26 21:30:43 rainbow kernel: [  124.052485]  [<ffffffff80256505>]
irq_exit+0x75/0xa0
Jan 26 21:30:43 rainbow kernel: [  124.052488]  [<ffffffff802161d6>]
do_IRQ+0x86/0x110
Jan 26 21:30:43 rainbow kernel: [  124.052491]  [<ffffffff802141d3>]
ret_from_intr+0x0/0x29
Jan 26 21:30:43 rainbow kernel: [  124.052493]  <EOI> <4>---[ end
trace b56d100a0de59942 ]---
Jan 26 21:30:43 rainbow kernel: [  124.052496] iwl data: 00000000: 00
70 34 20 00 00 00 00 00 00 00 00 00 00 00 00  .p4 ............
Jan 26 21:30:43 rainbow kernel: [  124.052499] iwl data: 00000010: 00
88 97 35 01 88 ff ff 00 01 10 00 00 00 00 00  ...5............
Jan 26 21:30:43 rainbow kernel: [  124.052547] iwl3945 0000:03:00.0:
Microcode SW error detected. Restarting 0x82000008.
Jan 26 21:30:43 rainbow kernel: [  124.052576] iwl3945 0000:03:00.0:
Start IWL Error Log Dump:
Jan 26 21:30:43 rainbow kernel: [  124.052579] iwl3945 0000:03:00.0:
Status: 0x000202E4, count: 1
Jan 26 21:30:43 rainbow kernel: [  124.052583] iwl3945 0000:03:00.0:
Desc       Time       asrtPC  blink2 ilink1  nmiPC   Line
Jan 26 21:30:43 rainbow kernel: [  124.052652] iwl3945 0000:03:00.0:
SYSASSERT     (#5) 0000283943 0x0089A 0x00342 0x00304 0x00000 267
Jan 26 21:30:43 rainbow kernel: [  124.052654]
Jan 26 21:30:43 rainbow kernel: [  124.052717] iwl3945 0000:03:00.0:
Start IWL Event Log Dump: display count 512, wraps 2
Jan 26 21:30:43 rainbow kernel: [  124.052749] iwl3945 0000:03:00.0:
0000052635^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  124.052780] iwl3945 0000:03:00.0:
0000052662^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  124.052811] iwl3945 0000:03:00.0:
0000052664^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  124.052842] iwl3945 0000:03:00.0:
0000052673^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  124.052874] iwl3945 0000:03:00.0:
0000052685^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  124.052905] iwl3945 0000:03:00.0:
0000052687^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  124.052936] iwl3945 0000:03:00.0:
0000052696^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  124.052967] iwl3945 0000:03:00.0:
0000052711^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  124.052998] iwl3945 0000:03:00.0:
0000052713^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  124.053029] iwl3945 0000:03:00.0:
0000052722^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  124.053060] iwl3945 0000:03:00.0:
0000052743^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  124.053091] iwl3945 0000:03:00.0:
0000052745^I0x00000000^I0302
Jan 26 21:30:43 rainbow kernel: [  124.053122] iwl3945 0000:03:00.0:
0000052752^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  124.053154] iwl3945 0000:03:00.0:
0000053609^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  124.053185] iwl3945 0000:03:00.0:
0000053610^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  124.053216] iwl3945 0000:03:00.0:
0000053773^I0x00000024^I0353
Jan 26 21:30:43 rainbow kernel: [  124.053247] iwl3945 0000:03:00.0:
0000055507^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  124.053278] iwl3945 0000:03:00.0:
0000055509^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  124.053309] iwl3945 0000:03:00.0:
0000055582^I0x00000025^I0353
Jan 26 21:30:43 rainbow kernel: [  124.053340] iwl3945 0000:03:00.0:
0000055593^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  124.053371] iwl3945 0000:03:00.0:
0000056191^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  124.053402] iwl3945 0000:03:00.0:
0000056193^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  124.053433] iwl3945 0000:03:00.0:
0000056267^I0x00000026^I0353
Jan 26 21:30:43 rainbow kernel: [  124.053464] iwl3945 0000:03:00.0:
0000056277^I0x00000000^I0352
Jan 26 21:30:43 rainbow kernel: [  124.053495] iwl3945 0000:03:00.0:
0000058460^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  124.053527] iwl3945 0000:03:00.0:
0000058462^I0x00000000^I0302
Jan 26 21:30:43 rainbow kernel: [  124.053558] iwl3945 0000:03:00.0:
0000058502^I0x00000028^I0353
Jan 26 21:30:43 rainbow kernel: [  124.053589] iwl3945 0000:03:00.0:
0000058533^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  124.053620] iwl3945 0000:03:00.0:
0000058535^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  124.053651] iwl3945 0000:03:00.0:
0000058544^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  124.053682] iwl3945 0000:03:00.0:
0000058581^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  124.053714] iwl3945 0000:03:00.0:
0000058583^I0x00000000^I0302
Jan 26 21:30:43 rainbow kernel: [  124.053745] iwl3945 0000:03:00.0:
0000058607^I0x00000029^I0353
Jan 26 21:30:43 rainbow kernel: [  124.053776] iwl3945 0000:03:00.0:
0000058625^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  124.053811] iwl3945 0000:03:00.0:
0000058627^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  124.053842] iwl3945 0000:03:00.0:
0000058636^I0x00008000^I0350
Jan 26 21:30:43 rainbow kernel: [  124.053873] iwl3945 0000:03:00.0:
0000058657^I0x000000d9^I0106
Jan 26 21:30:43 rainbow kernel: [  124.053904] iwl3945 0000:03:00.0:
0000058659^I0x00000000^I0301
Jan 26 21:30:43 rainbow kernel: [  124.053935] iwl3945 0000:03:00.0:
0000058669^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.053966] iwl3945 0000:03:00.0:
0000058704^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.054003] iwl3945 0000:03:00.0:
0000058706^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.054034] iwl3945 0000:03:00.0:
0000058715^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.054065] iwl3945 0000:03:00.0:
0000058731^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.054096] iwl3945 0000:03:00.0:
0000058733^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.054127] iwl3945 0000:03:00.0:
0000058741^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.054158] iwl3945 0000:03:00.0:
0000058760^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.054189] iwl3945 0000:03:00.0:
0000058762^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.054220] iwl3945 0000:03:00.0:
0000058770^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.054251] iwl3945 0000:03:00.0:
0000058789^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.054282] iwl3945 0000:03:00.0:
0000058791^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.054316] iwl3945 0000:03:00.0:
0000058799^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.054347] iwl3945 0000:03:00.0:
0000058831^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.054377] iwl3945 0000:03:00.0:
0000058832^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.054408] iwl3945 0000:03:00.0:
0000058841^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.054439] iwl3945 0000:03:00.0:
0000058848^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.054470] iwl3945 0000:03:00.0:
0000058850^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.054503] iwl3945 0000:03:00.0:
0000058859^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.054534] iwl3945 0000:03:00.0:
0000058907^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.054565] iwl3945 0000:03:00.0:
0000058909^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.054596] iwl3945 0000:03:00.0:
0000058918^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.054627] iwl3945 0000:03:00.0:
0000058945^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.054658] iwl3945 0000:03:00.0:
0000058947^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.054689] iwl3945 0000:03:00.0:
0000058956^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.054720] iwl3945 0000:03:00.0:
0000058977^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.054751] iwl3945 0000:03:00.0:
0000058978^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.054782] iwl3945 0000:03:00.0:
0000058988^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.054815] iwl3945 0000:03:00.0:
0000058994^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.054846] iwl3945 0000:03:00.0:
0000058996^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.054877] iwl3945 0000:03:00.0:
0000059037^I0x0000002a^I0353
Jan 26 21:30:44 rainbow kernel: [  124.054908] iwl3945 0000:03:00.0:
0000059062^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.054940] iwl3945 0000:03:00.0:
0000059063^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.054972] iwl3945 0000:03:00.0:
0000059097^I0x0000002b^I0353
Jan 26 21:30:44 rainbow kernel: [  124.055003] iwl3945 0000:03:00.0:
0000059124^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.055034] iwl3945 0000:03:00.0:
0000059125^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.055065] iwl3945 0000:03:00.0:
0000059134^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.055096] iwl3945 0000:03:00.0:
0000059157^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.055127] iwl3945 0000:03:00.0:
0000059159^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.055158] iwl3945 0000:03:00.0:
0000059167^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.055189] iwl3945 0000:03:00.0:
0000059206^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.055220] iwl3945 0000:03:00.0:
0000059208^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.055252] iwl3945 0000:03:00.0:
0000059216^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.055284] iwl3945 0000:03:00.0:
0000059245^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.055315] iwl3945 0000:03:00.0:
0000059247^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.055346] iwl3945 0000:03:00.0:
0000059257^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.055377] iwl3945 0000:03:00.0:
0000059266^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.055408] iwl3945 0000:03:00.0:
0000059268^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.055439] iwl3945 0000:03:00.0:
0000059277^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.055471] iwl3945 0000:03:00.0:
0000059291^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.055502] iwl3945 0000:03:00.0:
0000059293^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.055533] iwl3945 0000:03:00.0:
0000059332^I0x0000002c^I0353
Jan 26 21:30:44 rainbow kernel: [  124.055564] iwl3945 0000:03:00.0:
0000059348^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.055595] iwl3945 0000:03:00.0:
0000059349^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.055626] iwl3945 0000:03:00.0:
0000059353^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.055658] iwl3945 0000:03:00.0:
0000059362^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.055689] iwl3945 0000:03:00.0:
0000059364^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.055720] iwl3945 0000:03:00.0:
0000059404^I0x0000002d^I0353
Jan 26 21:30:44 rainbow kernel: [  124.055751] iwl3945 0000:03:00.0:
0000059446^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.055783] iwl3945 0000:03:00.0:
0000059448^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.055814] iwl3945 0000:03:00.0:
0000059471^I0x0000002e^I0353
Jan 26 21:30:44 rainbow kernel: [  124.055845] iwl3945 0000:03:00.0:
0000060497^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.055876] iwl3945 0000:03:00.0:
0000060499^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.055907] iwl3945 0000:03:00.0:
0000060507^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.055938] iwl3945 0000:03:00.0:
0000060529^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.055970] iwl3945 0000:03:00.0:
0000060531^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056001] iwl3945 0000:03:00.0:
0000060539^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000060557^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000060559^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000060599^I0x0000002f^I0353
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000060638^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000060640^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000060663^I0x00000030^I0353
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000060745^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000060747^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000060787^I0x00000031^I0353
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000060818^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000060820^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000060897^I0x00000027^I0353
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000060908^I0x00000000^I0352
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000060914^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000060916^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000060926^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000060945^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000060947^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000060956^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000060986^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000060988^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000061224^I0x00000028^I0353
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000061234^I0x00000000^I0352
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000061246^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000061247^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000061287^I0x00000032^I0353
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000061321^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000061323^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000061331^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000061363^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000061364^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000061373^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000061396^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000061398^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000061406^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000061698^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000061700^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000061731^I0x00000033^I0353
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000062278^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000062280^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000062289^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000062330^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000062332^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000062372^I0x00000034^I0353
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000062389^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000062391^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000062412^I0x00000035^I0353
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000062447^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000062448^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000062457^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000062467^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000062468^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000062477^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000062500^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000062502^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000062544^I0x00000036^I0353
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000062554^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000062564^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000062594^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000062596^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000062604^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000062658^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000062660^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000062699^I0x00000037^I0353
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000062743^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000062745^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000062786^I0x00000038^I0353
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000062849^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000062851^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000062860^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000062905^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000062907^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000062915^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000062932^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000062934^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000062942^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000062958^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000062960^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000062969^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000062983^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000062985^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000062993^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000063001^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000063003^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000063011^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000063025^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000063027^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000063035^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000063046^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000063047^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000063056^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000063075^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000063077^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000063086^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000063094^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000063096^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000063104^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000063121^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000063122^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000063131^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000063139^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000063141^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000063149^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000063183^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000063184^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000063193^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000063224^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000063226^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000063234^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000063243^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000063244^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000063276^I0x00000039^I0353
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000063301^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000063303^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000063313^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000063322^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000063323^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000063333^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000063343^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000063345^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000063354^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000063427^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000063429^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000063438^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000063447^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000063449^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000063458^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000063986^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000063988^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000064061^I0x00000029^I0353
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000064071^I0x00000000^I0352
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000064079^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000064081^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000064150^I0x0000002a^I0353
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000064160^I0x00000000^I0352
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000064167^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000064169^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000064238^I0x0000002b^I0353
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000064249^I0x00000000^I0352
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000064259^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000064260^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000064335^I0x0000002c^I0353
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000064345^I0x00000000^I0352
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000064372^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000064374^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000064459^I0x0000002d^I0353
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000064470^I0x00000000^I0352
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000064480^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000064482^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000064559^I0x0000002e^I0353
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000064569^I0x00000000^I0352
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000064583^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000064585^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000064595^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000064614^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000064616^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000064692^I0x0000002f^I0353
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000064702^I0x00000000^I0352
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000064713^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000064715^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000064803^I0x00000030^I0353
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000064813^I0x00000000^I0352
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000064843^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000064845^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000064921^I0x00000031^I0353
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000064931^I0x00000000^I0352
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000064989^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000064991^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000065079^I0x00000032^I0353
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000065089^I0x00000000^I0352
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000065104^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000065106^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000065201^I0x00000033^I0353
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000065211^I0x00000000^I0352
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000065218^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000065220^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000065289^I0x00000034^I0353
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000065299^I0x00000000^I0352
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000065306^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000065308^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000065379^I0x00000035^I0353
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000065390^I0x00000000^I0352
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000065397^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000065398^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000065471^I0x00000036^I0353
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000065482^I0x00000000^I0352
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000065494^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000065496^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000065571^I0x00000037^I0353
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000065582^I0x00000000^I0352
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000065602^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000065604^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000065700^I0x00000038^I0353
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000065710^I0x00000000^I0352
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000065729^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000065731^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000065805^I0x00000039^I0353
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000065815^I0x00000000^I0352
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000065822^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000065824^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000065894^I0x0000003a^I0353
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000065904^I0x00000000^I0352
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000065919^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000065921^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000066075^I0x0000003b^I0353
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000066085^I0x00000000^I0352
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000066102^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000066104^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000066179^I0x0000003c^I0353
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000066195^I0x00000000^I0352
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000066217^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000066219^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000066294^I0x0000003d^I0353
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000066304^I0x00000000^I0352
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000068074^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000068076^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000068462^I0x00000000^I0356
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000069187^I0x00000003^I0310
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000069947^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000069949^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000070022^I0x0000003e^I0353
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000070032^I0x00000000^I0352
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000071245^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000071247^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000071323^I0x0000003f^I0353
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000071333^I0x00000000^I0352
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000071492^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000071494^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000071570^I0x00000040^I0353
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000071581^I0x00000000^I0352
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000072876^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000072878^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000073061^I0x00000041^I0353
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000075061^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000075063^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000075071^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000075094^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000075096^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000075136^I0x0000003a^I0353
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000075169^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000075170^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000075180^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000075194^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000075196^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000075205^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000075232^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000075234^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000075242^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000075294^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000075296^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000075306^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000075330^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000075332^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000075341^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000075423^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000075425^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000075434^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000075444^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000075446^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000075471^I0x0000003b^I0353
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000075546^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000075547^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000075557^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000075567^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000075569^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000075577^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000075755^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000075757^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000075765^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000075797^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000075798^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000075838^I0x0000003c^I0353
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000075855^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000075857^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000075897^I0x00000000^I0304
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000077084^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000077085^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000077125^I0x0000003d^I0353
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000077151^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000077153^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000077162^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000077192^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000077193^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000077202^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000077211^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000077213^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000077220^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000077234^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000077235^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000077276^I0x0000003e^I0353
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000077291^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000077293^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000077312^I0x0000003f^I0353
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000077345^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000077346^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000077389^I0x00000040^I0353
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000077399^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000077408^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000077449^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000077451^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000077459^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000077502^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000077504^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000077512^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000077529^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000077531^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000077541^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000077557^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000077559^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000077567^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000077702^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000077704^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000077712^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000077748^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000077750^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000077759^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000077771^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000077772^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000077781^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000077792^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000077794^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000077835^I0x00000000^I0304
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000079769^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000079771^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000079775^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000079783^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000079785^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000079793^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000079827^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000079829^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000079837^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000079930^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000079931^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000079940^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000079991^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000079993^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000080002^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000080018^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000080020^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000080029^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000080050^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000080052^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000080061^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000080075^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000080076^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000080086^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000080119^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000080121^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000080160^I0x00000041^I0353
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000080196^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000080197^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000080206^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000080389^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000080391^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000080400^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000080437^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000080439^I0x00000000^I0302
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000080448^I0x00008000^I0350
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000081599^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000081601^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000081981^I0x00000000^I0356
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000082286^I0x00000003^I0310
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000083210^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000083212^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000083287^I0x00000042^I0353
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000083297^I0x00000000^I0352
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000083305^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000083307^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000083375^I0x00000043^I0353
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000083385^I0x00000000^I0352
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000083424^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000083426^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000083530^I0x00000044^I0353
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000083540^I0x00000000^I0352
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000083547^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000083548^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000083618^I0x00000045^I0353
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000083628^I0x00000000^I0352
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000083636^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000083637^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000083711^I0x00000046^I0353
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000083721^I0x00000000^I0352
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000083728^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000083730^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000083803^I0x00000047^I0353
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000083814^I0x00000000^I0352
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000083820^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000083822^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000083891^I0x00000048^I0353
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000083901^I0x00000000^I0352
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000083919^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000083921^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000083995^I0x00000049^I0353
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000084006^I0x00000000^I0352
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000084012^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000084014^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000084083^I0x0000004a^I0353
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000084093^I0x00000000^I0352
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000084100^I0x000000d9^I0106
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000084102^I0x00000000^I0301
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000084173^I0x0000004b^I0353
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000084184^I0x00000000^I0352
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000084747^I0x00010087^I0250
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000084752^I0x0000001c^I0218
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000283745^I0x00000040^I0218
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000283749^I0x00000000^I0218
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
0000283945^I0x00000100^I0125
Jan 26 21:30:44 rainbow kernel: [  124.056009] ieee80211 phy0: I
iwl3945_print_rx_config_cmd RX CONFIG:
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl data: 00000000: 00
1f 3c 20 a1 6e 00 00 00 00 00 00 00 00 00 00  ..< .n..........
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl data: 00000010: 00
00 00 00 00 00 00 00 03 00 00 00 ff 0f 00 00  ................
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl data: 00000020: 05
80 00 00 04 00 00 00 0b 00 00 00              ............
Jan 26 21:30:44 rainbow kernel: [  124.056009] ieee80211 phy0: I
iwl3945_print_rx_config_cmd u16 channel: 0xb
Jan 26 21:30:44 rainbow kernel: [  124.056009] ieee80211 phy0: I
iwl3945_print_rx_config_cmd u32 flags: 0x00008005
Jan 26 21:30:44 rainbow kernel: [  124.056009] ieee80211 phy0: I
iwl3945_print_rx_config_cmd u32 filter_flags: 0x00000004
Jan 26 21:30:44 rainbow kernel: [  124.056009] ieee80211 phy0: I
iwl3945_print_rx_config_cmd u8 dev_type: 0x3
Jan 26 21:30:44 rainbow kernel: [  124.056009] ieee80211 phy0: I
iwl3945_print_rx_config_cmd u8 ofdm_basic_rates: 0xff
Jan 26 21:30:44 rainbow kernel: [  124.056009] ieee80211 phy0: I
iwl3945_print_rx_config_cmd u8 cck_basic_rates: 0x0f
Jan 26 21:30:44 rainbow kernel: [  124.056009] ieee80211 phy0: I
iwl3945_print_rx_config_cmd u8[6] node_addr: 00:1f:3c:20:a1:6e
Jan 26 21:30:44 rainbow kernel: [  124.056009] ieee80211 phy0: I
iwl3945_print_rx_config_cmd u8[6] bssid_addr: 00:00:00:00:00:00
Jan 26 21:30:44 rainbow kernel: [  124.056009] ieee80211 phy0: I
iwl3945_print_rx_config_cmd u16 assoc_id: 0x0
Jan 26 21:30:44 rainbow kernel: [  124.056009] ieee80211 phy0: I
iwl3945_irq_handle_error Restarting adapter due to uCode error.
Jan 26 21:30:44 rainbow kernel: [  124.056009] ieee80211 phy0: I
iwl3945_rx_handle r = 18, i = 17, REPLY_ERROR, 0x02
Jan 26 21:30:44 rainbow kernel: [  124.056009] iwl3945 0000:03:00.0:
Error Reply type 0x00000001 cmd UNKNOWN (0x3C) seq 0x6EA1 ser
0x003C0000
Jan 26 21:30:44 rainbow kernel: [  124.069246] ieee80211 phy0: U
__iwl3945_down iwl3945 is going down
Jan 26 21:30:44 rainbow kernel: [  124.069394] ieee80211 phy0: U
iwl3945_apm_stop_master stop master
Jan 26 21:30:44 rainbow kernel: [  124.069925] ieee80211 phy0: U
iwl3945_apm_stop_master stop master
Jan 26 21:30:44 rainbow kernel: [  124.070031] ieee80211 phy0: U
iwl3945_clear_free_frames 0 frames on pre-allocated heap on clear.
Jan 26 21:30:44 rainbow kernel: [  124.070045] ieee80211 phy0: U
iwl3945_power_init_handle Initialize power
Jan 26 21:30:44 rainbow kernel: [  124.070056] ieee80211 phy0: U
iwl3945_power_init_handle adjust power command flags
Jan 26 21:30:44 rainbow kernel: [  124.070151] ieee80211 phy0: U
iwl3945_hw_nic_init HW Revision ID = 0x2
Jan 26 21:30:44 rainbow kernel: [  124.070199] ieee80211 phy0: U
iwl3945_nic_config 3945 RADIO-MM type
Jan 26 21:30:44 rainbow kernel: [  124.070208] ieee80211 phy0: U
iwl3945_nic_config SKU OP mode is basic
Jan 26 21:30:44 rainbow kernel: [  124.070211] ieee80211 phy0: U
iwl3945_nic_config 3945ABG revision is 0xF1
Jan 26 21:30:44 rainbow kernel: [  124.070221] ieee80211 phy0: U
iwl3945_nic_config Card M type B version is 0x3
Jan 26 21:30:44 rainbow kernel: [  124.072242] ieee80211 phy0: U
iwl3945_load_bsm Begin load bsm
Jan 26 21:30:44 rainbow kernel: [  124.073504] ieee80211 phy0: U
iwl3945_verify_bsm Begin verify bsm
Jan 26 21:30:44 rainbow kernel: [  124.075633] ieee80211 phy0: U
iwl3945_verify_bsm BSM bootstrap uCode image OK
Jan 26 21:30:44 rainbow kernel: [  124.075688] ieee80211 phy0: U
iwl3945_load_bsm BSM write complete, poll 1 iterations
Jan 26 21:30:44 rainbow kernel: [  124.075704] ieee80211 phy0: U
__iwl3945_up iwl3945 is coming up
Jan 26 21:30:44 rainbow kernel: [  124.087131] ieee80211 phy0: I
iwl3945_rx_handle r = 1, i = 0, REPLY_ALIVE, 0x01
Jan 26 21:30:44 rainbow kernel: [  124.087144] ieee80211 phy0: I
iwl3945_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x9
Jan 26 21:30:44 rainbow kernel: [  124.087148] ieee80211 phy0: I
iwl3945_rx_reply_alive Initialization Alive received.
Jan 26 21:30:44 rainbow kernel: [  124.092020] ieee80211 phy0: U
iwl3945_verify_inst_sparse ucode inst image size is 900
Jan 26 21:30:44 rainbow kernel: [  124.092113] ieee80211 phy0: U
iwl3945_verify_inst_sparse ucode inst image size is 2672
Jan 26 21:30:44 rainbow kernel: [  124.092393] ieee80211 phy0: U
iwl3945_verify_ucode Initialize uCode is good in inst SRAM
Jan 26 21:30:44 rainbow kernel: [  124.092398] ieee80211 phy0: U
iwl3945_init_alive_start Initialization Alive received.
Jan 26 21:30:44 rainbow kernel: [  124.092443] ieee80211 phy0: U
iwl3945_set_ucode_ptrs Runtime uCode pointers are set.
Jan 26 21:30:44 rainbow kernel: [  124.096806] ieee80211 phy0: I
iwl3945_rx_handle r = 2, i = 1, REPLY_ALIVE, 0x01
Jan 26 21:30:44 rainbow kernel: [  124.096822] ieee80211 phy0: I
iwl3945_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x0
Jan 26 21:30:44 rainbow kernel: [  124.096832] ieee80211 phy0: I
iwl3945_rx_reply_alive Runtime Alive received.
Jan 26 21:30:44 rainbow kernel: [  124.096880] ieee80211 phy0: I
iwl3945_disable_events Selected uCode log events may be disabled
Jan 26 21:30:44 rainbow kernel: [  124.096889] ieee80211 phy0: I
iwl3945_disable_events   by writing "1"s into disable bitmap
Jan 26 21:30:44 rainbow kernel: [  124.096898] ieee80211 phy0: I
iwl3945_disable_events   in SRAM at 0x8022c8, size 47 u32s
Jan 26 21:30:44 rainbow kernel: [  124.104039] ieee80211 phy0: U
iwl3945_alive_start Runtime Alive received.
Jan 26 21:30:44 rainbow kernel: [  124.104057] ieee80211 phy0: U
iwl3945_verify_inst_sparse ucode inst image size is 900
Jan 26 21:30:44 rainbow kernel: [  124.104144] ieee80211 phy0: U
iwl3945_verify_inst_sparse ucode inst image size is 2672
Jan 26 21:30:44 rainbow kernel: [  124.104231] ieee80211 phy0: U
iwl3945_verify_inst_sparse ucode inst image size is 80684
Jan 26 21:30:44 rainbow kernel: [  124.111894] ieee80211 phy0: U
iwl3945_verify_ucode Runtime uCode is good in inst SRAM
Jan 26 21:30:44 rainbow kernel: [  124.111930] ieee80211 phy0: U
iwl3945_alive_start RFKILL status: 0x1
Jan 26 21:30:44 rainbow kernel: [  124.111963] ieee80211 phy0: U
iwl3945_update_power_cmd Flags value = 0x00000008
Jan 26 21:30:44 rainbow kernel: [  124.111972] ieee80211 phy0: U
iwl3945_update_power_cmd Tx timeout = 0
Jan 26 21:30:44 rainbow kernel: [  124.111979] ieee80211 phy0: U
iwl3945_update_power_cmd Rx timeout = 0
Jan 26 21:30:44 rainbow kernel: [  124.111988] ieee80211 phy0: U
iwl3945_update_power_cmd Sleep interval vector = { 0 , 0 , 0 , 0 , 0 }
Jan 26 21:30:44 rainbow kernel: [  124.112028] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command POWER_TABLE_CMD (#77), seq: 0x0400,
36 bytes at 0[0]:4
Jan 26 21:30:44 rainbow kernel: [  124.112117] ieee80211 phy0: I
iwl3945_rx_handle r 3 i 2 No handler needed for POWER_TABLE_CMD, 0x77
Jan 26 21:30:44 rainbow kernel: [  124.112153] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_BT_CONFIG (#9b), seq: 0x0401,
16 bytes at 1[1]:4
Jan 26 21:30:44 rainbow kernel: [  124.112229] ieee80211 phy0: I
iwl3945_rx_handle r 4 i 3 No handler needed for REPLY_BT_CONFIG, 0x9b
Jan 26 21:30:44 rainbow kernel: [  124.112258] ieee80211 phy0: U
iwl3945_commit_rxon Sending RXON
Jan 26 21:30:44 rainbow kernel: [  124.112261] * without RXON_FILTER_ASSOC_MSK
Jan 26 21:30:44 rainbow kernel: [  124.112264] * channel = 11
Jan 26 21:30:44 rainbow kernel: [  124.112266] * bssid = 00:00:00:00:00:00
Jan 26 21:30:44 rainbow kernel: [  124.112285] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x0402, 48
bytes at 2[2]:4
Jan 26 21:30:44 rainbow kernel: [  124.113510] ieee80211 phy0: I
iwl3945_rx_handle r 5 i 4 No handler needed for REPLY_RXON, 0x10
Jan 26 21:30:44 rainbow kernel: [  124.113544] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 235 dsp 109 rate code 0x0d
Jan 26 21:30:44 rainbow kernel: [  124.113553] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 235 dsp 109 rate code 0x0f
Jan 26 21:30:44 rainbow kernel: [  124.113562] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 235 dsp 109 rate code 0x05
Jan 26 21:30:44 rainbow kernel: [  124.113570] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 235 dsp 109 rate code 0x07
Jan 26 21:30:44 rainbow kernel: [  124.113578] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 235 dsp 109 rate code 0x09
Jan 26 21:30:44 rainbow kernel: [  124.113586] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 235 dsp 109 rate code 0x0b
Jan 26 21:30:44 rainbow kernel: [  124.113594] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 235 dsp 109 rate code 0x01
Jan 26 21:30:44 rainbow kernel: [  124.113603] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 235 dsp 109 rate code 0x03
Jan 26 21:30:44 rainbow kernel: [  124.113611] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 171 dsp  98 rate code 0x0a
Jan 26 21:30:44 rainbow kernel: [  124.113620] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 171 dsp  98 rate code 0x14
Jan 26 21:30:44 rainbow kernel: [  124.113628] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 171 dsp  98 rate code 0x37
Jan 26 21:30:44 rainbow kernel: [  124.113637] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 171 dsp  98 rate code 0x6e
Jan 26 21:30:44 rainbow kernel: [  124.113649] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq:
0x0403, 56 bytes at 3[3]:4
Jan 26 21:30:44 rainbow kernel: [  124.113763] ieee80211 phy0: I
iwl3945_rx_handle r 6 i 5 No handler needed for
REPLY_TX_PWR_TABLE_CMD, 0x97
Jan 26 21:30:44 rainbow kernel: [  124.113843] ieee80211 phy0: U
iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
Jan 26 21:30:44 rainbow kernel: [  124.113857] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0404, 68
bytes at 4[4]:4
Jan 26 21:30:44 rainbow kernel: [  124.113944] ieee80211 phy0: I
iwl3945_rx_handle r = 7, i = 6, REPLY_ADD_STA, 0x18
Jan 26 21:30:44 rainbow kernel: [  124.113962] ieee80211 phy0: U
iwl3945_send_add_station REPLY_ADD_STA PASSED
Jan 26 21:30:44 rainbow kernel: [  124.113977] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0405,
56 bytes at 5[5]:4
Jan 26 21:30:44 rainbow kernel: [  124.114115] ieee80211 phy0: I
iwl3945_rx_handle r 8 i 7 No handler needed for REPLY_RATE_SCALE, 0x47
Jan 26 21:30:44 rainbow kernel: [  124.114146] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0406,
56 bytes at 6[6]:4
Jan 26 21:30:44 rainbow kernel: [  124.114223] ieee80211 phy0: I
iwl3945_rx_handle r 9 i 8 No handler needed for REPLY_RATE_SCALE, 0x47
Jan 26 21:30:44 rainbow kernel: [  124.114257] ieee80211 phy0: U
iwl3945_hw_reg_txpower_get_temperature Temperature: 92
Jan 26 21:30:44 rainbow kernel: [  124.114265] ieee80211 phy0: U
is_temp_calib_needed Same temp,
Jan 26 21:30:44 rainbow kernel: [  124.114272] ieee80211 phy0: U
is_temp_calib_needed Timed thermal calib not needed
Jan 26 21:30:44 rainbow kernel: [  124.115929] Registered led device:
iwl-phy0:radio
Jan 26 21:30:44 rainbow kernel: [  124.115940] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0407, 12
bytes at 7[7]:4
Jan 26 21:30:44 rainbow kernel: [  124.116042] ieee80211 phy0: I
iwl3945_rx_handle r 10 i 9 No handler needed for REPLY_LEDS_CMD, 0x48
Jan 26 21:30:44 rainbow kernel: [  124.116085] Registered led device:
iwl-phy0:assoc
Jan 26 21:30:44 rainbow kernel: [  124.116124] Registered led device:
iwl-phy0:RX
Jan 26 21:30:44 rainbow kernel: [  124.116161] Registered led device:
iwl-phy0:TX
Jan 26 21:30:44 rainbow kernel: [  124.116166] ieee80211 phy0: U
iwl3945_alive_start ALIVE processing complete.
Jan 26 21:30:44 rainbow kernel: [  124.157877] ieee80211 phy0: I
iwl3945_rx_handle r = 11, i = 10, REPLY_3945_RX, 0x1b
Jan 26 21:30:44 rainbow kernel: [  124.159561] ieee80211 phy0: I
iwl3945_rx_handle r = 12, i = 11, REPLY_3945_RX, 0x1b
Jan 26 21:30:44 rainbow kernel: [  124.166909] ieee80211 phy0: I
iwl3945_rx_handle r = 13, i = 12, REPLY_3945_RX, 0x1b
Jan 26 21:30:44 rainbow kernel: [  124.170069] ieee80211 phy0: I
iwl3945_rx_handle r = 14, i = 13, REPLY_3945_RX, 0x1b
Jan 26 21:30:44 rainbow kernel: [  124.176234] ieee80211 phy0: I
iwl3945_rx_handle r = 15, i = 14, REPLY_3945_RX, 0x1b
Jan 26 21:30:44 rainbow kernel: [  124.186028] ieee80211 phy0: I
iwl3945_rx_handle r = 16, i = 15, REPLY_3945_RX, 0x1b
Jan 26 21:30:44 rainbow kernel: [  124.194980] ieee80211 phy0: I
iwl3945_rx_handle r = 17, i = 16, REPLY_3945_RX, 0x1b
Jan 26 21:30:44 rainbow kernel: [  124.252020] wlan0: direct probe to
AP 00:30:bd:c0:90:24 timed out
Jan 26 21:30:44 rainbow kernel: [  124.260266] ieee80211 phy0: I
iwl3945_rx_handle r = 18, i = 17, REPLY_3945_RX, 0x1b
Jan 26 21:30:44 rainbow kernel: [  124.260299] ieee80211 phy0: U
iwl3945_mac_hw_scan enter
Jan 26 21:30:44 rainbow kernel: [  124.260304] ieee80211 phy0: U
iwl3945_scan_initiate Starting scan...
Jan 26 21:30:44 rainbow kernel: [  124.260309] ieee80211 phy0: U
iwl3945_mac_hw_scan leave
Jan 26 21:30:44 rainbow kernel: [  124.260316] ieee80211 phy0: U
iwl3945_bg_request_scan Kicking off one indirect scan.
Jan 26 21:30:44 rainbow kernel: [  124.260320] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 1 [ACTIVE 39]
Jan 26 21:30:44 rainbow kernel: [  124.260324] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 2 [ACTIVE 39]
Jan 26 21:30:44 rainbow kernel: [  124.260327] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 3 [ACTIVE 39]
Jan 26 21:30:44 rainbow kernel: [  124.260331] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 4 [ACTIVE 39]
Jan 26 21:30:44 rainbow kernel: [  124.260334] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 5 [ACTIVE 39]
Jan 26 21:30:44 rainbow kernel: [  124.260337] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 6 [ACTIVE 39]
Jan 26 21:30:44 rainbow kernel: [  124.260341] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 7 [ACTIVE 39]
Jan 26 21:30:44 rainbow kernel: [  124.260344] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 8 [ACTIVE 39]
Jan 26 21:30:44 rainbow kernel: [  124.260347] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 9 [ACTIVE 39]
Jan 26 21:30:44 rainbow kernel: [  124.260350] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 10 [ACTIVE 39]
Jan 26 21:30:44 rainbow kernel: [  124.260354] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 11 [ACTIVE 39]
Jan 26 21:30:44 rainbow kernel: [  124.260357] ieee80211 phy0: U
iwl3945_get_channels_for_scan total channels to scan 11
Jan 26 21:30:44 rainbow kernel: [  124.260364] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x4408,
351 bytes at 8[32]:4
Jan 26 21:30:44 rainbow kernel: [  124.260502] ieee80211 phy0: I
iwl3945_rx_handle r = 19, i = 18, REPLY_SCAN_CMD, 0x80
Jan 26 21:30:44 rainbow kernel: [  124.261541] ieee80211 phy0: I
iwl3945_rx_handle r = 21, i = 19, STATISTICS_NOTIFICATION, 0x9d
Jan 26 21:30:44 rainbow kernel: [  124.261549] ieee80211 phy0: I
iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0409, 12
bytes at 9[9]:4
Jan 26 21:30:44 rainbow kernel: [  124.261558] ieee80211 phy0: I
iwl3945_rx_handle r = 21, i = 20, SCAN_START_NOTIFICATION, 0x82
Jan 26 21:30:44 rainbow kernel: [  124.261564] ieee80211 phy0: I
iwl3945_rx_scan_start_notif Scan start: 1 [802.11bg] (TSF:
0x00000000:0002467E) - 1 (beacon timer 16832898)
Jan 26 21:30:44 rainbow kernel: [  124.262165] ieee80211 phy0: I
iwl3945_rx_handle r 22 i 21 No handler needed for REPLY_LEDS_CMD, 0x48
Jan 26 21:30:44 rainbow kernel: [  124.263508] ieee80211 phy0: I
iwl3945_rx_handle r = 23, i = 22, REPLY_3945_RX, 0x1b
Jan 26 21:30:44 rainbow kernel: [  124.265654] ieee80211 phy0: I
iwl3945_rx_handle r = 24, i = 23, REPLY_3945_RX, 0x1b
Jan 26 21:30:44 rainbow kernel: [  124.267930] ieee80211 phy0: I
iwl3945_rx_handle r = 25, i = 24, REPLY_3945_RX, 0x1b
Jan 26 21:30:44 rainbow kernel: [  124.269806] ieee80211 phy0: I
iwl3945_rx_handle r = 26, i = 25, REPLY_3945_RX, 0x1b
Jan 26 21:30:44 rainbow kernel: [  124.273236] ieee80211 phy0: I
iwl3945_rx_handle r = 27, i = 26, REPLY_3945_RX, 0x1b
Jan 26 21:30:44 rainbow kernel: [  124.276129] ieee80211 phy0: I
iwl3945_rx_handle r = 28, i = 27, REPLY_3945_RX, 0x1b
Jan 26 21:30:44 rainbow kernel: [  124.301504] ieee80211 phy0: I
iwl3945_rx_handle r = 29, i = 28, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 21:30:44 rainbow kernel: [  124.301516] ieee80211 phy0: I
iwl3945_rx_scan_results_notif Scan ch.res: 1 [802.11bg] (TSF:
0x00000000:0002E28F) - 6 elapsed=39953 usec (95700ms since last)
Jan 26 21:30:44 rainbow kernel: [  124.302505] ieee80211 phy0: I
iwl3945_rx_handle r = 31, i = 29, STATISTICS_NOTIFICATION, 0x9d
Jan 26 21:30:44 rainbow kernel: [  124.302515] ieee80211 phy0: I
iwl3945_rx_handle r = 31, i = 30, SCAN_START_NOTIFICATION, 0x82
Jan 26 21:30:44 rainbow kernel: [  124.302521] ieee80211 phy0: I
iwl3945_rx_scan_start_notif Scan start: 2 [802.11bg] (TSF:
0x00000000:0002E685) - 1 (beacon timer 16791931)
Jan 26 21:30:44 rainbow kernel: [  124.314906] ieee80211 phy0: I
iwl3945_rx_handle r = 32, i = 31, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 21:30:44 rainbow kernel: [  124.314913] ieee80211 phy0: I
iwl3945_rx_scan_results_notif Scan ch.res: 2 [802.11bg] (TSF:
0x00000000:000316F2) - 0 elapsed=12397 usec (12ms since last)
Jan 26 21:30:44 rainbow kernel: [  124.315946] ieee80211 phy0: I
iwl3945_rx_handle r = 34, i = 32, STATISTICS_NOTIFICATION, 0x9d
Jan 26 21:30:44 rainbow kernel: [  124.315955] ieee80211 phy0: I
iwl3945_rx_handle r = 34, i = 33, SCAN_START_NOTIFICATION, 0x82
Jan 26 21:30:44 rainbow kernel: [  124.315959] ieee80211 phy0: I
iwl3945_rx_scan_start_notif Scan start: 3 [802.11bg] (TSF:
0x00000000:00031B08) - 1 (beacon timer 16778488)
Jan 26 21:30:44 rainbow kernel: [  124.328527] ieee80211 phy0: I
iwl3945_rx_handle r = 35, i = 34, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 21:30:44 rainbow kernel: [  124.328534] ieee80211 phy0: I
iwl3945_rx_scan_results_notif Scan ch.res: 3 [802.11bg] (TSF:
0x00000000:00034C23) - 0 elapsed=12571 usec (16ms since last)
Jan 26 21:30:44 rainbow kernel: [  124.329551] ieee80211 phy0: I
iwl3945_rx_handle r = 37, i = 35, STATISTICS_NOTIFICATION, 0x9d
Jan 26 21:30:44 rainbow kernel: [  124.329559] ieee80211 phy0: I
iwl3945_rx_handle r = 37, i = 36, SCAN_START_NOTIFICATION, 0x82
Jan 26 21:30:44 rainbow kernel: [  124.329563] ieee80211 phy0: I
iwl3945_rx_scan_start_notif Scan start: 4 [802.11bg] (TSF:
0x00000000:00035029) - 1 (beacon timer 33644503)
Jan 26 21:30:44 rainbow kernel: [  124.331657] ieee80211 phy0: I
iwl3945_rx_handle r = 38, i = 37, REPLY_3945_RX, 0x1b
Jan 26 21:30:44 rainbow kernel: [  124.333900] ieee80211 phy0: I
iwl3945_rx_handle r = 39, i = 38, REPLY_3945_RX, 0x1b
Jan 26 21:30:44 rainbow kernel: [  124.336182] ieee80211 phy0: I
iwl3945_rx_handle r = 40, i = 39, REPLY_3945_RX, 0x1b
Jan 26 21:30:44 rainbow kernel: [  124.348188] ieee80211 phy0: I
iwl3945_rx_handle r = 41, i = 40, REPLY_3945_RX, 0x1b
Jan 26 21:30:44 rainbow kernel: [  124.369540] ieee80211 phy0: I
iwl3945_rx_handle r = 42, i = 41, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 21:30:44 rainbow kernel: [  124.369552] ieee80211 phy0: I
iwl3945_rx_scan_results_notif Scan ch.res: 4 [802.11bg] (TSF:
0x00000000:0003EC35) - 4 elapsed=39948 usec (40ms since last)
Jan 26 21:30:44 rainbow kernel: [  124.370557] ieee80211 phy0: I
iwl3945_rx_handle r = 44, i = 42, STATISTICS_NOTIFICATION, 0x9d
Jan 26 21:30:44 rainbow kernel: [  124.370567] ieee80211 phy0: I
iwl3945_rx_handle r = 44, i = 43, SCAN_START_NOTIFICATION, 0x82
Jan 26 21:30:44 rainbow kernel: [  124.370571] ieee80211 phy0: I
iwl3945_rx_scan_start_notif Scan start: 5 [802.11bg] (TSF:
0x00000000:0003F038) - 1 (beacon timer 33603528)
Jan 26 21:30:44 rainbow kernel: [  124.375408] ieee80211 phy0: I
iwl3945_rx_handle r = 45, i = 44, REPLY_3945_RX, 0x1b
Jan 26 21:30:44 rainbow kernel: [  124.378152] ieee80211 phy0: I
iwl3945_rx_handle r = 46, i = 45, REPLY_3945_RX, 0x1b
Jan 26 21:30:44 rainbow kernel: [  124.383229] ieee80211 phy0: I
iwl3945_rx_handle r = 47, i = 46, REPLY_3945_RX, 0x1b
Jan 26 21:30:44 rainbow kernel: [  124.396964] ieee80211 phy0: I
iwl3945_rx_handle r = 48, i = 47, REPLY_3945_RX, 0x1b
Jan 26 21:30:44 rainbow kernel: [  124.410529] ieee80211 phy0: I
iwl3945_rx_handle r = 49, i = 48, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 21:30:44 rainbow kernel: [  124.410542] ieee80211 phy0: I
iwl3945_rx_scan_results_notif Scan ch.res: 5 [802.11bg] (TSF:
0x00000000:00048C4D) - 4 elapsed=39957 usec (40ms since last)
Jan 26 21:30:44 rainbow kernel: [  124.411498] ieee80211 phy0: I
iwl3945_rx_handle r = 51, i = 49, STATISTICS_NOTIFICATION, 0x9d
Jan 26 21:30:44 rainbow kernel: [  124.411510] ieee80211 phy0: I
iwl3945_rx_handle r = 51, i = 50, SCAN_START_NOTIFICATION, 0x82
Jan 26 21:30:44 rainbow kernel: [  124.411515] ieee80211 phy0: I
iwl3945_rx_scan_start_notif Scan start: 6 [802.11bg] (TSF:
0x00000000:00049020) - 1 (beacon timer 33562592)
Jan 26 21:30:44 rainbow kernel: [  124.413579] ieee80211 phy0: I
iwl3945_rx_handle r = 52, i = 51, REPLY_3945_RX, 0x1b
Jan 26 21:30:44 rainbow kernel: [  124.414538] ieee80211 phy0: I
iwl3945_rx_handle r = 53, i = 52, REPLY_3945_RX, 0x1b
Jan 26 21:30:44 rainbow kernel: [  124.416736] ieee80211 phy0: I
iwl3945_rx_handle r = 54, i = 53, REPLY_3945_RX, 0x1b
Jan 26 21:30:44 rainbow kernel: [  124.419095] ieee80211 phy0: I
iwl3945_rx_handle r = 55, i = 54, REPLY_3945_RX, 0x1b
Jan 26 21:30:44 rainbow kernel: [  124.420796] ieee80211 phy0: I
iwl3945_rx_handle r = 56, i = 55, REPLY_3945_RX, 0x1b
Jan 26 21:30:44 rainbow kernel: [  124.422027] ieee80211 phy0: I
iwl3945_rx_handle r = 57, i = 56, REPLY_3945_RX, 0x1b
Jan 26 21:30:44 rainbow kernel: [  124.438762] ieee80211 phy0: I
iwl3945_rx_handle r = 58, i = 57, REPLY_3945_RX, 0x1b
Jan 26 21:30:44 rainbow kernel: [  124.450588] ieee80211 phy0: I
iwl3945_rx_handle r = 59, i = 58, REPLY_3945_RX, 0x1b
Jan 26 21:30:44 rainbow kernel: [  124.451422] ieee80211 phy0: I
iwl3945_rx_handle r = 60, i = 59, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 21:30:44 rainbow kernel: [  124.451427] ieee80211 phy0: I
iwl3945_rx_scan_results_notif Scan ch.res: 6 [802.11bg] (TSF:
0x00000000:00052C34) - 10 elapsed=39956 usec (40ms since last)
Jan 26 21:30:44 rainbow kernel: [  124.452510] ieee80211 phy0: I
iwl3945_rx_handle r = 62, i = 60, STATISTICS_NOTIFICATION, 0x9d
Jan 26 21:30:44 rainbow kernel: [  124.452520] ieee80211 phy0: I
iwl3945_rx_handle r = 62, i = 61, SCAN_START_NOTIFICATION, 0x82
Jan 26 21:30:44 rainbow kernel: [  124.452525] ieee80211 phy0: I
iwl3945_rx_scan_start_notif Scan start: 7 [802.11bg] (TSF:
0x00000000:00053073) - 1 (beacon timer 50401165)
Jan 26 21:30:44 rainbow kernel: [  124.454617] ieee80211 phy0: I
iwl3945_rx_handle r = 63, i = 62, REPLY_3945_RX, 0x1b
Jan 26 21:30:44 rainbow kernel: [  124.456869] ieee80211 phy0: I
iwl3945_rx_handle r = 64, i = 63, REPLY_3945_RX, 0x1b
Jan 26 21:30:44 rainbow kernel: [  124.459117] ieee80211 phy0: I
iwl3945_rx_handle r = 65, i = 64, REPLY_3945_RX, 0x1b
Jan 26 21:30:44 rainbow kernel: [  124.487192] ieee80211 phy0: I
iwl3945_rx_handle r = 66, i = 65, REPLY_3945_RX, 0x1b
Jan 26 21:30:44 rainbow kernel: [  124.492462] ieee80211 phy0: I
iwl3945_rx_handle r = 67, i = 66, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 21:30:44 rainbow kernel: [  124.492469] ieee80211 phy0: I
iwl3945_rx_scan_results_notif Scan ch.res: 7 [802.11bg] (TSF:
0x00000000:0005CC7E) - 4 elapsed=39947 usec (44ms since last)
Jan 26 21:30:44 rainbow kernel: [  124.493501] ieee80211 phy0: I
iwl3945_rx_handle r = 69, i = 67, STATISTICS_NOTIFICATION, 0x9d
Jan 26 21:30:44 rainbow kernel: [  124.493510] ieee80211 phy0: I
iwl3945_rx_handle r = 69, i = 68, SCAN_START_NOTIFICATION, 0x82
Jan 26 21:30:44 rainbow kernel: [  124.493515] ieee80211 phy0: I
iwl3945_rx_scan_start_notif Scan start: 8 [802.11bg] (TSF:
0x00000000:0005D074) - 1 (beacon timer 50360204)
Jan 26 21:30:44 rainbow kernel: [  124.495608] ieee80211 phy0: I
iwl3945_rx_handle r = 70, i = 69, REPLY_3945_RX, 0x1b
Jan 26 21:30:44 rainbow kernel: [  124.499127] ieee80211 phy0: I
iwl3945_rx_handle r = 71, i = 70, REPLY_3945_RX, 0x1b
Jan 26 21:30:44 rainbow kernel: [  124.500305] ieee80211 phy0: I
iwl3945_rx_handle r = 72, i = 71, REPLY_3945_RX, 0x1b
Jan 26 21:30:44 rainbow kernel: [  124.533464] ieee80211 phy0: I
iwl3945_rx_handle r = 73, i = 72, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 21:30:44 rainbow kernel: [  124.533473] ieee80211 phy0: I
iwl3945_rx_scan_results_notif Scan ch.res: 8 [802.11bg] (TSF:
0x00000000:00066C8A) - 3 elapsed=39958 usec (40ms since last)
Jan 26 21:30:44 rainbow kernel: [  124.534447] ieee80211 phy0: I
iwl3945_rx_handle r = 75, i = 73, STATISTICS_NOTIFICATION, 0x9d
Jan 26 21:30:44 rainbow kernel: [  124.534456] ieee80211 phy0: I
iwl3945_rx_handle r = 75, i = 74, SCAN_START_NOTIFICATION, 0x82
Jan 26 21:30:44 rainbow kernel: [  124.534460] ieee80211 phy0: I
iwl3945_rx_scan_start_notif Scan start: 9 [802.11bg] (TSF:
0x00000000:00067067) - 1 (beacon timer 67198873)
Jan 26 21:30:44 rainbow kernel: [  124.538409] ieee80211 phy0: I
iwl3945_rx_handle r = 76, i = 75, REPLY_3945_RX, 0x1b
Jan 26 21:30:44 rainbow kernel: [  124.547190] ieee80211 phy0: I
iwl3945_rx_handle r = 77, i = 76, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 21:30:44 rainbow kernel: [  124.547195] ieee80211 phy0: I
iwl3945_rx_scan_results_notif Scan ch.res: 9 [802.11bg] (TSF:
0x00000000:0006A24B) - 1 elapsed=12772 usec (12ms since last)
Jan 26 21:30:44 rainbow kernel: [  124.548175] ieee80211 phy0: I
iwl3945_rx_handle r = 79, i = 77, STATISTICS_NOTIFICATION, 0x9d
Jan 26 21:30:44 rainbow kernel: [  124.548184] ieee80211 phy0: I
iwl3945_rx_handle r = 79, i = 78, SCAN_START_NOTIFICATION, 0x82
Jan 26 21:30:44 rainbow kernel: [  124.548189] ieee80211 phy0: I
iwl3945_rx_scan_start_notif Scan start: 10 [802.11bg] (TSF:
0x00000000:0006A622) - 1 (beacon timer 67185118)
Jan 26 21:30:44 rainbow kernel: [  124.550680] ieee80211 phy0: I
iwl3945_rx_handle r = 80, i = 79, REPLY_3945_RX, 0x1b
Jan 26 21:30:44 rainbow kernel: [  124.553417] ieee80211 phy0: I
iwl3945_rx_handle r = 81, i = 80, REPLY_3945_RX, 0x1b
Jan 26 21:30:44 rainbow kernel: [  124.567469] ieee80211 phy0: I
iwl3945_rx_handle r = 82, i = 81, REPLY_3945_RX, 0x1b
Jan 26 21:30:44 rainbow kernel: [  124.588172] ieee80211 phy0: I
iwl3945_rx_handle r = 83, i = 82, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 21:30:44 rainbow kernel: [  124.588184] ieee80211 phy0: I
iwl3945_rx_scan_results_notif Scan ch.res: 10 [802.11bg] (TSF:
0x00000000:00074237) - 3 elapsed=39957 usec (44ms since last)
Jan 26 21:30:44 rainbow kernel: [  124.589130] ieee80211 phy0: I
iwl3945_rx_handle r = 85, i = 83, STATISTICS_NOTIFICATION, 0x9d
Jan 26 21:30:44 rainbow kernel: [  124.589141] ieee80211 phy0: I
iwl3945_rx_handle r = 85, i = 84, SCAN_START_NOTIFICATION, 0x82
Jan 26 21:30:44 rainbow kernel: [  124.589146] ieee80211 phy0: I
iwl3945_rx_scan_start_notif Scan start: 11 [802.11bg] (TSF:
0x00000000:0007461C) - 1 (beacon timer 67144163)
Jan 26 21:30:44 rainbow kernel: [  124.590860] ieee80211 phy0: I
iwl3945_rx_handle r = 86, i = 85, REPLY_3945_RX, 0x1b
Jan 26 21:30:44 rainbow kernel: [  124.594066] ieee80211 phy0: I
iwl3945_rx_handle r = 87, i = 86, REPLY_3945_RX, 0x1b
Jan 26 21:30:44 rainbow kernel: [  124.604619] ieee80211 phy0: I
iwl3945_rx_handle r = 88, i = 87, REPLY_3945_RX, 0x1b
Jan 26 21:30:44 rainbow kernel: [  124.629085] ieee80211 phy0: I
iwl3945_rx_handle r = 89, i = 88, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 21:30:44 rainbow kernel: [  124.629097] ieee80211 phy0: I
iwl3945_rx_scan_results_notif Scan ch.res: 11 [802.11bg] (TSF:
0x00000000:0007E224) - 3 elapsed=39944 usec (40ms since last)
Jan 26 21:30:44 rainbow kernel: [  124.629211] ieee80211 phy0: I
iwl3945_rx_handle r = 90, i = 89, SCAN_COMPLETE_NOTIFICATION, 0x84
Jan 26 21:30:44 rainbow kernel: [  124.629217] ieee80211 phy0: I
iwl3945_rx_scan_complete_notif Scan complete: 11 channels (TSF
0x0007E294:00000000) - 1
Jan 26 21:30:44 rainbow kernel: [  124.629220] ieee80211 phy0: I
iwl3945_rx_scan_complete_notif Scan pass on 2.4GHz took 368ms
Jan 26 21:30:44 rainbow kernel: [  124.629250] ieee80211 phy0: U
iwl3945_bg_request_scan Kicking off one indirect scan.
Jan 26 21:30:44 rainbow kernel: [  124.629256] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 36 [PASSIVE 110]
Jan 26 21:30:44 rainbow kernel: [  124.629259] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 40 [PASSIVE 110]
Jan 26 21:30:44 rainbow kernel: [  124.629263] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 44 [PASSIVE 110]
Jan 26 21:30:44 rainbow kernel: [  124.629265] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 48 [PASSIVE 110]
Jan 26 21:30:44 rainbow kernel: [  124.629269] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 52 [PASSIVE 110]
Jan 26 21:30:44 rainbow kernel: [  124.629272] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 56 [PASSIVE 110]
Jan 26 21:30:44 rainbow kernel: [  124.629276] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 60 [PASSIVE 110]
Jan 26 21:30:44 rainbow kernel: [  124.629279] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 64 [PASSIVE 110]
Jan 26 21:30:44 rainbow kernel: [  124.629283] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 149 [PASSIVE 110]
Jan 26 21:30:44 rainbow kernel: [  124.629286] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 153 [PASSIVE 110]
Jan 26 21:30:44 rainbow kernel: [  124.629290] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 157 [PASSIVE 110]
Jan 26 21:30:44 rainbow kernel: [  124.629294] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 161 [PASSIVE 110]
Jan 26 21:30:44 rainbow kernel: [  124.629297] ieee80211 phy0: U
iwl3945_get_channels_for_scan Scanning 165 [PASSIVE 110]
Jan 26 21:30:44 rainbow kernel: [  124.629300] ieee80211 phy0: U
iwl3945_get_channels_for_scan total channels to scan 13
Jan 26 21:30:44 rainbow kernel: [  124.629308] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x440A,
367 bytes at 10[32]:4
Jan 26 21:30:44 rainbow kernel: [  124.629497] ieee80211 phy0: I
iwl3945_rx_handle r = 91, i = 90, REPLY_SCAN_CMD, 0x80
Jan 26 21:30:44 rainbow kernel: [  124.630434] ieee80211 phy0: I
iwl3945_rx_handle r = 93, i = 91, STATISTICS_NOTIFICATION, 0x9d
Jan 26 21:30:44 rainbow kernel: [  124.630443] ieee80211 phy0: I
iwl3945_rx_handle r = 93, i = 92, SCAN_START_NOTIFICATION, 0x82
Jan 26 21:30:44 rainbow kernel: [  124.630448] ieee80211 phy0: I
iwl3945_rx_scan_start_notif Scan start: 36 [802.11a] (TSF:
0x00000000:0007E757) - 1 (beacon timer 83982505)
Jan 26 21:30:44 rainbow kernel: [  124.743099] ieee80211 phy0: I
iwl3945_rx_handle r = 94, i = 93, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 21:30:44 rainbow kernel: [  124.743113] ieee80211 phy0: I
iwl3945_rx_scan_results_notif Scan ch.res: 36 [802.11a] (TSF:
0x00000000:00099F60) - 0 elapsed=112649 usec (112ms since last)
Jan 26 21:30:44 rainbow kernel: [  124.744014] ieee80211 phy0: I
iwl3945_rx_handle r = 96, i = 94, STATISTICS_NOTIFICATION, 0x9d
Jan 26 21:30:44 rainbow kernel: [  124.744025] ieee80211 phy0: I
iwl3945_rx_handle r = 96, i = 95, SCAN_START_NOTIFICATION, 0x82
Jan 26 21:30:44 rainbow kernel: [  124.744030] ieee80211 phy0: I
iwl3945_rx_scan_start_notif Scan start: 40 [802.11a] (TSF:
0x00000000:0009A2FD) - 1 (beacon timer 100748547)
Jan 26 21:30:44 rainbow kernel: [  124.856687] ieee80211 phy0: I
iwl3945_rx_handle r = 97, i = 96, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 21:30:44 rainbow kernel: [  124.856711] ieee80211 phy0: I
iwl3945_rx_scan_results_notif Scan ch.res: 40 [802.11a] (TSF:
0x00000000:000B5B06) - 0 elapsed=112649 usec (112ms since last)
Jan 26 21:30:44 rainbow kernel: [  124.857577] ieee80211 phy0: I
iwl3945_rx_handle r = 99, i = 97, STATISTICS_NOTIFICATION, 0x9d
Jan 26 21:30:44 rainbow kernel: [  124.857607] ieee80211 phy0: I
iwl3945_rx_handle r = 99, i = 98, SCAN_START_NOTIFICATION, 0x82
Jan 26 21:30:44 rainbow kernel: [  124.857621] ieee80211 phy0: I
iwl3945_rx_scan_start_notif Scan start: 44 [802.11a] (TSF:
0x00000000:000B5EAB) - 1 (beacon timer 117514581)
Jan 26 21:30:44 rainbow kernel: [  124.970243] ieee80211 phy0: I
iwl3945_rx_handle r = 100, i = 99, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 21:30:44 rainbow kernel: [  124.970268] ieee80211 phy0: I
iwl3945_rx_scan_results_notif Scan ch.res: 44 [802.11a] (TSF:
0x00000000:000D16B4) - 0 elapsed=112649 usec (116ms since last)
Jan 26 21:30:44 rainbow kernel: [  124.971186] ieee80211 phy0: I
iwl3945_rx_handle r = 102, i = 100, STATISTICS_NOTIFICATION, 0x9d
Jan 26 21:30:44 rainbow kernel: [  124.971212] ieee80211 phy0: I
iwl3945_rx_handle r = 102, i = 101, SCAN_START_NOTIFICATION, 0x82
Jan 26 21:30:44 rainbow kernel: [  124.971228] ieee80211 phy0: I
iwl3945_rx_scan_start_notif Scan start: 48 [802.11a] (TSF:
0x00000000:000D1A73) - 1 (beacon timer 134280589)
Jan 26 21:30:44 rainbow kernel: [  125.083835] ieee80211 phy0: I
iwl3945_rx_handle r = 103, i = 102, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 21:30:44 rainbow kernel: [  125.083847] ieee80211 phy0: I
iwl3945_rx_scan_results_notif Scan ch.res: 48 [802.11a] (TSF:
0x00000000:000ED27B) - 0 elapsed=112648 usec (112ms since last)
Jan 26 21:30:44 rainbow kernel: [  125.084787] ieee80211 phy0: I
iwl3945_rx_handle r = 105, i = 103, STATISTICS_NOTIFICATION, 0x9d
Jan 26 21:30:44 rainbow kernel: [  125.084799] ieee80211 phy0: I
iwl3945_rx_handle r = 105, i = 104, SCAN_START_NOTIFICATION, 0x82
Jan 26 21:30:44 rainbow kernel: [  125.084804] ieee80211 phy0: I
iwl3945_rx_scan_start_notif Scan start: 52 [802.11a] (TSF:
0x00000000:000ED61D) - 1 (beacon timer 151046627)
Jan 26 21:30:45 rainbow kernel: [  125.197477] ieee80211 phy0: I
iwl3945_rx_handle r = 106, i = 105, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 21:30:45 rainbow kernel: [  125.197495] ieee80211 phy0: I
iwl3945_rx_scan_results_notif Scan ch.res: 52 [802.11a] (TSF:
0x00000000:00108E25) - 0 elapsed=112648 usec (116ms since last)
Jan 26 21:30:45 rainbow kernel: [  125.198401] ieee80211 phy0: I
iwl3945_rx_handle r = 108, i = 106, STATISTICS_NOTIFICATION, 0x9d
Jan 26 21:30:45 rainbow kernel: [  125.198417] ieee80211 phy0: I
iwl3945_rx_handle r = 108, i = 107, SCAN_START_NOTIFICATION, 0x82
Jan 26 21:30:45 rainbow kernel: [  125.198426] ieee80211 phy0: I
iwl3945_rx_scan_start_notif Scan start: 56 [802.11a] (TSF:
0x00000000:001091CD) - 1 (beacon timer 167812658)
Jan 26 21:30:45 rainbow kernel: [  125.311080] ieee80211 phy0: I
iwl3945_rx_handle r = 109, i = 108, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 21:30:45 rainbow kernel: [  125.311107] ieee80211 phy0: I
iwl3945_rx_scan_results_notif Scan ch.res: 56 [802.11a] (TSF:
0x00000000:001249D6) - 0 elapsed=112649 usec (112ms since last)
Jan 26 21:30:45 rainbow kernel: [  125.311988] ieee80211 phy0: I
iwl3945_rx_handle r = 111, i = 109, STATISTICS_NOTIFICATION, 0x9d
Jan 26 21:30:45 rainbow kernel: [  125.312013] ieee80211 phy0: I
iwl3945_rx_handle r = 111, i = 110, SCAN_START_NOTIFICATION, 0x82
Jan 26 21:30:45 rainbow kernel: [  125.312025] ieee80211 phy0: I
iwl3945_rx_scan_start_notif Scan start: 60 [802.11a] (TSF:
0x00000000:00124D73) - 1 (beacon timer 184578701)
Jan 26 21:30:45 rainbow kernel: [  125.424647] ieee80211 phy0: I
iwl3945_rx_handle r = 112, i = 111, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 21:30:45 rainbow kernel: [  125.424672] ieee80211 phy0: I
iwl3945_rx_scan_results_notif Scan ch.res: 60 [802.11a] (TSF:
0x00000000:0014057B) - 0 elapsed=112648 usec (116ms since last)
Jan 26 21:30:45 rainbow kernel: [  125.425910] ieee80211 phy0: I
iwl3945_rx_handle r = 114, i = 112, STATISTICS_NOTIFICATION, 0x9d
Jan 26 21:30:45 rainbow kernel: [  125.425935] ieee80211 phy0: I
iwl3945_rx_handle r = 114, i = 113, SCAN_START_NOTIFICATION, 0x82
Jan 26 21:30:45 rainbow kernel: [  125.425946] ieee80211 phy0: I
iwl3945_rx_scan_start_notif Scan start: 64 [802.11a] (TSF:
0x00000000:00140A8D) - 1 (beacon timer 201344371)
Jan 26 21:30:45 rainbow kernel: [  125.538579] ieee80211 phy0: I
iwl3945_rx_handle r = 115, i = 114, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 21:30:45 rainbow kernel: [  125.538610] ieee80211 phy0: I
iwl3945_rx_scan_results_notif Scan ch.res: 64 [802.11a] (TSF:
0x00000000:0015C296) - 0 elapsed=112649 usec (112ms since last)
Jan 26 21:30:45 rainbow kernel: [  125.539859] ieee80211 phy0: I
iwl3945_rx_handle r = 117, i = 115, STATISTICS_NOTIFICATION, 0x9d
Jan 26 21:30:45 rainbow kernel: [  125.539884] ieee80211 phy0: I
iwl3945_rx_handle r = 117, i = 116, SCAN_START_NOTIFICATION, 0x82
Jan 26 21:30:45 rainbow kernel: [  125.539896] ieee80211 phy0: I
iwl3945_rx_scan_start_notif Scan start: 149 [802.11a] (TSF:
0x00000000:0015C7A8) - 1 (beacon timer 218110040)
Jan 26 21:30:45 rainbow kernel: [  125.652480] ieee80211 phy0: I
iwl3945_rx_handle r = 118, i = 117, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 21:30:45 rainbow kernel: [  125.652493] ieee80211 phy0: I
iwl3945_rx_scan_results_notif Scan ch.res: 149 [802.11a] (TSF:
0x00000000:00177FB0) - 0 elapsed=112648 usec (116ms since last)
Jan 26 21:30:45 rainbow kernel: [  125.653420] ieee80211 phy0: I
iwl3945_rx_handle r = 120, i = 118, STATISTICS_NOTIFICATION, 0x9d
Jan 26 21:30:45 rainbow kernel: [  125.653429] ieee80211 phy0: I
iwl3945_rx_handle r = 120, i = 119, SCAN_START_NOTIFICATION, 0x82
Jan 26 21:30:45 rainbow kernel: [  125.653434] ieee80211 phy0: I
iwl3945_rx_scan_start_notif Scan start: 153 [802.11a] (TSF:
0x00000000:00178367) - 1 (beacon timer 251755673)
Jan 26 21:30:45 rainbow kernel: [  125.766137] ieee80211 phy0: I
iwl3945_rx_handle r = 121, i = 120, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 21:30:45 rainbow kernel: [  125.766143] ieee80211 phy0: I
iwl3945_rx_scan_results_notif Scan ch.res: 153 [802.11a] (TSF:
0x00000000:00193B6F) - 0 elapsed=112648 usec (112ms since last)
Jan 26 21:30:45 rainbow kernel: [  125.767072] ieee80211 phy0: I
iwl3945_rx_handle r = 123, i = 121, STATISTICS_NOTIFICATION, 0x9d
Jan 26 21:30:45 rainbow kernel: [  125.767082] ieee80211 phy0: I
iwl3945_rx_handle r = 123, i = 122, SCAN_START_NOTIFICATION, 0x82
Jan 26 21:30:45 rainbow kernel: [  125.767087] ieee80211 phy0: I
iwl3945_rx_scan_start_notif Scan start: 157 [802.11a] (TSF:
0x00000000:00193F1B) - 1 (beacon timer 268521701)
Jan 26 21:30:45 rainbow kernel: [  125.879741] ieee80211 phy0: I
iwl3945_rx_handle r = 124, i = 123, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 21:30:45 rainbow kernel: [  125.879756] ieee80211 phy0: I
iwl3945_rx_scan_results_notif Scan ch.res: 157 [802.11a] (TSF:
0x00000000:001AF724) - 0 elapsed=112649 usec (112ms since last)
Jan 26 21:30:45 rainbow kernel: [  125.880655] ieee80211 phy0: I
iwl3945_rx_handle r = 126, i = 124, STATISTICS_NOTIFICATION, 0x9d
Jan 26 21:30:45 rainbow kernel: [  125.880684] ieee80211 phy0: I
iwl3945_rx_handle r = 126, i = 125, SCAN_START_NOTIFICATION, 0x82
Jan 26 21:30:45 rainbow kernel: [  125.880700] ieee80211 phy0: I
iwl3945_rx_scan_start_notif Scan start: 161 [802.11a] (TSF:
0x00000000:001AFADA) - 1 (beacon timer 285287718)
Jan 26 21:30:45 rainbow kernel: [  125.993342] ieee80211 phy0: I
iwl3945_rx_handle r = 127, i = 126, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 21:30:45 rainbow kernel: [  125.993356] ieee80211 phy0: I
iwl3945_rx_scan_results_notif Scan ch.res: 161 [802.11a] (TSF:
0x00000000:001CB2E3) - 0 elapsed=112649 usec (116ms since last)
Jan 26 21:30:45 rainbow kernel: [  125.994286] ieee80211 phy0: I
iwl3945_rx_handle r = 129, i = 127, STATISTICS_NOTIFICATION, 0x9d
Jan 26 21:30:45 rainbow kernel: [  125.994310] ieee80211 phy0: I
iwl3945_rx_handle r = 129, i = 128, SCAN_START_NOTIFICATION, 0x82
Jan 26 21:30:45 rainbow kernel: [  125.994320] ieee80211 phy0: I
iwl3945_rx_scan_start_notif Scan start: 165 [802.11a] (TSF:
0x00000000:001CB69D) - 1 (beacon timer 302053731)
Jan 26 21:30:45 rainbow kernel: [  126.106941] ieee80211 phy0: I
iwl3945_rx_handle r = 130, i = 129, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 21:30:45 rainbow kernel: [  126.106956] ieee80211 phy0: I
iwl3945_rx_scan_results_notif Scan ch.res: 165 [802.11a] (TSF:
0x00000000:001E6EA6) - 0 elapsed=112649 usec (112ms since last)
Jan 26 21:30:45 rainbow kernel: [  126.108010] ieee80211 phy0: I
iwl3945_rx_handle r = 131, i = 130, SCAN_COMPLETE_NOTIFICATION, 0x84
Jan 26 21:30:45 rainbow kernel: [  126.108021] ieee80211 phy0: I
iwl3945_rx_scan_complete_notif Scan complete: 13 channels (TSF
0x001E72D8:00000000) - 1
Jan 26 21:30:45 rainbow kernel: [  126.108031] ieee80211 phy0: I
iwl3945_rx_scan_complete_notif Scan pass on 5.2GHz took 1476ms
Jan 26 21:30:45 rainbow kernel: [  126.108039] ieee80211 phy0: I
iwl3945_rx_scan_complete_notif Setting scan to off
Jan 26 21:30:45 rainbow kernel: [  126.108047] ieee80211 phy0: I
iwl3945_rx_scan_complete_notif Scan took 1848ms
Jan 26 21:30:45 rainbow kernel: [  126.108097] ieee80211 phy0: U
iwl3945_bg_scan_completed SCAN complete scan
Jan 26 21:30:45 rainbow kernel: [  126.108124] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 235 dsp 109 rate code 0x0d
Jan 26 21:30:45 rainbow kernel: [  126.108136] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 235 dsp 109 rate code 0x0f
Jan 26 21:30:45 rainbow kernel: [  126.108146] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 235 dsp 109 rate code 0x05
Jan 26 21:30:45 rainbow kernel: [  126.108156] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 235 dsp 109 rate code 0x07
Jan 26 21:30:45 rainbow kernel: [  126.108165] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 235 dsp 109 rate code 0x09
Jan 26 21:30:45 rainbow kernel: [  126.108175] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 235 dsp 109 rate code 0x0b
Jan 26 21:30:45 rainbow kernel: [  126.108184] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 235 dsp 109 rate code 0x01
Jan 26 21:30:45 rainbow kernel: [  126.108194] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 235 dsp 109 rate code 0x03
Jan 26 21:30:45 rainbow kernel: [  126.108247] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 171 dsp  98 rate code 0x0a
Jan 26 21:30:45 rainbow kernel: [  126.108258] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 171 dsp  98 rate code 0x14
Jan 26 21:30:45 rainbow kernel: [  126.108269] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 171 dsp  98 rate code 0x37
Jan 26 21:30:45 rainbow kernel: [  126.108279] ieee80211 phy0: U
iwl3945_hw_reg_send_txpower ch 11:1 rf 171 dsp  98 rate code 0x6e
Jan 26 21:30:45 rainbow kernel: [  126.108296] ieee80211 phy0: U
iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq:
0x040B, 56 bytes at 11[11]:4
Jan 26 21:30:45 rainbow kernel: [  126.108402] ieee80211 phy0: I
iwl3945_rx_handle r 132 i 131 No handler needed for
REPLY_TX_PWR_TABLE_CMD, 0x97
Jan 26 21:30:45 rainbow kernel: [  126.112569] ieee80211 phy0: I
iwl3945_rx_handle r = 133, i = 132, REPLY_3945_RX, 0x1b
Jan 26 21:30:45 rainbow kernel: [  126.112849] ieee80211 phy0: U
iwl3945_mac_config enter to channel 11
Jan 26 21:30:45 rainbow kernel: [  126.112870] ieee80211 phy0: U
iwl3945_commit_rxon Sending RXON
Jan 26 21:30:45 rainbow kernel: [  126.112873] * without RXON_FILTER_ASSOC_MSK
Jan 26 21:30:45 rainbow kernel: [  126.112875] * channel = 11
Jan 26 21:30:45 rainbow kernel: [  126.112877] * bssid = 00:00:00:00:00:00
