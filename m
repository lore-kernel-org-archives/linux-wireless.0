Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:33334 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893Ab3F0Nik convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jun 2013 09:38:40 -0400
Received: by mail-ee0-f51.google.com with SMTP id e52so414413eek.10
        for <linux-wireless@vger.kernel.org>; Thu, 27 Jun 2013 06:38:38 -0700 (PDT)
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	"Berg, Johannes" <johannes.berg@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: 3.10.0-rc7-00135-g98b6ed0:  wrong command queue 0 (should be 4), sequence 0x4A readp=112 writep=112
Date: Thu, 27 Jun 2013 15:38:30 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201306271538.31234.a.miskiewicz@gmail.com> (sfid-20130627_153852_690173_487DC033)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


This time another problem in current Linus git, fresh boot. Fortunately
network still works fine after that.

3:00.0 Network controller: Intel Corporation PRO/Wireless 5350 AGN [Echo Peak] Network Connection

[   46.500256] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[ 4989.863668] ------------[ cut here ]------------
[ 4989.863689] WARNING: at drivers/net/wireless/iwlwifi/pcie/tx.c:1396 iwl_pcie_hcmd_complete+0xaa/0x371 [iwlwifi]()
[ 4989.863692] wrong command queue 0 (should be 4), sequence 0x4A readp=112 writep=112
[ 4989.863693] Modules linked in: xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter xt_conntrack nf_conntrack ip_tables x_tables tun rfcomm bnep sch_sfq joydev iTCO_wdt 
iTCO_vendor_support pcmcia ext2 mbcache coretemp psmouse microcode serio_raw sdhci_pci pcspkr arc4 sdhci firewire_ohci sr_mod yenta_socket cdrom firewire_core pcmcia_rsrc 
lpc_ich cdc_ether iwldvm mmc_core crc_itu_t pcmcia_core mfd_core i2c_i801 usbnet mac80211 mii cdc_wdm uvcvideo videobuf2_core kvm_intel iwlwifi kvm cdc_acm videodev btusb 
media e1000e videobuf2_vmalloc usbhid cfg80211 videobuf2_memops bluetooth thinkpad_acpi crc16 ptp snd_hda_codec_conexant pps_core thermal rfkill wmi snd_hda_intel ac nvram 
snd_hda_codec evdev battery snd_hwdep snd_pcm snd_timer snd soundcore snd_page_alloc cpufreq_stats acpi_cpufreq processor
[ 4989.863743]  tcp_illinois mperf ipv6 autofs4 xfs(F) libcrc32c(F) crc32c(F) cbc(F) ablk_helper(F) cryptd(F) lrw(F) gf128mul(F) glue_helper(F) aes_x86_64(F) dm_crypt(F) dm_mod(F) 
sd_mod(F) crc_t10dif(F) ahci(F) libahci(F) libata(F) scsi_mod(F) hid_logitech_dj(F) hid(F) uhci_hcd(F) ehci_pci(F) ehci_hcd(F) usbcore(F) usb_common(F)
[ 4989.863765] CPU: 0 PID: 3847 Comm: irq/52-iwlwifi Tainted: GF            3.10.0-rc7-00135-g98b6ed0 #504
[ 4989.863767] Hardware name: LENOVO 2764CTO/2764CTO, BIOS 7UET94WW (3.24 ) 10/17/2012
[ 4989.863769]  0000000000018264 ffff8802302d5c98 ffffffff813b9ee0 ffff8802302d5cd0
[ 4989.863772]  ffffffff81030f66 ffff8802302d5ce0 0000000080000008 ffff8802302d5e00
[ 4989.863775]  ffff8801f8fff080 ffff880231fb4000 ffff8802302d5d30 ffffffff81030fc5
[ 4989.863778] Call Trace:
[ 4989.863784]  [<ffffffff813b9ee0>] dump_stack+0x19/0x1b
[ 4989.863789]  [<ffffffff81030f66>] warn_slowpath_common+0x60/0x78
[ 4989.863792]  [<ffffffff81030fc5>] warn_slowpath_fmt+0x47/0x49
[ 4989.863797]  [<ffffffff8105d076>] ? set_next_entity+0x3f/0x96
[ 4989.863803]  [<ffffffffa04c8ab8>] iwl_pcie_hcmd_complete+0xaa/0x371 [iwlwifi]
[ 4989.863809]  [<ffffffffa04c6419>] iwl_pcie_irq_handler+0x660/0x79b [iwlwifi]
[ 4989.863814]  [<ffffffff81096d37>] ? irq_finalize_oneshot+0xb4/0xb4
[ 4989.863817]  [<ffffffff81096d50>] irq_thread_fn+0x19/0x31
[ 4989.863819]  [<ffffffff81096fa8>] irq_thread+0xd1/0x13c
[ 4989.863822]  [<ffffffff81096e41>] ? wake_threads_waitq+0x3f/0x3f
[ 4989.863825]  [<ffffffff81096ed7>] ? irq_thread_dtor+0x96/0x96
[ 4989.863829]  [<ffffffff8104d6d3>] kthread+0xb5/0xbd
[ 4989.863832]  [<ffffffff8104d61e>] ? kthread_create_on_node+0x113/0x113
[ 4989.863836]  [<ffffffff813bf4ec>] ret_from_fork+0x7c/0xb0
[ 4989.863839]  [<ffffffff8104d61e>] ? kthread_create_on_node+0x113/0x113
[ 4989.863841] ---[ end trace 20d78ce40090ed50 ]---
[ 4989.863844] iwl data: 00000000: 0e 00 50 f2 04 10 4a 00 01 10 10 44 00 01 02 dd  ..P...J....D....
[ 4989.863846] iwl data: 00000010: 00 00 00 00 1f 59 41 33 71 01 06 00 09 e0 00 00  .....YA3q.......




