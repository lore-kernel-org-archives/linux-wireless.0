Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57473 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbZBYBpZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2009 20:45:25 -0500
Date: Tue, 24 Feb 2009 20:44:55 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: reinette chatre <reinette.chatre@intel.com>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] iwlagn: default to MAX_UCODE_BEACON_INTERVAL in
	iwl_adjust_beacon_interval
Message-ID: <20090225014454.GA3577@tuxdriver.com> (sfid-20090225_024535_952293_DA05B892)
References: <154E55ADF9629D4E8D13F08BF92ABEB629C9D28B8D@PDSMSX501.ccr.corp.intel.com> <20090220145223.GA15006@tuxdriver.com> <1235155966.5860.44.camel@rc-desk> <20090220194306.GA4051@tuxdriver.com> <20090221003013.GA3890@tuxdriver.com> <20090221003133.GB3890@tuxdriver.com> <1235443093.4455.77.camel@johannes.local>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="h31gzZEtNLTqOjlF"
In-Reply-To: <1235443093.4455.77.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 23, 2009 at 06:38:13PM -0800, Johannes Berg wrote:
> Ok, starting to look into this ...
> 
> Since it seems you get this all the time, could you please put a printk
> into net/wireless/scan.c in cfg80211_inform_bss_frame where it sets
> res->pub.beacon_interval, and print out
> 	"%p %d", &res->pub, res->pub.beacon_interval
> 
> and another one in cfg80211_get_bss where you print out the return value
> (just to make sure it's returning the right thing). Maybe also put one
> into cfg80211_bss_update where it updates things.
> 
> I suspect that some memory is getting overwritten or something. The
> embedded struct thing was a bit of a hack.
> 
> Also please put a printk into the iwlwifi code and into
> net/mac80211/mlme.c where it assigns
> 	sdata->vif.bss_conf.beacon_int = bss->cbss.beacon_interval;
> 
> so that I can see the order this happening.

I have applied the patch attached as "debug.patch".  I booted F10,
logged-in, and allowed NetworkManager to establish a connection.
The resulting dmesg output is attached as "dmesg.txt".

Hth!  Let me know if you want more...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="debug.patch"

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index b49f9f7..cb3ccbd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -640,6 +640,8 @@ static u16 iwl_adjust_beacon_interval(u16 beacon_val)
 	u16 new_val = 0;
 	u16 beacon_factor = 0;
 
+printk(KERN_ERR "%s %d\n", __FILE__, __LINE__);
+printk(KERN_ERR "%d\n", beacon_val);
 	beacon_factor = (beacon_val + MAX_UCODE_BEACON_INTERVAL)
 					/ MAX_UCODE_BEACON_INTERVAL;
 	new_val = beacon_val / beacon_factor;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 7f23858..77c17f3 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -638,6 +638,8 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
 	if (bss) {
 		/* set timing information */
 		sdata->vif.bss_conf.beacon_int = bss->cbss.beacon_interval;
+printk(KERN_ERR "%s %d\n", __FILE__, __LINE__);
+printk(KERN_ERR "%d\n", bss->cbss.beacon_interval);
 		sdata->vif.bss_conf.timestamp = bss->cbss.tsf;
 		sdata->vif.bss_conf.dtim_period = bss->dtim_period;
 
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 280dbcd..5a35ac3 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -219,6 +219,7 @@ struct cfg80211_bss *cfg80211_get_bss(struct wiphy *wiphy,
 {
 	struct cfg80211_registered_device *dev = wiphy_to_dev(wiphy);
 	struct cfg80211_internal_bss *bss, *res = NULL;
+	struct cfg80211_bss *ret;
 
 	spin_lock_bh(&dev->bss_lock);
 
@@ -236,8 +237,13 @@ struct cfg80211_bss *cfg80211_get_bss(struct wiphy *wiphy,
 
 	spin_unlock_bh(&dev->bss_lock);
 	if (!res)
-		return NULL;
-	return &res->pub;
+		ret = NULL;
+	else
+		ret = &res->pub;
+
+printk(KERN_ERR "%s %d\n", __FILE__, __LINE__);
+printk(KERN_ERR "%p\n", ret);
+	return ret;
 }
 EXPORT_SYMBOL(cfg80211_get_bss);
 
@@ -368,6 +374,8 @@ cfg80211_bss_update(struct cfg80211_registered_device *dev,
 	} else if (found) {
 		kref_get(&found->ref);
 		found->pub.beacon_interval = res->pub.beacon_interval;
+printk(KERN_ERR "%s %d\n", __FILE__, __LINE__);
+printk(KERN_ERR "%p %d\n", &res->pub, res->pub.beacon_interval);
 		found->pub.tsf = res->pub.tsf;
 		found->pub.signal = res->pub.signal;
 		found->pub.capability = res->pub.capability;
@@ -416,6 +424,8 @@ cfg80211_inform_bss_frame(struct wiphy *wiphy,
 	res->pub.signal = signal;
 	res->pub.tsf = le64_to_cpu(mgmt->u.probe_resp.timestamp);
 	res->pub.beacon_interval = le16_to_cpu(mgmt->u.probe_resp.beacon_int);
+printk(KERN_ERR "%s %d\n", __FILE__, __LINE__);
+printk(KERN_ERR "%p %d\n", &res->pub, res->pub.beacon_interval);
 	res->pub.capability = le16_to_cpu(mgmt->u.probe_resp.capab_info);
 	/* point to after the private area */
 	res->pub.information_elements = (u8 *)res + sizeof(*res) + privsz;

--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.txt"

Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.29-rc6-wl (linville@linville-t400.local) (gcc version 4.3.2 20081105 (Red Hat 4.3.2-7) (GCC) ) #10 SMP Tue Feb 24 19:45:55 EST 2009
Command line: ro root=/dev/VolGroup00/LogVol00 rhgb quiet
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
 BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007e8b1000 (usable)
 BIOS-e820: 000000007e8b1000 - 000000007e8b7000 (reserved)
 BIOS-e820: 000000007e8b7000 - 000000007e9b7000 (usable)
 BIOS-e820: 000000007e9b7000 - 000000007ea0f000 (reserved)
 BIOS-e820: 000000007ea0f000 - 000000007ea6b000 (usable)
 BIOS-e820: 000000007ea6b000 - 000000007ea76000 (ACPI NVS)
 BIOS-e820: 000000007ea76000 - 000000007ea7a000 (reserved)
 BIOS-e820: 000000007ea7a000 - 000000007ea7e000 (ACPI NVS)
 BIOS-e820: 000000007ea7e000 - 000000007ea81000 (reserved)
 BIOS-e820: 000000007ea81000 - 000000007eaa8000 (ACPI NVS)
 BIOS-e820: 000000007eaa8000 - 000000007eca0000 (reserved)
 BIOS-e820: 000000007eca0000 - 000000007ed00000 (ACPI data)
 BIOS-e820: 000000007ed00000 - 000000007ed0f000 (reserved)
 BIOS-e820: 000000007ed0f000 - 000000007ed9f000 (ACPI NVS)
 BIOS-e820: 000000007ed9f000 - 000000007ede5000 (usable)
 BIOS-e820: 000000007ede5000 - 000000007edfd000 (ACPI data)
 BIOS-e820: 000000007edfd000 - 000000007ee00000 (usable)
 BIOS-e820: 000000007ee00000 - 000000007f000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
 BIOS-e820: 00000000fed10000 - 00000000fed14000 (reserved)
 BIOS-e820: 00000000fed18000 - 00000000fed1a000 (reserved)
 BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
DMI present.
last_pfn = 0x7ee00 max_arch_pfn = 0x100000000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
init_memory_mapping: 0000000000000000-000000007ee00000
 0000000000 - 007ee00000 page 2M
kernel direct mapping tables up to 7ee00000 @ 8000-b000
last_map_addr: 7ee00000 end: 7ee00000
RAMDISK: 37c2d000 - 37fef398
ACPI: RSDP 000F65A0, 0024 (r2 LENOVO)
ACPI: XSDT 7ED6A5EC, 0094 (r1 LENOVO TP-7U        1070  LTP        0)
ACPI: FACP 7EDE9000, 00F4 (r3 LENOVO TP-7U        1070 LNVO        1)
ACPI Warning (tbfadt-0568): 32/64X length mismatch in Pm1aControlBlock: 16/32 [20081204]
ACPI Warning (tbfadt-0412): Invalid length for Pm1aControlBlock: 32, using default 16 [20081204]
FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
ACPI: DSDT 7EDEA000, F0B0 (r1 LENOVO TP-7U        1070 MSFT  3000000)
ACPI: FACS 7ED8E000, 0040
ACPI: SSDT 7ED6A8B4, 0227 (r1 LENOVO TP-7U        1070 MSFT  3000000)
ACPI: ECDT 7ED79B8B, 0052 (r1 LENOVO TP-7U        1070 LNVO        1)
ACPI: APIC 7ED79BDD, 0078 (r1 LENOVO TP-7U        1070 LNVO        1)
ACPI: MCFG 7ED79C55, 003C (r1 LENOVO TP-7U        1070 LNVO        1)
ACPI: HPET 7ED79C91, 0038 (r1 LENOVO TP-7U        1070 LNVO        1)
ACPI: SLIC 7ED79DF0, 0176 (r1 LENOVO TP-7U        1070  LTP        0)
ACPI: BOOT 7ED79F66, 0028 (r1 LENOVO TP-7U        1070  LTP        1)
ACPI: SSDT 7ED8D213, 054F (r1 LENOVO TP-7U        1070 INTL 20050513)
ACPI: TCPA 7EDFC000, 0032 (r0                        0             0)
ACPI: ASF! 7EDFA000, 0072 (r16 LENOVO TP-7U        1070 PTL         1)
ACPI: SSDT 7EDE8000, 0655 (r1  PmRef    CpuPm     3000 INTL 20050624)
ACPI: SSDT 7EDE7000, 0274 (r1  PmRef  Cpu0Tst     3000 INTL 20050624)
ACPI: SSDT 7EDE6000, 0242 (r1  PmRef    ApTst     3000 INTL 20050624)
ACPI: Local APIC address 0xfee00000
No NUMA configuration found
Faking a node at 0000000000000000-000000007ee00000
Bootmem setup node 0 0000000000000000-000000007ee00000
  NODE_DATA [0000000000009000 - 0000000000020fff]
  bootmap [0000000000021000 -  0000000000030dbf] pages 10
(6 early reservations) ==> bootmem [0000000000 - 007ee00000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0000200000 - 00014608c0]    TEXT DATA BSS ==> [0000200000 - 00014608c0]
  #3 [0037c2d000 - 0037fef398]          RAMDISK ==> [0037c2d000 - 0037fef398]
  #4 [000009ec00 - 0000100000]    BIOS reserved ==> [000009ec00 - 0000100000]
  #5 [0000008000 - 0000009000]          PGTABLE ==> [0000008000 - 0000009000]
found SMP MP-table at [ffff8800000f65e0] 000f65e0
 [ffffe20000000000-ffffe200033fffff] PMD -> [ffff880001600000-ffff8800049fffff] on node 0
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00100000
Movable zone start PFN for each node
early_node_map[6] active PFN ranges
    0: 0x00000000 -> 0x0000009e
    0: 0x00000100 -> 0x0007e8b1
    0: 0x0007e8b7 -> 0x0007e9b7
    0: 0x0007ea0f -> 0x0007ea6b
    0: 0x0007ed9f -> 0x0007ede5
    0: 0x0007edfd -> 0x0007ee00
On node 0 totalpages: 518644
  DMA zone: 104 pages used for memmap
  DMA zone: 103 pages reserved
  DMA zone: 3791 pages, LIFO batch:0
  DMA32 zone: 13091 pages used for memmap
  DMA32 zone: 501555 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 0, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a201 base: 0xfed00000
SMP: Allowing 4 CPUs, 2 hotplug CPUs
nr_irqs_gsi: 24
PM: Registered nosave memory: 000000000009e000 - 000000000009f000
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000dc000
PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
PM: Registered nosave memory: 000000007e8b1000 - 000000007e8b7000
PM: Registered nosave memory: 000000007e9b7000 - 000000007ea0f000
PM: Registered nosave memory: 000000007ea6b000 - 000000007ea76000
PM: Registered nosave memory: 000000007ea76000 - 000000007ea7a000
PM: Registered nosave memory: 000000007ea7a000 - 000000007ea7e000
PM: Registered nosave memory: 000000007ea7e000 - 000000007ea81000
PM: Registered nosave memory: 000000007ea81000 - 000000007eaa8000
PM: Registered nosave memory: 000000007eaa8000 - 000000007eca0000
PM: Registered nosave memory: 000000007eca0000 - 000000007ed00000
PM: Registered nosave memory: 000000007ed00000 - 000000007ed0f000
PM: Registered nosave memory: 000000007ed0f000 - 000000007ed9f000
PM: Registered nosave memory: 000000007ede5000 - 000000007edfd000
Allocating PCI resources starting at 80000000 (gap: 7f000000:61000000)
NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 nr_node_ids:1
PERCPU: Allocating 1904640 bytes of per cpu data
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 505346
Policy zone: DMA32
Kernel command line: ro root=/dev/VolGroup00/LogVol00 rhgb quiet
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
Fast TSC calibration using PIT
Detected 2526.937 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:  8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8191
... CLASSHASH_SIZE:          4096
... MAX_LOCKDEP_ENTRIES:     8192
... MAX_LOCKDEP_CHAINS:      16384
... CHAINHASH_SIZE:          8192
 memory used by lock dependency info: 4351 kB
 per task-struct memory footprint: 2688 bytes
allocated 20971520 bytes of page_cgroup
please try cgroup_disable=memory option if you don't want
Checking aperture...
No AGP bridge found
Calgary: detecting Calgary via BIOS EBDA area
Calgary: Unable to locate Rio Grande table in EBDA - bailing!
Memory: 1970312k/2078720k available (3636k kernel code, 4144k absent, 104264k reserved, 2182k data, 3064k init)
SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
hpet clockevent registered
HPET: 4 timers in total, 0 timers will be used for per-cpu timer
Calibrating delay loop (skipped), value calculated using timer frequency.. 5053.87 BogoMIPS (lpj=2526937)
Security Framework initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Initializing cgroup subsys net_cls
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
[ds] using Core 2/Atom configuration
CPU 0/0x0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM2)
using mwait in idle threads.
ACPI: Core revision 20081204
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM)2 Duo CPU     T9400  @ 2.53GHz stepping 06
lockdep: fixing up alternatives.
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 5053.72 BogoMIPS (lpj=2526864)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
[ds] using Core 2/Atom configuration
CPU 1/0x1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Core(TM)2 Duo CPU     T9400  @ 2.53GHz stepping 06
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
Total of 2 processors activated (10107.60 BogoMIPS).
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
khelper used greatest stack depth: 5848 bytes left
net_namespace: 2232 bytes
Booting paravirtualized kernel on bare hardware
regulator: core version 0.5
khelper used greatest stack depth: 5592 bytes left
Time:  1:37:12  Date: 02/25/09
NET: Registered protocol family 16
ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
ACPI: bus type pci registered
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 63
PCI: MCFG area at e0000000 reserved in E820
PCI: Using MMCONFIG at e0000000 - e3ffffff
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: EC description table is found, configuring boot EC
ACPI: BIOS _OSI(Linux) query ignored
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in interrupt mode
ACPI: ACPI Dock Station Driver: 3 docks/bays found
ACPI: PCI Root Bridge [PCI0] (0000:00)
DMAR: Forcing write-buffer flush capability
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:01.0: PME# disabled
pci 0000:00:03.0: reg 10 64bit mmio: [0xfc226800-0xfc22680f]
pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
pci 0000:00:03.0: PME# disabled
pci 0000:00:19.0: reg 10 32bit mmio: [0xfc200000-0xfc21ffff]
pci 0000:00:19.0: reg 14 32bit mmio: [0xfc225000-0xfc225fff]
pci 0000:00:19.0: reg 18 io port: [0x1840-0x185f]
pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
pci 0000:00:19.0: PME# disabled
pci 0000:00:1a.0: reg 20 io port: [0x1860-0x187f]
pci 0000:00:1a.1: reg 20 io port: [0x1880-0x189f]
pci 0000:00:1a.2: reg 20 io port: [0x18a0-0x18bf]
pci 0000:00:1a.7: reg 10 32bit mmio: [0xfc226c00-0xfc226fff]
pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.7: PME# disabled
pci 0000:00:1b.0: reg 10 64bit mmio: [0xfc220000-0xfc223fff]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PME# disabled
pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.3: PME# disabled
pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.4: PME# disabled
pci 0000:00:1d.0: reg 20 io port: [0x18c0-0x18df]
pci 0000:00:1d.1: reg 20 io port: [0x18e0-0x18ff]
pci 0000:00:1d.2: reg 20 io port: [0x1c00-0x1c1f]
pci 0000:00:1d.7: reg 10 32bit mmio: [0xfc227000-0xfc2273ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.2: reg 10 io port: [0x1c40-0x1c47]
pci 0000:00:1f.2: reg 14 io port: [0x1834-0x1837]
pci 0000:00:1f.2: reg 18 io port: [0x1838-0x183f]
pci 0000:00:1f.2: reg 1c io port: [0x1830-0x1833]
pci 0000:00:1f.2: reg 20 io port: [0x1c20-0x1c3f]
pci 0000:00:1f.2: reg 24 32bit mmio: [0xfc226000-0xfc2267ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: reg 10 64bit mmio: [0xfc227400-0xfc2274ff]
pci 0000:00:1f.3: reg 20 io port: [0x1c60-0x1c7f]
pci 0000:01:00.0: reg 10 32bit mmio: [0xd0000000-0xdfffffff]
pci 0000:01:00.0: reg 14 io port: [0x2000-0x20ff]
pci 0000:01:00.0: reg 18 32bit mmio: [0xcfff0000-0xcfffffff]
pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
pci 0000:01:00.0: supports D1 D2
pci 0000:00:01.0: bridge io port: [0x2000-0x2fff]
pci 0000:00:01.0: bridge 32bit mmio: [0xcff00000-0xcfffffff]
pci 0000:00:01.0: bridge 64bit mmio pref: [0xd0000000-0xdfffffff]
pci 0000:03:00.0: reg 10 64bit mmio: [0xf4200000-0xf4201fff]
pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
pci 0000:03:00.0: PME# disabled
pci 0000:00:1c.1: bridge 32bit mmio: [0xf4200000-0xf42fffff]
pci 0000:00:1c.3: bridge io port: [0x3000-0x3fff]
pci 0000:00:1c.3: bridge 32bit mmio: [0xf8000000-0xf9ffffff]
pci 0000:00:1c.3: bridge 64bit mmio pref: [0xf4000000-0xf40fffff]
pci 0000:00:1c.4: bridge io port: [0x4000-0x4fff]
pci 0000:00:1c.4: bridge 32bit mmio: [0xfa000000-0xfbffffff]
pci 0000:00:1c.4: bridge 64bit mmio pref: [0xf4100000-0xf41fffff]
pci 0000:15:00.0: reg 10 32bit mmio: [0xf4300000-0xf4300fff]
pci 0000:15:00.0: supports D1 D2
pci 0000:15:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:15:00.0: PME# disabled
pci 0000:15:00.1: reg 10 32bit mmio: [0xf4301000-0xf43017ff]
pci 0000:15:00.1: supports D1 D2
pci 0000:15:00.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:15:00.1: PME# disabled
pci 0000:15:00.2: reg 10 32bit mmio: [0xf4301800-0xf43018ff]
pci 0000:15:00.2: supports D1 D2
pci 0000:15:00.2: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:15:00.2: PME# disabled
pci 0000:15:00.3: reg 10 32bit mmio: [0xf4301c00-0xf4301cff]
pci 0000:15:00.3: supports D1 D2
pci 0000:15:00.3: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:15:00.3: PME# disabled
pci 0000:15:00.4: reg 10 32bit mmio: [0xf4302000-0xf43020ff]
pci 0000:15:00.4: supports D1 D2
pci 0000:15:00.4: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:15:00.4: PME# disabled
pci 0000:15:00.5: reg 10 32bit mmio: [0xf4302400-0xf43024ff]
pci 0000:15:00.5: supports D1 D2
pci 0000:15:00.5: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:15:00.5: PME# disabled
pci 0000:00:1e.0: transparent bridge
pci 0000:00:1e.0: bridge io port: [0x5000-0x8fff]
pci 0000:00:1e.0: bridge 32bit mmio: [0xf4300000-0xf7ffffff]
pci 0000:00:1e.0: bridge 64bit mmio pref: [0xf0000000-0xf3ffffff]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: Power Resource [PUBS] (on)
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 comparators, 64-bit 14.318180 MHz counter
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 10 devices
ACPI: ACPI bus type pnp unregistered
system 00:00: iomem range 0x0-0x9ffff could not be reserved
system 00:00: iomem range 0xc0000-0xc3fff has been reserved
system 00:00: iomem range 0xc4000-0xc7fff has been reserved
system 00:00: iomem range 0xc8000-0xcbfff has been reserved
system 00:00: iomem range 0xcc000-0xcffff has been reserved
system 00:00: iomem range 0xd0000-0xd3fff has been reserved
system 00:00: iomem range 0xdc000-0xdffff could not be reserved
system 00:00: iomem range 0xe0000-0xe3fff could not be reserved
system 00:00: iomem range 0xe4000-0xe7fff could not be reserved
system 00:00: iomem range 0xe8000-0xebfff could not be reserved
system 00:00: iomem range 0xec000-0xeffff could not be reserved
system 00:00: iomem range 0xf0000-0xfffff could not be reserved
system 00:00: iomem range 0x100000-0x7effffff could not be reserved
system 00:00: iomem range 0xfec00000-0xfed3ffff could not be reserved
system 00:00: iomem range 0xfed4c000-0xffffffff could not be reserved
system 00:02: ioport range 0x164e-0x164f has been reserved
system 00:02: ioport range 0x1000-0x107f has been reserved
system 00:02: ioport range 0x1180-0x11ff has been reserved
system 00:02: ioport range 0x800-0x80f has been reserved
system 00:02: ioport range 0x15e0-0x15ef has been reserved
system 00:02: ioport range 0x1600-0x1641 has been reserved
system 00:02: ioport range 0x1600-0x161b has been reserved
system 00:02: iomem range 0xe0000000-0xefffffff has been reserved
system 00:02: iomem range 0xfed1c000-0xfed1ffff has been reserved
system 00:02: iomem range 0xfed10000-0xfed13fff has been reserved
system 00:02: iomem range 0xfed18000-0xfed18fff has been reserved
system 00:02: iomem range 0xfed19000-0xfed19fff has been reserved
system 00:02: iomem range 0xfed45000-0xfed4bfff has been reserved
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: 0x2000-0x2fff
pci 0000:00:01.0:   MEM window: 0xcff00000-0xcfffffff
pci 0000:00:01.0:   PREFETCH window: 0x000000d0000000-0x000000dfffffff
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
pci 0000:00:1c.0:   IO window: disabled
pci 0000:00:1c.0:   MEM window: disabled
pci 0000:00:1c.0:   PREFETCH window: disabled
pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
pci 0000:00:1c.1:   IO window: disabled
pci 0000:00:1c.1:   MEM window: 0xf4200000-0xf42fffff
pci 0000:00:1c.1:   PREFETCH window: disabled
pci 0000:00:1c.3: PCI bridge, secondary bus 0000:05
pci 0000:00:1c.3:   IO window: 0x3000-0x3fff
pci 0000:00:1c.3:   MEM window: 0xf8000000-0xf9ffffff
pci 0000:00:1c.3:   PREFETCH window: 0x000000f4000000-0x000000f40fffff
pci 0000:00:1c.4: PCI bridge, secondary bus 0000:0d
pci 0000:00:1c.4:   IO window: 0x4000-0x4fff
pci 0000:00:1c.4:   MEM window: 0xfa000000-0xfbffffff
pci 0000:00:1c.4:   PREFETCH window: 0x000000f4100000-0x000000f41fffff
pci 0000:15:00.0: CardBus bridge, secondary bus 0000:16
pci 0000:15:00.0:   IO window: 0x005000-0x0050ff
pci 0000:15:00.0:   IO window: 0x005400-0x0054ff
pci 0000:15:00.0:   PREFETCH window: 0xf0000000-0xf3ffffff
pci 0000:15:00.0:   MEM window: 0x80000000-0x83ffffff
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:15
pci 0000:00:1e.0:   IO window: 0x5000-0x8fff
pci 0000:00:1e.0:   MEM window: 0xf4300000-0xf7ffffff
pci 0000:00:1e.0:   PREFETCH window: 0x000000f0000000-0x000000f3ffffff
  alloc irq_desc for 16 on cpu 0 node 0
  alloc kstat_irqs on cpu 0 node 0
pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:01.0: setting latency timer to 64
  alloc irq_desc for 20 on cpu 0 node 0
  alloc kstat_irqs on cpu 0 node 0
pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
pci 0000:00:1c.0: setting latency timer to 64
  alloc irq_desc for 21 on cpu 0 node 0
  alloc kstat_irqs on cpu 0 node 0
pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
pci 0000:00:1c.1: setting latency timer to 64
  alloc irq_desc for 23 on cpu 0 node 0
  alloc kstat_irqs on cpu 0 node 0
pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
pci 0000:00:1c.3: setting latency timer to 64
pci 0000:00:1c.4: PCI INT A -> GSI 20 (level, low) -> IRQ 20
pci 0000:00:1c.4: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
pci 0000:15:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
pci_bus 0000:01: resource 0 io:  [0x2000-0x2fff]
pci_bus 0000:01: resource 1 mem: [0xcff00000-0xcfffffff]
pci_bus 0000:01: resource 2 mem: [0xd0000000-0xdfffffff]
pci_bus 0000:01: resource 3 mem: [0x0-0x0]
pci_bus 0000:02: resource 0 mem: [0x0-0x0]
pci_bus 0000:02: resource 1 mem: [0x0-0x0]
pci_bus 0000:02: resource 2 mem: [0x0-0x0]
pci_bus 0000:02: resource 3 mem: [0x0-0x0]
pci_bus 0000:03: resource 0 mem: [0x0-0x0]
pci_bus 0000:03: resource 1 mem: [0xf4200000-0xf42fffff]
pci_bus 0000:03: resource 2 mem: [0x0-0x0]
pci_bus 0000:03: resource 3 mem: [0x0-0x0]
pci_bus 0000:05: resource 0 io:  [0x3000-0x3fff]
pci_bus 0000:05: resource 1 mem: [0xf8000000-0xf9ffffff]
pci_bus 0000:05: resource 2 mem: [0xf4000000-0xf40fffff]
pci_bus 0000:05: resource 3 mem: [0x0-0x0]
pci_bus 0000:0d: resource 0 io:  [0x4000-0x4fff]
pci_bus 0000:0d: resource 1 mem: [0xfa000000-0xfbffffff]
pci_bus 0000:0d: resource 2 mem: [0xf4100000-0xf41fffff]
pci_bus 0000:0d: resource 3 mem: [0x0-0x0]
pci_bus 0000:15: resource 0 io:  [0x5000-0x8fff]
pci_bus 0000:15: resource 1 mem: [0xf4300000-0xf7ffffff]
pci_bus 0000:15: resource 2 mem: [0xf0000000-0xf3ffffff]
pci_bus 0000:15: resource 3 io:  [0x00-0xffff]
pci_bus 0000:15: resource 4 mem: [0x000000-0xffffffffffffffff]
pci_bus 0000:16: resource 0 io:  [0x5000-0x50ff]
pci_bus 0000:16: resource 1 io:  [0x5400-0x54ff]
pci_bus 0000:16: resource 2 mem: [0xf0000000-0xf3ffffff]
pci_bus 0000:16: resource 3 mem: [0x80000000-0x83ffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 10, 4718592 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
NET: Registered protocol family 1
checking if image is initramfs...<7>Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 0
 it is
Freeing initrd memory: 3848k freed
Simple Boot Flag at 0x35 set to 0x1
audit: initializing netlink socket (disabled)
type=2000 audit(1235525831.771:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Created ptmx node in devpts ino 2
msgmni has been set to 3855
SELinux:  Registering netfilter hooks
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
io scheduler noop registered
io scheduler cfq registered (default)
pci 0000:01:00.0: Boot video device
pcieport-driver 0000:00:01.0: setting latency timer to 64
  alloc irq_desc for 24 on cpu 0 node 0
  alloc kstat_irqs on cpu 0 node 0
pcieport-driver 0000:00:01.0: irq 24 for MSI/MSI-X
pcieport-driver 0000:00:1c.0: setting latency timer to 64
  alloc irq_desc for 25 on cpu 0 node 0
  alloc kstat_irqs on cpu 0 node 0
pcieport-driver 0000:00:1c.0: irq 25 for MSI/MSI-X
pcieport-driver 0000:00:1c.1: setting latency timer to 64
  alloc irq_desc for 26 on cpu 0 node 0
  alloc kstat_irqs on cpu 0 node 0
pcieport-driver 0000:00:1c.1: irq 26 for MSI/MSI-X
pcieport-driver 0000:00:1c.3: setting latency timer to 64
  alloc irq_desc for 27 on cpu 0 node 0
  alloc kstat_irqs on cpu 0 node 0
pcieport-driver 0000:00:1c.3: irq 27 for MSI/MSI-X
pcieport-driver 0000:00:1c.4: setting latency timer to 64
  alloc irq_desc for 28 on cpu 0 node 0
  alloc kstat_irqs on cpu 0 node 0
pcieport-driver 0000:00:1c.4: irq 28 for MSI/MSI-X
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
pciehp: Using ACPI for slot detection.
pciehp 0000:00:1c.3:pcie02: HPC vendor_id 8086 device_id 2946 ss_vid 0 ss_did 0
pciehp 0000:00:1c.3:pcie02: service driver pciehp loaded
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
decode_hpp: Could not get hotplug parameters. Use defaults
acpiphp_glue: Slot 1 already registered by another hotplug driver
decode_hpp: Could not get hotplug parameters. Use defaults
acpiphp: Slot [1] registered
ACPI: AC Adapter [AC] (on-line)
ACPI: Battery Slot [BAT0] (battery present)
input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
ACPI: Power Button (FF) [PWRF]
input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
ACPI: Lid Switch [LID]
input: Sleep Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
ACPI: Sleep Button (CM) [SLPB]
ACPI: SSDT 7EA78C20, 02C8 (r1  PmRef  Cpu0Ist     3000 INTL 20050624)
ACPI: SSDT 7EA76020, 087A (r1  PmRef  Cpu0Cst     3001 INTL 20050624)
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-2 state
Monitor-Mwait will be used to enter C-3 state
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
processor ACPI_CPU:00: registered as cooling_device0
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: SSDT 7EA77CA0, 01CF (r1  PmRef    ApIst     3000 INTL 20050624)
ACPI: SSDT 7EA77F20, 008D (r1  PmRef    ApCst     3000 INTL 20050624)
ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
processor ACPI_CPU:01: registered as cooling_device1
ACPI: Processor [CPU1] (supports 8 throttling states)
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [THM0] (44 C)
thermal LNXTHERM:02: registered as thermal_zone1
ACPI: Thermal Zone [THM1] (49 C)
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
brd: module loaded
loop: module loaded
Fixed MDIO Bus: probed
input: Macintosh mouse button emulation as /devices/virtual/input/input3
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
  alloc irq_desc for 29 on cpu 0 node 0
  alloc kstat_irqs on cpu 0 node 0
ahci 0000:00:1f.2: irq 29 for MSI/MSI-X
ahci: SSS flag set, parallel bus scan disabled
ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x3 impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part 
ahci 0000:00:1f.2: setting latency timer to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
ata1: SATA max UDMA/133 abar m2048@0xfc226000 port 0xfc226100 irq 29
ata2: SATA max UDMA/133 abar m2048@0xfc226000 port 0xfc226180 irq 29
ata3: DUMMY
ata4: DUMMY
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
ata1.00: ATA-7: ST9160823AS, 3.CME, max UDMA/100
ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
ata1.00: configured for UDMA/100
ata1.00: configured for UDMA/100
ata1: EH complete
scsi 0:0:0:0: Direct-Access     ATA      ST9160823AS      3.CM PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors: (160 GB/149 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors: (160 GB/149 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
ata2.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
ata2.00: ATAPI: MATSHITADVD-RAM UJ862A, SB01, max UDMA/33
ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
ata2.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
ata2.00: configured for UDMA/33
scsi 1:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ862A   SB01 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
sr 1:0:0:0: Attached scsi generic sg1 type 5
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: debug port 1
ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1a.7: irq 23, io mem 0xfc226c00
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.29-rc6-wl ehci_hcd
usb usb1: SerialNumber: 0000:00:1a.7
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
  alloc irq_desc for 19 on cpu 0 node 0
  alloc kstat_irqs on cpu 0 node 0
ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: irq 19, io mem 0xfc227000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.29-rc6-wl ehci_hcd
usb usb2: SerialNumber: 0000:00:1d.7
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001860
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.29-rc6-wl uhci_hcd
usb usb3: SerialNumber: 0000:00:1a.0
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001880
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.29-rc6-wl uhci_hcd
usb usb4: SerialNumber: 0000:00:1a.1
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
  alloc irq_desc for 22 on cpu 0 node 0
  alloc kstat_irqs on cpu 0 node 0
uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
uhci_hcd 0000:00:1a.2: setting latency timer to 64
uhci_hcd 0000:00:1a.2: UHCI Host Controller
uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1a.2: irq 22, io base 0x000018a0
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.29-rc6-wl uhci_hcd
usb usb5: SerialNumber: 0000:00:1a.2
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.0: irq 16, io base 0x000018c0
usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb6: Product: UHCI Host Controller
usb usb6: Manufacturer: Linux 2.6.29-rc6-wl uhci_hcd
usb usb6: SerialNumber: 0000:00:1d.0
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
  alloc irq_desc for 17 on cpu 0 node 0
  alloc kstat_irqs on cpu 0 node 0
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.1: irq 17, io base 0x000018e0
usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb7: Product: UHCI Host Controller
usb usb7: Manufacturer: Linux 2.6.29-rc6-wl uhci_hcd
usb usb7: SerialNumber: 0000:00:1d.1
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
  alloc irq_desc for 18 on cpu 0 node 0
  alloc kstat_irqs on cpu 0 node 0
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001c00
usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb8: Product: UHCI Host Controller
usb usb8: Manufacturer: Linux 2.6.29-rc6-wl uhci_hcd
usb usb8: SerialNumber: 0000:00:1d.2
usb usb8: configuration #1 chosen from 1 choice
hub 8-0:1.0: USB hub found
hub 8-0:1.0: 2 ports detected
PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
rtc_cmos 00:07: RTC can wake from S4
rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
cpuidle: using governor ladder
cpuidle: using governor menu
Marking TSC unstable due to TSC halts in idle
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
registered taskstats version 1
  Magic number: 13:536:610
Freeing unused kernel memory: 3064k freed
Write protecting the kernel read-only data: 5308k
Clocksource tsc unstable (delta = -79207971 ns)
console_init used greatest stack depth: 5184 bytes left
modprobe used greatest stack depth: 4960 bytes left
usb 1-6: new high speed USB device using ehci_hcd and address 4
rmmod used greatest stack depth: 4704 bytes left
usb 1-6: New USB device found, idVendor=17ef, idProduct=1004
usb 1-6: New USB device strings: Mfr=2, Product=1, SerialNumber=3
usb 1-6: Product: Integrated Camera
usb 1-6: Manufacturer: Chicony Electronics Co., Ltd.
usb 1-6: SerialNumber: SN0001
usb 1-6: configuration #1 chosen from 1 choice
Synaptics Touchpad, model: 1, fw: 7.0, id: 0x1c0b1, caps: 0xd04791/0xb00000
serio: Synaptics pass-through port at isa0060/serio1/input0
input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input5
usb 4-1: new full speed USB device using uhci_hcd and address 2
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
usb 4-1: New USB device found, idVendor=08ff, idProduct=2810
usb 4-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
usb 4-1: Product: Fingerprint Sensor
usb 4-1: configuration #1 chosen from 1 choice
type=1404 audit(1235525833.854:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
usb 4-2: new full speed USB device using uhci_hcd and address 3
SELinux: 8192 avtab hash slots, 112329 rules.
SELinux: 8192 avtab hash slots, 112329 rules.
usb 4-2: New USB device found, idVendor=0a5c, idProduct=2145
usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 4-2: Product: ThinkPad Bluetooth with Enhanced Data Rate II
usb 4-2: Manufacturer: Lenovo Computer Corp
usb 4-2: configuration #1 chosen from 1 choice
SELinux:  8 users, 11 roles, 2579 types, 121 bools, 1 sens, 1024 cats
SELinux:  73 classes, 112329 rules
SELinux:  class kernel_service not defined in policy
SELinux: the above unknown classes and permissions will be allowed
SELinux:  Completing initialization.
SELinux:  Setting up existing superblocks.
SELinux: initialized (dev dm-0, type ext3), uses xattr
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses genfs_contexts
SELinux: initialized (dev devpts, type devpts), uses transition SIDs
SELinux: initialized (dev inotifyfs, type inotifyfs), uses genfs_contexts
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
SELinux: initialized (dev proc, type proc), uses genfs_contexts
SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
type=1403 audit(1235525834.447:3): policy loaded auid=4294967295 ses=4294967295
runlevel used greatest stack depth: 3776 bytes left
mount used greatest stack depth: 2992 bytes left
udevd version 127 started
ACPI: WMI: Mapper loaded
e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
e1000e: Copyright (c) 1999-2008 Intel Corporation.
e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
e1000e 0000:00:19.0: setting latency timer to 64
  alloc irq_desc for 30 on cpu 0 node 0
  alloc kstat_irqs on cpu 0 node 0
e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:1c:25:80:08:c1
0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
0000:00:19.0: eth0: MAC: 6, PHY: 8, PBA No: 1008ff-0ff
acpi device:0a: registered as cooling_device2
input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:08/device:09/input/input6
ACPI: Video Device [VID1] (multi-head: yes  rom: no  post: no)
Bluetooth: Core ver 2.14
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
iTCO_vendor_support: vendor-support=0
Bluetooth: Generic Bluetooth USB driver ver 0.4
usbcore: registered new interface driver btusb
ricoh-mmc: Ricoh MMC Controller disabling driver
ricoh-mmc: Copyright(c) Philip Langdale
ricoh-mmc: Ricoh MMC controller found at 0000:15:00.3 [1180:0843] (rev 11)
ricoh-mmc: Controller is now disabled.
input: PC Speaker as /devices/platform/pcspkr/input/input7
Linux video capture interface: v2.00
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
iTCO_wdt: Found a ICH9M-E TCO device (Version=2, TCOBASE=0x1060)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
cfg80211: Using static regulatory domain info
cfg80211: Regulatory domain: US
	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
cfg80211: Calling CRDA for country: US
i801_smbus 0000:00:1f.3: PCI INT A -> GSI 23 (level, low) -> IRQ 23
yenta_cardbus 0000:15:00.0: CardBus bridge found [17aa:20c6]
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
uvcvideo: Found UVC 1.00 device Integrated Camera (17ef:1004)
input: Integrated Camera as /devices/pci0000:00/0000:00:1a.7/usb1/1-6/1-6:1.0/input/input8
usbcore: registered new interface driver uvcvideo
USB Video Class driver (v0.1.0)
yenta_cardbus 0000:15:00.0: ISA IRQ mask 0x0cb8, PCI irq 16
yenta_cardbus 0000:15:00.0: Socket status: 30000006
yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge I/O window: 0x5000 - 0x8fff
yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge Memory window: 0xf4300000 - 0xf7ffffff
yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge Memory window: 0xf0000000 - 0xf3ffffff
IBM TrackPoint firmware: 0x0e, buttons: 3/3
thinkpad_acpi: ThinkPad ACPI Extras v0.22
thinkpad_acpi: http://ibm-acpi.sf.net/
thinkpad_acpi: ThinkPad BIOS 7UET37WW (1.07 ), EC 7VHT12WW-1.01
thinkpad_acpi: Lenovo ThinkPad T400, model 2767V7U
thinkpad_acpi: radio switch found; radios are enabled
thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
Registered led device: tpacpi::thinklight
Registered led device: tpacpi::power
Registered led device: tpacpi:orange:batt
Registered led device: tpacpi:green:batt
Registered led device: tpacpi::dock_active
Registered led device: tpacpi::bay_active
Registered led device: tpacpi::dock_batt
Registered led device: tpacpi::unknown_led
Registered led device: tpacpi::standby
thinkpad_acpi: Standard ACPI backlight interface available, not loading native one.
input: ThinkPad Extra Buttons as /devices/virtual/input/input9
firewire_ohci 0000:15:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/serio2/input/input10
firewire_ohci: Added fw-ohci device 0000:15:00.1, OHCI version 1.10
sdhci-pci 0000:15:00.2: SDHCI controller found [1180:0822] (rev 21)
sdhci-pci 0000:15:00.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
Registered led device: mmc0::
mmc0: SDHCI controller on PCI [0000:15:00.2] using DMA
firewire_core: created device fw0: GUID 00016c00005f52bd, S400
lib80211: common routines for IEEE802.11 drivers
lib80211_crypt: registered algorithm 'NULL'
iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.3.27kds
iwlagn: Copyright(c) 2003-2009 Intel Corporation
iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
iwlagn 0000:03:00.0: setting latency timer to 64
iwlagn 0000:03:00.0: Detected Intel Wireless WiFi Link 5300AGN REV=0x24
iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
  alloc irq_desc for 31 on cpu 0 node 0
  alloc kstat_irqs on cpu 0 node 0
iwlagn 0000:03:00.0: irq 31 for MSI/MSI-X
phy0: Selected rate control algorithm 'iwl-agn-rs'
HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
HDA Intel 0000:00:1b.0: setting latency timer to 64
input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/input/input11
input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/input/input12
input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/input/input13
device-mapper: multipath: version 1.0.5 loaded
EXT3 FS on dm-0, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
SELinux: initialized (dev sda1, type ext3), uses xattr
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
swap_cgroup: uses 16000 bytes of vmalloc for pointer array space and 8192000 bytes to hold mem_cgroup pointers on swap
swap_cgroup can be disabled by noswapaccount boot option.
Adding 4095992k swap on /dev/mapper/VolGroup00-LogVol01.  Priority:-1 extents:1 across:4095992k 
SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts
platform microcode: firmware: requesting intel-ucode/06-17-06
platform microcode: firmware: requesting intel-ucode/06-17-06
Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
Microcode Update Driver: v2.00 removed.
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ip6_tables: (C) 2000-2006 Netfilter Core Team
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
SELinux: initialized (dev rpc_pipefs, type rpc_pipefs), uses genfs_contexts
Bluetooth: L2CAP ver 2.11
Bluetooth: L2CAP socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.10
Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Bluetooth: BNEP filters: protocol multicast
Bridge firewalling registered
Bluetooth: SCO (Voice Link) ver 0.6
Bluetooth: SCO socket layer initialized
e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
ADDRCONF(NETDEV_UP): eth0: link is not ready
iwlagn 0000:03:00.0: firmware: requesting iwlwifi-5000-1.ucode
iwlagn 0000:03:00.0: loaded firmware version 5.4.1.16
Registered led device: iwl-phy0::radio
Registered led device: iwl-phy0::assoc
Registered led device: iwl-phy0::RX
Registered led device: iwl-phy0::TX
ADDRCONF(NETDEV_UP): wlan0: link is not ready
net/wireless/scan.c 244
(null)
net/wireless/scan.c 427
ffff88006e5254c0 100
net/wireless/scan.c 427
ffff88006e525278 100
net/wireless/scan.c 427
ffff88006ed59950 100
net/wireless/scan.c 427
ffff88006e5254c0 100
net/wireless/scan.c 427
ffff88006ed59b98 100
net/wireless/scan.c 427
ffff88006ed59de0 100
net/wireless/scan.c 427
ffff88006e525278 100
net/wireless/scan.c 427
ffff88006ed59950 100
net/wireless/scan.c 427
ffff88006ed59b98 100
net/wireless/scan.c 427
ffff88006ed59de0 100
net/wireless/scan.c 427
ffff88006ed59b98 100
net/wireless/scan.c 427
ffff88006e525278 100
net/wireless/scan.c 427
ffff88006ed59950 100
net/wireless/scan.c 427
ffff88006ed59b98 100
net/wireless/scan.c 427
ffff88006ed5a028 100
net/wireless/scan.c 427
ffff88006ed59950 100
net/wireless/scan.c 427
ffff88006e525278 100
net/wireless/scan.c 427
ffff88006e5254c0 100
net/wireless/scan.c 427
ffff88006ed59de0 100
net/wireless/scan.c 427
ffff88006ed5a028 100
net/wireless/scan.c 427
ffff88006ed59950 100
net/wireless/scan.c 427
ffff88006e5254c0 100
net/wireless/scan.c 377
ffff88006e5254c0 100
net/wireless/scan.c 427
ffff88006e5254c0 100
net/wireless/scan.c 427
ffff88006ed59de0 100
net/wireless/scan.c 427
ffff88006ed59b98 100
net/wireless/scan.c 427
ffff88006e525278 100
net/wireless/scan.c 427
ffff88006ed5a4b8 100
net/wireless/scan.c 427
ffff88006e525030 100
net/wireless/scan.c 427
ffff88006e524de8 100
net/wireless/scan.c 427
ffff88006e524ba0 100
net/wireless/scan.c 427
ffff88006ed5a4b8 100
net/wireless/scan.c 427
ffff88006e524de8 100
net/wireless/scan.c 427
ffff88006e525030 100
net/wireless/scan.c 377
ffff88006e525030 100
net/wireless/scan.c 427
ffff88006e525030 100
net/wireless/scan.c 427
ffff88006e525278 100
net/wireless/scan.c 427
ffff88006ed59b98 100
net/wireless/scan.c 427
ffff88006ed5a700 100
net/wireless/scan.c 427
ffff88006ed5a948 100
net/wireless/scan.c 427
ffff88006ed5ab90 100
net/wireless/scan.c 427
ffff88006ed59b98 100
net/wireless/scan.c 377
ffff88006ed59b98 100
net/wireless/scan.c 427
ffff88006ed59b98 100
net/wireless/scan.c 427
ffff88006e524ba0 100
net/wireless/scan.c 427
ffff88006ed5add8 100
net/wireless/scan.c 427
ffff88006e525278 100
net/wireless/scan.c 427
ffff88006ed5a270 100
net/wireless/scan.c 427
ffff88006ed5a700 100
net/wireless/scan.c 427
ffff88006e524ba0 100
net/wireless/scan.c 427
ffff88006e525030 100
net/wireless/scan.c 377
ffff88006e525030 100
net/wireless/scan.c 427
ffff88006ed5a700 100
net/wireless/scan.c 377
ffff88006ed5a700 100
net/wireless/scan.c 244
ffff88006ed59de0
wlan0: authenticate with AP 00:18:84:80:c6:b1
net/wireless/scan.c 244
(null)
wlan0: authenticated
wlan0: associate with AP 00:18:84:80:c6:b1
net/wireless/scan.c 244
(null)
net/wireless/scan.c 244
(null)
wlan0: RX AssocResp from 00:18:84:80:c6:b1 (capab=0x421 status=0 aid=1)
wlan0: associated
net/wireless/scan.c 244
(null)
drivers/net/wireless/iwlwifi/iwl-agn.c 643
0
wlan0: disassociating by local choice (reason=3)
net/wireless/scan.c 244
(null)
net/wireless/scan.c 427
ffff88006ed5b020 100
net/wireless/scan.c 377
ffff88006ed5b020 100
net/wireless/scan.c 427
ffff88006ed5a700 100
net/wireless/scan.c 377
ffff88006ed5a700 100
net/wireless/scan.c 427
ffff88006ed5a700 100
net/wireless/scan.c 377
ffff88006ed5a700 100
net/wireless/scan.c 427
ffff88006ed5a700 100
net/wireless/scan.c 377
ffff88006ed5a700 100
net/wireless/scan.c 427
ffff88006ed5a700 100
net/wireless/scan.c 377
ffff88006ed5a700 100
net/wireless/scan.c 427
ffff88006ed5b020 100
net/wireless/scan.c 377
ffff88006ed5b020 100
net/wireless/scan.c 427
ffff88006ed5b020 100
net/wireless/scan.c 377
ffff88006ed5b020 100
net/wireless/scan.c 427
ffff88006ed5b020 100
net/wireless/scan.c 377
ffff88006ed5b020 100
net/wireless/scan.c 427
ffff88006ed5b020 100
net/wireless/scan.c 377
ffff88006ed5b020 100
net/wireless/scan.c 427
ffff88006ed5b020 100
net/wireless/scan.c 377
ffff88006ed5b020 100
net/wireless/scan.c 427
ffff88006ed5b020 100
net/wireless/scan.c 377
ffff88006ed5b020 100
net/wireless/scan.c 427
ffff88006e5244c8 100
net/wireless/scan.c 377
ffff88006e5244c8 100
net/wireless/scan.c 427
ffff88006e524280 100
net/wireless/scan.c 377
ffff88006e524280 100
net/wireless/scan.c 427
ffff88006e525950 100
net/wireless/scan.c 377
ffff88006e525950 100
net/wireless/scan.c 427
ffff88006e525950 100
net/wireless/scan.c 377
ffff88006e525950 100
net/wireless/scan.c 427
ffff88006e525950 100
net/wireless/scan.c 377
ffff88006e525950 100
net/wireless/scan.c 427
ffff88006e525950 100
net/wireless/scan.c 377
ffff88006e525950 100
net/wireless/scan.c 427
ffff88006e525950 100
net/wireless/scan.c 377
ffff88006e525950 100
net/wireless/scan.c 427
ffff88006e525950 100
net/wireless/scan.c 377
ffff88006e525950 100
net/wireless/scan.c 427
ffff88006e525950 100
net/wireless/scan.c 377
ffff88006e525950 100
net/wireless/scan.c 244
(null)
net/wireless/scan.c 427
ffff88006e525950 100
net/wireless/scan.c 377
ffff88006e525950 100
net/wireless/scan.c 427
ffff88006e525950 100
net/wireless/scan.c 377
ffff88006e525950 100
net/wireless/scan.c 427
ffff88006e525950 100
net/wireless/scan.c 377
ffff88006e525950 100
net/wireless/scan.c 427
ffff88006e525950 100
net/wireless/scan.c 377
ffff88006e525950 100
net/wireless/scan.c 427
ffff88006e525950 100
net/wireless/scan.c 377
ffff88006e525950 100
net/wireless/scan.c 427
ffff88006e525950 100
net/wireless/scan.c 377
ffff88006e525950 100
net/wireless/scan.c 427
ffff88006e525950 100
net/wireless/scan.c 377
ffff88006e525950 100
net/wireless/scan.c 427
ffff88006e525950 100
net/wireless/scan.c 377
ffff88006e525950 100
pci 0000:01:00.0: power state changed by ACPI to D0
pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
net/wireless/scan.c 427
ffff88006e525950 100
net/wireless/scan.c 377
ffff88006e525950 100
net/wireless/scan.c 427
ffff88006e525950 100
net/wireless/scan.c 377
ffff88006e525950 100
net/wireless/scan.c 427
ffff88006e525950 100
net/wireless/scan.c 377
ffff88006e525950 100
net/wireless/scan.c 427
ffff88006e525950 100
net/wireless/scan.c 377
ffff88006e525950 100
net/wireless/scan.c 427
ffff88006e525950 100
net/wireless/scan.c 377
ffff88006e525950 100
net/wireless/scan.c 427
ffff88006e525950 100
net/wireless/scan.c 377
ffff88006e525950 100
net/wireless/scan.c 427
ffff88006e525950 100
net/wireless/scan.c 377
ffff88006e525950 100
net/wireless/scan.c 427
ffff88006e525950 100
net/wireless/scan.c 377
ffff88006e525950 100
net/wireless/scan.c 427
ffff88006e525950 100
net/wireless/scan.c 377
ffff88006e525950 100
net/wireless/scan.c 427
ffff88006e525950 100
net/wireless/scan.c 377
ffff88006e525950 100
net/wireless/scan.c 427
ffff88006e525950 100
net/wireless/scan.c 377
ffff88006e525950 100
net/wireless/scan.c 427
ffff88006e525950 100
net/wireless/scan.c 377
ffff88006e525950 100
net/wireless/scan.c 427
ffff88006e525950 100
net/wireless/scan.c 377
ffff88006e525950 100
net/wireless/scan.c 427
ffff88006e525950 100
net/wireless/scan.c 377
ffff88006e525950 100
net/wireless/scan.c 427
ffff88006e525950 100
net/wireless/scan.c 377
ffff88006e525950 100
net/wireless/scan.c 427
ffff88006e525950 100
net/wireless/scan.c 377
ffff88006e525950 100
net/wireless/scan.c 427
ffff88006e525950 100
net/wireless/scan.c 377
ffff88006e525950 100
net/wireless/scan.c 427
ffff88006e525950 100
net/wireless/scan.c 377
ffff88006e525950 100
net/wireless/scan.c 427
ffff88006e525950 100
net/wireless/scan.c 377
ffff88006e525950 100
net/wireless/scan.c 427
ffff88006e525950 100
net/wireless/scan.c 377
ffff88006e525950 100
net/wireless/scan.c 427
ffff88006e525950 100
net/wireless/scan.c 377
ffff88006e525950 100
net/wireless/scan.c 427
ffff88006e525950 100
net/wireless/scan.c 377
ffff88006e525950 100
net/wireless/scan.c 427
ffff88006e525b98 100
net/wireless/scan.c 377
ffff88006e525b98 100
net/wireless/scan.c 427
ffff88006e525950 100
net/wireless/scan.c 377
ffff88006e525950 100
net/wireless/scan.c 427
ffff88006e525950 100
net/wireless/scan.c 377
ffff88006e525950 100
net/wireless/scan.c 427
ffff88006e525950 100
net/wireless/scan.c 377
ffff88006e525950 100
net/wireless/scan.c 427
ffff88006ed5b4b0 100
net/wireless/scan.c 377
ffff88006ed5b4b0 100
net/wireless/scan.c 427
ffff88006ed5b4b0 100
net/wireless/scan.c 377
ffff88006ed5b4b0 100
net/wireless/scan.c 427
ffff88006ed5b4b0 100
net/wireless/scan.c 377
ffff88006ed5b4b0 100
net/wireless/scan.c 427
ffff88006e525950 100
net/wireless/scan.c 377
ffff88006e525950 100
net/wireless/scan.c 427
ffff88006e525950 100
net/wireless/scan.c 377
ffff88006e525950 100
net/wireless/scan.c 427
ffff88006e525b98 100
net/wireless/scan.c 377
ffff88006e525b98 100
net/wireless/scan.c 427
ffff88006e525950 100
net/wireless/scan.c 377
ffff88006e525950 100
net/wireless/scan.c 427
ffff88006e525950 100
net/wireless/scan.c 377
ffff88006e525950 100
net/wireless/scan.c 427
ffff88006e525950 100
net/wireless/scan.c 377
ffff88006e525950 100
net/wireless/scan.c 427
ffff88006e525950 100
net/wireless/scan.c 377
ffff88006e525950 100
net/wireless/scan.c 427
ffff88006e525950 100
net/wireless/scan.c 377
ffff88006e525950 100
net/wireless/scan.c 427
ffff88006e525950 100
net/wireless/scan.c 377
ffff88006e525950 100
net/wireless/scan.c 427
ffff88006e525950 100
net/wireless/scan.c 377
ffff88006e525950 100
net/wireless/scan.c 427
ffff88006e525950 100
net/wireless/scan.c 377
ffff88006e525950 100
net/wireless/scan.c 427
ffff88006e525950 100
net/wireless/scan.c 377
ffff88006e525950 100
net/wireless/scan.c 427
ffff88006e525de0 100
net/wireless/scan.c 377
ffff88006e525de0 100
net/wireless/scan.c 427
ffff88006e525de0 100
net/wireless/scan.c 377
ffff88006e525de0 100
net/wireless/scan.c 427
ffff88006e525de0 100
net/wireless/scan.c 377
ffff88006e525de0 100
net/wireless/scan.c 427
ffff88006e525de0 100
net/wireless/scan.c 377
ffff88006e525de0 100
net/wireless/scan.c 427
ffff88006e525de0 100
net/wireless/scan.c 377
ffff88006e525de0 100
net/wireless/scan.c 427
ffff88006e525de0 100
net/wireless/scan.c 377
ffff88006e525de0 100
net/wireless/scan.c 427
ffff88006e525de0 100
net/wireless/scan.c 377
ffff88006e525de0 100
net/wireless/scan.c 427
ffff88006e525de0 100
net/wireless/scan.c 377
ffff88006e525de0 100
net/wireless/scan.c 427
ffff88006e525de0 100
net/wireless/scan.c 377
ffff88006e525de0 100
net/wireless/scan.c 427
ffff88006ed5b4b0 100
net/wireless/scan.c 377
ffff88006ed5b4b0 100
net/wireless/scan.c 427
ffff88006ed5b4b0 100
net/wireless/scan.c 377
ffff88006ed5b4b0 100
net/wireless/scan.c 427
ffff88006ed5b4b0 100
net/wireless/scan.c 377
ffff88006ed5b4b0 100
net/wireless/scan.c 427
ffff88006ed5b4b0 100
net/wireless/scan.c 377
ffff88006ed5b4b0 100
net/wireless/scan.c 427
ffff88006ed5b4b0 100
net/wireless/scan.c 377
ffff88006ed5b4b0 100
net/wireless/scan.c 427
ffff88006ed5b4b0 100
net/wireless/scan.c 377
ffff88006ed5b4b0 100
net/wireless/scan.c 427
ffff88006ed5b4b0 100
net/wireless/scan.c 377
ffff88006ed5b4b0 100
net/wireless/scan.c 427
ffff88006ed5b4b0 100
net/wireless/scan.c 377
ffff88006ed5b4b0 100
net/wireless/scan.c 427
ffff88006ed5b4b0 100
net/wireless/scan.c 377
ffff88006ed5b4b0 100
net/wireless/scan.c 427
ffff88006ed5b4b0 100
net/wireless/scan.c 377
ffff88006ed5b4b0 100
net/wireless/scan.c 427
ffff88006ed5b4b0 100
net/wireless/scan.c 377
ffff88006ed5b4b0 100
net/wireless/scan.c 427
ffff88006ed5b4b0 100
net/wireless/scan.c 377
ffff88006ed5b4b0 100
net/wireless/scan.c 427
ffff88006ed5b4b0 100
net/wireless/scan.c 377
ffff88006ed5b4b0 100
net/wireless/scan.c 427
ffff88006ed5b4b0 100
net/wireless/scan.c 377
ffff88006ed5b4b0 100
net/wireless/scan.c 427
ffff88006ed5b4b0 100
net/wireless/scan.c 377
ffff88006ed5b4b0 100
net/wireless/scan.c 427
ffff88006ed5b4b0 100
net/wireless/scan.c 377
ffff88006ed5b4b0 100
net/wireless/scan.c 427
ffff88006ed5b4b0 100
net/wireless/scan.c 377
ffff88006ed5b4b0 100
net/wireless/scan.c 427
ffff88006ed5b4b0 100
net/wireless/scan.c 377
ffff88006ed5b4b0 100
net/wireless/scan.c 427
ffff88006ed5b4b0 100
net/wireless/scan.c 377
ffff88006ed5b4b0 100
net/wireless/scan.c 427
ffff88006ed5b4b0 100
net/wireless/scan.c 377
ffff88006ed5b4b0 100
net/wireless/scan.c 427
ffff88006ed5b4b0 100
net/wireless/scan.c 377
ffff88006ed5b4b0 100
net/wireless/scan.c 427
ffff88006ed5b4b0 100
net/wireless/scan.c 377
ffff88006ed5b4b0 100
net/wireless/scan.c 427
ffff88006ed5b4b0 100
net/wireless/scan.c 377
ffff88006ed5b4b0 100
net/wireless/scan.c 427
ffff88006ed5b4b0 100
net/wireless/scan.c 377
ffff88006ed5b4b0 100
net/wireless/scan.c 427
ffff88006ed5b4b0 100
net/wireless/scan.c 377
ffff88006ed5b4b0 100
net/wireless/scan.c 427
ffff88006ed5b4b0 100
net/wireless/scan.c 377
ffff88006ed5b4b0 100
net/wireless/scan.c 427
ffff88006ed5b4b0 100
net/wireless/scan.c 377
ffff88006ed5b4b0 100
net/wireless/scan.c 427
ffff88006ed5b4b0 100
net/wireless/scan.c 377
ffff88006ed5b4b0 100
net/wireless/scan.c 427
ffff88006ed5b4b0 100
net/wireless/scan.c 377
ffff88006ed5b4b0 100
net/wireless/scan.c 427
ffff88006ed5b4b0 100
net/wireless/scan.c 377
ffff88006ed5b4b0 100
net/wireless/scan.c 427
ffff88006ed5b4b0 100
net/wireless/scan.c 377
ffff88006ed5b4b0 100
net/wireless/scan.c 427
ffff88006ed5b4b0 100
net/wireless/scan.c 377
ffff88006ed5b4b0 100
net/wireless/scan.c 427
ffff88006ed5b4b0 100
net/wireless/scan.c 377
ffff88006ed5b4b0 100
net/wireless/scan.c 427
ffff88006ed5b4b0 100
net/wireless/scan.c 377
ffff88006ed5b4b0 100
net/wireless/scan.c 427
ffff88006ed5b4b0 100
net/wireless/scan.c 377
ffff88006ed5b4b0 100
net/wireless/scan.c 427
ffff88006ed5b4b0 100
net/wireless/scan.c 377
ffff88006ed5b4b0 100
net/wireless/scan.c 427
ffff88006ed5b4b0 100
net/wireless/scan.c 377
ffff88006ed5b4b0 100
net/wireless/scan.c 427
ffff88006ed5b4b0 100
net/wireless/scan.c 377
ffff88006ed5b4b0 100
net/wireless/scan.c 427
ffff88006ed5b940 100
net/wireless/scan.c 377
ffff88006ed5b940 100
net/wireless/scan.c 427
ffff88006ed5b940 100
net/wireless/scan.c 377
ffff88006ed5b940 100
net/wireless/scan.c 427
ffff88006ed5b940 100
net/wireless/scan.c 377
ffff88006ed5b940 100
net/wireless/scan.c 427
ffff88006ed5b940 100
net/wireless/scan.c 377
ffff88006ed5b940 100
net/wireless/scan.c 427
ffff88006ed5b940 100
net/wireless/scan.c 377
ffff88006ed5b940 100
net/wireless/scan.c 427
ffff88006e525de0 100
net/wireless/scan.c 377
ffff88006e525de0 100
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
net/wireless/scan.c 427
ffff88006e525de0 100
net/wireless/scan.c 377
ffff88006e525de0 100
net/wireless/scan.c 427
ffff88006e525de0 100
net/wireless/scan.c 377
ffff88006e525de0 100
net/wireless/scan.c 427
ffff88006e525de0 100
net/wireless/scan.c 377
ffff88006e525de0 100
net/wireless/scan.c 427
ffff88006e525de0 100
net/wireless/scan.c 377
ffff88006e525de0 100
net/wireless/scan.c 427
ffff88006e525de0 100
net/wireless/scan.c 377
ffff88006e525de0 100
net/wireless/scan.c 427
ffff88006e525de0 100
net/wireless/scan.c 377
ffff88006e525de0 100
net/wireless/scan.c 427
ffff88006e525de0 100
net/wireless/scan.c 377
ffff88006e525de0 100
net/wireless/scan.c 427
ffff88006e525de0 100
net/wireless/scan.c 377
ffff88006e525de0 100
net/wireless/scan.c 427
ffff88006e525de0 100
net/wireless/scan.c 377
ffff88006e525de0 100
net/wireless/scan.c 427
ffff88006e525de0 100
net/wireless/scan.c 377
ffff88006e525de0 100
net/wireless/scan.c 427
ffff88006e525de0 100
net/wireless/scan.c 377
ffff88006e525de0 100
net/wireless/scan.c 427
ffff88006e525de0 100
net/wireless/scan.c 377
ffff88006e525de0 100
net/wireless/scan.c 427
ffff88006e525de0 100
net/wireless/scan.c 377
ffff88006e525de0 100
net/wireless/scan.c 427
ffff88006e525de0 100
net/wireless/scan.c 377
ffff88006e525de0 100
net/wireless/scan.c 427
ffff88006e525de0 100
net/wireless/scan.c 377
ffff88006e525de0 100
net/wireless/scan.c 427
ffff88006e525de0 100
net/wireless/scan.c 377
ffff88006e525de0 100
net/wireless/scan.c 427
ffff88006e525de0 100
net/wireless/scan.c 377
ffff88006e525de0 100
net/wireless/scan.c 427
ffff88006e525de0 100
net/wireless/scan.c 377
ffff88006e525de0 100
net/wireless/scan.c 427
ffff88006e525de0 100
net/wireless/scan.c 377
ffff88006e525de0 100
net/wireless/scan.c 427
ffff88006e525de0 100
net/wireless/scan.c 377
ffff88006e525de0 100
net/wireless/scan.c 427
ffff88006e525de0 100
net/wireless/scan.c 377
ffff88006e525de0 100
net/wireless/scan.c 427
ffff88006e525de0 100
net/wireless/scan.c 377
ffff88006e525de0 100
net/wireless/scan.c 427
ffff88006e525de0 100
net/wireless/scan.c 377
ffff88006e525de0 100
net/wireless/scan.c 427
ffff88006e526270 100
net/wireless/scan.c 377
ffff88006e526270 100
net/wireless/scan.c 427
ffff88006e526270 100
net/wireless/scan.c 377
ffff88006e526270 100
net/wireless/scan.c 427
ffff88006e526270 100
net/wireless/scan.c 377
ffff88006e526270 100
net/wireless/scan.c 427
ffff88006e526270 100
net/wireless/scan.c 377
ffff88006e526270 100
net/wireless/scan.c 427
ffff88006e526270 100
net/wireless/scan.c 377
ffff88006e526270 100
net/wireless/scan.c 427
ffff88006e526270 100
net/wireless/scan.c 377
ffff88006e526270 100
net/wireless/scan.c 427
ffff88006e526270 100
net/wireless/scan.c 377
ffff88006e526270 100
net/wireless/scan.c 427
ffff88006ed5b940 100
net/wireless/scan.c 377
ffff88006ed5b940 100
net/wireless/scan.c 427
ffff88006ed5b940 100
net/wireless/scan.c 377
ffff88006ed5b940 100
net/wireless/scan.c 427
ffff88006ed5b940 100
net/wireless/scan.c 377
ffff88006ed5b940 100
net/wireless/scan.c 427
ffff88006ed5b940 100
net/wireless/scan.c 377
ffff88006ed5b940 100
net/wireless/scan.c 427
ffff88006ed5b940 100
net/wireless/scan.c 377
ffff88006ed5b940 100
net/wireless/scan.c 427
ffff88006ed5b940 100
net/wireless/scan.c 377
ffff88006ed5b940 100
net/wireless/scan.c 427
ffff88006ed5b940 100
net/wireless/scan.c 377
ffff88006ed5b940 100
net/wireless/scan.c 427
ffff88006ed5b940 100
net/wireless/scan.c 377
ffff88006ed5b940 100
net/wireless/scan.c 427
ffff88006ed5b940 100
net/wireless/scan.c 377
ffff88006ed5b940 100
net/wireless/scan.c 427
ffff88006ed5b940 100
net/wireless/scan.c 377
ffff88006ed5b940 100
net/wireless/scan.c 427
ffff88006ed5b940 100
net/wireless/scan.c 377
ffff88006ed5b940 100
net/wireless/scan.c 427
ffff88006ed5b940 100
net/wireless/scan.c 377
ffff88006ed5b940 100
net/wireless/scan.c 427
ffff88006e526270 100
net/wireless/scan.c 427
ffff88006e5264b8 100
net/wireless/scan.c 377
ffff88006e5264b8 100
net/wireless/scan.c 427
ffff88006ed59950 100
net/wireless/scan.c 427
ffff88006ed5b940 100
net/wireless/scan.c 427
ffff88006e526270 100
net/wireless/scan.c 427
ffff88006ed5bdd0 100
net/wireless/scan.c 427
ffff88006ed5b940 100
net/wireless/scan.c 427
ffff88006ed5bdd0 100
net/wireless/scan.c 427
ffff88006ed59950 100
net/wireless/scan.c 427
ffff88006e526270 100
net/wireless/scan.c 377
ffff88006e526270 100
net/wireless/scan.c 427
ffff88006e526270 100
net/wireless/scan.c 427
ffff88006e5254c0 100
net/wireless/scan.c 427
ffff88006e5264b8 100
net/wireless/scan.c 427
ffff88006e526270 100
net/wireless/scan.c 427
ffff88006e5254c0 100
net/wireless/scan.c 427
ffff88006e5264b8 100
net/wireless/scan.c 427
ffff88006e526270 100
net/wireless/scan.c 377
ffff88006e526270 100
net/wireless/scan.c 427
ffff88006ed59950 100
net/wireless/scan.c 427
ffff88006ed5bdd0 100
net/wireless/scan.c 427
ffff88007be52b90 100
net/wireless/scan.c 377
ffff88007be52b90 100
net/wireless/scan.c 427
ffff88007be52b90 100
net/wireless/scan.c 427
ffff88006e525278 100
net/wireless/scan.c 377
ffff88006e525278 100
net/wireless/scan.c 427
ffff88006bc04038 100
net/wireless/scan.c 427
ffff88006bc04280 100
net/wireless/scan.c 427
ffff88006e525278 100
net/wireless/scan.c 427
ffff88006e5264b8 100
net/wireless/scan.c 427
ffff88006e526270 100
net/wireless/scan.c 427
ffff88006e5264b8 100
net/wireless/scan.c 427
ffff88006e525278 100
net/wireless/scan.c 427
ffff88006e526270 100
net/wireless/scan.c 427
ffff88006e5264b8 100
net/wireless/scan.c 427
ffff88006bc04280 100
net/wireless/scan.c 377
ffff88006bc04280 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006bc04280 100
net/wireless/scan.c 377
ffff88006bc04280 100
net/wireless/scan.c 427
ffff88006bc04280 100
net/wireless/scan.c 377
ffff88006bc04280 100
net/wireless/scan.c 427
ffff88006bc04280 100
net/wireless/scan.c 377
ffff88006bc04280 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006bc04280 100
net/wireless/scan.c 377
ffff88006bc04280 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006bc04280 100
net/wireless/scan.c 377
ffff88006bc04280 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006bc04280 100
net/wireless/scan.c 377
ffff88006bc04280 100
net/wireless/scan.c 427
ffff88006bc04280 100
net/wireless/scan.c 377
ffff88006bc04280 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006bc04280 100
net/wireless/scan.c 377
ffff88006bc04280 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006bc04280 100
net/wireless/scan.c 377
ffff88006bc04280 100
net/wireless/scan.c 427
ffff88006bc04280 100
net/wireless/scan.c 377
ffff88006bc04280 100
net/wireless/scan.c 427
ffff88006bc04280 100
net/wireless/scan.c 377
ffff88006bc04280 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006bc04280 100
net/wireless/scan.c 377
ffff88006bc04280 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006bc04280 100
net/wireless/scan.c 377
ffff88006bc04280 100
net/wireless/scan.c 427
ffff88006bc04280 100
net/wireless/scan.c 377
ffff88006bc04280 100
net/wireless/scan.c 427
ffff88006bc04280 100
net/wireless/scan.c 377
ffff88006bc04280 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006bc04280 100
net/wireless/scan.c 427
ffff88006bc04038 100
net/wireless/scan.c 427
ffff88006bc04280 100
net/wireless/scan.c 377
ffff88006bc04280 100
net/wireless/scan.c 427
ffff88006bc04280 100
net/wireless/scan.c 427
ffff88006e5264b8 100
net/wireless/scan.c 377
ffff88006e5264b8 100
net/wireless/scan.c 427
ffff88006bc044c8 100
net/wireless/scan.c 427
ffff88006bc04038 100
net/wireless/scan.c 427
ffff88006bc04280 100
net/wireless/scan.c 377
ffff88006bc04280 100
net/wireless/scan.c 427
ffff88006e5264b8 100
net/wireless/scan.c 427
ffff88006e525278 100
net/wireless/scan.c 377
ffff88006e525278 100
net/wireless/scan.c 427
ffff88006bc04280 100
net/wireless/scan.c 427
ffff88006e525278 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006e526948 100
net/wireless/scan.c 427
ffff88006e5264b8 100
net/wireless/scan.c 427
ffff88006e526948 100
net/wireless/scan.c 427
ffff88006e525278 100
net/wireless/scan.c 427
ffff88006bc04280 100
net/wireless/scan.c 427
ffff88006e526948 100
net/wireless/scan.c 427
ffff88006e526b90 100
net/wireless/scan.c 377
ffff88006e526b90 100
net/wireless/scan.c 427
ffff88006e526b90 100
net/wireless/scan.c 377
ffff88006e526b90 100
net/wireless/scan.c 427
ffff88006bc04280 100
net/wireless/scan.c 377
ffff88006bc04280 100
net/wireless/scan.c 427
ffff88006e526b90 100
net/wireless/scan.c 377
ffff88006e526b90 100
net/wireless/scan.c 427
ffff88006e526b90 100
net/wireless/scan.c 377
ffff88006e526b90 100
net/wireless/scan.c 427
ffff88006e526b90 100
net/wireless/scan.c 377
ffff88006e526b90 100
net/wireless/scan.c 427
ffff88006e526b90 100
net/wireless/scan.c 377
ffff88006e526b90 100
net/wireless/scan.c 427
ffff88006e526b90 100
net/wireless/scan.c 377
ffff88006e526b90 100
net/wireless/scan.c 427
ffff88006bc04280 100
net/wireless/scan.c 377
ffff88006bc04280 100
net/wireless/scan.c 427
ffff88006bc04280 100
net/wireless/scan.c 377
ffff88006bc04280 100
net/wireless/scan.c 427
ffff88006e526b90 100
net/wireless/scan.c 377
ffff88006e526b90 100
net/wireless/scan.c 427
ffff88006bc04280 100
net/wireless/scan.c 377
ffff88006bc04280 100
net/wireless/scan.c 427
ffff88006bc04280 100
net/wireless/scan.c 377
ffff88006bc04280 100
net/wireless/scan.c 427
ffff88006bc04280 100
net/wireless/scan.c 377
ffff88006bc04280 100
net/wireless/scan.c 427
ffff88006bc04280 100
net/wireless/scan.c 377
ffff88006bc04280 100
net/wireless/scan.c 427
ffff88006bc04280 100
net/wireless/scan.c 377
ffff88006bc04280 100
net/wireless/scan.c 427
ffff88006e526b90 100
net/wireless/scan.c 377
ffff88006e526b90 100
net/wireless/scan.c 427
ffff88006bc04280 100
net/wireless/scan.c 377
ffff88006bc04280 100
net/wireless/scan.c 427
ffff88006e525b98 100
net/wireless/scan.c 377
ffff88006e525b98 100
net/wireless/scan.c 427
ffff88006bc04280 100
net/wireless/scan.c 377
ffff88006bc04280 100
net/wireless/scan.c 427
ffff88006e525b98 100
net/wireless/scan.c 377
ffff88006e525b98 100
net/wireless/scan.c 427
ffff88006bc04280 100
net/wireless/scan.c 377
ffff88006bc04280 100
net/wireless/scan.c 427
ffff88006bc04958 100
net/wireless/scan.c 377
ffff88006bc04958 100
net/wireless/scan.c 427
ffff88006bc04958 100
net/wireless/scan.c 377
ffff88006bc04958 100
net/wireless/scan.c 427
ffff88006e525b98 100
net/wireless/scan.c 377
ffff88006e525b98 100
net/wireless/scan.c 427
ffff88006bc04958 100
net/wireless/scan.c 377
ffff88006bc04958 100
fuse init (API version 7.11)
net/wireless/scan.c 427
ffff88006bc04958 100
net/wireless/scan.c 377
ffff88006bc04958 100
SELinux: initialized (dev fuse, type fuse), uses genfs_contexts
net/wireless/scan.c 427
ffff88006bc04958 100
net/wireless/scan.c 377
ffff88006bc04958 100
net/wireless/scan.c 427
ffff88006e525de0 100
net/wireless/scan.c 377
ffff88006e525de0 100
net/wireless/scan.c 427
ffff88006e525de0 100
net/wireless/scan.c 377
ffff88006e525de0 100
net/wireless/scan.c 427
ffff88006e525de0 100
net/wireless/scan.c 377
ffff88006e525de0 100
net/wireless/scan.c 427
ffff88006bc04958 100
net/wireless/scan.c 377
ffff88006bc04958 100
net/wireless/scan.c 427
ffff88006e526dd8 100
net/wireless/scan.c 377
ffff88006e526dd8 100
net/wireless/scan.c 427
ffff88006bc04958 100
net/wireless/scan.c 377
ffff88006bc04958 100
net/wireless/scan.c 427
ffff88006bc04958 100
net/wireless/scan.c 377
ffff88006bc04958 100
net/wireless/scan.c 427
ffff88006e526dd8 100
net/wireless/scan.c 377
ffff88006e526dd8 100
net/wireless/scan.c 427
ffff88006e526dd8 100
net/wireless/scan.c 377
ffff88006e526dd8 100
net/wireless/scan.c 427
ffff88006e526dd8 100
net/wireless/scan.c 377
ffff88006e526dd8 100
net/wireless/scan.c 427
ffff88006bc04958 100
net/wireless/scan.c 377
ffff88006bc04958 100
net/wireless/scan.c 427
ffff88006bc04958 100
net/wireless/scan.c 377
ffff88006bc04958 100
net/wireless/scan.c 427
ffff88006e526dd8 100
net/wireless/scan.c 377
ffff88006e526dd8 100
net/wireless/scan.c 427
ffff88006bc04958 100
net/wireless/scan.c 377
ffff88006bc04958 100
net/wireless/scan.c 427
ffff88006e526dd8 100
net/wireless/scan.c 377
ffff88006e526dd8 100
net/wireless/scan.c 427
ffff88006e526dd8 100
net/wireless/scan.c 377
ffff88006e526dd8 100
net/wireless/scan.c 427
ffff88006bc04958 100
net/wireless/scan.c 377
ffff88006bc04958 100
net/wireless/scan.c 427
ffff88006bc04958 100
net/wireless/scan.c 377
ffff88006bc04958 100
net/wireless/scan.c 427
ffff88006e526dd8 100
net/wireless/scan.c 377
ffff88006e526dd8 100
net/wireless/scan.c 427
ffff88006bc04958 100
net/wireless/scan.c 377
ffff88006bc04958 100
net/wireless/scan.c 427
ffff88006e526dd8 100
net/wireless/scan.c 377
ffff88006e526dd8 100
net/wireless/scan.c 427
ffff88006bc04958 100
net/wireless/scan.c 377
ffff88006bc04958 100
net/wireless/scan.c 427
ffff88006bc04958 100
net/wireless/scan.c 377
ffff88006bc04958 100
net/wireless/scan.c 427
ffff88006e526dd8 100
net/wireless/scan.c 377
ffff88006e526dd8 100
net/wireless/scan.c 427
ffff88006e526dd8 100
net/wireless/scan.c 377
ffff88006e526dd8 100
net/wireless/scan.c 427
ffff88006bc04958 100
net/wireless/scan.c 377
ffff88006bc04958 100
net/wireless/scan.c 427
ffff88006bc04958 100
net/wireless/scan.c 377
ffff88006bc04958 100
net/wireless/scan.c 427
ffff88006bc04958 100
net/wireless/scan.c 377
ffff88006bc04958 100
net/wireless/scan.c 427
ffff88006bc04958 100
net/wireless/scan.c 377
ffff88006bc04958 100
net/wireless/scan.c 427
ffff88006e526dd8 100
net/wireless/scan.c 377
ffff88006e526dd8 100
net/wireless/scan.c 427
ffff88006e526dd8 100
net/wireless/scan.c 377
ffff88006e526dd8 100
net/wireless/scan.c 427
ffff88006e526dd8 100
net/wireless/scan.c 377
ffff88006e526dd8 100
net/wireless/scan.c 427
ffff88006bc04958 100
net/wireless/scan.c 377
ffff88006bc04958 100
net/wireless/scan.c 427
ffff88006bc04958 100
net/wireless/scan.c 377
ffff88006bc04958 100
net/wireless/scan.c 427
ffff88006bc04de8 100
net/wireless/scan.c 377
ffff88006bc04de8 100
net/wireless/scan.c 427
ffff88006bc04de8 100
net/wireless/scan.c 377
ffff88006bc04de8 100
net/wireless/scan.c 427
ffff88006bc05278 100
net/wireless/scan.c 377
ffff88006bc05278 100
net/wireless/scan.c 427
ffff88006e526dd8 100
net/wireless/scan.c 377
ffff88006e526dd8 100
net/wireless/scan.c 427
ffff88006bc05278 100
net/wireless/scan.c 377
ffff88006bc05278 100
net/wireless/scan.c 427
ffff88006bc05278 100
net/wireless/scan.c 377
ffff88006bc05278 100
net/wireless/scan.c 427
ffff88006bc05278 100
net/wireless/scan.c 377
ffff88006bc05278 100
net/wireless/scan.c 427
ffff88006bc05278 100
net/wireless/scan.c 377
ffff88006bc05278 100
net/wireless/scan.c 427
ffff88006bc05278 100
net/wireless/scan.c 377
ffff88006bc05278 100
net/wireless/scan.c 427
ffff88006e526dd8 100
net/wireless/scan.c 377
ffff88006e526dd8 100
net/wireless/scan.c 427
ffff88006e526dd8 100
net/wireless/scan.c 377
ffff88006e526dd8 100
net/wireless/scan.c 427
ffff88006e526dd8 100
net/wireless/scan.c 377
ffff88006e526dd8 100
net/wireless/scan.c 427
ffff88006bc05278 100
net/wireless/scan.c 377
ffff88006bc05278 100
net/wireless/scan.c 427
ffff88006e526dd8 100
net/wireless/scan.c 377
ffff88006e526dd8 100
net/wireless/scan.c 427
ffff88006bc05278 100
net/wireless/scan.c 377
ffff88006bc05278 100
net/wireless/scan.c 427
ffff88006e526dd8 100
net/wireless/scan.c 377
ffff88006e526dd8 100
net/wireless/scan.c 427
ffff88006e526dd8 100
net/wireless/scan.c 377
ffff88006e526dd8 100
net/wireless/scan.c 427
ffff88006bc05278 100
net/wireless/scan.c 377
ffff88006bc05278 100
net/wireless/scan.c 427
ffff88006e526dd8 100
net/wireless/scan.c 377
ffff88006e526dd8 100
net/wireless/scan.c 427
ffff88006bc05278 100
net/wireless/scan.c 377
ffff88006bc05278 100
net/wireless/scan.c 427
ffff88006bc05278 100
net/wireless/scan.c 377
ffff88006bc05278 100
net/wireless/scan.c 427
ffff88006e527020 100
net/wireless/scan.c 377
ffff88006e527020 100
net/wireless/scan.c 427
ffff88006bc05278 100
net/wireless/scan.c 377
ffff88006bc05278 100
net/wireless/scan.c 427
ffff88006bc05278 100
net/wireless/scan.c 377
ffff88006bc05278 100
net/wireless/scan.c 427
ffff88006bc05278 100
net/wireless/scan.c 377
ffff88006bc05278 100
net/wireless/scan.c 427
ffff88006e527020 100
net/wireless/scan.c 377
ffff88006e527020 100
net/wireless/scan.c 427
ffff88006e527020 100
net/wireless/scan.c 377
ffff88006e527020 100
wlan0: deauthenticated (Reason: 6)
net/wireless/scan.c 427
ffff88006bc054c0 100
net/wireless/scan.c 377
ffff88006bc054c0 100
net/wireless/scan.c 427
ffff88006bc054c0 100
net/wireless/scan.c 377
ffff88006bc054c0 100
net/wireless/scan.c 427
ffff88006bc054c0 100
net/wireless/scan.c 377
ffff88006bc054c0 100
net/wireless/scan.c 427
ffff88006bc054c0 100
net/wireless/scan.c 377
ffff88006bc054c0 100
net/wireless/scan.c 427
ffff88006bc054c0 100
net/wireless/scan.c 377
ffff88006bc054c0 100
net/wireless/scan.c 427
ffff88006bc054c0 100
net/wireless/scan.c 377
ffff88006bc054c0 100
net/wireless/scan.c 427
ffff88006bc054c0 100
net/wireless/scan.c 377
ffff88006bc054c0 100
net/wireless/scan.c 427
ffff88006bc054c0 100
net/wireless/scan.c 377
ffff88006bc054c0 100
net/wireless/scan.c 427
ffff88006bc05708 100
net/wireless/scan.c 377
ffff88006bc05708 100
net/wireless/scan.c 427
ffff88006bc05708 100
net/wireless/scan.c 377
ffff88006bc05708 100
net/wireless/scan.c 427
ffff88006bc05708 100
net/wireless/scan.c 377
ffff88006bc05708 100
net/wireless/scan.c 427
ffff88006bc05708 100
net/wireless/scan.c 377
ffff88006bc05708 100
net/wireless/scan.c 427
ffff88006bc05708 100
net/wireless/scan.c 377
ffff88006bc05708 100
net/wireless/scan.c 427
ffff88006bc05b98 100
net/wireless/scan.c 377
ffff88006bc05b98 100
net/wireless/scan.c 427
ffff88006bc05b98 100
net/wireless/scan.c 377
ffff88006bc05b98 100
net/wireless/scan.c 427
ffff88006bc05b98 100
net/wireless/scan.c 377
ffff88006bc05b98 100
net/wireless/scan.c 427
ffff88006bc05b98 100
net/wireless/scan.c 377
ffff88006bc05b98 100
net/wireless/scan.c 427
ffff88006bc05b98 100
net/wireless/scan.c 377
ffff88006bc05b98 100
net/wireless/scan.c 427
ffff88006bc05b98 100
net/wireless/scan.c 377
ffff88006bc05b98 100
net/wireless/scan.c 427
ffff88006e527020 100
net/wireless/scan.c 377
ffff88006e527020 100
net/wireless/scan.c 427
ffff88006e5276f8 100
net/wireless/scan.c 377
ffff88006e5276f8 100
net/wireless/scan.c 427
ffff88006e5276f8 100
net/wireless/scan.c 377
ffff88006e5276f8 100
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
net/wireless/scan.c 427
ffff88006e527b88 100
net/wireless/scan.c 377
ffff88006e527b88 100
net/wireless/scan.c 427
ffff88006e527b88 100
net/wireless/scan.c 377
ffff88006e527b88 100
net/wireless/scan.c 427
ffff88006e527b88 100
net/wireless/scan.c 377
ffff88006e527b88 100
net/wireless/scan.c 427
ffff88006e527b88 100
net/wireless/scan.c 377
ffff88006e527b88 100
net/wireless/scan.c 427
ffff88006e527b88 100
net/wireless/scan.c 377
ffff88006e527b88 100
net/wireless/scan.c 427
ffff88006e527b88 100
net/wireless/scan.c 377
ffff88006e527b88 100
net/wireless/scan.c 427
ffff88006e527b88 100
net/wireless/scan.c 377
ffff88006e527b88 100
net/wireless/scan.c 427
ffff88006e527b88 100
net/wireless/scan.c 377
ffff88006e527b88 100
net/wireless/scan.c 427
ffff88006e527b88 100
net/wireless/scan.c 377
ffff88006e527b88 100
net/wireless/scan.c 427
ffff88006e527b88 100
net/wireless/scan.c 377
ffff88006e527b88 100
net/wireless/scan.c 427
ffff88006bc06028 100
net/wireless/scan.c 377
ffff88006bc06028 100
net/wireless/scan.c 427
ffff88006bc06028 100
net/wireless/scan.c 377
ffff88006bc06028 100
net/wireless/scan.c 427
ffff88006bc06028 100
net/wireless/scan.c 377
ffff88006bc06028 100
net/wireless/scan.c 427
ffff88006bc06028 100
net/wireless/scan.c 377
ffff88006bc06028 100
net/wireless/scan.c 427
ffff88006bc06028 100
net/wireless/scan.c 377
ffff88006bc06028 100
net/wireless/scan.c 427
ffff88006bc064b8 100
net/wireless/scan.c 377
ffff88006bc064b8 100
net/wireless/scan.c 427
ffff88006bc064b8 100
net/wireless/scan.c 377
ffff88006bc064b8 100
net/wireless/scan.c 427
ffff88006bc064b8 100
net/wireless/scan.c 377
ffff88006bc064b8 100
net/wireless/scan.c 427
ffff88006bc064b8 100
net/wireless/scan.c 377
ffff88006bc064b8 100
net/wireless/scan.c 427
ffff88006bc064b8 100
net/wireless/scan.c 377
ffff88006bc064b8 100
net/wireless/scan.c 427
ffff88006bc064b8 100
net/wireless/scan.c 377
ffff88006bc064b8 100
net/wireless/scan.c 427
ffff88006bc064b8 100
net/wireless/scan.c 377
ffff88006bc064b8 100
net/wireless/scan.c 427
ffff88006bc064b8 100
net/wireless/scan.c 377
ffff88006bc064b8 100
net/wireless/scan.c 427
ffff88006bc064b8 100
net/wireless/scan.c 377
ffff88006bc064b8 100
net/wireless/scan.c 427
ffff88006bc064b8 100
net/wireless/scan.c 377
ffff88006bc064b8 100
net/wireless/scan.c 427
ffff88006bc064b8 100
net/wireless/scan.c 377
ffff88006bc064b8 100
net/wireless/scan.c 427
ffff88006bc064b8 100
net/wireless/scan.c 377
ffff88006bc064b8 100
net/wireless/scan.c 427
ffff88006ed5b4b0 100
net/wireless/scan.c 427
ffff88006ed5b6f8 100
net/wireless/scan.c 427
ffff88006ed5b4b0 100
net/wireless/scan.c 427
ffff88006bc064b8 100
net/wireless/scan.c 427
ffff88006ed5add8 100
net/wireless/scan.c 427
ffff88006bc06948 100
net/wireless/scan.c 427
ffff88006bc064b8 100
net/wireless/scan.c 427
ffff88006bc06b90 100
net/wireless/scan.c 427
ffff88006bc064b8 100
net/wireless/scan.c 427
ffff88006bc06b90 100
net/wireless/scan.c 427
ffff88006ed5a270 100
net/wireless/scan.c 427
ffff88006bc06b90 100
net/wireless/scan.c 427
ffff88006ed5add8 100
net/wireless/scan.c 427
ffff88006bc06948 100
net/wireless/scan.c 427
ffff88006ed5a270 100
net/wireless/scan.c 427
ffff88006bc06b90 100
net/wireless/scan.c 427
ffff88006ed5add8 100
net/wireless/scan.c 377
ffff88006ed5add8 100
net/wireless/scan.c 427
ffff88006bc064b8 100
net/wireless/scan.c 427
ffff88006ed5a270 100
net/wireless/scan.c 427
ffff88006bc06b90 100
net/wireless/scan.c 427
ffff88006bc06dd8 100
net/wireless/scan.c 427
ffff88006ed5add8 100
net/wireless/scan.c 427
ffff88006ed5b6f8 100
net/wireless/scan.c 427
ffff88006ed5add8 100
net/wireless/scan.c 427
ffff88006ed5a270 100
net/wireless/scan.c 427
ffff88006bc064b8 100
net/wireless/scan.c 377
ffff88006bc064b8 100
net/wireless/scan.c 427
ffff88006bc064b8 100
net/wireless/scan.c 427
ffff88006bc06b90 100
net/wireless/scan.c 427
ffff88006bc07020 100
net/wireless/scan.c 427
ffff88006bc064b8 100
net/wireless/scan.c 427
ffff88006ed5add8 100
net/wireless/scan.c 427
ffff88006ed5b4b0 100
net/wireless/scan.c 427
ffff88006bc064b8 100
net/wireless/scan.c 427
ffff88007be52b90 100
net/wireless/scan.c 427
ffff88006bc06b90 100
net/wireless/scan.c 427
ffff88007be52b90 100
net/wireless/scan.c 427
ffff88006bc07020 100
net/wireless/scan.c 427
ffff88006bc07268 100
net/wireless/scan.c 427
ffff88007be52b90 100
net/wireless/scan.c 377
ffff88007be52b90 100
net/wireless/scan.c 427
ffff88007be52b90 100
net/wireless/scan.c 377
ffff88007be52b90 100
net/wireless/scan.c 427
ffff88006bc064b8 100
net/wireless/scan.c 377
ffff88006bc064b8 100
net/wireless/scan.c 427
ffff88006bc064b8 100
net/wireless/scan.c 377
ffff88006bc064b8 100
net/wireless/scan.c 427
ffff88007be52b90 100
net/wireless/scan.c 377
ffff88007be52b90 100
net/wireless/scan.c 427
ffff88006bc064b8 100
net/wireless/scan.c 377
ffff88006bc064b8 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006bc064b8 100
net/wireless/scan.c 377
ffff88006bc064b8 100
net/wireless/scan.c 427
ffff88006bc064b8 100
net/wireless/scan.c 377
ffff88006bc064b8 100
net/wireless/scan.c 427
ffff88006bc064b8 100
net/wireless/scan.c 377
ffff88006bc064b8 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006bc064b8 100
net/wireless/scan.c 377
ffff88006bc064b8 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006bc064b8 100
net/wireless/scan.c 377
ffff88006bc064b8 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006bc064b8 100
net/wireless/scan.c 377
ffff88006bc064b8 100
net/wireless/scan.c 427
ffff88006bc064b8 100
net/wireless/scan.c 377
ffff88006bc064b8 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006bc064b8 100
net/wireless/scan.c 377
ffff88006bc064b8 100
net/wireless/scan.c 427
ffff88006bc064b8 100
net/wireless/scan.c 377
ffff88006bc064b8 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006bc064b8 100
net/wireless/scan.c 377
ffff88006bc064b8 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006bc064b8 100
net/wireless/scan.c 377
ffff88006bc064b8 100
net/wireless/scan.c 427
ffff88006bc064b8 100
net/wireless/scan.c 377
ffff88006bc064b8 100
net/wireless/scan.c 427
ffff88006bc064b8 100
net/wireless/scan.c 377
ffff88006bc064b8 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006bc064b8 100
net/wireless/scan.c 377
ffff88006bc064b8 100
net/wireless/scan.c 427
ffff88006bc064b8 100
net/wireless/scan.c 377
ffff88006bc064b8 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006bc064b8 100
net/wireless/scan.c 377
ffff88006bc064b8 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006bc064b8 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006e5264b8 100
net/wireless/scan.c 427
ffff88006e525278 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006bc07020 100
net/wireless/scan.c 427
ffff88006bc064b8 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006e525278 100
net/wireless/scan.c 427
ffff88006e5264b8 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006e5264b8 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006e5264b8 100
net/wireless/scan.c 377
ffff88006e5264b8 100
net/wireless/scan.c 427
ffff88006bc06b90 100
net/wireless/scan.c 427
ffff88006bc07020 100
net/wireless/scan.c 427
ffff88006bc07268 100
net/wireless/scan.c 427
ffff88006bc06b90 100
net/wireless/scan.c 427
ffff88006e525278 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006e5264b8 100
net/wireless/scan.c 427
ffff88006ed5b4b0 100
net/wireless/scan.c 427
ffff88006ed5add8 100
net/wireless/scan.c 427
ffff88006bc07020 100
net/wireless/scan.c 427
ffff88006ed5add8 100
net/wireless/scan.c 377
ffff88006ed5add8 100
net/wireless/scan.c 427
ffff88006ed5add8 100
net/wireless/scan.c 427
ffff88006ed5b4b0 100
net/wireless/scan.c 427
ffff88007be52b90 100
net/wireless/scan.c 427
ffff88006bc07020 100
net/wireless/scan.c 427
ffff88006e525278 100
net/wireless/scan.c 377
ffff88006e525278 100
net/wireless/scan.c 427
ffff88006e525278 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006ed5b4b0 100
net/wireless/scan.c 427
ffff88006ed5add8 100
net/wireless/scan.c 427
ffff88006e525278 100
net/wireless/scan.c 427
ffff88006ed5add8 100
net/wireless/scan.c 427
ffff88006bc06b90 100
net/wireless/scan.c 427
ffff88006bc07268 100
net/wireless/scan.c 427
ffff88006ed5b4b0 100
net/wireless/scan.c 427
ffff88006bc06b90 100
net/wireless/scan.c 427
ffff88006bc074b0 100
net/wireless/scan.c 427
ffff88006bc06b90 100
net/wireless/scan.c 377
ffff88006bc06b90 100
net/wireless/scan.c 427
ffff88006ed5add8 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006bc07268 100
net/wireless/scan.c 377
ffff88006bc07268 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006bc07268 100
net/wireless/scan.c 377
ffff88006bc07268 100
net/wireless/scan.c 427
ffff88006bc07268 100
net/wireless/scan.c 377
ffff88006bc07268 100
net/wireless/scan.c 427
ffff88006bc07268 100
net/wireless/scan.c 377
ffff88006bc07268 100
net/wireless/scan.c 427
ffff88006bc07268 100
net/wireless/scan.c 377
ffff88006bc07268 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006bc07268 100
net/wireless/scan.c 377
ffff88006bc07268 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006bc07268 100
net/wireless/scan.c 377
ffff88006bc07268 100
net/wireless/scan.c 427
ffff88006bc07268 100
net/wireless/scan.c 377
ffff88006bc07268 100
net/wireless/scan.c 427
ffff88006bc07268 100
net/wireless/scan.c 377
ffff88006bc07268 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006bc07268 100
net/wireless/scan.c 377
ffff88006bc07268 100
net/wireless/scan.c 427
ffff88006bc07268 100
net/wireless/scan.c 377
ffff88006bc07268 100
net/wireless/scan.c 427
ffff88006bc07268 100
net/wireless/scan.c 377
ffff88006bc07268 100
net/wireless/scan.c 427
ffff88006bc07268 100
net/wireless/scan.c 377
ffff88006bc07268 100
net/wireless/scan.c 427
ffff88006bc07268 100
net/wireless/scan.c 377
ffff88006bc07268 100
net/wireless/scan.c 427
ffff88006bc07268 100
net/wireless/scan.c 377
ffff88006bc07268 100
net/wireless/scan.c 427
ffff88006bc07268 100
net/wireless/scan.c 377
ffff88006bc07268 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006bc07268 100
net/wireless/scan.c 377
ffff88006bc07268 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006bc07268 100
net/wireless/scan.c 377
ffff88006bc07268 100
net/wireless/scan.c 427
ffff88006bc07268 100
net/wireless/scan.c 377
ffff88006bc07268 100
net/wireless/scan.c 427
ffff88006bc07268 100
net/wireless/scan.c 377
ffff88006bc07268 100
net/wireless/scan.c 427
ffff88006bc07268 100
net/wireless/scan.c 377
ffff88006bc07268 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006bc07268 100
net/wireless/scan.c 377
ffff88006bc07268 100
net/wireless/scan.c 427
ffff88006bc07268 100
net/wireless/scan.c 377
ffff88006bc07268 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006bc07268 100
net/wireless/scan.c 377
ffff88006bc07268 100
net/wireless/scan.c 427
ffff88006bc07268 100
net/wireless/scan.c 377
ffff88006bc07268 100
net/wireless/scan.c 427
ffff88006bc07268 100
net/wireless/scan.c 377
ffff88006bc07268 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006bc07268 100
net/wireless/scan.c 377
ffff88006bc07268 100
net/wireless/scan.c 427
ffff88006e526700 100
net/wireless/scan.c 377
ffff88006e526700 100
net/wireless/scan.c 427
ffff88006e525278 100
net/wireless/scan.c 377
ffff88006e525278 100
net/wireless/scan.c 427
ffff88006bc07b88 100
net/wireless/scan.c 377
ffff88006bc07b88 100
net/wireless/scan.c 427
ffff88006bc07b88 100
net/wireless/scan.c 377
ffff88006bc07b88 100
net/wireless/scan.c 427
ffff88006bc07b88 100
net/wireless/scan.c 377
ffff88006bc07b88 100
net/wireless/scan.c 427
ffff88006bc07b88 100
net/wireless/scan.c 377
ffff88006bc07b88 100
net/wireless/scan.c 427
ffff88006bc07dd0 100
net/wireless/scan.c 377
ffff88006bc07dd0 100
net/wireless/scan.c 427
ffff88006bc07dd0 100
net/wireless/scan.c 377
ffff88006bc07dd0 100
net/wireless/scan.c 427
ffff88005a7c8038 100
net/wireless/scan.c 377
ffff88005a7c8038 100
net/wireless/scan.c 427
ffff88005a7c8038 100
net/wireless/scan.c 377
ffff88005a7c8038 100
net/wireless/scan.c 427
ffff88006bc07dd0 100
net/wireless/scan.c 377
ffff88006bc07dd0 100
net/wireless/scan.c 427
ffff88006bc07dd0 100
net/wireless/scan.c 377
ffff88006bc07dd0 100
net/wireless/scan.c 427
ffff88005a7c8038 100
net/wireless/scan.c 377
ffff88005a7c8038 100
net/wireless/scan.c 427
ffff88006bc07dd0 100
net/wireless/scan.c 377
ffff88006bc07dd0 100
net/wireless/scan.c 427
ffff88006bc07dd0 100
net/wireless/scan.c 377
ffff88006bc07dd0 100
net/wireless/scan.c 427
ffff88006bc07dd0 100
net/wireless/scan.c 377
ffff88006bc07dd0 100
net/wireless/scan.c 427
ffff88006bc07dd0 100
net/wireless/scan.c 377
ffff88006bc07dd0 100
net/wireless/scan.c 427
ffff88005a7c8038 100
net/wireless/scan.c 377
ffff88005a7c8038 100
net/wireless/scan.c 427
ffff88006bc07dd0 100
net/wireless/scan.c 377
ffff88006bc07dd0 100
net/wireless/scan.c 427
ffff88005a7c8038 100
net/wireless/scan.c 377
ffff88005a7c8038 100
net/wireless/scan.c 427
ffff88006bc07dd0 100
net/wireless/scan.c 377
ffff88006bc07dd0 100
net/wireless/scan.c 427
ffff88005a7c84c8 100
net/wireless/scan.c 377
ffff88005a7c84c8 100
net/wireless/scan.c 427
ffff88005f148038 100
net/wireless/scan.c 377
ffff88005f148038 100
net/wireless/scan.c 427
ffff88005f148038 100
net/wireless/scan.c 377
ffff88005f148038 100
net/wireless/scan.c 427
ffff88005a7c84c8 100
net/wireless/scan.c 377
ffff88005a7c84c8 100
net/wireless/scan.c 427
ffff88005a7c84c8 100
net/wireless/scan.c 377
ffff88005a7c84c8 100
net/wireless/scan.c 427
ffff88005a7c84c8 100
net/wireless/scan.c 377
ffff88005a7c84c8 100
net/wireless/scan.c 427
ffff88005a7c8710 100
net/wireless/scan.c 377
ffff88005a7c8710 100
net/wireless/scan.c 427
ffff88005f148038 100
net/wireless/scan.c 377
ffff88005f148038 100
net/wireless/scan.c 427
ffff88005f148038 100
net/wireless/scan.c 377
ffff88005f148038 100
net/wireless/scan.c 427
ffff88005a7c8710 100
net/wireless/scan.c 377
ffff88005a7c8710 100
net/wireless/scan.c 427
ffff88005f148038 100
net/wireless/scan.c 377
ffff88005f148038 100
net/wireless/scan.c 427
ffff88005f148038 100
net/wireless/scan.c 377
ffff88005f148038 100
net/wireless/scan.c 427
ffff88005f148038 100
net/wireless/scan.c 377
ffff88005f148038 100
net/wireless/scan.c 427
ffff88005a7c8710 100
net/wireless/scan.c 377
ffff88005a7c8710 100
net/wireless/scan.c 427
ffff88005f148038 100
net/wireless/scan.c 377
ffff88005f148038 100
net/wireless/scan.c 427
ffff88005f148038 100
net/wireless/scan.c 377
ffff88005f148038 100
net/wireless/scan.c 427
ffff88005f148038 100
net/wireless/scan.c 377
ffff88005f148038 100
net/wireless/scan.c 427
ffff88005f148038 100
net/wireless/scan.c 377
ffff88005f148038 100
net/wireless/scan.c 427
ffff88005f148038 100
net/wireless/scan.c 377
ffff88005f148038 100
net/wireless/scan.c 427
ffff88005f148038 100
net/wireless/scan.c 377
ffff88005f148038 100
net/wireless/scan.c 427
ffff88005a7c8ba0 100
net/wireless/scan.c 377
ffff88005a7c8ba0 100
net/wireless/scan.c 427
ffff88005f148038 100
net/wireless/scan.c 377
ffff88005f148038 100
net/wireless/scan.c 427
ffff88005f148038 100
net/wireless/scan.c 377
ffff88005f148038 100
net/wireless/scan.c 427
ffff88005a7c8ba0 100
net/wireless/scan.c 377
ffff88005a7c8ba0 100
net/wireless/scan.c 244
(null)
net/wireless/scan.c 244
(null)
net/wireless/scan.c 244
(null)
net/wireless/scan.c 244
ffff88006ed5b4b0
wlan0: authenticate with AP 00:18:39:5b:82:ca
net/wireless/scan.c 244
ffff88006ed5b4b0
wlan0: authenticated
wlan0: associate with AP 00:18:39:5b:82:ca
net/wireless/scan.c 244
ffff88006ed5b4b0
net/wireless/scan.c 244
ffff88006ed5b4b0
wlan0: RX AssocResp from 00:18:39:5b:82:ca (capab=0x411 status=0 aid=6)
wlan0: associated
net/wireless/scan.c 244
ffff88006ed5b4b0
net/mac80211/mlme.c 641
100
drivers/net/wireless/iwlwifi/iwl-agn.c 643
100
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
net/wireless/scan.c 427
ffff88005a7c8de8 100
net/wireless/scan.c 377
ffff88005a7c8de8 100
net/wireless/scan.c 427
ffff88005a7c9278 100
net/wireless/scan.c 377
ffff88005a7c9278 100
net/wireless/scan.c 427
ffff88005a7c9278 100
net/wireless/scan.c 377
ffff88005a7c9278 100
net/wireless/scan.c 427
ffff88005a7c9278 100
net/wireless/scan.c 377
ffff88005a7c9278 100
net/wireless/scan.c 427
ffff88005a7c9278 100
net/wireless/scan.c 377
ffff88005a7c9278 100
net/wireless/scan.c 427
ffff88005a7c9278 100
net/wireless/scan.c 377
ffff88005a7c9278 100
net/wireless/scan.c 427
ffff88005a7c9278 100
net/wireless/scan.c 377
ffff88005a7c9278 100
net/wireless/scan.c 427
ffff88005a7c9278 100
net/wireless/scan.c 377
ffff88005a7c9278 100
net/wireless/scan.c 427
ffff88005a7c9278 100
net/wireless/scan.c 377
ffff88005a7c9278 100
net/wireless/scan.c 427
ffff88005a7c9278 100
net/wireless/scan.c 377
ffff88005a7c9278 100
net/wireless/scan.c 427
ffff88005a7c9278 100
net/wireless/scan.c 377
ffff88005a7c9278 100
net/wireless/scan.c 427
ffff88005a7c94c0 100
net/wireless/scan.c 377
ffff88005a7c94c0 100
net/wireless/scan.c 427
ffff88005a7c9950 100
net/wireless/scan.c 377
ffff88005a7c9950 100
net/wireless/scan.c 427
ffff88005a7c9950 100
net/wireless/scan.c 377
ffff88005a7c9950 100
net/wireless/scan.c 427
ffff88005a7c9950 100
net/wireless/scan.c 377
ffff88005a7c9950 100
net/wireless/scan.c 427
ffff88005a7c9950 100
net/wireless/scan.c 377
ffff88005a7c9950 100
net/wireless/scan.c 427
ffff88005a7c84c8 100
net/wireless/scan.c 377
ffff88005a7c84c8 100
net/wireless/scan.c 244
ffff88006ed5b4b0
net/wireless/scan.c 427
ffff88005a7c84c8 100
net/wireless/scan.c 377
ffff88005a7c84c8 100
net/wireless/scan.c 427
ffff88005a7c84c8 100
net/wireless/scan.c 377
ffff88005a7c84c8 100
net/wireless/scan.c 427
ffff88005a7c84c8 100
net/wireless/scan.c 377
ffff88005a7c84c8 100
net/wireless/scan.c 427
ffff88005a7c84c8 100
net/wireless/scan.c 377
ffff88005a7c84c8 100
net/wireless/scan.c 427
ffff88005a7c9b98 100
net/wireless/scan.c 377
ffff88005a7c9b98 100
net/wireless/scan.c 427
ffff88005a7c9b98 100
net/wireless/scan.c 377
ffff88005a7c9b98 100
net/wireless/scan.c 427
ffff88005a7c9b98 100
net/wireless/scan.c 377
ffff88005a7c9b98 100
net/wireless/scan.c 427
ffff88005a7c9de0 100
net/wireless/scan.c 377
ffff88005a7c9de0 100
net/wireless/scan.c 427
ffff88005a7c9de0 100
net/wireless/scan.c 377
ffff88005a7c9de0 100
net/wireless/scan.c 427
ffff88005a7c9de0 100
net/wireless/scan.c 377
ffff88005a7c9de0 100
net/wireless/scan.c 427
ffff88005a7c9de0 100
net/wireless/scan.c 377
ffff88005a7c9de0 100
net/wireless/scan.c 427
ffff88005a7c9de0 100
net/wireless/scan.c 377
ffff88005a7c9de0 100
net/wireless/scan.c 427
ffff88005a7c9de0 100
net/wireless/scan.c 377
ffff88005a7c9de0 100
net/wireless/scan.c 427
ffff88005a7c9de0 100
net/wireless/scan.c 377
ffff88005a7c9de0 100
net/wireless/scan.c 427
ffff88005a7c9de0 100
net/wireless/scan.c 377
ffff88005a7c9de0 100
net/wireless/scan.c 427
ffff88005a7c9de0 100
net/wireless/scan.c 377
ffff88005a7c9de0 100
net/wireless/scan.c 427
ffff88005a7ca028 100
net/wireless/scan.c 377
ffff88005a7ca028 100
net/wireless/scan.c 427
ffff88005f148038 100
net/wireless/scan.c 377
ffff88005f148038 100
net/wireless/scan.c 427
ffff88005f148038 100
net/wireless/scan.c 377
ffff88005f148038 100
net/wireless/scan.c 427
ffff88005f148038 100
net/wireless/scan.c 377
ffff88005f148038 100
net/wireless/scan.c 244
ffff88006ed5b4b0
net/wireless/scan.c 427
ffff88005a7ca028 100
net/wireless/scan.c 377
ffff88005a7ca028 100
net/wireless/scan.c 427
ffff88005a7ca028 100
net/wireless/scan.c 377
ffff88005a7ca028 100
net/wireless/scan.c 427
ffff88005a7ca028 100
net/wireless/scan.c 377
ffff88005a7ca028 100
net/wireless/scan.c 427
ffff88005a7ca028 100
net/wireless/scan.c 377
ffff88005a7ca028 100
net/wireless/scan.c 427
ffff88005a7ca028 100
net/wireless/scan.c 377
ffff88005a7ca028 100
net/wireless/scan.c 427
ffff88005a7ca028 100
net/wireless/scan.c 377
ffff88005a7ca028 100
net/wireless/scan.c 427
ffff88005a7ca028 100
net/wireless/scan.c 377
ffff88005a7ca028 100
net/wireless/scan.c 427
ffff88005a7ca028 100
net/wireless/scan.c 377
ffff88005a7ca028 100
net/wireless/scan.c 427
ffff88005a7ca028 100
net/wireless/scan.c 377
ffff88005a7ca028 100
net/wireless/scan.c 427
ffff88005a7ca028 100
net/wireless/scan.c 377
ffff88005a7ca028 100
net/wireless/scan.c 427
ffff88005a7ca028 100
net/wireless/scan.c 377
ffff88005a7ca028 100
net/wireless/scan.c 427
ffff88005a7ca028 100
net/wireless/scan.c 377
ffff88005a7ca028 100
net/wireless/scan.c 427
ffff88005a7ca028 100
net/wireless/scan.c 377
ffff88005a7ca028 100
net/wireless/scan.c 427
ffff88005f148038 100
net/wireless/scan.c 377
ffff88005f148038 100
net/wireless/scan.c 427
ffff88005f148038 100
net/wireless/scan.c 377
ffff88005f148038 100
net/wireless/scan.c 427
ffff88005f148038 100
net/wireless/scan.c 377
ffff88005f148038 100
net/wireless/scan.c 427
ffff88005f148038 100
net/wireless/scan.c 377
ffff88005f148038 100
net/wireless/scan.c 244
ffff88006ed5b4b0
net/wireless/scan.c 427
ffff88005f148038 100
net/wireless/scan.c 377
ffff88005f148038 100
net/wireless/scan.c 427
ffff88005f148038 100
net/wireless/scan.c 377
ffff88005f148038 100
net/wireless/scan.c 427
ffff88005f148038 100
net/wireless/scan.c 377
ffff88005f148038 100
net/wireless/scan.c 427
ffff88005f148038 100
net/wireless/scan.c 377
ffff88005f148038 100
net/wireless/scan.c 427
ffff88005f148038 100
net/wireless/scan.c 377
ffff88005f148038 100
net/wireless/scan.c 427
ffff88005f148038 100
net/wireless/scan.c 377
ffff88005f148038 100
net/wireless/scan.c 427
ffff88005f148038 100
net/wireless/scan.c 377
ffff88005f148038 100
net/wireless/scan.c 427
ffff88005f148038 100
net/wireless/scan.c 377
ffff88005f148038 100
net/wireless/scan.c 427
ffff88005f148038 100
net/wireless/scan.c 377
ffff88005f148038 100
net/wireless/scan.c 427
ffff88005f148038 100
net/wireless/scan.c 377
ffff88005f148038 100
net/wireless/scan.c 427
ffff88005f148038 100
net/wireless/scan.c 377
ffff88005f148038 100
net/wireless/scan.c 427
ffff88005f148038 100
net/wireless/scan.c 377
ffff88005f148038 100
net/wireless/scan.c 427
ffff88005f148038 100
net/wireless/scan.c 377
ffff88005f148038 100
net/wireless/scan.c 427
ffff88005f148038 100
net/wireless/scan.c 377
ffff88005f148038 100
net/wireless/scan.c 427
ffff88005f148038 100
net/wireless/scan.c 377
ffff88005f148038 100
net/wireless/scan.c 427
ffff88005f148038 100
net/wireless/scan.c 377
ffff88005f148038 100
net/wireless/scan.c 427
ffff88005f148038 100
net/wireless/scan.c 377
ffff88005f148038 100
net/wireless/scan.c 244
ffff88006ed5b4b0
net/wireless/scan.c 427
ffff88005f148038 100
net/wireless/scan.c 377
ffff88005f148038 100
net/wireless/scan.c 427
ffff88005f148038 100
net/wireless/scan.c 377
ffff88005f148038 100
net/wireless/scan.c 427
ffff88005f148038 100
net/wireless/scan.c 377
ffff88005f148038 100
net/wireless/scan.c 427
ffff88005f148038 100
net/wireless/scan.c 377
ffff88005f148038 100
net/wireless/scan.c 427
ffff88005f148038 100
net/wireless/scan.c 377
ffff88005f148038 100
net/wireless/scan.c 427
ffff88005a7ca028 100
net/wireless/scan.c 377
ffff88005a7ca028 100
net/wireless/scan.c 427
ffff88005a7ca028 100
net/wireless/scan.c 377
ffff88005a7ca028 100
net/wireless/scan.c 427
ffff88005a7ca028 100
net/wireless/scan.c 377
ffff88005a7ca028 100
net/wireless/scan.c 427
ffff88005a7ca028 100
net/wireless/scan.c 377
ffff88005a7ca028 100
net/wireless/scan.c 427
ffff88005a7ca028 100
net/wireless/scan.c 377
ffff88005a7ca028 100
net/wireless/scan.c 427
ffff88005a7ca028 100
net/wireless/scan.c 377
ffff88005a7ca028 100
net/wireless/scan.c 427
ffff88005a7ca028 100
net/wireless/scan.c 377
ffff88005a7ca028 100
net/wireless/scan.c 427
ffff88005a7ca028 100
net/wireless/scan.c 377
ffff88005a7ca028 100
net/wireless/scan.c 427
ffff88005a7ca028 100
net/wireless/scan.c 377
ffff88005a7ca028 100
net/wireless/scan.c 427
ffff88005a7ca028 100
net/wireless/scan.c 377
ffff88005a7ca028 100
net/wireless/scan.c 427
ffff88005f148280 100
net/wireless/scan.c 377
ffff88005f148280 100
net/wireless/scan.c 427
ffff88005f148280 100
net/wireless/scan.c 377
ffff88005f148280 100
net/wireless/scan.c 244
ffff88006ed5b4b0
net/wireless/scan.c 427
ffff88005f148280 100
net/wireless/scan.c 377
ffff88005f148280 100
net/wireless/scan.c 427
ffff88005f148280 100
net/wireless/scan.c 377
ffff88005f148280 100
net/wireless/scan.c 427
ffff88005f148280 100
net/wireless/scan.c 377
ffff88005f148280 100
net/wireless/scan.c 427
ffff88005f148280 100
net/wireless/scan.c 377
ffff88005f148280 100
wlan0: no IPv6 routers present
net/wireless/scan.c 427
ffff88005f148280 100
net/wireless/scan.c 377
ffff88005f148280 100
net/wireless/scan.c 427
ffff88005f148280 100
net/wireless/scan.c 377
ffff88005f148280 100
net/wireless/scan.c 427
ffff88005f148280 100
net/wireless/scan.c 377
ffff88005f148280 100
net/wireless/scan.c 427
ffff88005f148280 100
net/wireless/scan.c 377
ffff88005f148280 100
net/wireless/scan.c 427
ffff88005f148280 100
net/wireless/scan.c 377
ffff88005f148280 100
net/wireless/scan.c 427
ffff88005f148038 100
net/wireless/scan.c 377
ffff88005f148038 100
net/wireless/scan.c 427
ffff88005f148038 100
net/wireless/scan.c 377
ffff88005f148038 100
net/wireless/scan.c 427
ffff88005f148038 100
net/wireless/scan.c 377
ffff88005f148038 100
net/wireless/scan.c 427
ffff88005f148038 100
net/wireless/scan.c 377
ffff88005f148038 100
net/wireless/scan.c 244
ffff88006ed5b4b0
net/wireless/scan.c 427
ffff88005f148038 100
net/wireless/scan.c 377
ffff88005f148038 100
net/wireless/scan.c 427
ffff88005f148038 100
net/wireless/scan.c 377
ffff88005f148038 100
net/wireless/scan.c 427
ffff88005f148038 100
net/wireless/scan.c 377
ffff88005f148038 100
net/wireless/scan.c 427
ffff88005f148038 100
net/wireless/scan.c 377
ffff88005f148038 100
net/wireless/scan.c 427
ffff88005f148038 100
net/wireless/scan.c 377
ffff88005f148038 100
net/wireless/scan.c 427
ffff88005f148038 100
net/wireless/scan.c 377
ffff88005f148038 100
net/wireless/scan.c 427
ffff88005f148038 100
net/wireless/scan.c 377
ffff88005f148038 100
net/wireless/scan.c 427
ffff88005f148038 100
net/wireless/scan.c 377
ffff88005f148038 100
net/wireless/scan.c 427
ffff88005f148038 100
net/wireless/scan.c 377
ffff88005f148038 100
net/wireless/scan.c 244
ffff88006ed5b4b0

--h31gzZEtNLTqOjlF--
