Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62395 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050Ab0JGHfq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 03:35:46 -0400
Received: by wyb28 with SMTP id 28so387062wyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 07 Oct 2010 00:35:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201010071606.37134.br1@einfach.org>
References: <20101005095510.3083.46174.stgit@tt-desk> <201010071003.37599.br1@einfach.org>
 <AANLkTimf=f1DhP68=aHZ7WKVCN9RPBq7sh+46ExnYRVa@mail.gmail.com> <201010071606.37134.br1@einfach.org>
From: Jonathan Guerin <jonathan@guerin.id.au>
Date: Thu, 7 Oct 2010 17:35:23 +1000
Message-ID: <AANLkTimChFrsQsW2BbM43gT5pLD8Kcg_59WUpRfhmZLT@mail.gmail.com>
Subject: Re: [PATCH 4/5] nl80211/mac80211: Add channel utilization to survey
To: Bruno Randolf <br1@einfach.org>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>, linville@tuxdriver.com,
	nbd@openwrt.org, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, adrian@freebsd.org,
	vasanth@atheros.com, "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 7, 2010 at 5:06 PM, Bruno Randolf <br1@einfach.org> wrote:
> On Thu October 7 2010 15:51:49 Helmut Schaa wrote:
>> On Thu, Oct 7, 2010 at 3:03 AM, Bruno Randolf <br1@einfach.org> wrote:
>> > On Wed October 6 2010 18:54:37 Helmut Schaa wrote:
>> >> On Tue, Oct 5, 2010 at 11:55 AM, Bruno Randolf <br1@einfach.org> wrote:
>> >> > This adds three new values to the survey results:
>> >> >
>> >> >  * BUSY - percentage of time the channel was busy
>> >> >  * BUSY_TX - percentage of time spent transmitting frames
>> >> >  * BUSY_RX - percentage of time spent receiving frames
>> >>
>> >> Does BUSY include BUSY_RX and BUSY_TX already? At least on
>> >> rt2800 devices we only have access to BUSY which already includes
>> >> BUSY_RX and TX.
>> >
>> > yes, BUSY includes TX and RX.
>> >
>> >> And what about BUSY on the secondary channel in case of 40Mhz?
>> >
>> > i have no information about that. luis?
>>
>> At least we've got a register for that in rt2800 ;)
>> That's why I'm asking.
>
> which units do you have for the busy time? what about other drivers?
>
> in ath[59]k we have it as cycles (which is about 1/44000 of a second,
> depending on the mode). so it counts up rather fast.
>
> i have been thinking more about it and i think my current approach is flawed.
> the idea was that we probably need to use a percentage as the least common
> denominator between all drivers, and i wanted to leave the time period up to
> userspace. so if userspace wants to have the percentage in the last second, it
> would poll every second, if it wants it every 100ms it would poll every 100ms.
> that would work, if there is only one userspace process querying this in
> regular intervals.
>
> but what if there is a second process who does the same, or a user issues "iw
> wlan0 survey dump", that would reduce the timespan for the other process... so
> that is obviously flawed...
>
> some absolute cumulative value would be better, so several userspace processes
> can poll and do their own averaging or percentage calculations.
>
> but which units to use? what would be a good way of solving that?
> any ideas???

My 2c:
I do something similar with my work. I output the amount of time in tx
& rx, as well as the 'measurement' time, being the elapsed time since
it was read last (all in ms). If you get a timer to go off
periodically (either ANI doing it, or something else if ANI is
disabled), then the user can calculate the % if required, based on the
elapsed time. Having a unit in ms seems to make the most sense as it
will be driver/clock agnostic, and easily match up to frame txtimes if
you wanted to de-construct the value further.

>
> bruno
>


--
Jonathan Guerin