complete dmesg:
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.10.0-rc7-00135-g98b6ed0 (arekm@ixion-pld) (gcc version 4.8.1 20130531 (release) (PLD-Linux) ) #504 SMP PREEMPT Thu Jun 27 11:20:19 CEST 2013
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.10 root=/dev/mapper/lrootfs ro resume=/dev/sda2 panic=60 init=/bin/systemd systemd.unit=graphical.target pause_on_oops=30 
reboot=acpi
[    0.000000] Disabled fast string operations
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009ebff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009ec00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000dc000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bd4a0fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bd4a1000-0x00000000bd4a6fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bd4a7000-0x00000000bd5b6fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bd5b7000-0x00000000bd60efff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bd60f000-0x00000000bd6c5fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bd6c6000-0x00000000bd6d0fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bd6d1000-0x00000000bd6d3fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bd6d4000-0x00000000bd6d7fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bd6d8000-0x00000000bd6dbfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bd6dc000-0x00000000bd6defff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bd6df000-0x00000000bd705fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bd706000-0x00000000bd707fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bd708000-0x00000000bd90efff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bd90f000-0x00000000bd99efff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bd99f000-0x00000000bd9fefff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bd9ff000-0x00000000bd9fffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bdc00000-0x00000000bfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec0ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed003ff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed10000-0x00000000fed13fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed18000-0x00000000fed19fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed8ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff800000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000023bffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: LENOVO 2764CTO/2764CTO, BIOS 7UET94WW (3.24 ) 10/17/2012
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x23c000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 23C000000 mask FFC000000 uncachable
[    0.000000]   1 base 0BE000000 mask FFE000000 uncachable
[    0.000000]   2 base 000000000 mask F80000000 write-back
[    0.000000]   3 base 080000000 mask FC0000000 write-back
[    0.000000]   4 base 100000000 mask F00000000 write-back
[    0.000000]   5 base 200000000 mask FC0000000 write-back
[    0.000000]   6 base 0BDE00000 mask FFFE00000 uncachable
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0xbde00000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xbda00 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000f6480-0x000f648f] mapped at [ffff8800000f6480]
[    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01870000, 0x01870fff] PGTABLE
[    0.000000] BRK [0x01871000, 0x01871fff] PGTABLE
[    0.000000] BRK [0x01872000, 0x01872fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x23be00000-0x23bffffff]
[    0.000000]  [mem 0x23be00000-0x23bffffff] page 2M
[    0.000000] BRK [0x01873000, 0x01873fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x238000000-0x23bdfffff]
[    0.000000]  [mem 0x238000000-0x23bdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x200000000-0x237ffffff]
[    0.000000]  [mem 0x200000000-0x237ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xbd4a0fff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xbd3fffff] page 2M
[    0.000000]  [mem 0xbd400000-0xbd4a0fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xbd4a7000-0xbd5b6fff]
[    0.000000]  [mem 0xbd4a7000-0xbd5b6fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xbd60f000-0xbd6c5fff]
[    0.000000]  [mem 0xbd60f000-0xbd6c5fff] page 4k
[    0.000000] BRK [0x01874000, 0x01874fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xbd9ff000-0xbd9fffff]
[    0.000000]  [mem 0xbd9ff000-0xbd9fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x1ffffffff]
[    0.000000]  [mem 0x100000000-0x1ffffffff] page 2M
[    0.000000] RAMDISK: [mem 0x3780c000-0x37bfdfff]
[    0.000000] ACPI: RSDP 00000000000f6440 00024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 00000000bd949b3a 0009C (v01 LENOVO TP-7U    00003240  LTP 00000000)
[    0.000000] ACPI: FACP 00000000bd949c00 000F4 (v03 LENOVO TP-7U    00003240 LNVO 00000001)
[    0.000000] ACPI: DSDT 00000000bd94a00e 0FB01 (v01 LENOVO TP-7U    00003240 MSFT 03000000)
[    0.000000] ACPI: FACS 00000000bd98e000 00040
[    0.000000] ACPI: SSDT 00000000bd949db4 0025A (v01 LENOVO TP-7U    00003240 MSFT 03000000)
[    0.000000] ACPI: ECDT 00000000bd959b0f 00052 (v01 LENOVO TP-7U    00003240 LNVO 00000001)
[    0.000000] ACPI: APIC 00000000bd959b61 00078 (v01 LENOVO TP-7U    00003240 LNVO 00000001)
[    0.000000] ACPI: MCFG 00000000bd959bd9 0003C (v01 LENOVO TP-7U    00003240 LNVO 00000001)
[    0.000000] ACPI: HPET 00000000bd959c15 00038 (v01 LENOVO TP-7U    00003240 LNVO 00000001)
[    0.000000] ACPI: SLIC 00000000bd959dc2 00176 (v01 LENOVO TP-7U    00003240  LTP 00000000)
[    0.000000] ACPI: BOOT 00000000bd959f38 00028 (v01 LENOVO TP-7U    00003240  LTP 00000001)
[    0.000000] ACPI: ASF! 00000000bd959f60 000A0 (v16 LENOVO TP-7U    00003240 PTL  00000001)
[    0.000000] ACPI: SSDT 00000000bd98d1fa 00568 (v01 LENOVO TP-7U    00003240 INTL 20050513)
[    0.000000] ACPI: TCPA 00000000bd707000 00032 (v00                 00000000      00000000)
[    0.000000] ACPI: DMAR 00000000bd706000 00120 (v01               ? 00000001      00000000)
[    0.000000] ACPI: SSDT 00000000bd6d3000 00655 (v01  PmRef    CpuPm 00003000 INTL 20050624)
[    0.000000] ACPI: SSDT 00000000bd6d2000 00274 (v01  PmRef  Cpu0Tst 00003000 INTL 20050624)
[    0.000000] ACPI: SSDT 00000000bd6d1000 00242 (v01  PmRef    ApTst 00003000 INTL 20050624)
[    0.000000] ACPI: DMI detected: Lenovo ThinkPad T400
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea0008ffffff] PMD -> [ffff880233600000-ffff88023b5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x23bffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009dfff]
[    0.000000]   node   0: [mem 0x00100000-0xbd4a0fff]
[    0.000000]   node   0: [mem 0xbd4a7000-0xbd5b6fff]
[    0.000000]   node   0: [mem 0xbd60f000-0xbd6c5fff]
[    0.000000]   node   0: [mem 0xbd9ff000-0xbd9fffff]
[    0.000000]   node   0: [mem 0x100000000-0x23bffffff]
[    0.000000] On node 0 totalpages: 2070022
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3997 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 12058 pages used for memmap
[    0.000000]   DMA32 zone: 771689 pages, LIFO batch:31
[    0.000000]   Normal zone: 20224 pages used for memmap
[    0.000000]   Normal zone: 1294336 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
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
[    0.000000] smpboot: 4 Processors exceeds NR_CPUS limit of 2
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 000000000009f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000dc000
[    0.000000] PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bd4a1000 - 00000000bd4a7000
[    0.000000] PM: Registered nosave memory: 00000000bd5b7000 - 00000000bd60f000
[    0.000000] PM: Registered nosave memory: 00000000bd6c6000 - 00000000bd6d1000
[    0.000000] PM: Registered nosave memory: 00000000bd6d1000 - 00000000bd6d4000
[    0.000000] PM: Registered nosave memory: 00000000bd6d4000 - 00000000bd6d8000
[    0.000000] PM: Registered nosave memory: 00000000bd6d8000 - 00000000bd6dc000
[    0.000000] PM: Registered nosave memory: 00000000bd6dc000 - 00000000bd6df000
[    0.000000] PM: Registered nosave memory: 00000000bd6df000 - 00000000bd706000
[    0.000000] PM: Registered nosave memory: 00000000bd706000 - 00000000bd708000
[    0.000000] PM: Registered nosave memory: 00000000bd708000 - 00000000bd90f000
[    0.000000] PM: Registered nosave memory: 00000000bd90f000 - 00000000bd99f000
[    0.000000] PM: Registered nosave memory: 00000000bd99f000 - 00000000bd9ff000
[    0.000000] PM: Registered nosave memory: 00000000bda00000 - 00000000bdc00000
[    0.000000] PM: Registered nosave memory: 00000000bdc00000 - 00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fed00000
[    0.000000] PM: Registered nosave memory: 00000000fed00000 - 00000000fed10000
[    0.000000] PM: Registered nosave memory: 00000000fed10000 - 00000000fed14000
[    0.000000] PM: Registered nosave memory: 00000000fed14000 - 00000000fed18000
[    0.000000] PM: Registered nosave memory: 00000000fed18000 - 00000000fed1a000
[    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed90000
[    0.000000] PM: Registered nosave memory: 00000000fed90000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ff800000
[    0.000000] PM: Registered nosave memory: 00000000ff800000 - 0000000100000000
[    0.000000] e820: [mem 0xc0000000-0xdfffffff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88023bc00000 s79104 r8192 d23296 u1048576
[    0.000000] pcpu-alloc: s79104 r8192 d23296 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2037655
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.10 root=/dev/mapper/lrootfs ro resume=/dev/sda2 panic=60 init=/bin/systemd systemd.unit=graphical.target 
pause_on_oops=30 reboot=acpi
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.000000] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 8057488k/9371648k available (3853k kernel code, 1091560k absent, 222600k reserved, 2755k data, 844k init)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2526.719 MHz processor
[    0.004003] Calibrating delay loop (skipped), value calculated using timer frequency.. 5053.43 BogoMIPS (lpj=10106876)
[    0.004116] pid_max: default: 32768 minimum: 301
[    0.004199] Security Framework initialized
[    0.004263] Yama: becoming mindful.
[    0.004329] Mount-cache hash table entries: 256
[    0.004631] Initializing cgroup subsys devices
[    0.004687] Initializing cgroup subsys freezer
[    0.004742] Initializing cgroup subsys blkio
[    0.004796] Initializing cgroup subsys perf_event
[    0.004879] Disabled fast string operations
[    0.004937] CPU: Physical Processor ID: 0
[    0.004992] CPU: Processor Core ID: 0
[    0.005046] mce: CPU supports 6 MCE banks
[    0.005106] CPU0: Thermal monitoring enabled (TM2)
[    0.005166] Last level iTLB entries: 4KB 128, 2MB 4, 4MB 4
Last level dTLB entries: 4KB 256, 2MB 0, 4MB 32
tlb_flushall_shift: -1
[    0.008043] Freeing SMP alternatives: 16k freed
[    0.008107] ACPI: Core revision 20130328
[    0.016712] ACPI: All ACPI Tables successfully acquired
[    0.020089] dmar: Host address width 36
[    0.020146] dmar: DRHD base: 0x000000feb03000 flags: 0x0
[    0.020209] dmar: IOMMU 0: reg_base_addr feb03000 ver 1:0 cap c9008020e30260 ecap 1000
[    0.020279] dmar: DRHD base: 0x000000feb01000 flags: 0x0
[    0.020340] dmar: IOMMU 1: reg_base_addr feb01000 ver 1:0 cap c0000020630260 ecap 1000
[    0.020411] dmar: DRHD base: 0x000000feb00000 flags: 0x0
[    0.020472] dmar: IOMMU 2: reg_base_addr feb00000 ver 1:0 cap c0000020630270 ecap 1000
[    0.020543] dmar: DRHD base: 0x000000feb02000 flags: 0x1
[    0.020603] dmar: IOMMU 3: reg_base_addr feb02000 ver 1:0 cap c9008020630260 ecap 1000
[    0.020674] dmar: RMRR base: 0x000000fc226c00 end: 0x000000fc2273ff
[    0.020733] dmar: RMRR base: 0x000000bdc00000 end: 0x000000bfffffff
[    0.021301] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.061730] smpboot: CPU0: Intel(R) Core(TM)2 Duo CPU     T9400  @ 2.53GHz (fam: 06, model: 17, stepping: 06)
[    0.064000] Performance Events: PEBS fmt0+, 4-deep LBR, Core2 events, Intel PMU driver.
[    0.064000] ... version:                2
[    0.064000] ... bit width:              40
[    0.064000] ... generic registers:      2
[    0.064000] ... value mask:             000000ffffffffff
[    0.064000] ... max period:             000000007fffffff
[    0.064000] ... fixed-purpose events:   3
[    0.064000] ... event mask:             0000000700000003
[    0.092064] smpboot: Booting Node   0, Processors  #1 OK
[    0.008000] Disabled fast string operations
[    0.104050] Brought up 2 CPUs
[    0.104163] ----------------
[    0.104217] | NMI testsuite:
[    0.104271] --------------------
[    0.104325]   remote IPI:  ok  |
[    0.116097]    local IPI:  ok  |
[    0.140003] --------------------
[    0.140058] Good, all   2 testcases passed! |
[    0.140114] ---------------------------------
[    0.140171] smpboot: Total of 2 processors activated (10106.87 BogoMIPS)
[    0.143203] devtmpfs: initialized
[    0.143554] PM: Registering ACPI NVS region [mem 0xbd6c6000-0xbd6d0fff] (45056 bytes)
[    0.143554] PM: Registering ACPI NVS region [mem 0xbd6d8000-0xbd6dbfff] (16384 bytes)
[    0.143554] PM: Registering ACPI NVS region [mem 0xbd6df000-0xbd705fff] (159744 bytes)
[    0.143554] PM: Registering ACPI NVS region [mem 0xbd90f000-0xbd99efff] (589824 bytes)
[    0.144188] regulator-dummy: no parameters
[    0.144281] NET: Registered protocol family 16
[    0.144815] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.144886] ACPI: bus type PCI registered
[    0.145077] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000)
[    0.145151] PCI: MMCONFIG at [mem 0xe0000000-0xe3ffffff] reserved in E820
[    0.150210] PCI: Using configuration type 1 for base access
[    0.153550] bio: create slab <bio-0> at 0
[    0.153749] ACPI: Added _OSI(Module Device)
[    0.153806] ACPI: Added _OSI(Processor Device)
[    0.153862] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.153919] ACPI: Added _OSI(Processor Aggregator Device)
[    0.153977] ACPI: Added _OSI(Linux)
[    0.155703] ACPI: EC: EC description table is found, configuring boot EC
[    0.161948] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query honored via DMI
[    0.177648] ACPI: SSDT 00000000bd6d6c20 002C8 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
[    0.178200] ACPI: Dynamic OEM Table Load:
[    0.178336] ACPI: SSDT           (null) 002C8 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
[    0.178603] ACPI: SSDT 00000000bd6d4020 0087A (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
[    0.179185] ACPI: Dynamic OEM Table Load:
[    0.179321] ACPI: SSDT           (null) 0087A (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
[    0.201521] ACPI: SSDT 00000000bd6d5ca0 001CF (v01  PmRef    ApIst 00003000 INTL 20050624)
[    0.202090] ACPI: Dynamic OEM Table Load:
[    0.202225] ACPI: SSDT           (null) 001CF (v01  PmRef    ApIst 00003000 INTL 20050624)
[    0.212002] ACPI: SSDT 00000000bd6d5f20 0008D (v01  PmRef    ApCst 00003000 INTL 20050624)
[    0.212002] ACPI: Dynamic OEM Table Load:
[    0.212002] ACPI: SSDT           (null) 0008D (v01  PmRef    ApCst 00003000 INTL 20050624)
[    0.224151] ACPI: Interpreter enabled
[    0.224212] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20130328/hwxface-568)
[    0.224366] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130328/hwxface-568)
[    0.224530] ACPI: (supports S0 S3 S4 S5)
[    0.224586] ACPI: Using IOAPIC for interrupt routing
[    0.224680] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.225853] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.240310] ACPI: Power Resource [PUBS] (on)
[    0.250662] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.251221] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    0.251779] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    0.252319] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    0.252878] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    0.253436] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
[    0.253994] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
[    0.254552] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    0.255058] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.255253] acpi PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-3f] only partially covers this bridge
[    0.255421] PCI host bridge to bus 0000:00
[    0.255480] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.255538] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.255598] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.255657] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.255718] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
[    0.255778] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
[    0.255838] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    0.255899] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xfebfffff]
[    0.256006] pci 0000:00:00.0: [8086:2a40] type 00 class 0x060000
[    0.256025] DMAR: Forcing write-buffer flush capability
[    0.256082] DMAR: Disabling IOMMU for graphics on this chipset
[    0.256241] pci 0000:00:02.0: [8086:2a42] type 00 class 0x030000
[    0.256254] pci 0000:00:02.0: reg 10: [mem 0xf4400000-0xf47fffff 64bit]
[    0.256261] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.256267] pci 0000:00:02.0: reg 20: [io  0x1800-0x1807]
[    0.256355] pci 0000:00:02.1: [8086:2a43] type 00 class 0x038000
[    0.256366] pci 0000:00:02.1: reg 10: [mem 0xf4200000-0xf42fffff 64bit]
[    0.256493] pci 0000:00:03.0: [8086:2a44] type 00 class 0x078000
[    0.256509] pci 0000:00:03.0: reg 10: [mem 0xfc226800-0xfc22680f 64bit]
[    0.256559] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.256706] pci 0000:00:19.0: [8086:10f5] type 00 class 0x020000
[    0.256732] pci 0000:00:19.0: reg 10: [mem 0xfc000000-0xfc01ffff]
[    0.256743] pci 0000:00:19.0: reg 14: [mem 0xfc025000-0xfc025fff]
[    0.256755] pci 0000:00:19.0: reg 18: [io  0x1840-0x185f]
[    0.256843] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.256872] pci 0000:00:19.0: System wakeup disabled by ACPI
[    0.256994] pci 0000:00:1a.0: [8086:2937] type 00 class 0x0c0300
[    0.257050] pci 0000:00:1a.0: reg 20: [io  0x1860-0x187f]
[    0.257149] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.257271] pci 0000:00:1a.1: [8086:2938] type 00 class 0x0c0300
[    0.257328] pci 0000:00:1a.1: reg 20: [io  0x1880-0x189f]
[    0.257469] pci 0000:00:1a.2: [8086:2939] type 00 class 0x0c0300
[    0.257525] pci 0000:00:1a.2: reg 20: [io  0x18a0-0x18bf]
[    0.257626] pci 0000:00:1a.2: System wakeup disabled by ACPI
[    0.257760] pci 0000:00:1a.7: [8086:293c] type 00 class 0x0c0320
[    0.257786] pci 0000:00:1a.7: reg 10: [mem 0xfc226c00-0xfc226fff]
[    0.257894] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.257944] pci 0000:00:1a.7: System wakeup disabled by ACPI
[    0.258046] pci 0000:00:1b.0: [8086:293e] type 00 class 0x040300
[    0.258046] pci 0000:00:1b.0: reg 10: [mem 0xfc020000-0xfc023fff 64bit]
[    0.258046] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.258046] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.258354] pci 0000:00:1c.0: [8086:2940] type 01 class 0x060400
[    0.258354] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.258354] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.258614] pci 0000:00:1c.1: [8086:2942] type 01 class 0x060400
[    0.258614] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.258614] pci 0000:00:1c.1: System wakeup disabled by ACPI
[    0.258878] pci 0000:00:1c.3: [8086:2946] type 01 class 0x060400
[    0.258878] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.258878] pci 0000:00:1c.3: System wakeup disabled by ACPI
[    0.259141] pci 0000:00:1c.4: [8086:2948] type 01 class 0x060400
[    0.259141] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.259141] pci 0000:00:1c.4: System wakeup disabled by ACPI
[    0.259404] pci 0000:00:1d.0: [8086:2934] type 00 class 0x0c0300
[    0.259404] pci 0000:00:1d.0: reg 20: [io  0x18c0-0x18df]
[    0.259404] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.259680] pci 0000:00:1d.1: [8086:2935] type 00 class 0x0c0300
[    0.259680] pci 0000:00:1d.1: reg 20: [io  0x18e0-0x18ff]
[    0.259870] pci 0000:00:1d.2: [8086:2936] type 00 class 0x0c0300
[    0.259870] pci 0000:00:1d.2: reg 20: [io  0x1c00-0x1c1f]
[    0.260064] pci 0000:00:1d.7: [8086:293a] type 00 class 0x0c0320
[    0.260064] pci 0000:00:1d.7: reg 10: [mem 0xfc227000-0xfc2273ff]
[    0.260064] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.260064] pci 0000:00:1d.7: System wakeup disabled by ACPI
[    0.260378] pci 0000:00:1e.0: [8086:2448] type 01 class 0x060401
[    0.260378] pci 0000:00:1e.0: System wakeup disabled by ACPI
[    0.260594] pci 0000:00:1f.0: [8086:2917] type 00 class 0x060100
[    0.260803] pci 0000:00:1f.2: [8086:2929] type 00 class 0x010601
[    0.260803] pci 0000:00:1f.2: reg 10: [io  0x1c48-0x1c4f]
[    0.260803] pci 0000:00:1f.2: reg 14: [io  0x183c-0x183f]
[    0.260803] pci 0000:00:1f.2: reg 18: [io  0x1c40-0x1c47]
[    0.260803] pci 0000:00:1f.2: reg 1c: [io  0x1838-0x183b]
[    0.260803] pci 0000:00:1f.2: reg 20: [io  0x1c20-0x1c3f]
[    0.260803] pci 0000:00:1f.2: reg 24: [mem 0xfc226000-0xfc2267ff]
[    0.260803] pci 0000:00:1f.2: PME# supported from D3hot
[    0.261065] pci 0000:00:1f.3: [8086:2930] type 00 class 0x0c0500
[    0.261065] pci 0000:00:1f.3: reg 10: [mem 0xfc227400-0xfc2274ff 64bit]
[    0.261065] pci 0000:00:1f.3: reg 20: [io  0x1c60-0x1c7f]
[    0.261319] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.261480] pci 0000:03:00.0: [8086:423b] type 00 class 0x028000
[    0.261480] pci 0000:03:00.0: reg 10: [mem 0xf4300000-0xf4301fff 64bit]
[    0.261480] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.268047] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.268111] pci 0000:00:1c.1:   bridge window [mem 0xf4300000-0xf43fffff]
[    0.269499] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.269499] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    0.269499] pci 0000:00:1c.3:   bridge window [mem 0xf8000000-0xf9ffffff]
[    0.269499] pci 0000:00:1c.3:   bridge window [mem 0xf4000000-0xf40fffff 64bit pref]
[    0.269674] pci 0000:00:1c.4: PCI bridge to [bus 0d-14]
[    0.269674] pci 0000:00:1c.4:   bridge window [io  0x3000-0x3fff]
[    0.269674] pci 0000:00:1c.4:   bridge window [mem 0xfa000000-0xfbffffff]
[    0.269674] pci 0000:00:1c.4:   bridge window [mem 0xf4100000-0xf41fffff 64bit pref]
[    0.269821] pci 0000:15:00.0: [1180:0476] type 02 class 0x060700
[    0.269821] pci 0000:15:00.0: proprietary Ricoh MMC controller disabled (via cardbus function)
[    0.269821] pci 0000:15:00.0: MMC cards are now supported by standard SDHCI controller
[    0.269821] pci 0000:15:00.0: reg 10: [mem 0xf4800000-0xf4800fff]
[    0.269821] pci 0000:15:00.0: supports D1 D2
[    0.269821] pci 0000:15:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.270143] pci 0000:15:00.1: [1180:0832] type 00 class 0x0c0010
[    0.270143] pci 0000:15:00.1: reg 10: [mem 0xf4801000-0xf48017ff]
[    0.270143] pci 0000:15:00.1: supports D1 D2
[    0.270143] pci 0000:15:00.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.270368] pci 0000:15:00.2: [1180:0822] type 00 class 0x080500
[    0.270368] pci 0000:15:00.2: reg 10: [mem 0xf4801800-0xf48018ff]
[    0.270368] pci 0000:15:00.2: supports D1 D2
[    0.270368] pci 0000:15:00.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.270593] pci 0000:15:00.4: [1180:0592] type 00 class 0x088000
[    0.270593] pci 0000:15:00.4: reg 10: [mem 0xf4802000-0xf48020ff]
[    0.270593] pci 0000:15:00.4: supports D1 D2
[    0.270593] pci 0000:15:00.4: PME# supported from D0 D1 D2 D3hot D3cold
[    0.270819] pci 0000:15:00.5: [1180:0852] type 00 class 0x088000
[    0.270819] pci 0000:15:00.5: reg 10: [mem 0xf4802400-0xf48024ff]
[    0.270819] pci 0000:15:00.5: supports D1 D2
[    0.270819] pci 0000:15:00.5: PME# supported from D0 D1 D2 D3hot D3cold
[    0.271044] pci 0000:00:1e.0: PCI bridge to [bus 15-18] (subtractive decode)
[    0.271044] pci 0000:00:1e.0:   bridge window [io  0x4000-0x7fff]
[    0.271044] pci 0000:00:1e.0:   bridge window [mem 0xf4800000-0xf7ffffff]
[    0.271044] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xf3ffffff 64bit pref]
[    0.271044] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.271044] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.271044] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.271044] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000d3fff] (subtractive decode)
[    0.271044] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
[    0.271044] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
[    0.271044] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xfebfffff] (subtractive decode)
[    0.271283] pci_bus 0000:16: busn_res: can not insert [bus 16-ff] under [bus 15-18] (conflicts with (null) [bus 15-18])
[    0.271283] pci_bus 0000:16: busn_res: [bus 16-ff] end is updated to 17
[    0.271283] pci_bus 0000:00: on NUMA node 0
[    0.271283] acpi PNP0A08:00: Requesting ACPI _OSC control (0x1d)
[    0.271283] acpi PNP0A08:00: ACPI _OSC control (0x1d) granted
[    0.276812] ACPI: Enabled 3 GPEs in block 00 to 3F
[    0.276814] acpi root: \_SB_.PCI0 notify handler is installed
[    0.277006] Found 1 acpi root devices
[    0.292065] ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[    0.292335] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.292335] vgaarb: loaded
[    0.292335] vgaarb: bridge control possible 0000:00:02.0
[    0.292850] PCI: Using ACPI for IRQ routing
[    0.295167] PCI: pci_cache_line_size set to 64 bytes
[    0.295258] e820: reserve RAM buffer [mem 0x0009ec00-0x0009ffff]
[    0.295261] e820: reserve RAM buffer [mem 0xbd4a1000-0xbfffffff]
[    0.295263] e820: reserve RAM buffer [mem 0xbd5b7000-0xbfffffff]
[    0.295266] e820: reserve RAM buffer [mem 0xbd6c6000-0xbfffffff]
[    0.295269] e820: reserve RAM buffer [mem 0xbda00000-0xbfffffff]
[    0.295434] NetLabel: Initializing
[    0.295434] NetLabel:  domain hash size = 128
[    0.295434] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.295434] NetLabel:  unlabeled traffic allowed by default
[    0.295434] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.295434] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.295434] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.298177] Switching to clocksource hpet
[    0.299747] pnp: PnP ACPI init
[    0.299810] ACPI: bus type PNP registered
[    0.318038] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.318100] system 00:00: [mem 0x000c0000-0x000c3fff] could not be reserved
[    0.318161] system 00:00: [mem 0x000c4000-0x000c7fff] could not be reserved
[    0.318221] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
[    0.318282] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
[    0.318342] system 00:00: [mem 0x000dc000-0x000dffff] could not be reserved
[    0.318403] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
[    0.318464] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
[    0.318524] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
[    0.318585] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
[    0.318646] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
[    0.318707] system 00:00: [mem 0x00100000-0xbfffffff] could not be reserved
[    0.318768] system 00:00: [mem 0xfec00000-0xffffffff] could not be reserved
[    0.318829] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.338915] system 00:01: [io  0x1000-0x107f] has been reserved
[    0.338975] system 00:01: [io  0x1180-0x11ff] has been reserved
[    0.339035] system 00:01: [io  0x0800-0x080f] has been reserved
[    0.339094] system 00:01: [io  0x15e0-0x15ef] has been reserved
[    0.339154] system 00:01: [io  0x1600-0x167f] has been reserved
[    0.339213] system 00:01: [io  0x1680-0x169f] has been reserved
[    0.340962] system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
[    0.341023] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.341084] system 00:01: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.341144] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.341204] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.341265] system 00:01: [mem 0xfed45000-0xfed4bfff] has been reserved
[    0.341325] system 00:01: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.341386] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.341471] pnp 00:02: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.341483] pnp 00:03: [dma 4]
[    0.341530] pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.341582] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.341644] pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.341698] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.341760] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.341817] pnp 00:08: Plug and Play ACPI device, IDs IBM0057 PNP0f13 (active)
[    0.362204] pnp: PnP ACPI: found 9 devices
[    0.362261] ACPI: bus type PNP unregistered
[    0.370588] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to [bus 02] add_size 1000
[    0.370593] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 02] add_size 200000
[    0.370596] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff] to [bus 02] add_size 200000
[    0.370607] pci 0000:00:1c.1: bridge window [io  0x1000-0x0fff] to [bus 03] add_size 1000
[    0.370610] pci 0000:00:1c.1: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 03] add_size 200000
[    0.370649] pci 0000:00:1c.0: res[14]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[    0.370652] pci 0000:00:1c.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.370655] pci 0000:00:1c.1: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.370658] pci 0000:00:1c.0: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.370661] pci 0000:00:1c.1: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.370666] pci 0000:00:1c.0: BAR 14: assigned [mem 0xc0000000-0xc01fffff]
[    0.370729] pci 0000:00:1c.0: BAR 15: assigned [mem 0xc0200000-0xc03fffff 64bit pref]
[    0.370801] pci 0000:00:1c.1: BAR 15: assigned [mem 0xc0400000-0xc05fffff 64bit pref]
[    0.370874] pci 0000:00:1c.0: BAR 13: assigned [io  0x8000-0x8fff]
[    0.370935] pci 0000:00:1c.1: BAR 13: assigned [io  0x9000-0x9fff]
[    0.370995] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.371054] pci 0000:00:1c.0:   bridge window [io  0x8000-0x8fff]
[    0.371118] pci 0000:00:1c.0:   bridge window [mem 0xc0000000-0xc01fffff]
[    0.371181] pci 0000:00:1c.0:   bridge window [mem 0xc0200000-0xc03fffff 64bit pref]
[    0.371257] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.371316] pci 0000:00:1c.1:   bridge window [io  0x9000-0x9fff]
[    0.371379] pci 0000:00:1c.1:   bridge window [mem 0xf4300000-0xf43fffff]
[    0.371442] pci 0000:00:1c.1:   bridge window [mem 0xc0400000-0xc05fffff 64bit pref]
[    0.371518] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.371578] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    0.371641] pci 0000:00:1c.3:   bridge window [mem 0xf8000000-0xf9ffffff]
[    0.371703] pci 0000:00:1c.3:   bridge window [mem 0xf4000000-0xf40fffff 64bit pref]
[    0.371779] pci 0000:00:1c.4: PCI bridge to [bus 0d-14]
[    0.371839] pci 0000:00:1c.4:   bridge window [io  0x3000-0x3fff]
[    0.371902] pci 0000:00:1c.4:   bridge window [mem 0xfa000000-0xfbffffff]
[    0.371965] pci 0000:00:1c.4:   bridge window [mem 0xf4100000-0xf41fffff 64bit pref]
[    0.372059] pci 0000:15:00.0: res[15]=[mem 0x04000000-0x03ffffff pref] get_res_add_size add_size 4000000
[    0.372063] pci 0000:15:00.0: res[16]=[mem 0x04000000-0x03ffffff] get_res_add_size add_size 4000000
[    0.372065] pci 0000:15:00.0: res[13]=[io  0x0100-0x00ff] get_res_add_size add_size 100
[    0.372068] pci 0000:15:00.0: res[14]=[io  0x0100-0x00ff] get_res_add_size add_size 100
[    0.372071] pci 0000:15:00.0: BAR 15: assigned [mem 0xf0000000-0xf3ffffff pref]
[    0.372145] pci 0000:15:00.0: BAR 16: assigned [mem 0xc4000000-0xc7ffffff]
[    0.372205] pci 0000:15:00.0: BAR 13: assigned [io  0x4000-0x40ff]
[    0.372265] pci 0000:15:00.0: BAR 14: assigned [io  0x4400-0x44ff]
[    0.372325] pci 0000:15:00.0: CardBus bridge to [bus 16-17]
[    0.372383] pci 0000:15:00.0:   bridge window [io  0x4000-0x40ff]
[    0.372446] pci 0000:15:00.0:   bridge window [io  0x4400-0x44ff]
[    0.372509] pci 0000:15:00.0:   bridge window [mem 0xf0000000-0xf3ffffff pref]
[    0.372583] pci 0000:15:00.0:   bridge window [mem 0xc4000000-0xc7ffffff]
[    0.372646] pci 0000:00:1e.0: PCI bridge to [bus 15-18]
[    0.372706] pci 0000:00:1e.0:   bridge window [io  0x4000-0x7fff]
[    0.372769] pci 0000:00:1e.0:   bridge window [mem 0xf4800000-0xf7ffffff]
[    0.372832] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xf3ffffff 64bit pref]
[    0.373137] pci 0000:00:1e.0: setting latency timer to 64
[    0.373178] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.373180] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.373183] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.373185] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.373188] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.373190] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.373192] pci_bus 0000:00: resource 10 [mem 0xc0000000-0xfebfffff]
[    0.373195] pci_bus 0000:02: resource 0 [io  0x8000-0x8fff]
[    0.373197] pci_bus 0000:02: resource 1 [mem 0xc0000000-0xc01fffff]
[    0.373200] pci_bus 0000:02: resource 2 [mem 0xc0200000-0xc03fffff 64bit pref]
[    0.373202] pci_bus 0000:03: resource 0 [io  0x9000-0x9fff]
[    0.373205] pci_bus 0000:03: resource 1 [mem 0xf4300000-0xf43fffff]
[    0.373207] pci_bus 0000:03: resource 2 [mem 0xc0400000-0xc05fffff 64bit pref]
[    0.373210] pci_bus 0000:05: resource 0 [io  0x2000-0x2fff]
[    0.373212] pci_bus 0000:05: resource 1 [mem 0xf8000000-0xf9ffffff]
[    0.373214] pci_bus 0000:05: resource 2 [mem 0xf4000000-0xf40fffff 64bit pref]
[    0.373217] pci_bus 0000:0d: resource 0 [io  0x3000-0x3fff]
[    0.373219] pci_bus 0000:0d: resource 1 [mem 0xfa000000-0xfbffffff]
[    0.373221] pci_bus 0000:0d: resource 2 [mem 0xf4100000-0xf41fffff 64bit pref]
[    0.373224] pci_bus 0000:15: resource 0 [io  0x4000-0x7fff]
[    0.373226] pci_bus 0000:15: resource 1 [mem 0xf4800000-0xf7ffffff]
[    0.373229] pci_bus 0000:15: resource 2 [mem 0xf0000000-0xf3ffffff 64bit pref]
[    0.373231] pci_bus 0000:15: resource 4 [io  0x0000-0x0cf7]
[    0.373233] pci_bus 0000:15: resource 5 [io  0x0d00-0xffff]
[    0.373236] pci_bus 0000:15: resource 6 [mem 0x000a0000-0x000bffff]
[    0.373238] pci_bus 0000:15: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.373240] pci_bus 0000:15: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.373243] pci_bus 0000:15: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.373245] pci_bus 0000:15: resource 10 [mem 0xc0000000-0xfebfffff]
[    0.373247] pci_bus 0000:16: resource 0 [io  0x4000-0x40ff]
[    0.373250] pci_bus 0000:16: resource 1 [io  0x4400-0x44ff]
[    0.373252] pci_bus 0000:16: resource 2 [mem 0xf0000000-0xf3ffffff pref]
[    0.373254] pci_bus 0000:16: resource 3 [mem 0xc4000000-0xc7ffffff]
[    0.373287] NET: Registered protocol family 2
[    0.373498] TCP established hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.373868] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.374236] TCP: Hash tables configured (established 65536 bind 65536)
[    0.374342] TCP: reno registered
[    0.374398] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.374498] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.374659] NET: Registered protocol family 1
[    0.374727] pci 0000:00:02.0: Boot video device
[    0.374739] pci 0000:00:1a.0: power state changed by ACPI to D0
[    0.375035] pci 0000:00:1a.2: power state changed by ACPI to D0
[    0.375341] pci 0000:00:1d.0: power state changed by ACPI to D0
[    0.375886] PCI: CLS 64 bytes, default 64
[    0.375923] Trying to unpack rootfs image as initramfs...
[    0.398696] Freeing initrd memory: 4040k freed
[    0.400317] dmar: Device scope device [0000:00:03.02] not found
[    0.400377] dmar: Device scope device [0000:00:03.03] not found
[    0.400448] DMAR: No ATSR found
[    0.400568] IOMMU 2 0xfeb00000: using Register based invalidation
[    0.400626] IOMMU 0 0xfeb03000: using Register based invalidation
[    0.400685] IOMMU 3 0xfeb02000: using Register based invalidation
[    0.400746] IOMMU: Setting RMRR:
[    0.400813] IOMMU: Setting identity map for device 0000:00:1d.0 [0xfc226c00 - 0xfc2273ff]
[    0.400915] IOMMU: Setting identity map for device 0000:00:1d.1 [0xfc226c00 - 0xfc2273ff]
[    0.401005] IOMMU: Setting identity map for device 0000:00:1d.2 [0xfc226c00 - 0xfc2273ff]
[    0.401096] IOMMU: Setting identity map for device 0000:00:1d.7 [0xfc226c00 - 0xfc2273ff]
[    0.401188] IOMMU: Setting identity map for device 0000:00:1a.0 [0xfc226c00 - 0xfc2273ff]
[    0.401278] IOMMU: Setting identity map for device 0000:00:1a.1 [0xfc226c00 - 0xfc2273ff]
[    0.401368] IOMMU: Setting identity map for device 0000:00:1a.2 [0xfc226c00 - 0xfc2273ff]
[    0.401458] IOMMU: Setting identity map for device 0000:00:1a.7 [0xfc226c00 - 0xfc2273ff]
[    0.401540] IOMMU: Prepare 0-16MiB unity mapping for LPC
[    0.401609] IOMMU: Setting identity map for device 0000:00:1f.0 [0x0 - 0xffffff]
[    0.401842] PCI-DMA: Intel(R) Virtualization Technology for Directed I/O
[    0.404439] Simple Boot Flag at 0x35 set to 0x1
[    0.404943] Initialise module verification
[    0.405039] audit: initializing netlink socket (disabled)
[    0.405108] type=2000 audit(1372334088.404:1): initialized
[    0.405638] bounce pool size: 64 pages
[    0.405704] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.409021] VFS: Disk quotas dquot_6.5.2
[    0.409147] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.409344] ROMFS MTD (C) 2007 Red Hat, Inc.
[    0.409456] msgmni has been set to 15874
[    0.409770] Key type asymmetric registered
[    0.409827] Asymmetric key parser 'x509' registered
[    0.409972] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.410067] io scheduler noop registered
[    0.410124] io scheduler deadline registered (default)
[    0.410330] pcieport 0000:00:1c.0: irq 43 for MSI/MSI-X
[    0.410527] pcieport 0000:00:1c.1: irq 44 for MSI/MSI-X
[    0.410724] pcieport 0000:00:1c.3: irq 45 for MSI/MSI-X
[    0.410918] pcieport 0000:00:1c.4: irq 46 for MSI/MSI-X
[    0.411180] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[    0.411244] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
[    0.411271] pcieport 0000:00:1c.1: Signaling PME through PCIe PME interrupt
[    0.411332] pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
[    0.411394] pcie_pme 0000:00:1c.1:pcie01: service driver pcie_pme loaded
[    0.411420] pcieport 0000:00:1c.3: Signaling PME through PCIe PME interrupt
[    0.411484] pcie_pme 0000:00:1c.3:pcie01: service driver pcie_pme loaded
[    0.411510] pcieport 0000:00:1c.4: Signaling PME through PCIe PME interrupt
[    0.411573] pcie_pme 0000:00:1c.4:pcie01: service driver pcie_pme loaded
[    0.411686] intel_idle: does not run on family 6 model 23
[    0.411780] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    0.412015] ACPI: Lid Switch [LID]
[    0.412139] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
[    0.412212] ACPI: Sleep Button [SLPB]
[    0.412360] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    0.412432] ACPI: Power Button [PWRF]
[    0.412576] GHES: HEST is not enabled!
[    0.437225] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.438034] Linux agpgart interface v0.103
[    0.438229] agpgart-intel 0000:00:00.0: Intel GM45 Chipset
[    0.438346] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[    0.440413] agpgart-intel 0000:00:00.0: detected 32768K stolen memory
[    0.440616] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    0.440774] [drm] Initialized drm 1.1.0 20060810
[    0.441230] [drm] Memory usable by graphics device = 2048M
[    0.441291] i915 0000:00:02.0: setting latency timer to 64
[    0.463033] i915 0000:00:02.0: irq 47 for MSI/MSI-X
[    0.463041] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    0.463101] [drm] Driver supports precise vblank timestamp query.
[    0.463208] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    0.596833] fbcon: inteldrmfb (fb0) is primary device
[    1.179426] Console: switching to colour frame buffer device 180x56
[    1.182889] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    1.182924] i915 0000:00:02.0: registered panic notifier
[    1.213456] acpi device:02: registered as cooling_device0
[    1.213541] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    1.213642] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input3
[    1.213763] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    1.215984] brd: module loaded
[    1.216126] mei_me 0000:00:03.0: setting latency timer to 64
[    1.216152] mei_me 0000:00:03.0: irq 48 for MSI/MSI-X
[    1.219293] libphy: Fixed MDIO Bus: probed
[    1.219418] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    1.226990] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.227048] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.227255] mousedev: PS/2 mouse device common for all mice
[    1.227344] rtc_cmos 00:06: RTC can wake from S4
[    1.227533] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    1.227594] rtc_cmos 00:06: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    1.227662] cpuidle: using governor ladder
[    1.227687] cpuidle: using governor menu
[    1.227713] ledtrig-cpu: registered to indicate activity on CPUs
[    1.227918] TCP: cubic registered
[    1.227939] NET: Registered protocol family 17
[    1.232935] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    1.238731] Loading module verification certificates
[    1.239764] MODSIGN: Loaded cert 'Magrathea: Glacier signing key: 3f85817e8cdcb440ba0d077ca1195739cc72ca0e'
[    1.239817] registered taskstats version 1
[    1.240413] rtc_cmos 00:06: setting system clock to 2013-06-27 11:54:50 UTC (1372334090)
[    1.242722] Freeing unused kernel memory: 844k freed
[    1.244410] Write protecting the kernel read-only data: 6144k
[    1.246445] Freeing unused kernel memory: 232k freed
[    1.248126] Freeing unused kernel memory: 68k freed
[    1.255857] usb_common: module verification failed: signature and/or required key missing - tainting kernel
[    1.258662] ACPI: bus type USB registered
[    1.260234] usbcore: registered new interface driver usbfs
[    1.261749] usbcore: registered new interface driver hub
[    1.263268] usbcore: registered new device driver usb
[    1.265189] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.266944] ehci-pci: EHCI PCI platform driver
[    1.268500] ehci-pci 0000:00:1a.7: setting latency timer to 64
[    1.268517] ehci-pci 0000:00:1a.7: EHCI Host Controller
[    1.269940] ehci-pci 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    1.271379] ehci-pci 0000:00:1a.7: debug port 1
[    1.276689] ehci-pci 0000:00:1a.7: cache line size of 64 is not supported
[    1.276712] ehci-pci 0000:00:1a.7: irq 23, io mem 0xfc226c00
[    1.288013] ehci-pci 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    1.289411] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.290805] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.292204] usb usb1: Product: EHCI Host Controller
[    1.293575] usb usb1: Manufacturer: Linux 3.10.0-rc7-00135-g98b6ed0 ehci_hcd
[    1.294949] usb usb1: SerialNumber: 0000:00:1a.7
[    1.296498] hub 1-0:1.0: USB hub found
[    1.297886] hub 1-0:1.0: 6 ports detected
[    1.299564] ehci-pci 0000:00:1d.7: setting latency timer to 64
[    1.299574] ehci-pci 0000:00:1d.7: EHCI Host Controller
[    1.301010] ehci-pci 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    1.302440] ehci-pci 0000:00:1d.7: debug port 1
[    1.307752] ehci-pci 0000:00:1d.7: cache line size of 64 is not supported
[    1.307772] ehci-pci 0000:00:1d.7: irq 19, io mem 0xfc227000
[    1.320014] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    1.321440] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    1.322832] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.324223] usb usb2: Product: EHCI Host Controller
[    1.325590] usb usb2: Manufacturer: Linux 3.10.0-rc7-00135-g98b6ed0 ehci_hcd
[    1.326948] usb usb2: SerialNumber: 0000:00:1d.7
[    1.328475] hub 2-0:1.0: USB hub found
[    1.329821] hub 2-0:1.0: 6 ports detected
[    1.331770] uhci_hcd: USB Universal Host Controller Interface driver
[    1.333207] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    1.333211] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    1.334547] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    1.335944] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001860
[    1.337348] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    1.338697] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.340046] usb usb3: Product: UHCI Host Controller
[    1.341389] usb usb3: Manufacturer: Linux 3.10.0-rc7-00135-g98b6ed0 uhci_hcd
[    1.342769] usb usb3: SerialNumber: 0000:00:1a.0
[    1.344305] hub 3-0:1.0: USB hub found
[    1.345655] hub 3-0:1.0: 2 ports detected
[    1.347163] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    1.347167] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    1.348503] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    1.349852] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001880
[    1.351170] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    1.352435] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.353685] usb usb4: Product: UHCI Host Controller
[    1.354937] usb usb4: Manufacturer: Linux 3.10.0-rc7-00135-g98b6ed0 uhci_hcd
[    1.356199] usb usb4: SerialNumber: 0000:00:1a.1
[    1.357596] hub 4-0:1.0: USB hub found
[    1.358837] hub 4-0:1.0: 2 ports detected
[    1.360211] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    1.360215] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    1.361401] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    1.362667] uhci_hcd 0000:00:1a.2: irq 22, io base 0x000018a0
[    1.363935] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    1.365170] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.366394] usb usb5: Product: UHCI Host Controller
[    1.367615] usb usb5: Manufacturer: Linux 3.10.0-rc7-00135-g98b6ed0 uhci_hcd
[    1.368860] usb usb5: SerialNumber: 0000:00:1a.2
[    1.370222] hub 5-0:1.0: USB hub found
[    1.371456] hub 5-0:1.0: 2 ports detected
[    1.372865] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.372869] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.374099] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    1.375375] uhci_hcd 0000:00:1d.0: irq 16, io base 0x000018c0
[    1.376645] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    1.377860] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.379091] usb usb6: Product: UHCI Host Controller
[    1.380330] usb usb6: Manufacturer: Linux 3.10.0-rc7-00135-g98b6ed0 uhci_hcd
[    1.381575] usb usb6: SerialNumber: 0000:00:1d.0
[    1.382962] hub 6-0:1.0: USB hub found
[    1.384222] hub 6-0:1.0: 2 ports detected
[    1.385616] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    1.385620] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.386855] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    1.388161] uhci_hcd 0000:00:1d.1: irq 17, io base 0x000018e0
[    1.389438] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    1.390678] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.391921] usb usb7: Product: UHCI Host Controller
[    1.393587] usb usb7: Manufacturer: Linux 3.10.0-rc7-00135-g98b6ed0 uhci_hcd
[    1.394827] usb usb7: SerialNumber: 0000:00:1d.1
[    1.396243] hub 7-0:1.0: USB hub found
[    1.397509] hub 7-0:1.0: 2 ports detected
[    1.398915] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    1.398919] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    1.400159] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    1.401445] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001c00
[    1.402702] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    1.403940] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.405199] tsc: Refined TSC clocksource calibration: 2526.999 MHz
[    1.406445] Switching to clocksource tsc
[    1.407677] usb usb8: Product: UHCI Host Controller
[    1.408901] usb usb8: Manufacturer: Linux 3.10.0-rc7-00135-g98b6ed0 uhci_hcd
[    1.410143] usb usb8: SerialNumber: 0000:00:1d.2
[    1.411533] hub 8-0:1.0: USB hub found
[    1.412793] hub 8-0:1.0: 2 ports detected
[    1.414820] hidraw: raw HID events driver (C) Jiri Kosina
[    1.417766] SCSI subsystem initialized
[    1.420325] ACPI: bus type ATA registered
[    1.421687] libata version 3.00 loaded.
[    1.422555] ahci 0000:00:1f.2: version 3.0
[    1.422663] ahci 0000:00:1f.2: irq 49 for MSI/MSI-X
[    1.422705] ahci: SSS flag set, parallel bus scan disabled
[    1.423966] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x3 impl SATA mode
[    1.425227] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ccc sxs 
[    1.426475] ahci 0000:00:1f.2: setting latency timer to 64
[    1.427290] scsi0 : ahci
[    1.428652] scsi1 : ahci
[    1.430012] scsi2 : ahci
[    1.431345] scsi3 : ahci
[    1.432677] ata1: SATA max UDMA/133 abar m2048@0xfc226000 port 0xfc226100 irq 49
[    1.433926] ata2: SATA max UDMA/133 abar m2048@0xfc226000 port 0xfc226180 irq 49
[    1.435140] ata3: DUMMY
[    1.436376] ata4: DUMMY
[    1.756029] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.764322] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    1.764326] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    1.765537] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    1.773407] ata1.00: ATA-8: OCZ-VERTEX2, 1.37, max UDMA/133
[    1.774622] ata1.00: 468862128 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.783409] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    1.783413] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    1.784663] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    1.793413] ata1.00: configured for UDMA/133
[    1.794754] scsi 0:0:0:0: Direct-Access     ATA      OCZ-VERTEX2      1.37 PQ: 0 ANSI: 5
[    1.868009] usb 1-6: new high-speed USB device number 3 using ehci-pci
[    2.011511] usb 1-6: New USB device found, idVendor=17ef, idProduct=1004
[    2.012788] usb 1-6: New USB device strings: Mfr=2, Product=1, SerialNumber=3
[    2.014048] usb 1-6: Product: Integrated Camera
[    2.015333] usb 1-6: Manufacturer: Chicony Electronics Co., Ltd.
[    2.016626] usb 1-6: SerialNumber: SN0001
[    2.116018] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.119740] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[    2.120759] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[    2.120763] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    2.123164] ata2.00: ATAPI: Optiarc  DVD RW AD-7910S, 1.D0, max UDMA/100
[    2.127350] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[    2.128454] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[    2.128458] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    2.130780] ata2.00: configured for UDMA/100
[    2.134370] scsi 1:0:0:0: CD-ROM            Optiarc  DVD RW AD-7910S  1.D0 PQ: 0 ANSI: 5
[    2.136788] sd 0:0:0:0: [sda] 468862128 512-byte logical blocks: (240 GB/223 GiB)
[    2.138200] sd 0:0:0:0: [sda] Write Protect is off
[    2.139525] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.139547] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.141743]  sda: sda1 sda2 sda3 < sda5 sda6 sda7 >
[    2.143642] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.146296] device-mapper: ioctl: 4.24.0-ioctl (2013-01-15) initialised: dm-devel@redhat.com
[    2.183633] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
[    2.188143] systemd-udevd[1381]: starting version 204
[    2.392012] usb 2-4: new high-speed USB device number 3 using ehci-pci
[    2.591849] usb 2-4: New USB device found, idVendor=0bdb, idProduct=1900
[    2.593282] usb 2-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    2.594737] usb 2-4: Product: Ericsson F3507g Mobile Broadband Minicard Composite Device
[    2.596204] usb 2-4: Manufacturer: Ericsson
[    2.597660] usb 2-4: SerialNumber: 3541430228088360
[    3.008007] usb 4-2: new full-speed USB device number 2 using uhci_hcd
[    3.183175] usb 4-2: New USB device found, idVendor=0a5c, idProduct=2145
[    3.184681] usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.186197] usb 4-2: Product: ThinkPad Bluetooth with Enhanced Data Rate II
[    3.187701] usb 4-2: Manufacturer: Lenovo Computer Corp
[    3.432006] usb 6-1: new full-speed USB device number 2 using uhci_hcd
[    3.621648] usb 6-1: New USB device found, idVendor=046d, idProduct=c52b
[    3.623151] usb 6-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.624692] usb 6-1: Product: USB Receiver
[    3.626238] usb 6-1: Manufacturer: Logitech
[   13.849100] bio: create slab <bio-1> at 1
[   16.694161] bio: create slab <bio-1> at 1
[   27.373503] bio: create slab <bio-1> at 1
[   27.470461] bio: create slab <bio-1> at 1
[   27.502567] XFS (dm-0): Mounting Filesystem
[   27.559078] XFS (dm-0): Ending clean mount
[   27.680461] systemd[1]: systemd 204 running in system mode. (+PAM +LIBWRAP +AUDIT +SELINUX +IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ)
[   27.692595] systemd[1]: Inserted module 'autofs4'
[   27.703674] NET: Registered protocol family 10
[   27.705389] systemd[1]: Inserted module 'ipv6'
[   27.707514] systemd[1]: Set hostname to <t400>.
[   27.710127] systemd[1]: Hardware watchdog 'INTCAMT', version 0
[   27.711602] systemd[1]: Failed to set timeout to 20s: Invalid argument
[   27.833297] systemd[1]: [/lib/systemd/system/named.service:12] Executable path is not absolute, ignoring: touch $CHROOT_TO_DIR/named.log
[   27.834817] systemd[1]: [/lib/systemd/system/named.service:13] Executable path is not absolute, ignoring: chown named:named $CHROOT_TO_DIR/named.log
[   27.836375] systemd[1]: [/lib/systemd/system/named.service:18] Not an absolute path, ignoring: $CHROOT_TO_DIR/named.pid
[   27.856993] systemd[1]: Starting Syslog Socket.
[   27.860099] systemd[1]: Listening on Syslog Socket.
[   27.861587] systemd[1]: Starting Forward Password Requests to Wall Directory Watch.
[   27.863122] systemd[1]: Started Forward Password Requests to Wall Directory Watch.
[   27.864636] systemd[1]: Starting Remote File Systems.
[   27.867597] systemd[1]: Reached target Remote File Systems.
[   27.869098] systemd[1]: Starting Collect Read-Ahead Data...
[   27.872767] systemd[1]: Starting Replay Read-Ahead Data...
[   27.876711] systemd[1]: Starting Delayed Shutdown Socket.
[   27.879800] systemd[1]: Listening on Delayed Shutdown Socket.
[   27.881648] systemd[1]: Starting /dev/initctl Compatibility Named Pipe.
[   27.885937] systemd[1]: Listening on /dev/initctl Compatibility Named Pipe.
[   27.887350] systemd[1]: Starting Journal Socket.
[   27.890558] systemd[1]: Listening on Journal Socket.
[   27.892555] systemd[1]: Starting Restore Sound Card State...
[   27.896248] systemd[1]: Starting Create static device nodes in /dev...
[   27.899902] systemd[1]: Starting Journal Service...
[   27.906641] systemd[1]: Started Journal Service.
[   27.909564] systemd[1]: Starting Dispatch Password Requests to Console Directory Watch.
[   27.912594] systemd[1]: Started Dispatch Password Requests to Console Directory Watch.
[   27.915077] systemd[1]: Starting Arbitrary Executable File Formats File System Automount Point.
[   27.920160] systemd[1]: Set up automount Arbitrary Executable File Formats File System Automount Point.
[   27.922074] systemd[1]: Mounting POSIX Message Queue File System...
[   27.927060] systemd[1]: Mounting Huge Pages File System...
[   27.931743] systemd[1]: Expecting device dev-sda7.device...
[   27.935760] systemd[1]: Expecting device dev-mapper-lrootfs.device...
[   27.940685] systemd[1]: Starting Swap.
[   27.944676] systemd[1]: Reached target Swap.
[   27.947516] systemd[1]: Starting udev Kernel Socket.
[   27.950634] systemd[1]: Listening on udev Kernel Socket.
[   27.953545] systemd[1]: Starting udev Control Socket.
[   27.959157] systemd[1]: Listening on udev Control Socket.
[   27.960683] systemd[1]: Starting udev Coldplug all Devices...
[   27.964318] systemd[1]: Expecting device dev-sda6.device...
[   27.971218] systemd[1]: Started Collect Read-Ahead Data.
[   27.974387] systemd[1]: Started Replay Read-Ahead Data.
[   27.977975] systemd[1]: Started Restore Sound Card State.
[   27.981522] systemd[1]: Started Create static device nodes in /dev.
[   27.984638] systemd[1]: Mounted POSIX Message Queue File System.
[   27.989660] systemd[1]: Mounted Huge Pages File System.
[   27.991155] systemd[1]: Starting udev Kernel Device Manager...
[   27.994656] systemd[1]: Starting File System Check on Root Device...
[   28.002944] systemd[1]: Started Set Up Additional Binary Formats.
[   28.005405] systemd[1]: Starting Load Kernel Modules...
[   28.005670] systemd-udevd[2723]: starting version 204
[   28.010184] systemd[1]: Starting Apply Kernel Variables...
[   28.016772] systemd[1]: Starting Setup Virtual Console...
[   28.021600] systemd[1]: Started udev Kernel Device Manager.
[   28.037593] systemd[1]: Started Setup Virtual Console.
[   28.043318] TCP: illinois registered
[   28.048204] systemd[1]: Started File System Check on Root Device.
[   28.051425] systemd[1]: Started Apply Kernel Variables.
[   28.053822] ACPI: Requesting acpi_cpufreq
[   28.055859] Monitor-Mwait will be used to enter C-1 state
[   28.055950] Monitor-Mwait will be used to enter C-2 state
[   28.055954] Monitor-Mwait will be used to enter C-3 state
[   28.055956] tsc: Marking TSC unstable due to TSC halts in idle
[   28.055985] ACPI: acpi_idle registered with cpuidle
[   28.056393] systemd[1]: Starting Remount Root and Kernel File Systems...
[   28.058995] Switching to clocksource hpet
[   28.299947] Non-volatile memory driver v1.3
[   28.308357] snd_hda_intel 0000:00:1b.0: irq 50 for MSI/MSI-X
[   28.318421] ACPI: Battery Slot [BAT0] (battery present)
[   28.325530] ACPI: AC Adapter [AC] (on-line)
[   28.331162] pps_core: LinuxPPS API ver. 1 registered
[   28.333473] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[   28.337928] hda_codec: CX20561 (Hermosa): BIOS auto-probing.
[   28.339608] ALSA sound/pci/hda/hda_auto_parser.c:393 autoconfig: line_outs=1 (0x1a/0x0/0x0/0x0/0x0) type:speaker
[   28.339611] ALSA sound/pci/hda/hda_auto_parser.c:397    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[   28.339614] ALSA sound/pci/hda/hda_auto_parser.c:401    hp_outs=2 (0x19/0x16/0x0/0x0/0x0)
[   28.339616] ALSA sound/pci/hda/hda_auto_parser.c:402    mono: mono_out=0x0
[   28.339618] ALSA sound/pci/hda/hda_auto_parser.c:405    dig-out=0x1c/0x0
[   28.339619] ALSA sound/pci/hda/hda_auto_parser.c:406    inputs:
[   28.339622] ALSA sound/pci/hda/hda_auto_parser.c:410      Mic=0x18
[   28.339624] ALSA sound/pci/hda/hda_auto_parser.c:410      Internal Mic=0x1d
[   28.339626] ALSA sound/pci/hda/hda_auto_parser.c:410      Dock Mic=0x17
[   28.345164] thermal LNXTHERM:00: registered as thermal_zone0
[   28.345431] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input5
[   28.348613] ACPI: Thermal Zone [THM0] (48 C)
[   28.375173] thinkpad_acpi: ThinkPad ACPI Extras v0.24
[   28.376427] thinkpad_acpi: http://ibm-acpi.sf.net/
[   28.377624] ALSA sound/pci/hda/patch_conexant.c:3414 hda_codec: Enable sync_write for stable communication
[   28.378135] thinkpad_acpi: ThinkPad BIOS 7UET94WW (3.24 ), EC 7VHT16WW-1.06
[   28.379534] thinkpad_acpi: Lenovo ThinkPad T400, model 2764CTO
[   28.381676] wmi: Mapper loaded
[   28.382169] PTP clock support registered
[   28.386313] ALSA sound/pci/hda/hda_auto_parser.c:393 autoconfig: line_outs=0 (0x0/0x0/0x0/0x0/0x0) type:line
[   28.386316] ALSA sound/pci/hda/hda_auto_parser.c:397    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[   28.386319] ALSA sound/pci/hda/hda_auto_parser.c:401    hp_outs=0 (0x0/0x0/0x0/0x0/0x0)
[   28.386321] ALSA sound/pci/hda/hda_auto_parser.c:402    mono: mono_out=0x0
[   28.386322] ALSA sound/pci/hda/hda_auto_parser.c:406    inputs:
[   28.389107] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input6
[   28.393600] input: HDA Intel Dock Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
[   28.395009] input: HDA Intel Dock Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[   28.417523] thermal LNXTHERM:01: registered as thermal_zone1
[   28.420360] ACPI: Thermal Zone [THM1] (43 C)
[   28.424398] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[   28.430575] thinkpad_acpi: detected a 8-level brightness capable ThinkPad
[   28.431916] Bluetooth: Core ver 2.16
[   28.433385] thinkpad_acpi: radio switch found; radios are enabled
[   28.434849] thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
[   28.436467] thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
[   28.450059] NET: Registered protocol family 31
[   28.451401] Bluetooth: HCI device and connection manager initialized
[   28.452835] media: Linux media interface: v0.10
[   28.454184] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[   28.454231] Bluetooth: HCI socket layer initialized
[   28.454234] Bluetooth: L2CAP socket layer initialized
[   28.454241] Bluetooth: SCO socket layer initialized
[   28.459534] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
[   28.460957] cfg80211: Calling CRDA to update world regulatory domain
[   28.462872] e1000e 0000:00:19.0: setting latency timer to 64
[   28.462943] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[   28.464616] e1000e 0000:00:19.0: irq 51 for MSI/MSI-X
[   28.480281] cdc_acm 2-4:1.1: ttyACM0: USB ACM device
[   28.483779] Linux video capture interface: v2.00
[   28.486119] Intel(R) Wireless WiFi driver for Linux, in-tree:
[   28.487526] Copyright(c) 2003-2013 Intel Corporation
[   28.490162] cdc_acm 2-4:1.3: ttyACM1: USB ACM device
[   28.491733] iwlwifi 0000:03:00.0: irq 52 for MSI/MSI-X
[   28.492591] logitech-djreceiver 0003:046D:C52B.0003: hiddev0,hidraw0: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:1d.0-1/input2
[   28.496489] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is unblocked
[   28.500712] usbcore: registered new interface driver usbhid
[   28.502989] usbhid: USB HID core driver
[   28.503265] iwlwifi 0000:03:00.0: loaded firmware version 8.83.5.1 build 33692 op_mode iwldvm
[   28.507106] cdc_acm 2-4:1.9: ttyACM2: USB ACM device
[   28.509723] usbcore: registered new interface driver btusb
[   28.512597] input: Logitech Unifying Device. Wireless PID:1028 as /devices/pci0000:00/0000:00:1d.0/usb6/6-1/6-1:1.2/0003:046D:C52B.0003/input/input10
[   28.518325] usbcore: registered new interface driver cdc_acm
[   28.518446] thinkpad_acpi: rfkill switch tpacpi_wwan_sw: radio is unblocked
[   28.521916] cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
[   28.523814] uvcvideo: Found UVC 1.00 device Integrated Camera (17ef:1004)
[   28.536791] cdc_wdm 2-4:1.5: cdc-wdm1: USB WDM device
[   28.542010] logitech-djdevice 0003:046D:C52B.0004: input,hidraw1: USB HID v1.11 Mouse [Logitech Unifying Device. Wireless PID:1028] on usb-0000:00:1d.0-1:1
[   28.552202] cdc_wdm 2-4:1.6: cdc-wdm2: USB WDM device
[   28.554110] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUG disabled
[   28.555806] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
[   28.557729] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
[   28.559585] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE enabled
[   28.561371] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_P2P enabled
[   28.563174] iwlwifi 0000:03:00.0: Detected Intel(R) WiMAX/WiFi Link 5350 AGN, REV=0x24
[   28.565409] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
[   28.572066] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one
[   28.580230] usbcore: registered new interface driver cdc_wdm
[   28.599456] thinkpad_acpi: Console audio control enabled, mode: override (read/write)
[   28.601329] yenta_cardbus 0000:15:00.0: CardBus bridge found [17aa:20c6]
[   28.601933] input: Integrated Camera as /devices/pci0000:00/0000:00:1a.7/usb1/1-6/1-6:1.0/input/input11
[   28.606308] cdc_ether 2-4:1.7 wwan0: register 'cdc_ether' at usb-0000:00:1d.7-4, Mobile Broadband Network Device, 02:80:37:ec:02:00
[   28.614721] usbcore: registered new interface driver cdc_ether
[   28.614758] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input12
[   28.619452] usbcore: registered new interface driver uvcvideo
[   28.621288] sdhci: Secure Digital Host Controller Interface driver
[   28.622483] USB Video Class driver (1.1.1)
[   28.626160] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[   28.626463] sdhci: Copyright(c) Pierre Ossman
[   28.630707] cdrom: Uniform CD-ROM driver Revision: 3.20
[   28.635517] sr 1:0:0:0: Attached scsi CD-ROM sr0
[   28.637405] input: PC Speaker as /devices/platform/pcspkr/input/input13
[   28.642078] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[   28.658448] microcode: CPU0 sig=0x10676, pf=0x80, revision=0x610
[   28.665458] microcode: CPU1 sig=0x10676, pf=0x80, revision=0x610
[   28.670917] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   28.736828] yenta_cardbus 0000:15:00.0: ISA IRQ mask 0x0cb8, PCI irq 16
[   28.739149] yenta_cardbus 0000:15:00.0: Socket status: 30000006
[   28.740953] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window: [io  0x4000-0x7fff]
[   28.742872] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window: [mem 0xf4800000-0xf7ffffff]
[   28.744787] pcmcia_socket pcmcia_socket0: cs: memory probe 0xf4800000-0xf7ffffff:
[   28.747019]  excluding 0xf4800000-0xf4b7ffff
[   28.749199] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window: [mem 0xf0000000-0xf3ffffff 64bit pref]
[   28.751034] pcmcia_socket pcmcia_socket0: cs: memory probe 0xf0000000-0xf3ffffff:
[   28.751047]  excluding 0xf0000000-0xf3ffffff
[   28.760151] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 00:21:86:a2:19:06
[   28.762562] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
[   28.766914] e1000e 0000:00:19.0 eth0: MAC: 7, PHY: 8, PBA No: 1008FF-0FF
[   28.768935] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
[   28.771279] ACPI Warning: 0x0000000000001028-0x000000000000102f SystemIO conflicts with Region \_SB_.PCI0.LPC_.PMIO 1 (20130328/utaddress-251)
[   28.773084] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   28.775260] ACPI Warning: 0x00000000000011b0-0x00000000000011bf SystemIO conflicts with Region \_SB_.PCI0.LPC_.LPIO 1 (20130328/utaddress-251)
[   28.777031] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   28.778820] ACPI Warning: 0x0000000000001180-0x00000000000011af SystemIO conflicts with Region \_SB_.PCI0.LPC_.LPIO 1 (20130328/utaddress-251)
[   28.780625] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   28.782709] lpc_ich: Resource conflict(s) found affecting gpio_ich
[   28.828151] firewire_ohci 0000:15:00.1: added OHCI v1.10 device as card 0, 4 IR + 4 IT contexts, quirks 0x11
[   28.832499] sdhci-pci 0000:15:00.2: SDHCI controller found [1180:0822] (rev 21)
[   28.835434] sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
[   28.837323] mmc0: no vqmmc regulator found
[   28.839227] mmc0: no vmmc regulator found
[   28.852021] sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
[   28.858900] mmc0: SDHCI controller on PCI [0000:15:00.2] using DMA
[   28.893567] cfg80211: World regulatory domain updated:
[   28.895371] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   28.897388] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   28.899268] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   28.901984] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   28.908218] iTCO_vendor_support: vendor-support=0
[   28.910360] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[   28.910396] iTCO_wdt: Found a ICH9M-E TCO device (Version=2, TCOBASE=0x1060)
[   28.910762] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   28.915951] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   28.915953] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   28.915965] cfg80211: Calling CRDA for country: PL
[   28.930998] cfg80211: Regulatory domain changed to country: PL
[   28.932826] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   28.936853] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   28.938601] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   28.942445] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   28.944263] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
[   28.945934] cfg80211:   (57240000 KHz - 65880000 KHz @ 2160000 KHz), (N/A, 4000 mBm)
[   29.329599] firewire_core 0000:15:00.1: created device fw0: GUID 00061b032a347baa, S400
[   29.522062] psmouse serio1: synaptics: Touchpad model: 1, fw: 7.0, id: 0x1c0b1, caps: 0xd04791/0xb00000/0x20000, board id: 71, fw id: 434116
[   29.522067] psmouse serio1: synaptics: serio: Synaptics pass-through port at isa0060/serio1/input0
[   29.574171] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input14
[   29.616330] systemd-logind[4104]: Watching system buttons on /dev/input/event2 (Power Button)
[   29.617760] systemd-logind[4104]: Watching system buttons on /dev/input/event3 (Video Bus)
[   29.619233] systemd-logind[4104]: Watching system buttons on /dev/input/event0 (Lid Switch)
[   29.623410] systemd-logind[4104]: Watching system buttons on /dev/input/event1 (Sleep Button)
[   29.629979] systemd-logind[4104]: Watching system buttons on /dev/input/event12 (ThinkPad Extra Buttons)
[   29.784546] e1000e 0000:00:19.0: irq 51 for MSI/MSI-X
[   29.888079] e1000e 0000:00:19.0: irq 51 for MSI/MSI-X
[   29.888203] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   30.063806] ata1.00: configured for UDMA/133
[   30.067518] ata1: EH complete
[   32.945572] psmouse serio2: alps: Unknown ALPS touchpad: E7=10 00 64, EC=10 00 64
[   33.957665] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
[   33.959331] iwlwifi 0000:03:00.0: Radio type=0x0-0x1-0x0
[   34.122822] psmouse serio2: trackpoint: IBM TrackPoint firmware: 0x0e, buttons: 3/3
[   34.182872] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
[   34.187346] iwlwifi 0000:03:00.0: Radio type=0x0-0x1-0x0
[   34.318041] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
[   34.379922] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/serio2/input/input15
[   36.838286] eth1: authenticate with 68:7f:74:06:b3:1b
[   36.846810] eth1: direct probe to 68:7f:74:06:b3:1b (try 1/3)
[   37.052084] eth1: send auth to 68:7f:74:06:b3:1b (try 2/3)
[   37.057952] eth1: authenticated
[   37.064097] eth1: associate with 68:7f:74:06:b3:1b (try 1/3)
[   37.074793] eth1: RX AssocResp from 68:7f:74:06:b3:1b (capab=0x31 status=0 aid=6)
[   37.084695] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
[   37.089001] eth1: associated
[   43.924394] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   43.925967] Bluetooth: BNEP filters: protocol multicast
[   43.927485] Bluetooth: BNEP socket layer initialized
[   43.968685] Bluetooth: RFCOMM TTY layer initialized
[   43.970247] Bluetooth: RFCOMM socket layer initialized
[   43.971774] Bluetooth: RFCOMM ver 1.11
[   45.313667] systemd-readahead[2611]: Failed to read event: File too large
[   46.414540] tun: Universal TUN/TAP device driver, 1.6
[   46.419315] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   46.480300] ip_tables: (C) 2000-2006 Netfilter Core Team
[   46.500256] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[ 4989.863668] ------------[ cut here ]------------
[ 4989.863689] WARNING: at drivers/net/wireless/iwlwifi/pcie/tx.c:1396 iwl_pcie_hcmd_complete+0xaa/0x371 [iwlwifi]()
[ 4989.863692] wrong command queue 0 (should be 4), sequence 0x4A readp=112 writep=112
[ 4989.863693] Modules linked in: xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter xt_conntrack nf_conntrack ip_tables x_tables tun rfcomm bnep sch_sfq joydev iTCO_wdt 
iTCO_vendor_support pcmcia ext2 mbcache coretemp psmouse microcode serio_raw sdhci_pci pcspkr arc4 sdhci firewire_ohci sr_mod yenta_socket cdrom firewire_core pcmcia_rsrc 
lpc_ich cdc_ether iwldvm mmc_core crc_itu_t pcmcia_core mfd_core i2c_i801 usbnet mac80211 mii cdc_wdm uvcvideo videobuf2_core kvm_intel iwlwifi kvm cdc_acm videodev btusb 
media e1000e videobuf2_vmalloc usbhid cfg80211 videobuf2_memops bluetooth thinkpad_acpi crc16 ptp snd_hda_codec_conexant pps_core thermal rfkill wmi snd_hda_intel ac nvram 
snd_hda_codec evdev battery snd_hwdep snd_pcm snd_timer snd soundcore snd_page_alloc cpufreq_stats acpi_cpufreq processor
[ 4989.863743]  tcp_illinois mperf ipv6 autofs4 xfs(F) libcrc32c(F) crc32c(F) cbc(F) ablk_helper(F) cryptd(F) lrw(F) gf128mul(F) glue_helper(F) aes_x86_64(F) dm_crypt(F) dm_mod(F) 
sd_mod(F) crc_t10dif(F) ahci(F) libahci(F) libata(F) scsi_mod(F) hid_logitech_dj(F) hid(F) uhci_hcd(F) ehci_pci(F) ehci_hcd(F) usbcore(F) usb_common(F)
[ 4989.863765] CPU: 0 PID: 3847 Comm: irq/52-iwlwifi Tainted: GF            3.10.0-rc7-00135-g98b6ed0 #504
[ 4989.863767] Hardware name: LENOVO 2764CTO/2764CTO, BIOS 7UET94WW (3.24 ) 10/17/2012
[ 4989.863769]  0000000000018264 ffff8802302d5c98 ffffffff813b9ee0 ffff8802302d5cd0
[ 4989.863772]  ffffffff81030f66 ffff8802302d5ce0 0000000080000008 ffff8802302d5e00
[ 4989.863775]  ffff8801f8fff080 ffff880231fb4000 ffff8802302d5d30 ffffffff81030fc5
[ 4989.863778] Call Trace:
[ 4989.863784]  [<ffffffff813b9ee0>] dump_stack+0x19/0x1b
[ 4989.863789]  [<ffffffff81030f66>] warn_slowpath_common+0x60/0x78
[ 4989.863792]  [<ffffffff81030fc5>] warn_slowpath_fmt+0x47/0x49
[ 4989.863797]  [<ffffffff8105d076>] ? set_next_entity+0x3f/0x96
[ 4989.863803]  [<ffffffffa04c8ab8>] iwl_pcie_hcmd_complete+0xaa/0x371 [iwlwifi]
[ 4989.863809]  [<ffffffffa04c6419>] iwl_pcie_irq_handler+0x660/0x79b [iwlwifi]
[ 4989.863814]  [<ffffffff81096d37>] ? irq_finalize_oneshot+0xb4/0xb4
[ 4989.863817]  [<ffffffff81096d50>] irq_thread_fn+0x19/0x31
[ 4989.863819]  [<ffffffff81096fa8>] irq_thread+0xd1/0x13c
[ 4989.863822]  [<ffffffff81096e41>] ? wake_threads_waitq+0x3f/0x3f
[ 4989.863825]  [<ffffffff81096ed7>] ? irq_thread_dtor+0x96/0x96
[ 4989.863829]  [<ffffffff8104d6d3>] kthread+0xb5/0xbd
[ 4989.863832]  [<ffffffff8104d61e>] ? kthread_create_on_node+0x113/0x113
[ 4989.863836]  [<ffffffff813bf4ec>] ret_from_fork+0x7c/0xb0
[ 4989.863839]  [<ffffffff8104d61e>] ? kthread_create_on_node+0x113/0x113
[ 4989.863841] ---[ end trace 20d78ce40090ed50 ]---
[ 4989.863844] iwl data: 00000000: 0e 00 50 f2 04 10 4a 00 01 10 10 44 00 01 02 dd  ..P...J....D....
[ 4989.863846] iwl data: 00000010: 00 00 00 00 1f 59 41 33 71 01 06 00 09 e0 00 00  .....YA3q.......


