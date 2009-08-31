Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:50231 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbZHaVh6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2009 17:37:58 -0400
Received: by bwz19 with SMTP id 19so3090177bwz.37
        for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2009 14:37:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A9C25AE.9020109@gmx.de>
References: <1789900589@web.de> <4A9C25AE.9020109@gmx.de>
Date: Mon, 31 Aug 2009 23:37:59 +0200
Message-ID: <22ee4e770908311437y4954a79eje48976a0203f1806@mail.gmail.com>
Subject: Re: [PATCH] ar9170: added phy register initialisation from eeprom
	values
From: Christian Lamparter <chunkeey@googlemail.com>
To: Joerg Albert <jal2@gmx.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(changed cc', web.de finally pissed me off with a 500 mail quota)

2009/8/31 Joerg Albert <jal2@gmx.de>:
> On 08/31/2009 11:53 AM, Chunkeey@web.de wrote:
>> ...
>> See Documentation/CodingStyle - Chapter 8
>>
>> The preferred style for long (multi-line) comments is:
>> /*
>>  * look up a certain register in ar5416_phy_init[] and return the init. value
>>  * for the band and bandwidth given. Return 0 if register address not found.
>>  */
>> ...
>
> Thanks for the comments. I agree with all of them and will re-spin a patch.
Great!

>> It's amazing how much **** you can _cut_ from the vendor driver.
>
> Yes, at first sight it looks really complex but it isn't.
well, there's still a thing... we can only copy what's there in driver,
But since the two-stage fw is capable of reinitializing
the rf/phy we could do all sorts of stuff without breaking it.


>> BTW: does this patch help the 1-stage fw stability, or is it still broken?
>
> Turned out I had a corrupt firmware file. After downloading from Luis' URL it works fine
> with my WNDA3100. Guess I had an earlier version from before 2009/05/28 or firefox
> corrupted it during download.
>
> What's your setup to get 80+ MBit/s throughput with the two-stage firmware?
simply another 11n card a few meters away (but in the same room of course,
since the 5GHz band doesn't like to go through concrete)

I tested a few configurations and only with a rt2860pci was able to get a
satisfying result over a small distance (7 m, but still in the same room ;) )
Other cards: like the ar5416 also worked, but not that well (tx rates halved)
and iwl4965, iwl5300 didn't work at all in n. (but they're flying with 11a)

> I've used an 802.11g AP so far, but have access to an 802.11n dual-band AP now.
> Guess I should use 5GHz as 2.4 is rather crowded here.
> How can I put ar9170 into 802.11n/40MHz mode?

well you need a patch which lets you use the MCS rates and
kicks off BlockAck sessions. I posted a version some time
ago, (AFAIK initial RFC?). However due to fact that the code belongs
into the rc-algorithm and the lack of "out-house testing" feedback,
I had to drop it. I can send you an _updated_ (well, it should apply without
fuzz... but you still have to select the MCS by hand) version if you want,
however not until Friday. Of course, If you have free time on your hand,
you could do the fix-ups by yourself and start the madNess right on! ;-)

(Note: Felix is looking into minstrel/HT. I expect once the code is
available, that we only have to patch ar9170 just a _little_ bit to get
it _sort of_ working.
(it might never probably work with the current available firmwares,
since the BA tx_status is totally bogus)

Regards,
    Chr
