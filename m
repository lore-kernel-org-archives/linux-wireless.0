Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:45710 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754795AbZBJWUL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2009 17:20:11 -0500
Received: by wf-out-1314.google.com with SMTP id 28so62809wfa.4
        for <linux-wireless@vger.kernel.org>; Tue, 10 Feb 2009 14:20:09 -0800 (PST)
Message-ID: <4991FD9A.8050701@gmail.com> (sfid-20090210_232027_868424_7BA4CC12)
Date: Tue, 10 Feb 2009 14:20:10 -0800
From: John Daiker <daikerjohn@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: bcm43xx-dev@lists.berlios.de
Subject: b43: extreme latency on 2.6.28.3
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have been having trouble with my b43 card for a bit, and wondered if 
anyone could lend a hand.

Long story short... dropped connections and crazy-high latency when 
initially connecting.  I am fairly confident that it's not the router 
(Netgear WGR614v9), as I have two other machines that don't see this 
kind of high latency.  (Windows laptop with an Intel 4965 and an Ubuntu 
8.10 server with a Realtek rt2500pci).


Pinging from one box (192.168.1.204) to the problem box (192.168.1.210)
 From 192.168.1.204 icmp_seq=37 Destination Host Unreachable
 From 192.168.1.204 icmp_seq=38 Destination Host Unreachable
 From 192.168.1.204 icmp_seq=39 Destination Host Unreachable
 From 192.168.1.204 icmp_seq=51 Destination Host Unreachable
 From 192.168.1.204 icmp_seq=52 Destination Host Unreachable
 From 192.168.1.204 icmp_seq=53 Destination Host Unreachable
64 bytes from 192.168.1.210: icmp_seq=49 ttl=64 time=15307 ms
64 bytes from 192.168.1.210: icmp_seq=54 ttl=64 time=18607 ms
64 bytes from 192.168.1.210: icmp_seq=55 ttl=64 time=18285 ms
64 bytes from 192.168.1.210: icmp_seq=56 ttl=64 time=17696 ms
64 bytes from 192.168.1.210: icmp_seq=57 ttl=64 time=19030 ms
64 bytes from 192.168.1.210: icmp_seq=58 ttl=64 time=18239 ms
64 bytes from 192.168.1.210: icmp_seq=59 ttl=64 time=17332 ms

(Un)fortunately, this high latency disappeared over the course of 
writing this e-mail... so the mystery deepens.

I'm wondering what could cause this, and more importantly, how I can 
help to debug it.  I've researched how to increase mac80211 and/or b43 
debug verbosity, but can't find much documented in-kernel or on 
linuxwireless.org

dmesg, kernel config, and lspci -vvv output included.


For further reference, should I inline-include the following, or use 
attachments?

Thanks,
John Daiker



