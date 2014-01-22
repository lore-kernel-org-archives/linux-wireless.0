Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:37918 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbaAVJHR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 04:07:17 -0500
Received: by mail-ea0-f182.google.com with SMTP id r15so3565584ead.27
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jan 2014 01:07:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1390380726.4334.4.camel@jlt4.sipsolutions.net>
References: <1390227670-19030-1-git-send-email-michal.kazior@tieto.com>
	<1390227670-19030-6-git-send-email-michal.kazior@tieto.com>
	<1390316761.6199.27.camel@jlt4.sipsolutions.net>
	<CA+BoTQmsROawL=bcyiXM+zCWKfKr7KPRvDoojKfoCByV97zSUw@mail.gmail.com>
	<1390380726.4334.4.camel@jlt4.sipsolutions.net>
Date: Wed, 22 Jan 2014 10:07:14 +0100
Message-ID: <CA+BoTQm+DipFGQhVnGoVM4JvLgXZv1EZ0Ve4UNnFwnifsKXoCA@mail.gmail.com> (sfid-20140122_100723_445624_D48D5B67)
Subject: Re: [PATCH 5/7] mac80211: improve CSA locking
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22 January 2014 09:52, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2014-01-22 at 07:51 +0100, Michal Kazior wrote:
>
>> > I mean this:
>> >
>> >> +       sdata->csa_chandef = params.chandef;
>> >
>> > doesn't seem to belong here.
>>
>> I mistakenly left that while rebasing. I'll fix that. I think that's
>> the only thing that shouldn't be in this patch?
>
> It's the only thing I found, but ... :)
>
>> > It would also be good to explain why you're doing this?
>>
>> You mean the whole locking patch? Basically to be able safely assess
>> CSA state. Taking a bunch of wdev->mtx seems like a bad idea. Due to
>> how the locks are ordered and organized I've came up with using
>> local->mtx as an extra CSA-related variable protection. Using
>> local->mtx makes it possible to iterate over interfaces and check
>> for/update CSA state in an atomic way.
>>
>> Is this a satisfactory explanation?
>
> Almost - where exactly do you need that? I'm just trying to weigh this
> patch vs. the other that I didn't like to see if this is needed
> regardless of the particular approach of how we switch channels later.

Hmm.. ieee80211_check_concurrent_iface() checks for vif.csa_active so
I assumed it should be protected by a lock too. But now I'm
questioning if it should check csa_active at all? It's just an
interface type change. You can't change iftype of a running (i.e.
connected/associated/beaconing) interface, right? If interface isn't
actually running it doesn't use a channel context, so it is fine to
change iftype regardless of CSA state. What should actually be
forbidden is to bind to a channel context that is a part of a CSA
(which I do in the other patch).

local->mtx is also used in the later patch to lock out conflicting
(current impl. just assumes concurrent = conflicting) CSA requests.
But I wonder (assuming we forege csa_active check in
ieee80211_check_concurrent_iface) - if we move CSA to be more chanctx
centric it might actually make more sense to depend on chanctx_mtx
instead of local->mtx, no?


Michał
