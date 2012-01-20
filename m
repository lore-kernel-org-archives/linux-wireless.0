Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:36725 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752246Ab2ATJxH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jan 2012 04:53:07 -0500
Received: by lahc1 with SMTP id c1so206101lah.19
        for <linux-wireless@vger.kernel.org>; Fri, 20 Jan 2012 01:53:04 -0800 (PST)
Message-ID: <4F19397A.8080408@gmail.com> (sfid-20120120_105319_388352_2227382E)
Date: Fri, 20 Jan 2012 10:52:58 +0100
From: =?UTF-8?B?TWFydGluIEh1bmRlYsO4bGw=?= <m.hundeboll@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: wl1271: ERROR watchdog interrupt received! starting recovery.
Content-Type: multipart/mixed;
 boundary="------------080700080507070301020005"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080700080507070301020005
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

I'm running an ad-hoc network with two pandaboards using the following commands to setup the network:

root@panda0 # ip link set dev wlan0 address 7e:78:47:8c:26:52
root@panda0 # iw dev wlan0 set type ibss
root@panda0 # ip link set dev wlan0 up
root@panda0 # iw dev wlan0 ibss join panda-mesh 2412 02:72:CF:28:19:1A
root@panda0 # iw phy phy0 set rts 100
root@panda0 # ip addr add 10.10.10.52/24 dev wlan0

and

root@panda1 # ip link set dev wlan0 address 7e:78:47:8c:26:53
root@panda1 # iw dev wlan0 set type ibss
root@panda1 # ip link set dev wlan0 up
root@panda1 # iw dev wlan0 ibss join panda-mesh 2412 02:72:CF:28:19:1A
root@panda1 # iw phy phy0 set rts 100
root@panda1 # ip addr add 10.10.10.53/24 dev wlan0

After this, the nodes list each other in a station dump. I then run ping:

root@panda0 # ping 10.10.10.53

but only two requests are transmitted before the devices restart as seen in the attached dmesg logs. The tcpdump from panda1 is attached in tcpdump.txt. I have attached the kernel config and here is some additional info:

root@panda0 # uname -a
Linux n52 3.1.6-1-ARCH #1 SMP PREEMPT Tue Jan 3 03:26:01 UTC 2012 armv7l ARMv7 Processor rev 2 (v7l) OMAP4 Panda board GNU/Linux

root@panda0 # modinfo wl12xx
filename:       /lib/modules/3.1.6-1-ARCH/kernel/drivers/net/wireless/wl12xx/wl12xx.ko.gz
author:         Juuso Oikarinen <juuso.oikarinen@nokia.com>
author:         Luciano Coelho <coelho@ti.com>
license:        GPL
srcversion:     DC3EDD5C82CB353BCE97039
depends:        mac80211,cfg80211
vermagic:       3.1.6-1-ARCH SMP preempt mod_unload modversions ARMv7 p2v8
parm:           debug_level:wl12xx debugging level (uint)
parm:           fwlog:charp
parm:           keymap:FW logger options: continuous, ondemand, dbgpins or disable

I see some commit logs from medio 2011 about the wl12xx watchdog, so I assume that they have made it into the 3.1 kernel.

Kind regards,
Martin Hundebøll
  

--------------080700080507070301020005
Content-Type: text/x-log;
 name="panda0.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="panda0.log"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.1.6-1-ARCH (nobody@platinum) (gcc version 4.6.2 20111125 (prerelease) (GCC) ) #1 SMP PREEMPT Tue Jan 3 03:26:01 UTC 2012
[    0.000000] CPU: ARMv7 Processor [411fc092] revision 2 (ARMv7), cr=10c5387d
[    0.000000] CPU: VIPT nonaliasing data cache, VIPT aliasing instruction cache
[    0.000000] Machine: OMAP4 Panda board
[    0.000000] Reserving 18874368 bytes SDRAM for VRAM
[    0.000000] Memory policy: ECC disabled, Data cache writealloc
[    0.000000] OMAP4430 ES2.2
[    0.000000] SRAM: Mapped pa 0x40300000 to va 0xfe400000 size: 0xe000
[    0.000000] On node 0 totalpages: 256000
[    0.000000] free_area_init_node: node 0, pgdat c08ca560, node_mem_map c0994000
[    0.000000]   Normal zone: 1536 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 195072 pages, LIFO batch:31
[    0.000000]   HighMem zone: 512 pages used for memmap
[    0.000000]   HighMem zone: 58880 pages, LIFO batch:15
[    0.000000] PERCPU: Embedded 8 pages/cpu @c119c000 s11808 r8192 d12768 u32768
[    0.000000] pcpu-alloc: s11808 r8192 d12768 u32768 alloc=8*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 253952
[    0.000000] Kernel command line: console=ttyO2,115200n8 noinitrd init=/sbin/init root=/dev/mmcblk0p2 rootwait rw loglevel=8 quiet
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] allocated 4194304 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] Memory: 1000MB = 1000MB total
[    0.000000] Memory: 1001016k/1001016k available, 47560k reserved, 237568K highmem
[    0.000000] Virtual kernel memory layout:
[    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
[    0.000000]     fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
[    0.000000]     DMA     : 0xffc00000 - 0xffe00000   (   2 MB)
[    0.000000]     vmalloc : 0xf0800000 - 0xf8000000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf0000000   ( 768 MB)
[    0.000000]     pkmap   : 0xbfe00000 - 0xc0000000   (   2 MB)
[    0.000000]     modules : 0xbf000000 - 0xbfe00000   (  14 MB)
[    0.000000]       .text : 0xc0008000 - 0xc0809238   (8197 kB)
[    0.000000]       .init : 0xc080a000 - 0xc085ce20   ( 332 kB)
[    0.000000]       .data : 0xc085e000 - 0xc08cc908   ( 443 kB)
[    0.000000]        .bss : 0xc08cc92c - 0xc0993e3c   ( 798 kB)
[    0.000000] SLUB: Genslabs=13, HWalign=32, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:410 nr_irqs:410 410
[    0.000000] omap_hwmod: dpll_mpu_m2_ck: missing clockdomain for dpll_mpu_m2_ck.
[    0.000000] OMAP clockevent source: GPTIMER1 at 32768 Hz
[    0.000000] sched_clock: 32 bits at 32kHz, resolution 30517ns, wraps every 131071999ms
[    0.000000] Console: colour dummy device 80x30
[    0.000152] Calibrating delay loop... 1576.53 BogoMIPS (lpj=6156288)
[    0.070373] pid_max: default: 32768 minimum: 301
[    0.070617] Security Framework initialized
[    0.070709] AppArmor: AppArmor initialized
[    0.070953] Mount-cache hash table entries: 512
[    0.071960] Initializing cgroup subsys cpuacct
[    0.072021] Initializing cgroup subsys memory
[    0.072082] Initializing cgroup subsys devices
[    0.072082] Initializing cgroup subsys freezer
[    0.072113] Initializing cgroup subsys blkio
[    0.072143] Initializing cgroup subsys perf_event
[    0.072296] CPU: Testing write buffer coherency: ok
[    0.072570] Calibrating local timer... 386.28MHz.
[    0.117431] hw perfevents: enabled with ARMv7 Cortex-A9 PMU driver, 7 counters available
[    0.117523] L310 cache controller enabled
[    0.117523] l2x0: 16 ways, CACHE_ID 0x410000c4, AUX_CTRL 0x7e470000, Cache size: 1048576 B
[    0.194000] CPU1: Booted secondary processor
[    0.194000] CPU1: Unknown IPI message 0x1
[    0.224182] Brought up 2 CPUs
[    0.224182] SMP: Total of 2 processors activated (3115.31 BogoMIPS).
[    0.225036] devtmpfs: initialized
[    0.228637] omap_hwmod: l3_div_ck: missing clockdomain for l3_div_ck.
[    0.231750] omap_hwmod: dmm: _wait_target_disable failed
[    0.234344] omap_hwmod: emif_fw: _wait_target_disable failed
[    0.236907] omap_hwmod: l3_main_1: _wait_target_disable failed
[    0.239501] omap_hwmod: l3_main_2: _wait_target_disable failed
[    0.242095] omap_hwmod: l4_abe: _wait_target_disable failed
[    0.244689] omap_hwmod: l4_cfg: _wait_target_disable failed
[    0.247253] omap_hwmod: l4_per: _wait_target_disable failed
[    0.250366] omap_hwmod: l4_wkup: _wait_target_disable failed
[    0.252929] omap_hwmod: dma_system: _wait_target_disable failed
[    0.255584] omap_hwmod: dss_core: _wait_target_disable failed
[    0.258178] omap_hwmod: dss_dispc: _wait_target_disable failed
[    0.260742] omap_hwmod: dss_dsi1: _wait_target_disable failed
[    0.263336] omap_hwmod: dss_dsi2: _wait_target_disable failed
[    0.265930] omap_hwmod: dss_hdmi: _wait_target_disable failed
[    0.268524] omap_hwmod: dss_rfbi: _wait_target_disable failed
[    0.271118] omap_hwmod: dss_venc: _wait_target_disable failed
[    0.274627] omap_hwmod: mailbox: _wait_target_disable failed
[    0.277465] omap_hwmod: spinlock: _wait_target_disable failed
[    0.279296] print_constraints: dummy: 
[    0.279571] NET: Registered protocol family 16
[    0.279724] GPMC revision 6.0
[    0.280822] omap_device: omap_gpio.0: new worst case activate latency 0: 61035
[    0.281005] OMAP GPIO hardware version 0.1
[    0.282287] omap_mux_init: Add partition: #1: core, flags: 2
[    0.283264] omap_mux_init: Add partition: #2: wkup, flags: 2
[    0.284301] omap_device: omap_uart.0: new worst case activate latency 0: 30517
[    0.284576] omap_device: omap_uart.1: new worst case deactivate latency 0: 30517
[    0.287780] hw-breakpoint: found 6 breakpoint and 1 watchpoint registers.
[    0.287780] hw-breakpoint: 1 breakpoint(s) reserved for watchpoint single-step.
[    0.287811] hw-breakpoint: maximum watchpoint size is 4 bytes.
[    0.288635] omap_init_sham: platform not supported
[    0.288635] omap_init_aes: platform not supported
[    0.289978] OMAP DMA hardware revision 0.0
[    0.295715] bio: create slab <bio-0> at 0
[    0.296234] print_constraints: vwl1271: 1800 mV 
[    0.296844] SCSI subsystem initialized
[    0.297027] omap_device: omap2_mcspi.1: new worst case activate latency 0: 30517
[    0.297729] usbcore: registered new interface driver usbfs
[    0.297821] usbcore: registered new interface driver hub
[    0.297912] usbcore: registered new device driver usb
[    0.298461] omap_device: omap_i2c.1: new worst case activate latency 0: 30517
[    0.308013] omap_i2c omap_i2c.1: bus 1 rev4.0 at 400 kHz
[    0.308502] Skipping twl internal clock init and using bootloader value (unknown osc rate)
[    0.308990] twl6030: PIH (irq 39) chaining IRQs 368..387
[    0.309387] print_constraints: VUSB: 3300 mV normal standby
[    0.506622] twl6030_usb twl6030_usb: Initialized TWL6030 USB module
[    0.506988] print_constraints: VMMC: 1200 <--> 3000 mV at 3000 mV normal standby
[    0.507385] print_constraints: VPP: 1800 <--> 2500 mV at 1900 mV normal standby
[    0.507659] print_constraints: VCXIO: 1800 mV normal standby
[    0.507873] print_constraints: VDAC: 1800 mV normal standby
[    0.508239] print_constraints: VAUX2_6030: 1200 <--> 2800 mV at 1800 mV normal standby
[    0.508605] print_constraints: VAUX3_6030: 1000 <--> 3000 mV at 1200 mV normal standby
[    0.509094] print_constraints: CLK32KG: 
[    0.509338] print_constraints: VANA: 2100 mV normal standby
[    0.509429] omap_device: omap_i2c.1: new worst case deactivate latency 0: 30517
[    0.521392] omap_i2c omap_i2c.2: bus 2 rev4.0 at 400 kHz
[    0.536621] omap_i2c omap_i2c.3: bus 3 rev4.0 at 100 kHz
[    0.551849] omap_i2c omap_i2c.4: bus 4 rev4.0 at 400 kHz
[    0.552429] Advanced Linux Sound Architecture Driver Version 1.0.24.
[    0.552917] NetLabel: Initializing
[    0.552917] NetLabel:  domain hash size = 128
[    0.552947] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.552978] NetLabel:  unlabeled traffic allowed by default
[    0.553009] Switching to clocksource 32k_counter
[    0.559478] Switched to NOHz mode on CPU #0
[    0.559844] Switched to NOHz mode on CPU #1
[    0.567962] AppArmor: AppArmor Filesystem Enabled
[    0.578979] musb-hdrc: version 6.0, ?dma?, otg (peripheral+host)
[    0.579101] omap_device: musb-omap2430.-1: new worst case activate latency 0: 30517
[    0.579193] musb-hdrc: ConfigData=0xde (UTMI-8, dyn FIFOs, bulk combine, bulk split, HB-ISO Rx, HB-ISO Tx, SoftConn)
[    0.579193] musb-hdrc: MHDRC RTL version 2.0 
[    0.579193] musb-hdrc: setup fifo_mode 5
[    0.579223] musb-hdrc: 28/31 max ep, 8192/16384 memory
[    0.579467] musb-hdrc musb-hdrc: USB OTG mode controller at fc0ab000 using DMA, IRQ 124
[    0.579711] omap_device: musb-omap2430.-1: new worst case deactivate latency 0: 30517
[    0.579986] NET: Registered protocol family 2
[    0.580322] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.581420] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.583343] TCP bind hash table entries: 65536 (order: 7, 786432 bytes)
[    0.584503] TCP: Hash tables configured (established 131072 bind 65536)
[    0.584503] TCP reno registered
[    0.584533] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.584564] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.584960] NET: Registered protocol family 1
[    0.585388] RPC: Registered named UNIX socket transport module.
[    0.585388] RPC: Registered udp transport module.
[    0.585418] RPC: Registered tcp transport module.
[    0.585418] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.654632] omap_dsp_init: 600000 bytes @ be800000
[    0.655242] audit: initializing netlink socket (disabled)
[    0.655303] type=2000 audit(0.664:1): initialized
[    0.828582] highmem bounce pool size: 64 pages
[    0.836273] VFS: Disk quotas dquot_6.5.2
[    0.836700] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.841186] fuse init (API version 7.17)
[    0.842437] Btrfs loaded
[    0.842468] msgmni has been set to 1491
[    0.843688] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.843719] io scheduler noop registered
[    0.843719] io scheduler deadline registered
[    0.843811] io scheduler cfq registered (default)
[    0.844451] omap_device: omapdss_dss.-1: new worst case activate latency 0: 30517
[    0.844482] OMAP DSS rev 4.0
[    0.847045] omap_hwmod: dss_core: _wait_target_disable failed
[    0.847076] omap_device: omapdss_dss.-1: new worst case deactivate latency 0: 2593994
[    0.849945] omap_hwmod: dss_core: _wait_target_disable failed
[    0.852539] omap_hwmod: dss_dispc: _wait_target_disable failed
[    0.855407] omap_hwmod: dss_dispc: _wait_target_disable failed
[    0.858001] omap_hwmod: dss_core: _wait_target_disable failed
[    0.860595] omap_hwmod: dss_dsi1: _wait_target_disable failed
[    0.863769] omap_hwmod: dss_dispc: _wait_target_disable failed
[    0.866363] omap_hwmod: dss_core: _wait_target_disable failed
[    0.869689] omap_hwmod: dss_dispc: _wait_target_disable failed
[    0.872283] omap_hwmod: dss_core: _wait_target_disable failed
[    0.872406] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.115753] omap_uart.0: ttyO0 at MMIO 0x4806a000 (irq = 104) is a OMAP UART0
[    1.240570] omap_uart.1: ttyO1 at MMIO 0x4806c000 (irq = 105) is a OMAP UART1
[    1.365570] omap_uart.2: ttyO2 at MMIO 0x48020000 (irq = 106) is a OMAP UART2
[    1.379943] console [ttyO2] enabled
[    1.490631] omap_uart.3: ttyO3 at MMIO 0x4806e000 (irq = 102) is a OMAP UART3
[    1.622070] brd: module loaded
[    1.625335] loop: module loaded
[    1.626953] omap2-nand driver initializing
[    1.627136] OneNAND driver initializing
[    1.627777] usbcore: registered new interface driver cdc_ether
[    1.627838] usbcore: registered new interface driver rndis_host
[    1.627868] cdc_ncm: 04-Aug-2011
[    1.627899] usbcore: registered new interface driver cdc_ncm
[    1.628234] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.628356] _regulator_get: ehci-omap.0 supply hsusb0 not found, using dummy regulator
[    1.628448] ehci-omap ehci-omap.0: OMAP-EHCI Host Controller
[    1.628662] ehci-omap ehci-omap.0: new USB bus registered, assigned bus number 1
[    1.628814] ehci-omap ehci-omap.0: irq 109, io mem 0x4a064c00
[    1.639007] ehci-omap ehci-omap.0: USB 2.0 started, EHCI 1.00
[    1.639648] hub 1-0:1.0: USB hub found
[    1.639678] hub 1-0:1.0: 3 ports detected
[    1.670318] Initializing USB Mass Storage driver...
[    1.670440] usbcore: registered new interface driver usb-storage
[    1.670440] USB Mass Storage support registered.
[    1.670532] usbcore: registered new interface driver libusual
[    1.670654] udc: OMAP UDC driver, version: 4 October 2004 (iso) (dma)
[    1.670837]  gadget: using random self ethernet address
[    1.670837]  gadget: using random host ethernet address
[    1.671813] usb0: MAC de:7f:36:ae:e4:e1
[    1.671813] usb0: HOST MAC 26:a6:6f:7e:08:66
[    1.671844]  gadget: Ethernet Gadget, version: Memorial Day 2008
[    1.671874]  gadget: g_ether ready
[    1.866790] musb-hdrc musb-hdrc: MUSB HDRC host driver
[    1.867065] musb-hdrc musb-hdrc: new USB bus registered, assigned bus number 2
[    1.867553] hub 2-0:1.0: USB hub found
[    1.867584] hub 2-0:1.0: 1 port detected
[    1.868072] mousedev: PS/2 mouse device common for all mice
[    1.871093] twl_rtc twl_rtc: rtc core: registered twl_rtc as rtc0
[    1.871337] i2c /dev entries driver
[    1.871978] Linux media interface: v0.10
[    1.872100] lirc_dev: IR Remote Control driver registered, major 249 
[    1.872131] Driver for 1-wire Dallas network protocol.
[    1.872406] omap_device: omap_wdt.-1: new worst case activate latency 0: 91552
[    1.872924] OMAP Watchdog Timer Rev 0x00: initial timeout 60 sec
[    1.873687] device-mapper: uevent: version 1.0.3
[    1.874084] device-mapper: ioctl: 4.21.0-ioctl (2011-07-06) initialised: dm-devel@redhat.com
[    1.874298] device-mapper: multipath: version 1.3.0 loaded
[    1.874298] device-mapper: multipath round-robin: version 1.0.0 loaded
[    1.874908] cpuidle: using governor ladder
[    1.874908] cpuidle: using governor menu
[    1.874938] sdhci: Secure Digital Host Controller Interface driver
[    1.874969] sdhci: Copyright(c) Pierre Ossman
[    1.876251] _regulator_get: omap_hsmmc.0 supply vmmc_aux not found, using dummy regulator
[    1.877410] omap_device: omap_hsmmc.0: new worst case activate latency 0: 30517
[    1.877532] _regulator_get: omap_hsmmc.4 supply vmmc_aux not found, using dummy regulator
[    1.877838] omap_device: omap_hsmmc.4: new worst case deactivate latency 0: 30517
[    1.878204] Registered led device: pandaboard::status1
[    1.878265] Registered led device: pandaboard::status2
[    1.878936] usbcore: registered new interface driver snd-usb-6fire
[    1.879882] ALSA device list:
[    1.879882]   No soundcards found.
[    1.880065] oprofile: using arm/armv7-ca9
[    1.881225] TCP cubic registered
[    1.881835] NET: Registered protocol family 10
[    1.884796] NET: Registered protocol family 17
[    1.884948] Registering the dns_resolver key type
[    1.884979] VFP support v0.3: implementor 41 architecture 3 part 30 variant 9 rev 1
[    1.885009] ThumbEE CPU extension supported.
[    1.885009] Registering SWP/SWPB emulation handler
[    1.887847] Power Management for TI OMAP4.
[    1.892181] sr_init: No PMIC hook to init smartreflex
[    1.892303] smartreflex smartreflex.0: omap_sr_probe: SmartReflex driver initialized
[    1.892395] smartreflex smartreflex.1: omap_sr_probe: SmartReflex driver initialized
[    1.892517] smartreflex smartreflex.2: omap_sr_probe: SmartReflex driver initialized
[    1.892608] SmartReflex Class3 initialized
[    1.898101] clock: disabling unused clocks to save power
[    1.898712] registered taskstats version 1
[    1.914459] omap_hwmod: dss_dispc: _wait_target_disable failed
[    1.917022] omap_hwmod: dss_core: _wait_target_disable failed
[    1.920989] Console: switching to colour frame buffer device 80x30
[    1.924957] omapdss DPI: Could not find exact pixel clock. Requested 23500 kHz, got 23630 kHz
[    1.927398] regulator_init_complete: VANA: incomplete constraints, leaving on
[    1.928375] regulator_init_complete: VDAC: incomplete constraints, leaving on
[    1.928710] regulator_init_complete: VCXIO: incomplete constraints, leaving on
[    1.929260] omap_device: omap_i2c.1: new worst case activate latency 0: 61035
[    1.929412] regulator_init_complete: VUSB: incomplete constraints, leaving on
[    1.930114] twl_rtc twl_rtc: setting system clock to 2000-01-01 02:05:11 UTC (946692311)
[    1.930541] md: Waiting for all devices to be available before autodetect
[    1.930541] md: If you don't use raid, use raid=noautodetect
[    1.934112] md: Autodetecting RAID arrays.
[    1.934112] md: Scanned 0 and added 0 devices.
[    1.934112] md: autorun ...
[    1.934143] md: ... autorun DONE.
[    1.934204] Waiting for root device /dev/mmcblk0p2...
[    1.967163] usb 1-1: new high speed USB device number 2 using ehci-omap
[    2.058227] mmc0: host does not support reading read-only switch. assuming write-enable.
[    2.058288] mmc0: new SDHC card at address e624
[    2.058593] mmcblk0: mmc0:e624 SD04G 3.69 GiB 
[    2.067291]  mmcblk0: p1 p2
[    2.124206] hub 1-1:1.0: USB hub found
[    2.124359] hub 1-1:1.0: 5 ports detected
[    2.159362] kjournald starting.  Commit interval 5 seconds
[    2.159393] EXT3-fs (mmcblk0p2): warning: maximal mount count reached, running e2fsck is recommended
[    2.167236] EXT3-fs (mmcblk0p2): using internal journal
[    2.167266] EXT3-fs (mmcblk0p2): mounted filesystem with ordered data mode
[    2.167297] VFS: Mounted root (ext3 filesystem) on device 179:2.
[    2.170501] devtmpfs: mounted
[    2.170776] Freeing init memory: 328K
[    2.184265] mmc1: card claims to support voltages below the defined range. These will be ignored.
[    2.202880] mmc1: queuing unknown CIS tuple 0x91 (3 bytes)
[    2.203887] mmc1: new SDIO card at address 0001
[    2.412597] usb 1-1.1: new high speed USB device number 3 using ehci-omap
[    3.094879] udevd[82]: starting version 175
[    3.420013] cfg80211: Calling CRDA to update world regulatory domain
[    3.539611] smsc95xx v1.0.4
[    3.621704] smsc95xx 1-1.1:1.0: eth0: register 'smsc95xx' at usb-ehci-omap.0-1.1, smsc95xx USB 2.0 Ethernet, e2:f8:11:27:fc:55
[    3.621795] usbcore: registered new interface driver smsc95xx
[    4.134063] cfg80211: Updating information on frequency 2412 MHz for a 20 MHz width channel with regulatory rule:
[    4.134094] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (600 mBi, 2000 mBm)
[    4.134094] cfg80211: Updating information on frequency 2417 MHz for a 20 MHz width channel with regulatory rule:
[    4.134124] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (600 mBi, 2000 mBm)
[    4.134124] cfg80211: Updating information on frequency 2422 MHz for a 20 MHz width channel with regulatory rule:
[    4.134124] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (600 mBi, 2000 mBm)
[    4.134155] cfg80211: Updating information on frequency 2427 MHz for a 20 MHz width channel with regulatory rule:
[    4.134155] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (600 mBi, 2000 mBm)
[    4.134155] cfg80211: Updating information on frequency 2432 MHz for a 20 MHz width channel with regulatory rule:
[    4.134185] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (600 mBi, 2000 mBm)
[    4.134185] cfg80211: Updating information on frequency 2437 MHz for a 20 MHz width channel with regulatory rule:
[    4.134185] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (600 mBi, 2000 mBm)
[    4.134216] cfg80211: Updating information on frequency 2442 MHz for a 20 MHz width channel with regulatory rule:
[    4.134216] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (600 mBi, 2000 mBm)
[    4.134246] cfg80211: Updating information on frequency 2447 MHz for a 20 MHz width channel with regulatory rule:
[    4.134246] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (600 mBi, 2000 mBm)
[    4.134246] cfg80211: Updating information on frequency 2452 MHz for a 20 MHz width channel with regulatory rule:
[    4.134277] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (600 mBi, 2000 mBm)
[    4.134277] cfg80211: Updating information on frequency 2457 MHz for a 20 MHz width channel with regulatory rule:
[    4.134277] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (600 mBi, 2000 mBm)
[    4.134307] cfg80211: Updating information on frequency 2462 MHz for a 20 MHz width channel with regulatory rule:
[    4.134307] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (600 mBi, 2000 mBm)
[    4.134307] cfg80211: Updating information on frequency 2467 MHz for a 20 MHz width channel with regulatory rule:
[    4.134338] cfg80211: 2457000 KHz - 2482000 KHz @  KHz), (600 mBi, 2000 mBm)
[    4.134338] cfg80211: Updating information on frequency 2472 MHz for a 20 MHz width channel with regulatory rule:
[    4.134338] cfg80211: 2457000 KHz - 2482000 KHz @  KHz), (600 mBi, 2000 mBm)
[    4.134368] cfg80211: Updating information on frequency 2484 MHz for a 20 MHz width channel with regulatory rule:
[    4.134368] cfg80211: 2474000 KHz - 2494000 KHz @  KHz), (600 mBi, 2000 mBm)
[    4.134368] cfg80211: Disabling freq 5035 MHz
[    4.134399] cfg80211: Disabling freq 5040 MHz
[    4.134399] cfg80211: Disabling freq 5045 MHz
[    4.134399] cfg80211: Disabling freq 5055 MHz
[    4.134429] cfg80211: Disabling freq 5060 MHz
[    4.134429] cfg80211: Disabling freq 5080 MHz
[    4.134429] cfg80211: Disabling freq 5170 MHz
[    4.134429] cfg80211: Updating information on frequency 5180 MHz for a 20 MHz width channel with regulatory rule:
[    4.134460] cfg80211: 5170000 KHz - 5250000 KHz @  KHz), (600 mBi, 2000 mBm)
[    4.134460] cfg80211: Updating information on frequency 5190 MHz for a 20 MHz width channel with regulatory rule:
[    4.134490] cfg80211: 5170000 KHz - 5250000 KHz @  KHz), (600 mBi, 2000 mBm)
[    4.134490] cfg80211: Updating information on frequency 5200 MHz for a 20 MHz width channel with regulatory rule:
[    4.134490] cfg80211: 5170000 KHz - 5250000 KHz @  KHz), (600 mBi, 2000 mBm)
[    4.134521] cfg80211: Updating information on frequency 5210 MHz for a 20 MHz width channel with regulatory rule:
[    4.134521] cfg80211: 5170000 KHz - 5250000 KHz @  KHz), (600 mBi, 2000 mBm)
[    4.134521] cfg80211: Updating information on frequency 5220 MHz for a 20 MHz width channel with regulatory rule:
[    4.134552] cfg80211: 5170000 KHz - 5250000 KHz @  KHz), (600 mBi, 2000 mBm)
[    4.134552] cfg80211: Updating information on frequency 5230 MHz for a 20 MHz width channel with regulatory rule:
[    4.134552] cfg80211: 5170000 KHz - 5250000 KHz @  KHz), (600 mBi, 2000 mBm)
[    4.134582] cfg80211: Updating information on frequency 5240 MHz for a 20 MHz width channel with regulatory rule:
[    4.134582] cfg80211: 5170000 KHz - 5250000 KHz @  KHz), (600 mBi, 2000 mBm)
[    4.134582] cfg80211: Disabling freq 5260 MHz
[    4.134613] cfg80211: Disabling freq 5280 MHz
[    4.134613] cfg80211: Disabling freq 5300 MHz
[    4.134613] cfg80211: Disabling freq 5320 MHz
[    4.134613] cfg80211: Disabling freq 5500 MHz
[    4.134613] cfg80211: Disabling freq 5520 MHz
[    4.134643] cfg80211: Disabling freq 5540 MHz
[    4.134643] cfg80211: Disabling freq 5560 MHz
[    4.134643] cfg80211: Disabling freq 5580 MHz
[    4.134643] cfg80211: Disabling freq 5600 MHz
[    4.134674] cfg80211: Disabling freq 5620 MHz
[    4.134674] cfg80211: Disabling freq 5640 MHz
[    4.134674] cfg80211: Disabling freq 5660 MHz
[    4.134674] cfg80211: Disabling freq 5680 MHz
[    4.134674] cfg80211: Disabling freq 5700 MHz
[    4.134704] cfg80211: Updating information on frequency 5745 MHz for a 20 MHz width channel with regulatory rule:
[    4.134704] cfg80211: 5735000 KHz - 5835000 KHz @  KHz), (600 mBi, 2000 mBm)
[    4.134704] cfg80211: Updating information on frequency 5765 MHz for a 20 MHz width channel with regulatory rule:
[    4.134735] cfg80211: 5735000 KHz - 5835000 KHz @  KHz), (600 mBi, 2000 mBm)
[    4.134735] cfg80211: Updating information on frequency 5785 MHz for a 20 MHz width channel with regulatory rule:
[    4.134765] cfg80211: 5735000 KHz - 5835000 KHz @  KHz), (600 mBi, 2000 mBm)
[    4.134765] cfg80211: Updating information on frequency 5805 MHz for a 20 MHz width channel with regulatory rule:
[    4.134765] cfg80211: 5735000 KHz - 5835000 KHz @  KHz), (600 mBi, 2000 mBm)
[    4.134796] cfg80211: Updating information on frequency 5825 MHz for a 20 MHz width channel with regulatory rule:
[    4.134796] cfg80211: 5735000 KHz - 5835000 KHz @  KHz), (600 mBi, 2000 mBm)
[    4.153350] wl1271: loaded
[    4.368072] EXT3-fs (mmcblk0p2): warning: maximal mount count reached, running e2fsck is recommended
[    4.370117] EXT3-fs (mmcblk0p2): using internal journal
[    8.169647] smsc95xx 1-1.1:1.0: eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
[   16.881195] eth0: no IPv6 routers present
[  121.620269] wl1271: firmware booted (Rev 6.1.5.50.74)
[  132.271820] wlan0: no IPv6 routers present
[  132.424163] wlan0: Creating new IBSS network, BSSID 02:72:cf:28:19:1a
[  209.365875] wl1271: ERROR watchdog interrupt received! starting recovery.
[  209.373046] wl1271: Reading FW panic log
[  211.373443] wl1271: ERROR command complete timeout
[  211.378479] ------------[ cut here ]------------
[  211.378601] WARNING: at drivers/net/wireless/wl12xx/cmd.c:107 wl1271_cmd_send+0x334/0x368 [wl12xx]()
[  211.378631] Modules linked in: arc4 wl12xx_sdio wl12xx mac80211 smsc95xx cfg80211 rfkill
[  211.378662] [<c001372c>] (unwind_backtrace+0x0/0xe0) from [<c0046aa4>] (warn_slowpath_common+0x4c/0x64)
[  211.378692] [<c0046aa4>] (warn_slowpath_common+0x4c/0x64) from [<c0046ad4>] (warn_slowpath_null+0x18/0x1c)
[  211.378723] [<c0046ad4>] (warn_slowpath_null+0x18/0x1c) from [<bf13dad0>] (wl1271_cmd_send+0x334/0x368 [wl12xx])
[  211.378814] [<bf13dad0>] (wl1271_cmd_send+0x334/0x368 [wl12xx]) from [<bf13f4ac>] (wl12xx_cmd_stop_fwlog+0x50/0x80 [wl12xx])
[  211.378845] [<bf13f4ac>] (wl12xx_cmd_stop_fwlog+0x50/0x80 [wl12xx]) from [<bf13c3e4>] (wl1271_recovery_work+0xac/0x2b0 [wl12xx])
[  211.378906] [<bf13c3e4>] (wl1271_recovery_work+0xac/0x2b0 [wl12xx]) from [<c005fc5c>] (process_one_work+0x270/0x454)
[  211.378906] [<c005fc5c>] (process_one_work+0x270/0x454) from [<c00601a4>] (worker_thread+0x1a8/0x2a4)
[  211.378936] [<c00601a4>] (worker_thread+0x1a8/0x2a4) from [<c00640c0>] (kthread+0x7c/0x84)
[  211.378967] [<c00640c0>] (kthread+0x7c/0x84) from [<c000df3c>] (kernel_thread_exit+0x0/0x8)
[  211.378997] ---[ end trace 4be6dc2e593c8298 ]---
[  211.378997] wl1271: ERROR failed to send stop firmware logger command
[  211.388275] wl1271: Hardware recovery in progress. FW ver: Rev 6.1.5.50.74 pc: 0x268f9
[  211.388305] wl1271: down
[  211.388427] ieee80211 phy0: Hardware restart was requested
[  211.499053] omap_device: omap_hsmmc.4: new worst case deactivate latency 0: 61035
[  211.904693] wl1271: firmware booted (Rev 6.1.5.50.74)

--------------080700080507070301020005
Content-Type: text/x-log;
 name="panda1.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="panda1.log"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.1.6-1-ARCH (nobody@platinum) (gcc version 4.6.2 20111125 (prerelease) (GCC) ) #1 SMP PREEMPT Tue Jan 3 03:26:01 UTC 2012
[    0.000000] CPU: ARMv7 Processor [411fc092] revision 2 (ARMv7), cr=10c5387d
[    0.000000] CPU: VIPT nonaliasing data cache, VIPT aliasing instruction cache
[    0.000000] Machine: OMAP4 Panda board
[    0.000000] Reserving 18874368 bytes SDRAM for VRAM
[    0.000000] Memory policy: ECC disabled, Data cache writealloc
[    0.000000] OMAP4430 ES2.2
[    0.000000] SRAM: Mapped pa 0x40300000 to va 0xfe400000 size: 0xe000
[    0.000000] On node 0 totalpages: 256000
[    0.000000] free_area_init_node: node 0, pgdat c08ca560, node_mem_map c0994000
[    0.000000]   Normal zone: 1536 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 195072 pages, LIFO batch:31
[    0.000000]   HighMem zone: 512 pages used for memmap
[    0.000000]   HighMem zone: 58880 pages, LIFO batch:15
[    0.000000] PERCPU: Embedded 8 pages/cpu @c119c000 s11808 r8192 d12768 u32768
[    0.000000] pcpu-alloc: s11808 r8192 d12768 u32768 alloc=8*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 253952
[    0.000000] Kernel command line: console=ttyO2,115200n8 noinitrd init=/sbin/init root=/dev/mmcblk0p2 rootwait rw loglevel=8 quiet
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] allocated 4194304 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] Memory: 1000MB = 1000MB total
[    0.000000] Memory: 1001016k/1001016k available, 47560k reserved, 237568K highmem
[    0.000000] Virtual kernel memory layout:
[    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
[    0.000000]     fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
[    0.000000]     DMA     : 0xffc00000 - 0xffe00000   (   2 MB)
[    0.000000]     vmalloc : 0xf0800000 - 0xf8000000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf0000000   ( 768 MB)
[    0.000000]     pkmap   : 0xbfe00000 - 0xc0000000   (   2 MB)
[    0.000000]     modules : 0xbf000000 - 0xbfe00000   (  14 MB)
[    0.000000]       .text : 0xc0008000 - 0xc0809238   (8197 kB)
[    0.000000]       .init : 0xc080a000 - 0xc085ce20   ( 332 kB)
[    0.000000]       .data : 0xc085e000 - 0xc08cc908   ( 443 kB)
[    0.000000]        .bss : 0xc08cc92c - 0xc0993e3c   ( 798 kB)
[    0.000000] SLUB: Genslabs=13, HWalign=32, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:410 nr_irqs:410 410
[    0.000000] omap_hwmod: dpll_mpu_m2_ck: missing clockdomain for dpll_mpu_m2_ck.
[    0.000000] OMAP clockevent source: GPTIMER1 at 32768 Hz
[    0.000000] sched_clock: 32 bits at 32kHz, resolution 30517ns, wraps every 131071999ms
[    0.000000] Console: colour dummy device 80x30
[    0.000152] Calibrating delay loop... 1576.53 BogoMIPS (lpj=6156288)
[    0.070373] pid_max: default: 32768 minimum: 301
[    0.070617] Security Framework initialized
[    0.070709] AppArmor: AppArmor initialized
[    0.070953] Mount-cache hash table entries: 512
[    0.071960] Initializing cgroup subsys cpuacct
[    0.072021] Initializing cgroup subsys memory
[    0.072052] Initializing cgroup subsys devices
[    0.072082] Initializing cgroup subsys freezer
[    0.072082] Initializing cgroup subsys blkio
[    0.072113] Initializing cgroup subsys perf_event
[    0.072265] CPU: Testing write buffer coherency: ok
[    0.072570] Calibrating local timer... 386.31MHz.
[    0.117431] hw perfevents: enabled with ARMv7 Cortex-A9 PMU driver, 7 counters available
[    0.117523] L310 cache controller enabled
[    0.117523] l2x0: 16 ways, CACHE_ID 0x410000c4, AUX_CTRL 0x7e470000, Cache size: 1048576 B
[    0.194000] CPU1: Booted secondary processor
[    0.194030] CPU1: Unknown IPI message 0x1
[    0.224182] Brought up 2 CPUs
[    0.224182] SMP: Total of 2 processors activated (3115.31 BogoMIPS).
[    0.225036] devtmpfs: initialized
[    0.228668] omap_hwmod: l3_div_ck: missing clockdomain for l3_div_ck.
[    0.231750] omap_hwmod: dmm: _wait_target_disable failed
[    0.234344] omap_hwmod: emif_fw: _wait_target_disable failed
[    0.236938] omap_hwmod: l3_main_1: _wait_target_disable failed
[    0.239501] omap_hwmod: l3_main_2: _wait_target_disable failed
[    0.242095] omap_hwmod: l4_abe: _wait_target_disable failed
[    0.244689] omap_hwmod: l4_cfg: _wait_target_disable failed
[    0.247283] omap_hwmod: l4_per: _wait_target_disable failed
[    0.250366] omap_hwmod: l4_wkup: _wait_target_disable failed
[    0.252960] omap_hwmod: dma_system: _wait_target_disable failed
[    0.255584] omap_hwmod: dss_core: _wait_target_disable failed
[    0.258178] omap_hwmod: dss_dispc: _wait_target_disable failed
[    0.260772] omap_hwmod: dss_dsi1: _wait_target_disable failed
[    0.263366] omap_hwmod: dss_dsi2: _wait_target_disable failed
[    0.265930] omap_hwmod: dss_hdmi: _wait_target_disable failed
[    0.268524] omap_hwmod: dss_rfbi: _wait_target_disable failed
[    0.271118] omap_hwmod: dss_venc: _wait_target_disable failed
[    0.274627] omap_hwmod: mailbox: _wait_target_disable failed
[    0.277465] omap_hwmod: spinlock: _wait_target_disable failed
[    0.279296] print_constraints: dummy: 
[    0.279571] NET: Registered protocol family 16
[    0.279724] GPMC revision 6.0
[    0.280822] omap_device: omap_gpio.0: new worst case activate latency 0: 61035
[    0.281005] OMAP GPIO hardware version 0.1
[    0.282287] omap_mux_init: Add partition: #1: core, flags: 2
[    0.283264] omap_mux_init: Add partition: #2: wkup, flags: 2
[    0.284271] omap_device: omap_uart.0: new worst case activate latency 0: 30517
[    0.287750] hw-breakpoint: found 6 breakpoint and 1 watchpoint registers.
[    0.287750] hw-breakpoint: 1 breakpoint(s) reserved for watchpoint single-step.
[    0.287780] hw-breakpoint: maximum watchpoint size is 4 bytes.
[    0.288604] omap_init_sham: platform not supported
[    0.288604] omap_init_aes: platform not supported
[    0.289947] OMAP DMA hardware revision 0.0
[    0.295684] bio: create slab <bio-0> at 0
[    0.296203] print_constraints: vwl1271: 1800 mV 
[    0.296813] SCSI subsystem initialized
[    0.296997] omap_device: omap2_mcspi.1: new worst case activate latency 0: 30517
[    0.297698] usbcore: registered new interface driver usbfs
[    0.297760] usbcore: registered new interface driver hub
[    0.297882] usbcore: registered new device driver usb
[    0.308044] omap_i2c omap_i2c.1: bus 1 rev4.0 at 400 kHz
[    0.308532] Skipping twl internal clock init and using bootloader value (unknown osc rate)
[    0.308990] twl6030: PIH (irq 39) chaining IRQs 368..387
[    0.309387] print_constraints: VUSB: 3300 mV normal standby
[    0.506622] twl6030_usb twl6030_usb: Initialized TWL6030 USB module
[    0.506988] print_constraints: VMMC: 1200 <--> 3000 mV at 3000 mV normal standby
[    0.507415] print_constraints: VPP: 1800 <--> 2500 mV at 1900 mV normal standby
[    0.507659] print_constraints: VCXIO: 1800 mV normal standby
[    0.507873] print_constraints: VDAC: 1800 mV normal standby
[    0.508239] print_constraints: VAUX2_6030: 1200 <--> 2800 mV at 1800 mV normal standby
[    0.508605] print_constraints: VAUX3_6030: 1000 <--> 3000 mV at 1200 mV normal standby
[    0.509094] print_constraints: CLK32KG: 
[    0.509338] print_constraints: VANA: 2100 mV normal standby
[    0.521453] omap_i2c omap_i2c.2: bus 2 rev4.0 at 400 kHz
[    0.536682] omap_i2c omap_i2c.3: bus 3 rev4.0 at 100 kHz
[    0.536895] omap_device: omap_i2c.4: new worst case activate latency 0: 30517
[    0.551910] omap_i2c omap_i2c.4: bus 4 rev4.0 at 400 kHz
[    0.552490] Advanced Linux Sound Architecture Driver Version 1.0.24.
[    0.552978] NetLabel: Initializing
[    0.552978] NetLabel:  domain hash size = 128
[    0.552978] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.553039] NetLabel:  unlabeled traffic allowed by default
[    0.553039] Switching to clocksource 32k_counter
[    0.559539] Switched to NOHz mode on CPU #0
[    0.559875] Switched to NOHz mode on CPU #1
[    0.567993] AppArmor: AppArmor Filesystem Enabled
[    0.579010] musb-hdrc: version 6.0, ?dma?, otg (peripheral+host)
[    0.579132] omap_device: musb-omap2430.-1: new worst case activate latency 0: 30517
[    0.579193] musb-hdrc: ConfigData=0xde (UTMI-8, dyn FIFOs, bulk combine, bulk split, HB-ISO Rx, HB-ISO Tx, SoftConn)
[    0.579223] musb-hdrc: MHDRC RTL version 2.0 
[    0.579223] musb-hdrc: setup fifo_mode 5
[    0.579223] musb-hdrc: 28/31 max ep, 8192/16384 memory
[    0.579467] musb-hdrc musb-hdrc: USB OTG mode controller at fc0ab000 using DMA, IRQ 124
[    0.579986] NET: Registered protocol family 2
[    0.580322] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.581420] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.583343] TCP bind hash table entries: 65536 (order: 7, 786432 bytes)
[    0.584503] TCP: Hash tables configured (established 131072 bind 65536)
[    0.584503] TCP reno registered
[    0.584533] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.584564] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.584960] NET: Registered protocol family 1
[    0.585388] RPC: Registered named UNIX socket transport module.
[    0.585388] RPC: Registered udp transport module.
[    0.585388] RPC: Registered tcp transport module.
[    0.585418] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.654663] omap_dsp_init: 600000 bytes @ be800000
[    0.655273] audit: initializing netlink socket (disabled)
[    0.655334] type=2000 audit(0.664:1): initialized
[    0.826324] highmem bounce pool size: 64 pages
[    0.834014] VFS: Disk quotas dquot_6.5.2
[    0.834472] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.838989] fuse init (API version 7.17)
[    0.840209] Btrfs loaded
[    0.840240] msgmni has been set to 1491
[    0.841461] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.841491] io scheduler noop registered
[    0.841491] io scheduler deadline registered
[    0.841583] io scheduler cfq registered (default)
[    0.842254] omap_device: omapdss_dss.-1: new worst case activate latency 0: 30517
[    0.842285] OMAP DSS rev 4.0
[    0.844879] omap_hwmod: dss_core: _wait_target_disable failed
[    0.844879] omap_device: omapdss_dss.-1: new worst case deactivate latency 0: 2563476
[    0.847747] omap_hwmod: dss_core: _wait_target_disable failed
[    0.847778] omap_device: omapdss_dss.-1: new worst case deactivate latency 0: 2593994
[    0.850372] omap_hwmod: dss_dispc: _wait_target_disable failed
[    0.853240] omap_hwmod: dss_dispc: _wait_target_disable failed
[    0.855834] omap_hwmod: dss_core: _wait_target_disable failed
[    0.858428] omap_hwmod: dss_dsi1: _wait_target_disable failed
[    0.861602] omap_hwmod: dss_dispc: _wait_target_disable failed
[    0.864196] omap_hwmod: dss_core: _wait_target_disable failed
[    0.867492] omap_hwmod: dss_dispc: _wait_target_disable failed
[    0.870117] omap_hwmod: dss_core: _wait_target_disable failed
[    0.870269] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.154815] omap_uart.0: ttyO0 at MMIO 0x4806a000 (irq = 104) is a OMAP UART0
[    1.279663] omap_uart.1: ttyO1 at MMIO 0x4806c000 (irq = 105) is a OMAP UART1
[    1.404663] omap_uart.2: ttyO2 at MMIO 0x48020000 (irq = 106) is a OMAP UART2
[    1.419036] console [ttyO2] enabled
[    1.529693] omap_uart.3: ttyO3 at MMIO 0x4806e000 (irq = 102) is a OMAP UART3
[    1.661163] brd: module loaded
[    1.664428] loop: module loaded
[    1.666046] omap2-nand driver initializing
[    1.666229] OneNAND driver initializing
[    1.666870] usbcore: registered new interface driver cdc_ether
[    1.666900] usbcore: registered new interface driver rndis_host
[    1.666961] cdc_ncm: 04-Aug-2011
[    1.666992] usbcore: registered new interface driver cdc_ncm
[    1.667327] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.667449] _regulator_get: ehci-omap.0 supply hsusb0 not found, using dummy regulator
[    1.667541] ehci-omap ehci-omap.0: OMAP-EHCI Host Controller
[    1.667755] ehci-omap ehci-omap.0: new USB bus registered, assigned bus number 1
[    1.667877] ehci-omap ehci-omap.0: irq 109, io mem 0x4a064c00
[    1.678100] ehci-omap ehci-omap.0: USB 2.0 started, EHCI 1.00
[    1.678741] hub 1-0:1.0: USB hub found
[    1.678771] hub 1-0:1.0: 3 ports detected
[    1.709381] Initializing USB Mass Storage driver...
[    1.709503] usbcore: registered new interface driver usb-storage
[    1.709533] USB Mass Storage support registered.
[    1.709594] usbcore: registered new interface driver libusual
[    1.709716] udc: OMAP UDC driver, version: 4 October 2004 (iso) (dma)
[    1.709899]  gadget: using random self ethernet address
[    1.709899]  gadget: using random host ethernet address
[    1.710876] usb0: MAC da:7e:b7:d1:2a:07
[    1.710876] usb0: HOST MAC 5e:5e:81:5a:e0:88
[    1.710937]  gadget: Ethernet Gadget, version: Memorial Day 2008
[    1.710937]  gadget: g_ether ready
[    1.905853] musb-hdrc musb-hdrc: MUSB HDRC host driver
[    1.906127] musb-hdrc musb-hdrc: new USB bus registered, assigned bus number 2
[    1.906646] hub 2-0:1.0: USB hub found
[    1.906646] hub 2-0:1.0: 1 port detected
[    1.907135] mousedev: PS/2 mouse device common for all mice
[    1.908203] omap_device: omap_i2c.1: new worst case deactivate latency 0: 30517
[    1.910217] twl_rtc twl_rtc: rtc core: registered twl_rtc as rtc0
[    1.910430] i2c /dev entries driver
[    1.911102] Linux media interface: v0.10
[    1.911224] lirc_dev: IR Remote Control driver registered, major 249 
[    1.911224] Driver for 1-wire Dallas network protocol.
[    1.911529] omap_device: omap_wdt.-1: new worst case activate latency 0: 91552
[    1.912048] OMAP Watchdog Timer Rev 0x00: initial timeout 60 sec
[    1.912811] device-mapper: uevent: version 1.0.3
[    1.913208] device-mapper: ioctl: 4.21.0-ioctl (2011-07-06) initialised: dm-devel@redhat.com
[    1.913421] device-mapper: multipath: version 1.3.0 loaded
[    1.913421] device-mapper: multipath round-robin: version 1.0.0 loaded
[    1.914031] cpuidle: using governor ladder
[    1.914031] cpuidle: using governor menu
[    1.914093] sdhci: Secure Digital Host Controller Interface driver
[    1.914093] sdhci: Copyright(c) Pierre Ossman
[    1.914215] omap_device: omap_hsmmc.0: new worst case activate latency 0: 30517
[    1.915405] _regulator_get: omap_hsmmc.0 supply vmmc_aux not found, using dummy regulator
[    1.916656] _regulator_get: omap_hsmmc.4 supply vmmc_aux not found, using dummy regulator
[    1.917327] Registered led device: pandaboard::status1
[    1.917388] Registered led device: pandaboard::status2
[    1.918060] usbcore: registered new interface driver snd-usb-6fire
[    1.918975] ALSA device list:
[    1.919006]   No soundcards found.
[    1.919189] oprofile: using arm/armv7-ca9
[    1.920349] TCP cubic registered
[    1.920959] NET: Registered protocol family 10
[    1.923919] NET: Registered protocol family 17
[    1.924072] Registering the dns_resolver key type
[    1.924102] VFP support v0.3: implementor 41 architecture 3 part 30 variant 9 rev 1
[    1.924133] ThumbEE CPU extension supported.
[    1.924133] Registering SWP/SWPB emulation handler
[    1.926940] Power Management for TI OMAP4.
[    1.931304] sr_init: No PMIC hook to init smartreflex
[    1.931427] smartreflex smartreflex.0: omap_sr_probe: SmartReflex driver initialized
[    1.931518] smartreflex smartreflex.1: omap_sr_probe: SmartReflex driver initialized
[    1.931640] smartreflex smartreflex.2: omap_sr_probe: SmartReflex driver initialized
[    1.931732] SmartReflex Class3 initialized
[    1.937194] clock: disabling unused clocks to save power
[    1.937774] registered taskstats version 1
[    1.953216] omap_hwmod: dss_dispc: _wait_target_disable failed
[    1.955780] omap_hwmod: dss_core: _wait_target_disable failed
[    1.959838] Console: switching to colour frame buffer device 80x30
[    1.972473] omap_hwmod: dss_dispc: _wait_target_disable failed
[    1.975036] omap_hwmod: dss_core: _wait_target_disable failed
[    1.975128] omapdss DPI: Could not find exact pixel clock. Requested 23500 kHz, got 23630 kHz
[    1.977508] regulator_init_complete: VANA: incomplete constraints, leaving on
[    1.978424] regulator_init_complete: VDAC: incomplete constraints, leaving on
[    1.978729] regulator_init_complete: VCXIO: incomplete constraints, leaving on
[    1.979339] regulator_init_complete: VUSB: incomplete constraints, leaving on
[    1.980041] twl_rtc twl_rtc: setting system clock to 2000-01-01 02:05:00 UTC (946692300)
[    1.980407] md: Waiting for all devices to be available before autodetect
[    1.980407] md: If you don't use raid, use raid=noautodetect
[    1.980957] md: Autodetecting RAID arrays.
[    1.980957] md: Scanned 0 and added 0 devices.
[    1.980987] md: autorun ...
[    1.980987] md: ... autorun DONE.
[    1.981079] Waiting for root device /dev/mmcblk0p2...
[    2.006256] usb 1-1: new high speed USB device number 2 using ehci-omap
[    2.097381] mmc0: host does not support reading read-only switch. assuming write-enable.
[    2.097442] mmc0: new SDHC card at address e624
[    2.097778] mmcblk0: mmc0:e624 SD04G 3.69 GiB 
[    2.106536]  mmcblk0: p1 p2
[    2.163299] hub 1-1:1.0: USB hub found
[    2.163421] hub 1-1:1.0: 5 ports detected
[    2.206146] kjournald starting.  Commit interval 5 seconds
[    2.206176] EXT3-fs (mmcblk0p2): warning: maximal mount count reached, running e2fsck is recommended
[    2.212799] EXT3-fs (mmcblk0p2): using internal journal
[    2.212829] EXT3-fs (mmcblk0p2): mounted filesystem with ordered data mode
[    2.212860] VFS: Mounted root (ext3 filesystem) on device 179:2.
[    2.216033] devtmpfs: mounted
[    2.216308] Freeing init memory: 328K
[    2.223358] mmc1: card claims to support voltages below the defined range. These will be ignored.
[    2.242004] mmc1: queuing unknown CIS tuple 0x91 (3 bytes)
[    2.243194] mmc1: new SDIO card at address 0001
[    2.342193] omap_device: omap_hsmmc.4: new worst case deactivate latency 0: 30517
[    2.451690] usb 1-1.1: new high speed USB device number 3 using ehci-omap
[    3.130432] udevd[82]: starting version 175
[    3.476013] cfg80211: Calling CRDA to update world regulatory domain
[    3.551086] smsc95xx v1.0.4
[    3.665283] smsc95xx 1-1.1:1.0: eth0: register 'smsc95xx' at usb-ehci-omap.0-1.1, smsc95xx USB 2.0 Ethernet, 1a:76:41:2f:73:46
[    3.665405] usbcore: registered new interface driver smsc95xx
[    3.827087] omap_device: omap_hsmmc.4: new worst case deactivate latency 0: 61035
[    4.031524] cfg80211: Updating information on frequency 2412 MHz for a 20 MHz width channel with regulatory rule:
[    4.031555] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (600 mBi, 2000 mBm)
[    4.031555] cfg80211: Updating information on frequency 2417 MHz for a 20 MHz width channel with regulatory rule:
[    4.031555] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (600 mBi, 2000 mBm)
[    4.031585] cfg80211: Updating information on frequency 2422 MHz for a 20 MHz width channel with regulatory rule:
[    4.031585] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (600 mBi, 2000 mBm)
[    4.031585] cfg80211: Updating information on frequency 2427 MHz for a 20 MHz width channel with regulatory rule:
[    4.031616] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (600 mBi, 2000 mBm)
[    4.031616] cfg80211: Updating information on frequency 2432 MHz for a 20 MHz width channel with regulatory rule:
[    4.031646] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (600 mBi, 2000 mBm)
[    4.031646] cfg80211: Updating information on frequency 2437 MHz for a 20 MHz width channel with regulatory rule:
[    4.031646] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (600 mBi, 2000 mBm)
[    4.031677] cfg80211: Updating information on frequency 2442 MHz for a 20 MHz width channel with regulatory rule:
[    4.031677] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (600 mBi, 2000 mBm)
[    4.031677] cfg80211: Updating information on frequency 2447 MHz for a 20 MHz width channel with regulatory rule:
[    4.031707] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (600 mBi, 2000 mBm)
[    4.031707] cfg80211: Updating information on frequency 2452 MHz for a 20 MHz width channel with regulatory rule:
[    4.031707] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (600 mBi, 2000 mBm)
[    4.031738] cfg80211: Updating information on frequency 2457 MHz for a 20 MHz width channel with regulatory rule:
[    4.031738] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (600 mBi, 2000 mBm)
[    4.031738] cfg80211: Updating information on frequency 2462 MHz for a 20 MHz width channel with regulatory rule:
[    4.031768] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (600 mBi, 2000 mBm)
[    4.031768] cfg80211: Updating information on frequency 2467 MHz for a 20 MHz width channel with regulatory rule:
[    4.031768] cfg80211: 2457000 KHz - 2482000 KHz @  KHz), (600 mBi, 2000 mBm)
[    4.031799] cfg80211: Updating information on frequency 2472 MHz for a 20 MHz width channel with regulatory rule:
[    4.031799] cfg80211: 2457000 KHz - 2482000 KHz @  KHz), (600 mBi, 2000 mBm)
[    4.031799] cfg80211: Updating information on frequency 2484 MHz for a 20 MHz width channel with regulatory rule:
[    4.031829] cfg80211: 2474000 KHz - 2494000 KHz @  KHz), (600 mBi, 2000 mBm)
[    4.031829] cfg80211: Disabling freq 5035 MHz
[    4.031829] cfg80211: Disabling freq 5040 MHz
[    4.031860] cfg80211: Disabling freq 5045 MHz
[    4.031860] cfg80211: Disabling freq 5055 MHz
[    4.031860] cfg80211: Disabling freq 5060 MHz
[    4.031860] cfg80211: Disabling freq 5080 MHz
[    4.031860] cfg80211: Disabling freq 5170 MHz
[    4.031890] cfg80211: Updating information on frequency 5180 MHz for a 20 MHz width channel with regulatory rule:
[    4.031890] cfg80211: 5170000 KHz - 5250000 KHz @  KHz), (600 mBi, 2000 mBm)
[    4.031890] cfg80211: Updating information on frequency 5190 MHz for a 20 MHz width channel with regulatory rule:
[    4.031921] cfg80211: 5170000 KHz - 5250000 KHz @  KHz), (600 mBi, 2000 mBm)
[    4.031921] cfg80211: Updating information on frequency 5200 MHz for a 20 MHz width channel with regulatory rule:
[    4.031951] cfg80211: 5170000 KHz - 5250000 KHz @  KHz), (600 mBi, 2000 mBm)
[    4.031951] cfg80211: Updating information on frequency 5210 MHz for a 20 MHz width channel with regulatory rule:
[    4.031951] cfg80211: 5170000 KHz - 5250000 KHz @  KHz), (600 mBi, 2000 mBm)
[    4.031982] cfg80211: Updating information on frequency 5220 MHz for a 20 MHz width channel with regulatory rule:
[    4.031982] cfg80211: 5170000 KHz - 5250000 KHz @  KHz), (600 mBi, 2000 mBm)
[    4.031982] cfg80211: Updating information on frequency 5230 MHz for a 20 MHz width channel with regulatory rule:
[    4.032012] cfg80211: 5170000 KHz - 5250000 KHz @  KHz), (600 mBi, 2000 mBm)
[    4.032012] cfg80211: Updating information on frequency 5240 MHz for a 20 MHz width channel with regulatory rule:
[    4.032012] cfg80211: 5170000 KHz - 5250000 KHz @  KHz), (600 mBi, 2000 mBm)
[    4.032043] cfg80211: Disabling freq 5260 MHz
[    4.032043] cfg80211: Disabling freq 5280 MHz
[    4.032043] cfg80211: Disabling freq 5300 MHz
[    4.032043] cfg80211: Disabling freq 5320 MHz
[    4.032043] cfg80211: Disabling freq 5500 MHz
[    4.032073] cfg80211: Disabling freq 5520 MHz
[    4.032073] cfg80211: Disabling freq 5540 MHz
[    4.032073] cfg80211: Disabling freq 5560 MHz
[    4.032073] cfg80211: Disabling freq 5580 MHz
[    4.032104] cfg80211: Disabling freq 5600 MHz
[    4.032104] cfg80211: Disabling freq 5620 MHz
[    4.032104] cfg80211: Disabling freq 5640 MHz
[    4.032104] cfg80211: Disabling freq 5660 MHz
[    4.032135] cfg80211: Disabling freq 5680 MHz
[    4.032135] cfg80211: Disabling freq 5700 MHz
[    4.032135] cfg80211: Updating information on frequency 5745 MHz for a 20 MHz width channel with regulatory rule:
[    4.032135] cfg80211: 5735000 KHz - 5835000 KHz @  KHz), (600 mBi, 2000 mBm)
[    4.032165] cfg80211: Updating information on frequency 5765 MHz for a 20 MHz width channel with regulatory rule:
[    4.032165] cfg80211: 5735000 KHz - 5835000 KHz @  KHz), (600 mBi, 2000 mBm)
[    4.032165] cfg80211: Updating information on frequency 5785 MHz for a 20 MHz width channel with regulatory rule:
[    4.032196] cfg80211: 5735000 KHz - 5835000 KHz @  KHz), (600 mBi, 2000 mBm)
[    4.032196] cfg80211: Updating information on frequency 5805 MHz for a 20 MHz width channel with regulatory rule:
[    4.032226] cfg80211: 5735000 KHz - 5835000 KHz @  KHz), (600 mBi, 2000 mBm)
[    4.032226] cfg80211: Updating information on frequency 5825 MHz for a 20 MHz width channel with regulatory rule:
[    4.032226] cfg80211: 5735000 KHz - 5835000 KHz @  KHz), (600 mBi, 2000 mBm)
[    4.050140] wl1271: loaded
[    4.162597] omap_device: musb-omap2430.-1: new worst case deactivate latency 0: 30517
[    4.500213] EXT3-fs (mmcblk0p2): warning: maximal mount count reached, running e2fsck is recommended
[    4.502258] EXT3-fs (mmcblk0p2): using internal journal
[    8.288970] smsc95xx 1-1.1:1.0: eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
[   17.615600] eth0: no IPv6 routers present
[  137.758300] wl1271: firmware booted (Rev 6.1.5.50.74)
[  141.480346] wlan0: Selected IBSS BSSID 02:72:cf:28:19:1a based on configured SSID
[  148.537445] wlan0: no IPv6 routers present
[  193.076568] device wlan0 entered promiscuous mode
[  201.816101] device wlan0 left promiscuous mode
[  203.818756] wl1271: ERROR command complete timeout
[  203.823791] ------------[ cut here ]------------
[  203.823913] WARNING: at drivers/net/wireless/wl12xx/cmd.c:107 wl1271_cmd_send+0x334/0x368 [wl12xx]()
[  203.823944] Modules linked in: arc4 wl12xx_sdio wl12xx mac80211 smsc95xx cfg80211 rfkill
[  203.823974] [<c001372c>] (unwind_backtrace+0x0/0xe0) from [<c0046aa4>] (warn_slowpath_common+0x4c/0x64)
[  203.824005] [<c0046aa4>] (warn_slowpath_common+0x4c/0x64) from [<c0046ad4>] (warn_slowpath_null+0x18/0x1c)
[  203.824035] [<c0046ad4>] (warn_slowpath_null+0x18/0x1c) from [<bf13dad0>] (wl1271_cmd_send+0x334/0x368 [wl12xx])
[  203.824127] [<bf13dad0>] (wl1271_cmd_send+0x334/0x368 [wl12xx]) from [<bf13e29c>] (wl1271_cmd_configure+0x34/0x54 [wl12xx])
[  203.824188] [<bf13e29c>] (wl1271_cmd_configure+0x34/0x54 [wl12xx]) from [<bf1421a4>] (wl1271_acx_group_address_tbl+0x70/0xa4 [wl12xx])
[  203.824249] [<bf1421a4>] (wl1271_acx_group_address_tbl+0x70/0xa4 [wl12xx]) from [<bf13cad4>] (wl1271_op_configure_filter+0x8c/0xdc [wl12xx])
[  203.824493] [<bf13cad4>] (wl1271_op_configure_filter+0x8c/0xdc [wl12xx]) from [<bf0e3de4>] (ieee80211_configure_filter+0x154/0x180 [mac80211])
[  203.824584] [<bf0e3de4>] (ieee80211_configure_filter+0x154/0x180 [mac80211]) from [<c005fc5c>] (process_one_work+0x270/0x454)
[  203.824584] [<c005fc5c>] (process_one_work+0x270/0x454) from [<c00601a4>] (worker_thread+0x1a8/0x2a4)
[  203.824615] [<c00601a4>] (worker_thread+0x1a8/0x2a4) from [<c00640c0>] (kthread+0x7c/0x84)
[  203.824645] [<c00640c0>] (kthread+0x7c/0x84) from [<c000df3c>] (kernel_thread_exit+0x0/0x8)
[  203.824676] ---[ end trace 174147eb56df8880 ]---
[  203.824707] wl1271: WARNING CONFIGURE command NOK
[  203.824707] wl1271: WARNING failed to set group addr table: -110
[  203.824768] wl1271: Reading FW panic log
[  205.826599] wl1271: ERROR command complete timeout
[  205.831634] ------------[ cut here ]------------
[  205.831695] WARNING: at drivers/net/wireless/wl12xx/cmd.c:107 wl1271_cmd_send+0x334/0x368 [wl12xx]()
[  205.831726] Modules linked in: arc4 wl12xx_sdio wl12xx mac80211 smsc95xx cfg80211 rfkill
[  205.831756] [<c001372c>] (unwind_backtrace+0x0/0xe0) from [<c0046aa4>] (warn_slowpath_common+0x4c/0x64)
[  205.831787] [<c0046aa4>] (warn_slowpath_common+0x4c/0x64) from [<c0046ad4>] (warn_slowpath_null+0x18/0x1c)
[  205.831817] [<c0046ad4>] (warn_slowpath_null+0x18/0x1c) from [<bf13dad0>] (wl1271_cmd_send+0x334/0x368 [wl12xx])
[  205.831878] [<bf13dad0>] (wl1271_cmd_send+0x334/0x368 [wl12xx]) from [<bf13f4ac>] (wl12xx_cmd_stop_fwlog+0x50/0x80 [wl12xx])
[  205.831939] [<bf13f4ac>] (wl12xx_cmd_stop_fwlog+0x50/0x80 [wl12xx]) from [<bf13c3e4>] (wl1271_recovery_work+0xac/0x2b0 [wl12xx])
[  205.831970] [<bf13c3e4>] (wl1271_recovery_work+0xac/0x2b0 [wl12xx]) from [<c005fc5c>] (process_one_work+0x270/0x454)
[  205.832000] [<c005fc5c>] (process_one_work+0x270/0x454) from [<c00601a4>] (worker_thread+0x1a8/0x2a4)
[  205.832031] [<c00601a4>] (worker_thread+0x1a8/0x2a4) from [<c00640c0>] (kthread+0x7c/0x84)
[  205.832031] [<c00640c0>] (kthread+0x7c/0x84) from [<c000df3c>] (kernel_thread_exit+0x0/0x8)
[  205.832061] ---[ end trace 174147eb56df8881 ]---
[  205.832061] wl1271: ERROR failed to send stop firmware logger command
[  205.841308] wl1271: Hardware recovery in progress. FW ver: Rev 6.1.5.50.74 pc: 0x268f9
[  205.841308] wl1271: down
[  205.841491] ieee80211 phy0: Hardware restart was requested
[  206.359405] wl1271: firmware booted (Rev 6.1.5.50.74)

--------------080700080507070301020005
Content-Type: text/plain;
 name="tcpdump.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="tcpdump.txt"

dGNwZHVtcDogdmVyYm9zZSBvdXRwdXQgc3VwcHJlc3NlZCwgdXNlIC12IG9yIC12diBmb3Ig
ZnVsbCBwcm90b2NvbCBkZWNvZGUKbGlzdGVuaW5nIG9uIHdsYW4wLCBsaW5rLXR5cGUgRU4x
ME1CIChFdGhlcm5ldCksIGNhcHR1cmUgc2l6ZSA2NTUzNSBieXRlcwoxMDo0MTowNC45MjU5
NjYgQVJQLCBSZXF1ZXN0IHdoby1oYXMgMTAuMTAuMTAuNTMgdGVsbCAxMC4xMC4xMC41Miwg
bGVuZ3RoIDI4CjEwOjQxOjA0LjkyNjA1NyBBUlAsIFJlcGx5IDEwLjEwLjEwLjUzIGlzLWF0
IDdlOjc4OjQ3OjhjOjI2OjUzIChvdWkgVW5rbm93biksIGxlbmd0aCAyOAoxMDo0MTowNC45
Mjg4MzQgSVAgMTAuMTAuMTAuNTIgPiAxMC4xMC4xMC41MzogSUNNUCBlY2hvIHJlcXVlc3Qs
IGlkIDQ0Mywgc2VxIDEsIGxlbmd0aCA2NAoxMDo0MTowNC45Mjg5MjYgSVAgMTAuMTAuMTAu
NTMgPiAxMC4xMC4xMC41MjogSUNNUCBlY2hvIHJlcGx5LCBpZCA0NDMsIHNlcSAxLCBsZW5n
dGggNjQKMTA6NDE6MDUuOTE5MTMwIElQIDEwLjEwLjEwLjUyID4gMTAuMTAuMTAuNTM6IElD
TVAgZWNobyByZXF1ZXN0LCBpZCA0NDMsIHNlcSAyLCBsZW5ndGggNjQKMTA6NDE6MDUuOTE5
MTYwIElQIDEwLjEwLjEwLjUzID4gMTAuMTAuMTAuNTI6IElDTVAgZWNobyByZXBseSwgaWQg
NDQzLCBzZXEgMiwgbGVuZ3RoIDY0Cl5DCjYgcGFja2V0cyBjYXB0dXJlZAo2IHBhY2tldHMg
cmVjZWl2ZWQgYnkgZmlsdGVyCjAgcGFja2V0cyBkcm9wcGVkIGJ5IGtlcm5lbAo=
--------------080700080507070301020005
Content-Type: text/plain;
 name="config"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="config"

IwojIEF1dG9tYXRpY2FsbHkgZ2VuZXJhdGVkIGZpbGU7IERPIE5PVCBFRElULgojIExpbnV4
L2FybSAzLjEuNiBLZXJuZWwgQ29uZmlndXJhdGlvbgojCkNPTkZJR19BUk09eQpDT05GSUdf
U1lTX1NVUFBPUlRTX0FQTV9FTVVMQVRJT049eQpDT05GSUdfSEFWRV9TQ0hFRF9DTE9DSz15
CkNPTkZJR19HRU5FUklDX0dQSU89eQojIENPTkZJR19BUkNIX1VTRVNfR0VUVElNRU9GRlNF
VCBpcyBub3Qgc2V0CkNPTkZJR19HRU5FUklDX0NMT0NLRVZFTlRTPXkKQ09ORklHX0dFTkVS
SUNfQ0xPQ0tFVkVOVFNfQlJPQURDQVNUPXkKQ09ORklHX0tUSU1FX1NDQUxBUj15CkNPTkZJ
R19IQVZFX1BST0NfQ1BVPXkKQ09ORklHX1NUQUNLVFJBQ0VfU1VQUE9SVD15CkNPTkZJR19M
T0NLREVQX1NVUFBPUlQ9eQpDT05GSUdfVFJBQ0VfSVJRRkxBR1NfU1VQUE9SVD15CkNPTkZJ
R19IQVJESVJRU19TV19SRVNFTkQ9eQpDT05GSUdfR0VORVJJQ19JUlFfUFJPQkU9eQpDT05G
SUdfR0VORVJJQ19MT0NLQlJFQUs9eQpDT05GSUdfUldTRU1fR0VORVJJQ19TUElOTE9DSz15
CkNPTkZJR19BUkNIX0hBU19DUFVGUkVRPXkKQ09ORklHX0FSQ0hfSEFTX0NQVV9JRExFX1dB
SVQ9eQpDT05GSUdfR0VORVJJQ19IV0VJR0hUPXkKQ09ORklHX0dFTkVSSUNfQ0FMSUJSQVRF
X0RFTEFZPXkKQ09ORklHX05FRURfRE1BX01BUF9TVEFURT15CkNPTkZJR19WRUNUT1JTX0JB
U0U9MHhmZmZmMDAwMApDT05GSUdfQVJNX1BBVENIX1BIWVNfVklSVD15CkNPTkZJR19ERUZD
T05GSUdfTElTVD0iL2xpYi9tb2R1bGVzLyRVTkFNRV9SRUxFQVNFLy5jb25maWciCkNPTkZJ
R19IQVZFX0lSUV9XT1JLPXkKQ09ORklHX0lSUV9XT1JLPXkKCiMKIyBHZW5lcmFsIHNldHVw
CiMKQ09ORklHX0VYUEVSSU1FTlRBTD15CkNPTkZJR19JTklUX0VOVl9BUkdfTElNSVQ9MzIK
Q09ORklHX0NST1NTX0NPTVBJTEU9IiIKQ09ORklHX0xPQ0FMVkVSU0lPTj0iLUFSQ0giCiMg
Q09ORklHX0xPQ0FMVkVSU0lPTl9BVVRPIGlzIG5vdCBzZXQKQ09ORklHX0hBVkVfS0VSTkVM
X0daSVA9eQpDT05GSUdfSEFWRV9LRVJORUxfTFpNQT15CkNPTkZJR19IQVZFX0tFUk5FTF9M
Wk89eQpDT05GSUdfS0VSTkVMX0daSVA9eQojIENPTkZJR19LRVJORUxfTFpNQSBpcyBub3Qg
c2V0CiMgQ09ORklHX0tFUk5FTF9MWk8gaXMgbm90IHNldApDT05GSUdfREVGQVVMVF9IT1NU
TkFNRT0iKG5vbmUpIgpDT05GSUdfU1dBUD15CkNPTkZJR19TWVNWSVBDPXkKQ09ORklHX1NZ
U1ZJUENfU1lTQ1RMPXkKQ09ORklHX1BPU0lYX01RVUVVRT15CkNPTkZJR19QT1NJWF9NUVVF
VUVfU1lTQ1RMPXkKQ09ORklHX0JTRF9QUk9DRVNTX0FDQ1Q9eQpDT05GSUdfQlNEX1BST0NF
U1NfQUNDVF9WMz15CkNPTkZJR19GSEFORExFPXkKQ09ORklHX1RBU0tTVEFUUz15CkNPTkZJ
R19UQVNLX0RFTEFZX0FDQ1Q9eQpDT05GSUdfVEFTS19YQUNDVD15CkNPTkZJR19UQVNLX0lP
X0FDQ09VTlRJTkc9eQpDT05GSUdfQVVESVQ9eQpDT05GSUdfSEFWRV9HRU5FUklDX0hBUkRJ
UlFTPXkKCiMKIyBJUlEgc3Vic3lzdGVtCiMKQ09ORklHX0dFTkVSSUNfSEFSRElSUVM9eQpD
T05GSUdfSEFWRV9TUEFSU0VfSVJRPXkKQ09ORklHX0dFTkVSSUNfSVJRX1NIT1c9eQpDT05G
SUdfR0VORVJJQ19JUlFfQ0hJUD15CkNPTkZJR19JUlFfRE9NQUlOPXkKQ09ORklHX1NQQVJT
RV9JUlE9eQoKIwojIFJDVSBTdWJzeXN0ZW0KIwpDT05GSUdfVFJFRV9QUkVFTVBUX1JDVT15
CkNPTkZJR19QUkVFTVBUX1JDVT15CiMgQ09ORklHX1JDVV9UUkFDRSBpcyBub3Qgc2V0CkNP
TkZJR19SQ1VfRkFOT1VUPTMyCiMgQ09ORklHX1JDVV9GQU5PVVRfRVhBQ1QgaXMgbm90IHNl
dAojIENPTkZJR19UUkVFX1JDVV9UUkFDRSBpcyBub3Qgc2V0CiMgQ09ORklHX1JDVV9CT09T
VCBpcyBub3Qgc2V0CkNPTkZJR19JS0NPTkZJRz15CkNPTkZJR19JS0NPTkZJR19QUk9DPXkK
Q09ORklHX0xPR19CVUZfU0hJRlQ9MTcKQ09ORklHX0NHUk9VUFM9eQojIENPTkZJR19DR1JP
VVBfREVCVUcgaXMgbm90IHNldApDT05GSUdfQ0dST1VQX0ZSRUVaRVI9eQpDT05GSUdfQ0dS
T1VQX0RFVklDRT15CkNPTkZJR19DUFVTRVRTPXkKQ09ORklHX1BST0NfUElEX0NQVVNFVD15
CkNPTkZJR19DR1JPVVBfQ1BVQUNDVD15CkNPTkZJR19SRVNPVVJDRV9DT1VOVEVSUz15CkNP
TkZJR19DR1JPVVBfTUVNX1JFU19DVExSPXkKQ09ORklHX0NHUk9VUF9NRU1fUkVTX0NUTFJf
U1dBUD15CkNPTkZJR19DR1JPVVBfTUVNX1JFU19DVExSX1NXQVBfRU5BQkxFRD15CkNPTkZJ
R19DR1JPVVBfUEVSRj15CkNPTkZJR19DR1JPVVBfU0NIRUQ9eQpDT05GSUdfRkFJUl9HUk9V
UF9TQ0hFRD15CkNPTkZJR19SVF9HUk9VUF9TQ0hFRD15CkNPTkZJR19CTEtfQ0dST1VQPXkK
IyBDT05GSUdfREVCVUdfQkxLX0NHUk9VUCBpcyBub3Qgc2V0CkNPTkZJR19OQU1FU1BBQ0VT
PXkKQ09ORklHX1VUU19OUz15CkNPTkZJR19JUENfTlM9eQpDT05GSUdfVVNFUl9OUz15CkNP
TkZJR19QSURfTlM9eQpDT05GSUdfTkVUX05TPXkKIyBDT05GSUdfU0NIRURfQVVUT0dST1VQ
IGlzIG5vdCBzZXQKQ09ORklHX01NX09XTkVSPXkKIyBDT05GSUdfU1lTRlNfREVQUkVDQVRF
RCBpcyBub3Qgc2V0CkNPTkZJR19SRUxBWT15CkNPTkZJR19CTEtfREVWX0lOSVRSRD15CkNP
TkZJR19JTklUUkFNRlNfU09VUkNFPSIiCkNPTkZJR19SRF9HWklQPXkKQ09ORklHX1JEX0Ja
SVAyPXkKQ09ORklHX1JEX0xaTUE9eQpDT05GSUdfUkRfWFo9eQpDT05GSUdfUkRfTFpPPXkK
Q09ORklHX0NDX09QVElNSVpFX0ZPUl9TSVpFPXkKQ09ORklHX1NZU0NUTD15CkNPTkZJR19B
Tk9OX0lOT0RFUz15CkNPTkZJR19FWFBFUlQ9eQpDT05GSUdfVUlEMTY9eQpDT05GSUdfU1lT
Q1RMX1NZU0NBTEw9eQpDT05GSUdfS0FMTFNZTVM9eQpDT05GSUdfS0FMTFNZTVNfQUxMPXkK
Q09ORklHX0hPVFBMVUc9eQpDT05GSUdfUFJJTlRLPXkKQ09ORklHX0JVRz15CkNPTkZJR19F
TEZfQ09SRT15CkNPTkZJR19CQVNFX0ZVTEw9eQpDT05GSUdfRlVURVg9eQpDT05GSUdfRVBP
TEw9eQpDT05GSUdfU0lHTkFMRkQ9eQpDT05GSUdfVElNRVJGRD15CkNPTkZJR19FVkVOVEZE
PXkKQ09ORklHX1NITUVNPXkKQ09ORklHX0FJTz15CkNPTkZJR19FTUJFRERFRD15CkNPTkZJ
R19IQVZFX1BFUkZfRVZFTlRTPXkKQ09ORklHX1BFUkZfVVNFX1ZNQUxMT0M9eQoKIwojIEtl
cm5lbCBQZXJmb3JtYW5jZSBFdmVudHMgQW5kIENvdW50ZXJzCiMKQ09ORklHX1BFUkZfRVZF
TlRTPXkKQ09ORklHX1BFUkZfQ09VTlRFUlM9eQojIENPTkZJR19ERUJVR19QRVJGX1VTRV9W
TUFMTE9DIGlzIG5vdCBzZXQKQ09ORklHX1ZNX0VWRU5UX0NPVU5URVJTPXkKQ09ORklHX1NM
VUJfREVCVUc9eQojIENPTkZJR19DT01QQVRfQlJLIGlzIG5vdCBzZXQKIyBDT05GSUdfU0xB
QiBpcyBub3Qgc2V0CkNPTkZJR19TTFVCPXkKIyBDT05GSUdfU0xPQiBpcyBub3Qgc2V0CkNP
TkZJR19QUk9GSUxJTkc9eQpDT05GSUdfVFJBQ0VQT0lOVFM9eQpDT05GSUdfT1BST0ZJTEU9
eQpDT05GSUdfSEFWRV9PUFJPRklMRT15CkNPTkZJR19LUFJPQkVTPXkKQ09ORklHX0tSRVRQ
Uk9CRVM9eQpDT05GSUdfSEFWRV9LUFJPQkVTPXkKQ09ORklHX0hBVkVfS1JFVFBST0JFUz15
CkNPTkZJR19VU0VfR0VORVJJQ19TTVBfSEVMUEVSUz15CkNPTkZJR19IQVZFX1JFR1NfQU5E
X1NUQUNLX0FDQ0VTU19BUEk9eQpDT05GSUdfSEFWRV9DTEs9eQpDT05GSUdfSEFWRV9ETUFf
QVBJX0RFQlVHPXkKQ09ORklHX0hBVkVfSFdfQlJFQUtQT0lOVD15CgojCiMgR0NPVi1iYXNl
ZCBrZXJuZWwgcHJvZmlsaW5nCiMKIyBDT05GSUdfR0NPVl9LRVJORUwgaXMgbm90IHNldApD
T05GSUdfSEFWRV9HRU5FUklDX0RNQV9DT0hFUkVOVD15CkNPTkZJR19TTEFCSU5GTz15CkNP
TkZJR19SVF9NVVRFWEVTPXkKQ09ORklHX0JBU0VfU01BTEw9MApDT05GSUdfTU9EVUxFUz15
CiMgQ09ORklHX01PRFVMRV9GT1JDRV9MT0FEIGlzIG5vdCBzZXQKQ09ORklHX01PRFVMRV9V
TkxPQUQ9eQojIENPTkZJR19NT0RVTEVfRk9SQ0VfVU5MT0FEIGlzIG5vdCBzZXQKQ09ORklH
X01PRFZFUlNJT05TPXkKQ09ORklHX01PRFVMRV9TUkNWRVJTSU9OX0FMTD15CkNPTkZJR19T
VE9QX01BQ0hJTkU9eQpDT05GSUdfQkxPQ0s9eQpDT05GSUdfTEJEQUY9eQpDT05GSUdfQkxL
X0RFVl9CU0c9eQojIENPTkZJR19CTEtfREVWX0JTR0xJQiBpcyBub3Qgc2V0CkNPTkZJR19C
TEtfREVWX0lOVEVHUklUWT15CiMgQ09ORklHX0JMS19ERVZfVEhST1RUTElORyBpcyBub3Qg
c2V0CgojCiMgSU8gU2NoZWR1bGVycwojCkNPTkZJR19JT1NDSEVEX05PT1A9eQpDT05GSUdf
SU9TQ0hFRF9ERUFETElORT15CkNPTkZJR19JT1NDSEVEX0NGUT15CiMgQ09ORklHX0NGUV9H
Uk9VUF9JT1NDSEVEIGlzIG5vdCBzZXQKIyBDT05GSUdfREVGQVVMVF9ERUFETElORSBpcyBu
b3Qgc2V0CkNPTkZJR19ERUZBVUxUX0NGUT15CiMgQ09ORklHX0RFRkFVTFRfTk9PUCBpcyBu
b3Qgc2V0CkNPTkZJR19ERUZBVUxUX0lPU0NIRUQ9ImNmcSIKIyBDT05GSUdfSU5MSU5FX1NQ
SU5fVFJZTE9DSyBpcyBub3Qgc2V0CiMgQ09ORklHX0lOTElORV9TUElOX1RSWUxPQ0tfQkgg
aXMgbm90IHNldAojIENPTkZJR19JTkxJTkVfU1BJTl9MT0NLIGlzIG5vdCBzZXQKIyBDT05G
SUdfSU5MSU5FX1NQSU5fTE9DS19CSCBpcyBub3Qgc2V0CiMgQ09ORklHX0lOTElORV9TUElO
X0xPQ0tfSVJRIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5MSU5FX1NQSU5fTE9DS19JUlFTQVZF
IGlzIG5vdCBzZXQKIyBDT05GSUdfSU5MSU5FX1NQSU5fVU5MT0NLIGlzIG5vdCBzZXQKIyBD
T05GSUdfSU5MSU5FX1NQSU5fVU5MT0NLX0JIIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5MSU5F
X1NQSU5fVU5MT0NLX0lSUSBpcyBub3Qgc2V0CiMgQ09ORklHX0lOTElORV9TUElOX1VOTE9D
S19JUlFSRVNUT1JFIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5MSU5FX1JFQURfVFJZTE9DSyBp
cyBub3Qgc2V0CiMgQ09ORklHX0lOTElORV9SRUFEX0xPQ0sgaXMgbm90IHNldAojIENPTkZJ
R19JTkxJTkVfUkVBRF9MT0NLX0JIIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5MSU5FX1JFQURf
TE9DS19JUlEgaXMgbm90IHNldAojIENPTkZJR19JTkxJTkVfUkVBRF9MT0NLX0lSUVNBVkUg
aXMgbm90IHNldAojIENPTkZJR19JTkxJTkVfUkVBRF9VTkxPQ0sgaXMgbm90IHNldAojIENP
TkZJR19JTkxJTkVfUkVBRF9VTkxPQ0tfQkggaXMgbm90IHNldAojIENPTkZJR19JTkxJTkVf
UkVBRF9VTkxPQ0tfSVJRIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5MSU5FX1JFQURfVU5MT0NL
X0lSUVJFU1RPUkUgaXMgbm90IHNldAojIENPTkZJR19JTkxJTkVfV1JJVEVfVFJZTE9DSyBp
cyBub3Qgc2V0CiMgQ09ORklHX0lOTElORV9XUklURV9MT0NLIGlzIG5vdCBzZXQKIyBDT05G
SUdfSU5MSU5FX1dSSVRFX0xPQ0tfQkggaXMgbm90IHNldAojIENPTkZJR19JTkxJTkVfV1JJ
VEVfTE9DS19JUlEgaXMgbm90IHNldAojIENPTkZJR19JTkxJTkVfV1JJVEVfTE9DS19JUlFT
QVZFIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5MSU5FX1dSSVRFX1VOTE9DSyBpcyBub3Qgc2V0
CiMgQ09ORklHX0lOTElORV9XUklURV9VTkxPQ0tfQkggaXMgbm90IHNldAojIENPTkZJR19J
TkxJTkVfV1JJVEVfVU5MT0NLX0lSUSBpcyBub3Qgc2V0CiMgQ09ORklHX0lOTElORV9XUklU
RV9VTkxPQ0tfSVJRUkVTVE9SRSBpcyBub3Qgc2V0CkNPTkZJR19NVVRFWF9TUElOX09OX09X
TkVSPXkKQ09ORklHX0ZSRUVaRVI9eQoKIwojIFN5c3RlbSBUeXBlCiMKQ09ORklHX01NVT15
CiMgQ09ORklHX0FSQ0hfSU5URUdSQVRPUiBpcyBub3Qgc2V0CiMgQ09ORklHX0FSQ0hfUkVB
TFZJRVcgaXMgbm90IHNldAojIENPTkZJR19BUkNIX1ZFUlNBVElMRSBpcyBub3Qgc2V0CiMg
Q09ORklHX0FSQ0hfVkVYUFJFU1MgaXMgbm90IHNldAojIENPTkZJR19BUkNIX0FUOTEgaXMg
bm90IHNldAojIENPTkZJR19BUkNIX0JDTVJJTkcgaXMgbm90IHNldAojIENPTkZJR19BUkNI
X0NMUFM3MTFYIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJDSF9DTlMzWFhYIGlzIG5vdCBzZXQK
IyBDT05GSUdfQVJDSF9HRU1JTkkgaXMgbm90IHNldAojIENPTkZJR19BUkNIX1BSSU1BMiBp
cyBub3Qgc2V0CiMgQ09ORklHX0FSQ0hfRUJTQTExMCBpcyBub3Qgc2V0CiMgQ09ORklHX0FS
Q0hfRVA5M1hYIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJDSF9GT09UQlJJREdFIGlzIG5vdCBz
ZXQKIyBDT05GSUdfQVJDSF9NWEMgaXMgbm90IHNldAojIENPTkZJR19BUkNIX01YUyBpcyBu
b3Qgc2V0CiMgQ09ORklHX0FSQ0hfTkVUWCBpcyBub3Qgc2V0CiMgQ09ORklHX0FSQ0hfSDcy
MFggaXMgbm90IHNldAojIENPTkZJR19BUkNIX0lPUDEzWFggaXMgbm90IHNldAojIENPTkZJ
R19BUkNIX0lPUDMyWCBpcyBub3Qgc2V0CiMgQ09ORklHX0FSQ0hfSU9QMzNYIGlzIG5vdCBz
ZXQKIyBDT05GSUdfQVJDSF9JWFAyM1hYIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJDSF9JWFAy
MDAwIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJDSF9JWFA0WFggaXMgbm90IHNldAojIENPTkZJ
R19BUkNIX0RPVkUgaXMgbm90IHNldAojIENPTkZJR19BUkNIX0tJUktXT09EIGlzIG5vdCBz
ZXQKIyBDT05GSUdfQVJDSF9MUEMzMlhYIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJDSF9NVjc4
WFgwIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJDSF9PUklPTjVYIGlzIG5vdCBzZXQKIyBDT05G
SUdfQVJDSF9NTVAgaXMgbm90IHNldAojIENPTkZJR19BUkNIX0tTODY5NSBpcyBub3Qgc2V0
CiMgQ09ORklHX0FSQ0hfVzkwWDkwMCBpcyBub3Qgc2V0CiMgQ09ORklHX0FSQ0hfTlVDOTNY
IGlzIG5vdCBzZXQKIyBDT05GSUdfQVJDSF9URUdSQSBpcyBub3Qgc2V0CiMgQ09ORklHX0FS
Q0hfUE5YNDAwOCBpcyBub3Qgc2V0CiMgQ09ORklHX0FSQ0hfUFhBIGlzIG5vdCBzZXQKIyBD
T05GSUdfQVJDSF9NU00gaXMgbm90IHNldAojIENPTkZJR19BUkNIX1NITU9CSUxFIGlzIG5v
dCBzZXQKIyBDT05GSUdfQVJDSF9SUEMgaXMgbm90IHNldAojIENPTkZJR19BUkNIX1NBMTEw
MCBpcyBub3Qgc2V0CiMgQ09ORklHX0FSQ0hfUzNDMjQxMCBpcyBub3Qgc2V0CiMgQ09ORklH
X0FSQ0hfUzNDNjRYWCBpcyBub3Qgc2V0CiMgQ09ORklHX0FSQ0hfUzVQNjRYMCBpcyBub3Qg
c2V0CiMgQ09ORklHX0FSQ0hfUzVQQzEwMCBpcyBub3Qgc2V0CiMgQ09ORklHX0FSQ0hfUzVQ
VjIxMCBpcyBub3Qgc2V0CiMgQ09ORklHX0FSQ0hfRVhZTk9TNCBpcyBub3Qgc2V0CiMgQ09O
RklHX0FSQ0hfU0hBUksgaXMgbm90IHNldAojIENPTkZJR19BUkNIX1RDQ185MjYgaXMgbm90
IHNldAojIENPTkZJR19BUkNIX1UzMDAgaXMgbm90IHNldAojIENPTkZJR19BUkNIX1U4NTAw
IGlzIG5vdCBzZXQKIyBDT05GSUdfQVJDSF9OT01BRElLIGlzIG5vdCBzZXQKIyBDT05GSUdf
QVJDSF9EQVZJTkNJIGlzIG5vdCBzZXQKQ09ORklHX0FSQ0hfT01BUD15CiMgQ09ORklHX1BM
QVRfU1BFQVIgaXMgbm90IHNldAojIENPTkZJR19BUkNIX1ZUODUwMCBpcyBub3Qgc2V0CiMg
Q09ORklHX0FSQ0hfWllOUSBpcyBub3Qgc2V0CiMgQ09ORklHX0dQSU9fUENBOTUzWCBpcyBu
b3Qgc2V0CkNPTkZJR19LRVlCT0FSRF9HUElPX1BPTExFRD1tCgojCiMgVEkgT01BUCBDb21t
b24gRmVhdHVyZXMKIwpDT05GSUdfQVJDSF9PTUFQX09URz15CiMgQ09ORklHX0FSQ0hfT01B
UDEgaXMgbm90IHNldApDT05GSUdfQVJDSF9PTUFQMlBMVVM9eQoKIwojIE9NQVAgRmVhdHVy
ZSBTZWxlY3Rpb25zCiMKQ09ORklHX09NQVBfU01BUlRSRUZMRVg9eQpDT05GSUdfT01BUF9T
TUFSVFJFRkxFWF9DTEFTUzM9eQpDT05GSUdfT01BUF9SRVNFVF9DTE9DS1M9eQpDT05GSUdf
T01BUF9NVVg9eQpDT05GSUdfT01BUF9NVVhfREVCVUc9eQpDT05GSUdfT01BUF9NVVhfV0FS
TklOR1M9eQpDT05GSUdfT01BUF9NQ0JTUD15CkNPTkZJR19PTUFQX01CT1hfRldLPW0KQ09O
RklHX09NQVBfTUJPWF9LRklGT19TSVpFPTI1NgpDT05GSUdfT01BUF8zMktfVElNRVI9eQoj
IENPTkZJR19PTUFQM19MMl9BVVhfU0VDVVJFX1NBVkVfUkVTVE9SRSBpcyBub3Qgc2V0CkNP
TkZJR19PTUFQXzMyS19USU1FUl9IWj0xMjgKQ09ORklHX09NQVBfRE1fVElNRVI9eQpDT05G
SUdfT01BUF9QTV9OT09QPXkKCiMKIyBUSSBPTUFQMi8zLzQgU3BlY2lmaWMgRmVhdHVyZXMK
IwpDT05GSUdfQVJDSF9PTUFQMlBMVVNfVFlQSUNBTD15CiMgQ09ORklHX0FSQ0hfT01BUDIg
aXMgbm90IHNldApDT05GSUdfQVJDSF9PTUFQMz15CkNPTkZJR19BUkNIX09NQVA0PXkKQ09O
RklHX1NPQ19PTUFQMzQzMD15CkNPTkZJR19TT0NfT01BUFRJODE2WD15CkNPTkZJR19PTUFQ
X1BBQ0tBR0VfQ0JCPXkKQ09ORklHX09NQVBfUEFDS0FHRV9DVVM9eQpDT05GSUdfT01BUF9Q
QUNLQUdFX0NCUD15CkNPTkZJR19PTUFQX1BBQ0tBR0VfQ0JMPXkKQ09ORklHX09NQVBfUEFD
S0FHRV9DQlM9eQoKIwojIE9NQVAgQm9hcmQgVHlwZQojCkNPTkZJR19NQUNIX09NQVAzX0JF
QUdMRT15CkNPTkZJR19NQUNIX0RFVktJVDgwMDA9eQpDT05GSUdfTUFDSF9PTUFQX0xEUD15
CkNPTkZJR19NQUNIX09NQVAzNTMwX0xWX1NPTT15CkNPTkZJR19NQUNIX09NQVAzX1RPUlBF
RE89eQpDT05GSUdfTUFDSF9PVkVSTz15CkNPTkZJR19NQUNIX09NQVAzRVZNPXkKQ09ORklH
X01BQ0hfT01BUDM1MTdFVk09eQpDT05GSUdfTUFDSF9DUkFORUJPQVJEPXkKQ09ORklHX01B
Q0hfT01BUDNfUEFORE9SQT15CkNPTkZJR19NQUNIX09NQVAzX1RPVUNIQk9PSz15CkNPTkZJ
R19NQUNIX09NQVBfMzQzMFNEUD15CkNPTkZJR19NQUNIX05PS0lBX1JNNjgwPXkKQ09ORklH
X01BQ0hfTk9LSUFfUlg1MT15CkNPTkZJR19NQUNIX09NQVBfWk9PTTI9eQpDT05GSUdfTUFD
SF9PTUFQX1pPT00zPXkKQ09ORklHX01BQ0hfQ01fVDM1PXkKQ09ORklHX01BQ0hfQ01fVDM1
MTc9eQpDT05GSUdfTUFDSF9DTV9UMzczMD15CkNPTkZJR19NQUNIX0lHRVAwMDIwPXkKQ09O
RklHX01BQ0hfSUdFUDAwMzA9eQpDT05GSUdfTUFDSF9TQkMzNTMwPXkKQ09ORklHX01BQ0hf
T01BUF8zNjMwU0RQPXkKQ09ORklHX01BQ0hfVEk4MTY4RVZNPXkKQ09ORklHX01BQ0hfT01B
UF80NDMwU0RQPXkKQ09ORklHX01BQ0hfT01BUDRfUEFOREE9eQpDT05GSUdfT01BUDNfRU1V
PXkKIyBDT05GSUdfT01BUDNfU0RSQ19BQ19USU1JTkcgaXMgbm90IHNldAoKIwojIFN5c3Rl
bSBNTVUKIwoKIwojIFByb2Nlc3NvciBUeXBlCiMKQ09ORklHX0NQVV9WNz15CkNPTkZJR19D
UFVfMzJ2Nks9eQpDT05GSUdfQ1BVXzMydjc9eQpDT05GSUdfQ1BVX0FCUlRfRVY3PXkKQ09O
RklHX0NQVV9QQUJSVF9WNz15CkNPTkZJR19DUFVfQ0FDSEVfVjc9eQpDT05GSUdfQ1BVX0NB
Q0hFX1ZJUFQ9eQpDT05GSUdfQ1BVX0NPUFlfVjY9eQpDT05GSUdfQ1BVX1RMQl9WNz15CkNP
TkZJR19DUFVfSEFTX0FTSUQ9eQpDT05GSUdfQ1BVX0NQMTU9eQpDT05GSUdfQ1BVX0NQMTVf
TU1VPXkKCiMKIyBQcm9jZXNzb3IgRmVhdHVyZXMKIwpDT05GSUdfQVJNX1RIVU1CPXkKQ09O
RklHX0FSTV9USFVNQkVFPXkKQ09ORklHX1NXUF9FTVVMQVRFPXkKIyBDT05GSUdfQ1BVX0lD
QUNIRV9ESVNBQkxFIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1BVX0RDQUNIRV9ESVNBQkxFIGlz
IG5vdCBzZXQKIyBDT05GSUdfQ1BVX0JQUkVESUNUX0RJU0FCTEUgaXMgbm90IHNldApDT05G
SUdfT1VURVJfQ0FDSEU9eQpDT05GSUdfT1VURVJfQ0FDSEVfU1lOQz15CkNPTkZJR19DQUNI
RV9MMlgwPXkKQ09ORklHX0NBQ0hFX1BMMzEwPXkKQ09ORklHX0FSTV9MMV9DQUNIRV9TSElG
VD01CkNPTkZJR19BUk1fRE1BX01FTV9CVUZGRVJBQkxFPXkKQ09ORklHX0NQVV9IQVNfUE1V
PXkKQ09ORklHX0FSTV9FUlJBVEFfNDMwOTczPXkKIyBDT05GSUdfQVJNX0VSUkFUQV80NTg2
OTMgaXMgbm90IHNldAojIENPTkZJR19BUk1fRVJSQVRBXzQ2MDA3NSBpcyBub3Qgc2V0CiMg
Q09ORklHX0FSTV9FUlJBVEFfNzQyMjMwIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJNX0VSUkFU
QV83NDIyMzEgaXMgbm90IHNldApDT05GSUdfUEwzMTBfRVJSQVRBXzU4ODM2OT15CkNPTkZJ
R19BUk1fRVJSQVRBXzcyMDc4OT15CkNPTkZJR19QTDMxMF9FUlJBVEFfNzI3OTE1PXkKIyBD
T05GSUdfQVJNX0VSUkFUQV83NDM2MjIgaXMgbm90IHNldAojIENPTkZJR19BUk1fRVJSQVRB
Xzc1MTQ3MiBpcyBub3Qgc2V0CiMgQ09ORklHX0FSTV9FUlJBVEFfNzUzOTcwIGlzIG5vdCBz
ZXQKIyBDT05GSUdfQVJNX0VSUkFUQV83NTQzMjIgaXMgbm90IHNldAojIENPTkZJR19BUk1f
RVJSQVRBXzc1NDMyNyBpcyBub3Qgc2V0CiMgQ09ORklHX0FSTV9FUlJBVEFfNzY0MzY5IGlz
IG5vdCBzZXQKIyBDT05GSUdfUEwzMTBfRVJSQVRBXzc2OTQxOSBpcyBub3Qgc2V0CkNPTkZJ
R19BUk1fR0lDPXkKCiMKIyBCdXMgc3VwcG9ydAojCkNPTkZJR19BUk1fQU1CQT15CiMgQ09O
RklHX1BDSV9TWVNDQUxMIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJDSF9TVVBQT1JUU19NU0kg
aXMgbm90IHNldAojIENPTkZJR19QQ0NBUkQgaXMgbm90IHNldAoKIwojIEtlcm5lbCBGZWF0
dXJlcwojCkNPTkZJR19USUNLX09ORVNIT1Q9eQpDT05GSUdfTk9fSFo9eQpDT05GSUdfSElH
SF9SRVNfVElNRVJTPXkKQ09ORklHX0dFTkVSSUNfQ0xPQ0tFVkVOVFNfQlVJTEQ9eQpDT05G
SUdfU01QPXkKQ09ORklHX1NNUF9PTl9VUD15CkNPTkZJR19IQVZFX0FSTV9TQ1U9eQpDT05G
SUdfSEFWRV9BUk1fVFdEPXkKQ09ORklHX1ZNU1BMSVRfM0c9eQojIENPTkZJR19WTVNQTElU
XzJHIGlzIG5vdCBzZXQKIyBDT05GSUdfVk1TUExJVF8xRyBpcyBub3Qgc2V0CkNPTkZJR19Q
QUdFX09GRlNFVD0weEMwMDAwMDAwCkNPTkZJR19OUl9DUFVTPTIKQ09ORklHX0hPVFBMVUdf
Q1BVPXkKQ09ORklHX0xPQ0FMX1RJTUVSUz15CiMgQ09ORklHX1BSRUVNUFRfTk9ORSBpcyBu
b3Qgc2V0CiMgQ09ORklHX1BSRUVNUFRfVk9MVU5UQVJZIGlzIG5vdCBzZXQKQ09ORklHX1BS
RUVNUFQ9eQpDT05GSUdfUFJFRU1QVF9DT1VOVD15CkNPTkZJR19IWj0xMjgKIyBDT05GSUdf
VEhVTUIyX0tFUk5FTCBpcyBub3Qgc2V0CkNPTkZJR19BRUFCST15CiMgQ09ORklHX09BQklf
Q09NUEFUIGlzIG5vdCBzZXQKQ09ORklHX0FSQ0hfSEFTX0hPTEVTX01FTU9SWU1PREVMPXkK
IyBDT05GSUdfQVJDSF9TUEFSU0VNRU1fREVGQVVMVCBpcyBub3Qgc2V0CiMgQ09ORklHX0FS
Q0hfU0VMRUNUX01FTU9SWV9NT0RFTCBpcyBub3Qgc2V0CkNPTkZJR19IQVZFX0FSQ0hfUEZO
X1ZBTElEPXkKQ09ORklHX0hJR0hNRU09eQpDT05GSUdfSElHSFBURT15CkNPTkZJR19IV19Q
RVJGX0VWRU5UUz15CkNPTkZJR19TRUxFQ1RfTUVNT1JZX01PREVMPXkKQ09ORklHX0ZMQVRN
RU1fTUFOVUFMPXkKQ09ORklHX0ZMQVRNRU09eQpDT05GSUdfRkxBVF9OT0RFX01FTV9NQVA9
eQpDT05GSUdfSEFWRV9NRU1CTE9DSz15CkNPTkZJR19QQUdFRkxBR1NfRVhURU5ERUQ9eQpD
T05GSUdfU1BMSVRfUFRMT0NLX0NQVVM9NApDT05GSUdfQ09NUEFDVElPTj15CkNPTkZJR19N
SUdSQVRJT049eQojIENPTkZJR19QSFlTX0FERFJfVF82NEJJVCBpcyBub3Qgc2V0CkNPTkZJ
R19aT05FX0RNQV9GTEFHPTAKQ09ORklHX0JPVU5DRT15CkNPTkZJR19WSVJUX1RPX0JVUz15
CiMgQ09ORklHX0tTTSBpcyBub3Qgc2V0CkNPTkZJR19ERUZBVUxUX01NQVBfTUlOX0FERFI9
MzI3NjgKQ09ORklHX0NMRUFOQ0FDSEU9eQpDT05GSUdfRk9SQ0VfTUFYX1pPTkVPUkRFUj0x
MQpDT05GSUdfTEVEUz15CkNPTkZJR19BTElHTk1FTlRfVFJBUD15CiMgQ09ORklHX1VBQ0NF
U1NfV0lUSF9NRU1DUFkgaXMgbm90IHNldAojIENPTkZJR19TRUNDT01QIGlzIG5vdCBzZXQK
IyBDT05GSUdfQ0NfU1RBQ0tQUk9URUNUT1IgaXMgbm90IHNldAojIENPTkZJR19ERVBSRUNB
VEVEX1BBUkFNX1NUUlVDVCBpcyBub3Qgc2V0CgojCiMgQm9vdCBvcHRpb25zCiMKQ09ORklH
X1VTRV9PRj15CkNPTkZJR19aQk9PVF9ST01fVEVYVD0weDAKQ09ORklHX1pCT09UX1JPTV9C
U1M9MHgwCkNPTkZJR19DTURMSU5FPSIiCiMgQ09ORklHX1hJUF9LRVJORUwgaXMgbm90IHNl
dApDT05GSUdfS0VYRUM9eQpDT05GSUdfQVRBR1NfUFJPQz15CiMgQ09ORklHX0NSQVNIX0RV
TVAgaXMgbm90IHNldApDT05GSUdfQVVUT19aUkVMQUREUj15CgojCiMgQ1BVIFBvd2VyIE1h
bmFnZW1lbnQKIwoKIwojIENQVSBGcmVxdWVuY3kgc2NhbGluZwojCkNPTkZJR19DUFVfRlJF
UT15CkNPTkZJR19DUFVfRlJFUV9UQUJMRT15CkNPTkZJR19DUFVfRlJFUV9TVEFUPXkKQ09O
RklHX0NQVV9GUkVRX1NUQVRfREVUQUlMUz15CkNPTkZJR19DUFVfRlJFUV9ERUZBVUxUX0dP
Vl9QRVJGT1JNQU5DRT15CiMgQ09ORklHX0NQVV9GUkVRX0RFRkFVTFRfR09WX1BPV0VSU0FW
RSBpcyBub3Qgc2V0CiMgQ09ORklHX0NQVV9GUkVRX0RFRkFVTFRfR09WX1VTRVJTUEFDRSBp
cyBub3Qgc2V0CiMgQ09ORklHX0NQVV9GUkVRX0RFRkFVTFRfR09WX09OREVNQU5EIGlzIG5v
dCBzZXQKIyBDT05GSUdfQ1BVX0ZSRVFfREVGQVVMVF9HT1ZfQ09OU0VSVkFUSVZFIGlzIG5v
dCBzZXQKQ09ORklHX0NQVV9GUkVRX0dPVl9QRVJGT1JNQU5DRT15CkNPTkZJR19DUFVfRlJF
UV9HT1ZfUE9XRVJTQVZFPXkKQ09ORklHX0NQVV9GUkVRX0dPVl9VU0VSU1BBQ0U9eQpDT05G
SUdfQ1BVX0ZSRVFfR09WX09OREVNQU5EPXkKQ09ORklHX0NQVV9GUkVRX0dPVl9DT05TRVJW
QVRJVkU9eQoKIwojIEFSTSBDUFUgZnJlcXVlbmN5IHNjYWxpbmcgZHJpdmVycwojCkNPTkZJ
R19DUFVfSURMRT15CkNPTkZJR19DUFVfSURMRV9HT1ZfTEFEREVSPXkKQ09ORklHX0NQVV9J
RExFX0dPVl9NRU5VPXkKCiMKIyBGbG9hdGluZyBwb2ludCBlbXVsYXRpb24KIwoKIwojIEF0
IGxlYXN0IG9uZSBlbXVsYXRpb24gbXVzdCBiZSBzZWxlY3RlZAojCkNPTkZJR19WRlA9eQpD
T05GSUdfVkZQdjM9eQpDT05GSUdfTkVPTj15CgojCiMgVXNlcnNwYWNlIGJpbmFyeSBmb3Jt
YXRzCiMKQ09ORklHX0JJTkZNVF9FTEY9eQpDT05GSUdfQ09SRV9EVU1QX0RFRkFVTFRfRUxG
X0hFQURFUlM9eQpDT05GSUdfSEFWRV9BT1VUPXkKQ09ORklHX0JJTkZNVF9BT1VUPW0KQ09O
RklHX0JJTkZNVF9NSVNDPW0KCiMKIyBQb3dlciBtYW5hZ2VtZW50IG9wdGlvbnMKIwpDT05G
SUdfU1VTUEVORD15CkNPTkZJR19TVVNQRU5EX0ZSRUVaRVI9eQpDT05GSUdfUE1fU0xFRVA9
eQpDT05GSUdfUE1fU0xFRVBfU01QPXkKQ09ORklHX1BNX1JVTlRJTUU9eQpDT05GSUdfUE09
eQpDT05GSUdfUE1fREVCVUc9eQojIENPTkZJR19QTV9BRFZBTkNFRF9ERUJVRyBpcyBub3Qg
c2V0CiMgQ09ORklHX1BNX1RFU1RfU1VTUEVORCBpcyBub3Qgc2V0CkNPTkZJR19DQU5fUE1f
VFJBQ0U9eQojIENPTkZJR19BUE1fRU1VTEFUSU9OIGlzIG5vdCBzZXQKQ09ORklHX0FSQ0hf
SEFTX09QUD15CkNPTkZJR19QTV9PUFA9eQpDT05GSUdfUE1fQ0xLPXkKQ09ORklHX0FSQ0hf
U1VTUEVORF9QT1NTSUJMRT15CkNPTkZJR19ORVQ9eQoKIwojIE5ldHdvcmtpbmcgb3B0aW9u
cwojCkNPTkZJR19QQUNLRVQ9eQpDT05GSUdfVU5JWD15CkNPTkZJR19YRlJNPXkKQ09ORklH
X1hGUk1fVVNFUj1tCiMgQ09ORklHX1hGUk1fU1VCX1BPTElDWSBpcyBub3Qgc2V0CiMgQ09O
RklHX1hGUk1fTUlHUkFURSBpcyBub3Qgc2V0CiMgQ09ORklHX1hGUk1fU1RBVElTVElDUyBp
cyBub3Qgc2V0CkNPTkZJR19YRlJNX0lQQ09NUD1tCkNPTkZJR19ORVRfS0VZPW0KIyBDT05G
SUdfTkVUX0tFWV9NSUdSQVRFIGlzIG5vdCBzZXQKQ09ORklHX0lORVQ9eQpDT05GSUdfSVBf
TVVMVElDQVNUPXkKQ09ORklHX0lQX0FEVkFOQ0VEX1JPVVRFUj15CiMgQ09ORklHX0lQX0ZJ
Ql9UUklFX1NUQVRTIGlzIG5vdCBzZXQKQ09ORklHX0lQX01VTFRJUExFX1RBQkxFUz15CkNP
TkZJR19JUF9ST1VURV9NVUxUSVBBVEg9eQpDT05GSUdfSVBfUk9VVEVfVkVSQk9TRT15CkNP
TkZJR19JUF9ST1VURV9DTEFTU0lEPXkKQ09ORklHX0lQX1BOUD15CkNPTkZJR19JUF9QTlBf
REhDUD15CkNPTkZJR19JUF9QTlBfQk9PVFA9eQojIENPTkZJR19JUF9QTlBfUkFSUCBpcyBu
b3Qgc2V0CkNPTkZJR19ORVRfSVBJUD1tCiMgQ09ORklHX05FVF9JUEdSRV9ERU1VWCBpcyBu
b3Qgc2V0CkNPTkZJR19JUF9NUk9VVEU9eQojIENPTkZJR19JUF9NUk9VVEVfTVVMVElQTEVf
VEFCTEVTIGlzIG5vdCBzZXQKQ09ORklHX0lQX1BJTVNNX1YxPXkKQ09ORklHX0lQX1BJTVNN
X1YyPXkKIyBDT05GSUdfQVJQRCBpcyBub3Qgc2V0CkNPTkZJR19TWU5fQ09PS0lFUz15CkNP
TkZJR19JTkVUX0FIPW0KQ09ORklHX0lORVRfRVNQPW0KQ09ORklHX0lORVRfSVBDT01QPW0K
Q09ORklHX0lORVRfWEZSTV9UVU5ORUw9bQpDT05GSUdfSU5FVF9UVU5ORUw9bQpDT05GSUdf
SU5FVF9YRlJNX01PREVfVFJBTlNQT1JUPW0KQ09ORklHX0lORVRfWEZSTV9NT0RFX1RVTk5F
TD1tCkNPTkZJR19JTkVUX1hGUk1fTU9ERV9CRUVUPW0KQ09ORklHX0lORVRfTFJPPXkKQ09O
RklHX0lORVRfRElBRz15CkNPTkZJR19JTkVUX1RDUF9ESUFHPXkKQ09ORklHX1RDUF9DT05H
X0FEVkFOQ0VEPXkKQ09ORklHX1RDUF9DT05HX0JJQz1tCkNPTkZJR19UQ1BfQ09OR19DVUJJ
Qz15CkNPTkZJR19UQ1BfQ09OR19XRVNUV09PRD1tCkNPTkZJR19UQ1BfQ09OR19IVENQPW0K
Q09ORklHX1RDUF9DT05HX0hTVENQPW0KQ09ORklHX1RDUF9DT05HX0hZQkxBPW0KQ09ORklH
X1RDUF9DT05HX1ZFR0FTPW0KQ09ORklHX1RDUF9DT05HX1NDQUxBQkxFPW0KQ09ORklHX1RD
UF9DT05HX0xQPW0KQ09ORklHX1RDUF9DT05HX1ZFTk89bQpDT05GSUdfVENQX0NPTkdfWUVB
SD1tCkNPTkZJR19UQ1BfQ09OR19JTExJTk9JUz1tCkNPTkZJR19ERUZBVUxUX0NVQklDPXkK
IyBDT05GSUdfREVGQVVMVF9SRU5PIGlzIG5vdCBzZXQKQ09ORklHX0RFRkFVTFRfVENQX0NP
Tkc9ImN1YmljIgpDT05GSUdfVENQX01ENVNJRz15CkNPTkZJR19JUFY2PXkKQ09ORklHX0lQ
VjZfUFJJVkFDWT15CiMgQ09ORklHX0lQVjZfUk9VVEVSX1BSRUYgaXMgbm90IHNldAojIENP
TkZJR19JUFY2X09QVElNSVNUSUNfREFEIGlzIG5vdCBzZXQKQ09ORklHX0lORVQ2X0FIPW0K
Q09ORklHX0lORVQ2X0VTUD1tCkNPTkZJR19JTkVUNl9JUENPTVA9bQojIENPTkZJR19JUFY2
X01JUDYgaXMgbm90IHNldApDT05GSUdfSU5FVDZfWEZSTV9UVU5ORUw9bQpDT05GSUdfSU5F
VDZfVFVOTkVMPW0KQ09ORklHX0lORVQ2X1hGUk1fTU9ERV9UUkFOU1BPUlQ9bQpDT05GSUdf
SU5FVDZfWEZSTV9NT0RFX1RVTk5FTD1tCkNPTkZJR19JTkVUNl9YRlJNX01PREVfQkVFVD1t
CkNPTkZJR19JTkVUNl9YRlJNX01PREVfUk9VVEVPUFRJTUlaQVRJT049bQpDT05GSUdfSVBW
Nl9TSVQ9bQpDT05GSUdfSVBWNl9TSVRfNlJEPXkKQ09ORklHX0lQVjZfTkRJU0NfTk9ERVRZ
UEU9eQpDT05GSUdfSVBWNl9UVU5ORUw9bQpDT05GSUdfSVBWNl9NVUxUSVBMRV9UQUJMRVM9
eQojIENPTkZJR19JUFY2X1NVQlRSRUVTIGlzIG5vdCBzZXQKIyBDT05GSUdfSVBWNl9NUk9V
VEUgaXMgbm90IHNldApDT05GSUdfTkVUTEFCRUw9eQpDT05GSUdfTkVUV09SS19TRUNNQVJL
PXkKIyBDT05GSUdfTkVUV09SS19QSFlfVElNRVNUQU1QSU5HIGlzIG5vdCBzZXQKQ09ORklH
X05FVEZJTFRFUj15CiMgQ09ORklHX05FVEZJTFRFUl9ERUJVRyBpcyBub3Qgc2V0CkNPTkZJ
R19ORVRGSUxURVJfQURWQU5DRUQ9eQpDT05GSUdfQlJJREdFX05FVEZJTFRFUj15CgojCiMg
Q29yZSBOZXRmaWx0ZXIgQ29uZmlndXJhdGlvbgojCkNPTkZJR19ORVRGSUxURVJfTkVUTElO
Sz1tCkNPTkZJR19ORVRGSUxURVJfTkVUTElOS19RVUVVRT1tCkNPTkZJR19ORVRGSUxURVJf
TkVUTElOS19MT0c9bQpDT05GSUdfTkZfQ09OTlRSQUNLPW0KQ09ORklHX05GX0NPTk5UUkFD
S19NQVJLPXkKQ09ORklHX05GX0NPTk5UUkFDS19TRUNNQVJLPXkKQ09ORklHX05GX0NPTk5U
UkFDS19aT05FUz15CkNPTkZJR19ORl9DT05OVFJBQ0tfRVZFTlRTPXkKIyBDT05GSUdfTkZf
Q09OTlRSQUNLX1RJTUVTVEFNUCBpcyBub3Qgc2V0CkNPTkZJR19ORl9DVF9QUk9UT19EQ0NQ
PW0KQ09ORklHX05GX0NUX1BST1RPX0dSRT1tCkNPTkZJR19ORl9DVF9QUk9UT19TQ1RQPW0K
Q09ORklHX05GX0NUX1BST1RPX1VEUExJVEU9bQpDT05GSUdfTkZfQ09OTlRSQUNLX0FNQU5E
QT1tCkNPTkZJR19ORl9DT05OVFJBQ0tfRlRQPW0KQ09ORklHX05GX0NPTk5UUkFDS19IMzIz
PW0KQ09ORklHX05GX0NPTk5UUkFDS19JUkM9bQpDT05GSUdfTkZfQ09OTlRSQUNLX0JST0FE
Q0FTVD1tCkNPTkZJR19ORl9DT05OVFJBQ0tfTkVUQklPU19OUz1tCiMgQ09ORklHX05GX0NP
Tk5UUkFDS19TTk1QIGlzIG5vdCBzZXQKQ09ORklHX05GX0NPTk5UUkFDS19QUFRQPW0KQ09O
RklHX05GX0NPTk5UUkFDS19TQU5FPW0KQ09ORklHX05GX0NPTk5UUkFDS19TSVA9bQpDT05G
SUdfTkZfQ09OTlRSQUNLX1RGVFA9bQpDT05GSUdfTkZfQ1RfTkVUTElOSz1tCkNPTkZJR19O
RVRGSUxURVJfVFBST1hZPW0KQ09ORklHX05FVEZJTFRFUl9YVEFCTEVTPW0KCiMKIyBYdGFi
bGVzIGNvbWJpbmVkIG1vZHVsZXMKIwpDT05GSUdfTkVURklMVEVSX1hUX01BUks9bQpDT05G
SUdfTkVURklMVEVSX1hUX0NPTk5NQVJLPW0KCiMKIyBYdGFibGVzIHRhcmdldHMKIwojIENP
TkZJR19ORVRGSUxURVJfWFRfVEFSR0VUX0FVRElUIGlzIG5vdCBzZXQKQ09ORklHX05FVEZJ
TFRFUl9YVF9UQVJHRVRfQ0hFQ0tTVU09bQpDT05GSUdfTkVURklMVEVSX1hUX1RBUkdFVF9D
TEFTU0lGWT1tCkNPTkZJR19ORVRGSUxURVJfWFRfVEFSR0VUX0NPTk5NQVJLPW0KQ09ORklH
X05FVEZJTFRFUl9YVF9UQVJHRVRfQ09OTlNFQ01BUks9bQpDT05GSUdfTkVURklMVEVSX1hU
X1RBUkdFVF9DVD1tCkNPTkZJR19ORVRGSUxURVJfWFRfVEFSR0VUX0RTQ1A9bQpDT05GSUdf
TkVURklMVEVSX1hUX1RBUkdFVF9ITD1tCkNPTkZJR19ORVRGSUxURVJfWFRfVEFSR0VUX0lE
TEVUSU1FUj1tCkNPTkZJR19ORVRGSUxURVJfWFRfVEFSR0VUX0xFRD1tCkNPTkZJR19ORVRG
SUxURVJfWFRfVEFSR0VUX01BUks9bQpDT05GSUdfTkVURklMVEVSX1hUX1RBUkdFVF9ORkxP
Rz1tCkNPTkZJR19ORVRGSUxURVJfWFRfVEFSR0VUX05GUVVFVUU9bQpDT05GSUdfTkVURklM
VEVSX1hUX1RBUkdFVF9OT1RSQUNLPW0KQ09ORklHX05FVEZJTFRFUl9YVF9UQVJHRVRfUkFU
RUVTVD1tCkNPTkZJR19ORVRGSUxURVJfWFRfVEFSR0VUX1RFRT1tCkNPTkZJR19ORVRGSUxU
RVJfWFRfVEFSR0VUX1RQUk9YWT1tCkNPTkZJR19ORVRGSUxURVJfWFRfVEFSR0VUX1RSQUNF
PW0KQ09ORklHX05FVEZJTFRFUl9YVF9UQVJHRVRfU0VDTUFSSz1tCkNPTkZJR19ORVRGSUxU
RVJfWFRfVEFSR0VUX1RDUE1TUz1tCkNPTkZJR19ORVRGSUxURVJfWFRfVEFSR0VUX1RDUE9Q
VFNUUklQPW0KCiMKIyBYdGFibGVzIG1hdGNoZXMKIwojIENPTkZJR19ORVRGSUxURVJfWFRf
TUFUQ0hfQUREUlRZUEUgaXMgbm90IHNldApDT05GSUdfTkVURklMVEVSX1hUX01BVENIX0NM
VVNURVI9bQpDT05GSUdfTkVURklMVEVSX1hUX01BVENIX0NPTU1FTlQ9bQpDT05GSUdfTkVU
RklMVEVSX1hUX01BVENIX0NPTk5CWVRFUz1tCkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hf
Q09OTkxJTUlUPW0KQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9DT05OTUFSSz1tCkNPTkZJ
R19ORVRGSUxURVJfWFRfTUFUQ0hfQ09OTlRSQUNLPW0KQ09ORklHX05FVEZJTFRFUl9YVF9N
QVRDSF9DUFU9bQpDT05GSUdfTkVURklMVEVSX1hUX01BVENIX0RDQ1A9bQojIENPTkZJR19O
RVRGSUxURVJfWFRfTUFUQ0hfREVWR1JPVVAgaXMgbm90IHNldApDT05GSUdfTkVURklMVEVS
X1hUX01BVENIX0RTQ1A9bQpDT05GSUdfTkVURklMVEVSX1hUX01BVENIX0VTUD1tCkNPTkZJ
R19ORVRGSUxURVJfWFRfTUFUQ0hfSEFTSExJTUlUPW0KQ09ORklHX05FVEZJTFRFUl9YVF9N
QVRDSF9IRUxQRVI9bQpDT05GSUdfTkVURklMVEVSX1hUX01BVENIX0hMPW0KQ09ORklHX05F
VEZJTFRFUl9YVF9NQVRDSF9JUFJBTkdFPW0KQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9J
UFZTPW0KQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9MRU5HVEg9bQpDT05GSUdfTkVURklM
VEVSX1hUX01BVENIX0xJTUlUPW0KQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9NQUM9bQpD
T05GSUdfTkVURklMVEVSX1hUX01BVENIX01BUks9bQpDT05GSUdfTkVURklMVEVSX1hUX01B
VENIX01VTFRJUE9SVD1tCkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfT1NGPW0KQ09ORklH
X05FVEZJTFRFUl9YVF9NQVRDSF9PV05FUj1tCkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hf
UE9MSUNZPW0KQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9QSFlTREVWPW0KQ09ORklHX05F
VEZJTFRFUl9YVF9NQVRDSF9QS1RUWVBFPW0KQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9R
VU9UQT1tCkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfUkFURUVTVD1tCkNPTkZJR19ORVRG
SUxURVJfWFRfTUFUQ0hfUkVBTE09bQpDT05GSUdfTkVURklMVEVSX1hUX01BVENIX1JFQ0VO
VD1tCkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfU0NUUD1tCkNPTkZJR19ORVRGSUxURVJf
WFRfTUFUQ0hfU09DS0VUPW0KQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9TVEFURT1tCkNP
TkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfU1RBVElTVElDPW0KQ09ORklHX05FVEZJTFRFUl9Y
VF9NQVRDSF9TVFJJTkc9bQpDT05GSUdfTkVURklMVEVSX1hUX01BVENIX1RDUE1TUz1tCkNP
TkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfVElNRT1tCkNPTkZJR19ORVRGSUxURVJfWFRfTUFU
Q0hfVTMyPW0KIyBDT05GSUdfSVBfU0VUIGlzIG5vdCBzZXQKQ09ORklHX0lQX1ZTPW0KQ09O
RklHX0lQX1ZTX0lQVjY9eQojIENPTkZJR19JUF9WU19ERUJVRyBpcyBub3Qgc2V0CkNPTkZJ
R19JUF9WU19UQUJfQklUUz0xMgoKIwojIElQVlMgdHJhbnNwb3J0IHByb3RvY29sIGxvYWQg
YmFsYW5jaW5nIHN1cHBvcnQKIwpDT05GSUdfSVBfVlNfUFJPVE9fVENQPXkKQ09ORklHX0lQ
X1ZTX1BST1RPX1VEUD15CkNPTkZJR19JUF9WU19QUk9UT19BSF9FU1A9eQpDT05GSUdfSVBf
VlNfUFJPVE9fRVNQPXkKQ09ORklHX0lQX1ZTX1BST1RPX0FIPXkKQ09ORklHX0lQX1ZTX1BS
T1RPX1NDVFA9eQoKIwojIElQVlMgc2NoZWR1bGVyCiMKQ09ORklHX0lQX1ZTX1JSPW0KQ09O
RklHX0lQX1ZTX1dSUj1tCkNPTkZJR19JUF9WU19MQz1tCkNPTkZJR19JUF9WU19XTEM9bQpD
T05GSUdfSVBfVlNfTEJMQz1tCkNPTkZJR19JUF9WU19MQkxDUj1tCkNPTkZJR19JUF9WU19E
SD1tCkNPTkZJR19JUF9WU19TSD1tCkNPTkZJR19JUF9WU19TRUQ9bQpDT05GSUdfSVBfVlNf
TlE9bQoKIwojIElQVlMgYXBwbGljYXRpb24gaGVscGVyCiMKQ09ORklHX0lQX1ZTX0ZUUD1t
CkNPTkZJR19JUF9WU19ORkNUPXkKQ09ORklHX0lQX1ZTX1BFX1NJUD1tCgojCiMgSVA6IE5l
dGZpbHRlciBDb25maWd1cmF0aW9uCiMKQ09ORklHX05GX0RFRlJBR19JUFY0PW0KQ09ORklH
X05GX0NPTk5UUkFDS19JUFY0PW0KQ09ORklHX05GX0NPTk5UUkFDS19QUk9DX0NPTVBBVD15
CkNPTkZJR19JUF9ORl9RVUVVRT1tCkNPTkZJR19JUF9ORl9JUFRBQkxFUz1tCkNPTkZJR19J
UF9ORl9NQVRDSF9BSD1tCkNPTkZJR19JUF9ORl9NQVRDSF9FQ049bQpDT05GSUdfSVBfTkZf
TUFUQ0hfVFRMPW0KQ09ORklHX0lQX05GX0ZJTFRFUj1tCkNPTkZJR19JUF9ORl9UQVJHRVRf
UkVKRUNUPW0KQ09ORklHX0lQX05GX1RBUkdFVF9MT0c9bQpDT05GSUdfSVBfTkZfVEFSR0VU
X1VMT0c9bQpDT05GSUdfTkZfTkFUPW0KQ09ORklHX05GX05BVF9ORUVERUQ9eQpDT05GSUdf
SVBfTkZfVEFSR0VUX01BU1FVRVJBREU9bQpDT05GSUdfSVBfTkZfVEFSR0VUX05FVE1BUD1t
CkNPTkZJR19JUF9ORl9UQVJHRVRfUkVESVJFQ1Q9bQpDT05GSUdfTkZfTkFUX1BST1RPX0RD
Q1A9bQpDT05GSUdfTkZfTkFUX1BST1RPX0dSRT1tCkNPTkZJR19ORl9OQVRfUFJPVE9fVURQ
TElURT1tCkNPTkZJR19ORl9OQVRfUFJPVE9fU0NUUD1tCkNPTkZJR19ORl9OQVRfRlRQPW0K
Q09ORklHX05GX05BVF9JUkM9bQpDT05GSUdfTkZfTkFUX1RGVFA9bQpDT05GSUdfTkZfTkFU
X0FNQU5EQT1tCkNPTkZJR19ORl9OQVRfUFBUUD1tCkNPTkZJR19ORl9OQVRfSDMyMz1tCkNP
TkZJR19ORl9OQVRfU0lQPW0KQ09ORklHX0lQX05GX01BTkdMRT1tCkNPTkZJR19JUF9ORl9U
QVJHRVRfQ0xVU1RFUklQPW0KQ09ORklHX0lQX05GX1RBUkdFVF9FQ049bQpDT05GSUdfSVBf
TkZfVEFSR0VUX1RUTD1tCkNPTkZJR19JUF9ORl9SQVc9bQpDT05GSUdfSVBfTkZfU0VDVVJJ
VFk9bQpDT05GSUdfSVBfTkZfQVJQVEFCTEVTPW0KQ09ORklHX0lQX05GX0FSUEZJTFRFUj1t
CkNPTkZJR19JUF9ORl9BUlBfTUFOR0xFPW0KCiMKIyBJUHY2OiBOZXRmaWx0ZXIgQ29uZmln
dXJhdGlvbgojCkNPTkZJR19ORl9ERUZSQUdfSVBWNj1tCkNPTkZJR19ORl9DT05OVFJBQ0tf
SVBWNj1tCkNPTkZJR19JUDZfTkZfUVVFVUU9bQpDT05GSUdfSVA2X05GX0lQVEFCTEVTPW0K
Q09ORklHX0lQNl9ORl9NQVRDSF9BSD1tCkNPTkZJR19JUDZfTkZfTUFUQ0hfRVVJNjQ9bQpD
T05GSUdfSVA2X05GX01BVENIX0ZSQUc9bQpDT05GSUdfSVA2X05GX01BVENIX09QVFM9bQpD
T05GSUdfSVA2X05GX01BVENIX0hMPW0KQ09ORklHX0lQNl9ORl9NQVRDSF9JUFY2SEVBREVS
PW0KQ09ORklHX0lQNl9ORl9NQVRDSF9NSD1tCkNPTkZJR19JUDZfTkZfTUFUQ0hfUlQ9bQpD
T05GSUdfSVA2X05GX1RBUkdFVF9ITD1tCkNPTkZJR19JUDZfTkZfVEFSR0VUX0xPRz1tCkNP
TkZJR19JUDZfTkZfRklMVEVSPW0KQ09ORklHX0lQNl9ORl9UQVJHRVRfUkVKRUNUPW0KQ09O
RklHX0lQNl9ORl9NQU5HTEU9bQpDT05GSUdfSVA2X05GX1JBVz1tCkNPTkZJR19JUDZfTkZf
U0VDVVJJVFk9bQoKIwojIERFQ25ldDogTmV0ZmlsdGVyIENvbmZpZ3VyYXRpb24KIwpDT05G
SUdfREVDTkVUX05GX0dSQUJVTEFUT1I9bQpDT05GSUdfQlJJREdFX05GX0VCVEFCTEVTPW0K
Q09ORklHX0JSSURHRV9FQlRfQlJPVVRFPW0KQ09ORklHX0JSSURHRV9FQlRfVF9GSUxURVI9
bQpDT05GSUdfQlJJREdFX0VCVF9UX05BVD1tCkNPTkZJR19CUklER0VfRUJUXzgwMl8zPW0K
Q09ORklHX0JSSURHRV9FQlRfQU1PTkc9bQpDT05GSUdfQlJJREdFX0VCVF9BUlA9bQpDT05G
SUdfQlJJREdFX0VCVF9JUD1tCkNPTkZJR19CUklER0VfRUJUX0lQNj1tCkNPTkZJR19CUklE
R0VfRUJUX0xJTUlUPW0KQ09ORklHX0JSSURHRV9FQlRfTUFSSz1tCkNPTkZJR19CUklER0Vf
RUJUX1BLVFRZUEU9bQpDT05GSUdfQlJJREdFX0VCVF9TVFA9bQpDT05GSUdfQlJJREdFX0VC
VF9WTEFOPW0KQ09ORklHX0JSSURHRV9FQlRfQVJQUkVQTFk9bQpDT05GSUdfQlJJREdFX0VC
VF9ETkFUPW0KQ09ORklHX0JSSURHRV9FQlRfTUFSS19UPW0KQ09ORklHX0JSSURHRV9FQlRf
UkVESVJFQ1Q9bQpDT05GSUdfQlJJREdFX0VCVF9TTkFUPW0KQ09ORklHX0JSSURHRV9FQlRf
TE9HPW0KQ09ORklHX0JSSURHRV9FQlRfVUxPRz1tCkNPTkZJR19CUklER0VfRUJUX05GTE9H
PW0KQ09ORklHX0lQX0RDQ1A9bQpDT05GSUdfSU5FVF9EQ0NQX0RJQUc9bQoKIwojIERDQ1Ag
Q0NJRHMgQ29uZmlndXJhdGlvbiAoRVhQRVJJTUVOVEFMKQojCiMgQ09ORklHX0lQX0RDQ1Bf
Q0NJRDJfREVCVUcgaXMgbm90IHNldApDT05GSUdfSVBfRENDUF9DQ0lEMz15CiMgQ09ORklH
X0lQX0RDQ1BfQ0NJRDNfREVCVUcgaXMgbm90IHNldApDT05GSUdfSVBfRENDUF9URlJDX0xJ
Qj15CgojCiMgRENDUCBLZXJuZWwgSGFja2luZwojCiMgQ09ORklHX0lQX0RDQ1BfREVCVUcg
aXMgbm90IHNldAojIENPTkZJR19ORVRfRENDUFBST0JFIGlzIG5vdCBzZXQKQ09ORklHX0lQ
X1NDVFA9bQpDT05GSUdfTkVUX1NDVFBQUk9CRT1tCiMgQ09ORklHX1NDVFBfREJHX01TRyBp
cyBub3Qgc2V0CiMgQ09ORklHX1NDVFBfREJHX09CSkNOVCBpcyBub3Qgc2V0CiMgQ09ORklH
X1NDVFBfSE1BQ19OT05FIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NUUF9ITUFDX1NIQTEgaXMg
bm90IHNldApDT05GSUdfU0NUUF9ITUFDX01ENT15CkNPTkZJR19SRFM9bQpDT05GSUdfUkRT
X1RDUD1tCiMgQ09ORklHX1JEU19ERUJVRyBpcyBub3Qgc2V0CkNPTkZJR19USVBDPW0KIyBD
T05GSUdfVElQQ19BRFZBTkNFRCBpcyBub3Qgc2V0CiMgQ09ORklHX1RJUENfREVCVUcgaXMg
bm90IHNldApDT05GSUdfQVRNPW0KQ09ORklHX0FUTV9DTElQPW0KIyBDT05GSUdfQVRNX0NM
SVBfTk9fSUNNUCBpcyBub3Qgc2V0CkNPTkZJR19BVE1fTEFORT1tCkNPTkZJR19BVE1fTVBP
QT1tCkNPTkZJR19BVE1fQlIyNjg0PW0KQ09ORklHX0FUTV9CUjI2ODRfSVBGSUxURVI9eQpD
T05GSUdfTDJUUD1tCkNPTkZJR19MMlRQX0RFQlVHRlM9bQpDT05GSUdfTDJUUF9WMz15CkNP
TkZJR19MMlRQX0lQPW0KQ09ORklHX0wyVFBfRVRIPW0KQ09ORklHX1NUUD1tCkNPTkZJR19H
QVJQPW0KQ09ORklHX0JSSURHRT1tCkNPTkZJR19CUklER0VfSUdNUF9TTk9PUElORz15CkNP
TkZJR19ORVRfRFNBPXkKQ09ORklHX05FVF9EU0FfVEFHX0RTQT15CkNPTkZJR19ORVRfRFNB
X1RBR19FRFNBPXkKQ09ORklHX05FVF9EU0FfVEFHX1RSQUlMRVI9eQpDT05GSUdfTkVUX0RT
QV9NVjg4RTZYWFg9eQpDT05GSUdfTkVUX0RTQV9NVjg4RTYwNjA9eQpDT05GSUdfTkVUX0RT
QV9NVjg4RTZYWFhfTkVFRF9QUFU9eQpDT05GSUdfTkVUX0RTQV9NVjg4RTYxMzE9eQpDT05G
SUdfTkVUX0RTQV9NVjg4RTYxMjNfNjFfNjU9eQpDT05GSUdfVkxBTl84MDIxUT1tCkNPTkZJ
R19WTEFOXzgwMjFRX0dWUlA9eQpDT05GSUdfREVDTkVUPW0KIyBDT05GSUdfREVDTkVUX1JP
VVRFUiBpcyBub3Qgc2V0CkNPTkZJR19MTEM9bQpDT05GSUdfTExDMj1tCiMgQ09ORklHX0lQ
WCBpcyBub3Qgc2V0CiMgQ09ORklHX0FUQUxLIGlzIG5vdCBzZXQKIyBDT05GSUdfWDI1IGlz
IG5vdCBzZXQKQ09ORklHX0xBUEI9bQpDT05GSUdfRUNPTkVUPW0KQ09ORklHX0VDT05FVF9B
VU5VRFA9eQpDT05GSUdfRUNPTkVUX05BVElWRT15CkNPTkZJR19XQU5fUk9VVEVSPW0KQ09O
RklHX1BIT05FVD1tCkNPTkZJR19JRUVFODAyMTU0PW0KQ09ORklHX05FVF9TQ0hFRD15Cgoj
CiMgUXVldWVpbmcvU2NoZWR1bGluZwojCkNPTkZJR19ORVRfU0NIX0NCUT1tCkNPTkZJR19O
RVRfU0NIX0hUQj1tCkNPTkZJR19ORVRfU0NIX0hGU0M9bQpDT05GSUdfTkVUX1NDSF9BVE09
bQpDT05GSUdfTkVUX1NDSF9QUklPPW0KQ09ORklHX05FVF9TQ0hfTVVMVElRPW0KQ09ORklH
X05FVF9TQ0hfUkVEPW0KIyBDT05GSUdfTkVUX1NDSF9TRkIgaXMgbm90IHNldApDT05GSUdf
TkVUX1NDSF9TRlE9bQpDT05GSUdfTkVUX1NDSF9URVFMPW0KQ09ORklHX05FVF9TQ0hfVEJG
PW0KQ09ORklHX05FVF9TQ0hfR1JFRD1tCkNPTkZJR19ORVRfU0NIX0RTTUFSSz1tCkNPTkZJ
R19ORVRfU0NIX05FVEVNPW0KQ09ORklHX05FVF9TQ0hfRFJSPW0KIyBDT05GSUdfTkVUX1ND
SF9NUVBSSU8gaXMgbm90IHNldAojIENPTkZJR19ORVRfU0NIX0NIT0tFIGlzIG5vdCBzZXQK
IyBDT05GSUdfTkVUX1NDSF9RRlEgaXMgbm90IHNldAojIENPTkZJR19ORVRfU0NIX0lOR1JF
U1MgaXMgbm90IHNldAoKIwojIENsYXNzaWZpY2F0aW9uCiMKQ09ORklHX05FVF9DTFM9eQpD
T05GSUdfTkVUX0NMU19CQVNJQz1tCkNPTkZJR19ORVRfQ0xTX1RDSU5ERVg9bQpDT05GSUdf
TkVUX0NMU19ST1VURTQ9bQpDT05GSUdfTkVUX0NMU19GVz1tCiMgQ09ORklHX05FVF9DTFNf
VTMyIGlzIG5vdCBzZXQKQ09ORklHX05FVF9DTFNfUlNWUD1tCkNPTkZJR19ORVRfQ0xTX1JT
VlA2PW0KIyBDT05GSUdfTkVUX0NMU19GTE9XIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX0NM
U19DR1JPVVAgaXMgbm90IHNldApDT05GSUdfTkVUX0VNQVRDSD15CkNPTkZJR19ORVRfRU1B
VENIX1NUQUNLPTMyCkNPTkZJR19ORVRfRU1BVENIX0NNUD1tCkNPTkZJR19ORVRfRU1BVENI
X05CWVRFPW0KQ09ORklHX05FVF9FTUFUQ0hfVTMyPW0KQ09ORklHX05FVF9FTUFUQ0hfTUVU
QT1tCkNPTkZJR19ORVRfRU1BVENIX1RFWFQ9bQpDT05GSUdfTkVUX0NMU19BQ1Q9eQpDT05G
SUdfTkVUX0FDVF9QT0xJQ0U9bQpDT05GSUdfTkVUX0FDVF9HQUNUPW0KQ09ORklHX0dBQ1Rf
UFJPQj15CkNPTkZJR19ORVRfQUNUX01JUlJFRD1tCkNPTkZJR19ORVRfQUNUX0lQVD1tCkNP
TkZJR19ORVRfQUNUX05BVD1tCkNPTkZJR19ORVRfQUNUX1BFRElUPW0KQ09ORklHX05FVF9B
Q1RfU0lNUD1tCkNPTkZJR19ORVRfQUNUX1NLQkVESVQ9bQpDT05GSUdfTkVUX0FDVF9DU1VN
PW0KIyBDT05GSUdfTkVUX0NMU19JTkQgaXMgbm90IHNldApDT05GSUdfTkVUX1NDSF9GSUZP
PXkKQ09ORklHX0RDQj15CkNPTkZJR19ETlNfUkVTT0xWRVI9eQpDT05GSUdfQkFUTUFOX0FE
Vj1tCiMgQ09ORklHX0JBVE1BTl9BRFZfREVCVUcgaXMgbm90IHNldApDT05GSUdfUlBTPXkK
Q09ORklHX1JGU19BQ0NFTD15CkNPTkZJR19YUFM9eQoKIwojIE5ldHdvcmsgdGVzdGluZwoj
CkNPTkZJR19ORVRfUEtUR0VOPW0KIyBDT05GSUdfTkVUX1RDUFBST0JFIGlzIG5vdCBzZXQK
IyBDT05GSUdfTkVUX0RST1BfTU9OSVRPUiBpcyBub3Qgc2V0CiMgQ09ORklHX0hBTVJBRElP
IGlzIG5vdCBzZXQKIyBDT05GSUdfQ0FOIGlzIG5vdCBzZXQKQ09ORklHX0lSREE9bQoKIwoj
IElyREEgcHJvdG9jb2xzCiMKQ09ORklHX0lSTEFOPW0KQ09ORklHX0lSTkVUPW0KQ09ORklH
X0lSQ09NTT1tCkNPTkZJR19JUkRBX1VMVFJBPXkKCiMKIyBJckRBIG9wdGlvbnMKIwpDT05G
SUdfSVJEQV9DQUNIRV9MQVNUX0xTQVA9eQpDT05GSUdfSVJEQV9GQVNUX1JSPXkKQ09ORklH
X0lSREFfREVCVUc9eQoKIwojIEluZnJhcmVkLXBvcnQgZGV2aWNlIGRyaXZlcnMKIwoKIwoj
IFNJUiBkZXZpY2UgZHJpdmVycwojCkNPTkZJR19JUlRUWV9TSVI9bQoKIwojIERvbmdsZSBz
dXBwb3J0CiMKQ09ORklHX0RPTkdMRT15CkNPTkZJR19FU0lfRE9OR0xFPW0KQ09ORklHX0FD
VElTWVNfRE9OR0xFPW0KQ09ORklHX1RFS1JBTV9ET05HTEU9bQpDT05GSUdfVE9JTTMyMzJf
RE9OR0xFPW0KQ09ORklHX0xJVEVMSU5LX0RPTkdMRT1tCkNPTkZJR19NQTYwMF9ET05HTEU9
bQpDT05GSUdfR0lSQklMX0RPTkdMRT1tCkNPTkZJR19NQ1AyMTIwX0RPTkdMRT1tCkNPTkZJ
R19PTERfQkVMS0lOX0RPTkdMRT1tCkNPTkZJR19BQ1QyMDBMX0RPTkdMRT1tCkNPTkZJR19L
SU5HU1VOX0RPTkdMRT1tCkNPTkZJR19LU0RBWlpMRV9ET05HTEU9bQpDT05GSUdfS1M5NTlf
RE9OR0xFPW0KCiMKIyBGSVIgZGV2aWNlIGRyaXZlcnMKIwpDT05GSUdfVVNCX0lSREE9bQpD
T05GSUdfU0lHTUFURUxfRklSPW0KQ09ORklHX01DU19GSVI9bQpDT05GSUdfQlQ9bQpDT05G
SUdfQlRfTDJDQVA9eQpDT05GSUdfQlRfU0NPPXkKQ09ORklHX0JUX1JGQ09NTT1tCkNPTkZJ
R19CVF9SRkNPTU1fVFRZPXkKQ09ORklHX0JUX0JORVA9bQpDT05GSUdfQlRfQk5FUF9NQ19G
SUxURVI9eQpDT05GSUdfQlRfQk5FUF9QUk9UT19GSUxURVI9eQpDT05GSUdfQlRfSElEUD1t
CgojCiMgQmx1ZXRvb3RoIGRldmljZSBkcml2ZXJzCiMKQ09ORklHX0JUX0hDSUJUVVNCPW0K
Q09ORklHX0JUX0hDSUJUU0RJTz1tCkNPTkZJR19CVF9IQ0lVQVJUPW0KQ09ORklHX0JUX0hD
SVVBUlRfSDQ9eQpDT05GSUdfQlRfSENJVUFSVF9CQ1NQPXkKQ09ORklHX0JUX0hDSVVBUlRf
QVRIM0s9eQpDT05GSUdfQlRfSENJVUFSVF9MTD15CkNPTkZJR19CVF9IQ0lCQ00yMDNYPW0K
Q09ORklHX0JUX0hDSUJQQTEwWD1tCkNPTkZJR19CVF9IQ0lCRlVTQj1tCkNPTkZJR19CVF9I
Q0lWSENJPW0KQ09ORklHX0JUX01SVkw9bQpDT05GSUdfQlRfTVJWTF9TRElPPW0KQ09ORklH
X0JUX0FUSDNLPW0KQ09ORklHX0JUX1dJTElOSz1tCkNPTkZJR19BRl9SWFJQQz1tCiMgQ09O
RklHX0FGX1JYUlBDX0RFQlVHIGlzIG5vdCBzZXQKQ09ORklHX1JYS0FEPW0KQ09ORklHX0ZJ
Ql9SVUxFUz15CkNPTkZJR19XSVJFTEVTUz15CkNPTkZJR19XSVJFTEVTU19FWFQ9eQpDT05G
SUdfV0VYVF9DT1JFPXkKQ09ORklHX1dFWFRfUFJPQz15CkNPTkZJR19XRVhUX1NQWT15CkNP
TkZJR19XRVhUX1BSSVY9eQpDT05GSUdfQ0ZHODAyMTE9bQojIENPTkZJR19OTDgwMjExX1RF
U1RNT0RFIGlzIG5vdCBzZXQKIyBDT05GSUdfQ0ZHODAyMTFfREVWRUxPUEVSX1dBUk5JTkdT
IGlzIG5vdCBzZXQKQ09ORklHX0NGRzgwMjExX1JFR19ERUJVRz15CkNPTkZJR19DRkc4MDIx
MV9ERUZBVUxUX1BTPXkKQ09ORklHX0NGRzgwMjExX0RFQlVHRlM9eQojIENPTkZJR19DRkc4
MDIxMV9JTlRFUk5BTF9SRUdEQiBpcyBub3Qgc2V0CkNPTkZJR19DRkc4MDIxMV9XRVhUPXkK
Q09ORklHX1dJUkVMRVNTX0VYVF9TWVNGUz15CkNPTkZJR19MSUI4MDIxMT1tCkNPTkZJR19M
SUI4MDIxMV9DUllQVF9XRVA9bQpDT05GSUdfTElCODAyMTFfQ1JZUFRfQ0NNUD1tCkNPTkZJ
R19MSUI4MDIxMV9DUllQVF9US0lQPW0KIyBDT05GSUdfTElCODAyMTFfREVCVUcgaXMgbm90
IHNldApDT05GSUdfTUFDODAyMTE9bQpDT05GSUdfTUFDODAyMTFfSEFTX1JDPXkKQ09ORklH
X01BQzgwMjExX1JDX1BJRD15CkNPTkZJR19NQUM4MDIxMV9SQ19NSU5TVFJFTD15CkNPTkZJ
R19NQUM4MDIxMV9SQ19NSU5TVFJFTF9IVD15CiMgQ09ORklHX01BQzgwMjExX1JDX0RFRkFV
TFRfUElEIGlzIG5vdCBzZXQKQ09ORklHX01BQzgwMjExX1JDX0RFRkFVTFRfTUlOU1RSRUw9
eQpDT05GSUdfTUFDODAyMTFfUkNfREVGQVVMVD0ibWluc3RyZWxfaHQiCkNPTkZJR19NQUM4
MDIxMV9NRVNIPXkKQ09ORklHX01BQzgwMjExX0xFRFM9eQpDT05GSUdfTUFDODAyMTFfREVC
VUdGUz15CiMgQ09ORklHX01BQzgwMjExX0RFQlVHX01FTlUgaXMgbm90IHNldApDT05GSUdf
V0lNQVg9bQpDT05GSUdfV0lNQVhfREVCVUdfTEVWRUw9OApDT05GSUdfUkZLSUxMPW0KQ09O
RklHX1JGS0lMTF9MRURTPXkKQ09ORklHX1JGS0lMTF9JTlBVVD15CkNPTkZJR19SRktJTExf
UkVHVUxBVE9SPW0KQ09ORklHX1JGS0lMTF9HUElPPW0KQ09ORklHX05FVF85UD1tCiMgQ09O
RklHX05FVF85UF9ERUJVRyBpcyBub3Qgc2V0CkNPTkZJR19DQUlGPW0KIyBDT05GSUdfQ0FJ
Rl9ERUJVRyBpcyBub3Qgc2V0CkNPTkZJR19DQUlGX05FVERFVj1tCkNPTkZJR19DRVBIX0xJ
Qj1tCiMgQ09ORklHX0NFUEhfTElCX1BSRVRUWURFQlVHIGlzIG5vdCBzZXQKQ09ORklHX05G
Qz1tCgojCiMgTmVhciBGaWVsZCBDb21tdW5pY2F0aW9uIChORkMpIGRldmljZXMKIwpDT05G
SUdfUE41NDRfTkZDPW0KQ09ORklHX05GQ19QTjUzMz1tCgojCiMgRGV2aWNlIERyaXZlcnMK
IwoKIwojIEdlbmVyaWMgRHJpdmVyIE9wdGlvbnMKIwpDT05GSUdfVUVWRU5UX0hFTFBFUl9Q
QVRIPSIiCkNPTkZJR19ERVZUTVBGUz15CkNPTkZJR19ERVZUTVBGU19NT1VOVD15CkNPTkZJ
R19TVEFOREFMT05FPXkKQ09ORklHX1BSRVZFTlRfRklSTVdBUkVfQlVJTEQ9eQpDT05GSUdf
RldfTE9BREVSPXkKQ09ORklHX0ZJUk1XQVJFX0lOX0tFUk5FTD15CkNPTkZJR19FWFRSQV9G
SVJNV0FSRT0iIgojIENPTkZJR19ERUJVR19EUklWRVIgaXMgbm90IHNldAojIENPTkZJR19E
RUJVR19ERVZSRVMgaXMgbm90IHNldAojIENPTkZJR19TWVNfSFlQRVJWSVNPUiBpcyBub3Qg
c2V0CkNPTkZJR19SRUdNQVA9eQpDT05GSUdfUkVHTUFQX0kyQz15CkNPTkZJR19DT05ORUNU
T1I9eQpDT05GSUdfUFJPQ19FVkVOVFM9eQpDT05GSUdfTVREPXkKIyBDT05GSUdfTVREX0RF
QlVHIGlzIG5vdCBzZXQKQ09ORklHX01URF9URVNUUz1tCkNPTkZJR19NVERfUkVEQk9PVF9Q
QVJUUz1tCkNPTkZJR19NVERfUkVEQk9PVF9ESVJFQ1RPUllfQkxPQ0s9LTEKIyBDT05GSUdf
TVREX1JFREJPT1RfUEFSVFNfVU5BTExPQ0FURUQgaXMgbm90IHNldAojIENPTkZJR19NVERf
UkVEQk9PVF9QQVJUU19SRUFET05MWSBpcyBub3Qgc2V0CkNPTkZJR19NVERfQ01ETElORV9Q
QVJUUz15CiMgQ09ORklHX01URF9BRlNfUEFSVFMgaXMgbm90IHNldApDT05GSUdfTVREX09G
X1BBUlRTPXkKIyBDT05GSUdfTVREX0FSN19QQVJUUyBpcyBub3Qgc2V0CgojCiMgVXNlciBN
b2R1bGVzIEFuZCBUcmFuc2xhdGlvbiBMYXllcnMKIwpDT05GSUdfTVREX0NIQVI9eQpDT05G
SUdfTVREX0JMS0RFVlM9eQpDT05GSUdfTVREX0JMT0NLPXkKQ09ORklHX0ZUTD1tCkNPTkZJ
R19ORlRMPW0KQ09ORklHX05GVExfUlc9eQpDT05GSUdfSU5GVEw9bQpDT05GSUdfUkZEX0ZU
TD1tCkNPTkZJR19TU0ZEQz1tCkNPTkZJR19TTV9GVEw9bQpDT05GSUdfTVREX09PUFM9bQoj
IENPTkZJR19NVERfU1dBUCBpcyBub3Qgc2V0CgojCiMgUkFNL1JPTS9GbGFzaCBjaGlwIGRy
aXZlcnMKIwpDT05GSUdfTVREX0NGST1tCkNPTkZJR19NVERfSkVERUNQUk9CRT1tCkNPTkZJ
R19NVERfR0VOX1BST0JFPW0KIyBDT05GSUdfTVREX0NGSV9BRFZfT1BUSU9OUyBpcyBub3Qg
c2V0CkNPTkZJR19NVERfTUFQX0JBTktfV0lEVEhfMT15CkNPTkZJR19NVERfTUFQX0JBTktf
V0lEVEhfMj15CkNPTkZJR19NVERfTUFQX0JBTktfV0lEVEhfND15CiMgQ09ORklHX01URF9N
QVBfQkFOS19XSURUSF84IGlzIG5vdCBzZXQKIyBDT05GSUdfTVREX01BUF9CQU5LX1dJRFRI
XzE2IGlzIG5vdCBzZXQKIyBDT05GSUdfTVREX01BUF9CQU5LX1dJRFRIXzMyIGlzIG5vdCBz
ZXQKQ09ORklHX01URF9DRklfSTE9eQpDT05GSUdfTVREX0NGSV9JMj15CiMgQ09ORklHX01U
RF9DRklfSTQgaXMgbm90IHNldAojIENPTkZJR19NVERfQ0ZJX0k4IGlzIG5vdCBzZXQKQ09O
RklHX01URF9DRklfSU5URUxFWFQ9bQpDT05GSUdfTVREX0NGSV9BTURTVEQ9bQpDT05GSUdf
TVREX0NGSV9TVEFBPW0KQ09ORklHX01URF9DRklfVVRJTD1tCkNPTkZJR19NVERfUkFNPW0K
Q09ORklHX01URF9ST009bQpDT05GSUdfTVREX0FCU0VOVD1tCgojCiMgTWFwcGluZyBkcml2
ZXJzIGZvciBjaGlwIGFjY2VzcwojCkNPTkZJR19NVERfQ09NUExFWF9NQVBQSU5HUz15CkNP
TkZJR19NVERfUEhZU01BUD1tCiMgQ09ORklHX01URF9QSFlTTUFQX0NPTVBBVCBpcyBub3Qg
c2V0CiMgQ09ORklHX01URF9QSFlTTUFQX09GIGlzIG5vdCBzZXQKIyBDT05GSUdfTVREX0FS
TV9JTlRFR1JBVE9SIGlzIG5vdCBzZXQKIyBDT05GSUdfTVREX0lNUEE3IGlzIG5vdCBzZXQK
IyBDT05GSUdfTVREX0dQSU9fQUREUiBpcyBub3Qgc2V0CkNPTkZJR19NVERfUExBVFJBTT1t
CiMgQ09ORklHX01URF9MQVRDSF9BRERSIGlzIG5vdCBzZXQKCiMKIyBTZWxmLWNvbnRhaW5l
ZCBNVEQgZGV2aWNlIGRyaXZlcnMKIwojIENPTkZJR19NVERfREFUQUZMQVNIIGlzIG5vdCBz
ZXQKQ09ORklHX01URF9NMjVQODA9bQpDT05GSUdfTTI1UFhYX1VTRV9GQVNUX1JFQUQ9eQoj
IENPTkZJR19NVERfU1NUMjVMIGlzIG5vdCBzZXQKQ09ORklHX01URF9TTFJBTT1tCkNPTkZJ
R19NVERfUEhSQU09bQpDT05GSUdfTVREX01URFJBTT1tCkNPTkZJR19NVERSQU1fVE9UQUxf
U0laRT00MDk2CkNPTkZJR19NVERSQU1fRVJBU0VfU0laRT0xMjgKQ09ORklHX01URF9CTE9D
SzJNVEQ9bQoKIwojIERpc2stT24tQ2hpcCBEZXZpY2UgRHJpdmVycwojCkNPTkZJR19NVERf
RE9DMjAwMD1tCkNPTkZJR19NVERfRE9DMjAwMT1tCkNPTkZJR19NVERfRE9DMjAwMVBMVVM9
bQpDT05GSUdfTVREX0RPQ1BST0JFPW0KQ09ORklHX01URF9ET0NFQ0M9bQojIENPTkZJR19N
VERfRE9DUFJPQkVfQURWQU5DRUQgaXMgbm90IHNldApDT05GSUdfTVREX0RPQ1BST0JFX0FE
RFJFU1M9MApDT05GSUdfTVREX05BTkRfRUNDPXkKIyBDT05GSUdfTVREX05BTkRfRUNDX1NN
QyBpcyBub3Qgc2V0CkNPTkZJR19NVERfTkFORD15CiMgQ09ORklHX01URF9OQU5EX1ZFUklG
WV9XUklURSBpcyBub3Qgc2V0CiMgQ09ORklHX01URF9OQU5EX0VDQ19CQ0ggaXMgbm90IHNl
dAojIENPTkZJR19NVERfU01fQ09NTU9OIGlzIG5vdCBzZXQKIyBDT05GSUdfTVREX05BTkRf
TVVTRVVNX0lEUyBpcyBub3Qgc2V0CiMgQ09ORklHX01URF9OQU5EX0dQSU8gaXMgbm90IHNl
dApDT05GSUdfTVREX05BTkRfT01BUDI9eQpDT05GSUdfTVREX05BTkRfSURTPXkKQ09ORklH
X01URF9OQU5EX0RJU0tPTkNISVA9bQojIENPTkZJR19NVERfTkFORF9ESVNLT05DSElQX1BS
T0JFX0FEVkFOQ0VEIGlzIG5vdCBzZXQKQ09ORklHX01URF9OQU5EX0RJU0tPTkNISVBfUFJP
QkVfQUREUkVTUz0wCiMgQ09ORklHX01URF9OQU5EX0RJU0tPTkNISVBfQkJUV1JJVEUgaXMg
bm90IHNldAojIENPTkZJR19NVERfTkFORF9OQU5EU0lNIGlzIG5vdCBzZXQKQ09ORklHX01U
RF9OQU5EX1BMQVRGT1JNPXkKIyBDT05GSUdfTVREX0FMQVVEQSBpcyBub3Qgc2V0CkNPTkZJ
R19NVERfT05FTkFORD15CkNPTkZJR19NVERfT05FTkFORF9WRVJJRllfV1JJVEU9eQojIENP
TkZJR19NVERfT05FTkFORF9HRU5FUklDIGlzIG5vdCBzZXQKQ09ORklHX01URF9PTkVOQU5E
X09NQVAyPXkKIyBDT05GSUdfTVREX09ORU5BTkRfT1RQIGlzIG5vdCBzZXQKQ09ORklHX01U
RF9PTkVOQU5EXzJYX1BST0dSQU09eQpDT05GSUdfTVREX09ORU5BTkRfU0lNPW0KCiMKIyBM
UEREUiBmbGFzaCBtZW1vcnkgZHJpdmVycwojCkNPTkZJR19NVERfTFBERFI9bQpDT05GSUdf
TVREX1FJTkZPX1BST0JFPW0KQ09ORklHX01URF9VQkk9bQpDT05GSUdfTVREX1VCSV9XTF9U
SFJFU0hPTEQ9NDA5NgpDT05GSUdfTVREX1VCSV9CRUJfUkVTRVJWRT0xCkNPTkZJR19NVERf
VUJJX0dMVUVCST1tCiMgQ09ORklHX01URF9VQklfREVCVUcgaXMgbm90IHNldApDT05GSUdf
RFRDPXkKQ09ORklHX09GPXkKCiMKIyBEZXZpY2UgVHJlZSBhbmQgT3BlbiBGaXJtd2FyZSBz
dXBwb3J0CiMKIyBDT05GSUdfUFJPQ19ERVZJQ0VUUkVFIGlzIG5vdCBzZXQKQ09ORklHX09G
X0ZMQVRUUkVFPXkKQ09ORklHX09GX0VBUkxZX0ZMQVRUUkVFPXkKQ09ORklHX09GX0FERFJF
U1M9eQpDT05GSUdfT0ZfSVJRPXkKQ09ORklHX09GX0RFVklDRT15CkNPTkZJR19PRl9HUElP
PXkKQ09ORklHX09GX0kyQz15CkNPTkZJR19PRl9ORVQ9eQpDT05GSUdfT0ZfU1BJPXkKQ09O
RklHX09GX01ESU89eQojIENPTkZJR19QQVJQT1JUIGlzIG5vdCBzZXQKQ09ORklHX0JMS19E
RVY9eQojIENPTkZJR19CTEtfREVWX0NPV19DT01NT04gaXMgbm90IHNldApDT05GSUdfQkxL
X0RFVl9MT09QPXkKQ09ORklHX0JMS19ERVZfTE9PUF9NSU5fQ09VTlQ9OApDT05GSUdfQkxL
X0RFVl9DUllQVE9MT09QPW0KQ09ORklHX0JMS19ERVZfRFJCRD1tCiMgQ09ORklHX0RSQkRf
RkFVTFRfSU5KRUNUSU9OIGlzIG5vdCBzZXQKQ09ORklHX0JMS19ERVZfTkJEPW0KIyBDT05G
SUdfQkxLX0RFVl9VQiBpcyBub3Qgc2V0CkNPTkZJR19CTEtfREVWX1JBTT15CkNPTkZJR19C
TEtfREVWX1JBTV9DT1VOVD0xNgpDT05GSUdfQkxLX0RFVl9SQU1fU0laRT02NTUzNgojIENP
TkZJR19CTEtfREVWX1hJUCBpcyBub3Qgc2V0CkNPTkZJR19DRFJPTV9QS1RDRFZEPW0KQ09O
RklHX0NEUk9NX1BLVENEVkRfQlVGRkVSUz04CiMgQ09ORklHX0NEUk9NX1BLVENEVkRfV0NB
Q0hFIGlzIG5vdCBzZXQKQ09ORklHX0FUQV9PVkVSX0VUSD1tCkNPTkZJR19NR19ESVNLPW0K
Q09ORklHX01HX0RJU0tfUkVTPTAKIyBDT05GSUdfQkxLX0RFVl9SQkQgaXMgbm90IHNldAoj
IENPTkZJR19TRU5TT1JTX0xJUzNMVjAyRCBpcyBub3Qgc2V0CkNPTkZJR19NSVNDX0RFVklD
RVM9eQpDT05GSUdfQUQ1MjVYX0RQT1Q9bQpDT05GSUdfQUQ1MjVYX0RQT1RfSTJDPW0KQ09O
RklHX0FENTI1WF9EUE9UX1NQST1tCkNPTkZJR19JQ1M5MzJTNDAxPW0KQ09ORklHX0VOQ0xP
U1VSRV9TRVJWSUNFUz1tCiMgQ09ORklHX0FQRFM5ODAyQUxTIGlzIG5vdCBzZXQKQ09ORklH
X0lTTDI5MDAzPW0KIyBDT05GSUdfSVNMMjkwMjAgaXMgbm90IHNldApDT05GSUdfU0VOU09S
U19UU0wyNTUwPW0KQ09ORklHX1NFTlNPUlNfQkgxNzgwPW0KIyBDT05GSUdfU0VOU09SU19C
SDE3NzAgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0FQRFM5OTBYIGlzIG5vdCBzZXQK
Q09ORklHX0hNQzYzNTI9bQpDT05GSUdfRFMxNjgyPW0KQ09ORklHX1RJX0RBQzc1MTI9bQpD
T05GSUdfQk1QMDg1PW0KIyBDT05GSUdfVVNCX1NXSVRDSF9GU0E5NDgwIGlzIG5vdCBzZXQK
IyBDT05GSUdfQzJQT1JUIGlzIG5vdCBzZXQKCiMKIyBFRVBST00gc3VwcG9ydAojCkNPTkZJ
R19FRVBST01fQVQyND1tCkNPTkZJR19FRVBST01fQVQyNT1tCkNPTkZJR19FRVBST01fTEVH
QUNZPW0KQ09ORklHX0VFUFJPTV9NQVg2ODc1PW0KQ09ORklHX0VFUFJPTV85M0NYNj1tCkNP
TkZJR19FRVBST01fOTNYWDQ2PW0KQ09ORklHX0lXTUMzMjAwVE9QPW0KIyBDT05GSUdfSVdN
QzMyMDBUT1BfREVCVUcgaXMgbm90IHNldAojIENPTkZJR19JV01DMzIwMFRPUF9ERUJVR0ZT
IGlzIG5vdCBzZXQKCiMKIyBUZXhhcyBJbnN0cnVtZW50cyBzaGFyZWQgdHJhbnNwb3J0IGxp
bmUgZGlzY2lwbGluZQojCkNPTkZJR19USV9TVD1tCiMgQ09ORklHX1NFTlNPUlNfTElTM19T
UEkgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0xJUzNfSTJDIGlzIG5vdCBzZXQKQ09O
RklHX0hBVkVfSURFPXkKIyBDT05GSUdfSURFIGlzIG5vdCBzZXQKCiMKIyBTQ1NJIGRldmlj
ZSBzdXBwb3J0CiMKQ09ORklHX1NDU0lfTU9EPXkKQ09ORklHX1JBSURfQVRUUlM9bQpDT05G
SUdfU0NTST15CkNPTkZJR19TQ1NJX0RNQT15CkNPTkZJR19TQ1NJX1RHVD1tCkNPTkZJR19T
Q1NJX05FVExJTks9eQpDT05GSUdfU0NTSV9QUk9DX0ZTPXkKCiMKIyBTQ1NJIHN1cHBvcnQg
dHlwZSAoZGlzaywgdGFwZSwgQ0QtUk9NKQojCkNPTkZJR19CTEtfREVWX1NEPXkKQ09ORklH
X0NIUl9ERVZfU1Q9bQpDT05GSUdfQ0hSX0RFVl9PU1NUPW0KQ09ORklHX0JMS19ERVZfU1I9
eQojIENPTkZJR19CTEtfREVWX1NSX1ZFTkRPUiBpcyBub3Qgc2V0CkNPTkZJR19DSFJfREVW
X1NHPXkKQ09ORklHX0NIUl9ERVZfU0NIPW0KQ09ORklHX1NDU0lfRU5DTE9TVVJFPW0KQ09O
RklHX1NDU0lfTVVMVElfTFVOPXkKQ09ORklHX1NDU0lfQ09OU1RBTlRTPXkKQ09ORklHX1ND
U0lfTE9HR0lORz15CkNPTkZJR19TQ1NJX1NDQU5fQVNZTkM9eQpDT05GSUdfU0NTSV9XQUlU
X1NDQU49bQoKIwojIFNDU0kgVHJhbnNwb3J0cwojCiMgQ09ORklHX1NDU0lfU1BJX0FUVFJT
IGlzIG5vdCBzZXQKQ09ORklHX1NDU0lfRkNfQVRUUlM9bQpDT05GSUdfU0NTSV9GQ19UR1Rf
QVRUUlM9eQpDT05GSUdfU0NTSV9JU0NTSV9BVFRSUz1tCkNPTkZJR19TQ1NJX1NBU19BVFRS
Uz1tCkNPTkZJR19TQ1NJX1NBU19MSUJTQVM9bQpDT05GSUdfU0NTSV9TQVNfQVRBPXkKQ09O
RklHX1NDU0lfU0FTX0hPU1RfU01QPXkKQ09ORklHX1NDU0lfU1JQX0FUVFJTPW0KQ09ORklH
X1NDU0lfU1JQX1RHVF9BVFRSUz15CkNPTkZJR19TQ1NJX0xPV0xFVkVMPXkKQ09ORklHX0lT
Q1NJX1RDUD1tCkNPTkZJR19JU0NTSV9CT09UX1NZU0ZTPW0KQ09ORklHX0xJQkZDPW0KQ09O
RklHX0xJQkZDT0U9bQpDT05GSUdfU0NTSV9ERUJVRz1tCkNPTkZJR19TQ1NJX0RIPXkKQ09O
RklHX1NDU0lfREhfUkRBQz1tCkNPTkZJR19TQ1NJX0RIX0hQX1NXPW0KQ09ORklHX1NDU0lf
REhfRU1DPW0KQ09ORklHX1NDU0lfREhfQUxVQT1tCiMgQ09ORklHX1NDU0lfT1NEX0lOSVRJ
QVRPUiBpcyBub3Qgc2V0CkNPTkZJR19BVEE9bQojIENPTkZJR19BVEFfTk9OU1RBTkRBUkQg
aXMgbm90IHNldApDT05GSUdfQVRBX1ZFUkJPU0VfRVJST1I9eQpDT05GSUdfU0FUQV9QTVA9
eQoKIwojIENvbnRyb2xsZXJzIHdpdGggbm9uLVNGRiBuYXRpdmUgaW50ZXJmYWNlCiMKIyBD
T05GSUdfU0FUQV9BSENJX1BMQVRGT1JNIGlzIG5vdCBzZXQKQ09ORklHX0FUQV9TRkY9eQoK
IwojIFNGRiBjb250cm9sbGVycyB3aXRoIGN1c3RvbSBETUEgaW50ZXJmYWNlCiMKQ09ORklH
X0FUQV9CTURNQT15CgojCiMgU0FUQSBTRkYgY29udHJvbGxlcnMgd2l0aCBCTURNQQojCkNP
TkZJR19TQVRBX01WPW0KCiMKIyBQQVRBIFNGRiBjb250cm9sbGVycyB3aXRoIEJNRE1BCiMK
CiMKIyBQSU8tb25seSBTRkYgY29udHJvbGxlcnMKIwojIENPTkZJR19QQVRBX1BMQVRGT1JN
IGlzIG5vdCBzZXQKCiMKIyBHZW5lcmljIGZhbGxiYWNrIC8gbGVnYWN5IGRyaXZlcnMKIwpD
T05GSUdfTUQ9eQpDT05GSUdfQkxLX0RFVl9NRD15CkNPTkZJR19NRF9BVVRPREVURUNUPXkK
Q09ORklHX01EX0xJTkVBUj1tCkNPTkZJR19NRF9SQUlEMD1tCkNPTkZJR19NRF9SQUlEMT1t
CkNPTkZJR19NRF9SQUlEMTA9bQpDT05GSUdfTURfUkFJRDQ1Nj1tCiMgQ09ORklHX01VTFRJ
Q09SRV9SQUlENDU2IGlzIG5vdCBzZXQKQ09ORklHX01EX01VTFRJUEFUSD1tCkNPTkZJR19N
RF9GQVVMVFk9bQpDT05GSUdfQkxLX0RFVl9ETT15CiMgQ09ORklHX0RNX0RFQlVHIGlzIG5v
dCBzZXQKQ09ORklHX0RNX0NSWVBUPW0KQ09ORklHX0RNX1NOQVBTSE9UPXkKQ09ORklHX0RN
X01JUlJPUj15CkNPTkZJR19ETV9SQUlEPW0KIyBDT05GSUdfRE1fTE9HX1VTRVJTUEFDRSBp
cyBub3Qgc2V0CkNPTkZJR19ETV9aRVJPPW0KQ09ORklHX0RNX01VTFRJUEFUSD15CkNPTkZJ
R19ETV9NVUxUSVBBVEhfUUw9bQpDT05GSUdfRE1fTVVMVElQQVRIX1NUPW0KIyBDT05GSUdf
RE1fREVMQVkgaXMgbm90IHNldApDT05GSUdfRE1fVUVWRU5UPXkKIyBDT05GSUdfRE1fRkxB
S0VZIGlzIG5vdCBzZXQKQ09ORklHX1RBUkdFVF9DT1JFPXkKQ09ORklHX1RDTV9JQkxPQ0s9
bQpDT05GSUdfVENNX0ZJTEVJTz1tCkNPTkZJR19UQ01fUFNDU0k9bQpDT05GSUdfTE9PUEJB
Q0tfVEFSR0VUPW0KQ09ORklHX1RDTV9GQz1tCkNPTkZJR19JU0NTSV9UQVJHRVQ9bQpDT05G
SUdfTkVUREVWSUNFUz15CkNPTkZJR19JRkI9bQpDT05GSUdfRFVNTVk9bQpDT05GSUdfQk9O
RElORz1tCkNPTkZJR19NQUNWTEFOPW0KIyBDT05GSUdfTUFDVlRBUCBpcyBub3Qgc2V0CkNP
TkZJR19FUVVBTElaRVI9bQpDT05GSUdfVFVOPW0KQ09ORklHX1ZFVEg9bQpDT05GSUdfTUlJ
PXkKQ09ORklHX1BIWUxJQj15CgojCiMgTUlJIFBIWSBkZXZpY2UgZHJpdmVycwojCiMgQ09O
RklHX01BUlZFTExfUEhZIGlzIG5vdCBzZXQKIyBDT05GSUdfREFWSUNPTV9QSFkgaXMgbm90
IHNldAojIENPTkZJR19RU0VNSV9QSFkgaXMgbm90IHNldAojIENPTkZJR19MWFRfUEhZIGlz
IG5vdCBzZXQKIyBDT05GSUdfQ0lDQURBX1BIWSBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJVEVT
U0VfUEhZIGlzIG5vdCBzZXQKQ09ORklHX1NNU0NfUEhZPXkKIyBDT05GSUdfQlJPQURDT01f
UEhZIGlzIG5vdCBzZXQKIyBDT05GSUdfSUNQTFVTX1BIWSBpcyBub3Qgc2V0CiMgQ09ORklH
X1JFQUxURUtfUEhZIGlzIG5vdCBzZXQKIyBDT05GSUdfTkFUSU9OQUxfUEhZIGlzIG5vdCBz
ZXQKIyBDT05GSUdfU1RFMTBYUCBpcyBub3Qgc2V0CiMgQ09ORklHX0xTSV9FVDEwMTFDX1BI
WSBpcyBub3Qgc2V0CiMgQ09ORklHX01JQ1JFTF9QSFkgaXMgbm90IHNldAojIENPTkZJR19G
SVhFRF9QSFkgaXMgbm90IHNldAojIENPTkZJR19NRElPX0JJVEJBTkcgaXMgbm90IHNldApD
T05GSUdfTkVUX0VUSEVSTkVUPXkKIyBDT05GSUdfQVg4ODc5NiBpcyBub3Qgc2V0CkNPTkZJ
R19TTUM5MVg9eQojIENPTkZJR19USV9EQVZJTkNJX0VNQUMgaXMgbm90IHNldAojIENPTkZJ
R19USV9EQVZJTkNJX01ESU8gaXMgbm90IHNldAojIENPTkZJR19USV9EQVZJTkNJX0NQRE1B
IGlzIG5vdCBzZXQKQ09ORklHX0RNOTAwMD1tCkNPTkZJR19ETTkwMDBfREVCVUdMRVZFTD00
CkNPTkZJR19ETTkwMDBfRk9SQ0VfU0lNUExFX1BIWV9QT0xMPXkKQ09ORklHX0VOQzI4SjYw
PW0KIyBDT05GSUdfRU5DMjhKNjBfV1JJVEVWRVJJRlkgaXMgbm90IHNldAojIENPTkZJR19F
VEhPQyBpcyBub3Qgc2V0CkNPTkZJR19TTUM5MTFYPXkKQ09ORklHX1NNU0M5MTFYPXkKIyBD
T05GSUdfU01TQzkxMVhfQVJDSF9IT09LUyBpcyBub3Qgc2V0CiMgQ09ORklHX0RORVQgaXMg
bm90IHNldAojIENPTkZJR19JQk1fTkVXX0VNQUNfWk1JSSBpcyBub3Qgc2V0CiMgQ09ORklH
X0lCTV9ORVdfRU1BQ19SR01JSSBpcyBub3Qgc2V0CiMgQ09ORklHX0lCTV9ORVdfRU1BQ19U
QUggaXMgbm90IHNldAojIENPTkZJR19JQk1fTkVXX0VNQUNfRU1BQzQgaXMgbm90IHNldAoj
IENPTkZJR19JQk1fTkVXX0VNQUNfTk9fRkxPV19DVFJMIGlzIG5vdCBzZXQKIyBDT05GSUdf
SUJNX05FV19FTUFDX01BTF9DTFJfSUNJTlRTVEFUIGlzIG5vdCBzZXQKIyBDT05GSUdfSUJN
X05FV19FTUFDX01BTF9DT01NT05fRVJSIGlzIG5vdCBzZXQKIyBDT05GSUdfQjQ0IGlzIG5v
dCBzZXQKQ09ORklHX0tTODg1MT1tCiMgQ09ORklHX0tTODg1MV9NTEwgaXMgbm90IHNldAoj
IENPTkZJR19GVE1BQzEwMCBpcyBub3Qgc2V0CiMgQ09ORklHX05FVERFVl8xMDAwIGlzIG5v
dCBzZXQKIyBDT05GSUdfTkVUREVWXzEwMDAwIGlzIG5vdCBzZXQKQ09ORklHX1dMQU49eQpD
T05GSUdfTElCRVJUQVNfVEhJTkZJUk09bQojIENPTkZJR19MSUJFUlRBU19USElORklSTV9E
RUJVRyBpcyBub3Qgc2V0CkNPTkZJR19MSUJFUlRBU19USElORklSTV9VU0I9bQpDT05GSUdf
QVQ3NkM1MFhfVVNCPW0KQ09ORklHX1VTQl9aRDEyMDE9bQpDT05GSUdfVVNCX05FVF9STkRJ
U19XTEFOPW0KQ09ORklHX1JUTDgxODc9bQpDT05GSUdfUlRMODE4N19MRURTPXkKQ09ORklH
X01BQzgwMjExX0hXU0lNPW0KQ09ORklHX0FUSF9DT01NT049bQojIENPTkZJR19BVEhfREVC
VUcgaXMgbm90IHNldAojIENPTkZJR19BVEg5SyBpcyBub3Qgc2V0CiMgQ09ORklHX0FUSDlL
X0hUQyBpcyBub3Qgc2V0CkNPTkZJR19DQVJMOTE3MD1tCkNPTkZJR19DQVJMOTE3MF9MRURT
PXkKIyBDT05GSUdfQ0FSTDkxNzBfREVCVUdGUyBpcyBub3Qgc2V0CkNPTkZJR19DQVJMOTE3
MF9XUEM9eQpDT05GSUdfQjQzPW0KQ09ORklHX0I0M19TU0I9eQojIENPTkZJR19CNDNfU0RJ
TyBpcyBub3Qgc2V0CkNPTkZJR19CNDNfUElPPXkKQ09ORklHX0I0M19QSFlfTj15CkNPTkZJ
R19CNDNfUEhZX0xQPXkKQ09ORklHX0I0M19MRURTPXkKQ09ORklHX0I0M19IV1JORz15CiMg
Q09ORklHX0I0M19ERUJVRyBpcyBub3Qgc2V0CkNPTkZJR19CNDNMRUdBQ1k9bQpDT05GSUdf
QjQzTEVHQUNZX0xFRFM9eQpDT05GSUdfQjQzTEVHQUNZX0hXUk5HPXkKQ09ORklHX0I0M0xF
R0FDWV9ERUJVRz15CkNPTkZJR19CNDNMRUdBQ1lfRE1BPXkKQ09ORklHX0I0M0xFR0FDWV9Q
SU89eQpDT05GSUdfQjQzTEVHQUNZX0RNQV9BTkRfUElPX01PREU9eQojIENPTkZJR19CNDNM
RUdBQ1lfRE1BX01PREUgaXMgbm90IHNldAojIENPTkZJR19CNDNMRUdBQ1lfUElPX01PREUg
aXMgbm90IHNldApDT05GSUdfSE9TVEFQPW0KQ09ORklHX0hPU1RBUF9GSVJNV0FSRT15CkNP
TkZJR19IT1NUQVBfRklSTVdBUkVfTlZSQU09eQojIENPTkZJR19JV00gaXMgbm90IHNldApD
T05GSUdfTElCRVJUQVM9bQpDT05GSUdfTElCRVJUQVNfVVNCPW0KQ09ORklHX0xJQkVSVEFT
X1NESU89bQpDT05GSUdfTElCRVJUQVNfU1BJPW0KIyBDT05GSUdfTElCRVJUQVNfREVCVUcg
aXMgbm90IHNldAojIENPTkZJR19MSUJFUlRBU19NRVNIIGlzIG5vdCBzZXQKQ09ORklHX1A1
NF9DT01NT049bQpDT05GSUdfUDU0X1VTQj1tCkNPTkZJR19QNTRfU1BJPW0KIyBDT05GSUdf
UDU0X1NQSV9ERUZBVUxUX0VFUFJPTSBpcyBub3Qgc2V0CkNPTkZJR19QNTRfTEVEUz15CkNP
TkZJR19SVDJYMDA9bQpDT05GSUdfUlQyNTAwVVNCPW0KQ09ORklHX1JUNzNVU0I9bQpDT05G
SUdfUlQyODAwVVNCPW0KQ09ORklHX1JUMjgwMFVTQl9SVDMzWFg9eQpDT05GSUdfUlQyODAw
VVNCX1JUMzVYWD15CiMgQ09ORklHX1JUMjgwMFVTQl9SVDUzWFggaXMgbm90IHNldApDT05G
SUdfUlQyODAwVVNCX1VOS05PV049eQpDT05GSUdfUlQyODAwX0xJQj1tCkNPTkZJR19SVDJY
MDBfTElCX1VTQj1tCkNPTkZJR19SVDJYMDBfTElCPW0KQ09ORklHX1JUMlgwMF9MSUJfRklS
TVdBUkU9eQpDT05GSUdfUlQyWDAwX0xJQl9DUllQVE89eQpDT05GSUdfUlQyWDAwX0xJQl9M
RURTPXkKQ09ORklHX1JUMlgwMF9MSUJfREVCVUdGUz15CiMgQ09ORklHX1JUMlgwMF9ERUJV
RyBpcyBub3Qgc2V0CiMgQ09ORklHX1JUTDgxOTJTRSBpcyBub3Qgc2V0CiMgQ09ORklHX1JU
TDgxOTJERSBpcyBub3Qgc2V0CkNPTkZJR19SVEw4MTkyQ1U9bQpDT05GSUdfUlRMV0lGST1t
CkNPTkZJR19SVEw4MTkyQ19DT01NT049bQpDT05GSUdfV0wxMjUxPW0KQ09ORklHX1dMMTI1
MV9TUEk9bQpDT05GSUdfV0wxMjUxX1NESU89bQpDT05GSUdfV0wxMlhYX01FTlU9bQpDT05G
SUdfV0wxMlhYPW0KQ09ORklHX1dMMTJYWF9IVD15CkNPTkZJR19XTDEyWFhfU1BJPW0KQ09O
RklHX1dMMTJYWF9TRElPPW0KQ09ORklHX1dMMTJYWF9TRElPX1RFU1Q9bQpDT05GSUdfV0wx
MlhYX1BMQVRGT1JNX0RBVEE9eQpDT05GSUdfWkQxMjExUlc9bQojIENPTkZJR19aRDEyMTFS
V19ERUJVRyBpcyBub3Qgc2V0CkNPTkZJR19NV0lGSUVYPW0KQ09ORklHX01XSUZJRVhfU0RJ
Tz1tCgojCiMgV2lNQVggV2lyZWxlc3MgQnJvYWRiYW5kIGRldmljZXMKIwojIENPTkZJR19X
SU1BWF9JMjQwME1fVVNCIGlzIG5vdCBzZXQKIyBDT05GSUdfV0lNQVhfSTI0MDBNX1NESU8g
aXMgbm90IHNldAoKIwojIFVTQiBOZXR3b3JrIEFkYXB0ZXJzCiMKQ09ORklHX1VTQl9DQVRD
PW0KQ09ORklHX1VTQl9LQVdFVEg9bQpDT05GSUdfVVNCX1BFR0FTVVM9bQpDT05GSUdfVVNC
X1JUTDgxNTA9bQpDT05GSUdfVVNCX1VTQk5FVD15CkNPTkZJR19VU0JfTkVUX0FYODgxN1g9
bQpDT05GSUdfVVNCX05FVF9DRENFVEhFUj15CkNPTkZJR19VU0JfTkVUX0NEQ19FRU09bQpD
T05GSUdfVVNCX05FVF9DRENfTkNNPXkKQ09ORklHX1VTQl9ORVRfRE05NjAxPW0KQ09ORklH
X1VTQl9ORVRfU01TQzc1WFg9bQpDT05GSUdfVVNCX05FVF9TTVNDOTVYWD1tCkNPTkZJR19V
U0JfTkVUX0dMNjIwQT1tCkNPTkZJR19VU0JfTkVUX05FVDEwODA9bQpDT05GSUdfVVNCX05F
VF9QTFVTQj1tCkNPTkZJR19VU0JfTkVUX01DUzc4MzA9bQpDT05GSUdfVVNCX05FVF9STkRJ
U19IT1NUPXkKQ09ORklHX1VTQl9ORVRfQ0RDX1NVQlNFVD1tCkNPTkZJR19VU0JfQUxJX001
NjMyPXkKQ09ORklHX1VTQl9BTjI3MjA9eQpDT05GSUdfVVNCX0JFTEtJTj15CkNPTkZJR19V
U0JfQVJNTElOVVg9eQpDT05GSUdfVVNCX0VQU09OMjg4OD15CkNPTkZJR19VU0JfS0MyMTkw
PXkKQ09ORklHX1VTQl9ORVRfWkFVUlVTPW0KQ09ORklHX1VTQl9ORVRfQ1g4MjMxMF9FVEg9
bQpDT05GSUdfVVNCX05FVF9LQUxNSUE9bQpDT05GSUdfVVNCX0hTTz1tCkNPTkZJR19VU0Jf
TkVUX0lOVDUxWDE9bQpDT05GSUdfVVNCX0NEQ19QSE9ORVQ9bQpDT05GSUdfVVNCX0lQSEVU
SD1tCkNPTkZJR19VU0JfU0lFUlJBX05FVD1tCkNPTkZJR19VU0JfVkw2MDA9bQojIENPTkZJ
R19XQU4gaXMgbm90IHNldAojIENPTkZJR19BVE1fRFJJVkVSUyBpcyBub3Qgc2V0CkNPTkZJ
R19JRUVFODAyMTU0X0RSSVZFUlM9bQojIENPTkZJR19JRUVFODAyMTU0X0ZBS0VIQVJEIGlz
IG5vdCBzZXQKCiMKIyBDQUlGIHRyYW5zcG9ydCBkcml2ZXJzCiMKIyBDT05GSUdfQ0FJRl9U
VFkgaXMgbm90IHNldAojIENPTkZJR19DQUlGX1NQSV9TTEFWRSBpcyBub3Qgc2V0CiMgQ09O
RklHX0NBSUZfSFNJIGlzIG5vdCBzZXQKQ09ORklHX1BQUD1tCkNPTkZJR19QUFBfTVVMVElM
SU5LPXkKQ09ORklHX1BQUF9GSUxURVI9eQpDT05GSUdfUFBQX0FTWU5DPW0KQ09ORklHX1BQ
UF9TWU5DX1RUWT1tCkNPTkZJR19QUFBfREVGTEFURT1tCkNPTkZJR19QUFBfQlNEQ09NUD1t
CkNPTkZJR19QUFBfTVBQRT1tCkNPTkZJR19QUFBPRT1tCkNPTkZJR19QUFBPQVRNPW0KIyBD
T05GSUdfUFBQT0wyVFAgaXMgbm90IHNldApDT05GSUdfU0xJUD1tCkNPTkZJR19TTElQX0NP
TVBSRVNTRUQ9eQpDT05GSUdfU0xIQz1tCkNPTkZJR19TTElQX1NNQVJUPXkKQ09ORklHX1NM
SVBfTU9ERV9TTElQNj15CkNPTkZJR19ORVRDT05TT0xFPW0KIyBDT05GSUdfTkVUQ09OU09M
RV9EWU5BTUlDIGlzIG5vdCBzZXQKQ09ORklHX05FVFBPTEw9eQojIENPTkZJR19ORVRQT0xM
X1RSQVAgaXMgbm90IHNldApDT05GSUdfTkVUX1BPTExfQ09OVFJPTExFUj15CiMgQ09ORklH
X0lTRE4gaXMgbm90IHNldApDT05GSUdfUEhPTkU9bQoKIwojIElucHV0IGRldmljZSBzdXBw
b3J0CiMKQ09ORklHX0lOUFVUPXkKQ09ORklHX0lOUFVUX0ZGX01FTUxFU1M9eQpDT05GSUdf
SU5QVVRfUE9MTERFVj1tCkNPTkZJR19JTlBVVF9TUEFSU0VLTUFQPW0KCiMKIyBVc2VybGFu
ZCBpbnRlcmZhY2VzCiMKQ09ORklHX0lOUFVUX01PVVNFREVWPXkKQ09ORklHX0lOUFVUX01P
VVNFREVWX1BTQVVYPXkKQ09ORklHX0lOUFVUX01PVVNFREVWX1NDUkVFTl9YPTEwMjQKQ09O
RklHX0lOUFVUX01PVVNFREVWX1NDUkVFTl9ZPTc2OApDT05GSUdfSU5QVVRfSk9ZREVWPW0K
Q09ORklHX0lOUFVUX0VWREVWPXkKIyBDT05GSUdfSU5QVVRfRVZCVUcgaXMgbm90IHNldAoK
IwojIElucHV0IERldmljZSBEcml2ZXJzCiMKQ09ORklHX0lOUFVUX0tFWUJPQVJEPXkKQ09O
RklHX0tFWUJPQVJEX0FEUDU1ODg9bQpDT05GSUdfS0VZQk9BUkRfQURQNTU4OT1tCkNPTkZJ
R19LRVlCT0FSRF9BVEtCRD15CkNPTkZJR19LRVlCT0FSRF9RVDEwNzA9bQpDT05GSUdfS0VZ
Qk9BUkRfUVQyMTYwPW0KQ09ORklHX0tFWUJPQVJEX0xLS0JEPW0KQ09ORklHX0tFWUJPQVJE
X0dQSU89bQpDT05GSUdfS0VZQk9BUkRfVENBNjQxNj1tCkNPTkZJR19LRVlCT0FSRF9NQVRS
SVg9bQpDT05GSUdfS0VZQk9BUkRfTE04MzIzPW0KQ09ORklHX0tFWUJPQVJEX01BWDczNTk9
bQpDT05GSUdfS0VZQk9BUkRfTUNTPW0KQ09ORklHX0tFWUJPQVJEX01QUjEyMT1tCkNPTkZJ
R19LRVlCT0FSRF9ORVdUT049bQpDT05GSUdfS0VZQk9BUkRfT1BFTkNPUkVTPW0KQ09ORklH
X0tFWUJPQVJEX1NUT1dBV0FZPW0KQ09ORklHX0tFWUJPQVJEX1NVTktCRD1tCkNPTkZJR19L
RVlCT0FSRF9PTUFQND1tCkNPTkZJR19LRVlCT0FSRF9UV0w0MDMwPW0KQ09ORklHX0tFWUJP
QVJEX1hUS0JEPW0KQ09ORklHX0lOUFVUX01PVVNFPXkKQ09ORklHX01PVVNFX1BTMj1tCkNP
TkZJR19NT1VTRV9QUzJfQUxQUz15CkNPTkZJR19NT1VTRV9QUzJfTE9HSVBTMlBQPXkKQ09O
RklHX01PVVNFX1BTMl9TWU5BUFRJQ1M9eQpDT05GSUdfTU9VU0VfUFMyX1RSQUNLUE9JTlQ9
eQpDT05GSUdfTU9VU0VfUFMyX0VMQU5URUNIPXkKQ09ORklHX01PVVNFX1BTMl9TRU5URUxJ
Qz15CkNPTkZJR19NT1VTRV9QUzJfVE9VQ0hLSVQ9eQpDT05GSUdfTU9VU0VfU0VSSUFMPW0K
Q09ORklHX01PVVNFX0FQUExFVE9VQ0g9bQpDT05GSUdfTU9VU0VfQkNNNTk3ND1tCkNPTkZJ
R19NT1VTRV9WU1hYWEFBPW0KQ09ORklHX01PVVNFX0dQSU89bQpDT05GSUdfTU9VU0VfU1lO
QVBUSUNTX0kyQz1tCkNPTkZJR19JTlBVVF9KT1lTVElDSz15CkNPTkZJR19KT1lTVElDS19B
TkFMT0c9bQpDT05GSUdfSk9ZU1RJQ0tfQTNEPW0KQ09ORklHX0pPWVNUSUNLX0FEST1tCkNP
TkZJR19KT1lTVElDS19DT0JSQT1tCkNPTkZJR19KT1lTVElDS19HRjJLPW0KQ09ORklHX0pP
WVNUSUNLX0dSSVA9bQpDT05GSUdfSk9ZU1RJQ0tfR1JJUF9NUD1tCkNPTkZJR19KT1lTVElD
S19HVUlMTEVNT1Q9bQpDT05GSUdfSk9ZU1RJQ0tfSU5URVJBQ1Q9bQpDT05GSUdfSk9ZU1RJ
Q0tfU0lERVdJTkRFUj1tCkNPTkZJR19KT1lTVElDS19UTURDPW0KQ09ORklHX0pPWVNUSUNL
X0lGT1JDRT1tCkNPTkZJR19KT1lTVElDS19JRk9SQ0VfVVNCPXkKQ09ORklHX0pPWVNUSUNL
X0lGT1JDRV8yMzI9eQpDT05GSUdfSk9ZU1RJQ0tfV0FSUklPUj1tCkNPTkZJR19KT1lTVElD
S19NQUdFTExBTj1tCkNPTkZJR19KT1lTVElDS19TUEFDRU9SQj1tCkNPTkZJR19KT1lTVElD
S19TUEFDRUJBTEw9bQpDT05GSUdfSk9ZU1RJQ0tfU1RJTkdFUj1tCkNPTkZJR19KT1lTVElD
S19UV0lESk9ZPW0KQ09ORklHX0pPWVNUSUNLX1pIRU5IVUE9bQpDT05GSUdfSk9ZU1RJQ0tf
QVM1MDExPW0KQ09ORklHX0pPWVNUSUNLX0pPWURVTVA9bQpDT05GSUdfSk9ZU1RJQ0tfWFBB
RD1tCkNPTkZJR19KT1lTVElDS19YUEFEX0ZGPXkKQ09ORklHX0pPWVNUSUNLX1hQQURfTEVE
Uz15CkNPTkZJR19JTlBVVF9UQUJMRVQ9eQpDT05GSUdfVEFCTEVUX1VTQl9BQ0VDQUQ9bQpD
T05GSUdfVEFCTEVUX1VTQl9BSVBURUs9bQpDT05GSUdfVEFCTEVUX1VTQl9HVENPPW0KQ09O
RklHX1RBQkxFVF9VU0JfSEFOV0FORz1tCkNPTkZJR19UQUJMRVRfVVNCX0tCVEFCPW0KQ09O
RklHX1RBQkxFVF9VU0JfV0FDT009bQpDT05GSUdfSU5QVVRfVE9VQ0hTQ1JFRU49eQpDT05G
SUdfVE9VQ0hTQ1JFRU5fQURTNzg0Nj1tCkNPTkZJR19UT1VDSFNDUkVFTl9BRDc4Nzc9bQpD
T05GSUdfVE9VQ0hTQ1JFRU5fQUQ3ODc5PW0KQ09ORklHX1RPVUNIU0NSRUVOX0FENzg3OV9J
MkM9bQpDT05GSUdfVE9VQ0hTQ1JFRU5fQUQ3ODc5X1NQST1tCkNPTkZJR19UT1VDSFNDUkVF
Tl9BVE1FTF9NWFQ9bQpDT05GSUdfVE9VQ0hTQ1JFRU5fQlUyMTAxMz1tCkNPTkZJR19UT1VD
SFNDUkVFTl9DWThDVE1HMTEwPW0KQ09ORklHX1RPVUNIU0NSRUVOX0RZTkFQUk89bQpDT05G
SUdfVE9VQ0hTQ1JFRU5fSEFNUFNISVJFPW0KQ09ORklHX1RPVUNIU0NSRUVOX0VFVEk9bQpD
T05GSUdfVE9VQ0hTQ1JFRU5fRlVKSVRTVT1tCkNPTkZJR19UT1VDSFNDUkVFTl9HVU5aRT1t
CkNPTkZJR19UT1VDSFNDUkVFTl9FTE89bQpDT05GSUdfVE9VQ0hTQ1JFRU5fV0FDT01fVzgw
MDE9bQpDT05GSUdfVE9VQ0hTQ1JFRU5fTUFYMTE4MDE9bQpDT05GSUdfVE9VQ0hTQ1JFRU5f
TUNTNTAwMD1tCkNPTkZJR19UT1VDSFNDUkVFTl9NVE9VQ0g9bQpDT05GSUdfVE9VQ0hTQ1JF
RU5fSU5FWElPPW0KQ09ORklHX1RPVUNIU0NSRUVOX01LNzEyPW0KQ09ORklHX1RPVUNIU0NS
RUVOX1BFTk1PVU5UPW0KQ09ORklHX1RPVUNIU0NSRUVOX1RPVUNIUklHSFQ9bQpDT05GSUdf
VE9VQ0hTQ1JFRU5fVE9VQ0hXSU49bQpDT05GSUdfVE9VQ0hTQ1JFRU5fVVNCX0NPTVBPU0lU
RT1tCkNPTkZJR19UT1VDSFNDUkVFTl9VU0JfRUdBTEFYPXkKQ09ORklHX1RPVUNIU0NSRUVO
X1VTQl9QQU5KSVQ9eQpDT05GSUdfVE9VQ0hTQ1JFRU5fVVNCXzNNPXkKQ09ORklHX1RPVUNI
U0NSRUVOX1VTQl9JVE09eQpDT05GSUdfVE9VQ0hTQ1JFRU5fVVNCX0VUVVJCTz15CkNPTkZJ
R19UT1VDSFNDUkVFTl9VU0JfR1VOWkU9eQpDT05GSUdfVE9VQ0hTQ1JFRU5fVVNCX0RNQ19U
U0MxMD15CkNPTkZJR19UT1VDSFNDUkVFTl9VU0JfSVJUT1VDSD15CkNPTkZJR19UT1VDSFND
UkVFTl9VU0JfSURFQUxURUs9eQpDT05GSUdfVE9VQ0hTQ1JFRU5fVVNCX0dFTkVSQUxfVE9V
Q0g9eQpDT05GSUdfVE9VQ0hTQ1JFRU5fVVNCX0dPVE9QPXkKQ09ORklHX1RPVUNIU0NSRUVO
X1VTQl9KQVNURUM9eQpDT05GSUdfVE9VQ0hTQ1JFRU5fVVNCX0UyST15CkNPTkZJR19UT1VD
SFNDUkVFTl9VU0JfWllUUk9OSUM9eQpDT05GSUdfVE9VQ0hTQ1JFRU5fVVNCX0VUVF9UQzQ1
VVNCPXkKQ09ORklHX1RPVUNIU0NSRUVOX1VTQl9ORVhJTz15CkNPTkZJR19UT1VDSFNDUkVF
Tl9UT1VDSElUMjEzPW0KQ09ORklHX1RPVUNIU0NSRUVOX1RTQzIwMDU9bQpDT05GSUdfVE9V
Q0hTQ1JFRU5fVFNDMjAwNz1tCkNPTkZJR19UT1VDSFNDUkVFTl9XOTBYOTAwPW0KQ09ORklH
X1RPVUNIU0NSRUVOX1NUMTIzMj1tCkNPTkZJR19UT1VDSFNDUkVFTl9UUFM2NTA3WD1tCkNP
TkZJR19JTlBVVF9NSVNDPXkKQ09ORklHX0lOUFVUX0FENzE0WD1tCkNPTkZJR19JTlBVVF9B
RDcxNFhfSTJDPW0KQ09ORklHX0lOUFVUX0FENzE0WF9TUEk9bQpDT05GSUdfSU5QVVRfTU1B
ODQ1MD1tCkNPTkZJR19JTlBVVF9NUFUzMDUwPW0KQ09ORklHX0lOUFVUX0FUSV9SRU1PVEU9
bQpDT05GSUdfSU5QVVRfQVRJX1JFTU9URTI9bQpDT05GSUdfSU5QVVRfS0VZU1BBTl9SRU1P
VEU9bQpDT05GSUdfSU5QVVRfS1hUSjk9bQojIENPTkZJR19JTlBVVF9LWFRKOV9QT0xMRURf
TU9ERSBpcyBub3Qgc2V0CkNPTkZJR19JTlBVVF9QT1dFUk1BVEU9bQpDT05GSUdfSU5QVVRf
WUVBTElOSz1tCkNPTkZJR19JTlBVVF9DTTEwOT1tCkNPTkZJR19JTlBVVF9UV0w0MDMwX1BX
UkJVVFRPTj15CkNPTkZJR19JTlBVVF9UV0w0MDMwX1ZJQlJBPXkKQ09ORklHX0lOUFVUX1RX
TDYwNDBfVklCUkE9eQpDT05GSUdfSU5QVVRfVUlOUFVUPXkKQ09ORklHX0lOUFVUX1BDRjg1
NzQ9bQpDT05GSUdfSU5QVVRfR1BJT19ST1RBUllfRU5DT0RFUj1tCkNPTkZJR19JTlBVVF9B
RFhMMzRYPW0KQ09ORklHX0lOUFVUX0FEWEwzNFhfSTJDPW0KQ09ORklHX0lOUFVUX0FEWEwz
NFhfU1BJPW0KQ09ORklHX0lOUFVUX0NNQTMwMDA9bQpDT05GSUdfSU5QVVRfQ01BMzAwMF9J
MkM9bQoKIwojIEhhcmR3YXJlIEkvTyBwb3J0cwojCkNPTkZJR19TRVJJTz15CkNPTkZJR19T
RVJJT19TRVJQT1JUPXkKIyBDT05GSUdfU0VSSU9fQU1CQUtNSSBpcyBub3Qgc2V0CkNPTkZJ
R19TRVJJT19MSUJQUzI9eQojIENPTkZJR19TRVJJT19SQVcgaXMgbm90IHNldAojIENPTkZJ
R19TRVJJT19BTFRFUkFfUFMyIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VSSU9fUFMyTVVMVCBp
cyBub3Qgc2V0CkNPTkZJR19HQU1FUE9SVD1tCiMgQ09ORklHX0dBTUVQT1JUX05TNTU4IGlz
IG5vdCBzZXQKIyBDT05GSUdfR0FNRVBPUlRfTDQgaXMgbm90IHNldAoKIwojIENoYXJhY3Rl
ciBkZXZpY2VzCiMKQ09ORklHX1ZUPXkKQ09ORklHX0NPTlNPTEVfVFJBTlNMQVRJT05TPXkK
Q09ORklHX1ZUX0NPTlNPTEU9eQpDT05GSUdfSFdfQ09OU09MRT15CkNPTkZJR19WVF9IV19D
T05TT0xFX0JJTkRJTkc9eQpDT05GSUdfVU5JWDk4X1BUWVM9eQojIENPTkZJR19ERVZQVFNf
TVVMVElQTEVfSU5TVEFOQ0VTIGlzIG5vdCBzZXQKIyBDT05GSUdfTEVHQUNZX1BUWVMgaXMg
bm90IHNldAojIENPTkZJR19TRVJJQUxfTk9OU1RBTkRBUkQgaXMgbm90IHNldAojIENPTkZJ
R19OX0dTTSBpcyBub3Qgc2V0CiMgQ09ORklHX1RSQUNFX1NJTksgaXMgbm90IHNldApDT05G
SUdfREVWS01FTT15CgojCiMgU2VyaWFsIGRyaXZlcnMKIwpDT05GSUdfU0VSSUFMXzgyNTA9
eQpDT05GSUdfU0VSSUFMXzgyNTBfQ09OU09MRT15CkNPTkZJR19TRVJJQUxfODI1MF9OUl9V
QVJUUz0zMgpDT05GSUdfU0VSSUFMXzgyNTBfUlVOVElNRV9VQVJUUz00CkNPTkZJR19TRVJJ
QUxfODI1MF9FWFRFTkRFRD15CkNPTkZJR19TRVJJQUxfODI1MF9NQU5ZX1BPUlRTPXkKQ09O
RklHX1NFUklBTF84MjUwX1NIQVJFX0lSUT15CkNPTkZJR19TRVJJQUxfODI1MF9ERVRFQ1Rf
SVJRPXkKQ09ORklHX1NFUklBTF84MjUwX1JTQT15CgojCiMgTm9uLTgyNTAgc2VyaWFsIHBv
cnQgc3VwcG9ydAojCiMgQ09ORklHX1NFUklBTF9BTUJBX1BMMDEwIGlzIG5vdCBzZXQKIyBD
T05GSUdfU0VSSUFMX0FNQkFfUEwwMTEgaXMgbm90IHNldAojIENPTkZJR19TRVJJQUxfTUFY
MzEwMCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFUklBTF9NQVgzMTA3IGlzIG5vdCBzZXQKQ09O
RklHX1NFUklBTF9DT1JFPXkKQ09ORklHX1NFUklBTF9DT1JFX0NPTlNPTEU9eQpDT05GSUdf
Q09OU09MRV9QT0xMPXkKIyBDT05GSUdfU0VSSUFMX09GX1BMQVRGT1JNIGlzIG5vdCBzZXQK
Q09ORklHX1NFUklBTF9PTUFQPXkKQ09ORklHX1NFUklBTF9PTUFQX0NPTlNPTEU9eQojIENP
TkZJR19TRVJJQUxfVElNQkVSREFMRSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFUklBTF9BTFRF
UkFfSlRBR1VBUlQgaXMgbm90IHNldAojIENPTkZJR19TRVJJQUxfQUxURVJBX1VBUlQgaXMg
bm90IHNldAojIENPTkZJR19TRVJJQUxfSUZYNlg2MCBpcyBub3Qgc2V0CiMgQ09ORklHX1NF
UklBTF9YSUxJTlhfUFNfVUFSVCBpcyBub3Qgc2V0CiMgQ09ORklHX1RUWV9QUklOVEsgaXMg
bm90IHNldAojIENPTkZJR19IVkNfRENDIGlzIG5vdCBzZXQKIyBDT05GSUdfSVBNSV9IQU5E
TEVSIGlzIG5vdCBzZXQKQ09ORklHX0hXX1JBTkRPTT15CiMgQ09ORklHX0hXX1JBTkRPTV9U
SU1FUklPTUVNIGlzIG5vdCBzZXQKIyBDT05GSUdfUjM5NjQgaXMgbm90IHNldAojIENPTkZJ
R19SQVdfRFJJVkVSIGlzIG5vdCBzZXQKIyBDT05GSUdfVENHX1RQTSBpcyBub3Qgc2V0CiMg
Q09ORklHX1JBTU9PUFMgaXMgbm90IHNldApDT05GSUdfSTJDPXkKQ09ORklHX0kyQ19CT0FS
RElORk89eQpDT05GSUdfSTJDX0NPTVBBVD15CkNPTkZJR19JMkNfQ0hBUkRFVj15CiMgQ09O
RklHX0kyQ19NVVggaXMgbm90IHNldApDT05GSUdfSTJDX0hFTFBFUl9BVVRPPXkKQ09ORklH
X0kyQ19TTUJVUz1tCkNPTkZJR19JMkNfQUxHT0JJVD1tCkNPTkZJR19JMkNfQUxHT1BDQT1t
CgojCiMgSTJDIEhhcmR3YXJlIEJ1cyBzdXBwb3J0CiMKCiMKIyBJMkMgc3lzdGVtIGJ1cyBk
cml2ZXJzIChtb3N0bHkgZW1iZWRkZWQgLyBzeXN0ZW0tb24tY2hpcCkKIwojIENPTkZJR19J
MkNfREVTSUdOV0FSRSBpcyBub3Qgc2V0CiMgQ09ORklHX0kyQ19HUElPIGlzIG5vdCBzZXQK
IyBDT05GSUdfSTJDX09DT1JFUyBpcyBub3Qgc2V0CkNPTkZJR19JMkNfT01BUD15CkNPTkZJ
R19JMkNfUENBX1BMQVRGT1JNPW0KIyBDT05GSUdfSTJDX1BYQV9QQ0kgaXMgbm90IHNldAoj
IENPTkZJR19JMkNfU0lNVEVDIGlzIG5vdCBzZXQKIyBDT05GSUdfSTJDX1hJTElOWCBpcyBu
b3Qgc2V0CgojCiMgRXh0ZXJuYWwgSTJDL1NNQnVzIGFkYXB0ZXIgZHJpdmVycwojCkNPTkZJ
R19JMkNfRElPTEFOX1UyQz1tCkNPTkZJR19JMkNfUEFSUE9SVF9MSUdIVD1tCkNPTkZJR19J
MkNfVEFPU19FVk09bQpDT05GSUdfSTJDX1RJTllfVVNCPW0KCiMKIyBPdGhlciBJMkMvU01C
dXMgYnVzIGRyaXZlcnMKIwpDT05GSUdfSTJDX1NUVUI9bQojIENPTkZJR19JMkNfREVCVUdf
Q09SRSBpcyBub3Qgc2V0CiMgQ09ORklHX0kyQ19ERUJVR19BTEdPIGlzIG5vdCBzZXQKIyBD
T05GSUdfSTJDX0RFQlVHX0JVUyBpcyBub3Qgc2V0CkNPTkZJR19TUEk9eQojIENPTkZJR19T
UElfREVCVUcgaXMgbm90IHNldApDT05GSUdfU1BJX01BU1RFUj15CgojCiMgU1BJIE1hc3Rl
ciBDb250cm9sbGVyIERyaXZlcnMKIwojIENPTkZJR19TUElfQUxURVJBIGlzIG5vdCBzZXQK
IyBDT05GSUdfU1BJX0JJVEJBTkcgaXMgbm90IHNldAojIENPTkZJR19TUElfR1BJTyBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NQSV9PQ19USU5ZIGlzIG5vdCBzZXQKQ09ORklHX1NQSV9PTUFQ
MjRYWD15CiMgQ09ORklHX1NQSV9QTDAyMiBpcyBub3Qgc2V0CiMgQ09ORklHX1NQSV9QWEEy
WFhfUENJIGlzIG5vdCBzZXQKIyBDT05GSUdfU1BJX1hJTElOWCBpcyBub3Qgc2V0CiMgQ09O
RklHX1NQSV9ERVNJR05XQVJFIGlzIG5vdCBzZXQKCiMKIyBTUEkgUHJvdG9jb2wgTWFzdGVy
cwojCkNPTkZJR19TUElfU1BJREVWPXkKIyBDT05GSUdfU1BJX1RMRTYyWDAgaXMgbm90IHNl
dAoKIwojIFBQUyBzdXBwb3J0CiMKIyBDT05GSUdfUFBTIGlzIG5vdCBzZXQKCiMKIyBQUFMg
Z2VuZXJhdG9ycyBzdXBwb3J0CiMKCiMKIyBQVFAgY2xvY2sgc3VwcG9ydAojCgojCiMgRW5h
YmxlIERldmljZSBEcml2ZXJzIC0+IFBQUyB0byBzZWUgdGhlIFBUUCBjbG9jayBvcHRpb25z
LgojCkNPTkZJR19BUkNIX1JFUVVJUkVfR1BJT0xJQj15CkNPTkZJR19HUElPTElCPXkKQ09O
RklHX0RFQlVHX0dQSU89eQpDT05GSUdfR1BJT19TWVNGUz15CgojCiMgTWVtb3J5IG1hcHBl
ZCBHUElPIGRyaXZlcnM6CiMKIyBDT05GSUdfR1BJT19HRU5FUklDX1BMQVRGT1JNIGlzIG5v
dCBzZXQKIyBDT05GSUdfR1BJT19JVDg3NjFFIGlzIG5vdCBzZXQKIyBDT05GSUdfR1BJT19Q
TDA2MSBpcyBub3Qgc2V0CgojCiMgSTJDIEdQSU8gZXhwYW5kZXJzOgojCiMgQ09ORklHX0dQ
SU9fTUFYNzMwMCBpcyBub3Qgc2V0CiMgQ09ORklHX0dQSU9fTUFYNzMyWCBpcyBub3Qgc2V0
CiMgQ09ORklHX0dQSU9fUENGODU3WCBpcyBub3Qgc2V0CiMgQ09ORklHX0dQSU9fU1gxNTBY
IGlzIG5vdCBzZXQKQ09ORklHX0dQSU9fVFdMNDAzMD15CiMgQ09ORklHX0dQSU9fQURQNTU4
OCBpcyBub3Qgc2V0CgojCiMgUENJIEdQSU8gZXhwYW5kZXJzOgojCgojCiMgU1BJIEdQSU8g
ZXhwYW5kZXJzOgojCiMgQ09ORklHX0dQSU9fTUFYNzMwMSBpcyBub3Qgc2V0CiMgQ09ORklH
X0dQSU9fTUNQMjNTMDggaXMgbm90IHNldAojIENPTkZJR19HUElPX01DMzM4ODAgaXMgbm90
IHNldAojIENPTkZJR19HUElPXzc0WDE2NCBpcyBub3Qgc2V0CgojCiMgQUM5NyBHUElPIGV4
cGFuZGVyczoKIwoKIwojIE1PRFVMYnVzIEdQSU8gZXhwYW5kZXJzOgojCkNPTkZJR19XMT15
CkNPTkZJR19XMV9DT049eQoKIwojIDEtd2lyZSBCdXMgTWFzdGVycwojCiMgQ09ORklHX1cx
X01BU1RFUl9EUzI0OTAgaXMgbm90IHNldAojIENPTkZJR19XMV9NQVNURVJfRFMyNDgyIGlz
IG5vdCBzZXQKIyBDT05GSUdfVzFfTUFTVEVSX0RTMVdNIGlzIG5vdCBzZXQKIyBDT05GSUdf
VzFfTUFTVEVSX0dQSU8gaXMgbm90IHNldAojIENPTkZJR19IRFFfTUFTVEVSX09NQVAgaXMg
bm90IHNldAoKIwojIDEtd2lyZSBTbGF2ZXMKIwojIENPTkZJR19XMV9TTEFWRV9USEVSTSBp
cyBub3Qgc2V0CiMgQ09ORklHX1cxX1NMQVZFX1NNRU0gaXMgbm90IHNldAojIENPTkZJR19X
MV9TTEFWRV9EUzI0MDggaXMgbm90IHNldAojIENPTkZJR19XMV9TTEFWRV9EUzI0MjMgaXMg
bm90IHNldAojIENPTkZJR19XMV9TTEFWRV9EUzI0MzEgaXMgbm90IHNldAojIENPTkZJR19X
MV9TTEFWRV9EUzI0MzMgaXMgbm90IHNldAojIENPTkZJR19XMV9TTEFWRV9EUzI3NjAgaXMg
bm90IHNldAojIENPTkZJR19XMV9TTEFWRV9EUzI3ODAgaXMgbm90IHNldAojIENPTkZJR19X
MV9TTEFWRV9CUTI3MDAwIGlzIG5vdCBzZXQKQ09ORklHX1BPV0VSX1NVUFBMWT15CiMgQ09O
RklHX1BPV0VSX1NVUFBMWV9ERUJVRyBpcyBub3Qgc2V0CiMgQ09ORklHX1BEQV9QT1dFUiBp
cyBub3Qgc2V0CiMgQ09ORklHX1RFU1RfUE9XRVIgaXMgbm90IHNldAojIENPTkZJR19CQVRU
RVJZX0RTMjc4MCBpcyBub3Qgc2V0CiMgQ09ORklHX0JBVFRFUllfRFMyNzgyIGlzIG5vdCBz
ZXQKIyBDT05GSUdfQkFUVEVSWV9CUTIwWjc1IGlzIG5vdCBzZXQKIyBDT05GSUdfQkFUVEVS
WV9CUTI3eDAwIGlzIG5vdCBzZXQKIyBDT05GSUdfQkFUVEVSWV9NQVgxNzA0MCBpcyBub3Qg
c2V0CiMgQ09ORklHX0JBVFRFUllfTUFYMTcwNDIgaXMgbm90IHNldAojIENPTkZJR19DSEFS
R0VSX0lTUDE3MDQgaXMgbm90IHNldAojIENPTkZJR19DSEFSR0VSX01BWDg5MDMgaXMgbm90
IHNldAojIENPTkZJR19DSEFSR0VSX1RXTDQwMzAgaXMgbm90IHNldAojIENPTkZJR19DSEFS
R0VSX0dQSU8gaXMgbm90IHNldApDT05GSUdfSFdNT049eQojIENPTkZJR19IV01PTl9WSUQg
aXMgbm90IHNldAojIENPTkZJR19IV01PTl9ERUJVR19DSElQIGlzIG5vdCBzZXQKCiMKIyBO
YXRpdmUgZHJpdmVycwojCiMgQ09ORklHX1NFTlNPUlNfQUQ3NDE0IGlzIG5vdCBzZXQKIyBD
T05GSUdfU0VOU09SU19BRDc0MTggaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0FEQ1hY
IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19BRE0xMDIxIGlzIG5vdCBzZXQKIyBDT05G
SUdfU0VOU09SU19BRE0xMDI1IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19BRE0xMDI2
IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19BRE0xMDI5IGlzIG5vdCBzZXQKIyBDT05G
SUdfU0VOU09SU19BRE0xMDMxIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19BRE05MjQw
IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19BRFQ3NDExIGlzIG5vdCBzZXQKIyBDT05G
SUdfU0VOU09SU19BRFQ3NDYyIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19BRFQ3NDcw
IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19BRFQ3NDc1IGlzIG5vdCBzZXQKIyBDT05G
SUdfU0VOU09SU19BU0M3NjIxIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19BVFhQMSBp
cyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfRFM2MjAgaXMgbm90IHNldAojIENPTkZJR19T
RU5TT1JTX0RTMTYyMSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfRjcxODA1RiBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfRjcxODgyRkcgaXMgbm90IHNldAojIENPTkZJR19T
RU5TT1JTX0Y3NTM3NVMgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0c3NjBBIGlzIG5v
dCBzZXQKIyBDT05GSUdfU0VOU09SU19HTDUxOFNNIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VO
U09SU19HTDUyMFNNIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19HUElPX0ZBTiBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfSVQ4NyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNP
UlNfSkM0MiBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTElORUFHRSBpcyBub3Qgc2V0
CiMgQ09ORklHX1NFTlNPUlNfTE02MyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTE03
MCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTE03MyBpcyBub3Qgc2V0CiMgQ09ORklH
X1NFTlNPUlNfTE03NSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTE03NyBpcyBub3Qg
c2V0CiMgQ09ORklHX1NFTlNPUlNfTE03OCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNf
TE04MCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTE04MyBpcyBub3Qgc2V0CiMgQ09O
RklHX1NFTlNPUlNfTE04NSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTE04NyBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTE05MCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNP
UlNfTE05MiBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTE05MyBpcyBub3Qgc2V0CiMg
Q09ORklHX1NFTlNPUlNfTFRDNDE1MSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTFRD
NDIxNSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTFRDNDI0NSBpcyBub3Qgc2V0CiMg
Q09ORklHX1NFTlNPUlNfTFRDNDI2MSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTE05
NTI0MSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTE05NTI0NSBpcyBub3Qgc2V0CiMg
Q09ORklHX1NFTlNPUlNfTUFYMTExMSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTUFY
MTYwNjUgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX01BWDE2MTkgaXMgbm90IHNldAoj
IENPTkZJR19TRU5TT1JTX01BWDE2NjggaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX01B
WDY2MzkgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX01BWDY2NDIgaXMgbm90IHNldAoj
IENPTkZJR19TRU5TT1JTX01BWDY2NTAgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX05U
Q19USEVSTUlTVE9SIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19QQzg3MzYwIGlzIG5v
dCBzZXQKIyBDT05GSUdfU0VOU09SU19QQzg3NDI3IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VO
U09SU19QQ0Y4NTkxIGlzIG5vdCBzZXQKIyBDT05GSUdfUE1CVVMgaXMgbm90IHNldAojIENP
TkZJR19TRU5TT1JTX1NIVDE1IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19TSFQyMSBp
cyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfU01NNjY1IGlzIG5vdCBzZXQKIyBDT05GSUdf
U0VOU09SU19ETUUxNzM3IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19FTUMxNDAzIGlz
IG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19FTUMyMTAzIGlzIG5vdCBzZXQKIyBDT05GSUdf
U0VOU09SU19FTUM2VzIwMSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfU01TQzQ3TTEg
aXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX1NNU0M0N00xOTIgaXMgbm90IHNldAojIENP
TkZJR19TRU5TT1JTX1NNU0M0N0IzOTcgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX1ND
SDU2WFhfQ09NTU9OIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19TQ0g1NjI3IGlzIG5v
dCBzZXQKIyBDT05GSUdfU0VOU09SU19TQ0g1NjM2IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VO
U09SU19BRFMxMDE1IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19BRFM3ODI4IGlzIG5v
dCBzZXQKIyBDT05GSUdfU0VOU09SU19BRFM3ODcxIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VO
U09SU19BTUM2ODIxIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19USE1DNTAgaXMgbm90
IHNldAojIENPTkZJR19TRU5TT1JTX1RNUDEwMiBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNP
UlNfVE1QNDAxIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19UTVA0MjEgaXMgbm90IHNl
dApDT05GSUdfU0VOU09SU19UV0w0MDMwX01BREM9bQojIENPTkZJR19TRU5TT1JTX1ZUMTIx
MSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfVzgzNzgxRCBpcyBub3Qgc2V0CiMgQ09O
RklHX1NFTlNPUlNfVzgzNzkxRCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfVzgzNzky
RCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfVzgzNzkzIGlzIG5vdCBzZXQKIyBDT05G
SUdfU0VOU09SU19XODM3OTUgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX1c4M0w3ODVU
UyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfVzgzTDc4Nk5HIGlzIG5vdCBzZXQKIyBD
T05GSUdfU0VOU09SU19XODM2MjdIRiBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfVzgz
NjI3RUhGIGlzIG5vdCBzZXQKQ09ORklHX1RIRVJNQUw9eQpDT05GSUdfVEhFUk1BTF9IV01P
Tj15CkNPTkZJR19XQVRDSERPRz15CkNPTkZJR19XQVRDSERPR19DT1JFPXkKQ09ORklHX1dB
VENIRE9HX05PV0FZT1VUPXkKCiMKIyBXYXRjaGRvZyBEZXZpY2UgRHJpdmVycwojCiMgQ09O
RklHX1NPRlRfV0FUQ0hET0cgaXMgbm90IHNldAojIENPTkZJR19BUk1fU1A4MDVfV0FUQ0hE
T0cgaXMgbm90IHNldAojIENPTkZJR19EV19XQVRDSERPRyBpcyBub3Qgc2V0CiMgQ09ORklH
X01QQ09SRV9XQVRDSERPRyBpcyBub3Qgc2V0CkNPTkZJR19PTUFQX1dBVENIRE9HPXkKQ09O
RklHX1RXTDQwMzBfV0FUQ0hET0c9eQojIENPTkZJR19NQVg2M1hYX1dBVENIRE9HIGlzIG5v
dCBzZXQKCiMKIyBVU0ItYmFzZWQgV2F0Y2hkb2cgQ2FyZHMKIwpDT05GSUdfVVNCUENXQVRD
SERPRz1tCkNPTkZJR19TU0JfUE9TU0lCTEU9eQoKIwojIFNvbmljcyBTaWxpY29uIEJhY2tw
bGFuZQojCkNPTkZJR19TU0I9bQpDT05GSUdfU1NCX0JMT0NLSU89eQpDT05GSUdfU1NCX1NE
SU9IT1NUX1BPU1NJQkxFPXkKIyBDT05GSUdfU1NCX1NESU9IT1NUIGlzIG5vdCBzZXQKIyBD
T05GSUdfU1NCX1NJTEVOVCBpcyBub3Qgc2V0CiMgQ09ORklHX1NTQl9ERUJVRyBpcyBub3Qg
c2V0CkNPTkZJR19CQ01BX1BPU1NJQkxFPXkKCiMKIyBCcm9hZGNvbSBzcGVjaWZpYyBBTUJB
CiMKIyBDT05GSUdfQkNNQSBpcyBub3Qgc2V0CkNPTkZJR19NRkRfU1VQUE9SVD15CkNPTkZJ
R19NRkRfQ09SRT15CiMgQ09ORklHX01GRF84OFBNODYwWCBpcyBub3Qgc2V0CiMgQ09ORklH
X01GRF9TTTUwMSBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9BU0lDMyBpcyBub3Qgc2V0CiMg
Q09ORklHX0hUQ19FR1BJTyBpcyBub3Qgc2V0CiMgQ09ORklHX0hUQ19QQVNJQzMgaXMgbm90
IHNldAojIENPTkZJR19IVENfSTJDUExEIGlzIG5vdCBzZXQKIyBDT05GSUdfVFBTNjEwNVgg
aXMgbm90IHNldAojIENPTkZJR19UUFM2NTAxMCBpcyBub3Qgc2V0CiMgQ09ORklHX1RQUzY1
MDdYIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX1RQUzY1ODZYIGlzIG5vdCBzZXQKIyBDT05G
SUdfTUZEX1RQUzY1OTEwIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX1RQUzY1OTEyX0kyQyBp
cyBub3Qgc2V0CiMgQ09ORklHX01GRF9UUFM2NTkxMl9TUEkgaXMgbm90IHNldApDT05GSUdf
VFdMNDAzMF9DT1JFPXkKQ09ORklHX1RXTDQwMzBfTUFEQz15CkNPTkZJR19UV0w0MDMwX1BP
V0VSPXkKQ09ORklHX01GRF9UV0w0MDMwX0FVRElPPXkKIyBDT05GSUdfVFdMNjAzMF9QV00g
aXMgbm90IHNldApDT05GSUdfVFdMNjA0MF9DT1JFPXkKIyBDT05GSUdfTUZEX1NUTVBFIGlz
IG5vdCBzZXQKIyBDT05GSUdfTUZEX1RDMzU4OVggaXMgbm90IHNldAojIENPTkZJR19NRkRf
VE1JTyBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9UN0w2NlhCIGlzIG5vdCBzZXQKIyBDT05G
SUdfTUZEX1RDNjM4N1hCIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX1RDNjM5M1hCIGlzIG5v
dCBzZXQKIyBDT05GSUdfUE1JQ19EQTkwM1ggaXMgbm90IHNldAojIENPTkZJR19QTUlDX0FE
UDU1MjAgaXMgbm90IHNldAojIENPTkZJR19NRkRfTUFYODkyNSBpcyBub3Qgc2V0CiMgQ09O
RklHX01GRF9NQVg4OTk3IGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX01BWDg5OTggaXMgbm90
IHNldAojIENPTkZJR19NRkRfV004NDAwIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX1dNODMx
WF9JMkMgaXMgbm90IHNldAojIENPTkZJR19NRkRfV004MzFYX1NQSSBpcyBub3Qgc2V0CiMg
Q09ORklHX01GRF9XTTgzNTBfSTJDIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX1dNODk5NCBp
cyBub3Qgc2V0CiMgQ09ORklHX01GRF9QQ0Y1MDYzMyBpcyBub3Qgc2V0CiMgQ09ORklHX01G
RF9NQzEzWFhYIGlzIG5vdCBzZXQKIyBDT05GSUdfQUJYNTAwX0NPUkUgaXMgbm90IHNldAoj
IENPTkZJR19FWlhfUENBUCBpcyBub3Qgc2V0CkNPTkZJR19NRkRfV0wxMjczX0NPUkU9bQpD
T05GSUdfTUZEX09NQVBfVVNCX0hPU1Q9eQojIENPTkZJR19NRkRfQUFUMjg3MF9DT1JFIGlz
IG5vdCBzZXQKQ09ORklHX1JFR1VMQVRPUj15CiMgQ09ORklHX1JFR1VMQVRPUl9ERUJVRyBp
cyBub3Qgc2V0CkNPTkZJR19SRUdVTEFUT1JfRFVNTVk9eQpDT05GSUdfUkVHVUxBVE9SX0ZJ
WEVEX1ZPTFRBR0U9eQpDT05GSUdfUkVHVUxBVE9SX1ZJUlRVQUxfQ09OU1VNRVI9eQpDT05G
SUdfUkVHVUxBVE9SX1VTRVJTUEFDRV9DT05TVU1FUj15CiMgQ09ORklHX1JFR1VMQVRPUl9C
UTI0MDIyIGlzIG5vdCBzZXQKIyBDT05GSUdfUkVHVUxBVE9SX01BWDE1ODYgaXMgbm90IHNl
dAojIENPTkZJR19SRUdVTEFUT1JfTUFYODY0OSBpcyBub3Qgc2V0CiMgQ09ORklHX1JFR1VM
QVRPUl9NQVg4NjYwIGlzIG5vdCBzZXQKIyBDT05GSUdfUkVHVUxBVE9SX01BWDg5NTIgaXMg
bm90IHNldApDT05GSUdfUkVHVUxBVE9SX1RXTDQwMzA9eQojIENPTkZJR19SRUdVTEFUT1Jf
TFAzOTcxIGlzIG5vdCBzZXQKIyBDT05GSUdfUkVHVUxBVE9SX0xQMzk3MiBpcyBub3Qgc2V0
CkNPTkZJR19SRUdVTEFUT1JfVFBTNjUwMjM9eQpDT05GSUdfUkVHVUxBVE9SX1RQUzY1MDdY
PXkKIyBDT05GSUdfUkVHVUxBVE9SX0lTTDYyNzFBIGlzIG5vdCBzZXQKIyBDT05GSUdfUkVH
VUxBVE9SX0FENTM5OCBpcyBub3Qgc2V0CiMgQ09ORklHX1JFR1VMQVRPUl9UUFM2NTI0WCBp
cyBub3Qgc2V0CkNPTkZJR19NRURJQV9TVVBQT1JUPXkKCiMKIyBNdWx0aW1lZGlhIGNvcmUg
c3VwcG9ydAojCkNPTkZJR19NRURJQV9DT05UUk9MTEVSPXkKQ09ORklHX1ZJREVPX0RFVj1t
CkNPTkZJR19WSURFT19WNEwyX0NPTU1PTj1tCiMgQ09ORklHX1ZJREVPX1Y0TDJfU1VCREVW
X0FQSSBpcyBub3Qgc2V0CkNPTkZJR19EVkJfQ09SRT1tCkNPTkZJR19EVkJfTkVUPXkKQ09O
RklHX1ZJREVPX01FRElBPW0KCiMKIyBNdWx0aW1lZGlhIGRyaXZlcnMKIwpDT05GSUdfUkNf
Q09SRT15CkNPTkZJR19MSVJDPXkKQ09ORklHX1JDX01BUD1tCkNPTkZJR19JUl9ORUNfREVD
T0RFUj1tCkNPTkZJR19JUl9SQzVfREVDT0RFUj1tCkNPTkZJR19JUl9SQzZfREVDT0RFUj1t
CkNPTkZJR19JUl9KVkNfREVDT0RFUj1tCkNPTkZJR19JUl9TT05ZX0RFQ09ERVI9bQpDT05G
SUdfSVJfUkM1X1NaX0RFQ09ERVI9bQpDT05GSUdfSVJfTUNFX0tCRF9ERUNPREVSPW0KQ09O
RklHX0lSX0xJUkNfQ09ERUM9bQpDT05GSUdfSVJfSU1PTj1tCkNPTkZJR19JUl9NQ0VVU0I9
bQpDT05GSUdfSVJfUkVEUkFUMz1tCkNPTkZJR19JUl9TVFJFQU1aQVA9bQojIENPTkZJR19S
Q19MT09QQkFDSyBpcyBub3Qgc2V0CkNPTkZJR19NRURJQV9BVFRBQ0g9eQpDT05GSUdfTUVE
SUFfVFVORVI9bQpDT05GSUdfTUVESUFfVFVORVJfQ1VTVE9NSVNFPXkKCiMKIyBDdXN0b21p
emUgVFYgdHVuZXJzCiMKQ09ORklHX01FRElBX1RVTkVSX1NJTVBMRT1tCkNPTkZJR19NRURJ
QV9UVU5FUl9UREE4MjkwPW0KQ09ORklHX01FRElBX1RVTkVSX1REQTgyN1g9bQpDT05GSUdf
TUVESUFfVFVORVJfVERBMTgyNzE9bQpDT05GSUdfTUVESUFfVFVORVJfVERBOTg4Nz1tCkNP
TkZJR19NRURJQV9UVU5FUl9URUE1NzYxPW0KQ09ORklHX01FRElBX1RVTkVSX1RFQTU3Njc9
bQpDT05GSUdfTUVESUFfVFVORVJfTVQyMFhYPW0KQ09ORklHX01FRElBX1RVTkVSX01UMjA2
MD1tCkNPTkZJR19NRURJQV9UVU5FUl9NVDIyNjY9bQpDT05GSUdfTUVESUFfVFVORVJfTVQy
MTMxPW0KQ09ORklHX01FRElBX1RVTkVSX1FUMTAxMD1tCkNPTkZJR19NRURJQV9UVU5FUl9Y
QzIwMjg9bQpDT05GSUdfTUVESUFfVFVORVJfWEM1MDAwPW0KQ09ORklHX01FRElBX1RVTkVS
X1hDNDAwMD1tCkNPTkZJR19NRURJQV9UVU5FUl9NWEw1MDA1Uz1tCkNPTkZJR19NRURJQV9U
VU5FUl9NWEw1MDA3VD1tCkNPTkZJR19NRURJQV9UVU5FUl9NQzQ0UzgwMz1tCkNPTkZJR19N
RURJQV9UVU5FUl9NQVgyMTY1PW0KQ09ORklHX01FRElBX1RVTkVSX1REQTE4MjE4PW0KQ09O
RklHX01FRElBX1RVTkVSX1REQTE4MjEyPW0KQ09ORklHX1ZJREVPX1Y0TDI9bQpDT05GSUdf
VklERU9CVUZfR0VOPW0KQ09ORklHX1ZJREVPQlVGX1ZNQUxMT0M9bQpDT05GSUdfVklERU9C
VUZfRE1BX0NPTlRJRz1tCkNPTkZJR19WSURFT0JVRl9EVkI9bQpDT05GSUdfVklERU9fVFZF
RVBST009bQpDT05GSUdfVklERU9fVFVORVI9bQpDT05GSUdfVjRMMl9NRU0yTUVNX0RFVj1t
CkNPTkZJR19WSURFT0JVRjJfQ09SRT1tCkNPTkZJR19WSURFT0JVRjJfTUVNT1BTPW0KQ09O
RklHX1ZJREVPQlVGMl9WTUFMTE9DPW0KQ09ORklHX1ZJREVPX0NBUFRVUkVfRFJJVkVSUz15
CiMgQ09ORklHX1ZJREVPX0FEVl9ERUJVRyBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJREVPX0ZJ
WEVEX01JTk9SX1JBTkdFUyBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJREVPX0hFTFBFUl9DSElQ
U19BVVRPIGlzIG5vdCBzZXQKQ09ORklHX1ZJREVPX0lSX0kyQz1tCgojCiMgRW5jb2RlcnMs
IGRlY29kZXJzLCBzZW5zb3JzIGFuZCBvdGhlciBoZWxwZXIgY2hpcHMKIwoKIwojIEF1ZGlv
IGRlY29kZXJzLCBwcm9jZXNzb3JzIGFuZCBtaXhlcnMKIwojIENPTkZJR19WSURFT19UVkFV
RElPIGlzIG5vdCBzZXQKIyBDT05GSUdfVklERU9fVERBNzQzMiBpcyBub3Qgc2V0CiMgQ09O
RklHX1ZJREVPX1REQTk4NDAgaXMgbm90IHNldAojIENPTkZJR19WSURFT19URUE2NDE1QyBp
cyBub3Qgc2V0CiMgQ09ORklHX1ZJREVPX1RFQTY0MjAgaXMgbm90IHNldApDT05GSUdfVklE
RU9fTVNQMzQwMD1tCkNPTkZJR19WSURFT19DUzUzNDU9bQpDT05GSUdfVklERU9fQ1M1M0wz
MkE9bQojIENPTkZJR19WSURFT19UTFYzMjBBSUMyM0IgaXMgbm90IHNldApDT05GSUdfVklE
RU9fV004Nzc1PW0KQ09ORklHX1ZJREVPX1dNODczOT1tCkNPTkZJR19WSURFT19WUDI3U01Q
WD1tCgojCiMgUkRTIGRlY29kZXJzCiMKIyBDT05GSUdfVklERU9fU0FBNjU4OCBpcyBub3Qg
c2V0CgojCiMgVmlkZW8gZGVjb2RlcnMKIwpDT05GSUdfVklERU9fQURWNzE4MD1tCiMgQ09O
RklHX1ZJREVPX0JUODE5IGlzIG5vdCBzZXQKIyBDT05GSUdfVklERU9fQlQ4NTYgaXMgbm90
IHNldAojIENPTkZJR19WSURFT19CVDg2NiBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJREVPX0tT
MDEyNyBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJREVPX1NBQTcxMTAgaXMgbm90IHNldApDT05G
SUdfVklERU9fU0FBNzExWD1tCiMgQ09ORklHX1ZJREVPX1NBQTcxOTEgaXMgbm90IHNldAoj
IENPTkZJR19WSURFT19UVlA1MTRYIGlzIG5vdCBzZXQKIyBDT05GSUdfVklERU9fVFZQNTE1
MCBpcyBub3Qgc2V0CkNPTkZJR19WSURFT19UVlA3MDAyPW0KIyBDT05GSUdfVklERU9fVlBY
MzIyMCBpcyBub3Qgc2V0CgojCiMgVmlkZW8gYW5kIGF1ZGlvIGRlY29kZXJzCiMKQ09ORklH
X1ZJREVPX1NBQTcxN1g9bQpDT05GSUdfVklERU9fQ1gyNTg0MD1tCgojCiMgTVBFRyB2aWRl
byBlbmNvZGVycwojCkNPTkZJR19WSURFT19DWDIzNDFYPW0KCiMKIyBWaWRlbyBlbmNvZGVy
cwojCkNPTkZJR19WSURFT19TQUE3MTI3PW0KIyBDT05GSUdfVklERU9fU0FBNzE4NSBpcyBu
b3Qgc2V0CiMgQ09ORklHX1ZJREVPX0FEVjcxNzAgaXMgbm90IHNldAojIENPTkZJR19WSURF
T19BRFY3MTc1IGlzIG5vdCBzZXQKIyBDT05GSUdfVklERU9fQURWNzM0MyBpcyBub3Qgc2V0
CkNPTkZJR19WSURFT19BSzg4MVg9bQoKIwojIENhbWVyYSBzZW5zb3IgZGV2aWNlcwojCkNP
TkZJR19WSURFT19PVjc2NzA9bQpDT05GSUdfVklERU9fTVQ5VjAxMT1tCkNPTkZJR19WSURF
T19UQ004MjVYPW0KCiMKIyBGbGFzaCBkZXZpY2VzCiMKIyBDT05GSUdfVklERU9fQURQMTY1
MyBpcyBub3Qgc2V0CgojCiMgVmlkZW8gaW1wcm92ZW1lbnQgY2hpcHMKIwpDT05GSUdfVklE
RU9fVVBENjQwMzFBPW0KQ09ORklHX1ZJREVPX1VQRDY0MDgzPW0KCiMKIyBNaXNjZWxhbmVv
dXMgaGVscGVyIGNoaXBzCiMKIyBDT05GSUdfVklERU9fVEhTNzMwMyBpcyBub3Qgc2V0CkNP
TkZJR19WSURFT19NNTI3OTA9bQojIENPTkZJR19WSURFT19WSVZJIGlzIG5vdCBzZXQKIyBD
T05GSUdfVklERU9fVlBGRV9DQVBUVVJFIGlzIG5vdCBzZXQKQ09ORklHX1ZJREVPX09NQVAy
X1ZPVVRfVlJGQj15CkNPTkZJR19WSURFT19PTUFQMl9WT1VUPW0KIyBDT05GSUdfVklERU9f
Q1BJQTIgaXMgbm90IHNldAojIENPTkZJR19WSURFT19BVTA4MjggaXMgbm90IHNldAojIENP
TkZJR19WSURFT19TUjAzMFBDMzAgaXMgbm90IHNldAojIENPTkZJR19WSURFT19OT09OMDEw
UEMzMCBpcyBub3Qgc2V0CiMgQ09ORklHX1NPQ19DQU1FUkEgaXMgbm90IHNldApDT05GSUdf
VjRMX1VTQl9EUklWRVJTPXkKQ09ORklHX1VTQl9WSURFT19DTEFTUz1tCkNPTkZJR19VU0Jf
VklERU9fQ0xBU1NfSU5QVVRfRVZERVY9eQpDT05GSUdfVVNCX0dTUENBPW0KQ09ORklHX1VT
Ql9NNTYwMj1tCkNPTkZJR19VU0JfU1RWMDZYWD1tCkNPTkZJR19VU0JfR0w4NjA9bQpDT05G
SUdfVVNCX0dTUENBX0JFTlE9bQpDT05GSUdfVVNCX0dTUENBX0NPTkVYPW0KQ09ORklHX1VT
Ql9HU1BDQV9DUElBMT1tCkNPTkZJR19VU0JfR1NQQ0FfRVRPTVM9bQpDT05GSUdfVVNCX0dT
UENBX0ZJTkVQSVg9bQpDT05GSUdfVVNCX0dTUENBX0pFSUxJTko9bQpDT05GSUdfVVNCX0dT
UENBX0tJTkVDVD1tCkNPTkZJR19VU0JfR1NQQ0FfS09OSUNBPW0KQ09ORklHX1VTQl9HU1BD
QV9NQVJTPW0KQ09ORklHX1VTQl9HU1BDQV9NUjk3MzEwQT1tCkNPTkZJR19VU0JfR1NQQ0Ff
Tlc4MFg9bQpDT05GSUdfVVNCX0dTUENBX09WNTE5PW0KQ09ORklHX1VTQl9HU1BDQV9PVjUz
ND1tCkNPTkZJR19VU0JfR1NQQ0FfT1Y1MzRfOT1tCkNPTkZJR19VU0JfR1NQQ0FfUEFDMjA3
PW0KQ09ORklHX1VTQl9HU1BDQV9QQUM3MzAyPW0KQ09ORklHX1VTQl9HU1BDQV9QQUM3MzEx
PW0KQ09ORklHX1VTQl9HU1BDQV9TRTQwMT1tCkNPTkZJR19VU0JfR1NQQ0FfU045QzIwMjg9
bQpDT05GSUdfVVNCX0dTUENBX1NOOUMyMFg9bQpDT05GSUdfVVNCX0dTUENBX1NPTklYQj1t
CkNPTkZJR19VU0JfR1NQQ0FfU09OSVhKPW0KQ09ORklHX1VTQl9HU1BDQV9TUENBNTAwPW0K
Q09ORklHX1VTQl9HU1BDQV9TUENBNTAxPW0KQ09ORklHX1VTQl9HU1BDQV9TUENBNTA1PW0K
Q09ORklHX1VTQl9HU1BDQV9TUENBNTA2PW0KQ09ORklHX1VTQl9HU1BDQV9TUENBNTA4PW0K
Q09ORklHX1VTQl9HU1BDQV9TUENBNTYxPW0KQ09ORklHX1VTQl9HU1BDQV9TUENBMTUyOD1t
CkNPTkZJR19VU0JfR1NQQ0FfU1E5MDU9bQpDT05GSUdfVVNCX0dTUENBX1NROTA1Qz1tCkNP
TkZJR19VU0JfR1NQQ0FfU1E5MzBYPW0KQ09ORklHX1VTQl9HU1BDQV9TVEswMTQ9bQpDT05G
SUdfVVNCX0dTUENBX1NUVjA2ODA9bQpDT05GSUdfVVNCX0dTUENBX1NVTlBMVVM9bQpDT05G
SUdfVVNCX0dTUENBX1Q2MTM9bQpDT05GSUdfVVNCX0dTUENBX1RWODUzMj1tCkNPTkZJR19V
U0JfR1NQQ0FfVkMwMzJYPW0KQ09ORklHX1VTQl9HU1BDQV9WSUNBTT1tCkNPTkZJR19VU0Jf
R1NQQ0FfWElSTElOS19DSVQ9bQpDT05GSUdfVVNCX0dTUENBX1pDM1hYPW0KQ09ORklHX1ZJ
REVPX1BWUlVTQjI9bQpDT05GSUdfVklERU9fUFZSVVNCMl9TWVNGUz15CkNPTkZJR19WSURF
T19QVlJVU0IyX0RWQj15CiMgQ09ORklHX1ZJREVPX1BWUlVTQjJfREVCVUdJRkMgaXMgbm90
IHNldApDT05GSUdfVklERU9fSERQVlI9bQpDT05GSUdfVklERU9fRU0yOFhYPW0KQ09ORklH
X1ZJREVPX0VNMjhYWF9BTFNBPW0KQ09ORklHX1ZJREVPX0VNMjhYWF9EVkI9bQpDT05GSUdf
VklERU9fRU0yOFhYX1JDPXkKQ09ORklHX1ZJREVPX1RMRzIzMDA9bQpDT05GSUdfVklERU9f
Q1gyMzFYWD1tCkNPTkZJR19WSURFT19DWDIzMVhYX1JDPXkKQ09ORklHX1ZJREVPX0NYMjMx
WFhfQUxTQT1tCkNPTkZJR19WSURFT19DWDIzMVhYX0RWQj1tCkNPTkZJR19WSURFT19VU0JW
SVNJT049bQpDT05GSUdfVVNCX0VUNjFYMjUxPW0KQ09ORklHX1VTQl9TTjlDMTAyPW0KQ09O
RklHX1VTQl9QV0M9bQojIENPTkZJR19VU0JfUFdDX0RFQlVHIGlzIG5vdCBzZXQKQ09ORklH
X1VTQl9QV0NfSU5QVVRfRVZERVY9eQpDT05GSUdfVVNCX1pSMzY0WFg9bQpDT05GSUdfVVNC
X1NUS1dFQkNBTT1tCkNPTkZJR19VU0JfUzIyNTU9bQpDT05GSUdfVjRMX01FTTJNRU1fRFJJ
VkVSUz15CkNPTkZJR19WSURFT19NRU0yTUVNX1RFU1RERVY9bQpDT05GSUdfUkFESU9fQURB
UFRFUlM9eQpDT05GSUdfSTJDX1NJNDcxMz1tCkNPTkZJR19SQURJT19TSTQ3MTM9bQpDT05G
SUdfVVNCX0RTQlI9bQpDT05GSUdfUkFESU9fU0k0NzBYPXkKQ09ORklHX1VTQl9TSTQ3MFg9
bQpDT05GSUdfSTJDX1NJNDcwWD1tCkNPTkZJR19VU0JfTVI4MDA9bQpDT05GSUdfUkFESU9f
VEVBNTc2ND1tCkNPTkZJR19SQURJT19TQUE3NzA2SD1tCkNPTkZJR19SQURJT19URUY2ODYy
PW0KQ09ORklHX1JBRElPX1dMMTI3Mz1tCgojCiMgVGV4YXMgSW5zdHJ1bWVudHMgV0wxMjh4
IEZNIGRyaXZlciAoU1QgYmFzZWQpCiMKQ09ORklHX1JBRElPX1dMMTI4WD1tCkNPTkZJR19E
VkJfTUFYX0FEQVBURVJTPTgKQ09ORklHX0RWQl9EWU5BTUlDX01JTk9SUz15CkNPTkZJR19E
VkJfQ0FQVFVSRV9EUklWRVJTPXkKIyBDT05GSUdfVFRQQ0lfRUVQUk9NIGlzIG5vdCBzZXQK
CiMKIyBTdXBwb3J0ZWQgVVNCIEFkYXB0ZXJzCiMKQ09ORklHX0RWQl9VU0I9bQojIENPTkZJ
R19EVkJfVVNCX0RFQlVHIGlzIG5vdCBzZXQKQ09ORklHX0RWQl9VU0JfQTgwMD1tCkNPTkZJ
R19EVkJfVVNCX0RJQlVTQl9NQj1tCiMgQ09ORklHX0RWQl9VU0JfRElCVVNCX01CX0ZBVUxU
WSBpcyBub3Qgc2V0CkNPTkZJR19EVkJfVVNCX0RJQlVTQl9NQz1tCkNPTkZJR19EVkJfVVNC
X0RJQjA3MDA9bQpDT05GSUdfRFZCX1VTQl9VTVRfMDEwPW0KQ09ORklHX0RWQl9VU0JfQ1hV
U0I9bQpDT05GSUdfRFZCX1VTQl9NOTIwWD1tCkNPTkZJR19EVkJfVVNCX0dMODYxPW0KQ09O
RklHX0RWQl9VU0JfQVU2NjEwPW0KQ09ORklHX0RWQl9VU0JfRElHSVRWPW0KQ09ORklHX0RW
Ql9VU0JfVlA3MDQ1PW0KQ09ORklHX0RWQl9VU0JfVlA3MDJYPW0KQ09ORklHX0RWQl9VU0Jf
R1A4UFNLPW0KQ09ORklHX0RWQl9VU0JfTk9WQV9UX1VTQjI9bQpDT05GSUdfRFZCX1VTQl9U
VFVTQjI9bQpDT05GSUdfRFZCX1VTQl9EVFQyMDBVPW0KQ09ORklHX0RWQl9VU0JfT1BFUkEx
PW0KQ09ORklHX0RWQl9VU0JfQUY5MDA1PW0KQ09ORklHX0RWQl9VU0JfQUY5MDA1X1JFTU9U
RT1tCkNPTkZJR19EVkJfVVNCX0RXMjEwMj1tCkNPTkZJR19EVkJfVVNCX0NJTkVSR1lfVDI9
bQpDT05GSUdfRFZCX1VTQl9BTllTRUU9bQpDT05GSUdfRFZCX1VTQl9EVFY1MTAwPW0KQ09O
RklHX0RWQl9VU0JfQUY5MDE1PW0KQ09ORklHX0RWQl9VU0JfQ0U2MjMwPW0KQ09ORklHX0RW
Ql9VU0JfRlJJSU89bQpDT05GSUdfRFZCX1VTQl9FQzE2OD1tCkNPTkZJR19EVkJfVVNCX0Fa
NjAyNz1tCkNPTkZJR19EVkJfVVNCX0xNRTI1MTA9bQpDT05GSUdfRFZCX1VTQl9URUNITklT
QVRfVVNCMj1tCkNPTkZJR19TTVNfU0lBTk9fTURUVj1tCgojCiMgU2lhbm8gbW9kdWxlIGNv
bXBvbmVudHMKIwpDT05GSUdfU01TX1VTQl9EUlY9bQojIENPTkZJR19TTVNfU0RJT19EUlYg
aXMgbm90IHNldAoKIwojIFN1cHBvcnRlZCBGbGV4Q29wSUkgKEIyQzIpIEFkYXB0ZXJzCiMK
Q09ORklHX0RWQl9CMkMyX0ZMRVhDT1A9bQpDT05GSUdfRFZCX0IyQzJfRkxFWENPUF9VU0I9
bQojIENPTkZJR19EVkJfQjJDMl9GTEVYQ09QX0RFQlVHIGlzIG5vdCBzZXQKCiMKIyBTdXBw
b3J0ZWQgRFZCIEZyb250ZW5kcwojCkNPTkZJR19EVkJfRkVfQ1VTVE9NSVNFPXkKCiMKIyBD
dXN0b21pc2UgRFZCIEZyb250ZW5kcwojCgojCiMgTXVsdGlzdGFuZGFyZCAoc2F0ZWxsaXRl
KSBmcm9udGVuZHMKIwpDT05GSUdfRFZCX1NUQjA4OTk9bQpDT05GSUdfRFZCX1NUQjYxMDA9
bQpDT05GSUdfRFZCX1NUVjA5MHg9bQpDT05GSUdfRFZCX1NUVjYxMTB4PW0KCiMKIyBNdWx0
aXN0YW5kYXJkIChjYWJsZSArIHRlcnJlc3RyaWFsKSBmcm9udGVuZHMKIwpDT05GSUdfRFZC
X0RSWEs9bQpDT05GSUdfRFZCX1REQTE4MjcxQzJERD1tCgojCiMgRFZCLVMgKHNhdGVsbGl0
ZSkgZnJvbnRlbmRzCiMKQ09ORklHX0RWQl9DWDI0MTEwPW0KQ09ORklHX0RWQl9DWDI0MTIz
PW0KQ09ORklHX0RWQl9NVDMxMj1tCkNPTkZJR19EVkJfWkwxMDAzNj1tCkNPTkZJR19EVkJf
WkwxMDAzOT1tCkNPTkZJR19EVkJfUzVIMTQyMD1tCkNPTkZJR19EVkJfU1RWMDI4OD1tCkNP
TkZJR19EVkJfU1RCNjAwMD1tCkNPTkZJR19EVkJfU1RWMDI5OT1tCkNPTkZJR19EVkJfU1RW
NjExMD1tCkNPTkZJR19EVkJfU1RWMDkwMD1tCkNPTkZJR19EVkJfVERBODA4Mz1tCkNPTkZJ
R19EVkJfVERBMTAwODY9bQpDT05GSUdfRFZCX1REQTgyNjE9bQpDT05GSUdfRFZCX1ZFUzFY
OTM9bQpDT05GSUdfRFZCX1RVTkVSX0lURDEwMDA9bQpDT05GSUdfRFZCX1RVTkVSX0NYMjQx
MTM9bQpDT05GSUdfRFZCX1REQTgyNlg9bQpDT05GSUdfRFZCX1RVQTYxMDA9bQpDT05GSUdf
RFZCX0NYMjQxMTY9bQpDT05GSUdfRFZCX1NJMjFYWD1tCkNPTkZJR19EVkJfRFMzMDAwPW0K
Q09ORklHX0RWQl9NQjg2QTE2PW0KCiMKIyBEVkItVCAodGVycmVzdHJpYWwpIGZyb250ZW5k
cwojCkNPTkZJR19EVkJfU1A4ODcwPW0KQ09ORklHX0RWQl9TUDg4N1g9bQpDT05GSUdfRFZC
X0NYMjI3MDA9bQpDT05GSUdfRFZCX0NYMjI3MDI9bQpDT05GSUdfRFZCX1M1SDE0MzI9bQpD
T05GSUdfRFZCX0RSWEQ9bQpDT05GSUdfRFZCX0w2NDc4MT1tCkNPTkZJR19EVkJfVERBMTAw
NFg9bQpDT05GSUdfRFZCX05YVDYwMDA9bQpDT05GSUdfRFZCX01UMzUyPW0KQ09ORklHX0RW
Ql9aTDEwMzUzPW0KQ09ORklHX0RWQl9ESUIzMDAwTUI9bQpDT05GSUdfRFZCX0RJQjMwMDBN
Qz1tCkNPTkZJR19EVkJfRElCNzAwME09bQpDT05GSUdfRFZCX0RJQjcwMDBQPW0KQ09ORklH
X0RWQl9ESUI5MDAwPW0KQ09ORklHX0RWQl9UREExMDA0OD1tCkNPTkZJR19EVkJfQUY5MDEz
PW0KQ09ORklHX0RWQl9FQzEwMD1tCkNPTkZJR19EVkJfU1RWMDM2Nz1tCkNPTkZJR19EVkJf
Q1hEMjgyMFI9bQoKIwojIERWQi1DIChjYWJsZSkgZnJvbnRlbmRzCiMKQ09ORklHX0RWQl9W
RVMxODIwPW0KQ09ORklHX0RWQl9UREExMDAyMT1tCkNPTkZJR19EVkJfVERBMTAwMjM9bQpD
T05GSUdfRFZCX1NUVjAyOTc9bQoKIwojIEFUU0MgKE5vcnRoIEFtZXJpY2FuL0tvcmVhbiBU
ZXJyZXN0cmlhbC9DYWJsZSBEVFYpIGZyb250ZW5kcwojCkNPTkZJR19EVkJfTlhUMjAwWD1t
CkNPTkZJR19EVkJfT1I1MTIxMT1tCkNPTkZJR19EVkJfT1I1MTEzMj1tCkNPTkZJR19EVkJf
QkNNMzUxMD1tCkNPTkZJR19EVkJfTEdEVDMzMFg9bQpDT05GSUdfRFZCX0xHRFQzMzA1PW0K
Q09ORklHX0RWQl9TNUgxNDA5PW0KQ09ORklHX0RWQl9BVTg1MjI9bQpDT05GSUdfRFZCX1M1
SDE0MTE9bQoKIwojIElTREItVCAodGVycmVzdHJpYWwpIGZyb250ZW5kcwojCkNPTkZJR19E
VkJfUzkyMT1tCkNPTkZJR19EVkJfRElCODAwMD1tCkNPTkZJR19EVkJfTUI4NkEyMFM9bQoK
IwojIERpZ2l0YWwgdGVycmVzdHJpYWwgb25seSB0dW5lcnMvUExMCiMKQ09ORklHX0RWQl9Q
TEw9bQpDT05GSUdfRFZCX1RVTkVSX0RJQjAwNzA9bQpDT05GSUdfRFZCX1RVTkVSX0RJQjAw
OTA9bQoKIwojIFNFQyBjb250cm9sIGRldmljZXMgZm9yIERWQi1TCiMKQ09ORklHX0RWQl9M
TkJQMjE9bQpDT05GSUdfRFZCX0lTTDY0MDU9bQpDT05GSUdfRFZCX0lTTDY0MjE9bQpDT05G
SUdfRFZCX0lTTDY0MjM9bQpDT05GSUdfRFZCX0xHUzhHTDU9bQpDT05GSUdfRFZCX0xHUzhH
WFg9bQpDT05GSUdfRFZCX0FUQk04ODMwPW0KQ09ORklHX0RWQl9UREE2NjV4PW0KQ09ORklH
X0RWQl9JWDI1MDVWPW0KCiMKIyBUb29scyB0byBkZXZlbG9wIG5ldyBmcm9udGVuZHMKIwoj
IENPTkZJR19EVkJfRFVNTVlfRkUgaXMgbm90IHNldAoKIwojIEdyYXBoaWNzIHN1cHBvcnQK
IwpDT05GSUdfRFJNPW0KIyBDT05GSUdfVkdBU1RBVEUgaXMgbm90IHNldAojIENPTkZJR19W
SURFT19PVVRQVVRfQ09OVFJPTCBpcyBub3Qgc2V0CkNPTkZJR19GQj15CkNPTkZJR19GSVJN
V0FSRV9FRElEPXkKIyBDT05GSUdfRkJfRERDIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfQk9P
VF9WRVNBX1NVUFBPUlQgaXMgbm90IHNldApDT05GSUdfRkJfQ0ZCX0ZJTExSRUNUPXkKQ09O
RklHX0ZCX0NGQl9DT1BZQVJFQT15CkNPTkZJR19GQl9DRkJfSU1BR0VCTElUPXkKIyBDT05G
SUdfRkJfQ0ZCX1JFVl9QSVhFTFNfSU5fQllURSBpcyBub3Qgc2V0CkNPTkZJR19GQl9TWVNf
RklMTFJFQ1Q9bQpDT05GSUdfRkJfU1lTX0NPUFlBUkVBPW0KQ09ORklHX0ZCX1NZU19JTUFH
RUJMSVQ9bQojIENPTkZJR19GQl9GT1JFSUdOX0VORElBTiBpcyBub3Qgc2V0CkNPTkZJR19G
Ql9TWVNfRk9QUz1tCiMgQ09ORklHX0ZCX1dNVF9HRV9ST1BTIGlzIG5vdCBzZXQKQ09ORklH
X0ZCX0RFRkVSUkVEX0lPPXkKIyBDT05GSUdfRkJfU1ZHQUxJQiBpcyBub3Qgc2V0CiMgQ09O
RklHX0ZCX01BQ01PREVTIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfQkFDS0xJR0hUIGlzIG5v
dCBzZXQKQ09ORklHX0ZCX01PREVfSEVMUEVSUz15CkNPTkZJR19GQl9USUxFQkxJVFRJTkc9
eQoKIwojIEZyYW1lIGJ1ZmZlciBoYXJkd2FyZSBkcml2ZXJzCiMKIyBDT05GSUdfRkJfQVJN
Q0xDRCBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX1VWRVNBIGlzIG5vdCBzZXQKIyBDT05GSUdf
RkJfUzFEMTNYWFggaXMgbm90IHNldAojIENPTkZJR19GQl9UTUlPIGlzIG5vdCBzZXQKQ09O
RklHX0ZCX1VETD1tCiMgQ09ORklHX0ZCX1ZJUlRVQUwgaXMgbm90IHNldAojIENPTkZJR19G
Ql9NRVRST05PTUUgaXMgbm90IHNldAojIENPTkZJR19GQl9CUk9BRFNIRUVUIGlzIG5vdCBz
ZXQKIyBDT05GSUdfRkJfT01BUF9MQ0RfVkdBIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfT01B
UF9CT09UTE9BREVSX0lOSVQgaXMgbm90IHNldApDT05GSUdfT01BUDJfVlJBTT15CkNPTkZJ
R19PTUFQMl9WUkZCPXkKQ09ORklHX09NQVAyX0RTUz15CkNPTkZJR19PTUFQMl9WUkFNX1NJ
WkU9MTgKQ09ORklHX09NQVAyX0RTU19ERUJVR19TVVBQT1JUPXkKIyBDT05GSUdfT01BUDJf
RFNTX0NPTExFQ1RfSVJRX1NUQVRTIGlzIG5vdCBzZXQKQ09ORklHX09NQVAyX0RTU19EUEk9
eQojIENPTkZJR19PTUFQMl9EU1NfUkZCSSBpcyBub3Qgc2V0CkNPTkZJR19PTUFQMl9EU1Nf
VkVOQz15CkNPTkZJR19PTUFQNF9EU1NfSERNST15CkNPTkZJR19PTUFQMl9EU1NfU0RJPXkK
Q09ORklHX09NQVAyX0RTU19EU0k9eQpDT05GSUdfT01BUDJfRFNTX0ZBS0VfVlNZTkM9eQpD
T05GSUdfT01BUDJfRFNTX01JTl9GQ0tfUEVSX1BDSz0wCkNPTkZJR19PTUFQMl9EU1NfU0xF
RVBfQUZURVJfVkVOQ19SRVNFVD15CkNPTkZJR19GQl9PTUFQMj15CkNPTkZJR19GQl9PTUFQ
Ml9ERUJVR19TVVBQT1JUPXkKQ09ORklHX0ZCX09NQVAyX05VTV9GQlM9MwoKIwojIE9NQVAy
LzMgRGlzcGxheSBEZXZpY2UgRHJpdmVycwojCkNPTkZJR19QQU5FTF9HRU5FUklDX0RQST15
CkNPTkZJR19QQU5FTF9MR1BISUxJUFNfTEIwMzVRMDI9eQpDT05GSUdfUEFORUxfU0hBUlBf
TFMwMzdWN0RXMDE9eQpDT05GSUdfUEFORUxfTkVDX05MODA0OEhMMTFfMDFCPXkKQ09ORklH
X1BBTkVMX1RBQUw9eQpDT05GSUdfUEFORUxfVFBPX1REMDQzTVRFQTE9eQpDT05GSUdfUEFO
RUxfQUNYNTY1QUtNPXkKQ09ORklHX0JBQ0tMSUdIVF9MQ0RfU1VQUE9SVD15CkNPTkZJR19M
Q0RfQ0xBU1NfREVWSUNFPW0KIyBDT05GSUdfTENEX0w0RjAwMjQyVDAzIGlzIG5vdCBzZXQK
IyBDT05GSUdfTENEX0xNUzI4M0dGMDUgaXMgbm90IHNldAojIENPTkZJR19MQ0RfTFRWMzUw
UVYgaXMgbm90IHNldAojIENPTkZJR19MQ0RfVERPMjRNIGlzIG5vdCBzZXQKIyBDT05GSUdf
TENEX1ZHRzI0MzJBNCBpcyBub3Qgc2V0CkNPTkZJR19MQ0RfUExBVEZPUk09bQojIENPTkZJ
R19MQ0RfUzZFNjNNMCBpcyBub3Qgc2V0CiMgQ09ORklHX0xDRF9MRDkwNDAgaXMgbm90IHNl
dAojIENPTkZJR19MQ0RfQU1TMzY5RkcwNiBpcyBub3Qgc2V0CkNPTkZJR19CQUNLTElHSFRf
Q0xBU1NfREVWSUNFPXkKQ09ORklHX0JBQ0tMSUdIVF9HRU5FUklDPW0KIyBDT05GSUdfQkFD
S0xJR0hUX0FEUDg4NjAgaXMgbm90IHNldAojIENPTkZJR19CQUNLTElHSFRfQURQODg3MCBp
cyBub3Qgc2V0CgojCiMgRGlzcGxheSBkZXZpY2Ugc3VwcG9ydAojCkNPTkZJR19ESVNQTEFZ
X1NVUFBPUlQ9eQoKIwojIERpc3BsYXkgaGFyZHdhcmUgZHJpdmVycwojCgojCiMgQ29uc29s
ZSBkaXNwbGF5IGRyaXZlciBzdXBwb3J0CiMKQ09ORklHX0RVTU1ZX0NPTlNPTEU9eQpDT05G
SUdfRlJBTUVCVUZGRVJfQ09OU09MRT15CiMgQ09ORklHX0ZSQU1FQlVGRkVSX0NPTlNPTEVf
REVURUNUX1BSSU1BUlkgaXMgbm90IHNldApDT05GSUdfRlJBTUVCVUZGRVJfQ09OU09MRV9S
T1RBVElPTj15CkNPTkZJR19GT05UUz15CkNPTkZJR19GT05UXzh4OD15CkNPTkZJR19GT05U
Xzh4MTY9eQojIENPTkZJR19GT05UXzZ4MTEgaXMgbm90IHNldAojIENPTkZJR19GT05UXzd4
MTQgaXMgbm90IHNldAojIENPTkZJR19GT05UX1BFQVJMXzh4OCBpcyBub3Qgc2V0CiMgQ09O
RklHX0ZPTlRfQUNPUk5fOHg4IGlzIG5vdCBzZXQKIyBDT05GSUdfRk9OVF9NSU5JXzR4NiBp
cyBub3Qgc2V0CiMgQ09ORklHX0ZPTlRfU1VOOHgxNiBpcyBub3Qgc2V0CiMgQ09ORklHX0ZP
TlRfU1VOMTJ4MjIgaXMgbm90IHNldAojIENPTkZJR19GT05UXzEweDE4IGlzIG5vdCBzZXQK
Q09ORklHX0xPR089eQpDT05GSUdfTE9HT19MSU5VWF9NT05PPXkKQ09ORklHX0xPR09fTElO
VVhfVkdBMTY9eQpDT05GSUdfTE9HT19MSU5VWF9DTFVUMjI0PXkKQ09ORklHX1NPVU5EPXkK
Q09ORklHX1NPVU5EX09TU19DT1JFPXkKQ09ORklHX1NPVU5EX09TU19DT1JFX1BSRUNMQUlN
PXkKQ09ORklHX1NORD15CkNPTkZJR19TTkRfVElNRVI9eQpDT05GSUdfU05EX1BDTT15CkNP
TkZJR19TTkRfSFdERVA9bQpDT05GSUdfU05EX1JBV01JREk9eQpDT05GSUdfU05EX0pBQ0s9
eQpDT05GSUdfU05EX1NFUVVFTkNFUj1tCkNPTkZJR19TTkRfU0VRX0RVTU1ZPW0KQ09ORklH
X1NORF9PU1NFTVVMPXkKQ09ORklHX1NORF9NSVhFUl9PU1M9bQpDT05GSUdfU05EX1BDTV9P
U1M9bQpDT05GSUdfU05EX1BDTV9PU1NfUExVR0lOUz15CkNPTkZJR19TTkRfU0VRVUVOQ0VS
X09TUz15CkNPTkZJR19TTkRfSFJUSU1FUj1tCkNPTkZJR19TTkRfU0VRX0hSVElNRVJfREVG
QVVMVD15CkNPTkZJR19TTkRfRFlOQU1JQ19NSU5PUlM9eQpDT05GSUdfU05EX1NVUFBPUlRf
T0xEX0FQST15CkNPTkZJR19TTkRfVkVSQk9TRV9QUk9DRlM9eQojIENPTkZJR19TTkRfVkVS
Qk9TRV9QUklOVEsgaXMgbm90IHNldAojIENPTkZJR19TTkRfREVCVUcgaXMgbm90IHNldApD
T05GSUdfU05EX1JBV01JRElfU0VRPW0KIyBDT05GSUdfU05EX09QTDNfTElCX1NFUSBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NORF9PUEw0X0xJQl9TRVEgaXMgbm90IHNldAojIENPTkZJR19T
TkRfU0JBV0VfU0VRIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0VNVTEwSzFfU0VRIGlzIG5v
dCBzZXQKQ09ORklHX1NORF9EUklWRVJTPXkKIyBDT05GSUdfU05EX0RVTU1ZIGlzIG5vdCBz
ZXQKIyBDT05GSUdfU05EX0FMT09QIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1ZJUk1JREkg
aXMgbm90IHNldAojIENPTkZJR19TTkRfTVRQQVYgaXMgbm90IHNldAojIENPTkZJR19TTkRf
U0VSSUFMX1UxNjU1MCBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9NUFU0MDEgaXMgbm90IHNl
dApDT05GSUdfU05EX0FSTT15CiMgQ09ORklHX1NORF9BUk1BQUNJIGlzIG5vdCBzZXQKQ09O
RklHX1NORF9TUEk9eQpDT05GSUdfU05EX1VTQj15CkNPTkZJR19TTkRfVVNCX0FVRElPPW0K
Q09ORklHX1NORF9VU0JfVUExMDE9bQpDT05GSUdfU05EX1VTQl9DQUlBUT1tCkNPTkZJR19T
TkRfVVNCX0NBSUFRX0lOUFVUPXkKQ09ORklHX1NORF9VU0JfNkZJUkU9eQpDT05GSUdfU05E
X1NPQz15CiMgQ09ORklHX1NORF9TT0NfQ0FDSEVfTFpPIGlzIG5vdCBzZXQKQ09ORklHX1NO
RF9PTUFQX1NPQz15CkNPTkZJR19TTkRfT01BUF9TT0NfTUNCU1A9eQpDT05GSUdfU05EX09N
QVBfU09DX01DUERNPXkKQ09ORklHX1NORF9PTUFQX1NPQ19IRE1JPXkKQ09ORklHX1NORF9P
TUFQX1NPQ19SWDUxPXkKQ09ORklHX1NORF9PTUFQX1NPQ19PVkVSTz15CkNPTkZJR19TTkRf
T01BUF9TT0NfT01BUDNFVk09eQpDT05GSUdfU05EX09NQVBfU09DX0FNMzUxN0VWTT15CkNP
TkZJR19TTkRfT01BUF9TT0NfU0RQMzQzMD15CkNPTkZJR19TTkRfT01BUF9TT0NfU0RQNDQz
MD15CkNPTkZJR19TTkRfT01BUF9TT0NfT01BUDRfSERNST15CkNPTkZJR19TTkRfT01BUF9T
T0NfT01BUDNfUEFORE9SQT15CkNPTkZJR19TTkRfT01BUF9TT0NfT01BUDNfQkVBR0xFPXkK
Q09ORklHX1NORF9PTUFQX1NPQ19aT09NMj15CkNPTkZJR19TTkRfT01BUF9TT0NfSUdFUDAw
MjA9eQpDT05GSUdfU05EX1NPQ19JMkNfQU5EX1NQST15CiMgQ09ORklHX1NORF9TT0NfQUxM
X0NPREVDUyBpcyBub3Qgc2V0CkNPTkZJR19TTkRfU09DX1RMVjMyMEFJQzIzPXkKQ09ORklH
X1NORF9TT0NfVExWMzIwQUlDM1g9eQpDT05GSUdfU05EX1NPQ19UV0w0MDMwPXkKQ09ORklH
X1NORF9TT0NfVFdMNjA0MD15CkNPTkZJR19TTkRfU09DX1RQQTYxMzBBMj15CiMgQ09ORklH
X1NPVU5EX1BSSU1FIGlzIG5vdCBzZXQKQ09ORklHX0hJRF9TVVBQT1JUPXkKQ09ORklHX0hJ
RD15CkNPTkZJR19ISURSQVc9eQoKIwojIFVTQiBJbnB1dCBEZXZpY2VzCiMKQ09ORklHX1VT
Ql9ISUQ9bQpDT05GSUdfSElEX1BJRD15CkNPTkZJR19VU0JfSElEREVWPXkKCiMKIyBVU0Ig
SElEIEJvb3QgUHJvdG9jb2wgZHJpdmVycwojCiMgQ09ORklHX1VTQl9LQkQgaXMgbm90IHNl
dAojIENPTkZJR19VU0JfTU9VU0UgaXMgbm90IHNldAoKIwojIFNwZWNpYWwgSElEIGRyaXZl
cnMKIwpDT05GSUdfSElEX0E0VEVDSD1tCkNPTkZJR19ISURfQUNSVVg9bQojIENPTkZJR19I
SURfQUNSVVhfRkYgaXMgbm90IHNldAojIENPTkZJR19ISURfQVBQTEUgaXMgbm90IHNldApD
T05GSUdfSElEX0JFTEtJTj1tCkNPTkZJR19ISURfQ0hFUlJZPW0KQ09ORklHX0hJRF9DSElD
T05ZPW0KQ09ORklHX0hJRF9QUk9ESUtFWVM9bQpDT05GSUdfSElEX0NZUFJFU1M9bQpDT05G
SUdfSElEX0RSQUdPTlJJU0U9bQpDT05GSUdfRFJBR09OUklTRV9GRj15CkNPTkZJR19ISURf
RU1TX0ZGPW0KQ09ORklHX0hJRF9FTEVDT009bQpDT05GSUdfSElEX0VaS0VZPW0KQ09ORklH
X0hJRF9IT0xURUs9bQpDT05GSUdfSE9MVEVLX0ZGPXkKQ09ORklHX0hJRF9LRVlUT1VDSD1t
CkNPTkZJR19ISURfS1lFPW0KQ09ORklHX0hJRF9VQ0xPR0lDPW0KQ09ORklHX0hJRF9XQUxU
T1A9bQpDT05GSUdfSElEX0dZUkFUSU9OPW0KQ09ORklHX0hJRF9UV0lOSEFOPW0KQ09ORklH
X0hJRF9LRU5TSU5HVE9OPW0KQ09ORklHX0hJRF9MQ1BPV0VSPW0KQ09ORklHX0hJRF9MT0dJ
VEVDSD1tCkNPTkZJR19MT0dJVEVDSF9GRj15CkNPTkZJR19MT0dJUlVNQkxFUEFEMl9GRj15
CkNPTkZJR19MT0dJRzk0MF9GRj15CkNPTkZJR19MT0dJV0lJX0ZGPXkKQ09ORklHX0hJRF9N
QUdJQ01PVVNFPW0KQ09ORklHX0hJRF9NSUNST1NPRlQ9bQpDT05GSUdfSElEX01PTlRFUkVZ
PW0KQ09ORklHX0hJRF9NVUxUSVRPVUNIPW0KQ09ORklHX0hJRF9OVFJJRz1tCkNPTkZJR19I
SURfT1JURUs9bQpDT05GSUdfSElEX1BBTlRIRVJMT1JEPW0KQ09ORklHX1BBTlRIRVJMT1JE
X0ZGPXkKQ09ORklHX0hJRF9QRVRBTFlOWD1tCkNPTkZJR19ISURfUElDT0xDRD1tCkNPTkZJ
R19ISURfUElDT0xDRF9GQj15CkNPTkZJR19ISURfUElDT0xDRF9CQUNLTElHSFQ9eQpDT05G
SUdfSElEX1BJQ09MQ0RfTENEPXkKQ09ORklHX0hJRF9QSUNPTENEX0xFRFM9eQpDT05GSUdf
SElEX1FVQU5UQT1tCkNPTkZJR19ISURfUk9DQ0FUPW0KQ09ORklHX0hJRF9ST0NDQVRfQ09N
TU9OPW0KQ09ORklHX0hJRF9ST0NDQVRfQVJWTz1tCkNPTkZJR19ISURfUk9DQ0FUX0tPTkU9
bQpDT05GSUdfSElEX1JPQ0NBVF9LT05FUExVUz1tCkNPTkZJR19ISURfUk9DQ0FUX0tPVkFQ
TFVTPW0KQ09ORklHX0hJRF9ST0NDQVRfUFlSQT1tCkNPTkZJR19ISURfU0FNU1VORz1tCkNP
TkZJR19ISURfU09OWT1tCkNPTkZJR19ISURfU1BFRURMSU5LPW0KQ09ORklHX0hJRF9TVU5Q
TFVTPW0KQ09ORklHX0hJRF9HUkVFTkFTSUE9bQpDT05GSUdfR1JFRU5BU0lBX0ZGPXkKQ09O
RklHX0hJRF9TTUFSVEpPWVBMVVM9bQpDT05GSUdfU01BUlRKT1lQTFVTX0ZGPXkKQ09ORklH
X0hJRF9UT1BTRUVEPW0KQ09ORklHX0hJRF9USFJVU1RNQVNURVI9bQpDT05GSUdfVEhSVVNU
TUFTVEVSX0ZGPXkKQ09ORklHX0hJRF9XQUNPTT1tCkNPTkZJR19ISURfV0FDT01fUE9XRVJf
U1VQUExZPXkKQ09ORklHX0hJRF9XSUlNT1RFPW0KQ09ORklHX0hJRF9aRVJPUExVUz1tCkNP
TkZJR19aRVJPUExVU19GRj15CkNPTkZJR19ISURfWllEQUNST049bQpDT05GSUdfVVNCX1NV
UFBPUlQ9eQpDT05GSUdfVVNCX0FSQ0hfSEFTX0hDRD15CkNPTkZJR19VU0JfQVJDSF9IQVNf
T0hDST15CkNPTkZJR19VU0JfQVJDSF9IQVNfRUhDST15CkNPTkZJR19VU0I9eQojIENPTkZJ
R19VU0JfREVCVUcgaXMgbm90IHNldAojIENPTkZJR19VU0JfQU5OT1VOQ0VfTkVXX0RFVklD
RVMgaXMgbm90IHNldAoKIwojIE1pc2NlbGxhbmVvdXMgVVNCIG9wdGlvbnMKIwojIENPTkZJ
R19VU0JfREVWSUNFRlMgaXMgbm90IHNldAojIENPTkZJR19VU0JfREVWSUNFX0NMQVNTIGlz
IG5vdCBzZXQKIyBDT05GSUdfVVNCX0RZTkFNSUNfTUlOT1JTIGlzIG5vdCBzZXQKQ09ORklH
X1VTQl9TVVNQRU5EPXkKQ09ORklHX1VTQl9PVEc9eQojIENPTkZJR19VU0JfT1RHX1dISVRF
TElTVCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9PVEdfQkxBQ0tMSVNUX0hVQiBpcyBub3Qg
c2V0CkNPTkZJR19VU0JfTU9OPXkKIyBDT05GSUdfVVNCX1dVU0IgaXMgbm90IHNldAojIENP
TkZJR19VU0JfV1VTQl9DQkFGIGlzIG5vdCBzZXQKCiMKIyBVU0IgSG9zdCBDb250cm9sbGVy
IERyaXZlcnMKIwojIENPTkZJR19VU0JfQzY3WDAwX0hDRCBpcyBub3Qgc2V0CkNPTkZJR19V
U0JfRUhDSV9IQ0Q9eQpDT05GSUdfVVNCX0VIQ0lfUk9PVF9IVUJfVFQ9eQpDT05GSUdfVVNC
X0VIQ0lfVFRfTkVXU0NIRUQ9eQpDT05GSUdfVVNCX0VIQ0lfSENEX09NQVA9eQojIENPTkZJ
R19VU0JfT1hVMjEwSFBfSENEIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0lTUDExNlhfSENE
IGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0lTUDE3NjBfSENEIGlzIG5vdCBzZXQKIyBDT05G
SUdfVVNCX0lTUDEzNjJfSENEIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX09IQ0lfSENEIGlz
IG5vdCBzZXQKIyBDT05GSUdfVVNCX1UxMzJfSENEIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNC
X1NMODExX0hDRCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9SOEE2NjU5N19IQ0QgaXMgbm90
IHNldAojIENPTkZJR19VU0JfSFdBX0hDRCBpcyBub3Qgc2V0CkNPTkZJR19VU0JfTVVTQl9I
RFJDPXkKIyBDT05GSUdfVVNCX01VU0JfVFVTQjYwMTAgaXMgbm90IHNldApDT05GSUdfVVNC
X01VU0JfT01BUDJQTFVTPXkKIyBDT05GSUdfVVNCX01VU0JfQU0zNVggaXMgbm90IHNldAoj
IENPTkZJR19NVVNCX1BJT19PTkxZIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1VYNTAwX0RN
QSBpcyBub3Qgc2V0CkNPTkZJR19VU0JfSU5WRU5UUkFfRE1BPXkKIyBDT05GSUdfVVNCX1RJ
X0NQUElfRE1BIGlzIG5vdCBzZXQKCiMKIyBVU0IgRGV2aWNlIENsYXNzIGRyaXZlcnMKIwpD
T05GSUdfVVNCX0FDTT1tCkNPTkZJR19VU0JfUFJJTlRFUj1tCkNPTkZJR19VU0JfV0RNPW0K
Q09ORklHX1VTQl9UTUM9bQoKIwojIE5PVEU6IFVTQl9TVE9SQUdFIGRlcGVuZHMgb24gU0NT
SSBidXQgQkxLX0RFVl9TRCBtYXkKIwoKIwojIGFsc28gYmUgbmVlZGVkOyBzZWUgVVNCX1NU
T1JBR0UgSGVscCBmb3IgbW9yZSBpbmZvCiMKQ09ORklHX1VTQl9TVE9SQUdFPXkKIyBDT05G
SUdfVVNCX1NUT1JBR0VfREVCVUcgaXMgbm90IHNldApDT05GSUdfVVNCX1NUT1JBR0VfUkVB
TFRFSz1tCkNPTkZJR19SRUFMVEVLX0FVVE9QTT15CkNPTkZJR19VU0JfU1RPUkFHRV9EQVRB
RkFCPW0KQ09ORklHX1VTQl9TVE9SQUdFX0ZSRUVDT009bQpDT05GSUdfVVNCX1NUT1JBR0Vf
SVNEMjAwPW0KQ09ORklHX1VTQl9TVE9SQUdFX1VTQkFUPW0KQ09ORklHX1VTQl9TVE9SQUdF
X1NERFIwOT1tCkNPTkZJR19VU0JfU1RPUkFHRV9TRERSNTU9bQpDT05GSUdfVVNCX1NUT1JB
R0VfSlVNUFNIT1Q9bQpDT05GSUdfVVNCX1NUT1JBR0VfQUxBVURBPW0KQ09ORklHX1VTQl9T
VE9SQUdFX09ORVRPVUNIPW0KQ09ORklHX1VTQl9TVE9SQUdFX0tBUk1BPW0KQ09ORklHX1VT
Ql9TVE9SQUdFX0NZUFJFU1NfQVRBQ0I9bQpDT05GSUdfVVNCX1NUT1JBR0VfRU5FX1VCNjI1
MD1tCkNPTkZJR19VU0JfVUFTPW0KQ09ORklHX1VTQl9MSUJVU1VBTD15CgojCiMgVVNCIElt
YWdpbmcgZGV2aWNlcwojCkNPTkZJR19VU0JfTURDODAwPW0KQ09ORklHX1VTQl9NSUNST1RF
Sz1tCgojCiMgVVNCIHBvcnQgZHJpdmVycwojCkNPTkZJR19VU0JfU0VSSUFMPW0KQ09ORklH
X1VTQl9FWlVTQj15CkNPTkZJR19VU0JfU0VSSUFMX0dFTkVSSUM9eQpDT05GSUdfVVNCX1NF
UklBTF9BSVJDQUJMRT1tCkNPTkZJR19VU0JfU0VSSUFMX0FSSzMxMTY9bQpDT05GSUdfVVNC
X1NFUklBTF9CRUxLSU49bQpDT05GSUdfVVNCX1NFUklBTF9DSDM0MT1tCkNPTkZJR19VU0Jf
U0VSSUFMX1dISVRFSEVBVD1tCkNPTkZJR19VU0JfU0VSSUFMX0RJR0lfQUNDRUxFUE9SVD1t
CkNPTkZJR19VU0JfU0VSSUFMX0NQMjEwWD1tCkNPTkZJR19VU0JfU0VSSUFMX0NZUFJFU1Nf
TTg9bQpDT05GSUdfVVNCX1NFUklBTF9FTVBFRz1tCkNPTkZJR19VU0JfU0VSSUFMX0ZURElf
U0lPPW0KQ09ORklHX1VTQl9TRVJJQUxfRlVOU09GVD1tCkNPTkZJR19VU0JfU0VSSUFMX1ZJ
U09SPW0KQ09ORklHX1VTQl9TRVJJQUxfSVBBUT1tCkNPTkZJR19VU0JfU0VSSUFMX0lSPW0K
Q09ORklHX1VTQl9TRVJJQUxfRURHRVBPUlQ9bQpDT05GSUdfVVNCX1NFUklBTF9FREdFUE9S
VF9UST1tCkNPTkZJR19VU0JfU0VSSUFMX0dBUk1JTj1tCkNPTkZJR19VU0JfU0VSSUFMX0lQ
Vz1tCkNPTkZJR19VU0JfU0VSSUFMX0lVVT1tCkNPTkZJR19VU0JfU0VSSUFMX0tFWVNQQU5f
UERBPW0KQ09ORklHX1VTQl9TRVJJQUxfS0VZU1BBTj1tCkNPTkZJR19VU0JfU0VSSUFMX0tF
WVNQQU5fTVBSPXkKQ09ORklHX1VTQl9TRVJJQUxfS0VZU1BBTl9VU0EyOD15CkNPTkZJR19V
U0JfU0VSSUFMX0tFWVNQQU5fVVNBMjhYPXkKQ09ORklHX1VTQl9TRVJJQUxfS0VZU1BBTl9V
U0EyOFhBPXkKQ09ORklHX1VTQl9TRVJJQUxfS0VZU1BBTl9VU0EyOFhCPXkKQ09ORklHX1VT
Ql9TRVJJQUxfS0VZU1BBTl9VU0ExOT15CkNPTkZJR19VU0JfU0VSSUFMX0tFWVNQQU5fVVNB
MThYPXkKQ09ORklHX1VTQl9TRVJJQUxfS0VZU1BBTl9VU0ExOVc9eQpDT05GSUdfVVNCX1NF
UklBTF9LRVlTUEFOX1VTQTE5UVc9eQpDT05GSUdfVVNCX1NFUklBTF9LRVlTUEFOX1VTQTE5
UUk9eQpDT05GSUdfVVNCX1NFUklBTF9LRVlTUEFOX1VTQTQ5Vz15CkNPTkZJR19VU0JfU0VS
SUFMX0tFWVNQQU5fVVNBNDlXTEM9eQpDT05GSUdfVVNCX1NFUklBTF9LTFNJPW0KQ09ORklH
X1VTQl9TRVJJQUxfS09CSUxfU0NUPW0KQ09ORklHX1VTQl9TRVJJQUxfTUNUX1UyMzI9bQpD
T05GSUdfVVNCX1NFUklBTF9NT1M3NzIwPW0KQ09ORklHX1VTQl9TRVJJQUxfTU9TNzg0MD1t
CkNPTkZJR19VU0JfU0VSSUFMX01PVE9ST0xBPW0KQ09ORklHX1VTQl9TRVJJQUxfTkFWTUFO
PW0KQ09ORklHX1VTQl9TRVJJQUxfUEwyMzAzPW0KQ09ORklHX1VTQl9TRVJJQUxfT1RJNjg1
OD1tCkNPTkZJR19VU0JfU0VSSUFMX1FDQVVYPW0KQ09ORklHX1VTQl9TRVJJQUxfUVVBTENP
TU09bQpDT05GSUdfVVNCX1NFUklBTF9TUENQOFg1PW0KQ09ORklHX1VTQl9TRVJJQUxfSFA0
WD1tCkNPTkZJR19VU0JfU0VSSUFMX1NBRkU9bQpDT05GSUdfVVNCX1NFUklBTF9TQUZFX1BB
RERFRD15CkNPTkZJR19VU0JfU0VSSUFMX1NJRU1FTlNfTVBJPW0KQ09ORklHX1VTQl9TRVJJ
QUxfU0lFUlJBV0lSRUxFU1M9bQpDT05GSUdfVVNCX1NFUklBTF9TWU1CT0w9bQpDT05GSUdf
VVNCX1NFUklBTF9UST1tCkNPTkZJR19VU0JfU0VSSUFMX0NZQkVSSkFDSz1tCkNPTkZJR19V
U0JfU0VSSUFMX1hJUkNPTT1tCkNPTkZJR19VU0JfU0VSSUFMX1dXQU49bQpDT05GSUdfVVNC
X1NFUklBTF9PUFRJT049bQpDT05GSUdfVVNCX1NFUklBTF9PTU5JTkVUPW0KQ09ORklHX1VT
Ql9TRVJJQUxfT1BUSUNPTj1tCkNPTkZJR19VU0JfU0VSSUFMX1ZJVk9QQVlfU0VSSUFMPW0K
Q09ORklHX1VTQl9TRVJJQUxfWklPPW0KQ09ORklHX1VTQl9TRVJJQUxfU1NVMTAwPW0KQ09O
RklHX1VTQl9TRVJJQUxfREVCVUc9bQoKIwojIFVTQiBNaXNjZWxsYW5lb3VzIGRyaXZlcnMK
IwpDT05GSUdfVVNCX0VNSTYyPW0KQ09ORklHX1VTQl9FTUkyNj1tCkNPTkZJR19VU0JfQURV
VFVYPW0KQ09ORklHX1VTQl9TRVZTRUc9bQpDT05GSUdfVVNCX1JJTzUwMD1tCkNPTkZJR19V
U0JfTEVHT1RPV0VSPW0KQ09ORklHX1VTQl9MQ0Q9bQpDT05GSUdfVVNCX0xFRD1tCkNPTkZJ
R19VU0JfQ1lQUkVTU19DWTdDNjM9bQpDT05GSUdfVVNCX0NZVEhFUk09bQpDT05GSUdfVVNC
X0lETU9VU0U9bQpDT05GSUdfVVNCX0ZURElfRUxBTj1tCkNPTkZJR19VU0JfQVBQTEVESVNQ
TEFZPW0KQ09ORklHX1VTQl9TSVNVU0JWR0E9bQpDT05GSUdfVVNCX1NJU1VTQlZHQV9DT049
eQpDT05GSUdfVVNCX0xEPW0KQ09ORklHX1VTQl9UUkFOQ0VWSUJSQVRPUj1tCkNPTkZJR19V
U0JfSU9XQVJSSU9SPW0KQ09ORklHX1VTQl9URVNUPW0KQ09ORklHX1VTQl9JU0lHSFRGVz1t
CkNPTkZJR19VU0JfWVVSRVg9bQpDT05GSUdfVVNCX0FUTT1tCkNPTkZJR19VU0JfU1BFRURU
T1VDSD1tCkNPTkZJR19VU0JfQ1hBQ1JVPW0KQ09ORklHX1VTQl9VRUFHTEVBVE09bQpDT05G
SUdfVVNCX1hVU0JBVE09bQpDT05GSUdfVVNCX0dBREdFVD15CiMgQ09ORklHX1VTQl9HQURH
RVRfREVCVUcgaXMgbm90IHNldAojIENPTkZJR19VU0JfR0FER0VUX0RFQlVHX0ZJTEVTIGlz
IG5vdCBzZXQKQ09ORklHX1VTQl9HQURHRVRfREVCVUdfRlM9eQpDT05GSUdfVVNCX0dBREdF
VF9WQlVTX0RSQVc9MgojIENPTkZJR19VU0JfRlVTQjMwMCBpcyBub3Qgc2V0CkNPTkZJR19V
U0JfT01BUD15CiMgQ09ORklHX1VTQl9SOEE2NjU5NyBpcyBub3Qgc2V0CiMgQ09ORklHX1VT
Ql9HQURHRVRfTVVTQl9IRFJDIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX002NjU5MiBpcyBu
b3Qgc2V0CiMgQ09ORklHX1VTQl9ORVQyMjcyIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0RV
TU1ZX0hDRCBpcyBub3Qgc2V0CkNPTkZJR19VU0JfR0FER0VUX0RVQUxTUEVFRD15CiMgQ09O
RklHX1VTQl9aRVJPIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0FVRElPIGlzIG5vdCBzZXQK
Q09ORklHX1VTQl9FVEg9eQpDT05GSUdfVVNCX0VUSF9STkRJUz15CkNPTkZJR19VU0JfRVRI
X0VFTT15CiMgQ09ORklHX1VTQl9HX05DTSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9HQURH
RVRGUyBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9GVU5DVElPTkZTIGlzIG5vdCBzZXQKIyBD
T05GSUdfVVNCX0ZJTEVfU1RPUkFHRSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9NQVNTX1NU
T1JBR0UgaXMgbm90IHNldAojIENPTkZJR19VU0JfR19TRVJJQUwgaXMgbm90IHNldAojIENP
TkZJR19VU0JfTUlESV9HQURHRVQgaXMgbm90IHNldAojIENPTkZJR19VU0JfR19QUklOVEVS
IGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0NEQ19DT01QT1NJVEUgaXMgbm90IHNldAojIENP
TkZJR19VU0JfR19OT0tJQSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9HX01VTFRJIGlzIG5v
dCBzZXQKIyBDT05GSUdfVVNCX0dfSElEIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0dfREJH
UCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9HX1dFQkNBTSBpcyBub3Qgc2V0CgojCiMgT1RH
IGFuZCByZWxhdGVkIGluZnJhc3RydWN0dXJlCiMKQ09ORklHX1VTQl9PVEdfVVRJTFM9eQpD
T05GSUdfVVNCX0dQSU9fVkJVUz15CiMgQ09ORklHX0lTUDEzMDFfT01BUCBpcyBub3Qgc2V0
CiMgQ09ORklHX1VTQl9VTFBJIGlzIG5vdCBzZXQKQ09ORklHX1RXTDQwMzBfVVNCPXkKQ09O
RklHX1RXTDYwMzBfVVNCPXkKQ09ORklHX05PUF9VU0JfWENFSVY9eQpDT05GSUdfTU1DPXkK
IyBDT05GSUdfTU1DX0RFQlVHIGlzIG5vdCBzZXQKQ09ORklHX01NQ19VTlNBRkVfUkVTVU1F
PXkKIyBDT05GSUdfTU1DX0NMS0dBVEUgaXMgbm90IHNldAoKIwojIE1NQy9TRC9TRElPIENh
cmQgRHJpdmVycwojCkNPTkZJR19NTUNfQkxPQ0s9eQpDT05GSUdfTU1DX0JMT0NLX01JTk9S
Uz04CkNPTkZJR19NTUNfQkxPQ0tfQk9VTkNFPXkKQ09ORklHX1NESU9fVUFSVD1tCiMgQ09O
RklHX01NQ19URVNUIGlzIG5vdCBzZXQKCiMKIyBNTUMvU0QvU0RJTyBIb3N0IENvbnRyb2xs
ZXIgRHJpdmVycwojCkNPTkZJR19NTUNfQVJNTU1DST1tCkNPTkZJR19NTUNfU0RIQ0k9eQpD
T05GSUdfTU1DX1NESENJX1BMVEZNPW0KIyBDT05GSUdfTU1DX1NESENJX1BYQVYzIGlzIG5v
dCBzZXQKIyBDT05GSUdfTU1DX1NESENJX1BYQVYyIGlzIG5vdCBzZXQKQ09ORklHX01NQ19P
TUFQPW0KQ09ORklHX01NQ19PTUFQX0hTPXkKIyBDT05GSUdfTU1DX0RXIGlzIG5vdCBzZXQK
IyBDT05GSUdfTU1DX1ZVQjMwMCBpcyBub3Qgc2V0CiMgQ09ORklHX01NQ19VU0hDIGlzIG5v
dCBzZXQKIyBDT05GSUdfTUVNU1RJQ0sgaXMgbm90IHNldApDT05GSUdfTkVXX0xFRFM9eQpD
T05GSUdfTEVEU19DTEFTUz15CgojCiMgTEVEIGRyaXZlcnMKIwojIENPTkZJR19MRURTX0xN
MzUzMCBpcyBub3Qgc2V0CiMgQ09ORklHX0xFRFNfUENBOTUzMiBpcyBub3Qgc2V0CkNPTkZJ
R19MRURTX0dQSU89eQojIENPTkZJR19MRURTX0xQMzk0NCBpcyBub3Qgc2V0CiMgQ09ORklH
X0xFRFNfTFA1NTIxIGlzIG5vdCBzZXQKIyBDT05GSUdfTEVEU19MUDU1MjMgaXMgbm90IHNl
dAojIENPTkZJR19MRURTX1BDQTk1NVggaXMgbm90IHNldAojIENPTkZJR19MRURTX0RBQzEy
NFMwODUgaXMgbm90IHNldApDT05GSUdfTEVEU19SRUdVTEFUT1I9eQojIENPTkZJR19MRURT
X0JEMjgwMiBpcyBub3Qgc2V0CiMgQ09ORklHX0xFRFNfTFQzNTkzIGlzIG5vdCBzZXQKQ09O
RklHX0xFRFNfVFJJR0dFUlM9eQoKIwojIExFRCBUcmlnZ2VycwojCkNPTkZJR19MRURTX1RS
SUdHRVJfVElNRVI9bQpDT05GSUdfTEVEU19UUklHR0VSX0hFQVJUQkVBVD15CkNPTkZJR19M
RURTX1RSSUdHRVJfQkFDS0xJR0hUPW0KIyBDT05GSUdfTEVEU19UUklHR0VSX0dQSU8gaXMg
bm90IHNldApDT05GSUdfTEVEU19UUklHR0VSX0RFRkFVTFRfT049bQoKIwojIGlwdGFibGVz
IHRyaWdnZXIgaXMgdW5kZXIgTmV0ZmlsdGVyIGNvbmZpZyAoTEVEIHRhcmdldCkKIwojIENP
TkZJR19BQ0NFU1NJQklMSVRZIGlzIG5vdCBzZXQKQ09ORklHX1JUQ19MSUI9eQpDT05GSUdf
UlRDX0NMQVNTPXkKQ09ORklHX1JUQ19IQ1RPU1lTPXkKQ09ORklHX1JUQ19IQ1RPU1lTX0RF
VklDRT0icnRjMCIKIyBDT05GSUdfUlRDX0RFQlVHIGlzIG5vdCBzZXQKCiMKIyBSVEMgaW50
ZXJmYWNlcwojCkNPTkZJR19SVENfSU5URl9TWVNGUz15CkNPTkZJR19SVENfSU5URl9QUk9D
PXkKQ09ORklHX1JUQ19JTlRGX0RFVj15CkNPTkZJR19SVENfSU5URl9ERVZfVUlFX0VNVUw9
eQojIENPTkZJR19SVENfRFJWX1RFU1QgaXMgbm90IHNldAoKIwojIEkyQyBSVEMgZHJpdmVy
cwojCiMgQ09ORklHX1JUQ19EUlZfRFMxMzA3IGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RS
Vl9EUzEzNzQgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX0RTMTY3MiBpcyBub3Qgc2V0
CiMgQ09ORklHX1JUQ19EUlZfRFMzMjMyIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9N
QVg2OTAwIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9SUzVDMzcyIGlzIG5vdCBzZXQK
IyBDT05GSUdfUlRDX0RSVl9JU0wxMjA4IGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9J
U0wxMjAyMiBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfWDEyMDUgaXMgbm90IHNldAoj
IENPTkZJR19SVENfRFJWX1BDRjg1NjMgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX1BD
Rjg1ODMgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX000MVQ4MCBpcyBub3Qgc2V0CiMg
Q09ORklHX1JUQ19EUlZfQlEzMksgaXMgbm90IHNldApDT05GSUdfUlRDX0RSVl9UV0w0MDMw
PXkKIyBDT05GSUdfUlRDX0RSVl9TMzUzOTBBIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RS
Vl9GTTMxMzAgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX1JYODU4MSBpcyBub3Qgc2V0
CiMgQ09ORklHX1JUQ19EUlZfUlg4MDI1IGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9F
TTMwMjcgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX1JWMzAyOUMyIGlzIG5vdCBzZXQK
CiMKIyBTUEkgUlRDIGRyaXZlcnMKIwojIENPTkZJR19SVENfRFJWX000MVQ5MyBpcyBub3Qg
c2V0CiMgQ09ORklHX1JUQ19EUlZfTTQxVDk0IGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RS
Vl9EUzEzMDUgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX0RTMTM5MCBpcyBub3Qgc2V0
CiMgQ09ORklHX1JUQ19EUlZfTUFYNjkwMiBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZf
Ujk3MDEgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX1JTNUMzNDggaXMgbm90IHNldAoj
IENPTkZJR19SVENfRFJWX0RTMzIzNCBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfUENG
MjEyMyBpcyBub3Qgc2V0CgojCiMgUGxhdGZvcm0gUlRDIGRyaXZlcnMKIwojIENPTkZJR19S
VENfRFJWX0NNT1MgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX0RTMTI4NiBpcyBub3Qg
c2V0CiMgQ09ORklHX1JUQ19EUlZfRFMxNTExIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RS
Vl9EUzE1NTMgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX0RTMTc0MiBpcyBub3Qgc2V0
CiMgQ09ORklHX1JUQ19EUlZfU1RLMTdUQTggaXMgbm90IHNldAojIENPTkZJR19SVENfRFJW
X000OFQ4NiBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfTTQ4VDM1IGlzIG5vdCBzZXQK
IyBDT05GSUdfUlRDX0RSVl9NNDhUNTkgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX01T
TTYyNDIgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX0JRNDgwMiBpcyBub3Qgc2V0CiMg
Q09ORklHX1JUQ19EUlZfUlA1QzAxIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9WMzAy
MCBpcyBub3Qgc2V0CgojCiMgb24tQ1BVIFJUQyBkcml2ZXJzCiMKIyBDT05GSUdfUlRDX0RS
Vl9QTDAzMCBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfUEwwMzEgaXMgbm90IHNldAoj
IENPTkZJR19ETUFERVZJQ0VTIGlzIG5vdCBzZXQKIyBDT05GSUdfQVVYRElTUExBWSBpcyBu
b3Qgc2V0CkNPTkZJR19VSU89bQpDT05GSUdfVUlPX1BEUlY9bQpDT05GSUdfVUlPX1BEUlZf
R0VOSVJRPW0KCiMKIyBWaXJ0aW8gZHJpdmVycwojCiMgQ09ORklHX1ZJUlRJT19CQUxMT09O
IGlzIG5vdCBzZXQKQ09ORklHX1NUQUdJTkc9eQojIENPTkZJR19WSURFT19UTTYwMDAgaXMg
bm90IHNldApDT05GSUdfVVNCSVBfQ09SRT1tCkNPTkZJR19VU0JJUF9WSENJX0hDRD1tCkNP
TkZJR19VU0JJUF9IT1NUPW0KIyBDT05GSUdfVVNCSVBfREVCVUcgaXMgbm90IHNldApDT05G
SUdfVzM1VU5EPW0KQ09ORklHX1BSSVNNMl9VU0I9bQojIENPTkZJR19FQ0hPIGlzIG5vdCBz
ZXQKIyBDT05GSUdfQlJDTVVUSUwgaXMgbm90IHNldAojIENPTkZJR19BU1VTX09MRUQgaXMg
bm90IHNldApDT05GSUdfUjg3MTJVPW0KQ09ORklHX1I4NzEyX0FQPXkKIyBDT05GSUdfVFJB
TlpQT1JUIGlzIG5vdCBzZXQKIyBDT05GSUdfUE9ITUVMRlMgaXMgbm90IHNldAojIENPTkZJ
R19MSU5FNl9VU0IgaXMgbm90IHNldAojIENPTkZJR19VU0JfU0VSSUFMX1FVQVRFQ0gyIGlz
IG5vdCBzZXQKIyBDT05GSUdfVVNCX1NFUklBTF9RVUFURUNIX1VTQjIgaXMgbm90IHNldAoj
IENPTkZJR19WVDY2NTYgaXMgbm90IHNldAojIENPTkZJR19JSU8gaXMgbm90IHNldApDT05G
SUdfWFZNQUxMT0M9eQpDT05GSUdfWlJBTT1tCiMgQ09ORklHX1pSQU1fREVCVUcgaXMgbm90
IHNldApDT05GSUdfWkNBQ0hFPXkKIyBDT05GSUdfRkJfU003WFggaXMgbm90IHNldApDT05G
SUdfTElSQ19TVEFHSU5HPXkKQ09ORklHX0xJUkNfSUdPUlBMVUdVU0I9bQpDT05GSUdfTElS
Q19JTU9OPW0KQ09ORklHX0xJUkNfU0FTRU09bQpDT05GSUdfTElSQ19TRVJJQUw9bQpDT05G
SUdfTElSQ19TRVJJQUxfVFJBTlNNSVRURVI9eQpDT05GSUdfTElSQ19TSVI9bQpDT05GSUdf
TElSQ19UVFVTQklSPW0KQ09ORklHX0xJUkNfWklMT0c9bQojIENPTkZJR19FQVNZQ0FQIGlz
IG5vdCBzZXQKQ09ORklHX1RJRFNQQlJJREdFPW0KQ09ORklHX1RJRFNQQlJJREdFX01FTVBP
T0xfU0laRT0weDYwMDAwMAojIENPTkZJR19USURTUEJSSURHRV9ERUJVRyBpcyBub3Qgc2V0
CkNPTkZJR19USURTUEJSSURHRV9SRUNPVkVSWT15CiMgQ09ORklHX1RJRFNQQlJJREdFX0NB
Q0hFX0xJTkVfQ0hFQ0sgaXMgbm90IHNldApDT05GSUdfVElEU1BCUklER0VfV0RUMz15CkNP
TkZJR19USURTUEJSSURHRV9XRFRfVElNRU9VVD01CiMgQ09ORklHX1RJRFNQQlJJREdFX05U
RllfUFdSRVJSIGlzIG5vdCBzZXQKIyBDT05GSUdfVElEU1BCUklER0VfQkFDS1RSQUNFIGlz
IG5vdCBzZXQKIyBDT05GSUdfQVRINktfTEVHQUNZIGlzIG5vdCBzZXQKQ09ORklHX1VTQl9F
TkVTVE9SQUdFPW0KIyBDT05GSUdfQkNNX1dJTUFYIGlzIG5vdCBzZXQKIyBDT05GSUdfRlQx
MDAwIGlzIG5vdCBzZXQKCiMKIyBTcGVha3VwIGNvbnNvbGUgc3BlZWNoCiMKIyBDT05GSUdf
U1BFQUtVUCBpcyBub3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NSRUVOX0NMRUFSUEFEX1RNMTIx
NyBpcyBub3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NSRUVOX1NZTkFQVElDU19JMkNfUk1JNCBp
cyBub3Qgc2V0CiMgQ09ORklHX0FMVEVSQV9TVEFQTCBpcyBub3Qgc2V0CkNPTkZJR19PTUFQ
M19TR1g9eQpDT05GSUdfQ0xLREVWX0xPT0tVUD15CiMgQ09ORklHX0hXU1BJTkxPQ0sgaXMg
bm90IHNldApDT05GSUdfQ0xLU1JDX01NSU89eQpDT05GSUdfSU9NTVVfU1VQUE9SVD15CiMg
Q09ORklHX1ZJUlRfRFJJVkVSUyBpcyBub3Qgc2V0CgojCiMgRmlsZSBzeXN0ZW1zCiMKQ09O
RklHX0VYVDJfRlM9eQpDT05GSUdfRVhUMl9GU19YQVRUUj15CkNPTkZJR19FWFQyX0ZTX1BP
U0lYX0FDTD15CkNPTkZJR19FWFQyX0ZTX1NFQ1VSSVRZPXkKIyBDT05GSUdfRVhUMl9GU19Y
SVAgaXMgbm90IHNldApDT05GSUdfRVhUM19GUz15CkNPTkZJR19FWFQzX0RFRkFVTFRTX1RP
X09SREVSRUQ9eQpDT05GSUdfRVhUM19GU19YQVRUUj15CkNPTkZJR19FWFQzX0ZTX1BPU0lY
X0FDTD15CkNPTkZJR19FWFQzX0ZTX1NFQ1VSSVRZPXkKQ09ORklHX0VYVDRfRlM9eQpDT05G
SUdfRVhUNF9GU19YQVRUUj15CkNPTkZJR19FWFQ0X0ZTX1BPU0lYX0FDTD15CkNPTkZJR19F
WFQ0X0ZTX1NFQ1VSSVRZPXkKIyBDT05GSUdfRVhUNF9ERUJVRyBpcyBub3Qgc2V0CkNPTkZJ
R19KQkQ9eQojIENPTkZJR19KQkRfREVCVUcgaXMgbm90IHNldApDT05GSUdfSkJEMj15CiMg
Q09ORklHX0pCRDJfREVCVUcgaXMgbm90IHNldApDT05GSUdfRlNfTUJDQUNIRT15CkNPTkZJ
R19SRUlTRVJGU19GUz1tCiMgQ09ORklHX1JFSVNFUkZTX0NIRUNLIGlzIG5vdCBzZXQKIyBD
T05GSUdfUkVJU0VSRlNfUFJPQ19JTkZPIGlzIG5vdCBzZXQKQ09ORklHX1JFSVNFUkZTX0ZT
X1hBVFRSPXkKQ09ORklHX1JFSVNFUkZTX0ZTX1BPU0lYX0FDTD15CkNPTkZJR19SRUlTRVJG
U19GU19TRUNVUklUWT15CkNPTkZJR19KRlNfRlM9bQpDT05GSUdfSkZTX1BPU0lYX0FDTD15
CkNPTkZJR19KRlNfU0VDVVJJVFk9eQojIENPTkZJR19KRlNfREVCVUcgaXMgbm90IHNldApD
T05GSUdfSkZTX1NUQVRJU1RJQ1M9eQpDT05GSUdfWEZTX0ZTPW0KQ09ORklHX1hGU19RVU9U
QT15CkNPTkZJR19YRlNfUE9TSVhfQUNMPXkKQ09ORklHX1hGU19SVD15CiMgQ09ORklHX1hG
U19ERUJVRyBpcyBub3Qgc2V0CkNPTkZJR19HRlMyX0ZTPW0KQ09ORklHX0dGUzJfRlNfTE9D
S0lOR19ETE09eQpDT05GSUdfT0NGUzJfRlM9bQpDT05GSUdfT0NGUzJfRlNfTzJDQj1tCkNP
TkZJR19PQ0ZTMl9GU19VU0VSU1BBQ0VfQ0xVU1RFUj1tCkNPTkZJR19PQ0ZTMl9GU19TVEFU
Uz15CkNPTkZJR19PQ0ZTMl9ERUJVR19NQVNLTE9HPXkKIyBDT05GSUdfT0NGUzJfREVCVUdf
RlMgaXMgbm90IHNldApDT05GSUdfQlRSRlNfRlM9eQpDT05GSUdfQlRSRlNfRlNfUE9TSVhf
QUNMPXkKQ09ORklHX05JTEZTMl9GUz1tCkNPTkZJR19GU19QT1NJWF9BQ0w9eQpDT05GSUdf
RVhQT1JURlM9eQpDT05GSUdfRklMRV9MT0NLSU5HPXkKQ09ORklHX0ZTTk9USUZZPXkKQ09O
RklHX0ROT1RJRlk9eQpDT05GSUdfSU5PVElGWV9VU0VSPXkKQ09ORklHX0ZBTk9USUZZPXkK
Q09ORklHX0ZBTk9USUZZX0FDQ0VTU19QRVJNSVNTSU9OUz15CkNPTkZJR19RVU9UQT15CkNP
TkZJR19RVU9UQV9ORVRMSU5LX0lOVEVSRkFDRT15CkNPTkZJR19QUklOVF9RVU9UQV9XQVJO
SU5HPXkKIyBDT05GSUdfUVVPVEFfREVCVUcgaXMgbm90IHNldApDT05GSUdfUVVPVEFfVFJF
RT1tCkNPTkZJR19RRk1UX1YxPW0KQ09ORklHX1FGTVRfVjI9bQpDT05GSUdfUVVPVEFDVEw9
eQpDT05GSUdfQVVUT0ZTNF9GUz1tCkNPTkZJR19GVVNFX0ZTPXkKQ09ORklHX0NVU0U9bQpD
T05GSUdfR0VORVJJQ19BQ0w9eQoKIwojIENhY2hlcwojCkNPTkZJR19GU0NBQ0hFPW0KQ09O
RklHX0ZTQ0FDSEVfU1RBVFM9eQpDT05GSUdfRlNDQUNIRV9ISVNUT0dSQU09eQojIENPTkZJ
R19GU0NBQ0hFX0RFQlVHIGlzIG5vdCBzZXQKIyBDT05GSUdfRlNDQUNIRV9PQkpFQ1RfTElT
VCBpcyBub3Qgc2V0CkNPTkZJR19DQUNIRUZJTEVTPW0KIyBDT05GSUdfQ0FDSEVGSUxFU19E
RUJVRyBpcyBub3Qgc2V0CiMgQ09ORklHX0NBQ0hFRklMRVNfSElTVE9HUkFNIGlzIG5vdCBz
ZXQKCiMKIyBDRC1ST00vRFZEIEZpbGVzeXN0ZW1zCiMKQ09ORklHX0lTTzk2NjBfRlM9bQpD
T05GSUdfSk9MSUVUPXkKQ09ORklHX1pJU09GUz15CkNPTkZJR19VREZfRlM9bQpDT05GSUdf
VURGX05MUz15CgojCiMgRE9TL0ZBVC9OVCBGaWxlc3lzdGVtcwojCkNPTkZJR19GQVRfRlM9
eQpDT05GSUdfTVNET1NfRlM9eQpDT05GSUdfVkZBVF9GUz15CkNPTkZJR19GQVRfREVGQVVM
VF9DT0RFUEFHRT00MzcKQ09ORklHX0ZBVF9ERUZBVUxUX0lPQ0hBUlNFVD0iaXNvODg1OS0x
IgpDT05GSUdfTlRGU19GUz1tCiMgQ09ORklHX05URlNfREVCVUcgaXMgbm90IHNldAojIENP
TkZJR19OVEZTX1JXIGlzIG5vdCBzZXQKCiMKIyBQc2V1ZG8gZmlsZXN5c3RlbXMKIwpDT05G
SUdfUFJPQ19GUz15CkNPTkZJR19QUk9DX1NZU0NUTD15CkNPTkZJR19QUk9DX1BBR0VfTU9O
SVRPUj15CkNPTkZJR19TWVNGUz15CkNPTkZJR19UTVBGUz15CkNPTkZJR19UTVBGU19QT1NJ
WF9BQ0w9eQpDT05GSUdfVE1QRlNfWEFUVFI9eQojIENPTkZJR19IVUdFVExCX1BBR0UgaXMg
bm90IHNldApDT05GSUdfQ09ORklHRlNfRlM9eQpDT05GSUdfTUlTQ19GSUxFU1lTVEVNUz15
CiMgQ09ORklHX0FERlNfRlMgaXMgbm90IHNldApDT05GSUdfQUZGU19GUz1tCkNPTkZJR19F
Q1JZUFRfRlM9eQpDT05GSUdfSEZTX0ZTPW0KQ09ORklHX0hGU1BMVVNfRlM9bQpDT05GSUdf
QkVGU19GUz1tCiMgQ09ORklHX0JFRlNfREVCVUcgaXMgbm90IHNldApDT05GSUdfQkZTX0ZT
PW0KQ09ORklHX0VGU19GUz1tCkNPTkZJR19KRkZTMl9GUz1tCkNPTkZJR19KRkZTMl9GU19E
RUJVRz0wCkNPTkZJR19KRkZTMl9GU19XUklURUJVRkZFUj15CiMgQ09ORklHX0pGRlMyX0ZT
X1dCVUZfVkVSSUZZIGlzIG5vdCBzZXQKIyBDT05GSUdfSkZGUzJfU1VNTUFSWSBpcyBub3Qg
c2V0CiMgQ09ORklHX0pGRlMyX0ZTX1hBVFRSIGlzIG5vdCBzZXQKQ09ORklHX0pGRlMyX0NP
TVBSRVNTSU9OX09QVElPTlM9eQpDT05GSUdfSkZGUzJfWkxJQj15CkNPTkZJR19KRkZTMl9M
Wk89eQpDT05GSUdfSkZGUzJfUlRJTUU9eQojIENPTkZJR19KRkZTMl9SVUJJTiBpcyBub3Qg
c2V0CiMgQ09ORklHX0pGRlMyX0NNT0RFX05PTkUgaXMgbm90IHNldAojIENPTkZJR19KRkZT
Ml9DTU9ERV9QUklPUklUWSBpcyBub3Qgc2V0CiMgQ09ORklHX0pGRlMyX0NNT0RFX1NJWkUg
aXMgbm90IHNldApDT05GSUdfSkZGUzJfQ01PREVfRkFWT1VSTFpPPXkKQ09ORklHX1VCSUZT
X0ZTPW0KQ09ORklHX1VCSUZTX0ZTX1hBVFRSPXkKIyBDT05GSUdfVUJJRlNfRlNfQURWQU5D
RURfQ09NUFIgaXMgbm90IHNldApDT05GSUdfVUJJRlNfRlNfTFpPPXkKQ09ORklHX1VCSUZT
X0ZTX1pMSUI9eQojIENPTkZJR19VQklGU19GU19ERUJVRyBpcyBub3Qgc2V0CkNPTkZJR19M
T0dGUz1tCkNPTkZJR19DUkFNRlM9bQpDT05GSUdfU1FVQVNIRlM9bQojIENPTkZJR19TUVVB
U0hGU19YQVRUUiBpcyBub3Qgc2V0CkNPTkZJR19TUVVBU0hGU19aTElCPXkKIyBDT05GSUdf
U1FVQVNIRlNfTFpPIGlzIG5vdCBzZXQKIyBDT05GSUdfU1FVQVNIRlNfWFogaXMgbm90IHNl
dAojIENPTkZJR19TUVVBU0hGU19FTUJFRERFRCBpcyBub3Qgc2V0CkNPTkZJR19TUVVBU0hG
U19GUkFHTUVOVF9DQUNIRV9TSVpFPTMKQ09ORklHX1ZYRlNfRlM9bQpDT05GSUdfTUlOSVhf
RlM9bQpDT05GSUdfT01GU19GUz1tCiMgQ09ORklHX0hQRlNfRlMgaXMgbm90IHNldApDT05G
SUdfUU5YNEZTX0ZTPW0KQ09ORklHX1JPTUZTX0ZTPW0KQ09ORklHX1JPTUZTX0JBQ0tFRF9C
WV9CTE9DSz15CiMgQ09ORklHX1JPTUZTX0JBQ0tFRF9CWV9NVEQgaXMgbm90IHNldAojIENP
TkZJR19ST01GU19CQUNLRURfQllfQk9USCBpcyBub3Qgc2V0CkNPTkZJR19ST01GU19PTl9C
TE9DSz15CiMgQ09ORklHX1BTVE9SRSBpcyBub3Qgc2V0CkNPTkZJR19TWVNWX0ZTPW0KIyBD
T05GSUdfVUZTX0ZTIGlzIG5vdCBzZXQKQ09ORklHX05FVFdPUktfRklMRVNZU1RFTVM9eQpD
T05GSUdfTkZTX0ZTPXkKQ09ORklHX05GU19WMz15CkNPTkZJR19ORlNfVjNfQUNMPXkKQ09O
RklHX05GU19WND15CiMgQ09ORklHX05GU19WNF8xIGlzIG5vdCBzZXQKQ09ORklHX1JPT1Rf
TkZTPXkKIyBDT05GSUdfTkZTX1VTRV9MRUdBQ1lfRE5TIGlzIG5vdCBzZXQKQ09ORklHX05G
U19VU0VfS0VSTkVMX0ROUz15CiMgQ09ORklHX05GU19VU0VfTkVXX0lETUFQUEVSIGlzIG5v
dCBzZXQKQ09ORklHX05GU0Q9bQpDT05GSUdfTkZTRF9WMl9BQ0w9eQpDT05GSUdfTkZTRF9W
Mz15CkNPTkZJR19ORlNEX1YzX0FDTD15CkNPTkZJR19ORlNEX1Y0PXkKQ09ORklHX0xPQ0tE
PXkKQ09ORklHX0xPQ0tEX1Y0PXkKQ09ORklHX05GU19BQ0xfU1VQUE9SVD15CkNPTkZJR19O
RlNfQ09NTU9OPXkKQ09ORklHX1NVTlJQQz15CkNPTkZJR19TVU5SUENfR1NTPXkKQ09ORklH
X1JQQ1NFQ19HU1NfS1JCNT1tCkNPTkZJR19DRVBIX0ZTPW0KQ09ORklHX0NJRlM9bQojIENP
TkZJR19DSUZTX1NUQVRTIGlzIG5vdCBzZXQKQ09ORklHX0NJRlNfV0VBS19QV19IQVNIPXkK
Q09ORklHX0NJRlNfVVBDQUxMPXkKQ09ORklHX0NJRlNfWEFUVFI9eQpDT05GSUdfQ0lGU19Q
T1NJWD15CiMgQ09ORklHX0NJRlNfREVCVUcyIGlzIG5vdCBzZXQKQ09ORklHX0NJRlNfREZT
X1VQQ0FMTD15CiMgQ09ORklHX0NJRlNfRlNDQUNIRSBpcyBub3Qgc2V0CiMgQ09ORklHX0NJ
RlNfQUNMIGlzIG5vdCBzZXQKQ09ORklHX05DUF9GUz1tCkNPTkZJR19OQ1BGU19QQUNLRVRf
U0lHTklORz15CkNPTkZJR19OQ1BGU19JT0NUTF9MT0NLSU5HPXkKQ09ORklHX05DUEZTX1NU
Uk9ORz15CkNPTkZJR19OQ1BGU19ORlNfTlM9eQpDT05GSUdfTkNQRlNfT1MyX05TPXkKIyBD
T05GSUdfTkNQRlNfU01BTExET1MgaXMgbm90IHNldApDT05GSUdfTkNQRlNfTkxTPXkKQ09O
RklHX05DUEZTX0VYVFJBUz15CkNPTkZJR19DT0RBX0ZTPW0KQ09ORklHX0FGU19GUz1tCiMg
Q09ORklHX0FGU19ERUJVRyBpcyBub3Qgc2V0CiMgQ09ORklHX0FGU19GU0NBQ0hFIGlzIG5v
dCBzZXQKQ09ORklHXzlQX0ZTPW0KIyBDT05GSUdfOVBfRlNDQUNIRSBpcyBub3Qgc2V0CkNP
TkZJR185UF9GU19QT1NJWF9BQ0w9eQoKIwojIFBhcnRpdGlvbiBUeXBlcwojCkNPTkZJR19Q
QVJUSVRJT05fQURWQU5DRUQ9eQpDT05GSUdfQUNPUk5fUEFSVElUSU9OPXkKIyBDT05GSUdf
QUNPUk5fUEFSVElUSU9OX0NVTUFOQSBpcyBub3Qgc2V0CiMgQ09ORklHX0FDT1JOX1BBUlRJ
VElPTl9FRVNPWCBpcyBub3Qgc2V0CkNPTkZJR19BQ09STl9QQVJUSVRJT05fSUNTPXkKIyBD
T05GSUdfQUNPUk5fUEFSVElUSU9OX0FERlMgaXMgbm90IHNldAojIENPTkZJR19BQ09STl9Q
QVJUSVRJT05fUE9XRVJURUMgaXMgbm90IHNldApDT05GSUdfQUNPUk5fUEFSVElUSU9OX1JJ
U0NJWD15CkNPTkZJR19PU0ZfUEFSVElUSU9OPXkKQ09ORklHX0FNSUdBX1BBUlRJVElPTj15
CkNPTkZJR19BVEFSSV9QQVJUSVRJT049eQpDT05GSUdfTUFDX1BBUlRJVElPTj15CkNPTkZJ
R19NU0RPU19QQVJUSVRJT049eQpDT05GSUdfQlNEX0RJU0tMQUJFTD15CkNPTkZJR19NSU5J
WF9TVUJQQVJUSVRJT049eQpDT05GSUdfU09MQVJJU19YODZfUEFSVElUSU9OPXkKQ09ORklH
X1VOSVhXQVJFX0RJU0tMQUJFTD15CkNPTkZJR19MRE1fUEFSVElUSU9OPXkKIyBDT05GSUdf
TERNX0RFQlVHIGlzIG5vdCBzZXQKQ09ORklHX1NHSV9QQVJUSVRJT049eQpDT05GSUdfVUxU
UklYX1BBUlRJVElPTj15CkNPTkZJR19TVU5fUEFSVElUSU9OPXkKQ09ORklHX0tBUk1BX1BB
UlRJVElPTj15CkNPTkZJR19FRklfUEFSVElUSU9OPXkKQ09ORklHX1NZU1Y2OF9QQVJUSVRJ
T049eQpDT05GSUdfTkxTPXkKQ09ORklHX05MU19ERUZBVUxUPSJpc284ODU5LTEiCkNPTkZJ
R19OTFNfQ09ERVBBR0VfNDM3PXkKQ09ORklHX05MU19DT0RFUEFHRV83Mzc9bQpDT05GSUdf
TkxTX0NPREVQQUdFXzc3NT1tCkNPTkZJR19OTFNfQ09ERVBBR0VfODUwPW0KQ09ORklHX05M
U19DT0RFUEFHRV84NTI9bQpDT05GSUdfTkxTX0NPREVQQUdFXzg1NT1tCkNPTkZJR19OTFNf
Q09ERVBBR0VfODU3PW0KQ09ORklHX05MU19DT0RFUEFHRV84NjA9bQpDT05GSUdfTkxTX0NP
REVQQUdFXzg2MT1tCkNPTkZJR19OTFNfQ09ERVBBR0VfODYyPW0KQ09ORklHX05MU19DT0RF
UEFHRV84NjM9bQpDT05GSUdfTkxTX0NPREVQQUdFXzg2ND1tCkNPTkZJR19OTFNfQ09ERVBB
R0VfODY1PW0KQ09ORklHX05MU19DT0RFUEFHRV84NjY9bQpDT05GSUdfTkxTX0NPREVQQUdF
Xzg2OT1tCkNPTkZJR19OTFNfQ09ERVBBR0VfOTM2PW0KQ09ORklHX05MU19DT0RFUEFHRV85
NTA9bQpDT05GSUdfTkxTX0NPREVQQUdFXzkzMj1tCkNPTkZJR19OTFNfQ09ERVBBR0VfOTQ5
PW0KQ09ORklHX05MU19DT0RFUEFHRV84NzQ9bQpDT05GSUdfTkxTX0lTTzg4NTlfOD1tCkNP
TkZJR19OTFNfQ09ERVBBR0VfMTI1MD1tCkNPTkZJR19OTFNfQ09ERVBBR0VfMTI1MT1tCkNP
TkZJR19OTFNfQVNDSUk9bQpDT05GSUdfTkxTX0lTTzg4NTlfMT15CkNPTkZJR19OTFNfSVNP
ODg1OV8yPW0KQ09ORklHX05MU19JU084ODU5XzM9bQpDT05GSUdfTkxTX0lTTzg4NTlfND1t
CkNPTkZJR19OTFNfSVNPODg1OV81PW0KQ09ORklHX05MU19JU084ODU5XzY9bQpDT05GSUdf
TkxTX0lTTzg4NTlfNz1tCkNPTkZJR19OTFNfSVNPODg1OV85PW0KQ09ORklHX05MU19JU084
ODU5XzEzPW0KQ09ORklHX05MU19JU084ODU5XzE0PW0KQ09ORklHX05MU19JU084ODU5XzE1
PW0KQ09ORklHX05MU19LT0k4X1I9bQpDT05GSUdfTkxTX0tPSThfVT1tCkNPTkZJR19OTFNf
VVRGOD1tCkNPTkZJR19ETE09bQojIENPTkZJR19ETE1fREVCVUcgaXMgbm90IHNldAoKIwoj
IEtlcm5lbCBoYWNraW5nCiMKQ09ORklHX1BSSU5US19USU1FPXkKQ09ORklHX0RFRkFVTFRf
TUVTU0FHRV9MT0dMRVZFTD00CkNPTkZJR19FTkFCTEVfV0FSTl9ERVBSRUNBVEVEPXkKQ09O
RklHX0VOQUJMRV9NVVNUX0NIRUNLPXkKQ09ORklHX0ZSQU1FX1dBUk49MTAyNApDT05GSUdf
TUFHSUNfU1lTUlE9eQojIENPTkZJR19TVFJJUF9BU01fU1lNUyBpcyBub3Qgc2V0CkNPTkZJ
R19VTlVTRURfU1lNQk9MUz15CkNPTkZJR19ERUJVR19GUz15CiMgQ09ORklHX0hFQURFUlNf
Q0hFQ0sgaXMgbm90IHNldAojIENPTkZJR19ERUJVR19TRUNUSU9OX01JU01BVENIIGlzIG5v
dCBzZXQKQ09ORklHX0RFQlVHX0tFUk5FTD15CiMgQ09ORklHX0RFQlVHX1NISVJRIGlzIG5v
dCBzZXQKIyBDT05GSUdfTE9DS1VQX0RFVEVDVE9SIGlzIG5vdCBzZXQKIyBDT05GSUdfSEFS
RExPQ0tVUF9ERVRFQ1RPUiBpcyBub3Qgc2V0CkNPTkZJR19ERVRFQ1RfSFVOR19UQVNLPXkK
Q09ORklHX0RFRkFVTFRfSFVOR19UQVNLX1RJTUVPVVQ9MTIwCiMgQ09ORklHX0JPT1RQQVJB
TV9IVU5HX1RBU0tfUEFOSUMgaXMgbm90IHNldApDT05GSUdfQk9PVFBBUkFNX0hVTkdfVEFT
S19QQU5JQ19WQUxVRT0wCkNPTkZJR19TQ0hFRF9ERUJVRz15CkNPTkZJR19TQ0hFRFNUQVRT
PXkKQ09ORklHX1RJTUVSX1NUQVRTPXkKIyBDT05GSUdfREVCVUdfT0JKRUNUUyBpcyBub3Qg
c2V0CiMgQ09ORklHX1NMVUJfREVCVUdfT04gaXMgbm90IHNldAojIENPTkZJR19TTFVCX1NU
QVRTIGlzIG5vdCBzZXQKIyBDT05GSUdfREVCVUdfS01FTUxFQUsgaXMgbm90IHNldApDT05G
SUdfREVCVUdfUFJFRU1QVD15CiMgQ09ORklHX0RFQlVHX1JUX01VVEVYRVMgaXMgbm90IHNl
dAojIENPTkZJR19SVF9NVVRFWF9URVNURVIgaXMgbm90IHNldAojIENPTkZJR19ERUJVR19T
UElOTE9DSyBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX01VVEVYRVMgaXMgbm90IHNldAoj
IENPTkZJR19ERUJVR19MT0NLX0FMTE9DIGlzIG5vdCBzZXQKIyBDT05GSUdfUFJPVkVfTE9D
S0lORyBpcyBub3Qgc2V0CiMgQ09ORklHX1NQQVJTRV9SQ1VfUE9JTlRFUiBpcyBub3Qgc2V0
CiMgQ09ORklHX0xPQ0tfU1RBVCBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX0FUT01JQ19T
TEVFUCBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX0xPQ0tJTkdfQVBJX1NFTEZURVNUUyBp
cyBub3Qgc2V0CkNPTkZJR19TVEFDS1RSQUNFPXkKIyBDT05GSUdfREVCVUdfU1RBQ0tfVVNB
R0UgaXMgbm90IHNldAojIENPTkZJR19ERUJVR19LT0JKRUNUIGlzIG5vdCBzZXQKIyBDT05G
SUdfREVCVUdfSElHSE1FTSBpcyBub3Qgc2V0CkNPTkZJR19ERUJVR19CVUdWRVJCT1NFPXkK
IyBDT05GSUdfREVCVUdfSU5GTyBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX1ZNIGlzIG5v
dCBzZXQKIyBDT05GSUdfREVCVUdfV1JJVEVDT1VOVCBpcyBub3Qgc2V0CiMgQ09ORklHX0RF
QlVHX01FTU9SWV9JTklUIGlzIG5vdCBzZXQKIyBDT05GSUdfREVCVUdfTElTVCBpcyBub3Qg
c2V0CiMgQ09ORklHX1RFU1RfTElTVF9TT1JUIGlzIG5vdCBzZXQKIyBDT05GSUdfREVCVUdf
U0cgaXMgbm90IHNldAojIENPTkZJR19ERUJVR19OT1RJRklFUlMgaXMgbm90IHNldAojIENP
TkZJR19ERUJVR19DUkVERU5USUFMUyBpcyBub3Qgc2V0CiMgQ09ORklHX0JPT1RfUFJJTlRL
X0RFTEFZIGlzIG5vdCBzZXQKIyBDT05GSUdfUkNVX1RPUlRVUkVfVEVTVCBpcyBub3Qgc2V0
CkNPTkZJR19SQ1VfQ1BVX1NUQUxMX1RJTUVPVVQ9NjAKQ09ORklHX1JDVV9DUFVfU1RBTExf
VkVSQk9TRT15CiMgQ09ORklHX0tQUk9CRVNfU0FOSVRZX1RFU1QgaXMgbm90IHNldAojIENP
TkZJR19CQUNLVFJBQ0VfU0VMRl9URVNUIGlzIG5vdCBzZXQKIyBDT05GSUdfREVCVUdfQkxP
Q0tfRVhUX0RFVlQgaXMgbm90IHNldAojIENPTkZJR19ERUJVR19GT1JDRV9XRUFLX1BFUl9D
UFUgaXMgbm90IHNldAojIENPTkZJR19ERUJVR19QRVJfQ1BVX01BUFMgaXMgbm90IHNldAoj
IENPTkZJR19MS0RUTSBpcyBub3Qgc2V0CiMgQ09ORklHX0NQVV9OT1RJRklFUl9FUlJPUl9J
TkpFQ1QgaXMgbm90IHNldAojIENPTkZJR19GQVVMVF9JTkpFQ1RJT04gaXMgbm90IHNldApD
T05GSUdfU1lTQ1RMX1NZU0NBTExfQ0hFQ0s9eQojIENPTkZJR19ERUJVR19QQUdFQUxMT0Mg
aXMgbm90IHNldApDT05GSUdfTk9QX1RSQUNFUj15CkNPTkZJR19IQVZFX0ZVTkNUSU9OX1RS
QUNFUj15CkNPTkZJR19IQVZFX0ZVTkNUSU9OX0dSQVBIX1RSQUNFUj15CkNPTkZJR19IQVZF
X0RZTkFNSUNfRlRSQUNFPXkKQ09ORklHX0hBVkVfRlRSQUNFX01DT1VOVF9SRUNPUkQ9eQpD
T05GSUdfSEFWRV9DX1JFQ09SRE1DT1VOVD15CkNPTkZJR19UUkFDRVJfTUFYX1RSQUNFPXkK
Q09ORklHX1JJTkdfQlVGRkVSPXkKQ09ORklHX0VWRU5UX1RSQUNJTkc9eQpDT05GSUdfRVZF
TlRfUE9XRVJfVFJBQ0lOR19ERVBSRUNBVEVEPXkKQ09ORklHX0NPTlRFWFRfU1dJVENIX1RS
QUNFUj15CkNPTkZJR19SSU5HX0JVRkZFUl9BTExPV19TV0FQPXkKQ09ORklHX1RSQUNJTkc9
eQpDT05GSUdfR0VORVJJQ19UUkFDRVI9eQpDT05GSUdfVFJBQ0lOR19TVVBQT1JUPXkKQ09O
RklHX0ZUUkFDRT15CiMgQ09ORklHX0ZVTkNUSU9OX1RSQUNFUiBpcyBub3Qgc2V0CiMgQ09O
RklHX0lSUVNPRkZfVFJBQ0VSIGlzIG5vdCBzZXQKIyBDT05GSUdfUFJFRU1QVF9UUkFDRVIg
aXMgbm90IHNldApDT05GSUdfU0NIRURfVFJBQ0VSPXkKQ09ORklHX0JSQU5DSF9QUk9GSUxF
X05PTkU9eQojIENPTkZJR19QUk9GSUxFX0FOTk9UQVRFRF9CUkFOQ0hFUyBpcyBub3Qgc2V0
CiMgQ09ORklHX1BST0ZJTEVfQUxMX0JSQU5DSEVTIGlzIG5vdCBzZXQKIyBDT05GSUdfU1RB
Q0tfVFJBQ0VSIGlzIG5vdCBzZXQKQ09ORklHX0JMS19ERVZfSU9fVFJBQ0U9eQpDT05GSUdf
S1BST0JFX0VWRU5UPXkKIyBDT05GSUdfRlRSQUNFX1NUQVJUVVBfVEVTVCBpcyBub3Qgc2V0
CiMgQ09ORklHX1JJTkdfQlVGRkVSX0JFTkNITUFSSyBpcyBub3Qgc2V0CiMgQ09ORklHX0RZ
TkFNSUNfREVCVUcgaXMgbm90IHNldAojIENPTkZJR19ETUFfQVBJX0RFQlVHIGlzIG5vdCBz
ZXQKIyBDT05GSUdfQVRPTUlDNjRfU0VMRlRFU1QgaXMgbm90IHNldApDT05GSUdfQVNZTkNf
UkFJRDZfVEVTVD1tCiMgQ09ORklHX1NBTVBMRVMgaXMgbm90IHNldApDT05GSUdfSEFWRV9B
UkNIX0tHREI9eQpDT05GSUdfS0dEQj15CkNPTkZJR19LR0RCX1NFUklBTF9DT05TT0xFPXkK
IyBDT05GSUdfS0dEQl9URVNUUyBpcyBub3Qgc2V0CkNPTkZJR19LR0RCX0tEQj15CkNPTkZJ
R19LREJfS0VZQk9BUkQ9eQojIENPTkZJR19URVNUX0tTVFJUT1ggaXMgbm90IHNldApDT05G
SUdfU1RSSUNUX0RFVk1FTT15CkNPTkZJR19BUk1fVU5XSU5EPXkKQ09ORklHX0RFQlVHX1VT
RVI9eQpDT05GSUdfREVCVUdfTEw9eQpDT05GSUdfRUFSTFlfUFJJTlRLPXkKIyBDT05GSUdf
REVCVUdfSUNFRENDIGlzIG5vdCBzZXQKQ09ORklHX09DX0VUTT15CgojCiMgU2VjdXJpdHkg
b3B0aW9ucwojCkNPTkZJR19LRVlTPXkKIyBDT05GSUdfS0VZU19ERUJVR19QUk9DX0tFWVMg
aXMgbm90IHNldAojIENPTkZJR19TRUNVUklUWV9ETUVTR19SRVNUUklDVCBpcyBub3Qgc2V0
CkNPTkZJR19TRUNVUklUWT15CkNPTkZJR19TRUNVUklUWUZTPXkKQ09ORklHX1NFQ1VSSVRZ
X05FVFdPUks9eQojIENPTkZJR19TRUNVUklUWV9ORVRXT1JLX1hGUk0gaXMgbm90IHNldApD
T05GSUdfU0VDVVJJVFlfUEFUSD15CkNPTkZJR19MU01fTU1BUF9NSU5fQUREUj0wCkNPTkZJ
R19TRUNVUklUWV9TRUxJTlVYPXkKQ09ORklHX1NFQ1VSSVRZX1NFTElOVVhfQk9PVFBBUkFN
PXkKQ09ORklHX1NFQ1VSSVRZX1NFTElOVVhfQk9PVFBBUkFNX1ZBTFVFPTAKQ09ORklHX1NF
Q1VSSVRZX1NFTElOVVhfRElTQUJMRT15CkNPTkZJR19TRUNVUklUWV9TRUxJTlVYX0RFVkVM
T1A9eQpDT05GSUdfU0VDVVJJVFlfU0VMSU5VWF9BVkNfU1RBVFM9eQpDT05GSUdfU0VDVVJJ
VFlfU0VMSU5VWF9DSEVDS1JFUVBST1RfVkFMVUU9MQojIENPTkZJR19TRUNVUklUWV9TRUxJ
TlVYX1BPTElDWURCX1ZFUlNJT05fTUFYIGlzIG5vdCBzZXQKQ09ORklHX1NFQ1VSSVRZX1NN
QUNLPXkKQ09ORklHX1NFQ1VSSVRZX1RPTU9ZTz15CkNPTkZJR19TRUNVUklUWV9UT01PWU9f
TUFYX0FDQ0VQVF9FTlRSWT0yMDQ4CkNPTkZJR19TRUNVUklUWV9UT01PWU9fTUFYX0FVRElU
X0xPRz0xMDI0CiMgQ09ORklHX1NFQ1VSSVRZX1RPTU9ZT19PTUlUX1VTRVJTUEFDRV9MT0FE
RVIgaXMgbm90IHNldApDT05GSUdfU0VDVVJJVFlfVE9NT1lPX1BPTElDWV9MT0FERVI9Ii9z
YmluL3RvbW95by1pbml0IgpDT05GSUdfU0VDVVJJVFlfVE9NT1lPX0FDVElWQVRJT05fVFJJ
R0dFUj0iL3NiaW4vaW5pdCIKQ09ORklHX1NFQ1VSSVRZX0FQUEFSTU9SPXkKQ09ORklHX1NF
Q1VSSVRZX0FQUEFSTU9SX0JPT1RQQVJBTV9WQUxVRT0xCiMgQ09ORklHX0lNQSBpcyBub3Qg
c2V0CiMgQ09ORklHX0RFRkFVTFRfU0VDVVJJVFlfU0VMSU5VWCBpcyBub3Qgc2V0CiMgQ09O
RklHX0RFRkFVTFRfU0VDVVJJVFlfU01BQ0sgaXMgbm90IHNldAojIENPTkZJR19ERUZBVUxU
X1NFQ1VSSVRZX1RPTU9ZTyBpcyBub3Qgc2V0CkNPTkZJR19ERUZBVUxUX1NFQ1VSSVRZX0FQ
UEFSTU9SPXkKIyBDT05GSUdfREVGQVVMVF9TRUNVUklUWV9EQUMgaXMgbm90IHNldApDT05G
SUdfREVGQVVMVF9TRUNVUklUWT0iYXBwYXJtb3IiCkNPTkZJR19YT1JfQkxPQ0tTPW0KQ09O
RklHX0FTWU5DX0NPUkU9bQpDT05GSUdfQVNZTkNfTUVNQ1BZPW0KQ09ORklHX0FTWU5DX1hP
Uj1tCkNPTkZJR19BU1lOQ19QUT1tCkNPTkZJR19BU1lOQ19SQUlENl9SRUNPVj1tCkNPTkZJ
R19DUllQVE89eQoKIwojIENyeXB0byBjb3JlIG9yIGhlbHBlcgojCkNPTkZJR19DUllQVE9f
QUxHQVBJPXkKQ09ORklHX0NSWVBUT19BTEdBUEkyPXkKQ09ORklHX0NSWVBUT19BRUFEPW0K
Q09ORklHX0NSWVBUT19BRUFEMj15CkNPTkZJR19DUllQVE9fQkxLQ0lQSEVSPXkKQ09ORklH
X0NSWVBUT19CTEtDSVBIRVIyPXkKQ09ORklHX0NSWVBUT19IQVNIPXkKQ09ORklHX0NSWVBU
T19IQVNIMj15CkNPTkZJR19DUllQVE9fUk5HPW0KQ09ORklHX0NSWVBUT19STkcyPXkKQ09O
RklHX0NSWVBUT19QQ09NUD1tCkNPTkZJR19DUllQVE9fUENPTVAyPXkKQ09ORklHX0NSWVBU
T19NQU5BR0VSPXkKQ09ORklHX0NSWVBUT19NQU5BR0VSMj15CkNPTkZJR19DUllQVE9fTUFO
QUdFUl9ESVNBQkxFX1RFU1RTPXkKQ09ORklHX0NSWVBUT19HRjEyOE1VTD1tCkNPTkZJR19D
UllQVE9fTlVMTD1tCiMgQ09ORklHX0NSWVBUT19QQ1JZUFQgaXMgbm90IHNldApDT05GSUdf
Q1JZUFRPX1dPUktRVUVVRT15CkNPTkZJR19DUllQVE9fQ1JZUFREPW0KQ09ORklHX0NSWVBU
T19BVVRIRU5DPW0KQ09ORklHX0NSWVBUT19URVNUPW0KCiMKIyBBdXRoZW50aWNhdGVkIEVu
Y3J5cHRpb24gd2l0aCBBc3NvY2lhdGVkIERhdGEKIwpDT05GSUdfQ1JZUFRPX0NDTT1tCkNP
TkZJR19DUllQVE9fR0NNPW0KQ09ORklHX0NSWVBUT19TRVFJVj1tCgojCiMgQmxvY2sgbW9k
ZXMKIwpDT05GSUdfQ1JZUFRPX0NCQz15CkNPTkZJR19DUllQVE9fQ1RSPW0KQ09ORklHX0NS
WVBUT19DVFM9bQpDT05GSUdfQ1JZUFRPX0VDQj15CkNPTkZJR19DUllQVE9fTFJXPW0KQ09O
RklHX0NSWVBUT19QQ0JDPW0KQ09ORklHX0NSWVBUT19YVFM9bQoKIwojIEhhc2ggbW9kZXMK
IwpDT05GSUdfQ1JZUFRPX0hNQUM9bQpDT05GSUdfQ1JZUFRPX1hDQkM9bQpDT05GSUdfQ1JZ
UFRPX1ZNQUM9bQoKIwojIERpZ2VzdAojCkNPTkZJR19DUllQVE9fQ1JDMzJDPXkKQ09ORklH
X0NSWVBUT19HSEFTSD1tCkNPTkZJR19DUllQVE9fTUQ0PW0KQ09ORklHX0NSWVBUT19NRDU9
eQpDT05GSUdfQ1JZUFRPX01JQ0hBRUxfTUlDPW0KQ09ORklHX0NSWVBUT19STUQxMjg9bQpD
T05GSUdfQ1JZUFRPX1JNRDE2MD1tCkNPTkZJR19DUllQVE9fUk1EMjU2PW0KQ09ORklHX0NS
WVBUT19STUQzMjA9bQpDT05GSUdfQ1JZUFRPX1NIQTE9eQpDT05GSUdfQ1JZUFRPX1NIQTI1
Nj1tCkNPTkZJR19DUllQVE9fU0hBNTEyPW0KQ09ORklHX0NSWVBUT19UR1IxOTI9bQpDT05G
SUdfQ1JZUFRPX1dQNTEyPW0KCiMKIyBDaXBoZXJzCiMKQ09ORklHX0NSWVBUT19BRVM9bQpD
T05GSUdfQ1JZUFRPX0FOVUJJUz1tCkNPTkZJR19DUllQVE9fQVJDND1tCkNPTkZJR19DUllQ
VE9fQkxPV0ZJU0g9bQpDT05GSUdfQ1JZUFRPX0NBTUVMTElBPW0KQ09ORklHX0NSWVBUT19D
QVNUNT1tCkNPTkZJR19DUllQVE9fQ0FTVDY9bQpDT05GSUdfQ1JZUFRPX0RFUz15CkNPTkZJ
R19DUllQVE9fRkNSWVBUPW0KQ09ORklHX0NSWVBUT19LSEFaQUQ9bQpDT05GSUdfQ1JZUFRP
X1NBTFNBMjA9bQpDT05GSUdfQ1JZUFRPX1NFRUQ9bQpDT05GSUdfQ1JZUFRPX1NFUlBFTlQ9
bQpDT05GSUdfQ1JZUFRPX1RFQT1tCkNPTkZJR19DUllQVE9fVFdPRklTSD1tCkNPTkZJR19D
UllQVE9fVFdPRklTSF9DT01NT049bQoKIwojIENvbXByZXNzaW9uCiMKQ09ORklHX0NSWVBU
T19ERUZMQVRFPW0KQ09ORklHX0NSWVBUT19aTElCPW0KQ09ORklHX0NSWVBUT19MWk89bQoK
IwojIFJhbmRvbSBOdW1iZXIgR2VuZXJhdGlvbgojCkNPTkZJR19DUllQVE9fQU5TSV9DUFJO
Rz1tCkNPTkZJR19DUllQVE9fVVNFUl9BUEk9bQpDT05GSUdfQ1JZUFRPX1VTRVJfQVBJX0hB
U0g9bQpDT05GSUdfQ1JZUFRPX1VTRVJfQVBJX1NLQ0lQSEVSPW0KQ09ORklHX0NSWVBUT19I
Vz15CkNPTkZJR19DUllQVE9fREVWX09NQVBfU0hBTT1tCkNPTkZJR19DUllQVE9fREVWX09N
QVBfQUVTPW0KQ09ORklHX0JJTkFSWV9QUklOVEY9eQoKIwojIExpYnJhcnkgcm91dGluZXMK
IwpDT05GSUdfUkFJRDZfUFE9bQpDT05GSUdfQklUUkVWRVJTRT15CkNPTkZJR19DUkNfQ0NJ
VFQ9bQpDT05GSUdfQ1JDMTY9eQpDT05GSUdfQ1JDX1QxMERJRj15CkNPTkZJR19DUkNfSVRV
X1Q9bQpDT05GSUdfQ1JDMzI9eQpDT05GSUdfQ1JDNz1tCkNPTkZJR19MSUJDUkMzMkM9eQpD
T05GSUdfQ1JDOD1tCkNPTkZJR19BVURJVF9HRU5FUklDPXkKQ09ORklHX1pMSUJfSU5GTEFU
RT15CkNPTkZJR19aTElCX0RFRkxBVEU9eQpDT05GSUdfTFpPX0NPTVBSRVNTPXkKQ09ORklH
X0xaT19ERUNPTVBSRVNTPXkKQ09ORklHX1haX0RFQz15CkNPTkZJR19YWl9ERUNfWDg2PXkK
Q09ORklHX1haX0RFQ19QT1dFUlBDPXkKQ09ORklHX1haX0RFQ19JQTY0PXkKQ09ORklHX1ha
X0RFQ19BUk09eQpDT05GSUdfWFpfREVDX0FSTVRIVU1CPXkKQ09ORklHX1haX0RFQ19TUEFS
Qz15CkNPTkZJR19YWl9ERUNfQkNKPXkKIyBDT05GSUdfWFpfREVDX1RFU1QgaXMgbm90IHNl
dApDT05GSUdfREVDT01QUkVTU19HWklQPXkKQ09ORklHX0RFQ09NUFJFU1NfQlpJUDI9eQpD
T05GSUdfREVDT01QUkVTU19MWk1BPXkKQ09ORklHX0RFQ09NUFJFU1NfWFo9eQpDT05GSUdf
REVDT01QUkVTU19MWk89eQpDT05GSUdfUkVFRF9TT0xPTU9OPW0KQ09ORklHX1JFRURfU09M
T01PTl9ERUMxNj15CkNPTkZJR19URVhUU0VBUkNIPXkKQ09ORklHX1RFWFRTRUFSQ0hfS01Q
PW0KQ09ORklHX1RFWFRTRUFSQ0hfQk09bQpDT05GSUdfVEVYVFNFQVJDSF9GU009bQpDT05G
SUdfQlRSRUU9eQpDT05GSUdfSEFTX0lPTUVNPXkKQ09ORklHX0hBU19JT1BPUlQ9eQpDT05G
SUdfSEFTX0RNQT15CkNPTkZJR19DUFVfUk1BUD15CkNPTkZJR19OTEFUVFI9eQpDT05GSUdf
TFJVX0NBQ0hFPW0KQ09ORklHX0FWRVJBR0U9eQpDT05GSUdfQ09SRElDPW0K
--------------080700080507070301020005--
