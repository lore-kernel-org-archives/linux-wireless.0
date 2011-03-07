Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:34299 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755132Ab1CGLmc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2011 06:42:32 -0500
Subject: Re: WARN_ON in ieee80211_scan_completed_finish triggered
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>,
	Ben Greear <greearb@candelatech.com>
In-Reply-To: <1299491485.3790.2.camel@jlt3.sipsolutions.net> (sfid-20110307_105130_457515_FFFFFFFF997C7B78)
References: <1299443142.1292.6.camel@marge>
	 <1299491485.3790.2.camel@jlt3.sipsolutions.net>
	 (sfid-20110307_105130_457515_FFFFFFFF997C7B78)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Mar 2011 12:42:27 +0100
Message-ID: <1299498147.5665.3.camel@marge>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-03-07 at 10:51 +0100, Johannes Berg wrote:
> On Sun, 2011-03-06 at 21:25 +0100, Michael Buesch wrote:
> > I just noticed the following warning on my p54spi device
> > with compat-wireless-2011-02-25 (OpenWrt):
> > 
> 
> > [ 1182.826599] WARNING: at net/mac80211/scan.c:310 ieee80211_rx_bss_free+0x20c/0x4b8 [mac80211]()
> 
> Unfortunately the backtrace gives no hint at all, is it possible that
> there was an ifdown that canceled the scan?

I don't think there was an ifdown.
It seems that it happened right after a regulatory
update. See printk timestamps in the full kernel log:

