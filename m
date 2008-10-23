Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:45435 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbYJWSb6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2008 14:31:58 -0400
Received: by qw-out-2122.google.com with SMTP id 3so216848qwe.37
        for <linux-wireless@vger.kernel.org>; Thu, 23 Oct 2008 11:31:57 -0700 (PDT)
Message-ID: <1ba2fa240810231131l9c9597au2acf166a13a8c03b@mail.gmail.com> (sfid-20081023_203204_167748_8F303F01)
Date: Thu, 23 Oct 2008 20:31:56 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [RFC] mac80211: Re-enable aggregation
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	Sujith <Sujith.Manoharan@atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis Rodriguez" <Luis.Rodriguez@atheros.com>
In-Reply-To: <43e72e890810231023q5650184r8ce50cb51b63e706@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <18684.16351.638713.791015@gargle.gargle.HOWL>
	 <18684.20459.335157.171344@gargle.gargle.HOWL>
	 <1224495531.18024.55.camel@johannes.berg>
	 <18684.24323.743610.871307@gargle.gargle.HOWL>
	 <1224505349.27899.17.camel@johannes.berg>
	 <18684.51206.771543.514682@localhost.localdomain>
	 <1224669612.28639.49.camel@johannes.berg>
	 <18688.17545.136327.991699@gargle.gargle.HOWL>
	 <1224773124.6002.32.camel@johannes.berg>
	 <43e72e890810231023q5650184r8ce50cb51b63e706@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 23, 2008 at 7:23 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Thu, Oct 23, 2008 at 7:45 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> On Thu, 2008-10-23 at 15:01 +0530, Sujith wrote:
>>> Johannes Berg wrote:
>>> > It seems that should be a rate control decision? Possibly taking into
>>> > account more than just always doing aggregation sessions. Then again, I
>>> > suppose aggregation sessions are cheap. What about latency here?
>>> >
>>>
>>> Well, that is what Luis seems to think too, but our RC
>>> doesn't do much now, so we try to setup an aggregation session with any
>>> associated STA.
>>
>> If that was done in the RC at least (could easily be moved I suppose)
>> and you cleaned up the RC, then surely nbd would play with porting
>> minstrel and making it aware of such things, which probably makes for a
>> better RC... And since you have to clean up the RC anyway :)
>
> I checked internally to verify where you would decide when to AMPDU
> and to try to get different reviews and opinions, and it seems that
> the path we take right now is correct as there is not much overhead so
> we always use AMPDU with whoever supports it with data frames. If
> you're a STA you do it all the time with the AP for data frames.
>
> I noticed iwlagn had some more logic within the RC but I gave up
> trying to follow the logic. I suspect they do the same though, Tomas?

I got different output from our system engineering. APMDU has overhead
and if there is not requirement
for high throughput we don't initiate one. What is for sure we shounld
not have aggregation enabled for VO AC.
I've payed attention that there are different APs do that differently
some opens BA session on BE AC immediately upon association some do it
on high throughput I haven't seen in the second case it will be opened
on simple ping.
Anyhow if we would implement the triggering on throughput  simply
setting starting and stopping thresholds to small values will have
same effect as your solution and setting it to 0 and maximum will
respectively will have effect on  opening BA session upon association.

Tomas
