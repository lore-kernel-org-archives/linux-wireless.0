Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:44366 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756415Ab2DDPvV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Apr 2012 11:51:21 -0400
Received: by obbtb18 with SMTP id tb18so472250obb.19
        for <linux-wireless@vger.kernel.org>; Wed, 04 Apr 2012 08:51:20 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 4 Apr 2012 21:21:20 +0530
Message-ID: <CACAxKDr11ySDxbggg1Zc2cZa7QCGk8Rb=WoPdSuOZX-08fTVhw@mail.gmail.com> (sfid-20120404_175126_258944_0BC66EC0)
Subject: Issue with Compat Wireless-2012-04-03 with Wireless operations
From: Girish B N <bngirish1@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With latest Compat wireless package (2012-04-03) and firmware ver (04
- wl127x-fw-4-sr.bin and wl127x-fw-4-plt.bin, ) I am able to
successfully calibrate and nvs file sucessfully.
However, I am not able to connect to any device. there is crash in the
modules. However I am able to do the scan operation successfully.
There is crash after running the following commands
>ifconfig wlan0 down
>ifconfig wlan0 hw ether de:ad:be:ef:c0:fe
>iwconfig wlan0 mode ad-hoc
>iwconfig wlan0 essid brady123
>ifconfig wlan0 192.168.1.6 up
Please find the log below

Let us know the right version of the firmware and any patches to be
applied for Compat Wireless package to be able to use for both
calibration and successful wireless operation

/ # dmesg
Linux version 2.6.28.2 (root@ubuntu) (gcc version 4.4.2 (GCC) ) #3 Thu
Mar 22 03:04:06 PDT 2012
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
Kernel command line: console=0 rootfstype=jffs2 quiet
root=/dev/mtdblock7 safefs=0 kernel=1 sku=772
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
NAND device: Manufacturer ID: 0x20, Chip ID: 0x73 (ST Micro NAND 16MiB
3,3V 8-bit)
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
CGU: Get clock id:20 freq:45000000
Powering off wl12xx<6>Powering off wl12xx<6>Powering down MMC
Slot<6>Powering on wl12xx<6>lpc313x_mmc lpc313x_mmc.0: LPC313x MMC
controller at irq 26
Powering up MMC Slot<4>mmc0: card claims to support voltages below the
defined range. These will be ignored.
mmc0: queuing CIS tuple 0x91 length 3
mmc_attach_sdio the value of funcs=0x2
mmc_attach_sdio the value of funcs=0x2
mmc0: new SDIO card at address 0001
Powering on wl12xx<6>Compat-wireless backport release:
compat-wireless-2012-04-02-2-1-g5c6c8e6
Backport based on linux-next.git next-20120403
cfg80211: Calling CRDA to update world regulatory domain
wl1271_probe: the value of func->num = 0x2
wl12xx: loaded
/ # ifconfig
lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          UP LOOPBACK RUNNING  MTU:16436  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

/ #
/ # ifconfig [J -a
lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          UP LOOPBACK RUNNING  MTU:16436  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

wlan0     Link encap:Ethernet  HWaddr 03:00:00:00:29:00
          BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

/ # ifconfig wlan0 down &
onfig wlan0 hw ether de:ad:be:ef:c0:fe &
[3]+  Done                       ifconfig wlan0 down
/ # ifconfig wlan0 hw ether de:ad:be:ef:c0:fe &
[3]+  Done                       ifconfig wlan0 hw ether de:ad:be:ef:c0:fe
/ # iwconfig wlan0 mode ad-hoc
/ # iwconfig wlan0 essid brady123
/ # ifconfig wlan0 192.168.1.6 up
KERNEL[234.242778] add
/devices/platform/lpc313x_mmc.0/mmc_host/mmc0/mmc0:0001/mmc0:0001:2/wl12xx/compat_firmware/wl12xx
(compat_firmware)
ACTION=add
DEVPATH=/devices/platform/lpc313x_mmc.0/mmc_host/mmc0/mmc0:0001/mmc0:0001:2/wl12xx/compat_firmware/wl12xx
SUBSYSTEM=compat_firmware
FIRMWARE=ti-connectivity/wl127x-fw-4-sr.bin
ASYNC=0
SEQNUM=217

