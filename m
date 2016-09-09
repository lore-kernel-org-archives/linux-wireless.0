Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35281 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751296AbcIIOcH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Sep 2016 10:32:07 -0400
Received: by mail-wm0-f65.google.com with SMTP id a6so3025677wmc.2
        for <linux-wireless@vger.kernel.org>; Fri, 09 Sep 2016 07:32:05 -0700 (PDT)
From: Valerio Passini <valerio.passini@unicam.it>
To: Joerg Roedel <joro@8bytes.org>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Adam Morrison <mad@cs.technion.ac.il>,
        linux-wireless@vger.kernel.org,
        Omer Peleg <omer@cs.technion.ac.il>,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: Re: Stability connection problems in ath9k kernel 4.7
Date: Fri, 09 Sep 2016 16:32:00 +0200
Message-ID: <3910431.yb7VZHRpoX@automatix> (sfid-20160909_163215_571204_DC12657C)
In-Reply-To: <20160909083832.GX1437@8bytes.org>
References: <1798564.U2X6r5Zons@automatix> <CAC6K2=_Hdkgc_6igoC59J_Cn9=bdye827zbEK7PWtZY6ebh-6Q@mail.gmail.com> <20160909083832.GX1437@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On venerd=EC 9 settembre 2016 10:38:32 CEST Joerg Roedel wrote:
> Hi Valerio,
>=20
> On Thu, Sep 08, 2016 at 09:07:56PM +0200, Valerio Passini wrote:
> > I'm hoping having done it right and I can try your first suggestion, bu=
t I
> > really cannot solve this problem by myself: sorry, I have no capabiliti=
es
> > in programming in any known and unknown computer language. Surely, I can
> > test all the patches you want and report the results but this is the be=
st
> > I can do. Best regards
>=20
> Can you please send me the full dmesg after boot? The Intel-IOMMU is not
> enabled by default, so I want to check if it is either enabled by
> kernel-config or kernel command-line.
>=20
> Thanks,
>=20
> 	Joerg

Hi Joerg,

It is enabled by kernel config. Indeed, unchecking that option makes the=20
problem disappearing.

Valerio

=46ull dmesg as you asked me.
[    0.000000] microcode: microcode updated early to revision 0x20, date =
=3D=20
2016-03-16
[    0.000000] Linux version 4.7.3 (valerio@Automatix) (gcc version 6.2.0=20
20160901 (Debian 6.2.0-3) ) #1 SMP PREEMPT Fri Sep 9 16:15:07 CEST 2016
[    0.000000] Command line: BOOT_IMAGE=3D/boot/vmlinuz-4.7.3=20
root=3DUUID=3D917286ea-e4a0-4a3e-9307-102636ba2a20 ro quiet acpi_osi=3D
[    0.000000] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
[    0.000000] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point=
=20
registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
[    0.000000] x86/fpu: Enabled xstate features 0x7, context size is 832=20
bytes, using 'standard' format.
[    0.000000] x86/fpu: Using 'eager' FPU context switches.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000057fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000058000-0x0000000000058fff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000059000-0x000000000009dfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009e000-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000b5df7fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000b5df8000-0x00000000b5dfefff] ACPI =
NVS
[    0.000000] BIOS-e820: [mem 0x00000000b5dff000-0x00000000b6719fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000b671a000-0x00000000b69b7fff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000b69b8000-0x00000000c6045fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000c6046000-0x00000000c624ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000c6250000-0x00000000c6402fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000c6403000-0x00000000c6b08fff] ACPI =
NVS
[    0.000000] BIOS-e820: [mem 0x00000000c6b09000-0x00000000c6f59fff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000c6f5a000-0x00000000c6ffefff] type =
20
[    0.000000] BIOS-e820: [mem 0x00000000c6fff000-0x00000000c6ffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000c7c00000-0x00000000cfdfffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed03fff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000022f1fffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] efi: EFI v2.31 by American Megatrends
[    0.000000] efi:  ESRT=3D0xc6f58798  ACPI 2.0=3D0xc648b000  ACPI=3D0xc64=
8b000 =20
SMBIOS=3D0xc6f58398=20
[    0.000000] esrt: Reserving ESRT space from 0x00000000c6f58798 to=20
0x00000000c6f587d0.
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: ASUSTeK COMPUTER INC. N551JW/N551JW, BIOS N551JW.207=20
08/03/2015
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x22f200 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask 7E00000000 write-back
[    0.000000]   1 base 0200000000 mask 7FE0000000 write-back
[    0.000000]   2 base 0220000000 mask 7FF0000000 write-back
[    0.000000]   3 base 00E0000000 mask 7FE0000000 uncachable
[    0.000000]   4 base 00D0000000 mask 7FF0000000 uncachable
[    0.000000]   5 base 00C8000000 mask 7FF8000000 uncachable
[    0.000000]   6 base 00C7C00000 mask 7FFFC00000 uncachable
[    0.000000]   7 base 022F800000 mask 7FFF800000 uncachable
[    0.000000]   8 base 022F400000 mask 7FFFC00000 uncachable
[    0.000000]   9 base 022F200000 mask 7FFFE00000 uncachable
[    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- WT=
 =20
[    0.000000] e820: update [mem 0xc7c00000-0xffffffff] usable =3D=3D> rese=
rved
[    0.000000] e820: last_pfn =3D 0xc7000 max_arch_pfn =3D 0x400000000
[    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] BRK [0x01a02000, 0x01a02fff] PGTABLE
[    0.000000] BRK [0x01a03000, 0x01a03fff] PGTABLE
[    0.000000] BRK [0x01a04000, 0x01a04fff] PGTABLE
[    0.000000] BRK [0x01a05000, 0x01a05fff] PGTABLE
[    0.000000] BRK [0x01a06000, 0x01a06fff] PGTABLE
[    0.000000] BRK [0x01a07000, 0x01a07fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x37424000-0x37a09fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000C648B000 000024 (v02 _ASUS_)
[    0.000000] ACPI: XSDT 0x00000000C648B098 0000BC (v01 _ASUS_ Notebook=20
01072009 AMI  00010013)
[    0.000000] ACPI: FACP 0x00000000C649EF40 00010C (v05 _ASUS_ Notebook=20
01072009 AMI  00010013)
[    0.000000] ACPI: DSDT 0x00000000C648B270 013CC9 (v02 _ASUS_ Notebook=20
00000012 INTL 20120711)
[    0.000000] ACPI: FACS 0x00000000C6B06F80 000040
[    0.000000] ACPI: APIC 0x00000000C649F050 000092 (v03 _ASUS_ Notebook=20
01072009 AMI  00010013)
[    0.000000] ACPI: FPDT 0x00000000C649F0E8 000044 (v01 _ASUS_ Notebook=20
01072009 AMI  00010013)
[    0.000000] ACPI: ECDT 0x00000000C649F130 0000C1 (v01 _ASUS_ Notebook=20
01072009 AMI. 00000005)
[    0.000000] ACPI: SSDT 0x00000000C649F1F8 00019D (v01 Intel  zpodd   =20
00001000 INTL 20120711)
[    0.000000] ACPI: SSDT 0x00000000C649F398 000539 (v01 PmRef  Cpu0Ist =20
00003000 INTL 20120711)
[    0.000000] ACPI: SSDT 0x00000000C649F8D8 000AD8 (v01 PmRef  CpuPm   =20
00003000 INTL 20120711)
[    0.000000] ACPI: MCFG 0x00000000C64A03B0 00003C (v01 _ASUS_ Notebook=20
01072009 MSFT 00000097)
[    0.000000] ACPI: HPET 0x00000000C64A03F0 000038 (v01 _ASUS_ Notebook=20
01072009 AMI. 00000005)
[    0.000000] ACPI: SSDT 0x00000000C64A0428 000298 (v01 SataRe SataTabl=20
00001000 INTL 20120711)
[    0.000000] ACPI: SSDT 0x00000000C64A06C0 004541 (v01 SaSsdt SaSsdt  =20
00003000 INTL 20091112)
[    0.000000] ACPI: SSDT 0x00000000C64A4C08 001A55 (v01 SgRef  SgPeg   =20
00001000 INTL 20120711)
[    0.000000] ACPI: SSDT 0x00000000C64A6660 000393 (v01 CppcTa CppcTabl=20
00001000 INTL 20120711)
[    0.000000] ACPI: PCCT 0x00000000C64A69F8 00006E (v05 PcctTa PcctTabl=20
00001000 INTL 20120711)
[    0.000000] ACPI: SSDT 0x00000000C64A6A68 000AC4 (v01 Cpc_Ta Cpc_Tabl=20
00001000 INTL 20120711)
[    0.000000] ACPI: BGRT 0x00000000C64A7530 000038 (v00 _ASUS_ Notebook=20
01072009 ASUS 00010013)
[    0.000000] ACPI: DMAR 0x00000000C64A7568 0000A8 (v01 INTEL  HSW     =20
00000001 INTL 00000001)
[    0.000000] ACPI: SSDT 0x00000000C64A7610 001A58 (v01 OptRef OptTabl =20
00001000 INTL 20120711)
[    0.000000] ACPI: MSDM 0x00000000C624EE18 000055 (v03 _ASUS_ Notebook=20
00000000 ASUS 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000022f1fffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x22f1f5000-0x22f1f8fff]
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.000000]   Normal   [mem 0x0000000100000000-0x000000022f1fffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x0000000000057fff]
[    0.000000]   node   0: [mem 0x0000000000059000-0x000000000009dfff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x00000000b5df7fff]
[    0.000000]   node   0: [mem 0x00000000b5dff000-0x00000000b6719fff]
[    0.000000]   node   0: [mem 0x00000000b69b8000-0x00000000c6045fff]
[    0.000000]   node   0: [mem 0x00000000c6250000-0x00000000c6402fff]
[    0.000000]   node   0: [mem 0x00000000c6fff000-0x00000000c6ffffff]
[    0.000000]   node   0: [mem 0x0000000100000000-0x000000022f1fffff]
[    0.000000] Initmem setup node 0 [mem=20
0x0000000000001000-0x000000022f1fffff]
[    0.000000] On node 0 totalpages: 2052337
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 22 pages reserved
[    0.000000]   DMA zone: 3996 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 12606 pages used for memmap
[    0.000000]   DMA32 zone: 806741 pages, LIFO batch:31
[    0.000000]   Normal zone: 19400 pages used for memmap
[    0.000000]   Normal zone: 1241600 pages, LIFO batch:31
[    0.000000] Reserving Intel graphics stolen memory at 0xc7e00000-0xcfdff=
fff
[    0.000000] ACPI: PM-Timer IO Port: 0x1808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x00058000-0x00058fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xb5df8000-0xb5dfefff]
[    0.000000] PM: Registered nosave memory: [mem 0xb671a000-0xb69b7fff]
[    0.000000] PM: Registered nosave memory: [mem 0xc6046000-0xc624ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xc6403000-0xc6b08fff]
[    0.000000] PM: Registered nosave memory: [mem 0xc6b09000-0xc6f59fff]
[    0.000000] PM: Registered nosave memory: [mem 0xc6f5a000-0xc6ffefff]
[    0.000000] PM: Registered nosave memory: [mem 0xc7000000-0xc7bfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xc7c00000-0xcfdfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xcfe00000-0xf7ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf8000000-0xfbffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfc000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfecfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed00000-0xfed03fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed04000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] e820: [mem 0xcfe00000-0xf7ffffff] available for PCI devices
[    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles:=20
0xffffffff, max_idle_ns: 1910969940391419 ns
[    0.000000] setup_percpu: NR_CPUS:16 nr_cpumask_bits:16 nr_cpu_ids:8=20
nr_node_ids:1
[    0.000000] percpu: Embedded 31 pages/cpu @ffff88022ee00000 s86936 r8192=
=20
d31848 u262144
[    0.000000] pcpu-alloc: s86936 r8192 d31848 u262144 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7=20
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l=20
pages: 2020245
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=3D/boot/vmlinuz-4.7.3=20
root=3DUUID=3D917286ea-e4a0-4a3e-9307-102636ba2a20 ro quiet acpi_osi=3D
[    0.000000] ACPI: _OSI method disabled
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Memory: 7953608K/8209348K available (4657K kernel code, 585K=
=20
rwdata, 1600K rodata, 868K init, 568K bss, 255740K reserved, 0K cma-reserve=
d)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D8, N=
odes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	Build-time adjustment of leaf fanout to 64.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=3D16 to nr_cpu_ids=3D8.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D64, nr_cpu_ids=
=3D8
[    0.000000] NR_IRQS:4352 nr_irqs:488 16
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff,=
=20
max_idle_ns: 133484882848 ns
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] tsc: Detected 2594.026 MHz processor
[    0.000002] Calibrating delay loop (skipped), value calculated using tim=
er=20
frequency.. 5188.05 BogoMIPS (lpj=3D2594026)
[    0.000003] pid_max: default: 32768 minimum: 301
[    0.000006] ACPI: Core revision 20160422
[    0.012404] ACPI: 10 ACPI AML tables successfully acquired and loaded

