Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45285 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946218AbcBRUcS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2016 15:32:18 -0500
Message-ID: <1455827536.2084.35.camel@sipsolutions.net> (sfid-20160218_213223_007912_F3521EB5)
Subject: Re: [PATCH-v2 1/2] mac80211: Take bitrates into account when
 building IEs.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
	linux-wireless@vger.kernel.org
Date: Thu, 18 Feb 2016 21:32:16 +0100
In-Reply-To: <56B38FD1.40902@candelatech.com>
References: <1445361858-24976-1-git-send-email-greearb@candelatech.com>
	 <1453807009.2759.23.camel@sipsolutions.net>
	 <56A78E8F.1080505@candelatech.com>
	 <1454576521.2564.6.camel@sipsolutions.net> <56B38FD1.40902@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-02-04 at 09:52 -0800, Ben Greear wrote:
> On 02/04/2016 01:02 AM, Johannes Berg wrote:
> > On Tue, 2016-01-26 at 07:19 -0800, Ben Greear wrote:
> > 
> > > As far as I can tell, that will not work, because I want to have
> > > multiple station devices per radio, and have each of them be able
> > > to
> > > use a different configuration.  So, one station may be /g, and
> > > another /n and another /AC.  Same with APs.  In addition, some
> > > stations may want to use all available rates for their mode, and
> > > others may want to use a fixed rate or subset of available rates.
> > 
> > So let's agree that we're splitting the *used* rates (which we have
> > today) and the *advertised* rates/modes/...
> 
> Yes, I think that will work well, and unless I mis-understand, that
> is basically what I implemented so far.

Yes.

> Copied state might be tricky.  I think if we hold any copies of
> capabilities data in the sdata, then it should be logically compared
> with a mask and then treated as an AND with whatever the wiphy has.

Not sure what you're saying here. I was thinking we'd simply do one of
these two:

1) sdata->sband[5GHZ].vht = wiphy->sband[5GHZ].vht & user-config
   (semantically, not implementation of course)
2) sdata->sband[5GHZ].vht = wiphy->sband[5GHZ].vht

and change mac80211 to use sdata->sband instead of wiphy->sband
wherever the latter is used today. That way, we can avoid touching all
these things.

I think, for example, that you missed TDLS in your changes. Changing
everything throughout would mean that grepping for "wiphy->sband" would
immediately show such bugs, making it far easier to maintain.

>   I'm reluctant to propose any serious mac80211 change at this point,
> though perhaps as more of this type of features are added, then it
> will become more obvious how to nicely consolidate things in
> mac80211.

I don't really think this would be a "serious" change? It's basically
pointering changes, you could (and perhaps should, to catch it all) use
an spatch to make the initial change.

> To be honest, I thought my -v2 patches were fairly non-invasive
> compared to my normal hackings :)
> 

:)

johannes