KERNEL[234.451922] remove
/devices/platform/lpc313x_mmc.0/mmc_host/mmc0/mmc0:0001/mmc0:0001:2/wl12xx/compat_firmware/wl12xx
(compat_firmware)
ACTION=remove
DEVPATH=/devices/platform/lpc313x_mmc.0/mmc_host/mmc0/mmc0:0001/mmc0:0001:2/wl12xx/compat_firmware/wl12xx
SUBSYSTEM=compat_firmware
FIRMWARE=ti-connectivity/wl127x-fw-4-sr.bin
ASYNC=0
SEQNUM=218

UDEV  [234.464602] add
/devices/platform/lpc313x_mmc.0/mmc_host/mmc0/mmc0:0001/mmc0:0001:2/wl12xx/compat_firmware/wl12xx
(compat_firmware)
ACTION=add
DEVPATH=/devices/platform/lpc313x_mmc.0/mmc_host/mmc0/mmc0:0001/mmc0:0001:2/wl12xx/compat_firmware/wl12xx
SUBSYSTEM=compat_firmware
FIRMWARE=ti-connectivity/wl127x-fw-4-sr.bin
ASYNC=0
SEQNUM=217

UDEV  [234.527889] remove
/devices/platform/lpc313x_mmc.0/mmc_host/mmc0/mmc0:0001/mmc0:0001:2/wl12xx/compat_firmware/wl12xx
(compat_firmware)
ACTION=remove
DEVPATH=/devices/platform/lpc313x_mmc.0/mmc_host/mmc0/mmc0:0001/mmc0:0001:2/wl12xx/compat_firmware/wl12xx
SUBSYSTEM=compat_firmware
FIRMWARE=ti-connectivity/wl127x-fw-4-sr.bin
ASYNC=0
SEQNUM=218

/ # dmesg
Linux version 2.6.28.2 (root@ubuntu) (gcc version 4.4.2 (GCC) ) #3 Thu
Mar 22 03:04:06 PDT 2012
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
Kernel command line: console=0 rootfstype=jffs2 quiet
root=/dev/mtdblock7 safefs=0 kernel=1 sku=772
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
NAND device: Manufacturer ID: 0x20, Chip ID: 0x73 (ST Micro NAND 16MiB
3,3V 8-bit)
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
CGU: Get clock id:20 freq:45000000
Powering off wl12xx<6>Powering off wl12xx<6>Powering down MMC
Slot<6>Powering on wl12xx<6>lpc313x_mmc lpc313x_mmc.0: LPC313x MMC
controller at irq 26
Powering up MMC Slot<4>mmc0: card claims to support voltages below the
defined range. These will be ignored.
mmc0: queuing CIS tuple 0x91 length 3
mmc_attach_sdio the value of funcs=0x2
mmc_attach_sdio the value of funcs=0x2
mmc0: new SDIO card at address 0001
Powering on wl12xx<6>Compat-wireless backport release:
compat-wireless-2012-04-02-2-1-g5c6c8e6
Backport based on linux-next.git next-20120403
cfg80211: Calling CRDA to update world regulatory domain
wl1271_probe: the value of func->num = 0x2
wl12xx: loaded
wl12xx: firmware booted (Rev 6.3.5.0.98)
/ # route add default gw 192.168.1.1 dev wlan0
/ # iwconfig
lo        no wireless extensions.

wlan0     IEEE 802.11abgn  ESSID:"brady123"
          Mode:Ad-Hoc  Frequency:2.412 GHz  Cell: Not-Associated
          Tx-Power=20 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:on

