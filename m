Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from will39.synserver.de ([212.40.172.10]:56364 "EHLO
	will39.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbXKVVzm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2007 16:55:42 -0500
Message-ID: <4745EE3E.8090601@willies.info> (sfid-20071122_215554_426174_1585897D)
Date: Thu, 22 Nov 2007 22:01:50 +0100
From: Jan Willies <jan@willies.info>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: jean-baptiste.note@m4x.org, developers@islsm.org,
	linux-wireless@vger.kernel.org, kyle@mcmartin.ca
Subject: Re: [Developers] ISL3880IK crashes with 2.6.19.1 / .21.1
References: <46631BD2.20704@willies.info>	 <3871229b0706031323w5c8e3589r973b8735ed3e1f85@mail.gmail.com>	 <466341AF.7050505@willies.info>	 <43e72e890711211703p799a18f0qc8636f27cf17bb91@mail.gmail.com> <43e72e890711211713y1678bc9blf75e45dae4d74b8@mail.gmail.com>
In-Reply-To: <43e72e890711211713y1678bc9blf75e45dae4d74b8@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> On Nov 21, 2007 8:03 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> On Jun 3, 2007 5:33 PM, Jan Willies <jan@willies.info> wrote:
>>> Jean-Baptiste Note schrieb:
>>>> Hi,
>>>>
>>>> Any chance you could decode the oops ? If you're recompiling the
>>>> kernel yourself, include symbols (can't remember the option name), or
>>>> run ksymoops...
>>> I recompiled the kernel with KALLSYMS and got this:
>>>
>>> root@OpenWrt:/# iwconfig
>>> lo        no wireless extensions.
>>>
>>> ethData bus error, epc == c007e16c, ra == c007d6c0
>>> Oops[#1]:
>>> Cpu 0
>>> $ 0   : 00000000 1000b800 abad0000 00000032
>>> $ 4   : 00000001 c0068000 00000013 00000001
>>> $ 8   : 00000004 800feb8c 00000000 00000000
>>> $12   : 00000000 00000000 8124ca40 00000000
>>> $16   : 812a7800 000000fa 81361320 81361000
>>> $20   : 00000010 00000000 a1cc0000 00000019
>>> $24   : 00000000 2abd45f0
>>> $28   : 813d6000 813d7ce8 ff02000d c007d6c0
>>> Hi    : 000002fc
>>> Lo    : 00035866
>>> epc   : c007e16c isl38xx_trigger_device+0xc/0x60 [prism54]     Not tainted
>>> ra    : c007d6c0 islpci_mgt_transaction+0x380/0x614 [prism54]
>>> Status: 1000b803    KERNEL EXL IE
>>> Cause : 0000001c
>>> PrId  : 00029007
>>> Modules linked in: prism54 switch_robo switch_core diag
>>> Process iwconfig (pid: 1411, threadinfo=813d6000, task=8106f3f8)
>>> Stack : 81108800 8001e418 00000060 00000000 00000000 8106f3f8 8003bf54
>>> 813616b0
>>>          813616b0 80029ab0 00000004 00000000 00000000 80200ddc 0000008a
>>> ff02000d
>>>          81361320 813d7d98 81361000 c0086cd0 1000b800 00000000 1000b800
>>> 8002964c
>>>          00000004 813d7d50 00000000 81271d04 813d7e70 813d7e70 813d7e60
>>> 80200ddc
>>>          7fcad438 7fcad478 813d7e60 00008b01 c0081628 00000101 00000001
>>> 00000000
>>>          ...
>>> Call Trace:
>>> [<c007e16c>] isl38xx_trigger_device+0xc/0x60 [prism54]
>>> [<c007d6c0>] islpci_mgt_transaction+0x380/0x614 [prism54]
>>> [<c0086cd0>] mgt_get_request+0x100/0x2ec [prism54]
>>> [<c0081628>] prism54_set_mac_address+0x1a0/0xfd8 [prism54]
>> Sorry for the late reply ;) but anyway, I tried looking into this
>> finally (with new found knowledge on this subject, thanks to Kyle) and
>> I cannot see a place where isl38xx_trigger_device() would trigger
>> unaligned access.

Heh, wasn't expecting an answer anymore :)

>> Is this issue still present? If so I'd like to get to the bottom of
>> it. FYI p54 is there as a replacement but as you may know certain
>> features (ad-hoc, ap support, encryption) are still not present in
>> that driver.

Yep, I packaged p54 for OpenWrt and it's working for me. Well, I just 
tried a scan and some APs showed up. But there was no segfaulting.

Hmmz, I wasn't aware that p54 doesn't support encryption or AP mode yet. 
Is there any website/blog or something apart from linvilles commit log 
where I can read about its progress?

Funny thing is, I had a chat with Michael Wu because p54 was segfaulting 
for me. Turned out that I was missing some crypto modules, which are 
only needed for encryption I guess. Therefore I assumed encryption is 
working.

> Actually I've been informed this is not unaligned access problem but
> instead it occurs on do_be() or ip22_be_interrupt() on MIPS. I'll have
> to check how that works, I do not yet understand how this is reached.

I will try a new build with prism54 in the next days and let you know if 
that issue is still present.


- Jan