config
#
# Automatically generated file; DO NOT EDIT.
# Linux/x86 3.10.0-rc7 Kernel Configuration
#
CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_HAVE_INTEL_TXT=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
CONFIG_KERNEL_XZ=y
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_FHANDLE=y
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y
# CONFIG_AUDIT_LOGINUID_IMMUTABLE is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
# CONFIG_NO_HZ_FULL is not set
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_STALL_COMMON=y
# CONFIG_RCU_USER_QS is not set
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_RCU_BOOST=y
CONFIG_RCU_BOOST_PRIO=1
CONFIG_RCU_BOOST_DELAY=500
# CONFIG_RCU_NOCB_CPU is not set
CONFIG_IKCONFIG=m
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=19
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_MEMCG is not set
# CONFIG_CGROUP_HUGETLB is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_BLK_CGROUP=y
# CONFIG_DEBUG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HOTPLUG=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
# CONFIG_EXPERT is not set
CONFIG_UID16=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_PCI_QUIRKS=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=m
CONFIG_OPROFILE_EVENT_MULTIPLEX=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_KPROBES is not set
# CONFIG_JUMP_LABEL is not set
CONFIG_UPROBES=y
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_CLK=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_MODULE_SIG=y
# CONFIG_MODULE_SIG_FORCE is not set
CONFIG_MODULE_SIG_ALL=y
CONFIG_MODULE_SIG_SHA1=y
# CONFIG_MODULE_SIG_SHA224 is not set
# CONFIG_MODULE_SIG_SHA256 is not set
# CONFIG_MODULE_SIG_SHA384 is not set
# CONFIG_MODULE_SIG_SHA512 is not set
CONFIG_MODULE_SIG_HASH="sha1"
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_DEV_THROTTLING=y

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
CONFIG_ACORN_PARTITION_CUMANA=y
CONFIG_ACORN_PARTITION_EESOX=y
CONFIG_ACORN_PARTITION_ICS=y
CONFIG_ACORN_PARTITION_ADFS=y
CONFIG_ACORN_PARTITION_POWERTEC=y
CONFIG_ACORN_PARTITION_RISCIX=y
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
CONFIG_ATARI_PARTITION=y
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
CONFIG_SGI_PARTITION=y
CONFIG_ULTRIX_PARTITION=y
CONFIG_SUN_PARTITION=y
# CONFIG_KARMA_PARTITION is not set
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=m
CONFIG_CFQ_GROUP_IOSCHED=y
CONFIG_DEFAULT_DEADLINE=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="deadline"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_PADATA=y
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_X2APIC=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_INTEL_LPSS=y
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
# CONFIG_HYPERVISOR_GUEST is not set
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
CONFIG_MCORE2=y
# CONFIG_MATOM is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
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
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=2
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=m
CONFIG_X86_THERMAL_VECTOR=y
# CONFIG_I8K is not set
CONFIG_MICROCODE=m
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_MICROCODE_INTEL_LIB=y
CONFIG_MICROCODE_INTEL_EARLY=y
CONFIG_MICROCODE_EARLY=y
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_NEED_BOUNCE_POOL=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=65536
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_CLEANCACHE=y
CONFIG_FRONTSWAP=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
CONFIG_EFI=y
CONFIG_EFI_STUB=y
CONFIG_SECCOMP=y
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
# CONFIG_KEXEC_JUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
# CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
CONFIG_PM_WAKELOCKS_GC=y
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_PM_CLK=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=m
CONFIG_ACPI_BATTERY=m
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=m
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_I2C=y
CONFIG_ACPI_PROCESSOR=m
CONFIG_ACPI_IPMI=m
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
CONFIG_ACPI_THERMAL=m
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_INITRD_TABLE_OVERRIDE=y
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_SBS=m
CONFIG_ACPI_HED=y
CONFIG_ACPI_CUSTOM_METHOD=m
CONFIG_ACPI_BGRT=y
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
CONFIG_ACPI_APEI_PCIEAER=y
CONFIG_ACPI_APEI_EINJ=m
CONFIG_ACPI_APEI_ERST_DEBUG=m
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=m
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=m
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m

