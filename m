Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f31.google.com ([209.85.219.31]:65495 "EHLO
	mail-ew0-f31.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755935AbZAOX7a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2009 18:59:30 -0500
Received: by ewy12 with SMTP id 12so481834ewy.13
        for <linux-wireless@vger.kernel.org>; Thu, 15 Jan 2009 15:59:27 -0800 (PST)
Message-ID: <496FCDDD.7090203@gmail.com> (sfid-20090116_005936_011424_C8B95C82)
Date: Fri, 16 Jan 2009 00:59:25 +0100
From: Artur Skawina <art.08.09@gmail.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: Artur Skawina <art.08.09@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: wireless-testing, p54 and sinus 154 data no longer works
References: <494698AF.4020204@gmail.com> <200901152042.42372.chunkeey@web.de> <496F9740.5010109@gmail.com> <200901152341.02130.chunkeey@web.de>
In-Reply-To: <200901152341.02130.chunkeey@web.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> well... I'm still looking for an explanation for your other problems:
> =============================================================================
> BUG kmalloc-4096: Poison overwritten
> -----------------------------------------------------------------------------
> 
>   Object 0xddec18c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>   Object 0xddec18d0:  >69< 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b ikkkkkkkkkkkkkkk
>   Object 0xddec18e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> 
> The odd thing is here that it's only a "single" bit in the object flipped and not more!

yes, that does not look good. i didn't find anything obvious under wireless/p54
that could be responsible for it, didn't look at the rest of the stack yet.
I'd say ignore this for now, until i'm able to reproduce it; one try on a very
different machine didn't help and i didn't have a lot of time to retest after
the kernel upgrade(s) today. 

> And we all have slub/slab debug options enabled as well (in fact, we had to fix the usbdriver for that,
> see patch "p54usb: rewriting rx/tx routines to make use of usb_anchor's facilities" )
> 
> can you check your RAM with memtest or something?

yes, i just need to plan for enough downtime... 

> --------------------------
> Disconnecting/reconnecting the wireless client resulted in this:
>> mac80211-phy0: failed to remove key (0, 00:1b:fb:12:34:56) from hardware (-12)
> followed later, when killing hostapd, by:
>> mac80211-phy0: failed to remove key (1, ff:ff:ff:ff:ff:ff) from hardware (-12)
> 
> well, -12 is -ENOMEM. Well we can use GFP_KERNEL in p54_set_key so its unlikely that your "box"
> doesn't have enough space, but your p54usb device 'itself' has no more room left... and
> this is unlikely too, so it probably stalled/crashed.

Hmm, could having it plugged into a full speed usb port be relevant?
On the other computer, i tried both w/ the card connected directly (high speed)
and through a full speed hub - didn't make any difference (no crash, same
arp etc problems).

> We fixed a something like this before for the 2nd generation devices:
> http://www.spinics.net/lists/linux-wireless/msg25692.html
> 
> However, I don't know if the net2280 chip on your device needs it or not, but it should hurt if you try it.

ok, will look into it.

Thanks,

artur
