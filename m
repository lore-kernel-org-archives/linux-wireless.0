Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from metis.intersales.de ([213.133.99.69]:55150 "EHLO
	metis.intersales.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbXFCVCO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jun 2007 17:02:14 -0400
Message-ID: <46631BD2.20704@willies.info>
Date: Sun, 03 Jun 2007 21:51:46 +0200
From: Jan Willies <jan@willies.info>
MIME-Version: 1.0
To: developers@islsm.org, linux-wireless@vger.kernel.org
Subject: ISL3880IK crashes with 2.6.19.1 / .21.1
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I tried to replace my broken atheros card with an ISL3880IK one but it 
crashes. I tried both wireless-tools.28/29 and kernel 2.6.19.1/2.6.21.1

My system is OpenWrt on a Netgear WGT634U (mipsel).

Any ideas on that?


regards
Jan



Jan  1 00:00:26 OpenWrt user.info kernel: Loaded prism54 driver, version 1.2
Jan  1 00:00:26 OpenWrt user.warn kernel: PCI: Enabling device 
0000:00:01.0 (0000 -> 0002)
Jan  1 00:00:26 OpenWrt user.warn kernel: PCI: Fixing up device 0000:00:01.0

root@OpenWrt:/# ifconfig eth1 up
Jan  1 00:02:32 OpenWrt user.debug kernel: eth1: resetting device...
Jan  1 00:02:32 OpenWrt user.debug kernel: eth1: uploading firmware...
Jan  1 00:02:32 OpenWrt user.debug kernel: eth1: firmware version: 1.0.4.3
Jan  1 00:02:32 OpenWrt user.debug kernel: eth1: firmware upload complete
Jan  1 00:02:32 OpenWrt user.debug kernel: eth1: interface reset complete


root@OpenWrt:/# iwconfig
lo        no wireless extensions.

ethData bus error, epc == c010810c, ra == c010765c
Oops[#1]:
Cpu 0
$ 0   : 00000000 1000b800 abad0000 a1fa02e8
$ 4   : 00000001 c00f0000 00000013 00000001
$ 8   : 00000004 800fbb6c 00000000 00000000
$12   : 00000000 00000100 00000400 00000000
$16   : 818a1980 1000b801 81ee0a80 81ee0800
$20   : 00000010 00000000 a1fa0000 ff02000d
$24   : 00000000 2abd45f0
$28   : 81c7c000 81c7dce8 00000000 c010765c
Hi    : 000002fc
Lo    : 00035866
epc   : c010810c     Not tainted
ra    : c010765c Status: 1000b803    KERNEL EXL IE
Cause : 0000001c
PrId  : 00029007
Modules linked in: sch_red sch_sfq sch_hfsc cls_fw prism54 
ip_conntrack_tftp ip_nat_irc ip_conntrack_irc ip_nat_ftp 
ip_conntrack_ftp ipt_TTL ipt_ttl ipt_TOS ipt_time ipt_tos xt_MARK 
xt_mark xt_mac xt_length ipt_ECN ipt_ecn xt_CLASSIFY imq ipt_IMQ 
ipt_layer7 ipt_ipp2p xt_NOTRACK iptable_raw xt_portscan xt_DELUDE 
xt_string ipt_recent ipt_owner ipt_LOG xt_helper xt_CONNMARK xt_connmark 
tun ppp_async ppp_generic slhc crc_ccitt nfs lockd sunrpc switch_robo 
switch_core diag
Process iwconfig (pid: 2228, threadinfo=81c7c000, task=81cc15a0)
Stack : 0000000a 8034e000 812318c0 8034e000 00000000 81cc15a0 8003d39c 
81ee0e30
         81ee0e30 8002f260 00000004 00000000 00000000 801f79ac 7fd95178 
0000008a
         ff02000d 81ee0a80 81c7dd98 c0110aa8 812318c0 8034e000 00000000 
812318c0
         00000004 81c7dd50 00000000 8002a7fc 81c7de70 81c7de70 81c7de60 
801f79ac
         7fd95178 7fd951f8 81c7de60 00008b01 81ee0800 c010b5b8 80001e30 
00000005
         ...
Call 
Trace:[<8003d39c>][<8002f260>][<c0110aa8>][<8002a7fc>][<c010b5b8>][<80001e30>][<800039a0>][<c010b53c>][<80166258>][<800fbb5c>][<c010b53c>][<80166794>][<8011e3f8>][<80157fe0>][<8001f2c8>][<80112914>][<801128f4>][<8008282c>][<80082b48>][<80073db0>][<8007136c>][<80082bc8>][<800617e0>][<80061710>][<8000cdc0>][<8000cdc0>]

Code: 10800014  24020002  3c02abad <8ca30010> 3442face  1462000f 
24020008  08042050  00000000
0      no wireless extensions.

eth0.0    no wireless extensions.

eth0.1    no wireless extensions.

imq0      no wireless extensions.

imq1      no wireless extensions.

Segmentation fault



And another one:

root@OpenWrt:/# iwconfig
lo        no wireless extensions.

ethData bus error, epc == c0108158, ra == c010765c
Oops[#1]:
Cpu 0
$ 0   : 00000000 1000b800 00000008 90004000
$ 4   : 00000001 c00f0000 00000013 00000001
$ 8   : 00000004 800fbb6c 00000000 00000000
$12   : 00000000 00000100 00000400 00000000
$16   : 81289980 1000b801 81f0ca80 81f0c800
$20   : 00000010 00000000 a1860000 ff02000d
$24   : 00000000 2abd45f0
$28   : 81dbc000 81dbdce8 00000000 c010765c
Hi    : 000002fc
Lo    : 00035866
epc   : c0108158     Not tainted
ra    : c010765c Status: 1000b803    KERNEL EXL IE
Cause : 8000081c
PrId  : 00029007
Modules linked in: sch_red sch_sfq sch_hfsc cls_fw prism54 
ip_conntrack_tftp ip_nat_irc ip_conntrack_irc ip_nat_ftp 
ip_conntrack_ftp ipt_TTL ipt_ttl ipt_TOS ipt_time ipt_tos xt_MARK 
xt_mark xt_mac xt_length ipt_ECN ipt_ecn xt_CLASSIFY imq ipt_IMQ 
ipt_layer7 ipt_ipp2p xt_NOTRACK iptable_raw xt_portscan xt_DELUDE 
xt_string ipt_recent ipt_owner ipt_LOG xt_helper xt_CONNMARK xt_connmark 
tun ppp_async ppp_generic slhc crc_ccitt nfs lockd sunrpc switch_robo 
switch_core diag
Process iwconfig (pid: 2223, threadinfo=81dbc000, task=81cdd188)
Stack : 00000000 8002a720 8034e019 00000019 00000000 81cdd188 8003d39c 
81f0ce30
         81f0ce30 8002a7fc 00000004 00000000 00000000 801f79ac 7fab8178 
0000008a
         ff02000d 81f0ca80 81dbdd98 c0110aa8 80001e58 81dbdea8 8196b000 
00000001
         00000004 81dbdd50 00000000 800039a0 81dbde70 81dbde70 81dbde60 
801f79ac
         7fab8178 7fab81f8 81dbde60 00008b01 81f0c800 c010b5b8 8026fb10 
00000005
         ...
Call 
Trace:[<8002a720>][<8003d39c>][<8002a7fc>][<c0110aa8>][<80001e58>][<800039a0>][<c010b5b8>][<c010b53c>][<80166258>][<80120964>][<80074ec4>][<c010b53c>][<80166794>][<8005d680>][<80093d58>][<8007d814>][<8011e3f8>][<80157fe0>][<8001f2c8>][<80112914>][<801128f4>][<8008282c>][<80082b48>][<80073db0>][<8002a7fc>][<80082bc8>][<800617e0>][<80061710>][<8000cdc0>][<8000cdc0>]

Code: 3c0300a3  24020008  aca20000 <03e00008> 8ca20018  ac850020 
3c0300a3  3c058026  8c820018
0      no wireleData bus error, epc == c010e6e8, ra == 800490b8
Oops[#2]:
Cpu 0
$ 0   : 00000000 10009801 00000001 00010000
$ 4   : c00f0000 81f0ca80 00000140 00000000
$ 8   : ffffffff ffffffff 00000001 00000001
$12   : ffffbbd3 00000103 8022b38c 10009001
$16   : 81802200 00000000 00000000 00000005
$20   : 00000010 00000000 a1860000 ff02000d
$24   : 81dbdaac ffffffff
$28   : 81dbc000 81dbda98 00000000 800490b8
Hi    : 00000002
Lo    : 00000000
epc   : c010e6e8     Not tainted
ra    : 800490b8 Status: 10009803    KERNEL EXL IE
Cause : 0000201c
PrId  : 00029007
Modules linked in: sch_red sch_sfq sch_hfsc cls_fw prism54 
ip_conntrack_tftp ip_nat_irc ip_conntrack_irc ip_nat_ftp 
ip_conntrack_ftp ipt_TTL ipt_ttl ipt_TOS ipt_time ipt_tos xt_MARK 
xt_mark xt_mac xt_length ipt_ECN ipt_ecn xt_CLASSIFY imq ipt_IMQ 
ipt_layer7 ipt_ipp2p xt_NOTRACK iptable_raw xt_portscan xt_DELUDE 
xt_string ipt_recent ipt_owner ipt_LOG xt_helper xt_CONNMARK xt_connmark 
tun ppp_async ppp_generic slhc crc_ccitt nfs lockd sunrpc switch_robo 
switch_core diag
Process iwconfig (pid: 2223, threadinfo=81dbc000, task=81cdd188)
Stack : 00000060 00000000 5e3da035 ffffbbd3 00000001 80266544 81802200 
00000000
         00000000 800490b8 802340c0 802cd980 00000000 8002a720 80234140 
81802200
         00000005 00000004 800491d4 81dbdc38 10009800 8002a7fc 0000202f 
8002418c
         0000a800 81dbdc38 81dbdc38 8000549c 00002030 1000b800 fffff7e8 
80023d04
         80001e80 80024d68 00000400 80210b54 00002030 80220000 00000000 
800039a0
         ...
Call 
Trace:[<800490b8>][<8002a720>][<800491d4>][<8002a7fc>][<8002418c>][<8000549c>][<80023d04>][<80001e80>][<80024d68>][<800039a0>][<800faf78>][<8000aa28>][<8000aa40>][<c010815c>][<8000ad3c>][<8000ac78>][<c0108158>][<c010765c>][<800039a8>][<8008b61c>][<800fbb6c>][<c010765c>][<800490b8>][<c0108158>][<8002a720>][<8003d39c>][<8002a7fc>][<c0110aa8>][<80001e58>][<800039a0>][<c010b5b8>][<c010b53c>][<80166258>][<80120964>][<80074ec4>][<c010b53c>][<80166794>][<8005d680>][<80093d58>][<8007d814>][<8011e3f8>][<80157fe0>][<8001f2c8>][<80112914>][<801128f4>][<8008282c>][<80082b48>][<80073db0>][<8002a7fc>][<80082bc8>][<800617e0>][<80061710>][<8000cdc0>][<8000cdc0>]

Code: 8ca40170  24020001  afa20010 <8c820078> 00a08021  30420200 
1440009d  8cb10180  8c820010
ss extensions.
Kernel panic - not syncing: Fatal exception in interrupt

eth0.0    no w ireless extensio<0>Rebooting in 3 seconds..ns.

eth0.1    no wireless extensions.

imq0      no wireless extensions.

imq1      no wireless extensions.

<1>Please stand by while rebooting the system...


http://pastebin.ca/534295
