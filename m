Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:45559 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbaAOGwS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jan 2014 01:52:18 -0500
Received: by mail-bk0-f52.google.com with SMTP id d7so572219bkh.11
        for <linux-wireless@vger.kernel.org>; Tue, 14 Jan 2014 22:52:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1389716461.32635.15.camel@jlt4.sipsolutions.net>
References: <1389194818-7864-1-git-send-email-michal.kazior@tieto.com>
	<1389194818-7864-5-git-send-email-michal.kazior@tieto.com>
	<1389716461.32635.15.camel@jlt4.sipsolutions.net>
Date: Wed, 15 Jan 2014 07:52:16 +0100
Message-ID: <CA+BoTQmrFARTcupjCFuz6V=c7fHHgiSurbCfnr79En=LozftFg@mail.gmail.com> (sfid-20140115_075221_823996_6DBB54C4)
Subject: Re: [RFC 4/4] cfg80211: implement multi-BSS CSA
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14 January 2014 17:21, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2014-01-08 at 16:26 +0100, Michal Kazior wrote:
>> This extends NL80211_CMD_CHANNEL_SWITCH by adding
>> a new attribute NL80211_ATTR_SWITCH_NEXT. The
>> attribute holds nested channel switch attributes
>> (including itself) allowing
>> multi-interface/chained CSA.
>
> That's ... creative? Interesting? I'm not sure I like that API much.
>
> OTOH, it's a neat way of reusing all the attributes that we have, etc.
>
> However, I think it'd be easier to implement on both sides of the fence
> if we structured this differently and made the "more vifs" to be a
> nested attribute with data inside each one of them.
>
> Actually, I'd suggest that in the multi-vif case all of the attributes
> should be inside the list, like this:
>
>  wiphy, chswitch=[1=[ifidx,...], 2=[ifidx,...], 3=[ifidx,...]]
>
> alternatively, maybe something that would be nice would be
>
>  wiphy, chswitch=[ifidx1=[...], ifidx2=[...], ifidx3=[...]]
>
> but the common way would be to ignore the array index completely.

So you're basically saying the new attribute should be used as an
array attribute instead. Sounds good, but..

What about backward compatibility? Do we not care? Or should we
preserve old parsing for single-interface CSA (i.e. older hostapd)?



> Today you get
>
>  wiphy, ifidx, ..., next=[ifidx, ..., next=[ifidx, ..., next=[...]]]
>
> and I don't really like the deep nesting.
>
> I would also argue that doing
>  wiphy, ifidx1, ..., more=[1=[ifidx2, ...], ...]
> or
>  wiphy, ifidx1, ..., next=[...]
>
> is more error prone as it would allow older kernels to parse the whole
> thing while ignoring the next/more/whatever, so you'd get some weird
> subset of the intended behaviour. Forcing *all* interfaces into the
> sub-attribute when more than one is desired (or in fact for a single
> one, if you're ok with requiring a kernel with support) would IMHO be
> less error prone.

>From a practical point of view cfg80211 should deny such a request due
to multi-channel (interface combination) and by (the only CSA
implementator in upstream) mac80211 due to chanctx->refcount > 1.


> Haven't looked over the code in much detail, but a few small comments:
>  * I think you should preserve tracing, it has facilities for arrays too

I didn't want to bother with that for the recursively nested structure
for the initial implementation.


>  * hard-coding a limit of 8 vifs seems pointless, you can easily
> allocate dynamic
>    memory, no?

I wanted to avoid that for the initial implementation.


Also, there's a locking bug in this patch - wdev_lock shouldn't be
taken by the channel_switch in nl80211. The lock should be taken by
the callee for each interface it processes later on.


Michal
