Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from investici.nine.ch ([217.150.252.179]:20364 "EHLO
	confino.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088Ab2EBQVj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 May 2012 12:21:39 -0400
Date: Wed, 2 May 2012 18:21:02 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	"Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwlwifi warn_slowpath with 3.*
Message-ID: <20120502162100.GA2528@ritirata.org> (sfid-20120502_182147_261458_20DEC215)
References: <20120422182928.GA2854@ritirata.org>
 <20120430145803.GE2630@ritirata.org>
 <20120430170337.GA2560@tuxdriver.com>
 <4595B4D22AB93C4FABBA84AAD5AA37FD143115@ORSMSX103.amr.corp.intel.com>
 <CANUX_P1Nx4jYbRwehi+qW-2RVy=ntb_cCzBzpYXkJysuPvrCPA@mail.gmail.com>
 <20120501183415.GG4316@ritirata.org>
 <20120501205616.GA2563@ritirata.org>
 <4595B4D22AB93C4FABBA84AAD5AA37FD14438A@ORSMSX103.amr.corp.intel.com>
 <CANUX_P0UYx_-PS8BUGO10Cwrm6LuhMu4Vyhad4RL-Jn6YqE-Pg@mail.gmail.com>
 <20120502153914.GA9285@tuxdriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZoaI/ZTpAVc4A5k6"
In-Reply-To: <20120502153914.GA9285@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--ZoaI/ZTpAVc4A5k6
Content-Type: multipart/mixed; boundary="jI8keyz6grp/JLjh"
Content-Disposition: inline


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 02, 2012 at 11:39:14AM -0400, John W. Linville wrote:
> On Wed, May 02, 2012 at 10:08:46AM +0300, Emmanuel Grumbach wrote:
> > On Wed, May 2, 2012 at 12:19 AM, Venkataraman, Meenakshi
> > <meenakshi.venkataraman@intel.com> wrote:
> > > Hi Antonio,
> > >
> > >>> it seems so. It happens at least once at boot time.
> > >>> I will try wireless-testing and see what happens. Then I will apply=
 your patch.
> > >>
> > >>The problem is there either with wireless-testing and with
> > >>wireless-testing+your_patch.
> > >>
> > >>If it can somehow help, I also got several stack trace regarding inte=
l_iova
> > >>functions. But then the I got kernel panic and I was not able to copy=
 the
> > >>messages.
> > >
> > > [MV] Depending on how you set it up, perhaps the stack trace was save=
d in one of the syslog files in /var/log/...
> > >
> > > Thanks!
> > > Meenakshi
> > >
> >=20
> > Can you please re-run with debug=3D1 and send the whole log ?
> > This will give a better indication on when the issue occurs.
>=20
> Does this help?
>=20
> 	https://bugzilla.redhat.com/show_bug.cgi?id=3D815998#c18

I applied patch in comment 17 on linux-3.3.4. IT didn't help but this time =
I got
the WARNING even with debug=3D1. Log is attached.


Cheers,

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="kernel.log"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 3.3.4-pf (root@eagle4) (gcc version 4.6.3 (Gen=
too 4.6.3 p1.0, pie-0.5.1) ) #3 SMP PREEMPT Tue May 1 11:34:23 CEST 2012
[    0.000000] Command line: root=3D/dev/sda5 console=3Dtty1 resume=3D/dev/=
sda3 init=3D/usr/bin/systemd
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009a800 (usable)
[    0.000000]  BIOS-e820: 000000000009a800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 0000000020000000 (usable)
[    0.000000]  BIOS-e820: 0000000020000000 - 0000000020200000 (reserved)
[    0.000000]  BIOS-e820: 0000000020200000 - 0000000040000000 (usable)
[    0.000000]  BIOS-e820: 0000000040000000 - 0000000040200000 (reserved)
[    0.000000]  BIOS-e820: 0000000040200000 - 00000000caa83000 (usable)
[    0.000000]  BIOS-e820: 00000000caa83000 - 00000000caac7000 (reserved)
[    0.000000]  BIOS-e820: 00000000caac7000 - 00000000cadb7000 (usable)
[    0.000000]  BIOS-e820: 00000000cadb7000 - 00000000cade7000 (reserved)
[    0.000000]  BIOS-e820: 00000000cade7000 - 00000000cafe7000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cafe7000 - 00000000cafff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cafff000 - 00000000cb000000 (usable)
[    0.000000]  BIOS-e820: 00000000cb800000 - 00000000cfa00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffc00000 - 00000000ffc20000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000012f000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.6 present.
[    0.000000] DMI: Dell Inc. Latitude E5420/0675PR, BIOS A01 04/20/2011
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usab=
le) =3D=3D> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usab=
le)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn =3D 0x12f000 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 080000000 mask FC0000000 write-back
[    0.000000]   2 base 0C0000000 mask FF8000000 write-back
[    0.000000]   3 base 0C8000000 mask FFC000000 write-back
[    0.000000]   4 base 0CB000000 mask FFF000000 uncachable
[    0.000000]   5 base 100000000 mask FE0000000 write-back
[    0.000000]   6 base 120000000 mask FF0000000 write-back
[    0.000000]   7 base 12F000000 mask FFF000000 uncachable
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] e820 update range: 00000000cb000000 - 0000000100000000 (usab=
le) =3D=3D> (reserved)
[    0.000000] last_pfn =3D 0xcb000 max_arch_pfn =3D 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000f1ff0] f1ff0
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff880000095000] 95000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-00000000cb000000
[    0.000000]  0000000000 - 00cb000000 page 2M
[    0.000000] kernel direct mapping tables up to cb000000 @ 1fffb000-20000=
000
[    0.000000] init_memory_mapping: 0000000100000000-000000012f000000
[    0.000000]  0100000000 - 012f000000 page 2M
[    0.000000] kernel direct mapping tables up to 12f000000 @ cadb1000-cadb=
7000
[    0.000000] ACPI: RSDP 00000000000fe300 00024 (v02 DELL  )
[    0.000000] ACPI: XSDT 00000000caffde18 0007C (v01 DELL    CBX3    06222=
004 MSFT 00010013)
[    0.000000] ACPI: FACP 00000000caf87d98 000F4 (v04 DELL    CBX3    06222=
004 MSFT 00010013)
[    0.000000] ACPI Warning: 32/64 FACS address mismatch in FADT - two FACS=
 tables! (20120111/tbfadt-378)
[    0.000000] ACPI Warning: 32/64X FACS address mismatch in FADT - 0xCAFE4=
E40/0x00000000CAFE4D40, using 32 (20120111/tbfadt-502)
[    0.000000] ACPI: DSDT 00000000caf7e018 0864E (v02 INT430 SYSFexxx 00001=
001 INTL 20090903)
[    0.000000] ACPI: FACS 00000000cafe4e40 00040
[    0.000000] ACPI: APIC 00000000caffcf18 000CC (v02 DELL    CBX3    06222=
004 MSFT 00010013)
[    0.000000] ACPI: TCPA 00000000cafe5d18 00032 (v02                 00000=
000      00000000)
[    0.000000] ACPI: ASF! 00000000cafe4a18 000A0 (v32 INTEL  Montevin 00000=
001 TFSM 000F4240)
[    0.000000] ACPI: MCFG 00000000cafe5c98 0003C (v01 DELL   SNDYBRDG 06222=
004 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000cafe5c18 00038 (v01 A M I   PCHHPET 06222=
004 AMI. 00000003)
[    0.000000] ACPI: BOOT 00000000cafe5b98 00028 (v01 DELL   CBX3     06222=
004 AMI  00010013)
[    0.000000] ACPI: SSDT 00000000caf7d818 007C2 (v01  PmRef  Cpu0Ist 00003=
000 INTL 20090903)
[    0.000000] ACPI: SSDT 00000000caf7c018 00996 (v01  PmRef    CpuPm 00003=
000 INTL 20090903)
[    0.000000] ACPI: DMAR 00000000caf87c18 000E8 (v01 INTEL      SNB  00000=
001 INTL 00000001)
[    0.000000] ACPI: SLIC 00000000caf88a18 00176 (v03 DELL    CBX3    06222=
004 MSFT 00010013)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000012f000000
[    0.000000] Initmem setup node 0 0000000000000000-000000012f000000
[    0.000000]   NODE_DATA [000000012eff5000 - 000000012effffff]
[    0.000000]  [ffffea0000000000-ffffea0004bfffff] PMD -> [ffff88012a60000=
0-ffff88012e5fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0012f000
[    0.000000] Movable zone start PFN for each node
[    0.000000] Early memory PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009a
[    0.000000]     0: 0x00000100 -> 0x00020000
[    0.000000]     0: 0x00020200 -> 0x00040000
[    0.000000]     0: 0x00040200 -> 0x000caa83
[    0.000000]     0: 0x000caac7 -> 0x000cadb7
[    0.000000]     0: 0x000cafff -> 0x000cb000
[    0.000000]     0: 0x00100000 -> 0x0012f000
[    0.000000] On node 0 totalpages: 1022206
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3909 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16320 pages used for memmap
[    0.000000]   DMA32 zone: 809396 pages, LIFO batch:31
[    0.000000]   Normal zone: 3008 pages used for memmap
[    0.000000]   Normal zone: 189504 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x04] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x05] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x06] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x08] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x09] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x0a] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x0b] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x0c] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x0d] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x0e] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x0f] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] 16 Processors exceeds NR_CPUS limit of 4
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009a000 - 00000000000=
9b000
[    0.000000] PM: Registered nosave memory: 000000000009b000 - 00000000000=
a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000=
e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 00000000001=
00000
[    0.000000] PM: Registered nosave memory: 0000000020000000 - 00000000202=
00000
[    0.000000] PM: Registered nosave memory: 0000000040000000 - 00000000402=
00000
[    0.000000] PM: Registered nosave memory: 00000000caa83000 - 00000000caa=
c7000
[    0.000000] PM: Registered nosave memory: 00000000cadb7000 - 00000000cad=
e7000
[    0.000000] PM: Registered nosave memory: 00000000cade7000 - 00000000caf=
e7000
[    0.000000] PM: Registered nosave memory: 00000000cafe7000 - 00000000caf=
ff000
[    0.000000] PM: Registered nosave memory: 00000000cb000000 - 00000000cb8=
00000
[    0.000000] PM: Registered nosave memory: 00000000cb800000 - 00000000cfa=
00000
[    0.000000] PM: Registered nosave memory: 00000000cfa00000 - 00000000fed=
1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed=
20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000ffc=
00000
[    0.000000] PM: Registered nosave memory: 00000000ffc00000 - 00000000ffc=
20000
[    0.000000] PM: Registered nosave memory: 00000000ffc20000 - 00000001000=
00000
[    0.000000] Allocating PCI resources starting at cfa00000 (gap: cfa00000=
:2f31c000)
[    0.000000] setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 25 pages/cpu @ffff88012ec00000 s70080 r8192=
 d24128 u524288
