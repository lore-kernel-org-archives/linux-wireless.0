Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39307 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427Ab1KIIhQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Nov 2011 03:37:16 -0500
Subject: Re: [PATCH v8 2/2] mac80211:  Support ht-cap over-rides.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4EB9B70B.6000406@candelatech.com>
References: <1320780995-30483-1-git-send-email-greearb@candelatech.com>
	 <1320780995-30483-2-git-send-email-greearb@candelatech.com>
	 (sfid-20111108_203659_989707_E33ECA13) <1320783128.24797.48.camel@jlt3.sipsolutions.net>
	 <4EB99812.3000507@candelatech.com>
	 <1320786130.24797.78.camel@jlt3.sipsolutions.net>
	 <4EB9B70B.6000406@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Nov 2011 09:37:12 +0100
Message-ID: <1320827832.3845.8.camel@jlt3.sipsolutions.net> (sfid-20111109_093720_440669_B0A4D87D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-11-08 at 15:11 -0800, Ben Greear wrote:

> > Please. I'd rather go over a bit than read the above :-)
> 
> I just fixed this by using a tmp variable.  Hopefully the
> compiler is smart enough to make it disappear.

That works, yeah.

> > I really think that'd be much nicer. As it is now we have to add all
> > these checks everywhere, if we just calculate it once and then change
> > places to use it we just have to remember to use the right thing.
> 
> I'm quite nervous about attempting this change.  I'm pretty
> confident my current patch works as designed, and over all,
> it's pretty non-intrusive.  I am afraid that if I start trying
> to substitute something for sband->ht_cap that I'm going
> to end up changing a lot of code and possibly adding all sorts
> of strange bugs.

You should only have to change the places where you now added the
overrides, no?

> Out of curiousity, if one is doing off-channel work, wouldn't
> sband be different from when we associated and possibly different
> in it's ht-capabilities?  If so, the used-ht-caps would not
> be valid for that work?

Well the off-channel work will be on the channel that you're going to be
using after a successful connection, so that should be OK.

I'd at least like to try. If it ends up a disaster maybe we shouldn't,
but the way you go back to the mask & set all the time makes me a bit
nervous.

johannes

