Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:43723 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750979AbeEVErQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 May 2018 00:47:16 -0400
Received: by mail-pg0-f67.google.com with SMTP id p8-v6so7291637pgq.10
        for <linux-wireless@vger.kernel.org>; Mon, 21 May 2018 21:47:15 -0700 (PDT)
Date: Mon, 21 May 2018 21:47:12 -0700
From: Eric Biggers <ebiggers3@gmail.com>
To: "Dreyfuss, Haim" <haim.dreyfuss@intel.com>
Cc: linuxwifi <linuxwifi@intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Coelho, Luciano" <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [4.17 iwlwifi regression] NULL pointer dereference in
 reg_query_regdb_wmm()
Message-ID: <20180522044712.GA987@sol.localdomain> (sfid-20180522_064723_805111_474BFA8C)
References: <20180519183345.GA701@sol.localdomain>
 <409B2791E285FD41B488E034D9B4719F27E99C58@HASMSX106.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="liOOAslEiF7prFVr"
In-Reply-To: <409B2791E285FD41B488E034D9B4719F27E99C58@HASMSX106.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Haim,

On Mon, May 21, 2018 at 10:10:09AM +0000, Dreyfuss, Haim wrote:
> Hello,
> 
> Can you provide the following information?
> 1. The *boot* you mentioned is from clean shutdown or from Sx state?
> 2. Do you know which MCC the driver is trying to update?
> I will appreciate if you could reproduce it with trace-cmd  (recording at least iwlwifi , iwlwifi_msg -and iwlwifi_ucode)
> Or if you can't,  just send dmesg  but make sure to set iwlwifi.debug in the kernel parameters to 0x4000
> 

It's a clean boot, from powered off.

I built an v4.17-rc6 kernel with CONFIG_IWLWIFI_DEBUG=y and booted with
iwlwifi.debug=0x4000.  I've attached the dmesg output and kernel config.

The crash happens right away, so there's no time to easily run trace-cmd.
But if the other stuff still isn't enough, I can try booting with the
NetworkManager service disabled, then enabling it at runtime.

- Eric

--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg

