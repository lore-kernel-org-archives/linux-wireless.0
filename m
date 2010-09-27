Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:60972 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755640Ab0I0TNW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 15:13:22 -0400
Received: by gwj17 with SMTP id 17so1615580gwj.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 12:13:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1285614631.4043.29.camel@jlt3.sipsolutions.net>
References: <1285266471.3770.384.camel@jlt3.sipsolutions.net>
 <AANLkTi=3GraBb9hTrieCNvCB0o3PXGORkW1b7F2PceK3@mail.gmail.com>
 <1285611630.4043.26.camel@jlt3.sipsolutions.net> <AANLkTin+1-_RA8fY8B5-omQi3kMJ3U0iw8Kdg=FC2rnP@mail.gmail.com>
 <1285613669.4043.27.camel@jlt3.sipsolutions.net> <AANLkTimmZZiMbtA-8m69grwV_v95KcGKRQi6=-fz0JuT@mail.gmail.com>
 <1285614371.4043.28.camel@jlt3.sipsolutions.net> <AANLkTikcqU3kMCELc9QadC0JOA2ic1=Mw+X34kOus4VL@mail.gmail.com>
 <1285614631.4043.29.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 27 Sep 2010 12:12:54 -0700
Message-ID: <AANLkTimMzR2LoH0Qxqi-VH=o15vERFSTZSBbMbDGvv8Q@mail.gmail.com>
Subject: Re: [RFC] mac80211: fix release_reorder_timeout in scan
To: Johannes Berg <johannes@sipsolutions.net>,
	Matt Smith <Matt.Smith@atheros.com>,
	Srinivasa Duvvuri <Srinivasa.Duvvuri@atheros.com>
Cc: wireless <linux-wireless@vger.kernel.org>, Jouni Malinen <j@w1.fi>,
	Christian Lamparter <chunkeey@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 27, 2010 at 12:10 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2010-09-27 at 12:09 -0700, Luis R. Rodriguez wrote:
>> On Mon, Sep 27, 2010 at 12:06 PM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > On Mon, 2010-09-27 at 12:03 -0700, Luis R. Rodriguez wrote:
>> >
>> >> > We put them into the reorder buffer, but if we get a reorder timeout
>> >> > while scanning we'll drop the frames which isn't necessary.
>> >>
>> >> Ah, got it, thanks, good catch. Guess its not a terrible stable fix,
>> >> but at least important for those who care about VoIP and such.
>> >
>> > You wouldn't typically use aggregation on VO traffic, I think?
>>
>> ath9k uses aggregation for all data traffic.
>
> But it can only control TX :)

True

> Which is, of course, relevant if it's used
> as an AP,

True

> but for typical VO traffic I would argue that using
> aggregation is a bug since it'll just increase delays & jitter.

This deviates from subject a little but while at it, I am curious,
Matt, Srini, what do you think?

  Luis
