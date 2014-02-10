Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from isrv.corpit.ru ([86.62.121.231]:53318 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752394AbaBJTQ7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Feb 2014 14:16:59 -0500
Message-ID: <52F925A9.1030707@msgid.tls.msk.ru> (sfid-20140210_201714_781873_6EB9489A)
Date: Mon, 10 Feb 2014 23:16:57 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: brcm80211-dev-list@broadcom.com, linux-wireless@vger.kernel.org
Subject: Re: BCM4313 & brcmsmac & 3.12: only semi-working?
References: <52BDE9DC.5040206@msgid.tls.msk.ru> <52BE9CF9.7030305@broadcom.com> <52BEC2F6.7010505@msgid.tls.msk.ru> <52D4FC8B.6090301@msgid.tls.msk.ru>
In-Reply-To: <52D4FC8B.6090301@msgid.tls.msk.ru>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After some more unsuccessful digging with brcmsmac driver, I thought I'd
give wl driver a try.

Unfortunately it does not work with kernels > 3.8, so I tried with 3.2.

There, wl.ko built successfully, created eth1 device on load, and wifi
apparently works fine.  I transferred a few gigs in both direction, and
the signal is very stable at 65Mbps.  It worked for several hours.

Unfortunately, kernels before 3.9 has another problem on this laptop:
it is the battery life.  3.8 and older kernels draws battery much faster
(even without wifi enabled), this laptop lasts about 4 hours on battery
with 3.2 kernel, compared to more than 7 with 3.10 kernel.  I guess it
is the new ivy bridge pstates support introduced in 3.9.

I tried compiling wl.ko for 3.10 kernel, but unfortunately it doesn't
work there (after some minor tweaking of the source - I just commented
out procfs support) -- it does not find any devices.

So it looks like brcmsmac driver has a prob/bug, while wl driver works,
but wl doesn't work with more recent kernel.

It is still better than to use a separate usb dongle.  But it'd be
really nie to see brcmsmac driver just working without the need to
decide which don you want now: battery life or wifi (I'd vote for
both :)

Thanks,

/mjt

14.01.2014 12:59, Michael Tokarev wrote:
> So, I returned from my newyear trip.  There, I tried to use this my laptop
> with many various wifi networks, in hotels, cafes and other places.  And
> it never worked.
> 
> So I bought an usb wifi adaptor, some cheap old orient model, which worked
> MUCH better than the built-in broadcom wifi. Except of 2 issues.
> 
> First, the antenna in this usb dongle is small, so signal quality isn't as
> good as for the built-in adaptor with good antenna.
> 
> And second, which is much more severe, it is an external adaptor plugged
> into an usb slot, so it isn't that easy as internal one, but it is very
> easy to BREAK the usb slot.  Which is what I did while sitting in a cafe
> and someone else walking by.  So now I've one usb port on my laptop broken
> now (with very unpleasant large crack on the laptop "body") and the usb
> wifi adaptor I bought is broken too.
> 
> I also tried to replace the internal wifi card with some non-broadcom
> model, but the laptop refused to _boot_ while the card is inserted
> (a so-called bios lock).
> 
> So the question stands: what is the way to actually use the internal
> bcm card, without all those hassles I already encountered?
> 
> So far, the expirience was that anything with broadcom inside should
> NOT be considered for a purchase, because the issues they gave you
> costs much more than a price difference for a different model without
> broadcom parts.
> 
> Thanks,
> 
> /mjt
> 
> 28.12.2013 16:24, Michael Tokarev wrote:
>> Thank you very much for the reply!
>>
>> 28.12.2013 13:42, Arend van Spriel wrote:
>>> On 12/27/2013 09:58 PM, Michael Tokarev wrote:
>>>> Hello.
>>>>
>>>> Got a Lenovo Thinkpad notebook with the following wifi card:
>>>>
>>>> 03:00.0 Network controller [0280]: Broadcom Corporation BCM4313 802.11b/g/n Wireless LAN Controller [14e4:4727] (rev 01)
>>>>     Subsystem: Broadcom Corporation Device [14e4:0608]
>>>>     Flags: bus master, fast devsel, latency 0, IRQ 17
>>>>     Memory at f1600000 (64-bit, non-prefetchable) [size=16K]
>>>>     Capabilities: [40] Power Management version 3
>>>>     Capabilities: [58] Vendor Specific Information: Len=78 <?>
>>>>     Capabilities: [48] MSI: Enable- Count=1/1 Maskable- 64bit+
>>>>     Capabilities: [d0] Express Endpoint, MSI 00
>>>>     Capabilities: [100] Advanced Error Reporting
>>>>     Capabilities: [13c] Virtual Channel
>>>>     Capabilities: [160] Device Serial Number 00-00-24-ff-ff-fe-48-d2
>>>>     Capabilities: [16c] Power Budgeting <?>
>>>>     Kernel driver in use: bcma-pci-bridge
>>
>> [wifi tx stalls after short usage, 3.12 kernel]
>>
>>>> P.S. I tried to find archives of brcm80211 list, or a way to
>>>> subscribe to it before posting, but found neither.  Are there
>>>> archives?
>>>
>>> Nope. The brcm80211-dev-list is just a (hopefully) convenient way to get
>>> your message to the brcm80211 driver developer within Broadcom. So it is
>>> always best to Cc: the linux-wireless list as well.
>>
>> Ah.  So the real archives should be for linux-wireless@ not for brcm..@ :)
>> Got it, thank you!
>>
>>> Now about your card. I am not sure where to start, but can you dump
>>> contents for following debugfs file:
>>>
>>> /sys/kernel/debug/brcmsmac/bcma*/hardware
>>
>> # cat /sys/kernel/debug/brcmsmac/bcma0\:0/hardware
>> board vendor: 14e4
>> board type: 608
>> board revision: 1109
>> board flags: 402201
>> board flags2: 884
>> firmware revision: 262032c
>>
>>> Also a capture file would be great so if you have wireshark or dumpcap you can add monitor interface and capture 802.11 packets from connect up until the stalls. Commands for adding/enabling monitor interface (ass root/sudo):
>>>
>>> # iw dev wlan0 interface add mon0 type monitor
>>> # ifconfig mon0 up
>>
>> Capture file made with tcpdump is attached (gzipped).  I started the
>> capture with wlan0 disabled, next I  used `nmcli con up id "wifi mjt"'
>> to connect to the AP (named, obviously, "mjt"), and next I tried to
>> d/load a file from my website (86.62.121.231).  It d/loaded about 27Kb
>> and stalled.  Next I tried to ping the AP (192.168.88.65), which also
>> didn't work.
>>
>> That's quite a typical behavour of this whole thing.  Sometimes it
>> lasts a bit longer, but that's rather unusual and it ends up stalling
>> anyway.
>>
>> Is it worth the effort to try 3.13-tobe kernel here?  I browsed changes
>> in there made in drivers/net/wireless/brcm80211/ compared with 3.12, but
>> there aren't many changes related to the softmac version, and most
>> looks rather cosmetic.
>>
>> Thank you very much for the help!
>>
>> /mjt
>>
> 