dmesg
[    0.000000] BIOS EBDA/lowmem at: 0009f800/0009f800
[    0.000000] Linux version 2.6.28.3-090210-1343 (root@jdm6) (gcc 
version 4.3.2 (Ubuntu 4.3.2-1ubuntu12) ) #1 SMP Tue Feb 10 13:49:08 PST 2009
[    0.000000] Command line: 
root=UUID=d0d52b48-db63-4fd7-bb7a-4af5119d2017 ro printk.time=1 
initcall_debug
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cfee0000 (usable)
[    0.000000]  BIOS-e820: 00000000cfee0000 - 00000000cfee3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cfee3000 - 00000000cfef0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cfef0000 - 00000000cff00000 (reserved)
[    0.000000]  BIOS-e820: 00000000d0000000 - 00000000e0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
[    0.000000] DMI 2.4 present.
[    0.000000] last_pfn = 0x130000 max_arch_pfn = 0x3ffffffff
[    0.000000] last_pfn = 0xcfee0 max_arch_pfn = 0x3ffffffff
[    0.000000] init_memory_mapping: 0000000000000000-00000000cfee0000
[    0.000000]  0000000000 - 00cfe00000 page 2M
[    0.000000]  00cfe00000 - 00cfee0000 page 4k
[    0.000000] kernel direct mapping tables up to cfee0000 @ 8000-e000
[    0.000000] last_map_addr: cfee0000 end: cfee0000
[    0.000000] init_memory_mapping: 0000000100000000-0000000130000000
[    0.000000]  0100000000 - 0130000000 page 2M
[    0.000000] kernel direct mapping tables up to 130000000 @ c000-12000
[    0.000000] last_map_addr: 130000000 end: 130000000
[    0.000000] RAMDISK: 37bd9000 - 37fef391
[    0.000000] ACPI: RSDP 000F6E20, 0014 (r0 GBT   )
[    0.000000] ACPI: RSDT CFEE3040, 003C (r1 GBT    GBTUACPI 42302E31 
GBTU  1010101)
[    0.000000] ACPI: FACP CFEE30C0, 0074 (r1 GBT    GBTUACPI 42302E31 
GBTU  1010101)
[    0.000000] ACPI: DSDT CFEE3180, 5363 (r1 GBT    GBTUACPI     1000 
MSFT  100000C)
[    0.000000] ACPI: FACS CFEE0000, 0040
[    0.000000] ACPI: HPET CFEE8640, 0038 (r1 GBT    GBTUACPI 42302E31 
GBTU       98)
[    0.000000] ACPI: MCFG CFEE86C0, 003C (r1 GBT    GBTUACPI 42302E31 
GBTU  1010101)
[    0.000000] ACPI: APIC CFEE8540, 0084 (r1 GBT    GBTUACPI 42302E31 
GBTU  1010101)
[    0.000000] ACPI: SSDT CFEE8740, 019E (r1  PmRef  Cpu0Ist     3000 
INTL 20040311)
[    0.000000] ACPI: SSDT CFEE8BD0, 0275 (r1  PmRef    CpuPm     3000 
INTL 20040311)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] (7 early reservations) ==> bootmem [0000000000 - 0130000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> 
[0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> 
[0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 00008baba8]    TEXT DATA BSS ==> 
[0000200000 - 00008baba8]
[    0.000000]   #3 [0037bd9000 - 0037fef391]          RAMDISK ==> 
[0037bd9000 - 0037fef391]
[    0.000000]   #4 [000009f800 - 0000100000]    BIOS reserved ==> 
[000009f800 - 0000100000]
[    0.000000]   #5 [0000008000 - 000000c000]          PGTABLE ==> 
[0000008000 - 000000c000]
[    0.000000]   #6 [000000c000 - 000000d000]          PGTABLE ==> 
[000000c000 - 000000d000]
[    0.000000] found SMP MP-table at [ffff8800000f5470] 000f5470
[    0.000000]  [ffffe20000000000-ffffe200043fffff] PMD -> 
[ffff880028200000-ffff88002c5fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00130000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000cfee0
[    0.000000]     0: 0x00100000 -> 0x00130000
[    0.000000] On node 0 totalpages: 1048191
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1828 pages reserved
[    0.000000]   DMA zone: 2115 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 833304 pages, LIFO batch:31
[    0.000000]   Normal zone: 2688 pages used for memmap
[    0.000000]   Normal zone: 193920 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] Allocating PCI resources starting at e2000000 (gap: 
e0000000:1ec00000)
[    0.000000] PERCPU: Allocating 45056 bytes of per cpu data
[    0.000000] NR_CPUS: 2, nr_cpu_ids: 2, nr_node_ids 1
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on. 
Total pages: 1029339
[    0.000000] Kernel command line: 
root=UUID=d0d52b48-db63-4fd7-bb7a-4af5119d2017 ro printk.time=1 
initcall_debug
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2666.670 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Dentry cache hash table entries: 524288 (order: 10, 
4194304 bytes)
[    0.004000] Inode-cache hash table entries: 262144 (order: 9, 2097152 
bytes)
[    0.004000] Checking aperture...
[    0.004000] No AGP bridge found
[    0.004000] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.004000] Placing software IO TLB between 0x20000000 - 0x24000000
[    0.004000] Memory: 4038504k/4980736k available (3772k kernel code, 
787972k absent, 153372k reserved, 2142k data, 336k init)
[    0.004000] hpet clockevent registered
[    0.004000] HPET: 3 timers in total, 0 timers will be used for 
per-cpu timer
[    0.004000] Calibrating delay loop (skipped), value calculated using 
timer frequency.. 5333.34 BogoMIPS (lpj=10666680)
[    0.004000] Mount-cache hash table entries: 256
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 4096K
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 0
[    0.004000] CPU0: Thermal monitoring enabled (TM2)
[    0.004000] using mwait in idle threads.
[    0.004000] ACPI: Core revision 20080926
[    0.007718] Setting APIC routing to flat
[    0.008000] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.047829] CPU0: Intel(R) Core(TM)2 CPU          6700  @ 2.66GHz 
stepping 06
[    0.048001] calling  migration_init+0x0/0x5b @ 1
[    0.048001] initcall migration_init+0x0/0x5b returned 1 after 0 usecs
[    0.048001] initcall migration_init+0x0/0x5b returned with error code 1
[    0.048001] calling  spawn_ksoftirqd+0x0/0x61 @ 1
[    0.048001] initcall spawn_ksoftirqd+0x0/0x61 returned 0 after 0 usecs
[    0.048001] calling  init_call_single_data+0x0/0x57 @ 1
[    0.048001] initcall init_call_single_data+0x0/0x57 returned 0 after 
0 usecs
[    0.048001] Booting processor 1 APIC 0x1 ip 0x6000
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 5333.27 
BogoMIPS (lpj=10666545)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 4096K
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] CPU1: Thermal monitoring enabled (TM2)
[    0.132399] CPU1: Intel(R) Core(TM)2 CPU          6700  @ 2.66GHz 
stepping 06
[    0.132902] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.136016] Brought up 2 CPUs
[    0.136068] Total of 2 processors activated (10666.61 BogoMIPS).
[    0.136161] CPU0 attaching sched-domain:
[    0.136163]  domain 0: span 0-1 level MC
[    0.136165]   groups: 0 1
[    0.136168] CPU1 attaching sched-domain:
[    0.136169]  domain 0: span 0-1 level MC
[    0.136170]   groups: 1 0
[    0.136217] calling  init_cpufreq_transition_notifier_list+0x0/0x1b @ 1
[    0.136217] initcall init_cpufreq_transition_notifier_list+0x0/0x1b 
returned 0 after 0 usecs
[    0.136217] calling  net_ns_init+0x0/0x18d @ 1
[    0.136232] net_namespace: 912 bytes
[    0.136285] initcall net_ns_init+0x0/0x18d returned 0 after 0 usecs
[    0.136340] calling  cpufreq_tsc+0x0/0x42 @ 1
[    0.136392] initcall cpufreq_tsc+0x0/0x42 returned 0 after 0 usecs
[    0.136448] calling  init_smp_flush+0x0/0x51 @ 1
[    0.136501] initcall init_smp_flush+0x0/0x51 returned 0 after 0 usecs
[    0.136555] calling  sysctl_init+0x0/0x32 @ 1
[    0.136673] initcall sysctl_init+0x0/0x32 returned 0 after 0 usecs
[    0.136727] calling  ksysfs_init+0x0/0xbb @ 1
[    0.136782] initcall ksysfs_init+0x0/0xbb returned 0 after 0 usecs
[    0.136836] calling  init_jiffies_clocksource+0x0/0x12 @ 1
[    0.136891] initcall init_jiffies_clocksource+0x0/0x12 returned 0 
after 0 usecs
[    0.136969] calling  pm_init+0x0/0x38 @ 1
[    0.137024] initcall pm_init+0x0/0x38 returned 0 after 0 usecs
[    0.137078] calling  stop_machine_init+0x0/0x47 @ 1
[    0.137139] initcall stop_machine_init+0x0/0x47 returned 0 after 0 usecs
[    0.137139] calling  filelock_init+0x0/0x2e @ 1
[    0.137139] initcall filelock_init+0x0/0x2e returned 0 after 0 usecs
[    0.137139] calling  init_misc_binfmt+0x0/0x44 @ 1
[    0.137139] initcall init_misc_binfmt+0x0/0x44 returned 0 after 0 usecs
[    0.137139] calling  init_script_binfmt+0x0/0x12 @ 1
[    0.137139] initcall init_script_binfmt+0x0/0x12 returned 0 after 0 usecs
[    0.137139] calling  init_elf_binfmt+0x0/0x12 @ 1
[    0.137139] initcall init_elf_binfmt+0x0/0x12 returned 0 after 0 usecs
[    0.137139] calling  init_compat_elf_binfmt+0x0/0x12 @ 1
[    0.137139] initcall init_compat_elf_binfmt+0x0/0x12 returned 0 after 
0 usecs
[    0.137139] calling  debugfs_init+0x0/0x54 @ 1
[    0.137139] initcall debugfs_init+0x0/0x54 returned 0 after 0 usecs
[    0.137139] calling  random32_init+0x0/0xdb @ 1
[    0.137139] initcall random32_init+0x0/0xdb returned 0 after 0 usecs
[    0.137139] calling  cpufreq_core_init+0x0/0x84 @ 1
[    0.137139] initcall cpufreq_core_init+0x0/0x84 returned 0 after 0 usecs
[    0.137139] calling  cpuidle_init+0x0/0x43 @ 1
[    0.137139] initcall cpuidle_init+0x0/0x43 returned 0 after 0 usecs
[    0.137139] calling  sock_init+0x0/0x60 @ 1
[    0.137139] initcall sock_init+0x0/0x60 returned 0 after 0 usecs
[    0.137168] calling  netlink_proto_init+0x0/0x161 @ 1
[    0.137224] NET: Registered protocol family 16
[    0.137282] initcall netlink_proto_init+0x0/0x161 returned 0 after 0 
usecs
[    0.137337] calling  bdi_class_init+0x0/0x41 @ 1
[    0.137396] initcall bdi_class_init+0x0/0x41 returned 0 after 0 usecs
[    0.137396] calling  kobject_uevent_init+0x0/0x49 @ 1
[    0.140005] initcall kobject_uevent_init+0x0/0x49 returned 0 after 0 
usecs
[    0.140059] calling  pcibus_class_init+0x0/0x19 @ 1
[    0.140119] initcall pcibus_class_init+0x0/0x19 returned 0 after 0 usecs
[    0.140119] calling  pci_driver_init+0x0/0x19 @ 1
[    0.140119] initcall pci_driver_init+0x0/0x19 returned 0 after 0 usecs
[    0.140119] calling  tty_class_init+0x0/0x31 @ 1
[    0.140119] initcall tty_class_init+0x0/0x31 returned 0 after 0 usecs
[    0.140119] calling  vtconsole_class_init+0x0/0xcc @ 1
[    0.140119] initcall vtconsole_class_init+0x0/0xcc returned 0 after 0 
usecs
[    0.140119] calling  amd_postcore_init+0x0/0x8af @ 1
[    0.140119] initcall amd_postcore_init+0x0/0x8af returned 0 after 0 usecs
[    0.140168] calling  arch_kdebugfs_init+0x0/0x32 @ 1
[    0.140223] initcall arch_kdebugfs_init+0x0/0x32 returned 0 after 0 usecs
[    0.140774] calling  mtrr_if_init+0x0/0x9e @ 1
[    0.140827] initcall mtrr_if_init+0x0/0x9e returned 0 after 0 usecs
[    0.140882] calling  ffh_cstate_init+0x0/0x35 @ 1
[    0.140935] initcall ffh_cstate_init+0x0/0x35 returned 0 after 0 usecs
[    0.140989] calling  acpi_pci_init+0x0/0x5f @ 1
[    0.141042] ACPI: bus type pci registered
[    0.141094] initcall acpi_pci_init+0x0/0x5f returned 0 after 0 usecs
[    0.141149] calling  init_acpi_device_notify+0x0/0x4b @ 1
[    0.141202] initcall init_acpi_device_notify+0x0/0x4b returned 0 
after 0 usecs
[    0.141281] calling  pci_arch_init+0x0/0x53 @ 1
[    0.141350] PCI: MCFG configuration 0: base d0000000 segment 0 buses 
0 - 255
[    0.141405] PCI: MCFG area at d0000000 reserved in E820
[    0.146613] PCI: Using MMCONFIG at d0000000 - dfffffff
[    0.146666] PCI: Using configuration type 1 for base access
[    0.146722] initcall pci_arch_init+0x0/0x53 returned 0 after 3906 usecs
[    0.146777] calling  topology_init+0x0/0x35 @ 1
[    0.146835] initcall topology_init+0x0/0x35 returned 0 after 0 usecs
[    0.146835] calling  mtrr_init_finialize+0x0/0x40 @ 1
[    0.146835] initcall mtrr_init_finialize+0x0/0x40 returned 0 after 0 
usecs
[    0.146835] calling  param_sysfs_init+0x0/0x1eb @ 1
[    0.148021] initcall param_sysfs_init+0x0/0x1eb returned 0 after 3906 
usecs
[    0.148070] calling  pm_sysrq_init+0x0/0x20 @ 1
[    0.148123] initcall pm_sysrq_init+0x0/0x20 returned 0 after 0 usecs
[    0.148177] calling  readahead_init+0x0/0x3b @ 1
[    0.148242] initcall readahead_init+0x0/0x3b returned 0 after 0 usecs
[    0.148242] calling  init_bio+0x0/0xc8 @ 1
[    0.148242] initcall init_bio+0x0/0xc8 returned 0 after 0 usecs
[    0.148242] calling  cryptomgr_init+0x0/0x3a @ 1
[    0.148265] initcall cryptomgr_init+0x0/0x3a returned 0 after 0 usecs
[    0.148319] calling  blk_settings_init+0x0/0x2a @ 1
[    0.148373] initcall blk_settings_init+0x0/0x2a returned 0 after 0 usecs
[    0.148427] calling  blk_ioc_init+0x0/0x2a @ 1
[    0.148483] initcall blk_ioc_init+0x0/0x2a returned 0 after 0 usecs
[    0.148537] calling  blk_softirq_init+0x0/0x77 @ 1
[    0.148590] initcall blk_softirq_init+0x0/0x77 returned 0 after 0 usecs
[    0.148644] calling  genhd_device_init+0x0/0x69 @ 1
[    0.148730] initcall genhd_device_init+0x0/0x69 returned 0 after 0 usecs
[    0.148787] calling  pci_slot_init+0x0/0x50 @ 1
[    0.148841] initcall pci_slot_init+0x0/0x50 returned 0 after 0 usecs
[    0.148895] calling  acpi_init+0x0/0x239 @ 1
[    0.149369] ACPI: EC: Look up EC in DSDT
[    0.155438] ACPI: Interpreter enabled
[    0.155493] ACPI: (supports S0 S5)
[    0.155598] ACPI: Using IOAPIC for interrupt routing
[    0.155685] initcall acpi_init+0x0/0x239 returned 0 after 3906 usecs
[    0.155740] calling  acpi_scan_init+0x0/0x109 @ 1
[    0.156899] initcall acpi_scan_init+0x0/0x109 returned 0 after 3906 usecs
[    0.160003] calling  acpi_ec_init+0x0/0x61 @ 1
[    0.160072] initcall acpi_ec_init+0x0/0x61 returned 0 after 0 usecs
[    0.160072] calling  acpi_pci_root_init+0x0/0x28 @ 1
[    0.160117] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.160187] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.160187] pci 0000:00:01.0: PME# disabled
[    0.160203] pci 0000:00:1a.0: reg 20 io port: [0xc000-0xc01f]
[    0.160240] pci 0000:00:1a.1: reg 20 io port: [0xc400-0xc41f]
[    0.160277] pci 0000:00:1a.7: reg 10 32bit mmio: [0xf5205000-0xf52053ff]
[    0.160334] pci 0000:00:1b.0: reg 10 64bit mmio: [0xf5200000-0xf5203fff]
[    0.160356] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.160411] pci 0000:00:1b.0: PME# disabled
[    0.160497] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.160552] pci 0000:00:1c.0: PME# disabled
[    0.160640] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.160695] pci 0000:00:1c.3: PME# disabled
[    0.160782] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.160837] pci 0000:00:1c.4: PME# disabled
[    0.160923] pci 0000:00:1d.0: reg 20 io port: [0xc800-0xc81f]
[    0.160960] pci 0000:00:1d.1: reg 20 io port: [0xcc00-0xcc1f]
[    0.160996] pci 0000:00:1d.2: reg 20 io port: [0xd000-0xd01f]
[    0.161032] pci 0000:00:1d.7: reg 10 32bit mmio: [0xf5204000-0xf52043ff]
[    0.161150] pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 
ACPI/GPIO/TCO
[    0.161230] pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH6 
GPIO
[    0.161311] pci 0000:00:1f.2: reg 10 io port: [0x00-0x07]
[    0.161315] pci 0000:00:1f.2: reg 14 io port: [0x00-0x03]
[    0.161319] pci 0000:00:1f.2: reg 18 io port: [0x00-0x07]
[    0.161323] pci 0000:00:1f.2: reg 1c io port: [0x00-0x03]
[    0.161327] pci 0000:00:1f.2: reg 20 io port: [0xf000-0xf00f]
[    0.161331] pci 0000:00:1f.2: reg 24 io port: [0xfc00-0xfc0f]
[    0.161341] pci 0000:00:1f.2: PME# supported from D3hot
[    0.161395] pci 0000:00:1f.2: PME# disabled
[    0.161460] pci 0000:00:1f.3: reg 10 32bit mmio: [0xf5206000-0xf52060ff]
[    0.161474] pci 0000:00:1f.3: reg 20 io port: [0x500-0x51f]
[    0.161502] pci 0000:00:1f.5: reg 10 io port: [0xd800-0xd807]
[    0.161506] pci 0000:00:1f.5: reg 14 io port: [0xdc00-0xdc03]
[    0.161510] pci 0000:00:1f.5: reg 18 io port: [0xe000-0xe007]
[    0.161514] pci 0000:00:1f.5: reg 1c io port: [0xe400-0xe403]
[    0.161518] pci 0000:00:1f.5: reg 20 io port: [0xe800-0xe80f]
[    0.161522] pci 0000:00:1f.5: reg 24 io port: [0xec00-0xec0f]
[    0.161532] pci 0000:00:1f.5: PME# supported from D3hot
[    0.161586] pci 0000:00:1f.5: PME# disabled
[    0.161662] pci 0000:01:00.0: reg 10 32bit mmio: [0xf0000000-0xf0ffffff]
[    0.161668] pci 0000:01:00.0: reg 14 64bit mmio: [0xe0000000-0xefffffff]
[    0.161674] pci 0000:01:00.0: reg 1c 64bit mmio: [0xf1000000-0xf1ffffff]
[    0.161678] pci 0000:01:00.0: reg 24 io port: [0x8000-0x807f]
[    0.161682] pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    0.161717] pci 0000:00:01.0: bridge io port: [0x8000-0x8fff]
[    0.161719] pci 0000:00:01.0: bridge 32bit mmio: [0xf0000000-0xf2ffffff]
[    0.161722] pci 0000:00:01.0: bridge 64bit mmio pref: 
[0xe0000000-0xefffffff]
[    0.161752] pci 0000:00:1c.0: bridge io port: [0x7000-0x7fff]
[    0.161836] pci 0000:03:00.0: reg 24 32bit mmio: [0xf5000000-0xf5001fff]
[    0.161853] pci 0000:03:00.0: PME# supported from D3hot
[    0.161908] pci 0000:03:00.0: PME# disabled
[    0.162004] pci 0000:03:00.1: reg 10 io port: [0x9000-0x9007]
[    0.162012] pci 0000:03:00.1: reg 14 io port: [0x9400-0x9403]
[    0.162019] pci 0000:03:00.1: reg 18 io port: [0x9800-0x9807]
[    0.162026] pci 0000:03:00.1: reg 1c io port: [0x9c00-0x9c03]
[    0.162034] pci 0000:03:00.1: reg 20 io port: [0xa000-0xa00f]
[    0.162098] pci 0000:00:1c.3: bridge io port: [0x9000-0xafff]
[    0.162100] pci 0000:00:1c.3: bridge 32bit mmio: [0xf5000000-0xf50fffff]
[    0.162153] pci 0000:04:00.0: reg 10 64bit mmio: [0xf4000000-0xf4003fff]
[    0.162160] pci 0000:04:00.0: reg 18 io port: [0xb000-0xb0ff]
[    0.162182] pci 0000:04:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    0.162192] pci 0000:04:00.0: supports D1 D2
[    0.162193] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.162250] pci 0000:04:00.0: PME# disabled
[    0.162333] pci 0000:00:1c.4: bridge io port: [0xb000-0xbfff]
[    0.162336] pci 0000:00:1c.4: bridge 32bit mmio: [0xf3000000-0xf4ffffff]
[    0.162358] pci 0000:05:01.0: reg 10 32bit mmio: [0xf5100000-0xf5101fff]
[    0.162416] pci 0000:00:1e.0: transparent bridge
[    0.162471] pci 0000:00:1e.0: bridge 32bit mmio: [0xf5100000-0xf51fffff]
[    0.162491] bus 00 -> node 0
[    0.162495] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.162704] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    0.162780] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
[    0.162857] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
[    0.162931] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
[    0.172333] initcall acpi_pci_root_init+0x0/0x28 returned 0 after 
11718 usecs
[    0.172333] calling  acpi_pci_link_init+0x0/0x63 @ 1
[    0.172333] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 *10 11 
12 14 15)
[    0.172657] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11 
12 14 15) *0, disabled.
[    0.173180] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *9 10 11 
12 14 15)
[    0.173653] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11 
12 14 15)
[    0.174127] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 
12 14 15) *0, disabled.
[    0.174649] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 *6 7 9 10 11 
12 14 15)
[    0.175123] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 *5 6 7 9 10 11 
12 14 15)
[    0.176273] ACPI: PCI Interrupt Link [LNK1] (IRQs *3 4 5 6 7 9 10 11 
12 14 15)
[    0.176707] initcall acpi_pci_link_init+0x0/0x63 returned 0 after 
3906 usecs
[    0.176707] calling  acpi_power_init+0x0/0x77 @ 1
[    0.176707] initcall acpi_power_init+0x0/0x77 returned 0 after 0 usecs
[    0.176707] calling  acpi_system_init+0x0/0x1ba @ 1
[    0.176707] initcall acpi_system_init+0x0/0x1ba returned 0 after 0 usecs
[    0.176707] calling  pnp_init+0x0/0x12 @ 1
[    0.176707] initcall pnp_init+0x0/0x12 returned 0 after 0 usecs
[    0.176707] calling  misc_init+0x0/0xa4 @ 1
[    0.176707] initcall misc_init+0x0/0xa4 returned 0 after 0 usecs
[    0.176707] calling  init_scsi+0x0/0x89 @ 1
[    0.176707] SCSI subsystem initialized
[    0.176707] initcall init_scsi+0x0/0x89 returned 0 after 0 usecs
[    0.176707] calling  ata_init+0x0/0x3f6 @ 1
[    0.176707] libata version 3.00 loaded.
[    0.176707] initcall ata_init+0x0/0x3f6 returned 0 after 0 usecs
[    0.176707] calling  usb_init+0x0/0x135 @ 1
[    0.176707] usbcore: registered new interface driver usbfs
[    0.176707] usbcore: registered new interface driver hub
[    0.176707] usbcore: registered new device driver usb
[    0.176707] initcall usb_init+0x0/0x135 returned 0 after 0 usecs
[    0.176707] calling  serio_init+0x0/0xa0 @ 1
[    0.176707] initcall serio_init+0x0/0xa0 returned 0 after 0 usecs
[    0.176707] calling  input_init+0x0/0x119 @ 1
[    0.176707] initcall input_init+0x0/0x119 returned 0 after 0 usecs
[    0.176707] calling  power_supply_class_init+0x0/0x38 @ 1
[    0.176707] initcall power_supply_class_init+0x0/0x38 returned 0 
after 0 usecs
[    0.176707] calling  thermal_init+0x0/0x43 @ 1
[    0.176707] initcall thermal_init+0x0/0x43 returned 0 after 0 usecs
[    0.176707] calling  md_init+0x0/0xdc @ 1
[    0.176707] initcall md_init+0x0/0xdc returned 0 after 0 usecs
[    0.176707] calling  leds_init+0x0/0x31 @ 1
[    0.176707] initcall leds_init+0x0/0x31 returned 0 after 0 usecs
[    0.176707] calling  pci_subsys_init+0x0/0x130 @ 1
[    0.176707] PCI: Using ACPI for IRQ routing
[    0.176707] initcall pci_subsys_init+0x0/0x130 returned 0 after 0 usecs
[    0.176707] calling  proto_init+0x0/0x2e @ 1
[    0.176707] initcall proto_init+0x0/0x2e returned 0 after 0 usecs
[    0.176707] calling  net_dev_init+0x0/0x14d @ 1
[    0.176707] initcall net_dev_init+0x0/0x14d returned 0 after 0 usecs
[    0.176707] calling  neigh_init+0x0/0x71 @ 1
[    0.176707] initcall neigh_init+0x0/0x71 returned 0 after 0 usecs
[    0.176707] calling  genl_init+0x0/0xea @ 1
[    0.196009] initcall genl_init+0x0/0xea returned 0 after 19531 usecs
[    0.196067] calling  wireless_nlevent_init+0x0/0x31 @ 1
[    0.196124] initcall wireless_nlevent_init+0x0/0x31 returned 0 after 
0 usecs
[    0.196183] calling  cfg80211_init+0x0/0x90 @ 1
[    0.208033] cfg80211: Calling CRDA to update world regulatory domain
[    0.208083] cfg80211: Failed calling CRDA
[    0.208083] cfg80211: calling CRDA failed - unable to update world 
regulatory domain, using static definition
[    0.208165] initcall cfg80211_init+0x0/0x90 returned 0 after 11718 usecs
[    0.208220] calling  sysctl_init+0x0/0x4d @ 1
[    0.208273] initcall sysctl_init+0x0/0x4d returned 0 after 0 usecs
[    0.208327] calling  pci_iommu_init+0x0/0x12 @ 1
[    0.208392] initcall pci_iommu_init+0x0/0x12 returned 0 after 0 usecs
[    0.208447] calling  print_all_ICs+0x0/0x53b @ 1
[    0.208501] initcall print_all_ICs+0x0/0x53b returned 0 after 0 usecs
[    0.208556] calling  hpet_late_init+0x0/0x1c2 @ 1
[    0.208610] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.208759] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.212009] initcall hpet_late_init+0x0/0x1c2 returned 0 after 3906 usecs
[    0.212063] calling  clocksource_done_booting+0x0/0x12 @ 1
[    0.212120] initcall clocksource_done_booting+0x0/0x12 returned 0 
after 0 usecs
[    0.212203] calling  init_pipe_fs+0x0/0x51 @ 1
[    0.212270] initcall init_pipe_fs+0x0/0x51 returned 0 after 0 usecs
[    0.212325] calling  init_mnt_writers+0x0/0x57 @ 1
[    0.212378] initcall init_mnt_writers+0x0/0x57 returned 0 after 0 usecs
[    0.212432] calling  eventpoll_init+0x0/0xbc @ 1
[    0.212493] initcall eventpoll_init+0x0/0xbc returned 0 after 0 usecs
[    0.212548] calling  anon_inode_init+0x0/0x126 @ 1
[    0.212603] initcall anon_inode_init+0x0/0x126 returned 0 after 0 usecs
[    0.212658] calling  acpi_event_init+0x0/0x5a @ 1
[    0.228129] initcall acpi_event_init+0x0/0x5a returned 0 after 15748 
usecs
[    0.228187] calling  pnpacpi_init+0x0/0x8e @ 1
[    0.228242] pnp: PnP ACPI init
[    0.228303] ACPI: bus type pnp registered
[    0.230828] pnp: PnP ACPI: found 14 devices
[    0.230881] ACPI: ACPI bus type pnp unregistered
[    0.230934] initcall pnpacpi_init+0x0/0x8e returned 0 after 2628 usecs
[    0.230989] calling  pnp_system_init+0x0/0x13 @ 1
[    0.231047] system 00:01: ioport range 0x4d0-0x4d1 has been reserved
[    0.231101] system 00:01: ioport range 0x290-0x29f has been reserved
[    0.231155] system 00:01: ioport range 0x800-0x87f has been reserved
[    0.231209] system 00:01: ioport range 0x290-0x294 has been reserved
[    0.231264] system 00:01: ioport range 0x880-0x88f has been reserved
[    0.231322] system 00:0a: ioport range 0x400-0x4bf could not be reserved
[    0.231379] system 00:0b: iomem range 0xd0000000-0xdfffffff has been 
reserved
[    0.231436] system 00:0c: iomem range 0xce000-0xcffff has been reserved
[    0.231986] system 00:0c: iomem range 0xf0000-0xf7fff could not be 
reserved
[    0.232041] system 00:0c: iomem range 0xf8000-0xfbfff could not be 
reserved
[    0.232096] system 00:0c: iomem range 0xfc000-0xfffff could not be 
reserved
[    0.232156] system 00:0c: iomem range 0xcfee0000-0xcfefffff could not 
be reserved
[    0.232235] system 00:0c: iomem range 0x0-0x9ffff could not be reserved
[    0.232290] system 00:0c: iomem range 0x100000-0xcfedffff could not 
be reserved
[    0.232369] system 00:0c: iomem range 0xfec00000-0xfec00fff has been 
reserved
[    0.232424] system 00:0c: iomem range 0xfed10000-0xfed1dfff has been 
reserved
[    0.232479] system 00:0c: iomem range 0xfed20000-0xfed8ffff has been 
reserved
[    0.232533] system 00:0c: iomem range 0xfee00000-0xfee00fff has been 
reserved
[    0.232588] system 00:0c: iomem range 0xffb00000-0xffb7ffff has been 
reserved
[    0.232643] system 00:0c: iomem range 0xfff00000-0xffffffff has been 
reserved
[    0.232698] system 00:0c: iomem range 0xe0000-0xeffff has been reserved
[    0.232775] initcall pnp_system_init+0x0/0x13 returned 0 after 1691 usecs
[    0.232829] calling  chr_dev_init+0x0/0xa3 @ 1
[    0.233119] initcall chr_dev_init+0x0/0xa3 returned 0 after 230 usecs
[    0.233174] calling  firmware_class_init+0x0/0x87 @ 1
[    0.233247] initcall firmware_class_init+0x0/0x87 returned 0 after 18 
usecs
[    0.233302] calling  loopback_init+0x0/0x12 @ 1
[    0.233404] initcall loopback_init+0x0/0x12 returned 0 after 47 usecs
[    0.233459] calling  cpufreq_gov_performance_init+0x0/0x12 @ 1
[    0.233513] initcall cpufreq_gov_performance_init+0x0/0x12 returned 0 
after 0 usecs
[    0.233593] calling  cpufreq_gov_dbs_init+0x0/0x91 @ 1
[    0.233673] initcall cpufreq_gov_dbs_init+0x0/0x91 returned 0 after 
24 usecs
[    0.233728] calling  init_acpi_pm_clocksource+0x0/0x105 @ 1
[    0.238261] initcall init_acpi_pm_clocksource+0x0/0x105 returned 0 
after 4379 usecs
[    0.238340] calling  pcibios_assign_resources+0x0/0x8a @ 1
[    0.238417] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.238471] pci 0000:00:01.0:   IO window: 0x8000-0x8fff
[    0.238525] pci 0000:00:01.0:   MEM window: 0xf0000000-0xf2ffffff
[    0.238580] pci 0000:00:01.0:   PREFETCH window: 
0x000000e0000000-0x000000efffffff
[    0.238661] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
[    0.238715] pci 0000:00:1c.0:   IO window: 0x7000-0x7fff
[    0.238770] pci 0000:00:1c.0:   MEM window: disabled
[    0.238824] pci 0000:00:1c.0:   PREFETCH window: disabled
[    0.238880] pci 0000:00:1c.3: PCI bridge, secondary bus 0000:03
[    0.238934] pci 0000:00:1c.3:   IO window: 0x9000-0xafff
[    0.238989] pci 0000:00:1c.3:   MEM window: 0xf5000000-0xf50fffff
[    0.239044] pci 0000:00:1c.3:   PREFETCH window: disabled
[    0.239100] pci 0000:00:1c.4: PCI bridge, secondary bus 0000:04
[    0.239155] pci 0000:00:1c.4:   IO window: 0xb000-0xbfff
[    0.239210] pci 0000:00:1c.4:   MEM window: 0xf3000000-0xf4ffffff
[    0.239265] pci 0000:00:1c.4:   PREFETCH window: 
0x000000f5300000-0x000000f53fffff
[    0.239347] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:05
[    0.239400] pci 0000:00:1e.0:   IO window: disabled
[    0.239455] pci 0000:00:1e.0:   MEM window: 0xf5100000-0xf51fffff
[    0.239510] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.239570] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.239626] pci 0000:00:01.0: setting latency timer to 64
[    0.239631] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.239686] pci 0000:00:1c.0: setting latency timer to 64
[    0.239692] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.239748] pci 0000:00:1c.3: setting latency timer to 64
[    0.239752] pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.239808] pci 0000:00:1c.4: setting latency timer to 64
[    0.239813] pci 0000:00:1e.0: setting latency timer to 64
[    0.239815] bus: 00 index 0 io port: [0x00-0xffff]
[    0.239868] bus: 00 index 1 mmio: [0x000000-0xffffffffffffffff]
[    0.239921] bus: 01 index 0 io port: [0x8000-0x8fff]
[    0.239974] bus: 01 index 1 mmio: [0xf0000000-0xf2ffffff]
[    0.240027] bus: 01 index 2 mmio: [0xe0000000-0xefffffff]
[    0.240080] bus: 01 index 3 mmio: [0x0-0x0]
[    0.240153] bus: 02 index 0 io port: [0x7000-0x7fff]
[    0.240206] bus: 02 index 1 mmio: [0x0-0x0]
[    0.240257] bus: 02 index 2 mmio: [0x0-0x0]
[    0.240309] bus: 02 index 3 mmio: [0x0-0x0]
[    0.240361] bus: 03 index 0 io port: [0x9000-0xafff]
[    0.240414] bus: 03 index 1 mmio: [0xf5000000-0xf50fffff]
[    0.240467] bus: 03 index 2 mmio: [0x0-0x0]
[    0.240518] bus: 03 index 3 mmio: [0x0-0x0]
[    0.240571] bus: 04 index 0 io port: [0xb000-0xbfff]
[    0.240623] bus: 04 index 1 mmio: [0xf3000000-0xf4ffffff]
[    0.240676] bus: 04 index 2 mmio: [0xf5300000-0xf53fffff]
[    0.240729] bus: 04 index 3 mmio: [0x0-0x0]
[    0.240781] bus: 05 index 0 mmio: [0x0-0x0]
[    0.240833] bus: 05 index 1 mmio: [0xf5100000-0xf51fffff]
[    0.240886] bus: 05 index 2 mmio: [0x0-0x0]
[    0.240938] bus: 05 index 3 io port: [0x00-0xffff]
[    0.240990] bus: 05 index 4 mmio: [0x000000-0xffffffffffffffff]
[    0.241045] initcall pcibios_assign_resources+0x0/0x8a returned 0 
after 2584 usecs
[    0.241124] calling  inet_init+0x0/0x258 @ 1
[    0.241195] NET: Registered protocol family 2
[    0.280571] IP route cache hash table entries: 131072 (order: 8, 
1048576 bytes)
[    0.280973] TCP established hash table entries: 262144 (order: 10, 
4194304 bytes)
[    0.282183] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.282593] TCP: Hash tables configured (established 262144 bind 65536)
[    0.282648] TCP reno registered
[    0.292693] initcall inet_init+0x0/0x258 returned 0 after 50300 usecs
[    0.292754] calling  af_unix_init+0x0/0x58 @ 1
[    0.292816] NET: Registered protocol family 1
[    0.292887] initcall af_unix_init+0x0/0x58 returned 0 after 75 usecs
[    0.292942] calling  populate_rootfs+0x0/0x131 @ 1
[    0.293068] checking if image is initramfs... it is
[    0.501607] Switched to high resolution mode on CPU 1
[    0.504610] Switched to high resolution mode on CPU 0
[    0.564122] Freeing initrd memory: 4184k freed
[    0.565043] initcall populate_rootfs+0x0/0x131 returned 0 after 
265669 usecs
[    0.565100] calling  i8259A_init_sysfs+0x0/0x29 @ 1
[    0.565256] initcall i8259A_init_sysfs+0x0/0x29 returned 0 after 96 usecs
[    0.565313] calling  vsyscall_init+0x0/0x6c @ 1
[    0.565382] initcall vsyscall_init+0x0/0x6c returned 0 after 15 usecs
[    0.565436] calling  sbf_init+0x0/0x100 @ 1
[    0.565488] initcall sbf_init+0x0/0x100 returned 0 after 0 usecs
[    0.565543] calling  i8237A_init_sysfs+0x0/0x29 @ 1
[    0.565636] initcall i8237A_init_sysfs+0x0/0x29 returned 0 after 37 usecs
[    0.565691] calling  add_rtc_cmos+0x0/0xce @ 1
[    0.565747] initcall add_rtc_cmos+0x0/0xce returned 0 after 2 usecs
[    0.565802] calling  cache_sysfs_init+0x0/0x5b @ 1
[    0.566051] initcall cache_sysfs_init+0x0/0x5b returned 0 after 190 usecs
[    0.566107] calling  mce_init_device+0x0/0x81 @ 1
[    0.566254] initcall mce_init_device+0x0/0x81 returned 0 after 91 usecs
[    0.566309] calling  periodic_mcheck_init+0x0/0x3f @ 1
[    0.566364] initcall periodic_mcheck_init+0x0/0x3f returned 0 after 1 
usecs
[    0.566419] calling  thermal_throttle_init_device+0x0/0x8e @ 1
[    0.566476] initcall thermal_throttle_init_device+0x0/0x8e returned 0 
after 2 usecs
[    0.566557] calling  msr_init+0x0/0x120 @ 1
[    0.566680] initcall msr_init+0x0/0x120 returned 0 after 68 usecs
[    0.566735] calling  cpuid_init+0x0/0x120 @ 1
[    0.566853] initcall cpuid_init+0x0/0x120 returned 0 after 64 usecs
[    0.566908] calling  init_lapic_sysfs+0x0/0x41 @ 1
[    0.566999] initcall init_lapic_sysfs+0x0/0x41 returned 0 after 36 usecs
[    0.567054] calling  ioapic_init_sysfs+0x0/0xcf @ 1
[    0.567145] initcall ioapic_init_sysfs+0x0/0xcf returned 0 after 36 usecs
[    0.567200] calling  add_pcspkr+0x0/0x2a @ 1
[    0.567280] initcall add_pcspkr+0x0/0x2a returned 0 after 26 usecs
[    0.567334] calling  uv_ptc_init+0x0/0x77 @ 1
[    0.567387] initcall uv_ptc_init+0x0/0x77 returned 0 after 0 usecs
[    0.567441] calling  uv_bau_init+0x0/0x486 @ 1
[    0.567494] initcall uv_bau_init+0x0/0x486 returned 0 after 0 usecs
[    0.567548] calling  sgi_uv_sysfs_init+0x0/0xa0 @ 1
[    0.567603] initcall sgi_uv_sysfs_init+0x0/0xa0 returned 0 after 2 usecs
[    0.567658] calling  init_vdso_vars+0x0/0x240 @ 1
[    0.567720] initcall init_vdso_vars+0x0/0x240 returned 0 after 9 usecs
[    0.567774] calling  ia32_binfmt_init+0x0/0x14 @ 1
[    0.567831] initcall ia32_binfmt_init+0x0/0x14 returned 0 after 3 usecs
[    0.567885] calling  sysenter_setup+0x0/0x35f @ 1
[    0.567941] initcall sysenter_setup+0x0/0x35f returned 0 after 2 usecs
[    0.567995] calling  init_aout_binfmt+0x0/0x13 @ 1
[    0.568049] initcall init_aout_binfmt+0x0/0x13 returned 0 after 0 usecs
[    0.568104] calling  init_sched_debug_procfs+0x0/0x2c @ 1
[    0.568167] initcall init_sched_debug_procfs+0x0/0x2c returned 0 
after 9 usecs
[    0.568246] calling  proc_schedstat_init+0x0/0x22 @ 1
[    0.568299] initcall proc_schedstat_init+0x0/0x22 returned 0 after 0 
usecs
[    0.568354] calling  proc_execdomains_init+0x0/0x2a @ 1
[    0.568408] initcall proc_execdomains_init+0x0/0x2a returned 0 after 
0 usecs
[    0.568463] calling  ioresources_init+0x0/0x3c @ 1
[    0.568517] initcall ioresources_init+0x0/0x3c returned 0 after 1 usecs
[    0.568571] calling  uid_cache_init+0x0/0x88 @ 1
[    0.568637] initcall uid_cache_init+0x0/0x88 returned 0 after 12 usecs
[    0.568691] calling  init_posix_timers+0x0/0xe8 @ 1
[    0.568749] initcall init_posix_timers+0x0/0xe8 returned 0 after 4 usecs
[    0.568804] calling  init_posix_cpu_timers+0x0/0xb3 @ 1
[    0.568857] initcall init_posix_cpu_timers+0x0/0xb3 returned 0 after 
0 usecs
[    0.568912] calling  nsproxy_cache_init+0x0/0x31 @ 1
[    0.568968] initcall nsproxy_cache_init+0x0/0x31 returned 0 after 3 usecs
[    0.569035] calling  timekeeping_init_device+0x0/0x29 @ 1
[    0.569136] initcall timekeeping_init_device+0x0/0x29 returned 0 
after 45 usecs
[    0.569216] calling  init_clocksource_sysfs+0x0/0x52 @ 1
[    0.569313] initcall init_clocksource_sysfs+0x0/0x52 returned 0 after 
42 usecs
[    0.569392] calling  init_timer_list_procfs+0x0/0x2c @ 1
[    0.569447] initcall init_timer_list_procfs+0x0/0x2c returned 0 after 
1 usecs
[    0.569502] calling  futex_init+0x0/0xad @ 1
[    0.569560] initcall futex_init+0x0/0xad returned 0 after 5 usecs
[    0.569614] calling  proc_dma_init+0x0/0x22 @ 1
[    0.569668] initcall proc_dma_init+0x0/0x22 returned 0 after 0 usecs
[    0.569722] calling  proc_modules_init+0x0/0x22 @ 1
[    0.569776] initcall proc_modules_init+0x0/0x22 returned 0 after 0 usecs
[    0.569831] calling  percpu_modinit+0x0/0x80 @ 1
[    0.569884] initcall percpu_modinit+0x0/0x80 returned 0 after 0 usecs
[    0.569938] calling  kallsyms_init+0x0/0x25 @ 1
[    0.569992] initcall kallsyms_init+0x0/0x25 returned 0 after 0 usecs
[    0.570046] calling  ikconfig_init+0x0/0x39 @ 1
[    0.570099] initcall ikconfig_init+0x0/0x39 returned 0 after 0 usecs
[    0.570154] calling  utsname_sysctl_init+0x0/0x14 @ 1
[    0.570712] initcall utsname_sysctl_init+0x0/0x14 returned 0 after 9 
usecs
[    0.570767] calling  init_lstats_procfs+0x0/0x2b @ 1
[    0.570821] initcall init_lstats_procfs+0x0/0x2b returned 0 after 0 usecs
[    0.570876] calling  init_per_zone_pages_min+0x0/0x58 @ 1
[    0.571030] initcall init_per_zone_pages_min+0x0/0x58 returned 0 
after 98 usecs
[    0.571109] calling  pdflush_init+0x0/0x12 @ 1
[    0.571199] initcall pdflush_init+0x0/0x12 returned 0 after 31 usecs
[    0.571253] calling  kswapd_init+0x0/0x20 @ 1
[    0.571320] initcall kswapd_init+0x0/0x20 returned 0 after 13 usecs
[    0.571374] calling  setup_vmstat+0x0/0xbd @ 1
[    0.571432] initcall setup_vmstat+0x0/0xbd returned 0 after 4 usecs
[    0.571486] calling  mm_sysfs_init+0x0/0x29 @ 1
[    0.571541] initcall mm_sysfs_init+0x0/0x29 returned 0 after 1 usecs
[    0.571595] calling  proc_vmalloc_init+0x0/0x25 @ 1
[    0.571650] initcall proc_vmalloc_init+0x0/0x25 returned 0 after 1 usecs
[    0.571704] calling  procswaps_init+0x0/0x31 @ 1
[    0.571758] initcall procswaps_init+0x0/0x31 returned 0 after 0 usecs
[    0.571812] calling  init_tmpfs+0x0/0xda @ 1
[    0.571881] initcall init_tmpfs+0x0/0xda returned 0 after 15 usecs
[    0.571936] calling  slab_proc_init+0x0/0x25 @ 1
[    0.571989] initcall slab_proc_init+0x0/0x25 returned 0 after 0 usecs
[    0.572044] calling  cpucache_init+0x0/0x35 @ 1
[    0.572097] initcall cpucache_init+0x0/0x35 returned 0 after 0 usecs
[    0.572152] calling  fasync_init+0x0/0x2e @ 1
[    0.572208] initcall fasync_init+0x0/0x2e returned 0 after 3 usecs
[    0.572262] calling  proc_filesystems_init+0x0/0x22 @ 1
[    0.572317] initcall proc_filesystems_init+0x0/0x22 returned 0 after 
0 usecs
[    0.572372] calling  inotify_setup+0x0/0x12 @ 1
[    0.572424] initcall inotify_setup+0x0/0x12 returned 0 after 0 usecs
[    0.572479] calling  inotify_user_setup+0x0/0xbc @ 1
[    0.572545] initcall inotify_user_setup+0x0/0xbc returned 0 after 12 
usecs
[    0.572600] calling  aio_setup+0x0/0x71 @ 1
[    0.572689] initcall aio_setup+0x0/0x71 returned 0 after 31 usecs
[    0.572743] calling  proc_locks_init+0x0/0x22 @ 1
[    0.572797] initcall proc_locks_init+0x0/0x22 returned 0 after 0 usecs
[    0.572852] calling  init_sys32_ioctl+0x0/0x87 @ 1
[    0.572915] initcall init_sys32_ioctl+0x0/0x87 returned 0 after 10 usecs
[    0.572970] calling  init_mbcache+0x0/0x14 @ 1
[    0.573026] initcall init_mbcache+0x0/0x14 returned 0 after 0 usecs
[    0.573081] calling  dnotify_init+0x0/0x38 @ 1
[    0.573137] initcall dnotify_init+0x0/0x38 returned 0 after 3 usecs
[    0.573192] calling  proc_cmdline_init+0x0/0x22 @ 1
[    0.573247] initcall proc_cmdline_init+0x0/0x22 returned 0 after 1 usecs
[    0.573301] calling  proc_cpuinfo_init+0x0/0x22 @ 1
[    0.573355] initcall proc_cpuinfo_init+0x0/0x22 returned 0 after 0 usecs
[    0.573410] calling  proc_devices_init+0x0/0x22 @ 1
[    0.573464] initcall proc_devices_init+0x0/0x22 returned 0 after 0 usecs
[    0.573519] calling  proc_interrupts_init+0x0/0x22 @ 1
[    0.573573] initcall proc_interrupts_init+0x0/0x22 returned 0 after 0 
usecs
[    0.573628] calling  proc_loadavg_init+0x0/0x22 @ 1
[    0.573682] initcall proc_loadavg_init+0x0/0x22 returned 0 after 0 usecs
[    0.573737] calling  proc_meminfo_init+0x0/0x22 @ 1
[    0.573791] initcall proc_meminfo_init+0x0/0x22 returned 0 after 0 usecs
[    0.573845] calling  proc_stat_init+0x0/0x22 @ 1
[    0.573899] initcall proc_stat_init+0x0/0x22 returned 0 after 0 usecs
[    0.573954] calling  proc_uptime_init+0x0/0x2d @ 1
[    0.574008] initcall proc_uptime_init+0x0/0x2d returned 0 after 0 usecs
[    0.574062] calling  proc_version_init+0x0/0x22 @ 1
[    0.574116] initcall proc_version_init+0x0/0x22 returned 0 after 0 usecs
[    0.574171] calling  proc_kcore_init+0x0/0x49 @ 1
[    0.574225] initcall proc_kcore_init+0x0/0x49 returned 0 after 0 usecs
[    0.574279] calling  proc_kmsg_init+0x0/0x25 @ 1
[    0.574333] initcall proc_kmsg_init+0x0/0x25 returned 0 after 0 usecs
[    0.574387] calling  proc_page_init+0x0/0x42 @ 1
[    0.574442] initcall proc_page_init+0x0/0x42 returned 0 after 1 usecs
[    0.574496] calling  configfs_init+0x0/0xd6 @ 1
[    0.574556] initcall configfs_init+0x0/0xd6 returned 0 after 6 usecs
[    0.574610] calling  init_devpts_fs+0x0/0x42 @ 1
[    0.574669] initcall init_devpts_fs+0x0/0x42 returned 0 after 5 usecs
[    0.574723] calling  init_ext3_fs+0x0/0x72 @ 1
[    0.574786] initcall init_ext3_fs+0x0/0x72 returned 0 after 9 usecs
[    0.574840] calling  init_ext4_fs+0x0/0x9a @ 1
[    0.574913] initcall init_ext4_fs+0x0/0x9a returned 0 after 19 usecs
[    0.574967] calling  journal_init+0x0/0xa7 @ 1
[    0.575035] initcall journal_init+0x0/0xa7 returned 0 after 15 usecs
[    0.575090] calling  journal_init+0x0/0xbc @ 1
[    0.575158] initcall journal_init+0x0/0xbc returned 0 after 15 usecs
[    0.575212] calling  init_ext2_fs+0x0/0x72 @ 1
[    0.575273] initcall init_ext2_fs+0x0/0x72 returned 0 after 8 usecs
[    0.575327] calling  init_ramfs_fs+0x0/0x12 @ 1
[    0.575380] initcall init_ramfs_fs+0x0/0x12 returned 0 after 0 usecs
[    0.575434] calling  init_fat_fs+0x0/0x54 @ 1
[    0.575493] initcall init_fat_fs+0x0/0x54 returned 0 after 6 usecs
[    0.575547] calling  init_vfat_fs+0x0/0x12 @ 1
[    0.575600] initcall init_vfat_fs+0x0/0x12 returned 0 after 0 usecs
[    0.575654] calling  init_msdos_fs+0x0/0x12 @ 1
[    0.575708] initcall init_msdos_fs+0x0/0x12 returned 0 after 0 usecs
[    0.575762] calling  init_iso9660_fs+0x0/0x66 @ 1
[    0.575820] initcall init_iso9660_fs+0x0/0x66 returned 0 after 5 usecs
[    0.575874] calling  init_nfs_fs+0x0/0x150 @ 1
[    0.575986] initcall init_nfs_fs+0x0/0x150 returned 0 after 50 usecs
[    0.576040] calling  init_nlm+0x0/0x22 @ 1
[    0.576102] initcall init_nlm+0x0/0x22 returned 0 after 9 usecs
[    0.576156] calling  init_nls_cp437+0x0/0x12 @ 1
[    0.576209] initcall init_nls_cp437+0x0/0x12 returned 0 after 0 usecs
[    0.576263] calling  init_nls_ascii+0x0/0x12 @ 1
[    0.576315] initcall init_nls_ascii+0x0/0x12 returned 0 after 0 usecs
[    0.576369] calling  init_nls_iso8859_1+0x0/0x12 @ 1
[    0.576422] initcall init_nls_iso8859_1+0x0/0x12 returned 0 after 0 usecs
[    0.576477] calling  init_nls_iso8859_15+0x0/0x12 @ 1
[    0.576530] initcall init_nls_iso8859_15+0x0/0x12 returned 0 after 0 
usecs
[    0.576585] calling  init_nls_utf8+0x0/0x25 @ 1
[    0.576638] initcall init_nls_utf8+0x0/0x25 returned 0 after 0 usecs
[    0.576692] calling  init_ntfs_fs+0x0/0x247 @ 1
[    0.576744] NTFS driver 2.1.29 [Flags: R/W DEBUG].
[    0.576822] initcall init_ntfs_fs+0x0/0x247 returned 0 after 75 usecs
[    0.576877] calling  init_autofs4_fs+0x0/0x29 @ 1
[    0.576964] initcall init_autofs4_fs+0x0/0x29 returned 0 after 31 usecs
[    0.577039] calling  ipc_init+0x0/0x23 @ 1
[    0.577094] msgmni has been set to 7897
[    0.577148] initcall ipc_init+0x0/0x23 returned 0 after 56 usecs
[    0.577202] calling  ipc_sysctl_init+0x0/0x18 @ 1
[    0.577271] initcall ipc_sysctl_init+0x0/0x18 returned 0 after 16 usecs
[    0.577326] calling  crypto_algapi_init+0x0/0xd @ 1
[    0.577380] initcall crypto_algapi_init+0x0/0xd returned 0 after 1 usecs
[    0.577434] calling  chainiv_module_init+0x0/0x12 @ 1
[    0.577488] initcall chainiv_module_init+0x0/0x12 returned 0 after 0 
usecs
[    0.577543] calling  eseqiv_module_init+0x0/0x21 @ 1
[    0.577596] initcall eseqiv_module_init+0x0/0x21 returned 0 after 0 usecs
[    0.577651] calling  crypto_ecb_module_init+0x0/0x12 @ 1
[    0.577704] initcall crypto_ecb_module_init+0x0/0x12 returned 0 after 
0 usecs
[    0.577759] calling  aes_init+0x0/0x2f3 @ 1
[    0.577861] initcall aes_init+0x0/0x2f3 returned 0 after 46 usecs
[    0.577916] calling  arc4_init+0x0/0x12 @ 1
[    0.578004] initcall arc4_init+0x0/0x12 returned 0 after 34 usecs
[    0.578058] calling  krng_mod_init+0x0/0x1e @ 1
[    0.578124] alg: No test for stdrng (krng)
[    0.578180] initcall krng_mod_init+0x0/0x1e returned 0 after 66 usecs
[    0.578234] calling  proc_genhd_init+0x0/0x3c @ 1
[    0.578289] initcall proc_genhd_init+0x0/0x3c returned 0 after 2 usecs
[    0.578344] calling  noop_init+0x0/0x14 @ 1
[    0.578396] io scheduler noop registered
[    0.578448] initcall noop_init+0x0/0x14 returned 0 after 51 usecs
[    0.578502] calling  deadline_init+0x0/0x1b @ 1
[    0.578554] io scheduler deadline registered
[    0.578606] initcall deadline_init+0x0/0x1b returned 0 after 50 usecs
[    0.578661] calling  cfq_init+0x0/0xa1 @ 1
[    0.578720] io scheduler cfq registered (default)
[    0.578773] initcall cfq_init+0x0/0xa1 returned 0 after 59 usecs
[    0.578827] calling  percpu_counter_startup+0x0/0x14 @ 1
[    0.578881] initcall percpu_counter_startup+0x0/0x14 returned 0 after 
0 usecs
[    0.578937] calling  pci_init+0x0/0x43 @ 1
[    0.579099] pci 0000:01:00.0: Boot video device
[    0.581103] initcall pci_init+0x0/0x43 returned 0 after 2061 usecs
[    0.581158] calling  pci_proc_init+0x0/0x7b @ 1
[    0.581242] initcall pci_proc_init+0x0/0x7b returned 0 after 30 usecs
[    0.581296] calling  pcie_portdrv_init+0x0/0x50 @ 1
[    0.581390] pcieport-driver 0000:00:01.0: setting latency timer to 64
[    0.581412] pcieport-driver 0000:00:01.0: found MSI capability
[    0.581480] pcieport-driver 0000:00:01.0: irq 319 for MSI/MSI-X
[    0.581486] pci_express 0000:00:01.0:pcie00: allocate port service
[    0.581514] pci_express 0000:00:01.0:pcie03: allocate port service
[    0.581566] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    0.581591] pcieport-driver 0000:00:1c.0: found MSI capability
[    0.581660] pcieport-driver 0000:00:1c.0: irq 318 for MSI/MSI-X
[    0.581669] pci_express 0000:00:1c.0:pcie00: allocate port service
[    0.581695] pci_express 0000:00:1c.0:pcie02: allocate port service
[    0.581720] pci_express 0000:00:1c.0:pcie03: allocate port service
[    0.581779] pcieport-driver 0000:00:1c.3: setting latency timer to 64
[    0.581804] pcieport-driver 0000:00:1c.3: found MSI capability
[    0.581873] pcieport-driver 0000:00:1c.3: irq 317 for MSI/MSI-X
[    0.581882] pci_express 0000:00:1c.3:pcie00: allocate port service
[    0.581908] pci_express 0000:00:1c.3:pcie02: allocate port service
[    0.581933] pci_express 0000:00:1c.3:pcie03: allocate port service
[    0.581994] pcieport-driver 0000:00:1c.4: setting latency timer to 64
[    0.582018] pcieport-driver 0000:00:1c.4: found MSI capability
[    0.582088] pcieport-driver 0000:00:1c.4: irq 316 for MSI/MSI-X
[    0.582096] pci_express 0000:00:1c.4:pcie00: allocate port service
[    0.582123] pci_express 0000:00:1c.4:pcie02: allocate port service
[    0.582148] pci_express 0000:00:1c.4:pcie03: allocate port service
[    0.582227] initcall pcie_portdrv_init+0x0/0x50 returned 0 after 855 
usecs
[    0.582282] calling  aer_service_init+0x0/0x29 @ 1
[    0.582359] initcall aer_service_init+0x0/0x29 returned 0 after 22 usecs
[    0.582414] calling  acpi_reserve_resources+0x0/0xeb @ 1
[    0.582470] initcall acpi_reserve_resources+0x0/0xeb returned 0 after 
2 usecs
[    0.582525] calling  irqrouter_init_sysfs+0x0/0x38 @ 1
[    0.582619] initcall irqrouter_init_sysfs+0x0/0x38 returned 0 after 
38 usecs
[    0.582674] calling  acpi_container_init+0x0/0x42 @ 1
[    0.583983] initcall acpi_container_init+0x0/0x42 returned 0 after 
1228 usecs
[    0.584040] calling  rand_initialize+0x0/0x30 @ 1
[    0.584102] initcall rand_initialize+0x0/0x30 returned 0 after 9 usecs
[    0.584156] calling  tty_init+0x0/0xfa @ 1
[    0.585977] initcall tty_init+0x0/0xfa returned 0 after 1721 usecs
[    0.586032] calling  pty_init+0x0/0x706 @ 1
[    0.602903] initcall pty_init+0x0/0x706 returned 0 after 16425 usecs
[    0.602961] calling  sysrq_init+0x0/0x25 @ 1
[    0.603020] initcall sysrq_init+0x0/0x25 returned 0 after 6 usecs
[    0.603074] calling  raw_init+0x0/0xdf @ 1
[    0.603179] initcall raw_init+0x0/0xdf returned 0 after 50 usecs
[    0.603233] calling  rtc_init+0x0/0xfb @ 1
[    0.603324] Real Time Clock Driver v1.12ac
[    0.603377] initcall rtc_init+0x0/0xfb returned 0 after 89 usecs
[    0.603431] calling  hpet_init+0x0/0x71 @ 1
[    0.603647] initcall hpet_init+0x0/0x71 returned 0 after 159 usecs
[    0.603702] calling  mod_init+0x0/0x208 @ 1
[    0.603822] initcall mod_init+0x0/0x208 returned -19 after 66 usecs
[    0.603876] calling  agp_init+0x0/0x38 @ 1
[    0.603928] Linux agpgart interface v0.103
[    0.603980] initcall agp_init+0x0/0x38 returned 0 after 50 usecs
[    0.604552] calling  hangcheck_init+0x0/0x8f @ 1
[    0.604605] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 
seconds, margin is 60 seconds).
[    0.604684] Hangcheck: Using get_cycles().
[    0.604738] initcall hangcheck_init+0x0/0x8f returned 0 after 130 usecs
[    0.604793] calling  serial8250_init+0x0/0x135 @ 1
[    0.604845] Serial: 8250/16550 driver4 ports, IRQ sharing disabled
[    0.605013] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.605288] initcall serial8250_init+0x0/0x135 returned 0 after 421 usecs
[    0.605343] calling  serial8250_pnp_init+0x0/0x12 @ 1
[    0.605652] 00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.605822] initcall serial8250_pnp_init+0x0/0x12 returned 0 after 
414 usecs
[    0.605877] calling  serial8250_pci_init+0x0/0x23 @ 1
[    0.605971] initcall serial8250_pci_init+0x0/0x23 returned 0 after 39 
usecs
[    0.606028] calling  topology_sysfs_init+0x0/0x55 @ 1
[    0.606089] initcall topology_sysfs_init+0x0/0x55 returned 0 after 8 
usecs
[    0.606144] calling  brd_init+0x0/0x1bc @ 1
[    0.607145] brd: module loaded
[    0.607197] initcall brd_init+0x0/0x1bc returned 0 after 976 usecs
[    0.607252] calling  loop_init+0x0/0x1dc @ 1
[    0.607771] loop: module loaded
[    0.607823] initcall loop_init+0x0/0x1dc returned 0 after 506 usecs
[    0.607878] calling  net_olddevs_init+0x0/0x9c @ 1
[    0.607933] initcall net_olddevs_init+0x0/0x9c returned 0 after 2 usecs
[    0.607988] calling  ide_init+0x0/0x82 @ 1
[    0.608040] Uniform Multi-Platform E-IDE driver
[    0.608145] initcall ide_init+0x0/0x82 returned 0 after 100 usecs
[    0.608200] calling  jmicron_ide_init+0x0/0x1b @ 1
[    0.608261] jmicron 0000:03:00.1: IDE controller (0x197b:0x2363 rev 0x02)
[    0.608324] JMicron IDE 0000:03:00.1: enabling device (0000 -> 0001)
[    0.608383] JMicron IDE 0000:03:00.1: PCI INT B -> GSI 16 (level, 
low) -> IRQ 16
[    0.608478] jmicron 0000:03:00.1: 100% native mode on irq 16
[    0.608540] JMicron IDE 0000:03:00.1: setting latency timer to 64
[    0.608545]     ide0: BM-DMA at 0xa000-0xa007
[    0.608608]     ide1: BM-DMA at 0xa008-0xa00f
[    0.608665] Probing IDE interface ide0...
[    1.120457] hdb: WDC WD3000JB-00KFA0, ATA DISK drive
[    1.176065] hdb: host max PIO5 wanted PIO255(auto-tune) selected PIO4
[    1.176135] hdb: UDMA/100 mode selected
[    1.176277] Probing IDE interface ide1...
[    1.744084] ide0 at 0x9000-0x9007,0x9402 on irq 16
[    1.744181] ide1 at 0x9800-0x9807,0x9c02 on irq 16
[    1.744338] initcall jmicron_ide_init+0x0/0x1b returned 0 after 
1109457 usecs
[    1.744394] calling  ide_gd_init+0x0/0x23 @ 1
[    1.744446] ide-gd driver 1.18
[    1.744505] hdb: max request size: 512KiB
[    1.746323] hdb: Host Protected Area detected.
[    1.746324] 	current capacity is 586070255 sectors (300067 MB)
[    1.746325] 	native  capacity is 586072368 sectors (300069 MB)
[    1.746628] hdb: Host Protected Area disabled.
[    1.746684] hdb: 586072368 sectors (300069 MB) w/8192KiB Cache, 
CHS=36481/255/63
[    1.746923] hdb: cache flushes supported
[    1.747008]  hdb: hdb1 hdb2 < hdb5 hdb6 hdb7 hdb8 hdb9 hdb10 hdb11 
hdb12 hdb13 hdb14 > hdb3
[    1.867046] initcall ide_gd_init+0x0/0x23 returned 0 after 119725 usecs
[    1.867101] calling  piix_init+0x0/0x31 @ 1
[    1.867164] ata_piix 0000:00:1f.2: version 2.12
[    1.867171] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) 
-> IRQ 19
[    1.867226] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[    2.020042] ata_piix 0000:00:1f.2: setting latency timer to 64
[    2.020109] scsi0 : ata_piix
[    2.020275] scsi1 : ata_piix
[    2.020365] ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 
irq 14
[    2.020421] ata2: SATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 
irq 15
[    2.816064] ata1.00: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.816131] ata1.01: SATA link down (SStatus 4 SControl 300)
[    2.864529] ata1.00: HPA detected: current 976771055, native 976773168
[    2.864589] ata1.00: ATA-7: ST3500641AS, 3.AAJ, max UDMA/133
[    2.864645] ata1.00: 976771055 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.947836] ata1.00: configured for UDMA/133
[    3.594639] ata2.00: SATA link down (SStatus 0 SControl 300)
[    3.594697] ata2.01: SATA link down (SStatus 4 SControl 300)
[    3.594804] scsi 0:0:0:0: Direct-Access     ATA      ST3500641AS 
  3.AA PQ: 0 ANSI: 5