[    0.000000] pcpu-alloc: s70080 r8192 d24128 u524288 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3=20
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 1002809
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=3D/dev/sda5 console=3Dtty1 resume=
=3D/dev/sda3 init=3D/usr/bin/systemd
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave/xrstor: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 3946512k/4964352k available (4655k kernel code, 8755=
28k absent, 142312k reserved, 3971k data, 556k init)
[    0.000000] SLUB: Genslabs=3D15, HWalign=3D64, Order=3D0-3, MinObjects=
=3D0, CPUs=3D4, Nodes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:4352 nr_irqs:712 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty1] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.001000] Detected 2494.374 MHz processor.
[    0.000002] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 4988.74 BogoMIPS (lpj=3D2494374)
[    0.000146] pid_max: default: 32768 minimum: 301
[    0.000239] Security Framework initialized
[    0.000616] Dentry cache hash table entries: 524288 (order: 10, 4194304 =
bytes)
[    0.001565] Inode-cache hash table entries: 262144 (order: 9, 2097152 by=
tes)
[    0.001977] Mount-cache hash table entries: 256
[    0.002135] Initializing cgroup subsys freezer
[    0.002206] Initializing cgroup subsys bfqio
[    0.002309] CPU: Physical Processor ID: 0
[    0.002377] CPU: Processor Core ID: 0
[    0.002448] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.002449] ENERGY_PERF_BIAS: View and update with x86_energy_perf_polic=
y(8)
[    0.002595] mce: CPU supports 7 MCE banks
[    0.002673] CPU0: Thermal monitoring enabled (TM1)
[    0.002748] using mwait in idle threads.
[    0.002879] ACPI: Core revision 20120111
[    0.007143] DMAR: Host address width 36
[    0.007214] DMAR: DRHD base: 0x000000fed90000 flags: 0x0
[    0.007300] IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c0000020e60262 e=
cap f0101a
[    0.007402] DMAR: DRHD base: 0x000000fed91000 flags: 0x1
[    0.007478] IOMMU 1: reg_base_addr fed91000 ver 1:0 cap c9008020660262 e=
cap f0105a
[    0.007580] DMAR: RMRR base: 0x000000cadc6000 end: 0x000000cadd5fff
[    0.007655] DMAR: RMRR base: 0x000000cb800000 end: 0x000000cf9fffff
[    0.007798] IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
[    0.007871] HPET id 0 under DRHD base 0xfed91000
[    0.007943] HPET id 0 under DRHD base 0xfed91000
[    0.008015] HPET id 0 under DRHD base 0xfed91000
[    0.008087] HPET id 0 under DRHD base 0xfed91000
[    0.008157] HPET id 0 under DRHD base 0xfed91000
[    0.008228] HPET id 0 under DRHD base 0xfed91000
[    0.008299] HPET id 0 under DRHD base 0xfed91000
[    0.008370] HPET id 0 under DRHD base 0xfed91000
[    0.008631] Enabled IRQ remapping in xapic mode
[    0.009153] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.019216] CPU0: Intel(R) Core(TM) i5-2520M CPU @ 2.50GHz stepping 07
[    0.121080] Performance Events: PEBS fmt1+, SandyBridge events, Intel PM=
U driver.
[    0.121780] PEBS disabled due to CPU errata.
[    0.121853] ... version:                3
[    0.121922] ... bit width:              48
[    0.121993] ... generic registers:      4
[    0.122063] ... value mask:             0000ffffffffffff
[    0.122137] ... max period:             000000007fffffff
[    0.122210] ... fixed-purpose events:   3
[    0.122280] ... event mask:             000000070000000f
[    0.132086] Booting Node   0, Processors  #1
[    0.132197] smpboot cpu 1: start_ip =3D 95000
[    0.165468]  #2
[    0.165533] smpboot cpu 2: start_ip =3D 95000
[    0.196826]  #3 Ok.
[    0.196895] smpboot cpu 3: start_ip =3D 95000
[    0.228074] Brought up 4 CPUs
[    0.228146] Total of 4 processors activated (19954.99 BogoMIPS).
[    0.230839] devtmpfs: initialized
[    0.231027] PM: Registering ACPI NVS region at cade7000 (2097152 bytes)
[    0.231131] Dell Latitude E5420 series board detected. Selecting PCI-met=
hod for reboots.
[    0.231308] NET: Registered protocol family 16
[    0.231423] kworker/u:0 used greatest stack depth: 6656 bytes left
[    0.231514] kworker/u:0 used greatest stack depth: 5688 bytes left
[    0.231729] ACPI FADT declares the system doesn't support PCIe ASPM, so =
disable it
[    0.231832] ACPI: bus type pci registered
[    0.231987] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000=
-0xfbffffff] (base 0xf8000000)
[    0.232092] PCI: not using MMCONFIG
[    0.232162] PCI: Using configuration type 1 for base access
[    0.232240] dmi type 0xB1 record - unknown flag
[    0.233992] kworker/u:0 used greatest stack depth: 5648 bytes left
[    0.235024] bio: create slab <bio-0> at 0
[    0.235181] ACPI: Added _OSI(Module Device)
[    0.235253] ACPI: Added _OSI(Processor Device)
[    0.235325] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.235398] ACPI: Added _OSI(Processor Aggregator Device)
[    0.236845] ACPI: EC: Look up EC in DSDT
[    0.240327] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.250232] ACPI: SSDT 00000000cadd7718 0067C (v01  PmRef  Cpu0Cst 00003=
001 INTL 20090903)
[    0.250760] ACPI: Dynamic OEM Table Load:
[    0.250911] ACPI: SSDT           (null) 0067C (v01  PmRef  Cpu0Cst 00003=
001 INTL 20090903)
[    0.251272] ACPI: SSDT 00000000cadd8a98 00303 (v01  PmRef    ApIst 00003=
000 INTL 20090903)
[    0.251822] ACPI: Dynamic OEM Table Load:
[    0.251972] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003=
000 INTL 20090903)
[    0.253031] ACPI: SSDT 00000000cadd6d98 00119 (v01  PmRef    ApCst 00003=
000 INTL 20090903)
[    0.253553] ACPI: Dynamic OEM Table Load:
[    0.253700] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003=
000 INTL 20090903)
[    0.258992] ACPI: Interpreter enabled
[    0.259064] ACPI: (supports S0 S3 S4 S5)
[    0.259304] ACPI: Using IOAPIC for interrupt routing
[    0.259389] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000=
-0xfbffffff] (base 0xf8000000)
[    0.259818] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in ACP=
I motherboard resources
[    0.302296] ACPI: EC: GPE =3D 0x10, I/O: command/status =3D 0x934, data =
=3D 0x930
[    0.302884] ACPI: No dock devices found.
[    0.302958] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.303301] \_SB_.PCI0:_OSC invalid UUID
[    0.303302] _OSC request data:1 8 1f=20
[    0.303306] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    0.303778] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.303858] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.303933] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x00=
0bffff]
[    0.304035] pci_root PNP0A08:00: host bridge window [mem 0xcfa00000-0xfe=
afffff]
[    0.304137] pci_root PNP0A08:00: host bridge window [mem 0xfed40000-0xfe=
d44fff]
[    0.304284] PCI host bridge to bus 0000:00
[    0.304356] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.304431] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.304506] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.304581] pci_bus 0000:00: root bus resource [mem 0xcfa00000-0xfeaffff=
f]
[    0.304657] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed44ff=
f]
[    0.304739] pci 0000:00:00.0: [8086:0104] type 0 class 0x000600
[    0.304775] pci 0000:00:02.0: [8086:0126] type 0 class 0x000300
[    0.304785] pci 0000:00:02.0: reg 10: [mem 0xe2800000-0xe2bfffff 64bit]
[    0.304791] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit p=
ref]
[    0.304796] pci 0000:00:02.0: reg 20: [io  0x8000-0x803f]
[    0.304850] pci 0000:00:16.0: [8086:1c3a] type 0 class 0x000780
[    0.304874] pci 0000:00:16.0: reg 10: [mem 0xe5480000-0xe548000f 64bit]
[    0.304951] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.304991] pci 0000:00:1a.0: [8086:1c2d] type 0 class 0x000c03
[    0.305012] pci 0000:00:1a.0: reg 10: [mem 0xe5450000-0xe54503ff]
[    0.305103] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.305130] pci 0000:00:1b.0: [8086:1c20] type 0 class 0x000403
[    0.305146] pci 0000:00:1b.0: reg 10: [mem 0xe5440000-0xe5443fff 64bit]
[    0.305215] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.305247] pci 0000:00:1c.0: [8086:1c10] type 1 class 0x000604
[    0.305378] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.305419] pci 0000:00:1c.1: [8086:1c12] type 1 class 0x000604
[    0.305550] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.305590] pci 0000:00:1c.2: [8086:1c14] type 1 class 0x000604
[    0.305721] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.305759] pci 0000:00:1c.5: [8086:1c1a] type 1 class 0x000604
[    0.305847] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.305876] pci 0000:00:1c.6: [8086:1c1c] type 1 class 0x000604
[    0.305961] pci 0000:00:1c.6: PME# supported from D0 D3hot D3cold
[    0.305993] pci 0000:00:1d.0: [8086:1c26] type 0 class 0x000c03
[    0.306014] pci 0000:00:1d.0: reg 10: [mem 0xe5430000-0xe54303ff]
[    0.306105] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.306131] pci 0000:00:1f.0: [8086:1c49] type 0 class 0x000601
[    0.306258] pci 0000:00:1f.2: [8086:1c03] type 0 class 0x000106
[    0.306276] pci 0000:00:1f.2: reg 10: [io  0x80b0-0x80b7]
[    0.306284] pci 0000:00:1f.2: reg 14: [io  0x80a0-0x80a3]
[    0.306293] pci 0000:00:1f.2: reg 18: [io  0x8090-0x8097]
[    0.306301] pci 0000:00:1f.2: reg 1c: [io  0x8080-0x8083]
[    0.306309] pci 0000:00:1f.2: reg 20: [io  0x8060-0x807f]
[    0.306317] pci 0000:00:1f.2: reg 24: [mem 0xe5420000-0xe54207ff]
[    0.306363] pci 0000:00:1f.2: PME# supported from D3hot
[    0.306382] pci 0000:00:1f.3: [8086:1c22] type 0 class 0x000c05
[    0.306398] pci 0000:00:1f.3: reg 10: [mem 0xe5410000-0xe54100ff 64bit]
[    0.306420] pci 0000:00:1f.3: reg 20: [io  0x8040-0x805f]
[    0.306520] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    0.306836] pci 0000:02:00.0: [8086:0082] type 0 class 0x000280
[    0.306985] pci 0000:02:00.0: reg 10: [mem 0xe5300000-0xe5301fff 64bit]
[    0.307703] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.310366] pci 0000:00:1c.1: PCI bridge to [bus 02-02]
[    0.310446] pci 0000:00:1c.1:   bridge window [mem 0xe5300000-0xe53fffff]
[    0.312249] pci 0000:03:00.0: [1217:8134] type 2 class 0x000607
[    0.312294] pci 0000:03:00.0: reg 10: [mem 0xe4030000-0xe4030fff]
[    0.312366] pci 0000:03:00.0: supports D1 D2
[    0.312368] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.312421] pci 0000:00:1c.2: PCI bridge to [bus 03-08]
[    0.312497] pci 0000:00:1c.2:   bridge window [io  0x6000-0x7fff]
[    0.312501] pci 0000:00:1c.2:   bridge window [mem 0xe2c00000-0xe40fffff]
[    0.312507] pci 0000:00:1c.2:   bridge window [mem 0xe0000000-0xe13fffff=
 64bit pref]
[    0.312648] pci 0000:09:00.0: [1217:13f7] type 0 class 0x000c00
[    0.312680] pci 0000:09:00.0: reg 10: [mem 0xe5230000-0xe5230fff]
[    0.312929] pci 0000:09:00.0: supports D1 D2
[    0.312931] pci 0000:09:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.313020] pci 0000:09:00.1: [1217:8321] type 0 class 0x000805
[    0.313054] pci 0000:09:00.1: reg 10: [mem 0xe5220000-0xe52201ff]
[    0.313302] pci 0000:09:00.1: supports D1 D2
[    0.313303] pci 0000:09:00.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.313384] pci 0000:09:00.2: [1217:8331] type 0 class 0x000180
[    0.313417] pci 0000:09:00.2: reg 10: [mem 0xe5210000-0xe52103ff]
[    0.313464] pci 0000:09:00.2: reg 18: [mem 0xe5200000-0xe52003ff]
[    0.313667] pci 0000:09:00.2: supports D1 D2
[    0.313669] pci 0000:09:00.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.315283] pci 0000:00:1c.5: PCI bridge to [bus 09-09]
[    0.315376] pci 0000:00:1c.5:   bridge window [mem 0xe5200000-0xe52fffff]
[    0.315624] pci 0000:0a:00.0: [14e4:1681] type 0 class 0x000200
[    0.315662] pci 0000:0a:00.0: reg 10: [mem 0xe4110000-0xe411ffff 64bit]
[    0.315694] pci 0000:0a:00.0: reg 18: [mem 0xe4100000-0xe410ffff 64bit]
[    0.315884] pci 0000:0a:00.0: PME# supported from D3hot D3cold
[    0.318255] pci 0000:00:1c.6: PCI bridge to [bus 0a-11]
[    0.318353] pci 0000:00:1c.6:   bridge window [io  0x2000-0x5fff]
[    0.318358] pci 0000:00:1c.6:   bridge window [mem 0xe4100000-0xe51fffff]
[    0.318365] pci 0000:00:1c.6:   bridge window [mem 0xe1400000-0xe24fffff=
 64bit pref]
[    0.318391] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.318482] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.318508] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.318535] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP06._PRT]
[    0.318558] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP07._PRT]
[    0.318588] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    0.318648] \_SB_.PCI0:_OSC invalid UUID
[    0.318649] _OSC request data:1 1f 1f=20
[    0.318653]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.318748] \_SB_.PCI0:_OSC invalid UUID
[    0.318749] _OSC request data:1 0 1d=20
[    0.318753]  pci0000:00: ACPI _OSC request failed (AE_ERROR), returned c=
ontrol mask: 0x1d
[    0.318856] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.321951] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 1=
5) *11
[    0.322583] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12 14 1=
5) *10
[    0.323217] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 *5 6 7 10 12 14 =
15)
[    0.323783] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12 14 =
15)
[    0.324349] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 1=
5) *0, disabled.
[    0.325022] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 1=
5) *0, disabled.
[    0.325692] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 *3 4 5 6 7 10 12 14 =
15)
[    0.326257] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12 14 1=
5) *0, disabled.
[    0.327014] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.327122] vgaarb: loaded
[    0.327190] vgaarb: bridge control possible 0000:00:02.0
[    0.327353] SCSI subsystem initialized
[    0.327481] libata version 3.00 loaded.
[    0.327771] wmi: Mapper loaded
[    0.327861] PCI: Using ACPI for IRQ routing
[    0.330050] PCI: pci_cache_line_size set to 64 bytes
[    0.330209] reserve RAM buffer: 000000000009a800 - 000000000009ffff=20
[    0.330211] reserve RAM buffer: 00000000caa83000 - 00000000cbffffff=20
[    0.330213] reserve RAM buffer: 00000000cadb7000 - 00000000cbffffff=20
[    0.330216] reserve RAM buffer: 00000000cb000000 - 00000000cbffffff=20
[    0.330217] reserve RAM buffer: 000000012f000000 - 000000012fffffff=20
[    0.330349] NetLabel: Initializing
[    0.330420] NetLabel:  domain hash size =3D 128
[    0.330491] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    0.330568] NetLabel:  unlabeled traffic allowed by default
[    0.330697] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.331122] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.333215] Switching to clocksource hpet
[    0.333358] pnp: PnP ACPI init
[    0.333442] ACPI: bus type pnp registered
[    0.333758] pnp 00:00: [bus 00-3e]
[    0.333761] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.333762] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.333764] pnp 00:00: [io  0x0d00-0xffff window]
[    0.333766] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.333767] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    0.333769] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    0.333770] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    0.333778] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    0.333780] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    0.333782] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    0.333783] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    0.333785] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    0.333786] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    0.333788] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    0.333789] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    0.333791] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    0.333793] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    0.333794] pnp 00:00: [mem 0xcfa00000-0xfeafffff window]
[    0.333796] pnp 00:00: [mem 0xfed40000-0xfed44fff window]
[    0.333854] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (a=
ctive)
[    0.333868] pnp 00:01: [io  0x0000-0x001f]
[    0.333869] pnp 00:01: [io  0x0081-0x0091]
[    0.333871] pnp 00:01: [io  0x0093-0x009f]
[    0.333873] pnp 00:01: [io  0x00c0-0x00df]
[    0.333875] pnp 00:01: [dma 4]
[    0.333908] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.333916] pnp 00:02: [mem 0xff000000-0xffffffff]
[    0.333953] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
[    0.334016] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    0.334061] system 00:03: [mem 0xfed00000-0xfed003ff] has been reserved
[    0.334147] system 00:03: Plug and Play ACPI device, IDs PNP0103 PNP0c01=
 (active)
[    0.334155] pnp 00:04: [io  0x00f0]
[    0.334165] pnp 00:04: [irq 13]
[    0.334199] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.334214] pnp 00:05: [io  0x002e-0x002f]
[    0.334216] pnp 00:05: [io  0x004e-0x004f]
[    0.334218] pnp 00:05: [io  0x0061]
[    0.334220] pnp 00:05: [io  0x0063]
[    0.334221] pnp 00:05: [io  0x0065]
[    0.334223] pnp 00:05: [io  0x0067]
[    0.334225] pnp 00:05: [io  0x0070]
[    0.334226] pnp 00:05: [io  0x0080]
[    0.334228] pnp 00:05: [io  0x0092]
[    0.334229] pnp 00:05: [io  0x00b2-0x00b3]
[    0.334231] pnp 00:05: [io  0x0680-0x069f]
[    0.334232] pnp 00:05: [io  0x1000-0x100f]
[    0.334234] pnp 00:05: [io  0xffff]
[    0.334235] pnp 00:05: [io  0xffff]
[    0.334236] pnp 00:05: [io  0x0400-0x047f]
[    0.334238] pnp 00:05: [io  0x0500-0x057f]
[    0.334239] pnp 00:05: [io  0x164e-0x164f]
[    0.334292] system 00:05: [io  0x0680-0x069f] has been reserved
[    0.334399] system 00:05: [io  0x1000-0x100f] has been reserved
[    0.334473] system 00:05: [io  0xffff] has been reserved
[    0.334547] system 00:05: [io  0xffff] has been reserved
[    0.334620] system 00:05: [io  0x0400-0x047f] has been reserved
[    0.334693] system 00:05: [io  0x0500-0x057f] has been reserved
[    0.334768] system 00:05: [io  0x164e-0x164f] has been reserved
[    0.334843] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.334851] pnp 00:06: [io  0x0070-0x0077]
[    0.334858] pnp 00:06: [irq 8]
[    0.334896] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.334911] pnp 00:07: [io  0x0060]
[    0.334912] pnp 00:07: [io  0x0064]
[    0.334920] pnp 00:07: [irq 1]
[    0.334954] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.354684] pnp 00:08: Plug and Play ACPI device, IDs PNP0401 (disabled)
[    0.354699] pnp 00:09: [irq 12]
[    0.354735] pnp 00:09: Plug and Play ACPI device, IDs DLL049b PNP0f13 (a=
ctive)
[    0.354837] pnp 00:0a: [mem 0xfed1c000-0xfed1ffff]
[    0.354838] pnp 00:0a: [mem 0xfed10000-0xfed17fff]
[    0.354840] pnp 00:0a: [mem 0xfed18000-0xfed18fff]
[    0.354841] pnp 00:0a: [mem 0xfed19000-0xfed19fff]
[    0.354843] pnp 00:0a: [mem 0xf8000000-0xfbffffff]
[    0.354844] pnp 00:0a: [mem 0xfed20000-0xfed3ffff]
[    0.354846] pnp 00:0a: [mem 0xfed90000-0xfed93fff]
[    0.354847] pnp 00:0a: [mem 0xfed45000-0xfed8ffff]
[    0.354849] pnp 00:0a: [mem 0xff000000-0xffffffff]
[    0.354852] pnp 00:0a: [mem 0xfee00000-0xfeefffff]
[    0.354854] pnp 00:0a: [mem 0x00000000-0xffffffffffffffff disabled]
[    0.354855] pnp 00:0a: [mem 0x00000000-0xffffffffffffffff disabled]
[    0.354916] system 00:0a: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.354994] system 00:0a: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.355069] system 00:0a: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.355145] system 00:0a: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.355220] system 00:0a: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.355303] system 00:0a: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.355377] system 00:0a: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.355452] system 00:0a: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.355528] system 00:0a: [mem 0xff000000-0xffffffff] could not be reser=
ved
[    0.355603] system 00:0a: [mem 0xfee00000-0xfeefffff] has been reserved
[    0.355679] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.355733] pnp 00:0b: [irq 23]
[    0.355777] pnp 00:0b: Plug and Play ACPI device, IDs SMO8800 (active)
[    0.382119] pnp 00:0c: [mem 0x20000000-0x201fffff]
[    0.382121] pnp 00:0c: [mem 0x40000000-0x401fffff]
[    0.382186] system 00:0c: [mem 0x20000000-0x201fffff] has been reserved
[    0.382270] system 00:0c: [mem 0x40000000-0x401fffff] has been reserved
[    0.382346] system 00:0c: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.382354] pnp: PnP ACPI: found 13 devices
[    0.382426] ACPI: ACPI bus type pnp unregistered
[    0.389744] PCI: max bus depth: 2 pci_try_num: 3
[    0.389796] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    0.389881] pci 0000:00:1c.1: PCI bridge to [bus 02-02]
[    0.389957] pci 0000:00:1c.1:   bridge window [mem 0xe5300000-0xe53fffff]
[    0.390041] pci 0000:03:00.0: BAR 16: can't assign mem (size 0x4000000)
[    0.390117] pci 0000:03:00.0: BAR 15: can't assign mem pref (size 0x4000=
000)
[    0.390194] pci 0000:03:00.0: BAR 14: assigned [io  0x6000-0x60ff]
[    0.390274] pci 0000:03:00.0: BAR 13: assigned [io  0x6400-0x64ff]
[    0.390348] pci 0000:03:00.0: CardBus bridge to [bus 04-07]
[    0.390422] pci 0000:03:00.0:   bridge window [io  0x6400-0x64ff]
[    0.390499] pci 0000:03:00.0:   bridge window [io  0x6000-0x60ff]
[    0.390579] pci 0000:00:1c.2: PCI bridge to [bus 03-08]
[    0.390654] pci 0000:00:1c.2:   bridge window [io  0x6000-0x7fff]
[    0.390732] pci 0000:00:1c.2:   bridge window [mem 0xe2c00000-0xe40fffff]
[    0.390809] pci 0000:00:1c.2:   bridge window [mem 0xe0000000-0xe13fffff=
 64bit pref]
