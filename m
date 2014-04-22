Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from stator.leun.net ([85.214.203.199]:35579 "EHLO stator.leun.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbaDVXBP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Apr 2014 19:01:15 -0400
Date: Wed, 23 Apr 2014 00:53:09 +0200
From: Michael Leun <lkml20140418@newton.leun.net>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	arik@wizery.com, linux@eikelenboom.it
Subject: Re: [PATCH 0/2] cfg80211: two reg fixes
Message-ID: <20140423005309.5c2d093e@xenia.leun.net> (sfid-20140423_010121_438358_06382D73)
In-Reply-To: <20140422215012.GS27882@wotan.suse.de>
References: <1398137975-14275-1-git-send-email-mcgrof@do-not-panic.com>
	<20140422180003.6438dbb7@xenia.leun.net>
	<20140422204552.GR27882@wotan.suse.de>
	<20140422233213.780405d1@xenia.leun.net>
	<20140422215012.GS27882@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 22 Apr 2014 23:50:12 +0200
"Luis R. Rodriguez" <mcgrof@suse.com> wrote:

> On Tue, Apr 22, 2014 at 11:32:13PM +0200, Michael Leun wrote:
> > On Tue, 22 Apr 2014 22:45:52 +0200
> > "Luis R. Rodriguez" <mcgrof@suse.com> wrote:
> > 
> > 
> > > > I only see this on an Acer PTZ1825 with an ath9k wireless card,
> > > > but that machine was not sold with that wlan card, so other
> > > > people with the same model won't neccesarily see the same issue.
> > > 
> > > OK I see the issue and its clear now how this could have
> > > gone through, the wiphy comes from the country IE and it
> > > could have gone disappearing during suspend / hotplug, so
> > > we do need to check for it again.
> > [...]
> > > -		if (wiphy->regulatory_flags &
> > > REGULATORY_COUNTRY_IE_IGNORE)
> > > +		if (wiphy &&
> > > +		    wiphy->regulatory_flags &
> > > REGULATORY_COUNTRY_IE_IGNORE) return REG_REQ_IGNORE;
> > 
> > Yup, thats it. I can hear it whisper "put me into stable".
> 
> I was a bit perplexed that this was not picked up before, so I hunted
> a bit and found a fix that was applied to the mac80211-next upstream
> development tree but not propagated to stable. Can you remove that
> pach, just git checkout -f and try this one instead? It applies
> cleanly and since its upstream on Linus' tree already we should be
> able to get this to Greg faster if you confirm it fixes your issue.
> So all we need is a Tested-by.
> 
>   Luis
> 
> commit 772f0389338cfcf96da1c178046dc7e1649ab554
> Author: Ilan Peer <ilan.peer@intel.com>


Yes, this also fixes it.

-- 
MfG,

Michael Leun

