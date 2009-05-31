Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:51922 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbZEaUyW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 May 2009 16:54:22 -0400
Received: by bwz22 with SMTP id 22so7125958bwz.37
        for <linux-wireless@vger.kernel.org>; Sun, 31 May 2009 13:54:21 -0700 (PDT)
Subject: Re: [BUG] Crda oopses the system
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Bob Copeland <me@bobcopeland.com>,
	Pavel Roskin <proski@gnu.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1243774031.5741.5.camel@maxim-laptop>
References: <43e72e890905131612w275685d2tfe5066453b8b255e@mail.gmail.com>
	 <1242256950.3241.13.camel@maxim-laptop>
	 <43e72e890905131628i51255cd0wc16b7827a2514413@mail.gmail.com>
	 <1242258469.3241.19.camel@maxim-laptop>
	 <43e72e890905131707k2933f3cftfdec6e632f5b9fc3@mail.gmail.com>
	 <b6c5339f0905140720p29be483cr1968f50a6bea48e5@mail.gmail.com>
	 <1242742647.23110.10.camel@ibm172> <1242951611.5206.9.camel@maxim-laptop>
	 <43e72e890905211736i3dfaf7d5q78d511eac0fbca1e@mail.gmail.com>
	 <1242986902.5544.8.camel@maxim-laptop>
	 <20090531062217.GB23972@bombadil.infradead.org>
	 <1243774031.5741.5.camel@maxim-laptop>
