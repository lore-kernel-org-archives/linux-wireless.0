Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40393 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab2KTMVO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 07:21:14 -0500
Message-ID: <1353414102.9399.16.camel@jlt4.sipsolutions.net> (sfid-20121120_132117_586059_4B3F3222)
Subject: Re: [RFC v2 4/8] nl80211/cfg80211: support VHT channel configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 20 Nov 2012 13:21:42 +0100
In-Reply-To: <50AB70B9.1010505@posedge.com>
References: <1352492254-29399-1-git-send-email-johannes@sipsolutions.net>
	  <1352492254-29399-5-git-send-email-johannes@sipsolutions.net>
	  <50AB3EE1.8060101@posedge.com>
	  <1353400890.9399.3.camel@jlt4.sipsolutions.net>
	  (sfid-20121120_094103_819884_8535CF9F) <1353404398.9399.9.camel@jlt4.sipsolutions.net>
	 <50AB70B9.1010505@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-11-20 at 17:29 +0530, Mahesh Palivela wrote:

> >>> For loops in both functions seems to be similar. One return false, other
> >>> return -EINVAL. Can we remove duplication?
> >>
> >> True, but they check different flags. I suppose we could have a common
> >> function where the checked flags are passed in, I can try that.
> >
> > I'll add this to the patch:
> >
> > http://p.sipsolutions.net/24eb25fb98ef2d0b.txt
> >
> 
> Looks good to me Johannes. Overall your VHT channel config 
> implementation done so well.

Thanks for reviewing!

> Partial regulatory check in nl80211_parse_chandef() has to be modified 
> to include BW check. I see your TODO comment there.

Yes, although I'm not completely sure the bandwidth check ever made
sense? We'll need to discuss that.

Regardless of that though, I'm tempted to put this into the tree now. As
we don't have any drivers (but hwsim) using it, we won't have any
regulatory issues without the bandwidth check for now, and then we can
base further work on this.

Any objections from you? If not I'll repost the whole thing as [PATCH].

johannes