[    0.000000] Linux version 2.6.38-rc7 (mb@marge) (gcc version 4.5.2 (Linaro GCC 4.5-2011.02-0) ) #6 PREEMPT Sun Mar 6 20:40:45 CET 2011
[    0.000000] CPU: ARMv6-compatible processor [4107b362] revision 2 (ARMv6TEJ), cr=00c5387f
[    0.000000] CPU: VIPT aliasing data cache, unknown instruction cache
[    0.000000] Machine: Nokia N810
[    0.000000] Memory policy: ECC disabled, Data cache writeback
[    0.000000] OMAP2420
[    0.000000] 
[    0.000000] SRAM: Mapped pa 0x40200000 to va 0xfe400000 size: 0xa0000
[    0.000000] On node 0 totalpages: 32768
[    0.000000] free_area_init_node: node 0, pgdat c03eb718, node_mem_map c044b000
[    0.000000]   Normal zone: 256 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 32512 pages, LIFO batch:7
[    0.000000] Clocking rate (Crystal/DPLL/MPU): 19.2/658/329 MHz
[    0.000000] GPMC revision 2.0
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
[    0.000000] pcpu-alloc: [0] 0 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 32512
[    0.000000] Kernel command line: root=/dev/mmcblk0p1 rootfstype=ext4,ext3,ext2,squashfs,jffs2 console=tty0 console=ttyO2,115200n8 earlyprintk
[    0.000000] PID hash table entries: 512 (order: -1, 2048 bytes)
[    0.000000] Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
[    0.000000] Memory: 128MB = 128MB total
[    0.000000] Memory: 125508k/125508k available, 5564k reserved, 0K highmem
[    0.000000] Virtual kernel memory layout:
[    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
[    0.000000]     fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
[    0.000000]     DMA     : 0xffc00000 - 0xffe00000   (   2 MB)
[    0.000000]     vmalloc : 0xc8800000 - 0xf8000000   ( 760 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xc8000000   ( 128 MB)
[    0.000000]     modules : 0xbf000000 - 0xc0000000   (  16 MB)
[    0.000000]       .init : 0xc0008000 - 0xc002a000   ( 136 kB)
[    0.000000]       .text : 0xc002a000 - 0xc03c0704   (3674 kB)
[    0.000000]       .data : 0xc03c2000 - 0xc03ebdc0   ( 168 kB)
[    0.000000] SLUB: Genslabs=13, HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] NR_IRQS:391
[    0.000000] IRQ: Found an INTC at 0xfa0fe000 (revision 2.0) with 96 interrupts
[    0.000000] Total of 96 interrupts on 1 active controller
[    0.000000] OMAP clockevent source: GPTIMER1 at 32000 Hz
[    0.000000] sched_clock: 32 bits at 32kHz, resolution 30517ns, wraps every 131071999ms
[    0.000000] Console: colour dummy device 80x30
[    0.000000] console [tty0] enabled
[    0.001770] Calibrating delay loop... 320.37 BogoMIPS (lpj=1253376)
[    0.175567] pid_max: default: 32768 minimum: 301
[    0.176300] Mount-cache hash table entries: 512
[    0.177246] CPU: Testing write buffer coherency: ok
[    0.178771] devtmpfs: initialized
[    0.182037] omap_voltage_early_init: voltage driver support not added
[    0.184509] print_constraints: dummy: 
[    0.185089] NET: Registered protocol family 16
[    0.189636] omap_device: omap_gpio.0: new worst case activate latency 0: 91552
[    0.189880] OMAP GPIO hardware version 1.8
[    0.190093] OMAP GPIO hardware version 1.8
[    0.190277] OMAP GPIO hardware version 1.8
[    0.190460] OMAP GPIO hardware version 1.8
[    0.197967] omap_mux_init: Add partition: #1: core, flags: 3
[    0.205627] omap_device: omap_uart.0: new worst case deactivate latency 0: 30517
[    0.205688] omap_device: omap_uart.0: new worst case activate latency 0: 30517
[    0.208465] N8x0 MIPID config loaded
[    0.208587] N8x0 Blizzard initializedUSBFS INIT 1
[    0.230499] USBFS INIT 2
[    0.230560] USBFS INIT 3
[    0.230621] PLAT OTG INIT
[    0.231414] OTG_SYSCON_1 = 00000004
[    0.231445] OTG_SYSCON_2 = 00000100
[    0.231475] USB: hmc 16, usb0 6 wires, Mini-AB on usb0
[    0.232269] OTG_SYSCON_1 = 00030004
[    0.232299] USBFS INIT 4
[    0.232360] TUSB 6010
[    0.240234] OMAP DMA hardware revision 2.0
[    0.242492] omap2_clk_init_cpufreq_table: no matching entries in rate_table
[    0.277343] bio: create slab <bio-0> at 0
[    0.281402] SCSI subsystem initialized
[    0.287536] omap_device: omap_i2c.1: new worst case activate latency 0: 30517
[    0.287719] omap_i2c omap_i2c.1: bus 1 rev3.4 at 400 kHz
[    0.289581] omap_i2c omap_i2c.2: bus 2 rev3.4 at 400 kHz
[    0.292236] omap_device: omap_i2c.2: new worst case deactivate latency 0: 30517
[    0.293670] tahvo tahvo: Betty v2.2 found
[    0.294677] retu retu: Vilma v1.5 found
[    0.303985] Switching to clocksource 32k_counter
[    0.305450] Switched to NOHz mode on CPU #0
[    0.377166] NET: Registered protocol family 2
[    0.377563] IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.378326] TCP established hash table entries: 4096 (order: 3, 32768 bytes)
[    0.378662] TCP bind hash table entries: 4096 (order: 2, 16384 bytes)
[    0.378875] TCP: Hash tables configured (established 4096 bind 4096)
[    0.378936] TCP reno registered
[    0.378997] UDP hash table entries: 256 (order: 0, 4096 bytes)
[    0.379119] UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
[    0.380187] NET: Registered protocol family 1
[    0.381530] PMU: registered new PMU device of type 0
[    0.427642] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    0.427795] Registering mini_fo version $Id$
[    0.429718] JFFS2 version 2.2 (NAND) (SUMMARY) (ZLIB) (LZO) (LZMA) (RTIME) (CMODE_PRIORITY) (c) 2001-2006 Red Hat, Inc.
[    0.433135] msgmni has been set to 245
[    0.435455] io scheduler noop registered
[    0.435791] io scheduler cfq registered (default)
[    0.438598] omapfb: ls041y3 rev 81 LCD detected, 24 data lines
[    0.439117] omapfb: configured for panel ls041y3
[    0.443756] omapfb: DISPC version 2.0 initialized
[    0.443908] omapfb: RFBI version 1.0 initialized
[    0.460998] omapfb: s1d13745 LCD controller rev 1 initialized (CNF pins 3)
[    0.461242] omapfb omapfb: s1d1374x: setting update mode to auto
[    0.516326] Console: switching to colour frame buffer device 100x30
[    0.535919] omapfb: Framebuffer initialized. Total vram 770048 planes 1
[    0.542968] omapfb: Pixclock 21940 kHz hfreq 24.9 kHz vfreq 51.0 Hz
[    0.551971] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.565460] omap_uart.0: ttyO0 at MMIO 0x4806a000 (irq = 72) is a OMAP UART0
[    0.574371] omap_uart.1: ttyO1 at MMIO 0x4806c000 (irq = 73) is a OMAP UART1
[    0.583160] omap_uart.2: ttyO2 at MMIO 0x4806e000 (irq = 74) is a OMAP UART2
[    1.850708] console [ttyO2] enabled
[    1.866058] omap_rng omap_rng: OMAP Random Number Generator ver. 40
[    1.915496] brd: module loaded
[    1.943664] loop: module loaded
[    1.955474] Menelaus rev 2.2
[    1.981536] OneNAND driver initializing
[    1.993377] omap2-onenand omap2-onenand: initializing on CS0, phys base 0x04000000, virtual base c88c0000
[    2.017761] OneNAND Manufacturer: Samsung (0xec)
[    2.017791] Muxed OneNAND 256MB 1.8V 16-bit (0x40)
[    2.030364] OneNAND version = 0x0022
[    2.041412] Chip support all block unlock
[    2.041442] Chip has 2 plane
[    2.042999] Scanning device for bad blocks
[    2.084777] onenand_bbt_wait: ecc 0x2222 ctrl 0x2440 intr 0x8080 addr1 0x20e addr8 0x0
[    2.084808] OneNAND eraseblock 526 is an initial bad block
[    2.140777] onenand_bbt_wait: ecc 0x2222 ctrl 0x2440 intr 0x8080 addr1 0x4fa addr8 0x0
[    2.140808] OneNAND eraseblock 1274 is an initial bad block
[    2.169250] onenand_bbt_wait: ecc 0x2222 ctrl 0x2440 intr 0x8080 addr1 0x60e addr8 0x0
[    2.169281] OneNAND eraseblock 1550 is an initial bad block
[    2.210418] Creating 5 MTD partitions on "omap2-onenand":
[    2.222839] 0x000000000000-0x000000020000 : "bootloader"
[    2.240142] 0x000000020000-0x000000080000 : "config"
[    2.256988] 0x000000080000-0x000000280000 : "kernel"
[    2.274078] 0x000000280000-0x000000680000 : "initfs"
[    2.290588] 0x000000680000-0x000010000000 : "rootfs"
[    2.311157] mousedev: PS/2 mouse device common for all mice
[    2.365905] Registered led device: n810::keyboard
[    2.366851] Registered led device: n810::cover
[    2.368011] input: Internal keyboard as /devices/virtual/input/input0
[    2.383239] i2c-core: driver [lm8323] using legacy suspend method
[    2.396606] i2c-core: driver [lm8323] using legacy resume method
[    2.410156] TSC2005 driver initializing
[    2.422424] input: TSC2005 touchscreen as /devices/virtual/input/input1
[    2.438690] i2c /dev entries driver
[    2.453491] input: retu-pwrbutton as /devices/virtual/input/input2
[    2.471160] input: retu-headset as /devices/platform/retu/retu-headset/input/input3
[    2.488769] cpuidle: using governor ladder
[    2.499908] cpuidle: using governor menu
[    2.511016] sdhci: Secure Digital Host Controller Interface driver
[    2.524200] sdhci: Copyright(c) Pierre Ossman
[    2.734375] OMAP-mmc: waiting for cards...
[    3.016998] mmc0: host does not support reading read-only switch. assuming write-enable.
[    3.032714] mmc0: new SD card at address aaaa
[    3.045440] mmcblk0: mmc0:aaaa SU02G 1.84 GiB 
[    3.060668]  mmcblk0: p1 p2
[    3.148742] mmci-omap mmci-omap.0: command timeout (CMD52)
[    3.161010] mmci-omap mmci-omap.0: command timeout (CMD52)
[    3.174041] mmci-omap mmci-omap.0: command timeout (CMD52)
[    3.190399] mmci-omap mmci-omap.0: command timeout (CMD8)
[    3.202087] mmci-omap mmci-omap.0: command timeout (CMD8)
[    3.214599] mmci-omap mmci-omap.0: command timeout (CMD5)
[    3.226715] mmci-omap mmci-omap.0: command timeout (CMD5)
[    3.237976] mmci-omap mmci-omap.0: command timeout (CMD5)
[    3.249847] mmci-omap mmci-omap.0: command timeout (CMD5)
[    3.261688] mmci-omap mmci-omap.0: command timeout (CMD5)
[    3.273529] mmci-omap mmci-omap.0: command timeout (CMD55)
[    3.284759] mmci-omap mmci-omap.0: command timeout (CMD55)
[    3.296539] mmci-omap mmci-omap.0: command timeout (CMD55)
[    3.307312] mmci-omap mmci-omap.0: command timeout (CMD55)
[    3.318634] mmci-omap mmci-omap.0: command timeout (CMD55)
[    3.329895] mmci-omap mmci-omap.0: command timeout (CMD55)
[    3.380340] mmc1: new MMC card at address 0001
[    3.391143] mmcblk1: mmc1:0001 000000 1.87 GiB 
[    3.404632]  mmcblk1: p1
[    3.411804] mmcblk1: p1 size 4014064 extends beyond EOD, truncated
[    3.426452] omap_sham_mod_init: loading omap-sham driver
[    3.436645] omap_sham_mod_init: Unsupported cpu
[    3.446014] omap_aes_mod_init: loading omap-aes driver
[    3.455749] omap_aes_mod_init: Unsupported cpu
[    3.466461] TCP cubic registered
[    3.478729] NET: Registered protocol family 10
[    3.490325] NET: Registered protocol family 17
[    3.498962] Registering the dns_resolver key type
[    3.507751] VFP support v0.3: implementor 41 architecture 1 part 20 variant b rev 2
[    3.522644] omap_voltage_late_init: Voltage driver support not added
[    3.533935] Power Management for OMAP2 initializing
[    3.543365] PRCM revision 1.0
[    3.551910] input: slide as /devices/virtual/input/input4
[    3.564422] input: kb_lock as /devices/virtual/input/input5
[    3.576293] clock: disabling unused clocks to save power
[    3.587158] Bootup reason: pwr_key
[    3.595855] OMAP GPIO switch handler initializing
[    3.613067] gpio-switch: required switch not found (-1, cam_act)
[    3.625457] gpio-switch: required switch not found (-1, cam_turn)
[    3.637512] slide (GPIO 110) is now closed
[    3.647491] kb_lock (GPIO 102) is now open
[    3.657501] headphone (GPIO 107) is now disconnected
[    3.826507] EXT4-fs (mmcblk0p1): recovery complete
[    3.840332] EXT4-fs (mmcblk0p1): mounted filesystem with ordered data mode. Opts: (null)
[    3.855499] VFS: Mounted root (ext4 filesystem) on device 179:1.
[    3.870178] devtmpfs: mounted
[    3.880065] Freeing init memory: 136K
[    8.648925] EXT4-fs (mmcblk0p1): re-mounted. Opts: (null)
[   10.420623] retu-n810bm retu-n810bm: Requesting CAL BME PMM block firmware file n810-cal-bme-pmm.fw
[   10.740936] Compat-wireless backport release: compat-wireless-2011-01-31-19-g74d6d79
[   10.816772] Backport based on wireless-testing.git master-2011-02-25
[   10.861450] firmware retu-n810bm: firmware_loading_store: vmap() failed
[   10.921936] retu-n810bm retu-n810bm: CAL PMM block image file not found
[   11.344207] cfg80211: Calling CRDA to update world regulatory domain
[   11.700561] cfg80211: World regulatory domain updated:
[   11.734283] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   11.765319] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   11.796569] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   11.835601] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   11.866699] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   11.898132] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   11.939666] usbcore: registered new interface driver usbfs
[   11.955139] usbcore: registered new interface driver hub
[   11.970336] usbcore: registered new device driver usb
[   12.694671] RPC: Registered udp transport module.
[   12.707641] RPC: Registered tcp transport module.
[   12.720489] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   13.086395] PPP generic driver version 2.4.2
[   14.090728] tun: Universal TUN/TAP device driver, 1.6
[   14.104095] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   14.274139] ieee80211 phy0: p54 detected a LM20 firmware
[   14.288146] p54: rx_mtu reduced from 3240 to 2376
[   14.301025] ieee80211 phy0: FW rev 2.13.0.0.a.13.14 - Softmac protocol 5.6
[   14.316223] ieee80211 phy0: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:YES
[   14.434204] firmware spi2.0: firmware_loading_store: vmap() failed
[   14.449462] p54spi spi2.0: loading default eeprom...
[   14.464416] ieee80211 phy0: hwaddr 00:02:ee:c0:ff:ee, MAC:isl3820 RF:Longbow
[   14.483703] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[   14.490203] Registered led device: p54-phy0::assoc
[   14.491485] Registered led device: p54-phy0::tx
[   14.499816] Registered led device: p54-phy0::rx
[   14.501281] Registered led device: p54-phy0::radio
[   14.501525] p54spi spi2.0: is registered as 'phy0'
[   14.713531] nfs: Unknown symbol nfsacl_decode (err 0)
[   14.753784] nfs: Unknown symbol nfsacl_encode (err 0)
[   14.832611] nfs: Unknown symbol svc_gss_principal (err 0)
[   14.991241] nfsd: Unknown symbol nfsacl_decode (err 0)
[   15.012420] nfsd: Unknown symbol gss_mech_get_by_pseudoflavor (err 0)
[   15.041809] nfsd: Unknown symbol nfsacl_encode (err 0)
[   15.098236] nfsd: Unknown symbol gss_pseudoflavor_to_service (err 0)
[   15.129791] nfsd: Unknown symbol svc_gss_principal (err 0)
[   15.150604] nfsd: Unknown symbol gss_mech_put (err 0)
[   15.187347] nfsd: Unknown symbol svcauth_gss_flavor (err 0)
[   15.399688] ip_tables: (C) 2000-2006 Netfilter Core Team
[   15.796020] NET: Registered protocol family 24
[   16.069122] nf_conntrack version 0.5.0 (1963 buckets, 7852 max)
[   17.162780] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   17.782226] TAHVO PROBE USB
[   17.792907] tahvo: Registering interrupt 0 for device vbus_interrupt
[   17.807678] PWR OFF 1
[   17.817718] PWR OFF 2
[   17.827606] PWR OFF 3
[   17.837249] PWR OFF 4
[   17.846679] PWR OFF 5
[   17.856079] PWR OFF 6
[   17.865112] PWR OFF 7
[   17.873931] TAHVO SET TRANSCEIVER
[   17.883941] USB cable disconnected
[   17.894042] TAHVO USB DONE
[   17.904266] TAHVO PROBE USB OTG
[   17.913879] TAHVO OTG INIT 1
[   17.922607] TAHVO OTG INIT 2
[   17.931152] TAHVO OTG INIT 3
[   17.940643] TAHVO OTG INIT 4
[   17.949035] TAHVO OTG INIT 5
[   17.957214] TAHVO OTG INIT 6
[   17.965179] TAHVO OTG INIT 7
[   17.972991] TAHVO OMAP OTG REQUEST IRQ
[   17.982086] RESULT 0
[   17.990325] TAHVO USB LOADED
[   18.109436] musb-hdrc: version 6.0, tusb-omap-dma, otg (peripheral+host), debug=0
[   18.127807] nop_usb_xceiv nop_usb_xceiv: can't register transceiver, err: -16
[   18.156311] nop_usb_xceiv: probe of nop_usb_xceiv failed with error -16
[   18.195098] tusb: prcm2.0 int2.0 gpio3.0 dma3.0 dieid2 rev3.1
[   18.218353] drivers/usb/musb/tusb6010.c tusb_musb_disable: dma still active
[   18.243194] musb-hdrc: ConfigData=0x06 (UTMI-8, dyn FIFOs, SoftConn)
[   18.243255] musb-hdrc: MHDRC RTL version 1.400 
[   18.243286] musb-hdrc: setup fifo_mode 4
[   18.243347] musb-hdrc: 28/31 max ep, 16384/16384 memory
[   18.244018] musb-hdrc musb-hdrc: USB OTG mode controller at c8be4000 using DMA, IRQ 218
[   20.368164] cfg80211: Calling CRDA for country: DE
[   20.982696] cfg80211: Regulatory domain changed to country: DE
[   20.994720] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   21.010223] cfg80211:     (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   21.024139] cfg80211:     (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   21.038208] cfg80211:     (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   21.052062] cfg80211:     (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
[   21.094635] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   22.757873] wlan0: authenticate with 00:1d:0f:b9:df:2d (try 1)
[   22.776733] wlan0: authenticated
[   22.779022] wlan0: associate with 00:1d:0f:b9:df:2d (try 1)
[   22.801055] wlan0: RX AssocResp from 00:1d:0f:b9:df:2d (capab=0x411 status=0 aid=3)
[   22.801116] wlan0: associated
[   22.811584] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   22.855529] cfg80211: Calling CRDA for country: DE
[   23.150695] cfg80211: Regulatory domain changed to country: DE
[   23.195037] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   23.245025] cfg80211:     (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   23.278869] cfg80211:     (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   23.320068] cfg80211:     (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   23.349334] cfg80211:     (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
[ 1182.077880] cfg80211: Calling CRDA to update world regulatory domain
[ 1182.205261] cfg80211: World regulatory domain updated:
[ 1182.211517] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[ 1182.222381] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[ 1182.232482] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[ 1182.241577] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[ 1182.251129] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[ 1182.260528] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[ 1182.269927] cfg80211: Calling CRDA for country: DE
[ 1182.369659] cfg80211: Regulatory domain changed to country: DE
[ 1182.376586] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[ 1182.386138] cfg80211:     (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
[ 1182.395385] cfg80211:     (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[ 1182.404449] cfg80211:     (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[ 1182.413146] cfg80211:     (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
[ 1182.821472] ------------[ cut here ]------------
[ 1182.826599] WARNING: at /home/mb/develop/svn/openwrt_n810/trunk/build_dir/linux-omap24xx/compat-wireless-2011-02-25/net/mac80211/scan.c:310 ieee80211_rx_bss_free+0x20c/0x4b8 [mac80211]()
[ 1182.845275] Modules linked in: leds_gpio musb_hdrc tahvo_usb nop_usb_xceiv ip6t_REJECT ip6t_LOG ip6t_rt ip6t_hbh ip6t_mh ip6t_ipv6header ip6t_frag ip6t_eui64 ip6t_ah ip6table_raw ip6_queue ip6table_mangle ip6table_filter ip6_tables nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_conntrack_ftp ipt_REDIRECT ipt_NETMAP ipt_MASQUERADE iptable_nat nf_nat xt_recent xt_helper xt_conntrack xt_connmark xt_connbytes xt_NOTRACK iptable_raw xt_state nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack pppoe pppox ipt_REJECT xt_TCPMSS ipt_LOG xt_comment xt_multiport xt_mac xt_limit iptable_mangle iptable_filter ip_tables xt_tcpudp x_tables p54spi tun snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd_rawmidi snd_seq_device snd_hwdep snd_page_alloc snd soundcore ppp_async ppp_generic slhc p54common lockd sunrpc mac80211 usbcore exportfs cfg80211 compat arc4 n810bm ecb
[ 1182.929046] [<c0033edc>] (unwind_backtrace+0x0/0xe0) from [<c004f2a4>] (warn_slowpath_common+0x4c/0x64)
[ 1182.939788] [<c004f2a4>] (warn_slowpath_common+0x4c/0x64) from [<c004f2d4>] (warn_slowpath_null+0x18/0x1c)
[ 1182.951171] [<c004f2d4>] (warn_slowpath_null+0x18/0x1c) from [<bf06e700>] (ieee80211_rx_bss_free+0x20c/0x4b8 [mac80211])
[ 1182.963623] [<bf06e700>] (ieee80211_rx_bss_free+0x20c/0x4b8 [mac80211]) from [<c0060fd0>] (process_one_work+0x220/0x374)
[ 1182.975891] [<c0060fd0>] (process_one_work+0x220/0x374) from [<c0063320>] (worker_thread+0x1e4/0x310)
[ 1182.986663] [<c0063320>] (worker_thread+0x1e4/0x310) from [<c0066b54>] (kthread+0x80/0x88)
[ 1182.996154] [<c0066b54>] (kthread+0x80/0x88) from [<c002ffe4>] (kernel_thread_exit+0x0/0x8)
[ 1183.005676] ---[ end trace 9161f9fa8f376438 ]---
[ 1184.886108] wlan0: authenticate with 00:1d:0f:b9:df:2d (try 1)
[ 1184.902191] wlan0: authenticated
[ 1184.903198] wlan0: associate with 00:1d:0f:b9:df:2d (try 1)
[ 1184.909210] wlan0: RX ReassocResp from 00:1d:0f:b9:df:2d (capab=0x411 status=0 aid=3)
[ 1184.909271] wlan0: associated
[ 1184.917022] cfg80211: Calling CRDA for country: DE
[ 1185.019226] cfg80211: Regulatory domain changed to country: DE
[ 1185.026153] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[ 1185.035675] cfg80211:     (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
[ 1185.044311] cfg80211:     (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[ 1185.053253] cfg80211:     (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[ 1185.061920] cfg80211:     (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
[ 1215.072723] cfg80211: Calling CRDA to update world regulatory domain
[ 1215.197235] cfg80211: World regulatory domain updated:
[ 1215.203430] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[ 1215.212951] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[ 1215.223632] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[ 1215.233734] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[ 1215.243377] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[ 1215.252777] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[ 1215.262237] cfg80211: Calling CRDA for country: DE
[ 1215.362762] cfg80211: Regulatory domain changed to country: DE
[ 1215.369689] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[ 1215.379211] cfg80211:     (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
[ 1215.388427] cfg80211:     (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[ 1215.397735] cfg80211:     (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[ 1215.407806] cfg80211:     (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
[ 1217.073699] wlan0: authenticate with 00:1d:0f:b9:df:2d (try 1)
[ 1217.090820] wlan0: authenticated
[ 1217.091827] wlan0: associate with 00:1d:0f:b9:df:2d (try 1)
[ 1217.280883] wlan0: associate with 00:1d:0f:b9:df:2d (try 2)
[ 1217.284332] wlan0: RX ReassocResp from 00:1d:0f:b9:df:2d (capab=0x411 status=0 aid=3)
[ 1217.284362] wlan0: associated
[ 1217.292510] cfg80211: Calling CRDA for country: DE
[ 1217.395324] cfg80211: Regulatory domain changed to country: DE
[ 1217.402282] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[ 1217.411834] cfg80211:     (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
[ 1217.421020] cfg80211:     (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[ 1217.431732] cfg80211:     (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[ 1217.440765] cfg80211:     (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
[ 1220.415222] wlan0: deauthenticated from 00:1d:0f:b9:df:2d (Reason: 2)
[ 1220.418029] cfg80211: Calling CRDA to update world regulatory domain
[ 1220.525299] cfg80211: World regulatory domain updated:
[ 1220.531951] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[ 1220.542022] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[ 1220.551422] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[ 1220.560760] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[ 1220.571319] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[ 1220.581420] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[ 1220.591766] cfg80211: Calling CRDA for country: DE
[ 1220.690551] cfg80211: Regulatory domain changed to country: DE
[ 1220.697509] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[ 1220.708374] cfg80211:     (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
[ 1220.718048] cfg80211:     (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[ 1220.727264] cfg80211:     (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[ 1220.736602] cfg80211:     (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
[ 1221.151580] wlan0: authenticate with 00:1d:0f:b9:df:2d (try 1)
[ 1221.343414] wlan0: authenticate with 00:1d:0f:b9:df:2d (try 2)
[ 1221.538696] wlan0: authenticate with 00:1d:0f:b9:df:2d (try 3)
[ 1221.734008] wlan0: authentication with 00:1d:0f:b9:df:2d timed out
[ 1222.464202] wlan0: authenticate with 00:1d:0f:b9:df:2d (try 1)
[ 1222.655914] wlan0: authenticate with 00:1d:0f:b9:df:2d (try 2)
[ 1222.658386] wlan0: authenticated
[ 1222.659423] wlan0: associate with 00:1d:0f:b9:df:2d (try 1)
[ 1222.666900] wlan0: RX ReassocResp from 00:1d:0f:b9:df:2d (capab=0x411 status=0 aid=3)
[ 1222.666961] wlan0: associated
[ 1222.674560] cfg80211: Calling CRDA for country: DE
[ 1222.777038] cfg80211: Regulatory domain changed to country: DE
[ 1222.783996] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[ 1222.793487] cfg80211:     (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
[ 1222.802429] cfg80211:     (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[ 1222.811126] cfg80211:     (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[ 1222.819763] cfg80211:     (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)


-- 
Greetings, Michael.