[    0.000000] Linux version 4.17.0-rc6 (e@zzz) (gcc version 8.1.0 (GCC)) #8 SMP PREEMPT Mon May 21 21:23:04 PDT 2018
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-4.17.0-rc6 root=UUID=a46f8764-1525-43b5-871b-e4e5b4ad1e4a rw rootflags=subvol=root cryptdevice=/dev/disk/by-uuid/959cda6d-3f53-43ad-9cb5-a360b3176eeb:crypt-main:allow-discards iwlwifi.debug=0x4000 quiet
[    0.000000] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x008: 'MPX bounds registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x010: 'MPX CSR'
[    0.000000] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
[    0.000000] x86/fpu: xstate_offset[3]:  832, xstate_sizes[3]:   64
[    0.000000] x86/fpu: xstate_offset[4]:  896, xstate_sizes[4]:   64
[    0.000000] x86/fpu: Enabled xstate features 0x1f, context size is 960 bytes, using 'compacted' format.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000057fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000058000-0x0000000000058fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000059000-0x000000000009cfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009d000-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007a41dfff] usable
[    0.000000] BIOS-e820: [mem 0x000000007a41e000-0x000000007a41efff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000007a41f000-0x000000007a448fff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007a449000-0x000000007a4a1fff] usable
[    0.000000] BIOS-e820: [mem 0x000000007a4a2000-0x000000007ac22fff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007ac23000-0x0000000086c39fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000086c3a000-0x0000000086ca4fff] type 20
[    0.000000] BIOS-e820: [mem 0x0000000086ca5000-0x0000000087650fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000087651000-0x0000000087f98fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000087f99000-0x0000000087ffdfff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000087ffe000-0x0000000087ffefff] usable
[    0.000000] BIOS-e820: [mem 0x0000000088000000-0x00000000880fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fe000000-0x00000000fe010fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x00000002727fffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] efi: EFI v2.40 by American Megatrends
[    0.000000] efi:  ACPI=0x87fd5000  ACPI 2.0=0x87fd5000  SMBIOS=0xf0000 
[    0.000000] SMBIOS 2.8 present.
[    0.000000] DMI: Dell Inc. Inspiron 15-7568/0M5YMV, BIOS 01.00.00 08/07/2015
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x272800 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00C0000000 mask 7FC0000000 uncachable
[    0.000000]   1 base 00A0000000 mask 7FE0000000 uncachable
[    0.000000]   2 base 0090000000 mask 7FF0000000 uncachable
[    0.000000]   3 base 008C000000 mask 7FFC000000 uncachable
[    0.000000]   4 base 008A000000 mask 7FFE000000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC- WT  
[    0.000000] e820: last_pfn = 0x87fff max_arch_pfn = 0x400000000
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [        (ptrval)] 97000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] BRK [0x107b74000, 0x107b74fff] PGTABLE
[    0.000000] BRK [0x107b75000, 0x107b75fff] PGTABLE
[    0.000000] BRK [0x107b76000, 0x107b76fff] PGTABLE
[    0.000000] BRK [0x107b77000, 0x107b77fff] PGTABLE
[    0.000000] BRK [0x107b78000, 0x107b78fff] PGTABLE
[    0.000000] BRK [0x107b79000, 0x107b79fff] PGTABLE
[    0.000000] BRK [0x107b7a000, 0x107b7afff] PGTABLE
[    0.000000] BRK [0x107b7b000, 0x107b7bfff] PGTABLE
[    0.000000] BRK [0x107b7c000, 0x107b7cfff] PGTABLE
[    0.000000] BRK [0x107b7d000, 0x107b7dfff] PGTABLE
[    0.000000] BRK [0x107b7e000, 0x107b7efff] PGTABLE
[    0.000000] Secure boot could not be determined
[    0.000000] RAMDISK: [mem 0x37437000-0x37a12fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x0000000087FD5000 000024 (v02 DELL  )
[    0.000000] ACPI: XSDT 0x0000000087FD50B0 0000E4 (v01 DELL   CBX3     01072009 AMI  00010013)
[    0.000000] ACPI: FACP 0x0000000087FF3320 00010C (v05 DELL   CBX3     01072009 AMI  00010013)
[    0.000000] ACPI: DSDT 0x0000000087FD5228 01E0F7 (v02 DELL   CBX3     01072009 INTL 20120913)
[    0.000000] ACPI: FACS 0x0000000087F97F80 000040
[    0.000000] ACPI: APIC 0x0000000087FF3430 000084 (v03 DELL   CBX3     01072009 AMI  00010013)
[    0.000000] ACPI: FPDT 0x0000000087FF34B8 000044 (v01 DELL   CBX3     01072009 AMI  00010013)
[    0.000000] ACPI: FIDT 0x0000000087FF3500 00009C (v01 DELL   CBX3     01072009 AMI  00010013)
[    0.000000] ACPI: MCFG 0x0000000087FF35A0 00003C (v01 DELL   CBX3     01072009 MSFT 00000097)
[    0.000000] ACPI: HPET 0x0000000087FF35E0 000038 (v01 DELL   CBX3     01072009 AMI. 0005000B)
[    0.000000] ACPI: SSDT 0x0000000087FF3618 0003DA (v01 SataRe SataTabl 00001000 INTL 20120913)
[    0.000000] ACPI: LPIT 0x0000000087FF39F8 000094 (v01 INTEL  SKL-ULT  00000000 MSFT 0000005F)
[    0.000000] ACPI: SSDT 0x0000000087FF3A90 000248 (v02 INTEL  sensrhub 00000000 INTL 20120913)
[    0.000000] ACPI: SSDT 0x0000000087FF3CD8 000E9E (v02 INTEL  PtidDevc 00001000 INTL 20120913)
[    0.000000] ACPI: SSDT 0x0000000087FF4B78 000551 (v02 INTEL  Ther_Rvp 00001000 INTL 20120913)
[    0.000000] ACPI: DBGP 0x0000000087FF50D0 000034 (v01 INTEL           00000000 MSFT 0000005F)
[    0.000000] ACPI: DBG2 0x0000000087FF5108 000054 (v00 INTEL           00000000 MSFT 0000005F)
[    0.000000] ACPI: SSDT 0x0000000087FF5160 000770 (v02 INTEL  xh_rvp07 00000000 INTL 20120913)
[    0.000000] ACPI: BOOT 0x0000000087FF58D0 000028 (v01 DELL   CBX3     01072009 AMI  00010013)
[    0.000000] ACPI: SSDT 0x0000000087FF58F8 00352C (v02 SaSsdt SaSsdt   00003000 INTL 20120913)
[    0.000000] ACPI: UEFI 0x0000000087FF8E28 000042 (v01                 00000000      00000000)
[    0.000000] ACPI: SSDT 0x0000000087FF8E70 000E58 (v02 CpuRef CpuSsdt  00003000 INTL 20120913)
[    0.000000] ACPI: SSDT 0x0000000087FF9CC8 003720 (v02 DptfTa DptfTabl 00001000 INTL 20120913)
[    0.000000] ACPI: MSDM 0x0000000087FFD3E8 000055 (v03 DELL   CBX3     06222004 AMI  00010013)
[    0.000000] ACPI: SLIC 0x0000000087FFD440 000176 (v03 DELL   CBX3     01072009 MSFT 00010013)
[    0.000000] ACPI: BGRT 0x0000000087FFD5B8 000038 (v00 ?\xb5\xf2?            01072009 AMI  00010013)
[    0.000000] ACPI: TPM2 0x0000000087FFD5F0 000034 (v03        Tpm2Tabl 00000001 AMI  00000000)
[    0.000000] ACPI: ASF! 0x0000000087FFD628 0000A5 (v32 INTEL   HCG     00000001 TFSM 000F4240)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x00000002727fffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x2727fb000-0x2727fefff]
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.000000]   Normal   [mem 0x0000000100000000-0x00000002727fffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x0000000000057fff]
[    0.000000]   node   0: [mem 0x0000000000059000-0x000000000009cfff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x000000007a41dfff]
[    0.000000]   node   0: [mem 0x000000007a449000-0x000000007a4a1fff]
[    0.000000]   node   0: [mem 0x000000007ac23000-0x0000000086c39fff]
[    0.000000]   node   0: [mem 0x0000000087ffe000-0x0000000087ffefff]
[    0.000000]   node   0: [mem 0x0000000100000000-0x00000002727fffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x00000002727fffff]
[    0.000000] On node 0 totalpages: 2067498
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 22 pages reserved
[    0.000000]   DMA zone: 3995 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 8531 pages used for memmap
[    0.000000]   DMA32 zone: 545935 pages, LIFO batch:31
[    0.000000]   Normal zone: 23712 pages used for memmap
[    0.000000]   Normal zone: 1517568 pages, LIFO batch:31
[    0.000000] Reserved but unavailable: 98 pages
[    0.000000] Reserving Intel graphics memory at [mem 0x8a800000-0x8c7fffff]
[    0.000000] ACPI: PM-Timer IO Port: 0x1808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-119
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] [Firmware Bug]: TSC_DEADLINE disabled due to Errata; please update microcode to version: 0xb2 (or later)
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] e820: [mem 0x8c800000-0xdfffffff] available for PCI devices
[    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1910969940391419 ns
[    0.000000] random: get_random_bytes called from start_kernel+0x8a/0x49d with crng_init=0
[    0.000000] setup_percpu: NR_CPUS:128 nr_cpumask_bits:128 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] percpu: Embedded 42 pages/cpu @        (ptrval) s132312 r8192 d31528 u524288
[    0.000000] pcpu-alloc: s132312 r8192 d31528 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 2035169
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-4.17.0-rc6 root=UUID=a46f8764-1525-43b5-871b-e4e5b4ad1e4a rw rootflags=subvol=root cryptdevice=/dev/disk/by-uuid/959cda6d-3f53-43ad-9cb5-a360b3176eeb:crypt-main:allow-discards iwlwifi.debug=0x4000 quiet
[    0.000000] Memory: 7814948K/8269992K available (12300K kernel code, 551K rwdata, 4028K rodata, 960K init, 772K bss, 455044K reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Kernel/User page tables isolation: enabled
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=128 to nr_cpu_ids=4.
[    0.000000] 	Tasks RCU enabled.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
[    0.000000] NR_IRQS: 8448, nr_irqs: 1024, preallocated irqs: 16
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] ACPI: Core revision 20180313
[    0.000000] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 79635855245 ns
[    0.000000] hpet clockevent registered
[    0.001000] APIC: Switch to symmetric I/O mode setup
[    0.003000] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
[    0.008000] tsc: Detected 2400.000 MHz processor
[    0.008000] clocksource: tsc-early: mask: 0xffffffffffffffff max_cycles: 0x22983777dd9, max_idle_ns: 440795300422 ns
[    0.008000] Calibrating delay loop (skipped), value calculated using timer frequency.. 4800.00 BogoMIPS (lpj=2400000)
[    0.008000] pid_max: default: 32768 minimum: 301
[    0.008000] Security Framework initialized
[    0.008000] Yama: becoming mindful.
[    0.010886] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.012025] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.012063] Mount-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.012096] Mountpoint-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.012234] CPU: Physical Processor ID: 0
[    0.012234] CPU: Processor Core ID: 0
[    0.012238] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.012239] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.012244] mce: CPU supports 8 MCE banks
[    0.012253] CPU0: Thermal monitoring enabled (TM1)
[    0.012265] process: using mwait in idle threads
[    0.012268] Last level iTLB entries: 4KB 64, 2MB 8, 4MB 8
[    0.012268] Last level dTLB entries: 4KB 64, 2MB 0, 4MB 0, 1GB 4
[    0.012270] Spectre V2 : Mitigation: Full generic retpoline
[    0.012270] Spectre V2 : Spectre v2 mitigation: Filling RSB on context switch
[    0.016880] Freeing SMP alternatives memory: 32K
[    0.023000] smpboot: CPU0: Intel(R) Core(TM) i5-6200U CPU @ 2.30GHz (family: 0x6, model: 0x4e, stepping: 0x3)
[    0.023000] random: get_random_bytes called from cpu_startup_entry+0x24/0x70 with crng_init=0
[    0.027041] Performance Events: PEBS fmt3+, Skylake events, 32-deep LBR, full-width counters, Intel PMU driver.
[    0.027066] ... version:                4
[    0.027066] ... bit width:              48
[    0.027067] ... generic registers:      4
[    0.027067] ... value mask:             0000ffffffffffff
[    0.027068] ... max period:             00007fffffffffff
[    0.027068] ... fixed-purpose events:   3
[    0.027069] ... event mask:             000000070000000f
[    0.028040] Hierarchical SRCU implementation.
[    0.030020] smp: Bringing up secondary CPUs ...
[    0.035044] x86: Booting SMP configuration:
[    0.035045] .... node  #0, CPUs:      #1
[    0.001000] random: get_random_bytes called from start_secondary+0x137/0x1b0 with crng_init=0
[    0.040042]  #2 #3
[    0.045525] smp: Brought up 1 node, 4 CPUs
[    0.045525] smpboot: Max logical packages: 1
[    0.045525] smpboot: Total of 4 processors activated (19200.00 BogoMIPS)
[    0.046259] devtmpfs: initialized
[    0.046259] PM: Registering ACPI NVS region [mem 0x7a41e000-0x7a41efff] (4096 bytes)
[    0.046259] PM: Registering ACPI NVS region [mem 0x87651000-0x87f98fff] (9732096 bytes)
[    0.047005] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1911260446275000 ns
[    0.047010] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    0.047045] xor: automatically using best checksumming function   avx       
[    0.047050] pinctrl core: initialized pinctrl subsystem
[    0.047104] NET: Registered protocol family 16
[    0.047236] cpuidle: using governor menu
[    0.047236] Simple Boot Flag at 0x47 set to 0x80
[    0.047236] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.047236] ACPI: bus type PCI registered
[    0.047236] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.047236] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.047236] PCI: Using configuration type 1 for base access
[    0.048267] HugeTLB registered 2.00 MiB page size, pre-allocated 0 pages
[    0.048267] cryptd: max_cpu_qlen set to 1000
[    0.064537] raid6: sse2x1   gen()  9847 MB/s
[    0.081533] raid6: sse2x1   xor()  7283 MB/s
[    0.098534] raid6: sse2x2   gen() 12109 MB/s
[    0.115535] raid6: sse2x2   xor()  8472 MB/s
[    0.132532] raid6: sse2x4   gen() 14121 MB/s
[    0.149532] raid6: sse2x4   xor()  8652 MB/s
[    0.166533] raid6: avx2x1   gen() 19535 MB/s
[    0.183531] raid6: avx2x1   xor() 14189 MB/s
[    0.200542] raid6: avx2x2   gen() 23519 MB/s
[    0.217531] raid6: avx2x2   xor() 15853 MB/s
[    0.234532] raid6: avx2x4   gen() 25207 MB/s
[    0.251531] raid6: avx2x4   xor() 16251 MB/s
[    0.251532] raid6: using algorithm avx2x4 gen() 25207 MB/s
[    0.251533] raid6: .... xor() 16251 MB/s, rmw enabled
[    0.251533] raid6: using avx2x2 recovery algorithm
[    0.252002] ACPI: Added _OSI(Module Device)
[    0.252002] ACPI: Added _OSI(Processor Device)
[    0.252002] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.252002] ACPI: Added _OSI(Processor Aggregator Device)
[    0.252002] ACPI: Added _OSI(Linux-Dell-Video)
[    0.280894] ACPI: 9 ACPI AML tables successfully acquired and loaded
[    0.286153] ACPI: [Firmware Bug]: BIOS _OSI(Linux) query ignored
[    0.293254] ACPI: Dynamic OEM Table Load:
[    0.293259] ACPI: SSDT 0xFFFF967268A64800 00061E (v02 PmRef  Cpu0Ist  00003000 INTL 20120913)
[    0.293655] ACPI: \_PR_.CPU0: _OSC native thermal LVT Acked
[    0.294844] ACPI: Dynamic OEM Table Load:
[    0.294848] ACPI: SSDT 0xFFFF967268406C00 00037F (v02 PmRef  Cpu0Cst  00003001 INTL 20120913)
[    0.295789] ACPI: Dynamic OEM Table Load:
[    0.295793] ACPI: SSDT 0xFFFF967268A64000 0005AA (v02 PmRef  ApIst    00003000 INTL 20120913)
[    0.296353] ACPI: Dynamic OEM Table Load:
[    0.296357] ACPI: SSDT 0xFFFF967268A99C00 000119 (v02 PmRef  ApCst    00003000 INTL 20120913)
[    0.298413] ACPI: EC: EC started
[    0.298413] ACPI: EC: interrupt blocked
[    0.302131] ACPI: \_SB_.PCI0.LPCB.ECDV: Used as first EC
[    0.302132] ACPI: \_SB_.PCI0.LPCB.ECDV: GPE=0x45, EC_CMD/EC_SC=0x934, EC_DATA=0x930
[    0.302133] ACPI: \_SB_.PCI0.LPCB.ECDV: Used as boot DSDT EC to handle transactions
[    0.302134] ACPI: Interpreter enabled
[    0.302165] ACPI: (supports S0 S3 S5)
[    0.302165] ACPI: Using IOAPIC for interrupt routing
[    0.302197] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.302665] ACPI: Enabled 9 GPEs in block 00 to 7F
[    0.304159] ACPI: Power Resource [PG00] (on)
[    0.304461] ACPI: Power Resource [PG01] (on)
[    0.304726] ACPI: Power Resource [PG02] (on)
[    0.306121] ACPI: Power Resource [WRST] (off)
[    0.306407] ACPI: Power Resource [WRST] (off)
[    0.306697] ACPI: Power Resource [WRST] (off)
[    0.306974] ACPI: Power Resource [WRST] (off)
[    0.307244] ACPI: Power Resource [WRST] (off)
[    0.307521] ACPI: Power Resource [WRST] (off)
[    0.307795] ACPI: Power Resource [WRST] (off)
[    0.308067] ACPI: Power Resource [WRST] (off)
[    0.308344] ACPI: Power Resource [WRST] (off)
[    0.308833] ACPI: Power Resource [WRST] (off)
[    0.309102] ACPI: Power Resource [WRST] (off)
[    0.309377] ACPI: Power Resource [WRST] (off)
[    0.309660] ACPI: Power Resource [WRST] (off)
[    0.309945] ACPI: Power Resource [WRST] (off)
[    0.310220] ACPI: Power Resource [WRST] (off)
[    0.310497] ACPI: Power Resource [WRST] (off)
[    0.310771] ACPI: Power Resource [WRST] (off)
[    0.311040] ACPI: Power Resource [WRST] (off)
[    0.311318] ACPI: Power Resource [WRST] (off)
[    0.311598] ACPI: Power Resource [WRST] (off)
[    0.322072] ACPI: Power Resource [FN00] (off)
[    0.322973] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
[    0.322979] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.324403] acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug PME AER PCIeCapability]
[    0.324404] acpi PNP0A08:00: FADT indicates ASPM is unsupported, using BIOS configuration
[    0.324629] PCI host bridge to bus 0000:00
[    0.324631] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
[    0.324632] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    0.324633] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
[    0.324634] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000c3fff window]
[    0.324636] pci_bus 0000:00: root bus resource [mem 0x000c4000-0x000c7fff window]
[    0.324637] pci_bus 0000:00: root bus resource [mem 0x000c8000-0x000cbfff window]
[    0.324638] pci_bus 0000:00: root bus resource [mem 0x000cc000-0x000cffff window]
[    0.324639] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff window]
[    0.324640] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff window]
[    0.324641] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff window]
[    0.324642] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff window]
[    0.324643] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff window]
[    0.324644] pci_bus 0000:00: root bus resource [mem 0x000e8000-0x000ebfff window]
[    0.324645] pci_bus 0000:00: root bus resource [mem 0x000ec000-0x000effff window]
[    0.324646] pci_bus 0000:00: root bus resource [mem 0x8c800000-0xdfffffff window]
[    0.324647] pci_bus 0000:00: root bus resource [mem 0xfd000000-0xfe7fffff window]
[    0.324649] pci_bus 0000:00: root bus resource [bus 00-fe]
[    0.324659] pci 0000:00:00.0: [8086:1904] type 00 class 0x060000
[    0.324773] pci 0000:00:02.0: [8086:1916] type 00 class 0x030000
[    0.324784] pci 0000:00:02.0: reg 0x10: [mem 0xde000000-0xdeffffff 64bit]
[    0.324790] pci 0000:00:02.0: reg 0x18: [mem 0xc0000000-0xcfffffff 64bit pref]
[    0.324794] pci 0000:00:02.0: reg 0x20: [io  0xf000-0xf03f]
[    0.324913] pci 0000:00:04.0: [8086:1903] type 00 class 0x118000
[    0.324926] pci 0000:00:04.0: reg 0x10: [mem 0xdf120000-0xdf127fff 64bit]
[    0.325110] pci 0000:00:14.0: [8086:9d2f] type 00 class 0x0c0330
[    0.325133] pci 0000:00:14.0: reg 0x10: [mem 0xdf110000-0xdf11ffff 64bit]
[    0.325207] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.325419] pci 0000:00:15.0: [8086:9d60] type 00 class 0x118000
[    0.325682] pci 0000:00:15.0: reg 0x10: [mem 0xdf137000-0xdf137fff 64bit]
[    0.326683] pci 0000:00:15.1: [8086:9d61] type 00 class 0x118000
[    0.326947] pci 0000:00:15.1: reg 0x10: [mem 0xdf136000-0xdf136fff 64bit]
[    0.327882] pci 0000:00:16.0: [8086:9d3a] type 00 class 0x078000
[    0.327909] pci 0000:00:16.0: reg 0x10: [mem 0xdf135000-0xdf135fff 64bit]
[    0.327989] pci 0000:00:16.0: PME# supported from D3hot
[    0.328094] pci 0000:00:17.0: [8086:9d03] type 00 class 0x010601
[    0.328114] pci 0000:00:17.0: reg 0x10: [mem 0xdf130000-0xdf131fff]
[    0.328122] pci 0000:00:17.0: reg 0x14: [mem 0xdf134000-0xdf1340ff]
[    0.328130] pci 0000:00:17.0: reg 0x18: [io  0xf090-0xf097]
[    0.328138] pci 0000:00:17.0: reg 0x1c: [io  0xf080-0xf083]
[    0.328145] pci 0000:00:17.0: reg 0x20: [io  0xf060-0xf07f]
[    0.328153] pci 0000:00:17.0: reg 0x24: [mem 0xdf133000-0xdf1337ff]
[    0.328200] pci 0000:00:17.0: PME# supported from D3hot
[    0.328327] pci 0000:00:1c.0: [8086:9d14] type 01 class 0x060400
[    0.328418] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.328599] pci 0000:00:1f.0: [8086:9d48] type 00 class 0x060100
[    0.328815] pci 0000:00:1f.2: [8086:9d21] type 00 class 0x058000
[    0.328830] pci 0000:00:1f.2: reg 0x10: [mem 0xdf12c000-0xdf12ffff]
[    0.328995] pci 0000:00:1f.3: [8086:9d70] type 00 class 0x040300
[    0.329015] pci 0000:00:1f.3: reg 0x10: [mem 0xdf128000-0xdf12bfff 64bit]
[    0.329042] pci 0000:00:1f.3: reg 0x20: [mem 0xdf100000-0xdf10ffff 64bit]
[    0.329095] pci 0000:00:1f.3: PME# supported from D3hot D3cold
[    0.329265] pci 0000:00:1f.4: [8086:9d23] type 00 class 0x0c0500
[    0.329325] pci 0000:00:1f.4: reg 0x10: [mem 0xdf132000-0xdf1320ff 64bit]
[    0.329395] pci 0000:00:1f.4: reg 0x20: [io  0xf040-0xf05f]
[    0.329831] pci 0000:01:00.0: [8086:3165] type 00 class 0x028000
[    0.329928] pci 0000:01:00.0: reg 0x10: [mem 0xdf000000-0xdf001fff 64bit]
[    0.330235] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    0.330747] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.330752] pci 0000:00:1c.0:   bridge window [mem 0xdf000000-0xdf0fffff]
[    0.332891] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.332947] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *10 11 12 14 15)
[    0.333000] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.333043] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.333098] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.333152] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.333208] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.333262] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.335000] ACPI: EC: interrupt unblocked
[    0.335000] ACPI: EC: event unblocked
[    0.335000] ACPI: \_SB_.PCI0.LPCB.ECDV: GPE=0x45, EC_CMD/EC_SC=0x934, EC_DATA=0x930
[    0.335000] ACPI: \_SB_.PCI0.LPCB.ECDV: Used as boot DSDT EC to handle transactions and events
[    0.335779] SCSI subsystem initialized
[    0.335784] libata version 3.00 loaded.
[    0.336206] ACPI: bus type USB registered
[    0.336217] usbcore: registered new interface driver usbfs
[    0.336223] usbcore: registered new interface driver hub
[    0.336676] usbcore: registered new device driver usb
[    0.336695] Registered efivars operations
[    0.342107] Advanced Linux Sound Architecture Driver Initialized.
[    0.342114] PCI: Using ACPI for IRQ routing
[    0.370131] PCI: pci_cache_line_size set to 64 bytes
[    0.370552] e820: reserve RAM buffer [mem 0x00058000-0x0005ffff]
[    0.370553] e820: reserve RAM buffer [mem 0x0009d000-0x0009ffff]
[    0.370553] e820: reserve RAM buffer [mem 0x7a41e000-0x7bffffff]
[    0.370555] e820: reserve RAM buffer [mem 0x7a4a2000-0x7bffffff]
[    0.370555] e820: reserve RAM buffer [mem 0x86c3a000-0x87ffffff]
[    0.370557] e820: reserve RAM buffer [mem 0x87fff000-0x87ffffff]
[    0.370557] e820: reserve RAM buffer [mem 0x272800000-0x273ffffff]
[    0.370648] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    0.370686] wmi_bus wmi_bus-PNP0C14:00: WQBC data block query control method not found
[    0.370795] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.370800] hpet0: 8 comparators, 64-bit 24.000000 MHz counter
[    0.373013] clocksource: Switched to clocksource tsc-early
[    0.373068] pnp: PnP ACPI init
[    0.373243] system 00:00: [io  0x0680-0x069f] has been reserved
[    0.373244] system 00:00: [io  0xffff] has been reserved
[    0.373245] system 00:00: [io  0xffff] has been reserved
[    0.373247] system 00:00: [io  0xffff] has been reserved
[    0.373248] system 00:00: [io  0x1800-0x18fe] has been reserved
[    0.373249] system 00:00: [io  0x164e-0x164f] has been reserved
[    0.373253] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.373348] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.373373] system 00:02: [io  0x1854-0x1857] has been reserved
[    0.373376] system 00:02: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    0.373547] pnp 00:03: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.373561] pnp 00:04: Plug and Play ACPI device, IDs DLL06fd PNP0f13 (active)
[    0.373720] system 00:05: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.373722] system 00:05: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.373723] system 00:05: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.373724] system 00:05: [mem 0xe0000000-0xefffffff] has been reserved
[    0.373726] system 00:05: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.373727] system 00:05: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.373728] system 00:05: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.373730] system 00:05: [mem 0xff000000-0xffffffff] has been reserved
[    0.373731] system 00:05: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.373733] system 00:05: [mem 0xdffe0000-0xdfffffff] has been reserved
[    0.373736] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.373763] system 00:06: [mem 0xfd000000-0xfdabffff] has been reserved
[    0.373765] system 00:06: [mem 0xfdad0000-0xfdadffff] has been reserved
[    0.373766] system 00:06: [mem 0xfdb00000-0xfdffffff] has been reserved
[    0.373768] system 00:06: [mem 0xfe000000-0xfe01ffff] could not be reserved
[    0.373769] system 00:06: [mem 0xfe036000-0xfe03bfff] has been reserved
[    0.373770] system 00:06: [mem 0xfe03d000-0xfe3fffff] has been reserved
[    0.373772] system 00:06: [mem 0xfe410000-0xfe7fffff] has been reserved
[    0.373774] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.374709] system 00:07: [mem 0xfe029000-0xfe029fff] has been reserved
[    0.374711] system 00:07: [mem 0xfe028000-0xfe028fff] has been reserved
[    0.374714] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.376565] pnp: PnP ACPI: found 8 devices
[    0.382015] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
[    0.382032] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.382045] pci 0000:00:1c.0:   bridge window [mem 0xdf000000-0xdf0fffff]
[    0.382052] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    0.382053] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
[    0.382054] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff window]
[    0.382056] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000c3fff window]
[    0.382057] pci_bus 0000:00: resource 8 [mem 0x000c4000-0x000c7fff window]
[    0.382058] pci_bus 0000:00: resource 9 [mem 0x000c8000-0x000cbfff window]
[    0.382059] pci_bus 0000:00: resource 10 [mem 0x000cc000-0x000cffff window]
[    0.382060] pci_bus 0000:00: resource 11 [mem 0x000d0000-0x000d3fff window]
[    0.382061] pci_bus 0000:00: resource 12 [mem 0x000d4000-0x000d7fff window]
[    0.382062] pci_bus 0000:00: resource 13 [mem 0x000d8000-0x000dbfff window]
[    0.382063] pci_bus 0000:00: resource 14 [mem 0x000dc000-0x000dffff window]
[    0.382065] pci_bus 0000:00: resource 15 [mem 0x000e4000-0x000e7fff window]
[    0.382066] pci_bus 0000:00: resource 16 [mem 0x000e8000-0x000ebfff window]
[    0.382067] pci_bus 0000:00: resource 17 [mem 0x000ec000-0x000effff window]
[    0.382068] pci_bus 0000:00: resource 18 [mem 0x8c800000-0xdfffffff window]
[    0.382069] pci_bus 0000:00: resource 19 [mem 0xfd000000-0xfe7fffff window]
[    0.382070] pci_bus 0000:01: resource 1 [mem 0xdf000000-0xdf0fffff]
[    0.382172] NET: Registered protocol family 2
[    0.382262] tcp_listen_portaddr_hash hash table entries: 4096 (order: 4, 65536 bytes)
[    0.382325] TCP established hash table entries: 65536 (order: 7, 524288 bytes)
[    0.382457] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.382722] TCP: Hash tables configured (established 65536 bind 65536)
[    0.382756] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.382792] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.382848] NET: Registered protocol family 1
[    0.382939] pci 0000:00:02.0: Video device with shadowed ROM at [mem 0x000c0000-0x000dffff]
[    0.384228] PCI: CLS 0 bytes, default 64
[    0.384256] Unpacking initramfs...
[    0.464655] Freeing initrd memory: 6000K
[    0.464664] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.464667] software IO TLB [mem 0x74702000-0x78702000] (64MB) mapped at [        (ptrval)-        (ptrval)]
[    0.464752] RAPL PMU: API unit is 2^-32 Joules, 5 fixed counters, 655360 ms ovfl timer
[    0.464753] RAPL PMU: hw unit of domain pp0-core 2^-14 Joules
[    0.464753] RAPL PMU: hw unit of domain package 2^-14 Joules
[    0.464754] RAPL PMU: hw unit of domain dram 2^-14 Joules
[    0.464754] RAPL PMU: hw unit of domain pp1-gpu 2^-14 Joules
[    0.464755] RAPL PMU: hw unit of domain psys 2^-14 Joules
[    0.464879] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x22983777dd9, max_idle_ns: 440795300422 ns
[    0.464890] clocksource: Switched to clocksource tsc
[    0.464918] Scanning for low memory corruption every 60 seconds
[    0.465401] Initialise system trusted keyrings
[    0.465421] workingset: timestamp_bits=56 max_order=21 bucket_order=0
[    0.698130] Key type asymmetric registered
[    0.698131] Asymmetric key parser 'x509' registered
[    0.698158] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.698159] io scheduler noop registered
[    0.698160] io scheduler deadline registered
[    0.698186] io scheduler cfq registered (default)
[    0.698187] io scheduler kyber registered
[    0.698615] pcieport 0000:00:1c.0: AER enabled with IRQ 120
[    0.698633] pcieport 0000:00:1c.0: Signaling PME with IRQ 120
[    0.698649] intel_idle: MWAIT substates: 0x11142120
[    0.698650] intel_idle: v0.4.1 model 0x4E
[    0.698808] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.699419] ACPI: AC Adapter [AC] (on-line)
[    0.699469] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
[    0.699480] ACPI: Lid Switch [LID0]
[    0.699520] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
[    0.699529] ACPI: Power Button [PBTN]
[    0.699553] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
[    0.699557] ACPI: Sleep Button [SBTN]
[    0.699579] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    0.699586] ACPI: Power Button [PWRF]
[    0.701986] thermal LNXTHERM:00: registered as thermal_zone0
[    0.701987] ACPI: Thermal Zone [THM] (25 C)
[    0.702116] ACPI: Invalid active1 threshold
[    0.702182] thermal LNXTHERM:01: registered as thermal_zone1
[    0.702183] ACPI: Thermal Zone [TZ00] (28 C)
[    0.702268] thermal LNXTHERM:02: registered as thermal_zone2
[    0.702269] ACPI: Thermal Zone [TZ01] (30 C)
[    0.703250] Linux agpgart interface v0.103
[    0.704339] [drm] Replacing VGA console driver
[    0.707638] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    0.707639] [drm] Driver supports precise vblank timestamp query.
[    0.709224] i915 0000:00:02.0: Direct firmware load for i915/skl_dmc_ver1_27.bin failed with error -2
[    0.709226] i915 0000:00:02.0: Failed to load DMC firmware i915/skl_dmc_ver1_27.bin. Disabling runtime power management.
[    0.709228] i915 0000:00:02.0: DMC firmware homepage: https://01.org/linuxgraphics/downloads/firmware
[    0.718398] [drm] Initialized i915 1.6.0 20180308 for 0000:00:02.0 on minor 0
[    0.720798] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    0.723609] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input4
[    0.724747] loop: module loaded
[    0.724793] ahci 0000:00:17.0: version 3.0
[    0.724968] ahci 0000:00:17.0: SSS flag set, parallel bus scan disabled
[    0.724990] ahci 0000:00:17.0: AHCI 0001.0301 32 slots 1 ports 6 Gbps 0x1 impl SATA mode
[    0.724992] ahci 0000:00:17.0: flags: 64bit ncq stag pm led clo only pio slum part deso sadm sds apst 
[    0.725210] scsi host0: ahci
[    0.725262] ata1: SATA max UDMA/133 abar m2048@0xdf133000 port 0xdf133100 irq 122
[    0.725282] Intel(R) Wireless WiFi driver for Linux
[    0.725282] Copyright(c) 2003- 2015 Intel Corporation
[    0.725552] iwlwifi 0000:01:00.0: enabling device (0000 -> 0002)
[    0.727215] iwlwifi 0000:01:00.0: Direct firmware load for iwlwifi-7265D-29.ucode failed with error -2
[    0.727224] iwlwifi 0000:01:00.0: Direct firmware load for iwlwifi-7265D-28.ucode failed with error -2
[    0.727713] iwlwifi 0000:01:00.0: loaded firmware version 27.541033.0 op_mode iwlmvm
[    0.727752] iwlwifi 0000:01:00.0: Detected Intel(R) Dual Band Wireless AC 3165, REV=0x210
[    0.735680] fbcon: inteldrmfb (fb0) is primary device
[    0.739305] ACPI: Battery Slot [BAT0] (battery present)
[    0.742970] pcieport 0000:00:1c.0: AER: Corrected error received: id=00e0
[    0.742975] pcieport 0000:00:1c.0: PCIe Bus Error: severity=Corrected, type=Physical Layer, id=00e0(Receiver ID)
[    0.742977] pcieport 0000:00:1c.0:   device [8086:9d14] error status/mask=00000001/00002000
[    0.742978] pcieport 0000:00:1c.0:    [ 0] Receiver Error         (First)
[    0.753446] iwlwifi 0000:01:00.0: base HW address: 94:65:9c:f5:87:7d
[    0.815195] ieee80211 phy0: Selected rate control algorithm 'iwl-mvm-rs'
[    0.815563] thermal thermal_zone3: failed to read out thermal zone (-61)
[    0.815575] usbcore: registered new interface driver ax88179_178a
[    0.815731] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    0.815736] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 1
[    0.816823] xhci_hcd 0000:00:14.0: hcc params 0x200077c1 hci version 0x100 quirks 0x00109810
[    0.816828] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    0.817005] hub 1-0:1.0: USB hub found
[    0.817026] hub 1-0:1.0: 12 ports detected
[    0.817840] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    0.817843] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 2
[    0.817845] xhci_hcd 0000:00:14.0: Host supports USB 3.0  SuperSpeed
[    0.817952] hub 2-0:1.0: USB hub found
[    0.817967] hub 2-0:1.0: 6 ports detected
[    0.818544] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    0.818913] i8042: Warning: Keylock active
[    0.820398] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.820419] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.820782] random: fast init done
[    0.820802] i801_smbus 0000:00:1f.4: SPD Write Disable is set
[    0.820838] i801_smbus 0000:00:1f.4: SMBus using PCI interrupt
[    0.821155] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input5
[    0.859703] ACPI Warning: \_SB.IETM._ART: Return Package type mismatch at index 0 - found Integer, expected Reference (20180313/nspredef-263)
[    0.859708] ACPI: Invalid package element [0]: got number, expecting [R]
[    0.859709] _ART package 0 is invalid, ignored
[    0.897649] proc_thermal 0000:00:04.0: enabling device (0000 -> 0002)
[    0.925235] device-mapper: ioctl: 4.39.0-ioctl (2018-04-03) initialised: dm-devel@redhat.com
[    0.925256] intel_pstate: Intel P-state driver initializing
[    0.925471] intel_pstate: HWP enabled
[    0.925505] usbcore: registered new interface driver usbhid
[    0.925506] usbhid: USB HID core driver
[    0.925509] msi_wmi: This machine doesn't have neither MSI-hotkeys nor backlight through WMI
[    0.925712] snd_hda_intel 0000:00:1f.3: enabling device (0000 -> 0002)
[    0.928967] NET: Registered protocol family 17
[    0.929231] microcode: sig=0x406e3, pf=0x80, revision=0x2d
[    0.929281] microcode: Microcode Update Driver: v2.2.
[    0.929287] AVX2 version of gcm_enc/dec engaged.
[    0.929288] AES CTR mode by8 optimization enabled
[    0.941999] sched_clock: Marking stable (941990113, 0)->(1042592550, -100602437)
[    0.942298] registered taskstats version 1
[    0.942299] Loading compiled-in X.509 certificates
[    0.942818] Btrfs loaded, crc32c=crc32c-intel
[    0.943884] hctosys: unable to open rtc device (rtc0)
[    0.943895] cfg80211: Loading compiled-in X.509 certificates for regulatory database
[    0.992794] cfg80211: Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
[    0.992798] ALSA device list:
[    0.992799]   No soundcards found.
[    1.037825] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.040329] ata1.00: ATA-9: SAMSUNG SSD PM871 2.5 7mm 256GB, EMT02D0Q, max UDMA/133
[    1.040331] ata1.00: 500118192 sectors, multi 1: LBA48 NCQ (depth 31/32), AA
[    1.042084] ata1.00: configured for UDMA/133
[    1.137597] usb 1-4: new full-speed USB device number 2 using xhci_hcd
[    1.277092] hid-generic 0003:0483:91D1.0001: device has no listeners, quitting
[    1.380110] usb 2-1: new SuperSpeed USB device number 2 using xhci_hcd
[    1.509081] usb 1-5: new high-speed USB device number 3 using xhci_hcd
[    1.738829] psmouse serio1: synaptics: queried max coordinates: x [..5664], y [..4648]
[    1.749097] ax88179_178a 2-1:1.0 eth0: register 'ax88179_178a' at usb-0000:00:14.0-1, ASIX AX88179 USB 3.0 Gigabit Ethernet, a0:ce:c8:05:75:a5
[    1.764990] psmouse serio1: synaptics: queried min coordinates: x [1278..], y [1206..]
[    1.764999] psmouse serio1: synaptics: Your touchpad (PNP: DLL06fd PNP0f13) says it can support a different bus. If i2c-hid and hid-rmi are not used, you might want to try setting psmouse.synaptics_intertouch to 1 and report this to linux-input@vger.kernel.org.
[    1.817410] psmouse serio1: synaptics: Touchpad model: 1, fw: 8.1, id: 0x1e2b1, caps: 0xd00523/0x840300/0x12e800/0x0, board id: 3014, fw id: 1842486
[    1.850116] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input7
[    1.859964] snd_hda_intel 0000:00:1f.3: bound 0000:00:02.0 (ops 0xffffffff916a6dc0)
[    1.860219] _warn_unseeded_randomness: 16 callbacks suppressed
[    1.860228] random: get_random_bytes called from load_elf_binary+0xd09/0x1630 with crng_init=1
[    1.878529] snd_hda_codec_conexant hdaudioC0D0: CX20722: BIOS auto-probing.
[    1.879033] snd_hda_codec_conexant hdaudioC0D0: autoconfig for CX20722: line_outs=1 (0x17/0x0/0x0/0x0/0x0) type:speaker
[    1.879037] snd_hda_codec_conexant hdaudioC0D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    1.879041] snd_hda_codec_conexant hdaudioC0D0:    hp_outs=1 (0x16/0x0/0x0/0x0/0x0)
[    1.879044] snd_hda_codec_conexant hdaudioC0D0:    mono: mono_out=0x0
[    1.879046] snd_hda_codec_conexant hdaudioC0D0:    inputs:
[    1.879050] snd_hda_codec_conexant hdaudioC0D0:      Internal Mic=0x1a
[    1.879053] snd_hda_codec_conexant hdaudioC0D0:      Mic=0x19
[    1.880678] snd_hda_codec_conexant hdaudioC0D0: Enable sync_write for stable communication
[    1.881109] usb 1-7: new full-speed USB device number 4 using xhci_hcd
[    1.885711] Console: switching to colour frame buffer device 240x67
[    1.891498] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1f.3/sound/card0/input8
[    1.892579] input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1f.3/sound/card0/input9
[    1.892613] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1f.3/sound/card0/input10
[    1.892665] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1f.3/sound/card0/input11
[    1.892696] input: HDA Intel PCH HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:1f.3/sound/card0/input12
[    1.892722] input: HDA Intel PCH HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:1f.3/sound/card0/input13
[    1.892765] input: HDA Intel PCH HDMI/DP,pcm=9 as /devices/pci0000:00/0000:00:1f.3/sound/card0/input14
[    1.892790] input: HDA Intel PCH HDMI/DP,pcm=10 as /devices/pci0000:00/0000:00:1f.3/sound/card0/input15
[    1.912223] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    1.912481] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG SSD PM87 2D0Q PQ: 0 ANSI: 5
[    1.912859] sd 0:0:0:0: [sda] 500118192 512-byte logical blocks: (256 GB/238 GiB)
[    1.912878] sd 0:0:0:0: [sda] Write Protect is off
[    1.912882] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.912904] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.916323]  sda: sda1 sda2 sda3
[    1.916759] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.016344] input: Wacom Pen and multitouch sensor Finger as /devices/pci0000:00/0000:00:14.0/usb1/1-7/1-7:1.0/0003:056A:480D.0002/input/input17
[    2.016411] wacom 0003:056A:480D.0002: : USB HID v1.11 Device [Wacom Co.,Ltd. Pen and multitouch sensor] on usb-0000:00:14.0-7/input0
[    2.018079] input: Wacom Pen and multitouch sensor Pen as /devices/pci0000:00/0000:00:14.0/usb1/1-7/1-7:1.1/0003:056A:480D.0003/input/input19
[    2.018139] wacom 0003:056A:480D.0003: : USB HID v1.11 Mouse [Wacom Co.,Ltd. Pen and multitouch sensor] on usb-0000:00:14.0-7/input1
[    2.078557] Freeing unused kernel memory: 960K
[    2.078558] Write protecting the kernel read-only data: 18432k
[    2.079775] Freeing unused kernel memory: 2008K
[    2.079945] Freeing unused kernel memory: 68K
[    2.085435] x86/mm: Checked W+X mappings: passed, no W+X pages found.
[    2.085436] x86/mm: Checking user space page tables
[    2.090762] x86/mm: Checked W+X mappings: passed, no W+X pages found.
[    2.119538] random: get_random_bytes called from generate_random_uuid+0xe/0x30 with crng_init=1
[    2.120684] random: get_random_bytes called from load_elf_binary+0xd09/0x1630 with crng_init=1
[    4.918988] random: crng init done
[    9.248728] BTRFS: device fsid a46f8764-1525-43b5-871b-e4e5b4ad1e4a devid 1 transid 804225 /dev/dm-0
[    9.267322] BTRFS info (device dm-0): disk space caching is enabled
[    9.267324] BTRFS info (device dm-0): has skinny extents
[    9.328001] BTRFS info (device dm-0): enabling ssd optimizations
[    9.488392] systemd[1]: systemd 238 running in system mode. (+PAM -AUDIT -SELINUX -IMA -APPARMOR +SMACK -SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD -IDN2 +IDN +PCRE2 default-hierarchy=hybrid)
[    9.500263] systemd[1]: Detected architecture x86-64.
[    9.501047] systemd[1]: Set hostname to <zzz>.
[    9.543380] systemd[1]: File /usr/lib/systemd/system/systemd-journald.service:35 configures an IP firewall (IPAddressDeny=any), but the local system does not support BPF/cgroup based firewalling.
[    9.543383] systemd[1]: Proceeding WITHOUT firewalling in effect! (This warning is only shown for the first loaded unit using IP firewalling.)
[    9.562928] systemd[1]: Started Forward Password Requests to Wall Directory Watch.
[    9.562952] systemd[1]: Reached target Swap.
[    9.562995] systemd[1]: Listening on Device-mapper event daemon FIFOs.
[    9.563115] systemd[1]: Created slice system-getty.slice.
[    9.563171] systemd[1]: Listening on Journal Socket (/dev/log).
[    9.732944] BTRFS info (device dm-0): use zstd compression, level 0
[    9.732952] BTRFS info (device dm-0): enabling auto defrag
[    9.732955] BTRFS info (device dm-0): disk space caching is enabled
[    9.774281] systemd-journald[268]: Received request to flush runtime journal from PID 1
[   10.455758] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
[   11.517616] pcieport 0000:00:1c.0: AER: Corrected error received: id=00e0
[   11.517623] pcieport 0000:00:1c.0: PCIe Bus Error: severity=Corrected, type=Physical Layer, id=00e0(Receiver ID)
[   11.517627] pcieport 0000:00:1c.0:   device [8086:9d14] error status/mask=00000001/00002000
[   11.517630] pcieport 0000:00:1c.0:    [ 0] Receiver Error         (First)
[   11.530000] iwlwifi 0000:01:00.0: U iwl_mvm_get_regdomain Getting regdomain data for ZZ from FW
[   11.530003] iwlwifi 0000:01:00.0: U iwl_mvm_update_mcc send MCC update to FW with 'ZZ' src = 16
[   11.530404] iwlwifi 0000:01:00.0: U iwl_mvm_update_mcc MCC response status: 0x1. new MCC: 0x3030 ('00') change: 0 n_chans: 39
[   11.530406] iwlwifi 0000:01:00.0: U iwl_parse_nvm_mcc_info building regdom for 39 channels
[   11.530411] iwlwifi 0000:01:00.0: U iwl_nvm_print_channel_flags Ch. 1: 0x34b: VALID IBSS ACTIVE GO_CONCURRENT 20MHZ 40MHZ
[   11.530414] iwlwifi 0000:01:00.0: U iwl_nvm_print_channel_flags Ch. 2: 0x34b: VALID IBSS ACTIVE GO_CONCURRENT 20MHZ 40MHZ
[   11.530416] iwlwifi 0000:01:00.0: U iwl_nvm_print_channel_flags Ch. 3: 0x34b: VALID IBSS ACTIVE GO_CONCURRENT 20MHZ 40MHZ
[   11.530419] iwlwifi 0000:01:00.0: U iwl_nvm_print_channel_flags Ch. 4: 0x34b: VALID IBSS ACTIVE GO_CONCURRENT 20MHZ 40MHZ
[   11.530422] iwlwifi 0000:01:00.0: U iwl_nvm_print_channel_flags Ch. 5: 0x34b: VALID IBSS ACTIVE GO_CONCURRENT 20MHZ 40MHZ
[   11.530424] iwlwifi 0000:01:00.0: U iwl_nvm_print_channel_flags Ch. 6: 0x34b: VALID IBSS ACTIVE GO_CONCURRENT 20MHZ 40MHZ
[   11.530427] iwlwifi 0000:01:00.0: U iwl_nvm_print_channel_flags Ch. 7: 0x34b: VALID IBSS ACTIVE GO_CONCURRENT 20MHZ 40MHZ
[   11.530429] iwlwifi 0000:01:00.0: U iwl_nvm_print_channel_flags Ch. 8: 0x34b: VALID IBSS ACTIVE GO_CONCURRENT 20MHZ 40MHZ
[   11.530432] iwlwifi 0000:01:00.0: U iwl_nvm_print_channel_flags Ch. 9: 0x34b: VALID IBSS ACTIVE GO_CONCURRENT 20MHZ 40MHZ
[   11.530435] iwlwifi 0000:01:00.0: U iwl_nvm_print_channel_flags Ch. 10: 0x34b: VALID IBSS ACTIVE GO_CONCURRENT 20MHZ 40MHZ
[   11.530437] iwlwifi 0000:01:00.0: U iwl_nvm_print_channel_flags Ch. 11: 0x34b: VALID IBSS ACTIVE GO_CONCURRENT 20MHZ 40MHZ
[   11.530440] iwlwifi 0000:01:00.0: U iwl_nvm_print_channel_flags Ch. 12: 0x341: VALID GO_CONCURRENT 20MHZ 40MHZ
[   11.530443] iwlwifi 0000:01:00.0: U iwl_nvm_print_channel_flags Ch. 13: 0x341: VALID GO_CONCURRENT 20MHZ 40MHZ
[   11.530444] iwlwifi 0000:01:00.0: U iwl_nvm_print_channel_flags Ch. 14: 0x0: No traffic
[   11.530447] iwlwifi 0000:01:00.0: U iwl_nvm_print_channel_flags Ch. 36: 0x7e1: VALID INDOOR_ONLY GO_CONCURRENT UNIFORM 20MHZ 40MHZ 80MHZ
[   11.530451] BUG: unable to handle kernel NULL pointer dereference at 000000000000000a
[   11.530456] PGD 0 P4D 0 
[   11.530460] Oops: 0000 [#1] PREEMPT SMP PTI
[   11.530461] Modules linked in: kvm_intel kvm irqbypass joydev
[   11.530469] CPU: 2 PID: 367 Comm: NetworkManager Tainted: G                T 4.17.0-rc6 #8
[   11.530470] Hardware name: Dell Inc. Inspiron 15-7568/0M5YMV, BIOS 01.00.00 08/07/2015
[   11.530476] RIP: 0010:reg_query_regdb_wmm+0x14/0x160
[   11.530478] RSP: 0018:ffff9b62c10fb4b0 EFLAGS: 00010207
[   11.530481] RAX: ffff9672648f8000 RBX: ffff96726110a000 RCX: ffff9672648f8638
[   11.530483] RDX: ffff96726110a008 RSI: 000000000000143c RDI: ffff9672648f8018
[   11.530484] RBP: 0000000000013088 R08: 00000000000002aa R09: 0000000000000000
[   11.530486] R10: 0000000000000000 R11: 0000000000000001 R12: ffffffff9195ebbb
[   11.530488] R13: 000000000000143c R14: 000000000000000e R15: 00000000000007e1
[   11.530490] FS:  00007fe7341c7880(0000) GS:ffff967272500000(0000) knlGS:0000000000000000
[   11.530492] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   11.530494] CR2: 000000000000000a CR3: 00000002613ca006 CR4: 00000000003606e0
[   11.530496] Call Trace:
[   11.530501]  iwl_parse_nvm_mcc_info+0x390/0x7e0
[   11.530505]  iwl_mvm_get_regdomain+0x90/0x160
[   11.530509]  iwl_mvm_init_mcc+0x6f/0x1f0
[   11.530512]  ? iwl_mvm_power_update_device+0x7b/0xb0
[   11.530515]  iwl_mvm_up+0x8b3/0x990
[   11.530518]  __iwl_mvm_mac_start+0x26c/0x2d0
[   11.530521]  iwl_mvm_mac_start+0x4e/0x120
[   11.530524]  ? inetdev_event+0x72/0x4d0
[   11.530528]  drv_start+0x2d/0x50
[   11.530531]  ieee80211_do_open+0x453/0x880
[   11.530535]  __dev_open+0xb4/0x130
[   11.530538]  __dev_change_flags+0x1a1/0x210
[   11.530541]  ? __dev_notify_flags+0x56/0xf0
[   11.530544]  dev_change_flags+0x1e/0x60
[   11.530548]  ? nla_put_ifalias+0x2e/0x90
[   11.530550]  do_setlink+0x656/0xd80
[   11.530554]  ? __nla_reserve+0x38/0x50
[   11.530556]  ? __nla_put+0xc/0x20
[   11.530559]  ? nla_put+0x2f/0x40
[   11.530561]  ? rtnl_xdp_fill+0x172/0x1d0
[   11.530564]  ? __nla_reserve+0x38/0x50
[   11.530566]  ? __nla_reserve+0x38/0x50
[   11.530569]  ? inet_fill_link_af+0x1c/0x50
[   11.530571]  rtnl_newlink+0x793/0x930
[   11.530576]  ? __wake_up_common_lock+0x84/0xb0
[   11.530579]  rtnetlink_rcv_msg+0x121/0x390
[   11.530583]  ? dput.part.5+0x92/0x120
[   11.530586]  ? __lookup_slow+0x137/0x160
[   11.530589]  ? rtnl_calcit.isra.14+0x110/0x110
[   11.530592]  netlink_rcv_skb+0x44/0x110
[   11.530595]  netlink_unicast+0x18b/0x230
[   11.530597]  netlink_sendmsg+0x1f0/0x3b0
[   11.530601]  sock_sendmsg+0x14/0x20
[   11.530603]  ___sys_sendmsg+0x28e/0x2f0
[   11.530607]  ? try_to_wake_up+0x26a/0x360
[   11.530610]  ? __check_object_size+0xf9/0x180
[   11.530613]  ? __fget+0x67/0xa0
[   11.530615]  __sys_sendmsg+0x52/0xa0
[   11.530620]  do_syscall_64+0x43/0xd0
[   11.530623]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   11.530626] RIP: 0033:0x7fe7319e37b7
[   11.530627] RSP: 002b:00007ffd3169fb60 EFLAGS: 00000293 ORIG_RAX: 000000000000002e
[   11.530629] RAX: ffffffffffffffda RBX: 0000000000000007 RCX: 00007fe7319e37b7
[   11.530631] RDX: 0000000000000000 RSI: 00007ffd3169fbc0 RDI: 0000000000000007
[   11.530632] RBP: 00007ffd3169fbc0 R08: 0000000000000000 R09: 0000000000000008
[   11.530634] R10: 000056141edf4010 R11: 0000000000000293 R12: 0000000000000000
[   11.530636] R13: 00007ffd3169fbc0 R14: 00007ffd3169fd44 R15: 0000000000000000
[   11.530637] Code: ff ff 0f 1f 44 00 00 eb ae 0f 1f 40 00 66 2e 0f 1f 84 00 00 00 00 00 4c 8b 0d 59 56 fc 00 49 81 f9 00 f0 ff ff 0f 87 12 01 00 00 <45> 0f b7 41 0a 49 89 d2 b8 c3 ff ff ff 49 8d 51 08 66 45 85 c0 
[   11.530671] RIP: reg_query_regdb_wmm+0x14/0x160 RSP: ffff9b62c10fb4b0
[   11.530673] CR2: 000000000000000a
[   11.530675] ---[ end trace 45779f68d165a366 ]---

