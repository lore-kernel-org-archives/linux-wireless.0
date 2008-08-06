Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx03.syneticon.net ([87.79.32.166]:3232 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756580AbYHFUFI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Aug 2008 16:05:08 -0400
Message-ID: <489A03E7.60800@wpkg.org> (sfid-20080806_220515_851086_2408439D)
Date: Wed, 06 Aug 2008 22:04:55 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
MIME-Version: 1.0
To: Chr <chunkeey@web.de>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	OpenWrt Development List <openwrt-devel@lists.openwrt.org>
Subject: Re: kernel panic on p54pci insertion on mipsel
References: <4898B018.5050202@wpkg.org> <43e72e890808051619u4ed7c447wd80a866192220b84@mail.gmail.com> <4899F540.8050409@wpkg.org> <200808062150.01765.chunkeey@web.de>
In-Reply-To: <200808062150.01765.chunkeey@web.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chr schrieb:
> On Wednesday 06 August 2008 21:02:24 Tomasz Chmielewski wrote:
>> Luis R. Rodriguez schrieb:
>>
>> (...)
>>
>>>> - doesn't work with prism54.ko module (similar messages to
>>>> http://marc.info/?l=linux-wireless&m=120250829717134&w=2)
>>> We need more details, or do you get *exactly* the same error messages?
>>>
>>> "Out of memory, cannot handle oid" comes up after a failed kmalloc()
>>> while trying to handle an interrupt and management frame (not 802.11
>>> frame) from the firmware. From that archived mailing list though the
>>> oid 0x080002ff is mentioned and... well prism54 doesn't know what that
>>> is. I wonder if the firmware is triggering random interrupts with
>>> bogus oids.
>>>
>>> If you can provide a complete log it can help. Also in your previous
>>> posts I see you mentioned you were working with different firmwares.
>>> 1.0.4.3.arm should *only* be used with prism54. You may also want to
>>> try an older firmware version than 1.0.4.3.arm, this one came from
>>> 3com cards.
>> Is older firmware available anywhere online?
> you can get lots of fullmac & softmac firmwares right here:
> http://daemonizer.de/prism54/prism54-fw/

I get "Out of memory, cannot handle oid" with all 1.x.x.x firmware and 
prism54 module.
I was renaming 1.x.x.x to isl3890, loading module, ifconfig up, removing module - from the highest 1.x.x.x version down to 0.8.0.0, which made the kernel panic after these series of rmmods, modprobes and ifconfigs. The panic can be reproduced if you do these ifconfig up series several times in a row.

# ifconfig eth2 up
Data bus error, epc == c0071834, ra == 8004cc30
Oops[#1]:
Cpu 0
$ 0   : 00000000 10009800 00000001 00000001
$ 4   : c0054000 80de8b60 ffffffff 00000000
$ 8   : 1000d800 1000001f 802e0000 802f0000
$12   : 802e0000 00000006 802e4588 81c3d508
$16   : 81d69880 00000080 00000001 00000006
$20   : 00000000 c0054078 00000001 7fc25828
$24   : 00000001 2abb4fb0
$28   : 80de0000 80de1c50 7fc258bc 8004cc30
Hi    : 00020200
Lo    : 05858000
epc   : c0071834     Not tainted
ra    : 8004cc30 Status: 10009803    KERNEL EXL IE
Cause : 0080401c
PrId  : 00029006 (Broadcom BCM3302)
Modules linked in: prism54 [last unloaded: prism54]
Process ifconfig (pid: 1329, threadinfo=80de0000, task=81edb998)
Stack : 8018405c 81c02805 00000001 802e4558 00000001 8001d2bc 81d69880 00000080
        00000001 8004cc30 802a1a90 00000006 80de8b60 80de8800 802a1a90 00000006
        80de8b60 80de8800 8004e0dc 80002ca4 81d17e00 10009801 00000000 8001c310
        00004000 c0054000 80001e54 1000d800 00000400 00000000 0000468c 802a0000
        00000000 80002ca4 00000001 7fc25828 80125850 00000006 802e4df4 00000000
        ...
Call Trace:[<8018405c>][<8001d2bc>][<8004cc30>][<8004e0dc>][<80002ca4>][<8001c310>][<80001e54>][<80002ca4>][<80125850>][<c0070c00>][<c0070c98>][<c007118c>]

Code: 8ca40150  24020001  afa20010 <8c820078> 00a08021  30420200  1440009f  8cb10160  8c820010
Kernel panic - not syncing: Fatal exception in interrupt


-- 
Tomasz Chmielewski
http://wpkg.org