#
# x86 CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
CONFIG_X86_PCC_CPUFREQ=m
CONFIG_X86_ACPI_CPUFREQ=m
# CONFIG_X86_ACPI_CPUFREQ_CPB is not set
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_AMD_FREQ_SENSITIVITY is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
CONFIG_INTEL_IDLE=y

#
# Memory power savings
#
CONFIG_I7300_IDLE_IOAT_CHANNEL=y
CONFIG_I7300_IDLE=m

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=m
CONFIG_PCIEAER=y
# CONFIG_PCIE_ECRC is not set
CONFIG_PCIEAER_INJECT=m
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
CONFIG_PCI_STUB=m
CONFIG_HT_IRQ=y
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
CONFIG_PCI_IOAPIC=y
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=m
CONFIG_PCMCIA=m
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=m
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
CONFIG_PD6729=m
CONFIG_I82092=m
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=m
CONFIG_HOTPLUG_PCI_CPCI=y
# CONFIG_HOTPLUG_PCI_CPCI_ZT5550 is not set
CONFIG_HOTPLUG_PCI_CPCI_GENERIC=m
CONFIG_HOTPLUG_PCI_SHPC=m
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=m
CONFIG_COREDUMP=y
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
# CONFIG_X86_X32 is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_KEYS_COMPAT=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y
CONFIG_COMPAT_NETLINK_MESSAGES=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=m
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=m
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=m
CONFIG_XFRM_USER=m
# CONFIG_XFRM_SUB_POLICY is not set
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
# CONFIG_IP_FIB_TRIE_STATS is not set
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_ROUTE_CLASSID=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
CONFIG_IP_PNP_RARP=y
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE_DEMUX=m
CONFIG_NET_IP_TUNNEL=m
CONFIG_NET_IPGRE=m
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE=y
CONFIG_IP_MROUTE_MULTIPLE_TABLES=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
CONFIG_NET_IPVTI=m
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
CONFIG_INET_XFRM_MODE_TRANSPORT=m
CONFIG_INET_XFRM_MODE_TUNNEL=m
CONFIG_INET_XFRM_MODE_BEET=m
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
CONFIG_INET_UDP_DIAG=m
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=m
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=m
CONFIG_TCP_CONG_HSTCP=m
CONFIG_TCP_CONG_HYBLA=m
CONFIG_TCP_CONG_VEGAS=m
CONFIG_TCP_CONG_SCALABLE=m
CONFIG_TCP_CONG_LP=m
CONFIG_TCP_CONG_VENO=m
CONFIG_TCP_CONG_YEAH=m
CONFIG_TCP_CONG_ILLINOIS=m
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=m
CONFIG_IPV6_PRIVACY=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
CONFIG_INET6_IPCOMP=m
CONFIG_IPV6_MIP6=m
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
CONFIG_INET6_XFRM_MODE_TUNNEL=m
CONFIG_INET6_XFRM_MODE_BEET=m
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=m
CONFIG_IPV6_SIT=m
CONFIG_IPV6_SIT_6RD=y
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
CONFIG_IPV6_GRE=m
CONFIG_IPV6_MULTIPLE_TABLES=y
CONFIG_IPV6_SUBTREES=y
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=y
CONFIG_IPV6_PIMSM_V2=y
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_NETLINK_ACCT=m
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_ZONES=y
# CONFIG_NF_CONNTRACK_PROCFS is not set
CONFIG_NF_CONNTRACK_EVENTS=y
CONFIG_NF_CONNTRACK_TIMEOUT=y
CONFIG_NF_CONNTRACK_TIMESTAMP=y
CONFIG_NF_CONNTRACK_LABELS=y
CONFIG_NF_CT_PROTO_DCCP=m
CONFIG_NF_CT_PROTO_GRE=m
CONFIG_NF_CT_PROTO_SCTP=m
CONFIG_NF_CT_PROTO_UDPLITE=m
CONFIG_NF_CONNTRACK_AMANDA=m
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_H323=m
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_BROADCAST=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
CONFIG_NF_CONNTRACK_SNMP=m
CONFIG_NF_CONNTRACK_PPTP=m
CONFIG_NF_CONNTRACK_SANE=m
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=m
CONFIG_NF_CT_NETLINK=m
CONFIG_NF_CT_NETLINK_TIMEOUT=m
CONFIG_NF_CT_NETLINK_HELPER=m
CONFIG_NETFILTER_NETLINK_QUEUE_CT=y
CONFIG_NF_NAT=m
CONFIG_NF_NAT_NEEDED=y
CONFIG_NF_NAT_PROTO_DCCP=m
CONFIG_NF_NAT_PROTO_UDPLITE=m
CONFIG_NF_NAT_PROTO_SCTP=m
CONFIG_NF_NAT_AMANDA=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
CONFIG_NF_NAT_SIP=m
CONFIG_NF_NAT_TFTP=m
CONFIG_NETFILTER_TPROXY=m
CONFIG_NETFILTER_XTABLES=m

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=m
CONFIG_NETFILTER_XT_CONNMARK=m
CONFIG_NETFILTER_XT_SET=m

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_AUDIT=m
CONFIG_NETFILTER_XT_TARGET_CHECKSUM=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
CONFIG_NETFILTER_XT_TARGET_CT=m
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_HL=m
CONFIG_NETFILTER_XT_TARGET_HMARK=m
CONFIG_NETFILTER_XT_TARGET_IDLETIMER=m
CONFIG_NETFILTER_XT_TARGET_LED=m
CONFIG_NETFILTER_XT_TARGET_LOG=m
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_TARGET_NETMAP=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
# CONFIG_NETFILTER_XT_TARGET_NOTRACK is not set
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
CONFIG_NETFILTER_XT_TARGET_REDIRECT=m
CONFIG_NETFILTER_XT_TARGET_TEE=m
CONFIG_NETFILTER_XT_TARGET_TPROXY=m
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_NETFILTER_XT_TARGET_SECMARK=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=m
CONFIG_NETFILTER_XT_MATCH_BPF=m
CONFIG_NETFILTER_XT_MATCH_CLUSTER=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNLABEL=m
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_CPU=m
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DEVGROUP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ECN=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_HL=m
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
CONFIG_NETFILTER_XT_MATCH_IPVS=m
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
CONFIG_NETFILTER_XT_MATCH_NFACCT=m
CONFIG_NETFILTER_XT_MATCH_OSF=m
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_RECENT=m
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_SOCKET=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_TIME=m
CONFIG_NETFILTER_XT_MATCH_U32=m
CONFIG_IP_SET=m
CONFIG_IP_SET_MAX=256
CONFIG_IP_SET_BITMAP_IP=m
CONFIG_IP_SET_BITMAP_IPMAC=m
CONFIG_IP_SET_BITMAP_PORT=m
CONFIG_IP_SET_HASH_IP=m
CONFIG_IP_SET_HASH_IPPORT=m
CONFIG_IP_SET_HASH_IPPORTIP=m
CONFIG_IP_SET_HASH_IPPORTNET=m
CONFIG_IP_SET_HASH_NET=m
CONFIG_IP_SET_HASH_NETPORT=m
CONFIG_IP_SET_HASH_NETIFACE=m
CONFIG_IP_SET_LIST_SET=m
CONFIG_IP_VS=m
CONFIG_IP_VS_IPV6=y
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_AH_ESP=y
CONFIG_IP_VS_PROTO_ESP=y
CONFIG_IP_VS_PROTO_AH=y
CONFIG_IP_VS_PROTO_SCTP=y

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=m
CONFIG_IP_VS_WRR=m
CONFIG_IP_VS_LC=m
CONFIG_IP_VS_WLC=m
CONFIG_IP_VS_LBLC=m
CONFIG_IP_VS_LBLCR=m
CONFIG_IP_VS_DH=m
CONFIG_IP_VS_SH=m
CONFIG_IP_VS_SED=m
CONFIG_IP_VS_NQ=m