[    0.013195] Dentry cache hash table entries: 1048576 (order: 11, 8388608=
=20
bytes)
[    0.014822] Inode-cache hash table entries: 524288 (order: 10, 4194304=20
bytes)
[    0.015697] Mount-cache hash table entries: 16384 (order: 5, 131072 byte=
s)
[    0.015702] Mountpoint-cache hash table entries: 16384 (order: 5, 131072=
=20
bytes)
[    0.015875] CPU: Physical Processor ID: 0
[    0.015876] CPU: Processor Core ID: 0
[    0.015879] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.015879] ENERGY_PERF_BIAS: View and update with=20
x86_energy_perf_policy(8)
[    0.015882] mce: CPU supports 9 MCE banks
[    0.015889] CPU0: Thermal monitoring enabled (TM1)
[    0.015899] process: using mwait in idle threads
[    0.015902] Last level iTLB entries: 4KB 1024, 2MB 1024, 4MB 1024
[    0.015902] Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 1024, 1GB 4
[    0.016145] Freeing SMP alternatives memory: 20K (ffffffff8196d000 -=20
ffffffff81972000)
[    0.017770] smpboot: Max logical packages: 2
[    0.017771] smpboot: APIC(0) Converting physical 0 to logical package 0
[    0.018112] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D0 pin2=3D0
[    0.028116] TSC deadline timer enabled
[    0.028118] smpboot: CPU0: Intel(R) Core(TM) i7-4720HQ CPU @ 2.60GHz=20
(family: 0x6, model: 0x3c, stepping: 0x3)
[    0.028121] Performance Events: PEBS fmt2+, 16-deep LBR, Haswell events,=
=20
full-width counters, Intel PMU driver.
[    0.028135] ... version:                3
[    0.028135] ... bit width:              48
[    0.028136] ... generic registers:      4
[    0.028136] ... value mask:             0000ffffffffffff
[    0.028137] ... max period:             0000ffffffffffff
[    0.028137] ... fixed-purpose events:   3
[    0.028138] ... event mask:             000000070000000f
[    0.039191] x86: Booting SMP configuration:
[    0.039192] .... node  #0, CPUs:      #1 #2 #3 #4 #5 #6 #7
[    0.500594] x86: Booted up 1 node, 8 CPUs
[    0.500597] smpboot: Total of 8 processors activated (41524.66 BogoMIPS)
[    0.505481] devtmpfs: initialized
[    0.505517] x86/mm: Memory block size: 128MB
[    0.507136] PM: Registering ACPI NVS region [mem 0xb5df8000-0xb5dfefff]=
=20
(28672 bytes)
[    0.507137] PM: Registering ACPI NVS region [mem 0xc6403000-0xc6b08fff]=
=20
(7364608 bytes)
[    0.507224] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xfffffff=
f,=20
max_idle_ns: 1911260446275000 ns
[    0.507244] pinctrl core: initialized pinctrl subsystem
[    0.507359] NET: Registered protocol family 16
[    0.512295] cpuidle: using governor ladder
[    0.518312] cpuidle: using governor menu
[    0.518330] ACPI FADT declares the system doesn't support PCIe ASPM, so=
=20
disable it
[    0.518331] ACPI: bus type PCI registered
[    0.518371] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem=20
0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.518373] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.518378] pmd_set_huge: Cannot satisfy [mem 0xf8000000-0xf8200000] wit=
h a=20
huge-page mapping due to MTRR override.
[    0.518414] PCI: Using configuration type 1 for base access
[    0.518431] core: PMU erratum BJ122, BV98, HSD29 worked around, HT is on
[    0.524396] HugeTLB registered 1 GB page size, pre-allocated 0 pages
[    0.524397] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.524529] ACPI: Added _OSI(Module Device)
[    0.524530] ACPI: Added _OSI(Processor Device)
[    0.524531] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.524532] ACPI: Added _OSI(Processor Aggregator Device)
[    0.524535] ACPI : EC: EC description table is found, configuring boot EC
[    0.524536] ACPI : EC: EC started
[    0.525621] ACPI: Executed 2 blocks of module-level executable AML code
[    0.531009] ACPI: Dynamic OEM Table Load:
[    0.531014] ACPI: SSDT 0xFFFF8802250D0C00 0003D3 (v01 PmRef  Cpu0Cst =20
00003001 INTL 20120711)
[    0.531501] ACPI: Dynamic OEM Table Load:
[    0.531504] ACPI: SSDT 0xFFFF8802250D8800 0005AA (v01 PmRef  ApIst   =20
00003000 INTL 20120711)
[    0.532011] ACPI: Dynamic OEM Table Load:
[    0.532014] ACPI: SSDT 0xFFFF8802250A0E00 000119 (v01 PmRef  ApCst   =20
00003000 INTL 20120711)
[    0.533156] ACPI: Interpreter enabled
[    0.533176] ACPI: (supports S0 S3 S4 S5)
[    0.533176] ACPI: Using IOAPIC for interrupt routing
[    0.533191] PCI: Using host bridge windows from ACPI; if necessary, use=
=20
"pci=3Dnocrs" and report a bug
[    0.536082] ACPI: Power Resource [PG00] (on)
[    0.538302] ACPI Error: [_OSI] Namespace lookup failure, AE_NOT_FOUND=20
(20160422/psargs-359)
[    0.538305] ACPI Error: Method parse/execution failed [\_SB.BTKL._STA]=20
(Node ffff880226442618), AE_NOT_FOUND (20160422/psparse-542)
[    0.538315] ACPI Error: [_OSI] Namespace lookup failure, AE_NOT_FOUND=20
(20160422/psargs-359)
[    0.538317] ACPI Error: Method parse/execution failed [\_SB.BTKL._STA]=20
(Node ffff880226442618), AE_NOT_FOUND (20160422/psparse-542)
[    0.539060] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    0.539063] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM Cloc=
kPM=20
Segments MSI]
[    0.539400] acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug PME AER=
=20
PCIeCapability]
[    0.539401] acpi PNP0A08:00: FADT indicates ASPM is unsupported, using B=
IOS=20
configuration
[    0.539500] PCI host bridge to bus 0000:00
[    0.539502] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
[    0.539503] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    0.539504] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f=20
window]
[    0.539504] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000c3ff=
f=20
window]
[    0.539505] pci_bus 0000:00: root bus resource [mem 0x000c4000-0x000c7ff=
f=20
window]
[    0.539506] pci_bus 0000:00: root bus resource [mem 0x000c8000-0x000cbff=
f=20
window]
[    0.539507] pci_bus 0000:00: root bus resource [mem 0x000cc000-0x000cfff=
f=20
window]
[    0.539508] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3ff=
f=20
window]
[    0.539508] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7ff=
f=20
window]
[    0.539509] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbff=
f=20
window]
[    0.539510] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dfff=
f=20
window]
[    0.539511] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3ff=
f=20
window]
[    0.539511] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7ff=
f=20
window]
[    0.539512] pci_bus 0000:00: root bus resource [mem 0x000e8000-0x000ebff=
f=20
window]
[    0.539513] pci_bus 0000:00: root bus resource [mem 0x000ec000-0x000efff=
f=20
window]
[    0.539514] pci_bus 0000:00: root bus resource [mem 0xcfe00000-0xfeaffff=
f=20
window]
[    0.539515] pci_bus 0000:00: root bus resource [bus 00-3e]
[    0.539520] pci 0000:00:00.0: [8086:0c04] type 00 class 0x060000
[    0.539575] pci 0000:00:01.0: [8086:0c01] type 01 class 0x060400
[    0.539599] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.539646] pci 0000:00:01.0: System wakeup disabled by ACPI
[    0.539670] pci 0000:00:02.0: [8086:0416] type 00 class 0x030000
[    0.539676] pci 0000:00:02.0: reg 0x10: [mem 0xf7400000-0xf77fffff 64bit]
[    0.539681] pci 0000:00:02.0: reg 0x18: [mem 0xd0000000-0xdfffffff 64bit=
=20
pref]
[    0.539683] pci 0000:00:02.0: reg 0x20: [io  0xf000-0xf03f]
[    0.539731] pci 0000:00:03.0: [8086:0c0c] type 00 class 0x040300
[    0.539737] pci 0000:00:03.0: reg 0x10: [mem 0xf7a14000-0xf7a17fff 64bit]
[    0.539808] pci 0000:00:14.0: [8086:8c31] type 00 class 0x0c0330
[    0.539822] pci 0000:00:14.0: reg 0x10: [mem 0xf7a00000-0xf7a0ffff 64bit]
[    0.539872] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.539895] pci 0000:00:14.0: System wakeup disabled by ACPI
[    0.539918] pci 0000:00:16.0: [8086:8c3a] type 00 class 0x078000
[    0.539932] pci 0000:00:16.0: reg 0x10: [mem 0xf7a1c000-0xf7a1c00f 64bit]
[    0.539986] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.540036] pci 0000:00:1b.0: [8086:8c20] type 00 class 0x040300
[    0.540049] pci 0000:00:1b.0: reg 0x10: [mem 0xf7a10000-0xf7a13fff 64bit]
[    0.540106] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.540132] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.540154] pci 0000:00:1c.0: [8086:8c10] type 01 class 0x060400
[    0.540207] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.540221] pci 0000:00:1c.0: Enabling MPC IRBNCE
[    0.540223] pci 0000:00:1c.0: Intel PCH root port ACS workaround enabled
[    0.540260] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.540282] pci 0000:00:1c.1: [8086:8c12] type 01 class 0x060400
[    0.540335] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.540348] pci 0000:00:1c.1: Enabling MPC IRBNCE
[    0.540352] pci 0000:00:1c.1: Intel PCH root port ACS workaround enabled
[    0.540408] pci 0000:00:1c.2: [8086:8c14] type 01 class 0x060400
[    0.540462] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.540474] pci 0000:00:1c.2: Enabling MPC IRBNCE
[    0.540477] pci 0000:00:1c.2: Intel PCH root port ACS workaround enabled
[    0.540510] pci 0000:00:1c.2: System wakeup disabled by ACPI
[    0.540533] pci 0000:00:1c.3: [8086:8c16] type 01 class 0x060400
[    0.540586] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.540598] pci 0000:00:1c.3: Enabling MPC IRBNCE
[    0.540601] pci 0000:00:1c.3: Intel PCH root port ACS workaround enabled
[    0.540634] pci 0000:00:1c.3: System wakeup disabled by ACPI
[    0.540662] pci 0000:00:1f.0: [8086:8c49] type 00 class 0x060100
[    0.540788] pci 0000:00:1f.2: [8086:8c03] type 00 class 0x010601
[    0.540799] pci 0000:00:1f.2: reg 0x10: [io  0xf0b0-0xf0b7]
[    0.540805] pci 0000:00:1f.2: reg 0x14: [io  0xf0a0-0xf0a3]
[    0.540811] pci 0000:00:1f.2: reg 0x18: [io  0xf090-0xf097]
[    0.540817] pci 0000:00:1f.2: reg 0x1c: [io  0xf080-0xf083]
[    0.540823] pci 0000:00:1f.2: reg 0x20: [io  0xf060-0xf07f]
[    0.540830] pci 0000:00:1f.2: reg 0x24: [mem 0xf7a1a000-0xf7a1a7ff]
[    0.540859] pci 0000:00:1f.2: PME# supported from D3hot
[    0.540900] pci 0000:00:1f.3: [8086:8c22] type 00 class 0x0c0500
[    0.540912] pci 0000:00:1f.3: reg 0x10: [mem 0xf7a19000-0xf7a190ff 64bit]
[    0.540929] pci 0000:00:1f.3: reg 0x20: [io  0xf040-0xf05f]
[    0.541008] pci 0000:01:00.0: [10de:139b] type 00 class 0x030200
[    0.541024] pci 0000:01:00.0: reg 0x10: [mem 0xf6000000-0xf6ffffff]
[    0.541040] pci 0000:01:00.0: reg 0x14: [mem 0xe0000000-0xefffffff 64bit=
=20
pref]
[    0.541055] pci 0000:01:00.0: reg 0x1c: [mem 0xf0000000-0xf1ffffff 64bit=
=20
pref]
[    0.541065] pci 0000:01:00.0: reg 0x24: [io  0xe000-0xe07f]
[    0.541076] pci 0000:01:00.0: reg 0x30: [mem 0xf7000000-0xf707ffff pref]
[    0.541169] pci 0000:01:00.0: System wakeup disabled by ACPI
[    0.542365] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.542367] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.542369] pci 0000:00:01.0:   bridge window [mem 0xf6000000-0xf70fffff]
[    0.542371] pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xf1ffffff=
=20
64bit pref]
[    0.542405] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.542443] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.542495] pci 0000:04:00.0: [168c:0032] type 00 class 0x028000
[    0.542520] pci 0000:04:00.0: reg 0x10: [mem 0xf7900000-0xf797ffff 64bit]
[    0.542571] pci 0000:04:00.0: reg 0x30: [mem 0xf7980000-0xf798ffff pref]
[    0.542637] pci 0000:04:00.0: supports D1 D2
[    0.542639] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.544366] pci 0000:00:1c.2: PCI bridge to [bus 04]
[    0.544371] pci 0000:00:1c.2:   bridge window [mem 0xf7900000-0xf79fffff]
[    0.544421] pci 0000:05:00.0: [10ec:5287] type 00 class 0xff0000
[    0.544440] pci 0000:05:00.0: reg 0x10: [mem 0xf7815000-0xf7815fff]
[    0.544502] pci 0000:05:00.0: reg 0x30: [mem 0xf7800000-0xf780ffff pref]
[    0.544584] pci 0000:05:00.0: supports D1 D2
[    0.544585] pci 0000:05:00.0: PME# supported from D1 D2 D3hot D3cold
[    0.544663] pci 0000:05:00.1: [10ec:8168] type 00 class 0x020000
[    0.544682] pci 0000:05:00.1: reg 0x10: [io  0xd000-0xd0ff]
[    0.544710] pci 0000:05:00.1: reg 0x18: [mem 0xf7814000-0xf7814fff 64bit]
[    0.544727] pci 0000:05:00.1: reg 0x20: [mem 0xf7810000-0xf7813fff 64bit]
[    0.544813] pci 0000:05:00.1: supports D1 D2
[    0.544814] pci 0000:05:00.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.546374] pci 0000:00:1c.3: PCI bridge to [bus 05]
[    0.546377] pci 0000:00:1c.3:   bridge window [io  0xd000-0xdfff]
[    0.546380] pci 0000:00:1c.3:   bridge window [mem 0xf7800000-0xf78fffff]
[    0.546937] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11 12) *0=
,=20
disabled.
[    0.546973] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 12) *0,=20
disabled.
[    0.547006] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 12) *0,=20
disabled.
[    0.547040] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 12) *0,=20
disabled.
[    0.547073] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 12) *0,=20
disabled.
[    0.547105] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 12) *0,=20
disabled.
[    0.547138] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 12) *0,=20
disabled.
[    0.547171] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 12) *0,=20
disabled.
[    0.547197] ACPI Error: [_OSI] Namespace lookup failure, AE_NOT_FOUND=20
(20160422/psargs-359)
[    0.547199] ACPI Error: Method parse/execution failed [\_SB.BTKL._STA]=20
(Node ffff880226442618), AE_NOT_FOUND (20160422/psparse-542)
[    0.547375] ACPI: Enabled 4 GPEs in block 00 to 3F
[    0.547420] ACPI : EC: EC stopped
[    0.547468] ACPI : EC: GPE =3D 0x19, I/O: command/status =3D 0x66, data =
=3D 0x62
[    0.547469] ACPI : EC: EC started
[    0.547609] vgaarb: setting as boot device: PCI:0000:00:02.0
[    0.547611] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio
+mem,locks=3Dnone
[    0.547613] vgaarb: loaded
[    0.547614] vgaarb: bridge control possible 0000:00:02.0
[    0.547656] SCSI subsystem initialized
[    0.547680] libata version 3.00 loaded.
[    0.547693] EDAC MC: Ver: 3.0.0
[    0.547796] PCI: Using ACPI for IRQ routing
[    0.548993] PCI: pci_cache_line_size set to 64 bytes
[    0.549043] e820: reserve RAM buffer [mem 0x00058000-0x0005ffff]
[    0.549044] e820: reserve RAM buffer [mem 0x0009e000-0x0009ffff]
[    0.549045] e820: reserve RAM buffer [mem 0xb5df8000-0xb7ffffff]
[    0.549046] e820: reserve RAM buffer [mem 0xb671a000-0xb7ffffff]
[    0.549047] e820: reserve RAM buffer [mem 0xc6046000-0xc7ffffff]
[    0.549049] e820: reserve RAM buffer [mem 0xc6403000-0xc7ffffff]
[    0.549050] e820: reserve RAM buffer [mem 0xc7000000-0xc7ffffff]
[    0.549051] e820: reserve RAM buffer [mem 0x22f200000-0x22fffffff]
[    0.549152] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.549156] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.552169] amd_nb: Cannot enumerate AMD northbridges
[    0.552178] clocksource: Switched to clocksource hpet
[    0.552192] VFS: Disk quotas dquot_6.6.0
[    0.552199] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 byte=
s)
[    0.552227] pnp: PnP ACPI init
[    0.552270] system 00:00: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.552272] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.552380] system 00:01: [io  0x0680-0x069f] has been reserved
[    0.552381] system 00:01: [io  0xffff] has been reserved
[    0.552382] system 00:01: [io  0xffff] has been reserved
[    0.552383] system 00:01: [io  0xffff] has been reserved
[    0.552383] system 00:01: [io  0x1c00-0x1cfe] has been reserved
[    0.552384] system 00:01: [io  0x1d00-0x1dfe] has been reserved
[    0.552385] system 00:01: [io  0x1e00-0x1efe] has been reserved
[    0.552386] system 00:01: [io  0x1f00-0x1ffe] has been reserved
[    0.552387] system 00:01: [io  0x1800-0x18fe] has been reserved
[    0.552388] system 00:01: [io  0x164e-0x164f] has been reserved
[    0.552389] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.552401] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.552427] system 00:03: [io  0x1854-0x1857] has been reserved
[    0.552429] system 00:03: Plug and Play ACPI device, IDs INT3f0d PNP0c02=
=20
(active)
[    0.552453] system 00:04: [io  0x04d0-0x04d1] has been reserved
[    0.552455] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.552471] system 00:05: [io  0x0240-0x0259] has been reserved
[    0.552473] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.552500] pnp 00:06: Plug and Play ACPI device, IDs ETD0108 SYN0a00=20
SYN0002 PNP0f03 PNP0f13 PNP0f12 (active)
[    0.552519] pnp 00:07: Plug and Play ACPI device, IDs ATK3001 PNP030b=20
(active)
[    0.552698] system 00:08: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.552699] system 00:08: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.552700] system 00:08: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.552701] system 00:08: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.552702] system 00:08: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.552703] system 00:08: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.552704] system 00:08: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.552704] system 00:08: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.552705] system 00:08: [mem 0xff000000-0xffffffff] has been reserved
[    0.552707] system 00:08: [mem 0xfee00000-0xfeefffff] could not be reser=
ved
[    0.552708] system 00:08: [mem 0xf7fdf000-0xf7fdffff] has been reserved
[    0.552709] system 00:08: [mem 0xf7fe0000-0xf7feffff] has been reserved
[    0.552710] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.552749] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.552834] ACPI Error: [_OSI] Namespace lookup failure, AE_NOT_FOUND=20
(20160422/psargs-359)
[    0.552836] ACPI Error: Method parse/execution failed [\_SB.BTKL._STA]=20
(Node ffff880226442618), AE_NOT_FOUND (20160422/psparse-542)
[    0.552914] pnp: PnP ACPI: found 10 devices
[    0.558487] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff,=20
max_idle_ns: 2085701024 ns
[    0.558503] pci 0000:00:1c.1: bridge window [io  0x1000-0x0fff] to [bus =
03]=20
add_size 1000
[    0.558505] pci 0000:00:1c.1: bridge window [mem 0x00100000-0x000fffff=20
64bit pref] to [bus 03] add_size 200000 add_align 100000
[    0.558506] pci 0000:00:1c.1: bridge window [mem 0x00100000-0x000fffff] =
to=20
[bus 03] add_size 200000 add_align 100000
[    0.558519] pci 0000:00:1c.1: res[14]=3D[mem 0x00100000-0x000fffff]=20
res_to_dev_res add_size 200000 min_align 100000
[    0.558520] pci 0000:00:1c.1: res[14]=3D[mem 0x00100000-0x002fffff]=20
res_to_dev_res add_size 200000 min_align 100000
[    0.558521] pci 0000:00:1c.1: res[15]=3D[mem 0x00100000-0x000fffff 64bit=
=20
pref] res_to_dev_res add_size 200000 min_align 100000
[    0.558522] pci 0000:00:1c.1: res[15]=3D[mem 0x00100000-0x002fffff 64bit=
=20
pref] res_to_dev_res add_size 200000 min_align 100000
[    0.558523] pci 0000:00:1c.1: res[13]=3D[io  0x1000-0x0fff] res_to_dev_r=
es=20
add_size 1000 min_align 1000
[    0.558524] pci 0000:00:1c.1: res[13]=3D[io  0x1000-0x1fff] res_to_dev_r=
es=20
add_size 1000 min_align 1000
[    0.558528] pci 0000:00:1c.1: BAR 14: assigned [mem 0xcfe00000-0xcffffff=
f]
[    0.558534] pci 0000:00:1c.1: BAR 15: assigned [mem 0xf2000000-0xf21ffff=
f=20
64bit pref]
[    0.558535] pci 0000:00:1c.1: BAR 13: assigned [io  0x2000-0x2fff]
[    0.558537] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.558538] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.558540] pci 0000:00:01.0:   bridge window [mem 0xf6000000-0xf70fffff]
[    0.558541] pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xf1ffffff=
=20
64bit pref]
[    0.558544] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.558552] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.558555] pci 0000:00:1c.1:   bridge window [io  0x2000-0x2fff]
[    0.558558] pci 0000:00:1c.1:   bridge window [mem 0xcfe00000-0xcfffffff]
[    0.558561] pci 0000:00:1c.1:   bridge window [mem 0xf2000000-0xf21fffff=
=20
64bit pref]
[    0.558565] pci 0000:00:1c.2: PCI bridge to [bus 04]
[    0.558569] pci 0000:00:1c.2:   bridge window [mem 0xf7900000-0xf79fffff]
[    0.558575] pci 0000:00:1c.3: PCI bridge to [bus 05]
[    0.558577] pci 0000:00:1c.3:   bridge window [io  0xd000-0xdfff]
[    0.558581] pci 0000:00:1c.3:   bridge window [mem 0xf7800000-0xf78fffff]
[    0.558588] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    0.558589] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
[    0.558589] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff windo=
w]
[    0.558590] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000c3fff windo=
w]
[    0.558591] pci_bus 0000:00: resource 8 [mem 0x000c4000-0x000c7fff windo=
w]
[    0.558592] pci_bus 0000:00: resource 9 [mem 0x000c8000-0x000cbfff windo=
w]
[    0.558593] pci_bus 0000:00: resource 10 [mem 0x000cc000-0x000cffff wind=
ow]
[    0.558594] pci_bus 0000:00: resource 11 [mem 0x000d0000-0x000d3fff wind=
ow]
[    0.558594] pci_bus 0000:00: resource 12 [mem 0x000d4000-0x000d7fff wind=
ow]
[    0.558595] pci_bus 0000:00: resource 13 [mem 0x000d8000-0x000dbfff wind=
ow]
[    0.558596] pci_bus 0000:00: resource 14 [mem 0x000dc000-0x000dffff wind=
ow]
[    0.558597] pci_bus 0000:00: resource 15 [mem 0x000e0000-0x000e3fff wind=
ow]
[    0.558598] pci_bus 0000:00: resource 16 [mem 0x000e4000-0x000e7fff wind=
ow]
[    0.558598] pci_bus 0000:00: resource 17 [mem 0x000e8000-0x000ebfff wind=
ow]
[    0.558599] pci_bus 0000:00: resource 18 [mem 0x000ec000-0x000effff wind=
ow]
[    0.558600] pci_bus 0000:00: resource 19 [mem 0xcfe00000-0xfeafffff wind=
ow]
[    0.558601] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    0.558602] pci_bus 0000:01: resource 1 [mem 0xf6000000-0xf70fffff]
[    0.558603] pci_bus 0000:01: resource 2 [mem 0xe0000000-0xf1ffffff 64bit=
=20
pref]
[    0.558604] pci_bus 0000:03: resource 0 [io  0x2000-0x2fff]
[    0.558604] pci_bus 0000:03: resource 1 [mem 0xcfe00000-0xcfffffff]
[    0.558605] pci_bus 0000:03: resource 2 [mem 0xf2000000-0xf21fffff 64bit=
=20
pref]
[    0.558606] pci_bus 0000:04: resource 1 [mem 0xf7900000-0xf79fffff]
[    0.558607] pci_bus 0000:05: resource 0 [io  0xd000-0xdfff]
[    0.558608] pci_bus 0000:05: resource 1 [mem 0xf7800000-0xf78fffff]
[    0.558621] NET: Registered protocol family 2
[    0.558710] TCP established hash table entries: 65536 (order: 7, 524288=
=20
bytes)
[    0.558789] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.558926] TCP: Hash tables configured (established 65536 bind 65536)
[    0.558941] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.558965] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.559008] NET: Registered protocol family 1
[    0.559016] pci 0000:00:02.0: Video device with shadowed ROM at [mem=20
0x000c0000-0x000dffff]
[    0.559158] PCI: CLS 64 bytes, default 64
[    0.559192] Unpacking initramfs...
[    0.626612] Freeing initrd memory: 6040K (ffff880037424000 -=20
ffff880037a0a000)
[    0.626624] DMAR: Host address width 39
[    0.626625] DMAR: DRHD base: 0x000000fed90000 flags: 0x0
[    0.626635] DMAR: dmar0: reg_base_addr fed90000 ver 1:0 cap c00000206604=
62=20
ecap f0101a
[    0.626636] DMAR: DRHD base: 0x000000fed91000 flags: 0x1
[    0.626640] DMAR: dmar1: reg_base_addr fed91000 ver 1:0 cap d20080206604=
62=20
ecap f010da
[    0.626640] DMAR: RMRR base: 0x000000c61e6000 end: 0x000000c61f2fff
[    0.626641] DMAR: RMRR base: 0x000000c7c00000 end: 0x000000cfdfffff
[    0.626647] DMAR: No ATSR found
[    0.627485] DMAR: dmar0: Using Queued invalidation
[    0.627492] DMAR: dmar1: Using Queued invalidation
[    0.627535] DMAR: Setting RMRR:
[    0.627569] DMAR: Setting identity map for device 0000:00:02.0 [0xc7c000=
00=20
=2D 0xcfdfffff]
[    0.628186] DMAR: Setting identity map for device 0000:00:14.0 [0xc61e60=
00=20
=2D 0xc61f2fff]
[    0.628197] DMAR: Prepare 0-16MiB unity mapping for LPC
[    0.628221] DMAR: Setting identity map for device 0000:00:1f.0 [0x0 -=20
0xffffff]
[    0.628352] DMAR: Intel(R) Virtualization Technology for Directed I/O
[    0.628387] iommu: Adding device 0000:00:00.0 to group 0
[    0.628396] iommu: Adding device 0000:00:01.0 to group 1
[    0.628402] iommu: Adding device 0000:00:02.0 to group 2
[    0.628407] iommu: Adding device 0000:00:03.0 to group 3
[    0.628412] iommu: Adding device 0000:00:14.0 to group 4
[    0.628419] iommu: Adding device 0000:00:16.0 to group 5
[    0.628424] iommu: Adding device 0000:00:1b.0 to group 6
[    0.628429] iommu: Adding device 0000:00:1c.0 to group 7
[    0.628434] iommu: Adding device 0000:00:1c.1 to group 8
[    0.628440] iommu: Adding device 0000:00:1c.2 to group 9
[    0.628446] iommu: Adding device 0000:00:1c.3 to group 10
[    0.628455] iommu: Adding device 0000:00:1f.0 to group 11
[    0.628460] iommu: Adding device 0000:00:1f.2 to group 11
[    0.628465] iommu: Adding device 0000:00:1f.3 to group 11
[    0.628469] iommu: Adding device 0000:01:00.0 to group 1
[    0.628474] iommu: Adding device 0000:04:00.0 to group 12
[    0.628494] iommu: Adding device 0000:05:00.0 to group 13
[    0.628511] iommu: Adding device 0000:05:00.1 to group 13
[    0.631087] futex hash table entries: 2048 (order: 5, 131072 bytes)
[    0.631114] audit: initializing netlink subsys (disabled)
[    0.631135] audit: type=3D2000 audit(1473437962.618:1): initialized
[    0.631312] workingset: timestamp_bits=3D54 max_order=3D21 bucket_order=
=3D0
[    0.632538] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor=20
249)
[    0.632565] io scheduler noop registered
[    0.632567] io scheduler deadline registered
[    0.632595] io scheduler cfq registered (default)
[    0.633131] pcieport 0000:00:01.0: Signaling PME through PCIe PME interr=
upt
[    0.633133] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
[    0.633135] pcie_pme 0000:00:01.0:pcie001: service driver pcie_pme loaded
[    0.633159] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interr=
upt
[    0.633163] pcie_pme 0000:00:1c.0:pcie001: service driver pcie_pme loaded
[    0.633196] pcieport 0000:00:1c.1: Signaling PME through PCIe PME interr=
upt
[    0.633200] pcie_pme 0000:00:1c.1:pcie001: service driver pcie_pme loaded
[    0.633216] pcieport 0000:00:1c.2: Signaling PME through PCIe PME interr=
upt
[    0.633217] pci 0000:04:00.0: Signaling PME through PCIe PME interrupt
[    0.633221] pcie_pme 0000:00:1c.2:pcie001: service driver pcie_pme loaded
[    0.633236] pcieport 0000:00:1c.3: Signaling PME through PCIe PME interr=
upt
[    0.633237] pci 0000:05:00.0: Signaling PME through PCIe PME interrupt
[    0.633238] pci 0000:05:00.1: Signaling PME through PCIe PME interrupt
[    0.633242] pcie_pme 0000:00:1c.3:pcie001: service driver pcie_pme loaded
[    0.633245] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.633246] intel_idle: MWAIT substates: 0x42120
[    0.633247] intel_idle: v0.4.1 model 0x3C
[    0.633463] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.633585] GHES: HEST is not enabled!
[    0.633618] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.634387] i8042: PNP: PS/2 Controller [PNP030b:PS2K,PNP0f03:PS2M] at=20
0x60,0x64 irq 1,12
[    0.637930] i8042: Detected active multiplexing controller, rev 1.1
[    0.639337] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.639343] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    0.639344] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    0.639344] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    0.639356] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    0.639525] mousedev: PS/2 mouse device common for all mice
[    0.639581] input: PC Speaker as /devices/platform/pcspkr/input/input1
[    0.639597] rtc_cmos 00:02: RTC can wake from S4
[    0.639712] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    0.639744] rtc_cmos 00:02: alarms up to one month, y3k, 242 bytes nvram=
,=20
hpet irqs
[    0.639750] intel_pstate: Intel P-state driver initializing
[    0.639966] ledtrig-cpu: registered to indicate activity on CPUs
[    0.640810] NET: Registered protocol family 10
[    0.641365] mip6: Mobile IPv6
[    0.641371] NET: Registered protocol family 17
[    0.641385] Key type dns_resolver registered
[    0.641925] microcode: CPU0 sig=3D0x306c3, pf=3D0x20, revision=3D0x20
[    0.641967] microcode: CPU1 sig=3D0x306c3, pf=3D0x20, revision=3D0x20
[    0.642011] microcode: CPU2 sig=3D0x306c3, pf=3D0x20, revision=3D0x20
[    0.642041] microcode: CPU3 sig=3D0x306c3, pf=3D0x20, revision=3D0x20
[    0.642063] microcode: CPU4 sig=3D0x306c3, pf=3D0x20, revision=3D0x20
[    0.642107] microcode: CPU5 sig=3D0x306c3, pf=3D0x20, revision=3D0x20
[    0.642126] microcode: CPU6 sig=3D0x306c3, pf=3D0x20, revision=3D0x20
[    0.642143] microcode: CPU7 sig=3D0x306c3, pf=3D0x20, revision=3D0x20
[    0.642253] microcode: Microcode Update Driver: v2.01=20
<tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.642537] registered taskstats version 1
[    0.643774] rtc_cmos 00:02: setting system clock to 2016-09-09 16:19:23 =
UTC=20
(1473437963)
[    0.645672] Freeing unused kernel memory: 868K (ffffffff81894000 -=20
ffffffff8196d000)
[    0.645676] Write protecting the kernel read-only data: 8192k
[    0.646529] Freeing unused kernel memory: 1468K (ffff880001491000 -=20
ffff880001600000)
[    0.649148] Freeing unused kernel memory: 448K (ffff880001790000 -=20
ffff880001800000)
[    0.671612] random: systemd-udevd: uninitialized urandom read (16 bytes=
=20
read, 5 bits of entropy available)
[    0.671691] random: systemd-udevd: uninitialized urandom read (16 bytes=
=20
read, 5 bits of entropy available)
[    0.671706] random: systemd-udevd: uninitialized urandom read (16 bytes=
=20
read, 5 bits of entropy available)
[    0.672562] random: udevadm: uninitialized urandom read (16 bytes read, =
5=20
bits of entropy available)
[    0.672622] random: udevadm: uninitialized urandom read (16 bytes read, =
5=20
bits of entropy available)
[    0.673152] random: udevadm: uninitialized urandom read (16 bytes read, =
5=20
bits of entropy available)
[    0.673230] random: udevadm: uninitialized urandom read (16 bytes read, =
5=20
bits of entropy available)
[    0.673285] random: udevadm: uninitialized urandom read (16 bytes read, =
5=20
bits of entropy available)
[    0.673345] random: udevadm: uninitialized urandom read (16 bytes read, =
5=20
bits of entropy available)
[    0.673397] random: udevadm: uninitialized urandom read (16 bytes read, =
5=20
bits of entropy available)
[    0.679935] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/
serio0/input/input0
[    0.709696] thermal LNXTHERM:00: registered as thermal_zone0
[    0.709699] ACPI: Thermal Zone [THRM] (67 C)
[    0.709812] ACPI: bus type USB registered
[    0.709830] usbcore: registered new interface driver usbfs
[    0.709835] usbcore: registered new interface driver hub
[    0.709866] usbcore: registered new device driver usb
[    0.709923] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    0.709931] r8169 0000:05:00.1: can't disable ASPM; OS doesn't have ASPM=
=20
control
[    0.710467] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    0.710480] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus=
=20
number 1
[    0.711600] xhci_hcd 0000:00:14.0: hcc params 0x200077c1 hci version 0x1=
00=20
quirks 0x00009810
[    0.711605] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    0.711686] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    0.711687] usb usb1: New USB device strings: Mfr=3D3, Product=3D2,=20
SerialNumber=3D1
[    0.711689] usb usb1: Product: xHCI Host Controller
[    0.711690] usb usb1: Manufacturer: Linux 4.7.3 xhci-hcd
[    0.711691] usb usb1: SerialNumber: 0000:00:14.0
[    0.711788] hub 1-0:1.0: USB hub found
[    0.711805] hub 1-0:1.0: 14 ports detected
[    0.713194] r8169 0000:05:00.1 eth0: RTL8411 at 0xffffc90000c84000,=20
08:62:66:b5:38:a0, XID 1c800800 IRQ 32
[    0.713197] r8169 0000:05:00.1 eth0: jumbo features [frames: 9200 bytes,=
 tx=20
checksumming: ko]
[    0.713377] rtsx_pci 0000:05:00.0: rtsx_pci_acquire_irq: pcr->msi_en =3D=
 1,=20
