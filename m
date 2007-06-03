Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from metis.intersales.de ([213.133.99.69]:32823 "EHLO
	metis.intersales.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbXFCWd2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jun 2007 18:33:28 -0400
Message-ID: <466341AF.7050505@willies.info>
Date: Mon, 04 Jun 2007 00:33:19 +0200
From: Jan Willies <jan@willies.info>
MIME-Version: 1.0
To: jean-baptiste.note@m4x.org
CC: developers@islsm.org, linux-wireless@vger.kernel.org
Subject: Re: [Developers] ISL3880IK crashes with 2.6.19.1 / .21.1
References: <46631BD2.20704@willies.info> <3871229b0706031323w5c8e3589r973b8735ed3e1f85@mail.gmail.com>
In-Reply-To: <3871229b0706031323w5c8e3589r973b8735ed3e1f85@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jean-Baptiste Note schrieb:
> Hi,
> 
> Any chance you could decode the oops ? If you're recompiling the
> kernel yourself, include symbols (can't remember the option name), or
> run ksymoops...

I recompiled the kernel with KALLSYMS and got this:

root@OpenWrt:/# iwconfig
lo        no wireless extensions.

ethData bus error, epc == c007e16c, ra == c007d6c0
Oops[#1]:
Cpu 0
$ 0   : 00000000 1000b800 abad0000 00000032
$ 4   : 00000001 c0068000 00000013 00000001
$ 8   : 00000004 800feb8c 00000000 00000000
$12   : 00000000 00000000 8124ca40 00000000
$16   : 812a7800 000000fa 81361320 81361000
$20   : 00000010 00000000 a1cc0000 00000019
$24   : 00000000 2abd45f0
$28   : 813d6000 813d7ce8 ff02000d c007d6c0
Hi    : 000002fc
Lo    : 00035866
epc   : c007e16c isl38xx_trigger_device+0xc/0x60 [prism54]     Not tainted
ra    : c007d6c0 islpci_mgt_transaction+0x380/0x614 [prism54]
Status: 1000b803    KERNEL EXL IE
Cause : 0000001c
PrId  : 00029007
Modules linked in: prism54 switch_robo switch_core diag
Process iwconfig (pid: 1411, threadinfo=813d6000, task=8106f3f8)
Stack : 81108800 8001e418 00000060 00000000 00000000 8106f3f8 8003bf54 
813616b0
         813616b0 80029ab0 00000004 00000000 00000000 80200ddc 0000008a 
ff02000d
         81361320 813d7d98 81361000 c0086cd0 1000b800 00000000 1000b800 
8002964c
         00000004 813d7d50 00000000 81271d04 813d7e70 813d7e70 813d7e60 
80200ddc
         7fcad438 7fcad478 813d7e60 00008b01 c0081628 00000101 00000001 
00000000
         ...
Call Trace:
[<c007e16c>] isl38xx_trigger_device+0xc/0x60 [prism54]
[<c007d6c0>] islpci_mgt_transaction+0x380/0x614 [prism54]
[<c0086cd0>] mgt_get_request+0x100/0x2ec [prism54]
[<c0081628>] prism54_set_mac_address+0x1a0/0xfd8 [prism54]


Code: 10800014  24020002  3c02abad <8ca30010> 3442face  1462000f 
24020008  0801f868  00000000
0      no wireless extensions.

eth0.0    no wireless extensions.

eth0.1    no wireless extensions.

Segmentation fault


And:

root@OpenWrt:/# iwconfig eth1
Data bus error, epc == c007e1b8, ra == c007d6c0
Oops[#1]:
Cpu 0
$ 0   : 00000000 1000b800 00000008 90004000
$ 4   : 00000001 c0068000 00000013 00000001
$ 8   : 00000004 800feb8c 00000000 00000000
$12   : 00000000 00705aac 2ab8af4c 00000000
$16   : 81c9d280 000000fa 813a8320 813a8000
$20   : 00000010 00000000 a1cc0000 00000019
$24   : 00000000 2abd45f0
$28   : 81c92000 81c93ce8 ff02000d c007d6c0
Hi    : 00000369
Lo    : 00001be5
epc   : c007e1b8 isl38xx_trigger_device+0x58/0x60 [prism54]     Not tainted
ra    : c007d6c0 islpci_mgt_transaction+0x380/0x614 [prism54]
Status: 1000b803    KERNEL EXL IE
Cause : 8000001c
PrId  : 00029007
Modules linked in: prism54 switch_robo switch_core diag
Process iwconfig (pid: 1298, threadinfo=81c92000, task=802ca3f8)
Stack : 00000000 81e5b760 81288000 811134f4 00000000 802ca3f8 8003bf54 
813a86b0
         813a86b0 00000007 00000004 00000000 00000000 80200ddc 0000008a 
ff02000d
         813a8320 81c93d98 813a8000 c0086cd0 813260d8 00000000 813d0000 
00000001
         00000004 81c93d50 00000000 80029ab0 81c93e70 81c93e70 81c93e60 
80200ddc
         7f95e888 7f95e8a8 81c93e60 00008b01 c0081628 00000101 00000001 
00000000
         ...
Call Trace:
[<c007e1b8>] isl38xx_trigger_device+0x58/0x60 [prism54]
[<c007d6c0>] islpci_mgt_transaction+0x380/0x614 [prism54]
[<c0086cd0>] mgt_get_request+0x100/0x2ec [prism54]
[<c0081628>] prism54_set_mac_address+0x1a0/0xfd8 [prism54]


Code: 3c0300a3  24020008  aca20000 <03e00008> 8ca20018  ac850020 
3c0300a3  3c058028  8c820018
Data bus error, epc == c0084850, ra == 80049768
Oops[#2]:
Cpu 0
$ 0   : 00000000 10009801 00000001 fffffbff
$ 4   : c0068000 813a8320 00000000 00000000
$ 8   : 00000041 00000000 8024c9a0 24b76a00
$12   : 386d43c1 80290000 80290000 80290000
$16   : 813c2400 00000000 00000000 00000005
$20   : 00000010 00000000 a1cc0000 00000019
$24   : 00000000 8000be40
$28   : 81c92000 81c93ab0 ff02000d 80049768
Hi    : 00000002
Lo    : 00000005
epc   : c0084850 islpci_interrupt+0x20/0x2c8 [prism54]     Not tainted
ra    : 80049768 handle_IRQ_event+0x54/0xc0
Status: 10009803    KERNEL EXL IE
Cause : 0000201c
PrId  : 00029007
Modules linked in: prism54 switch_robo switch_core diag
Process iwconfig (pid: 1298, threadinfo=81c92000, task=802ca3f8)
Stack : 0000000a 80038acc 00000010 8002dcf8 00000001 8028fe44 813c2400 
00000000
         00000000 80049768 00000008 8028fe24 00000000 80029570 80258140 
00000005
         81c93c38 00000004 8004b57c 81c93c38 10009800 8002964c 00001d49 
1000b800
         0000a000 81c93c38 80001dd8 80001ce0 00000400 80236870 00001d49 
80250000
         00000000 80003960 a1cc0000 00000019 800fda98 00000000 80290000 
80236870
         ...
Call Trace:
[<c0084850>] islpci_interrupt+0x20/0x2c8 [prism54]
[<80049768>] handle_IRQ_event+0x54/0xc0
[<8004b57c>] handle_level_irq+0xbc/0x130
[<80001dd8>] plat_irq_dispatch+0x168/0x1e0
[<80003960>] ret_from_irq+0x0/0x4
[<80009da8>] die+0x94/0xe4
[<8000a0f8>] do_be+0x140/0x17c
[<80003940>] ret_from_exception+0x0/0x20
[<c007e1b8>] isl38xx_trigger_device+0x58/0x60 [prism54]
[<c007d6c0>] islpci_mgt_transaction+0x380/0x614 [prism54]
[<c0086cd0>] mgt_get_request+0x100/0x2ec [prism54]
[<c0081628>] prism54_set_mac_address+0x1a0/0xfd8 [prism54]


Code: 8ca40150  24020001  afa20010 <8c820078> 00a08021  30420200 
1440009d  8cb10160  8c820010
Kernel panic - not syncing: Fatal exception in interrupt
Rebooting in 3 seconds..<1>Please stand by while rebooting the system...

http://pastebin.ca/534888
