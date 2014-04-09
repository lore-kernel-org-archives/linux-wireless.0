Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:54015 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932898AbaDIPWh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 11:22:37 -0400
Received: by mail-pa0-f45.google.com with SMTP id kl14so2649115pab.4
        for <linux-wireless@vger.kernel.org>; Wed, 09 Apr 2014 08:22:36 -0700 (PDT)
From: "Zhao\, Gang" <gamerh2o@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 8/8] cfg80211: remove unnecessary include clauses
References: <c0bf65125e2d1fce1a1757cd2d46ef47d4a145b9.1397006688.git.gamerh2o@gmail.com>
	<c02aba28b27fe39da9730cd965e322054815713f.1397006688.git.gamerh2o@gmail.com>
	<1397029770.4964.2.camel@jlt4.sipsolutions.net>
	<87d2gqg05o.fsf@gmail.com>
	<1397047019.4964.8.camel@jlt4.sipsolutions.net>
Date: Wed, 09 Apr 2014 23:22:27 +0800
In-Reply-To: <1397047019.4964.8.camel@jlt4.sipsolutions.net> (Johannes Berg's
	message of "Wed, 09 Apr 2014 14:36:59 +0200")
Message-ID: <87y4zeede4.fsf@gmail.com> (sfid-20140409_172247_231741_347FF193)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-04-09 at 14:36:59 +0200, Johannes Berg wrote:
> On Wed, 2014-04-09 at 20:25 +0800, Zhao, Gang wrote:
>> On Wed, 2014-04-09 at 09:49:30 +0200, Johannes Berg wrote:
>> > I don't like those last four patches, I'd rather have more includes than
>> > rely on other headers including headers that we need - that could change
>> > after all.
>> 
>> As I said in commit log, duplicate including could hide some warnings.
>
> Well, the commit logs for these patches didn't have any such
> information, but that's not really the point. Besides, what does "could
> hide some warnings" even mean? This isn't a meaningful thing, if you
> include the right headers then you should get what you need, and you
> should include the headers for what you need.

I said it in those four "fix" patches, not here. I thought it's
consensus to exclude directly included headers if it's indirectly
included in other headers, but apparently I'm wrong.

What I mean the duplicate including supressed the warnings is:

#include <a.h>
#include <b.h>
#include <c.h>

<c.h> includes <a.h>, so I thought <a.h> is "duplicate". BTW now I'm not
sure my defination of duplicate is equal to `make includecheck` command.

If <b.h> needs to includes <a.h> but forgot to do it, it will not
generate warning, since <a.h> is above, and do the work. If we remove
<a.h>, the warning will show up, and we can fix it. That's what I think
is the benifit of removing duplicate include.

>
>> In theory, the possibility of change is equal, either it's a directly
>> included header or a indirectly included header, and it's more likely to
>> change to include more, not less. So the change may not cause any
>> problem.
>
> At the current point in time. If some of the headers that you rely on
> including something no longer does in the future because it no longer
> needs that, then you just broke everything. That's the point you
> seemingly didn't consider, and I think it's much better to include what
> you need rather than rely on somebody else doing it for you. The latter
> can even be architecture-specific.

I see your point. The benifit of removing duplicate including is above,
the drawback is that we may more depend on other parts of the code than
we should be.

>
>> In other way, the local directory header files may change more
>> frequently than the header files in include/ directory. Whether it's a
>> total win to apply the last four patches may be a question, but it's
>> just amusing to see that lots of lines can be deleted. :-)
>
> # of lines isn't a relevant metric though. If you were removing includes
> that we didn't need that's certainly a useful thing, but removing
> includes because they're indirectly already included is IMHO practically
> always bad.
>
> johannes
