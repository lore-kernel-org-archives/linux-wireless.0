Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63752 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754622Ab2DKOhY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 10:37:24 -0400
Received: by obbtb18 with SMTP id tb18so1296955obb.19
        for <linux-wireless@vger.kernel.org>; Wed, 11 Apr 2012 07:37:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1333609261.27729.80.camel@cumari>
References: <CACAxKDr11ySDxbggg1Zc2cZa7QCGk8Rb=WoPdSuOZX-08fTVhw@mail.gmail.com>
	<1333609261.27729.80.camel@cumari>
Date: Wed, 11 Apr 2012 20:07:24 +0530
Message-ID: <CACAxKDoznVbnpF-QL+FE6v+D_5WKS5DPO0BCzOkTwX_GNAz2NQ@mail.gmail.com> (sfid-20120411_163729_425643_C83CEC76)
Subject: Re: Issue with Compat Wireless-2012-04-03 with Wireless operations
From: Girish B N <bngirish1@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luca,

Thanks for the reply
I have switched from Compat Wireless package (2012-04-03) to Compat
wireless package (2012-04-04).
Please find the log below after running the following commands.

>ifconfig wlan0 down
>ifconfig wlan0 hw ether de:ad:be:ef:c0:fe
>iw wlan0 set type ibss
>ifconfig wlan0 up
>iw wlan0 ibss join brady123 2432

The moment i run the above commands, the interface will go down and
there will be an error. I am not able to figure out the reason for
failure with the latest code.

I had the similar issue with the older package Compat wireless package
(2012-02-22) which uses the firmware version wl127x-fw-3.bin version
Rev 6.3.0.0.77
After applying the two below patches, it worked properly in both
Ad-hoc and Managed mode.

http://permalink.gmane.org/gmane.linux.kernel.wireless.general/84311
http://permalink.gmane.org/gmane.linux.kernel.wireless.general/84312

The log after running the able commands is as follows
~ # dmesg
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
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 8128
Kernel command line: console=0 rootfstype=jffs2 quiet
root=/dev/mtdblock7 safefs=0 kernel=1 sku=772
irq=30 Event=0x3e bank:1 bit:30 type:0irq=31 Event=0x54 bank:2 bit:20
type:0irq=32 Event=0x4b bank:2 bit:11 type:0PID hash
JFFS2 version 2.2. (NAND) (SUMMARY)  Â© 2001-2006 Red Hat, Inc.
jffs2_scan_inode_node(): CRC failed on node at 0x000241e8: Read
0xffffffff, calculated 0xb1f136f3
Empty flash at 0x0002422c ends at 0x00024400
jffs2_scan_inode_node(): CRC failed on node at 0x000245d0: Read
0xffffffff, calculated 0x4f7122c0
Empty flash at 0x00024614 ends at 0x00024800

CGU: Get clock id:34 freq:6000000
lpc313x-wdt lpc313x-wdt: Watchdog timer closed unexpectedly
CGU: Get clock id:34 freq:6000000
lpc313x-wdt lpc313x-wdt: Watchdog timer closed unexpectedly
CGU: Get clock id:34 freq:6000000
lpc313x-wdt lpc313x-wdt: Watchdog timer closed unexpectedly
JFFS2 notice: (264) check_node_data: wrong data CRC in data node at
0x00024b24: read 0x84ed3ce5, calculated 0x2579c0bf.

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
Slot<6>Powering on wl12xx<6>lpc313x_mmc lpc313x_mmc.0: LPC313x

MMC controller at irq 26
Powering up MMC Slot<4>mmc0: card claims to support voltages below the
defined range. These will be ignored.
mmc0: queuing CIS tuple 0x91 length 3
mmc_attach_sdio the value of funcs=0x2
mmc_attach_sdio the value of funcs=0x2
mmc0: new SDIO card at address 0001
Powering on wl12xx<6>Compat-wireless backport release:
compat-wireless-2012-04-02-2-1-g5c6c8e6
Backport based on linux-next.git next-20120404