pci->irq =3D 33
[    0.715756] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    0.715761] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus=
=20
number 2
[    0.715796] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0003
[    0.715798] usb usb2: New USB device strings: Mfr=3D3, Product=3D2,=20
SerialNumber=3D1
[    0.715799] usb usb2: Product: xHCI Host Controller
[    0.715801] usb usb2: Manufacturer: Linux 4.7.3 xhci-hcd
[    0.715802] usb usb2: SerialNumber: 0000:00:14.0
[    0.715915] hub 2-0:1.0: USB hub found
[    0.715926] hub 2-0:1.0: 4 ports detected
[    0.716608] ahci 0000:00:1f.2: version 3.0
[    0.716755] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 4 ports 6 Gbps 0x=
14=20
impl SATA mode
[    0.716757] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part=
=20
ems apst=20
[    0.718662] scsi host0: ahci
[    0.718757] scsi host1: ahci
[    0.718836] scsi host2: ahci
[    0.718904] scsi host3: ahci
[    0.718966] scsi host4: ahci
[    0.719001] ata1: DUMMY
[    0.719002] ata2: DUMMY
[    0.719005] ata3: SATA max UDMA/133 abar m2048@0xf7a1a000 port 0xf7a1a20=
0=20
irq 34
[    0.719007] ata4: DUMMY
[    0.719009] ata5: SATA max UDMA/133 abar m2048@0xf7a1a000 port 0xf7a1a30=
0=20
irq 34
[    0.721557] r8169 0000:05:00.1 enp5s0f1: renamed from eth0
[    1.022237] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.022259] ata5: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.024147] ata5.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succee=
ded
[    1.024150] ata5.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK=
)=20
filtered out
[    1.024152] ata5.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION=
=20
OVERLAY) filtered out
[    1.024321] ata3.00: ATAPI: HL-DT-ST DVDRAM GUC0N, AS01, max UDMA/133
[    1.024426] ata5.00: supports DRM functions and may not be fully accessi=
ble
[    1.025241] ata5.00: disabling queued TRIM support
[    1.025245] ata5.00: ATA-9: Samsung SSD 850 EVO 250GB, EMT02B6Q, max UDM=
A/
133
[    1.025247] ata5.00: 488397168 sectors, multi 1: LBA48 NCQ (depth 31/32)=
,=20
AA
[    1.026062] ata3.00: configured for UDMA/133
[    1.026086] ata5.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succee=
ded
[    1.026088] ata5.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK=
)=20
filtered out
[    1.026089] ata5.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION=
=20
OVERLAY) filtered out
[    1.026285] ata5.00: supports DRM functions and may not be fully accessi=
ble
[    1.026892] ata5.00: disabling queued TRIM support
[    1.027119] ata5.00: configured for UDMA/133
[    1.029411] scsi 2:0:0:0: CD-ROM            HL-DT-ST DVDRAM GUC0N     AS=
01=20
PQ: 0 ANSI: 5
[    1.043044] scsi 4:0:0:0: Direct-Access     ATA      Samsung SSD 850  2B=
6Q=20
PQ: 0 ANSI: 5
[    1.058855] sd 4:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/
233 GiB)
[    1.058917] sd 4:0:0:0: [sda] Write Protect is off
[    1.058919] sd 4:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.058938] sd 4:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[    1.060277]  sda: sda1 sda2 sda3 sda4 sda5 sda6 sda7 sda8
[    1.060651] sd 4:0:0:0: [sda] Attached SCSI disk
[    1.069197] usb 1-3: new full-speed USB device number 2 using xhci_hcd
[    1.075254] sr 2:0:0:0: [sr0] scsi3-mmc drive: 24x/24x writer dvd-ram cd=
/rw=20
xa/form2 cdda tray
[    1.075257] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.075401] sr 2:0:0:0: Attached scsi CD-ROM sr0
[    1.082387] usb 1-3: New USB device found, idVendor=3D046d, idProduct=3D=
c52f
[    1.082390] usb 1-3: New USB device strings: Mfr=3D1, Product=3D2,=20
SerialNumber=3D0
[    1.082392] usb 1-3: Product: USB Receiver
[    1.082393] usb 1-3: Manufacturer: Logitech
[    1.084066] hidraw: raw HID events driver (C) Jiri Kosina
[    1.086196] usbcore: registered new interface driver usbhid
[    1.086199] usbhid: USB HID core driver
[    1.086716] input: Logitech USB Receiver as /devices/
pci0000:00/0000:00:14.0/usb1/1-3/1-3:1.0/0003:046D:C52F.0001/input/input10
[    1.086765] hid-generic 0003:046D:C52F.0001: input,hidraw0: USB HID v1.1=
1=20
Mouse [Logitech USB Receiver] on usb-0000:00:14.0-3/input0
[    1.087443] input: Logitech USB Receiver as /devices/
pci0000:00/0000:00:14.0/usb1/1-3/1-3:1.1/0003:046D:C52F.0002/input/input11
[    1.138411] hid-generic 0003:046D:C52F.0002: input,hiddev0,hidraw1: USB =
HID=20
v1.11 Device [Logitech USB Receiver] on usb-0000:00:14.0-3/input1
[    1.196155] EXT4-fs (sda6): mounted filesystem with ordered data mode.=20
Opts: (null)
[    1.236211] usb 1-5: new full-speed USB device number 3 using xhci_hcd
[    1.243502] systemd[1]: RTC configured in localtime, applying delta of 1=
20=20
minutes to system time.
[    1.248929] usb 1-5: New USB device found, idVendor=3D13d3, idProduct=3D=
3402
[    1.248931] usb 1-5: New USB device strings: Mfr=3D1, Product=3D2,=20
SerialNumber=3D3
[    1.248932] usb 1-5: Product: Bluetooth USB Host Controller
[    1.248933] usb 1-5: Manufacturer: Atheros Communications
[    1.248934] usb 1-5: SerialNumber: Alaska Day 2006
[    1.258502] ip_tables: (C) 2000-2006 Netfilter Core Team
[    1.274499] systemd[1]: systemd 231 running in system mode. (+PAM +AUDIT=
=20
+SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUT=
LS=20
+ACL +XZ -LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD +IDN)
[    1.274652] systemd[1]: Detected architecture x86-64.
[    1.274811] systemd[1]: Set hostname to <Automatix>.
[    1.330299] systemd[1]: Listening on udev Kernel Socket.
[    1.330353] systemd[1]: Listening on fsck to fsckd communication Socket.
[    1.330383] systemd[1]: Started Forward Password Requests to Wall Direct=
ory=20
Watch.
[    1.330407] systemd[1]: Listening on /dev/initctl Compatibility Named Pi=
pe.
[    1.330417] systemd[1]: Reached target Encrypted Volumes.
[    1.330442] systemd[1]: Listening on RPCbind Server Activation Socket.
[    1.330450] systemd[1]: Reached target Swap.
[    1.330466] systemd[1]: Listening on Syslog Socket.
[    1.330481] systemd[1]: Listening on Journal Socket (/dev/log).
[    1.330535] systemd[1]: Created slice User and Session Slice.
[    1.330574] systemd[1]: Created slice System Slice.
[    1.330620] systemd[1]: Listening on Journal Audit Socket.
[    1.330630] systemd[1]: Reached target User and Group Name Lookups.
[    1.330638] systemd[1]: Reached target Slices.
[    1.330679] systemd[1]: Created slice system-systemd\x2dfsck.slice.
[    1.330701] systemd[1]: Listening on udev Control Socket.
[    1.330721] systemd[1]: Listening on Journal Socket.
[    1.338296] systemd[1]: Mounting POSIX Message Queue File System...
[    1.338708] systemd[1]: Starting Remount Root and Kernel File Systems...
[    1.340234] systemd[1]: Starting Load Kernel Modules...
[    1.340527] systemd[1]: Mounting Huge Pages File System...
[    1.340788] systemd[1]: Starting Journal Service...
[    1.341096] systemd[1]: Starting Create list of required static device=20
nodes for the current kernel...
[    1.341474] systemd[1]: Mounting Debug File System...
[    1.341603] systemd[1]: Set up automount Arbitrary Executable File Forma=
ts=20
=46ile System Automount Point.
[    1.342249] systemd[1]: Started Dispatch Password Requests to Console=20
Directory Watch.
[    1.342321] systemd[1]: Created slice system-getty.slice.
[    1.343686] systemd[1]: Starting Set the console keyboard layout...
[    1.344491] systemd[1]: Started Create list of required static device no=
des=20
for the current kernel.
[    1.344970] systemd[1]: Starting Create Static Device Nodes in /dev...
[    1.345591] systemd[1]: Mounted POSIX Message Queue File System.
[    1.345620] systemd[1]: Mounted Huge Pages File System.
[    1.345637] systemd[1]: Mounted Debug File System.
[    1.347119] EXT4-fs (sda6): re-mounted. Opts: user_xattr,errors=3Dremoun=
t-ro
[    1.347487] systemd[1]: Started Remount Root and Kernel File Systems.
[    1.348564] systemd[1]: Starting udev Coldplug all Devices...
[    1.348852] lp: driver loaded but no devices found
[    1.348883] systemd[1]: Starting Load/Save Random Seed...
[    1.350133] ppdev: user-space parallel port driver
[    1.352833] systemd[1]: Started Load/Save Random Seed.
[    1.353578] systemd[1]: Started Load Kernel Modules.
[    1.354091] systemd[1]: Starting Apply Kernel Variables...
[    1.358517] systemd[1]: Started Apply Kernel Variables.
[    1.361692] systemd[1]: Started Create Static Device Nodes in /dev.
[    1.362063] systemd[1]: Starting udev Kernel Device Manager...
[    1.371894] systemd[1]: Started Journal Service.
[    1.380806] systemd-journald[234]: Received request to flush runtime=20
journal from PID 1
[    1.402194] usb 1-7: new high-speed USB device number 4 using xhci_hcd
[    1.404552] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0=
D:
00/input/input12
[    1.405361] ACPI: Lid Switch [LID]
[    1.405404] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/
PNP0C0E:00/input/input13
[    1.405431] ACPI: Sleep Button [SLPB]
[    1.405466] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/
input14
[    1.405491] ACPI: Power Button [PWRF]
[    1.406928] ACPI: AC Adapter [AC0] (on-line)
[    1.412928] ACPI: Battery Slot [BAT0] (battery present)
[    1.413033] wmi: Mapper loaded
[    1.430087] sr 2:0:0:0: Attached scsi generic sg0 type 5
[    1.430394] sd 4:0:0:0: Attached scsi generic sg1 type 0
[    1.433545] i801_smbus 0000:00:1f.3: SMBus using PCI interrupt
[    1.435042] ACPI Error: [_OSI] Namespace lookup failure, AE_NOT_FOUND=20
(20160422/psargs-359)
[    1.435047] ACPI Error: Method parse/execution failed [\_SB.BTKL._STA]=20
(Node ffff880226442618), AE_NOT_FOUND (20160422/psparse-542)
[    1.440113] snd_hda_intel 0000:00:03.0: Applying patch firmware 'asus-n5=
51-
hda-fix.fw'
[    1.440589] snd_hda_intel 0000:00:1b.0: Applying patch firmware 'asus-n5=
51-
hda-fix.fw'
[    1.441925] RAPL PMU: API unit is 2^-32 Joules, 4 fixed counters, 655360=
 ms=20
