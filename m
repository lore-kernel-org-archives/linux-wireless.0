Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43412 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755017Ab1FTATZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jun 2011 20:19:25 -0400
Received: by yxi11 with SMTP id 11so1904062yxi.19
        for <linux-wireless@vger.kernel.org>; Sun, 19 Jun 2011 17:19:23 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 19 Jun 2011 18:19:23 -0600
Message-ID: <BANLkTimBt24ZmdAbYud-MdKGuGfA5U+gCA@mail.gmail.com> (sfid-20110620_021934_598499_9E4BC6CD)
Subject: UBNT AirRouter / ath9k / failure to initialize radio
From: Kelly Hogan <kshogan@bluemesh.net>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

Im working on getting ath9k to see the radio in the UBNT AirRouter,
and all looks normal until we try to initialize the radio and bring up
an interface.  We always return:

ath: Unable to reset hardware; reset status -5 (freq 2412 MHz)

Environment:

Linux OpenWrt 2.6.37.6 #1 Fri Jun 10 16:39:50 CEST 2011 mips GNU/Linux

trunk version of openwrt.

We are running the uniFi version of the openwrt bins, as they are
similar hardware.

Any help in where to look for ideas would be greatly appreciated.

Thanks!

iw list

Wiphy phy0
        Band 1:
                Capabilities: 0x11ce
                        HT20/HT40
                        SM Power Save disabled
                        RX HT40 SGI
                        TX STBC
                        RX STBC 1-stream
                        Max AMSDU length: 3839 bytes
                        DSSS/CCK HT40
                Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
                Minimum RX AMPDU time spacing: 8 usec (0x06)
                HT RX MCS rate indexes supported: 0-15
                TX unequal modulation not supported
                HT TX Max spatial streams: 1
                HT TX MCS rate indexes supported may differ
                Frequencies:
                        * 2412 MHz [1] (27.0 dBm)
                        * 2417 MHz [2] (27.0 dBm)
                        * 2422 MHz [3] (27.0 dBm)
                        * 2427 MHz [4] (27.0 dBm)
                        * 2432 MHz [5] (27.0 dBm)
                        * 2437 MHz [6] (27.0 dBm)
                        * 2442 MHz [7] (27.0 dBm)
                        * 2447 MHz [8] (27.0 dBm)
                        * 2452 MHz [9] (27.0 dBm)
                        * 2457 MHz [10] (27.0 dBm)
                        * 2462 MHz [11] (27.0 dBm)
                        * 2467 MHz [12] (disabled)
                        * 2472 MHz [13] (disabled)
                        * 2484 MHz [14] (disabled)
                Bitrates (non-HT):
                        * 1.0 Mbps
                        * 2.0 Mbps (short preamble supported)
                        * 5.5 Mbps (short preamble supported)
                        * 11.0 Mbps (short preamble supported)
                        * 6.0 Mbps
                        * 9.0 Mbps
                        * 12.0 Mbps
                        * 18.0 Mbps
                        * 24.0 Mbps
                        * 36.0 Mbps
                        * 48.0 Mbps
                        * 54.0 Mbps
        max # scan SSIDs: 4
        max scan IEs length: 2257 bytes
        Coverage class: 0 (up to 0m)
        Available Antennas: TX 0 RX 0
        Supported interface modes:
                 * IBSS
                 * managed
                 * AP
                 * AP/VLAN
                 * WDS
                 * monitor
                 * mesh point
                 * P2P-client
                 * P2P-GO
        Supported commands:
                 * new_interface
                 * set_interface
                 * new_key
                 * new_beacon
                 * new_station
                 * new_mpath
                 * set_mesh_params
                 * set_bss
                 * authenticate
                 * associate
                 * deauthenticate
                 * disassociate
                 * join_ibss
                 * join_mesh
                 * remain_on_channel
                 * set_tx_bitrate_mask
                 * action
                 * frame_wait_cancel
                 * set_wiphy_netns
                 * set_channel
                 * set_wds_peer
                 * connect
                 * disconnect
        Supported TX frame types:
                 * IBSS: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050
0x0060 0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
                 * managed: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050
0x0060 0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
                 * AP: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050
0x0060 0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
                 * AP/VLAN: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050
0x0060 0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
                 * mesh point: 0x0000 0x0010 0x0020 0x0030 0x0040
