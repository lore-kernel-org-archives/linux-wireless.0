Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f44.google.com ([209.85.214.44]:33009 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbaAOJpk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jan 2014 04:45:40 -0500
Received: by mail-bk0-f44.google.com with SMTP id ej10so620656bkb.3
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jan 2014 01:45:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1389778744.4338.2.camel@jlt4.sipsolutions.net>
References: <1389194818-7864-1-git-send-email-michal.kazior@tieto.com>
	<1389194818-7864-5-git-send-email-michal.kazior@tieto.com>
	<1389716461.32635.15.camel@jlt4.sipsolutions.net>
	<CA+BoTQmrFARTcupjCFuz6V=c7fHHgiSurbCfnr79En=LozftFg@mail.gmail.com>
	<1389778744.4338.2.camel@jlt4.sipsolutions.net>
Date: Wed, 15 Jan 2014 10:45:38 +0100
Message-ID: <CA+BoTQnA1M0jr5XYS_OAakCvjU+hzX6gRAB3PrRu5f-zu-h+-A@mail.gmail.com> (sfid-20140115_104550_712383_370EC168)
Subject: Re: [RFC 4/4] cfg80211: implement multi-BSS CSA
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15 January 2014 10:39, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2014-01-15 at 07:52 +0100, Michal Kazior wrote:
>
>> So you're basically saying the new attribute should be used as an
>> array attribute instead. Sounds good, but..
>>
>> What about backward compatibility? Do we not care? Or should we
>> preserve old parsing for single-interface CSA (i.e. older hostapd)?
>
> I think we have to preserve the old parsing if the new isn't present,
> but that shouldn't be all that difficult?
>
> if (info->attrs[MULTI])
>   for_each_attr(a, info->attrs[MULTI])
>     parse_nested(a, attrs);
>     parse(attrs);
> else
>   parse(info->attrs);
>
> or something like that, right?

Agreed.


>> > is more error prone as it would allow older kernels to parse the whole
>> > thing while ignoring the next/more/whatever, so you'd get some weird
>> > subset of the intended behaviour. Forcing *all* interfaces into the
>> > sub-attribute when more than one is desired (or in fact for a single
>> > one, if you're ok with requiring a kernel with support) would IMHO be
>> > less error prone.
>>
>> From a practical point of view cfg80211 should deny such a request due
>> to multi-channel (interface combination) and by (the only CSA
>> implementator in upstream) mac80211 due to chanctx->refcount > 1.
>
> Hmm, true. I'd still prefer the other version, the stacked/nested one
> kinda makes me uncomfortable ... It'll work, no doubt about it, but the
> deep nesting I'm not really happy with.

I'll work on that then.


Michał