/ #
/ # iwconfig [J        dmesg
wed by default
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
NAND device: Manufacturer ID: 0x20, Chip ID: 0x73 (ST Micro NAND 16MiB
3,3V 8-bit)
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
CGU: Get clock id:20 freq:45000000
Powering off wl12xx<6>Powering off wl12xx<6>Powering down MMC
Slot<6>Powering on wl12xx<6>lpc313x_mmc lpc313x_mmc.0: LPC313x MMC
controller at irq 26
Powering up MMC Slot<4>mmc0: card claims to support voltages below the
defined range. These will be ignored.
mmc0: queuing CIS tuple 0x91 length 3
mmc_attach_sdio the value of funcs=0x2
mmc_attach_sdio the value of funcs=0x2
mmc0: new SDIO card at address 0001
Powering on wl12xx<6>Compat-wireless backport release:
compat-wireless-2012-04-02-2-1-g5c6c8e6
Backport based on linux-next.git next-20120403
cfg80211: Calling CRDA to update world regulatory domain
wl1271_probe: the value of func->num = 0x2
wl12xx: loaded
wl12xx: firmware booted (Rev 6.3.5.0.98)
wlan0: Creating new IBSS network, BSSID c1edff10
wl12xx: ERROR command complete timeout
------------[ cut here ]------------
WARNING: at /home/bps/compat-wireless-2012-04-03/drivers/net/wireless/wl12xx/cmd.c:108
wl1271_cmd_send+0x340/0x374 [wl12xx]()
Modules linked in: wl12xx_sdio wl12xx compat_firmware_class mac80211
cfg80211 rfkill_backport compat lpc313x_mmc g_serial nxp_usb2_udc
[<c01b9990>] (dump_stack+0x0/0x14) from [<c0035cec>]
(warn_on_slowpath+0x4c/0x68)
[<c0035ca0>] (warn_on_slowpath+0x0/0x68) from [<bf0b0868>]
(wl1271_cmd_send+0x340/0x374 [wl12xx])
 r6:c1f31970 r5:ffffff92 r4:c1f316c0
[<bf0b0528>] (wl1271_cmd_send+0x0/0x374 [wl12xx]) from [<bf0b27d0>]
(wl12xx_cmd_role_start_ibss+0x140/0x180 [wl12xx])
[<bf0b2690>] (wl12xx_cmd_role_start_ibss+0x0/0x180 [wl12xx]) from
[<bf0ad4c0>] (wl1271_op_bss_info_changed+0x92c/0xba4 [wl12xx])
 r7:c1c36838 r6:c1c36840 r5:c1f316c0 r4:c1c368c4
[<bf0acb94>] (wl1271_op_bss_info_changed+0x0/0xba4 [wl12xx]) from
[<bf064b94>] (ieee80211_bss_info_change_notify+0x170/0x184 [mac80211])
[<bf064a24>] (ieee80211_bss_info_change_notify+0x0/0x184 [mac80211])
from [<bf06ddf4>] (__ieee80211_sta_join_ibss+0x568/0x5f4 [mac80211])
 r7:c1f31d74 r6:c1f50820 r5:c1e5e414 r4:c1c363e0
[<bf06d88c>] (__ieee80211_sta_join_ibss+0x0/0x5f4 [mac80211]) from
[<bf06e1a0>] (ieee80211_ibss_work+0x230/0x414 [mac80211])
[<bf06df70>] (ieee80211_ibss_work+0x0/0x414 [mac80211]) from
[<bf070ec0>] (ieee80211_iface_work+0x294/0x2c8 [mac80211])
[<bf070c2c>] (ieee80211_iface_work+0x0/0x2c8 [mac80211]) from
[<c0045e3c>] (run_workqueue+0xbc/0x144)
[<c0045d80>] (run_workqueue+0x0/0x144) from [<c0046528>]
(worker_thread+0x104/0x118)
 r7:c1f5ce48 r6:c1edffa4 r5:c1ede000 r4:c1f5ce40
[<c0046424>] (worker_thread+0x0/0x118) from [<c0049b00>] (kthread+0x58/0x94)
 r7:00000000 r6:c1f5ce40 r5:c0046424 r4:c1ede000
[<c0049aa8>] (kthread+0x0/0x94) from [<c0038b08>] (do_exit+0x0/0x6fc)
 r7:00000000 r6:00000000 r5:00000000 r4:00000000