cfg80211: Calling CRDA to update world regulatory domain
wl1271_probe: the value of func->num = 0x2
wl12xx: loaded
~ # ifconfig wlan0 down
~ # ifconfig wlan0 hw ether de:ad:be:ef:c0:fe
~ # iw wlan0 set type ibss
~ # ifconfig wlan0 up
KERNEL[7478.242840] add


/devices/platform/lpc313x_mmc.0/mmc_host/mmc0/mmc0:0001/mmc0:0001:2/wl12xx/compat_firmware/wl12xx
(compat_firmware)
ACTION=add
DEVPATH=/devices/platform/lpc313x_mmc.0/mmc_host/mmc0/mmc0:0001/mmc0:0001:2/wl12xx/compat_firmware/wl12xx
SUBSYSTEM=compat_firmware
FIRMWARE=ti-connectivity/wl127x-fw-4-sr.bin
ASYNC=0
SEQNUM=217

KERNEL[7478.534438] remove

/devices/platform/lpc313x_mmc.0/mmc_host/mmc0/mmc0:0001/mmc0:0001:2/wl12xx/compat_firmware/wl12xx
(compat_firmware)
ACTION=remove
DEVPATH=/devices/platform/lpc313x_mmc.0/mmc_host/mmc0/mmc0:0001/mmc0:0001:2/wl12xx/compat_firmware/wl12xx
SUBSYSTEM=compat_firmware
FIRMWARE=ti-connectivity/wl127x-fw-4-sr.bin
ASYNC=0
SEQNUM=218

UDEV  [7478.540249] add


/devices/platform/lpc313x_mmc.0/mmc_host/mmc0/mmc0:0001/mmc0:0001:2/wl12xx/compat_firmware/wl12xx
(compat_firmware)
ACTION=add
DEVPATH=/devices/platform/lpc313x_mmc.0/mmc_host/mmc0/mmc0:0001/mmc0:0001:2/wl12xx/compat_firmware/wl12xx
SUBSYSTEM=compat_firmware
FIRMWARE=ti-connectivity/wl127x-fw-4-sr.bin
ASYNC=0
SEQNUM=217

UDEV  [7478.566789] remove

/devices/platform/lpc313x_mmc.0/mmc_host/mmc0/mmc0:0001/mmc0:0001:2/wl12xx/compat_firmware/wl12xx
(compat_firmware)
ACTION=remove
DEVPATH=/devices/platform/lpc313x_mmc.0/mmc_host/mmc0/mmc0:0001/mmc0:0001:2/wl12xx/compat_firmware/wl12xx
SUBSYSTEM=compat_firmware
FIRMWARE=ti-connectivity/wl127x-fw-4-sr.bin
ASYNC=0
SEQNUM=218


~ #
~ # iw wlan0 ibss join brady123 2.4
Usage: iw [options] dev <devname> ibss join <SSID> <freq in MHz>
[fixed-freq] [<fixed bssid>] [beacon-interval <TU>]

[basic-rates <rate in Mbps,rate2,...>] [mcast-rate <rate in Mbps>]
[key d:0:abcde]

Join the IBSS cell with the given SSID, if it doesn't exist create
it on the given frequency. When fixed frequency is requested, don't
join/create a cell on a different frequency. When a fixed BSSID is
requested use that BSSID and do not adopt another cell's BSSID even
if it has higher TSF and the same SSID. If an IBSS is created, create
it with the specified basic-rates, multicast-rate and beacon-interval.

Options:
--debug enable netlink debugging
~ #
~ # iw wlan0 ibss join brady123 2.4 [J
Usage: iw [options] dev <devname> ibss join <SSID> <freq in MHz>
[fixed-freq] [<fixed bssid>] [beacon-interval <TU>]

