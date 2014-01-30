Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:42866 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbaA3AmF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jan 2014 19:42:05 -0500
Received: by mail-la0-f41.google.com with SMTP id mc6so2113466lab.28
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jan 2014 16:42:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1391001002.4143.14.camel@jlt4.sipsolutions.net>
References: <1390394624-3927-1-git-send-email-janusz.dziedzic@tieto.com>
 <1390394624-3927-2-git-send-email-janusz.dziedzic@tieto.com>
 <1390492620.4142.33.camel@jlt4.sipsolutions.net> <20140125003255.GE28512@garbanzo.do-not-panic.com>
 <1391001002.4143.14.camel@jlt4.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 29 Jan 2014 16:41:42 -0800
Message-ID: <CAB=NE6XysGH36Jep4xxqQZPmFM=AR6akcb-REWPW93H4y68=tQ@mail.gmail.com> (sfid-20140130_014209_727999_A54C1133)
Subject: Re: [PATCH v2 2/3] cfg80211: introduce regulatory wide bandwidth flag
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 29, 2014 at 5:10 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2014-01-24 at 16:32 -0800, Luis R. Rodriguez wrote:
>
>> > This seems reasonable, thanks. Maybe we should require the bandwidth to
>> > not be set at all or something? At least maybe in the regdb parser - it
>> > makes very little sense to have @20 and then ignore it completely?
>> >
>> > Or maybe the userspace code could just not expose the flag, but rather
>> > set the new "wide_bw" flag when all the rules are marked as @N/A (and
>> > treat a combination of @number and @N/A as a bug)?
>>
>> The optimizer code I added to CRDA does all this for us, so technically,
>> unless I'm missing something, this could be dealt with magically in
>> userspace. Its also unclear why we'd define this as a regulatory
>> parameter -- this just seems to make sense.
>>
>> I'd look at extending CRDA binary to use the optimizer on the regulatory
>> domain prior to sending it to the kernel. All of a sudden you get full
>> support for this for free on any kernel.
>
> I'm not sure I get it. Whatever 'optimisation' you're doing surely can't
> be changing the semantics of the rules, which are currently defined to
> be separate and channels can't cross different rules. This may not be
> all that interesting for most country entries today, but there are a few
> that have overlapping rules and regardless, it's some form of API/ABI.

Sure.

> In any case, no optimiser can actually do what Janusz needs, since he
> needs the ability to split up existing frequency ranges due to different
> flags in parts of those, while keeping the ability to use channels that
> use multiple ranges.

Ah I see.

> The only thing I could think of an optimiser doing is combine ranges,
> but then it would lose flags which can't be right.

One thing is in-kernel rules, another is wireless-regdb. If you are
extending rules in wireless-regdb you may at times run into a
situation where two rules are contiguous and you know you can combine
them and want to, combination for example makes sense if your source
for the db has a set of contiguous frequency rules with the same
power, max eirp, and flags. That's what the optimizer available as a
library does in reglib, part of CRDA.

> And in fact combining rules would be breaking the current db.txt format.  I won't let you get
> away with that on the kernel/userspace API (hence this patch), but if
> you can get away with breaking it in CRDA I'm only going to roll my eyes
> a bit :-)

CRDA binary doesn't make use of the optimizer yet but it can.

  Luis
