Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f170.google.com ([209.85.160.170]:34578 "EHLO
	mail-yk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbbKIGCb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2015 01:02:31 -0500
Received: by ykfs79 with SMTP id s79so19985427ykf.1
        for <linux-wireless@vger.kernel.org>; Sun, 08 Nov 2015 22:02:31 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 9 Nov 2015 00:02:31 -0600
Message-ID: <CADLC3L1xeetwWLn1FbSyzvFYHvPw2z8C3OmQ-w9Bi0U=iLqZiA@mail.gmail.com> (sfid-20151109_070259_018185_7B9A08C2)
Subject: ath10k AP "failed to delete peer" errors when using Nexus 5X
From: Robert Hancock <hancockrwd@gmail.com>
To: ath10k@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm using OpenWRT on a TP-Link Archer C7, currently running
development rev 47397 which is kernel 4.1.1 and compat-wireless
2015-10-26. Ever since I got a new Nexus 5X phone, it seems like
periodically (once a day or so), the 5GHz wireless (using ath10k)
craps out and I get a bunch of errors in the kernel log on the router.
I have to reboot the router to get the 5GHz working again. Full kernel
log from one of these failures is below. Any thoughts on what is going
on here?

There are reports of a newer Android build (which I don't have yet)
which supposedly has some wireless fixes on the Nexus 5X, but I'm not
sure what it could be doing that would be causing the router to crap
out like this.

[    0.000000] Linux version 4.1.11 (rob@haswell) (gcc version 4.8.3
(OpenWrt/Linaro GCC 4.8-2014.04 r47397) ) #2 Fri Nov 6 19:13:48 CST
2015
[    0.000000] MyLoader: sysp=fdfbfbfe, boardp=feef7ff7, parts=7ffdddfd
[    0.000000] bootconsole [early0] enabled
[    0.000000] CPU0 revision is: 00019750 (MIPS 74Kc)
[    0.000000] SoC: Qualcomm Atheros QCA9558 ver 1 rev 0
[    0.000000] Determined physical RAM map:
[    0.000000]  memory: 08000000 @ 00000000 (usable)
[    0.000000] Initrd not found or empty - disabling initrd
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x0000000000000000-0x0000000007ffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000000000-0x0000000007ffffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000000000-0x0000000007ffffff]
[    0.000000] On node 0 totalpages: 32768
[    0.000000] free_area_init_node: node 0, pgdat 80387de0,
node_mem_map 81000000
[    0.000000]   Normal zone: 256 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 32768 pages, LIFO batch:7
[    0.000000] Primary instruction cache 64kB, VIPT, 4-way, linesize 32 bytes.
[    0.000000] Primary data cache 32kB, 4-way, VIPT, cache aliases,
linesize 32 bytes
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
[    0.000000] pcpu-alloc: [0] 0
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 32512
[    0.000000] Kernel command line:  board=ARCHER-C7
console=ttyS0,115200 rootfstype=squashfs,jffs2 noinitrd
[    0.000000] PID hash table entries: 512 (order: -1, 2048 bytes)
[    0.000000] Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
[    0.000000] Writing ErrCtl register=00000000
[    0.000000] Readback ErrCtl register=00000000
[    0.000000] Memory: 125724K/131072K available (2705K kernel code,
132K rwdata, 492K rodata, 244K init, 195K bss, 5348K reserved, 0K
cma-reserved)
[    0.000000] SLUB: HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] NR_IRQS:83
[    0.000000] Clocks: CPU:720.000MHz, DDR:600.000MHz, AHB:200.000MHz,
Ref:40.000MHz
[    0.000000] clocksource MIPS: mask: 0xffffffff max_cycles:
0xffffffff, max_idle_ns: 5309056796 ns
[    0.000007] sched_clock: 32 bits at 360MHz, resolution 2ns, wraps
every 5965232126ns
[    0.007494] Calibrating delay loop... 358.80 BogoMIPS (lpj=1794048)
[    0.070069] pid_max: default: 32768 minimum: 301
[    0.074616] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.080950] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.089791] clocksource jiffies: mask: 0xffffffff max_cycles:
0xffffffff, max_idle_ns: 19112604462750000 ns
[    0.099691] NET: Registered protocol family 16
[    0.104900] MIPS: machine is TP-LINK Archer C7
[    0.112241] ar724x-pci ar724x-pci.0: PCIe link is down
[    0.117138] registering PCI controller with io_map_base unset
[    0.122818] registering PCI controller with io_map_base unset
[    0.570262] PCI host bridge to bus 0000:00
[    0.574190] pci_bus 0000:00: root bus resource [mem 0x10000000-0x11ffffff]
[    0.580791] pci_bus 0000:00: root bus resource [io  0x0000]
[    0.586173] pci_bus 0000:00: root bus resource [??? 0x00000000 flags 0x0]
[    0.592714] pci_bus 0000:00: No busn resource found for root bus,
will use [bus 00-ff]
[    0.600386] pci_bus 0000:00: busn_res: [bus 00-ff] end is updated to 00
[    0.600493] PCI host bridge to bus 0000:01
[    0.604374] pci_bus 0000:01: root bus resource [mem 0x12000000-0x13ffffff]
[    0.611025] pci_bus 0000:01: root bus resource [io  0x0001]
[    0.616385] pci_bus 0000:01: root bus resource [??? 0x00000000 flags 0x0]
[    0.622945] pci_bus 0000:01: No busn resource found for root bus,
will use [bus 01-ff]
[    0.630614] pci 0000:01:00.0: [168c:003c] type 00 class 0x028000
[    0.630656] pci 0000:01:00.0: reg 0x10: [mem 0x00000000-0x001fffff 64bit]
[    0.630710] pci 0000:01:00.0: reg 0x30: [mem 0x00000000-0x0000ffff pref]
[    0.630761] pci 0000:01:00.0: supports D1 D2
[    0.630929] pci_bus 0000:01: busn_res: [bus 01-ff] end is updated to 01
[    0.630956] pci 0000:01:00.0: BAR 0: assigned [mem
0x12000000-0x121fffff 64bit]
[    0.637988] pci 0000:01:00.0: BAR 6: assigned [mem
0x12200000-0x1220ffff pref]
[    0.644924] pci 0000:01:00.0: using irq 41 for pin 1
[    0.650334] Switched to clocksource MIPS
[    0.655078] NET: Registered protocol family 2
[    0.659947] TCP established hash table entries: 1024 (order: 0, 4096 bytes)
[    0.666646] TCP bind hash table entries: 1024 (order: 0, 4096 bytes)
[    0.672771] TCP: Hash tables configured (established 1024 bind 1024)
[    0.678941] UDP hash table entries: 256 (order: 0, 4096 bytes)
[    0.684553] UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
[    0.690802] NET: Registered protocol family 1
[    0.695003] PCI: CLS 0 bytes, default 32
[    0.695788] futex hash table entries: 256 (order: -1, 3072 bytes)
[    0.715155] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    0.720764] jffs2: version 2.2 (NAND) (SUMMARY) (LZMA) (RTIME)
(CMODE_PRIORITY) (c) 2001-2006 Red Hat, Inc.
[    0.732434] io scheduler noop registered
[    0.736158] io scheduler deadline registered (default)
[    0.741318] Serial: 8250/16550 driver, 1 ports, IRQ sharing disabled
[    0.747710] console [ttyS0] disabled
[    0.771167] serial8250.0: ttyS0 at MMIO 0x18020000 (irq = 11,
base_baud = 2500000) is a 16550A
[    0.779430] console [ttyS0] enabled
[    0.786473] bootconsole [early0] disabled
[    0.796641] m25p80 spi0.0: found s25fl128s, expected m25p80
[    0.802344] m25p80 spi0.0: s25fl128s (16384 Kbytes)
[    0.808273] 5 tp-link partitions found on MTD device spi0.0
[    0.813958] Creating 5 MTD partitions on "spi0.0":
[    0.818817] 0x000000000000-0x000000020000 : "u-boot"
[    0.824556] 0x000000020000-0x000000145410 : "kernel"
[    0.830226] 0x000000145410-0x000000ff0000 : "rootfs"
[    0.835926] mtd: device 2 (rootfs) set to be root filesystem
[    0.841739] 1 squashfs-split partitions found on MTD device rootfs
[    0.848006] 0x000000810000-0x000000ff0000 : "rootfs_data"
[    0.854109] 0x000000ff0000-0x000001000000 : "art"
[    0.859505] 0x000000020000-0x000000ff0000 : "firmware"
[    0.878558] switch0: Atheros AR8327 rev. 4 switch registered on ag71xx-mdio.0
[    0.968232] libphy: ag71xx_mdio: probed
[    1.561841] ag71xx ag71xx.0: connected to PHY at ag71xx-mdio.0:00
[uid=004dd034, driver=Atheros AR8216/AR8236/AR8316]
[    1.573155] eth0: Atheros AG71xx at 0xb9000000, irq 4, mode:RGMII
[    2.161928] eth1: Atheros AG71xx at 0xba000000, irq 5, mode:SGMII
[    2.169974] NET: Registered protocol family 10
[    2.177521] NET: Registered protocol family 17
[    2.182140] bridge: automatic filtering via arp/ip/ip6tables has
been deprecated. Update your scripts to load br_netfilter if you need
this.
[    2.195063] 8021q: 802.1Q VLAN Support v1.8
[    2.206007] VFS: Mounted root (squashfs filesystem) readonly on device 31:2.
[    2.214066] Freeing unused kernel memory: 244K (803a3000 - 803e0000)
[    3.302448] init: Console is alive
[    3.306067] init: - watchdog -
[    5.170168] usbcore: registered new interface driver usbfs
[    5.175841] usbcore: registered new interface driver hub
[    5.181340] usbcore: registered new device driver usb
[    5.217629] SCSI subsystem initialized
[    5.226141] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    5.233933] ehci-platform: EHCI generic platform driver
[    5.239305] ehci-platform ehci-platform.0: EHCI Host Controller
[    5.245373] ehci-platform ehci-platform.0: new USB bus registered,
assigned bus number 1
[    5.255639] ehci-platform ehci-platform.0: TX-TX IDP fix enabled
[    5.261758] ehci-platform ehci-platform.0: irq 48, io mem 0x1b000000
[    5.280394] ehci-platform ehci-platform.0: USB 2.0 started, EHCI 1.00
[    5.287611] hub 1-0:1.0: USB hub found
[    5.291703] hub 1-0:1.0: 1 port detected
[    5.295972] ehci-platform ehci-platform.1: EHCI Host Controller
[    5.302041] ehci-platform ehci-platform.1: new USB bus registered,
assigned bus number 2
[    5.312328] ehci-platform ehci-platform.1: TX-TX IDP fix enabled
[    5.318433] ehci-platform ehci-platform.1: irq 49, io mem 0x1b400000
[    5.340357] ehci-platform ehci-platform.1: USB 2.0 started, EHCI 1.00
[    5.347582] hub 2-0:1.0: USB hub found
[    5.351673] hub 2-0:1.0: 1 port detected
[    5.357954] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    5.365304] ohci-platform: OHCI generic platform driver
[    5.373937] usbcore: registered new interface driver usb-storage
[    6.327488] init: - preinit -
[    7.457758] eth1: link up (1000Mbps/Full duplex)
[    7.479186] random: procd urandom read with 11 bits of entropy available
[    9.691240] jffs2_scan_eraseblock(): End of filesystem marker found
at 0x10000
[    9.698593] jffs2_build_filesystem(): unlocking the mtd device... done.
[    9.705323] jffs2_build_filesystem(): erasing all blocks after the
end marker... done.
[   35.582050] jffs2: notice: (421) jffs2_build_xattr_subsystem:
complete building xattr subsystem, 0 of xdatum (0 unchecked, 0 orphan)
and 0 of xref (0 dead, 0 orphan) found.
[   35.600056] mount_root: overlay filesystem has not been fully initialized yet
[   35.622116] mount_root: switching to jffs2 overlay
[   36.417605] eth1: link down
[   36.429278] procd: - early -
[   36.432755] procd: - watchdog -
[   37.114600] procd: - ubus -
[   38.131293] procd: - init -
[   39.755417] sit: IPv6 over IPv4 tunneling driver
[   39.781809] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   39.806282] Netfilter messages via NETLINK v0.30.
[   39.822108] ip_set: protocol 6
[   39.892131] Loading modules backported from Linux version
master-2015-10-26-0-g28c26cb
[   39.900163] Backport generated by backports.git backports-20150903-4-g12cf266
[   39.946899] cfg80211: World regulatory domain updated:
[   39.952155] cfg80211:  DFS Master region: unset
[   39.956573] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp), (dfs_cac_time)
[   39.966462] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz),
(N/A, 2000 mBm), (N/A)
[   39.974590] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz),
(N/A, 2000 mBm), (N/A)
[   39.982716] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz),
(N/A, 2000 mBm), (N/A)
[   39.990846] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz,
160000 KHz AUTO), (N/A, 2000 mBm), (N/A)
[   40.000473] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz,
160000 KHz AUTO), (N/A, 2000 mBm), (0 s)
[   40.010088] cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz),
(N/A, 2000 mBm), (0 s)
[   40.018300] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz),
(N/A, 2000 mBm), (N/A)
[   40.026422] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000
KHz), (N/A, 0 mBm), (N/A)
[   40.197787] PCI: Enabling device 0000:01:00.0 (0000 -> 0002)
[   40.206052] ath10k_pci 0000:01:00.0: pci irq legacy interrupts 0
irq_mode 0 reset_mode 0
[   40.424955] ath10k_pci 0000:01:00.0: Direct firmware load for
ath10k/cal-pci-0000:01:00.0.bin failed with error -2
[   40.435487] ath10k_pci 0000:01:00.0: Falling back to user helper
[   47.824999] ath10k_pci 0000:01:00.0: Direct firmware load for
ath10k/QCA988X/hw2.0/board-2.bin failed with error -2
[   47.835603] ath10k_pci 0000:01:00.0: Falling back to user helper
[   47.909137] firmware ath10k!QCA988X!hw2.0!board-2.bin:
firmware_loading_store: map pages failed
[   48.952798] ath10k_pci 0000:01:00.0: qca988x hw2.0 (0x4100016c,
0x043202ff sub 0000:0000) fw 10.2.4.70-2 fwapi 5 bdapi 1 htt-ver 2.1
wmi-op 5 htt-op 2 cal file max-sta 128 raw 0 hwcrypto 1 features
no-p2p
[   48.971250] ath10k_pci 0000:01:00.0: debug 0 debugfs 1 tracing 0
dfs 1 testmode 1
[   49.073330] ath: EEPROM regdomain: 0x0
[   49.073344] ath: EEPROM indicates default country code should be used
[   49.073351] ath: doing EEPROM country->regdmn map search
[   49.073368] ath: country maps to regdmn code: 0x3a
[   49.073377] ath: Country alpha2 being used: US
[   49.073384] ath: Regpair used: 0x3a
[   49.084806] cfg80211: Regulatory domain changed to country: US
[   49.090754] cfg80211:  DFS Master region: FCC
[   49.094994] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp), (dfs_cac_time)
[   49.104883] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz),
(N/A, 3000 mBm), (N/A)
[   49.113012] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz,
160000 KHz AUTO), (N/A, 2300 mBm), (N/A)
[   49.122636] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz,
160000 KHz AUTO), (N/A, 2300 mBm), (0 s)
[   49.132257] cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz),
(N/A, 2300 mBm), (0 s)
[   49.140467] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz),
(N/A, 3000 mBm), (N/A)
[   49.148579] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000
KHz), (N/A, 4000 mBm), (N/A)
[   49.321549] u32 classifier
[   49.324303]     input device check on
[   49.328015]     Actions configured
[   49.333525] Mirror/redirect action on
[   49.345180] nf_conntrack version 0.5.0 (1968 buckets, 7872 max)
[   49.431031] ip_tables: (C) 2000-2006 Netfilter Core Team
[   49.498783] usbcore: registered new interface driver usblp
[   49.541194] xt_time: kernel timezone is -0000
[   49.562392] PPP generic driver version 2.4.2
[   49.569154] NET: Registered protocol family 24
[   49.588769] ath: EEPROM regdomain: 0x0
[   49.588786] ath: EEPROM indicates default country code should be used
[   49.588793] ath: doing EEPROM country->regdmn map search
[   49.588810] ath: country maps to regdmn code: 0x3a
[   49.588819] ath: Country alpha2 being used: US
[   49.588827] ath: Regpair used: 0x3a
[   49.602252] ieee80211 phy1: Selected rate control algorithm 'minstrel_ht'
[   49.604647] ieee80211 phy1: Atheros AR9550 Rev:0 mem=0xb8100000, irq=47
[   57.140725] eth1: link up (1000Mbps/Full duplex)
[   57.158885] device eth1 entered promiscuous mode
[   57.171135] IPv6: ADDRCONF(NETDEV_UP): br-lan: link is not ready
[   57.203413] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   58.232000] br-lan: port 1(eth1) entered forwarding state
[   58.237527] br-lan: port 1(eth1) entered forwarding state
[   58.284610] cfg80211: Regulatory domain changed to country: CA
[   58.290571] cfg80211:  DFS Master region: FCC
[   58.294813] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp), (dfs_cac_time)
[   58.304708] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz),
(N/A, 3000 mBm), (N/A)
[   58.312832] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz,
160000 KHz AUTO), (N/A, 1700 mBm), (N/A)
[   58.322460] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz,
160000 KHz AUTO), (N/A, 2400 mBm), (0 s)
[   58.332086] cfg80211:   (5490000 KHz - 5600000 KHz @ 80000 KHz),
(N/A, 2400 mBm), (0 s)
[   58.340197] cfg80211:   (5650000 KHz - 5730000 KHz @ 80000 KHz),
(N/A, 2400 mBm), (0 s)
[   58.348322] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz),
(N/A, 3000 mBm), (N/A)
[   58.655019] IPv6: ADDRCONF(NETDEV_CHANGE): br-lan: link becomes ready
[   60.230369] br-lan: port 1(eth1) entered forwarding state
[   60.260888] eth0: link up (1000Mbps/Full duplex)
[   62.120018] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   62.127295] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   62.167836] IPv6: ADDRCONF(NETDEV_UP): wlan1: link is not ready
[   62.213830] device wlan0 entered promiscuous mode
[   62.261092] Atheros AR8216/AR8236/AR8316 ag71xx-mdio.0:00: Port 1 is up
[   62.269142] Atheros AR8216/AR8236/AR8316 ag71xx-mdio.0:00: Port 5 is up
[   62.333558] device wlan1 entered promiscuous mode
[   62.338395] br-lan: port 3(wlan1) entered forwarding state
[   62.344014] br-lan: port 3(wlan1) entered forwarding state
[   63.120569] br-lan: port 3(wlan1) entered disabled state
[   64.050399] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   64.056989] br-lan: port 2(wlan0) entered forwarding state
[   64.062612] br-lan: port 2(wlan0) entered forwarding state
[   66.060370] br-lan: port 2(wlan0) entered forwarding state
[   71.815252] IPv6: ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
[   71.821920] br-lan: port 3(wlan1) entered forwarding state
[   71.827524] br-lan: port 3(wlan1) entered forwarding state
[   71.959631] random: nonblocking pool is initialized
[   73.820366] br-lan: port 3(wlan1) entered forwarding state
[ 1622.881675] Atheros AR8216/AR8236/AR8316 ag71xx-mdio.0:00: Port 4 is up
[ 1872.447808] ath10k_pci 0000:01:00.0: failed to delete peer
64:bc:0c:46:e4:55 for vdev 0: -145
[ 1872.456456] ------------[ cut here ]------------
[ 1872.461289] WARNING: CPU: 0 PID: 2159 at
/home/rob/openwrt/build_dir/target-mips_34kc_musl-1.1.11/linux-ar71xx_generic/compat-wireless-2015-10-26/net/mac80211/sta_info.c:918
sta_set_sinfo+0x938/0x9d0 [mac80211]()
[ 1872.480434] Modules linked in: pppoe ppp_async iptable_nat ath9k
pppox ppp_generic nf_nat_ipv4 nf_conntrack_ipv6 nf_conntrack_ipv4
ipt_REJECT ipt_MASQUERADE ath9k_common xt_time xt_tcpudp xt_tcpmss
xt_string xt_statistic xt_state xt_recent xt_nat xt_multiport xt_mark
xt_mac xt_limit xt_length xt_id xt_hl xt_helper xt_ecn xt_dscp
xt_conntrack xt_connmark xt_connlimit xt_connbytes xt_comment
xt_TCPMSS xt_REDIRECT xt_LOG xt_HL xt_DSCP xt_CT xt_CLASSIFY usblp
ts_kmp ts_fsm ts_bm slhc nf_reject_ipv4 nf_nat_redirect
nf_nat_masquerade_ipv4 nf_nat_ftp nf_nat nf_log_ipv4 nf_defrag_ipv6
nf_defrag_ipv4 nf_conntrack_rtcache nf_conntrack_ftp iptable_raw
iptable_mangle iptable_filter ipt_ECN ip_tables crc_ccitt ath9k_hw
em_cmp em_nbyte sch_teql sch_dsmark sch_tbf sch_pie act_ipt sch_gred
sch_htb cls_basic sch_prio
[ 1872.552989]  em_meta act_police em_text sch_codel sch_fq sch_sfq
sch_red act_connmark nf_conntrack act_skbedit act_mirred em_u32
cls_u32 cls_tcindex cls_flow cls_route cls_fw sch_hfsc sch_ingress
ath10k_pci ath10k_core ath mac80211 cfg80211 compat ledtrig_usbdev
xt_set ip_set_list_set ip_set_hash_netiface ip_set_hash_netport
ip_set_hash_netnet ip_set_hash_net ip_set_hash_netportnet
ip_set_hash_mac ip_set_hash_ipportnet ip_set_hash_ipportip
ip_set_hash_ipport ip_set_hash_ipmark ip_set_hash_ip
ip_set_bitmap_port ip_set_bitmap_ipmac ip_set_bitmap_ip ip_set
nfnetlink ip6t_REJECT nf_reject_ipv6 nf_log_ipv6 nf_log_common
ip6table_raw ip6table_mangle ip6table_filter ip6_tables x_tables msdos
ifb sit tunnel4 ip_tunnel vfat fat usb_storage ohci_platform ohci_hcd
ehci_platform ehci_hcd sd_mod scsi_mod gpio_button_hotplug
[ 1872.625088]  ext4 jbd2 mbcache usbcore nls_base usb_common crc16 crypto_hash
[ 1872.631011] CPU: 0 PID: 2159 Comm: hostapd Not tainted 4.1.11 #2
[ 1872.637099] Stack : 803e42d2 00000034 00000000 00000001 8033cbac
80388723 8799afc0 0000086f
 803e3524 00000000 00000004 00000008 00000000 800a5d34 00000003 80341f20
 00000396 00000000 80340434 858177e4 00000000 800a43bc 803e42d2 000000c8
 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
 ...
