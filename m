Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53590 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754358Ab1ISNcS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 09:32:18 -0400
Subject: Re: [PATCH v3 1/3] nl80211: Parse channel type attribute in an
 ibss join request
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexander Simon <an.alexsimon@googlemail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4703394.vfFCDJXmvM@alex-1> (sfid-20110919_151856_847765_ACF41151)
References: <35635039ce7d4a79dc62b19d51ccf0d5d4838112.1316297595.git.an.alexsimon@googlemail.com>
	 <1316436761.5995.22.camel@jlt3.sipsolutions.net>
	 <4703394.vfFCDJXmvM@alex-1> (sfid-20110919_151856_847765_ACF41151)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Sep 2011 15:32:17 +0200
Message-ID: <1316439137.5995.31.camel@jlt3.sipsolutions.net> (sfid-20110919_153221_835836_0B22625F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-09-19 at 15:18 +0200, Alexander Simon wrote:
> > With just this patch, you can set HT IBSS but mac80211 won't be able to
> > do it so there probably should be some form of feature check for this so
> > other (non-mac80211) drivers would be able to do this correctly -- I
> > don't expect all of them to implement HT IBSS.
> Just that i got this right: Mac80211 and other cfg80211-drivers should set 
> some flag that HT IBSS is supported that we can check.
> So that if HT IBSS is requested but not available we can return an error?

Right. Might also make sense to export that to userspace so it knows
whether to ask for it or not (in tools like NM)

johannes