---[ end trace 6a06b766661523a6 ]---
wl12xx: ERROR failed to initiate cmd role enable
wl12xx: WARNING cmd join failed -110
wl12xx: ERROR command complete timeout
------------[ cut here ]------------
WARNING: at /home/bps/compat-wireless-2012-04-03/drivers/net/wireless/wl12xx/cmd.c:108
wl1271_cmd_send+0x340/0x374 [wl12xx]()
Modules linked in: wl12xx_sdio wl12xx compat_firmware_class mac80211
cfg80211 rfkill_backport compat lpc313x_mmc g_serial nxp_usb2_udc
[<c01b9990>] (dump_stack+0x0/0x14) from [<c0035cec>]
(warn_on_slowpath+0x4c/0x68)
[<c0035ca0>] (warn_on_slowpath+0x0/0x68) from [<bf0b0868>]
(wl1271_cmd_send+0x340/0x374 [wl12xx])
 r6:c1f31970 r5:ffffff92 r4:c1f316c0
[<bf0b0528>] (wl1271_cmd_send+0x0/0x374 [wl12xx]) from [<bf0b2050>]
(wl1271_cmd_configure+0x3c/0x60 [wl12xx])
[<bf0b2014>] (wl1271_cmd_configure+0x0/0x60 [wl12xx]) from
[<bf0b6dcc>] (wl1271_acx_ac_cfg+0xa0/0xd4 [wl12xx])
 r5:00000005 r4:c1e4cc00
[<bf0b6d2c>] (wl1271_acx_ac_cfg+0x0/0xd4 [wl12xx]) from [<bf0abac0>]
(wl1271_op_conf_tx+0x90/0xfc [wl12xx])
[<bf0aba30>] (wl1271_op_conf_tx+0x0/0xfc [wl12xx]) from [<bf080208>]
(ieee80211_set_wmm_default+0x19c/0x1f0 [mac80211])
[<bf08006c>] (ieee80211_set_wmm_default+0x0/0x1f0 [mac80211]) from
[<bf0802d0>] (ieee80211_sta_def_wmm_params+0x74/0x78 [mac80211])
[<bf08025c>] (ieee80211_sta_def_wmm_params+0x0/0x78 [mac80211]) from
[<bf06de04>] (__ieee80211_sta_join_ibss+0x578/0x5f4 [mac80211])
 r5:c1e5e414 r4:c1c363e0
[<bf06d88c>] (__ieee80211_sta_join_ibss+0x0/0x5f4 [mac80211]) from
[<bf06e1a0>] (ieee80211_ibss_work+0x230/0x414 [mac80211])
[<bf06df70>] (ieee80211_ibss_work+0x0/0x414 [mac80211]) from
[<bf070ec0>] (ieee80211_iface_work+0x294/0x2c8 [mac80211])
[<bf070c2c>] (ieee80211_iface_work+0x0/0x2c8 [mac80211]) from
[<c0045e3c>] (run_workqueue+0xbc/0x144)
[<c0045d80>] (run_workqueue+0x0/0x144) from [<c0046528>]
(worker_thread+0x104/0x118)
 r7:c1f5ce48 r6:c1edffa4 r5:c1ede000 r4:c1f5ce40
[<c0046424>] (worker_thread+0x0/0x118) from [<c0049b00>] (kthread+0x58/0x94)
 r7:00000000 r6:c1f5ce40 r5:c0046424 r4:c1ede000
[<c0049aa8>] (kthread+0x0/0x94) from [<c0038b08>] (do_exit+0x0/0x6fc)
 r7:00000000 r6:00000000 r5:00000000 r4:00000000
---[ end trace 6a06b766661523a6 ]---
wl12xx: WARNING CONFIGURE command NOK
wl12xx: WARNING acx ac cfg failed: -110
wl12xx: ERROR command complete timeout
------------[ cut here ]------------
WARNING: at /home/bps/compat-wireless-2012-04-03/drivers/net/wireless/wl12xx/cmd.c:108
wl1271_cmd_send+0x340/0x374 [wl12xx]()
Modules linked in: wl12xx_sdio wl12xx compat_firmware_class mac80211
cfg80211 rfkill_backport compat lpc313x_mmc g_serial nxp_usb2_udc
[<c01b9990>] (dump_stack+0x0/0x14) from [<c0035cec>]
(warn_on_slowpath+0x4c/0x68)
[<c0035ca0>] (warn_on_slowpath+0x0/0x68) from [<bf0b0868>]
(wl1271_cmd_send+0x340/0x374 [wl12xx])
 r6:c1f31970 r5:ffffff92 r4:c1f316c0