[ 1872.673496] Call Trace:
[ 1872.675991] [<80072124>] show_stack+0x50/0x84
[ 1872.680437] [<800819ec>] warn_slowpath_common+0xa0/0xd0
[ 1872.685784] [<80081aa4>] warn_slowpath_null+0x18/0x24
[ 1872.691035] [<873869ec>] sta_set_sinfo+0x938/0x9d0 [mac80211]

[ 1872.698439] ---[ end trace 6751cc6390d26847 ]---
[ 2178.626996] ath10k_pci 0000:01:00.0: failed to install key for vdev
0 peer 8c:3a:e3:15:29:f3: -145
[ 2178.636103] wlan0: failed to remove key (0, 8c:3a:e3:15:29:f3) from
hardware (-145)
[ 2178.657904] ath10k_pci 0000:01:00.0: cipher 0 is not supported
[ 2178.663879] ath10k_pci 0000:01:00.0: failed to remove peer wep key 0: -122
[ 2178.670920] ath10k_pci 0000:01:00.0: failed to clear all peer wep
keys for vdev 0: -122
[ 2178.679067] ath10k_pci 0000:01:00.0: failed to disassociate
station: 8c:3a:e3:15:29:f3 vdev 0: -122
[ 2178.688309] ------------[ cut here ]------------
[ 2178.693108] WARNING: CPU: 0 PID: 2159 at
/home/rob/openwrt/build_dir/target-mips_34kc_musl-1.1.11/linux-ar71xx_generic/compat-wireless-2015-10-26/net/mac80211/sta_info.c:910
sta_set_sinfo+0x8e8/0x9d0 [mac80211]()
[ 2178.712266] Modules linked in: pppoe ppp_async iptable_nat ath9k
pppox ppp_generic nf_nat_ipv4 nf_conntrack_ipv6 nf_conntrack_ipv4
ipt_REJECT ipt_MASQUERADE ath9k_common xt_time xt_tcpudp xt_tcpmss
xt_string xt_statistic xt_state xt_recent xt_nat xt_multiport xt_mark
xt_mac xt_limit xt_length xt_id xt_hl xt_helper xt_ecn xt_dscp
xt_conntrack xt_connmark xt_connlimit xt_connbytes xt_comment
xt_TCPMSS xt_REDIRECT xt_LOG xt_HL xt_DSCP xt_CT xt_CLASSIFY usblp
ts_kmp ts_fsm ts_bm slhc nf_reject_ipv4 nf_nat_redirect
nf_nat_masquerade_ipv4 nf_nat_ftp nf_nat nf_log_ipv4 nf_defrag_ipv6
nf_defrag_ipv4 nf_conntrack_rtcache nf_conntrack_ftp iptable_raw
iptable_mangle iptable_filter ipt_ECN ip_tables crc_ccitt ath9k_hw
em_cmp em_nbyte sch_teql sch_dsmark sch_tbf sch_pie act_ipt sch_gred
sch_htb cls_basic sch_prio
[ 2178.784793]  em_meta act_police em_text sch_codel sch_fq sch_sfq
sch_red act_connmark nf_conntrack act_skbedit act_mirred em_u32
cls_u32 cls_tcindex cls_flow cls_route cls_fw sch_hfsc sch_ingress
ath10k_pci ath10k_core ath mac80211 cfg80211 compat ledtrig_usbdev
xt_set ip_set_list_set ip_set_hash_netiface ip_set_hash_netport
ip_set_hash_netnet ip_set_hash_net ip_set_hash_netportnet
ip_set_hash_mac ip_set_hash_ipportnet ip_set_hash_ipportip
ip_set_hash_ipport ip_set_hash_ipmark ip_set_hash_ip
ip_set_bitmap_port ip_set_bitmap_ipmac ip_set_bitmap_ip ip_set
nfnetlink ip6t_REJECT nf_reject_ipv6 nf_log_ipv6 nf_log_common
ip6table_raw ip6table_mangle ip6table_filter ip6_tables x_tables msdos
ifb sit tunnel4 ip_tunnel vfat fat usb_storage ohci_platform ohci_hcd
ehci_platform ehci_hcd sd_mod scsi_mod gpio_button_hotplug
[ 2178.856831]  ext4 jbd2 mbcache usbcore nls_base usb_common crc16 crypto_hash
[ 2178.862745] CPU: 0 PID: 2159 Comm: hostapd Tainted: G        W
 4.1.11 #2
