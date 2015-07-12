Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:35669 "EHLO
	mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbbGLRlt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jul 2015 13:41:49 -0400
Received: by qkbp125 with SMTP id p125so240786522qkb.2
        for <linux-wireless@vger.kernel.org>; Sun, 12 Jul 2015 10:41:48 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 12 Jul 2015 10:41:48 -0700
Message-ID: <CANfj49UXDJACBjSgdd8RE6=cQ43KMBapOCh7qaQ00jZQZ2bOPQ@mail.gmail.com> (sfid-20150712_194247_796616_1D61DB19)
Subject: Oops with rtl8187
From: Oliver Kurth <okurth@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have a awus036h (Alfa) wireless usb adapter, which uses the rtl8187
driver. I am trying to get it to work with a raspberry pi running
Linux 4.0.7-v7+. It sometimes works for some time, but will always
eventually crash, bringing the whole network down. I already upgraded
from 3.18, where I had the same issue. I also tested it by connecting
it to a Linux vm in VMware Fusion running Ubuntu 15.04 with kernel
3.19.0-21 and got the same Oops, so it is not a problem just confined
to the raspberry or the arm architecture.


pi@raspberrypi ~ $ uname -a
Linux raspberrypi 4.0.7-v7+ #802 SMP PREEMPT Wed Jul 8 18:01:25 BST
2015 armv7l GNU/Linux

vmware@ubuntu:~$ lsusb
Bus 001 Device 021: ID 0bda:8187 Realtek Semiconductor Corp. RTL8187
Wireless Adapter
...


