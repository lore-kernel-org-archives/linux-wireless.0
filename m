Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60912 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946936Ab3BHUxQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 15:53:16 -0500
Message-ID: <1360356792.29851.33.camel@jlt4.sipsolutions.net> (sfid-20130208_215320_686018_F323B66F)
Subject: Re: [PATCH v3 1/2] mac80211: Fix tx queue handling during scans
From: Johannes Berg <johannes@sipsolutions.net>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Date: Fri, 08 Feb 2013 21:53:12 +0100
In-Reply-To: <20130208204632.GE2622@thinkpad-t410>
References: <1360189829.7910.84.camel@jlt4.sipsolutions.net>
	 <1360259677-19278-1-git-send-email-seth.forshee@canonical.com>
	 <1360314212.29851.4.camel@jlt4.sipsolutions.net>
	 <20130208171155.GC2622@thinkpad-t410>
	 <1360343852.29851.26.camel@jlt4.sipsolutions.net>
	 <20130208181002.GD2622@thinkpad-t410>
	 <1360350359.29851.27.camel@jlt4.sipsolutions.net>
	 <20130208204632.GE2622@thinkpad-t410>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-02-08 at 14:46 -0600, Seth Forshee wrote:

> > > Well, I think the way that will be simplest with the fewest code changes
> > > would be to use a tx control flag. Of course then we've gobbled up one
> > > of the last available flags.
> > 
> > Let's do that anyway then. I still think we need to do the
> > PS/scan/offchannel thing I described in another mail anyway, so that'd
> > be a better interim step than changing all the prototypes...
> 
> When I originally looked at using a tx control flag I didn't think that
> using IEEE80211_TX_CTL_TX_OFFCHAN would work, but now I'm not sure why.
> Is there any reason not to do this?

I guess you'd have to pre-assign the queue, since the code in
ieee80211_tx() might skip that part, but that seems easy enough. Other
than that, a driver that checks IEEE80211_TX_CTL_TX_OFFCHAN might treat
that frame specially, but OTOH the only drivers using it right now are
ours and TI's and they both have HW scan/roc, so your code never
executes. What a future driver might do is anyone's guess...

johannes