0x0050 0x0060 0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0
0x00f0
                 * P2P-client: 0x0000 0x0010 0x0020 0x0030 0x0040
0x0050 0x0060 0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0
0x00f0
                 * P2P-GO: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050
0x0060 0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
        Supported RX frame types:
                 * IBSS: 0x00d0
                 * managed: 0x0040 0x00d0
                 * AP: 0x0000 0x0020 0x0040 0x00a0 0x00b0 0x00c0 0x00d0
                 * AP/VLAN: 0x0000 0x0020 0x0040 0x00a0 0x00b0 0x00c0 0x00d0
                 * mesh point: 0x00b0 0x00c0 0x00d0
                 * P2P-client: 0x0040 0x00d0
                 * P2P-GO: 0x0000 0x0020 0x0040 0x00a0 0x00b0 0x00c0 0x00d0


dmesg:

Linux version 2.6.37.6 (buildslave@dd.das-iro.de) (gcc version 4.5.4
20110505 (prerelease) (Linaro GCC 4.5-2011.05-0) ) #1 Fri Jun 10
16:39:50 CEST 2011
prom: fw_arg0=00000006, fw_arg1=a1f7bfb0, fw_arg2=a1f7c460, fw_arg3=00000000
MyLoader: sysp=f0f0f0f0, boardp=f0f0f0f0, parts=f0f0f0f0
bootconsole [early0] enabled
CPU revision is: 00019374 (MIPS 24Kc)
SoC: Atheros AR7241 rev 1
Clocks: CPU:390.000MHz, DDR:390.000MHz, AHB:195.000MHz, Ref:5.000MHz
Determined physical RAM map:
 memory: 02000000 @ 00000000 (usable)
Initrd not found or empty - disabling initrd
Zone PFN ranges:
  Normal   0x00000000 -> 0x00002000
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0: 0x00000000 -> 0x00002000
On node 0 totalpages: 8192
free_area_init_node: node 0, pgdat 802bc2a0, node_mem_map 81000000
  Normal zone: 64 pages used for memmap
  Normal zone: 0 pages reserved
  Normal zone: 8128 pages, LIFO batch:0
pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
pcpu-alloc: [0] 0
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 8128
Kernel command line:  board=UBNT-XM console=ttyS0,115200
mtdparts=spi0.0:256k(u-boot)ro,64k(u-boot-env)ro,1024k(kernel),6528k(rootfs),256k(cfg)ro,64k(EEPROM)ro,7552k@0x50000(firmware)
rootfstype=squashfs,jffs2 nod
PID hash table entries: 128 (order: -3, 512 bytes)
Dentry cache hash table entries: 4096 (order: 2, 16384 bytes)
Inode-cache hash table entries: 2048 (order: 1, 8192 bytes)
Primary instruction cache 64kB, VIPT, 4-way, linesize 32 bytes.
Primary data cache 32kB, 4-way, VIPT, cache aliases, linesize 32 bytes
Writing ErrCtl register=00000000
Readback ErrCtl register=00000000
Memory: 29360k/32768k available (2036k kernel code, 3408k reserved,
381k data, 172k init, 0k highmem)
SLUB: Genslabs=9, HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
NR_IRQS:80
Calibrating delay loop... 259.68 BogoMIPS (lpj=1298432)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 512
NET: Registered protocol family 16
MIPS: machine is Ubiquiti UniFi
registering PCI controller with io_map_base unset
bio: create slab <bio-0> at 0
pci 0000:00:00.0: [168c:ff1c] type 0 class 0x000200
pci 0000:00:00.0: fixup device configuration
pci 0000:00:00.0: reg 10: [mem 0x00000000-0x0000ffff 64bit]
pci 0000:00:00.0: supports D1
pci 0000:00:00.0: PME# supported from D0 D1 D3hot
pci 0000:00:00.0: PME# disabled
pci 0000:00:00.0: BAR 0: assigned [mem 0x10000000-0x1000ffff 64bit]
pci 0000:00:00.0: BAR 0: set to [mem 0x10000000-0x1000ffff 64bit] (PCI
address [0x10000000-0x1000ffff])
PCI: mapping irq 72 to pin1@0000:00:00.0
Switching to clocksource MIPS
NET: Registered protocol family 2
IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
TCP established hash table entries: 1024 (order: 1, 8192 bytes)
TCP bind hash table entries: 1024 (order: 0, 4096 bytes)
TCP: Hash tables configured (established 1024 bind 1024)
TCP reno registered
UDP hash table entries: 256 (order: 0, 4096 bytes)
UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
NET: Registered protocol family 1
PCI: CLS 0 bytes, default 32
squashfs: version 4.0 (2009/01/31) Phillip Lougher
JFFS2 version 2.2 (NAND) (SUMMARY) (LZMA) (RTIME) (CMODE_PRIORITY) (c)
2001-2006 Red Hat, Inc.
msgmni has been set to 57
io scheduler noop registered
io scheduler deadline registered (default)
Serial: 8250/16550 driver, 1 ports, IRQ sharing disabled
serial8250.0: ttyS0 at MMIO 0x18020000 (irq = 11) is a 16550A
console [ttyS0] enabled, bootconsole disabled
Atheros AR71xx SPI Controller driver version 0.2.4
m25p80 spi0.0: found m25p64, expected m25p80
m25p80 spi0.0: m25p64 (8192 Kbytes)
7 cmdlinepart partitions found on MTD device spi0.0
Creating 7 MTD partitions on "spi0.0":
0x000000000000-0x000000040000 : "u-boot"
0x000000040000-0x000000050000 : "u-boot-env"
0x000000050000-0x000000150000 : "kernel"
0x000000150000-0x0000007b0000 : "rootfs"
mtd: partition "rootfs" set to be root filesystem
split_squashfs: no squashfs found in "spi0.0"
0x0000007b0000-0x0000007f0000 : "cfg"
0x0000007f0000-0x000000800000 : "EEPROM"
0x000000050000-0x0000007b0000 : "firmware"
ag71xx_mdio: probed
eth0: Atheros AG71xx at 0xb9000000, irq 4
eth0: connected to PHY at ag71xx-mdio:04 [uid=004dd041, driver=Generic PHY]
Atheros AR71xx hardware watchdog driver version 0.1.0
ar71xx-wdt: timeout=15 secs (max=22)
TCP westwood registered
NET: Registered protocol family 17
Bridge firewalling registered
802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
All bugs added by David S. Miller <davem@redhat.com>
JFFS2 notice: (1) jffs2_build_xattr_subsystem: complete building xattr
subsystem, 0 of xdatum (0 unchecked, 0 orphan) and 0 of xref (0 dead,
0 orphan) found.
VFS: Mounted root (jffs2 filesystem) readonly on device 31:3.
Freeing unused kernel memory: 172k freed
Button Hotplug driver version 0.4.1
Registered led device: ubnt:orange:dome
Registered led device: ubnt:green:dome
eth0: link up (100Mbps/Full duplex)
eth0: link down
device eth0 entered promiscuous mode
Compat-wireless backport release: compat-wireless-2011-05-23
Backport based on wireless-testing.git master-2011-05-27
eth0: link up (100Mbps/Full duplex)
br-lan: port 1(eth0) entering forwarding state
br-lan: port 1(eth0) entering forwarding state
cfg80211: Calling CRDA to update world regulatory domain
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
cfg80211: World regulatory domain updated:
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
PCI: Setting latency timer of device 0000:00:00.0 to 64
ath: EEPROM regdomain: 0x0
ath: EEPROM indicates default country code should be used
ath: doing EEPROM country->regdmn map search
ath: country maps to regdmn code: 0x3a
ath: Country alpha2 being used: US
ath: Regpair used: 0x3a
ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
Registered led device: ath9k-phy0
ieee80211 phy0: Atheros AR9285 Rev:2 mem=0xb0000000, irq=72
cfg80211: Calling CRDA for country: US
PPP generic driver version 2.4.2
ip_tables: (C) 2000-2006 Netfilter Core Team
cfg80211: Regulatory domain changed to country: US
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
cfg80211:     (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
NET: Registered protocol family 24
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
nf_conntrack version 0.5.0 (461 buckets, 1844 max)
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ath: Unable to reset hardware; reset status -5 (freq 2412 MHz)
ar71xx-wdt: enabling watchdog timer
ath: Unable to reset hardware; reset status -5 (freq 2412 MHz)
ath: Unable to reset hardware; reset status -5 (
