Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f179.google.com ([209.85.216.179]:34226 "EHLO
        mail-qt0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753223AbdKWRsD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Nov 2017 12:48:03 -0500
Subject: Re: kernel BUG at crypto/asymmetric_keys/public_key.c:80
To: Johannes Berg <johannes@sipsolutions.net>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        open list <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Howells <dhowells@redhat.com>,
        linux-wireless@vger.kernel.org
References: <d2b989b6-38cf-a04d-0353-3540fdb891ed@gmail.com>
 <2ef18f35-bb00-2f4b-45fe-1beb3cdd0745@broadcom.com>
 <1511376145.2841.1.camel@sipsolutions.net>
 <a95ae21a-c9f7-4e01-98f1-469201e20615@gmail.com>
 <1511447043.2841.2.camel@sipsolutions.net>
From: Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <46fde28f-8f97-841e-d00a-399a40b3a2e7@gmail.com> (sfid-20171123_184837_697730_74C1AE48)
Date: Thu, 23 Nov 2017 09:47:58 -0800
MIME-Version: 1.0
In-Reply-To: <1511447043.2841.2.camel@sipsolutions.net>
Content-Type: multipart/mixed;
 boundary="------------669F2A6CC101D5EC8DB53416"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------669F2A6CC101D5EC8DB53416
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit



On 11/23/2017 06:24 AM, Johannes Berg wrote:
> On Wed, 2017-11-22 at 15:07 -0800, Florian Fainelli wrote:
>> On 11/22/2017 10:42 AM, Johannes Berg wrote:
>>> On Wed, 2017-11-22 at 19:29 +0100, Arend van Spriel wrote:
>>>> + Johannes
>>>>
>>>>  >>>     BUG_ON(!sig->digest);
>>>>          BUG_ON(!sig->s);
>>>
>>> I *think* this is the same bug that was reported before, then this
>>> should fix it:
>>>
>>> https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git/commit/?id=d7be102f2945a626f55e0501e52bb31ba3e77b81
>>>
>>> Can you try?
>>
>> My baseline already has this commit actually, is there something else
>> you would want me to check?
> 
> Hmm, different problem then - could you put the entire boot log
> somewhere I can read it?

Absolutely, please find it enclosed.
-- 
Florian

--------------669F2A6CC101D5EC8DB53416
Content-Type: text/plain; charset=UTF-8;
 name="log"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename="log"

BOLT> boot stb-bld-03:users/fainelli/UPS/vmlinuz-initrd-arm
Device eth0:  hwaddr 00-10-18-57-23-70, ipaddr 192.168.1.23, mask 255.255.255.0
        gateway 192.168.1.1, nameserver 192.19.189.10, domain broadcom.com
        DHCP server 192.168.1.1, DHCP server MAC 68-05-CA-18-47-70
Loader:zimg Filesys:tftp Dev:(null) File:stb-bld-03:users/fainelli/UPS/vmlinuz-initrd-arm Options:(null)
Reading 18406640 bytes from zImage...........
Closing network 'eth0'
Starting program at 0x8000 (DTB @ 0x771f000)

32 bit direct boot...
[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Linux version 4.14.0-12995-g0c86a6bd85ff (fainelli@stb-bld-03) (gcc version 6.3.0 (crosstool-NG )) #17 SMP Wed Nov 22 09:42:09 PST 2017
[    0.000000] CPU: ARMv7 Processor [420f00f3] revision 3 (ARMv7), cr=30c5387d
[    0.000000] CPU: div instructions available: patching division code
[    0.000000] CPU: PIPT / VIPT nonaliasing data cache, PIPT instruction cache
[    0.000000] OF: fdt: Machine model: BCM97445VMS
[    0.000000] Memory policy: Data cache writealloc
[    0.000000] cma: Reserved 16 MiB at 0x00000000bf000000
[    0.000000] random: get_random_bytes called from start_kernel+0xa4/0x41c with crng_init=0
[    0.000000] percpu: Embedded 17 pages/cpu @ee795000 s39116 r8192 d22324 u69632
[    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 776704
[    0.000000] Kernel command line: 
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Memory: 3035280K/3112960K available (8192K kernel code, 652K rwdata, 2076K rodata, 22528K init, 242K bss, 61296K reserved, 16384K cma-reserved, 2310144K highmem)
[    0.000000] Virtual kernel memory layout:
[    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
[    0.000000]     fixmap  : 0xffc00000 - 0xfff00000   (3072 kB)
[    0.000000]     vmalloc : 0xf0800000 - 0xff800000   ( 240 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf0000000   ( 768 MB)
[    0.000000]     pkmap   : 0xbfe00000 - 0xc0000000   (   2 MB)
[    0.000000]     modules : 0xbf000000 - 0xbfe00000   (  14 MB)
[    0.000000]       .text : 0xc0008000 - 0xc0a00000   (10208 kB)
[    0.000000]       .init : 0xc0e00000 - 0xc2400000   (22528 kB)
[    0.000000]       .data : 0xc2400000 - 0xc24a304c   ( 653 kB)
[    0.000000]        .bss : 0xc24a304c - 0xc24dfbe4   ( 243 kB)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS: 16, nr_irqs: 16, preallocated irqs: 16
[    0.000000] irq_brcmstb_l2: registered L2 intc (mem: 0xf0805000, parent irq: 16)
[    0.000000] irq_brcmstb_l2: registered L2 intc (mem: 0xf0807000, parent irq: 17)
[    0.000000] irq_brcmstb_l2: registered L2 intc (mem: 0xf0809640, parent irq: 18)
[    0.000000] irq_brcmstb_l2: registered L2 intc (mem: 0xf080b200, parent irq: 19)
[    0.000000] irq_bcm7120_l2: registered BCM7120 L2 intc (mem: 0xfc40a780, parent IRQ(s): 2)
[    0.000000] irq_bcm7120_l2: registered BCM7120 L2 intc (mem: 0xf080d280, parent IRQ(s): 3)
[    0.000000] brcmstb: biuctrl: MCP: Write pairing already disabled
[    0.000000] arch_timer: cp15 timer(s) running at 27.00MHz (virt).
[    0.000000] clocksource: arch_sys_counter: mask: 0xffffffffffffff max_cycles: 0x63a1e71a3, max_idle_ns: 440795203123 ns
[    0.000006] sched_clock: 56 bits at 27MHz, resolution 37ns, wraps every 4398046511093ns
[    0.000016] Switching to timer-based delay loop, resolution 37ns
[    0.000255] Console: colour dummy device 80x30
[    0.000441] console [tty0] enabled
[    0.000464] Calibrating delay loop (skipped), value calculated using timer frequency.. 54.00 BogoMIPS (lpj=27000)
[    0.000480] pid_max: default: 32768 minimum: 301
[    0.000567] Mount-cache hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000585] Mountpoint-cache hash table entries: 2048 (order: 1, 8192 bytes)
[    0.001063] CPU: Testing write buffer coherency: ok
[    0.001293] CPU0: update cpu_capacity 1024
[    0.001306] CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
[    0.001692] Setting up static identity map for 0x200000 - 0x200060
[    0.001761] Hierarchical SRCU implementation.
[    0.003736] smp: Bringing up secondary CPUs ...
[    0.004409] CPU1: update cpu_capacity 1024
[    0.004413] CPU1: thread -1, cpu 1, socket 0, mpidr 80000001
[    0.005101] CPU2: update cpu_capacity 1024
[    0.005105] CPU2: thread -1, cpu 2, socket 0, mpidr 80000002
[    0.005776] CPU3: update cpu_capacity 1024
[    0.005780] CPU3: thread -1, cpu 3, socket 0, mpidr 80000003
[    0.005837] smp: Brought up 1 node, 4 CPUs
[    0.005878] SMP: Total of 4 processors activated (216.00 BogoMIPS).
[    0.005887] CPU: All CPU(s) started in SVC mode.
[    0.006343] devtmpfs: initialized
[    0.011672] VFP support v0.3: implementor 42 architecture 4 part 00 variant 0 rev 0
[    0.011882] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1911260446275000 ns
[    0.011909] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    0.013068] random: fast init done
[    0.013240] NET: Registered protocol family 16
[    0.014124] DMA: preallocated 256 KiB pool for atomic coherent allocations
[    0.014917] cpuidle: using governor menu
[    0.015025] hw-breakpoint: found 5 (+1 reserved) breakpoint and 4 watchpoint registers.
[    0.015037] hw-breakpoint: maximum watchpoint size is 8 bytes.
[    0.033416] SCSI subsystem initialized
[    0.033823] usbcore: registered new interface driver usbfs
[    0.033869] usbcore: registered new interface driver hub
[    0.033930] usbcore: registered new device driver usb
[    0.034038] Linux video capture interface: v2.00
[    0.034081] pps_core: LinuxPPS API ver. 1 registered
[    0.034090] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.034120] PTP clock support registered
[    0.034630] Advanced Linux Sound Architecture Driver Initialized.
[    0.035068] clocksource: Switched to clocksource arch_sys_counter
[    0.073379] NET: Registered protocol family 2
[    0.073710] TCP established hash table entries: 8192 (order: 3, 32768 bytes)
[    0.073758] TCP bind hash table entries: 8192 (order: 4, 65536 bytes)
[    0.073846] TCP: Hash tables configured (established 8192 bind 8192)
[    0.073952] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.073985] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.074150] NET: Registered protocol family 1
[    0.074448] RPC: Registered named UNIX socket transport module.
[    0.074458] RPC: Registered udp transport module.
[    0.074465] RPC: Registered tcp transport module.
[    0.074473] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.128462] hw perfevents: no interrupt-affinity property for /pmu, guessing.
[    0.128781] hw perfevents: enabled with armv7_cortex_a15 PMU driver, 7 counters available
[    0.130310] Initialise system trusted keyrings
[    0.130448] workingset: timestamp_bits=30 max_order=20 bucket_order=0
[    0.134558] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    0.135113] NFS: Registering the id_resolver key type
[    0.135139] Key type id_resolver registered
[    0.135147] Key type id_legacy registered
[    0.135164] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
[    0.135190] jffs2: version 2.2. (NAND) © 2001-2006 Red Hat, Inc.
[    0.135386] fuse init (API version 7.26)
[    0.136603] Key type asymmetric registered
[    0.136617] Asymmetric key parser 'x509' registered
[    0.136653] bounce: pool size: 64 pages
[    0.136691] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
[    0.136706] io scheduler noop registered
[    0.136716] io scheduler deadline registered
[    0.136863] io scheduler cfq registered (default)
[    0.136876] io scheduler mq-deadline registered
[    0.136885] io scheduler kyber registered
[    0.137349] brcm-gisb-arb f0400000.gisb-arb: registered mem: f08c7000, irqs: 58, 59
[    0.137823] brcm-sata-phy f0458100.sata_phy: registered 2 port(s)
[    0.138870] brcmstb-gpio f040a700.gpio: Registered 4 banks (GPIO(s): 0-127)
[    0.139303] brcmstb-gpio f04172c0.gpio: Registered 2 banks (GPIO(s): 128-191)
[    0.174657] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.176395] f040ab00.serial: ttyS0 at MMIO 0xf040ab00 (irq = 36, base_baud = 5062500) is a 16550A
[    0.878924] console [ttyS0] enabled
[    0.882970] f040ab40.serial: ttyS1 at MMIO 0xf040ab40 (irq = 37, base_baud = 5062500) is a 16550A
[    0.892339] f040ab80.serial: ttyS2 at MMIO 0xf040ab80 (irq = 38, base_baud = 5062500) is a 16550A
[    0.907210] brd: module loaded
[    0.915763] loop: module loaded
[    0.920678] brcmstb_nand f03e2800.nand: enabling FLASH_DMA
[    0.926771] nand: device found, Manufacturer ID: 0x2c, Chip ID: 0x68
[    0.933149] nand: Micron MT29F32G08CBACAWP
[    0.937262] nand: 4096 MiB, MLC, erase size: 1024 KiB, page size: 4096, OOB size: 224
[    0.945122] brcmstb_nand f03e2800.nand: detected 4096MiB total, 1024KiB blocks, 4KiB pages, 28B OOB, 8-bit, BCH-24 (1KiB sector)
[    0.957416] Bad block table found at page 1048320, version 0x01
[    0.963930] Bad block table found at page 1048064, version 0x01
[    0.970453] nand_read_bbt: bad block at 0x000005a00000
[    0.975612] nand_read_bbt: bad block at 0x000005b00000
[    0.980892] 3 ofpart partitions found on MTD device brcmnand.1
[    0.986743] Creating 3 MTD partitions on "brcmnand.1":
[    0.991901] 0x000000000000-0x000080000000 : "flash1.rootfs0"
[    0.999275] 0x000080000000-0x000100000000 : "flash1.rootfs1"
[    1.006571] 0x000000000000-0x000100000000 : "flash1"
[    1.014654] brcmstb_qspi f03e0920.qspi: using bspi-mspi mode
[    1.020406] brcmstb_qspi f03e0920.qspi: no IRQs registered, cannot init driver
[    1.027670] brcmstb_qspi: probe of f03e0920.qspi failed with error -22
[    1.034267] brcmstb_qspi f0416000.spi: using mspi mode
[    1.044000] libphy: unimac MII bus: probed
[    1.060096] unimac-mdio f0b403c0.mdio: Broadcom UniMAC MDIO bus at 0xf0aa53c0
[    1.067988] libphy: Fixed MDIO Bus: probed
[    1.072497] libphy: sf2 slave mii: probed
[    1.087588] b53_common: found switch: BCM7445, rev 0
[    1.096351] brcm-systemport f04a0000.ethernet: Broadcom SYSTEMPORTv 1.00 at 0xf0ab8000 (irqs: 64, 65, TXQs: 32, RXQs: 1)
[    1.107364] e1000e: Intel(R) PRO/1000 Network Driver - 3.2.6-k
[    1.113217] e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
[    1.119194] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Ethernet driver
[    1.126656] usbcore: registered new interface driver pegasus
[    1.132360] usbcore: registered new interface driver asix
[    1.137799] usbcore: registered new interface driver ax88179_178a
[    1.143939] usbcore: registered new interface driver cdc_ether
[    1.149823] usbcore: registered new interface driver cdc_ncm
[    1.155675] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.162234] ehci-pci: EHCI PCI platform driver
[    1.166723] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.172935] ohci-pci: OHCI PCI platform driver
[    1.177487] usbcore: registered new interface driver usb-storage
[    1.183775] udc-core: couldn't find an available UDC - added [g_mass_storage] to list of pending drivers
[    1.193454] mousedev: PS/2 mouse device common for all mice
[    1.199504] brcmstb-waketimer f0417580.waketimer: rtc core: registered brcmstb-waketmr as rtc0
[    1.208149] brcmstb-waketimer f0417580.waketimer: registered, with irq 60
[    1.215059] i2c /dev entries driver
[    1.218708] gspca_main: v2.14.0 registered
[    1.223129] brcmstb_thermal f04d1500.thermal: registered AVS TMON of-sensor driver
[    1.231249] sdhci: Secure Digital Host Controller Interface driver
[    1.237451] sdhci: Copyright(c) Pierre Ossman
[    1.241821] sdhci-pltfm: SDHCI platform and OF driver helper
[    1.247569] sdhci-brcmstb f03e0000.sdhci: Clock not found in Device Tree
[    1.284074] mmc0: SDHCI controller on f03e0000.sdhci [f03e0000.sdhci] using ADMA
[    1.291715] usbcore: registered new interface driver usbhid
[    1.297314] usbhid: USB HID core driver
[    1.301668] NET: Registered protocol family 17
[    1.306397] Key type dns_resolver registered
[    1.310699] Registering SWP/SWPB emulation handler
[    1.315810] Loading compiled-in X.509 certificates
[    1.321952] libphy: sf2 slave mii: probed
[    1.336538] b53_common: found switch: BCM7445, rev 0
[    1.400063] f0b403c0.mdio--1:05: Broadcom BCM7445 PHY revision: 0xd0, patch: 3
[    1.723026] Broadcom BCM7445 f0b403c0.mdio--1:05: attached PHY driver [Broadcom BCM7445] (mii_bus:phy_addr=f0b403c0.mdio--1:05, irq=POLL)
[    1.744012] Generic PHY f0b403c0.mdio--1:00: attached PHY driver [Generic PHY] (mii_bus:phy_addr=f0b403c0.mdio--1:00, irq=POLL)
[    1.757538] Generic PHY fixed-0:01: attached PHY driver [Generic PHY] (mii_bus:phy_addr=fixed-0:01, irq=POLL)
[    1.769486] Generic PHY fixed-0:02: attached PHY driver [Generic PHY] (mii_bus:phy_addr=fixed-0:02, irq=POLL)
[    1.779876] DSA: tree 0 setup
[    1.782864] Starfighter 2 top: 4.00, core: 2.00 base: 0xf0b80000, IRQs: 67, 68
[    1.790540] brcmstb-waketimer f0417580.waketimer: setting system clock to 1970-01-01 00:01:37 UTC (97)
[    1.800022] cfg80211: Loading compiled-in X.509 certificates for regulatory database
[    1.810712] ------------[ cut here ]------------
[    1.815342] kernel BUG at crypto/asymmetric_keys/public_key.c:80!
[    1.821445] Internal error: Oops - BUG: 0 [#1] SMP ARM
[    1.826594] Modules linked in:
[    1.829661] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 4.14.0-12995-g0c86a6bd85ff #17
[    1.837417] Hardware name: Broadcom STB (Flattened Device Tree)
[    1.843346] task: ee0a0000 task.stack: ee096000
[    1.847898] PC is at public_key_verify_signature+0x21c/0x260
[    1.853569] LR is at x509_check_for_self_signed+0xb0/0x10c
[    1.859064] pc : [<c0525d08>]    lr : [<c0526ee8>]    psr: 60000013
[    1.865340] sp : ee097cf8  ip : c0a7a336  fp : 00000000
[    1.870574] r10: c248e998  r9 : c0b40160  r8 : ed94b1c0
[    1.875807] r7 : c0a7a2c8  r6 : ed94b240  r5 : c2404c48  r4 : ed980700
[    1.882345] r3 : 00000000  r2 : c0b40400  r1 : ed94b080  r0 : ed94b1c0
[    1.888884] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
[    1.896030] Control: 30c5387d  Table: 00003000  DAC: fffffffd
[    1.901785] Process swapper/0 (pid: 1, stack limit = 0xee096210)
[    1.907802] Stack: (0xee097cf8 to 0xee098000)
[    1.912167] 7ce0:                                                       60000013 00000000
[    1.920360] 7d00: 014080c0 c052149c 000011a0 c248e998 00000000 c033dcb8 ee097d98 ed94b2c0
[    1.928552] 7d20: ffffffff 00000001 edac722e c0a7a5bc 00000001 edac722e c0a7a5bc c0521530
[    1.936743] 7d40: c052143c ffffffff edac7200 00000000 00000000 00000000 c0518bc0 c248e998
[    1.944934] 7d60: 00000000 c02416f8 c244bc28 00000000 edac7200 edac7388 edac7384 60000013
[    1.953125] 7d80: 00000000 c0b40054 c0518bc0 c248e998 00000000 c025de10 00000000 00000000
[    1.961315] 7da0: 00000000 fffffffe fffffffe 00000000 00000000 c0b40054 c0518bc0 c0518c34
[    1.969506] 7dc0: c0a23498 ee096000 00000000 00040e00 ed94b342 ed980700 ed980700 ed94b240
[    1.977698] 7de0: c0a7a2c8 000002a8 c0b40160 c248e998 00000000 c0526ee8 00000000 ed980700
[    1.985890] 7e00: ed94b240 c0525f24 c244d210 ee097e80 c248e998 ee097e80 c244d1ac c0526b74
[    1.994082] 7e20: c244d210 c244b988 c248e998 ee097e80 c244d1ac c0b40160 c248e998 c0524f20
[    2.002273] 7e40: c2404c48 c244b988 c0a7a2c8 ed980681 ee02c180 ed980680 00000000 c0511148
[    2.010465] 7e60: c24b7e5a 00000048 60000013 00000000 00000000 c244d1b4 00000000 00000000
[    2.018655] 7e80: 00000000 00000000 00000000 00000000 00000000 c0a7a2c8 000002a8 00000000
[    2.026846] 7ea0: 7fffffff 00040e00 c0a7a2c8 c24df734 000002a8 c0a7a570 c0bb0f4c c0b18008
[    2.035037] 7ec0: 1f030000 c0e47898 000002a8 1f030000 0000000e 00000000 00000000 c2404c48
[    2.043227] 7ee0: ffffe000 c0e4777c 00000000 c0e6583c c0e74f98 00000008 00000000 c0201bd8
[    2.051419] 7f00: 60000013 c025dda4 00000000 c0c05a00 c0e005d8 00000000 00000000 00000007
[    2.059609] 7f20: 00000007 00040e00 00000000 c240d790 00000000 c2404c48 c0e65818 00000000
[    2.067801] 7f40: 00000000 00040e00 00000000 00040e00 c24a3080 c24a3080 c24a3080 00000109
[    2.075993] 7f60: c0e65838 c0e6583c c0e74f98 c0e00e6c 00000007 00000007 00000000 c0e005d8
[    2.084185] 7f80: c09b4398 00000000 c09b4398 00000000 00000000 00000000 00000000 00000000
[    2.092377] 7fa0: 00000000 c09b43a0 00000000 c0208920 00000000 00000000 00000000 00000000
[    2.100568] 7fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    2.108759] 7fe0: 00000000 00000000 00000000 00000000 00000013 00000000 d91998da eea1d16c
[    2.116964] [<c0525d08>] (public_key_verify_signature) from [<c0526ee8>] (x509_check_for_self_signed+0xb0/0x10c)
[    2.127161] [<c0526ee8>] (x509_check_for_self_signed) from [<c0525f24>] (x509_cert_parse+0x14c/0x1a8)
[    2.136399] [<c0525f24>] (x509_cert_parse) from [<c0526b74>] (x509_key_preparse+0x14/0x18c)
[    2.144768] [<c0526b74>] (x509_key_preparse) from [<c0524f20>] (asymmetric_key_preparse+0x54/0xd4)
[    2.153749] [<c0524f20>] (asymmetric_key_preparse) from [<c0511148>] (key_create_or_update+0x120/0x3c4)
[    2.163166] [<c0511148>] (key_create_or_update) from [<c0e47898>] (regulatory_init_db+0x11c/0x1e4)
[    2.172146] [<c0e47898>] (regulatory_init_db) from [<c0201bd8>] (do_one_initcall+0x54/0x18c)
[    2.180610] [<c0201bd8>] (do_one_initcall) from [<c0e00e6c>] (kernel_init_freeable+0x140/0x1cc)
[    2.189328] [<c0e00e6c>] (kernel_init_freeable) from [<c09b43a0>] (kernel_init+0x8/0x110)
[    2.197527] [<c09b43a0>] (kernel_init) from [<c0208920>] (ret_from_fork+0x14/0x34)
[    2.205114] Code: ebf8636b eaffffab e7f001f2 e7f001f2 (e7f001f2) 
[    2.211219] ---[ end trace 5faac36851bd7a0b ]---
[    2.215871] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
[    2.215871] 
[    2.225031] CPU1: stopping
[    2.227750] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G      D          4.14.0-12995-g0c86a6bd85ff #17
[    2.236810] Hardware name: Broadcom STB (Flattened Device Tree)
[    2.242753] [<c0211ac0>] (unwind_backtrace) from [<c020c8b8>] (show_stack+0x10/0x14)
[    2.250518] [<c020c8b8>] (show_stack) from [<c099f674>] (dump_stack+0x84/0x98)
[    2.257759] [<c099f674>] (dump_stack) from [<c02108d4>] (handle_IPI+0x2ac/0x32c)
[    2.265172] [<c02108d4>] (handle_IPI) from [<c02014cc>] (gic_handle_irq+0x8c/0x90)
[    2.272757] [<c02014cc>] (gic_handle_irq) from [<c020d578>] (__irq_svc+0x58/0x74)
[    2.280251] Exception stack(0xee0c7f68 to 0xee0c7fb0)
[    2.285312] 7f60:                   00000001 00000000 00000000 c021bc60 ee0c6000 c2404c74
[    2.293504] 7f80: c2404ce0 00000002 c23ec3c0 00000000 00000000 ee0c7fc0 2c3c2000 ee0c7fb8
[    2.301696] 7fa0: c0209390 c0209394 600f0013 ffffffff
[    2.306760] [<c020d578>] (__irq_svc) from [<c0209394>] (arch_cpu_idle+0x38/0x3c)
[    2.314179] [<c0209394>] (arch_cpu_idle) from [<c025ed08>] (do_idle+0x184/0x218)
[    2.321592] [<c025ed08>] (do_idle) from [<c025f038>] (cpu_startup_entry+0x18/0x1c)
[    2.329178] [<c025f038>] (cpu_startup_entry) from [<002018ac>] (0x2018ac)
[    2.335977] CPU3: stopping
[    2.338694] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G      D          4.14.0-12995-g0c86a6bd85ff #17
[    2.347754] Hardware name: Broadcom STB (Flattened Device Tree)
[    2.353690] [<c0211ac0>] (unwind_backtrace) from [<c020c8b8>] (show_stack+0x10/0x14)
[    2.361452] [<c020c8b8>] (show_stack) from [<c099f674>] (dump_stack+0x84/0x98)
[    2.368691] [<c099f674>] (dump_stack) from [<c02108d4>] (handle_IPI+0x2ac/0x32c)
[    2.376103] [<c02108d4>] (handle_IPI) from [<c02014cc>] (gic_handle_irq+0x8c/0x90)
[    2.383688] [<c02014cc>] (gic_handle_irq) from [<c020d578>] (__irq_svc+0x58/0x74)
[    2.391182] Exception stack(0xee0cbf68 to 0xee0cbfb0)
[    2.396243] bf60:                   00000001 00000000 00000000 c021bc60 ee0ca000 c2404c74
[    2.404434] bf80: c2404ce0 00000008 c23ec3c0 00000000 00000000 ee0cbfc0 2c3e4000 ee0cbfb8
[    2.412625] bfa0: c0209390 c0209394 600f0013 ffffffff
[    2.417690] [<c020d578>] (__irq_svc) from [<c0209394>] (arch_cpu_idle+0x38/0x3c)
[    2.425103] [<c0209394>] (arch_cpu_idle) from [<c025ed08>] (do_idle+0x184/0x218)
[    2.432514] [<c025ed08>] (do_idle) from [<c025f038>] (cpu_startup_entry+0x18/0x1c)
[    2.440098] [<c025f038>] (cpu_startup_entry) from [<002018ac>] (0x2018ac)
[    2.446897] CPU2: stopping
[    2.449615] CPU: 2 PID: 0 Comm: swapper/2 Tainted: G      D          4.14.0-12995-g0c86a6bd85ff #17
[    2.458676] Hardware name: Broadcom STB (Flattened Device Tree)
[    2.464612] [<c0211ac0>] (unwind_backtrace) from [<c020c8b8>] (show_stack+0x10/0x14)
[    2.472372] [<c020c8b8>] (show_stack) from [<c099f674>] (dump_stack+0x84/0x98)
[    2.479611] [<c099f674>] (dump_stack) from [<c02108d4>] (handle_IPI+0x2ac/0x32c)
[    2.487022] [<c02108d4>] (handle_IPI) from [<c02014cc>] (gic_handle_irq+0x8c/0x90)
[    2.494606] [<c02014cc>] (gic_handle_irq) from [<c020d578>] (__irq_svc+0x58/0x74)
[    2.502100] Exception stack(0xee0c9f68 to 0xee0c9fb0)
[    2.507161] 9f60:                   00000001 00000000 00000000 c021bc60 ee0c8000 c2404c74
[    2.515354] 9f80: c2404ce0 00000004 c23ec3c0 00000000 00000000 ee0c9fc0 2c3d3000 ee0c9fb8
[    2.523544] 9fa0: c0209390 c0209394 60000013 ffffffff
[    2.528608] [<c020d578>] (__irq_svc) from [<c0209394>] (arch_cpu_idle+0x38/0x3c)
[    2.536022] [<c0209394>] (arch_cpu_idle) from [<c025ed08>] (do_idle+0x184/0x218)
[    2.543433] [<c025ed08>] (do_idle) from [<c025f038>] (cpu_startup_entry+0x18/0x1c)
[    2.551018] [<c025f038>] (cpu_startup_entry) from [<002018ac>] (0x2018ac)
[    2.557825] ---[ end Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
[    2.557825] 



--------------669F2A6CC101D5EC8DB53416--
