Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48473 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754106AbcCOOPw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2016 10:15:52 -0400
Message-ID: <1458051349.2871.19.camel@sipsolutions.net> (sfid-20160315_151555_907811_976050BC)
Subject: Re: [PATCH-v2 1/2] mac80211: Take bitrates into account when
 building IEs.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
	linux-wireless@vger.kernel.org
Date: Tue, 15 Mar 2016 15:15:49 +0100
In-Reply-To: <56E1B556.4080004@candelatech.com>
References: <1445361858-24976-1-git-send-email-greearb@candelatech.com>
	 <1453807009.2759.23.camel@sipsolutions.net>
	 <56A78E8F.1080505@candelatech.com>
	 <1454576521.2564.6.camel@sipsolutions.net> <56B38FD1.40902@candelatech.com>
	 <1455827536.2084.35.camel@sipsolutions.net>
	 <56C62C4E.7020600@candelatech.com>
	 <1455828330.2084.38.camel@sipsolutions.net>
	 <56C630B7.7020604@candelatech.com>
	 <1455830078.2084.47.camel@sipsolutions.net>
	 <56C63D8B.9020900@candelatech.com>
	 <1456225589.2041.24.camel@sipsolutions.net>
	 <56E1B556.4080004@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-03-10 at 09:56 -0800, Ben Greear wrote:

> First, are you proposing that I make a copy of the entire  local-
> >hw.wiphy->bands array and store it locally in sdata?

No, I think it should be pointers there, say

sdata->bands[X] pointing to the same thing as local->hw.wiphy->bands[X] 
is pointing to.

So the first patch would introduce that, and replace each and every use
of local->hw.wiphy->bands[] with sdata->bands[], if necessary
annotating the remaining ones with why they're OK and should stay.

> And then, I would provide some API to modify the bands[i]->bitrates
> and other variables to properly select the advertised features?

Kinda. You'd provide some kind of helper function or API to take the
local->hw.wiphy->bands[X] and duplicate it into a newly allocated
buffer, modifying it along the way, before assigning it to the per-
sdata stuff in sdata->bands[X].

> I am a bit concerned about making copies (and then changing) the
> driver's bitrates array.  Likely it will work with ath10k, but it
> seems fragile at best.

That's an interesting point, we currently use the rate *index* a lot,
so we have to find some way of preserving that. Perhaps we need to
introduce a flag indicating a given rate is disabled?


johannes