[ 2178.870085] Stack : 803e42d2 00000042 00000000 00000001 8033cbac
80388723 8799afc0 0000086f
 803e3524 00000000 00000004 00000008 00000000 800a5d34 00000003 80341f20
 0000038e 00000000 80340434 858177e4 00000000 800a43bc 803e42d2 000000c8
 80387890 00000000 00000000 00000000 00000000 00000000 00000000 00000000
 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
 ...
[ 2178.906727] Call Trace:
[ 2178.909253] [<80072124>] show_stack+0x50/0x84
[ 2178.913681] [<800819ec>] warn_slowpath_common+0xa0/0xd0
[ 2178.919009] [<80081aa4>] warn_slowpath_null+0x18/0x24
[ 2178.924239] [<8738699c>] sta_set_sinfo+0x8e8/0x9d0 [mac80211]

[ 2178.931641] ---[ end trace 6751cc6390d26848 ]---
[ 2181.926812] ath10k_pci 0000:01:00.0: failed to delete peer
8c:3a:e3:15:29:f3 for vdev 0: -11
[ 2184.946721] ath10k_pci 0000:01:00.0: failed to set beacon mode for
vdev 0: -11
[ 2187.946538] ath10k_pci 0000:01:00.0: failed to set dtim period for
vdev 0: -11
[ 2190.986373] ath10k_pci 0000:01:00.0: failed to recalculate rts/cts
prot for vdev 0: -11
[ 2193.986210] ath10k_pci 0000:01:00.0: failed to set protection mode
0 on vdev 0: -11
[ 2196.986045] ath10k_pci 0000:01:00.0: failed to set preamble for vdev 0: -11
