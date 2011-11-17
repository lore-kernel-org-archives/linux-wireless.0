Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41276 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754532Ab1KQRZG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 12:25:06 -0500
Subject: Re: [PATCH v8 2/2] mac80211:  Support ht-cap over-rides.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4EC542C4.1040402@candelatech.com>
References: <1320780995-30483-1-git-send-email-greearb@candelatech.com>
	 <1320780995-30483-2-git-send-email-greearb@candelatech.com>
	 (sfid-20111108_203659_989707_E33ECA13) <1320783128.24797.48.camel@jlt3.sipsolutions.net>
	 <4EB99812.3000507@candelatech.com>
	 <1320786130.24797.78.camel@jlt3.sipsolutions.net>
	 <4EBC2516.4080807@candelatech.com>
	 <1321529293.3997.28.camel@jlt3.sipsolutions.net>
	 <4EC542C4.1040402@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Nov 2011 18:25:03 +0100
Message-ID: <1321550703.3997.45.camel@jlt3.sipsolutions.net> (sfid-20111117_182516_858639_0ACB6131)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-11-17 at 09:22 -0800, Ben Greear wrote:

> > We can't, but can't we like assign sdata->ht_caps = sband->ht_caps? Or
> > maybe even calculate restricted HT caps for both 2.4 and 5 GHz?
> > Basically what I was thinking is this:
> 
> > struct sub_if_data {
> > 	...
> > 	struct ieee80211_sta_ht_cap ht_cap[num_bands];
> > 	...
> > };
> 
> So we'd have to copy this data from sbands[] upon creation
> of the interface to make sure it is always initialized?
> This would allow us to easily support the overrides for
> non-station interfaces, so I do like that benefit.
> 
> Can the sbands[] data ever change for any reason once
> an interface is created?  If not, then probably this is
> doable.  If it can change, then we are screwed.

I don't think it can change but it's not const (I think?) so drivers
might do stupid things -- but that would be buggy anyway.

> It seems you are basically wanting to copy the sband[] data
> local to each interface (sdata), and then we would remove sband from most
> (or all?) of the method calls that deal with sband->ht_caps?

I guess. Though we still need the band to know which one to use (I'm
reluctant to say we just need one due to channel switching etc.)

> Looks like quite a bit of code churn, and probably requiring at least two
> patches:
>   * Get rid of sband usage by copying the sband data into sdata
>   * Add the over-ride logic

Yeah. It might be *too much* churn, but that's what I was thinking. If
you think it's likely too much churn let's go with what you have now,
there are only a few minor things about it I don't like much.

johannes