--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=config

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86 4.17.0-rc6 Kernel Configuration
#
CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_MMU=y
CONFIG_ARCH_MMAP_RND_BITS_MIN=28
CONFIG_ARCH_MMAP_RND_BITS_MAX=32
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MIN=8
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MAX=16
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
CONFIG_ARCH_HAS_FILTER_PGPROT=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_64_SMP=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_PGTABLE_LEVELS=4
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y
CONFIG_THREAD_INFO_IN_TASK=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
# CONFIG_COMPILE_TEST is not set
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_CROSS_MEMORY_ATTACH is not set
# CONFIG_USELIB is not set
# CONFIG_AUDIT is not set
CONFIG_HAVE_ARCH_AUDITSYSCALL=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_EFFECTIVE_AFF_MASK=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_MIGRATION=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_HIERARCHY=y
CONFIG_GENERIC_MSI_IRQ=y
CONFIG_GENERIC_MSI_IRQ_DOMAIN=y
CONFIG_GENERIC_IRQ_MATRIX_ALLOCATOR=y
CONFIG_GENERIC_IRQ_RESERVATION_MODE=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_CLOCKSOURCE_VALIDATE_LAST_CYCLE=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
CONFIG_NO_HZ_IDLE=y
# CONFIG_NO_HZ_FULL is not set
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_BSD_PROCESS_ACCT is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
# CONFIG_TASK_XACCT is not set
# CONFIG_CPU_ISOLATION is not set