[    0.390916] pci 0000:00:1c.5: PCI bridge to [bus 09-09]
[    0.390992] pci 0000:00:1c.5:   bridge window [mem 0xe5200000-0xe52fffff]
[    0.391074] pci 0000:00:1c.6: PCI bridge to [bus 0a-11]
[    0.391148] pci 0000:00:1c.6:   bridge window [io  0x2000-0x5fff]
[    0.391225] pci 0000:00:1c.6:   bridge window [mem 0xe4100000-0xe51fffff]
[    0.391320] pci 0000:00:1c.6:   bridge window [mem 0xe1400000-0xe24fffff=
 64bit pref]
[    0.391466] pci 0000:03:00.0: setting latency timer to 64
[    0.391480] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.391482] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.391484] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.391485] pci_bus 0000:00: resource 7 [mem 0xcfa00000-0xfeafffff]
[    0.391487] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed44fff]
[    0.391489] pci_bus 0000:02: resource 1 [mem 0xe5300000-0xe53fffff]
[    0.391491] pci_bus 0000:03: resource 0 [io  0x6000-0x7fff]
[    0.391493] pci_bus 0000:03: resource 1 [mem 0xe2c00000-0xe40fffff]
[    0.391494] pci_bus 0000:03: resource 2 [mem 0xe0000000-0xe13fffff 64bit=
 pref]
[    0.391496] pci_bus 0000:04: resource 0 [io  0x6400-0x64ff]
[    0.391498] pci_bus 0000:04: resource 1 [io  0x6000-0x60ff]
[    0.391499] pci_bus 0000:09: resource 1 [mem 0xe5200000-0xe52fffff]
[    0.391501] pci_bus 0000:0a: resource 0 [io  0x2000-0x5fff]
[    0.391503] pci_bus 0000:0a: resource 1 [mem 0xe4100000-0xe51fffff]
[    0.391505] pci_bus 0000:0a: resource 2 [mem 0xe1400000-0xe24fffff 64bit=
 pref]
[    0.391527] NET: Registered protocol family 2
[    0.391715] IP route cache hash table entries: 131072 (order: 8, 1048576=
 bytes)
[    0.392630] TCP established hash table entries: 524288 (order: 11, 83886=
08 bytes)
[    0.393912] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.394120] TCP: Hash tables configured (established 524288 bind 65536)
[    0.394195] TCP reno registered
[    0.394289] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.394380] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.394515] NET: Registered protocol family 1
[    0.394596] pci 0000:00:02.0: Boot video device
[    0.394896] PCI: CLS 64 bytes, default 64
[    0.394915] DMAR: No ATSR found
[    0.395008] IOMMU 0 0xfed90000: using Queued invalidation
[    0.395081] IOMMU 1 0xfed91000: using Queued invalidation
[    0.395155] IOMMU: Setting RMRR:
[    0.395241] IOMMU: Setting identity map for device 0000:00:02.0 [0xcb800=
000 - 0xcf9fffff]
[    0.395712] IOMMU: Setting identity map for device 0000:00:1d.0 [0xcadc6=
000 - 0xcadd5fff]
[    0.395835] IOMMU: Setting identity map for device 0000:00:1a.0 [0xcadc6=
000 - 0xcadd5fff]
[    0.395947] IOMMU: Prepare 0-16MiB unity mapping for LPC
[    0.396512] IOMMU: Setting identity map for device 0000:00:1f.0 [0x0 - 0=
xffffff]
[    0.396853] PCI-DMA: Intel(R) Virtualization Technology for Directed I/O
[    0.396945] ------------[ cut here ]------------
[    0.397019] WARNING: at drivers/pci/search.c:44 pci_find_upstream_pcie_b=
ridge+0x5e/0x70()
[    0.397121] Hardware name: Latitude E5420
[    0.397192] Modules linked in:
[    0.397306] Pid: 1, comm: BFS/0 Not tainted 3.3.4-pf #3
[    0.397378] Call Trace:
[    0.397450]  [<ffffffff8103103b>] ? warn_slowpath_common+0x7b/0xc0
[    0.397526]  [<ffffffff812083de>] ? pci_find_upstream_pcie_bridge+0x5e/0=
x70
[    0.397604]  [<ffffffff8137dd85>] ? intel_iommu_device_group+0x75/0x100
[    0.397681]  [<ffffffff81378683>] ? add_iommu_group+0x33/0x60
[    0.397755]  [<ffffffff81378650>] ? bus_set_iommu+0x40/0x40
[    0.397831]  [<ffffffff812f3f7d>] ? bus_for_each_dev+0x4d/0x80
[    0.397906]  [<ffffffff81378643>] ? bus_set_iommu+0x33/0x40
[    0.397980]  [<ffffffff818aaaac>] ? intel_iommu_init+0xa21/0xaae
[    0.398056]  [<ffffffff81112614>] ? vfsmount_lock_local_unlock+0x24/0x40
[    0.398133]  [<ffffffff81105a95>] ? sys_mkdirat+0x75/0xd0
[    0.398207]  [<ffffffff81883dd1>] ? memblock_find_dma_reserve+0x13e/0x13e
[    0.398286]  [<ffffffff81883ddf>] ? pci_iommu_init+0xe/0x37
[    0.398360]  [<ffffffff810001c9>] ? do_one_initcall+0x39/0x170
[    0.398436]  [<ffffffff81880b38>] ? kernel_init+0xda/0x154
[    0.398510]  [<ffffffff81488f54>] ? kernel_thread_helper+0x4/0x10
[    0.398586]  [<ffffffff81880a5e>] ? start_kernel+0x2e1/0x2e1
[    0.398661]  [<ffffffff81488f50>] ? gs_change+0xb/0xb
[    0.398736] ---[ end trace e93713a9d40cd06c ]---
[    0.400398] Simple Boot Flag at 0xf3 set to 0x1
[    0.401171] microcode: CPU0 sig=3D0x206a7, pf=3D0x10, revision=3D0x15
[    0.401264] microcode: CPU1 sig=3D0x206a7, pf=3D0x10, revision=3D0x15
[    0.401344] microcode: CPU2 sig=3D0x206a7, pf=3D0x10, revision=3D0x15
[    0.401431] microcode: CPU3 sig=3D0x206a7, pf=3D0x10, revision=3D0x15
[    0.401540] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    0.402057] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.404834] VFS: Disk quotas dquot_6.5.2
[    0.404957] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.405509] msgmni has been set to 7836
[    0.405792] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 253)
[    0.405896] io scheduler noop registered
[    0.406037] io scheduler bfq registered (default)
[    0.406543] intel_idle: MWAIT substates: 0x21120
[    0.406544] intel_idle: v0.4 model 0x2A
[    0.406546] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.407115] ACPI: AC Adapter [AC] (on-line)
[    0.407294] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:=
00/input/input0
[    0.407776] ACPI: Lid Switch [LID]
[    0.407902] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0=
C:00/input/input1
[    0.408023] ACPI: Power Button [PBTN]
[    0.408141] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0=
E:00/input/input2
[    0.408261] ACPI: Sleep Button [SBTN]
[    0.408375] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input3
[    0.408488] ACPI: Power Button [PWRF]
[    0.486225] thermal LNXTHERM:00: registered as thermal_zone0
[    0.486300] ACPI: Thermal Zone [THM] (25 C)
[    0.486538] GHES: HEST is not enabled!
[    0.486713] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.486727] ACPI: Battery Slot [BAT0] (battery absent)
[    0.487475] Non-volatile memory driver v1.3
[    0.487592] Linux agpgart interface v0.103
[    0.487717] agpgart-intel 0000:00:00.0: Intel Sandybridge Chipset
[    0.487919] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K tota=
l, 262144K mappable
[    0.489164] agpgart-intel 0000:00:00.0: detected 65536K stolen memory
[    0.489360] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    0.489510] [drm] Initialized drm 1.1.0 20060810
[    0.489603] i915 0000:00:02.0: setting latency timer to 64
[    0.555003] i915 0000:00:02.0: irq 42 for MSI/MSI-X
[    0.555011] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    0.555095] [drm] Driver supports precise vblank timestamp query.
[    0.555196] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=
=3Dio+mem,decodes=3Dio+mem:owns=3Dio+mem
[    1.042970] fbcon: inteldrmfb (fb0) is primary device
[    1.401008] Refined TSC clocksource calibration: 2494.333 MHz.
[    1.401016] Switching to clocksource tsc
[    1.441049] Console: switching to colour frame buffer device 200x112
[    1.444122] fb0: inteldrmfb frame buffer device
[    1.444124] drm: registered panic notifier
[    1.551786] acpi device:36: registered as cooling_device4
[    1.565071] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:0=
0/LNXVIDEO:00/input/input4
[    1.565096] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    1.565144] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on mi=
nor 0
[    1.566490] brd: module loaded
[    1.566631] ahci 0000:00:1f.2: version 3.0
[    1.566687] ahci 0000:00:1f.2: irq 43 for MSI/MSI-X
[    1.566714] ahci: SSS flag set, parallel bus scan disabled
[    1.577754] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x=
3b impl SATA mode
[    1.577811] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio=
 slum part ems sxs apst=20
[    1.577835] ahci 0000:00:1f.2: setting latency timer to 64
[    1.586396] scsi0 : ahci
[    1.586479] scsi1 : ahci
[    1.586550] scsi2 : ahci
[    1.586620] scsi3 : ahci
[    1.586689] scsi4 : ahci
[    1.586769] scsi5 : ahci
[    1.587091] ata1: SATA max UDMA/133 abar m2048@0xe5420000 port 0xe542010=
0 irq 43
[    1.587112] ata2: SATA max UDMA/133 abar m2048@0xe5420000 port 0xe542018=
0 irq 43
[    1.587130] ata3: DUMMY
[    1.587140] ata4: SATA max UDMA/133 abar m2048@0xe5420000 port 0xe542028=
0 irq 43
[    1.587158] ata5: SATA max UDMA/133 abar m2048@0xe5420000 port 0xe542030=
0 irq 43
[    1.587177] ata6: SATA max UDMA/133 abar m2048@0xe5420000 port 0xe542038=
0 irq 43
[    1.587414] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0=
x60,0x64 irq 1,12
[    1.587652] i8042: Warning: Keylock active
[    1.588963] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.588996] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.589090] mousedev: PS/2 mouse device common for all mice
[    1.589345] rtc_cmos 00:06: RTC can wake from S4
[    1.589483] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    1.589531] rtc0: alarms up to one year, y3k, 242 bytes nvram, hpet irqs
[    1.589582] ACPI Warning: 0x0000000000008040-0x000000000000805f SystemIO=
 conflicts with Region \_SB_.PCI0.SBUS.SMBI 1 (20120111/utaddress-251)
[    1.589614] ACPI: If an ACPI driver is available for this device, you sh=
ould use it instead of the native driver
[    1.589796] EDAC MC: Ver: 2.1.0
[    1.590211] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input5
[    1.590231] cpuidle: using governor ladder
[    1.590331] cpuidle: using governor menu
[    1.590570] EFI Variables Facility v0.08 2004-May-17
[    1.590667] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    1.604640] input: Dell WMI hotkeys as /devices/virtual/input/input6
[    1.605629] dell_wmi_aio: No known WMI GUID found
[    1.605702] intel_oaktrail: Platform not recognized (You could try the m=
odule's force-parameter)
[    1.605878] TCP cubic registered
[    1.605891] TCP vegas registered
[    1.605901] TCP yeah registered
[    1.605910] Initializing XFRM netlink socket
[    1.606063] NET: Registered protocol family 10
[    1.606484] NET: Registered protocol family 17
[    1.606499] Registering the dns_resolver key type
[    1.606530] TuxOnIce 3.2.1 (http://tuxonice.net)
[    1.891346] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.899979] ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (unknown) rejected by=
 device (Stat=3D0x51 Err=3D0x04)
[    1.940525] ata1.00: ATA-8: ST9320423AS, D005SDM1, max UDMA/133
[    1.940583] ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    1.950031] ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (unknown) rejected by=
 device (Stat=3D0x51 Err=3D0x04)
