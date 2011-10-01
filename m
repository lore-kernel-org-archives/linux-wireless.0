Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34635 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062Ab1JAAwB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Sep 2011 20:52:01 -0400
Received: by ywb5 with SMTP id 5so1981979ywb.19
        for <linux-wireless@vger.kernel.org>; Fri, 30 Sep 2011 17:52:00 -0700 (PDT)
Message-ID: <4E86642D.8040601@lwfinger.net> (sfid-20111001_025215_844307_DA525A0F)
Date: Fri, 30 Sep 2011 19:51:57 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: Ian Jeffray <ian@emobix.co.uk>, linux-wireless@vger.kernel.org
Subject: Re: r8712u driver - on ARM
References: <4E81ED65.7060703@emobix.co.uk> <4E81F8C8.4010909@lwfinger.net> <4E860CDB.9040207@emobix.co.uk> <201109302106.12028.chunkeey@googlemail.com>
In-Reply-To: <201109302106.12028.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/30/2011 02:06 PM, Christian Lamparter wrote:
> On Friday 30 September 2011 20:39:23 Ian Jeffray wrote:
>> On 27/09/2011 17:24, Larry Finger wrote:
>>> On 09/27/2011 10:36 AM, Ian Jeffray wrote:
>>>> Dear all,
>>>>
>>>> I'm attempting to get some sense from a Realtek 8191S device on
>>>> ARM linux.
>> <SNIP>
>>>> My host is a TI DaVinci DM8168 (OMAP3+toys). The USB host is not
>>>> fantastic, but has been thrashed heavily with other devices and seems
>>>> to be reliable in those cases.
>> <SNIP>
>>>
>>> I have not tried this chip on an ARM host as I have no hardware. My
>>> testing has been with X86 and PPC - thus I know the endianess is OK, but
>>> that is the extent of my platform testing.
>>>
>>> The first thing I would try is wireshark on another host to verify that
>>> packets are actually getting on the air.
>>
>> Ok, so I've spent more more days working on this.  The driver appears
>> to be fine on an ARM9 S3X board.   I've contacted the TI support
>> team about the USB host and applied some patches from them which have
>> slightly improved the situation, but it's still horrible - I'm actually
>> getting "reliable" scans but only a pathetic 1Mbit or less of data
>> throughput.
>>
>> I've also tried this driver (and the realtek upstream version) with
>> a Blackfin BF527 device, which has roughly the same 'musb' Inventra
>> USB host controller... and I see exactly the same problem there!
>> The firmware appears to load fine, but scans produce no results.
>>
>> I'm not really sure about your comment about wireshark because,
>> as far as I understand, a 'iwlist wlan0 scan' command doesn't cause
>> any traffic which would be wireshark capturable on another host...
>> am I misunderstanding something?

@Ian: If iwlist scan is run as root, an active scan is done. If run as an 
unprivileged user, then a passive scan is done. With the former, we would see an 
outgoing probe packet on each channel.

>> So it appears as though there may be some general problem with this
>> driver and an 'musb' host controller.  Very strange.
>>
>> My next course of attack is to try comparing outputs of 'usbmon'
>> dumps between hosts which work and hosts which don't... but I can't
>> make a great deal of sense looking at them really.
>>
>> I'd greatly appreciate any more advice you may be able to give.
>
> Well, I'm not really in r8712u but I can tell you a few things about
> carl9170 and musb.
>
> You see I had a similar discussion a while ago:
> http://www.spinics.net/lists/linux-wireless/msg68870.html
>
> Apparently, musb can't do DMA with non 4-bytes aligned buffers
> and falls back to PIO [which results in a much higher cpu utilization
> and really bad usb throughput... so if timing is critical this "fact"
> is pretty much a deal-breaker for the combination].
>
> Now, you might ask, why this DMA vs. PIO is so importent... Well,
> it's because the network stack has its own alignment ideas and
> about the data/skbs. There's a comment in include/linux/skbuff.h
> around line 1400 which explains the situation. The upshot is you
> can choose between a penatly on the packet processing by the
> stack, or a penatly on the driver/hardware site if r8712u does
> not implement any additional techniques to counter the issues.

@Christian: Thanks for the pointer on the penalty associated with unaligned DMA 
on ARM. I'll prepare a patch to see if using the skb_reserve() call hurts x86 or 
PPC performance. If it does not, then the patch can be used for all architectures.

Larry

