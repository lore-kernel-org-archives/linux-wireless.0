Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:43140 "EHLO
        eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754542AbcISMGE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 08:06:04 -0400
To: <linux-wireless@vger.kernel.org>,
        Aditya Shankar <Aditya.Shankar@microchip.com>,
        Ganesh Krishna <Ganesh.Krishna@microchip.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <luisbg@osg.samsung.com>
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: staging: wilc1000: kernel Oops while opening the device
Message-ID: <c12338f5-0a50-bb55-0b83-0fa705237cf8@atmel.com> (sfid-20160919_140608_648592_0ADCCF9E)
Date: Mon, 19 Sep 2016 14:06:02 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

While using the wilc1000 driver with latest 4.8-rc7, I
have difficulties to open the device and actually use it as I have
this kernel Oops right after the loading of the firmware (wilc1003_firmware.bin).

If I revert back the driver to its b9811891a9f60ca9c314dcab3244c65930c4cf37 state,
it works okay. I did this because I tend to think that it might be related to the latest
move on this driver to "completion" or "work queues".
It seems to be a regression from 4.7.

It's on my ARM platform sama5d2 Xplained.

Here is the log:

---------------------------------------------------------------------------

root@sama5d2-xplained:~# ifup wlan0
Successfully initialized wpa_supplicant
wilc1000_sdio mmc1:0001:1: chipid (001003a0)
wilc1000_sdio mmc1:0001:1: has_thrpt_enh3 = 1...
wilc1000_sdio mmc1:0001:1 wlan0: loading firmware atmel/wilc1003_firmware.bin
Unable to handle kernel NULL pointer dereference at virtual address 00000010
pgd = d4608000
[00000010] *pgd=34671831, *pte=00000000, *ppte=00000000
Internal error: Oops: 17 [#1] ARM
Modules linked in: wilc1000_sdio(C) wilc1000(C)
CPU: 0 PID: 365 Comm: wpa_supplicant Tainted: G         C      4.8.0-rc7 #231
Hardware name: Atmel SAMA5
task: d463dbc0 task.stack: d462e000
PC is at __queue_work+0x98/0x29c
LR is at __queue_work+0x60/0x29c
pc : [<c0127060>]    lr : [<c0127028>]    psr: 60000093
sp : d462fc68  ip : a0000093  fp : 00000014
r10: 00000000  r9 : 00000001  r8 : c0a0812c
r7 : c0a2f098  r6 : d444a900  r5 : d4663374  r4 : 00000000
r3 : 0006000a  r2 : d4663374  r1 : 07ffffff  r0 : 00000000
Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment none
Control: 10c53c7d  Table: 34608059  DAC: 00000051
Process wpa_supplicant (pid: 365, stack limit = 0xd462e208)
Stack: (0xd462fc68 to 0xd4630000)
fc60:                   c0a0bbc0 ffffc985 a0000013 ffffffe1 00000000 d461a460
fc80: 00000000 d444a500 00008914 c0127298 d4663200 d461a460 00000001 bf0076b4
fca0: fffffe7c bf0082b4 ffffffff 00000018 00000001 00000000 00000000 00000000
fcc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
fce0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
fd00: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
fd20: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
fd40: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
fd60: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
fd80: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
fda0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
fdc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
fde0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
fe00: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 d461a460
fe20: 00000000 00000000 00000000 00000000 d461a000 d461a800 00000000 bf00509c
fe40: 00000001 00000000 d461a000 bf00dde0 00000001 00001002 00000000 c04fde98
fe60: d461a000 d461a000 00000001 d461a000 00001003 c04fe128 d461a000 00000148
fe80: 00001002 00000001 00000000 c04fe204 00000000 d444a50c 00000000 00000001
fea0: 00000000 c0557d5c 00000020 00000000 bebd28f0 bebd28f0 d444a50c d461a000
fec0: 6e616c77 00000030 00000000 00000000 00001003 00000000 00000000 00000000
fee0: 00001002 00008914 bebd28f0 d0164000 bebd28f0 d43ceb40 d462e000 bebd28f0
ff00: d0164020 c04e40a0 00000005 d43ceb40 00008914 c01b16e0 d43ce008 00000020
ff20: 00000001 00000001 00000000 00000000 d4418d80 d43ce000 00000008 d4028ba8
ff40: d43ce000 00000008 bebd2950 d462ff80 00000008 c01a1a1c 00000000 00000000
ff60: d43ce000 00000000 00000000 d43ceb40 d43ceb40 00008914 bebd28f0 00000005
ff80: d462e000 00000000 000f0c70 c01b1ef0 00000000 00000005 00000001 00000036
ffa0: c01076e4 c0107520 00000000 00000005 00000005 00008914 bebd28f0 00001003
ffc0: 00000000 00000005 00000001 00000036 0011959d 001195b9 00000005 000f0c70
ffe0: 001019bc bebd28e4 000b4660 b6c761fc 600c0010 00000005 00000000 00000000
[<c0127060>] (__queue_work) from [<c0127298>] (queue_work_on+0x34/0x40)
[<c0127298>] (queue_work_on) from [<bf0076b4>] (wilc_enqueue_cmd+0x54/0x64 [wilc1000])
[<bf0076b4>] (wilc_enqueue_cmd [wilc1000]) from [<bf0082b4>] (wilc_set_wfi_drv_handler+0x48/0x70 [wilc1000])
[<bf0082b4>] (wilc_set_wfi_drv_handler [wilc1000]) from [<bf00509c>] (wilc_mac_open+0x214/0x250 [wilc1000])
[<bf00509c>] (wilc_mac_open [wilc1000]) from [<c04fde98>] (__dev_open+0xb8/0x11c)
[<c04fde98>] (__dev_open) from [<c04fe128>] (__dev_change_flags+0x94/0x158)
[<c04fe128>] (__dev_change_flags) from [<c04fe204>] (dev_change_flags+0x18/0x48)
[<c04fe204>] (dev_change_flags) from [<c0557d5c>] (devinet_ioctl+0x6b4/0x788)
[<c0557d5c>] (devinet_ioctl) from [<c04e40a0>] (sock_ioctl+0x154/0x2cc)
[<c04e40a0>] (sock_ioctl) from [<c01b16e0>] (do_vfs_ioctl+0x9c/0x878)
[<c01b16e0>] (do_vfs_ioctl) from [<c01b1ef0>] (SyS_ioctl+0x34/0x5c)
[<c01b1ef0>] (SyS_ioctl) from [<c0107520>] (ret_fast_syscall+0x0/0x3c)
Code: e5932004 e1520006 01a04003 0affffff (e5943010) 
---[ end trace b612328adaa6bf20 ]---
/etc/network/if-pre-up.d/wpa-supplicant: line 83:   365 Segmentation fault      start-stop-daemon --start --quiet --name $WPA_SUP_PNAME --startas $WPA_SUP_BIN --pidfile $WPA_SUP_PIDFILE -- $WPA_SUP_OPTIONS $WPA_SUP_CONF -D $IF_WPA_DRIVER

---------------------------------------------------------------------------

Best regards,
-- 
Nicolas Ferre
