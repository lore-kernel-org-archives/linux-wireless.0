Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:4890 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbZKCT0N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2009 14:26:13 -0500
Date: Tue, 3 Nov 2009 14:25:48 -0500
From: Bob Copeland <me@bobcopeland.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: CSights <csights@fastmail.fm>, linux-wireless@vger.kernel.org
Subject: Re: ath5k and ".local" dropout
Message-ID: <20091103192548.GB10464@hash.localnet>
References: <200911021907.16271.csights@fastmail.fm> <20091103180055.GC4839@tuxdriver.com> <b6c5339f0911031054g13443c17ma925014fb9b16ab8@mail.gmail.com> <20091103190149.GE4839@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20091103190149.GE4839@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 03, 2009 at 02:01:49PM -0500, John W. Linville wrote:
> > We zero out the mcast filter for some reason, I'm not sure why.  Maybe
> > missing tildes in front of the zeroes or something.
> 
> Any feedback on that patch? :-)

Positive, so far.  Saving CSights the trouble of requoting :)  I'll push it
unless C pops up with "any other problem"...

> > diff --git a/drivers/net/wireless/ath/ath5k/base.c
> > b/drivers/net/wireless/ath/ath5k/base.c index 1287ded..1e6e0b6 100644
> > --- a/drivers/net/wireless/ath/ath5k/base.c
> > +++ b/drivers/net/wireless/ath/ath5k/base.c
> > @@ -1125,7 +1125,6 @@ ath5k_mode_setup(struct ath5k_softc *sc)
> >       /* configure operational mode */
> >       ath5k_hw_set_opmode(ah);
> >
> > -     ath5k_hw_set_mcast_filter(ah, 0, 0);
> >       ATH5K_DBG(sc, ATH5K_DEBUG_MODE, "RX filter 0x%x\n", rfilt);
> >  }
> 
> YES!
> At least I am able to ping for longer than 2 minutes. :)  I'll keep
> running  the modified code and see if any other problem crops up.

-- 
Bob Copeland %% www.bobcopeland.com

