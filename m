Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47027 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab0I3WzR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Sep 2010 18:55:17 -0400
Subject: Re: [RFC 1/2] genetlink: introduce pre_doit/post_doit hooks
From: Johannes Berg <johannes@sipsolutions.net>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	tgraf@suug.ch
In-Reply-To: <AANLkTimVMGHNkK=o650qzZfvUp3mWRAG_=60etVbEBxh@mail.gmail.com>
References: <20100930211013.472957770@sipsolutions.net>
	 <20100930211131.021309930@sipsolutions.net>
	 <AANLkTik9+zA4PPPx=q6CRM-sgOjjECJdtJTgkCG9pGAY@mail.gmail.com>
	 <1285886690.5137.28.camel@jlt3.sipsolutions.net>
	 <1285886821.5137.29.camel@jlt3.sipsolutions.net>
	 <1285886955.5137.31.camel@jlt3.sipsolutions.net>
	 <AANLkTimVMGHNkK=o650qzZfvUp3mWRAG_=60etVbEBxh@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Oct 2010 00:55:52 +0200
Message-ID: <1285887352.5137.34.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-10-01 at 08:51 +1000, Julian Calaby wrote:

> > Come to think of it -- I could get away with a single pointer, since, if
> > both are assigned,
> >
> > user_ptr[0] == wiphy_to_rdev(((netdev *)user_ptr[1])->ieee80211_ptr->wiphy)
> >
> > but that's a lot of pointy things, and some functions only have the rdev
> > so it gets more complex. I think allowing two private pointers is a
> > decent compromise.
> 
> Come to think of it -- if someone wanted to have a massive structure
> with 10 pointers and a set of random data structures, then they could
> easily create their priv struct and assign it to user_ptr[0], hence
> rendering my argument null and void.

Oh, well, I thought your argument was that it was arbitrary and not
really necessary :-)

Also, this rather cheap, it just needs a bit more stack space in a place
that isn't typically deeply nested. So if some protocol came around and
needed three pointers, I'd probably advocate just bumping it to three.
At some point I might draw a line (10 is probably too much).

But you're right, of course, they can just use the first one and put
something dynamically allocated into that, if really needed.

johannes