[    1.950495] ata1.00: configured for UDMA/133
[    1.952366] scsi 0:0:0:0: Direct-Access     ATA      ST9320423AS      D0=
05 PQ: 0 ANSI: 5
[    1.952534] sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB=
/298 GiB)
[    1.952599] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.952607] sd 0:0:0:0: [sda] Write Protect is off
[    1.952610] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.952628] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    2.005590]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[    2.005979] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.256879] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.268693] ata2.00: ATAPI: TSSTcorp DVD+/-RW TS-L633J, D400, max UDMA/1=
00
[    2.284047] ata2.00: configured for UDMA/100
[    2.293996] scsi 1:0:0:0: CD-ROM            TSSTcorp DVD+-RW TS-L633J D4=
00 PQ: 0 ANSI: 5
[    2.301864] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 =
cdda tray
[    2.301884] cdrom: Uniform CD-ROM driver Revision: 3.20
[    2.302019] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    2.302084] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    2.606418] ata4: SATA link down (SStatus 0 SControl 300)
[    2.911024] ata5: SATA link down (SStatus 0 SControl 300)
[    3.215630] ata6: SATA link down (SStatus 0 SControl 300)
[    3.216064] TuxOnIce: No image found.
[    3.217522] Restarting tasks ... Restarting kernel threads ... done.
[    3.217613] done.
[    3.344896] PM: Checking hibernation image partition /dev/sda3
[    3.344914] PM: Hibernation image partition 8:3 present
[    3.344929] PM: Looking for hibernation image.
[    3.346412] PM: Image not found (code -22)
[    3.346418] PM: Hibernation image not present or could not be loaded.
[    3.346426] registered taskstats version 1
[    3.363157] EXT4-fs (sda5): couldn't mount as ext3 due to feature incomp=
atibilities
[    3.363982] EXT4-fs (sda5): couldn't mount as ext2 due to feature incomp=
atibilities
[    3.413373] EXT4-fs (sda5): mounted filesystem with ordered data mode. O=
pts: (null)
[    3.413400] VFS: Mounted root (ext4 filesystem) readonly on device 8:5.
[    3.414126] Freeing unused kernel memory: 556k freed
[    3.414197] Write protecting the kernel read-only data: 8192k
[    3.417593] Freeing unused kernel memory: 1468k freed
[    3.419091] Freeing unused kernel memory: 556k freed
[    3.419175] BFS CPU scheduler v0.420 by Con Kolivas.
[    4.631436] systemd-getty-g used greatest stack depth: 5304 bytes left
[    4.638953] systemd-cryptse used greatest stack depth: 5008 bytes left
[    6.202399] udevd[857]: starting version 182
[    7.419395] EXT4-fs (sda5): re-mounted. Opts: (null)
[    7.576449] usbcore: registered new interface driver usbfs
[    7.577462] usbcore: registered new interface driver hub
[    7.578409] usbcore: registered new device driver usb
[    7.633633] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    7.634647] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    7.634651] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    7.635574] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus =
number 1
[    7.636488] ehci_hcd 0000:00:1a.0: debug port 2
[    7.641322] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    7.641338] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xe5450000
[    7.647882] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    7.648798] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    7.649652] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    7.650531] usb usb1: Product: EHCI Host Controller
[    7.651409] usb usb1: Manufacturer: Linux 3.3.4-pf ehci_hcd
[    7.652411] usb usb1: SerialNumber: 0000:00:1a.0
[    7.653472] hub 1-0:1.0: USB hub found
[    7.654335] hub 1-0:1.0: 2 ports detected
[    7.655331] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    7.655336] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    7.656246] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus =
number 2
[    7.657153] ehci_hcd 0000:00:1d.0: debug port 2
[    7.661893] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    7.661909] ehci_hcd 0000:00:1d.0: irq 17, io mem 0xe5430000
[    7.667831] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    7.668803] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    7.669704] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    7.670597] usb usb2: Product: EHCI Host Controller
[    7.671524] usb usb2: Manufacturer: Linux 3.3.4-pf ehci_hcd
[    7.672434] usb usb2: SerialNumber: 0000:00:1d.0
[    7.673518] hub 2-0:1.0: USB hub found
[    7.674442] hub 2-0:1.0: 2 ports detected
[    7.956514] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[    8.071928] usb 1-1: New USB device found, idVendor=3D8087, idProduct=3D=
0024
[    8.072930] usb 1-1: New USB device strings: Mfr=3D0, Product=3D0, Seria=
lNumber=3D0
[    8.074259] hub 1-1:1.0: USB hub found
[    8.075347] hub 1-1:1.0: 6 ports detected
[    8.179185] usb 2-1: new high-speed USB device number 2 using ehci_hcd
[    8.294432] usb 2-1: New USB device found, idVendor=3D8087, idProduct=3D=
0024
[    8.295452] usb 2-1: New USB device strings: Mfr=3D0, Product=3D0, Seria=
lNumber=3D0
[    8.296784] hub 2-1:1.0: USB hub found
[    8.297931] hub 2-1:1.0: 6 ports detected
[    8.373084] usb 1-1.4: new high-speed USB device number 3 using ehci_hcd
[    8.628624] usb 1-1.4: New USB device found, idVendor=3D1bcf, idProduct=
=3D280b
[    8.629714] usb 1-1.4: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[    8.630777] usb 1-1.4: Product: Laptop_Integrated_Webcam_FHD
[    8.631813] usb 1-1.4: Manufacturer: CN0CJ3P27248715OB5MJA00
[    8.688937] Adding 8388604k swap on /dev/sda3.  Priority:0 extents:1 acr=
oss:8388604k=20
[    8.921423] usb 2-1.4: new high-speed USB device number 3 using ehci_hcd
[    8.968256] cfg80211: Calling CRDA to update world regulatory domain
[    9.008743] usb 2-1.4: New USB device found, idVendor=3D05e3, idProduct=
=3D0608
[    9.009860] usb 2-1.4: New USB device strings: Mfr=3D0, Product=3D1, Ser=
ialNumber=3D0
[    9.010987] usb 2-1.4: Product: USB2.0 Hub
[    9.012604] hub 2-1.4:1.0: USB hub found
[    9.014003] hub 2-1.4:1.0: 4 ports detected
[    9.070484] Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:d
[    9.071667] Copyright(c) 2003-2011 Intel Corporation
[    9.072992] iwlwifi 0000:02:00.0: pci_resource_len =3D 0x00002000
[    9.074145] iwlwifi 0000:02:00.0: pci_resource_base =3D ffffc900050f0000
[    9.075338] iwlwifi 0000:02:00.0: HW Revision ID =3D 0x34
[    9.077054] iwlwifi 0000:02:00.0: irq 44 for MSI/MSI-X
[    9.077170] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_DEBUG enabled
[    9.078295] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
[    9.079457] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
[    9.079542] usb 2-1.6: new full-speed USB device number 4 using ehci_hcd
[    9.081724] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE enabled
[    9.082896] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_P2P enabled
[    9.084014] iwlwifi 0000:02:00.0: U iwl_probe *** LOAD DRIVER ***
[    9.085150] iwlwifi 0000:02:00.0: U iwl_probe BT channel inhibition is On
[    9.086317] iwlwifi 0000:02:00.0: Detected Intel(R) Centrino(R) Advanced=
-N 6205 AGN, REV=3D0xB0
[    9.087500] iwlwifi 0000:02:00.0: U iwl_trans_pcie_prepare_card_hw iwl_t=
rans_prepare_card_hw enter
[    9.088667] iwlwifi 0000:02:00.0: U iwl_set_hw_ready hardware ready
[    9.089879] iwlwifi 0000:02:00.0: U iwl_apm_init Init card's basic funct=
ions
[    9.091076] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[    9.109192] iwlwifi 0000:02:00.0: U iwl_apm_stop Stop card, put in low p=
ower state
[    9.110337] iwlwifi 0000:02:00.0: U iwl_apm_stop_master stop master
[    9.111542] iwlwifi 0000:02:00.0: device EEPROM VER=3D0x715, CALIB=3D0x6
[    9.112677] iwlwifi 0000:02:00.0: Device SKU: 0x1F0
[    9.113823] iwlwifi 0000:02:00.0: Valid Tx ant: 0x3, Valid Rx ant: 0x3
[    9.114957] iwlwifi 0000:02:00.0: U iwl_probe MAC address: a0:88:b4:6f:4=
e:2c
[    9.116118] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[    9.117308] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 1 Freq=3D2412[=
2.4GHz] valid flag=3D0x20
[    9.118490] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 2 Freq=3D2417[=
2.4GHz] valid flag=3D0x20
[    9.119627] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 3 Freq=3D2422[=
2.4GHz] valid flag=3D0x20
[    9.120789] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 4 Freq=3D2427[=
2.4GHz] valid flag=3D0x20
[    9.121901] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 5 Freq=3D2432[=
2.4GHz] valid flag=3D0x0
[    9.123027] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 6 Freq=3D2437[=
2.4GHz] valid flag=3D0x0
[    9.124123] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 7 Freq=3D2442[=
2.4GHz] valid flag=3D0x0
[    9.125220] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 8 Freq=3D2447[=
2.4GHz] valid flag=3D0x10
[    9.126298] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 9 Freq=3D2452[=
2.4GHz] valid flag=3D0x10
[    9.127467] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 10 Freq=3D2457=
[2.4GHz] valid flag=3D0x10
[    9.128526] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 11 Freq=3D2462=
[2.4GHz] valid flag=3D0x10
[    9.129602] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 12 Freq=3D2467=
[2.4GHz] valid flag=3D0x36
[    9.130637] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 13 Freq=3D2472=
[2.4GHz] valid flag=3D0x36
[    9.131704] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 36 Freq=3D5180=
[5.2GHz] valid flag=3D0x26
[    9.132735] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 40 Freq=3D5200=
[5.2GHz] valid flag=3D0x16
[    9.133774] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 44 Freq=3D5220=
[5.2GHz] valid flag=3D0x26
[    9.134792] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 48 Freq=3D5240=
[5.2GHz] valid flag=3D0x16
[    9.135823] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 52 Freq=3D5260=
[5.2GHz] valid flag=3D0x2E
[    9.136830] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 56 Freq=3D5280=
[5.2GHz] valid flag=3D0x1E
[    9.137866] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 60 Freq=3D5300=
[5.2GHz] valid flag=3D0x2E
[    9.138909] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 64 Freq=3D5320=
[5.2GHz] valid flag=3D0x1E
[    9.139885] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 100 Freq=3D550=
0[5.2GHz] valid flag=3D0x2E
[    9.140880] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 104 Freq=3D552=
0[5.2GHz] valid flag=3D0x1E
[    9.141820] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 108 Freq=3D554=
0[5.2GHz] valid flag=3D0x2E
[    9.142784] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 112 Freq=3D556=
0[5.2GHz] valid flag=3D0x1E
[    9.143699] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 116 Freq=3D558=
0[5.2GHz] valid flag=3D0x2E
[    9.144625] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 120 Freq=3D560=
0[5.2GHz] valid flag=3D0x1E
[    9.145516] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 124 Freq=3D562=
0[5.2GHz] valid flag=3D0x2E
[    9.146441] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 128 Freq=3D564=
0[5.2GHz] valid flag=3D0x1E
[    9.147325] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 132 Freq=3D566=
0[5.2GHz] valid flag=3D0x2E
[    9.148237] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 136 Freq=3D568=
0[5.2GHz] valid flag=3D0x1E
[    9.149110] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 140 Freq=3D570=
0[5.2GHz] valid flag=3D0x3E
[    9.149993] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 149 Freq=3D574=
5[5.2GHz] valid flag=3D0x26
[    9.150832] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 153 Freq=3D576=
5[5.2GHz] valid flag=3D0x16
[    9.151669] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 157 Freq=3D578=
5[5.2GHz] valid flag=3D0x26
[    9.152549] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 161 Freq=3D580=
5[5.2GHz] valid flag=3D0x16
[    9.153378] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 165 Freq=3D582=
5[5.2GHz] valid flag=3D0x36
[    9.154237] iwlwifi 0000:02:00.0: Tunable channels: 13 802.11bg, 24 802.=
11a channels
[    9.155159] iwlwifi 0000:02:00.0: U iwl_request_firmware attempting to l=
oad firmware EXPERIMENTAL 'iwlwifi-6000g2a-exp.ucode'
[    9.158556] usb 2-1.6: New USB device found, idVendor=3D413c, idProduct=
=3D8187
[    9.159491] usb 2-1.6: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D3
[    9.160362] usb 2-1.6: Product: DW375 Bluetooth Module
[    9.161227] usb 2-1.6: Manufacturer: Dell Computer Corp
[    9.162117] usb 2-1.6: SerialNumber: C0F8DAE4FAE3
[    9.280053] usb 2-1.4.2: new low-speed USB device number 5 using ehci_hcd
[    9.286411] cfg80211: World regulatory domain updated:
[    9.287295] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenn=
a_gain, max_eirp)
[    9.288175] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mB=
i, 2000 mBm)
[    9.289045] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mB=
i, 2000 mBm)
[    9.289904] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mB=
i, 2000 mBm)
[    9.290756] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mB=
i, 2000 mBm)
[    9.291598] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mB=
i, 2000 mBm)
[    9.304648] iwlwifi 0000:02:00.0: U iwl_request_firmware attempting to l=
oad firmware 'iwlwifi-6000g2a-6.ucode'
[    9.305837] iwlwifi 0000:02:00.0: U iwl_request_firmware attempting to l=
oad firmware 'iwlwifi-6000g2a-5.ucode'
[    9.368764] iwlwifi 0000:02:00.0: U iwl_ucode_callback Loaded firmware f=
ile 'iwlwifi-6000g2a-5.ucode' (444128 bytes).
[    9.369682] iwlwifi 0000:02:00.0: loaded firmware version 17.168.5.3 bui=
ld 42301
[    9.369777] usb 2-1.4.2: New USB device found, idVendor=3D046a, idProduc=
t=3D0023
[    9.369781] usb 2-1.4.2: New USB device strings: Mfr=3D0, Product=3D0, S=
erialNumber=3D0
[    9.372628] iwlwifi 0000:02:00.0: U iwl_ucode_callback f/w package hdr u=
code version raw =3D 0x11a80503
[    9.373602] iwlwifi 0000:02:00.0: U iwl_ucode_callback f/w package hdr r=
untime inst size =3D 149504
[    9.374679] iwlwifi 0000:02:00.0: U iwl_ucode_callback f/w package hdr r=
untime data size =3D 81920
[    9.375680] iwlwifi 0000:02:00.0: U iwl_ucode_callback f/w package hdr i=
nit inst size =3D 130552
[    9.376659] iwlwifi 0000:02:00.0: U iwl_ucode_callback f/w package hdr i=
nit data size =3D 81920
[    9.377760] Registered led device: phy0-led
[    9.377920] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[    9.433882] usb 2-1.4.4: new high-speed USB device number 6 using ehci_h=
cd
[    9.511246] usb 2-1.4.4: New USB device found, idVendor=3D05e3, idProduc=
t=3D0608
[    9.512274] usb 2-1.4.4: New USB device strings: Mfr=3D0, Product=3D1, S=
erialNumber=3D0
[    9.513272] usb 2-1.4.4: Product: USB2.0 Hub
[    9.514786] hub 2-1.4.4:1.0: USB hub found
[    9.516140] hub 2-1.4.4:1.0: 4 ports detected
[    9.567403] snd_hda_intel 0000:00:1b.0: irq 45 for MSI/MSI-X
[    9.744394] EXT4-fs (sda6): mounted filesystem with ordered data mode. O=
pts: (null)
[    9.783461] usb 2-1.4.4.1: new high-speed USB device number 7 using ehci=
_hcd
[    9.863018] usb 2-1.4.4.1: New USB device found, idVendor=3D05e3, idProd=
uct=3D0723
[    9.864152] usb 2-1.4.4.1: New USB device strings: Mfr=3D3, Product=3D4,=
 SerialNumber=3D0
[    9.865216] usb 2-1.4.4.1: Product: USB Storage
[    9.866390] usb 2-1.4.4.1: Manufacturer: Generic=20
[    9.899375] input: DualPoint Stick as /devices/platform/i8042/serio1/inp=
ut/input7
[    9.913427] input: AlpsPS/2 ALPS DualPoint TouchPad as /devices/platform=
/i8042/serio1/input/input8
[    9.931187] usb 2-1.4.4.4: new low-speed USB device number 8 using ehci_=
hcd
[   10.010826] usb 2-1.4.4.4: New USB device found, idVendor=3D093a, idProd=
uct=3D2510
[   10.012016] usb 2-1.4.4.4: New USB device strings: Mfr=3D1, Product=3D2,=
 SerialNumber=3D0
[   10.013154] usb 2-1.4.4.4: Product: USB OPTICAL MOUSE
[   10.014290] usb 2-1.4.4.4: Manufacturer: PIXART
[   10.153462] net.wlan0 used greatest stack depth: 4968 bytes left
[   10.178948] Linux video capture interface: v2.00
[   10.213251] uvcvideo: Found UVC 1.00 device Laptop_Integrated_Webcam_FHD=
 (1bcf:280b)
