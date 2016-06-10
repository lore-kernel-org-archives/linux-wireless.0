Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:34000 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbcFJECu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2016 00:02:50 -0400
Received: by mail-oi0-f52.google.com with SMTP id e72so94917201oib.1
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jun 2016 21:02:50 -0700 (PDT)
Date: Thu, 9 Jun 2016 23:02:47 -0500
From: David Gilman <dgilman@gilslotd.com>
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: linux-wireless@vger.kernel.org,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: Re: Troubleshooting mwl8k driver issue
Message-ID: <20160610040247.GA16190@dar.local> (sfid-20160610_060256_536101_B7FE1E93)
References: <20160604035452.GA5925@dar.local>
 <20160606065146.GK8402@wantstofly.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="XF85m9dhOBO43t/C"
In-Reply-To: <20160606065146.GK8402@wantstofly.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--XF85m9dhOBO43t/C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 06, 2016 at 09:51:46AM +0300, Lennert Buytenhek wrote:
> There's a bunch of bad-looking stuff in the posted dmesgs, such as:
> 
> [ 10.983657] pci 0000:00:01.0: enabling device (0140 -> 0142)
> [ 11.972069] ieee80211 phy0: Command RF_ANTENNA error 0x2
> [ 11.977455] ieee80211 phy0: failed to set # of RX antennas
> [ 11.993318] ieee80211 phy0: Command RF_ANTENNA error 0x2
> [ 11.998713] ieee80211 phy0: failed to set # of TX antennas
> [ 12.004243] ieee80211 phy0: 88w8366 v48, c8d719177244, STA firmware 4.1.0.3
> 
> And:
> 
> [ 22.517451] 0000:02:00.0: unable to load firmware helper image
> [ 22.523399] ieee80211 phy1: Cannot start firmware
> [ 22.528230] ieee80211 phy1: Trying to reload the firmware again
> [ 23.016669] ieee80211 phy1: 88w8366 v7, c8d719177246, AP firmware 5.2.8.17

I've attached my startup dmesg output, I am seeing some of those messages.

> Is the behavior consistent per device across boots?  I.e. does device
> X always work on every boot while device Y never works at all?

Yes.

> For starters, could you post lspci -n output?

00:01.0 0604: 11ab:6282 (rev 01)
00:02.0 0604: 11ab:6282 (rev 01)
01:00.0 0200: 11ab:2a41
02:00.0 0200: 11ab:2a42

> Also, do you see the same behavior with older kernels, or have you
> only tried 4.4?

I saw it on kernel 3.18 as well.

As an aside I semi-bricked my router and I'm currently unable to flash
new images - unfortunate, as I prepped an OpenWRT build with debug
logging.  I feel committed to seeing this through though so I have
another device ordered but I will be unable to test new builds until it
gets here in a week or so.

-- 
David Gilman  :DG<
http://gilslotd.com

--XF85m9dhOBO43t/C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=openwrt_old_syslog

