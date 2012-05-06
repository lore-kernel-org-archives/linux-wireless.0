Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from investici.nine.ch ([217.150.252.179]:63902 "EHLO
	confino.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850Ab2EFJPT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 May 2012 05:15:19 -0400
Date: Sun, 6 May 2012 11:15:32 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwlwifi warn_slowpath with 3.*
Message-ID: <20120506091526.GA2086@ritirata.org> (sfid-20120506_111531_101483_A934276A)
References: <20120504002136.GA4201@ritirata.org>
 <CANUX_P1Ji6H0zaA_kMHx2F1AD+czB=XtrDhjEvR8t1aCDpZhUQ@mail.gmail.com>
 <20120504063644.GA2912@ritirata.org>
 <CANUX_P0XhRQNVMQKtrw4j1UT9S=CMcjApCyNsdHHtLVME3jeEQ@mail.gmail.com>
 <20120504142006.GA2040@ritirata.org>
 <CANUX_P28EcqDVXQkSrGk2fetf=Evf2Yd_Fg9Czwb1jEPpdgTWg@mail.gmail.com>
 <CANUX_P0ygFyDjOo1Thygw_dEiHKPPiH4=GDKN4ncX3vwy0ujrw@mail.gmail.com>
 <20120506075433.GA1288@ritirata.org>
 <CANUX_P09Bx=kZ+OoHLTdZgJy_rJOQvutg3yVrBLHzPzV=KMQsg@mail.gmail.com>
 <20120506085637.GB1288@ritirata.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f2QGlHpHGjS2mn6Y"
In-Reply-To: <20120506085637.GB1288@ritirata.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--f2QGlHpHGjS2mn6Y
Content-Type: multipart/mixed; boundary="pWyiEgJYm5f9v55/"
Content-Disposition: inline


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, May 06, 2012 at 10:56:38AM +0200, Antonio Quartulli wrote:
> On Sun, May 06, 2012 at 11:26:32 +0300, Emmanuel Grumbach wrote:
> > All right,
> >=20
> > Can you please test the patch I sent to you (which was good but not eno=
ugh)
> > And add this one too ?
>=20
> Ok, I'll also leave the print.patch.
> I'll report the result.
>=20

The WARNING is gone :)

I attached the dmesg log anyway (debug was off, but there
are all the prints you introduced).

To be sure, I also removed all the IWL_ERR you added and tried to reboot (in
order to see whether the printings were affecting synchronization).


Thank you!

> Thank you
>=20
> >=20
> > Thanks
> >=20
> > Emmanuel Grumbach
> > egrumbach@gmail.com
> >=20
> >=20
> > On Sun, May 6, 2012 at 10:54 AM, Antonio Quartulli <ordex@autistici.org=
> wrote:
> > > On Sun, May 06, 2012 at 08:49:52 +0300, Emmanuel Grumbach wrote:
> > >> wait - I just noticed that this one introduced another issue...
> > >
> > > ok, I'll drop this patch
> > >
> > >>
> > >> Emmanuel Grumbach
> > >> egrumbach@gmail.com
> > >>
> > >>
> > >> On Sat, May 5, 2012 at 9:49 PM, Emmanuel Grumbach <egrumbach@gmail.c=
om> wrote:
> > >> > Well,
> > >> >
> > >> > this is not the same warning as before.
> > >> > Can you try the patch attached ?
> > >> > I have submitted it internally.
> > >> >
> > >> > thanks
> > >> >
> > >> > Emmanuel Grumbach
> > >> > egrumbach@gmail.com
> > >> >
> > >> >
> > >> > On Fri, May 4, 2012 at 5:20 PM, Antonio Quartulli <ordex@autistici=
=2Eorg> wrote:
> > >> >> On Fri, May 04, 2012 at 09:58:30 +0300, Emmanuel Grumbach wrote:
> > >> >>> This can't be with my patch, is it ?
> > >> >>
> > >> >> here is the log. Some pieces are missing at the beginning, didn't=
 check why.
> > >> >> However the WARNING comes up later, so it should be ok. Tell me i=
f I can do
> > >> >> something else!
> > >> >>
> > >> >> Cheers,
> > >> >>
> > >> >>
> > >> >> --
> > >> >> Antonio Quartulli
> > >> >>
> > >> >> ..each of us alone is worth nothing..
> > >> >> Ernesto "Che" Guevara
> > >
> > > --
> > > Antonio Quartulli
> > >
> > > ..each of us alone is worth nothing..
> > > Ernesto "Che" Guevara
>=20
>=20
>=20
> --=20
> Antonio Quartulli
>=20
> ..each of us alone is worth nothing..
> Ernesto "Che" Guevara



--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename=log1
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 3.4.0-rc5-wl+ (ordex@eagle4) (gcc version 4.6.=
3 (Gentoo 4.6.3 p1.0, pie-0.5.1) ) #26 SMP PREEMPT Fri May 4 16:14:26 CEST =
2012
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
 tables! (20120320/tbfadt-378)
[    0.000000] ACPI Warning: 32/64X FACS address mismatch in FADT - 0xCAFE4=
E40/0x00000000CAFE4D40, using 32 (20120320/tbfadt-502)
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
[    0.000000] PERCPU: Embedded 25 pages/cpu @ffff88012ec00000 s72512 r8192=
 d21696 u524288
[    0.000000] pcpu-alloc: s72512 r8192 d21696 u524288 alloc=3D1*2097152
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
[    0.000000] Memory: 3946504k/4964352k available (4636k kernel code, 8755=
28k absent, 142320k reserved, 3997k data, 564k init)
[    0.000000] SLUB: Genslabs=3D15, HWalign=3D64, Order=3D0-3, MinObjects=
=3D0, CPUs=3D4, Nodes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	Dump stacks of tasks blocking RCU-preempt GP.
[    0.000000] NR_IRQS:4352 nr_irqs:712 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty1] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.001000] Detected 2494.271 MHz processor.
[    0.000002] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 4988.54 BogoMIPS (lpj=3D2494271)
[    0.000145] pid_max: default: 32768 minimum: 301
[    0.000229] Security Framework initialized
[    0.000517] Dentry cache hash table entries: 524288 (order: 10, 4194304 =
bytes)
[    0.001417] Inode-cache hash table entries: 262144 (order: 9, 2097152 by=
tes)
[    0.001829] Mount-cache hash table entries: 256
[    0.002042] Initializing cgroup subsys freezer
[    0.002131] CPU: Physical Processor ID: 0
[    0.002200] CPU: Processor Core ID: 0
[    0.002272] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.002273] ENERGY_PERF_BIAS: View and update with x86_energy_perf_polic=
y(8)
[    0.002418] mce: CPU supports 7 MCE banks
[    0.002496] CPU0: Thermal monitoring enabled (TM1)
[    0.002571] using mwait in idle threads.
[    0.002704] ACPI: Core revision 20120320
[    0.007153] DMAR: Host address width 36
[    0.007225] DMAR: DRHD base: 0x000000fed90000 flags: 0x0
[    0.007302] IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c0000020e60262 e=
cap f0101a
[    0.007405] DMAR: DRHD base: 0x000000fed91000 flags: 0x1
[    0.007481] IOMMU 1: reg_base_addr fed91000 ver 1:0 cap c9008020660262 e=
cap f0105a
[    0.007583] DMAR: RMRR base: 0x000000cadc6000 end: 0x000000cadd5fff
[    0.007659] DMAR: RMRR base: 0x000000cb800000 end: 0x000000cf9fffff
[    0.007803] IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
[    0.007876] HPET id 0 under DRHD base 0xfed91000
[    0.007948] HPET id 0 under DRHD base 0xfed91000
[    0.008019] HPET id 0 under DRHD base 0xfed91000
[    0.008089] HPET id 0 under DRHD base 0xfed91000
[    0.008161] HPET id 0 under DRHD base 0xfed91000
[    0.008233] HPET id 0 under DRHD base 0xfed91000
[    0.008305] HPET id 0 under DRHD base 0xfed91000
[    0.008377] HPET id 0 under DRHD base 0xfed91000
[    0.008639] Enabled IRQ remapping in xapic mode
[    0.009181] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.019244] CPU0: Intel(R) Core(TM) i5-2520M CPU @ 2.50GHz stepping 07
[    0.120720] Performance Events: PEBS fmt1+, 16-deep LBR, SandyBridge eve=
nts, Intel PMU driver.
[    0.120980] PEBS disabled due to CPU errata.
[    0.121532] ... version:                3
[    0.121604] ... bit width:              48
[    0.121674] ... generic registers:      4
[    0.121747] ... value mask:             0000ffffffffffff
[    0.121819] ... max period:             000000007fffffff
[    0.121892] ... fixed-purpose events:   3
[    0.121963] ... event mask:             000000070000000f
[    0.133729] Booting Node   0, Processors  #1 #2 #3 Ok.
[    0.180984] Brought up 4 CPUs
[    0.181057] Total of 4 processors activated (19954.16 BogoMIPS).
[    0.183829] devtmpfs: initialized
[    0.184046] PM: Registering ACPI NVS region [mem 0xcade7000-0xcafe6fff] =
(2097152 bytes)
[    0.184178] Dell Latitude E5420 series board detected. Selecting PCI-met=
hod for reboots.
[    0.184324] NET: Registered protocol family 16
[    0.184457] kworker/u:0 used greatest stack depth: 6488 bytes left
[    0.184537] kworker/u:0 used greatest stack depth: 5480 bytes left
[    0.184810] ACPI FADT declares the system doesn't support PCIe ASPM, so =
disable it
[    0.184914] ACPI: bus type pci registered
[    0.185064] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000=
-0xfbffffff] (base 0xf8000000)
[    0.185170] PCI: not using MMCONFIG
[    0.185241] PCI: Using configuration type 1 for base access
[    0.185320] dmi type 0xB1 record - unknown flag
[    0.188530] bio: create slab <bio-0> at 0
[    0.188677] ACPI: Added _OSI(Module Device)
[    0.188748] ACPI: Added _OSI(Processor Device)
[    0.188819] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.188890] ACPI: Added _OSI(Processor Aggregator Device)
[    0.190486] ACPI: EC: Look up EC in DSDT
[    0.194330] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.200196] ACPI: SSDT 00000000cadd7718 0067C (v01  PmRef  Cpu0Cst 00003=
001 INTL 20090903)
[    0.200768] ACPI: Dynamic OEM Table Load:
[    0.200916] ACPI: SSDT           (null) 0067C (v01  PmRef  Cpu0Cst 00003=
001 INTL 20090903)
[    0.201309] ACPI: SSDT 00000000cadd8a98 00303 (v01  PmRef    ApIst 00003=
000 INTL 20090903)
[    0.201903] ACPI: Dynamic OEM Table Load:
[    0.202055] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003=
000 INTL 20090903)
[    0.202326] ACPI: SSDT 00000000cadd6d98 00119 (v01  PmRef    ApCst 00003=
000 INTL 20090903)
[    0.202894] ACPI: Dynamic OEM Table Load:
[    0.203042] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003=
000 INTL 20090903)
[    0.204617] ACPI: Interpreter enabled
[    0.204690] ACPI: (supports S0 S3 S4 S5)
[    0.204929] ACPI: Using IOAPIC for interrupt routing
[    0.205022] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000=
-0xfbffffff] (base 0xf8000000)
[    0.205475] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in ACP=
I motherboard resources
[    0.231415] ACPI: EC: GPE =3D 0x10, I/O: command/status =3D 0x934, data =
=3D 0x930
[    0.232016] ACPI: No dock devices found.
[    0.232089] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.232449] \_SB_.PCI0:_OSC invalid UUID
[    0.232451] _OSC request data:1 8 1f=20
[    0.232455] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    0.232967] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.233043] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.233119] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x00=
0bffff]
[    0.233222] pci_root PNP0A08:00: host bridge window [mem 0xcfa00000-0xfe=
afffff]
[    0.233324] pci_root PNP0A08:00: host bridge window [mem 0xfed40000-0xfe=
d44fff]
[    0.233470] PCI host bridge to bus 0000:00
[    0.233544] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.233623] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.233699] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.233775] pci_bus 0000:00: root bus resource [mem 0xcfa00000-0xfeaffff=
f]
[    0.233851] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed44ff=
f]
[    0.233936] pci 0000:00:00.0: [8086:0104] type 00 class 0x060000
[    0.233974] pci 0000:00:02.0: [8086:0126] type 00 class 0x030000
[    0.233984] pci 0000:00:02.0: reg 10: [mem 0xe2800000-0xe2bfffff 64bit]
[    0.233990] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit p=
ref]
[    0.233995] pci 0000:00:02.0: reg 20: [io  0x8000-0x803f]
[    0.234049] pci 0000:00:16.0: [8086:1c3a] type 00 class 0x078000
[    0.234073] pci 0000:00:16.0: reg 10: [mem 0xe5480000-0xe548000f 64bit]
[    0.234151] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.234188] pci 0000:00:1a.0: [8086:1c2d] type 00 class 0x0c0320
[    0.234209] pci 0000:00:1a.0: reg 10: [mem 0xe5450000-0xe54503ff]
[    0.234299] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.234327] pci 0000:00:1b.0: [8086:1c20] type 00 class 0x040300
[    0.234343] pci 0000:00:1b.0: reg 10: [mem 0xe5440000-0xe5443fff 64bit]
[    0.234412] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.234442] pci 0000:00:1c.0: [8086:1c10] type 01 class 0x060400
[    0.234577] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.234618] pci 0000:00:1c.1: [8086:1c12] type 01 class 0x060400
[    0.234749] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.234789] pci 0000:00:1c.2: [8086:1c14] type 01 class 0x060400
[    0.234920] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.234961] pci 0000:00:1c.5: [8086:1c1a] type 01 class 0x060400
[    0.235048] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.235076] pci 0000:00:1c.6: [8086:1c1c] type 01 class 0x060400
[    0.235160] pci 0000:00:1c.6: PME# supported from D0 D3hot D3cold
[    0.235192] pci 0000:00:1d.0: [8086:1c26] type 00 class 0x0c0320
[    0.235214] pci 0000:00:1d.0: reg 10: [mem 0xe5430000-0xe54303ff]
[    0.235305] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.235331] pci 0000:00:1f.0: [8086:1c49] type 00 class 0x060100
[    0.235457] pci 0000:00:1f.2: [8086:1c03] type 00 class 0x010601
[    0.235476] pci 0000:00:1f.2: reg 10: [io  0x80b0-0x80b7]
[    0.235484] pci 0000:00:1f.2: reg 14: [io  0x80a0-0x80a3]
[    0.235493] pci 0000:00:1f.2: reg 18: [io  0x8090-0x8097]
[    0.235501] pci 0000:00:1f.2: reg 1c: [io  0x8080-0x8083]
[    0.235509] pci 0000:00:1f.2: reg 20: [io  0x8060-0x807f]
[    0.235518] pci 0000:00:1f.2: reg 24: [mem 0xe5420000-0xe54207ff]
[    0.235567] pci 0000:00:1f.2: PME# supported from D3hot
[    0.235587] pci 0000:00:1f.3: [8086:1c22] type 00 class 0x0c0500
[    0.235603] pci 0000:00:1f.3: reg 10: [mem 0xe5410000-0xe54100ff 64bit]
[    0.235625] pci 0000:00:1f.3: reg 20: [io  0x8040-0x805f]
[    0.235726] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    0.236043] pci 0000:02:00.0: [8086:0082] type 00 class 0x028000
[    0.236192] pci 0000:02:00.0: reg 10: [mem 0xe5300000-0xe5301fff 64bit]
[    0.236897] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.238694] pci 0000:00:1c.1: PCI bridge to [bus 02-02]
[    0.238774] pci 0000:00:1c.1:   bridge window [mem 0xe5300000-0xe53fffff]
[    0.240579] pci 0000:03:00.0: [1217:8134] type 02 class 0x060700
[    0.240623] pci 0000:03:00.0: reg 10: [mem 0xe4030000-0xe4030fff]
[    0.240694] pci 0000:03:00.0: supports D1 D2
[    0.240696] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.240749] pci 0000:00:1c.2: PCI bridge to [bus 03-08]
[    0.240824] pci 0000:00:1c.2:   bridge window [io  0x6000-0x7fff]
[    0.240828] pci 0000:00:1c.2:   bridge window [mem 0xe2c00000-0xe40fffff]
[    0.240835] pci 0000:00:1c.2:   bridge window [mem 0xe0000000-0xe13fffff=
 64bit pref]
[    0.240979] pci 0000:09:00.0: [1217:13f7] type 00 class 0x0c0010
[    0.241012] pci 0000:09:00.0: reg 10: [mem 0xe5230000-0xe5230fff]
[    0.241262] pci 0000:09:00.0: supports D1 D2
[    0.241263] pci 0000:09:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.241352] pci 0000:09:00.1: [1217:8321] type 00 class 0x080501
[    0.241385] pci 0000:09:00.1: reg 10: [mem 0xe5220000-0xe52201ff]
[    0.241632] pci 0000:09:00.1: supports D1 D2
[    0.241633] pci 0000:09:00.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.241717] pci 0000:09:00.2: [1217:8331] type 00 class 0x018000
[    0.241750] pci 0000:09:00.2: reg 10: [mem 0xe5210000-0xe52103ff]
[    0.241797] pci 0000:09:00.2: reg 18: [mem 0xe5200000-0xe52003ff]
[    0.241999] pci 0000:09:00.2: supports D1 D2
[    0.242000] pci 0000:09:00.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.243611] pci 0000:00:1c.5: PCI bridge to [bus 09-09]
[    0.243704] pci 0000:00:1c.5:   bridge window [mem 0xe5200000-0xe52fffff]
[    0.243953] pci 0000:0a:00.0: [14e4:1681] type 00 class 0x020000
[    0.243992] pci 0000:0a:00.0: reg 10: [mem 0xe4110000-0xe411ffff 64bit]
[    0.244024] pci 0000:0a:00.0: reg 18: [mem 0xe4100000-0xe410ffff 64bit]
[    0.244213] pci 0000:0a:00.0: PME# supported from D3hot D3cold
[    0.245584] pci 0000:00:1c.6: PCI bridge to [bus 0a-11]
[    0.245682] pci 0000:00:1c.6:   bridge window [io  0x2000-0x5fff]
[    0.245686] pci 0000:00:1c.6:   bridge window [mem 0xe4100000-0xe51fffff]
[    0.245693] pci 0000:00:1c.6:   bridge window [mem 0xe1400000-0xe24fffff=
 64bit pref]
[    0.245720] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.245820] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.245846] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.245877] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP06._PRT]
[    0.245902] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP07._PRT]
[    0.245934] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    0.245998] \_SB_.PCI0:_OSC invalid UUID
[    0.245999] _OSC request data:1 1f 1f=20
[    0.246003]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.246101] \_SB_.PCI0:_OSC invalid UUID
[    0.246102] _OSC request data:1 0 1d=20
[    0.246106]  pci0000:00: ACPI _OSC request failed (AE_ERROR), returned c=
ontrol mask: 0x1d
[    0.246209] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.249398] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 1=
5) *11
[    0.250038] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12 14 1=
5) *10
[    0.250671] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 *5 6 7 10 12 14 =
15)
[    0.251237] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12 14 =
15)
[    0.251804] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 1=
5) *0, disabled.
[    0.252477] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 1=
5) *0, disabled.
[    0.253150] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 *3 4 5 6 7 10 12 14 =
15)
[    0.253719] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12 14 1=
5) *0, disabled.
[    0.254478] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.254591] vgaarb: loaded
[    0.254660] vgaarb: bridge control possible 0000:00:02.0
[    0.254832] SCSI subsystem initialized
[    0.254973] libata version 3.00 loaded.
[    0.255278] wmi: Mapper loaded
[    0.255365] PCI: Using ACPI for IRQ routing
[    0.257554] PCI: pci_cache_line_size set to 64 bytes
[    0.257708] reserve RAM buffer: 000000000009a800 - 000000000009ffff=20
[    0.257711] reserve RAM buffer: 00000000caa83000 - 00000000cbffffff=20
[    0.257713] reserve RAM buffer: 00000000cadb7000 - 00000000cbffffff=20
[    0.257715] reserve RAM buffer: 00000000cb000000 - 00000000cbffffff=20
[    0.257717] reserve RAM buffer: 000000012f000000 - 000000012fffffff=20
[    0.257867] NetLabel: Initializing
[    0.257938] NetLabel:  domain hash size =3D 128
[    0.258009] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    0.258088] NetLabel:  unlabeled traffic allowed by default
[    0.258237] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.258661] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.260749] Switching to clocksource hpet
[    0.260897] pnp: PnP ACPI init
[    0.260972] ACPI: bus type pnp registered
[    0.261278] pnp 00:00: [bus 00-3e]
[    0.261280] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.261282] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.261284] pnp 00:00: [io  0x0d00-0xffff window]
[    0.261286] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.261288] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    0.261289] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    0.261291] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    0.261293] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    0.261294] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    0.261296] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    0.261298] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    0.261299] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    0.261301] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    0.261303] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    0.261304] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    0.261306] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    0.261309] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    0.261310] pnp 00:00: [mem 0xcfa00000-0xfeafffff window]
[    0.261312] pnp 00:00: [mem 0xfed40000-0xfed44fff window]
[    0.261381] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (a=
ctive)
[    0.261393] pnp 00:01: [io  0x0000-0x001f]
[    0.261394] pnp 00:01: [io  0x0081-0x0091]
[    0.261396] pnp 00:01: [io  0x0093-0x009f]
[    0.261397] pnp 00:01: [io  0x00c0-0x00df]
[    0.261399] pnp 00:01: [dma 4]
[    0.261440] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.261447] pnp 00:02: [mem 0xff000000-0xffffffff]
[    0.261489] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
[    0.261559] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    0.261615] system 00:03: [mem 0xfed00000-0xfed003ff] has been reserved
[    0.261693] system 00:03: Plug and Play ACPI device, IDs PNP0103 PNP0c01=
 (active)