[   10.247895] input: Laptop_Integrated_Webcam_FHD as /devices/pci0000:00/0=
000:00:1a.0/usb1/1-1/1-1.4/1-1.4:1.0/input/input9
[   10.249167] usbcore: registered new interface driver uvcvideo
[   10.250304] USB Video Class driver (1.1.1)
[   11.222118] Initializing USB Mass Storage driver...
[   11.223298] usb-storage 2-1.4.4.1:1.0: Quirks match for vid 05e3 pid 072=
3: 8000
[   11.224381] scsi6 : usb-storage 2-1.4.4.1:1.0
[   11.225630] usbcore: registered new interface driver usb-storage
[   11.226767] USB Mass Storage support registered.
[   11.365057] HDMI status: Codec=3D3 Pin=3D5 Presence_Detect=3D0 ELD_Valid=
=3D0
[   11.366221] HDMI status: Codec=3D3 Pin=3D6 Presence_Detect=3D0 ELD_Valid=
=3D0
[   11.367381] HDMI status: Codec=3D3 Pin=3D7 Presence_Detect=3D0 ELD_Valid=
=3D0
[   11.368574] input: HDA Intel PCH HDMI/DP,pcm=3D8 as /devices/pci0000:00/=
0000:00:1b.0/sound/card0/input10
[   11.369793] input: HDA Intel PCH HDMI/DP,pcm=3D7 as /devices/pci0000:00/=
0000:00:1b.0/sound/card0/input11
[   11.370994] input: HDA Intel PCH HDMI/DP,pcm=3D3 as /devices/pci0000:00/=
0000:00:1b.0/sound/card0/input12
[   11.372205] input: HDA Intel PCH Dock Mic as /devices/pci0000:00/0000:00=
:1b.0/sound/card0/input13
[   11.373521] input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1b.0=
/sound/card0/input14
[   11.374731] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:0=
0:1b.0/sound/card0/input15
[   11.375967] input: HDA Intel PCH Dock Line Out as /devices/pci0000:00/00=
00:00:1b.0/sound/card0/input16
[   12.228442] scsi 6:0:0:0: Direct-Access     Generic  STORAGE DEVICE   94=
51 PQ: 0 ANSI: 0
[   12.228834] sd 6:0:0:0: Attached scsi generic sg2 type 0
[   12.233073] sd 6:0:0:0: [sdb] Attached SCSI removable disk
[   12.996871] input: PIXART USB OPTICAL MOUSE as /devices/pci0000:00/0000:=
00:1d.0/usb2/2-1/2-1.4/2-1.4.4/2-1.4.4.4/2-1.4.4.4:1.0/input/input17
[   12.997308] generic-usb 0003:093A:2510.0003: input,hidraw0: USB HID v1.1=
0 Mouse [PIXART USB OPTICAL MOUSE] on usb-0000:00:1d.0-1.4.4.4/input0
[   12.997432] usbcore: registered new interface driver usbhid
[   12.997468] usbhid: USB HID core driver
[   13.010130] input: HID 046a:0023 as /devices/pci0000:00/0000:00:1d.0/usb=
2/2-1/2-1.4/2-1.4.2/2-1.4.2:1.0/input/input18
[   13.010405] cherry 0003:046A:0023.0001: input,hidraw1: USB HID v1.11 Key=
board [HID 046a:0023] on usb-0000:00:1d.0-1.4.2/input0
[   13.020719] input: HID 046a:0023 as /devices/pci0000:00/0000:00:1d.0/usb=
2/2-1/2-1.4/2-1.4.2/2-1.4.2:1.1/input/input19
[   13.020943] cherry 0003:046A:0023.0002: input,hidraw2: USB HID v1.11 Dev=
ice [HID 046a:0023] on usb-0000:00:1d.0-1.4.2/input1
[   14.591551] iwlwifi 0000:02:00.0: U iwl_prep_station Add STA to driver I=
D 15: ff:ff:ff:ff:ff:ff
[   14.591594] iwlwifi 0000:02:00.0: U iwl_prep_station Add STA to driver I=
D 14: ff:ff:ff:ff:ff:ff
[   14.591631] iwlwifi 0000:02:00.0: U iwl_trans_pcie_prepare_card_hw iwl_t=
rans_prepare_card_hw enter
[   14.591698] iwlwifi 0000:02:00.0: U iwl_set_hw_ready hardware ready
[   14.591752] iwlwifi 0000:02:00.0: U iwl_apm_init Init card's basic funct=
ions
[   14.591833] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[   14.598647] iwlwifi 0000:02:00.0: Radio type=3D0x1-0x2-0x0
[   14.661860] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command COEX_PRIORITY_TABLE_CMD
[   14.661906] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command COEX_PRIORITY_TABLE_CMD
[   14.662086] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command COEX_PRIORITY_TABLE_CMD
[   14.662151] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_PHY_CALIBRATION_CMD
[   14.662191] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_PHY_CALIBRATION_CMD
[   14.662714] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_PHY_CALIBRATION_CMD
[   14.662760] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command CALIBRATION_CFG_CMD
[   14.662806] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command CALIBRATION_CFG_CMD
[   14.662975] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command CALIBRATION_CFG_CMD
[   14.884111] iwlwifi 0000:02:00.0: U iwl_apm_stop Stop card, put in low p=
ower state
[   14.884179] iwlwifi 0000:02:00.0: U iwl_apm_stop_master stop master
[   14.884270] iwlwifi 0000:02:00.0: U iwl_trans_pcie_prepare_card_hw iwl_t=
rans_prepare_card_hw enter
[   14.884336] iwlwifi 0000:02:00.0: U iwl_set_hw_ready hardware ready
[   14.884389] iwlwifi 0000:02:00.0: U iwl_apm_init Init card's basic funct=
ions
[   14.884470] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[   14.891317] iwlwifi 0000:02:00.0: Radio type=3D0x1-0x2-0x0
[   14.957487] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command COEX_PRIORITY_TABLE_CMD
[   14.957530] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command COEX_PRIORITY_TABLE_CMD
[   14.957698] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command COEX_PRIORITY_TABLE_CMD
[   14.957770] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_PHY_CALIBRATION_CMD
[   14.957813] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_PHY_CALIBRATION_CMD
[   14.958335] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_PHY_CALIBRATION_CMD
[   14.958436] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_PHY_CALIBRATION_CMD
[   14.958498] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_PHY_CALIBRATION_CMD
[   14.958650] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_PHY_CALIBRATION_CMD
[   14.958720] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_PHY_CALIBRATION_CMD
[   14.958785] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_PHY_CALIBRATION_CMD
[   14.958967] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_PHY_CALIBRATION_CMD
[   14.959046] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_PHY_CALIBRATION_CMD
[   14.959087] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_PHY_CALIBRATION_CMD
[   14.960552] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_PHY_CALIBRATION_CMD
[   14.961964] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_PHY_CALIBRATION_CMD
[   14.963357] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_PHY_CALIBRATION_CMD
[   14.963485] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_PHY_CALIBRATION_CMD
[   14.963495] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_PHY_CALIBRATION_CMD
[   14.963497] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_PHY_CALIBRATION_CMD
[   14.963615] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_PHY_CALIBRATION_CMD
[   14.963629] iwlwifi 0000:02:00.0: U iwl_alive_start Runtime Alive receiv=
ed.
[   14.963631] iwlwifi 0000:02:00.0: U iwl_send_bt_config BT coex active
[   14.963633] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_BT_CONFIG
[   14.963635] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_BT_CONFIG
[   14.963719] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_BT_CONFIG
[   14.963732] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command CALIBRATION_CFG_CMD
[   14.963734] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command CALIBRATION_CFG_CMD
[   14.963854] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command CALIBRATION_CFG_CMD
[   14.963868] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command TX_ANT_CONFIGURATION_CMD
[   14.963870] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command TX_ANT_CONFIGURATION_CMD
[   14.990953] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command TX_ANT_CONFIGURATION_CMD
[   14.992214] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   14.993467] iwlwifi 0000:02:00.0: U iwl_full_rxon_required need full RXO=
N - !iwl_is_associated_ctx(ctx)
[   14.994714] iwlwifi 0000:02:00.0: U iwlagn_commit_rxon Going to commit R=
XON
[   14.994715]   * without RXON_FILTER_ASSOC_MSK
[   14.994715]   * channel =3D 1
[   14.994716]   * bssid =3D 00:00:00:00:00:00
[   14.994718] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_RXON
[   14.994719] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_RXON
[   14.995830] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_RXON
[   14.995848] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations Clearing uc=
ode stations in driver
[   14.995851] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations No active s=
tations found to be cleared
[   14.995855] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations ... start.
[   14.995858] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring sta f=
f:ff:ff:ff:ff:ff
[   14.995861] iwlwifi 0000:02:00.0: U iwl_send_add_sta Adding sta 15 (ff:f=
f:ff:ff:ff:ff) synchronously
[   14.995863] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_ADD_STA
[   14.995865] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_ADD_STA
[   15.012572] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Processing =
response for adding station 15
[   15.013815] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp REPLY_ADD_S=
TA PASSED
[   15.015025] iwlwifi 0000:02:00.0: I iwl_sta_ucode_activate Added STA id =
15 addr ff:ff:ff:ff:ff:ff to uCode
[   15.016242] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on id 15 addr ff:ff:ff:ff:ff:ff
[   15.017457] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on according to cmd buffer ff:ff:ff:ff:ff:ff
[   15.018680] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_ADD_STA
[   15.019918] iwlwifi 0000:02:00.0: U is_lq_table_valid Channel 0 is not a=
n HT channel
[   15.021159] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_TX_LINK_QUALITY_CMD
[   15.021161] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_TX_LINK_QUALITY_CMD
[   15.021270] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_TX_LINK_QUALITY_CMD
[   15.021281] iwlwifi 0000:02:00.0: U iwl_send_lq_cmd init LQ command comp=
lete, clearing sta addition status for sta 15
[   15.021285] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations .... complete.
[   15.021290] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_CT_KILL_CONFIG_CMD
[   15.021293] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_CT_KILL_CONFIG_CMD
[   15.021355] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_CT_KILL_CONFIG_CMD
[   15.021363] iwlwifi 0000:02:00.0: U iwl_rf_kill_ct_config REPLY_CT_KILL_=
CONFIG_CMD succeeded, critical temperature enter is 114,exit is 95
[   15.021365] iwlwifi 0000:02:00.0: U iwl_alive_start ALIVE processing com=
plete.
[   15.021369] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command POWER_TABLE_CMD
[   15.021372] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command POWER_TABLE_CMD
[   15.021433] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command POWER_TABLE_CMD
[   15.021446] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   15.021449] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   15.021452] iwlwifi 0000:02:00.0: U iwlagn_mac_start Start UP work done.
[   15.021473] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   15.021476] iwlwifi 0000:02:00.0: U iwl_full_rxon_required need full RXO=
N - !iwl_is_associated_ctx(ctx)
[   15.021479] iwlwifi 0000:02:00.0: U iwlagn_commit_rxon Going to commit R=
XON
[   15.021480]   * without RXON_FILTER_ASSOC_MSK
[   15.021481]   * channel =3D 1
[   15.021482]   * bssid =3D 00:00:00:00:00:00
[   15.021484] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_RXON
[   15.021486] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_RXON
[   15.021702] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_RXON
[   15.021714] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations Clearing uc=
ode stations in driver
[   15.021717] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations Clearing uc=
ode active for station 15
[   15.021720] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations ... start.
[   15.021723] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring sta f=
f:ff:ff:ff:ff:ff
[   15.021726] iwlwifi 0000:02:00.0: U iwl_send_add_sta Adding sta 15 (ff:f=
f:ff:ff:ff:ff) synchronously
[   15.021729] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_ADD_STA
[   15.021731] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_ADD_STA
[   15.021816] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Processing =
response for adding station 15
[   15.021819] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp REPLY_ADD_S=
TA PASSED
[   15.021823] iwlwifi 0000:02:00.0: I iwl_sta_ucode_activate Added STA id =
15 addr ff:ff:ff:ff:ff:ff to uCode
[   15.021827] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on id 15 addr ff:ff:ff:ff:ff:ff
[   15.021830] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on according to cmd buffer ff:ff:ff:ff:ff:ff
[   15.021835] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_ADD_STA
[   15.021842] iwlwifi 0000:02:00.0: U is_lq_table_valid Channel 1 is not a=
n HT channel
[   15.021851] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_TX_LINK_QUALITY_CMD
[   15.021854] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_TX_LINK_QUALITY_CMD
[   15.021945] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_TX_LINK_QUALITY_CMD
[   15.021960] iwlwifi 0000:02:00.0: U iwl_send_lq_cmd init LQ command comp=
lete, clearing sta addition status for sta 15
[   15.021963] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations .... complete.
[   15.021968] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   15.021980] iwlwifi 0000:02:00.0: U iwlagn_update_qos send QoS cmd with =
Qos active=3D0 FLAGS=3D0x0
[   15.021984] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_QOS_PARAM
[   15.021987] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_QOS_PARAM
[   15.022082] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_QOS_PARAM
[   15.022092] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   15.022096] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   15.022100] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   15.022104] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   15.022110] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command POWER_TABLE_CMD
[   15.022113] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command POWER_TABLE_CMD
[   15.022190] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command POWER_TABLE_CMD
[   15.022197] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   15.022200] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   15.022203] iwlwifi 0000:02:00.0: U iwl_full_rxon_required need full RXO=
N - !iwl_is_associated_ctx(ctx)
[   15.022207] iwlwifi 0000:02:00.0: U iwlagn_commit_rxon Going to commit R=
XON
[   15.022208]   * without RXON_FILTER_ASSOC_MSK
[   15.022209]   * channel =3D 1
[   15.022210]   * bssid =3D 00:00:00:00:00:00
[   15.022212] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_RXON
[   15.022214] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_RXON
[   15.023530] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_RXON
[   15.023569] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations Clearing uc=
ode stations in driver
[   15.023572] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations Clearing uc=
ode active for station 15
[   15.023575] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations ... start.
[   15.023577] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring sta f=
f:ff:ff:ff:ff:ff
[   15.023579] iwlwifi 0000:02:00.0: U iwl_send_add_sta Adding sta 15 (ff:f=
f:ff:ff:ff:ff) synchronously
[   15.023581] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_ADD_STA
[   15.023582] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_ADD_STA
[   15.023687] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Processing =
response for adding station 15
[   15.023689] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp REPLY_ADD_S=
TA PASSED
[   15.023694] iwlwifi 0000:02:00.0: I iwl_sta_ucode_activate Added STA id =
15 addr ff:ff:ff:ff:ff:ff to uCode
[   15.023697] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on id 15 addr ff:ff:ff:ff:ff:ff
[   15.023699] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on according to cmd buffer ff:ff:ff:ff:ff:ff
[   15.023703] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_ADD_STA
[   15.023740] iwlwifi 0000:02:00.0: U is_lq_table_valid Channel 1 is not a=
n HT channel
[   15.023742] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_TX_LINK_QUALITY_CMD
[   15.023744] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_TX_LINK_QUALITY_CMD
[   15.025147] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_TX_LINK_QUALITY_CMD
[   15.025184] iwlwifi 0000:02:00.0: U iwl_send_lq_cmd init LQ command comp=
lete, clearing sta addition status for sta 15
[   15.025186] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations .... complete.
[   15.025482] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   15.123317] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   15.123325] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command POWER_TABLE_CMD
[   15.123328] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command POWER_TABLE_CMD
[   15.124732] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command POWER_TABLE_CMD
[   15.124740] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   15.124743] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   15.124756] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_SCAN_CMD
[   15.124759] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_SCAN_CMD
[   15.124934] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_SCAN_CMD
[   15.580185] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_SCAN_CMD
[   15.581413] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_SCAN_CMD
[   15.583812] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_SCAN_CMD
[   16.869145] udevd used greatest stack depth: 4784 bytes left
[   18.310748] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   18.311941] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command POWER_TABLE_CMD
[   18.313130] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command POWER_TABLE_CMD
[   18.314361] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command POWER_TABLE_CMD
[   18.314367] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   18.314369] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   20.294356] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   20.295546] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command POWER_TABLE_CMD
[   20.296757] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command POWER_TABLE_CMD
[   20.299428] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command POWER_TABLE_CMD
[   20.300667] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   20.301925] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   20.303127] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_SCAN_CMD
[   20.304324] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_SCAN_CMD
[   20.305814] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_SCAN_CMD
[   20.693425] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_SCAN_CMD
[   20.694689] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_SCAN_CMD
[   20.697144] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_SCAN_CMD
[   23.424092] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   23.425337] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command POWER_TABLE_CMD
[   23.426601] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command POWER_TABLE_CMD
[   23.427985] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command POWER_TABLE_CMD
[   23.429251] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   23.430525] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   23.680234] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   23.681457] iwlwifi 0000:02:00.0: U iwl_full_rxon_required need full RXO=
N - !iwl_is_associated_ctx(ctx)
[   23.682759] iwlwifi 0000:02:00.0: U iwlagn_commit_rxon Going to commit R=
XON
[   23.682761]   * without RXON_FILTER_ASSOC_MSK
[   23.682761]   * channel =3D 1
[   23.682762]   * bssid =3D 00:00:00:00:00:00
[   23.687572] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_RXON
[   23.688863] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_RXON
[   23.691711] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_RXON
[   23.692952] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations Clearing uc=
ode stations in driver
[   23.694236] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations Clearing uc=
ode active for station 15
[   23.695450] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations ... start.
[   23.696677] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring sta f=
f:ff:ff:ff:ff:ff
[   23.697873] iwlwifi 0000:02:00.0: U iwl_send_add_sta Adding sta 15 (ff:f=
f:ff:ff:ff:ff) synchronously
[   23.699111] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_ADD_STA
[   23.700331] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_ADD_STA
[   23.701764] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Processing =
response for adding station 15
[   23.702991] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp REPLY_ADD_S=
TA PASSED
[   23.704146] iwlwifi 0000:02:00.0: I iwl_sta_ucode_activate Added STA id =
15 addr ff:ff:ff:ff:ff:ff to uCode
[   23.705305] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on id 15 addr ff:ff:ff:ff:ff:ff
[   23.706459] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on according to cmd buffer ff:ff:ff:ff:ff:ff
[   23.707624] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_ADD_STA
[   23.708795] iwlwifi 0000:02:00.0: U is_lq_table_valid Channel 1 is not a=
n HT channel
[   23.709958] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_TX_LINK_QUALITY_CMD
[   23.711260] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_TX_LINK_QUALITY_CMD
[   23.713924] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_TX_LINK_QUALITY_CMD
[   23.715163] iwlwifi 0000:02:00.0: U iwl_send_lq_cmd init LQ command comp=
lete, clearing sta addition status for sta 15
[   23.716392] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations .... complete.
[   23.716429] iwlwifi 0000:02:00.0: U __iwl_down iwlwifi is going down
[   23.716433] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations Clearing uc=
ode stations in driver
[   23.716436] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations Clearing uc=
ode active for station 15
[   23.716990] iwlwifi 0000:02:00.0: U iwl_apm_stop Stop card, put in low p=
ower state
[   23.717006] iwlwifi 0000:02:00.0: U iwl_apm_stop_master stop master
[   23.720661] iwlwifi 0000:02:00.0: U iwl_prep_station Add STA to driver I=
D 15: ff:ff:ff:ff:ff:ff
[   23.720664] iwlwifi 0000:02:00.0: U iwl_prep_station Add STA to driver I=
D 14: ff:ff:ff:ff:ff:ff
[   23.720667] iwlwifi 0000:02:00.0: U iwl_trans_pcie_prepare_card_hw iwl_t=
rans_prepare_card_hw enter
[   23.720700] iwlwifi 0000:02:00.0: U iwl_set_hw_ready hardware ready
[   23.720726] iwlwifi 0000:02:00.0: U iwl_apm_init Init card's basic funct=
ions
[   23.720756] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[   23.727523] iwlwifi 0000:02:00.0: Radio type=3D0x1-0x2-0x0
[   23.727694] ------------[ cut here ]------------
[   23.727699] WARNING: at drivers/iommu/intel-iommu.c:2911 intel_unmap_pag=
e+0x14b/0x180()
[   23.727700] Hardware name: Latitude E5420
[   23.727701] Driver unmaps unmatched page at PFN ffd1a000
[   23.727702] Modules linked in: hid_cherry usbhid snd_hda_codec_hdmi snd_=
hda_codec_idt usb_storage uvcvideo videobuf2_vmalloc videobuf2_memops video=
buf2_core videodev v4l2_compat_ioctl32 snd_hda_intel snd_hda_codec iwlwifi =
snd_hwdep snd_pcm snd_page_alloc snd_timer mac80211 snd cfg80211 soundcore =
psmouse ehci_hcd usbcore usb_common
[   23.727716] Pid: 1844, comm: ifconfig Tainted: G        W    3.3.4-pf #3
[   23.727717] Call Trace:
[   23.727720]  [<ffffffff8137db00>] ? intel_unmap_page+0x60/0x180
[   23.727725]  [<ffffffff8103103b>] ? warn_slowpath_common+0x7b/0xc0
[   23.727727]  [<ffffffff81031135>] ? warn_slowpath_fmt+0x45/0x50
[   23.727730]  [<ffffffff814871f3>] ? _raw_spin_unlock_irqrestore+0x13/0x40
[   23.727732]  [<ffffffff8137dbeb>] ? intel_unmap_page+0x14b/0x180
[   23.727738]  [<ffffffffa013e26c>] ? iwl_trans_rxq_free_rx_bufs+0x4c/0xf0=
 [iwlwifi]
