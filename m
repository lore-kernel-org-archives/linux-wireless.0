Return-Path: <SRS0=EPmr=NA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1882AC67863
	for <linux-wireless@archiver.kernel.org>; Sat, 20 Oct 2018 09:44:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC88621476
	for <linux-wireless@archiver.kernel.org>; Sat, 20 Oct 2018 09:44:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DC88621476
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727525AbeJTRyS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 20 Oct 2018 13:54:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49734 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727343AbeJTRyS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 20 Oct 2018 13:54:18 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AC6FB30832C2;
        Sat, 20 Oct 2018 09:44:27 +0000 (UTC)
Received: from localhost (ovpn-204-32.brq.redhat.com [10.40.204.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5C7844D4;
        Sat, 20 Oct 2018 09:44:26 +0000 (UTC)
Date:   Sat, 20 Oct 2018 11:44:25 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Tom Psyborg <pozega.tomislav@gmail.com>
Cc:     linux-wireless@vger.kernel.org,
        Daniel Golle <daniel@makrotopia.org>,
        Mathias Kresin <dev@kresin.me>, Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH v4 4/8] rt2800: fix registers init for MT7620
Message-ID: <20181020094424.GA20307@redhat.com>
References: <20181012120329.GD2118@redhat.com>
 <CAKR_QVKKiRFASfB=Rs7eUXKNt-Sqm7dTp2tBikOBatJxKvkJ0w@mail.gmail.com>
 <20181012122630.GB2668@redhat.com>
 <CAKR_QVLtJGzpBuz-BBi5yzFPoTUnadDdEXcwnR4XrB3DuWchjQ@mail.gmail.com>
 <20181016080922.GB4158@redhat.com>
 <CAKR_QVJ9T3EOhMoWPUv3x7-+NS54Y7cCRafM34pqve_4eV-zJQ@mail.gmail.com>
 <20181016154957.GA8730@redhat.com>
 <CAKR_QV+p_BP+xvqc65gHjm8t6fRNwfTRwKixCn7DN9+LjG-n3A@mail.gmail.com>
 <20181019090028.GA7023@redhat.com>
 <CAKR_QVJPKO6Au_WieKjeSZP9vRhFTqukhndgwYAnxAUuwziAaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="4Ckj6UjgE2iN1+kY"
Content-Disposition: inline
In-Reply-To: <CAKR_QVJPKO6Au_WieKjeSZP9vRhFTqukhndgwYAnxAUuwziAaQ@mail.gmail.com>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Sat, 20 Oct 2018 09:44:27 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 19, 2018 at 04:21:09PM +0200, Tom Psyborg wrote:
> On 19/10/2018, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> >
> > I tried to do this, but somehow after update BUILD1 image into device
> > my configuration was wiped out :-( and I have to reconfigure the
> > device now. Anyway I'm going to test and provide dmesg , but this
> > will take some time.
> >
> > Regards
> > Stanislaw
> >
> 
> that's because these builds were done on 4.4 that i had in my system
> and there are config differences between these builds and current
> snapshot. to save you time i need only bootlogs not wifi performance
> tests.

So, there is no diffrence in dmesg and device is recognized as RT6352.
I atteched both dmesg's for the record.

Regards
Stanislaw


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="BUILD1.dmesg.txt"

[    0.000000] Linux version 4.9.73 (ubuntu@ubuntu) (gcc version 5.5.0 (OpenWrt GCC 5.5.0 r5682-b153dbf) ) #0 Fri Jan 5 10:59:59 2018
[    0.000000] Board has DDR1
[    0.000000] Analog PMU set to hw control
[    0.000000] Digital PMU set to hw control
[    0.000000] SoC Type: MediaTek MT7620N ver:2 eco:6
[    0.000000] bootconsole [early0] enabled
[    0.000000] CPU0 revision is: 00019650 (MIPS 24KEc)
[    0.000000] MIPS: machine is Nexx WT3020 (8M)
[    0.000000] Determined physical RAM map:
[    0.000000]  memory: 04000000 @ 00000000 (usable)
[    0.000000] Initrd not found or empty - disabling initrd
[    0.000000] Primary instruction cache 64kB, VIPT, 4-way, linesize 32 bytes.
[    0.000000] Primary data cache 32kB, 4-way, PIPT, no aliases, linesize 32 bytes
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x0000000000000000-0x0000000003ffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000000000-0x0000000003ffffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000000000-0x0000000003ffffff]
[    0.000000] On node 0 totalpages: 16384
[    0.000000] free_area_init_node: node 0, pgdat 803af724, node_mem_map 81000020
[    0.000000]   Normal zone: 128 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 16384 pages, LIFO batch:3
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
[    0.000000] pcpu-alloc: [0] 0 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 16256
[    0.000000] Kernel command line: console=ttyS0,57600 rootfstype=squashfs,jffs2
[    0.000000] PID hash table entries: 256 (order: -2, 1024 bytes)
[    0.000000] Dentry cache hash table entries: 8192 (order: 3, 32768 bytes)
[    0.000000] Inode-cache hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Writing ErrCtl register=0003f290
[    0.000000] Readback ErrCtl register=0003f290
[    0.000000] Memory: 60708K/65536K available (2912K kernel code, 144K rwdata, 720K rodata, 184K init, 210K bss, 4828K reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] NR_IRQS:256
[    0.000000] CPU Clock: 580MHz
[    0.000000] clocksource: systick: mask: 0xffff max_cycles: 0xffff, max_idle_ns: 583261500 ns
[    0.000000] systick: enable autosleep mode
[    0.000000] systick: running - mult: 214748, shift: 32
[    0.000000] clocksource: MIPS: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 6590553264 ns
[    0.000011] sched_clock: 32 bits at 290MHz, resolution 3ns, wraps every 7405115902ns
[    0.015451] Calibrating delay loop... 385.84 BogoMIPS (lpj=1929216)
[    0.080614] pid_max: default: 32768 minimum: 301
[    0.089921] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.102950] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.122146] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 19112604462750000 ns
[    0.141623] futex hash table entries: 256 (order: -1, 3072 bytes)
[    0.153770] pinctrl core: initialized pinctrl subsystem
[    0.164734] NET: Registered protocol family 16
[    0.193594] rt2880_gpio 10000600.gpio: registering 24 gpios
[    0.204618] rt2880_gpio 10000600.gpio: registering 24 irq handlers
[    0.217201] rt2880_gpio 10000660.gpio: registering 32 gpios
[    0.228189] rt2880_gpio 10000660.gpio: registering 32 irq handlers
[    0.240725] rt2880_gpio 10000688.gpio: registering 1 gpios
[    0.251533] rt2880_gpio 10000688.gpio: registering 1 irq handlers
[    0.267228] clocksource: Switched to clocksource systick
[    0.278917] NET: Registered protocol family 2
[    0.288380] TCP established hash table entries: 1024 (order: 0, 4096 bytes)
[    0.302151] TCP bind hash table entries: 1024 (order: 0, 4096 bytes)
[    0.314747] TCP: Hash tables configured (established 1024 bind 1024)
[    0.327466] UDP hash table entries: 256 (order: 0, 4096 bytes)
[    0.339003] UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
[    0.351666] NET: Registered protocol family 1
[    0.360231] PCI: CLS 0 bytes, default 32
[    0.362405] rt-timer 10000100.timer: maximum frequency is 1220Hz
[    0.375038] Crashlog allocated RAM at address 0x3f00000
[    0.386437] workingset: timestamp_bits=30 max_order=14 bucket_order=0
[    0.407190] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    0.418689] jffs2: version 2.2 (NAND) (SUMMARY) (LZMA) (RTIME) (CMODE_PRIORITY) (c) 2001-2006 Red Hat, Inc.
[    0.446316] io scheduler noop registered
[    0.454010] io scheduler deadline registered (default)
[    0.464396] ralink-usb-phy usbphy: invalid resource
[    0.474527] Serial: 8250/16550 driver, 2 ports, IRQ sharing disabled
[    0.488166] console [ttyS0] disabled
[    0.495153] 10000c00.uartlite: ttyS0 at MMIO 0x10000c00 (irq = 20, base_baud = 2500000) is a Palmchip BK-3103
[    0.514923] console [ttyS0] enabled
[    0.528706] bootconsole [early0] disabled
[    0.548747] spi spi0.0: force spi mode3
[    0.557103] m25p80 spi0.0: s25fl064k (8192 Kbytes)
[    0.566737] 4 ofpart partitions found on MTD device spi0.0
[    0.577668] Creating 4 MTD partitions on "spi0.0":
[    0.587225] 0x000000000000-0x000000030000 : "u-boot"
[    0.598728] 0x000000030000-0x000000040000 : "u-boot-env"
[    0.611161] 0x000000040000-0x000000050000 : "factory"
[    0.623060] 0x000000050000-0x000000800000 : "firmware"
[    0.679040] 2 uimage-fw partitions found on MTD device firmware
[    0.690883] 0x000000050000-0x000000185c89 : "kernel"
[    0.702349] 0x000000185c89-0x000000800000 : "rootfs"
[    0.714076] mtd: device 5 (rootfs) set to be root filesystem
[    0.725948] 1 squashfs-split partitions found on MTD device rootfs
[    0.738322] 0x000000500000-0x000000800000 : "rootfs_data"
[    0.751334] libphy: Fixed MDIO Bus: probed
[    0.763164] mtk_soc_eth 10100000.ethernet: loaded mt7620 driver
[    0.775813] mtk_soc_eth 10100000.ethernet eth0: mediatek frame engine at 0xb0100000, irq 5
[    0.792810] rt2880_wdt 10000120.watchdog: Initialized
[    0.803452] NET: Registered protocol family 17
[    0.812412] 8021q: 802.1Q VLAN Support v1.8
[    0.835948] VFS: Mounted root (squashfs filesystem) readonly on device 31:5.
[    0.851051] Freeing unused kernel memory: 184K
[    0.859933] This architecture does not have kernel memory protection.
[    2.552839] init: Console is alive
[    2.559905] init: - watchdog -
[    2.637187] random: fast init done
[    4.753882] kmodloader: loading kernel modules from /etc/modules-boot.d/*
[    5.026940] usbcore: registered new interface driver usbfs
[    5.038040] usbcore: registered new interface driver hub
[    5.048758] usbcore: registered new device driver usb
[    5.064401] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    5.079109] ehci-platform: EHCI generic platform driver
[    5.099868] phy phy-usbphy.0: remote usb device wakeup disabled
[    5.111672] phy phy-usbphy.0: UTMI 16bit 30MHz
[    5.120559] ehci-platform 101c0000.ehci: EHCI Host Controller
[    5.132052] ehci-platform 101c0000.ehci: new USB bus registered, assigned bus number 1
[    5.147963] ehci-platform 101c0000.ehci: irq 26, io mem 0x101c0000
[    5.169582] ehci-platform 101c0000.ehci: USB 2.0 started, EHCI 1.00
[    5.183115] hub 1-0:1.0: USB hub found
[    5.190973] hub 1-0:1.0: 1 port detected
[    5.201814] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    5.215587] ohci-platform: OHCI generic platform driver
[    5.226319] ohci-platform 101c1000.ohci: Generic Platform OHCI controller
[    5.239919] ohci-platform 101c1000.ohci: new USB bus registered, assigned bus number 2
[    5.255809] ohci-platform 101c1000.ohci: irq 26, io mem 0x101c1000
[    5.294056] hub 2-0:1.0: USB hub found
[    5.301954] hub 2-0:1.0: 1 port detected
[    5.312495] kmodloader: done loading kernel modules from /etc/modules-boot.d/*
[    5.331112] init: - preinit -
[    7.291794] 8021q: adding VLAN 0 to HW filter on device eth0
[    8.713650] jffs2_scan_eraseblock(): End of filesystem marker found at 0x10000
[    8.728085] jffs2_build_filesystem(): unlocking the mtd device... 
[    8.740062] done.
[    8.743886] jffs2_build_filesystem(): erasing all blocks after the end marker... 
[   21.742699] done.
[   21.746576] jffs2: notice: (326) jffs2_build_xattr_subsystem: complete building xattr subsystem, 0 of xdatum (0 unchecked, 0 orphan) and 0 of xref (0 dead, 0 orphan) found.
[   21.779256] mount_root: overlay filesystem has not been fully initialized yet
[   21.813658] mount_root: switching to jffs2 overlay
[   22.273659] urandom-seed: Seed file not found (/etc/urandom.seed)
[   22.406324] procd: - early -
[   22.412943] procd: - watchdog -
[   22.687776] procd: - watchdog -
[   22.694401] procd: - ubus -
[   22.891447] procd: - init -
[   23.338422] kmodloader: loading kernel modules from /etc/modules.d/*
[   23.357273] Loading modules backported from Linux version wt-2017-11-01-0-gfe248fc2c180
[   23.373288] Backport generated by backports.git v4.14-rc2-1-31-g86cf0e5d
[   23.394531] nf_conntrack version 0.5.0 (1024 buckets, 4096 max)
[   23.463679] xt_time: kernel timezone is -0000
[   23.492833] ip_tables: (C) 2000-2006 Netfilter Core Team
[   23.553033] PPP generic driver version 2.4.2
[   23.564396] NET: Registered protocol family 24
[   23.631494] rt2800_wmac 10180000.wmac: loaded eeprom from mtd device "factory"
[   23.645960] ieee80211 phy0: rt2x00_set_rt: Info - RT chipset 6352, rev 0500 detected
[   23.661418] ieee80211 phy0: rt2x00_set_rf: Info - RF chipset 7620 detected
[   23.675814] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[   23.699557] usbcore: registered new interface driver rt2800usb
[   23.818150] usbcore: registered new interface driver ath9k_htc
[   23.831039] kmodloader: done loading kernel modules from /etc/modules.d/*
[   34.462869] 8021q: adding VLAN 0 to HW filter on device eth0
[   34.508019] br-lan: port 1(eth0.1) entered blocking state
[   34.518854] br-lan: port 1(eth0.1) entered disabled state
[   34.530017] device eth0.1 entered promiscuous mode
[   34.539600] device eth0 entered promiscuous mode
[   34.654634] br-lan: port 1(eth0.1) entered blocking state
[   34.665458] br-lan: port 1(eth0.1) entered forwarding state
[   40.437728] br-lan: port 1(eth0.1) entered disabled state
[   40.474772] br-lan: port 2(wlan0) entered blocking state
[   40.485438] br-lan: port 2(wlan0) entered disabled state
[   40.496446] device wlan0 entered promiscuous mode
[   41.113018] br-lan: port 2(wlan0) entered blocking state
[   41.123641] br-lan: port 2(wlan0) entered forwarding state
[   41.820846] br-lan: port 1(eth0.1) entered blocking state
[   41.831666] br-lan: port 1(eth0.1) entered forwarding state

--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="BUILD2.dmesg.txt"

[    0.000000] Linux version 4.9.73 (ubuntu@ubuntu) (gcc version 5.5.0 (OpenWrt GCC 5.5.0 r5682-b153dbf) ) #0 Fri Jan 5 10:59:59 2018
[    0.000000] Board has DDR1
[    0.000000] Analog PMU set to hw control
[    0.000000] Digital PMU set to hw control
[    0.000000] SoC Type: MediaTek MT7620N ver:2 eco:6
[    0.000000] bootconsole [early0] enabled
[    0.000000] CPU0 revision is: 00019650 (MIPS 24KEc)
[    0.000000] MIPS: machine is Nexx WT3020 (8M)
[    0.000000] Determined physical RAM map:
[    0.000000]  memory: 04000000 @ 00000000 (usable)
[    0.000000] Initrd not found or empty - disabling initrd
[    0.000000] Primary instruction cache 64kB, VIPT, 4-way, linesize 32 bytes.
[    0.000000] Primary data cache 32kB, 4-way, PIPT, no aliases, linesize 32 bytes
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x0000000000000000-0x0000000003ffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000000000-0x0000000003ffffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000000000-0x0000000003ffffff]
[    0.000000] On node 0 totalpages: 16384
[    0.000000] free_area_init_node: node 0, pgdat 803af724, node_mem_map 81000020
[    0.000000]   Normal zone: 128 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 16384 pages, LIFO batch:3
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
[    0.000000] pcpu-alloc: [0] 0 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 16256
[    0.000000] Kernel command line: console=ttyS0,57600 rootfstype=squashfs,jffs2
[    0.000000] PID hash table entries: 256 (order: -2, 1024 bytes)
[    0.000000] Dentry cache hash table entries: 8192 (order: 3, 32768 bytes)
[    0.000000] Inode-cache hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Writing ErrCtl register=0003f290
[    0.000000] Readback ErrCtl register=0003f290
[    0.000000] Memory: 60708K/65536K available (2912K kernel code, 144K rwdata, 720K rodata, 184K init, 210K bss, 4828K reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] NR_IRQS:256
[    0.000000] CPU Clock: 580MHz
[    0.000000] clocksource: systick: mask: 0xffff max_cycles: 0xffff, max_idle_ns: 583261500 ns
[    0.000000] systick: enable autosleep mode
[    0.000000] systick: running - mult: 214748, shift: 32
[    0.000000] clocksource: MIPS: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 6590553264 ns
[    0.000011] sched_clock: 32 bits at 290MHz, resolution 3ns, wraps every 7405115902ns
[    0.015451] Calibrating delay loop... 385.84 BogoMIPS (lpj=1929216)
[    0.080607] pid_max: default: 32768 minimum: 301
[    0.089913] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.102943] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.122139] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 19112604462750000 ns
[    0.141618] futex hash table entries: 256 (order: -1, 3072 bytes)
[    0.153763] pinctrl core: initialized pinctrl subsystem
[    0.164727] NET: Registered protocol family 16
[    0.193588] rt2880_gpio 10000600.gpio: registering 24 gpios
[    0.204611] rt2880_gpio 10000600.gpio: registering 24 irq handlers
[    0.217196] rt2880_gpio 10000660.gpio: registering 32 gpios
[    0.228184] rt2880_gpio 10000660.gpio: registering 32 irq handlers
[    0.240720] rt2880_gpio 10000688.gpio: registering 1 gpios
[    0.251528] rt2880_gpio 10000688.gpio: registering 1 irq handlers
[    0.267223] clocksource: Switched to clocksource systick
[    0.278913] NET: Registered protocol family 2
[    0.288376] TCP established hash table entries: 1024 (order: 0, 4096 bytes)
[    0.302147] TCP bind hash table entries: 1024 (order: 0, 4096 bytes)
[    0.314743] TCP: Hash tables configured (established 1024 bind 1024)
[    0.327462] UDP hash table entries: 256 (order: 0, 4096 bytes)
[    0.338999] UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
[    0.351662] NET: Registered protocol family 1
[    0.360227] PCI: CLS 0 bytes, default 32
[    0.362401] rt-timer 10000100.timer: maximum frequency is 1220Hz
[    0.375034] Crashlog allocated RAM at address 0x3f00000
[    0.386433] workingset: timestamp_bits=30 max_order=14 bucket_order=0
[    0.407187] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    0.418686] jffs2: version 2.2 (NAND) (SUMMARY) (LZMA) (RTIME) (CMODE_PRIORITY) (c) 2001-2006 Red Hat, Inc.
[    0.446313] io scheduler noop registered
[    0.454007] io scheduler deadline registered (default)
[    0.464392] ralink-usb-phy usbphy: invalid resource
[    0.474523] Serial: 8250/16550 driver, 2 ports, IRQ sharing disabled
[    0.488163] console [ttyS0] disabled
[    0.495150] 10000c00.uartlite: ttyS0 at MMIO 0x10000c00 (irq = 20, base_baud = 2500000) is a Palmchip BK-3103
[    0.514920] console [ttyS0] enabled
[    0.528703] bootconsole [early0] disabled
[    0.548743] spi spi0.0: force spi mode3
[    0.557098] m25p80 spi0.0: s25fl064k (8192 Kbytes)
[    0.566731] 4 ofpart partitions found on MTD device spi0.0
[    0.577662] Creating 4 MTD partitions on "spi0.0":
[    0.587219] 0x000000000000-0x000000030000 : "u-boot"
[    0.598721] 0x000000030000-0x000000040000 : "u-boot-env"
[    0.611154] 0x000000040000-0x000000050000 : "factory"
[    0.623053] 0x000000050000-0x000000800000 : "firmware"
[    0.679029] 2 uimage-fw partitions found on MTD device firmware
[    0.690873] 0x000000050000-0x000000185c89 : "kernel"
[    0.702340] 0x000000185c89-0x000000800000 : "rootfs"
[    0.714067] mtd: device 5 (rootfs) set to be root filesystem
[    0.725939] 1 squashfs-split partitions found on MTD device rootfs
[    0.738312] 0x000000500000-0x000000800000 : "rootfs_data"
[    0.751325] libphy: Fixed MDIO Bus: probed
[    0.763154] mtk_soc_eth 10100000.ethernet: loaded mt7620 driver
[    0.775803] mtk_soc_eth 10100000.ethernet eth0: mediatek frame engine at 0xb0100000, irq 5
[    0.792802] rt2880_wdt 10000120.watchdog: Initialized
[    0.803443] NET: Registered protocol family 17
[    0.812405] 8021q: 802.1Q VLAN Support v1.8
[    0.835941] VFS: Mounted root (squashfs filesystem) readonly on device 31:5.
[    0.851044] Freeing unused kernel memory: 184K
[    0.859926] This architecture does not have kernel memory protection.
[    2.552869] init: Console is alive
[    2.559936] init: - watchdog -
[    2.637179] random: fast init done
[    4.754118] kmodloader: loading kernel modules from /etc/modules-boot.d/*
[    5.027260] usbcore: registered new interface driver usbfs
[    5.038317] usbcore: registered new interface driver hub
[    5.049033] usbcore: registered new device driver usb
[    5.064638] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    5.079350] ehci-platform: EHCI generic platform driver
[    5.100108] phy phy-usbphy.0: remote usb device wakeup disabled
[    5.111911] phy phy-usbphy.0: UTMI 16bit 30MHz
[    5.120796] ehci-platform 101c0000.ehci: EHCI Host Controller
[    5.132289] ehci-platform 101c0000.ehci: new USB bus registered, assigned bus number 1
[    5.148201] ehci-platform 101c0000.ehci: irq 26, io mem 0x101c0000
[    5.169736] ehci-platform 101c0000.ehci: USB 2.0 started, EHCI 1.00
[    5.183270] hub 1-0:1.0: USB hub found
[    5.191126] hub 1-0:1.0: 1 port detected
[    5.201966] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    5.215744] ohci-platform: OHCI generic platform driver
[    5.226473] ohci-platform 101c1000.ohci: Generic Platform OHCI controller
[    5.240074] ohci-platform 101c1000.ohci: new USB bus registered, assigned bus number 2
[    5.255964] ohci-platform 101c1000.ohci: irq 26, io mem 0x101c1000
[    5.294208] hub 2-0:1.0: USB hub found
[    5.302108] hub 2-0:1.0: 1 port detected
[    5.312644] kmodloader: done loading kernel modules from /etc/modules-boot.d/*
[    5.331276] init: - preinit -
[    7.294190] 8021q: adding VLAN 0 to HW filter on device eth0
[    8.720519] jffs2_scan_eraseblock(): End of filesystem marker found at 0x10000
[    8.734948] jffs2_build_filesystem(): unlocking the mtd device... 
[    8.746920] done.
[    8.750763] jffs2_build_filesystem(): erasing all blocks after the end marker... 
[   21.560944] done.
[   21.564823] jffs2: notice: (327) jffs2_build_xattr_subsystem: complete building xattr subsystem, 0 of xdatum (0 unchecked, 0 orphan) and 0 of xref (0 dead, 0 orphan) found.
[   21.597479] mount_root: overlay filesystem has not been fully initialized yet
[   21.631804] mount_root: switching to jffs2 overlay
[   22.092048] urandom-seed: Seed file not found (/etc/urandom.seed)
[   22.225140] procd: - early -
[   22.231057] procd: - watchdog -
[   22.506591] procd: - watchdog -
[   22.513116] procd: - ubus -
[   22.710100] procd: - init -
[   23.156989] kmodloader: loading kernel modules from /etc/modules.d/*
[   23.175863] Loading modules backported from Linux version wt-2017-11-01-0-gfe248fc2c180
[   23.191876] Backport generated by backports.git v4.14-rc2-1-31-g86cf0e5d
[   23.213051] nf_conntrack version 0.5.0 (1024 buckets, 4096 max)
[   23.284767] xt_time: kernel timezone is -0000
[   23.313913] ip_tables: (C) 2000-2006 Netfilter Core Team
[   23.374477] PPP generic driver version 2.4.2
[   23.385852] NET: Registered protocol family 24
[   23.452696] rt2800_wmac 10180000.wmac: loaded eeprom from mtd device "factory"
[   23.467162] ieee80211 phy0: rt2x00_set_rt: Info - RT chipset 6352, rev 0500 detected
[   23.482621] ieee80211 phy0: rt2x00_set_rf: Info - RF chipset 7620 detected
[   23.497016] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[   23.520822] usbcore: registered new interface driver rt2800usb
[   23.639371] usbcore: registered new interface driver ath9k_htc
[   23.652266] kmodloader: done loading kernel modules from /etc/modules.d/*
[   34.235987] 8021q: adding VLAN 0 to HW filter on device eth0
[   34.279728] br-lan: port 1(eth0.1) entered blocking state
[   34.290564] br-lan: port 1(eth0.1) entered disabled state
[   34.301732] device eth0.1 entered promiscuous mode
[   34.311321] device eth0 entered promiscuous mode
[   34.425063] br-lan: port 1(eth0.1) entered blocking state
[   34.435885] br-lan: port 1(eth0.1) entered forwarding state
[   40.235344] br-lan: port 1(eth0.1) entered disabled state
[   40.266543] br-lan: port 2(wlan0) entered blocking state
[   40.277215] br-lan: port 2(wlan0) entered disabled state
[   40.288224] device wlan0 entered promiscuous mode
[   40.910514] br-lan: port 2(wlan0) entered blocking state
[   40.921138] br-lan: port 2(wlan0) entered forwarding state
[   41.780483] br-lan: port 1(eth0.1) entered blocking state
[   41.791304] br-lan: port 1(eth0.1) entered forwarding state

--4Ckj6UjgE2iN1+kY--