Content-Type: multipart/mixed; boundary="=-bJ5XisRKzgdfNecF+xyX"
Date: Sun, 31 May 2009 23:54:13 +0300
Message-Id: <1243803253.5417.12.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-bJ5XisRKzgdfNecF+xyX
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Sun, 2009-05-31 at 15:47 +0300, Maxim Levitsky wrote:
> On Sun, 2009-05-31 at 02:22 -0400, Luis R. Rodriguez wrote:
> > On Fri, May 22, 2009 at 01:08:22PM +0300, Maxim Levitsky wrote:
> > > I am talking about 
> > > 
> > > BUG_ON(!country_ie_regdomain);
> > > in net/wireless/reg.c
> > 
> > Please try this patch and leave a window open with this running:
> > 
> > iw event
> > 
> > Please be sure to grab iw from git, not sure if the reg events
> > have all gone into an official release yet. What I'm looking for
> > is whether or not a previous 11d setting was already processed
> > or if the !country_ie_regdomain condition happens from the first
> > 11d processing.
> > 
> >   Luis
> > 
> > diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> > index f87ac1d..1b60dfc 100644
> > --- a/net/wireless/reg.c
> > +++ b/net/wireless/reg.c
> > @@ -2171,7 +2171,11 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
> >  	 * the country IE rd with what CRDA believes that country should have
> >  	 */
> >  
> > -	BUG_ON(!country_ie_regdomain);
> > +	if (WARN_ON(!country_ie_regdomain)) {
> > +		kfree(rd);
> > +		rd = NULL;
> > +		return -EINVAL;
> > +	}
> >  	BUG_ON(rd == country_ie_regdomain);
> >  
> >  	/*
> > @@ -2268,6 +2272,8 @@ int regulatory_init(void)
> >  	if (IS_ERR(reg_pdev))
> >  		return PTR_ERR(reg_pdev);
> >  
> > +	country_ie_regdomain = NULL;
> > +
> >  	spin_lock_init(&reg_requests_lock);
> >  	spin_lock_init(&reg_pending_beacons_lock);
> >  
> 
> 
> I'll test this today.
> I have iw from git.
> 
> Best regards,
> 	Maxim Levitsky
> 










Here it is:


> wlan0 (phy #0): assoc 00:1b:9e:d8:77:02 -> 00:1b:77:f1:7c:29 status: 0: Successful
> wlan0 (phy #0): disassoc 00:1b:77:f1:7c:29 -> 00:1b:9e:d8:77:02 reason 3: Deauthenticated because sending station is leaving (or has left) the IBSS or ESS
> wlan0 (phy #0): scan finished
> wlan0 (phy #0): auth 00:23:4d:3c:80:27 -> 00:1b:77:f1:7c:29 status: 0: Successful
> wlan0 (phy #0): assoc 00:23:4d:3c:80:27 -> 00:1b:77:f1:7c:29 status: 0: Successful
> phy #0: regulatory domain change: intersection used due to a request made by a country IE on phy0
> 
dmesg attached (I use nvidia drivers)



On top of that there are few more very bold bugs in ath5k AP mode:


1 - beacons are send only after I start hostapd twise (kill it, and
start again)

2 - ath5k makes kernel panic, reliably after few times hostapd have
started, I didn't yet captured the output.
I remember to see panics with ad-hoc as well. 
I mean blinking leds on keyboard.

3 - couldn't transfer any frames between AP and client, only association
works.

I have started the hostapd, associated the clent (using link-local
feature of NM) assigned both ap and client an ip address (ifconfig wlan0
10.1.0.1/24 on AP, and ifconfig wlan0 10.1.0.2/24 on client ) and yet
even I couldn't receive even a arp reply from AP, and vise versa.

I use hostapd and wpa_supplicant frm latest git.




--=-bJ5XisRKzgdfNecF+xyX
Content-Disposition: attachment; filename="dmesg"
Content-Type: text/plain; name="dmesg"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

[    0.000000] Linux version 2.6.30-rc7-wl (maxim@maxim-laptop) (gcc version 4.3.3 (Ubuntu 4.3.3-5ubuntu4) ) #22 SMP PREEMPT Sun May 31 15:31:50 IDT 2009
[    0.000000] Command line: root=UUID=9ac77d81-98b6-47fe-9141-450c3edaafdb ro acpi_backlight=vendor vga=791 splash 
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007fcfd000 (usable)
[    0.000000]  BIOS-e820: 000000007fcfd000 - 000000007fd08000 (reserved)
[    0.000000]  BIOS-e820: 000000007fd08000 - 000000007fd52000 (usable)
[    0.000000]  BIOS-e820: 000000007fd52000 - 000000007fd55000 (reserved)
[    0.000000]  BIOS-e820: 000000007fd55000 - 000000007fdbb000 (usable)
[    0.000000]  BIOS-e820: 000000007fdbb000 - 000000007fdbf000 (reserved)
[    0.000000]  BIOS-e820: 000000007fdbf000 - 000000007fe70000 (usable)
[    0.000000]  BIOS-e820: 000000007fe70000 - 000000007febf000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007febf000 - 000000007ff00000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007ff00000 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000] DMI 2.4 present.
[    0.000000] last_pfn = 0x7fe70 max_arch_pfn = 0x100000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0FFFE0000 mask FFFFE0000 write-protect
[    0.000000]   1 base 000000000 mask FC0000000 write-back
[    0.000000]   2 base 040000000 mask FC0000000 write-back
[    0.000000]   3 base 07FF00000 mask FFFF00000 uncachable
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 0000000000001000 - 0000000000006000 (usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000001000 (usable)
[    0.000000]  modified: 0000000000001000 - 0000000000006000 (reserved)
[    0.000000]  modified: 0000000000006000 - 000000000009fc00 (usable)
[    0.000000]  modified: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000007fcfd000 (usable)
[    0.000000]  modified: 000000007fcfd000 - 000000007fd08000 (reserved)
[    0.000000]  modified: 000000007fd08000 - 000000007fd52000 (usable)
[    0.000000]  modified: 000000007fd52000 - 000000007fd55000 (reserved)
[    0.000000]  modified: 000000007fd55000 - 000000007fdbb000 (usable)
[    0.000000]  modified: 000000007fdbb000 - 000000007fdbf000 (reserved)
[    0.000000]  modified: 000000007fdbf000 - 000000007fe70000 (usable)
[    0.000000]  modified: 000000007fe70000 - 000000007febf000 (ACPI NVS)
[    0.000000]  modified: 000000007febf000 - 000000007ff00000 (ACPI data)
[    0.000000]  modified: 000000007ff00000 - 0000000080000000 (reserved)
[    0.000000]  modified: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  modified: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  modified: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000] init_memory_mapping: 0000000000000000-000000007fe70000
[    0.000000]  0000000000 - 007fe00000 page 2M
[    0.000000]  007fe00000 - 007fe70000 page 4k
[    0.000000] kernel direct mapping tables up to 7fe70000 @ 8000-c000
[    0.000000] RAMDISK: 37c76000 - 37fef57b
[    0.000000] ACPI: RSDP 00000000000fe020 00024 (v02 ACRSYS)
[    0.000000] ACPI: XSDT 000000007fefe120 00064 (v01 ACRSYS ACRPRDCT 00000001      01000013)
[    0.000000] ACPI: FACP 000000007fefd000 000F4 (v04 ACRSYS ACRPRDCT 00000001 MSFT 01000013)
[    0.000000] ACPI: DSDT 000000007fef4000 08968 (v01 ACRSYS ACRPRDCT 00000001 MSFT 01000013)
[    0.000000] ACPI: FACS 000000007fe75000 00040
[    0.000000] ACPI: APIC 000000007fef3000 00068 (v02 ACRSYS ACRPRDCT 00000001 MSFT 01000013)
[    0.000000] ACPI: MCFG 000000007fef2000 0003C (v01 ACRSYS ACRPRDCT 00000001 MSFT 01000013)
[    0.000000] ACPI: SLIC 000000007fef1000 00176 (v01 ACRSYS ACRPRDCT 00000001 MSFT 01000013)
[    0.000000] ACPI: HPET 000000007fef0000 00038 (v01 ACRSYS ACRPRDCT 00000001 MSFT 01000013)
[    0.000000] ACPI: SSDT 000000007feef000 004C4 (v01  PmRef    CpuPm 00003000 INTL 20051117)
[    0.000000] ACPI: SSDT 000000007feee000 00232 (v01  PmRef  Cpu0Tst 00003000 INTL 20051117)
[    0.000000] ACPI: SSDT 000000007feed000 000A0 (v01  PmRef  Cpu1Tst 00003000 INTL 20051117)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] (7 early reservations) ==> bootmem [0000000000 - 007fe70000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 000083fd1c]    TEXT DATA BSS ==> [0000200000 - 000083fd1c]
[    0.000000]   #3 [0037c76000 - 0037fef57b]          RAMDISK ==> [0037c76000 - 0037fef57b]
[    0.000000]   #4 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
[    0.000000]   #5 [0000840000 - 00008401e4]              BRK ==> [0000840000 - 00008401e4]
[    0.000000]   #6 [0000008000 - 000000a000]          PGTABLE ==> [0000008000 - 000000a000]
[    0.000000] found SMP MP-table at [ffff8800000fe1b0] fe1b0
[    0.000000]  [ffffe20000000000-ffffe20001bfffff] PMD -> [ffff880001200000-ffff880002dfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00100000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[6] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000001
[    0.000000]     0: 0x00000006 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0007fcfd
[    0.000000]     0: 0x0007fd08 -> 0x0007fd52
[    0.000000]     0: 0x0007fd55 -> 0x0007fdbb
[    0.000000]     0: 0x0007fdbf -> 0x0007fe70
[    0.000000] On node 0 totalpages: 523768
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1700 pages reserved
[    0.000000]   DMA zone: 2238 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7107 pages used for memmap
[    0.000000]   DMA32 zone: 512667 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 0000000000001000 - 0000000000006000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 000000007fcfd000 - 000000007fd08000
[    0.000000] PM: Registered nosave memory: 000000007fd52000 - 000000007fd55000
[    0.000000] PM: Registered nosave memory: 000000007fdbb000 - 000000007fdbf000
[    0.000000] Allocating PCI resources starting at 88000000 (gap: 80000000:60000000)
[    0.000000] NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 26 pages at ffff880001011000, static data 76868 bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 514905
[    0.000000] Kernel command line: root=UUID=9ac77d81-98b6-47fe-9141-450c3edaafdb ro acpi_backlight=vendor vga=791 splash 
[    0.000000] Initializing CPU#0
[    0.000000] Preemptible RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:424
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1662.397 MHz processor.
[    0.010000] Console: colour dummy device 80x25
[    0.010000] console [tty0] enabled
[    0.010000] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.010000] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.010000] Checking aperture...
[    0.010000] No AGP bridge found
[    0.010000] Memory: 2052376k/2095552k available (3640k kernel code, 480k absent, 42076k reserved, 1783k data, 408k init)
[    0.010000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.010000] hpet clockevent registered
[    0.010000] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.010000] Calibrating delay loop (skipped), value calculated using timer frequency.. 3324.79 BogoMIPS (lpj=16623970)
[    0.010000] Security Framework initialized
[    0.010000] Mount-cache hash table entries: 256
[    0.010000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.010000] CPU: L2 cache: 2048K
[    0.010000] CPU: Physical Processor ID: 0
[    0.010000] CPU: Processor Core ID: 0
[    0.010000] CPU0: Thermal monitoring enabled (TM1)
[    0.010000] using mwait in idle threads.
[    0.010000] ACPI: Core revision 20090320
[    0.020066] Setting APIC routing to flat
[    0.020474] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.123587] CPU0: Intel(R) Core(TM)2 Duo CPU     T5450  @ 1.66GHz stepping 0d
[    0.130000] Booting processor 1 APIC 0x1 ip 0x6000
[    0.010000] Initializing CPU#1
[    0.010000] Calibrating delay using timer specific routine.. 3829.58 BogoMIPS (lpj=19147942)
[    0.010000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.010000] CPU: L2 cache: 2048K
[    0.010000] CPU: Physical Processor ID: 0
[    0.010000] CPU: Processor Core ID: 1
[    0.010000] CPU1: Thermal monitoring enabled (TM1)
[    0.010000] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.281398] CPU1: Intel(R) Core(TM)2 Duo CPU     T5450  @ 1.66GHz stepping 0d
[    0.281492] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.290020] Brought up 2 CPUs
[    0.290028] Total of 2 processors activated (7154.38 BogoMIPS).
[    0.290091] CPU0 attaching sched-domain:
[    0.290095]  domain 0: span 0-1 level MC
[    0.290098]   groups: 0 1
[    0.290104] CPU1 attaching sched-domain:
[    0.290106]  domain 0: span 0-1 level MC
[    0.290109]   groups: 1 0
[    0.290151] net_namespace: 1360 bytes
[    0.290151] NET: Registered protocol family 16
[    0.290151] ACPI: bus type pci registered
[    0.290151] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.290151] PCI: MCFG area at e0000000 reserved in E820
[    0.300001] CPU1: Temperature/speed normal
[    0.305857] PCI: Using MMCONFIG at e0000000 - efffffff
[    0.305866] PCI: Using configuration type 1 for base access
[    0.305889] bio: create slab <bio-0> at 0
[    0.310127] ACPI: EC: Look up EC in DSDT
[    0.360035] ACPI: BIOS _OSI(Linux) query ignored
[    0.365173] ACPI: EC: non-query interrupt received, switching to interrupt mode
[    0.390229] ACPI: Interpreter enabled
[    0.390239] ACPI: (supports S0 S3 S4 S5)
[    0.390274] ACPI: Using IOAPIC for interrupt routing
[    0.432649] ACPI: EC: GPE = 0x1c, I/O: command/status = 0x66, data = 0x62
[    0.432649] ACPI: EC: driver started in interrupt mode
[    0.432649] ACPI: No dock devices found.
[    0.432649] ACPI Warning (nspredef-0331): \_SB_.PCI0._OSC: Parameter count mismatch - ASL declared 5, ACPI requires 4 [20090320]
[    0.432649] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.432649] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.432649] pci 0000:00:01.0: PME# disabled
[    0.432649] pci 0000:00:1a.0: reg 20 io port: [0x60c0-0x60df]
[    0.432649] pci 0000:00:1a.1: reg 20 io port: [0x60a0-0x60bf]
[    0.432649] pci 0000:00:1a.7: reg 10 32bit mmio: [0x9b304c00-0x9b304fff]
[    0.432649] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.432649] pci 0000:00:1a.7: PME# disabled
[    0.432649] pci 0000:00:1b.0: reg 10 64bit mmio: [0x9b300000-0x9b303fff]
[    0.432649] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.432649] pci 0000:00:1b.0: PME# disabled
[    0.432649] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.432649] pci 0000:00:1c.0: PME# disabled
[    0.432649] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.432649] pci 0000:00:1c.1: PME# disabled
[    0.432649] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.432649] pci 0000:00:1c.2: PME# disabled
[    0.432649] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.432649] pci 0000:00:1c.3: PME# disabled
[    0.432649] pci 0000:00:1d.0: reg 20 io port: [0x6080-0x609f]
[    0.432649] pci 0000:00:1d.1: reg 20 io port: [0x6060-0x607f]
[    0.432660] pci 0000:00:1d.2: reg 20 io port: [0x6040-0x605f]
[    0.432837] pci 0000:00:1d.7: reg 10 32bit mmio: [0x9b304800-0x9b304bff]
[    0.433002] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.433020] pci 0000:00:1d.7: PME# disabled
[    0.433409] pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
[    0.433426] pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
[    0.433445] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at ff2c (mask 0003)
[    0.433462] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0068 (mask 0007)
[    0.433590] pci 0000:00:1f.1: reg 10 io port: [0x6108-0x610f]
[    0.433608] pci 0000:00:1f.1: reg 14 io port: [0x611c-0x611f]
[    0.433626] pci 0000:00:1f.1: reg 18 io port: [0x6100-0x6107]
[    0.433643] pci 0000:00:1f.1: reg 1c io port: [0x6118-0x611b]
[    0.433661] pci 0000:00:1f.1: reg 20 io port: [0x60e0-0x60ef]
[    0.433851] pci 0000:00:1f.2: reg 10 io port: [0x60f8-0x60ff]
[    0.433868] pci 0000:00:1f.2: reg 14 io port: [0x6114-0x6117]
[    0.433886] pci 0000:00:1f.2: reg 18 io port: [0x60f0-0x60f7]
[    0.433904] pci 0000:00:1f.2: reg 1c io port: [0x6110-0x6113]
[    0.433921] pci 0000:00:1f.2: reg 20 io port: [0x6020-0x603f]
[    0.433939] pci 0000:00:1f.2: reg 24 32bit mmio: [0x9b304000-0x9b3047ff]
[    0.434050] pci 0000:00:1f.2: PME# supported from D3hot
[    0.434067] pci 0000:00:1f.2: PME# disabled
[    0.434152] pci 0000:00:1f.3: reg 10 32bit mmio: [0x9b305000-0x9b3050ff]
[    0.434216] pci 0000:00:1f.3: reg 20 io port: [0x6000-0x601f]
[    0.440121] pci 0000:01:00.0: reg 10 32bit mmio: [0x92000000-0x92ffffff]
[    0.440139] pci 0000:01:00.0: reg 14 64bit mmio: [0x80000000-0x8fffffff]
[    0.440156] pci 0000:01:00.0: reg 1c 64bit mmio: [0x90000000-0x91ffffff]
[    0.440166] pci 0000:01:00.0: reg 24 io port: [0x5000-0x507f]
[    0.440176] pci 0000:01:00.0: reg 30 32bit mmio: [0xfffe0000-0xffffffff]
[    0.460203] pci 0000:00:01.0: bridge io port: [0x5000-0x5fff]
[    0.460207] pci 0000:00:01.0: bridge 32bit mmio: [0x90000000-0x92ffffff]
[    0.460213] pci 0000:00:01.0: bridge 64bit mmio pref: [0x80000000-0x8fffffff]
[    0.460366] pci 0000:00:1c.0: bridge io port: [0x4000-0x4fff]
[    0.460373] pci 0000:00:1c.0: bridge 32bit mmio: [0x9a300000-0x9b2fffff]
[    0.460391] pci 0000:00:1c.0: bridge 64bit mmio pref: [0x93000000-0x93ffffff]
[    0.460544] pci 0000:00:1c.1: bridge io port: [0x3000-0x3fff]
[    0.460554] pci 0000:00:1c.1: bridge 32bit mmio: [0x99300000-0x9a2fffff]
[    0.460572] pci 0000:00:1c.1: bridge 64bit mmio pref: [0x94000000-0x94ffffff]
[    0.460795] pci 0000:05:00.0: reg 10 64bit mmio: [0x98200000-0x9820ffff]
[    0.461019] pci 0000:05:00.0: PME# supported from D3hot D3cold
[    0.461043] pci 0000:05:00.0: PME# disabled
[    0.461728] pci 0000:00:1c.2: bridge io port: [0x2000-0x2fff]
[    0.461738] pci 0000:00:1c.2: bridge 32bit mmio: [0x98200000-0x992fffff]
[    0.461756] pci 0000:00:1c.2: bridge 64bit mmio pref: [0x95000000-0x95ffffff]
[    0.461958] pci 0000:06:00.0: reg 10 32bit mmio: [0x97100000-0x97100fff]
[    0.462211] pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
[    0.462232] pci 0000:06:00.0: PME# disabled
[    0.462339] pci 0000:06:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.462572] pci 0000:00:1c.3: bridge io port: [0x1000-0x1fff]
[    0.462578] pci 0000:00:1c.3: bridge 32bit mmio: [0x97100000-0x981fffff]
[    0.462587] pci 0000:00:1c.3: bridge 64bit mmio pref: [0x96000000-0x96ffffff]
[    0.462639] pci 0000:07:00.0: reg 10 32bit mmio: [0x97000000-0x970007ff]
[    0.462707] pci 0000:07:00.0: supports D1 D2
[    0.462709] pci 0000:07:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.462723] pci 0000:07:00.0: PME# disabled
[    0.462778] pci 0000:07:00.1: reg 10 32bit mmio: [0x97000a00-0x97000aff]
[    0.462847] pci 0000:07:00.1: supports D1 D2
[    0.462849] pci 0000:07:00.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.462863] pci 0000:07:00.1: PME# disabled
[    0.462917] pci 0000:07:00.2: reg 10 32bit mmio: [0x97000900-0x970009ff]
[    0.462985] pci 0000:07:00.2: supports D1 D2
[    0.462987] pci 0000:07:00.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.463001] pci 0000:07:00.2: PME# disabled
[    0.463056] pci 0000:07:00.3: reg 10 32bit mmio: [0x97000800-0x970008ff]
[    0.463125] pci 0000:07:00.3: supports D1 D2
[    0.463128] pci 0000:07:00.3: PME# supported from D0 D1 D2 D3hot D3cold
[    0.463142] pci 0000:07:00.3: PME# disabled
[    0.463229] pci 0000:00:1e.0: transparent bridge
[    0.463244] pci 0000:00:1e.0: bridge 32bit mmio: [0x97000000-0x970fffff]
[    0.463290] pci_bus 0000:00: on NUMA node 0
[    0.463299] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.463530] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
[    0.463651] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
[    0.463757] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
[    0.463863] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP4._PRT]
[    0.463981] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGP._PRT]
[    0.470564] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12)
[    0.470564] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 10 *11 12)
[    0.470564] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 10 *11 12)
[    0.470699] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 *11 12)
[    0.470887] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
[    0.471080] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 *10 11 12)
[    0.471269] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 9 10 *11 12)
[    0.471456] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 9 10 *11 12)
[    0.471573] SCSI subsystem initialized
[    0.471573] libata version 3.00 loaded.
[    0.471573] PCI: Using ACPI for IRQ routing
[    0.560041] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.560055] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.580010] Switched to high resolution mode on CPU 0
[    0.581521] Switched to high resolution mode on CPU 1
[    0.642510] pnp: PnP ACPI init
[    0.642525] ACPI: bus type pnp registered
[    0.643889] pnp 00:01: io resource (0x164e-0x164f) overlaps 0000:00:1c.3 BAR 7 (0x1000-0x1fff), disabling
[    0.677575] pnp: PnP ACPI: found 10 devices
[    0.677584] ACPI: ACPI bus type pnp unregistered
[    0.677603] system 00:01: ioport range 0x600-0x60f has been reserved
[    0.677615] system 00:01: ioport range 0x610-0x610 has been reserved
[    0.677626] system 00:01: ioport range 0x800-0x80f has been reserved
[    0.677637] system 00:01: ioport range 0x810-0x817 has been reserved
[    0.677648] system 00:01: ioport range 0x400-0x47f has been reserved
[    0.677659] system 00:01: ioport range 0x500-0x53f has been reserved
[    0.677671] system 00:01: iomem range 0xe0000000-0xefffffff has been reserved
[    0.677684] system 00:01: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    0.677696] system 00:01: iomem range 0xfed14000-0xfed17fff has been reserved
[    0.677708] system 00:01: iomem range 0xfed18000-0xfed18fff has been reserved
[    0.677721] system 00:01: iomem range 0xfed19000-0xfed19fff has been reserved
[    0.677733] system 00:01: iomem range 0xfec00000-0xfec00fff has been reserved
[    0.677745] system 00:01: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.677757] system 00:01: iomem range 0x32000000-0x320000ff could not be reserved
[    0.683771] pci 0000:01:00.0: BAR 6: can't allocate mem resource [0x90000000-0x8fffffff]
[    0.683786] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.683797] pci 0000:00:01.0:   IO window: 0x5000-0x5fff
[    0.683809] pci 0000:00:01.0:   MEM window: 0x90000000-0x92ffffff
[    0.683821] pci 0000:00:01.0:   PREFETCH window: 0x00000080000000-0x0000008fffffff
[    0.683837] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
[    0.683849] pci 0000:00:1c.0:   IO window: 0x4000-0x4fff
[    0.683863] pci 0000:00:1c.0:   MEM window: 0x9a300000-0x9b2fffff
[    0.683877] pci 0000:00:1c.0:   PREFETCH window: 0x00000093000000-0x00000093ffffff
[    0.683896] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:04
[    0.683908] pci 0000:00:1c.1:   IO window: 0x3000-0x3fff
[    0.683922] pci 0000:00:1c.1:   MEM window: 0x99300000-0x9a2fffff
[    0.683935] pci 0000:00:1c.1:   PREFETCH window: 0x00000094000000-0x00000094ffffff
[    0.683955] pci 0000:00:1c.2: PCI bridge, secondary bus 0000:05
[    0.683966] pci 0000:00:1c.2:   IO window: 0x2000-0x2fff
[    0.683980] pci 0000:00:1c.2:   MEM window: 0x98200000-0x992fffff
[    0.683993] pci 0000:00:1c.2:   PREFETCH window: 0x00000095000000-0x00000095ffffff
[    0.684012] pci 0000:00:1c.3: PCI bridge, secondary bus 0000:06
[    0.684024] pci 0000:00:1c.3:   IO window: 0x1000-0x1fff
[    0.684038] pci 0000:00:1c.3:   MEM window: 0x97100000-0x981fffff
[    0.684051] pci 0000:00:1c.3:   PREFETCH window: 0x00000096000000-0x00000096ffffff
[    0.684070] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:07
[    0.684080] pci 0000:00:1e.0:   IO window: disabled
[    0.684093] pci 0000:00:1e.0:   MEM window: 0x97000000-0x970fffff
[    0.684106] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.684128]   alloc irq_desc for 16 on cpu 0 node 0
[    0.684130]   alloc kstat_irqs on cpu 0 node 0
[    0.684136] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.684150] pci 0000:00:01.0: setting latency timer to 64
[    0.684159] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.684173] pci 0000:00:1c.0: setting latency timer to 64
[    0.684183]   alloc irq_desc for 17 on cpu 0 node 0
[    0.684185]   alloc kstat_irqs on cpu 0 node 0
[    0.684189] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.684203] pci 0000:00:1c.1: setting latency timer to 64
[    0.684213]   alloc irq_desc for 18 on cpu 0 node 0
[    0.684216]   alloc kstat_irqs on cpu 0 node 0
[    0.684219] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.684233] pci 0000:00:1c.2: setting latency timer to 64
[    0.684243]   alloc irq_desc for 19 on cpu 0 node 0
[    0.684245]   alloc kstat_irqs on cpu 0 node 0
[    0.684249] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.684263] pci 0000:00:1c.3: setting latency timer to 64
[    0.684272] pci 0000:00:1e.0: setting latency timer to 64
[    0.684278] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.684281] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.684284] pci_bus 0000:01: resource 0 io:  [0x5000-0x5fff]
[    0.684286] pci_bus 0000:01: resource 1 mem: [0x90000000-0x92ffffff]
[    0.684289] pci_bus 0000:01: resource 2 pref mem [0x80000000-0x8fffffff]
[    0.684292] pci_bus 0000:02: resource 0 io:  [0x4000-0x4fff]
[    0.684295] pci_bus 0000:02: resource 1 mem: [0x9a300000-0x9b2fffff]
[    0.684298] pci_bus 0000:02: resource 2 pref mem [0x93000000-0x93ffffff]
[    0.684301] pci_bus 0000:04: resource 0 io:  [0x3000-0x3fff]
[    0.684303] pci_bus 0000:04: resource 1 mem: [0x99300000-0x9a2fffff]
[    0.684306] pci_bus 0000:04: resource 2 pref mem [0x94000000-0x94ffffff]
[    0.684309] pci_bus 0000:05: resource 0 io:  [0x2000-0x2fff]
[    0.684312] pci_bus 0000:05: resource 1 mem: [0x98200000-0x992fffff]
[    0.684314] pci_bus 0000:05: resource 2 pref mem [0x95000000-0x95ffffff]
[    0.684317] pci_bus 0000:06: resource 0 io:  [0x1000-0x1fff]
[    0.684320] pci_bus 0000:06: resource 1 mem: [0x97100000-0x981fffff]
[    0.684323] pci_bus 0000:06: resource 2 pref mem [0x96000000-0x96ffffff]
[    0.684326] pci_bus 0000:07: resource 1 mem: [0x97000000-0x970fffff]
[    0.684328] pci_bus 0000:07: resource 3 io:  [0x00-0xffff]
[    0.684331] pci_bus 0000:07: resource 4 mem: [0x000000-0xffffffffffffffff]
[    0.684348] NET: Registered protocol family 2
[    0.963537] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.963830] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.965876] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.966450] TCP: Hash tables configured (established 262144 bind 65536)
[    0.966461] TCP reno registered
[    1.084216] NET: Registered protocol family 1
[    1.084300] Unpacking initramfs...
[    1.194643] Freeing initrd memory: 3557k freed
[    1.197866] cpu0(2) debug files 120
[    1.198381] cpu1(2) debug files 120
[    1.198930] Scanning for low memory corruption every 60 seconds
[    1.205054] VFS: Disk quotas dquot_6.5.2
[    1.205133] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.205895] msgmni has been set to 4016
[    1.206193] alg: No test for stdrng (krng)
[    1.206209] io scheduler noop registered
[    1.206219] io scheduler anticipatory registered (default)
[    1.206228] io scheduler deadline registered
[    1.206246] io scheduler cfq registered
[    1.206665] pci 0000:01:00.0: Boot video device
[    1.206845]   alloc irq_desc for 24 on cpu 0 node 0
[    1.206848]   alloc kstat_irqs on cpu 0 node 0
[    1.206860] pcieport-driver 0000:00:01.0: irq 24 for MSI/MSI-X
[    1.206873] pcieport-driver 0000:00:01.0: setting latency timer to 64
[    1.207109]   alloc irq_desc for 25 on cpu 0 node 0
[    1.207111]   alloc kstat_irqs on cpu 0 node 0
[    1.207122] pcieport-driver 0000:00:1c.0: irq 25 for MSI/MSI-X
[    1.207142] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    1.207400]   alloc irq_desc for 26 on cpu 0 node 0
[    1.207402]   alloc kstat_irqs on cpu 0 node 0
[    1.207412] pcieport-driver 0000:00:1c.1: irq 26 for MSI/MSI-X
[    1.207433] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[    1.207694]   alloc irq_desc for 27 on cpu 0 node 0
[    1.207697]   alloc kstat_irqs on cpu 0 node 0
[    1.207707] pcieport-driver 0000:00:1c.2: irq 27 for MSI/MSI-X
[    1.207727] pcieport-driver 0000:00:1c.2: setting latency timer to 64
[    1.207992]   alloc irq_desc for 28 on cpu 0 node 0
[    1.207995]   alloc kstat_irqs on cpu 0 node 0
[    1.208005] pcieport-driver 0000:00:1c.3: irq 28 for MSI/MSI-X
[    1.208025] pcieport-driver 0000:00:1c.3: setting latency timer to 64
[    1.208274] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.208285] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    1.241768] decode_hpp: Could not get hotplug parameters. Use defaults
[    1.241892] acpiphp: Slot [1] registered
[    1.242257] vesafb: framebuffer at 0x91000000, mapped to 0xffffc20010100000, using 3072k, total 14336k
[    1.242273] vesafb: mode is 1024x768x16, linelength=2048, pages=1
[    1.242283] vesafb: scrolling: redraw
[    1.242292] vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
[    1.271178] Console: switching to colour frame buffer device 128x48
[    1.300126] fb0: VESA VGA frame buffer device
[    1.303994] ACPI: AC Adapter [AC] (on-line)
[    1.304414] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    1.304822] ACPI: Power Button [PWRF]
[    1.305116] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:03/PNP0C0C:00/input/input1
[    1.305666] ACPI: Power Button [PWRB]
[    1.305944] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:03/PNP0C0D:00/input/input2
[    1.306550] ACPI: Lid Switch [LID0]
[    1.306824] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:03/PNP0C0E:00/input/input3
[    1.307374] ACPI: Sleep Button [SLPB]
[    1.308133] ACPI: SSDT 000000007fe74c90 001EA (v01  PmRef  Cpu0Ist 00003000 INTL 20051117)
[    1.309198] ACPI: SSDT 000000007fe73610 005D7 (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
[    1.312197] ACPI Warning (processor_throttling-0843): Invalid throttling state, reset
[    1.312640]  [20090320]
[    1.312980] Monitor-Mwait will be used to enter C-1 state
[    1.313005] Monitor-Mwait will be used to enter C-2 state
[    1.313027] Monitor-Mwait will be used to enter C-3 state
[    1.313033] Marking TSC unstable due to TSC halts in idle
[    1.313385] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    1.313789] processor ACPI_CPU:00: registered as cooling_device0
[    1.314122] ACPI: Processor [CPU0] (supports 8 throttling states)
[    1.314882] ACPI: SSDT 000000007fe74f10 000C4 (v01  PmRef  Cpu1Ist 00003000 INTL 20051117)
[    1.315802] ACPI: SSDT 000000007fe76d10 00083 (v01  PmRef  Cpu1Cst 00003000 INTL 20051117)
[    1.317064] ACPI Warning (processor_throttling-0843): Invalid throttling state, reset
[    1.317507]  [20090320]
[    1.317997] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    1.326152] processor ACPI_CPU:01: registered as cooling_device1
[    1.334478] ACPI: Processor [CPU1] (supports 8 throttling states)
[    1.382782] thermal LNXTHERM:01: registered as thermal_zone0
[    1.391575] ACPI: Thermal Zone [TZ01] (55 C)
[    1.720156] ACPI: Battery Slot [BAT0] (battery present)
[    1.729712] Non-volatile memory driver v1.3
[    1.739052] Linux agpgart interface v0.103
[    1.749438] loop: module loaded
[    1.759168] nbd: registered device at major 43
[    1.771278] Driver 'sd' needs updating - please use bus_type methods
[    1.781521] Driver 'sr' needs updating - please use bus_type methods
[    1.791816] ahci 0000:00:1f.2: version 3.0
[    1.791834] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.802371]   alloc irq_desc for 29 on cpu 0 node 0
[    1.802374]   alloc kstat_irqs on cpu 0 node 0
[    1.802387] ahci 0000:00:1f.2: irq 29 for MSI/MSI-X
[    1.802463] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 3 Gbps 0x7 impl SATA mode
[    1.813303] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ems 
[    1.824393] ahci 0000:00:1f.2: setting latency timer to 64
[    1.826539] scsi0 : ahci
[    1.837829] scsi1 : ahci
[    1.849114] scsi2 : ahci
[    1.860406] ata1: SATA max UDMA/133 abar m2048@0x9b304000 port 0x9b304100 irq 29
[    1.872129] ata2: SATA max UDMA/133 abar m2048@0x9b304000 port 0x9b304180 irq 29
[    1.883883] ata3: SATA max UDMA/133 abar m2048@0x9b304000 port 0x9b304200 irq 29
[    1.895772] ata_piix 0000:00:1f.1: version 2.13
[    1.895783] ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.907928] ata_piix 0000:00:1f.1: setting latency timer to 64
[    1.908001] scsi3 : ata_piix
[    1.920285] scsi4 : ata_piix
[    1.932571] ata4: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x60e0 irq 14
[    1.944978] ata5: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x60e8 irq 15
[    1.957427] PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
[    2.007810] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.020051] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.032174] mice: PS/2 mouse device common for all mice
[    2.044025] rtc_cmos 00:03: RTC can wake from S4
[    2.055548] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    2.066828] rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
[    2.077895] i2c /dev entries driver
[    2.080544] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    2.099509] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.110896] cpuidle: using governor ladder
[    2.122497] cpuidle: using governor menu
[    2.130419] ata4.00: ATAPI: HL-DT-ST DVDRAM GSA-T20N, WP03, max UDMA/33
[    2.143926] Advanced Linux Sound Architecture Driver Version 1.0.20.
[    2.154721] ALSA device list:
[    2.165320]   No soundcards found.
[    2.175832] Netfilter messages via NETLINK v0.30.
[    2.176132] ata4.00: configured for UDMA/33
[    2.196703] TCP cubic registered
[    2.207089] Initializing XFRM netlink socket
[    2.217616] registered taskstats version 1
[    2.227932] rtc_cmos 00:03: setting system clock to 2009-05-31 20:28:39 UTC (1243801719)
[    2.238411] ata2: SATA link down (SStatus 0 SControl 300)
[    2.248877] ata3: SATA link down (SStatus 0 SControl 300)
[    2.410144] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.500055] Clocksource tsc unstable (delta = -144631009 ns)
[    2.808033] ata1.00: ATA-8: TOSHIBA MK1646GSX, LB113J, max UDMA/100
[    2.818265] ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    2.829491] ata1.00: configured for UDMA/100
[    2.842778] scsi 0:0:0:0: Direct-Access     ATA      TOSHIBA MK1646GS LB11 PQ: 0 ANSI: 5
[    2.853842] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.853868] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors: (160 GB/149 GiB)
[    2.853886] sd 0:0:0:0: [sda] Write Protect is off
[    2.853889] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.853911] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.854026]  sda:<5>scsi 3:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-T20N  WP03 PQ: 0 ANSI: 5
[    2.911936]  sda1 sda3 sda4
[    2.923728] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.940989] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    2.952292] Uniform CD-ROM driver Revision: 3.20
[    2.963899] sr 3:0:0:0: Attached scsi CD-ROM sr0
[    2.964082] sr 3:0:0:0: Attached scsi generic sg1 type 5
[    3.160181] Freeing unused kernel memory: 408k freed
[    3.314995] fuse init (API version 7.11)
[    3.983119] PM: Starting manual resume from disk
[    3.993905] EXT4-fs: barriers enabled
[    4.015947] kjournald2 starting: pid 1224, dev sda4:8, commit interval 5 seconds
[    4.015957] EXT4-fs: delayed allocation enabled
[    4.015959] EXT4-fs: file extents enabled
[    4.020175] EXT4-fs: mballoc enabled
[    4.020192] EXT4-fs: mounted filesystem sda4 with ordered data mode
[    9.733330] udev: starting version 141
[   10.071536] ACPI: WMI: Mapper loaded
[   10.190572] usbcore: registered new interface driver usbfs
[   10.190610] usbcore: registered new interface driver hub
[   10.190694] usbcore: registered new device driver usb
[   10.731524] nvidia: module license 'NVIDIA' taints kernel.
[   10.731531] Disabling lock debugging due to kernel taint
[   10.781712] iTCO_vendor_support: vendor-support=0
[   10.783258] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
[   10.783355] iTCO_wdt: Found a ICH8M TCO device (Version=2, TCOBASE=0x0460)
[   10.783416] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   10.840358] sdhci: Secure Digital Host Controller Interface driver
[   10.840363] sdhci: Copyright(c) Pierre Ossman
[   10.883665] sdhci-pci 0000:07:00.1: SDHCI controller found [1180:0822] (rev 22)
[   10.883686]   alloc irq_desc for 22 on cpu 0 node 0
[   10.883689]   alloc kstat_irqs on cpu 0 node 0
[   10.883698] sdhci-pci 0000:07:00.1: PCI INT B -> GSI 22 (level, low) -> IRQ 22
[   10.886095] Registered led device: mmc0::
[   10.887291] mmc0: SDHCI controller on PCI [0000:07:00.1] using PIO
[   10.899476]   alloc irq_desc for 20 on cpu 0 node 0
[   10.899480]   alloc kstat_irqs on cpu 0 node 0
[   10.899489] ohci1394 0000:07:00.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[   10.899498] ohci1394 0000:07:00.0: setting latency timer to 64
[   10.964854] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[20]  MMIO=[97000000-970007ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
[   11.053401] nvidia 0000:01:00.0: power state changed by ACPI to D0
[   11.053415] nvidia 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   11.053424] nvidia 0000:01:00.0: setting latency timer to 64
[   11.053591] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  180.44  Tue Mar 24 05:46:32 PST 2009
[   11.075549] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   11.075587] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[   11.075610] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[   11.075614] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[   11.075671] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[   11.079587] ehci_hcd 0000:00:1a.7: debug port 1
[   11.079594] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[   11.079616] ehci_hcd 0000:00:1a.7: irq 18, io mem 0x9b304c00
[   11.100046] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[   11.100158] usb usb1: configuration #1 chosen from 1 choice
[   11.100195] hub 1-0:1.0: USB hub found
[   11.100204] hub 1-0:1.0: 4 ports detected
[   11.100346]   alloc irq_desc for 23 on cpu 0 node 0
[   11.100349]   alloc kstat_irqs on cpu 0 node 0
[   11.100358] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[   11.100382] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[   11.100386] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   11.100417] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[   11.104340] ehci_hcd 0000:00:1d.7: debug port 1
[   11.104348] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[   11.104367] ehci_hcd 0000:00:1d.7: irq 23, io mem 0x9b304800
[   11.120047] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[   11.120149] usb usb2: configuration #1 chosen from 1 choice
[   11.120187] hub 2-0:1.0: USB hub found
[   11.120196] hub 2-0:1.0: 6 ports detected
[   11.185328] uhci_hcd: USB Universal Host Controller Interface driver
[   11.185431] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   11.185445] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[   11.185450] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[   11.185490] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[   11.185543] uhci_hcd 0000:00:1a.0: irq 16, io base 0x000060c0
[   11.185665] usb usb3: configuration #1 chosen from 1 choice
[   11.185703] hub 3-0:1.0: USB hub found
[   11.185711] hub 3-0:1.0: 2 ports detected
[   11.185817]   alloc irq_desc for 21 on cpu 0 node 0
[   11.185820]   alloc kstat_irqs on cpu 0 node 0
[   11.185828] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[   11.185837] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[   11.185841] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[   11.185869] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[   11.185912] uhci_hcd 0000:00:1a.1: irq 21, io base 0x000060a0
[   11.186000] usb usb4: configuration #1 chosen from 1 choice
[   11.186034] hub 4-0:1.0: USB hub found
[   11.186041] hub 4-0:1.0: 2 ports detected
[   11.186147] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[   11.186155] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[   11.186159] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   11.186186] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
[   11.186219] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00006080
[   11.186310] usb usb5: configuration #1 chosen from 1 choice
[   11.186343] hub 5-0:1.0: USB hub found
[   11.186352] hub 5-0:1.0: 2 ports detected
[   11.186455] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[   11.186463] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[   11.186467] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   11.186494] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
[   11.186537] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00006060
[   11.186627] usb usb6: configuration #1 chosen from 1 choice
[   11.186669] hub 6-0:1.0: USB hub found
[   11.186677] hub 6-0:1.0: 2 ports detected
[   11.186777] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[   11.186786] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[   11.186790] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   11.186818] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
[   11.186850] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00006040
[   11.186951] usb usb7: configuration #1 chosen from 1 choice
[   11.186986] hub 7-0:1.0: USB hub found
[   11.186994] hub 7-0:1.0: 2 ports detected
[   11.274622] tg3.c:v3.98 (February 25, 2009)
[   11.274692] tg3 0000:05:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   11.274709] tg3 0000:05:00.0: setting latency timer to 64
[   11.290177] tg3 0000:05:00.0: PME# disabled
[   11.327796] acer-wmi: Acer Laptop ACPI-WMI Extras
[   11.338136] eth0: Tigon3 [partno(BCM95787m) rev b002] (PCI Express) MAC address 00:1b:38:c8:50:f3
[   11.338141] eth0: attached PHY is 5787 (10/100/1000Base-T Ethernet) (WireSpeed[1])
[   11.338144] eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[   11.338147] eth0: dma_rwctrl[76180000] dma_mask[64-bit]
[   11.360140] cfg80211: Calling CRDA to update world regulatory domain
[   11.394695] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[   11.394765]   alloc irq_desc for 30 on cpu 0 node 0
[   11.394768]   alloc kstat_irqs on cpu 0 node 0
[   11.394782] HDA Intel 0000:00:1b.0: irq 30 for MSI/MSI-X
[   11.394828] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   11.440087] usb 2-4: new high speed USB device using ehci_hcd and address 2
[   11.541719] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, 1.2.26kds
[   11.541723] iwl3945: Copyright(c) 2003-2009 Intel Corporation
[   11.541819] iwl3945 0000:06:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[   11.541834] iwl3945 0000:06:00.0: setting latency timer to 64
[   11.581684] cfg80211: World regulatory domain updated:
[   11.581689] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   11.581693] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   11.581696] 	(2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   11.581699] 	(2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   11.581702] 	(5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   11.581705] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   11.583470] cfg80211: World regulatory domain updated:
[   11.583473] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   11.583477] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   11.583481] 	(2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   11.583484] 	(2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   11.583487] 	(5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   11.583490] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   11.599957] usb 2-4: configuration #1 chosen from 1 choice
[   11.614038] iwl3945 0000:06:00.0: Tunable channels: 13 802.11bg, 0 802.11a channels
[   11.614043] iwl3945 0000:06:00.0: Detected Intel Wireless WiFi Link 3945BG
[   11.614189]   alloc irq_desc for 31 on cpu 0 node 0
[   11.614192]   alloc kstat_irqs on cpu 0 node 0
[   11.614227] iwl3945 0000:06:00.0: irq 31 for MSI/MSI-X
[   11.618422] phy0: Selected rate control algorithm 'iwl-3945-rs'
[   11.692201] Linux video capture interface: v2.00
[   11.693677] hda-codec: No codec parser is available
[   11.723451] uvcvideo: Found UVC 1.00 device Acer CrystalEye webcam (064e:a101)
[   11.725969] input: Acer CrystalEye webcam as /devices/pci0000:00/0000:00:1d.7/usb2/2-4/2-4:1.0/input/input5
[   11.726035] usbcore: registered new interface driver uvcvideo
[   11.726038] USB Video Class driver (v0.1.0)
[   11.878956] input: PS/2 Mouse as /devices/platform/i8042/serio1/input/input6
[   11.913571] input: AlpsPS/2 ALPS GlidePoint as /devices/platform/i8042/serio1/input/input7
[   12.280189] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[b64057b700023f7c]
[   12.437581] usbcore: registered new interface driver libusual
[   12.452444] Initializing USB Mass Storage driver...
[   12.452500] usbcore: registered new interface driver usb-storage
[   12.452503] USB Mass Storage support registered.
[   12.750017] hda_intel: No response from codec, disabling MSI: last cmd=0x018b0000
[   13.606775] Adding 3068404k swap on /dev/sda3.  Priority:-1 extents:1 across:3068404k 
[   13.760012] hda_intel: azx_get_response timeout, switching to polling mode: last cmd=0x018b0000
[   14.332192] EXT4 FS on sda4, internal journal on sda4:8
[   16.254622] RPC: Registered udp transport module.
[   16.254625] RPC: Registered tcp transport module.
[   16.411025] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   19.615270] /dev/vmmon[2935]: Module vmmon: registered with major=10 minor=165
[   19.615311] /dev/vmmon[2935]: Initial HV check: anyNotCapable=1 anyUnlocked=0 anyEnabled=0 anyDisabled=0
[   19.615317] /dev/vmmon[2935]: Module vmmon: initialized
[   19.640112] /dev/vmci[2945]: VMCI: Driver initialized.
[   19.641856] /dev/vmci[2945]: Module vmci: registered with major=10 minor=59
[   19.641862] /dev/vmci[2945]: Module vmci: initialized
[   21.262518] /dev/vmnet: open called by PID 3490 (vmnet-dhcpd)
[   21.262533] /dev/vmnet: hub 0 does not exist, allocating memory.
[   21.262557] /dev/vmnet: port on hub 0 successfully opened
[   21.340101] /dev/vmnet: open called by PID 3492 (vmnet-natd)
[   21.340119] /dev/vmnet: port on hub 0 successfully opened
[   21.403907] /dev/vmnet: open called by PID 3496 (vmnet-netifup)
[   21.403926] /dev/vmnet: port on hub 0 successfully opened
[   21.403941] vmnet0 (): not using net_device_ops yet
[   25.278422] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[   25.289036] NFSD: starting 90-second grace period
[   27.396006] Bluetooth: Core ver 2.15
[   27.398428] NET: Registered protocol family 31
[   27.398434] Bluetooth: HCI device and connection manager initialized
[   27.398440] Bluetooth: HCI socket layer initialized
[   27.431535] Bluetooth: L2CAP ver 2.13
[   27.431540] Bluetooth: L2CAP socket layer initialized
[   27.451205] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   27.451210] Bluetooth: BNEP filters: protocol multicast
[   27.519038] Bridge firewalling registered
[   27.533923] Bluetooth: SCO (Voice Link) ver 0.6
[   27.533928] Bluetooth: SCO socket layer initialized
[   28.806059] warning: `dhcpd3' uses 32-bit capabilities (legacy support in use)
[   28.864018] nvidia 0000:01:00.0: irq 30 for MSI/MSI-X
[   28.864044] IRQ 30/nvidia: IRQF_DISABLED is not guaranteed on shared IRQs
[   35.729646] tg3 0000:05:00.0: PME# disabled
[   35.729948]   alloc irq_desc for 32 on cpu 0 node 0
[   35.729953]   alloc kstat_irqs on cpu 0 node 0
[   35.729988] tg3 0000:05:00.0: irq 32 for MSI/MSI-X
[   36.031904] iwl3945 0000:06:00.0: firmware: requesting iwlwifi-3945-2.ucode
[   36.230893] iwl3945 0000:06:00.0: loaded firmware version 15.32.2.9
[   36.311919] Registered led device: iwl-phy0::radio
[   36.312021] Registered led device: iwl-phy0::assoc
[   36.312053] Registered led device: iwl-phy0::RX
[   36.312084] Registered led device: iwl-phy0::TX
[   36.463381] NET: Registered protocol family 17
[   36.574798] __ieee80211_start_scan: scan requested
[   36.575986] __ieee80211_start_scan: scan requested OK
[   37.660076] ieee80211_scan_completed: aborted=0
[   37.660083] cfg80211_scan_done: scan done. aborted=0
[   37.662617] ieee80211_scan_completed: exit
[   56.728514] __ieee80211_start_scan: scan requested
[   56.729579] __ieee80211_start_scan: scan requested OK
[   57.810076] ieee80211_scan_completed: aborted=0
[   57.810082] cfg80211_scan_done: scan done. aborted=0
[   57.812580] ieee80211_scan_completed: exit
[   66.688122] hda-intel: IRQ timing workaround is activated for card #0. Suggest a bigger bdl_pos_adj.
[   86.731155] __ieee80211_start_scan: scan requested
[   86.732885] __ieee80211_start_scan: scan requested OK
[   87.822550] ieee80211_scan_completed: aborted=0
[   87.822555] cfg80211_scan_done: scan done. aborted=0
[   87.825015] ieee80211_scan_completed: exit
[  126.735097] __ieee80211_start_scan: scan requested
[  126.735947] __ieee80211_start_scan: scan requested OK
[  127.820028] ieee80211_scan_completed: aborted=0
[  127.820033] cfg80211_scan_done: scan done. aborted=0
[  127.822249] ieee80211_scan_completed: exit
[  148.859939] __ieee80211_start_scan: scan requested
[  148.860584] __ieee80211_start_scan: scan requested OK
[  149.950075] ieee80211_scan_completed: aborted=0
[  149.950082] cfg80211_scan_done: scan done. aborted=0
[  149.951147] ieee80211_sta_req_auth: called
[  149.951912] ieee80211_scan_completed: exit
[  149.953254] wlan0: authenticate with AP 00:1b:9e:d8:77:02
[  149.955180] wlan0: authenticated
[  149.956127] ieee80211_sta_req_auth: called
[  149.956771] wlan0: associate with AP 00:1b:9e:d8:77:02
[  149.959389] wlan0: RX AssocResp from 00:1b:9e:d8:77:02 (capab=0x411 status=0 aid=3)
[  149.959395] wlan0: associated
[  170.452303] wlan0: disassociating by local choice (reason=3)
[  170.659255] __ieee80211_start_scan: scan requested
[  170.660561] __ieee80211_start_scan: scan requested OK
[  171.752542] ieee80211_scan_completed: aborted=0
[  171.752547] cfg80211_scan_done: scan done. aborted=0
[  171.753280] ieee80211_sta_req_auth: called
[  171.755054] ieee80211_scan_completed: exit
[  171.756586] wlan0: authenticate with AP 00:1b:9e:d8:77:02
[  171.758499] wlan0: authenticated
[  171.759258] ieee80211_sta_req_auth: called
[  171.760098] wlan0: associate with AP 00:1b:9e:d8:77:02
[  171.763787] wlan0: RX ReassocResp from 00:1b:9e:d8:77:02 (capab=0x411 status=0 aid=3)
[  171.763791] wlan0: associated
[  176.107408] __ieee80211_start_scan: scan requested
[  176.107444] __ieee80211_start_scan: scan requested OK
[  177.210111] ieee80211_scan_completed: aborted=0
[  177.210118] cfg80211_scan_done: scan done. aborted=0
[  177.212954] ieee80211_scan_completed: exit
[  185.240455] wlan0: disassociating by local choice (reason=3)
[  185.420203] __ieee80211_start_scan: scan requested
[  185.421266] __ieee80211_start_scan: scan requested OK
[  186.525760] ieee80211_scan_completed: aborted=0
[  186.525767] cfg80211_scan_done: scan done. aborted=0
[  186.526759] ieee80211_sta_req_auth: called
[  186.529091] ieee80211_scan_completed: exit
[  186.531133] wlan0: authenticate with AP 00:1b:9e:d8:77:02
[  186.533077] wlan0: authenticated
[  186.534122] ieee80211_sta_req_auth: called
[  186.534790] wlan0: associate with AP 00:1b:9e:d8:77:02
[  186.537498] wlan0: RX ReassocResp from 00:1b:9e:d8:77:02 (capab=0x411 status=0 aid=3)
[  186.537503] wlan0: associated
[  204.087221] wlan0: disassociating by local choice (reason=3)
[  204.313172] __ieee80211_start_scan: scan requested
[  204.314693] __ieee80211_start_scan: scan requested OK
[  205.402527] ieee80211_scan_completed: aborted=0
[  205.402531] cfg80211_scan_done: scan done. aborted=0
[  205.403202] ieee80211_sta_req_auth: called
[  205.406873] ieee80211_scan_completed: exit
[  205.410514] wlan0: authenticate with AP 00:1b:9e:d8:77:02
[  205.413127] wlan0: authenticated
[  205.413830] ieee80211_sta_req_auth: called
[  205.414665] wlan0: associate with AP 00:1b:9e:d8:77:02
[  205.417277] wlan0: RX ReassocResp from 00:1b:9e:d8:77:02 (capab=0x411 status=0 aid=3)
[  205.417281] wlan0: associated
[  216.111269] __ieee80211_start_scan: scan requested
[  216.111305] __ieee80211_start_scan: scan requested OK
[  217.190136] ieee80211_scan_completed: aborted=0
[  217.190144] cfg80211_scan_done: scan done. aborted=0
[  217.192401] ieee80211_scan_completed: exit
[  256.109448] __ieee80211_start_scan: scan requested
[  256.109484] __ieee80211_start_scan: scan requested OK
[  257.230114] ieee80211_scan_completed: aborted=0
[  257.230120] cfg80211_scan_done: scan done. aborted=0
[  257.232561] ieee80211_scan_completed: exit
[  280.550106] wlan0: disassociating by local choice (reason=3)
[  280.748587] __ieee80211_start_scan: scan requested
[  280.749576] __ieee80211_start_scan: scan requested OK
[  281.840068] ieee80211_scan_completed: aborted=0
[  281.840075] cfg80211_scan_done: scan done. aborted=0
[  281.841095] ieee80211_sta_req_auth: called
[  281.842168] ieee80211_scan_completed: exit
[  281.843850] wlan0: authenticate with AP 00:1b:9e:d8:77:02
[  281.845779] wlan0: authenticated
[  281.846719] ieee80211_sta_req_auth: called
[  281.847537] wlan0: associate with AP 00:1b:9e:d8:77:02
[  281.850972] wlan0: RX ReassocResp from 00:1b:9e:d8:77:02 (capab=0x411 status=0 aid=3)
[  281.850977] wlan0: associated
[  291.618214] wlan0: disassociating by local choice (reason=3)
[  291.813026] __ieee80211_start_scan: scan requested
[  291.817844] __ieee80211_start_scan: scan requested OK
[  292.902538] ieee80211_scan_completed: aborted=0
[  292.902543] cfg80211_scan_done: scan done. aborted=0
[  292.903432] ieee80211_sta_req_auth: called
[  292.904523] ieee80211_scan_completed: exit
[  292.906019] wlan0: authenticate with AP 00:23:4d:3c:80:27
[  292.907801] wlan0: authenticated
[  292.908539] ieee80211_sta_req_auth: called
[  292.909431] wlan0: associate with AP 00:23:4d:3c:80:27
[  292.911823] wlan0: RX ReassocResp from 00:23:4d:3c:80:27 (capab=0x401 status=0 aid=1)
[  292.911827] wlan0: associated
[  292.924959] cfg80211: Calling CRDA for country: IL
[  292.927402] cfg80211: Current regulatory domain updated by AP to: IL
[  292.927406] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[  292.927410] 	(2402000 KHz - 2477000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[  292.949903] ------------[ cut here ]------------
[  292.949930] WARNING: at /home/maxim/software/kernel/linux-2.6/net/wireless/reg.c:2174 set_regdom+0x3f6/0x4a0 [cfg80211]()
[  292.949933] Hardware name: Aspire 5720     
[  292.949935] Modules linked in: af_packet sco bridge stp llc bnep l2cap bluetooth vmnet vmblock vmci vmmon nfsd exportfs nfs lockd nfs_acl auth_rpcgss sunrpc usb_storage usb_libusual cpufreq_powersave cpufreq_conservative cpufreq_userspace acpi_cpufreq coretemp sbp2 joydev uvcvideo videodev v4l1_compat v4l2_compat_ioctl32 snd_hda_codec_realtek iwl3945 iwlcore mac80211 snd_hda_intel snd_hda_codec snd_hwdep acer_wmi rfkill snd_pcm tg3 backlight psmouse uhci_hcd ehci_hcd cfg80211 snd_timer ohci1394 sdhci_pci sdhci libphy serio_raw iTCO_wdt iTCO_vendor_support nvidia(P) usbcore snd_page_alloc wmi evdev fuse
[  292.949987] Pid: 6564, comm: crda Tainted: P           2.6.30-rc7-wl #22
[  292.949990] Call Trace:
[  292.950002]  [<ffffffffa08709b6>] ? set_regdom+0x3f6/0x4a0 [cfg80211]
[  292.950009]  [<ffffffff80244068>] warn_slowpath_common+0x78/0xd0
[  292.950013]  [<ffffffff802440cf>] warn_slowpath_null+0xf/0x20
[  292.950022]  [<ffffffffa08709b6>] set_regdom+0x3f6/0x4a0 [cfg80211]
[  292.950032]  [<ffffffffa0876ce2>] nl80211_set_reg+0x112/0x2c0 [cfg80211]
[  292.950038]  [<ffffffff803e652f>] ? nla_parse+0xef/0x110
[  292.950043]  [<ffffffff805134e6>] genl_rcv_msg+0x1b6/0x1f0
[  292.950047]  [<ffffffff80513330>] ? genl_rcv_msg+0x0/0x1f0
[  292.950052]  [<ffffffff80512b19>] netlink_rcv_skb+0x89/0xb0
[  292.950055]  [<ffffffff80513317>] genl_rcv+0x27/0x40
[  292.950059]  [<ffffffff80512679>] ? netlink_sendmsg+0x159/0x300
[  292.950063]  [<ffffffff80512504>] netlink_unicast+0x2c4/0x2e0
[  292.950068]  [<ffffffff804f337e>] ? __alloc_skb+0x6e/0x150
[  292.950072]  [<ffffffff8051271e>] netlink_sendmsg+0x1fe/0x300
[  292.950076]  [<ffffffff8031f320>] ? proc_delete_inode+0x0/0x50
[  292.950080]  [<ffffffff804ea457>] sock_sendmsg+0x127/0x140
[  292.950085]  [<ffffffff8025be00>] ? autoremove_wake_function+0x0/0x40
[  292.950090]  [<ffffffff802d8fda>] ? __link_path_walk+0x78a/0x1010
[  292.950095]  [<ffffffff8029f6c6>] ? get_page_from_freelist+0x3b6/0x650
[  292.950099]  [<ffffffff802996d5>] ? find_lock_page+0x25/0x70
[  292.950103]  [<ffffffff804e909b>] ? move_addr_to_kernel+0x2b/0x40
[  292.950107]  [<ffffffff804f499c>] ? verify_iovec+0x3c/0xd0
[  292.950111]  [<ffffffff804ea5f9>] sys_sendmsg+0x189/0x320
[  292.950114]  [<ffffffff804eb485>] ? move_addr_to_user+0x65/0x80
[  292.950119]  [<ffffffff802b13d1>] ? handle_mm_fault+0x1e1/0x830
[  292.950124]  [<ffffffff803d8a71>] ? __up_read+0x91/0xb0
[  292.950130]  [<ffffffff8020bf2b>] system_call_fastpath+0x16/0x1b
[  292.950133] ---[ end trace 2f9541b4b18ff046 ]---
[  293.019646] ACPI Warning (utdelete-0421): Large Reference Count (5070) in object ffff880059c96060 [20090320]
[  293.019671] general protection fault: 0000 [#1] PREEMPT SMP 
[  293.019677] last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
[  293.019680] CPU 1 
[  293.019682] Modules linked in: af_packet sco bridge stp llc bnep l2cap bluetooth vmnet vmblock vmci vmmon nfsd exportfs nfs lockd nfs_acl auth_rpcgss sunrpc usb_storage usb_libusual cpufreq_powersave cpufreq_conservative cpufreq_userspace acpi_cpufreq coretemp sbp2 joydev uvcvideo videodev v4l1_compat v4l2_compat_ioctl32 snd_hda_codec_realtek iwl3945 iwlcore mac80211 snd_hda_intel snd_hda_codec snd_hwdep acer_wmi rfkill snd_pcm tg3 backlight psmouse uhci_hcd ehci_hcd cfg80211 snd_timer ohci1394 sdhci_pci sdhci libphy serio_raw iTCO_wdt iTCO_vendor_support nvidia(P) usbcore snd_page_alloc wmi evdev fuse
[  293.019740] Pid: 9, comm: events/1 Tainted: P        W  2.6.30-rc7-wl #22 Aspire 5720     
[  293.019743] RIP: 0010:[<ffffffff8043436f>]  [<ffffffff8043436f>] acpi_ut_update_object_reference+0x29/0x160
[  293.019753] RSP: 0018:ffff88007f893c20  EFLAGS: 00010206
[  293.019756] RAX: ffff880059c96100 RBX: 305f545faf03000f RCX: 000000000001ffff
[  293.019758] RDX: 0000000000000001 RSI: 0000000000000001 RDI: 305f545faf03000f
[  293.019761] RBP: ffff88007f893c60 R08: 0000000000000000 R09: 000000000000000c
[  293.019764] R10: 0000000000000010 R11: 0000000000000000 R12: 0000000000000000
[  293.019767] R13: ffff880059e4ffc0 R14: 0000000000000001 R15: ffff88007f893c30
[  293.019770] FS:  0000000000000000(0000) GS:ffff88000102b000(0000) knlGS:0000000000000000
[  293.019773] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[  293.019776] CR2: 00007f4820d45948 CR3: 0000000000201000 CR4: 00000000000006e0
[  293.019779] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  293.019782] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  293.019785] Process events/1 (pid: 9, threadinfo ffff88007f892000, task ffff88007f88d800)
[  293.019787] Stack:
[  293.019789]  ffff88007f893c40 ffffffff802604f4 0000000000000000 0000000000000002
[  293.019794]  0000000000000000 ffff880059e4ffc0 ffff88006adea870 0000000000000040
[  293.019799]  ffff88007f893ca0 ffffffff8042f885 ffff880000000003 ffff880059e4ffc0
[  293.019804] Call Trace:
[  293.019807]  [<ffffffff802604f4>] ? up+0x34/0x50
[  293.019813]  [<ffffffff8042f885>] acpi_ps_execute_method+0x260/0x29b
[  293.019818]  [<ffffffff8042b8e6>] acpi_ns_evaluate+0xee/0x1b8
[  293.019823]  [<ffffffff8042b340>] acpi_evaluate_object+0x1c0/0x2c8
[  293.019828]  [<ffffffffa001d6d8>] wmi_evaluate_method+0x108/0x130 [wmi]
[  293.019836]  [<ffffffff8058400c>] ? thread_return+0x3e/0x712
[  293.019842]  [<ffffffffa09017d0>] ? acer_rfkill_update+0x0/0xa0 [acer_wmi]
[  293.019848]  [<ffffffffa090117c>] WMI_execute_u32+0x4c/0x90 [acer_wmi]
[  293.019855]  [<ffffffffa0901620>] get_u32+0x90/0x100 [acer_wmi]
[  293.019860]  [<ffffffffa09017ea>] acer_rfkill_update+0x1a/0xa0 [acer_wmi]
[  293.019866]  [<ffffffff80257293>] worker_thread+0x1a3/0x2a0
[  293.019872]  [<ffffffff8025be00>] ? autoremove_wake_function+0x0/0x40
[  293.019876]  [<ffffffff802570f0>] ? worker_thread+0x0/0x2a0
[  293.019881]  [<ffffffff802570f0>] ? worker_thread+0x0/0x2a0
[  293.019885]  [<ffffffff8025b906>] kthread+0x56/0x90
[  293.019888]  [<ffffffff8020ceaa>] child_rip+0xa/0x20
[  293.019894]  [<ffffffff8025b8b0>] ? kthread+0x0/0x90
[  293.019898]  [<ffffffff8020cea0>] ? child_rip+0x0/0x20
[  293.019902] Code: c9 c3 55 48 89 e5 41 57 4c 8d 7d d0 41 56 44 0f b7 f6 41 55 41 54 53 48 89 fb 48 83 ec 18 48 c7 45 d0 00 00 00 00 e9 db 00 00 00 <80> 7b 08 0f 0f 84 18 01 00 00 8a 43 09 83 e8 04 3c 10 0f 87 92 
[  293.019944] RIP  [<ffffffff8043436f>] acpi_ut_update_object_reference+0x29/0x160
[  293.019949]  RSP <ffff88007f893c20>
[  293.019953] ---[ end trace 2f9541b4b18ff047 ]---
[  300.040055] Machine check events logged
[  316.108981] __ieee80211_start_scan: scan requested
[  316.109019] __ieee80211_start_scan: scan requested OK
[  316.990131] ieee80211_scan_completed: aborted=0
[  316.990137] cfg80211_scan_done: scan done. aborted=0
[  316.992259] ieee80211_scan_completed: exit
[  356.108655] __ieee80211_start_scan: scan requested
[  356.108688] __ieee80211_start_scan: scan requested OK
[  357.040180] ieee80211_scan_completed: aborted=0
[  357.040187] cfg80211_scan_done: scan done. aborted=0
[  357.042408] ieee80211_scan_completed: exit
[  357.353562] wlan0: deauthenticated (Reason: 2)
[  357.571451] __ieee80211_start_scan: scan requested
[  357.571463] __ieee80211_start_scan: scan requested OK
[  358.490047] ieee80211_scan_completed: aborted=0
[  358.490054] cfg80211_scan_done: scan done. aborted=0
[  358.491036] ieee80211_sta_req_auth: called
[  358.492940] ieee80211_scan_completed: exit
[  358.494591] wlan0: authenticate with AP 00:23:4d:3c:80:27
[  358.690140] wlan0: authenticate with AP 00:23:4d:3c:80:27
[  358.890130] wlan0: authenticate with AP 00:23:4d:3c:80:27
[  359.090133] wlan0: authentication with AP 00:23:4d:3c:80:27 timed out
[  359.090991] iw[6379]: segfault at 0 ip 00007fbaa96e5da0 sp 00007fffd6595438 error 4 in libnl.so.1.1[7fbaa96ce000+4c000]
[  364.094383] __ieee80211_start_scan: scan requested
[  364.095187] __ieee80211_start_scan: scan requested OK
[  365.000124] ieee80211_scan_completed: aborted=0
[  365.000131] cfg80211_scan_done: scan done. aborted=0
[  365.002809] ieee80211_scan_completed: exit
[  370.002313] __ieee80211_start_scan: scan requested
[  370.003079] __ieee80211_start_scan: scan requested OK
[  370.900078] ieee80211_scan_completed: aborted=0
[  370.900085] cfg80211_scan_done: scan done. aborted=0
[  370.902744] ieee80211_scan_completed: exit
[  375.901940] __ieee80211_start_scan: scan requested
[  375.902792] __ieee80211_start_scan: scan requested OK
[  376.810135] ieee80211_scan_completed: aborted=0
[  376.810144] cfg80211_scan_done: scan done. aborted=0
[  376.812755] ieee80211_scan_completed: exit
[  381.811874] __ieee80211_start_scan: scan requested
[  381.812732] __ieee80211_start_scan: scan requested OK
[  382.720105] ieee80211_scan_completed: aborted=0
[  382.720113] cfg80211_scan_done: scan done. aborted=0
[  382.723065] ieee80211_scan_completed: exit
[  387.721894] __ieee80211_start_scan: scan requested
[  387.722568] __ieee80211_start_scan: scan requested OK
[  388.640124] ieee80211_scan_completed: aborted=0
[  388.640132] cfg80211_scan_done: scan done. aborted=0
[  388.642814] ieee80211_scan_completed: exit
[  393.641688] __ieee80211_start_scan: scan requested
[  393.642450] __ieee80211_start_scan: scan requested OK
[  394.530109] ieee80211_scan_completed: aborted=0
[  394.530116] cfg80211_scan_done: scan done. aborted=0
[  394.532814] ieee80211_scan_completed: exit
[  416.108551] __ieee80211_start_scan: scan requested
[  416.109191] __ieee80211_start_scan: scan requested OK
[  417.010130] ieee80211_scan_completed: aborted=0
[  417.010138] cfg80211_scan_done: scan done. aborted=0
[  417.012814] ieee80211_scan_completed: exit

--=-bJ5XisRKzgdfNecF+xyX--