[   23.727742]  [<ffffffffa013f8da>] ? iwl_trans_pcie_start_device+0x17a/0x=
eb0 [iwlwifi]
[   23.727746]  [<ffffffffa01244ed>] ? iwl_load_ucode_wait_alive+0x2d/0x4c0=
 [iwlwifi]
[   23.727749]  [<ffffffff810579c9>] ? get_parent_ip+0x9/0x20
[   23.727751]  [<ffffffff810579c9>] ? get_parent_ip+0x9/0x20
[   23.727753]  [<ffffffff81057a67>] ? sub_preempt_count+0x87/0xb0
[   23.727755]  [<ffffffff814871f3>] ? _raw_spin_unlock_irqrestore+0x13/0x40
[   23.727758]  [<ffffffffa012295e>] ? iwlagn_mac_start+0x17e/0x310 [iwlwif=
i]
[   23.727764]  [<ffffffffa00c7a56>] ? ieee80211_do_open+0x276/0x6a0 [mac80=
211]
[   23.727769]  [<ffffffffa00c5d02>] ? ieee80211_check_concurrent_iface+0x2=
2/0x1a0 [mac80211]
[   23.727772]  [<ffffffff8139c136>] ? __dev_open+0x86/0xd0
[   23.727775]  [<ffffffff8139c3aa>] ? __dev_change_flags+0x9a/0x180
[   23.727777]  [<ffffffff8139c540>] ? dev_change_flags+0x20/0x70
[   23.727780]  [<ffffffff813f782f>] ? devinet_ioctl+0x5bf/0x750
[   23.727783]  [<ffffffff813831c9>] ? sock_do_ioctl+0x29/0x60
[   23.727785]  [<ffffffff81383263>] ? sock_ioctl+0x63/0x2b0
[   23.727788]  [<ffffffff811076ce>] ? do_vfs_ioctl+0x8e/0x4f0
[   23.727790]  [<ffffffff810579c9>] ? get_parent_ip+0x9/0x20
[   23.727792]  [<ffffffff81107bc8>] ? sys_ioctl+0x98/0xa0
[   23.727795]  [<ffffffff81487ee2>] ? system_call_fastpath+0x16/0x1b
[   23.727796] ---[ end trace e93713a9d40cd06e ]---
[   23.836019] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command COEX_PRIORITY_TABLE_CMD
[   23.837257] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command COEX_PRIORITY_TABLE_CMD
[   23.838622] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command COEX_PRIORITY_TABLE_CMD
[   23.839853] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_PHY_CALIBRATION_CMD
[   23.841055] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_PHY_CALIBRATION_CMD
[   23.841161] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_PHY_CALIBRATION_CMD
[   23.841171] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_PHY_CALIBRATION_CMD
[   23.841174] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_PHY_CALIBRATION_CMD
[   23.841234] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_PHY_CALIBRATION_CMD
[   23.841240] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_PHY_CALIBRATION_CMD
[   23.841242] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_PHY_CALIBRATION_CMD
[   23.841327] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_PHY_CALIBRATION_CMD
[   23.841333] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_PHY_CALIBRATION_CMD
[   23.841336] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_PHY_CALIBRATION_CMD
[   23.841427] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_PHY_CALIBRATION_CMD
[   23.841434] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_PHY_CALIBRATION_CMD
[   23.841437] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_PHY_CALIBRATION_CMD
[   23.841540] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_PHY_CALIBRATION_CMD
[   23.841547] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_PHY_CALIBRATION_CMD
[   23.841549] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_PHY_CALIBRATION_CMD
[   23.841640] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_PHY_CALIBRATION_CMD
[   23.841648] iwlwifi 0000:02:00.0: U iwl_alive_start Runtime Alive receiv=
ed.
[   23.841651] iwlwifi 0000:02:00.0: U iwl_send_bt_config BT coex active
[   23.841653] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_BT_CONFIG
[   23.841656] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_BT_CONFIG
[   23.841718] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_BT_CONFIG
[   23.841725] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command CALIBRATION_CFG_CMD
[   23.841727] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command CALIBRATION_CFG_CMD
[   23.841818] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command CALIBRATION_CFG_CMD
[   23.841829] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command TX_ANT_CONFIGURATION_CMD
[   23.841832] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command TX_ANT_CONFIGURATION_CMD
[   23.868907] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command TX_ANT_CONFIGURATION_CMD
[   23.868920] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   23.868927] iwlwifi 0000:02:00.0: U iwl_full_rxon_required need full RXO=
N - !iwl_is_associated_ctx(ctx)
[   23.868931] iwlwifi 0000:02:00.0: U iwlagn_commit_rxon Going to commit R=
XON
[   23.868932]   * without RXON_FILTER_ASSOC_MSK
[   23.868933]   * channel =3D 1
[   23.868934]   * bssid =3D 00:00:00:00:00:00
[   23.868936] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_RXON
[   23.868940] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_RXON
[   23.870047] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_RXON
[   23.870058] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations Clearing uc=
ode stations in driver
[   23.870061] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations No active s=
tations found to be cleared
[   23.870065] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations ... start.
[   23.870068] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring sta f=
f:ff:ff:ff:ff:ff
[   23.870072] iwlwifi 0000:02:00.0: U iwl_send_add_sta Adding sta 15 (ff:f=
f:ff:ff:ff:ff) synchronously
[   23.870074] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_ADD_STA
[   23.870077] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_ADD_STA
[   23.886776] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Processing =
response for adding station 15
[   23.886779] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp REPLY_ADD_S=
TA PASSED
[   23.886781] iwlwifi 0000:02:00.0: I iwl_sta_ucode_activate Added STA id =
15 addr ff:ff:ff:ff:ff:ff to uCode
[   23.886783] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on id 15 addr ff:ff:ff:ff:ff:ff
[   23.886785] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on according to cmd buffer ff:ff:ff:ff:ff:ff
[   23.886788] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_ADD_STA
[   23.886798] iwlwifi 0000:02:00.0: U is_lq_table_valid Channel 1 is not a=
n HT channel
[   23.886801] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_TX_LINK_QUALITY_CMD
[   23.886804] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_TX_LINK_QUALITY_CMD
[   23.886929] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_TX_LINK_QUALITY_CMD
[   23.886940] iwlwifi 0000:02:00.0: U iwl_send_lq_cmd init LQ command comp=
lete, clearing sta addition status for sta 15
[   23.886943] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations .... complete.
[   23.886948] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_CT_KILL_CONFIG_CMD
[   23.886950] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_CT_KILL_CONFIG_CMD
[   23.887037] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_CT_KILL_CONFIG_CMD
[   23.887048] iwlwifi 0000:02:00.0: U iwl_rf_kill_ct_config REPLY_CT_KILL_=
CONFIG_CMD succeeded, critical temperature enter is 114,exit is 95
[   23.887051] iwlwifi 0000:02:00.0: U iwl_alive_start ALIVE processing com=
plete.
[   23.887056] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command POWER_TABLE_CMD
[   23.887058] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command POWER_TABLE_CMD
[   23.887144] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command POWER_TABLE_CMD
[   23.887155] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   23.887159] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   23.887163] iwlwifi 0000:02:00.0: U iwlagn_mac_start Start UP work done.
[   23.887170] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   23.887173] iwlwifi 0000:02:00.0: U iwl_full_rxon_required need full RXO=
N - !iwl_is_associated_ctx(ctx)
[   23.887176] iwlwifi 0000:02:00.0: U iwlagn_commit_rxon Going to commit R=
XON
[   23.887176]   * without RXON_FILTER_ASSOC_MSK
[   23.887177]   * channel =3D 1
[   23.887177]   * bssid =3D 00:00:00:00:00:00
[   23.887179] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_RXON
[   23.887180] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_RXON
[   23.888747] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_RXON
[   23.888757] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations Clearing uc=
ode stations in driver
[   23.888761] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations Clearing uc=
ode active for station 15
[   23.888764] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations ... start.
[   23.888767] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring sta f=
f:ff:ff:ff:ff:ff
[   23.888770] iwlwifi 0000:02:00.0: U iwl_send_add_sta Adding sta 15 (ff:f=
f:ff:ff:ff:ff) synchronously
[   23.888772] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_ADD_STA
[   23.888775] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_ADD_STA
[   23.888875] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Processing =
response for adding station 15
[   23.888878] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp REPLY_ADD_S=
TA PASSED
[   23.888880] iwlwifi 0000:02:00.0: I iwl_sta_ucode_activate Added STA id =
15 addr ff:ff:ff:ff:ff:ff to uCode
[   23.888882] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on id 15 addr ff:ff:ff:ff:ff:ff
[   23.888883] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on according to cmd buffer ff:ff:ff:ff:ff:ff
[   23.888886] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_ADD_STA
[   23.888897] iwlwifi 0000:02:00.0: U is_lq_table_valid Channel 1 is not a=
n HT channel
[   23.888900] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_TX_LINK_QUALITY_CMD
[   23.888902] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_TX_LINK_QUALITY_CMD
[   23.890110] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_TX_LINK_QUALITY_CMD
[   23.890121] iwlwifi 0000:02:00.0: U iwl_send_lq_cmd init LQ command comp=
lete, clearing sta addition status for sta 15
[   23.890125] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations .... complete.
[   23.890131] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   23.890136] iwlwifi 0000:02:00.0: U iwlagn_update_qos send QoS cmd with =
Qos active=3D0 FLAGS=3D0x0
[   23.890139] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_QOS_PARAM
[   23.890141] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_QOS_PARAM
[   23.891561] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_QOS_PARAM
[   23.891573] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   23.891579] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   23.891582] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   23.891590] iwlwifi 0000:02:00.0: U iwl_full_rxon_required need full RXO=
N - !iwl_is_associated_ctx(ctx)
[   23.891592] iwlwifi 0000:02:00.0: U iwlagn_commit_rxon Going to commit R=
XON
[   23.891593]   * without RXON_FILTER_ASSOC_MSK
[   23.891593]   * channel =3D 1
[   23.891594]   * bssid =3D 00:00:00:00:00:00
[   23.891595] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_RXON
[   23.891597] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_RXON
[   23.893158] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_RXON
[   23.893169] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations Clearing uc=
ode stations in driver
[   23.893172] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations Clearing uc=
ode active for station 15
[   23.893176] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations ... start.
[   23.893178] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring sta f=
f:ff:ff:ff:ff:ff
[   23.893181] iwlwifi 0000:02:00.0: U iwl_send_add_sta Adding sta 15 (ff:f=
f:ff:ff:ff:ff) synchronously
[   23.893184] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_ADD_STA
[   23.893186] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_ADD_STA
[   23.893290] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Processing =
response for adding station 15
[   23.893293] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp REPLY_ADD_S=
TA PASSED
[   23.893295] iwlwifi 0000:02:00.0: I iwl_sta_ucode_activate Added STA id =
15 addr ff:ff:ff:ff:ff:ff to uCode
[   23.893297] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on id 15 addr ff:ff:ff:ff:ff:ff
[   23.893299] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on according to cmd buffer ff:ff:ff:ff:ff:ff
[   23.893301] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_ADD_STA
[   23.893312] iwlwifi 0000:02:00.0: U is_lq_table_valid Channel 1 is not a=
n HT channel
[   23.893315] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_TX_LINK_QUALITY_CMD
[   23.893318] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_TX_LINK_QUALITY_CMD
[   23.894522] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_TX_LINK_QUALITY_CMD
[   23.894533] iwlwifi 0000:02:00.0: U iwl_send_lq_cmd init LQ command comp=
lete, clearing sta addition status for sta 15
[   23.894536] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations .... complete.
[   23.894840] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   24.870807] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   24.872035] iwlwifi 0000:02:00.0: U iwl_full_rxon_required need full RXO=
N - !iwl_is_associated_ctx(ctx)
[   24.873297] iwlwifi 0000:02:00.0: U iwlagn_commit_rxon Going to commit R=
XON
[   24.873299]   * without RXON_FILTER_ASSOC_MSK
[   24.873300]   * channel =3D 1
[   24.873300]   * bssid =3D 00:00:00:00:00:00
[   24.878153] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_RXON
[   24.879449] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_RXON
[   24.882293] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_RXON
[   24.883551] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations Clearing uc=
ode stations in driver
[   24.884802] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations Clearing uc=
ode active for station 15
[   24.886025] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations ... start.
[   24.887246] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring sta f=
f:ff:ff:ff:ff:ff
[   24.888493] iwlwifi 0000:02:00.0: U iwl_send_add_sta Adding sta 15 (ff:f=
f:ff:ff:ff:ff) synchronously
[   24.889703] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_ADD_STA
[   24.890938] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_ADD_STA
[   24.893620] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Processing =
response for adding station 15
[   24.894845] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp REPLY_ADD_S=
TA PASSED
[   24.896021] iwlwifi 0000:02:00.0: I iwl_sta_ucode_activate Added STA id =
15 addr ff:ff:ff:ff:ff:ff to uCode
[   24.897202] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on id 15 addr ff:ff:ff:ff:ff:ff
[   24.898381] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on according to cmd buffer ff:ff:ff:ff:ff:ff
[   24.899564] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_ADD_STA
[   24.900757] iwlwifi 0000:02:00.0: U is_lq_table_valid Channel 1 is not a=
n HT channel
[   24.901948] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_TX_LINK_QUALITY_CMD
[   24.903148] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_TX_LINK_QUALITY_CMD
[   24.904603] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_TX_LINK_QUALITY_CMD
[   24.905860] iwlwifi 0000:02:00.0: U iwl_send_lq_cmd init LQ command comp=
lete, clearing sta addition status for sta 15
[   24.907100] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations .... complete.
[   24.908371] iwlwifi 0000:02:00.0: U __iwl_down iwlwifi is going down
[   24.909605] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations Clearing uc=
ode stations in driver
[   24.910881] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations Clearing uc=
ode active for station 15
[   24.912692] iwlwifi 0000:02:00.0: U iwl_apm_stop Stop card, put in low p=
ower state
[   24.913973] iwlwifi 0000:02:00.0: U iwl_apm_stop_master stop master
[   24.920179] iwlwifi 0000:02:00.0: U iwl_prep_station Add STA to driver I=
D 15: ff:ff:ff:ff:ff:ff
[   24.921480] iwlwifi 0000:02:00.0: U iwl_prep_station Add STA to driver I=
D 14: ff:ff:ff:ff:ff:ff
[   24.922735] iwlwifi 0000:02:00.0: U iwl_trans_pcie_prepare_card_hw iwl_t=
rans_prepare_card_hw enter
[   24.924006] iwlwifi 0000:02:00.0: U iwl_set_hw_ready hardware ready
[   24.925315] iwlwifi 0000:02:00.0: U iwl_apm_init Init card's basic funct=
ions
[   24.926606] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[   24.934638] iwlwifi 0000:02:00.0: Radio type=3D0x1-0x2-0x0
[   25.002503] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command COEX_PRIORITY_TABLE_CMD
[   25.003755] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command COEX_PRIORITY_TABLE_CMD
[   25.005139] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command COEX_PRIORITY_TABLE_CMD
[   25.006404] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_PHY_CALIBRATION_CMD
[   25.007736] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_PHY_CALIBRATION_CMD
[   25.009181] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_PHY_CALIBRATION_CMD
[   25.010467] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_PHY_CALIBRATION_CMD
[   25.011784] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_PHY_CALIBRATION_CMD
[   25.013132] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_PHY_CALIBRATION_CMD
[   25.014416] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_PHY_CALIBRATION_CMD
[   25.015704] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_PHY_CALIBRATION_CMD
[   25.017063] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_PHY_CALIBRATION_CMD
[   25.018366] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_PHY_CALIBRATION_CMD
[   25.019629] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_PHY_CALIBRATION_CMD
[   25.021079] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_PHY_CALIBRATION_CMD
[   25.022348] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_PHY_CALIBRATION_CMD
[   25.023586] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_PHY_CALIBRATION_CMD
[   25.025034] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_PHY_CALIBRATION_CMD
[   25.026304] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_PHY_CALIBRATION_CMD
[   25.027545] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_PHY_CALIBRATION_CMD
[   25.029005] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_PHY_CALIBRATION_CMD
[   25.030272] iwlwifi 0000:02:00.0: U iwl_alive_start Runtime Alive receiv=
ed.
[   25.031518] iwlwifi 0000:02:00.0: U iwl_send_bt_config BT coex active
[   25.032794] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_BT_CONFIG
[   25.032797] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_BT_CONFIG
[   25.032875] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_BT_CONFIG
[   25.032912] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command CALIBRATION_CFG_CMD
[   25.032915] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command CALIBRATION_CFG_CMD
[   25.033019] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command CALIBRATION_CFG_CMD
[   25.033060] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command TX_ANT_CONFIGURATION_CMD
[   25.033063] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command TX_ANT_CONFIGURATION_CMD
[   25.060171] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command TX_ANT_CONFIGURATION_CMD
[   25.061476] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   25.062781] iwlwifi 0000:02:00.0: U iwl_full_rxon_required need full RXO=
N - !iwl_is_associated_ctx(ctx)
[   25.064066] iwlwifi 0000:02:00.0: U iwlagn_commit_rxon Going to commit R=
XON
[   25.064067]   * without RXON_FILTER_ASSOC_MSK
[   25.064068]   * channel =3D 1
[   25.064068]   * bssid =3D 00:00:00:00:00:00
[   25.064070] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_RXON
[   25.064071] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_RXON
[   25.065189] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_RXON
[   25.065208] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations Clearing uc=
ode stations in driver
[   25.065210] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations No active s=
tations found to be cleared
[   25.065212] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations ... start.
[   25.065214] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring sta f=
f:ff:ff:ff:ff:ff
[   25.065217] iwlwifi 0000:02:00.0: U iwl_send_add_sta Adding sta 15 (ff:f=
f:ff:ff:ff:ff) synchronously
[   25.065219] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_ADD_STA
[   25.065220] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_ADD_STA
[   25.081933] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Processing =
response for adding station 15
[   25.083183] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp REPLY_ADD_S=
TA PASSED
[   25.083185] iwlwifi 0000:02:00.0: I iwl_sta_ucode_activate Added STA id =
15 addr ff:ff:ff:ff:ff:ff to uCode
[   25.083187] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on id 15 addr ff:ff:ff:ff:ff:ff
[   25.083189] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on according to cmd buffer ff:ff:ff:ff:ff:ff
[   25.083192] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_ADD_STA
[   25.083218] iwlwifi 0000:02:00.0: U is_lq_table_valid Channel 1 is not a=
n HT channel
[   25.083221] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_TX_LINK_QUALITY_CMD
[   25.083222] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_TX_LINK_QUALITY_CMD
[   25.089379] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_TX_LINK_QUALITY_CMD
[   25.089388] iwlwifi 0000:02:00.0: U iwl_send_lq_cmd init LQ command comp=
lete, clearing sta addition status for sta 15
[   25.089392] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations .... complete.
[   25.089397] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_CT_KILL_CONFIG_CMD
[   25.089400] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_CT_KILL_CONFIG_CMD
[   25.095650] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_CT_KILL_CONFIG_CMD
[   25.095657] iwlwifi 0000:02:00.0: U iwl_rf_kill_ct_config REPLY_CT_KILL_=
CONFIG_CMD succeeded, critical temperature enter is 114,exit is 95
[   25.095660] iwlwifi 0000:02:00.0: U iwl_alive_start ALIVE processing com=
plete.
[   25.095663] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command POWER_TABLE_CMD
[   25.095666] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command POWER_TABLE_CMD
[   25.100714] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command POWER_TABLE_CMD
[   25.100721] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   25.100724] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   25.100728] iwlwifi 0000:02:00.0: U iwlagn_mac_start Start UP work done.
[   25.100735] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   25.100737] iwlwifi 0000:02:00.0: U iwl_full_rxon_required need full RXO=
N - !iwl_is_associated_ctx(ctx)
[   25.100740] iwlwifi 0000:02:00.0: U iwlagn_commit_rxon Going to commit R=
XON
[   25.100742]   * without RXON_FILTER_ASSOC_MSK
[   25.100743]   * channel =3D 1
[   25.100743]   * bssid =3D 00:00:00:00:00:00
[   25.100745] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_RXON
[   25.100748] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_RXON
[   25.107102] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_RXON
[   25.107108] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations Clearing uc=
ode stations in driver
[   25.107110] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations Clearing uc=
ode active for station 15
[   25.107113] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations ... start.
[   25.107116] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring sta f=
f:ff:ff:ff:ff:ff
[   25.107119] iwlwifi 0000:02:00.0: U iwl_send_add_sta Adding sta 15 (ff:f=
f:ff:ff:ff:ff) synchronously
[   25.107122] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_ADD_STA
[   25.107124] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_ADD_STA
[   25.124401] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Processing =
response for adding station 15
[   25.124402] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp REPLY_ADD_S=
TA PASSED
[   25.124404] iwlwifi 0000:02:00.0: I iwl_sta_ucode_activate Added STA id =
15 addr ff:ff:ff:ff:ff:ff to uCode
[   25.124406] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on id 15 addr ff:ff:ff:ff:ff:ff
[   25.124408] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on according to cmd buffer ff:ff:ff:ff:ff:ff
[   25.124410] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_ADD_STA
[   25.124417] iwlwifi 0000:02:00.0: U is_lq_table_valid Channel 1 is not a=
n HT channel
[   25.124419] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_TX_LINK_QUALITY_CMD
[   25.124422] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_TX_LINK_QUALITY_CMD
[   25.137751] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_TX_LINK_QUALITY_CMD
[   25.137757] iwlwifi 0000:02:00.0: U iwl_send_lq_cmd init LQ command comp=
lete, clearing sta addition status for sta 15
[   25.137760] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations .... complete.
[   25.137765] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   25.137770] iwlwifi 0000:02:00.0: U iwlagn_update_qos send QoS cmd with =
Qos active=3D0 FLAGS=3D0x0
[   25.137772] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_QOS_PARAM
[   25.137775] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_QOS_PARAM
[   25.142664] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_QOS_PARAM
[   25.142670] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   25.142675] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   25.142678] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   25.142684] iwlwifi 0000:02:00.0: U iwl_full_rxon_required need full RXO=
N - !iwl_is_associated_ctx(ctx)
[   25.142687] iwlwifi 0000:02:00.0: U iwlagn_commit_rxon Going to commit R=
XON
[   25.142688]   * without RXON_FILTER_ASSOC_MSK
[   25.142689]   * channel =3D 1
[   25.142690]   * bssid =3D 00:00:00:00:00:00
[   25.142692] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_RXON
[   25.142694] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_RXON
[   25.151386] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_RXON
[   25.151391] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations Clearing uc=
ode stations in driver
[   25.151394] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations Clearing uc=
ode active for station 15
[   25.151396] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations ... start.
[   25.151399] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring sta f=
f:ff:ff:ff:ff:ff
[   25.151402] iwlwifi 0000:02:00.0: U iwl_send_add_sta Adding sta 15 (ff:f=
f:ff:ff:ff:ff) synchronously
[   25.151404] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_ADD_STA
[   25.151407] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_ADD_STA
[   25.165853] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Processing =
response for adding station 15
[   25.165855] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp REPLY_ADD_S=
TA PASSED
[   25.165857] iwlwifi 0000:02:00.0: I iwl_sta_ucode_activate Added STA id =
15 addr ff:ff:ff:ff:ff:ff to uCode
[   25.165858] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on id 15 addr ff:ff:ff:ff:ff:ff
[   25.165860] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on according to cmd buffer ff:ff:ff:ff:ff:ff
[   25.165862] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_ADD_STA
[   25.165869] iwlwifi 0000:02:00.0: U is_lq_table_valid Channel 1 is not a=
n HT channel
[   25.165871] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_TX_LINK_QUALITY_CMD
[   25.165874] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_TX_LINK_QUALITY_CMD
[   25.179643] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_TX_LINK_QUALITY_CMD
[   25.179649] iwlwifi 0000:02:00.0: U iwl_send_lq_cmd init LQ command comp=
lete, clearing sta addition status for sta 15
[   25.179651] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations .... complete.
[   25.180197] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   27.330329] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   27.331558] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command POWER_TABLE_CMD
[   27.332827] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command POWER_TABLE_CMD
[   27.335503] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command POWER_TABLE_CMD
[   27.336767] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   27.338022] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   27.339268] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_SCAN_CMD
[   27.339271] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_SCAN_CMD
[   27.339499] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_SCAN_CMD
[   27.905940] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_SCAN_CMD
[   27.907171] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_SCAN_CMD
[   27.909661] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_SCAN_CMD
[   30.636554] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   30.637925] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command POWER_TABLE_CMD
[   30.639191] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command POWER_TABLE_CMD
[   30.640585] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command POWER_TABLE_CMD
[   30.641810] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   30.643051] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   30.644350] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   30.645582] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command POWER_TABLE_CMD
[   30.646760] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command POWER_TABLE_CMD
[   30.649379] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command POWER_TABLE_CMD
[   30.650612] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   30.651801] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   30.652966] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_SCAN_CMD
[   30.654123] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_SCAN_CMD
[   30.656593] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_SCAN_CMD
[   30.694343] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   30.695970] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   30.697168] iwlwifi 0000:02:00.0: U iwl_set_rxon_channel Staging channel=
 set to 3 [0]