[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Linux version 4.4.7 (openwrt@0e997fc2ad25) (gcc version 5.3.0 (OpenWrt GCC 5.3.0 r49377) ) #1 Sun May 22 08:20:37 UTC 2016
[    0.000000] CPU: Feroceon 88FR131 [56251311] revision 1 (ARMv5TE), cr=0005397f
[    0.000000] CPU: VIVT data cache, VIVT instruction cache
[    0.000000] Machine model: Linksys EA3500
[    0.000000] Memory policy: Data cache writeback
[    0.000000] On node 0 totalpages: 16384
[    0.000000] free_area_init_node: node 0, pgdat c057d838, node_mem_map c3f7a000
[    0.000000]   Normal zone: 128 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 16384 pages, LIFO batch:3
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
[    0.000000] pcpu-alloc: [0] 0 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 16256
[    0.000000] Kernel command line: console=ttyS0,115200 mtdparts=nand_mtd:512k(uboot)ro,16k@512k(u_env),16k@528k(s_env),20m@2m(kernel),20m@2m(rootfs)fs,20m@22m(alt_kernel),20m@22m(alt_rootfs)fs,22m@42m(syscfg) root=/dev/mtdblock6 ro rootfstype=jffs2 serial_number=12C10606503967 uuid=9E782CBBA2A839EF4B650308C7E22720 hw_version=RGWM-C5_0GA device_mac=C0:56:27:BA:65:BD factory_date=2015/06/24 wps_pin=74717897
[    0.000000] PID hash table entries: 256 (order: -2, 1024 bytes)
[    0.000000] Dentry cache hash table entries: 8192 (order: 3, 32768 bytes)
[    0.000000] Inode-cache hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Memory: 58956K/65536K available (3946K kernel code, 135K rwdata, 1444K rodata, 168K init, 197K bss, 6580K reserved, 0K cma-reserved)
[    0.000000] Virtual kernel memory layout:
[    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
[    0.000000]     fixmap  : 0xffc00000 - 0xfff00000   (3072 kB)
[    0.000000]     vmalloc : 0xc4800000 - 0xff800000   ( 944 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xc4000000   (  64 MB)
[    0.000000]     modules : 0xbf000000 - 0xc0000000   (  16 MB)
[    0.000000]       .text : 0xc0008000 - 0xc054bdc4   (5392 kB)
[    0.000000]       .init : 0xc054c000 - 0xc0576000   ( 168 kB)
[    0.000000]       .data : 0xc0576000 - 0xc0597fac   ( 136 kB)
[    0.000000]        .bss : 0xc0597fac - 0xc05c959c   ( 198 kB)
[    0.000000] SLUB: HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] clocksource: orion_clocksource: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 9556302233 ns
[    0.000010] sched_clock: 32 bits at 200MHz, resolution 5ns, wraps every 10737418237ns
[    0.000098] Calibrating delay loop... 795.44 BogoMIPS (lpj=3977216)
[    0.040090] pid_max: default: 32768 minimum: 301
[    0.040217] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.040238] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.040825] CPU: Testing write buffer coherency: ok
[    0.041209] Setting up static identity map for 0x81e0 - 0x821c
[    0.041558] mvebu-soc-id: MVEBU SoC ID=0x6282, Rev=0x1
[    0.047290] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 19112604462750000 ns
[    0.047429] pinctrl core: initialized pinctrl subsystem
[    0.048746] NET: Registered protocol family 16
[    0.049248] DMA: preallocated 256 KiB pool for atomic coherent allocations
[    0.052997] cpuidle: using governor ladder
[    0.053554] Feroceon L2: Enabling L2
[    0.053603] Feroceon L2: Cache support initialised.
[    0.053930] [Firmware Info]: /ocp@f1000000/ethernet-controller@72000/ethernet0-port@0: local-mac-address is not set
[    0.054055] [Firmware Info]: /ocp@f1000000/ethernet-controller@76000/ethernet1-port@0: local-mac-address is not set
[    0.073095] SCSI subsystem initialized
[    0.073496] usbcore: registered new interface driver usbfs
[    0.073600] usbcore: registered new interface driver hub
[    0.073684] usbcore: registered new device driver usb
[    0.074967] clocksource: Switched to clocksource orion_clocksource
[    0.076190] NET: Registered protocol family 2
[    0.076972] TCP established hash table entries: 1024 (order: 0, 4096 bytes)
[    0.077005] TCP bind hash table entries: 1024 (order: 0, 4096 bytes)
[    0.077031] TCP: Hash tables configured (established 1024 bind 1024)
[    0.077095] UDP hash table entries: 256 (order: 0, 4096 bytes)
[    0.077123] UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
[    0.077312] NET: Registered protocol family 1
[    0.077382] PCI: CLS 0 bytes, default 32
[    0.078487] futex hash table entries: 256 (order: -1, 3072 bytes)
[    0.097671] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    0.097699] jffs2: version 2.2 (NAND) (SUMMARY) (LZMA) (RTIME) (CMODE_PRIORITY) (c) 2001-2006 Red Hat, Inc.
[    0.100705] io scheduler noop registered
[    0.100728] io scheduler deadline registered (default)
[    0.102290] kirkwood-pinctrl f1010000.pin-controller: registered pinctrl driver
[    0.103060] irq: Cannot allocate irq_descs @ IRQ31, assuming pre-allocated
[    0.103525] irq: Cannot allocate irq_descs @ IRQ63, assuming pre-allocated
[    0.104357] mvebu-pcie mbus:pcie-controller: PCI host bridge to bus 0000:00
[    0.104381] pci_bus 0000:00: root bus resource [io  0x1000-0xfffff]
[    0.104398] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xefffffff]
[    0.104414] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.104456] pci 0000:00:01.0: [11ab:6282] type 01 class 0x060400
[    0.104772] pci 0000:00:02.0: [11ab:6282] type 01 class 0x060400
[    0.105145] PCI: bus0: Fast back to back transfers disabled
[    0.105166] pci 0000:00:01.0: bridge configuration invalid ([bus 00-00]), reconfiguring
[    0.105186] pci 0000:00:02.0: bridge configuration invalid ([bus 00-00]), reconfiguring
[    0.105374] pci 0000:01:00.0: [11ab:2a41] type 00 class 0x020000
[    0.105438] pci 0000:01:00.0: reg 0x10: [mem 0x90000000-0x9000ffff 64bit]
[    0.105469] pci 0000:01:00.0: reg 0x18: [mem 0x90010000-0x9001ffff 64bit]
[    0.105811] PCI: bus1: Fast back to back transfers disabled
[    0.105833] pci_bus 0000:01: busn_res: [bus 01-ff] end is updated to 01
[    0.106020] pci 0000:02:00.0: [11ab:2a42] type 00 class 0x020000
[    0.106082] pci 0000:02:00.0: reg 0x10: [mem 0x98000000-0x9800ffff 64bit]
[    0.106114] pci 0000:02:00.0: reg 0x18: [mem 0x98010000-0x9801ffff 64bit]
[    0.106445] PCI: bus2: Fast back to back transfers disabled
[    0.106466] pci_bus 0000:02: busn_res: [bus 02-ff] end is updated to 02
[    0.106602] pci 0000:00:01.0: BAR 8: assigned [mem 0xe0000000-0xe00fffff]
[    0.106625] pci 0000:00:02.0: BAR 8: assigned [mem 0xe0100000-0xe01fffff]
[    0.106648] pci 0000:01:00.0: BAR 0: assigned [mem 0xe0000000-0xe000ffff 64bit]
[    0.106678] pci 0000:01:00.0: BAR 2: assigned [mem 0xe0010000-0xe001ffff 64bit]
[    0.106702] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.106722] pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xe00fffff]
[    0.106747] pci 0000:02:00.0: BAR 0: assigned [mem 0xe0100000-0xe010ffff 64bit]
[    0.106775] pci 0000:02:00.0: BAR 2: assigned [mem 0xe0110000-0xe011ffff 64bit]
[    0.106800] pci 0000:00:02.0: PCI bridge to [bus 02]
[    0.106817] pci 0000:00:02.0:   bridge window [mem 0xe0100000-0xe01fffff]
[    0.147001] Serial: 8250/16550 driver, 16 ports, IRQ sharing enabled
[    0.150640] console [ttyS0] disabled
[    0.150731] f1012000.serial: ttyS0 at MMIO 0xf1012000 (irq = 25, base_baud = 12500000) is a 16550A
[    0.762159] console [ttyS0] enabled
[    0.767145] nand: device found, Manufacturer ID: 0xad, Chip ID: 0x76
[    0.773529] nand: Hynix NAND 64MiB 3,3V 8-bit
[    0.777947] nand: 64 MiB, SLC, erase size: 16 KiB, page size: 512, OOB size: 16
[    0.785326] Scanning device for bad blocks
[    0.915084] Bad eraseblock 1168 at 0x000001240000
[    1.164093] Bad eraseblock 3441 at 0x0000035c4000
[    1.239152] mtd: bad character after partition (f)
[    1.244000] 8 ofpart partitions found on MTD device orion_nand
[    1.249880] Creating 8 MTD partitions on "orion_nand":
[    1.255062] 0x000000000000-0x000000080000 : "u-boot"
[    1.262008] 0x000000080000-0x000000084000 : "u_env"
[    1.268337] 0x000000084000-0x000000088000 : "s_env"
[    1.274598] 0x000000200000-0x000001600000 : "kernel1"
[    1.281554] 0x000000490000-0x000001600000 : "rootfs1"
[    1.288467] 0x000001600000-0x000002a00000 : "kernel2"
[    1.295447] 0x000001890000-0x000002a00000 : "ubi"
[    1.302004] 0x000002a00000-0x000004000000 : "syscfg"
[    1.309560] libphy: orion_mdio_bus: probed
[    1.313873] mv643xx_eth: MV-643xx 10/100/1000 ethernet driver version 1.4
[    1.322361] mv643xx_eth_port mv643xx_eth_port.0 eth0: port 0 with MAC address c0:56:27:ba:65:bd
[    1.331884] mv643xx_eth_port mv643xx_eth_port.1 eth1: port 0 with MAC address c0:56:27:ba:65:be
[    1.340715] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.347299] ehci-pci: EHCI PCI platform driver
[    1.351849] ehci-platform: EHCI generic platform driver
[    1.357313] ehci-orion: EHCI orion driver
[    1.361533] orion-ehci f1050000.ehci: EHCI Host Controller
[    1.367109] orion-ehci f1050000.ehci: new USB bus registered, assigned bus number 1
[    1.374953] orion-ehci f1050000.ehci: irq 29, io mem 0xf1050000
[    1.394997] orion-ehci f1050000.ehci: USB 2.0 started, EHCI 1.00
[    1.401886] hub 1-0:1.0: USB hub found
[    1.405920] hub 1-0:1.0: 1 port detected
[    1.410415] usbcore: registered new interface driver usb-storage
[    1.418717] NET: Registered protocol family 10
[    1.426472] NET: Registered protocol family 17
[    1.431008] bridge: automatic filtering via arp/ip/ip6tables has been deprecated. Update your scripts to load br_netfilter if you need this.
[    1.443749] Bridge firewalling registered
[    1.447806] 8021q: 802.1Q VLAN Support v1.8
[    1.454576] UBI: auto-attach mtd6
[    1.457781] ubi0: attaching mtd6
[    1.578240] ubi0: scanning is finished
[    1.591512] ubi0: attached mtd6 (name "ubi", size 17 MiB)
[    1.596983] ubi0: PEB size: 16384 bytes (16 KiB), LEB size: 15872 bytes
[    1.603632] ubi0: min./max. I/O unit sizes: 512/512, sub-page size 256
[    1.610208] ubi0: VID header offset: 256 (aligned 256), data offset: 512
[    1.616955] ubi0: good PEBs: 1116, bad PEBs: 0, corrupted PEBs: 0
[    1.623076] ubi0: user volume: 2, internal volumes: 1, max. volumes count: 92
[    1.630264] ubi0: max/mean erase counter: 2/0, WL threshold: 4096, image sequence number: 2053880514
[    1.639452] ubi0: available PEBs: 0, total reserved PEBs: 1116, PEBs reserved for bad PEB handling: 80
[    1.649195] ubi0: background thread "ubi_bgt0d" started, PID 880
[    1.656139] block ubiblock0_0: created from ubi0:0(rootfs)
[    1.661654] ubiblock: device ubiblock0_0 (rootfs) set to be root filesystem
[    1.669439] mvsw61xx 10.mvsw61xx: Found MV88E6171 at f1072004.mdio-bu:10
[    1.676204] mvsw61xx 10.mvsw61xx: Using indirect addressing
[    1.681900] hctosys: unable to open rtc device (rtc0)
[    1.694636] VFS: Mounted root (squashfs filesystem) readonly on device 254:0.
[    1.702360] Freeing unused kernel memory: 168K (c054c000 - c0576000)
[    2.416624] init: Console is alive
[    2.969528] libata version 3.00 loaded.
[    2.983121] init: - preinit -
[    3.314782] random: procd urandom read with 5 bits of entropy available
[    6.456509] UBIFS (ubi0:1): background thread "ubifs_bgt0_1" started, PID 929
[    6.463948] UBIFS (ubi0:1): recovery needed
[    6.509029] UBIFS (ubi0:1): recovery completed
[    6.513588] UBIFS (ubi0:1): UBIFS: mounted UBI device 0, volume 1, name "rootfs_data"
[    6.521490] UBIFS (ubi0:1): LEB size: 15872 bytes (15 KiB), min./max. I/O unit sizes: 512 bytes/512 bytes
[    6.531126] UBIFS (ubi0:1): FS size: 14173696 bytes (13 MiB, 893 LEBs), journal size 714240 bytes (0 MiB, 45 LEBs)
[    6.541540] UBIFS (ubi0:1): reserved for root: 669457 bytes (653 KiB)
[    6.548034] UBIFS (ubi0:1): media format: w4/r0 (latest is w4/r0), UUID 831EA53C-3EEC-4791-BDCA-04C694EC5AA7, small LPT model
[    6.563711] mount_root: switching to jffs2 overlay
[    6.580781] procd: - early -
[    7.627223] procd: - ubus -
[    7.682974] procd: - init -
[    8.324371] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    8.338027] i2c /dev entries driver
[    8.346003] Loading modules backported from Linux version v4.4-rc5-1913-gc8fdf68
[    8.353441] Backport generated by backports.git backports-20151218-0-g2f58d9d
[    8.364437] ip_tables: (C) 2000-2006 Netfilter Core Team
[    8.377523] nf_conntrack version 0.5.0 (923 buckets, 3692 max)
[    8.415845] xt_time: kernel timezone is -0000
[    8.458365] Marvell TOPDOG(R) 802.11 Wireless Network Driver version 0.13
[    8.465264] pci 0000:00:01.0: enabling device (0140 -> 0142)
[    9.183654] ieee80211 phy0: Command RF_ANTENNA error 0x2
[    9.189039] ieee80211 phy0: failed to set # of RX antennas
[    9.194586] ieee80211 phy0: Command RF_ANTENNA error 0x2
[    9.199953] ieee80211 phy0: failed to set # of TX antennas
[    9.205494] ieee80211 phy0: 88w8366 v48, c05627ba65bf, STA firmware 4.1.0.3
[    9.216323] pci 0000:00:02.0: enabling device (0140 -> 0142)
[    9.954864] ieee80211 phy1: Command RF_ANTENNA error 0x2
[    9.960242] ieee80211 phy1: failed to set # of RX antennas
[    9.965807] ieee80211 phy1: Command RF_ANTENNA error 0x2
[    9.971148] ieee80211 phy1: failed to set # of TX antennas
[    9.976695] ieee80211 phy1: 88w8366 v48, c05627ba65c1, STA firmware 4.1.0.3
[    9.993947] PPP generic driver version 2.4.2
[   10.012124] NET: Registered protocol family 24
[   16.026656] mv643xx_eth_port mv643xx_eth_port.0 eth0: link up, 1000 Mb/s, full duplex, flow control disabled
[   16.050211] device eth0 entered promiscuous mode
[   16.060715] IPv6: ADDRCONF(NETDEV_UP): br-lan: link is not ready
[   16.108612] mv643xx_eth_port mv643xx_eth_port.1 eth1: link up, 1000 Mb/s, full duplex, flow control disabled
[   17.025074] br-lan: port 1(eth0) entered forwarding state
[   17.030568] br-lan: port 1(eth0) entered forwarding state
[   17.056687] IPv6: ADDRCONF(NETDEV_CHANGE): br-lan: link becomes ready
[   18.216444] ieee80211 phy1: 88w8366 v7, c05627ba65c1, AP firmware 5.2.8.17
[   18.270954] IPv6: ADDRCONF(NETDEV_UP): wlan1: link is not ready
[   18.281775] device wlan1 entered promiscuous mode
[   19.024987] br-lan: port 1(eth0) entered forwarding state
[   21.288103] IPv6: ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
[   21.294651] br-lan: port 2(wlan1) entered forwarding state
[   21.300270] br-lan: port 2(wlan1) entered forwarding state
[   23.294989] br-lan: port 2(wlan1) entered forwarding state
[   36.623165] random: nonblocking pool is initialized


--XF85m9dhOBO43t/C--