[basic-rates <rate in Mbps,rate2,...>] [mcast-rate <rate in Mbps>]
[key d:0:abcde]

Join the IBSS cell with the given SSID, if it doesn't exist create
it on the given frequency. When fixed frequency is requested, don't
join/create a cell on a different frequency. When a fixed BSSID is
requested use that BSSID and do not adopt another cell's BSSID even
if it has higher TSF and the same SSID. If an IBSS is created, create
it with the specified basic-rates, multicast-rate and beacon-interval.

Options:
--debug enable netlink debugging
~ # dme 2412
~ # iw wlan0 ibss join brady123 2.4 [J 412 32

~ # dmesg
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
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 8128
Kernel command line: console=0 rootfstype=jffs2 quiet
root=/dev/mtdblock7 safefs=0 kernel=1 sku=772
irq=30 Event=0x3e bank:1 bit:30 type:0irq=31 Event=0x54 bank:2 bit:20
type:0irq=32 Event=0x4b bank:2 bit:11 type:0PID hash
JFFS2 version 2.2. (NAND) (SUMMARY)  Â© 2001-2006 Red Hat, Inc.
jffs2_scan_inode_node(): CRC failed on node at 0x000241e8: Read
0xffffffff, calculated 0xb1f136f3
Empty flash at 0x0002422c ends at 0x00024400
jffs2_scan_inode_node(): CRC failed on node at 0x000245d0: Read
0xffffffff, calculated 0x4f7122c0
Empty flash at 0x00024614 ends at 0x00024800

CGU: Get clock id:34 freq:6000000
lpc313x-wdt lpc313x-wdt: Watchdog timer closed unexpectedly
CGU: Get clock id:34 freq:6000000
lpc313x-wdt lpc313x-wdt: Watchdog timer closed unexpectedly
CGU: Get clock id:34 freq:6000000
lpc313x-wdt lpc313x-wdt: Watchdog timer closed unexpectedly
JFFS2 notice: (264) check_node_data: wrong data CRC in data node at
0x00024b24: read 0x84ed3ce5, calculated 0x2579c0bf.

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
Slot<6>Powering on wl12xx<6>lpc313x_mmc lpc313x_mmc.0: LPC313x

MMC controller at irq 26
Powering up MMC Slot<4>mmc0: card claims to support voltages below the
defined range. These will be ignored.
mmc0: queuing CIS tuple 0x91 length 3
mmc_attach_sdio the value of funcs=0x2
mmc_attach_sdio the value of funcs=0x2
mmc0: new SDIO card at address 0001
Powering on wl12xx<6>Compat-wireless backport release:
compat-wireless-2012-04-02-2-1-g5c6c8e6
Backport based on linux-next.git next-20120404

