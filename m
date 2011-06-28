Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:50345 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755920Ab1F1C4S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2011 22:56:18 -0400
Received: from [70.96.116.236] (helo=[192.168.0.251])
	by box284.bluehost.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <troy.kisky@boundarydevices.com>)
	id 1QbOTH-0000Uh-Qt
	for linux-wireless@vger.kernel.org; Mon, 27 Jun 2011 20:56:16 -0600
Message-ID: <4E0942CA.9010402@boundarydevices.com> (sfid-20110628_050049_933046_30E3185F)
Date: Mon, 27 Jun 2011 19:56:10 -0700
From: Troy Kisky <troy.kisky@boundarydevices.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: WL1271: WLAN_IRQ not working
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

I trying to get an LSR WL1271 sdio module to work. Everything seems to
work fine until the WLAN_IRQ pin should go high, but it never does. Checking
with a scope shows constant low. proc/interrupts also says 0. I'm using
3.0.0-rc4 with patches for non-mainline board. If I make the interrupt
gp a high output, I can raise the level of the WLAN_IRQ pin slightly,
but it is still a logic 0.


tiwi_r2_datasheet.pdf says interrupts are "active-low or falling-edge"

So, why does the driver request an active high interrupt? I'm guessing
datasheet bug.

Anyway, here are the messages I'm getting with most debugging turned on,
if someone is willing to take a look.

Thanks
Troy


------------------------

Linux version 3.0.0-rc4-00023-gbaa5b0a-dirty (tkisky@officeserver) (gcc
version 4.4.1 (Sourcery G++ Lite 2010q1-202) ) #71 PREEMPT Sat Jun 25
17:49:49 MST 2011
CPU: ARMv7 Processor [412fc085] revision 5 (ARMv7), cr=10c53c7f
CPU: VIPT nonaliasing data cache, VIPT aliasing instruction cache
Machine: Boundary Devices Nitrogen MX53 Board
Memory policy: ECC disabled, Data cache writeback
On node 0 totalpages: 131072
free_area_init_node: node 0, pgdat c04d01f4, node_mem_map c04ee000
  Normal zone: 1024 pages used for memmap
  Normal zone: 0 pages reserved
  Normal zone: 130048 pages, LIFO batch:31
pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
pcpu-alloc: [0] 0
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 130048
Kernel command line: DEBUG=1 earlyprintk loglevel=8 consoleblank=0
calibration ip=dhcp root=/dev/nfs
nfsroot=192.168.0.200:/home/tkisky/arm-lucid rw rootwait
ldb=single,di=0,ch0_map=JEIDA
video=mxcdi0fb:raw:29500000,800,480,1,0,1,0,72,96,24,7,10,3,1,1,888
console=ttymxc1,115200
PID hash table entries: 2048 (order: 1, 8192 bytes)
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 512MB = 512MB total
Memory: 514708k/514708k available, 9580k reserved, 0K highmem
Virtual kernel memory layout:
    vector  : 0xffff0000 - 0xffff1000   (   4 kB)
    fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
    DMA     : 0xffc00000 - 0xffe00000   (   2 MB)
    vmalloc : 0xe0800000 - 0xf4000000   ( 312 MB)
    lowmem  : 0xc0000000 - 0xe0000000   ( 512 MB)
    modules : 0xbf000000 - 0xc0000000   (  16 MB)
      .init : 0xc0008000 - 0xc002b000   ( 140 kB)
      .text : 0xc002b000 - 0xc049e6d4   (4558 kB)
      .data : 0xc04a0000 - 0xc04d0880   ( 195 kB)
       .bss : 0xc04d08a4 - 0xc04ed498   ( 115 kB)