#
# RCU Subsystem
#
CONFIG_PREEMPT_RCU=y
# CONFIG_RCU_EXPERT is not set
CONFIG_SRCU=y
CONFIG_TREE_SRCU=y
CONFIG_TASKS_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_NEED_SEGCBLIST=y
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=19
CONFIG_LOG_CPU_MAX_BUF_SHIFT=12
CONFIG_PRINTK_SAFE_LOG_BUF_SHIFT=13
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH=y
CONFIG_ARCH_SUPPORTS_INT128=y
# CONFIG_NUMA_BALANCING is not set
CONFIG_CGROUPS=y
# CONFIG_MEMCG is not set
# CONFIG_BLK_CGROUP is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
# CONFIG_RT_GROUP_SCHED is not set
# CONFIG_CGROUP_PIDS is not set
# CONFIG_CGROUP_RDMA is not set
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_HUGETLB is not set
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_DEVICE is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_CGROUP_PERF is not set
# CONFIG_CGROUP_DEBUG is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
# CONFIG_USER_NS is not set
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
# CONFIG_RD_LZ4 is not set
CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BPF=y
CONFIG_EXPERT=y
CONFIG_UID16=y
CONFIG_MULTIUSER=y
# CONFIG_SGETMASK_SYSCALL is not set
# CONFIG_SYSFS_SYSCALL is not set
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_FHANDLE=y
CONFIG_POSIX_TIMERS=y
CONFIG_PRINTK=y
CONFIG_PRINTK_NMI=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_FUTEX_PI=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
# CONFIG_AIO is not set
CONFIG_ADVISE_SYSCALLS=y
# CONFIG_MEMBARRIER is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_ALL is not set
CONFIG_KALLSYMS_ABSOLUTE_PERCPU=y
CONFIG_KALLSYMS_BASE_RELATIVE=y
# CONFIG_BPF_SYSCALL is not set
# CONFIG_USERFAULTFD is not set
CONFIG_ARCH_HAS_MEMBARRIER_SYNC_CORE=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y
# CONFIG_PC104 is not set

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
# CONFIG_SLOB is not set
# CONFIG_SLAB_MERGE_DEFAULT is not set
CONFIG_SLAB_FREELIST_RANDOM=y
CONFIG_SLAB_FREELIST_HARDENED=y
CONFIG_SLUB_CPU_PARTIAL=y
CONFIG_SYSTEM_DATA_VERIFICATION=y
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_KPROBES is not set
CONFIG_JUMP_LABEL=y
# CONFIG_STATIC_KEYS_SELFTEST is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_FUNCTION_ERROR_INJECTION=y
CONFIG_HAVE_NMI=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_ARCH_HAS_FORTIFY_SOURCE=y
CONFIG_ARCH_HAS_SET_MEMORY=y
CONFIG_HAVE_ARCH_THREAD_STRUCT_WHITELIST=y
CONFIG_ARCH_WANTS_DYNAMIC_TASK_STRUCT=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_CLK=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_HARDLOCKUP_DETECTOR_PERF=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_HAVE_RCU_TABLE_FREE=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_GCC_PLUGINS=y
CONFIG_GCC_PLUGINS=y
# CONFIG_GCC_PLUGIN_CYC_COMPLEXITY is not set
# CONFIG_GCC_PLUGIN_LATENT_ENTROPY is not set
# CONFIG_GCC_PLUGIN_STRUCTLEAK is not set
CONFIG_GCC_PLUGIN_RANDSTRUCT=y
# CONFIG_GCC_PLUGIN_RANDSTRUCT_PERFORMANCE is not set
CONFIG_HAVE_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR_NONE is not set
# CONFIG_CC_STACKPROTECTOR_REGULAR is not set
CONFIG_CC_STACKPROTECTOR_STRONG=y
# CONFIG_CC_STACKPROTECTOR_AUTO is not set
CONFIG_HAVE_ARCH_WITHIN_STACK_FRAMES=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD=y
CONFIG_HAVE_ARCH_HUGE_VMAP=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_HAVE_MOD_ARCH_SPECIFIC=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y
CONFIG_ARCH_HAS_ELF_RANDOMIZE=y
CONFIG_HAVE_ARCH_MMAP_RND_BITS=y
CONFIG_HAVE_EXIT_THREAD=y
CONFIG_ARCH_MMAP_RND_BITS=28
CONFIG_HAVE_ARCH_MMAP_RND_COMPAT_BITS=y
CONFIG_ARCH_MMAP_RND_COMPAT_BITS=8
CONFIG_HAVE_ARCH_COMPAT_MMAP_BASES=y
CONFIG_HAVE_COPY_THREAD_TLS=y
CONFIG_HAVE_STACK_VALIDATION=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y
CONFIG_HAVE_ARCH_VMAP_STACK=y
CONFIG_VMAP_STACK=y
CONFIG_ARCH_HAS_STRICT_KERNEL_RWX=y
CONFIG_STRICT_KERNEL_RWX=y
CONFIG_ARCH_HAS_STRICT_MODULE_RWX=y
CONFIG_STRICT_MODULE_RWX=y
CONFIG_ARCH_HAS_REFCOUNT=y
# CONFIG_REFCOUNT_FULL is not set

#
# GCOV-based kernel profiling
#
CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
# CONFIG_MODULE_SIG is not set
# CONFIG_MODULE_COMPRESS is not set
CONFIG_MODULES_TREE_LOOKUP=y
CONFIG_BLOCK=y
CONFIG_BLK_SCSI_REQUEST=y
CONFIG_BLK_DEV_BSG=y
# CONFIG_BLK_DEV_BSGLIB is not set
# CONFIG_BLK_DEV_INTEGRITY is not set
# CONFIG_BLK_DEV_ZONED is not set
# CONFIG_BLK_CMDLINE_PARSER is not set
CONFIG_BLK_WBT=y
CONFIG_BLK_WBT_SQ=y
CONFIG_BLK_WBT_MQ=y
# CONFIG_BLK_SED_OPAL is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_EFI_PARTITION=y
CONFIG_BLOCK_COMPAT=y
CONFIG_BLK_MQ_PCI=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
# CONFIG_MQ_IOSCHED_DEADLINE is not set
CONFIG_MQ_IOSCHED_KYBER=y
# CONFIG_IOSCHED_BFQ is not set
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_RWSEM_SPIN_ON_OWNER=y
CONFIG_LOCK_SPIN_ON_OWNER=y
CONFIG_ARCH_USE_QUEUED_SPINLOCKS=y
CONFIG_QUEUED_SPINLOCKS=y
CONFIG_ARCH_USE_QUEUED_RWLOCKS=y
CONFIG_QUEUED_RWLOCKS=y
CONFIG_ARCH_HAS_SYNC_CORE_BEFORE_USERMODE=y
CONFIG_ARCH_HAS_SYSCALL_WRAPPER=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_FEATURE_NAMES=y
# CONFIG_X86_X2APIC is not set
# CONFIG_X86_MPPARSE is not set
# CONFIG_GOLDFISH is not set
CONFIG_RETPOLINE=y
# CONFIG_INTEL_RDT is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_INTEL_LPSS=y
# CONFIG_X86_AMD_PLATFORM_DEVICE is not set
CONFIG_IOSF_MBI=y
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
# CONFIG_HYPERVISOR_GUEST is not set
CONFIG_NO_BOOTMEM=y
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
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
# CONFIG_GART_IOMMU is not set
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS_RANGE_BEGIN=2
CONFIG_NR_CPUS_RANGE_END=512
CONFIG_NR_CPUS_DEFAULT=64
CONFIG_NR_CPUS=128
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_SCHED_MC_PRIO=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
# CONFIG_X86_MCELOG_LEGACY is not set
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_THERMAL_VECTOR=y