cfg80211: Calling CRDA to update world regulatory domain
wl1271_probe: the value of func->num = 0x2
wl12xx: loaded
wl12xx: TEST_CMD_INI_FILE_RADIO_PARAM: 00000000: 00 00 00 00 19 00 00
00 00 00 ec f6 00 0c 18 f8
wl12xx: TEST_CMD_INI_FILE_RADIO_PARAM: 00000010: fc 00 08 10 f0 f8 00
0a 14 00 00 00 00 00 00 00
wl12xx: TEST_CMD_INI_FILE_RADIO_PARAM: 00000020: 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00
wl12xx: TEST_CMD_INI_FILE_RADIO_PARAM: 00000030: 00 00 00 00 00 00 77
01 80 00 1d 1f 22 26 27 29
wl12xx: TEST_CMD_INI_FILE_RADIO_PARAM: 00000040: 1a 1f 22 25 25 27 16
1d 1e 20 24 25 50 50 50 50
wl12xx: TEST_CMD_INI_FILE_RADIO_PARAM: 00000050: 50 50 50 50 50 50 50
50 50 50 50 50 50 50 50 50
wl12xx: TEST_CMD_INI_FILE_RADIO_PARAM: 00000060: 50 50 50 50 50 50 50
50 01 02 02 02 02 00 15 15
wl12xx: TEST_CMD_INI_FILE_RADIO_PARAM: 00000070: 15 11 15 15 0e 1e 2d
00 00 00 00 00 00 00 00 00
wl12xx: TEST_CMD_INI_FILE_RADIO_PARAM: 00000080: 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00
wl12xx: TEST_CMD_INI_FILE_RADIO_PARAM: 00000090: 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00
wl12xx: TEST_CMD_INI_FILE_RADIO_PARAM: 000000a0: 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00
wl12xx: TEST_CMD_INI_FILE_RADIO_PARAM: 000000b0: 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00
wl12xx: TEST_CMD_INI_FILE_RADIO_PARAM: 000000c0: 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00
wl12xx: TEST_CMD_INI_FILE_RADIO_PARAM: 000000d0: 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00
wl12xx: TEST_CMD_INI_FILE_EXT_RADIO_PARAM: 00000000: 00 00 00 00 26 00
00 00 00 00 00 00 00 00 00 00
wl12xx: TEST_CMD_INI_FILE_EXT_RADIO_PARAM: 00000010: 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00
wl12xx: TEST_CMD_INI_FILE_EXT_RADIO_PARAM: 00000020: 00 00 00 00
wl12xx: firmware booted (Rev 6.3.5.0.98)
wlan0: Trigger new scan to find an IBSS to join
~ #
~ # dmesg [J
~ # iw wlan0 ibss join brady123 2432 [J
~ # iw wlan0 ibss join brady123 2.4 [J
~ # ifconfig wlan0 up [J
~ #

