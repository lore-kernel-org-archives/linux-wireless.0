Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout2.ltindia.com ([125.18.18.171]:8756 "EHLO
	mailout2.ltindia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975Ab2DKOkB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 10:40:01 -0400
From: Girish Bn <Girish.BN@lnties.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: WL12xx: Managed/Ad-Hoc Modes doesn't work in Open Mode
Date: Wed, 11 Apr 2012 14:39:52 +0000
Message-ID: <45566970CF58C74CB52107862E0541CD1CFD8F0D@POCITMSEXMB03.LntUniverse.com> (sfid-20120411_164007_868891_AFD73F37)
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

With latest Compat wireless package (2012-04-034 and firmware Rev 6.3.7.0.105 ) I am able to successfully calibrate and nvs file sucessfully.
However, I am not able to connect to any device. there is crash in the modules. However I am able to do the scan operation successfully.
There is crash after running the following commands
>ifconfig wlan0 192.168.1.6 up
>iw dev wlan0 scan
>iw wlan0 connect Digisol

Please find the log below
~ # dmesg
Linux version 2.6.28.2 (root@ubuntu) (gcc version 4.4.2 (GCC) ) #3 Thu Mar 22 03:04:06 PDT 2012
CPU: ARM926EJ-S [41069265] revision 5 (ARMv5TEJ), cr=00053177
CPU: VIVT data cache, VIVT instruction cache
Machine: Brady BPS313XV1
Memory policy: ECC disabled, Data cache writeback
On node 0 totalpages: 8192
free_area_init_node: node 0, pgdat c024d008, node_mem_map c0262000
  Normal zone: 64 pages used for memmap
  Normal zone: 0 pages reserved
  Normal zone: 8128 pages, LIFO batch:0
  Movable zone: 0 pages used for memmap
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 8128
Kernel command line: console=0 rootfstype=jffs2 quiet root=/dev/mtdblock7 safefs=0 kernel=1 sku=772
irq=30 Event=0x3e bank:1 bit:30 type:0

irq=31 Event=0x54 bank:2 bit:20 type:0

irq=32 Event=0x4b bank:2 bit:11 type:0

PID hash table entries: 128 (order: 7, 512 bytes)
Console: colour dummy device 80x30
console [ttyS0] enabled
Dentry cache hash table entries: 4096 (order: 2, 16384 bytes)
Inode-cache hash table entries: 2048 (order: 1, 8192 bytes)
Memory: 32MB = 32MB total
Memory: 30012KB available (2136K code, 177K data, 88K init)
Calibrating delay loop... 89.70 BogoMIPS (lpj=448512)
Security Framework initialized
Mount-cache hash table entries: 512
CPU: Testing write buffer coherency: ok
net_namespace: 288 bytes
NET: Registered protocol family 16
cgu_init pll set at 180000000
Registering USB gadget 0x00000f20 0x02800004 (3)
LPC31: Power Management init.
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
NET: Registered protocol family 2
IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
TCP established hash table entries: 1024 (order: 1, 8192 bytes)
TCP bind hash table entries: 1024 (order: 0, 4096 bytes)
TCP: Hash tables configured (established 1024 bind 1024)
TCP reno registered
NET: Registered protocol family 1
NetWinder Floating Point Emulator V0.97 (double precision)
JFFS2 version 2.2. (NAND) (SUMMARY)  © 2001-2006 Red Hat, Inc.
msgmni has been set to 58
alg: No test for stdrng (krng)
io scheduler noop registered (default)
Serial: 8250/16550 driver1 ports, IRQ sharing disabled
serial8250: ttyS0 at MMIO 0x15001000 (irq = 10) is a NXP16750
serial8250.0: ttyS0 at MMIO 0x15001000 (irq = 10) is a NXP16750
NAND device: Manufacturer ID: 0x20, Chip ID: 0x73 (ST Micro NAND 16MiB 3,3V 8-bit)
Bad block table found at page 32736, version 0x00
Bad block table found at page 32704, version 0x00
nand_read_bbt: Bad block at 0x00000000
nand_read_bbt: Bad block at 0x00000000
Creating 10 MTD partitions on "NAND 16MiB 3,3V 8-bit":
0x00004000-0x00018000 : "apex1"
0x00018000-0x0002c000 : "apex2"
0x0002c000-0x00030000 : "apex-env"
0x00030000-0x00050000 : "sysconfig"
0x00050000-0x00208000 : "kernel1"
0x00208000-0x003c0000 : "kernel2"
0x003c0000-0x00440000 : "configfs"
0x00440000-0x00de8000 : "rootfs"
0x00de8000-0x00fe8000 : "safefs"
0x00fe8000-0x00ff0000 : "log"
mice: PS/2 mouse device common for all mice
CGU: Get clock id:34 freq:6000000
lpc313x-wdt lpc313x-wdt: Watchdog device driver initialized.
cpuidle: using governor ladder
TCP cubic registered
NET: Registered protocol family 17
ieee80211: 802.11 data/management/control stack, git-1.1.13
ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
ieee80211_crypt: registered algorithm 'NULL'
ieee80211_crypt: registered algorithm 'WEP'
VFS: Mounted root (jffs2 filesystem) readonly.
Freeing init memory: 88K
CGU: Get clock id:34 freq:6000000
lpc313x-wdt lpc313x-wdt: Watchdog timer closed unexpectedly
Empty flash at 0x000021ac ends at 0x00002200
CGU: Get clock id:34 freq:6000000
lpc313x-wdt lpc313x-wdt: Watchdog timer closed unexpectedly
CGU: Get clock id:34 freq:6000000
lpc313x-wdt lpc313x-wdt: Watchdog timer closed unexpectedly
CGU: Get clock id:34 freq:6000000
lpc313x-wdt lpc313x-wdt: Watchdog timer closed unexpectedly
Freescale High-Speed USB SOC Device Controller driver (Apr 20, 2007)
g_serial gadget: Gadget Serial v2.4
g_serial gadget: g_serial ready
fsl-usb2-udc: bind to driver g_serial
CGU: Get clock id:34 freq:6000000
lpc313x-wdt lpc313x-wdt: Watchdog timer closed unexpectedly
g_serial gadget: high speed config #2: CDC ACM config
CGU: Get clock id:34 freq:6000000
JFFS2 notice: (289) check_node_data: wrong data CRC in data node at 0x008c9f44: read 0x2c798f7c, calculated 0x6700a86.
JFFS2 notice: (289) check_node_data: wrong data CRC in data node at 0x008aa9d0: read 0x8dd9efbb, calculated 0xb49f0abf.
Compat-wireless backport release: compat-wireless-2012-04-02-2-1-g5c6c8e6
Backport based on linux-next.git next-20120404
CGU: Get clock id:20 freq:45000000
Powering off wl12xx<6>Powering off wl12xx<6>Powering down MMC Slot<6>Powering on wl12xx<6>lpc313x_mmc lpc313x_mmc.0: LPC313x MMC controller at irq 26
Powering up MMC Slot<4>mmc0: card claims to support voltages below the defined range. These will be ignored.
mmc0: queuing CIS tuple 0x91 length 3
mmc_attach_sdio the value of funcs=0x2
Powering on wl12xx<6>mmc_attach_sdio the value of funcs=0x2
mmc0: new SDIO card at address 0001
cfg80211: Calling CRDA to update world regulatory domain
wl1271_probe: the value of func->num = 0x2
wl12xx: loaded
wl12xx: firmware booted (Rev 6.3.7.0.105)
~ # iw dev wlan0 scan
BSS 68:7f:74:e5:67:52 (on wlan0)
               TSF: 265454534411 usec (3d, 01:44:14)
               freq: 2437
               beacon interval: 100
               capability: ESS Privacy ShortPreamble ShortSlotTime (0x0431)
               signal: -45.00 dBm
               last seen: 410 ms ago
               SSID: Leviton
               Supported rates: 1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0
               DS Parameter set: channel 6
               RSN:      * Version: 1
                              * Group cipher: TKIP
                              * Pairwise ciphers: CCMP
                              * Authentication suites: PSK
                              * Capabilities: PreAuth (0x0001)
               WPA:     * Version: 1
                              * Group cipher: TKIP
                              * Pairwise ciphers: TKIP
                              * Authentication suites: PSK
               ERP: <no flags>
               Extended supported rates: 24.0 36.0 48.0 54.0
               WMM:  * Parameter version 1
                              * BE: CW 15-1023, AIFSN 3
                              * BK: CW 15-1023, AIFSN 7
                              * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
                              * VO: acm CW 3-7, AIFSN 2, TXOP 1504 usec
               WPS:      * Version: 1.0
                              * Wi-Fi Protected Setup State: 2 (Configured)
                              * Selected Registrar: 0x0
                              * Response Type: 3 (AP)
                              * UUID: 00000000-0000-0001-1000-687f74e56752
                              * Manufacturer: Linksys Corporation
                              * Model: WRT120N
                              * Model Number: v1.0.04
                              * Serial Number: JUT00K749982
                              * Primary Device Type: 6-0050f204-1
                              * Device name: Wireless Router(WFA)
                              * Config methods: Label, PBC
BSS 00:17:7c:16:4f:24 (on wlan0)
               TSF: 6402078552 usec (0d, 01:46:42)
               freq: 2462
               beacon interval: 100
               capability: ESS ShortSlotTime (0x0401)
               signal: -53.00 dBm
               last seen: 350 ms ago
               SSID: Digisol
               Supported rates: 1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0
               DS Parameter set: channel 11
               ERP: <no flags>
               Extended supported rates: 24.0 36.0 48.0 54.0
               HT capabilities:
                              Capabilities: 0x186e
                                             HT20/HT40
                                             SM Power Save disabled
                                             RX HT20 SGI
                                             RX HT40 SGI
                                             No RX STBC
                                             Max AMSDU length: 7935 bytes
                                             DSSS/CCK HT40
                              Maximum RX AMPDU length 32767 bytes (exponent: 0x002)
                              Minimum RX AMPDU time spacing: 8 usec (0x06)
                              HT RX MCS rate indexes supported: 0-7
                              HT TX MCS rate indexes are undefined
               HT operation:
                              * primary channel: 11
                              * secondary channel offset: below
                              * STA channel width: any
                              * RIFS: 0
                              * HT protection: no
                              * non-GF present: 0
                              * OBSS non-GF present: 0
                              * dual beacon: 0
                              * dual CTS protection: 0
                              * STBC beacon: 0
                              * L-SIG TXOP Prot: 0
                              * PCO active: 0
                              * PCO phase: 0
               WMM:  * Parameter version 1
                              * BE: CW 15-1023, AIFSN 3
                              * BK: CW 15-1023, AIFSN 7
                              * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
                              * VO: acm CW 3-7, AIFSN 2, TXOP 1504 usec
               WPS:      * Version: 1.0
                              * Wi-Fi Protected Setup State: 1 (Unconfigured)
                              * Response Type: 3 (AP)
                              * UUID: 63041253-1019-2006-1228-00177c164f24
                              * Manufacturer:
                               * Model: RTL8xxx
                              * Model Number: EV-2009-02-06
                              * Serial Number: 123456789012347
                              * Primary Device Type: 6-0050f204-1
                              * Device name: Wireless Router
                              * Config methods: Ethernet, Label, PBC
~ # iw wlan0 connect Digisol
~ # dmesg
Linux version 2.6.28.2 (root@ubuntu) (gcc version 4.4.2 (GCC) ) #3 Thu Mar 22 03:04:06 PDT 2012
CPU: ARM926EJ-S [41069265] revision 5 (ARMv5TEJ), cr=00053177
CPU: VIVT data cache, VIVT instruction cache
Machine: Brady BPS313XV1
Memory policy: ECC disabled, Data cache writeback
On node 0 totalpages: 8192
free_area_init_node: node 0, pgdat c024d008, node_mem_map c0262000
  Normal zone: 64 pages used for memmap
  Normal zone: 0 pages reserved
  Normal zone: 8128 pages, LIFO batch:0
  Movable zone: 0 pages used for memmap
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 8128
Kernel command line: console=0 rootfstype=jffs2 quiet root=/dev/mtdblock7 safefs=0 kernel=1 sku=772
irq=30 Event=0x3e bank:1 bit:30 type:0

irq=31 Event=0x54 bank:2 bit:20 type:0

irq=32 Event=0x4b bank:2 bit:11 type:0

PID hash table entries: 128 (order: 7, 512 bytes)
Console: colour dummy device 80x30
console [ttyS0] enabled
Dentry cache hash table entries: 4096 (order: 2, 16384 bytes)
Inode-cache hash table entries: 2048 (order: 1, 8192 bytes)
Memory: 32MB = 32MB total
Memory: 30012KB available (2136K code, 177K data, 88K init)
Calibrating delay loop... 89.70 BogoMIPS (lpj=448512)
Security Framework initialized
Mount-cache hash table entries: 512
CPU: Testing write buffer coherency: ok
net_namespace: 288 bytes
NET: Registered protocol family 16
cgu_init pll set at 180000000
Registering USB gadget 0x00000f20 0x02800004 (3)
LPC31: Power Management init.
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
NET: Registered protocol family 2
IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
TCP established hash table entries: 1024 (order: 1, 8192 bytes)
TCP bind hash table entries: 1024 (order: 0, 4096 bytes)
TCP: Hash tables configured (established 1024 bind 1024)
TCP reno registered
NET: Registered protocol family 1
NetWinder Floating Point Emulator V0.97 (double precision)
JFFS2 version 2.2. (NAND) (SUMMARY)  © 2001-2006 Red Hat, Inc.
msgmni has been set to 58
alg: No test for stdrng (krng)
io scheduler noop registered (default)
Serial: 8250/16550 driver1 ports, IRQ sharing disabled
serial8250: ttyS0 at MMIO 0x15001000 (irq = 10) is a NXP16750
serial8250.0: ttyS0 at MMIO 0x15001000 (irq = 10) is a NXP16750
NAND device: Manufacturer ID: 0x20, Chip ID: 0x73 (ST Micro NAND 16MiB 3,3V 8-bit)
Bad block table found at page 32736, version 0x00
Bad block table found at page 32704, version 0x00
nand_read_bbt: Bad block at 0x00000000
nand_read_bbt: Bad block at 0x00000000
Creating 10 MTD partitions on "NAND 16MiB 3,3V 8-bit":
0x00004000-0x00018000 : "apex1"
0x00018000-0x0002c000 : "apex2"
0x0002c000-0x00030000 : "apex-env"
0x00030000-0x00050000 : "sysconfig"
0x00050000-0x00208000 : "kernel1"
0x00208000-0x003c0000 : "kernel2"
0x003c0000-0x00440000 : "configfs"
0x00440000-0x00de8000 : "rootfs"
0x00de8000-0x00fe8000 : "safefs"
0x00fe8000-0x00ff0000 : "log"
mice: PS/2 mouse device common for all mice
CGU: Get clock id:34 freq:6000000
lpc313x-wdt lpc313x-wdt: Watchdog device driver initialized.
cpuidle: using governor ladder
TCP cubic registered
NET: Registered protocol family 17
ieee80211: 802.11 data/management/control stack, git-1.1.13
ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
ieee80211_crypt: registered algorithm 'NULL'
ieee80211_crypt: registered algorithm 'WEP'
VFS: Mounted root (jffs2 filesystem) readonly.
Freeing init memory: 88K
CGU: Get clock id:34 freq:6000000
lpc313x-wdt lpc313x-wdt: Watchdog timer closed unexpectedly
Empty flash at 0x000021ac ends at 0x00002200
CGU: Get clock id:34 freq:6000000
lpc313x-wdt lpc313x-wdt: Watchdog timer closed unexpectedly
CGU: Get clock id:34 freq:6000000
lpc313x-wdt lpc313x-wdt: Watchdog timer closed unexpectedly
CGU: Get clock id:34 freq:6000000
lpc313x-wdt lpc313x-wdt: Watchdog timer closed unexpectedly
Freescale High-Speed USB SOC Device Controller driver (Apr 20, 2007)
g_serial gadget: Gadget Serial v2.4
g_serial gadget: g_serial ready
fsl-usb2-udc: bind to driver g_serial
CGU: Get clock id:34 freq:6000000
lpc313x-wdt lpc313x-wdt: Watchdog timer closed unexpectedly
g_serial gadget: high speed config #2: CDC ACM config
CGU: Get clock id:34 freq:6000000
JFFS2 notice: (289) check_node_data: wrong data CRC in data node at 0x008c9f44: read 0x2c798f7c, calculated 0x6700a86.
JFFS2 notice: (289) check_node_data: wrong data CRC in data node at 0x008aa9d0: read 0x8dd9efbb, calculated 0xb49f0abf.
Compat-wireless backport release: compat-wireless-2012-04-02-2-1-g5c6c8e6
Backport based on linux-next.git next-20120404
CGU: Get clock id:20 freq:45000000
Powering off wl12xx<6>Powering off wl12xx<6>Powering down MMC Slot<6>Powering on wl12xx<6>lpc313x_mmc lpc313x_mmc.0: LPC313x MMC controller at irq 26
Powering up MMC Slot<4>mmc0: card claims to support voltages below the defined range. These will be ignored.
mmc0: queuing CIS tuple 0x91 length 3
mmc_attach_sdio the value of funcs=0x2
Powering on wl12xx<6>mmc_attach_sdio the value of funcs=0x2
mmc0: new SDIO card at address 0001
cfg80211: Calling CRDA to update world regulatory domain
wl1271_probe: the value of func->num = 0x2
wl12xx: loaded
wl12xx: firmware booted (Rev 6.3.7.0.105)
wlan0: authenticate with c1e3f22c
wlan0: send auth to c1e3f22c (try 1/3)
wlan0: authenticated
wlan0: associate with c1e3f22c (try 1/3)
wlan0: RX AssocResp from c1ee6c1a (capab=0x401 status=0 aid=2)
wlan0: associated
~ #
~ # dmesg[J
Linux version 2.6.28.2 (root@ubuntu) (gcc version 4.4.2 (GCC) ) #3 Thu Mar 22 03:04:06 PDT 2012
CPU: ARM926EJ-S [41069265] revision 5 (ARMv5TEJ), cr=00053177
CPU: VIVT data cache, VIVT instruction cache
Machine: Brady BPS313XV1
Memory policy: ECC disabled, Data cache writeback
On node 0 totalpages: 8192
free_area_init_node: node 0, pgdat c024d008, node_mem_map c0262000
  Normal zone: 64 pages used for memmap
  Normal zone: 0 pages reserved
  Normal zone: 8128 pages, LIFO batch:0
  Movable zone: 0 pages used for memmap
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 8128
Kernel command line: console=0 rootfstype=jffs2 quiet root=/dev/mtdblock7 safefs=0 kernel=1 sku=772
irq=30 Event=0x3e bank:1 bit:30 type:0

irq=31 Event=0x54 bank:2 bit:20 type:0

irq=32 Event=0x4b bank:2 bit:11 type:0

PID hash table entries: 128 (order: 7, 512 bytes)
Console: colour dummy device 80x30
console [ttyS0] enabled
Dentry cache hash table entries: 4096 (order: 2, 16384 bytes)
Inode-cache hash table entries: 2048 (order: 1, 8192 bytes)
Memory: 32MB = 32MB total
Memory: 30012KB available (2136K code, 177K data, 88K init)
Calibrating delay loop... 89.70 BogoMIPS (lpj=448512)
Security Framework initialized
Mount-cache hash table entries: 512
CPU: Testing write buffer coherency: ok
net_namespace: 288 bytes
NET: Registered protocol family 16
cgu_init pll set at 180000000
Registering USB gadget 0x00000f20 0x02800004 (3)
LPC31: Power Management init.
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
NET: Registered protocol family 2
IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
TCP established hash table entries: 1024 (order: 1, 8192 bytes)
TCP bind hash table entries: 1024 (order: 0, 4096 bytes)
TCP: Hash tables configured (established 1024 bind 1024)
TCP reno registered
NET: Registered protocol family 1
NetWinder Floating Point Emulator V0.97 (double precision)
JFFS2 version 2.2. (NAND) (SUMMARY)  © 2001-2006 Red Hat, Inc.
msgmni has been set to 58
alg: No test for stdrng (krng)
io scheduler noop registered (default)
Serial: 8250/16550 driver1 ports, IRQ sharing disabled
serial8250: ttyS0 at MMIO 0x15001000 (irq = 10) is a NXP16750
serial8250.0: ttyS0 at MMIO 0x15001000 (irq = 10) is a NXP16750
NAND device: Manufacturer ID: 0x20, Chip ID: 0x73 (ST Micro NAND 16MiB 3,3V 8-bit)
Bad block table found at page 32736, version 0x00
Bad block table found at page 32704, version 0x00
nand_read_bbt: Bad block at 0x00000000
nand_read_bbt: Bad block at 0x00000000
Creating 10 MTD partitions on "NAND 16MiB 3,3V 8-bit":
0x00004000-0x00018000 : "apex1"
0x00018000-0x0002c000 : "apex2"
0x0002c000-0x00030000 : "apex-env"
0x00030000-0x00050000 : "sysconfig"
0x00050000-0x00208000 : "kernel1"
0x00208000-0x003c0000 : "kernel2"
0x003c0000-0x00440000 : "configfs"
0x00440000-0x00de8000 : "rootfs"
0x00de8000-0x00fe8000 : "safefs"
0x00fe8000-0x00ff0000 : "log"
mice: PS/2 mouse device common for all mice
CGU: Get clock id:34 freq:6000000
lpc313x-wdt lpc313x-wdt: Watchdog device driver initialized.
cpuidle: using governor ladder
TCP cubic registered
NET: Registered protocol family 17
ieee80211: 802.11 data/management/control stack, git-1.1.13
ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
ieee80211_crypt: registered algorithm 'NULL'
ieee80211_crypt: registered algorithm 'WEP'
VFS: Mounted root (jffs2 filesystem) readonly.
Freeing init memory: 88K
CGU: Get clock id:34 freq:6000000
lpc313x-wdt lpc313x-wdt: Watchdog timer closed unexpectedly
Empty flash at 0x000021ac ends at 0x00002200
CGU: Get clock id:34 freq:6000000
lpc313x-wdt lpc313x-wdt: Watchdog timer closed unexpectedly
CGU: Get clock id:34 freq:6000000
lpc313x-wdt lpc313x-wdt: Watchdog timer closed unexpectedly
CGU: Get clock id:34 freq:6000000
lpc313x-wdt lpc313x-wdt: Watchdog timer closed unexpectedly
Freescale High-Speed USB SOC Device Controller driver (Apr 20, 2007)
g_serial gadget: Gadget Serial v2.4
g_serial gadget: g_serial ready
fsl-usb2-udc: bind to driver g_serial
CGU: Get clock id:34 freq:6000000
lpc313x-wdt lpc313x-wdt: Watchdog timer closed unexpectedly
g_serial gadget: high speed config #2: CDC ACM config
CGU: Get clock id:34 freq:6000000
JFFS2 notice: (289) check_node_data: wrong data CRC in data node at 0x008c9f44: read 0x2c798f7c, calculated 0x6700a86.
JFFS2 notice: (289) check_node_data: wrong data CRC in data node at 0x008aa9d0: read 0x8dd9efbb, calculated 0xb49f0abf.
Compat-wireless backport release: compat-wireless-2012-04-02-2-1-g5c6c8e6
Backport based on linux-next.git next-20120404
CGU: Get clock id:20 freq:45000000
Powering off wl12xx<6>Powering off wl12xx<6>Powering down MMC Slot<6>Powering on wl12xx<6>lpc313x_mmc lpc313x_mmc.0: LPC313x MMC controller at irq 26
Powering up MMC Slot<4>mmc0: card claims to support voltages below the defined range. These will be ignored.
mmc0: queuing CIS tuple 0x91 length 3
mmc_attach_sdio the value of funcs=0x2
Powering on wl12xx<6>mmc_attach_sdio the value of funcs=0x2
mmc0: new SDIO card at address 0001
cfg80211: Calling CRDA to update world regulatory domain
wl1271_probe: the value of func->num = 0x2
wl12xx: loaded
wl12xx: firmware booted (Rev 6.3.7.0.105)
wlan0: authenticate with c1e3f22c
wlan0: send auth to c1e3f22c (try 1/3)
wlan0: authenticated
wlan0: associate with c1e3f22c (try 1/3)
wlan0: RX AssocResp from c1ee6c1a (capab=0x401 status=0 aid=2)
wlan0: associated
wl12xx: ERROR command complete timeout
------------[ cut here ]------------
WARNING: at /home/bps/compat-wireless-2012-04-04/drivers/net/wireless/wl12xx/cmd.c:108 wl1271_cmd_send+0x340/0x374 [wl12xx]()
Modules linked in: wl12xx_sdio wl12xx compat_firmware_class mac80211 cfg80211 lpc313x_mmc rfkill_backport compat g_serial nxp_usb2_udc
[<c01b9990>] (dump_stack+0x0/0x14) from [<c0035cec>] (warn_on_slowpath+0x4c/0x68)
[<c0035ca0>] (warn_on_slowpath+0x0/0x68) from [<bf0b086c>] (wl1271_cmd_send+0x340/0x374 [wl12xx])
r6:c1f35970 r5:ffffff92 r4:c1f356c0
[<bf0b052c>] (wl1271_cmd_send+0x0/0x374 [wl12xx]) from [<bf0b2054>] (wl1271_cmd_configure+0x3c/0x60 [wl12xx])
[<bf0b2018>] (wl1271_cmd_configure+0x0/0x60 [wl12xx]) from [<bf0b64c4>] (wl1271_acx_set_ht_capabilities+0xa0/0xd0 [wl12xx])
r5:c1f21bc8 r4:c1e6b300
[<bf0b6424>] (wl1271_acx_set_ht_capabilities+0x0/0xd0 [wl12xx]) from [<bf0ad5e0>] (wl1271_op_bss_info_changed+0xa4c/0xba4 [wl12xx])
r9:00000001 r8:0000305d r7:c1eec838 r6:c1eec840 r5:c1f356c0
r4:c1eec8c4
[<bf0acb94>] (wl1271_op_bss_info_changed+0x0/0xba4 [wl12xx]) from [<bf064b94>] (ieee80211_bss_info_change_notify+0x170/0x184 [mac80211])
[<bf064a24>] (ieee80211_bss_info_change_notify+0x0/0x184 [mac80211]) from [<bf085794>] (ieee80211_rx_mgmt_assoc_resp+0x628/0x824 [mac80211])
r7:c1f35104 r6:c1ee6c10 r5:0000305d r4:c1eec3e0
[<bf08516c>] (ieee80211_rx_mgmt_assoc_resp+0x0/0x824 [mac80211]) from [<bf0865fc>] (ieee80211_sta_rx_queued_mgmt+0xc08/0xd38 [mac80211])
[<bf0859f4>] (ieee80211_sta_rx_queued_mgmt+0x0/0xd38 [mac80211]) from [<bf070e40>] (ieee80211_iface_work+0x214/0x2c8 [mac80211])
[<bf070c2c>] (ieee80211_iface_work+0x0/0x2c8 [mac80211]) from [<c0045e3c>] (run_workqueue+0xbc/0x144)
[<c0045d80>] (run_workqueue+0x0/0x144) from [<c0046528>] (worker_thread+0x104/0x118)
r7:c1d89608 r6:c1f21fa4 r5:c1f20000 r4:c1d89600
[<c0046424>] (worker_thread+0x0/0x118) from [<c0049b00>] (kthread+0x58/0x94)
r7:00000000 r6:c1d89600 r5:c0046424 r4:c1f20000
[<c0049aa8>] (kthread+0x0/0x94) from [<c0038b08>] (do_exit+0x0/0x6fc)
r7:00000000 r6:00000000 r5:00000000 r4:00000000
---[ end trace 6a06b766661523a6 ]---
wl12xx: WARNING CONFIGURE command NOK
wl12xx: WARNING acx ht capabilities setting failed: -110
wl12xx: WARNING Set ht cap true failed -110
wl12xx: Reading FW panic log
~ #
~ # dmesg[J
Linux version 2.6.28.2 (root@ubuntu) (gcc version 4.4.2 (GCC) ) #3 Thu Mar 22 03:04:06 PDT 2012
CPU: ARM926EJ-S [41069265] revision 5 (ARMv5TEJ), cr=00053177
CPU: VIVT data cache, VIVT instruction cache
Machine: Brady BPS313XV1
Memory policy: ECC disabled, Data cache writeback
On node 0 totalpages: 8192
free_area_init_node: node 0, pgdat c024d008, node_mem_map c0262000
  Normal zone: 64 pages used for memmap
  Normal zone: 0 pages reserved
  Normal zone: 8128 pages, LIFO batch:0
  Movable zone: 0 pages used for memmap
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 8128
Kernel command line: console=0 rootfstype=jffs2 quiet root=/dev/mtdblock7 safefs=0 kernel=1 sku=772
irq=30 Event=0x3e bank:1 bit:30 type:0

irq=31 Event=0x54 bank:2 bit:20 type:0

irq=32 Event=0x4b bank:2 bit:11 type:0

PID hash table entries: 128 (order: 7, 512 bytes)
Console: colour dummy device 80x30
console [ttyS0] enabled
Dentry cache hash table entries: 4096 (order: 2, 16384 bytes)
Inode-cache hash table entries: 2048 (order: 1, 8192 bytes)
Memory: 32MB = 32MB total
Memory: 30012KB available (2136K code, 177K data, 88K init)
Calibrating delay loop... 89.70 BogoMIPS (lpj=448512)
Security Framework initialized
Mount-cache hash table entries: 512
CPU: Testing write buffer coherency: ok
net_namespace: 288 bytes
NET: Registered protocol family 16
cgu_init pll set at 180000000
Registering USB gadget 0x00000f20 0x02800004 (3)
LPC31: Power Management init.
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
NET: Registered protocol family 2
IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
TCP established hash table entries: 1024 (order: 1, 8192 bytes)
TCP bind hash table entries: 1024 (order: 0, 4096 bytes)
TCP: Hash tables configured (established 1024 bind 1024)
TCP reno registered
NET: Registered protocol family 1
NetWinder Floating Point Emulator V0.97 (double precision)
JFFS2 version 2.2. (NAND) (SUMMARY)  © 2001-2006 Red Hat, Inc.
msgmni has been set to 58
alg: No test for stdrng (krng)
io scheduler noop registered (default)
Serial: 8250/16550 driver1 ports, IRQ sharing disabled
serial8250: ttyS0 at MMIO 0x15001000 (irq = 10) is a NXP16750
serial8250.0: ttyS0 at MMIO 0x15001000 (irq = 10) is a NXP16750
NAND device: Manufacturer ID: 0x20, Chip ID: 0x73 (ST Micro NAND 16MiB 3,3V 8-bit)
Bad block table found at page 32736, version 0x00
Bad block table found at page 32704, version 0x00
nand_read_bbt: Bad block at 0x00000000
nand_read_bbt: Bad block at 0x00000000
Creating 10 MTD partitions on "NAND 16MiB 3,3V 8-bit":
0x00004000-0x00018000 : "apex1"
0x00018000-0x0002c000 : "apex2"
0x0002c000-0x00030000 : "apex-env"
0x00030000-0x00050000 : "sysconfig"
0x00050000-0x00208000 : "kernel1"
0x00208000-0x003c0000 : "kernel2"
0x003c0000-0x00440000 : "configfs"
0x00440000-0x00de8000 : "rootfs"
0x00de8000-0x00fe8000 : "safefs"
0x00fe8000-0x00ff0000 : "log"
mice: PS/2 mouse device common for all mice
CGU: Get clock id:34 freq:6000000
lpc313x-wdt lpc313x-wdt: Watchdog device driver initialized.
cpuidle: using governor ladder
TCP cubic registered
NET: Registered protocol family 17
ieee80211: 802.11 data/management/control stack, git-1.1.13
ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
ieee80211_crypt: registered algorithm 'NULL'
ieee80211_crypt: registered algorithm 'WEP'
VFS: Mounted root (jffs2 filesystem) readonly.
Freeing init memory: 88K
CGU: Get clock id:34 freq:6000000
lpc313x-wdt lpc313x-wdt: Watchdog timer closed unexpectedly
Empty flash at 0x000021ac ends at 0x00002200
CGU: Get clock id:34 freq:6000000
lpc313x-wdt lpc313x-wdt: Watchdog timer closed unexpectedly
CGU: Get clock id:34 freq:6000000
lpc313x-wdt lpc313x-wdt: Watchdog timer closed unexpectedly
CGU: Get clock id:34 freq:6000000
lpc313x-wdt lpc313x-wdt: Watchdog timer closed unexpectedly
Freescale High-Speed USB SOC Device Controller driver (Apr 20, 2007)
g_serial gadget: Gadget Serial v2.4
g_serial gadget: g_serial ready
fsl-usb2-udc: bind to driver g_serial
CGU: Get clock id:34 freq:6000000
lpc313x-wdt lpc313x-wdt: Watchdog timer closed unexpectedly
g_serial gadget: high speed config #2: CDC ACM config
CGU: Get clock id:34 freq:6000000
JFFS2 notice: (289) check_node_data: wrong data CRC in data node at 0x008c9f44: read 0x2c798f7c, calculated 0x6700a86.
JFFS2 notice: (289) check_node_data: wrong data CRC in data node at 0x008aa9d0: read 0x8dd9efbb, calculated 0xb49f0abf.
Compat-wireless backport release: compat-wireless-2012-04-02-2-1-g5c6c8e6
Backport based on linux-next.git next-20120404
CGU: Get clock id:20 freq:45000000
Powering off wl12xx<6>Powering off wl12xx<6>Powering down MMC Slot<6>Powering on wl12xx<6>lpc313x_mmc lpc313x_mmc.0: LPC313x MMC controller at irq 26
Powering up MMC Slot<4>mmc0: card claims to support voltages below the defined range. These will be ignored.
mmc0: queuing CIS tuple 0x91 length 3
mmc_attach_sdio the value of funcs=0x2
Powering on wl12xx<6>mmc_attach_sdio the value of funcs=0x2
mmc0: new SDIO card at address 0001
cfg80211: Calling CRDA to update world regulatory domain
wl1271_probe: the value of func->num = 0x2
wl12xx: loaded
wl12xx: firmware booted (Rev 6.3.7.0.105)
wlan0: authenticate with c1e3f22c
wlan0: send auth to c1e3f22c (try 1/3)
wlan0: authenticated
wlan0: associate with c1e3f22c (try 1/3)
wlan0: RX AssocResp from c1ee6c1a (capab=0x401 status=0 aid=2)
wlan0: associated
wl12xx: ERROR command complete timeout
------------[ cut here ]------------
WARNING: at /home/bps/compat-wireless-2012-04-04/drivers/net/wireless/wl12xx/cmd.c:108 wl1271_cmd_send+0x340/0x374 [wl12xx]()
Modules linked in: wl12xx_sdio wl12xx compat_firmware_class mac80211 cfg80211 lpc313x_mmc rfkill_backport compat g_serial nxp_usb2_udc
[<c01b9990>] (dump_stack+0x0/0x14) from [<c0035cec>] (warn_on_slowpath+0x4c/0x68)
[<c0035ca0>] (warn_on_slowpath+0x0/0x68) from [<bf0b086c>] (wl1271_cmd_send+0x340/0x374 [wl12xx])
r6:c1f35970 r5:ffffff92 r4:c1f356c0
[<bf0b052c>] (wl1271_cmd_send+0x0/0x374 [wl12xx]) from [<bf0b2054>] (wl1271_cmd_configure+0x3c/0x60 [wl12xx])
[<bf0b2018>] (wl1271_cmd_configure+0x0/0x60 [wl12xx]) from [<bf0b64c4>] (wl1271_acx_set_ht_capabilities+0xa0/0xd0 [wl12xx])
r5:c1f21bc8 r4:c1e6b300
[<bf0b6424>] (wl1271_acx_set_ht_capabilities+0x0/0xd0 [wl12xx]) from [<bf0ad5e0>] (wl1271_op_bss_info_changed+0xa4c/0xba4 [wl12xx])
r9:00000001 r8:0000305d r7:c1eec838 r6:c1eec840 r5:c1f356c0
r4:c1eec8c4
[<bf0acb94>] (wl1271_op_bss_info_changed+0x0/0xba4 [wl12xx]) from [<bf064b94>] (ieee80211_bss_info_change_notify+0x170/0x184 [mac80211])
[<bf064a24>] (ieee80211_bss_info_change_notify+0x0/0x184 [mac80211]) from [<bf085794>] (ieee80211_rx_mgmt_assoc_resp+0x628/0x824 [mac80211])
r7:c1f35104 r6:c1ee6c10 r5:0000305d r4:c1eec3e0
[<bf08516c>] (ieee80211_rx_mgmt_assoc_resp+0x0/0x824 [mac80211]) from [<bf0865fc>] (ieee80211_sta_rx_queued_mgmt+0xc08/0xd38 [mac80211])
[<bf0859f4>] (ieee80211_sta_rx_queued_mgmt+0x0/0xd38 [mac80211]) from [<bf070e40>] (ieee80211_iface_work+0x214/0x2c8 [mac80211])
[<bf070c2c>] (ieee80211_iface_work+0x0/0x2c8 [mac80211]) from [<c0045e3c>] (run_workqueue+0xbc/0x144)
[<c0045d80>] (run_workqueue+0x0/0x144) from [<c0046528>] (worker_thread+0x104/0x118)
r7:c1d89608 r6:c1f21fa4 r5:c1f20000 r4:c1d89600
[<c0046424>] (worker_thread+0x0/0x118) from [<c0049b00>] (kthread+0x58/0x94)
r7:00000000 r6:c1d89600 r5:c0046424 r4:c1f20000
[<c0049aa8>] (kthread+0x0/0x94) from [<c0038b08>] (do_exit+0x0/0x6fc)
r7:00000000 r6:00000000 r5:00000000 r4:00000000
---[ end trace 6a06b766661523a6 ]---
wl12xx: WARNING CONFIGURE command NOK
wl12xx: WARNING acx ht capabilities setting failed: -110
wl12xx: WARNING Set ht cap true failed -110
wl12xx: Reading FW panic log
wl12xx: ERROR command complete timeout
------------[ cut here ]------------
WARNING: at /home/bps/compat-wireless-2012-04-04/drivers/net/wireless/wl12xx/cmd.c:108 wl1271_cmd_send+0x340/0x374 [wl12xx]()
Modules linked in: wl12xx_sdio wl12xx compat_firmware_class mac80211 cfg80211 lpc313x_mmc rfkill_backport compat g_serial nxp_usb2_udc
[<c01b9990>] (dump_stack+0x0/0x14) from [<c0035cec>] (warn_on_slowpath+0x4c/0x68)
[<c0035ca0>] (warn_on_slowpath+0x0/0x68) from [<bf0b086c>] (wl1271_cmd_send+0x340/0x374 [wl12xx])
r6:c1f35970 r5:ffffff92 r4:c1f356c0
[<bf0b052c>] (wl1271_cmd_send+0x0/0x374 [wl12xx]) from [<bf0b0f1c>] (wl12xx_cmd_stop_fwlog+0x4c/0x7c [wl12xx])
[<bf0b0ed0>] (wl12xx_cmd_stop_fwlog+0x0/0x7c [wl12xx]) from [<bf0af398>] (wl1271_recovery_work+0xb4/0x334 [wl12xx])
r5:c1f358ac r4:c1f356c0
[<bf0af2e4>] (wl1271_recovery_work+0x0/0x334 [wl12xx]) from [<c0045e3c>] (run_workqueue+0xbc/0x144)
[<c0045d80>] (run_workqueue+0x0/0x144) from [<c0046528>] (worker_thread+0x104/0x118)
r7:c1d89608 r6:c1f21fa4 r5:c1f20000 r4:c1d89600
[<c0046424>] (worker_thread+0x0/0x118) from [<c0049b00>] (kthread+0x58/0x94)
r7:00000000 r6:c1d89600 r5:c0046424 r4:c1f20000
[<c0049aa8>] (kthread+0x0/0x94) from [<c0038b08>] (do_exit+0x0/0x6fc)
r7:00000000 r6:00000000 r5:00000000 r4:00000000
---[ end trace 6a06b766661523a6 ]---
wl12xx: ERROR failed to send stop firmware logger command
wl12xx: Hardware recovery in progress. FW ver: Rev 6.3.7.0.105 pc: 0x9a32
wl12xx: down
ieee80211 phy0: Hardware restart was requested
wl12xx: ERROR timeout waiting for the hardware to complete initialization
~ #
Let us know the issue with Wl1271 driver in Compat Wireless package


Thanks & Regards,
Girish
L&T IES,
E-mail ID :Girish.BN@lnties.com
www.lnties.com

This mail is classified as :
(  ) L&T IES Proprietary
(  ) L&T IES Confidential
(X) L&T IES Internal Use
( ) L&T IES General Business



Larsen & Toubro Limited

www.larsentoubro.com

This Email may contain confidential or privileged information for the intended recipient (s) If you are not the intended recipient, please do not use or disseminate the information, notify the sender and delete it from your system.