#
# Performance monitoring
#
CONFIG_PERF_EVENTS_INTEL_UNCORE=y
CONFIG_PERF_EVENTS_INTEL_RAPL=y
CONFIG_PERF_EVENTS_INTEL_CSTATE=y
# CONFIG_PERF_EVENTS_AMD_POWER is not set
CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX64=y
# CONFIG_X86_VSYSCALL_EMULATION is not set
# CONFIG_I8K is not set
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
# CONFIG_X86_5LEVEL is not set
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_X86_DIRECT_GBPAGES=y
CONFIG_ARCH_HAS_MEM_ENCRYPT=y
# CONFIG_AMD_MEM_ENCRYPT is not set
CONFIG_NUMA=y
# CONFIG_AMD_NUMA is not set
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
# CONFIG_NUMA_EMU is not set
CONFIG_NODES_SHIFT=6
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_HAVE_GENERIC_GUP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION=y
CONFIG_ARCH_ENABLE_THP_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=65536
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_ARCH_WANTS_THP_SWAP=y
CONFIG_THP_SWAP=y
CONFIG_TRANSPARENT_HUGE_PAGECACHE=y
# CONFIG_CLEANCACHE is not set
# CONFIG_CMA is not set
# CONFIG_ZPOOL is not set
# CONFIG_ZBUD is not set
# CONFIG_ZSMALLOC is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
# CONFIG_DEFERRED_STRUCT_PAGE_INIT is not set
# CONFIG_IDLE_PAGE_TRACKING is not set
CONFIG_ARCH_HAS_ZONE_DEVICE=y
# CONFIG_PERCPU_STATS is not set
# CONFIG_GUP_BENCHMARK is not set
# CONFIG_X86_PMEM_LEGACY is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
CONFIG_X86_INTEL_UMIP=y
# CONFIG_X86_INTEL_MPX is not set
# CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS is not set
CONFIG_EFI=y
# CONFIG_EFI_STUB is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
# CONFIG_KEXEC_FILE is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_RANDOMIZE_BASE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_DYNAMIC_MEMORY_LAYOUT=y
CONFIG_RANDOMIZE_MEMORY=y
CONFIG_RANDOMIZE_MEMORY_PHYSICAL_PADDING=0x0
CONFIG_HOTPLUG_CPU=y
# CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
# CONFIG_COMPAT_VDSO is not set
# CONFIG_LEGACY_VSYSCALL_EMULATE is not set
CONFIG_LEGACY_VSYSCALL_NONE=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_MODIFY_LDT_SYSCALL=y
CONFIG_HAVE_LIVEPATCH=y
CONFIG_ARCH_HAS_ADD_PAGES=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
# CONFIG_SUSPEND_SKIP_SYNC is not set
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_PM_CLK=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
CONFIG_ACPI_SYSTEM_POWER_STATES_SUPPORT=y
# CONFIG_ACPI_DEBUGGER is not set
CONFIG_ACPI_SPCR_TABLE=y
CONFIG_ACPI_LPIT=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS_POWER is not set
CONFIG_ACPI_REV_OVERRIDE_POSSIBLE=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_TAD is not set
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_CPU_FREQ_PSS=y
CONFIG_ACPI_PROCESSOR_CSTATE=y
CONFIG_ACPI_PROCESSOR_IDLE=y
CONFIG_ACPI_CPPC_LIB=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=y
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_NUMA=y
CONFIG_ARCH_HAS_ACPI_TABLE_UPGRADE=y
# CONFIG_ACPI_TABLE_UPGRADE is not set
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_HOTPLUG_IOAPIC=y
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_BGRT is not set
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
# CONFIG_ACPI_NFIT is not set
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
# CONFIG_ACPI_APEI is not set
# CONFIG_DPTF_POWER is not set
# CONFIG_PMIC_OPREGION is not set
# CONFIG_ACPI_CONFIGFS is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set
# CONFIG_CPU_FREQ_GOV_SCHEDUTIL is not set

#
# CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_GOV_LADDER is not set
CONFIG_CPU_IDLE_GOV_MENU=y
CONFIG_INTEL_IDLE=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_MMCONF_FAM10H=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
# CONFIG_PCIE_ECRC is not set
# CONFIG_PCIEAER_INJECT is not set
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
# CONFIG_PCIEASPM_DEFAULT is not set
CONFIG_PCIEASPM_POWERSAVE=y
# CONFIG_PCIEASPM_POWER_SUPERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=y
# CONFIG_PCIE_DPC is not set
# CONFIG_PCIE_PTM is not set
CONFIG_PCI_BUS_ADDR_T_64BIT=y
CONFIG_PCI_MSI=y
CONFIG_PCI_MSI_IRQ_DOMAIN=y
CONFIG_PCI_QUIRKS=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_STUB is not set
CONFIG_PCI_LOCKLESS_CONFIG=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
CONFIG_PCI_LABEL=y
# CONFIG_HOTPLUG_PCI is not set

#
# Cadence PCIe controllers support
#

#
# DesignWare PCI Core Support
#
# CONFIG_PCIE_DW_PLAT is not set

#
# PCI host controller drivers
#
# CONFIG_VMD is not set

#
# PCI Endpoint
#
# CONFIG_PCI_ENDPOINT is not set

#
# PCI switch controller drivers
#
# CONFIG_PCI_SW_SWITCHTEC is not set
# CONFIG_ISA_BUS is not set
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
# CONFIG_PCCARD is not set
# CONFIG_RAPIDIO is not set
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ELFCORE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
# CONFIG_X86_X32 is not set
CONFIG_COMPAT_32=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y
CONFIG_NET_INGRESS=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=y
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=y
# CONFIG_TLS is not set
# CONFIG_XFRM_USER is not set
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
# CONFIG_IP_FIB_TRIE_STATS is not set
# CONFIG_IP_MULTIPLE_TABLES is not set
# CONFIG_IP_ROUTE_MULTIPATH is not set
# CONFIG_IP_ROUTE_VERBOSE is not set
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE_DEMUX is not set
# CONFIG_IP_MROUTE is not set
CONFIG_SYN_COOKIES=y
# CONFIG_NET_FOU is not set
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
# CONFIG_INET_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
# CONFIG_NETLABEL is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
CONFIG_NETFILTER_ADVANCED=y
# CONFIG_BRIDGE_NETFILTER is not set

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_INGRESS=y
CONFIG_NETFILTER_NETLINK=y
# CONFIG_NETFILTER_NETLINK_ACCT is not set
# CONFIG_NETFILTER_NETLINK_QUEUE is not set
# CONFIG_NETFILTER_NETLINK_LOG is not set
CONFIG_NF_CONNTRACK=y
CONFIG_NF_LOG_COMMON=y
CONFIG_NF_LOG_NETDEV=y
CONFIG_NF_CONNTRACK_MARK=y
# CONFIG_NF_CONNTRACK_PROCFS is not set
# CONFIG_NF_CONNTRACK_EVENTS is not set
# CONFIG_NF_CONNTRACK_TIMEOUT is not set
# CONFIG_NF_CONNTRACK_TIMESTAMP is not set
# CONFIG_NF_CT_PROTO_DCCP is not set
# CONFIG_NF_CT_PROTO_SCTP is not set
# CONFIG_NF_CT_PROTO_UDPLITE is not set
# CONFIG_NF_CONNTRACK_AMANDA is not set
# CONFIG_NF_CONNTRACK_FTP is not set
# CONFIG_NF_CONNTRACK_H323 is not set
# CONFIG_NF_CONNTRACK_IRC is not set
# CONFIG_NF_CONNTRACK_NETBIOS_NS is not set
# CONFIG_NF_CONNTRACK_SNMP is not set
# CONFIG_NF_CONNTRACK_PPTP is not set
# CONFIG_NF_CONNTRACK_SANE is not set
# CONFIG_NF_CONNTRACK_SIP is not set
# CONFIG_NF_CONNTRACK_TFTP is not set
CONFIG_NF_CT_NETLINK=y
CONFIG_NF_CT_NETLINK_TIMEOUT=y
CONFIG_NF_NAT=y
CONFIG_NF_NAT_NEEDED=y
# CONFIG_NF_NAT_REDIRECT is not set
CONFIG_NF_TABLES=y
CONFIG_NF_TABLES_NETDEV=y
CONFIG_NFT_EXTHDR=y
CONFIG_NFT_META=y
CONFIG_NFT_RT=y
# CONFIG_NFT_NUMGEN is not set
CONFIG_NFT_CT=y
# CONFIG_NFT_SET_RBTREE is not set
# CONFIG_NFT_SET_HASH is not set
# CONFIG_NFT_SET_BITMAP is not set
CONFIG_NFT_COUNTER=y
CONFIG_NFT_LOG=y
CONFIG_NFT_LIMIT=y
CONFIG_NFT_MASQ=y
# CONFIG_NFT_REDIR is not set
CONFIG_NFT_NAT=y
# CONFIG_NFT_OBJREF is not set
# CONFIG_NFT_QUOTA is not set
CONFIG_NFT_REJECT=y
# CONFIG_NFT_COMPAT is not set
CONFIG_NFT_HASH=y
CONFIG_NFT_FIB=y
# CONFIG_NF_DUP_NETDEV is not set
# CONFIG_NFT_DUP_NETDEV is not set
# CONFIG_NFT_FWD_NETDEV is not set
# CONFIG_NF_FLOW_TABLE is not set
CONFIG_NETFILTER_XTABLES=y

#
# Xtables combined modules
#
# CONFIG_NETFILTER_XT_MARK is not set
# CONFIG_NETFILTER_XT_CONNMARK is not set

#
# Xtables targets
#
# CONFIG_NETFILTER_XT_TARGET_CLASSIFY is not set
# CONFIG_NETFILTER_XT_TARGET_CONNMARK is not set
# CONFIG_NETFILTER_XT_TARGET_HMARK is not set
# CONFIG_NETFILTER_XT_TARGET_IDLETIMER is not set
# CONFIG_NETFILTER_XT_TARGET_LED is not set
CONFIG_NETFILTER_XT_TARGET_LOG=y
# CONFIG_NETFILTER_XT_TARGET_MARK is not set
CONFIG_NETFILTER_XT_NAT=y
# CONFIG_NETFILTER_XT_TARGET_NETMAP is not set
# CONFIG_NETFILTER_XT_TARGET_NFLOG is not set
# CONFIG_NETFILTER_XT_TARGET_NFQUEUE is not set
# CONFIG_NETFILTER_XT_TARGET_RATEEST is not set
# CONFIG_NETFILTER_XT_TARGET_REDIRECT is not set
# CONFIG_NETFILTER_XT_TARGET_TEE is not set
# CONFIG_NETFILTER_XT_TARGET_TCPMSS is not set

#
# Xtables matches
#
# CONFIG_NETFILTER_XT_MATCH_ADDRTYPE is not set
# CONFIG_NETFILTER_XT_MATCH_BPF is not set
# CONFIG_NETFILTER_XT_MATCH_CGROUP is not set
# CONFIG_NETFILTER_XT_MATCH_CLUSTER is not set
CONFIG_NETFILTER_XT_MATCH_COMMENT=y
# CONFIG_NETFILTER_XT_MATCH_CONNBYTES is not set
# CONFIG_NETFILTER_XT_MATCH_CONNLABEL is not set
# CONFIG_NETFILTER_XT_MATCH_CONNLIMIT is not set
# CONFIG_NETFILTER_XT_MATCH_CONNMARK is not set
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=y
# CONFIG_NETFILTER_XT_MATCH_CPU is not set
# CONFIG_NETFILTER_XT_MATCH_DCCP is not set
# CONFIG_NETFILTER_XT_MATCH_DEVGROUP is not set
# CONFIG_NETFILTER_XT_MATCH_DSCP is not set
# CONFIG_NETFILTER_XT_MATCH_ECN is not set
# CONFIG_NETFILTER_XT_MATCH_ESP is not set
# CONFIG_NETFILTER_XT_MATCH_HASHLIMIT is not set
# CONFIG_NETFILTER_XT_MATCH_HELPER is not set
# CONFIG_NETFILTER_XT_MATCH_HL is not set
# CONFIG_NETFILTER_XT_MATCH_IPCOMP is not set
CONFIG_NETFILTER_XT_MATCH_IPRANGE=y
# CONFIG_NETFILTER_XT_MATCH_L2TP is not set
# CONFIG_NETFILTER_XT_MATCH_LENGTH is not set
CONFIG_NETFILTER_XT_MATCH_LIMIT=y
# CONFIG_NETFILTER_XT_MATCH_MAC is not set
# CONFIG_NETFILTER_XT_MATCH_MARK is not set
# CONFIG_NETFILTER_XT_MATCH_MULTIPORT is not set
# CONFIG_NETFILTER_XT_MATCH_NFACCT is not set
# CONFIG_NETFILTER_XT_MATCH_OSF is not set
CONFIG_NETFILTER_XT_MATCH_OWNER=y
# CONFIG_NETFILTER_XT_MATCH_PKTTYPE is not set
# CONFIG_NETFILTER_XT_MATCH_QUOTA is not set
# CONFIG_NETFILTER_XT_MATCH_RATEEST is not set
# CONFIG_NETFILTER_XT_MATCH_REALM is not set
CONFIG_NETFILTER_XT_MATCH_RECENT=y
# CONFIG_NETFILTER_XT_MATCH_SCTP is not set
CONFIG_NETFILTER_XT_MATCH_STATE=y
# CONFIG_NETFILTER_XT_MATCH_STATISTIC is not set
# CONFIG_NETFILTER_XT_MATCH_STRING is not set
# CONFIG_NETFILTER_XT_MATCH_TCPMSS is not set
# CONFIG_NETFILTER_XT_MATCH_TIME is not set
# CONFIG_NETFILTER_XT_MATCH_U32 is not set
# CONFIG_IP_SET is not set
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=y
CONFIG_NF_CONNTRACK_IPV4=y
CONFIG_NF_SOCKET_IPV4=y
CONFIG_NF_TABLES_IPV4=y
CONFIG_NFT_CHAIN_ROUTE_IPV4=y
CONFIG_NFT_REJECT_IPV4=y
# CONFIG_NFT_DUP_IPV4 is not set
CONFIG_NFT_FIB_IPV4=y
# CONFIG_NF_TABLES_ARP is not set
# CONFIG_NF_DUP_IPV4 is not set
CONFIG_NF_LOG_ARP=y
CONFIG_NF_LOG_IPV4=y
CONFIG_NF_REJECT_IPV4=y
CONFIG_NF_NAT_IPV4=y
CONFIG_NFT_CHAIN_NAT_IPV4=y
CONFIG_NF_NAT_MASQUERADE_IPV4=y
CONFIG_NFT_MASQ_IPV4=y
CONFIG_IP_NF_IPTABLES=y
# CONFIG_IP_NF_MATCH_AH is not set
# CONFIG_IP_NF_MATCH_ECN is not set
# CONFIG_IP_NF_MATCH_TTL is not set
CONFIG_IP_NF_FILTER=y
CONFIG_IP_NF_TARGET_REJECT=y
# CONFIG_IP_NF_TARGET_SYNPROXY is not set
CONFIG_IP_NF_NAT=y
CONFIG_IP_NF_TARGET_MASQUERADE=y
# CONFIG_IP_NF_TARGET_NETMAP is not set
# CONFIG_IP_NF_TARGET_REDIRECT is not set
# CONFIG_IP_NF_MANGLE is not set
# CONFIG_IP_NF_RAW is not set
# CONFIG_IP_NF_SECURITY is not set
# CONFIG_IP_NF_ARPTABLES is not set
# CONFIG_NF_TABLES_BRIDGE is not set
# CONFIG_BRIDGE_NF_EBTABLES is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_L2TP is not set
CONFIG_STP=m
CONFIG_BRIDGE=m
# CONFIG_BRIDGE_IGMP_SNOOPING is not set
CONFIG_HAVE_NET_DSA=y
# CONFIG_NET_DSA is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
CONFIG_LLC=m
# CONFIG_LLC2 is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
# CONFIG_DNS_RESOLVER is not set
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
CONFIG_NETLINK_DIAG=y
# CONFIG_MPLS is not set
# CONFIG_NET_NSH is not set
# CONFIG_HSR is not set
# CONFIG_NET_SWITCHDEV is not set
# CONFIG_NET_L3_MASTER_DEV is not set
# CONFIG_NET_NCSI is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_CGROUP_NET_PRIO is not set
# CONFIG_CGROUP_NET_CLASSID is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
# CONFIG_BPF_JIT is not set
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
# CONFIG_AF_KCM is not set
CONFIG_WIRELESS=y
CONFIG_CFG80211=y
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_CERTIFICATION_ONUS is not set
CONFIG_CFG80211_REQUIRE_SIGNED_REGDB=y
CONFIG_CFG80211_USE_KERNEL_REGDB_KEYS=y
CONFIG_CFG80211_DEFAULT_PS=y
CONFIG_CFG80211_CRDA_SUPPORT=y
# CONFIG_CFG80211_WEXT is not set
CONFIG_MAC80211=y
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_MINSTREL_HT=y
# CONFIG_MAC80211_RC_MINSTREL_VHT is not set
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
# CONFIG_MAC80211_MESH is not set
CONFIG_MAC80211_LEDS=y
# CONFIG_MAC80211_MESSAGE_TRACING is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
CONFIG_MAC80211_STA_HASH_MAX_SIZE=0
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_CEPH_LIB is not set
# CONFIG_NFC is not set
# CONFIG_PSAMPLE is not set
# CONFIG_NET_IFE is not set
# CONFIG_LWTUNNEL is not set
# CONFIG_NET_DEVLINK is not set
CONFIG_MAY_USE_DEVLINK=y
CONFIG_HAVE_EBPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
# CONFIG_UEVENT_HELPER is not set
CONFIG_DEVTMPFS=y
# CONFIG_DEVTMPFS_MOUNT is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_EXTRA_FIRMWARE="i915/skl_dmc_ver1_26.bin i915/skl_guc_ver6_1.bin i915/skl_huc_ver01_07_1398.bin iwlwifi-7265D-27.ucode"
CONFIG_EXTRA_FIRMWARE_DIR="/lib/firmware"
# CONFIG_FW_LOADER_USER_HELPER_FALLBACK is not set
CONFIG_WANT_DEV_COREDUMP=y
# CONFIG_ALLOW_DEV_COREDUMP is not set
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_DEBUG_TEST_DRIVER_REMOVE is not set
# CONFIG_TEST_ASYNC_DRIVER_PROBE is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_GENERIC_CPU_VULNERABILITIES=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_DMA_FENCE_TRACE is not set

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
# CONFIG_OF is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
# CONFIG_PARPORT is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_NULL_BLK is not set
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
CONFIG_BLK_DEV_NBD=m
# CONFIG_BLK_DEV_SKD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_BLK_DEV_RBD is not set
# CONFIG_BLK_DEV_RSXX is not set

#
# NVME Support
#
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_NVME_FC is not set

