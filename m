Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51218 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab1IUKQH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 06:16:07 -0400
Subject: Re: [RFC 3/5] nl80211/cfg80211: adding intermediate scan result
 event.
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <coelho@ti.com>
Cc: victorg@ti.com, linux-wireless@vger.kernel.org
In-Reply-To: <1316595838.2157.468.camel@cumari>
References: <1315224151-16552-1-git-send-email-VictorG@ti.com>
	 <1315224151-16552-4-git-send-email-VictorG@ti.com>
	 <4E799DF9.9060807@ti.com>  <1316594138.3940.10.camel@jlt3.sipsolutions.net>
	 <1316595838.2157.468.camel@cumari>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Sep 2011 12:16:01 +0200
Message-ID: <1316600161.3940.17.camel@jlt3.sipsolutions.net> (sfid-20110921_121611_463152_34125538)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-09-21 at 12:03 +0300, Luciano Coelho wrote:

> > advantages of 1:
> > + info is directly available
> > + very fine-grained
> > 
> > disadvantages of 1:
> > - lots of context switches, fairly expensive
> 
> I just want to mention that these context switches will be there
> regardless of whether the full BSS info is passed or not.

Of course, but sending half the info is not really an option I'm willing
to consider :-)

> > advantages of 2:
> > + adds more generic filtering capability
> 
> What do you mean here? I think we can have quite generic filtering in
> both cases.

True, but we won't do it if we don't need it here ;-)

> > + fewer context switches since retrieving BSS dump is limited & only
> > needs very few messages
> 
> Indeed the number of switches will be smaller.  To improve it further,
> as we discussed on IRC, we should also implement a per-channel BSS dump,
> otherwise we would have to retrieve the same data over an over again.

That's what I meant by the filtering.

> > disadvantages of 2:
> > - not quite as fine-grained
> 
> One more:
> - this requires HW support (which we don't have in wl12xx ;), unless SW
> scan is used

Oh, that might be true. You might be able to fake it but that seems
complex.

> I see your point about reducing the context switches while still
> increasing the granularity of scan results with this option 2, but I
> think it's not going to be that helpful.  Sure we can stop the scan
> earlier if we find what we want, but the possibilities will be smaller.
> 
> Also, with option 2, you may have more context switches too, if you're
> scanning on not-so-crowded areas.  If we report results per-channel, we
> will always have at least 37 events (with 11a and 11bg), each triggering
> at least 3 context switches, because userspace requests the BSS dump
> separately.  If we use per-results events, including all BSS info, we
> will have just as many context switches as there are results available.
> 
> Thus, I think passing intermediate result events, as they come, is more
> flexible and efficient in normal situations.  And if we really want to
> reduce the context switches and data copied from kernel to userspace, we
> also have the option of improving results filtering.  We could make some
> similar "match" filters as I have recently implemented for sched_scans.

Good points! I'm convinced :-)

johannes