Jul 11 06:00:23 raspberrypi kernel: [   41.746641] Internal error:
Oops: 817 [#1] PREEMPT SMP ARM
Jul 11 06:00:23 raspberrypi kernel: [   41.753311] Modules linked in:
xt_state iptable_filter ipt_MASQUERADE nf_nat_masquerade_ipv4
iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat
nf_connt
rack ip_tables x_tables snd_bcm2835 snd_pcm snd_seq snd_seq_device
snd_timer snd arc4 rtl8187 eeprom_93cx6 mac80211 cfg80211 rfkill
8192cu uio_pdrv_genirq uio
Jul 11 06:00:23 raspberrypi kernel: [   41.788246] CPU: 0 PID: 1563
Comm: wpa_supplicant Not tainted 4.0.7-v7+ #802
Jul 11 06:00:23 raspberrypi kernel: [   41.797857] Hardware name: BCM2709
Jul 11 06:00:23 raspberrypi kernel: [   41.802538] task: b8534200 ti:
b8420000 task.ti: b8420000
Jul 11 06:00:23 raspberrypi kernel: [   41.809255] PC is at
__mutex_lock_slowpath+0xb8/0x180
Jul 11 06:00:23 raspberrypi kernel: [   41.815624] LR is at
__mutex_lock_slowpath+0x90/0x180
Jul 11 06:00:23 raspberrypi kernel: [   41.821967] pc : [<80549e24>]
 lr : [<80549dfc>]    psr: a0000013
Jul 11 06:00:23 raspberrypi kernel: [   41.821967] sp : b8421ce8  ip :
b8421ce8  fp : b8421d1c
Jul 11 06:00:23 raspberrypi kernel: [   41.836034] r10: 00000001  r9 :
b853f034  r8 : 00000000
Jul 11 06:00:23 raspberrypi kernel: [   41.842516] r7 : b8534200  r6 :
ffffffff  r5 : b853f030  r4 : b853f02c
Jul 11 06:00:23 raspberrypi kernel: [   41.850299] r3 : 00000000  r2 :
b8421cec  r1 : 00000000  r0 : b853f030
Jul 11 06:00:23 raspberrypi kernel: [   41.858086] Flags: NzCv  IRQs
on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Jul 11 06:00:23 raspberrypi kernel: [   41.867723] Control: 10c5387d
Table: 3851c06a  DAC: 00000015
Jul 11 06:00:23 raspberrypi kernel: [   41.874731] Process
wpa_supplicant (pid: 1563, stack limit = 0xb8420210)
Jul 11 06:00:23 raspberrypi kernel: [   41.883970] Stack: (0xb8421ce8
to 0xb8422000)
Jul 11 06:00:23 raspberrypi kernel: [   41.889608] 1ce0:
    b75af4c8 b853f034 00000000 b8421d00 b853f02c b75af4c8
Jul 11 06:00:23 raspberrypi kernel: [   41.900320] 1d00: b75af000
b75af02c 00000000 b92c1200 b8421d34 b8421d20 80549f48 80549d78
Jul 11 06:00:23 raspberrypi kernel: [   41.911022] 1d20: 7f203fb8
b853e340 b8421d94 b8421d38 7f203fec 80549ef8 b8421d94 b8421d48
Jul 11 06:00:23 raspberrypi kernel: [   41.921726] 1d40: b8421dbc
b8421d50 7f182db8 7f182e28 b8534200 00000000 b853f02c b853e340
Jul 11 06:00:23 raspberrypi kernel: [   41.932459] 1d60: b853f020
00000000 00000001 b853e340 b75af4c8 b75af000 b75af02c 00000000
Jul 11 06:00:23 raspberrypi kernel: [   41.943281] 1d80: b92c1200
00000001 b8421ddc b8421d98 7f164c6c 7f203fc4 00000002 b853ee34
Jul 11 06:00:23 raspberrypi kernel: [   41.954242] 1da0: b75af02c
00000000 b92c1200 7f16274c b8421ddc b75af4c0 7f1aa7ec 00000001
Jul 11 06:00:23 raspberrypi kernel: [   41.965277] 1dc0: b75af02c
00000000 b92c1200 00008914 b8421df4 b8421de0 7f165bd0 7f164bd4
Jul 11 06:00:23 raspberrypi kernel: [   41.976400] 1de0: 7f165b6c
b75af000 b8421e1c b8421df8 8047129c 7f165b78 b8421e1c b75af000
Jul 11 06:00:23 raspberrypi kernel: [   41.987569] 1e00: b75af000
00001003 00000001 00001002 b8421e44 b8421e20 80471584 804711e0
Jul 11 06:00:23 raspberrypi kernel: [   41.998767] 1e20: 00008914
b75af000 00000140 00001002 00000001 00000000 b8421e6c b8421e48
Jul 11 06:00:23 raspberrypi kernel: [   42.009995] 1e40: 8047167c
804714f8 00008914 00000000 b92c120c 00000000 00000001 00000000
Jul 11 06:00:23 raspberrypi kernel: [   42.021278] 1e60: b8421ed4
b8421e70 804dc004 80471660 00000020 00000000 b75af000 b92c120c
Jul 11 06:00:23 raspberrypi kernel: [   42.032577] 1e80: 00000014
7eb83a3c 6e616c77 00000031 00000000 00000000 00001003 00000000
Jul 11 06:00:23 raspberrypi kernel: [   42.043875] 1ea0: 00000000
00000000 00001002 00008914 b91dde40 7eb83a3c 80838cc0 00000006
Jul 11 06:00:23 raspberrypi kernel: [   42.055171] 1ec0: 7eb83a3c
b964c4a0 b8421ee4 b8421ed8 804dd8f4 804db968 b8421f04 b8421ee8
Jul 11 06:00:23 raspberrypi kernel: [   42.066467] 1ee0: 804531e0
804dd75c b91dde40 b91dde40 00000006 7eb83a3c b8421f7c b8421f08
Jul 11 06:00:23 raspberrypi kernel: [   42.077764] 1f00: 80150f34
80453014 b8421f24 b8421f18 8015b4bc 7eb83904 b964c300 00000000
Jul 11 06:00:23 raspberrypi kernel: [   42.089064] 1f20: 00000129
8000ed48 b8420000 00000000 b8421f94 b8421f40 80455ab4 80454b74
Jul 11 06:00:23 raspberrypi kernel: [   42.100366] 1f40: 00000000
00000000 00000000 00000024 b8421e90 b91dde40 b91dde40 00008914
Jul 11 06:00:23 raspberrypi kernel: [   42.111669] 1f60: 7eb83a3c
00000006 b8420000 00000000 b8421fa4 b8421f80 80151170 80150b20
Jul 11 06:00:23 raspberrypi kernel: [   42.122971] 1f80: 00001003
000cfae8 00ad48bc 00000006 00000036 8000ed48 00000000 b8421fa8
Jul 11 06:00:23 raspberrypi kernel: [   42.134274] 1fa0: 8000eb40
80151138 000cfae8 00ad48bc 00000006 00008914 7eb83a3c 00001003
Jul 11 06:00:23 raspberrypi kernel: [   42.145578] 1fc0: 000cfae8
00ad48bc 00000006 00000036 00000001 000cfae8 7eb83b2c 7eb83b18
Jul 11 06:00:23 raspberrypi kernel: [   42.156879] 1fe0: 00ad48bc
7eb83a38 00093fe8 76c81dcc 60000010 00000006 00000000 00000000
Jul 11 06:00:23 raspberrypi kernel: [   42.168192] [<80549e24>]
(__mutex_lock_slowpath) from [<80549f48>] (mutex_lock+0x5c/0x60)
Jul 11 06:00:23 raspberrypi kernel: [   42.179509] [<80549f48>]
(mutex_lock) from [<7f203fec>] (rtl8187_start+0x34/0x2ac8 [rtl8187])
Jul 11 06:00:23 raspberrypi kernel: [   42.191240] [<7f203fec>]
(rtl8187_start [rtl8187]) from [<7f164c6c>]
(ieee80211_do_open+0xa4/0xfa4 [mac80211])
Jul 11 06:00:23 raspberrypi kernel: [   42.204496] [<7f164c6c>]
(ieee80211_do_open [mac80211]) from [<7f165bd0>]
(ieee80211_open+0x64/0x68 [mac80211])
Jul 11 06:00:23 raspberrypi kernel: [   42.217785] [<7f165bd0>]
(ieee80211_open [mac80211]) from [<8047129c>] (__dev_open+0xc8/0x140)
Jul 11 06:00:23 raspberrypi kernel: [   42.229519] [<8047129c>]
(__dev_open) from [<80471584>] (__dev_change_flags+0x98/0x168)
Jul 11 06:00:23 raspberrypi kernel: [   42.240637] [<80471584>]
(__dev_change_flags) from [<8047167c>] (dev_change_flags+0x28/0x58)
Jul 11 06:00:23 raspberrypi kernel: [   42.252184] [<8047167c>]
(dev_change_flags) from [<804dc004>] (devinet_ioctl+0x6a8/0x778)
Jul 11 06:00:23 raspberrypi kernel: [   42.263467] [<804dc004>]
(devinet_ioctl) from [<804dd8f4>] (inet_ioctl+0x1a4/0x1d0)
Jul 11 06:00:23 raspberrypi kernel: [   42.274223] [<804dd8f4>]
(inet_ioctl) from [<804531e0>] (sock_ioctl+0x1d8/0x2a4)
Jul 11 06:00:23 raspberrypi kernel: [   42.284716] [<804531e0>]
(sock_ioctl) from [<80150f34>] (do_vfs_ioctl+0x420/0x618)
Jul 11 06:00:23 raspberrypi kernel: [   42.295386] [<80150f34>]
(do_vfs_ioctl) from [<80151170>] (SyS_ioctl+0x44/0x6c)
Jul 11 06:00:23 raspberrypi kernel: [   42.305796] [<80151170>]
(SyS_ioctl) from [<8000eb40>] (ret_fast_syscall+0x0/0x54)
Jul 11 06:00:23 raspberrypi kernel: [   42.316465] Code: e50b302c
e50b9030 e584200c e3e06000 (e5832000)
Jul 11 06:00:23 raspberrypi kernel: [   42.324397] ---[ end trace
1a4b1708ecea66b7 ]---
Jul 11 06:00:23 raspberrypi kernel: [   42.330670] note:
wpa_supplicant[1563] exited with preempt_count 2