ovfl timer
[    1.441927] RAPL PMU: hw unit of domain pp0-core 2^-14 Joules
[    1.441928] RAPL PMU: hw unit of domain package 2^-14 Joules
[    1.441928] RAPL PMU: hw unit of domain dram 2^-14 Joules
[    1.441929] RAPL PMU: hw unit of domain pp1-gpu 2^-14 Joules
[    1.441938] [drm] Initialized drm 1.1.0 20060810
[    1.445844] AVX2 version of gcm_enc/dec engaged.
[    1.445847] AES CTR mode by8 optimization enabled
[    1.452312] ath: phy0: Set parameters for CUS198
[    1.452315] ath: phy0: Set BT/WLAN RX diversity capability
[    1.452914] snd_hda_codec_realtek hdaudioC0D0: autoconfig for ALC668:=20
line_outs=3D2 (0x14/0x1a/0x0/0x0/0x0) type:speaker
[    1.452917] snd_hda_codec_realtek hdaudioC0D0:    speaker_outs=3D0=20
(0x0/0x0/0x0/0x0/0x0)
[    1.452919] snd_hda_codec_realtek hdaudioC0D0:    hp_outs=3D1=20
(0x15/0x0/0x0/0x0/0x0)
[    1.452920] snd_hda_codec_realtek hdaudioC0D0:    mono: mono_out=3D0x0
[    1.452921] snd_hda_codec_realtek hdaudioC0D0:    inputs:
[    1.452923] snd_hda_codec_realtek hdaudioC0D0:      Mic=3D0x18
[    1.452925] snd_hda_codec_realtek hdaudioC0D0:      Internal Mic=3D0x12
[    1.458598] ath: phy0: Enable LNA combining
[    1.459780] ath: phy0: ASPM enabled: 0x42
[    1.459781] ath: EEPROM regdomain: 0x60
[    1.459781] ath: EEPROM indicates we should expect a direct regpair map
[    1.459783] ath: Country alpha2 being used: 00
[    1.459783] ath: Regpair used: 0x60
[    1.460359] psmouse serio4: elantech: assuming hardware version 4 (with=
=20
firmware version 0x381fa2)
[    1.464225] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.=
0/
sound/card0/input15
[    1.464324] input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1b.0/
sound/card0/input16
[    1.464359] input: HDA Intel PCH Headphone as /devices/
pci0000:00/0000:00:1b.0/sound/card0/input17
[    1.467528] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[    1.467801] ieee80211 phy0: Atheros AR9485 Rev:1 mem=3D0xffffc9000150000=
0,=20
irq=3D18
[    1.469147] [drm] DMAR active, disabling use of stolen memory
[    1.469148] [drm] Memory usable by graphics device =3D 2048M
[    1.469149] [drm] VT-d active for gfx access
[    1.469150] [drm] Replacing VGA console driver
[    1.474841] psmouse serio4: elantech: Synaptics capabilities query resul=
t=20
0x10, 0x14, 0x0e.
[    1.475222] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    1.475224] [drm] Driver supports precise vblank timestamp query.
[    1.477471] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=
=3Dio
+mem,decodes=3Dio+mem:owns=3Dio+mem
[    1.478966] asus_wmi: ASUS WMI generic driver loaded
[    1.481162] asus_wmi: Initialization: 0x1
[    1.481210] asus_wmi: BIOS WMI version: 7.9
[    1.481241] asus_wmi: SFUN value: 0x6a0877
[    1.482051] input: Asus WMI hotkeys as /devices/platform/asus-nb-wmi/inp=
ut/
input18
[    1.485287] iTCO_vendor_support: vendor-support=3D0
[    1.486157] asus_wmi: Number of fans: 1
[    1.486493] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[    1.486532] iTCO_wdt: Found a Lynx Point TCO device (Version=3D2,=20
TCOBASE=3D0x1860)
[    1.486800] iTCO_wdt: initialized. heartbeat=3D30 sec (nowayout=3D0)
[    1.492929] psmouse serio4: elantech: Elan sample query result 05, 1b, 64
[    1.505590] ath9k 0000:04:00.0 wlp4s0: renamed from wlan0
[    1.545399] usb 1-7: New USB device found, idVendor=3D13d3, idProduct=3D=
5188
[    1.545402] usb 1-7: New USB device strings: Mfr=3D3, Product=3D1,=20
SerialNumber=3D2
[    1.545404] usb 1-7: Product: USB2.0 UVC HD Webcam
[    1.545405] usb 1-7: Manufacturer: Azurewave
[    1.545407] usb 1-7: SerialNumber: NULL
[    1.578147] [Firmware Bug]: ACPI(PEGP) defines _DOD but not _DOS
[    1.587502] ACPI: Video Device [PEGP] (multi-head: yes  rom: yes  post: =
no)
[    1.588795] acpi device:5f: registered as cooling_device8
[    1.588828] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/
PNP0A08:00/device:4f/LNXVIDEO:00/input/input19
[    1.590788] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: n=
o)
[    1.592338] acpi device:73: registered as cooling_device10
[    1.592446] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/
PNP0A08:00/LNXVIDEO:01/input/input20
[    1.594323] intel_rapl: Found RAPL domain package
[    1.594327] intel_rapl: Found RAPL domain core
[    1.594330] intel_rapl: Found RAPL domain uncore
[    1.594332] intel_rapl: Found RAPL domain dram
[    1.594336] intel_rapl: RAPL package 0 domain package locked by BIOS
[    1.594342] intel_rapl: RAPL package 0 domain dram locked by BIOS
[    1.596319] Bluetooth: Core ver 2.21
[    1.596327] NET: Registered protocol family 31
[    1.596328] Bluetooth: HCI device and connection manager initialized
[    1.596330] Bluetooth: HCI socket layer initialized
[    1.596332] Bluetooth: L2CAP socket layer initialized
[    1.596334] Bluetooth: SCO socket layer initialized
[    1.606542] media: Linux media interface: v0.10
[    1.607430] usbcore: registered new interface driver btusb
[    1.608508] Linux video capture interface: v2.00
[    1.608639] usbcore: registered new interface driver ath3k
[    1.612677] uvcvideo: Found UVC 1.00 device USB2.0 UVC HD Webcam=20
(13d3:5188)
[    1.616608] EXT4-fs (sda7): mounted filesystem with ordered data mode.=20
Opts: user_xattr
[    1.618048] uvcvideo 1-7:1.0: Entity type for entity Extension 4 was not=
=20
initialized!
[    1.618050] uvcvideo 1-7:1.0: Entity type for entity Processing 2 was no=
t=20
initialized!
[    1.618052] uvcvideo 1-7:1.0: Entity type for entity Camera 1 was not=20
initialized!
[    1.618094] input: USB2.0 UVC HD Webcam as /devices/
pci0000:00/0000:00:14.0/usb1/1-7/1-7:1.0/input/input21
[    1.618131] usbcore: registered new interface driver uvcvideo
[    1.618133] USB Video Class driver (1.1.1)
[    1.630198] tsc: Refined TSC clocksource calibration: 2593.993 MHz
[    1.630203] clocksource: tsc: mask: 0xffffffffffffffff max_cycles:=20
0x256411d258c, max_idle_ns: 440795337342 ns
[    1.630827] input: ETPS/2 Elantech Touchpad as /devices/platform/i8042/
serio4/input/input9
[    1.644127] random: nonblocking pool is initialized
[    1.721233] bbswitch: version 0.8
[    1.721238] bbswitch: Found integrated VGA device 0000:00:02.0:=20
\_SB_.PCI0.GFX0
[    1.721241] bbswitch: Found discrete VGA device 0000:01:00.0:=20
\_SB_.PCI0.PEG0.PEGP
[    1.721251] ACPI Warning: \_SB.PCI0.PEG0.PEGP._DSM: Argument #4 type=20
mismatch - Found [Buffer], ACPI requires [Package] (20160422/nsarguments-95)
[    1.721323] bbswitch: detected an Optimus _DSM function
[    1.721373] bbswitch: Succesfully loaded. Discrete card 0000:01:00.0 is =
on
[    1.721707] bbswitch: disabling discrete graphics
[    1.721715] ACPI Warning: \_SB.PCI0.PEG0.PEGP._DSM: Argument #4 type=20
mismatch - Found [Buffer], ACPI requires [Package] (20160422/nsarguments-95)
[    1.747762] fbcon: inteldrmfb (fb0) is primary device
[    1.815370] usbcore: registered new interface driver Promethean ActivDri=
ver
[    2.630460] 5.8.46:USB Activboard/Activhub Driver
[    2.630460] clocksource: Switched to clocksource tsc
[    3.142546] snd_hda_intel 0000:00:03.0: bound 0000:00:02.0 (ops=20
i915_audio_component_bind_ops [i915])
[    3.142557] [drm] Initialized i915 1.6.0 20160425 for 0000:00:02.0 on mi=
nor=20
0
[    3.142729] Console: switching to colour frame buffer device 240x67
[    3.154217] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    3.177439] input: HDA Intel HDMI HDMI/DP,pcm=3D3 as /devices/
pci0000:00/0000:00:03.0/sound/card1/input22
[    3.177508] input: HDA Intel HDMI HDMI/DP,pcm=3D7 as /devices/
pci0000:00/0000:00:03.0/sound/card1/input23
[    3.177569] input: HDA Intel HDMI HDMI/DP,pcm=3D8 as /devices/
pci0000:00/0000:00:03.0/sound/card1/input24
[    3.446694] IPv6: ADDRCONF(NETDEV_UP): enp5s0f1: link is not ready
[    3.458372] r8169 0000:05:00.1 enp5s0f1: link down
[    3.458422] IPv6: ADDRCONF(NETDEV_UP): enp5s0f1: link is not ready
[    3.460515] IPv6: ADDRCONF(NETDEV_UP): wlp4s0: link is not ready
[    3.475155] IPv6: ADDRCONF(NETDEV_UP): wlp4s0: link is not ready
[    3.504625] IPv6: ADDRCONF(NETDEV_UP): wlp4s0: link is not ready
[    3.549278] IPv6: ADDRCONF(NETDEV_UP): wlp4s0: link is not ready
[    4.562064] IPv6: ADDRCONF(NETDEV_UP): wlp4s0: link is not ready
[    4.583625] wlp4s0: authenticate with xx:xx:xx:xx:xx:xx
[    4.597820] wlp4s0: send auth to xx:xx:xx:xx:xx:xx (try 1/3)
[    4.619150] wlp4s0: authenticated
[    4.620146] wlp4s0: associate with xx:xx:xx:xx:xx:xx (try 1/3)
[    4.661364] wlp4s0: RX AssocResp from xx:xx:xx:xx:xx:xx (capab=3D0x431=20
status=3D0 aid=3D2)
[    4.661433] wlp4s0: associated
[    4.661460] IPv6: ADDRCONF(NETDEV_CHANGE): wlp4s0: link becomes ready
[   17.593739] fuse init (API version 7.25)
[   17.845896] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   17.845909] Bluetooth: BNEP filters: protocol multicast
[   17.845925] Bluetooth: BNEP socket layer initialized
[   17.857713] Bluetooth: RFCOMM TTY layer initialized
[   17.857719] Bluetooth: RFCOMM socket layer initialized
[   17.857723] Bluetooth: RFCOMM ver 1.11
[   22.359106] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[   22.359111] Bluetooth: HIDP socket layer initialized
[   22.359558] hid-generic 0005:045E:07A2.0003: unknown main item tag 0x0
[   22.359657] input: Microsoft Sculpt Comfort Mouse as /devices/
pci0000:00/0000:00:14.0/usb1/1-5/1-5:1.0/bluetooth/hci0/hci0:21/0005:045E:
07A2.0003/input/input25
[   22.360338] hid-generic 0005:045E:07A2.0003: input,hidraw2: BLUETOOTH HI=
D=20
v1.29 Mouse [Microsoft Sculpt Comfort Mouse] on xx:xx:xx:xx:xx:xx
[  156.817544] ath: phy0: DMA failed to stop in 10 ms AR_CR=3D0x00000024=20
AR_DIAG_SW=3D0x02000020 DMADBG_7=3D0x00006100
[  157.343185] DMAR: DRHD: handling fault status reg 3
[  157.343191] DMAR: [DMA Read] Request device [04:00.0] fault addr ff3a800=
0=20
[fault reason 06] PTE Read access is not set
[  157.957947] wlp4s0: authenticate with xx:xx:xx:xx:xx:xx
[  157.979102] wlp4s0: send auth to xx:xx:xx:xx:xx:xx (try 1/3)
[  158.004673] wlp4s0: authenticated
[  158.005518] wlp4s0: associate with xx:xx:xx:xx:xx:xx (try 1/3)
[  158.014076] wlp4s0: RX AssocResp from xx:xx:xx:xx:xx:xx (capab=3D0x431=20
status=3D0 aid=3D2)
[  158.014183] wlp4s0: associated
[  171.794356] ath: phy0: DMA failed to stop in 10 ms AR_CR=3D0x00000024=20
AR_DIAG_SW=3D0x02000020 DMADBG_7=3D0x00006100
[  172.918927] wlp4s0: authenticate with xx:xx:xx:xx:xx:xx
[  172.940023] wlp4s0: send auth to xx:xx:xx:xx:xx:xx (try 1/3)
[  172.941958] wlp4s0: authenticated
[  172.943222] wlp4s0: associate with xx:xx:xx:xx:xx:xx (try 1/3)
[  172.946885] wlp4s0: RX AssocResp from xx:xx:xx:xx:xx:xx (capab=3D0x431=20
status=3D0 aid=3D2)
[  172.946979] wlp4s0: associated