#
# IPVS SH scheduler
#
CONFIG_IP_VS_SH_TAB_BITS=8

#
# IPVS application helper
#
CONFIG_IP_VS_FTP=m
CONFIG_IP_VS_NFCT=y
CONFIG_IP_VS_PE_SIP=m

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_CONNTRACK_IPV4=m
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_RPFILTER=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_ULOG=m
CONFIG_NF_NAT_IPV4=m
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_NF_NAT_SNMP_BASIC=m
CONFIG_NF_NAT_PROTO_GRE=m
CONFIG_NF_NAT_PPTP=m
CONFIG_NF_NAT_H323=m
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_CLUSTERIP=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_SECURITY=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV6=m
CONFIG_NF_CONNTRACK_IPV6=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_AH=m
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_MH=m
CONFIG_IP6_NF_MATCH_RPFILTER=m
CONFIG_IP6_NF_MATCH_RT=m
CONFIG_IP6_NF_TARGET_HL=m
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_RAW=m
CONFIG_IP6_NF_SECURITY=m
CONFIG_NF_NAT_IPV6=m
CONFIG_IP6_NF_TARGET_MASQUERADE=m
CONFIG_IP6_NF_TARGET_NPT=m
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
CONFIG_BRIDGE_EBT_IP6=m
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
CONFIG_BRIDGE_EBT_PKTTYPE=m
CONFIG_BRIDGE_EBT_STP=m
CONFIG_BRIDGE_EBT_VLAN=m
CONFIG_BRIDGE_EBT_ARPREPLY=m
CONFIG_BRIDGE_EBT_DNAT=m
CONFIG_BRIDGE_EBT_MARK_T=m
CONFIG_BRIDGE_EBT_REDIRECT=m
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=m
CONFIG_BRIDGE_EBT_ULOG=m
CONFIG_BRIDGE_EBT_NFLOG=m
CONFIG_IP_DCCP=m
CONFIG_INET_DCCP_DIAG=m

#
# DCCP CCIDs Configuration
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
CONFIG_IP_DCCP_CCID3=y
# CONFIG_IP_DCCP_CCID3_DEBUG is not set
CONFIG_IP_DCCP_TFRC_LIB=y

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
CONFIG_IP_SCTP=m
# CONFIG_SCTP_DBG_MSG is not set
# CONFIG_SCTP_DBG_OBJCNT is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1 is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
CONFIG_SCTP_COOKIE_HMAC_MD5=y
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
CONFIG_RDS=m
CONFIG_RDS_TCP=m
# CONFIG_RDS_DEBUG is not set
CONFIG_TIPC=m
CONFIG_TIPC_PORTS=8191
# CONFIG_ATM is not set
CONFIG_L2TP=m
# CONFIG_L2TP_DEBUGFS is not set
CONFIG_L2TP_V3=y
CONFIG_L2TP_IP=m
CONFIG_L2TP_ETH=m
CONFIG_STP=m
CONFIG_GARP=m
CONFIG_MRP=m
CONFIG_BRIDGE=m
CONFIG_BRIDGE_IGMP_SNOOPING=y
CONFIG_BRIDGE_VLAN_FILTERING=y
CONFIG_HAVE_NET_DSA=y
CONFIG_VLAN_8021Q=m
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_VLAN_8021Q_MVRP=y
# CONFIG_DECNET is not set
CONFIG_LLC=m
CONFIG_LLC2=m
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
CONFIG_X25=m
CONFIG_LAPB=m
# CONFIG_PHONET is not set
CONFIG_IEEE802154=m
CONFIG_IEEE802154_6LOWPAN=m
CONFIG_MAC802154=m
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_PRIO=m
CONFIG_NET_SCH_MULTIQ=m
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFB=m
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
CONFIG_NET_SCH_DRR=m
CONFIG_NET_SCH_MQPRIO=m
CONFIG_NET_SCH_CHOKE=m
CONFIG_NET_SCH_QFQ=m
CONFIG_NET_SCH_CODEL=m
CONFIG_NET_SCH_FQ_CODEL=m
CONFIG_NET_SCH_INGRESS=m
CONFIG_NET_SCH_PLUG=m

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
CONFIG_NET_CLS_FLOW=m
CONFIG_NET_CLS_CGROUP=m
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
CONFIG_NET_EMATCH_NBYTE=m
CONFIG_NET_EMATCH_U32=m
CONFIG_NET_EMATCH_META=m
CONFIG_NET_EMATCH_TEXT=m
CONFIG_NET_EMATCH_CANID=m
CONFIG_NET_EMATCH_IPSET=m
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=m
# CONFIG_GACT_PROB is not set
CONFIG_NET_ACT_MIRRED=m
CONFIG_NET_ACT_IPT=m
CONFIG_NET_ACT_NAT=m
CONFIG_NET_ACT_PEDIT=m
# CONFIG_NET_ACT_SIMP is not set
CONFIG_NET_ACT_SKBEDIT=m
CONFIG_NET_ACT_CSUM=m
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=m
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=m
CONFIG_VSOCKETS=m
CONFIG_VMWARE_VMCI_VSOCKETS=m
CONFIG_NETLINK_MMAP=y
CONFIG_NETLINK_DIAG=m
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_NETPRIO_CGROUP=m
CONFIG_BQL=y
CONFIG_BPF_JIT=y

#
# Network testing
#
CONFIG_NET_PKTGEN=m
# CONFIG_NET_DROP_MONITOR is not set
# CONFIG_HAMRADIO is not set
CONFIG_CAN=m
CONFIG_CAN_RAW=m
CONFIG_CAN_BCM=m
CONFIG_CAN_GW=m

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=m
CONFIG_CAN_SLCAN=m
CONFIG_CAN_DEV=m
CONFIG_CAN_CALC_BITTIMING=y
CONFIG_CAN_LEDS=y
# CONFIG_PCH_CAN is not set
# CONFIG_CAN_SJA1000 is not set
# CONFIG_CAN_C_CAN is not set
# CONFIG_CAN_CC770 is not set

#
# CAN USB interfaces
#
# CONFIG_CAN_EMS_USB is not set
# CONFIG_CAN_ESD_USB2 is not set
# CONFIG_CAN_KVASER_USB is not set
# CONFIG_CAN_PEAK_USB is not set
# CONFIG_CAN_8DEV_USB is not set
# CONFIG_CAN_SOFTING is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
# CONFIG_IRDA is not set
CONFIG_BT=m
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=m
CONFIG_BT_HCIBTSDIO=m
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
# CONFIG_BT_HCIUART_ATH3K is not set
CONFIG_BT_HCIUART_LL=y
CONFIG_BT_HCIUART_3WIRE=y
CONFIG_BT_HCIBCM203X=m
CONFIG_BT_HCIBPA10X=m
CONFIG_BT_HCIBFUSB=m
CONFIG_BT_HCIDTL1=m
CONFIG_BT_HCIBT3C=m
CONFIG_BT_HCIBLUECARD=m
CONFIG_BT_HCIBTUART=m
CONFIG_BT_HCIVHCI=m
# CONFIG_BT_MRVL is not set
# CONFIG_BT_ATH3K is not set
CONFIG_AF_RXRPC=m
# CONFIG_AF_RXRPC_DEBUG is not set
CONFIG_RXKAD=m
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_WEXT_PRIV=y
CONFIG_CFG80211=m
CONFIG_NL80211_TESTMODE=y
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_REG_DEBUG is not set
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
CONFIG_CFG80211_WEXT=y
# CONFIG_LIB80211 is not set
CONFIG_MAC80211=m
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_MINSTREL_HT=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
# CONFIG_MAC80211_MESH is not set
CONFIG_MAC80211_LEDS=y
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_MESSAGE_TRACING is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
CONFIG_WIMAX=m
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=m
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
CONFIG_RFKILL_REGULATOR=m
CONFIG_RFKILL_GPIO=m
# CONFIG_NET_9P is not set
CONFIG_CAIF=m
# CONFIG_CAIF_DEBUG is not set
CONFIG_CAIF_NETDEV=m
# CONFIG_CAIF_USB is not set
CONFIG_CEPH_LIB=m
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
CONFIG_NFC=m
CONFIG_NFC_NCI=m
CONFIG_NFC_HCI=m
CONFIG_NFC_SHDLC=y

#
# Near Field Communication (NFC) devices
#
# CONFIG_NFC_PN533 is not set
# CONFIG_NFC_MEI_PHY is not set
# CONFIG_NFC_PN544 is not set
# CONFIG_NFC_MICROREAD is not set
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
CONFIG_CONNECTOR=m
# CONFIG_MTD is not set
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_SERIAL=m
CONFIG_PARPORT_PC_FIFO=y
CONFIG_PARPORT_PC_SUPERIO=y
CONFIG_PARPORT_PC_PCMCIA=m
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=m
# CONFIG_PARIDE is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
CONFIG_BLK_DEV_CRYPTOLOOP=m
CONFIG_BLK_DEV_DRBD=m
# CONFIG_DRBD_FAULT_INJECTION is not set
CONFIG_BLK_DEV_NBD=m
CONFIG_BLK_DEV_NVME=m
CONFIG_BLK_DEV_OSD=m
# CONFIG_BLK_DEV_SX8 is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
CONFIG_BLK_DEV_XIP=y
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
CONFIG_CDROM_PKTCDVD_WCACHE=y
CONFIG_ATA_OVER_ETH=m
CONFIG_VIRTIO_BLK=m
# CONFIG_BLK_DEV_HD is not set
CONFIG_BLK_DEV_RBD=m
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_AD525X_DPOT is not set
# CONFIG_ATMEL_PWM is not set
CONFIG_DUMMY_IRQ=m
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ATMEL_SSC is not set
CONFIG_ENCLOSURE_SERVICES=m
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
# CONFIG_ISL29003 is not set
# CONFIG_ISL29020 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_SENSORS_BH1780 is not set
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
# CONFIG_BMP085_I2C is not set
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_SRAM is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=m
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
CONFIG_INTEL_MEI=y
CONFIG_INTEL_MEI_ME=y
CONFIG_VMWARE_VMCI=m
CONFIG_HAVE_IDE=y
CONFIG_IDE=m

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_ATAPI=y
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_IDE_GD=m
CONFIG_IDE_GD_ATA=y
# CONFIG_IDE_GD_ATAPI is not set
CONFIG_BLK_DEV_IDECS=m
# CONFIG_BLK_DEV_DELKIN is not set
CONFIG_BLK_DEV_IDECD=m
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
CONFIG_BLK_DEV_IDETAPE=m
CONFIG_BLK_DEV_IDEACPI=y
CONFIG_IDE_TASK_IOCTL=y
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=m
CONFIG_BLK_DEV_PLATFORM=m
# CONFIG_BLK_DEV_CMD640 is not set
CONFIG_BLK_DEV_IDEPNP=m
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
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
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
CONFIG_BLK_DEV_PIIX=m
# CONFIG_BLK_DEV_IT8172 is not set
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
CONFIG_SCSI_MOD=m
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=m
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=m
CONFIG_CHR_DEV_OSST=m
CONFIG_BLK_DEV_SR=m
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=m
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_ENCLOSURE=m
CONFIG_SCSI_MULTI_LUN=y
# CONFIG_SCSI_CONSTANTS is not set
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
# CONFIG_SCSI_SAS_ATA is not set
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=m
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=m
CONFIG_ISCSI_BOOT_SYSFS=m
# CONFIG_SCSI_CXGB3_ISCSI is not set
# CONFIG_SCSI_CXGB4_ISCSI is not set
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_SCSI_BNX2X_FCOE is not set
# CONFIG_BE2ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_HPSA is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_MVUMI is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_MPT3SAS is not set
CONFIG_SCSI_UFSHCD=m
CONFIG_SCSI_UFSHCD_PCI=m
CONFIG_SCSI_UFSHCD_PLATFORM=m
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
CONFIG_VMWARE_PVSCSI=m
CONFIG_LIBFC=m
CONFIG_LIBFCOE=m
CONFIG_FCOE=m
# CONFIG_FCOE_FNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_ISCI is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_PPA is not set
# CONFIG_SCSI_IMM is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_BFA_FC is not set
CONFIG_SCSI_VIRTIO=m
# CONFIG_SCSI_CHELSIO_FCOE is not set
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
CONFIG_SCSI_DH=m
CONFIG_SCSI_DH_RDAC=m
# CONFIG_SCSI_DH_HP_SW is not set
# CONFIG_SCSI_DH_EMC is not set
CONFIG_SCSI_DH_ALUA=m
CONFIG_SCSI_OSD_INITIATOR=m
CONFIG_SCSI_OSD_ULD=m
CONFIG_SCSI_OSD_DPRINT_SENSE=1
# CONFIG_SCSI_OSD_DEBUG is not set
CONFIG_ATA=m
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
CONFIG_SATA_ZPODD=y
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=m
CONFIG_SATA_AHCI_PLATFORM=m
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_SX4 is not set
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=m
# CONFIG_SATA_HIGHBANK is not set
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_SVW is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set

#
# PATA SFF controllers with BMDMA
#
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARASAN_CF is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CS5536 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87415 is not set
CONFIG_PATA_OLDPIIX=m
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RDC is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SCH is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_TOSHIBA is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
CONFIG_PATA_MPIIX=m
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_PCMCIA is not set
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
CONFIG_PATA_ACPI=m
CONFIG_ATA_GENERIC=m
CONFIG_PATA_LEGACY=m
CONFIG_MD=y
CONFIG_BLK_DEV_MD=m
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
CONFIG_MD_MULTIPATH=m
CONFIG_MD_FAULTY=m
CONFIG_BCACHE=m
# CONFIG_BCACHE_DEBUG is not set
# CONFIG_BCACHE_EDEBUG is not set
# CONFIG_BCACHE_CLOSURES_DEBUG is not set
CONFIG_BLK_DEV_DM=m
# CONFIG_DM_DEBUG is not set
CONFIG_DM_BUFIO=m
CONFIG_DM_BIO_PRISON=m
CONFIG_DM_PERSISTENT_DATA=m
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_THIN_PROVISIONING=m
# CONFIG_DM_DEBUG_BLOCK_STACK_TRACING is not set
CONFIG_DM_CACHE=m
CONFIG_DM_CACHE_MQ=m
CONFIG_DM_CACHE_CLEANER=m
CONFIG_DM_MIRROR=m
CONFIG_DM_RAID=m
CONFIG_DM_LOG_USERSPACE=m
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
CONFIG_DM_MULTIPATH_QL=m
CONFIG_DM_MULTIPATH_ST=m
# CONFIG_DM_DELAY is not set
# CONFIG_DM_UEVENT is not set
# CONFIG_DM_FLAKEY is not set
CONFIG_DM_VERITY=m
CONFIG_TARGET_CORE=m
CONFIG_TCM_IBLOCK=m
CONFIG_TCM_FILEIO=m
CONFIG_TCM_PSCSI=m
CONFIG_LOOPBACK_TARGET=m
CONFIG_TCM_FC=m
CONFIG_ISCSI_TARGET=m
CONFIG_SBP_TARGET=m
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_SBP2=m
CONFIG_FIREWIRE_NET=m
# CONFIG_FIREWIRE_NOSY is not set
CONFIG_I2O=m
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
# CONFIG_I2O_EXT_ADAPTEC is not set
CONFIG_I2O_CONFIG=m
CONFIG_I2O_CONFIG_OLD_IOCTL=y
CONFIG_I2O_BUS=m
CONFIG_I2O_BLOCK=m
CONFIG_I2O_SCSI=m
CONFIG_I2O_PROC=m
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
CONFIG_BONDING=m
CONFIG_DUMMY=m
CONFIG_EQUALIZER=m
CONFIG_NET_FC=y
CONFIG_MII=m
CONFIG_IFB=m
CONFIG_NET_TEAM=m
CONFIG_NET_TEAM_MODE_BROADCAST=m
CONFIG_NET_TEAM_MODE_ROUNDROBIN=m
CONFIG_NET_TEAM_MODE_RANDOM=m
CONFIG_NET_TEAM_MODE_ACTIVEBACKUP=m
CONFIG_NET_TEAM_MODE_LOADBALANCE=m
CONFIG_MACVLAN=m
CONFIG_MACVTAP=m
CONFIG_VXLAN=m
CONFIG_NETCONSOLE=m
# CONFIG_NETCONSOLE_DYNAMIC is not set
CONFIG_NETPOLL=y
CONFIG_NETPOLL_TRAP=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_NTB_NETDEV=m
CONFIG_TUN=m
CONFIG_VETH=m
CONFIG_VIRTIO_NET=m
# CONFIG_ARCNET is not set