[    0.261702] pnp 00:04: [io  0x00f0]
[    0.261712] pnp 00:04: [irq 13]
[    0.261759] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.261768] pnp 00:05: [io  0x002e-0x002f]
[    0.261770] pnp 00:05: [io  0x004e-0x004f]
[    0.261771] pnp 00:05: [io  0x0061]
[    0.261772] pnp 00:05: [io  0x0063]
[    0.261774] pnp 00:05: [io  0x0065]
[    0.261775] pnp 00:05: [io  0x0067]
[    0.261776] pnp 00:05: [io  0x0070]
[    0.261778] pnp 00:05: [io  0x0080]
[    0.261779] pnp 00:05: [io  0x0092]
[    0.261780] pnp 00:05: [io  0x00b2-0x00b3]
[    0.261782] pnp 00:05: [io  0x0680-0x069f]
[    0.261783] pnp 00:05: [io  0x1000-0x100f]
[    0.261785] pnp 00:05: [io  0xffff]
[    0.261786] pnp 00:05: [io  0xffff]
[    0.261787] pnp 00:05: [io  0x0400-0x047f]
[    0.261789] pnp 00:05: [io  0x0500-0x057f]
[    0.261790] pnp 00:05: [io  0x164e-0x164f]
[    0.261853] system 00:05: [io  0x0680-0x069f] has been reserved
[    0.261940] system 00:05: [io  0x1000-0x100f] has been reserved
[    0.262015] system 00:05: [io  0xffff] has been reserved
[    0.262089] system 00:05: [io  0xffff] has been reserved
[    0.262163] system 00:05: [io  0x0400-0x047f] has been reserved
[    0.262236] system 00:05: [io  0x0500-0x057f] has been reserved
[    0.262310] system 00:05: [io  0x164e-0x164f] has been reserved
[    0.262386] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.262393] pnp 00:06: [io  0x0070-0x0077]
[    0.262400] pnp 00:06: [irq 8]
[    0.262447] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.262456] pnp 00:07: [io  0x0060]
[    0.262457] pnp 00:07: [io  0x0064]
[    0.262463] pnp 00:07: [irq 1]
[    0.262507] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.263400] pnp 00:08: Plug and Play ACPI device, IDs PNP0401 (disabled)
[    0.263414] pnp 00:09: [irq 12]
[    0.263463] pnp 00:09: Plug and Play ACPI device, IDs DLL049b PNP0f13 (a=
ctive)
[    0.263572] pnp 00:0a: [mem 0xfed1c000-0xfed1ffff]
[    0.263574] pnp 00:0a: [mem 0xfed10000-0xfed17fff]
[    0.263576] pnp 00:0a: [mem 0xfed18000-0xfed18fff]
[    0.263577] pnp 00:0a: [mem 0xfed19000-0xfed19fff]
[    0.263579] pnp 00:0a: [mem 0xf8000000-0xfbffffff]
[    0.263580] pnp 00:0a: [mem 0xfed20000-0xfed3ffff]
[    0.263582] pnp 00:0a: [mem 0xfed90000-0xfed93fff]
[    0.263583] pnp 00:0a: [mem 0xfed45000-0xfed8ffff]
[    0.263585] pnp 00:0a: [mem 0xff000000-0xffffffff]
[    0.263586] pnp 00:0a: [mem 0xfee00000-0xfeefffff]
[    0.263588] pnp 00:0a: [mem 0x00000000-0xffffffffffffffff disabled]
[    0.263590] pnp 00:0a: [mem 0x00000000-0xffffffffffffffff disabled]
[    0.263657] system 00:0a: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.263734] system 00:0a: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.263810] system 00:0a: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.263914] system 00:0a: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.263990] system 00:0a: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.264066] system 00:0a: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.264142] system 00:0a: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.264218] system 00:0a: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.264294] system 00:0a: [mem 0xff000000-0xffffffff] could not be reser=
ved
[    0.264371] system 00:0a: [mem 0xfee00000-0xfeefffff] has been reserved
[    0.264448] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.264506] pnp 00:0b: [irq 23]
[    0.264564] pnp 00:0b: Plug and Play ACPI device, IDs SMO8800 (active)
[    0.266006] pnp 00:0c: [mem 0x20000000-0x201fffff]
[    0.266008] pnp 00:0c: [mem 0x40000000-0x401fffff]
[    0.266085] system 00:0c: [mem 0x20000000-0x201fffff] has been reserved
[    0.266162] system 00:0c: [mem 0x40000000-0x401fffff] has been reserved
[    0.266238] system 00:0c: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.266246] pnp: PnP ACPI: found 13 devices
[    0.266317] ACPI: ACPI bus type pnp unregistered
[    0.274774] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    0.274866] pci 0000:00:1c.1: PCI bridge to [bus 02-02]
[    0.274943] pci 0000:00:1c.1:   bridge window [mem 0xe5300000-0xe53fffff]
[    0.275027] pci 0000:03:00.0: res[15]=3D[mem 0x04000000-0x03ffffff pref]=
 get_res_add_size add_size 4000000
[    0.275029] pci 0000:03:00.0: res[16]=3D[mem 0x04000000-0x03ffffff] get_=
res_add_size add_size 4000000
[    0.275032] pci 0000:03:00.0: res[13]=3D[io  0x0100-0x00ff] get_res_add_=
size add_size 100
[    0.275034] pci 0000:03:00.0: res[14]=3D[io  0x0100-0x00ff] get_res_add_=
size add_size 100
[    0.275038] pci 0000:03:00.0: BAR 15: can't assign mem pref (size 0x4000=
000)
[    0.275115] pci 0000:03:00.0: BAR 16: can't assign mem (size 0x4000000)
[    0.275193] pci 0000:03:00.0: BAR 13: assigned [io  0x6000-0x60ff]
[    0.275268] pci 0000:03:00.0: BAR 14: assigned [io  0x6400-0x64ff]
[    0.275343] pci 0000:03:00.0: BAR 16: can't assign mem (size 0x4000000)
[    0.275419] pci 0000:03:00.0: BAR 15: can't assign mem pref (size 0x4000=
000)
[    0.275496] pci 0000:03:00.0: BAR 14: assigned [io  0x6000-0x60ff]
[    0.275571] pci 0000:03:00.0: BAR 13: assigned [io  0x6400-0x64ff]
[    0.275646] pci 0000:03:00.0: CardBus bridge to [bus 04-07]
[    0.275720] pci 0000:03:00.0:   bridge window [io  0x6400-0x64ff]
[    0.275800] pci 0000:03:00.0:   bridge window [io  0x6000-0x60ff]
[    0.275886] pci 0000:00:1c.2: PCI bridge to [bus 03-08]
[    0.275961] pci 0000:00:1c.2:   bridge window [io  0x6000-0x7fff]
[    0.276040] pci 0000:00:1c.2:   bridge window [mem 0xe2c00000-0xe40fffff]
[    0.276119] pci 0000:00:1c.2:   bridge window [mem 0xe0000000-0xe13fffff=
 64bit pref]
[    0.276227] pci 0000:00:1c.5: PCI bridge to [bus 09-09]
[    0.276303] pci 0000:00:1c.5:   bridge window [mem 0xe5200000-0xe52fffff]
[    0.276388] pci 0000:00:1c.6: PCI bridge to [bus 0a-11]
[    0.276463] pci 0000:00:1c.6:   bridge window [io  0x2000-0x5fff]
[    0.276542] pci 0000:00:1c.6:   bridge window [mem 0xe4100000-0xe51fffff]
[    0.276619] pci 0000:00:1c.6:   bridge window [mem 0xe1400000-0xe24fffff=
 64bit pref]
[    0.276769] pci 0000:03:00.0: setting latency timer to 64
[    0.276785] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.276786] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.276788] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.276790] pci_bus 0000:00: resource 7 [mem 0xcfa00000-0xfeafffff]
[    0.276792] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed44fff]
[    0.276794] pci_bus 0000:02: resource 1 [mem 0xe5300000-0xe53fffff]
[    0.276796] pci_bus 0000:03: resource 0 [io  0x6000-0x7fff]
[    0.276797] pci_bus 0000:03: resource 1 [mem 0xe2c00000-0xe40fffff]
[    0.276799] pci_bus 0000:03: resource 2 [mem 0xe0000000-0xe13fffff 64bit=
 pref]
[    0.276801] pci_bus 0000:04: resource 0 [io  0x6400-0x64ff]
[    0.276803] pci_bus 0000:04: resource 1 [io  0x6000-0x60ff]
[    0.276805] pci_bus 0000:09: resource 1 [mem 0xe5200000-0xe52fffff]
[    0.276806] pci_bus 0000:0a: resource 0 [io  0x2000-0x5fff]
[    0.276808] pci_bus 0000:0a: resource 1 [mem 0xe4100000-0xe51fffff]
[    0.276810] pci_bus 0000:0a: resource 2 [mem 0xe1400000-0xe24fffff 64bit=
 pref]
[    0.276844] NET: Registered protocol family 2
[    0.277012] IP route cache hash table entries: 131072 (order: 8, 1048576=
 bytes)
[    0.277698] TCP established hash table entries: 524288 (order: 11, 83886=
08 bytes)
[    0.278983] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.279194] TCP: Hash tables configured (established 524288 bind 65536)
[    0.279270] TCP: reno registered
[    0.279345] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.279435] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.279572] NET: Registered protocol family 1
[    0.279654] pci 0000:00:02.0: Boot video device
[    0.279977] PCI: CLS 64 bytes, default 64
[    0.279997] DMAR: No ATSR found
[    0.280093] IOMMU 0 0xfed90000: using Queued invalidation
[    0.280167] IOMMU 1 0xfed91000: using Queued invalidation
[    0.280241] IOMMU: Setting RMRR:
[    0.280319] IOMMU: Setting identity map for device 0000:00:02.0 [0xcb800=
000 - 0xcf9fffff]
[    0.280794] IOMMU: Setting identity map for device 0000:00:1d.0 [0xcadc6=
000 - 0xcadd5fff]
[    0.280925] IOMMU: Setting identity map for device 0000:00:1a.0 [0xcadc6=
000 - 0xcadd5fff]
[    0.281518] IOMMU: Prepare 0-16MiB unity mapping for LPC
[    0.281597] IOMMU: Setting identity map for device 0000:00:1f.0 [0x0 - 0=
xffffff]
[    0.281950] PCI-DMA: Intel(R) Virtualization Technology for Directed I/O
[    0.282039] ------------[ cut here ]------------
[    0.282115] WARNING: at drivers/pci/search.c:44 pci_find_upstream_pcie_b=
ridge+0x5e/0x70()
[    0.282218] Hardware name: Latitude E5420
[    0.282289] Modules linked in:
[    0.282397] Pid: 1, comm: swapper/0 Not tainted 3.4.0-rc5-wl+ #26
[    0.282471] Call Trace:
[    0.282543]  [<ffffffff8103279a>] warn_slowpath_common+0x7a/0xb0
[    0.282618]  [<ffffffff810327e5>] warn_slowpath_null+0x15/0x20
[    0.282694]  [<ffffffff811fb34e>] pci_find_upstream_pcie_bridge+0x5e/0x70
[    0.282772]  [<ffffffff81377727>] intel_iommu_device_group+0x77/0x100
[    0.282855]  [<ffffffff81371fc5>] add_iommu_group+0x35/0x60
[    0.282930]  [<ffffffff81371f90>] ? bus_set_iommu+0x50/0x50
[    0.283005]  [<ffffffff812ebb0e>] bus_for_each_dev+0x4e/0x80
[    0.283080]  [<ffffffff81371f7b>] bus_set_iommu+0x3b/0x50
[    0.283156]  [<ffffffff818adbc9>] intel_iommu_init+0xa55/0xae4
[    0.283232]  [<ffffffff810fb996>] ? sys_mkdirat+0x76/0xd0
[    0.283308]  [<ffffffff818860b7>] ? memblock_find_dma_reserve+0x13d/0x13d
[    0.283385]  [<ffffffff818860ca>] pci_iommu_init+0x13/0x3e
[    0.283459]  [<ffffffff810001ca>] do_one_initcall+0x3a/0x160
[    0.283534]  [<ffffffff81882c13>] kernel_init+0x143/0x1c7
[    0.283608]  [<ffffffff81882589>] ? do_early_param+0x87/0x87
[    0.283683]  [<ffffffff814844d4>] kernel_thread_helper+0x4/0x10
[    0.283758]  [<ffffffff81882ad0>] ? start_kernel+0x2ed/0x2ed
[    0.283838]  [<ffffffff814844d0>] ? gs_change+0xb/0xb
[    0.283915] ---[ end trace e93713a9d40cd06c ]---
[    0.285675] Simple Boot Flag at 0xf3 set to 0x1
[    0.286659] microcode: CPU0 sig=3D0x206a7, pf=3D0x10, revision=3D0x15
[    0.286739] microcode: CPU1 sig=3D0x206a7, pf=3D0x10, revision=3D0x15
[    0.286833] microcode: CPU2 sig=3D0x206a7, pf=3D0x10, revision=3D0x15
[    0.286921] microcode: CPU3 sig=3D0x206a7, pf=3D0x10, revision=3D0x15
[    0.287058] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    0.287660] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.290750] VFS: Disk quotas dquot_6.5.2
[    0.290905] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.291495] msgmni has been set to 7836
[    0.291894] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 253)
[    0.291998] io scheduler noop registered (default)
[    0.292547] intel_idle: MWAIT substates: 0x21120
[    0.292549] intel_idle: v0.4 model 0x2A
[    0.292550] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.293194] ACPI: AC Adapter [AC] (on-line)
[    0.293686] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:=
00/input/input0
[    0.294076] ACPI: Lid Switch [LID]
[    0.294202] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0=
C:00/input/input1
[    0.294307] ACPI: Power Button [PBTN]
[    0.294433] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0=
E:00/input/input2
[    0.294539] ACPI: Sleep Button [SBTN]
[    0.294661] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input3
[    0.294764] ACPI: Power Button [PWRF]
[    0.294975] ACPI: Requesting acpi_cpufreq
[    0.315287] thermal LNXTHERM:00: registered as thermal_zone0
[    0.315362] ACPI: Thermal Zone [THM] (25 C)
[    0.315658] GHES: HEST is not enabled!
[    0.315720] ACPI: Battery Slot [BAT0] (battery absent)
[    0.315927] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.316601] Non-volatile memory driver v1.3
[    0.316714] Linux agpgart interface v0.103
[    0.316868] agpgart-intel 0000:00:00.0: Intel Sandybridge Chipset
[    0.317071] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K tota=
l, 262144K mappable
[    0.318284] agpgart-intel 0000:00:00.0: detected 65536K stolen memory
[    0.318493] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    0.318648] [drm] Initialized drm 1.1.0 20060810
[    0.318998] i915 0000:00:02.0: setting latency timer to 64
[    0.383851] i915 0000:00:02.0: irq 42 for MSI/MSI-X
[    0.383859] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    0.383935] [drm] Driver supports precise vblank timestamp query.
[    0.384037] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=
=3Dio+mem,decodes=3Dio+mem:owns=3Dio+mem
[    0.736107] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[    0.847768] fbcon: inteldrmfb (fb0) is primary device
[    1.284537] Refined TSC clocksource calibration: 2494.333 MHz.
[    1.284545] Switching to clocksource tsc
[    1.306006] Console: switching to colour frame buffer device 200x112
[    1.309248] fb0: inteldrmfb frame buffer device
[    1.309260] drm: registered panic notifier
[    1.325946] acpi device:36: registered as cooling_device4
[    1.332481] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:0=
0/LNXVIDEO:00/input/input4
[    1.332507] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    1.332555] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on mi=
nor 0
[    1.333966] brd: module loaded
[    1.334125] ahci 0000:00:1f.2: version 3.0
[    1.334182] ahci 0000:00:1f.2: irq 43 for MSI/MSI-X
[    1.334209] ahci: SSS flag set, parallel bus scan disabled
[    1.344504] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x=
3b impl SATA mode
[    1.344550] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio=
 slum part ems sxs apst=20
[    1.344575] ahci 0000:00:1f.2: setting latency timer to 64
[    1.353136] scsi0 : ahci
[    1.353229] scsi1 : ahci
[    1.353310] scsi2 : ahci
[    1.353391] scsi3 : ahci
[    1.353487] scsi4 : ahci
[    1.353566] scsi5 : ahci
[    1.353895] ata2: SATA max UDMA/133 abar m2048@0xe5420000 port 0xe542010=
0 irq 43
[    1.353916] ata3: SATA max UDMA/133 abar m2048@0xe5420000 port 0xe542018=
0 irq 43
[    1.353935] ata4: DUMMY
[    1.353945] ata5: SATA max UDMA/133 abar m2048@0xe5420000 port 0xe542028=
0 irq 43
[    1.353965] ata6: SATA max UDMA/133 abar m2048@0xe5420000 port 0xe542030=
0 irq 43
[    1.353985] ata7: SATA max UDMA/133 abar m2048@0xe5420000 port 0xe542038=
0 irq 43
[    1.354231] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0=
x60,0x64 irq 1,12
[    1.354476] i8042: Warning: Keylock active
[    1.355684] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.355716] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.355834] mousedev: PS/2 mouse device common for all mice
[    1.356081] rtc_cmos 00:06: RTC can wake from S4
[    1.356239] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    1.356289] rtc0: alarms up to one year, y3k, 242 bytes nvram, hpet irqs
[    1.356341] ACPI Warning: 0x0000000000008040-0x000000000000805f SystemIO=
 conflicts with Region \_SB_.PCI0.SBUS.SMBI 1 (20120320/utaddress-251)
[    1.356377] ACPI: If an ACPI driver is available for this device, you sh=
ould use it instead of the native driver
[    1.356596] EDAC MC: Ver: 2.1.0
[    1.356755] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input5
[    1.357024] cpuidle: using governor ladder
[    1.357116] cpuidle: using governor menu
[    1.357337] EFI Variables Facility v0.08 2004-May-17
[    1.357467] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    1.369786] input: Dell WMI hotkeys as /devices/virtual/input/input6
[    1.370669] dell_wmi_aio: No known WMI GUID found
[    1.370717] intel_oaktrail: Platform not recognized (You could try the m=
odule's force-parameter)
[    1.370842] TCP: cubic registered
[    1.370857] TCP: vegas registered
[    1.370867] TCP: yeah registered
[    1.370877] Initializing XFRM netlink socket
[    1.371057] NET: Registered protocol family 10
[    1.371239] NET: Registered protocol family 17
[    1.371254] Registering the dns_resolver key type
[    1.371399] PM: Checking hibernation image partition /dev/sda3
[    1.658150] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.661762] ata2.00: ACPI cmd 00/00:00:00:00:00:a0 (unknown) rejected by=
 device (Stat=3D0x51 Err=3D0x04)
[    1.662250] ata2.00: ATA-8: ST9320423AS, D005SDM1, max UDMA/133
[    1.662302] ata2.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    1.665541] ata2.00: ACPI cmd 00/00:00:00:00:00:a0 (unknown) rejected by=
 device (Stat=3D0x51 Err=3D0x04)
