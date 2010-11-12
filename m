Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:30408 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932661Ab0KLU1g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 15:27:36 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 12 Nov 2010 12:27:23 -0800
Date: Fri, 12 Nov 2010 12:27:32 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Mark Mentovai <mark@moxienet.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"stable@kernel.org" <stable@kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] cfg80211: Fix regulatory bug with multiple cards with
 a delayed CRDA response
Message-ID: <20101112202732.GI25089@tux>
References: <1289528843-21982-1-git-send-email-lrodriguez@atheros.com>
 <AANLkTimKdqoWx2FtvJ9HG3Yj0ofROMDNo30=FJv1vVGG@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <AANLkTimKdqoWx2FtvJ9HG3Yj0ofROMDNo30=FJv1vVGG@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 11, 2010 at 10:05:21PM -0800, Mark Mentovai wrote:
> Luis R. Rodriguez wrote:
> > When two cards are connected with the same regulatory domain
> > if CRDA had a delayed response then cfg80211's own set regulatory
> > domain would still be the world regulatory domain. There was a bug
> > on cfg80211's ignore_request() when analyzing incoming driver
> > regulatory hints as it was only checking against the currently
> > set cfg80211 regulatory domain and not for any other new
> > pending requests. This is easily fixed by also checking against
> > the pending request.
> 
> Luis, thanks for taking a look at this bug.
> 
> Capsule summary: you’ve overloaded -EALREADY, which until now seemed
> to mean “that’s the regdomain I’m already using,” to now also mean
> “I’m going to be using that regdomain soon but I’m waiting on CRDA.”
> The two cases need to be handled differently.
> 
> In my case, this patch makes things a little bit worse. I tested it
> with compat_wireless 20101110. I’ve included what I see after boot
> below the explanation.
> 
> Your patch changes things so that, according to the steps in my
> original message, steps 3 and 4 become:
> 
> 3. The second card’s driver calls regulatory_hint to provide US as a
> driver hint. ignore_request sees that the last request came from a
> driver and that the current and last request sought to set the same
> hint, so it returns -EALREADY. This triggers the “if the regulatory
> domain being requested by the driver” block, which calls reg_copy_regd
> on the apparent assumption that cfg80211_regdomain contains the
> regdomain that the wiphy actually wants, although it doesn’t, and it’s
> very wrong to do this copy. cfg80211_regdomain is still on 00, because
> CRDA hasn’t responded to the first card’s request yet.
> 
> 4. When CRDA finally responds to the first card’s request from #2, it
> gets plumbed to set_regdom, which calls __set_regdom. __set_regdom
> sees that it’s not intersecting, and enters the block where it would
> normally copy reg_copy_regd to set the wiphy’s regd, but the wiphy it
> uses is the one saved from last_request (in step 3), and it already
> had something copied to it (also in step 3). Since __set_regdom checks
> for this and bails out with -EALREADY in the “userspace could have
> sent two replies with only one kernel request” case. Because
> __set_regdom fails, set_regdom returns early and never makes it to the
> update_all_wiphy_regulatory or print_regdomain steps. The regdomain
> remains unchanged. I’m still stuck at 00.
> 
> What about using something other than -EALREADY to signal “that
> request is already pending?” On its face, this works, but I think
> there’s a deeper flaw that also needs to be addressed. I’m concerned
> that the wiphys that fall into this state won’t see a reg_copy_regd
> call at all. The idea is that any such wiphy shouldn’t really be
> ignored, but it should be joined to a group of wiphys waiting on the
> pending request, and when the request is satisfied, the regd field
> should be populated for each of them.

Thanks for testing and your review.

We need to address a queue of requests with the associated wiphys,
as I originally had developed, I'll go ahead and add this and
treat these, it should take care of even multiple cards with
different regulatory hints. I expect the amount of code will be
a bit to large for stable though so likely we may only be able
to fix this for new kernels.

I'll take a stab at this now.

  Luis