SLUB: Genslabs=11, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
Preemptible hierarchical RCU implementation.
NR_IRQS:368
TrustZone Interrupt Controller (TZIC) initialized
MXC GPIO hardware
CPU identified as i.MX53, silicon rev 2.1
sched_clock: 32 bits at 100MHz, resolution 10ns, wraps every 42949ms
Console: colour dummy device 80x30
Calibrating delay loop... 996.14 BogoMIPS (lpj=4980736)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 512
CPU: Testing write buffer coherency: ok
print_constraints: dummy:
NET: Registered protocol family 16
MX53 Nitrogen board
mxc_board_init: before ifdef
bio: create slab <bio-0> at 0
print_constraints: vwl1271: 1800 mV
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
Advanced Linux Sound Architecture Driver Version 1.0.24.
cfg80211: Calling CRDA to update world regulatory domain
Switching to clocksource mxc_timer1
Switched to NOHz mode on CPU #0
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 5, 131072 bytes)
TCP bind hash table entries: 16384 (order: 4, 65536 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
UDP hash table entries: 256 (order: 0, 4096 bytes)
UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
NET: Registered protocol family 1
RPC: Registered named UNIX socket transport module.
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
msgmni has been set to 1005
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
Serial: IMX driver
imx-uart.0: ttymxc0 at MMIO 0x53fbc000 (irq = 31) is a IMX
imx-uart.1: ttymxc1 at MMIO 0x53fc0000 (irq = 32) is a IMX
console [ttymxc1] enabled
imx-uart.2: ttymxc2 at MMIO 0x5000c000 (irq = 33) is a IMX
brd: module loaded
loop: module loaded
FEC Ethernet Driver
fec_enet_mii_bus: probed
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
mousedev: PS/2 mouse device common for all mice
input: gpio-keys as /devices/platform/gpio-keys/input/input0
i2c /dev entries driver
lirc_dev: IR Remote Control driver registered, major 253
IR NEC protocol handler initialized
IR RC5(x) protocol handler initialized
IR RC6 protocol handler initialized
IR JVC protocol handler initialized
IR Sony protocol handler initialized
IR RC5 (streamzap) protocol handler initialized
IR LIRC bridge handler initialized
Linux video capture interface: v2.00
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
mmc0: no vmmc regulator found
mmc0: SDHCI controller on platform [sdhci-esdhc-imx.0] using DMA
mmc1: SDHCI controller on platform [sdhci-esdhc-imx.2] using DMA
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
ALSA device list:
  No soundcards found.
TCP cubic registered
NET: Registered protocol family 17
VFP support v0.3: implementor 41 architecture 3 part 30 variant c rev 2
No RTC device found, ALARM timers will not wake from suspend
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
eth0: Freescale FEC PHY driver [ICS1893] (mii_bus:phy_addr=1:05, irq=-1)
mmc0: new high speed SDHC card at address b368
mmcblk0: mmc0:b368 AF UD 3.72 GiB
 mmcblk0: p1
mmc1: card claims to support voltages below the defined range. These
will be ignored.
mmc1: queuing unknown CIS tuple 0x91 (3 bytes)
mmc1: new SDIO card at address 0001
PHY: 1:05 - Link is Up - 100/Full
Sending DHCP requests ., OK
IP-Config: Got DHCP answer from 192.168.0.200, my address is 192.168.0.7
IP-Config: Complete:
     device=eth0, addr=192.168.0.7, mask=255.255.255.0, gw=192.168.0.253,
     host=192.168.0.7, domain=example.org, nis-domain=(none),
     bootserver=192.168.0.200, rootserver=192.168.0.200, rootpath=
VFS: Mounted root (nfs filesystem) on device 0:11.
Freeing init memory: 140K
init (3407): /proc/3407/oom_adj is deprecated, please use
/proc/3407/oom_score_adj instead.
wl1271: sdio PM caps = 0x0
wl1271: loaded
wl1271: initialized
root@imxhost:~#
root@imxhost:~#
root@imxhost:~#
root@imxhost:~#
root@imxhost:~#
root@imxhost:~# ifconfig wlan0 up
wl1271: mac80211 start
wl1271: mac80211 add interface type 2 mac 00:19:b8:01:2e:70
wl1271: mem_start 00000000 mem_size 00000000
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: sdio write 52 addr 0x1fffc, byte 0x01
wl1271: chip id 0x4030111 (1271 PG20)
wl1271: booting firmware ti-connectivity/wl1271-fw-2.bin
wl1271: pause1 0xf03
wl1271: mem_start 00040000 mem_size 00014FC0
wl1271: reg_start 00310000 reg_size 00006000
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: DRPW_SCRATCH_START 0031002c
wl1271: clk2 0x0
wl1271: mem_start 00040000 mem_size 00014FC0
wl1271: reg_start 00300000 reg_size 0000A000
wl1271: mem2_start 003004F8 mem2_size 00000004
wl1271: mem3_start 00040404 mem3_size 00000000
wl1271: soft reset bootdata 0x0
wl1271: nvs burst write 0x30546c: 0xb8012e70
wl1271: nvs burst write 0x305470: 0x19
wl1271: mem_start 00040000 mem_size 00014FC0
wl1271: reg_start 00300000 reg_size 0000A000
wl1271: mem2_start 003004F8 mem2_size 00000004
wl1271: mem3_start 00040404 mem3_size 00000000
wl1271: ACX_EEPROMLESS_IND_REG
wl1271: chip id 0x4030111
wl1271: firmware chunks to be uploaded: 6
wl1271: chunk 5 addr 0x0 len 195608
wl1271: starting firmware upload
wl1271: fw_data_len 195608 chunk_size 512
wl1271: mem_start 00000000 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cb900c to 0x0
wl1271: uploading fw chunk 0xe0cb920c to 0x200
wl1271: uploading fw chunk 0xe0cb940c to 0x400
wl1271: uploading fw chunk 0xe0cb960c to 0x600
wl1271: uploading fw chunk 0xe0cb980c to 0x800
wl1271: uploading fw chunk 0xe0cb9a0c to 0xa00
wl1271: uploading fw chunk 0xe0cb9c0c to 0xc00
wl1271: uploading fw chunk 0xe0cb9e0c to 0xe00
wl1271: uploading fw chunk 0xe0cba00c to 0x1000
wl1271: uploading fw chunk 0xe0cba20c to 0x1200
wl1271: uploading fw chunk 0xe0cba40c to 0x1400
wl1271: uploading fw chunk 0xe0cba60c to 0x1600
wl1271: uploading fw chunk 0xe0cba80c to 0x1800
wl1271: uploading fw chunk 0xe0cbaa0c to 0x1a00
wl1271: uploading fw chunk 0xe0cbac0c to 0x1c00
wl1271: uploading fw chunk 0xe0cbae0c to 0x1e00
wl1271: uploading fw chunk 0xe0cbb00c to 0x2000
wl1271: uploading fw chunk 0xe0cbb20c to 0x2200
wl1271: uploading fw chunk 0xe0cbb40c to 0x2400
wl1271: uploading fw chunk 0xe0cbb60c to 0x2600
wl1271: uploading fw chunk 0xe0cbb80c to 0x2800
wl1271: uploading fw chunk 0xe0cbba0c to 0x2a00
wl1271: uploading fw chunk 0xe0cbbc0c to 0x2c00
wl1271: uploading fw chunk 0xe0cbbe0c to 0x2e00
wl1271: uploading fw chunk 0xe0cbc00c to 0x3000
wl1271: uploading fw chunk 0xe0cbc20c to 0x3200
wl1271: uploading fw chunk 0xe0cbc40c to 0x3400
wl1271: uploading fw chunk 0xe0cbc60c to 0x3600
wl1271: uploading fw chunk 0xe0cbc80c to 0x3800
wl1271: uploading fw chunk 0xe0cbca0c to 0x3a00
wl1271: uploading fw chunk 0xe0cbcc0c to 0x3c00
wl1271: uploading fw chunk 0xe0cbce0c to 0x3e00
wl1271: uploading fw chunk 0xe0cbd00c to 0x4000
wl1271: uploading fw chunk 0xe0cbd20c to 0x4200
wl1271: uploading fw chunk 0xe0cbd40c to 0x4400
wl1271: uploading fw chunk 0xe0cbd60c to 0x4600
wl1271: uploading fw chunk 0xe0cbd80c to 0x4800
wl1271: uploading fw chunk 0xe0cbda0c to 0x4a00
wl1271: uploading fw chunk 0xe0cbdc0c to 0x4c00
wl1271: uploading fw chunk 0xe0cbde0c to 0x4e00
wl1271: uploading fw chunk 0xe0cbe00c to 0x5000
wl1271: uploading fw chunk 0xe0cbe20c to 0x5200
wl1271: uploading fw chunk 0xe0cbe40c to 0x5400
wl1271: uploading fw chunk 0xe0cbe60c to 0x5600
wl1271: uploading fw chunk 0xe0cbe80c to 0x5800
wl1271: uploading fw chunk 0xe0cbea0c to 0x5a00
wl1271: uploading fw chunk 0xe0cbec0c to 0x5c00
wl1271: uploading fw chunk 0xe0cbee0c to 0x5e00
wl1271: uploading fw chunk 0xe0cbf00c to 0x6000
wl1271: uploading fw chunk 0xe0cbf20c to 0x6200
wl1271: uploading fw chunk 0xe0cbf40c to 0x6400
wl1271: uploading fw chunk 0xe0cbf60c to 0x6600
wl1271: uploading fw chunk 0xe0cbf80c to 0x6800
wl1271: uploading fw chunk 0xe0cbfa0c to 0x6a00
wl1271: uploading fw chunk 0xe0cbfc0c to 0x6c00
wl1271: uploading fw chunk 0xe0cbfe0c to 0x6e00
wl1271: uploading fw chunk 0xe0cc000c to 0x7000
wl1271: uploading fw chunk 0xe0cc020c to 0x7200
wl1271: uploading fw chunk 0xe0cc040c to 0x7400
wl1271: uploading fw chunk 0xe0cc060c to 0x7600
wl1271: uploading fw chunk 0xe0cc080c to 0x7800
wl1271: uploading fw chunk 0xe0cc0a0c to 0x7a00
wl1271: uploading fw chunk 0xe0cc0c0c to 0x7c00
wl1271: uploading fw chunk 0xe0cc0e0c to 0x7e00
wl1271: uploading fw chunk 0xe0cc100c to 0x8000
wl1271: uploading fw chunk 0xe0cc120c to 0x8200
wl1271: uploading fw chunk 0xe0cc140c to 0x8400
wl1271: uploading fw chunk 0xe0cc160c to 0x8600
wl1271: uploading fw chunk 0xe0cc180c to 0x8800
wl1271: uploading fw chunk 0xe0cc1a0c to 0x8a00
wl1271: uploading fw chunk 0xe0cc1c0c to 0x8c00
wl1271: uploading fw chunk 0xe0cc1e0c to 0x8e00
wl1271: uploading fw chunk 0xe0cc200c to 0x9000
wl1271: uploading fw chunk 0xe0cc220c to 0x9200
wl1271: uploading fw chunk 0xe0cc240c to 0x9400
wl1271: uploading fw chunk 0xe0cc260c to 0x9600
wl1271: uploading fw chunk 0xe0cc280c to 0x9800
wl1271: uploading fw chunk 0xe0cc2a0c to 0x9a00
wl1271: uploading fw chunk 0xe0cc2c0c to 0x9c00
wl1271: uploading fw chunk 0xe0cc2e0c to 0x9e00
wl1271: uploading fw chunk 0xe0cc300c to 0xa000
wl1271: uploading fw chunk 0xe0cc320c to 0xa200
wl1271: uploading fw chunk 0xe0cc340c to 0xa400
wl1271: uploading fw chunk 0xe0cc360c to 0xa600
wl1271: uploading fw chunk 0xe0cc380c to 0xa800
wl1271: uploading fw chunk 0xe0cc3a0c to 0xaa00
wl1271: uploading fw chunk 0xe0cc3c0c to 0xac00
wl1271: uploading fw chunk 0xe0cc3e0c to 0xae00
wl1271: uploading fw chunk 0xe0cc400c to 0xb000
wl1271: uploading fw chunk 0xe0cc420c to 0xb200
wl1271: uploading fw chunk 0xe0cc440c to 0xb400
wl1271: uploading fw chunk 0xe0cc460c to 0xb600
wl1271: uploading fw chunk 0xe0cc480c to 0xb800
wl1271: uploading fw chunk 0xe0cc4a0c to 0xba00
wl1271: uploading fw chunk 0xe0cc4c0c to 0xbc00
wl1271: uploading fw chunk 0xe0cc4e0c to 0xbe00
wl1271: uploading fw chunk 0xe0cc500c to 0xc000
wl1271: uploading fw chunk 0xe0cc520c to 0xc200
wl1271: uploading fw chunk 0xe0cc540c to 0xc400
wl1271: uploading fw chunk 0xe0cc560c to 0xc600
wl1271: uploading fw chunk 0xe0cc580c to 0xc800
wl1271: uploading fw chunk 0xe0cc5a0c to 0xca00
wl1271: uploading fw chunk 0xe0cc5c0c to 0xcc00
wl1271: uploading fw chunk 0xe0cc5e0c to 0xce00
wl1271: uploading fw chunk 0xe0cc600c to 0xd000
wl1271: uploading fw chunk 0xe0cc620c to 0xd200
wl1271: uploading fw chunk 0xe0cc640c to 0xd400
wl1271: uploading fw chunk 0xe0cc660c to 0xd600
wl1271: uploading fw chunk 0xe0cc680c to 0xd800
wl1271: uploading fw chunk 0xe0cc6a0c to 0xda00
wl1271: uploading fw chunk 0xe0cc6c0c to 0xdc00
wl1271: uploading fw chunk 0xe0cc6e0c to 0xde00
wl1271: uploading fw chunk 0xe0cc700c to 0xe000
wl1271: uploading fw chunk 0xe0cc720c to 0xe200
wl1271: uploading fw chunk 0xe0cc740c to 0xe400
wl1271: uploading fw chunk 0xe0cc760c to 0xe600
wl1271: uploading fw chunk 0xe0cc780c to 0xe800
wl1271: uploading fw chunk 0xe0cc7a0c to 0xea00
wl1271: uploading fw chunk 0xe0cc7c0c to 0xec00
wl1271: uploading fw chunk 0xe0cc7e0c to 0xee00
wl1271: uploading fw chunk 0xe0cc800c to 0xf000
wl1271: uploading fw chunk 0xe0cc820c to 0xf200
wl1271: uploading fw chunk 0xe0cc840c to 0xf400
wl1271: uploading fw chunk 0xe0cc860c to 0xf600
wl1271: uploading fw chunk 0xe0cc880c to 0xf800
wl1271: uploading fw chunk 0xe0cc8a0c to 0xfa00
wl1271: uploading fw chunk 0xe0cc8c0c to 0xfc00
wl1271: uploading fw chunk 0xe0cc8e0c to 0xfe00
wl1271: uploading fw chunk 0xe0cc900c to 0x10000
wl1271: uploading fw chunk 0xe0cc920c to 0x10200
wl1271: uploading fw chunk 0xe0cc940c to 0x10400
wl1271: uploading fw chunk 0xe0cc960c to 0x10600
wl1271: uploading fw chunk 0xe0cc980c to 0x10800
wl1271: uploading fw chunk 0xe0cc9a0c to 0x10a00
wl1271: uploading fw chunk 0xe0cc9c0c to 0x10c00
wl1271: uploading fw chunk 0xe0cc9e0c to 0x10e00
wl1271: uploading fw chunk 0xe0cca00c to 0x11000
wl1271: uploading fw chunk 0xe0cca20c to 0x11200
wl1271: uploading fw chunk 0xe0cca40c to 0x11400
wl1271: uploading fw chunk 0xe0cca60c to 0x11600
wl1271: uploading fw chunk 0xe0cca80c to 0x11800
wl1271: uploading fw chunk 0xe0ccaa0c to 0x11a00
wl1271: uploading fw chunk 0xe0ccac0c to 0x11c00
wl1271: uploading fw chunk 0xe0ccae0c to 0x11e00
wl1271: uploading fw chunk 0xe0ccb00c to 0x12000
wl1271: uploading fw chunk 0xe0ccb20c to 0x12200
wl1271: uploading fw chunk 0xe0ccb40c to 0x12400
wl1271: uploading fw chunk 0xe0ccb60c to 0x12600
wl1271: uploading fw chunk 0xe0ccb80c to 0x12800
wl1271: uploading fw chunk 0xe0ccba0c to 0x12a00
wl1271: uploading fw chunk 0xe0ccbc0c to 0x12c00
wl1271: uploading fw chunk 0xe0ccbe0c to 0x12e00
wl1271: uploading fw chunk 0xe0ccc00c to 0x13000
wl1271: uploading fw chunk 0xe0ccc20c to 0x13200
wl1271: uploading fw chunk 0xe0ccc40c to 0x13400
wl1271: uploading fw chunk 0xe0ccc60c to 0x13600
wl1271: uploading fw chunk 0xe0ccc80c to 0x13800
wl1271: uploading fw chunk 0xe0ccca0c to 0x13a00
wl1271: uploading fw chunk 0xe0cccc0c to 0x13c00
wl1271: uploading fw chunk 0xe0ccce0c to 0x13e00
wl1271: uploading fw chunk 0xe0ccd00c to 0x14000
wl1271: uploading fw chunk 0xe0ccd20c to 0x14200
wl1271: uploading fw chunk 0xe0ccd40c to 0x14400
wl1271: uploading fw chunk 0xe0ccd60c to 0x14600
wl1271: uploading fw chunk 0xe0ccd80c to 0x14800
wl1271: uploading fw chunk 0xe0ccda0c to 0x14a00
wl1271: uploading fw chunk 0xe0ccdc0c to 0x14c00
wl1271: uploading fw chunk 0xe0ccde0c to 0x14e00
wl1271: uploading fw chunk 0xe0cce00c to 0x15000
wl1271: uploading fw chunk 0xe0cce20c to 0x15200
wl1271: uploading fw chunk 0xe0cce40c to 0x15400
wl1271: uploading fw chunk 0xe0cce60c to 0x15600
wl1271: uploading fw chunk 0xe0cce80c to 0x15800
wl1271: uploading fw chunk 0xe0ccea0c to 0x15a00
wl1271: uploading fw chunk 0xe0ccec0c to 0x15c00
wl1271: uploading fw chunk 0xe0ccee0c to 0x15e00
wl1271: uploading fw chunk 0xe0ccf00c to 0x16000
wl1271: uploading fw chunk 0xe0ccf20c to 0x16200
wl1271: uploading fw chunk 0xe0ccf40c to 0x16400
wl1271: uploading fw chunk 0xe0ccf60c to 0x16600
wl1271: uploading fw chunk 0xe0ccf80c to 0x16800
wl1271: uploading fw chunk 0xe0ccfa0c to 0x16a00
wl1271: uploading fw chunk 0xe0ccfc0c to 0x16c00
wl1271: uploading fw chunk 0xe0ccfe0c to 0x16e00
wl1271: uploading fw chunk 0xe0cd000c to 0x17000
wl1271: uploading fw chunk 0xe0cd020c to 0x17200
wl1271: mem_start 00017400 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cd040c to 0x17400
wl1271: uploading fw chunk 0xe0cd060c to 0x17600
wl1271: uploading fw chunk 0xe0cd080c to 0x17800
wl1271: uploading fw chunk 0xe0cd0a0c to 0x17a00
wl1271: uploading fw chunk 0xe0cd0c0c to 0x17c00
wl1271: uploading fw chunk 0xe0cd0e0c to 0x17e00
wl1271: uploading fw chunk 0xe0cd100c to 0x18000
wl1271: uploading fw chunk 0xe0cd120c to 0x18200
wl1271: uploading fw chunk 0xe0cd140c to 0x18400
wl1271: uploading fw chunk 0xe0cd160c to 0x18600
wl1271: uploading fw chunk 0xe0cd180c to 0x18800
wl1271: uploading fw chunk 0xe0cd1a0c to 0x18a00
wl1271: uploading fw chunk 0xe0cd1c0c to 0x18c00
wl1271: uploading fw chunk 0xe0cd1e0c to 0x18e00
wl1271: uploading fw chunk 0xe0cd200c to 0x19000
wl1271: uploading fw chunk 0xe0cd220c to 0x19200
wl1271: uploading fw chunk 0xe0cd240c to 0x19400
wl1271: uploading fw chunk 0xe0cd260c to 0x19600
wl1271: uploading fw chunk 0xe0cd280c to 0x19800
wl1271: uploading fw chunk 0xe0cd2a0c to 0x19a00
wl1271: uploading fw chunk 0xe0cd2c0c to 0x19c00
wl1271: uploading fw chunk 0xe0cd2e0c to 0x19e00
wl1271: uploading fw chunk 0xe0cd300c to 0x1a000
wl1271: uploading fw chunk 0xe0cd320c to 0x1a200
wl1271: uploading fw chunk 0xe0cd340c to 0x1a400
wl1271: uploading fw chunk 0xe0cd360c to 0x1a600
wl1271: uploading fw chunk 0xe0cd380c to 0x1a800
wl1271: uploading fw chunk 0xe0cd3a0c to 0x1aa00
wl1271: uploading fw chunk 0xe0cd3c0c to 0x1ac00
wl1271: uploading fw chunk 0xe0cd3e0c to 0x1ae00
wl1271: uploading fw chunk 0xe0cd400c to 0x1b000
wl1271: uploading fw chunk 0xe0cd420c to 0x1b200
wl1271: uploading fw chunk 0xe0cd440c to 0x1b400
wl1271: uploading fw chunk 0xe0cd460c to 0x1b600
wl1271: uploading fw chunk 0xe0cd480c to 0x1b800
wl1271: uploading fw chunk 0xe0cd4a0c to 0x1ba00
wl1271: uploading fw chunk 0xe0cd4c0c to 0x1bc00
wl1271: uploading fw chunk 0xe0cd4e0c to 0x1be00
wl1271: uploading fw chunk 0xe0cd500c to 0x1c000
wl1271: uploading fw chunk 0xe0cd520c to 0x1c200
wl1271: uploading fw chunk 0xe0cd540c to 0x1c400
wl1271: uploading fw chunk 0xe0cd560c to 0x1c600
wl1271: uploading fw chunk 0xe0cd580c to 0x1c800
wl1271: uploading fw chunk 0xe0cd5a0c to 0x1ca00
wl1271: uploading fw chunk 0xe0cd5c0c to 0x1cc00
wl1271: uploading fw chunk 0xe0cd5e0c to 0x1ce00
wl1271: uploading fw chunk 0xe0cd600c to 0x1d000
wl1271: uploading fw chunk 0xe0cd620c to 0x1d200
wl1271: uploading fw chunk 0xe0cd640c to 0x1d400
wl1271: uploading fw chunk 0xe0cd660c to 0x1d600
wl1271: uploading fw chunk 0xe0cd680c to 0x1d800
wl1271: uploading fw chunk 0xe0cd6a0c to 0x1da00
wl1271: uploading fw chunk 0xe0cd6c0c to 0x1dc00
wl1271: uploading fw chunk 0xe0cd6e0c to 0x1de00
wl1271: uploading fw chunk 0xe0cd700c to 0x1e000
wl1271: uploading fw chunk 0xe0cd720c to 0x1e200
wl1271: uploading fw chunk 0xe0cd740c to 0x1e400
wl1271: uploading fw chunk 0xe0cd760c to 0x1e600
wl1271: uploading fw chunk 0xe0cd780c to 0x1e800
wl1271: uploading fw chunk 0xe0cd7a0c to 0x1ea00
wl1271: uploading fw chunk 0xe0cd7c0c to 0x1ec00
wl1271: uploading fw chunk 0xe0cd7e0c to 0x1ee00
wl1271: uploading fw chunk 0xe0cd800c to 0x1f000
wl1271: uploading fw chunk 0xe0cd820c to 0x1f200
wl1271: uploading fw chunk 0xe0cd840c to 0x1f400
wl1271: uploading fw chunk 0xe0cd860c to 0x1f600
wl1271: uploading fw chunk 0xe0cd880c to 0x1f800
wl1271: uploading fw chunk 0xe0cd8a0c to 0x1fa00
wl1271: uploading fw chunk 0xe0cd8c0c to 0x1fc00
wl1271: uploading fw chunk 0xe0cd8e0c to 0x1fe00
wl1271: uploading fw chunk 0xe0cd900c to 0x20000
wl1271: uploading fw chunk 0xe0cd920c to 0x20200
wl1271: uploading fw chunk 0xe0cd940c to 0x20400
wl1271: uploading fw chunk 0xe0cd960c to 0x20600
wl1271: uploading fw chunk 0xe0cd980c to 0x20800
wl1271: uploading fw chunk 0xe0cd9a0c to 0x20a00
wl1271: uploading fw chunk 0xe0cd9c0c to 0x20c00
wl1271: uploading fw chunk 0xe0cd9e0c to 0x20e00
wl1271: uploading fw chunk 0xe0cda00c to 0x21000
wl1271: uploading fw chunk 0xe0cda20c to 0x21200
wl1271: uploading fw chunk 0xe0cda40c to 0x21400
wl1271: uploading fw chunk 0xe0cda60c to 0x21600
wl1271: uploading fw chunk 0xe0cda80c to 0x21800
wl1271: uploading fw chunk 0xe0cdaa0c to 0x21a00
wl1271: uploading fw chunk 0xe0cdac0c to 0x21c00
wl1271: uploading fw chunk 0xe0cdae0c to 0x21e00
wl1271: uploading fw chunk 0xe0cdb00c to 0x22000
wl1271: uploading fw chunk 0xe0cdb20c to 0x22200
wl1271: uploading fw chunk 0xe0cdb40c to 0x22400
wl1271: uploading fw chunk 0xe0cdb60c to 0x22600
wl1271: uploading fw chunk 0xe0cdb80c to 0x22800
wl1271: uploading fw chunk 0xe0cdba0c to 0x22a00
wl1271: uploading fw chunk 0xe0cdbc0c to 0x22c00
wl1271: uploading fw chunk 0xe0cdbe0c to 0x22e00
wl1271: uploading fw chunk 0xe0cdc00c to 0x23000
wl1271: uploading fw chunk 0xe0cdc20c to 0x23200
wl1271: uploading fw chunk 0xe0cdc40c to 0x23400
wl1271: uploading fw chunk 0xe0cdc60c to 0x23600
wl1271: uploading fw chunk 0xe0cdc80c to 0x23800
wl1271: uploading fw chunk 0xe0cdca0c to 0x23a00
wl1271: uploading fw chunk 0xe0cdcc0c to 0x23c00
wl1271: uploading fw chunk 0xe0cdce0c to 0x23e00
wl1271: uploading fw chunk 0xe0cdd00c to 0x24000
wl1271: uploading fw chunk 0xe0cdd20c to 0x24200
wl1271: uploading fw chunk 0xe0cdd40c to 0x24400
wl1271: uploading fw chunk 0xe0cdd60c to 0x24600
wl1271: uploading fw chunk 0xe0cdd80c to 0x24800
wl1271: uploading fw chunk 0xe0cdda0c to 0x24a00
wl1271: uploading fw chunk 0xe0cddc0c to 0x24c00
wl1271: uploading fw chunk 0xe0cdde0c to 0x24e00
wl1271: uploading fw chunk 0xe0cde00c to 0x25000
wl1271: uploading fw chunk 0xe0cde20c to 0x25200
wl1271: uploading fw chunk 0xe0cde40c to 0x25400
wl1271: uploading fw chunk 0xe0cde60c to 0x25600
wl1271: uploading fw chunk 0xe0cde80c to 0x25800
wl1271: uploading fw chunk 0xe0cdea0c to 0x25a00
wl1271: uploading fw chunk 0xe0cdec0c to 0x25c00
wl1271: uploading fw chunk 0xe0cdee0c to 0x25e00
wl1271: uploading fw chunk 0xe0cdf00c to 0x26000
wl1271: uploading fw chunk 0xe0cdf20c to 0x26200
wl1271: uploading fw chunk 0xe0cdf40c to 0x26400
wl1271: uploading fw chunk 0xe0cdf60c to 0x26600
wl1271: uploading fw chunk 0xe0cdf80c to 0x26800
wl1271: uploading fw chunk 0xe0cdfa0c to 0x26a00
wl1271: uploading fw chunk 0xe0cdfc0c to 0x26c00
wl1271: uploading fw chunk 0xe0cdfe0c to 0x26e00
wl1271: uploading fw chunk 0xe0ce000c to 0x27000
wl1271: uploading fw chunk 0xe0ce020c to 0x27200
wl1271: uploading fw chunk 0xe0ce040c to 0x27400
wl1271: uploading fw chunk 0xe0ce060c to 0x27600
wl1271: uploading fw chunk 0xe0ce080c to 0x27800
wl1271: uploading fw chunk 0xe0ce0a0c to 0x27a00
wl1271: uploading fw chunk 0xe0ce0c0c to 0x27c00
wl1271: uploading fw chunk 0xe0ce0e0c to 0x27e00
wl1271: uploading fw chunk 0xe0ce100c to 0x28000
wl1271: uploading fw chunk 0xe0ce120c to 0x28200
wl1271: uploading fw chunk 0xe0ce140c to 0x28400
wl1271: uploading fw chunk 0xe0ce160c to 0x28600
wl1271: uploading fw chunk 0xe0ce180c to 0x28800
wl1271: uploading fw chunk 0xe0ce1a0c to 0x28a00
wl1271: uploading fw chunk 0xe0ce1c0c to 0x28c00
wl1271: uploading fw chunk 0xe0ce1e0c to 0x28e00
wl1271: uploading fw chunk 0xe0ce200c to 0x29000
wl1271: uploading fw chunk 0xe0ce220c to 0x29200
wl1271: uploading fw chunk 0xe0ce240c to 0x29400
wl1271: uploading fw chunk 0xe0ce260c to 0x29600
wl1271: uploading fw chunk 0xe0ce280c to 0x29800
wl1271: uploading fw chunk 0xe0ce2a0c to 0x29a00
wl1271: uploading fw chunk 0xe0ce2c0c to 0x29c00
wl1271: uploading fw chunk 0xe0ce2e0c to 0x29e00
wl1271: uploading fw chunk 0xe0ce300c to 0x2a000
wl1271: uploading fw chunk 0xe0ce320c to 0x2a200
wl1271: uploading fw chunk 0xe0ce340c to 0x2a400
wl1271: uploading fw chunk 0xe0ce360c to 0x2a600
wl1271: uploading fw chunk 0xe0ce380c to 0x2a800
wl1271: uploading fw chunk 0xe0ce3a0c to 0x2aa00
wl1271: uploading fw chunk 0xe0ce3c0c to 0x2ac00
wl1271: uploading fw chunk 0xe0ce3e0c to 0x2ae00
wl1271: uploading fw chunk 0xe0ce400c to 0x2b000
wl1271: uploading fw chunk 0xe0ce420c to 0x2b200
wl1271: uploading fw chunk 0xe0ce440c to 0x2b400
wl1271: uploading fw chunk 0xe0ce460c to 0x2b600
wl1271: uploading fw chunk 0xe0ce480c to 0x2b800
wl1271: uploading fw chunk 0xe0ce4a0c to 0x2ba00
wl1271: uploading fw chunk 0xe0ce4c0c to 0x2bc00
wl1271: uploading fw chunk 0xe0ce4e0c to 0x2be00
wl1271: uploading fw chunk 0xe0ce500c to 0x2c000
wl1271: uploading fw chunk 0xe0ce520c to 0x2c200
wl1271: uploading fw chunk 0xe0ce540c to 0x2c400
wl1271: uploading fw chunk 0xe0ce560c to 0x2c600
wl1271: uploading fw chunk 0xe0ce580c to 0x2c800
wl1271: uploading fw chunk 0xe0ce5a0c to 0x2ca00
wl1271: uploading fw chunk 0xe0ce5c0c to 0x2cc00
wl1271: uploading fw chunk 0xe0ce5e0c to 0x2ce00
wl1271: uploading fw chunk 0xe0ce600c to 0x2d000
wl1271: uploading fw chunk 0xe0ce620c to 0x2d200
wl1271: uploading fw chunk 0xe0ce640c to 0x2d400
wl1271: uploading fw chunk 0xe0ce660c to 0x2d600
wl1271: uploading fw chunk 0xe0ce680c to 0x2d800
wl1271: uploading fw chunk 0xe0ce6a0c to 0x2da00
wl1271: uploading fw chunk 0xe0ce6c0c to 0x2dc00
wl1271: uploading fw chunk 0xe0ce6e0c to 0x2de00
wl1271: uploading fw chunk 0xe0ce700c to 0x2e000
wl1271: uploading fw chunk 0xe0ce720c to 0x2e200
wl1271: uploading fw chunk 0xe0ce740c to 0x2e400
wl1271: uploading fw chunk 0xe0ce760c to 0x2e600
wl1271: mem_start 0002E800 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0ce780c to 0x2e800
wl1271: uploading fw chunk 0xe0ce7a0c to 0x2ea00
wl1271: uploading fw chunk 0xe0ce7c0c to 0x2ec00
wl1271: uploading fw chunk 0xe0ce7e0c to 0x2ee00
wl1271: uploading fw chunk 0xe0ce800c to 0x2f000
wl1271: uploading fw chunk 0xe0ce820c to 0x2f200
wl1271: uploading fw chunk 0xe0ce840c to 0x2f400
wl1271: uploading fw chunk 0xe0ce860c to 0x2f600
wl1271: uploading fw chunk 0xe0ce880c to 0x2f800
wl1271: uploading fw chunk 0xe0ce8a0c to 0x2fa00
wl1271: uploading fw last chunk (24 B) 0xe0ce8c0c to 0x2fc00
wl1271: chunk 4 addr 0x20000000 len 48936
wl1271: starting firmware upload
wl1271: fw_data_len 48936 chunk_size 512
wl1271: mem_start 20000000 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: mem_start 20000000 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0ce8c2c to 0x20000000
wl1271: mem_start 20000200 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0ce8e2c to 0x20000200
wl1271: mem_start 20000400 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0ce902c to 0x20000400
wl1271: mem_start 20000600 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0ce922c to 0x20000600
wl1271: mem_start 20000800 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0ce942c to 0x20000800
wl1271: mem_start 20000A00 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0ce962c to 0x20000a00
wl1271: mem_start 20000C00 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0ce982c to 0x20000c00
wl1271: mem_start 20000E00 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0ce9a2c to 0x20000e00
wl1271: mem_start 20001000 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0ce9c2c to 0x20001000
wl1271: mem_start 20001200 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0ce9e2c to 0x20001200
wl1271: mem_start 20001400 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cea02c to 0x20001400
wl1271: mem_start 20001600 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cea22c to 0x20001600
wl1271: mem_start 20001800 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cea42c to 0x20001800
wl1271: mem_start 20001A00 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cea62c to 0x20001a00
wl1271: mem_start 20001C00 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cea82c to 0x20001c00
wl1271: mem_start 20001E00 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0ceaa2c to 0x20001e00
wl1271: mem_start 20002000 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0ceac2c to 0x20002000
wl1271: mem_start 20002200 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0ceae2c to 0x20002200
wl1271: mem_start 20002400 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0ceb02c to 0x20002400
wl1271: mem_start 20002600 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0ceb22c to 0x20002600
wl1271: mem_start 20002800 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0ceb42c to 0x20002800
wl1271: mem_start 20002A00 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0ceb62c to 0x20002a00
wl1271: mem_start 20002C00 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0ceb82c to 0x20002c00
wl1271: mem_start 20002E00 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0ceba2c to 0x20002e00
wl1271: mem_start 20003000 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cebc2c to 0x20003000
wl1271: mem_start 20003200 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cebe2c to 0x20003200
wl1271: mem_start 20003400 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cec02c to 0x20003400
wl1271: mem_start 20003600 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cec22c to 0x20003600
wl1271: mem_start 20003800 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cec42c to 0x20003800
wl1271: mem_start 20003A00 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cec62c to 0x20003a00
wl1271: mem_start 20003C00 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cec82c to 0x20003c00
wl1271: mem_start 20003E00 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0ceca2c to 0x20003e00
wl1271: mem_start 20004000 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cecc2c to 0x20004000
wl1271: mem_start 20004200 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cece2c to 0x20004200
wl1271: mem_start 20004400 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0ced02c to 0x20004400
wl1271: mem_start 20004600 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0ced22c to 0x20004600
wl1271: mem_start 20004800 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0ced42c to 0x20004800
wl1271: mem_start 20004A00 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0ced62c to 0x20004a00
wl1271: mem_start 20004C00 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0ced82c to 0x20004c00
wl1271: mem_start 20004E00 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0ceda2c to 0x20004e00
wl1271: mem_start 20005000 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cedc2c to 0x20005000
wl1271: mem_start 20005200 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cede2c to 0x20005200
wl1271: mem_start 20005400 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cee02c to 0x20005400
wl1271: mem_start 20005600 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cee22c to 0x20005600
wl1271: mem_start 20005800 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cee42c to 0x20005800
wl1271: mem_start 20005A00 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cee62c to 0x20005a00
wl1271: mem_start 20005C00 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cee82c to 0x20005c00
wl1271: mem_start 20005E00 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0ceea2c to 0x20005e00
wl1271: mem_start 20006000 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0ceec2c to 0x20006000
wl1271: mem_start 20006200 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0ceee2c to 0x20006200
wl1271: mem_start 20006400 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cef02c to 0x20006400
wl1271: mem_start 20006600 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cef22c to 0x20006600
wl1271: mem_start 20006800 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cef42c to 0x20006800
wl1271: mem_start 20006A00 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cef62c to 0x20006a00
wl1271: mem_start 20006C00 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cef82c to 0x20006c00
wl1271: mem_start 20006E00 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cefa2c to 0x20006e00
wl1271: mem_start 20007000 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cefc2c to 0x20007000
wl1271: mem_start 20007200 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cefe2c to 0x20007200
wl1271: mem_start 20007400 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf002c to 0x20007400
wl1271: mem_start 20007600 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf022c to 0x20007600
wl1271: mem_start 20007800 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf042c to 0x20007800
wl1271: mem_start 20007A00 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf062c to 0x20007a00
wl1271: mem_start 20007C00 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf082c to 0x20007c00
wl1271: mem_start 20007E00 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf0a2c to 0x20007e00
wl1271: mem_start 20008000 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf0c2c to 0x20008000
wl1271: mem_start 20008200 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf0e2c to 0x20008200
wl1271: mem_start 20008400 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf102c to 0x20008400
wl1271: mem_start 20008600 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf122c to 0x20008600
wl1271: mem_start 20008800 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf142c to 0x20008800
wl1271: mem_start 20008A00 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf162c to 0x20008a00
wl1271: mem_start 20008C00 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf182c to 0x20008c00
wl1271: mem_start 20008E00 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf1a2c to 0x20008e00
wl1271: mem_start 20009000 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf1c2c to 0x20009000
wl1271: mem_start 20009200 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf1e2c to 0x20009200
wl1271: mem_start 20009400 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf202c to 0x20009400
wl1271: mem_start 20009600 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf222c to 0x20009600
wl1271: mem_start 20009800 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf242c to 0x20009800
wl1271: mem_start 20009A00 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf262c to 0x20009a00
wl1271: mem_start 20009C00 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf282c to 0x20009c00
wl1271: mem_start 20009E00 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf2a2c to 0x20009e00
wl1271: mem_start 2000A000 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf2c2c to 0x2000a000
wl1271: mem_start 2000A200 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf2e2c to 0x2000a200
wl1271: mem_start 2000A400 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf302c to 0x2000a400
wl1271: mem_start 2000A600 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf322c to 0x2000a600
wl1271: mem_start 2000A800 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf342c to 0x2000a800
wl1271: mem_start 2000AA00 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf362c to 0x2000aa00
wl1271: mem_start 2000AC00 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf382c to 0x2000ac00
wl1271: mem_start 2000AE00 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf3a2c to 0x2000ae00
wl1271: mem_start 2000B000 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf3c2c to 0x2000b000
wl1271: mem_start 2000B200 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf3e2c to 0x2000b200
wl1271: mem_start 2000B400 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf402c to 0x2000b400
wl1271: mem_start 2000B600 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf422c to 0x2000b600
wl1271: mem_start 2000B800 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf442c to 0x2000b800
wl1271: mem_start 2000BA00 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf462c to 0x2000ba00
wl1271: mem_start 2000BC00 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf482c to 0x2000bc00
wl1271: uploading fw last chunk (296 B) 0xe0cf4a2c to 0x2000be00
wl1271: chunk 3 addr 0x40000 len 448
wl1271: starting firmware upload
wl1271: fw_data_len 448 chunk_size 512
wl1271: mem_start 00040000 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw last chunk (448 B) 0xe0cf4b5c to 0x40000
wl1271: chunk 2 addr 0x40be0 len 16332
wl1271: starting firmware upload
wl1271: fw_data_len 16332 chunk_size 512
wl1271: mem_start 00040BE0 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: mem_start 00040BE0 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf4d24 to 0x40be0
wl1271: mem_start 00040DE0 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf4f24 to 0x40de0
wl1271: mem_start 00040FE0 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf5124 to 0x40fe0
wl1271: mem_start 000411E0 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf5324 to 0x411e0
wl1271: mem_start 000413E0 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf5524 to 0x413e0
wl1271: mem_start 000415E0 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf5724 to 0x415e0
wl1271: mem_start 000417E0 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf5924 to 0x417e0
wl1271: mem_start 000419E0 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf5b24 to 0x419e0
wl1271: mem_start 00041BE0 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf5d24 to 0x41be0
wl1271: mem_start 00041DE0 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf5f24 to 0x41de0
wl1271: mem_start 00041FE0 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf6124 to 0x41fe0
wl1271: mem_start 000421E0 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf6324 to 0x421e0
wl1271: mem_start 000423E0 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf6524 to 0x423e0
wl1271: mem_start 000425E0 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf6724 to 0x425e0
wl1271: mem_start 000427E0 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf6924 to 0x427e0
wl1271: mem_start 000429E0 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf6b24 to 0x429e0
wl1271: mem_start 00042BE0 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf6d24 to 0x42be0
wl1271: mem_start 00042DE0 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf6f24 to 0x42de0
wl1271: mem_start 00042FE0 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf7124 to 0x42fe0
wl1271: mem_start 000431E0 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf7324 to 0x431e0
wl1271: mem_start 000433E0 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf7524 to 0x433e0
wl1271: mem_start 000435E0 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf7724 to 0x435e0
wl1271: mem_start 000437E0 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf7924 to 0x437e0
wl1271: mem_start 000439E0 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf7b24 to 0x439e0
wl1271: mem_start 00043BE0 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf7d24 to 0x43be0
wl1271: mem_start 00043DE0 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf7f24 to 0x43de0
wl1271: mem_start 00043FE0 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf8124 to 0x43fe0
wl1271: mem_start 000441E0 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf8324 to 0x441e0
wl1271: mem_start 000443E0 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf8524 to 0x443e0
wl1271: mem_start 000445E0 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf8724 to 0x445e0
wl1271: mem_start 000447E0 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf8924 to 0x447e0
wl1271: uploading fw last chunk (460 B) 0xe0cf8b24 to 0x449e0
wl1271: chunk 1 addr 0x312000 len 8092
wl1271: starting firmware upload
wl1271: fw_data_len 8092 chunk_size 512
wl1271: mem_start 00312000 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: mem_start 00312000 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf8cf8 to 0x312000
wl1271: mem_start 00312200 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf8ef8 to 0x312200
wl1271: mem_start 00312400 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf90f8 to 0x312400
wl1271: mem_start 00312600 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf92f8 to 0x312600
wl1271: mem_start 00312800 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf94f8 to 0x312800
wl1271: mem_start 00312A00 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf96f8 to 0x312a00
wl1271: mem_start 00312C00 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf98f8 to 0x312c00
wl1271: mem_start 00312E00 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf9af8 to 0x312e00
wl1271: mem_start 00313000 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf9cf8 to 0x313000
wl1271: mem_start 00313200 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cf9ef8 to 0x313200
wl1271: mem_start 00313400 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cfa0f8 to 0x313400
wl1271: mem_start 00313600 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cfa2f8 to 0x313600
wl1271: mem_start 00313800 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cfa4f8 to 0x313800
wl1271: mem_start 00313A00 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cfa6f8 to 0x313a00
wl1271: mem_start 00313C00 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cfa8f8 to 0x313c00
wl1271: uploading fw last chunk (412 B) 0xe0cfaaf8 to 0x313e00
wl1271: chunk 0 addr 0x316000 len 3784
wl1271: starting firmware upload
wl1271: fw_data_len 3784 chunk_size 512
wl1271: mem_start 00316000 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: mem_start 00316000 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cfac9c to 0x316000
wl1271: mem_start 00316200 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cfae9c to 0x316200
wl1271: mem_start 00316400 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cfb09c to 0x316400
wl1271: mem_start 00316600 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cfb29c to 0x316600
wl1271: mem_start 00316800 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cfb49c to 0x316800
wl1271: mem_start 00316A00 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cfb69c to 0x316a00
wl1271: mem_start 00316C00 mem_size 000177C0
wl1271: reg_start 00300000 reg_size 00008800
wl1271: mem2_start 00000000 mem2_size 00000000
wl1271: mem3_start 00000000 mem3_size 00000000
wl1271: uploading fw chunk 0xe0cfb89c to 0x316c00
wl1271: uploading fw last chunk (200 B) 0xe0cfba9c to 0x316e00
wl1271: chip id after firmware boot: 0x4030111
wl1271: mem_start 00040000 mem_size 00014FC0
wl1271: reg_start 00300000 reg_size 0000A000
wl1271: mem2_start 003004F8 mem2_size 00000004
wl1271: mem3_start 00040404 mem3_size 00000000
wl1271: cmd_box_addr 0x407b4 event_box_addr 0x4ce58
wl1271: acx event mbox mask
wl1271: cmd configure
wl1271: MBOX ptrs: 0x4ce58 0x4ceac
wl1271: MBOX ptrs: 0x4ce58 0x4ceac
wl1271: cmd test
wl1271: FEM autodetect: manual, manufacturer: 1

wl1271: TEST_CMD_INI_FILE_RADIO_PARAM: 00000000: 00 00 00 00 19 00 00 00
00 00 ec f6 00 0c 18 f8
wl1271: TEST_CMD_INI_FILE_RADIO_PARAM: 00000010: fc 00 08 10 f0 f8 00 0a
14 00 00 00 00 00 00 00
wl1271: TEST_CMD_INI_FILE_RADIO_PARAM: 00000020: 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00
wl1271: TEST_CMD_INI_FILE_RADIO_PARAM: 00000030: 00 00 00 00 00 00 77 01
80 00 1d 1f 22 26 27 29
wl1271: TEST_CMD_INI_FILE_RADIO_PARAM: 00000040: 1a 1f 22 25 25 27 16 1d
1e 20 24 25 50 50 50 50
wl1271: TEST_CMD_INI_FILE_RADIO_PARAM: 00000050: 50 50 50 50 50 50 50 50
50 50 50 50 50 50 50 50
wl1271: TEST_CMD_INI_FILE_RADIO_PARAM: 00000060: 50 50 50 50 50 50 50 50
01 02 02 02 02 00 15 15
wl1271: TEST_CMD_INI_FILE_RADIO_PARAM: 00000070: 15 11 15 15 0e 1e 2d 00
00 00 00 00 00 00 00 00
wl1271: TEST_CMD_INI_FILE_RADIO_PARAM: 00000080: 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00
wl1271: TEST_CMD_INI_FILE_RADIO_PARAM: 00000090: 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00
wl1271: TEST_CMD_INI_FILE_RADIO_PARAM: 000000a0: 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00
wl1271: TEST_CMD_INI_FILE_RADIO_PARAM: 000000b0: 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00
wl1271: TEST_CMD_INI_FILE_RADIO_PARAM: 000000c0: 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00
wl1271: TEST_CMD_INI_FILE_RADIO_PARAM: 000000d0: 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00
wl1271: cmd test
wl1271: TEST_CMD_INI_FILE_EXT_RADIO_PARAM: 00000000: 00 00 00 00 26 00
00 00 00 00 00 00 00 00 00 00
wl1271: TEST_CMD_INI_FILE_EXT_RADIO_PARAM: 00000010: 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00
wl1271: TEST_CMD_INI_FILE_EXT_RADIO_PARAM: 00000020: 00 00 00 00
wl1271: cmd test
wl1271: acx config ps
wl1271: cmd configure
wl1271: cmd template_set 2
wl1271: cmd template_set 3
wl1271: cmd template_set 0
wl1271: cmd template_set 6
wl1271: cmd template_set 5
wl1271: cmd template_set 4
wl1271: cmd template_set 1
wl1271: cmd template_set 13
wl1271: cmd template_set 7
wl1271: cmd template_set 7
wl1271: cmd template_set 7
wl1271: cmd template_set 7
wl1271: acx group address tbl
wl1271: cmd configure
wl1271: acx connection monitor parameters: disabled
wl1271: cmd configure
wl1271: acx beacon filter opt
wl1271: cmd configure
wl1271: acx beacon filter table
wl1271: cmd configure
wl1271: acx fm coex setting
wl1271: cmd configure
wl1271: acx bcn dtim options
wl1271: cmd configure
wl1271: acx sleep auth
wl1271: cmd configure
wl1271: acx rssi snr avg weights
wl1271: cmd configure
wl1271: acx rate policies
wl1271: basic_rate: 0x3, full_rate: 0x3
wl1271: cmd configure
wl1271: wl1271 mem cfg
wl1271: cmd configure
wl1271: acx sg sta cfg
wl1271: cmd configure
wl1271: acx sg enable
wl1271: cmd configure
wl1271: acx mem map
wl1271: cmd interrogate
wl1271: available tx blocks: 99
wl1271: acx rx msdu life time
wl1271: cmd configure
wl1271: acx rx config
wl1271: cmd configure
wl1271: acx data pd threshold
wl1271: cmd configure
wl1271: acx slot
wl1271: cmd configure
wl1271: acx service period timeout
wl1271: cmd configure
wl1271: acx rts threshold: 2353
wl1271: cmd configure
wl1271: acx dco itrim parameters
wl1271: cmd configure
wl1271: acx tx config options
wl1271: cmd configure
wl1271: wl1271 rx interrupt config
wl1271: cmd configure
wl1271: acx cca threshold
wl1271: cmd configure
wl1271: acx frag threshold: 2352
wl1271: cmd configure
wl1271: acx ac cfg 0 cw_ming 15 cw_max 63 aifs 3 txop 0
wl1271: cmd configure
wl1271: acx tid config
wl1271: cmd configure
wl1271: acx ac cfg 1 cw_ming 15 cw_max 63 aifs 7 txop 0
wl1271: cmd configure
wl1271: acx tid config
wl1271: cmd configure
wl1271: acx ac cfg 2 cw_ming 15 cw_max 63 aifs 1 txop 3008
wl1271: cmd configure
wl1271: acx tid config
wl1271: cmd configure
wl1271: acx ac cfg 3 cw_ming 15 cw_max 63 aifs 1 txop 1504
wl1271: cmd configure
wl1271: acx tid config
wl1271: cmd configure
wl1271: cmd data path
wl1271: rx start cmd channel 1
wl1271: tx start cmd channel 1
wl1271: acx feature cfg
wl1271: cmd configure
wl1271: acx pm config
wl1271: cmd configure
wl1271: cmd set_default_wep_key 0
wl1271: acx keep alive config
wl1271: cmd configure
wl1271: acx keep alive config
wl1271: cmd configure
wl1271: acx keep alive config
wl1271: cmd configure
wl1271: acx keep alive config
wl1271: cmd configure
wl1271: acx keep alive mode: 0
wl1271: cmd configure
wl1271: acx ba session setting
wl1271: cmd configure
wl1271: acx ba session setting
wl1271: cmd configure
wl1271: acx ba session setting
wl1271: cmd configure
wl1271: acx ba session setting
wl1271: cmd configure
wl1271: acx ba session setting
wl1271: cmd configure
wl1271: acx ba session setting
wl1271: cmd configure
wl1271: acx ba session setting
wl1271: cmd configure
wl1271: acx ba session setting
wl1271: cmd configure
wl1271: firmware booted (Rev 6.1.3.50.58)
wl1271: 11a is not supported
wl1271: mac80211 bss info changed 0xe
wl1271: acx slot
wl1271: cmd configure
wl1271: acx_set_preamble
wl1271: cmd configure
wl1271: acx_set_ctsprotect
wl1271: cmd configure
wl1271: mac80211 bss info changed 0x4000
wl1271: mac80211 config ch 1 psm off power 20 idle changed 0xffffffff
wl1271: flushing tx buffer: 0 0
wl1271: acx rate policies
wl1271: basic_rate: 0x1, full_rate: 0x3
wl1271: cmd configure
wl1271: acx rate policies
wl1271: basic_rate: 0x1, full_rate: 0x1
wl1271: cmd configure
wl1271: acx keep alive config
wl1271: cmd configure
wl1271: acx dot11_cur_tx_pwr
wl1271: cmd configure
wl1271: mac80211 conf tx 0
wl1271: acx ac cfg 3 cw_ming 7 cw_max 15 aifs 2 txop 3264
wl1271: cmd configure
wl1271: acx tid config
wl1271: cmd configure
wl1271: mac80211 conf tx 1
wl1271: acx ac cfg 2 cw_ming 15 cw_max 31 aifs 2 txop 6016
wl1271: cmd configure
wl1271: acx tid config
wl1271: cmd configure
wl1271: mac80211 conf tx 2
wl1271: acx ac cfg 0 cw_ming 31 cw_max 1023 aifs 3 txop 0
wl1271: cmd configure
wl1271: acx tid config
wl1271: cmd configure
wl1271: mac80211 conf tx 3
wl1271: acx ac cfg 1 cw_ming 31 cw_max 1023 aifs 7 txop 0
wl1271: cmd configure
wl1271: acx tid config
wl1271: cmd configure
wl1271: mac80211 bss info changed 0x2000
wl1271: elp work
wl1271: chip to elp
wl1271: sdio write 52 addr 0x1fffc, byte 0x00
wl1271: waking up chip from elp
wl1271: sdio write 52 addr 0x1fffc, byte 0x01
	This is from
	wl1271_raw_write32(wl, HW_ACCESS_ELP_CTRL_REG_ADDR, ELPCTRL_WAKE_UP);
	But WLAN_IRQ is always low, never goes high.

wl1271: ERROR ELP wakeup timeout!

	Timeout waiting for WLAN_IRQ to go high.
		
wl1271: Hardware recovery in progress. FW ver: Rev 6.1.3.50.58 pc: 0x0
wl1271: mac80211 remove interface
.................
