Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45913 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789Ab2IEQzf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2012 12:55:35 -0400
Received: by eekc1 with SMTP id c1so326619eek.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Sep 2012 09:55:34 -0700 (PDT)
Date: Wed, 5 Sep 2012 18:55:10 +0200
From: Anisse Astier <anisse@astier.eu>
To: linux-wireless@vger.kernel.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Subject: rtl8192ce: activation problem with rtl8188ce pci card
Message-ID: <20120905185510.2ab501cd@destiny.ordissimo> (sfid-20120905_185544_569443_BB7F60E7)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/fj=9ZoQXUMmXiPp7BD4WaoO"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--MP_/fj=9ZoQXUMmXiPp7BD4WaoO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

On a toshiba laptop (see dmesg attached), with a wireless-next kernel,
this card doesn't seem to turn on:
01:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RTL8101E/RTL8102E PCI Express Fast Ethernet controller [10ec:8136] (rev 02)

# modprobe rtl8192ce debug=4
[ 6184.995319] cfg80211: Calling CRDA to update world regulatory domain
[ 6185.103824] rtl8192ce: rtl8192ce: FW Power Save off (module option)
[ 6185.103881] rtl8192ce: Using firmware rtlwifi/rtl8192cfw.bin
[ 6185.150488] rtlwifi:rtl_fw_cb():<0-0> Firmware callback routine entered!
[ 6185.216834] ieee80211 phy0: Selected rate control algorithm 'rtl_rc'
[ 6185.224729] rtlwifi: wireless switch is on
[ 6185.289544] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:11
[ 6185.289649] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:11
[ 6185.289797] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:11
[ 6185.289944] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:11
[ 6185.290092] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:11
[ 6185.290250] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:11
[ 6185.290398] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:11
[ 6185.290545] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:11
[ 6185.290693] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:98053f15:10
[ 6185.291829] rtl8192c_common:rtl92c_download_fw():<0-0> Firmware Version(49), Signature(0x88c1),Size(32)
[ 6185.513223] rtl8192ce:rtl92ce_enable_hw_security_config():<0-0> PairwiseEncAlgorithm = 0 GroupEncAlgorithm = 0
[ 6185.513237] rtl8192ce:rtl92ce_enable_hw_security_config():<0-0> The SECR-value cc
[ 6185.622274] rtl8192c_common:rtl92c_dm_initialize_txpower_tracking_thermalmeter():<0-0> pMgntInfo->txpower_tracking = 1
[ 6185.623129] rtlwifi:rtl_pci_start():<0-0> enable_interrupt OK
[ 6185.623140] rtlwifi:rtl_pci_start():<0-0> OK
[ 6185.624061] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> Not connected to any
[ 6185.624073] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[ 6185.624123] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Trigger 92S Thermal Meter!!
[ 6185.632970] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 2
[ 6185.632987] rtl8192ce:rtl92ce_sw_led_on():<0-0> LedAddr:4E ledpin=1
[ 6185.633028] rtlwifi:rtl_op_bss_info_changed():<0-0> BSS_CHANGED_ERP_PREAMBLE use short preamble:0
[ 6185.633040] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[ 6185.633989] rtlwifi:rtl_op_config():<0-0> IEEE80211_CONF_CHANGE_LISTEN_INTERVAL
[ 6185.634281] rtlwifi:rtl_op_config():<0-0> IEEE80211_CONF_CHANGE_RETRY_LIMITS 4
[ 6185.644434] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[ 6185.644445] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[ 6185.655245] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 6185.734598] rtl8192ce:_rtl92ce_phy_set_rf_power_state():<0-0> IPS Set eRf nic disable
[ 6185.735117] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 2
[ 6185.735129] rtl8192ce:rtl92ce_sw_led_on():<0-0> LedAddr:4E ledpin=1
[ 6185.852489] rtlwifi:_rtl_pci_interrupt():<10000-1> rx descriptor unavailable!
[ 6185.852504] rtlwifi:_rtl_pci_interrupt():<10000-1> rx overflow !
[ 6185.853211] rtlwifi:_rtl_pci_interrupt():<10000-1> rx descriptor unavailable!
[ 6185.853221] rtlwifi:_rtl_pci_interrupt():<10000-1> rx overflow !
[ 6185.853823] rtlwifi:_rtl_pci_interrupt():<10000-1> rx descriptor unavailable!
[ 6185.853833] rtlwifi:_rtl_pci_interrupt():<10000-1> rx overflow !
[...] this is repeated

After a modprobe -r:
[ 6187.127706] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 2
[ 6187.127724] rtl8192ce:rtl92ce_sw_led_on():<0-0> LedAddr:4E ledpin=1
[ 6187.130614] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 2
[ 6187.130626] rtl8192ce:rtl92ce_sw_led_on():<0-0> LedAddr:4E ledpin=1
[ 6187.130638] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 7
[ 6187.130646] rtl8192ce:rtl92ce_sw_led_off():<0-0> LedAddr:4E ledpin=1
[ 6187.139353] rtl8192c_common:rtl92c_firmware_selfreset(): 8051 reset fail
[ 6187.139373] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 7
[ 6187.139382] rtl8192ce:rtl92ce_sw_led_off():<0-0> LedAddr:4E ledpin=1

 
After inserting the module, the PCI information is scrambled:
06:00.0 Network controller: Realtek Semiconductor Co., Ltd. Device 8176 (rev ff) (prog-if ff)
        !!! Unknown header type 7f

After a few seconds, the computer will freeze if the module isn't removed.
The card works on Windows.

This looks like a hidden rfkill, or maybe it is a different revision of
the card. What do you think ?

Regards,