#
# Misc devices
#
# CONFIG_AD525X_DPOT is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
# CONFIG_ISL29003 is not set
# CONFIG_ISL29020 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_SRAM is not set
# CONFIG_PCI_ENDPOINT_TEST is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_EEPROM_IDT_89HPESX is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_SENSORS_LIS3_I2C is not set
# CONFIG_ALTERA_STAPL is not set
# CONFIG_INTEL_MEI is not set
# CONFIG_INTEL_MEI_ME is not set
# CONFIG_INTEL_MEI_TXE is not set
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC & related support
#

#
# Intel MIC Bus Driver
#
# CONFIG_INTEL_MIC_BUS is not set

#
# SCIF Bus Driver
#
# CONFIG_SCIF_BUS is not set

#
# VOP Bus Driver
#
# CONFIG_VOP_BUS is not set

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#

#
# SCIF Driver
#

#
# Intel MIC Coprocessor State Management (COSM) Drivers
#

#
# VOP Driver
#
# CONFIG_GENWQE is not set
# CONFIG_ECHO is not set
# CONFIG_MISC_RTSX_PCI is not set
# CONFIG_MISC_RTSX_USB is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_MQ_DEFAULT is not set
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
# CONFIG_CHR_DEV_SG is not set
# CONFIG_CHR_DEV_SCH is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
# CONFIG_SATA_PMP is not set

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=y
CONFIG_SATA_MOBILE_LPM_POLICY=0
# CONFIG_SATA_AHCI_PLATFORM is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
# CONFIG_ATA_SFF is not set
CONFIG_MD=y
# CONFIG_BLK_DEV_MD is not set
# CONFIG_BCACHE is not set
CONFIG_BLK_DEV_DM_BUILTIN=y
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_MQ_DEFAULT is not set
# CONFIG_DM_DEBUG is not set
# CONFIG_DM_UNSTRIPED is not set
CONFIG_DM_CRYPT=y
# CONFIG_DM_SNAPSHOT is not set
# CONFIG_DM_THIN_PROVISIONING is not set
# CONFIG_DM_CACHE is not set
# CONFIG_DM_ERA is not set
# CONFIG_DM_MIRROR is not set
# CONFIG_DM_RAID is not set
# CONFIG_DM_ZERO is not set
# CONFIG_DM_MULTIPATH is not set
# CONFIG_DM_DELAY is not set
# CONFIG_DM_UEVENT is not set
# CONFIG_DM_FLAKEY is not set
# CONFIG_DM_VERITY is not set
# CONFIG_DM_SWITCH is not set
# CONFIG_DM_LOG_WRITES is not set
# CONFIG_DM_INTEGRITY is not set
# CONFIG_TARGET_CORE is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_MII=y
CONFIG_NET_CORE=y
# CONFIG_BONDING is not set
# CONFIG_DUMMY is not set
# CONFIG_EQUALIZER is not set
# CONFIG_NET_FC is not set
# CONFIG_NET_TEAM is not set
# CONFIG_MACVLAN is not set
# CONFIG_IPVLAN is not set
# CONFIG_VXLAN is not set
# CONFIG_MACSEC is not set
# CONFIG_NETCONSOLE is not set
CONFIG_TUN=m
# CONFIG_TUN_VNET_CROSS_LE is not set
# CONFIG_VETH is not set
# CONFIG_NLMON is not set
# CONFIG_ARCNET is not set

#
# CAIF transport drivers
#

#
# Distributed Switch Architecture drivers
#
# CONFIG_ETHERNET is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_MDIO_DEVICE=y
CONFIG_MDIO_BUS=y
# CONFIG_MDIO_BITBANG is not set
# CONFIG_MDIO_THUNDER is not set
CONFIG_PHYLIB=y
# CONFIG_LED_TRIGGER_PHY is not set

#
# MII PHY device drivers
#
# CONFIG_AMD_PHY is not set
# CONFIG_AQUANTIA_PHY is not set
# CONFIG_AT803X_PHY is not set
# CONFIG_BCM7XXX_PHY is not set
# CONFIG_BCM87XX_PHY is not set
# CONFIG_BROADCOM_PHY is not set
# CONFIG_CICADA_PHY is not set
# CONFIG_CORTINA_PHY is not set
# CONFIG_DAVICOM_PHY is not set
# CONFIG_DP83822_PHY is not set
# CONFIG_DP83848_PHY is not set
# CONFIG_DP83867_PHY is not set
# CONFIG_FIXED_PHY is not set
# CONFIG_ICPLUS_PHY is not set
# CONFIG_INTEL_XWAY_PHY is not set
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_LXT_PHY is not set
# CONFIG_MARVELL_PHY is not set
# CONFIG_MARVELL_10G_PHY is not set
# CONFIG_MICREL_PHY is not set
# CONFIG_MICROCHIP_PHY is not set
# CONFIG_MICROSEMI_PHY is not set
# CONFIG_NATIONAL_PHY is not set
# CONFIG_QSEMI_PHY is not set
# CONFIG_REALTEK_PHY is not set
# CONFIG_RENESAS_PHY is not set
# CONFIG_ROCKCHIP_PHY is not set
# CONFIG_SMSC_PHY is not set
# CONFIG_STE10XP is not set
# CONFIG_TERANETICS_PHY is not set
# CONFIG_VITESSE_PHY is not set
# CONFIG_XILINX_GMII2RGMII is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
CONFIG_USB_NET_DRIVERS=y
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_RTL8152 is not set
# CONFIG_USB_LAN78XX is not set
CONFIG_USB_USBNET=y
# CONFIG_USB_NET_AX8817X is not set
CONFIG_USB_NET_AX88179_178A=y
# CONFIG_USB_NET_CDCETHER is not set
# CONFIG_USB_NET_CDC_EEM is not set
# CONFIG_USB_NET_CDC_NCM is not set
# CONFIG_USB_NET_HUAWEI_CDC_NCM is not set
# CONFIG_USB_NET_CDC_MBIM is not set
# CONFIG_USB_NET_DM9601 is not set
# CONFIG_USB_NET_SR9700 is not set
# CONFIG_USB_NET_SR9800 is not set
# CONFIG_USB_NET_SMSC75XX is not set
# CONFIG_USB_NET_SMSC95XX is not set
# CONFIG_USB_NET_GL620A is not set
# CONFIG_USB_NET_NET1080 is not set
# CONFIG_USB_NET_PLUSB is not set
# CONFIG_USB_NET_MCS7830 is not set
# CONFIG_USB_NET_RNDIS_HOST is not set
# CONFIG_USB_NET_CDC_SUBSET is not set
# CONFIG_USB_NET_ZAURUS is not set
# CONFIG_USB_NET_CX82310_ETH is not set
# CONFIG_USB_NET_KALMIA is not set
# CONFIG_USB_NET_QMI_WWAN is not set
# CONFIG_USB_NET_INT51X1 is not set
# CONFIG_USB_IPHETH is not set
# CONFIG_USB_SIERRA_NET is not set
# CONFIG_USB_NET_CH9200 is not set
CONFIG_WLAN=y
# CONFIG_WIRELESS_WDS is not set
# CONFIG_WLAN_VENDOR_ADMTEK is not set
# CONFIG_WLAN_VENDOR_ATH is not set
# CONFIG_WLAN_VENDOR_ATMEL is not set
# CONFIG_WLAN_VENDOR_BROADCOM is not set
# CONFIG_WLAN_VENDOR_CISCO is not set
CONFIG_WLAN_VENDOR_INTEL=y
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_IWL4965 is not set
# CONFIG_IWL3945 is not set
CONFIG_IWLWIFI=y
CONFIG_IWLWIFI_LEDS=y
# CONFIG_IWLDVM is not set
CONFIG_IWLMVM=y
# CONFIG_IWLWIFI_BCAST_FILTERING is not set
CONFIG_IWLWIFI_PCIE_RTPM=y

#
# Debugging Options
#
CONFIG_IWLWIFI_DEBUG=y
# CONFIG_WLAN_VENDOR_INTERSIL is not set
# CONFIG_WLAN_VENDOR_MARVELL is not set
# CONFIG_WLAN_VENDOR_MEDIATEK is not set
# CONFIG_WLAN_VENDOR_RALINK is not set
# CONFIG_WLAN_VENDOR_REALTEK is not set
# CONFIG_WLAN_VENDOR_RSI is not set
# CONFIG_WLAN_VENDOR_ST is not set
# CONFIG_WLAN_VENDOR_TI is not set
# CONFIG_WLAN_VENDOR_ZYDAS is not set
# CONFIG_WLAN_VENDOR_QUANTENNA is not set
# CONFIG_MAC80211_HWSIM is not set
# CONFIG_USB_NET_RNDIS_WLAN is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
# CONFIG_WAN is not set
# CONFIG_VMXNET3 is not set
# CONFIG_FUJITSU_ES is not set
# CONFIG_ISDN is not set
# CONFIG_NVM is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_LEDS is not set
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set
CONFIG_INPUT_SPARSEKMAP=y
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=y
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
# CONFIG_KEYBOARD_DLINK_DIR685 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
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
# CONFIG_KEYBOARD_TM2_TOUCHKEY is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
# CONFIG_MOUSE_PS2_ALPS is not set
# CONFIG_MOUSE_PS2_BYD is not set
# CONFIG_MOUSE_PS2_LOGIPS2PP is not set
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_SYNAPTICS_SMBUS=y
# CONFIG_MOUSE_PS2_CYPRESS is not set
# CONFIG_MOUSE_PS2_LIFEBOOK is not set
# CONFIG_MOUSE_PS2_TRACKPOINT is not set
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_PS2_FOCALTECH is not set
CONFIG_MOUSE_PS2_SMBUS=y
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_CYAPA is not set
# CONFIG_MOUSE_ELAN_I2C is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_PROPERTIES=y
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
# CONFIG_TOUCHSCREEN_BU21013 is not set
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
# CONFIG_TOUCHSCREEN_CYTTSP4_CORE is not set
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
# CONFIG_TOUCHSCREEN_EETI is not set
# CONFIG_TOUCHSCREEN_EGALAX_SERIAL is not set
# CONFIG_TOUCHSCREEN_EXC3000 is not set
# CONFIG_TOUCHSCREEN_FUJITSU is not set
# CONFIG_TOUCHSCREEN_HIDEEP is not set
# CONFIG_TOUCHSCREEN_ILI210X is not set
# CONFIG_TOUCHSCREEN_S6SY761 is not set
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_EKTF2127 is not set
# CONFIG_TOUCHSCREEN_ELAN is not set
# CONFIG_TOUCHSCREEN_ELO is not set
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
# CONFIG_TOUCHSCREEN_WACOM_I2C is not set
# CONFIG_TOUCHSCREEN_MAX11801 is not set
# CONFIG_TOUCHSCREEN_MCS5000 is not set
# CONFIG_TOUCHSCREEN_MMS114 is not set
# CONFIG_TOUCHSCREEN_MELFAS_MIP4 is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_INEXIO is not set
# CONFIG_TOUCHSCREEN_MK712 is not set
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
# CONFIG_TOUCHSCREEN_PIXCIR is not set
# CONFIG_TOUCHSCREEN_WDT87XX_I2C is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
# CONFIG_TOUCHSCREEN_TSC2004 is not set
# CONFIG_TOUCHSCREEN_TSC2007 is not set
# CONFIG_TOUCHSCREEN_SILEAD is not set
# CONFIG_TOUCHSCREEN_ST1232 is not set
# CONFIG_TOUCHSCREEN_STMFTS is not set
# CONFIG_TOUCHSCREEN_SX8654 is not set
# CONFIG_TOUCHSCREEN_TPS6507X is not set
# CONFIG_TOUCHSCREEN_ZET6223 is not set
# CONFIG_TOUCHSCREEN_ROHM_BU21023 is not set
# CONFIG_INPUT_MISC is not set
CONFIG_RMI4_CORE=y
CONFIG_RMI4_I2C=y
CONFIG_RMI4_SMB=y
CONFIG_RMI4_F03=y
CONFIG_RMI4_F03_SERIO=y
CONFIG_RMI4_2D_SENSOR=y
CONFIG_RMI4_F11=y
CONFIG_RMI4_F12=y
CONFIG_RMI4_F30=y
# CONFIG_RMI4_F34 is not set
CONFIG_RMI4_F55=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_SERIO_ARC_PS2 is not set
# CONFIG_USERIO is not set
# CONFIG_GAMEPORT is not set

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
# CONFIG_LEGACY_PTYS is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
CONFIG_DEVMEM=y
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
# CONFIG_SERIAL_8250 is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_UARTLITE is not set
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_SC16IS7XX is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_DEV_BUS is not set
# CONFIG_TTY_PRINTK is not set
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_HPET_MMAP_DEFAULT=y
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
# CONFIG_XILLYBUS is not set

#
# I2C support
#
CONFIG_I2C=y
CONFIG_ACPI_I2C_OPREGION=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
# CONFIG_I2C_CHARDEV is not set
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_LTC4306 is not set
# CONFIG_I2C_MUX_PCA9541 is not set
# CONFIG_I2C_MUX_REG is not set
# CONFIG_I2C_MUX_MLXCPLD is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=y
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
CONFIG_I2C_I801=y
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_ISMT is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_DESIGNWARE_PLATFORM is not set
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EMEV2 is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_ROBOTFUZZ_OSIF is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_MLXCPLD is not set
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_SLAVE is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
# CONFIG_SPMI is not set
# CONFIG_HSI is not set
# CONFIG_PPS is not set

#
# PTP clock support
#
# CONFIG_PTP_1588_CLOCK is not set

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
CONFIG_PINCTRL=y
# CONFIG_DEBUG_PINCTRL is not set
# CONFIG_PINCTRL_AMD is not set
# CONFIG_PINCTRL_MCP23S08 is not set
# CONFIG_PINCTRL_SX150X is not set
# CONFIG_PINCTRL_BAYTRAIL is not set
# CONFIG_PINCTRL_CHERRYVIEW is not set
# CONFIG_PINCTRL_BROXTON is not set
# CONFIG_PINCTRL_CANNONLAKE is not set
# CONFIG_PINCTRL_CEDARFORK is not set
# CONFIG_PINCTRL_DENVERTON is not set
# CONFIG_PINCTRL_GEMINILAKE is not set
# CONFIG_PINCTRL_LEWISBURG is not set
# CONFIG_PINCTRL_SUNRISEPOINT is not set
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
# CONFIG_POWER_AVS is not set
# CONFIG_POWER_RESET is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_CHARGER_SBS is not set
# CONFIG_BATTERY_BQ27XXX is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_BATTERY_GAUGE_LTC2941 is not set
CONFIG_HWMON=y
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
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ASPEED is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS620 is not set
# CONFIG_SENSORS_DS1621 is not set
CONFIG_SENSORS_DELL_SMM=y
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_G762 is not set
# CONFIG_SENSORS_HIH6130 is not set
# CONFIG_SENSORS_I5500 is not set
CONFIG_SENSORS_CORETEMP=y
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_POWR1220 is not set
# CONFIG_SENSORS_LINEAGE is not set
# CONFIG_SENSORS_LTC2945 is not set
# CONFIG_SENSORS_LTC2990 is not set
# CONFIG_SENSORS_LTC4151 is not set
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4222 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LTC4260 is not set
# CONFIG_SENSORS_LTC4261 is not set
# CONFIG_SENSORS_MAX16065 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX1668 is not set
# CONFIG_SENSORS_MAX197 is not set
# CONFIG_SENSORS_MAX6621 is not set
# CONFIG_SENSORS_MAX6639 is not set
# CONFIG_SENSORS_MAX6642 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_MAX6697 is not set
# CONFIG_SENSORS_MAX31790 is not set
# CONFIG_SENSORS_MCP3021 is not set
# CONFIG_SENSORS_TC654 is not set
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
# CONFIG_SENSORS_LM95234 is not set
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_LM95245 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_NTC_THERMISTOR is not set
# CONFIG_SENSORS_NCT6683 is not set
# CONFIG_SENSORS_NCT6775 is not set
# CONFIG_SENSORS_NCT7802 is not set
# CONFIG_SENSORS_NCT7904 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_PMBUS is not set
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SHT3x is not set
# CONFIG_SENSORS_SHTC1 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
# CONFIG_SENSORS_EMC2103 is not set
# CONFIG_SENSORS_EMC6W201 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_STTS751 is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_ADC128D818 is not set
# CONFIG_SENSORS_ADS1015 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_AMC6821 is not set
# CONFIG_SENSORS_INA209 is not set
# CONFIG_SENSORS_INA2XX is not set
# CONFIG_SENSORS_INA3221 is not set
# CONFIG_SENSORS_TC74 is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP103 is not set
# CONFIG_SENSORS_TMP108 is not set
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83773G is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83795 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_XGENE is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
# CONFIG_THERMAL_STATISTICS is not set
CONFIG_THERMAL_EMERGENCY_POWEROFF_DELAY_MS=0
# CONFIG_THERMAL_HWMON is not set
# CONFIG_THERMAL_WRITABLE_TRIPS is not set
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
# CONFIG_THERMAL_DEFAULT_GOV_POWER_ALLOCATOR is not set
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_GOV_STEP_WISE=y
# CONFIG_THERMAL_GOV_BANG_BANG is not set
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_GOV_POWER_ALLOCATOR is not set
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_INTEL_POWERCLAMP is not set
# CONFIG_X86_PKG_TEMP_THERMAL is not set
CONFIG_INTEL_SOC_DTS_IOSF_CORE=y
# CONFIG_INTEL_SOC_DTS_THERMAL is not set

