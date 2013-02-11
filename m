Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:45239 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757838Ab3BKRSd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 12:18:33 -0500
Date: Mon, 11 Feb 2013 11:18:29 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [PATCH v3 1/2] mac80211: Fix tx queue handling during scans
Message-ID: <20130211171829.GD13768@thinkpad-t410> (sfid-20130211_181846_085677_E76F3569)
References: <1360189829.7910.84.camel@jlt4.sipsolutions.net>
 <1360259677-19278-1-git-send-email-seth.forshee@canonical.com>
 <1360314212.29851.4.camel@jlt4.sipsolutions.net>
 <20130208171155.GC2622@thinkpad-t410>
 <1360343852.29851.26.camel@jlt4.sipsolutions.net>
 <20130208181002.GD2622@thinkpad-t410>
 <1360350359.29851.27.camel@jlt4.sipsolutions.net>
 <20130208204632.GE2622@thinkpad-t410>
 <1360356792.29851.33.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1360356792.29851.33.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 08, 2013 at 09:53:12PM +0100, Johannes Berg wrote:
> On Fri, 2013-02-08 at 14:46 -0600, Seth Forshee wrote:
> 
> > > > Well, I think the way that will be simplest with the fewest code changes
> > > > would be to use a tx control flag. Of course then we've gobbled up one
> > > > of the last available flags.
> > > 
> > > Let's do that anyway then. I still think we need to do the
> > > PS/scan/offchannel thing I described in another mail anyway, so that'd
> > > be a better interim step than changing all the prototypes...
> > 
> > When I originally looked at using a tx control flag I didn't think that
> > using IEEE80211_TX_CTL_TX_OFFCHAN would work, but now I'm not sure why.
> > Is there any reason not to do this?
> 
> I guess you'd have to pre-assign the queue, since the code in
> ieee80211_tx() might skip that part, but that seems easy enough. Other
> than that, a driver that checks IEEE80211_TX_CTL_TX_OFFCHAN might treat
> that frame specially, but OTOH the only drivers using it right now are
> ours and TI's and they both have HW scan/roc, so your code never
> executes. What a future driver might do is anyone's guess...

All right, I decided to go ahead with the new flag since what I need it
to do is somewhat incongruous with what IEEE80211_TX_CTL_TX_OFFCHAN
indicates. New patches will follow.

Seth

