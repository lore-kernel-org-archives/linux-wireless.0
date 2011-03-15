Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62036 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304Ab1COQRP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2011 12:17:15 -0400
Received: by wwa36 with SMTP id 36so935710wwa.1
        for <linux-wireless@vger.kernel.org>; Tue, 15 Mar 2011 09:17:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110315151746.421c04b3@toddler>
References: <20110224182022.57e32862@toddler>
	<20110224200203.GB17412@elie>
	<20110314164812.4c0cfc29@toddler>
	<AANLkTimSZrGCzBaB9K=WVO7faGNM-+qeKEE2qzjkPnSD@mail.gmail.com>
	<20110315131907.6f06a221@toddler>
	<AANLkTi=Gub1JAO21qtRjxVWrtc6Masp1siF3NHntgcvp@mail.gmail.com>
	<20110315151746.421c04b3@toddler>
Date: Tue, 15 Mar 2011 21:47:14 +0530
Message-ID: <AANLkTinmD3aJphAcge0xunk4sS4pec20u3PSKTE0Og6=@mail.gmail.com>
Subject: Re: Could ath9k and rt2800pci bugs be related?
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Tony Houghton <h@realh.co.uk>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 15, 2011 at 8:47 PM, Tony Houghton <h@realh.co.uk> wrote:
> On Tue, 15 Mar 2011 19:05:27 +0530
> Mohammed Shafi <shafi.wireless@gmail.com> wrote:
>
>> On Tue, Mar 15, 2011 at 6:49 PM, Tony Houghton <h@realh.co.uk> wrote:
>> > On Tue, 15 Mar 2011 13:17:40 +0530
>> > Mohammed Shafi <shafi.wireless@gmail.com> wrote:
>> >
>> >> On Mon, Mar 14, 2011 at 10:18 PM, Tony Houghton <h@realh.co.uk>
>> >> wrote:
>> >> >
>> >> > I've just bought an Acer Aspire Revo 3700 and this had very
>> >> > similar symptoms with a different adapter. Luckily another
>> >> > customer had posted about it on the vendor's website and his fix
>> >> > works for me. The fix is to blacklist the rt2800pci module and
>> >> > the rt2860sta driver seems to work quite happily without it.
>> >>
>> >> can you please check by disabling the supicious rt modules and see
>> >> whether this problems happens.
>> >
>> > Yes, I did blacklist rt2800pci and the system works correctly
>> > without the module loaded. Even the wireless connection still works.
>>
>> Ok still there is also one or two guys reporting this locking issue,
>> so we need to be very sure.
>
> I'm afraid you misunderstood me. The rt28* issue is on a different
> system with an Ralink adapter. AFAIK the actual rt28* modules have
> nothing to do with the Atheros problem. I only made a connection because
> the symptoms are so similar, and I thought it possible that the two
> different drivers might share some code, but it's more likely to be a
> coincidence.

Ok fine.

>
> Has anyone else reported the rt28* problem and/or are the developers
> aware of it? I know I'm not the only affected person because I read
> about it in a customer comment on the vendor's web site for the Acer
> R3700.

 no i am not aware of it.

>
>> >> for quick check please try with the latest compat wireless.
>> >
>> > How do I do that?
>> >
>> > I would also be willing to add extra debugging messages to ath9k to
>> > help track down the AR9285 problem. I'm a C programmer, but not a
>> > kernel hacker so I think I would need some advice about which
>> > functions to examine.
>>
>> No its nothing to do with kernel hacking, its just a wireless package.
>
> For kernel hacking I meant I would like to experiment with the code
> myself. If you can't reproduce the problem I think it would be very
> helpful if I can make it print extra messages to narrow it down. If you
> could tell me something like, "The shutdown process should start at
> function X and end at function Y," I'll know better which code to
> experiment with. BTW, all types of wireless shutdown seem to be
> affected, whether I turn off the WAP, click Disconnect in network
> manager, press the rfkill switch, suspend, shutdown or rmmod ath9k.

i dont know what to say, may be you can look at
vim /drivers/net/wireless/ath/ath9k/pci.c
and
vim /net/mac80211/pm.c
let me also see if i can get the problem reproduced

>
> Should I use printk to print the debugging messages or something else?
> As there is the debug module parameter I guess the latter. Is there also
> some sort of sleep function which I can safely add after each debug
> message to make sure the message is made visible before the crash?

printk is sufficient and if you can enable all debugs by ath9k debug=0xfffffffff
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
