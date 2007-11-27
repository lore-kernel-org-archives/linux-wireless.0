Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from will39.synserver.de ([212.40.172.10]:54913 "EHLO
	will39.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbXK0B0A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 20:26:00 -0500
Message-ID: <474B6ADE.7020808@gmail.com> (sfid-20071127_012605_534584_EA370EEC)
Date: Tue, 27 Nov 2007 01:54:54 +0100
From: loswillios <loswillios@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: kyle@mcmartin.ca, linux-wireless@vger.kernel.org,
	developers@islsm.org
Subject: Re: [Developers] ISL3880IK crashes with 2.6.19.1 / .21.1
References: <46631BD2.20704@willies.info>		<3871229b0706031323w5c8e3589r973b8735ed3e1f85@mail.gmail.com>		<466341AF.7050505@willies.info>		<43e72e890711211703p799a18f0qc8636f27cf17bb91@mail.gmail.com>	<43e72e890711211713y1678bc9blf75e45dae4d74b8@mail.gmail.com> <4745EE3E.8090601@willies.info>
In-Reply-To: <4745EE3E.8090601@willies.info>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jan Willies wrote:
> Luis R. Rodriguez wrote:
>> Actually I've been informed this is not unaligned access problem but
>> instead it occurs on do_be() or ip22_be_interrupt() on MIPS. I'll have
>> to check how that works, I do not yet understand how this is reached.
> 
> I will try a new build with prism54 in the next days and let you know if 
> that issue is still present.

Still the same problem with 2.6.23.1:

root@OpenWrt:/# ifconfig eth1 up
eth1: resetting device...
eth1: uploading firmware...
eth1: firmware version: 1.0.4.3
eth1: firmware upload complete
eth1: interface reset complete

root@OpenWrt:/# iwlist eth1 scanning
Data bus error, epc == c011518c, ra == c01146cc
Oops[#1]:
Cpu 0
$ 0   : 00000000 1000b800 abad0000 00000032
$ 4   : 00000001 c00c8000 00000013 00000001
$ 8   : 0000003c 80102bd4 ffffffff 81e2101c
$12   : ffffffff 00000580 2ab8af24 00000498
$16   : 81e21680 000000fa 81339380 0000004a
$20   : 81339380 00000000 a1e80000 81339000
$24   : 00000000 2abd55e0
$28   : 813b4000 813b5cc8 00000019 c01146cc
Hi    : 00000000
Lo    : 00000580
epc   : c011518c     Not tainted
ra    : c01146cc Status: 1000b803    KERNEL EXL IE
Cause : 0000001c
PrId  : 00029007
Modules linked in: prism54 ehci_hcd ohci_hcd nf_nat_tftp 
nf_conntrack_tftp nf_nat_irc nf_conntrack_irc nf_nat_ftp 
nf_conntrack_ftp ppp_async ppp_generic slhc crc_ccitt usbcore arc4 aes 
deflate ecb cbc blkcipher crypto_hash cryptomgr crypto_algapi 
switch_robo switch_core diag
Process iwlist (pid: 680, threadinfo=813b4000, task=810a10c8)
Stack : ffffff9c 2ab3549b 80074a50 7fd23300 00000000 810a10c8 8003cac4 
81339710
         81339710 8008c054 0000003e 00000000 00000000 813b5e60 00000060 
17000012
         81339380 813b5d78 00000498 c011dce0 81052920 00000000 17000012 
00000009
         0000003e 813b5d30 00000000 81052920 813b5e70 802a6000 802a6000 
813b5e60
         813b5e70 00000000 81339380 00008b0b c01187ec 00008b0b 81047360 
000080d0
         ...
Call 
Trace:[<80074a50>][<8003cac4>][<8008c054>][<c011dce0>][<c01187ec>][<c01186a4>][<801ec8ec>][<8005ecc4>][<8005ecc4>][<800cbc34>][<80118d8c>][<c01186a4>][<801ecb10>][<80060f6c>][<80164b28>][<8008d4a8>][<8008630c>][<8008661c>][<8008669c>][<8000c12c>][<80003a00>]

Code: 10800014  24020002  3c02abad <8ca30010> 3442face  1462000f 
24020008  08045470  00000000
Segmentation fault


Sometimes I even get this weird stuff:

root@OpenWrt:/# ifconfig eth1 up
eth1: resetting device...
eth1: uploading firmware...
eth1: firmware version: 1.0.4.3
eth1: firmware upload complete
eth1: no 'reset complete' IRQ seen - retrying
eth1: no 'reset complete' IRQ seen - retrying
eth1: interface reset failure
prism54: Your card/socket may be faulty, or IRQ line too busy :(
ifconfig: SIOCSIFFLAGS: Timer expired


Thanks for looking into it, much appreciated.


- Jan
