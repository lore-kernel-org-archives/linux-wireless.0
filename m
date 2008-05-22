Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:48470 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755264AbYEVTaT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 15:30:19 -0400
Subject: Re: iwl4965 - wpa_supplicant can't see 5Ghz frequencies -
	2.6.26-rc1 kernel
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Tomas Winkler <tomasw@gmail.com>,
	Vincent C Jones <v.jones@networkingunlimited.com>,
	linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <egrumbach@gmail.com>
In-Reply-To: <1211483568.3698.66.camel@johannes.berg>
References: <1210352234.3763.23.camel@X61.NetworkingUnlimited.com>
	 <1ba2fa240805101156q4dc52c2bt47d2f6e51b611eea@mail.gmail.com>
	 <1210456110.3787.26.camel@X61.NetworkingUnlimited.com>
	 <1ba2fa240805101506p78c3eeb6q6e980ac4200fd56f@mail.gmail.com>
	 <1210474179.3787.31.camel@X61.NetworkingUnlimited.com>
	 <1ba2fa240805120950mf983e97qac4cdfa2c84b6662@mail.gmail.com>
	 <1210617467.3792.4.camel@X61.DFGI.com>
	 <1ba2fa240805220953u746d3429q50faa1885104cadb@mail.gmail.com>
	 <1211478969.3698.56.camel@johannes.berg>
	 <1211481249.28022.15.camel@localhost.localdomain>
	 <1ba2fa240805221151q2e53b069n6658c6cd7d6f4ba0@mail.gmail.com>
	 (sfid-20080522_205154_739984_95576FF6)  <1211483568.3698.66.camel@johannes.berg>
Content-Type: text/plain
Date: Thu, 22 May 2008 15:30:12 -0400
Message-Id: <1211484612.28022.31.camel@localhost.localdomain> (sfid-20080522_213040_180573_76D0E4E4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-05-22 at 21:12 +0200, Johannes Berg wrote:
> > > wpa_supplicant cannot handle A-band channel #s.  Thus, with the previous
> > > code, the FREQ+frequency was sent first, and the FREQ+channel was sent
> > > second.  Sending the FREQ+channel second made the supplicant overwrite
> > > the value it already parsed from the FREQ+frequency for that BSSID.  But
> > > since the supplicant can't handle A-band channel #s, you end up with 0.
> > >
> > > Reversing the order of these two makes it work, but it's a total hack.
> > > That may be what's needed right now though until everyone fixes their
> > > supplicant.  There's overlap on A-band channels 7 - 12 (5035MHz ->
> > > 5060MHz) with B/G band channel #s.  Obviously WEXT falls over here
> > > because the band isn't passed.
> > >
> > > But what's the best fix to the supplicant?  It could just parse A-band
> > > channels and where the numbers overlap, assume B/G band.  Or, it could
> > > be patched to prefer FREQ+frequency over FREQ+channel if it received
> > > both.  That's probably the best solution.
> 
> Fun. How about it we just make wpa supplicant ignore FREQ/channel
> completely if it uses FREQ/frequency anyway?

Can't because some drivers send channel and not frequency.  Yeah, we
could fix all the drivers, but that doesn't help people running latest
supplicant on older kernels.

atmel.c
zd1201.c
wl3501_cs.c
linux-wlan-ng (somewhat unclear but probably)

Dan

> > Actually we've also tried to removing FREQ+channel part and it has
> > worked. So wpa_supplicant won't get into this dilemma.
> 
> Makes sense.
> 
> > Patch that broke it is below so  I guess the bug is in everything form
> > 2.6.25 and up.
> > '
> > commit 8318d78a44d49ac1edf2bdec7299de3617c4232e
> > Author: Johannes Berg <johannes@sipsolutions.net>
> > Date:   Thu Jan 24 19:38:38 2008 +0100
> > 
> >     cfg80211 API for channels/bitrates, mac80211 and driver conversion
> > '
> 
> Yeah, sorry about that. Once more, bitten by the assumption wext was
> useful and people would implement it properly.
> 
> johannes