[   30.698350] iwlwifi 0000:02:00.0: U iwl_set_rxon_channel Staging channel=
 set to 3 [0]
[   30.698390] iwlwifi 0000:02:00.0: U iwl_full_rxon_required need full RXO=
N - !iwl_is_associated_ctx(ctx)
[   30.698393] iwlwifi 0000:02:00.0: U iwlagn_commit_rxon Going to commit R=
XON
[   30.698394]   * without RXON_FILTER_ASSOC_MSK
[   30.698395]   * channel =3D 3
[   30.698395]   * bssid =3D 00:00:00:00:00:00
[   30.698397] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_RXON
[   30.698399] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_RXON
[   30.699660] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_RXON
[   30.699678] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations Clearing uc=
ode stations in driver
[   30.699682] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations Clearing uc=
ode active for station 15
[   30.699685] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations ... start.
[   30.699688] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring sta f=
f:ff:ff:ff:ff:ff
[   30.699691] iwlwifi 0000:02:00.0: U iwl_send_add_sta Adding sta 15 (ff:f=
f:ff:ff:ff:ff) synchronously
[   30.699694] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_ADD_STA
[   30.699696] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_ADD_STA
[   30.716390] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Processing =
response for adding station 15
[   30.716392] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp REPLY_ADD_S=
TA PASSED
[   30.716396] iwlwifi 0000:02:00.0: I iwl_sta_ucode_activate Added STA id =
15 addr ff:ff:ff:ff:ff:ff to uCode
[   30.716399] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on id 15 addr ff:ff:ff:ff:ff:ff
[   30.716402] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on according to cmd buffer ff:ff:ff:ff:ff:ff
[   30.716405] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_ADD_STA
[   30.716412] iwlwifi 0000:02:00.0: U is_lq_table_valid Channel 1 is not a=
n HT channel
[   30.716415] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_TX_LINK_QUALITY_CMD
[   30.716417] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_TX_LINK_QUALITY_CMD
[   30.716516] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_TX_LINK_QUALITY_CMD
[   30.716522] iwlwifi 0000:02:00.0: U iwl_send_lq_cmd init LQ command comp=
lete, clearing sta addition status for sta 15
[   30.716525] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations .... complete.
[   30.716530] wlan0: authenticate with 00:1e:2a:f6:f1:4a (try 1)
[   30.730989] wlan0: deauthenticating from 00:1e:2a:f6:f1:4a by local choi=
ce (reason=3D2)
[   30.731003] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   30.737013] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command POWER_TABLE_CMD
[   30.738193] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command POWER_TABLE_CMD
[   30.739515] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command POWER_TABLE_CMD
[   30.740699] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   30.741896] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   30.743090] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   30.744262] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command POWER_TABLE_CMD
[   30.744264] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command POWER_TABLE_CMD
[   30.744346] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command POWER_TABLE_CMD
[   30.744354] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   30.744357] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   30.744360] wlan0: authenticate with 00:1e:2a:f6:f1:4a (try 1)
[   30.746163] wlan0: authenticated
[   30.746174] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   30.746179] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command POWER_TABLE_CMD
[   30.746182] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command POWER_TABLE_CMD
[   30.746286] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command POWER_TABLE_CMD
[   30.746297] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   30.746301] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   30.746305] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   30.746308] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   30.746311] iwlwifi 0000:02:00.0: U iwl_set_rxon_channel Staging channel=
 set to 1 [0]
