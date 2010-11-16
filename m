Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56832 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445Ab0KPAdZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Nov 2010 19:33:25 -0500
Received: by iwn35 with SMTP id 35so98803iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 15 Nov 2010 16:33:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101116000605.GA5679@tux>
References: <1289528843-21982-1-git-send-email-lrodriguez@atheros.com>
 <AANLkTimKdqoWx2FtvJ9HG3Yj0ofROMDNo30=FJv1vVGG@mail.gmail.com>
 <20101112202732.GI25089@tux> <20101116000605.GA5679@tux>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 15 Nov 2010 16:33:04 -0800
Message-ID: <AANLkTimFF8VuaSt+EUOBYKQvEoXAjDP3U8o568eD6ZnK@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: Fix regulatory bug with multiple cards with a
 delayed CRDA response
To: Luis Rodriguez <Luis.Rodriguez@atheros.com>
Cc: Mark Mentovai <mark@moxienet.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"stable@kernel.org" <stable@kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 15, 2010 at 4:06 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Fri, Nov 12, 2010 at 12:27:32PM -0800, Luis Rodriguez wrote:
>> On Thu, Nov 11, 2010 at 10:05:21PM -0800, Mark Mentovai wrote:
>> > Luis R. Rodriguez wrote:
>> > > When two cards are connected with the same regulatory domain
>> > > if CRDA had a delayed response then cfg80211's own set regulatory
>> > > domain would still be the world regulatory domain. There was a bug
>> > > on cfg80211's ignore_request() when analyzing incoming driver
>> > > regulatory hints as it was only checking against the currently
>> > > set cfg80211 regulatory domain and not for any other new
>> > > pending requests. This is easily fixed by also checking against
>> > > the pending request.
>> >
>> > Luis, thanks for taking a look at this bug.
>> >
>> > Capsule summary: you’ve overloaded -EALREADY, which until now seemed
>> > to mean “that’s the regdomain I’m already using,” to now also mean
>> > “I’m going to be using that regdomain soon but I’m waiting on CRDA.”
>> > The two cases need to be handled differently.
>> >
>> > In my case, this patch makes things a little bit worse. I tested it
>> > with compat_wireless 20101110. I’ve included what I see after boot
>> > below the explanation.
>> >
>> > Your patch changes things so that, according to the steps in my
>> > original message, steps 3 and 4 become:
>> >
>> > 3. The second card’s driver calls regulatory_hint to provide US as a
>> > driver hint. ignore_request sees that the last request came from a
>> > driver and that the current and last request sought to set the same
>> > hint, so it returns -EALREADY. This triggers the “if the regulatory
>> > domain being requested by the driver” block, which calls reg_copy_regd
>> > on the apparent assumption that cfg80211_regdomain contains the
>> > regdomain that the wiphy actually wants, although it doesn’t, and it’s
>> > very wrong to do this copy. cfg80211_regdomain is still on 00, because
>> > CRDA hasn’t responded to the first card’s request yet.
>> >
>> > 4. When CRDA finally responds to the first card’s request from #2, it
>> > gets plumbed to set_regdom, which calls __set_regdom. __set_regdom
>> > sees that it’s not intersecting, and enters the block where it would
>> > normally copy reg_copy_regd to set the wiphy’s regd, but the wiphy it
>> > uses is the one saved from last_request (in step 3), and it already
>> > had something copied to it (also in step 3). Since __set_regdom checks
>> > for this and bails out with -EALREADY in the “userspace could have
>> > sent two replies with only one kernel request” case. Because
>> > __set_regdom fails, set_regdom returns early and never makes it to the
>> > update_all_wiphy_regulatory or print_regdomain steps. The regdomain
>> > remains unchanged. I’m still stuck at 00.
>> >
>> > What about using something other than -EALREADY to signal “that
>> > request is already pending?” On its face, this works, but I think
>> > there’s a deeper flaw that also needs to be addressed. I’m concerned
>> > that the wiphys that fall into this state won’t see a reg_copy_regd
>> > call at all. The idea is that any such wiphy shouldn’t really be
>> > ignored, but it should be joined to a group of wiphys waiting on the
>> > pending request, and when the request is satisfied, the regd field
>> > should be populated for each of them.
>>
>> Thanks for testing and your review.
>>
>> We need to address a queue of requests with the associated wiphys,
>> as I originally had developed, I'll go ahead and add this and
>> treat these, it should take care of even multiple cards with
>> different regulatory hints. I expect the amount of code will be
>> a bit to large for stable though so likely we may only be able
>> to fix this for new kernels.
>>
>> I'll take a stab at this now.
>
> OK we did have the queuing mechanism in place but we were not processing
> the requests atomically. Please give the patch below a shot.

Now the next thing we need to do is decide what we want to do in the
case CRDA is not present and we keep checking and the last request is
still not processed. How many times do we want to check for this, and
what do we do if we give up?

I'm thinking we check every 1/2 second and in the case we don't get a
response in 3 seconds we give up completely on CRDA. This would entail
dropping all pending regulatory requests. Not sure if we should bother
even allowing for 11d hints if CRDA was not found.. Then again users
can install CRDA after... so do we just require a reboot then?

  Luis