#
# ACPI INT340X thermal drivers
#
CONFIG_INT340X_THERMAL=y
CONFIG_ACPI_THERMAL_REL=y
# CONFIG_INT3406_THERMAL is not set
# CONFIG_INTEL_PCH_THERMAL is not set
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_BCM590XX is not set
# CONFIG_MFD_BD9571MWV is not set
# CONFIG_MFD_AXP20X_I2C is not set
# CONFIG_MFD_CROS_EC is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_DA9062 is not set
# CONFIG_MFD_DA9063 is not set
# CONFIG_MFD_DA9150 is not set
# CONFIG_MFD_DLN2 is not set
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_MFD_INTEL_QUARK_I2C_GPIO is not set
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_INTEL_SOC_PMIC_CHTWC is not set
# CONFIG_MFD_INTEL_LPSS_ACPI is not set
# CONFIG_MFD_INTEL_LPSS_PCI is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX14577 is not set
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX77843 is not set
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_MT6397 is not set
# CONFIG_MFD_MENF21BMC is not set
# CONFIG_MFD_VIPERBOARD is not set
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RT5033 is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_SI476X_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_MFD_SKY81452 is not set
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_SYSCON is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_MFD_LP3943 is not set
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_TI_LMU is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65086 is not set
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TPS68470 is not set
# CONFIG_MFD_TI_LP873X is not set
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
# CONFIG_REGULATOR is not set
# CONFIG_RC_CORE is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=y
# CONFIG_AGP_AMD64 is not set
CONFIG_AGP_INTEL=y
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_VIA is not set
CONFIG_INTEL_GTT=y
# CONFIG_VGA_ARB is not set
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_MIPI_DSI=y
# CONFIG_DRM_DP_AUX_CHARDEV is not set
# CONFIG_DRM_DEBUG_MM is not set
# CONFIG_DRM_DEBUG_MM_SELFTEST is not set
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_KMS_FB_HELPER=y
CONFIG_DRM_FBDEV_EMULATION=y
CONFIG_DRM_FBDEV_OVERALLOC=100
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set

#
# I2C encoder or helper chips
#
# CONFIG_DRM_I2C_CH7006 is not set
# CONFIG_DRM_I2C_SIL164 is not set
# CONFIG_DRM_I2C_NXP_TDA998X is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_AMDGPU is not set

#
# ACP (Audio CoProcessor) Configuration
#

#
# AMD Library routines
#
# CONFIG_DRM_NOUVEAU is not set
CONFIG_DRM_I915=y
# CONFIG_DRM_I915_ALPHA_SUPPORT is not set
CONFIG_DRM_I915_CAPTURE_ERROR=y
CONFIG_DRM_I915_COMPRESS_ERROR=y
CONFIG_DRM_I915_USERPTR=y
# CONFIG_DRM_I915_GVT is not set

#
# drm/i915 Debugging
#
# CONFIG_DRM_I915_WERROR is not set
# CONFIG_DRM_I915_DEBUG is not set
# CONFIG_DRM_I915_SW_FENCE_DEBUG_OBJECTS is not set
# CONFIG_DRM_I915_SW_FENCE_CHECK_DAG is not set
# CONFIG_DRM_I915_SELFTEST is not set
# CONFIG_DRM_I915_LOW_LEVEL_TRACEPOINTS is not set
# CONFIG_DRM_I915_DEBUG_VBLANK_EVADE is not set
# CONFIG_DRM_VGEM is not set
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_DRM_QXL is not set
# CONFIG_DRM_BOCHS is not set
CONFIG_DRM_PANEL=y

#
# Display Panels
#
# CONFIG_DRM_PANEL_RASPBERRYPI_TOUCHSCREEN is not set
CONFIG_DRM_BRIDGE=y
CONFIG_DRM_PANEL_BRIDGE=y

#
# Display Interface Bridges
#
# CONFIG_DRM_ANALOGIX_ANX78XX is not set
# CONFIG_DRM_HISI_HIBMC is not set
# CONFIG_DRM_TINYDRM is not set
# CONFIG_DRM_LEGACY is not set
CONFIG_DRM_PANEL_ORIENTATION_QUIRKS=y

#
# Frame buffer Devices
#
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_CMDLINE=y
CONFIG_FB_NOTIFY=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
# CONFIG_FB_MODE_HELPERS is not set
# CONFIG_FB_TILEBLITTING is not set

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
# CONFIG_FB_VESA is not set
# CONFIG_FB_EFI is not set
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_OPENCORES is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_SMSCUFX is not set
# CONFIG_FB_UDL is not set
# CONFIG_FB_IBM_GXT4500 is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
# CONFIG_FB_AUO_K190X is not set
# CONFIG_FB_SIMPLE is not set
# CONFIG_FB_SM712 is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_PLATFORM=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_PM8941_WLED is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_LM3639 is not set
# CONFIG_BACKLIGHT_LV5207LP is not set
# CONFIG_BACKLIGHT_BD6107 is not set
# CONFIG_BACKLIGHT_ARCXCNN is not set
CONFIG_HDMI=y

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_DUMMY_CONSOLE_COLUMNS=80
CONFIG_DUMMY_CONSOLE_ROWS=25
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
# CONFIG_LOGO is not set
CONFIG_SOUND=y
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_SEQ_DEVICE=y
CONFIG_SND_JACK=y
CONFIG_SND_JACK_INPUT_DEV=y
# CONFIG_SND_OSSEMUL is not set
CONFIG_SND_PCM_TIMER=y
CONFIG_SND_HRTIMER=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_MAX_CARDS=32
# CONFIG_SND_SUPPORT_OLD_API is not set
CONFIG_SND_PROC_FS=y
# CONFIG_SND_VERBOSE_PROCFS is not set
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_SEQUENCER=y
# CONFIG_SND_SEQ_DUMMY is not set
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
CONFIG_SND_DRIVERS=y
# CONFIG_SND_DUMMY is not set
# CONFIG_SND_ALOOP is not set
# CONFIG_SND_VIRMIDI is not set
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_SERIAL_U16550 is not set
# CONFIG_SND_MPU401 is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
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
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
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
# CONFIG_SND_SE6X is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set

#
# HD-Audio
#
CONFIG_SND_HDA=y
CONFIG_SND_HDA_INTEL=y
CONFIG_SND_HDA_HWDEP=y
CONFIG_SND_HDA_RECONFIG=y
CONFIG_SND_HDA_INPUT_BEEP=y
CONFIG_SND_HDA_INPUT_BEEP_MODE=1
CONFIG_SND_HDA_PATCH_LOADER=y
# CONFIG_SND_HDA_CODEC_REALTEK is not set
# CONFIG_SND_HDA_CODEC_ANALOG is not set
# CONFIG_SND_HDA_CODEC_SIGMATEL is not set
# CONFIG_SND_HDA_CODEC_VIA is not set
CONFIG_SND_HDA_CODEC_HDMI=y
# CONFIG_SND_HDA_CODEC_CIRRUS is not set
CONFIG_SND_HDA_CODEC_CONEXANT=y
# CONFIG_SND_HDA_CODEC_CA0110 is not set
# CONFIG_SND_HDA_CODEC_CA0132 is not set
# CONFIG_SND_HDA_CODEC_CMEDIA is not set
# CONFIG_SND_HDA_CODEC_SI3054 is not set
CONFIG_SND_HDA_GENERIC=y
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
CONFIG_SND_HDA_CORE=y
CONFIG_SND_HDA_I915=y
CONFIG_SND_HDA_PREALLOC_SIZE=4096
# CONFIG_SND_USB is not set
# CONFIG_SND_SOC is not set
# CONFIG_SND_X86 is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
# CONFIG_HIDRAW is not set
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
# CONFIG_HID_A4TECH is not set
# CONFIG_HID_ACCUTOUCH is not set
# CONFIG_HID_ACRUX is not set
# CONFIG_HID_APPLE is not set
# CONFIG_HID_APPLEIR is not set
# CONFIG_HID_ASUS is not set
# CONFIG_HID_AUREAL is not set
# CONFIG_HID_BELKIN is not set
# CONFIG_HID_BETOP_FF is not set
# CONFIG_HID_CHERRY is not set
# CONFIG_HID_CHICONY is not set
# CONFIG_HID_CORSAIR is not set
# CONFIG_HID_PRODIKEYS is not set
# CONFIG_HID_CMEDIA is not set
# CONFIG_HID_CYPRESS is not set
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELAN is not set
# CONFIG_HID_ELECOM is not set
# CONFIG_HID_ELO is not set
# CONFIG_HID_EZKEY is not set
# CONFIG_HID_GEMBIRD is not set
# CONFIG_HID_GFRM is not set
# CONFIG_HID_HOLTEK is not set
# CONFIG_HID_GOOGLE_HAMMER is not set
# CONFIG_HID_GT683R is not set
# CONFIG_HID_KEYTOUCH is not set
# CONFIG_HID_KYE is not set
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_ICADE is not set
# CONFIG_HID_ITE is not set
# CONFIG_HID_JABRA is not set
# CONFIG_HID_TWINHAN is not set
# CONFIG_HID_KENSINGTON is not set
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LED is not set
# CONFIG_HID_LENOVO is not set
CONFIG_HID_LOGITECH=y
# CONFIG_HID_LOGITECH_HIDPP is not set
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
# CONFIG_LOGIWHEELS_FF is not set
# CONFIG_HID_MAGICMOUSE is not set
# CONFIG_HID_MAYFLASH is not set
CONFIG_HID_MICROSOFT=y
# CONFIG_HID_MONTEREY is not set
# CONFIG_HID_MULTITOUCH is not set
# CONFIG_HID_NTI is not set
# CONFIG_HID_NTRIG is not set
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PENMOUNT is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PLANTRONICS is not set
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_RETRODE is not set
# CONFIG_HID_ROCCAT is not set
# CONFIG_HID_SAITEK is not set
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SONY is not set
# CONFIG_HID_SPEEDLINK is not set
# CONFIG_HID_STEELSERIES is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_RMI is not set
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TIVO is not set
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THINGM is not set
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_UDRAW_PS3 is not set
CONFIG_HID_WACOM=y
# CONFIG_HID_WIIMOTE is not set
# CONFIG_HID_XINMO is not set
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
# CONFIG_HID_SENSOR_HUB is not set
# CONFIG_HID_ALPS is not set

#
# USB HID support
#
CONFIG_USB_HID=y
# CONFIG_HID_PID is not set
# CONFIG_USB_HIDDEV is not set

#
# I2C HID support
#
# CONFIG_I2C_HID is not set

#
# Intel ISH HID support
#
# CONFIG_INTEL_ISH_HID is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
CONFIG_USB_PCI=y
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
CONFIG_USB_DYNAMIC_MINORS=y
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
# CONFIG_USB_LEDS_TRIGGER_USBPORT is not set
# CONFIG_USB_MON is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=y
# CONFIG_USB_XHCI_DBGCAP is not set
CONFIG_USB_XHCI_PCI=y
# CONFIG_USB_XHCI_PLATFORM is not set
# CONFIG_USB_EHCI_HCD is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_FOTG210_HCD is not set
# CONFIG_USB_OHCI_HCD is not set
# CONFIG_USB_UHCI_HCD is not set
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_HCD_TEST_MODE is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_REALTEK=m
# CONFIG_REALTEK_AUTOPM is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_STORAGE_ENE_UB6250 is not set
# CONFIG_USB_UAS is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set
# CONFIG_USBIP_CORE is not set
# CONFIG_USB_MUSB_HDRC is not set
# CONFIG_USB_DWC3 is not set
# CONFIG_USB_DWC2 is not set
# CONFIG_USB_ISP1760 is not set

#
# USB port drivers
#
CONFIG_USB_SERIAL=m
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_SIMPLE is not set
# CONFIG_USB_SERIAL_AIRCABLE is not set
# CONFIG_USB_SERIAL_ARK3116 is not set
# CONFIG_USB_SERIAL_BELKIN is not set
# CONFIG_USB_SERIAL_CH341 is not set
# CONFIG_USB_SERIAL_WHITEHEAT is not set
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
# CONFIG_USB_SERIAL_CP210X is not set
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
# CONFIG_USB_SERIAL_EMPEG is not set
# CONFIG_USB_SERIAL_FTDI_SIO is not set
# CONFIG_USB_SERIAL_VISOR is not set
# CONFIG_USB_SERIAL_IPAQ is not set
# CONFIG_USB_SERIAL_IR is not set
# CONFIG_USB_SERIAL_EDGEPORT is not set
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_F81232 is not set
# CONFIG_USB_SERIAL_F8153X is not set
# CONFIG_USB_SERIAL_GARMIN is not set
# CONFIG_USB_SERIAL_IPW is not set
# CONFIG_USB_SERIAL_IUU is not set
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
# CONFIG_USB_SERIAL_KEYSPAN is not set
# CONFIG_USB_SERIAL_KLSI is not set
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
# CONFIG_USB_SERIAL_MCT_U232 is not set
# CONFIG_USB_SERIAL_METRO is not set
# CONFIG_USB_SERIAL_MOS7720 is not set
# CONFIG_USB_SERIAL_MOS7840 is not set
# CONFIG_USB_SERIAL_MXUPORT is not set
# CONFIG_USB_SERIAL_NAVMAN is not set
CONFIG_USB_SERIAL_PL2303=m
# CONFIG_USB_SERIAL_OTI6858 is not set
# CONFIG_USB_SERIAL_QCAUX is not set
# CONFIG_USB_SERIAL_QUALCOMM is not set
# CONFIG_USB_SERIAL_SPCP8X5 is not set
# CONFIG_USB_SERIAL_SAFE is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
# CONFIG_USB_SERIAL_SYMBOL is not set
# CONFIG_USB_SERIAL_TI is not set
# CONFIG_USB_SERIAL_CYBERJACK is not set
# CONFIG_USB_SERIAL_XIRCOM is not set
CONFIG_USB_SERIAL_WWAN=m
CONFIG_USB_SERIAL_OPTION=m
# CONFIG_USB_SERIAL_OMNINET is not set
# CONFIG_USB_SERIAL_OPTICON is not set
# CONFIG_USB_SERIAL_XSENS_MT is not set
# CONFIG_USB_SERIAL_WISHBONE is not set
# CONFIG_USB_SERIAL_SSU100 is not set
# CONFIG_USB_SERIAL_QT2 is not set
# CONFIG_USB_SERIAL_UPD78F0730 is not set
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
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set
# CONFIG_USB_EZUSB_FX2 is not set
# CONFIG_USB_HUB_USB251XB is not set
# CONFIG_USB_HSIC_USB3503 is not set
# CONFIG_USB_HSIC_USB4604 is not set
# CONFIG_USB_LINK_LAYER_TEST is not set

#
# USB Physical Layer drivers
#
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_USB_ISP1301 is not set
# CONFIG_USB_GADGET is not set
# CONFIG_TYPEC is not set
# CONFIG_USB_LED_TRIG is not set
# CONFIG_USB_ULPI_BUS is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y
# CONFIG_LEDS_CLASS_FLASH is not set
# CONFIG_LEDS_BRIGHTNESS_HW_CHANGED is not set

#
# LED drivers
#
# CONFIG_LEDS_APU is not set
# CONFIG_LEDS_LM3530 is not set
# CONFIG_LEDS_LM3642 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_LP3944 is not set
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_LP5562 is not set
# CONFIG_LEDS_LP8501 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA963X is not set
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_INTEL_SS4200 is not set
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_TLC591XX is not set
# CONFIG_LEDS_LM355x is not set

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
# CONFIG_LEDS_BLINKM is not set
# CONFIG_LEDS_MLXCPLD is not set
# CONFIG_LEDS_MLXREG is not set
# CONFIG_LEDS_USER is not set
# CONFIG_LEDS_NIC78BX is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
# CONFIG_LEDS_TRIGGER_DISK is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_CPU is not set
# CONFIG_LEDS_TRIGGER_ACTIVITY is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
# CONFIG_LEDS_TRIGGER_CAMERA is not set
# CONFIG_LEDS_TRIGGER_PANIC is not set
# CONFIG_LEDS_TRIGGER_NETDEV is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC_ATOMIC_SCRUB=y
CONFIG_EDAC_SUPPORT=y
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_MC146818_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
CONFIG_RTC_SYSTOHC=y
CONFIG_RTC_SYSTOHC_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set
CONFIG_RTC_NVMEM=y

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_ABB5ZES3 is not set
# CONFIG_RTC_DRV_ABX80X is not set
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_ISL12022 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF8523 is not set
# CONFIG_RTC_DRV_PCF85063 is not set
# CONFIG_RTC_DRV_PCF85363 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_BQ32K is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8010 is not set
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set
# CONFIG_RTC_DRV_EM3027 is not set
# CONFIG_RTC_DRV_RV8803 is not set

#
# SPI RTC drivers
#
CONFIG_RTC_I2C_AND_SPI=y

#
# SPI and I2C RTC drivers
#
# CONFIG_RTC_DRV_DS3232 is not set
# CONFIG_RTC_DRV_PCF2127 is not set
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1685_FAMILY is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_DS2404 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_MSM6242 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_RP5C01 is not set
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_FTRTC010 is not set