[<bf0b0528>] (wl1271_cmd_send+0x0/0x374 [wl12xx]) from [<bf0b2050>]
(wl1271_cmd_configure+0x3c/0x60 [wl12xx])
[<bf0b2014>] (wl1271_cmd_configure+0x0/0x60 [wl12xx]) from
[<bf0b6dcc>] (wl1271_acx_ac_cfg+0xa0/0xd4 [wl12xx])
 r5:0000000b r4:c1e4cc00
[<bf0b6d2c>] (wl1271_acx_ac_cfg+0x0/0xd4 [wl12xx]) from [<bf0abac0>]
(wl1271_op_conf_tx+0x90/0xfc [wl12xx])
[<bf0aba30>] (wl1271_op_conf_tx+0x0/0xfc [wl12xx]) from [<bf080208>]
(ieee80211_set_wmm_default+0x19c/0x1f0 [mac80211])
[<bf08006c>] (ieee80211_set_wmm_default+0x0/0x1f0 [mac80211]) from
[<bf0802d0>] (ieee80211_sta_def_wmm_params+0x74/0x78 [mac80211])
[<bf08025c>] (ieee80211_sta_def_wmm_params+0x0/0x78 [mac80211]) from
[<bf06de04>] (__ieee80211_sta_join_ibss+0x578/0x5f4 [mac80211])
 r5:c1e5e414 r4:c1c363e0
[<bf06d88c>] (__ieee80211_sta_join_ibss+0x0/0x5f4 [mac80211]) from
[<bf06e1a0>] (ieee80211_ibss_work+0x230/0x414 [mac80211])
[<bf06df70>] (ieee80211_ibss_work+0x0/0x414 [mac80211]) from
[<bf070ec0>] (ieee80211_iface_work+0x294/0x2c8 [mac80211])
[<bf070c2c>] (ieee80211_iface_work+0x0/0x2c8 [mac80211]) from
[<c0045e3c>] (run_workqueue+0xbc/0x144)
[<c0045d80>] (run_workqueue+0x0/0x144) from [<c0046528>]
(worker_thread+0x104/0x118)
 r7:c1f5ce48 r6:c1edffa4 r5:c1ede000 r4:c1f5ce40
[<c0046424>] (worker_thread+0x0/0x118) from [<c0049b00>] (kthread+0x58/0x94)
 r7:00000000 r6:c1f5ce40 r5:c0046424 r4:c1ede000
[<c0049aa8>] (kthread+0x0/0x94) from [<c0038b08>] (do_exit+0x0/0x6fc)
 r7:00000000 r6:00000000 r5:00000000 r4:00000000
---[ end trace 6a06b766661523a6 ]---
wl12xx: WARNING CONFIGURE command NOK
wl12xx: WARNING acx ac cfg failed: -110
wl12xx: ERROR command complete timeout
------------[ cut here ]------------
WARNING: at /home/bps/compat-wireless-2012-04-03/drivers/net/wireless/wl12xx/cmd.c:108
wl1271_cmd_send+0x340/0x374 [wl12xx]()
Modules linked in: wl12xx_sdio wl12xx compat_firmware_class mac80211
cfg80211 rfkill_backport compat lpc313x_mmc g_serial nxp_usb2_udc
[<c01b9990>] (dump_stack+0x0/0x14) from [<c0035cec>]
(warn_on_slowpath+0x4c/0x68)
[<c0035ca0>] (warn_on_slowpath+0x0/0x68) from [<bf0b0868>]
(wl1271_cmd_send+0x340/0x374 [wl12xx])
 r6:c1f31970 r5:ffffff92 r4:c1f316c0
