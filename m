Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.243]:48793 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772AbYE2ATv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2008 20:19:51 -0400
Received: by an-out-0708.google.com with SMTP id d40so10900and.103
        for <linux-wireless@vger.kernel.org>; Wed, 28 May 2008 17:19:50 -0700 (PDT)
Message-ID: <40f31dec0805281719p1e120c90p379887e478df61a4@mail.gmail.com> (sfid-20080529_021955_502329_F38A2D3B)
Date: Thu, 29 May 2008 03:19:48 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Richard Scherping" <richard@scherping.de>
Subject: Re: ath5k: 10 MHz channels?
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <483D9C34.2020908@scherping.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <483B181F.3010802@scherping.de>
	 <40f31dec0805280336r40b102ffx11cbd0c0d465c9f8@mail.gmail.com>
	 <483D9C34.2020908@scherping.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/5/28 Richard Scherping <richard@scherping.de>:
> Nick Kossifidis schrieb:
>
>> No work has been done for such features yet, other more important
>> things are missing right now. If you want to rev. engineer
>> half/quarter rate channels, i think you should start from nic_wakeup
>> and reset functions (also check out rx/tx descriptors for the rate
>> code). Mmiotrace is your friend ;-)
>
> Thanks very much for your reply, Nick!
>
> In fact I found the piece of code needed to get 10 MHz channels working with the Ubiquity cards today.
> I do not have the full code at hand ATM, but it was not more than adding
>
> clock |= 0x100
>
> to hw.c:ath5k_hw_nic_wakeup.
>
> madwifi-trace helped to find that single, but important bit ;-)
>

Cool stuff ;-)

Thanks a lot for finding this out, can you also try 5Mhz and see what changes ??

Could you run some iperf tests and see the difference ?
Have you verified that 10Mhz channels work between madwifi and ath5k +
your patch ?

> ath5k performance still is somewhat limited in ad-hoc mode, but I will try to work on that, too. Are there any ideas yet, that are not already implemented? I refer to the effect that a simple ping between two ath5k ad-hoc stations has only about 80 % success rate...
>

ASAP i'll post a patch to update the list of registers and fix I/Q
calibration, then we 'll be able to implement ANI (adaptive noise
immunity) which i believe will fix some
rf issues (working on it, i think i got it right based on public
available pattent docs from Atheros, search for a topic "tracing ani"
on ath5k-devel for more infos). Then we have to work on phy
initialization (rf registers etc), tx power calibration and tx power
setting (this is going to take a long time). Sorry for delaying these
patches (you can find some of my work on the latest tarballs here ->
http://www.kernel.org/pub/linux/kernel/people/mickflemm/ and work done
on tx power etc on ath_info tool, but i have more to send) it's just
that my time is very limited due to university etc and i try hard to
keep up with rev. engineering and other things.

There are many things to be done but i'm optimistic that this summer
is going to be very productive. I'm starting to be optimistic about
AR5416 (802.11n) cards too ;-)

There are also many things to do on the driver side that we are ready
to implement -hw code exist- (802.11e for example) but there is simply
NO time to work on them.

In other words: We NEED more people !

> Thanks for your great work! With the full frequency range and free choice of channelwidths ath5k is about to exceed even specially modified MadWifi versions in functionality.
>
> Richard
>

I hope we 'll have a nice floss driver for Atheros cards so anyone can
work better with them, not only as a user but also for research etc.
This hw is nice and i hope to get 100% out of it...

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