#
# CAIF transport drivers
#
CONFIG_CAIF_TTY=m
# CONFIG_CAIF_SPI_SLAVE is not set
# CONFIG_CAIF_HSI is not set
CONFIG_CAIF_VIRTIO=m
CONFIG_VHOST_NET=m
CONFIG_VHOST_SCSI=m
CONFIG_VHOST_RING=m

#
# Distributed Switch Architecture drivers
#
# CONFIG_NET_DSA_MV88E6XXX is not set
# CONFIG_NET_DSA_MV88E6060 is not set
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
# CONFIG_NET_DSA_MV88E6131 is not set
# CONFIG_NET_DSA_MV88E6123_61_65 is not set
CONFIG_ETHERNET=y
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_NET_VENDOR_ADAPTEC is not set
# CONFIG_NET_VENDOR_ALTEON is not set
# CONFIG_NET_VENDOR_AMD is not set
# CONFIG_NET_VENDOR_ATHEROS is not set
CONFIG_NET_CADENCE=y
# CONFIG_ARM_AT91_ETHER is not set
# CONFIG_MACB is not set
# CONFIG_NET_VENDOR_BROADCOM is not set
# CONFIG_NET_VENDOR_BROCADE is not set
# CONFIG_NET_CALXEDA_XGMAC is not set
# CONFIG_NET_VENDOR_CHELSIO is not set
# CONFIG_NET_VENDOR_CISCO is not set
# CONFIG_DNET is not set
# CONFIG_NET_VENDOR_DEC is not set
# CONFIG_NET_VENDOR_DLINK is not set
# CONFIG_NET_VENDOR_EMULEX is not set
# CONFIG_NET_VENDOR_EXAR is not set
# CONFIG_NET_VENDOR_FUJITSU is not set
# CONFIG_NET_VENDOR_HP is not set
CONFIG_NET_VENDOR_INTEL=y
# CONFIG_E100 is not set
# CONFIG_E1000 is not set
CONFIG_E1000E=m
# CONFIG_IGB is not set
# CONFIG_IGBVF is not set
# CONFIG_IXGB is not set
# CONFIG_IXGBE is not set
# CONFIG_IXGBEVF is not set
# CONFIG_NET_VENDOR_I825XX is not set
# CONFIG_IP1000 is not set
# CONFIG_JME is not set
# CONFIG_NET_VENDOR_MARVELL is not set
# CONFIG_NET_VENDOR_MELLANOX is not set
# CONFIG_NET_VENDOR_MICREL is not set
# CONFIG_NET_VENDOR_MYRI is not set
# CONFIG_FEALNX is not set
# CONFIG_NET_VENDOR_NATSEMI is not set
# CONFIG_NET_VENDOR_NVIDIA is not set
# CONFIG_NET_VENDOR_OKI is not set
# CONFIG_ETHOC is not set
# CONFIG_NET_PACKET_ENGINE is not set
# CONFIG_NET_VENDOR_QLOGIC is not set
# CONFIG_NET_VENDOR_REALTEK is not set
# CONFIG_NET_VENDOR_RDC is not set
# CONFIG_NET_VENDOR_SEEQ is not set
# CONFIG_NET_VENDOR_SILAN is not set
# CONFIG_NET_VENDOR_SIS is not set
# CONFIG_SFC is not set
# CONFIG_NET_VENDOR_SMSC is not set
# CONFIG_NET_VENDOR_STMICRO is not set
# CONFIG_NET_VENDOR_SUN is not set
# CONFIG_NET_VENDOR_TEHUTI is not set
# CONFIG_NET_VENDOR_TI is not set
# CONFIG_NET_VENDOR_VIA is not set
# CONFIG_NET_VENDOR_WIZNET is not set
# CONFIG_NET_VENDOR_XIRCOM is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_AT803X_PHY is not set
# CONFIG_AMD_PHY is not set
# CONFIG_MARVELL_PHY is not set
# CONFIG_DAVICOM_PHY is not set
# CONFIG_QSEMI_PHY is not set
CONFIG_LXT_PHY=m
# CONFIG_CICADA_PHY is not set
# CONFIG_VITESSE_PHY is not set
# CONFIG_SMSC_PHY is not set
# CONFIG_BROADCOM_PHY is not set
# CONFIG_BCM87XX_PHY is not set
# CONFIG_ICPLUS_PHY is not set
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
# CONFIG_STE10XP is not set
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_MICREL_PHY is not set
CONFIG_FIXED_PHY=y
CONFIG_MDIO_BITBANG=m
CONFIG_MDIO_GPIO=m
CONFIG_PLIP=m
CONFIG_PPP=m
CONFIG_PPP_BSDCOMP=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_FILTER=y
CONFIG_PPP_MPPE=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPPOE=m
CONFIG_PPTP=m
CONFIG_PPPOL2TP=m
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_SLIP=m
CONFIG_SLHC=m
CONFIG_SLIP_COMPRESSED=y
CONFIG_SLIP_SMART=y
CONFIG_SLIP_MODE_SLIP6=y

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_RTL8152 is not set
CONFIG_USB_USBNET=m
CONFIG_USB_NET_AX8817X=m
CONFIG_USB_NET_AX88179_178A=m
CONFIG_USB_NET_CDCETHER=m
CONFIG_USB_NET_CDC_EEM=m
CONFIG_USB_NET_CDC_NCM=m
CONFIG_USB_NET_CDC_MBIM=m
# CONFIG_USB_NET_DM9601 is not set
# CONFIG_USB_NET_SMSC75XX is not set
# CONFIG_USB_NET_SMSC95XX is not set
# CONFIG_USB_NET_GL620A is not set
CONFIG_USB_NET_NET1080=m
# CONFIG_USB_NET_PLUSB is not set
CONFIG_USB_NET_MCS7830=m
CONFIG_USB_NET_RNDIS_HOST=m
CONFIG_USB_NET_CDC_SUBSET=m
# CONFIG_USB_ALI_M5632 is not set
# CONFIG_USB_AN2720 is not set
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
# CONFIG_USB_EPSON2888 is not set
# CONFIG_USB_KC2190 is not set
CONFIG_USB_NET_ZAURUS=m
# CONFIG_USB_NET_CX82310_ETH is not set
# CONFIG_USB_NET_KALMIA is not set
CONFIG_USB_NET_QMI_WWAN=m
# CONFIG_USB_HSO is not set
# CONFIG_USB_NET_INT51X1 is not set
CONFIG_USB_IPHETH=m
CONFIG_USB_SIERRA_NET=m
# CONFIG_USB_VL600 is not set
CONFIG_WLAN=y
# CONFIG_PCMCIA_RAYCS is not set
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_AIRO is not set
# CONFIG_ATMEL is not set
# CONFIG_AT76C50X_USB is not set
# CONFIG_AIRO_CS is not set
# CONFIG_PCMCIA_WL3501 is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
CONFIG_USB_NET_RNDIS_WLAN=m
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
# CONFIG_ADM8211 is not set
CONFIG_MAC80211_HWSIM=m
# CONFIG_MWL8K is not set
# CONFIG_ATH_CARDS is not set
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
# CONFIG_BRCMFMAC is not set
# CONFIG_HOSTAP is not set
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
CONFIG_IWLWIFI=m
CONFIG_IWLDVM=m
CONFIG_IWLMVM=m
CONFIG_IWLWIFI_OPMODE_MODULAR=y

#
# Debugging Options
#
# CONFIG_IWLWIFI_DEBUG is not set
# CONFIG_IWLWIFI_DEVICE_TRACING is not set
CONFIG_IWLWIFI_DEVICE_TESTMODE=y
CONFIG_IWLWIFI_P2P=y
# CONFIG_IWL4965 is not set
# CONFIG_IWL3945 is not set
# CONFIG_LIBERTAS is not set
# CONFIG_HERMES is not set
# CONFIG_P54_COMMON is not set
# CONFIG_RT2X00 is not set
# CONFIG_RTLWIFI is not set
# CONFIG_WL_TI is not set
# CONFIG_ZD1211RW is not set
# CONFIG_MWIFIEX is not set

#
# WiMAX Wireless Broadband devices
#
CONFIG_WIMAX_I2400M=m
CONFIG_WIMAX_I2400M_USB=m
CONFIG_WIMAX_I2400M_DEBUG_LEVEL=8
# CONFIG_WAN is not set
CONFIG_IEEE802154_DRIVERS=m
# CONFIG_IEEE802154_FAKEHARD is not set
CONFIG_IEEE802154_FAKELB=m
CONFIG_VMXNET3=m
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=m
CONFIG_INPUT_SPARSEKMAP=m
CONFIG_INPUT_MATRIXKMAP=m

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=m
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
CONFIG_KEYBOARD_GPIO=m
CONFIG_KEYBOARD_GPIO_POLLED=m
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
CONFIG_KEYBOARD_MATRIX=m
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_SAMSUNG is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
CONFIG_KEYBOARD_XTKBD=m
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=m
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_SERIAL=m
# CONFIG_MOUSE_APPLETOUCH is not set
CONFIG_MOUSE_BCM5974=m
# CONFIG_MOUSE_CYAPA is not set
# CONFIG_MOUSE_VSXXXAA is not set
CONFIG_MOUSE_GPIO=m
CONFIG_MOUSE_SYNAPTICS_I2C=m
CONFIG_MOUSE_SYNAPTICS_USB=m
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
# CONFIG_JOYSTICK_A3D is not set
CONFIG_JOYSTICK_ADI=m
# CONFIG_JOYSTICK_COBRA is not set
# CONFIG_JOYSTICK_GF2K is not set
# CONFIG_JOYSTICK_GRIP is not set
# CONFIG_JOYSTICK_GRIP_MP is not set
# CONFIG_JOYSTICK_GUILLEMOT is not set
# CONFIG_JOYSTICK_INTERACT is not set
# CONFIG_JOYSTICK_SIDEWINDER is not set
# CONFIG_JOYSTICK_TMDC is not set
# CONFIG_JOYSTICK_IFORCE is not set
CONFIG_JOYSTICK_WARRIOR=m
# CONFIG_JOYSTICK_MAGELLAN is not set
# CONFIG_JOYSTICK_SPACEORB is not set
# CONFIG_JOYSTICK_SPACEBALL is not set
# CONFIG_JOYSTICK_STINGER is not set
# CONFIG_JOYSTICK_TWIDJOY is not set
# CONFIG_JOYSTICK_ZHENHUA is not set
# CONFIG_JOYSTICK_DB9 is not set
# CONFIG_JOYSTICK_GAMECON is not set
# CONFIG_JOYSTICK_TURBOGRAFX is not set
# CONFIG_JOYSTICK_AS5011 is not set
CONFIG_JOYSTICK_JOYDUMP=m
# CONFIG_JOYSTICK_XPAD is not set
# CONFIG_JOYSTICK_WALKERA0701 is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_BMA150 is not set
CONFIG_INPUT_PCSPKR=m
# CONFIG_INPUT_MMA8450 is not set
# CONFIG_INPUT_MPU3050 is not set
# CONFIG_INPUT_APANEL is not set
# CONFIG_INPUT_GP2A is not set
CONFIG_INPUT_GPIO_TILT_POLLED=m
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_KXTJ9 is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_UINPUT=m
# CONFIG_INPUT_PCF8574 is not set
CONFIG_INPUT_PWM_BEEPER=m
# CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_IMS_PCU is not set
# CONFIG_INPUT_CMA3000 is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
CONFIG_SERIO_CT82C710=m
CONFIG_SERIO_PARKBD=m
CONFIG_SERIO_PCIPS2=m
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_SERIO_ARC_PS2 is not set
CONFIG_GAMEPORT=m
CONFIG_GAMEPORT_NS558=m
CONFIG_GAMEPORT_L4=m
CONFIG_GAMEPORT_EMU10K1=m
CONFIG_GAMEPORT_FM801=m

#
# Character devices
#
CONFIG_TTY=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
CONFIG_NOZOMI=m
CONFIG_N_GSM=m
# CONFIG_TRACE_SINK is not set
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_CS=m
CONFIG_SERIAL_8250_NR_UARTS=8
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=m
CONFIG_SERIAL_SCCNXP=y
CONFIG_SERIAL_SCCNXP_CONSOLE=y
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
CONFIG_PRINTER=m
CONFIG_LP_CONSOLE=y
CONFIG_PPDEV=m
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=m
CONFIG_IPMI_HANDLER=m
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=m
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=y
# CONFIG_HW_RANDOM_ATMEL is not set
CONFIG_HW_RANDOM_VIA=y
# CONFIG_HW_RANDOM_VIRTIO is not set
# CONFIG_HW_RANDOM_EXYNOS is not set
CONFIG_HW_RANDOM_TPM=m
CONFIG_NVRAM=m
# CONFIG_R3964 is not set
CONFIG_APPLICOM=m

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=m
# CONFIG_CARDMAN_4000 is not set
# CONFIG_CARDMAN_4040 is not set
CONFIG_IPWIRELESS=m
CONFIG_MWAVE=m
CONFIG_RAW_DRIVER=m
CONFIG_MAX_RAW_DEVS=1024
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=m
CONFIG_TCG_TPM=m
CONFIG_TCG_TIS=m
CONFIG_TCG_TIS_I2C_INFINEON=m
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=m
CONFIG_TCG_INFINEON=m
# CONFIG_TCG_ST33_I2C is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_GPIO=m
# CONFIG_I2C_MUX_PCA9541 is not set
# CONFIG_I2C_MUX_PCA954x is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=m
CONFIG_I2C_ALGOBIT=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=m
CONFIG_I2C_ISCH=m
CONFIG_I2C_ISMT=m
CONFIG_I2C_PIIX4=m
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
CONFIG_I2C_SCMI=m

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_CBUS_GPIO is not set
# CONFIG_I2C_DESIGNWARE_PLATFORM is not set
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_GPIO=m
CONFIG_I2C_INTEL_MID=m
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
CONFIG_I2C_PARPORT=m
CONFIG_I2C_PARPORT_LIGHT=m
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set

#
# Qualcomm MSM SSBI bus support
#
# CONFIG_SSBI is not set
CONFIG_HSI=m
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
CONFIG_HSI_CHAR=m

#
# PPS support
#
CONFIG_PPS=m
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
CONFIG_PPS_CLIENT_LDISC=m
CONFIG_PPS_CLIENT_PARPORT=m
CONFIG_PPS_CLIENT_GPIO=m

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=m

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
CONFIG_PTP_1588_CLOCK_PCH=m
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=m

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=m
# CONFIG_GPIO_IT8761E is not set
# CONFIG_GPIO_TS5500 is not set
CONFIG_GPIO_SCH=m
CONFIG_GPIO_ICH=m
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_SX150X is not set
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
CONFIG_GPIO_BT8XX=m
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_LANGWELL is not set
# CONFIG_GPIO_PCH is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
# CONFIG_GPIO_MCP23S08 is not set

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#

#
# USB GPIO expanders:
#
CONFIG_W1=m
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
# CONFIG_W1_MASTER_DS2490 is not set
# CONFIG_W1_MASTER_DS2482 is not set
# CONFIG_W1_MASTER_DS1WM is not set
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=m
# CONFIG_W1_SLAVE_SMEM is not set
# CONFIG_W1_SLAVE_DS2408 is not set
# CONFIG_W1_SLAVE_DS2413 is not set
# CONFIG_W1_SLAVE_DS2423 is not set
# CONFIG_W1_SLAVE_DS2431 is not set
# CONFIG_W1_SLAVE_DS2433 is not set
# CONFIG_W1_SLAVE_DS2760 is not set
# CONFIG_W1_SLAVE_DS2780 is not set
# CONFIG_W1_SLAVE_DS2781 is not set
CONFIG_W1_SLAVE_DS28E04=m
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=m
# CONFIG_GENERIC_ADC_BATTERY is not set
CONFIG_TEST_POWER=m
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
CONFIG_BATTERY_SBS=m
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_ISP1704 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
CONFIG_CHARGER_GPIO=m
CONFIG_CHARGER_MANAGER=y
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_BATTERY_GOLDFISH is not set
CONFIG_POWER_RESET=y
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
# CONFIG_HWMON_VID is not set
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7410 is not set
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS620 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_GPIO_FAN=m
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_CORETEMP=m
# CONFIG_SENSORS_IBMAEM is not set
# CONFIG_SENSORS_IBMPEX is not set
CONFIG_SENSORS_IIO_HWMON=m
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_LINEAGE is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LTC4151 is not set
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LTC4261 is not set
# CONFIG_SENSORS_LM95234 is not set
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_LM95245 is not set
# CONFIG_SENSORS_MAX16065 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX1668 is not set
# CONFIG_SENSORS_MAX197 is not set
# CONFIG_SENSORS_MAX6639 is not set
# CONFIG_SENSORS_MAX6642 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_MAX6697 is not set
# CONFIG_SENSORS_MCP3021 is not set
# CONFIG_SENSORS_NCT6775 is not set
# CONFIG_SENSORS_NTC_THERMISTOR is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_PMBUS=m
CONFIG_SENSORS_PMBUS=m
# CONFIG_SENSORS_ADM1275 is not set
# CONFIG_SENSORS_LM25066 is not set
# CONFIG_SENSORS_LTC2978 is not set
# CONFIG_SENSORS_MAX16064 is not set
# CONFIG_SENSORS_MAX34440 is not set
# CONFIG_SENSORS_MAX8688 is not set
# CONFIG_SENSORS_UCD9000 is not set
# CONFIG_SENSORS_UCD9200 is not set
# CONFIG_SENSORS_ZL6100 is not set
# CONFIG_SENSORS_SHT15 is not set
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
# CONFIG_SENSORS_EMC2103 is not set
# CONFIG_SENSORS_EMC6W201 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_SCH5627 is not set
# CONFIG_SENSORS_SCH5636 is not set
# CONFIG_SENSORS_ADS1015 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_AMC6821 is not set
# CONFIG_SENSORS_INA209 is not set
# CONFIG_SENSORS_INA2XX is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83795 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_APPLESMC is not set

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=m
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_CPU_THERMAL is not set
CONFIG_THERMAL_EMULATION=y
CONFIG_INTEL_POWERCLAMP=m
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_F71808E_WDT is not set
# CONFIG_SP5100_TCO is not set
# CONFIG_SC520_WDT is not set
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=m
# CONFIG_IE6XX_WDT is not set
CONFIG_ITCO_WDT=m
CONFIG_ITCO_VENDOR_SUPPORT=y
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_NV_TCO is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC_SCH311X_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_VIA_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=m
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_AAT2870_CORE is not set
# CONFIG_MFD_CROS_EC is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_HTC_I2CPLD is not set
CONFIG_LPC_ICH=m
CONFIG_LPC_SCH=m
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_VIPERBOARD is not set
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_UCB1400_CORE is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_SI476X_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_SYSCON is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TPS65217 is not set
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
# CONFIG_MFD_TPS65912 is not set
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
# CONFIG_REGULATOR_DUMMY is not set
# CONFIG_REGULATOR_FIXED_VOLTAGE is not set
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
CONFIG_REGULATOR_USERSPACE_CONSUMER=m
CONFIG_REGULATOR_GPIO=m
# CONFIG_REGULATOR_AD5398 is not set
# CONFIG_REGULATOR_FAN53555 is not set
# CONFIG_REGULATOR_ISL6271A is not set
# CONFIG_REGULATOR_MAX1586 is not set
# CONFIG_REGULATOR_MAX8649 is not set
# CONFIG_REGULATOR_MAX8660 is not set
# CONFIG_REGULATOR_MAX8952 is not set
# CONFIG_REGULATOR_MAX8973 is not set
# CONFIG_REGULATOR_LP3971 is not set
# CONFIG_REGULATOR_LP3972 is not set
# CONFIG_REGULATOR_LP872X is not set
# CONFIG_REGULATOR_LP8755 is not set
# CONFIG_REGULATOR_TPS51632 is not set
# CONFIG_REGULATOR_TPS62360 is not set
# CONFIG_REGULATOR_TPS65023 is not set
# CONFIG_REGULATOR_TPS6507X is not set
CONFIG_MEDIA_SUPPORT=m

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
CONFIG_MEDIA_RADIO_SUPPORT=y
CONFIG_MEDIA_RC_SUPPORT=y
CONFIG_MEDIA_CONTROLLER=y
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2_SUBDEV_API=y
CONFIG_VIDEO_V4L2=m
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEOBUF2_CORE=m
CONFIG_VIDEOBUF2_MEMOPS=m
CONFIG_VIDEOBUF2_VMALLOC=m
# CONFIG_VIDEO_V4L2_INT_DEVICE is not set
CONFIG_DVB_CORE=m
CONFIG_DVB_NET=y
# CONFIG_TTPCI_EEPROM is not set
CONFIG_DVB_MAX_ADAPTERS=8
# CONFIG_DVB_DYNAMIC_MINORS is not set

#
# Media drivers
#
CONFIG_RC_CORE=m
CONFIG_RC_MAP=m
CONFIG_RC_DECODERS=y
CONFIG_LIRC=m
CONFIG_IR_LIRC_CODEC=m
CONFIG_IR_NEC_DECODER=m
CONFIG_IR_RC5_DECODER=m
CONFIG_IR_RC6_DECODER=m
CONFIG_IR_JVC_DECODER=m
CONFIG_IR_SONY_DECODER=m
CONFIG_IR_RC5_SZ_DECODER=m
CONFIG_IR_SANYO_DECODER=m
CONFIG_IR_MCE_KBD_DECODER=m
CONFIG_RC_DEVICES=y
# CONFIG_RC_ATI_REMOTE is not set
# CONFIG_IR_ENE is not set
# CONFIG_IR_IMON is not set
# CONFIG_IR_MCEUSB is not set
CONFIG_IR_ITE_CIR=m
# CONFIG_IR_FINTEK is not set
# CONFIG_IR_NUVOTON is not set
# CONFIG_IR_REDRAT3 is not set
# CONFIG_IR_STREAMZAP is not set
CONFIG_IR_WINBOND_CIR=m
# CONFIG_IR_IGUANA is not set
# CONFIG_IR_TTUSBIR is not set
CONFIG_RC_LOOPBACK=m
CONFIG_IR_GPIO_CIR=m
CONFIG_MEDIA_USB_SUPPORT=y

