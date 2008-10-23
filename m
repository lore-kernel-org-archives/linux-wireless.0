Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:4559 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbYJWRXk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2008 13:23:40 -0400
Received: by yx-out-2324.google.com with SMTP id 8so126388yxm.1
        for <linux-wireless@vger.kernel.org>; Thu, 23 Oct 2008 10:23:38 -0700 (PDT)
Message-ID: <43e72e890810231023q5650184r8ce50cb51b63e706@mail.gmail.com> (sfid-20081023_192345_381783_7AD6A806)
Date: Thu, 23 Oct 2008 10:23:38 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC] mac80211: Re-enable aggregation
Cc: Sujith <Sujith.Manoharan@atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis Rodriguez" <Luis.Rodriguez@atheros.com>,
	"tomasw@gmail.com" <tomasw@gmail.com>,
	"Tomas Winkler" <tomas.winkler@intel.com>
In-Reply-To: <1224773124.6002.32.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <18684.16351.638713.791015@gargle.gargle.HOWL>
	 <1224493957.18024.47.camel@johannes.berg>
	 <18684.20459.335157.171344@gargle.gargle.HOWL>
	 <1224495531.18024.55.camel@johannes.berg>
	 <18684.24323.743610.871307@gargle.gargle.HOWL>
	 <1224505349.27899.17.camel@johannes.berg>
	 <18684.51206.771543.514682@localhost.localdomain>
	 <1224669612.28639.49.camel@johannes.berg>
	 <18688.17545.136327.991699@gargle.gargle.HOWL>
	 <1224773124.6002.32.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 23, 2008 at 7:45 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2008-10-23 at 15:01 +0530, Sujith wrote:
>> Johannes Berg wrote:
>> > It seems that should be a rate control decision? Possibly taking into
>> > account more than just always doing aggregation sessions. Then again, I
>> > suppose aggregation sessions are cheap. What about latency here?
>> >
>>
>> Well, that is what Luis seems to think too, but our RC
>> doesn't do much now, so we try to setup an aggregation session with any
>> associated STA.
>
> If that was done in the RC at least (could easily be moved I suppose)
> and you cleaned up the RC, then surely nbd would play with porting
> minstrel and making it aware of such things, which probably makes for a
> better RC... And since you have to clean up the RC anyway :)

I checked internally to verify where you would decide when to AMPDU
and to try to get different reviews and opinions, and it seems that
the path we take right now is correct as there is not much overhead so
we always use AMPDU with whoever supports it with data frames. If
you're a STA you do it all the time with the AP for data frames.

I noticed iwlagn had some more logic within the RC but I gave up
trying to follow the logic. I suspect they do the same though, Tomas?

  Luis