[   30.746313] iwlwifi 0000:02:00.0: U iwl_set_rxon_channel Staging channel=
 set to 1 [0]
[   30.746317] iwlwifi 0000:02:00.0: U iwl_full_rxon_required need full RXO=
N - !iwl_is_associated_ctx(ctx)
[   30.746319] iwlwifi 0000:02:00.0: U iwlagn_commit_rxon Going to commit R=
XON
[   30.746320]   * without RXON_FILTER_ASSOC_MSK
[   30.746320]   * channel =3D 1
[   30.746321]   * bssid =3D 00:00:00:00:00:00
[   30.746322] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_RXON
[   30.746324] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_RXON
[   30.747790] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_RXON
[   30.747800] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations Clearing uc=
ode stations in driver
[   30.747803] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations Clearing uc=
ode active for station 15
[   30.747806] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations ... start.
[   30.747809] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring sta f=
f:ff:ff:ff:ff:ff
[   30.747812] iwlwifi 0000:02:00.0: U iwl_send_add_sta Adding sta 15 (ff:f=
f:ff:ff:ff:ff) synchronously
[   30.747815] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_ADD_STA
[   30.747817] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_ADD_STA
[   30.764504] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Processing =
response for adding station 15
[   30.764506] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp REPLY_ADD_S=
TA PASSED
[   30.764508] iwlwifi 0000:02:00.0: I iwl_sta_ucode_activate Added STA id =
15 addr ff:ff:ff:ff:ff:ff to uCode
[   30.764510] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on id 15 addr ff:ff:ff:ff:ff:ff
[   30.764512] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on according to cmd buffer ff:ff:ff:ff:ff:ff
[   30.764515] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_ADD_STA
[   30.764525] iwlwifi 0000:02:00.0: U is_lq_table_valid Channel 3 is not a=
n HT channel
[   30.764528] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_TX_LINK_QUALITY_CMD
[   30.764531] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_TX_LINK_QUALITY_CMD
[   30.764645] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_TX_LINK_QUALITY_CMD
[   30.764655] iwlwifi 0000:02:00.0: U iwl_send_lq_cmd init LQ command comp=
lete, clearing sta addition status for sta 15
[   30.764658] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations .... complete.
[   30.764670] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   30.764674] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command POWER_TABLE_CMD
[   30.764677] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command POWER_TABLE_CMD
[   30.766104] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command POWER_TABLE_CMD
[   30.766116] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   30.766119] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   30.766123] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   30.766126] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   30.766129] iwlwifi 0000:02:00.0: U iwl_set_rxon_channel Staging channel=
 set to 3 [0]
[   30.766131] iwlwifi 0000:02:00.0: U iwl_set_rxon_channel Staging channel=
 set to 3 [0]
[   30.766135] iwlwifi 0000:02:00.0: U iwl_full_rxon_required need full RXO=
N - !iwl_is_associated_ctx(ctx)
[   30.766137] iwlwifi 0000:02:00.0: U iwlagn_commit_rxon Going to commit R=
XON
[   30.766138]   * without RXON_FILTER_ASSOC_MSK
[   30.766138]   * channel =3D 3
[   30.766139]   * bssid =3D 00:00:00:00:00:00
[   30.766140] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_RXON
[   30.766142] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_RXON
[   30.767450] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_RXON
[   30.767460] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations Clearing uc=
ode stations in driver
[   30.767464] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations Clearing uc=
ode active for station 15
[   30.767467] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations ... start.
[   30.767470] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring sta f=
f:ff:ff:ff:ff:ff
[   30.767474] iwlwifi 0000:02:00.0: U iwl_send_add_sta Adding sta 15 (ff:f=
f:ff:ff:ff:ff) synchronously
[   30.767476] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_ADD_STA
[   30.767479] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_ADD_STA
[   30.784164] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Processing =
response for adding station 15
[   30.784166] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp REPLY_ADD_S=
TA PASSED
[   30.784168] iwlwifi 0000:02:00.0: I iwl_sta_ucode_activate Added STA id =
15 addr ff:ff:ff:ff:ff:ff to uCode
[   30.784170] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on id 15 addr ff:ff:ff:ff:ff:ff
[   30.784172] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on according to cmd buffer ff:ff:ff:ff:ff:ff
[   30.784175] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_ADD_STA
[   30.784186] iwlwifi 0000:02:00.0: U is_lq_table_valid Channel 1 is not a=
n HT channel
[   30.784188] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_TX_LINK_QUALITY_CMD
[   30.784189] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_TX_LINK_QUALITY_CMD
[   30.784315] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_TX_LINK_QUALITY_CMD
[   30.784327] iwlwifi 0000:02:00.0: U iwl_send_lq_cmd init LQ command comp=
lete, clearing sta addition status for sta 15
[   30.784329] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations .... complete.
[   30.784332] wlan0: associate with 00:1e:2a:f6:f1:4a (try 1)
[   30.788402] wlan0: RX AssocResp from 00:1e:2a:f6:f1:4a (capab=3D0x431 st=
atus=3D0 aid=3D6)
[   30.788404] wlan0: associated
[   30.788406] wlan0: moving STA 00:1e:2a:f6:f1:4a to state 1
[   30.788408] wlan0: moving STA 00:1e:2a:f6:f1:4a to state 2
[   30.788411] iwlwifi 0000:02:00.0: U iwlagn_mac_sta_add proceeding to add=
 station 00:1e:2a:f6:f1:4a
[   30.788413] iwlwifi 0000:02:00.0: U iwl_prep_station Add STA to driver I=
D 0: 00:1e:2a:f6:f1:4a
[   30.788416] iwlwifi 0000:02:00.0: U iwl_send_add_sta Adding sta 0 (00:1e=
:2a:f6:f1:4a) synchronously
[   30.788418] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_ADD_STA
[   30.788419] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_ADD_STA
[   30.788554] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Processing =
response for adding station 0
[   30.788557] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp REPLY_ADD_S=
TA PASSED
[   30.788559] iwlwifi 0000:02:00.0: I iwl_sta_ucode_activate Added STA id =
0 addr 00:1e:2a:f6:f1:4a to uCode
[   30.788561] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on id 0 addr 00:1e:2a:f6:f1:4a
[   30.788563] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on according to cmd buffer 00:1e:2a:f6:f1:4a
[   30.788565] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_ADD_STA
[   30.788575] iwlwifi 0000:02:00.0: U iwlagn_mac_sta_add Initializing rate=
 scaling for station 00:1e:2a:f6:f1:4a
[   30.788580] iwlwifi 0000:02:00.0: U is_lq_table_valid Channel 3 is not a=
n HT channel
[   30.788582] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_TX_LINK_QUALITY_CMD
[   30.788583] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_TX_LINK_QUALITY_CMD
[   30.788704] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_TX_LINK_QUALITY_CMD
[   30.788714] iwlwifi 0000:02:00.0: U iwl_send_lq_cmd init LQ command comp=
lete, clearing sta addition status for sta 0
[   30.788723] iwlwifi 0000:02:00.0: U iwlagn_update_qos send QoS cmd with =
Qos active=3D1 FLAGS=3D0x1
[   30.788726] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_QOS_PARAM
[   30.788728] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_QOS_PARAM
[   30.788827] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_QOS_PARAM
[   30.788839] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   30.788842] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   30.788845] iwlwifi 0000:02:00.0: U iwl_full_rxon_required need full RXO=
N - !iwl_is_associated_ctx(ctx)
[   30.788847] iwlwifi 0000:02:00.0: U iwlagn_commit_rxon Going to commit R=
XON
[   30.788848]   * with RXON_FILTER_ASSOC_MSK
[   30.788848]   * channel =3D 3
[   30.788849]   * bssid =3D 00:1e:2a:f6:f1:4a
[   30.788850] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_RXON
[   30.788851] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_RXON
[   30.789487] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_RXON
[   30.789497] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations Clearing uc=
ode stations in driver
[   30.789500] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations Clearing uc=
ode active for station 0
[   30.789503] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations Clearing uc=
ode active for station 15
[   30.789505] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations ... start.
[   30.789507] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring sta 0=
0:1e:2a:f6:f1:4a
[   30.789509] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring sta f=
f:ff:ff:ff:ff:ff
[   30.789511] iwlwifi 0000:02:00.0: U iwl_send_add_sta Adding sta 0 (00:1e=
:2a:f6:f1:4a) synchronously
[   30.789513] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_ADD_STA
[   30.789514] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_ADD_STA
[   30.789634] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Processing =
response for adding station 0
[   30.789636] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp REPLY_ADD_S=
TA PASSED
[   30.789638] iwlwifi 0000:02:00.0: I iwl_sta_ucode_activate Added STA id =
0 addr 00:1e:2a:f6:f1:4a to uCode
[   30.789640] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on id 0 addr 00:1e:2a:f6:f1:4a
[   30.789642] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on according to cmd buffer 00:1e:2a:f6:f1:4a
[   30.789644] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_ADD_STA
[   30.789654] iwlwifi 0000:02:00.0: U is_lq_table_valid Channel 3 is not a=
n HT channel
[   30.789656] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_TX_LINK_QUALITY_CMD
[   30.789658] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_TX_LINK_QUALITY_CMD
[   30.789786] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_TX_LINK_QUALITY_CMD
[   30.789796] iwlwifi 0000:02:00.0: U iwl_send_lq_cmd init LQ command comp=
lete, clearing sta addition status for sta 0
[   30.789800] iwlwifi 0000:02:00.0: U iwl_send_add_sta Adding sta 15 (ff:f=
f:ff:ff:ff:ff) synchronously
[   30.789802] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_ADD_STA
[   30.789803] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_ADD_STA
[   30.789932] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Processing =
response for adding station 15
[   30.789934] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp REPLY_ADD_S=
TA PASSED
[   30.789936] iwlwifi 0000:02:00.0: I iwl_sta_ucode_activate Added STA id =
15 addr ff:ff:ff:ff:ff:ff to uCode
[   30.789938] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on id 15 addr ff:ff:ff:ff:ff:ff
[   30.789940] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on according to cmd buffer ff:ff:ff:ff:ff:ff
[   30.789943] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_ADD_STA
[   30.789953] iwlwifi 0000:02:00.0: U is_lq_table_valid Channel 3 is not a=
n HT channel
[   30.789955] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_TX_LINK_QUALITY_CMD
[   30.789956] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_TX_LINK_QUALITY_CMD
[   30.790084] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_TX_LINK_QUALITY_CMD
[   30.790095] iwlwifi 0000:02:00.0: U iwl_send_lq_cmd init LQ command comp=
lete, clearing sta addition status for sta 15
[   30.790098] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations .... complete.
[   30.790101] iwlwifi 0000:02:00.0: U iwl_send_rxon_timing beacon interval=
 100 beacon timer 71051 beacon tim 0
[   30.790103] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_RXON_TIMING
[   30.790104] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_RXON_TIMING
[   30.790223] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_RXON_TIMING
[   30.790234] iwlwifi 0000:02:00.0: U iwlagn_update_qos send QoS cmd with =
Qos active=3D1 FLAGS=3D0x1
[   30.790236] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_QOS_PARAM
[   30.790238] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_QOS_PARAM
[   30.791698] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_QOS_PARAM
[   30.791704] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_RXON
[   30.791706] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_RXON
[   30.791969] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_RXON
[   30.791976] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_REMOVE_STA
[   30.791979] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_REMOVE_STA
[   30.792096] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_REMOVE_STA
[   30.792102] iwlwifi 0000:02:00.0: U iwl_send_remove_station REPLY_REMOVE=
_STA PASSED
[   30.792105] iwlwifi 0000:02:00.0: U iwl_send_add_sta Adding sta 0 (00:1e=
:2a:f6:f1:4a) synchronously
[   30.792107] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_ADD_STA
[   30.792109] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_ADD_STA
[   30.792200] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Processing =
response for adding station 0
[   30.792201] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp REPLY_ADD_S=
TA PASSED
[   30.792203] iwlwifi 0000:02:00.0: I iwl_sta_ucode_activate STA id 0 addr=
 00:1e:2a:f6:f1:4a already present in uCode (according to driver)
[   30.792205] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on id 0 addr 00:1e:2a:f6:f1:4a
[   30.792207] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on according to cmd buffer 00:1e:2a:f6:f1:4a
[   30.792209] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_ADD_STA
[   30.792215] iwlwifi 0000:02:00.0: U is_lq_table_valid Channel 3 is not a=
n HT channel
[   30.792217] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_TX_LINK_QUALITY_CMD
[   30.792218] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_TX_LINK_QUALITY_CMD
[   30.794085] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_TX_LINK_QUALITY_CMD
[   30.794092] iwlwifi 0000:02:00.0: U iwl_send_lq_cmd init LQ command comp=
lete, clearing sta addition status for sta 0
[   30.794099] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_TX_POWER_DBM_CMD
[   30.794101] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_TX_POWER_DBM_CMD
[   30.794793] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_TX_POWER_DBM_CMD
[   30.794800] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_PHY_CALIBRATION_CMD
[   30.794802] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_PHY_CALIBRATION_CMD
[   30.794905] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_PHY_CALIBRATION_CMD
[   30.795231] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   30.795287] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   30.795289] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   30.817212] iwlwifi 0000:02:00.0: U iwl_send_add_sta Adding sta 0 (00:1e=
:2a:f6:f1:4a) synchronously
[   30.817216] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_ADD_STA
[   30.817219] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_ADD_STA
[   30.817356] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Processing =
response for adding station 0
[   30.817358] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp REPLY_ADD_S=
TA PASSED
[   30.817360] iwlwifi 0000:02:00.0: I iwl_sta_ucode_activate STA id 0 addr=
 00:1e:2a:f6:f1:4a already present in uCode (according to driver)
[   30.817363] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on id 0 addr 00:1e:2a:f6:f1:4a
[   30.817364] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on according to cmd buffer 00:1e:2a:f6:f1:4a
[   30.817367] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_ADD_STA
[   30.817416] iwlwifi 0000:02:00.0: U iwl_send_add_sta Adding sta 0 (00:1e=
:2a:f6:f1:4a) synchronously
[   30.817418] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_ADD_STA
[   30.817421] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_ADD_STA
[   30.817558] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Processing =
response for adding station 0
[   30.817561] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp REPLY_ADD_S=
TA PASSED
[   30.817563] iwlwifi 0000:02:00.0: I iwl_sta_ucode_activate STA id 0 addr=
 00:1e:2a:f6:f1:4a already present in uCode (according to driver)
[   30.817565] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on id 0 addr 00:1e:2a:f6:f1:4a
[   30.817567] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on according to cmd buffer 00:1e:2a:f6:f1:4a
[   30.817569] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_ADD_STA
[   30.818101] wlan0: moving STA 00:1e:2a:f6:f1:4a to state 3
[   32.368765] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   32.370090] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   36.165346] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   40.006968] iwlwifi 0000:02:00.0: I is_lq_table_valid Channel 3 is not a=
n HT channel
[   40.831963] wlan0: no IPv6 routers present

--jI8keyz6grp/JLjh--

--ZoaI/ZTpAVc4A5k6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAEBAgAGBQJPoV7sAAoJEFMQTLzJFOZFUC0H/3LlNZ36VZ0wqtD5J9rTxy2R
on03AOabYmtJBPWj3JrBcTGSukNNUoQHIfcc++Gv6fK9X5o5QNS/sroMFIkDwBSc
20YxAhkwmMJ8tJnNcu2eWc1iSnAIzMF8gYlsYwugHBeDbWe31L/uiDoT9Bosqbd2
qQyxK2RoQRUP8JAlLHBt1VMfQE/w9ocOrVWLTUcCSQ7PapJZgHVHVfo0oy4WehhC
IX3DFUK2MKQ1ArQDaLjryhBm1LS68e91zOlRKDHDVGSalA0kjfjWqdbdUgY2Dtg1
mB9+hoQDFeMnEtK0W96DQT8ujII4/kil2BmPK4OKRT5oQMdhaz+5AXG+sbwObcM=
=7Kij
-----END PGP SIGNATURE-----

--ZoaI/ZTpAVc4A5k6--
