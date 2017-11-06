Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:44978 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753488AbdKFP5N (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Nov 2017 10:57:13 -0500
Message-ID: <1509983829.10974.2.camel@gmail.com> (sfid-20171106_165731_715160_74DF3A17)
Subject: Soft lockup in rt2x00usb_work_rxdone()
From: Richard Genoud <richard.genoud@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Date: Mon, 06 Nov 2017 16:57:09 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I get a soft lock-up while unbinding the USB driver on a TP-Link TL-WN727Nv3 (chipset 5370):

# echo 1-2.2 > /sys/bus/usb/drivers/usb/unbind
watchdog: BUG: soft lockup - CPU#0 stuck for 23s! [kworker/u2:3:308]
CPU: 0 PID: 308 Comm: kworker/u2:3 Not tainted 4.14.0-rc8 #11
Hardware name: Atmel AT91SAM9
Workqueue: phy0 rt2x00usb_work_rxdone
task: c7b91000 task.stack: c7bee000
PC is at rt2x00lib_rxdone+0x590/0x5b8
LR is at rt2x00lib_dmadone+0x54/0x58
pc : [<c0332978>]    lr : [<c0331fdc>]    psr: 80000013
sp : c7befebc  ip : 00000052  fp : c7befee4
r10: 00000000  r9 : c79b2b58  r8 : 00000000
r7 : c7816d00  r6 : c780e200  r5 : c79c68dc  r4 : c7134ce0
r3 : 00000001  r2 : c70bc200  r1 : ffffa55f  r0 : 00000000
Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
Control: 0005317f  Table: 261b8000  DAC: 00000053
CPU: 0 PID: 308 Comm: kworker/u2:3 Not tainted 4.14.0-rc8 #11
Hardware name: Atmel AT91SAM9
Workqueue: phy0 rt2x00usb_work_rxdone
[<c000fe00>] (unwind_backtrace) from [<c000dd94>] (show_stack+0x20/0x24)
[<c000dd94>] (show_stack) from [<c05a5440>] (dump_stack+0x20/0x28)
[<c05a5440>] (dump_stack) from [<c000b03c>] (show_regs+0x1c/0x20)
[<c000b03c>] (show_regs) from [<c0064c6c>] (watchdog_timer_fn+0x148/0x1ac)
[<c0064c6c>] (watchdog_timer_fn) from [<c0051dec>] (hrtimer_run_queues+0x128/0x250)
[<c0051dec>] (hrtimer_run_queues) from [<c00512e8>] (run_local_timers+0x18/0x68)
[<c00512e8>] (run_local_timers) from [<c0051370>] (update_process_times+0x38/0x6c)
[<c0051370>] (update_process_times) from [<c005e1c0>] (tick_nohz_handler+0xc0/0x10c)
[<c005e1c0>] (tick_nohz_handler) from [<c03a73cc>] (ch2_irq+0x30/0x38)
[<c03a73cc>] (ch2_irq) from [<c0046b00>] (__handle_irq_event_percpu+0x74/0x1dc)
[<c0046b00>] (__handle_irq_event_percpu) from [<c0046c94>] (handle_irq_event_percpu+0x2c/0x68)
[<c0046c94>] (handle_irq_event_percpu) from [<c0046d08>] (handle_irq_event+0x38/0x4c)
[<c0046d08>] (handle_irq_event) from [<c0049f54>] (handle_fasteoi_irq+0xa0/0x114)
[<c0049f54>] (handle_fasteoi_irq) from [<c0046320>] (generic_handle_irq+0x28/0x38)
[<c0046320>] (generic_handle_irq) from [<c00463c0>] (__handle_domain_irq+0x90/0xb8)
[<c00463c0>] (__handle_domain_irq) from [<c00094a4>] (aic_handle+0xb0/0xb8)
[<c00094a4>] (aic_handle) from [<c000ea68>] (__irq_svc+0x68/0x84)
Exception stack(0xc7befe68 to 0xc7befeb0)
fe60:                   00000000 ffffa55f c70bc200 00000001 c7134ce0 c79c68dc
fe80: c780e200 c7816d00 00000000 c79b2b58 00000000 c7befee4 00000052 c7befebc
fea0: c0331fdc c0332978 80000013 ffffffff
[<c000ea68>] (__irq_svc) from [<c0332978>] (rt2x00lib_rxdone+0x590/0x5b8)
[<c0332978>] (rt2x00lib_rxdone) from [<c0337550>] (rt2x00usb_work_rxdone+0x60/0x7c)
[<c0337550>] (rt2x00usb_work_rxdone) from [<c002ca64>] (process_one_work+0x1e4/0x3a0)
[<c002ca64>] (process_one_work) from [<c002cf28>] (worker_thread+0x2c8/0x45c)
[<c002cf28>] (worker_thread) from [<c0031f68>] (kthread+0x114/0x130)
[<c0031f68>] (kthread) from [<c000a4c8>] (ret_from_fork+0x14/0x2c)

I can trigger this each time.

NB: if the wifi is deactivated properly before the unbind, there's no problem :

# ifconfig wlan0 down ; echo 1-2.2 > /sys/bus/usb/drivers/usb/unbind
wlan0: deauthenticating from 06:18:d6:91:9e:29 by local choice (Reason: 3=DEAUTH_LEAVING)



Full dmesg:
 
## Booting kernel from Legacy Image at 20007fc0 ...
   Image Name:   Linux-4.14.0-rc8
   Image Type:   ARM Linux Kernel Image (uncompressed)
   Data Size:    4522192 Bytes = 4.3 MiB
   Load Address: 20008000
   Entry Point:  20008000
## Flattened Device Tree blob at 26400000
   Booting using the fdt blob at 0x26400000
   XIP Kernel Image ... OK
   Loading Device Tree to 27df2000, end 27dfcbb3 ... OK

Starting kernel ...

Booting Linux on physical CPU 0x0
Linux version 4.14.0-rc8 (rgenoud@lnx-rg) (gcc version 4.7.3 (GCC)) #11 Mon Nov 6 16:22:49 CET 2017
CPU: ARM926EJ-S [41069265] revision 5 (ARMv5TEJ), cr=0005317f
CPU: VIVT data cache, VIVT instruction cache
OF: fdt: Machine model: Paratronic LNS
Memory policy: Data cache writeback
On node 0 totalpages: 32768
free_area_init_node: node 0, pgdat c08a4b78, node_mem_map c7efb000
  Normal zone: 256 pages used for memmap
  Normal zone: 0 pages reserved
  Normal zone: 32768 pages, LIFO batch:7
random: fast init done
pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
pcpu-alloc: [0] 0 
Built 1 zonelists, mobility grouping on.  Total pages: 32512
Kernel command line: loglevel=8 ro root=ubi0:rootfs rootfstype=ubifs ubi.mtd=ubi lpj=995328 ubi.fm_autoconvert=1 panic=2 mtdparts=atmel_nand:256M(all),128k@0(dtb),10112k(kernel),251392k(ubi),512k(bbt)ro atmel-nand-controller.use_dma=0 spidev.bufsiz=53200 video=320x240-32
PID hash table entries: 512 (order: -1, 2048 bytes)
Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
Memory: 120624K/131072K available (5847K kernel code, 475K rwdata, 1504K rodata, 480K init, 245K bss, 10448K reserved, 0K cma-reserved)
Virtual kernel memory layout:
    vector  : 0xffff0000 - 0xffff1000   (   4 kB)
    fixmap  : 0xffc00000 - 0xfff00000   (3072 kB)
    vmalloc : 0xc8800000 - 0xff800000   ( 880 MB)
    lowmem  : 0xc0000000 - 0xc8000000   ( 128 MB)
      .text : 0xc0008000 - 0xc05be200   (5849 kB)
      .init : 0xc07be000 - 0xc0836000   ( 480 kB)
      .data : 0xc0836000 - 0xc08accd0   ( 476 kB)
       .bss : 0xc08b20e8 - 0xc08ef77c   ( 246 kB)
ftrace: allocating 23621 entries in 70 pages
NR_IRQS: 16, nr_irqs: 16, preallocated irqs: 16
clocksource: pit: mask: 0xfffffff max_cycles: 0xfffffff, max_idle_ns: 14334453866 ns
sched_clock: 32 bits at 100 Hz, resolution 10000000ns, wraps every 21474836475000000ns
Console: colour dummy device 80x30
console [tty0] enabled
Calibrating delay loop (skipped) preset value.. 199.06 BogoMIPS (lpj=995328)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
Mountpoint-cache hash table entries: 1024 (order: 0, 4096 bytes)
CPU: Testing write buffer coherency: ok
Setting up static identity map for 0x20008400 - 0x2000843c
devtmpfs: initialized
clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 19112604462750000 ns
futex hash table entries: 256 (order: -1, 3072 bytes)
pinctrl core: initialized pinctrl subsystem
NET: Registered protocol family 16
DMA: preallocated 256 KiB pool for atomic coherent allocations
AT91: PM: standby: standby, suspend: ulp0
gpio-at91 fffff400.gpio: at address c8861400
gpio-at91 fffff600.gpio: at address c8863600
gpio-at91 fffff800.gpio: at address c8865800
gpio-at91 fffffa00.gpio: at address c8867a00
pinctrl-at91 ahb:apb:pinctrl@fffff400: initialized AT91 pinctrl driver
tcb_clksrc: tc0 at 16.166 MHz
clocksource: tcb_clksrc: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 114675631333 ns
at_hdmac ffffec00.dma-controller: Atmel AHB DMA Controller ( cpy set slave ), 8 channels
at_hdmac ffffee00.dma-controller: Atmel AHB DMA Controller ( cpy set slave ), 8 channels
AT91: Detected SoC family: at91sam9x5
AT91: Detected SoC: at91sam9g35, revision 1
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
i2c-gpio i2c-gpio-0: using pins 30 (SDA) and 31 (SCL)
pps_core: LinuxPPS API ver. 1 registered
pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
PTP clock support registered
clocksource: Switched to clocksource tcb_clksrc
NET: Registered protocol family 2
TCP established hash table entries: 1024 (order: 0, 4096 bytes)
TCP bind hash table entries: 1024 (order: 0, 4096 bytes)
TCP: Hash tables configured (established 1024 bind 1024)
UDP hash table entries: 256 (order: 0, 4096 bytes)
UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
NET: Registered protocol family 1
RPC: Registered named UNIX socket transport module.
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
workingset: timestamp_bits=30 max_order=15 bucket_order=0
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
io scheduler noop registered (default)
io scheduler mq-deadline registered
io scheduler kyber registered
fffff200.serial: ttyS0 at MMIO 0xfffff200 (irq = 16, base_baud = 8333333) is a ATMEL_SERIAL
console [ttyS0] enabled
f801c000.serial: ttyS1 at MMIO 0xf801c000 (irq = 23, base_baud = 8333333) is a ATMEL_SERIAL
f8020000.serial: ttyS2 at MMIO 0xf8020000 (irq = 24, base_baud = 8333333) is a ATMEL_SERIAL
f8024000.serial: ttyS3 at MMIO 0xf8024000 (irq = 25, base_baud = 8333333) is a ATMEL_SERIAL
brd: module loaded
loop: module loaded
ssc f0010000.ssc: Atmel SSC device at 0xc88a0000 (irq 22)
at24 0-0053: 256 byte 24c02 EEPROM, writable, 16 bytes/write
at24 0-0051: 65536 byte 24c512 EEPROM, writable, 128 bytes/write
nand: device found, Manufacturer ID: 0x2c, Chip ID: 0xda
nand: Micron MT29F2G08ABAEAWP
nand: 256 MiB, SLC, erase size: 128 KiB, page size: 2048, OOB size: 64
Bad block table found at page 131008, version 0x01
Bad block table found at page 130944, version 0x01
5 cmdlinepart partitions found on MTD device atmel_nand
Creating 5 MTD partitions on "atmel_nand":
0x000000000000-0x000010000000 : "all"
0x000000000000-0x000000020000 : "dtb"
0x000000020000-0x000000a00000 : "kernel"
0x000000a00000-0x00000ff80000 : "ubi"
0x00000ff80000-0x000010000000 : "bbt"
atmel-pmecc ffffe000.ecc-engine: can't request region for resource [mem 0xffffe000-0xffffe5ff]
atmel-pmecc: probe of ffffe000.ecc-engine failed with error -16
m25p80 spi0.0: at25df321a (4096 Kbytes)
4 ofpart partitions found on MTD device spi0.0
Creating 4 MTD partitions on "spi0.0":
0x000000000000-0x000000008000 : "bootpri"
0x000000008000-0x000000108000 : "bootsec"
0x000000108000-0x000000218000 : "bootenv"
0x000000110000-0x000000400000 : "free"
atmel_spi f0000000.spi: Atmel SPI Controller version 0x212 at 0xf0000000 (irq 27)
atmel_spi f0004000.spi: Atmel SPI Controller version 0x212 at 0xf0004000 (irq 28)
libphy: Fixed MDIO Bus: probed
tun: Universal TUN/TAP device driver, 1.6
libphy: MACB_mii_bus: probed
Davicom DM9161A f802c000.ethernet-ffffffff:00: attached PHY driver [Davicom DM9161A] (mii_bus:phy_addr=f802c000.ethernet-ffffffff:00, irq=POLL)
macb f802c000.ethernet eth0: Cadence MACB rev 0x0001010c at 0xf802c000 irq 31 (00:04:a3:d2:a7:ef)
PPP generic driver version 2.4.2
PPP Deflate Compression module registered
usbcore: registered new interface driver rt2800usb
usbcore: registered new interface driver cdc_ether
usbcore: registered new interface driver rndis_host
usbcore: registered new interface driver cdc_ncm
usbcore: registered new interface driver qmi_wwan
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci-atmel: EHCI Atmel driver
atmel-ehci 700000.ehci: EHCI Host Controller
atmel-ehci 700000.ehci: new USB bus registered, assigned bus number 1
atmel-ehci 700000.ehci: irq 32, io mem 0x00700000
atmel-ehci 700000.ehci: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 4.14.0-rc8 ehci_hcd
usb usb1: SerialNumber: 700000.ehci
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 3 ports detected
usbcore: registered new interface driver cdc_acm
cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
usbcore: registered new interface driver cdc_wdm
usbcore: registered new interface driver usb-storage
usbcore: registered new interface driver usbserial
usbcore: registered new interface driver option
usbserial: USB Serial support registered for GSM modem (1-port)
usbcore: registered new interface driver pl2303
usbserial: USB Serial support registered for pl2303
usbcore: registered new interface driver qcserial
usbserial: USB Serial support registered for Qualcomm USB modem
usbcore: registered new interface driver sierra
usbserial: USB Serial support registered for Sierra USB modem
atmel_usba_udc 500000.gadget: MMIO registers at 0xf803c000 mapped at c88e1000
atmel_usba_udc 500000.gadget: FIFO at 0x00500000 mapped at c8a80000
using random self ethernet address
using random host ethernet address
usb0: HOST MAC 56:0b:bc:61:78:8c
usb0: MAC fa:b6:82:52:5d:bb
using random self ethernet address
using random host ethernet address
g_ether gadget: Ethernet Gadget, version: Memorial Day 2008
g_ether gadget: g_ether ready
i2c /dev entries driver
AT91: Starting after user reset
at91_wdt fffffe40.watchdog: watchdog is disabled
at91_wdt: probe of fffffe40.watchdog failed with error -22
hidraw: raw HID events driver (C) Jiri Kosina
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (2048 buckets, 8192 max)
ctnetlink v0.93: registering with nfnetlink.
ip_tables: (C) 2000-2006 Netfilter Core Team
Initializing XFRM netlink socket
NET: Registered protocol family 10
Segment Routing with IPv6
ip6_tables: (C) 2000-2006 Netfilter Core Team
sit: IPv6, IPv4 and MPLS over IPv4 tunneling driver
NET: Registered protocol family 17
NET: Registered protocol family 15
Key type dns_resolver registered
ubi0: default fastmap pool size: 95
ubi0: default fastmap WL pool size: 47
ubi0: attaching mtd3
atmel_usba_udc 500000.gadget: ODD: EP5 configuration is invalid!
atmel_usba_udc 500000.gadget: ODD: EP6 configuration is invalid!
atmel_usba_udc 500000.gadget: ODD: EP5 configuration is invalid!
atmel_usba_udc 500000.gadget: ODD: EP6 configuration is invalid!
usb 1-2: new high-speed USB device number 2 using atmel-ehci
g_ether gadget: high-speed config #1: CDC Ethernet (ECM)
ubi0: attached by fastmap
ubi0: fastmap pool size: 95
ubi0: fastmap WL pool size: 47
usb 1-2: New USB device found, idVendor=0424, idProduct=2512
usb 1-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
hub 1-2:1.0: USB hub found
hub 1-2:1.0: 2 ports detected
ubi0: attached mtd3 (name "ubi", size 245 MiB)
ubi0: PEB size: 131072 bytes (128 KiB), LEB size: 126976 bytes
ubi0: min./max. I/O unit sizes: 2048/2048, sub-page size 2048
ubi0: VID header offset: 2048 (aligned 2048), data offset: 4096
ubi0: good PEBs: 1964, bad PEBs: 0, corrupted PEBs: 0
ubi0: user volume: 3, internal volumes: 1, max. volumes count: 128
ubi0: max/mean erase counter: 32/12, WL threshold: 4096, image sequence number: 216151522
ubi0: available PEBs: 0, total reserved PEBs: 1964, PEBs reserved for bad PEB handling: 40
backlight-power-supply: disabling
panel-power-supply: disabling
ubi0: background thread "ubi_bgt0d" started, PID 618
atmel_usart fffff200.serial: using dma1chan0 for rx DMA transfers
atmel_usart fffff200.serial: using dma1chan1 for tx DMA transfers
UBIFS (ubi0:0): recovery needed
UBIFS (ubi0:0): recovery deferred
UBIFS (ubi0:0): UBIFS: mounted UBI device 0, volume 0, name "rootfs", R/O mode
UBIFS (ubi0:0): LEB size: 126976 bytes (124 KiB), min./max. I/O unit sizes: 2048 bytes/2048 bytes
UBIFS (ubi0:0): FS size: 66789376 bytes (63 MiB, 526 LEBs), journal size 9015296 bytes (8 MiB, 71 LEBs)
UBIFS (ubi0:0): reserved for root: 0 bytes (0 KiB)
UBIFS (ubi0:0): media format: w4/r0 (latest is w5/r0), UUID 764284F8-1DF2-40F9-BFB6-C0DC0D4D143F, small LPT model
VFS: Mounted root (ubifs filesystem) readonly on device 0:14.
devtmpfs: mounted
Freeing unused kernel memory: 480K
This architecture does not have kernel memory protection.
usb 1-2.2: new high-speed USB device number 3 using atmel-ehci
usb 1-2.2: New USB device found, idVendor=148f, idProduct=5370
usb 1-2.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-2.2: Product: 802.11 n WLAN
usb 1-2.2: Manufacturer: TPlink
usb 1-2.2: SerialNumber: 1.0
UBIFS (ubi0:2): background thread "ubifs_bgt0_2" started, PID 631
usb 1-2.2: reset high-speed USB device number 3 using atmel-ehci
UBIFS (ubi0:2): recovery needed
ieee80211 phy0: rt2x00_set_rt: Info - RT chipset 5390, rev 0502 detected
ieee80211 phy0: rt2x00_set_rf: Info - RF chipset 5370 detected
ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
UBIFS (ubi0:2): recovery completed
UBIFS (ubi0:2): UBIFS: mounted UBI device 0, volume 2, name "data"
UBIFS (ubi0:2): LEB size: 126976 bytes (124 KiB), min./max. I/O unit sizes: 2048 bytes/2048 bytes
UBIFS (ubi0:2): FS size: 105771008 bytes (100 MiB, 833 LEBs), journal size 9023488 bytes (8 MiB, 72 LEBs)
UBIFS (ubi0:2): reserved for root: 0 bytes (0 KiB)
UBIFS (ubi0:2): media format: w4/r0 (latest is w5/r0), UUID F6094496-0276-4615-A1FF-CE370C8017B0, small LPT model
Watchdog disabled
ieee80211 phy0: rt2x00lib_request_firmware: Info - Loading firmware file 'rt2870.bin'
ieee80211 phy0: rt2x00lib_request_firmware: Info - Firmware detected - version: 0.36
IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
wlan0: authenticate with 06:18:d6:91:9e:29
wlan0: send auth to 06:18:d6:91:9e:29 (try 1/3)
wlan0: authenticated
wlan0: associate with 06:18:d6:91:9e:29 (try 1/3)
wlan0: RX AssocResp from 06:18:d6:91:9e:29 (capab=0x431 status=0 aid=2)
wlan0: associated
IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
# ifconfig 
lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

tether    Link encap:Ethernet  HWaddr FA:B6:82:52:5D:BB  
          inet addr:192.168.5.1  Bcast:192.168.5.255  Mask:255.255.255.0
          inet6 addr: fe80::3039:28ff:fe3d:96e8/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:39 errors:0 dropped:0 overruns:0 frame:0
          TX packets:11 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:6930 (6.7 KiB)  TX bytes:2046 (1.9 KiB)

usb0      Link encap:Ethernet  HWaddr FA:B6:82:52:5D:BB  
          inet6 addr: fe80::f8b6:82ff:fe52:5dbb/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:41 errors:0 dropped:0 overruns:0 frame:0
          TX packets:16 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:7334 (7.1 KiB)  TX bytes:2432 (2.3 KiB)

wlan0     Link encap:Ethernet  HWaddr 10:FE:ED:25:B1:0D  
          inet addr:192.168.3.134  Bcast:192.168.3.255  Mask:255.255.255.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:10 errors:0 dropped:0 overruns:0 frame:0
          TX packets:10 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:1440 (1.4 KiB)  TX bytes:2052 (2.0 KiB)

# echo 1-2.2 > /sys/bus/usb/drivers/usb/unbind
watchdog: BUG: soft lockup - CPU#0 stuck for 23s! [kworker/u2:3:308]
CPU: 0 PID: 308 Comm: kworker/u2:3 Not tainted 4.14.0-rc8 #11
Hardware name: Atmel AT91SAM9
Workqueue: phy0 rt2x00usb_work_rxdone
task: c7b91000 task.stack: c7bee000
PC is at rt2x00lib_rxdone+0x590/0x5b8
LR is at rt2x00lib_dmadone+0x54/0x58
pc : [<c0332978>]    lr : [<c0331fdc>]    psr: 80000013
sp : c7befebc  ip : 00000052  fp : c7befee4
r10: 00000000  r9 : c79b2b58  r8 : 00000000
r7 : c7816d00  r6 : c780e200  r5 : c79c68dc  r4 : c7134ce0
r3 : 00000001  r2 : c70bc200  r1 : ffffa55f  r0 : 00000000
Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
Control: 0005317f  Table: 261b8000  DAC: 00000053
CPU: 0 PID: 308 Comm: kworker/u2:3 Not tainted 4.14.0-rc8 #11
Hardware name: Atmel AT91SAM9
Workqueue: phy0 rt2x00usb_work_rxdone
[<c000fe00>] (unwind_backtrace) from [<c000dd94>] (show_stack+0x20/0x24)
[<c000dd94>] (show_stack) from [<c05a5440>] (dump_stack+0x20/0x28)
[<c05a5440>] (dump_stack) from [<c000b03c>] (show_regs+0x1c/0x20)
[<c000b03c>] (show_regs) from [<c0064c6c>] (watchdog_timer_fn+0x148/0x1ac)
[<c0064c6c>] (watchdog_timer_fn) from [<c0051dec>] (hrtimer_run_queues+0x128/0x250)
[<c0051dec>] (hrtimer_run_queues) from [<c00512e8>] (run_local_timers+0x18/0x68)
[<c00512e8>] (run_local_timers) from [<c0051370>] (update_process_times+0x38/0x6c)
[<c0051370>] (update_process_times) from [<c005e1c0>] (tick_nohz_handler+0xc0/0x10c)
[<c005e1c0>] (tick_nohz_handler) from [<c03a73cc>] (ch2_irq+0x30/0x38)
[<c03a73cc>] (ch2_irq) from [<c0046b00>] (__handle_irq_event_percpu+0x74/0x1dc)
[<c0046b00>] (__handle_irq_event_percpu) from [<c0046c94>] (handle_irq_event_percpu+0x2c/0x68)
[<c0046c94>] (handle_irq_event_percpu) from [<c0046d08>] (handle_irq_event+0x38/0x4c)
[<c0046d08>] (handle_irq_event) from [<c0049f54>] (handle_fasteoi_irq+0xa0/0x114)
[<c0049f54>] (handle_fasteoi_irq) from [<c0046320>] (generic_handle_irq+0x28/0x38)
[<c0046320>] (generic_handle_irq) from [<c00463c0>] (__handle_domain_irq+0x90/0xb8)
[<c00463c0>] (__handle_domain_irq) from [<c00094a4>] (aic_handle+0xb0/0xb8)
[<c00094a4>] (aic_handle) from [<c000ea68>] (__irq_svc+0x68/0x84)
Exception stack(0xc7befe68 to 0xc7befeb0)
fe60:                   00000000 ffffa55f c70bc200 00000001 c7134ce0 c79c68dc
fe80: c780e200 c7816d00 00000000 c79b2b58 00000000 c7befee4 00000052 c7befebc
fea0: c0331fdc c0332978 80000013 ffffffff
[<c000ea68>] (__irq_svc) from [<c0332978>] (rt2x00lib_rxdone+0x590/0x5b8)
[<c0332978>] (rt2x00lib_rxdone) from [<c0337550>] (rt2x00usb_work_rxdone+0x60/0x7c)
[<c0337550>] (rt2x00usb_work_rxdone) from [<c002ca64>] (process_one_work+0x1e4/0x3a0)
[<c002ca64>] (process_one_work) from [<c002cf28>] (worker_thread+0x2c8/0x45c)
[<c002cf28>] (worker_thread) from [<c0031f68>] (kthread+0x114/0x130)
[<c0031f68>] (kthread) from [<c000a4c8>] (ret_from_fork+0x14/0x2c)



Regards,
Richard
