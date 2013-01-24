Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f169.google.com ([209.85.220.169]:45011 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab3AXE41 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2013 23:56:27 -0500
Received: by mail-vc0-f169.google.com with SMTP id n10so1873220vcn.28
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jan 2013 20:56:26 -0800 (PST)
Message-ID: <5100BEF7.4000107@gnoutcheff.name> (sfid-20130124_055633_555778_99BB9D3A)
Date: Wed, 23 Jan 2013 23:56:23 -0500
From: Daniel Gnoutcheff <daniel@gnoutcheff.name>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: [ath5k] [bugreport] BIOS hang if wifi was connected before reboot
Content-Type: multipart/mixed;
 boundary="------------080604080303010306030408"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080604080303010306030408
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello all,

I have a Lenovo Thinkpad R61 7733A82 running Ubuntu 12.10 on kernel 
3.7.4 with an Atheros AR5212 PCI-Express wireless card which is reported 
in dmesg as:
   ath5k: phy0: Atheros AR5414 chip found (MAC: 0xa3, PHY: 0x61)

If I connect this card to some network and then perform a warm reboot 
without disconnecting from that network, then the system seems to lock 
up in the middle of the BIOS self-test.

For example, if I stop NetworkManager and wpa_supplicant and issue the 
commands:
   iw dev wlan0 set type ibss
   ip link set dev wlan0 up
   iw wlan0 ibss join gnoutchd 2412
   shutdown -r now
then the system appears to shut down correctly, and the screen blanks as 
it normally does when rebooting, and I can even hear the CD-DVD drive 
resetting itself, but then it locks up just before the point where I'd 
expect the BIOS splash screen to appear.

However, if I issue 'ip link set dev wlan0 down' *before* I reboot, then 
the system reboots perfectly.   Omitting the 'iw wlan0 ibss join' step 
also prevents the hang.

If I'm within range of a WPA network, I can also reproduce the hang with 
something like
   wpa_supplicant -c wpa_supplicant.conf -iwlan0 &
   # wait for connection to complete
   killall -SIGKILL wpa_supplicant
   shutdown -r now
I also get the hang if I leave wpa_supplicant running and if my 
initscripts never send it any signals (e.g. if its pid file is in 
/run/sendsigs.omit.d).

However, if I give wpa_supplicant the chance to cleanup and disconnect 
(i.e. if I or my initscripts send it a SIGINT or a SIGTERM or a 'wpa_cli 
terminate'), then I don't get the hang.

These are just the examples I've looked into closely.  I've also 
observed the same hang if I reboot while connected to any of a variety 
of wifi networks that I use, which include both open networks and WPA 
networks.

This bug is present in a kernel v3.7.4 and wireless-testing commit 
9d9540984a75ec4d0e59a33ce7d34581fd5b561b, but I've also seen in in 
kernels as old as 2.6.31.  I have installed the latest BIOS update 
available for this machine.

Up until recently, it seems that NetworkManager would always disconnect 
upon shutdown and thus avoided this bug, but this changed in Ubuntu 
12.10.  FWIW, I've attached the dmesg log for connecting to a WPA 
network and then disconnecting from it cleanly.  Please let me know if 
there's anything I can do to help debug this.

Thanks!

Have a good one,
Daniel

--------------080604080303010306030408
Content-Type: text/plain; charset=UTF-8;
 name="dmesg-3.8.0-rc4-wl-wpa_supplicant_with_cleanup.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg-3.8.0-rc4-wl-wpa_supplicant_with_cleanup.txt"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.8.0-rc4-wl (gnoutchd@dan-lap) (gcc version 4.7.2 (Ubuntu/Linaro 4.7.2-2ubuntu1) ) #28 SMP Wed Jan 23 20:59:15 EST 2013
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.8.0-rc4-wl root=UUID=d03dbee7-efb8-45ae-bdbc-e06fb7d61b04 ro recovery nomodeset
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000d2000-0x00000000000d3fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007d6affff] usable
[    0.000000] BIOS-e820: [mem 0x000000007d6b0000-0x000000007d6cbfff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007d6cc000-0x000000007d6fffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000007d700000-0x000000007dffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f0000000-0x00000000f3ffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec0ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed003ff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed14000-0x00000000fed19fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed8ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: LENOVO 7733A82/7733A82, BIOS 7LETD0WW (2.30 ) 02/27/2012
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x7d6b0 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DFFFF uncachable
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 07E000000 mask FFE000000 uncachable
[    0.000000]   1 base 000000000 mask F80000000 write-back
[    0.000000]   2 base 07D700000 mask FFFF00000 uncachable
[    0.000000]   3 base 07D800000 mask FFF800000 uncachable
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 2016MB, range: 32MB, type UC
[    0.000000] reg 1, base: 0GB, range: 2GB, type WB
[    0.000000] reg 2, base: 2007MB, range: 1MB, type UC
[    0.000000] reg 3, base: 2008MB, range: 8MB, type UC
[    0.000000] total RAM covered: 2007M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 64M 	num_reg: 4  	lose cover RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2007MB, range: 1MB, type UC
[    0.000000] reg 2, base: 2008MB, range: 8MB, type UC
[    0.000000] reg 3, base: 2016MB, range: 32MB, type UC
[    0.000000] found SMP MP-table at [mem 0x000f68f0-0x000f68ff] mapped at [ffff8800000f68f0]
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x7d6affff]
[    0.000000]  [mem 0x00000000-0x7d5fffff] page 2M
[    0.000000]  [mem 0x7d600000-0x7d6affff] page 4k
[    0.000000] kernel direct mapping tables up to 0x7d6affff @ [mem 0x1fffc000-0x1fffffff]
[    0.000000] RAMDISK: [mem 0x357e2000-0x36be8fff]
[    0.000000] ACPI: RSDP 00000000000f68c0 00024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 000000007d6bb614 00094 (v01 LENOVO TP-7L    00002300  LTP 00000000)
[    0.000000] ACPI: FACP 000000007d6bb700 000F4 (v03 LENOVO TP-7L    00002300 LNVO 00000001)
[    0.000000] ACPI BIOS Bug: Warning: 32/64X length mismatch in FADT/Gpe1Block: 0/32 (20121018/tbfadt-567)
[    0.000000] ACPI BIOS Bug: Warning: Optional FADT field Gpe1Block has zero address or length: 0x000000000000102C/0x0 (20121018/tbfadt-598)
[    0.000000] ACPI: DSDT 000000007d6bbb1d 1003C (v01 LENOVO TP-7L    00002300 MSFT 03000000)
[    0.000000] ACPI: FACS 000000007d6e4000 00040
[    0.000000] ACPI: SSDT 000000007d6bb8b4 00269 (v01 LENOVO TP-7L    00002300 MSFT 03000000)
[    0.000000] ACPI: ECDT 000000007d6cbb59 00052 (v01 LENOVO TP-7L    00002300 LNVO 00000001)
[    0.000000] ACPI: TCPA 000000007d6cbbab 00032 (v02 LENOVO TP-7L    00002300 LNVO 00000001)
[    0.000000] ACPI: APIC 000000007d6cbbdd 00068 (v01 LENOVO TP-7L    00002300 LNVO 00000001)
[    0.000000] ACPI: MCFG 000000007d6cbc45 0003C (v01 LENOVO TP-7L    00002300 LNVO 00000001)
[    0.000000] ACPI: HPET 000000007d6cbc81 00038 (v01 LENOVO TP-7L    00002300 LNVO 00000001)
[    0.000000] ACPI: SLIC 000000007d6cbdf0 00176 (v01 LENOVO TP-7L    00002300  LTP 00000000)
[    0.000000] ACPI: BOOT 000000007d6cbf66 00028 (v01 LENOVO TP-7L    00002300  LTP 00000001)
[    0.000000] ACPI: ASF! 000000007d6cbf8e 00072 (v16 LENOVO TP-7L    00002300 PTL  00000001)
[    0.000000] ACPI: SSDT 000000007d6e26d9 0025F (v01 LENOVO TP-7L    00002300 INTL 20050513)
[    0.000000] ACPI: SSDT 000000007d6e2938 000A6 (v01 LENOVO TP-7L    00002300 INTL 20050513)
[    0.000000] ACPI: SSDT 000000007d6e29de 004F7 (v01 LENOVO TP-7L    00002300 INTL 20050513)
[    0.000000] ACPI: SSDT 000000007d6e2ed5 001D8 (v01 LENOVO TP-7L    00002300 INTL 20050513)
[    0.000000] ACPI: DMI detected: Lenovo ThinkPad R61
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000007d6affff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x7d6affff]
[    0.000000]   NODE_DATA [mem 0x7d6ac000-0x7d6affff]
[    0.000000]  [ffffea0000000000-ffffea0001ffffff] PMD -> [ffff88007ae00000-ffff88007cdfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009cfff]
[    0.000000]   node   0: [mem 0x00100000-0x7d6affff]
[    0.000000] On node 0 totalpages: 513597
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3911 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7963 pages used for memmap
[    0.000000]   DMA32 zone: 501653 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000d2000
[    0.000000] PM: Registered nosave memory: 00000000000d2000 - 00000000000d4000
[    0.000000] PM: Registered nosave memory: 00000000000d4000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] e820: [mem 0x7e000000-0xefffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88007d400000 s80064 r8192 d22336 u1048576
[    0.000000] pcpu-alloc: s80064 r8192 d22336 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 505564
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.8.0-rc4-wl root=UUID=d03dbee7-efb8-45ae-bdbc-e06fb7d61b04 ro recovery nomodeset
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 1987452k/2054848k available (6087k kernel code, 460k absent, 66936k reserved, 4980k data, 908k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=256 to nr_cpu_ids=2.
[    0.000000] NR_IRQS:16640 nr_irqs:512 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 1995.025 MHz processor
[    0.004003] Calibrating delay loop (skipped), value calculated using timer frequency.. 3990.05 BogoMIPS (lpj=7980100)
[    0.004111] pid_max: default: 32768 minimum: 301
[    0.004193] Security Framework initialized
[    0.004458] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.005694] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.008318] Mount-cache hash table entries: 256
[    0.008604] Initializing cgroup subsys cpuacct
[    0.008655] Initializing cgroup subsys devices
[    0.008706] Initializing cgroup subsys freezer
[    0.008755] Initializing cgroup subsys net_cls
[    0.008810] Initializing cgroup subsys blkio
[    0.008861] Initializing cgroup subsys perf_event
[    0.008942] CPU: Physical Processor ID: 0
[    0.008994] CPU: Processor Core ID: 0
[    0.009047] mce: CPU supports 6 MCE banks
[    0.009105] CPU0: Thermal monitoring enabled (TM2)
[    0.009160] process: using mwait in idle threads
[    0.009213] Last level iTLB entries: 4KB 128, 2MB 4, 4MB 4
[    0.009213] Last level dTLB entries: 4KB 256, 2MB 0, 4MB 32
[    0.009213] tlb_flushall_shift: -1
[    0.009416] Freeing SMP alternatives: 24k freed
[    0.011975] ACPI: Core revision 20121018
[    0.024016] ftrace: allocating 22962 entries in 90 pages
[    0.036547] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.079072] smpboot: CPU0: Intel(R) Core(TM)2 Duo CPU     T7300  @ 2.00GHz (fam: 06, model: 0f, stepping: 0a)
[    0.080000] Performance Events: PEBS fmt0+, 4-deep LBR, Core2 events, Intel PMU driver.
[    0.080000] perf_event_intel: PEBS disabled due to CPU errata
[    0.080000] ... version:                2
[    0.080000] ... bit width:              40
[    0.080000] ... generic registers:      2
[    0.080000] ... value mask:             000000ffffffffff
[    0.080000] ... max period:             000000007fffffff
[    0.080000] ... fixed-purpose events:   3
[    0.080000] ... event mask:             0000000700000003
[    0.080000] smpboot: Booting Node   0, Processors  #1 OK
[    0.090914] TSC synchronization [CPU#0 -> CPU#1]:
[    0.090983] Measured 363140 cycles TSC warp between CPUs, turning off TSC clock.
[    0.091057] tsc: Marking TSC unstable due to check_tsc_sync_source failed
[    0.091141] Brought up 2 CPUs
[    0.091206] smpboot: Total of 2 processors activated (7980.10 BogoMIPS)
[    0.092099] devtmpfs: initialized
[    0.092256] PM: Registering ACPI NVS region [mem 0x7d6cc000-0x7d6fffff] (212992 bytes)
[    0.093291] regulator-dummy: no parameters
[    0.093396] RTC time:  2:42:49, date: 01/24/13
[    0.093503] NET: Registered protocol family 16
[    0.093728] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.093805] ACPI: bus type pci registered
[    0.093914] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf0000000-0xf3ffffff] (base 0xf0000000)
[    0.093996] PCI: MMCONFIG at [mem 0xf0000000-0xf3ffffff] reserved in E820
[    0.101673] PCI: Using configuration type 1 for base access
[    0.102581] bio: create slab <bio-0> at 0
[    0.102581] ACPI: Added _OSI(Module Device)
[    0.102581] ACPI: Added _OSI(Processor Device)
[    0.102581] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.102581] ACPI: Added _OSI(Processor Aggregator Device)
[    0.102581] ACPI: Added _OSI(Linux)
[    0.102581] ACPI: EC: EC description table is found, configuring boot EC
[    0.108992] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query honored via DMI
[    0.120861] ACPI: SSDT 000000007d6e1b32 002C4 (v01  PmRef  Cpu0Ist 00000100 INTL 20050513)
[    0.121655] ACPI: Dynamic OEM Table Load:
[    0.121813] ACPI: SSDT           (null) 002C4 (v01  PmRef  Cpu0Ist 00000100 INTL 20050513)
[    0.122716] ACPI: SSDT 000000007d6e1e7b 0085E (v01  PmRef  Cpu0Cst 00000100 INTL 20050513)
[    0.123538] ACPI: Dynamic OEM Table Load:
[    0.123688] ACPI: SSDT           (null) 0085E (v01  PmRef  Cpu0Cst 00000100 INTL 20050513)
[    0.123864] ACPI: SSDT 000000007d6e1a6a 000C8 (v01  PmRef  Cpu1Ist 00000100 INTL 20050513)
[    0.123864] ACPI: Dynamic OEM Table Load:
[    0.123864] ACPI: SSDT           (null) 000C8 (v01  PmRef  Cpu1Ist 00000100 INTL 20050513)
[    0.123864] ACPI: SSDT 000000007d6e1df6 00085 (v01  PmRef  Cpu1Cst 00000100 INTL 20050513)
[    0.123864] ACPI: Dynamic OEM Table Load:
[    0.123864] ACPI: SSDT           (null) 00085 (v01  PmRef  Cpu1Cst 00000100 INTL 20050513)
[    0.124213] ACPI: Interpreter enabled
[    0.124276] ACPI: (supports S0 S3 S4 S5)
[    0.124520] ACPI: Using IOAPIC for interrupt routing
[    0.129257] ACPI: Power Resource [PUBS] (on)
[    0.132254] ACPI: EC: GPE = 0x12, I/O: command/status = 0x66, data = 0x62
[    0.132947] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.133011] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.133111] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.133172] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.133646] pci_root PNP0A08:00: Requesting ACPI _OSC control (0x1d)
[    0.134056] pci_root PNP0A08:00: ACPI _OSC control (0x1d) granted
[    0.134152] pci_root PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-3f] only partially covers this bridge
[    0.134266] PCI host bridge to bus 0000:00
[    0.134327] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.134390] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.134451] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.134515] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.134583] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
[    0.134649] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    0.134715] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
[    0.134779] pci_bus 0000:00: root bus resource [mem 0x7e000000-0xfebfffff]
[    0.134846] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed4bfff]
[    0.134921] pci 0000:00:00.0: [8086:2a00] type 00 class 0x060000
[    0.134975] pci 0000:00:02.0: [8086:2a02] type 00 class 0x030000
[    0.134991] pci 0000:00:02.0: reg 10: [mem 0xf8100000-0xf81fffff 64bit]
[    0.135001] pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.135008] pci 0000:00:02.0: reg 20: [io  0x1800-0x1807]
[    0.135051] pci 0000:00:02.1: [8086:2a03] type 00 class 0x038000
[    0.135064] pci 0000:00:02.1: reg 10: [mem 0xf8200000-0xf82fffff 64bit]
[    0.135217] pci 0000:00:19.0: [8086:1049] type 00 class 0x020000
[    0.135265] pci 0000:00:19.0: reg 10: [mem 0xfe000000-0xfe01ffff]
[    0.135285] pci 0000:00:19.0: reg 14: [mem 0xfe025000-0xfe025fff]
[    0.135305] pci 0000:00:19.0: reg 18: [io  0x1840-0x185f]
[    0.135470] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.135512] pci 0000:00:1a.0: [8086:2834] type 00 class 0x0c0300
[    0.136068] pci 0000:00:1a.0: reg 20: [io  0x1860-0x187f]
[    0.136150] pci 0000:00:1a.1: [8086:2835] type 00 class 0x0c0300
[    0.136262] pci 0000:00:1a.1: reg 20: [io  0x1880-0x189f]
[    0.136368] pci 0000:00:1a.7: [8086:283a] type 00 class 0x0c0320
[    0.136407] pci 0000:00:1a.7: reg 10: [mem 0xfe226c00-0xfe226fff]
[    0.136580] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.136640] pci 0000:00:1b.0: [8086:284b] type 00 class 0x040300
[    0.136684] pci 0000:00:1b.0: reg 10: [mem 0xfe020000-0xfe023fff 64bit]
[    0.136875] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.136936] pci 0000:00:1c.0: [8086:283f] type 01 class 0x060400
[    0.137154] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.137207] pci 0000:00:1c.1: [8086:2841] type 01 class 0x060400
[    0.137405] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.137463] pci 0000:00:1c.2: [8086:2843] type 01 class 0x060400
[    0.137667] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.137727] pci 0000:00:1c.3: [8086:2845] type 01 class 0x060400
[    0.137928] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.137988] pci 0000:00:1c.4: [8086:2847] type 01 class 0x060400
[    0.138188] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.138249] pci 0000:00:1d.0: [8086:2830] type 00 class 0x0c0300
[    0.138350] pci 0000:00:1d.0: reg 20: [io  0x18a0-0x18bf]
[    0.138436] pci 0000:00:1d.1: [8086:2831] type 00 class 0x0c0300
[    0.138541] pci 0000:00:1d.1: reg 20: [io  0x18c0-0x18df]
[    0.138616] pci 0000:00:1d.2: [8086:2832] type 00 class 0x0c0300
[    0.138710] pci 0000:00:1d.2: reg 20: [io  0x18e0-0x18ff]
[    0.138810] pci 0000:00:1d.7: [8086:2836] type 00 class 0x0c0320
[    0.138859] pci 0000:00:1d.7: reg 10: [mem 0xfe227000-0xfe2273ff]
[    0.139060] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.139106] pci 0000:00:1e.0: [8086:2448] type 01 class 0x060401
[    0.139285] pci 0000:00:1f.0: [8086:2811] type 00 class 0x060100
[    0.139462] pci 0000:00:1f.0: quirk: [io  0x1000-0x107f] claimed by ICH6 ACPI/GPIO/TCO
[    0.139547] pci 0000:00:1f.0: quirk: [io  0x1180-0x11bf] claimed by ICH6 GPIO
[    0.139613] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 1600 (mask 007f)
[    0.139693] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 15e0 (mask 000f)
[    0.139770] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 1680 (mask 001f)
[    0.139936] pci 0000:00:1f.1: [8086:2850] type 00 class 0x01018a
[    0.139963] pci 0000:00:1f.1: reg 10: [io  0x0000-0x0007]
[    0.139988] pci 0000:00:1f.1: reg 14: [io  0x0000-0x0003]
[    0.140013] pci 0000:00:1f.1: reg 18: [io  0x0000-0x0007]
[    0.140033] pci 0000:00:1f.1: reg 1c: [io  0x0000-0x0003]
[    0.140056] pci 0000:00:1f.1: reg 20: [io  0x1c00-0x1c0f]
[    0.140155] pci 0000:00:1f.2: [8086:2829] type 00 class 0x010601
[    0.140205] pci 0000:00:1f.2: reg 10: [io  0x1c50-0x1c57]
[    0.140224] pci 0000:00:1f.2: reg 14: [io  0x1c44-0x1c47]
[    0.140242] pci 0000:00:1f.2: reg 18: [io  0x1c48-0x1c4f]
[    0.140262] pci 0000:00:1f.2: reg 1c: [io  0x1c40-0x1c43]
[    0.140288] pci 0000:00:1f.2: reg 20: [io  0x1c20-0x1c3f]
[    0.140310] pci 0000:00:1f.2: reg 24: [mem 0xfe226000-0xfe2267ff]
[    0.140437] pci 0000:00:1f.2: PME# supported from D3hot
[    0.140486] pci 0000:00:1f.3: [8086:283e] type 00 class 0x0c0500
[    0.140516] pci 0000:00:1f.3: reg 10: [mem 0xfe227400-0xfe2274ff]
[    0.140589] pci 0000:00:1f.3: reg 20: [io  0x1c60-0x1c7f]
[    0.140781] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.140850] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.140856] pci 0000:00:1c.0:   bridge window [mem 0xfc000000-0xfdffffff]
[    0.140874] pci 0000:00:1c.0:   bridge window [mem 0xf8000000-0xf80fffff 64bit pref]
[    0.141013] pci 0000:03:00.0: [168c:1014] type 00 class 0x020000
[    0.141047] pci 0000:03:00.0: reg 10: [mem 0xdf3f0000-0xdf3fffff 64bit]
[    0.152028] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.152098] pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
[    0.152105] pci 0000:00:1c.1:   bridge window [mem 0xdc000000-0xdf3fffff]
[    0.152121] pci 0000:00:1c.1:   bridge window [mem 0xdfe00000-0xdfefffff 64bit pref]
[    0.152234] pci 0000:00:1c.2: PCI bridge to [bus 04]
[    0.152303] pci 0000:00:1c.2:   bridge window [io  0x4000-0x4fff]
[    0.152313] pci 0000:00:1c.2:   bridge window [mem 0xd8000000-0xd9ffffff]
[    0.152330] pci 0000:00:1c.2:   bridge window [mem 0xdfb00000-0xdfbfffff 64bit pref]
[    0.152441] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.152509] pci 0000:00:1c.3:   bridge window [io  0x5000-0x5fff]
[    0.152517] pci 0000:00:1c.3:   bridge window [mem 0xd4000000-0xd5ffffff]
[    0.152530] pci 0000:00:1c.3:   bridge window [mem 0xdf800000-0xdf8fffff 64bit pref]
[    0.152638] pci 0000:00:1c.4: PCI bridge to [bus 0d-14]
[    0.152709] pci 0000:00:1c.4:   bridge window [io  0x6000-0x6fff]
[    0.152717] pci 0000:00:1c.4:   bridge window [mem 0xd0000000-0xd1ffffff]
[    0.152730] pci 0000:00:1c.4:   bridge window [mem 0xdf500000-0xdf5fffff 64bit pref]
[    0.152818] pci 0000:15:00.0: [1180:0476] type 02 class 0x060700
[    0.152857] pci 0000:15:00.0: proprietary Ricoh MMC controller disabled (via cardbus function)
[    0.152933] pci 0000:15:00.0: MMC cards are now supported by standard SDHCI controller
[    0.153037] pci 0000:15:00.0: reg 10: [mem 0xf8300000-0xf8300fff]
[    0.153109] pci 0000:15:00.0: supports D1 D2
[    0.153112] pci 0000:15:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.153158] pci 0000:15:00.1: [1180:0832] type 00 class 0x0c0010
[    0.153205] pci 0000:15:00.1: reg 10: [mem 0xf8301000-0xf83017ff]
[    0.153398] pci 0000:15:00.1: supports D1 D2
[    0.153400] pci 0000:15:00.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.153445] pci 0000:15:00.2: [1180:0822] type 00 class 0x080500
[    0.153486] pci 0000:15:00.2: reg 10: [mem 0xf8301800-0xf83018ff]
[    0.153680] pci 0000:15:00.2: supports D1 D2
[    0.153683] pci 0000:15:00.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.153731] pci 0000:15:00.4: [1180:0592] type 00 class 0x088000
[    0.153771] pci 0000:15:00.4: reg 10: [mem 0xf8302000-0xf83020ff]
[    0.153969] pci 0000:15:00.4: supports D1 D2
[    0.153971] pci 0000:15:00.4: PME# supported from D0 D1 D2 D3hot D3cold
[    0.154012] pci 0000:15:00.5: [1180:0852] type 00 class 0x088000
[    0.154057] pci 0000:15:00.5: reg 10: [mem 0xf8302400-0xf83024ff]
[    0.154244] pci 0000:15:00.5: supports D1 D2
[    0.154247] pci 0000:15:00.5: PME# supported from D0 D1 D2 D3hot D3cold
[    0.154380] pci 0000:00:1e.0: PCI bridge to [bus 15-18] (subtractive decode)
[    0.154451] pci 0000:00:1e.0:   bridge window [io  0x7000-0xafff]
[    0.154458] pci 0000:00:1e.0:   bridge window [mem 0xf8300000-0xfbffffff]
[    0.154471] pci 0000:00:1e.0:   bridge window [mem 0xf4000000-0xf7ffffff 64bit pref]
[    0.154474] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.154477] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.154480] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.154483] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
[    0.154486] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
[    0.154488] pci 0000:00:1e.0:   bridge window [mem 0x000dc000-0x000dffff] (subtractive decode)
[    0.154491] pci 0000:00:1e.0:   bridge window [mem 0x7e000000-0xfebfffff] (subtractive decode)
[    0.154494] pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfed4bfff] (subtractive decode)
[    0.154571] pci_bus 0000:16: busn_res: can not insert [bus 16-ff] under [bus 15-18] (conflicts with (null) [bus 15-18])
[    0.154579] pci_bus 0000:16: busn_res: [bus 16-ff] end is updated to 17
[    0.154678] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
[    0.154710] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.154744] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
[    0.154772] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
[    0.154804] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP4._PRT]
[    0.154836] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[    0.160382] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 *10 11)
[    0.160845] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    0.161305] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    0.161764] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    0.162223] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    0.162681] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
[    0.163140] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
[    0.163598] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    0.164065] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.164087] vgaarb: loaded
[    0.164134] vgaarb: bridge control possible 0000:00:02.0
[    0.164330] SCSI subsystem initialized
[    0.164381] ACPI: bus type scsi registered
[    0.164439] libata version 3.00 loaded.
[    0.164439] ACPI: bus type usb registered
[    0.164439] usbcore: registered new interface driver usbfs
[    0.164439] usbcore: registered new interface driver hub
[    0.164439] usbcore: registered new device driver usb
[    0.168040] PCI: Using ACPI for IRQ routing
[    0.170763] PCI: pci_cache_line_size set to 64 bytes
[    0.170888] e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
[    0.170891] e820: reserve RAM buffer [mem 0x7d6b0000-0x7fffffff]
[    0.170994] NetLabel: Initializing
[    0.171043] NetLabel:  domain hash size = 128
[    0.171093] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.171155] NetLabel:  unlabeled traffic allowed by default
[    0.171222] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.171222] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.171222] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.173015] Switching to clocksource hpet
[    0.179474] pnp: PnP ACPI init
[    0.179550] ACPI: bus type pnp registered
[    0.180132] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.180190] system 00:00: [mem 0x000c0000-0x000c3fff] could not be reserved
[    0.180245] system 00:00: [mem 0x000c4000-0x000c7fff] could not be reserved
[    0.180299] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
[    0.180355] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
[    0.180409] system 00:00: [mem 0x000d0000-0x000d3fff] could not be reserved
[    0.180464] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
[    0.180520] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
[    0.180575] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
[    0.180631] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
[    0.180686] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
[    0.180740] system 00:00: [mem 0x00100000-0x7dffffff] could not be reserved
[    0.180796] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
[    0.180851] system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
[    0.180907] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.181052] system 00:01: [io  0x164e-0x164f] has been reserved
[    0.181106] system 00:01: [io  0x1000-0x107f] has been reserved
[    0.181162] system 00:01: [io  0x1180-0x11bf] has been reserved
[    0.181215] system 00:01: [io  0x0800-0x080f] has been reserved
[    0.181269] system 00:01: [io  0x15e0-0x15ef] has been reserved
[    0.181322] system 00:01: [io  0x1600-0x165f] could not be reserved
[    0.181376] system 00:01: [mem 0xf0000000-0xf3ffffff] has been reserved
[    0.181430] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.181484] system 00:01: [mem 0xfed14000-0xfed17fff] has been reserved
[    0.181538] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.181592] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.181646] system 00:01: [mem 0xfed45000-0xfed4bfff] has been reserved
[    0.181701] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.181765] pnp 00:02: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.181777] pnp 00:03: [dma 4]
[    0.181803] pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.181838] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.181884] pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.181921] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.181957] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.181994] pnp 00:08: Plug and Play ACPI device, IDs IBM0057 PNP0f13 (active)
[    0.182409] pnp 00:09: Plug and Play ACPI device, IDs ATM1200 PNP0c31 (active)
[    0.182946] pnp: PnP ACPI: found 10 devices
[    0.182997] ACPI: ACPI bus type pnp unregistered
[    0.190167] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.190223] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.190280] pci 0000:00:1c.0:   bridge window [mem 0xfc000000-0xfdffffff]
[    0.190338] pci 0000:00:1c.0:   bridge window [mem 0xf8000000-0xf80fffff 64bit pref]
[    0.190408] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.190461] pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
[    0.190519] pci 0000:00:1c.1:   bridge window [mem 0xdc000000-0xdf3fffff]
[    0.190576] pci 0000:00:1c.1:   bridge window [mem 0xdfe00000-0xdfefffff 64bit pref]
[    0.190647] pci 0000:00:1c.2: PCI bridge to [bus 04]
[    0.190700] pci 0000:00:1c.2:   bridge window [io  0x4000-0x4fff]
[    0.190758] pci 0000:00:1c.2:   bridge window [mem 0xd8000000-0xd9ffffff]
[    0.190815] pci 0000:00:1c.2:   bridge window [mem 0xdfb00000-0xdfbfffff 64bit pref]
[    0.190885] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.190939] pci 0000:00:1c.3:   bridge window [io  0x5000-0x5fff]
[    0.190996] pci 0000:00:1c.3:   bridge window [mem 0xd4000000-0xd5ffffff]
[    0.191053] pci 0000:00:1c.3:   bridge window [mem 0xdf800000-0xdf8fffff 64bit pref]
[    0.191123] pci 0000:00:1c.4: PCI bridge to [bus 0d-14]
[    0.191177] pci 0000:00:1c.4:   bridge window [io  0x6000-0x6fff]
[    0.191234] pci 0000:00:1c.4:   bridge window [mem 0xd0000000-0xd1ffffff]
[    0.191291] pci 0000:00:1c.4:   bridge window [mem 0xdf500000-0xdf5fffff 64bit pref]
[    0.191365] pci 0000:15:00.0: res[15]=[mem 0x04000000-0x03ffffff pref] get_res_add_size add_size 4000000
[    0.191368] pci 0000:15:00.0: res[16]=[mem 0x04000000-0x03ffffff] get_res_add_size add_size 4000000
[    0.191371] pci 0000:15:00.0: res[13]=[io  0x0100-0x00ff] get_res_add_size add_size 100
[    0.191374] pci 0000:15:00.0: res[14]=[io  0x0100-0x00ff] get_res_add_size add_size 100
[    0.191380] pci 0000:15:00.0: BAR 15: assigned [mem 0xf4000000-0xf7ffffff pref]
[    0.191446] pci 0000:15:00.0: BAR 16: assigned [mem 0x80000000-0x83ffffff]
[    0.191500] pci 0000:15:00.0: BAR 13: assigned [io  0x7000-0x70ff]
[    0.191553] pci 0000:15:00.0: BAR 14: assigned [io  0x7400-0x74ff]
[    0.191607] pci 0000:15:00.0: CardBus bridge to [bus 16-17]
[    0.191660] pci 0000:15:00.0:   bridge window [io  0x7000-0x70ff]
[    0.191717] pci 0000:15:00.0:   bridge window [io  0x7400-0x74ff]
[    0.191774] pci 0000:15:00.0:   bridge window [mem 0xf4000000-0xf7ffffff pref]
[    0.191842] pci 0000:15:00.0:   bridge window [mem 0x80000000-0x83ffffff]
[    0.191900] pci 0000:00:1e.0: PCI bridge to [bus 15-18]
[    0.191953] pci 0000:00:1e.0:   bridge window [io  0x7000-0xafff]
[    0.192024] pci 0000:00:1e.0:   bridge window [mem 0xf8300000-0xfbffffff]
[    0.192081] pci 0000:00:1e.0:   bridge window [mem 0xf4000000-0xf7ffffff 64bit pref]
[    0.192200] pci 0000:00:1e.0: enabling device (0005 -> 0007)
[    0.192257] pci 0000:00:1e.0: setting latency timer to 64
[    0.192275] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.192278] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.192281] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.192283] pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff]
[    0.192286] pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff]
[    0.192289] pci_bus 0000:00: resource 9 [mem 0x000dc000-0x000dffff]
[    0.192291] pci_bus 0000:00: resource 10 [mem 0x7e000000-0xfebfffff]
[    0.192294] pci_bus 0000:00: resource 11 [mem 0xfed40000-0xfed4bfff]
[    0.192297] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
[    0.192300] pci_bus 0000:02: resource 1 [mem 0xfc000000-0xfdffffff]
[    0.192303] pci_bus 0000:02: resource 2 [mem 0xf8000000-0xf80fffff 64bit pref]
[    0.192305] pci_bus 0000:03: resource 0 [io  0x3000-0x3fff]
[    0.192308] pci_bus 0000:03: resource 1 [mem 0xdc000000-0xdf3fffff]
[    0.192311] pci_bus 0000:03: resource 2 [mem 0xdfe00000-0xdfefffff 64bit pref]
[    0.192314] pci_bus 0000:04: resource 0 [io  0x4000-0x4fff]
[    0.192316] pci_bus 0000:04: resource 1 [mem 0xd8000000-0xd9ffffff]
[    0.192319] pci_bus 0000:04: resource 2 [mem 0xdfb00000-0xdfbfffff 64bit pref]
[    0.192322] pci_bus 0000:05: resource 0 [io  0x5000-0x5fff]
[    0.192324] pci_bus 0000:05: resource 1 [mem 0xd4000000-0xd5ffffff]
[    0.192327] pci_bus 0000:05: resource 2 [mem 0xdf800000-0xdf8fffff 64bit pref]
[    0.192330] pci_bus 0000:0d: resource 0 [io  0x6000-0x6fff]
[    0.192332] pci_bus 0000:0d: resource 1 [mem 0xd0000000-0xd1ffffff]
[    0.192335] pci_bus 0000:0d: resource 2 [mem 0xdf500000-0xdf5fffff 64bit pref]
[    0.192338] pci_bus 0000:15: resource 0 [io  0x7000-0xafff]
[    0.192341] pci_bus 0000:15: resource 1 [mem 0xf8300000-0xfbffffff]
[    0.192343] pci_bus 0000:15: resource 2 [mem 0xf4000000-0xf7ffffff 64bit pref]
[    0.192346] pci_bus 0000:15: resource 4 [io  0x0000-0x0cf7]
[    0.192348] pci_bus 0000:15: resource 5 [io  0x0d00-0xffff]
[    0.192351] pci_bus 0000:15: resource 6 [mem 0x000a0000-0x000bffff]
[    0.192354] pci_bus 0000:15: resource 7 [mem 0x000d4000-0x000d7fff]
[    0.192356] pci_bus 0000:15: resource 8 [mem 0x000d8000-0x000dbfff]
[    0.192359] pci_bus 0000:15: resource 9 [mem 0x000dc000-0x000dffff]
[    0.192362] pci_bus 0000:15: resource 10 [mem 0x7e000000-0xfebfffff]
[    0.192364] pci_bus 0000:15: resource 11 [mem 0xfed40000-0xfed4bfff]
[    0.192367] pci_bus 0000:16: resource 0 [io  0x7000-0x70ff]
[    0.192370] pci_bus 0000:16: resource 1 [io  0x7400-0x74ff]
[    0.192372] pci_bus 0000:16: resource 2 [mem 0xf4000000-0xf7ffffff pref]
[    0.192375] pci_bus 0000:16: resource 3 [mem 0x80000000-0x83ffffff]
[    0.192414] NET: Registered protocol family 2
[    0.192637] TCP established hash table entries: 16384 (order: 6, 262144 bytes)
[    0.192836] TCP bind hash table entries: 16384 (order: 6, 262144 bytes)
[    0.193000] TCP: Hash tables configured (established 16384 bind 16384)
[    0.193108] TCP: reno registered
[    0.193162] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    0.193232] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    0.193347] NET: Registered protocol family 1
[    0.193409] pci 0000:00:02.0: Boot video device
[    0.193449] pci 0000:00:1a.1: power state changed by ACPI to D0
[    0.193575] pci 0000:00:1d.0: power state changed by ACPI to D0
[    0.193680] pci 0000:00:1d.2: power state changed by ACPI to D0
[    0.193808] PCI: CLS mismatch (64 != 32), using 64 bytes
[    0.193857] Trying to unpack rootfs image as initramfs...
[    0.667043] Freeing initrd memory: 20508k freed
[    0.679966] Simple Boot Flag at 0x35 set to 0x1
[    0.680461] audit: initializing netlink socket (disabled)
[    0.680533] type=2000 audit(1358995369.680:1): initialized
[    0.709029] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.710865] VFS: Disk quotas dquot_6.5.2
[    0.710969] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.711588] fuse init (API version 7.20)
[    0.711733] msgmni has been set to 3921
[    0.712205] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.712898] io scheduler noop registered
[    0.712950] io scheduler deadline registered
[    0.713005] io scheduler cfq registered (default)
[    0.713235] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    0.713416] pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
[    0.713593] pcieport 0000:00:1c.2: irq 42 for MSI/MSI-X
[    0.713765] pcieport 0000:00:1c.3: irq 43 for MSI/MSI-X
[    0.713938] pcieport 0000:00:1c.4: irq 44 for MSI/MSI-X
[    0.714081] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[    0.714139] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
[    0.714163] pcieport 0000:00:1c.1: Signaling PME through PCIe PME interrupt
[    0.714218] pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
[    0.714274] pcie_pme 0000:00:1c.1:pcie01: service driver pcie_pme loaded
[    0.714300] pcieport 0000:00:1c.2: Signaling PME through PCIe PME interrupt
[    0.714358] pcie_pme 0000:00:1c.2:pcie01: service driver pcie_pme loaded
[    0.714381] pcieport 0000:00:1c.3: Signaling PME through PCIe PME interrupt
[    0.714439] pcie_pme 0000:00:1c.3:pcie01: service driver pcie_pme loaded
[    0.714462] pcieport 0000:00:1c.4: Signaling PME through PCIe PME interrupt
[    0.714520] pcie_pme 0000:00:1c.4:pcie01: service driver pcie_pme loaded
[    0.714541] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.714664] pciehp: Using ACPI for slot detection.
[    0.714751] pciehp 0000:00:1c.3:pcie04: HPC vendor_id 8086 device_id 2845 ss_vid 17aa ss_did 20ad
[    0.714837] pciehp 0000:00:1c.3:pcie04: service driver pciehp loaded
[    0.714850] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.714927] intel_idle: does not run on family 6 model 15
[    0.715080] ACPI: Deprecated procfs I/F for AC is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    0.715291] ACPI: AC Adapter [AC] (on-line)
[    0.715495] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
[    0.715765] ACPI: Lid Switch [LID]
[    0.715856] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input1
[    0.715924] ACPI: Sleep Button [SLPB]
[    0.716037] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    0.716109] ACPI: Power Button [PWRF]
[    0.716237] ACPI: Requesting acpi_cpufreq
[    0.718268] Monitor-Mwait will be used to enter C-1 state
[    0.718276] Monitor-Mwait will be used to enter C-2 state
[    0.718282] Monitor-Mwait will be used to enter C-3 state
[    0.718296] ACPI: acpi_idle registered with cpuidle
[    0.725080] thermal LNXTHERM:00: registered as thermal_zone0
[    0.725134] ACPI: Thermal Zone [THM0] (71 C)
[    0.726424] thermal LNXTHERM:01: registered as thermal_zone1
[    0.726477] ACPI: Thermal Zone [THM1] (82 C)
[    0.726607] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    0.728964] Linux agpgart interface v0.103
[    0.729180] agpgart-intel 0000:00:00.0: Intel 965GM Chipset
[    0.729312] agpgart-intel 0000:00:00.0: detected gtt size: 524288K total, 262144K mappable
[    0.730457] agpgart-intel 0000:00:00.0: detected 8192K stolen memory
[    0.730743] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
[    0.732995] brd: module loaded
[    0.734199] loop: module loaded
[    0.734405] ata_piix 0000:00:1f.1: version 2.13
[    0.734489] ata_piix 0000:00:1f.1: setting latency timer to 64
[    0.734980] scsi0 : ata_piix
[    0.735302] scsi1 : ata_piix
[    0.735463] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1c00 irq 14
[    0.735556] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1c08 irq 15
[    0.736104] libphy: Fixed MDIO Bus: probed
[    0.736211] PPP generic driver version 2.4.2
[    0.736586] ata2: port disabled--ignoring
[    0.736639] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.736706] ehci-pci: EHCI PCI platform driver
[    0.736835] ehci-pci 0000:00:1a.7: setting latency timer to 64
[    0.736842] ehci-pci 0000:00:1a.7: EHCI Host Controller
[    0.737012] ehci-pci 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    0.741072] ehci-pci 0000:00:1a.7: cache line size of 64 is not supported
[    0.741093] ehci-pci 0000:00:1a.7: irq 22, io mem 0xfe226c00
[    0.741921] ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    0.741993] ACPI: Battery Slot [BAT0] (battery present)
[    0.752021] ehci-pci 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    0.752217] hub 1-0:1.0: USB hub found
[    0.752270] hub 1-0:1.0: 4 ports detected
[    0.752480] ehci-pci 0000:00:1d.7: setting latency timer to 64
[    0.752484] ehci-pci 0000:00:1d.7: EHCI Host Controller
[    0.752583] ehci-pci 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    0.752661] ehci-pci 0000:00:1d.7: debug port 1
[    0.756601] ehci-pci 0000:00:1d.7: cache line size of 64 is not supported
[    0.756619] ehci-pci 0000:00:1d.7: irq 19, io mem 0xfe227000
[    0.768021] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    0.768200] hub 2-0:1.0: USB hub found
[    0.768252] hub 2-0:1.0: 6 ports detected
[    0.768489] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.768553] uhci_hcd: USB Universal Host Controller Interface driver
[    0.768626] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    0.768630] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    0.768723] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    0.768824] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001860
[    0.769005] hub 3-0:1.0: USB hub found
[    0.769058] hub 3-0:1.0: 2 ports detected
[    0.769191] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    0.769195] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    0.769289] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    0.769389] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001880
[    0.769579] hub 4-0:1.0: USB hub found
[    0.769632] hub 4-0:1.0: 2 ports detected
[    0.769791] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    0.769795] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    0.769888] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
[    0.769988] uhci_hcd 0000:00:1d.0: irq 16, io base 0x000018a0
[    0.770165] hub 5-0:1.0: USB hub found
[    0.770217] hub 5-0:1.0: 2 ports detected
[    0.770352] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    0.770356] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    0.770457] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
[    0.770555] uhci_hcd 0000:00:1d.1: irq 17, io base 0x000018c0
[    0.770750] hub 6-0:1.0: USB hub found
[    0.770802] hub 6-0:1.0: 2 ports detected
[    0.770967] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    0.770971] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    0.771062] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
[    0.771162] uhci_hcd 0000:00:1d.2: irq 18, io base 0x000018e0
[    0.771341] hub 7-0:1.0: USB hub found
[    0.771394] hub 7-0:1.0: 2 ports detected
[    0.771562] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    0.779844] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.779901] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.780097] mousedev: PS/2 mouse device common for all mice
[    0.780336] rtc_cmos 00:06: RTC can wake from S4
[    0.780527] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    0.780610] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.780759] device-mapper: uevent: version 1.0.3
[    0.780878] device-mapper: ioctl: 4.23.1-ioctl (2012-12-18) initialised: dm-devel@redhat.com
[    0.780987] cpuidle: using governor ladder
[    0.781091] cpuidle: using governor menu
[    0.781141] EFI Variables Facility v0.08 2004-May-17
[    0.781286] TCP: cubic registered
[    0.781445] NET: Registered protocol family 10
[    0.781677] NET: Registered protocol family 17
[    0.781757] Key type dns_resolver registered
[    0.782151] PM: Hibernation image not present or could not be loaded.
[    0.782165] registered taskstats version 1
[    0.784855] Key type trusted registered
[    0.786171] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    0.787197] Key type encrypted registered
[    0.789957]   Magic number: 13:664:713
[    0.790137] rtc_cmos 00:06: setting system clock to 2013-01-24 02:42:50 UTC (1358995370)
[    0.793142] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    0.793200] EDD information not available.
[    0.900626] ata1.00: ATAPI: MATSHITADVD-RAM UJ-850, RB11, max UDMA/33
[    0.916526] ata1.00: configured for UDMA/33
[    0.918993] scsi 0:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ-850   RB11 PQ: 0 ANSI: 5
[    0.921427] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    0.921497] cdrom: Uniform CD-ROM driver Revision: 3.20
[    0.921688] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    0.921839] sr 0:0:0:0: Attached scsi generic sg0 type 5
[    0.923436] Freeing unused kernel memory: 908k freed
[    0.923770] Write protecting the kernel read-only data: 10240k
[    0.924171] Freeing unused kernel memory: 48k freed
[    0.928239] Freeing unused kernel memory: 1476k freed
[    0.947481] udevd[93]: starting version 175
[    1.014341] e1000e: Intel(R) PRO/1000 Network Driver - 2.1.4-k
[    1.014401] e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
[    1.014496] e1000e 0000:00:19.0: setting latency timer to 64
[    1.014577] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    1.014698] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
[    1.015061] [drm] Initialized drm 1.1.0 20060810
[    1.073436] sdhci: Secure Digital Host Controller Interface driver
[    1.073496] sdhci: Copyright(c) Pierre Ossman
[    1.074164] sdhci-pci 0000:15:00.2: SDHCI controller found [1180:0822] (rev 21)
[    1.075267] sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
[    1.075341] sdhci-pci 0000:15:00.2: setting latency timer to 64
[    1.075346] mmc0: no vqmmc regulator found
[    1.075397] mmc0: no vmmc regulator found
[    1.076454] sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
[    1.086012] pci 0000:00:02.0: setting latency timer to 64
[    1.115100] pci 0000:00:02.0: irq 46 for MSI/MSI-X
[    1.115110] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    1.115177] [drm] No driver support for vblank timestamp query.
[    1.120068] mmc0: SDHCI controller on PCI [0000:15:00.2] using DMA
[    1.125500] acpi device:01: registered as cooling_device2
[    1.125599] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    1.125696] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input4
[    1.126490] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    1.150796] sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
[    1.180077] usb 1-4: new high-speed USB device number 3 using ehci-pci
[    1.184172] firewire_ohci 0000:15:00.1: added OHCI v1.10 device as card 0, 4 IR + 4 IT contexts, quirks 0x11
[    1.210248] sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
[    1.270336] sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
[    1.317356] hub 1-4:1.0: USB hub found
[    1.319205] hub 1-4:1.0: 4 ports detected
[    1.330288] sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
[    1.334070] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 00:15:58:c6:29:b6
[    1.334139] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
[    1.334825] e1000e 0000:00:19.0 eth0: MAC: 6, PHY: 6, PBA No: FFFFFF-0FF
[    1.334904] ahci 0000:00:1f.2: version 3.0
[    1.334976] ahci 0000:00:1f.2: irq 47 for MSI/MSI-X
[    1.335044] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 1.5 Gbps 0x5 impl SATA mode
[    1.335109] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ccc 
[    1.335173] ahci 0000:00:1f.2: setting latency timer to 64
[    1.335794] scsi2 : ahci
[    1.336049] scsi3 : ahci
[    1.336214] scsi4 : ahci
[    1.336315] ata3: SATA max UDMA/133 abar m2048@0xfe226000 port 0xfe226100 irq 47
[    1.336381] ata4: DUMMY
[    1.336432] ata5: SATA max UDMA/133 abar m2048@0xfe226000 port 0xfe226200 irq 47
[    1.564063] usb 3-2: new full-speed USB device number 2 using uhci_hcd
[    1.656079] ata5: SATA link down (SStatus 0 SControl 300)
[    1.656160] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.657306] ata3.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    1.657310] ata3.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    1.657605] ata3.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
[    1.657609] ata3.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    1.658835] ata3.00: ATA-8: HITACHI HTS543212L9SA00, FBBZC48C, max UDMA/100
[    1.658897] ata3.00: 234441648 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.684182] firewire_core 0000:15:00.1: created device fw0: GUID 00016c2000168fc7, S400
[    1.831897] ata3.00: failed to get Identify Device Data, Emask 0x1
[    1.833599] ata3.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    1.833603] ata3.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    1.833973] ata3.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
[    1.833978] ata3.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    2.009689] ata3.00: failed to get Identify Device Data, Emask 0x1
[    2.009694] ata3.00: configured for UDMA/100
[    2.009935] scsi 2:0:0:0: Direct-Access     ATA      HITACHI HTS54321 FBBZ PQ: 0 ANSI: 5
[    2.010226] sd 2:0:0:0: Attached scsi generic sg1 type 0
[    2.010338] sd 2:0:0:0: [sda] 234441648 512-byte logical blocks: (120 GB/111 GiB)
[    2.010521] sd 2:0:0:0: [sda] Write Protect is off
[    2.010581] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.010601] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.028953]  sda: sda1 sda2
[    2.029337] sd 2:0:0:0: [sda] Attached SCSI disk
[    3.407755] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
[    6.705254] udevd[343]: starting version 175
[    8.214426] WARNING! power/level is deprecated; use power/control instead
[    9.318253] tpm_tis 00:09: 1.2 TPM (device-id 0x3203, rev-id 9)
[    9.319157] Non-volatile memory driver v1.3
[    9.342485] wmi: Mapper loaded
[   10.296226] tpm_tis 00:09: TPM is disabled/deactivated (0x6)
[   10.327330] r592 0000:15:00.4: setting latency timer to 64
[   10.327444] r592: driver successfully loaded
[   10.969608] yenta_cardbus 0000:15:00.0: CardBus bridge found [17aa:20c6]
[   11.096841] yenta_cardbus 0000:15:00.0: ISA IRQ mask 0x0cb8, PCI irq 16
[   11.096904] yenta_cardbus 0000:15:00.0: Socket status: 30000006
[   11.096966] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window: [io  0x7000-0xafff]
[   11.097036] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window: [mem 0xf8300000-0xfbffffff]
[   11.097107] pcmcia_socket pcmcia_socket0: cs: memory probe 0xf8300000-0xfbffffff:
[   11.097176]  excluding 0xf8300000-0xf86cffff
[   11.097303] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window: [mem 0xf4000000-0xf7ffffff 64bit pref]
[   11.097375] pcmcia_socket pcmcia_socket0: cs: memory probe 0xf4000000-0xf7ffffff:
[   11.097453]  excluding 0xf4000000-0xf7ffffff
[   11.378300] r852 0000:15:00.5: setting latency timer to 64
[   11.378389] r852: driver loaded successfully
[   11.389467] psmouse serio1: synaptics: Touchpad model: 1, fw: 6.2, id: 0x81a0b1, caps: 0xa04793/0x300000/0x0, board id: 71, fw id: 67352
[   11.389555] psmouse serio1: synaptics: serio: Synaptics pass-through port at isa0060/serio1/input0
[   11.431657] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input5
[   11.935965] cfg80211: Calling CRDA to update world regulatory domain
[   12.306267] pcmcia_socket pcmcia_socket0: cs: memory probe 0x0c0000-0x0fffff:
[   12.306334]  excluding 0xc0000-0xd3fff 0xe0000-0xfffff
[   12.306508] pcmcia_socket pcmcia_socket0: cs: memory probe 0xa0000000-0xa0ffffff:
[   12.306584]  clean.
[   12.306646] pcmcia_socket pcmcia_socket0: cs: memory probe 0x60000000-0x60ffffff:
[   12.306720]  excluding 0x60000000-0x60ffffff
[   13.452163] thinkpad_acpi: ThinkPad ACPI Extras v0.24
[   13.452168] thinkpad_acpi: http://ibm-acpi.sf.net/
[   13.452170] thinkpad_acpi: ThinkPad BIOS 7LETD0WW (2.30 ), EC 7KHT24WW-1.08
[   13.452172] thinkpad_acpi: Lenovo ThinkPad R61/R61i, model 7733A82
[   13.452550] thinkpad_acpi: detected a 8-level brightness capable ThinkPad
[   13.453999] thinkpad_acpi: ACPI backlight control delay disabled
[   13.454154] thinkpad_acpi: radio switch found; radios are enabled
[   13.454167] thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
[   13.454169] thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
[   13.458761] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one
[   13.459771] thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
[   13.460902] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input6
[   14.042511] cfg80211: World regulatory domain updated:
[   14.042516] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   14.042519] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   14.042521] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   14.042524] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   14.042526] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   14.042528] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   14.265652] hda_intel: probe_mask set to 0x1 for device 17aa:20ac
[   14.265731] snd_hda_intel 0000:00:1b.0: irq 48 for MSI/MSI-X
[   15.795964] ath5k 0000:03:00.0: registered as 'phy0'
[   16.404784] ath: EEPROM regdomain: 0x62
[   16.404787] ath: EEPROM indicates we should expect a direct regpair map
[   16.404790] ath: Country alpha2 being used: 00
[   16.404792] ath: Regpair used: 0x62
[   16.404795] cfg80211: Updating information on frequency 2412 MHz with regulatory rule:
[   16.404798] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   16.404800] cfg80211: Updating information on frequency 2417 MHz with regulatory rule:
[   16.404802] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   16.404804] cfg80211: Updating information on frequency 2422 MHz with regulatory rule:
[   16.404806] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   16.404814] cfg80211: Updating information on frequency 2427 MHz with regulatory rule:
[   16.404816] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   16.404817] cfg80211: Updating information on frequency 2432 MHz with regulatory rule:
[   16.404819] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   16.404821] cfg80211: Updating information on frequency 2437 MHz with regulatory rule:
[   16.404823] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   16.404825] cfg80211: Updating information on frequency 2442 MHz with regulatory rule:
[   16.404827] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   16.404828] cfg80211: Updating information on frequency 2447 MHz with regulatory rule:
[   16.404830] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   16.404832] cfg80211: Updating information on frequency 2452 MHz with regulatory rule:
[   16.404834] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   16.404836] cfg80211: Updating information on frequency 2457 MHz with regulatory rule:
[   16.404838] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   16.404839] cfg80211: Updating information on frequency 2462 MHz with regulatory rule:
[   16.404841] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   16.404843] cfg80211: Updating information on frequency 2467 MHz with regulatory rule:
[   16.404845] cfg80211: 2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   16.404847] cfg80211: Updating information on frequency 2472 MHz with regulatory rule:
[   16.404849] cfg80211: 2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   16.404850] cfg80211: Updating information on frequency 2484 MHz with regulatory rule:
[   16.404853] cfg80211: 2474000 KHz - 2494000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   16.404854] cfg80211: Disabling freq 5040 MHz as custom regd has no rule that fits it
[   16.404856] cfg80211: Disabling freq 5060 MHz as custom regd has no rule that fits it
[   16.404857] cfg80211: Disabling freq 5080 MHz as custom regd has no rule that fits it
[   16.404859] cfg80211: Updating information on frequency 5180 MHz with regulatory rule:
[   16.404861] cfg80211: 5140000 KHz - 5360000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[   16.404863] cfg80211: Updating information on frequency 5200 MHz with regulatory rule:
[   16.404865] cfg80211: 5140000 KHz - 5360000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[   16.404866] cfg80211: Updating information on frequency 5220 MHz with regulatory rule:
[   16.404869] cfg80211: 5140000 KHz - 5360000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[   16.404870] cfg80211: Updating information on frequency 5240 MHz with regulatory rule:
[   16.404872] cfg80211: 5140000 KHz - 5360000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[   16.404874] cfg80211: Updating information on frequency 5260 MHz with regulatory rule:
[   16.404876] cfg80211: 5140000 KHz - 5360000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[   16.404878] cfg80211: Updating information on frequency 5280 MHz with regulatory rule:
[   16.404880] cfg80211: 5140000 KHz - 5360000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[   16.404881] cfg80211: Updating information on frequency 5300 MHz with regulatory rule:
[   16.404883] cfg80211: 5140000 KHz - 5360000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[   16.404885] cfg80211: Updating information on frequency 5320 MHz with regulatory rule:
[   16.404887] cfg80211: 5140000 KHz - 5360000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[   16.404889] cfg80211: Updating information on frequency 5500 MHz with regulatory rule:
[   16.404891] cfg80211: 5460000 KHz - 5860000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[   16.404892] cfg80211: Updating information on frequency 5520 MHz with regulatory rule:
[   16.404894] cfg80211: 5460000 KHz - 5860000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[   16.404896] cfg80211: Updating information on frequency 5540 MHz with regulatory rule:
[   16.404898] cfg80211: 5460000 KHz - 5860000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[   16.404900] cfg80211: Updating information on frequency 5560 MHz with regulatory rule:
[   16.404902] cfg80211: 5460000 KHz - 5860000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[   16.404903] cfg80211: Updating information on frequency 5580 MHz with regulatory rule:
[   16.404905] cfg80211: 5460000 KHz - 5860000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[   16.404907] cfg80211: Updating information on frequency 5600 MHz with regulatory rule:
[   16.404909] cfg80211: 5460000 KHz - 5860000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[   16.404911] cfg80211: Updating information on frequency 5620 MHz with regulatory rule:
[   16.404913] cfg80211: 5460000 KHz - 5860000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[   16.404915] cfg80211: Updating information on frequency 5640 MHz with regulatory rule:
[   16.404917] cfg80211: 5460000 KHz - 5860000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[   16.404918] cfg80211: Updating information on frequency 5660 MHz with regulatory rule:
[   16.404920] cfg80211: 5460000 KHz - 5860000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[   16.404922] cfg80211: Updating information on frequency 5680 MHz with regulatory rule:
[   16.404924] cfg80211: 5460000 KHz - 5860000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[   16.404926] cfg80211: Updating information on frequency 5700 MHz with regulatory rule:
[   16.404928] cfg80211: 5460000 KHz - 5860000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[   16.404929] cfg80211: Updating information on frequency 5745 MHz with regulatory rule:
[   16.404931] cfg80211: 5460000 KHz - 5860000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[   16.404933] cfg80211: Updating information on frequency 5765 MHz with regulatory rule:
[   16.404935] cfg80211: 5460000 KHz - 5860000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[   16.404937] cfg80211: Updating information on frequency 5785 MHz with regulatory rule:
[   16.404939] cfg80211: 5460000 KHz - 5860000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[   16.404940] cfg80211: Updating information on frequency 5805 MHz with regulatory rule:
[   16.404943] cfg80211: 5460000 KHz - 5860000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[   16.404944] cfg80211: Updating information on frequency 5825 MHz with regulatory rule:
[   16.404946] cfg80211: 5460000 KHz - 5860000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[   16.404992] cfg80211: Ignoring regulatory request Set by core since the driver uses its own custom regulatory domain
[   16.460676] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[   16.461116] ath5k: phy0: Atheros AR5414 chip found (MAC: 0xa3, PHY: 0x61)
[   17.293350] psmouse serio2: trackpoint: IBM TrackPoint firmware: 0x0e, buttons: 3/3
[   17.526403] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/serio2/input/input7
[  125.796548] EXT4-fs (sda2): re-mounted. Opts: errors=remount-ro
[  229.546336] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  233.768348] wlan0: authenticate with 00:09:5b:d4:ec:24
[  233.777145] wlan0: send auth to 00:09:5b:d4:ec:24 (try 1/3)
[  233.778689] wlan0: authenticated
[  233.778713] ath5k 0000:03:00.0 wlan0: disabling HT/VHT due to WEP/TKIP use
[  233.778718] ath5k 0000:03:00.0 wlan0: disabling HT as WMM/QoS is not supported by the AP
[  233.778723] ath5k 0000:03:00.0 wlan0: disabling VHT as WMM/QoS is not supported by the AP
[  233.780070] wlan0: associate with 00:09:5b:d4:ec:24 (try 1/3)
[  233.782160] wlan0: RX AssocResp from 00:09:5b:d4:ec:24 (capab=0x431 status=0 aid=2)
[  233.782379] wlan0: associated
[  233.782394] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  265.423327] wlan0: deauthenticating from 00:09:5b:d4:ec:24 by local choice (reason=3)
[  265.423762] cfg80211: All devices are disconnected, going to restore regulatory settings
[  265.423766] cfg80211: Restoring regulatory settings
[  265.423770] cfg80211: Kicking the queue
[  265.423773] cfg80211: Calling CRDA to update world regulatory domain
[  265.427428] cfg80211: Ignoring regulatory request Set by core since the driver uses its own custom regulatory domain
[  265.427432] cfg80211: World regulatory domain updated:
[  265.427434] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[  265.427437] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  265.427439] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[  265.427441] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[  265.427444] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  265.427446] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)

--------------080604080303010306030408--
