Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:40946 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932607AbaEGLnD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 07:43:03 -0400
Received: by mail-wg0-f42.google.com with SMTP id y10so841437wgg.1
        for <linux-wireless@vger.kernel.org>; Wed, 07 May 2014 04:43:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1399461426.10517.16.camel@jlt4.sipsolutions.net>
References: <1396267459-9976-1-git-send-email-michal.kazior@tieto.com>
	<1397051137-26201-1-git-send-email-michal.kazior@tieto.com>
	<1397051137-26201-3-git-send-email-michal.kazior@tieto.com>
	<1399387345.4218.44.camel@jlt4.sipsolutions.net>
	<CA+BoTQ=FqfB46Bd6iC3F=Ps=b4f6CP77p5d6f4fiVLUttCYQjg@mail.gmail.com>
	<1399449912.5038.7.camel@jlt4.sipsolutions.net>
	<CA+BoTQnJ7N=UtDu_tySg8uYrQg9i+BvuYrwez7x-LUVinroWDw@mail.gmail.com>
	<1399453631.10517.10.camel@jlt4.sipsolutions.net>
	<CA+BoTQmygnk161oi=AUwfFM4U-r8TxuJVcHPMbsOG+QCzB03hQ@mail.gmail.com>
	<1399461426.10517.16.camel@jlt4.sipsolutions.net>
Date: Wed, 7 May 2014 13:43:01 +0200
Message-ID: <CA+BoTQ=uNCVZcacg32nTp2i7gu2RcZQbbe4nw5_sCBANHHTY0A@mail.gmail.com> (sfid-20140507_134309_006496_F19D474A)
Subject: Re: [PATCH v4 2/5] mac80211: use chanctx reservation for AP CSA
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luca Coelho <luca@coelho.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7 May 2014 13:17, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2014-05-07 at 11:41 +0200, Michal Kazior wrote:
>
>> > I'm not really sure how this would work though - drivers that have
>> > firmware generating beacons don't generally seem to be in a position to
>> > just stop that aspect and continue operating otherwise, with active
>> > clients and all that. It seems to me this might be really difficult to
>> > implement.
>>
>> Yeah. This seems like a problem for template drivers. But on the other
>> hand if they are capable of handling CSA IE counter they should
>> understand CSA, shouldn't they?
>
> Yeah but that doesn't mean they can simply stop beaconing for "extended"
> periods of time.

We can't really guarantee how long we'll need to stop beaconing for.

Assume: AP+STA. Start AP CSA bcn_int=100ms, cs_count=5. While CSA
progresses STA receives cs_count=100 (with bcn_int=100ms).

This is all theory and in practice you won't get cs_count that big and
the lag greater shouldn't be greater than 5 or 6 beacon intervals. Is
that an "extended" period of time? I don't know. Should we even worry
about this? I don't think so.


>> > Remind me why we're doing this - didn't you originally have something in
>> > mind that was forcing them all to be synchronized with the switch?
>>
>> No, not really.
>>
>> With per-vif CSA requests you can end up submitting requests between
>> vif TBTTs, no? Having an atomic "switch vif1,vif2,vif3 to chanX" could
>> help - although currently ieee80211_beacon_get() isn't really
>> synchronized well so you still hit the problem.
>>
>> And how do you expect to deal with multi-vif with APs with different
>> beacon intervals? Those inherently can't be tightly synchronized. The
>> same goes for AP+STA if you start AP first (with the other way around
>> you could, in theory, match STA's AP TBTT with your own).
>
> I'm not really sure all of these are cases that we need to consider
> though?
>
> Multi-BSS I totally see, but if you're trying to do that with different
> beacon intervals you're probably in a world of pain already - not sure
> we should support that to start with...

You still can have different TBTTs across your AP vifs. ath10k does
this, although it should be possible to force it to beacon in bursts.


> AP/GO-follows-STA I can also see, due to regulatory and concurrent
> BSS/P2P usage.
>
> As for those other cases, are they really relevant?

I think I lost track of the point of the discussion at some point :-)
Weren't we discussing csa_active?


Michał