[<bf0b0528>] (wl1271_cmd_send+0x0/0x374 [wl12xx]) from [<bf0b2050>]
(wl1271_cmd_configure+0x3c/0x60 [wl12xx])
[<bf0b2014>] (wl1271_cmd_configure+0x0/0x60 [wl12xx]) from
[<bf0b6dcc>] (wl1271_acx_ac_cfg+0xa0/0xd4 [wl12xx])
 r5:00000000 r4:c1e4cc00
[<bf0b6d2c>] (wl1271_acx_ac_cfg+0x0/0xd4 [wl12xx]) from [<bf0abac0>]
(wl1271_op_conf_tx+0x90/0xfc [wl12xx])
[<bf0aba30>] (wl1271_op_conf_tx+0x0/0xfc [wl12xx]) from [<bf080208>]
(ieee80211_set_wmm_default+0x19c/0x1f0 [mac80211])
[<bf08006c>] (ieee80211_set_wmm_default+0x0/0x1f0 [mac80211]) from
[<bf0802d0>] (ieee80211_sta_def_wmm_params+0x74/0x78 [mac80211])
[<bf08025c>] (ieee80211_sta_def_wmm_params+0x0/0x78 [mac80211]) from
[<bf06de04>] (__ieee80211_sta_join_ibss+0x578/0x5f4 [mac80211])
 r5:c1e5e414 r4:c1c363e0
[<bf06d88c>] (__ieee80211_sta_join_ibss+0x0/0x5f4 [mac80211]) from
[<bf06e1a0>] (ieee80211_ibss_work+0x230/0x414 [mac80211])
[<bf06df70>] (ieee80211_ibss_work+0x0/0x414 [mac80211]) from
[<bf070ec0>] (ieee80211_iface_work+0x294/0x2c8 [mac80211])
[<bf070c2c>] (ieee80211_iface_work+0x0/0x2c8 [mac80211]) from
[<c0045e3c>] (run_workqueue+0xbc/0x144)
[<c0045d80>] (run_workqueue+0x0/0x144) from [<c0046528>]
(worker_thread+0x104/0x118)
 r7:c1f5ce48 r6:c1edffa4 r5:c1ede000 r4:c1f5ce40
[<c0046424>] (worker_thread+0x0/0x118) from [<c0049b00>] (kthread+0x58/0x94)
 r7:00000000 r6:c1f5ce40 r5:c0046424 r4:c1ede000
[<c0049aa8>] (kthread+0x0/0x94) from [<c0038b08>] (do_exit+0x0/0x6fc)
 r7:00000000 r6:00000000 r5:00000000 r4:00000000
---[ end trace 6a06b766661523a6 ]---
wl12xx: WARNING CONFIGURE command NOK
wl12xx: WARNING acx ac cfg failed: -110
wl12xx: ERROR command complete timeout
------------[ cut here ]------------
WARNING: at /home/bps/compat-wireless-2012-04-03/drivers/net/wireless/wl12xx/cmd.c:108
wl1271_cmd_send+0x340/0x374 [wl12xx]()
Modules linked in: wl12xx_sdio wl12xx compat_firmware_class mac80211
cfg80211 rfkill_backport compat lpc313x_mmc g_serial nxp_usb2_udc
[<c01b9990>] (dump_stack+0x0/0x14) from [<c0035cec>]
(warn_on_slowpath+0x4c/0x68)
[<c0035ca0>] (warn_on_slowpath+0x0/0x68) from [<bf0b0868>]
(wl1271_cmd_send+0x340/0x374 [wl12xx])
 r6:c1f31970 r5:ffffff92 r4:c1f316c0
[<bf0b0528>] (wl1271_cmd_send+0x0/0x374 [wl12xx]) from [<bf0b2050>]
(wl1271_cmd_configure+0x3c/0x60 [wl12xx])
[<bf0b2014>] (wl1271_cmd_configure+0x0/0x60 [wl12xx]) from
[<bf0b6dcc>] (wl1271_acx_ac_cfg+0xa0/0xd4 [wl12xx])
 r5:00000000 r4:c1e4cc00