[    1.665918] ata2.00: configured for UDMA/133
[    1.666139] scsi 0:0:0:0: Direct-Access     ATA      ST9320423AS      D0=
05 PQ: 0 ANSI: 5
[    1.666391] sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB=
/298 GiB)
[    1.666472] sd 0:0:0:0: [sda] Write Protect is off
[    1.666485] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.666502] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.666523] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    1.720929]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[    1.721730] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.970746] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.982565] ata3.00: ATAPI: TSSTcorp DVD+/-RW TS-L633J, D400, max UDMA/1=
00
[    1.997940] ata3.00: configured for UDMA/100
[    2.007088] scsi 1:0:0:0: CD-ROM            TSSTcorp DVD+-RW TS-L633J D4=
00 PQ: 0 ANSI: 5
[    2.017570] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 =
cdda tray
[    2.017607] cdrom: Uniform CD-ROM driver Revision: 3.20
[    2.018005] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    2.018118] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    2.322289] ata5: SATA link down (SStatus 0 SControl 300)
[    2.626896] ata6: SATA link down (SStatus 0 SControl 300)
[    2.931504] ata7: SATA link down (SStatus 0 SControl 300)
[    2.931650] PM: Hibernation image partition 8:3 present
[    2.931653] PM: Looking for hibernation image.
[    2.940425] PM: Image not found (code -22)
[    2.940428] PM: Hibernation image not present or could not be loaded.
[    2.940438] registered taskstats version 1
[    2.954943] EXT4-fs (sda5): couldn't mount as ext3 due to feature incomp=
atibilities
[    2.962339] EXT4-fs (sda5): couldn't mount as ext2 due to feature incomp=
atibilities
[    3.029956] EXT4-fs (sda5): mounted filesystem with ordered data mode. O=
pts: (null)
[    3.029992] VFS: Mounted root (ext4 filesystem) readonly on device 8:5.
[    3.030823] Freeing unused kernel memory: 564k freed
[    3.030903] Write protecting the kernel read-only data: 8192k
[    3.034603] Freeing unused kernel memory: 1488k freed
[    3.036230] Freeing unused kernel memory: 580k freed
[    4.644438] systemd-cryptse used greatest stack depth: 5120 bytes left
[    5.832613] systemd-sysctl used greatest stack depth: 4648 bytes left
[    6.044239] udevd[847]: starting version 182
[    6.264506] mount used greatest stack depth: 4624 bytes left
[    7.643282] usbcore: registered new interface driver usbfs
[    7.644541] usbcore: registered new interface driver hub
[    7.645763] usbcore: registered new device driver usb
[    7.680804] cfg80211: Calling CRDA to update world regulatory domain
[    7.711681] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    7.712959] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    7.712964] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    7.714169] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus =
number 1
[    7.715399] ehci_hcd 0000:00:1a.0: debug port 2
[    7.720475] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    7.720491] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xe5450000
[    7.727212] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    7.728472] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    7.729732] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    7.730935] usb usb1: Product: EHCI Host Controller
[    7.732130] usb usb1: Manufacturer: Linux 3.4.0-rc5-wl+ ehci_hcd
[    7.733323] usb usb1: SerialNumber: 0000:00:1a.0
[    7.734661] hub 1-0:1.0: USB hub found
[    7.735859] hub 1-0:1.0: 2 ports detected
[    7.737129] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    7.737133] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    7.738337] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus =
number 2
[    7.739550] ehci_hcd 0000:00:1d.0: debug port 2
[    7.744614] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    7.744627] ehci_hcd 0000:00:1d.0: irq 17, io mem 0xe5430000
[    7.751176] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    7.752487] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    7.753687] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    7.754842] usb usb2: Product: EHCI Host Controller
[    7.755996] usb usb2: Manufacturer: Linux 3.4.0-rc5-wl+ ehci_hcd
[    7.757136] usb usb2: SerialNumber: 0000:00:1d.0
[    7.758515] hub 2-0:1.0: USB hub found
[    7.759677] hub 2-0:1.0: 2 ports detected
[    7.796029] snd_hda_intel 0000:00:1b.0: irq 44 for MSI/MSI-X
[    7.983575] iwlwifi: Intel(R) Wireless WiFi Link AGN driver for Linux, i=
n-tree:d
[    7.984750] iwlwifi: Copyright(c) 2003-2012 Intel Corporation
[    7.986520] iwlwifi 0000:02:00.0: pci_resource_len =3D 0x00002000
[    7.987673] iwlwifi 0000:02:00.0: pci_resource_base =3D ffffc90000674000
[    7.990316] iwlwifi 0000:02:00.0: HW Revision ID =3D 0x34
[    7.992324] iwlwifi 0000:02:00.0: irq 45 for MSI/MSI-X
[    8.037867] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[    8.054864] iwlwifi 0000:02:00.0: loaded firmware version 17.168.5.3 bui=
ld 42301
[    8.055018] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_DEBUG enabled
[    8.057316] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
[    8.058515] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
[    8.059669] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE enabled
[    8.060860] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_P2P enabled
[    8.062030] iwlwifi 0000:02:00.0: Detected Intel(R) Centrino(R) Advanced=
-N 6205 AGN, REV=3D0xB0
[    8.063312] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[    8.081441] iwlwifi 0000:02:00.0: device EEPROM VER=3D0x715, CALIB=3D0x6
[    8.082563] iwlwifi 0000:02:00.0: Device SKU: 0x1F0
[    8.083712] iwlwifi 0000:02:00.0: Valid Tx ant: 0x3, Valid Rx ant: 0x3
[    8.084855] iwlwifi 0000:02:00.0: Tunable channels: 13 802.11bg, 24 802.=
11a channels
[    8.086069] Registered led device: phy0-led
[    8.086318] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[    8.153052] usb 1-1: New USB device found, idVendor=3D8087, idProduct=3D=
0024
[    8.154226] usb 1-1: New USB device strings: Mfr=3D0, Product=3D0, Seria=
lNumber=3D0
[    8.155763] hub 1-1:1.0: USB hub found
[    8.157044] hub 1-1:1.0: 6 ports detected
[    8.260522] usb 2-1: new high-speed USB device number 2 using ehci_hcd
[    8.375761] usb 2-1: New USB device found, idVendor=3D8087, idProduct=3D=
0024
[    8.376931] usb 2-1: New USB device strings: Mfr=3D0, Product=3D0, Seria=
lNumber=3D0
[    8.378786] hub 2-1:1.0: USB hub found
[    8.379991] hub 2-1:1.0: 6 ports detected
[    8.455460] usb 1-1.4: new high-speed USB device number 3 using ehci_hcd
[    8.576411] cfg80211: World regulatory domain updated:
[    8.577510] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenn=
a_gain, max_eirp)
[    8.578662] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mB=
i, 2000 mBm)
[    8.579772] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mB=
i, 2000 mBm)
[    8.580904] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mB=
i, 2000 mBm)
[    8.582012] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mB=
i, 2000 mBm)
[    8.583141] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mB=
i, 2000 mBm)
[    8.584333] input: DualPoint Stick as /devices/platform/i8042/serio1/inp=
ut/input7
[    8.599826] input: AlpsPS/2 ALPS DualPoint TouchPad as /devices/platform=
/i8042/serio1/input/input8
[    8.710331] usb 1-1.4: New USB device found, idVendor=3D1bcf, idProduct=
=3D280b
[    8.711481] usb 1-1.4: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[    8.712620] usb 1-1.4: Product: Laptop_Integrated_Webcam_FHD
[    8.713715] usb 1-1.4: Manufacturer: CN0CJ3P27248715OB5MJA00
[    8.749552] modprobe used greatest stack depth: 4584 bytes left
[    8.842324] input: HDA Intel PCH HDMI/DP,pcm=3D8 as /devices/pci0000:00/=
0000:00:1b.0/sound/card0/input9
[    8.843594] input: HDA Intel PCH HDMI/DP,pcm=3D7 as /devices/pci0000:00/=
0000:00:1b.0/sound/card0/input10
[    8.844826] input: HDA Intel PCH HDMI/DP,pcm=3D3 as /devices/pci0000:00/=
0000:00:1b.0/sound/card0/input11
[    8.846044] input: HDA Intel PCH Dock Mic as /devices/pci0000:00/0000:00=
:1b.0/sound/card0/input12
[    8.847268] input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1b.0=
/sound/card0/input13
[    8.848499] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:0=
0:1b.0/sound/card0/input14
[    8.849744] input: HDA Intel PCH Dock Line Out as /devices/pci0000:00/00=
00:00:1b.0/sound/card0/input15
[    9.003715] usb 2-1.4: new high-speed USB device number 3 using ehci_hcd
[    9.090955] usb 2-1.4: New USB device found, idVendor=3D05e3, idProduct=
=3D0608
[    9.092176] usb 2-1.4: New USB device strings: Mfr=3D0, Product=3D1, Ser=
ialNumber=3D0
[    9.093379] usb 2-1.4: Product: USB2.0 Hub
[    9.095042] hub 2-1.4:1.0: USB hub found
[    9.096584] hub 2-1.4:1.0: 4 ports detected
[    9.172494] usb 2-1.6: new full-speed USB device number 4 using ehci_hcd
[    9.262357] usb 2-1.6: New USB device found, idVendor=3D413c, idProduct=
=3D8187
[    9.263557] usb 2-1.6: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D3
[    9.264749] usb 2-1.6: Product: DW375 Bluetooth Module
[    9.265925] usb 2-1.6: Manufacturer: Dell Computer Corp
[    9.266320] Linux video capture interface: v2.00
[    9.268273] usb 2-1.6: SerialNumber: C0F8DAE4FAE3
[    9.272671] uvcvideo: Found UVC 1.00 device Laptop_Integrated_Webcam_FHD=
 (1bcf:280b)
[    9.307394] input: Laptop_Integrated_Webcam_FHD as /devices/pci0000:00/0=
000:00:1a.0/usb1/1-1/1-1.4/1-1.4:1.0/input/input16
[    9.308747] usbcore: registered new interface driver uvcvideo
[    9.309986] USB Video Class driver (1.1.1)
[    9.362371] usb 2-1.4.2: new low-speed USB device number 5 using ehci_hcd
[    9.452252] usb 2-1.4.2: New USB device found, idVendor=3D046a, idProduc=
t=3D0023
[    9.453486] usb 2-1.4.2: New USB device strings: Mfr=3D0, Product=3D0, S=
erialNumber=3D0
[    9.502890] usbcore: registered new interface driver usbhid
[    9.504142] usbhid: USB HID core driver
[    9.529210] usb 2-1.4.4: new high-speed USB device number 6 using ehci_h=
cd
[    9.550972] input: HID 046a:0023 as /devices/pci0000:00/0000:00:1d.0/usb=
2/2-1/2-1.4/2-1.4.2/2-1.4.2:1.0/input/input17
[    9.552677] cherry 0003:046A:0023.0001: input,hidraw0: USB HID v1.11 Key=
board [HID 046a:0023] on usb-0000:00:1d.0-1.4.2/input0
[    9.563554] input: HID 046a:0023 as /devices/pci0000:00/0000:00:1d.0/usb=
2/2-1/2-1.4/2-1.4.2/2-1.4.2:1.1/input/input18
[    9.565263] cherry 0003:046A:0023.0002: input,hidraw1: USB HID v1.11 Dev=
ice [HID 046a:0023] on usb-0000:00:1d.0-1.4.2/input1
[    9.606410] usb 2-1.4.4: New USB device found, idVendor=3D05e3, idProduc=
t=3D0608
[    9.607778] usb 2-1.4.4: New USB device strings: Mfr=3D0, Product=3D1, S=
erialNumber=3D0
[    9.609127] usb 2-1.4.4: Product: USB2.0 Hub
[    9.611035] hub 2-1.4.4:1.0: USB hub found
[    9.612657] hub 2-1.4.4:1.0: 4 ports detected
[    9.879729] usb 2-1.4.4.1: new high-speed USB device number 7 using ehci=
_hcd
[    9.970697] usb 2-1.4.4.1: New USB device found, idVendor=3D05e3, idProd=
uct=3D0723
[    9.972084] usb 2-1.4.4.1: New USB device strings: Mfr=3D3, Product=3D4,=
 SerialNumber=3D0
[    9.973454] usb 2-1.4.4.1: Product: USB Storage
[    9.974735] usb 2-1.4.4.1: Manufacturer: Generic=20
[   10.027477] Initializing USB Mass Storage driver...
[   10.028945] usb-storage 2-1.4.4.1:1.0: Quirks match for vid 05e3 pid 072=
3: 8000
[   10.030320] scsi6 : usb-storage 2-1.4.4.1:1.0
[   10.031879] usbcore: registered new interface driver usb-storage
[   10.033260] USB Mass Storage support registered.
[   10.039495] usb 2-1.4.4.4: new low-speed USB device number 8 using ehci_=
hcd
[   10.130230] usb 2-1.4.4.4: New USB device found, idVendor=3D093a, idProd=
uct=3D2510
[   10.131600] usb 2-1.4.4.4: New USB device strings: Mfr=3D1, Product=3D2,=
 SerialNumber=3D0
