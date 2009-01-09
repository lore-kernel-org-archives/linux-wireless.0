Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web57604.mail.re1.yahoo.com ([66.196.100.86]:40249 "HELO
	web57604.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753667AbZAIXHF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 18:07:05 -0500
References: <326502.74480.qm@web57615.mail.re1.yahoo.com> <1231528324.30298.14.camel@rc-desk>
Date: Fri, 9 Jan 2009 15:07:01 -0800 (PST)
From: Deuce <the_deuce@yahoo.com>
Subject: Re: kernel BUG at drivers/net/wireless/iwlwifi/iwl3945-base.c:3127!
To: reinette chatre <reinette.chatre@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <960943.33934.qm@web57604.mail.re1.yahoo.com> (sfid-20090110_000734_357822_57F83147)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> From: reinette chatre <reinette.chatre@intel.com>

> On Thu, 2009-01-08 at 19:28 -0800, Deuce wrote:
> > Kernel BUG in iwl3945 with 20090107 wireless-testing and firmware 15.28.2.8  
> The Microcode SW error detected seems to be the beginning of the end.  An 
> attempt with Ubuntu's distributed iwlwifi-3945-1.ucode firmware was not 
> successful either (I do not know the version).
> > 
> > The BUG happens a short period after logging in when Netmanager starts to scan 
> and attempt to associate.  Association never completes.
> > 
> > Curiously, the bug was not triggered the first time I finally booted up with 
> iwl3945 debug=0x43fff and netconsole functioning.  However it was immediately 
> triggered on a subsequent reboot.  The first try may have been a warm reboot vs. 
> a cold reboot.
> > 
> > Below is the dmesg output without debug.  Attached is a full dmesg output with 
> debug=0x43fff.
> 
> There appears to be a few things going on here. I am still investigating
> the firmware error, but we could start with something that will not let
> your machine crash and get us some more information about one of the
> issues.
> 
> Could you please try with this patch? Please do run your test with
> debugging enabled as you have done before. Thank you very much.
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c 
> b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> index a23d51d..09c1c8d 100644
> --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
> +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> @@ -3118,7 +3118,14 @@ static void iwl3945_tx_cmd_complete(struct iwl_priv 
> *priv,
>     int cmd_index;
>     struct iwl_cmd *cmd;
> 
> -    BUG_ON(txq_id != IWL_CMD_QUEUE_NUM);
> +    if (WARN(txq_id != IWL_CMD_QUEUE_NUM,
> +         "wrong command queue %d, sequence 0x%X readp=%d writep=%d\n",
> +          txq_id, sequence,
> +          priv->txq[IWL_CMD_QUEUE_NUM].q.read_ptr,
> +          priv->txq[IWL_CMD_QUEUE_NUM].q.write_ptr)) {
> +        iwl_print_hex_dump(priv, IWL_DL_INFO , rxb, 32);
> +        return;
> +    }
> 
>     cmd_index = get_cmd_index(&priv->txq[IWL_CMD_QUEUE_NUM].q, index, huge);
>     cmd = priv->txq[IWL_CMD_QUEUE_NUM].cmd[cmd_index];

New log attached.  Only the above patch was applied to the previous code base.

Thanks,

Jason

Jan  9 17:47:45 rainbow kernel: Inspecting /boot/System.map-2.6.28-wl
Jan  9 17:47:45 rainbow kernel: Cannot find map file.
Jan  9 17:47:45 rainbow kernel: Loaded 53821 symbols from 85 modules.
Jan  9 17:47:45 rainbow kernel: [    0.000000] BIOS EBDA/lowmem at: 0009d800/0009d800
Jan  9 17:47:45 rainbow kernel: [    0.000000] Initializing cgroup subsys cpuset
Jan  9 17:47:45 rainbow kernel: [    0.000000] Initializing cgroup subsys cpu
Jan  9 17:47:45 rainbow kernel: [    0.000000] Linux version 2.6.28-wl (captainamerica@rainbow) (gcc version 4.3.2 (Ubuntu 4.3.2-1ubuntu11) ) #7 SMP Fri Jan 9 17:36:30 EST 2009
Jan  9 17:47:45 rainbow kernel: [    0.000000] Command line: root=UUID=b49fa89a-8364-4ea0-b712-438b002b45c1 ro debug netconsole=@169.254.1.1/eth0,6666@169.254.5.142/00:0d:93:7b:d8:a0
Jan  9 17:47:45 rainbow kernel: [    0.000000] KERNEL supported cpus:
Jan  9 17:47:45 rainbow kernel: [    0.000000]   Intel GenuineIntel
Jan  9 17:47:45 rainbow kernel: [    0.000000]   AMD AuthenticAMD
Jan  9 17:47:45 rainbow kernel: [    0.000000]   Centaur CentaurHauls
Jan  9 17:47:45 rainbow kernel: [    0.000000] BIOS-provided physical RAM map:
Jan  9 17:47:45 rainbow kernel: [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009d800 (usable)
Jan  9 17:47:45 rainbow kernel: [    0.000000]  BIOS-e820: 000000000009d800 - 00000000000a0000 (reserved)
Jan  9 17:47:45 rainbow kernel: [    0.000000]  BIOS-e820: 00000000000d2000 - 00000000000d4000 (reserved)
Jan  9 17:47:45 rainbow kernel: [    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
Jan  9 17:47:45 rainbow kernel: [    0.000000]  BIOS-e820: 0000000000100000 - 00000000bf6b0000 (usable)
Jan  9 17:47:45 rainbow kernel: [    0.000000]  BIOS-e820: 00000000bf6b0000 - 00000000bf6cc000 (ACPI data)
Jan  9 17:47:45 rainbow kernel: [    0.000000]  BIOS-e820: 00000000bf6cc000 - 00000000bf700000 (ACPI NVS)
Jan  9 17:47:45 rainbow kernel: [    0.000000]  BIOS-e820: 00000000bf700000 - 00000000c0000000 (reserved)
Jan  9 17:47:45 rainbow kernel: [    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
Jan  9 17:47:45 rainbow kernel: [    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
Jan  9 17:47:45 rainbow kernel: [    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
Jan  9 17:47:45 rainbow kernel: [    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
Jan  9 17:47:45 rainbow kernel: [    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
Jan  9 17:47:45 rainbow kernel: [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
Jan  9 17:47:45 rainbow kernel: [    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
Jan  9 17:47:45 rainbow kernel: [    0.000000]  BIOS-e820: 0000000100000000 - 000000013c000000 (usable)
Jan  9 17:47:45 rainbow kernel: [    0.000000] DMI present.
Jan  9 17:47:45 rainbow kernel: [    0.000000] last_pfn = 0x13c000 max_arch_pfn = 0x3ffffffff
Jan  9 17:47:45 rainbow kernel: [    0.000000] last_pfn = 0xbf6b0 max_arch_pfn = 0x3ffffffff
Jan  9 17:47:45 rainbow kernel: [    0.000000] init_memory_mapping: 0000000000000000-00000000bf6b0000
Jan  9 17:47:45 rainbow kernel: [    0.000000]  0000000000 - 00bf600000 page 2M
Jan  9 17:47:45 rainbow kernel: [    0.000000]  00bf600000 - 00bf6b0000 page 4k
Jan  9 17:47:45 rainbow kernel: [    0.000000] kernel direct mapping tables up to bf6b0000 @ 8000-d000
Jan  9 17:47:45 rainbow kernel: [    0.000000] last_map_addr: bf6b0000 end: bf6b0000
Jan  9 17:47:45 rainbow kernel: [    0.000000] init_memory_mapping: 0000000100000000-000000013c000000
Jan  9 17:47:45 rainbow kernel: [    0.000000]  0100000000 - 013c000000 page 2M
Jan  9 17:47:45 rainbow kernel: [    0.000000] kernel direct mapping tables up to 13c000000 @ b000-11000
Jan  9 17:47:45 rainbow kernel: [    0.000000] last_map_addr: 13c000000 end: 13c000000
Jan  9 17:47:45 rainbow kernel: [    0.000000] RAMDISK: 36a36000 - 37fefbe8
Jan  9 17:47:45 rainbow kernel: [    0.000000] ACPI: RSDP 000F68D0, 0024 (r2 LENOVO)
Jan  9 17:47:45 rainbow kernel: [    0.000000] ACPI: XSDT BF6BB74D, 0094 (r1 LENOVO TP-7L        2120  LTP        0)
Jan  9 17:47:45 rainbow kernel: [    0.000000] ACPI: FACP BF6BB800, 00F4 (r3 LENOVO TP-7L        2120 LNVO        1)
Jan  9 17:47:45 rainbow kernel: [    0.000000] ACPI Warning (tbfadt-0460): Optional field "Gpe1Block" has zero address or length: 000000000000102C/0 [20080926]
Jan  9 17:47:45 rainbow kernel: [    0.000000] ACPI: DSDT BF6BBC1D, FF03 (r1 LENOVO TP-7L        2120 MSFT  3000000)
Jan  9 17:47:45 rainbow kernel: [    0.000000] ACPI: FACS BF6E4000, 0040
Jan  9 17:47:45 rainbow kernel: [    0.000000] ACPI: SSDT BF6BB9B4, 0269 (r1 LENOVO TP-7L        2120 MSFT  3000000)
Jan  9 17:47:45 rainbow kernel: [    0.000000] ACPI: ECDT BF6CBB20, 0052 (r1 LENOVO TP-7L        2120 LNVO        1)
Jan  9 17:47:45 rainbow kernel: [    0.000000] ACPI: TCPA BF6CBB72, 0032 (r2 LENOVO TP-7L        2120 LNVO        1)
Jan  9 17:47:45 rainbow kernel: [    0.000000] ACPI: APIC BF6CBBA4, 0068 (r1 LENOVO TP-7L        2120 LNVO        1)
Jan  9 17:47:45 rainbow kernel: [    0.000000] ACPI: MCFG BF6CBC0C, 003C (r1 LENOVO TP-7L        2120 LNVO        1)
Jan  9 17:47:45 rainbow kernel: [    0.000000] ACPI: HPET BF6CBC48, 0038 (r1 LENOVO TP-7L        2120 LNVO        1)
Jan  9 17:47:45 rainbow kernel: [    0.000000] ACPI: SLIC BF6CBDF0, 0176 (r1 LENOVO TP-7L        2120  LTP        0)
Jan  9 17:47:45 rainbow kernel: [    0.000000] ACPI: BOOT BF6CBF66, 0028 (r1 LENOVO TP-7L        2120  LTP        1)
Jan  9 17:47:45 rainbow kernel: [    0.000000] ACPI: ASF! BF6CBF8E, 0072 (r16 LENOVO TP-7L        2120 PTL         1)
Jan  9 17:47:45 rainbow kernel: [    0.000000] ACPI: SSDT BF6E26D9, 025F (r1 LENOVO TP-7L        2120 INTL 20050513)
Jan  9 17:47:45 rainbow kernel: [    0.000000] ACPI: SSDT BF6E2938, 00A6 (r1 LENOVO TP-7L        2120 INTL 20050513)
Jan  9 17:47:45 rainbow kernel: [    0.000000] ACPI: SSDT BF6E29DE, 04F7 (r1 LENOVO TP-7L        2120 INTL 20050513)
Jan  9 17:47:45 rainbow kernel: [    0.000000] ACPI: SSDT BF6E2ED5, 01D8 (r1 LENOVO TP-7L        2120 INTL 20050513)
Jan  9 17:47:45 rainbow kernel: [    0.000000] ACPI: DMI detected: Lenovo ThinkPad T61
Jan  9 17:47:45 rainbow kernel: [    0.000000] ACPI: Added _OSI(Linux)
Jan  9 17:47:45 rainbow kernel: [    0.000000] ACPI: Local APIC address 0xfee00000
Jan  9 17:47:45 rainbow kernel: [    0.000000] No NUMA configuration found
Jan  9 17:47:45 rainbow kernel: [    0.000000] Faking a node at 0000000000000000-000000013c000000
Jan  9 17:47:45 rainbow kernel: [    0.000000] Bootmem setup node 0 0000000000000000-000000013c000000
Jan  9 17:47:45 rainbow kernel: [    0.000000]   NODE_DATA [0000000000001000 - 0000000000005fff]
Jan  9 17:47:45 rainbow kernel: [    0.000000]   bootmap [000000000000c000 -  00000000000337ff] pages 28
Jan  9 17:47:45 rainbow kernel: [    0.000000] (7 early reservations) ==> bootmem [0000000000 - 013c000000]
Jan  9 17:47:45 rainbow kernel: [    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
Jan  9 17:47:45 rainbow kernel: [    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
Jan  9 17:47:45 rainbow kernel: [    0.000000]   #2 [0000200000 - 000090b73c]    TEXT DATA BSS ==> [0000200000 - 000090b73c]
Jan  9 17:47:45 rainbow kernel: [    0.000000]   #3 [0036a36000 - 0037fefbe8]          RAMDISK ==> [0036a36000 - 0037fefbe8]
Jan  9 17:47:45 rainbow kernel: [    0.000000]   #4 [000009d800 - 0000100000]    BIOS reserved ==> [000009d800 - 0000100000]
Jan  9 17:47:45 rainbow kernel: [    0.000000]   #5 [0000008000 - 000000b000]          PGTABLE ==> [0000008000 - 000000b000]
Jan  9 17:47:45 rainbow kernel: [    0.000000]   #6 [000000b000 - 000000c000]          PGTABLE ==> [000000b000 - 000000c000]
Jan  9 17:47:45 rainbow kernel: [    0.000000] found SMP MP-table at [ffff8800000f6900] 000f6900
Jan  9 17:47:45 rainbow kernel: [    0.000000]  [ffffe20000000000-ffffe200045fffff] PMD -> [ffff880028200000-ffff88002b9fffff] on node 0
Jan  9 17:47:45 rainbow kernel: [    0.000000] Zone PFN ranges:
Jan  9 17:47:45 rainbow kernel: [    0.000000]   DMA      0x00000000 -> 0x00001000
Jan  9 17:47:45 rainbow kernel: [    0.000000]   DMA32    0x00001000 -> 0x00100000
Jan  9 17:47:45 rainbow kernel: [    0.000000]   Normal   0x00100000 -> 0x0013c000
Jan  9 17:47:45 rainbow kernel: [    0.000000] Movable zone start PFN for each node
Jan  9 17:47:45 rainbow kernel: [    0.000000] early_node_map[3] active PFN ranges
Jan  9 17:47:45 rainbow kernel: [    0.000000]     0: 0x00000000 -> 0x0000009d
Jan  9 17:47:45 rainbow kernel: [    0.000000]     0: 0x00000100 -> 0x000bf6b0
Jan  9 17:47:45 rainbow kernel: [    0.000000]     0: 0x00100000 -> 0x0013c000
Jan  9 17:47:45 rainbow kernel: [    0.000000] On node 0 totalpages: 1029709
Jan  9 17:47:45 rainbow kernel: [    0.000000]   DMA zone: 56 pages used for memmap
Jan  9 17:47:45 rainbow kernel: [    0.000000]   DMA zone: 1910 pages reserved
Jan  9 17:47:45 rainbow kernel: [    0.000000]   DMA zone: 2031 pages, LIFO batch:0
Jan  9 17:47:45 rainbow kernel: [    0.000000]   DMA32 zone: 14280 pages used for memmap
Jan  9 17:47:45 rainbow kernel: [    0.000000]   DMA32 zone: 765672 pages, LIFO batch:31
Jan  9 17:47:45 rainbow kernel: [    0.000000]   Normal zone: 3360 pages used for memmap
Jan  9 17:47:45 rainbow kernel: [    0.000000]   Normal zone: 242400 pages, LIFO batch:31
Jan  9 17:47:45 rainbow kernel: [    0.000000]   Movable zone: 0 pages used for memmap
Jan  9 17:47:45 rainbow kernel: [    0.000000] ACPI: PM-Timer IO Port: 0x1008
Jan  9 17:47:45 rainbow kernel: [    0.000000] ACPI: Local APIC address 0xfee00000
Jan  9 17:47:45 rainbow kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Jan  9 17:47:45 rainbow kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Jan  9 17:47:45 rainbow kernel: [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
Jan  9 17:47:45 rainbow kernel: [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
Jan  9 17:47:45 rainbow kernel: [    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
Jan  9 17:47:45 rainbow kernel: [    0.000000] IOAPIC[0]: apic_id 1, version 0, address 0xfec00000, GSI 0-23
Jan  9 17:47:45 rainbow kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
Jan  9 17:47:45 rainbow kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Jan  9 17:47:45 rainbow kernel: [    0.000000] ACPI: IRQ0 used by override.
Jan  9 17:47:45 rainbow kernel: [    0.000000] ACPI: IRQ2 used by override.
Jan  9 17:47:45 rainbow kernel: [    0.000000] ACPI: IRQ9 used by override.
Jan  9 17:47:45 rainbow kernel: [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
Jan  9 17:47:45 rainbow kernel: [    0.000000] Using ACPI (MADT) for SMP configuration information
Jan  9 17:47:45 rainbow kernel: [    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
Jan  9 17:47:45 rainbow kernel: [    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
Jan  9 17:47:45 rainbow kernel: [    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
Jan  9 17:47:45 rainbow kernel: [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000d2000
Jan  9 17:47:45 rainbow kernel: [    0.000000] PM: Registered nosave memory: 00000000000d2000 - 00000000000d4000
Jan  9 17:47:45 rainbow kernel: [    0.000000] PM: Registered nosave memory: 00000000000d4000 - 00000000000e0000
Jan  9 17:47:45 rainbow kernel: [    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
Jan  9 17:47:45 rainbow kernel: [    0.000000] PM: Registered nosave memory: 00000000bf6b0000 - 00000000bf6cc000
Jan  9 17:47:45 rainbow kernel: [    0.000000] PM: Registered nosave memory: 00000000bf6cc000 - 00000000bf700000
Jan  9 17:47:45 rainbow kernel: [    0.000000] PM: Registered nosave memory: 00000000bf700000 - 00000000c0000000
Jan  9 17:47:45 rainbow kernel: [    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000f0000000
Jan  9 17:47:45 rainbow kernel: [    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000f4000000
Jan  9 17:47:45 rainbow kernel: [    0.000000] PM: Registered nosave memory: 00000000f4000000 - 00000000fec00000
Jan  9 17:47:45 rainbow kernel: [    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000
Jan  9 17:47:45 rainbow kernel: [    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fed00000
Jan  9 17:47:45 rainbow kernel: [    0.000000] PM: Registered nosave memory: 00000000fed00000 - 00000000fed14000
Jan  9 17:47:45 rainbow kernel: [    0.000000] PM: Registered nosave memory: 00000000fed14000 - 00000000fed1a000
Jan  9 17:47:45 rainbow kernel: [    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1c000
Jan  9 17:47:45 rainbow kernel: [    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed90000
Jan  9 17:47:45 rainbow kernel: [    0.000000] PM: Registered nosave memory: 00000000fed90000 - 00000000fee00000
Jan  9 17:47:45 rainbow kernel: [    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
Jan  9 17:47:45 rainbow kernel: [    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ff000000
Jan  9 17:47:45 rainbow kernel: [    0.000000] PM: Registered nosave memory: 00000000ff000000 - 0000000100000000
Jan  9 17:47:45 rainbow kernel: [    0.000000] Allocating PCI resources starting at c4000000 (gap: c0000000:30000000)
Jan  9 17:47:45 rainbow kernel: [    0.000000] PERCPU: Allocating 65536 bytes of per cpu data
Jan  9 17:47:45 rainbow kernel: [    0.000000] per cpu data for cpu0 on node0 at 0000000028022000
Jan  9 17:47:45 rainbow kernel: [    0.000000] per cpu data for cpu1 on node0 at 0000000028032000
Jan  9 17:47:45 rainbow kernel: [    0.000000] NR_CPUS: 64, nr_cpu_ids: 2, nr_node_ids 1
Jan  9 17:47:45 rainbow kernel: [    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1010103
Jan  9 17:47:45 rainbow kernel: [    0.000000] Policy zone: Normal
Jan  9 17:47:45 rainbow kernel: [    0.000000] Kernel command line: root=UUID=b49fa89a-8364-4ea0-b712-438b002b45c1 ro debug netconsole=@169.254.1.1/eth0,6666@169.254.5.142/00:0d:93:7b:d8:a0
Jan  9 17:47:45 rainbow kernel: [    0.000000] Initializing CPU#0
Jan  9 17:47:45 rainbow kernel: [    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
Jan  9 17:47:45 rainbow kernel: [    0.000000] Extended CMOS year: 2000
Jan  9 17:47:45 rainbow kernel: [    0.000000] Fast TSC calibration using PIT
Jan  9 17:47:45 rainbow kernel: [    0.000000] Detected 2194.498 MHz processor.
Jan  9 17:47:45 rainbow kernel: [    0.004000] Console: colour VGA+ 80x25
Jan  9 17:47:45 rainbow kernel: [    0.004000] console [tty0] enabled
Jan  9 17:47:45 rainbow kernel: [    0.004000] allocated 41943040 bytes of page_cgroup
Jan  9 17:47:45 rainbow kernel: [    0.004000] please try cgroup_disable=memory option if you don't want
Jan  9 17:47:45 rainbow kernel: [    0.004000] Checking aperture...
Jan  9 17:47:45 rainbow kernel: [    0.004000] No AGP bridge found
Jan  9 17:47:45 rainbow kernel: [    0.004000] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Jan  9 17:47:45 rainbow kernel: [    0.004000] Placing software IO TLB between 0x20000000 - 0x24000000
Jan  9 17:47:45 rainbow kernel: [    0.004000] Memory: 3924736k/5177344k available (3154k kernel code, 1058508k absent, 194100k reserved, 1766k data, 552k init)
Jan  9 17:47:45 rainbow kernel: [    0.004000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
Jan  9 17:47:45 rainbow kernel: [    0.004000] hpet clockevent registered
Jan  9 17:47:45 rainbow kernel: [    0.004000] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
Jan  9 17:47:45 rainbow kernel: [    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 4388.99 BogoMIPS (lpj=8777992)
Jan  9 17:47:45 rainbow kernel: [    0.004000] Security Framework initialized
Jan  9 17:47:45 rainbow kernel: [    0.004000] SELinux:  Disabled at boot.
Jan  9 17:47:45 rainbow kernel: [    0.004000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Jan  9 17:47:45 rainbow kernel: [    0.004000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Jan  9 17:47:45 rainbow kernel: [    0.004789] Mount-cache hash table entries: 256
Jan  9 17:47:45 rainbow kernel: [    0.005004] Initializing cgroup subsys ns
Jan  9 17:47:45 rainbow kernel: [    0.005056] Initializing cgroup subsys cpuacct
Jan  9 17:47:45 rainbow kernel: [    0.005104] Initializing cgroup subsys memory
Jan  9 17:47:45 rainbow kernel: [    0.005155] Initializing cgroup subsys freezer
Jan  9 17:47:45 rainbow kernel: [    0.005221] CPU: L1 I cache: 32K, L1 D cache: 32K
Jan  9 17:47:45 rainbow kernel: [    0.005918] CPU: L2 cache: 4096K
Jan  9 17:47:45 rainbow kernel: [    0.005969] CPU 0/0x0 -> Node 0
Jan  9 17:47:45 rainbow kernel: [    0.006017] CPU: Physical Processor ID: 0
Jan  9 17:47:45 rainbow kernel: [    0.006071] CPU: Processor Core ID: 0
Jan  9 17:47:45 rainbow kernel: [    0.006125] CPU0: Thermal monitoring enabled (TM2)
Jan  9 17:47:45 rainbow kernel: [    0.006178] using mwait in idle threads.
Jan  9 17:47:45 rainbow kernel: [    0.007932] ACPI: Core revision 20080926
Jan  9 17:47:45 rainbow kernel: [    0.032055] Setting APIC routing to flat
Jan  9 17:47:45 rainbow kernel: [    0.032601] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
Jan  9 17:47:45 rainbow kernel: [    0.075234] CPU0: Intel(R) Core(TM)2 Duo CPU     T7500  @ 2.20GHz stepping 0b
Jan  9 17:47:45 rainbow kernel: [    0.076001] Booting processor 1 APIC 0x1 ip 0x6000
Jan  9 17:47:45 rainbow kernel: [    0.004000] Initializing CPU#1
Jan  9 17:47:45 rainbow kernel: [    0.004000] Calibrating delay using timer specific routine.. 4388.95 BogoMIPS (lpj=8777911)
Jan  9 17:47:45 rainbow kernel: [    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
Jan  9 17:47:45 rainbow kernel: [    0.004000] CPU: L2 cache: 4096K
Jan  9 17:47:45 rainbow kernel: [    0.004000] CPU 1/0x1 -> Node 0
Jan  9 17:47:45 rainbow kernel: [    0.004000] CPU: Physical Processor ID: 0
Jan  9 17:47:45 rainbow kernel: [    0.004000] CPU: Processor Core ID: 1
Jan  9 17:47:45 rainbow kernel: [    0.004000] CPU1: Thermal monitoring enabled (TM2)
Jan  9 17:47:45 rainbow kernel: [    0.160598] CPU1: Intel(R) Core(TM)2 Duo CPU     T7500  @ 2.20GHz stepping 0b
Jan  9 17:47:45 rainbow kernel: [    0.161265] checking TSC synchronization [CPU#0 -> CPU#1]:
Jan  9 17:47:45 rainbow kernel: [    0.164001] Measured 359117 cycles TSC warp between CPUs, turning off TSC clock.
Jan  9 17:47:45 rainbow kernel: [    0.164001] Marking TSC unstable due to check_tsc_sync_source failed
Jan  9 17:47:45 rainbow kernel: [    0.164039] Brought up 2 CPUs
Jan  9 17:47:45 rainbow kernel: [    0.164102] Total of 2 processors activated (8777.95 BogoMIPS).
Jan  9 17:47:45 rainbow kernel: [    0.164224] CPU0 attaching sched-domain:
Jan  9 17:47:45 rainbow kernel: [    0.164286]  domain 0: span 0-1 level MC
Jan  9 17:47:45 rainbow kernel: [    0.164392]   groups: 0 1
Jan  9 17:47:45 rainbow kernel: [    0.164588]   domain 1: span 0-1 level NODE
Jan  9 17:47:45 rainbow kernel: [    0.164695]    groups: 0-1
Jan  9 17:47:45 rainbow kernel: [    0.164846] CPU1 attaching sched-domain:
Jan  9 17:47:45 rainbow kernel: [    0.164905]  domain 0: span 0-1 level MC
Jan  9 17:47:45 rainbow kernel: [    0.165015]   groups: 1 0
Jan  9 17:47:45 rainbow kernel: [    0.165212]   domain 1: span 0-1 level NODE
Jan  9 17:47:45 rainbow kernel: [    0.165319]    groups: 0-1
Jan  9 17:47:45 rainbow kernel: [    0.165540] net_namespace: 1400 bytes
Jan  9 17:47:45 rainbow kernel: [    0.165540] Booting paravirtualized kernel on bare hardware
Jan  9 17:47:45 rainbow kernel: [    0.165540] Time: 22:47:22  Date: 01/09/09
Jan  9 17:47:45 rainbow kernel: [    0.165540] NET: Registered protocol family 16
Jan  9 17:47:45 rainbow kernel: [    0.168018] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
Jan  9 17:47:45 rainbow kernel: [    0.168093] ACPI: bus type pci registered
Jan  9 17:47:45 rainbow kernel: [    0.168159] PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 63
Jan  9 17:47:45 rainbow kernel: [    0.168159] PCI: MCFG area at f0000000 reserved in E820
Jan  9 17:47:45 rainbow kernel: [    0.170567] PCI: Using MMCONFIG at f0000000 - f3ffffff
Jan  9 17:47:45 rainbow kernel: [    0.170631] PCI: Using configuration type 1 for base access
Jan  9 17:47:45 rainbow kernel: [    0.173322] ACPI: EC: EC description table is found, configuring boot EC
Jan  9 17:47:45 rainbow kernel: [    0.180522] ACPI: BIOS _OSI(Linux) query honored via DMI
Jan  9 17:47:45 rainbow kernel: [    0.180022] ACPI: EC: non-query interrupt received, switching to interrupt mode
Jan  9 17:47:45 rainbow kernel: [    0.194213] ACPI: Interpreter enabled
Jan  9 17:47:45 rainbow kernel: [    0.194275] ACPI: (supports S0 S3 S4 S5)
Jan  9 17:47:45 rainbow kernel: [    0.194538] ACPI: Using IOAPIC for interrupt routing
Jan  9 17:47:45 rainbow kernel: [    0.213028] ACPI: EC: GPE = 0x12, I/O: command/status = 0x66, data = 0x62
Jan  9 17:47:45 rainbow kernel: [    0.213095] ACPI: EC: driver started in interrupt mode
Jan  9 17:47:45 rainbow kernel: [    0.213431] ACPI: ACPI Dock Station Driver: 3 docks/bays found
Jan  9 17:47:45 rainbow kernel: [    0.213505] ACPI: PCI Root Bridge [PCI0] (0000:00)
Jan  9 17:47:45 rainbow kernel: [    0.216064] pci 0000:00:02.0: reg 10 64bit mmio: [0xf8100000-0xf81fffff]
Jan  9 17:47:45 rainbow kernel: [    0.216134] pci 0000:00:02.0: reg 18 64bit mmio: [0xe0000000-0xefffffff]
Jan  9 17:47:45 rainbow kernel: [    0.216203] pci 0000:00:02.0: reg 20 io port: [0x1800-0x1807]
Jan  9 17:47:45 rainbow kernel: [    0.216294] pci 0000:00:02.1: reg 10 64bit mmio: [0xf8200000-0xf82fffff]
Jan  9 17:47:45 rainbow kernel: [    0.216535] pci 0000:00:19.0: reg 10 32bit mmio: [0xfe000000-0xfe01ffff]
Jan  9 17:47:45 rainbow kernel: [    0.216610] pci 0000:00:19.0: reg 14 32bit mmio: [0xfe025000-0xfe025fff]
Jan  9 17:47:45 rainbow kernel: [    0.216679] pci 0000:00:19.0: reg 18 io port: [0x1840-0x185f]
Jan  9 17:47:45 rainbow kernel: [    0.216679] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
Jan  9 17:47:45 rainbow kernel: [    0.216679] pci 0000:00:19.0: PME# disabled
Jan  9 17:47:45 rainbow kernel: [    0.216679] pci 0000:00:1a.0: reg 20 io port: [0x1860-0x187f]
Jan  9 17:47:45 rainbow kernel: [    0.216679] pci 0000:00:1a.1: reg 20 io port: [0x1880-0x189f]
Jan  9 17:47:45 rainbow kernel: [    0.216731] pci 0000:00:1a.7: reg 10 32bit mmio: [0xfe226c00-0xfe226fff]
Jan  9 17:47:45 rainbow kernel: [    0.216864] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
Jan  9 17:47:45 rainbow kernel: [    0.216933] pci 0000:00:1a.7: PME# disabled
Jan  9 17:47:45 rainbow kernel: [    0.217091] pci 0000:00:1b.0: reg 10 64bit mmio: [0xfe020000-0xfe023fff]
Jan  9 17:47:45 rainbow kernel: [    0.217226] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
Jan  9 17:47:45 rainbow kernel: [    0.217297] pci 0000:00:1b.0: PME# disabled
Jan  9 17:47:45 rainbow kernel: [    0.217473] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
Jan  9 17:47:45 rainbow kernel: [    0.217542] pci 0000:00:1c.0: PME# disabled
Jan  9 17:47:45 rainbow kernel: [    0.217715] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
Jan  9 17:47:45 rainbow kernel: [    0.217784] pci 0000:00:1c.1: PME# disabled
Jan  9 17:47:45 rainbow kernel: [    0.217950] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
Jan  9 17:47:45 rainbow kernel: [    0.218019] pci 0000:00:1c.2: PME# disabled
Jan  9 17:47:45 rainbow kernel: [    0.218191] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
Jan  9 17:47:45 rainbow kernel: [    0.218261] pci 0000:00:1c.3: PME# disabled
Jan  9 17:47:45 rainbow kernel: [    0.218425] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
Jan  9 17:47:45 rainbow kernel: [    0.218495] pci 0000:00:1c.4: PME# disabled
Jan  9 17:47:45 rainbow kernel: [    0.218671] pci 0000:00:1d.0: reg 20 io port: [0x18a0-0x18bf]
Jan  9 17:47:45 rainbow kernel: [    0.218857] pci 0000:00:1d.1: reg 20 io port: [0x18c0-0x18df]
Jan  9 17:47:45 rainbow kernel: [    0.219036] pci 0000:00:1d.2: reg 20 io port: [0x18e0-0x18ff]
Jan  9 17:47:45 rainbow kernel: [    0.219225] pci 0000:00:1d.7: reg 10 32bit mmio: [0xfe227000-0xfe2273ff]
Jan  9 17:47:45 rainbow kernel: [    0.219356] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
Jan  9 17:47:45 rainbow kernel: [    0.219423] pci 0000:00:1d.7: PME# disabled
Jan  9 17:47:45 rainbow kernel: [    0.219749] pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
Jan  9 17:47:45 rainbow kernel: [    0.219828] pci 0000:00:1f.0: quirk: region 1180-11bf claimed by ICH6 GPIO
Jan  9 17:47:45 rainbow kernel: [    0.219960] pci 0000:00:1f.1: reg 10 io port: [0x00-0x07]
Jan  9 17:47:45 rainbow kernel: [    0.220015] pci 0000:00:1f.1: reg 14 io port: [0x00-0x03]
Jan  9 17:47:45 rainbow kernel: [    0.220090] pci 0000:00:1f.1: reg 18 io port: [0x00-0x07]
Jan  9 17:47:45 rainbow kernel: [    0.220164] pci 0000:00:1f.1: reg 1c io port: [0x00-0x03]
Jan  9 17:47:45 rainbow kernel: [    0.220240] pci 0000:00:1f.1: reg 20 io port: [0x1c00-0x1c0f]
Jan  9 17:47:45 rainbow kernel: [    0.220406] pci 0000:00:1f.2: reg 10 io port: [0x1c50-0x1c57]
Jan  9 17:47:45 rainbow kernel: [    0.220481] pci 0000:00:1f.2: reg 14 io port: [0x1c44-0x1c47]
Jan  9 17:47:45 rainbow kernel: [    0.220553] pci 0000:00:1f.2: reg 18 io port: [0x1c48-0x1c4f]
Jan  9 17:47:45 rainbow kernel: [    0.220626] pci 0000:00:1f.2: reg 1c io port: [0x1c40-0x1c43]
Jan  9 17:47:45 rainbow kernel: [    0.220699] pci 0000:00:1f.2: reg 20 io port: [0x1c20-0x1c3f]
Jan  9 17:47:45 rainbow kernel: [    0.220772] pci 0000:00:1f.2: reg 24 32bit mmio: [0xfe226000-0xfe2267ff]
Jan  9 17:47:45 rainbow kernel: [    0.220860] pci 0000:00:1f.2: PME# supported from D3hot
Jan  9 17:47:45 rainbow kernel: [    0.220930] pci 0000:00:1f.2: PME# disabled
Jan  9 17:47:45 rainbow kernel: [    0.221050] pci 0000:00:1f.3: reg 10 32bit mmio: [0xfe227400-0xfe2274ff]
Jan  9 17:47:45 rainbow kernel: [    0.221150] pci 0000:00:1f.3: reg 20 io port: [0x1c60-0x1c7f]
Jan  9 17:47:45 rainbow kernel: [    0.221359] pci 0000:00:1c.0: bridge io port: [0x2000-0x2fff]
Jan  9 17:47:45 rainbow kernel: [    0.221428] pci 0000:00:1c.0: bridge 32bit mmio: [0xfc000000-0xfdffffff]
Jan  9 17:47:45 rainbow kernel: [    0.221503] pci 0000:00:1c.0: bridge 64bit mmio pref: [0xf8000000-0xf80fffff]
Jan  9 17:47:45 rainbow kernel: [    0.221757] pci 0000:03:00.0: reg 10 32bit mmio: [0xdf3ff000-0xdf3fffff]
Jan  9 17:47:45 rainbow kernel: [    0.221973] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
Jan  9 17:47:45 rainbow kernel: [    0.222036] pci 0000:03:00.0: PME# disabled
Jan  9 17:47:45 rainbow kernel: [    0.222188] pci 0000:00:1c.1: bridge io port: [0x3000-0x3fff]
Jan  9 17:47:45 rainbow kernel: [    0.222253] pci 0000:00:1c.1: bridge 32bit mmio: [0xdc000000-0xdf3fffff]
Jan  9 17:47:45 rainbow kernel: [    0.222325] pci 0000:00:1c.1: bridge 64bit mmio pref: [0xdfe00000-0xdfefffff]
Jan  9 17:47:45 rainbow kernel: [    0.222505] pci 0000:00:1c.2: bridge io port: [0x4000-0x4fff]
Jan  9 17:47:45 rainbow kernel: [    0.222575] pci 0000:00:1c.2: bridge 32bit mmio: [0xd8000000-0xd9ffffff]
Jan  9 17:47:45 rainbow kernel: [    0.222650] pci 0000:00:1c.2: bridge 64bit mmio pref: [0xdfb00000-0xdfbfffff]
Jan  9 17:47:45 rainbow kernel: [    0.222839] pci 0000:00:1c.3: bridge io port: [0x5000-0x5fff]
Jan  9 17:47:45 rainbow kernel: [    0.222909] pci 0000:00:1c.3: bridge 32bit mmio: [0xd4000000-0xd5ffffff]
Jan  9 17:47:45 rainbow kernel: [    0.222984] pci 0000:00:1c.3: bridge 64bit mmio pref: [0xdf800000-0xdf8fffff]
Jan  9 17:47:45 rainbow kernel: [    0.223162] pci 0000:00:1c.4: bridge io port: [0x6000-0x6fff]
Jan  9 17:47:45 rainbow kernel: [    0.223232] pci 0000:00:1c.4: bridge 32bit mmio: [0xd0000000-0xd1ffffff]
Jan  9 17:47:45 rainbow kernel: [    0.223307] pci 0000:00:1c.4: bridge 64bit mmio pref: [0xdf500000-0xdf5fffff]
Jan  9 17:47:45 rainbow kernel: [    0.223453] pci 0000:15:00.0: reg 10 32bit mmio: [0xf8300000-0xf8300fff]
Jan  9 17:47:45 rainbow kernel: [    0.223539] pci 0000:15:00.0: supports D1 D2
Jan  9 17:47:45 rainbow kernel: [    0.223599] pci 0000:15:00.0: PME# supported from D0 D1 D2 D3hot D3cold
Jan  9 17:47:45 rainbow kernel: [    0.223672] pci 0000:15:00.0: PME# disabled
Jan  9 17:47:45 rainbow kernel: [    0.223822] pci 0000:15:00.1: reg 10 32bit mmio: [0xf8301000-0xf83017ff]
Jan  9 17:47:45 rainbow kernel: [    0.224012] pci 0000:15:00.1: supports D1 D2
Jan  9 17:47:45 rainbow kernel: [    0.224073] pci 0000:15:00.1: PME# supported from D0 D1 D2 D3hot D3cold
Jan  9 17:47:45 rainbow kernel: [    0.224147] pci 0000:15:00.1: PME# disabled
Jan  9 17:47:45 rainbow kernel: [    0.224320] pci 0000:00:1e.0: transparent bridge
Jan  9 17:47:45 rainbow kernel: [    0.224385] pci 0000:00:1e.0: bridge io port: [0x7000-0xafff]
Jan  9 17:47:45 rainbow kernel: [    0.224454] pci 0000:00:1e.0: bridge 32bit mmio: [0xf8300000-0xfbffffff]
Jan  9 17:47:45 rainbow kernel: [    0.224527] pci 0000:00:1e.0: bridge 64bit mmio pref: [0xf4000000-0xf7ffffff]
Jan  9 17:47:45 rainbow kernel: [    0.224692] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
Jan  9 17:47:45 rainbow kernel: [    0.225019] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
Jan  9 17:47:45 rainbow kernel: [    0.225222] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
Jan  9 17:47:45 rainbow kernel: [    0.225426] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
Jan  9 17:47:45 rainbow kernel: [    0.225629] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
Jan  9 17:47:45 rainbow kernel: [    0.225835] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP4._PRT]
Jan  9 17:47:45 rainbow kernel: [    0.226042] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
Jan  9 17:47:45 rainbow kernel: [    0.228169] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 *10 11)
Jan  9 17:47:45 rainbow kernel: [    0.228915] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
Jan  9 17:47:45 rainbow kernel: [    0.229665] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
Jan  9 17:47:45 rainbow kernel: [    0.232658] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
Jan  9 17:47:45 rainbow kernel: [    0.233393] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
Jan  9 17:47:45 rainbow kernel: [    0.234134] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
Jan  9 17:47:45 rainbow kernel: [    0.234873] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
Jan  9 17:47:45 rainbow kernel: [    0.235612] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
Jan  9 17:47:45 rainbow kernel: [    0.236245] ACPI: Power Resource [PUBS] (on)
Jan  9 17:47:45 rainbow kernel: [    0.236245] PCI: Using ACPI for IRQ routing
Jan  9 17:47:45 rainbow kernel: [    0.252044] NET: Registered protocol family 8
Jan  9 17:47:45 rainbow kernel: [    0.252107] NET: Registered protocol family 20
Jan  9 17:47:45 rainbow kernel: [    0.252181] NetLabel: Initializing
Jan  9 17:47:45 rainbow kernel: [    0.252181] NetLabel:  domain hash size = 128
Jan  9 17:47:45 rainbow kernel: [    0.252181] NetLabel:  protocols = UNLABELED CIPSOv4
Jan  9 17:47:45 rainbow kernel: [    0.252203] NetLabel:  unlabeled traffic allowed by default
Jan  9 17:47:45 rainbow kernel: [    0.252359] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
Jan  9 17:47:45 rainbow kernel: [    0.252608] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
Jan  9 17:47:45 rainbow kernel: [    0.260013] Switched to high resolution mode on CPU 0
Jan  9 17:47:45 rainbow kernel: [    0.261550] Switched to high resolution mode on CPU 1
Jan  9 17:47:45 rainbow kernel: [    0.272018] pnp: PnP ACPI init
Jan  9 17:47:45 rainbow kernel: [    0.272082] ACPI: bus type pnp registered
Jan  9 17:47:45 rainbow kernel: [    0.278141] pnp: PnP ACPI: found 11 devices
Jan  9 17:47:45 rainbow kernel: [    0.278203] ACPI: ACPI bus type pnp unregistered
Jan  9 17:47:45 rainbow kernel: [    0.278268] system 00:00: iomem range 0x0-0x9ffff could not be reserved
Jan  9 17:47:45 rainbow kernel: [    0.278331] system 00:00: iomem range 0xc0000-0xc3fff has been reserved
Jan  9 17:47:45 rainbow kernel: [    0.278396] system 00:00: iomem range 0xc4000-0xc7fff has been reserved
Jan  9 17:47:45 rainbow kernel: [    0.278458] system 00:00: iomem range 0xc8000-0xcbfff has been reserved
Jan  9 17:47:45 rainbow kernel: [    0.278525] system 00:00: iomem range 0xcc000-0xcffff has been reserved
Jan  9 17:47:45 rainbow kernel: [    0.278588] system 00:00: iomem range 0xd0000-0xd3fff could not be reserved
Jan  9 17:47:45 rainbow kernel: [    0.278655] system 00:00: iomem range 0xe0000-0xe3fff could not be reserved
Jan  9 17:47:45 rainbow kernel: [    0.278722] system 00:00: iomem range 0xe4000-0xe7fff could not be reserved
Jan  9 17:47:45 rainbow kernel: [    0.278787] system 00:00: iomem range 0xe8000-0xebfff could not be reserved
Jan  9 17:47:45 rainbow kernel: [    0.279445] system 00:00: iomem range 0xec000-0xeffff could not be reserved
Jan  9 17:47:45 rainbow kernel: [    0.279509] system 00:00: iomem range 0xf0000-0xfffff could not be reserved
Jan  9 17:47:45 rainbow kernel: [    0.279572] system 00:00: iomem range 0x100000-0xbfffffff could not be reserved
Jan  9 17:47:45 rainbow kernel: [    0.279647] system 00:00: iomem range 0xfec00000-0xfed3ffff could not be reserved
Jan  9 17:47:45 rainbow kernel: [    0.279723] system 00:00: iomem range 0xfed4c000-0xffffffff could not be reserved
Jan  9 17:47:45 rainbow kernel: [    0.279804] system 00:02: ioport range 0x164e-0x164f has been reserved
Jan  9 17:47:45 rainbow kernel: [    0.279867] system 00:02: ioport range 0x1000-0x107f has been reserved
Jan  9 17:47:45 rainbow kernel: [    0.279933] system 00:02: ioport range 0x1180-0x11bf has been reserved
Jan  9 17:47:45 rainbow kernel: [    0.279998] system 00:02: ioport range 0x800-0x80f has been reserved
Jan  9 17:47:45 rainbow kernel: [    0.280065] system 00:02: ioport range 0x15e0-0x15ef has been reserved
Jan  9 17:47:45 rainbow kernel: [    0.280130] system 00:02: ioport range 0x1600-0x165f could not be reserved
Jan  9 17:47:45 rainbow kernel: [    0.280195] system 00:02: iomem range 0xf0000000-0xf3ffffff has been reserved
Jan  9 17:47:45 rainbow kernel: [    0.280260] system 00:02: iomem range 0xfed1c000-0xfed1ffff has been reserved
Jan  9 17:47:45 rainbow kernel: [    0.280324] system 00:02: iomem range 0xfed14000-0xfed17fff has been reserved
Jan  9 17:47:45 rainbow kernel: [    0.280393] system 00:02: iomem range 0xfed18000-0xfed18fff has been reserved
Jan  9 17:47:45 rainbow kernel: [    0.280459] system 00:02: iomem range 0xfed19000-0xfed19fff has been reserved
Jan  9 17:47:45 rainbow kernel: [    0.280524] system 00:02: iomem range 0xfed45000-0xfed4bfff has been reserved
Jan  9 17:47:45 rainbow kernel: [    0.285764] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
Jan  9 17:47:45 rainbow kernel: [    0.285831] pci 0000:00:1c.0:   IO window: 0x2000-0x2fff
Jan  9 17:47:45 rainbow kernel: [    0.285903] pci 0000:00:1c.0:   MEM window: 0xfc000000-0xfdffffff
Jan  9 17:47:45 rainbow kernel: [    0.285974] pci 0000:00:1c.0:   PREFETCH window: 0x000000f8000000-0x000000f80fffff
Jan  9 17:47:45 rainbow kernel: [    0.286055] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
Jan  9 17:47:45 rainbow kernel: [    0.286122] pci 0000:00:1c.1:   IO window: 0x3000-0x3fff
Jan  9 17:47:45 rainbow kernel: [    0.286196] pci 0000:00:1c.1:   MEM window: 0xdc000000-0xdf3fffff
Jan  9 17:47:45 rainbow kernel: [    0.286265] pci 0000:00:1c.1:   PREFETCH window: 0x000000dfe00000-0x000000dfefffff
Jan  9 17:47:45 rainbow kernel: [    0.286346] pci 0000:00:1c.2: PCI bridge, secondary bus 0000:04
Jan  9 17:47:45 rainbow kernel: [    0.286415] pci 0000:00:1c.2:   IO window: 0x4000-0x4fff
Jan  9 17:47:45 rainbow kernel: [    0.286484] pci 0000:00:1c.2:   MEM window: 0xd8000000-0xd9ffffff
Jan  9 17:47:45 rainbow kernel: [    0.286555] pci 0000:00:1c.2:   PREFETCH window: 0x000000dfb00000-0x000000dfbfffff
Jan  9 17:47:45 rainbow kernel: [    0.286637] pci 0000:00:1c.3: PCI bridge, secondary bus 0000:05
Jan  9 17:47:45 rainbow kernel: [    0.286704] pci 0000:00:1c.3:   IO window: 0x5000-0x5fff
Jan  9 17:47:45 rainbow kernel: [    0.286775] pci 0000:00:1c.3:   MEM window: 0xd4000000-0xd5ffffff
Jan  9 17:47:45 rainbow kernel: [    0.286848] pci 0000:00:1c.3:   PREFETCH window: 0x000000df800000-0x000000df8fffff
Jan  9 17:47:45 rainbow kernel: [    0.286933] pci 0000:00:1c.4: PCI bridge, secondary bus 0000:0d
Jan  9 17:47:45 rainbow kernel: [    0.286999] pci 0000:00:1c.4:   IO window: 0x6000-0x6fff
Jan  9 17:47:45 rainbow kernel: [    0.287067] pci 0000:00:1c.4:   MEM window: 0xd0000000-0xd1ffffff
Jan  9 17:47:45 rainbow kernel: [    0.287138] pci 0000:00:1c.4:   PREFETCH window: 0x000000df500000-0x000000df5fffff
Jan  9 17:47:45 rainbow kernel: [    0.287228] pci 0000:15:00.0: CardBus bridge, secondary bus 0000:16
Jan  9 17:47:45 rainbow kernel: [    0.287294] pci 0000:15:00.0:   IO window: 0x007000-0x0070ff
Jan  9 17:47:45 rainbow kernel: [    0.287362] pci 0000:15:00.0:   IO window: 0x007400-0x0074ff
Jan  9 17:47:45 rainbow kernel: [    0.287435] pci 0000:15:00.0:   PREFETCH window: 0xf4000000-0xf7ffffff
Jan  9 17:47:45 rainbow kernel: [    0.287505] pci 0000:15:00.0:   MEM window: 0xc4000000-0xc7ffffff
Jan  9 17:47:45 rainbow kernel: [    0.287574] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:15
Jan  9 17:47:45 rainbow kernel: [    0.287642] pci 0000:00:1e.0:   IO window: 0x7000-0xafff
Jan  9 17:47:45 rainbow kernel: [    0.287712] pci 0000:00:1e.0:   MEM window: 0xf8300000-0xfbffffff
Jan  9 17:47:45 rainbow kernel: [    0.287785] pci 0000:00:1e.0:   PREFETCH window: 0x000000f4000000-0x000000f7ffffff
Jan  9 17:47:45 rainbow kernel: [    0.287884] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
Jan  9 17:47:45 rainbow kernel: [    0.287957] pci 0000:00:1c.0: setting latency timer to 64
Jan  9 17:47:45 rainbow kernel: [    0.288047] pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
Jan  9 17:47:45 rainbow kernel: [    0.288115] pci 0000:00:1c.1: setting latency timer to 64
Jan  9 17:47:45 rainbow kernel: [    0.288192] pci 0000:00:1c.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
Jan  9 17:47:45 rainbow kernel: [    0.288264] pci 0000:00:1c.2: setting latency timer to 64
Jan  9 17:47:45 rainbow kernel: [    0.288345] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
Jan  9 17:47:45 rainbow kernel: [    0.288413] pci 0000:00:1c.3: setting latency timer to 64
Jan  9 17:47:45 rainbow kernel: [    0.288489] pci 0000:00:1c.4: PCI INT A -> GSI 20 (level, low) -> IRQ 20
Jan  9 17:47:45 rainbow kernel: [    0.288563] pci 0000:00:1c.4: setting latency timer to 64
Jan  9 17:47:45 rainbow kernel: [    0.288635] pci 0000:00:1e.0: enabling device (0005 -> 0007)
Jan  9 17:47:45 rainbow kernel: [    0.288709] pci 0000:00:1e.0: setting latency timer to 64
Jan  9 17:47:45 rainbow kernel: [    0.288789] pci 0000:15:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Jan  9 17:47:45 rainbow kernel: [    0.288857] pci 0000:15:00.0: setting latency timer to 64
Jan  9 17:47:45 rainbow kernel: [    0.288924] bus: 00 index 0 io port: [0x00-0xffff]
Jan  9 17:47:45 rainbow kernel: [    0.288987] bus: 00 index 1 mmio: [0x000000-0xffffffffffffffff]
Jan  9 17:47:45 rainbow kernel: [    0.289072] bus: 02 index 0 io port: [0x2000-0x2fff]
Jan  9 17:47:45 rainbow kernel: [    0.289135] bus: 02 index 1 mmio: [0xfc000000-0xfdffffff]
Jan  9 17:47:45 rainbow kernel: [    0.289199] bus: 02 index 2 mmio: [0xf8000000-0xf80fffff]
Jan  9 17:47:45 rainbow kernel: [    0.289264] bus: 02 index 3 mmio: [0x0-0x0]
Jan  9 17:47:45 rainbow kernel: [    0.289327] bus: 03 index 0 io port: [0x3000-0x3fff]
Jan  9 17:47:45 rainbow kernel: [    0.289393] bus: 03 index 1 mmio: [0xdc000000-0xdf3fffff]
Jan  9 17:47:45 rainbow kernel: [    0.289455] bus: 03 index 2 mmio: [0xdfe00000-0xdfefffff]
Jan  9 17:47:45 rainbow kernel: [    0.289518] bus: 03 index 3 mmio: [0x0-0x0]
Jan  9 17:47:45 rainbow kernel: [    0.289580] bus: 04 index 0 io port: [0x4000-0x4fff]
Jan  9 17:47:45 rainbow kernel: [    0.289645] bus: 04 index 1 mmio: [0xd8000000-0xd9ffffff]
Jan  9 17:47:45 rainbow kernel: [    0.289706] bus: 04 index 2 mmio: [0xdfb00000-0xdfbfffff]
Jan  9 17:47:45 rainbow kernel: [    0.289771] bus: 04 index 3 mmio: [0x0-0x0]
Jan  9 17:47:45 rainbow kernel: [    0.289834] bus: 05 index 0 io port: [0x5000-0x5fff]
Jan  9 17:47:45 rainbow kernel: [    0.289896] bus: 05 index 1 mmio: [0xd4000000-0xd5ffffff]
Jan  9 17:47:45 rainbow kernel: [    0.289959] bus: 05 index 2 mmio: [0xdf800000-0xdf8fffff]
Jan  9 17:47:45 rainbow kernel: [    0.290021] bus: 05 index 3 mmio: [0x0-0x0]
Jan  9 17:47:45 rainbow kernel: [    0.290084] bus: 0d index 0 io port: [0x6000-0x6fff]
Jan  9 17:47:45 rainbow kernel: [    0.290147] bus: 0d index 1 mmio: [0xd0000000-0xd1ffffff]
Jan  9 17:47:45 rainbow kernel: [    0.290208] bus: 0d index 2 mmio: [0xdf500000-0xdf5fffff]
Jan  9 17:47:45 rainbow kernel: [    0.290272] bus: 0d index 3 mmio: [0x0-0x0]
Jan  9 17:47:45 rainbow kernel: [    0.290335] bus: 15 index 0 io port: [0x7000-0xafff]
Jan  9 17:47:45 rainbow kernel: [    0.290397] bus: 15 index 1 mmio: [0xf8300000-0xfbffffff]
Jan  9 17:47:45 rainbow kernel: [    0.290460] bus: 15 index 2 mmio: [0xf4000000-0xf7ffffff]
Jan  9 17:47:45 rainbow kernel: [    0.290523] bus: 15 index 3 io port: [0x00-0xffff]
Jan  9 17:47:45 rainbow kernel: [    0.290587] bus: 15 index 4 mmio: [0x000000-0xffffffffffffffff]
Jan  9 17:47:45 rainbow kernel: [    0.290652] bus: 16 index 0 io port: [0x7000-0x70ff]
Jan  9 17:47:45 rainbow kernel: [    0.290713] bus: 16 index 1 io port: [0x7400-0x74ff]
Jan  9 17:47:45 rainbow kernel: [    0.290777] bus: 16 index 2 mmio: [0xf4000000-0xf7ffffff]
Jan  9 17:47:45 rainbow kernel: [    0.290841] bus: 16 index 3 mmio: [0xc4000000-0xc7ffffff]
Jan  9 17:47:45 rainbow kernel: [    0.290914] NET: Registered protocol family 2
Jan  9 17:47:45 rainbow kernel: [    0.329139] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
Jan  9 17:47:45 rainbow kernel: [    0.330323] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
Jan  9 17:47:45 rainbow kernel: [    0.334999] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
Jan  9 17:47:45 rainbow kernel: [    0.335739] TCP: Hash tables configured (established 524288 bind 65536)
Jan  9 17:47:45 rainbow kernel: [    0.335805] TCP reno registered
Jan  9 17:47:45 rainbow kernel: [    0.345109] NET: Registered protocol family 1
Jan  9 17:47:45 rainbow kernel: [    0.345280] checking if image is initramfs... it is
Jan  9 17:47:45 rainbow kernel: [    2.347063] Freeing initrd memory: 22246k freed
Jan  9 17:47:45 rainbow kernel: [    2.360576] Simple Boot Flag at 0x35 set to 0x1
Jan  9 17:47:45 rainbow kernel: [    2.361818] audit: initializing netlink socket (disabled)
Jan  9 17:47:45 rainbow kernel: [    2.361896] type=2000 audit(1231541244.360:1): initialized
Jan  9 17:47:45 rainbow kernel: [    2.367796] HugeTLB registered 2 MB page size, pre-allocated 0 pages
Jan  9 17:47:45 rainbow kernel: [    2.370406] VFS: Disk quotas dquot_6.5.1
Jan  9 17:47:45 rainbow kernel: [    2.370549] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Jan  9 17:47:45 rainbow kernel: [    2.370780] msgmni has been set to 7708
Jan  9 17:47:45 rainbow kernel: [    2.371033] alg: No test for stdrng (krng)
Jan  9 17:47:45 rainbow kernel: [    2.371106] io scheduler noop registered
Jan  9 17:47:45 rainbow kernel: [    2.371166] io scheduler anticipatory registered
Jan  9 17:47:45 rainbow kernel: [    2.371230] io scheduler deadline registered
Jan  9 17:47:45 rainbow kernel: [    2.371404] io scheduler cfq registered (default)
Jan  9 17:47:45 rainbow kernel: [    2.371477] pci 0000:00:02.0: Boot video device
Jan  9 17:47:45 rainbow kernel: [    2.381862] pcieport-driver 0000:00:1c.0: setting latency timer to 64
Jan  9 17:47:45 rainbow kernel: [    2.382015] pcieport-driver 0000:00:1c.0: found MSI capability
Jan  9 17:47:45 rainbow kernel: [    2.382133] pcieport-driver 0000:00:1c.0: irq 2303 for MSI/MSI-X
Jan  9 17:47:45 rainbow kernel: [    2.382219] pci_express 0000:00:1c.0:pcie00: allocate port service
Jan  9 17:47:45 rainbow kernel: [    2.382328] pci_express 0000:00:1c.0:pcie02: allocate port service
Jan  9 17:47:45 rainbow kernel: [    2.382429] pci_express 0000:00:1c.0:pcie03: allocate port service
Jan  9 17:47:45 rainbow kernel: [    2.382635] pcieport-driver 0000:00:1c.1: setting latency timer to 64
Jan  9 17:47:45 rainbow kernel: [    2.382774] pcieport-driver 0000:00:1c.1: found MSI capability
Jan  9 17:47:45 rainbow kernel: [    2.382895] pcieport-driver 0000:00:1c.1: irq 2302 for MSI/MSI-X
Jan  9 17:47:45 rainbow kernel: [    2.382987] pci_express 0000:00:1c.1:pcie00: allocate port service
Jan  9 17:47:45 rainbow kernel: [    2.383091] pci_express 0000:00:1c.1:pcie02: allocate port service
Jan  9 17:47:45 rainbow kernel: [    2.383195] pci_express 0000:00:1c.1:pcie03: allocate port service
Jan  9 17:47:45 rainbow kernel: [    2.383400] pcieport-driver 0000:00:1c.2: setting latency timer to 64
Jan  9 17:47:45 rainbow kernel: [    2.383528] pcieport-driver 0000:00:1c.2: found MSI capability
Jan  9 17:47:45 rainbow kernel: [    2.383636] pcieport-driver 0000:00:1c.2: irq 2301 for MSI/MSI-X
Jan  9 17:47:45 rainbow kernel: [    2.383723] pci_express 0000:00:1c.2:pcie00: allocate port service
Jan  9 17:47:45 rainbow kernel: [    2.383828] pci_express 0000:00:1c.2:pcie02: allocate port service
Jan  9 17:47:45 rainbow kernel: [    2.383931] pci_express 0000:00:1c.2:pcie03: allocate port service
Jan  9 17:47:45 rainbow kernel: [    2.384161] pcieport-driver 0000:00:1c.3: setting latency timer to 64
Jan  9 17:47:45 rainbow kernel: [    2.384299] pcieport-driver 0000:00:1c.3: found MSI capability
Jan  9 17:47:45 rainbow kernel: [    2.384410] pcieport-driver 0000:00:1c.3: irq 2300 for MSI/MSI-X
Jan  9 17:47:45 rainbow kernel: [    2.384495] pci_express 0000:00:1c.3:pcie00: allocate port service
Jan  9 17:47:45 rainbow kernel: [    2.384598] pci_express 0000:00:1c.3:pcie02: allocate port service
Jan  9 17:47:45 rainbow kernel: [    2.384701] pci_express 0000:00:1c.3:pcie03: allocate port service
Jan  9 17:47:45 rainbow kernel: [    2.384903] pcieport-driver 0000:00:1c.4: setting latency timer to 64
Jan  9 17:47:45 rainbow kernel: [    2.385058] pcieport-driver 0000:00:1c.4: found MSI capability
Jan  9 17:47:45 rainbow kernel: [    2.385175] pcieport-driver 0000:00:1c.4: irq 2299 for MSI/MSI-X
Jan  9 17:47:45 rainbow kernel: [    2.385261] pci_express 0000:00:1c.4:pcie00: allocate port service
Jan  9 17:47:45 rainbow kernel: [    2.385365] pci_express 0000:00:1c.4:pcie02: allocate port service
Jan  9 17:47:45 rainbow kernel: [    2.385467] pci_express 0000:00:1c.4:pcie03: allocate port service
Jan  9 17:47:45 rainbow kernel: [    2.416133] Linux agpgart interface v0.103
Jan  9 17:47:45 rainbow kernel: [    2.416214] Serial: 8250/16550 driver4 ports, IRQ sharing enabled
Jan  9 17:47:45 rainbow kernel: [    2.418492] brd: module loaded
Jan  9 17:47:45 rainbow kernel: [    2.418552] e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
Jan  9 17:47:45 rainbow kernel: [    2.418617] e1000e: Copyright (c) 1999-2008 Intel Corporation.
Jan  9 17:47:45 rainbow kernel: [    2.418727] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
Jan  9 17:47:45 rainbow kernel: [    2.418803] e1000e 0000:00:19.0: setting latency timer to 64
Jan  9 17:47:45 rainbow kernel: [    2.419041] e1000e 0000:00:19.0: irq 2298 for MSI/MSI-X
Jan  9 17:47:45 rainbow kernel: [    2.626473] 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:1c:25:7e:69:03
Jan  9 17:47:45 rainbow kernel: [    2.626547] 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
Jan  9 17:47:45 rainbow kernel: [    2.626648] 0000:00:19.0: eth0: MAC: 5, PHY: 6, PBA No: 1008ff-0ff
Jan  9 17:47:45 rainbow kernel: [    2.626772] netconsole: local port 6665
Jan  9 17:47:45 rainbow kernel: [    2.626835] netconsole: local IP 169.254.1.1
Jan  9 17:47:45 rainbow kernel: [    2.626896] netconsole: interface eth0
Jan  9 17:47:45 rainbow kernel: [    2.626955] netconsole: remote port 6666
Jan  9 17:47:45 rainbow kernel: [    2.627014] netconsole: remote IP 169.254.5.142
Jan  9 17:47:45 rainbow kernel: [    2.627078] netconsole: remote ethernet address 00:0d:93:7b:d8:a0
Jan  9 17:47:45 rainbow kernel: [    2.627141] netconsole: device eth0 not up yet, forcing it
Jan  9 17:47:45 rainbow kernel: [    2.764241] e1000e 0000:00:19.0: irq 2298 for MSI/MSI-X
Jan  9 17:47:45 rainbow kernel: [    2.820102] e1000e 0000:00:19.0: irq 2298 for MSI/MSI-X
Jan  9 17:47:45 rainbow kernel: [    6.825008] netconsole: timeout waiting for carrier
Jan  9 17:47:45 rainbow kernel: [    6.837030] console [netcon0] enabled
Jan  9 17:47:45 rainbow kernel: [    6.876175] netconsole: network logging started
Jan  9 17:47:45 rainbow kernel: [    6.876371] PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
Jan  9 17:47:45 rainbow kernel: [    6.886275] serio: i8042 KBD port at 0x60,0x64 irq 1
Jan  9 17:47:45 rainbow kernel: [    6.886340] serio: i8042 AUX port at 0x60,0x64 irq 12
Jan  9 17:47:45 rainbow kernel: [    6.886590] mice: PS/2 mouse device common for all mice
Jan  9 17:47:45 rainbow kernel: [    6.886740] rtc_cmos 00:07: RTC can wake from S4
Jan  9 17:47:45 rainbow kernel: [    6.886870] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
Jan  9 17:47:45 rainbow kernel: [    6.886971] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
Jan  9 17:47:45 rainbow kernel: [    6.887072] cpuidle: using governor ladder
Jan  9 17:47:45 rainbow kernel: [    6.887133] cpuidle: using governor menu
Jan  9 17:47:45 rainbow kernel: [    6.887494] TCP cubic registered
Jan  9 17:47:45 rainbow kernel: [    6.887747] registered taskstats version 1
Jan  9 17:47:45 rainbow kernel: [    6.887942]   Magic number: 9:215:805
Jan  9 17:47:45 rainbow kernel: [    6.888156] rtc_cmos 00:07: setting system clock to 2009-01-09 22:47:29 UTC (1231541249)
Jan  9 17:47:45 rainbow kernel: [    6.888233] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
Jan  9 17:47:45 rainbow kernel: [    6.888296] EDD information not available.
Jan  9 17:47:45 rainbow kernel: [    6.888401] Freeing unused kernel memory: 552k freed
Jan  9 17:47:45 rainbow kernel: [    6.888661] Write protecting the kernel read-only data: 4444k
Jan  9 17:47:45 rainbow kernel: [    6.892862] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
Jan  9 17:47:45 rainbow kernel: [    6.991471] fuse init (API version 7.10)
Jan  9 17:47:45 rainbow kernel: [    7.001322] ACPI: SSDT BF6E1B32, 02C4 (r1  PmRef  Cpu0Ist      100 INTL 20050513)
Jan  9 17:47:45 rainbow kernel: [    7.002128] ACPI: SSDT BF6E1E7B, 085E (r1  PmRef  Cpu0Cst      100 INTL 20050513)
Jan  9 17:47:45 rainbow kernel: [    7.005706] Monitor-Mwait will be used to enter C-1 state
Jan  9 17:47:45 rainbow kernel: [    7.005774] Monitor-Mwait will be used to enter C-2 state
Jan  9 17:47:45 rainbow kernel: [    7.005840] Monitor-Mwait will be used to enter C-3 state
Jan  9 17:47:45 rainbow kernel: [    7.006157] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
Jan  9 17:47:45 rainbow kernel: [    7.006483] processor ACPI_CPU:00: registered as cooling_device0
Jan  9 17:47:45 rainbow kernel: [    7.006551] ACPI: Processor [CPU0] (supports 8 throttling states)
Jan  9 17:47:45 rainbow kernel: [    7.007045] ACPI: SSDT BF6E1A6A, 00C8 (r1  PmRef  Cpu1Ist      100 INTL 20050513)
Jan  9 17:47:45 rainbow kernel: [    7.007663] ACPI: SSDT BF6E1DF6, 0085 (r1  PmRef  Cpu1Cst      100 INTL 20050513)
Jan  9 17:47:45 rainbow kernel: [    7.009877] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
Jan  9 17:47:45 rainbow kernel: [    7.010147] processor ACPI_CPU:01: registered as cooling_device1
Jan  9 17:47:45 rainbow kernel: [    7.010209] ACPI: Processor [CPU1] (supports 8 throttling states)
Jan  9 17:47:45 rainbow kernel: [    7.014450] thermal LNXTHERM:01: registered as thermal_zone0
Jan  9 17:47:45 rainbow kernel: [    7.018797] ACPI: Thermal Zone [THM0] (61 C)
Jan  9 17:47:45 rainbow kernel: [    7.019873] thermal LNXTHERM:02: registered as thermal_zone1
Jan  9 17:47:45 rainbow kernel: [    7.021247] ACPI: Thermal Zone [THM1] (56 C)
Jan  9 17:47:45 rainbow kernel: [    7.160237] usbcore: registered new interface driver usbfs
Jan  9 17:47:45 rainbow kernel: [    7.160332] usbcore: registered new interface driver hub
Jan  9 17:47:45 rainbow kernel: [    7.160441] usbcore: registered new device driver usb
Jan  9 17:47:45 rainbow kernel: [    7.162251] uhci_hcd: USB Universal Host Controller Interface driver
Jan  9 17:47:45 rainbow kernel: [    7.162373] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
Jan  9 17:47:45 rainbow kernel: [    7.162461] uhci_hcd 0000:00:1a.0: setting latency timer to 64
Jan  9 17:47:45 rainbow kernel: [    7.162536] uhci_hcd 0000:00:1a.0: UHCI Host Controller
Jan  9 17:47:45 rainbow kernel: [    7.162644] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
Jan  9 17:47:45 rainbow kernel: [    7.162781] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001860
Jan  9 17:47:45 rainbow kernel: [    7.163005] usb usb1: configuration #1 chosen from 1 choice
Jan  9 17:47:45 rainbow kernel: [    7.163098] hub 1-0:1.0: USB hub found
Jan  9 17:47:45 rainbow kernel: [    7.163167] hub 1-0:1.0: 2 ports detected
Jan  9 17:47:45 rainbow kernel: [    7.163921] uhci_hcd 0000:00:1a.1: power state changed by ACPI to D0
Jan  9 17:47:45 rainbow kernel: [    7.163993] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
Jan  9 17:47:45 rainbow kernel: [    7.164078] uhci_hcd 0000:00:1a.1: setting latency timer to 64
Jan  9 17:47:45 rainbow kernel: [    7.164146] uhci_hcd 0000:00:1a.1: UHCI Host Controller
Jan  9 17:47:45 rainbow kernel: [    7.164232] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
Jan  9 17:47:45 rainbow kernel: [    7.164347] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001880
Jan  9 17:47:45 rainbow kernel: [    7.164490] usb usb2: configuration #1 chosen from 1 choice
Jan  9 17:47:45 rainbow kernel: [    7.164574] hub 2-0:1.0: USB hub found
Jan  9 17:47:45 rainbow kernel: [    7.164637] hub 2-0:1.0: 2 ports detected
Jan  9 17:47:45 rainbow kernel: [    7.165274] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
Jan  9 17:47:45 rainbow kernel: [    7.165345] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Jan  9 17:47:45 rainbow kernel: [    7.165429] uhci_hcd 0000:00:1d.0: setting latency timer to 64
Jan  9 17:47:45 rainbow kernel: [    7.165503] uhci_hcd 0000:00:1d.0: UHCI Host Controller
Jan  9 17:47:45 rainbow kernel: [    7.165589] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 3
Jan  9 17:47:45 rainbow kernel: [    7.165707] uhci_hcd 0000:00:1d.0: irq 16, io base 0x000018a0
Jan  9 17:47:45 rainbow kernel: [    7.165854] usb usb3: configuration #1 chosen from 1 choice
Jan  9 17:47:45 rainbow kernel: [    7.165940] hub 3-0:1.0: USB hub found
Jan  9 17:47:45 rainbow kernel: [    7.166009] hub 3-0:1.0: 2 ports detected
Jan  9 17:47:45 rainbow kernel: [    7.166173] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
Jan  9 17:47:45 rainbow kernel: [    7.166253] uhci_hcd 0000:00:1d.1: setting latency timer to 64
Jan  9 17:47:45 rainbow kernel: [    7.166324] uhci_hcd 0000:00:1d.1: UHCI Host Controller
Jan  9 17:47:45 rainbow kernel: [    7.166403] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 4
Jan  9 17:47:45 rainbow kernel: [    7.166516] uhci_hcd 0000:00:1d.1: irq 17, io base 0x000018c0
Jan  9 17:47:45 rainbow kernel: [    7.166653] usb usb4: configuration #1 chosen from 1 choice
Jan  9 17:47:45 rainbow kernel: [    7.166739] hub 4-0:1.0: USB hub found
Jan  9 17:47:45 rainbow kernel: [    7.166802] hub 4-0:1.0: 2 ports detected
Jan  9 17:47:45 rainbow kernel: [    7.167614] uhci_hcd 0000:00:1d.2: power state changed by ACPI to D0
Jan  9 17:47:45 rainbow kernel: [    7.167685] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
Jan  9 17:47:45 rainbow kernel: [    7.167760] uhci_hcd 0000:00:1d.2: setting latency timer to 64
Jan  9 17:47:45 rainbow kernel: [    7.167830] uhci_hcd 0000:00:1d.2: UHCI Host Controller
Jan  9 17:47:45 rainbow kernel: [    7.167914] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 5
Jan  9 17:47:45 rainbow kernel: [    7.168027] uhci_hcd 0000:00:1d.2: irq 18, io base 0x000018e0
Jan  9 17:47:45 rainbow kernel: [    7.168168] usb usb5: configuration #1 chosen from 1 choice
Jan  9 17:47:45 rainbow kernel: [    7.168254] hub 5-0:1.0: USB hub found
Jan  9 17:47:45 rainbow kernel: [    7.168320] hub 5-0:1.0: 2 ports detected
Jan  9 17:47:45 rainbow kernel: [    7.175165] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Jan  9 17:47:45 rainbow kernel: [    7.175247] Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
Jan  9 17:47:45 rainbow kernel: [    7.178501] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
Jan  9 17:47:45 rainbow kernel: [    7.178584] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
Jan  9 17:47:45 rainbow kernel: [    7.178720] ehci_hcd 0000:00:1a.7: setting latency timer to 64
Jan  9 17:47:45 rainbow kernel: [    7.178789] ehci_hcd 0000:00:1a.7: EHCI Host Controller
Jan  9 17:47:45 rainbow kernel: [    7.178886] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 6
Jan  9 17:47:45 rainbow kernel: [    7.182908] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
Jan  9 17:47:45 rainbow kernel: [    7.182997] ehci_hcd 0000:00:1a.7: irq 22, io mem 0xfe226c00
Jan  9 17:47:45 rainbow kernel: [    7.199690] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
Jan  9 17:47:45 rainbow kernel: [    7.199880] usb usb6: configuration #1 chosen from 1 choice
Jan  9 17:47:45 rainbow kernel: [    7.199968] hub 6-0:1.0: USB hub found
Jan  9 17:47:45 rainbow kernel: [    7.200044] hub 6-0:1.0: 4 ports detected
Jan  9 17:47:45 rainbow kernel: [    7.200632] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
Jan  9 17:47:45 rainbow kernel: [    7.200707] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
Jan  9 17:47:45 rainbow kernel: [    7.200793] ehci_hcd 0000:00:1d.7: setting latency timer to 64
Jan  9 17:47:45 rainbow kernel: [    7.200863] ehci_hcd 0000:00:1d.7: EHCI Host Controller
Jan  9 17:47:45 rainbow kernel: [    7.200946] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 7
Jan  9 17:47:45 rainbow kernel: [    7.204972] ehci_hcd 0000:00:1d.7: debug port 1
Jan  9 17:47:45 rainbow kernel: [    7.205076] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
Jan  9 17:47:45 rainbow kernel: [    7.205157] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xfe227000
Jan  9 17:47:45 rainbow kernel: [    7.221031] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
Jan  9 17:47:45 rainbow kernel: [    7.221241] usb usb7: configuration #1 chosen from 1 choice
Jan  9 17:47:45 rainbow kernel: [    7.221330] hub 7-0:1.0: USB hub found
Jan  9 17:47:45 rainbow kernel: [    7.221396] hub 7-0:1.0: 6 ports detected
Jan  9 17:47:45 rainbow kernel: [    7.236822] SCSI subsystem initialized
Jan  9 17:47:45 rainbow kernel: [    7.252577] ohci1394 0000:15:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
Jan  9 17:47:45 rainbow kernel: [    7.252659] ohci1394 0000:15:00.1: setting latency timer to 64
Jan  9 17:47:45 rainbow kernel: [    7.285328] libata version 3.00 loaded.
Jan  9 17:47:45 rainbow kernel: [    7.288459] ahci 0000:00:1f.2: version 3.0
Jan  9 17:47:45 rainbow kernel: [    7.288530] ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
Jan  9 17:47:45 rainbow kernel: [    7.288665] ahci 0000:00:1f.2: irq 2297 for MSI/MSI-X
Jan  9 17:47:45 rainbow kernel: [    7.288784] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 1.5 Gbps 0x1 impl SATA mode
Jan  9 17:47:45 rainbow kernel: [    7.288869] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part 
Jan  9 17:47:45 rainbow kernel: [    7.288953] ahci 0000:00:1f.2: setting latency timer to 64
Jan  9 17:47:45 rainbow kernel: [    7.290806] scsi0 : ahci
Jan  9 17:47:45 rainbow kernel: [    7.292440] scsi1 : ahci
Jan  9 17:47:45 rainbow kernel: [    7.292553] scsi2 : ahci
Jan  9 17:47:45 rainbow kernel: [    7.292667] ata1: SATA max UDMA/133 abar m2048@0xfe226000 port 0xfe226100 irq 2297
Jan  9 17:47:45 rainbow kernel: [    7.292740] ata2: DUMMY
Jan  9 17:47:45 rainbow kernel: [    7.292794] ata3: DUMMY
Jan  9 17:47:45 rainbow kernel: [    7.305505] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[17]  MMIO=[f8301000-f83017ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
Jan  9 17:47:45 rainbow kernel: [    7.613306] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Jan  9 17:47:45 rainbow kernel: [    7.614258] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
Jan  9 17:47:45 rainbow kernel: [    7.614312] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
Jan  9 17:47:45 rainbow kernel: [    7.614589] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
Jan  9 17:47:45 rainbow kernel: [    7.614657] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
Jan  9 17:47:45 rainbow kernel: [    7.668475] ata1.00: ATA-8: WDC WD1200BEVS-08UST0, 02.01A02, max UDMA/133
Jan  9 17:47:45 rainbow kernel: [    7.668544] ata1.00: 234441648 sectors, multi 16: LBA48 NCQ (depth 31/32)
Jan  9 17:47:45 rainbow kernel: [    7.669652] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
Jan  9 17:47:45 rainbow kernel: [    7.669732] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
Jan  9 17:47:45 rainbow kernel: [    7.669913] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
Jan  9 17:47:45 rainbow kernel: [    7.670000] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
Jan  9 17:47:45 rainbow kernel: [    7.670797] ata1.00: configured for UDMA/133
Jan  9 17:47:45 rainbow kernel: [    7.687833] ata1.00: configured for UDMA/133
Jan  9 17:47:45 rainbow kernel: [    7.687911] ata1: EH complete
Jan  9 17:47:45 rainbow kernel: [    7.688068] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1200BEVS-0 02.0 PQ: 0 ANSI: 5
Jan  9 17:47:45 rainbow kernel: [    7.688734] pata_acpi 0000:00:1f.1: PCI INT C -> GSI 16 (level, low) -> IRQ 16
Jan  9 17:47:45 rainbow kernel: [    7.689462] pata_acpi 0000:00:1f.1: setting latency timer to 64
Jan  9 17:47:45 rainbow kernel: [    7.689543] pata_acpi 0000:00:1f.1: PCI INT C disabled
Jan  9 17:47:45 rainbow kernel: [    7.693414] ata_piix 0000:00:1f.1: version 2.12
Jan  9 17:47:45 rainbow kernel: [    7.693479] ata_piix 0000:00:1f.1: PCI INT C -> GSI 16 (level, low) -> IRQ 16
Jan  9 17:47:45 rainbow kernel: [    7.693595] ata_piix 0000:00:1f.1: setting latency timer to 64
Jan  9 17:47:45 rainbow kernel: [    7.694084] scsi3 : ata_piix
Jan  9 17:47:45 rainbow kernel: [    7.694209] scsi4 : ata_piix
Jan  9 17:47:45 rainbow kernel: [    7.695090] ata4: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1c00 irq 14
Jan  9 17:47:45 rainbow kernel: [    7.695159] ata5: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1c08 irq 15
Jan  9 17:47:45 rainbow kernel: [    7.724670] scsi 0:0:0:0: Attached scsi generic sg0 type 0
Jan  9 17:47:45 rainbow kernel: [    7.736117] Driver 'sd' needs updating - please use bus_type methods
Jan  9 17:47:45 rainbow kernel: [    7.736277] sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors: (120 GB/111 GiB)
Jan  9 17:47:45 rainbow kernel: [    7.736364] sd 0:0:0:0: [sda] Write Protect is off
Jan  9 17:47:45 rainbow kernel: [    7.736427] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Jan  9 17:47:45 rainbow kernel: [    7.736505] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jan  9 17:47:45 rainbow kernel: [    7.736627] sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors: (120 GB/111 GiB)
Jan  9 17:47:45 rainbow kernel: [    7.736711] sd 0:0:0:0: [sda] Write Protect is off
Jan  9 17:47:45 rainbow kernel: [    7.736775] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Jan  9 17:47:45 rainbow kernel: [    7.736852] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jan  9 17:47:45 rainbow kernel: [    7.736941]  sda: sda1 sda2 < sda5 >
Jan  9 17:47:45 rainbow kernel: [    7.770136] sd 0:0:0:0: [sda] Attached SCSI disk
Jan  9 17:47:45 rainbow kernel: [    7.857538] ata4.00: ATAPI: MATSHITADVD-RAM UJ-862, RB01, max UDMA/33
Jan  9 17:47:45 rainbow kernel: [    7.873405] ata4.00: configured for UDMA/33
Jan  9 17:47:45 rainbow kernel: [    7.873958] ata5: port disabled. ignoring.
Jan  9 17:47:45 rainbow kernel: [    7.876153] scsi 3:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ-862   RB01 PQ: 0 ANSI: 5
Jan  9 17:47:45 rainbow kernel: [    7.876365] scsi 3:0:0:0: Attached scsi generic sg1 type 5
Jan  9 17:47:45 rainbow kernel: [    7.888401] Driver 'sr' needs updating - please use bus_type methods
Jan  9 17:47:45 rainbow kernel: [    7.893558] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Jan  9 17:47:45 rainbow kernel: [    7.893625] Uniform CD-ROM driver Revision: 3.20
Jan  9 17:47:45 rainbow kernel: [    7.893781] sr 3:0:0:0: Attached scsi CD-ROM sr0
Jan  9 17:47:45 rainbow kernel: [    8.000087] Clocksource tsc unstable (delta = -187628151 ns)
Jan  9 17:47:45 rainbow kernel: [    8.039411] PM: Starting manual resume from disk
Jan  9 17:47:45 rainbow kernel: [    8.039478] PM: Resume from partition 8:5
Jan  9 17:47:45 rainbow kernel: [    8.039537] PM: Checking hibernation image.
Jan  9 17:47:45 rainbow kernel: [    8.039791] PM: Resume from disk failed.
Jan  9 17:47:45 rainbow kernel: [    8.107021] kjournald starting.  Commit interval 5 seconds
Jan  9 17:47:45 rainbow kernel: [    8.107119] EXT3-fs: mounted filesystem with ordered data mode.
Jan  9 17:47:45 rainbow kernel: [    8.440995] 0000:00:19.0: eth0: Link is Up 100 Mbps Half Duplex, Flow Control: None
Jan  9 17:47:45 rainbow kernel: [    8.441134] 0000:00:19.0: eth0: 10/100 speed: disabling TSO
Jan  9 17:47:45 rainbow kernel: [    8.441450] 0000:00:19.0: eth0: Detected Tx Unit Hang:
Jan  9 17:47:45 rainbow kernel: [    8.441451]   TDH                  <53>
Jan  9 17:47:45 rainbow kernel: [    8.441451]   TDT                  <ec>
Jan  9 17:47:45 rainbow kernel: [    8.441452]   next_to_use          <ec>
Jan  9 17:47:45 rainbow kernel: [    8.441452]   next_to_clean        <41>
Jan  9 17:47:45 rainbow kernel: [    8.441453] buffer_info[next_to_clean]:
Jan  9 17:47:45 rainbow kernel: [    8.441453]   time_stamp           <fffee1b5>
Jan  9 17:47:45 rainbow kernel: [    8.441454]   next_to_watch        <41>
Jan  9 17:47:45 rainbow kernel: [    8.441454]   jiffies              <fffee346>
Jan  9 17:47:45 rainbow kernel: [    8.441455]   next_to_watch.status <1>
Jan  9 17:47:45 rainbow kernel: [    8.585430] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00016c00005ec9db]
Jan  9 17:47:45 rainbow kernel: [   15.372082] udevd version 124 started
Jan  9 17:47:45 rainbow kernel: [   15.814551] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
Jan  9 17:47:45 rainbow kernel: [   15.947219] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
Jan  9 17:47:45 rainbow kernel: [   15.961054] ACPI: Power Button (FF) [PWRF]
Jan  9 17:47:45 rainbow kernel: [   15.961209] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input2
Jan  9 17:47:45 rainbow kernel: [   15.961916] ACPI: Lid Switch [LID]
Jan  9 17:47:45 rainbow kernel: [   15.962053] input: Sleep Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input3
Jan  9 17:47:45 rainbow kernel: [   15.985099] ACPI: Sleep Button (CM) [SLPB]
Jan  9 17:47:45 rainbow kernel: [   16.047967] ACPI: AC Adapter [AC] (on-line)
Jan  9 17:47:45 rainbow kernel: [   16.119721] ACPI: Battery Slot [BAT0] (battery present)
Jan  9 17:47:45 rainbow kernel: [   16.151639] ACPI: WMI: Mapper loaded
Jan  9 17:47:45 rainbow kernel: [   16.188990] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
Jan  9 17:47:45 rainbow kernel: [   16.309960] acpi device:03: registered as cooling_device2
Jan  9 17:47:45 rainbow kernel: [   16.310252] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:02/input/input4
Jan  9 17:47:45 rainbow kernel: [   16.326769] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
Jan  9 17:47:45 rainbow kernel: [   16.340548] iTCO_vendor_support: vendor-support=0
Jan  9 17:47:45 rainbow kernel: [   16.361258] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.04
Jan  9 17:47:45 rainbow kernel: [   16.361453] iTCO_wdt: Found a ICH8M-E TCO device (Version=2, TCOBASE=0x1060)
Jan  9 17:47:45 rainbow kernel: [   16.361625] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
Jan  9 17:47:45 rainbow kernel: [   16.388707] agpgart-intel 0000:00:00.0: Intel 965GM Chipset
Jan  9 17:47:45 rainbow kernel: [   16.389680] agpgart-intel 0000:00:00.0: detected 7676K stolen memory
Jan  9 17:47:45 rainbow kernel: [   16.393461] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
Jan  9 17:47:45 rainbow kernel: [   16.464163] Non-volatile memory driver v1.2
Jan  9 17:47:45 rainbow kernel: [   16.603535] yenta_cardbus 0000:15:00.0: CardBus bridge found [17aa:20c6]
Jan  9 17:47:45 rainbow kernel: [   16.613708] input: PC Speaker as /devices/platform/pcspkr/input/input5
Jan  9 17:47:45 rainbow kernel: [   16.730083] yenta_cardbus 0000:15:00.0: ISA IRQ mask 0x0cb8, PCI irq 16
Jan  9 17:47:45 rainbow kernel: [   16.730165] yenta_cardbus 0000:15:00.0: Socket status: 30000006
Jan  9 17:47:45 rainbow kernel: [   16.730235] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge I/O window: 0x7000 - 0xafff
Jan  9 17:47:45 rainbow kernel: [   16.730316] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge Memory window: 0xf8300000 - 0xfbffffff
Jan  9 17:47:45 rainbow kernel: [   16.730400] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge Memory window: 0xf4000000 - 0xf7ffffff
Jan  9 17:47:45 rainbow kernel: [   16.781087] cfg80211: Using static regulatory domain info
Jan  9 17:47:45 rainbow kernel: [   16.781164] cfg80211: Regulatory domain: US
Jan  9 17:47:45 rainbow kernel: [   16.781227] ^I(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Jan  9 17:47:45 rainbow kernel: [   16.781310] ^I(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
Jan  9 17:47:45 rainbow kernel: [   16.781382] ^I(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
Jan  9 17:47:45 rainbow kernel: [   16.781451] ^I(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
Jan  9 17:47:45 rainbow kernel: [   16.781512] ^I(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
Jan  9 17:47:45 rainbow kernel: [   16.781578] ^I(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
Jan  9 17:47:45 rainbow kernel: [   16.781654] ^I(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
Jan  9 17:47:45 rainbow kernel: [   16.781729] cfg80211: Calling CRDA for country: US
Jan  9 17:47:45 rainbow kernel: [   16.841720] lib80211: common routines for IEEE802.11 drivers
Jan  9 17:47:45 rainbow kernel: [   16.841798] lib80211_crypt: registered algorithm 'NULL'
Jan  9 17:47:45 rainbow kernel: [   17.209505] Synaptics Touchpad, model: 1, fw: 6.2, id: 0x81a0b1, caps: 0xa04791/0x300000
Jan  9 17:47:45 rainbow kernel: [   17.209591] serio: Synaptics pass-through port at isa0060/serio1/input0
Jan  9 17:47:45 rainbow kernel: [   17.254662] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input6
Jan  9 17:47:45 rainbow kernel: [   17.516979] thinkpad_acpi: ThinkPad ACPI Extras v0.21
Jan  9 17:47:45 rainbow kernel: [   17.517079] thinkpad_acpi: http://ibm-acpi.sf.net/
Jan  9 17:47:45 rainbow kernel: [   17.517148] thinkpad_acpi: ThinkPad BIOS 7LETB2WW (2.12 ), EC 7KHT24WW-1.08
Jan  9 17:47:45 rainbow kernel: [   17.517214] thinkpad_acpi: Lenovo ThinkPad T61, model 7658CTO
Jan  9 17:47:45 rainbow kernel: [   17.521365] thinkpad_acpi: ACPI backlight control delay disabled
Jan  9 17:47:45 rainbow kernel: [   17.521896] thinkpad_acpi: radio switch found; radios are enabled
Jan  9 17:47:45 rainbow kernel: [   17.522063] thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
Jan  9 17:47:45 rainbow kernel: [   17.522146] thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
Jan  9 17:47:45 rainbow kernel: [   17.529114] Registered led device: tpacpi::thinklight
Jan  9 17:47:45 rainbow kernel: [   17.529216] Registered led device: tpacpi::power
Jan  9 17:47:45 rainbow kernel: [   17.529308] Registered led device: tpacpi:orange:batt
Jan  9 17:47:45 rainbow kernel: [   17.529398] Registered led device: tpacpi:green:batt
Jan  9 17:47:45 rainbow kernel: [   17.529496] Registered led device: tpacpi::dock_active
Jan  9 17:47:45 rainbow kernel: [   17.529584] Registered led device: tpacpi::bay_active
Jan  9 17:47:45 rainbow kernel: [   17.529671] Registered led device: tpacpi::dock_batt
Jan  9 17:47:45 rainbow kernel: [   17.529758] Registered led device: tpacpi::unknown_led
Jan  9 17:47:45 rainbow kernel: [   17.529849] Registered led device: tpacpi::standby
Jan  9 17:47:45 rainbow kernel: [   17.533077] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one.
Jan  9 17:47:45 rainbow kernel: [   17.533525] input: ThinkPad Extra Buttons as /devices/virtual/input/input7
Jan  9 17:47:45 rainbow kernel: [   17.913515] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, 1.2.26kds
Jan  9 17:47:45 rainbow kernel: [   17.913631] iwl3945: Copyright(c) 2003-2008 Intel Corporation
Jan  9 17:47:45 rainbow kernel: [   17.913865] iwl3945 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
Jan  9 17:47:45 rainbow kernel: [   17.913932] iwl3945 0000:03:00.0: setting latency timer to 64
Jan  9 17:47:45 rainbow kernel: [   17.914192] ieee80211 phy0: U iwl3945_pci_probe pci_resource_len = 0x00001000
Jan  9 17:47:45 rainbow kernel: [   17.914268] ieee80211 phy0: U iwl3945_pci_probe pci_resource_base = ffffc200050be000
Jan  9 17:47:45 rainbow kernel: [   17.914397] ieee80211 phy0: U iwl3945_power_init_handle Initialize power 
Jan  9 17:47:45 rainbow kernel: [   17.914458] ieee80211 phy0: U iwl3945_power_init_handle adjust power command flags
Jan  9 17:47:45 rainbow kernel: [   17.973448] ieee80211 phy0: U iwl3945_pci_probe MAC address: 00:1f:3c:20:a1:6e
Jan  9 17:47:45 rainbow kernel: [   17.973530] ieee80211 phy0: U iwl3945_init_channel_map Initializing regulatory info from EEPROM
Jan  9 17:47:45 rainbow kernel: [   17.973598] ieee80211 phy0: U iwl3945_init_channel_map Parsing data for 56 channels.
Jan  9 17:47:45 rainbow kernel: [   17.973673] ieee80211 phy0: U iwl3945_init_channel_map Ch. 1 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
Jan  9 17:47:45 rainbow kernel: [   17.973749] ieee80211 phy0: U iwl3945_init_channel_map Ch. 2 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
Jan  9 17:47:45 rainbow kernel: [   17.973820] ieee80211 phy0: U iwl3945_init_channel_map Ch. 3 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
Jan  9 17:47:45 rainbow kernel: [   17.973891] ieee80211 phy0: U iwl3945_init_channel_map Ch. 4 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
Jan  9 17:47:45 rainbow kernel: [   17.973965] ieee80211 phy0: U iwl3945_init_channel_map Ch. 5 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
Jan  9 17:47:45 rainbow kernel: [   17.974053] ieee80211 phy0: U iwl3945_init_channel_map Ch. 6 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
Jan  9 17:47:45 rainbow kernel: [   17.974133] ieee80211 phy0: U iwl3945_init_channel_map Ch. 7 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
Jan  9 17:47:45 rainbow kernel: [   17.974204] ieee80211 phy0: U iwl3945_init_channel_map Ch. 8 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
Jan  9 17:47:45 rainbow kernel: [   17.974279] ieee80211 phy0: U iwl3945_init_channel_map Ch. 9 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
Jan  9 17:47:45 rainbow kernel: [   17.974353] ieee80211 phy0: U iwl3945_init_channel_map Ch. 10 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
Jan  9 17:47:45 rainbow kernel: [   17.974425] ieee80211 phy0: U iwl3945_init_channel_map Ch. 11 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 14dBm): Ad-Hoc supported
Jan  9 17:47:45 rainbow kernel: [   17.975093] ieee80211 phy0: U iwl3945_init_channel_map Ch. 12 Flags 0 [2.4GHz] - No traffic
Jan  9 17:47:45 rainbow kernel: [   17.975157] ieee80211 phy0: U iwl3945_init_channel_map Ch. 13 Flags 0 [2.4GHz] - No traffic
Jan  9 17:47:45 rainbow kernel: [   17.975222] ieee80211 phy0: U iwl3945_init_channel_map Ch. 14 Flags 0 [2.4GHz] - No traffic
Jan  9 17:47:45 rainbow kernel: [   17.975289] ieee80211 phy0: U iwl3945_init_channel_map Ch. 183 Flags 0 [5.2GHz] - No traffic
Jan  9 17:47:45 rainbow kernel: [   17.975354] ieee80211 phy0: U iwl3945_init_channel_map Ch. 184 Flags 0 [5.2GHz] - No traffic
Jan  9 17:47:45 rainbow kernel: [   17.975418] ieee80211 phy0: U iwl3945_init_channel_map Ch. 185 Flags 0 [5.2GHz] - No traffic
Jan  9 17:47:45 rainbow kernel: [   17.975483] ieee80211 phy0: U iwl3945_init_channel_map Ch. 187 Flags 0 [5.2GHz] - No traffic
Jan  9 17:47:45 rainbow kernel: [   17.975553] ieee80211 phy0: U iwl3945_init_channel_map Ch. 188 Flags 0 [5.2GHz] - No traffic
Jan  9 17:47:45 rainbow kernel: [   17.975617] ieee80211 phy0: U iwl3945_init_channel_map Ch. 189 Flags 0 [5.2GHz] - No traffic
Jan  9 17:47:45 rainbow kernel: [   17.975682] ieee80211 phy0: U iwl3945_init_channel_map Ch. 192 Flags 0 [5.2GHz] - No traffic
Jan  9 17:47:45 rainbow kernel: [   17.975747] ieee80211 phy0: U iwl3945_init_channel_map Ch. 196 Flags 0 [5.2GHz] - No traffic
Jan  9 17:47:45 rainbow kernel: [   17.975814] ieee80211 phy0: U iwl3945_init_channel_map Ch. 7 Flags 0 [5.2GHz] - No traffic
Jan  9 17:47:45 rainbow kernel: [   17.975879] ieee80211 phy0: U iwl3945_init_channel_map Ch. 8 Flags 0 [5.2GHz] - No traffic
Jan  9 17:47:45 rainbow kernel: [   17.975947] ieee80211 phy0: U iwl3945_init_channel_map Ch. 11 Flags 0 [5.2GHz] - No traffic
Jan  9 17:47:45 rainbow kernel: [   17.976014] ieee80211 phy0: U iwl3945_init_channel_map Ch. 12 Flags 0 [5.2GHz] - No traffic
Jan  9 17:47:45 rainbow kernel: [   17.976108] ieee80211 phy0: U iwl3945_init_channel_map Ch. 16 Flags 0 [5.2GHz] - No traffic
Jan  9 17:47:45 rainbow kernel: [   17.976177] ieee80211 phy0: U iwl3945_init_channel_map Ch. 34 Flags 0 [5.2GHz] - No traffic
Jan  9 17:47:45 rainbow kernel: [   17.976250] ieee80211 phy0: U iwl3945_init_channel_map Ch. 36 [5.2GHz] VALID WIDE DFS (0xa1 14dBm): Ad-Hoc not supported
Jan  9 17:47:45 rainbow kernel: [   17.976323] ieee80211 phy0: U iwl3945_init_channel_map Ch. 38 Flags 0 [5.2GHz] - No traffic
Jan  9 17:47:45 rainbow kernel: [   17.976391] ieee80211 phy0: U iwl3945_init_channel_map Ch. 40 [5.2GHz] VALID WIDE DFS (0xa1 14dBm): Ad-Hoc not supported
Jan  9 17:47:45 rainbow kernel: [   17.976459] ieee80211 phy0: U iwl3945_init_channel_map Ch. 42 Flags 0 [5.2GHz] - No traffic
Jan  9 17:47:45 rainbow kernel: [   17.976524] ieee80211 phy0: U iwl3945_init_channel_map Ch. 44 [5.2GHz] VALID WIDE DFS (0xa1 14dBm): Ad-Hoc not supported
Jan  9 17:47:45 rainbow kernel: [   17.976592] ieee80211 phy0: U iwl3945_init_channel_map Ch. 46 Flags 0 [5.2GHz] - No traffic
Jan  9 17:47:45 rainbow kernel: [   17.976662] ieee80211 phy0: U iwl3945_init_channel_map Ch. 48 [5.2GHz] VALID WIDE DFS (0xa1 14dBm): Ad-Hoc not supported
Jan  9 17:47:45 rainbow kernel: [   17.976732] ieee80211 phy0: U iwl3945_init_channel_map Ch. 52 [5.2GHz] VALID RADAR WIDE DFS (0xb1 14dBm): Ad-Hoc not supported
Jan  9 17:47:45 rainbow kernel: [   17.976805] ieee80211 phy0: U iwl3945_init_channel_map Ch. 56 [5.2GHz] VALID RADAR WIDE DFS (0xb1 14dBm): Ad-Hoc not supported
Jan  9 17:47:45 rainbow kernel: [   17.976876] ieee80211 phy0: U iwl3945_init_channel_map Ch. 60 [5.2GHz] VALID RADAR WIDE DFS (0xb1 14dBm): Ad-Hoc not supported
Jan  9 17:47:45 rainbow kernel: [   17.976951] ieee80211 phy0: U iwl3945_init_channel_map Ch. 64 [5.2GHz] VALID RADAR WIDE DFS (0xb1 14dBm): Ad-Hoc not supported
Jan  9 17:47:45 rainbow kernel: [   17.977026] ieee80211 phy0: U iwl3945_init_channel_map Ch. 100 Flags 0 [5.2GHz] - No traffic
Jan  9 17:47:45 rainbow kernel: [   17.977096] ieee80211 phy0: U iwl3945_init_channel_map Ch. 104 Flags 0 [5.2GHz] - No traffic
Jan  9 17:47:45 rainbow kernel: [   17.977170] ieee80211 phy0: U iwl3945_init_channel_map Ch. 108 Flags 0 [5.2GHz] - No traffic
Jan  9 17:47:45 rainbow kernel: [   17.977238] ieee80211 phy0: U iwl3945_init_channel_map Ch. 112 Flags 0 [5.2GHz] - No traffic
Jan  9 17:47:45 rainbow kernel: [   17.977307] ieee80211 phy0: U iwl3945_init_channel_map Ch. 116 Flags 0 [5.2GHz] - No traffic
Jan  9 17:47:45 rainbow kernel: [   17.977374] ieee80211 phy0: U iwl3945_init_channel_map Ch. 120 Flags 0 [5.2GHz] - No traffic
Jan  9 17:47:45 rainbow kernel: [   17.977447] ieee80211 phy0: U iwl3945_init_channel_map Ch. 124 Flags 0 [5.2GHz] - No traffic
Jan  9 17:47:45 rainbow kernel: [   17.977513] ieee80211 phy0: U iwl3945_init_channel_map Ch. 128 Flags 0 [5.2GHz] - No traffic
Jan  9 17:47:45 rainbow kernel: [   17.977580] ieee80211 phy0: U iwl3945_init_channel_map Ch. 132 Flags 0 [5.2GHz] - No traffic
Jan  9 17:47:45 rainbow kernel: [   17.977656] ieee80211 phy0: U iwl3945_init_channel_map Ch. 136 Flags 0 [5.2GHz] - No traffic
Jan  9 17:47:45 rainbow kernel: [   17.977723] ieee80211 phy0: U iwl3945_init_channel_map Ch. 140 Flags 0 [5.2GHz] - No traffic
Jan  9 17:47:45 rainbow kernel: [   17.977788] ieee80211 phy0: U iwl3945_init_channel_map Ch. 145 Flags 0 [5.2GHz] - No traffic
Jan  9 17:47:45 rainbow kernel: [   17.977853] ieee80211 phy0: U iwl3945_init_channel_map Ch. 149 [5.2GHz] VALID WIDE (0x21 16dBm): Ad-Hoc not supported
Jan  9 17:47:45 rainbow kernel: [   17.977924] ieee80211 phy0: U iwl3945_init_channel_map Ch. 153 [5.2GHz] VALID WIDE (0x21 16dBm): Ad-Hoc not supported
Jan  9 17:47:45 rainbow kernel: [   17.977991] ieee80211 phy0: U iwl3945_init_channel_map Ch. 157 [5.2GHz] VALID WIDE (0x21 16dBm): Ad-Hoc not supported
Jan  9 17:47:45 rainbow kernel: [   17.978060] ieee80211 phy0: U iwl3945_init_channel_map Ch. 161 [5.2GHz] VALID WIDE (0x21 16dBm): Ad-Hoc not supported
Jan  9 17:47:45 rainbow kernel: [   17.978128] ieee80211 phy0: U iwl3945_init_channel_map Ch. 165 [5.2GHz] VALID WIDE (0x21 16dBm): Ad-Hoc not supported
Jan  9 17:47:45 rainbow kernel: [   17.978209] ieee80211 phy0: U iwl3945_hw_reg_txpower_get_temperature Temperature: 260
Jan  9 17:47:45 rainbow kernel: [   17.978274] ieee80211 phy0: U iwl3945_hw_reg_init_channel_groups Initializing factory calib info from EEPROM
Jan  9 17:47:45 rainbow kernel: [   17.978342] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl 1 mapped to grp 0
Jan  9 17:47:45 rainbow kernel: [   17.978406] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta index for channel 1: -21 [260]
Jan  9 17:47:45 rainbow kernel: [   17.978474] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl 2 mapped to grp 0
Jan  9 17:47:45 rainbow kernel: [   17.978537] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta index for channel 2: -21 [260]
Jan  9 17:47:45 rainbow kernel: [   17.978603] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl 3 mapped to grp 0
Jan  9 17:47:45 rainbow kernel: [   17.978667] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta index for channel 3: -21 [260]
Jan  9 17:47:45 rainbow kernel: [   17.978740] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl 4 mapped to grp 0
Jan  9 17:47:45 rainbow kernel: [   17.978805] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta index for channel 4: -21 [260]
Jan  9 17:47:45 rainbow kernel: [   17.978873] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl 5 mapped to grp 0
Jan  9 17:47:45 rainbow kernel: [   17.978939] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta index for channel 5: -21 [260]
Jan  9 17:47:45 rainbow kernel: [   17.979009] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl 6 mapped to grp 0
Jan  9 17:47:45 rainbow kernel: [   17.979073] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta index for channel 6: -21 [260]
Jan  9 17:47:45 rainbow kernel: [   17.979142] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl 7 mapped to grp 0
Jan  9 17:47:45 rainbow kernel: [   17.979208] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta index for channel 7: -21 [260]
Jan  9 17:47:45 rainbow kernel: [   17.979280] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl 8 mapped to grp 0
Jan  9 17:47:45 rainbow kernel: [   17.979346] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta index for channel 8: -21 [260]
Jan  9 17:47:45 rainbow kernel: [   17.979414] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl 9 mapped to grp 0
Jan  9 17:47:45 rainbow kernel: [   17.979479] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta index for channel 9: -21 [260]
Jan  9 17:47:45 rainbow kernel: [   17.979548] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl 10 mapped to grp 0
Jan  9 17:47:45 rainbow kernel: [   17.979615] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta index for channel 10: -21 [260]
Jan  9 17:47:45 rainbow kernel: [   17.979684] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl 11 mapped to grp 0
Jan  9 17:47:45 rainbow kernel: [   17.979749] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta index for channel 11: -21 [260]
Jan  9 17:47:45 rainbow kernel: [   17.979821] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl 36 mapped to grp 1
Jan  9 17:47:45 rainbow kernel: [   17.979888] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta index for channel 36: -21 [260]
Jan  9 17:47:45 rainbow kernel: [   17.979954] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl 40 mapped to grp 1
Jan  9 17:47:45 rainbow kernel: [   17.980041] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta index for channel 40: -21 [260]
Jan  9 17:47:45 rainbow kernel: [   17.980108] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl 44 mapped to grp 1
Jan  9 17:47:45 rainbow kernel: [   17.980173] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta index for channel 44: -21 [260]
Jan  9 17:47:45 rainbow kernel: [   17.980239] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl 48 mapped to grp 2
Jan  9 17:47:45 rainbow kernel: [   17.980303] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta index for channel 48: -21 [260]
Jan  9 17:47:45 rainbow kernel: [   17.980375] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl 52 mapped to grp 2
Jan  9 17:47:45 rainbow kernel: [   17.980439] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta index for channel 52: -21 [260]
Jan  9 17:47:45 rainbow kernel: [   17.980505] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl 56 mapped to grp 2
Jan  9 17:47:45 rainbow kernel: [   17.980569] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta index for channel 56: -21 [260]
Jan  9 17:47:45 rainbow kernel: [   17.980637] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl 60 mapped to grp 2
Jan  9 17:47:45 rainbow kernel: [   17.980702] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta index for channel 60: -21 [260]
Jan  9 17:47:45 rainbow kernel: [   17.980768] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl 64 mapped to grp 2
Jan  9 17:47:45 rainbow kernel: [   17.980832] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta index for channel 64: -21 [260]
Jan  9 17:47:45 rainbow kernel: [   17.980904] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl 149 mapped to grp 4
Jan  9 17:47:45 rainbow kernel: [   17.980969] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta index for channel 149: -21 [260]
Jan  9 17:47:45 rainbow kernel: [   17.981043] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl 153 mapped to grp 4
Jan  9 17:47:45 rainbow kernel: [   17.981113] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta index for channel 153: -21 [260]
Jan  9 17:47:45 rainbow kernel: [   17.981185] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl 157 mapped to grp 4
Jan  9 17:47:45 rainbow kernel: [   17.981859] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta index for channel 157: -21 [260]
Jan  9 17:47:45 rainbow kernel: [   17.981927] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl 161 mapped to grp 4
Jan  9 17:47:45 rainbow kernel: [   17.981994] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta index for channel 161: -21 [260]
Jan  9 17:47:45 rainbow kernel: [   17.982063] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl 165 mapped to grp 4
Jan  9 17:47:45 rainbow kernel: [   17.982147] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta index for channel 165: -21 [260]
Jan  9 17:47:45 rainbow kernel: [   17.992920] ieee80211 phy0: U iwl3945_init_geos Channel 1 Freq=2412[2.4GHz] valid flag=00
Jan  9 17:47:45 rainbow kernel: [   17.992994] ieee80211 phy0: U iwl3945_init_geos Channel 2 Freq=2417[2.4GHz] valid flag=00
Jan  9 17:47:45 rainbow kernel: [   17.993063] ieee80211 phy0: U iwl3945_init_geos Channel 3 Freq=2422[2.4GHz] valid flag=00
Jan  9 17:47:45 rainbow kernel: [   17.993128] ieee80211 phy0: U iwl3945_init_geos Channel 4 Freq=2427[2.4GHz] valid flag=00
Jan  9 17:47:45 rainbow kernel: [   17.993193] ieee80211 phy0: U iwl3945_init_geos Channel 5 Freq=2432[2.4GHz] valid flag=00
Jan  9 17:47:45 rainbow kernel: [   17.993260] ieee80211 phy0: U iwl3945_init_geos Channel 6 Freq=2437[2.4GHz] valid flag=00
Jan  9 17:47:45 rainbow kernel: [   17.993328] ieee80211 phy0: U iwl3945_init_geos Channel 7 Freq=2442[2.4GHz] valid flag=00
Jan  9 17:47:45 rainbow kernel: [   17.993395] ieee80211 phy0: U iwl3945_init_geos Channel 8 Freq=2447[2.4GHz] valid flag=00
Jan  9 17:47:45 rainbow kernel: [   17.993460] ieee80211 phy0: U iwl3945_init_geos Channel 9 Freq=2452[2.4GHz] valid flag=00
Jan  9 17:47:45 rainbow kernel: [   17.993533] ieee80211 phy0: U iwl3945_init_geos Channel 10 Freq=2457[2.4GHz] valid flag=00
Jan  9 17:47:45 rainbow kernel: [   17.993598] ieee80211 phy0: U iwl3945_init_geos Channel 11 Freq=2462[2.4GHz] valid flag=00
Jan  9 17:47:45 rainbow kernel: [   17.993665] ieee80211 phy0: U iwl3945_init_geos Channel 36 Freq=5180[5.2GHz] valid flag=06
Jan  9 17:47:45 rainbow kernel: [   17.993731] ieee80211 phy0: U iwl3945_init_geos Channel 40 Freq=5200[5.2GHz] valid flag=06
Jan  9 17:47:45 rainbow kernel: [   17.993797] ieee80211 phy0: U iwl3945_init_geos Channel 44 Freq=5220[5.2GHz] valid flag=06
Jan  9 17:47:45 rainbow kernel: [   17.993863] ieee80211 phy0: U iwl3945_init_geos Channel 48 Freq=5240[5.2GHz] valid flag=06
Jan  9 17:47:45 rainbow kernel: [   17.993929] ieee80211 phy0: U iwl3945_init_geos Channel 52 Freq=5260[5.2GHz] valid flag=0E
Jan  9 17:47:45 rainbow kernel: [   17.993993] ieee80211 phy0: U iwl3945_init_geos Channel 56 Freq=5280[5.2GHz] valid flag=0E
Jan  9 17:47:45 rainbow kernel: [   17.994063] ieee80211 phy0: U iwl3945_init_geos Channel 60 Freq=5300[5.2GHz] valid flag=0E
Jan  9 17:47:45 rainbow kernel: [   17.994129] ieee80211 phy0: U iwl3945_init_geos Channel 64 Freq=5320[5.2GHz] valid flag=0E
Jan  9 17:47:45 rainbow kernel: [   17.994195] ieee80211 phy0: U iwl3945_init_geos Channel 149 Freq=5745[5.2GHz] valid flag=06
Jan  9 17:47:45 rainbow kernel: [   17.994263] ieee80211 phy0: U iwl3945_init_geos Channel 153 Freq=5765[5.2GHz] valid flag=06
Jan  9 17:47:45 rainbow kernel: [   17.994331] ieee80211 phy0: U iwl3945_init_geos Channel 157 Freq=5785[5.2GHz] valid flag=06
Jan  9 17:47:45 rainbow kernel: [   17.994397] ieee80211 phy0: U iwl3945_init_geos Channel 161 Freq=5805[5.2GHz] valid flag=06
Jan  9 17:47:45 rainbow kernel: [   17.994463] ieee80211 phy0: U iwl3945_init_geos Channel 165 Freq=5825[5.2GHz] valid flag=06
Jan  9 17:47:45 rainbow kernel: [   17.994530] iwl3945 0000:03:00.0: Tunable channels: 11 802.11bg, 13 802.11a channels
Jan  9 17:47:45 rainbow kernel: [   17.994601] iwl3945 0000:03:00.0: Detected Intel Wireless WiFi Link 3945ABG
Jan  9 17:47:45 rainbow kernel: [   17.994672] ieee80211 phy0: U iwl3945_set_rxon_channel Staging channel set to 6 [0]
Jan  9 17:47:45 rainbow kernel: [   17.996294] iwl3945 0000:03:00.0: PCI INT A disabled
Jan  9 17:47:45 rainbow kernel: [   17.996688] phy0: Selected rate control algorithm 'iwl-3945-rs'
Jan  9 17:47:45 rainbow kernel: [   18.414901] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
Jan  9 17:47:45 rainbow kernel: [   18.414976] hda_intel: probe_mask set to 0x1 for device 17aa:20ac
Jan  9 17:47:45 rainbow kernel: [   18.415146] HDA Intel 0000:00:1b.0: setting latency timer to 64
Jan  9 17:47:45 rainbow kernel: [   19.455115] Adding 4803392k swap on /dev/sda5.  Priority:-1 extents:1 across:4803392k
Jan  9 17:47:45 rainbow kernel: [   19.913638] EXT3 FS on sda1, internal journal
Jan  9 17:47:45 rainbow kernel: [   20.423709] ip_tables: (C) 2000-2006 Netfilter Core Team
Jan  9 17:47:45 rainbow kernel: [   22.530612] warning: `avahi-daemon' uses 32-bit capabilities (legacy support in use)
Jan  9 17:47:45 rainbow kernel: [   23.130249] IBM TrackPoint firmware: 0x0e, buttons: 3/3
Jan  9 17:47:46 rainbow kernel: [   23.368300] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/serio2/input/input8
Jan  9 17:47:50 rainbow kernel: [   27.916345] [drm] Initialized drm 1.1.0 20060810
Jan  9 17:47:50 rainbow kernel: [   28.015947] pci 0000:00:02.0: power state changed by ACPI to D0
Jan  9 17:47:50 rainbow kernel: [   28.015966] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Jan  9 17:47:50 rainbow kernel: [   28.015975] pci 0000:00:02.0: setting latency timer to 64
Jan  9 17:47:50 rainbow kernel: [   28.016347] pci 0000:00:02.0: irq 2296 for MSI/MSI-X
Jan  9 17:47:50 rainbow kernel: [   28.016597] [drm] Initialized i915 1.6.0 20080730 on minor 0
Jan  9 17:47:50 rainbow kernel: [   28.049430] mtrr: type mismatch for e0000000,10000000 old: write-back new: write-combining
Jan  9 17:47:51 rainbow kernel: [   28.924885] ieee80211 phy0: U iwl3945_mac_start enter
Jan  9 17:47:51 rainbow kernel: [   28.924910] iwl3945 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
Jan  9 17:47:51 rainbow kernel: [   28.925089] iwl3945 0000:03:00.0: restoring config space at offset 0x1 (was 0x100102, writing 0x100106)
Jan  9 17:47:51 rainbow kernel: [   28.925276] iwl3945 0000:03:00.0: irq 2295 for MSI/MSI-X
Jan  9 17:47:51 rainbow kernel: [   28.925381] iwl3945 0000:03:00.0: firmware: requesting iwlwifi-3945-2.ucode
Jan  9 17:47:51 rainbow kernel: [   29.002640] ieee80211 phy0: U iwl3945_read_ucode Got firmware 'iwlwifi-3945-2.ucode' file (149816 bytes) from disk
Jan  9 17:47:51 rainbow kernel: [   29.002659] iwl3945 0000:03:00.0: loaded firmware version 15.28.2.8
Jan  9 17:47:51 rainbow kernel: [   29.002664] ieee80211 phy0: U iwl3945_read_ucode f/w package hdr ucode version raw = 0xf1c0208
Jan  9 17:47:51 rainbow kernel: [   29.002673] ieee80211 phy0: U iwl3945_read_ucode f/w package hdr runtime inst size = 80684
Jan  9 17:47:51 rainbow kernel: [   29.002680] ieee80211 phy0: U iwl3945_read_ucode f/w package hdr runtime data size = 32768
Jan  9 17:47:51 rainbow kernel: [   29.002688] ieee80211 phy0: U iwl3945_read_ucode f/w package hdr init inst size = 2672
Jan  9 17:47:51 rainbow kernel: [   29.002695] ieee80211 phy0: U iwl3945_read_ucode f/w package hdr init data size = 32768
Jan  9 17:47:51 rainbow kernel: [   29.002702] ieee80211 phy0: U iwl3945_read_ucode f/w package hdr boot inst size = 900
Jan  9 17:47:51 rainbow kernel: [   29.002855] ieee80211 phy0: U iwl3945_read_ucode Copying (but not loading) uCode instr len 80684
Jan  9 17:47:51 rainbow kernel: [   29.002897] ieee80211 phy0: U iwl3945_read_ucode uCode instr buf vaddr = 0xffff8800bb880000, paddr = 0xbb880000
Jan  9 17:47:51 rainbow kernel: [   29.002906] ieee80211 phy0: U iwl3945_read_ucode Copying (but not loading) uCode data len 32768
Jan  9 17:47:51 rainbow kernel: [   29.002959] ieee80211 phy0: U iwl3945_read_ucode Copying (but not loading) init instr len 2672
Jan  9 17:47:51 rainbow kernel: [   29.002970] ieee80211 phy0: U iwl3945_read_ucode Copying (but not loading) init data len 32768
Jan  9 17:47:51 rainbow kernel: [   29.003002] ieee80211 phy0: U iwl3945_read_ucode Copying (but not loading) boot instr len 900
Jan  9 17:47:51 rainbow kernel: [   29.003036] ieee80211 phy0: U iwl3945_power_init_handle Initialize power 
Jan  9 17:47:51 rainbow kernel: [   29.003052] ieee80211 phy0: U iwl3945_power_init_handle adjust power command flags
Jan  9 17:47:51 rainbow kernel: [   29.003167] ieee80211 phy0: U iwl3945_hw_nic_init HW Revision ID = 0x2
Jan  9 17:47:51 rainbow kernel: [   29.003220] ieee80211 phy0: U iwl3945_nic_config 3945 RADIO-MM type
Jan  9 17:47:51 rainbow kernel: [   29.003232] ieee80211 phy0: U iwl3945_nic_config SKU OP mode is basic
Jan  9 17:47:51 rainbow kernel: [   29.003239] ieee80211 phy0: U iwl3945_nic_config 3945ABG revision is 0xF1
Jan  9 17:47:51 rainbow kernel: [   29.003252] ieee80211 phy0: U iwl3945_nic_config Card M type B version is 0x3
Jan  9 17:47:51 rainbow kernel: [   29.004473] ieee80211 phy0: U iwl3945_load_bsm Begin load bsm
Jan  9 17:47:51 rainbow kernel: [   29.005742] ieee80211 phy0: U iwl3945_verify_bsm Begin verify bsm
Jan  9 17:47:51 rainbow kernel: [   29.007978] ieee80211 phy0: U iwl3945_verify_bsm BSM bootstrap uCode image OK
Jan  9 17:47:51 rainbow kernel: [   29.008038] ieee80211 phy0: U iwl3945_load_bsm BSM write complete, poll 1 iterations
Jan  9 17:47:51 rainbow kernel: [   29.008057] ieee80211 phy0: U __iwl3945_up iwl3945 is coming up
Jan  9 17:47:51 rainbow kernel: [   29.008068] ieee80211 phy0: U iwl3945_mac_start Start UP work.
Jan  9 17:47:51 rainbow kernel: [   29.019523] ieee80211 phy0: I iwl3945_rx_handle r = 1, i = 0, REPLY_ALIVE, 0x01
Jan  9 17:47:51 rainbow kernel: [   29.019536] ieee80211 phy0: I iwl3945_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x9
Jan  9 17:47:51 rainbow kernel: [   29.019544] ieee80211 phy0: I iwl3945_rx_reply_alive Initialization Alive received.
Jan  9 17:47:51 rainbow kernel: [   29.025074] ieee80211 phy0: U iwl3945_verify_inst_sparse ucode inst image size is 900
Jan  9 17:47:51 rainbow kernel: [   29.025174] ieee80211 phy0: U iwl3945_verify_inst_sparse ucode inst image size is 2672
Jan  9 17:47:51 rainbow kernel: [   29.025461] ieee80211 phy0: U iwl3945_verify_ucode Initialize uCode is good in inst SRAM
Jan  9 17:47:51 rainbow kernel: [   29.025468] ieee80211 phy0: U iwl3945_init_alive_start Initialization Alive received.
Jan  9 17:47:51 rainbow kernel: [   29.025518] ieee80211 phy0: U iwl3945_set_ucode_ptrs Runtime uCode pointers are set.
Jan  9 17:47:51 rainbow kernel: [   29.029869] ieee80211 phy0: I iwl3945_rx_handle r = 2, i = 1, REPLY_ALIVE, 0x01
Jan  9 17:47:51 rainbow kernel: [   29.029879] ieee80211 phy0: I iwl3945_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x0
Jan  9 17:47:51 rainbow kernel: [   29.029887] ieee80211 phy0: I iwl3945_rx_reply_alive Runtime Alive received.
Jan  9 17:47:51 rainbow kernel: [   29.029935] ieee80211 phy0: I iwl3945_disable_events Selected uCode log events may be disabled
Jan  9 17:47:51 rainbow kernel: [   29.029942] ieee80211 phy0: I iwl3945_disable_events   by writing "1"s into disable bitmap
Jan  9 17:47:51 rainbow kernel: [   29.029950] ieee80211 phy0: I iwl3945_disable_events   in SRAM at 0x8022c8, size 47 u32s
Jan  9 17:47:51 rainbow kernel: [   29.037061] ieee80211 phy0: U iwl3945_alive_start Runtime Alive received.
Jan  9 17:47:51 rainbow kernel: [   29.037072] ieee80211 phy0: U iwl3945_verify_inst_sparse ucode inst image size is 900
Jan  9 17:47:51 rainbow kernel: [   29.037158] ieee80211 phy0: U iwl3945_verify_inst_sparse ucode inst image size is 2672
Jan  9 17:47:51 rainbow kernel: [   29.037244] ieee80211 phy0: U iwl3945_verify_inst_sparse ucode inst image size is 80684
Jan  9 17:47:51 rainbow kernel: [   29.045074] ieee80211 phy0: U iwl3945_verify_ucode Runtime uCode is good in inst SRAM
Jan  9 17:47:51 rainbow kernel: [   29.045109] ieee80211 phy0: U iwl3945_alive_start RFKILL status: 0x1
Jan  9 17:47:51 rainbow kernel: [   29.045135] ieee80211 phy0: U iwl3945_update_power_cmd Flags value = 0x00000009
Jan  9 17:47:51 rainbow kernel: [   29.045142] ieee80211 phy0: U iwl3945_update_power_cmd Tx timeout = 102400
Jan  9 17:47:51 rainbow kernel: [   29.045149] ieee80211 phy0: U iwl3945_update_power_cmd Rx timeout = 51200
Jan  9 17:47:51 rainbow kernel: [   29.045156] ieee80211 phy0: U iwl3945_update_power_cmd Sleep interval vector = { 1 , 1 , 1 , 1 , 1 }
Jan  9 17:47:51 rainbow kernel: [   29.045169] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command POWER_TABLE_CMD (#77), seq: 0x0400, 36 bytes at 0[0]:4
Jan  9 17:47:51 rainbow kernel: [   29.045253] ieee80211 phy0: I iwl3945_rx_handle r 3 i 2 No handler needed for POWER_TABLE_CMD, 0x77
Jan  9 17:47:51 rainbow kernel: [   29.048661] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_BT_CONFIG (#9b), seq: 0x0401, 16 bytes at 1[1]:4
Jan  9 17:47:51 rainbow kernel: [   29.048721] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Jan  9 17:47:51 rainbow kernel: [   29.058302] ieee80211 phy0: I iwl3945_rx_handle r 4 i 3 No handler needed for REPLY_BT_CONFIG, 0x9b
Jan  9 17:47:51 rainbow kernel: [   29.058372] ieee80211 phy0: U iwl3945_commit_rxon Sending RXON
Jan  9 17:47:51 rainbow kernel: [   29.058375] * without RXON_FILTER_ASSOC_MSK
Jan  9 17:47:51 rainbow kernel: [   29.058377] * channel = 1
Jan  9 17:47:51 rainbow kernel: [   29.058379] * bssid = 00:00:00:00:00:00
Jan  9 17:47:51 rainbow kernel: [   29.058403] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x0402, 48 bytes at 2[2]:4
Jan  9 17:47:51 rainbow kernel: [   29.058423] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Jan  9 17:47:51 rainbow kernel: [   29.061429] ieee80211 phy0: I iwl3945_rx_handle r 5 i 4 No handler needed for REPLY_RXON, 0x10
Jan  9 17:47:51 rainbow kernel: [   29.062303] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 187 dsp  99 rate code 0x0d
Jan  9 17:47:51 rainbow kernel: [   29.062314] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 187 dsp  99 rate code 0x0f
Jan  9 17:47:51 rainbow kernel: [   29.062323] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 187 dsp  99 rate code 0x05
Jan  9 17:47:51 rainbow kernel: [   29.062331] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 187 dsp  99 rate code 0x07
Jan  9 17:47:51 rainbow kernel: [   29.062340] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 187 dsp  99 rate code 0x09
Jan  9 17:47:51 rainbow kernel: [   29.062348] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 187 dsp  99 rate code 0x0b
Jan  9 17:47:51 rainbow kernel: [   29.062356] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 187 dsp  99 rate code 0x01
Jan  9 17:47:51 rainbow kernel: [   29.062364] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 187 dsp  99 rate code 0x03
Jan  9 17:47:51 rainbow kernel: [   29.062372] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 179 dsp 107 rate code 0x0a
Jan  9 17:47:51 rainbow kernel: [   29.062381] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 179 dsp 107 rate code 0x14
Jan  9 17:47:51 rainbow kernel: [   29.062390] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 179 dsp 107 rate code 0x37
Jan  9 17:47:51 rainbow kernel: [   29.062398] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 179 dsp 107 rate code 0x6e
Jan  9 17:47:51 rainbow kernel: [   29.062409] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0403, 56 bytes at 3[3]:4
Jan  9 17:47:51 rainbow kernel: [   29.062424] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Jan  9 17:47:51 rainbow kernel: [   29.064305] ieee80211 phy0: I iwl3945_rx_handle r 6 i 5 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
Jan  9 17:47:51 rainbow kernel: [   29.064360] ieee80211 phy0: U iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
Jan  9 17:47:51 rainbow kernel: [   29.064373] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0404, 68 bytes at 4[4]:4
Jan  9 17:47:51 rainbow kernel: [   29.064387] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Jan  9 17:47:51 rainbow kernel: [   29.067156] ieee80211 phy0: I iwl3945_rx_handle r = 7, i = 6, REPLY_ADD_STA, 0x18
Jan  9 17:47:51 rainbow kernel: [   29.068028] ieee80211 phy0: U iwl3945_send_add_station REPLY_ADD_STA PASSED
Jan  9 17:47:51 rainbow kernel: [   29.068043] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0405, 56 bytes at 5[5]:4
Jan  9 17:47:51 rainbow kernel: [   29.068059] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Jan  9 17:47:51 rainbow kernel: [   29.069995] ieee80211 phy0: I iwl3945_rx_handle r 8 i 7 No handler needed for REPLY_RATE_SCALE, 0x47
Jan  9 17:47:51 rainbow kernel: [   29.072221] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0406, 56 bytes at 6[6]:4
Jan  9 17:47:51 rainbow kernel: [   29.072281] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Jan  9 17:47:51 rainbow kernel: [   29.082833] ieee80211 phy0: I iwl3945_rx_handle r 9 i 8 No handler needed for REPLY_RATE_SCALE, 0x47
Jan  9 17:47:51 rainbow kernel: [   29.082876] ieee80211 phy0: U iwl3945_hw_reg_txpower_get_temperature Temperature: 66
Jan  9 17:47:51 rainbow kernel: [   29.082884] ieee80211 phy0: U is_temp_calib_needed Getting cooler, delta -194,
Jan  9 17:47:51 rainbow kernel: [   29.082891] ieee80211 phy0: U is_temp_calib_needed Timed thermal calib needed
Jan  9 17:47:51 rainbow kernel: [   29.082913] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x0d
Jan  9 17:47:51 rainbow kernel: [   29.082921] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x0f
Jan  9 17:47:51 rainbow kernel: [   29.082929] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x05
Jan  9 17:47:51 rainbow kernel: [   29.082937] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x07
Jan  9 17:47:51 rainbow kernel: [   29.082945] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x09
Jan  9 17:47:51 rainbow kernel: [   29.082952] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x0b
Jan  9 17:47:51 rainbow kernel: [   29.082961] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x01
Jan  9 17:47:51 rainbow kernel: [   29.082969] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x03
Jan  9 17:47:51 rainbow kernel: [   29.082977] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 171 dsp  98 rate code 0x0a
Jan  9 17:47:51 rainbow kernel: [   29.082985] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 171 dsp  98 rate code 0x14
Jan  9 17:47:51 rainbow kernel: [   29.082993] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 171 dsp  98 rate code 0x37
Jan  9 17:47:51 rainbow kernel: [   29.083001] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 171 dsp  98 rate code 0x6e
Jan  9 17:47:51 rainbow kernel: [   29.083013] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0407, 56 bytes at 7[7]:4
Jan  9 17:47:51 rainbow kernel: [   29.083027] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Jan  9 17:47:51 rainbow kernel: [   29.085662] ieee80211 phy0: I iwl3945_rx_handle r 10 i 9 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
Jan  9 17:47:51 rainbow kernel: [   29.107451] Registered led device: iwl-phy0:radio
Jan  9 17:47:51 rainbow kernel: [   29.107462] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0408, 12 bytes at 8[8]:4
Jan  9 17:47:51 rainbow kernel: [   29.107523] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Jan  9 17:47:51 rainbow kernel: [   29.107572] Registered led device: iwl-phy0:assoc
Jan  9 17:47:51 rainbow kernel: [   29.107608] Registered led device: iwl-phy0:RX
Jan  9 17:47:51 rainbow kernel: [   29.107643] Registered led device: iwl-phy0:TX
Jan  9 17:47:51 rainbow kernel: [   29.107648] ieee80211 phy0: U iwl3945_alive_start ALIVE processing complete.
Jan  9 17:47:51 rainbow kernel: [   29.107665] ieee80211 phy0: U iwl3945_mac_start leave
Jan  9 17:47:51 rainbow kernel: [   29.107692] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0409, 12 bytes at 9[9]:4
Jan  9 17:47:51 rainbow kernel: [   29.107748] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Jan  9 17:47:51 rainbow kernel: [   29.107765] ieee80211 phy0: U iwl3945_mac_add_interface enter: type 2
Jan  9 17:47:51 rainbow kernel: [   29.107774] ieee80211 phy0: U iwl3945_mac_add_interface Set: 00:1f:3c:20:a1:6e
Jan  9 17:47:51 rainbow kernel: [   29.107788] ieee80211 phy0: U iwl3945_commit_rxon Sending RXON
Jan  9 17:47:51 rainbow kernel: [   29.107790] * without RXON_FILTER_ASSOC_MSK
Jan  9 17:47:51 rainbow kernel: [   29.107792] * channel = 1
Jan  9 17:47:51 rainbow kernel: [   29.107793] * bssid = 00:00:00:00:00:00
Jan  9 17:47:51 rainbow kernel: [   29.107810] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x040A, 48 bytes at 10[10]:4
Jan  9 17:47:51 rainbow kernel: [   29.107824] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Jan  9 17:47:51 rainbow kernel: [   29.118027] ieee80211 phy0: I iwl3945_rx_handle r 12 i 10 No handler needed for REPLY_LEDS_CMD, 0x48
Jan  9 17:47:51 rainbow kernel: [   29.118056] ieee80211 phy0: I iwl3945_rx_handle r 12 i 11 No handler needed for REPLY_LEDS_CMD, 0x48
Jan  9 17:47:51 rainbow kernel: [   29.118196] ieee80211 phy0: I iwl3945_rx_handle r 13 i 12 No handler needed for REPLY_RXON, 0x10
Jan  9 17:47:51 rainbow kernel: [   29.118230] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x0d
Jan  9 17:47:51 rainbow kernel: [   29.118240] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x0f
Jan  9 17:47:51 rainbow kernel: [   29.118248] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x05
Jan  9 17:47:51 rainbow kernel: [   29.118255] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x07
Jan  9 17:47:51 rainbow kernel: [   29.118264] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x09
Jan  9 17:47:51 rainbow kernel: [   29.118272] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x0b
Jan  9 17:47:51 rainbow kernel: [   29.118279] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x01
Jan  9 17:47:51 rainbow kernel: [   29.118343] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x03
Jan  9 17:47:51 rainbow kernel: [   29.118351] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 171 dsp  98 rate code 0x0a
Jan  9 17:47:51 rainbow kernel: [   29.118359] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 171 dsp  98 rate code 0x14
Jan  9 17:47:51 rainbow kernel: [   29.118367] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 171 dsp  98 rate code 0x37
Jan  9 17:47:51 rainbow kernel: [   29.118375] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 171 dsp  98 rate code 0x6e
Jan  9 17:47:51 rainbow kernel: [   29.118388] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x040B, 56 bytes at 11[11]:4
Jan  9 17:47:51 rainbow kernel: [   29.118402] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Jan  9 17:47:51 rainbow kernel: [   29.121061] ieee80211 phy0: I iwl3945_rx_handle r 14 i 13 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
Jan  9 17:47:51 rainbow kernel: [   29.121116] ieee80211 phy0: U iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
Jan  9 17:47:51 rainbow kernel: [   29.121131] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x040C, 68 bytes at 12[12]:4
Jan  9 17:47:51 rainbow kernel: [   29.121146] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Jan  9 17:47:51 rainbow kernel: [   29.123857] ieee80211 phy0: I iwl3945_rx_handle r = 15, i = 14, REPLY_ADD_STA, 0x18
Jan  9 17:47:51 rainbow kernel: [   29.123894] ieee80211 phy0: U iwl3945_send_add_station REPLY_ADD_STA PASSED
Jan  9 17:47:51 rainbow kernel: [   29.123910] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x040D, 56 bytes at 13[13]:4
Jan  9 17:47:51 rainbow kernel: [   29.123925] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Jan  9 17:47:51 rainbow kernel: [   29.126693] ieee80211 phy0: I iwl3945_rx_handle r 16 i 15 No handler needed for REPLY_RATE_SCALE, 0x47
Jan  9 17:47:51 rainbow kernel: [   29.127410] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x040E, 56 bytes at 14[14]:4
Jan  9 17:47:51 rainbow kernel: [   29.127429] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Jan  9 17:47:51 rainbow kernel: [   29.129535] ieee80211 phy0: I iwl3945_rx_handle r 17 i 16 No handler needed for REPLY_RATE_SCALE, 0x47
Jan  9 17:47:51 rainbow kernel: [   29.129570] ieee80211 phy0: U iwl3945_mac_add_interface leave
Jan  9 17:47:51 rainbow kernel: [   29.129581] ieee80211 phy0: U iwl3945_bss_info_changed changes = 0xE
Jan  9 17:47:51 rainbow kernel: [   29.129588] ieee80211 phy0: U iwl3945_bss_info_changed ERP_PREAMBLE 0
Jan  9 17:47:51 rainbow kernel: [   29.129594] ieee80211 phy0: U iwl3945_bss_info_changed ERP_CTS 0
Jan  9 17:47:51 rainbow kernel: [   29.141033] ieee80211 phy0: I iwl3945_configure_filter Enter: changed: 0x0, total: 0x80000000
Jan  9 17:47:51 rainbow kernel: [   29.141755] ieee80211 phy0: U iwl3945_mac_config enter to channel 1
Jan  9 17:47:51 rainbow kernel: [   29.141763] ieee80211 phy0: U iwl3945_commit_rxon Sending RXON
Jan  9 17:47:51 rainbow kernel: [   29.141763] * without RXON_FILTER_ASSOC_MSK
Jan  9 17:47:51 rainbow kernel: [   29.141764] * channel = 1
Jan  9 17:47:51 rainbow kernel: [   29.141764] * bssid = 00:00:00:00:00:00
Jan  9 17:47:51 rainbow kernel: [   29.141774] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x040F, 48 bytes at 15[15]:4
Jan  9 17:47:51 rainbow kernel: [   29.141825] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Jan  9 17:47:51 rainbow kernel: [   29.152452] ieee80211 phy0: I iwl3945_rx_handle r 18 i 17 No handler needed for REPLY_RXON, 0x10
Jan  9 17:47:51 rainbow kernel: [   29.152479] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x0d
Jan  9 17:47:51 rainbow kernel: [   29.152483] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x0f
Jan  9 17:47:51 rainbow kernel: [   29.152485] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x05
Jan  9 17:47:51 rainbow kernel: [   29.152488] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x07
Jan  9 17:47:51 rainbow kernel: [   29.152491] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x09
Jan  9 17:47:51 rainbow kernel: [   29.152494] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x0b
Jan  9 17:47:51 rainbow kernel: [   29.152496] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x01
Jan  9 17:47:51 rainbow kernel: [   29.152499] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x03
Jan  9 17:47:51 rainbow kernel: [   29.152502] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 171 dsp  98 rate code 0x0a
Jan  9 17:47:51 rainbow kernel: [   29.152504] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 171 dsp  98 rate code 0x14
Jan  9 17:47:51 rainbow kernel: [   29.152507] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 171 dsp  98 rate code 0x37
Jan  9 17:47:51 rainbow kernel: [   29.152511] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 171 dsp  98 rate code 0x6e
Jan  9 17:47:51 rainbow kernel: [   29.152516] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0410, 56 bytes at 16[16]:4
Jan  9 17:47:51 rainbow kernel: [   29.152530] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Jan  9 17:47:51 rainbow kernel: [   29.155669] ieee80211 phy0: I iwl3945_rx_handle r 19 i 18 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
Jan  9 17:47:51 rainbow kernel: [   29.155683] ieee80211 phy0: U iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
Jan  9 17:47:51 rainbow kernel: [   29.155688] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0411, 68 bytes at 17[17]:4
Jan  9 17:47:51 rainbow kernel: [   29.158912] ieee80211 phy0: I iwl3945_rx_handle r = 20, i = 19, REPLY_ADD_STA, 0x18
Jan  9 17:47:51 rainbow kernel: [   29.158923] ieee80211 phy0: U iwl3945_send_add_station REPLY_ADD_STA PASSED
Jan  9 17:47:51 rainbow kernel: [   29.158929] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0412, 56 bytes at 18[18]:4
Jan  9 17:47:51 rainbow kernel: [   29.162160] ieee80211 phy0: I iwl3945_rx_handle r 21 i 20 No handler needed for REPLY_RATE_SCALE, 0x47
Jan  9 17:47:51 rainbow kernel: [   29.162206] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0413, 56 bytes at 19[19]:4
Jan  9 17:47:51 rainbow kernel: [   29.162216] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Jan  9 17:47:51 rainbow kernel: [   29.165437] ieee80211 phy0: I iwl3945_rx_handle r 22 i 21 No handler needed for REPLY_RATE_SCALE, 0x47
Jan  9 17:47:51 rainbow kernel: [   29.165475] ieee80211 phy0: U iwl3945_mac_config leave
Jan  9 17:47:51 rainbow kernel: [   29.165479] ieee80211 phy0: U iwl3945_mac_conf_tx enter
Jan  9 17:47:51 rainbow kernel: [   29.165482] ieee80211 phy0: U iwl3945_mac_conf_tx leave
Jan  9 17:47:51 rainbow kernel: [   29.165484] ieee80211 phy0: U iwl3945_mac_conf_tx enter
Jan  9 17:47:51 rainbow kernel: [   29.165487] ieee80211 phy0: U iwl3945_mac_conf_tx leave
Jan  9 17:47:51 rainbow kernel: [   29.165489] ieee80211 phy0: U iwl3945_mac_conf_tx enter
Jan  9 17:47:51 rainbow kernel: [   29.165491] ieee80211 phy0: U iwl3945_mac_conf_tx leave
Jan  9 17:47:51 rainbow kernel: [   29.165493] ieee80211 phy0: U iwl3945_mac_conf_tx enter
Jan  9 17:47:51 rainbow kernel: [   29.165496] ieee80211 phy0: U iwl3945_mac_conf_tx leave
Jan  9 17:47:51 rainbow kernel: [   29.165504] ieee80211 phy0: I iwl3945_configure_filter Enter: changed: 0x0, total: 0x80000000
Jan  9 17:47:51 rainbow kernel: [   29.165517] ieee80211 phy0: I iwl3945_configure_filter Enter: changed: 0x0, total: 0x80000000
Jan  9 17:47:51 rainbow kernel: [   29.166203] ieee80211 phy0: I iwl3945_configure_filter Enter: changed: 0x0, total: 0x80000000
Jan  9 17:47:51 rainbow kernel: [   29.166391] ieee80211 phy0: U iwl3945_mac_hw_scan enter
Jan  9 17:47:51 rainbow kernel: [   29.166397] ieee80211 phy0: U iwl3945_scan_initiate Starting scan...
Jan  9 17:47:51 rainbow kernel: [   29.166403] ieee80211 phy0: U iwl3945_mac_hw_scan leave
Jan  9 17:47:51 rainbow kernel: [   29.166410] ieee80211 phy0: U iwl3945_bg_request_scan Kicking off one indirect scan.
Jan  9 17:47:51 rainbow kernel: [   29.166414] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 1 [ACTIVE 39]
Jan  9 17:47:51 rainbow kernel: [   29.166417] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 2 [ACTIVE 39]
Jan  9 17:47:51 rainbow kernel: [   29.166421] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 3 [ACTIVE 39]
Jan  9 17:47:51 rainbow kernel: [   29.166423] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 4 [ACTIVE 39]
Jan  9 17:47:51 rainbow kernel: [   29.166426] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 5 [ACTIVE 39]
Jan  9 17:47:51 rainbow kernel: [   29.166429] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 6 [ACTIVE 39]
Jan  9 17:47:51 rainbow kernel: [   29.166432] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 7 [ACTIVE 39]
Jan  9 17:47:51 rainbow kernel: [   29.166435] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 8 [ACTIVE 39]
Jan  9 17:47:51 rainbow kernel: [   29.166438] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 9 [ACTIVE 39]
Jan  9 17:47:51 rainbow kernel: [   29.166442] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 10 [ACTIVE 39]
Jan  9 17:47:51 rainbow kernel: [   29.166455] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 11 [ACTIVE 39]
Jan  9 17:47:51 rainbow kernel: [   29.166457] ieee80211 phy0: U iwl3945_get_channels_for_scan total channels to scan 11 
Jan  9 17:47:51 rainbow kernel: [   29.166463] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x4414, 351 bytes at 20[32]:4
Jan  9 17:47:51 rainbow kernel: [   29.166473] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Jan  9 17:47:51 rainbow kernel: [   29.168337] ieee80211 phy0: I iwl3945_rx_handle r = 23, i = 22, REPLY_SCAN_CMD, 0x80
Jan  9 17:47:51 rainbow kernel: [   29.169399] ieee80211 phy0: I iwl3945_rx_handle r = 25, i = 23, STATISTICS_NOTIFICATION, 0x9d
Jan  9 17:47:51 rainbow kernel: [   29.169407] ieee80211 phy0: I iwl3945_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0415, 12 bytes at 21[21]:4
Jan  9 17:47:51 rainbow kernel: [   29.169445] ieee80211 phy0: I iwl3945_rx_handle r = 25, i = 24, SCAN_START_NOTIFICATION, 0x82
Jan  9 17:47:51 rainbow kernel: [   29.169450] ieee80211 phy0: I iwl3945_rx_scan_start_notif Scan start: 1 [802.11bg] (TSF: 0x00000000:000024C7) - 1 (beacon timer 92984)
Jan  9 17:47:51 rainbow kernel: [   29.170023] ieee80211 phy0: I iwl3945_rx_handle r 26 i 25 No handler needed for REPLY_LEDS_CMD, 0x48
Jan  9 17:47:51 rainbow kernel: [   29.171366] ieee80211 phy0: I iwl3945_rx_handle r = 27, i = 26, UNKNOWN, 0x1b
Jan  9 17:47:51 rainbow kernel: [   29.173550] ieee80211 phy0: I iwl3945_rx_handle r = 28, i = 27, UNKNOWN, 0x1b
Jan  9 17:47:51 rainbow kernel: [   29.175789] ieee80211 phy0: I iwl3945_rx_handle r = 29, i = 28, UNKNOWN, 0x1b
Jan  9 17:47:51 rainbow kernel: [   29.177683] ieee80211 phy0: I iwl3945_rx_handle r = 30, i = 29, UNKNOWN, 0x1b
Jan  9 17:47:51 rainbow kernel: [   29.180105] ieee80211 phy0: I iwl3945_rx_handle r = 31, i = 30, UNKNOWN, 0x1b
Jan  9 17:47:52 rainbow kernel: [   29.209410] ieee80211 phy0: I iwl3945_rx_handle r = 32, i = 31, SCAN_RESULTS_NOTIFICATION, 0x83
Jan  9 17:47:52 rainbow kernel: [   29.209424] ieee80211 phy0: I iwl3945_rx_scan_results_notif Scan ch.res: 1 [802.11bg] (TSF: 0x00000000:0000C0DE) - 5 elapsed=39959 usec (-270792ms since last)
Jan  9 17:47:52 rainbow kernel: [   29.210461] ieee80211 phy0: I iwl3945_rx_handle r = 34, i = 32, STATISTICS_NOTIFICATION, 0x9d
Jan  9 17:47:52 rainbow kernel: [   29.210470] ieee80211 phy0: I iwl3945_rx_handle r = 34, i = 33, SCAN_START_NOTIFICATION, 0x82
Jan  9 17:47:52 rainbow kernel: [   29.210474] ieee80211 phy0: I iwl3945_rx_scan_start_notif Scan start: 2 [802.11bg] (TSF: 0x00000000:0000C502) - 1 (beacon timer 51965)
Jan  9 17:47:52 rainbow kernel: [   29.223109] ieee80211 phy0: I iwl3945_rx_handle r = 35, i = 34, SCAN_RESULTS_NOTIFICATION, 0x83
Jan  9 17:47:52 rainbow kernel: [   29.223120] ieee80211 phy0: I iwl3945_rx_scan_results_notif Scan ch.res: 2 [802.11bg] (TSF: 0x00000000:0000F674) - 0 elapsed=12658 usec (12ms since last)
Jan  9 17:47:52 rainbow kernel: [   29.224163] ieee80211 phy0: I iwl3945_rx_handle r = 37, i = 35, STATISTICS_NOTIFICATION, 0x9d
Jan  9 17:47:52 rainbow kernel: [   29.224175] ieee80211 phy0: I iwl3945_rx_handle r = 37, i = 36, SCAN_START_NOTIFICATION, 0x82
Jan  9 17:47:52 rainbow kernel: [   29.224181] ieee80211 phy0: I iwl3945_rx_scan_start_notif Scan start: 3 [802.11bg] (TSF: 0x00000000:0000FA9C) - 1 (beacon timer 38244)
Jan  9 17:47:52 rainbow kernel: [   29.236840] ieee80211 phy0: I iwl3945_rx_handle r = 38, i = 37, SCAN_RESULTS_NOTIFICATION, 0x83
Jan  9 17:47:52 rainbow kernel: [   29.236848] ieee80211 phy0: I iwl3945_rx_scan_results_notif Scan ch.res: 3 [802.11bg] (TSF: 0x00000000:00012C1D) - 0 elapsed=12673 usec (16ms since last)
Jan  9 17:47:52 rainbow kernel: [   29.237881] ieee80211 phy0: I iwl3945_rx_handle r = 40, i = 38, STATISTICS_NOTIFICATION, 0x9d
Jan  9 17:47:52 rainbow kernel: [   29.237895] ieee80211 phy0: I iwl3945_rx_handle r = 40, i = 39, SCAN_START_NOTIFICATION, 0x82
Jan  9 17:47:52 rainbow kernel: [   29.237901] ieee80211 phy0: I iwl3945_rx_scan_start_notif Scan start: 4 [802.11bg] (TSF: 0x00000000:00013049) - 1 (beacon timer 24502)
Jan  9 17:47:52 rainbow kernel: [   29.240936] ieee80211 phy0: I iwl3945_rx_handle r = 41, i = 40, UNKNOWN, 0x1b
Jan  9 17:47:52 rainbow kernel: [   29.253011] ieee80211 phy0: I iwl3945_rx_handle r = 42, i = 41, UNKNOWN, 0x1b
Jan  9 17:47:52 rainbow kernel: [   29.277867] ieee80211 phy0: I iwl3945_rx_handle r = 43, i = 42, SCAN_RESULTS_NOTIFICATION, 0x83
Jan  9 17:47:52 rainbow kernel: [   29.277875] ieee80211 phy0: I iwl3945_rx_scan_results_notif Scan ch.res: 4 [802.11bg] (TSF: 0x00000000:0001CC55) - 2 elapsed=39948 usec (40ms since last)
Jan  9 17:47:52 rainbow kernel: [   29.279214] ieee80211 phy0: I iwl3945_rx_handle r = 45, i = 43, STATISTICS_NOTIFICATION, 0x9d
Jan  9 17:47:52 rainbow kernel: [   29.279226] ieee80211 phy0: I iwl3945_rx_handle r = 45, i = 44, SCAN_START_NOTIFICATION, 0x82
Jan  9 17:47:52 rainbow kernel: [   29.279232] ieee80211 phy0: I iwl3945_rx_scan_start_notif Scan start: 5 [802.11bg] (TSF: 0x00000000:0001D18C) - 1 (beacon timer 16862836)
Jan  9 17:47:52 rainbow kernel: [   29.282122] ieee80211 phy0: I iwl3945_rx_handle r = 46, i = 45, UNKNOWN, 0x1b
Jan  9 17:47:52 rainbow kernel: [   29.285099] ieee80211 phy0: I iwl3945_rx_handle r = 47, i = 46, UNKNOWN, 0x1b
Jan  9 17:47:52 rainbow kernel: [   29.319166] ieee80211 phy0: I iwl3945_rx_handle r = 48, i = 47, SCAN_RESULTS_NOTIFICATION, 0x83
Jan  9 17:47:52 rainbow kernel: [   29.319181] ieee80211 phy0: I iwl3945_rx_scan_results_notif Scan ch.res: 5 [802.11bg] (TSF: 0x00000000:00026DA3) - 2 elapsed=39959 usec (40ms since last)
Jan  9 17:47:52 rainbow kernel: [   29.320261] ieee80211 phy0: I iwl3945_rx_handle r = 50, i = 48, STATISTICS_NOTIFICATION, 0x9d
Jan  9 17:47:52 rainbow kernel: [   29.320287] ieee80211 phy0: I iwl3945_rx_handle r = 50, i = 49, SCAN_START_NOTIFICATION, 0x82
Jan  9 17:47:52 rainbow kernel: [   29.320299] ieee80211 phy0: I iwl3945_rx_scan_start_notif Scan start: 6 [802.11bg] (TSF: 0x00000000:000271EA) - 1 (beacon timer 16821782)
Jan  9 17:47:52 rainbow kernel: [   29.322392] ieee80211 phy0: I iwl3945_rx_handle r = 51, i = 50, UNKNOWN, 0x1b
Jan  9 17:47:52 rainbow kernel: [   29.324692] ieee80211 phy0: I iwl3945_rx_handle r = 52, i = 51, UNKNOWN, 0x1b
Jan  9 17:47:52 rainbow kernel: [   29.325982] ieee80211 phy0: I iwl3945_rx_handle r = 53, i = 52, UNKNOWN, 0x1b
Jan  9 17:47:52 rainbow kernel: [   29.328211] ieee80211 phy0: I iwl3945_rx_handle r = 54, i = 53, UNKNOWN, 0x1b
Jan  9 17:47:52 rainbow kernel: [   29.343750] ieee80211 phy0: I iwl3945_rx_handle r = 55, i = 54, UNKNOWN, 0x1b
Jan  9 17:47:52 rainbow kernel: [   29.351601] ieee80211 phy0: I iwl3945_rx_handle r = 56, i = 55, UNKNOWN, 0x1b
Jan  9 17:47:52 rainbow kernel: [   29.356091] ieee80211 phy0: I iwl3945_rx_handle r = 57, i = 56, UNKNOWN, 0x1b
Jan  9 17:47:52 rainbow kernel: [   29.360176] ieee80211 phy0: I iwl3945_rx_handle r = 58, i = 57, SCAN_RESULTS_NOTIFICATION, 0x83
Jan  9 17:47:52 rainbow kernel: [   29.360190] ieee80211 phy0: I iwl3945_rx_scan_results_notif Scan ch.res: 6 [802.11bg] (TSF: 0x00000000:00030DF4) - 7 elapsed=39946 usec (44ms since last)
Jan  9 17:47:52 rainbow kernel: [   29.361216] ieee80211 phy0: I iwl3945_rx_handle r = 60, i = 58, STATISTICS_NOTIFICATION, 0x9d
Jan  9 17:47:52 rainbow kernel: [   29.361241] ieee80211 phy0: I iwl3945_rx_handle r = 60, i = 59, SCAN_START_NOTIFICATION, 0x82
Jan  9 17:47:52 rainbow kernel: [   29.361253] ieee80211 phy0: I iwl3945_rx_scan_start_notif Scan start: 7 [802.11bg] (TSF: 0x00000000:00031206) - 1 (beacon timer 16780794)
Jan  9 17:47:52 rainbow kernel: [   29.362266] NET: Registered protocol family 17
Jan  9 17:47:52 rainbow kernel: [   29.363324] ieee80211 phy0: I iwl3945_rx_handle r = 61, i = 60, UNKNOWN, 0x1b
Jan  9 17:47:52 rainbow kernel: [   29.365723] ieee80211 phy0: I iwl3945_rx_handle r = 62, i = 61, UNKNOWN, 0x1b
Jan  9 17:47:52 rainbow kernel: [   29.368071] ieee80211 phy0: I iwl3945_rx_handle r = 63, i = 62, UNKNOWN, 0x1b
Jan  9 17:47:52 rainbow kernel: [   29.385099] ieee80211 phy0: I iwl3945_rx_handle r = 64, i = 63, UNKNOWN, 0x1b
Jan  9 17:47:52 rainbow kernel: [   29.401228] ieee80211 phy0: I iwl3945_rx_handle r = 65, i = 64, SCAN_RESULTS_NOTIFICATION, 0x83
Jan  9 17:47:52 rainbow kernel: [   29.401241] ieee80211 phy0: I iwl3945_rx_scan_results_notif Scan ch.res: 7 [802.11bg] (TSF: 0x00000000:0003AE0F) - 3 elapsed=39945 usec (40ms since last)
Jan  9 17:47:52 rainbow kernel: [   29.402188] ieee80211 phy0: I iwl3945_rx_handle r = 67, i = 65, STATISTICS_NOTIFICATION, 0x9d
Jan  9 17:47:52 rainbow kernel: [   29.402211] ieee80211 phy0: I iwl3945_rx_handle r = 67, i = 66, SCAN_START_NOTIFICATION, 0x82
Jan  9 17:47:52 rainbow kernel: [   29.402221] ieee80211 phy0: I iwl3945_rx_scan_start_notif Scan start: 8 [802.11bg] (TSF: 0x00000000:0003B1D5) - 1 (beacon timer 33619499)
Jan  9 17:47:52 rainbow kernel: [   29.406097] ieee80211 phy0: I iwl3945_rx_handle r = 68, i = 67, UNKNOWN, 0x1b
Jan  9 17:47:52 rainbow kernel: [   29.414768] ieee80211 phy0: I iwl3945_rx_handle r = 69, i = 68, SCAN_RESULTS_NOTIFICATION, 0x83
Jan  9 17:47:52 rainbow kernel: [   29.414782] ieee80211 phy0: I iwl3945_rx_scan_results_notif Scan ch.res: 8 [802.11bg] (TSF: 0x00000000:0003E2F8) - 1 elapsed=12579 usec (12ms since last)
Jan  9 17:47:52 rainbow kernel: [   29.415727] ieee80211 phy0: I iwl3945_rx_handle r = 71, i = 69, STATISTICS_NOTIFICATION, 0x9d
Jan  9 17:47:52 rainbow kernel: [   29.415749] ieee80211 phy0: I iwl3945_rx_handle r = 71, i = 70, SCAN_START_NOTIFICATION, 0x82
Jan  9 17:47:52 rainbow kernel: [   29.415762] ieee80211 phy0: I iwl3945_rx_scan_start_notif Scan start: 9 [802.11bg] (TSF: 0x00000000:0003E6BE) - 1 (beacon timer 33605954)
Jan  9 17:47:52 rainbow kernel: [   29.417802] ieee80211 phy0: I iwl3945_rx_handle r = 72, i = 71, UNKNOWN, 0x1b
Jan  9 17:47:52 rainbow kernel: [   29.428977] ieee80211 phy0: I iwl3945_rx_handle r = 73, i = 72, SCAN_RESULTS_NOTIFICATION, 0x83
Jan  9 17:47:52 rainbow kernel: [   29.428990] ieee80211 phy0: I iwl3945_rx_scan_results_notif Scan ch.res: 9 [802.11bg] (TSF: 0x00000000:00041A73) - 1 elapsed=13237 usec (16ms since last)
Jan  9 17:47:52 rainbow kernel: [   29.429940] ieee80211 phy0: I iwl3945_rx_handle r = 75, i = 73, STATISTICS_NOTIFICATION, 0x9d
Jan  9 17:47:52 rainbow kernel: [   29.429962] ieee80211 phy0: I iwl3945_rx_handle r = 75, i = 74, SCAN_START_NOTIFICATION, 0x82
Jan  9 17:47:52 rainbow kernel: [   29.429973] ieee80211 phy0: I iwl3945_rx_scan_start_notif Scan start: 10 [802.11bg] (TSF: 0x00000000:00041E3E) - 1 (beacon timer 33591746)
Jan  9 17:47:52 rainbow kernel: [   29.442475] ieee80211 phy0: I iwl3945_rx_handle r = 76, i = 75, SCAN_RESULTS_NOTIFICATION, 0x83
Jan  9 17:47:52 rainbow kernel: [   29.442488] ieee80211 phy0: I iwl3945_rx_scan_results_notif Scan ch.res: 10 [802.11bg] (TSF: 0x00000000:00044F34) - 0 elapsed=12534 usec (12ms since last)
Jan  9 17:47:52 rainbow kernel: [   29.443440] ieee80211 phy0: I iwl3945_rx_handle r = 78, i = 76, STATISTICS_NOTIFICATION, 0x9d
Jan  9 17:47:52 rainbow kernel: [   29.443462] ieee80211 phy0: I iwl3945_rx_handle r = 78, i = 77, SCAN_START_NOTIFICATION, 0x82
Jan  9 17:47:52 rainbow kernel: [   29.443472] ieee80211 phy0: I iwl3945_rx_scan_start_notif Scan start: 11 [802.11bg] (TSF: 0x00000000:000452FE) - 1 (beacon timer 33578242)
Jan  9 17:47:52 rainbow kernel: [   29.445146] ieee80211 phy0: I iwl3945_rx_handle r = 79, i = 78, UNKNOWN, 0x1b
Jan  9 17:47:52 rainbow kernel: [   29.447363] ieee80211 phy0: I iwl3945_rx_handle r = 80, i = 79, UNKNOWN, 0x1b
Jan  9 17:47:52 rainbow kernel: [   29.448519] ieee80211 phy0: I iwl3945_rx_handle r = 81, i = 80, UNKNOWN, 0x1b
Jan  9 17:47:52 rainbow kernel: [   29.451978] ieee80211 phy0: I iwl3945_rx_handle r = 82, i = 81, UNKNOWN, 0x1b
Jan  9 17:47:52 rainbow kernel: [   29.453610] ieee80211 phy0: I iwl3945_rx_handle r = 83, i = 82, UNKNOWN, 0x1b
Jan  9 17:47:52 rainbow kernel: [   29.454952] ieee80211 phy0: I iwl3945_rx_handle r = 84, i = 83, UNKNOWN, 0x1b
Jan  9 17:47:52 rainbow kernel: [   29.456391] ieee80211 phy0: I iwl3945_rx_handle r = 85, i = 84, UNKNOWN, 0x1b
Jan  9 17:47:52 rainbow kernel: [   29.458141] ieee80211 phy0: I iwl3945_rx_handle r = 86, i = 85, UNKNOWN, 0x1b
Jan  9 17:47:52 rainbow kernel: [   29.465123] ieee80211 phy0: I iwl3945_rx_handle r = 87, i = 86, UNKNOWN, 0x1b
Jan  9 17:47:52 rainbow kernel: [   29.466064] ieee80211 phy0: I iwl3945_rx_handle r = 88, i = 87, UNKNOWN, 0x1b
Jan  9 17:47:52 rainbow kernel: [   29.483337] ieee80211 phy0: I iwl3945_rx_handle r = 89, i = 88, SCAN_RESULTS_NOTIFICATION, 0x83
Jan  9 17:47:52 rainbow kernel: [   29.483357] ieee80211 phy0: I iwl3945_rx_scan_results_notif Scan ch.res: 11 [802.11bg] (TSF: 0x00000000:0004EF04) - 39 elapsed=39942 usec (40ms since last)
Jan  9 17:47:52 rainbow kernel: [   29.484404] ieee80211 phy0: I iwl3945_rx_handle r = 90, i = 89, SCAN_COMPLETE_NOTIFICATION, 0x84
Jan  9 17:47:52 rainbow kernel: [   29.484418] ieee80211 phy0: I iwl3945_rx_scan_complete_notif Scan complete: 11 channels (TSF 0x0004F333:00000000) - 1
Jan  9 17:47:52 rainbow kernel: [   29.484429] ieee80211 phy0: I iwl3945_rx_scan_complete_notif Scan pass on 2.4GHz took 316ms
Jan  9 17:47:52 rainbow kernel: [   29.485740] ieee80211 phy0: U iwl3945_bg_request_scan Kicking off one indirect scan.
Jan  9 17:47:52 rainbow kernel: [   29.485755] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 36 [PASSIVE 110]
Jan  9 17:47:52 rainbow kernel: [   29.485763] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 40 [PASSIVE 110]
Jan  9 17:47:52 rainbow kernel: [   29.485770] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 44 [PASSIVE 110]
Jan  9 17:47:52 rainbow kernel: [   29.485780] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 48 [PASSIVE 110]
Jan  9 17:47:52 rainbow kernel: [   29.485789] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 52 [PASSIVE 110]
Jan  9 17:47:52 rainbow kernel: [   29.485796] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 56 [PASSIVE 110]
Jan  9 17:47:52 rainbow kernel: [   29.485804] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 60 [PASSIVE 110]
Jan  9 17:47:52 rainbow kernel: [   29.485812] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 64 [PASSIVE 110]
Jan  9 17:47:52 rainbow kernel: [   29.485820] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 149 [PASSIVE 110]
Jan  9 17:47:52 rainbow kernel: [   29.485828] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 153 [PASSIVE 110]
Jan  9 17:47:52 rainbow kernel: [   29.485836] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 157 [PASSIVE 110]
Jan  9 17:47:52 rainbow kernel: [   29.485844] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 161 [PASSIVE 110]
Jan  9 17:47:52 rainbow kernel: [   29.485851] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 165 [PASSIVE 110]
Jan  9 17:47:52 rainbow kernel: [   29.485859] ieee80211 phy0: U iwl3945_get_channels_for_scan total channels to scan 13 
Jan  9 17:47:52 rainbow kernel: [   29.485873] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x4416, 367 bytes at 22[32]:4
Jan  9 17:47:52 rainbow kernel: [   29.486098] ieee80211 phy0: I iwl3945_rx_handle r = 91, i = 90, REPLY_SCAN_CMD, 0x80
Jan  9 17:47:52 rainbow kernel: [   29.487043] ieee80211 phy0: I iwl3945_rx_handle r = 93, i = 91, STATISTICS_NOTIFICATION, 0x9d
Jan  9 17:47:52 rainbow kernel: [   29.487067] ieee80211 phy0: I iwl3945_rx_handle r = 93, i = 92, SCAN_START_NOTIFICATION, 0x82
Jan  9 17:47:52 rainbow kernel: [   29.487078] ieee80211 phy0: I iwl3945_rx_scan_start_notif Scan start: 36 [802.11a] (TSF: 0x00000000:0004FD69) - 1 (beacon timer 50414231)
Jan  9 17:47:52 rainbow kernel: [   29.599706] ieee80211 phy0: I iwl3945_rx_handle r = 94, i = 93, SCAN_RESULTS_NOTIFICATION, 0x83
Jan  9 17:47:52 rainbow kernel: [   29.599727] ieee80211 phy0: I iwl3945_rx_scan_results_notif Scan ch.res: 36 [802.11a] (TSF: 0x00000000:0006B571) - 0 elapsed=112648 usec (116ms since last)
Jan  9 17:47:52 rainbow kernel: [   29.600644] ieee80211 phy0: I iwl3945_rx_handle r = 96, i = 94, STATISTICS_NOTIFICATION, 0x9d
Jan  9 17:47:52 rainbow kernel: [   29.600671] ieee80211 phy0: I iwl3945_rx_handle r = 96, i = 95, SCAN_START_NOTIFICATION, 0x82
Jan  9 17:47:52 rainbow kernel: [   29.600683] ieee80211 phy0: I iwl3945_rx_scan_start_notif Scan start: 40 [802.11a] (TSF: 0x00000000:0006B90E) - 1 (beacon timer 67180274)
Jan  9 17:47:52 rainbow kernel: [   29.713303] ieee80211 phy0: I iwl3945_rx_handle r = 97, i = 96, SCAN_RESULTS_NOTIFICATION, 0x83
Jan  9 17:47:52 rainbow kernel: [   29.713320] ieee80211 phy0: I iwl3945_rx_scan_results_notif Scan ch.res: 40 [802.11a] (TSF: 0x00000000:00087117) - 0 elapsed=112649 usec (116ms since last)
Jan  9 17:47:52 rainbow kernel: [   29.714220] ieee80211 phy0: I iwl3945_rx_handle r = 99, i = 97, STATISTICS_NOTIFICATION, 0x9d
Jan  9 17:47:52 rainbow kernel: [   29.714244] ieee80211 phy0: I iwl3945_rx_handle r = 99, i = 98, SCAN_START_NOTIFICATION, 0x82
Jan  9 17:47:52 rainbow kernel: [   29.714254] ieee80211 phy0: I iwl3945_rx_scan_start_notif Scan start: 44 [802.11a] (TSF: 0x00000000:000874B4) - 1 (beacon timer 83946316)
Jan  9 17:47:52 rainbow kernel: [   29.826884] ieee80211 phy0: I iwl3945_rx_handle r = 100, i = 99, SCAN_RESULTS_NOTIFICATION, 0x83
Jan  9 17:47:52 rainbow kernel: [   29.826903] ieee80211 phy0: I iwl3945_rx_scan_results_notif Scan ch.res: 44 [802.11a] (TSF: 0x00000000:000A2CBC) - 0 elapsed=112648 usec (112ms since last)
Jan  9 17:47:52 rainbow kernel: [   29.827828] ieee80211 phy0: I iwl3945_rx_handle r = 102, i = 100, STATISTICS_NOTIFICATION, 0x9d
Jan  9 17:47:52 rainbow kernel: [   29.827851] ieee80211 phy0: I iwl3945_rx_handle r = 102, i = 101, SCAN_START_NOTIFICATION, 0x82
Jan  9 17:47:52 rainbow kernel: [   29.827862] ieee80211 phy0: I iwl3945_rx_scan_start_notif Scan start: 48 [802.11a] (TSF: 0x00000000:000A3077) - 1 (beacon timer 100712329)
Jan  9 17:47:52 rainbow kernel: [   29.940480] ieee80211 phy0: I iwl3945_rx_handle r = 103, i = 102, SCAN_RESULTS_NOTIFICATION, 0x83
Jan  9 17:47:52 rainbow kernel: [   29.940498] ieee80211 phy0: I iwl3945_rx_scan_results_notif Scan ch.res: 48 [802.11a] (TSF: 0x00000000:000BE87F) - 0 elapsed=112648 usec (116ms since last)
Jan  9 17:47:52 rainbow kernel: [   29.941408] ieee80211 phy0: I iwl3945_rx_handle r = 105, i = 103, STATISTICS_NOTIFICATION, 0x9d
Jan  9 17:47:52 rainbow kernel: [   29.941434] ieee80211 phy0: I iwl3945_rx_handle r = 105, i = 104, SCAN_START_NOTIFICATION, 0x82
Jan  9 17:47:52 rainbow kernel: [   29.941446] ieee80211 phy0: I iwl3945_rx_scan_start_notif Scan start: 52 [802.11a] (TSF: 0x00000000:000BEC1C) - 1 (beacon timer 117478372)
Jan  9 17:47:52 rainbow kernel: [   30.054066] ieee80211 phy0: I iwl3945_rx_handle r = 106, i = 105, SCAN_RESULTS_NOTIFICATION, 0x83
Jan  9 17:47:52 rainbow kernel: [   30.054088] ieee80211 phy0: I iwl3945_rx_scan_results_notif Scan ch.res: 52 [802.11a] (TSF: 0x00000000:000DA425) - 0 elapsed=112649 usec (112ms since last)
Jan  9 17:47:52 rainbow kernel: [   30.054982] ieee80211 phy0: I iwl3945_rx_handle r = 108, i = 106, STATISTICS_NOTIFICATION, 0x9d
Jan  9 17:47:52 rainbow kernel: [   30.055005] ieee80211 phy0: I iwl3945_rx_handle r = 108, i = 107, SCAN_START_NOTIFICATION, 0x82
Jan  9 17:47:52 rainbow kernel: [   30.055016] ieee80211 phy0: I iwl3945_rx_scan_start_notif Scan start: 56 [802.11a] (TSF: 0x00000000:000DA7C5) - 1 (beacon timer 134244411)
Jan  9 17:47:52 rainbow kernel: [   30.167640] ieee80211 phy0: I iwl3945_rx_handle r = 109, i = 108, SCAN_RESULTS_NOTIFICATION, 0x83
Jan  9 17:47:52 rainbow kernel: [   30.167654] ieee80211 phy0: I iwl3945_rx_scan_results_notif Scan ch.res: 56 [802.11a] (TSF: 0x00000000:000F5FCD) - 0 elapsed=112648 usec (112ms since last)
Jan  9 17:47:52 rainbow kernel: [   30.168558] ieee80211 phy0: I iwl3945_rx_handle r = 111, i = 109, STATISTICS_NOTIFICATION, 0x9d
Jan  9 17:47:52 rainbow kernel: [   30.168580] ieee80211 phy0: I iwl3945_rx_handle r = 111, i = 110, SCAN_START_NOTIFICATION, 0x82
Jan  9 17:47:52 rainbow kernel: [   30.168593] ieee80211 phy0: I iwl3945_rx_scan_start_notif Scan start: 60 [802.11a] (TSF: 0x00000000:000F636A) - 1 (beacon timer 151010454)
Jan  9 17:47:53 rainbow kernel: [   30.281188] ieee80211 phy0: I iwl3945_rx_handle r = 112, i = 111, SCAN_RESULTS_NOTIFICATION, 0x83
Jan  9 17:47:53 rainbow kernel: [   30.281204] ieee80211 phy0: I iwl3945_rx_scan_results_notif Scan ch.res: 60 [802.11a] (TSF: 0x00000000:00111B72) - 0 elapsed=112648 usec (116ms since last)
Jan  9 17:47:53 rainbow kernel: [   30.282505] ieee80211 phy0: I iwl3945_rx_handle r = 114, i = 112, STATISTICS_NOTIFICATION, 0x9d
Jan  9 17:47:53 rainbow kernel: [   30.282527] ieee80211 phy0: I iwl3945_rx_handle r = 114, i = 113, SCAN_START_NOTIFICATION, 0x82
Jan  9 17:47:53 rainbow kernel: [   30.282537] ieee80211 phy0: I iwl3945_rx_scan_start_notif Scan start: 64 [802.11a] (TSF: 0x00000000:00112084) - 1 (beacon timer 167776124)
Jan  9 17:47:53 rainbow kernel: [   30.395110] ieee80211 phy0: I iwl3945_rx_handle r = 115, i = 114, SCAN_RESULTS_NOTIFICATION, 0x83
Jan  9 17:47:53 rainbow kernel: [   30.395132] ieee80211 phy0: I iwl3945_rx_scan_results_notif Scan ch.res: 64 [802.11a] (TSF: 0x00000000:0012D88D) - 0 elapsed=112649 usec (112ms since last)
Jan  9 17:47:53 rainbow kernel: [   30.396429] ieee80211 phy0: I iwl3945_rx_handle r = 117, i = 115, STATISTICS_NOTIFICATION, 0x9d
Jan  9 17:47:53 rainbow kernel: [   30.396456] ieee80211 phy0: I iwl3945_rx_handle r = 117, i = 116, SCAN_START_NOTIFICATION, 0x82
Jan  9 17:47:53 rainbow kernel: [   30.396468] ieee80211 phy0: I iwl3945_rx_scan_start_notif Scan start: 149 [802.11a] (TSF: 0x00000000:0012DD9F) - 1 (beacon timer 201421409)
Jan  9 17:47:53 rainbow kernel: [   30.509110] ieee80211 phy0: I iwl3945_rx_handle r = 118, i = 117, SCAN_RESULTS_NOTIFICATION, 0x83
Jan  9 17:47:53 rainbow kernel: [   30.509132] ieee80211 phy0: I iwl3945_rx_scan_results_notif Scan ch.res: 149 [802.11a] (TSF: 0x00000000:001495A7) - 0 elapsed=112648 usec (116ms since last)
Jan  9 17:47:53 rainbow kernel: [   30.510034] ieee80211 phy0: I iwl3945_rx_handle r = 120, i = 118, STATISTICS_NOTIFICATION, 0x9d
Jan  9 17:47:53 rainbow kernel: [   30.510062] ieee80211 phy0: I iwl3945_rx_handle r = 120, i = 119, SCAN_START_NOTIFICATION, 0x82
Jan  9 17:47:53 rainbow kernel: [   30.510075] ieee80211 phy0: I iwl3945_rx_scan_start_notif Scan start: 153 [802.11a] (TSF: 0x00000000:00149944) - 1 (beacon timer 218187452)
Jan  9 17:47:53 rainbow kernel: [   30.622636] ieee80211 phy0: I iwl3945_rx_handle r = 121, i = 120, SCAN_RESULTS_NOTIFICATION, 0x83
Jan  9 17:47:53 rainbow kernel: [   30.622661] ieee80211 phy0: I iwl3945_rx_scan_results_notif Scan ch.res: 153 [802.11a] (TSF: 0x00000000:0016514D) - 0 elapsed=112649 usec (112ms since last)
Jan  9 17:47:53 rainbow kernel: [   30.623578] ieee80211 phy0: I iwl3945_rx_handle r = 123, i = 121, STATISTICS_NOTIFICATION, 0x9d
Jan  9 17:47:53 rainbow kernel: [   30.623604] ieee80211 phy0: I iwl3945_rx_handle r = 123, i = 122, SCAN_START_NOTIFICATION, 0x82
Jan  9 17:47:53 rainbow kernel: [   30.623616] ieee80211 phy0: I iwl3945_rx_scan_start_notif Scan start: 157 [802.11a] (TSF: 0x00000000:001654E8) - 1 (beacon timer 234953496)
Jan  9 17:47:53 rainbow kernel: [   30.736268] ieee80211 phy0: I iwl3945_rx_handle r = 124, i = 123, SCAN_RESULTS_NOTIFICATION, 0x83
Jan  9 17:47:53 rainbow kernel: [   30.736288] ieee80211 phy0: I iwl3945_rx_scan_results_notif Scan ch.res: 157 [802.11a] (TSF: 0x00000000:00180CF7) - 0 elapsed=112655 usec (112ms since last)
Jan  9 17:47:53 rainbow kernel: [   30.737138] ieee80211 phy0: I iwl3945_rx_handle r = 126, i = 124, STATISTICS_NOTIFICATION, 0x9d
Jan  9 17:47:53 rainbow kernel: [   30.737165] ieee80211 phy0: I iwl3945_rx_handle r = 126, i = 125, SCAN_START_NOTIFICATION, 0x82
Jan  9 17:47:53 rainbow kernel: [   30.737178] ieee80211 phy0: I iwl3945_rx_scan_start_notif Scan start: 161 [802.11a] (TSF: 0x00000000:00181094) - 1 (beacon timer 251719532)
Jan  9 17:47:53 rainbow kernel: [   30.849863] ieee80211 phy0: I iwl3945_rx_handle r = 127, i = 126, SCAN_RESULTS_NOTIFICATION, 0x83
Jan  9 17:47:53 rainbow kernel: [   30.849885] ieee80211 phy0: I iwl3945_rx_scan_results_notif Scan ch.res: 161 [802.11a] (TSF: 0x00000000:0019C8AA) - 0 elapsed=112662 usec (116ms since last)
Jan  9 17:47:53 rainbow kernel: [   30.850775] ieee80211 phy0: I iwl3945_rx_handle r = 129, i = 127, STATISTICS_NOTIFICATION, 0x9d
Jan  9 17:47:53 rainbow kernel: [   30.850798] ieee80211 phy0: I iwl3945_rx_handle r = 129, i = 128, SCAN_START_NOTIFICATION, 0x82
Jan  9 17:47:53 rainbow kernel: [   30.850808] ieee80211 phy0: I iwl3945_rx_scan_start_notif Scan start: 165 [802.11a] (TSF: 0x00000000:0019CC46) - 1 (beacon timer 268485562)
Jan  9 17:47:53 rainbow kernel: [   30.963436] ieee80211 phy0: I iwl3945_rx_handle r = 130, i = 129, SCAN_RESULTS_NOTIFICATION, 0x83
Jan  9 17:47:53 rainbow kernel: [   30.963456] ieee80211 phy0: I iwl3945_rx_scan_results_notif Scan ch.res: 165 [802.11a] (TSF: 0x00000000:001B844F) - 0 elapsed=112649 usec (112ms since last)
Jan  9 17:47:53 rainbow kernel: [   30.964604] ieee80211 phy0: I iwl3945_rx_handle r = 131, i = 130, SCAN_COMPLETE_NOTIFICATION, 0x84
Jan  9 17:47:53 rainbow kernel: [   30.964619] ieee80211 phy0: I iwl3945_rx_scan_complete_notif Scan complete: 13 channels (TSF 0x001B891F:00000000) - 1
Jan  9 17:47:53 rainbow kernel: [   30.964629] ieee80211 phy0: I iwl3945_rx_scan_complete_notif Scan pass on 5.2GHz took 1484ms
Jan  9 17:47:53 rainbow kernel: [   30.964636] ieee80211 phy0: I iwl3945_rx_scan_complete_notif Setting scan to off
Jan  9 17:47:53 rainbow kernel: [   30.964643] ieee80211 phy0: I iwl3945_rx_scan_complete_notif Scan took 1800ms
Jan  9 17:47:53 rainbow kernel: [   30.966602] ieee80211 phy0: U iwl3945_bg_scan_completed SCAN complete scan
Jan  9 17:47:53 rainbow kernel: [   30.966634] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x0d
Jan  9 17:47:53 rainbow kernel: [   30.966643] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x0f
Jan  9 17:47:53 rainbow kernel: [   30.966651] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x05
Jan  9 17:47:53 rainbow kernel: [   30.966659] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x07
Jan  9 17:47:53 rainbow kernel: [   30.966666] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x09
Jan  9 17:47:53 rainbow kernel: [   30.966674] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x0b
Jan  9 17:47:53 rainbow kernel: [   30.966682] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x01
Jan  9 17:47:53 rainbow kernel: [   30.966690] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 109 rate code 0x03
Jan  9 17:47:53 rainbow kernel: [   30.966699] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 171 dsp  98 rate code 0x0a
Jan  9 17:47:53 rainbow kernel: [   30.966707] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 171 dsp  98 rate code 0x14
Jan  9 17:47:53 rainbow kernel: [   30.966715] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 171 dsp  98 rate code 0x37
Jan  9 17:47:53 rainbow kernel: [   30.966722] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 1:1 rf 171 dsp  98 rate code 0x6e
Jan  9 17:47:53 rainbow kernel: [   30.966737] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0417, 56 bytes at 23[23]:4
Jan  9 17:47:53 rainbow kernel: [   30.966795] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Jan  9 17:47:53 rainbow kernel: [   30.977368] ieee80211 phy0: I iwl3945_rx_handle r 132 i 131 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
Jan  9 17:47:53 rainbow kernel: [   30.977467] ieee80211 phy0: U iwl3945_mac_config enter to channel 11
Jan  9 17:47:53 rainbow kernel: [   30.977478] ieee80211 phy0: U iwl3945_set_rxon_channel Staging channel set to 11 [0]
Jan  9 17:47:53 rainbow kernel: [   30.977495] ieee80211 phy0: U iwl3945_commit_rxon Sending RXON
Jan  9 17:47:53 rainbow kernel: [   30.977497] * without RXON_FILTER_ASSOC_MSK
Jan  9 17:47:53 rainbow kernel: [   30.977499] * channel = 11
Jan  9 17:47:53 rainbow kernel: [   30.977500] * bssid = 00:00:00:00:00:00
Jan  9 17:47:53 rainbow kernel: [   30.977521] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x0418, 48 bytes at 24[24]:4
Jan  9 17:47:53 rainbow kernel: [   30.977538] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Jan  9 17:47:53 rainbow kernel: [   30.981300] ieee80211 phy0: I iwl3945_rx_handle r 133 i 132 No handler needed for REPLY_RXON, 0x10
Jan  9 17:47:53 rainbow kernel: [   30.981506] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0d
Jan  9 17:47:53 rainbow kernel: [   30.981518] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0f
Jan  9 17:47:53 rainbow kernel: [   30.981527] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x05
Jan  9 17:47:53 rainbow kernel: [   30.981535] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x07
Jan  9 17:47:53 rainbow kernel: [   30.981543] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x09
Jan  9 17:47:53 rainbow kernel: [   30.981562] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0b
Jan  9 17:47:53 rainbow kernel: [   30.981570] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x01
Jan  9 17:47:53 rainbow kernel: [   30.981578] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x03
Jan  9 17:47:53 rainbow kernel: [   30.981586] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x0a
Jan  9 17:47:53 rainbow kernel: [   30.981593] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x14
Jan  9 17:47:53 rainbow kernel: [   30.981601] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x37
Jan  9 17:47:53 rainbow kernel: [   30.981610] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x6e
Jan  9 17:47:53 rainbow kernel: [   30.981621] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0419, 56 bytes at 25[25]:4
Jan  9 17:47:53 rainbow kernel: [   30.981636] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Jan  9 17:47:53 rainbow kernel: [   30.984083] ieee80211 phy0: I iwl3945_rx_handle r 134 i 133 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
Jan  9 17:47:53 rainbow kernel: [   30.985070] ieee80211 phy0: U iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
Jan  9 17:47:53 rainbow kernel: [   30.985084] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x041A, 68 bytes at 26[26]:4
Jan  9 17:47:53 rainbow kernel: [   30.985098] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Jan  9 17:47:53 rainbow kernel: [   30.986851] ieee80211 phy0: I iwl3945_rx_handle r = 135, i = 134, REPLY_ADD_STA, 0x18
Jan  9 17:47:53 rainbow kernel: [   30.986910] ieee80211 phy0: U iwl3945_send_add_station REPLY_ADD_STA PASSED
Jan  9 17:47:53 rainbow kernel: [   30.986926] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x041B, 56 bytes at 27[27]:4
Jan  9 17:47:53 rainbow kernel: [   30.986941] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Jan  9 17:47:53 rainbow kernel: [   30.989615] ieee80211 phy0: I iwl3945_rx_handle r 136 i 135 No handler needed for REPLY_RATE_SCALE, 0x47
Jan  9 17:47:53 rainbow kernel: [   30.989673] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x041C, 56 bytes at 28[28]:4
Jan  9 17:47:53 rainbow kernel: [   30.989689] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Jan  9 17:47:53 rainbow kernel: [   30.992375] ieee80211 phy0: I iwl3945_rx_handle r 137 i 136 No handler needed for REPLY_RATE_SCALE, 0x47
Jan  9 17:47:53 rainbow kernel: [   30.992425] ieee80211 phy0: U iwl3945_mac_config leave
Jan  9 17:47:53 rainbow kernel: [   30.992439] ieee80211 phy0: U iwl3945_mac_config_interface bssid: 00:30:bd:c0:90:24
Jan  9 17:47:53 rainbow kernel: [   30.992451] ieee80211 phy0: U iwl3945_commit_rxon Sending RXON
Jan  9 17:47:53 rainbow kernel: [   30.992453] * without RXON_FILTER_ASSOC_MSK
Jan  9 17:47:53 rainbow kernel: [   30.992454] * channel = 11
Jan  9 17:47:53 rainbow kernel: [   30.992456] * bssid = 00:30:bd:c0:90:24
Jan  9 17:47:53 rainbow kernel: [   30.992473] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x041D, 48 bytes at 29[29]:4
Jan  9 17:47:53 rainbow kernel: [   30.992488] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Jan  9 17:47:53 rainbow kernel: [   30.995303] ieee80211 phy0: I iwl3945_rx_handle r 138 i 137 No handler needed for REPLY_RXON, 0x10
Jan  9 17:47:53 rainbow kernel: [   31.009101] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0d
Jan  9 17:47:53 rainbow kernel: [   31.009114] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0f
Jan  9 17:47:53 rainbow kernel: [   31.009123] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x05
Jan  9 17:47:53 rainbow kernel: [   31.009131] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x07
Jan  9 17:47:53 rainbow kernel: [   31.009139] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x09
Jan  9 17:47:53 rainbow kernel: [   31.009147] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0b
Jan  9 17:47:53 rainbow kernel: [   31.009155] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x01
Jan  9 17:47:53 rainbow kernel: [   31.009163] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x03
Jan  9 17:47:53 rainbow kernel: [   31.009171] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x0a
Jan  9 17:47:53 rainbow kernel: [   31.009180] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x14
Jan  9 17:47:53 rainbow kernel: [   31.009188] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x37
Jan  9 17:47:53 rainbow kernel: [   31.009196] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x6e
Jan  9 17:47:53 rainbow kernel: [   31.009208] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x041E, 56 bytes at 30[30]:4
Jan  9 17:47:53 rainbow kernel: [   31.009265] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Jan  9 17:47:53 rainbow kernel: [   31.019745] ieee80211 phy0: I iwl3945_rx_handle r 139 i 138 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
Jan  9 17:47:53 rainbow kernel: [   31.020066] ieee80211 phy0: U iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
Jan  9 17:47:53 rainbow kernel: [   31.020080] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x041F, 68 bytes at 31[31]:4
Jan  9 17:47:53 rainbow kernel: [   31.020095] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Jan  9 17:47:53 rainbow kernel: [   31.022511] ieee80211 phy0: I iwl3945_rx_handle r = 140, i = 139, REPLY_ADD_STA, 0x18
Jan  9 17:47:53 rainbow kernel: [   31.022536] ieee80211 phy0: U iwl3945_send_add_station REPLY_ADD_STA PASSED
Jan  9 17:47:53 rainbow kernel: [   31.022550] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0420, 56 bytes at 32[0]:4
Jan  9 17:47:53 rainbow kernel: [   31.022666] ieee80211 phy0: I iwl3945_rx_handle r 141 i 140 No handler needed for REPLY_RATE_SCALE, 0x47
Jan  9 17:47:53 rainbow kernel: [   31.022723] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0421, 56 bytes at 33[1]:4
Jan  9 17:47:53 rainbow kernel: [   31.022739] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Jan  9 17:47:53 rainbow kernel: [   31.025881] ieee80211 phy0: I iwl3945_rx_handle r 142 i 141 No handler needed for REPLY_RATE_SCALE, 0x47
Jan  9 17:47:53 rainbow kernel: [   31.025915] ieee80211 phy0: U iwl3945_mac_config_interface leave
Jan  9 17:47:53 rainbow kernel: [   31.025926] ieee80211 phy0: U iwl3945_mac_conf_tx enter
Jan  9 17:47:53 rainbow kernel: [   31.025932] ieee80211 phy0: U iwl3945_mac_conf_tx leave
Jan  9 17:47:53 rainbow kernel: [   31.025938] ieee80211 phy0: U iwl3945_mac_conf_tx enter
Jan  9 17:47:53 rainbow kernel: [   31.025944] ieee80211 phy0: U iwl3945_mac_conf_tx leave
Jan  9 17:47:53 rainbow kernel: [   31.025949] ieee80211 phy0: U iwl3945_mac_conf_tx enter
Jan  9 17:47:53 rainbow kernel: [   31.025956] ieee80211 phy0: U iwl3945_mac_conf_tx leave
Jan  9 17:47:53 rainbow kernel: [   31.025962] ieee80211 phy0: U iwl3945_mac_conf_tx enter
Jan  9 17:47:53 rainbow kernel: [   31.025968] ieee80211 phy0: U iwl3945_mac_conf_tx leave
Jan  9 17:47:53 rainbow kernel: [   31.025975] ieee80211 phy0: U iwl3945_mac_reset_tsf enter
Jan  9 17:47:53 rainbow kernel: [   31.025988] ieee80211 phy0: U iwl3945_commit_rxon Sending RXON
Jan  9 17:47:53 rainbow kernel: [   31.025990] * without RXON_FILTER_ASSOC_MSK
Jan  9 17:47:53 rainbow kernel: [   31.025992] * channel = 11
Jan  9 17:47:53 rainbow kernel: [   31.025993] * bssid = 00:30:bd:c0:90:24
Jan  9 17:47:53 rainbow kernel: [   31.026011] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x0422, 48 bytes at 34[2]:4
Jan  9 17:47:53 rainbow kernel: [   31.026026] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Jan  9 17:47:53 rainbow kernel: [   31.028772] ieee80211 phy0: I iwl3945_rx_handle r 143 i 142 No handler needed for REPLY_RXON, 0x10
Jan  9 17:47:53 rainbow kernel: [   31.028833] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0d
Jan  9 17:47:53 rainbow kernel: [   31.028843] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0f
Jan  9 17:47:53 rainbow kernel: [   31.028851] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x05
Jan  9 17:47:53 rainbow kernel: [   31.028859] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x07
Jan  9 17:47:53 rainbow kernel: [   31.028867] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x09
Jan  9 17:47:53 rainbow kernel: [   31.028875] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0b
Jan  9 17:47:53 rainbow kernel: [   31.028883] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x01
Jan  9 17:47:53 rainbow kernel: [   31.028891] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x03
Jan  9 17:47:53 rainbow kernel: [   31.028900] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x0a
Jan  9 17:47:53 rainbow kernel: [   31.028908] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x14
Jan  9 17:47:53 rainbow kernel: [   31.028916] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x37
Jan  9 17:47:53 rainbow kernel: [   31.028924] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x6e
Jan  9 17:47:53 rainbow kernel: [   31.028935] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0423, 56 bytes at 35[3]:4
Jan  9 17:47:53 rainbow kernel: [   31.028951] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Jan  9 17:47:53 rainbow kernel: [   31.031514] ieee80211 phy0: I iwl3945_rx_handle r 144 i 143 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
Jan  9 17:47:53 rainbow kernel: [   31.031570] ieee80211 phy0: U iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
Jan  9 17:47:53 rainbow kernel: [   31.031584] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0424, 68 bytes at 36[4]:4
Jan  9 17:47:53 rainbow kernel: [   31.031896] ieee80211 phy0: I iwl3945_rx_handle r = 145, i = 144, REPLY_ADD_STA, 0x18
Jan  9 17:47:53 rainbow kernel: [   31.032111] ieee80211 phy0: U iwl3945_send_add_station REPLY_ADD_STA PASSED
Jan  9 17:47:53 rainbow kernel: [   31.032136] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0425, 56 bytes at 37[5]:4
Jan  9 17:47:53 rainbow kernel: [   31.032907] ieee80211 phy0: I iwl3945_rx_handle r 146 i 145 No handler needed for REPLY_RATE_SCALE, 0x47
Jan  9 17:47:53 rainbow kernel: [   31.032983] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0426, 56 bytes at 38[6]:4
Jan  9 17:47:53 rainbow kernel: [   31.033000] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Jan  9 17:47:53 rainbow kernel: [   31.035691] ieee80211 phy0: I iwl3945_rx_handle r 147 i 146 No handler needed for REPLY_RATE_SCALE, 0x47
Jan  9 17:47:53 rainbow kernel: [   31.035745] ieee80211 phy0: U iwl3945_mac_reset_tsf leave - not in IBSS
Jan  9 17:47:53 rainbow kernel: [   31.035758] wlan0: authenticate with AP 00:30:bd:c0:90:24
Jan  9 17:47:53 rainbow kernel: [   31.035779] ieee80211 phy0: I iwl3945_mac_tx enter
Jan  9 17:47:53 rainbow kernel: [   31.035797] ieee80211 phy0: I iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Jan  9 17:47:53 rainbow kernel: [   31.035811] ieee80211 phy0: I iwl3945_mac_tx leave
Jan  9 17:47:53 rainbow kernel: [   31.045820] ieee80211 phy0: I iwl3945_rx_handle r = 148, i = 147, UNKNOWN, 0x1b
Jan  9 17:47:53 rainbow kernel: [   31.049583] ieee80211 phy0: I iwl3945_rx_handle r = 149, i = 148, REPLY_TX, 0x1c
Jan  9 17:47:54 rainbow kernel: [   31.232079] wlan0: authenticate with AP 00:30:bd:c0:90:24
Jan  9 17:47:54 rainbow kernel: [   31.232109] ieee80211 phy0: I iwl3945_mac_tx enter
Jan  9 17:47:54 rainbow kernel: [   31.232165] ieee80211 phy0: I iwl3945_mac_tx leave
Jan  9 17:47:54 rainbow kernel: [   31.249612] iwl3945 0000:03:00.0: Microcode SW error detected. Restarting 0x82000008.
Jan  9 17:47:54 rainbow kernel: [   31.249651] iwl3945 0000:03:00.0: Start IWL Error Log Dump:
Jan  9 17:47:54 rainbow kernel: [   31.249659] iwl3945 0000:03:00.0: Status: 0x000302E4, count: 1
Jan  9 17:47:54 rainbow kernel: [   31.249665] iwl3945 0000:03:00.0: Desc       Time       asrtPC  blink2 ilink1  nmiPC   Line
Jan  9 17:47:54 rainbow kernel: [   31.249742] iwl3945 0000:03:00.0: SYSASSERT     (#5) 0000216279 0x0089A 0x0025E 0x00304 0x04BC6 78
Jan  9 17:47:54 rainbow kernel: [   31.249745] 
Jan  9 17:47:54 rainbow kernel: [   31.249815] iwl3945 0000:03:00.0: Start IWL Event Log Dump: display count 512, wraps 16
Jan  9 17:47:54 rainbow kernel: [   31.249851] iwl3945 0000:03:00.0: 0000002661^I0x04250047^I0401
Jan  9 17:47:54 rainbow kernel: [   31.249888] iwl3945 0000:03:00.0: 0000002688^I0x0000010f^I0603
Jan  9 17:47:54 rainbow kernel: [   31.249923] iwl3945 0000:03:00.0: 0000002763^I0x00000180^I0604
Jan  9 17:47:54 rainbow kernel: [   31.250014] iwl3945 0000:03:00.0: 0000002765^I0x0000019c^I0610
Jan  9 17:47:54 rainbow kernel: [   31.250050] iwl3945 0000:03:00.0: 0000002766^I0x00018533^I0610
Jan  9 17:47:54 rainbow kernel: [   31.250085] iwl3945 0000:03:00.0: 0000002767^I0x02000000^I0610
Jan  9 17:47:54 rainbow kernel: [   31.250120] iwl3945 0000:03:00.0: 0000002815^I0x00000500^I0600
Jan  9 17:47:54 rainbow kernel: [   31.250154] iwl3945 0000:03:00.0: 0000004316^I0x000001ed^I0616
Jan  9 17:47:54 rainbow kernel: [   31.250190] iwl3945 0000:03:00.0: 0000002809^I0x00018507^I0638
Jan  9 17:47:54 rainbow kernel: [   31.250224] iwl3945 0000:03:00.0: 0000002832^I0x0000001c^I1101
Jan  9 17:47:54 rainbow kernel: [   31.250260] iwl3945 0000:03:00.0: 0000002865^I0x0000001a^I1101
Jan  9 17:47:54 rainbow kernel: [   31.250294] iwl3945 0000:03:00.0: 0000002892^I0x000000ff^I1103
Jan  9 17:47:54 rainbow kernel: [   31.250329] iwl3945 0000:03:00.0: 0000002893^I0xffff9111^I1103
Jan  9 17:47:54 rainbow kernel: [   31.250365] iwl3945 0000:03:00.0: 0000002895^I0x00000010^I1101
Jan  9 17:47:54 rainbow kernel: [   31.250400] iwl3945 0000:03:00.0: 0000002913^I0x00000011^I1101
Jan  9 17:47:54 rainbow kernel: [   31.250435] iwl3945 0000:03:00.0: 0000002926^I0x00000000^I1101
Jan  9 17:47:54 rainbow kernel: [   31.250469] iwl3945 0000:03:00.0: 0000002927^I0x00000000^I1101
Jan  9 17:47:54 rainbow kernel: [   31.250505] iwl3945 0000:03:00.0: 0000002929^I0x000001d8^I1101
Jan  9 17:47:54 rainbow kernel: [   31.250540] iwl3945 0000:03:00.0: 0000002931^I0x00000065^I1104
Jan  9 17:47:54 rainbow kernel: [   31.250575] iwl3945 0000:03:00.0: 0000002933^I0x0000000e^I1101
Jan  9 17:47:54 rainbow kernel: [   31.250611] iwl3945 0000:03:00.0: 0000002934^I0x00680034^I1102
Jan  9 17:47:54 rainbow kernel: [   31.250646] iwl3945 0000:03:00.0: 0000002935^I0x00670035^I1102
Jan  9 17:47:54 rainbow kernel: [   31.250681] iwl3945 0000:03:00.0: 0000002937^I0x007e0036^I1102
Jan  9 17:47:54 rainbow kernel: [   31.250717] iwl3945 0000:03:00.0: 0000002939^I0x007c0037^I1102
Jan  9 17:47:54 rainbow kernel: [   31.250753] iwl3945 0000:03:00.0: 0000002940^I0x00000038^I1102
Jan  9 17:47:54 rainbow kernel: [   31.250789] iwl3945 0000:03:00.0: 0000002942^I0x00840052^I1102
Jan  9 17:47:54 rainbow kernel: [   31.250824] iwl3945 0000:03:00.0: 0000002943^I0x00840053^I1102
Jan  9 17:47:54 rainbow kernel: [   31.250859] iwl3945 0000:03:00.0: 0000002945^I0x007e0054^I1102
Jan  9 17:47:54 rainbow kernel: [   31.250895] iwl3945 0000:03:00.0: 0000002946^I0x007d0055^I1102
Jan  9 17:47:54 rainbow kernel: [   31.250930] iwl3945 0000:03:00.0: 0000002948^I0x00000056^I1102
Jan  9 17:47:54 rainbow kernel: [   31.250965] iwl3945 0000:03:00.0: 0000002949^I0x00007050^I1102
Jan  9 17:47:54 rainbow kernel: [   31.251000] iwl3945 0000:03:00.0: 0000002951^I0x00017051^I1102
Jan  9 17:47:54 rainbow kernel: [   31.251035] iwl3945 0000:03:00.0: 0000002953^I0x00008204^I1102
Jan  9 17:47:54 rainbow kernel: [   31.251075] iwl3945 0000:03:00.0: 0000002955^I0x00018205^I1102
Jan  9 17:47:54 rainbow kernel: [   31.251110] iwl3945 0000:03:00.0: 0000002958^I0x00000001^I1101
Jan  9 17:47:54 rainbow kernel: [   31.251145] iwl3945 0000:03:00.0: 0000002959^I0x008b0063^I1102
Jan  9 17:47:54 rainbow kernel: [   31.251180] iwl3945 0000:03:00.0: 0000002961^I0x0000001d^I1104
Jan  9 17:47:54 rainbow kernel: [   31.251214] iwl3945 0000:03:00.0: 0000002963^I0x00000069^I1114
Jan  9 17:47:54 rainbow kernel: [   31.251250] iwl3945 0000:03:00.0: 0000002984^I0x0000020f^I0605
Jan  9 17:47:54 rainbow kernel: [   31.251285] iwl3945 0000:03:00.0: 0000002985^I0x0000026b^I0621
Jan  9 17:47:54 rainbow kernel: [   31.251319] iwl3945 0000:03:00.0: 0000002989^I0x0000010b^I1108
Jan  9 17:47:54 rainbow kernel: [   31.251354] iwl3945 0000:03:00.0: 0000002991^I0x0000000e^I1101
Jan  9 17:47:54 rainbow kernel: [   31.251389] iwl3945 0000:03:00.0: 0000002992^I0x00680034^I1102
Jan  9 17:47:54 rainbow kernel: [   31.251424] iwl3945 0000:03:00.0: 0000002993^I0x00670035^I1102
Jan  9 17:47:54 rainbow kernel: [   31.251459] iwl3945 0000:03:00.0: 0000002995^I0x007e0036^I1102
Jan  9 17:47:54 rainbow kernel: [   31.251493] iwl3945 0000:03:00.0: 0000002996^I0x007c0037^I1102
Jan  9 17:47:54 rainbow kernel: [   31.251528] iwl3945 0000:03:00.0: 0000002998^I0x00000038^I1102
Jan  9 17:47:54 rainbow kernel: [   31.251562] iwl3945 0000:03:00.0: 0000002999^I0x00840052^I1102
Jan  9 17:47:54 rainbow kernel: [   31.251597] iwl3945 0000:03:00.0: 0000003001^I0x00840053^I1102
Jan  9 17:47:54 rainbow kernel: [   31.251634] iwl3945 0000:03:00.0: 0000003002^I0x007e0054^I1102
Jan  9 17:47:54 rainbow kernel: [   31.251669] iwl3945 0000:03:00.0: 0000003004^I0x007d0055^I1102
Jan  9 17:47:54 rainbow kernel: [   31.251704] iwl3945 0000:03:00.0: 0000003005^I0x00000056^I1102
Jan  9 17:47:54 rainbow kernel: [   31.251739] iwl3945 0000:03:00.0: 0000003007^I0x00007050^I1102
Jan  9 17:47:54 rainbow kernel: [   31.251774] iwl3945 0000:03:00.0: 0000003009^I0x00017051^I1102
Jan  9 17:47:54 rainbow kernel: [   31.251808] iwl3945 0000:03:00.0: 0000003011^I0x00008204^I1102
Jan  9 17:47:54 rainbow kernel: [   31.251843] iwl3945 0000:03:00.0: 0000003013^I0x00018205^I1102
Jan  9 17:47:54 rainbow kernel: [   31.251879] iwl3945 0000:03:00.0: 0000003016^I0x00000001^I1101
Jan  9 17:47:54 rainbow kernel: [   31.251914] iwl3945 0000:03:00.0: 0000003017^I0x008b0063^I1102
Jan  9 17:47:54 rainbow kernel: [   31.251950] iwl3945 0000:03:00.0: 0000003019^I0x0000001c^I1104
Jan  9 17:47:54 rainbow kernel: [   31.251985] iwl3945 0000:03:00.0: 0000003020^I0x00000002^I1101
Jan  9 17:47:54 rainbow kernel: [   31.252020] iwl3945 0000:03:00.0: 0000003021^I0x0083903f^I1102
Jan  9 17:47:54 rainbow kernel: [   31.252055] iwl3945 0000:03:00.0: 0000003023^I0x0001d213^I1102
Jan  9 17:47:54 rainbow kernel: [   31.252090] iwl3945 0000:03:00.0: 0000003026^I0x00000002^I1101
Jan  9 17:47:54 rainbow kernel: [   31.252125] iwl3945 0000:03:00.0: 0000003027^I0x0003d206^I1102
Jan  9 17:47:54 rainbow kernel: [   31.252160] iwl3945 0000:03:00.0: 0000003029^I0x0083903e^I1102
Jan  9 17:47:54 rainbow kernel: [   31.252198] iwl3945 0000:03:00.0: 0000003033^I0x00000059^I1101
Jan  9 17:47:54 rainbow kernel: [   31.252233] iwl3945 0000:03:00.0: 0000003133^I0x00000013^I1101
Jan  9 17:47:54 rainbow kernel: [   31.252269] iwl3945 0000:03:00.0: 0000003151^I0x00000005^I1107
Jan  9 17:47:54 rainbow kernel: [   31.252304] iwl3945 0000:03:00.0: 0000003719^I0x0001817a^I1110
Jan  9 17:47:54 rainbow kernel: [   31.252339] iwl3945 0000:03:00.0: 0000003730^I0xffffff46^I0454
Jan  9 17:47:54 rainbow kernel: [   31.252374] iwl3945 0000:03:00.0: 0000003731^I0x00000000^I0472
Jan  9 17:47:54 rainbow kernel: [   31.252408] iwl3945 0000:03:00.0: 0000003741^I0x0000000b^I0463
Jan  9 17:47:54 rainbow kernel: [   31.252443] iwl3945 0000:03:00.0: 0000003744^I0xffffff46^I1111
Jan  9 17:47:54 rainbow kernel: [   31.252478] iwl3945 0000:03:00.0: 0000003749^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.252513] iwl3945 0000:03:00.0: 0000003749^I0x0000000e^I1106
Jan  9 17:47:54 rainbow kernel: [   31.252548] iwl3945 0000:03:00.0: 0000003754^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.252582] iwl3945 0000:03:00.0: 0000003758^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.252617] iwl3945 0000:03:00.0: 0000003762^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.252652] iwl3945 0000:03:00.0: 0000003766^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.252687] iwl3945 0000:03:00.0: 0000003771^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.252722] iwl3945 0000:03:00.0: 0000003775^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.252760] iwl3945 0000:03:00.0: 0000003779^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.252795] iwl3945 0000:03:00.0: 0000003784^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.252829] iwl3945 0000:03:00.0: 0000003788^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.252864] iwl3945 0000:03:00.0: 0000003792^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.252898] iwl3945 0000:03:00.0: 0000003796^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.252933] iwl3945 0000:03:00.0: 0000003801^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.252968] iwl3945 0000:03:00.0: 0000003805^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253003] iwl3945 0000:03:00.0: 0000003809^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253038] iwl3945 0000:03:00.0: 0000003813^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253073] iwl3945 0000:03:00.0: 0000003818^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253108] iwl3945 0000:03:00.0: 0000003822^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253143] iwl3945 0000:03:00.0: 0000003826^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253178] iwl3945 0000:03:00.0: 0000003831^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253213] iwl3945 0000:03:00.0: 0000003835^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253247] iwl3945 0000:03:00.0: 0000003839^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253282] iwl3945 0000:03:00.0: 0000003843^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253319] iwl3945 0000:03:00.0: 0000003848^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253354] iwl3945 0000:03:00.0: 0000003852^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253389] iwl3945 0000:03:00.0: 0000003856^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253423] iwl3945 0000:03:00.0: 0000003860^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253458] iwl3945 0000:03:00.0: 0000003865^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253493] iwl3945 0000:03:00.0: 0000003869^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253528] iwl3945 0000:03:00.0: 0000003873^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253563] iwl3945 0000:03:00.0: 0000003878^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000003882^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000003886^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000003890^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000003895^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000003899^I0x00000001^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000003900^I0x0000000f^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000003901^I0x00000392^I1105
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000003905^I0x00000510^I1115
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000003909^I0x0000000b^I0463
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000003910^I0x0000000b^I0462
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000003921^I0x0000010c^I0601
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000003932^I0x04260047^I0401
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000003942^I0x0000010f^I0603
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004014^I0x00000180^I0604
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004016^I0x0000019c^I0610
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004017^I0x00018050^I0610
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004018^I0x00000000^I0610
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004066^I0x00000500^I0600
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005568^I0x000001ed^I0616
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004060^I0x00018024^I0638
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004083^I0x0000001c^I1101
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004116^I0x0000001a^I1101
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004143^I0x000000ff^I1103
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004144^I0xffff9111^I1103
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004146^I0x00000010^I1101
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004164^I0x00000011^I1101
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004177^I0x00000000^I1101
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004178^I0x00000000^I1101
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004180^I0x000001d8^I1101
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004182^I0x00000065^I1104
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004184^I0x0000000e^I1101
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004185^I0x00680034^I1102
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004186^I0x00670035^I1102
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004188^I0x007e0036^I1102
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004190^I0x007c0037^I1102
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004191^I0x00000038^I1102
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004193^I0x00840052^I1102
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004194^I0x00840053^I1102
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004196^I0x007e0054^I1102
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004197^I0x007d0055^I1102
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004199^I0x00000056^I1102
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004200^I0x00007050^I1102
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004202^I0x00017051^I1102
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004204^I0x00008204^I1102
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004206^I0x00018205^I1102
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004209^I0x00000001^I1101
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004210^I0x008b0063^I1102
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004212^I0x0000001d^I1104
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004214^I0x00000069^I1114
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004235^I0x0000020f^I0605
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004236^I0x0000026b^I0621
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004240^I0x0000010b^I1108
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004242^I0x0000000e^I1101
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004243^I0x00680034^I1102
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004244^I0x00670035^I1102
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004246^I0x007e0036^I1102
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004247^I0x007c0037^I1102
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004249^I0x00000038^I1102
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004250^I0x00840052^I1102
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004252^I0x00840053^I1102
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004253^I0x007e0054^I1102
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004255^I0x007d0055^I1102
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004256^I0x00000056^I1102
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004258^I0x00007050^I1102
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004260^I0x00017051^I1102
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004262^I0x00008204^I1102
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004264^I0x00018205^I1102
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004267^I0x00000001^I1101
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004268^I0x008b0063^I1102
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004270^I0x0000001c^I1104
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004271^I0x00000002^I1101
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004272^I0x0083903f^I1102
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004274^I0x0001d213^I1102
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004277^I0x00000002^I1101
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004278^I0x0003d206^I1102
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004280^I0x0083903e^I1102
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004284^I0x00000059^I1101
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004384^I0x00000013^I1101
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004402^I0x00000005^I1107
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004970^I0x00017c97^I1110
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004981^I0xffffff47^I0454
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004982^I0x00000000^I0472
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004992^I0x0000000b^I0463
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000004995^I0xffffff47^I1111
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005000^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005000^I0x0000000e^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005005^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005009^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005013^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005017^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005022^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005026^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005030^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005035^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005039^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005043^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005047^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005052^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005056^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005060^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005064^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005069^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005073^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005077^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005082^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005086^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005090^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005094^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005099^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005103^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005107^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005111^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005116^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005120^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005124^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005129^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005133^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005137^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005141^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005146^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005150^I0x00000000^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005154^I0x00000001^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005155^I0x0000000f^I1106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005157^I0x00000396^I1105
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005160^I0x00000510^I1115
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005164^I0x0000000b^I0463
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005165^I0x0000000b^I0462
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005176^I0x0000010c^I0601
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005216^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005217^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005284^I0x00000012^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005294^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005301^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005303^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005375^I0x00000013^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005386^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005393^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005394^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005487^I0x00000014^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005498^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005504^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005506^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005577^I0x00000015^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005588^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005594^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005596^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005666^I0x00000016^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005682^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005684^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005758^I0x00000017^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005769^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005776^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005778^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005848^I0x00000018^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005859^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005866^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005868^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005943^I0x00000019^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005954^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005961^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000005962^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000006033^I0x0000001a^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000006043^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000006050^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000006052^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000006121^I0x0000001b^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000006131^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000006138^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000006140^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000006212^I0x0000001c^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000006222^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000006229^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000006231^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000006303^I0x0000001d^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000006314^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000006320^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000006322^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000006393^I0x0000001e^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000006403^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000006410^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000006412^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000006481^I0x0000001f^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000006491^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000006498^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000006500^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000006569^I0x00000020^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000006579^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000006586^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000006588^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000006932^I0x00000000^I0304
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000010100^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000010102^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000010178^I0x00000021^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000010188^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000010195^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000010197^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000010355^I0x00000022^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000010365^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000010372^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000010374^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000010460^I0x00000023^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000010470^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000010477^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000010479^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000010563^I0x00000024^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000010573^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000010580^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000010582^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000010653^I0x00000025^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000010663^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000010670^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000010672^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000010743^I0x00000026^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000010753^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000010760^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000010762^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000010834^I0x00000027^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000010845^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000010852^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000010853^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000010929^I0x00000028^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000010939^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000010946^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000010948^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000011020^I0x00000029^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000011030^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000011037^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000011039^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000011119^I0x0000002a^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000011129^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000011136^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000011138^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000011225^I0x0000002b^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000011235^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000011249^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000011251^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000011326^I0x0000002c^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000011337^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000011351^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000011353^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000011495^I0x0000002d^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000011505^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000011512^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000011514^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000011585^I0x0000002e^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000011595^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000011603^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000011605^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000011983^I0x00000000^I0356
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000012520^I0x00000003^I0310
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000012532^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000012534^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000012608^I0x0000002f^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000012619^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000012660^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000012662^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000012735^I0x00000030^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000012746^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000012764^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000012765^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000012840^I0x00000031^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000012851^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000012857^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000012859^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000012929^I0x00000032^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000012939^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000012956^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000012958^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000013031^I0x00000033^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000013042^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000013048^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000013050^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000013120^I0x00000034^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000013131^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000013139^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000013141^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000013215^I0x00000035^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000013226^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000013246^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000013248^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000013324^I0x00000036^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000013335^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000013349^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000013351^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000013430^I0x00000037^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000013441^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000013448^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000013449^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000013518^I0x00000038^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000013529^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000013535^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000013537^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000013606^I0x00000039^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000013617^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000013624^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000013625^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000013696^I0x0000003a^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000013707^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000013714^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000013715^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000013787^I0x0000003b^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000013797^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000013804^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000013806^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000013876^I0x0000003c^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000013886^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000013893^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000013894^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000013963^I0x0000003d^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000013974^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000013981^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000013982^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000014057^I0x0000003e^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000014073^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000014075^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000014147^I0x0000003f^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000014158^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000014165^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000014167^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000014235^I0x00000040^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000014246^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000014252^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000014254^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000014325^I0x00000041^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000014336^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000014343^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000014344^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000014415^I0x00000042^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000014426^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000014433^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000014434^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000014504^I0x00000043^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000014515^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000014522^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000014523^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000014599^I0x00000044^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000014609^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000014616^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000014617^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000014687^I0x00000045^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000014698^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000014705^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000014706^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000014776^I0x00000046^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000014787^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000014794^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000014795^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000014866^I0x00000047^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000014877^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000014884^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000014885^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000014955^I0x00000048^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000014966^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000014973^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000014974^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000015045^I0x00000049^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000015056^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000015063^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000015064^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000015133^I0x0000004a^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000015144^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000015151^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000015152^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000015222^I0x0000004b^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000015233^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000015239^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000015241^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000015314^I0x0000004c^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000015325^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000015332^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000015333^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000015404^I0x0000004d^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000015415^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000015421^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000015423^I0x00000000^I0302
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000015442^I0x00000002^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000015544^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000015546^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000015619^I0x0000004e^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000015630^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000015637^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000015638^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000015708^I0x0000004f^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000015719^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000015726^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000015727^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000015797^I0x00000050^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000015808^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000015814^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000015816^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000015886^I0x00000051^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000015896^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000015903^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000015905^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000015976^I0x00000052^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000015986^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000015993^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000015995^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000016092^I0x000000c4^I0303
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000016103^I0x000000d9^I0106
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000016105^I0x00000000^I0301
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000016179^I0x00000053^I0353
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000016189^I0x00000000^I0352
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000016307^I0x00010087^I0250
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000016313^I0x0000001c^I0218
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000216277^I0x00000002^I0123
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: 0000216280^I0x00000100^I0125
Jan  9 17:47:54 rainbow kernel: [   31.253568] ieee80211 phy0: I iwl3945_print_rx_config_cmd RX CONFIG:
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl data: 00000000: 00 1f 3c 20 a1 6e 00 00 00 30 bd c0 90 24 00 00  ..< .n...0...$..
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl data: 00000010: 00 00 00 00 00 00 00 00 03 00 00 00 15 03 00 00  ................
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl data: 00000020: 05 80 00 00 04 00 00 00 0b 00 00 00              ............
Jan  9 17:47:54 rainbow kernel: [   31.253568] ieee80211 phy0: I iwl3945_print_rx_config_cmd u16 channel: 0xb
Jan  9 17:47:54 rainbow kernel: [   31.253568] ieee80211 phy0: I iwl3945_print_rx_config_cmd u32 flags: 0x00008005
Jan  9 17:47:54 rainbow kernel: [   31.253568] ieee80211 phy0: I iwl3945_print_rx_config_cmd u32 filter_flags: 0x00000004
Jan  9 17:47:54 rainbow kernel: [   31.253568] ieee80211 phy0: I iwl3945_print_rx_config_cmd u8 dev_type: 0x3
Jan  9 17:47:54 rainbow kernel: [   31.253568] ieee80211 phy0: I iwl3945_print_rx_config_cmd u8 ofdm_basic_rates: 0x15
Jan  9 17:47:54 rainbow kernel: [   31.253568] ieee80211 phy0: I iwl3945_print_rx_config_cmd u8 cck_basic_rates: 0x03
Jan  9 17:47:54 rainbow kernel: [   31.253568] ieee80211 phy0: I iwl3945_print_rx_config_cmd u8[6] node_addr: 00:1f:3c:20:a1:6e
Jan  9 17:47:54 rainbow kernel: [   31.253568] ieee80211 phy0: I iwl3945_print_rx_config_cmd u8[6] bssid_addr: 00:30:bd:c0:90:24
Jan  9 17:47:54 rainbow kernel: [   31.253568] ieee80211 phy0: I iwl3945_print_rx_config_cmd u16 assoc_id: 0x0
Jan  9 17:47:54 rainbow kernel: [   31.253568] ieee80211 phy0: I iwl3945_irq_handle_error Restarting adapter due to uCode error.
Jan  9 17:47:54 rainbow kernel: [   31.253568] ieee80211 phy0: I iwl3945_rx_handle r = 150, i = 149, REPLY_ERROR, 0x02
Jan  9 17:47:54 rainbow kernel: [   31.253568] iwl3945 0000:03:00.0: Error Reply type 0x00000005 cmd REPLY_PHY_CALIBRATION_CMD (0xB0) seq 0x013A ser 0x004E0000
Jan  9 17:47:54 rainbow kernel: [   31.268820] ieee80211 phy0: U __iwl3945_down iwl3945 is going down
Jan  9 17:47:54 rainbow kernel: [   31.271273] iwl3945 0000:03:00.0: Can't stop Rx DMA.
Jan  9 17:47:54 rainbow kernel: [   31.271338] ieee80211 phy0: U iwl3945_apm_stop_master stop master
Jan  9 17:47:54 rainbow kernel: [   31.271562] ieee80211 phy0: U iwl3945_clear_free_frames 0 frames on pre-allocated heap on clear.
Jan  9 17:47:54 rainbow kernel: [   31.271584] ieee80211 phy0: U iwl3945_power_init_handle Initialize power 
Jan  9 17:47:54 rainbow kernel: [   31.271600] ieee80211 phy0: U iwl3945_power_init_handle adjust power command flags
Jan  9 17:47:54 rainbow kernel: [   31.271702] ieee80211 phy0: U iwl3945_hw_nic_init HW Revision ID = 0x2
Jan  9 17:47:54 rainbow kernel: [   31.271755] ieee80211 phy0: U iwl3945_nic_config 3945 RADIO-MM type
Jan  9 17:47:54 rainbow kernel: [   31.271769] ieee80211 phy0: U iwl3945_nic_config SKU OP mode is basic
Jan  9 17:47:54 rainbow kernel: [   31.271776] ieee80211 phy0: U iwl3945_nic_config 3945ABG revision is 0xF1
Jan  9 17:47:54 rainbow kernel: [   31.271790] ieee80211 phy0: U iwl3945_nic_config Card M type B version is 0x3
Jan  9 17:47:54 rainbow kernel: [   31.275110] ieee80211 phy0: U iwl3945_load_bsm Begin load bsm
Jan  9 17:47:54 rainbow kernel: [   31.276378] ieee80211 phy0: U iwl3945_verify_bsm Begin verify bsm
Jan  9 17:47:54 rainbow kernel: [   31.278563] ieee80211 phy0: U iwl3945_verify_bsm BSM bootstrap uCode image OK
Jan  9 17:47:54 rainbow kernel: [   31.278623] ieee80211 phy0: U iwl3945_load_bsm BSM write complete, poll 1 iterations
Jan  9 17:47:54 rainbow kernel: [   31.278643] ieee80211 phy0: U __iwl3945_up iwl3945 is coming up
Jan  9 17:47:54 rainbow kernel: [   31.290078] ieee80211 phy0: I iwl3945_rx_handle r = 1, i = 0, REPLY_ALIVE, 0x01
Jan  9 17:47:54 rainbow kernel: [   31.290094] ieee80211 phy0: I iwl3945_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x9
Jan  9 17:47:54 rainbow kernel: [   31.290103] ieee80211 phy0: I iwl3945_rx_reply_alive Initialization Alive received.
Jan  9 17:47:54 rainbow kernel: [   31.318595] ieee80211 phy0: U iwl3945_verify_inst_sparse ucode inst image size is 900
Jan  9 17:47:54 rainbow kernel: [   31.318695] ieee80211 phy0: U iwl3945_verify_inst_sparse ucode inst image size is 2672
Jan  9 17:47:54 rainbow kernel: [   31.318984] ieee80211 phy0: U iwl3945_verify_ucode Initialize uCode is good in inst SRAM
Jan  9 17:47:54 rainbow kernel: [   31.318992] ieee80211 phy0: U iwl3945_init_alive_start Initialization Alive received.
Jan  9 17:47:54 rainbow kernel: [   31.319042] ieee80211 phy0: U iwl3945_set_ucode_ptrs Runtime uCode pointers are set.
Jan  9 17:47:54 rainbow kernel: [   31.323299] ieee80211 phy0: I iwl3945_rx_handle r = 2, i = 1, REPLY_ALIVE, 0x01
Jan  9 17:47:54 rainbow kernel: [   31.323312] ieee80211 phy0: I iwl3945_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x0
Jan  9 17:47:54 rainbow kernel: [   31.323321] ieee80211 phy0: I iwl3945_rx_reply_alive Runtime Alive received.
Jan  9 17:47:54 rainbow kernel: [   31.323369] ieee80211 phy0: I iwl3945_disable_events Selected uCode log events may be disabled
Jan  9 17:47:54 rainbow kernel: [   31.323377] ieee80211 phy0: I iwl3945_disable_events   by writing "1"s into disable bitmap
Jan  9 17:47:54 rainbow kernel: [   31.323384] ieee80211 phy0: I iwl3945_disable_events   in SRAM at 0x8022c8, size 47 u32s
Jan  9 17:47:54 rainbow kernel: [   31.328021] ieee80211 phy0: U iwl3945_alive_start Runtime Alive received.
Jan  9 17:47:54 rainbow kernel: [   31.328031] ieee80211 phy0: U iwl3945_verify_inst_sparse ucode inst image size is 900
Jan  9 17:47:54 rainbow kernel: [   31.328116] ieee80211 phy0: U iwl3945_verify_inst_sparse ucode inst image size is 2672
Jan  9 17:47:54 rainbow kernel: [   31.328202] ieee80211 phy0: U iwl3945_verify_inst_sparse ucode inst image size is 80684
Jan  9 17:47:54 rainbow kernel: [   31.335976] ieee80211 phy0: U iwl3945_verify_ucode Runtime uCode is good in inst SRAM
Jan  9 17:47:54 rainbow kernel: [   31.336030] ieee80211 phy0: U iwl3945_alive_start RFKILL status: 0x1
Jan  9 17:47:54 rainbow kernel: [   31.336060] ieee80211 phy0: U iwl3945_update_power_cmd Flags value = 0x00000009
Jan  9 17:47:54 rainbow kernel: [   31.336067] ieee80211 phy0: U iwl3945_update_power_cmd Tx timeout = 102400
Jan  9 17:47:54 rainbow kernel: [   31.336074] ieee80211 phy0: U iwl3945_update_power_cmd Rx timeout = 51200
Jan  9 17:47:54 rainbow kernel: [   31.336081] ieee80211 phy0: U iwl3945_update_power_cmd Sleep interval vector = { 1 , 1 , 1 , 1 , 1 }
Jan  9 17:47:54 rainbow kernel: [   31.336095] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command POWER_TABLE_CMD (#77), seq: 0x0400, 36 bytes at 0[0]:4
Jan  9 17:47:54 rainbow kernel: [   31.336177] ieee80211 phy0: I iwl3945_rx_handle r 3 i 2 No handler needed for POWER_TABLE_CMD, 0x77
Jan  9 17:47:54 rainbow kernel: [   31.336208] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_BT_CONFIG (#9b), seq: 0x0401, 16 bytes at 1[1]:4
Jan  9 17:47:54 rainbow kernel: [   31.336224] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Jan  9 17:47:54 rainbow kernel: [   31.338015] ieee80211 phy0: I iwl3945_rx_handle r 4 i 3 No handler needed for REPLY_BT_CONFIG, 0x9b
Jan  9 17:47:54 rainbow kernel: [   31.338045] ieee80211 phy0: U iwl3945_commit_rxon Sending RXON
Jan  9 17:47:54 rainbow kernel: [   31.338047] * without RXON_FILTER_ASSOC_MSK
Jan  9 17:47:54 rainbow kernel: [   31.338049] * channel = 11
Jan  9 17:47:54 rainbow kernel: [   31.338051] * bssid = 00:00:00:00:00:00
Jan  9 17:47:54 rainbow kernel: [   31.338069] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x0402, 48 bytes at 2[2]:4
Jan  9 17:47:54 rainbow kernel: [   31.338086] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Jan  9 17:47:54 rainbow kernel: [   31.340998] ieee80211 phy0: I iwl3945_rx_handle r 5 i 4 No handler needed for REPLY_RXON, 0x10
Jan  9 17:47:54 rainbow kernel: [   31.341029] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0d
Jan  9 17:47:54 rainbow kernel: [   31.341038] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0f
Jan  9 17:47:54 rainbow kernel: [   31.341047] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x05
Jan  9 17:47:54 rainbow kernel: [   31.341055] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x07
Jan  9 17:47:54 rainbow kernel: [   31.341063] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x09
Jan  9 17:47:54 rainbow kernel: [   31.341071] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0b
Jan  9 17:47:54 rainbow kernel: [   31.341079] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x01
Jan  9 17:47:54 rainbow kernel: [   31.341088] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x03
Jan  9 17:47:54 rainbow kernel: [   31.341097] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x0a
Jan  9 17:47:54 rainbow kernel: [   31.341105] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x14
Jan  9 17:47:54 rainbow kernel: [   31.341114] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x37
Jan  9 17:47:54 rainbow kernel: [   31.341122] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x6e
Jan  9 17:47:54 rainbow kernel: [   31.341133] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0403, 56 bytes at 3[3]:4
Jan  9 17:47:54 rainbow kernel: [   31.341147] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Jan  9 17:47:54 rainbow kernel: [   31.343793] ieee80211 phy0: I iwl3945_rx_handle r 6 i 5 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
Jan  9 17:47:54 rainbow kernel: [   31.343816] ieee80211 phy0: U iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
Jan  9 17:47:54 rainbow kernel: [   31.343829] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0404, 68 bytes at 4[4]:4
Jan  9 17:47:54 rainbow kernel: [   31.343843] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Jan  9 17:47:54 rainbow kernel: [   31.346957] ieee80211 phy0: I iwl3945_rx_handle r = 7, i = 6, REPLY_ADD_STA, 0x18
Jan  9 17:47:54 rainbow kernel: [   31.346980] ieee80211 phy0: U iwl3945_send_add_station REPLY_ADD_STA PASSED
Jan  9 17:47:54 rainbow kernel: [   31.346998] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0405, 56 bytes at 5[5]:4
Jan  9 17:47:54 rainbow kernel: [   31.347243] ieee80211 phy0: I iwl3945_rx_handle r 8 i 7 No handler needed for REPLY_RATE_SCALE, 0x47
Jan  9 17:47:54 rainbow kernel: [   31.347273] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0406, 56 bytes at 6[6]:4
Jan  9 17:47:54 rainbow kernel: [   31.350434] ieee80211 phy0: I iwl3945_rx_handle r 9 i 8 No handler needed for REPLY_RATE_SCALE, 0x47
Jan  9 17:47:54 rainbow kernel: [   31.350461] ieee80211 phy0: U iwl3945_hw_reg_txpower_get_temperature Temperature: 75
Jan  9 17:47:54 rainbow kernel: [   31.350470] ieee80211 phy0: U is_temp_calib_needed Getting warmer, delta 9,
Jan  9 17:47:54 rainbow kernel: [   31.350477] ieee80211 phy0: U is_temp_calib_needed Timed thermal calib needed
Jan  9 17:47:54 rainbow kernel: [   31.350499] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0d
Jan  9 17:47:54 rainbow kernel: [   31.350507] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0f
Jan  9 17:47:54 rainbow kernel: [   31.350514] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x05
Jan  9 17:47:54 rainbow kernel: [   31.350523] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x07
Jan  9 17:47:54 rainbow kernel: [   31.350531] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x09
Jan  9 17:47:54 rainbow kernel: [   31.350539] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0b
Jan  9 17:47:54 rainbow kernel: [   31.350548] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x01
Jan  9 17:47:54 rainbow kernel: [   31.350556] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x03
Jan  9 17:47:54 rainbow kernel: [   31.350564] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x0a
Jan  9 17:47:54 rainbow kernel: [   31.350572] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x14
Jan  9 17:47:54 rainbow kernel: [   31.350580] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x37
Jan  9 17:47:54 rainbow kernel: [   31.350589] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x6e
Jan  9 17:47:54 rainbow kernel: [   31.350600] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0407, 56 bytes at 7[7]:4
Jan  9 17:47:54 rainbow kernel: [   31.350617] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Jan  9 17:47:54 rainbow kernel: [   31.353222] ieee80211 phy0: I iwl3945_rx_handle r 10 i 9 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
Jan  9 17:47:54 rainbow kernel: [   31.353323] Registered led device: iwl-phy0:radio
Jan  9 17:47:54 rainbow kernel: [   31.353333] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0408, 12 bytes at 8[8]:4
Jan  9 17:47:54 rainbow kernel: [   31.353350] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Jan  9 17:47:54 rainbow kernel: [   31.353399] Registered led device: iwl-phy0:assoc
Jan  9 17:47:54 rainbow kernel: [   31.353436] Registered led device: iwl-phy0:RX
Jan  9 17:47:54 rainbow kernel: [   31.353488] Registered led device: iwl-phy0:TX
Jan  9 17:47:54 rainbow kernel: [   31.353493] ieee80211 phy0: U iwl3945_alive_start ALIVE processing complete.
Jan  9 17:47:54 rainbow kernel: [   31.355975] ieee80211 phy0: I iwl3945_rx_handle r 11 i 10 No handler needed for REPLY_LEDS_CMD, 0x48
Jan  9 17:47:54 rainbow kernel: [   31.432179] wlan0: authenticate with AP 00:30:bd:c0:90:24
Jan  9 17:47:54 rainbow kernel: [   31.432194] ieee80211 phy0: I iwl3945_mac_tx enter
Jan  9 17:47:54 rainbow kernel: [   31.432253] ieee80211 phy0: I iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Jan  9 17:47:54 rainbow kernel: [   31.432262] ieee80211 phy0: I iwl3945_mac_tx leave
Jan  9 17:47:54 rainbow kernel: [   31.442766] ieee80211 phy0: I iwl3945_rx_handle r = 12, i = 11, REPLY_TX, 0x1c
Jan  9 17:47:54 rainbow kernel: [   31.632075] wlan0: authentication with AP 00:30:bd:c0:90:24 timed out
Jan  9 17:48:12 rainbow kernel: [   49.534876] ieee80211 phy0: U iwl3945_mac_hw_scan enter
Jan  9 17:48:12 rainbow kernel: [   49.534889] ieee80211 phy0: U iwl3945_scan_initiate Starting scan...
Jan  9 17:48:12 rainbow kernel: [   49.534895] ieee80211 phy0: U iwl3945_mac_hw_scan leave
Jan  9 17:48:12 rainbow kernel: [   49.534902] ieee80211 phy0: U iwl3945_bg_request_scan Kicking off one indirect scan.
Jan  9 17:48:12 rainbow kernel: [   49.534908] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 1 [ACTIVE 39]
Jan  9 17:48:12 rainbow kernel: [   49.534911] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 2 [ACTIVE 39]
Jan  9 17:48:12 rainbow kernel: [   49.534915] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 3 [ACTIVE 39]
Jan  9 17:48:12 rainbow kernel: [   49.534918] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 4 [ACTIVE 39]
Jan  9 17:48:12 rainbow kernel: [   49.534922] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 5 [ACTIVE 39]
Jan  9 17:48:12 rainbow kernel: [   49.534925] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 6 [ACTIVE 39]
Jan  9 17:48:12 rainbow kernel: [   49.534928] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 7 [ACTIVE 39]
Jan  9 17:48:12 rainbow kernel: [   49.534931] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 8 [ACTIVE 39]
Jan  9 17:48:12 rainbow kernel: [   49.534934] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 9 [ACTIVE 39]
Jan  9 17:48:12 rainbow kernel: [   49.534937] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 10 [ACTIVE 39]
Jan  9 17:48:12 rainbow kernel: [   49.534940] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 11 [ACTIVE 39]
Jan  9 17:48:12 rainbow kernel: [   49.534943] ieee80211 phy0: U iwl3945_get_channels_for_scan total channels to scan 11 
Jan  9 17:48:12 rainbow kernel: [   49.534952] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x4409, 351 bytes at 9[32]:4
Jan  9 17:48:12 rainbow kernel: [   50.032089] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms
Jan  9 17:48:12 rainbow kernel: [   50.032116] ieee80211 phy0: U iwl3945_bg_scan_completed SCAN complete scan
Jan  9 17:48:12 rainbow kernel: [   50.032143] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0d
Jan  9 17:48:12 rainbow kernel: [   50.032152] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0f
Jan  9 17:48:12 rainbow kernel: [   50.032160] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x05
Jan  9 17:48:12 rainbow kernel: [   50.032168] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x07
Jan  9 17:48:12 rainbow kernel: [   50.032175] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x09
Jan  9 17:48:12 rainbow kernel: [   50.032183] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0b
Jan  9 17:48:12 rainbow kernel: [   50.032192] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x01
Jan  9 17:48:12 rainbow kernel: [   50.032200] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x03
Jan  9 17:48:12 rainbow kernel: [   50.032208] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x0a
Jan  9 17:48:12 rainbow kernel: [   50.032260] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x14
Jan  9 17:48:12 rainbow kernel: [   50.032270] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x37
Jan  9 17:48:12 rainbow kernel: [   50.032278] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x6e
Jan  9 17:48:12 rainbow kernel: [   50.032295] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x040A, 56 bytes at 10[10]:4
Jan  9 17:48:13 rainbow kernel: [   50.532162] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms
Jan  9 17:48:30 rainbow kernel: [   67.516208] ieee80211 phy0: U iwl3945_mac_hw_scan enter
Jan  9 17:48:30 rainbow kernel: [   67.516233] ieee80211 phy0: U iwl3945_mac_hw_scan direct scan for WLAN [4]
Jan  9 17:48:30 rainbow kernel: [   67.516236]  <3>ieee80211 phy0: U iwl3945_scan_initiate Starting scan...
Jan  9 17:48:30 rainbow kernel: [   67.516256] ieee80211 phy0: U iwl3945_mac_hw_scan leave
Jan  9 17:48:30 rainbow kernel: [   67.516270] ieee80211 phy0: U iwl3945_bg_request_scan Kicking off one direct scan for 'WLAN'
Jan  9 17:48:30 rainbow kernel: [   67.516284] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 1 [ACTIVE 42]
Jan  9 17:48:30 rainbow kernel: [   67.516292] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 2 [ACTIVE 42]
Jan  9 17:48:30 rainbow kernel: [   67.516300] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 3 [ACTIVE 42]
Jan  9 17:48:30 rainbow kernel: [   67.516307] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 4 [ACTIVE 42]
Jan  9 17:48:30 rainbow kernel: [   67.516315] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 5 [ACTIVE 42]
Jan  9 17:48:30 rainbow kernel: [   67.516324] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 6 [ACTIVE 42]
Jan  9 17:48:30 rainbow kernel: [   67.516331] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 7 [ACTIVE 42]
Jan  9 17:48:30 rainbow kernel: [   67.516339] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 8 [ACTIVE 42]
Jan  9 17:48:30 rainbow kernel: [   67.516347] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 9 [ACTIVE 42]
Jan  9 17:48:30 rainbow kernel: [   67.516355] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 10 [ACTIVE 42]
Jan  9 17:48:30 rainbow kernel: [   67.516362] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 11 [ACTIVE 42]
Jan  9 17:48:30 rainbow kernel: [   67.516396] ieee80211 phy0: U iwl3945_get_channels_for_scan total channels to scan 11 
Jan  9 17:48:30 rainbow kernel: [   67.516412] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x440B, 351 bytes at 11[32]:4
Jan  9 17:48:30 rainbow kernel: [   68.016100] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms
Jan  9 17:48:30 rainbow kernel: [   68.016128] ieee80211 phy0: U iwl3945_bg_scan_completed SCAN complete scan
Jan  9 17:48:30 rainbow kernel: [   68.016156] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0d
Jan  9 17:48:30 rainbow kernel: [   68.016165] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0f
Jan  9 17:48:30 rainbow kernel: [   68.016173] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x05
Jan  9 17:48:30 rainbow kernel: [   68.016182] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x07
Jan  9 17:48:30 rainbow kernel: [   68.016190] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x09
Jan  9 17:48:30 rainbow kernel: [   68.016198] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0b
Jan  9 17:48:30 rainbow kernel: [   68.016206] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x01
Jan  9 17:48:30 rainbow kernel: [   68.016214] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x03
Jan  9 17:48:30 rainbow kernel: [   68.016224] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x0a
Jan  9 17:48:30 rainbow kernel: [   68.016232] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x14
Jan  9 17:48:30 rainbow kernel: [   68.016241] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x37
Jan  9 17:48:30 rainbow kernel: [   68.016250] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x6e
Jan  9 17:48:30 rainbow kernel: [   68.016266] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x040C, 56 bytes at 12[12]:4
Jan  9 17:48:31 rainbow kernel: [   68.516092] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms
Jan  9 17:48:35 rainbow kernel: [   73.017728] ieee80211 phy0: U iwl3945_mac_hw_scan enter
Jan  9 17:48:35 rainbow kernel: [   73.017751] ieee80211 phy0: U iwl3945_scan_initiate Starting scan...
Jan  9 17:48:35 rainbow kernel: [   73.017764] ieee80211 phy0: U iwl3945_mac_hw_scan leave
Jan  9 17:48:35 rainbow kernel: [   73.017778] ieee80211 phy0: U iwl3945_bg_request_scan Kicking off one indirect scan.
Jan  9 17:48:35 rainbow kernel: [   73.017790] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 1 [ACTIVE 39]
Jan  9 17:48:35 rainbow kernel: [   73.017798] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 2 [ACTIVE 39]
Jan  9 17:48:35 rainbow kernel: [   73.017806] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 3 [ACTIVE 39]
Jan  9 17:48:35 rainbow kernel: [   73.017813] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 4 [ACTIVE 39]
Jan  9 17:48:35 rainbow kernel: [   73.017820] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 5 [ACTIVE 39]
Jan  9 17:48:35 rainbow kernel: [   73.017828] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 6 [ACTIVE 39]
Jan  9 17:48:35 rainbow kernel: [   73.017835] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 7 [ACTIVE 39]
Jan  9 17:48:35 rainbow kernel: [   73.017843] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 8 [ACTIVE 39]
Jan  9 17:48:35 rainbow kernel: [   73.017850] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 9 [ACTIVE 39]
Jan  9 17:48:35 rainbow kernel: [   73.017857] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 10 [ACTIVE 39]
Jan  9 17:48:35 rainbow kernel: [   73.017866] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 11 [ACTIVE 39]
Jan  9 17:48:35 rainbow kernel: [   73.017874] ieee80211 phy0: U iwl3945_get_channels_for_scan total channels to scan 11 
Jan  9 17:48:35 rainbow kernel: [   73.017893] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x440D, 351 bytes at 13[32]:4
Jan  9 17:48:36 rainbow kernel: [   73.520120] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms
Jan  9 17:48:36 rainbow kernel: [   73.520145] ieee80211 phy0: U iwl3945_bg_scan_completed SCAN complete scan
Jan  9 17:48:36 rainbow kernel: [   73.520171] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0d
Jan  9 17:48:36 rainbow kernel: [   73.520179] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0f
Jan  9 17:48:36 rainbow kernel: [   73.520188] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x05
Jan  9 17:48:36 rainbow kernel: [   73.520195] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x07
Jan  9 17:48:36 rainbow kernel: [   73.520203] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x09
Jan  9 17:48:36 rainbow kernel: [   73.520211] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0b
Jan  9 17:48:36 rainbow kernel: [   73.520218] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x01
Jan  9 17:48:36 rainbow kernel: [   73.520226] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x03
Jan  9 17:48:36 rainbow kernel: [   73.520233] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x0a
Jan  9 17:48:36 rainbow kernel: [   73.520241] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x14
Jan  9 17:48:36 rainbow kernel: [   73.520249] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x37
Jan  9 17:48:36 rainbow kernel: [   73.520256] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x6e
Jan  9 17:48:36 rainbow kernel: [   73.520272] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x040E, 56 bytes at 14[14]:4
Jan  9 17:48:36 rainbow kernel: [   74.016101] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms
Jan  9 17:48:41 rainbow kernel: [   78.521739] ieee80211 phy0: U iwl3945_mac_hw_scan enter
Jan  9 17:48:41 rainbow kernel: [   78.521761] ieee80211 phy0: U iwl3945_mac_hw_scan direct scan for WLAN [4]
Jan  9 17:48:41 rainbow kernel: [   78.521764]  <3>ieee80211 phy0: U iwl3945_scan_initiate Starting scan...
Jan  9 17:48:41 rainbow kernel: [   78.521785] ieee80211 phy0: U iwl3945_mac_hw_scan leave
Jan  9 17:48:41 rainbow kernel: [   78.521799] ieee80211 phy0: U iwl3945_bg_request_scan Kicking off one direct scan for 'WLAN'
Jan  9 17:48:41 rainbow kernel: [   78.521811] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 1 [ACTIVE 42]
Jan  9 17:48:41 rainbow kernel: [   78.521819] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 2 [ACTIVE 42]
Jan  9 17:48:41 rainbow kernel: [   78.521826] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 3 [ACTIVE 42]
Jan  9 17:48:41 rainbow kernel: [   78.521834] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 4 [ACTIVE 42]
Jan  9 17:48:41 rainbow kernel: [   78.521842] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 5 [ACTIVE 42]
Jan  9 17:48:41 rainbow kernel: [   78.521864] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 6 [ACTIVE 42]
Jan  9 17:48:41 rainbow kernel: [   78.521872] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 7 [ACTIVE 42]
Jan  9 17:48:41 rainbow kernel: [   78.521879] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 8 [ACTIVE 42]
Jan  9 17:48:41 rainbow kernel: [   78.521886] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 9 [ACTIVE 42]
Jan  9 17:48:41 rainbow kernel: [   78.521894] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 10 [ACTIVE 42]
Jan  9 17:48:41 rainbow kernel: [   78.521901] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 11 [ACTIVE 42]
Jan  9 17:48:41 rainbow kernel: [   78.521908] ieee80211 phy0: U iwl3945_get_channels_for_scan total channels to scan 11 
Jan  9 17:48:41 rainbow kernel: [   78.521924] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x440F, 351 bytes at 15[32]:4
Jan  9 17:48:41 rainbow kernel: [   79.020145] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms
Jan  9 17:48:41 rainbow kernel: [   79.020160] ieee80211 phy0: U iwl3945_bg_scan_completed SCAN complete scan
Jan  9 17:48:41 rainbow kernel: [   79.020183] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0d
Jan  9 17:48:41 rainbow kernel: [   79.020191] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0f
Jan  9 17:48:41 rainbow kernel: [   79.020199] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x05
Jan  9 17:48:41 rainbow kernel: [   79.020206] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x07
Jan  9 17:48:41 rainbow kernel: [   79.020214] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x09
Jan  9 17:48:41 rainbow kernel: [   79.020221] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0b
Jan  9 17:48:41 rainbow kernel: [   79.020229] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x01
Jan  9 17:48:41 rainbow kernel: [   79.020237] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x03
Jan  9 17:48:41 rainbow kernel: [   79.020244] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x0a
Jan  9 17:48:41 rainbow kernel: [   79.020252] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x14
Jan  9 17:48:41 rainbow kernel: [   79.020260] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x37
Jan  9 17:48:41 rainbow kernel: [   79.020268] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x6e
Jan  9 17:48:41 rainbow kernel: [   79.020283] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0410, 56 bytes at 16[16]:4
Jan  9 17:48:42 rainbow kernel: [   79.520104] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms
Jan  9 17:48:46 rainbow kernel: [   84.021624] ieee80211 phy0: U iwl3945_mac_hw_scan enter
Jan  9 17:48:46 rainbow kernel: [   84.021641] ieee80211 phy0: U iwl3945_scan_initiate Starting scan...
Jan  9 17:48:46 rainbow kernel: [   84.021653] ieee80211 phy0: U iwl3945_mac_hw_scan leave
Jan  9 17:48:46 rainbow kernel: [   84.021666] ieee80211 phy0: U iwl3945_bg_request_scan Kicking off one indirect scan.
Jan  9 17:48:46 rainbow kernel: [   84.021677] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 1 [ACTIVE 39]
Jan  9 17:48:46 rainbow kernel: [   84.021685] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 2 [ACTIVE 39]
Jan  9 17:48:46 rainbow kernel: [   84.021694] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 3 [ACTIVE 39]
Jan  9 17:48:46 rainbow kernel: [   84.021701] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 4 [ACTIVE 39]
Jan  9 17:48:46 rainbow kernel: [   84.021709] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 5 [ACTIVE 39]
Jan  9 17:48:46 rainbow kernel: [   84.021718] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 6 [ACTIVE 39]
Jan  9 17:48:46 rainbow kernel: [   84.021726] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 7 [ACTIVE 39]
Jan  9 17:48:46 rainbow kernel: [   84.021749] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 8 [ACTIVE 39]
Jan  9 17:48:46 rainbow kernel: [   84.021757] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 9 [ACTIVE 39]
Jan  9 17:48:46 rainbow kernel: [   84.021764] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 10 [ACTIVE 39]
Jan  9 17:48:46 rainbow kernel: [   84.021772] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 11 [ACTIVE 39]
Jan  9 17:48:46 rainbow kernel: [   84.021779] ieee80211 phy0: U iwl3945_get_channels_for_scan total channels to scan 11 
Jan  9 17:48:46 rainbow kernel: [   84.021795] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x4411, 351 bytes at 17[32]:4
Jan  9 17:48:47 rainbow kernel: [   84.520100] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms
Jan  9 17:48:47 rainbow kernel: [   84.520117] ieee80211 phy0: U iwl3945_bg_scan_completed SCAN complete scan
Jan  9 17:48:47 rainbow kernel: [   84.520140] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0d
Jan  9 17:48:47 rainbow kernel: [   84.520148] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0f
Jan  9 17:48:47 rainbow kernel: [   84.520157] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x05
Jan  9 17:48:47 rainbow kernel: [   84.520166] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x07
Jan  9 17:48:47 rainbow kernel: [   84.520173] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x09
Jan  9 17:48:47 rainbow kernel: [   84.520181] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0b
Jan  9 17:48:47 rainbow kernel: [   84.520189] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x01
Jan  9 17:48:47 rainbow kernel: [   84.520197] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x03
Jan  9 17:48:47 rainbow kernel: [   84.520205] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x0a
Jan  9 17:48:47 rainbow kernel: [   84.520213] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x14
Jan  9 17:48:47 rainbow kernel: [   84.520221] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x37
Jan  9 17:48:47 rainbow kernel: [   84.520229] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x6e
Jan  9 17:48:47 rainbow kernel: [   84.520242] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0412, 56 bytes at 18[18]:4
Jan  9 17:48:47 rainbow kernel: [   85.020112] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms
Jan  9 17:48:52 rainbow kernel: [   89.521622] ieee80211 phy0: U iwl3945_mac_hw_scan enter
Jan  9 17:48:52 rainbow kernel: [   89.521642] ieee80211 phy0: U iwl3945_mac_hw_scan direct scan for WLAN [4]
Jan  9 17:48:52 rainbow kernel: [   89.521645]  <3>ieee80211 phy0: U iwl3945_scan_initiate Starting scan...
Jan  9 17:48:52 rainbow kernel: [   89.521665] ieee80211 phy0: U iwl3945_mac_hw_scan leave
Jan  9 17:48:52 rainbow kernel: [   89.521679] ieee80211 phy0: U iwl3945_bg_request_scan Kicking off one direct scan for 'WLAN'
Jan  9 17:48:52 rainbow kernel: [   89.521692] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 1 [ACTIVE 42]
Jan  9 17:48:52 rainbow kernel: [   89.521700] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 2 [ACTIVE 42]
Jan  9 17:48:52 rainbow kernel: [   89.521707] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 3 [ACTIVE 42]
Jan  9 17:48:52 rainbow kernel: [   89.521715] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 4 [ACTIVE 42]
Jan  9 17:48:52 rainbow kernel: [   89.521723] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 5 [ACTIVE 42]
Jan  9 17:48:52 rainbow kernel: [   89.521731] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 6 [ACTIVE 42]
Jan  9 17:48:52 rainbow kernel: [   89.521739] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 7 [ACTIVE 42]
Jan  9 17:48:52 rainbow kernel: [   89.521747] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 8 [ACTIVE 42]
Jan  9 17:48:52 rainbow kernel: [   89.521754] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 9 [ACTIVE 42]
Jan  9 17:48:52 rainbow kernel: [   89.521763] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 10 [ACTIVE 42]
Jan  9 17:48:52 rainbow kernel: [   89.521771] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 11 [ACTIVE 42]
Jan  9 17:48:52 rainbow kernel: [   89.521779] ieee80211 phy0: U iwl3945_get_channels_for_scan total channels to scan 11 
Jan  9 17:48:52 rainbow kernel: [   89.521795] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x4413, 351 bytes at 19[32]:4
Jan  9 17:48:52 rainbow kernel: [   90.020109] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms
Jan  9 17:48:52 rainbow kernel: [   90.020124] ieee80211 phy0: U iwl3945_bg_scan_completed SCAN complete scan
Jan  9 17:48:52 rainbow kernel: [   90.020146] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0d
Jan  9 17:48:52 rainbow kernel: [   90.020155] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0f
Jan  9 17:48:52 rainbow kernel: [   90.020163] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x05
Jan  9 17:48:52 rainbow kernel: [   90.020171] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x07
Jan  9 17:48:52 rainbow kernel: [   90.020180] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x09
Jan  9 17:48:52 rainbow kernel: [   90.020188] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0b
Jan  9 17:48:52 rainbow kernel: [   90.020195] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x01
Jan  9 17:48:52 rainbow kernel: [   90.020203] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x03
Jan  9 17:48:52 rainbow kernel: [   90.020211] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x0a
Jan  9 17:48:52 rainbow kernel: [   90.020219] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x14
Jan  9 17:48:52 rainbow kernel: [   90.020227] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x37
Jan  9 17:48:52 rainbow kernel: [   90.020235] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x6e
Jan  9 17:48:52 rainbow kernel: [   90.020247] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0414, 56 bytes at 20[20]:4
Jan  9 17:48:53 rainbow kernel: [   90.520096] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms
Jan  9 17:48:54 rainbow kernel: [   91.352110] ieee80211 phy0: U iwl3945_hw_reg_txpower_get_temperature Temperature: 74
Jan  9 17:48:54 rainbow kernel: [   91.352124] ieee80211 phy0: U is_temp_calib_needed Getting cooler, delta -1,
Jan  9 17:48:54 rainbow kernel: [   91.352131] ieee80211 phy0: U is_temp_calib_needed Timed thermal calib not needed
Jan  9 17:48:57 rainbow kernel: [   95.021842] ieee80211 phy0: U iwl3945_mac_hw_scan enter
Jan  9 17:48:57 rainbow kernel: [   95.021860] ieee80211 phy0: U iwl3945_scan_initiate Starting scan...
Jan  9 17:48:57 rainbow kernel: [   95.021873] ieee80211 phy0: U iwl3945_mac_hw_scan leave
Jan  9 17:48:57 rainbow kernel: [   95.021886] ieee80211 phy0: U iwl3945_bg_request_scan Kicking off one indirect scan.
Jan  9 17:48:57 rainbow kernel: [   95.021898] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 1 [ACTIVE 39]
Jan  9 17:48:57 rainbow kernel: [   95.021906] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 2 [ACTIVE 39]
Jan  9 17:48:57 rainbow kernel: [   95.021915] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 3 [ACTIVE 39]
Jan  9 17:48:57 rainbow kernel: [   95.021923] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 4 [ACTIVE 39]
Jan  9 17:48:57 rainbow kernel: [   95.021930] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 5 [ACTIVE 39]
Jan  9 17:48:57 rainbow kernel: [   95.021937] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 6 [ACTIVE 39]
Jan  9 17:48:57 rainbow kernel: [   95.021945] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 7 [ACTIVE 39]
Jan  9 17:48:57 rainbow kernel: [   95.021953] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 8 [ACTIVE 39]
Jan  9 17:48:57 rainbow kernel: [   95.021960] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 9 [ACTIVE 39]
Jan  9 17:48:57 rainbow kernel: [   95.021967] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 10 [ACTIVE 39]
Jan  9 17:48:57 rainbow kernel: [   95.021975] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 11 [ACTIVE 39]
Jan  9 17:48:57 rainbow kernel: [   95.021984] ieee80211 phy0: U iwl3945_get_channels_for_scan total channels to scan 11 
Jan  9 17:48:57 rainbow kernel: [   95.022000] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x4415, 351 bytes at 21[32]:4
Jan  9 17:48:58 rainbow kernel: [   95.520101] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms
Jan  9 17:48:58 rainbow kernel: [   95.520116] ieee80211 phy0: U iwl3945_bg_scan_completed SCAN complete scan
Jan  9 17:48:58 rainbow kernel: [   95.520138] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0d
Jan  9 17:48:58 rainbow kernel: [   95.520147] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0f
Jan  9 17:48:58 rainbow kernel: [   95.520156] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x05
Jan  9 17:48:58 rainbow kernel: [   95.520164] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x07
Jan  9 17:48:58 rainbow kernel: [   95.520172] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x09
Jan  9 17:48:58 rainbow kernel: [   95.520179] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0b
Jan  9 17:48:58 rainbow kernel: [   95.520187] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x01
Jan  9 17:48:58 rainbow kernel: [   95.520195] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x03
Jan  9 17:48:58 rainbow kernel: [   95.520204] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x0a
Jan  9 17:48:58 rainbow kernel: [   95.520212] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x14
Jan  9 17:48:58 rainbow kernel: [   95.520220] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x37
Jan  9 17:48:58 rainbow kernel: [   95.520228] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x6e
Jan  9 17:48:58 rainbow kernel: [   95.520240] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0416, 56 bytes at 22[22]:4
Jan  9 17:48:58 rainbow kernel: [   96.020100] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms
Jan  9 17:49:03 rainbow kernel: [  100.521824] ieee80211 phy0: U iwl3945_mac_hw_scan enter
Jan  9 17:49:03 rainbow kernel: [  100.521844] ieee80211 phy0: U iwl3945_mac_hw_scan direct scan for WLAN [4]
Jan  9 17:49:03 rainbow kernel: [  100.521847]  <3>ieee80211 phy0: U iwl3945_scan_initiate Starting scan...
Jan  9 17:49:03 rainbow kernel: [  100.521869] ieee80211 phy0: U iwl3945_mac_hw_scan leave
Jan  9 17:49:03 rainbow kernel: [  100.521883] ieee80211 phy0: U iwl3945_bg_request_scan Kicking off one direct scan for 'WLAN'
Jan  9 17:49:03 rainbow kernel: [  100.521896] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 1 [ACTIVE 42]
Jan  9 17:49:03 rainbow kernel: [  100.521904] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 2 [ACTIVE 42]
Jan  9 17:49:03 rainbow kernel: [  100.521912] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 3 [ACTIVE 42]
Jan  9 17:49:03 rainbow kernel: [  100.521920] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 4 [ACTIVE 42]
Jan  9 17:49:03 rainbow kernel: [  100.521927] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 5 [ACTIVE 42]
Jan  9 17:49:03 rainbow kernel: [  100.521935] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 6 [ACTIVE 42]
Jan  9 17:49:03 rainbow kernel: [  100.521943] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 7 [ACTIVE 42]
Jan  9 17:49:03 rainbow kernel: [  100.521951] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 8 [ACTIVE 42]
Jan  9 17:49:03 rainbow kernel: [  100.521959] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 9 [ACTIVE 42]
Jan  9 17:49:03 rainbow kernel: [  100.521967] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 10 [ACTIVE 42]
Jan  9 17:49:03 rainbow kernel: [  100.521976] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 11 [ACTIVE 42]
Jan  9 17:49:03 rainbow kernel: [  100.521983] ieee80211 phy0: U iwl3945_get_channels_for_scan total channels to scan 11 
Jan  9 17:49:03 rainbow kernel: [  100.521998] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x4417, 351 bytes at 23[32]:4
Jan  9 17:49:03 rainbow kernel: [  101.020110] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms
Jan  9 17:49:03 rainbow kernel: [  101.020125] ieee80211 phy0: U iwl3945_bg_scan_completed SCAN complete scan
Jan  9 17:49:03 rainbow kernel: [  101.020147] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0d
Jan  9 17:49:03 rainbow kernel: [  101.020156] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0f
Jan  9 17:49:03 rainbow kernel: [  101.020164] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x05
Jan  9 17:49:03 rainbow kernel: [  101.020172] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x07
Jan  9 17:49:03 rainbow kernel: [  101.020180] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x09
Jan  9 17:49:03 rainbow kernel: [  101.020188] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0b
Jan  9 17:49:03 rainbow kernel: [  101.020196] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x01
Jan  9 17:49:03 rainbow kernel: [  101.020237] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x03
Jan  9 17:49:03 rainbow kernel: [  101.020246] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x0a
Jan  9 17:49:03 rainbow kernel: [  101.020254] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x14
Jan  9 17:49:03 rainbow kernel: [  101.020262] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x37
Jan  9 17:49:03 rainbow kernel: [  101.020270] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x6e
Jan  9 17:49:03 rainbow kernel: [  101.020283] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0418, 56 bytes at 24[24]:4
Jan  9 17:49:04 rainbow kernel: [  101.520101] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms
Jan  9 17:49:08 rainbow kernel: [  106.021633] ieee80211 phy0: U iwl3945_mac_hw_scan enter
Jan  9 17:49:08 rainbow kernel: [  106.021653] ieee80211 phy0: U iwl3945_scan_initiate Starting scan...
Jan  9 17:49:08 rainbow kernel: [  106.021666] ieee80211 phy0: U iwl3945_mac_hw_scan leave
Jan  9 17:49:08 rainbow kernel: [  106.021680] ieee80211 phy0: U iwl3945_bg_request_scan Kicking off one indirect scan.
Jan  9 17:49:08 rainbow kernel: [  106.021691] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 1 [ACTIVE 39]
Jan  9 17:49:08 rainbow kernel: [  106.021699] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 2 [ACTIVE 39]
Jan  9 17:49:08 rainbow kernel: [  106.021708] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 3 [ACTIVE 39]
Jan  9 17:49:08 rainbow kernel: [  106.021716] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 4 [ACTIVE 39]
Jan  9 17:49:08 rainbow kernel: [  106.021723] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 5 [ACTIVE 39]
Jan  9 17:49:08 rainbow kernel: [  106.021731] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 6 [ACTIVE 39]
Jan  9 17:49:08 rainbow kernel: [  106.021738] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 7 [ACTIVE 39]
Jan  9 17:49:08 rainbow kernel: [  106.021746] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 8 [ACTIVE 39]
Jan  9 17:49:08 rainbow kernel: [  106.021754] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 9 [ACTIVE 39]
Jan  9 17:49:08 rainbow kernel: [  106.021761] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 10 [ACTIVE 39]
Jan  9 17:49:08 rainbow kernel: [  106.021770] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 11 [ACTIVE 39]
Jan  9 17:49:08 rainbow kernel: [  106.021833] ieee80211 phy0: U iwl3945_get_channels_for_scan total channels to scan 11 
Jan  9 17:49:08 rainbow kernel: [  106.021849] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x4419, 351 bytes at 25[32]:4
Jan  9 17:49:09 rainbow kernel: [  106.520099] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms
Jan  9 17:49:09 rainbow kernel: [  106.520115] ieee80211 phy0: U iwl3945_bg_scan_completed SCAN complete scan
Jan  9 17:49:09 rainbow kernel: [  106.520137] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0d
Jan  9 17:49:09 rainbow kernel: [  106.520147] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0f
Jan  9 17:49:09 rainbow kernel: [  106.520155] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x05
Jan  9 17:49:09 rainbow kernel: [  106.520164] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x07
Jan  9 17:49:09 rainbow kernel: [  106.520171] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x09
Jan  9 17:49:09 rainbow kernel: [  106.520179] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0b
Jan  9 17:49:09 rainbow kernel: [  106.520187] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x01
Jan  9 17:49:09 rainbow kernel: [  106.520195] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x03
Jan  9 17:49:09 rainbow kernel: [  106.520203] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x0a
Jan  9 17:49:09 rainbow kernel: [  106.520211] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x14
Jan  9 17:49:09 rainbow kernel: [  106.520219] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x37
Jan  9 17:49:09 rainbow kernel: [  106.520227] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x6e
Jan  9 17:49:09 rainbow kernel: [  106.520240] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x041A, 56 bytes at 26[26]:4
Jan  9 17:49:09 rainbow kernel: [  107.020102] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms
Jan  9 17:49:14 rainbow kernel: [  111.521808] ieee80211 phy0: U iwl3945_mac_hw_scan enter
Jan  9 17:49:14 rainbow kernel: [  111.521828] ieee80211 phy0: U iwl3945_mac_hw_scan direct scan for WLAN [4]
Jan  9 17:49:14 rainbow kernel: [  111.521831]  <3>ieee80211 phy0: U iwl3945_scan_initiate Starting scan...
Jan  9 17:49:14 rainbow kernel: [  111.521851] ieee80211 phy0: U iwl3945_mac_hw_scan leave
Jan  9 17:49:14 rainbow kernel: [  111.521865] ieee80211 phy0: U iwl3945_bg_request_scan Kicking off one direct scan for 'WLAN'
Jan  9 17:49:14 rainbow kernel: [  111.521879] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 1 [ACTIVE 42]
Jan  9 17:49:14 rainbow kernel: [  111.521886] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 2 [ACTIVE 42]
Jan  9 17:49:14 rainbow kernel: [  111.521893] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 3 [ACTIVE 42]
Jan  9 17:49:14 rainbow kernel: [  111.521901] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 4 [ACTIVE 42]
Jan  9 17:49:14 rainbow kernel: [  111.521909] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 5 [ACTIVE 42]
Jan  9 17:49:14 rainbow kernel: [  111.521933] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 6 [ACTIVE 42]
Jan  9 17:49:14 rainbow kernel: [  111.521940] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 7 [ACTIVE 42]
Jan  9 17:49:14 rainbow kernel: [  111.521948] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 8 [ACTIVE 42]
Jan  9 17:49:14 rainbow kernel: [  111.521956] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 9 [ACTIVE 42]
Jan  9 17:49:14 rainbow kernel: [  111.521963] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 10 [ACTIVE 42]
Jan  9 17:49:14 rainbow kernel: [  111.521971] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 11 [ACTIVE 42]
Jan  9 17:49:14 rainbow kernel: [  111.521979] ieee80211 phy0: U iwl3945_get_channels_for_scan total channels to scan 11 
Jan  9 17:49:14 rainbow kernel: [  111.521994] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x441B, 351 bytes at 27[32]:4
Jan  9 17:49:14 rainbow kernel: [  112.020098] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms
Jan  9 17:49:14 rainbow kernel: [  112.020114] ieee80211 phy0: U iwl3945_bg_scan_completed SCAN complete scan
Jan  9 17:49:14 rainbow kernel: [  112.020136] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0d
Jan  9 17:49:14 rainbow kernel: [  112.020144] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0f
Jan  9 17:49:14 rainbow kernel: [  112.020153] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x05
Jan  9 17:49:14 rainbow kernel: [  112.020161] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x07
Jan  9 17:49:14 rainbow kernel: [  112.020169] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x09
Jan  9 17:49:14 rainbow kernel: [  112.020176] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0b
Jan  9 17:49:14 rainbow kernel: [  112.020184] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x01
Jan  9 17:49:14 rainbow kernel: [  112.020191] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x03
Jan  9 17:49:14 rainbow kernel: [  112.020199] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x0a
Jan  9 17:49:14 rainbow kernel: [  112.020208] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x14
Jan  9 17:49:14 rainbow kernel: [  112.020216] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x37
Jan  9 17:49:14 rainbow kernel: [  112.020224] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x6e
Jan  9 17:49:14 rainbow kernel: [  112.020237] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x041C, 56 bytes at 28[28]:4
Jan  9 17:49:15 rainbow kernel: [  112.520154] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms
Jan  9 17:49:19 rainbow kernel: [  117.021774] ieee80211 phy0: U iwl3945_mac_hw_scan enter
Jan  9 17:49:19 rainbow kernel: [  117.021792] ieee80211 phy0: U iwl3945_scan_initiate Starting scan...
Jan  9 17:49:19 rainbow kernel: [  117.021804] ieee80211 phy0: U iwl3945_mac_hw_scan leave
Jan  9 17:49:19 rainbow kernel: [  117.021817] ieee80211 phy0: U iwl3945_bg_request_scan Kicking off one indirect scan.
Jan  9 17:49:19 rainbow kernel: [  117.021829] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 1 [ACTIVE 39]
Jan  9 17:49:19 rainbow kernel: [  117.021838] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 2 [ACTIVE 39]
Jan  9 17:49:19 rainbow kernel: [  117.021847] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 3 [ACTIVE 39]
Jan  9 17:49:19 rainbow kernel: [  117.021855] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 4 [ACTIVE 39]
Jan  9 17:49:19 rainbow kernel: [  117.021863] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 5 [ACTIVE 39]
Jan  9 17:49:19 rainbow kernel: [  117.021870] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 6 [ACTIVE 39]
Jan  9 17:49:19 rainbow kernel: [  117.021878] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 7 [ACTIVE 39]
Jan  9 17:49:19 rainbow kernel: [  117.021886] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 8 [ACTIVE 39]
Jan  9 17:49:19 rainbow kernel: [  117.021894] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 9 [ACTIVE 39]
Jan  9 17:49:19 rainbow kernel: [  117.021902] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 10 [ACTIVE 39]
Jan  9 17:49:19 rainbow kernel: [  117.021910] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 11 [ACTIVE 39]
Jan  9 17:49:19 rainbow kernel: [  117.021917] ieee80211 phy0: U iwl3945_get_channels_for_scan total channels to scan 11 
Jan  9 17:49:19 rainbow kernel: [  117.021934] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x441D, 351 bytes at 29[32]:4
Jan  9 17:49:20 rainbow kernel: [  117.520101] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms
Jan  9 17:49:20 rainbow kernel: [  117.520114] ieee80211 phy0: U iwl3945_bg_scan_completed SCAN complete scan
Jan  9 17:49:20 rainbow kernel: [  117.520136] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0d
Jan  9 17:49:20 rainbow kernel: [  117.520145] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0f
Jan  9 17:49:20 rainbow kernel: [  117.520152] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x05
Jan  9 17:49:20 rainbow kernel: [  117.520160] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x07
Jan  9 17:49:20 rainbow kernel: [  117.520168] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x09
Jan  9 17:49:20 rainbow kernel: [  117.520176] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0b
Jan  9 17:49:20 rainbow kernel: [  117.520184] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x01
Jan  9 17:49:20 rainbow kernel: [  117.520192] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x03
Jan  9 17:49:20 rainbow kernel: [  117.520200] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x0a
Jan  9 17:49:20 rainbow kernel: [  117.520209] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x14
Jan  9 17:49:20 rainbow kernel: [  117.520217] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x37
Jan  9 17:49:20 rainbow kernel: [  117.520225] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x6e
Jan  9 17:49:20 rainbow kernel: [  117.520237] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x041E, 56 bytes at 30[30]:4
Jan  9 17:49:20 rainbow kernel: [  118.020110] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms
Jan  9 17:49:25 rainbow kernel: [  122.521834] ieee80211 phy0: U iwl3945_mac_hw_scan enter
Jan  9 17:49:25 rainbow kernel: [  122.521856] ieee80211 phy0: U iwl3945_mac_hw_scan direct scan for WLAN [4]
Jan  9 17:49:25 rainbow kernel: [  122.521859]  <3>ieee80211 phy0: U iwl3945_scan_initiate Starting scan...
Jan  9 17:49:25 rainbow kernel: [  122.521877] ieee80211 phy0: U iwl3945_mac_hw_scan leave
Jan  9 17:49:25 rainbow kernel: [  122.521890] ieee80211 phy0: U iwl3945_bg_request_scan Kicking off one direct scan for 'WLAN'
Jan  9 17:49:25 rainbow kernel: [  122.521903] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 1 [ACTIVE 42]
Jan  9 17:49:25 rainbow kernel: [  122.521911] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 2 [ACTIVE 42]
Jan  9 17:49:25 rainbow kernel: [  122.521919] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 3 [ACTIVE 42]
Jan  9 17:49:25 rainbow kernel: [  122.521927] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 4 [ACTIVE 42]
Jan  9 17:49:25 rainbow kernel: [  122.521935] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 5 [ACTIVE 42]
Jan  9 17:49:25 rainbow kernel: [  122.521942] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 6 [ACTIVE 42]
Jan  9 17:49:25 rainbow kernel: [  122.521950] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 7 [ACTIVE 42]
Jan  9 17:49:25 rainbow kernel: [  122.521957] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 8 [ACTIVE 42]
Jan  9 17:49:25 rainbow kernel: [  122.521965] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 9 [ACTIVE 42]
Jan  9 17:49:25 rainbow kernel: [  122.521973] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 10 [ACTIVE 42]
Jan  9 17:49:25 rainbow kernel: [  122.522038] ieee80211 phy0: U iwl3945_get_channels_for_scan Scanning 11 [ACTIVE 42]
Jan  9 17:49:25 rainbow kernel: [  122.522046] ieee80211 phy0: U iwl3945_get_channels_for_scan total channels to scan 11 
Jan  9 17:49:25 rainbow kernel: [  122.522062] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x441F, 351 bytes at 31[32]:4
Jan  9 17:49:25 rainbow kernel: [  123.020111] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms
Jan  9 17:49:25 rainbow kernel: [  123.020124] ieee80211 phy0: U iwl3945_bg_scan_completed SCAN complete scan
Jan  9 17:49:25 rainbow kernel: [  123.020145] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0d
Jan  9 17:49:25 rainbow kernel: [  123.020153] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0f
Jan  9 17:49:25 rainbow kernel: [  123.020161] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x05
Jan  9 17:49:25 rainbow kernel: [  123.020169] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x07
Jan  9 17:49:25 rainbow kernel: [  123.020177] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x09
Jan  9 17:49:25 rainbow kernel: [  123.020185] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0b
Jan  9 17:49:25 rainbow kernel: [  123.020193] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x01
Jan  9 17:49:25 rainbow kernel: [  123.020200] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x03
Jan  9 17:49:25 rainbow kernel: [  123.020208] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x0a
Jan  9 17:49:25 rainbow kernel: [  123.020216] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x14
Jan  9 17:49:25 rainbow kernel: [  123.020225] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x37
Jan  9 17:49:25 rainbow kernel: [  123.020233] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x6e
Jan  9 17:49:25 rainbow kernel: [  123.020299] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0420, 56 bytes at 32[0]:4
Jan  9 17:49:26 rainbow kernel: [  123.520145] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms
Jan  9 17:49:30 rainbow kernel: [  127.511538] ieee80211 phy0: U iwl3945_mac_config enter to channel 11
Jan  9 17:49:30 rainbow kernel: [  127.511571] ieee80211 phy0: U iwl3945_commit_rxon Sending RXON
Jan  9 17:49:30 rainbow kernel: [  127.511574] * without RXON_FILTER_ASSOC_MSK
Jan  9 17:49:30 rainbow kernel: [  127.511576] * channel = 11
Jan  9 17:49:30 rainbow kernel: [  127.511577] * bssid = 00:00:00:00:00:00
Jan  9 17:49:30 rainbow kernel: [  127.511605] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x0421, 48 bytes at 33[1]:4
Jan  9 17:49:30 rainbow kernel: [  128.009021] iwl3945 0000:03:00.0: Error sending REPLY_RXON: time out after 500ms
Jan  9 17:49:30 rainbow kernel: [  128.009036] iwl3945 0000:03:00.0: Error setting new configuration (-110).
Jan  9 17:49:30 rainbow kernel: [  128.009041] ieee80211 phy0: U iwl3945_mac_config leave
Jan  9 17:49:30 rainbow kernel: [  128.009047] ieee80211 phy0: U iwl3945_mac_conf_tx enter
Jan  9 17:49:30 rainbow kernel: [  128.009052] ieee80211 phy0: U iwl3945_mac_conf_tx leave
Jan  9 17:49:30 rainbow kernel: [  128.009054] ieee80211 phy0: U iwl3945_mac_conf_tx enter
Jan  9 17:49:30 rainbow kernel: [  128.009057] ieee80211 phy0: U iwl3945_mac_conf_tx leave
Jan  9 17:49:30 rainbow kernel: [  128.009059] ieee80211 phy0: U iwl3945_mac_conf_tx enter
Jan  9 17:49:30 rainbow kernel: [  128.009062] ieee80211 phy0: U iwl3945_mac_conf_tx leave
Jan  9 17:49:30 rainbow kernel: [  128.009065] ieee80211 phy0: U iwl3945_mac_conf_tx enter
Jan  9 17:49:30 rainbow kernel: [  128.009067] ieee80211 phy0: U iwl3945_mac_conf_tx leave
Jan  9 17:49:30 rainbow kernel: [  128.009071] ieee80211 phy0: U iwl3945_mac_reset_tsf enter
Jan  9 17:49:30 rainbow kernel: [  128.009077] ieee80211 phy0: U iwl3945_commit_rxon Sending RXON
Jan  9 17:49:30 rainbow kernel: [  128.009077] * without RXON_FILTER_ASSOC_MSK
Jan  9 17:49:30 rainbow kernel: [  128.009078] * channel = 11
Jan  9 17:49:30 rainbow kernel: [  128.009078] * bssid = 00:00:00:00:00:00
Jan  9 17:49:30 rainbow kernel: [  128.009089] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x0422, 48 bytes at 34[2]:4
Jan  9 17:49:31 rainbow kernel: [  128.511331] iwl3945 0000:03:00.0: Error sending REPLY_RXON: time out after 500ms
Jan  9 17:49:31 rainbow kernel: [  128.511342] iwl3945 0000:03:00.0: Error setting new configuration (-110).
Jan  9 17:49:31 rainbow kernel: [  128.511347] ieee80211 phy0: U iwl3945_mac_reset_tsf leave - not in IBSS
Jan  9 17:49:31 rainbow kernel: [  128.511353] wlan0: direct probe to AP 00:30:bd:c0:90:24 try 1
Jan  9 17:49:31 rainbow kernel: [  128.511367] ieee80211 phy0: I iwl3945_mac_tx enter
Jan  9 17:49:31 rainbow kernel: [  128.511402] ieee80211 phy0: I iwl3945_mac_tx leave
Jan  9 17:49:31 rainbow kernel: [  128.511483] iwl3945 0000:03:00.0: Microcode SW error detected. Restarting 0x82000008.
Jan  9 17:49:31 rainbow kernel: [  128.511511] iwl3945 0000:03:00.0: Start IWL Error Log Dump:
Jan  9 17:49:31 rainbow kernel: [  128.511513] iwl3945 0000:03:00.0: Status: 0x000302E4, count: 1
Jan  9 17:49:31 rainbow kernel: [  128.511516] iwl3945 0000:03:00.0: Desc       Time       asrtPC  blink2 ilink1  nmiPC   Line
Jan  9 17:49:31 rainbow kernel: [  128.511584] iwl3945 0000:03:00.0: SYSASSERT     (#5) 0097076438 0x0089A 0x0025E 0x00304 0x01BCC 78
Jan  9 17:49:31 rainbow kernel: [  128.511585] 
Jan  9 17:49:31 rainbow kernel: [  128.511647] iwl3945 0000:03:00.0: Start IWL Event Log Dump: display count 512, wraps 1
Jan  9 17:49:31 rainbow kernel: [  128.511678] iwl3945 0000:03:00.0: 0000003900^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.511709] iwl3945 0000:03:00.0: 0000003904^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.511739] iwl3945 0000:03:00.0: 0000003908^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.511769] iwl3945 0000:03:00.0: 0000003912^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.511799] iwl3945 0000:03:00.0: 0000003917^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.511829] iwl3945 0000:03:00.0: 0000003921^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.511859] iwl3945 0000:03:00.0: 0000003925^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.511889] iwl3945 0000:03:00.0: 0000003929^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.511919] iwl3945 0000:03:00.0: 0000003934^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.511949] iwl3945 0000:03:00.0: 0000003938^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.511980] iwl3945 0000:03:00.0: 0000003942^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.512010] iwl3945 0000:03:00.0: 0000003947^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.512040] iwl3945 0000:03:00.0: 0000003951^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.512070] iwl3945 0000:03:00.0: 0000003955^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.512101] iwl3945 0000:03:00.0: 0000003959^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.512131] iwl3945 0000:03:00.0: 0000003964^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.512161] iwl3945 0000:03:00.0: 0000003968^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.512191] iwl3945 0000:03:00.0: 0000003972^I0x00000001^I1106
Jan  9 17:49:31 rainbow kernel: [  128.512221] iwl3945 0000:03:00.0: 0000003973^I0x0000000f^I1106
Jan  9 17:49:31 rainbow kernel: [  128.512251] iwl3945 0000:03:00.0: 0000003975^I0x00000396^I1105
Jan  9 17:49:31 rainbow kernel: [  128.512281] iwl3945 0000:03:00.0: 0000003978^I0x00000403^I1115
Jan  9 17:49:31 rainbow kernel: [  128.512311] iwl3945 0000:03:00.0: 0000003982^I0x0000000b^I0463
Jan  9 17:49:31 rainbow kernel: [  128.512342] iwl3945 0000:03:00.0: 0000003983^I0x0000000b^I0462
Jan  9 17:49:31 rainbow kernel: [  128.512372] iwl3945 0000:03:00.0: 0000003994^I0x0000010c^I0601
Jan  9 17:49:31 rainbow kernel: [  128.512402] iwl3945 0000:03:00.0: 0000004004^I0x04040018^I0401
Jan  9 17:49:31 rainbow kernel: [  128.512433] iwl3945 0000:03:00.0: 0000004011^I0x000000d9^I0106
Jan  9 17:49:31 rainbow kernel: [  128.512463] iwl3945 0000:03:00.0: 0000004013^I0x00000000^I0301
Jan  9 17:49:31 rainbow kernel: [  128.512492] iwl3945 0000:03:00.0: 0000004085^I0x00000001^I0353
Jan  9 17:49:31 rainbow kernel: [  128.512522] iwl3945 0000:03:00.0: 0000004095^I0x00000000^I0352
Jan  9 17:49:31 rainbow kernel: [  128.512552] iwl3945 0000:03:00.0: 0000004102^I0x000000d9^I0106
Jan  9 17:49:31 rainbow kernel: [  128.512582] iwl3945 0000:03:00.0: 0000004104^I0x00000000^I0301
Jan  9 17:49:31 rainbow kernel: [  128.512612] iwl3945 0000:03:00.0: 0000004174^I0x00000002^I0353
Jan  9 17:49:31 rainbow kernel: [  128.512642] iwl3945 0000:03:00.0: 0000004185^I0x00000000^I0352
Jan  9 17:49:31 rainbow kernel: [  128.512672] iwl3945 0000:03:00.0: 0000004191^I0x000000d9^I0106
Jan  9 17:49:31 rainbow kernel: [  128.512702] iwl3945 0000:03:00.0: 0000004193^I0x00000000^I0301
Jan  9 17:49:31 rainbow kernel: [  128.512732] iwl3945 0000:03:00.0: 0000004264^I0x00000003^I0353
Jan  9 17:49:31 rainbow kernel: [  128.512766] iwl3945 0000:03:00.0: 0000004274^I0x00000000^I0352
Jan  9 17:49:31 rainbow kernel: [  128.512796] iwl3945 0000:03:00.0: 0000004281^I0x000000d9^I0106
Jan  9 17:49:31 rainbow kernel: [  128.512827] iwl3945 0000:03:00.0: 0000004283^I0x00000000^I0301
Jan  9 17:49:31 rainbow kernel: [  128.512857] iwl3945 0000:03:00.0: 0000004292^I0x00008000^I0350
Jan  9 17:49:31 rainbow kernel: [  128.512887] iwl3945 0000:03:00.0: 0000004296^I0x04050047^I0401
Jan  9 17:49:31 rainbow kernel: [  128.512917] iwl3945 0000:03:00.0: 0000004327^I0x0000010f^I0603
Jan  9 17:49:31 rainbow kernel: [  128.512947] iwl3945 0000:03:00.0: 0000004402^I0x00000180^I0604
Jan  9 17:49:31 rainbow kernel: [  128.512977] iwl3945 0000:03:00.0: 0000004404^I0x0000019c^I0610
Jan  9 17:49:31 rainbow kernel: [  128.513007] iwl3945 0000:03:00.0: 0000004405^I0x00017ecc^I0610
Jan  9 17:49:31 rainbow kernel: [  128.513037] iwl3945 0000:03:00.0: 0000004406^I0x02000000^I0610
Jan  9 17:49:31 rainbow kernel: [  128.513067] iwl3945 0000:03:00.0: 0000004454^I0x00000500^I0600
Jan  9 17:49:31 rainbow kernel: [  128.513097] iwl3945 0000:03:00.0: 0000005954^I0x000001ed^I0616
Jan  9 17:49:31 rainbow kernel: [  128.513127] iwl3945 0000:03:00.0: 0000004448^I0x00017ea0^I0638
Jan  9 17:49:31 rainbow kernel: [  128.513157] iwl3945 0000:03:00.0: 0000004871^I0x0000001c^I1101
Jan  9 17:49:31 rainbow kernel: [  128.513187] iwl3945 0000:03:00.0: 0000004904^I0x0000001a^I1101
Jan  9 17:49:31 rainbow kernel: [  128.513217] iwl3945 0000:03:00.0: 0000004931^I0x000000ff^I1103
Jan  9 17:49:31 rainbow kernel: [  128.513248] iwl3945 0000:03:00.0: 0000004932^I0xffff9111^I1103
Jan  9 17:49:31 rainbow kernel: [  128.513278] iwl3945 0000:03:00.0: 0000004934^I0x00000010^I1101
Jan  9 17:49:31 rainbow kernel: [  128.513310] iwl3945 0000:03:00.0: 0000004952^I0x00000011^I1101
Jan  9 17:49:31 rainbow kernel: [  128.513340] iwl3945 0000:03:00.0: 0000004965^I0x00000000^I1101
Jan  9 17:49:31 rainbow kernel: [  128.513370] iwl3945 0000:03:00.0: 0000004966^I0x00000000^I1101
Jan  9 17:49:31 rainbow kernel: [  128.513401] iwl3945 0000:03:00.0: 0000004968^I0x000001d8^I1101
Jan  9 17:49:31 rainbow kernel: [  128.513431] iwl3945 0000:03:00.0: 0000004970^I0x00000065^I1104
Jan  9 17:49:31 rainbow kernel: [  128.513461] iwl3945 0000:03:00.0: 0000004972^I0x0000000e^I1101
Jan  9 17:49:31 rainbow kernel: [  128.513491] iwl3945 0000:03:00.0: 0000004973^I0x00680034^I1102
Jan  9 17:49:31 rainbow kernel: [  128.513521] iwl3945 0000:03:00.0: 0000004974^I0x00670035^I1102
Jan  9 17:49:31 rainbow kernel: [  128.513551] iwl3945 0000:03:00.0: 0000004976^I0x007e0036^I1102
Jan  9 17:49:31 rainbow kernel: [  128.513581] iwl3945 0000:03:00.0: 0000004978^I0x007c0037^I1102
Jan  9 17:49:31 rainbow kernel: [  128.513612] iwl3945 0000:03:00.0: 0000004979^I0x00000038^I1102
Jan  9 17:49:31 rainbow kernel: [  128.513642] iwl3945 0000:03:00.0: 0000004981^I0x00840052^I1102
Jan  9 17:49:31 rainbow kernel: [  128.513672] iwl3945 0000:03:00.0: 0000004982^I0x00840053^I1102
Jan  9 17:49:31 rainbow kernel: [  128.513702] iwl3945 0000:03:00.0: 0000004984^I0x007e0054^I1102
Jan  9 17:49:31 rainbow kernel: [  128.513733] iwl3945 0000:03:00.0: 0000004985^I0x007d0055^I1102
Jan  9 17:49:31 rainbow kernel: [  128.513763] iwl3945 0000:03:00.0: 0000004987^I0x00000056^I1102
Jan  9 17:49:31 rainbow kernel: [  128.513794] iwl3945 0000:03:00.0: 0000004988^I0x00007050^I1102
Jan  9 17:49:31 rainbow kernel: [  128.513824] iwl3945 0000:03:00.0: 0000004990^I0x00017051^I1102
Jan  9 17:49:31 rainbow kernel: [  128.513854] iwl3945 0000:03:00.0: 0000004992^I0x00008204^I1102
Jan  9 17:49:31 rainbow kernel: [  128.513884] iwl3945 0000:03:00.0: 0000004994^I0x00018205^I1102
Jan  9 17:49:31 rainbow kernel: [  128.513914] iwl3945 0000:03:00.0: 0000004997^I0x00000001^I1101
Jan  9 17:49:31 rainbow kernel: [  128.513944] iwl3945 0000:03:00.0: 0000004998^I0x008b0063^I1102
Jan  9 17:49:31 rainbow kernel: [  128.513974] iwl3945 0000:03:00.0: 0000005000^I0x0000001d^I1104
Jan  9 17:49:31 rainbow kernel: [  128.514004] iwl3945 0000:03:00.0: 0000005002^I0x00000069^I1114
Jan  9 17:49:31 rainbow kernel: [  128.514034] iwl3945 0000:03:00.0: 0000005023^I0x0000020f^I0605
Jan  9 17:49:31 rainbow kernel: [  128.514064] iwl3945 0000:03:00.0: 0000005024^I0x0000026b^I0621
Jan  9 17:49:31 rainbow kernel: [  128.514094] iwl3945 0000:03:00.0: 0000005028^I0x0000010b^I1108
Jan  9 17:49:31 rainbow kernel: [  128.514124] iwl3945 0000:03:00.0: 0000005030^I0x0000000e^I1101
Jan  9 17:49:31 rainbow kernel: [  128.514154] iwl3945 0000:03:00.0: 0000005031^I0x00680034^I1102
Jan  9 17:49:31 rainbow kernel: [  128.514184] iwl3945 0000:03:00.0: 0000005032^I0x00670035^I1102
Jan  9 17:49:31 rainbow kernel: [  128.514216] iwl3945 0000:03:00.0: 0000005034^I0x007e0036^I1102
Jan  9 17:49:31 rainbow kernel: [  128.514247] iwl3945 0000:03:00.0: 0000005035^I0x007c0037^I1102
Jan  9 17:49:31 rainbow kernel: [  128.514279] iwl3945 0000:03:00.0: 0000005037^I0x00000038^I1102
Jan  9 17:49:31 rainbow kernel: [  128.514309] iwl3945 0000:03:00.0: 0000005038^I0x00840052^I1102
Jan  9 17:49:31 rainbow kernel: [  128.514340] iwl3945 0000:03:00.0: 0000005040^I0x00840053^I1102
Jan  9 17:49:31 rainbow kernel: [  128.514370] iwl3945 0000:03:00.0: 0000005041^I0x007e0054^I1102
Jan  9 17:49:31 rainbow kernel: [  128.514400] iwl3945 0000:03:00.0: 0000005043^I0x007d0055^I1102
Jan  9 17:49:31 rainbow kernel: [  128.514430] iwl3945 0000:03:00.0: 0000005044^I0x00000056^I1102
Jan  9 17:49:31 rainbow kernel: [  128.514460] iwl3945 0000:03:00.0: 0000005046^I0x00007050^I1102
Jan  9 17:49:31 rainbow kernel: [  128.514490] iwl3945 0000:03:00.0: 0000005048^I0x00017051^I1102
Jan  9 17:49:31 rainbow kernel: [  128.514520] iwl3945 0000:03:00.0: 0000005050^I0x00008204^I1102
Jan  9 17:49:31 rainbow kernel: [  128.514550] iwl3945 0000:03:00.0: 0000005052^I0x00018205^I1102
Jan  9 17:49:31 rainbow kernel: [  128.514580] iwl3945 0000:03:00.0: 0000005055^I0x00000001^I1101
Jan  9 17:49:31 rainbow kernel: [  128.514610] iwl3945 0000:03:00.0: 0000005056^I0x008b0063^I1102
Jan  9 17:49:31 rainbow kernel: [  128.514641] iwl3945 0000:03:00.0: 0000005058^I0x0000001c^I1104
Jan  9 17:49:31 rainbow kernel: [  128.514671] iwl3945 0000:03:00.0: 0000005060^I0x00000002^I1101
Jan  9 17:49:31 rainbow kernel: [  128.514702] iwl3945 0000:03:00.0: 0000005060^I0x0083903f^I1102
Jan  9 17:49:31 rainbow kernel: [  128.514733] iwl3945 0000:03:00.0: 0000005062^I0x0001d213^I1102
Jan  9 17:49:31 rainbow kernel: [  128.514764] iwl3945 0000:03:00.0: 0000005066^I0x00000002^I1101
Jan  9 17:49:31 rainbow kernel: [  128.514795] iwl3945 0000:03:00.0: 0000005066^I0x0003d206^I1102
Jan  9 17:49:31 rainbow kernel: [  128.514825] iwl3945 0000:03:00.0: 0000005068^I0x0083903e^I1102
Jan  9 17:49:31 rainbow kernel: [  128.514855] iwl3945 0000:03:00.0: 0000005072^I0x00000059^I1101
Jan  9 17:49:31 rainbow kernel: [  128.514886] iwl3945 0000:03:00.0: 0000005172^I0x00000013^I1101
Jan  9 17:49:31 rainbow kernel: [  128.514916] iwl3945 0000:03:00.0: 0000005190^I0x00000005^I1107
Jan  9 17:49:31 rainbow kernel: [  128.514946] iwl3945 0000:03:00.0: 0000005758^I0x00017983^I1110
Jan  9 17:49:31 rainbow kernel: [  128.514976] iwl3945 0000:03:00.0: 0000005769^I0xffffff47^I0454
Jan  9 17:49:31 rainbow kernel: [  128.515007] iwl3945 0000:03:00.0: 0000005770^I0x00000000^I0472
Jan  9 17:49:31 rainbow kernel: [  128.515037] iwl3945 0000:03:00.0: 0000005780^I0x0000000b^I0463
Jan  9 17:49:31 rainbow kernel: [  128.515067] iwl3945 0000:03:00.0: 0000005783^I0xffffff47^I1111
Jan  9 17:49:31 rainbow kernel: [  128.515097] iwl3945 0000:03:00.0: 0000005788^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515128] iwl3945 0000:03:00.0: 0000005788^I0x0000000e^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515158] iwl3945 0000:03:00.0: 0000005793^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515190] iwl3945 0000:03:00.0: 0000005797^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515220] iwl3945 0000:03:00.0: 0000005801^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515251] iwl3945 0000:03:00.0: 0000005805^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515281] iwl3945 0000:03:00.0: 0000005810^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515312] iwl3945 0000:03:00.0: 0000005814^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515342] iwl3945 0000:03:00.0: 0000005818^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515372] iwl3945 0000:03:00.0: 0000005823^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515402] iwl3945 0000:03:00.0: 0000005827^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515432] iwl3945 0000:03:00.0: 0000005831^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000005835^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000005840^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000005844^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000005848^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000005852^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000005857^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000005861^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000005865^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000005870^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000005874^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000005878^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000005882^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000005887^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000005891^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000005895^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000005899^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000005904^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000005908^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000005912^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000005917^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000005921^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000005925^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000005929^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000005934^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000005938^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000005942^I0x00000001^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000005943^I0x0000000f^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000005945^I0x00000396^I1105
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000005948^I0x00000403^I1115
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000005952^I0x0000000b^I0463
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000005953^I0x0000000b^I0462
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000005964^I0x0000010c^I0601
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000005975^I0x04060047^I0401
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000005985^I0x0000010f^I0603
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006056^I0x00000180^I0604
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006058^I0x0000019c^I0610
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006059^I0x00017856^I0610
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006060^I0x00000000^I0610
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006108^I0x00000500^I0600
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007610^I0x000001ed^I0616
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006102^I0x0001782a^I0638
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006125^I0x0000001c^I1101
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006158^I0x0000001a^I1101
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006185^I0x000000ff^I1103
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006186^I0xffff9111^I1103
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006188^I0x00000010^I1101
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006206^I0x00000011^I1101
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006219^I0x00000000^I1101
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006220^I0x00000000^I1101
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006222^I0x000001d8^I1101
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006224^I0x00000065^I1104
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006226^I0x0000000e^I1101
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006227^I0x00680034^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006228^I0x00670035^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006230^I0x007e0036^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006232^I0x007c0037^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006233^I0x00000038^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006235^I0x00840052^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006236^I0x00840053^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006238^I0x007e0054^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006239^I0x007d0055^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006241^I0x00000056^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006242^I0x00007050^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006244^I0x00017051^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006246^I0x00008204^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006248^I0x00018205^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006251^I0x00000001^I1101
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006252^I0x008b0063^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006254^I0x0000001d^I1104
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006256^I0x00000069^I1114
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006277^I0x0000020f^I0605
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006278^I0x0000026b^I0621
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006282^I0x0000010b^I1108
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006284^I0x0000000e^I1101
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006285^I0x00680034^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006286^I0x00670035^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006288^I0x007e0036^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006289^I0x007c0037^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006291^I0x00000038^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006292^I0x00840052^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006294^I0x00840053^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006295^I0x007e0054^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006297^I0x007d0055^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006298^I0x00000056^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006300^I0x00007050^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006302^I0x00017051^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006304^I0x00008204^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006306^I0x00018205^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006309^I0x00000001^I1101
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006310^I0x008b0063^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006312^I0x0000001c^I1104
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006313^I0x00000002^I1101
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006314^I0x0083903f^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006316^I0x0001d213^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006319^I0x00000002^I1101
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006320^I0x0003d206^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006322^I0x0083903e^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006326^I0x00000059^I1101
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006426^I0x00000013^I1101
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000006444^I0x00000005^I1107
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007012^I0x0001749d^I1110
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007023^I0xffffff47^I0454
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007024^I0x00000000^I0472
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007034^I0x0000000b^I0463
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007037^I0xffffff47^I1111
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007042^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007042^I0x0000000e^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007047^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007051^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007055^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007059^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007064^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007068^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007072^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007077^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007081^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007085^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007089^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007094^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007098^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007102^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007106^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007111^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007115^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007119^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007124^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007128^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007132^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007136^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007141^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007145^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007149^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007153^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007158^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007162^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007166^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007171^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007175^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007179^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007183^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007188^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007192^I0x00000001^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007193^I0x0000000f^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007194^I0x00000392^I1105
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007198^I0x00000403^I1115
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007201^I0x0000000b^I0463
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007202^I0x0000000b^I0462
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007213^I0x0000010c^I0601
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007224^I0x04070097^I0401
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007227^I0x0000000b^I0451
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007246^I0x00000000^I0451
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007260^I0x0000010f^I0603
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007326^I0x00000180^I0604
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007328^I0x0000019c^I0610
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007329^I0x00017360^I0610
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007330^I0x00000000^I0610
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007378^I0x00000500^I0600
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008880^I0x000001ed^I0616
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007372^I0x00017334^I0638
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007395^I0x0000001c^I1101
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007428^I0x0000001a^I1101
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007455^I0x000000ff^I1103
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007456^I0xffff9111^I1103
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007458^I0x00000010^I1101
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007476^I0x00000011^I1101
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007489^I0x00000000^I1101
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007490^I0x00000000^I1101
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007492^I0x000001d8^I1101
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007494^I0x00000065^I1104
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007496^I0x0000000e^I1101
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007497^I0x00680034^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007498^I0x00670035^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007500^I0x007e0036^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007502^I0x007c0037^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007503^I0x00000038^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007505^I0x00840052^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007506^I0x00840053^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007508^I0x007e0054^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007509^I0x007d0055^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007511^I0x00000056^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007512^I0x00007050^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007514^I0x00017051^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007516^I0x00008204^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007518^I0x00018205^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007521^I0x00000001^I1101
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007522^I0x008b0063^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007524^I0x0000001d^I1104
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007526^I0x00000069^I1114
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007547^I0x0000020f^I0605
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007548^I0x0000026b^I0621
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007552^I0x0000010b^I1108
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007554^I0x0000000e^I1101
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007555^I0x00680034^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007556^I0x00670035^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007558^I0x007e0036^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007559^I0x007c0037^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007561^I0x00000038^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007562^I0x00840052^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007564^I0x00840053^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007565^I0x007e0054^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007567^I0x007d0055^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007568^I0x00000056^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007570^I0x00007050^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007572^I0x00017051^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007574^I0x00008204^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007576^I0x00018205^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007579^I0x00000001^I1101
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007580^I0x008b0063^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007582^I0x0000001c^I1104
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007583^I0x00000002^I1101
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007584^I0x0083903f^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007586^I0x0001d213^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007589^I0x00000002^I1101
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007590^I0x0003d206^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007592^I0x0083903e^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007596^I0x00000059^I1101
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007696^I0x00000013^I1101
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000007714^I0x00000005^I1107
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008282^I0x00016fa7^I1110
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008293^I0xffffff47^I0454
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008294^I0x00000000^I0472
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008304^I0x0000000b^I0463
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008307^I0xffffff47^I1111
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008312^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008312^I0x0000000e^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008317^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008321^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008325^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008329^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008334^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008338^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008342^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008347^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008351^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008355^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008359^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008364^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008368^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008372^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008376^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008381^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008385^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008389^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008394^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008398^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008402^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008406^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008411^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008415^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008419^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008423^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008428^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008432^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008436^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008441^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008445^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008449^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008453^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008458^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008462^I0x00000001^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008463^I0x0000000f^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008464^I0x00000392^I1105
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008468^I0x00000403^I1115
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008471^I0x0000000b^I0463
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008472^I0x0000000b^I0462
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008483^I0x0000010c^I0601
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008494^I0x04080048^I0401
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008505^I0x0000010f^I0603
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008576^I0x00000180^I0604
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008578^I0x0000019c^I0610
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008579^I0x00016e7e^I0610
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008580^I0x00000000^I0610
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008628^I0x00000500^I0600
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008622^I0x00016e52^I0638
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008634^I0x0000001c^I1101
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008666^I0x0000001a^I1101
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008694^I0x000000ff^I1103
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008695^I0xffff9111^I1103
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008696^I0x00000010^I1101
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008715^I0x00000011^I1101
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008728^I0x00000000^I1101
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008729^I0x00000000^I1101
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008731^I0x000001d8^I1101
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008733^I0x00000064^I1104
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008735^I0x0000000e^I1101
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008736^I0x00680034^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008737^I0x00670035^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008739^I0x007e0036^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008740^I0x007c0037^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008742^I0x00000038^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008743^I0x00840052^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008745^I0x00840053^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008746^I0x007e0054^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008748^I0x007d0055^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008749^I0x00000056^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008751^I0x00007050^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008753^I0x00017051^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008755^I0x00008204^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008757^I0x00018205^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008760^I0x00000001^I1101
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008761^I0x008b0063^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008763^I0x0000001c^I1104
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008765^I0x00000069^I1114
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008803^I0x02000000^I0600
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008809^I0x00000000^I0651
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008810^I0x00000259^I0605
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008812^I0x0000026b^I0621
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008815^I0x0000010b^I1108
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008817^I0x0000000e^I1101
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008818^I0x00680034^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008820^I0x00670035^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008821^I0x007e0036^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008823^I0x007c0037^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008824^I0x00000038^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008826^I0x00840052^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008827^I0x00840053^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008829^I0x007e0054^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008830^I0x007d0055^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008832^I0x00000056^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008833^I0x00007050^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008835^I0x00017051^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008837^I0x00008204^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008839^I0x00018205^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008842^I0x00000001^I1101
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008843^I0x008b0063^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008845^I0x0000001d^I1104
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008847^I0x00000002^I1101
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008848^I0x0083903f^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008850^I0x0001d213^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008853^I0x00000002^I1101
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008854^I0x0003d206^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008856^I0x0083903e^I1102
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008860^I0x00000059^I1101
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008960^I0x00000013^I1101
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000008977^I0x00000005^I1107
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000009545^I0x00016ab8^I1110
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000009556^I0xffffff46^I0454
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000009557^I0x00000000^I0472
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000009567^I0x0000000b^I0463
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000009570^I0xffffff46^I1111
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000009575^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000009575^I0x0000000e^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000009580^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000009584^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000009588^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000009592^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000009597^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000009601^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000009605^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000009610^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000009614^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000009618^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000009622^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000009627^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000009631^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000009635^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000009639^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000009644^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000009648^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000009652^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000009657^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000009661^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000009665^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000009669^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000009674^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000009678^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000009682^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000009686^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000009691^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000009695^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000009699^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000009704^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000009708^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000009712^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000009716^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000009721^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000009725^I0x00000001^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000009726^I0x0000000f^I1106
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000009727^I0x00000392^I1105
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000009731^I0x00000403^I1115
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000009734^I0x0000000b^I0463
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000009735^I0x0000000b^I0462
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000009746^I0x0000010c^I0601
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000009788^I0x00010087^I0250
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0000009793^I0x0000001c^I0218
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0097076437^I0x00000002^I0123
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: 0097076439^I0x00000100^I0125
Jan  9 17:49:31 rainbow kernel: [  128.515446] ieee80211 phy0: I iwl3945_print_rx_config_cmd RX CONFIG:
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl data: 00000000: 00 1f 3c 20 a1 6e 00 00 00 00 00 00 00 00 00 00  ..< .n..........
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl data: 00000010: 00 00 00 00 00 00 00 00 03 00 00 00 15 03 00 00  ................
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl data: 00000020: 05 80 00 00 04 00 00 00 0b 00 00 00              ............
Jan  9 17:49:31 rainbow kernel: [  128.515446] ieee80211 phy0: I iwl3945_print_rx_config_cmd u16 channel: 0xb
Jan  9 17:49:31 rainbow kernel: [  128.515446] ieee80211 phy0: I iwl3945_print_rx_config_cmd u32 flags: 0x00008005
Jan  9 17:49:31 rainbow kernel: [  128.515446] ieee80211 phy0: I iwl3945_print_rx_config_cmd u32 filter_flags: 0x00000004
Jan  9 17:49:31 rainbow kernel: [  128.515446] ieee80211 phy0: I iwl3945_print_rx_config_cmd u8 dev_type: 0x3
Jan  9 17:49:31 rainbow kernel: [  128.515446] ieee80211 phy0: I iwl3945_print_rx_config_cmd u8 ofdm_basic_rates: 0x15
Jan  9 17:49:31 rainbow kernel: [  128.515446] ieee80211 phy0: I iwl3945_print_rx_config_cmd u8 cck_basic_rates: 0x03
Jan  9 17:49:31 rainbow kernel: [  128.515446] ieee80211 phy0: I iwl3945_print_rx_config_cmd u8[6] node_addr: 00:1f:3c:20:a1:6e
Jan  9 17:49:31 rainbow kernel: [  128.515446] ieee80211 phy0: I iwl3945_print_rx_config_cmd u8[6] bssid_addr: 00:00:00:00:00:00
Jan  9 17:49:31 rainbow kernel: [  128.515446] ieee80211 phy0: I iwl3945_print_rx_config_cmd u16 assoc_id: 0x0
Jan  9 17:49:31 rainbow kernel: [  128.515446] ieee80211 phy0: I iwl3945_irq_handle_error Restarting adapter due to uCode error.
Jan  9 17:49:31 rainbow kernel: [  128.515446] ieee80211 phy0: I iwl3945_rx_handle r = 13, i = 12, REPLY_ERROR, 0x02
Jan  9 17:49:31 rainbow kernel: [  128.515446] iwl3945 0000:03:00.0: Error Reply type 0x00000005 cmd REPLY_PHY_CALIBRATION_CMD (0xB0) seq 0x013A ser 0x004E0000
Jan  9 17:49:31 rainbow kernel: [  128.538471] ieee80211 phy0: U __iwl3945_down iwl3945 is going down
Jan  9 17:49:31 rainbow kernel: [  128.541014] iwl3945 0000:03:00.0: Can't stop Rx DMA.
Jan  9 17:49:31 rainbow kernel: [  128.542286] ieee80211 phy0: U iwl3945_apm_stop_master stop master
Jan  9 17:49:31 rainbow kernel: [  128.542502] ieee80211 phy0: U iwl3945_clear_free_frames 0 frames on pre-allocated heap on clear.
Jan  9 17:49:31 rainbow kernel: [  128.542515] ieee80211 phy0: U iwl3945_power_init_handle Initialize power 
Jan  9 17:49:31 rainbow kernel: [  128.542524] ieee80211 phy0: U iwl3945_power_init_handle adjust power command flags
Jan  9 17:49:31 rainbow kernel: [  128.542619] ieee80211 phy0: U iwl3945_hw_nic_init HW Revision ID = 0x2
Jan  9 17:49:31 rainbow kernel: [  128.542665] ieee80211 phy0: U iwl3945_nic_config 3945 RADIO-MM type
Jan  9 17:49:31 rainbow kernel: [  128.542674] ieee80211 phy0: U iwl3945_nic_config SKU OP mode is basic
Jan  9 17:49:31 rainbow kernel: [  128.542676] ieee80211 phy0: U iwl3945_nic_config 3945ABG revision is 0xF1
Jan  9 17:49:31 rainbow kernel: [  128.542685] ieee80211 phy0: U iwl3945_nic_config Card M type B version is 0x3
Jan  9 17:49:31 rainbow kernel: [  128.544314] ieee80211 phy0: U iwl3945_load_bsm Begin load bsm
Jan  9 17:49:31 rainbow kernel: [  128.545580] ieee80211 phy0: U iwl3945_verify_bsm Begin verify bsm
Jan  9 17:49:31 rainbow kernel: [  128.547712] ieee80211 phy0: U iwl3945_verify_bsm BSM bootstrap uCode image OK
Jan  9 17:49:31 rainbow kernel: [  128.547766] ieee80211 phy0: U iwl3945_load_bsm BSM write complete, poll 1 iterations
Jan  9 17:49:31 rainbow kernel: [  128.547780] ieee80211 phy0: U __iwl3945_up iwl3945 is coming up
Jan  9 17:49:31 rainbow kernel: [  128.559197] ieee80211 phy0: I iwl3945_rx_handle r = 1, i = 0, REPLY_ALIVE, 0x01
Jan  9 17:49:31 rainbow kernel: [  128.559206] ieee80211 phy0: I iwl3945_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x9
Jan  9 17:49:31 rainbow kernel: [  128.559209] ieee80211 phy0: I iwl3945_rx_reply_alive Initialization Alive received.
Jan  9 17:49:31 rainbow kernel: [  128.571978] ieee80211 phy0: U iwl3945_verify_inst_sparse ucode inst image size is 900
Jan  9 17:49:31 rainbow kernel: [  128.572081] ieee80211 phy0: U iwl3945_verify_inst_sparse ucode inst image size is 2672
Jan  9 17:49:31 rainbow kernel: [  128.572356] ieee80211 phy0: U iwl3945_verify_ucode Initialize uCode is good in inst SRAM
Jan  9 17:49:31 rainbow kernel: [  128.572359] ieee80211 phy0: U iwl3945_init_alive_start Initialization Alive received.
Jan  9 17:49:31 rainbow kernel: [  128.572404] ieee80211 phy0: U iwl3945_set_ucode_ptrs Runtime uCode pointers are set.
Jan  9 17:49:31 rainbow kernel: [  128.576786] ieee80211 phy0: I iwl3945_rx_handle r = 2, i = 1, REPLY_ALIVE, 0x01
Jan  9 17:49:31 rainbow kernel: [  128.576791] ieee80211 phy0: I iwl3945_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x0
Jan  9 17:49:31 rainbow kernel: [  128.576794] ieee80211 phy0: I iwl3945_rx_reply_alive Runtime Alive received.
Jan  9 17:49:31 rainbow kernel: [  128.576835] ieee80211 phy0: I iwl3945_disable_events Selected uCode log events may be disabled
Jan  9 17:49:31 rainbow kernel: [  128.576838] ieee80211 phy0: I iwl3945_disable_events   by writing "1"s into disable bitmap
Jan  9 17:49:31 rainbow kernel: [  128.576841] ieee80211 phy0: I iwl3945_disable_events   in SRAM at 0x8022c8, size 47 u32s
Jan  9 17:49:31 rainbow kernel: [  128.585164] ieee80211 phy0: U iwl3945_alive_start Runtime Alive received.
Jan  9 17:49:31 rainbow kernel: [  128.585168] ieee80211 phy0: U iwl3945_verify_inst_sparse ucode inst image size is 900
Jan  9 17:49:31 rainbow kernel: [  128.585251] ieee80211 phy0: U iwl3945_verify_inst_sparse ucode inst image size is 2672
Jan  9 17:49:31 rainbow kernel: [  128.585327] ieee80211 phy0: U iwl3945_verify_inst_sparse ucode inst image size is 80684
Jan  9 17:49:31 rainbow kernel: [  128.592760] ieee80211 phy0: U iwl3945_verify_ucode Runtime uCode is good in inst SRAM
Jan  9 17:49:31 rainbow kernel: [  128.592789] ieee80211 phy0: U iwl3945_alive_start RFKILL status: 0x1
Jan  9 17:49:31 rainbow kernel: [  128.592809] ieee80211 phy0: U iwl3945_update_power_cmd Flags value = 0x00000009
Jan  9 17:49:31 rainbow kernel: [  128.592812] ieee80211 phy0: U iwl3945_update_power_cmd Tx timeout = 102400
Jan  9 17:49:31 rainbow kernel: [  128.592815] ieee80211 phy0: U iwl3945_update_power_cmd Rx timeout = 51200
Jan  9 17:49:31 rainbow kernel: [  128.592818] ieee80211 phy0: U iwl3945_update_power_cmd Sleep interval vector = { 1 , 1 , 1 , 1 , 1 }
Jan  9 17:49:31 rainbow kernel: [  128.592824] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command POWER_TABLE_CMD (#77), seq: 0x0400, 36 bytes at 0[0]:4
Jan  9 17:49:31 rainbow kernel: [  128.592899] ieee80211 phy0: I iwl3945_rx_handle r 3 i 2 No handler needed for POWER_TABLE_CMD, 0x77
Jan  9 17:49:31 rainbow kernel: [  128.592935] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_BT_CONFIG (#9b), seq: 0x0401, 16 bytes at 1[1]:4
Jan  9 17:49:31 rainbow kernel: [  128.592945] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Jan  9 17:49:31 rainbow kernel: [  128.594765] ieee80211 phy0: I iwl3945_rx_handle r 4 i 3 No handler needed for REPLY_BT_CONFIG, 0x9b
Jan  9 17:49:31 rainbow kernel: [  128.594777] ieee80211 phy0: U iwl3945_commit_rxon Sending RXON
Jan  9 17:49:31 rainbow kernel: [  128.594778] * without RXON_FILTER_ASSOC_MSK
Jan  9 17:49:31 rainbow kernel: [  128.594779] * channel = 11
Jan  9 17:49:31 rainbow kernel: [  128.594779] * bssid = 00:00:00:00:00:00
Jan  9 17:49:31 rainbow kernel: [  128.594786] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x0402, 48 bytes at 2[2]:4
Jan  9 17:49:31 rainbow kernel: [  128.594796] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Jan  9 17:49:31 rainbow kernel: [  128.597630] ieee80211 phy0: I iwl3945_rx_handle r 5 i 4 No handler needed for REPLY_RXON, 0x10
Jan  9 17:49:31 rainbow kernel: [  128.597670] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0d
Jan  9 17:49:31 rainbow kernel: [  128.597674] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0f
Jan  9 17:49:31 rainbow kernel: [  128.597678] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x05
Jan  9 17:49:31 rainbow kernel: [  128.597681] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x07
Jan  9 17:49:31 rainbow kernel: [  128.597684] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x09
Jan  9 17:49:31 rainbow kernel: [  128.597687] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x0b
Jan  9 17:49:31 rainbow kernel: [  128.597690] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x01
Jan  9 17:49:31 rainbow kernel: [  128.597694] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 203 dsp 121 rate code 0x03
Jan  9 17:49:31 rainbow kernel: [  128.597697] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x0a
Jan  9 17:49:31 rainbow kernel: [  128.597700] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x14
Jan  9 17:49:31 rainbow kernel: [  128.597703] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x37
Jan  9 17:49:31 rainbow kernel: [  128.597706] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 227 dsp 125 rate code 0x6e
Jan  9 17:49:31 rainbow kernel: [  128.597710] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0403, 56 bytes at 3[3]:4
Jan  9 17:49:31 rainbow kernel: [  128.597719] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Jan  9 17:49:31 rainbow kernel: [  128.600447] ieee80211 phy0: I iwl3945_rx_handle r 6 i 5 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
Jan  9 17:49:31 rainbow kernel: [  128.600480] ieee80211 phy0: U iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
Jan  9 17:49:31 rainbow kernel: [  128.600485] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0404, 68 bytes at 4[4]:4
Jan  9 17:49:31 rainbow kernel: [  128.600494] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Jan  9 17:49:31 rainbow kernel: [  128.603750] ieee80211 phy0: I iwl3945_rx_handle r = 7, i = 6, REPLY_ADD_STA, 0x18
Jan  9 17:49:31 rainbow kernel: [  128.603759] ieee80211 phy0: U iwl3945_send_add_station REPLY_ADD_STA PASSED
Jan  9 17:49:31 rainbow kernel: [  128.603765] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0405, 56 bytes at 5[5]:4
Jan  9 17:49:31 rainbow kernel: [  128.603774] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Jan  9 17:49:31 rainbow kernel: [  128.606913] ieee80211 phy0: I iwl3945_rx_handle r 8 i 7 No handler needed for REPLY_RATE_SCALE, 0x47
Jan  9 17:49:31 rainbow kernel: [  128.606949] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0406, 56 bytes at 6[6]:4
Jan  9 17:49:31 rainbow kernel: [  128.610142] ieee80211 phy0: I iwl3945_rx_handle r 9 i 8 No handler needed for REPLY_RATE_SCALE, 0x47
Jan  9 17:49:31 rainbow kernel: [  128.610159] ieee80211 phy0: U iwl3945_hw_reg_txpower_get_temperature Temperature: 113
Jan  9 17:49:31 rainbow kernel: [  128.610164] ieee80211 phy0: U is_temp_calib_needed Getting warmer, delta 38,
Jan  9 17:49:31 rainbow kernel: [  128.610166] ieee80211 phy0: U is_temp_calib_needed Timed thermal calib needed
Jan  9 17:49:31 rainbow kernel: [  128.610176] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 235 dsp 121 rate code 0x0d
Jan  9 17:49:31 rainbow kernel: [  128.610179] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 235 dsp 121 rate code 0x0f
Jan  9 17:49:31 rainbow kernel: [  128.610182] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 235 dsp 121 rate code 0x05
Jan  9 17:49:31 rainbow kernel: [  128.610185] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 235 dsp 121 rate code 0x07
Jan  9 17:49:31 rainbow kernel: [  128.610188] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 235 dsp 121 rate code 0x09
Jan  9 17:49:31 rainbow kernel: [  128.610191] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 235 dsp 121 rate code 0x0b
Jan  9 17:49:31 rainbow kernel: [  128.610194] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 235 dsp 121 rate code 0x01
Jan  9 17:49:31 rainbow kernel: [  128.610196] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 235 dsp 121 rate code 0x03
Jan  9 17:49:31 rainbow kernel: [  128.610199] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 171 dsp 110 rate code 0x0a
Jan  9 17:49:31 rainbow kernel: [  128.610202] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 171 dsp 110 rate code 0x14
Jan  9 17:49:31 rainbow kernel: [  128.610205] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 171 dsp 110 rate code 0x37
Jan  9 17:49:31 rainbow kernel: [  128.610208] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 171 dsp 110 rate code 0x6e
Jan  9 17:49:31 rainbow kernel: [  128.610212] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0407, 56 bytes at 7[7]:4
Jan  9 17:49:31 rainbow kernel: [  128.610221] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Jan  9 17:49:31 rainbow kernel: [  128.612993] ieee80211 phy0: I iwl3945_rx_handle r 10 i 9 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
Jan  9 17:49:31 rainbow kernel: [  128.613056] Registered led device: iwl-phy0:radio
Jan  9 17:49:31 rainbow kernel: [  128.613060] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0408, 12 bytes at 8[8]:4
Jan  9 17:49:31 rainbow kernel: [  128.613105] Registered led device: iwl-phy0:assoc
Jan  9 17:49:31 rainbow kernel: [  128.613148] ieee80211 phy0: I iwl3945_rx_handle r 11 i 10 No handler needed for REPLY_LEDS_CMD, 0x48
Jan  9 17:49:31 rainbow kernel: [  128.613164] Registered led device: iwl-phy0:RX
Jan  9 17:49:31 rainbow kernel: [  128.613177] Registered led device: iwl-phy0:TX
Jan  9 17:49:31 rainbow kernel: [  128.613178] ieee80211 phy0: U iwl3945_alive_start ALIVE processing complete.
Jan  9 17:49:31 rainbow kernel: [  128.709029] wlan0: direct probe to AP 00:30:bd:c0:90:24 try 2
Jan  9 17:49:31 rainbow kernel: [  128.709047] ieee80211 phy0: I iwl3945_mac_tx enter
Jan  9 17:49:31 rainbow kernel: [  128.709107] ieee80211 phy0: I iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Jan  9 17:49:31 rainbow kernel: [  128.709117] ieee80211 phy0: I iwl3945_mac_tx leave
Jan  9 17:49:31 rainbow kernel: [  128.719640] ieee80211 phy0: I iwl3945_rx_handle r = 12, i = 11, REPLY_TX, 0x1c
Jan  9 17:49:31 rainbow kernel: [  128.909050] wlan0: direct probe to AP 00:30:bd:c0:90:24 try 3
Jan  9 17:49:31 rainbow kernel: [  128.909084] ieee80211 phy0: I iwl3945_mac_tx enter
Jan  9 17:49:31 rainbow kernel: [  128.909141] ieee80211 phy0: I iwl3945_mac_tx leave
Jan  9 17:49:31 rainbow kernel: [  128.909240] ieee80211 phy0: I iwl3945_rx_handle r 14 i 12 No handler needed for UNKNOWN, 0x40
Jan  9 17:49:31 rainbow kernel: [  128.909281] ------------[ cut here ]------------
Jan  9 17:49:31 rainbow kernel: [  128.909287] WARNING: at drivers/net/wireless/iwlwifi/iwl3945-base.c:3131 iwl3945_irq_tasklet+0x1121/0x14d0 [iwl3945]()
Jan  9 17:49:31 rainbow kernel: [  128.909293] wrong command queue 0, sequence 0x0 readp=9 writep=9
Jan  9 17:49:31 rainbow kernel: [  128.909297] Modules linked in: af_packet i915 drm binfmt_misc acpi_cpufreq cpufreq_ondemand cpufreq_stats cpufreq_powersave cpufreq_userspace cpufreq_conservative freq_table pci_slot sbs sbshc container iptable_filter ip_tables x_tables sbp2 snd_hda_intel arc4 ecb snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss iwl3945 iwlcore snd_seq_midi joydev thinkpad_acpi snd_rawmidi mac80211 snd_seq_midi_event rfkill snd_seq pcmcia led_class lib80211 evdev cfg80211 snd_timer snd_seq_device serio_raw pcspkr yenta_socket rsrc_nonstatic pcmcia_core psmouse nvram intel_agp iTCO_wdt iTCO_vendor_support video output shpchp wmi battery ac button pci_hotplug snd soundcore snd_page_alloc ext3 jbd mbcache sr_mod cdrom sd_mod crc_t10dif sg ata_piix ata_generic pata_acpi ahci ohci1394 libata ieee1394 scsi_mod ehci_hcd uhci_hcd usbcore thermal processor fan fuse
Jan  9 17:49:31 rainbow kernel: [  128.909441] Pid: 0, comm: swapper Not tainted 2.6.28-wl #7
Jan  9 17:49:31 rainbow kernel: [  128.909445] Call Trace:
Jan  9 17:49:31 rainbow kernel: [  128.909449]  <IRQ>  [<ffffffff8024c557>] warn_slowpath+0xb7/0xf0
Jan  9 17:49:31 rainbow kernel: [  128.909477]  [<ffffffff8050a010>] ? printk+0x67/0x6f
Jan  9 17:49:31 rainbow kernel: [  128.909491]  [<ffffffff8022e599>] ? default_spin_lock_flags+0x9/0x10
Jan  9 17:49:31 rainbow kernel: [  128.909513]  [<ffffffffa0380171>] iwl3945_irq_tasklet+0x1121/0x14d0 [iwl3945]
Jan  9 17:49:31 rainbow kernel: [  128.909525]  [<ffffffff8026744b>] ? hrtimer_get_next_event+0xcb/0xe0
Jan  9 17:49:31 rainbow kernel: [  128.909532]  [<ffffffff8026b1e9>] ? getnstimeofday+0x49/0xc0
Jan  9 17:49:31 rainbow kernel: [  128.909539]  [<ffffffff80267699>] ? ktime_get_ts+0x59/0x60
Jan  9 17:49:31 rainbow kernel: [  128.909547]  [<ffffffff80251e56>] tasklet_action+0x86/0x110
Jan  9 17:49:31 rainbow kernel: [  128.909555]  [<ffffffff8025256c>] __do_softirq+0x9c/0x170
Jan  9 17:49:31 rainbow kernel: [  128.909562]  [<ffffffff80214d8c>] call_softirq+0x1c/0x30
Jan  9 17:49:31 rainbow kernel: [  128.909569]  [<ffffffff802160bd>] do_softirq+0x5d/0xa0
Jan  9 17:49:31 rainbow kernel: [  128.909575]  [<ffffffff802522ed>] irq_exit+0x8d/0xa0
Jan  9 17:49:31 rainbow kernel: [  128.909581]  [<ffffffff80216389>] do_IRQ+0xc9/0x110
Jan  9 17:49:31 rainbow kernel: [  128.909588]  [<ffffffff80213b23>] ret_from_intr+0x0/0x29
Jan  9 17:49:31 rainbow kernel: [  128.909592]  <EOI>  [<ffffffffa001f678>] ? acpi_idle_enter_bm+0x28a/0x2da [processor]
Jan  9 17:49:31 rainbow kernel: [  128.909625]  [<ffffffffa001f670>] ? acpi_idle_enter_bm+0x282/0x2da [processor]
Jan  9 17:49:31 rainbow kernel: [  128.909633]  [<ffffffff805104af>] ? notifier_call_chain+0x3f/0x80
Jan  9 17:49:31 rainbow kernel: [  128.909642]  [<ffffffff80458d85>] ? cpuidle_idle_call+0xa5/0x100
Jan  9 17:49:31 rainbow kernel: [  128.909651]  [<ffffffff80211e75>] ? cpu_idle+0x65/0xc0
Jan  9 17:49:31 rainbow kernel: [  128.909659]  [<ffffffff804f8381>] ? rest_init+0x61/0x70
Jan  9 17:49:31 rainbow kernel: [  128.909664] ---[ end trace 4cb4f19346bc4e12 ]---
Jan  9 17:49:31 rainbow kernel: [  128.909671] iwl data: 00000000: 00 50 34 20 00 00 00 00 00 00 00 00 00 00 00 00  .P4 ............
Jan  9 17:49:31 rainbow kernel: [  128.909677] iwl data: 00000010: 00 32 d1 38 01 88 ff ff 00 01 10 00 00 00 00 00  .2.8............
Jan  9 17:49:31 rainbow kernel: [  128.909699] ieee80211 phy0: I iwl3945_rx_handle r 14 i 13 No handler needed for UNKNOWN, 0x00
Jan  9 17:49:31 rainbow kernel: [  128.909723] ------------[ cut here ]------------
Jan  9 17:49:31 rainbow kernel: [  128.909728] WARNING: at drivers/net/wireless/iwlwifi/iwl3945-base.c:3131 iwl3945_irq_tasklet+0x1121/0x14d0 [iwl3945]()
Jan  9 17:49:31 rainbow kernel: [  128.909734] wrong command queue 0, sequence 0x0 readp=9 writep=9
Jan  9 17:49:31 rainbow kernel: [  128.909737] Modules linked in: af_packet i915 drm binfmt_misc acpi_cpufreq cpufreq_ondemand cpufreq_stats cpufreq_powersave cpufreq_userspace cpufreq_conservative freq_table pci_slot sbs sbshc container iptable_filter ip_tables x_tables sbp2 snd_hda_intel arc4 ecb snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss iwl3945 iwlcore snd_seq_midi joydev thinkpad_acpi snd_rawmidi mac80211 snd_seq_midi_event rfkill snd_seq pcmcia led_class lib80211 evdev cfg80211 snd_timer snd_seq_device serio_raw pcspkr yenta_socket rsrc_nonstatic pcmcia_core psmouse nvram intel_agp iTCO_wdt iTCO_vendor_support video output shpchp wmi battery ac button pci_hotplug snd soundcore snd_page_alloc ext3 jbd mbcache sr_mod cdrom sd_mod crc_t10dif sg ata_piix ata_generic pata_acpi ahci ohci1394 libata ieee1394 scsi_mod ehci_hcd uhci_hcd usbcore thermal processor fan fuse
Jan  9 17:49:31 rainbow kernel: [  128.909863] Pid: 0, comm: swapper Tainted: G        W  2.6.28-wl #7
Jan  9 17:49:31 rainbow kernel: [  128.909866] Call Trace:
Jan  9 17:49:31 rainbow kernel: [  128.909869]  <IRQ>  [<ffffffff8024c557>] warn_slowpath+0xb7/0xf0
Jan  9 17:49:31 rainbow kernel: [  128.909891]  [<ffffffff8050a010>] ? printk+0x67/0x6f
Jan  9 17:49:31 rainbow kernel: [  128.909901]  [<ffffffff8022e599>] ? default_spin_lock_flags+0x9/0x10
Jan  9 17:49:31 rainbow kernel: [  128.909910]  [<ffffffff803af87e>] ? unmap_single+0x13e/0x160
Jan  9 17:49:31 rainbow kernel: [  128.909917]  [<ffffffff8022e599>] ? default_spin_lock_flags+0x9/0x10
Jan  9 17:49:31 rainbow kernel: [  128.909938]  [<ffffffffa0380171>] iwl3945_irq_tasklet+0x1121/0x14d0 [iwl3945]
Jan  9 17:49:31 rainbow kernel: [  128.909949]  [<ffffffff8026744b>] ? hrtimer_get_next_event+0xcb/0xe0
Jan  9 17:49:31 rainbow kernel: [  128.909955]  [<ffffffff8026b1e9>] ? getnstimeofday+0x49/0xc0
Jan  9 17:49:31 rainbow kernel: [  128.909962]  [<ffffffff80267699>] ? ktime_get_ts+0x59/0x60
Jan  9 17:49:31 rainbow kernel: [  128.909970]  [<ffffffff80251e56>] tasklet_action+0x86/0x110
Jan  9 17:49:31 rainbow kernel: [  128.909977]  [<ffffffff8025256c>] __do_softirq+0x9c/0x170
Jan  9 17:49:31 rainbow kernel: [  128.909983]  [<ffffffff80214d8c>] call_softirq+0x1c/0x30
Jan  9 17:49:31 rainbow kernel: [  128.909990]  [<ffffffff802160bd>] do_softirq+0x5d/0xa0
Jan  9 17:49:31 rainbow kernel: [  128.909996]  [<ffffffff802522ed>] irq_exit+0x8d/0xa0
Jan  9 17:49:31 rainbow kernel: [  128.910002]  [<ffffffff80216389>] do_IRQ+0xc9/0x110
Jan  9 17:49:31 rainbow kernel: [  128.910008]  [<ffffffff80213b23>] ret_from_intr+0x0/0x29
Jan  9 17:49:31 rainbow kernel: [  128.910012]  <EOI>  [<ffffffffa001f678>] ? acpi_idle_enter_bm+0x28a/0x2da [processor]
Jan  9 17:49:31 rainbow kernel: [  128.910043]  [<ffffffffa001f670>] ? acpi_idle_enter_bm+0x282/0x2da [processor]
Jan  9 17:49:31 rainbow kernel: [  128.910050]  [<ffffffff805104af>] ? notifier_call_chain+0x3f/0x80
Jan  9 17:49:31 rainbow kernel: [  128.910057]  [<ffffffff80458d85>] ? cpuidle_idle_call+0xa5/0x100
Jan  9 17:49:31 rainbow kernel: [  128.910065]  [<ffffffff80211e75>] ? cpu_idle+0x65/0xc0
Jan  9 17:49:31 rainbow kernel: [  128.910072]  [<ffffffff804f8381>] ? rest_init+0x61/0x70
Jan  9 17:49:31 rainbow kernel: [  128.910077] ---[ end trace 4cb4f19346bc4e12 ]---
Jan  9 17:49:31 rainbow kernel: [  128.910082] iwl data: 00000000: 00 60 34 20 00 00 00 00 00 00 00 00 00 00 00 00  .`4 ............
Jan  9 17:49:31 rainbow kernel: [  128.910088] iwl data: 00000010: 00 39 d1 38 01 88 ff ff 00 01 10 00 00 00 00 00  .9.8............
Jan  9 17:49:31 rainbow kernel: [  128.910186] iwl3945 0000:03:00.0: Microcode SW error detected. Restarting 0x82000008.
Jan  9 17:49:31 rainbow kernel: [  128.910221] iwl3945 0000:03:00.0: Start IWL Error Log Dump:
Jan  9 17:49:31 rainbow kernel: [  128.910229] iwl3945 0000:03:00.0: Status: 0x000302E4, count: 1
Jan  9 17:49:31 rainbow kernel: [  128.910236] iwl3945 0000:03:00.0: Desc       Time       asrtPC  blink2 ilink1  nmiPC   Line
Jan  9 17:49:31 rainbow kernel: [  128.910314] iwl3945 0000:03:00.0: SYSASSERT     (#5) 0000199967 0x0089A 0x00342 0x00304 0x00000 267
Jan  9 17:49:31 rainbow kernel: [  128.910317] 
Jan  9 17:49:31 rainbow kernel: [  128.910389] iwl3945 0000:03:00.0: Start IWL Event Log Dump: display count 512, wraps 1
Jan  9 17:49:31 rainbow kernel: [  128.910426] iwl3945 0000:03:00.0: 0000004713^I0x00840052^I1102
Jan  9 17:49:31 rainbow kernel: [  128.910461] iwl3945 0000:03:00.0: 0000004714^I0x00840053^I1102
Jan  9 17:49:31 rainbow kernel: [  128.910496] iwl3945 0000:03:00.0: 0000004716^I0x007e0054^I1102
Jan  9 17:49:31 rainbow kernel: [  128.910531] iwl3945 0000:03:00.0: 0000004717^I0x007d0055^I1102
Jan  9 17:49:31 rainbow kernel: [  128.910567] iwl3945 0000:03:00.0: 0000004719^I0x00000056^I1102
Jan  9 17:49:31 rainbow kernel: [  128.910602] iwl3945 0000:03:00.0: 0000004720^I0x00007050^I1102
Jan  9 17:49:31 rainbow kernel: [  128.910639] iwl3945 0000:03:00.0: 0000004722^I0x00017051^I1102
Jan  9 17:49:31 rainbow kernel: [  128.910675] iwl3945 0000:03:00.0: 0000004724^I0x00008204^I1102
Jan  9 17:49:31 rainbow kernel: [  128.910710] iwl3945 0000:03:00.0: 0000004726^I0x00018205^I1102
Jan  9 17:49:31 rainbow kernel: [  128.910746] iwl3945 0000:03:00.0: 0000004729^I0x00000001^I1101
Jan  9 17:49:31 rainbow kernel: [  128.910781] iwl3945 0000:03:00.0: 0000004730^I0x008b0063^I1102
Jan  9 17:49:31 rainbow kernel: [  128.910820] iwl3945 0000:03:00.0: 0000004732^I0x0000001d^I1104
Jan  9 17:49:31 rainbow kernel: [  128.910855] iwl3945 0000:03:00.0: 0000004734^I0x00000069^I1114
Jan  9 17:49:31 rainbow kernel: [  128.910891] iwl3945 0000:03:00.0: 0000004755^I0x0000020f^I0605
Jan  9 17:49:31 rainbow kernel: [  128.910926] iwl3945 0000:03:00.0: 0000004756^I0x0000026b^I0621
Jan  9 17:49:31 rainbow kernel: [  128.910961] iwl3945 0000:03:00.0: 0000004760^I0x0000010b^I1108
Jan  9 17:49:31 rainbow kernel: [  128.910997] iwl3945 0000:03:00.0: 0000004762^I0x0000000e^I1101
Jan  9 17:49:31 rainbow kernel: [  128.911032] iwl3945 0000:03:00.0: 0000004763^I0x00680034^I1102
Jan  9 17:49:31 rainbow kernel: [  128.911068] iwl3945 0000:03:00.0: 0000004764^I0x00670035^I1102
Jan  9 17:49:31 rainbow kernel: [  128.911103] iwl3945 0000:03:00.0: 0000004766^I0x007e0036^I1102
Jan  9 17:49:31 rainbow kernel: [  128.911138] iwl3945 0000:03:00.0: 0000004767^I0x007c0037^I1102
Jan  9 17:49:31 rainbow kernel: [  128.911173] iwl3945 0000:03:00.0: 0000004769^I0x00000038^I1102
Jan  9 17:49:31 rainbow kernel: [  128.911209] iwl3945 0000:03:00.0: 0000004770^I0x00840052^I1102
Jan  9 17:49:31 rainbow kernel: [  128.911244] iwl3945 0000:03:00.0: 0000004772^I0x00840053^I1102
Jan  9 17:49:31 rainbow kernel: [  128.911279] iwl3945 0000:03:00.0: 0000004773^I0x007e0054^I1102
Jan  9 17:49:31 rainbow kernel: [  128.911315] iwl3945 0000:03:00.0: 0000004775^I0x007d0055^I1102
Jan  9 17:49:31 rainbow kernel: [  128.911350] iwl3945 0000:03:00.0: 0000004776^I0x00000056^I1102
Jan  9 17:49:31 rainbow kernel: [  128.911385] iwl3945 0000:03:00.0: 0000004778^I0x00007050^I1102
Jan  9 17:49:31 rainbow kernel: [  128.911420] iwl3945 0000:03:00.0: 0000004780^I0x00017051^I1102
Jan  9 17:49:31 rainbow kernel: [  128.911456] iwl3945 0000:03:00.0: 0000004782^I0x00008204^I1102
Jan  9 17:49:31 rainbow kernel: [  128.911490] iwl3945 0000:03:00.0: 0000004784^I0x00018205^I1102
Jan  9 17:49:31 rainbow kernel: [  128.911526] iwl3945 0000:03:00.0: 0000004787^I0x00000001^I1101
Jan  9 17:49:31 rainbow kernel: [  128.911561] iwl3945 0000:03:00.0: 0000004788^I0x008b0063^I1102
Jan  9 17:49:31 rainbow kernel: [  128.911596] iwl3945 0000:03:00.0: 0000004790^I0x0000001c^I1104
Jan  9 17:49:31 rainbow kernel: [  128.911631] iwl3945 0000:03:00.0: 0000004792^I0x00000002^I1101
Jan  9 17:49:31 rainbow kernel: [  128.911666] iwl3945 0000:03:00.0: 0000004792^I0x0083903f^I1102
Jan  9 17:49:31 rainbow kernel: [  128.911708] iwl3945 0000:03:00.0: 0000004794^I0x0001d213^I1102
Jan  9 17:49:31 rainbow kernel: [  128.911746] iwl3945 0000:03:00.0: 0000004798^I0x00000002^I1101
Jan  9 17:49:31 rainbow kernel: [  128.911782] iwl3945 0000:03:00.0: 0000004798^I0x0003d206^I1102
Jan  9 17:49:31 rainbow kernel: [  128.911817] iwl3945 0000:03:00.0: 0000004800^I0x0083903e^I1102
Jan  9 17:49:31 rainbow kernel: [  128.911852] iwl3945 0000:03:00.0: 0000004804^I0x00000059^I1101
Jan  9 17:49:31 rainbow kernel: [  128.911887] iwl3945 0000:03:00.0: 0000004904^I0x00000013^I1101
Jan  9 17:49:31 rainbow kernel: [  128.911922] iwl3945 0000:03:00.0: 0000004922^I0x00000005^I1107
Jan  9 17:49:31 rainbow kernel: [  128.911956] iwl3945 0000:03:00.0: 0000005490^I0x00017a8f^I1110
Jan  9 17:49:31 rainbow kernel: [  128.911991] iwl3945 0000:03:00.0: 0000005501^I0xffffff6d^I0454
Jan  9 17:49:31 rainbow kernel: [  128.912027] iwl3945 0000:03:00.0: 0000005502^I0x00000000^I0472
Jan  9 17:49:31 rainbow kernel: [  128.912062] iwl3945 0000:03:00.0: 0000005512^I0x0000000b^I0463
Jan  9 17:49:31 rainbow kernel: [  128.912097] iwl3945 0000:03:00.0: 0000005515^I0xffffff6d^I1111
Jan  9 17:49:31 rainbow kernel: [  128.912132] iwl3945 0000:03:00.0: 0000005520^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.912168] iwl3945 0000:03:00.0: 0000005520^I0x0000000e^I1106
Jan  9 17:49:31 rainbow kernel: [  128.912203] iwl3945 0000:03:00.0: 0000005525^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.912238] iwl3945 0000:03:00.0: 0000005529^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.912277] iwl3945 0000:03:00.0: 0000005533^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.912315] iwl3945 0000:03:00.0: 0000005537^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.912351] iwl3945 0000:03:00.0: 0000005542^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.912386] iwl3945 0000:03:00.0: 0000005546^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.912421] iwl3945 0000:03:00.0: 0000005550^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.912457] iwl3945 0000:03:00.0: 0000005555^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.912492] iwl3945 0000:03:00.0: 0000005559^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.912528] iwl3945 0000:03:00.0: 0000005563^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.912563] iwl3945 0000:03:00.0: 0000005567^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.912598] iwl3945 0000:03:00.0: 0000005572^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.912634] iwl3945 0000:03:00.0: 0000005576^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.912670] iwl3945 0000:03:00.0: 0000005580^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.912705] iwl3945 0000:03:00.0: 0000005584^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.912741] iwl3945 0000:03:00.0: 0000005589^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.912776] iwl3945 0000:03:00.0: 0000005593^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.912812] iwl3945 0000:03:00.0: 0000005597^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.912850] iwl3945 0000:03:00.0: 0000005602^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.912889] iwl3945 0000:03:00.0: 0000005606^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.912925] iwl3945 0000:03:00.0: 0000005610^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.912960] iwl3945 0000:03:00.0: 0000005614^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.912996] iwl3945 0000:03:00.0: 0000005619^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.913031] iwl3945 0000:03:00.0: 0000005623^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.913067] iwl3945 0000:03:00.0: 0000005627^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.913102] iwl3945 0000:03:00.0: 0000005631^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.913138] iwl3945 0000:03:00.0: 0000005636^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.913173] iwl3945 0000:03:00.0: 0000005640^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.913209] iwl3945 0000:03:00.0: 0000005644^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.913244] iwl3945 0000:03:00.0: 0000005649^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.913279] iwl3945 0000:03:00.0: 0000005653^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.913315] iwl3945 0000:03:00.0: 0000005657^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.913350] iwl3945 0000:03:00.0: 0000005661^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.913386] iwl3945 0000:03:00.0: 0000005666^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.913426] iwl3945 0000:03:00.0: 0000005670^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.913464] iwl3945 0000:03:00.0: 0000005674^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.913500] iwl3945 0000:03:00.0: 0000005678^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.913535] iwl3945 0000:03:00.0: 0000005683^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.913570] iwl3945 0000:03:00.0: 0000005687^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.913606] iwl3945 0000:03:00.0: 0000005691^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.913640] iwl3945 0000:03:00.0: 0000005696^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.913676] iwl3945 0000:03:00.0: 0000005700^I0x00000001^I1106
Jan  9 17:49:31 rainbow kernel: [  128.913712] iwl3945 0000:03:00.0: 0000005701^I0x0000000f^I1106
Jan  9 17:49:31 rainbow kernel: [  128.913747] iwl3945 0000:03:00.0: 0000005702^I0x000003b0^I1105
Jan  9 17:49:31 rainbow kernel: [  128.913783] iwl3945 0000:03:00.0: 0000005706^I0x0000040d^I1115
Jan  9 17:49:31 rainbow kernel: [  128.913818] iwl3945 0000:03:00.0: 0000005709^I0x0000000b^I0463
Jan  9 17:49:31 rainbow kernel: [  128.913854] iwl3945 0000:03:00.0: 0000005710^I0x0000000b^I0462
Jan  9 17:49:31 rainbow kernel: [  128.913889] iwl3945 0000:03:00.0: 0000005721^I0x0000010c^I0601
Jan  9 17:49:31 rainbow kernel: [  128.913925] iwl3945 0000:03:00.0: 0000005732^I0x04050047^I0401
Jan  9 17:49:31 rainbow kernel: [  128.913961] iwl3945 0000:03:00.0: 0000005742^I0x0000010f^I0603
Jan  9 17:49:31 rainbow kernel: [  128.913999] iwl3945 0000:03:00.0: 0000005814^I0x00000180^I0604
Jan  9 17:49:31 rainbow kernel: [  128.914037] iwl3945 0000:03:00.0: 0000005816^I0x0000019c^I0610
Jan  9 17:49:31 rainbow kernel: [  128.914074] iwl3945 0000:03:00.0: 0000005817^I0x00017948^I0610
Jan  9 17:49:31 rainbow kernel: [  128.914109] iwl3945 0000:03:00.0: 0000005818^I0x00000000^I0610
Jan  9 17:49:31 rainbow kernel: [  128.914144] iwl3945 0000:03:00.0: 0000005866^I0x00000500^I0600
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007368^I0x000001ed^I0616
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000005860^I0x0001791c^I0638
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006283^I0x0000001c^I1101
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006316^I0x0000001a^I1101
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006343^I0x000000ff^I1103
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006344^I0xffff9111^I1103
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006346^I0x00000010^I1101
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006364^I0x00000011^I1101
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006377^I0x00000000^I1101
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006378^I0x00000000^I1101
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006380^I0x000001d8^I1101
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006382^I0x00000065^I1104
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006384^I0x0000000e^I1101
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006385^I0x00680034^I1102
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006386^I0x00670035^I1102
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006388^I0x007e0036^I1102
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006390^I0x007c0037^I1102
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006391^I0x00000038^I1102
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006393^I0x00840052^I1102
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006394^I0x00840053^I1102
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006396^I0x007e0054^I1102
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006397^I0x007d0055^I1102
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006399^I0x00000056^I1102
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006400^I0x00007050^I1102
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006402^I0x00017051^I1102
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006404^I0x00008204^I1102
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006406^I0x00018205^I1102
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006409^I0x00000001^I1101
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006410^I0x008b0063^I1102
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006412^I0x0000001d^I1104
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006414^I0x00000069^I1114
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006435^I0x0000020f^I0605
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006436^I0x0000026b^I0621
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006440^I0x0000010b^I1108
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006442^I0x0000000e^I1101
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006443^I0x00680034^I1102
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006444^I0x00670035^I1102
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006446^I0x007e0036^I1102
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006447^I0x007c0037^I1102
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006449^I0x00000038^I1102
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006450^I0x00840052^I1102
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006452^I0x00840053^I1102
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006453^I0x007e0054^I1102
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006455^I0x007d0055^I1102
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006456^I0x00000056^I1102
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006458^I0x00007050^I1102
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006460^I0x00017051^I1102
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006462^I0x00008204^I1102
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006464^I0x00018205^I1102
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006467^I0x00000001^I1101
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006468^I0x008b0063^I1102
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006470^I0x0000001c^I1104
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006471^I0x00000002^I1101
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006472^I0x0083903f^I1102
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006474^I0x0001d213^I1102
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006477^I0x00000002^I1101
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006478^I0x0003d206^I1102
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006480^I0x0083903e^I1102
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006484^I0x00000059^I1101
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006584^I0x00000013^I1101
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000006602^I0x00000005^I1107
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007170^I0x000173ff^I1110
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007181^I0xffffff6d^I0454
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007182^I0x00000000^I0472
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007192^I0x0000000b^I0463
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007195^I0xffffff6d^I1111
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007200^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007200^I0x0000000e^I1106
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007205^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007209^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007213^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007217^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007222^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007226^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007230^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007235^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007239^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007243^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007247^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007252^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007256^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007260^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007264^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007269^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007273^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007277^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007282^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007286^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007290^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007294^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007299^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007303^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007307^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007311^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007316^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007320^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007324^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007329^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007333^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007337^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007341^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007346^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007350^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007354^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007358^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007363^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007367^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007371^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007376^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007380^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007384^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007388^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007393^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007397^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007401^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007406^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007410^I0x00000000^I1106
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007414^I0x00000001^I1106
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007415^I0x0000000f^I1106
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007417^I0x000003d2^I1105
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007420^I0x0000040d^I1115
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007423^I0x0000000b^I0463
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007424^I0x0000000b^I0462
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007436^I0x0000010c^I0601
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007446^I0x04060047^I0401
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007456^I0x0000010f^I0603
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007528^I0x00000180^I0604
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007530^I0x0000019c^I0610
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007531^I0x00017295^I0610
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007532^I0x00000000^I0610
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007580^I0x00000500^I0600
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009081^I0x000001ed^I0616
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007574^I0x0001726a^I0638
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007597^I0x0000001c^I1101
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007630^I0x0000001a^I1101
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007657^I0x000000ff^I1103
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007658^I0xffff9111^I1103
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007660^I0x00000010^I1101
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007678^I0x00000011^I1101
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007691^I0x00000000^I1101
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007692^I0x00000000^I1101
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007694^I0x000001d8^I1101
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007696^I0x00000065^I1104
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007698^I0x0000000e^I1101
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007699^I0x00680034^I1102
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007700^I0x00670035^I1102
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007702^I0x007e0036^I1102
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007704^I0x007c0037^I1102
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007705^I0x00000038^I1102
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007707^I0x00840052^I1102
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007708^I0x00840053^I1102
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007710^I0x007e0054^I1102
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007711^I0x007d0055^I1102
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007713^I0x00000056^I1102
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007714^I0x00007050^I1102
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007716^I0x00017051^I1102
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007718^I0x00008204^I1102
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007720^I0x00018205^I1102
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007723^I0x00000001^I1101
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007724^I0x008b0063^I1102
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007726^I0x0000001d^I1104
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007728^I0x00000069^I1114
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007749^I0x0000020f^I0605
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007750^I0x0000026b^I0621
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007754^I0x0000010b^I1108
Jan  9 17:49:31 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007756^I0x0000000e^I1101
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007757^I0x00680034^I1102
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007758^I0x00670035^I1102
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007760^I0x007e0036^I1102
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007761^I0x007c0037^I1102
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007763^I0x00000038^I1102
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007764^I0x00840052^I1102
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007766^I0x00840053^I1102
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007767^I0x007e0054^I1102
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007769^I0x007d0055^I1102
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007770^I0x00000056^I1102
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007772^I0x00007050^I1102
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007774^I0x00017051^I1102
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007776^I0x00008204^I1102
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007778^I0x00018205^I1102
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007781^I0x00000001^I1101
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007782^I0x008b0063^I1102
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007784^I0x0000001c^I1104
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007785^I0x00000002^I1101
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007786^I0x0083903f^I1102
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007788^I0x0001d213^I1102
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007791^I0x00000002^I1101
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007792^I0x0003d206^I1102
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007794^I0x0083903e^I1102
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007798^I0x00000059^I1101
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007898^I0x00000013^I1101
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000007916^I0x00000005^I1107
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008484^I0x00016edd^I1110
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008495^I0xffffff6d^I0454
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008496^I0x00000000^I0472
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008506^I0x0000000b^I0463
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008509^I0xffffff6d^I1111
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008514^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008514^I0x0000000e^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008519^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008523^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008527^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008531^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008536^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008540^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008544^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008549^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008553^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008557^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008561^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008566^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008570^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008574^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008578^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008583^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008587^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008591^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008596^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008600^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008604^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008608^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008613^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008617^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008621^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008625^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008630^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008634^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008638^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008643^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008647^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008651^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008655^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008660^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008664^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008668^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008672^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008677^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008681^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008685^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008690^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008694^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008698^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008702^I0x00000001^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008703^I0x0000000f^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008705^I0x000003b8^I1105
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008708^I0x0000040d^I1115
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008712^I0x0000000b^I0463
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008713^I0x0000000b^I0462
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008724^I0x0000010c^I0601
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008735^I0x04070097^I0401
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008737^I0x0000000b^I0451
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008741^I0x001deb79^I0450
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008743^I0x001deb79^I0450
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008746^I0x001deb79^I0450
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008748^I0x001deb79^I0450
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008750^I0x001deb79^I0450
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008753^I0x001deb79^I0450
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008755^I0x001deb79^I0450
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008757^I0x001deb79^I0450
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008764^I0x000000ff^I0451
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008772^I0x000000d9^I0106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008774^I0x00000000^I0302
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008776^I0x00008000^I0350
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008779^I0x000000d9^I0106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008781^I0x00000000^I0301
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008854^I0x00000001^I0353
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008865^I0x00000000^I0352
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008899^I0x0000010f^I0603
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000008943^I0x04080048^I0401
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009014^I0x00000180^I0604
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009016^I0x0000019c^I0610
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009017^I0x00016cc7^I0610
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009018^I0x00000000^I0610
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009066^I0x00000500^I0600
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009060^I0x00016c9c^I0638
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009072^I0x0000001c^I1101
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009104^I0x0000001a^I1101
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009132^I0x000000ff^I1103
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009133^I0xffff9111^I1103
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009134^I0x00000010^I1101
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009153^I0x00000011^I1101
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009166^I0x00000000^I1101
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009167^I0x00000000^I1101
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009169^I0x000001d8^I1101
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009171^I0x00000064^I1104
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009173^I0x0000000e^I1101
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009174^I0x00680034^I1102
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009175^I0x00670035^I1102
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009177^I0x007e0036^I1102
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009178^I0x007c0037^I1102
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009180^I0x00000038^I1102
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009181^I0x00840052^I1102
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009183^I0x00840053^I1102
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009184^I0x007e0054^I1102
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009186^I0x007d0055^I1102
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009187^I0x00000056^I1102
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009189^I0x00007050^I1102
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009191^I0x00017051^I1102
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009193^I0x00008204^I1102
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009194^I0x00018205^I1102
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009198^I0x00000001^I1101
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009199^I0x008b0063^I1102
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009201^I0x0000001c^I1104
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009203^I0x00000069^I1114
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009240^I0x02000000^I0600
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009246^I0x00000000^I0651
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009247^I0x00000259^I0605
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009249^I0x0000026b^I0621
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009252^I0x0000010b^I1108
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009254^I0x0000000e^I1101
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009255^I0x00680034^I1102
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009257^I0x00670035^I1102
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009258^I0x007e0036^I1102
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009260^I0x007c0037^I1102
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009261^I0x00000038^I1102
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009263^I0x00840052^I1102
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009264^I0x00840053^I1102
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009266^I0x007e0054^I1102
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009267^I0x007d0055^I1102
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009269^I0x00000056^I1102
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009270^I0x00007050^I1102
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009272^I0x00017051^I1102
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009274^I0x00008204^I1102
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009276^I0x00018205^I1102
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009279^I0x00000001^I1101
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009280^I0x008b0063^I1102
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009282^I0x0000001d^I1104
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009284^I0x00000002^I1101
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009285^I0x0083903f^I1102
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009287^I0x0001d213^I1102
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009290^I0x00000002^I1101
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009291^I0x0003d206^I1102
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009293^I0x0083903e^I1102
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009297^I0x00000059^I1101
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009397^I0x00000013^I1101
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009414^I0x00000005^I1107
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009982^I0x00016903^I1110
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009993^I0xffffff6b^I0454
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000009994^I0x00000000^I0472
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010004^I0x0000000b^I0463
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010007^I0xffffff6b^I1111
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010012^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010012^I0x0000000e^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010017^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010021^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010025^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010029^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010034^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010038^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010042^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010047^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010051^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010055^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010059^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010064^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010068^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010072^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010076^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010081^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010085^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010089^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010094^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010098^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010102^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010106^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010111^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010115^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010119^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010123^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010128^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010132^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010136^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010141^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010145^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010149^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010153^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010158^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010162^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010166^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010170^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010175^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010179^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010183^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010188^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010192^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010196^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010200^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010205^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010209^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010213^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010218^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010222^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010226^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010230^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010235^I0x00000000^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010239^I0x00000001^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010240^I0x0000000f^I1106
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010241^I0x000003df^I1105
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010245^I0x0000040d^I1115
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010248^I0x0000000b^I0463
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010249^I0x0000000b^I0462
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010260^I0x0000010c^I0601
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010302^I0x00010087^I0250
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000010307^I0x0000001c^I0218
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000199855^I0x00000040^I0218
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000199859^I0x00000000^I0218
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: 0000199969^I0x00000100^I0125
Jan  9 17:49:32 rainbow kernel: [  128.914145] ieee80211 phy0: I iwl3945_print_rx_config_cmd RX CONFIG:
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl data: 00000000: 00 1f 3c 20 a1 6e 00 00 00 00 00 00 00 00 00 00  ..< .n..........
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl data: 00000010: 00 00 00 00 00 00 00 00 03 00 00 00 ff 0f 00 00  ................
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl data: 00000020: 05 80 00 00 04 00 00 00 0b 00 00 00              ............
Jan  9 17:49:32 rainbow kernel: [  128.914145] ieee80211 phy0: I iwl3945_print_rx_config_cmd u16 channel: 0xb
Jan  9 17:49:32 rainbow kernel: [  128.914145] ieee80211 phy0: I iwl3945_print_rx_config_cmd u32 flags: 0x00008005
Jan  9 17:49:32 rainbow kernel: [  128.914145] ieee80211 phy0: I iwl3945_print_rx_config_cmd u32 filter_flags: 0x00000004
Jan  9 17:49:32 rainbow kernel: [  128.914145] ieee80211 phy0: I iwl3945_print_rx_config_cmd u8 dev_type: 0x3
Jan  9 17:49:32 rainbow kernel: [  128.914145] ieee80211 phy0: I iwl3945_print_rx_config_cmd u8 ofdm_basic_rates: 0xff
Jan  9 17:49:32 rainbow kernel: [  128.914145] ieee80211 phy0: I iwl3945_print_rx_config_cmd u8 cck_basic_rates: 0x0f
Jan  9 17:49:32 rainbow kernel: [  128.914145] ieee80211 phy0: I iwl3945_print_rx_config_cmd u8[6] node_addr: 00:1f:3c:20:a1:6e
Jan  9 17:49:32 rainbow kernel: [  128.914145] ieee80211 phy0: I iwl3945_print_rx_config_cmd u8[6] bssid_addr: 00:00:00:00:00:00
Jan  9 17:49:32 rainbow kernel: [  128.914145] ieee80211 phy0: I iwl3945_print_rx_config_cmd u16 assoc_id: 0x0
Jan  9 17:49:32 rainbow kernel: [  128.914145] ieee80211 phy0: I iwl3945_irq_handle_error Restarting adapter due to uCode error.
Jan  9 17:49:32 rainbow kernel: [  128.914145] ieee80211 phy0: I iwl3945_rx_handle r = 15, i = 14, REPLY_ERROR, 0x02
Jan  9 17:49:32 rainbow kernel: [  128.914145] iwl3945 0000:03:00.0: Error Reply type 0x00000001 cmd UNKNOWN (0x3C) seq 0x6EA1 ser 0x003C0000
Jan  9 17:49:32 rainbow kernel: [  128.930372] ieee80211 phy0: U __iwl3945_down iwl3945 is going down
Jan  9 17:49:32 rainbow kernel: [  128.932909] iwl3945 0000:03:00.0: Can't stop Rx DMA.
Jan  9 17:49:32 rainbow kernel: [  128.932976] ieee80211 phy0: U iwl3945_apm_stop_master stop master
Jan  9 17:49:32 rainbow kernel: [  128.933237] ieee80211 phy0: U iwl3945_clear_free_frames 0 frames on pre-allocated heap on clear.
Jan  9 17:49:32 rainbow kernel: [  128.933262] ieee80211 phy0: U iwl3945_power_init_handle Initialize power 
Jan  9 17:49:32 rainbow kernel: [  128.933279] ieee80211 phy0: U iwl3945_power_init_handle adjust power command flags
Jan  9 17:49:32 rainbow kernel: [  128.933384] ieee80211 phy0: U iwl3945_hw_nic_init HW Revision ID = 0x2
Jan  9 17:49:32 rainbow kernel: [  128.933436] ieee80211 phy0: U iwl3945_nic_config 3945 RADIO-MM type
Jan  9 17:49:32 rainbow kernel: [  128.933450] ieee80211 phy0: U iwl3945_nic_config SKU OP mode is basic
Jan  9 17:49:32 rainbow kernel: [  128.933456] ieee80211 phy0: U iwl3945_nic_config 3945ABG revision is 0xF1
Jan  9 17:49:32 rainbow kernel: [  128.933470] ieee80211 phy0: U iwl3945_nic_config Card M type B version is 0x3
Jan  9 17:49:32 rainbow kernel: [  128.937148] ieee80211 phy0: U iwl3945_load_bsm Begin load bsm
Jan  9 17:49:32 rainbow kernel: [  128.938420] ieee80211 phy0: U iwl3945_verify_bsm Begin verify bsm
Jan  9 17:49:32 rainbow kernel: [  128.940598] ieee80211 phy0: U iwl3945_verify_bsm BSM bootstrap uCode image OK
Jan  9 17:49:32 rainbow kernel: [  128.940657] ieee80211 phy0: U iwl3945_load_bsm BSM write complete, poll 1 iterations
Jan  9 17:49:32 rainbow kernel: [  128.940676] ieee80211 phy0: U __iwl3945_up iwl3945 is coming up
Jan  9 17:49:32 rainbow kernel: [  128.952114] ieee80211 phy0: I iwl3945_rx_handle r = 1, i = 0, REPLY_ALIVE, 0x01
Jan  9 17:49:32 rainbow kernel: [  128.952131] ieee80211 phy0: I iwl3945_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x9
Jan  9 17:49:32 rainbow kernel: [  128.952139] ieee80211 phy0: I iwl3945_rx_reply_alive Initialization Alive received.
Jan  9 17:49:32 rainbow kernel: [  128.960026] ieee80211 phy0: U iwl3945_verify_inst_sparse ucode inst image size is 900
Jan  9 17:49:32 rainbow kernel: [  128.960128] ieee80211 phy0: U iwl3945_verify_inst_sparse ucode inst image size is 2672
Jan  9 17:49:32 rainbow kernel: [  128.960424] ieee80211 phy0: U iwl3945_verify_ucode Initialize uCode is good in inst SRAM
Jan  9 17:49:32 rainbow kernel: [  128.960432] ieee80211 phy0: U iwl3945_init_alive_start Initialization Alive received.
Jan  9 17:49:32 rainbow kernel: [  128.960482] ieee80211 phy0: U iwl3945_set_ucode_ptrs Runtime uCode pointers are set.
Jan  9 17:49:32 rainbow kernel: [  128.964836] ieee80211 phy0: I iwl3945_rx_handle r = 2, i = 1, REPLY_ALIVE, 0x01
Jan  9 17:49:32 rainbow kernel: [  128.964847] ieee80211 phy0: I iwl3945_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x0
Jan  9 17:49:32 rainbow kernel: [  128.964855] ieee80211 phy0: I iwl3945_rx_reply_alive Runtime Alive received.
Jan  9 17:49:32 rainbow kernel: [  128.964903] ieee80211 phy0: I iwl3945_disable_events Selected uCode log events may be disabled
Jan  9 17:49:32 rainbow kernel: [  128.964910] ieee80211 phy0: I iwl3945_disable_events   by writing "1"s into disable bitmap
Jan  9 17:49:32 rainbow kernel: [  128.964918] ieee80211 phy0: I iwl3945_disable_events   in SRAM at 0x8022c8, size 47 u32s
Jan  9 17:49:32 rainbow kernel: [  128.972026] ieee80211 phy0: U iwl3945_alive_start Runtime Alive received.
Jan  9 17:49:32 rainbow kernel: [  128.972037] ieee80211 phy0: U iwl3945_verify_inst_sparse ucode inst image size is 900
Jan  9 17:49:32 rainbow kernel: [  128.972122] ieee80211 phy0: U iwl3945_verify_inst_sparse ucode inst image size is 2672
Jan  9 17:49:32 rainbow kernel: [  128.972208] ieee80211 phy0: U iwl3945_verify_inst_sparse ucode inst image size is 80684
Jan  9 17:49:32 rainbow kernel: [  128.979969] ieee80211 phy0: U iwl3945_verify_ucode Runtime uCode is good in inst SRAM
Jan  9 17:49:32 rainbow kernel: [  128.980028] ieee80211 phy0: U iwl3945_alive_start RFKILL status: 0x1
Jan  9 17:49:32 rainbow kernel: [  128.980057] ieee80211 phy0: U iwl3945_update_power_cmd Flags value = 0x00000009
Jan  9 17:49:32 rainbow kernel: [  128.980065] ieee80211 phy0: U iwl3945_update_power_cmd Tx timeout = 102400
Jan  9 17:49:32 rainbow kernel: [  128.980072] ieee80211 phy0: U iwl3945_update_power_cmd Rx timeout = 51200
Jan  9 17:49:32 rainbow kernel: [  128.980080] ieee80211 phy0: U iwl3945_update_power_cmd Sleep interval vector = { 1 , 1 , 1 , 1 , 1 }
Jan  9 17:49:32 rainbow kernel: [  128.980094] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command POWER_TABLE_CMD (#77), seq: 0x0400, 36 bytes at 0[0]:4
Jan  9 17:49:32 rainbow kernel: [  128.980180] ieee80211 phy0: I iwl3945_rx_handle r 3 i 2 No handler needed for POWER_TABLE_CMD, 0x77
Jan  9 17:49:32 rainbow kernel: [  128.980262] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_BT_CONFIG (#9b), seq: 0x0401, 16 bytes at 1[1]:4
Jan  9 17:49:32 rainbow kernel: [  128.980278] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Jan  9 17:49:32 rainbow kernel: [  128.982068] ieee80211 phy0: I iwl3945_rx_handle r 4 i 3 No handler needed for REPLY_BT_CONFIG, 0x9b
Jan  9 17:49:32 rainbow kernel: [  128.982103] ieee80211 phy0: U iwl3945_commit_rxon Sending RXON
Jan  9 17:49:32 rainbow kernel: [  128.982105] * without RXON_FILTER_ASSOC_MSK
Jan  9 17:49:32 rainbow kernel: [  128.982107] * channel = 11
Jan  9 17:49:32 rainbow kernel: [  128.982109] * bssid = 00:00:00:00:00:00
Jan  9 17:49:32 rainbow kernel: [  128.982126] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x0402, 48 bytes at 2[2]:4
Jan  9 17:49:32 rainbow kernel: [  128.982140] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Jan  9 17:49:32 rainbow kernel: [  128.985063] ieee80211 phy0: I iwl3945_rx_handle r 5 i 4 No handler needed for REPLY_RXON, 0x10
Jan  9 17:49:32 rainbow kernel: [  128.985121] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 235 dsp 121 rate code 0x0d
Jan  9 17:49:32 rainbow kernel: [  128.985131] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 235 dsp 121 rate code 0x0f
Jan  9 17:49:32 rainbow kernel: [  128.985140] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 235 dsp 121 rate code 0x05
Jan  9 17:49:32 rainbow kernel: [  128.985148] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 235 dsp 121 rate code 0x07
Jan  9 17:49:32 rainbow kernel: [  128.985156] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 235 dsp 121 rate code 0x09
Jan  9 17:49:32 rainbow kernel: [  128.985164] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 235 dsp 121 rate code 0x0b
Jan  9 17:49:32 rainbow kernel: [  128.985172] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 235 dsp 121 rate code 0x01
Jan  9 17:49:32 rainbow kernel: [  128.985180] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 235 dsp 121 rate code 0x03
Jan  9 17:49:32 rainbow kernel: [  128.985187] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 171 dsp 110 rate code 0x0a
Jan  9 17:49:32 rainbow kernel: [  128.985195] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 171 dsp 110 rate code 0x14
Jan  9 17:49:32 rainbow kernel: [  128.985204] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 171 dsp 110 rate code 0x37
Jan  9 17:49:32 rainbow kernel: [  128.985213] ieee80211 phy0: U iwl3945_hw_reg_send_txpower ch 11:1 rf 171 dsp 110 rate code 0x6e
Jan  9 17:49:32 rainbow kernel: [  128.985224] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0403, 56 bytes at 3[3]:4
Jan  9 17:49:32 rainbow kernel: [  128.985240] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Jan  9 17:49:32 rainbow kernel: [  128.987900] ieee80211 phy0: I iwl3945_rx_handle r 6 i 5 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
Jan  9 17:49:32 rainbow kernel: [  128.987958] ieee80211 phy0: U iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
Jan  9 17:49:32 rainbow kernel: [  128.987971] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0404, 68 bytes at 4[4]:4
Jan  9 17:49:32 rainbow kernel: [  128.987985] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Jan  9 17:49:32 rainbow kernel: [  128.990829] ieee80211 phy0: I iwl3945_rx_handle r = 7, i = 6, REPLY_ADD_STA, 0x18
Jan  9 17:49:32 rainbow kernel: [  128.990860] ieee80211 phy0: U iwl3945_send_add_station REPLY_ADD_STA PASSED
Jan  9 17:49:32 rainbow kernel: [  128.990876] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0405, 56 bytes at 5[5]:4
Jan  9 17:49:32 rainbow kernel: [  128.990891] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Jan  9 17:49:32 rainbow kernel: [  128.993644] ieee80211 phy0: I iwl3945_rx_handle r 8 i 7 No handler needed for REPLY_RATE_SCALE, 0x47
Jan  9 17:49:32 rainbow kernel: [  128.993679] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0406, 56 bytes at 6[6]:4
Jan  9 17:49:32 rainbow kernel: [  128.993872] ieee80211 phy0: I iwl3945_rx_handle r 9 i 8 No handler needed for REPLY_RATE_SCALE, 0x47
Jan  9 17:49:32 rainbow kernel: [  128.993913] ieee80211 phy0: U iwl3945_hw_reg_txpower_get_temperature Temperature: 112
Jan  9 17:49:32 rainbow kernel: [  128.993922] ieee80211 phy0: U is_temp_calib_needed Getting cooler, delta -1,
Jan  9 17:49:32 rainbow kernel: [  128.993930] ieee80211 phy0: U is_temp_calib_needed Timed thermal calib not needed
Jan  9 17:49:32 rainbow kernel: [  128.994019] Registered led device: iwl-phy0:radio
Jan  9 17:49:32 rainbow kernel: [  128.994028] ieee80211 phy0: U iwl3945_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0407, 12 bytes at 7[7]:4
Jan  9 17:49:32 rainbow kernel: [  128.994045] ieee80211 phy0: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Jan  9 17:49:32 rainbow kernel: [  128.994094] Registered led device: iwl-phy0:assoc
Jan  9 17:49:32 rainbow kernel: [  128.994129] Registered led device: iwl-phy0:RX
Jan  9 17:49:32 rainbow kernel: [  128.994164] Registered led device: iwl-phy0:TX
Jan  9 17:49:32 rainbow kernel: [  128.994168] ieee80211 phy0: U iwl3945_alive_start ALIVE processing complete.
Jan  9 17:49:32 rainbow kernel: [  128.996677] ieee80211 phy0: I iwl3945_rx_handle r 10 i 9 No handler needed for REPLY_LEDS_CMD, 0x48
Jan  9 17:49:32 rainbow kernel: [  129.109100] wlan0: direct probe to AP 00:30:bd:c0:90:24 timed out



      