[<bf0b6d2c>] (wl1271_acx_ac_cfg+0x0/0xd4 [wl12xx]) from [<bf0abac0>]
(wl1271_op_conf_tx+0x90/0xfc [wl12xx])
[<bf0aba30>] (wl1271_op_conf_tx+0x0/0xfc [wl12xx]) from [<bf080208>]
(ieee80211_set_wmm_default+0x19c/0x1f0 [mac80211])
[<bf08006c>] (ieee80211_set_wmm_default+0x0/0x1f0 [mac80211]) from
[<bf0802d0>] (ieee80211_sta_def_wmm_params+0x74/0x78 [mac80211])
[<bf08025c>] (ieee80211_sta_def_wmm_params+0x0/0x78 [mac80211]) from
[<bf06de04>] (__ieee80211_sta_join_ibss+0x578/0x5f4 [mac80211])
 r5:c1e5e414 r4:c1c363e0
[<bf06d88c>] (__ieee80211_sta_join_ibss+0x0/0x5f4 [mac80211]) from
[<bf06e1a0>] (ieee80211_ibss_work+0x230/0x414 [mac80211])
[<bf06df70>] (ieee80211_ibss_work+0x0/0x414 [mac80211]) from
[<bf070ec0>] (ieee80211_iface_work+0x294/0x2c8 [mac80211])
[<bf070c2c>] (ieee80211_iface_work+0x0/0x2c8 [mac80211]) from
[<c0045e3c>] (run_workqueue+0xbc/0x144)
[<c0045d80>] (run_workqueue+0x0/0x144) from [<c0046528>]
(worker_thread+0x104/0x118)
 r7:c1f5ce48 r6:c1edffa4 r5:c1ede000 r4:c1f5ce40
[<c0046424>] (worker_thread+0x0/0x118) from [<c0049b00>] (kthread+0x58/0x94)
 r7:00000000 r6:c1f5ce40 r5:c0046424 r4:c1ede000
[<c0049aa8>] (kthread+0x0/0x94) from [<c0038b08>] (do_exit+0x0/0x6fc)
 r7:00000000 r6:00000000 r5:00000000 r4:00000000
---[ end trace 6a06b766661523a6 ]---
wl12xx: WARNING CONFIGURE command NOK
wl12xx: WARNING acx ac cfg failed: -110
wl12xx: Reading FW panic log
wl12xx: ERROR command complete timeout
------------[ cut here ]------------
WARNING: at /home/bps/compat-wireless-2012-04-03/drivers/net/wireless/wl12xx/cmd.c:108
wl1271_cmd_send+0x340/0x374 [wl12xx]()
Modules linked in: wl12xx_sdio wl12xx compat_firmware_class mac80211
cfg80211 rfkill_backport compat lpc313x_mmc g_serial nxp_usb2_udc
[<c01b9990>] (dump_stack+0x0/0x14) from [<c0035cec>]
(warn_on_slowpath+0x4c/0x68)
[<c0035ca0>] (warn_on_slowpath+0x0/0x68) from [<bf0b0868>]
(wl1271_cmd_send+0x340/0x374 [wl12xx])
 r6:c1f31970 r5:ffffff92 r4:c1f316c0
[<bf0b0528>] (wl1271_cmd_send+0x0/0x374 [wl12xx]) from [<bf0b0f18>]
(wl12xx_cmd_stop_fwlog+0x4c/0x7c [wl12xx])
[<bf0b0ecc>] (wl12xx_cmd_stop_fwlog+0x0/0x7c [wl12xx]) from
[<bf0af38c>] (wl1271_recovery_work+0xb4/0x334 [wl12xx])
 r5:c1f318ac r4:c1f316c0
[<bf0af2d8>] (wl1271_recovery_work+0x0/0x334 [wl12xx]) from
[<c0045e3c>] (run_workqueue+0xbc/0x144)
[<c0045d80>] (run_workqueue+0x0/0x144) from [<c0046528>]
(worker_thread+0x104/0x118)
 r7:c1f5ce48 r6:c1edffa4 r5:c1ede000 r4:c1f5ce40
[<c0046424>] (worke
