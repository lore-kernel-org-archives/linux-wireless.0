Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40069 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898Ab1KDQY4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 12:24:56 -0400
Subject: Re: [PATCH v3 3/3] mac80211: Allow overriding some HT information.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4EB41014.6000002@candelatech.com>
References: <1320299722-30113-1-git-send-email-greearb@candelatech.com>
	 <1320299722-30113-3-git-send-email-greearb@candelatech.com>
	 (sfid-20111103_065549_863747_7FFD5818) <1320310045.3950.23.camel@jlt3.sipsolutions.net>
	 <4EB2CBCC.6080709@candelatech.com>
	 <1320417690.3969.88.camel@jlt3.sipsolutions.net>
	 <4EB41014.6000002@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Nov 2011 17:24:53 +0100
Message-ID: <1320423893.3969.104.camel@jlt3.sipsolutions.net> (sfid-20111104_172459_762123_51CB44A1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-11-04 at 09:17 -0700, Ben Greear wrote:

> >>> The AMPDU density should only allow increasing.
> >>>
> >>> I think a lot of this validation should live in cfg80211 so if another
> >>> driver wants to implement it, this kind of thing is already covered.
> >>
> >> The ath9k driver supports 0, and then every value that corresponds to 1us or higher.
> >> If you set it to 1/2us, for instance, it just quietly rounds up to 1us.  It defaults
> >> to 8, so it appears valid to decrease or increase this value.
> >
> > What quietly rounds up?
> >
> > If it defaults to 8 then I'm sure there's a reason for it, such as the
> > crypto engine not being fast enough and needing 8us buffer between
> > frames. As such, I really don't think decreasing it is valid.
> 
> See this code in ath9k, top of main.c.  It appears to support more
> than the default of 8.  I tested it out, and it appears to work
> when set to lower values.  I am disabling hw-crypt since I need
> multiple VIFS, but not sure that matters or not.
> 
> static u8 parse_mpdudensity(u8 mpdudensity)

Well, this is used for TX. You're advertising the value for RX.
Advertising a smaller value may work for you -- but only if the AP uses
something larger anyway. It's free to do this. The code you quoted
implements this -- it looks at what the min spacing is the peer wants,
and then uses something bigger.

So I still stand by what I said earlier -- you should not allow
advertising a smaller value than the hardware wanted to use initially.
If the AP doesn't use that smaller value, all is well, but if it
actually uses a smaller value then the hardware might fall over.

johannes