#
# Webcam devices
#
CONFIG_USB_VIDEO_CLASS=m
CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
CONFIG_USB_GSPCA=m
CONFIG_USB_M5602=m
CONFIG_USB_STV06XX=m
CONFIG_USB_GL860=m
# CONFIG_USB_GSPCA_BENQ is not set
CONFIG_USB_GSPCA_CONEX=m
# CONFIG_USB_GSPCA_CPIA1 is not set
CONFIG_USB_GSPCA_ETOMS=m
CONFIG_USB_GSPCA_FINEPIX=m
CONFIG_USB_GSPCA_JEILINJ=m
# CONFIG_USB_GSPCA_JL2005BCD is not set
CONFIG_USB_GSPCA_KINECT=m
# CONFIG_USB_GSPCA_KONICA is not set
CONFIG_USB_GSPCA_MARS=m
CONFIG_USB_GSPCA_MR97310A=m
# CONFIG_USB_GSPCA_NW80X is not set
CONFIG_USB_GSPCA_OV519=m
CONFIG_USB_GSPCA_OV534=m
# CONFIG_USB_GSPCA_OV534_9 is not set
CONFIG_USB_GSPCA_PAC207=m
CONFIG_USB_GSPCA_PAC7302=m
CONFIG_USB_GSPCA_PAC7311=m
# CONFIG_USB_GSPCA_SE401 is not set
# CONFIG_USB_GSPCA_SN9C2028 is not set
CONFIG_USB_GSPCA_SN9C20X=m
CONFIG_USB_GSPCA_SONIXB=m
CONFIG_USB_GSPCA_SONIXJ=m
CONFIG_USB_GSPCA_SPCA500=m
CONFIG_USB_GSPCA_SPCA501=m
CONFIG_USB_GSPCA_SPCA505=m
CONFIG_USB_GSPCA_SPCA506=m
CONFIG_USB_GSPCA_SPCA508=m
CONFIG_USB_GSPCA_SPCA561=m
# CONFIG_USB_GSPCA_SPCA1528 is not set
CONFIG_USB_GSPCA_SQ905=m
CONFIG_USB_GSPCA_SQ905C=m
# CONFIG_USB_GSPCA_SQ930X is not set
CONFIG_USB_GSPCA_STK014=m
CONFIG_USB_GSPCA_STV0680=m
CONFIG_USB_GSPCA_SUNPLUS=m
CONFIG_USB_GSPCA_T613=m
# CONFIG_USB_GSPCA_TOPRO is not set
CONFIG_USB_GSPCA_TV8532=m
CONFIG_USB_GSPCA_VC032X=m
# CONFIG_USB_GSPCA_VICAM is not set
# CONFIG_USB_GSPCA_XIRLINK_CIT is not set
CONFIG_USB_GSPCA_ZC3XX=m
CONFIG_USB_PWC=m
# CONFIG_USB_PWC_DEBUG is not set
CONFIG_USB_PWC_INPUT_EVDEV=y
# CONFIG_VIDEO_CPIA2 is not set
# CONFIG_USB_ZR364XX is not set
# CONFIG_USB_STKWEBCAM is not set
# CONFIG_USB_S2255 is not set
# CONFIG_USB_SN9C102 is not set

#
# Analog TV USB devices
#
# CONFIG_VIDEO_PVRUSB2 is not set
# CONFIG_VIDEO_HDPVR is not set
# CONFIG_VIDEO_TLG2300 is not set
# CONFIG_VIDEO_USBVISION is not set
# CONFIG_VIDEO_STK1160 is not set

#
# Analog/digital TV USB devices
#
# CONFIG_VIDEO_AU0828 is not set
# CONFIG_VIDEO_CX231XX is not set
# CONFIG_VIDEO_TM6000 is not set

#
# Digital TV USB devices
#
CONFIG_DVB_USB=m
CONFIG_DVB_USB_DEBUG=y
# CONFIG_DVB_USB_A800 is not set
CONFIG_DVB_USB_DIBUSB_MB=m
# CONFIG_DVB_USB_DIBUSB_MB_FAULTY is not set
CONFIG_DVB_USB_DIBUSB_MC=m
CONFIG_DVB_USB_DIB0700=m
# CONFIG_DVB_USB_UMT_010 is not set
# CONFIG_DVB_USB_CXUSB is not set
# CONFIG_DVB_USB_M920X is not set
# CONFIG_DVB_USB_DIGITV is not set
# CONFIG_DVB_USB_VP7045 is not set
# CONFIG_DVB_USB_VP702X is not set
# CONFIG_DVB_USB_GP8PSK is not set
# CONFIG_DVB_USB_NOVA_T_USB2 is not set
# CONFIG_DVB_USB_TTUSB2 is not set
CONFIG_DVB_USB_DTT200U=m
# CONFIG_DVB_USB_OPERA1 is not set
CONFIG_DVB_USB_AF9005=m
CONFIG_DVB_USB_AF9005_REMOTE=m
# CONFIG_DVB_USB_PCTV452E is not set
# CONFIG_DVB_USB_DW2102 is not set
CONFIG_DVB_USB_CINERGY_T2=m
# CONFIG_DVB_USB_DTV5100 is not set
# CONFIG_DVB_USB_FRIIO is not set
# CONFIG_DVB_USB_AZ6027 is not set
# CONFIG_DVB_USB_TECHNISAT_USB2 is not set
CONFIG_DVB_USB_V2=m
CONFIG_DVB_USB_AF9015=m
CONFIG_DVB_USB_AF9035=m
# CONFIG_DVB_USB_ANYSEE is not set
# CONFIG_DVB_USB_AU6610 is not set
# CONFIG_DVB_USB_AZ6007 is not set
# CONFIG_DVB_USB_CE6230 is not set
# CONFIG_DVB_USB_EC168 is not set
# CONFIG_DVB_USB_GL861 is not set
CONFIG_DVB_USB_IT913X=m
# CONFIG_DVB_USB_LME2510 is not set
# CONFIG_DVB_USB_MXL111SF is not set
CONFIG_DVB_USB_RTL28XXU=m
# CONFIG_DVB_TTUSB_BUDGET is not set
# CONFIG_DVB_TTUSB_DEC is not set
# CONFIG_SMS_USB_DRV is not set
# CONFIG_DVB_B2C2_FLEXCOP_USB is not set

#
# Webcam, TV (analog/digital) USB devices
#
# CONFIG_VIDEO_EM28XX is not set
CONFIG_MEDIA_PCI_SUPPORT=y

#
# Media capture support
#

#
# Media capture/analog TV support
#
# CONFIG_VIDEO_IVTV is not set
# CONFIG_VIDEO_ZORAN is not set
# CONFIG_VIDEO_HEXIUM_GEMINI is not set
# CONFIG_VIDEO_HEXIUM_ORION is not set
# CONFIG_VIDEO_MXB is not set

#
# Media capture/analog/hybrid TV support
#
# CONFIG_VIDEO_CX18 is not set
# CONFIG_VIDEO_CX23885 is not set
# CONFIG_VIDEO_CX25821 is not set
# CONFIG_VIDEO_CX88 is not set
# CONFIG_VIDEO_BT848 is not set
# CONFIG_VIDEO_SAA7134 is not set
# CONFIG_VIDEO_SAA7164 is not set

#
# Media digital TV PCI Adapters
#
# CONFIG_DVB_AV7110 is not set
# CONFIG_DVB_BUDGET_CORE is not set
# CONFIG_DVB_B2C2_FLEXCOP_PCI is not set
# CONFIG_DVB_PLUTO2 is not set
# CONFIG_DVB_DM1105 is not set
# CONFIG_DVB_PT1 is not set
# CONFIG_MANTIS_CORE is not set
# CONFIG_DVB_NGENE is not set
# CONFIG_DVB_DDBRIDGE is not set
# CONFIG_V4L_PLATFORM_DRIVERS is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
# CONFIG_V4L_TEST_DRIVERS is not set

#
# Supported MMC/SDIO adapters
#
# CONFIG_SMS_SDIO_DRV is not set
# CONFIG_MEDIA_PARPORT_SUPPORT is not set
# CONFIG_RADIO_ADAPTERS is not set

#
# Supported FireWire (IEEE 1394) Adapters
#
# CONFIG_DVB_FIREDTV is not set
CONFIG_CYPRESS_FIRMWARE=m

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y
CONFIG_MEDIA_ATTACH=y
CONFIG_VIDEO_IR_I2C=m

#
# Audio decoders, processors and mixers
#

#
# RDS decoders
#

#
# Video decoders
#

#
# Video and audio decoders
#

#
# Video encoders
#

#
# Camera sensor devices
#

#
# Flash devices
#

#
# Video improvement chips
#

#
# Miscelaneous helper chips
#

#
# Sensors used on soc_camera driver
#
CONFIG_MEDIA_TUNER=m
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_MT2060=m
CONFIG_MEDIA_TUNER_MT2266=m
CONFIG_MEDIA_TUNER_QT1010=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_XC4000=m
CONFIG_MEDIA_TUNER_MXL5005S=m
CONFIG_MEDIA_TUNER_MXL5007T=m
CONFIG_MEDIA_TUNER_MC44S803=m
CONFIG_MEDIA_TUNER_TDA18218=m
CONFIG_MEDIA_TUNER_FC0011=m
CONFIG_MEDIA_TUNER_FC0012=m
CONFIG_MEDIA_TUNER_FC0013=m
CONFIG_MEDIA_TUNER_E4000=m
CONFIG_MEDIA_TUNER_FC2580=m
CONFIG_MEDIA_TUNER_TUA9001=m
CONFIG_MEDIA_TUNER_IT913X=m
CONFIG_MEDIA_TUNER_R820T=m

#
# Multistandard (satellite) frontends
#

#
# Multistandard (cable + terrestrial) frontends
#

#
# DVB-S (satellite) frontends
#

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_DIB3000MB=m
CONFIG_DVB_DIB3000MC=m
CONFIG_DVB_DIB7000M=m
CONFIG_DVB_DIB7000P=m
CONFIG_DVB_AF9013=m
CONFIG_DVB_RTL2830=m
CONFIG_DVB_RTL2832=m

#
# DVB-C (cable) frontends
#

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_LGDT3305=m
CONFIG_DVB_S5H1411=m

#
# ISDB-T (terrestrial) frontends
#
CONFIG_DVB_DIB8000=m

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=m
CONFIG_DVB_TUNER_DIB0070=m
CONFIG_DVB_TUNER_DIB0090=m

#
# SEC control devices for DVB-S
#
CONFIG_DVB_IT913X_FE=m
CONFIG_DVB_AF9033=m

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_VIA is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
CONFIG_VGA_SWITCHEROO=y
CONFIG_DRM=y
CONFIG_DRM_USB=m
CONFIG_DRM_KMS_HELPER=y
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
CONFIG_DRM_TTM=m

#
# I2C encoder or helper chips
#
# CONFIG_DRM_I2C_CH7006 is not set
# CONFIG_DRM_I2C_SIL164 is not set
# CONFIG_DRM_I2C_NXP_TDA998X is not set
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
CONFIG_DRM_RADEON=m
# CONFIG_DRM_RADEON_UMS is not set
# CONFIG_DRM_NOUVEAU is not set
CONFIG_DRM_I915=y
CONFIG_DRM_I915_KMS=y
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
CONFIG_DRM_VMWGFX=m
# CONFIG_DRM_VMWGFX_FBCON is not set
# CONFIG_DRM_GMA500 is not set
CONFIG_DRM_UDL=m
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
CONFIG_DRM_CIRRUS_QEMU=m
CONFIG_DRM_QXL=m
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_HDMI=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=m
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
# CONFIG_FB_FOREIGN_ENDIAN is not set
# CONFIG_FB_SYS_FOPS is not set
CONFIG_FB_DEFERRED_IO=y
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
# CONFIG_FB_VESA is not set
# CONFIG_FB_EFI is not set
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
CONFIG_FB_RADEON=m
CONFIG_FB_RADEON_I2C=y
CONFIG_FB_RADEON_BACKLIGHT=y
# CONFIG_FB_RADEON_DEBUG is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_TMIO is not set
# CONFIG_FB_SMSCUFX is not set
# CONFIG_FB_UDL is not set
# CONFIG_FB_GOLDFISH is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
# CONFIG_FB_AUO_K190X is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
CONFIG_LCD_PLATFORM=m
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=m
CONFIG_BACKLIGHT_PWM=m
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_LM3630 is not set
# CONFIG_BACKLIGHT_LM3639 is not set
# CONFIG_BACKLIGHT_LP855X is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
CONFIG_LOGO_LINUX_VGA16=y
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
# CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
# CONFIG_SND_PCM_OSS is not set
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_HRTIMER=m
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
CONFIG_SND_DYNAMIC_MINORS=y
# CONFIG_SND_SUPPORT_OLD_API is not set
CONFIG_SND_VERBOSE_PROCFS=y
CONFIG_SND_VERBOSE_PRINTK=y
CONFIG_SND_DEBUG=y
# CONFIG_SND_DEBUG_VERBOSE is not set
# CONFIG_SND_PCM_XRUN_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_KCTL_JACK=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=m
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_MPU401_UART=m
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DRIVERS=y
# CONFIG_SND_PCSP is not set
# CONFIG_SND_DUMMY is not set
CONFIG_SND_ALOOP=m
CONFIG_SND_VIRMIDI=m
CONFIG_SND_MTPAV=m
# CONFIG_SND_MTS64 is not set
CONFIG_SND_SERIAL_U16550=m
CONFIG_SND_MPU401=m
# CONFIG_SND_PORTMAN2X4 is not set
# CONFIG_SND_AC97_POWER_SAVE is not set
CONFIG_SND_PCI=y
CONFIG_SND_AD1889=m
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ASIHPI is not set
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
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_CTXFI is not set
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
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDA_INTEL=m
CONFIG_SND_HDA_PREALLOC_SIZE=64
CONFIG_SND_HDA_HWDEP=y
CONFIG_SND_HDA_RECONFIG=y
CONFIG_SND_HDA_INPUT_BEEP=y
CONFIG_SND_HDA_INPUT_BEEP_MODE=1
CONFIG_SND_HDA_INPUT_JACK=y
CONFIG_SND_HDA_PATCH_LOADER=y
CONFIG_SND_HDA_CODEC_REALTEK=y
CONFIG_SND_HDA_CODEC_ANALOG=y
CONFIG_SND_HDA_CODEC_SIGMATEL=y
CONFIG_SND_HDA_CODEC_VIA=y
CONFIG_SND_HDA_CODEC_HDMI=y
CONFIG_SND_HDA_CODEC_CIRRUS=y
CONFIG_SND_HDA_CODEC_CONEXANT=y
CONFIG_SND_HDA_CODEC_CA0110=y
CONFIG_SND_HDA_CODEC_CA0132=y
# CONFIG_SND_HDA_CODEC_CA0132_DSP is not set
CONFIG_SND_HDA_CODEC_CMEDIA=y
CONFIG_SND_HDA_CODEC_SI3054=y
CONFIG_SND_HDA_GENERIC=y
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=10
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
CONFIG_SND_INTEL8X0=m
CONFIG_SND_INTEL8X0M=m
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_LOLA is not set
# CONFIG_SND_LX6464ES is not set
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
CONFIG_SND_USB=y
# CONFIG_SND_USB_AUDIO is not set
# CONFIG_SND_USB_UA101 is not set
# CONFIG_SND_USB_USX2Y is not set
# CONFIG_SND_USB_CAIAQ is not set
# CONFIG_SND_USB_US122L is not set
# CONFIG_SND_USB_6FIRE is not set
# CONFIG_SND_FIREWIRE is not set
CONFIG_SND_PCMCIA=y
# CONFIG_SND_VXPOCKET is not set
# CONFIG_SND_PDAUDIOCF is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=m

#
# HID support
#
CONFIG_HID=m
CONFIG_HIDRAW=y
CONFIG_UHID=m
CONFIG_HID_GENERIC=m

#
# Special HID drivers
#
CONFIG_HID_A4TECH=m
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=m
# CONFIG_HID_APPLEIR is not set
# CONFIG_HID_AUREAL is not set
CONFIG_HID_BELKIN=m
CONFIG_HID_CHERRY=m
CONFIG_HID_CHICONY=m
# CONFIG_HID_PRODIKEYS is not set
CONFIG_HID_CYPRESS=m
CONFIG_HID_DRAGONRISE=m
# CONFIG_DRAGONRISE_FF is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELECOM is not set
CONFIG_HID_EZKEY=m
# CONFIG_HID_HOLTEK is not set
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=m
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
CONFIG_HID_GYRATION=m
# CONFIG_HID_ICADE is not set
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=m
# CONFIG_HID_LCPOWER is not set
CONFIG_HID_LENOVO_TPKBD=m
CONFIG_HID_LOGITECH=m
CONFIG_HID_LOGITECH_DJ=m
CONFIG_LOGITECH_FF=y
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
CONFIG_LOGIWHEELS_FF=y
# CONFIG_HID_MAGICMOUSE is not set
CONFIG_HID_MICROSOFT=m
CONFIG_HID_MONTEREY=m
CONFIG_HID_MULTITOUCH=m
CONFIG_HID_NTRIG=m
CONFIG_HID_ORTEK=m
CONFIG_HID_PANTHERLORD=m
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=m
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
CONFIG_HID_PS3REMOTE=m
# CONFIG_HID_ROCCAT is not set
# CONFIG_HID_SAITEK is not set
CONFIG_HID_SAMSUNG=m
CONFIG_HID_SONY=m
# CONFIG_HID_SPEEDLINK is not set
# CONFIG_HID_STEELSERIES is not set
CONFIG_HID_SUNPLUS=m
CONFIG_HID_GREENASIA=m
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=m
CONFIG_SMARTJOYPLUS_FF=y
# CONFIG_HID_TIVO is not set
CONFIG_HID_TOPSEED=m
# CONFIG_HID_THINGM is not set
CONFIG_HID_THRUSTMASTER=m
CONFIG_THRUSTMASTER_FF=y
# CONFIG_HID_WACOM is not set
CONFIG_HID_WIIMOTE=m
CONFIG_HID_WIIMOTE_EXT=y
CONFIG_HID_ZEROPLUS=m
# CONFIG_ZEROPLUS_FF is not set
# CONFIG_HID_ZYDACRON is not set
CONFIG_HID_SENSOR_HUB=m

#
# USB HID support
#
CONFIG_USB_HID=m
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# I2C HID support
#
CONFIG_I2C_HID=m
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=m
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=m
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_OTG=y
CONFIG_USB_OTG_WHITELIST=y
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
CONFIG_USB_MON=m
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=m
# CONFIG_USB_XHCI_HCD_DEBUGGING is not set
CONFIG_USB_EHCI_HCD=m
CONFIG_USB_EHCI_ROOT_HUB_TT=y
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
CONFIG_USB_EHCI_PCI=m
CONFIG_USB_EHCI_HCD_PLATFORM=m
# CONFIG_USB_OXU210HP_HCD is not set
CONFIG_USB_ISP116X_HCD=m
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
CONFIG_USB_OHCI_HCD=m
CONFIG_USB_OHCI_HCD_PLATFORM=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=m
CONFIG_USB_SL811_HCD=m
# CONFIG_USB_SL811_HCD_ISO is not set
CONFIG_USB_SL811_CS=m
# CONFIG_USB_R8A66597_HCD is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m
CONFIG_USB_WDM=m
CONFIG_USB_TMC=m

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_REALTEK is not set
CONFIG_USB_STORAGE_DATAFAB=m
CONFIG_USB_STORAGE_FREECOM=m
CONFIG_USB_STORAGE_ISD200=m
CONFIG_USB_STORAGE_USBAT=m
CONFIG_USB_STORAGE_SDDR09=m
CONFIG_USB_STORAGE_SDDR55=m
CONFIG_USB_STORAGE_JUMPSHOT=m
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_STORAGE_ENE_UB6250 is not set

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
CONFIG_USB_MICROTEK=m
# CONFIG_USB_DWC3 is not set
# CONFIG_USB_CHIPIDEA is not set

