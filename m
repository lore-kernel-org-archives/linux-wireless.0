Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f179.google.com ([209.85.128.179]:38384 "EHLO
        mail-wr0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751107AbdLZRUg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Dec 2017 12:20:36 -0500
Received: by mail-wr0-f179.google.com with SMTP id o2so34978216wro.5
        for <linux-wireless@vger.kernel.org>; Tue, 26 Dec 2017 09:20:35 -0800 (PST)
Date: Tue, 26 Dec 2017 18:20:22 +0100 (CET)
From: Enrico Mioso <mrkiko.rs@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Arnd Bergmann <arnd@arndb.de>, John Crispin <john@phrozen.org>,
        nbd@nbd.name
Subject: Re: ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping
 frame due to full tx queue...?
In-Reply-To: <20171213152017.GA3554@redhat.com>
Message-ID: <alpine.LNX.2.21.99.1712261820080.22705@localhost.localdomain> (sfid-20171226_182041_710107_537E55B8)
References: <alpine.LNX.2.21.99.1712112132480.7817@localhost.localdomain> <20171213152017.GA3554@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ok, observing a stall. Unfortunately, it still happens.
Ufh...
dmesg:

may I do something else?



Linux version 4.9.70 (mrkiko@gatosaldo) (gcc version 5.5.0 (OpenWrt GCC 5.5.0 r5616-67c1c145f0) ) #0 Sun Dec 24 16:06:16 2017
SoC Type: Ralink RT3350 id:1 rev:2
bootconsole [early0] enabled
CPU0 revision is: 0001964c (MIPS 24KEc)
MIPS: machine is Asus WL-330N3G
Determined physical RAM map:
  memory: 02000000 @ 00000000 (usable)
Initrd not found or empty - disabling initrd
Primary instruction cache 32kB, VIPT, 4-way, linesize 32 bytes.
Primary data cache 16kB, 4-way, VIPT, no aliases, linesize 32 bytes
Zone ranges:
   Normal   [mem 0x0000000000000000-0x0000000001ffffff]
Movable zone start for each node
Early memory node ranges
   node   0: [mem 0x0000000000000000-0x0000000001ffffff]
Initmem setup node 0 [mem 0x0000000000000000-0x0000000001ffffff]
On node 0 totalpages: 8192
free_area_init_node: node 0, pgdat 8037e834, node_mem_map 81000020
   Normal zone: 64 pages used for memmap
   Normal zone: 0 pages reserved
   Normal zone: 8192 pages, LIFO batch:0
pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
pcpu-alloc: [0] 0 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 8128
Kernel command line: console=ttyS0,57600 rootfstype=squashfs,jffs2
PID hash table entries: 128 (order: -3, 512 bytes)
Dentry cache hash table entries: 4096 (order: 2, 16384 bytes)
Inode-cache hash table entries: 2048 (order: 1, 8192 bytes)
Writing ErrCtl register=0003c00b
Readback ErrCtl register=0003c00b
Memory: 28436K/32768K available (3061K kernel code, 147K rwdata, 372K rodata, 188K init, 200K bss, 4332K reserved, 0K cma-reserved)
SLUB: HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
NR_IRQS:256
CPU Clock: 320MHz
clocksource_probe: no matching clocksources found
clocksource: MIPS: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 11945377789 ns
sched_clock: 32 bits at 160MHz, resolution 6ns, wraps every 13421772796ns
Calibrating delay loop... 212.58 BogoMIPS (lpj=1062912)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
Mountpoint-cache hash table entries: 1024 (order: 0, 4096 bytes)
clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 19112604462750000 ns
futex hash table entries: 256 (order: -1, 3072 bytes)
pinctrl core: initialized pinctrl subsystem
NET: Registered protocol family 16
Can't analyze schedule() prologue at 802f97f0
rt2880_gpio 10000600.gpio: registering 24 gpios
rt2880_gpio 10000600.gpio: registering 24 irq handlers
clocksource: Switched to clocksource MIPS
NET: Registered protocol family 2
TCP established hash table entries: 1024 (order: 0, 4096 bytes)
TCP bind hash table entries: 1024 (order: 0, 4096 bytes)
TCP: Hash tables configured (established 1024 bind 1024)
UDP hash table entries: 256 (order: 0, 4096 bytes)
UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
NET: Registered protocol family 1
rt-timer 10000100.timer: maximum frequency is 3255Hz
workingset: timestamp_bits=30 max_order=13 bucket_order=0
squashfs: version 4.0 (2009/01/31) Phillip Lougher
jffs2: version 2.2 (NAND) (SUMMARY) (LZMA) (RTIME) (CMODE_PRIORITY) (c) 2001-2006 Red Hat, Inc.
io scheduler noop registered
io scheduler deadline registered (default)
Serial: 8250/16550 driver, 2 ports, IRQ sharing disabled
console [ttyS0] disabled
10000c00.uartlite: ttyS0 at MMIO 0x10000c00 (irq = 20, base_baud = 6666666) is a Palmchip BK-3103
console [ttyS0] enabled
bootconsole [early0] disabled
spi spi0.0: force spi mode3
m25p80 spi0.0: w25q32 (4096 Kbytes)
4 ofpart partitions found on MTD device spi0.0
Creating 4 MTD partitions on "spi0.0":
0x000000000000-0x000000030000 : "u-boot"
0x000000030000-0x000000040000 : "u-boot-env"
0x000000040000-0x000000050000 : "factory"
0x000000050000-0x000000400000 : "firmware"
2 uimage-fw partitions found on MTD device firmware
0x000000050000-0x0000001758ed : "kernel"
0x0000001758ed-0x000000400000 : "rootfs"
mtd: device 5 (rootfs) set to be root filesystem
1 squashfs-split partitions found on MTD device rootfs
0x00000032c000-0x000000400000 : "rootfs_data"
libphy: Fixed MDIO Bus: probed
rt3050-esw 10110000.esw: link changed 0x10
mtk_soc_eth 10100000.ethernet eth0: mediatek frame engine at 0xb0100000, irq 5
rt2880_wdt 10000120.watchdog: Initialized
NET: Registered protocol family 10
NET: Registered protocol family 17
8021q: 802.1Q VLAN Support v1.8
VFS: Mounted root (squashfs filesystem) readonly on device 31:5.
Freeing unused kernel memory: 188K
This architecture does not have kernel memory protection.
random: fast init done
init: Console is alive
init: - watchdog -
kmodloader: loading kernel modules from /etc/modules-boot.d/*
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
dwc2 101c0000.otg: Configuration mismatch. dr_mode forced to host
dwc2 101c0000.otg: DWC OTG Controller
dwc2 101c0000.otg: new USB bus registered, assigned bus number 1
dwc2 101c0000.otg: irq 26, io mem 0x00000000
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 1 port detected
kmodloader: done loading kernel modules from /etc/modules-boot.d/*
init: - preinit -
8021q: adding VLAN 0 to HW filter on device eth0
jffs2: notice: (311) jffs2_build_xattr_subsystem: complete building xattr subsystem, 0 of xdatum (0 unchecked, 0 orphan) and 0 of xref (0 dead, 0 orphan) found.
mount_root: switching to jffs2 overlay
urandom-seed: Seeding with /etc/urandom.seed
procd: - early -
procd: - watchdog -
procd: - watchdog -
procd: - ubus -
procd: - init -
kmodloader: loading kernel modules from /etc/modules.d/*
ip6_tables: (C) 2000-2006 Netfilter Core Team
Loading modules backported from Linux version wt-2017-11-01-0-gfe248fc2c180
Backport generated by backports.git v4.14-rc2-1-31-g86cf0e5d
ip_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (1024 buckets, 4096 max)
xt_time: kernel timezone is -0000
rt2800_wmac 10180000.wmac: loaded eeprom from mtd device "factory"
ieee80211 phy0: rt2x00_set_rt: Info - RT chipset 2872, rev 0200 detected
ieee80211 phy0: rt2x00_set_rf: Info - RF chipset 0005 detected
ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
kmodloader: done loading kernel modules from /etc/modules.d/*
8021q: adding VLAN 0 to HW filter on device eth0
br-lan: port 1(eth0.1) entered blocking state
br-lan: port 1(eth0.1) entered disabled state
device eth0.1 entered promiscuous mode
device eth0 entered promiscuous mode
br-lan: port 1(eth0.1) entered blocking state
br-lan: port 1(eth0.1) entered forwarding state
IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
br-lan: port 2(wlan0) entered blocking state
br-lan: port 2(wlan0) entered disabled state
device wlan0 entered promiscuous mode
IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
br-lan: port 2(wlan0) entered blocking state
br-lan: port 2(wlan0) entered forwarding state
random: crng init done
rt3050-esw 10110000.esw: link changed 0x00
rt3050-esw 10110000.esw: link changed 0x10
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
