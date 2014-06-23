Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:44808 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812AbaFWUOG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2014 16:14:06 -0400
Received: by mail-lb0-f181.google.com with SMTP id p9so5155143lbv.26
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jun 2014 13:14:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOHe==H=6zZ-CyZL0k1oyLAAD35gFwP-MBc7VDX=Xy=N8fmTEA@mail.gmail.com>
References: <1402778536-31305-1-git-send-email-mihirsht@gmail.com>
 <CAB=NE6U=i7oeK7Ue=NH2YFhLrZOc359MzRYcj4Cv2dYUC0QwmQ@mail.gmail.com> <CAOHe==H=6zZ-CyZL0k1oyLAAD35gFwP-MBc7VDX=Xy=N8fmTEA@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Mon, 23 Jun 2014 13:13:42 -0700
Message-ID: <CAB=NE6UbzpEPp0D1vQ6mvBdqeEq2KH1uQuVbsrWb4B8i-1VEbg@mail.gmail.com> (sfid-20140623_221411_428360_ACA00CFF)
Subject: Re: [PATCH] cfg80211: unblock user hint when cfg80211_regdom is intersected
To: Mihir Shete <mihirsht@gmail.com>,
	Ben Greear <greearb@candelatech.com>,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	Arik Nemtsov <arik@wizery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adding Ben and Janusz as I believe this is the core of the original
issue Ben reported when a card has no regulatory domain programmed and
his system ends up intersecting a user set regulatory domain and the
cfg80211 regulatory domain was core. That should not happen and a
proper fix would be entangled on this code section. Also adding Arik
as he might be interested in the intersection case given that his new
API would add a new type of regulatory setting we should consider for
when then the user asks to update regulatory.

On Thu, Jun 19, 2014 at 2:51 AM, Mihir Shete <mihirsht@gmail.com> wrote:
>> Let's keep this in mind:
>>
>> When processing requests on the queue get_last_request() will return
>> the last requests which was accepted and already processed. When
>> reg_update_last_request() is issued last_request becomes the newly
>> accepted request that we are about to process. If this seems rather
>> confusing we should split this up into two, but so far its not clear
>> to me this is needed given we serialize processing requests and have a
>> last_request->pending too.
>>
>> __reg_process_hint_user() is evaluating whether or not we should apply
>> the passed hint. Given all this, when would lr->intersect be true but
>> the set regdomain not be intersected? That would seem like an issue to
>> me.
>>
> hmm, yea but there can be cases when last_request is not processed

Not within the context of processing requests on queue -- in this
particular case when we are processing requests
reg_process_pending_hints() will not allow the code to continue unless
the last request is already processed.

> and we have already called reg_update_last_request(). This happens because
> reg_update_last_request() is called before reg_call_crda() and so I thought we
> could ignore the user hints till we hear back from crda.

We already do that on reg_process_pending_hints(), we won't allow
hints through until the last request is processed, the requests then
are serialized.

>> Also note that your commit log seems to claim to want to make a change
>> only for user type hints but the above folds all your desired changes
>> to all the checks it was checking for.
>>
>> Lastly, we should be allowing through user changes if and only if a
>> core or driver hint was not issued,
> User hints are for enhancing the compliance and they should be allowed
> even after the driver hints.

Yeah good point,  right now we're ignoring all hints from the user if
the last request was set by core, driver or user and the regdom
changes. I think it makes sense then to split up each of these into
their own check just to make the code clear and document each case on
top with the logic. Additionally we always are setting intersection as
required regardless of what __reg_process_hint_user() told us to do,
this is obviously a mistake for when the regulatory domain was set by
core and the regulatory domain is world roaming for example so
reg_process_hint_user() should check for the treatment instead of
blindly always setting intersection. I think addressing these changes
would fix the issue Ben reported on his custom test environment.

> Say, a device is configured to be sold in the US, and a User travels with it
> to some country where 5GHz operation is not allowed then the user
> hint will help ensuring that we comply with the new regulatory rules.

Agreed. That should be a specific case then.

>>otherwise the intersection makes
>> sense to upkeep, however I do see it making sense to allow a user
>> regulatory if an intersection was done but *iff* we want to clear the
>> old userspace setting,
> Yes, agreed. and we have a check in  __reg_process_hint_user()
> to override the intersection *iff* we have a *different* userspace setting.

Well but that code section right now asks to ignore the request:

        /*
         * If the user knows better the user should set the regdom
         * to their country before the IE is picked up
         */
        if (lr->initiator == NL80211_REGDOM_SET_BY_USER &&
            lr->intersect)
                return REG_REQ_IGNORE;

That comment should be removed as its there from old times and
adjusted to reflect current times. We already deal with cell base
station hints above, this section deals with regular hints. This needs
to be updated to ensure what you say is allowed but we have to
consider the different cases for intersection of a regulatory domain
that was hinted by user. We can have three hints that could lead to an
intersection to user when a driver hint is involved, in this order:

Core (world) --> driver --> user (intersection)
Core (world) --> user --> driver (intersection)

The first case is what we typically would see though but both are
possible. Adding a check to ensure user hints are allowed to be set if
the last request was a user hint would address the first case given
that the wiphy->regdg would be cached but it wouldn't allow for
setting the regulatory domain for the second case. Right now a driver
hint is always intersected if the last request was not core. If the
regulatory hints agree REG_REQ_ALREADY_SET is always returned. As
reflected in the above code section right now we're ignoring all hints
from the user if the last request was set by core, driver or user and
the regdom changes. The change you make would tries to detangle the
double user hint case, but I think it also makes sense to detangle and
document clearly what happens when driver hint --> user hint happens,
that should produce an intersection.

>> but note that to do that cleanly we'd have to
>> assume an original state. We can do this without much overhead by
>> resetting the regulatory core to the original state given that core
>> and driver hints will be cached and be set once the reset is called.
>> You have to consider when a reset makes sense though and be very very
>> careful about this though otherwise you might end up in inconsistent
>> states that make no sense at run time. Consider being allowed to do
>> certain things, being associated, and then all of a sudden driving the
>> regulatory core which would prohibit that current state.
>>
>> If you really want to enable this regardless of the state you may have
>> to trigger disassoc, etc. Please think of all this.
> User hints can come at any time and they are always processed irrespective
> of the sme state, but I can see Arik is already working on taking care of this
> stuff.

Indeed, all that work will be very useful, his change becomes more
important given the nature of source of regulatory data though, since
we process regulatory hints serially now and if a driver is only using
wireless-regdb then there should be no major issues as the regulatory
state changes, but his change is more important once we consider
different regulatory sources.

  Luis