Anisse
--MP_/fj=9ZoQXUMmXiPp7BD4WaoO
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=dmesg-rtl8192ce-no-up.txt

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.5.0 (root@compilator-1) (gcc version 4.4.5 (Debian 4.4.5-8) ) #13 SMP Wed Sep 5 15:51:44 CEST 2012
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009f7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009f800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000df6befff] usable
[    0.000000] BIOS-e820: [mem 0x00000000df6bf000-0x00000000dfabefff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000dfabf000-0x00000000dfbbefff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000dfbbf000-0x00000000dfbfefff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000dfbff000-0x00000000dfbfffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dfc00000-0x00000000dfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec10000-0x00000000fec10fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed80000-0x00000000fed80fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffe00000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x0000000106ffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000107000000-0x000000011effffff] reserved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.7 present.
[    0.000000] DMI: TOSHIBA SATELLITE C850D-115/Renmore, BIOS 1.10 04/25/2012
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x107000 max_arch_pfn = 0x1000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-through
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 080000000 mask FC0000000 write-back
[    0.000000]   2 base 0C0000000 mask FE0000000 write-back
[    0.000000]   3 base 0DFBBC000 mask FFFFFF000 uncachable
[    0.000000]   4 base 0FFE00000 mask FFFE00000 write-protect
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 000000011f000000 aka 4592M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] initial memory mapped: [mem 0x00000000-0x01ffffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x37bfdfff]
[    0.000000]  [mem 0x00000000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x379fffff] page 2M
[    0.000000]  [mem 0x37a00000-0x37bfdfff] page 4k
[    0.000000] kernel direct mapping tables up to 0x37bfdfff @ [mem 0x01ffa000-0x01ffffff]
[    0.000000] RAMDISK: [mem 0x037bd000-0x03ffffff]
[    0.000000] ACPI: RSDP 000fe020 00024 (v02 TOSASU)
[    0.000000] ACPI: XSDT dfbfe120 00084 (v01 TOSASU TOSASU00 00000001      01000013)
[    0.000000] ACPI: FACP dfbfc000 0010C (v05 TOSASU TOSASU00 00000001 ACPI 00040000)
[    0.000000] ACPI: DSDT dfbdd000 1A3D2 (v01 TOSASU TOSASU00 F0000000 ACPI 00040000)
[    0.000000] ACPI: FACS dfb82000 00040
[    0.000000] ACPI: UEFI dfbfd000 00236 (v01 TOSASU TOSASU00 00000001 ACPI 00040000)
[    0.000000] ACPI: HPET dfbfb000 00038 (v01 TOSASU TOSASU00 00000001 ACPI 00040000)
[    0.000000] ACPI: APIC dfbfa000 00084 (v03 TOSASU TOSASU00 00000001 ACPI 00040000)
[    0.000000] ACPI: MCFG dfbf9000 0003C (v01 TOSASU TOSASU00 00000001 ACPI 00040000)
[    0.000000] ACPI: ASF! dfbf8000 000A5 (v32 TOSASU TOSASU00 00000001 ACPI 00040000)
[    0.000000] ACPI: BOOT dfbdc000 00028 (v01 TOSASU TOSASU00 00000001 ACPI 00040000)
[    0.000000] ACPI: SLIC dfbdb000 00176 (v01 TOSASU TOSASU00 00000001 ACPI 00040000)
[    0.000000] ACPI: WDRT dfbda000 00047 (v01 TOSASU TOSASU00 00000000 ACPI 00040000)
[    0.000000] ACPI: WDAT dfbd9000 001AC (v01 TOSASU TOSASU00 00000001 ACPI 00040000)
[    0.000000] ACPI: SSDT dfbd8000 003DE (v01 AMD    POWERNOW 00000001 AMD  00000001)
[    0.000000] ACPI: SSDT dfbd6000 016CF (v02    AMD     ALIB 00000001 MSFT 04000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 3316MB HIGHMEM available.
[    0.000000] 891MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 37bfe000
[    0.000000]   low ram: 0 - 37bfe000
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x37bfdfff]
[    0.000000]   HighMem  [mem 0x37bfe000-0x06ffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0xdf6befff]
[    0.000000]   node   0: [mem 0xdfbff000-0xdfbfffff]
[    0.000000]   node   0: [mem 0x00000000-0x06ffffff]
[    0.000000] On node 0 totalpages: 943695
[    0.000000] free_area_init_node: node 0, pgdat c1591e80, node_mem_map f5b1d200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3951 pages, LIFO batch:0
[    0.000000]   Normal zone: 1752 pages used for memmap
[    0.000000]   Normal zone: 222502 pages, LIFO batch:31
[    0.000000]   HighMem zone: 6633 pages used for memmap
[    0.000000]   HighMem zone: 708825 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10228210 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 3 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0xe0000000-0xf7ffffff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 13 pages/cpu @f5ab4000 s32064 r0 d21184 u53248
[    0.000000] pcpu-alloc: s32064 r0 d21184 u53248 alloc=13*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 935278
[    0.000000] Kernel command line: auto BOOT_IMAGE=Ordissimo ro root=LABEL=root splash=silent quiet radeon.modeset=1 i915.modeset=1
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00037bfe:00107000)
[    0.000000] Memory: 3719696k/4308992k available (3651k kernel code, 55084k reserved, 2091k data, 484k init, 2861832k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff16000 - 0xfffff000   ( 932 kB)
[    0.000000]     pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
[    0.000000]     vmalloc : 0xf83fe000 - 0xffbfe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf7bfe000   ( 891 MB)
[    0.000000]       .init : 0xc159c000 - 0xc1615000   ( 484 kB)
[    0.000000]       .data : 0xc1390de8 - 0xc159bdc0   (2091 kB)
[    0.000000]       .text : 0xc1000000 - 0xc1390de8   (3651 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=4.
[    0.000000] NR_IRQS:2304 nr_irqs:712 16
[    0.000000] CPU 0 irqstacks, hard=f5408000 soft=f540a000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3567 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.001000] tsc: Detected 1397.338 MHz processor
[    0.000005] Calibrating delay loop (skipped), value calculated using timer frequency.. 2794.67 BogoMIPS (lpj=1397338)
[    0.000013] pid_max: default: 32768 minimum: 301
[    0.000179] Mount-cache hash table entries: 512
[    0.002308] CPU: Physical Processor ID: 0
[    0.002314] CPU: Processor Core ID: 0
[    0.002319] mce: CPU supports 6 MCE banks
[    0.002346] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.002346] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.002346] tlb_flushall_shift is 0xffffffff
[    0.002849] SMP alternatives: lockdep: fixing up alternatives
[    0.002854] SMP alternatives: switching to UP code
[    0.009206] ACPI: Core revision 20120711
[    0.049352] ftrace: allocating 16506 entries in 33 pages
[    0.066164] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.066831] ..TIMER: vector=0x51 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.076834] smpboot: CPU0: AMD E1-1200 APU with Radeon(tm) HD Graphics stepping 00
[    0.178280] Performance Events: AMD PMU driver.
[    0.178300] ... version:                0
[    0.178304] ... bit width:              48
[    0.178308] ... generic registers:      4
[    0.178312] ... value mask:             0000ffffffffffff
[    0.178315] ... max period:             00007fffffffffff
[    0.178318] ... fixed-purpose events:   0
[    0.178322] ... event mask:             000000000000000f
[    0.179652] Brought up 1 CPUs
[    0.179661] smpboot: Total of 1 processors activated (2794.67 BogoMIPS)
[    0.181456] devtmpfs: initialized
[    0.182456] PM: Registering ACPI NVS region [mem 0xdfabf000-0xdfbbefff] (1048576 bytes)
[    0.184969] NET: Registered protocol family 16
[    0.188126] ACPI: bus type pci registered
[    0.188757] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.188766] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.188769] PCI: Using MMCONFIG for extended config space
[    0.188774] PCI: Using configuration type 1 for base access
[    0.207097] bio: create slab <bio-0> at 0
[    0.207684] ACPI: Added _OSI(Module Device)
[    0.207697] ACPI: Added _OSI(Processor Device)
[    0.207702] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.207707] ACPI: Added _OSI(Processor Aggregator Device)
[    0.230869] ACPI: EC: Look up EC in DSDT
[    2.782403] ACPI: Executed 1 blocks of module-level executable AML code
[    2.799424] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    2.803556] ACPI: Interpreter enabled
[    2.803568] ACPI: (supports S0 S3 S5)
[    2.803678] ACPI: Using IOAPIC for interrupt routing
[    2.807268] [Firmware Bug]: ACPI: No _BQC method, cannot determine initial brightness
[    2.808513] [Firmware Bug]: ACPI: No _BQC method, cannot determine initial brightness
[    2.846353] ACPI: Power Resource [P0L0] (off)
[    2.846798] ACPI: Power Resource [P0L1] (off)
[    2.847099] ACPI: Power Resource [P0L2] (off)
[    2.847451] ACPI: Power Resource [P0L3] (off)
[    2.853505] ACPI: EC: GPE = 0xc, I/O: command/status = 0x66, data = 0x62
[    2.854948] ACPI: No dock devices found.
[    2.854960] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    2.855985] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    2.856522] pci_root PNP0A08:00: ignoring host bridge window [mem 0x000cc000-0x000cffff] (conflicts with Video ROM [mem 0x000c0000-0x000cefff])
[    2.856565] pci_root PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-3f] only partially covers this bridge
[    2.857101] PCI host bridge to bus 0000:00
[    2.857112] pci_bus 0000:00: busn_res: [bus 00-ff] is inserted under domain [bus 00-ff]
[    2.857118] pci_bus 0000:00: root bus resource [bus 00-ff]
[    2.857125] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    2.857131] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    2.857136] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    2.857142] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000c3fff]
[    2.857148] pci_bus 0000:00: root bus resource [mem 0x000c4000-0x000c7fff]
[    2.857155] pci_bus 0000:00: root bus resource [mem 0x000c8000-0x000cbfff]
[    2.857160] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
[    2.857166] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
[    2.857173] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    2.857178] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
[    2.857183] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff]
[    2.857188] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff]
[    2.857194] pci_bus 0000:00: root bus resource [mem 0x000e8000-0x000ebfff]
[    2.857200] pci_bus 0000:00: root bus resource [mem 0x000ec000-0x000effff]
[    2.857205] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xf7ffffff]
[    2.857211] pci_bus 0000:00: root bus resource [mem 0xfc000000-0xfed3ffff]
[    2.857217] pci_bus 0000:00: root bus resource [mem 0xfed45000-0xffffffff]
[    2.857350] pci 0000:00:00.0: [1022:1510] type 00 class 0x060000
[    2.857529] pci 0000:00:01.0: [1002:9809] type 00 class 0x030000
[    2.857555] pci 0000:00:01.0: reg 10: [mem 0xe0000000-0xefffffff pref]
[    2.857574] pci 0000:00:01.0: reg 14: [io  0x5000-0x50ff]
[    2.857593] pci 0000:00:01.0: reg 18: [mem 0xf0400000-0xf043ffff]
[    2.857720] pci 0000:00:01.0: supports D1 D2
[    2.857763] pci 0000:00:01.1: [1002:1314] type 00 class 0x040300
[    2.857787] pci 0000:00:01.1: reg 10: [mem 0xf0444000-0xf0447fff]
[    2.857935] pci 0000:00:01.1: supports D1 D2
[    2.858095] pci 0000:00:11.0: [1022:7800] type 00 class 0x01018f
[    2.858128] pci 0000:00:11.0: reg 10: [io  0x5118-0x511f]
[    2.858149] pci 0000:00:11.0: reg 14: [io  0x5124-0x5127]
[    2.858170] pci 0000:00:11.0: reg 18: [io  0x5110-0x5117]
[    2.858191] pci 0000:00:11.0: reg 1c: [io  0x5120-0x5123]
[    2.858212] pci 0000:00:11.0: reg 20: [io  0x5100-0x510f]
[    2.858243] pci 0000:00:11.0: reg 24: [mem 0xf044f000-0xf044f7ff]
[    2.858291] pci 0000:00:11.0: set SATA to AHCI mode
[    2.858367] pci 0000:00:12.0: [1022:7807] type 00 class 0x0c0310
[    2.858394] pci 0000:00:12.0: reg 10: [mem 0xf044e000-0xf044efff]
[    2.858544] pci 0000:00:12.2: [1022:7808] type 00 class 0x0c0320
[    2.858582] pci 0000:00:12.2: reg 10: [mem 0xf044d000-0xf044d0ff]
[    2.858751] pci 0000:00:12.2: supports D1 D2
[    2.858757] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    2.858933] pci 0000:00:13.0: [1022:7807] type 00 class 0x0c0310
[    2.858960] pci 0000:00:13.0: reg 10: [mem 0xf044c000-0xf044cfff]
[    2.859112] pci 0000:00:13.2: [1022:7808] type 00 class 0x0c0320
[    2.859150] pci 0000:00:13.2: reg 10: [mem 0xf044b000-0xf044b0ff]
[    2.859330] pci 0000:00:13.2: supports D1 D2
[    2.859336] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    2.859389] pci 0000:00:14.0: [1022:780b] type 00 class 0x0c0500
[    2.859554] pci 0000:00:14.2: [1022:780d] type 00 class 0x040300
[    2.859601] pci 0000:00:14.2: reg 10: [mem 0xf0440000-0xf0443fff 64bit]
[    2.859758] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    2.859798] pci 0000:00:14.3: [1022:780e] type 00 class 0x060100
[    2.859954] pci 0000:00:14.4: [1022:780f] type 01 class 0x060401
[    2.860046] pci 0000:00:14.5: [1022:7809] type 00 class 0x0c0310
[    2.860072] pci 0000:00:14.5: reg 10: [mem 0xf044a000-0xf044afff]
[    2.860226] pci 0000:00:15.0: [1022:43a0] type 01 class 0x060400
[    2.860429] pci 0000:00:15.0: supports D1 D2
[    2.860487] pci 0000:00:15.1: [1022:43a1] type 01 class 0x060400
[    2.860656] pci 0000:00:15.1: supports D1 D2
[    2.860712] pci 0000:00:15.2: [1022:43a2] type 01 class 0x060400
[    2.860880] pci 0000:00:15.2: supports D1 D2
[    2.860939] pci 0000:00:16.0: [1022:7807] type 00 class 0x0c0310
[    2.860966] pci 0000:00:16.0: reg 10: [mem 0xf0449000-0xf0449fff]
[    2.861116] pci 0000:00:16.2: [1022:7808] type 00 class 0x0c0320
[    2.861154] pci 0000:00:16.2: reg 10: [mem 0xf0448000-0xf04480ff]
[    2.861355] pci 0000:00:16.2: supports D1 D2
[    2.861361] pci 0000:00:16.2: PME# supported from D0 D1 D2 D3hot
[    2.861419] pci 0000:00:18.0: [1022:1700] type 00 class 0x060000
[    2.861518] pci 0000:00:18.1: [1022:1701] type 00 class 0x060000
[    2.861607] pci 0000:00:18.2: [1022:1702] type 00 class 0x060000
[    2.861701] pci 0000:00:18.3: [1022:1703] type 00 class 0x060000
[    2.861824] pci 0000:00:18.4: [1022:1704] type 00 class 0x060000
[    2.861912] pci 0000:00:18.5: [1022:1718] type 00 class 0x060000
[    2.862000] pci 0000:00:18.6: [1022:1716] type 00 class 0x060000
[    2.862088] pci 0000:00:18.7: [1022:1719] type 00 class 0x060000
[    2.862290] pci_bus 0000:01: busn_res: [bus 01] is inserted under [bus 00-ff]
[    2.862390] pci 0000:00:14.4: PCI bridge to [bus 01] (subtractive decode)
[    2.862411] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    2.862416] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    2.862422] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    2.862428] pci 0000:00:14.4:   bridge window [mem 0x000c0000-0x000c3fff] (subtractive decode)
[    2.862434] pci 0000:00:14.4:   bridge window [mem 0x000c4000-0x000c7fff] (subtractive decode)
[    2.862440] pci 0000:00:14.4:   bridge window [mem 0x000c8000-0x000cbfff] (subtractive decode)
[    2.862446] pci 0000:00:14.4:   bridge window [mem 0x000d0000-0x000d3fff] (subtractive decode)
[    2.862451] pci 0000:00:14.4:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
[    2.862457] pci 0000:00:14.4:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
[    2.862463] pci 0000:00:14.4:   bridge window [mem 0x000dc000-0x000dffff] (subtractive decode)
[    2.862469] pci 0000:00:14.4:   bridge window [mem 0x000e0000-0x000e3fff] (subtractive decode)
[    2.862475] pci 0000:00:14.4:   bridge window [mem 0x000e4000-0x000e7fff] (subtractive decode)
[    2.862481] pci 0000:00:14.4:   bridge window [mem 0x000e8000-0x000ebfff] (subtractive decode)
[    2.862488] pci 0000:00:14.4:   bridge window [mem 0x000ec000-0x000effff] (subtractive decode)
[    2.862494] pci 0000:00:14.4:   bridge window [mem 0xe0000000-0xf7ffffff] (subtractive decode)
[    2.862500] pci 0000:00:14.4:   bridge window [mem 0xfc000000-0xfed3ffff] (subtractive decode)
[    2.862506] pci 0000:00:14.4:   bridge window [mem 0xfed45000-0xffffffff] (subtractive decode)
[    2.862650] pci_bus 0000:02: busn_res: [bus 02-05] is inserted under [bus 00-ff]
[    2.862660] pci 0000:00:15.0: PCI bridge to [bus 02-05]
[    2.862674] pci 0000:00:15.0:   bridge window [io  0x4000-0x4fff]
[    2.862685] pci 0000:00:15.0:   bridge window [mem 0xf0300000-0xf03fffff]
[    2.862700] pci 0000:00:15.0:   bridge window [mem 0xf0000000-0xf00fffff 64bit pref]
[    2.862807] pci_bus 0000:06: busn_res: [bus 06] is inserted under [bus 00-ff]
[    2.862852] pci 0000:06:00.0: [10ec:8176] type 00 class 0x028000
[    2.862886] pci 0000:06:00.0: reg 10: [io  0x3000-0x30ff]
[    2.862944] pci 0000:06:00.0: reg 18: [mem 0xf0200000-0xf0203fff 64bit]
[    2.863123] pci 0000:06:00.0: supports D1 D2
[    2.863129] pci 0000:06:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    2.865340] pci 0000:00:15.1: PCI bridge to [bus 06]
[    2.865364] pci 0000:00:15.1:   bridge window [io  0x3000-0x3fff]
[    2.865381] pci 0000:00:15.1:   bridge window [mem 0xf0200000-0xf02fffff]
[    2.865504] pci_bus 0000:07: busn_res: [bus 07] is inserted under [bus 00-ff]
[    2.865546] pci 0000:07:00.0: [10ec:8136] type 00 class 0x020000
[    2.865578] pci 0000:07:00.0: reg 10: [io  0x2000-0x20ff]
[    2.865634] pci 0000:07:00.0: reg 18: [mem 0xf0104000-0xf0104fff 64bit pref]
[    2.865670] pci 0000:07:00.0: reg 20: [mem 0xf0100000-0xf0103fff 64bit pref]
[    2.865818] pci 0000:07:00.0: supports D1 D2
[    2.865824] pci 0000:07:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    2.867341] pci 0000:00:15.2: PCI bridge to [bus 07]
[    2.867407] pci 0000:00:15.2:   bridge window [io  0x2000-0x2fff]
[    2.867428] pci 0000:00:15.2:   bridge window [mem 0xf0100000-0xf01fffff 64bit pref]
[    2.867479] pci_bus 0000:00: on NUMA node 0
[    2.867496] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    2.868164] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.SPB0._PRT]
[    2.868334] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.SPB1._PRT]
[    2.868487] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.SPB2._PRT]
[    2.868866] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
[    2.869540]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    2.870298]  pci0000:00: ACPI _OSC control (0x1d) granted
[    2.928637] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 10 11 12 14 15) *0
[    2.928957] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 10 11 12 14 15) *0
[    2.929364] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 10 11 12 14 15) *0
[    2.929677] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 10 11 12 14 15) *0
[    2.929956] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 10 11 12 14 15) *0
[    2.930213] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 10 11 12 14 15) *0
[    2.930462] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 10 11 12 14 15) *0
[    2.930705] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 10 11 12 14 15) *0
[    2.932034] vgaarb: device added: PCI:0000:00:01.0,decodes=io+mem,owns=io+mem,locks=none
[    2.932106] vgaarb: loaded
[    2.932110] vgaarb: bridge control possible 0000:00:01.0
[    2.932985] SCSI subsystem initialized
[    2.932993] ACPI: bus type scsi registered
[    2.933494] libata version 3.00 loaded.
[    2.934799] PCI: Using ACPI for IRQ routing
[    2.938165] PCI: pci_cache_line_size set to 64 bytes
[    2.938539] e820: reserve RAM buffer [mem 0x0009f800-0x0009ffff]
[    2.938547] e820: reserve RAM buffer [mem 0xdf6bf000-0xdfffffff]
[    2.938556] e820: reserve RAM buffer [mem 0xdfc00000-0xdfffffff]
[    2.938562] e820: reserve RAM buffer [mem 0x107000000-0x107ffffff]
[    2.940137] Switching to clocksource hpet
[    2.994143] pnp: PnP ACPI init
[    2.994229] ACPI: bus type pnp registered
[    2.994638] pnp 00:00: [bus 00-ff]
[    2.994647] pnp 00:00: [io  0x0000-0x0cf7 window]
[    2.994653] pnp 00:00: [io  0x0d00-0xffff window]
[    2.994660] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    2.994665] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    2.994671] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    2.994773] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    2.994779] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    2.994784] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    2.994795] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    2.994800] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    2.994805] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    2.994810] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    2.994816] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    2.994821] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    2.994826] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    2.994832] pnp 00:00: [mem 0xe0000000-0xf7ffffff window]
[    2.994838] pnp 00:00: [mem 0xfc000000-0xfed3ffff window]
[    2.994843] pnp 00:00: [mem 0xfed45000-0xffffffff window]
[    2.994848] pnp 00:00: [io  0x0cf8-0x0cff]
[    2.995430] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    2.995593] pnp 00:01: [mem 0xfec00000-0xfec00fff]
[    2.995599] pnp 00:01: [mem 0xfee00000-0xfee00fff]
[    2.996118] system 00:01: [mem 0xfec00000-0xfec00fff] could not be reserved
[    2.996126] system 00:01: [mem 0xfee00000-0xfee00fff] has been reserved
[    2.996142] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    2.996717] pnp 00:02: [irq 0 disabled]
[    2.996734] pnp 00:02: [irq 8]
[    2.996741] pnp 00:02: [mem 0xfed00000-0xfed003ff]
[    2.997051] pnp 00:02: Plug and Play ACPI device, IDs PNP0103 (active)
[    2.997439] pnp 00:03: [io  0x0000-0x000f]
[    2.997445] pnp 00:03: [io  0x0081-0x008f]
[    2.997450] pnp 00:03: [io  0x00c0-0x00df]
[    2.997456] pnp 00:03: [dma 4]
[    2.997858] pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
[    2.997894] pnp 00:04: [io  0x00f0-0x00fe]
[    2.997905] pnp 00:04: [irq 13]
[    2.998265] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
[    2.998450] pnp 00:05: [io  0x0070-0x0071]
[    2.998849] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
[    2.998883] pnp 00:06: [io  0x0061]
[    2.999277] pnp 00:06: Plug and Play ACPI device, IDs PNP0800 (active)
[    2.999334] pnp 00:07: [io  0x0060]
[    2.999340] pnp 00:07: [io  0x0064]
[    2.999351] pnp 00:07: [irq 1]
[    2.999796] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
[    2.999836] pnp 00:08: [irq 12]
[    3.000210] pnp 00:08: Plug and Play ACPI device, IDs TOS0310 PNP0f13 (active)
[    3.000251] pnp 00:09: [io  0x0010-0x001f]
[    3.000256] pnp 00:09: [io  0x002e-0x002f]
[    3.000262] pnp 00:09: [io  0x0072-0x0073]
[    3.000267] pnp 00:09: [io  0x0080]
[    3.000272] pnp 00:09: [io  0x00b0-0x00b1]
[    3.000276] pnp 00:09: [io  0x0092]
[    3.000281] pnp 00:09: [io  0x025c-0x025d]
[    3.000286] pnp 00:09: [io  0x0400-0x04cf]
[    3.000291] pnp 00:09: [io  0x04d0-0x04d1]
[    3.000301] pnp 00:09: [io  0x04d6]
[    3.000305] pnp 00:09: [io  0x0680-0x06ff]
[    3.000310] pnp 00:09: [io  0x077a]
[    3.000315] pnp 00:09: [io  0x0c00-0x0c01]
[    3.000319] pnp 00:09: [io  0x0c14]
[    3.000324] pnp 00:09: [io  0x0c50-0x0c52]
[    3.000328] pnp 00:09: [io  0x0c6c]
[    3.000333] pnp 00:09: [io  0x0c6f]
[    3.000338] pnp 00:09: [io  0x0cd0-0x0cdb]
[    3.000342] pnp 00:09: [io  0x0840-0x0847]
[    3.000878] system 00:09: [io  0x025c-0x025d] has been reserved
[    3.000886] system 00:09: [io  0x0400-0x04cf] has been reserved
[    3.000892] system 00:09: [io  0x04d0-0x04d1] has been reserved
[    3.000899] system 00:09: [io  0x04d6] has been reserved
[    3.000906] system 00:09: [io  0x0680-0x06ff] has been reserved
[    3.000913] system 00:09: [io  0x077a] has been reserved
[    3.000919] system 00:09: [io  0x0c00-0x0c01] has been reserved
[    3.000926] system 00:09: [io  0x0c14] has been reserved
[    3.000932] system 00:09: [io  0x0c50-0x0c52] has been reserved
[    3.000938] system 00:09: [io  0x0c6c] has been reserved
[    3.000945] system 00:09: [io  0x0c6f] has been reserved
[    3.000952] system 00:09: [io  0x0cd0-0x0cdb] has been reserved
[    3.000959] system 00:09: [io  0x0840-0x0847] has been reserved
[    3.000973] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    3.001136] pnp 00:0a: [mem 0x000e0000-0x000fffff]
[    3.001143] pnp 00:0a: [mem 0xffe00000-0xffffffff]
[    3.001626] system 00:0a: [mem 0x000e0000-0x000fffff] could not be reserved
[    3.001634] system 00:0a: [mem 0xffe00000-0xffffffff] has been reserved
[    3.001646] system 00:0a: Plug and Play ACPI device, IDs PNP0c01 (active)
[    3.003450] pnp: PnP ACPI: found 11 devices
[    3.003456] ACPI: ACPI bus type pnp unregistered
[    3.062483] pci 0000:00:14.4: PCI bridge to [bus 01]
[    3.062517] pci 0000:00:15.0: PCI bridge to [bus 02-05]
[    3.062526] pci 0000:00:15.0:   bridge window [io  0x4000-0x4fff]
[    3.062538] pci 0000:00:15.0:   bridge window [mem 0xf0300000-0xf03fffff]
[    3.062549] pci 0000:00:15.0:   bridge window [mem 0xf0000000-0xf00fffff 64bit pref]
[    3.062563] pci 0000:00:15.1: PCI bridge to [bus 06]
[    3.062571] pci 0000:00:15.1:   bridge window [io  0x3000-0x3fff]
[    3.062583] pci 0000:00:15.1:   bridge window [mem 0xf0200000-0xf02fffff]
[    3.062600] pci 0000:00:15.2: PCI bridge to [bus 07]
[    3.062652] pci 0000:00:15.2:   bridge window [io  0x2000-0x2fff]
[    3.062669] pci 0000:00:15.2:   bridge window [mem 0xf0100000-0xf01fffff 64bit pref]
[    3.062758] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    3.062765] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    3.062770] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    3.062776] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000c3fff]
[    3.062782] pci_bus 0000:00: resource 8 [mem 0x000c4000-0x000c7fff]
[    3.062789] pci_bus 0000:00: resource 9 [mem 0x000c8000-0x000cbfff]
[    3.062795] pci_bus 0000:00: resource 10 [mem 0x000d0000-0x000d3fff]
[    3.062800] pci_bus 0000:00: resource 11 [mem 0x000d4000-0x000d7fff]
[    3.062806] pci_bus 0000:00: resource 12 [mem 0x000d8000-0x000dbfff]
[    3.062812] pci_bus 0000:00: resource 13 [mem 0x000dc000-0x000dffff]
[    3.062818] pci_bus 0000:00: resource 14 [mem 0x000e0000-0x000e3fff]
[    3.062824] pci_bus 0000:00: resource 15 [mem 0x000e4000-0x000e7fff]
[    3.062829] pci_bus 0000:00: resource 16 [mem 0x000e8000-0x000ebfff]
[    3.062835] pci_bus 0000:00: resource 17 [mem 0x000ec000-0x000effff]
[    3.062840] pci_bus 0000:00: resource 18 [mem 0xe0000000-0xf7ffffff]
[    3.062846] pci_bus 0000:00: resource 19 [mem 0xfc000000-0xfed3ffff]
[    3.062852] pci_bus 0000:00: resource 20 [mem 0xfed45000-0xffffffff]
[    3.062859] pci_bus 0000:01: resource 4 [io  0x0000-0x0cf7]
[    3.062864] pci_bus 0000:01: resource 5 [io  0x0d00-0xffff]
[    3.062869] pci_bus 0000:01: resource 6 [mem 0x000a0000-0x000bffff]
[    3.062875] pci_bus 0000:01: resource 7 [mem 0x000c0000-0x000c3fff]
[    3.062881] pci_bus 0000:01: resource 8 [mem 0x000c4000-0x000c7fff]
[    3.062887] pci_bus 0000:01: resource 9 [mem 0x000c8000-0x000cbfff]
[    3.062892] pci_bus 0000:01: resource 10 [mem 0x000d0000-0x000d3fff]
[    3.062898] pci_bus 0000:01: resource 11 [mem 0x000d4000-0x000d7fff]
[    3.062903] pci_bus 0000:01: resource 12 [mem 0x000d8000-0x000dbfff]
[    3.062909] pci_bus 0000:01: resource 13 [mem 0x000dc000-0x000dffff]
[    3.062916] pci_bus 0000:01: resource 14 [mem 0x000e0000-0x000e3fff]
[    3.062922] pci_bus 0000:01: resource 15 [mem 0x000e4000-0x000e7fff]
[    3.062927] pci_bus 0000:01: resource 16 [mem 0x000e8000-0x000ebfff]
[    3.062933] pci_bus 0000:01: resource 17 [mem 0x000ec000-0x000effff]
[    3.062940] pci_bus 0000:01: resource 18 [mem 0xe0000000-0xf7ffffff]
[    3.062946] pci_bus 0000:01: resource 19 [mem 0xfc000000-0xfed3ffff]
[    3.062951] pci_bus 0000:01: resource 20 [mem 0xfed45000-0xffffffff]
[    3.062957] pci_bus 0000:02: resource 0 [io  0x4000-0x4fff]
[    3.062962] pci_bus 0000:02: resource 1 [mem 0xf0300000-0xf03fffff]
[    3.062968] pci_bus 0000:02: resource 2 [mem 0xf0000000-0xf00fffff 64bit pref]
[    3.062974] pci_bus 0000:06: resource 0 [io  0x3000-0x3fff]
[    3.062979] pci_bus 0000:06: resource 1 [mem 0xf0200000-0xf02fffff]
[    3.062986] pci_bus 0000:07: resource 0 [io  0x2000-0x2fff]
[    3.062991] pci_bus 0000:07: resource 2 [mem 0xf0100000-0xf01fffff 64bit pref]
[    3.063109] NET: Registered protocol family 2
[    3.063862] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    3.065000] TCP bind hash table entries: 65536 (order: 9, 2359296 bytes)
[    3.077721] TCP: Hash tables configured (established 131072 bind 65536)
[    3.077852] TCP: reno registered
[    3.077871] UDP hash table entries: 512 (order: 3, 40960 bytes)
[    3.078072] UDP-Lite hash table entries: 512 (order: 3, 40960 bytes)
[    3.078520] NET: Registered protocol family 1
[    3.078568] pci 0000:00:01.0: Boot video device
[    3.079258] PCI: CLS 64 bytes, default 64
[    3.079529] Trying to unpack rootfs image as initramfs...
[    3.579467] Freeing initrd memory: 8460k freed
[    3.586154] Simple Boot Flag at 0x44 set to 0x1
[    3.586463] LVT offset 0 assigned for vector 0x400
[    3.586556] perf: AMD IBS detected (0x000000ff)
[    3.590965] bounce pool size: 64 pages
[    3.616441] msgmni has been set to 1692
[    3.617758] io scheduler noop registered
[    3.617766] io scheduler deadline registered (default)
[    3.618844] pcieport 0000:00:15.0: irq 40 for MSI/MSI-X
[    3.619536] pcieport 0000:00:15.1: irq 41 for MSI/MSI-X
[    3.620065] pcieport 0000:00:15.2: irq 42 for MSI/MSI-X
[    3.620989] pcieport 0000:00:15.0: Signaling PME through PCIe PME interrupt
[    3.621080] pcie_pme 0000:00:15.0:pcie01: service driver pcie_pme loaded
[    3.621156] pcieport 0000:00:15.1: Signaling PME through PCIe PME interrupt
[    3.621164] pci 0000:06:00.0: Signaling PME through PCIe PME interrupt
[    3.621210] pcie_pme 0000:00:15.1:pcie01: service driver pcie_pme loaded
[    3.621283] pcieport 0000:00:15.2: Signaling PME through PCIe PME interrupt
[    3.621290] pci 0000:07:00.0: Signaling PME through PCIe PME interrupt
[    3.621337] pcie_pme 0000:00:15.2:pcie01: service driver pcie_pme loaded
[    3.623869] ACPI: acpi_idle registered with cpuidle
[    3.651590] Linux agpgart interface v0.103
[    3.663821] brd: module loaded
[    3.664818] ahci 0000:00:11.0: version 3.0
[    3.665398] ahci 0000:00:11.0: AHCI 0001.0300 32 slots 2 ports 6 Gbps 0x3 impl SATA mode
[    3.665408] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part 
[    3.668683] scsi0 : ahci
[    3.669793] scsi1 : ahci
[    3.670420] ata1: SATA max UDMA/133 abar m2048@0xf044f000 port 0xf044f100 irq 19
[    3.670428] ata2: SATA max UDMA/133 abar m2048@0xf044f000 port 0xf044f180 irq 19
[    3.674366] sky2: driver version 1.30
[    3.675234] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    3.675612] r8169 0000:07:00.0: irq 43 for MSI/MSI-X
[    3.676966] r8169 0000:07:00.0: eth0: RTL8105e at 0xf842a000, 4c:72:b9:64:6c:52, XID 00c00000 IRQ 43
[    3.678466] i8042: PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    3.681223] i8042: Detected active multiplexing controller, rev 1.1
[    3.683248] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.683345] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    3.683871] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    3.684021] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    3.684033] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    3.685899] mousedev: PS/2 mouse device common for all mice
[    3.687669] rtc_cmos 00:05: RTC can wake from S4
[    3.688666] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    3.688795] rtc0: alarms up to one month, 114 bytes nvram, hpet irqs
[    3.689175] cpuidle: using governor ladder
[    3.689701] cpuidle: using governor menu
[    3.691783] TCP: cubic registered
[    3.691794] NET: Registered protocol family 17
[    3.692129] Key type dns_resolver registered
[    3.693160] Using IPI No-Shortcut mode
[    3.694119] registered taskstats version 1
[    3.695766] console [netcon0] enabled
[    3.695771] netconsole: network logging started
[    3.695885] rtc_cmos 00:05: setting system clock to 2012-09-05 18:12:53 UTC (1346868773)
[    3.884108] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    4.630202] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.630362] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    4.632268] ata1.00: ATA-8: Hitachi HTS543232A7A384, ES2OA70K, max UDMA/133
[    4.632284] ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    4.634622] ata2.00: ATAPI: TSSTcorp CDDVDW SN-208AB, TO03, max UDMA/100
[    4.634671] ata1.00: configured for UDMA/133
[    4.636126] scsi 0:0:0:0: Direct-Access     ATA      Hitachi HTS54323 ES2O PQ: 0 ANSI: 5
[    4.638652] sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
[    4.638865] sd 0:0:0:0: [sda] Write Protect is off
[    4.638873] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.638962] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.642213] ata2.00: configured for UDMA/100
[    4.643170] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    4.651572] scsi 1:0:0:0: CD-ROM            TSSTcorp CDDVDW SN-208AB  TO03 PQ: 0 ANSI: 5
[    4.666170] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    4.666181] cdrom: Uniform CD-ROM driver Revision: 3.20
[    4.667668] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    4.668704] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    5.070415]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 >
[    5.075322] sd 0:0:0:0: [sda] Attached SCSI disk
[    5.075678] Freeing unused kernel memory: 484k freed
[    5.076260] Write protecting the kernel text: 3652k
[    5.076485] Write protecting the kernel read-only data: 1740k
[    5.076496] NX-protecting the kernel data: 4540k
[    5.087945] tsc: Refined TSC clocksource calibration: 1397.458 MHz
[    5.087984] Switching to clocksource tsc
[    5.139116] udev: starting version 160
[    5.139317] udevd (695): /proc/695/oom_adj is deprecated, please use /proc/695/oom_score_adj instead.
[    5.289843] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    5.297479] ACPI: Power Button [PWRB]
[    5.300657] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input2
[    5.347079] ACPI: Lid Switch [LID]
[    5.348521] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    5.348719] ACPI: Power Button [PWRF]
[    5.380769] [Firmware Bug]: ACPI: No _BQC method, cannot determine initial brightness
[    5.381472] thermal LNXTHERM:00: registered as thermal_zone0
[    5.381478] ACPI: Thermal Zone [THZ0] (50 C)
[    5.403167] ACPI: Fan [Z0F0] (off)
[    5.403463] ACPI: Fan [Z0F1] (off)
[    5.403686] ACPI: Fan [Z0F2] (off)
[    5.403903] ACPI: Fan [Z0F3] (off)
[    5.405435] acpi device:01: registered as cooling_device5
[    5.405607] ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
[    5.405883] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input4
[    5.680959] ACPI: bus type usb registered
[    5.681131] usbcore: registered new interface driver usbfs
[    5.681274] usbcore: registered new interface driver hub
[    5.715183] usbcore: registered new device driver usb
[    5.716452] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    5.716724] ehci_hcd 0000:00:12.2: EHCI Host Controller
[    5.717132] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
[    5.717246] QUIRK: Enable AMD PLL fix
[    5.717255] ehci_hcd 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    5.717566] ehci_hcd 0000:00:12.2: debug port 1
[    5.718984] [drm] Initialized drm 1.1.0 20060810
[    5.734828] ehci_hcd 0000:00:12.2: irq 17, io mem 0xf044d000
[    5.750880] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    5.751336] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    5.751344] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.751350] usb usb1: Product: EHCI Host Controller
[    5.751356] usb usb1: Manufacturer: Linux 3.5.0 ehci_hcd
[    5.751361] usb usb1: SerialNumber: 0000:00:12.2
[    5.793181] psmouse serio2: synaptics: Touchpad model: 1, fw: 7.2, id: 0x1c0b1, caps: 0xd04733/0xa40000/0xa0000, board id: 3655, fw id: 582762
[    5.812310] hub 1-0:1.0: USB hub found
[    5.812409] hub 1-0:1.0: 5 ports detected
[    5.828971] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio2/input/input5
[    5.839110] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    5.839167] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
[    5.839187] ehci_hcd 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    5.839286] ehci_hcd 0000:00:13.2: debug port 1
[    5.839319] ehci_hcd 0000:00:13.2: irq 17, io mem 0xf044b000
[    5.844862] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    5.845061] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    5.845068] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.845074] usb usb2: Product: EHCI Host Controller
[    5.845079] usb usb2: Manufacturer: Linux 3.5.0 ehci_hcd
[    5.845084] usb usb2: SerialNumber: 0000:00:13.2
[    5.848151] hub 2-0:1.0: USB hub found
[    5.848177] hub 2-0:1.0: 5 ports detected
[    5.857819] ehci_hcd 0000:00:16.2: EHCI Host Controller
[    5.857853] ehci_hcd 0000:00:16.2: new USB bus registered, assigned bus number 3
[    5.857871] ehci_hcd 0000:00:16.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    5.857971] ehci_hcd 0000:00:16.2: debug port 1
[    5.858005] ehci_hcd 0000:00:16.2: irq 17, io mem 0xf0448000
[    5.863833] ehci_hcd 0000:00:16.2: USB 2.0 started, EHCI 1.00
[    5.863945] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    5.863952] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.863958] usb usb3: Product: EHCI Host Controller
[    5.863963] usb usb3: Manufacturer: Linux 3.5.0 ehci_hcd
[    5.863968] usb usb3: SerialNumber: 0000:00:16.2
[    5.867463] hub 3-0:1.0: USB hub found
[    5.867489] hub 3-0:1.0: 4 ports detected
[    5.915818] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    5.916095] ohci_hcd 0000:00:12.0: OHCI Host Controller
[    5.916126] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 4
[    5.916867] ohci_hcd 0000:00:12.0: irq 18, io mem 0xf044e000
[    5.951572] [drm] radeon kernel modesetting enabled.
[    5.972055] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    5.972066] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.972072] usb usb4: Product: OHCI Host Controller
[    5.972078] usb usb4: Manufacturer: Linux 3.5.0 ohci_hcd
[    5.972083] usb usb4: SerialNumber: 0000:00:12.0
[    5.976285] hub 4-0:1.0: USB hub found
[    5.976381] hub 4-0:1.0: 5 ports detected
[    5.989043] [drm] initializing kernel modesetting (PALM 0x1002:0x9809 0x1179:0xFB33).
[    5.989178] [drm] register mmio base: 0xF0400000
[    5.989183] [drm] register mmio size: 262144
[    5.998414] ATOM BIOS: AMD
[    5.998506] radeon 0000:00:01.0: VRAM: 384M 0x0000000000000000 - 0x0000000017FFFFFF (384M used)
[    5.998515] radeon 0000:00:01.0: GTT: 512M 0x0000000018000000 - 0x0000000037FFFFFF
[    6.003047] [drm] Detected VRAM RAM=384M, BAR=256M
[    6.003056] [drm] RAM width 32bits DDR
[    6.007275] [TTM] Zone  kernel: Available graphics memory: 433404 kiB
[    6.007285] [TTM] Zone highmem: Available graphics memory: 1864320 kiB
[    6.007289] [TTM] Initializing pool allocator
[    6.008457] [drm] radeon: 384M of VRAM memory ready
[    6.008466] [drm] radeon: 512M of GTT memory ready.
[    6.018996] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    6.019006] [drm] Driver supports precise vblank timestamp query.
[    6.019221] radeon 0000:00:01.0: irq 44 for MSI/MSI-X
[    6.019267] radeon 0000:00:01.0: radeon: using MSI.
[    6.019463] [drm] radeon: irq initialized.
[    6.019476] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    6.028806] [drm] Loading PALM Microcode
[    6.075353] [drm] PCIE GART of 512M enabled (table at 0x0000000000040000).
[    6.075880] radeon 0000:00:01.0: WB enabled
[    6.075890] radeon 0000:00:01.0: fence driver on ring 0 use gpu addr 0x0000000018000c00 and cpu addr 0xffc8cc00
[    6.093926] [drm] ring test on 0 succeeded in 1 usecs
[    6.095034] [drm] ib test on ring 0 succeeded in 0 usecs
[    6.098272] [drm] Radeon Display Connectors
[    6.098281] [drm] Connector 0:
[    6.098285] [drm]   LVDS-1
[    6.098288] [drm]   HPD1
[    6.098294] [drm]   DDC: 0x6430 0x6430 0x6434 0x6434 0x6438 0x6438 0x643c 0x643c
[    6.098298] [drm]   Encoders:
[    6.098302] [drm]     LCD1: INTERNAL_UNIPHY
[    6.098305] [drm] Connector 1:
[    6.098309] [drm]   HDMI-A-1
[    6.098312] [drm]   HPD2
[    6.098317] [drm]   DDC: 0x6440 0x6440 0x6444 0x6444 0x6448 0x6448 0x644c 0x644c
[    6.098320] [drm]   Encoders:
[    6.098323] [drm]     DFP1: INTERNAL_UNIPHY
[    6.098326] [drm] Connector 2:
[    6.098330] [drm]   VGA-1
[    6.098335] [drm]   DDC: 0x64d8 0x64d8 0x64dc 0x64dc 0x64e0 0x64e0 0x64e4 0x64e4
[    6.098338] [drm]   Encoders:
[    6.098341] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    6.098842] [drm] Internal thermal controller without fan control
[    6.099490] [drm] radeon: power management initialized
[    6.149667] usb 2-3: new high-speed USB device number 2 using ehci_hcd
[    6.278007] usb 2-3: New USB device found, idVendor=0bda, idProduct=0138
[    6.278025] usb 2-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    6.278035] usb 2-3: Product: USB2.0-CRW
[    6.278044] usb 2-3: Manufacturer: Generic
[    6.278053] usb 2-3: SerialNumber: 20090516388200000
[    6.294818] Initializing USB Mass Storage driver...
[    6.295402] scsi2 : usb-storage 2-3:1.0
[    6.296452] usbcore: registered new interface driver usb-storage
[    6.296459] USB Mass Storage support registered.
[    6.387268] usb 2-4: new high-speed USB device number 3 using ehci_hcd
[    6.532474] [drm] fb mappable at 0xE0142000
[    6.532483] [drm] vram apper at 0xE0000000
[    6.532486] [drm] size 4325376
[    6.532490] [drm] fb depth is 24
[    6.532493] [drm]    pitch is 5632
[    6.534257] fbcon: radeondrmfb (fb0) is primary device
[    6.639970] usb 2-4: New USB device found, idVendor=04f2, idProduct=b307
[    6.639979] usb 2-4: New USB device strings: Mfr=3, Product=1, SerialNumber=2
[    6.639985] usb 2-4: Product: TOSHIBA Web Camera - HD
[    6.639991] usb 2-4: Manufacturer: Chicony Electronics Co.,Ltd.
[    6.639996] usb 2-4: SerialNumber: 0x0001
[    7.081095] Console: switching to colour frame buffer device 170x48
[    7.090618] fb0: radeondrmfb frame buffer device
[    7.090619] drm: registered panic notifier
[    7.090955] [drm] Initialized radeon 2.17.0 20080528 for 0000:00:01.0 on minor 0
[    7.091299] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    7.091328] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 5
[    7.091418] ohci_hcd 0000:00:13.0: irq 18, io mem 0xf044c000
[    7.146871] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    7.146882] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.146888] usb usb5: Product: OHCI Host Controller
[    7.146894] usb usb5: Manufacturer: Linux 3.5.0 ohci_hcd
[    7.146899] usb usb5: SerialNumber: 0000:00:13.0
[    7.147910] hub 5-0:1.0: USB hub found
[    7.148003] hub 5-0:1.0: 5 ports detected
[    7.148641] ohci_hcd 0000:00:14.5: OHCI Host Controller
[    7.148669] ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 6
[    7.148752] ohci_hcd 0000:00:14.5: irq 18, io mem 0xf044a000
[    7.203647] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    7.203658] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.203664] usb usb6: Product: OHCI Host Controller
[    7.203669] usb usb6: Manufacturer: Linux 3.5.0 ohci_hcd
[    7.203674] usb usb6: SerialNumber: 0000:00:14.5
[    7.204547] hub 6-0:1.0: USB hub found
[    7.204571] hub 6-0:1.0: 2 ports detected
[    7.205190] ohci_hcd 0000:00:16.0: OHCI Host Controller
[    7.205219] ohci_hcd 0000:00:16.0: new USB bus registered, assigned bus number 7
[    7.205306] ohci_hcd 0000:00:16.0: irq 18, io mem 0xf0449000
[    7.260589] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    7.260600] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.260606] usb usb7: Product: OHCI Host Controller
[    7.260612] usb usb7: Manufacturer: Linux 3.5.0 ohci_hcd
[    7.260617] usb usb7: SerialNumber: 0000:00:16.0
[    7.261401] hub 7-0:1.0: USB hub found
[    7.261472] hub 7-0:1.0: 4 ports detected
[    7.302300] scsi 2:0:0:0: Direct-Access     Generic- Multi-Card       1.00 PQ: 0 ANSI: 0 CCS
[    7.303786] sd 2:0:0:0: Attached scsi generic sg2 type 0
[    7.311825] sd 2:0:0:0: [sdb] Attached SCSI removable disk
[    7.678264] kjournald starting.  Commit interval 5 seconds
[    7.678463] EXT3-fs (sda5): mounted filesystem with ordered data mode
[    7.741890] kjournald starting.  Commit interval 5 seconds
[    7.741969] EXT3-fs (sda7): mounted filesystem with ordered data mode
[    9.882200] udev: starting version 160
[   10.333808] ACPI: Deprecated procfs I/F for AC is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[   10.334140] wmi: Mapper loaded
[   10.377814] ACPI: AC Adapter [AC0] (on-line)
[   10.446692] ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[   10.446748] ACPI: Battery Slot [BAT0] (battery present)
[   10.727404] ACPI Warning: 0x00000b00-0x00000b07 SystemIO conflicts with Region \_SB_.PCI0.SMBS.SMB0 1 (20120711/utaddress-251)
[   10.727427] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   10.979174] microcode: CPU0: patch_level=0x0500010d
[   10.981314] Linux video capture interface: v2.00
[   11.160691] uvcvideo: Found UVC 1.00 device TOSHIBA Web Camera - HD (04f2:b307)
[   11.173597] input: TOSHIBA Web Camera - HD as /devices/pci0000:00/0000:00:13.2/usb2/2-4/2-4:1.0/input/input6
[   11.174894] usbcore: registered new interface driver uvcvideo
[   11.174901] USB Video Class driver (1.1.1)
[   11.261831] snd_hda_intel 0000:00:01.1: irq 45 for MSI/MSI-X
[   11.293621] input: HD-Audio Generic HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:01.1/sound/card2/input7
[   11.311941] snd_hda_intel 0000:00:14.2: irq 46 for MSI/MSI-X
[   11.375724] input: HD-Audio Generic Mic as /devices/pci0000:00/0000:00:14.2/sound/card0/input8
[   11.376438] input: HD-Audio Generic Headphone as /devices/pci0000:00/0000:00:14.2/sound/card0/input9
[   11.442385] microcode: failed to load file amd-ucode/microcode_amd.bin
[   11.444535] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   11.498486] powernow-k8: Found 1 AMD E1-1200 APU with Radeon(tm) HD Graphics (1 cpu cores) (version 2.20.00)
[   11.498633] powernow-k8:    0 : pstate 0 (1400 MHz)
[   11.498639] powernow-k8:    1 : pstate 1 (1166 MHz)
[   11.498643] powernow-k8:    2 : pstate 2 (777 MHz)
[   13.383848] Adding 1048572k swap on /dev/sda6.  Priority:-1 extents:1 across:1048572k 
[   25.568669] kjournald starting.  Commit interval 5 seconds
[   25.569334] EXT3-fs (sda7): using internal journal
[   25.569352] EXT3-fs (sda7): mounted filesystem with ordered data mode
[   26.236551] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redhat.com
[   28.025775] kjournald starting.  Commit interval 5 seconds
[   28.026256] EXT3-fs (sda8): using internal journal
[   28.026268] EXT3-fs (sda8): mounted filesystem with ordered data mode
[   28.143583] kjournald starting.  Commit interval 5 seconds
[   28.144514] EXT3-fs (sda9): using internal journal
[   28.144533] EXT3-fs (sda9): mounted filesystem with ordered data mode
[   30.920725] fuse init (API version 7.19)
[   31.657279] r8169 0000:07:00.0: eth0: link down
[   31.657585] r8169 0000:07:00.0: eth0: link down
[   33.293384] r8169 0000:07:00.0: eth0: link up
[   34.029275] device eth0 entered promiscuous mode
[   35.042100] device eth0 left promiscuous mode
[   35.052708] device eth0 entered promiscuous mode
[   35.200657] NET: Registered protocol family 10
[   36.059184] device eth0 left promiscuous mode

--MP_/fj=9ZoQXUMmXiPp7BD4WaoO--
