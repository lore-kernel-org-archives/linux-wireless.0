Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:55372 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760265Ab0I0Wef convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 18:34:35 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 15:34:27 -0700
From: Matt Smith <Matt.Smith@Atheros.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Srinivasa Duvvuri <Srinivasa.Duvvuri@Atheros.com>,
	wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>,
	Christian Lamparter <chunkeey@googlemail.com>
Date: Mon, 27 Sep 2010 15:34:33 -0700
Subject: Re: [RFC] mac80211: fix release_reorder_timeout in scan
Message-ID: <0B26B230-4AA6-48DE-9241-F5DA6A557153@Atheros.com>
References: <1285266471.3770.384.camel@jlt3.sipsolutions.net>
 <AANLkTi=3GraBb9hTrieCNvCB0o3PXGORkW1b7F2PceK3@mail.gmail.com>
 <1285611630.4043.26.camel@jlt3.sipsolutions.net>
 <AANLkTin+1-_RA8fY8B5-omQi3kMJ3U0iw8Kdg=FC2rnP@mail.gmail.com>
 <1285613669.4043.27.camel@jlt3.sipsolutions.net>
 <AANLkTimmZZiMbtA-8m69grwV_v95KcGKRQi6=-fz0JuT@mail.gmail.com>
 <1285614371.4043.28.camel@jlt3.sipsolutions.net>
 <AANLkTikcqU3kMCELc9QadC0JOA2ic1=Mw+X34kOus4VL@mail.gmail.com>
 <1285614631.4043.29.camel@jlt3.sipsolutions.net>
 <AANLkTimMzR2LoH0Qxqi-VH=o15vERFSTZSBbMbDGvv8Q@mail.gmail.com>
In-Reply-To: <AANLkTimMzR2LoH0Qxqi-VH=o15vERFSTZSBbMbDGvv8Q@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I would not send voice data under a BA agreement.  If you have to give up on transmitting a frame, it will leave a hole at the receiver which will then require a BAR to move past.  Since you will typically only send one frame at a time, it (use of A-MPDU aggregation) doesn't buy you anything.  IIRC, there are industry certification tests that send more than one frame a second at AC_VO, however, which one needs to to pass.

Matt

On Sep 27, 2010, at 12:12 PM, Luis R. Rodriguez wrote:

> On Mon, Sep 27, 2010 at 12:10 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> On Mon, 2010-09-27 at 12:09 -0700, Luis R. Rodriguez wrote:
>>> On Mon, Sep 27, 2010 at 12:06 PM, Johannes Berg
>>> <johannes@sipsolutions.net> wrote:
>>>> On Mon, 2010-09-27 at 12:03 -0700, Luis R. Rodriguez wrote:
>>>> 
>>>>>> We put them into the reorder buffer, but if we get a reorder timeout
>>>>>> while scanning we'll drop the frames which isn't necessary.
>>>>> 
>>>>> Ah, got it, thanks, good catch. Guess its not a terrible stable fix,
>>>>> but at least important for those who care about VoIP and such.
>>>> 
>>>> You wouldn't typically use aggregation on VO traffic, I think?
>>> 
>>> ath9k uses aggregation for all data traffic.
>> 
>> But it can only control TX :)
> 
> True
> 
>> Which is, of course, relevant if it's used
>> as an AP,
> 
> True
> 
>> but for typical VO traffic I would argue that using
>> aggregation is a bug since it'll just increase delays & jitter.
> 
> This deviates from subject a little but while at it, I am curious,
> Matt, Srini, what do you think?
> 
>  Luis