#
# HID Sensor RTC drivers
#
# CONFIG_RTC_DRV_HID_SENSOR_TIME is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_DMA_ENGINE=y
CONFIG_DMA_VIRTUAL_CHANNELS=y
CONFIG_DMA_ACPI=y
# CONFIG_ALTERA_MSGDMA is not set
CONFIG_INTEL_IDMA64=y
# CONFIG_INTEL_IOATDMA is not set
# CONFIG_QCOM_HIDMA_MGMT is not set
# CONFIG_QCOM_HIDMA is not set
# CONFIG_DW_DMAC is not set
# CONFIG_DW_DMAC_PCI is not set

#
# DMA Clients
#
# CONFIG_ASYNC_TX_DMA is not set
# CONFIG_DMATEST is not set

#
# DMABUF options
#
CONFIG_SYNC_FILE=y
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set
CONFIG_IRQ_BYPASS_MANAGER=m
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO_MENU=y
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
# CONFIG_ACER_WIRELESS is not set
# CONFIG_ACERHDF is not set
# CONFIG_ALIENWARE_WMI is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_DELL_SMBIOS is not set
# CONFIG_DELL_WMI_AIO is not set
# CONFIG_DELL_WMI_LED is not set
# CONFIG_DELL_SMO8800 is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_GPD_POCKET_FAN is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WIRELESS is not set
# CONFIG_HP_WMI is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_ASUS_WIRELESS is not set
CONFIG_ACPI_WMI=y
# CONFIG_WMI_BMOF is not set
# CONFIG_INTEL_WMI_THUNDERBOLT is not set
CONFIG_MSI_WMI=y
# CONFIG_PEAQ_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_TOSHIBA_HAPS is not set
# CONFIG_TOSHIBA_WMI is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_HID_EVENT is not set
# CONFIG_INTEL_VBTN is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_INTEL_PMC_CORE is not set
# CONFIG_IBM_RTL is not set
# CONFIG_SAMSUNG_LAPTOP is not set
# CONFIG_MXM_WMI is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set
# CONFIG_INTEL_PMC_IPC is not set
# CONFIG_SURFACE_PRO3_BUTTON is not set
# CONFIG_INTEL_PUNIT_IPC is not set
# CONFIG_MLX_PLATFORM is not set
CONFIG_INTEL_TURBO_MAX_3=y
CONFIG_PMC_ATOM=y
# CONFIG_CHROME_PLATFORMS is not set
# CONFIG_MELLANOX_PLATFORM is not set
CONFIG_CLKDEV_LOOKUP=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y

#
# Common Clock Framework
#
# CONFIG_COMMON_CLK_SI5351 is not set
# CONFIG_COMMON_CLK_SI544 is not set
# CONFIG_COMMON_CLK_CDCE706 is not set
# CONFIG_COMMON_CLK_CS2000_CP is not set
# CONFIG_HWSPINLOCK is not set

#
# Clock Source drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
CONFIG_MAILBOX=y
CONFIG_PCC=y
# CONFIG_ALTERA_MBOX is not set
CONFIG_IOMMU_SUPPORT=y

#
# Generic IOMMU Pagetable Support
#
# CONFIG_AMD_IOMMU is not set
CONFIG_DMAR_TABLE=y
# CONFIG_INTEL_IOMMU is not set
CONFIG_IRQ_REMAP=y

#
# Remoteproc drivers
#
# CONFIG_REMOTEPROC is not set

#
# Rpmsg drivers
#
# CONFIG_RPMSG_QCOM_GLINK_RPM is not set
# CONFIG_RPMSG_VIRTIO is not set
# CONFIG_SOUNDWIRE is not set

#
# SOC (System On Chip) specific Drivers
#

#
# Amlogic SoC drivers
#

#
# Broadcom SoC drivers
#

#
# i.MX SoC drivers
#

#
# Qualcomm SoC drivers
#
# CONFIG_SOC_TI is not set

#
# Xilinx SoC drivers
#
# CONFIG_XILINX_VCU is not set
# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set

#
# IRQ chip support
#
CONFIG_ARM_GIC_MAX_NR=1
# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set
# CONFIG_FMC is not set

#
# PHY Subsystem
#
# CONFIG_GENERIC_PHY is not set
# CONFIG_BCM_KONA_USB2_PHY is not set
# CONFIG_PHY_PXA_28NM_HSIC is not set
# CONFIG_PHY_PXA_28NM_USB2 is not set
# CONFIG_POWERCAP is not set
# CONFIG_MCB is not set

#
# Performance monitor support
#
CONFIG_RAS=y
# CONFIG_THUNDERBOLT is not set

#
# Android
#
# CONFIG_ANDROID is not set
# CONFIG_LIBNVDIMM is not set
# CONFIG_DAX is not set
CONFIG_NVMEM=y

#
# HW tracing support
#
# CONFIG_STM is not set
# CONFIG_INTEL_TH is not set
# CONFIG_FPGA is not set
# CONFIG_UNISYS_VISORBUS is not set
# CONFIG_SIOX is not set
# CONFIG_SLIMBUS is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_FIRMWARE_MEMMAP is not set
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=y
# CONFIG_DMIID is not set
# CONFIG_DMI_SYSFS is not set
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_FW_CFG_SYSFS is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# EFI (Extensible Firmware Interface) Support
#
# CONFIG_EFI_VARS is not set
CONFIG_EFI_ESRT=y
# CONFIG_EFI_FAKE_MEMMAP is not set
CONFIG_EFI_RUNTIME_WRAPPERS=y
# CONFIG_EFI_CAPSULE_LOADER is not set
# CONFIG_EFI_TEST is not set

#
# Tegra firmware driver
#

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_FS_IOMAP=y
# CONFIG_EXT2_FS is not set
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_USE_FOR_EXT2=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
CONFIG_EXT4_ENCRYPTION=y
CONFIG_EXT4_FS_ENCRYPTION=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
CONFIG_BTRFS_FS=y
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
# CONFIG_BTRFS_ASSERT is not set
# CONFIG_BTRFS_FS_REF_VERIFY is not set
# CONFIG_NILFS2_FS is not set
# CONFIG_F2FS_FS is not set
# CONFIG_FS_DAX is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
# CONFIG_EXPORTFS_BLOCK_OPS is not set
CONFIG_FILE_LOCKING=y
# CONFIG_MANDATORY_FILE_LOCKING is not set
CONFIG_FS_ENCRYPTION=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
# CONFIG_QUOTA is not set
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=m
# CONFIG_CUSE is not set
# CONFIG_OVERLAY_FS is not set

#
# Caches
#
# CONFIG_FSCACHE is not set

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
CONFIG_FAT_DEFAULT_UTF8=y
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_PROC_CHILDREN=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
# CONFIG_CONFIGFS_FS is not set
CONFIG_EFIVAR_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ORANGEFS_FS is not set
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_CRAMFS is not set
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_QNX6FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_PSTORE is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=m
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
CONFIG_NLS_CODEPAGE_1250=y
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=m
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
# CONFIG_NLS_MAC_CYRILLIC is not set
# CONFIG_NLS_MAC_GAELIC is not set
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
# CONFIG_NLS_MAC_ROMANIAN is not set
# CONFIG_NLS_MAC_TURKISH is not set
CONFIG_NLS_UTF8=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_CONSOLE_LOGLEVEL_DEFAULT=7
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
# CONFIG_BOOT_PRINTK_DELAY is not set

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
# CONFIG_PAGE_OWNER is not set
# CONFIG_DEBUG_FS is not set
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_SECTION_MISMATCH_WARN_ONLY=y
CONFIG_STACK_VALIDATION=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
# CONFIG_MAGIC_SYSRQ_SERIAL is not set
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_PAGE_EXTENSION is not set
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_PAGE_POISONING is not set
# CONFIG_DEBUG_RODATA_TEST is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_VM is not set
CONFIG_ARCH_HAS_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KASAN=y
# CONFIG_KASAN is not set
CONFIG_ARCH_HAS_KCOV=y
# CONFIG_KCOV is not set
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
# CONFIG_SOFTLOCKUP_DETECTOR is not set
CONFIG_HARDLOCKUP_CHECK_TIMESTAMP=y
# CONFIG_HARDLOCKUP_DETECTOR is not set
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_WQ_WATCHDOG is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_PANIC_TIMEOUT=0
# CONFIG_SCHED_DEBUG is not set
CONFIG_SCHED_INFO=y
# CONFIG_SCHEDSTATS is not set
# CONFIG_SCHED_STACK_END_CHECK is not set
# CONFIG_DEBUG_TIMEKEEPING is not set
# CONFIG_DEBUG_PREEMPT is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_LOCK_DEBUGGING_SUPPORT=y
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
# CONFIG_DEBUG_RWSEMS is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_DEBUG_ATOMIC_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_LOCK_TORTURE_TEST is not set
# CONFIG_WW_MUTEX_SELFTEST is not set
CONFIG_STACKTRACE=y
CONFIG_WARN_ALL_UNSEEDED_RANDOM=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_PI_LIST is not set
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
# CONFIG_RCU_PERF_TEST is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_TRACE is not set
# CONFIG_RCU_EQS_DEBUG is not set
# CONFIG_DEBUG_WQ_FORCE_RR_CPU is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_CPU_HOTPLUG_STATE_CONTROL is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DMA_API_DEBUG is not set
CONFIG_RUNTIME_TESTING_MENU=y
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_TEST_SORT is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_PERCPU_TEST is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_TEST_HEXDUMP is not set
# CONFIG_TEST_STRING_HELPERS is not set
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_TEST_PRINTF is not set
# CONFIG_TEST_BITMAP is not set
# CONFIG_TEST_UUID is not set
# CONFIG_TEST_RHASHTABLE is not set
# CONFIG_TEST_HASH is not set
# CONFIG_TEST_LKM is not set
# CONFIG_TEST_USER_COPY is not set
# CONFIG_TEST_BPF is not set
# CONFIG_FIND_BIT_BENCHMARK is not set
# CONFIG_TEST_FIRMWARE is not set
# CONFIG_TEST_SYSCTL is not set
# CONFIG_TEST_UDELAY is not set
# CONFIG_TEST_STATIC_KEYS is not set
# CONFIG_TEST_KMOD is not set
# CONFIG_MEMTEST is not set
CONFIG_BUG_ON_DATA_CORRUPTION=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_ARCH_HAS_UBSAN_SANITIZE_ALL=y
# CONFIG_UBSAN is not set
CONFIG_ARCH_HAS_DEVMEM_IS_ALLOWED=y
CONFIG_STRICT_DEVMEM=y
# CONFIG_IO_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_EARLY_PRINTK_EFI=y
# CONFIG_EARLY_PRINTK_USB_XDBC is not set
CONFIG_X86_PTDUMP_CORE=y
# CONFIG_X86_PTDUMP is not set
# CONFIG_EFI_PGT_DUMP is not set
CONFIG_DEBUG_WX=y
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
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
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_ENTRY is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_FPU is not set
# CONFIG_PUNIT_ATOM_DEBUG is not set
CONFIG_UNWINDER_ORC=y
# CONFIG_UNWINDER_FRAME_POINTER is not set
# CONFIG_UNWINDER_GUESS is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_KEYS_COMPAT=y
# CONFIG_PERSISTENT_KEYRINGS is not set
# CONFIG_BIG_KEYS is not set
# CONFIG_ENCRYPTED_KEYS is not set
# CONFIG_KEY_DH_OPERATIONS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
# CONFIG_SECURITYFS is not set
# CONFIG_SECURITY_NETWORK is not set
CONFIG_PAGE_TABLE_ISOLATION=y
# CONFIG_SECURITY_PATH is not set
CONFIG_HAVE_HARDENED_USERCOPY_ALLOCATOR=y
CONFIG_HARDENED_USERCOPY=y
CONFIG_HARDENED_USERCOPY_FALLBACK=y
# CONFIG_HARDENED_USERCOPY_PAGESPAN is not set
CONFIG_FORTIFY_SOURCE=y
# CONFIG_STATIC_USERMODEHELPER is not set
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_LOADPIN is not set
CONFIG_SECURITY_YAMA=y
# CONFIG_INTEGRITY is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_RNG_DEFAULT=y
CONFIG_CRYPTO_AKCIPHER2=y
CONFIG_CRYPTO_AKCIPHER=y
CONFIG_CRYPTO_KPP2=y
CONFIG_CRYPTO_ACOMP2=y
CONFIG_CRYPTO_RSA=y
# CONFIG_CRYPTO_DH is not set
# CONFIG_CRYPTO_ECDH is not set
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_NULL2=y
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
# CONFIG_CRYPTO_MCRYPTD is not set
# CONFIG_CRYPTO_AUTHENC is not set
# CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_SIMD=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=y
# CONFIG_CRYPTO_CHACHA20POLY1305 is not set
CONFIG_CRYPTO_SEQIV=y
# CONFIG_CRYPTO_ECHAINIV is not set

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
# CONFIG_CRYPTO_CFB is not set
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=y
# CONFIG_CRYPTO_KEYWRAP is not set

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
# CONFIG_CRYPTO_CRC32 is not set
CONFIG_CRYPTO_CRC32_PCLMUL=y
# CONFIG_CRYPTO_CRCT10DIF is not set
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_POLY1305 is not set
# CONFIG_CRYPTO_POLY1305_X86_64 is not set
# CONFIG_CRYPTO_MD4 is not set
# CONFIG_CRYPTO_MD5 is not set
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
# CONFIG_CRYPTO_SHA1 is not set
# CONFIG_CRYPTO_SHA1_SSSE3 is not set
# CONFIG_CRYPTO_SHA256_SSSE3 is not set
# CONFIG_CRYPTO_SHA512_SSSE3 is not set
# CONFIG_CRYPTO_SHA1_MB is not set
# CONFIG_CRYPTO_SHA256_MB is not set
# CONFIG_CRYPTO_SHA512_MB is not set
CONFIG_CRYPTO_SHA256=y
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_SHA3 is not set
# CONFIG_CRYPTO_SM3 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_TI is not set
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_BLOWFISH_X86_64 is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAMELLIA_X86_64 is not set
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64 is not set
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64 is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST5_AVX_X86_64 is not set
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_CAST6_AVX_X86_64 is not set
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_DES3_EDE_X86_64 is not set
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
# CONFIG_CRYPTO_CHACHA20 is not set
# CONFIG_CRYPTO_CHACHA20_X86_64 is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
# CONFIG_CRYPTO_SERPENT_AVX_X86_64 is not set
# CONFIG_CRYPTO_SERPENT_AVX2_X86_64 is not set
# CONFIG_CRYPTO_SM4 is not set
CONFIG_CRYPTO_SPECK=y
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_X86_64 is not set
# CONFIG_CRYPTO_TWOFISH_X86_64_3WAY is not set
# CONFIG_CRYPTO_TWOFISH_AVX_X86_64 is not set

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
CONFIG_CRYPTO_LZO=y
# CONFIG_CRYPTO_842 is not set
# CONFIG_CRYPTO_LZ4 is not set
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_DRBG_MENU=y
CONFIG_CRYPTO_DRBG_HMAC=y
# CONFIG_CRYPTO_DRBG_HASH is not set
# CONFIG_CRYPTO_DRBG_CTR is not set
CONFIG_CRYPTO_DRBG=y
CONFIG_CRYPTO_JITTERENTROPY=y
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_USER_API_RNG is not set
# CONFIG_CRYPTO_USER_API_AEAD is not set
CONFIG_CRYPTO_HASH_INFO=y
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_PKCS7_MESSAGE_PARSER=y
# CONFIG_PKCS7_TEST_KEY is not set
# CONFIG_SIGNED_PE_FILE_VERIFICATION is not set

#
# Certificates for signature checking
#
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_SYSTEM_TRUSTED_KEYS=""
# CONFIG_SYSTEM_EXTRA_CERTIFICATE is not set
# CONFIG_SECONDARY_TRUSTED_KEYRING is not set
# CONFIG_SYSTEM_BLACKLIST_KEYRING is not set
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQFD=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_KVM_VFIO=y
CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT=y
CONFIG_KVM_COMPAT=y
CONFIG_HAVE_KVM_IRQ_BYPASS=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
# CONFIG_KVM_AMD is not set
# CONFIG_VHOST_NET is not set
# CONFIG_VHOST_CROSS_ENDIAN_LEGACY is not set

#
# Library routines
#
CONFIG_RAID6_PQ=y
CONFIG_BITREVERSE=y
CONFIG_RATIONAL=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
# CONFIG_CRC_CCITT is not set
CONFIG_CRC16=y
# CONFIG_CRC_T10DIF is not set
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC4 is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
CONFIG_XXHASH=y
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_ZSTD_COMPRESS=y
CONFIG_ZSTD_DECOMPRESS=y
# CONFIG_XZ_DEC is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_INTERVAL_TREE=y
CONFIG_RADIX_TREE_MULTIORDER=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_SGL_ALLOC=y
CONFIG_DMA_DIRECT_OPS=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_GLOB=y
# CONFIG_GLOB_SELFTEST is not set
CONFIG_NLATTR=y
CONFIG_CLZ_TAB=y
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set
# CONFIG_IRQ_POLL is not set
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y
CONFIG_UCS2_STRING=y
CONFIG_FONT_SUPPORT=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_SG_POOL=y
CONFIG_ARCH_HAS_SG_CHAIN=y
CONFIG_ARCH_HAS_PMEM_API=y
CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE=y
CONFIG_SBITMAP=y
# CONFIG_STRING_SELFTEST is not set

--liOOAslEiF7prFVr--