[   10.132985] usb 2-1.4.4.4: Product: USB OPTICAL MOUSE
[   10.134301] usb 2-1.4.4.4: Manufacturer: PIXART
[   10.139281] input: PIXART USB OPTICAL MOUSE as /devices/pci0000:00/0000:=
00:1d.0/usb2/2-1/2-1.4/2-1.4.4/2-1.4.4.4/2-1.4.4.4:1.0/input/input19
[   10.140839] generic-usb 0003:093A:2510.0003: input,hidraw2: USB HID v1.1=
0 Mouse [PIXART USB OPTICAL MOUSE] on usb-0000:00:1d.0-1.4.4.4/input0
[   10.464900] Adding 8388604k swap on /dev/sda3.  Priority:0 extents:1 acr=
oss:8388604k=20
[   11.033336] scsi 6:0:0:0: Direct-Access     Generic  STORAGE DEVICE   94=
51 PQ: 0 ANSI: 0
[   11.035119] sd 6:0:0:0: Attached scsi generic sg2 type 0
[   11.039786] sd 6:0:0:0: [sdb] Attached SCSI removable disk
[   14.048812] udevd used greatest stack depth: 4224 bytes left
[   22.756375] EXT4-fs (sda5): re-mounted. Opts: (null)
[   23.061350] EXT4-fs (sda6): mounted filesystem with ordered data mode. O=
pts: (null)
[   25.487932] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[   25.494770] iwlwifi 0000:02:00.0: Radio type=3D0x1-0x2-0x0
[   25.558213] iwlwifi 0000:02:00.0: Sending command COEX_PRIORITY_TABLE_CM=
D (#5a), seq: 0x0900, 72 bytes at 0[0]:9
[   25.558265] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 0    TFD ffff880107b=
b0000   00000000fff5cc00
[   25.558300] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009000=
05a to 00000000fff5cc00 TB 1  [0, 0]
[   25.558434] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0000=
 Unmap 00000000fff5cc00 TBs 1
[   25.558482] iwlwifi 0000:02:00.0: Sending command REPLY_PHY_CALIBRATION_=
CMD (#b0), seq: 0x0901, 12 bytes at 1[1]:9
[   25.558545] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 1    TFD ffff880107b=
b0080   00000000ffcd6c00
[   25.558579] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009010=
0b0 to 00000000ffcd6c00 TB 1  [1, 1]
[   25.558622] iwlwifi 0000:02:00.0: ATTACHED 2 tbs to 1    TFD ffff880107b=
b0080   00000000ffcd5c18
[   25.559084] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0080=
 Unmap 00000000ffcd6c00 TBs 2
[   25.559143] iwlwifi 0000:02:00.0: Sending command CALIBRATION_CFG_CMD (#=
65), seq: 0x0902, 96 bytes at 2[2]:9
[   25.559210] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 2    TFD ffff880107b=
b0100   00000000ffc2d400
[   25.559259] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009020=
065 to 00000000ffc2d400 TB 1  [2, 2]
[   25.559395] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0100=
 Unmap 00000000ffc2d400 TBs 1
[   25.780256] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[   25.787098] iwlwifi 0000:02:00.0: Radio type=3D0x1-0x2-0x0
[   25.853889] iwlwifi 0000:02:00.0: Sending command COEX_PRIORITY_TABLE_CM=
D (#5a), seq: 0x0900, 72 bytes at 0[0]:9
[   25.853942] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 0    TFD ffff880107b=
b0000   00000000fff5cc00
[   25.853977] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009000=
05a to 00000000fff5cc00 TB 1  [0, 0]
[   25.854129] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0000=
 Unmap 00000000fff5cc00 TBs 1
[   25.854203] iwlwifi 0000:02:00.0: Sending command REPLY_PHY_CALIBRATION_=
CMD (#b0), seq: 0x0901, 12 bytes at 1[1]:9
[   25.854265] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 1    TFD ffff880107b=
b0080   00000000ffd69c00
[   25.854299] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009010=
0b0 to 00000000ffd69c00 TB 1  [1, 1]
[   25.854343] iwlwifi 0000:02:00.0: ATTACHED 2 tbs to 1    TFD ffff880107b=
b0080   00000000ffd68d98
[   25.854772] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0080=
 Unmap 00000000ffd69c00 TBs 2
[   25.854893] iwlwifi 0000:02:00.0: Sending command REPLY_PHY_CALIBRATION_=
CMD (#b0), seq: 0x0902, 12 bytes at 2[2]:9
[   25.854944] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 2    TFD ffff880107b=
b0100   00000000ffd63400
[   25.854978] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009020=
0b0 to 00000000ffd63400 TB 1  [2, 2]
[   25.855021] iwlwifi 0000:02:00.0: ATTACHED 2 tbs to 2    TFD ffff880107b=
b0100   00000000ffd62918
[   25.855133] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0100=
 Unmap 00000000ffd63400 TBs 2
[   25.855178] iwlwifi 0000:02:00.0: Sending command REPLY_PHY_CALIBRATION_=
CMD (#b0), seq: 0x0903, 12 bytes at 3[3]:9
[   25.855228] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 3    TFD ffff880107b=
b0180   00000000ffd5f600
[   25.855262] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009030=
0b0 to 00000000ffd5f600 TB 1  [3, 3]
[   25.855307] iwlwifi 0000:02:00.0: ATTACHED 2 tbs to 3    TFD ffff880107b=
b0180   00000000ffd5ed98
[   25.855441] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0180=
 Unmap 00000000ffd5f600 TBs 2
[   25.855517] iwlwifi 0000:02:00.0: Sending command REPLY_PHY_CALIBRATION_=
CMD (#b0), seq: 0x0904, 520 bytes at 4[4]:9
[   25.855567] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 4    TFD ffff880107b=
b0200   00000000ffd5ba00
[   25.855601] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009040=
0b0 to 00000000ffd5ba00 TB 1  [4, 4]
[   25.855644] iwlwifi 0000:02:00.0: ATTACHED 2 tbs to 4    TFD ffff880107b=
b0200   00000000ffd5a818
[   25.855803] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0200=
 Unmap 00000000ffd5ba00 TBs 2
[   25.855865] iwlwifi 0000:02:00.0: Sending command REPLY_PHY_CALIBRATION_=
CMD (#b0), seq: 0x0905, 1352 bytes at 5[5]:9
[   25.855929] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 5    TFD ffff880107b=
b0280   00000000ffd57800
[   25.855979] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009050=
0b0 to 00000000ffd57800 TB 1  [5, 5]
[   25.855983] iwlwifi 0000:02:00.0: ATTACHED 2 tbs to 5    TFD ffff880107b=
b0280   00000000ffd56818
[   25.856095] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0280=
 Unmap 00000000ffd57800 TBs 2
[   25.856104] iwlwifi 0000:02:00.0: Sending command REPLY_PHY_CALIBRATION_=
CMD (#b0), seq: 0x0906, 92 bytes at 6[6]:9
[   25.856108] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 6    TFD ffff880107b=
b0300   00000000ffd53e00
[   25.856111] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009060=
0b0 to 00000000ffd53e00 TB 1  [6, 6]
[   25.856114] iwlwifi 0000:02:00.0: ATTACHED 2 tbs to 6    TFD ffff880107b=
b0300   00000000ffd52a18
[   25.856194] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0300=
 Unmap 00000000ffd53e00 TBs 2
[   25.856205] iwlwifi 0000:02:00.0: Sending command REPLY_BT_CONFIG (#9b),=
 seq: 0x0907, 16 bytes at 7[7]:9
[   25.856209] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 7    TFD ffff880107b=
b0380   00000000ffd4f200
[   25.856212] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009070=
09b to 00000000ffd4f200 TB 1  [7, 7]
[   25.856272] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0380=
 Unmap 00000000ffd4f200 TBs 1
[   25.856280] iwlwifi 0000:02:00.0: Sending command CALIBRATION_CFG_CMD (#=
65), seq: 0x0908, 96 bytes at 8[8]:9
[   25.856284] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 8    TFD ffff880107b=
b0400   00000000ffd4be00
[   25.856287] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009080=
065 to 00000000ffd4be00 TB 1  [8, 8]
[   25.856371] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0400=
 Unmap 00000000ffd4be00 TBs 1
[   25.856380] iwlwifi 0000:02:00.0: Sending command TX_ANT_CONFIGURATION_C=
MD (#98), seq: 0x0909, 8 bytes at 9[9]:9
[   25.856384] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 9    TFD ffff880107b=
b0480   00000000ffd47a00
[   25.856387] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009090=
098 to 00000000ffd47a00 TB 1  [9, 9]
[   25.883512] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0480=
 Unmap 00000000ffd47a00 TBs 1
[   25.885116] iwlwifi 0000:02:00.0: Sending command REPLY_STATISTICS_CMD (=
#9c), seq: 0x090A, 8 bytes at 10[10]:9
[   25.888199] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 10    TFD ffff880107=
bb0500   00000000fff57c00
[   25.888248] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000090a0=
09c to 00000000fff57c00 TB 1  [10, 10]
[   25.889846] iwlwifi 0000:02:00.0: Sending command REPLY_RXON (#10), seq:=
 0x090B, 54 bytes at 11[11]:9
[   25.889851] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 11    TFD ffff880107=
bb0580   00000000fff56600
[   25.889854] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000090b0=
010 to 00000000fff56600 TB 1  [11, 11]
[   25.889938] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0500=
 Unmap 00000000fff57c00 TBs 1
[   25.890944] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0580=
 Unmap 00000000fff56600 TBs 1
[   25.890962] iwlwifi 0000:02:00.0: Sending command REPLY_ADD_STA (#18), s=
eq: 0x090C, 96 bytes at 12[12]:9
[   25.890966] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 12    TFD ffff880107=
bb0600   00000000fff4f800
[   25.890971] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000090c0=
018 to 00000000fff4f800 TB 1  [12, 12]
[   25.907819] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0600=
 Unmap 00000000fff4f800 TBs 1
[   25.909414] iwlwifi 0000:02:00.0: Sending command REPLY_TX_LINK_QUALITY_=
CMD (#4e), seq: 0x090D, 92 bytes at 13[13]:9
[   25.912509] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 13    TFD ffff880107=
bb0680   00000000fff57200
[   25.912556] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000090d0=
04e to 00000000fff57200 TB 1  [13, 13]
[   25.914259] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0680=
 Unmap 00000000fff57200 TBs 1
[   25.915827] iwlwifi 0000:02:00.0: Sending command REPLY_CT_KILL_CONFIG_C=
MD (#a4), seq: 0x090E, 16 bytes at 14[14]:9
[   25.918895] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 14    TFD ffff880107=
bb0700   00000000fff49400
[   25.918945] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000090e0=
0a4 to 00000000fff49400 TB 1  [14, 14]
[   25.920603] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0700=
 Unmap 00000000fff49400 TBs 1
[   25.920618] iwlwifi 0000:02:00.0: Sending command POWER_TABLE_CMD (#77),=
 seq: 0x090F, 40 bytes at 15[15]:9
[   25.920623] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 15    TFD ffff880107=
bb0780   00000000fff4f000
[   25.920626] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000090f0=
077 to 00000000fff4f000 TB 1  [15, 15]
[   25.920688] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0780=
 Unmap 00000000fff4f000 TBs 1
[   25.920726] iwlwifi 0000:02:00.0: Sending command REPLY_LEDS_CMD (#48), =
seq: 0x0910, 12 bytes at 16[16]:9
[   25.920730] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 16    TFD ffff880107=
bb0800   00000000fff45e00
[   25.920734] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009100=
048 to 00000000fff45e00 TB 1  [16, 16]
[   25.920743] iwlwifi 0000:02:00.0: Sending command REPLY_RXON (#10), seq:=
 0x0911, 54 bytes at 17[17]:9
[   25.920748] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 17    TFD ffff880107=
bb0880   00000000fff44a00
[   25.920751] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009110=
010 to 00000000fff44a00 TB 1  [17, 17]
[   25.920817] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0800=
 Unmap 00000000fff45e00 TBs 1
[   25.920953] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0880=
 Unmap 00000000fff44a00 TBs 1
[   25.920970] iwlwifi 0000:02:00.0: Sending command REPLY_ADD_STA (#18), s=
eq: 0x0912, 96 bytes at 18[18]:9
[   25.920974] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 18    TFD ffff880107=
bb0900   00000000fff3dc00
[   25.920977] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009120=
018 to 00000000fff3dc00 TB 1  [18, 18]
[   25.921083] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0900=
 Unmap 00000000fff3dc00 TBs 1
[   25.921092] iwlwifi 0000:02:00.0: Sending command REPLY_TX_LINK_QUALITY_=
CMD (#4e), seq: 0x0913, 92 bytes at 19[19]:9
[   25.921097] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 19    TFD ffff880107=
bb0980   00000000fff3c800
[   25.921100] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009130=
04e to 00000000fff3c800 TB 1  [19, 19]
[   25.921189] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0980=
 Unmap 00000000fff3c800 TBs 1
[   25.921201] iwlwifi 0000:02:00.0: Sending command REPLY_RXON (#10), seq:=
 0x0914, 54 bytes at 20[20]:9
[   25.921205] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 20    TFD ffff880107=
bb0a00   00000000fff39600
[   25.921208] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009140=
010 to 00000000fff39600 TB 1  [20, 20]
[   25.921405] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0a00=
 Unmap 00000000fff39600 TBs 1
[   25.921439] iwlwifi 0000:02:00.0: Sending command REPLY_ADD_STA (#18), s=
eq: 0x0915, 96 bytes at 21[21]:9
[   25.921443] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 21    TFD ffff880107=
bb0a80   00000000ffd5f400
[   25.921446] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009150=
018 to 00000000ffd5f400 TB 1  [21, 21]
[   25.921545] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0a80=
 Unmap 00000000ffd5f400 TBs 1
[   25.921554] iwlwifi 0000:02:00.0: Sending command REPLY_TX_LINK_QUALITY_=
CMD (#4e), seq: 0x0916, 92 bytes at 22[22]:9
[   25.921557] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 22    TFD ffff880107=
bb0b00   00000000ffd5e000
[   25.921561] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009160=
04e to 00000000ffd5e000 TB 1  [22, 22]
[   25.921650] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0b00=
 Unmap 00000000ffd5e000 TBs 1
[   25.921669] iwlwifi 0000:02:00.0: Sending command REPLY_QOS_PARAM (#13),=
 seq: 0x0917, 40 bytes at 23[23]:9
[   25.921674] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 23    TFD ffff880107=
bb0b80   00000000ffd57800
[   25.921677] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009170=
013 to 00000000ffd57800 TB 1  [23, 23]
[   25.921751] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0b80=
 Unmap 00000000ffd57800 TBs 1
[   25.921771] iwlwifi 0000:02:00.0: Sending command POWER_TABLE_CMD (#77),=
 seq: 0x0918, 40 bytes at 24[24]:9
[   25.921775] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 24    TFD ffff880107=
bb0c00   00000000ffd4f600
[   25.921778] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009180=
077 to 00000000ffd4f600 TB 1  [24, 24]
[   25.921854] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0c00=
 Unmap 00000000ffd4f600 TBs 1
[   25.922433] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   25.954772] iwlwifi 0000:02:00.0: Sending command REPLY_SCAN_CMD (#80), =
seq: 0x0919, 994 bytes at 25[25]:9
[   25.954778] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 25    TFD ffff880107=
bb0c80   00000000ffd47400
[   25.954782] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009190=
080 to 00000000ffd47400 TB 1  [25, 25]
[   25.954786] iwlwifi 0000:02:00.0: ATTACHED 2 tbs to 25    TFD ffff880107=
bb0c80   00000000ffd46000
[   25.956310] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0c80=
 Unmap 00000000ffd47400 TBs 2
[   26.385856] iwlwifi 0000:02:00.0: Sending command REPLY_RXON (#10), seq:=
 0x091A, 54 bytes at 26[26]:9
[   26.388860] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 26    TFD ffff880107=
bb0d00   00000000ffef3a00
[   26.388906] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000091a0=
010 to 00000000ffef3a00 TB 1  [26, 26]
[   26.392110] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0d00=
 Unmap 00000000ffef3a00 TBs 1
[   26.393672] iwlwifi 0000:02:00.0: Sending command REPLY_ADD_STA (#18), s=
eq: 0x091B, 96 bytes at 27[27]:9
[   26.396650] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 27    TFD ffff880107=
bb0d80   00000000ffeede00
[   26.396697] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000091b0=
018 to 00000000ffeede00 TB 1  [27, 27]
[   26.399804] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0d80=
 Unmap 00000000ffeede00 TBs 1
[   26.401341] iwlwifi 0000:02:00.0: Sending command REPLY_TX_LINK_QUALITY_=
CMD (#4e), seq: 0x091C, 92 bytes at 28[28]:9
[   26.404316] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 28    TFD ffff880107=
bb0e00   00000000ffef3c00
[   26.404363] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000091c0=
04e to 00000000ffef3c00 TB 1  [28, 28]
[   26.407427] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0e00=
 Unmap 00000000ffef3c00 TBs 1
[   26.408998] iwlwifi 0000:02:00.0: Sending command REPLY_SCAN_CMD (#80), =
seq: 0x091D, 1120 bytes at 29[29]:9
[   26.412033] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 29    TFD ffff880107=
bb0e80   00000000ffef3e00
[   26.412037] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000091d0=
080 to 00000000ffef3e00 TB 1  [29, 29]
[   26.412041] iwlwifi 0000:02:00.0: ATTACHED 2 tbs to 29    TFD ffff880107=
bb0e80   00000000ffef2000
[   26.415144] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0e80=
 Unmap 00000000ffef3e00 TBs 2
[   31.114628] iwlwifi 0000:02:00.0: Sending command REPLY_SCAN_CMD (#80), =
seq: 0x091E, 994 bytes at 30[30]:9
[   31.117631] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 30    TFD ffff880107=
bb0f00   00000000ffe57c00
[   31.117680] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000091e0=
080 to 00000000ffe57c00 TB 1  [30, 30]
[   31.119236] iwlwifi 0000:02:00.0: ATTACHED 2 tbs to 30    TFD ffff880107=
bb0f00   00000000ffe56000
[   31.122408] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0f00=
 Unmap 00000000ffe57c00 TBs 2
[   31.596590] iwlwifi 0000:02:00.0: Sending command REPLY_SCAN_CMD (#80), =
seq: 0x091F, 1120 bytes at 31[31]:9
[   31.599634] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 31    TFD ffff880107=
bb0f80   00000000ffdfba00
[   31.599669] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000091f0=
080 to 00000000ffdfba00 TB 1  [31, 31]
[   31.601209] iwlwifi 0000:02:00.0: ATTACHED 2 tbs to 31    TFD ffff880107=
bb0f80   00000000ffdfa000
[   31.603772] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0f80=
 Unmap 00000000ffdfba00 TBs 2
[   34.541602] iwlwifi 0000:02:00.0: Sending command REPLY_RXON (#10), seq:=
 0x0920, 54 bytes at 32[0]:9
[   34.544656] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 32    TFD ffff880107=
bb1000   00000000ffd47c00
[   34.544705] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009200=
010 to 00000000ffd47c00 TB 1  [0, 32]
[   34.547951] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb1000=
 Unmap 00000000ffd47c00 TBs 1
[   34.549544] iwlwifi 0000:02:00.0: Sending command REPLY_ADD_STA (#18), s=
eq: 0x0921, 96 bytes at 33[1]:9
[   34.552587] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 33    TFD ffff880107=
bb1080   00000000ffd2bc00
[   34.552634] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009210=
018 to 00000000ffd2bc00 TB 1  [1, 33]
[   34.555748] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb1080=
 Unmap 00000000ffd2bc00 TBs 1
[   34.557315] iwlwifi 0000:02:00.0: Sending command REPLY_TX_LINK_QUALITY_=
CMD (#4e), seq: 0x0922, 92 bytes at 34[2]:9
[   34.560360] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 34    TFD ffff880107=
bb1100   00000000ffd2a400
[   34.560406] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009220=
04e to 00000000ffd2a400 TB 1  [2, 34]
[   34.563559] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb1100=
 Unmap 00000000ffd2a400 TBs 1
[   34.565137] iwlwifi 0000:02:00.0: Sending command REPLY_LEDS_CMD (#48), =
seq: 0x0923, 12 bytes at 35[3]:9
[   34.568167] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 35    TFD ffff880107=
bb1180   00000000ffd2b600
[   34.568214] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009230=
048 to 00000000ffd2b600 TB 1  [3, 35]
[   34.570254] iwlwifi 0000:02:00.0: iwl_tx_queue_unmap, UNMAP 35[3]:9
[   34.571775] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb1180=
 Unmap 00000000ffd2b600 TBs 1
[   34.576531] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[   34.586341] iwlwifi 0000:02:00.0: Radio type=3D0x1-0x2-0x0
[   34.654498] iwlwifi 0000:02:00.0: Sending command COEX_PRIORITY_TABLE_CM=
D (#5a), seq: 0x0900, 72 bytes at 0[0]:9
[   34.656041] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 0    TFD ffff880107b=
b0000   00000000fff5cc00
[   34.656075] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009000=
05a to 00000000fff5cc00 TB 1  [0, 0]
[   34.657741] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0000=
 Unmap 00000000fff5cc00 TBs 1
[   34.659295] iwlwifi 0000:02:00.0: Sending command REPLY_PHY_CALIBRATION_=
CMD (#b0), seq: 0x0901, 12 bytes at 1[1]:9
[   34.662341] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 1    TFD ffff880107b=
b0080   00000000ffd99c00
[   34.662375] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009010=
0b0 to 00000000ffd99c00 TB 1  [1, 1]
[   34.663904] iwlwifi 0000:02:00.0: ATTACHED 2 tbs to 1    TFD ffff880107b=
b0080   00000000ffd98b58
[   34.665544] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0080=
 Unmap 00000000ffd99c00 TBs 2
[   34.667100] iwlwifi 0000:02:00.0: Sending command REPLY_PHY_CALIBRATION_=
CMD (#b0), seq: 0x0902, 12 bytes at 2[2]:9
[   34.670124] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 2    TFD ffff880107b=
b0100   00000000ffd93400
[   34.670158] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009020=
0b0 to 00000000ffd93400 TB 1  [2, 2]
[   34.671698] iwlwifi 0000:02:00.0: ATTACHED 2 tbs to 2    TFD ffff880107b=
b0100   00000000ffd92918
[   34.671801] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0100=
 Unmap 00000000ffd93400 TBs 2
[   34.671814] iwlwifi 0000:02:00.0: Sending command REPLY_PHY_CALIBRATION_=
CMD (#b0), seq: 0x0903, 12 bytes at 3[3]:9
[   34.671818] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 3    TFD ffff880107b=
b0180   00000000fff57600
[   34.671820] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009030=
0b0 to 00000000fff57600 TB 1  [3, 3]
[   34.671823] iwlwifi 0000:02:00.0: ATTACHED 2 tbs to 3    TFD ffff880107b=
b0180   00000000fff56d98
[   34.671930] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0180=
 Unmap 00000000fff57600 TBs 2
[   34.671943] iwlwifi 0000:02:00.0: Sending command REPLY_PHY_CALIBRATION_=
CMD (#b0), seq: 0x0904, 520 bytes at 4[4]:9
[   34.671951] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 4    TFD ffff880107b=
b0200   00000000ffd99a00
[   34.671953] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009040=
0b0 to 00000000ffd99a00 TB 1  [4, 4]
[   34.671956] iwlwifi 0000:02:00.0: ATTACHED 2 tbs to 4    TFD ffff880107b=
b0200   00000000ffd98818
[   34.672069] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0200=
 Unmap 00000000ffd99a00 TBs 2
[   34.672083] iwlwifi 0000:02:00.0: Sending command REPLY_PHY_CALIBRATION_=
CMD (#b0), seq: 0x0905, 1352 bytes at 5[5]:9
[   34.672086] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 5    TFD ffff880107b=
b0280   00000000ffd8f800
[   34.672089] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009050=
0b0 to 00000000ffd8f800 TB 1  [5, 5]
[   34.672091] iwlwifi 0000:02:00.0: ATTACHED 2 tbs to 5    TFD ffff880107b=
b0280   00000000ffd8e818
[   34.672217] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0280=
 Unmap 00000000ffd8f800 TBs 2
[   34.672231] iwlwifi 0000:02:00.0: Sending command REPLY_PHY_CALIBRATION_=
CMD (#b0), seq: 0x0906, 92 bytes at 6[6]:9
[   34.672234] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 6    TFD ffff880107b=
b0300   00000000ffd8be00
[   34.672237] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009060=
0b0 to 00000000ffd8be00 TB 1  [6, 6]
[   34.672239] iwlwifi 0000:02:00.0: ATTACHED 2 tbs to 6    TFD ffff880107b=
b0300   00000000ffd8aa18
[   34.672354] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0300=
 Unmap 00000000ffd8be00 TBs 2
[   34.672369] iwlwifi 0000:02:00.0: Sending command REPLY_BT_CONFIG (#9b),=
 seq: 0x0907, 16 bytes at 7[7]:9
[   34.672372] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 7    TFD ffff880107b=
b0380   00000000ffd87200
[   34.672374] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009070=
09b to 00000000ffd87200 TB 1  [7, 7]
[   34.672472] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0380=
 Unmap 00000000ffd87200 TBs 1
[   34.672486] iwlwifi 0000:02:00.0: Sending command CALIBRATION_CFG_CMD (#=
65), seq: 0x0908, 96 bytes at 8[8]:9
[   34.672489] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 8    TFD ffff880107b=
b0400   00000000ffd83e00
[   34.672492] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009080=
065 to 00000000ffd83e00 TB 1  [8, 8]
[   34.672576] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0400=
 Unmap 00000000ffd83e00 TBs 1
[   34.672589] iwlwifi 0000:02:00.0: Sending command TX_ANT_CONFIGURATION_C=
MD (#98), seq: 0x0909, 8 bytes at 9[9]:9
[   34.672592] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 9    TFD ffff880107b=
b0480   00000000ffd7fa00
[   34.672594] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009090=
098 to 00000000ffd7fa00 TB 1  [9, 9]
[   34.699681] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0480=
 Unmap 00000000ffd7fa00 TBs 1
[   34.699698] iwlwifi 0000:02:00.0: Sending command REPLY_STATISTICS_CMD (=
#9c), seq: 0x090A, 8 bytes at 10[10]:9
[   34.699702] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 10    TFD ffff880107=
bb0500   00000000ffd7bc00
[   34.699704] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000090a0=
09c to 00000000ffd7bc00 TB 1  [10, 10]
[   34.699708] iwlwifi 0000:02:00.0: Sending command REPLY_RXON (#10), seq:=
 0x090B, 54 bytes at 11[11]:9
[   34.699711] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 11    TFD ffff880107=
bb0580   00000000ffd7a600
[   34.699713] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000090b0=
010 to 00000000ffd7a600 TB 1  [11, 11]
[   34.699800] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0500=
 Unmap 00000000ffd7bc00 TBs 1
[   34.700813] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0580=
 Unmap 00000000ffd7a600 TBs 1
[   34.700835] iwlwifi 0000:02:00.0: Sending command REPLY_ADD_STA (#18), s=
eq: 0x090C, 96 bytes at 12[12]:9
[   34.700840] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 12    TFD ffff880107=
bb0600   00000000ffd73800
[   34.700843] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000090c0=
018 to 00000000ffd73800 TB 1  [12, 12]
[   34.717542] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0600=
 Unmap 00000000ffd73800 TBs 1
[   34.717557] iwlwifi 0000:02:00.0: Sending command REPLY_TX_LINK_QUALITY_=
CMD (#4e), seq: 0x090D, 92 bytes at 13[13]:9
[   34.717561] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 13    TFD ffff880107=
bb0680   00000000ffd72200
[   34.717563] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000090d0=
04e to 00000000ffd72200 TB 1  [13, 13]
[   34.717684] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0680=
 Unmap 00000000ffd72200 TBs 1
[   34.717699] iwlwifi 0000:02:00.0: Sending command REPLY_CT_KILL_CONFIG_C=
MD (#a4), seq: 0x090E, 16 bytes at 14[14]:9
[   34.717702] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 14    TFD ffff880107=
bb0700   00000000ffd6f400
[   34.717704] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000090e0=
0a4 to 00000000ffd6f400 TB 1  [14, 14]
[   34.717802] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0700=
 Unmap 00000000ffd6f400 TBs 1
[   34.717817] iwlwifi 0000:02:00.0: Sending command POWER_TABLE_CMD (#77),=
 seq: 0x090F, 40 bytes at 15[15]:9
[   34.717820] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 15    TFD ffff880107=
bb0780   00000000ffd5f000
[   34.717823] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000090f0=
077 to 00000000ffd5f000 TB 1  [15, 15]
[   34.717910] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0780=
 Unmap 00000000ffd5f000 TBs 1
[   34.717932] iwlwifi 0000:02:00.0: Sending command REPLY_RXON (#10), seq:=
 0x0910, 54 bytes at 16[16]:9
[   34.717937] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 16    TFD ffff880107=
bb0800   00000000ffd4fe00
[   34.717939] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009100=
010 to 00000000ffd4fe00 TB 1  [16, 16]
[   34.719278] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0800=
 Unmap 00000000ffd4fe00 TBs 1
[   34.719299] iwlwifi 0000:02:00.0: Sending command REPLY_ADD_STA (#18), s=
eq: 0x0911, 96 bytes at 17[17]:9
[   34.719304] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 17    TFD ffff880107=
bb0880   00000000ffd2da00
[   34.719306] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009110=
018 to 00000000ffd2da00 TB 1  [17, 17]
[   34.719408] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0880=
 Unmap 00000000ffd2da00 TBs 1
[   34.719421] iwlwifi 0000:02:00.0: Sending command REPLY_TX_LINK_QUALITY_=
CMD (#4e), seq: 0x0912, 92 bytes at 18[18]:9
[   34.719425] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 18    TFD ffff880107=
bb0900   00000000ffd2cc00
[   34.719427] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009120=
04e to 00000000ffd2cc00 TB 1  [18, 18]
[   34.720645] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0900=
 Unmap 00000000ffd2cc00 TBs 1
[   34.720669] iwlwifi 0000:02:00.0: Sending command REPLY_RXON (#10), seq:=
 0x0913, 54 bytes at 19[19]:9
[   34.720674] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 19    TFD ffff880107=
bb0980   00000000ffbf7800
[   34.720677] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009130=
010 to 00000000ffbf7800 TB 1  [19, 19]
[   34.722009] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0980=
 Unmap 00000000ffbf7800 TBs 1
[   34.722026] iwlwifi 0000:02:00.0: Sending command REPLY_ADD_STA (#18), s=
eq: 0x0914, 96 bytes at 20[20]:9
[   34.722030] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 20    TFD ffff880107=
bb0a00   00000000ffbf1600
[   34.722032] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009140=
018 to 00000000ffbf1600 TB 1  [20, 20]
[   34.722152] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0a00=
 Unmap 00000000ffbf1600 TBs 1
[   34.722165] iwlwifi 0000:02:00.0: Sending command REPLY_TX_LINK_QUALITY_=
CMD (#4e), seq: 0x0915, 92 bytes at 21[21]:9
[   34.722170] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 21    TFD ffff880107=
bb0a80   00000000ffbf0400
[   34.722172] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009150=
04e to 00000000ffbf0400 TB 1  [21, 21]
[   34.723404] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0a80=
 Unmap 00000000ffbf0400 TBs 1
[   34.723422] iwlwifi 0000:02:00.0: Sending command REPLY_QOS_PARAM (#13),=
 seq: 0x0916, 40 bytes at 22[22]:9
[   34.723428] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 22    TFD ffff880107=
bb0b00   00000000fff53000
[   34.723431] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009160=
013 to 00000000fff53000 TB 1  [22, 22]
[   34.724633] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0b00=
 Unmap 00000000fff53000 TBs 1
[   34.724950] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   35.004086] iwlwifi 0000:02:00.0: Sending command REPLY_RXON (#10), seq:=
 0x0917, 54 bytes at 23[23]:9
[   35.005614] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 23    TFD ffff880107=
bb0b80   00000000fff53800
[   35.005663] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009170=
010 to 00000000fff53800 TB 1  [23, 23]
[   35.008885] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0b80=
 Unmap 00000000fff53800 TBs 1
[   35.010443] iwlwifi 0000:02:00.0: Sending command REPLY_ADD_STA (#18), s=
eq: 0x0918, 96 bytes at 24[24]:9
[   35.014453] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 24    TFD ffff880107=
bb0c00   00000000fff4b600
[   35.014504] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009180=
018 to 00000000fff4b600 TB 1  [24, 24]
[   35.017960] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0c00=
 Unmap 00000000fff4b600 TBs 1
[   35.019501] iwlwifi 0000:02:00.0: Sending command REPLY_TX_LINK_QUALITY_=
CMD (#4e), seq: 0x0919, 92 bytes at 25[25]:9
[   35.022481] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 25    TFD ffff880107=
bb0c80   00000000fff53400
[   35.022515] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009190=
04e to 00000000fff53400 TB 1  [25, 25]
[   35.025613] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0c80=
 Unmap 00000000fff53400 TBs 1
[   35.027189] iwlwifi 0000:02:00.0: Sending command REPLY_LEDS_CMD (#48), =
seq: 0x091A, 12 bytes at 26[26]:9
[   35.030255] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 26    TFD ffff880107=
bb0d00   00000000fff47a00
[   35.030289] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000091a0=
048 to 00000000fff47a00 TB 1  [26, 26]
[   35.032299] iwlwifi 0000:02:00.0: iwl_tx_queue_unmap, UNMAP 26[26]:9
[   35.033816] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0d00=
 Unmap 00000000fff47a00 TBs 1
[   35.040942] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[   35.050746] iwlwifi 0000:02:00.0: Radio type=3D0x1-0x2-0x0
[   35.118899] iwlwifi 0000:02:00.0: Sending command COEX_PRIORITY_TABLE_CM=
D (#5a), seq: 0x0900, 72 bytes at 0[0]:9
[   35.120437] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 0    TFD ffff880107b=
b0000   00000000fff5cc00
[   35.120471] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009000=
05a to 00000000fff5cc00 TB 1  [0, 0]
[   35.122093] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0000=
 Unmap 00000000fff5cc00 TBs 1
[   35.123633] iwlwifi 0000:02:00.0: Sending command REPLY_PHY_CALIBRATION_=
CMD (#b0), seq: 0x0901, 12 bytes at 1[1]:9
[   35.126679] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 1    TFD ffff880107b=
b0080   00000000ffd21c00
[   35.126714] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009010=
0b0 to 00000000ffd21c00 TB 1  [1, 1]
[   35.128243] iwlwifi 0000:02:00.0: ATTACHED 2 tbs to 1    TFD ffff880107b=
b0080   00000000ffd20d58
[   35.129880] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0080=
 Unmap 00000000ffd21c00 TBs 2
[   35.131443] iwlwifi 0000:02:00.0: Sending command REPLY_PHY_CALIBRATION_=
CMD (#b0), seq: 0x0902, 12 bytes at 2[2]:9
[   35.134484] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 2    TFD ffff880107b=
b0100   00000000ffd1b400
[   35.134517] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009020=
0b0 to 00000000ffd1b400 TB 1  [2, 2]
[   35.136069] iwlwifi 0000:02:00.0: ATTACHED 2 tbs to 2    TFD ffff880107b=
b0100   00000000ffd1a918
[   35.136190] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0100=
 Unmap 00000000ffd1b400 TBs 2
[   35.136204] iwlwifi 0000:02:00.0: Sending command REPLY_PHY_CALIBRATION_=
CMD (#b0), seq: 0x0903, 12 bytes at 3[3]:9
[   35.136207] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 3    TFD ffff880107b=
b0180   00000000fff57600
[   35.136210] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009030=
0b0 to 00000000fff57600 TB 1  [3, 3]
[   35.136212] iwlwifi 0000:02:00.0: ATTACHED 2 tbs to 3    TFD ffff880107b=
b0180   00000000fff56d98
[   35.136320] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0180=
 Unmap 00000000fff57600 TBs 2
[   35.136334] iwlwifi 0000:02:00.0: Sending command REPLY_PHY_CALIBRATION_=
CMD (#b0), seq: 0x0904, 520 bytes at 4[4]:9
[   35.136342] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 4    TFD ffff880107b=
b0200   00000000ffd21a00
[   35.136344] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009040=
0b0 to 00000000ffd21a00 TB 1  [4, 4]
[   35.136347] iwlwifi 0000:02:00.0: ATTACHED 2 tbs to 4    TFD ffff880107b=
b0200   00000000ffd20818
[   35.136459] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0200=
 Unmap 00000000ffd21a00 TBs 2
[   35.136472] iwlwifi 0000:02:00.0: Sending command REPLY_PHY_CALIBRATION_=
CMD (#b0), seq: 0x0905, 1352 bytes at 5[5]:9
[   35.136476] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 5    TFD ffff880107b=
b0280   00000000ffd17800
[   35.136478] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009050=
0b0 to 00000000ffd17800 TB 1  [5, 5]
[   35.136481] iwlwifi 0000:02:00.0: ATTACHED 2 tbs to 5    TFD ffff880107b=
b0280   00000000ffd16818
[   35.136607] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0280=
 Unmap 00000000ffd17800 TBs 2
[   35.136621] iwlwifi 0000:02:00.0: Sending command REPLY_PHY_CALIBRATION_=
CMD (#b0), seq: 0x0906, 92 bytes at 6[6]:9
[   35.136625] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 6    TFD ffff880107b=
b0300   00000000ffd13e00
[   35.136627] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009060=
0b0 to 00000000ffd13e00 TB 1  [6, 6]
[   35.136629] iwlwifi 0000:02:00.0: ATTACHED 2 tbs to 6    TFD ffff880107b=
b0300   00000000ffd12a18
[   35.136744] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0300=
 Unmap 00000000ffd13e00 TBs 2
[   35.136759] iwlwifi 0000:02:00.0: Sending command REPLY_BT_CONFIG (#9b),=
 seq: 0x0907, 16 bytes at 7[7]:9
[   35.136762] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 7    TFD ffff880107b=
b0380   00000000ffd0f200
[   35.136764] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009070=
09b to 00000000ffd0f200 TB 1  [7, 7]
[   35.136854] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0380=
 Unmap 00000000ffd0f200 TBs 1
[   35.136868] iwlwifi 0000:02:00.0: Sending command CALIBRATION_CFG_CMD (#=
65), seq: 0x0908, 96 bytes at 8[8]:9
[   35.136871] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 8    TFD ffff880107b=
b0400   00000000ffd0be00
[   35.136873] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009080=
065 to 00000000ffd0be00 TB 1  [8, 8]
[   35.136958] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0400=
 Unmap 00000000ffd0be00 TBs 1
[   35.136971] iwlwifi 0000:02:00.0: Sending command TX_ANT_CONFIGURATION_C=
MD (#98), seq: 0x0909, 8 bytes at 9[9]:9
[   35.136974] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 9    TFD ffff880107b=
b0480   00000000ffd07a00
[   35.136976] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009090=
098 to 00000000ffd07a00 TB 1  [9, 9]
[   35.164062] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0480=
 Unmap 00000000ffd07a00 TBs 1
[   35.164079] iwlwifi 0000:02:00.0: Sending command REPLY_STATISTICS_CMD (=
#9c), seq: 0x090A, 8 bytes at 10[10]:9
[   35.164082] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 10    TFD ffff880107=
bb0500   00000000ffd03c00
[   35.164085] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000090a0=
09c to 00000000ffd03c00 TB 1  [10, 10]
[   35.164089] iwlwifi 0000:02:00.0: Sending command REPLY_RXON (#10), seq:=
 0x090B, 54 bytes at 11[11]:9
[   35.164092] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 11    TFD ffff880107=
bb0580   00000000ffd02600
[   35.164094] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000090b0=
010 to 00000000ffd02600 TB 1  [11, 11]
[   35.164180] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0500=
 Unmap 00000000ffd03c00 TBs 1
[   35.165194] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0580=
 Unmap 00000000ffd02600 TBs 1
[   35.165216] iwlwifi 0000:02:00.0: Sending command REPLY_ADD_STA (#18), s=
eq: 0x090C, 96 bytes at 12[12]:9
[   35.165221] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 12    TFD ffff880107=
bb0600   00000000ffcfb800
[   35.165224] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000090c0=
018 to 00000000ffcfb800 TB 1  [12, 12]
[   35.181908] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0600=
 Unmap 00000000ffcfb800 TBs 1
[   35.181923] iwlwifi 0000:02:00.0: Sending command REPLY_TX_LINK_QUALITY_=
CMD (#4e), seq: 0x090D, 92 bytes at 13[13]:9
[   35.181928] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 13    TFD ffff880107=
bb0680   00000000ffcfa200
[   35.181930] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000090d0=
04e to 00000000ffcfa200 TB 1  [13, 13]
[   35.182050] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0680=
 Unmap 00000000ffcfa200 TBs 1
[   35.182065] iwlwifi 0000:02:00.0: Sending command REPLY_CT_KILL_CONFIG_C=
MD (#a4), seq: 0x090E, 16 bytes at 14[14]:9
[   35.182069] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 14    TFD ffff880107=
bb0700   00000000ffcf7400
[   35.182071] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000090e0=
0a4 to 00000000ffcf7400 TB 1  [14, 14]
[   35.182171] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0700=
 Unmap 00000000ffcf7400 TBs 1
[   35.182186] iwlwifi 0000:02:00.0: Sending command POWER_TABLE_CMD (#77),=
 seq: 0x090F, 40 bytes at 15[15]:9
[   35.182189] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 15    TFD ffff880107=
bb0780   00000000ffcf3000
[   35.182191] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000090f0=
077 to 00000000ffcf3000 TB 1  [15, 15]
[   35.182282] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0780=
 Unmap 00000000ffcf3000 TBs 1
[   35.182304] iwlwifi 0000:02:00.0: Sending command REPLY_RXON (#10), seq:=
 0x0910, 54 bytes at 16[16]:9
[   35.182310] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 16    TFD ffff880107=
bb0800   00000000ffcefe00
[   35.182312] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009100=
010 to 00000000ffcefe00 TB 1  [16, 16]
[   35.183641] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0800=
 Unmap 00000000ffcefe00 TBs 1
[   35.183662] iwlwifi 0000:02:00.0: Sending command REPLY_ADD_STA (#18), s=
eq: 0x0911, 96 bytes at 17[17]:9
[   35.183666] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 17    TFD ffff880107=
bb0880   00000000ffce9a00
[   35.183669] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009110=
018 to 00000000ffce9a00 TB 1  [17, 17]
[   35.183772] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0880=
 Unmap 00000000ffce9a00 TBs 1
[   35.183785] iwlwifi 0000:02:00.0: Sending command REPLY_TX_LINK_QUALITY_=
CMD (#4e), seq: 0x0912, 92 bytes at 18[18]:9
[   35.183789] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 18    TFD ffff880107=
bb0900   00000000ffce8c00
[   35.183791] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009120=
04e to 00000000ffce8c00 TB 1  [18, 18]
[   35.185001] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0900=
 Unmap 00000000ffce8c00 TBs 1
[   35.185020] iwlwifi 0000:02:00.0: Sending command REPLY_RXON (#10), seq:=
 0x0913, 54 bytes at 19[19]:9
[   35.185025] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 19    TFD ffff880107=
bb0980   00000000ffce5800
[   35.185028] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009130=
010 to 00000000ffce5800 TB 1  [19, 19]
[   35.186364] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0980=
 Unmap 00000000ffce5800 TBs 1
[   35.186381] iwlwifi 0000:02:00.0: Sending command REPLY_ADD_STA (#18), s=
eq: 0x0914, 96 bytes at 20[20]:9
[   35.186384] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 20    TFD ffff880107=
bb0a00   00000000ffcdf600
[   35.186387] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009140=
018 to 00000000ffcdf600 TB 1  [20, 20]
[   35.186506] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0a00=
 Unmap 00000000ffcdf600 TBs 1
[   35.186520] iwlwifi 0000:02:00.0: Sending command REPLY_TX_LINK_QUALITY_=
CMD (#4e), seq: 0x0915, 92 bytes at 21[21]:9
[   35.186524] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 21    TFD ffff880107=
bb0a80   00000000ffcde400
[   35.186526] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009150=
04e to 00000000ffcde400 TB 1  [21, 21]
[   35.187947] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0a80=
 Unmap 00000000ffcde400 TBs 1
[   35.187965] iwlwifi 0000:02:00.0: Sending command REPLY_QOS_PARAM (#13),=
 seq: 0x0916, 40 bytes at 22[22]:9
[   35.187970] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 22    TFD ffff880107=
bb0b00   00000000fff53000
[   35.187973] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009160=
013 to 00000000fff53000 TB 1  [22, 22]
[   35.189172] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0b00=
 Unmap 00000000fff53000 TBs 1
[   35.189489] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   37.251732] iwlwifi 0000:02:00.0: Sending command REPLY_SCAN_CMD (#80), =
seq: 0x0917, 994 bytes at 23[23]:9
[   37.253255] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 23    TFD ffff880107=
bb0b80   00000000fff53800
[   37.253303] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009170=
080 to 00000000fff53800 TB 1  [23, 23]
[   37.254857] iwlwifi 0000:02:00.0: ATTACHED 2 tbs to 23    TFD ffff880107=
bb0b80   00000000fff52000
[   37.257662] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0b80=
 Unmap 00000000fff53800 TBs 2
[   37.852742] iwlwifi 0000:02:00.0: Sending command REPLY_RXON (#10), seq:=
 0x0918, 54 bytes at 24[24]:9
[   37.856778] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 24    TFD ffff880107=
bb0c00   00000000ffed7600
[   37.856829] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009180=
010 to 00000000ffed7600 TB 1  [24, 24]
[   37.860516] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0c00=
 Unmap 00000000ffed7600 TBs 1
[   37.862083] iwlwifi 0000:02:00.0: Sending command REPLY_ADD_STA (#18), s=
eq: 0x0919, 96 bytes at 25[25]:9
[   37.865107] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 25    TFD ffff880107=
bb0c80   00000000ffed7400
[   37.865144] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009190=
018 to 00000000ffed7400 TB 1  [25, 25]
[   37.868230] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0c80=
 Unmap 00000000ffed7400 TBs 1
[   37.869790] iwlwifi 0000:02:00.0: Sending command REPLY_TX_LINK_QUALITY_=
CMD (#4e), seq: 0x091A, 92 bytes at 26[26]:9
[   37.872827] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 26    TFD ffff880107=
bb0d00   00000000ffed6a00
[   37.872861] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000091a0=
04e to 00000000ffed6a00 TB 1  [26, 26]
[   37.875955] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0d00=
 Unmap 00000000ffed6a00 TBs 1
[   37.877540] iwlwifi 0000:02:00.0: Sending command REPLY_SCAN_CMD (#80), =
seq: 0x091B, 1120 bytes at 27[27]:9
[   37.880579] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 27    TFD ffff880107=
bb0d80   00000000ffed7e00
[   37.880630] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000091b0=
080 to 00000000ffed7e00 TB 1  [27, 27]
[   37.882707] iwlwifi 0000:02:00.0: ATTACHED 2 tbs to 27    TFD ffff880107=
bb0d80   00000000ffed6000
[   37.887357] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0d80=
 Unmap 00000000ffed7e00 TBs 2
[   40.614341] iwlwifi 0000:02:00.0: Sending command REPLY_SCAN_CMD (#80), =
seq: 0x091C, 836 bytes at 28[28]:9
[   40.618463] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 28    TFD ffff880107=
bb0e00   00000000ffe3bc00
[   40.618514] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000091c0=
080 to 00000000ffe3bc00 TB 1  [28, 28]
[   40.620606] iwlwifi 0000:02:00.0: ATTACHED 2 tbs to 28    TFD ffff880107=
bb0e00   00000000ffe3a000
[   40.625388] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0e00=
 Unmap 00000000ffe3bc00 TBs 2
[   40.627180] wlan0: authenticate with 00:1e:2a:f6:f1:4a
[   40.628757] iwlwifi 0000:02:00.0: Sending command REPLY_RXON (#10), seq:=
 0x091D, 54 bytes at 29[29]:9
[   40.630303] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 29    TFD ffff880107=
bb0e80   00000000ffe31e00
[   40.630339] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000091d0=
010 to 00000000ffe31e00 TB 1  [29, 29]
[   40.633050] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0e80=
 Unmap 00000000ffe31e00 TBs 1
[   40.634638] iwlwifi 0000:02:00.0: Sending command REPLY_ADD_STA (#18), s=
eq: 0x091E, 96 bytes at 30[30]:9
[   40.637715] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 30    TFD ffff880107=
bb0f00   00000000ffe3bc00
[   40.637718] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000091e0=
018 to 00000000ffe3bc00 TB 1  [30, 30]
[   40.639336] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0f00=
 Unmap 00000000ffe3bc00 TBs 1
[   40.639350] iwlwifi 0000:02:00.0: Sending command REPLY_TX_LINK_QUALITY_=
CMD (#4e), seq: 0x091F, 92 bytes at 31[31]:9
[   40.639354] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 31    TFD ffff880107=
bb0f80   00000000ffe3aa00
[   40.639357] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000091f0=
04e to 00000000ffe3aa00 TB 1  [31, 31]
[   40.640916] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb0f80=
 Unmap 00000000ffe3aa00 TBs 1
[   40.640935] iwlwifi 0000:02:00.0: Sending command REPLY_RXON (#10), seq:=
 0x0920, 54 bytes at 32[0]:9
[   40.640939] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 32    TFD ffff880107=
bb1000   00000000ffe25c00
[   40.640943] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009200=
010 to 00000000ffe25c00 TB 1  [0, 32]
[   40.647118] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb1000=
 Unmap 00000000ffe25c00 TBs 1
[   40.647128] iwlwifi 0000:02:00.0: Sending command REPLY_ADD_STA (#18), s=
eq: 0x0921, 96 bytes at 33[1]:9
[   40.647132] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 33    TFD ffff880107=
bb1080   00000000ffe1fc00
[   40.647137] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009210=
018 to 00000000ffe1fc00 TB 1  [1, 33]
[   40.656371] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb1080=
 Unmap 00000000ffe1fc00 TBs 1
[   40.656380] iwlwifi 0000:02:00.0: Sending command REPLY_TX_LINK_QUALITY_=
CMD (#4e), seq: 0x0922, 92 bytes at 34[2]:9
[   40.656384] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 34    TFD ffff880107=
bb1100   00000000ffe3b400
[   40.656387] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009220=
04e to 00000000ffe3b400 TB 1  [2, 34]
[   40.659515] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb1100=
 Unmap 00000000ffe3b400 TBs 1
[   40.659530] iwlwifi 0000:02:00.0: Sending command REPLY_ADD_STA (#18), s=
eq: 0x0923, 96 bytes at 35[3]:9
[   40.659534] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 35    TFD ffff880107=
bb1180   00000000ffe1e600
[   40.659537] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009230=
018 to 00000000ffe1e600 TB 1  [3, 35]
[   40.665698] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb1180=
 Unmap 00000000ffe1e600 TBs 1
[   40.665718] wlan0: send auth to 00:1e:2a:f6:f1:4a (try 1/3)
[   40.665732] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 0    TFD ffff880107b=
48000   00000000ffe3b000
[   40.665735] iwlwifi 0000:02:00.0: ATTACHED 2 tbs to 0    TFD ffff880107b=
48000   00000000ffe3aa58
[   40.671933] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b48000=
 Unmap 00000000ffe3b000 TBs 2
[   40.671973] wlan0: authenticated
[   40.676475] wlan0: associate with 00:1e:2a:f6:f1:4a (try 1/3)
[   40.676487] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 1    TFD ffff880107b=
48080   00000000ffe3b148
[   40.676489] iwlwifi 0000:02:00.0: ATTACHED 2 tbs to 1    TFD ffff880107b=
48080   00000000ffe3ac26
[   40.679481] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b48080=
 Unmap 00000000ffe3b148 TBs 2
[   40.679524] wlan0: RX AssocResp from 00:1e:2a:f6:f1:4a (capab=3D0x431 st=
atus=3D0 aid=3D3)
[   40.679526] wlan0: associated
[   40.679531] iwlwifi 0000:02:00.0: Sending command REPLY_ADD_STA (#18), s=
eq: 0x0924, 96 bytes at 36[4]:9
[   40.679536] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 36    TFD ffff880107=
bb1200   00000000ffe17a00
[   40.679542] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009240=
018 to 00000000ffe17a00 TB 1  [4, 36]
[   40.680984] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb1200=
 Unmap 00000000ffe17a00 TBs 1
[   40.681002] iwlwifi 0000:02:00.0: Sending command REPLY_TX_LINK_QUALITY_=
CMD (#4e), seq: 0x0925, 92 bytes at 37[5]:9
[   40.681007] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 37    TFD ffff880107=
bb1280   00000000ffe16800
[   40.681010] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009250=
04e to 00000000ffe16800 TB 1  [5, 37]
[   40.686863] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb1280=
 Unmap 00000000ffe16800 TBs 1
[   40.686878] iwlwifi 0000:02:00.0: Sending command REPLY_QOS_PARAM (#13),=
 seq: 0x0926, 40 bytes at 38[6]:9
[   40.686884] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 38    TFD ffff880107=
bb1300   00000000ffe13e00
[   40.686886] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009260=
013 to 00000000ffe13e00 TB 1  [6, 38]
[   40.692744] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb1300=
 Unmap 00000000ffe13e00 TBs 1
[   40.692758] iwlwifi 0000:02:00.0: Sending command REPLY_RXON (#10), seq:=
 0x0927, 54 bytes at 39[7]:9
[   40.692764] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 39    TFD ffff880107=
bb1380   00000000ffe17200
[   40.692767] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009270=
010 to 00000000ffe17200 TB 1  [7, 39]
[   40.698595] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb1380=
 Unmap 00000000ffe17200 TBs 1
[   40.698610] iwlwifi 0000:02:00.0: Sending command REPLY_ADD_STA (#18), s=
eq: 0x0928, 96 bytes at 40[8]:9
[   40.698616] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 40    TFD ffff880107=
bb1400   00000000ffe0de00
[   40.698620] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009280=
018 to 00000000ffe0de00 TB 1  [8, 40]
[   40.704427] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb1400=
 Unmap 00000000ffe0de00 TBs 1
[   40.704441] iwlwifi 0000:02:00.0: Sending command REPLY_TX_LINK_QUALITY_=
CMD (#4e), seq: 0x0929, 92 bytes at 41[9]:9
[   40.704446] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 41    TFD ffff880107=
bb1480   00000000ffe17a00
[   40.704448] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009290=
04e to 00000000ffe17a00 TB 1  [9, 41]
[   40.710186] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb1480=
 Unmap 00000000ffe17a00 TBs 1
[   40.710199] iwlwifi 0000:02:00.0: Sending command REPLY_ADD_STA (#18), s=
eq: 0x092A, 96 bytes at 42[10]:9
[   40.710204] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 42    TFD ffff880107=
bb1500   00000000ffe0cc00
[   40.710206] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000092a0=
018 to 00000000ffe0cc00 TB 1  [10, 42]
[   40.715939] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb1500=
 Unmap 00000000ffe0cc00 TBs 1
[   40.715952] iwlwifi 0000:02:00.0: Sending command REPLY_TX_LINK_QUALITY_=
CMD (#4e), seq: 0x092B, 92 bytes at 43[11]:9
[   40.715957] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 43    TFD ffff880107=
bb1580   00000000ffe17600
[   40.715960] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000092b0=
04e to 00000000ffe17600 TB 1  [11, 43]
[   40.721685] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb1580=
 Unmap 00000000ffe17600 TBs 1
[   40.721699] iwlwifi 0000:02:00.0: Sending command REPLY_RXON_TIMING (#14=
), seq: 0x092C, 24 bytes at 44[12]:9
[   40.721704] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 44    TFD ffff880107=
bb1600   00000000ffe09800
[   40.721706] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000092c0=
014 to 00000000ffe09800 TB 1  [12, 44]
[   40.727438] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb1600=
 Unmap 00000000ffe09800 TBs 1
[   40.727451] iwlwifi 0000:02:00.0: Sending command REPLY_QOS_PARAM (#13),=
 seq: 0x092D, 40 bytes at 45[13]:9
[   40.727456] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 45    TFD ffff880107=
bb1680   00000000ffe0d200
[   40.727459] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000092d0=
013 to 00000000ffe0d200 TB 1  [13, 45]
[   40.733195] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb1680=
 Unmap 00000000ffe0d200 TBs 1
[   40.733208] iwlwifi 0000:02:00.0: Sending command REPLY_RXON (#10), seq:=
 0x092E, 54 bytes at 46[14]:9
[   40.733213] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 46    TFD ffff880107=
bb1700   00000000ffe05400
[   40.733215] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000092e0=
010 to 00000000ffe05400 TB 1  [14, 46]
[   40.738973] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb1700=
 Unmap 00000000ffe05400 TBs 1
[   40.738986] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x092F, 52 bytes at 47[15]:9
[   40.738991] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 47    TFD ffff880107=
bb1780   00000000ffe04000
[   40.738994] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000092f0=
0a8 to 00000000ffe04000 TB 1  [15, 47]
[   40.738998] iwlwifi 0000:02:00.0: Sending command REPLY_TX_POWER_DBM_CMD=
 (#95), seq: 0x0930, 8 bytes at 48[16]:9
[   40.739001] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 48    TFD ffff880107=
bb1800   00000000ffe03e00
[   40.739003] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009300=
095 to 00000000ffe03e00 TB 1  [16, 48]
[   40.744735] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb1780=
 Unmap 00000000ffe04000 TBs 1
[   40.744739] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb1800=
 Unmap 00000000ffe03e00 TBs 1
[   40.745007] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   40.843572] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0931, 52 bytes at 49[17]:9
[   40.845069] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 49    TFD ffff880107=
bb1880   00000000ffdf9a00
[   40.845103] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009310=
0a8 to 00000000ffdf9a00 TB 1  [17, 49]
[   40.848158] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb1880=
 Unmap 00000000ffdf9a00 TBs 1
[   40.945826] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0932, 52 bytes at 50[18]:9
[   40.948787] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 50    TFD ffff880107=
bb1900   00000000ffdf3c00
[   40.948822] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009320=
0a8 to 00000000ffdf3c00 TB 1  [18, 50]
[   40.951884] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb1900=
 Unmap 00000000ffdf3c00 TBs 1
[   41.752316] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 2    TFD ffff880107b=
48100   00000000ffdd3290
[   41.757231] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b48100=
 Unmap 00000000ffdd3290 TBs 1
[   41.759816] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 0    TFD ffff880107b=
60000   00000000ffdcd148
[   41.761307] iwlwifi 0000:02:00.0: ATTACHED 2 tbs to 0    TFD ffff880107b=
60000   00000000ffdccc48
[   41.772632] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b60000=
 Unmap 00000000ffdcd148 TBs 2
[   42.684762] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0933, 52 bytes at 51[19]:9
[   42.687696] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 51    TFD ffff880107=
bb1980   00000000ffda3800
[   42.687730] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009330=
0a8 to 00000000ffda3800 TB 1  [19, 51]
[   42.689320] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 1    TFD ffff880107b=
60080   00000000ffd9d000
[   42.689584] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb1980=
 Unmap 00000000ffda3800 TBs 1
[   42.692296] iwlwifi 0000:02:00.0: ATTACHED 2 tbs to 1    TFD ffff880107b=
60080   00000000ffd9cc48
[   42.698788] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b60080=
 Unmap 00000000ffd9d000 TBs 2
[   42.706978] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 2    TFD ffff880107b=
60100   00000000ffd97000
[   42.708475] iwlwifi 0000:02:00.0: ATTACHED 2 tbs to 2    TFD ffff880107b=
60100   00000000ffd96c48
[   42.710058] iwlwifi 0000:02:00.0: Sending command REPLY_ADD_STA (#18), s=
eq: 0x0934, 96 bytes at 52[20]:9
[   42.712976] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 52    TFD ffff880107=
bb1a00   00000000ffd9d600
[   42.713030] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009340=
018 to 00000000ffd9d600 TB 1  [20, 52]
[   42.714690] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b60100=
 Unmap 00000000ffd97000 TBs 2
[   42.716192] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb1a00=
 Unmap 00000000ffd9d600 TBs 1
[   42.717710] iwlwifi 0000:02:00.0: Sending command REPLY_ADD_STA (#18), s=
eq: 0x0935, 96 bytes at 53[21]:9
[   42.720589] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 53    TFD ffff880107=
bb1a80   00000000ffd93400
[   42.720624] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009350=
018 to 00000000ffd93400 TB 1  [21, 53]
[   42.722180] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb1a80=
 Unmap 00000000ffd93400 TBs 1
[   42.737009] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 3    TFD ffff880107b=
60180   00000000ffd9d3d8
[   42.738487] iwlwifi 0000:02:00.0: ATTACHED 2 tbs to 3    TFD ffff880107b=
60180   00000000ffd9c440
[   42.746562] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b60180=
 Unmap 00000000ffd9d3d8 TBs 2
[   42.760979] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 3    TFD ffff880107b=
48180   00000000ffd9d000
[   42.765871] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b48180=
 Unmap 00000000ffd9d000 TBs 1
[   42.786622] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0936, 52 bytes at 54[22]:9
[   42.789503] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 54    TFD ffff880107=
bb1b00   00000000ffd8f000
[   42.789538] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009360=
0a8 to 00000000ffd8f000 TB 1  [22, 54]
[   42.792496] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb1b00=
 Unmap 00000000ffd8f000 TBs 1
[   42.888894] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0937, 52 bytes at 55[23]:9
[   42.891775] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 55    TFD ffff880107=
bb1b80   00000000ffd85800
[   42.891809] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009370=
0a8 to 00000000ffd85800 TB 1  [23, 55]
[   42.894775] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb1b80=
 Unmap 00000000ffd85800 TBs 1
[   43.392182] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 4    TFD ffff880107b=
60200   00000000ffd6f148
[   43.393641] iwlwifi 0000:02:00.0: ATTACHED 2 tbs to 4    TFD ffff880107b=
60200   00000000ffd6e840
[   43.410621] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b60200=
 Unmap 00000000ffd6f148 TBs 2
[   43.412101] iwlwifi 0000:02:00.0: Sending command REPLY_TX_LINK_QUALITY_=
CMD (#4e), seq: 0x0938, 92 bytes at 56[24]:9
[   43.414921] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 56    TFD ffff880107=
bb1c00   00000000ffd6b600
[   43.414955] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009380=
04e to 00000000ffd6b600 TB 1  [24, 56]
[   43.416577] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb1c00=
 Unmap 00000000ffd6b600 TBs 1
[   43.431333] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 5    TFD ffff880107b=
60280   00000000ffd6b000
[   43.432796] iwlwifi 0000:02:00.0: ATTACHED 2 tbs to 5    TFD ffff880107b=
60280   00000000ffd6a640
[   43.436110] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b60280=
 Unmap 00000000ffd6b000 TBs 2
[   43.502507] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0939, 52 bytes at 57[25]:9
[   43.505339] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 57    TFD ffff880107=
bb1c80   00000000ffd63400
[   43.505373] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009390=
0a8 to 00000000ffd63400 TB 1  [25, 57]
[   43.508319] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb1c80=
 Unmap 00000000ffd63400 TBs 1
[   43.707031] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x093A, 52 bytes at 58[26]:9
[   43.709844] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 58    TFD ffff880107=
bb1d00   00000000ffd59a00
[   43.709879] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000093a0=
0a8 to 00000000ffd59a00 TB 1  [26, 58]
[   43.712817] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb1d00=
 Unmap 00000000ffd59a00 TBs 1
[   43.759704] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 4    TFD ffff880107b=
48200   00000000ffd59290
[   43.766421] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b48200=
 Unmap 00000000ffd59290 TBs 1
[   43.809325] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x093B, 52 bytes at 59[27]:9
[   43.812133] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 59    TFD ffff880107=
bb1d80   00000000ffd4fe00
[   43.812167] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000093b0=
0a8 to 00000000ffd4fe00 TB 1  [27, 59]
[   43.815121] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb1d80=
 Unmap 00000000ffd4fe00 TBs 1
[   43.911590] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x093C, 52 bytes at 60[28]:9
[   43.914436] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 60    TFD ffff880107=
bb1e00   00000000ffd47c00
[   43.914470] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000093c0=
0a8 to 00000000ffd47c00 TB 1  [28, 60]
[   43.917426] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb1e00=
 Unmap 00000000ffd47c00 TBs 1
[   44.013872] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x093D, 52 bytes at 61[29]:9
[   44.016768] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 61    TFD ffff880107=
bb1e80   00000000ffd3fe00
[   44.016803] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000093d0=
0a8 to 00000000ffd3fe00 TB 1  [29, 61]
[   44.019767] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb1e80=
 Unmap 00000000ffd3fe00 TBs 1
[   44.525189] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x093E, 52 bytes at 62[30]:9
[   44.528061] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 62    TFD ffff880107=
bb1f00   00000000ffd2dc00
[   44.528095] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000093e0=
0a8 to 00000000ffd2dc00 TB 1  [30, 62]
[   44.531069] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb1f00=
 Unmap 00000000ffd2dc00 TBs 1
[   44.758420] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 5    TFD ffff880107b=
48280   00000000ffd213d8
[   44.764658] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b48280=
 Unmap 00000000ffd213d8 TBs 1
[   44.803568] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 6    TFD ffff880107b=
60300   00000000ffd21000
[   44.805052] iwlwifi 0000:02:00.0: ATTACHED 2 tbs to 6    TFD ffff880107b=
60300   00000000ffd20640
[   44.811677] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b60300=
 Unmap 00000000ffd21000 TBs 2
[   44.934271] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x093F, 52 bytes at 63[31]:9
[   44.937158] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 63    TFD ffff880107=
bb1f80   00000000ffd11a00
[   44.937192] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000093f0=
0a8 to 00000000ffd11a00 TB 1  [31, 63]
[   44.940174] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb1f80=
 Unmap 00000000ffd11a00 TBs 1
[   45.036509] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0940, 52 bytes at 64[0]:9
[   45.039473] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 64    TFD ffff880107=
bb2000   00000000ffd11c00
[   45.039508] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009400=
0a8 to 00000000ffd11c00 TB 1  [0, 64]
[   45.042529] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb2000=
 Unmap 00000000ffd11c00 TBs 1
[   45.343321] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0941, 52 bytes at 65[1]:9
[   45.346241] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 65    TFD ffff880107=
bb2080   00000000fff45c00
[   45.346275] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009410=
0a8 to 00000000fff45c00 TB 1  [1, 65]
[   45.349279] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb2080=
 Unmap 00000000fff45c00 TBs 1
[   45.757118] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 6    TFD ffff880107b=
48300   00000000fff33520
[   45.761977] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b48300=
 Unmap 00000000fff33520 TBs 1
[   45.850374] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 7    TFD ffff880107b=
60380   00000000fff33000
[   45.851864] iwlwifi 0000:02:00.0: ATTACHED 2 tbs to 7    TFD ffff880107b=
60380   00000000fff32640
[   45.857451] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b60380=
 Unmap 00000000fff33000 TBs 2
[   46.059120] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0942, 52 bytes at 66[2]:9
[   46.062031] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 66    TFD ffff880107=
bb2100   00000000fff23400
[   46.062081] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009420=
0a8 to 00000000fff23400 TB 1  [2, 66]
[   46.065289] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb2100=
 Unmap 00000000fff23400 TBs 1
[   46.366008] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0943, 52 bytes at 67[3]:9
[   46.368948] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 67    TFD ffff880107=
bb2180   00000000fff13600
[   46.368982] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009430=
0a8 to 00000000fff13600 TB 1  [3, 67]
[   46.372180] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb2180=
 Unmap 00000000fff13600 TBs 1
[   46.737826] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 8    TFD ffff880107b=
60400   00000000fff03520
[   46.739334] iwlwifi 0000:02:00.0: ATTACHED 2 tbs to 8    TFD ffff880107b=
60400   00000000fff02840
[   46.747880] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b60400=
 Unmap 00000000fff03520 TBs 2
[   46.755823] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 7    TFD ffff880107b=
48380   00000000fff03668
[   46.760696] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b48380=
 Unmap 00000000fff03668 TBs 1
[   46.776130] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0944, 52 bytes at 68[4]:9
[   46.779061] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 68    TFD ffff880107=
bb2200   00000000ffef7a00
[   46.779096] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009440=
0a8 to 00000000ffef7a00 TB 1  [4, 68]
[   46.780700] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb2200=
 Unmap 00000000ffef7a00 TBs 1
[   47.286402] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0945, 52 bytes at 69[5]:9
[   47.289336] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 69    TFD ffff880107=
bb2280   00000000ffee1800
[   47.289371] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009450=
0a8 to 00000000ffee1800 TB 1  [5, 69]
[   47.292544] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb2280=
 Unmap 00000000ffee1800 TBs 1
[   47.388674] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0946, 52 bytes at 70[6]:9
[   47.391601] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 70    TFD ffff880107=
bb2300   00000000ffed9e00
[   47.391635] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009460=
0a8 to 00000000ffed9e00 TB 1  [6, 70]
[   47.394807] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb2300=
 Unmap 00000000ffed9e00 TBs 1
[   47.490978] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0947, 52 bytes at 71[7]:9
[   47.493859] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 71    TFD ffff880107=
bb2380   00000000ffed1200
[   47.493893] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009470=
0a8 to 00000000ffed1200 TB 1  [7, 71]
[   47.497051] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb2380=
 Unmap 00000000ffed1200 TBs 1
[   47.593212] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0948, 52 bytes at 72[8]:9
[   47.596121] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 72    TFD ffff880107=
bb2400   00000000ffec9e00
[   47.596156] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009480=
0a8 to 00000000ffec9e00 TB 1  [8, 72]
[   47.599328] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb2400=
 Unmap 00000000ffec9e00 TBs 1
[   47.695485] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0949, 52 bytes at 73[9]:9
[   47.698365] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 73    TFD ffff880107=
bb2480   00000000ffec1a00
[   47.698399] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009490=
0a8 to 00000000ffec1a00 TB 1  [9, 73]
[   47.701560] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb2480=
 Unmap 00000000ffec1a00 TBs 1
[   47.754537] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 8    TFD ffff880107b=
48400   00000000ffec17b0
[   47.761426] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b48400=
 Unmap 00000000ffec17b0 TBs 1
[   47.891015] dhcpcd used greatest stack depth: 4208 bytes left
[   48.206822] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x094A, 52 bytes at 74[10]:9
[   48.208321] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 74    TFD ffff880107=
bb2500   00000000ffea7c00
[   48.208368] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000094a0=
0a8 to 00000000ffea7c00 TB 1  [10, 74]
[   48.208578] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 9    TFD ffff880107b=
60480   00000000ffea68f8
[   48.208580] iwlwifi 0000:02:00.0: ATTACHED 2 tbs to 9    TFD ffff880107b=
60480   00000000ffea5240
[   48.212915] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b60480=
 Unmap 00000000ffea68f8 TBs 2
[   48.214417] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb2500=
 Unmap 00000000ffea7c00 TBs 1
[   48.217589] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 10    TFD ffff880107=
b60500   00000000ffea7000
[   48.219048] iwlwifi 0000:02:00.0: ATTACHED 2 tbs to 10    TFD ffff880107=
b60500   00000000ffea6a40
[   48.223908] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b60500=
 Unmap 00000000ffea7000 TBs 2
[   48.225383] iwlwifi 0000:02:00.0: Sending command REPLY_TX_LINK_QUALITY_=
CMD (#4e), seq: 0x094B, 92 bytes at 75[11]:9
[   48.228235] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 75    TFD ffff880107=
bb2580   00000000ffe9d600
[   48.228269] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000094b0=
04e to 00000000ffe9d600 TB 1  [11, 75]
[   48.229754] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 11    TFD ffff880107=
b60580   00000000ffe99000
[   48.231222] iwlwifi 0000:02:00.0: ATTACHED 2 tbs to 11    TFD ffff880107=
b60580   00000000ffe98e40
[   48.232699] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 12    TFD ffff880107=
b60600   00000000ffd05148
[   48.234143] iwlwifi 0000:02:00.0: ATTACHED 2 tbs to 12    TFD ffff880107=
b60600   00000000ffd04840
[   48.235613] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb2580=
 Unmap 00000000ffe9d600 TBs 1
[   48.237026] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b60580=
 Unmap 00000000ffe99000 TBs 2
[   48.238955] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b60600=
 Unmap 00000000ffd05148 TBs 2
[   48.309083] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x094C, 52 bytes at 76[12]:9
[   48.311833] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 76    TFD ffff880107=
bb2600   00000000ffe93800
[   48.311867] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000094c0=
0a8 to 00000000ffe93800 TB 1  [12, 76]
[   48.314947] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb2600=
 Unmap 00000000ffe93800 TBs 1
[   48.411391] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x094D, 52 bytes at 77[13]:9
[   48.414133] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 77    TFD ffff880107=
bb2680   00000000ffe87200
[   48.414167] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000094d0=
0a8 to 00000000ffe87200 TB 1  [13, 77]
[   48.417264] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb2680=
 Unmap 00000000ffe87200 TBs 1
[   48.753241] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 9    TFD ffff880107b=
48480   00000000ffe77a40
[   48.759229] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b48480=
 Unmap 00000000ffe77a40 TBs 1
[   48.820425] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x094E, 52 bytes at 78[14]:9
[   48.823206] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 78    TFD ffff880107=
bb2700   00000000ffe71400
[   48.823240] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000094e0=
0a8 to 00000000ffe71400 TB 1  [14, 78]
[   48.826347] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb2700=
 Unmap 00000000ffe71400 TBs 1
[   49.536320] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x094F, 52 bytes at 79[15]:9
[   49.539092] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 79    TFD ffff880107=
bb2780   00000000ffe51000
[   49.539127] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000094f0=
0a8 to 00000000ffe51000 TB 1  [15, 79]
[   49.542257] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb2780=
 Unmap 00000000ffe51000 TBs 1
[   49.751948] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 10    TFD ffff880107=
b48500   00000000ffe45b88
[   49.758710] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b48500=
 Unmap 00000000ffe45b88 TBs 1
[   50.208673] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 13    TFD ffff880107=
b60680   00000000ffe31290
[   50.210092] iwlwifi 0000:02:00.0: ATTACHED 2 tbs to 13    TFD ffff880107=
b60680   00000000ffe30640
[   50.216061] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b60680=
 Unmap 00000000ffe31290 TBs 2
[   50.740644] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 14    TFD ffff880107=
b60700   00000000ffe1d668
[   50.740690] iwlwifi 0000:02:00.0: ATTACHED 2 tbs to 14    TFD ffff880107=
b60700   00000000ffe1c440
[   50.747329] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b60700=
 Unmap 00000000ffe1d668 TBs 2
[   50.750653] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 11    TFD ffff880107=
b48580   00000000ffe15cd0
[   50.753968] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b48580=
 Unmap 00000000ffe15cd0 TBs 1
[   50.865768] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0950, 52 bytes at 80[16]:9
[   50.865825] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 80    TFD ffff880107=
bb2800   00000000ffe0be00
[   50.865859] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009500=
0a8 to 00000000ffe0be00 TB 1  [16, 80]
[   50.867586] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb2800=
 Unmap 00000000ffe0be00 TBs 1
[   51.741371] wlan0: no IPv6 routers present
[   51.749362] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 12    TFD ffff880107=
b48600   00000000ffde9e18
[   51.758415] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b48600=
 Unmap 00000000ffde9e18 TBs 1
[   51.990722] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0951, 52 bytes at 81[17]:9
[   51.990778] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 81    TFD ffff880107=
bb2880   00000000ffdd9a00
[   51.990812] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009510=
0a8 to 00000000ffdd9a00 TB 1  [17, 81]
[   51.992606] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb2880=
 Unmap 00000000ffdd9a00 TBs 1
[   52.195253] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0952, 52 bytes at 82[18]:9
[   52.195309] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 82    TFD ffff880107=
bb2900   00000000ffdcfc00
[   52.195344] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009520=
0a8 to 00000000ffdcfc00 TB 1  [18, 82]
[   52.197131] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb2900=
 Unmap 00000000ffdcfc00 TBs 1
[   52.748082] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 13    TFD ffff880107=
b48680   00000000ffdb9f60
[   52.753503] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b48680=
 Unmap 00000000ffdb9f60 TBs 1
[   53.013399] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0953, 52 bytes at 83[19]:9
[   53.013455] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 83    TFD ffff880107=
bb2980   00000000ffdab800
[   53.013489] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009530=
0a8 to 00000000ffdab800 TB 1  [19, 83]
[   53.015184] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb2980=
 Unmap 00000000ffdab800 TBs 1
[   53.746778] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 14    TFD ffff880107=
b48700   00000000ffd8f0a8
[   53.749096] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b48700=
 Unmap 00000000ffd8f0a8 TBs 1
[   54.649673] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0954, 52 bytes at 84[20]:9
[   54.649728] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 84    TFD ffff880107=
bb2a00   00000000ffd69600
[   54.649762] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009540=
0a8 to 00000000ffd69600 TB 1  [20, 84]
[   54.651510] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb2a00=
 Unmap 00000000ffd69600 TBs 1
[   54.745500] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 15    TFD ffff880107=
b48780   00000000ffd691f0
[   54.747843] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b48780=
 Unmap 00000000ffd691f0 TBs 1
[   54.751955] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0955, 52 bytes at 85[21]:9
[   54.752012] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 85    TFD ffff880107=
bb2a80   00000000ffd5f400
[   54.752046] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009550=
0a8 to 00000000ffd5f400 TB 1  [21, 85]
[   54.752194] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb2a80=
 Unmap 00000000ffd5f400 TBs 1
[   54.854211] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0956, 52 bytes at 86[22]:9
[   54.854268] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 86    TFD ffff880107=
bb2b00   00000000ffd59000
[   54.854303] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009560=
0a8 to 00000000ffd59000 TB 1  [22, 86]
[   54.856044] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb2b00=
 Unmap 00000000ffd59000 TBs 1
[   55.058743] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0957, 52 bytes at 87[23]:9
[   55.058799] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 87    TFD ffff880107=
bb2b80   00000000ffd4f800
[   55.058833] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009570=
0a8 to 00000000ffd4f800 TB 1  [23, 87]
[   55.060624] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb2b80=
 Unmap 00000000ffd4f800 TBs 1
[   55.263279] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0958, 52 bytes at 88[24]:9
[   55.263335] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 88    TFD ffff880107=
bb2c00   00000000ffd45600
[   55.263370] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009580=
0a8 to 00000000ffd45600 TB 1  [24, 88]
[   55.265158] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb2c00=
 Unmap 00000000ffd45600 TBs 1
[   55.467828] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0959, 52 bytes at 89[25]:9
[   55.469292] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 89    TFD ffff880107=
bb2c80   00000000ffd3d400
[   55.469326] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009590=
0a8 to 00000000ffd3d400 TB 1  [25, 89]
[   55.472502] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb2c80=
 Unmap 00000000ffd3d400 TBs 1
[   55.744197] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 16    TFD ffff880107=
b48800   00000000ffd35338
[   55.749446] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b48800=
 Unmap 00000000ffd35338 TBs 1
[   55.750972] iwlwifi 0000:02:00.0: Sending command REPLY_TX_LINK_QUALITY_=
CMD (#4e), seq: 0x095A, 92 bytes at 90[26]:9
[   55.753931] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 90    TFD ffff880107=
bb2d00   00000000ffd34a00
[   55.753964] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000095a0=
04e to 00000000ffd34a00 TB 1  [26, 90]
[   55.755631] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb2d00=
 Unmap 00000000ffd34a00 TBs 1
[   56.183679] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x095B, 52 bytes at 91[27]:9
[   56.186706] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 91    TFD ffff880107=
bb2d80   00000000ffd1de00
[   56.186741] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000095b0=
0a8 to 00000000ffd1de00 TB 1  [27, 91]
[   56.189975] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb2d80=
 Unmap 00000000ffd1de00 TBs 1
[   56.695052] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x095C, 52 bytes at 92[28]:9
[   56.698102] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 92    TFD ffff880107=
bb2e00   00000000ffd15c00
[   56.698136] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000095c0=
0a8 to 00000000ffd15c00 TB 1  [28, 92]
[   56.701382] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb2e00=
 Unmap 00000000ffd15c00 TBs 1
[   56.742906] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 17    TFD ffff880107=
b48880   00000000fff45480
[   56.750030] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b48880=
 Unmap 00000000fff45480 TBs 1
[   57.741608] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 18    TFD ffff880107=
b48900   00000000fff1b5c8
[   57.748728] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b48900=
 Unmap 00000000fff1b5c8 TBs 1
[   58.025908] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x095D, 52 bytes at 93[29]:9
[   58.028973] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 93    TFD ffff880107=
bb2e80   00000000ffd15e00
[   58.029007] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000095d0=
0a8 to 00000000ffd15e00 TB 1  [29, 93]
[   58.030946] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb2e80=
 Unmap 00000000ffd15e00 TBs 1
[   58.033657] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 15    TFD ffff880107=
b60780   00000000ffd09148
[   58.035182] iwlwifi 0000:02:00.0: ATTACHED 2 tbs to 15    TFD ffff880107=
b60780   00000000ffd08c40
[   58.040808] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b60780=
 Unmap 00000000ffd09148 TBs 2
[   58.126772] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x095E, 52 bytes at 94[30]:9
[   58.129764] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 94    TFD ffff880107=
bb2f00   00000000fff05c00
[   58.129798] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000095e0=
0a8 to 00000000fff05c00 TB 1  [30, 94]
[   58.133010] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb2f00=
 Unmap 00000000fff05c00 TBs 1
[   58.740326] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 19    TFD ffff880107=
b48980   00000000ffeeb710
[   58.748238] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b48980=
 Unmap 00000000ffeeb710 TBs 1
[   59.739028] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 20    TFD ffff880107=
b48a00   00000000ffec1858
[   59.746095] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b48a00=
 Unmap 00000000ffec1858 TBs 1
[   60.478933] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x095F, 52 bytes at 95[31]:9
[   60.481905] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 95    TFD ffff880107=
bb2f80   00000000ffe9ba00
[   60.481941] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000095f0=
0a8 to 00000000ffe9ba00 TB 1  [31, 95]
[   60.485083] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb2f80=
 Unmap 00000000ffe9ba00 TBs 1
[   60.737745] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 21    TFD ffff880107=
b48a80   00000000ffe939a0
[   60.743446] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b48a80=
 Unmap 00000000ffe939a0 TBs 1
[   60.744972] iwlwifi 0000:02:00.0: Sending command REPLY_TX_LINK_QUALITY_=
CMD (#4e), seq: 0x0960, 92 bytes at 96[0]:9
[   60.747921] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 96    TFD ffff880107=
bb3000   00000000ffe92c00
[   60.747954] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009600=
04e to 00000000ffe92c00 TB 1  [0, 96]
[   60.752177] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 16    TFD ffff880107=
b60800   00000000ffe8d148
[   60.753701] iwlwifi 0000:02:00.0: ATTACHED 2 tbs to 16    TFD ffff880107=
b60800   00000000ffe8ce40
[   60.755201] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb3000=
 Unmap 00000000ffe92c00 TBs 1
[   60.758720] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b60800=
 Unmap 00000000ffe8d148 TBs 2
[   60.760232] iwlwifi 0000:02:00.0: Sending command REPLY_TX_LINK_QUALITY_=
CMD (#4e), seq: 0x0961, 92 bytes at 97[1]:9
[   60.763126] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 97    TFD ffff880107=
bb3080   00000000ffe93c00
[   60.763159] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009610=
04e to 00000000ffe93c00 TB 1  [1, 97]
[   60.764732] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb3080=
 Unmap 00000000ffe93c00 TBs 1
[   61.297068] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0962, 52 bytes at 98[2]:9
[   61.299981] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 98    TFD ffff880107=
bb3100   00000000ffe6f400
[   61.300015] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009620=
0a8 to 00000000ffe6f400 TB 1  [2, 98]
[   61.303187] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb3100=
 Unmap 00000000ffe6f400 TBs 1
[   61.603867] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0963, 52 bytes at 99[3]:9
[   61.606801] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 99    TFD ffff880107=
bb3180   00000000ffe5f600
[   61.606835] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009630=
0a8 to 00000000ffe5f600 TB 1  [3, 99]
[   61.610019] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb3180=
 Unmap 00000000ffe5f600 TBs 1
[   61.736443] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 22    TFD ffff880107=
b48b00   00000000ffe57ae8
[   61.740238] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b48b00=
 Unmap 00000000ffe57ae8 TBs 1
[   62.626544] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0964, 52 bytes at 100[4]:9
[   62.629456] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 100    TFD ffff88010=
7bb3200   00000000ffe2fa00
[   62.629491] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009640=
0a8 to 00000000ffe2fa00 TB 1  [4, 100]
[   62.632678] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb3200=
 Unmap 00000000ffe2fa00 TBs 1
[   62.735153] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 23    TFD ffff880107=
b48b80   00000000ffe27c30
[   62.738944] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b48b80=
 Unmap 00000000ffe27c30 TBs 1
[   63.036266] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0965, 52 bytes at 101[5]:9
[   63.039201] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 101    TFD ffff88010=
7bb3280   00000000ffe1b800
[   63.039237] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009650=
0a8 to 00000000ffe1b800 TB 1  [5, 101]
[   63.040743] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 17    TFD ffff880107=
b60880   00000000ffe1a148
[   63.042216] iwlwifi 0000:02:00.0: ATTACHED 2 tbs to 17    TFD ffff880107=
b60880   00000000ffe19a40
[   63.043739] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb3280=
 Unmap 00000000ffe1b800 TBs 1
[   63.047157] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b60880=
 Unmap 00000000ffe1a148 TBs 2
[   63.137884] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0966, 52 bytes at 102[6]:9
[   63.140757] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 102    TFD ffff88010=
7bb3300   00000000ffe11e00
[   63.140791] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009660=
0a8 to 00000000ffe11e00 TB 1  [6, 102]
[   63.143949] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb3300=
 Unmap 00000000ffe11e00 TBs 1
[   63.240161] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0967, 52 bytes at 103[7]:9
[   63.243075] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 103    TFD ffff88010=
7bb3380   00000000ffe09200
[   63.243109] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009670=
0a8 to 00000000ffe09200 TB 1  [7, 103]
[   63.246284] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb3380=
 Unmap 00000000ffe09200 TBs 1
[   63.546966] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0968, 52 bytes at 104[8]:9
[   63.549886] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 104    TFD ffff88010=
7bb3400   00000000ffdf9e00
[   63.549920] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009680=
0a8 to 00000000ffdf9e00 TB 1  [8, 104]
[   63.553117] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb3400=
 Unmap 00000000ffdf9e00 TBs 1
[   63.733857] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 24    TFD ffff880107=
b48c00   00000000ffdf1d78
[   63.737643] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b48c00=
 Unmap 00000000ffdf1d78 TBs 1
[   64.058299] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0969, 52 bytes at 105[9]:9
[   64.061221] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 105    TFD ffff88010=
7bb3480   00000000ffddda00
[   64.061256] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009690=
0a8 to 00000000ffddda00 TB 1  [9, 105]
[   64.064437] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb3480=
 Unmap 00000000ffddda00 TBs 1
[   64.732572] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 25    TFD ffff880107=
b48c80   00000000ffdc1d78
[   64.737316] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b48c80=
 Unmap 00000000ffdc1d78 TBs 1
[   65.387774] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x096A, 52 bytes at 106[10]:9
[   65.390695] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 106    TFD ffff88010=
7bb3500   00000000ffda3c00
[   65.390730] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000096a0=
0a8 to 00000000ffda3c00 TB 1  [10, 106]
[   65.393918] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb3500=
 Unmap 00000000ffda3c00 TBs 1
[   65.731274] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 26    TFD ffff880107=
b48d00   00000000ffd93c30
[   65.735043] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b48d00=
 Unmap 00000000ffd93c30 TBs 1
[   66.729981] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 27    TFD ffff880107=
b48d80   00000000ffd69ae8
[   66.737602] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b48d80=
 Unmap 00000000ffd69ae8 TBs 1
[   66.819519] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x096B, 52 bytes at 107[11]:9
[   66.822481] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 107    TFD ffff88010=
7bb3580   00000000ffd63600
[   66.822516] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000096b0=
0a8 to 00000000ffd63600 TB 1  [11, 107]
[   66.825725] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb3580=
 Unmap 00000000ffd63600 TBs 1
[   67.535395] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x096C, 52 bytes at 108[12]:9
[   67.538355] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 108    TFD ffff88010=
7bb3600   00000000ffd45800
[   67.538390] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000096c0=
0a8 to 00000000ffd45800 TB 1  [12, 108]
[   67.541606] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb3600=
 Unmap 00000000ffd45800 TBs 1
[   67.728699] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 28    TFD ffff880107=
b48e00   00000000ffd459a0
[   67.736766] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b48e00=
 Unmap 00000000ffd459a0 TBs 1
[   67.739890] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x096D, 52 bytes at 109[13]:9
[   67.742845] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 109    TFD ffff88010=
7bb3680   00000000ffd37200
[   67.742880] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000096d0=
0a8 to 00000000ffd37200 TB 1  [13, 109]
[   67.744484] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb3680=
 Unmap 00000000ffd37200 TBs 1
[   68.727401] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 29    TFD ffff880107=
b48e80   00000000fff47858
[   68.735934] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b48e80=
 Unmap 00000000fff47858 TBs 1
[   69.376217] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x096E, 52 bytes at 110[14]:9
[   69.379168] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 110    TFD ffff88010=
7bb3700   00000000ffd1b400
[   69.379203] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000096e0=
0a8 to 00000000ffd1b400 TB 1  [14, 110]
[   69.382389] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb3700=
 Unmap 00000000ffd1b400 TBs 1
[   69.683018] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x096F, 52 bytes at 111[15]:9
[   69.685952] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 111    TFD ffff88010=
7bb3780   00000000fff1f000
[   69.685987] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000096f0=
0a8 to 00000000fff1f000 TB 1  [15, 111]
[   69.689177] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb3780=
 Unmap 00000000fff1f000 TBs 1
[   69.726104] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 30    TFD ffff880107=
b48f00   00000000fff1f710
[   69.732398] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b48f00=
 Unmap 00000000fff1f710 TBs 1
[   69.989822] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0970, 52 bytes at 112[16]:9
[   69.992796] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 112    TFD ffff88010=
7bb3800   00000000fff0fe00
[   69.992830] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009700=
0a8 to 00000000fff0fe00 TB 1  [16, 112]
[   69.996063] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb3800=
 Unmap 00000000fff0fe00 TBs 1
[   70.724810] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 31    TFD ffff880107=
b48f80   00000000ffef15c8
[   70.728631] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b48f80=
 Unmap 00000000ffef15c8 TBs 1
[   70.730164] iwlwifi 0000:02:00.0: Sending command REPLY_TX_LINK_QUALITY_=
CMD (#4e), seq: 0x0971, 92 bytes at 113[17]:9
[   70.733121] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 113    TFD ffff88010=
7bb3880   00000000ffef0a00
[   70.733155] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009710=
04e to 00000000ffef0a00 TB 1  [17, 113]
[   70.734814] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb3880=
 Unmap 00000000ffef0a00 TBs 1
[   71.217034] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0972, 52 bytes at 114[18]:9
[   71.220021] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 114    TFD ffff88010=
7bb3900   00000000ffedbc00
[   71.220055] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009720=
0a8 to 00000000ffedbc00 TB 1  [18, 114]
[   71.223245] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb3900=
 Unmap 00000000ffedbc00 TBs 1
[   71.723518] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 32    TFD ffff880107=
b49000   00000000ffecb480
[   71.728316] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b49000=
 Unmap 00000000ffecb480 TBs 1
[   72.035169] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0973, 52 bytes at 115[19]:9
[   72.038172] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 115    TFD ffff88010=
7bb3980   00000000ffeb7800
[   72.038207] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009730=
0a8 to 00000000ffeb7800 TB 1  [19, 115]
[   72.041424] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb3980=
 Unmap 00000000ffeb7800 TBs 1
[   72.137439] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0974, 52 bytes at 116[20]:9
[   72.140471] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 116    TFD ffff88010=
7bb3a00   00000000ffeaf600
[   72.140506] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009740=
0a8 to 00000000ffeaf600 TB 1  [20, 116]
[   72.143746] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb3a00=
 Unmap 00000000ffeaf600 TBs 1
[   72.720228] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 33    TFD ffff880107=
b49080   00000000ffe97148
[   72.728290] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b49080=
 Unmap 00000000ffe97148 TBs 1
[   72.751073] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0975, 52 bytes at 117[21]:9
[   72.754102] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 117    TFD ffff88010=
7bb3a80   00000000ffe8b400
[   72.754137] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009750=
0a8 to 00000000ffe8b400 TB 1  [21, 117]
[   72.757333] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb3a80=
 Unmap 00000000ffe8b400 TBs 1
[   73.262374] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0976, 52 bytes at 118[22]:9
[   73.265396] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 118    TFD ffff88010=
7bb3b00   00000000ffe77000
[   73.265431] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009760=
0a8 to 00000000ffe77000 TB 1  [22, 118]
[   73.268660] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb3b00=
 Unmap 00000000ffe77000 TBs 1
[   73.569185] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0977, 52 bytes at 119[23]:9
[   73.572207] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 119    TFD ffff88010=
7bb3b80   00000000ffe67800
[   73.572242] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009770=
0a8 to 00000000ffe67800 TB 1  [23, 119]
[   73.575470] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb3b80=
 Unmap 00000000ffe67800 TBs 1
[   73.720931] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 34    TFD ffff880107=
b49100   00000000ffe5f338
[   73.725109] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b49100=
 Unmap 00000000ffe5f338 TBs 1
[   74.182789] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0978, 52 bytes at 120[24]:9
[   74.185810] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 120    TFD ffff88010=
7bb3c00   00000000ffe49600
[   74.185845] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009780=
0a8 to 00000000ffe49600 TB 1  [24, 120]
[   74.189072] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb3c00=
 Unmap 00000000ffe49600 TBs 1
[   74.694785] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0979, 52 bytes at 121[25]:9
[   74.697835] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 121    TFD ffff88010=
7bb3c80   00000000ffe2f400
[   74.697870] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009790=
0a8 to 00000000ffe2f400 TB 1  [25, 121]
[   74.701132] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb3c80=
 Unmap 00000000ffe2f400 TBs 1
[   74.719638] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 35    TFD ffff880107=
b49180   00000000ffe3b1f0
[   74.726283] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b49180=
 Unmap 00000000ffe3b1f0 TBs 1
[   75.000911] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x097A, 52 bytes at 122[26]:9
[   75.003923] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 122    TFD ffff88010=
7bb3d00   00000000ffe1fa00
[   75.003957] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000097a0=
0a8 to 00000000ffe1fa00 TB 1  [26, 122]
[   75.007183] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb3d00=
 Unmap 00000000ffe1fa00 TBs 1
[   75.718355] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 36    TFD ffff880107=
b49200   00000000ffdff0a8
[   75.727419] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b49200=
 Unmap 00000000ffdff0a8 TBs 1
[   76.023581] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x097B, 52 bytes at 123[27]:9
[   76.026631] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 123    TFD ffff88010=
7bb3d80   00000000ffdefe00
[   76.026682] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000097b0=
0a8 to 00000000ffdefe00 TB 1  [27, 123]
[   76.029834] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb3d80=
 Unmap 00000000ffdefe00 TBs 1
[   76.534946] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x097C, 52 bytes at 124[28]:9
[   76.537981] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 124    TFD ffff88010=
7bb3e00   00000000ffdd9c00
[   76.538030] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000097c0=
0a8 to 00000000ffdd9c00 TB 1  [28, 124]
[   76.541311] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb3e00=
 Unmap 00000000ffdd9c00 TBs 1
[   76.717065] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 37    TFD ffff880107=
b49280   00000000ffdd1f60
[   76.725128] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b49280=
 Unmap 00000000ffdd1f60 TBs 1
[   76.739503] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x097D, 52 bytes at 125[29]:9
[   76.742536] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 125    TFD ffff88010=
7bb3e80   00000000ffdc9e00
[   76.742571] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000097d0=
0a8 to 00000000ffdc9e00 TB 1  [29, 125]
[   76.744224] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb3e80=
 Unmap 00000000ffdc9e00 TBs 1
[   77.659883] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x097E, 52 bytes at 126[30]:9
[   77.662892] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 126    TFD ffff88010=
7bb3f00   00000000ffda1c00
[   77.662926] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000097e0=
0a8 to 00000000ffda1c00 TB 1  [30, 126]
[   77.666147] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb3f00=
 Unmap 00000000ffda1c00 TBs 1
[   77.715766] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 38    TFD ffff880107=
b49300   00000000ffda1e18
[   77.722290] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b49300=
 Unmap 00000000ffda1e18 TBs 1
[   77.966719] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x097F, 52 bytes at 127[31]:9
[   77.969719] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 127    TFD ffff88010=
7bb3f80   00000000ffd8fa00
[   77.969753] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000097f0=
0a8 to 00000000ffd8fa00 TB 1  [31, 127]
[   77.972970] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb3f80=
 Unmap 00000000ffd8fa00 TBs 1
[   78.714489] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 39    TFD ffff880107=
b49380   00000000ffd6fcd0
[   78.723178] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b49380=
 Unmap 00000000ffd6fcd0 TBs 1
[   78.989382] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0980, 52 bytes at 128[0]:9
[   78.992385] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 128    TFD ffff88010=
7bb4000   00000000ffd5fc00
[   78.992419] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009800=
0a8 to 00000000ffd5fc00 TB 1  [0, 128]
[   78.995610] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb4000=
 Unmap 00000000ffd5fc00 TBs 1
[   79.713173] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 40    TFD ffff880107=
b49400   00000000ffd43b88
[   79.722003] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b49400=
 Unmap 00000000ffd43b88 TBs 1
[   79.723545] iwlwifi 0000:02:00.0: Sending command REPLY_TX_LINK_QUALITY_=
CMD (#4e), seq: 0x0981, 92 bytes at 129[1]:9
[   79.726518] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 129    TFD ffff88010=
7bb4080   00000000ffd3fc00
[   79.726553] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009810=
04e to 00000000ffd3fc00 TB 1  [1, 129]
[   79.728216] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb4080=
 Unmap 00000000ffd3fc00 TBs 1
[   80.711899] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 41    TFD ffff880107=
b49480   00000000fff4ba40
[   80.720204] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b49480=
 Unmap 00000000fff4ba40 TBs 1
[   81.710593] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 42    TFD ffff880107=
b49500   00000000fff258f8
[   81.714402] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b49500=
 Unmap 00000000fff258f8 TBs 1
[   82.709309] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 43    TFD ffff880107=
b49580   00000000ffeff7b0
[   82.715601] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b49580=
 Unmap 00000000ffeff7b0 TBs 1
[   82.773267] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0982, 52 bytes at 130[2]:9
[   82.776252] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 130    TFD ffff88010=
7bb4100   00000000ffd19400
[   82.776287] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009820=
0a8 to 00000000ffd19400 TB 1  [2, 130]
[   82.779493] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb4100=
 Unmap 00000000ffd19400 TBs 1
[   82.875561] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0983, 52 bytes at 131[3]:9
[   82.878545] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 131    TFD ffff88010=
7bb4180   00000000ffef5600
[   82.878580] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009830=
0a8 to 00000000ffef5600 TB 1  [3, 131]
[   82.881798] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb4180=
 Unmap 00000000ffef5600 TBs 1
[   83.708000] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 44    TFD ffff880107=
b49600   00000000ffed3668
[   83.712786] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b49600=
 Unmap 00000000ffed3668 TBs 1
[   84.706729] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 45    TFD ffff880107=
b49680   00000000ffeaf520
[   84.710551] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b49680=
 Unmap 00000000ffeaf520 TBs 1
[   84.818619] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0984, 52 bytes at 132[4]:9
[   84.821611] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 132    TFD ffff88010=
7bb4200   00000000ffea5a00
[   84.821645] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009840=
0a8 to 00000000ffea5a00 TB 1  [4, 132]
[   84.824852] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb4200=
 Unmap 00000000ffea5a00 TBs 1
[   84.920878] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0985, 52 bytes at 133[5]:9
[   84.923894] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 133    TFD ffff88010=
7bb4280   00000000ffe9f800
[   84.923928] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009850=
0a8 to 00000000ffe9f800 TB 1  [5, 133]
[   84.927167] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb4280=
 Unmap 00000000ffe9f800 TBs 1
[   85.023151] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0986, 52 bytes at 134[6]:9
[   85.026179] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 134    TFD ffff88010=
7bb4300   00000000ffe97e00
[   85.026214] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009860=
0a8 to 00000000ffe97e00 TB 1  [6, 134]
[   85.029411] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb4300=
 Unmap 00000000ffe97e00 TBs 1
[   85.125424] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0987, 52 bytes at 135[7]:9
[   85.128465] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 135    TFD ffff88010=
7bb4380   00000000ffe8f200
[   85.128500] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009870=
0a8 to 00000000ffe8f200 TB 1  [7, 135]
[   85.131747] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb4380=
 Unmap 00000000ffe8f200 TBs 1
[   85.227696] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0988, 52 bytes at 136[8]:9
[   85.230711] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 136    TFD ffff88010=
7bb4400   00000000ffe8be00
[   85.230746] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009880=
0a8 to 00000000ffe8be00 TB 1  [8, 136]
[   85.233974] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb4400=
 Unmap 00000000ffe8be00 TBs 1
[   85.329953] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0989, 52 bytes at 137[9]:9
[   85.333010] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 137    TFD ffff88010=
7bb4480   00000000ffe7fa00
[   85.333045] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009890=
0a8 to 00000000ffe7fa00 TB 1  [9, 137]
[   85.336272] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb4480=
 Unmap 00000000ffe7fa00 TBs 1
[   85.432222] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x098A, 52 bytes at 138[10]:9
[   85.435283] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 138    TFD ffff88010=
7bb4500   00000000ffe77c00
[   85.435318] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000098a0=
0a8 to 00000000ffe77c00 TB 1  [10, 138]
[   85.438552] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb4500=
 Unmap 00000000ffe77c00 TBs 1
[   85.534496] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x098B, 52 bytes at 139[11]:9
[   85.537565] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 139    TFD ffff88010=
7bb4580   00000000ffe6f600
[   85.537600] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000098b0=
0a8 to 00000000ffe6f600 TB 1  [11, 139]
[   85.540840] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb4580=
 Unmap 00000000ffe6f600 TBs 1
[   85.636769] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x098C, 52 bytes at 140[12]:9
[   85.639811] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 140    TFD ffff88010=
7bb4600   00000000ffe67800
[   85.639846] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000098c0=
0a8 to 00000000ffe67800 TB 1  [12, 140]
[   85.643087] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb4600=
 Unmap 00000000ffe67800 TBs 1
[   85.705423] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 46    TFD ffff880107=
b49700   00000000ffe673d8
[   85.711771] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b49700=
 Unmap 00000000ffe673d8 TBs 1
[   85.739061] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x098D, 52 bytes at 141[13]:9
[   85.742119] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 141    TFD ffff88010=
7bb4680   00000000ffe5d200
[   85.742154] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000098d0=
0a8 to 00000000ffe5d200 TB 1  [13, 141]
[   85.745342] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb4680=
 Unmap 00000000ffe5d200 TBs 1
[   86.454935] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x098E, 52 bytes at 142[14]:9
[   86.454991] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 142    TFD ffff88010=
7bb4700   00000000ffe3d400
[   86.455026] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000098e0=
0a8 to 00000000ffe3d400 TB 1  [14, 142]
[   86.456813] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb4700=
 Unmap 00000000ffe3d400 TBs 1
[   86.704132] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 47    TFD ffff880107=
b49780   00000000ffe3b290
[   86.706468] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b49780=
 Unmap 00000000ffe3b290 TBs 1
[   87.170789] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x098F, 52 bytes at 143[15]:9
[   87.170844] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 143    TFD ffff88010=
7bb4780   00000000ffe1d000
[   87.170880] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 00000000098f0=
0a8 to 00000000ffe1d000 TB 1  [15, 143]
[   87.172627] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb4780=
 Unmap 00000000ffe1d000 TBs 1
[   87.702837] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 48    TFD ffff880107=
b49800   00000000ffe07148
[   87.709141] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b49800=
 Unmap 00000000ffe07148 TBs 1
[   87.988916] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0990, 52 bytes at 144[16]:9
[   87.991945] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 144    TFD ffff88010=
7bb4800   00000000ffdf9e00
[   87.991980] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009900=
0a8 to 00000000ffdf9e00 TB 1  [16, 144]
[   87.995209] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb4800=
 Unmap 00000000ffdf9e00 TBs 1
[   88.500253] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0991, 52 bytes at 145[17]:9
[   88.503286] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 145    TFD ffff88010=
7bb4880   00000000ffde1a00
[   88.503320] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009910=
0a8 to 00000000ffde1a00 TB 1  [17, 145]
[   88.506562] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb4880=
 Unmap 00000000ffde1a00 TBs 1
[   88.701565] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 49    TFD ffff880107=
b49880   00000000ffddb000
[   88.707593] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b49880=
 Unmap 00000000ffddb000 TBs 1
[   88.709152] iwlwifi 0000:02:00.0: Sending command REPLY_TX_LINK_QUALITY_=
CMD (#4e), seq: 0x0992, 92 bytes at 146[18]:9
[   88.712177] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 146    TFD ffff88010=
7bb4900   00000000ffdd7c00
[   88.712211] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009920=
04e to 00000000ffdd7c00 TB 1  [18, 146]
[   88.713856] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb4900=
 Unmap 00000000ffdd7c00 TBs 1
[   89.700254] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 50    TFD ffff880107=
b49900   00000000ffdb1000
[   89.706526] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b49900=
 Unmap 00000000ffdb1000 TBs 1
[   89.727466] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0993, 52 bytes at 147[19]:9
[   89.730534] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 147    TFD ffff88010=
7bb4980   00000000ffdab800
[   89.730569] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009930=
0a8 to 00000000ffdab800 TB 1  [19, 147]
[   89.733640] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb4980=
 Unmap 00000000ffdab800 TBs 1
[   89.829731] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0994, 52 bytes at 148[20]:9
[   89.832791] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 148    TFD ffff88010=
7bb4a00   00000000ffda3600
[   89.832826] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009940=
0a8 to 00000000ffda3600 TB 1  [20, 148]
[   89.836056] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb4a00=
 Unmap 00000000ffda3600 TBs 1
[   90.545611] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0995, 52 bytes at 149[21]:9
[   90.548619] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 149    TFD ffff88010=
7bb4a80   00000000ffd83400
[   90.548654] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009950=
0a8 to 00000000ffd83400 TB 1  [21, 149]
[   90.551918] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb4a80=
 Unmap 00000000ffd83400 TBs 1
[   90.698965] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 51    TFD ffff880107=
b49980   00000000ffd7b148
[   90.702805] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b49980=
 Unmap 00000000ffd7b148 TBs 1
[   91.159213] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0996, 52 bytes at 150[22]:9
[   91.162213] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 150    TFD ffff88010=
7bb4b00   00000000ffd65000
[   91.162247] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009960=
0a8 to 00000000ffd65000 TB 1  [22, 150]
[   91.165399] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb4b00=
 Unmap 00000000ffd65000 TBs 1
[   91.697670] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 52    TFD ffff880107=
b49a00   00000000fff59290
[   91.705982] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b49a00=
 Unmap 00000000fff59290 TBs 1
[   92.696382] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 53    TFD ffff880107=
b49a80   00000000ffd2d3d8
[   92.700205] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b49a80=
 Unmap 00000000ffd2d3d8 TBs 1
[   93.695082] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 54    TFD ffff880107=
b49b00   00000000fff31520
[   93.698888] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b49b00=
 Unmap 00000000fff31520 TBs 1
[   93.715896] iwlwifi 0000:02:00.0: Sending command SENSITIVITY_CMD (#a8),=
 seq: 0x0997, 52 bytes at 151[23]:9
[   93.718888] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 151    TFD ffff88010=
7bb4b80   00000000ffd25800
[   93.718926] iwlwifi 0000:02:00.0: iwl_enqueue_hcmd, Mapped 0000000009970=
0a8 to 00000000ffd25800 TB 1  [23, 151]
[   93.720704] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107bb4b80=
 Unmap 00000000ffd25800 TBs 1
[   94.693791] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 55    TFD ffff880107=
b49b80   00000000fff0b668
[   94.702135] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b49b80=
 Unmap 00000000fff0b668 TBs 1
[   95.692502] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 56    TFD ffff880107=
b49c00   00000000ffee57b0
[   95.699273] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b49c00=
 Unmap 00000000ffee57b0 TBs 1
[   96.691198] iwlwifi 0000:02:00.0: ATTACHED 1 tbs to 57    TFD ffff880107=
b49c80   00000000ffebb8f8
[   96.695010] iwlwifi 0000:02:00.0: iwlagn_unmap_tfd  TFD ffff880107b49c80=
 Unmap 00000000ffebb8f8 TBs 1

--pWyiEgJYm5f9v55/--

--f2QGlHpHGjS2mn6Y
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAEBAgAGBQJPpkEuAAoJEFMQTLzJFOZF7ZcIALZoHdEg3Qmho/2zfhDa0hH3
x0pITgvXgwY3Yjn0sG9zoMtSYOCoh/Olp9CiUQt5kUpt5f497E5gmfY1H1M/QVjc
oNCqX4UiApN+tjHbLZl1i6VOwBkeN3hnKoI8/iBvvQlwDwr2FZQ9LlPJDL8vSmjd
ctkFTVSmvGg64191octXJ622VlZhnszTnixx1cCWp7dYq2g5CUsxNpbhQt08P5ie
ZiJf/WlcIGWooghkmWRudPqPxvgbIcCul1plCXJvJfE+38xFGj044r78ODGhmQeu
6UmDRxdgTBLREf6zX8DYdEfAow38s2h2A4gcoHc4BiUro7j/lKlVutH6kmpaxcM=
=CPeI
-----END PGP SIGNATURE-----

--f2QGlHpHGjS2mn6Y--