#
# USB port drivers
#
# CONFIG_USB_USS720 is not set
CONFIG_USB_SERIAL=m
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_AIRCABLE is not set
# CONFIG_USB_SERIAL_ARK3116 is not set
# CONFIG_USB_SERIAL_BELKIN is not set
# CONFIG_USB_SERIAL_CH341 is not set
# CONFIG_USB_SERIAL_WHITEHEAT is not set
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
CONFIG_USB_SERIAL_CP210X=m
CONFIG_USB_SERIAL_CYPRESS_M8=m
# CONFIG_USB_SERIAL_EMPEG is not set
CONFIG_USB_SERIAL_FTDI_SIO=m
# CONFIG_USB_SERIAL_FUNSOFT is not set
# CONFIG_USB_SERIAL_VISOR is not set
# CONFIG_USB_SERIAL_IPAQ is not set
# CONFIG_USB_SERIAL_IR is not set
# CONFIG_USB_SERIAL_EDGEPORT is not set
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_F81232 is not set
# CONFIG_USB_SERIAL_GARMIN is not set
CONFIG_USB_SERIAL_IPW=m
# CONFIG_USB_SERIAL_IUU is not set
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
# CONFIG_USB_SERIAL_KEYSPAN is not set
# CONFIG_USB_SERIAL_KLSI is not set
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
# CONFIG_USB_SERIAL_MCT_U232 is not set
# CONFIG_USB_SERIAL_METRO is not set
# CONFIG_USB_SERIAL_MOS7720 is not set
# CONFIG_USB_SERIAL_MOS7840 is not set
CONFIG_USB_SERIAL_MOTOROLA=m
# CONFIG_USB_SERIAL_NAVMAN is not set
CONFIG_USB_SERIAL_PL2303=m
# CONFIG_USB_SERIAL_OTI6858 is not set
# CONFIG_USB_SERIAL_QCAUX is not set
CONFIG_USB_SERIAL_QUALCOMM=m
# CONFIG_USB_SERIAL_SPCP8X5 is not set
# CONFIG_USB_SERIAL_HP4X is not set
# CONFIG_USB_SERIAL_SAFE is not set
# CONFIG_USB_SERIAL_SIEMENS_MPI is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
# CONFIG_USB_SERIAL_SYMBOL is not set
# CONFIG_USB_SERIAL_TI is not set
# CONFIG_USB_SERIAL_CYBERJACK is not set
# CONFIG_USB_SERIAL_XIRCOM is not set
CONFIG_USB_SERIAL_WWAN=m
CONFIG_USB_SERIAL_OPTION=m
# CONFIG_USB_SERIAL_OMNINET is not set
# CONFIG_USB_SERIAL_OPTICON is not set
# CONFIG_USB_SERIAL_VIVOPAY_SERIAL is not set
# CONFIG_USB_SERIAL_XSENS_MT is not set
# CONFIG_USB_SERIAL_ZIO is not set
# CONFIG_USB_SERIAL_WISHBONE is not set
CONFIG_USB_SERIAL_ZTE=m
# CONFIG_USB_SERIAL_SSU100 is not set
# CONFIG_USB_SERIAL_QT2 is not set
# CONFIG_USB_SERIAL_DEBUG is not set

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
CONFIG_USB_LED=m
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set
CONFIG_USB_EZUSB_FX2=m
# CONFIG_USB_HSIC_USB3503 is not set
CONFIG_USB_PHY=y
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_OMAP_CONTROL_USB is not set
# CONFIG_OMAP_USB3 is not set
# CONFIG_SAMSUNG_USBPHY is not set
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
CONFIG_USB_GPIO_VBUS=m
# CONFIG_USB_ISP1301 is not set
# CONFIG_USB_RCAR_PHY is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
CONFIG_MMC=m
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set
# CONFIG_MMC_CLKGATE is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_MMC_BLOCK_BOUNCE=y
CONFIG_SDIO_UART=m
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_PCI=m
CONFIG_MMC_RICOH_MMC=y
CONFIG_MMC_SDHCI_ACPI=m
CONFIG_MMC_SDHCI_PLTFM=m
# CONFIG_MMC_SDHCI_PXAV3 is not set
# CONFIG_MMC_SDHCI_PXAV2 is not set
CONFIG_MMC_WBSD=m
# CONFIG_MMC_TIFM_SD is not set
CONFIG_MMC_SDRICOH_CS=m
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
# CONFIG_MMC_VUB300 is not set
CONFIG_MMC_USHC=m
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_LM3530 is not set
# CONFIG_LEDS_LM3642 is not set
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_GPIO=m
# CONFIG_LEDS_LP3944 is not set
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_LP5562 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA9633 is not set
CONFIG_LEDS_PWM=m
CONFIG_LEDS_REGULATOR=m
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_INTEL_SS4200 is not set
# CONFIG_LEDS_LT3593 is not set
# CONFIG_LEDS_DELL_NETBOOKS is not set
# CONFIG_LEDS_RENESAS_TPU is not set
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_LM355x is not set
# CONFIG_LEDS_OT200 is not set
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_ONESHOT=m
CONFIG_LEDS_TRIGGER_IDE_DISK=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
CONFIG_LEDS_TRIGGER_CPU=y
# CONFIG_LEDS_TRIGGER_GPIO is not set
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=m
CONFIG_LEDS_TRIGGER_CAMERA=m
CONFIG_ACCESSIBILITY=y
# CONFIG_A11Y_BRAILLE_CONSOLE is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_SYSTOHC=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_DS3232 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_ISL12022 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF8523 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_BQ32K is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set
# CONFIG_RTC_DRV_EM3027 is not set
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_MSM6242 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_RP5C01 is not set
# CONFIG_RTC_DRV_V3020 is not set
# CONFIG_RTC_DRV_DS2404 is not set

#
# on-CPU RTC drivers
#

#
# HID Sensor RTC drivers
#
CONFIG_RTC_DRV_HID_SENSOR_TIME=m
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_INTEL_MID_DMAC=m
CONFIG_INTEL_IOATDMA=m
# CONFIG_DW_DMAC is not set
CONFIG_TIMB_DMA=m
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
CONFIG_ASYNC_TX_DMA=y
# CONFIG_DMATEST is not set
CONFIG_DCA=m
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=m
# CONFIG_UIO_CIF is not set
CONFIG_UIO_PDRV=m
# CONFIG_UIO_PDRV_GENIRQ is not set
CONFIG_UIO_DMEM_GENIRQ=m
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
CONFIG_UIO_PCI_GENERIC=m
# CONFIG_UIO_NETX is not set
CONFIG_VFIO_IOMMU_TYPE1=m
CONFIG_VFIO=m
CONFIG_VFIO_PCI=m
CONFIG_VFIO_PCI_VGA=y
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO=m

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=m
CONFIG_VIRTIO_BALLOON=m
CONFIG_VIRTIO_MMIO=m
CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y

#
# Microsoft Hyper-V guest support
#
CONFIG_STAGING=y
# CONFIG_ET131X is not set
# CONFIG_SLICOSS is not set
CONFIG_USBIP_CORE=m
CONFIG_USBIP_VHCI_HCD=m
CONFIG_USBIP_HOST=m
# CONFIG_USBIP_DEBUG is not set
# CONFIG_W35UND is not set
# CONFIG_PRISM2_USB is not set
# CONFIG_ECHO is not set
# CONFIG_COMEDI is not set
# CONFIG_ASUS_OLED is not set
CONFIG_PANEL=m
CONFIG_PANEL_PARPORT=0
CONFIG_PANEL_PROFILE=5
# CONFIG_PANEL_CHANGE_MESSAGE is not set
# CONFIG_R8187SE is not set
# CONFIG_RTL8192U is not set
# CONFIG_RTLLIB is not set
# CONFIG_R8712U is not set
# CONFIG_RTS5139 is not set
# CONFIG_TRANZPORT is not set
# CONFIG_IDE_PHISON is not set
# CONFIG_LINE6_USB is not set
# CONFIG_USB_SERIAL_QUATECH2 is not set
# CONFIG_VT6655 is not set
# CONFIG_VT6656 is not set
# CONFIG_DX_SEP is not set

#
# IIO staging drivers
#

#
# Accelerometers
#

#
# Analog to digital converters
#
# CONFIG_AD7291 is not set
# CONFIG_AD7606 is not set
# CONFIG_AD799X is not set

#
# Analog digital bi-direction converters
#
# CONFIG_ADT7316 is not set

#
# Capacitance to digital converters
#
# CONFIG_AD7150 is not set
# CONFIG_AD7152 is not set
# CONFIG_AD7746 is not set

#
# Direct Digital Synthesis
#

#
# Digital gyroscope sensors
#

#
# Network Analyzer, Impedance Converters
#
# CONFIG_AD5933 is not set

#
# Light sensors
#
# CONFIG_SENSORS_ISL29018 is not set
# CONFIG_SENSORS_ISL29028 is not set
# CONFIG_TSL2583 is not set
# CONFIG_TSL2x7x is not set

#
# Magnetometer sensors
#
# CONFIG_SENSORS_HMC5843 is not set

#
# Active energy metering IC
#
# CONFIG_ADE7854 is not set

#
# Resolver to digital converters
#

#
# Triggers - standalone
#
# CONFIG_IIO_PERIODIC_RTC_TRIGGER is not set
# CONFIG_IIO_GPIO_TRIGGER is not set
# CONFIG_IIO_SYSFS_TRIGGER is not set
# CONFIG_IIO_SIMPLE_DUMMY is not set
CONFIG_ZSMALLOC=y
CONFIG_ZRAM=m
# CONFIG_ZRAM_DEBUG is not set
# CONFIG_WLAGS49_H2 is not set
# CONFIG_WLAGS49_H25 is not set
# CONFIG_FB_SM7XX is not set
CONFIG_CRYSTALHD=m
# CONFIG_FB_XGI is not set
CONFIG_ACPI_QUICKSTART=m
# CONFIG_USB_ENESTORAGE is not set
# CONFIG_BCM_WIMAX is not set
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
# CONFIG_SPEAKUP is not set
# CONFIG_TOUCHSCREEN_CLEARPAD_TM1217 is not set
# CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
CONFIG_STAGING_MEDIA=y
# CONFIG_DVB_AS102 is not set
# CONFIG_DVB_CXD2099 is not set
# CONFIG_VIDEO_DT3155 is not set
# CONFIG_VIDEO_GO7007 is not set
# CONFIG_LIRC_STAGING is not set

#
# Android
#
# CONFIG_ANDROID is not set
CONFIG_USB_WPAN_HCD=m
# CONFIG_WIMAX_GDM72XX is not set
CONFIG_CSR_WIFI=m
CONFIG_NET_VENDOR_SILICOM=y
# CONFIG_SBYPASS is not set
# CONFIG_BPCTL is not set
# CONFIG_CED1401 is not set
# CONFIG_DGRP is not set
CONFIG_FIREWIRE_SERIAL=m
CONFIG_ZCACHE=y
CONFIG_ZCACHE_DEBUG=y
# CONFIG_USB_DWC2 is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_CHROMEOS_LAPTOP is not set
# CONFIG_DELL_LAPTOP is not set
# CONFIG_DELL_WMI is not set
# CONFIG_DELL_WMI_AIO is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_AMILO_RFKILL is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WMI is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
CONFIG_IDEAPAD_LAPTOP=m
CONFIG_THINKPAD_ACPI=m
CONFIG_THINKPAD_ACPI_ALSA_SUPPORT=y
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
# CONFIG_THINKPAD_ACPI_DEBUG is not set
# CONFIG_THINKPAD_ACPI_UNSAFE_LEDS is not set
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
CONFIG_SENSORS_HDAPS=m
CONFIG_INTEL_MENLOW=m
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ASUS_WMI is not set
CONFIG_ACPI_WMI=m
# CONFIG_MSI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
CONFIG_ACPI_CMPC=m
CONFIG_INTEL_IPS=m
CONFIG_IBM_RTL=m
# CONFIG_XO15_EBOOK is not set
# CONFIG_SAMSUNG_LAPTOP is not set
CONFIG_MXM_WMI=m
# CONFIG_INTEL_OAKTRAIL is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
CONFIG_PVPANIC=m
CONFIG_CLKDEV_LOOKUP=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y

#
# Common Clock Framework
#
# CONFIG_COMMON_CLK_DEBUG is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
CONFIG_MAILBOX=y
CONFIG_IOMMU_API=y
CONFIG_IOMMU_SUPPORT=y
# CONFIG_AMD_IOMMU is not set
CONFIG_DMAR_TABLE=y
CONFIG_INTEL_IOMMU=y
CONFIG_INTEL_IOMMU_DEFAULT_ON=y
CONFIG_INTEL_IOMMU_FLOPPY_WA=y
CONFIG_IRQ_REMAP=y

#
# Remoteproc drivers
#
# CONFIG_STE_MODEM_RPROC is not set

#
# Rpmsg drivers
#
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
CONFIG_DEVFREQ_GOV_PERFORMANCE=y
CONFIG_DEVFREQ_GOV_POWERSAVE=y
CONFIG_DEVFREQ_GOV_USERSPACE=y

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_GPIO=m
# CONFIG_EXTCON_ADC_JACK is not set
CONFIG_MEMORY=y
CONFIG_IIO=m
CONFIG_IIO_BUFFER=y
# CONFIG_IIO_BUFFER_CB is not set
CONFIG_IIO_KFIFO_BUF=m
CONFIG_IIO_TRIGGERED_BUFFER=m
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Accelerometers
#
CONFIG_HID_SENSOR_ACCEL_3D=m
# CONFIG_IIO_ST_ACCEL_3AXIS is not set

#
# Analog to digital converters
#
# CONFIG_MAX1363 is not set
# CONFIG_TI_ADC081C is not set

#
# Amplifiers
#

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=m
CONFIG_HID_SENSOR_IIO_TRIGGER=m
CONFIG_HID_SENSOR_ENUM_BASE_QUIRKS=y

#
# Digital to analog converters
#
# CONFIG_AD5064 is not set
# CONFIG_AD5380 is not set
# CONFIG_AD5446 is not set
# CONFIG_MAX517 is not set
# CONFIG_MCP4725 is not set

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#

#
# Phase-Locked Loop (PLL) frequency synthesizers
#

#
# Digital gyroscope sensors
#
# CONFIG_HID_SENSOR_GYRO_3D is not set
# CONFIG_IIO_ST_GYRO_3AXIS is not set
# CONFIG_ITG3200 is not set

#
# Inertial measurement units
#
# CONFIG_INV_MPU6050_IIO is not set

#
# Light sensors
#
# CONFIG_ADJD_S311 is not set
# CONFIG_SENSORS_TSL2563 is not set
# CONFIG_VCNL4000 is not set
# CONFIG_HID_SENSOR_ALS is not set

#
# Magnetometer sensors
#
# CONFIG_AK8975 is not set
# CONFIG_HID_SENSOR_MAGNETOMETER_3D is not set
# CONFIG_IIO_ST_MAGN_3AXIS is not set
CONFIG_NTB=m
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
# CONFIG_IPACK_BUS is not set
CONFIG_RESET_CONTROLLER=y

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=m
CONFIG_DCDBAS=m
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=m
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_ISCSI_IBFT=m
# CONFIG_GOOGLE_FIRMWARE is not set

#
# EFI (Extensible Firmware Interface) Support
#
# CONFIG_EFI_VARS is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=m
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=m
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=m
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_FS_XIP=y
CONFIG_JBD=m
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=m
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=m
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=m
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
# CONFIG_XFS_RT is not set
CONFIG_XFS_WARN=y
# CONFIG_XFS_DEBUG is not set
CONFIG_GFS2_FS=m
CONFIG_GFS2_FS_LOCKING_DLM=y
CONFIG_OCFS2_FS=m
CONFIG_OCFS2_FS_O2CB=m
CONFIG_OCFS2_FS_USERSPACE_CLUSTER=m
CONFIG_OCFS2_FS_STATS=y
CONFIG_OCFS2_DEBUG_MASKLOG=y
# CONFIG_OCFS2_DEBUG_FS is not set
CONFIG_BTRFS_FS=m
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
# CONFIG_FANOTIFY_ACCESS_PERMISSIONS is not set
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=m
CONFIG_QFMT_V1=m
CONFIG_QFMT_V2=m
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=m
CONFIG_CUSE=m
CONFIG_GENERIC_ACL=y

#
# Caches
#
CONFIG_FSCACHE=m
CONFIG_FSCACHE_STATS=y
CONFIG_FSCACHE_HISTOGRAM=y
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set
CONFIG_CACHEFILES=m
# CONFIG_CACHEFILES_DEBUG is not set
CONFIG_CACHEFILES_HISTOGRAM=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=m
# CONFIG_NTFS_DEBUG is not set
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=m
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
CONFIG_AFFS_FS=m
CONFIG_ECRYPT_FS=m
CONFIG_ECRYPT_FS_MESSAGING=y
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
CONFIG_LOGFS=m
CONFIG_CRAMFS=m
CONFIG_SQUASHFS=m
CONFIG_SQUASHFS_XATTR=y
CONFIG_SQUASHFS_ZLIB=y
CONFIG_SQUASHFS_LZO=y
CONFIG_SQUASHFS_XZ=y
# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
CONFIG_SQUASHFS_EMBEDDED=y
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_VXFS_FS=m
CONFIG_MINIX_FS=m
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_QNX6FS_FS is not set
CONFIG_ROMFS_FS=y
CONFIG_ROMFS_BACKED_BY_BLOCK=y
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_PSTORE=y
CONFIG_PSTORE_CONSOLE=y
CONFIG_PSTORE_RAM=m
CONFIG_SYSV_FS=m
CONFIG_UFS_FS=m
# CONFIG_UFS_FS_WRITE is not set
# CONFIG_UFS_DEBUG is not set
# CONFIG_EXOFS_FS is not set
CONFIG_F2FS_FS=m
CONFIG_F2FS_STAT_FS=y
CONFIG_F2FS_FS_XATTR=y
CONFIG_F2FS_FS_POSIX_ACL=y
CONFIG_EFIVAR_FS=m
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=m
CONFIG_NFS_V2=m
CONFIG_NFS_V3=m
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=m
CONFIG_NFS_SWAP=y
# CONFIG_NFS_V4_1 is not set
CONFIG_NFS_FSCACHE=y
CONFIG_NFS_USE_LEGACY_DNS=y
CONFIG_NFSD=m
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
# CONFIG_NFSD_FAULT_INJECTION is not set
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
CONFIG_SUNRPC_GSS=m
CONFIG_SUNRPC_SWAP=y
CONFIG_RPCSEC_GSS_KRB5=m
# CONFIG_SUNRPC_DEBUG is not set
CONFIG_CEPH_FS=m
CONFIG_CIFS=m
# CONFIG_CIFS_STATS is not set
# CONFIG_CIFS_WEAK_PW_HASH is not set
# CONFIG_CIFS_UPCALL is not set
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_ACL is not set
CONFIG_CIFS_DEBUG=y
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_DFS_UPCALL is not set
CONFIG_CIFS_SMB2=y
CONFIG_CIFS_FSCACHE=y
CONFIG_NCP_FS=m
CONFIG_NCPFS_PACKET_SIGNING=y
CONFIG_NCPFS_IOCTL_LOCKING=y
CONFIG_NCPFS_STRONG=y
CONFIG_NCPFS_NFS_NS=y
CONFIG_NCPFS_OS2_NS=y
CONFIG_NCPFS_SMALLDOS=y
CONFIG_NCPFS_NLS=y
CONFIG_NCPFS_EXTRAS=y
CONFIG_CODA_FS=m
# CONFIG_AFS_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=m
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_MAC_ROMAN=m
CONFIG_NLS_MAC_CELTIC=m
CONFIG_NLS_MAC_CENTEURO=m
CONFIG_NLS_MAC_CROATIAN=m
CONFIG_NLS_MAC_CYRILLIC=m
CONFIG_NLS_MAC_GAELIC=m
CONFIG_NLS_MAC_GREEK=m
CONFIG_NLS_MAC_ICELAND=m
CONFIG_NLS_MAC_INUIT=m
CONFIG_NLS_MAC_ROMANIAN=m
CONFIG_NLS_MAC_TURKISH=m
CONFIG_NLS_UTF8=m
CONFIG_DLM=m
# CONFIG_DLM_DEBUG is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_PREEMPT is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_ATOMIC_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set

#
# RCU Debugging
#
# CONFIG_PROVE_RCU_DELAY is not set
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=60
CONFIG_RCU_CPU_STALL_VERBOSE=y
# CONFIG_RCU_CPU_STALL_INFO is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_LKDTM is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
# CONFIG_FUNCTION_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_PREEMPT_TRACER is not set
# CONFIG_SCHED_TRACER is not set
# CONFIG_FTRACE_SYSCALLS is not set
# CONFIG_TRACER_SNAPSHOT is not set
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_STACK_TRACER is not set
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_FIREWIRE_OHCI_REMOTE_DMA is not set
CONFIG_DYNAMIC_DEBUG=y
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_ATOMIC64_SELFTEST is not set
CONFIG_ASYNC_RAID6_TEST=m
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_TEST_STRING_HELPERS is not set
# CONFIG_TEST_KSTRTOX is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
CONFIG_DEBUG_SET_MODULE_RONX=y
# CONFIG_DEBUG_NX_TEST is not set
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_DEBUG is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
CONFIG_DEBUG_NMI_SELFTEST=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_TRUSTED_KEYS=m
CONFIG_ENCRYPTED_KEYS=m
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
CONFIG_INTEL_TXT=y
# CONFIG_SECURITY_SELINUX is not set
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
CONFIG_SECURITY_YAMA=y
CONFIG_SECURITY_YAMA_STACKED=y
# CONFIG_IMA is not set
# CONFIG_DEFAULT_SECURITY_YAMA is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_ASYNC_PQ=m
CONFIG_ASYNC_RAID6_RECOV=m
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=m
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=m
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=m
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=m
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=m
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_PCRYPT=m
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=m
CONFIG_CRYPTO_AUTHENC=m
# CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_ABLK_HELPER_X86=m
CONFIG_CRYPTO_GLUE_HELPER_X86=m

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=m
CONFIG_CRYPTO_CTR=m
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=m
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_CRC32=m
CONFIG_CRYPTO_CRC32_PCLMUL=m
CONFIG_CRYPTO_GHASH=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=m
CONFIG_CRYPTO_SHA256_SSSE3=m
CONFIG_CRYPTO_SHA512_SSSE3=m
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_WP512=m
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=m
CONFIG_CRYPTO_AES_NI_INTEL=m
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_BLOWFISH_X86_64=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAMELLIA_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=m
CONFIG_CRYPTO_CAST_COMMON=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST5_AVX_X86_64=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_CAST6_AVX_X86_64=m
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=m
CONFIG_CRYPTO_SALSA20_X86_64=m
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=m
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_X86_64=m
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=m
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_ZLIB=m
CONFIG_CRYPTO_LZO=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
CONFIG_CRYPTO_USER_API=m
CONFIG_CRYPTO_USER_API_HASH=m
CONFIG_CRYPTO_USER_API_SKCIPHER=m
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
CONFIG_KVM_AMD=m
# CONFIG_KVM_MMU_AUDIT is not set
CONFIG_KVM_DEVICE_ASSIGNMENT=y
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=m
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_PERCPU_RWSEM=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=m
CONFIG_CRC_T10DIF=m
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=m
CONFIG_LIBCRC32C=m
CONFIG_CRC8=m
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_BTREE=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_LRU_CACHE=m
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=m
CONFIG_DDR=y
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y
CONFIG_UCS2_STRING=y

-- 
Arkadiusz Miśkiewicz, arekm / maven.pl