iw wlan0 set type ibss [J
~ # ifconfig wlan0 up [J
~ # iw wlan0 set type ibss [J
~ # ifconfig wlan0 hw ether

de:ad:be:ef:c0:fe [J
~ # iw wlan0 set type ibss [J
~ # ifconfig wlan0 up [J
~ # iw wlan0 ibss join brady123 2.4 [J
~ # iw

wlan0 ibss join brady123 2432 [J
~ # dmesg [J
~ # [J iw dev wlan0 scan
command failed: Resource temporarily unavailable (-11)
~ #
~ # iw dev wlan0 scan [J
command failed: Resource temporarily unavailable (-11)
~ # iw dev wlan0 link
Joined IBSS 8e:0a:7f:d4:9c:b7 (on wlan0)
SSID: brady123
freq: 2432
~ # ifconfig -a

lo        Link encap:Local Loopback
        inet addr:127.0.0.1  Mask:255.0.0.0
        UP LOOPBACK RUNNING  MTU:16436  Metric:1
        RX packets:0 errors:0 dropped:0 overruns:0 frame:0
        TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
        collisions:0 txqueuelen:0
        RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

wlan0     Link encap:Ethernet  HWaddr DE:AD:BE:EF:C0:FE
        UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1

        RX packets:0 errors:0 dropped:0 overruns:0 frame:0
        TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
        collisions:0 txqueuelen:1000
        RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

~ #
~ # ifconfig -a [J
~ # iw dev wlan0 link [J
~ # iw dev wlan0 scan [J
command failed: Resource temporarily unavailable (-11)

~ # dmesg
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
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 8128
Kernel command line: console=0 rootfstype=jffs2 quiet
root=/dev/mtdblock7 safefs=0 kernel=1 sku=772
irq=30 Event=0x3e bank:1 bit:30 type:0irq=31 Event=0x54 bank:2 bit:20
type:0irq=32 Event=0x4b bank:2 bit:11 type:0PID hash
JFFS2 version 2.2. (NAND) (SUMMARY)  Â© 2001-2006 Red Hat, Inc.
jffs2_scan_inode_node(): CRC failed on node at 0x000241e8: Read
0xffffffff, calculated 0xb1f136f3
Empty flash at 0x0002422c ends at 0x00024400
jffs2_scan_inode_node(): CRC failed on node at 0x000245d0: Read
0xffffffff, calculated 0x4f7122c0
Empty flash at 0x00024614 ends at 0x00024800

CGU: Get clock id:34 freq:6000000
lpc313x-wdt lpc313x-wdt: Watchdog timer closed unexpectedly
CGU: Get clock id:34 freq:6000000
lpc313x-wdt lpc313x-wdt: Watchdog timer closed unexpectedly
CGU: Get clock id:34 freq:6000000
lpc313x-wdt lpc313x-wdt: Watchdog timer closed unexpectedly
JFFS2 notice: (264) check_node_data: wrong data CRC in data node at
0x00024b24: read 0x84ed3ce5, calculated 0x2579c0bf.

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
Slot<6>Powering on wl12xx<6>lpc313x_mmc lpc313x_mmc.0: LPC313x

MMC controller at irq 26
Powering up MMC Slot<4>mmc0: card claims to support voltages below the
defined range. These will be ignored.
mmc0: queuing CIS tuple 0x91 length 3
mmc_attach_sdio the value of funcs=0x2
mmc_attach_sdio the value of funcs=0x2
mmc0: new SDIO card at address 0001
Powering on wl12xx<6>Compat-wireless backport release:
compat-wireless-2012-04-02-2-1-g5c6c8e6
Backport based on linux-next.git next-20120404

cfg80211: Calling CRDA to update world regulatory domain
wl1271_probe: the value of func->num = 0x2
wl12xx: loaded
wl12xx: TEST_CMD_INI_FILE_RADIO_PARAM: 00000000: 00 00 00 00 19 00 00
00 00 00 ec f6 00 0c 18 f8
wl12xx: TEST_CMD_INI_FILE_RADIO_PARAM: 00000010: fc 00 08 10 f0 f8 00
0a 14 00 00 00 00 00 00 00
wl12xx: TEST_CMD_INI_FILE_RADIO_PARAM: 00000020: 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00
wl12xx: TEST_CMD_INI_FILE_RADIO_PARAM: 00000030: 00 00 00 00 00 00 77
01 80 00 1d 1f 22 26 27 29
wl12xx: TEST_CMD_INI_FILE_RADIO_PARAM: 00000040: 1a 1f 22 25 25 27 16
1d 1e 20 24 25 50 50 50 50
wl12xx: TEST_CMD_INI_FILE_RADIO_PARAM: 00000050: 50 50 50 50 50 50 50
50 50 50 50 50 50 50 50 50
wl12xx: TEST_CMD_INI_FILE_RADIO_PARAM: 00000060: 50 50 50 50 50 50 50
50 01 02 02 02 02 00 15 15
wl12xx: TEST_CMD_INI_FILE_RADIO_PARAM: 00000070: 15 11 15 15 0e 1e 2d
00 00 00 00 00 00 00 00 00
wl12xx: TEST_CMD_INI_FILE_RADIO_PARAM: 00000080: 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00
wl12xx: TEST_CMD_INI_FILE_RADIO_PARAM: 00000090: 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00
wl12xx: TEST_CMD_INI_FILE_RADIO_PARAM: 000000a0: 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00
wl12xx: TEST_CMD_INI_FILE_RADIO_PARAM: 000000b0: 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00
wl12xx: TEST_CMD_INI_FILE_RADIO_PARAM: 000000c0: 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00
wl12xx: TEST_CMD_INI_FILE_RADIO_PARAM: 000000d0: 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00
wl12xx: TEST_CMD_INI_FILE_EXT_RADIO_PARAM: 00000000: 00 00 00 00 26 00
00 00 00 00 00 00 00 00 00 00
wl12xx: TEST_CMD_INI_FILE_EXT_RADIO_PARAM: 00000010: 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00
wl12xx: TEST_CMD_INI_FILE_EXT_RADIO_PARAM: 00000020: 00 00 00 00
wl12xx: firmware booted (Rev 6.3.5.0.98)
wlan0: Trigger new scan to find an IBSS to join
wl12xx: Scan completed due to error.

wl12xx: Reading FW panic log
wl12xx: Hardware recovery in progress. FW ver: Rev 6.3.5.0.98 pc: 0x0
wl12xx: down
ieee80211 phy0: Hardware restart was requested
wlan0: Creating new IBSS network, BSSID c1f2bf10
wl12xx: ERROR timeout waiting for the hardware to complete initialization
wl12xx: ERROR timeout waiting for the hardware to complete initialization
wl12xx: ERROR timeout waiting for the hardware to complete initialization
wl12xx: ERROR firmware boot failed despite 3 retries
wlan0: No active IBSS STAs - trying to scan for other IBSS networks
with same SSID (merge)
wlan0: No active IBSS STAs - trying to scan for other IBSS networks
with same SSID (merge)

Thanks
Girish

On Thu, Apr 5, 2012 at 12:31 PM, Luciano Coelho <coelho@ti.com> wrote:
> Hi Girish,
>
> On Wed, 2012-04-04 at 21:21 +0530, Girish B N wrote:
>> With latest Compat wireless package (2012-04-03) and firmware ver (04
>> - wl127x-fw-4-sr.bin and wl127x-fw-4-plt.bin, ) I am able to
>> successfully calibrate and nvs file sucessfully.
>> However, I am not able to connect to any device. there is crash in the
>> modules. However I am able to do the scan operation successfully.
>> There is crash after running the following commands
>> >ifconfig wlan0 down
>> >ifconfig wlan0 hw ether de:ad:be:ef:c0:fe
>> >iwconfig wlan0 mode ad-hoc
>> >iwconfig wlan0 essid brady123
>> >ifconfig wlan0 192.168.1.6 up
>
> Can you try to redo this with iw instead of iwconfig? Try this:
>
> ifconfig wlan0 down
> ifconfig wlan0 hw ether de:ad:be:ef:c0:fe
> iw wlan0 set type ibss
> ifconfig wlan0 up
> iw wlan0 ibss join brady123
>
> iwconfig is obsolete and if you use it, there is some wrapper code and
> other things happening, so it's more difficult to follow.  It should
> still work, of course, but if you use iw, I'll be able to help you more
> easily.
>
>
>> Please find the log below
>>
>> Let us know the right version of the firmware and any patches to be
>> applied for Compat Wireless package to be able to use for both
>> calibration and successful wireless operation
>
> [...]
>
>> Powering on wl12xx<6>Compat-wireless backport release:
>> compat-wireless-2012-04-02-2-1-g5c6c8e6
>> Backport based on linux-next.git next-20120403
>> cfg80211: Calling CRDA to update world regulatory domain
>> wl1271_probe: the value of func->num = 0x2
>> wl12xx: loaded
>> wl12xx: firmware booted (Rev 6.3.5.0.98)
>
> This seems to be the correct version to use with the latest upstream
> code.
>
>
>> wlan0: Creating new IBSS network, BSSID c1edff10
>> wl12xx: ERROR command complete timeout
>> ------------[ cut here ]------------
>> WARNING: at
>> /home/bps/compat-wireless-2012-04-03/drivers/net/wireless/wl12xx/cmd.c:108
>> wl1271_cmd_send+0x340/0x374 [wl12xx]()
>
> [...]
>
>> wl12xx: ERROR failed to initiate cmd role enable
>> wl12xx: WARNING cmd join failed -110
>> wl12xx: ERROR command complete timeout
>> ------------[ cut here ]------------
>
> For some reason the firmware is not able to start the IBSS role.
>
> Could you try this again with the iw commands I mentioned above and
> enable debugging on the wl12xx module with debug_level 0x13800?
>
> --
> Cheers,
> Luca.
>
