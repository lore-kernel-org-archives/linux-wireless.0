Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f21.google.com ([209.85.217.21]:59696 "EHLO
	mail-gx0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbZA0Dfn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2009 22:35:43 -0500
Received: by gxk14 with SMTP id 14so5451479gxk.13
        for <linux-wireless@vger.kernel.org>; Mon, 26 Jan 2009 19:35:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <c4d76b3b0901261913s23427b19tbbe34ee7b4261068@mail.gmail.com>
References: <760481.57662.qm@web57614.mail.re1.yahoo.com>
	 <20090126114453.GB3197@sortiz.org>
	 <c4d76b3b0901261913s23427b19tbbe34ee7b4261068@mail.gmail.com>
Date: Mon, 26 Jan 2009 22:35:39 -0500
Message-ID: <c4d76b3b0901261935n1846b675w72cfa7308d198080@mail.gmail.com> (sfid-20090127_043600_858124_1EDF3BE5)
Subject: Re: kernel BUG at drivers/net/wireless/iwlwifi/iwl3945-base.c:3127!
From: Jason Andryuk <jandryuk@gmail.com>
To: Samuel Ortiz <samuel@sortiz.org>
Cc: reinette chatre <reinette.chatre@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 26, 2009 at 10:13 PM, Jason Andryuk <jandryuk@gmail.com> wrote:
> I was away from the computer, so I would not have been able to test
> anything anyway.
>
> I tested  wireless-testings of  master-2009-01-23 and had the same
> inability to authenticate.  The WARNING (previous BUG) was triggered.
> Below are the logs.
>
> I see wireless-testing merged some of your commits, so I'll go try those out.
>
> Jason

Same result: no authentication.  The "wrong command queue 0, sequence
0x0 readp=9 writep=9" message came twice right after Network Manager
gave up and displayed the status of the interface as disconnected.

Is the "Microcode SW error detected. Restarting 0x82000008." message
of concern?  I have seen that in all the traces.

Jason

Jan 26 22:22:17 rainbow kernel: Inspecting /boot/System.map-2.6.29-rc2-wl
Jan 26 22:22:17 rainbow kernel: Cannot find map file.
Jan 26 22:22:17 rainbow kernel: Loaded 54530 symbols from 89 modules.
Jan 26 22:22:17 rainbow kernel: [    0.000000] Initializing cgroup subsys cpuset
Jan 26 22:22:17 rainbow kernel: [    0.000000] Initializing cgroup subsys cpu
Jan 26 22:22:17 rainbow kernel: [    0.000000] Linux version
2.6.29-rc2-wl (captainamerica@rainbow) (gcc version 4.3.2 (Ubuntu
4.3.2-1ubuntu11) ) #26 SMP Mon Jan 26 22:17:19 EST 2009
Jan 26 22:22:17 rainbow kernel: [    0.000000] Command line:
root=UUID=b49fa89a-8364-4ea0-b712-438b002b45c1 ro debug
netconsole=@169.254.1.1/eth0,@169.254.242.220/
Jan 26 22:22:17 rainbow kernel: [    0.000000] KERNEL supported cpus:
Jan 26 22:22:17 rainbow kernel: [    0.000000]   Intel GenuineIntel
Jan 26 22:22:17 rainbow kernel: [    0.000000]   AMD AuthenticAMD
Jan 26 22:22:17 rainbow kernel: [    0.000000]   Centaur CentaurHauls
Jan 26 22:22:17 rainbow kernel: [    0.000000] BIOS-provided physical RAM map:
Jan 26 22:22:17 rainbow kernel: [    0.000000]  BIOS-e820:
0000000000000000 - 000000000009d800 (usable)
Jan 26 22:22:17 rainbow kernel: [    0.000000]  BIOS-e820:
000000000009d800 - 00000000000a0000 (reserved)
Jan 26 22:22:17 rainbow kernel: [    0.000000]  BIOS-e820:
00000000000d2000 - 00000000000d4000 (reserved)
Jan 26 22:22:17 rainbow kernel: [    0.000000]  BIOS-e820:
00000000000e0000 - 0000000000100000 (reserved)
Jan 26 22:22:17 rainbow kernel: [    0.000000]  BIOS-e820:
0000000000100000 - 00000000bf6b0000 (usable)
Jan 26 22:22:17 rainbow kernel: [    0.000000]  BIOS-e820:
00000000bf6b0000 - 00000000bf6cc000 (ACPI data)
Jan 26 22:22:17 rainbow kernel: [    0.000000]  BIOS-e820:
00000000bf6cc000 - 00000000bf700000 (ACPI NVS)
Jan 26 22:22:17 rainbow kernel: [    0.000000]  BIOS-e820:
00000000bf700000 - 00000000c0000000 (reserved)
Jan 26 22:22:17 rainbow kernel: [    0.000000]  BIOS-e820:
00000000f0000000 - 00000000f4000000 (reserved)
Jan 26 22:22:17 rainbow kernel: [    0.000000]  BIOS-e820:
00000000fec00000 - 00000000fec10000 (reserved)
Jan 26 22:22:17 rainbow kernel: [    0.000000]  BIOS-e820:
00000000fed00000 - 00000000fed00400 (reserved)
Jan 26 22:22:17 rainbow kernel: [    0.000000]  BIOS-e820:
00000000fed14000 - 00000000fed1a000 (reserved)
Jan 26 22:22:17 rainbow kernel: [    0.000000]  BIOS-e820:
00000000fed1c000 - 00000000fed90000 (reserved)
Jan 26 22:22:17 rainbow kernel: [    0.000000]  BIOS-e820:
00000000fee00000 - 00000000fee01000 (reserved)
Jan 26 22:22:17 rainbow kernel: [    0.000000]  BIOS-e820:
00000000ff000000 - 0000000100000000 (reserved)
Jan 26 22:22:17 rainbow kernel: [    0.000000]  BIOS-e820:
0000000100000000 - 000000013c000000 (usable)
Jan 26 22:22:17 rainbow kernel: [    0.000000] DMI present.
Jan 26 22:22:17 rainbow kernel: [    0.000000] last_pfn = 0x13c000
max_arch_pfn = 0x100000000
Jan 26 22:22:17 rainbow kernel: [    0.000000] last_pfn = 0xbf6b0
max_arch_pfn = 0x100000000
Jan 26 22:22:17 rainbow kernel: [    0.000000] init_memory_mapping:
0000000000000000-00000000bf6b0000
Jan 26 22:22:17 rainbow kernel: [    0.000000]  0000000000 - 00bf600000 page 2M
Jan 26 22:22:17 rainbow kernel: [    0.000000]  00bf600000 - 00bf6b0000 page 4k
Jan 26 22:22:17 rainbow kernel: [    0.000000] kernel direct mapping
tables up to bf6b0000 @ 8000-d000
Jan 26 22:22:17 rainbow kernel: [    0.000000] last_map_addr: bf6b0000
end: bf6b0000
Jan 26 22:22:17 rainbow kernel: [    0.000000] init_memory_mapping:
0000000100000000-000000013c000000
Jan 26 22:22:17 rainbow kernel: [    0.000000]  0100000000 - 013c000000 page 2M
Jan 26 22:22:17 rainbow kernel: [    0.000000] kernel direct mapping
tables up to 13c000000 @ b000-11000
Jan 26 22:22:17 rainbow kernel: [    0.000000] last_map_addr:
13c000000 end: 13c000000
Jan 26 22:22:17 rainbow kernel: [    0.000000] RAMDISK: 369d7000 - 37fef916
Jan 26 22:22:17 rainbow kernel: [    0.000000] ACPI: RSDP 000F68D0,
0024 (r2 LENOVO)
Jan 26 22:22:17 rainbow kernel: [    0.000000] ACPI: XSDT BF6BB74D,
0094 (r1 LENOVO TP-7L        2120  LTP        0)
Jan 26 22:22:17 rainbow kernel: [    0.000000] ACPI: FACP BF6BB800,
00F4 (r3 LENOVO TP-7L        2120 LNVO        1)
Jan 26 22:22:17 rainbow kernel: [    0.000000] ACPI Warning
(tbfadt-0568): 32/64X length mismatch in Gpe0Block: 64/32 [20081204]
Jan 26 22:22:17 rainbow kernel: [    0.000000] ACPI Warning
(tbfadt-0568): 32/64X length mismatch in Gpe1Block: 0/32 [20081204]
Jan 26 22:22:17 rainbow kernel: [    0.000000] ACPI Warning
(tbfadt-0596): Optional field Gpe1Block has zero address or length:
000000000000102C/0 [20081204]
Jan 26 22:22:17 rainbow kernel: [    0.000000] FADT:
X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
Jan 26 22:22:17 rainbow kernel: [    0.000000] ACPI: DSDT BF6BBC1D,
FF03 (r1 LENOVO TP-7L        2120 MSFT  3000000)
Jan 26 22:22:17 rainbow kernel: [    0.000000] ACPI: FACS BF6E4000, 0040
Jan 26 22:22:17 rainbow kernel: [    0.000000] ACPI: SSDT BF6BB9B4,
0269 (r1 LENOVO TP-7L        2120 MSFT  3000000)
Jan 26 22:22:17 rainbow kernel: [    0.000000] ACPI: ECDT BF6CBB20,
0052 (r1 LENOVO TP-7L        2120 LNVO        1)
Jan 26 22:22:17 rainbow kernel: [    0.000000] ACPI: TCPA BF6CBB72,
0032 (r2 LENOVO TP-7L        2120 LNVO        1)
Jan 26 22:22:17 rainbow kernel: [    0.000000] ACPI: APIC BF6CBBA4,
0068 (r1 LENOVO TP-7L        2120 LNVO        1)
Jan 26 22:22:17 rainbow kernel: [    0.000000] ACPI: MCFG BF6CBC0C,
003C (r1 LENOVO TP-7L        2120 LNVO        1)
Jan 26 22:22:17 rainbow kernel: [    0.000000] ACPI: HPET BF6CBC48,
0038 (r1 LENOVO TP-7L        2120 LNVO        1)
Jan 26 22:22:17 rainbow kernel: [    0.000000] ACPI: SLIC BF6CBDF0,
0176 (r1 LENOVO TP-7L        2120  LTP        0)
Jan 26 22:22:17 rainbow kernel: [    0.000000] ACPI: BOOT BF6CBF66,
0028 (r1 LENOVO TP-7L        2120  LTP        1)
Jan 26 22:22:17 rainbow kernel: [    0.000000] ACPI: ASF! BF6CBF8E,
0072 (r16 LENOVO TP-7L        2120 PTL         1)
Jan 26 22:22:17 rainbow kernel: [    0.000000] ACPI: SSDT BF6E26D9,
025F (r1 LENOVO TP-7L        2120 INTL 20050513)
Jan 26 22:22:17 rainbow kernel: [    0.000000] ACPI: SSDT BF6E2938,
00A6 (r1 LENOVO TP-7L        2120 INTL 20050513)
Jan 26 22:22:17 rainbow kernel: [    0.000000] ACPI: SSDT BF6E29DE,
04F7 (r1 LENOVO TP-7L        2120 INTL 20050513)
Jan 26 22:22:17 rainbow kernel: [    0.000000] ACPI: SSDT BF6E2ED5,
01D8 (r1 LENOVO TP-7L        2120 INTL 20050513)
Jan 26 22:22:17 rainbow kernel: [    0.000000] ACPI: DMI detected:
Lenovo ThinkPad T61
Jan 26 22:22:17 rainbow kernel: [    0.000000] ACPI: Added _OSI(Linux)
Jan 26 22:22:17 rainbow kernel: [    0.000000] ACPI: Local APIC
address 0xfee00000
Jan 26 22:22:17 rainbow kernel: [    0.000000] No NUMA configuration found
Jan 26 22:22:17 rainbow kernel: [    0.000000] Faking a node at
0000000000000000-000000013c000000
Jan 26 22:22:17 rainbow kernel: [    0.000000] Bootmem setup node 0
0000000000000000-000000013c000000
Jan 26 22:22:17 rainbow kernel: [    0.000000]   NODE_DATA
[0000000000001000 - 0000000000005fff]
Jan 26 22:22:17 rainbow kernel: [    0.000000]   bootmap
[000000000000c000 -  00000000000337ff] pages 28
Jan 26 22:22:17 rainbow kernel: [    0.000000] (7 early reservations)
==> bootmem [0000000000 - 013c000000]
Jan 26 22:22:17 rainbow kernel: [    0.000000]   #0 [0000000000 -
0000001000]   BIOS data page ==> [0000000000 - 0000001000]
Jan 26 22:22:17 rainbow kernel: [    0.000000]   #1 [0000006000 -
0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
Jan 26 22:22:17 rainbow kernel: [    0.000000]   #2 [0000200000 -
00008ec840]    TEXT DATA BSS ==> [0000200000 - 00008ec840]
Jan 26 22:22:17 rainbow kernel: [    0.000000]   #3 [00369d7000 -
0037fef916]          RAMDISK ==> [00369d7000 - 0037fef916]
Jan 26 22:22:17 rainbow kernel: [    0.000000]   #4 [000009d800 -
0000100000]    BIOS reserved ==> [000009d800 - 0000100000]
Jan 26 22:22:17 rainbow kernel: [    0.000000]   #5 [0000008000 -
000000b000]          PGTABLE ==> [0000008000 - 000000b000]
Jan 26 22:22:17 rainbow kernel: [    0.000000]   #6 [000000b000 -
000000c000]          PGTABLE ==> [000000b000 - 000000c000]
Jan 26 22:22:17 rainbow kernel: [    0.000000] found SMP MP-table at
[ffff8800000f6900] 000f6900
Jan 26 22:22:17 rainbow kernel: [    0.000000]
[ffffe20000000000-ffffe200045fffff] PMD ->
[ffff880028200000-ffff88002b9fffff] on node 0
Jan 26 22:22:17 rainbow kernel: [    0.000000] Zone PFN ranges:
Jan 26 22:22:17 rainbow kernel: [    0.000000]   DMA      0x00000000
-> 0x00001000
Jan 26 22:22:17 rainbow kernel: [    0.000000]   DMA32    0x00001000
-> 0x00100000
Jan 26 22:22:17 rainbow kernel: [    0.000000]   Normal   0x00100000
-> 0x0013c000
Jan 26 22:22:17 rainbow kernel: [    0.000000] Movable zone start PFN
for each node
Jan 26 22:22:17 rainbow kernel: [    0.000000] early_node_map[3]
active PFN ranges
Jan 26 22:22:17 rainbow kernel: [    0.000000]     0: 0x00000000 -> 0x0000009d
Jan 26 22:22:17 rainbow kernel: [    0.000000]     0: 0x00000100 -> 0x000bf6b0
Jan 26 22:22:17 rainbow kernel: [    0.000000]     0: 0x00100000 -> 0x0013c000
Jan 26 22:22:17 rainbow kernel: [    0.000000] On node 0 totalpages: 1029709
Jan 26 22:22:17 rainbow kernel: [    0.000000]   DMA zone: 56 pages
used for memmap
Jan 26 22:22:17 rainbow kernel: [    0.000000]   DMA zone: 1879 pages reserved
Jan 26 22:22:17 rainbow kernel: [    0.000000]   DMA zone: 2062 pages,
LIFO batch:0
Jan 26 22:22:17 rainbow kernel: [    0.000000]   DMA32 zone: 14280
pages used for memmap
Jan 26 22:22:17 rainbow kernel: [    0.000000]   DMA32 zone: 765672
pages, LIFO batch:31
Jan 26 22:22:17 rainbow kernel: [    0.000000]   Normal zone: 3360
pages used for memmap
Jan 26 22:22:17 rainbow kernel: [    0.000000]   Normal zone: 242400
pages, LIFO batch:31
Jan 26 22:22:17 rainbow kernel: [    0.000000] ACPI: PM-Timer IO Port: 0x1008
Jan 26 22:22:17 rainbow kernel: [    0.000000] ACPI: Local APIC
address 0xfee00000
Jan 26 22:22:17 rainbow kernel: [    0.000000] ACPI: LAPIC
(acpi_id[0x00] lapic_id[0x00] enabled)
Jan 26 22:22:17 rainbow kernel: [    0.000000] ACPI: LAPIC
(acpi_id[0x01] lapic_id[0x01] enabled)
Jan 26 22:22:17 rainbow kernel: [    0.000000] ACPI: LAPIC_NMI
(acpi_id[0x00] high edge lint[0x1])
Jan 26 22:22:17 rainbow kernel: [    0.000000] ACPI: LAPIC_NMI
(acpi_id[0x01] high edge lint[0x1])
Jan 26 22:22:17 rainbow kernel: [    0.000000] ACPI: IOAPIC (id[0x01]
address[0xfec00000] gsi_base[0])
Jan 26 22:22:17 rainbow kernel: [    0.000000] IOAPIC[0]: apic_id 1,
version 0, address 0xfec00000, GSI 0-23
Jan 26 22:22:17 rainbow kernel: [    0.000000] ACPI: INT_SRC_OVR (bus
0 bus_irq 0 global_irq 2 dfl dfl)
Jan 26 22:22:17 rainbow kernel: [    0.000000] ACPI: INT_SRC_OVR (bus
0 bus_irq 9 global_irq 9 high level)
Jan 26 22:22:17 rainbow kernel: [    0.000000] ACPI: IRQ0 used by override.
Jan 26 22:22:17 rainbow kernel: [    0.000000] ACPI: IRQ2 used by override.
Jan 26 22:22:17 rainbow kernel: [    0.000000] ACPI: IRQ9 used by override.
Jan 26 22:22:17 rainbow kernel: [    0.000000] Using ACPI (MADT) for
SMP configuration information
Jan 26 22:22:17 rainbow kernel: [    0.000000] ACPI: HPET id:
0x8086a201 base: 0xfed00000
Jan 26 22:22:17 rainbow kernel: [    0.000000] SMP: Allowing 2 CPUs, 0
hotplug CPUs
Jan 26 22:22:17 rainbow kernel: [    0.000000] PM: Registered nosave
memory: 000000000009d000 - 000000000009e000
Jan 26 22:22:17 rainbow kernel: [    0.000000] PM: Registered nosave
memory: 000000000009e000 - 00000000000a0000
Jan 26 22:22:17 rainbow kernel: [    0.000000] PM: Registered nosave
memory: 00000000000a0000 - 00000000000d2000
Jan 26 22:22:17 rainbow kernel: [    0.000000] PM: Registered nosave
memory: 00000000000d2000 - 00000000000d4000
Jan 26 22:22:17 rainbow kernel: [    0.000000] PM: Registered nosave
memory: 00000000000d4000 - 00000000000e0000
Jan 26 22:22:17 rainbow kernel: [    0.000000] PM: Registered nosave
memory: 00000000000e0000 - 0000000000100000
Jan 26 22:22:17 rainbow kernel: [    0.000000] PM: Registered nosave
memory: 00000000bf6b0000 - 00000000bf6cc000
Jan 26 22:22:17 rainbow kernel: [    0.000000] PM: Registered nosave
memory: 00000000bf6cc000 - 00000000bf700000
Jan 26 22:22:17 rainbow kernel: [    0.000000] PM: Registered nosave
memory: 00000000bf700000 - 00000000c0000000
Jan 26 22:22:17 rainbow kernel: [    0.000000] PM: Registered nosave
memory: 00000000c0000000 - 00000000f0000000
Jan 26 22:22:17 rainbow kernel: [    0.000000] PM: Registered nosave
memory: 00000000f0000000 - 00000000f4000000
Jan 26 22:22:17 rainbow kernel: [    0.000000] PM: Registered nosave
memory: 00000000f4000000 - 00000000fec00000
Jan 26 22:22:17 rainbow kernel: [    0.000000] PM: Registered nosave
memory: 00000000fec00000 - 00000000fec10000
Jan 26 22:22:17 rainbow kernel: [    0.000000] PM: Registered nosave
memory: 00000000fec10000 - 00000000fed00000
Jan 26 22:22:17 rainbow kernel: [    0.000000] PM: Registered nosave
memory: 00000000fed00000 - 00000000fed14000
Jan 26 22:22:17 rainbow kernel: [    0.000000] PM: Registered nosave
memory: 00000000fed14000 - 00000000fed1a000
Jan 26 22:22:17 rainbow kernel: [    0.000000] PM: Registered nosave
memory: 00000000fed1a000 - 00000000fed1c000
Jan 26 22:22:17 rainbow kernel: [    0.000000] PM: Registered nosave
memory: 00000000fed1c000 - 00000000fed90000
Jan 26 22:22:17 rainbow kernel: [    0.000000] PM: Registered nosave
memory: 00000000fed90000 - 00000000fee00000
Jan 26 22:22:17 rainbow kernel: [    0.000000] PM: Registered nosave
memory: 00000000fee00000 - 00000000fee01000
Jan 26 22:22:17 rainbow kernel: [    0.000000] PM: Registered nosave
memory: 00000000fee01000 - 00000000ff000000
Jan 26 22:22:17 rainbow kernel: [    0.000000] PM: Registered nosave
memory: 00000000ff000000 - 0000000100000000
Jan 26 22:22:17 rainbow kernel: [    0.000000] Allocating PCI
resources starting at c4000000 (gap: c0000000:30000000)
Jan 26 22:22:17 rainbow kernel: [    0.000000] NR_CPUS:64
nr_cpumask_bits:64 nr_cpu_ids:2 nr_node_ids:1
Jan 26 22:22:17 rainbow kernel: [    0.000000] PERCPU: Allocating
65536 bytes of per cpu data
Jan 26 22:22:17 rainbow kernel: [    0.000000] Built 1 zonelists in
Node order, mobility grouping on.  Total pages: 1010134
Jan 26 22:22:17 rainbow kernel: [    0.000000] Policy zone: Normal
Jan 26 22:22:17 rainbow kernel: [    0.000000] Kernel command line:
root=UUID=b49fa89a-8364-4ea0-b712-438b002b45c1 ro debug
netconsole=@169.254.1.1/eth0,@169.254.242.220/
Jan 26 22:22:17 rainbow kernel: [    0.000000] Initializing CPU#0
Jan 26 22:22:17 rainbow kernel: [    0.000000] PID hash table entries:
4096 (order: 12, 32768 bytes)
Jan 26 22:22:17 rainbow kernel: [    0.000000] Extended CMOS year: 2000
Jan 26 22:22:17 rainbow kernel: [    0.000000] Fast TSC calibration using PIT
Jan 26 22:22:17 rainbow kernel: [    0.000000] Detected 2194.675 MHz processor.
Jan 26 22:22:17 rainbow kernel: [    0.004000] Console: colour VGA+ 80x25
Jan 26 22:22:17 rainbow kernel: [    0.004000] console [tty0] enabled
Jan 26 22:22:17 rainbow kernel: [    0.004000] allocated 41943040
bytes of page_cgroup
Jan 26 22:22:17 rainbow kernel: [    0.004000] please try
cgroup_disable=memory option if you don't want
Jan 26 22:22:17 rainbow kernel: [    0.004000] Checking aperture...
Jan 26 22:22:17 rainbow kernel: [    0.004000] No AGP bridge found
Jan 26 22:22:17 rainbow kernel: [    0.004000] PCI-DMA: Using software
bounce buffering for IO (SWIOTLB)
Jan 26 22:22:17 rainbow kernel: [    0.004000] Placing 64MB software
IO TLB between ffff880020000000 - ffff880024000000
Jan 26 22:22:17 rainbow kernel: [    0.004000] software IO TLB at phys
0x20000000 - 0x24000000
Jan 26 22:22:17 rainbow kernel: [    0.004000] Memory:
3924480k/5177344k available (3232k kernel code, 1058508k absent,
194356k reserved, 1772k data, 552k init)
Jan 26 22:22:17 rainbow kernel: [    0.004000] SLUB: Genslabs=13,
HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
Jan 26 22:22:17 rainbow kernel: [    0.004000] hpet clockevent registered
Jan 26 22:22:17 rainbow kernel: [    0.004000] HPET: 3 timers in
total, 0 timers will be used for per-cpu timer
Jan 26 22:22:17 rainbow kernel: [    0.004000] Calibrating delay loop
(skipped), value calculated using timer frequency.. 4389.35 BogoMIPS
(lpj=8778700)
Jan 26 22:22:17 rainbow kernel: [    0.004000] Security Framework initialized
Jan 26 22:22:17 rainbow kernel: [    0.004000] SELinux:  Disabled at boot.
Jan 26 22:22:17 rainbow kernel: [    0.004000] Dentry cache hash table
entries: 524288 (order: 10, 4194304 bytes)
Jan 26 22:22:17 rainbow kernel: [    0.004000] Inode-cache hash table
entries: 262144 (order: 9, 2097152 bytes)
Jan 26 22:22:17 rainbow kernel: [    0.004809] Mount-cache hash table
entries: 256
Jan 26 22:22:17 rainbow kernel: [    0.005020] Initializing cgroup subsys ns
Jan 26 22:22:17 rainbow kernel: [    0.005696] Initializing cgroup
subsys cpuacct
Jan 26 22:22:17 rainbow kernel: [    0.005749] Initializing cgroup subsys memory
Jan 26 22:22:17 rainbow kernel: [    0.005799] Initializing cgroup
subsys freezer
Jan 26 22:22:17 rainbow kernel: [    0.005863] CPU: L1 I cache: 32K,
L1 D cache: 32K
Jan 26 22:22:17 rainbow kernel: [    0.005956] CPU: L2 cache: 4096K
Jan 26 22:22:17 rainbow kernel: [    0.006007] [ds] using core 2 configuration
Jan 26 22:22:17 rainbow kernel: [    0.006060] CPU 0/0x0 -> Node 0
Jan 26 22:22:17 rainbow kernel: [    0.006114] CPU: Physical Processor ID: 0
Jan 26 22:22:17 rainbow kernel: [    0.006167] CPU: Processor Core ID: 0
Jan 26 22:22:17 rainbow kernel: [    0.006998] CPU0: Thermal
monitoring enabled (TM2)
Jan 26 22:22:17 rainbow kernel: [    0.007053] using mwait in idle threads.
Jan 26 22:22:17 rainbow kernel: [    0.008885] ACPI: Core revision 20081204
Jan 26 22:22:17 rainbow kernel: [    0.032059] Setting APIC routing to flat
Jan 26 22:22:17 rainbow kernel: [    0.032655] ..TIMER: vector=0x30
apic1=0 pin1=2 apic2=-1 pin2=-1
Jan 26 22:22:17 rainbow kernel: [    0.075800] CPU0: Intel(R)
Core(TM)2 Duo CPU     T7500  @ 2.20GHz stepping 0b
Jan 26 22:22:17 rainbow kernel: [    0.076001] Booting processor 1
APIC 0x1 ip 0x6000
Jan 26 22:22:17 rainbow kernel: [    0.004000] Initializing CPU#1
Jan 26 22:22:17 rainbow kernel: [    0.004000] Calibrating delay using
timer specific routine.. 4388.96 BogoMIPS (lpj=8777929)
Jan 26 22:22:17 rainbow kernel: [    0.004000] CPU: L1 I cache: 32K,
L1 D cache: 32K
Jan 26 22:22:17 rainbow kernel: [    0.004000] CPU: L2 cache: 4096K
Jan 26 22:22:17 rainbow kernel: [    0.004000] [ds] using core 2 configuration
Jan 26 22:22:17 rainbow kernel: [    0.004000] CPU 1/0x1 -> Node 0
Jan 26 22:22:17 rainbow kernel: [    0.004000] CPU: Physical Processor ID: 0
Jan 26 22:22:17 rainbow kernel: [    0.004000] CPU: Processor Core ID: 1
Jan 26 22:22:17 rainbow kernel: [    0.004000] CPU1: Thermal
monitoring enabled (TM2)
Jan 26 22:22:17 rainbow kernel: [    0.160608] CPU1: Intel(R)
Core(TM)2 Duo CPU     T7500  @ 2.20GHz stepping 0b
Jan 26 22:22:17 rainbow kernel: [    0.161373] checking TSC
synchronization [CPU#0 -> CPU#1]:
Jan 26 22:22:17 rainbow kernel: [    0.164001] Measured 359359 cycles
TSC warp between CPUs, turning off TSC clock.
Jan 26 22:22:17 rainbow kernel: [    0.164001] Marking TSC unstable
due to check_tsc_sync_source failed
Jan 26 22:22:17 rainbow kernel: [    0.164094] Brought up 2 CPUs
Jan 26 22:22:17 rainbow kernel: [    0.164157] Total of 2 processors
activated (8778.31 BogoMIPS).
Jan 26 22:22:17 rainbow kernel: [    0.164280] CPU0 attaching sched-domain:
Jan 26 22:22:17 rainbow kernel: [    0.164345]  domain 0: span 0-1 level MC
Jan 26 22:22:17 rainbow kernel: [    0.164457]   groups: 0 1
Jan 26 22:22:17 rainbow kernel: [    0.164664] CPU1 attaching sched-domain:
Jan 26 22:22:17 rainbow kernel: [    0.164725]  domain 0: span 0-1 level MC
Jan 26 22:22:17 rainbow kernel: [    0.164831]   groups: 1 0
Jan 26 22:22:17 rainbow kernel: [    0.165101] net_namespace: 1840 bytes
Jan 26 22:22:17 rainbow kernel: [    0.165101] Booting paravirtualized
kernel on bare hardware
Jan 26 22:22:17 rainbow kernel: [    0.165101] Time:  3:21:53  Date: 01/27/09
Jan 26 22:22:17 rainbow kernel: [    0.165101] NET: Registered
protocol family 16
Jan 26 22:22:17 rainbow kernel: [    0.165101] ACPI FADT declares the
system doesn't support PCIe ASPM, so disable it
Jan 26 22:22:17 rainbow kernel: [    0.165101] ACPI: bus type pci registered
Jan 26 22:22:17 rainbow kernel: [    0.165101] PCI: MCFG configuration
0: base f0000000 segment 0 buses 0 - 63
Jan 26 22:22:17 rainbow kernel: [    0.168004] PCI: MCFG area at
f0000000 reserved in E820
Jan 26 22:22:17 rainbow kernel: [    0.170582] PCI: Using MMCONFIG at
f0000000 - f3ffffff
Jan 26 22:22:17 rainbow kernel: [    0.170649] PCI: Using
configuration type 1 for base access
Jan 26 22:22:17 rainbow kernel: [    0.170728] bio: create slab <bio-0> at 0
Jan 26 22:22:17 rainbow kernel: [    0.173348] ACPI: EC: EC
description table is found, configuring boot EC
Jan 26 22:22:17 rainbow kernel: [    0.180529] ACPI: BIOS _OSI(Linux)
query honored via DMI
Jan 26 22:22:17 rainbow kernel: [    0.180025] ACPI: EC: non-query
interrupt received, switching to interrupt mode
Jan 26 22:22:17 rainbow kernel: [    0.192423] ACPI: Interpreter enabled
Jan 26 22:22:17 rainbow kernel: [    0.192473] ACPI: (supports S0 S3 S4 S5)
Jan 26 22:22:17 rainbow kernel: [    0.192719] ACPI: Using IOAPIC for
interrupt routing
Jan 26 22:22:17 rainbow kernel: [    0.212146] ACPI: EC: GPE = 0x12,
I/O: command/status = 0x66, data = 0x62
Jan 26 22:22:17 rainbow kernel: [    0.212213] ACPI: EC: driver
started in interrupt mode
Jan 26 22:22:17 rainbow kernel: [    0.212978] ACPI: ACPI Dock Station
Driver: 3 docks/bays found
Jan 26 22:22:17 rainbow kernel: [    0.213425] ACPI: PCI Root Bridge
[PCI0] (0000:00)
Jan 26 22:22:17 rainbow kernel: [    0.216071] pci 0000:00:02.0: reg
10 64bit mmio: [0xf8100000-0xf81fffff]
Jan 26 22:22:17 rainbow kernel: [    0.216141] pci 0000:00:02.0: reg
18 64bit mmio: [0xe0000000-0xefffffff]
Jan 26 22:22:17 rainbow kernel: [    0.216209] pci 0000:00:02.0: reg
20 io port: [0x1800-0x1807]
Jan 26 22:22:17 rainbow kernel: [    0.216313] pci 0000:00:02.1: reg
10 64bit mmio: [0xf8200000-0xf82fffff]
Jan 26 22:22:17 rainbow kernel: [    0.216549] pci 0000:00:19.0: reg
10 32bit mmio: [0xfe000000-0xfe01ffff]
Jan 26 22:22:17 rainbow kernel: [    0.216626] pci 0000:00:19.0: reg
14 32bit mmio: [0xfe025000-0xfe025fff]
Jan 26 22:22:17 rainbow kernel: [    0.216705] pci 0000:00:19.0: reg
18 io port: [0x1840-0x185f]
Jan 26 22:22:17 rainbow kernel: [    0.216869] pci 0000:00:19.0: PME#
supported from D0 D3hot D3cold
Jan 26 22:22:17 rainbow kernel: [    0.216945] pci 0000:00:19.0: PME# disabled
Jan 26 22:22:17 rainbow kernel: [    0.217114] pci 0000:00:1a.0: reg
20 io port: [0x1860-0x187f]
Jan 26 22:22:17 rainbow kernel: [    0.217313] pci 0000:00:1a.1: reg
20 io port: [0x1880-0x189f]
Jan 26 22:22:17 rainbow kernel: [    0.217512] pci 0000:00:1a.7: reg
10 32bit mmio: [0xfe226c00-0xfe226fff]
Jan 26 22:22:17 rainbow kernel: [    0.217682] pci 0000:00:1a.7: PME#
supported from D0 D3hot D3cold
Jan 26 22:22:17 rainbow kernel: [    0.217746] pci 0000:00:1a.7: PME# disabled
Jan 26 22:22:17 rainbow kernel: [    0.217746] pci 0000:00:1b.0: reg
10 64bit mmio: [0xfe020000-0xfe023fff]
Jan 26 22:22:17 rainbow kernel: [    0.217746] pci 0000:00:1b.0: PME#
supported from D0 D3hot D3cold
Jan 26 22:22:17 rainbow kernel: [    0.217746] pci 0000:00:1b.0: PME# disabled
Jan 26 22:22:17 rainbow kernel: [    0.217746] pci 0000:00:1c.0: PME#
supported from D0 D3hot D3cold
Jan 26 22:22:17 rainbow kernel: [    0.217746] pci 0000:00:1c.0: PME# disabled
Jan 26 22:22:17 rainbow kernel: [    0.217746] pci 0000:00:1c.1: PME#
supported from D0 D3hot D3cold
Jan 26 22:22:17 rainbow kernel: [    0.217746] pci 0000:00:1c.1: PME# disabled
Jan 26 22:22:17 rainbow kernel: [    0.217746] pci 0000:00:1c.2: PME#
supported from D0 D3hot D3cold
Jan 26 22:22:17 rainbow kernel: [    0.217746] pci 0000:00:1c.2: PME# disabled
Jan 26 22:22:17 rainbow kernel: [    0.217746] pci 0000:00:1c.3: PME#
supported from D0 D3hot D3cold
Jan 26 22:22:17 rainbow kernel: [    0.217746] pci 0000:00:1c.3: PME# disabled
Jan 26 22:22:17 rainbow kernel: [    0.217817] pci 0000:00:1c.4: PME#
supported from D0 D3hot D3cold
Jan 26 22:22:17 rainbow kernel: [    0.217895] pci 0000:00:1c.4: PME# disabled
Jan 26 22:22:17 rainbow kernel: [    0.218082] pci 0000:00:1d.0: reg
20 io port: [0x18a0-0x18bf]
Jan 26 22:22:17 rainbow kernel: [    0.218282] pci 0000:00:1d.1: reg
20 io port: [0x18c0-0x18df]
Jan 26 22:22:17 rainbow kernel: [    0.218486] pci 0000:00:1d.2: reg
20 io port: [0x18e0-0x18ff]
Jan 26 22:22:17 rainbow kernel: [    0.218681] pci 0000:00:1d.7: reg
10 32bit mmio: [0xfe227000-0xfe2273ff]
Jan 26 22:22:17 rainbow kernel: [    0.218863] pci 0000:00:1d.7: PME#
supported from D0 D3hot D3cold
Jan 26 22:22:17 rainbow kernel: [    0.218936] pci 0000:00:1d.7: PME# disabled
Jan 26 22:22:17 rainbow kernel: [    0.219280] pci 0000:00:1f.0:
quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
Jan 26 22:22:17 rainbow kernel: [    0.219362] pci 0000:00:1f.0:
quirk: region 1180-11bf claimed by ICH6 GPIO
Jan 26 22:22:17 rainbow kernel: [    0.219434] pci 0000:00:1f.0: ICH7
LPC Generic IO decode 1 PIO at 1600 (mask 007f)
Jan 26 22:22:17 rainbow kernel: [    0.219520] pci 0000:00:1f.0: ICH7
LPC Generic IO decode 2 PIO at 15e0 (mask 000f)
Jan 26 22:22:17 rainbow kernel: [    0.219600] pci 0000:00:1f.0: ICH7
LPC Generic IO decode 3 PIO at 1680 (mask 001f)
Jan 26 22:22:17 rainbow kernel: [    0.219772] pci 0000:00:1f.1: reg
10 io port: [0x00-0x07]
Jan 26 22:22:17 rainbow kernel: [    0.219853] pci 0000:00:1f.1: reg
14 io port: [0x00-0x03]
Jan 26 22:22:17 rainbow kernel: [    0.219925] pci 0000:00:1f.1: reg
18 io port: [0x00-0x07]
Jan 26 22:22:17 rainbow kernel: [    0.220023] pci 0000:00:1f.1: reg
1c io port: [0x00-0x03]
Jan 26 22:22:17 rainbow kernel: [    0.220099] pci 0000:00:1f.1: reg
20 io port: [0x1c00-0x1c0f]
Jan 26 22:22:17 rainbow kernel: [    0.220286] pci 0000:00:1f.2: reg
10 io port: [0x1c50-0x1c57]
Jan 26 22:22:17 rainbow kernel: [    0.220366] pci 0000:00:1f.2: reg
14 io port: [0x1c44-0x1c47]
Jan 26 22:22:17 rainbow kernel: [    0.220440] pci 0000:00:1f.2: reg
18 io port: [0x1c48-0x1c4f]
Jan 26 22:22:17 rainbow kernel: [    0.220522] pci 0000:00:1f.2: reg
1c io port: [0x1c40-0x1c43]
Jan 26 22:22:17 rainbow kernel: [    0.220601] pci 0000:00:1f.2: reg
20 io port: [0x1c20-0x1c3f]
Jan 26 22:22:17 rainbow kernel: [    0.220675] pci 0000:00:1f.2: reg
24 32bit mmio: [0xfe226000-0xfe2267ff]
Jan 26 22:22:17 rainbow kernel: [    0.220806] pci 0000:00:1f.2: PME#
supported from D3hot
Jan 26 22:22:17 rainbow kernel: [    0.220879] pci 0000:00:1f.2: PME# disabled
Jan 26 22:22:17 rainbow kernel: [    0.220987] pci 0000:00:1f.3: reg
10 32bit mmio: [0xfe227400-0xfe2274ff]
Jan 26 22:22:17 rainbow kernel: [    0.221091] pci 0000:00:1f.3: reg
20 io port: [0x1c60-0x1c7f]
Jan 26 22:22:17 rainbow kernel: [    0.221335] pci 0000:00:1c.0:
bridge io port: [0x2000-0x2fff]
Jan 26 22:22:17 rainbow kernel: [    0.221404] pci 0000:00:1c.0:
bridge 32bit mmio: [0xfc000000-0xfdffffff]
Jan 26 22:22:17 rainbow kernel: [    0.221480] pci 0000:00:1c.0:
bridge 64bit mmio pref: [0xf8000000-0xf80fffff]
Jan 26 22:22:17 rainbow kernel: [    0.221741] pci 0000:03:00.0: reg
10 32bit mmio: [0xdf3ff000-0xdf3fffff]
Jan 26 22:22:17 rainbow kernel: [    0.222038] pci 0000:03:00.0: PME#
supported from D0 D3hot D3cold
Jan 26 22:22:17 rainbow kernel: [    0.222100] pci 0000:03:00.0: PME# disabled
Jan 26 22:22:17 rainbow kernel: [    0.222252] pci 0000:00:1c.1:
bridge io port: [0x3000-0x3fff]
Jan 26 22:22:17 rainbow kernel: [    0.222317] pci 0000:00:1c.1:
bridge 32bit mmio: [0xdc000000-0xdf3fffff]
Jan 26 22:22:17 rainbow kernel: [    0.222394] pci 0000:00:1c.1:
bridge 64bit mmio pref: [0xdfe00000-0xdfefffff]
Jan 26 22:22:17 rainbow kernel: [    0.222557] pci 0000:00:1c.2:
bridge io port: [0x4000-0x4fff]
Jan 26 22:22:17 rainbow kernel: [    0.222636] pci 0000:00:1c.2:
bridge 32bit mmio: [0xd8000000-0xd9ffffff]
Jan 26 22:22:17 rainbow kernel: [    0.222715] pci 0000:00:1c.2:
bridge 64bit mmio pref: [0xdfb00000-0xdfbfffff]
Jan 26 22:22:17 rainbow kernel: [    0.222886] pci 0000:00:1c.3:
bridge io port: [0x5000-0x5fff]
Jan 26 22:22:17 rainbow kernel: [    0.222965] pci 0000:00:1c.3:
bridge 32bit mmio: [0xd4000000-0xd5ffffff]
Jan 26 22:22:17 rainbow kernel: [    0.223042] pci 0000:00:1c.3:
bridge 64bit mmio pref: [0xdf800000-0xdf8fffff]
Jan 26 22:22:17 rainbow kernel: [    0.223217] pci 0000:00:1c.4:
bridge io port: [0x6000-0x6fff]
Jan 26 22:22:17 rainbow kernel: [    0.223287] pci 0000:00:1c.4:
bridge 32bit mmio: [0xd0000000-0xd1ffffff]
Jan 26 22:22:17 rainbow kernel: [    0.223364] pci 0000:00:1c.4:
bridge 64bit mmio pref: [0xdf500000-0xdf5fffff]
Jan 26 22:22:17 rainbow kernel: [    0.223511] pci 0000:15:00.0: reg
10 32bit mmio: [0xf8300000-0xf8300fff]
Jan 26 22:22:17 rainbow kernel: [    0.223617] pci 0000:15:00.0: supports D1 D2
Jan 26 22:22:17 rainbow kernel: [    0.223681] pci 0000:15:00.0: PME#
supported from D0 D1 D2 D3hot D3cold
Jan 26 22:22:17 rainbow kernel: [    0.223756] pci 0000:15:00.0: PME# disabled
Jan 26 22:22:17 rainbow kernel: [    0.223902] pci 0000:15:00.1: reg
10 32bit mmio: [0xf8301000-0xf83017ff]
Jan 26 22:22:17 rainbow kernel: [    0.224123] pci 0000:15:00.1: supports D1 D2
Jan 26 22:22:17 rainbow kernel: [    0.224190] pci 0000:15:00.1: PME#
supported from D0 D1 D2 D3hot D3cold
Jan 26 22:22:17 rainbow kernel: [    0.224261] pci 0000:15:00.1: PME# disabled
Jan 26 22:22:17 rainbow kernel: [    0.224446] pci 0000:00:1e.0:
transparent bridge
Jan 26 22:22:17 rainbow kernel: [    0.224511] pci 0000:00:1e.0:
bridge io port: [0x7000-0xafff]
Jan 26 22:22:17 rainbow kernel: [    0.224580] pci 0000:00:1e.0:
bridge 32bit mmio: [0xf8300000-0xfbffffff]
Jan 26 22:22:17 rainbow kernel: [    0.224659] pci 0000:00:1e.0:
bridge 64bit mmio pref: [0xf4000000-0xf7ffffff]
Jan 26 22:22:17 rainbow kernel: [    0.224823] ACPI: PCI Interrupt
Routing Table [\_SB_.PCI0._PRT]
Jan 26 22:22:17 rainbow kernel: [    0.225042] ACPI: PCI Interrupt
Routing Table [\_SB_.PCI0.EXP0._PRT]
Jan 26 22:22:17 rainbow kernel: [    0.225191] ACPI: PCI Interrupt
Routing Table [\_SB_.PCI0.EXP1._PRT]
Jan 26 22:22:17 rainbow kernel: [    0.225335] ACPI: PCI Interrupt
Routing Table [\_SB_.PCI0.EXP2._PRT]
Jan 26 22:22:17 rainbow kernel: [    0.225479] ACPI: PCI Interrupt
Routing Table [\_SB_.PCI0.EXP3._PRT]
Jan 26 22:22:17 rainbow kernel: [    0.225624] ACPI: PCI Interrupt
Routing Table [\_SB_.PCI0.EXP4._PRT]
Jan 26 22:22:17 rainbow kernel: [    0.225773] ACPI: PCI Interrupt
Routing Table [\_SB_.PCI0.PCI1._PRT]
Jan 26 22:22:17 rainbow kernel: [    0.232226] ACPI: PCI Interrupt
Link [LNKA] (IRQs 3 4 5 6 7 9 *10 11)
Jan 26 22:22:17 rainbow kernel: [    0.232871] ACPI: PCI Interrupt
Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
Jan 26 22:22:17 rainbow kernel: [    0.233669] ACPI: PCI Interrupt
Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
Jan 26 22:22:17 rainbow kernel: [    0.234443] ACPI: PCI Interrupt
Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
Jan 26 22:22:17 rainbow kernel: [    0.235227] ACPI: PCI Interrupt
Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
Jan 26 22:22:17 rainbow kernel: [    0.236009] ACPI: PCI Interrupt
Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
Jan 26 22:22:17 rainbow kernel: [    0.236804] ACPI: PCI Interrupt
Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
Jan 26 22:22:17 rainbow kernel: [    0.237577] ACPI: PCI Interrupt
Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
Jan 26 22:22:17 rainbow kernel: [    0.240067] ACPI: Power Resource [PUBS] (on)
Jan 26 22:22:17 rainbow kernel: [    0.240198] PCI: Using ACPI for IRQ routing
Jan 26 22:22:17 rainbow kernel: [    0.252073] NET: Registered protocol family 8
Jan 26 22:22:17 rainbow kernel: [    0.252137] NET: Registered
protocol family 20
Jan 26 22:22:17 rainbow kernel: [    0.252208] NetLabel: Initializing
Jan 26 22:22:17 rainbow kernel: [    0.252208] NetLabel:  domain hash size = 128
Jan 26 22:22:17 rainbow kernel: [    0.252208] NetLabel:  protocols =
UNLABELED CIPSOv4
Jan 26 22:22:17 rainbow kernel: [    0.252217] NetLabel:  unlabeled
traffic allowed by default
Jan 26 22:22:17 rainbow kernel: [    0.252372] hpet0: at MMIO
0xfed00000, IRQs 2, 8, 0
Jan 26 22:22:17 rainbow kernel: [    0.252646] hpet0: 3 comparators,
64-bit 14.318180 MHz counter
Jan 26 22:22:17 rainbow kernel: [    0.260017] Switched to high
resolution mode on CPU 0
Jan 26 22:22:17 rainbow kernel: [    0.261725] Switched to high
resolution mode on CPU 1
Jan 26 22:22:17 rainbow kernel: [    0.276016] pnp: PnP ACPI init
Jan 26 22:22:17 rainbow kernel: [    0.276080] ACPI: bus type pnp registered
Jan 26 22:22:17 rainbow kernel: [    0.282012] pnp: PnP ACPI: found 11 devices
Jan 26 22:22:17 rainbow kernel: [    0.282068] ACPI: ACPI bus type pnp
unregistered
Jan 26 22:22:17 rainbow kernel: [    0.282734] system 00:00: iomem
range 0x0-0x9ffff could not be reserved
Jan 26 22:22:17 rainbow kernel: [    0.282804] system 00:00: iomem
range 0xc0000-0xc3fff has been reserved
Jan 26 22:22:17 rainbow kernel: [    0.282871] system 00:00: iomem
range 0xc4000-0xc7fff has been reserved
Jan 26 22:22:17 rainbow kernel: [    0.282940] system 00:00: iomem
range 0xc8000-0xcbfff has been reserved
Jan 26 22:22:17 rainbow kernel: [    0.283005] system 00:00: iomem
range 0xcc000-0xcffff has been reserved
Jan 26 22:22:17 rainbow kernel: [    0.283075] system 00:00: iomem
range 0xd0000-0xd3fff could not be reserved
Jan 26 22:22:17 rainbow kernel: [    0.283141] system 00:00: iomem
range 0xe0000-0xe3fff could not be reserved
Jan 26 22:22:17 rainbow kernel: [    0.283206] system 00:00: iomem
range 0xe4000-0xe7fff could not be reserved
Jan 26 22:22:17 rainbow kernel: [    0.283278] system 00:00: iomem
range 0xe8000-0xebfff could not be reserved
Jan 26 22:22:17 rainbow kernel: [    0.283347] system 00:00: iomem
range 0xec000-0xeffff could not be reserved
Jan 26 22:22:17 rainbow kernel: [    0.283415] system 00:00: iomem
range 0xf0000-0xfffff could not be reserved
Jan 26 22:22:17 rainbow kernel: [    0.283486] system 00:00: iomem
range 0x100000-0xbfffffff could not be reserved
Jan 26 22:22:17 rainbow kernel: [    0.283566] system 00:00: iomem
range 0xfec00000-0xfed3ffff could not be reserved
Jan 26 22:22:17 rainbow kernel: [    0.283645] system 00:00: iomem
range 0xfed4c000-0xffffffff could not be reserved
Jan 26 22:22:17 rainbow kernel: [    0.283726] system 00:02: ioport
range 0x164e-0x164f has been reserved
Jan 26 22:22:17 rainbow kernel: [    0.283792] system 00:02: ioport
range 0x1000-0x107f has been reserved
Jan 26 22:22:17 rainbow kernel: [    0.283861] system 00:02: ioport
range 0x1180-0x11bf has been reserved
Jan 26 22:22:17 rainbow kernel: [    0.283927] system 00:02: ioport
range 0x800-0x80f has been reserved
Jan 26 22:22:17 rainbow kernel: [    0.284000] system 00:02: ioport
range 0x15e0-0x15ef has been reserved
Jan 26 22:22:17 rainbow kernel: [    0.284069] system 00:02: ioport
range 0x1600-0x165f could not be reserved
Jan 26 22:22:17 rainbow kernel: [    0.284138] system 00:02: iomem
range 0xf0000000-0xf3ffffff has been reserved
Jan 26 22:22:17 rainbow kernel: [    0.284204] system 00:02: iomem
range 0xfed1c000-0xfed1ffff has been reserved
Jan 26 22:22:17 rainbow kernel: [    0.284270] system 00:02: iomem
range 0xfed14000-0xfed17fff has been reserved
Jan 26 22:22:17 rainbow kernel: [    0.284339] system 00:02: iomem
range 0xfed18000-0xfed18fff has been reserved
Jan 26 22:22:17 rainbow kernel: [    0.284409] system 00:02: iomem
range 0xfed19000-0xfed19fff has been reserved
Jan 26 22:22:17 rainbow kernel: [    0.284478] system 00:02: iomem
range 0xfed45000-0xfed4bfff has been reserved
Jan 26 22:22:17 rainbow kernel: [    0.289658] pci 0000:00:1c.0: PCI
bridge, secondary bus 0000:02
Jan 26 22:22:17 rainbow kernel: [    0.289726] pci 0000:00:1c.0:   IO
window: 0x2000-0x2fff
Jan 26 22:22:17 rainbow kernel: [    0.289801] pci 0000:00:1c.0:   MEM
window: 0xfc000000-0xfdffffff
Jan 26 22:22:17 rainbow kernel: [    0.289872] pci 0000:00:1c.0:
PREFETCH window: 0x000000f8000000-0x000000f80fffff
Jan 26 22:22:17 rainbow kernel: [    0.289957] pci 0000:00:1c.1: PCI
bridge, secondary bus 0000:03
Jan 26 22:22:17 rainbow kernel: [    0.290030] pci 0000:00:1c.1:   IO
window: 0x3000-0x3fff
Jan 26 22:22:17 rainbow kernel: [    0.290103] pci 0000:00:1c.1:   MEM
window: 0xdc000000-0xdf3fffff
Jan 26 22:22:17 rainbow kernel: [    0.290176] pci 0000:00:1c.1:
PREFETCH window: 0x000000dfe00000-0x000000dfefffff
Jan 26 22:22:17 rainbow kernel: [    0.290257] pci 0000:00:1c.2: PCI
bridge, secondary bus 0000:04
Jan 26 22:22:17 rainbow kernel: [    0.290332] pci 0000:00:1c.2:   IO
window: 0x4000-0x4fff
Jan 26 22:22:17 rainbow kernel: [    0.290401] pci 0000:00:1c.2:   MEM
window: 0xd8000000-0xd9ffffff
Jan 26 22:22:17 rainbow kernel: [    0.290475] pci 0000:00:1c.2:
PREFETCH window: 0x000000dfb00000-0x000000dfbfffff
Jan 26 22:22:17 rainbow kernel: [    0.290563] pci 0000:00:1c.3: PCI
bridge, secondary bus 0000:05
Jan 26 22:22:17 rainbow kernel: [    0.290637] pci 0000:00:1c.3:   IO
window: 0x5000-0x5fff
Jan 26 22:22:17 rainbow kernel: [    0.290716] pci 0000:00:1c.3:   MEM
window: 0xd4000000-0xd5ffffff
Jan 26 22:22:17 rainbow kernel: [    0.290790] pci 0000:00:1c.3:
PREFETCH window: 0x000000df800000-0x000000df8fffff
Jan 26 22:22:17 rainbow kernel: [    0.290881] pci 0000:00:1c.4: PCI
bridge, secondary bus 0000:0d
Jan 26 22:22:17 rainbow kernel: [    0.290948] pci 0000:00:1c.4:   IO
window: 0x6000-0x6fff
Jan 26 22:22:17 rainbow kernel: [    0.291023] pci 0000:00:1c.4:   MEM
window: 0xd0000000-0xd1ffffff
Jan 26 22:22:17 rainbow kernel: [    0.291096] pci 0000:00:1c.4:
PREFETCH window: 0x000000df500000-0x000000df5fffff
Jan 26 22:22:17 rainbow kernel: [    0.291188] pci 0000:15:00.0:
CardBus bridge, secondary bus 0000:16
Jan 26 22:22:17 rainbow kernel: [    0.291259] pci 0000:15:00.0:   IO
window: 0x007000-0x0070ff
Jan 26 22:22:17 rainbow kernel: [    0.291333] pci 0000:15:00.0:   IO
window: 0x007400-0x0074ff
Jan 26 22:22:17 rainbow kernel: [    0.291401] pci 0000:15:00.0:
PREFETCH window: 0xf4000000-0xf7ffffff
Jan 26 22:22:17 rainbow kernel: [    0.291475] pci 0000:15:00.0:   MEM
window: 0xc4000000-0xc7ffffff
Jan 26 22:22:17 rainbow kernel: [    0.291542] pci 0000:00:1e.0: PCI
bridge, secondary bus 0000:15
Jan 26 22:22:17 rainbow kernel: [    0.291611] pci 0000:00:1e.0:   IO
window: 0x7000-0xafff
Jan 26 22:22:17 rainbow kernel: [    0.291690] pci 0000:00:1e.0:   MEM
window: 0xf8300000-0xfbffffff
Jan 26 22:22:17 rainbow kernel: [    0.291759] pci 0000:00:1e.0:
PREFETCH window: 0x000000f4000000-0x000000f7ffffff
Jan 26 22:22:17 rainbow kernel: [    0.291858] pci 0000:00:1c.0: PCI
INT A -> GSI 20 (level, low) -> IRQ 20
Jan 26 22:22:17 rainbow kernel: [    0.291929] pci 0000:00:1c.0:
setting latency timer to 64
Jan 26 22:22:17 rainbow kernel: [    0.292009] pci 0000:00:1c.1: PCI
INT B -> GSI 21 (level, low) -> IRQ 21
Jan 26 22:22:17 rainbow kernel: [    0.292082] pci 0000:00:1c.1:
setting latency timer to 64
Jan 26 22:22:17 rainbow kernel: [    0.292166] pci 0000:00:1c.2: PCI
INT C -> GSI 22 (level, low) -> IRQ 22
Jan 26 22:22:17 rainbow kernel: [    0.292238] pci 0000:00:1c.2:
setting latency timer to 64
Jan 26 22:22:17 rainbow kernel: [    0.292317] pci 0000:00:1c.3: PCI
INT D -> GSI 23 (level, low) -> IRQ 23
Jan 26 22:22:17 rainbow kernel: [    0.292394] pci 0000:00:1c.3:
setting latency timer to 64
Jan 26 22:22:17 rainbow kernel: [    0.292470] pci 0000:00:1c.4: PCI
INT A -> GSI 20 (level, low) -> IRQ 20
Jan 26 22:22:17 rainbow kernel: [    0.292542] pci 0000:00:1c.4:
setting latency timer to 64
Jan 26 22:22:17 rainbow kernel: [    0.292614] pci 0000:00:1e.0:
enabling device (0005 -> 0007)
Jan 26 22:22:17 rainbow kernel: [    0.292692] pci 0000:00:1e.0:
setting latency timer to 64
Jan 26 22:22:17 rainbow kernel: [    0.292772] pci 0000:15:00.0: PCI
INT A -> GSI 16 (level, low) -> IRQ 16
Jan 26 22:22:17 rainbow kernel: [    0.292845] pci 0000:15:00.0:
setting latency timer to 64
Jan 26 22:22:17 rainbow kernel: [    0.292914] pci_bus 0000:00:
resource 0 io:  [0x00-0xffff]
Jan 26 22:22:17 rainbow kernel: [    0.292979] pci_bus 0000:00:
resource 1 mem: [0x000000-0xffffffffffffffff]
Jan 26 22:22:17 rainbow kernel: [    0.293065] pci_bus 0000:02:
resource 0 io:  [0x2000-0x2fff]
Jan 26 22:22:17 rainbow kernel: [    0.293131] pci_bus 0000:02:
resource 1 mem: [0xfc000000-0xfdffffff]
Jan 26 22:22:17 rainbow kernel: [    0.293197] pci_bus 0000:02:
resource 2 mem: [0xf8000000-0xf80fffff]
Jan 26 22:22:17 rainbow kernel: [    0.293263] pci_bus 0000:02:
resource 3 mem: [0x0-0x0]
Jan 26 22:22:17 rainbow kernel: [    0.293329] pci_bus 0000:03:
resource 0 io:  [0x3000-0x3fff]
Jan 26 22:22:17 rainbow kernel: [    0.293394] pci_bus 0000:03:
resource 1 mem: [0xdc000000-0xdf3fffff]
Jan 26 22:22:17 rainbow kernel: [    0.293463] pci_bus 0000:03:
resource 2 mem: [0xdfe00000-0xdfefffff]
Jan 26 22:22:17 rainbow kernel: [    0.293533] pci_bus 0000:03:
resource 3 mem: [0x0-0x0]
Jan 26 22:22:17 rainbow kernel: [    0.293599] pci_bus 0000:04:
resource 0 io:  [0x4000-0x4fff]
Jan 26 22:22:17 rainbow kernel: [    0.293664] pci_bus 0000:04:
resource 1 mem: [0xd8000000-0xd9ffffff]
Jan 26 22:22:17 rainbow kernel: [    0.293729] pci_bus 0000:04:
resource 2 mem: [0xdfb00000-0xdfbfffff]
Jan 26 22:22:17 rainbow kernel: [    0.293800] pci_bus 0000:04:
resource 3 mem: [0x0-0x0]
Jan 26 22:22:17 rainbow kernel: [    0.293868] pci_bus 0000:05:
resource 0 io:  [0x5000-0x5fff]
Jan 26 22:22:17 rainbow kernel: [    0.293935] pci_bus 0000:05:
resource 1 mem: [0xd4000000-0xd5ffffff]
Jan 26 22:22:17 rainbow kernel: [    0.294002] pci_bus 0000:05:
resource 2 mem: [0xdf800000-0xdf8fffff]
Jan 26 22:22:17 rainbow kernel: [    0.294070] pci_bus 0000:05:
resource 3 mem: [0x0-0x0]
Jan 26 22:22:17 rainbow kernel: [    0.294138] pci_bus 0000:0d:
resource 0 io:  [0x6000-0x6fff]
Jan 26 22:22:17 rainbow kernel: [    0.294206] pci_bus 0000:0d:
resource 1 mem: [0xd0000000-0xd1ffffff]
Jan 26 22:22:17 rainbow kernel: [    0.294268] pci_bus 0000:0d:
resource 2 mem: [0xdf500000-0xdf5fffff]
Jan 26 22:22:17 rainbow kernel: [    0.294338] pci_bus 0000:0d:
resource 3 mem: [0x0-0x0]
Jan 26 22:22:17 rainbow kernel: [    0.294405] pci_bus 0000:15:
resource 0 io:  [0x7000-0xafff]
Jan 26 22:22:17 rainbow kernel: [    0.294474] pci_bus 0000:15:
resource 1 mem: [0xf8300000-0xfbffffff]
Jan 26 22:22:17 rainbow kernel: [    0.294541] pci_bus 0000:15:
resource 2 mem: [0xf4000000-0xf7ffffff]
Jan 26 22:22:17 rainbow kernel: [    0.294607] pci_bus 0000:15:
resource 3 io:  [0x00-0xffff]
Jan 26 22:22:17 rainbow kernel: [    0.294675] pci_bus 0000:15:
resource 4 mem: [0x000000-0xffffffffffffffff]
Jan 26 22:22:17 rainbow kernel: [    0.294744] pci_bus 0000:16:
resource 0 io:  [0x7000-0x70ff]
Jan 26 22:22:17 rainbow kernel: [    0.294809] pci_bus 0000:16:
resource 1 io:  [0x7400-0x74ff]
Jan 26 22:22:17 rainbow kernel: [    0.294872] pci_bus 0000:16:
resource 2 mem: [0xf4000000-0xf7ffffff]
Jan 26 22:22:17 rainbow kernel: [    0.294936] pci_bus 0000:16:
resource 3 mem: [0xc4000000-0xc7ffffff]
Jan 26 22:22:17 rainbow kernel: [    0.295022] NET: Registered protocol family 2
Jan 26 22:22:17 rainbow kernel: [    0.341147] IP route cache hash
table entries: 131072 (order: 8, 1048576 bytes)
Jan 26 22:22:17 rainbow kernel: [    0.342349] TCP established hash
table entries: 524288 (order: 11, 8388608 bytes)
Jan 26 22:22:17 rainbow kernel: [    0.347015] TCP bind hash table
entries: 65536 (order: 8, 1048576 bytes)
Jan 26 22:22:17 rainbow kernel: [    0.347750] TCP: Hash tables
configured (established 524288 bind 65536)
Jan 26 22:22:17 rainbow kernel: [    0.347821] TCP reno registered
Jan 26 22:22:17 rainbow kernel: [    0.357113] NET: Registered protocol family 1
Jan 26 22:22:17 rainbow kernel: [    0.357293] checking if image is
initramfs... it is
Jan 26 22:22:17 rainbow kernel: [    2.402876] Freeing initrd memory:
22626k freed
Jan 26 22:22:17 rainbow kernel: [    2.416667] Simple Boot Flag at
0x35 set to 0x1
Jan 26 22:22:17 rainbow kernel: [    2.417862] audit: initializing
netlink socket (disabled)
Jan 26 22:22:17 rainbow kernel: [    2.417936] type=2000
audit(1233026514.417:1): initialized
Jan 26 22:22:17 rainbow kernel: [    2.423905] HugeTLB registered 2 MB
page size, pre-allocated 0 pages
Jan 26 22:22:17 rainbow kernel: [    2.426564] VFS: Disk quotas dquot_6.5.2
Jan 26 22:22:17 rainbow kernel: [    2.426711] Dquot-cache hash table
entries: 512 (order 0, 4096 bytes)
Jan 26 22:22:17 rainbow kernel: [    2.426942] msgmni has been set to 7709
Jan 26 22:22:17 rainbow kernel: [    2.427203] alg: No test for stdrng (krng)
Jan 26 22:22:17 rainbow kernel: [    2.427278] io scheduler noop registered
Jan 26 22:22:17 rainbow kernel: [    2.427342] io scheduler
anticipatory registered
Jan 26 22:22:17 rainbow kernel: [    2.427407] io scheduler deadline registered
Jan 26 22:22:17 rainbow kernel: [    2.427592] io scheduler cfq
registered (default)
Jan 26 22:22:17 rainbow kernel: [    2.427666] pci 0000:00:02.0: Boot
video device
Jan 26 22:22:17 rainbow kernel: [    2.428065] pcieport-driver
0000:00:1c.0: setting latency timer to 64
Jan 26 22:22:17 rainbow kernel: [    2.428268] pcieport-driver
0000:00:1c.0: irq 24 for MSI/MSI-X
Jan 26 22:22:17 rainbow kernel: [    2.428639] pcieport-driver
0000:00:1c.1: setting latency timer to 64
Jan 26 22:22:17 rainbow kernel: [    2.428859] pcieport-driver
0000:00:1c.1: irq 25 for MSI/MSI-X
Jan 26 22:22:17 rainbow kernel: [    2.429314] pcieport-driver
0000:00:1c.2: setting latency timer to 64
Jan 26 22:22:17 rainbow kernel: [    2.429504] pcieport-driver
0000:00:1c.2: irq 26 for MSI/MSI-X
Jan 26 22:22:17 rainbow kernel: [    2.429862] pcieport-driver
0000:00:1c.3: setting latency timer to 64
Jan 26 22:22:17 rainbow kernel: [    2.430068] pcieport-driver
0000:00:1c.3: irq 27 for MSI/MSI-X
Jan 26 22:22:17 rainbow kernel: [    2.430435] pcieport-driver
0000:00:1c.4: setting latency timer to 64
Jan 26 22:22:17 rainbow kernel: [    2.430630] pcieport-driver
0000:00:1c.4: irq 28 for MSI/MSI-X
Jan 26 22:22:17 rainbow kernel: [    2.463538] Linux agpgart interface v0.103
Jan 26 22:22:17 rainbow kernel: [    2.463611] Serial: 8250/16550
driver, 4 ports, IRQ sharing enabled
Jan 26 22:22:17 rainbow kernel: [    2.466198] brd: module loaded
Jan 26 22:22:17 rainbow kernel: [    2.466261] e1000e: Intel(R)
PRO/1000 Network Driver - 0.3.3.3-k6
Jan 26 22:22:17 rainbow kernel: [    2.466328] e1000e: Copyright (c)
1999-2008 Intel Corporation.
Jan 26 22:22:17 rainbow kernel: [    2.466452] e1000e 0000:00:19.0:
PCI INT A -> GSI 20 (level, low) -> IRQ 20
Jan 26 22:22:17 rainbow kernel: [    2.466530] e1000e 0000:00:19.0:
setting latency timer to 64
Jan 26 22:22:17 rainbow kernel: [    2.466767] e1000e 0000:00:19.0:
irq 29 for MSI/MSI-X
Jan 26 22:22:17 rainbow kernel: [    2.674484] 0000:00:19.0: eth0:
(PCI Express:2.5GB/s:Width x1) 00:1c:25:7e:69:03
Jan 26 22:22:17 rainbow kernel: [    2.674561] 0000:00:19.0: eth0:
Intel(R) PRO/1000 Network Connection
Jan 26 22:22:17 rainbow kernel: [    2.674673] 0000:00:19.0: eth0:
MAC: 5, PHY: 6, PBA No: 1008ff-0ff
Jan 26 22:22:17 rainbow kernel: [    2.674807] netconsole: local port 6665
Jan 26 22:22:17 rainbow kernel: [    2.674872] netconsole: local IP 169.254.1.1
Jan 26 22:22:17 rainbow kernel: [    2.674935] netconsole: interface eth0
Jan 26 22:22:17 rainbow kernel: [    2.675002] netconsole: remote port 6666
Jan 26 22:22:17 rainbow kernel: [    2.675064] netconsole: remote IP
169.254.242.220
Jan 26 22:22:17 rainbow kernel: [    2.675132] netconsole: remote
ethernet address ff:ff:ff:ff:ff:ff
Jan 26 22:22:17 rainbow kernel: [    2.675197] netconsole: device eth0
not up yet, forcing it
Jan 26 22:22:17 rainbow kernel: [    2.808251] e1000e 0000:00:19.0:
irq 29 for MSI/MSI-X
Jan 26 22:22:17 rainbow kernel: [    2.864112] e1000e 0000:00:19.0:
irq 29 for MSI/MSI-X
Jan 26 22:22:17 rainbow kernel: [    6.869008] netconsole: timeout
waiting for carrier
Jan 26 22:22:17 rainbow kernel: [    6.869993] e1000e: eth0 NIC Link
is Up 100 Mbps Half Duplex, Flow Control: None
Jan 26 22:22:17 rainbow kernel: [    6.870131] 0000:00:19.0: eth0:
10/100 speed: disabling TSO
Jan 26 22:22:17 rainbow kernel: [    6.881039] console [netcon0] enabled
Jan 26 22:22:17 rainbow kernel: [    6.916029] netconsole: network
logging started
Jan 26 22:22:17 rainbow kernel: [    6.916236] PNP: PS/2 Controller
[PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
Jan 26 22:22:17 rainbow kernel: [    6.925426] serio: i8042 KBD port
at 0x60,0x64 irq 1
Jan 26 22:22:17 rainbow kernel: [    6.925495] serio: i8042 AUX port
at 0x60,0x64 irq 12
Jan 26 22:22:17 rainbow kernel: [    6.925752] mice: PS/2 mouse device
common for all mice
Jan 26 22:22:17 rainbow kernel: [    6.925899] rtc_cmos 00:07: RTC can
wake from S4
Jan 26 22:22:17 rainbow kernel: [    6.926045] rtc_cmos 00:07: rtc
core: registered rtc_cmos as rtc0
Jan 26 22:22:17 rainbow kernel: [    6.926152] rtc0: alarms up to one
month, y3k, 114 bytes nvram, hpet irqs
Jan 26 22:22:17 rainbow kernel: [    6.926262] cpuidle: using governor ladder
Jan 26 22:22:17 rainbow kernel: [    6.926324] cpuidle: using governor menu
Jan 26 22:22:17 rainbow kernel: [    6.926672] TCP cubic registered
Jan 26 22:22:17 rainbow kernel: [    6.926991] registered taskstats version 1
Jan 26 22:22:17 rainbow kernel: [    6.927188]   Magic number: 9:136:362
Jan 26 22:22:17 rainbow kernel: [    6.927383] rtc_cmos 00:07: setting
system clock to 2009-01-27 03:22:00 UTC (1233026520)
Jan 26 22:22:17 rainbow kernel: [    6.927462] BIOS EDD facility v0.16
2004-Jun-25, 0 devices found
Jan 26 22:22:17 rainbow kernel: [    6.927528] EDD information not available.
Jan 26 22:22:17 rainbow kernel: [    6.927635] Freeing unused kernel
memory: 552k freed
Jan 26 22:22:17 rainbow kernel: [    6.927903] Write protecting the
kernel read-only data: 4544k
Jan 26 22:22:17 rainbow kernel: [    6.930940] input: AT Translated
Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
Jan 26 22:22:17 rainbow kernel: [    7.032985] fuse init (API version 7.11)
Jan 26 22:22:17 rainbow kernel: [    7.043515] ACPI: SSDT BF6E1B32,
02C4 (r1  PmRef  Cpu0Ist      100 INTL 20050513)
Jan 26 22:22:17 rainbow kernel: [    7.044329] ACPI: SSDT BF6E1E7B,
085E (r1  PmRef  Cpu0Cst      100 INTL 20050513)
Jan 26 22:22:17 rainbow kernel: [    7.047851] Monitor-Mwait will be
used to enter C-1 state
Jan 26 22:22:17 rainbow kernel: [    7.047929] Monitor-Mwait will be
used to enter C-2 state
Jan 26 22:22:17 rainbow kernel: [    7.047996] Monitor-Mwait will be
used to enter C-3 state
Jan 26 22:22:17 rainbow kernel: [    7.048291] ACPI: CPU0 (power
states: C1[C1] C2[C2] C3[C3])
Jan 26 22:22:17 rainbow kernel: [    7.048618] processor ACPI_CPU:00:
registered as cooling_device0
Jan 26 22:22:17 rainbow kernel: [    7.048685] ACPI: Processor [CPU0]
(supports 8 throttling states)
Jan 26 22:22:17 rainbow kernel: [    7.049200] ACPI: SSDT BF6E1A6A,
00C8 (r1  PmRef  Cpu1Ist      100 INTL 20050513)
Jan 26 22:22:17 rainbow kernel: [    7.049817] ACPI: SSDT BF6E1DF6,
0085 (r1  PmRef  Cpu1Cst      100 INTL 20050513)
Jan 26 22:22:17 rainbow kernel: [    7.052669] ACPI: CPU1 (power
states: C1[C1] C2[C2] C3[C3])
Jan 26 22:22:17 rainbow kernel: [    7.052992] processor ACPI_CPU:01:
registered as cooling_device1
Jan 26 22:22:17 rainbow kernel: [    7.053100] ACPI: Processor [CPU1]
(supports 8 throttling states)
Jan 26 22:22:17 rainbow kernel: [    7.056905] thermal LNXTHERM:01:
registered as thermal_zone0
Jan 26 22:22:17 rainbow kernel: [    7.060043] ACPI: Thermal Zone [THM0] (54 C)
Jan 26 22:22:17 rainbow kernel: [    7.061265] thermal LNXTHERM:02:
registered as thermal_zone1
Jan 26 22:22:17 rainbow kernel: [    7.062666] ACPI: Thermal Zone [THM1] (53 C)
Jan 26 22:22:17 rainbow kernel: [    7.226242] usbcore: registered new
interface driver usbfs
Jan 26 22:22:17 rainbow kernel: [    7.226354] usbcore: registered new
interface driver hub
Jan 26 22:22:17 rainbow kernel: [    7.228975] usbcore: registered new
device driver usb
Jan 26 22:22:17 rainbow kernel: [    7.231174] uhci_hcd: USB Universal
Host Controller Interface driver
Jan 26 22:22:17 rainbow kernel: [    7.231323] uhci_hcd 0000:00:1a.0:
PCI INT A -> GSI 20 (level, low) -> IRQ 20
Jan 26 22:22:17 rainbow kernel: [    7.231408] uhci_hcd 0000:00:1a.0:
setting latency timer to 64
Jan 26 22:22:17 rainbow kernel: [    7.231489] uhci_hcd 0000:00:1a.0:
UHCI Host Controller
Jan 26 22:22:17 rainbow kernel: [    7.231612] uhci_hcd 0000:00:1a.0:
new USB bus registered, assigned bus number 1
Jan 26 22:22:17 rainbow kernel: [    7.231773] uhci_hcd 0000:00:1a.0:
irq 20, io base 0x00001860
Jan 26 22:22:17 rainbow kernel: [    7.232095] usb usb1: configuration
#1 chosen from 1 choice
Jan 26 22:22:17 rainbow kernel: [    7.232204] hub 1-0:1.0: USB hub found
Jan 26 22:22:17 rainbow kernel: [    7.232273] hub 1-0:1.0: 2 ports detected
Jan 26 22:22:17 rainbow kernel: [    7.233912] ehci_hcd: USB 2.0
'Enhanced' Host Controller (EHCI) Driver
Jan 26 22:22:17 rainbow kernel: [    7.233995] Warning! ehci_hcd
should always be loaded before uhci_hcd and ohci_hcd, not after
Jan 26 22:22:17 rainbow kernel: [    7.234497] uhci_hcd 0000:00:1a.1:
power state changed by ACPI to D0
Jan 26 22:22:17 rainbow kernel: [    7.234566] uhci_hcd 0000:00:1a.1:
PCI INT B -> GSI 21 (level, low) -> IRQ 21
Jan 26 22:22:17 rainbow kernel: [    7.234641] uhci_hcd 0000:00:1a.1:
setting latency timer to 64
Jan 26 22:22:17 rainbow kernel: [    7.234716] uhci_hcd 0000:00:1a.1:
UHCI Host Controller
Jan 26 22:22:17 rainbow kernel: [    7.234806] uhci_hcd 0000:00:1a.1:
new USB bus registered, assigned bus number 2
Jan 26 22:22:17 rainbow kernel: [    7.234941] uhci_hcd 0000:00:1a.1:
irq 21, io base 0x00001880
Jan 26 22:22:17 rainbow kernel: [    7.235106] usb usb2: configuration
#1 chosen from 1 choice
Jan 26 22:22:17 rainbow kernel: [    7.235203] hub 2-0:1.0: USB hub found
Jan 26 22:22:17 rainbow kernel: [    7.235269] hub 2-0:1.0: 2 ports detected
Jan 26 22:22:17 rainbow kernel: [    7.235877] ehci_hcd 0000:00:1a.7:
power state changed by ACPI to D0
Jan 26 22:22:17 rainbow kernel: [    7.235948] ehci_hcd 0000:00:1a.7:
PCI INT C -> GSI 22 (level, low) -> IRQ 22
Jan 26 22:22:17 rainbow kernel: [    7.236123] ehci_hcd 0000:00:1a.7:
setting latency timer to 64
Jan 26 22:22:17 rainbow kernel: [    7.236208] ehci_hcd 0000:00:1a.7:
EHCI Host Controller
Jan 26 22:22:17 rainbow kernel: [    7.236298] ehci_hcd 0000:00:1a.7:
new USB bus registered, assigned bus number 3
Jan 26 22:22:17 rainbow kernel: [    7.240294] ehci_hcd 0000:00:1a.7:
cache line size of 32 is not supported
Jan 26 22:22:17 rainbow kernel: [    7.240375] ehci_hcd 0000:00:1a.7:
irq 22, io mem 0xfe226c00
Jan 26 22:22:17 rainbow kernel: [    7.256148] ehci_hcd 0000:00:1a.7:
USB 2.0 started, EHCI 1.00
Jan 26 22:22:17 rainbow kernel: [    7.256323] usb usb3: configuration
#1 chosen from 1 choice
Jan 26 22:22:17 rainbow kernel: [    7.256416] hub 3-0:1.0: USB hub found
Jan 26 22:22:17 rainbow kernel: [    7.256484] hub 3-0:1.0: 4 ports detected
Jan 26 22:22:17 rainbow kernel: [    7.257207] uhci_hcd 0000:00:1d.0:
power state changed by ACPI to D0
Jan 26 22:22:17 rainbow kernel: [    7.257277] uhci_hcd 0000:00:1d.0:
PCI INT A -> GSI 16 (level, low) -> IRQ 16
Jan 26 22:22:17 rainbow kernel: [    7.257355] uhci_hcd 0000:00:1d.0:
setting latency timer to 64
Jan 26 22:22:17 rainbow kernel: [    7.257429] uhci_hcd 0000:00:1d.0:
UHCI Host Controller
Jan 26 22:22:17 rainbow kernel: [    7.257527] uhci_hcd 0000:00:1d.0:
new USB bus registered, assigned bus number 4
Jan 26 22:22:17 rainbow kernel: [    7.257648] uhci_hcd 0000:00:1d.0:
irq 16, io base 0x000018a0
Jan 26 22:22:17 rainbow kernel: [    7.257801] usb usb4: configuration
#1 chosen from 1 choice
Jan 26 22:22:17 rainbow kernel: [    7.257897] hub 4-0:1.0: USB hub found
Jan 26 22:22:17 rainbow kernel: [    7.257965] hub 4-0:1.0: 2 ports detected
Jan 26 22:22:17 rainbow kernel: [    7.258776] ehci_hcd 0000:00:1d.7:
power state changed by ACPI to D0
Jan 26 22:22:17 rainbow kernel: [    7.258850] ehci_hcd 0000:00:1d.7:
PCI INT D -> GSI 19 (level, low) -> IRQ 19
Jan 26 22:22:17 rainbow kernel: [    7.258936] ehci_hcd 0000:00:1d.7:
setting latency timer to 64
Jan 26 22:22:17 rainbow kernel: [    7.259005] ehci_hcd 0000:00:1d.7:
EHCI Host Controller
Jan 26 22:22:17 rainbow kernel: [    7.259093] ehci_hcd 0000:00:1d.7:
new USB bus registered, assigned bus number 5
Jan 26 22:22:17 rainbow kernel: [    7.263088] ehci_hcd 0000:00:1d.7:
debug port 1
Jan 26 22:22:17 rainbow kernel: [    7.263157] ehci_hcd 0000:00:1d.7:
cache line size of 32 is not supported
Jan 26 22:22:17 rainbow kernel: [    7.263233] ehci_hcd 0000:00:1d.7:
irq 19, io mem 0xfe227000
Jan 26 22:22:17 rainbow kernel: [    7.276030] ehci_hcd 0000:00:1d.7:
USB 2.0 started, EHCI 1.00
Jan 26 22:22:17 rainbow kernel: [    7.276214] usb usb5: configuration
#1 chosen from 1 choice
Jan 26 22:22:17 rainbow kernel: [    7.276305] hub 5-0:1.0: USB hub found
Jan 26 22:22:17 rainbow kernel: [    7.276377] hub 5-0:1.0: 6 ports detected
Jan 26 22:22:17 rainbow kernel: [    7.276857] uhci_hcd 0000:00:1d.1:
PCI INT B -> GSI 17 (level, low) -> IRQ 17
Jan 26 22:22:17 rainbow kernel: [    7.276936] uhci_hcd 0000:00:1d.1:
setting latency timer to 64
Jan 26 22:22:17 rainbow kernel: [    7.277008] uhci_hcd 0000:00:1d.1:
UHCI Host Controller
Jan 26 22:22:17 rainbow kernel: [    7.277098] uhci_hcd 0000:00:1d.1:
new USB bus registered, assigned bus number 6
Jan 26 22:22:17 rainbow kernel: [    7.277223] uhci_hcd 0000:00:1d.1:
irq 17, io base 0x000018c0
Jan 26 22:22:17 rainbow kernel: [    7.277373] usb usb6: configuration
#1 chosen from 1 choice
Jan 26 22:22:17 rainbow kernel: [    7.277471] hub 6-0:1.0: USB hub found
Jan 26 22:22:17 rainbow kernel: [    7.277538] hub 6-0:1.0: 2 ports detected
Jan 26 22:22:17 rainbow kernel: [    7.278185] uhci_hcd 0000:00:1d.2:
power state changed by ACPI to D0
Jan 26 22:22:17 rainbow kernel: [    7.278256] uhci_hcd 0000:00:1d.2:
PCI INT C -> GSI 18 (level, low) -> IRQ 18
Jan 26 22:22:17 rainbow kernel: [    7.278331] uhci_hcd 0000:00:1d.2:
setting latency timer to 64
Jan 26 22:22:17 rainbow kernel: [    7.278404] uhci_hcd 0000:00:1d.2:
UHCI Host Controller
Jan 26 22:22:17 rainbow kernel: [    7.278512] uhci_hcd 0000:00:1d.2:
new USB bus registered, assigned bus number 7
Jan 26 22:22:17 rainbow kernel: [    7.278627] uhci_hcd 0000:00:1d.2:
irq 18, io base 0x000018e0
Jan 26 22:22:17 rainbow kernel: [    7.278778] usb usb7: configuration
#1 chosen from 1 choice
Jan 26 22:22:17 rainbow kernel: [    7.278873] hub 7-0:1.0: USB hub found
Jan 26 22:22:17 rainbow kernel: [    7.278943] hub 7-0:1.0: 2 ports detected
Jan 26 22:22:17 rainbow kernel: [    7.308841] SCSI subsystem initialized
Jan 26 22:22:17 rainbow kernel: [    7.333257] libata version 3.00 loaded.
Jan 26 22:22:17 rainbow kernel: [    7.335745] ohci1394 0000:15:00.1:
PCI INT B -> GSI 17 (level, low) -> IRQ 17
Jan 26 22:22:17 rainbow kernel: [    7.335832] ohci1394 0000:15:00.1:
setting latency timer to 64
Jan 26 22:22:17 rainbow kernel: [    7.394163] ohci1394: fw-host0:
OHCI-1394 1.1 (PCI): IRQ=[17]  MMIO=[f8301000-f83017ff]  Max
Packet=[2048]  IR/IT contexts=[4/4]
Jan 26 22:22:17 rainbow kernel: [    7.398540] pata_acpi 0000:00:1f.1:
PCI INT C -> GSI 16 (level, low) -> IRQ 16
Jan 26 22:22:17 rainbow kernel: [    7.398666] pata_acpi 0000:00:1f.1:
setting latency timer to 64
Jan 26 22:22:17 rainbow kernel: [    7.398741] pata_acpi 0000:00:1f.1:
PCI INT C disabled
Jan 26 22:22:17 rainbow kernel: [    7.399179] ahci 0000:00:1f.2: version 3.0
Jan 26 22:22:17 rainbow kernel: [    7.399284] ahci 0000:00:1f.2: PCI
INT B -> GSI 16 (level, low) -> IRQ 16
Jan 26 22:22:17 rainbow kernel: [    7.399451] ahci 0000:00:1f.2: irq
30 for MSI/MSI-X
Jan 26 22:22:17 rainbow kernel: [    7.399580] ahci 0000:00:1f.2: AHCI
0001.0100 32 slots 3 ports 1.5 Gbps 0x1 impl SATA mode
Jan 26 22:22:17 rainbow kernel: [    7.399651] ahci 0000:00:1f.2:
flags: 64bit ncq sntf pm led clo pio slum part
Jan 26 22:22:17 rainbow kernel: [    7.399720] ahci 0000:00:1f.2:
setting latency timer to 64
Jan 26 22:22:17 rainbow kernel: [    7.400747] scsi0 : ahci
Jan 26 22:22:17 rainbow kernel: [    7.400934] scsi1 : ahci
Jan 26 22:22:17 rainbow kernel: [    7.401084] scsi2 : ahci
Jan 26 22:22:17 rainbow kernel: [    7.401217] ata1: SATA max UDMA/133
abar m2048@0xfe226000 port 0xfe226100 irq 30
Jan 26 22:22:17 rainbow kernel: [    7.401283] ata2: DUMMY
Jan 26 22:22:17 rainbow kernel: [    7.401339] ata3: DUMMY
Jan 26 22:22:17 rainbow kernel: [    7.721042] ata1: SATA link up 1.5
Gbps (SStatus 113 SControl 300)
Jan 26 22:22:17 rainbow kernel: [    7.721807] ata1.00: ACPI cmd
ef/02:00:00:00:00:a0 succeeded
Jan 26 22:22:17 rainbow kernel: [    7.721863] ata1.00: ACPI cmd
f5/00:00:00:00:00:a0 filtered out
Jan 26 22:22:17 rainbow kernel: [    7.721997] ata1.00: ACPI cmd
ef/5f:00:00:00:00:a0 succeeded
Jan 26 22:22:17 rainbow kernel: [    7.722065] ata1.00: ACPI cmd
ef/10:03:00:00:00:a0 filtered out
Jan 26 22:22:17 rainbow kernel: [    7.775972] ata1.00: ATA-8: WDC
WD1200BEVS-08UST0, 02.01A02, max UDMA/133
Jan 26 22:22:17 rainbow kernel: [    7.776042] ata1.00: 234441648
sectors, multi 16: LBA48 NCQ (depth 31/32)
Jan 26 22:22:17 rainbow kernel: [    7.777229] ata1.00: ACPI cmd
ef/02:00:00:00:00:a0 succeeded
Jan 26 22:22:17 rainbow kernel: [    7.777308] ata1.00: ACPI cmd
f5/00:00:00:00:00:a0 filtered out
Jan 26 22:22:17 rainbow kernel: [    7.777479] ata1.00: ACPI cmd
ef/5f:00:00:00:00:a0 succeeded
Jan 26 22:22:17 rainbow kernel: [    7.777554] ata1.00: ACPI cmd
ef/10:03:00:00:00:a0 filtered out
Jan 26 22:22:17 rainbow kernel: [    7.778365] ata1.00: configured for UDMA/133
Jan 26 22:22:17 rainbow kernel: [    7.794804] ata1.00: configured for UDMA/133
Jan 26 22:22:17 rainbow kernel: [    7.794865] ata1: EH complete
Jan 26 22:22:17 rainbow kernel: [    7.795050] scsi 0:0:0:0:
Direct-Access     ATA      WDC WD1200BEVS-0 02.0 PQ: 0 ANSI: 5
Jan 26 22:22:17 rainbow kernel: [    7.798687] ata_piix 0000:00:1f.1:
version 2.12
Jan 26 22:22:17 rainbow kernel: [    7.798783] ata_piix 0000:00:1f.1:
PCI INT C -> GSI 16 (level, low) -> IRQ 16
Jan 26 22:22:17 rainbow kernel: [    7.798916] ata_piix 0000:00:1f.1:
setting latency timer to 64
Jan 26 22:22:17 rainbow kernel: [    7.800225] scsi3 : ata_piix
Jan 26 22:22:17 rainbow kernel: [    7.802742] scsi 0:0:0:0: Attached
scsi generic sg0 type 0
Jan 26 22:22:17 rainbow kernel: [    7.803463] scsi4 : ata_piix
Jan 26 22:22:17 rainbow kernel: [    7.804406] ata4: PATA max UDMA/100
cmd 0x1f0 ctl 0x3f6 bmdma 0x1c00 irq 14
Jan 26 22:22:17 rainbow kernel: [    7.804464] ata5: PATA max UDMA/100
cmd 0x170 ctl 0x376 bmdma 0x1c08 irq 15
Jan 26 22:22:17 rainbow kernel: [    7.814356] Driver 'sd' needs
updating - please use bus_type methods
Jan 26 22:22:17 rainbow kernel: [    7.814519] sd 0:0:0:0: [sda]
234441648 512-byte hardware sectors: (120 GB/111 GiB)
Jan 26 22:22:17 rainbow kernel: [    7.814609] sd 0:0:0:0: [sda] Write
Protect is off
Jan 26 22:22:17 rainbow kernel: [    7.814675] sd 0:0:0:0: [sda] Mode
Sense: 00 3a 00 00
Jan 26 22:22:17 rainbow kernel: [    7.814747] sd 0:0:0:0: [sda] Write
cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jan 26 22:22:17 rainbow kernel: [    7.815536] sd 0:0:0:0: [sda]
234441648 512-byte hardware sectors: (120 GB/111 GiB)
Jan 26 22:22:17 rainbow kernel: [    7.815625] sd 0:0:0:0: [sda] Write
Protect is off
Jan 26 22:22:17 rainbow kernel: [    7.815690] sd 0:0:0:0: [sda] Mode
Sense: 00 3a 00 00
Jan 26 22:22:17 rainbow kernel: [    7.815760] sd 0:0:0:0: [sda] Write
cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jan 26 22:22:17 rainbow kernel: [    7.815837]  sda: sda1 sda2 < sda5 >
Jan 26 22:22:17 rainbow kernel: [    7.855351] sd 0:0:0:0: [sda]
Attached SCSI disk
Jan 26 22:22:17 rainbow kernel: [    7.905066] usb 5-2: new high speed
USB device using ehci_hcd and address 2
Jan 26 22:22:17 rainbow kernel: [    7.969687] ata4.00: ATAPI:
MATSHITADVD-RAM UJ-862, RB01, max UDMA/33
Jan 26 22:22:17 rainbow kernel: [    7.985331] ata4.00: configured for UDMA/33
Jan 26 22:22:17 rainbow kernel: [    7.988113] scsi 3:0:0:0: CD-ROM
        MATSHITA DVD-RAM UJ-862   RB01 PQ: 0 ANSI: 5
Jan 26 22:22:17 rainbow kernel: [    7.988329] scsi 3:0:0:0: Attached
scsi generic sg1 type 5
Jan 26 22:22:17 rainbow kernel: [    7.988470] ata5: port disabled. ignoring.
Jan 26 22:22:17 rainbow kernel: [    8.001028] Clocksource tsc
unstable (delta = -89171406 ns)
Jan 26 22:22:17 rainbow kernel: [    8.003156] Driver 'sr' needs
updating - please use bus_type methods
Jan 26 22:22:17 rainbow kernel: [    8.008467] sr0: scsi3-mmc drive:
24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Jan 26 22:22:17 rainbow kernel: [    8.008541] Uniform CD-ROM driver
Revision: 3.20
Jan 26 22:22:17 rainbow kernel: [    8.008688] sr 3:0:0:0: Attached
scsi CD-ROM sr0
Jan 26 22:22:17 rainbow kernel: [    8.037512] usb 5-2: configuration
#1 chosen from 1 choice
Jan 26 22:22:17 rainbow kernel: [    8.073305] PM: Starting manual
resume from disk
Jan 26 22:22:17 rainbow kernel: [    8.073364] PM: Resume from partition 8:5
Jan 26 22:22:17 rainbow kernel: [    8.073409] PM: Checking hibernation image.
Jan 26 22:22:17 rainbow kernel: [    8.073666] PM: Resume from disk failed.
Jan 26 22:22:17 rainbow kernel: [    8.136601] kjournald starting.
Commit interval 5 seconds
Jan 26 22:22:17 rainbow kernel: [    8.136633] EXT3-fs: mounted
filesystem with ordered data mode.
Jan 26 22:22:17 rainbow kernel: [    8.669200] ieee1394: Host added:
ID:BUS[0-00:1023]  GUID[00016c00005ec9db]
Jan 26 22:22:17 rainbow kernel: [   14.870483] udevd version 124 started
Jan 26 22:22:17 rainbow kernel: [   15.137171] input: Power Button
(FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
Jan 26 22:22:17 rainbow kernel: [   15.156042] ACPI: Power Button (FF) [PWRF]
Jan 26 22:22:17 rainbow kernel: [   15.156230] input: Lid Switch as
/devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input2
Jan 26 22:22:17 rainbow kernel: [   15.156733] ACPI: Lid Switch [LID]
Jan 26 22:22:17 rainbow kernel: [   15.156857] input: Sleep Button
(CM) as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input3
Jan 26 22:22:17 rainbow kernel: [   15.172057] ACPI: Sleep Button (CM) [SLPB]
Jan 26 22:22:17 rainbow kernel: [   15.187746] pci_hotplug: PCI Hot
Plug PCI Core version: 0.5
Jan 26 22:22:17 rainbow kernel: [   15.361161] shpchp: Standard Hot
Plug PCI Controller Driver version: 0.4
Jan 26 22:22:17 rainbow kernel: [   15.567047] yenta_cardbus
0000:15:00.0: CardBus bridge found [17aa:20c6]
Jan 26 22:22:17 rainbow kernel: [   15.625399] ACPI: AC Adapter [AC] (on-line)
Jan 26 22:22:17 rainbow kernel: [   15.693132] yenta_cardbus
0000:15:00.0: ISA IRQ mask 0x0cb8, PCI irq 16
Jan 26 22:22:17 rainbow kernel: [   15.693208] yenta_cardbus
0000:15:00.0: Socket status: 30000006
Jan 26 22:22:17 rainbow kernel: [   15.693298] yenta_cardbus
0000:15:00.0: pcmcia: parent PCI bridge I/O window: 0x7000 - 0xafff
Jan 26 22:22:17 rainbow kernel: [   15.693381] yenta_cardbus
0000:15:00.0: pcmcia: parent PCI bridge Memory window: 0xf8300000 -
0xfbffffff
Jan 26 22:22:17 rainbow kernel: [   15.693462] yenta_cardbus
0000:15:00.0: pcmcia: parent PCI bridge Memory window: 0xf4000000 -
0xf7ffffff
Jan 26 22:22:17 rainbow kernel: [   15.709398] ACPI: WMI: Mapper loaded
Jan 26 22:22:17 rainbow kernel: [   15.746607] iTCO_vendor_support:
vendor-support=0
Jan 26 22:22:17 rainbow kernel: [   15.766290] iTCO_wdt: Intel TCO
WatchDog Timer Driver v1.04
Jan 26 22:22:17 rainbow kernel: [   15.766493] iTCO_wdt: Found a
ICH8M-E TCO device (Version=2, TCOBASE=0x1060)
Jan 26 22:22:17 rainbow kernel: [   15.766691] iTCO_wdt: initialized.
heartbeat=30 sec (nowayout=0)
Jan 26 22:22:17 rainbow kernel: [   15.795670] agpgart-intel
0000:00:00.0: Intel 965GM Chipset
Jan 26 22:22:17 rainbow kernel: [   15.796693] agpgart-intel
0000:00:00.0: detected 7676K stolen memory
Jan 26 22:22:17 rainbow kernel: [   15.799762] agpgart-intel
0000:00:00.0: AGP aperture is 256M @ 0xe0000000
Jan 26 22:22:17 rainbow kernel: [   15.816070] Non-volatile memory driver v1.3
Jan 26 22:22:17 rainbow kernel: [   15.960150] cfg80211: Using static
regulatory domain info
Jan 26 22:22:17 rainbow kernel: [   15.960233] cfg80211: Regulatory domain: US
Jan 26 22:22:17 rainbow kernel: [   15.960296] ^I(start_freq -
end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Jan 26 22:22:17 rainbow kernel: [   15.960373] ^I(2402000 KHz -
2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
Jan 26 22:22:17 rainbow kernel: [   15.960453] ^I(5170000 KHz -
5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
Jan 26 22:22:17 rainbow kernel: [   15.960523] ^I(5190000 KHz -
5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
Jan 26 22:22:17 rainbow kernel: [   15.960591] ^I(5210000 KHz -
5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
Jan 26 22:22:17 rainbow kernel: [   15.960663] ^I(5230000 KHz -
5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
Jan 26 22:22:17 rainbow kernel: [   15.960730] ^I(5735000 KHz -
5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
Jan 26 22:22:17 rainbow kernel: [   15.960796] cfg80211: Calling CRDA
for country: US
Jan 26 22:22:17 rainbow kernel: [   15.992954] acpi device:03:
registered as cooling_device2
Jan 26 22:22:17 rainbow kernel: [   15.993309] input: Video Bus as
/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:02/input/input4
Jan 26 22:22:17 rainbow kernel: [   16.012051] ACPI: Video Device
[VID] (multi-head: yes  rom: no  post: no)
Jan 26 22:22:17 rainbow kernel: [   16.050915] input: PC Speaker as
/devices/platform/pcspkr/input/input5
Jan 26 22:22:17 rainbow kernel: [   16.194821] lib80211: common
routines for IEEE802.11 drivers
Jan 26 22:22:17 rainbow kernel: [   16.194886] lib80211_crypt:
registered algorithm 'NULL'
Jan 26 22:22:17 rainbow kernel: [   16.214458] ACPI: Battery Slot
[BAT0] (battery present)
Jan 26 22:22:17 rainbow kernel: [   16.305650] thinkpad_acpi: ThinkPad
ACPI Extras v0.22
Jan 26 22:22:17 rainbow kernel: [   16.305733] thinkpad_acpi:
http://ibm-acpi.sf.net/
Jan 26 22:22:17 rainbow kernel: [   16.305804] thinkpad_acpi: ThinkPad
BIOS 7LETB2WW (2.12 ), EC 7KHT24WW-1.08
Jan 26 22:22:17 rainbow kernel: [   16.305871] thinkpad_acpi: Lenovo
ThinkPad T61, model 7658CTO
Jan 26 22:22:17 rainbow kernel: [   16.308463] thinkpad_acpi: ACPI
backlight control delay disabled
Jan 26 22:22:17 rainbow kernel: [   16.309160] thinkpad_acpi: radio
switch found; radios are enabled
Jan 26 22:22:17 rainbow kernel: [   16.309338] thinkpad_acpi: This
ThinkPad has standard ACPI backlight brightness control, supported by
the ACPI video driver
Jan 26 22:22:17 rainbow kernel: [   16.309427] thinkpad_acpi:
Disabling thinkpad-acpi brightness events by default...
Jan 26 22:22:17 rainbow kernel: [   16.315097] Registered led device:
tpacpi::thinklight
Jan 26 22:22:17 rainbow kernel: [   16.315203] Registered led device:
tpacpi::power
Jan 26 22:22:17 rainbow kernel: [   16.315292] Registered led device:
tpacpi:orange:batt
Jan 26 22:22:17 rainbow kernel: [   16.315383] Registered led device:
tpacpi:green:batt
Jan 26 22:22:17 rainbow kernel: [   16.315476] Registered led device:
tpacpi::dock_active
Jan 26 22:22:17 rainbow kernel: [   16.315567] Registered led device:
tpacpi::bay_active
Jan 26 22:22:17 rainbow kernel: [   16.315660] Registered led device:
tpacpi::dock_batt
Jan 26 22:22:17 rainbow kernel: [   16.315766] Registered led device:
tpacpi::unknown_led
Jan 26 22:22:17 rainbow kernel: [   16.315866] Registered led device:
tpacpi::standby
Jan 26 22:22:17 rainbow kernel: [   16.318090] thinkpad_acpi: Standard
ACPI backlight interface available, not loading native one.
Jan 26 22:22:17 rainbow kernel: [   16.318441] input: ThinkPad Extra
Buttons as /devices/virtual/input/input6
Jan 26 22:22:17 rainbow kernel: [   16.660935] Synaptics Touchpad,
model: 1, fw: 6.2, id: 0x81a0b1, caps: 0xa04791/0x300000
Jan 26 22:22:17 rainbow kernel: [   16.661029] serio: Synaptics
pass-through port at isa0060/serio1/input0
Jan 26 22:22:17 rainbow kernel: [   16.707818] input: SynPS/2
Synaptics TouchPad as /devices/platform/i8042/serio1/input/input7
Jan 26 22:22:17 rainbow kernel: [   17.288082] usb 5-2: firmware:
requesting isl3886usb
Jan 26 22:22:17 rainbow kernel: [   17.491721] iwl3945: Intel(R)
PRO/Wireless 3945ABG/BG Network Connection driver for Linux, 1.2.26kds
Jan 26 22:22:17 rainbow kernel: [   17.491828] iwl3945: Copyright(c)
2003-2009 Intel Corporation
Jan 26 22:22:17 rainbow kernel: [   17.492080] iwl3945 0000:03:00.0:
PCI INT A -> GSI 17 (level, low) -> IRQ 17
Jan 26 22:22:17 rainbow kernel: [   17.492152] iwl3945 0000:03:00.0:
setting latency timer to 64
Jan 26 22:22:17 rainbow kernel: [   17.492491] ieee80211 phy1: U
iwl3945_pci_probe pci_resource_len = 0x00001000
Jan 26 22:22:17 rainbow kernel: [   17.492568] ieee80211 phy1: U
iwl3945_pci_probe pci_resource_base = ffffc20005160000
Jan 26 22:22:17 rainbow kernel: [   17.492693] ieee80211 phy1: U
iwl3945_power_init_handle Initialize power
Jan 26 22:22:17 rainbow kernel: [   17.492752] ieee80211 phy1: U
iwl3945_power_init_handle adjust power command flags
Jan 26 22:22:17 rainbow kernel: [   17.547872] ieee80211 phy1: U
iwl3945_pci_probe MAC address: 00:1f:3c:20:a1:6e
Jan 26 22:22:17 rainbow kernel: [   17.547942] ieee80211 phy1: U
iwl_init_channel_map Initializing regulatory info from EEPROM
Jan 26 22:22:17 rainbow kernel: [   17.548007] ieee80211 phy1: U
iwl_init_channel_map Parsing data for 56 channels.
Jan 26 22:22:17 rainbow kernel: [   17.550390] ieee80211 phy1: U
iwl_init_channel_map Ch. 1 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b
15dBm): Ad-Hoc supported
Jan 26 22:22:17 rainbow kernel: [   17.550466] ieee80211 phy1: U
iwl_init_channel_map Ch. 2 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b
15dBm): Ad-Hoc supported
Jan 26 22:22:17 rainbow kernel: [   17.550535] ieee80211 phy1: U
iwl_init_channel_map Ch. 3 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b
15dBm): Ad-Hoc supported
Jan 26 22:22:17 rainbow kernel: [   17.550603] ieee80211 phy1: U
iwl_init_channel_map Ch. 4 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b
15dBm): Ad-Hoc supported
Jan 26 22:22:17 rainbow kernel: [   17.550672] ieee80211 phy1: U
iwl_init_channel_map Ch. 5 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b
15dBm): Ad-Hoc supported
Jan 26 22:22:17 rainbow kernel: [   17.550743] ieee80211 phy1: U
iwl_init_channel_map Ch. 6 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b
15dBm): Ad-Hoc supported
Jan 26 22:22:17 rainbow kernel: [   17.550811] ieee80211 phy1: U
iwl_init_channel_map Ch. 7 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b
15dBm): Ad-Hoc supported
Jan 26 22:22:17 rainbow kernel: [   17.550880] ieee80211 phy1: U
iwl_init_channel_map Ch. 8 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b
15dBm): Ad-Hoc supported
Jan 26 22:22:17 rainbow kernel: [   17.550948] ieee80211 phy1: U
iwl_init_channel_map Ch. 9 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b
15dBm): Ad-Hoc supported
Jan 26 22:22:17 rainbow kernel: [   17.551023] ieee80211 phy1: U
iwl_init_channel_map Ch. 10 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b
15dBm): Ad-Hoc supported
Jan 26 22:22:17 rainbow kernel: [   17.551092] ieee80211 phy1: U
iwl_init_channel_map Ch. 11 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b
14dBm): Ad-Hoc supported
Jan 26 22:22:17 rainbow kernel: [   17.551160] ieee80211 phy1: U
iwl_init_channel_map Ch. 12 Flags 0 [2.4GHz] - No traffic
Jan 26 22:22:17 rainbow kernel: [   17.551225] ieee80211 phy1: U
iwl_init_channel_map Ch. 13 Flags 0 [2.4GHz] - No traffic
Jan 26 22:22:17 rainbow kernel: [   17.551291] ieee80211 phy1: U
iwl_init_channel_map Ch. 14 Flags 0 [2.4GHz] - No traffic
Jan 26 22:22:17 rainbow kernel: [   17.551356] ieee80211 phy1: U
iwl_init_channel_map Ch. 183 Flags 0 [5.2GHz] - No traffic
Jan 26 22:22:17 rainbow kernel: [   17.551421] ieee80211 phy1: U
iwl_init_channel_map Ch. 184 Flags 0 [5.2GHz] - No traffic
Jan 26 22:22:17 rainbow kernel: [   17.551489] ieee80211 phy1: U
iwl_init_channel_map Ch. 185 Flags 0 [5.2GHz] - No traffic
Jan 26 22:22:17 rainbow kernel: [   17.551562] ieee80211 phy1: U
iwl_init_channel_map Ch. 187 Flags 0 [5.2GHz] - No traffic
Jan 26 22:22:17 rainbow kernel: [   17.551628] ieee80211 phy1: U
iwl_init_channel_map Ch. 188 Flags 0 [5.2GHz] - No traffic
Jan 26 22:22:17 rainbow kernel: [   17.551692] ieee80211 phy1: U
iwl_init_channel_map Ch. 189 Flags 0 [5.2GHz] - No traffic
Jan 26 22:22:17 rainbow kernel: [   17.551757] ieee80211 phy1: U
iwl_init_channel_map Ch. 192 Flags 0 [5.2GHz] - No traffic
Jan 26 22:22:17 rainbow kernel: [   17.551827] ieee80211 phy1: U
iwl_init_channel_map Ch. 196 Flags 0 [5.2GHz] - No traffic
Jan 26 22:22:17 rainbow kernel: [   17.551900] ieee80211 phy1: U
iwl_init_channel_map Ch. 7 Flags 0 [5.2GHz] - No traffic
Jan 26 22:22:17 rainbow kernel: [   17.551967] ieee80211 phy1: U
iwl_init_channel_map Ch. 8 Flags 0 [5.2GHz] - No traffic
Jan 26 22:22:17 rainbow kernel: [   17.552689] ieee80211 phy1: U
iwl_init_channel_map Ch. 11 Flags 0 [5.2GHz] - No traffic
Jan 26 22:22:17 rainbow kernel: [   17.552753] ieee80211 phy1: U
iwl_init_channel_map Ch. 12 Flags 0 [5.2GHz] - No traffic
Jan 26 22:22:17 rainbow kernel: [   17.552817] ieee80211 phy1: U
iwl_init_channel_map Ch. 16 Flags 0 [5.2GHz] - No traffic
Jan 26 22:22:17 rainbow kernel: [   17.552900] ieee80211 phy1: U
iwl_init_channel_map Ch. 34 Flags 0 [5.2GHz] - No traffic
Jan 26 22:22:17 rainbow kernel: [   17.552965] ieee80211 phy1: U
iwl_init_channel_map Ch. 36 [5.2GHz] VALID WIDE DFS (0xa1 14dBm):
Ad-Hoc not supported
Jan 26 22:22:17 rainbow kernel: [   17.553035] ieee80211 phy1: U
iwl_init_channel_map Ch. 38 Flags 0 [5.2GHz] - No traffic
Jan 26 22:22:17 rainbow kernel: [   17.553131] ieee80211 phy1: U
iwl_init_channel_map Ch. 40 [5.2GHz] VALID WIDE DFS (0xa1 14dBm):
Ad-Hoc not supported
Jan 26 22:22:17 rainbow kernel: [   17.553205] ieee80211 phy1: U
iwl_init_channel_map Ch. 42 Flags 0 [5.2GHz] - No traffic
Jan 26 22:22:17 rainbow kernel: [   17.553270] ieee80211 phy1: U
iwl_init_channel_map Ch. 44 [5.2GHz] VALID WIDE DFS (0xa1 14dBm):
Ad-Hoc not supported
Jan 26 22:22:17 rainbow kernel: [   17.553343] ieee80211 phy1: U
iwl_init_channel_map Ch. 46 Flags 0 [5.2GHz] - No traffic
Jan 26 22:22:17 rainbow kernel: [   17.553411] ieee80211 phy1: U
iwl_init_channel_map Ch. 48 [5.2GHz] VALID WIDE DFS (0xa1 14dBm):
Ad-Hoc not supported
Jan 26 22:22:17 rainbow kernel: [   17.553479] ieee80211 phy1: U
iwl_init_channel_map Ch. 52 [5.2GHz] VALID RADAR WIDE DFS (0xb1
14dBm): Ad-Hoc not supported
Jan 26 22:22:17 rainbow kernel: [   17.553547] ieee80211 phy1: U
iwl_init_channel_map Ch. 56 [5.2GHz] VALID RADAR WIDE DFS (0xb1
14dBm): Ad-Hoc not supported
Jan 26 22:22:17 rainbow kernel: [   17.553621] ieee80211 phy1: U
iwl_init_channel_map Ch. 60 [5.2GHz] VALID RADAR WIDE DFS (0xb1
14dBm): Ad-Hoc not supported
Jan 26 22:22:17 rainbow kernel: [   17.553703] ieee80211 phy1: U
iwl_init_channel_map Ch. 64 [5.2GHz] VALID RADAR WIDE DFS (0xb1
14dBm): Ad-Hoc not supported
Jan 26 22:22:17 rainbow kernel: [   17.553771] ieee80211 phy1: U
iwl_init_channel_map Ch. 100 Flags 0 [5.2GHz] - No traffic
Jan 26 22:22:17 rainbow kernel: [   17.553835] ieee80211 phy1: U
iwl_init_channel_map Ch. 104 Flags 0 [5.2GHz] - No traffic
Jan 26 22:22:17 rainbow kernel: [   17.553904] ieee80211 phy1: U
iwl_init_channel_map Ch. 108 Flags 0 [5.2GHz] - No traffic
Jan 26 22:22:17 rainbow kernel: [   17.553973] ieee80211 phy1: U
iwl_init_channel_map Ch. 112 Flags 0 [5.2GHz] - No traffic
Jan 26 22:22:17 rainbow kernel: [   17.554037] ieee80211 phy1: U
iwl_init_channel_map Ch. 116 Flags 0 [5.2GHz] - No traffic
Jan 26 22:22:17 rainbow kernel: [   17.554101] ieee80211 phy1: U
iwl_init_channel_map Ch. 120 Flags 0 [5.2GHz] - No traffic
Jan 26 22:22:17 rainbow kernel: [   17.554170] ieee80211 phy1: U
iwl_init_channel_map Ch. 124 Flags 0 [5.2GHz] - No traffic
Jan 26 22:22:17 rainbow kernel: [   17.554248] ieee80211 phy1: U
iwl_init_channel_map Ch. 128 Flags 0 [5.2GHz] - No traffic
Jan 26 22:22:17 rainbow kernel: [   17.554313] ieee80211 phy1: U
iwl_init_channel_map Ch. 132 Flags 0 [5.2GHz] - No traffic
Jan 26 22:22:17 rainbow kernel: [   17.554377] ieee80211 phy1: U
iwl_init_channel_map Ch. 136 Flags 0 [5.2GHz] - No traffic
Jan 26 22:22:17 rainbow kernel: [   17.554446] ieee80211 phy1: U
iwl_init_channel_map Ch. 140 Flags 0 [5.2GHz] - No traffic
Jan 26 22:22:17 rainbow kernel: [   17.554515] ieee80211 phy1: U
iwl_init_channel_map Ch. 145 Flags 0 [5.2GHz] - No traffic
Jan 26 22:22:17 rainbow kernel: [   17.554580] ieee80211 phy1: U
iwl_init_channel_map Ch. 149 [5.2GHz] VALID WIDE (0x21 16dBm): Ad-Hoc
not supported
Jan 26 22:22:17 rainbow kernel: [   17.554647] ieee80211 phy1: U
iwl_init_channel_map Ch. 153 [5.2GHz] VALID WIDE (0x21 16dBm): Ad-Hoc
not supported
Jan 26 22:22:17 rainbow kernel: [   17.554720] ieee80211 phy1: U
iwl_init_channel_map Ch. 157 [5.2GHz] VALID WIDE (0x21 16dBm): Ad-Hoc
not supported
Jan 26 22:22:17 rainbow kernel: [   17.554808] ieee80211 phy1: U
iwl_init_channel_map Ch. 161 [5.2GHz] VALID WIDE (0x21 16dBm): Ad-Hoc
not supported
Jan 26 22:22:17 rainbow kernel: [   17.554889] ieee80211 phy1: U
iwl_init_channel_map Ch. 165 [5.2GHz] VALID WIDE (0x21 16dBm): Ad-Hoc
not supported
Jan 26 22:22:17 rainbow kernel: [   17.554970] ieee80211 phy1: U
iwl3945_hw_reg_txpower_get_temperature Temperature: 260
Jan 26 22:22:17 rainbow kernel: [   17.555044] ieee80211 phy1: U
iwl3945_hw_reg_init_channel_groups Initializing factory calib info
from EEPROM
Jan 26 22:22:17 rainbow kernel: [   17.555118] ieee80211 phy1: U
iwl3945_hw_reg_get_ch_grp_index Chnl 1 mapped to grp 0
Jan 26 22:22:17 rainbow kernel: [   17.555182] ieee80211 phy1: U
iwl3945_txpower_set_from_eeprom Delta index for channel 1: -21 [260]
Jan 26 22:22:17 rainbow kernel: [   17.555248] ieee80211 phy1: U
iwl3945_hw_reg_get_ch_grp_index Chnl 2 mapped to grp 0
Jan 26 22:22:17 rainbow kernel: [   17.555315] ieee80211 phy1: U
iwl3945_txpower_set_from_eeprom Delta index for channel 2: -21 [260]
Jan 26 22:22:17 rainbow kernel: [   17.555381] ieee80211 phy1: U
iwl3945_hw_reg_get_ch_grp_index Chnl 3 mapped to grp 0
Jan 26 22:22:17 rainbow kernel: [   17.555445] ieee80211 phy1: U
iwl3945_txpower_set_from_eeprom Delta index for channel 3: -21 [260]
Jan 26 22:22:17 rainbow kernel: [   17.555516] ieee80211 phy1: U
iwl3945_hw_reg_get_ch_grp_index Chnl 4 mapped to grp 0
Jan 26 22:22:17 rainbow kernel: [   17.555593] ieee80211 phy1: U
iwl3945_txpower_set_from_eeprom Delta index for channel 4: -21 [260]
Jan 26 22:22:17 rainbow kernel: [   17.555659] ieee80211 phy1: U
iwl3945_hw_reg_get_ch_grp_index Chnl 5 mapped to grp 0
Jan 26 22:22:17 rainbow kernel: [   17.555723] ieee80211 phy1: U
iwl3945_txpower_set_from_eeprom Delta index for channel 5: -21 [260]
Jan 26 22:22:17 rainbow kernel: [   17.555794] ieee80211 phy1: U
iwl3945_hw_reg_get_ch_grp_index Chnl 6 mapped to grp 0
Jan 26 22:22:17 rainbow kernel: [   17.555862] ieee80211 phy1: U
iwl3945_txpower_set_from_eeprom Delta index for channel 6: -21 [260]
Jan 26 22:22:17 rainbow kernel: [   17.555927] ieee80211 phy1: U
iwl3945_hw_reg_get_ch_grp_index Chnl 7 mapped to grp 0
Jan 26 22:22:17 rainbow kernel: [   17.555991] ieee80211 phy1: U
iwl3945_txpower_set_from_eeprom Delta index for channel 7: -21 [260]
Jan 26 22:22:17 rainbow kernel: [   17.556062] ieee80211 phy1: U
iwl3945_hw_reg_get_ch_grp_index Chnl 8 mapped to grp 0
Jan 26 22:22:17 rainbow kernel: [   17.556157] ieee80211 phy1: U
iwl3945_txpower_set_from_eeprom Delta index for channel 8: -21 [260]
Jan 26 22:22:17 rainbow kernel: [   17.556223] ieee80211 phy1: U
iwl3945_hw_reg_get_ch_grp_index Chnl 9 mapped to grp 0
Jan 26 22:22:17 rainbow kernel: [   17.556293] ieee80211 phy1: U
iwl3945_txpower_set_from_eeprom Delta index for channel 9: -21 [260]
Jan 26 22:22:17 rainbow kernel: [   17.556382] ieee80211 phy1: U
iwl3945_hw_reg_get_ch_grp_index Chnl 10 mapped to grp 0
Jan 26 22:22:17 rainbow kernel: [   17.556454] ieee80211 phy1: U
iwl3945_txpower_set_from_eeprom Delta index for channel 10: -21 [260]
Jan 26 22:22:17 rainbow kernel: [   17.556520] ieee80211 phy1: U
iwl3945_hw_reg_get_ch_grp_index Chnl 11 mapped to grp 0
Jan 26 22:22:17 rainbow kernel: [   17.556590] ieee80211 phy1: U
iwl3945_txpower_set_from_eeprom Delta index for channel 11: -21 [260]
Jan 26 22:22:17 rainbow kernel: [   17.556655] ieee80211 phy1: U
iwl3945_hw_reg_get_ch_grp_index Chnl 36 mapped to grp 1
Jan 26 22:22:17 rainbow kernel: [   17.556724] ieee80211 phy1: U
iwl3945_txpower_set_from_eeprom Delta index for channel 36: -21 [260]
Jan 26 22:22:17 rainbow kernel: [   17.556790] ieee80211 phy1: U
iwl3945_hw_reg_get_ch_grp_index Chnl 40 mapped to grp 1
Jan 26 22:22:17 rainbow kernel: [   17.556853] ieee80211 phy1: U
iwl3945_txpower_set_from_eeprom Delta index for channel 40: -21 [260]
Jan 26 22:22:17 rainbow kernel: [   17.556925] ieee80211 phy1: U
iwl3945_hw_reg_get_ch_grp_index Chnl 44 mapped to grp 1
Jan 26 22:22:17 rainbow kernel: [   17.557004] ieee80211 phy1: U
iwl3945_txpower_set_from_eeprom Delta index for channel 44: -21 [260]
Jan 26 22:22:17 rainbow kernel: [   17.557087] ieee80211 phy1: U
iwl3945_hw_reg_get_ch_grp_index Chnl 48 mapped to grp 2
Jan 26 22:22:17 rainbow kernel: [   17.557151] ieee80211 phy1: U
iwl3945_txpower_set_from_eeprom Delta index for channel 48: -21 [260]
Jan 26 22:22:17 rainbow kernel: [   17.557228] ieee80211 phy1: U
iwl3945_hw_reg_get_ch_grp_index Chnl 52 mapped to grp 2
Jan 26 22:22:17 rainbow kernel: [   17.557303] ieee80211 phy1: U
iwl3945_txpower_set_from_eeprom Delta index for channel 52: -21 [260]
Jan 26 22:22:17 rainbow kernel: [   17.557369] ieee80211 phy1: U
iwl3945_hw_reg_get_ch_grp_index Chnl 56 mapped to grp 2
Jan 26 22:22:17 rainbow kernel: [   17.557433] ieee80211 phy1: U
iwl3945_txpower_set_from_eeprom Delta index for channel 56: -21 [260]
Jan 26 22:22:17 rainbow kernel: [   17.557504] ieee80211 phy1: U
iwl3945_hw_reg_get_ch_grp_index Chnl 60 mapped to grp 2
Jan 26 22:22:17 rainbow kernel: [   17.557571] ieee80211 phy1: U
iwl3945_txpower_set_from_eeprom Delta index for channel 60: -21 [260]
Jan 26 22:22:17 rainbow kernel: [   17.557650] ieee80211 phy1: U
iwl3945_hw_reg_get_ch_grp_index Chnl 64 mapped to grp 2
Jan 26 22:22:17 rainbow kernel: [   17.557721] ieee80211 phy1: U
iwl3945_txpower_set_from_eeprom Delta index for channel 64: -21 [260]
Jan 26 22:22:17 rainbow kernel: [   17.557794] ieee80211 phy1: U
iwl3945_hw_reg_get_ch_grp_index Chnl 149 mapped to grp 4
Jan 26 22:22:17 rainbow kernel: [   17.557860] ieee80211 phy1: U
iwl3945_txpower_set_from_eeprom Delta index for channel 149: -21 [260]
Jan 26 22:22:17 rainbow kernel: [   17.557932] ieee80211 phy1: U
iwl3945_hw_reg_get_ch_grp_index Chnl 153 mapped to grp 4
Jan 26 22:22:17 rainbow kernel: [   17.558002] ieee80211 phy1: U
iwl3945_txpower_set_from_eeprom Delta index for channel 153: -21 [260]
Jan 26 22:22:17 rainbow kernel: [   17.558088] ieee80211 phy1: U
iwl3945_hw_reg_get_ch_grp_index Chnl 157 mapped to grp 4
Jan 26 22:22:17 rainbow kernel: [   17.558152] ieee80211 phy1: U
iwl3945_txpower_set_from_eeprom Delta index for channel 157: -21 [260]
Jan 26 22:22:17 rainbow kernel: [   17.558218] ieee80211 phy1: U
iwl3945_hw_reg_get_ch_grp_index Chnl 161 mapped to grp 4
Jan 26 22:22:17 rainbow kernel: [   17.558288] ieee80211 phy1: U
iwl3945_txpower_set_from_eeprom Delta index for channel 161: -21 [260]
Jan 26 22:22:17 rainbow kernel: [   17.558358] ieee80211 phy1: U
iwl3945_hw_reg_get_ch_grp_index Chnl 165 mapped to grp 4
Jan 26 22:22:17 rainbow kernel: [   17.558422] ieee80211 phy1: U
iwl3945_txpower_set_from_eeprom Delta index for channel 165: -21 [260]
Jan 26 22:22:17 rainbow kernel: [   17.558491] ieee80211 phy1: U
iwlcore_init_geos Channel 1 Freq=2412[2.4GHz] valid flag=0x30
Jan 26 22:22:17 rainbow kernel: [   17.558561] ieee80211 phy1: U
iwlcore_init_geos Channel 2 Freq=2417[2.4GHz] valid flag=0x30
Jan 26 22:22:17 rainbow kernel: [   17.558639] ieee80211 phy1: U
iwlcore_init_geos Channel 3 Freq=2422[2.4GHz] valid flag=0x30
Jan 26 22:22:17 rainbow kernel: [   17.558704] ieee80211 phy1: U
iwlcore_init_geos Channel 4 Freq=2427[2.4GHz] valid flag=0x30
Jan 26 22:22:17 rainbow kernel: [   17.558769] ieee80211 phy1: U
iwlcore_init_geos Channel 5 Freq=2432[2.4GHz] valid flag=0x30
Jan 26 22:22:17 rainbow kernel: [   17.558839] ieee80211 phy1: U
iwlcore_init_geos Channel 6 Freq=2437[2.4GHz] valid flag=0x30
Jan 26 22:22:17 rainbow kernel: [   17.558908] ieee80211 phy1: U
iwlcore_init_geos Channel 7 Freq=2442[2.4GHz] valid flag=0x30
Jan 26 22:22:17 rainbow kernel: [   17.558972] ieee80211 phy1: U
iwlcore_init_geos Channel 8 Freq=2447[2.4GHz] valid flag=0x30
Jan 26 22:22:17 rainbow kernel: [   17.559664] ieee80211 phy1: U
iwlcore_init_geos Channel 9 Freq=2452[2.4GHz] valid flag=0x30
Jan 26 22:22:17 rainbow kernel: [   17.559744] ieee80211 phy1: U
iwlcore_init_geos Channel 10 Freq=2457[2.4GHz] valid flag=0x30
Jan 26 22:22:17 rainbow kernel: [   17.559820] ieee80211 phy1: U
iwlcore_init_geos Channel 11 Freq=2462[2.4GHz] valid flag=0x30
Jan 26 22:22:17 rainbow kernel: [   17.559891] ieee80211 phy1: U
iwlcore_init_geos Channel 36 Freq=5180[5.2GHz] valid flag=0x36
Jan 26 22:22:17 rainbow kernel: [   17.559959] ieee80211 phy1: U
iwlcore_init_geos Channel 40 Freq=5200[5.2GHz] valid flag=0x36
Jan 26 22:22:17 rainbow kernel: [   17.560029] ieee80211 phy1: U
iwlcore_init_geos Channel 44 Freq=5220[5.2GHz] valid flag=0x36
Jan 26 22:22:17 rainbow kernel: [   17.560119] ieee80211 phy1: U
iwlcore_init_geos Channel 48 Freq=5240[5.2GHz] valid flag=0x36
Jan 26 22:22:17 rainbow kernel: [   17.560196] ieee80211 phy1: U
iwlcore_init_geos Channel 52 Freq=5260[5.2GHz] valid flag=0x3E
Jan 26 22:22:17 rainbow kernel: [   17.560264] ieee80211 phy1: U
iwlcore_init_geos Channel 56 Freq=5280[5.2GHz] valid flag=0x3E
Jan 26 22:22:17 rainbow kernel: [   17.560330] ieee80211 phy1: U
iwlcore_init_geos Channel 60 Freq=5300[5.2GHz] valid flag=0x3E
Jan 26 22:22:17 rainbow kernel: [   17.560398] ieee80211 phy1: U
iwlcore_init_geos Channel 64 Freq=5320[5.2GHz] valid flag=0x3E
Jan 26 22:22:17 rainbow kernel: [   17.560470] ieee80211 phy1: U
iwlcore_init_geos Channel 149 Freq=5745[5.2GHz] valid flag=0x36
Jan 26 22:22:17 rainbow kernel: [   17.560537] ieee80211 phy1: U
iwlcore_init_geos Channel 153 Freq=5765[5.2GHz] valid flag=0x36
Jan 26 22:22:17 rainbow kernel: [   17.560603] ieee80211 phy1: U
iwlcore_init_geos Channel 157 Freq=5785[5.2GHz] valid flag=0x36
Jan 26 22:22:17 rainbow kernel: [   17.560674] ieee80211 phy1: U
iwlcore_init_geos Channel 161 Freq=5805[5.2GHz] valid flag=0x36
Jan 26 22:22:17 rainbow kernel: [   17.560745] ieee80211 phy1: U
iwlcore_init_geos Channel 165 Freq=5825[5.2GHz] valid flag=0x36
Jan 26 22:22:17 rainbow kernel: [   17.560818] iwl3945 0000:03:00.0:
Tunable channels: 11 802.11bg, 13 802.11a channels
Jan 26 22:22:17 rainbow kernel: [   17.560890] iwl3945 0000:03:00.0:
Detected Intel Wireless WiFi Link 3945ABG
Jan 26 22:22:17 rainbow kernel: [   17.561100] iwl3945 0000:03:00.0:
irq 31 for MSI/MSI-X
Jan 26 22:22:17 rainbow kernel: [   17.561264] ieee80211 phy1: U
iwl3945_set_rxon_channel Staging channel set to 6 [0]
Jan 26 22:22:17 rainbow kernel: [   17.562413] wmaster0 (iwl3945): not
using net_device_ops yet
Jan 26 22:22:17 rainbow kernel: [   17.562673] phy1: Selected rate
control algorithm 'iwl-3945-rs'
Jan 26 22:22:17 rainbow kernel: [   17.576673] phy0: p54 detected a
LM86 firmware
Jan 26 22:22:17 rainbow kernel: [   17.576729] p54: rx_mtu reduced
from 3240 to 2392
Jan 26 22:22:17 rainbow kernel: [   17.576780] phy0: FW rev 2.13.24.0
- Softmac protocol 5.9
Jan 26 22:22:17 rainbow kernel: [   17.576832] phy0: cryptographic
accelerator WEP:YES, TKIP:YES, CCMP:YES
Jan 26 22:22:17 rainbow kernel: [   17.993150] wlan0 (iwl3945): not
using net_device_ops yet
Jan 26 22:22:17 rainbow kernel: [   18.253753] HDA Intel 0000:00:1b.0:
PCI INT B -> GSI 17 (level, low) -> IRQ 17
Jan 26 22:22:17 rainbow kernel: [   18.253826] hda_intel: probe_mask
set to 0x1 for device 17aa:20ac
Jan 26 22:22:17 rainbow kernel: [   18.253965] HDA Intel 0000:00:1b.0:
setting latency timer to 64
Jan 26 22:22:17 rainbow kernel: [   19.776166] p54usb: probe of
5-2:1.0 failed with error -110
Jan 26 22:22:17 rainbow kernel: [   19.776283] usbcore: registered new
interface driver p54usb
Jan 26 22:22:17 rainbow kernel: [   20.922546] Adding 4803392k swap on
/dev/sda5.  Priority:-1 extents:1 across:4803392k
Jan 26 22:22:17 rainbow kernel: [   21.356124] EXT3 FS on sda1, internal journal
Jan 26 22:22:17 rainbow kernel: [   21.923884] ip_tables: (C)
2000-2006 Netfilter Core Team
Jan 26 22:22:17 rainbow kernel: [   22.425071] IBM TrackPoint
firmware: 0x0e, buttons: 3/3
Jan 26 22:22:17 rainbow kernel: [   22.649784] input: TPPS/2 IBM
TrackPoint as /devices/platform/i8042/serio1/serio2/input/input8
Jan 26 22:22:17 rainbow kernel: [   23.995719] warning: `avahi-daemon'
uses 32-bit capabilities (legacy support in use)
Jan 26 22:22:17 rainbow kernel: [   24.631391] NET: Registered
protocol family 10
Jan 26 22:22:17 rainbow kernel: [   24.631770] lo: Disabled Privacy Extensions
Jan 26 22:22:23 rainbow kernel: [   29.831448] [drm] Initialized drm
1.1.0 20060810
Jan 26 22:22:23 rainbow kernel: [   30.061846] pci 0000:00:02.0: power
state changed by ACPI to D0
Jan 26 22:22:23 rainbow kernel: [   30.061865] pci 0000:00:02.0: PCI
INT A -> GSI 16 (level, low) -> IRQ 16
Jan 26 22:22:23 rainbow kernel: [   30.061876] pci 0000:00:02.0:
setting latency timer to 64
Jan 26 22:22:23 rainbow kernel: [   30.069264] pci 0000:00:02.0: irq
32 for MSI/MSI-X
Jan 26 22:22:23 rainbow kernel: [   30.069306] [drm] Initialized i915
1.6.0 20080730 on minor 0
Jan 26 22:22:23 rainbow kernel: [   30.102071] mtrr: type mismatch for
e0000000,10000000 old: write-back new: write-combining
Jan 26 22:22:24 rainbow kernel: [   30.890367] ieee80211 phy1: U
iwl3945_mac_start enter
Jan 26 22:22:24 rainbow kernel: [   30.890390] iwl3945 0000:03:00.0:
firmware: requesting iwlwifi-3945-2.ucode
Jan 26 22:22:24 rainbow kernel: [   30.922082] ieee80211 phy1: U
iwl3945_read_ucode Got firmware 'iwlwifi-3945-2.ucode' file (149816
bytes) from disk
Jan 26 22:22:24 rainbow kernel: [   30.922102] iwl3945 0000:03:00.0:
loaded firmware version 15.28.2.8
Jan 26 22:22:24 rainbow kernel: [   30.922107] ieee80211 phy1: U
iwl3945_read_ucode f/w package hdr ucode version raw = 0xf1c0208
Jan 26 22:22:24 rainbow kernel: [   30.922116] ieee80211 phy1: U
iwl3945_read_ucode f/w package hdr runtime inst size = 80684
Jan 26 22:22:24 rainbow kernel: [   30.922124] ieee80211 phy1: U
iwl3945_read_ucode f/w package hdr runtime data size = 32768
Jan 26 22:22:24 rainbow kernel: [   30.922132] ieee80211 phy1: U
iwl3945_read_ucode f/w package hdr init inst size = 2672
Jan 26 22:22:24 rainbow kernel: [   30.922139] ieee80211 phy1: U
iwl3945_read_ucode f/w package hdr init data size = 32768
Jan 26 22:22:24 rainbow kernel: [   30.922148] ieee80211 phy1: U
iwl3945_read_ucode f/w package hdr boot inst size = 900
Jan 26 22:22:24 rainbow kernel: [   30.922287] ieee80211 phy1: U
iwl3945_read_ucode Copying (but not loading) uCode instr len 80684
Jan 26 22:22:24 rainbow kernel: [   30.922331] ieee80211 phy1: U
iwl3945_read_ucode uCode instr buf vaddr = 0xffff8800bb8a0000, paddr =
0xbb8a0000
Jan 26 22:22:24 rainbow kernel: [   30.922358] ieee80211 phy1: U
iwl3945_read_ucode Copying (but not loading) uCode data len 32768
Jan 26 22:22:24 rainbow kernel: [   30.922411] ieee80211 phy1: U
iwl3945_read_ucode Copying (but not loading) init instr len 2672
Jan 26 22:22:24 rainbow kernel: [   30.922421] ieee80211 phy1: U
iwl3945_read_ucode Copying (but not loading) init data len 32768
Jan 26 22:22:24 rainbow kernel: [   30.922454] ieee80211 phy1: U
iwl3945_read_ucode Copying (but not loading) boot instr len 900
Jan 26 22:22:24 rainbow kernel: [   30.922486] ieee80211 phy1: U
iwl3945_power_init_handle Initialize power
Jan 26 22:22:24 rainbow kernel: [   30.922502] ieee80211 phy1: U
iwl3945_power_init_handle adjust power command flags
Jan 26 22:22:24 rainbow kernel: [   30.922606] ieee80211 phy1: U
iwl3945_hw_nic_init HW Revision ID = 0x2
Jan 26 22:22:24 rainbow kernel: [   30.922660] ieee80211 phy1: U
iwl3945_nic_config 3945 RADIO-MM type
Jan 26 22:22:24 rainbow kernel: [   30.922674] ieee80211 phy1: U
iwl3945_nic_config SKU OP mode is basic
Jan 26 22:22:24 rainbow kernel: [   30.922681] ieee80211 phy1: U
iwl3945_nic_config 3945ABG revision is 0xF1
Jan 26 22:22:24 rainbow kernel: [   30.922695] ieee80211 phy1: U
iwl3945_nic_config Card M type B version is 0x3
Jan 26 22:22:24 rainbow kernel: [   30.923893] ieee80211 phy1: U
iwl3945_load_bsm Begin load bsm
Jan 26 22:22:24 rainbow kernel: [   30.925160] ieee80211 phy1: U
iwl3945_verify_bsm Begin verify bsm
Jan 26 22:22:24 rainbow kernel: [   30.927322] ieee80211 phy1: U
iwl3945_verify_bsm BSM bootstrap uCode image OK
Jan 26 22:22:24 rainbow kernel: [   30.927383] ieee80211 phy1: U
iwl3945_load_bsm BSM write complete, poll 1 iterations
Jan 26 22:22:24 rainbow kernel: [   30.927404] ieee80211 phy1: U
__iwl3945_up iwl3945 is coming up
Jan 26 22:22:24 rainbow kernel: [   30.927414] ieee80211 phy1: U
iwl3945_mac_start Start UP work.
Jan 26 22:22:24 rainbow kernel: [   30.938901] ieee80211 phy1: I
iwl3945_rx_handle r = 1, i = 0, REPLY_ALIVE, 0x01
Jan 26 22:22:24 rainbow kernel: [   30.938919] ieee80211 phy1: I
iwl3945_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x9
Jan 26 22:22:24 rainbow kernel: [   30.938927] ieee80211 phy1: I
iwl3945_rx_reply_alive Initialization Alive received.
Jan 26 22:22:24 rainbow kernel: [   30.945329] ieee80211 phy1: U
iwl3945_verify_inst_sparse ucode inst image size is 900
Jan 26 22:22:24 rainbow kernel: [   30.945428] ieee80211 phy1: U
iwl3945_verify_inst_sparse ucode inst image size is 2672
Jan 26 22:22:24 rainbow kernel: [   30.945724] ieee80211 phy1: U
iwl3945_verify_ucode Initialize uCode is good in inst SRAM
Jan 26 22:22:24 rainbow kernel: [   30.945732] ieee80211 phy1: U
iwl3945_init_alive_start Initialization Alive received.
Jan 26 22:22:24 rainbow kernel: [   30.945782] ieee80211 phy1: U
iwl3945_set_ucode_ptrs Runtime uCode pointers are set.
Jan 26 22:22:24 rainbow kernel: [   30.950136] ieee80211 phy1: I
iwl3945_rx_handle r = 2, i = 1, REPLY_ALIVE, 0x01
Jan 26 22:22:24 rainbow kernel: [   30.950148] ieee80211 phy1: I
iwl3945_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x0
Jan 26 22:22:24 rainbow kernel: [   30.950156] ieee80211 phy1: I
iwl3945_rx_reply_alive Runtime Alive received.
Jan 26 22:22:24 rainbow kernel: [   30.950205] ieee80211 phy1: I
iwl3945_disable_events Selected uCode log events may be disabled
Jan 26 22:22:24 rainbow kernel: [   30.950212] ieee80211 phy1: I
iwl3945_disable_events   by writing "1"s into disable bitmap
Jan 26 22:22:24 rainbow kernel: [   30.950220] ieee80211 phy1: I
iwl3945_disable_events   in SRAM at 0x8022c8, size 47 u32s
Jan 26 22:22:24 rainbow kernel: [   30.957059] ieee80211 phy1: U
iwl3945_alive_start Runtime Alive received.
Jan 26 22:22:24 rainbow kernel: [   30.957070] ieee80211 phy1: U
iwl3945_verify_inst_sparse ucode inst image size is 900
Jan 26 22:22:24 rainbow kernel: [   30.957157] ieee80211 phy1: U
iwl3945_verify_inst_sparse ucode inst image size is 2672
Jan 26 22:22:24 rainbow kernel: [   30.957243] ieee80211 phy1: U
iwl3945_verify_inst_sparse ucode inst image size is 80684
Jan 26 22:22:24 rainbow kernel: [   30.965067] ieee80211 phy1: U
iwl3945_verify_ucode Runtime uCode is good in inst SRAM
Jan 26 22:22:24 rainbow kernel: [   30.965105] ieee80211 phy1: U
iwl3945_alive_start RFKILL status: 0x1
Jan 26 22:22:24 rainbow kernel: [   30.965131] ieee80211 phy1: U
iwl3945_update_power_cmd Flags value = 0x00000008
Jan 26 22:22:24 rainbow kernel: [   30.965138] ieee80211 phy1: U
iwl3945_update_power_cmd Tx timeout = 0
Jan 26 22:22:24 rainbow kernel: [   30.965145] ieee80211 phy1: U
iwl3945_update_power_cmd Rx timeout = 0
Jan 26 22:22:24 rainbow kernel: [   30.965152] ieee80211 phy1: U
iwl3945_update_power_cmd Sleep interval vector = { 0 , 0 , 0 , 0 , 0 }
Jan 26 22:22:24 rainbow kernel: [   30.965168] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command POWER_TABLE_CMD (#77), seq: 0x0400,
36 bytes at 0[0]:4
Jan 26 22:22:24 rainbow kernel: [   30.965253] ieee80211 phy1: I
iwl3945_rx_handle r 3 i 2 No handler needed for POWER_TABLE_CMD, 0x77
Jan 26 22:22:24 rainbow kernel: [   30.968070] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_BT_CONFIG (#9b), seq: 0x0401,
16 bytes at 1[1]:4
Jan 26 22:22:24 rainbow kernel: [   30.968181] ieee80211 phy1: I
iwl3945_rx_handle r 4 i 3 No handler needed for REPLY_BT_CONFIG, 0x9b
Jan 26 22:22:24 rainbow kernel: [   30.968215] ieee80211 phy1: U
iwl3945_commit_rxon Sending RXON
Jan 26 22:22:24 rainbow kernel: [   30.968217] * without RXON_FILTER_ASSOC_MSK
Jan 26 22:22:24 rainbow kernel: [   30.968219] * channel = 1
Jan 26 22:22:24 rainbow kernel: [   30.968220] * bssid = 00:00:00:00:00:00
Jan 26 22:22:24 rainbow kernel: [   30.968238] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x0402, 48
bytes at 2[2]:4
Jan 26 22:22:24 rainbow kernel: [   30.969562] ieee80211 phy1: I
iwl3945_rx_handle r 5 i 4 No handler needed for REPLY_RXON, 0x10
Jan 26 22:22:24 rainbow kernel: [   30.970747] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 187 dsp  99 rate code 0x0d
Jan 26 22:22:24 rainbow kernel: [   30.970758] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 187 dsp  99 rate code 0x0f
Jan 26 22:22:24 rainbow kernel: [   30.970766] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 187 dsp  99 rate code 0x05
Jan 26 22:22:24 rainbow kernel: [   30.970774] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 187 dsp  99 rate code 0x07
Jan 26 22:22:24 rainbow kernel: [   30.970783] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 187 dsp  99 rate code 0x09
Jan 26 22:22:24 rainbow kernel: [   30.970791] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 187 dsp  99 rate code 0x0b
Jan 26 22:22:24 rainbow kernel: [   30.970799] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 187 dsp  99 rate code 0x01
Jan 26 22:22:24 rainbow kernel: [   30.970808] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 187 dsp  99 rate code 0x03
Jan 26 22:22:24 rainbow kernel: [   30.970816] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 179 dsp 107 rate code 0x0a
Jan 26 22:22:24 rainbow kernel: [   30.970824] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 179 dsp 107 rate code 0x14
Jan 26 22:22:24 rainbow kernel: [   30.970833] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 179 dsp 107 rate code 0x37
Jan 26 22:22:24 rainbow kernel: [   30.970842] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 179 dsp 107 rate code 0x6e
Jan 26 22:22:24 rainbow kernel: [   30.970853] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq:
0x0403, 56 bytes at 3[3]:4
Jan 26 22:22:24 rainbow kernel: [   30.971211] ieee80211 phy1: I
iwl3945_rx_handle r = 7, i = 5, REPLY_3945_RX, 0x1b
Jan 26 22:22:24 rainbow kernel: [   30.971223] ieee80211 phy1: I
iwl3945_pass_packet_to_mac80211 Dropping packet while interface is not
open.
Jan 26 22:22:24 rainbow kernel: [   30.971245] ieee80211 phy1: I
iwl3945_rx_handle r 7 i 6 No handler needed for
REPLY_TX_PWR_TABLE_CMD, 0x97
Jan 26 22:22:24 rainbow kernel: [   30.971279] ieee80211 phy1: U
iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
Jan 26 22:22:24 rainbow kernel: [   30.971292] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0404, 68
bytes at 4[4]:4
Jan 26 22:22:24 rainbow kernel: [   30.971368] ieee80211 phy1: I
iwl3945_rx_handle r = 8, i = 7, REPLY_ADD_STA, 0x18
Jan 26 22:22:24 rainbow kernel: [   30.971427] ieee80211 phy1: U
iwl_sta_ucode_activate Added STA to Ucode: 00:00:00:00:00:00
Jan 26 22:22:24 rainbow kernel: [   30.971437] ieee80211 phy1: U
iwl_send_add_sta REPLY_ADD_STA PASSED
Jan 26 22:22:24 rainbow kernel: [   30.971454] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0405,
56 bytes at 5[5]:4
Jan 26 22:22:24 rainbow kernel: [   30.971526] ieee80211 phy1: I
iwl3945_rx_handle r 9 i 8 No handler needed for REPLY_RATE_SCALE, 0x47
Jan 26 22:22:24 rainbow kernel: [   30.971584] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0406,
56 bytes at 6[6]:4
Jan 26 22:22:24 rainbow kernel: [   30.971694] ieee80211 phy1: I
iwl3945_rx_handle r 10 i 9 No handler needed for REPLY_RATE_SCALE,
0x47
Jan 26 22:22:24 rainbow kernel: [   30.971734] ieee80211 phy1: U
iwl3945_hw_reg_txpower_get_temperature Temperature: 62
Jan 26 22:22:24 rainbow kernel: [   30.971742] ieee80211 phy1: U
is_temp_calib_needed Getting cooler, delta -198,
Jan 26 22:22:24 rainbow kernel: [   30.971749] ieee80211 phy1: U
is_temp_calib_needed Timed thermal calib needed
Jan 26 22:22:24 rainbow kernel: [   30.971770] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 235 dsp 109 rate code 0x0d
Jan 26 22:22:24 rainbow kernel: [   30.971778] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 235 dsp 109 rate code 0x0f
Jan 26 22:22:24 rainbow kernel: [   30.971786] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 235 dsp 109 rate code 0x05
Jan 26 22:22:24 rainbow kernel: [   30.971794] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 235 dsp 109 rate code 0x07
Jan 26 22:22:24 rainbow kernel: [   30.971801] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 235 dsp 109 rate code 0x09
Jan 26 22:22:24 rainbow kernel: [   30.971809] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 235 dsp 109 rate code 0x0b
Jan 26 22:22:24 rainbow kernel: [   30.971817] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 235 dsp 109 rate code 0x01
Jan 26 22:22:24 rainbow kernel: [   30.971825] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 235 dsp 109 rate code 0x03
Jan 26 22:22:24 rainbow kernel: [   30.971833] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 171 dsp  98 rate code 0x0a
Jan 26 22:22:24 rainbow kernel: [   30.971842] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 171 dsp  98 rate code 0x14
Jan 26 22:22:24 rainbow kernel: [   30.971850] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 171 dsp  98 rate code 0x37
Jan 26 22:22:24 rainbow kernel: [   30.971858] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 171 dsp  98 rate code 0x6e
Jan 26 22:22:24 rainbow kernel: [   30.971870] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq:
0x0407, 56 bytes at 7[7]:4
Jan 26 22:22:24 rainbow kernel: [   30.972001] ieee80211 phy1: I
iwl3945_rx_handle r 11 i 10 No handler needed for
REPLY_TX_PWR_TABLE_CMD, 0x97
Jan 26 22:22:24 rainbow kernel: [   30.976327] ieee80211 phy1: I
iwl3945_rx_handle r = 12, i = 11, REPLY_3945_RX, 0x1b
Jan 26 22:22:24 rainbow kernel: [   30.976339] ieee80211 phy1: I
iwl3945_pass_packet_to_mac80211 Dropping packet while interface is not
open.
Jan 26 22:22:24 rainbow kernel: [   30.978064] Registered led device:
iwl-phy1:radio
Jan 26 22:22:24 rainbow kernel: [   30.978074] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0408, 12
bytes at 8[8]:4
Jan 26 22:22:24 rainbow kernel: [   30.978121] Registered led device:
iwl-phy1:assoc
Jan 26 22:22:24 rainbow kernel: [   30.978157] ieee80211 phy1: I
iwl3945_rx_handle r 13 i 12 No handler needed for REPLY_LEDS_CMD, 0x48
Jan 26 22:22:24 rainbow kernel: [   30.978163] Registered led device:
iwl-phy1:RX
Jan 26 22:22:24 rainbow kernel: [   30.978199] Registered led device:
iwl-phy1:TX
Jan 26 22:22:24 rainbow kernel: [   30.978204] ieee80211 phy1: U
iwl3945_alive_start ALIVE processing complete.
Jan 26 22:22:24 rainbow kernel: [   30.978333] ieee80211 phy1: U
iwl3945_mac_start leave
Jan 26 22:22:24 rainbow kernel: [   30.978348] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0409, 12
bytes at 9[9]:4
Jan 26 22:22:24 rainbow kernel: [   30.978360] ieee80211 phy1: U
iwl3945_mac_add_interface enter: type 2
Jan 26 22:22:24 rainbow kernel: [   30.978367] ieee80211 phy1: U
iwl3945_mac_add_interface Set: 00:1f:3c:20:a1:6e
Jan 26 22:22:24 rainbow kernel: [   30.978380] ieee80211 phy1: U
iwl3945_commit_rxon Sending RXON
Jan 26 22:22:24 rainbow kernel: [   30.978382] * without RXON_FILTER_ASSOC_MSK
Jan 26 22:22:24 rainbow kernel: [   30.978384] * channel = 1
Jan 26 22:22:24 rainbow kernel: [   30.978385] * bssid = 00:00:00:00:00:00
Jan 26 22:22:24 rainbow kernel: [   30.978444] ieee80211 phy1: I
iwl3945_rx_handle r 14 i 13 No handler needed for REPLY_LEDS_CMD, 0x48
Jan 26 22:22:24 rainbow kernel: [   30.978466] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x040A, 48
bytes at 10[10]:4
Jan 26 22:22:24 rainbow kernel: [   30.978704] ieee80211 phy1: I
iwl3945_rx_handle r 15 i 14 No handler needed for REPLY_RXON, 0x10
Jan 26 22:22:24 rainbow kernel: [   30.978735] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 235 dsp 109 rate code 0x0d
Jan 26 22:22:24 rainbow kernel: [   30.978744] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 235 dsp 109 rate code 0x0f
Jan 26 22:22:24 rainbow kernel: [   30.978752] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 235 dsp 109 rate code 0x05
Jan 26 22:22:24 rainbow kernel: [   30.978760] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 235 dsp 109 rate code 0x07
Jan 26 22:22:24 rainbow kernel: [   30.978767] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 235 dsp 109 rate code 0x09
Jan 26 22:22:24 rainbow kernel: [   30.978775] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 235 dsp 109 rate code 0x0b
Jan 26 22:22:24 rainbow kernel: [   30.978783] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 235 dsp 109 rate code 0x01
Jan 26 22:22:24 rainbow kernel: [   30.978791] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 235 dsp 109 rate code 0x03
Jan 26 22:22:24 rainbow kernel: [   30.978799] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 171 dsp  98 rate code 0x0a
Jan 26 22:22:24 rainbow kernel: [   30.978808] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 171 dsp  98 rate code 0x14
Jan 26 22:22:24 rainbow kernel: [   30.978816] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 171 dsp  98 rate code 0x37
Jan 26 22:22:24 rainbow kernel: [   30.978825] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 171 dsp  98 rate code 0x6e
Jan 26 22:22:24 rainbow kernel: [   30.978836] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq:
0x040B, 56 bytes at 11[11]:4
Jan 26 22:22:24 rainbow kernel: [   30.978967] ieee80211 phy1: I
iwl3945_rx_handle r 16 i 15 No handler needed for
REPLY_TX_PWR_TABLE_CMD, 0x97
Jan 26 22:22:24 rainbow kernel: [   30.978987] ieee80211 phy1: U
iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
Jan 26 22:22:24 rainbow kernel: [   30.979000] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x040C, 68
bytes at 12[12]:4
Jan 26 22:22:24 rainbow kernel: [   30.979111] ieee80211 phy1: I
iwl3945_rx_handle r = 17, i = 16, REPLY_ADD_STA, 0x18
Jan 26 22:22:24 rainbow kernel: [   30.979127] ieee80211 phy1: U
iwl_sta_ucode_activate Added STA to Ucode: 00:00:00:00:00:00
Jan 26 22:22:24 rainbow kernel: [   30.979137] ieee80211 phy1: U
iwl_send_add_sta REPLY_ADD_STA PASSED
Jan 26 22:22:24 rainbow kernel: [   30.979151] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x040D,
56 bytes at 13[13]:4
Jan 26 22:22:24 rainbow kernel: [   30.979228] ieee80211 phy1: I
iwl3945_rx_handle r 18 i 17 No handler needed for REPLY_RATE_SCALE,
0x47
Jan 26 22:22:24 rainbow kernel: [   30.979263] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x040E,
56 bytes at 14[14]:4
Jan 26 22:22:24 rainbow kernel: [   30.979341] ieee80211 phy1: I
iwl3945_rx_handle r 19 i 18 No handler needed for REPLY_RATE_SCALE,
0x47
Jan 26 22:22:24 rainbow kernel: [   30.979369] ieee80211 phy1: U
iwl3945_mac_add_interface leave
Jan 26 22:22:24 rainbow kernel: [   30.979378] ieee80211 phy1: U
iwl3945_bss_info_changed changes = 0xE
Jan 26 22:22:24 rainbow kernel: [   30.979385] ieee80211 phy1: U
iwl3945_bss_info_changed ERP_PREAMBLE 0
Jan 26 22:22:24 rainbow kernel: [   30.979392] ieee80211 phy1: U
iwl3945_bss_info_changed ERP_CTS 0
Jan 26 22:22:24 rainbow kernel: [   30.992033] ieee80211 phy1: I
iwl3945_configure_filter Enter: changed: 0x0, total: 0x80000000
Jan 26 22:22:24 rainbow kernel: [   30.993131] ieee80211 phy1: U
iwl3945_mac_config enter to channel 1
Jan 26 22:22:24 rainbow kernel: [   30.993145] ieee80211 phy1: U
iwl3945_commit_rxon Sending RXON
Jan 26 22:22:24 rainbow kernel: [   30.993147] * without RXON_FILTER_ASSOC_MSK
Jan 26 22:22:24 rainbow kernel: [   30.993149] * channel = 1
Jan 26 22:22:24 rainbow kernel: [   30.993150] * bssid = 00:00:00:00:00:00
Jan 26 22:22:24 rainbow kernel: [   30.993169] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x040F, 48
bytes at 15[15]:4
Jan 26 22:22:24 rainbow kernel: [   30.993388] ieee80211 phy1: I
iwl3945_rx_handle r 20 i 19 No handler needed for REPLY_RXON, 0x10
Jan 26 22:22:24 rainbow kernel: [   30.993426] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 235 dsp 109 rate code 0x0d
Jan 26 22:22:24 rainbow kernel: [   30.993437] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 235 dsp 109 rate code 0x0f
Jan 26 22:22:24 rainbow kernel: [   30.993446] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 235 dsp 109 rate code 0x05
Jan 26 22:22:24 rainbow kernel: [   30.993454] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 235 dsp 109 rate code 0x07
Jan 26 22:22:24 rainbow kernel: [   30.993463] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 235 dsp 109 rate code 0x09
Jan 26 22:22:24 rainbow kernel: [   30.993471] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 235 dsp 109 rate code 0x0b
Jan 26 22:22:24 rainbow kernel: [   30.993481] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 235 dsp 109 rate code 0x01
Jan 26 22:22:24 rainbow kernel: [   30.993489] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 235 dsp 109 rate code 0x03
Jan 26 22:22:24 rainbow kernel: [   30.993497] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 171 dsp  98 rate code 0x0a
Jan 26 22:22:24 rainbow kernel: [   30.993508] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 171 dsp  98 rate code 0x14
Jan 26 22:22:24 rainbow kernel: [   30.993517] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 171 dsp  98 rate code 0x37
Jan 26 22:22:24 rainbow kernel: [   30.993525] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 171 dsp  98 rate code 0x6e
Jan 26 22:22:24 rainbow kernel: [   30.993538] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq:
0x0410, 56 bytes at 16[16]:4
Jan 26 22:22:24 rainbow kernel: [   30.993671] ieee80211 phy1: I
iwl3945_rx_handle r 21 i 20 No handler needed for
REPLY_TX_PWR_TABLE_CMD, 0x97
Jan 26 22:22:24 rainbow kernel: [   30.993702] ieee80211 phy1: U
iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
Jan 26 22:22:24 rainbow kernel: [   30.993714] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0411, 68
bytes at 17[17]:4
Jan 26 22:22:24 rainbow kernel: [   30.993826] ieee80211 phy1: I
iwl3945_rx_handle r = 22, i = 21, REPLY_ADD_STA, 0x18
Jan 26 22:22:24 rainbow kernel: [   30.993854] ieee80211 phy1: U
iwl_sta_ucode_activate Added STA to Ucode: 00:00:00:00:00:00
Jan 26 22:22:24 rainbow kernel: [   30.993864] ieee80211 phy1: U
iwl_send_add_sta REPLY_ADD_STA PASSED
Jan 26 22:22:24 rainbow kernel: [   30.993877] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0412,
56 bytes at 18[18]:4
Jan 26 22:22:24 rainbow kernel: [   30.993955] ieee80211 phy1: I
iwl3945_rx_handle r 23 i 22 No handler needed for REPLY_RATE_SCALE,
0x47
Jan 26 22:22:24 rainbow kernel: [   30.994069] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0413,
56 bytes at 19[19]:4
Jan 26 22:22:24 rainbow kernel: [   30.994146] ieee80211 phy1: I
iwl3945_rx_handle r 24 i 23 No handler needed for REPLY_RATE_SCALE,
0x47
Jan 26 22:22:24 rainbow kernel: [   30.994198] ieee80211 phy1: U
iwl3945_mac_config leave
Jan 26 22:22:24 rainbow kernel: [   30.994207] ieee80211 phy1: U
iwl3945_mac_conf_tx enter
Jan 26 22:22:24 rainbow kernel: [   30.994225] ieee80211 phy1: U
iwl3945_mac_conf_tx leave
Jan 26 22:22:24 rainbow kernel: [   30.994232] ieee80211 phy1: U
iwl3945_mac_conf_tx enter
Jan 26 22:22:24 rainbow kernel: [   30.994240] ieee80211 phy1: U
iwl3945_mac_conf_tx leave
Jan 26 22:22:24 rainbow kernel: [   30.994245] ieee80211 phy1: U
iwl3945_mac_conf_tx enter
Jan 26 22:22:24 rainbow kernel: [   30.994253] ieee80211 phy1: U
iwl3945_mac_conf_tx leave
Jan 26 22:22:24 rainbow kernel: [   30.994259] ieee80211 phy1: U
iwl3945_mac_conf_tx enter
Jan 26 22:22:24 rainbow kernel: [   30.994266] ieee80211 phy1: U
iwl3945_mac_conf_tx leave
Jan 26 22:22:24 rainbow kernel: [   30.994283] ieee80211 phy1: I
iwl3945_configure_filter Enter: changed: 0x0, total: 0x80000000
Jan 26 22:22:24 rainbow kernel: [   30.994314] ieee80211 phy1: I
iwl3945_configure_filter Enter: changed: 0x0, total: 0x80000000
Jan 26 22:22:24 rainbow kernel: [   30.995326] ADDRCONF(NETDEV_UP):
wlan0: link is not ready
Jan 26 22:22:24 rainbow kernel: [   30.995333] ieee80211 phy1: I
iwl3945_configure_filter Enter: changed: 0x0, total: 0x80000000
Jan 26 22:22:24 rainbow kernel: [   31.002016] ieee80211 phy1: I
iwl3945_rx_handle r = 25, i = 24, REPLY_3945_RX, 0x1b
Jan 26 22:22:24 rainbow kernel: [   31.007521] ieee80211 phy1: U
iwl3945_mac_hw_scan enter
Jan 26 22:22:24 rainbow kernel: [   31.007536] ieee80211 phy1: U
iwl3945_scan_initiate Starting scan...
Jan 26 22:22:24 rainbow kernel: [   31.007551] ieee80211 phy1: U
iwl3945_mac_hw_scan leave
Jan 26 22:22:24 rainbow kernel: [   31.007633] ieee80211 phy1: U
iwl3945_bg_request_scan Kicking off one indirect scan.
Jan 26 22:22:24 rainbow kernel: [   31.007648] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 1 [ACTIVE 39]
Jan 26 22:22:24 rainbow kernel: [   31.007659] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 2 [ACTIVE 39]
Jan 26 22:22:24 rainbow kernel: [   31.007667] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 3 [ACTIVE 39]
Jan 26 22:22:24 rainbow kernel: [   31.007675] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 4 [ACTIVE 39]
Jan 26 22:22:24 rainbow kernel: [   31.007686] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 5 [ACTIVE 39]
Jan 26 22:22:24 rainbow kernel: [   31.007693] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 6 [ACTIVE 39]
Jan 26 22:22:24 rainbow kernel: [   31.007701] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 7 [ACTIVE 39]
Jan 26 22:22:24 rainbow kernel: [   31.007710] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 8 [ACTIVE 39]
Jan 26 22:22:24 rainbow kernel: [   31.007718] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 9 [ACTIVE 39]
Jan 26 22:22:24 rainbow kernel: [   31.007726] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 10 [ACTIVE 39]
Jan 26 22:22:24 rainbow kernel: [   31.007737] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 11 [ACTIVE 39]
Jan 26 22:22:24 rainbow kernel: [   31.007744] ieee80211 phy1: U
iwl3945_get_channels_for_scan total channels to scan 11
Jan 26 22:22:24 rainbow kernel: [   31.007765] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x4414,
350 bytes at 20[32]:4
Jan 26 22:22:24 rainbow kernel: [   31.007903] ieee80211 phy1: I
iwl3945_rx_handle r = 26, i = 25, REPLY_SCAN_CMD, 0x80
Jan 26 22:22:24 rainbow kernel: [   31.008961] ieee80211 phy1: I
iwl3945_rx_handle r = 28, i = 26, STATISTICS_NOTIFICATION, 0x9d
Jan 26 22:22:24 rainbow kernel: [   31.008978] ieee80211 phy1: I
iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0415, 12
bytes at 21[21]:4
Jan 26 22:22:24 rainbow kernel: [   31.009001] ieee80211 phy1: I
iwl3945_rx_handle r = 28, i = 27, SCAN_START_NOTIFICATION, 0x82
Jan 26 22:22:24 rainbow kernel: [   31.009013] ieee80211 phy1: I
iwl3945_rx_scan_start_notif Scan start: 1 [802.11bg] (TSF:
0x00000000:00003D1B) - 1 (beacon timer 86757)
Jan 26 22:22:24 rainbow kernel: [   31.009579] ieee80211 phy1: I
iwl3945_rx_handle r 29 i 28 No handler needed for REPLY_LEDS_CMD, 0x48
Jan 26 22:22:24 rainbow kernel: [   31.010921] ieee80211 phy1: I
iwl3945_rx_handle r = 30, i = 29, REPLY_3945_RX, 0x1b
Jan 26 22:22:24 rainbow kernel: [   31.013060] ieee80211 phy1: I
iwl3945_rx_handle r = 31, i = 30, REPLY_3945_RX, 0x1b
Jan 26 22:22:24 rainbow kernel: [   31.015153] ieee80211 phy1: I
iwl3945_rx_handle r = 32, i = 31, REPLY_3945_RX, 0x1b
Jan 26 22:22:24 rainbow kernel: [   31.016822] ieee80211 phy1: I
iwl3945_rx_handle r = 33, i = 32, REPLY_3945_RX, 0x1b
Jan 26 22:22:24 rainbow kernel: [   31.020125] ieee80211 phy1: I
iwl3945_rx_handle r = 34, i = 33, REPLY_3945_RX, 0x1b
Jan 26 22:22:24 rainbow kernel: [   31.048919] ieee80211 phy1: I
iwl3945_rx_handle r = 35, i = 34, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 22:22:24 rainbow kernel: [   31.048939] ieee80211 phy1: I
iwl3945_rx_scan_results_notif Scan ch.res: 1 [802.11bg] (TSF:
0x00000000:0000D925) - 4 elapsed=39946 usec (-268952ms since last)
Jan 26 22:22:24 rainbow kernel: [   31.049976] ieee80211 phy1: I
iwl3945_rx_handle r = 37, i = 35, STATISTICS_NOTIFICATION, 0x9d
Jan 26 22:22:24 rainbow kernel: [   31.050000] ieee80211 phy1: I
iwl3945_rx_handle r = 37, i = 36, SCAN_START_NOTIFICATION, 0x82
Jan 26 22:22:24 rainbow kernel: [   31.050011] ieee80211 phy1: I
iwl3945_rx_scan_start_notif Scan start: 2 [802.11bg] (TSF:
0x00000000:0000DD53) - 1 (beacon timer 45741)
Jan 26 22:22:24 rainbow kernel: [   31.053361] ieee80211 phy1: I
iwl3945_rx_handle r = 38, i = 37, REPLY_3945_RX, 0x1b
Jan 26 22:22:24 rainbow kernel: [   31.062289] ieee80211 phy1: I
iwl3945_rx_handle r = 39, i = 38, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 22:22:24 rainbow kernel: [   31.062306] ieee80211 phy1: I
iwl3945_rx_scan_results_notif Scan ch.res: 2 [802.11bg] (TSF:
0x00000000:00010D64) - 1 elapsed=12305 usec (12ms since last)
Jan 26 22:22:24 rainbow kernel: [   31.063354] ieee80211 phy1: I
iwl3945_rx_handle r = 41, i = 39, STATISTICS_NOTIFICATION, 0x9d
Jan 26 22:22:24 rainbow kernel: [   31.063382] ieee80211 phy1: I
iwl3945_rx_handle r = 41, i = 40, SCAN_START_NOTIFICATION, 0x82
Jan 26 22:22:24 rainbow kernel: [   31.063393] ieee80211 phy1: I
iwl3945_rx_scan_start_notif Scan start: 3 [802.11bg] (TSF:
0x00000000:00011192) - 1 (beacon timer 32366)
Jan 26 22:22:24 rainbow kernel: [   31.065455] ieee80211 phy1: I
iwl3945_rx_handle r = 42, i = 41, REPLY_3945_RX, 0x1b
Jan 26 22:22:24 rainbow kernel: [   31.069055] ieee80211 phy1: I
iwl3945_rx_handle r = 43, i = 42, REPLY_3945_RX, 0x1b
Jan 26 22:22:24 rainbow kernel: [   31.070664] ieee80211 phy1: I
iwl3945_rx_handle r = 44, i = 43, REPLY_3945_RX, 0x1b
Jan 26 22:22:24 rainbow kernel: [   31.103313] ieee80211 phy1: I
iwl3945_rx_handle r = 45, i = 44, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 22:22:24 rainbow kernel: [   31.103335] ieee80211 phy1: I
iwl3945_rx_scan_results_notif Scan ch.res: 3 [802.11bg] (TSF:
0x00000000:0001ADA2) - 3 elapsed=39952 usec (40ms since last)
Jan 26 22:22:24 rainbow kernel: [   31.104376] ieee80211 phy1: I
iwl3945_rx_handle r = 47, i = 45, STATISTICS_NOTIFICATION, 0x9d
Jan 26 22:22:24 rainbow kernel: [   31.104399] ieee80211 phy1: I
iwl3945_rx_handle r = 47, i = 46, SCAN_START_NOTIFICATION, 0x82
Jan 26 22:22:24 rainbow kernel: [   31.104410] ieee80211 phy1: I
iwl3945_rx_scan_start_notif Scan start: 4 [802.11bg] (TSF:
0x00000000:0001B1D4) - 1 (beacon timer 16870956)
Jan 26 22:22:24 rainbow kernel: [   31.106480] ieee80211 phy1: I
iwl3945_rx_handle r = 48, i = 47, REPLY_3945_RX, 0x1b
Jan 26 22:22:24 rainbow kernel: [   31.106911] NET: Registered
protocol family 17
Jan 26 22:22:24 rainbow kernel: [   31.107749] ieee80211 phy1: I
iwl3945_rx_handle r = 49, i = 48, REPLY_3945_RX, 0x1b
Jan 26 22:22:24 rainbow kernel: [   31.109900] ieee80211 phy1: I
iwl3945_rx_handle r = 50, i = 49, REPLY_3945_RX, 0x1b
Jan 26 22:22:24 rainbow kernel: [   31.112328] ieee80211 phy1: I
iwl3945_rx_handle r = 51, i = 50, REPLY_3945_RX, 0x1b
Jan 26 22:22:24 rainbow kernel: [   31.118580] ieee80211 phy1: I
iwl3945_rx_handle r = 52, i = 51, REPLY_3945_RX, 0x1b
Jan 26 22:22:24 rainbow kernel: [   31.125753] ieee80211 phy1: I
iwl3945_rx_handle r = 53, i = 52, REPLY_3945_RX, 0x1b
Jan 26 22:22:24 rainbow kernel: [   31.130638] ieee80211 phy1: I
iwl3945_rx_handle r = 54, i = 53, REPLY_3945_RX, 0x1b
Jan 26 22:22:24 rainbow kernel: [   31.144324] ieee80211 phy1: I
iwl3945_rx_handle r = 55, i = 54, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 22:22:24 rainbow kernel: [   31.144329] ieee80211 phy1: I
iwl3945_rx_scan_results_notif Scan ch.res: 4 [802.11bg] (TSF:
0x00000000:00024DE1) - 5 elapsed=39949 usec (44ms since last)
Jan 26 22:22:24 rainbow kernel: [   31.145317] ieee80211 phy1: I
iwl3945_rx_handle r = 57, i = 55, STATISTICS_NOTIFICATION, 0x9d
Jan 26 22:22:24 rainbow kernel: [   31.145328] ieee80211 phy1: I
iwl3945_rx_handle r = 57, i = 56, SCAN_START_NOTIFICATION, 0x82
Jan 26 22:22:24 rainbow kernel: [   31.145333] ieee80211 phy1: I
iwl3945_rx_scan_start_notif Scan start: 5 [802.11bg] (TSF:
0x00000000:000251A8) - 1 (beacon timer 16830040)
Jan 26 22:22:24 rainbow kernel: [   31.147383] ieee80211 phy1: I
iwl3945_rx_handle r = 58, i = 57, REPLY_3945_RX, 0x1b
Jan 26 22:22:24 rainbow kernel: [   31.159254] ieee80211 phy1: I
iwl3945_rx_handle r = 59, i = 58, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 22:22:24 rainbow kernel: [   31.159259] ieee80211 phy1: I
iwl3945_rx_scan_results_notif Scan ch.res: 5 [802.11bg] (TSF:
0x00000000:00028817) - 1 elapsed=13935 usec (12ms since last)
Jan 26 22:22:24 rainbow kernel: [   31.160189] ieee80211 phy1: I
iwl3945_rx_handle r = 61, i = 59, STATISTICS_NOTIFICATION, 0x9d
Jan 26 22:22:24 rainbow kernel: [   31.160198] ieee80211 phy1: I
iwl3945_rx_handle r = 61, i = 60, SCAN_START_NOTIFICATION, 0x82
Jan 26 22:22:24 rainbow kernel: [   31.160202] ieee80211 phy1: I
iwl3945_rx_scan_start_notif Scan start: 6 [802.11bg] (TSF:
0x00000000:00028BDD) - 1 (beacon timer 16815139)
Jan 26 22:22:24 rainbow kernel: [   31.162504] ieee80211 phy1: I
iwl3945_rx_handle r = 62, i = 61, REPLY_3945_RX, 0x1b
Jan 26 22:22:24 rainbow kernel: [   31.165318] ieee80211 phy1: I
iwl3945_rx_handle r = 63, i = 62, REPLY_3945_RX, 0x1b
Jan 26 22:22:24 rainbow kernel: [   31.166586] ieee80211 phy1: I
iwl3945_rx_handle r = 64, i = 63, REPLY_3945_RX, 0x1b
Jan 26 22:22:24 rainbow kernel: [   31.168978] ieee80211 phy1: I
iwl3945_rx_handle r = 65, i = 64, REPLY_3945_RX, 0x1b
Jan 26 22:22:24 rainbow kernel: [   31.170133] ieee80211 phy1: I
iwl3945_rx_handle r = 66, i = 65, REPLY_3945_RX, 0x1b
Jan 26 22:22:24 rainbow kernel: [   31.171391] ieee80211 phy1: I
iwl3945_rx_handle r = 67, i = 66, REPLY_3945_RX, 0x1b
Jan 26 22:22:24 rainbow kernel: [   31.186641] ieee80211 phy1: I
iwl3945_rx_handle r = 68, i = 67, REPLY_3945_RX, 0x1b
Jan 26 22:22:24 rainbow kernel: [   31.196441] ieee80211 phy1: I
iwl3945_rx_handle r = 69, i = 68, REPLY_3945_RX, 0x1b
Jan 26 22:22:24 rainbow kernel: [   31.198166] ieee80211 phy1: I
iwl3945_rx_handle r = 70, i = 69, REPLY_3945_RX, 0x1b
Jan 26 22:22:24 rainbow kernel: [   31.199719] ieee80211 phy1: I
iwl3945_rx_handle r = 71, i = 70, REPLY_3945_RX, 0x1b
Jan 26 22:22:24 rainbow kernel: [   31.200155] ieee80211 phy1: I
iwl3945_rx_handle r = 72, i = 71, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 22:22:24 rainbow kernel: [   31.200159] ieee80211 phy1: I
iwl3945_rx_scan_results_notif Scan ch.res: 6 [802.11bg] (TSF:
0x00000000:000327EB) - 11 elapsed=39950 usec (44ms since last)
Jan 26 22:22:24 rainbow kernel: [   31.201214] ieee80211 phy1: I
iwl3945_rx_handle r = 74, i = 72, STATISTICS_NOTIFICATION, 0x9d
Jan 26 22:22:24 rainbow kernel: [   31.201223] ieee80211 phy1: I
iwl3945_rx_handle r = 74, i = 73, SCAN_START_NOTIFICATION, 0x82
Jan 26 22:22:24 rainbow kernel: [   31.201229] ieee80211 phy1: I
iwl3945_rx_scan_start_notif Scan start: 7 [802.11bg] (TSF:
0x00000000:00032BFB) - 1 (beacon timer 33653765)
Jan 26 22:22:24 rainbow kernel: [   31.203313] ieee80211 phy1: I
iwl3945_rx_handle r = 75, i = 74, REPLY_3945_RX, 0x1b
Jan 26 22:22:24 rainbow kernel: [   31.205530] ieee80211 phy1: I
iwl3945_rx_handle r = 76, i = 75, REPLY_3945_RX, 0x1b
Jan 26 22:22:24 rainbow kernel: [   31.207826] ieee80211 phy1: I
iwl3945_rx_handle r = 77, i = 76, REPLY_3945_RX, 0x1b
Jan 26 22:22:24 rainbow kernel: [   31.210116] ieee80211 phy1: I
iwl3945_rx_handle r = 78, i = 77, REPLY_3945_RX, 0x1b
Jan 26 22:22:24 rainbow kernel: [   31.211675] ieee80211 phy1: I
iwl3945_rx_handle r = 79, i = 78, REPLY_3945_RX, 0x1b
Jan 26 22:22:24 rainbow kernel: [   31.233474] ieee80211 phy1: I
iwl3945_rx_handle r = 80, i = 79, REPLY_3945_RX, 0x1b
Jan 26 22:22:24 rainbow kernel: [   31.241186] ieee80211 phy1: I
iwl3945_rx_handle r = 81, i = 80, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 22:22:24 rainbow kernel: [   31.241191] ieee80211 phy1: I
iwl3945_rx_scan_results_notif Scan ch.res: 7 [802.11bg] (TSF:
0x00000000:0003C80B) - 10 elapsed=39952 usec (40ms since last)
Jan 26 22:22:24 rainbow kernel: [   31.242149] ieee80211 phy1: I
iwl3945_rx_handle r = 83, i = 81, STATISTICS_NOTIFICATION, 0x9d
Jan 26 22:22:24 rainbow kernel: [   31.242158] ieee80211 phy1: I
iwl3945_rx_handle r = 83, i = 82, SCAN_START_NOTIFICATION, 0x82
Jan 26 22:22:24 rainbow kernel: [   31.242162] ieee80211 phy1: I
iwl3945_rx_scan_start_notif Scan start: 8 [802.11bg] (TSF:
0x00000000:0003CBD2) - 1 (beacon timer 33612846)
Jan 26 22:22:24 rainbow kernel: [   31.244248] ieee80211 phy1: I
iwl3945_rx_handle r = 84, i = 83, REPLY_3945_RX, 0x1b
Jan 26 22:22:24 rainbow kernel: [   31.247386] ieee80211 phy1: I
iwl3945_rx_handle r = 85, i = 84, REPLY_3945_RX, 0x1b
Jan 26 22:22:24 rainbow kernel: [   31.282110] ieee80211 phy1: I
iwl3945_rx_handle r = 86, i = 85, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 22:22:24 rainbow kernel: [   31.282114] ieee80211 phy1: I
iwl3945_rx_scan_results_notif Scan ch.res: 8 [802.11bg] (TSF:
0x00000000:000467E5) - 2 elapsed=39955 usec (40ms since last)
Jan 26 22:22:24 rainbow kernel: [   31.283072] ieee80211 phy1: I
iwl3945_rx_handle r = 88, i = 86, STATISTICS_NOTIFICATION, 0x9d
Jan 26 22:22:24 rainbow kernel: [   31.283081] ieee80211 phy1: I
iwl3945_rx_handle r = 88, i = 87, SCAN_START_NOTIFICATION, 0x82
Jan 26 22:22:24 rainbow kernel: [   31.283084] ieee80211 phy1: I
iwl3945_rx_scan_start_notif Scan start: 9 [802.11bg] (TSF:
0x00000000:00046BAC) - 1 (beacon timer 33571924)
Jan 26 22:22:24 rainbow kernel: [   31.295753] ieee80211 phy1: I
iwl3945_rx_handle r = 89, i = 88, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 22:22:24 rainbow kernel: [   31.295758] ieee80211 phy1: I
iwl3945_rx_scan_results_notif Scan ch.res: 9 [802.11bg] (TSF:
0x00000000:00049D46) - 0 elapsed=12698 usec (12ms since last)
Jan 26 22:22:24 rainbow kernel: [   31.296699] ieee80211 phy1: I
iwl3945_rx_handle r = 91, i = 89, STATISTICS_NOTIFICATION, 0x9d
Jan 26 22:22:24 rainbow kernel: [   31.296724] ieee80211 phy1: I
iwl3945_rx_handle r = 91, i = 90, SCAN_START_NOTIFICATION, 0x82
Jan 26 22:22:24 rainbow kernel: [   31.296734] ieee80211 phy1: I
iwl3945_rx_scan_start_notif Scan start: 10 [802.11bg] (TSF:
0x00000000:0004A10F) - 1 (beacon timer 33558257)
Jan 26 22:22:24 rainbow kernel: [   31.303355] ieee80211 phy1: I
iwl3945_rx_handle r = 92, i = 91, REPLY_3945_RX, 0x1b
Jan 26 22:22:24 rainbow kernel: [   31.309140] ieee80211 phy1: I
iwl3945_rx_handle r = 93, i = 92, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 22:22:24 rainbow kernel: [   31.309153] ieee80211 phy1: I
iwl3945_rx_scan_results_notif Scan ch.res: 10 [802.11bg] (TSF:
0x00000000:0004D17C) - 1 elapsed=12397 usec (16ms since last)
Jan 26 22:22:24 rainbow kernel: [   31.310133] ieee80211 phy1: I
iwl3945_rx_handle r = 95, i = 93, STATISTICS_NOTIFICATION, 0x9d
Jan 26 22:22:24 rainbow kernel: [   31.310160] ieee80211 phy1: I
iwl3945_rx_handle r = 95, i = 94, SCAN_START_NOTIFICATION, 0x82
Jan 26 22:22:24 rainbow kernel: [   31.310171] ieee80211 phy1: I
iwl3945_rx_scan_start_notif Scan start: 11 [802.11bg] (TSF:
0x00000000:0004D54B) - 1 (beacon timer 50424501)
Jan 26 22:22:24 rainbow kernel: [   31.311851] ieee80211 phy1: I
iwl3945_rx_handle r = 96, i = 95, REPLY_3945_RX, 0x1b
Jan 26 22:22:24 rainbow kernel: [   31.314029] ieee80211 phy1: I
iwl3945_rx_handle r = 97, i = 96, REPLY_3945_RX, 0x1b
Jan 26 22:22:24 rainbow kernel: [   31.316161] ieee80211 phy1: I
iwl3945_rx_handle r = 98, i = 97, REPLY_3945_RX, 0x1b
Jan 26 22:22:24 rainbow kernel: [   31.323537] ieee80211 phy1: I
iwl3945_rx_handle r = 99, i = 98, REPLY_3945_RX, 0x1b
Jan 26 22:22:24 rainbow kernel: [   31.325893] ieee80211 phy1: I
iwl3945_rx_handle r = 100, i = 99, REPLY_3945_RX, 0x1b
Jan 26 22:22:24 rainbow kernel: [   31.329095] ieee80211 phy1: I
iwl3945_rx_handle r = 101, i = 100, REPLY_3945_RX, 0x1b
Jan 26 22:22:24 rainbow kernel: [   31.332843] ieee80211 phy1: I
iwl3945_rx_handle r = 102, i = 101, REPLY_3945_RX, 0x1b
Jan 26 22:22:24 rainbow kernel: [   31.350051] ieee80211 phy1: I
iwl3945_rx_handle r = 103, i = 102, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 22:22:24 rainbow kernel: [   31.350065] ieee80211 phy1: I
iwl3945_rx_scan_results_notif Scan ch.res: 11 [802.11bg] (TSF:
0x00000000:00057151) - 7 elapsed=39942 usec (40ms since last)
Jan 26 22:22:24 rainbow kernel: [   31.351123] ieee80211 phy1: I
iwl3945_rx_handle r = 104, i = 103, SCAN_COMPLETE_NOTIFICATION, 0x84
Jan 26 22:22:24 rainbow kernel: [   31.351133] ieee80211 phy1: I
iwl3945_rx_scan_complete_notif Scan complete: 11 channels (TSF
0x00057586:00000000) - 1
Jan 26 22:22:24 rainbow kernel: [   31.351143] ieee80211 phy1: I
iwl3945_rx_scan_complete_notif Scan pass on 2.4GHz took 344ms
Jan 26 22:22:24 rainbow kernel: [   31.351180] ieee80211 phy1: U
iwl3945_bg_request_scan Kicking off one indirect scan.
Jan 26 22:22:24 rainbow kernel: [   31.351194] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 36 [PASSIVE 110]
Jan 26 22:22:24 rainbow kernel: [   31.351202] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 40 [PASSIVE 110]
Jan 26 22:22:24 rainbow kernel: [   31.351210] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 44 [PASSIVE 110]
Jan 26 22:22:24 rainbow kernel: [   31.351217] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 48 [PASSIVE 110]
Jan 26 22:22:24 rainbow kernel: [   31.351225] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 52 [PASSIVE 110]
Jan 26 22:22:24 rainbow kernel: [   31.351233] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 56 [PASSIVE 110]
Jan 26 22:22:24 rainbow kernel: [   31.351241] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 60 [PASSIVE 110]
Jan 26 22:22:24 rainbow kernel: [   31.351249] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 64 [PASSIVE 110]
Jan 26 22:22:24 rainbow kernel: [   31.351257] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 149 [PASSIVE 110]
Jan 26 22:22:24 rainbow kernel: [   31.351265] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 153 [PASSIVE 110]
Jan 26 22:22:24 rainbow kernel: [   31.351274] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 157 [PASSIVE 110]
Jan 26 22:22:24 rainbow kernel: [   31.351282] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 161 [PASSIVE 110]
Jan 26 22:22:24 rainbow kernel: [   31.351290] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 165 [PASSIVE 110]
Jan 26 22:22:24 rainbow kernel: [   31.351298] ieee80211 phy1: U
iwl3945_get_channels_for_scan total channels to scan 13
Jan 26 22:22:24 rainbow kernel: [   31.351313] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x4416,
366 bytes at 22[32]:4
Jan 26 22:22:24 rainbow kernel: [   31.351513] ieee80211 phy1: I
iwl3945_rx_handle r = 105, i = 104, REPLY_SCAN_CMD, 0x80
Jan 26 22:22:24 rainbow kernel: [   31.352479] ieee80211 phy1: I
iwl3945_rx_handle r = 107, i = 105, STATISTICS_NOTIFICATION, 0x9d
Jan 26 22:22:24 rainbow kernel: [   31.352506] ieee80211 phy1: I
iwl3945_rx_handle r = 107, i = 106, SCAN_START_NOTIFICATION, 0x82
Jan 26 22:22:24 rainbow kernel: [   31.352519] ieee80211 phy1: I
iwl3945_rx_scan_start_notif Scan start: 36 [802.11a] (TSF:
0x00000000:00057ABB) - 1 (beacon timer 50382149)
Jan 26 22:22:24 rainbow kernel: [   31.465146] ieee80211 phy1: I
iwl3945_rx_handle r = 108, i = 107, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 22:22:24 rainbow kernel: [   31.465167] ieee80211 phy1: I
iwl3945_rx_scan_results_notif Scan ch.res: 36 [802.11a] (TSF:
0x00000000:000732C3) - 0 elapsed=112648 usec (116ms since last)
Jan 26 22:22:24 rainbow kernel: [   31.466056] ieee80211 phy1: I
iwl3945_rx_handle r = 110, i = 108, STATISTICS_NOTIFICATION, 0x9d
Jan 26 22:22:24 rainbow kernel: [   31.466079] ieee80211 phy1: I
iwl3945_rx_handle r = 110, i = 109, SCAN_START_NOTIFICATION, 0x82
Jan 26 22:22:24 rainbow kernel: [   31.466089] ieee80211 phy1: I
iwl3945_rx_scan_start_notif Scan start: 40 [802.11a] (TSF:
0x00000000:00073660) - 1 (beacon timer 67148192)
Jan 26 22:22:24 rainbow kernel: [   31.578720] ieee80211 phy1: I
iwl3945_rx_handle r = 111, i = 110, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 22:22:24 rainbow kernel: [   31.578740] ieee80211 phy1: I
iwl3945_rx_scan_results_notif Scan ch.res: 40 [802.11a] (TSF:
0x00000000:0008EE69) - 0 elapsed=112649 usec (112ms since last)
Jan 26 22:22:24 rainbow kernel: [   31.579608] ieee80211 phy1: I
iwl3945_rx_handle r = 113, i = 111, STATISTICS_NOTIFICATION, 0x9d
Jan 26 22:22:24 rainbow kernel: [   31.579635] ieee80211 phy1: I
iwl3945_rx_handle r = 113, i = 112, SCAN_START_NOTIFICATION, 0x82
Jan 26 22:22:24 rainbow kernel: [   31.579647] ieee80211 phy1: I
iwl3945_rx_scan_start_notif Scan start: 44 [802.11a] (TSF:
0x00000000:0008F205) - 1 (beacon timer 83914234)
Jan 26 22:22:25 rainbow kernel: [   31.692263] ieee80211 phy1: I
iwl3945_rx_handle r = 114, i = 113, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 22:22:25 rainbow kernel: [   31.692280] ieee80211 phy1: I
iwl3945_rx_scan_results_notif Scan ch.res: 44 [802.11a] (TSF:
0x00000000:000AAA0E) - 0 elapsed=112649 usec (116ms since last)
Jan 26 22:22:25 rainbow kernel: [   31.693183] ieee80211 phy1: I
iwl3945_rx_handle r = 116, i = 114, STATISTICS_NOTIFICATION, 0x9d
Jan 26 22:22:25 rainbow kernel: [   31.693210] ieee80211 phy1: I
iwl3945_rx_handle r = 116, i = 115, SCAN_START_NOTIFICATION, 0x82
Jan 26 22:22:25 rainbow kernel: [   31.693221] ieee80211 phy1: I
iwl3945_rx_scan_start_notif Scan start: 48 [802.11a] (TSF:
0x00000000:000AADC8) - 1 (beacon timer 100680247)
Jan 26 22:22:25 rainbow kernel: [   31.805887] ieee80211 phy1: I
iwl3945_rx_handle r = 117, i = 116, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 22:22:25 rainbow kernel: [   31.805905] ieee80211 phy1: I
iwl3945_rx_scan_results_notif Scan ch.res: 48 [802.11a] (TSF:
0x00000000:000C65D1) - 0 elapsed=112649 usec (112ms since last)
Jan 26 22:22:25 rainbow kernel: [   31.806756] ieee80211 phy1: I
iwl3945_rx_handle r = 119, i = 117, STATISTICS_NOTIFICATION, 0x9d
Jan 26 22:22:25 rainbow kernel: [   31.806780] ieee80211 phy1: I
iwl3945_rx_handle r = 119, i = 118, SCAN_START_NOTIFICATION, 0x82
Jan 26 22:22:25 rainbow kernel: [   31.806792] ieee80211 phy1: I
iwl3945_rx_scan_start_notif Scan start: 52 [802.11a] (TSF:
0x00000000:000C696D) - 1 (beacon timer 117446290)
Jan 26 22:22:25 rainbow kernel: [   31.919472] ieee80211 phy1: I
iwl3945_rx_handle r = 120, i = 119, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 22:22:25 rainbow kernel: [   31.919494] ieee80211 phy1: I
iwl3945_rx_scan_results_notif Scan ch.res: 52 [802.11a] (TSF:
0x00000000:000E2176) - 0 elapsed=112649 usec (112ms since last)
Jan 26 22:22:25 rainbow kernel: [   31.920363] ieee80211 phy1: I
iwl3945_rx_handle r = 122, i = 120, STATISTICS_NOTIFICATION, 0x9d
Jan 26 22:22:25 rainbow kernel: [   31.920392] ieee80211 phy1: I
iwl3945_rx_handle r = 122, i = 121, SCAN_START_NOTIFICATION, 0x82
Jan 26 22:22:25 rainbow kernel: [   31.920406] ieee80211 phy1: I
iwl3945_rx_scan_start_notif Scan start: 56 [802.11a] (TSF:
0x00000000:000E2512) - 1 (beacon timer 151091950)
Jan 26 22:22:25 rainbow kernel: [   32.033048] ieee80211 phy1: I
iwl3945_rx_handle r = 123, i = 122, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 22:22:25 rainbow kernel: [   32.033063] ieee80211 phy1: I
iwl3945_rx_scan_results_notif Scan ch.res: 56 [802.11a] (TSF:
0x00000000:000FDD1A) - 0 elapsed=112648 usec (112ms since last)
Jan 26 22:22:25 rainbow kernel: [   32.033937] ieee80211 phy1: I
iwl3945_rx_handle r = 125, i = 123, STATISTICS_NOTIFICATION, 0x9d
Jan 26 22:22:25 rainbow kernel: [   32.033964] ieee80211 phy1: I
iwl3945_rx_handle r = 125, i = 124, SCAN_START_NOTIFICATION, 0x82
Jan 26 22:22:25 rainbow kernel: [   32.033978] ieee80211 phy1: I
iwl3945_rx_scan_start_notif Scan start: 60 [802.11a] (TSF:
0x00000000:000FE0B7) - 1 (beacon timer 167857993)
Jan 26 22:22:25 rainbow kernel: [   32.146613] ieee80211 phy1: I
iwl3945_rx_handle r = 126, i = 125, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 22:22:25 rainbow kernel: [   32.146628] ieee80211 phy1: I
iwl3945_rx_scan_results_notif Scan ch.res: 60 [802.11a] (TSF:
0x00000000:001198BF) - 0 elapsed=112648 usec (116ms since last)
Jan 26 22:22:25 rainbow kernel: [   32.147908] ieee80211 phy1: I
iwl3945_rx_handle r = 128, i = 126, STATISTICS_NOTIFICATION, 0x9d
Jan 26 22:22:25 rainbow kernel: [   32.147931] ieee80211 phy1: I
iwl3945_rx_handle r = 128, i = 127, SCAN_START_NOTIFICATION, 0x82
Jan 26 22:22:25 rainbow kernel: [   32.147941] ieee80211 phy1: I
iwl3945_rx_scan_start_notif Scan start: 64 [802.11a] (TSF:
0x00000000:00119DD1) - 1 (beacon timer 184623663)
Jan 26 22:22:25 rainbow kernel: [   32.260572] ieee80211 phy1: I
iwl3945_rx_handle r = 129, i = 128, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 22:22:25 rainbow kernel: [   32.260587] ieee80211 phy1: I
iwl3945_rx_scan_results_notif Scan ch.res: 64 [802.11a] (TSF:
0x00000000:001355DA) - 0 elapsed=112649 usec (116ms since last)
Jan 26 22:22:25 rainbow kernel: [   32.261837] ieee80211 phy1: I
iwl3945_rx_handle r = 131, i = 129, STATISTICS_NOTIFICATION, 0x9d
Jan 26 22:22:25 rainbow kernel: [   32.261863] ieee80211 phy1: I
iwl3945_rx_handle r = 131, i = 130, SCAN_START_NOTIFICATION, 0x82
Jan 26 22:22:25 rainbow kernel: [   32.261875] ieee80211 phy1: I
iwl3945_rx_scan_start_notif Scan start: 149 [802.11a] (TSF:
0x00000000:00135AEC) - 1 (beacon timer 201389332)
Jan 26 22:22:25 rainbow kernel: [   32.374467] ieee80211 phy1: I
iwl3945_rx_handle r = 132, i = 131, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 22:22:25 rainbow kernel: [   32.374490] ieee80211 phy1: I
iwl3945_rx_scan_results_notif Scan ch.res: 149 [802.11a] (TSF:
0x00000000:001512F4) - 0 elapsed=112648 usec (112ms since last)
Jan 26 22:22:25 rainbow kernel: [   32.375377] ieee80211 phy1: I
iwl3945_rx_handle r = 134, i = 132, STATISTICS_NOTIFICATION, 0x9d
Jan 26 22:22:25 rainbow kernel: [   32.375401] ieee80211 phy1: I
iwl3945_rx_handle r = 134, i = 133, SCAN_START_NOTIFICATION, 0x82
Jan 26 22:22:25 rainbow kernel: [   32.375412] ieee80211 phy1: I
iwl3945_rx_scan_start_notif Scan start: 153 [802.11a] (TSF:
0x00000000:00151691) - 1 (beacon timer 218155375)
Jan 26 22:22:25 rainbow kernel: [   32.488095] ieee80211 phy1: I
iwl3945_rx_handle r = 135, i = 134, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 22:22:25 rainbow kernel: [   32.488114] ieee80211 phy1: I
iwl3945_rx_scan_results_notif Scan ch.res: 153 [802.11a] (TSF:
0x00000000:0016CEA0) - 0 elapsed=112655 usec (112ms since last)
Jan 26 22:22:25 rainbow kernel: [   32.488993] ieee80211 phy1: I
iwl3945_rx_handle r = 137, i = 135, STATISTICS_NOTIFICATION, 0x9d
Jan 26 22:22:25 rainbow kernel: [   32.489020] ieee80211 phy1: I
iwl3945_rx_handle r = 137, i = 136, SCAN_START_NOTIFICATION, 0x82
Jan 26 22:22:25 rainbow kernel: [   32.489032] ieee80211 phy1: I
iwl3945_rx_scan_start_notif Scan start: 157 [802.11a] (TSF:
0x00000000:0016D23B) - 1 (beacon timer 234921413)
Jan 26 22:22:25 rainbow kernel: [   32.601627] ieee80211 phy1: I
iwl3945_rx_handle r = 138, i = 137, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 22:22:25 rainbow kernel: [   32.601652] ieee80211 phy1: I
iwl3945_rx_scan_results_notif Scan ch.res: 157 [802.11a] (TSF:
0x00000000:00188A45) - 0 elapsed=112650 usec (116ms since last)
Jan 26 22:22:25 rainbow kernel: [   32.602535] ieee80211 phy1: I
iwl3945_rx_handle r = 140, i = 138, STATISTICS_NOTIFICATION, 0x9d
Jan 26 22:22:25 rainbow kernel: [   32.602560] ieee80211 phy1: I
iwl3945_rx_handle r = 140, i = 139, SCAN_START_NOTIFICATION, 0x82
Jan 26 22:22:25 rainbow kernel: [   32.602572] ieee80211 phy1: I
iwl3945_rx_scan_start_notif Scan start: 161 [802.11a] (TSF:
0x00000000:00188DE2) - 1 (beacon timer 251687454)
Jan 26 22:22:26 rainbow kernel: [   32.715258] ieee80211 phy1: I
iwl3945_rx_handle r = 141, i = 140, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 22:22:26 rainbow kernel: [   32.715278] ieee80211 phy1: I
iwl3945_rx_scan_results_notif Scan ch.res: 161 [802.11a] (TSF:
0x00000000:001A45EA) - 0 elapsed=112648 usec (112ms since last)
Jan 26 22:22:26 rainbow kernel: [   32.716145] ieee80211 phy1: I
iwl3945_rx_handle r = 143, i = 141, STATISTICS_NOTIFICATION, 0x9d
Jan 26 22:22:26 rainbow kernel: [   32.716174] ieee80211 phy1: I
iwl3945_rx_handle r = 143, i = 142, SCAN_START_NOTIFICATION, 0x82
Jan 26 22:22:26 rainbow kernel: [   32.716189] ieee80211 phy1: I
iwl3945_rx_scan_start_notif Scan start: 165 [802.11a] (TSF:
0x00000000:001A4986) - 1 (beacon timer 268453498)
Jan 26 22:22:26 rainbow kernel: [   32.828831] ieee80211 phy1: I
iwl3945_rx_handle r = 144, i = 143, SCAN_RESULTS_NOTIFICATION, 0x83
Jan 26 22:22:26 rainbow kernel: [   32.828852] ieee80211 phy1: I
iwl3945_rx_scan_results_notif Scan ch.res: 165 [802.11a] (TSF:
0x00000000:001C018E) - 0 elapsed=112648 usec (116ms since last)
Jan 26 22:22:26 rainbow kernel: [   32.830018] ieee80211 phy1: I
iwl3945_rx_handle r = 145, i = 144, SCAN_COMPLETE_NOTIFICATION, 0x84
Jan 26 22:22:26 rainbow kernel: [   32.830029] ieee80211 phy1: I
iwl3945_rx_scan_complete_notif Scan complete: 13 channels (TSF
0x001C063E:00000000) - 1
Jan 26 22:22:26 rainbow kernel: [   32.830039] ieee80211 phy1: I
iwl3945_rx_scan_complete_notif Scan pass on 5.2GHz took 1480ms
Jan 26 22:22:26 rainbow kernel: [   32.830046] ieee80211 phy1: I
iwl3945_rx_scan_complete_notif Setting scan to off
Jan 26 22:22:26 rainbow kernel: [   32.830054] ieee80211 phy1: I
iwl3945_rx_scan_complete_notif Scan took 1824ms
Jan 26 22:22:26 rainbow kernel: [   32.830090] ieee80211 phy1: U
iwl_bg_scan_completed SCAN complete scan
Jan 26 22:22:26 rainbow kernel: [   32.830119] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 235 dsp 109 rate code 0x0d
Jan 26 22:22:26 rainbow kernel: [   32.830128] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 235 dsp 109 rate code 0x0f
Jan 26 22:22:26 rainbow kernel: [   32.830137] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 235 dsp 109 rate code 0x05
Jan 26 22:22:26 rainbow kernel: [   32.830144] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 235 dsp 109 rate code 0x07
Jan 26 22:22:26 rainbow kernel: [   32.830152] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 235 dsp 109 rate code 0x09
Jan 26 22:22:26 rainbow kernel: [   32.830161] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 235 dsp 109 rate code 0x0b
Jan 26 22:22:26 rainbow kernel: [   32.830169] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 235 dsp 109 rate code 0x01
Jan 26 22:22:26 rainbow kernel: [   32.830177] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 235 dsp 109 rate code 0x03
Jan 26 22:22:26 rainbow kernel: [   32.830185] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 171 dsp  98 rate code 0x0a
Jan 26 22:22:26 rainbow kernel: [   32.830193] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 171 dsp  98 rate code 0x14
Jan 26 22:22:26 rainbow kernel: [   32.830201] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 171 dsp  98 rate code 0x37
Jan 26 22:22:26 rainbow kernel: [   32.830211] ieee80211 phy1: U
iwl3945_send_tx_power ch 1:1 rf 171 dsp  98 rate code 0x6e
Jan 26 22:22:26 rainbow kernel: [   32.830227] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq:
0x0417, 56 bytes at 23[23]:4
Jan 26 22:22:26 rainbow kernel: [   32.830329] ieee80211 phy1: I
iwl3945_rx_handle r 146 i 145 No handler needed for
REPLY_TX_PWR_TABLE_CMD, 0x97
Jan 26 22:22:26 rainbow kernel: [   32.830488] ieee80211 phy1: U
iwl3945_mac_config enter to channel 11
Jan 26 22:22:26 rainbow kernel: [   32.830503] ieee80211 phy1: U
iwl3945_set_rxon_channel Staging channel set to 11 [0]
Jan 26 22:22:26 rainbow kernel: [   32.830517] ieee80211 phy1: U
iwl3945_commit_rxon Sending RXON
Jan 26 22:22:26 rainbow kernel: [   32.830519] * without RXON_FILTER_ASSOC_MSK
Jan 26 22:22:26 rainbow kernel: [   32.830521] * channel = 11
Jan 26 22:22:26 rainbow kernel: [   32.830522] * bssid = 00:00:00:00:00:00
Jan 26 22:22:26 rainbow kernel: [   32.830544] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x0418, 48
bytes at 24[24]:4
Jan 26 22:22:26 rainbow kernel: [   32.831759] ieee80211 phy1: I
iwl3945_rx_handle r 147 i 146 No handler needed for REPLY_RXON, 0x10
Jan 26 22:22:26 rainbow kernel: [   32.831795] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x0d
Jan 26 22:22:26 rainbow kernel: [   32.831804] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x0f
Jan 26 22:22:26 rainbow kernel: [   32.831812] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x05
Jan 26 22:22:26 rainbow kernel: [   32.831820] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x07
Jan 26 22:22:26 rainbow kernel: [   32.831829] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x09
Jan 26 22:22:26 rainbow kernel: [   32.831837] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x0b
Jan 26 22:22:26 rainbow kernel: [   32.831845] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x01
Jan 26 22:22:26 rainbow kernel: [   32.831853] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x03
Jan 26 22:22:26 rainbow kernel: [   32.831861] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x0a
Jan 26 22:22:26 rainbow kernel: [   32.831869] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x14
Jan 26 22:22:26 rainbow kernel: [   32.831877] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x37
Jan 26 22:22:26 rainbow kernel: [   32.831886] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x6e
Jan 26 22:22:26 rainbow kernel: [   32.831898] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq:
0x0419, 56 bytes at 25[25]:4
Jan 26 22:22:26 rainbow kernel: [   32.832079] ieee80211 phy1: I
iwl3945_rx_handle r 148 i 147 No handler needed for
REPLY_TX_PWR_TABLE_CMD, 0x97
Jan 26 22:22:26 rainbow kernel: [   32.832153] ieee80211 phy1: U
iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
Jan 26 22:22:26 rainbow kernel: [   32.832169] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x041A, 68
bytes at 26[26]:4
Jan 26 22:22:26 rainbow kernel: [   32.832252] ieee80211 phy1: I
iwl3945_rx_handle r = 149, i = 148, REPLY_ADD_STA, 0x18
Jan 26 22:22:26 rainbow kernel: [   32.832279] ieee80211 phy1: U
iwl_sta_ucode_activate Added STA to Ucode: 00:00:00:00:00:00
Jan 26 22:22:26 rainbow kernel: [   32.832291] ieee80211 phy1: U
iwl_send_add_sta REPLY_ADD_STA PASSED
Jan 26 22:22:26 rainbow kernel: [   32.832304] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x041B,
56 bytes at 27[27]:4
Jan 26 22:22:26 rainbow kernel: [   32.832415] ieee80211 phy1: I
iwl3945_rx_handle r 150 i 149 No handler needed for REPLY_RATE_SCALE,
0x47
Jan 26 22:22:26 rainbow kernel: [   32.832449] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x041C,
56 bytes at 28[28]:4
Jan 26 22:22:26 rainbow kernel: [   32.832529] ieee80211 phy1: I
iwl3945_rx_handle r 151 i 150 No handler needed for REPLY_RATE_SCALE,
0x47
Jan 26 22:22:26 rainbow kernel: [   32.832579] ieee80211 phy1: U
iwl3945_mac_config leave
Jan 26 22:22:26 rainbow kernel: [   32.832593] ieee80211 phy1: U
iwl3945_mac_config_interface bssid: 00:30:bd:c0:90:24
Jan 26 22:22:26 rainbow kernel: [   32.832605] ieee80211 phy1: U
iwl3945_commit_rxon Sending RXON
Jan 26 22:22:26 rainbow kernel: [   32.832610] * without RXON_FILTER_ASSOC_MSK
Jan 26 22:22:26 rainbow kernel: [   32.832614] * channel = 11
Jan 26 22:22:26 rainbow kernel: [   32.832617] * bssid = 00:00:00:00:00:00
Jan 26 22:22:26 rainbow kernel: [   32.832637] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x041D, 48
bytes at 29[29]:4
Jan 26 22:22:26 rainbow kernel: [   32.832877] ieee80211 phy1: I
iwl3945_rx_handle r 152 i 151 No handler needed for REPLY_RXON, 0x10
Jan 26 22:22:26 rainbow kernel: [   32.832931] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x0d
Jan 26 22:22:26 rainbow kernel: [   32.832943] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x0f
Jan 26 22:22:26 rainbow kernel: [   32.832953] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x05
Jan 26 22:22:26 rainbow kernel: [   32.832963] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x07
Jan 26 22:22:26 rainbow kernel: [   32.832974] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x09
Jan 26 22:22:26 rainbow kernel: [   32.832984] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x0b
Jan 26 22:22:26 rainbow kernel: [   32.832995] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x01
Jan 26 22:22:26 rainbow kernel: [   32.833023] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x03
Jan 26 22:22:26 rainbow kernel: [   32.833035] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x0a
Jan 26 22:22:26 rainbow kernel: [   32.833045] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x14
Jan 26 22:22:26 rainbow kernel: [   32.833055] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x37
Jan 26 22:22:26 rainbow kernel: [   32.833066] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x6e
Jan 26 22:22:26 rainbow kernel: [   32.833080] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq:
0x041E, 56 bytes at 30[30]:4
Jan 26 22:22:26 rainbow kernel: [   32.833210] ieee80211 phy1: I
iwl3945_rx_handle r 153 i 152 No handler needed for
REPLY_TX_PWR_TABLE_CMD, 0x97
Jan 26 22:22:26 rainbow kernel: [   32.833244] ieee80211 phy1: U
iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
Jan 26 22:22:26 rainbow kernel: [   32.833258] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x041F, 68
bytes at 31[31]:4
Jan 26 22:22:26 rainbow kernel: [   32.833339] ieee80211 phy1: I
iwl3945_rx_handle r = 154, i = 153, REPLY_ADD_STA, 0x18
Jan 26 22:22:26 rainbow kernel: [   32.833389] ieee80211 phy1: U
iwl_sta_ucode_activate Added STA to Ucode: 00:00:00:00:00:00
Jan 26 22:22:26 rainbow kernel: [   32.833399] ieee80211 phy1: U
iwl_send_add_sta REPLY_ADD_STA PASSED
Jan 26 22:22:26 rainbow kernel: [   32.833414] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0420,
56 bytes at 32[0]:4
Jan 26 22:22:26 rainbow kernel: [   32.833491] ieee80211 phy1: I
iwl3945_rx_handle r 155 i 154 No handler needed for REPLY_RATE_SCALE,
0x47
Jan 26 22:22:26 rainbow kernel: [   32.833544] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0421,
56 bytes at 33[1]:4
Jan 26 22:22:26 rainbow kernel: [   32.833657] ieee80211 phy1: I
iwl3945_rx_handle r 156 i 155 No handler needed for REPLY_RATE_SCALE,
0x47
Jan 26 22:22:26 rainbow kernel: [   32.833686] ieee80211 phy1: U
iwl3945_mac_config_interface leave
Jan 26 22:22:26 rainbow kernel: [   32.833697] ieee80211 phy1: U
iwl3945_mac_conf_tx enter
Jan 26 22:22:26 rainbow kernel: [   32.833705] ieee80211 phy1: U
iwl3945_mac_conf_tx leave
Jan 26 22:22:26 rainbow kernel: [   32.833713] ieee80211 phy1: U
iwl3945_mac_conf_tx enter
Jan 26 22:22:26 rainbow kernel: [   32.833721] ieee80211 phy1: U
iwl3945_mac_conf_tx leave
Jan 26 22:22:26 rainbow kernel: [   32.833728] ieee80211 phy1: U
iwl3945_mac_conf_tx enter
Jan 26 22:22:26 rainbow kernel: [   32.833736] ieee80211 phy1: U
iwl3945_mac_conf_tx leave
Jan 26 22:22:26 rainbow kernel: [   32.833743] ieee80211 phy1: U
iwl3945_mac_conf_tx enter
Jan 26 22:22:26 rainbow kernel: [   32.833751] ieee80211 phy1: U
iwl3945_mac_conf_tx leave
Jan 26 22:22:26 rainbow kernel: [   32.833760] ieee80211 phy1: U
iwl3945_mac_reset_tsf enter
Jan 26 22:22:26 rainbow kernel: [   32.833771] ieee80211 phy1: U
iwl3945_commit_rxon Sending RXON
Jan 26 22:22:26 rainbow kernel: [   32.833774] * without RXON_FILTER_ASSOC_MSK
Jan 26 22:22:26 rainbow kernel: [   32.833776] * channel = 11
Jan 26 22:22:26 rainbow kernel: [   32.833778] * bssid = 00:00:00:00:00:00
Jan 26 22:22:26 rainbow kernel: [   32.833798] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x0422, 48
bytes at 34[2]:4
Jan 26 22:22:26 rainbow kernel: [   32.833986] ieee80211 phy1: I
iwl3945_rx_handle r 157 i 156 No handler needed for REPLY_RXON, 0x10
Jan 26 22:22:26 rainbow kernel: [   32.834041] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x0d
Jan 26 22:22:26 rainbow kernel: [   32.834053] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x0f
Jan 26 22:22:26 rainbow kernel: [   32.834063] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x05
Jan 26 22:22:26 rainbow kernel: [   32.834073] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x07
Jan 26 22:22:26 rainbow kernel: [   32.834084] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x09
Jan 26 22:22:26 rainbow kernel: [   32.834094] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x0b
Jan 26 22:22:26 rainbow kernel: [   32.834104] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x01
Jan 26 22:22:26 rainbow kernel: [   32.834114] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x03
Jan 26 22:22:26 rainbow kernel: [   32.834124] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x0a
Jan 26 22:22:26 rainbow kernel: [   32.834134] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x14
Jan 26 22:22:26 rainbow kernel: [   32.834144] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x37
Jan 26 22:22:26 rainbow kernel: [   32.834154] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x6e
Jan 26 22:22:26 rainbow kernel: [   32.834168] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq:
0x0423, 56 bytes at 35[3]:4
Jan 26 22:22:26 rainbow kernel: [   32.834269] ieee80211 phy1: I
iwl3945_rx_handle r 158 i 157 No handler needed for
REPLY_TX_PWR_TABLE_CMD, 0x97
Jan 26 22:22:26 rainbow kernel: [   32.834293] ieee80211 phy1: U
iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
Jan 26 22:22:26 rainbow kernel: [   32.834308] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0424, 68
bytes at 36[4]:4
Jan 26 22:22:26 rainbow kernel: [   32.834419] ieee80211 phy1: I
iwl3945_rx_handle r = 159, i = 158, REPLY_ADD_STA, 0x18
Jan 26 22:22:26 rainbow kernel: [   32.834447] ieee80211 phy1: U
iwl_sta_ucode_activate Added STA to Ucode: 00:00:00:00:00:00
Jan 26 22:22:26 rainbow kernel: [   32.834458] ieee80211 phy1: U
iwl_send_add_sta REPLY_ADD_STA PASSED
Jan 26 22:22:26 rainbow kernel: [   32.834472] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0425,
56 bytes at 37[5]:4
Jan 26 22:22:26 rainbow kernel: [   32.834579] ieee80211 phy1: I
iwl3945_rx_handle r 160 i 159 No handler needed for REPLY_RATE_SCALE,
0x47
Jan 26 22:22:26 rainbow kernel: [   32.834611] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0426,
56 bytes at 38[6]:4
Jan 26 22:22:26 rainbow kernel: [   32.834687] ieee80211 phy1: I
iwl3945_rx_handle r 161 i 160 No handler needed for REPLY_RATE_SCALE,
0x47
Jan 26 22:22:26 rainbow kernel: [   32.834749] ieee80211 phy1: U
iwl3945_mac_reset_tsf leave - not in IBSS
Jan 26 22:22:26 rainbow kernel: [   32.834760] wlan0: authenticate
with AP 00:30:bd:c0:90:24
Jan 26 22:22:26 rainbow kernel: [   32.834783] ieee80211 phy1: I
iwl3945_mac_tx enter
Jan 26 22:22:26 rainbow kernel: [   32.834798] ieee80211 phy1: I
iwl3945_mac_tx leave
Jan 26 22:22:26 rainbow kernel: [   32.834882] ieee80211 phy1: I
iwl3945_rx_handle r = 162, i = 161, REPLY_TX, 0x1c
Jan 26 22:22:26 rainbow kernel: [   33.033097] wlan0: authenticate
with AP 00:30:bd:c0:90:24
Jan 26 22:22:26 rainbow kernel: [   33.033124] ieee80211 phy1: I
iwl3945_mac_tx enter
Jan 26 22:22:26 rainbow kernel: [   33.033146] ieee80211 phy1: I
iwl3945_mac_tx leave
Jan 26 22:22:26 rainbow kernel: [   33.034863] iwl3945 0000:03:00.0:
Microcode SW error detected. Restarting 0x82000008.
Jan 26 22:22:26 rainbow kernel: [   33.034899] iwl3945 0000:03:00.0:
Start IWL Error Log Dump:
Jan 26 22:22:26 rainbow kernel: [   33.034907] iwl3945 0000:03:00.0:
Status: 0x000202E4, count: 1
Jan 26 22:22:26 rainbow kernel: [   33.034914] iwl3945 0000:03:00.0:
Desc       Time       asrtPC  blink2 ilink1  nmiPC   Line
Jan 26 22:22:26 rainbow kernel: [   33.034991] iwl3945 0000:03:00.0:
SYSASSERT     (#5) 0000200904 0x0089A 0x0025E 0x00304 0x04BC4 78
Jan 26 22:22:26 rainbow kernel: [   33.034993]
Jan 26 22:22:26 rainbow kernel: [   33.035064] iwl3945 0000:03:00.0:
Start IWL Event Log Dump: display count 512, wraps 6
Jan 26 22:22:26 rainbow kernel: [   33.035101] iwl3945 0000:03:00.0:
0001464116^I0x000000d9^I0106
Jan 26 22:22:26 rainbow kernel: [   33.035136] iwl3945 0000:03:00.0:
0001464118^I0x00000000^I0302
Jan 26 22:22:26 rainbow kernel: [   33.035172] iwl3945 0000:03:00.0:
0001464126^I0x00008000^I0350
Jan 26 22:22:26 rainbow kernel: [   33.035208] iwl3945 0000:03:00.0:
0001464136^I0x000000d9^I0106
Jan 26 22:22:26 rainbow kernel: [   33.035243] iwl3945 0000:03:00.0:
0001464137^I0x00000000^I0302
Jan 26 22:22:26 rainbow kernel: [   33.035279] iwl3945 0000:03:00.0:
0001464142^I0x00008000^I0350
Jan 26 22:22:26 rainbow kernel: [   33.035314] iwl3945 0000:03:00.0:
0001464199^I0x000000d9^I0106
Jan 26 22:22:26 rainbow kernel: [   33.035349] iwl3945 0000:03:00.0:
0001464201^I0x00000000^I0302
Jan 26 22:22:26 rainbow kernel: [   33.035384] iwl3945 0000:03:00.0:
0001464243^I0x00000004^I0353
Jan 26 22:22:26 rainbow kernel: [   33.035420] iwl3945 0000:03:00.0:
0001464314^I0x000000d9^I0106
Jan 26 22:22:26 rainbow kernel: [   33.035456] iwl3945 0000:03:00.0:
0001464316^I0x00000000^I0302
Jan 26 22:22:26 rainbow kernel: [   33.035492] iwl3945 0000:03:00.0:
0001464339^I0x00000005^I0353
Jan 26 22:22:26 rainbow kernel: [   33.035527] iwl3945 0000:03:00.0:
0001494700^I0x0000009d^I1108
Jan 26 22:22:26 rainbow kernel: [   33.035562] iwl3945 0000:03:00.0:
0001494702^I0x0000000e^I1101
Jan 26 22:22:26 rainbow kernel: [   33.035598] iwl3945 0000:03:00.0:
0001494703^I0x00680034^I1102
Jan 26 22:22:26 rainbow kernel: [   33.035634] iwl3945 0000:03:00.0:
0001494705^I0x00680035^I1102
Jan 26 22:22:26 rainbow kernel: [   33.035670] iwl3945 0000:03:00.0:
0001494706^I0x007c0036^I1102
Jan 26 22:22:26 rainbow kernel: [   33.035705] iwl3945 0000:03:00.0:
0001494708^I0x007d0037^I1102
Jan 26 22:22:26 rainbow kernel: [   33.035741] iwl3945 0000:03:00.0:
0001494709^I0x00000038^I1102
Jan 26 22:22:26 rainbow kernel: [   33.035776] iwl3945 0000:03:00.0:
0001494711^I0x00830052^I1102
Jan 26 22:22:26 rainbow kernel: [   33.035812] iwl3945 0000:03:00.0:
0001494712^I0x00830053^I1102
Jan 26 22:22:26 rainbow kernel: [   33.035847] iwl3945 0000:03:00.0:
0001494714^I0x007f0054^I1102
Jan 26 22:22:26 rainbow kernel: [   33.035882] iwl3945 0000:03:00.0:
0001494715^I0x007d0055^I1102
Jan 26 22:22:26 rainbow kernel: [   33.035917] iwl3945 0000:03:00.0:
0001494717^I0x00000056^I1102
Jan 26 22:22:26 rainbow kernel: [   33.035952] iwl3945 0000:03:00.0:
0001494718^I0x00007050^I1102
Jan 26 22:22:26 rainbow kernel: [   33.035987] iwl3945 0000:03:00.0:
0001494720^I0x00017051^I1102
Jan 26 22:22:26 rainbow kernel: [   33.036023] iwl3945 0000:03:00.0:
0001494722^I0x00008204^I1102
Jan 26 22:22:26 rainbow kernel: [   33.036059] iwl3945 0000:03:00.0:
0001494724^I0x00018205^I1102
Jan 26 22:22:26 rainbow kernel: [   33.036094] iwl3945 0000:03:00.0:
0001494727^I0x00000001^I1101
Jan 26 22:22:26 rainbow kernel: [   33.036131] iwl3945 0000:03:00.0:
0001494728^I0x008b0063^I1102
Jan 26 22:22:26 rainbow kernel: [   33.036166] iwl3945 0000:03:00.0:
0001494730^I0x0000001d^I1104
Jan 26 22:22:26 rainbow kernel: [   33.036201] iwl3945 0000:03:00.0:
0001494732^I0x00000002^I1101
Jan 26 22:22:26 rainbow kernel: [   33.036236] iwl3945 0000:03:00.0:
0001494733^I0x0082903f^I1102
Jan 26 22:22:26 rainbow kernel: [   33.036276] iwl3945 0000:03:00.0:
0001494735^I0x0000d213^I1102
Jan 26 22:22:26 rainbow kernel: [   33.036312] iwl3945 0000:03:00.0:
0001494738^I0x00000002^I1101
Jan 26 22:22:26 rainbow kernel: [   33.036348] iwl3945 0000:03:00.0:
0001494739^I0x0005d206^I1102
Jan 26 22:22:26 rainbow kernel: [   33.036383] iwl3945 0000:03:00.0:
0001494741^I0x0087903e^I1102
Jan 26 22:22:26 rainbow kernel: [   33.036419] iwl3945 0000:03:00.0:
0001494745^I0x0000005a^I1101
Jan 26 22:22:26 rainbow kernel: [   33.036454] iwl3945 0000:03:00.0:
0001494846^I0x00000013^I1101
Jan 26 22:22:26 rainbow kernel: [   33.036490] iwl3945 0000:03:00.0:
0001494863^I0x0000000e^I1107
Jan 26 22:22:26 rainbow kernel: [   33.036525] iwl3945 0000:03:00.0:
0001495379^I0x0e009ead^I1110
Jan 26 22:22:26 rainbow kernel: [   33.036560] iwl3945 0000:03:00.0:
0001495391^I0xffffff48^I0454
Jan 26 22:22:26 rainbow kernel: [   33.036596] iwl3945 0000:03:00.0:
0001495392^I0x00000000^I0472
Jan 26 22:22:26 rainbow kernel: [   33.036632] iwl3945 0000:03:00.0:
0001495404^I0x00000099^I0464
Jan 26 22:22:26 rainbow kernel: [   33.036667] iwl3945 0000:03:00.0:
0001495406^I0xffffff48^I1111
Jan 26 22:22:26 rainbow kernel: [   33.036702] iwl3945 0000:03:00.0:
0001495429^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.036738] iwl3945 0000:03:00.0:
0001495429^I0x0000000e^I1106
Jan 26 22:22:26 rainbow kernel: [   33.036773] iwl3945 0000:03:00.0:
0001495434^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.036808] iwl3945 0000:03:00.0:
0001495438^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.036847] iwl3945 0000:03:00.0:
0001495442^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.036883] iwl3945 0000:03:00.0:
0001495446^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.036919] iwl3945 0000:03:00.0:
0001495451^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.036958] iwl3945 0000:03:00.0:
0001495455^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.036994] iwl3945 0000:03:00.0:
0001495459^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.037030] iwl3945 0000:03:00.0:
0001495464^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.037065] iwl3945 0000:03:00.0:
0001495468^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.037100] iwl3945 0000:03:00.0:
0001495472^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.037136] iwl3945 0000:03:00.0:
0001495476^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.037172] iwl3945 0000:03:00.0:
0001495481^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.037207] iwl3945 0000:03:00.0:
0001495485^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.037243] iwl3945 0000:03:00.0:
0001495489^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.037279] iwl3945 0000:03:00.0:
0001495493^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.037314] iwl3945 0000:03:00.0:
0001495498^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.037350] iwl3945 0000:03:00.0:
0001495502^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.037385] iwl3945 0000:03:00.0:
0001495506^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.037424] iwl3945 0000:03:00.0:
0001495511^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.037460] iwl3945 0000:03:00.0:
0001495515^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.037496] iwl3945 0000:03:00.0:
0001495519^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.037534] iwl3945 0000:03:00.0:
0001495523^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.037570] iwl3945 0000:03:00.0:
0001495528^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.037606] iwl3945 0000:03:00.0:
0001495532^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.037641] iwl3945 0000:03:00.0:
0001495536^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.037676] iwl3945 0000:03:00.0:
0001495541^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.037712] iwl3945 0000:03:00.0:
0001495545^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.037747] iwl3945 0000:03:00.0:
0001495549^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.037781] iwl3945 0000:03:00.0:
0001495553^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.037817] iwl3945 0000:03:00.0:
0001495558^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.037852] iwl3945 0000:03:00.0:
0001495562^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.037887] iwl3945 0000:03:00.0:
0001495566^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.037922] iwl3945 0000:03:00.0:
0001495570^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.037958] iwl3945 0000:03:00.0:
0001495575^I0x00000001^I1106
Jan 26 22:22:26 rainbow kernel: [   33.037996] iwl3945 0000:03:00.0:
0001495576^I0x0000000f^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038031] iwl3945 0000:03:00.0:
0001495577^I0x00000370^I1105
Jan 26 22:22:26 rainbow kernel: [   33.038067] iwl3945 0000:03:00.0:
0001495580^I0x000004e8^I1115
Jan 26 22:22:26 rainbow kernel: [   33.038105] iwl3945 0000:03:00.0:
0001495585^I0x0000009d^I0464
Jan 26 22:22:26 rainbow kernel: [   33.038141] iwl3945 0000:03:00.0:
0001495586^I0x0000009d^I0462
Jan 26 22:22:26 rainbow kernel: [   33.038176] iwl3945 0000:03:00.0:
0001541709^I0x000000d9^I0106
Jan 26 22:22:26 rainbow kernel: [   33.038212] iwl3945 0000:03:00.0:
0001541710^I0x00000000^I0302
Jan 26 22:22:26 rainbow kernel: [   33.038246] iwl3945 0000:03:00.0:
0001541719^I0x00008000^I0350
Jan 26 22:22:26 rainbow kernel: [   33.038281] iwl3945 0000:03:00.0:
0001608274^I0x000000a1^I1108
Jan 26 22:22:26 rainbow kernel: [   33.038317] iwl3945 0000:03:00.0:
0001608276^I0x0000000e^I1101
Jan 26 22:22:26 rainbow kernel: [   33.038352] iwl3945 0000:03:00.0:
0001608277^I0x00680034^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038387] iwl3945 0000:03:00.0:
0001608278^I0x00680035^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038422] iwl3945 0000:03:00.0:
0001608280^I0x007c0036^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038458] iwl3945 0000:03:00.0:
0001608281^I0x007d0037^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038493] iwl3945 0000:03:00.0:
0001608283^I0x00000038^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038528] iwl3945 0000:03:00.0:
0001608284^I0x00830052^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038567] iwl3945 0000:03:00.0:
0001608286^I0x00830053^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038602] iwl3945 0000:03:00.0:
0001608287^I0x007f0054^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038638] iwl3945 0000:03:00.0:
0001608289^I0x007d0055^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038676] iwl3945 0000:03:00.0:
0001608291^I0x00000056^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038711] iwl3945 0000:03:00.0:
0001608292^I0x00007050^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038747] iwl3945 0000:03:00.0:
0001608294^I0x00017051^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038782] iwl3945 0000:03:00.0:
0001608296^I0x00008204^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038817] iwl3945 0000:03:00.0:
0001608298^I0x00018205^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001608301^I0x00000001^I1101
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001608302^I0x008b0063^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001608304^I0x0000001d^I1104
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001608306^I0x00000002^I1101
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001608307^I0x0082903f^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001608308^I0x0000d213^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001608312^I0x00000002^I1101
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001608312^I0x0005d206^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001608314^I0x0087903e^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001608318^I0x0000005a^I1101
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001608420^I0x00000013^I1101
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001608436^I0x0000000e^I1107
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001608953^I0x0f007307^I1110
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001608965^I0xffffff48^I0454
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001608966^I0x00000000^I0472
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001608977^I0x0000009d^I0464
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001608979^I0xffffff48^I1111
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001609002^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001609002^I0x0000000e^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001609007^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001609011^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001609015^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001609019^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001609024^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001609028^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001609032^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001609037^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001609041^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001609045^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001609049^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001609054^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001609058^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001609062^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001609066^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001609071^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001609075^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001609079^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001609084^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001609088^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001609092^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001609096^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001609101^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001609105^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001609109^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001609113^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001609118^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001609122^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001609126^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001609131^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001609135^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001609139^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001609143^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001609148^I0x00000001^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001609148^I0x0000000f^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001609150^I0x00000370^I1105
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001609153^I0x000004e8^I1115
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001609160^I0x000000a1^I0464
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001609161^I0x000000a1^I0462
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001721847^I0x000000a5^I1108
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001721849^I0x0000000e^I1101
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001721850^I0x00680034^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001721851^I0x00680035^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001721853^I0x007c0036^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001721854^I0x007d0037^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001721856^I0x00000038^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001721857^I0x00830052^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001721859^I0x00830053^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001721860^I0x007f0054^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001721862^I0x007d0055^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001721863^I0x00000056^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001721865^I0x00007050^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001721867^I0x00017051^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001721869^I0x00008204^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001721871^I0x00018205^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001721874^I0x00000001^I1101
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001721875^I0x008b0063^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001721877^I0x0000001c^I1104
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001721878^I0x00000002^I1101
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001721879^I0x0082903f^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001721881^I0x0000d213^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001721884^I0x00000002^I1101
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001721885^I0x0005d206^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001721887^I0x0087903e^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001721891^I0x0000005a^I1101
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001721992^I0x00000013^I1101
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001722009^I0x0000000e^I1107
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001722526^I0x10004762^I1110
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001722538^I0xffffff49^I0454
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001722539^I0x00000000^I0472
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001722551^I0x000000a1^I0464
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001722553^I0xffffff49^I1111
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001722575^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001722575^I0x0000000e^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001722580^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001722584^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001722588^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001722592^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001722597^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001722601^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001722605^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001722610^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001722614^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001722618^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001722622^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001722627^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001722631^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001722635^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001722639^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001722644^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001722648^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001722652^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001722657^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001722661^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001722665^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001722669^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001722674^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001722678^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001722682^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001722686^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001722691^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001722695^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001722699^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001722704^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001722708^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001722712^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001722716^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001722721^I0x00000001^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001722721^I0x0000000f^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001722723^I0x00000370^I1105
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001722726^I0x000004e8^I1115
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001722732^I0x000000a5^I0464
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001722733^I0x000000a5^I0462
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001784109^I0x000000d9^I0106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001784111^I0x00000000^I0302
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001784136^I0x00000001^I0353
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001784367^I0x000000d9^I0106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001784369^I0x00000000^I0302
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001784376^I0x00008000^I0350
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001835409^I0x000001b8^I1005
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001835413^I0x00000101^I1108
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001835415^I0x0000000e^I1101
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001835416^I0x00680034^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001835417^I0x00670035^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001835419^I0x007e0036^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001835420^I0x007c0037^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001835422^I0x00000038^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001835423^I0x00840052^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001835425^I0x00840053^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001835427^I0x007e0054^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001835428^I0x007d0055^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001835430^I0x00000056^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001835431^I0x00007050^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001835433^I0x00017051^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001835435^I0x00008204^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001835437^I0x00018205^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001835440^I0x00000001^I1101
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001835441^I0x008b0063^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001835443^I0x0000001d^I1104
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001835445^I0x00000002^I1101
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001835446^I0x0083903f^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001835448^I0x0001d213^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001835451^I0x00000002^I1101
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001835452^I0x0003d206^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001835454^I0x0083903e^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001835457^I0x00000059^I1101
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001835558^I0x00000013^I1101
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001835575^I0x00000004^I1107
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836091^I0x11001bc5^I1110
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836103^I0xffffff49^I0454
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836104^I0x00000000^I0472
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836115^I0x000000a5^I0464
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836118^I0xffffff49^I1111
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836144^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836145^I0x0000000e^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836149^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836154^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836158^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836162^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836166^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836171^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836175^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836179^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836183^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836188^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836192^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836196^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836200^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836205^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836209^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836213^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836217^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836222^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836226^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836230^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836234^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836239^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836243^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836247^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836251^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836256^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836260^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836264^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836268^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836273^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836277^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836281^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836285^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836290^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836294^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836298^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836302^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836307^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836311^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836315^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836319^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836324^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836328^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836332^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836336^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836341^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836345^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836349^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836353^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836358^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836362^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836366^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836370^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836375^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836379^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836383^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836387^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836392^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836396^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836400^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836404^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836409^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836413^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836417^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836421^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836426^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836430^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836434^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836438^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836443^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836447^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836451^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836455^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836460^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836464^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836468^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836472^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836477^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836481^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836485^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836489^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836494^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836498^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836502^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836506^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836511^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836515^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836519^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836523^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836528^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836532^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836536^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836540^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836545^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836549^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836553^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836557^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836562^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836566^I0x00000001^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836567^I0x0000000f^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836568^I0x00000485^I1105
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836572^I0x000004e8^I1115
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836575^I0x00000001^I0463
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836576^I0x00000001^I0462
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836947^I0x04170097^I0401
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836950^I0x00000001^I0451
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001836970^I0x00000000^I0451
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001837263^I0x04180010^I0401
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001837320^I0x00000175^I1005
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001837321^I0x00000000^I1001
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0001837322^I0x00000000^I1002
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000012^I0x000001b8^I1005
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000024^I0x0000010b^I1108
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000026^I0x0000000e^I1101
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000027^I0x00680034^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000028^I0x00670035^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000030^I0x007e0036^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000031^I0x007c0037^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000033^I0x00000038^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000034^I0x00840052^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000036^I0x00840053^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000037^I0x007e0054^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000039^I0x007d0055^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000040^I0x00000056^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000042^I0x00007050^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000044^I0x00017051^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000046^I0x00008204^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000048^I0x00018205^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000051^I0x00000001^I1101
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000052^I0x008b0063^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000054^I0x0000001c^I1104
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000056^I0x00000002^I1101
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000056^I0x0083903f^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000058^I0x0001d213^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000062^I0x00000002^I1101
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000062^I0x0003d206^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000064^I0x0083903e^I1102
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000068^I0x00000059^I1101
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000168^I0x00000013^I1101
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000186^I0x00000005^I1107
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000754^I0x00018d0f^I1110
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000765^I0xffffff48^I0454
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000766^I0x00000000^I0472
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000776^I0x00000001^I0463
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000779^I0xffffff48^I1111
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000784^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000784^I0x0000000e^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000789^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000793^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000797^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000801^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000806^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000810^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000814^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000819^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000823^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000827^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000831^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000836^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000840^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000844^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000848^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000853^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000857^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000861^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000866^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000870^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000874^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000878^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000883^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000887^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000891^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000895^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000900^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000904^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000908^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000913^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000917^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000921^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000925^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000930^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000934^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000938^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000943^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000947^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000951^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000955^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000960^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000964^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000968^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000972^I0x00000000^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000977^I0x00000001^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000978^I0x0000000f^I1106
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000979^I0x000003bd^I1105
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000983^I0x000004e8^I1115
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000986^I0x0000000b^I0463
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000987^I0x0000000b^I0462
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000001009^I0x000000aa^I0103
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000001283^I0x04190097^I0401
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000001285^I0x0000000b^I0451
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000001305^I0x00000000^I0451
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000001556^I0x041a0018^I0401
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000001693^I0x041b0047^I0401
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000001836^I0x041c0047^I0401
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000002023^I0x041d0010^I0401
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000002081^I0x00000175^I1005
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000002082^I0x00000000^I1001
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000002082^I0x00000000^I1002
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000012^I0x000001b8^I1005
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000040^I0x000000aa^I0103
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000319^I0x041e0097^I0401
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000321^I0x0000000b^I0451
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000341^I0x00000000^I0451
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000497^I0x041f0018^I0401
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000653^I0x04200047^I0401
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000785^I0x04210047^I0401
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000001037^I0x04220010^I0401
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000001095^I0x00000175^I1005
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000001096^I0x00000000^I1001
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000001096^I0x00000000^I1002
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000012^I0x000001b8^I1005
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000040^I0x000000aa^I0103
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000297^I0x04230097^I0401
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000299^I0x0000000b^I0451
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000319^I0x00000000^I0451
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000436^I0x04240018^I0401
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000599^I0x04250047^I0401
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000741^I0x04260047^I0401
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000929^I0x0000000b^I0463
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000932^I0x00010087^I0250
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000000938^I0x0000001c^I0218
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000200902^I0x00000002^I0123
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
0000200905^I0x00000100^I0125
Jan 26 22:22:26 rainbow kernel: [   33.038820] ieee80211 phy1: I
iwl3945_print_rx_config_cmd RX CONFIG:
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl data: 00000000: 00
1f 3c 20 a1 6e 00 00 00 30 bd c0 90 24 00 00  ..< .n...0...$..
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl data: 00000010: 00
00 00 00 00 00 00 00 03 00 00 00 15 03 00 00  ................
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl data: 00000020: 05
80 00 00 04 00 00 00 0b 00 00 00              ............
Jan 26 22:22:26 rainbow kernel: [   33.038820] ieee80211 phy1: I
iwl3945_print_rx_config_cmd u16 channel: 0xb
Jan 26 22:22:26 rainbow kernel: [   33.038820] ieee80211 phy1: I
iwl3945_print_rx_config_cmd u32 flags: 0x00008005
Jan 26 22:22:26 rainbow kernel: [   33.038820] ieee80211 phy1: I
iwl3945_print_rx_config_cmd u32 filter_flags: 0x00000004
Jan 26 22:22:26 rainbow kernel: [   33.038820] ieee80211 phy1: I
iwl3945_print_rx_config_cmd u8 dev_type: 0x3
Jan 26 22:22:26 rainbow kernel: [   33.038820] ieee80211 phy1: I
iwl3945_print_rx_config_cmd u8 ofdm_basic_rates: 0x15
Jan 26 22:22:26 rainbow kernel: [   33.038820] ieee80211 phy1: I
iwl3945_print_rx_config_cmd u8 cck_basic_rates: 0x03
Jan 26 22:22:26 rainbow kernel: [   33.038820] ieee80211 phy1: I
iwl3945_print_rx_config_cmd u8[6] node_addr: 00:1f:3c:20:a1:6e
Jan 26 22:22:26 rainbow kernel: [   33.038820] ieee80211 phy1: I
iwl3945_print_rx_config_cmd u8[6] bssid_addr: 00:30:bd:c0:90:24
Jan 26 22:22:26 rainbow kernel: [   33.038820] ieee80211 phy1: I
iwl3945_print_rx_config_cmd u16 assoc_id: 0x0
Jan 26 22:22:26 rainbow kernel: [   33.038820] ieee80211 phy1: I
iwl3945_irq_handle_error Restarting adapter due to uCode error.
Jan 26 22:22:26 rainbow kernel: [   33.038820] ieee80211 phy1: I
iwl3945_rx_handle r = 163, i = 162, REPLY_ERROR, 0x02
Jan 26 22:22:26 rainbow kernel: [   33.038820] iwl3945 0000:03:00.0:
Error Reply type 0x00000005 cmd REPLY_PHY_CALIBRATION_CMD (0xB0) seq
0x013A ser 0x004E0000
Jan 26 22:22:26 rainbow kernel: [   33.054134] ieee80211 phy1: U
__iwl3945_down iwl3945 is going down
Jan 26 22:22:26 rainbow kernel: [   33.055948] ieee80211 phy1: U
iwl3945_apm_stop_master stop master
Jan 26 22:22:26 rainbow kernel: [   33.056727] ieee80211 phy1: U
iwl3945_apm_stop_master stop master
Jan 26 22:22:26 rainbow kernel: [   33.056844] ieee80211 phy1: U
iwl3945_clear_free_frames 0 frames on pre-allocated heap on clear.
Jan 26 22:22:26 rainbow kernel: [   33.056865] ieee80211 phy1: U
iwl3945_power_init_handle Initialize power
Jan 26 22:22:26 rainbow kernel: [   33.056882] ieee80211 phy1: U
iwl3945_power_init_handle adjust power command flags
Jan 26 22:22:26 rainbow kernel: [   33.056986] ieee80211 phy1: U
iwl3945_hw_nic_init HW Revision ID = 0x2
Jan 26 22:22:26 rainbow kernel: [   33.057045] ieee80211 phy1: U
iwl3945_nic_config 3945 RADIO-MM type
Jan 26 22:22:26 rainbow kernel: [   33.057058] ieee80211 phy1: U
iwl3945_nic_config SKU OP mode is basic
Jan 26 22:22:26 rainbow kernel: [   33.057065] ieee80211 phy1: U
iwl3945_nic_config 3945ABG revision is 0xF1
Jan 26 22:22:26 rainbow kernel: [   33.057078] ieee80211 phy1: U
iwl3945_nic_config Card M type B version is 0x3
Jan 26 22:22:26 rainbow kernel: [   33.065327] ieee80211 phy1: U
iwl3945_load_bsm Begin load bsm
Jan 26 22:22:26 rainbow kernel: [   33.066603] ieee80211 phy1: U
iwl3945_verify_bsm Begin verify bsm
Jan 26 22:22:26 rainbow kernel: [   33.068819] ieee80211 phy1: U
iwl3945_verify_bsm BSM bootstrap uCode image OK
Jan 26 22:22:26 rainbow kernel: [   33.068879] ieee80211 phy1: U
iwl3945_load_bsm BSM write complete, poll 1 iterations
Jan 26 22:22:26 rainbow kernel: [   33.068899] ieee80211 phy1: U
__iwl3945_up iwl3945 is coming up
Jan 26 22:22:26 rainbow kernel: [   33.080352] ieee80211 phy1: I
iwl3945_rx_handle r = 1, i = 0, REPLY_ALIVE, 0x01
Jan 26 22:22:26 rainbow kernel: [   33.080369] ieee80211 phy1: I
iwl3945_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x9
Jan 26 22:22:26 rainbow kernel: [   33.080378] ieee80211 phy1: I
iwl3945_rx_reply_alive Initialization Alive received.
Jan 26 22:22:26 rainbow kernel: [   33.088065] ieee80211 phy1: U
iwl3945_verify_inst_sparse ucode inst image size is 900
Jan 26 22:22:26 rainbow kernel: [   33.088167] ieee80211 phy1: U
iwl3945_verify_inst_sparse ucode inst image size is 2672
Jan 26 22:22:26 rainbow kernel: [   33.088467] ieee80211 phy1: U
iwl3945_verify_ucode Initialize uCode is good in inst SRAM
Jan 26 22:22:26 rainbow kernel: [   33.088475] ieee80211 phy1: U
iwl3945_init_alive_start Initialization Alive received.
Jan 26 22:22:26 rainbow kernel: [   33.088525] ieee80211 phy1: U
iwl3945_set_ucode_ptrs Runtime uCode pointers are set.
Jan 26 22:22:26 rainbow kernel: [   33.092913] ieee80211 phy1: I
iwl3945_rx_handle r = 2, i = 1, REPLY_ALIVE, 0x01
Jan 26 22:22:26 rainbow kernel: [   33.092924] ieee80211 phy1: I
iwl3945_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x0
Jan 26 22:22:26 rainbow kernel: [   33.092932] ieee80211 phy1: I
iwl3945_rx_reply_alive Runtime Alive received.
Jan 26 22:22:26 rainbow kernel: [   33.092980] ieee80211 phy1: I
iwl3945_disable_events Selected uCode log events may be disabled
Jan 26 22:22:26 rainbow kernel: [   33.092989] ieee80211 phy1: I
iwl3945_disable_events   by writing "1"s into disable bitmap
Jan 26 22:22:26 rainbow kernel: [   33.092997] ieee80211 phy1: I
iwl3945_disable_events   in SRAM at 0x8022c8, size 47 u32s
Jan 26 22:22:26 rainbow kernel: [   33.104059] ieee80211 phy1: U
iwl3945_alive_start Runtime Alive received.
Jan 26 22:22:26 rainbow kernel: [   33.104071] ieee80211 phy1: U
iwl3945_verify_inst_sparse ucode inst image size is 900
Jan 26 22:22:26 rainbow kernel: [   33.104158] ieee80211 phy1: U
iwl3945_verify_inst_sparse ucode inst image size is 2672
Jan 26 22:22:26 rainbow kernel: [   33.104243] ieee80211 phy1: U
iwl3945_verify_inst_sparse ucode inst image size is 80684
Jan 26 22:22:26 rainbow kernel: [   33.112035] ieee80211 phy1: U
iwl3945_verify_ucode Runtime uCode is good in inst SRAM
Jan 26 22:22:26 rainbow kernel: [   33.112073] ieee80211 phy1: U
iwl3945_alive_start RFKILL status: 0x1
Jan 26 22:22:26 rainbow kernel: [   33.112103] ieee80211 phy1: U
iwl3945_update_power_cmd Flags value = 0x00000008
Jan 26 22:22:26 rainbow kernel: [   33.112112] ieee80211 phy1: U
iwl3945_update_power_cmd Tx timeout = 0
Jan 26 22:22:26 rainbow kernel: [   33.112118] ieee80211 phy1: U
iwl3945_update_power_cmd Rx timeout = 0
Jan 26 22:22:26 rainbow kernel: [   33.112128] ieee80211 phy1: U
iwl3945_update_power_cmd Sleep interval vector = { 0 , 0 , 0 , 0 , 0 }
Jan 26 22:22:26 rainbow kernel: [   33.112144] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command POWER_TABLE_CMD (#77), seq: 0x0400,
36 bytes at 0[0]:4
Jan 26 22:22:26 rainbow kernel: [   33.112229] ieee80211 phy1: I
iwl3945_rx_handle r 3 i 2 No handler needed for POWER_TABLE_CMD, 0x77
Jan 26 22:22:26 rainbow kernel: [   33.112506] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_BT_CONFIG (#9b), seq: 0x0401,
16 bytes at 1[1]:4
Jan 26 22:22:26 rainbow kernel: [   33.112582] ieee80211 phy1: I
iwl3945_rx_handle r 4 i 3 No handler needed for REPLY_BT_CONFIG, 0x9b
Jan 26 22:22:26 rainbow kernel: [   33.112642] ieee80211 phy1: U
iwl3945_commit_rxon Sending RXON
Jan 26 22:22:26 rainbow kernel: [   33.112645] * without RXON_FILTER_ASSOC_MSK
Jan 26 22:22:26 rainbow kernel: [   33.112648] * channel = 11
Jan 26 22:22:26 rainbow kernel: [   33.112649] * bssid = 00:00:00:00:00:00
Jan 26 22:22:26 rainbow kernel: [   33.112670] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x0402, 48
bytes at 2[2]:4
Jan 26 22:22:26 rainbow kernel: [   33.113888] ieee80211 phy1: I
iwl3945_rx_handle r 5 i 4 No handler needed for REPLY_RXON, 0x10
Jan 26 22:22:26 rainbow kernel: [   33.113946] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x0d
Jan 26 22:22:26 rainbow kernel: [   33.113959] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x0f
Jan 26 22:22:26 rainbow kernel: [   33.113969] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x05
Jan 26 22:22:26 rainbow kernel: [   33.113977] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x07
Jan 26 22:22:26 rainbow kernel: [   33.113985] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x09
Jan 26 22:22:26 rainbow kernel: [   33.113995] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x0b
Jan 26 22:22:26 rainbow kernel: [   33.114003] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x01
Jan 26 22:22:26 rainbow kernel: [   33.114011] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x03
Jan 26 22:22:26 rainbow kernel: [   33.114021] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x0a
Jan 26 22:22:26 rainbow kernel: [   33.114029] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x14
Jan 26 22:22:26 rainbow kernel: [   33.114038] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x37
Jan 26 22:22:26 rainbow kernel: [   33.114048] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x6e
Jan 26 22:22:26 rainbow kernel: [   33.114061] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq:
0x0403, 56 bytes at 3[3]:4
Jan 26 22:22:26 rainbow kernel: [   33.114162] ieee80211 phy1: I
iwl3945_rx_handle r 6 i 5 No handler needed for
REPLY_TX_PWR_TABLE_CMD, 0x97
Jan 26 22:22:26 rainbow kernel: [   33.114272] ieee80211 phy1: U
iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
Jan 26 22:22:26 rainbow kernel: [   33.114286] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0404, 68
bytes at 4[4]:4
Jan 26 22:22:26 rainbow kernel: [   33.114397] ieee80211 phy1: I
iwl3945_rx_handle r = 7, i = 6, REPLY_ADD_STA, 0x18
Jan 26 22:22:26 rainbow kernel: [   33.114426] ieee80211 phy1: U
iwl_sta_ucode_activate Added STA to Ucode: 00:00:00:00:00:00
Jan 26 22:22:26 rainbow kernel: [   33.114435] ieee80211 phy1: U
iwl_send_add_sta REPLY_ADD_STA PASSED
Jan 26 22:22:26 rainbow kernel: [   33.114449] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0405,
56 bytes at 5[5]:4
Jan 26 22:22:26 rainbow kernel: [   33.114558] ieee80211 phy1: I
iwl3945_rx_handle r 8 i 7 No handler needed for REPLY_RATE_SCALE, 0x47
Jan 26 22:22:26 rainbow kernel: [   33.114592] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0406,
56 bytes at 6[6]:4
Jan 26 22:22:26 rainbow kernel: [   33.114671] ieee80211 phy1: I
iwl3945_rx_handle r 9 i 8 No handler needed for REPLY_RATE_SCALE, 0x47
Jan 26 22:22:26 rainbow kernel: [   33.114724] ieee80211 phy1: U
iwl3945_hw_reg_txpower_get_temperature Temperature: 72
Jan 26 22:22:26 rainbow kernel: [   33.114735] ieee80211 phy1: U
is_temp_calib_needed Getting warmer, delta 10,
Jan 26 22:22:26 rainbow kernel: [   33.114742] ieee80211 phy1: U
is_temp_calib_needed Timed thermal calib needed
Jan 26 22:22:26 rainbow kernel: [   33.114763] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x0d
Jan 26 22:22:26 rainbow kernel: [   33.114771] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x0f
Jan 26 22:22:26 rainbow kernel: [   33.114780] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x05
Jan 26 22:22:26 rainbow kernel: [   33.114789] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x07
Jan 26 22:22:26 rainbow kernel: [   33.114797] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x09
Jan 26 22:22:26 rainbow kernel: [   33.114807] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x0b
Jan 26 22:22:26 rainbow kernel: [   33.114816] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x01
Jan 26 22:22:26 rainbow kernel: [   33.114824] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x03
Jan 26 22:22:26 rainbow kernel: [   33.114835] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x0a
Jan 26 22:22:26 rainbow kernel: [   33.114843] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x14
Jan 26 22:22:26 rainbow kernel: [   33.114852] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x37
Jan 26 22:22:26 rainbow kernel: [   33.114862] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x6e
Jan 26 22:22:26 rainbow kernel: [   33.114873] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq:
0x0407, 56 bytes at 7[7]:4
Jan 26 22:22:26 rainbow kernel: [   33.115210] ieee80211 phy1: I
iwl3945_rx_handle r 10 i 9 No handler needed for
REPLY_TX_PWR_TABLE_CMD, 0x97
Jan 26 22:22:26 rainbow kernel: [   33.116874] Registered led device:
iwl-phy1:radio
Jan 26 22:22:26 rainbow kernel: [   33.116887] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0408, 12
bytes at 8[8]:4
Jan 26 22:22:26 rainbow kernel: [   33.116966] ieee80211 phy1: I
iwl3945_rx_handle r 11 i 10 No handler needed for REPLY_LEDS_CMD, 0x48
Jan 26 22:22:26 rainbow kernel: [   33.118439] Registered led device:
iwl-phy1:assoc
Jan 26 22:22:26 rainbow kernel: [   33.121714] Registered led device:
iwl-phy1:RX
Jan 26 22:22:26 rainbow kernel: [   33.121760] Registered led device:
iwl-phy1:TX
Jan 26 22:22:26 rainbow kernel: [   33.121767] ieee80211 phy1: U
iwl3945_alive_start ALIVE processing complete.
Jan 26 22:22:26 rainbow kernel: [   33.146564] ieee80211 phy1: I
iwl3945_rx_handle r = 12, i = 11, REPLY_3945_RX, 0x1b
Jan 26 22:22:26 rainbow kernel: [   33.167070] ieee80211 phy1: I
iwl3945_rx_handle r = 13, i = 12, REPLY_3945_RX, 0x1b
Jan 26 22:22:26 rainbow kernel: [   33.169094] ieee80211 phy1: I
iwl3945_rx_handle r = 14, i = 13, REPLY_3945_RX, 0x1b
Jan 26 22:22:26 rainbow kernel: [   33.172277] ieee80211 phy1: I
iwl3945_rx_handle r = 15, i = 14, REPLY_3945_RX, 0x1b
Jan 26 22:22:26 rainbow kernel: [   33.176075] ieee80211 phy1: I
iwl3945_rx_handle r = 16, i = 15, REPLY_3945_RX, 0x1b
Jan 26 22:22:26 rainbow kernel: [   33.209226] ieee80211 phy1: I
iwl3945_rx_handle r = 17, i = 16, REPLY_3945_RX, 0x1b
Jan 26 22:22:26 rainbow kernel: [   33.213079] ieee80211 phy1: I
iwl3945_rx_handle r = 18, i = 17, REPLY_3945_RX, 0x1b
Jan 26 22:22:26 rainbow kernel: [   33.233023] wlan0: authenticate
with AP 00:30:bd:c0:90:24
Jan 26 22:22:26 rainbow kernel: [   33.233039] ieee80211 phy1: I
iwl3945_mac_tx enter
Jan 26 22:22:26 rainbow kernel: [   33.233050] ieee80211 phy1: I
iwl3945_mac_tx leave
Jan 26 22:22:26 rainbow kernel: [   33.233254] ieee80211 phy1: I
iwl3945_rx_handle r = 19, i = 18, REPLY_TX, 0x1c
Jan 26 22:22:26 rainbow kernel: [   33.433031] wlan0: authentication
with AP 00:30:bd:c0:90:24 timed out
Jan 26 22:22:28 rainbow kernel: [   35.100111] eth0: no IPv6 routers present
Jan 26 22:22:29 rainbow kernel: [   35.878325] usb 5-2: USB
disconnect, address 2
Jan 26 22:22:44 rainbow kernel: [   51.176200] ieee80211 phy1: U
iwl3945_mac_hw_scan enter
Jan 26 22:22:44 rainbow kernel: [   51.176222] ieee80211 phy1: U
iwl3945_scan_initiate Starting scan...
Jan 26 22:22:44 rainbow kernel: [   51.176235] ieee80211 phy1: U
iwl3945_mac_hw_scan leave
Jan 26 22:22:44 rainbow kernel: [   51.176249] ieee80211 phy1: U
iwl3945_bg_request_scan Kicking off one indirect scan.
Jan 26 22:22:44 rainbow kernel: [   51.176263] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 1 [ACTIVE 39]
Jan 26 22:22:44 rainbow kernel: [   51.176271] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 2 [ACTIVE 39]
Jan 26 22:22:44 rainbow kernel: [   51.176279] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 3 [ACTIVE 39]
Jan 26 22:22:44 rainbow kernel: [   51.176287] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 4 [ACTIVE 39]
Jan 26 22:22:44 rainbow kernel: [   51.176294] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 5 [ACTIVE 39]
Jan 26 22:22:44 rainbow kernel: [   51.176303] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 6 [ACTIVE 39]
Jan 26 22:22:44 rainbow kernel: [   51.176312] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 7 [ACTIVE 39]
Jan 26 22:22:44 rainbow kernel: [   51.176321] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 8 [ACTIVE 39]
Jan 26 22:22:44 rainbow kernel: [   51.176329] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 9 [ACTIVE 39]
Jan 26 22:22:44 rainbow kernel: [   51.176337] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 10 [ACTIVE 39]
Jan 26 22:22:44 rainbow kernel: [   51.176345] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 11 [ACTIVE 39]
Jan 26 22:22:44 rainbow kernel: [   51.176353] ieee80211 phy1: U
iwl3945_get_channels_for_scan total channels to scan 11
Jan 26 22:22:44 rainbow kernel: [   51.176371] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x4409,
350 bytes at 9[32]:4
Jan 26 22:22:45 rainbow kernel: [   51.676058] iwl3945 0000:03:00.0:
Error sending REPLY_SCAN_CMD: time out after 500ms.
Jan 26 22:22:45 rainbow kernel: [   51.676087] ieee80211 phy1: U
iwl_bg_scan_completed SCAN complete scan
Jan 26 22:22:45 rainbow kernel: [   51.676116] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x0d
Jan 26 22:22:45 rainbow kernel: [   51.676125] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x0f
Jan 26 22:22:45 rainbow kernel: [   51.676133] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x05
Jan 26 22:22:45 rainbow kernel: [   51.676142] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x07
Jan 26 22:22:45 rainbow kernel: [   51.676150] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x09
Jan 26 22:22:45 rainbow kernel: [   51.676158] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x0b
Jan 26 22:22:45 rainbow kernel: [   51.676167] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x01
Jan 26 22:22:45 rainbow kernel: [   51.676175] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x03
Jan 26 22:22:45 rainbow kernel: [   51.676183] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x0a
Jan 26 22:22:45 rainbow kernel: [   51.676192] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x14
Jan 26 22:22:45 rainbow kernel: [   51.676201] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x37
Jan 26 22:22:45 rainbow kernel: [   51.676209] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x6e
Jan 26 22:22:45 rainbow kernel: [   51.676225] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq:
0x040A, 56 bytes at 10[10]:4
Jan 26 22:22:45 rainbow kernel: [   52.176098] iwl3945 0000:03:00.0:
Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms.
Jan 26 22:22:51 rainbow kernel: [   57.692036] hda_intel:
azx_get_response timeout, switching to polling mode: last
cmd=0x002f000a
Jan 26 22:23:01 rainbow kernel: [   68.034879] ieee80211 phy1: U
iwl3945_mac_hw_scan enter
Jan 26 22:23:01 rainbow kernel: [   68.034902] ieee80211 phy1: U
iwl3945_mac_hw_scan direct scan for WLAN [4]
Jan 26 22:23:01 rainbow kernel: [   68.034905]  <3>ieee80211 phy1: U
iwl3945_scan_initiate Starting scan...
Jan 26 22:23:01 rainbow kernel: [   68.034925] ieee80211 phy1: U
iwl3945_mac_hw_scan leave
Jan 26 22:23:01 rainbow kernel: [   68.034940] ieee80211 phy1: U
iwl3945_bg_request_scan Kicking off one direct scan for 'WLAN'
Jan 26 22:23:01 rainbow kernel: [   68.034953] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 1 [ACTIVE 42]
Jan 26 22:23:01 rainbow kernel: [   68.034961] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 2 [ACTIVE 42]
Jan 26 22:23:01 rainbow kernel: [   68.034969] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 3 [ACTIVE 42]
Jan 26 22:23:01 rainbow kernel: [   68.034978] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 4 [ACTIVE 42]
Jan 26 22:23:01 rainbow kernel: [   68.034985] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 5 [ACTIVE 42]
Jan 26 22:23:01 rainbow kernel: [   68.034993] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 6 [ACTIVE 42]
Jan 26 22:23:01 rainbow kernel: [   68.035023] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 7 [ACTIVE 42]
Jan 26 22:23:01 rainbow kernel: [   68.035031] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 8 [ACTIVE 42]
Jan 26 22:23:01 rainbow kernel: [   68.035038] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 9 [ACTIVE 42]
Jan 26 22:23:01 rainbow kernel: [   68.035047] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 10 [ACTIVE 42]
Jan 26 22:23:01 rainbow kernel: [   68.035055] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 11 [ACTIVE 42]
Jan 26 22:23:01 rainbow kernel: [   68.035062] ieee80211 phy1: U
iwl3945_get_channels_for_scan total channels to scan 11
Jan 26 22:23:01 rainbow kernel: [   68.035080] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x440B,
350 bytes at 11[32]:4
Jan 26 22:23:01 rainbow kernel: [   68.533479] iwl3945 0000:03:00.0:
Error sending REPLY_SCAN_CMD: time out after 500ms.
Jan 26 22:23:01 rainbow kernel: [   68.533505] ieee80211 phy1: U
iwl_bg_scan_completed SCAN complete scan
Jan 26 22:23:01 rainbow kernel: [   68.533534] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x0d
Jan 26 22:23:01 rainbow kernel: [   68.533543] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x0f
Jan 26 22:23:01 rainbow kernel: [   68.533552] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x05
Jan 26 22:23:01 rainbow kernel: [   68.533560] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x07
Jan 26 22:23:01 rainbow kernel: [   68.533569] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x09
Jan 26 22:23:01 rainbow kernel: [   68.533578] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x0b
Jan 26 22:23:01 rainbow kernel: [   68.533586] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x01
Jan 26 22:23:01 rainbow kernel: [   68.533594] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x03
Jan 26 22:23:01 rainbow kernel: [   68.533602] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x0a
Jan 26 22:23:01 rainbow kernel: [   68.533610] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x14
Jan 26 22:23:01 rainbow kernel: [   68.533619] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x37
Jan 26 22:23:01 rainbow kernel: [   68.533628] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x6e
Jan 26 22:23:01 rainbow kernel: [   68.533644] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq:
0x040C, 56 bytes at 12[12]:4
Jan 26 22:23:02 rainbow kernel: [   69.033095] iwl3945 0000:03:00.0:
Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms.
Jan 26 22:23:06 rainbow kernel: [   73.535085] ieee80211 phy1: U
iwl3945_mac_hw_scan enter
Jan 26 22:23:06 rainbow kernel: [   73.535108] ieee80211 phy1: U
iwl3945_scan_initiate Starting scan...
Jan 26 22:23:06 rainbow kernel: [   73.535120] ieee80211 phy1: U
iwl3945_mac_hw_scan leave
Jan 26 22:23:06 rainbow kernel: [   73.535133] ieee80211 phy1: U
iwl3945_bg_request_scan Kicking off one indirect scan.
Jan 26 22:23:06 rainbow kernel: [   73.535146] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 1 [ACTIVE 39]
Jan 26 22:23:06 rainbow kernel: [   73.535154] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 2 [ACTIVE 39]
Jan 26 22:23:06 rainbow kernel: [   73.535163] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 3 [ACTIVE 39]
Jan 26 22:23:06 rainbow kernel: [   73.535170] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 4 [ACTIVE 39]
Jan 26 22:23:06 rainbow kernel: [   73.535178] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 5 [ACTIVE 39]
Jan 26 22:23:06 rainbow kernel: [   73.535186] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 6 [ACTIVE 39]
Jan 26 22:23:06 rainbow kernel: [   73.535210] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 7 [ACTIVE 39]
Jan 26 22:23:06 rainbow kernel: [   73.535218] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 8 [ACTIVE 39]
Jan 26 22:23:06 rainbow kernel: [   73.535226] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 9 [ACTIVE 39]
Jan 26 22:23:06 rainbow kernel: [   73.535234] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 10 [ACTIVE 39]
Jan 26 22:23:06 rainbow kernel: [   73.535241] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 11 [ACTIVE 39]
Jan 26 22:23:06 rainbow kernel: [   73.535249] ieee80211 phy1: U
iwl3945_get_channels_for_scan total channels to scan 11
Jan 26 22:23:06 rainbow kernel: [   73.535266] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x440D,
350 bytes at 13[32]:4
Jan 26 22:23:07 rainbow kernel: [   74.032110] iwl3945 0000:03:00.0:
Error sending REPLY_SCAN_CMD: time out after 500ms.
Jan 26 22:23:07 rainbow kernel: [   74.032130] ieee80211 phy1: U
iwl_bg_scan_completed SCAN complete scan
Jan 26 22:23:07 rainbow kernel: [   74.032155] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x0d
Jan 26 22:23:07 rainbow kernel: [   74.032164] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x0f
Jan 26 22:23:07 rainbow kernel: [   74.032172] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x05
Jan 26 22:23:07 rainbow kernel: [   74.032180] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x07
Jan 26 22:23:07 rainbow kernel: [   74.032188] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x09
Jan 26 22:23:07 rainbow kernel: [   74.032196] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x0b
Jan 26 22:23:07 rainbow kernel: [   74.032204] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x01
Jan 26 22:23:07 rainbow kernel: [   74.032212] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x03
Jan 26 22:23:07 rainbow kernel: [   74.032276] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x0a
Jan 26 22:23:07 rainbow kernel: [   74.032284] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x14
Jan 26 22:23:07 rainbow kernel: [   74.032293] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x37
Jan 26 22:23:07 rainbow kernel: [   74.032301] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x6e
Jan 26 22:23:07 rainbow kernel: [   74.032315] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq:
0x040E, 56 bytes at 14[14]:4
Jan 26 22:23:07 rainbow kernel: [   74.532102] iwl3945 0000:03:00.0:
Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms.
Jan 26 22:23:12 rainbow kernel: [   79.033934] ieee80211 phy1: U
iwl3945_mac_hw_scan enter
Jan 26 22:23:12 rainbow kernel: [   79.033955] ieee80211 phy1: U
iwl3945_mac_hw_scan direct scan for WLAN [4]
Jan 26 22:23:12 rainbow kernel: [   79.033958]  <3>ieee80211 phy1: U
iwl3945_scan_initiate Starting scan...
Jan 26 22:23:12 rainbow kernel: [   79.033977] ieee80211 phy1: U
iwl3945_mac_hw_scan leave
Jan 26 22:23:12 rainbow kernel: [   79.033991] ieee80211 phy1: U
iwl3945_bg_request_scan Kicking off one direct scan for 'WLAN'
Jan 26 22:23:12 rainbow kernel: [   79.034005] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 1 [ACTIVE 42]
Jan 26 22:23:12 rainbow kernel: [   79.034013] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 2 [ACTIVE 42]
Jan 26 22:23:12 rainbow kernel: [   79.034021] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 3 [ACTIVE 42]
Jan 26 22:23:12 rainbow kernel: [   79.034031] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 4 [ACTIVE 42]
Jan 26 22:23:12 rainbow kernel: [   79.034038] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 5 [ACTIVE 42]
Jan 26 22:23:12 rainbow kernel: [   79.034046] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 6 [ACTIVE 42]
Jan 26 22:23:12 rainbow kernel: [   79.034054] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 7 [ACTIVE 42]
Jan 26 22:23:12 rainbow kernel: [   79.034062] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 8 [ACTIVE 42]
Jan 26 22:23:12 rainbow kernel: [   79.034071] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 9 [ACTIVE 42]
Jan 26 22:23:12 rainbow kernel: [   79.034135] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 10 [ACTIVE 42]
Jan 26 22:23:12 rainbow kernel: [   79.034143] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 11 [ACTIVE 42]
Jan 26 22:23:12 rainbow kernel: [   79.034151] ieee80211 phy1: U
iwl3945_get_channels_for_scan total channels to scan 11
Jan 26 22:23:12 rainbow kernel: [   79.034169] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x440F,
350 bytes at 15[32]:4
Jan 26 22:23:12 rainbow kernel: [   79.532101] iwl3945 0000:03:00.0:
Error sending REPLY_SCAN_CMD: time out after 500ms.
Jan 26 22:23:12 rainbow kernel: [   79.532118] ieee80211 phy1: U
iwl_bg_scan_completed SCAN complete scan
Jan 26 22:23:12 rainbow kernel: [   79.532142] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x0d
Jan 26 22:23:12 rainbow kernel: [   79.532151] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x0f
Jan 26 22:23:12 rainbow kernel: [   79.532158] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x05
Jan 26 22:23:12 rainbow kernel: [   79.532167] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x07
Jan 26 22:23:12 rainbow kernel: [   79.532175] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x09
Jan 26 22:23:12 rainbow kernel: [   79.532183] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x0b
Jan 26 22:23:12 rainbow kernel: [   79.532191] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x01
Jan 26 22:23:12 rainbow kernel: [   79.532200] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x03
Jan 26 22:23:12 rainbow kernel: [   79.532208] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x0a
Jan 26 22:23:12 rainbow kernel: [   79.532216] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x14
Jan 26 22:23:12 rainbow kernel: [   79.532224] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x37
Jan 26 22:23:12 rainbow kernel: [   79.532232] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x6e
Jan 26 22:23:12 rainbow kernel: [   79.532246] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq:
0x0410, 56 bytes at 16[16]:4
Jan 26 22:23:13 rainbow kernel: [   80.032097] iwl3945 0000:03:00.0:
Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms.
Jan 26 22:23:17 rainbow kernel: [   84.533688] ieee80211 phy1: U
iwl3945_mac_hw_scan enter
Jan 26 22:23:17 rainbow kernel: [   84.533716] ieee80211 phy1: U
iwl3945_scan_initiate Starting scan...
Jan 26 22:23:17 rainbow kernel: [   84.533729] ieee80211 phy1: U
iwl3945_mac_hw_scan leave
Jan 26 22:23:17 rainbow kernel: [   84.533743] ieee80211 phy1: U
iwl3945_bg_request_scan Kicking off one indirect scan.
Jan 26 22:23:17 rainbow kernel: [   84.533758] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 1 [ACTIVE 39]
Jan 26 22:23:17 rainbow kernel: [   84.533766] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 2 [ACTIVE 39]
Jan 26 22:23:17 rainbow kernel: [   84.533774] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 3 [ACTIVE 39]
Jan 26 22:23:17 rainbow kernel: [   84.533783] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 4 [ACTIVE 39]
Jan 26 22:23:17 rainbow kernel: [   84.533792] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 5 [ACTIVE 39]
Jan 26 22:23:17 rainbow kernel: [   84.533858] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 6 [ACTIVE 39]
Jan 26 22:23:17 rainbow kernel: [   84.533865] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 7 [ACTIVE 39]
Jan 26 22:23:17 rainbow kernel: [   84.533873] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 8 [ACTIVE 39]
Jan 26 22:23:17 rainbow kernel: [   84.533881] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 9 [ACTIVE 39]
Jan 26 22:23:17 rainbow kernel: [   84.533889] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 10 [ACTIVE 39]
Jan 26 22:23:17 rainbow kernel: [   84.533897] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 11 [ACTIVE 39]
Jan 26 22:23:17 rainbow kernel: [   84.533904] ieee80211 phy1: U
iwl3945_get_channels_for_scan total channels to scan 11
Jan 26 22:23:17 rainbow kernel: [   84.533922] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x4411,
350 bytes at 17[32]:4
Jan 26 22:23:18 rainbow kernel: [   85.038572] iwl3945 0000:03:00.0:
Error sending REPLY_SCAN_CMD: time out after 500ms.
Jan 26 22:23:18 rainbow kernel: [   85.038599] ieee80211 phy1: U
iwl_bg_scan_completed SCAN complete scan
Jan 26 22:23:18 rainbow kernel: [   85.038629] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x0d
Jan 26 22:23:18 rainbow kernel: [   85.038637] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x0f
Jan 26 22:23:18 rainbow kernel: [   85.038646] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x05
Jan 26 22:23:18 rainbow kernel: [   85.038654] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x07
Jan 26 22:23:18 rainbow kernel: [   85.038662] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x09
Jan 26 22:23:18 rainbow kernel: [   85.038670] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x0b
Jan 26 22:23:18 rainbow kernel: [   85.038678] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x01
Jan 26 22:23:18 rainbow kernel: [   85.038687] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x03
Jan 26 22:23:18 rainbow kernel: [   85.038695] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x0a
Jan 26 22:23:18 rainbow kernel: [   85.038705] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x14
Jan 26 22:23:18 rainbow kernel: [   85.038760] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x37
Jan 26 22:23:18 rainbow kernel: [   85.038768] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x6e
Jan 26 22:23:18 rainbow kernel: [   85.038785] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq:
0x0412, 56 bytes at 18[18]:4
Jan 26 22:23:18 rainbow kernel: [   85.537076] iwl3945 0000:03:00.0:
Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms.
Jan 26 22:23:23 rainbow kernel: [   90.040264] ieee80211 phy1: U
iwl3945_mac_hw_scan enter
Jan 26 22:23:23 rainbow kernel: [   90.040285] ieee80211 phy1: U
iwl3945_mac_hw_scan direct scan for WLAN [4]
Jan 26 22:23:23 rainbow kernel: [   90.040288]  <3>ieee80211 phy1: U
iwl3945_scan_initiate Starting scan...
Jan 26 22:23:23 rainbow kernel: [   90.040309] ieee80211 phy1: U
iwl3945_mac_hw_scan leave
Jan 26 22:23:23 rainbow kernel: [   90.040323] ieee80211 phy1: U
iwl3945_bg_request_scan Kicking off one direct scan for 'WLAN'
Jan 26 22:23:23 rainbow kernel: [   90.040335] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 1 [ACTIVE 42]
Jan 26 22:23:23 rainbow kernel: [   90.040345] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 2 [ACTIVE 42]
Jan 26 22:23:23 rainbow kernel: [   90.040353] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 3 [ACTIVE 42]
Jan 26 22:23:23 rainbow kernel: [   90.040361] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 4 [ACTIVE 42]
Jan 26 22:23:23 rainbow kernel: [   90.040369] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 5 [ACTIVE 42]
Jan 26 22:23:23 rainbow kernel: [   90.040377] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 6 [ACTIVE 42]
Jan 26 22:23:23 rainbow kernel: [   90.040385] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 7 [ACTIVE 42]
Jan 26 22:23:23 rainbow kernel: [   90.040393] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 8 [ACTIVE 42]
Jan 26 22:23:23 rainbow kernel: [   90.040401] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 9 [ACTIVE 42]
Jan 26 22:23:23 rainbow kernel: [   90.040409] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 10 [ACTIVE 42]
Jan 26 22:23:23 rainbow kernel: [   90.040473] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 11 [ACTIVE 42]
Jan 26 22:23:23 rainbow kernel: [   90.040481] ieee80211 phy1: U
iwl3945_get_channels_for_scan total channels to scan 11
Jan 26 22:23:23 rainbow kernel: [   90.040497] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x4413,
350 bytes at 19[32]:4
Jan 26 22:23:23 rainbow kernel: [   90.540105] iwl3945 0000:03:00.0:
Error sending REPLY_SCAN_CMD: time out after 500ms.
Jan 26 22:23:23 rainbow kernel: [   90.540123] ieee80211 phy1: U
iwl_bg_scan_completed SCAN complete scan
Jan 26 22:23:23 rainbow kernel: [   90.540147] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x0d
Jan 26 22:23:23 rainbow kernel: [   90.540156] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x0f
Jan 26 22:23:23 rainbow kernel: [   90.540164] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x05
Jan 26 22:23:23 rainbow kernel: [   90.540172] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x07
Jan 26 22:23:23 rainbow kernel: [   90.540181] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x09
Jan 26 22:23:23 rainbow kernel: [   90.540189] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x0b
Jan 26 22:23:23 rainbow kernel: [   90.540197] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x01
Jan 26 22:23:23 rainbow kernel: [   90.540205] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x03
Jan 26 22:23:23 rainbow kernel: [   90.540213] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x0a
Jan 26 22:23:23 rainbow kernel: [   90.540222] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x14
Jan 26 22:23:23 rainbow kernel: [   90.540230] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x37
Jan 26 22:23:23 rainbow kernel: [   90.540239] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x6e
Jan 26 22:23:23 rainbow kernel: [   90.540252] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq:
0x0414, 56 bytes at 20[20]:4
Jan 26 22:23:24 rainbow kernel: [   91.040100] iwl3945 0000:03:00.0:
Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms.
Jan 26 22:23:26 rainbow kernel: [   93.112110] ieee80211 phy1: U
iwl3945_hw_reg_txpower_get_temperature Temperature: 72
Jan 26 22:23:26 rainbow kernel: [   93.112128] ieee80211 phy1: U
is_temp_calib_needed Same temp,
Jan 26 22:23:26 rainbow kernel: [   93.112136] ieee80211 phy1: U
is_temp_calib_needed Timed thermal calib not needed
Jan 26 22:23:28 rainbow kernel: [   95.541907] ieee80211 phy1: U
iwl3945_mac_hw_scan enter
Jan 26 22:23:28 rainbow kernel: [   95.541928] ieee80211 phy1: U
iwl3945_scan_initiate Starting scan...
Jan 26 22:23:28 rainbow kernel: [   95.541941] ieee80211 phy1: U
iwl3945_mac_hw_scan leave
Jan 26 22:23:28 rainbow kernel: [   95.541955] ieee80211 phy1: U
iwl3945_bg_request_scan Kicking off one indirect scan.
Jan 26 22:23:28 rainbow kernel: [   95.541968] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 1 [ACTIVE 39]
Jan 26 22:23:28 rainbow kernel: [   95.541977] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 2 [ACTIVE 39]
Jan 26 22:23:28 rainbow kernel: [   95.541985] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 3 [ACTIVE 39]
Jan 26 22:23:28 rainbow kernel: [   95.541992] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 4 [ACTIVE 39]
Jan 26 22:23:28 rainbow kernel: [   95.542056] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 5 [ACTIVE 39]
Jan 26 22:23:28 rainbow kernel: [   95.542064] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 6 [ACTIVE 39]
Jan 26 22:23:28 rainbow kernel: [   95.542071] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 7 [ACTIVE 39]
Jan 26 22:23:28 rainbow kernel: [   95.542079] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 8 [ACTIVE 39]
Jan 26 22:23:28 rainbow kernel: [   95.542087] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 9 [ACTIVE 39]
Jan 26 22:23:28 rainbow kernel: [   95.542095] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 10 [ACTIVE 39]
Jan 26 22:23:28 rainbow kernel: [   95.542103] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 11 [ACTIVE 39]
Jan 26 22:23:28 rainbow kernel: [   95.542111] ieee80211 phy1: U
iwl3945_get_channels_for_scan total channels to scan 11
Jan 26 22:23:28 rainbow kernel: [   95.542127] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x4415,
350 bytes at 21[32]:4
Jan 26 22:23:29 rainbow kernel: [   96.040099] iwl3945 0000:03:00.0:
Error sending REPLY_SCAN_CMD: time out after 500ms.
Jan 26 22:23:29 rainbow kernel: [   96.040118] ieee80211 phy1: U
iwl_bg_scan_completed SCAN complete scan
Jan 26 22:23:29 rainbow kernel: [   96.040143] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x0d
Jan 26 22:23:29 rainbow kernel: [   96.040152] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x0f
Jan 26 22:23:29 rainbow kernel: [   96.040160] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x05
Jan 26 22:23:29 rainbow kernel: [   96.040168] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x07
Jan 26 22:23:29 rainbow kernel: [   96.040177] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x09
Jan 26 22:23:29 rainbow kernel: [   96.040185] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x0b
Jan 26 22:23:29 rainbow kernel: [   96.040192] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x01
Jan 26 22:23:29 rainbow kernel: [   96.040200] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x03
Jan 26 22:23:29 rainbow kernel: [   96.040210] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x0a
Jan 26 22:23:29 rainbow kernel: [   96.040219] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x14
Jan 26 22:23:29 rainbow kernel: [   96.040227] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x37
Jan 26 22:23:29 rainbow kernel: [   96.040235] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x6e
Jan 26 22:23:29 rainbow kernel: [   96.040249] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq:
0x0416, 56 bytes at 22[22]:4
Jan 26 22:23:29 rainbow kernel: [   96.540101] iwl3945 0000:03:00.0:
Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms.
Jan 26 22:23:34 rainbow kernel: [  101.041714] ieee80211 phy1: U
iwl3945_mac_hw_scan enter
Jan 26 22:23:34 rainbow kernel: [  101.041736] ieee80211 phy1: U
iwl3945_mac_hw_scan direct scan for WLAN [4]
Jan 26 22:23:34 rainbow kernel: [  101.041739]  <3>ieee80211 phy1: U
iwl3945_scan_initiate Starting scan...
Jan 26 22:23:34 rainbow kernel: [  101.041760] ieee80211 phy1: U
iwl3945_mac_hw_scan leave
Jan 26 22:23:34 rainbow kernel: [  101.041775] ieee80211 phy1: U
iwl3945_bg_request_scan Kicking off one direct scan for 'WLAN'
Jan 26 22:23:34 rainbow kernel: [  101.041788] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 1 [ACTIVE 42]
Jan 26 22:23:34 rainbow kernel: [  101.041796] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 2 [ACTIVE 42]
Jan 26 22:23:34 rainbow kernel: [  101.041860] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 3 [ACTIVE 42]
Jan 26 22:23:34 rainbow kernel: [  101.041868] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 4 [ACTIVE 42]
Jan 26 22:23:34 rainbow kernel: [  101.041876] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 5 [ACTIVE 42]
Jan 26 22:23:34 rainbow kernel: [  101.041883] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 6 [ACTIVE 42]
Jan 26 22:23:34 rainbow kernel: [  101.041891] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 7 [ACTIVE 42]
Jan 26 22:23:34 rainbow kernel: [  101.041898] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 8 [ACTIVE 42]
Jan 26 22:23:34 rainbow kernel: [  101.041906] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 9 [ACTIVE 42]
Jan 26 22:23:34 rainbow kernel: [  101.041914] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 10 [ACTIVE 42]
Jan 26 22:23:34 rainbow kernel: [  101.041921] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 11 [ACTIVE 42]
Jan 26 22:23:34 rainbow kernel: [  101.041929] ieee80211 phy1: U
iwl3945_get_channels_for_scan total channels to scan 11
Jan 26 22:23:34 rainbow kernel: [  101.041946] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x4417,
350 bytes at 23[32]:4
Jan 26 22:23:34 rainbow kernel: [  101.540100] iwl3945 0000:03:00.0:
Error sending REPLY_SCAN_CMD: time out after 500ms.
Jan 26 22:23:34 rainbow kernel: [  101.540119] ieee80211 phy1: U
iwl_bg_scan_completed SCAN complete scan
Jan 26 22:23:34 rainbow kernel: [  101.540145] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x0d
Jan 26 22:23:34 rainbow kernel: [  101.540154] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x0f
Jan 26 22:23:34 rainbow kernel: [  101.540162] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x05
Jan 26 22:23:34 rainbow kernel: [  101.540171] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x07
Jan 26 22:23:34 rainbow kernel: [  101.540180] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x09
Jan 26 22:23:34 rainbow kernel: [  101.540188] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x0b
Jan 26 22:23:34 rainbow kernel: [  101.540197] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x01
Jan 26 22:23:34 rainbow kernel: [  101.540205] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x03
Jan 26 22:23:34 rainbow kernel: [  101.540214] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x0a
Jan 26 22:23:34 rainbow kernel: [  101.540222] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x14
Jan 26 22:23:34 rainbow kernel: [  101.540231] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x37
Jan 26 22:23:34 rainbow kernel: [  101.540239] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x6e
Jan 26 22:23:34 rainbow kernel: [  101.540252] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq:
0x0418, 56 bytes at 24[24]:4
Jan 26 22:23:35 rainbow kernel: [  102.040099] iwl3945 0000:03:00.0:
Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms.
Jan 26 22:23:39 rainbow kernel: [  106.541695] ieee80211 phy1: U
iwl3945_mac_hw_scan enter
Jan 26 22:23:39 rainbow kernel: [  106.541717] ieee80211 phy1: U
iwl3945_scan_initiate Starting scan...
Jan 26 22:23:39 rainbow kernel: [  106.541730] ieee80211 phy1: U
iwl3945_mac_hw_scan leave
Jan 26 22:23:39 rainbow kernel: [  106.541744] ieee80211 phy1: U
iwl3945_bg_request_scan Kicking off one indirect scan.
Jan 26 22:23:39 rainbow kernel: [  106.541757] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 1 [ACTIVE 39]
Jan 26 22:23:39 rainbow kernel: [  106.541764] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 2 [ACTIVE 39]
Jan 26 22:23:39 rainbow kernel: [  106.541772] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 3 [ACTIVE 39]
Jan 26 22:23:39 rainbow kernel: [  106.541780] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 4 [ACTIVE 39]
Jan 26 22:23:39 rainbow kernel: [  106.541788] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 5 [ACTIVE 39]
Jan 26 22:23:39 rainbow kernel: [  106.541797] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 6 [ACTIVE 39]
Jan 26 22:23:39 rainbow kernel: [  106.541861] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 7 [ACTIVE 39]
Jan 26 22:23:39 rainbow kernel: [  106.541869] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 8 [ACTIVE 39]
Jan 26 22:23:39 rainbow kernel: [  106.541876] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 9 [ACTIVE 39]
Jan 26 22:23:39 rainbow kernel: [  106.541884] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 10 [ACTIVE 39]
Jan 26 22:23:39 rainbow kernel: [  106.541893] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 11 [ACTIVE 39]
Jan 26 22:23:39 rainbow kernel: [  106.541900] ieee80211 phy1: U
iwl3945_get_channels_for_scan total channels to scan 11
Jan 26 22:23:39 rainbow kernel: [  106.541917] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x4419,
350 bytes at 25[32]:4
Jan 26 22:23:40 rainbow kernel: [  107.040099] iwl3945 0000:03:00.0:
Error sending REPLY_SCAN_CMD: time out after 500ms.
Jan 26 22:23:40 rainbow kernel: [  107.040117] ieee80211 phy1: U
iwl_bg_scan_completed SCAN complete scan
Jan 26 22:23:40 rainbow kernel: [  107.040141] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x0d
Jan 26 22:23:40 rainbow kernel: [  107.040150] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x0f
Jan 26 22:23:40 rainbow kernel: [  107.040159] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x05
Jan 26 22:23:40 rainbow kernel: [  107.040167] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x07
Jan 26 22:23:40 rainbow kernel: [  107.040175] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x09
Jan 26 22:23:40 rainbow kernel: [  107.040183] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x0b
Jan 26 22:23:40 rainbow kernel: [  107.040246] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x01
Jan 26 22:23:40 rainbow kernel: [  107.040254] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x03
Jan 26 22:23:40 rainbow kernel: [  107.040262] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x0a
Jan 26 22:23:40 rainbow kernel: [  107.040270] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x14
Jan 26 22:23:40 rainbow kernel: [  107.040279] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x37
Jan 26 22:23:40 rainbow kernel: [  107.040287] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x6e
Jan 26 22:23:40 rainbow kernel: [  107.040300] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq:
0x041A, 56 bytes at 26[26]:4
Jan 26 22:23:40 rainbow kernel: [  107.540102] iwl3945 0000:03:00.0:
Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms.
Jan 26 22:23:45 rainbow kernel: [  112.041733] ieee80211 phy1: U
iwl3945_mac_hw_scan enter
Jan 26 22:23:45 rainbow kernel: [  112.041756] ieee80211 phy1: U
iwl3945_mac_hw_scan direct scan for WLAN [4]
Jan 26 22:23:45 rainbow kernel: [  112.041759]  <3>ieee80211 phy1: U
iwl3945_scan_initiate Starting scan...
Jan 26 22:23:45 rainbow kernel: [  112.041780] ieee80211 phy1: U
iwl3945_mac_hw_scan leave
Jan 26 22:23:45 rainbow kernel: [  112.041796] ieee80211 phy1: U
iwl3945_bg_request_scan Kicking off one direct scan for 'WLAN'
Jan 26 22:23:45 rainbow kernel: [  112.041810] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 1 [ACTIVE 42]
Jan 26 22:23:45 rainbow kernel: [  112.041818] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 2 [ACTIVE 42]
Jan 26 22:23:45 rainbow kernel: [  112.041826] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 3 [ACTIVE 42]
Jan 26 22:23:45 rainbow kernel: [  112.041833] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 4 [ACTIVE 42]
Jan 26 22:23:45 rainbow kernel: [  112.041841] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 5 [ACTIVE 42]
Jan 26 22:23:45 rainbow kernel: [  112.041867] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 6 [ACTIVE 42]
Jan 26 22:23:45 rainbow kernel: [  112.041875] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 7 [ACTIVE 42]
Jan 26 22:23:45 rainbow kernel: [  112.041882] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 8 [ACTIVE 42]
Jan 26 22:23:45 rainbow kernel: [  112.041890] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 9 [ACTIVE 42]
Jan 26 22:23:45 rainbow kernel: [  112.041897] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 10 [ACTIVE 42]
Jan 26 22:23:45 rainbow kernel: [  112.041905] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 11 [ACTIVE 42]
Jan 26 22:23:45 rainbow kernel: [  112.041912] ieee80211 phy1: U
iwl3945_get_channels_for_scan total channels to scan 11
Jan 26 22:23:45 rainbow kernel: [  112.041929] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x441B,
350 bytes at 27[32]:4
Jan 26 22:23:45 rainbow kernel: [  112.540110] iwl3945 0000:03:00.0:
Error sending REPLY_SCAN_CMD: time out after 500ms.
Jan 26 22:23:45 rainbow kernel: [  112.540124] ieee80211 phy1: U
iwl_bg_scan_completed SCAN complete scan
Jan 26 22:23:45 rainbow kernel: [  112.540146] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x0d
Jan 26 22:23:45 rainbow kernel: [  112.540155] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x0f
Jan 26 22:23:45 rainbow kernel: [  112.540163] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x05
Jan 26 22:23:45 rainbow kernel: [  112.540171] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x07
Jan 26 22:23:45 rainbow kernel: [  112.540180] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x09
Jan 26 22:23:45 rainbow kernel: [  112.540189] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x0b
Jan 26 22:23:45 rainbow kernel: [  112.540198] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x01
Jan 26 22:23:45 rainbow kernel: [  112.540206] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x03
Jan 26 22:23:45 rainbow kernel: [  112.540214] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x0a
Jan 26 22:23:45 rainbow kernel: [  112.540223] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x14
Jan 26 22:23:45 rainbow kernel: [  112.540232] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x37
Jan 26 22:23:45 rainbow kernel: [  112.540241] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x6e
Jan 26 22:23:45 rainbow kernel: [  112.540254] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq:
0x041C, 56 bytes at 28[28]:4
Jan 26 22:23:46 rainbow kernel: [  113.040099] iwl3945 0000:03:00.0:
Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms.
Jan 26 22:23:50 rainbow kernel: [  117.541638] ieee80211 phy1: U
iwl3945_mac_hw_scan enter
Jan 26 22:23:50 rainbow kernel: [  117.541657] ieee80211 phy1: U
iwl3945_scan_initiate Starting scan...
Jan 26 22:23:50 rainbow kernel: [  117.541670] ieee80211 phy1: U
iwl3945_mac_hw_scan leave
Jan 26 22:23:50 rainbow kernel: [  117.541684] ieee80211 phy1: U
iwl3945_bg_request_scan Kicking off one indirect scan.
Jan 26 22:23:50 rainbow kernel: [  117.541696] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 1 [ACTIVE 39]
Jan 26 22:23:50 rainbow kernel: [  117.541704] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 2 [ACTIVE 39]
Jan 26 22:23:50 rainbow kernel: [  117.541711] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 3 [ACTIVE 39]
Jan 26 22:23:50 rainbow kernel: [  117.541721] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 4 [ACTIVE 39]
Jan 26 22:23:50 rainbow kernel: [  117.541728] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 5 [ACTIVE 39]
Jan 26 22:23:50 rainbow kernel: [  117.541736] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 6 [ACTIVE 39]
Jan 26 22:23:50 rainbow kernel: [  117.541759] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 7 [ACTIVE 39]
Jan 26 22:23:50 rainbow kernel: [  117.541767] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 8 [ACTIVE 39]
Jan 26 22:23:50 rainbow kernel: [  117.541775] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 9 [ACTIVE 39]
Jan 26 22:23:50 rainbow kernel: [  117.541783] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 10 [ACTIVE 39]
Jan 26 22:23:50 rainbow kernel: [  117.541791] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 11 [ACTIVE 39]
Jan 26 22:23:50 rainbow kernel: [  117.541799] ieee80211 phy1: U
iwl3945_get_channels_for_scan total channels to scan 11
Jan 26 22:23:50 rainbow kernel: [  117.541815] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x441D,
350 bytes at 29[32]:4
Jan 26 22:23:51 rainbow kernel: [  118.040105] iwl3945 0000:03:00.0:
Error sending REPLY_SCAN_CMD: time out after 500ms.
Jan 26 22:23:51 rainbow kernel: [  118.040130] ieee80211 phy1: U
iwl_bg_scan_completed SCAN complete scan
Jan 26 22:23:51 rainbow kernel: [  118.040157] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x0d
Jan 26 22:23:51 rainbow kernel: [  118.040165] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x0f
Jan 26 22:23:51 rainbow kernel: [  118.040173] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x05
Jan 26 22:23:51 rainbow kernel: [  118.040181] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x07
Jan 26 22:23:51 rainbow kernel: [  118.040190] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x09
Jan 26 22:23:51 rainbow kernel: [  118.040198] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x0b
Jan 26 22:23:51 rainbow kernel: [  118.040206] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x01
Jan 26 22:23:51 rainbow kernel: [  118.040214] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x03
Jan 26 22:23:51 rainbow kernel: [  118.040223] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x0a
Jan 26 22:23:51 rainbow kernel: [  118.040232] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x14
Jan 26 22:23:51 rainbow kernel: [  118.040240] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x37
Jan 26 22:23:51 rainbow kernel: [  118.040249] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x6e
Jan 26 22:23:51 rainbow kernel: [  118.040264] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq:
0x041E, 56 bytes at 30[30]:4
Jan 26 22:23:51 rainbow kernel: [  118.540113] iwl3945 0000:03:00.0:
Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms.
Jan 26 22:23:56 rainbow kernel: [  123.041713] ieee80211 phy1: U
iwl3945_mac_hw_scan enter
Jan 26 22:23:56 rainbow kernel: [  123.041731] ieee80211 phy1: U
iwl3945_mac_hw_scan direct scan for WLAN [4]
Jan 26 22:23:56 rainbow kernel: [  123.041734]  <3>ieee80211 phy1: U
iwl3945_scan_initiate Starting scan...
Jan 26 22:23:56 rainbow kernel: [  123.041754] ieee80211 phy1: U
iwl3945_mac_hw_scan leave
Jan 26 22:23:56 rainbow kernel: [  123.041768] ieee80211 phy1: U
iwl3945_bg_request_scan Kicking off one direct scan for 'WLAN'
Jan 26 22:23:56 rainbow kernel: [  123.041781] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 1 [ACTIVE 42]
Jan 26 22:23:56 rainbow kernel: [  123.041789] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 2 [ACTIVE 42]
Jan 26 22:23:56 rainbow kernel: [  123.041796] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 3 [ACTIVE 42]
Jan 26 22:23:56 rainbow kernel: [  123.041804] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 4 [ACTIVE 42]
Jan 26 22:23:56 rainbow kernel: [  123.041828] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 5 [ACTIVE 42]
Jan 26 22:23:56 rainbow kernel: [  123.041836] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 6 [ACTIVE 42]
Jan 26 22:23:56 rainbow kernel: [  123.041844] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 7 [ACTIVE 42]
Jan 26 22:23:56 rainbow kernel: [  123.041852] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 8 [ACTIVE 42]
Jan 26 22:23:56 rainbow kernel: [  123.041860] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 9 [ACTIVE 42]
Jan 26 22:23:56 rainbow kernel: [  123.041868] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 10 [ACTIVE 42]
Jan 26 22:23:56 rainbow kernel: [  123.041876] ieee80211 phy1: U
iwl3945_get_channels_for_scan Scanning 11 [ACTIVE 42]
Jan 26 22:23:56 rainbow kernel: [  123.041883] ieee80211 phy1: U
iwl3945_get_channels_for_scan total channels to scan 11
Jan 26 22:23:56 rainbow kernel: [  123.041899] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x441F,
350 bytes at 31[32]:4
Jan 26 22:23:56 rainbow kernel: [  123.540100] iwl3945 0000:03:00.0:
Error sending REPLY_SCAN_CMD: time out after 500ms.
Jan 26 22:23:56 rainbow kernel: [  123.540116] ieee80211 phy1: U
iwl_bg_scan_completed SCAN complete scan
Jan 26 22:23:56 rainbow kernel: [  123.540139] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x0d
Jan 26 22:23:56 rainbow kernel: [  123.540147] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x0f
Jan 26 22:23:56 rainbow kernel: [  123.540155] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x05
Jan 26 22:23:56 rainbow kernel: [  123.540163] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x07
Jan 26 22:23:56 rainbow kernel: [  123.540172] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x09
Jan 26 22:23:56 rainbow kernel: [  123.540180] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x0b
Jan 26 22:23:56 rainbow kernel: [  123.540189] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x01
Jan 26 22:23:56 rainbow kernel: [  123.540197] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x03
Jan 26 22:23:56 rainbow kernel: [  123.540206] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x0a
Jan 26 22:23:56 rainbow kernel: [  123.540215] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x14
Jan 26 22:23:56 rainbow kernel: [  123.540224] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x37
Jan 26 22:23:56 rainbow kernel: [  123.540232] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x6e
Jan 26 22:23:56 rainbow kernel: [  123.540245] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq:
0x0420, 56 bytes at 32[0]:4
Jan 26 22:23:57 rainbow kernel: [  124.040104] iwl3945 0000:03:00.0:
Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms.
Jan 26 22:24:01 rainbow kernel: [  128.033725] ieee80211 phy1: U
iwl3945_mac_config enter to channel 11
Jan 26 22:24:01 rainbow kernel: [  128.033757] ieee80211 phy1: U
iwl3945_commit_rxon Sending RXON
Jan 26 22:24:01 rainbow kernel: [  128.033759] * without RXON_FILTER_ASSOC_MSK
Jan 26 22:24:01 rainbow kernel: [  128.033761] * channel = 11
Jan 26 22:24:01 rainbow kernel: [  128.033762] * bssid = 00:00:00:00:00:00
Jan 26 22:24:01 rainbow kernel: [  128.033789] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x0421, 48
bytes at 33[1]:4
Jan 26 22:24:01 rainbow kernel: [  128.533801] iwl3945 0000:03:00.0:
Error sending REPLY_RXON: time out after 500ms.
Jan 26 22:24:01 rainbow kernel: [  128.533815] iwl3945 0000:03:00.0:
Error setting new configuration (-110).
Jan 26 22:24:01 rainbow kernel: [  128.533820] ieee80211 phy1: U
iwl3945_mac_config leave
Jan 26 22:24:01 rainbow kernel: [  128.533827] ieee80211 phy1: U
iwl3945_mac_config_interface bssid: 00:30:bd:c0:90:24
Jan 26 22:24:01 rainbow kernel: [  128.533832] ieee80211 phy1: U
iwl3945_commit_rxon Sending RXON
Jan 26 22:24:01 rainbow kernel: [  128.533833] * without RXON_FILTER_ASSOC_MSK
Jan 26 22:24:01 rainbow kernel: [  128.533834] * channel = 11
Jan 26 22:24:01 rainbow kernel: [  128.533834] * bssid = 00:00:00:00:00:00
Jan 26 22:24:01 rainbow kernel: [  128.533845] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x0422, 48
bytes at 34[2]:4
Jan 26 22:24:02 rainbow kernel: [  129.033072] iwl3945 0000:03:00.0:
Error sending REPLY_RXON: time out after 500ms.
Jan 26 22:24:02 rainbow kernel: [  129.033084] iwl3945 0000:03:00.0:
Error setting new configuration (-110).
Jan 26 22:24:02 rainbow kernel: [  129.033089] ieee80211 phy1: U
iwl3945_add_station Add STA ID 0: 00:00:00:00:00:00
Jan 26 22:24:02 rainbow kernel: [  129.033097] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0423, 68
bytes at 35[3]:4
Jan 26 22:24:02 rainbow kernel: [  129.533177] iwl3945 0000:03:00.0:
Error sending REPLY_ADD_STA: time out after 500ms.
Jan 26 22:24:02 rainbow kernel: [  129.533209] ieee80211 phy1: U
iwl3945_mac_config_interface leave
Jan 26 22:24:02 rainbow kernel: [  129.533222] ieee80211 phy1: U
iwl3945_mac_conf_tx enter
Jan 26 22:24:02 rainbow kernel: [  129.533231] ieee80211 phy1: U
iwl3945_mac_conf_tx leave
Jan 26 22:24:02 rainbow kernel: [  129.533237] ieee80211 phy1: U
iwl3945_mac_conf_tx enter
Jan 26 22:24:02 rainbow kernel: [  129.533244] ieee80211 phy1: U
iwl3945_mac_conf_tx leave
Jan 26 22:24:02 rainbow kernel: [  129.533250] ieee80211 phy1: U
iwl3945_mac_conf_tx enter
Jan 26 22:24:02 rainbow kernel: [  129.533257] ieee80211 phy1: U
iwl3945_mac_conf_tx leave
Jan 26 22:24:02 rainbow kernel: [  129.533263] ieee80211 phy1: U
iwl3945_mac_conf_tx enter
Jan 26 22:24:02 rainbow kernel: [  129.533269] ieee80211 phy1: U
iwl3945_mac_conf_tx leave
Jan 26 22:24:02 rainbow kernel: [  129.533278] ieee80211 phy1: U
iwl3945_mac_reset_tsf enter
Jan 26 22:24:02 rainbow kernel: [  129.533294] ieee80211 phy1: U
iwl3945_commit_rxon Sending RXON
Jan 26 22:24:02 rainbow kernel: [  129.533296] * without RXON_FILTER_ASSOC_MSK
Jan 26 22:24:02 rainbow kernel: [  129.533298] * channel = 11
Jan 26 22:24:02 rainbow kernel: [  129.533299] * bssid = 00:00:00:00:00:00
Jan 26 22:24:02 rainbow kernel: [  129.533324] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x0424, 48
bytes at 36[4]:4
Jan 26 22:24:03 rainbow kernel: [  130.032107] iwl3945 0000:03:00.0:
Error sending REPLY_RXON: time out after 500ms.
Jan 26 22:24:03 rainbow kernel: [  130.032130] iwl3945 0000:03:00.0:
Error setting new configuration (-110).
Jan 26 22:24:03 rainbow kernel: [  130.032140] ieee80211 phy1: U
iwl3945_mac_reset_tsf leave - not in IBSS
Jan 26 22:24:03 rainbow kernel: [  130.032151] wlan0: direct probe to
AP 00:30:bd:c0:90:24 try 1
Jan 26 22:24:03 rainbow kernel: [  130.032176] ieee80211 phy1: I
iwl3945_mac_tx enter
Jan 26 22:24:03 rainbow kernel: [  130.032192] ieee80211 phy1: I
iwl3945_mac_tx leave
Jan 26 22:24:03 rainbow kernel: [  130.032291] iwl3945 0000:03:00.0:
Microcode SW error detected. Restarting 0x82000008.
Jan 26 22:24:03 rainbow kernel: [  130.032329] iwl3945 0000:03:00.0:
Start IWL Error Log Dump:
Jan 26 22:24:03 rainbow kernel: [  130.032337] iwl3945 0000:03:00.0:
Status: 0x000202E4, count: 1
Jan 26 22:24:03 rainbow kernel: [  130.032344] iwl3945 0000:03:00.0:
Desc       Time       asrtPC  blink2 ilink1  nmiPC   Line
Jan 26 22:24:03 rainbow kernel: [  130.032421] iwl3945 0000:03:00.0:
SYSASSERT     (#5) 0096917366 0x0089A 0x0025E 0x00304 0x01BCC 78
Jan 26 22:24:03 rainbow kernel: [  130.032424]
Jan 26 22:24:03 rainbow kernel: [  130.032550] iwl3945 0000:03:00.0:
Start IWL Event Log Dump: display count 512, wraps 1
Jan 26 22:24:03 rainbow kernel: [  130.032587] iwl3945 0000:03:00.0:
0000043832^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.032623] iwl3945 0000:03:00.0:
0000043833^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.032659] iwl3945 0000:03:00.0:
0000044028^I0x000000c4^I0303
Jan 26 22:24:03 rainbow kernel: [  130.032695] iwl3945 0000:03:00.0:
0000044031^I0x00000011^I0357
Jan 26 22:24:03 rainbow kernel: [  130.032730] iwl3945 0000:03:00.0:
0000044417^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.032767] iwl3945 0000:03:00.0:
0000044419^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.032803] iwl3945 0000:03:00.0:
0000044429^I0x00008000^I0350
Jan 26 22:24:03 rainbow kernel: [  130.032839] iwl3945 0000:03:00.0:
0000044516^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.032874] iwl3945 0000:03:00.0:
0000044518^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.032910] iwl3945 0000:03:00.0:
0000044594^I0x0000002f^I0353
Jan 26 22:24:03 rainbow kernel: [  130.032946] iwl3945 0000:03:00.0:
0000044604^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.032982] iwl3945 0000:03:00.0:
0000044710^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.033019] iwl3945 0000:03:00.0:
0000044712^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.033055] iwl3945 0000:03:00.0:
0000044787^I0x00000030^I0353
Jan 26 22:24:03 rainbow kernel: [  130.033091] iwl3945 0000:03:00.0:
0000044798^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.033127] iwl3945 0000:03:00.0:
0000045341^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.033163] iwl3945 0000:03:00.0:
0000045342^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.033200] iwl3945 0000:03:00.0:
0000045529^I0x00000031^I0353
Jan 26 22:24:03 rainbow kernel: [  130.033237] iwl3945 0000:03:00.0:
0000045864^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.033274] iwl3945 0000:03:00.0:
0000045865^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.033311] iwl3945 0000:03:00.0:
0000045947^I0x00000032^I0353
Jan 26 22:24:03 rainbow kernel: [  130.033348] iwl3945 0000:03:00.0:
0000045958^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.033386] iwl3945 0000:03:00.0:
0000045969^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.033423] iwl3945 0000:03:00.0:
0000045971^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.033460] iwl3945 0000:03:00.0:
0000046044^I0x00000033^I0353
Jan 26 22:24:03 rainbow kernel: [  130.033497] iwl3945 0000:03:00.0:
0000046055^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.033535] iwl3945 0000:03:00.0:
0000046345^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.033571] iwl3945 0000:03:00.0:
0000046347^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.033609] iwl3945 0000:03:00.0:
0000046533^I0x00000034^I0353
Jan 26 22:24:03 rainbow kernel: [  130.033647] iwl3945 0000:03:00.0:
0000047166^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.033683] iwl3945 0000:03:00.0:
0000047168^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.033720] iwl3945 0000:03:00.0:
0000047351^I0x00000035^I0353
Jan 26 22:24:03 rainbow kernel: [  130.033764] iwl3945 0000:03:00.0:
0000047768^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.033804] iwl3945 0000:03:00.0:
0000047769^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.033841] iwl3945 0000:03:00.0:
0000047843^I0x00000036^I0353
Jan 26 22:24:03 rainbow kernel: [  130.033878] iwl3945 0000:03:00.0:
0000047854^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.033915] iwl3945 0000:03:00.0:
0000047878^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.033952] iwl3945 0000:03:00.0:
0000047880^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.033989] iwl3945 0000:03:00.0:
0000047955^I0x00000037^I0353
Jan 26 22:24:03 rainbow kernel: [  130.034026] iwl3945 0000:03:00.0:
0000047965^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.034063] iwl3945 0000:03:00.0:
0000048048^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.034101] iwl3945 0000:03:00.0:
0000048050^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.034137] iwl3945 0000:03:00.0:
0000048124^I0x00000038^I0353
Jan 26 22:24:03 rainbow kernel: [  130.034173] iwl3945 0000:03:00.0:
0000048134^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.034210] iwl3945 0000:03:00.0:
0000048224^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.034247] iwl3945 0000:03:00.0:
0000048226^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.034284] iwl3945 0000:03:00.0:
0000048298^I0x00000039^I0353
Jan 26 22:24:03 rainbow kernel: [  130.034321] iwl3945 0000:03:00.0:
0000048309^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.034360] iwl3945 0000:03:00.0:
0000048325^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.034399] iwl3945 0000:03:00.0:
0000048327^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.034436] iwl3945 0000:03:00.0:
0000048520^I0x000000c4^I0303
Jan 26 22:24:03 rainbow kernel: [  130.034473] iwl3945 0000:03:00.0:
0000048523^I0x00000012^I0357
Jan 26 22:24:03 rainbow kernel: [  130.034510] iwl3945 0000:03:00.0:
0000048825^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.034547] iwl3945 0000:03:00.0:
0000048827^I0x00000000^I0302
Jan 26 22:24:03 rainbow kernel: [  130.034584] iwl3945 0000:03:00.0:
0000048867^I0x00000006^I0353
Jan 26 22:24:03 rainbow kernel: [  130.034621] iwl3945 0000:03:00.0:
0000049281^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.034658] iwl3945 0000:03:00.0:
0000049283^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.034696] iwl3945 0000:03:00.0:
0000049477^I0x000000c4^I0303
Jan 26 22:24:03 rainbow kernel: [  130.034732] iwl3945 0000:03:00.0:
0000049480^I0x00000013^I0357
Jan 26 22:24:03 rainbow kernel: [  130.034769] iwl3945 0000:03:00.0:
0000049914^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.034806] iwl3945 0000:03:00.0:
0000049916^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.034843] iwl3945 0000:03:00.0:
0000050107^I0x0000003a^I0353
Jan 26 22:24:03 rainbow kernel: [  130.034880] iwl3945 0000:03:00.0:
0000050472^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.034917] iwl3945 0000:03:00.0:
0000050474^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.034957] iwl3945 0000:03:00.0:
0000050667^I0x000000c4^I0303
Jan 26 22:24:03 rainbow kernel: [  130.034996] iwl3945 0000:03:00.0:
0000050670^I0x00000014^I0357
Jan 26 22:24:03 rainbow kernel: [  130.035033] iwl3945 0000:03:00.0:
0000051429^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.035070] iwl3945 0000:03:00.0:
0000051431^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.035107] iwl3945 0000:03:00.0:
0000051622^I0x0000003b^I0353
Jan 26 22:24:03 rainbow kernel: [  130.035144] iwl3945 0000:03:00.0:
0000052199^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.035181] iwl3945 0000:03:00.0:
0000052201^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.035218] iwl3945 0000:03:00.0:
0000052277^I0x0000003c^I0353
Jan 26 22:24:03 rainbow kernel: [  130.035254] iwl3945 0000:03:00.0:
0000052288^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.035291] iwl3945 0000:03:00.0:
0000052555^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.035328] iwl3945 0000:03:00.0:
0000052557^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.035365] iwl3945 0000:03:00.0:
0000052720^I0x0000003d^I0353
Jan 26 22:24:03 rainbow kernel: [  130.035402] iwl3945 0000:03:00.0:
0000053045^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.035439] iwl3945 0000:03:00.0:
0000053047^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.035476] iwl3945 0000:03:00.0:
0000053121^I0x0000003e^I0353
Jan 26 22:24:03 rainbow kernel: [  130.035513] iwl3945 0000:03:00.0:
0000053132^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.035553] iwl3945 0000:03:00.0:
0000053140^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.035592] iwl3945 0000:03:00.0:
0000053141^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.035629] iwl3945 0000:03:00.0:
0000053281^I0x000000c4^I0303
Jan 26 22:24:03 rainbow kernel: [  130.035666] iwl3945 0000:03:00.0:
0000053284^I0x00000015^I0357
Jan 26 22:24:03 rainbow kernel: [  130.035703] iwl3945 0000:03:00.0:
0000053353^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.035740] iwl3945 0000:03:00.0:
0000053355^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.035776] iwl3945 0000:03:00.0:
0000053733^I0x00000000^I0356
Jan 26 22:24:03 rainbow kernel: [  130.035813] iwl3945 0000:03:00.0:
0000054234^I0x00000003^I0310
Jan 26 22:24:03 rainbow kernel: [  130.035849] iwl3945 0000:03:00.0:
0000054658^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.035886] iwl3945 0000:03:00.0:
0000054660^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.035923] iwl3945 0000:03:00.0:
0000054845^I0x0000003f^I0353
Jan 26 22:24:03 rainbow kernel: [  130.035959] iwl3945 0000:03:00.0:
0000055152^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.035996] iwl3945 0000:03:00.0:
0000055154^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036032] iwl3945 0000:03:00.0:
0000055534^I0x00000000^I0356
Jan 26 22:24:03 rainbow kernel: [  130.036069] iwl3945 0000:03:00.0:
0000056288^I0x00000003^I0310
Jan 26 22:24:03 rainbow kernel: [  130.036106] iwl3945 0000:03:00.0:
0000056296^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036146] iwl3945 0000:03:00.0:
0000056297^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036186] iwl3945 0000:03:00.0:
0000056374^I0x00000040^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036223] iwl3945 0000:03:00.0:
0000056385^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000056821^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000056823^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000056970^I0x00000041^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000057330^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000057332^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000057419^I0x00000042^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000057430^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000057871^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000057873^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000058057^I0x00000043^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000058586^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000058588^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000058907^I0x00000000^I0356
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000059470^I0x00000016^I0357
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000059524^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000059526^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000059602^I0x00000044^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000059612^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000059711^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000059713^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000059809^I0x00000045^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000059819^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000059836^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000059837^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000059912^I0x00000046^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000059922^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000059936^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000059937^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000060009^I0x00000047^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000060020^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000060106^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000060108^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000060185^I0x00000048^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000060195^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000060208^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000060210^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000060284^I0x00000049^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000060294^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000060306^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000060308^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000060386^I0x0000004a^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000060396^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000060586^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000060588^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000060781^I0x000000c4^I0303
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000061286^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000061287^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000061360^I0x0000004b^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000061371^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000061380^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000061381^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000061536^I0x0000004c^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000061661^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000061662^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000061736^I0x0000004d^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000061746^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000061816^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000061818^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000061896^I0x0000004e^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000061907^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000062230^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000062232^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000062305^I0x0000004f^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000062315^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000062323^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000062325^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000062704^I0x00000000^I0356
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000063233^I0x00000003^I0310
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000063278^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000063280^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000063352^I0x00000050^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000063363^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000064389^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000064391^I0x00000000^I0302
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000064418^I0x00000007^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000064438^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000064439^I0x00000000^I0302
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000064448^I0x00008000^I0350
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000064460^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000064461^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000064535^I0x00000051^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000064545^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000064599^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000064600^I0x00000000^I0302
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000064609^I0x00008000^I0350
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000068557^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000068559^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000068738^I0x00000052^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000071100^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000071102^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000071296^I0x000000c4^I0303
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000071299^I0x00000017^I0357
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000071929^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000071930^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000072125^I0x000000c4^I0303
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000072128^I0x00000018^I0357
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000072680^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000072681^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000072819^I0x00000053^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000073261^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000073262^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000073449^I0x00000054^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000074029^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000074031^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000074186^I0x00000055^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000074938^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000074939^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000075110^I0x00000056^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000075680^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000075682^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000075871^I0x00000057^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000076676^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000076677^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000076872^I0x000000c4^I0303
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000076875^I0x00000019^I0357
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000077594^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000077596^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000077786^I0x00000058^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000078072^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000078074^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000078266^I0x000000c4^I0303
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000078269^I0x0000001a^I0357
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000078562^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000078564^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000078637^I0x00000059^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000078648^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000078709^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000078711^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000078785^I0x0000005a^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000078795^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000078827^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000078829^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000078902^I0x0000005b^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000078912^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000078919^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000078921^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000078990^I0x0000005c^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000079001^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000079280^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000079282^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000079469^I0x0000005d^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000080012^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000080014^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000080208^I0x000000c4^I0303
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000080211^I0x0000001b^I0357
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000080830^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000080832^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000081026^I0x000000c4^I0303
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000081029^I0x0000001c^I0357
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000082318^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000082320^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000082402^I0x0000005e^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000082412^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000082430^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000082431^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000082505^I0x0000005f^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000082516^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000082616^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000082618^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000082698^I0x00000060^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000082708^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000084719^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000084720^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000084912^I0x00000061^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000085263^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000085265^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000085342^I0x00000062^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000085352^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000085616^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000085618^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000085811^I0x000000c4^I0303
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000085814^I0x0000001d^I0357
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000086494^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000086496^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000086570^I0x00000063^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000086580^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000086901^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000086902^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000087092^I0x00000064^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000087740^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000087742^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000087857^I0x00000065^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000088363^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000088365^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000088535^I0x00000066^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000089339^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000089340^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000089495^I0x000000c4^I0303
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000089498^I0x0000001e^I0357
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000090078^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000090080^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000090169^I0x00000067^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000090179^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000090915^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000090917^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000091107^I0x00000068^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000093110^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000093111^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000093184^I0x00000069^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000093195^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000093539^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000093541^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000093620^I0x0000006a^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000093630^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000094129^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000094131^I0x00000000^I0302
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000094139^I0x00008000^I0350
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000094150^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000094151^I0x00000000^I0302
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000094160^I0x00008000^I0350
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000094189^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000094191^I0x00000000^I0302
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000094212^I0x00000008^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000094228^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000094230^I0x00000000^I0302
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000094236^I0x00008000^I0350
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000094248^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000094250^I0x00000000^I0302
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000094259^I0x00008000^I0350
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000094487^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000094488^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000094650^I0x0000006b^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000095322^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000095324^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000095707^I0x00000000^I0356
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000096417^I0x00000003^I0310
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000096812^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000096814^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000097006^I0x000030c4^I0303
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000097009^I0x0000001f^I0357
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000097648^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000097650^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000097810^I0x0000006c^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000098171^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000098173^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000098362^I0x0000006d^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000098794^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000098796^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000099176^I0x00000000^I0356
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000100273^I0x00000003^I0310
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000100289^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000100291^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000100365^I0x0000006e^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000100376^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000100392^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000100394^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000100469^I0x0000006f^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000100479^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000100491^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000100493^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000100571^I0x00000070^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000100581^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000100596^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000100598^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000100673^I0x00000071^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000100684^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000100695^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000100697^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000100771^I0x00000072^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000100781^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000100794^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000100796^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000100871^I0x00000073^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000100882^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000100888^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000100890^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000100964^I0x00000074^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000100974^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000100986^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000100987^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000101060^I0x00000075^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000101071^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000101078^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000101079^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000101149^I0x00000076^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000101160^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000101166^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000101168^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000101251^I0x00000077^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000101261^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000101270^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000101272^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000101352^I0x00000078^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000101362^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000101378^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000101380^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000101458^I0x00000079^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000101468^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000101504^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000101505^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000101716^I0x0000007a^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000101726^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000101952^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000101954^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000102048^I0x0000007b^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000102058^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000102161^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000102162^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000102247^I0x0000007c^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000102258^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000102336^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000102338^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000102412^I0x0000007d^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000102422^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000102461^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000102463^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000102585^I0x0000007e^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000102596^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000102619^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000102620^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000102695^I0x0000007f^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000102706^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000102712^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000102714^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000102855^I0x00000080^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000102866^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000102873^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000102874^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000102950^I0x00000081^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000102961^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000103621^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000103623^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000103814^I0x000030c4^I0303
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000103817^I0x00000020^I0357
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000104315^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000104316^I0x00000000^I0302
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000104325^I0x00008000^I0350
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000104579^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000104581^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000104655^I0x00000082^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000104665^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000104818^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000104820^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000104908^I0x00000083^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000104919^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000105130^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000105131^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000105323^I0x00000084^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000105952^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000105954^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000106147^I0x000000c4^I0303
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000106150^I0x00000021^I0357
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000107029^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000107031^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000107222^I0x00000085^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000107763^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000107765^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000107953^I0x00000086^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000108270^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000108271^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000108345^I0x00000087^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000108355^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000109818^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000109820^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000110014^I0x000000c4^I0303
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000110017^I0x00000022^I0357
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000111118^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000111120^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000111313^I0x000000c4^I0303
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000111316^I0x00000023^I0357
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000111761^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000111763^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000111948^I0x00000088^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000112274^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000112275^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000112466^I0x00000089^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000112992^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000112994^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000113171^I0x0000008a^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000113576^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000113577^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000113749^I0x0000008b^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000115452^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000115453^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000115543^I0x0000008c^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000115553^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000115971^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000115973^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000116159^I0x0000008d^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000116466^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000116468^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000116657^I0x0000008e^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000117225^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000117227^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000117320^I0x0000008f^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000117330^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000117747^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000117749^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000117942^I0x000000c4^I0303
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000117945^I0x00000024^I0357
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000118382^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000118384^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000118574^I0x00000090^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000118849^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000118851^I0x00000000^I0302
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000118860^I0x00008000^I0350
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000118886^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000118887^I0x00000000^I0302
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000118896^I0x00008000^I0350
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000118945^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000118947^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000119115^I0x000000c4^I0303
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000119118^I0x00000025^I0357
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000119572^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000119574^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000119759^I0x00000091^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000120169^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000120170^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000120348^I0x00000092^I0353
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000120437^I0x00010087^I0250
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0000120442^I0x0000001c^I0218
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0096917365^I0x00000002^I0123
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
0096917367^I0x00000100^I0125
Jan 26 22:24:03 rainbow kernel: [  130.036247] ieee80211 phy1: I
iwl3945_print_rx_config_cmd RX CONFIG:
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl data: 00000000: 00
1f 3c 20 a1 6e 00 00 00 30 bd c0 90 24 00 00  ..< .n...0...$..
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl data: 00000010: 00
00 00 00 00 00 00 00 03 00 00 00 15 03 00 00  ................
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl data: 00000020: 05
80 00 00 04 00 00 00 0b 00 00 00              ............
Jan 26 22:24:03 rainbow kernel: [  130.036247] ieee80211 phy1: I
iwl3945_print_rx_config_cmd u16 channel: 0xb
Jan 26 22:24:03 rainbow kernel: [  130.036247] ieee80211 phy1: I
iwl3945_print_rx_config_cmd u32 flags: 0x00008005
Jan 26 22:24:03 rainbow kernel: [  130.036247] ieee80211 phy1: I
iwl3945_print_rx_config_cmd u32 filter_flags: 0x00000004
Jan 26 22:24:03 rainbow kernel: [  130.036247] ieee80211 phy1: I
iwl3945_print_rx_config_cmd u8 dev_type: 0x3
Jan 26 22:24:03 rainbow kernel: [  130.036247] ieee80211 phy1: I
iwl3945_print_rx_config_cmd u8 ofdm_basic_rates: 0x15
Jan 26 22:24:03 rainbow kernel: [  130.036247] ieee80211 phy1: I
iwl3945_print_rx_config_cmd u8 cck_basic_rates: 0x03
Jan 26 22:24:03 rainbow kernel: [  130.036247] ieee80211 phy1: I
iwl3945_print_rx_config_cmd u8[6] node_addr: 00:1f:3c:20:a1:6e
Jan 26 22:24:03 rainbow kernel: [  130.036247] ieee80211 phy1: I
iwl3945_print_rx_config_cmd u8[6] bssid_addr: 00:30:bd:c0:90:24
Jan 26 22:24:03 rainbow kernel: [  130.036247] ieee80211 phy1: I
iwl3945_print_rx_config_cmd u16 assoc_id: 0x0
Jan 26 22:24:03 rainbow kernel: [  130.036247] ieee80211 phy1: I
iwl3945_irq_handle_error Restarting adapter due to uCode error.
Jan 26 22:24:03 rainbow kernel: [  130.036247] ieee80211 phy1: I
iwl3945_rx_handle r = 20, i = 19, REPLY_ERROR, 0x02
Jan 26 22:24:03 rainbow kernel: [  130.036247] iwl3945 0000:03:00.0:
Error Reply type 0x00000005 cmd REPLY_PHY_CALIBRATION_CMD (0xB0) seq
0x013A ser 0x004E0000
Jan 26 22:24:03 rainbow kernel: [  130.036247] ieee80211 phy1: U
__iwl3945_down iwl3945 is going down
Jan 26 22:24:03 rainbow kernel: [  130.049028] ieee80211 phy1: U
iwl3945_apm_stop_master stop master
Jan 26 22:24:03 rainbow kernel: [  130.049028] ieee80211 phy1: U
iwl3945_apm_stop_master stop master
Jan 26 22:24:03 rainbow kernel: [  130.049028] ieee80211 phy1: U
iwl3945_clear_free_frames 0 frames on pre-allocated heap on clear.
Jan 26 22:24:03 rainbow kernel: [  130.049028] ieee80211 phy1: U
iwl3945_power_init_handle Initialize power
Jan 26 22:24:03 rainbow kernel: [  130.049028] ieee80211 phy1: U
iwl3945_power_init_handle adjust power command flags
Jan 26 22:24:03 rainbow kernel: [  130.049028] ieee80211 phy1: U
iwl3945_hw_nic_init HW Revision ID = 0x2
Jan 26 22:24:03 rainbow kernel: [  130.049028] ieee80211 phy1: U
iwl3945_nic_config 3945 RADIO-MM type
Jan 26 22:24:03 rainbow kernel: [  130.049028] ieee80211 phy1: U
iwl3945_nic_config SKU OP mode is basic
Jan 26 22:24:03 rainbow kernel: [  130.049028] ieee80211 phy1: U
iwl3945_nic_config 3945ABG revision is 0xF1
Jan 26 22:24:03 rainbow kernel: [  130.049028] ieee80211 phy1: U
iwl3945_nic_config Card M type B version is 0x3
Jan 26 22:24:03 rainbow kernel: [  130.057439] ieee80211 phy1: U
iwl3945_load_bsm Begin load bsm
Jan 26 22:24:03 rainbow kernel: [  130.058708] ieee80211 phy1: U
iwl3945_verify_bsm Begin verify bsm
Jan 26 22:24:03 rainbow kernel: [  130.060937] ieee80211 phy1: U
iwl3945_verify_bsm BSM bootstrap uCode image OK
Jan 26 22:24:03 rainbow kernel: [  130.060996] ieee80211 phy1: U
iwl3945_load_bsm BSM write complete, poll 1 iterations
Jan 26 22:24:03 rainbow kernel: [  130.061015] ieee80211 phy1: U
__iwl3945_up iwl3945 is coming up
Jan 26 22:24:03 rainbow kernel: [  130.072446] ieee80211 phy1: I
iwl3945_rx_handle r = 1, i = 0, REPLY_ALIVE, 0x01
Jan 26 22:24:03 rainbow kernel: [  130.072462] ieee80211 phy1: I
iwl3945_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x9
Jan 26 22:24:03 rainbow kernel: [  130.072470] ieee80211 phy1: I
iwl3945_rx_reply_alive Initialization Alive received.
Jan 26 22:24:03 rainbow kernel: [  130.080069] ieee80211 phy1: U
iwl3945_verify_inst_sparse ucode inst image size is 900
Jan 26 22:24:03 rainbow kernel: [  130.080173] ieee80211 phy1: U
iwl3945_verify_inst_sparse ucode inst image size is 2672
Jan 26 22:24:03 rainbow kernel: [  130.080481] ieee80211 phy1: U
iwl3945_verify_ucode Initialize uCode is good in inst SRAM
Jan 26 22:24:03 rainbow kernel: [  130.080491] ieee80211 phy1: U
iwl3945_init_alive_start Initialization Alive received.
Jan 26 22:24:03 rainbow kernel: [  130.080543] ieee80211 phy1: U
iwl3945_set_ucode_ptrs Runtime uCode pointers are set.
Jan 26 22:24:03 rainbow kernel: [  130.084900] ieee80211 phy1: I
iwl3945_rx_handle r = 2, i = 1, REPLY_ALIVE, 0x01
Jan 26 22:24:03 rainbow kernel: [  130.084914] ieee80211 phy1: I
iwl3945_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x0
Jan 26 22:24:03 rainbow kernel: [  130.084922] ieee80211 phy1: I
iwl3945_rx_reply_alive Runtime Alive received.
Jan 26 22:24:03 rainbow kernel: [  130.084971] ieee80211 phy1: I
iwl3945_disable_events Selected uCode log events may be disabled
Jan 26 22:24:03 rainbow kernel: [  130.084978] ieee80211 phy1: I
iwl3945_disable_events   by writing "1"s into disable bitmap
Jan 26 22:24:03 rainbow kernel: [  130.084986] ieee80211 phy1: I
iwl3945_disable_events   in SRAM at 0x8022c8, size 47 u32s
Jan 26 22:24:03 rainbow kernel: [  130.089701] ieee80211 phy1: U
iwl3945_alive_start Runtime Alive received.
Jan 26 22:24:03 rainbow kernel: [  130.089712] ieee80211 phy1: U
iwl3945_verify_inst_sparse ucode inst image size is 900
Jan 26 22:24:03 rainbow kernel: [  130.089799] ieee80211 phy1: U
iwl3945_verify_inst_sparse ucode inst image size is 2672
Jan 26 22:24:03 rainbow kernel: [  130.089885] ieee80211 phy1: U
iwl3945_verify_inst_sparse ucode inst image size is 80684
Jan 26 22:24:03 rainbow kernel: [  130.097683] ieee80211 phy1: U
iwl3945_verify_ucode Runtime uCode is good in inst SRAM
Jan 26 22:24:03 rainbow kernel: [  130.097720] ieee80211 phy1: U
iwl3945_alive_start RFKILL status: 0x1
Jan 26 22:24:03 rainbow kernel: [  130.097750] ieee80211 phy1: U
iwl3945_update_power_cmd Flags value = 0x00000008
Jan 26 22:24:03 rainbow kernel: [  130.097758] ieee80211 phy1: U
iwl3945_update_power_cmd Tx timeout = 0
Jan 26 22:24:03 rainbow kernel: [  130.097764] ieee80211 phy1: U
iwl3945_update_power_cmd Rx timeout = 0
Jan 26 22:24:03 rainbow kernel: [  130.097772] ieee80211 phy1: U
iwl3945_update_power_cmd Sleep interval vector = { 0 , 0 , 0 , 0 , 0 }
Jan 26 22:24:03 rainbow kernel: [  130.097788] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command POWER_TABLE_CMD (#77), seq: 0x0400,
36 bytes at 0[0]:4
Jan 26 22:24:03 rainbow kernel: [  130.097869] ieee80211 phy1: I
iwl3945_rx_handle r 3 i 2 No handler needed for POWER_TABLE_CMD, 0x77
Jan 26 22:24:03 rainbow kernel: [  130.098669] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_BT_CONFIG (#9b), seq: 0x0401,
16 bytes at 1[1]:4
Jan 26 22:24:03 rainbow kernel: [  130.098744] ieee80211 phy1: I
iwl3945_rx_handle r 4 i 3 No handler needed for REPLY_BT_CONFIG, 0x9b
Jan 26 22:24:03 rainbow kernel: [  130.099538] ieee80211 phy1: U
iwl3945_commit_rxon Sending RXON
Jan 26 22:24:03 rainbow kernel: [  130.099540] * without RXON_FILTER_ASSOC_MSK
Jan 26 22:24:03 rainbow kernel: [  130.099542] * channel = 11
Jan 26 22:24:03 rainbow kernel: [  130.099543] * bssid = 00:00:00:00:00:00
Jan 26 22:24:03 rainbow kernel: [  130.099563] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x0402, 48
bytes at 2[2]:4
Jan 26 22:24:03 rainbow kernel: [  130.100795] ieee80211 phy1: I
iwl3945_rx_handle r 5 i 4 No handler needed for REPLY_RXON, 0x10
Jan 26 22:24:03 rainbow kernel: [  130.100823] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x0d
Jan 26 22:24:03 rainbow kernel: [  130.100833] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x0f
Jan 26 22:24:03 rainbow kernel: [  130.100841] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x05
Jan 26 22:24:03 rainbow kernel: [  130.100849] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x07
Jan 26 22:24:03 rainbow kernel: [  130.100857] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x09
Jan 26 22:24:03 rainbow kernel: [  130.100864] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x0b
Jan 26 22:24:03 rainbow kernel: [  130.100873] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x01
Jan 26 22:24:03 rainbow kernel: [  130.100881] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 203 dsp 121 rate code 0x03
Jan 26 22:24:03 rainbow kernel: [  130.100889] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x0a
Jan 26 22:24:03 rainbow kernel: [  130.100897] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x14
Jan 26 22:24:03 rainbow kernel: [  130.100905] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x37
Jan 26 22:24:03 rainbow kernel: [  130.100914] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 227 dsp 125 rate code 0x6e
Jan 26 22:24:03 rainbow kernel: [  130.100926] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq:
0x0403, 56 bytes at 3[3]:4
Jan 26 22:24:03 rainbow kernel: [  130.101111] ieee80211 phy1: I
iwl3945_rx_handle r 6 i 5 No handler needed for
REPLY_TX_PWR_TABLE_CMD, 0x97
Jan 26 22:24:03 rainbow kernel: [  130.101135] ieee80211 phy1: U
iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
Jan 26 22:24:03 rainbow kernel: [  130.101148] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0404, 68
bytes at 4[4]:4
Jan 26 22:24:03 rainbow kernel: [  130.101355] ieee80211 phy1: I
iwl3945_rx_handle r = 7, i = 6, REPLY_ADD_STA, 0x18
Jan 26 22:24:03 rainbow kernel: [  130.101376] ieee80211 phy1: U
iwl_sta_ucode_activate Added STA to Ucode: 00:00:00:00:00:00
Jan 26 22:24:03 rainbow kernel: [  130.101386] ieee80211 phy1: U
iwl_send_add_sta REPLY_ADD_STA PASSED
Jan 26 22:24:03 rainbow kernel: [  130.101399] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0405,
56 bytes at 5[5]:4
Jan 26 22:24:03 rainbow kernel: [  130.102227] ieee80211 phy1: I
iwl3945_rx_handle r 8 i 7 No handler needed for REPLY_RATE_SCALE, 0x47
Jan 26 22:24:03 rainbow kernel: [  130.102425] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0406,
56 bytes at 6[6]:4
Jan 26 22:24:03 rainbow kernel: [  130.102691] ieee80211 phy1: I
iwl3945_rx_handle r 9 i 8 No handler needed for REPLY_RATE_SCALE, 0x47
Jan 26 22:24:03 rainbow kernel: [  130.102724] ieee80211 phy1: U
iwl3945_hw_reg_txpower_get_temperature Temperature: 109
Jan 26 22:24:03 rainbow kernel: [  130.102733] ieee80211 phy1: U
is_temp_calib_needed Getting warmer, delta 37,
Jan 26 22:24:03 rainbow kernel: [  130.102739] ieee80211 phy1: U
is_temp_calib_needed Timed thermal calib needed
Jan 26 22:24:03 rainbow kernel: [  130.102760] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 235 dsp 121 rate code 0x0d
Jan 26 22:24:03 rainbow kernel: [  130.102768] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 235 dsp 121 rate code 0x0f
Jan 26 22:24:03 rainbow kernel: [  130.102776] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 235 dsp 121 rate code 0x05
Jan 26 22:24:03 rainbow kernel: [  130.102784] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 235 dsp 121 rate code 0x07
Jan 26 22:24:03 rainbow kernel: [  130.102792] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 235 dsp 121 rate code 0x09
Jan 26 22:24:03 rainbow kernel: [  130.102800] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 235 dsp 121 rate code 0x0b
Jan 26 22:24:03 rainbow kernel: [  130.102808] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 235 dsp 121 rate code 0x01
Jan 26 22:24:03 rainbow kernel: [  130.102817] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 235 dsp 121 rate code 0x03
Jan 26 22:24:03 rainbow kernel: [  130.102825] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 171 dsp 110 rate code 0x0a
Jan 26 22:24:03 rainbow kernel: [  130.102833] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 171 dsp 110 rate code 0x14
Jan 26 22:24:03 rainbow kernel: [  130.102841] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 171 dsp 110 rate code 0x37
Jan 26 22:24:03 rainbow kernel: [  130.102849] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 171 dsp 110 rate code 0x6e
Jan 26 22:24:03 rainbow kernel: [  130.102860] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq:
0x0407, 56 bytes at 7[7]:4
Jan 26 22:24:03 rainbow kernel: [  130.103272] ieee80211 phy1: I
iwl3945_rx_handle r 10 i 9 No handler needed for
REPLY_TX_PWR_TABLE_CMD, 0x97
Jan 26 22:24:03 rainbow kernel: [  130.103590] Registered led device:
iwl-phy1:radio
Jan 26 22:24:03 rainbow kernel: [  130.103600] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0408, 12
bytes at 8[8]:4
Jan 26 22:24:03 rainbow kernel: [  130.103676] ieee80211 phy1: I
iwl3945_rx_handle r 11 i 10 No handler needed for REPLY_LEDS_CMD, 0x48
Jan 26 22:24:03 rainbow kernel: [  130.103704] Registered led device:
iwl-phy1:assoc
Jan 26 22:24:03 rainbow kernel: [  130.103741] Registered led device:
iwl-phy1:RX
Jan 26 22:24:03 rainbow kernel: [  130.103775] Registered led device:
iwl-phy1:TX
Jan 26 22:24:03 rainbow kernel: [  130.103780] ieee80211 phy1: U
iwl3945_alive_start ALIVE processing complete.
Jan 26 22:24:03 rainbow kernel: [  130.120772] ieee80211 phy1: I
iwl3945_rx_handle r = 12, i = 11, REPLY_3945_RX, 0x1b
Jan 26 22:24:03 rainbow kernel: [  130.140992] ieee80211 phy1: I
iwl3945_rx_handle r = 13, i = 12, REPLY_3945_RX, 0x1b
Jan 26 22:24:03 rainbow kernel: [  130.145040] ieee80211 phy1: I
iwl3945_rx_handle r = 14, i = 13, REPLY_3945_RX, 0x1b
Jan 26 22:24:03 rainbow kernel: [  130.146963] ieee80211 phy1: I
iwl3945_rx_handle r = 15, i = 14, REPLY_3945_RX, 0x1b
Jan 26 22:24:03 rainbow kernel: [  130.150589] ieee80211 phy1: I
iwl3945_rx_handle r = 16, i = 15, REPLY_3945_RX, 0x1b
Jan 26 22:24:03 rainbow kernel: [  130.181220] ieee80211 phy1: I
iwl3945_rx_handle r = 17, i = 16, REPLY_3945_RX, 0x1b
Jan 26 22:24:03 rainbow kernel: [  130.185138] ieee80211 phy1: I
iwl3945_rx_handle r = 18, i = 17, REPLY_3945_RX, 0x1b
Jan 26 22:24:03 rainbow kernel: [  130.189899] ieee80211 phy1: I
iwl3945_rx_handle r = 19, i = 18, REPLY_3945_RX, 0x1b
Jan 26 22:24:03 rainbow kernel: [  130.202642] ieee80211 phy1: I
iwl3945_rx_handle r = 20, i = 19, REPLY_3945_RX, 0x1b
Jan 26 22:24:03 rainbow kernel: [  130.223184] ieee80211 phy1: I
iwl3945_rx_handle r = 21, i = 20, REPLY_3945_RX, 0x1b
Jan 26 22:24:03 rainbow kernel: [  130.233063] wlan0: direct probe to
AP 00:30:bd:c0:90:24 try 2
Jan 26 22:24:03 rainbow kernel: [  130.233075] ieee80211 phy1: I
iwl3945_mac_tx enter
Jan 26 22:24:03 rainbow kernel: [  130.233083] ieee80211 phy1: I
iwl3945_mac_tx leave
Jan 26 22:24:03 rainbow kernel: [  130.233162] ieee80211 phy1: I
iwl3945_rx_handle r = 22, i = 21, REPLY_TX, 0x1c
Jan 26 22:24:03 rainbow kernel: [  130.432086] wlan0: direct probe to
AP 00:30:bd:c0:90:24 try 3
Jan 26 22:24:03 rainbow kernel: [  130.432096] ieee80211 phy1: I
iwl3945_mac_tx enter
Jan 26 22:24:03 rainbow kernel: [  130.432104] ieee80211 phy1: I
iwl3945_mac_tx leave
Jan 26 22:24:03 rainbow kernel: [  130.432200] ieee80211 phy1: I
iwl3945_rx_handle r 24 i 22 No handler needed for UNKNOWN, 0x40
Jan 26 22:24:03 rainbow kernel: [  130.432223] ------------[ cut here
]------------
Jan 26 22:24:03 rainbow kernel: [  130.432225] WARNING: at
drivers/net/wireless/iwlwifi/iwl3945-base.c:2310
iwl3945_irq_tasklet+0x10e2/0x1500 [iwl3945]()
Jan 26 22:24:03 rainbow kernel: [  130.432228] Hardware name: 7658CTO
Jan 26 22:24:03 rainbow kernel: [  130.432229] wrong command queue 0,
sequence 0x0 readp=9 writep=9
Jan 26 22:24:03 rainbow kernel: [  130.432231] Modules linked in:
af_packet i915 drm i2c_algo_bit i2c_core binfmt_misc ipv6 acpi_cpufreq
cpufreq_ondemand cpufreq_stats cpufreq_powersave cpufreq_userspace
cpufreq_conservative freq_table pci_slot sbs sbshc container
iptable_filter ip_tables x_tables sbp2 snd_hda_codec_analog
snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm arc4
snd_seq_dummy ecb snd_seq_oss snd_seq_midi iwl3945 iwlcore p54usb
p54common snd_rawmidi snd_seq_midi_event snd_seq joydev snd_timer
snd_seq_device snd mac80211 pcmcia thinkpad_acpi rfkill evdev lib80211
battery soundcore led_class serio_raw pcspkr psmouse video cfg80211
snd_page_alloc nvram intel_agp iTCO_wdt iTCO_vendor_support output wmi
ac yenta_socket rsrc_nonstatic pcmcia_core shpchp pci_hotplug button
ext3 jbd mbcache sr_mod cdrom sd_mod crc_t10dif sg ata_piix
ata_generic ahci pata_acpi ohci1394 libata ieee1394 scsi_mod ehci_hcd
uhci_hcd usbcore thermal processor fan fuse
Jan 26 22:24:03 rainbow kernel: [  130.432291] Pid: 0, comm: swapper
Not tainted 2.6.29-rc2-wl #26
Jan 26 22:24:03 rainbow kernel: [  130.432293] Call Trace:
Jan 26 22:24:03 rainbow kernel: [  130.432295]  <IRQ>
[<ffffffff80250440>] warn_slowpath+0xd0/0x130
Jan 26 22:24:03 rainbow kernel: [  130.432306]  [<ffffffff8051d9a0>] ?
printk+0x67/0x6f
Jan 26 22:24:03 rainbow kernel: [  130.432311]  [<ffffffff803bbc41>] ?
swiotlb_bounce+0x21/0x50
Jan 26 22:24:03 rainbow kernel: [  130.432314]  [<ffffffff803bbd05>] ?
sync_single+0x95/0xb0
Jan 26 22:24:03 rainbow kernel: [  130.432316]  [<ffffffff803bbf60>] ?
swiotlb_sync_single+0x60/0x70
Jan 26 22:24:03 rainbow kernel: [  130.432324]  [<ffffffffa0396262>]
iwl3945_irq_tasklet+0x10e2/0x1500 [iwl3945]
Jan 26 22:24:03 rainbow kernel: [  130.432328]  [<ffffffff803b7eda>] ?
ioread32+0x3a/0x40
Jan 26 22:24:03 rainbow kernel: [  130.432331]  [<ffffffff80255e36>]
tasklet_action+0x86/0x110
Jan 26 22:24:03 rainbow kernel: [  130.432333]  [<ffffffff802567ac>]
__do_softirq+0x9c/0x170
Jan 26 22:24:03 rainbow kernel: [  130.432336]  [<ffffffff80214a5c>]
call_softirq+0x1c/0x30
Jan 26 22:24:03 rainbow kernel: [  130.432339]  [<ffffffff80215f4d>]
do_softirq+0x5d/0xa0
Jan 26 22:24:03 rainbow kernel: [  130.432341]  [<ffffffff80256505>]
irq_exit+0x75/0xa0
Jan 26 22:24:03 rainbow kernel: [  130.432343]  [<ffffffff802161d6>]
do_IRQ+0x86/0x110
Jan 26 22:24:03 rainbow kernel: [  130.432345]  [<ffffffff802141d3>]
ret_from_intr+0x0/0x29
Jan 26 22:24:03 rainbow kernel: [  130.432347]  <EOI> <4>---[ end
trace 2a901068c968f9ea ]---
Jan 26 22:24:03 rainbow kernel: [  130.432351] iwl data: 00000000: 00
90 4c 20 00 00 00 00 00 00 00 00 00 00 00 00  ..L ............
Jan 26 22:24:03 rainbow kernel: [  130.432353] iwl data: 00000010: 00
fa 14 35 01 88 ff ff 00 01 10 00 00 00 00 00  ...5............
Jan 26 22:24:03 rainbow kernel: [  130.432361] ieee80211 phy1: I
iwl3945_rx_handle r 24 i 23 No handler needed for UNKNOWN, 0x00
Jan 26 22:24:03 rainbow kernel: [  130.432369] ------------[ cut here
]------------
Jan 26 22:24:03 rainbow kernel: [  130.432371] WARNING: at
drivers/net/wireless/iwlwifi/iwl3945-base.c:2310
iwl3945_irq_tasklet+0x10e2/0x1500 [iwl3945]()
Jan 26 22:24:03 rainbow kernel: [  130.432373] Hardware name: 7658CTO
Jan 26 22:24:03 rainbow kernel: [  130.432374] wrong command queue 0,
sequence 0x0 readp=9 writep=9
Jan 26 22:24:03 rainbow kernel: [  130.432376] Modules linked in:
af_packet i915 drm i2c_algo_bit i2c_core binfmt_misc ipv6 acpi_cpufreq
cpufreq_ondemand cpufreq_stats cpufreq_powersave cpufreq_userspace
cpufreq_conservative freq_table pci_slot sbs sbshc container
iptable_filter ip_tables x_tables sbp2 snd_hda_codec_analog
snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm arc4
snd_seq_dummy ecb snd_seq_oss snd_seq_midi iwl3945 iwlcore p54usb
p54common snd_rawmidi snd_seq_midi_event snd_seq joydev snd_timer
snd_seq_device snd mac80211 pcmcia thinkpad_acpi rfkill evdev lib80211
battery soundcore led_class serio_raw pcspkr psmouse video cfg80211
snd_page_alloc nvram intel_agp iTCO_wdt iTCO_vendor_support output wmi
ac yenta_socket rsrc_nonstatic pcmcia_core shpchp pci_hotplug button
ext3 jbd mbcache sr_mod cdrom sd_mod crc_t10dif sg ata_piix
ata_generic ahci pata_acpi ohci1394 libata ieee1394 scsi_mod ehci_hcd
uhci_hcd usbcore thermal processor fan fuse
Jan 26 22:24:03 rainbow kernel: [  130.432425] Pid: 0, comm: swapper
Tainted: G        W  2.6.29-rc2-wl #26
Jan 26 22:24:03 rainbow kernel: [  130.432427] Call Trace:
Jan 26 22:24:03 rainbow kernel: [  130.432433]  <IRQ>
[<ffffffff80250440>] warn_slowpath+0xd0/0x130
Jan 26 22:24:03 rainbow kernel: [  130.432440]  [<ffffffff8051d9a0>] ?
printk+0x67/0x6f
Jan 26 22:24:03 rainbow kernel: [  130.432443]  [<ffffffff803bc0de>] ?
unmap_single+0x13e/0x170
Jan 26 22:24:03 rainbow kernel: [  130.432446]  [<ffffffff803bbc41>] ?
swiotlb_bounce+0x21/0x50
Jan 26 22:24:03 rainbow kernel: [  130.432448]  [<ffffffff803bbd05>] ?
sync_single+0x95/0xb0
Jan 26 22:24:03 rainbow kernel: [  130.432450]  [<ffffffff803bbf60>] ?
swiotlb_sync_single+0x60/0x70
Jan 26 22:24:03 rainbow kernel: [  130.432458]  [<ffffffffa0396262>]
iwl3945_irq_tasklet+0x10e2/0x1500 [iwl3945]
Jan 26 22:24:03 rainbow kernel: [  130.432461]  [<ffffffff803b7eda>] ?
ioread32+0x3a/0x40
Jan 26 22:24:03 rainbow kernel: [  130.432463]  [<ffffffff80255e36>]
tasklet_action+0x86/0x110
Jan 26 22:24:03 rainbow kernel: [  130.432465]  [<ffffffff802567ac>]
__do_softirq+0x9c/0x170
Jan 26 22:24:03 rainbow kernel: [  130.432468]  [<ffffffff80214a5c>]
call_softirq+0x1c/0x30
Jan 26 22:24:03 rainbow kernel: [  130.432470]  [<ffffffff80215f4d>]
do_softirq+0x5d/0xa0
Jan 26 22:24:03 rainbow kernel: [  130.432472]  [<ffffffff80256505>]
irq_exit+0x75/0xa0
Jan 26 22:24:03 rainbow kernel: [  130.432474]  [<ffffffff802161d6>]
do_IRQ+0x86/0x110
Jan 26 22:24:03 rainbow kernel: [  130.432476]  [<ffffffff802141d3>]
ret_from_intr+0x0/0x29
Jan 26 22:24:03 rainbow kernel: [  130.432477]  <EOI> <4>---[ end
trace 2a901068c968f9eb ]---
Jan 26 22:24:03 rainbow kernel: [  130.432479] iwl data: 00000000: 00
a0 4c 20 00 00 00 00 00 00 00 00 00 00 00 00  ..L ............
Jan 26 22:24:03 rainbow kernel: [  130.432481] iwl data: 00000010: 00
f8 14 35 01 88 ff ff 00 01 10 00 00 00 00 00  ...5............
Jan 26 22:24:03 rainbow kernel: [  130.432526] iwl3945 0000:03:00.0:
Microcode SW error detected. Restarting 0x82000008.
Jan 26 22:24:03 rainbow kernel: [  130.432553] iwl3945 0000:03:00.0:
Start IWL Error Log Dump:
Jan 26 22:24:03 rainbow kernel: [  130.432556] iwl3945 0000:03:00.0:
Status: 0x000202E4, count: 1
Jan 26 22:24:03 rainbow kernel: [  130.432558] iwl3945 0000:03:00.0:
Desc       Time       asrtPC  blink2 ilink1  nmiPC   Line
Jan 26 22:24:03 rainbow kernel: [  130.432633] iwl3945 0000:03:00.0:
SYSASSERT     (#5) 0000332712 0x0089A 0x00342 0x00304 0x00000 267
Jan 26 22:24:03 rainbow kernel: [  130.432634]
Jan 26 22:24:03 rainbow kernel: [  130.432697] iwl3945 0000:03:00.0:
Start IWL Event Log Dump: display count 512, wraps 1
Jan 26 22:24:03 rainbow kernel: [  130.432728] iwl3945 0000:03:00.0:
0000000031^I0x007c0037^I1102
Jan 26 22:24:03 rainbow kernel: [  130.432758] iwl3945 0000:03:00.0:
0000000033^I0x00000038^I1102
Jan 26 22:24:03 rainbow kernel: [  130.432788] iwl3945 0000:03:00.0:
0000000034^I0x00840052^I1102
Jan 26 22:24:03 rainbow kernel: [  130.432824] iwl3945 0000:03:00.0:
0000000036^I0x00840053^I1102
Jan 26 22:24:03 rainbow kernel: [  130.432854] iwl3945 0000:03:00.0:
0000000037^I0x007e0054^I1102
Jan 26 22:24:03 rainbow kernel: [  130.432883] iwl3945 0000:03:00.0:
0000000039^I0x007d0055^I1102
Jan 26 22:24:03 rainbow kernel: [  130.432913] iwl3945 0000:03:00.0:
0000000040^I0x00000056^I1102
Jan 26 22:24:03 rainbow kernel: [  130.432943] iwl3945 0000:03:00.0:
0000000042^I0x00007050^I1102
Jan 26 22:24:03 rainbow kernel: [  130.432973] iwl3945 0000:03:00.0:
0000000044^I0x00017051^I1102
Jan 26 22:24:03 rainbow kernel: [  130.433009] iwl3945 0000:03:00.0:
0000000046^I0x00008204^I1102
Jan 26 22:24:03 rainbow kernel: [  130.433040] iwl3945 0000:03:00.0:
0000000048^I0x00018205^I1102
Jan 26 22:24:03 rainbow kernel: [  130.433071] iwl3945 0000:03:00.0:
0000000051^I0x00000001^I1101
Jan 26 22:24:03 rainbow kernel: [  130.433101] iwl3945 0000:03:00.0:
0000000052^I0x008b0063^I1102
Jan 26 22:24:03 rainbow kernel: [  130.433131] iwl3945 0000:03:00.0:
0000000054^I0x0000001c^I1104
Jan 26 22:24:03 rainbow kernel: [  130.433161] iwl3945 0000:03:00.0:
0000000056^I0x00000002^I1101
Jan 26 22:24:03 rainbow kernel: [  130.433191] iwl3945 0000:03:00.0:
0000000056^I0x0083903f^I1102
Jan 26 22:24:03 rainbow kernel: [  130.433222] iwl3945 0000:03:00.0:
0000000058^I0x0001d213^I1102
Jan 26 22:24:03 rainbow kernel: [  130.433257] iwl3945 0000:03:00.0:
0000000062^I0x00000002^I1101
Jan 26 22:24:03 rainbow kernel: [  130.433287] iwl3945 0000:03:00.0:
0000000062^I0x0003d206^I1102
Jan 26 22:24:03 rainbow kernel: [  130.433318] iwl3945 0000:03:00.0:
0000000064^I0x0083903e^I1102
Jan 26 22:24:03 rainbow kernel: [  130.433348] iwl3945 0000:03:00.0:
0000000068^I0x00000059^I1101
Jan 26 22:24:03 rainbow kernel: [  130.433378] iwl3945 0000:03:00.0:
0000000168^I0x00000013^I1101
Jan 26 22:24:03 rainbow kernel: [  130.433407] iwl3945 0000:03:00.0:
0000000186^I0x00000005^I1107
Jan 26 22:24:03 rainbow kernel: [  130.433437] iwl3945 0000:03:00.0:
0000000754^I0x00018d0f^I1110
Jan 26 22:24:03 rainbow kernel: [  130.433468] iwl3945 0000:03:00.0:
0000000765^I0xffffff69^I0454
Jan 26 22:24:03 rainbow kernel: [  130.433497] iwl3945 0000:03:00.0:
0000000766^I0x00000000^I0472
Jan 26 22:24:03 rainbow kernel: [  130.433527] iwl3945 0000:03:00.0:
0000000777^I0xffffff69^I1111
Jan 26 22:24:03 rainbow kernel: [  130.433557] iwl3945 0000:03:00.0:
0000000782^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.433587] iwl3945 0000:03:00.0:
0000000783^I0x0000000e^I1106
Jan 26 22:24:03 rainbow kernel: [  130.433617] iwl3945 0000:03:00.0:
0000000787^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.433647] iwl3945 0000:03:00.0:
0000000791^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.433677] iwl3945 0000:03:00.0:
0000000796^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.433707] iwl3945 0000:03:00.0:
0000000800^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.433739] iwl3945 0000:03:00.0:
0000000804^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.433769] iwl3945 0000:03:00.0:
0000000808^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.433799] iwl3945 0000:03:00.0:
0000000813^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.433829] iwl3945 0000:03:00.0:
0000000817^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.433859] iwl3945 0000:03:00.0:
0000000821^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.433889] iwl3945 0000:03:00.0:
0000000825^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.433920] iwl3945 0000:03:00.0:
0000000830^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.433949] iwl3945 0000:03:00.0:
0000000834^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.433979] iwl3945 0000:03:00.0:
0000000838^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.434009] iwl3945 0000:03:00.0:
0000000843^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.434039] iwl3945 0000:03:00.0:
0000000847^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.434069] iwl3945 0000:03:00.0:
0000000851^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.434099] iwl3945 0000:03:00.0:
0000000855^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.434129] iwl3945 0000:03:00.0:
0000000860^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.434159] iwl3945 0000:03:00.0:
0000000864^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.434189] iwl3945 0000:03:00.0:
0000000868^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.434220] iwl3945 0000:03:00.0:
0000000873^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.434250] iwl3945 0000:03:00.0:
0000000877^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.434280] iwl3945 0000:03:00.0:
0000000881^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.434310] iwl3945 0000:03:00.0:
0000000885^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.434340] iwl3945 0000:03:00.0:
0000000890^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.434369] iwl3945 0000:03:00.0:
0000000894^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.434401] iwl3945 0000:03:00.0:
0000000898^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.434430] iwl3945 0000:03:00.0:
0000000902^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.434460] iwl3945 0000:03:00.0:
0000000907^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.434490] iwl3945 0000:03:00.0:
0000000911^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.434521] iwl3945 0000:03:00.0:
0000000915^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.434551] iwl3945 0000:03:00.0:
0000000920^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.434581] iwl3945 0000:03:00.0:
0000000924^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.434611] iwl3945 0000:03:00.0:
0000000928^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.434640] iwl3945 0000:03:00.0:
0000000932^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.434671] iwl3945 0000:03:00.0:
0000000937^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.434701] iwl3945 0000:03:00.0:
0000000941^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.434731] iwl3945 0000:03:00.0:
0000000945^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.434761] iwl3945 0000:03:00.0:
0000000949^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.434791] iwl3945 0000:03:00.0:
0000000954^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.434821] iwl3945 0000:03:00.0:
0000000958^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.434852] iwl3945 0000:03:00.0:
0000000962^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.434881] iwl3945 0000:03:00.0:
0000000967^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.434911] iwl3945 0000:03:00.0:
0000000971^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.434941] iwl3945 0000:03:00.0:
0000000975^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.434971] iwl3945 0000:03:00.0:
0000000979^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.435001] iwl3945 0000:03:00.0:
0000000984^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.435031] iwl3945 0000:03:00.0:
0000000988^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.435061] iwl3945 0000:03:00.0:
0000000992^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.435091] iwl3945 0000:03:00.0:
0000000996^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.435121] iwl3945 0000:03:00.0:
0000001001^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.435152] iwl3945 0000:03:00.0:
0000001005^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.435182] iwl3945 0000:03:00.0:
0000001009^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.435212] iwl3945 0000:03:00.0:
0000001014^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.435241] iwl3945 0000:03:00.0:
0000001018^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.435271] iwl3945 0000:03:00.0:
0000001022^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.435301] iwl3945 0000:03:00.0:
0000001026^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.435332] iwl3945 0000:03:00.0:
0000001031^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.435362] iwl3945 0000:03:00.0:
0000001035^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.435392] iwl3945 0000:03:00.0:
0000001039^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.435422] iwl3945 0000:03:00.0:
0000001044^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.435451] iwl3945 0000:03:00.0:
0000001048^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.435481] iwl3945 0000:03:00.0:
0000001052^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.435511] iwl3945 0000:03:00.0:
0000001056^I0x00000000^I1106
Jan 26 22:24:03 rainbow kernel: [  130.435541] iwl3945 0000:03:00.0:
0000001061^I0x00000001^I1106
Jan 26 22:24:03 rainbow kernel: [  130.435571] iwl3945 0000:03:00.0:
0000001061^I0x0000000f^I1106
Jan 26 22:24:03 rainbow kernel: [  130.435601] iwl3945 0000:03:00.0:
0000001063^I0x00000411^I1105
Jan 26 22:24:03 rainbow kernel: [  130.435632] iwl3945 0000:03:00.0:
0000001066^I0x00000414^I1115
Jan 26 22:24:03 rainbow kernel: [  130.435662] iwl3945 0000:03:00.0:
0000001070^I0x0000000b^I0463
Jan 26 22:24:03 rainbow kernel: [  130.435692] iwl3945 0000:03:00.0:
0000001071^I0x0000000b^I0462
Jan 26 22:24:03 rainbow kernel: [  130.435721] iwl3945 0000:03:00.0:
0000001091^I0x000000aa^I0103
Jan 26 22:24:03 rainbow kernel: [  130.435751] iwl3945 0000:03:00.0:
0000001104^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.435781] iwl3945 0000:03:00.0:
0000001105^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.435812] iwl3945 0000:03:00.0:
0000001179^I0x00000001^I0353
Jan 26 22:24:03 rainbow kernel: [  130.435842] iwl3945 0000:03:00.0:
0000001190^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.435872] iwl3945 0000:03:00.0:
0000001196^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.435902] iwl3945 0000:03:00.0:
0000001198^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.435931] iwl3945 0000:03:00.0:
0000001269^I0x00000002^I0353
Jan 26 22:24:03 rainbow kernel: [  130.435961] iwl3945 0000:03:00.0:
0000001280^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.435991] iwl3945 0000:03:00.0:
0000001286^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436021] iwl3945 0000:03:00.0:
0000001288^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436051] iwl3945 0000:03:00.0:
0000001359^I0x00000003^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436081] iwl3945 0000:03:00.0:
0000001370^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436112] iwl3945 0000:03:00.0:
0000001377^I0x04030097^I0401
Jan 26 22:24:03 rainbow kernel: [  130.436142] iwl3945 0000:03:00.0:
0000001380^I0x0000000b^I0451
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000001399^I0x00000000^I0451
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000001414^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000001416^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000001489^I0x00000004^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000001500^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000001507^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000001508^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000001594^I0x00000005^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000001604^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000001611^I0x04040018^I0401
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000001621^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000001623^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000001697^I0x00000006^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000001708^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000001715^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000001716^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000001787^I0x00000007^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000001798^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000001804^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000001806^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000001876^I0x00000008^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000001887^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000001893^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000001895^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000001967^I0x00000009^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000001977^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000001984^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000001986^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000002056^I0x0000000a^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000002067^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000002073^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000002075^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000002144^I0x0000000b^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000002155^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000002161^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000002163^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000002233^I0x0000000c^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000002244^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000002251^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000002252^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000002322^I0x0000000d^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000002333^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000002339^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000002341^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000002410^I0x0000000e^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000002421^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000002427^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000002429^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000002498^I0x0000000f^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000002509^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000002516^I0x04050047^I0401
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000002520^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000002522^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000002593^I0x00000010^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000002604^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000002618^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000002620^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000002694^I0x00000011^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000002705^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000002712^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000002713^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000002786^I0x00000012^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000002797^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000002804^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000002805^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000002875^I0x00000013^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000002886^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000002892^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000002894^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000002965^I0x00000014^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000002976^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000002983^I0x04060047^I0401
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000002987^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000002989^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000003061^I0x00000015^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000003072^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000003088^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000003090^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000003164^I0x00000016^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000003175^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000003181^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000003183^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000003256^I0x00000017^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000003267^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000003273^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000003275^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000003346^I0x00000018^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000003357^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000003363^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000003365^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000003435^I0x00000019^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000003446^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000003453^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000003454^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000003524^I0x0000001a^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000003535^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000003542^I0x04070097^I0401
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000003545^I0x0000000b^I0451
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000003564^I0x00000000^I0451
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000003572^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000003573^I0x00000000^I0302
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000003576^I0x00008000^I0350
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000003586^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000003588^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000003662^I0x0000001b^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000003673^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000003680^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000003682^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000003756^I0x0000001c^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000003767^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000003968^I0x04080048^I0401
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000005674^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000005676^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000005766^I0x0000001d^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000005776^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000020374^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000020375^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000020755^I0x00000000^I0356
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000021061^I0x00000003^I0310
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000040410^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000040412^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000040792^I0x00000000^I0356
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000041293^I0x00000003^I0310
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000043710^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000043712^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000043792^I0x0000001e^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000043802^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000044173^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000044175^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000044554^I0x00000000^I0356
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000045305^I0x00000001^I0357
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000046285^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000046287^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000046668^I0x00000000^I0356
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000047234^I0x00000003^I0310
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000049251^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000049253^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000049262^I0x00008000^I0350
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000049323^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000049324^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000049334^I0x00008000^I0350
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000049416^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000049417^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000049427^I0x00008000^I0350
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000049478^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000049480^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000049489^I0x00008000^I0350
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000049504^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000049506^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000049515^I0x00008000^I0350
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000049527^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000049529^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000049635^I0x0000001f^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000049645^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000049747^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000049748^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000049822^I0x00000020^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000049833^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000049976^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000049978^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000050360^I0x00000000^I0356
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000050889^I0x00000003^I0310
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000050897^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000050898^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000050972^I0x00000021^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000050983^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000050990^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000050991^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000051079^I0x00000022^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000051089^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000051116^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000051118^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000051192^I0x00000023^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000051202^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000051267^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000051269^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000051343^I0x00000024^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000051353^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000051363^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000051365^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000051437^I0x00000025^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000051448^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000051471^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000051472^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000051547^I0x00000026^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000051557^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000051675^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000051677^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000051750^I0x00000027^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000051760^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000051862^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000051864^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000051939^I0x00000028^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000051950^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000052055^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000052057^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000052131^I0x00000029^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000052141^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000052161^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000052163^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000052236^I0x0000002a^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000052247^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000052305^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000052306^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000052381^I0x0000002b^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000052391^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000059149^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000059151^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000059160^I0x00008000^I0350
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000064098^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000064100^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000064173^I0x0000002c^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000064184^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000069945^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000069947^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000070020^I0x0000002d^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000070031^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000070832^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000070833^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000070952^I0x0000002e^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000070962^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000071058^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000071060^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000071133^I0x0000002f^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000071144^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000071368^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000071370^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000071379^I0x00008000^I0350
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000071473^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000071475^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000071551^I0x00000030^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000071562^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000075110^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000075112^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000075191^I0x00000031^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000075201^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000080668^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000080669^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000080990^I0x00000000^I0356
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000081515^I0x00000003^I0310
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000084340^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000084342^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000084723^I0x00000000^I0356
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000085436^I0x00000003^I0310
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000085915^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000085917^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000085992^I0x00000032^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000086002^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000086022^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000086024^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000086126^I0x00000033^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000086136^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000086226^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000086228^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000086304^I0x00000034^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000086314^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000086385^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000086387^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000086463^I0x00000035^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000086473^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000086488^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000086490^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000086567^I0x00000036^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000086578^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000086592^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000086594^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000086674^I0x00000037^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000086684^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000086692^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000086694^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000086768^I0x00000038^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000086778^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000086830^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000086832^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000086922^I0x00000039^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000086933^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000086940^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000086941^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000087018^I0x0000003a^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000087028^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000087046^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000087047^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000087140^I0x0000003b^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000087150^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000087171^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000087173^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000087265^I0x0000003c^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000087275^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000087351^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000087353^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000087444^I0x0000003d^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000087454^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000087462^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000087463^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000087540^I0x0000003e^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000087550^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000087560^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000087562^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000087635^I0x0000003f^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000087646^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000087708^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000087710^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000087787^I0x00000040^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000087797^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000087805^I0x000000d9^I0106
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000087807^I0x00000000^I0301
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000087885^I0x00000041^I0353
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000087896^I0x00000000^I0352
Jan 26 22:24:03 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000087949^I0x000000d9^I0106
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000087951^I0x00000000^I0301
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000088029^I0x00000042^I0353
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000088040^I0x00000000^I0352
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000088123^I0x000000d9^I0106
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000088125^I0x00000000^I0301
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000088199^I0x00000043^I0353
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000088209^I0x00000000^I0352
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000088347^I0x000000d9^I0106
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000088349^I0x00000000^I0301
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000088428^I0x00000044^I0353
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000088438^I0x00000000^I0352
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000088560^I0x000000d9^I0106
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000088562^I0x00000000^I0301
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000088718^I0x00000045^I0353
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000088728^I0x00000000^I0352
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000088872^I0x000000d9^I0106
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000088873^I0x00000000^I0301
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000088976^I0x00000046^I0353
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000088986^I0x00000000^I0352
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000089056^I0x000000d9^I0106
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000089058^I0x00000000^I0301
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000089135^I0x00000047^I0353
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000089146^I0x00000000^I0352
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000089180^I0x000000d9^I0106
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000089181^I0x00000000^I0301
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000089530^I0x00000000^I0356
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000090167^I0x00000003^I0310
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000090849^I0x000000d9^I0106
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000090851^I0x00000000^I0301
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000091043^I0x000000c4^I0303
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000099590^I0x000000d9^I0106
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000099592^I0x00000000^I0301
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000099770^I0x00000048^I0353
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000100033^I0x000000d9^I0106
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000100035^I0x00000000^I0301
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000100411^I0x00000000^I0304
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000102002^I0x000000d9^I0106
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000102003^I0x00000000^I0301
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000102382^I0x00000000^I0356
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000102911^I0x00000003^I0310
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000122769^I0x000000d9^I0106
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000122771^I0x00000000^I0301
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000123151^I0x00000000^I0356
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000123453^I0x00000003^I0310
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000129241^I0x000000d9^I0106
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000129243^I0x00000000^I0302
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000129275^I0x00000001^I0353
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000129295^I0x000000d9^I0106
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000129297^I0x00000000^I0302
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000129319^I0x00000002^I0353
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000129334^I0x000000d9^I0106
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000129336^I0x00000000^I0302
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000129353^I0x00000003^I0353
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000129418^I0x000000d9^I0106
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000129420^I0x00000000^I0301
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000129430^I0x00008000^I0350
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000129446^I0x000000d9^I0106
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000129448^I0x00000000^I0301
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000129457^I0x00008000^I0350
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000129478^I0x000000d9^I0106
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000129480^I0x00000000^I0302
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000129487^I0x00008000^I0350
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000129508^I0x000000d9^I0106
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000129510^I0x00000000^I0301
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000129519^I0x00008000^I0350
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000129532^I0x000000d9^I0106
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000129533^I0x00000000^I0301
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000129543^I0x00008000^I0350
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000131115^I0x000000d9^I0106
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000131116^I0x00000000^I0302
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000131145^I0x00000004^I0353
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000131233^I0x000000d9^I0106
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000131235^I0x00000000^I0301
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000131245^I0x00008000^I0350
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000131264^I0x000000d9^I0106
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000131266^I0x00000000^I0301
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000131338^I0x00000049^I0353
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000131348^I0x00000000^I0352
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000131368^I0x000000d9^I0106
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000131370^I0x00000000^I0301
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000131380^I0x00008000^I0350
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000131391^I0x000000d9^I0106
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000131393^I0x00000000^I0301
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000131402^I0x00008000^I0350
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000133451^I0x00010087^I0250
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000133457^I0x0000001c^I0218
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000332455^I0x00000040^I0218
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000332459^I0x00000000^I0218
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
0000332714^I0x00000100^I0125
Jan 26 22:24:04 rainbow kernel: [  130.436153] ieee80211 phy1: I
iwl3945_print_rx_config_cmd RX CONFIG:
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl data: 00000000: 00
1f 3c 20 a1 6e 00 00 00 00 00 00 00 00 00 00  ..< .n..........
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl data: 00000010: 00
00 00 00 00 00 00 00 03 00 00 00 ff 0f 00 00  ................
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl data: 00000020: 05
80 00 00 04 00 00 00 0b 00 00 00              ............
Jan 26 22:24:04 rainbow kernel: [  130.436153] ieee80211 phy1: I
iwl3945_print_rx_config_cmd u16 channel: 0xb
Jan 26 22:24:04 rainbow kernel: [  130.436153] ieee80211 phy1: I
iwl3945_print_rx_config_cmd u32 flags: 0x00008005
Jan 26 22:24:04 rainbow kernel: [  130.436153] ieee80211 phy1: I
iwl3945_print_rx_config_cmd u32 filter_flags: 0x00000004
Jan 26 22:24:04 rainbow kernel: [  130.436153] ieee80211 phy1: I
iwl3945_print_rx_config_cmd u8 dev_type: 0x3
Jan 26 22:24:04 rainbow kernel: [  130.436153] ieee80211 phy1: I
iwl3945_print_rx_config_cmd u8 ofdm_basic_rates: 0xff
Jan 26 22:24:04 rainbow kernel: [  130.436153] ieee80211 phy1: I
iwl3945_print_rx_config_cmd u8 cck_basic_rates: 0x0f
Jan 26 22:24:04 rainbow kernel: [  130.436153] ieee80211 phy1: I
iwl3945_print_rx_config_cmd u8[6] node_addr: 00:1f:3c:20:a1:6e
Jan 26 22:24:04 rainbow kernel: [  130.436153] ieee80211 phy1: I
iwl3945_print_rx_config_cmd u8[6] bssid_addr: 00:00:00:00:00:00
Jan 26 22:24:04 rainbow kernel: [  130.436153] ieee80211 phy1: I
iwl3945_print_rx_config_cmd u16 assoc_id: 0x0
Jan 26 22:24:04 rainbow kernel: [  130.436153] ieee80211 phy1: I
iwl3945_irq_handle_error Restarting adapter due to uCode error.
Jan 26 22:24:04 rainbow kernel: [  130.436153] ieee80211 phy1: I
iwl3945_rx_handle r = 25, i = 24, REPLY_ERROR, 0x02
Jan 26 22:24:04 rainbow kernel: [  130.436153] iwl3945 0000:03:00.0:
Error Reply type 0x00000001 cmd UNKNOWN (0x3C) seq 0x6EA1 ser
0x003C0000
Jan 26 22:24:04 rainbow kernel: [  130.448611] ieee80211 phy1: U
__iwl3945_down iwl3945 is going down
Jan 26 22:24:04 rainbow kernel: [  130.448834] ieee80211 phy1: U
iwl3945_apm_stop_master stop master
Jan 26 22:24:04 rainbow kernel: [  130.449542] ieee80211 phy1: U
iwl3945_apm_stop_master stop master
Jan 26 22:24:04 rainbow kernel: [  130.449656] ieee80211 phy1: U
iwl3945_clear_free_frames 0 frames on pre-allocated heap on clear.
Jan 26 22:24:04 rainbow kernel: [  130.449677] ieee80211 phy1: U
iwl3945_power_init_handle Initialize power
Jan 26 22:24:04 rainbow kernel: [  130.449693] ieee80211 phy1: U
iwl3945_power_init_handle adjust power command flags
Jan 26 22:24:04 rainbow kernel: [  130.449805] ieee80211 phy1: U
iwl3945_hw_nic_init HW Revision ID = 0x2
Jan 26 22:24:04 rainbow kernel: [  130.449857] ieee80211 phy1: U
iwl3945_nic_config 3945 RADIO-MM type
Jan 26 22:24:04 rainbow kernel: [  130.449870] ieee80211 phy1: U
iwl3945_nic_config SKU OP mode is basic
Jan 26 22:24:04 rainbow kernel: [  130.449877] ieee80211 phy1: U
iwl3945_nic_config 3945ABG revision is 0xF1
Jan 26 22:24:04 rainbow kernel: [  130.449890] ieee80211 phy1: U
iwl3945_nic_config Card M type B version is 0x3
Jan 26 22:24:04 rainbow kernel: [  130.453413] ieee80211 phy1: U
iwl3945_load_bsm Begin load bsm
Jan 26 22:24:04 rainbow kernel: [  130.454684] ieee80211 phy1: U
iwl3945_verify_bsm Begin verify bsm
Jan 26 22:24:04 rainbow kernel: [  130.456867] ieee80211 phy1: U
iwl3945_verify_bsm BSM bootstrap uCode image OK
Jan 26 22:24:04 rainbow kernel: [  130.456927] ieee80211 phy1: U
iwl3945_load_bsm BSM write complete, poll 1 iterations
Jan 26 22:24:04 rainbow kernel: [  130.456947] ieee80211 phy1: U
__iwl3945_up iwl3945 is coming up
Jan 26 22:24:04 rainbow kernel: [  130.468409] ieee80211 phy1: I
iwl3945_rx_handle r = 1, i = 0, REPLY_ALIVE, 0x01
Jan 26 22:24:04 rainbow kernel: [  130.468428] ieee80211 phy1: I
iwl3945_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x9
Jan 26 22:24:04 rainbow kernel: [  130.468437] ieee80211 phy1: I
iwl3945_rx_reply_alive Initialization Alive received.
Jan 26 22:24:04 rainbow kernel: [  130.476069] ieee80211 phy1: U
iwl3945_verify_inst_sparse ucode inst image size is 900
Jan 26 22:24:04 rainbow kernel: [  130.476178] ieee80211 phy1: U
iwl3945_verify_inst_sparse ucode inst image size is 2672
Jan 26 22:24:04 rainbow kernel: [  130.476467] ieee80211 phy1: U
iwl3945_verify_ucode Initialize uCode is good in inst SRAM
Jan 26 22:24:04 rainbow kernel: [  130.476476] ieee80211 phy1: U
iwl3945_init_alive_start Initialization Alive received.
Jan 26 22:24:04 rainbow kernel: [  130.476527] ieee80211 phy1: U
iwl3945_set_ucode_ptrs Runtime uCode pointers are set.
Jan 26 22:24:04 rainbow kernel: [  130.480914] ieee80211 phy1: I
iwl3945_rx_handle r = 2, i = 1, REPLY_ALIVE, 0x01
Jan 26 22:24:04 rainbow kernel: [  130.480930] ieee80211 phy1: I
iwl3945_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x0
Jan 26 22:24:04 rainbow kernel: [  130.480940] ieee80211 phy1: I
iwl3945_rx_reply_alive Runtime Alive received.
Jan 26 22:24:04 rainbow kernel: [  130.480989] ieee80211 phy1: I
iwl3945_disable_events Selected uCode log events may be disabled
Jan 26 22:24:04 rainbow kernel: [  130.480996] ieee80211 phy1: I
iwl3945_disable_events   by writing "1"s into disable bitmap
Jan 26 22:24:04 rainbow kernel: [  130.481006] ieee80211 phy1: I
iwl3945_disable_events   in SRAM at 0x8022c8, size 47 u32s
Jan 26 22:24:04 rainbow kernel: [  130.488063] ieee80211 phy1: U
iwl3945_alive_start Runtime Alive received.
Jan 26 22:24:04 rainbow kernel: [  130.488073] ieee80211 phy1: U
iwl3945_verify_inst_sparse ucode inst image size is 900
Jan 26 22:24:04 rainbow kernel: [  130.488159] ieee80211 phy1: U
iwl3945_verify_inst_sparse ucode inst image size is 2672
Jan 26 22:24:04 rainbow kernel: [  130.488245] ieee80211 phy1: U
iwl3945_verify_inst_sparse ucode inst image size is 80684
Jan 26 22:24:04 rainbow kernel: [  130.496041] ieee80211 phy1: U
iwl3945_verify_ucode Runtime uCode is good in inst SRAM
Jan 26 22:24:04 rainbow kernel: [  130.496079] ieee80211 phy1: U
iwl3945_alive_start RFKILL status: 0x1
Jan 26 22:24:04 rainbow kernel: [  130.496110] ieee80211 phy1: U
iwl3945_update_power_cmd Flags value = 0x00000008
Jan 26 22:24:04 rainbow kernel: [  130.496118] ieee80211 phy1: U
iwl3945_update_power_cmd Tx timeout = 0
Jan 26 22:24:04 rainbow kernel: [  130.496125] ieee80211 phy1: U
iwl3945_update_power_cmd Rx timeout = 0
Jan 26 22:24:04 rainbow kernel: [  130.496134] ieee80211 phy1: U
iwl3945_update_power_cmd Sleep interval vector = { 0 , 0 , 0 , 0 , 0 }
Jan 26 22:24:04 rainbow kernel: [  130.496149] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command POWER_TABLE_CMD (#77), seq: 0x0400,
36 bytes at 0[0]:4
Jan 26 22:24:04 rainbow kernel: [  130.496256] ieee80211 phy1: I
iwl3945_rx_handle r 3 i 2 No handler needed for POWER_TABLE_CMD, 0x77
Jan 26 22:24:04 rainbow kernel: [  130.496285] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_BT_CONFIG (#9b), seq: 0x0401,
16 bytes at 1[1]:4
Jan 26 22:24:04 rainbow kernel: [  130.496444] ieee80211 phy1: I
iwl3945_rx_handle r 4 i 3 No handler needed for REPLY_BT_CONFIG, 0x9b
Jan 26 22:24:04 rainbow kernel: [  130.496470] ieee80211 phy1: U
iwl3945_commit_rxon Sending RXON
Jan 26 22:24:04 rainbow kernel: [  130.496472] * without RXON_FILTER_ASSOC_MSK
Jan 26 22:24:04 rainbow kernel: [  130.496475] * channel = 11
Jan 26 22:24:04 rainbow kernel: [  130.496477] * bssid = 00:00:00:00:00:00
Jan 26 22:24:04 rainbow kernel: [  130.496496] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x0402, 48
bytes at 2[2]:4
Jan 26 22:24:04 rainbow kernel: [  130.497758] ieee80211 phy1: I
iwl3945_rx_handle r 5 i 4 No handler needed for REPLY_RXON, 0x10
Jan 26 22:24:04 rainbow kernel: [  130.497785] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 235 dsp 121 rate code 0x0d
Jan 26 22:24:04 rainbow kernel: [  130.497795] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 235 dsp 121 rate code 0x0f
Jan 26 22:24:04 rainbow kernel: [  130.497804] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 235 dsp 121 rate code 0x05
Jan 26 22:24:04 rainbow kernel: [  130.497812] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 235 dsp 121 rate code 0x07
Jan 26 22:24:04 rainbow kernel: [  130.497821] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 235 dsp 121 rate code 0x09
Jan 26 22:24:04 rainbow kernel: [  130.497830] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 235 dsp 121 rate code 0x0b
Jan 26 22:24:04 rainbow kernel: [  130.497838] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 235 dsp 121 rate code 0x01
Jan 26 22:24:04 rainbow kernel: [  130.497848] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 235 dsp 121 rate code 0x03
Jan 26 22:24:04 rainbow kernel: [  130.497856] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 171 dsp 110 rate code 0x0a
Jan 26 22:24:04 rainbow kernel: [  130.497866] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 171 dsp 110 rate code 0x14
Jan 26 22:24:04 rainbow kernel: [  130.497874] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 171 dsp 110 rate code 0x37
Jan 26 22:24:04 rainbow kernel: [  130.497882] ieee80211 phy1: U
iwl3945_send_tx_power ch 11:1 rf 171 dsp 110 rate code 0x6e
Jan 26 22:24:04 rainbow kernel: [  130.497894] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq:
0x0403, 56 bytes at 3[3]:4
Jan 26 22:24:04 rainbow kernel: [  130.497993] ieee80211 phy1: I
iwl3945_rx_handle r 6 i 5 No handler needed for
REPLY_TX_PWR_TABLE_CMD, 0x97
Jan 26 22:24:04 rainbow kernel: [  130.498063] ieee80211 phy1: U
iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
Jan 26 22:24:04 rainbow kernel: [  130.498076] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0404, 68
bytes at 4[4]:4
Jan 26 22:24:04 rainbow kernel: [  130.498156] ieee80211 phy1: I
iwl3945_rx_handle r = 7, i = 6, REPLY_ADD_STA, 0x18
Jan 26 22:24:04 rainbow kernel: [  130.498208] ieee80211 phy1: U
iwl_sta_ucode_activate Added STA to Ucode: 00:00:00:00:00:00
Jan 26 22:24:04 rainbow kernel: [  130.498219] ieee80211 phy1: U
iwl_send_add_sta REPLY_ADD_STA PASSED
Jan 26 22:24:04 rainbow kernel: [  130.498232] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0405,
56 bytes at 5[5]:4
Jan 26 22:24:04 rainbow kernel: [  130.498341] ieee80211 phy1: I
iwl3945_rx_handle r 8 i 7 No handler needed for REPLY_RATE_SCALE, 0x47
Jan 26 22:24:04 rainbow kernel: [  130.498374] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0406,
56 bytes at 6[6]:4
Jan 26 22:24:04 rainbow kernel: [  130.498481] ieee80211 phy1: I
iwl3945_rx_handle r 9 i 8 No handler needed for REPLY_RATE_SCALE, 0x47
Jan 26 22:24:04 rainbow kernel: [  130.498517] ieee80211 phy1: U
iwl3945_hw_reg_txpower_get_temperature Temperature: 108
Jan 26 22:24:04 rainbow kernel: [  130.498527] ieee80211 phy1: U
is_temp_calib_needed Getting cooler, delta -1,
Jan 26 22:24:04 rainbow kernel: [  130.498534] ieee80211 phy1: U
is_temp_calib_needed Timed thermal calib not needed
Jan 26 22:24:04 rainbow kernel: [  130.498618] Registered led device:
iwl-phy1:radio
Jan 26 22:24:04 rainbow kernel: [  130.498628] ieee80211 phy1: U
iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0407, 12
bytes at 7[7]:4
Jan 26 22:24:04 rainbow kernel: [  130.498706] ieee80211 phy1: I
iwl3945_rx_handle r 10 i 9 No handler needed for REPLY_LEDS_CMD, 0x48
Jan 26 22:24:04 rainbow kernel: [  130.498742] Registered led device:
iwl-phy1:assoc
Jan 26 22:24:04 rainbow kernel: [  130.498781] Registered led device:
iwl-phy1:RX
Jan 26 22:24:04 rainbow kernel: [  130.498815] Registered led device:
iwl-phy1:TX
Jan 26 22:24:04 rainbow kernel: [  130.498820] ieee80211 phy1: U
iwl3945_alive_start ALIVE processing complete.
Jan 26 22:24:04 rainbow kernel: [  130.530384] ieee80211 phy1: I
iwl3945_rx_handle r = 11, i = 10, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  130.550613] ieee80211 phy1: I
iwl3945_rx_handle r = 12, i = 11, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  130.555069] ieee80211 phy1: I
iwl3945_rx_handle r = 13, i = 12, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  130.556548] ieee80211 phy1: I
iwl3945_rx_handle r = 14, i = 13, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  130.560207] ieee80211 phy1: I
iwl3945_rx_handle r = 15, i = 14, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  130.594750] ieee80211 phy1: I
iwl3945_rx_handle r = 16, i = 15, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  130.596471] ieee80211 phy1: I
iwl3945_rx_handle r = 17, i = 16, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  130.599539] ieee80211 phy1: I
iwl3945_rx_handle r = 18, i = 17, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  130.613045] ieee80211 phy1: I
iwl3945_rx_handle r = 19, i = 18, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  130.632764] ieee80211 phy1: I
iwl3945_rx_handle r = 20, i = 19, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  130.636043] wlan0: direct probe to
AP 00:30:bd:c0:90:24 timed out
Jan 26 22:24:04 rainbow kernel: [  130.653007] ieee80211 phy1: I
iwl3945_rx_handle r = 21, i = 20, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  130.658974] ieee80211 phy1: I
iwl3945_rx_handle r = 22, i = 21, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  130.662626] ieee80211 phy1: I
iwl3945_rx_handle r = 23, i = 22, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  130.693256] ieee80211 phy1: I
iwl3945_rx_handle r = 24, i = 23, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  130.697155] ieee80211 phy1: I
iwl3945_rx_handle r = 25, i = 24, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  130.699076] ieee80211 phy1: I
iwl3945_rx_handle r = 26, i = 25, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  130.715600] ieee80211 phy1: I
iwl3945_rx_handle r = 27, i = 26, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  130.735166] ieee80211 phy1: I
iwl3945_rx_handle r = 28, i = 27, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  130.755467] ieee80211 phy1: I
iwl3945_rx_handle r = 29, i = 28, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  130.765253] ieee80211 phy1: I
iwl3945_rx_handle r = 30, i = 29, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  130.795685] ieee80211 phy1: I
iwl3945_rx_handle r = 31, i = 30, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  130.800081] ieee80211 phy1: I
iwl3945_rx_handle r = 32, i = 31, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  130.801575] ieee80211 phy1: I
iwl3945_rx_handle r = 33, i = 32, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  130.817111] ieee80211 phy1: I
iwl3945_rx_handle r = 34, i = 33, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  130.837644] ieee80211 phy1: I
iwl3945_rx_handle r = 35, i = 34, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  130.859059] ieee80211 phy1: I
iwl3945_rx_handle r = 36, i = 35, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  130.863825] ieee80211 phy1: I
iwl3945_rx_handle r = 37, i = 36, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  130.867466] ieee80211 phy1: I
iwl3945_rx_handle r = 38, i = 37, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  130.902028] ieee80211 phy1: I
iwl3945_rx_handle r = 39, i = 38, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  130.904062] ieee80211 phy1: I
iwl3945_rx_handle r = 40, i = 39, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  130.940046] ieee80211 phy1: I
iwl3945_rx_handle r = 41, i = 40, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  130.966224] ieee80211 phy1: I
iwl3945_rx_handle r = 42, i = 41, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  130.967991] ieee80211 phy1: I
iwl3945_rx_handle r = 43, i = 42, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  130.969842] ieee80211 phy1: I
iwl3945_rx_handle r = 44, i = 43, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  131.004431] ieee80211 phy1: I
iwl3945_rx_handle r = 45, i = 44, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  131.006360] ieee80211 phy1: I
iwl3945_rx_handle r = 46, i = 45, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  131.022716] ieee80211 phy1: I
iwl3945_rx_handle r = 47, i = 46, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  131.062684] ieee80211 phy1: I
iwl3945_rx_handle r = 48, i = 47, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  131.072391] ieee80211 phy1: I
iwl3945_rx_handle r = 49, i = 48, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  131.073325] ieee80211 phy1: I
iwl3945_rx_handle r = 50, i = 49, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  131.106841] ieee80211 phy1: I
iwl3945_rx_handle r = 51, i = 50, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  131.124362] ieee80211 phy1: I
iwl3945_rx_handle r = 52, i = 51, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  131.144850] ieee80211 phy1: I
iwl3945_rx_handle r = 53, i = 52, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  131.165098] ieee80211 phy1: I
iwl3945_rx_handle r = 54, i = 53, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  131.171023] ieee80211 phy1: I
iwl3945_rx_handle r = 55, i = 54, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  131.174617] ieee80211 phy1: I
iwl3945_rx_handle r = 56, i = 55, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  131.209759] ieee80211 phy1: I
iwl3945_rx_handle r = 57, i = 56, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  131.211259] ieee80211 phy1: I
iwl3945_rx_handle r = 58, i = 57, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  131.227206] ieee80211 phy1: I
iwl3945_rx_handle r = 59, i = 58, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  131.247250] ieee80211 phy1: I
iwl3945_rx_handle r = 60, i = 59, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  131.267483] ieee80211 phy1: I
iwl3945_rx_handle r = 61, i = 60, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  131.273432] ieee80211 phy1: I
iwl3945_rx_handle r = 62, i = 61, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  131.275195] ieee80211 phy1: I
iwl3945_rx_handle r = 63, i = 62, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  131.277018] ieee80211 phy1: I
iwl3945_rx_handle r = 64, i = 63, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  131.311638] ieee80211 phy1: I
iwl3945_rx_handle r = 65, i = 64, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  131.313483] ieee80211 phy1: I
iwl3945_rx_handle r = 66, i = 65, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  131.316433] ieee80211 phy1: I
iwl3945_rx_handle r = 67, i = 66, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  131.349648] ieee80211 phy1: I
iwl3945_rx_handle r = 68, i = 67, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  131.369889] ieee80211 phy1: I
iwl3945_rx_handle r = 69, i = 68, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  131.375823] ieee80211 phy1: I
iwl3945_rx_handle r = 70, i = 69, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  131.379479] ieee80211 phy1: I
iwl3945_rx_handle r = 71, i = 70, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  131.414041] ieee80211 phy1: I
iwl3945_rx_handle r = 72, i = 71, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  131.416878] ieee80211 phy1: I
iwl3945_rx_handle r = 73, i = 72, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  131.432341] ieee80211 phy1: I
iwl3945_rx_handle r = 74, i = 73, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  131.452050] ieee80211 phy1: I
iwl3945_rx_handle r = 75, i = 74, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  131.478226] ieee80211 phy1: I
iwl3945_rx_handle r = 76, i = 75, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  131.481884] ieee80211 phy1: I
iwl3945_rx_handle r = 77, i = 76, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  131.512507] ieee80211 phy1: I
iwl3945_rx_handle r = 78, i = 77, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  131.516421] ieee80211 phy1: I
iwl3945_rx_handle r = 79, i = 78, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  131.518002] ieee80211 phy1: I
iwl3945_rx_handle r = 80, i = 79, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  131.521218] ieee80211 phy1: I
iwl3945_rx_handle r = 81, i = 80, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  131.554453] ieee80211 phy1: I
iwl3945_rx_handle r = 82, i = 81, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  131.574707] ieee80211 phy1: I
iwl3945_rx_handle r = 83, i = 82, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  131.584279] ieee80211 phy1: I
iwl3945_rx_handle r = 84, i = 83, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  131.618849] ieee80211 phy1: I
iwl3945_rx_handle r = 85, i = 84, REPLY_3945_RX, 0x1b
Jan 26 22:24:04 rainbow kernel: [  131.656853] ieee80211 phy1: I
iwl3945_rx_handle r = 86, i = 85, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  131.677132] ieee80211 phy1: I
iwl3945_rx_handle r = 87, i = 86, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  131.682976] ieee80211 phy1: I
iwl3945_rx_handle r = 88, i = 87, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  131.686698] ieee80211 phy1: I
iwl3945_rx_handle r = 89, i = 88, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  131.717314] ieee80211 phy1: I
iwl3945_rx_handle r = 90, i = 89, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  131.721201] ieee80211 phy1: I
iwl3945_rx_handle r = 91, i = 90, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  131.726014] ieee80211 phy1: I
iwl3945_rx_handle r = 92, i = 91, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  131.738740] ieee80211 phy1: I
iwl3945_rx_handle r = 93, i = 92, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  131.759258] ieee80211 phy1: I
iwl3945_rx_handle r = 94, i = 93, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  131.779490] ieee80211 phy1: I
iwl3945_rx_handle r = 95, i = 94, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  131.787204] ieee80211 phy1: I
iwl3945_rx_handle r = 96, i = 95, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  131.789065] ieee80211 phy1: I
iwl3945_rx_handle r = 97, i = 96, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  131.819716] ieee80211 phy1: I
iwl3945_rx_handle r = 98, i = 97, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  131.824143] ieee80211 phy1: I
iwl3945_rx_handle r = 99, i = 98, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  131.861660] ieee80211 phy1: I
iwl3945_rx_handle r = 100, i = 99, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  131.885931] ieee80211 phy1: I
iwl3945_rx_handle r = 101, i = 100, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  131.887832] ieee80211 phy1: I
iwl3945_rx_handle r = 102, i = 101, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  131.889580] ieee80211 phy1: I
iwl3945_rx_handle r = 103, i = 102, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  131.891490] ieee80211 phy1: I
iwl3945_rx_handle r = 104, i = 103, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  131.922122] ieee80211 phy1: I
iwl3945_rx_handle r = 105, i = 104, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  131.926644] ieee80211 phy1: I
iwl3945_rx_handle r = 106, i = 105, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  131.928636] ieee80211 phy1: I
iwl3945_rx_handle r = 107, i = 106, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  131.944693] ieee80211 phy1: I
iwl3945_rx_handle r = 108, i = 107, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  131.964063] ieee80211 phy1: I
iwl3945_rx_handle r = 109, i = 108, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  131.987290] ieee80211 phy1: I
iwl3945_rx_handle r = 110, i = 109, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  131.990314] ieee80211 phy1: I
iwl3945_rx_handle r = 111, i = 110, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  131.993882] ieee80211 phy1: I
iwl3945_rx_handle r = 112, i = 111, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  132.028470] ieee80211 phy1: I
iwl3945_rx_handle r = 113, i = 112, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  132.030039] ieee80211 phy1: I
iwl3945_rx_handle r = 114, i = 113, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  132.033182] ieee80211 phy1: I
iwl3945_rx_handle r = 115, i = 114, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  132.047104] ieee80211 phy1: I
iwl3945_rx_handle r = 116, i = 115, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  132.066462] ieee80211 phy1: I
iwl3945_rx_handle r = 117, i = 116, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  132.086693] ieee80211 phy1: I
iwl3945_rx_handle r = 118, i = 117, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  132.094416] ieee80211 phy1: I
iwl3945_rx_handle r = 119, i = 118, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  132.096237] ieee80211 phy1: I
iwl3945_rx_handle r = 120, i = 119, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  132.130870] ieee80211 phy1: I
iwl3945_rx_handle r = 121, i = 120, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  132.132942] ieee80211 phy1: I
iwl3945_rx_handle r = 122, i = 121, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  132.149546] ieee80211 phy1: I
iwl3945_rx_handle r = 123, i = 122, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  132.168864] ieee80211 phy1: I
iwl3945_rx_handle r = 124, i = 123, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  132.189611] ieee80211 phy1: I
iwl3945_rx_handle r = 125, i = 124, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  132.193162] ieee80211 phy1: I
iwl3945_rx_handle r = 126, i = 125, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  132.198697] ieee80211 phy1: I
iwl3945_rx_handle r = 127, i = 126, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  132.219420] ieee80211 phy1: I
iwl3945_rx_handle r = 128, i = 127, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  132.229326] ieee80211 phy1: I
iwl3945_rx_handle r = 129, i = 128, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  132.233272] ieee80211 phy1: I
iwl3945_rx_handle r = 130, i = 129, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  132.234843] ieee80211 phy1: I
iwl3945_rx_handle r = 131, i = 130, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  132.237980] ieee80211 phy1: I
iwl3945_rx_handle r = 132, i = 131, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  132.251827] ieee80211 phy1: I
iwl3945_rx_handle r = 133, i = 132, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  132.271265] ieee80211 phy1: I
iwl3945_rx_handle r = 134, i = 133, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  132.291501] ieee80211 phy1: I
iwl3945_rx_handle r = 135, i = 134, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  132.336288] ieee80211 phy1: I
iwl3945_rx_handle r = 136, i = 135, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  132.337777] ieee80211 phy1: I
iwl3945_rx_handle r = 137, i = 136, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  132.354049] ieee80211 phy1: I
iwl3945_rx_handle r = 138, i = 137, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  132.373665] ieee80211 phy1: I
iwl3945_rx_handle r = 139, i = 138, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  132.394308] ieee80211 phy1: I
iwl3945_rx_handle r = 140, i = 139, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  132.399853] ieee80211 phy1: I
iwl3945_rx_handle r = 141, i = 140, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  132.401611] ieee80211 phy1: I
iwl3945_rx_handle r = 142, i = 141, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  132.403494] ieee80211 phy1: I
iwl3945_rx_handle r = 143, i = 142, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  132.438080] ieee80211 phy1: I
iwl3945_rx_handle r = 144, i = 143, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  132.456242] ieee80211 phy1: I
iwl3945_rx_handle r = 145, i = 144, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  132.476069] ieee80211 phy1: I
iwl3945_rx_handle r = 146, i = 145, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  132.496309] ieee80211 phy1: I
iwl3945_rx_handle r = 147, i = 146, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  132.505898] ieee80211 phy1: I
iwl3945_rx_handle r = 148, i = 147, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  132.541081] ieee80211 phy1: I
iwl3945_rx_handle r = 149, i = 148, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  132.558822] ieee80211 phy1: I
iwl3945_rx_handle r = 150, i = 149, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  132.578466] ieee80211 phy1: I
iwl3945_rx_handle r = 151, i = 150, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  132.598706] ieee80211 phy1: I
iwl3945_rx_handle r = 152, i = 151, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  132.602755] ieee80211 phy1: I
iwl3945_rx_handle r = 153, i = 152, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  132.604593] ieee80211 phy1: I
iwl3945_rx_handle r = 154, i = 153, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  132.606443] ieee80211 phy1: I
iwl3945_rx_handle r = 155, i = 154, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  132.608271] ieee80211 phy1: I
iwl3945_rx_handle r = 156, i = 155, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  132.638936] ieee80211 phy1: I
iwl3945_rx_handle r = 157, i = 156, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  132.642884] ieee80211 phy1: I
iwl3945_rx_handle r = 158, i = 157, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  132.644835] ieee80211 phy1: I
iwl3945_rx_handle r = 159, i = 158, REPLY_3945_RX, 0x1b
Jan 26 22:24:05 rainbow kernel: [  132.660373] ieee80211 phy1: I
iwl3945_rx_handle r = 160, i = 159, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  132.680856] ieee80211 phy1: I
iwl3945_rx_handle r = 161, i = 160, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  132.701115] ieee80211 phy1: I
iwl3945_rx_handle r = 162, i = 161, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  132.707086] ieee80211 phy1: I
iwl3945_rx_handle r = 163, i = 162, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  132.710707] ieee80211 phy1: I
iwl3945_rx_handle r = 164, i = 163, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  132.745354] ieee80211 phy1: I
iwl3945_rx_handle r = 165, i = 164, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  132.746830] ieee80211 phy1: I
iwl3945_rx_handle r = 166, i = 165, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  132.750055] ieee80211 phy1: I
iwl3945_rx_handle r = 167, i = 166, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  132.763519] ieee80211 phy1: I
iwl3945_rx_handle r = 168, i = 167, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  132.783255] ieee80211 phy1: I
iwl3945_rx_handle r = 169, i = 168, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  132.803463] ieee80211 phy1: I
iwl3945_rx_handle r = 170, i = 169, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  132.807509] ieee80211 phy1: I
iwl3945_rx_handle r = 171, i = 170, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  132.813063] ieee80211 phy1: I
iwl3945_rx_handle r = 172, i = 171, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  132.847663] ieee80211 phy1: I
iwl3945_rx_handle r = 173, i = 172, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  132.849182] ieee80211 phy1: I
iwl3945_rx_handle r = 174, i = 173, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  132.853440] ieee80211 phy1: I
iwl3945_rx_handle r = 175, i = 174, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  132.866378] ieee80211 phy1: I
iwl3945_rx_handle r = 176, i = 175, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  132.885613] ieee80211 phy1: I
iwl3945_rx_handle r = 177, i = 176, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  132.905877] ieee80211 phy1: I
iwl3945_rx_handle r = 178, i = 177, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  132.913589] ieee80211 phy1: I
iwl3945_rx_handle r = 179, i = 178, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  132.915438] ieee80211 phy1: I
iwl3945_rx_handle r = 180, i = 179, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  132.946078] ieee80211 phy1: I
iwl3945_rx_handle r = 181, i = 180, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  132.950608] ieee80211 phy1: I
iwl3945_rx_handle r = 182, i = 181, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  132.952091] ieee80211 phy1: I
iwl3945_rx_handle r = 183, i = 182, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  132.988071] ieee80211 phy1: I
iwl3945_rx_handle r = 184, i = 183, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  133.014210] ieee80211 phy1: I
iwl3945_rx_handle r = 185, i = 184, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  133.017853] ieee80211 phy1: I
iwl3945_rx_handle r = 186, i = 185, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  133.048522] ieee80211 phy1: I
iwl3945_rx_handle r = 187, i = 186, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  133.053042] ieee80211 phy1: I
iwl3945_rx_handle r = 188, i = 187, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  133.054509] ieee80211 phy1: I
iwl3945_rx_handle r = 189, i = 188, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  133.070793] ieee80211 phy1: I
iwl3945_rx_handle r = 190, i = 189, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  133.090439] ieee80211 phy1: I
iwl3945_rx_handle r = 191, i = 190, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  133.110643] ieee80211 phy1: I
iwl3945_rx_handle r = 192, i = 191, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  133.120250] ieee80211 phy1: I
iwl3945_rx_handle r = 193, i = 192, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  133.155356] ieee80211 phy1: I
iwl3945_rx_handle r = 194, i = 193, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  133.157844] ieee80211 phy1: I
iwl3945_rx_handle r = 195, i = 194, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  133.192867] ieee80211 phy1: I
iwl3945_rx_handle r = 196, i = 195, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  133.213161] ieee80211 phy1: I
iwl3945_rx_handle r = 197, i = 196, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  133.217158] ieee80211 phy1: I
iwl3945_rx_handle r = 198, i = 197, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  133.220849] ieee80211 phy1: I
iwl3945_rx_handle r = 199, i = 198, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  133.222698] ieee80211 phy1: I
iwl3945_rx_handle r = 200, i = 199, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  133.257671] ieee80211 phy1: I
iwl3945_rx_handle r = 201, i = 200, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  133.259156] ieee80211 phy1: I
iwl3945_rx_handle r = 202, i = 201, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  133.274810] ieee80211 phy1: I
iwl3945_rx_handle r = 203, i = 202, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  133.295265] ieee80211 phy1: I
iwl3945_rx_handle r = 204, i = 203, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  133.315496] ieee80211 phy1: I
iwl3945_rx_handle r = 205, i = 204, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  133.319557] ieee80211 phy1: I
iwl3945_rx_handle r = 206, i = 205, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  133.321414] ieee80211 phy1: I
iwl3945_rx_handle r = 207, i = 206, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  133.325300] ieee80211 phy1: I
iwl3945_rx_handle r = 208, i = 207, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  133.355688] ieee80211 phy1: I
iwl3945_rx_handle r = 209, i = 208, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  133.359678] ieee80211 phy1: I
iwl3945_rx_handle r = 210, i = 209, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  133.361200] ieee80211 phy1: I
iwl3945_rx_handle r = 211, i = 210, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  133.364434] ieee80211 phy1: I
iwl3945_rx_handle r = 212, i = 211, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  133.378023] ieee80211 phy1: I
iwl3945_rx_handle r = 213, i = 212, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  133.397681] ieee80211 phy1: I
iwl3945_rx_handle r = 214, i = 213, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  133.417868] ieee80211 phy1: I
iwl3945_rx_handle r = 215, i = 214, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  133.423812] ieee80211 phy1: I
iwl3945_rx_handle r = 216, i = 215, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  133.427458] ieee80211 phy1: I
iwl3945_rx_handle r = 217, i = 216, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  133.462613] ieee80211 phy1: I
iwl3945_rx_handle r = 218, i = 217, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  133.479718] ieee80211 phy1: I
iwl3945_rx_handle r = 219, i = 218, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  133.500067] ieee80211 phy1: I
iwl3945_rx_handle r = 220, i = 219, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  133.520278] ieee80211 phy1: I
iwl3945_rx_handle r = 221, i = 220, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  133.526213] ieee80211 phy1: I
iwl3945_rx_handle r = 222, i = 221, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  133.543119] ieee80211 phy1: I
iwl3945_rx_handle r = 223, i = 222, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  133.560548] ieee80211 phy1: I
iwl3945_rx_handle r = 224, i = 223, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  133.565076] ieee80211 phy1: I
iwl3945_rx_handle r = 225, i = 224, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  133.566550] ieee80211 phy1: I
iwl3945_rx_handle r = 226, i = 225, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  133.602494] ieee80211 phy1: I
iwl3945_rx_handle r = 227, i = 226, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  133.622718] ieee80211 phy1: I
iwl3945_rx_handle r = 228, i = 227, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  133.628674] ieee80211 phy1: I
iwl3945_rx_handle r = 229, i = 228, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  133.632296] ieee80211 phy1: I
iwl3945_rx_handle r = 230, i = 229, REPLY_3945_RX, 0x1b
Jan 26 22:24:06 rainbow kernel: [  133.666921] ieee80211 phy1: I
iwl3945_rx_handle r = 231, i = 230, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  133.685223] ieee80211 phy1: I
iwl3945_rx_handle r = 232, i = 231, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  133.704881] ieee80211 phy1: I
iwl3945_rx_handle r = 233, i = 232, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  133.725233] ieee80211 phy1: I
iwl3945_rx_handle r = 234, i = 233, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  133.729194] ieee80211 phy1: I
iwl3945_rx_handle r = 235, i = 234, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  133.731073] ieee80211 phy1: I
iwl3945_rx_handle r = 236, i = 235, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  133.734722] ieee80211 phy1: I
iwl3945_rx_handle r = 237, i = 236, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  133.765356] ieee80211 phy1: I
iwl3945_rx_handle r = 238, i = 237, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  133.769875] ieee80211 phy1: I
iwl3945_rx_handle r = 239, i = 238, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  133.771362] ieee80211 phy1: I
iwl3945_rx_handle r = 240, i = 239, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  133.774014] ieee80211 phy1: I
iwl3945_rx_handle r = 241, i = 240, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  133.787649] ieee80211 phy1: I
iwl3945_rx_handle r = 242, i = 241, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  133.807286] ieee80211 phy1: I
iwl3945_rx_handle r = 243, i = 242, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  133.827950] ieee80211 phy1: I
iwl3945_rx_handle r = 244, i = 243, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  133.835270] ieee80211 phy1: I
iwl3945_rx_handle r = 245, i = 244, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  133.837123] ieee80211 phy1: I
iwl3945_rx_handle r = 246, i = 245, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  133.867762] ieee80211 phy1: I
iwl3945_rx_handle r = 247, i = 246, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  133.871718] ieee80211 phy1: I
iwl3945_rx_handle r = 248, i = 247, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  133.873262] ieee80211 phy1: I
iwl3945_rx_handle r = 249, i = 248, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  133.929928] ieee80211 phy1: I
iwl3945_rx_handle r = 250, i = 249, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  133.934000] ieee80211 phy1: I
iwl3945_rx_handle r = 251, i = 250, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  133.939532] ieee80211 phy1: I
iwl3945_rx_handle r = 252, i = 251, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  133.974727] ieee80211 phy1: I
iwl3945_rx_handle r = 253, i = 252, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  133.992487] ieee80211 phy1: I
iwl3945_rx_handle r = 254, i = 253, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  134.012103] ieee80211 phy1: I
iwl3945_rx_handle r = 255, i = 254, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  134.032329] ieee80211 phy1: I
iwl3945_rx_handle r = 0, i = 255, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  134.036375] ieee80211 phy1: I
iwl3945_rx_handle r = 1, i = 0, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  134.038280] ieee80211 phy1: I
iwl3945_rx_handle r = 2, i = 1, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  134.041926] ieee80211 phy1: I
iwl3945_rx_handle r = 3, i = 2, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  134.044835] ieee80211 phy1: I
iwl3945_rx_handle r = 4, i = 3, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  134.076530] ieee80211 phy1: I
iwl3945_rx_handle r = 5, i = 4, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  134.081301] ieee80211 phy1: I
iwl3945_rx_handle r = 6, i = 5, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  134.114442] ieee80211 phy1: I
iwl3945_rx_handle r = 7, i = 6, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  134.134714] ieee80211 phy1: I
iwl3945_rx_handle r = 8, i = 7, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  134.140629] ieee80211 phy1: I
iwl3945_rx_handle r = 9, i = 8, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  134.144579] ieee80211 phy1: I
iwl3945_rx_handle r = 10, i = 9, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  134.178935] ieee80211 phy1: I
iwl3945_rx_handle r = 11, i = 10, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  134.180436] ieee80211 phy1: I
iwl3945_rx_handle r = 12, i = 11, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  134.183639] ieee80211 phy1: I
iwl3945_rx_handle r = 13, i = 12, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  134.216891] ieee80211 phy1: I
iwl3945_rx_handle r = 14, i = 13, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  134.237108] ieee80211 phy1: I
iwl3945_rx_handle r = 15, i = 14, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  134.243086] ieee80211 phy1: I
iwl3945_rx_handle r = 16, i = 15, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  134.244870] ieee80211 phy1: I
iwl3945_rx_handle r = 17, i = 16, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  134.246728] ieee80211 phy1: I
iwl3945_rx_handle r = 18, i = 17, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  134.267493] ieee80211 phy1: I
iwl3945_rx_handle r = 19, i = 18, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  134.277361] ieee80211 phy1: I
iwl3945_rx_handle r = 20, i = 19, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  134.281971] ieee80211 phy1: I
iwl3945_rx_handle r = 21, i = 20, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  134.283461] ieee80211 phy1: I
iwl3945_rx_handle r = 22, i = 21, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  134.319297] ieee80211 phy1: I
iwl3945_rx_handle r = 23, i = 22, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  134.339532] ieee80211 phy1: I
iwl3945_rx_handle r = 24, i = 23, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  134.343609] ieee80211 phy1: I
iwl3945_rx_handle r = 25, i = 24, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  134.349137] ieee80211 phy1: I
iwl3945_rx_handle r = 26, i = 25, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  134.384265] ieee80211 phy1: I
iwl3945_rx_handle r = 27, i = 26, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  134.385750] ieee80211 phy1: I
iwl3945_rx_handle r = 28, i = 27, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  134.389801] ieee80211 phy1: I
iwl3945_rx_handle r = 29, i = 28, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  134.403442] ieee80211 phy1: I
iwl3945_rx_handle r = 30, i = 29, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  134.421703] ieee80211 phy1: I
iwl3945_rx_handle r = 31, i = 30, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  134.441934] ieee80211 phy1: I
iwl3945_rx_handle r = 32, i = 31, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  134.446012] ieee80211 phy1: I
iwl3945_rx_handle r = 33, i = 32, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  134.451537] ieee80211 phy1: I
iwl3945_rx_handle r = 34, i = 33, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  134.482175] ieee80211 phy1: I
iwl3945_rx_handle r = 35, i = 34, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  134.486727] ieee80211 phy1: I
iwl3945_rx_handle r = 36, i = 35, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  134.524103] ieee80211 phy1: I
iwl3945_rx_handle r = 37, i = 36, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  134.550372] ieee80211 phy1: I
iwl3945_rx_handle r = 38, i = 37, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  134.552098] ieee80211 phy1: I
iwl3945_rx_handle r = 39, i = 38, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  134.553939] ieee80211 phy1: I
iwl3945_rx_handle r = 40, i = 39, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  134.588556] ieee80211 phy1: I
iwl3945_rx_handle r = 41, i = 40, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  134.626503] ieee80211 phy1: I
iwl3945_rx_handle r = 42, i = 41, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  134.646739] ieee80211 phy1: I
iwl3945_rx_handle r = 43, i = 42, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  134.650821] ieee80211 phy1: I
iwl3945_rx_handle r = 44, i = 43, REPLY_3945_RX, 0x1b
Jan 26 22:24:07 rainbow kernel: [  134.656314] ieee80211 phy1: I
iwl3945_rx_handle r = 45, i = 44, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  134.691526] ieee80211 phy1: I
iwl3945_rx_handle r = 46, i = 45, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  134.693040] ieee80211 phy1: I
iwl3945_rx_handle r = 47, i = 46, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  134.709182] ieee80211 phy1: I
iwl3945_rx_handle r = 48, i = 47, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  134.728896] ieee80211 phy1: I
iwl3945_rx_handle r = 49, i = 48, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  134.749103] ieee80211 phy1: I
iwl3945_rx_handle r = 50, i = 49, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  134.753222] ieee80211 phy1: I
iwl3945_rx_handle r = 51, i = 50, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  134.756899] ieee80211 phy1: I
iwl3945_rx_handle r = 52, i = 51, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  134.758751] ieee80211 phy1: I
iwl3945_rx_handle r = 53, i = 52, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  134.794338] ieee80211 phy1: I
iwl3945_rx_handle r = 54, i = 53, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  134.795831] ieee80211 phy1: I
iwl3945_rx_handle r = 55, i = 54, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  134.831298] ieee80211 phy1: I
iwl3945_rx_handle r = 56, i = 55, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  134.855624] ieee80211 phy1: I
iwl3945_rx_handle r = 57, i = 56, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  134.861103] ieee80211 phy1: I
iwl3945_rx_handle r = 58, i = 57, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  134.896194] ieee80211 phy1: I
iwl3945_rx_handle r = 59, i = 58, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  134.898192] ieee80211 phy1: I
iwl3945_rx_handle r = 60, i = 59, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  134.914061] ieee80211 phy1: I
iwl3945_rx_handle r = 61, i = 60, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  134.933702] ieee80211 phy1: I
iwl3945_rx_handle r = 62, i = 61, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  134.953911] ieee80211 phy1: I
iwl3945_rx_handle r = 63, i = 62, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  134.959893] ieee80211 phy1: I
iwl3945_rx_handle r = 64, i = 63, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  134.961708] ieee80211 phy1: I
iwl3945_rx_handle r = 65, i = 64, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  134.963539] ieee80211 phy1: I
iwl3945_rx_handle r = 66, i = 65, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  134.998115] ieee80211 phy1: I
iwl3945_rx_handle r = 67, i = 66, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  134.999664] ieee80211 phy1: I
iwl3945_rx_handle r = 68, i = 67, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  135.002860] ieee80211 phy1: I
iwl3945_rx_handle r = 69, i = 68, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  135.004104] ieee80211 phy1: I
iwl3945_rx_handle r = 70, i = 69, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  135.016365] ieee80211 phy1: I
iwl3945_rx_handle r = 71, i = 70, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  135.036052] ieee80211 phy1: I
iwl3945_rx_handle r = 72, i = 71, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  135.056648] ieee80211 phy1: I
iwl3945_rx_handle r = 73, i = 72, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  135.060428] ieee80211 phy1: I
iwl3945_rx_handle r = 74, i = 73, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  135.062304] ieee80211 phy1: I
iwl3945_rx_handle r = 75, i = 74, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  135.064096] ieee80211 phy1: I
iwl3945_rx_handle r = 76, i = 75, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  135.065899] ieee80211 phy1: I
iwl3945_rx_handle r = 77, i = 76, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  135.096527] ieee80211 phy1: I
iwl3945_rx_handle r = 78, i = 77, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  135.100548] ieee80211 phy1: I
iwl3945_rx_handle r = 79, i = 78, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  135.102033] ieee80211 phy1: I
iwl3945_rx_handle r = 80, i = 79, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  135.105267] ieee80211 phy1: I
iwl3945_rx_handle r = 81, i = 80, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  135.118061] ieee80211 phy1: I
iwl3945_rx_handle r = 82, i = 81, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  135.138507] ieee80211 phy1: I
iwl3945_rx_handle r = 83, i = 82, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  135.158754] ieee80211 phy1: I
iwl3945_rx_handle r = 84, i = 83, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  135.162788] ieee80211 phy1: I
iwl3945_rx_handle r = 85, i = 84, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  135.168868] ieee80211 phy1: I
iwl3945_rx_handle r = 86, i = 85, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  135.198935] ieee80211 phy1: I
iwl3945_rx_handle r = 87, i = 86, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  135.202941] ieee80211 phy1: I
iwl3945_rx_handle r = 88, i = 87, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  135.204913] ieee80211 phy1: I
iwl3945_rx_handle r = 89, i = 88, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  135.220823] ieee80211 phy1: I
iwl3945_rx_handle r = 90, i = 89, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  135.240854] ieee80211 phy1: I
iwl3945_rx_handle r = 91, i = 90, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  135.261142] ieee80211 phy1: I
iwl3945_rx_handle r = 92, i = 91, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  135.268894] ieee80211 phy1: I
iwl3945_rx_handle r = 93, i = 92, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  135.270690] ieee80211 phy1: I
iwl3945_rx_handle r = 94, i = 93, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  135.301351] ieee80211 phy1: I
iwl3945_rx_handle r = 95, i = 94, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  135.305904] ieee80211 phy1: I
iwl3945_rx_handle r = 96, i = 95, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  135.322865] ieee80211 phy1: I
iwl3945_rx_handle r = 97, i = 96, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  135.343271] ieee80211 phy1: I
iwl3945_rx_handle r = 98, i = 97, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  135.363528] ieee80211 phy1: I
iwl3945_rx_handle r = 99, i = 98, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  135.367627] ieee80211 phy1: I
iwl3945_rx_handle r = 100, i = 99, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  135.369496] ieee80211 phy1: I
iwl3945_rx_handle r = 101, i = 100, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  135.371298] ieee80211 phy1: I
iwl3945_rx_handle r = 102, i = 101, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  135.373112] ieee80211 phy1: I
iwl3945_rx_handle r = 103, i = 102, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  135.403724] ieee80211 phy1: I
iwl3945_rx_handle r = 104, i = 103, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  135.407713] ieee80211 phy1: I
iwl3945_rx_handle r = 105, i = 104, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  135.445710] ieee80211 phy1: I
iwl3945_rx_handle r = 106, i = 105, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  135.465900] ieee80211 phy1: I
iwl3945_rx_handle r = 107, i = 106, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  135.469984] ieee80211 phy1: I
iwl3945_rx_handle r = 108, i = 107, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  135.475535] ieee80211 phy1: I
iwl3945_rx_handle r = 109, i = 108, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  135.510665] ieee80211 phy1: I
iwl3945_rx_handle r = 110, i = 109, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  135.514875] ieee80211 phy1: I
iwl3945_rx_handle r = 111, i = 110, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  135.548061] ieee80211 phy1: I
iwl3945_rx_handle r = 112, i = 111, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  135.568304] ieee80211 phy1: I
iwl3945_rx_handle r = 113, i = 112, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  135.572394] ieee80211 phy1: I
iwl3945_rx_handle r = 114, i = 113, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  135.574255] ieee80211 phy1: I
iwl3945_rx_handle r = 115, i = 114, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  135.577898] ieee80211 phy1: I
iwl3945_rx_handle r = 116, i = 115, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  135.612537] ieee80211 phy1: I
iwl3945_rx_handle r = 117, i = 116, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  135.614388] ieee80211 phy1: I
iwl3945_rx_handle r = 118, i = 117, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  135.630760] ieee80211 phy1: I
iwl3945_rx_handle r = 119, i = 118, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  135.650461] ieee80211 phy1: I
iwl3945_rx_handle r = 120, i = 119, REPLY_3945_RX, 0x1b
Jan 26 22:24:08 rainbow kernel: [  135.670703] ieee80211 phy1: I
iwl3945_rx_handle r = 121, i = 120, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  135.676660] ieee80211 phy1: I
iwl3945_rx_handle r = 122, i = 121, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  135.680528] ieee80211 phy1: I
iwl3945_rx_handle r = 123, i = 122, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  135.714978] ieee80211 phy1: I
iwl3945_rx_handle r = 124, i = 123, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  135.716474] ieee80211 phy1: I
iwl3945_rx_handle r = 125, i = 124, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  135.719678] ieee80211 phy1: I
iwl3945_rx_handle r = 126, i = 125, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  135.733541] ieee80211 phy1: I
iwl3945_rx_handle r = 127, i = 126, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  135.752892] ieee80211 phy1: I
iwl3945_rx_handle r = 128, i = 127, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  135.773114] ieee80211 phy1: I
iwl3945_rx_handle r = 129, i = 128, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  135.777256] ieee80211 phy1: I
iwl3945_rx_handle r = 130, i = 129, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  135.782773] ieee80211 phy1: I
iwl3945_rx_handle r = 131, i = 130, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  135.817382] ieee80211 phy1: I
iwl3945_rx_handle r = 132, i = 131, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  135.818872] ieee80211 phy1: I
iwl3945_rx_handle r = 133, i = 132, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  135.835544] ieee80211 phy1: I
iwl3945_rx_handle r = 134, i = 133, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  135.855314] ieee80211 phy1: I
iwl3945_rx_handle r = 135, i = 134, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  135.875562] ieee80211 phy1: I
iwl3945_rx_handle r = 136, i = 135, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  135.879659] ieee80211 phy1: I
iwl3945_rx_handle r = 137, i = 136, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  135.885142] ieee80211 phy1: I
iwl3945_rx_handle r = 138, i = 137, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  135.919779] ieee80211 phy1: I
iwl3945_rx_handle r = 139, i = 138, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  135.937539] ieee80211 phy1: I
iwl3945_rx_handle r = 140, i = 139, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  135.957668] ieee80211 phy1: I
iwl3945_rx_handle r = 141, i = 140, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  135.977908] ieee80211 phy1: I
iwl3945_rx_handle r = 142, i = 141, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  135.983918] ieee80211 phy1: I
iwl3945_rx_handle r = 143, i = 142, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  135.985718] ieee80211 phy1: I
iwl3945_rx_handle r = 144, i = 143, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  135.987540] ieee80211 phy1: I
iwl3945_rx_handle r = 145, i = 144, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  136.018184] ieee80211 phy1: I
iwl3945_rx_handle r = 146, i = 145, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  136.022736] ieee80211 phy1: I
iwl3945_rx_handle r = 147, i = 146, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  136.040910] ieee80211 phy1: I
iwl3945_rx_handle r = 148, i = 147, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  136.060125] ieee80211 phy1: I
iwl3945_rx_handle r = 149, i = 148, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  136.080358] ieee80211 phy1: I
iwl3945_rx_handle r = 150, i = 149, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  136.084467] ieee80211 phy1: I
iwl3945_rx_handle r = 151, i = 150, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  136.086315] ieee80211 phy1: I
iwl3945_rx_handle r = 152, i = 151, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  136.088117] ieee80211 phy1: I
iwl3945_rx_handle r = 153, i = 152, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  136.089960] ieee80211 phy1: I
iwl3945_rx_handle r = 154, i = 153, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  136.125168] ieee80211 phy1: I
iwl3945_rx_handle r = 155, i = 154, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  136.127091] ieee80211 phy1: I
iwl3945_rx_handle r = 156, i = 155, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  136.144575] ieee80211 phy1: I
iwl3945_rx_handle r = 157, i = 156, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  136.162525] ieee80211 phy1: I
iwl3945_rx_handle r = 158, i = 157, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  136.182767] ieee80211 phy1: I
iwl3945_rx_handle r = 159, i = 158, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  136.186872] ieee80211 phy1: I
iwl3945_rx_handle r = 160, i = 159, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  136.188721] ieee80211 phy1: I
iwl3945_rx_handle r = 161, i = 160, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  136.190527] ieee80211 phy1: I
iwl3945_rx_handle r = 162, i = 161, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  136.227000] ieee80211 phy1: I
iwl3945_rx_handle r = 163, i = 162, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  136.228935] ieee80211 phy1: I
iwl3945_rx_handle r = 164, i = 163, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  136.244495] ieee80211 phy1: I
iwl3945_rx_handle r = 165, i = 164, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  136.264921] ieee80211 phy1: I
iwl3945_rx_handle r = 166, i = 165, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  136.286765] ieee80211 phy1: I
iwl3945_rx_handle r = 167, i = 166, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  136.295045] ieee80211 phy1: I
iwl3945_rx_handle r = 168, i = 167, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  136.329387] ieee80211 phy1: I
iwl3945_rx_handle r = 169, i = 168, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  136.331394] ieee80211 phy1: I
iwl3945_rx_handle r = 170, i = 169, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  136.346890] ieee80211 phy1: I
iwl3945_rx_handle r = 171, i = 170, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  136.367262] ieee80211 phy1: I
iwl3945_rx_handle r = 172, i = 171, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  136.395327] ieee80211 phy1: I
iwl3945_rx_handle r = 173, i = 172, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  136.397140] ieee80211 phy1: I
iwl3945_rx_handle r = 174, i = 173, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  136.431761] ieee80211 phy1: I
iwl3945_rx_handle r = 175, i = 174, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  136.433624] ieee80211 phy1: I
iwl3945_rx_handle r = 176, i = 175, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  136.449966] ieee80211 phy1: I
iwl3945_rx_handle r = 177, i = 176, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  136.469728] ieee80211 phy1: I
iwl3945_rx_handle r = 178, i = 177, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  136.491319] ieee80211 phy1: I
iwl3945_rx_handle r = 179, i = 178, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  136.495930] ieee80211 phy1: I
iwl3945_rx_handle r = 180, i = 179, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  136.497738] ieee80211 phy1: I
iwl3945_rx_handle r = 181, i = 180, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  136.499566] ieee80211 phy1: I
iwl3945_rx_handle r = 182, i = 181, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  136.530167] ieee80211 phy1: I
iwl3945_rx_handle r = 183, i = 182, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  136.534181] ieee80211 phy1: I
iwl3945_rx_handle r = 184, i = 183, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  136.536192] ieee80211 phy1: I
iwl3945_rx_handle r = 185, i = 184, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  136.552395] ieee80211 phy1: I
iwl3945_rx_handle r = 186, i = 185, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  136.572076] ieee80211 phy1: I
iwl3945_rx_handle r = 187, i = 186, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  136.592577] ieee80211 phy1: I
iwl3945_rx_handle r = 188, i = 187, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  136.601969] ieee80211 phy1: I
iwl3945_rx_handle r = 189, i = 188, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  136.632590] ieee80211 phy1: I
iwl3945_rx_handle r = 190, i = 189, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  136.636557] ieee80211 phy1: I
iwl3945_rx_handle r = 191, i = 190, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  136.638446] ieee80211 phy1: I
iwl3945_rx_handle r = 192, i = 191, REPLY_3945_RX, 0x1b
Jan 26 22:24:09 rainbow kernel: [  136.654767] ieee80211 phy1: I
iwl3945_rx_handle r = 193, i = 192, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  136.674472] ieee80211 phy1: I
iwl3945_rx_handle r = 194, i = 193, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  136.694759] ieee80211 phy1: I
iwl3945_rx_handle r = 195, i = 194, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  136.698858] ieee80211 phy1: I
iwl3945_rx_handle r = 196, i = 195, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  136.700702] ieee80211 phy1: I
iwl3945_rx_handle r = 197, i = 196, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  136.704323] ieee80211 phy1: I
iwl3945_rx_handle r = 198, i = 197, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  136.739515] ieee80211 phy1: I
iwl3945_rx_handle r = 199, i = 198, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  136.741459] ieee80211 phy1: I
iwl3945_rx_handle r = 200, i = 199, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  136.756589] ieee80211 phy1: I
iwl3945_rx_handle r = 201, i = 200, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  136.776884] ieee80211 phy1: I
iwl3945_rx_handle r = 202, i = 201, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  136.797128] ieee80211 phy1: I
iwl3945_rx_handle r = 203, i = 202, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  136.801219] ieee80211 phy1: I
iwl3945_rx_handle r = 204, i = 203, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  136.803063] ieee80211 phy1: I
iwl3945_rx_handle r = 205, i = 204, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  136.804900] ieee80211 phy1: I
iwl3945_rx_handle r = 206, i = 205, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  136.806710] ieee80211 phy1: I
iwl3945_rx_handle r = 207, i = 206, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  136.841500] ieee80211 phy1: I
iwl3945_rx_handle r = 208, i = 207, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  136.843027] ieee80211 phy1: I
iwl3945_rx_handle r = 209, i = 208, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  136.846056] ieee80211 phy1: I
iwl3945_rx_handle r = 210, i = 209, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  136.859615] ieee80211 phy1: I
iwl3945_rx_handle r = 211, i = 210, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  136.879311] ieee80211 phy1: I
iwl3945_rx_handle r = 212, i = 211, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  136.899507] ieee80211 phy1: I
iwl3945_rx_handle r = 213, i = 212, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  136.903660] ieee80211 phy1: I
iwl3945_rx_handle r = 214, i = 213, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  136.905476] ieee80211 phy1: I
iwl3945_rx_handle r = 215, i = 214, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  136.909114] ieee80211 phy1: I
iwl3945_rx_handle r = 216, i = 215, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  136.943913] ieee80211 phy1: I
iwl3945_rx_handle r = 217, i = 216, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  136.945845] ieee80211 phy1: I
iwl3945_rx_handle r = 218, i = 217, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  136.962020] ieee80211 phy1: I
iwl3945_rx_handle r = 219, i = 218, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  136.981731] ieee80211 phy1: I
iwl3945_rx_handle r = 220, i = 219, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  137.001973] ieee80211 phy1: I
iwl3945_rx_handle r = 221, i = 220, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  137.006071] ieee80211 phy1: I
iwl3945_rx_handle r = 222, i = 221, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  137.007923] ieee80211 phy1: I
iwl3945_rx_handle r = 223, i = 222, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  137.009743] ieee80211 phy1: I
iwl3945_rx_handle r = 224, i = 223, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  137.011578] ieee80211 phy1: I
iwl3945_rx_handle r = 225, i = 224, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  137.046203] ieee80211 phy1: I
iwl3945_rx_handle r = 226, i = 225, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  137.064441] ieee80211 phy1: I
iwl3945_rx_handle r = 227, i = 226, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  137.084111] ieee80211 phy1: I
iwl3945_rx_handle r = 228, i = 227, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  137.104445] ieee80211 phy1: I
iwl3945_rx_handle r = 229, i = 228, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  137.110340] ieee80211 phy1: I
iwl3945_rx_handle r = 230, i = 229, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  137.112155] ieee80211 phy1: I
iwl3945_rx_handle r = 231, i = 230, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  137.114272] ieee80211 phy1: I
iwl3945_rx_handle r = 232, i = 231, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  137.144561] ieee80211 phy1: I
iwl3945_rx_handle r = 233, i = 232, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  137.149192] ieee80211 phy1: I
iwl3945_rx_handle r = 234, i = 233, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  137.151055] ieee80211 phy1: I
iwl3945_rx_handle r = 235, i = 234, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  137.166778] ieee80211 phy1: I
iwl3945_rx_handle r = 236, i = 235, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  137.186540] ieee80211 phy1: I
iwl3945_rx_handle r = 237, i = 236, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  137.206719] ieee80211 phy1: I
iwl3945_rx_handle r = 238, i = 237, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  137.211226] ieee80211 phy1: I
iwl3945_rx_handle r = 239, i = 238, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  137.212736] ieee80211 phy1: I
iwl3945_rx_handle r = 240, i = 239, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  137.214778] ieee80211 phy1: I
iwl3945_rx_handle r = 241, i = 240, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  137.216321] ieee80211 phy1: I
iwl3945_rx_handle r = 242, i = 241, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  137.247062] ieee80211 phy1: I
iwl3945_rx_handle r = 243, i = 242, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  137.251560] ieee80211 phy1: I
iwl3945_rx_handle r = 244, i = 243, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  137.253460] ieee80211 phy1: I
iwl3945_rx_handle r = 245, i = 244, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  137.269242] ieee80211 phy1: I
iwl3945_rx_handle r = 246, i = 245, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  137.288938] ieee80211 phy1: I
iwl3945_rx_handle r = 247, i = 246, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  137.309378] ieee80211 phy1: I
iwl3945_rx_handle r = 248, i = 247, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  137.318766] ieee80211 phy1: I
iwl3945_rx_handle r = 249, i = 248, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  137.354095] ieee80211 phy1: I
iwl3945_rx_handle r = 250, i = 249, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  137.355576] ieee80211 phy1: I
iwl3945_rx_handle r = 251, i = 250, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  137.370999] ieee80211 phy1: I
iwl3945_rx_handle r = 252, i = 251, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  137.391290] ieee80211 phy1: I
iwl3945_rx_handle r = 253, i = 252, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  137.411529] ieee80211 phy1: I
iwl3945_rx_handle r = 254, i = 253, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  137.415843] ieee80211 phy1: I
iwl3945_rx_handle r = 255, i = 254, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  137.421172] ieee80211 phy1: I
iwl3945_rx_handle r = 0, i = 255, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  137.451829] ieee80211 phy1: I
iwl3945_rx_handle r = 1, i = 0, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  137.456355] ieee80211 phy1: I
iwl3945_rx_handle r = 2, i = 1, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  137.457846] ieee80211 phy1: I
iwl3945_rx_handle r = 3, i = 2, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  137.493736] ieee80211 phy1: I
iwl3945_rx_handle r = 4, i = 3, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  137.518120] ieee80211 phy1: I
iwl3945_rx_handle r = 5, i = 4, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  137.519945] ieee80211 phy1: I
iwl3945_rx_handle r = 6, i = 5, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  137.523299] ieee80211 phy1: I
iwl3945_rx_handle r = 7, i = 6, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  137.558239] ieee80211 phy1: I
iwl3945_rx_handle r = 8, i = 7, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  137.560163] ieee80211 phy1: I
iwl3945_rx_handle r = 9, i = 8, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  137.576978] ieee80211 phy1: I
iwl3945_rx_handle r = 10, i = 9, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  137.596150] ieee80211 phy1: I
iwl3945_rx_handle r = 11, i = 10, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  137.616378] ieee80211 phy1: I
iwl3945_rx_handle r = 12, i = 11, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  137.620463] ieee80211 phy1: I
iwl3945_rx_handle r = 13, i = 12, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  137.625991] ieee80211 phy1: I
iwl3945_rx_handle r = 14, i = 13, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  137.646818] ieee80211 phy1: I
iwl3945_rx_handle r = 15, i = 14, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  137.656634] ieee80211 phy1: I
iwl3945_rx_handle r = 16, i = 15, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  137.660644] ieee80211 phy1: I
iwl3945_rx_handle r = 17, i = 16, REPLY_3945_RX, 0x1b
Jan 26 22:24:10 rainbow kernel: [  137.662134] ieee80211 phy1: I
iwl3945_rx_handle r = 18, i = 17, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  137.698541] ieee80211 phy1: I
iwl3945_rx_handle r = 19, i = 18, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  137.718786] ieee80211 phy1: I
iwl3945_rx_handle r = 20, i = 19, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  137.724757] ieee80211 phy1: I
iwl3945_rx_handle r = 21, i = 20, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  137.726575] ieee80211 phy1: I
iwl3945_rx_handle r = 22, i = 21, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  137.728367] ieee80211 phy1: I
iwl3945_rx_handle r = 23, i = 22, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  137.749211] ieee80211 phy1: I
iwl3945_rx_handle r = 24, i = 23, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  137.759030] ieee80211 phy1: I
iwl3945_rx_handle r = 25, i = 24, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  137.763190] ieee80211 phy1: I
iwl3945_rx_handle r = 26, i = 25, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  137.764681] ieee80211 phy1: I
iwl3945_rx_handle r = 27, i = 26, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  137.767757] ieee80211 phy1: I
iwl3945_rx_handle r = 28, i = 27, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  137.800942] ieee80211 phy1: I
iwl3945_rx_handle r = 29, i = 28, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  137.822710] ieee80211 phy1: I
iwl3945_rx_handle r = 30, i = 29, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  137.825321] ieee80211 phy1: I
iwl3945_rx_handle r = 31, i = 30, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  137.827527] ieee80211 phy1: I
iwl3945_rx_handle r = 32, i = 31, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  137.830801] ieee80211 phy1: I
iwl3945_rx_handle r = 33, i = 32, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  137.861428] ieee80211 phy1: I
iwl3945_rx_handle r = 34, i = 33, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  137.866083] ieee80211 phy1: I
iwl3945_rx_handle r = 35, i = 34, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  137.867572] ieee80211 phy1: I
iwl3945_rx_handle r = 36, i = 35, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  137.883654] ieee80211 phy1: I
iwl3945_rx_handle r = 37, i = 36, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  137.903347] ieee80211 phy1: I
iwl3945_rx_handle r = 38, i = 37, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  137.923586] ieee80211 phy1: I
iwl3945_rx_handle r = 39, i = 38, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  137.933203] ieee80211 phy1: I
iwl3945_rx_handle r = 40, i = 39, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  137.963837] ieee80211 phy1: I
iwl3945_rx_handle r = 41, i = 40, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  137.967854] ieee80211 phy1: I
iwl3945_rx_handle r = 42, i = 41, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  137.970130] ieee80211 phy1: I
iwl3945_rx_handle r = 43, i = 42, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  137.985394] ieee80211 phy1: I
iwl3945_rx_handle r = 44, i = 43, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  138.005754] ieee80211 phy1: I
iwl3945_rx_handle r = 45, i = 44, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  138.025989] ieee80211 phy1: I
iwl3945_rx_handle r = 46, i = 45, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  138.030154] ieee80211 phy1: I
iwl3945_rx_handle r = 47, i = 46, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  138.037096] ieee80211 phy1: I
iwl3945_rx_handle r = 48, i = 47, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  138.039126] ieee80211 phy1: I
iwl3945_rx_handle r = 49, i = 48, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  138.066239] ieee80211 phy1: I
iwl3945_rx_handle r = 50, i = 49, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  138.070361] ieee80211 phy1: I
iwl3945_rx_handle r = 51, i = 50, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  138.071847] ieee80211 phy1: I
iwl3945_rx_handle r = 52, i = 51, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  138.089179] ieee80211 phy1: I
iwl3945_rx_handle r = 53, i = 52, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  138.108156] ieee80211 phy1: I
iwl3945_rx_handle r = 54, i = 53, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  138.128399] ieee80211 phy1: I
iwl3945_rx_handle r = 55, i = 54, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  138.138132] ieee80211 phy1: I
iwl3945_rx_handle r = 56, i = 55, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  138.172667] ieee80211 phy1: I
iwl3945_rx_handle r = 57, i = 56, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  138.190861] ieee80211 phy1: I
iwl3945_rx_handle r = 58, i = 57, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  138.210561] ieee80211 phy1: I
iwl3945_rx_handle r = 59, i = 58, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  138.230790] ieee80211 phy1: I
iwl3945_rx_handle r = 60, i = 59, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  138.234931] ieee80211 phy1: I
iwl3945_rx_handle r = 61, i = 60, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  138.236731] ieee80211 phy1: I
iwl3945_rx_handle r = 62, i = 61, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  138.241064] ieee80211 phy1: I
iwl3945_rx_handle r = 63, i = 62, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  138.275516] ieee80211 phy1: I
iwl3945_rx_handle r = 64, i = 63, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  138.277439] ieee80211 phy1: I
iwl3945_rx_handle r = 65, i = 64, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  138.293263] ieee80211 phy1: I
iwl3945_rx_handle r = 66, i = 65, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  138.312955] ieee80211 phy1: I
iwl3945_rx_handle r = 67, i = 66, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  138.333344] ieee80211 phy1: I
iwl3945_rx_handle r = 68, i = 67, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  138.337312] ieee80211 phy1: I
iwl3945_rx_handle r = 69, i = 68, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  138.339133] ieee80211 phy1: I
iwl3945_rx_handle r = 70, i = 69, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  138.340988] ieee80211 phy1: I
iwl3945_rx_handle r = 71, i = 70, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  138.342795] ieee80211 phy1: I
iwl3945_rx_handle r = 72, i = 71, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  138.379795] ieee80211 phy1: I
iwl3945_rx_handle r = 73, i = 72, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  138.402131] ieee80211 phy1: I
iwl3945_rx_handle r = 74, i = 73, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  138.415362] ieee80211 phy1: I
iwl3945_rx_handle r = 75, i = 74, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  138.439258] ieee80211 phy1: I
iwl3945_rx_handle r = 76, i = 75, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  138.443848] ieee80211 phy1: I
iwl3945_rx_handle r = 77, i = 76, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  138.456407] ieee80211 phy1: I
iwl3945_rx_handle r = 78, i = 77, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  138.470686] ieee80211 phy1: I
iwl3945_rx_handle r = 79, i = 78, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  138.488165] ieee80211 phy1: I
iwl3945_rx_handle r = 80, i = 79, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  138.500607] ieee80211 phy1: I
iwl3945_rx_handle r = 81, i = 80, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  138.517754] ieee80211 phy1: I
iwl3945_rx_handle r = 82, i = 81, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  138.538002] ieee80211 phy1: I
iwl3945_rx_handle r = 83, i = 82, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  138.543962] ieee80211 phy1: I
iwl3945_rx_handle r = 84, i = 83, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  138.547617] ieee80211 phy1: I
iwl3945_rx_handle r = 85, i = 84, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  138.568440] ieee80211 phy1: I
iwl3945_rx_handle r = 86, i = 85, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  138.582885] ieee80211 phy1: I
iwl3945_rx_handle r = 87, i = 86, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  138.584345] ieee80211 phy1: I
iwl3945_rx_handle r = 88, i = 87, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  138.600470] ieee80211 phy1: I
iwl3945_rx_handle r = 89, i = 88, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  138.620163] ieee80211 phy1: I
iwl3945_rx_handle r = 90, i = 89, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  138.641322] ieee80211 phy1: I
iwl3945_rx_handle r = 91, i = 90, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  138.646363] ieee80211 phy1: I
iwl3945_rx_handle r = 92, i = 91, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  138.650431] ieee80211 phy1: I
iwl3945_rx_handle r = 93, i = 92, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  138.655127] ieee80211 phy1: I
iwl3945_rx_handle r = 94, i = 93, REPLY_3945_RX, 0x1b
Jan 26 22:24:11 rainbow kernel: [  138.670851] ieee80211 phy1: I
iwl3945_rx_handle r = 95, i = 94, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  138.680742] ieee80211 phy1: I
iwl3945_rx_handle r = 96, i = 95, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  138.685134] ieee80211 phy1: I
iwl3945_rx_handle r = 97, i = 96, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  138.687590] ieee80211 phy1: I
iwl3945_rx_handle r = 98, i = 97, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  138.722566] ieee80211 phy1: I
iwl3945_rx_handle r = 99, i = 98, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  138.742798] ieee80211 phy1: I
iwl3945_rx_handle r = 100, i = 99, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  138.747249] ieee80211 phy1: I
iwl3945_rx_handle r = 101, i = 100, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  138.752832] ieee80211 phy1: I
iwl3945_rx_handle r = 102, i = 101, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  138.783051] ieee80211 phy1: I
iwl3945_rx_handle r = 103, i = 102, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  138.787640] ieee80211 phy1: I
iwl3945_rx_handle r = 104, i = 103, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  138.805271] ieee80211 phy1: I
iwl3945_rx_handle r = 105, i = 104, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  138.824961] ieee80211 phy1: I
iwl3945_rx_handle r = 106, i = 105, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  138.845208] ieee80211 phy1: I
iwl3945_rx_handle r = 107, i = 106, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  138.849348] ieee80211 phy1: I
iwl3945_rx_handle r = 108, i = 107, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  138.852941] ieee80211 phy1: I
iwl3945_rx_handle r = 109, i = 108, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  138.854819] ieee80211 phy1: I
iwl3945_rx_handle r = 110, i = 109, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  138.885459] ieee80211 phy1: I
iwl3945_rx_handle r = 111, i = 110, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  138.890031] ieee80211 phy1: I
iwl3945_rx_handle r = 112, i = 111, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  138.907676] ieee80211 phy1: I
iwl3945_rx_handle r = 113, i = 112, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  138.927356] ieee80211 phy1: I
iwl3945_rx_handle r = 114, i = 113, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  138.947603] ieee80211 phy1: I
iwl3945_rx_handle r = 115, i = 114, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  138.951760] ieee80211 phy1: I
iwl3945_rx_handle r = 116, i = 115, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  138.957220] ieee80211 phy1: I
iwl3945_rx_handle r = 117, i = 116, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  138.992535] ieee80211 phy1: I
iwl3945_rx_handle r = 118, i = 117, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  138.994026] ieee80211 phy1: I
iwl3945_rx_handle r = 119, i = 118, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  139.010031] ieee80211 phy1: I
iwl3945_rx_handle r = 120, i = 119, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  139.029763] ieee80211 phy1: I
iwl3945_rx_handle r = 121, i = 120, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  139.050001] ieee80211 phy1: I
iwl3945_rx_handle r = 122, i = 121, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  139.059617] ieee80211 phy1: I
iwl3945_rx_handle r = 123, i = 122, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  139.094288] ieee80211 phy1: I
iwl3945_rx_handle r = 124, i = 123, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  139.095795] ieee80211 phy1: I
iwl3945_rx_handle r = 125, i = 124, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  139.099014] ieee80211 phy1: I
iwl3945_rx_handle r = 126, i = 125, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  139.112481] ieee80211 phy1: I
iwl3945_rx_handle r = 127, i = 126, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  139.132163] ieee80211 phy1: I
iwl3945_rx_handle r = 128, i = 127, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  139.154267] ieee80211 phy1: I
iwl3945_rx_handle r = 129, i = 128, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  139.162018] ieee80211 phy1: I
iwl3945_rx_handle r = 130, i = 129, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  139.196693] ieee80211 phy1: I
iwl3945_rx_handle r = 131, i = 130, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  139.198640] ieee80211 phy1: I
iwl3945_rx_handle r = 132, i = 131, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  139.215211] ieee80211 phy1: I
iwl3945_rx_handle r = 133, i = 132, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  139.234564] ieee80211 phy1: I
iwl3945_rx_handle r = 134, i = 133, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  139.254833] ieee80211 phy1: I
iwl3945_rx_handle r = 135, i = 134, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  139.260782] ieee80211 phy1: I
iwl3945_rx_handle r = 136, i = 135, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  139.264394] ieee80211 phy1: I
iwl3945_rx_handle r = 137, i = 136, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  139.295014] ieee80211 phy1: I
iwl3945_rx_handle r = 138, i = 137, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  139.299666] ieee80211 phy1: I
iwl3945_rx_handle r = 139, i = 138, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  139.301090] ieee80211 phy1: I
iwl3945_rx_handle r = 140, i = 139, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  139.316824] ieee80211 phy1: I
iwl3945_rx_handle r = 141, i = 140, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  139.336973] ieee80211 phy1: I
iwl3945_rx_handle r = 142, i = 141, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  139.363230] ieee80211 phy1: I
iwl3945_rx_handle r = 143, i = 142, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  139.366827] ieee80211 phy1: I
iwl3945_rx_handle r = 144, i = 143, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  139.401505] ieee80211 phy1: I
iwl3945_rx_handle r = 145, i = 144, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  139.403419] ieee80211 phy1: I
iwl3945_rx_handle r = 146, i = 145, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  139.420116] ieee80211 phy1: I
iwl3945_rx_handle r = 147, i = 146, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  139.439365] ieee80211 phy1: I
iwl3945_rx_handle r = 148, i = 147, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  139.459812] ieee80211 phy1: I
iwl3945_rx_handle r = 149, i = 148, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  139.463771] ieee80211 phy1: I
iwl3945_rx_handle r = 150, i = 149, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  139.465585] ieee80211 phy1: I
iwl3945_rx_handle r = 151, i = 150, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  139.467426] ieee80211 phy1: I
iwl3945_rx_handle r = 152, i = 151, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  139.469199] ieee80211 phy1: I
iwl3945_rx_handle r = 153, i = 152, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  139.490075] ieee80211 phy1: I
iwl3945_rx_handle r = 154, i = 153, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  139.499866] ieee80211 phy1: I
iwl3945_rx_handle r = 155, i = 154, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  139.504429] ieee80211 phy1: I
iwl3945_rx_handle r = 156, i = 155, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  139.505924] ieee80211 phy1: I
iwl3945_rx_handle r = 157, i = 156, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  139.521416] ieee80211 phy1: I
iwl3945_rx_handle r = 158, i = 157, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  139.541779] ieee80211 phy1: I
iwl3945_rx_handle r = 159, i = 158, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  139.562006] ieee80211 phy1: I
iwl3945_rx_handle r = 160, i = 159, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  139.566181] ieee80211 phy1: I
iwl3945_rx_handle r = 161, i = 160, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  139.571629] ieee80211 phy1: I
iwl3945_rx_handle r = 162, i = 161, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  139.592483] ieee80211 phy1: I
iwl3945_rx_handle r = 163, i = 162, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  139.606305] ieee80211 phy1: I
iwl3945_rx_handle r = 164, i = 163, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  139.608180] ieee80211 phy1: I
iwl3945_rx_handle r = 165, i = 164, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  139.644167] ieee80211 phy1: I
iwl3945_rx_handle r = 166, i = 165, REPLY_3945_RX, 0x1b
Jan 26 22:24:12 rainbow kernel: [  139.664502] ieee80211 phy1: I
iwl3945_rx_handle r = 167, i = 166, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  139.674026] ieee80211 phy1: I
iwl3945_rx_handle r = 168, i = 167, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  139.708716] ieee80211 phy1: I
iwl3945_rx_handle r = 169, i = 168, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  139.710649] ieee80211 phy1: I
iwl3945_rx_handle r = 170, i = 169, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  139.713312] ieee80211 phy1: I
iwl3945_rx_handle r = 171, i = 170, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  139.726898] ieee80211 phy1: I
iwl3945_rx_handle r = 172, i = 171, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  139.746570] ieee80211 phy1: I
iwl3945_rx_handle r = 173, i = 172, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  139.766819] ieee80211 phy1: I
iwl3945_rx_handle r = 174, i = 173, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  139.772795] ieee80211 phy1: I
iwl3945_rx_handle r = 175, i = 174, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  139.776400] ieee80211 phy1: I
iwl3945_rx_handle r = 176, i = 175, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  139.811118] ieee80211 phy1: I
iwl3945_rx_handle r = 177, i = 176, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  139.813048] ieee80211 phy1: I
iwl3945_rx_handle r = 178, i = 177, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  139.829338] ieee80211 phy1: I
iwl3945_rx_handle r = 179, i = 178, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  139.848977] ieee80211 phy1: I
iwl3945_rx_handle r = 180, i = 179, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  139.873389] ieee80211 phy1: I
iwl3945_rx_handle r = 181, i = 180, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  139.875187] ieee80211 phy1: I
iwl3945_rx_handle r = 182, i = 181, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  139.877009] ieee80211 phy1: I
iwl3945_rx_handle r = 183, i = 182, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  139.878714] ieee80211 phy1: I
iwl3945_rx_handle r = 184, i = 183, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  139.913523] ieee80211 phy1: I
iwl3945_rx_handle r = 185, i = 184, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  139.915002] ieee80211 phy1: I
iwl3945_rx_handle r = 186, i = 185, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  139.931038] ieee80211 phy1: I
iwl3945_rx_handle r = 187, i = 186, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  139.951375] ieee80211 phy1: I
iwl3945_rx_handle r = 188, i = 187, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  139.972317] ieee80211 phy1: I
iwl3945_rx_handle r = 189, i = 188, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  139.979445] ieee80211 phy1: I
iwl3945_rx_handle r = 190, i = 189, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  139.981177] ieee80211 phy1: I
iwl3945_rx_handle r = 191, i = 190, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  140.002091] ieee80211 phy1: I
iwl3945_rx_handle r = 192, i = 191, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  140.015921] ieee80211 phy1: I
iwl3945_rx_handle r = 193, i = 192, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  140.017875] ieee80211 phy1: I
iwl3945_rx_handle r = 194, i = 193, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  140.053774] ieee80211 phy1: I
iwl3945_rx_handle r = 195, i = 194, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  140.074020] ieee80211 phy1: I
iwl3945_rx_handle r = 196, i = 195, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  140.078201] ieee80211 phy1: I
iwl3945_rx_handle r = 197, i = 196, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  140.079992] ieee80211 phy1: I
iwl3945_rx_handle r = 198, i = 197, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  140.081783] ieee80211 phy1: I
iwl3945_rx_handle r = 199, i = 198, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  140.083633] ieee80211 phy1: I
iwl3945_rx_handle r = 200, i = 199, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  140.104506] ieee80211 phy1: I
iwl3945_rx_handle r = 201, i = 200, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  140.118320] ieee80211 phy1: I
iwl3945_rx_handle r = 202, i = 201, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  140.119820] ieee80211 phy1: I
iwl3945_rx_handle r = 203, i = 202, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  140.136331] ieee80211 phy1: I
iwl3945_rx_handle r = 204, i = 203, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  140.156180] ieee80211 phy1: I
iwl3945_rx_handle r = 205, i = 204, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  140.176429] ieee80211 phy1: I
iwl3945_rx_handle r = 206, i = 205, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  140.180572] ieee80211 phy1: I
iwl3945_rx_handle r = 207, i = 206, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  140.185979] ieee80211 phy1: I
iwl3945_rx_handle r = 208, i = 207, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  140.206900] ieee80211 phy1: I
iwl3945_rx_handle r = 209, i = 208, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  140.216676] ieee80211 phy1: I
iwl3945_rx_handle r = 210, i = 209, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  140.221292] ieee80211 phy1: I
iwl3945_rx_handle r = 211, i = 210, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  140.222760] ieee80211 phy1: I
iwl3945_rx_handle r = 212, i = 211, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  140.258580] ieee80211 phy1: I
iwl3945_rx_handle r = 213, i = 212, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  140.279874] ieee80211 phy1: I
iwl3945_rx_handle r = 214, i = 213, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  140.282979] ieee80211 phy1: I
iwl3945_rx_handle r = 215, i = 214, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  140.284772] ieee80211 phy1: I
iwl3945_rx_handle r = 216, i = 215, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  140.288444] ieee80211 phy1: I
iwl3945_rx_handle r = 217, i = 216, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  140.319055] ieee80211 phy1: I
iwl3945_rx_handle r = 218, i = 217, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  140.323707] ieee80211 phy1: I
iwl3945_rx_handle r = 219, i = 218, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  140.325192] ieee80211 phy1: I
iwl3945_rx_handle r = 220, i = 219, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  140.360985] ieee80211 phy1: I
iwl3945_rx_handle r = 221, i = 220, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  140.381227] ieee80211 phy1: I
iwl3945_rx_handle r = 222, i = 221, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  140.385406] ieee80211 phy1: I
iwl3945_rx_handle r = 223, i = 222, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  140.387202] ieee80211 phy1: I
iwl3945_rx_handle r = 224, i = 223, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  140.390854] ieee80211 phy1: I
iwl3945_rx_handle r = 225, i = 224, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  140.426122] ieee80211 phy1: I
iwl3945_rx_handle r = 226, i = 225, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  140.430257] ieee80211 phy1: I
iwl3945_rx_handle r = 227, i = 226, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  140.443712] ieee80211 phy1: I
iwl3945_rx_handle r = 228, i = 227, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  140.463387] ieee80211 phy1: I
iwl3945_rx_handle r = 229, i = 228, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  140.483630] ieee80211 phy1: I
iwl3945_rx_handle r = 230, i = 229, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  140.487812] ieee80211 phy1: I
iwl3945_rx_handle r = 231, i = 230, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  140.491450] ieee80211 phy1: I
iwl3945_rx_handle r = 232, i = 231, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  140.493220] ieee80211 phy1: I
iwl3945_rx_handle r = 233, i = 232, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  140.523858] ieee80211 phy1: I
iwl3945_rx_handle r = 234, i = 233, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  140.527912] ieee80211 phy1: I
iwl3945_rx_handle r = 235, i = 234, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  140.532591] ieee80211 phy1: I
iwl3945_rx_handle r = 236, i = 235, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  140.534443] ieee80211 phy1: I
iwl3945_rx_handle r = 237, i = 236, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  140.546058] ieee80211 phy1: I
iwl3945_rx_handle r = 238, i = 237, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  140.565784] ieee80211 phy1: I
iwl3945_rx_handle r = 239, i = 238, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  140.586028] ieee80211 phy1: I
iwl3945_rx_handle r = 240, i = 239, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  140.648081] ieee80211 phy1: I
iwl3945_rx_handle r = 241, i = 240, REPLY_3945_RX, 0x1b
Jan 26 22:24:13 rainbow kernel: [  140.668195] ieee80211 phy1: I
iwl3945_rx_handle r = 242, i = 241, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  140.689064] ieee80211 phy1: I
iwl3945_rx_handle r = 243, i = 242, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  140.694406] ieee80211 phy1: I
iwl3945_rx_handle r = 244, i = 243, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  140.698054] ieee80211 phy1: I
iwl3945_rx_handle r = 245, i = 244, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  140.718921] ieee80211 phy1: I
iwl3945_rx_handle r = 246, i = 245, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  140.732688] ieee80211 phy1: I
iwl3945_rx_handle r = 247, i = 246, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  140.734696] ieee80211 phy1: I
iwl3945_rx_handle r = 248, i = 247, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  140.750254] ieee80211 phy1: I
iwl3945_rx_handle r = 249, i = 248, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  140.770591] ieee80211 phy1: I
iwl3945_rx_handle r = 250, i = 249, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  140.790886] ieee80211 phy1: I
iwl3945_rx_handle r = 251, i = 250, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  140.796810] ieee80211 phy1: I
iwl3945_rx_handle r = 252, i = 251, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  140.799431] ieee80211 phy1: I
iwl3945_rx_handle r = 253, i = 252, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  140.800424] ieee80211 phy1: I
iwl3945_rx_handle r = 254, i = 253, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  140.831095] ieee80211 phy1: I
iwl3945_rx_handle r = 255, i = 254, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  140.835138] ieee80211 phy1: I
iwl3945_rx_handle r = 0, i = 255, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  140.837097] ieee80211 phy1: I
iwl3945_rx_handle r = 1, i = 0, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  140.853320] ieee80211 phy1: I
iwl3945_rx_handle r = 2, i = 1, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  140.872992] ieee80211 phy1: I
iwl3945_rx_handle r = 3, i = 2, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  140.893227] ieee80211 phy1: I
iwl3945_rx_handle r = 4, i = 3, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  140.902853] ieee80211 phy1: I
iwl3945_rx_handle r = 5, i = 4, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  140.923719] ieee80211 phy1: I
iwl3945_rx_handle r = 6, i = 5, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  140.938202] ieee80211 phy1: I
iwl3945_rx_handle r = 7, i = 6, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  140.939688] ieee80211 phy1: I
iwl3945_rx_handle r = 8, i = 7, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  140.975339] ieee80211 phy1: I
iwl3945_rx_handle r = 9, i = 8, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  140.995584] ieee80211 phy1: I
iwl3945_rx_handle r = 10, i = 9, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  140.999800] ieee80211 phy1: I
iwl3945_rx_handle r = 11, i = 10, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  141.001555] ieee80211 phy1: I
iwl3945_rx_handle r = 12, i = 11, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  141.005234] ieee80211 phy1: I
iwl3945_rx_handle r = 13, i = 12, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  141.035840] ieee80211 phy1: I
iwl3945_rx_handle r = 14, i = 13, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  141.039898] ieee80211 phy1: I
iwl3945_rx_handle r = 15, i = 14, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  141.044595] ieee80211 phy1: I
iwl3945_rx_handle r = 16, i = 15, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  141.077804] ieee80211 phy1: I
iwl3945_rx_handle r = 17, i = 16, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  141.098033] ieee80211 phy1: I
iwl3945_rx_handle r = 18, i = 17, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  141.104016] ieee80211 phy1: I
iwl3945_rx_handle r = 19, i = 18, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  141.107646] ieee80211 phy1: I
iwl3945_rx_handle r = 20, i = 19, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  141.138299] ieee80211 phy1: I
iwl3945_rx_handle r = 21, i = 20, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  141.142353] ieee80211 phy1: I
iwl3945_rx_handle r = 22, i = 21, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  141.144170] ieee80211 phy1: I
iwl3945_rx_handle r = 23, i = 22, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  141.160769] ieee80211 phy1: I
iwl3945_rx_handle r = 24, i = 23, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  141.180200] ieee80211 phy1: I
iwl3945_rx_handle r = 25, i = 24, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  141.200440] ieee80211 phy1: I
iwl3945_rx_handle r = 26, i = 25, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  141.204627] ieee80211 phy1: I
iwl3945_rx_handle r = 27, i = 26, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  141.206412] ieee80211 phy1: I
iwl3945_rx_handle r = 28, i = 27, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  141.210059] ieee80211 phy1: I
iwl3945_rx_handle r = 29, i = 28, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  141.245349] ieee80211 phy1: I
iwl3945_rx_handle r = 30, i = 29, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  141.246842] ieee80211 phy1: I
iwl3945_rx_handle r = 31, i = 30, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  141.282601] ieee80211 phy1: I
iwl3945_rx_handle r = 32, i = 31, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  141.302846] ieee80211 phy1: I
iwl3945_rx_handle r = 33, i = 32, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  141.307031] ieee80211 phy1: I
iwl3945_rx_handle r = 34, i = 33, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  141.308824] ieee80211 phy1: I
iwl3945_rx_handle r = 35, i = 34, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  141.312431] ieee80211 phy1: I
iwl3945_rx_handle r = 36, i = 35, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  141.343106] ieee80211 phy1: I
iwl3945_rx_handle r = 37, i = 36, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  141.347783] ieee80211 phy1: I
iwl3945_rx_handle r = 38, i = 37, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  141.349287] ieee80211 phy1: I
iwl3945_rx_handle r = 39, i = 38, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  141.365689] ieee80211 phy1: I
iwl3945_rx_handle r = 40, i = 39, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  141.385005] ieee80211 phy1: I
iwl3945_rx_handle r = 41, i = 40, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  141.408219] ieee80211 phy1: I
iwl3945_rx_handle r = 42, i = 41, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  141.411219] ieee80211 phy1: I
iwl3945_rx_handle r = 43, i = 42, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  141.413089] ieee80211 phy1: I
iwl3945_rx_handle r = 44, i = 43, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  141.414864] ieee80211 phy1: I
iwl3945_rx_handle r = 45, i = 44, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  141.445495] ieee80211 phy1: I
iwl3945_rx_handle r = 46, i = 45, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  141.450118] ieee80211 phy1: I
iwl3945_rx_handle r = 47, i = 46, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  141.452110] ieee80211 phy1: I
iwl3945_rx_handle r = 48, i = 47, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  141.467737] ieee80211 phy1: I
iwl3945_rx_handle r = 49, i = 48, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  141.487394] ieee80211 phy1: I
iwl3945_rx_handle r = 50, i = 49, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  141.508260] ieee80211 phy1: I
iwl3945_rx_handle r = 51, i = 50, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  141.511841] ieee80211 phy1: I
iwl3945_rx_handle r = 52, i = 51, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  141.513622] ieee80211 phy1: I
iwl3945_rx_handle r = 53, i = 52, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  141.515483] ieee80211 phy1: I
iwl3945_rx_handle r = 54, i = 53, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  141.517264] ieee80211 phy1: I
iwl3945_rx_handle r = 55, i = 54, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  141.552584] ieee80211 phy1: I
iwl3945_rx_handle r = 56, i = 55, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  141.554071] ieee80211 phy1: I
iwl3945_rx_handle r = 57, i = 56, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  141.589794] ieee80211 phy1: I
iwl3945_rx_handle r = 58, i = 57, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  141.610046] ieee80211 phy1: I
iwl3945_rx_handle r = 59, i = 58, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  141.619641] ieee80211 phy1: I
iwl3945_rx_handle r = 60, i = 59, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  141.622413] ieee80211 phy1: I
iwl3945_rx_handle r = 61, i = 60, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  141.655043] ieee80211 phy1: I
iwl3945_rx_handle r = 62, i = 61, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  141.656513] ieee80211 phy1: I
iwl3945_rx_handle r = 63, i = 62, REPLY_3945_RX, 0x1b
Jan 26 22:24:14 rainbow kernel: [  141.660115] ieee80211 phy1: I
iwl3945_rx_handle r = 64, i = 63, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  141.672487] ieee80211 phy1: I
iwl3945_rx_handle r = 65, i = 64, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  141.692188] ieee80211 phy1: I
iwl3945_rx_handle r = 66, i = 65, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  141.712459] ieee80211 phy1: I
iwl3945_rx_handle r = 67, i = 66, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  141.716649] ieee80211 phy1: I
iwl3945_rx_handle r = 68, i = 67, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  141.718425] ieee80211 phy1: I
iwl3945_rx_handle r = 69, i = 68, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  141.722058] ieee80211 phy1: I
iwl3945_rx_handle r = 70, i = 69, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  141.752709] ieee80211 phy1: I
iwl3945_rx_handle r = 71, i = 70, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  141.757437] ieee80211 phy1: I
iwl3945_rx_handle r = 72, i = 71, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  141.758935] ieee80211 phy1: I
iwl3945_rx_handle r = 73, i = 72, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  141.774300] ieee80211 phy1: I
iwl3945_rx_handle r = 74, i = 73, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  141.794612] ieee80211 phy1: I
iwl3945_rx_handle r = 75, i = 74, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  141.814845] ieee80211 phy1: I
iwl3945_rx_handle r = 76, i = 75, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  141.822629] ieee80211 phy1: I
iwl3945_rx_handle r = 77, i = 76, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  141.824406] ieee80211 phy1: I
iwl3945_rx_handle r = 78, i = 77, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  141.859973] ieee80211 phy1: I
iwl3945_rx_handle r = 79, i = 78, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  141.861453] ieee80211 phy1: I
iwl3945_rx_handle r = 80, i = 79, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  141.877350] ieee80211 phy1: I
iwl3945_rx_handle r = 81, i = 80, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  141.897008] ieee80211 phy1: I
iwl3945_rx_handle r = 82, i = 81, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  141.917249] ieee80211 phy1: I
iwl3945_rx_handle r = 83, i = 82, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  141.921456] ieee80211 phy1: I
iwl3945_rx_handle r = 84, i = 83, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  141.923232] ieee80211 phy1: I
iwl3945_rx_handle r = 85, i = 84, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  141.926864] ieee80211 phy1: I
iwl3945_rx_handle r = 86, i = 85, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  141.962944] ieee80211 phy1: I
iwl3945_rx_handle r = 87, i = 86, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  141.966241] ieee80211 phy1: I
iwl3945_rx_handle r = 88, i = 87, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  141.967372] ieee80211 phy1: I
iwl3945_rx_handle r = 89, i = 88, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  141.980291] ieee80211 phy1: I
iwl3945_rx_handle r = 90, i = 89, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  141.999407] ieee80211 phy1: I
iwl3945_rx_handle r = 91, i = 90, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  142.019656] ieee80211 phy1: I
iwl3945_rx_handle r = 92, i = 91, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  142.025636] ieee80211 phy1: I
iwl3945_rx_handle r = 93, i = 92, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  142.029266] ieee80211 phy1: I
iwl3945_rx_handle r = 94, i = 93, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  142.049071] ieee80211 phy1: I
iwl3945_rx_handle r = 95, i = 94, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  142.063993] ieee80211 phy1: I
iwl3945_rx_handle r = 96, i = 95, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  142.066220] ieee80211 phy1: I
iwl3945_rx_handle r = 97, i = 96, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  142.082573] ieee80211 phy1: I
iwl3945_rx_handle r = 98, i = 97, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  142.101807] ieee80211 phy1: I
iwl3945_rx_handle r = 99, i = 98, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  142.122049] ieee80211 phy1: I
iwl3945_rx_handle r = 100, i = 99, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  142.126265] ieee80211 phy1: I
iwl3945_rx_handle r = 101, i = 100, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  142.128036] ieee80211 phy1: I
iwl3945_rx_handle r = 102, i = 101, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  142.167008] ieee80211 phy1: I
iwl3945_rx_handle r = 103, i = 102, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  142.168469] ieee80211 phy1: I
iwl3945_rx_handle r = 104, i = 103, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  142.184151] ieee80211 phy1: I
iwl3945_rx_handle r = 105, i = 104, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  142.204214] ieee80211 phy1: I
iwl3945_rx_handle r = 106, i = 105, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  142.224457] ieee80211 phy1: I
iwl3945_rx_handle r = 107, i = 106, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  142.228665] ieee80211 phy1: I
iwl3945_rx_handle r = 108, i = 107, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  142.230439] ieee80211 phy1: I
iwl3945_rx_handle r = 109, i = 108, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  142.268793] ieee80211 phy1: I
iwl3945_rx_handle r = 110, i = 109, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  142.270669] ieee80211 phy1: I
iwl3945_rx_handle r = 111, i = 110, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  142.286956] ieee80211 phy1: I
iwl3945_rx_handle r = 112, i = 111, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  142.306618] ieee80211 phy1: I
iwl3945_rx_handle r = 113, i = 112, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  142.326855] ieee80211 phy1: I
iwl3945_rx_handle r = 114, i = 113, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  142.331067] ieee80211 phy1: I
iwl3945_rx_handle r = 115, i = 114, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  142.336476] ieee80211 phy1: I
iwl3945_rx_handle r = 116, i = 115, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  142.371196] ieee80211 phy1: I
iwl3945_rx_handle r = 117, i = 116, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  142.409009] ieee80211 phy1: I
iwl3945_rx_handle r = 118, i = 117, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  142.429849] ieee80211 phy1: I
iwl3945_rx_handle r = 119, i = 118, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  142.438875] ieee80211 phy1: I
iwl3945_rx_handle r = 120, i = 119, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  142.469521] ieee80211 phy1: I
iwl3945_rx_handle r = 121, i = 120, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  142.474442] ieee80211 phy1: I
iwl3945_rx_handle r = 122, i = 121, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  142.478263] ieee80211 phy1: I
iwl3945_rx_handle r = 123, i = 122, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  142.511411] ieee80211 phy1: I
iwl3945_rx_handle r = 124, i = 123, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  142.531697] ieee80211 phy1: I
iwl3945_rx_handle r = 125, i = 124, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  142.535850] ieee80211 phy1: I
iwl3945_rx_handle r = 126, i = 125, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  142.541235] ieee80211 phy1: I
iwl3945_rx_handle r = 127, i = 126, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  142.575953] ieee80211 phy1: I
iwl3945_rx_handle r = 128, i = 127, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  142.577825] ieee80211 phy1: I
iwl3945_rx_handle r = 129, i = 128, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  142.593633] ieee80211 phy1: I
iwl3945_rx_handle r = 130, i = 129, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  142.613802] ieee80211 phy1: I
iwl3945_rx_handle r = 131, i = 130, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  142.634041] ieee80211 phy1: I
iwl3945_rx_handle r = 132, i = 131, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  142.639988] ieee80211 phy1: I
iwl3945_rx_handle r = 133, i = 132, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  142.643656] ieee80211 phy1: I
iwl3945_rx_handle r = 134, i = 133, REPLY_3945_RX, 0x1b
Jan 26 22:24:15 rainbow kernel: [  142.664544] ieee80211 phy1: I
iwl3945_rx_handle r = 135, i = 134, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  142.678911] ieee80211 phy1: I
iwl3945_rx_handle r = 136, i = 135, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  142.680433] ieee80211 phy1: I
iwl3945_rx_handle r = 137, i = 136, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  142.695995] ieee80211 phy1: I
iwl3945_rx_handle r = 138, i = 137, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  142.716192] ieee80211 phy1: I
iwl3945_rx_handle r = 139, i = 138, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  142.736449] ieee80211 phy1: I
iwl3945_rx_handle r = 140, i = 139, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  142.742567] ieee80211 phy1: I
iwl3945_rx_handle r = 141, i = 140, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  142.746056] ieee80211 phy1: I
iwl3945_rx_handle r = 142, i = 141, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  142.766941] ieee80211 phy1: I
iwl3945_rx_handle r = 143, i = 142, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  142.776669] ieee80211 phy1: I
iwl3945_rx_handle r = 144, i = 143, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  142.798366] ieee80211 phy1: I
iwl3945_rx_handle r = 145, i = 144, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  142.818595] ieee80211 phy1: I
iwl3945_rx_handle r = 146, i = 145, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  142.838841] ieee80211 phy1: I
iwl3945_rx_handle r = 147, i = 146, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  142.846584] ieee80211 phy1: I
iwl3945_rx_handle r = 148, i = 147, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  142.848438] ieee80211 phy1: I
iwl3945_rx_handle r = 149, i = 148, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  142.879121] ieee80211 phy1: I
iwl3945_rx_handle r = 150, i = 149, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  142.883800] ieee80211 phy1: I
iwl3945_rx_handle r = 151, i = 150, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  142.885289] ieee80211 phy1: I
iwl3945_rx_handle r = 152, i = 151, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  142.901898] ieee80211 phy1: I
iwl3945_rx_handle r = 153, i = 152, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  142.921029] ieee80211 phy1: I
iwl3945_rx_handle r = 154, i = 153, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  142.941266] ieee80211 phy1: I
iwl3945_rx_handle r = 155, i = 154, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  142.945487] ieee80211 phy1: I
iwl3945_rx_handle r = 156, i = 155, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  142.950885] ieee80211 phy1: I
iwl3945_rx_handle r = 157, i = 156, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  142.982368] ieee80211 phy1: I
iwl3945_rx_handle r = 158, i = 157, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  143.023425] ieee80211 phy1: I
iwl3945_rx_handle r = 159, i = 158, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  143.043666] ieee80211 phy1: I
iwl3945_rx_handle r = 160, i = 159, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  143.047895] ieee80211 phy1: I
iwl3945_rx_handle r = 161, i = 160, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  143.049844] ieee80211 phy1: I
iwl3945_rx_handle r = 162, i = 161, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  143.053240] ieee80211 phy1: I
iwl3945_rx_handle r = 163, i = 162, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  143.083943] ieee80211 phy1: I
iwl3945_rx_handle r = 164, i = 163, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  143.088020] ieee80211 phy1: I
iwl3945_rx_handle r = 165, i = 164, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  143.089503] ieee80211 phy1: I
iwl3945_rx_handle r = 166, i = 165, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  143.105559] ieee80211 phy1: I
iwl3945_rx_handle r = 167, i = 166, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  143.125827] ieee80211 phy1: I
iwl3945_rx_handle r = 168, i = 167, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  143.146068] ieee80211 phy1: I
iwl3945_rx_handle r = 169, i = 168, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  143.152058] ieee80211 phy1: I
iwl3945_rx_handle r = 170, i = 169, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  143.153922] ieee80211 phy1: I
iwl3945_rx_handle r = 171, i = 170, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  143.155691] ieee80211 phy1: I
iwl3945_rx_handle r = 172, i = 171, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  143.176621] ieee80211 phy1: I
iwl3945_rx_handle r = 173, i = 172, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  143.186338] ieee80211 phy1: I
iwl3945_rx_handle r = 174, i = 173, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  143.190424] ieee80211 phy1: I
iwl3945_rx_handle r = 175, i = 174, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  143.191909] ieee80211 phy1: I
iwl3945_rx_handle r = 176, i = 175, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  143.195090] ieee80211 phy1: I
iwl3945_rx_handle r = 177, i = 176, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  143.208920] ieee80211 phy1: I
iwl3945_rx_handle r = 178, i = 177, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  143.228226] ieee80211 phy1: I
iwl3945_rx_handle r = 179, i = 178, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  143.248468] ieee80211 phy1: I
iwl3945_rx_handle r = 180, i = 179, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  143.252697] ieee80211 phy1: I
iwl3945_rx_handle r = 181, i = 180, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  143.258099] ieee80211 phy1: I
iwl3945_rx_handle r = 182, i = 181, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  143.279019] ieee80211 phy1: I
iwl3945_rx_handle r = 183, i = 182, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  143.292823] ieee80211 phy1: I
iwl3945_rx_handle r = 184, i = 183, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  143.294771] ieee80211 phy1: I
iwl3945_rx_handle r = 185, i = 184, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  143.297413] ieee80211 phy1: I
iwl3945_rx_handle r = 186, i = 185, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  143.330610] ieee80211 phy1: I
iwl3945_rx_handle r = 187, i = 186, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  143.350971] ieee80211 phy1: I
iwl3945_rx_handle r = 188, i = 187, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  143.356855] ieee80211 phy1: I
iwl3945_rx_handle r = 189, i = 188, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  143.360439] ieee80211 phy1: I
iwl3945_rx_handle r = 190, i = 189, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  143.395726] ieee80211 phy1: I
iwl3945_rx_handle r = 191, i = 190, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  143.397206] ieee80211 phy1: I
iwl3945_rx_handle r = 192, i = 191, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  143.413386] ieee80211 phy1: I
iwl3945_rx_handle r = 193, i = 192, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  143.433038] ieee80211 phy1: I
iwl3945_rx_handle r = 194, i = 193, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  143.453279] ieee80211 phy1: I
iwl3945_rx_handle r = 195, i = 194, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  143.462899] ieee80211 phy1: I
iwl3945_rx_handle r = 196, i = 195, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  143.483830] ieee80211 phy1: I
iwl3945_rx_handle r = 197, i = 196, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  143.498248] ieee80211 phy1: I
iwl3945_rx_handle r = 198, i = 197, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  143.499741] ieee80211 phy1: I
iwl3945_rx_handle r = 199, i = 198, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  143.515153] ieee80211 phy1: I
iwl3945_rx_handle r = 200, i = 199, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  143.535429] ieee80211 phy1: I
iwl3945_rx_handle r = 201, i = 200, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  143.555681] ieee80211 phy1: I
iwl3945_rx_handle r = 202, i = 201, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  143.559906] ieee80211 phy1: I
iwl3945_rx_handle r = 203, i = 202, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  143.561662] ieee80211 phy1: I
iwl3945_rx_handle r = 204, i = 203, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  143.565464] ieee80211 phy1: I
iwl3945_rx_handle r = 205, i = 204, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  143.595936] ieee80211 phy1: I
iwl3945_rx_handle r = 206, i = 205, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  143.600639] ieee80211 phy1: I
iwl3945_rx_handle r = 207, i = 206, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  143.602125] ieee80211 phy1: I
iwl3945_rx_handle r = 208, i = 207, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  143.604576] ieee80211 phy1: I
iwl3945_rx_handle r = 209, i = 208, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  143.618191] ieee80211 phy1: I
iwl3945_rx_handle r = 210, i = 209, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  143.637836] ieee80211 phy1: I
iwl3945_rx_handle r = 211, i = 210, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  143.658074] ieee80211 phy1: I
iwl3945_rx_handle r = 212, i = 211, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  143.662312] ieee80211 phy1: I
iwl3945_rx_handle r = 213, i = 212, REPLY_3945_RX, 0x1b
Jan 26 22:24:16 rainbow kernel: [  143.664104] ieee80211 phy1: I
iwl3945_rx_handle r = 214, i = 213, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  143.681447] ieee80211 phy1: I
iwl3945_rx_handle r = 215, i = 214, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  143.702440] ieee80211 phy1: I
iwl3945_rx_handle r = 216, i = 215, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  143.720596] ieee80211 phy1: I
iwl3945_rx_handle r = 217, i = 216, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  143.740230] ieee80211 phy1: I
iwl3945_rx_handle r = 218, i = 217, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  143.760922] ieee80211 phy1: I
iwl3945_rx_handle r = 219, i = 218, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  143.766467] ieee80211 phy1: I
iwl3945_rx_handle r = 220, i = 219, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  143.770098] ieee80211 phy1: I
iwl3945_rx_handle r = 221, i = 220, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  143.805479] ieee80211 phy1: I
iwl3945_rx_handle r = 222, i = 221, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  143.809501] ieee80211 phy1: I
iwl3945_rx_handle r = 223, i = 222, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  143.822988] ieee80211 phy1: I
iwl3945_rx_handle r = 224, i = 223, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  143.842630] ieee80211 phy1: I
iwl3945_rx_handle r = 225, i = 224, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  143.862883] ieee80211 phy1: I
iwl3945_rx_handle r = 226, i = 225, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  143.868873] ieee80211 phy1: I
iwl3945_rx_handle r = 227, i = 226, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  143.872475] ieee80211 phy1: I
iwl3945_rx_handle r = 228, i = 227, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  143.903297] ieee80211 phy1: I
iwl3945_rx_handle r = 229, i = 228, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  143.907893] ieee80211 phy1: I
iwl3945_rx_handle r = 230, i = 229, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  143.909393] ieee80211 phy1: I
iwl3945_rx_handle r = 231, i = 230, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  143.911820] ieee80211 phy1: I
iwl3945_rx_handle r = 232, i = 231, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  143.945041] ieee80211 phy1: I
iwl3945_rx_handle r = 233, i = 232, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  143.965279] ieee80211 phy1: I
iwl3945_rx_handle r = 234, i = 233, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  143.975273] ieee80211 phy1: I
iwl3945_rx_handle r = 235, i = 234, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  144.009653] ieee80211 phy1: I
iwl3945_rx_handle r = 236, i = 235, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  144.011145] ieee80211 phy1: I
iwl3945_rx_handle r = 237, i = 236, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  144.027800] ieee80211 phy1: I
iwl3945_rx_handle r = 238, i = 237, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  144.047445] ieee80211 phy1: I
iwl3945_rx_handle r = 239, i = 238, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  144.067684] ieee80211 phy1: I
iwl3945_rx_handle r = 240, i = 239, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  144.077315] ieee80211 phy1: I
iwl3945_rx_handle r = 241, i = 240, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  144.112052] ieee80211 phy1: I
iwl3945_rx_handle r = 242, i = 241, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  144.113895] ieee80211 phy1: I
iwl3945_rx_handle r = 243, i = 242, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  144.129634] ieee80211 phy1: I
iwl3945_rx_handle r = 244, i = 243, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  144.149847] ieee80211 phy1: I
iwl3945_rx_handle r = 245, i = 244, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  144.170080] ieee80211 phy1: I
iwl3945_rx_handle r = 246, i = 245, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  144.174329] ieee80211 phy1: I
iwl3945_rx_handle r = 247, i = 246, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  144.176097] ieee80211 phy1: I
iwl3945_rx_handle r = 248, i = 247, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  144.178513] ieee80211 phy1: I
iwl3945_rx_handle r = 249, i = 248, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  144.179705] ieee80211 phy1: I
iwl3945_rx_handle r = 250, i = 249, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  144.210357] ieee80211 phy1: I
iwl3945_rx_handle r = 251, i = 250, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  144.214454] ieee80211 phy1: I
iwl3945_rx_handle r = 252, i = 251, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  144.215948] ieee80211 phy1: I
iwl3945_rx_handle r = 253, i = 252, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  144.219125] ieee80211 phy1: I
iwl3945_rx_handle r = 254, i = 253, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  144.232023] ieee80211 phy1: I
iwl3945_rx_handle r = 255, i = 254, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  144.252240] ieee80211 phy1: I
iwl3945_rx_handle r = 0, i = 255, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  144.276734] ieee80211 phy1: I
iwl3945_rx_handle r = 1, i = 0, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  144.280886] ieee80211 phy1: I
iwl3945_rx_handle r = 2, i = 1, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  144.282482] ieee80211 phy1: I
iwl3945_rx_handle r = 3, i = 2, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  144.321724] ieee80211 phy1: I
iwl3945_rx_handle r = 4, i = 3, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  144.322965] ieee80211 phy1: I
iwl3945_rx_handle r = 5, i = 4, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  144.334485] ieee80211 phy1: I
iwl3945_rx_handle r = 6, i = 5, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  144.354640] ieee80211 phy1: I
iwl3945_rx_handle r = 7, i = 6, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  144.374883] ieee80211 phy1: I
iwl3945_rx_handle r = 8, i = 7, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  144.380880] ieee80211 phy1: I
iwl3945_rx_handle r = 9, i = 8, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  144.387239] ieee80211 phy1: I
iwl3945_rx_handle r = 10, i = 9, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  144.416459] ieee80211 phy1: I
iwl3945_rx_handle r = 11, i = 10, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  144.419259] ieee80211 phy1: I
iwl3945_rx_handle r = 12, i = 11, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  144.421089] ieee80211 phy1: I
iwl3945_rx_handle r = 13, i = 12, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  144.437408] ieee80211 phy1: I
iwl3945_rx_handle r = 14, i = 13, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  144.478476] ieee80211 phy1: I
iwl3945_rx_handle r = 15, i = 14, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  144.484251] ieee80211 phy1: I
iwl3945_rx_handle r = 16, i = 15, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  144.485200] ieee80211 phy1: I
iwl3945_rx_handle r = 17, i = 16, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  144.486910] ieee80211 phy1: I
iwl3945_rx_handle r = 18, i = 17, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  144.517560] ieee80211 phy1: I
iwl3945_rx_handle r = 19, i = 18, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  144.521664] ieee80211 phy1: I
iwl3945_rx_handle r = 20, i = 19, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  144.523584] ieee80211 phy1: I
iwl3945_rx_handle r = 21, i = 20, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  144.526204] ieee80211 phy1: I
iwl3945_rx_handle r = 22, i = 21, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  144.539289] ieee80211 phy1: I
iwl3945_rx_handle r = 23, i = 22, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  144.559442] ieee80211 phy1: I
iwl3945_rx_handle r = 24, i = 23, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  144.579913] ieee80211 phy1: I
iwl3945_rx_handle r = 25, i = 24, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  144.583936] ieee80211 phy1: I
iwl3945_rx_handle r = 26, i = 25, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  144.589264] ieee80211 phy1: I
iwl3945_rx_handle r = 27, i = 26, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  144.624732] ieee80211 phy1: I
iwl3945_rx_handle r = 28, i = 27, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  144.626225] ieee80211 phy1: I
iwl3945_rx_handle r = 29, i = 28, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  144.628611] ieee80211 phy1: I
iwl3945_rx_handle r = 30, i = 29, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  144.642760] ieee80211 phy1: I
iwl3945_rx_handle r = 31, i = 30, REPLY_3945_RX, 0x1b
Jan 26 22:24:17 rainbow kernel: [  144.661843] ieee80211 phy1: I
iwl3945_rx_handle r = 32, i = 31, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  144.682090] ieee80211 phy1: I
iwl3945_rx_handle r = 33, i = 32, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  144.686343] ieee80211 phy1: I
iwl3945_rx_handle r = 34, i = 33, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  144.688107] ieee80211 phy1: I
iwl3945_rx_handle r = 35, i = 34, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  144.691721] ieee80211 phy1: I
iwl3945_rx_handle r = 36, i = 35, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  144.726472] ieee80211 phy1: I
iwl3945_rx_handle r = 37, i = 36, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  144.731068] ieee80211 phy1: I
iwl3945_rx_handle r = 38, i = 37, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  144.744610] ieee80211 phy1: I
iwl3945_rx_handle r = 39, i = 38, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  144.764249] ieee80211 phy1: I
iwl3945_rx_handle r = 40, i = 39, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  144.784492] ieee80211 phy1: I
iwl3945_rx_handle r = 41, i = 40, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  144.794117] ieee80211 phy1: I
iwl3945_rx_handle r = 42, i = 41, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  144.814723] ieee80211 phy1: I
iwl3945_rx_handle r = 43, i = 42, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  144.829489] ieee80211 phy1: I
iwl3945_rx_handle r = 44, i = 43, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  144.830981] ieee80211 phy1: I
iwl3945_rx_handle r = 45, i = 44, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  144.847446] ieee80211 phy1: I
iwl3945_rx_handle r = 46, i = 45, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  144.866652] ieee80211 phy1: I
iwl3945_rx_handle r = 47, i = 46, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  144.887084] ieee80211 phy1: I
iwl3945_rx_handle r = 48, i = 47, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  144.898890] ieee80211 phy1: I
iwl3945_rx_handle r = 49, i = 48, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  144.931947] ieee80211 phy1: I
iwl3945_rx_handle r = 50, i = 49, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  144.933439] ieee80211 phy1: I
iwl3945_rx_handle r = 51, i = 50, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  144.935869] ieee80211 phy1: I
iwl3945_rx_handle r = 52, i = 51, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  144.948830] ieee80211 phy1: I
iwl3945_rx_handle r = 53, i = 52, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  144.969052] ieee80211 phy1: I
iwl3945_rx_handle r = 54, i = 53, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  144.989400] ieee80211 phy1: I
iwl3945_rx_handle r = 55, i = 54, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  144.993552] ieee80211 phy1: I
iwl3945_rx_handle r = 56, i = 55, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  144.998928] ieee80211 phy1: I
iwl3945_rx_handle r = 57, i = 56, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  145.029564] ieee80211 phy1: I
iwl3945_rx_handle r = 58, i = 57, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  145.033682] ieee80211 phy1: I
iwl3945_rx_handle r = 59, i = 58, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  145.035684] ieee80211 phy1: I
iwl3945_rx_handle r = 60, i = 59, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  145.051210] ieee80211 phy1: I
iwl3945_rx_handle r = 61, i = 60, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  145.071458] ieee80211 phy1: I
iwl3945_rx_handle r = 62, i = 61, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  145.093053] ieee80211 phy1: I
iwl3945_rx_handle r = 63, i = 62, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  145.095949] ieee80211 phy1: I
iwl3945_rx_handle r = 64, i = 63, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  145.097635] ieee80211 phy1: I
iwl3945_rx_handle r = 65, i = 64, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  145.101326] ieee80211 phy1: I
iwl3945_rx_handle r = 66, i = 65, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  145.131973] ieee80211 phy1: I
iwl3945_rx_handle r = 67, i = 66, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  145.136805] ieee80211 phy1: I
iwl3945_rx_handle r = 68, i = 67, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  145.140621] ieee80211 phy1: I
iwl3945_rx_handle r = 69, i = 68, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  145.173852] ieee80211 phy1: I
iwl3945_rx_handle r = 70, i = 69, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  145.194110] ieee80211 phy1: I
iwl3945_rx_handle r = 71, i = 70, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  145.198354] ieee80211 phy1: I
iwl3945_rx_handle r = 72, i = 71, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  145.201984] ieee80211 phy1: I
iwl3945_rx_handle r = 73, i = 72, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  145.203726] ieee80211 phy1: I
iwl3945_rx_handle r = 74, i = 73, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  145.234375] ieee80211 phy1: I
iwl3945_rx_handle r = 75, i = 74, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  145.238486] ieee80211 phy1: I
iwl3945_rx_handle r = 76, i = 75, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  145.243157] ieee80211 phy1: I
iwl3945_rx_handle r = 77, i = 76, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  145.276251] ieee80211 phy1: I
iwl3945_rx_handle r = 78, i = 77, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  145.297214] ieee80211 phy1: I
iwl3945_rx_handle r = 79, i = 78, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  145.300731] ieee80211 phy1: I
iwl3945_rx_handle r = 80, i = 79, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  145.302496] ieee80211 phy1: I
iwl3945_rx_handle r = 81, i = 80, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  145.306135] ieee80211 phy1: I
iwl3945_rx_handle r = 82, i = 81, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  145.340896] ieee80211 phy1: I
iwl3945_rx_handle r = 83, i = 82, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  145.342381] ieee80211 phy1: I
iwl3945_rx_handle r = 84, i = 83, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  145.345542] ieee80211 phy1: I
iwl3945_rx_handle r = 85, i = 84, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  145.358834] ieee80211 phy1: I
iwl3945_rx_handle r = 86, i = 85, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  145.378657] ieee80211 phy1: I
iwl3945_rx_handle r = 87, i = 86, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  145.398903] ieee80211 phy1: I
iwl3945_rx_handle r = 88, i = 87, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  145.403381] ieee80211 phy1: I
iwl3945_rx_handle r = 89, i = 88, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  145.404868] ieee80211 phy1: I
iwl3945_rx_handle r = 90, i = 89, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  145.408539] ieee80211 phy1: I
iwl3945_rx_handle r = 91, i = 90, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  145.429490] ieee80211 phy1: I
iwl3945_rx_handle r = 92, i = 91, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  145.443930] ieee80211 phy1: I
iwl3945_rx_handle r = 93, i = 92, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  145.445419] ieee80211 phy1: I
iwl3945_rx_handle r = 94, i = 93, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  145.460909] ieee80211 phy1: I
iwl3945_rx_handle r = 95, i = 94, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  145.481053] ieee80211 phy1: I
iwl3945_rx_handle r = 96, i = 95, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  145.501304] ieee80211 phy1: I
iwl3945_rx_handle r = 97, i = 96, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  145.505567] ieee80211 phy1: I
iwl3945_rx_handle r = 98, i = 97, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  145.510936] ieee80211 phy1: I
iwl3945_rx_handle r = 99, i = 98, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  145.546347] ieee80211 phy1: I
iwl3945_rx_handle r = 100, i = 99, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  145.548166] ieee80211 phy1: I
iwl3945_rx_handle r = 101, i = 100, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  145.563353] ieee80211 phy1: I
iwl3945_rx_handle r = 102, i = 101, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  145.583463] ieee80211 phy1: I
iwl3945_rx_handle r = 103, i = 102, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  145.603701] ieee80211 phy1: I
iwl3945_rx_handle r = 104, i = 103, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  145.609699] ieee80211 phy1: I
iwl3945_rx_handle r = 105, i = 104, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  145.611901] ieee80211 phy1: I
iwl3945_rx_handle r = 106, i = 105, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  145.613308] ieee80211 phy1: I
iwl3945_rx_handle r = 107, i = 106, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  145.648781] ieee80211 phy1: I
iwl3945_rx_handle r = 108, i = 107, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  145.650273] ieee80211 phy1: I
iwl3945_rx_handle r = 109, i = 108, REPLY_3945_RX, 0x1b
Jan 26 22:24:18 rainbow kernel: [  145.665631] ieee80211 phy1: I
iwl3945_rx_handle r = 110, i = 109, REPLY_3945_RX, 0x1b
Jan 26 22:24:19 rainbow kernel: [  145.685858] ieee80211 phy1: I
iwl3945_rx_handle r = 111, i = 110, REPLY_3945_RX, 0x1b
Jan 26 22:24:19 rainbow kernel: [  145.706101] ieee80211 phy1: I
iwl3945_rx_handle r = 112, i = 111, REPLY_3945_RX, 0x1b
Jan 26 22:24:19 rainbow kernel: [  145.710380] ieee80211 phy1: I
iwl3945_rx_handle r = 113, i = 112, REPLY_3945_RX, 0x1b
Jan 26 22:24:19 rainbow kernel: [  145.715742] ieee80211 phy1: I
iwl3945_rx_handle r = 114, i = 113, REPLY_3945_RX, 0x1b
Jan 26 22:24:19 rainbow kernel: [  145.750506] ieee80211 phy1: I
iwl3945_rx_handle r = 115, i = 114, REPLY_3945_RX, 0x1b
Jan 26 22:24:19 rainbow kernel: [  145.755174] ieee80211 phy1: I
iwl3945_rx_handle r = 116, i = 115, REPLY_3945_RX, 0x1b
Jan 26 22:24:19 rainbow kernel: [  145.768732] ieee80211 phy1: I
iwl3945_rx_handle r = 117, i = 116, REPLY_3945_RX, 0x1b
Jan 26 22:24:19 rainbow kernel: [  145.821266] ieee80211 phy1: I
iwl3945_rx_handle r = 118, i = 117, REPLY_3945_RX, 0x1b
Jan 26 22:24:19 rainbow kernel: [  145.854410] ieee80211 phy1: I
iwl3945_rx_handle r = 119, i = 118, REPLY_3945_RX, 0x1b
Jan 26 22:24:19 rainbow kernel: [  145.857962] ieee80211 phy1: I
iwl3945_rx_handle r = 120, i = 119, REPLY_3945_RX, 0x1b
Jan 26 22:24:19 rainbow kernel: [  145.862127] ieee80211 phy1: U
iwl3945_pci_remove *** UNLOAD DRIVER ***
Jan 26 22:24:19 rainbow kernel: [  145.871514] ieee80211 phy1: I
iwl3945_rx_handle r = 121, i = 120, REPLY_3945_RX, 0x1b
Jan 26 22:24:19 rainbow kernel: [  145.872083] ieee80211 phy1: I
iwl3945_configure_filter Enter: changed: 0x0, total: 0x80000000
Jan 26 22:24:19 rainbow kernel: [  145.890666] ieee80211 phy1: I
iwl3945_rx_handle r = 122, i = 121, REPLY_3945_RX, 0x1b
Jan 26 22:24:19 rainbow kernel: [  145.896116] ieee80211 phy1: U
iwl3945_mac_remove_interface enter
Jan 26 22:24:19 rainbow kernel: [  145.896127] ieee80211 phy1: U
iwl3945_mac_remove_interface leave
Jan 26 22:24:19 rainbow kernel: [  145.910216] ieee80211 phy1: U
iwl3945_mac_stop enter
Jan 26 22:24:19 rainbow kernel: [  145.910229] ieee80211 phy1: U
__iwl3945_down iwl3945 is going down
Jan 26 22:24:19 rainbow kernel: [  145.910530] ieee80211 phy1: U
iwl3945_apm_stop_master stop master
Jan 26 22:24:19 rainbow kernel: [  145.911242] ieee80211 phy1: U
iwl3945_apm_stop_master stop master
Jan 26 22:24:19 rainbow kernel: [  145.911274] ieee80211 phy1: U
iwl3945_clear_free_frames 0 frames on pre-allocated heap on clear.
Jan 26 22:24:19 rainbow kernel: [  145.911287] ieee80211 phy1: U
iwl3945_mac_stop leave
Jan 26 22:24:19 rainbow kernel: [  146.005024] iwl3945 0000:03:00.0:
PCI INT A disabled
Jan 26 22:24:26 rainbow kernel: [  153.217044] usb 5-2: new high speed
USB device using ehci_hcd and address 3
Jan 26 22:24:26 rainbow kernel: [  153.349788] usb 5-2: configuration
#1 chosen from 1 choice
Jan 26 22:24:26 rainbow kernel: [  153.350045] usb 5-2: firmware:
requesting isl3886usb
Jan 26 22:24:26 rainbow kernel: [  153.357700] phy2: p54 detected a
LM86 firmware
Jan 26 22:24:26 rainbow kernel: [  153.357706] p54: rx_mtu reduced
from 3240 to 2392
Jan 26 22:24:26 rainbow kernel: [  153.357711] phy2: FW rev 2.13.24.0
- Softmac protocol 5.9
Jan 26 22:24:26 rainbow kernel: [  153.357716] phy2: cryptographic
accelerator WEP:YES, TKIP:YES, CCMP:YES
Jan 26 22:24:28 rainbow kernel: [  155.552234] p54usb: probe of
5-2:1.0 failed with error -110
Jan 26 22:24:48 rainbow kernel: [  174.879425] usb 5-2: USB
disconnect, address 3
Jan 26 22:24:50 rainbow kernel: [  177.316145] usb 5-2: new high speed
USB device using ehci_hcd and address 4
Jan 26 22:24:50 rainbow kernel: [  177.448722] usb 5-2: configuration
#1 chosen from 1 choice
Jan 26 22:24:50 rainbow kernel: [  177.448935] usb 5-2: firmware:
requesting isl3886usb
Jan 26 22:24:50 rainbow kernel: [  177.485489] phy3: p54 detected a
LM86 firmware
Jan 26 22:24:50 rainbow kernel: [  177.485496] p54: rx_mtu reduced
from 3240 to 2392
Jan 26 22:24:50 rainbow kernel: [  177.485501] phy3: FW rev 2.13.1.0 -
Softmac protocol 5.5
Jan 26 22:24:50 rainbow kernel: [  177.485506] phy3: cryptographic
accelerator WEP:YES, TKIP:YES, CCMP:YES
Jan 26 22:24:52 rainbow kernel: [  179.392096] phy3: hwaddr
00:15:e9:12:3f:65, MAC:isl3886 RF:Frisbee
Jan 26 22:24:52 rainbow kernel: [  179.400242] wmaster0 (p54usb): not
using net_device_ops yet
Jan 26 22:24:52 rainbow kernel: [  179.401500] phy3: Selected rate
control algorithm 'minstrel'
Jan 26 22:24:52 rainbow kernel: [  179.401592] wlan0 (p54usb): not
using net_device_ops yet
Jan 26 22:24:52 rainbow kernel: [  179.421574] udev: renamed network
interface wlan0 to wlan2
Jan 26 22:24:56 rainbow kernel: [  183.486290] ADDRCONF(NETDEV_UP):
wlan2: link is not ready
Jan 26 22:24:57 rainbow kernel: [  184.181337] wlan2: authenticate
with AP 00:30:bd:c0:90:24
Jan 26 22:24:57 rainbow kernel: [  184.190363] wlan2: authenticated
Jan 26 22:24:57 rainbow kernel: [  184.190370] wlan2: associate with
AP 00:30:bd:c0:90:24
Jan 26 22:24:57 rainbow kernel: [  184.193885] wlan2: RX AssocResp
from 00:30:bd:c0:90:24 (capab=0x1 status=0 aid=8)
Jan 26 22:24:57 rainbow kernel: [  184.193892] wlan2: associated
Jan 26 22:24:57 rainbow kernel: [  184.194510] wlan2: disassociating
by local choice (reason=3)
Jan 26 22:25:03 rainbow kernel: [  189.870792] wlan2: authenticate
with AP 00:30:bd:c0:90:24
Jan 26 22:25:03 rainbow kernel: [  189.875492] wlan2: authenticated
Jan 26 22:25:03 rainbow kernel: [  189.875498] wlan2: associate with
AP 00:30:bd:c0:90:24
Jan 26 22:25:03 rainbow kernel: [  189.878367] wlan2: RX AssocResp
from 00:30:bd:c0:90:24 (capab=0x1 status=0 aid=8)
Jan 26 22:25:03 rainbow kernel: [  189.878374] wlan2: associated
Jan 26 22:25:03 rainbow kernel: [  189.883084]
ADDRCONF(NETDEV_CHANGE): wlan2: link becomes ready
Jan 26 22:25:13 rainbow kernel: [  200.460142] wlan2: no IPv6 routers present
