Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:41690 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751253AbZDQTiq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Apr 2009 15:38:46 -0400
Date: Fri, 17 Apr 2009 22:38:38 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] nl80211: Add set/get for frag/rts threshold and retry
	limits
Message-ID: <20090417193838.GA21250@jm.kir.nu> (sfid-20090417_213849_785295_B64B5E40)
References: <20090417184629.GA9275@jm.kir.nu> <1239996573.5110.12.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1239996573.5110.12.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 17, 2009 at 09:29:33PM +0200, Johannes Berg wrote:
> > +	if (changed & WIPHY_PARAM_RTS_THRESHOLD) {
> > +		if (local->ops->set_rts_threshold)
> > +			local->ops->set_rts_threshold(local_to_hw(local),
> > +						      wiphy->rts_threshold);
> > +	}
> 
> That could return an error. (so do the changes the other way around)

I noticed, but ended up following the existing behavior in wext.c. While
that may not be the ideal source for good behavior, at least this is
consistent. Should both of them be changed? What exactly should happen
on error?

> > +		if (changed & WIPHY_PARAM_RETRY_SHORT)
> > +			rdev->wiphy.retry_short = retry_short;
> > +		if (changed & WIPHY_PARAM_RETRY_LONG)
> > +			rdev->wiphy.retry_long = retry_long;
> > +		if (changed & WIPHY_PARAM_FRAG_THRESHOLD)
> > +			rdev->wiphy.frag_threshold = frag_threshold;
> > +		if (changed & WIPHY_PARAM_RTS_THRESHOLD)
> > +			rdev->wiphy.rts_threshold = rts_threshold;
> > +
> > +		result = rdev->ops->set_wiphy_params(&rdev->wiphy, changed);
> > +		if (result)
> > +			goto bad_res;
> > +	}
> 
> If that returns an error we need to roll back the values?

I thought about this, but ended up not doing that because the existing
(wext) code seemed to behave in the same way. It is unclear whether the
error there would indicate that some of the parameters were taken into
use, but not all. Unless we provide mechanism for returning that
information (e.g., separate calls for each parameter), I'm not sure what
exactly should be done here. Just leaving the parameters (which were
validated before) in struct wiphy seemed like the safest (and well,
certainly easiest ;-) alternative.

-- 
Jouni Malinen                                            PGP id EFC895FA