[    3.594964] ata_piix 0000:00:1f.5: PCI INT B -> GSI 19 (level, low) 
-> IRQ 19
[    3.595020] ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
[    3.595213] ata_piix 0000:00:1f.5: setting latency timer to 64
[    3.595241] scsi2 : ata_piix
[    3.595339] scsi3 : ata_piix
[    3.595426] ata3: SATA max UDMA/133 cmd 0xd800 ctl 0xdc00 bmdma 
0xe800 irq 19
[    3.595482] ata4: SATA max UDMA/133 cmd 0xe000 ctl 0xe400 bmdma 
0xe808 irq 19
[    4.068055] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    4.076200] ata3.00: ATAPI: SONY    DVD RW AW-G170S, 1.72, max UDMA/66
[    4.092215] ata3.00: configured for UDMA/66
[    4.422604] ata4: SATA link down (SStatus 0 SControl 300)
[    4.423723] scsi 2:0:0:0: CD-ROM            SONY     DVD RW AW-G170S 
  1.72 PQ: 0 ANSI: 5
[    4.423953] initcall piix_init+0x0/0x31 returned 0 after 2496873 usecs
[    4.424010] calling  ehci_hcd_init+0x0/0x8d @ 1
[    4.424063] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.424130] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) 
-> IRQ 18
[    4.424197] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    4.424199] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    4.424290] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned 
bus number 1
[    4.428271] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    4.428280] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xf5205000
[    4.444047] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    4.444242] usb usb1: configuration #1 chosen from 1 choice
[    4.444344] hub 1-0:1.0: USB hub found
[    4.444400] hub 1-0:1.0: 4 ports detected
[    4.444587] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) 
-> IRQ 23
[    4.444647] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    4.444649] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    4.444739] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned 
bus number 2
[    4.448717] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    4.448725] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf5204000
[    4.464047] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    4.464208] usb usb2: configuration #1 chosen from 1 choice
[    4.464316] hub 2-0:1.0: USB hub found
[    4.464371] hub 2-0:1.0: 6 ports detected
[    4.464552] initcall ehci_hcd_init+0x0/0x8d returned 0 after 39539 usecs
[    4.464608] calling  uhci_hcd_init+0x0/0xc5 @ 1
[    4.464660] uhci_hcd: USB Universal Host Controller Interface driver
[    4.464727] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) 
-> IRQ 16
[    4.464785] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    4.464787] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    4.464872] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned 
bus number 3
[    4.464969] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000c000
[    4.465100] usb usb3: configuration #1 chosen from 1 choice
[    4.465188] hub 3-0:1.0: USB hub found
[    4.465243] hub 3-0:1.0: 2 ports detected
[    4.465402] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) 
-> IRQ 21
[    4.465460] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    4.465462] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    4.465545] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned 
bus number 4
[    4.465646] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000c400
[    4.465776] usb usb4: configuration #1 chosen from 1 choice
[    4.465863] hub 4-0:1.0: USB hub found
[    4.465919] hub 4-0:1.0: 2 ports detected
[    4.466075] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) 
-> IRQ 23
[    4.466132] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    4.466135] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    4.466220] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned 
bus number 5
[    4.466317] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000c800
[    4.466442] usb usb5: configuration #1 chosen from 1 choice
[    4.466530] hub 5-0:1.0: USB hub found
[    4.466585] hub 5-0:1.0: 2 ports detected
[    4.466740] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) 
-> IRQ 19
[    4.466798] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    4.466800] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    4.466883] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned 
bus number 6
[    4.466979] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000cc00
[    4.467105] usb usb6: configuration #1 chosen from 1 choice
[    4.467194] hub 6-0:1.0: USB hub found
[    4.467249] hub 6-0:1.0: 2 ports detected
[    4.467405] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) 
-> IRQ 18
[    4.467462] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    4.467465] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    4.467549] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned 
bus number 7
[    4.467645] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000d000
[    4.467772] usb usb7: configuration #1 chosen from 1 choice
[    4.467859] hub 7-0:1.0: USB hub found
[    4.467918] hub 7-0:1.0: 2 ports detected
[    4.468096] initcall uhci_hcd_init+0x0/0xc5 returned 0 after 3353 usecs
[    4.468151] calling  usblp_init+0x0/0x1b @ 1
[    4.468230] usbcore: registered new interface driver usblp
[    4.468285] initcall usblp_init+0x0/0x1b returned 0 after 79 usecs
[    4.468339] calling  usb_stor_init+0x0/0x4c @ 1
[    4.468392] Initializing USB Mass Storage driver...
[    4.468482] usbcore: registered new interface driver usb-storage
[    4.468536] USB Mass Storage support registered.
[    4.468589] initcall usb_stor_init+0x0/0x4c returned 0 after 191 usecs
[    4.468644] calling  i8042_init+0x0/0x40b @ 1
[    4.468757] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    4.468811] PNP: PS/2 appears to have AUX port disabled, if this is 
incorrect please boot with i8042.nopnp
[    4.468972] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.469029] initcall i8042_init+0x0/0x40b returned 0 after 323 usecs
[    4.469085] calling  mousedev_init+0x0/0x92 @ 1
[    4.469204] mice: PS/2 mouse device common for all mice
[    4.469258] initcall mousedev_init+0x0/0x92 returned 0 after 116 usecs
[    4.469312] calling  evdev_init+0x0/0x12 @ 1
[    4.469365] initcall evdev_init+0x0/0x12 returned 0 after 0 usecs
[    4.469419] calling  atkbd_init+0x0/0x27 @ 1
[    4.469497] initcall atkbd_init+0x0/0x27 returned 0 after 23 usecs
[    4.469555] calling  psmouse_init+0x0/0x73 @ 1
[    4.469647] initcall psmouse_init+0x0/0x73 returned 0 after 38 usecs
[    4.469702] calling  raid0_init+0x0/0x12 @ 1
[    4.469754] md: raid0 personality registered for level 0
[    4.469808] initcall raid0_init+0x0/0x12 returned 0 after 52 usecs
[    4.469862] calling  init_ladder+0x0/0x12 @ 1
[    4.469915] cpuidle: using governor ladder
[    4.469968] initcall init_ladder+0x0/0x12 returned 0 after 51 usecs
[    4.470022] calling  init_menu+0x0/0x12 @ 1
[    4.470074] cpuidle: using governor menu
[    4.470127] initcall init_menu+0x0/0x12 returned 0 after 50 usecs
[    4.470181] calling  hid_init+0x0/0x70 @ 1
[    4.470769] initcall hid_init+0x0/0x70 returned 0 after 35 usecs
[    4.470830] calling  a4_init+0x0/0x20 @ 1
[    4.471924] initcall a4_init+0x0/0x20 returned 0 after 1011 usecs
[    4.471926] calling  apple_init+0x0/0x40 @ 1
[    4.471970] initcall apple_init+0x0/0x40 returned 0 after 41 usecs
[    4.471972] calling  belkin_init+0x0/0x20 @ 1
[    4.472424] initcall belkin_init+0x0/0x20 returned 0 after 439 usecs
[    4.472426] calling  bright_init+0x0/0x20 @ 1
[    4.472462] initcall bright_init+0x0/0x20 returned 0 after 32 usecs
[    4.472463] calling  ch_init+0x0/0x20 @ 1
[    4.472737] initcall ch_init+0x0/0x20 returned 0 after 265 usecs
[    4.472791] calling  ch_init+0x0/0x20 @ 1
[    4.472869] initcall ch_init+0x0/0x20 returned 0 after 24 usecs
[    4.472928] calling  cp_init+0x0/0x20 @ 1
[    4.473008] initcall cp_init+0x0/0x20 returned 0 after 26 usecs
[    4.473062] calling  dell_init+0x0/0x20 @ 1
[    4.473139] initcall dell_init+0x0/0x20 returned 0 after 23 usecs
[    4.473193] calling  ez_init+0x0/0x20 @ 1
[    4.473269] initcall ez_init+0x0/0x20 returned 0 after 23 usecs
[    4.473323] calling  gyration_init+0x0/0x20 @ 1
[    4.473400] initcall gyration_init+0x0/0x20 returned 0 after 23 usecs
[    4.473455] calling  lg_init+0x0/0x20 @ 1
[    4.473531] initcall lg_init+0x0/0x20 returned 0 after 23 usecs
[    4.473585] calling  ms_init+0x0/0x20 @ 1
[    4.473662] initcall ms_init+0x0/0x20 returned 0 after 23 usecs
[    4.473715] calling  mr_init+0x0/0x20 @ 1
[    4.473791] initcall mr_init+0x0/0x20 returned 0 after 22 usecs
[    4.473845] calling  pl_init+0x0/0x20 @ 1
[    4.473926] initcall pl_init+0x0/0x20 returned 0 after 23 usecs
[    4.473980] calling  pl_init+0x0/0x20 @ 1
[    4.474056] initcall pl_init+0x0/0x20 returned 0 after 23 usecs
[    4.474110] calling  samsung_init+0x0/0x20 @ 1
[    4.474187] initcall samsung_init+0x0/0x20 returned 0 after 22 usecs
[    4.474241] calling  sony_init+0x0/0x20 @ 1
[    4.474318] initcall sony_init+0x0/0x20 returned 0 after 23 usecs
[    4.474372] calling  sp_init+0x0/0x20 @ 1
[    4.474448] initcall sp_init+0x0/0x20 returned 0 after 22 usecs
[    4.474503] calling  hid_init+0x0/0x92 @ 1
[    4.474608] usbcore: registered new interface driver hiddev
[    4.474690] usbcore: registered new interface driver usbhid
[    4.474745] usbhid: v2.6:USB HID core driver
[    4.474797] initcall hid_init+0x0/0x92 returned 0 after 236 usecs
[    4.474851] calling  init_soundcore+0x0/0x40 @ 1
[    4.474928] initcall init_soundcore+0x0/0x40 returned 0 after 22 usecs
[    4.474982] calling  alsa_sound_init+0x0/0x88 @ 1
[    4.475045] Advanced Linux Sound Architecture Driver Version 1.0.18rc3.
[    4.475100] initcall alsa_sound_init+0x0/0x88 returned 0 after 63 usecs
[    4.475154] calling  alsa_timer_init+0x0/0x1fa @ 1
[    4.475248] initcall alsa_timer_init+0x0/0x1fa returned 0 after 38 usecs
[    4.475302] calling  alsa_pcm_init+0x0/0x71 @ 1
[    4.475356] initcall alsa_pcm_init+0x0/0x71 returned 0 after 1 usecs
[    4.475410] calling  snd_mem_init+0x0/0x2c @ 1
[    4.475464] initcall snd_mem_init+0x0/0x2c returned 0 after 1 usecs
[    4.475518] calling  alsa_card_azx_init+0x0/0x1b @ 1
[    4.475589] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) 
-> IRQ 22
[    4.475688] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    4.487609] input: AT Translated Set 2 keyboard as /class/input/input0
[    4.541642] initcall alsa_card_azx_init+0x0/0x1b returned 0 after 
64520 usecs
[    4.541697] calling  alsa_sound_last_init+0x0/0x7e @ 1
[    4.541750] ALSA device list:
[    4.541801]   #0: HDA Intel at 0xf5200000 irq 22
[    4.541853] initcall alsa_sound_last_init+0x0/0x7e returned 0 after 
100 usecs
[    4.541908] calling  sysctl_core_init+0x0/0x25 @ 1
[    4.541993] initcall sysctl_core_init+0x0/0x25 returned 0 after 30 usecs
[    4.542047] calling  llc_init+0x0/0x20 @ 1
[    4.542100] initcall llc_init+0x0/0x20 returned 0 after 0 usecs
[    4.542154] calling  snap_init+0x0/0x33 @ 1
[    4.542207] initcall snap_init+0x0/0x33 returned 0 after 0 usecs
[    4.542261] calling  nf_conntrack_standalone_init+0x0/0x12 @ 1
[    4.542315] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    4.542436] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. 
Please use
[    4.542515] nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack 
module option or
[    4.542594] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
[    4.542676] initcall nf_conntrack_standalone_init+0x0/0x12 returned 0 
after 353 usecs
[    4.542756] calling  xt_init+0x0/0xca @ 1
[    4.542809] initcall xt_init+0x0/0xca returned 0 after 0 usecs
[    4.542862] calling  tcpudp_mt_init+0x0/0x20 @ 1
[    4.542916] initcall tcpudp_mt_init+0x0/0x20 returned 0 after 1 usecs
[    4.542970] calling  sysctl_ipv4_init+0x0/0x53 @ 1
[    4.543195] initcall sysctl_ipv4_init+0x0/0x53 returned 0 after 168 usecs
[    4.543251] calling  ipv4_netfilter_init+0x0/0x20 @ 1
[    4.543305] initcall ipv4_netfilter_init+0x0/0x20 returned 0 after 0 
usecs
[    4.543360] calling  nf_conntrack_l3proto_ipv4_init+0x0/0x15b @ 1
[    4.543553] initcall nf_conntrack_l3proto_ipv4_init+0x0/0x15b 
returned 0 after 135 usecs
[    4.543633] calling  nf_nat_init+0x0/0x10f @ 1
[    4.543721] initcall nf_nat_init+0x0/0x10f returned 0 after 34 usecs
[    4.543775] calling  nf_defrag_init+0x0/0x17 @ 1
[    4.543828] initcall nf_defrag_init+0x0/0x17 returned 0 after 0 usecs
[    4.543883] calling  nf_nat_snmp_basic_init+0x0/0x44 @ 1
[    4.543936] initcall nf_nat_snmp_basic_init+0x0/0x44 returned 0 after 
0 usecs
[    4.543991] calling  ip_tables_init+0x0/0xae @ 1
[    4.544057] ip_tables: (C) 2000-2006 Netfilter Core Team
[    4.544111] initcall ip_tables_init+0x0/0xae returned 0 after 55 usecs
[    4.544165] calling  nf_nat_standalone_init+0x0/0x5e @ 1
[    4.544223] initcall nf_nat_standalone_init+0x0/0x5e returned 0 after 
4 usecs
[    4.544278] calling  masquerade_tg_init+0x0/0x3c @ 1
[    4.544333] initcall masquerade_tg_init+0x0/0x3c returned 0 after 1 usecs
[    4.544387] calling  netmap_tg_init+0x0/0x12 @ 1
[    4.544440] initcall netmap_tg_init+0x0/0x12 returned 0 after 0 usecs
[    4.544495] calling  redirect_tg_init+0x0/0x12 @ 1
[    4.544548] initcall redirect_tg_init+0x0/0x12 returned 0 after 0 usecs
[    4.544603] calling  cubictcp_register+0x0/0x6f @ 1
[    4.544656] TCP cubic registered
[    4.544708] initcall cubictcp_register+0x0/0x6f returned 0 after 50 usecs
[    4.544763] calling  packet_init+0x0/0x4a @ 1
[    4.544816] NET: Registered protocol family 17
[    4.544870] initcall packet_init+0x0/0x4a returned 0 after 53 usecs
[    4.544924] calling  br_init+0x0/0xd6 @ 1
[    4.545002] Bridge firewalling registered
[    4.545055] initcall br_init+0x0/0xd6 returned 0 after 77 usecs
[    4.545109] calling  init_sunrpc+0x0/0x72 @ 1
[    4.545256] RPC: Registered udp transport module.
[    4.545309] RPC: Registered tcp transport module.
[    4.545363] initcall init_sunrpc+0x0/0x72 returned 0 after 193 usecs
[    4.545418] calling  hpet_insert_resource+0x0/0x23 @ 1
[    4.545472] initcall hpet_insert_resource+0x0/0x23 returned 0 after 0 
usecs
[    4.545528] calling  update_mp_table+0x0/0x6bc @ 1
[    4.545581] initcall update_mp_table+0x0/0x6bc returned 0 after 0 usecs
[    4.545636] calling  lapic_insert_resource+0x0/0x42 @ 1
[    4.545690] initcall lapic_insert_resource+0x0/0x42 returned 0 after 
0 usecs
[    4.545745] calling  init_lapic_nmi_sysfs+0x0/0x39 @ 1
[    4.545799] initcall init_lapic_nmi_sysfs+0x0/0x39 returned 0 after 0 
usecs
[    4.545854] calling  ioapic_insert_resources+0x0/0x58 @ 1
[    4.545907] initcall ioapic_insert_resources+0x0/0x58 returned 0 
after 0 usecs
[    4.545987] calling  io_apic_bug_finalize+0x0/0x1b @ 1
[    4.546040] initcall io_apic_bug_finalize+0x0/0x1b returned 0 after 0 
usecs
[    4.546095] calling  check_early_ioremap_leak+0x0/0x6f @ 1
[    4.546149] initcall check_early_ioremap_leak+0x0/0x6f returned 0 
after 0 usecs
[    4.546228] calling  sched_init_debug+0x0/0x24 @ 1
[    4.546284] initcall sched_init_debug+0x0/0x24 returned 0 after 3 usecs
[    4.546340] calling  init_oops_id+0x0/0x30 @ 1
[    4.546395] initcall init_oops_id+0x0/0x30 returned 0 after 1 usecs
[    4.546449] calling  disable_boot_consoles+0x0/0x3a @ 1
[    4.546502] initcall disable_boot_consoles+0x0/0x3a returned 0 after 
0 usecs
[    4.546557] calling  pm_qos_power_init+0x0/0xe5 @ 1
[    4.546714] initcall pm_qos_power_init+0x0/0xe5 returned 0 after 97 usecs
[    4.546769] calling  random32_reseed+0x0/0xa5 @ 1
[    4.546829] initcall random32_reseed+0x0/0xa5 returned 0 after 6 usecs
[    4.546883] calling  pci_sysfs_init+0x0/0x55 @ 1
[    4.547008] initcall pci_sysfs_init+0x0/0x55 returned 0 after 71 usecs
[    4.547063] calling  acpi_wakeup_device_init+0x0/0xa0 @ 1
[    4.547119] initcall acpi_wakeup_device_init+0x0/0xa0 returned 0 
after 1 usecs
[    4.547198] calling  seqgen_init+0x0/0xf @ 1
[    4.547257] initcall seqgen_init+0x0/0xf returned 0 after 7 usecs
[    4.547313] calling  scsi_complete_async_scans+0x0/0x120 @ 1
[    4.547367] initcall scsi_complete_async_scans+0x0/0x120 returned 0 
after 0 usecs
[    4.547446] calling  memmap_init+0x0/0xa5 @ 1
[    4.547520] initcall memmap_init+0x0/0xa5 returned 0 after 20 usecs
[    4.547574] calling  pci_mmcfg_late_insert_resources+0x0/0x14f @ 1
[    4.547630] initcall pci_mmcfg_late_insert_resources+0x0/0x14f 
returned 0 after 1 usecs
[    4.547709] calling  tcp_congestion_default+0x0/0x12 @ 1
[    4.547763] initcall tcp_congestion_default+0x0/0x12 returned 0 after 
0 usecs
[    4.547820] Freeing unused kernel memory: 336k freed
[    4.602655] calling  fuse_init+0x0/0x152 [fuse] @ 1236
[    4.602710] fuse init (API version 7.10)
[    4.602852] initcall fuse_init+0x0/0x152 [fuse] returned 0 after 136 
usecs
[    4.608283] calling  acpi_processor_init+0x0/0x10a [processor] @ 1244
[    4.608433] processor ACPI_CPU:00: registered as cooling_device0
[    4.608488] ACPI: Processor [CPU0] (supports 8 throttling states)
[    4.608735] ACPI: SSDT CFEE8B40, 0087 (r1  PmRef  Cpu1Ist     3000 
INTL 20040311)
[    4.609033] processor ACPI_CPU:01: registered as cooling_device1
[    4.609089] ACPI: Processor [CPU1] (supports 8 throttling states)
[    4.609271] initcall acpi_processor_init+0x0/0x10a [processor] 
returned 0 after 907 usecs
[    4.610357] calling  acpi_thermal_init+0x0/0x83 [thermal] @ 1244
[    4.610946] initcall acpi_thermal_init+0x0/0x83 [thermal] returned 0 
after 34 usecs
[    4.825039] usb 2-5: new high speed USB device using ehci_hcd and 
address 2
[    4.874748] calling  generic_ide_init+0x0/0x20 [ide_pci_generic] @ 2343
[    4.874828] initcall generic_ide_init+0x0/0x20 [ide_pci_generic] 
returned 0 after 21 usecs
[    4.883642] calling  sky2_init_module+0x0/0x5c [sky2] @ 2358
[    4.883698] sky2 driver version 1.22
[    4.883780] sky2 0000:04:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.883842] sky2 0000:04:00.0: setting latency timer to 64
[    4.883866] sky2 0000:04:00.0: Yukon-2 EC chip revision 2
[    4.895898] calling  init_sd+0x0/0x105 [sd_mod] @ 2384
[    4.895965] Driver 'sd' needs updating - please use bus_type methods
[    4.896082] sd 0:0:0:0: [sda] 976771055 512-byte hardware sectors: 
(500 GB/465 GiB)
[    4.896170] sd 0:0:0:0: [sda] Write Protect is off
[    4.896223] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.896238] sd 0:0:0:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    4.896361] sd 0:0:0:0: [sda] 976771055 512-byte hardware sectors: 
(500 GB/465 GiB)
[    4.896448] sd 0:0:0:0: [sda] Write Protect is off
[    4.896500] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.896515] sd 0:0:0:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    4.896597]  sda: sda1 sda3 <<6>sky2 0000:04:00.0: Marvell Yukon 
88E8053 Gigabit Ethernet Controller
[    4.915925]  Part Number: Yukon 88E8053
[    4.915926]  Engineering Level: Rev. 2.2
[    4.915927]  Manufacturer: Marvell
[    4.916923] sky2 0000:04:00.0: irq 315 for MSI/MSI-X
[    4.917188] sky2 eth0: addr 00:1a:4d:40:12:9e
[    4.917258] initcall sky2_init_module+0x0/0x5c [sky2] returned 0 
after 32763 usecs
[    4.925942]  sda5 sda6 sda7 >
[    4.942004] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.942073] initcall init_sd+0x0/0x105 [sd_mod] returned 0 after 
45028 usecs
[    4.957554] usb 2-5: configuration #1 chosen from 1 choice
[    4.957845] hub 2-5:1.0: USB hub found
[    4.958198] hub 2-5:1.0: 2 ports detected
[    5.006479] md: md1 stopped.
[    5.252033] usb 3-2: new low speed USB device using uhci_hcd and 
address 2
[    5.449210] usb 3-2: configuration #1 chosen from 1 choice
[    5.635057] md: bind<hdb12>
[    5.635127] md: could not bd_claim hdb.
[    5.635181] md: md_import_device returned -16
[    5.662483] md: md1 stopped.
[    5.662544] md: unbind<hdb12>
[    5.669240] md: export_rdev(hdb12)
[    5.689619] md: bind<hdb12>
[    5.689856] md: bind<sda1>
[    5.691099] md1: setting max_sectors to 128, segment boundary to 32767
[    5.691155] raid0: looking at sda1
[    5.691206] raid0:   comparing sda1(31455168) with sda1(31455168)
[    5.691284] raid0:   END
[    5.691334] raid0:   ==> UNIQUE
[    5.691385] raid0: 1 zones
[    5.691435] raid0: looking at hdb12
[    5.691487] raid0:   comparing hdb12(31455168) with sda1(31455168)
[    5.691564] raid0:   EQUAL
[    5.691615] raid0: FINAL 1 zones
[    5.691666] raid0: done.
[    5.691716] raid0 : md_size is 62910336 blocks.
[    5.691768] raid0 : conf->hash_spacing is 62910336 blocks.
[    5.691821] raid0 : nb_zone is 1.
[    5.691872] raid0 : Allocating 8 bytes for hash.
[    5.692130]  md1: unknown partition table
[    5.808535] kjournald starting.  Commit interval 5 seconds
[    5.808541] EXT3-fs: mounted filesystem with ordered data mode.
[    5.852194] generic-usb 0003:051D:0002.0001: hiddev96: USB HID v1.10 
Device [APC Back-UPS ES 750 FW:819.z3.D USB FW:z3] on 
usb-0000:00:1a.0-2/input0
[    6.096053] usb 7-2: new low speed USB device using uhci_hcd and 
address 2
[    6.278889] usb 7-2: configuration #1 chosen from 1 choice
[    6.297092] input: Microsoft Microsoft 5-Button Mouse with 
IntelliEye(TM) as /class/input/input1
[    6.324083] generic-usb 0003:045E:0039.0002: input: USB HID v1.10 
Mouse [Microsoft Microsoft 5-Button Mouse with IntelliEye(TM)] on 
usb-0000:00:1d.2-2/input0
[   10.587231] udevd version 124 started
[   12.107446] nvidia: module license 'NVIDIA' taints kernel.
[   12.110547] calling  nvidia_init_module+0x0/0x94d [nvidia] @ 3652
[   12.360176] nvidia 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> 
IRQ 16
[   12.360241] nvidia 0000:01:00.0: setting latency timer to 64
[   12.360943] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  180.25 
Sat Jan 24 18:19:10 PST 2009
[   12.362441] initcall nvidia_init_module+0x0/0x94d [nvidia] returned 0 
after 245842 usecs
[   12.371453] calling  ssb_modinit+0x0/0x9a [ssb] @ 3758
[   12.371547] b43-pci-bridge 0000:05:01.0: PCI INT A -> GSI 19 (level, 
low) -> IRQ 19
[   12.432088] ssb: Sonics Silicon Backplane found on PCI device 
0000:05:01.0
[   12.432185] initcall ssb_modinit+0x0/0x9a [ssb] returned 0 after 
59244 usecs
[   12.479294] calling  ieee80211_init+0x0/0x22 [mac80211] @ 3839
[   12.479446] initcall ieee80211_init+0x0/0x22 [mac80211] returned 0 
after 68 usecs
[   12.522570] calling  b43_init+0x0/0x60 [b43] @ 3839
[   12.522719] b43-phy0: Broadcom 4318 WLAN found
[   12.564028] b43-phy0 debug: Found PHY: Analog 3, Type 2, Revision 7
[   12.564036] b43-phy0 debug: Found Radio: Manuf 0x17F, Version 0x2050, 
Revision 8
[   12.588505] phy0: Selected rate control algorithm 'pid'
[   12.590091] Broadcom 43xx driver loaded [ Features: PL, Firmware-ID: 
FW13 ]
[   12.590152] initcall b43_init+0x0/0x60 [b43] returned 0 after 65931 usecs
[   13.525771] Adding 2096440k swap on /dev/hdb5.  Priority:-1 extents:1 
across:2096440k
[   13.880158] EXT3 FS on hdb13, internal journal
[   15.451662] kjournald starting.  Commit interval 5 seconds
[   15.451851] EXT3 FS on sda7, internal journal
[   15.451855] EXT3-fs: mounted filesystem with writeback data mode.
[   15.485883] kjournald starting.  Commit interval 5 seconds
[   15.486109] EXT3 FS on hdb11, internal journal
[   15.486112] EXT3-fs: mounted filesystem with ordered data mode.
[   15.530957] kjournald starting.  Commit interval 5 seconds
[   15.531208] EXT3 FS on hdb8, internal journal
[   15.531212] EXT3-fs: mounted filesystem with ordered data mode.
[   15.551380] EXT4-fs: barriers enabled
[   15.568494] kjournald2 starting.  Commit interval 5 seconds
[   15.568630] EXT4 FS on md1, internal journal on md1:8
[   15.568632] EXT4-fs: delayed allocation enabled
[   15.568634] EXT4-fs: file extents enabled
[   15.568770] EXT4-fs: mballoc enabled
[   15.568772] EXT4-fs: mounted filesystem with ordered data mode.
[   16.016042] b43 ssb0:0: firmware: requesting b43/ucode5.fw
[   16.050035] b43 ssb0:0: firmware: requesting b43/pcm5.fw
[   16.055522] b43 ssb0:0: firmware: requesting b43/b0g0initvals5.fw
[   16.057357] b43 ssb0:0: firmware: requesting b43/b0g0bsinitvals5.fw
[   16.172053] b43-phy0: Loading firmware version 410.2160 (2007-05-26 
15:32:10)
[   16.192065] b43-phy0 debug: Chip initialized
[   16.192208] b43-phy0 debug: 32-bit DMA initialized
[   16.212403] Registered led device: b43-phy0::tx
[   16.212416] Registered led device: b43-phy0::rx
[   16.212441] b43-phy0 debug: Wireless interface started
[   16.244043] b43-phy0 debug: Adding Interface type 2
[   16.256649] phy0: HW CONFIG: freq=2412
[   16.256682] b43-phy0: Radio turned on by software
[   16.288090] b43-phy0 debug: Using hardware based encryption for 
keyidx: 0, mac: ff:ff:ff:ff:ff:ff
[   16.308050] phy0: HW CONFIG: freq=2412
[   16.532051] phy0: HW CONFIG: freq=2417
[   16.772031] phy0: HW CONFIG: freq=2422
[   17.012035] phy0: HW CONFIG: freq=2427
[   17.252049] phy0: HW CONFIG: freq=2432
[   17.492054] phy0: HW CONFIG: freq=2437
[   17.623994] calling  cpufreq_gov_userspace_init+0x0/0x12 
[cpufreq_userspace] @ 4688
[   17.623998] initcall cpufreq_gov_userspace_init+0x0/0x12 
[cpufreq_userspace] returned 0 after 0 usecs
[   17.668941] calling  acpi_cpufreq_init+0x0/0x6d [acpi_cpufreq] @ 4711
[   17.669181] initcall acpi_cpufreq_init+0x0/0x6d [acpi_cpufreq] 
returned 0 after 232 usecs
[   17.732019] phy0: HW CONFIG: freq=2442
[   17.972009] phy0: HW CONFIG: freq=2447
[   18.212010] phy0: HW CONFIG: freq=2452
[   18.447404] warning: `avahi-daemon' uses 32-bit capabilities (legacy 
support in use)
[   18.452013] phy0: HW CONFIG: freq=2457
[   18.692009] phy0: HW CONFIG: freq=2462
[   18.932015] phy0: HW CONFIG: freq=2412
[   18.972018] phy0: HW CONFIG: freq=2412
[   19.200012] phy0: HW CONFIG: freq=2417
[   19.440011] phy0: HW CONFIG: freq=2422
[   19.680014] phy0: HW CONFIG: freq=2427
[   19.924010] phy0: HW CONFIG: freq=2432
[   20.160018] phy0: HW CONFIG: freq=2437
[   20.400012] phy0: HW CONFIG: freq=2442
[   20.641667] phy0: HW CONFIG: freq=2447
[   20.880010] phy0: HW CONFIG: freq=2452
[   21.120012] phy0: HW CONFIG: freq=2457
[   21.360011] phy0: HW CONFIG: freq=2462
[   21.600016] phy0: HW CONFIG: freq=2412
[   21.611261] calling  VBoxDrvLinuxInit+0x0/0x1b8 [vboxdrv] @ 5406
[   21.611264] vboxdrv: Trying to deactivate the NMI watchdog permanently...
[   21.611267] vboxdrv: Successfully done.
[   21.611268] vboxdrv: Found 2 processor cores.
[   21.611362] VBoxDrv: dbg - g_abExecMemory=ffffffffa088e9c0
[   21.611382] vboxdrv: fAsync=0 offMin=0x3de offMax=0xbe0
[   21.611421] vboxdrv: TSC mode is 'synchronous', kernel timer mode is 
'normal'.
[   21.611423] vboxdrv: Successfully loaded version 2.1.2 (interface 
0x000a0009).
[   21.611430] initcall VBoxDrvLinuxInit+0x0/0x1b8 [vboxdrv] returned 0 
after 157 usecs
[   21.818568] calling  VBoxNetFltLinuxInit+0x0/0x121 [vboxnetflt] @ 5414
[   21.818573] VBoxNetFlt: dbg - g_abExecMemory=ffffffffa0a2b840
[   21.818584] initcall VBoxNetFltLinuxInit+0x0/0x121 [vboxnetflt] 
returned 0 after 8 usecs
[   23.896010] phy0: HW CONFIG: freq=2412
[   24.120011] phy0: HW CONFIG: freq=2417
[   24.360011] phy0: HW CONFIG: freq=2422
[   24.600012] phy0: HW CONFIG: freq=2427
[   24.840014] phy0: HW CONFIG: freq=2432
[   25.080012] phy0: HW CONFIG: freq=2437
[   25.320009] phy0: HW CONFIG: freq=2442
[   25.561009] phy0: HW CONFIG: freq=2447
[   25.808012] phy0: HW CONFIG: freq=2452
[   26.048011] phy0: HW CONFIG: freq=2457
[   26.292010] phy0: HW CONFIG: freq=2462
[   26.532022] phy0: HW CONFIG: freq=2412
[   27.866700] sky2 eth0: enabling interface
[   29.688635] sky2 eth0: Link is up at 100 Mbps, full duplex, flow 
control both
[  179.768013] b43-phy0 debug: Disabling hardware based encryption for 
keyidx: 0, mac: ff:ff:ff:ff:ff:ff
[  179.768018] b43-phy0 debug: Removing Interface type 2
[  179.781762] b43-phy0 debug: Wireless interface stopped
[  179.781930] b43-phy0 debug: DMA-32 rx_ring: Used slots 1/64, Failed 
frames 0/0 = 0.0%, Average tries 0.00
[  179.782083] b43-phy0 debug: DMA-32 tx_ring_AC_BK: Used slots 0/128, 
Failed frames 0/0 = 0.0%, Average tries 0.00
[  179.788013] b43-phy0 debug: DMA-32 tx_ring_AC_BE: Used slots 0/128, 
Failed frames 0/0 = 0.0%, Average tries 0.00
[  179.796009] b43-phy0 debug: DMA-32 tx_ring_AC_VI: Used slots 0/128, 
Failed frames 0/0 = 0.0%, Average tries 0.00
[  179.804008] b43-phy0 debug: DMA-32 tx_ring_AC_VO: Used slots 0/128, 
Failed frames 0/0 = 0.0%, Average tries 0.00
[  179.812008] b43-phy0 debug: DMA-32 tx_ring_mcast: Used slots 0/128, 
Failed frames 0/0 = 0.0%, Average tries 0.00
[  180.020016] b43-phy0: Loading firmware version 410.2160 (2007-05-26 
15:32:10)
[  180.036036] b43-phy0 debug: Chip initialized
[  180.036142] b43-phy0 debug: 32-bit DMA initialized
[  180.056406] Registered led device: b43-phy0::tx
[  180.056425] Registered led device: b43-phy0::rx
[  180.056452] b43-phy0 debug: Wireless interface started
[  180.092024] b43-phy0 debug: Adding Interface type 2
[  180.104866] phy0: HW CONFIG: freq=2412
[  180.108646] phy0: HW CONFIG: freq=2412
[  180.124428] wlan0: direct probe to AP 00:1f:33:31:40:fc try 1
[  180.124451] phy0: HW CONFIG: freq=2412
[  180.124605] wlan0: direct probe to AP 00:1f:33:31:40:fc try 1
[  180.124650] b43-phy0 debug: Using hardware based encryption for 
keyidx: 0, mac: ff:ff:ff:ff:ff:ff
[  180.246870] wlan0 direct probe responded
[  180.246875] wlan0: authenticate with AP 00:1f:33:31:40:fc
[  180.280024] wlan0: authenticated
[  180.280028] wlan0: associate with AP 00:1f:33:31:40:fc
[  180.364305] wlan0: RX AssocResp from 00:1f:33:31:40:fc (capab=0x411 
status=0 aid=2)
[  180.364308] wlan0: associated
[  180.364312] phy0: Allocated STA 00:1f:33:31:40:fc
[  180.364316] phy0: Inserted STA 00:1f:33:31:40:fc



kernel config
#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.28.3-090210-1343
# Tue Feb 10 13:44:54 2009
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
# CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_HAVE_CPUMASK_OF_CPU_MAP=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_X86_SMP=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_X86_TRAMPOLINE=y
# CONFIG_KTIME_SCALAR is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
# CONFIG_POSIX_MQUEUE is not set
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
# CONFIG_TASKSTATS is not set
# CONFIG_AUDIT is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=18
# CONFIG_CGROUPS is not set
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
# CONFIG_GROUP_SCHED is not set
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
# CONFIG_RELAY is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_COMPAT_BRK=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
# CONFIG_MARKERS is not set
CONFIG_HAVE_OPROFILE=y
# CONFIG_KPROBES is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_KMOD=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_BLK_DEV_BSG is not set
# CONFIG_BLK_DEV_INTEGRITY is not set
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_AS is not set
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_CLASSIC_RCU=y
# CONFIG_FREEZER is not set

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_VSMP is not set
CONFIG_PARAVIRT_GUEST=y
# CONFIG_XEN is not set
# CONFIG_KVM_CLOCK is not set
# CONFIG_KVM_GUEST is not set
# CONFIG_PARAVIRT is not set
# CONFIG_PARAVIRT_CLOCK is not set
# CONFIG_MEMTEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
CONFIG_MCORE2=y
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_CPU=y
CONFIG_X86_L1_CACHE_BYTES=64
CONFIG_X86_INTERNODE_CACHE_BYTES=64
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_P6_NOP=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR_64=y
# CONFIG_X86_DS is not set
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
# CONFIG_AMD_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=2
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
# CONFIG_I8K is not set
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
# CONFIG_DISCONTIGMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_RESOURCES_64BIT=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_UNEVICTABLE_LRU=y
CONFIG_MMU_NOTIFIER=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW_64K=y
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
# CONFIG_X86_PAT is not set
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x200000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
# CONFIG_SUSPEND is not set
# CONFIG_HIBERNATION is not set
CONFIG_ACPI=y
# CONFIG_ACPI_PROCFS is not set
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_SYSFS_POWER=y
# CONFIG_ACPI_PROC_EVENT is not set
# CONFIG_ACPI_AC is not set
# CONFIG_ACPI_BATTERY is not set
# CONFIG_ACPI_BUTTON is not set
# CONFIG_ACPI_FAN is not set
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=m
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=m
# CONFIG_ACPI_WMI is not set
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
# CONFIG_CPU_FREQ_DEBUG is not set
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_GOV_USERSPACE=m
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# CPUFreq processor drivers
#
CONFIG_X86_ACPI_CPUFREQ=m
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_ACPI_CPUFREQ_PROC_INTF is not set
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_DMAR is not set
# CONFIG_INTR_REMAP is not set
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
# CONFIG_PCIEASPM is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_LEGACY is not set
# CONFIG_HT_IRQ is not set
CONFIG_ISA_DMA_API=y
CONFIG_K8_NB=y
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
# CONFIG_PACKET_MMAP is not set
CONFIG_UNIX=y
# CONFIG_NET_KEY is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
# CONFIG_INET_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
# CONFIG_INET_LRO is not set
# CONFIG_INET_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
# CONFIG_NETFILTER_NETLINK_QUEUE is not set
# CONFIG_NETFILTER_NETLINK_LOG is not set
CONFIG_NF_CONNTRACK=y
CONFIG_NF_CT_ACCT=y
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_EVENTS=y
# CONFIG_NF_CT_PROTO_DCCP is not set
# CONFIG_NF_CT_PROTO_SCTP is not set
# CONFIG_NF_CT_PROTO_UDPLITE is not set
# CONFIG_NF_CONNTRACK_AMANDA is not set
# CONFIG_NF_CONNTRACK_FTP is not set
# CONFIG_NF_CONNTRACK_H323 is not set
# CONFIG_NF_CONNTRACK_IRC is not set
# CONFIG_NF_CONNTRACK_NETBIOS_NS is not set
# CONFIG_NF_CONNTRACK_PPTP is not set
# CONFIG_NF_CONNTRACK_SANE is not set
# CONFIG_NF_CONNTRACK_SIP is not set
# CONFIG_NF_CONNTRACK_TFTP is not set
# CONFIG_NF_CT_NETLINK is not set
CONFIG_NETFILTER_XTABLES=y
# CONFIG_NETFILTER_XT_TARGET_CLASSIFY is not set
# CONFIG_NETFILTER_XT_TARGET_CONNMARK is not set
# CONFIG_NETFILTER_XT_TARGET_MARK is not set
# CONFIG_NETFILTER_XT_TARGET_NFLOG is not set
# CONFIG_NETFILTER_XT_TARGET_NFQUEUE is not set
# CONFIG_NETFILTER_XT_TARGET_RATEEST is not set
# CONFIG_NETFILTER_XT_TARGET_TCPMSS is not set
# CONFIG_NETFILTER_XT_MATCH_COMMENT is not set
# CONFIG_NETFILTER_XT_MATCH_CONNBYTES is not set
# CONFIG_NETFILTER_XT_MATCH_CONNLIMIT is not set
# CONFIG_NETFILTER_XT_MATCH_CONNMARK is not set
# CONFIG_NETFILTER_XT_MATCH_CONNTRACK is not set
# CONFIG_NETFILTER_XT_MATCH_DCCP is not set
# CONFIG_NETFILTER_XT_MATCH_DSCP is not set
# CONFIG_NETFILTER_XT_MATCH_ESP is not set
# CONFIG_NETFILTER_XT_MATCH_HASHLIMIT is not set
# CONFIG_NETFILTER_XT_MATCH_HELPER is not set
# CONFIG_NETFILTER_XT_MATCH_IPRANGE is not set
# CONFIG_NETFILTER_XT_MATCH_LENGTH is not set
# CONFIG_NETFILTER_XT_MATCH_LIMIT is not set
# CONFIG_NETFILTER_XT_MATCH_MAC is not set
# CONFIG_NETFILTER_XT_MATCH_MARK is not set
# CONFIG_NETFILTER_XT_MATCH_MULTIPORT is not set
# CONFIG_NETFILTER_XT_MATCH_OWNER is not set
# CONFIG_NETFILTER_XT_MATCH_PHYSDEV is not set
# CONFIG_NETFILTER_XT_MATCH_PKTTYPE is not set
# CONFIG_NETFILTER_XT_MATCH_QUOTA is not set
# CONFIG_NETFILTER_XT_MATCH_RATEEST is not set
# CONFIG_NETFILTER_XT_MATCH_REALM is not set
# CONFIG_NETFILTER_XT_MATCH_RECENT is not set
# CONFIG_NETFILTER_XT_MATCH_SCTP is not set
# CONFIG_NETFILTER_XT_MATCH_STATE is not set
# CONFIG_NETFILTER_XT_MATCH_STATISTIC is not set
# CONFIG_NETFILTER_XT_MATCH_STRING is not set
# CONFIG_NETFILTER_XT_MATCH_TCPMSS is not set
# CONFIG_NETFILTER_XT_MATCH_TIME is not set
# CONFIG_NETFILTER_XT_MATCH_U32 is not set
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=y
CONFIG_NF_CONNTRACK_IPV4=y
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
# CONFIG_IP_NF_QUEUE is not set
CONFIG_IP_NF_IPTABLES=y
# CONFIG_IP_NF_MATCH_ADDRTYPE is not set
# CONFIG_IP_NF_MATCH_AH is not set
# CONFIG_IP_NF_MATCH_ECN is not set
# CONFIG_IP_NF_MATCH_TTL is not set
# CONFIG_IP_NF_FILTER is not set
# CONFIG_IP_NF_TARGET_LOG is not set
# CONFIG_IP_NF_TARGET_ULOG is not set
CONFIG_NF_NAT=y
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=y
CONFIG_IP_NF_TARGET_NETMAP=y
CONFIG_IP_NF_TARGET_REDIRECT=y
CONFIG_NF_NAT_SNMP_BASIC=y
# CONFIG_NF_NAT_FTP is not set
# CONFIG_NF_NAT_IRC is not set
# CONFIG_NF_NAT_TFTP is not set
# CONFIG_NF_NAT_AMANDA is not set
# CONFIG_NF_NAT_PPTP is not set
# CONFIG_NF_NAT_H323 is not set
# CONFIG_NF_NAT_SIP is not set
# CONFIG_IP_NF_MANGLE is not set
# CONFIG_IP_NF_RAW is not set
# CONFIG_IP_NF_ARPTABLES is not set
# CONFIG_BRIDGE_NF_EBTABLES is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
CONFIG_STP=y
CONFIG_BRIDGE=y
# CONFIG_NET_DSA is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_NET_SCHED is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
# CONFIG_PHONET is not set
CONFIG_WIRELESS=y
CONFIG_CFG80211=y
CONFIG_NL80211=y
# CONFIG_WIRELESS_OLD_REGULATORY is not set
CONFIG_WIRELESS_EXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
CONFIG_MAC80211=m

#
# Rate control algorithm selection
#
CONFIG_MAC80211_RC_PID=y
# CONFIG_MAC80211_RC_MINSTREL is not set
CONFIG_MAC80211_RC_DEFAULT_PID=y
# CONFIG_MAC80211_RC_DEFAULT_MINSTREL is not set
CONFIG_MAC80211_RC_DEFAULT="pid"
# CONFIG_MAC80211_MESH is not set
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
CONFIG_MAC80211_DEBUG_MENU=y
CONFIG_MAC80211_DEBUG_PACKET_ALIGNMENT=y
# CONFIG_MAC80211_NOINLINE is not set
CONFIG_MAC80211_VERBOSE_DEBUG=y
# CONFIG_MAC80211_HT_DEBUG is not set
# CONFIG_MAC80211_TKIP_DEBUG is not set
# CONFIG_MAC80211_IBSS_DEBUG is not set
# CONFIG_MAC80211_VERBOSE_PS_DEBUG is not set
CONFIG_MAC80211_DEBUG_COUNTERS=y
# CONFIG_MAC80211_VERBOSE_SPECT_MGMT_DEBUG is not set
# CONFIG_IEEE80211 is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
# CONFIG_BLK_DEV_XIP is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_MISC_DEVICES is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_IDE_GD=y
CONFIG_IDE_GD_ATA=y
# CONFIG_IDE_GD_ATAPI is not set
CONFIG_BLK_DEV_IDECD=m
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDESCSI is not set
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
# CONFIG_IDE_GENERIC is not set
# CONFIG_BLK_DEV_PLATFORM is not set
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
# CONFIG_IDEPCI_PCIBUS_ORDER is not set
# CONFIG_BLK_DEV_OFFBOARD is not set
CONFIG_BLK_DEV_GENERIC=m
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_HPT366 is not set
CONFIG_BLK_DEV_JMICRON=y
# CONFIG_BLK_DEV_SC1200 is not set
# CONFIG_BLK_DEV_PIIX is not set
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_BLK_DEV_TC86C001 is not set
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
# CONFIG_CHR_DEV_SG is not set
# CONFIG_CHR_DEV_SCH is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
# CONFIG_SCSI_MULTI_LUN is not set
CONFIG_SCSI_CONSTANTS=y
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
# CONFIG_SCSI_DH is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
# CONFIG_ATA_ACPI is not set
# CONFIG_SATA_PMP is not set
# CONFIG_SATA_AHCI is not set
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y
# CONFIG_SATA_SVW is not set
CONFIG_ATA_PIIX=y
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SX4 is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set
# CONFIG_PATA_SCH is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
# CONFIG_MD_LINEAR is not set
CONFIG_MD_RAID0=y
# CONFIG_MD_RAID1 is not set
# CONFIG_MD_RAID10 is not set
# CONFIG_MD_RAID456 is not set
# CONFIG_MD_MULTIPATH is not set
# CONFIG_MD_FAULTY is not set
# CONFIG_BLK_DEV_DM is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#

#
# Enable only one of the two stacks, unless you know what you are doing
#
# CONFIG_FIREWIRE is not set
# CONFIG_IEEE1394 is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
CONFIG_TUN=m
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
# CONFIG_NET_ETHERNET is not set
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
# CONFIG_E1000E is not set
# CONFIG_IP1000 is not set
# CONFIG_IGB is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
CONFIG_SKY2=m
CONFIG_SKY2_DEBUG=y
# CONFIG_VIA_VELOCITY is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2 is not set
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_JME is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
CONFIG_WLAN_80211=y
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_LIBERTAS is not set
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_AIRO is not set
# CONFIG_HERMES is not set
# CONFIG_ATMEL is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
# CONFIG_ADM8211 is not set
# CONFIG_MAC80211_HWSIM is not set
# CONFIG_P54_COMMON is not set
# CONFIG_ATH5K is not set
# CONFIG_ATH9K is not set
# CONFIG_IWLCORE is not set
# CONFIG_IWLWIFI_LEDS is not set
# CONFIG_IWLAGN is not set
# CONFIG_IWL3945 is not set
# CONFIG_HOSTAP is not set
CONFIG_B43=m
CONFIG_B43_PCI_AUTOSELECT=y
CONFIG_B43_PCICORE_AUTOSELECT=y
CONFIG_B43_LEDS=y
CONFIG_B43_DEBUG=y
# CONFIG_B43_FORCE_PIO is not set
# CONFIG_B43LEGACY is not set
# CONFIG_ZD1211RW is not set
# CONFIG_RT2X00 is not set

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET is not set
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_NET_FC is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
CONFIG_DEVKMEM=y
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_INTEL=y
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_NVRAM is not set
CONFIG_RTC=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=y
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
# CONFIG_I2C is not set
# CONFIG_SPI is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_HWMON is not set
CONFIG_THERMAL=y
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
CONFIG_SSB_B43_PCI_BRIDGE=y
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_REGULATOR is not set

#
# Multimedia devices
#

#
# Multimedia core support
#
# CONFIG_VIDEO_DEV is not set
# CONFIG_DVB_CORE is not set
# CONFIG_VIDEO_MEDIA is not set

#
# Multimedia drivers
#
# CONFIG_DAB is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
# CONFIG_AGP_INTEL is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_VIA is not set
# CONFIG_DRM is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
# CONFIG_FB is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=256
CONFIG_DUMMY_CONSOLE=y
CONFIG_SOUND=y
# CONFIG_SOUND_OSS_CORE is not set
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_SEQUENCER=m
# CONFIG_SND_SEQ_DUMMY is not set
# CONFIG_SND_MIXER_OSS is not set
# CONFIG_SND_PCM_OSS is not set
# CONFIG_SND_SEQUENCER_OSS is not set
# CONFIG_SND_RTCTIMER is not set
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_SUPPORT_OLD_API=y
# CONFIG_SND_VERBOSE_PROCFS is not set
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_DRIVERS=y
# CONFIG_SND_PCSP is not set
# CONFIG_SND_DUMMY is not set
# CONFIG_SND_VIRMIDI is not set
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_SERIAL_U16550 is not set
# CONFIG_SND_MPU401 is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDA_INTEL=y
# CONFIG_SND_HDA_HWDEP is not set
# CONFIG_SND_HDA_INPUT_BEEP is not set
CONFIG_SND_HDA_CODEC_REALTEK=y
# CONFIG_SND_HDA_CODEC_ANALOG is not set
# CONFIG_SND_HDA_CODEC_SIGMATEL is not set
# CONFIG_SND_HDA_CODEC_VIA is not set
# CONFIG_SND_HDA_CODEC_ATIHDMI is not set
# CONFIG_SND_HDA_CODEC_NVHDMI is not set
# CONFIG_SND_HDA_CODEC_CONEXANT is not set
# CONFIG_SND_HDA_CODEC_CMEDIA is not set
# CONFIG_SND_HDA_CODEC_SI3054 is not set
CONFIG_SND_HDA_GENERIC=y
# CONFIG_SND_HDA_POWER_SAVE is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_HIFIER is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
# CONFIG_SND_USB is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
# CONFIG_HID_DEBUG is not set
# CONFIG_HIDRAW is not set

#
# USB Input Devices
#
CONFIG_USB_HID=y
# CONFIG_HID_PID is not set
CONFIG_USB_HIDDEV=y

#
# Special HID drivers
#
CONFIG_HID_COMPAT=y
CONFIG_HID_A4TECH=y
CONFIG_HID_APPLE=y
CONFIG_HID_BELKIN=y
CONFIG_HID_BRIGHT=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
CONFIG_HID_DELL=y
CONFIG_HID_EZKEY=y
CONFIG_HID_GYRATION=y
CONFIG_HID_LOGITECH=y
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SONY=y
CONFIG_HID_SUNPLUS=y
# CONFIG_THRUSTMASTER_FF is not set
# CONFIG_ZEROPLUS_FF is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
# CONFIG_USB_DEVICE_CLASS is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
# CONFIG_USB_MON is not set
# CONFIG_USB_WUSB is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_EHCI_HCD=y
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_OHCI_HCD is not set
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_WHCI_HCD is not set
# CONFIG_USB_HWA_HCD is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
CONFIG_USB_PRINTER=y
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may also be needed;
#

#
# see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_DPCM is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_PHIDGET is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_VST is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_HP_DISK is not set
# CONFIG_LEDS_CLEVO_MAIL is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_IDE_DISK is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y

#
# DMA Devices
#
# CONFIG_INTEL_IOATDMA is not set
# CONFIG_UIO is not set
# CONFIG_STAGING is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
# CONFIG_DMIID is not set
# CONFIG_ISCSI_IBFT_FIND is not set

#
# File systems
#
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
# CONFIG_EXT2_FS_SECURITY is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
# CONFIG_EXT3_FS_SECURITY is not set
CONFIG_EXT4_FS=y
# CONFIG_EXT4DEV_COMPAT is not set
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS_POSIX_ACL=y
# CONFIG_EXT4_FS_SECURITY is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
# CONFIG_AUTOFS_FS is not set
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=m
CONFIG_GENERIC_ACL=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
# CONFIG_ZISOFS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=y
CONFIG_NTFS_DEBUG=y
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
# CONFIG_PROC_VMCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y

#
# Miscellaneous filesystems
#
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
CONFIG_CRAMFS=m
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V3=y
# CONFIG_NFS_V3_ACL is not set
# CONFIG_NFS_V4 is not set
CONFIG_NFSD=m
CONFIG_NFSD_V3=y
# CONFIG_NFSD_V3_ACL is not set
# CONFIG_NFSD_V4 is not set
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
# CONFIG_SUNRPC_REGISTER_V4 is not set
# CONFIG_RPCSEC_GSS_KRB5 is not set
# CONFIG_RPCSEC_GSS_SPKM3 is not set
# CONFIG_SMB_FS is not set
CONFIG_CIFS=m
CONFIG_CIFS_STATS=y
# CONFIG_CIFS_STATS2 is not set
# CONFIG_CIFS_WEAK_PW_HASH is not set
# CONFIG_CIFS_XATTR is not set
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_EXPERIMENTAL is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=y
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
# CONFIG_DEBUG_KERNEL is not set
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_STACKTRACE=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_FRAME_POINTER=y
# CONFIG_RCU_CPU_STALL_DETECTOR is not set
CONFIG_LATENCYTOP=y
CONFIG_SYSCTL_SYSCALL_CHECK=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y

#
# Tracers
#
# CONFIG_SYSPROF_TRACER is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_BUILD_DOCSRC is not set
# CONFIG_DYNAMIC_PRINTK_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_STRICT_DEVMEM is not set
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
CONFIG_OPTIMIZE_INLINING=y

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
# CONFIG_CRYPTO_FIPS is not set
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_GF128MUL is not set
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_CRYPTD is not set
# CONFIG_CRYPTO_AUTHENC is not set
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_SEQIV is not set

#
# Block modes
#
# CONFIG_CRYPTO_CBC is not set
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_PCBC is not set
# CONFIG_CRYPTO_XTS is not set

#
# Hash modes
#
# CONFIG_CRYPTO_HMAC is not set
# CONFIG_CRYPTO_XCBC is not set

#
# Digest
#
# CONFIG_CRYPTO_CRC32C is not set
# CONFIG_CRYPTO_CRC32C_INTEL is not set
# CONFIG_CRYPTO_MD4 is not set
# CONFIG_CRYPTO_MD5 is not set
CONFIG_CRYPTO_MICHAEL_MIC=m
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
# CONFIG_CRYPTO_SHA1 is not set
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_X86_64 is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_X86_64 is not set

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
# CONFIG_KVM_AMD is not set
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
# CONFIG_CRC_CCITT is not set
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
# CONFIG_LIBCRC32C is not set
CONFIG_ZLIB_INFLATE=m
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y



lspci -vvv
00:00.0 Host bridge: Intel Corporation 82P965/G965 Memory Controller Hub 
(rev 02)
	Subsystem: Giga-byte Technology Device 5000
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: <access denied>

00:01.0 PCI bridge: Intel Corporation 82P965/G965 PCI Express Root Port 
(rev 02)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 00008000-00008fff
	Memory behind bridge: f0000000-f2ffffff
	Prefetchable memory behind bridge: 00000000e0000000-00000000efffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport-driver

00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI 
Controller #4 (rev 02)
	Subsystem: Giga-byte Technology Device 5004
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 4: I/O ports at c000 [size=32]
	Kernel driver in use: uhci_hcd

00:1a.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI 
Controller #5 (rev 02)
	Subsystem: Giga-byte Technology Device 5004
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 21
	Region 4: I/O ports at c400 [size=32]
	Kernel driver in use: uhci_hcd

00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI 
Controller #2 (rev 02) (prog-if 20)
	Subsystem: Giga-byte Technology Device 5006
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at f5205000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: <access denied>
	Kernel driver in use: ehci_hcd

00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio 
Controller (rev 02)
	Subsystem: Giga-byte Technology Device a002
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 22
	Region 0: Memory at f5200000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>
	Kernel driver in use: HDA Intel

00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express 
Port 1 (rev 02)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 00007000-00007fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport-driver

00:1c.3 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express 
Port 4 (rev 02)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 00009000-0000afff
	Memory behind bridge: f5000000-f50fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport-driver

00:1c.4 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express 
Port 5 (rev 02)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
	I/O behind bridge: 0000b000-0000bfff
	Memory behind bridge: f3000000-f4ffffff
	Prefetchable memory behind bridge: 00000000f5300000-00000000f53fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport-driver

00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI 
Controller #1 (rev 02)
	Subsystem: Giga-byte Technology Device 5004
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 23
	Region 4: I/O ports at c800 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI 
Controller #2 (rev 02)
	Subsystem: Giga-byte Technology Device 5004
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 19
	Region 4: I/O ports at cc00 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.2 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI 
Controller #3 (rev 02)
	Subsystem: Giga-byte Technology Device 5004
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 18
	Region 4: I/O ports at d000 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI 
Controller #1 (rev 02) (prog-if 20)
	Subsystem: Giga-byte Technology Device 5006
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at f5204000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: <access denied>
	Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev f2) (prog-if 01)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=05, subordinate=05, sec-latency=32
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: f5100000-f51fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>

00:1f.0 ISA bridge: Intel Corporation 82801HB/HR (ICH8/R) LPC Interface 
Controller (rev 02)
	Subsystem: Giga-byte Technology Device 5001
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: <access denied>

00:1f.2 IDE interface: Intel Corporation 82801H (ICH8 Family) 4 port 
SATA IDE Controller (rev 02) (prog-if 8a [Master SecP PriP])
	Subsystem: Giga-byte Technology Device b002
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 19
	Region 0: I/O ports at 01f0 [size=8]
	Region 1: I/O ports at 03f4 [size=1]
	Region 2: I/O ports at 0170 [size=8]
	Region 3: I/O ports at 0374 [size=1]
	Region 4: I/O ports at f000 [size=16]
	Region 5: I/O ports at fc00 [size=16]
	Capabilities: <access denied>
	Kernel driver in use: ata_piix
	Kernel modules: ide-pci-generic

00:1f.3 SMBus: Intel Corporation 82801H (ICH8 Family) SMBus Controller 
(rev 02)
	Subsystem: Giga-byte Technology Device 5001
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin C routed to IRQ 9
	Region 0: Memory at f5206000 (32-bit, non-prefetchable) [size=256]
	Region 4: I/O ports at 0500 [size=32]

00:1f.5 IDE interface: Intel Corporation 82801H (ICH8 Family) 2 port 
SATA IDE Controller (rev 02) (prog-if 85 [Master SecO PriO])
	Subsystem: Giga-byte Technology Device b002
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 19
	Region 0: I/O ports at d800 [size=8]
	Region 1: I/O ports at dc00 [size=4]
	Region 2: I/O ports at e000 [size=8]
	Region 3: I/O ports at e400 [size=4]
	Region 4: I/O ports at e800 [size=16]
	Region 5: I/O ports at ec00 [size=16]
	Capabilities: <access denied>
	Kernel driver in use: ata_piix
	Kernel modules: ide-pci-generic

01:00.0 VGA compatible controller: nVidia Corporation G71 [GeForce 7900 
GS] (rev a1)
	Subsystem: eVga.com. Corp. Device c624
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at f0000000 (32-bit, non-prefetchable) [size=16M]
	Region 1: Memory at e0000000 (64-bit, prefetchable) [size=256M]
	Region 3: Memory at f1000000 (64-bit, non-prefetchable) [size=16M]
	Region 5: I/O ports at 8000 [size=128]
	[virtual] Expansion ROM at f2000000 [disabled] [size=128K]
	Capabilities: <access denied>
	Kernel driver in use: nvidia
	Kernel modules: nvidia

03:00.0 SATA controller: JMicron Technologies, Inc. JMicron 20360/20363 
AHCI Controller (rev 02) (prog-if 01)
	Subsystem: Giga-byte Technology Device b000
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 11
	Region 5: Memory at f5000000 (32-bit, non-prefetchable) [size=8K]
	Capabilities: <access denied>

03:00.1 IDE interface: JMicron Technologies, Inc. JMicron 20360/20363 
AHCI Controller (rev 02) (prog-if 85 [Master SecO PriO])
	Subsystem: Giga-byte Technology Device b000
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 16
	Region 0: I/O ports at 9000 [size=8]
	Region 1: I/O ports at 9400 [size=4]
	Region 2: I/O ports at 9800 [size=8]
	Region 3: I/O ports at 9c00 [size=4]
	Region 4: I/O ports at a000 [size=16]
	Capabilities: <access denied>
	Kernel driver in use: JMicron IDE
	Kernel modules: ide-pci-generic

04:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8053 PCI-E 
Gigabit Ethernet Controller (rev 22)
	Subsystem: Giga-byte Technology Device e000
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 315
	Region 0: Memory at f4000000 (64-bit, non-prefetchable) [size=16K]
	Region 2: I/O ports at b000 [size=256]
	[virtual] Expansion ROM at f5300000 [disabled] [size=128K]
	Capabilities: <access denied>
	Kernel driver in use: sky2
	Kernel modules: sky2

05:01.0 Network controller: Broadcom Corporation BCM4318 [AirForce One 
54g] 802.11g Wireless LAN Controller (rev 02)
	Subsystem: Belkin Device 7c0a
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 32
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at f5100000 (32-bit, non-prefetchable) [size=8K]
	Kernel driver in use: b43-pci-bridge
	Kernel modules: ssb

