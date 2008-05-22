Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754086AbYEVSe3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 14:34:29 -0400
Subject: Re: iwl4965 - wpa_supplicant can't see 5Ghz frequencies -
	2.6.26-rc1 kernel
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Tomas Winkler <tomasw@gmail.com>,
	Vincent C Jones <v.jones@networkingunlimited.com>,
	linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <egrumbach@gmail.com>
In-Reply-To: <1211478969.3698.56.camel@johannes.berg>
References: <1210352234.3763.23.camel@X61.NetworkingUnlimited.com>
	 <1ba2fa240805091712gccaec9cibdab621e8d1c9ba7@mail.gmail.com>
	 <1210430367.3778.9.camel@X61.NetworkingUnlimited.com>
	 <1210434402.3787.7.camel@X61.NetworkingUnlimited.com>
	 <1ba2fa240805101156q4dc52c2bt47d2f6e51b611eea@mail.gmail.com>
	 <1210456110.3787.26.camel@X61.NetworkingUnlimited.com>
	 <1ba2fa240805101506p78c3eeb6q6e980ac4200fd56f@mail.gmail.com>
	 <1210474179.3787.31.camel@X61.NetworkingUnlimited.com>
	 <1ba2fa240805120950mf983e97qac4cdfa2c84b6662@mail.gmail.com>
	 <1210617467.3792.4.camel@X61.DFGI.com>
	 <1ba2fa240805220953u746d3429q50faa1885104cadb@mail.gmail.com>
	 (sfid-20080522_185359_028598_D17C0097)  <1211478969.3698.56.camel@johannes.berg>
Content-Type: text/plain
Date: Thu, 22 May 2008 14:34:08 -0400
Message-Id: <1211481249.28022.15.camel@localhost.localdomain> (sfid-20080522_203433_525502_AD910734)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-05-22 at 19:56 +0200, Johannes Berg wrote:
> >         memset(&iwe, 0, sizeof(iwe));
> >         iwe.cmd = SIOCGIWFREQ;
> > -       iwe.u.freq.m = bss->freq;
> > -       iwe.u.freq.e = 6;
> > +       iwe.u.freq.m = ieee80211_frequency_to_channel(bss->freq);
> > +       iwe.u.freq.e = 0;
> >         current_ev = iwe_stream_add_event(current_ev, end_buf, &iwe,
> >                                           IW_EV_FREQ_LEN);
> > 
> >         memset(&iwe, 0, sizeof(iwe));
> >         iwe.cmd = SIOCGIWFREQ;
> > -       iwe.u.freq.m = ieee80211_frequency_to_channel(bss->freq);
> > -       iwe.u.freq.e = 0;
> > +       iwe.u.freq.m = bss->freq;
> > +       iwe.u.freq.e = 6;
> >         current_ev = iwe_stream_add_event(current_ev, end_buf, &iwe,
> >                                           IW_EV_FREQ_LEN);
> 
> That doesn't make any sense, can you explain?

Explanation:

wpa_supplicant cannot handle A-band channel #s.  Thus, with the previous
code, the FREQ+frequency was sent first, and the FREQ+channel was sent
second.  Sending the FREQ+channel second made the supplicant overwrite
the value it already parsed from the FREQ+frequency for that BSSID.  But
since the supplicant can't handle A-band channel #s, you end up with 0.

Reversing the order of these two makes it work, but it's a total hack.
That may be what's needed right now though until everyone fixes their
supplicant.  There's overlap on A-band channels 7 - 12 (5035MHz ->
5060MHz) with B/G band channel #s.  Obviously WEXT falls over here
because the band isn't passed.

But what's the best fix to the supplicant?  It could just parse A-band
channels and where the numbers overlap, assume B/G band.  Or, it could
be patched to prefer FREQ+frequency over FREQ+channel if it received
both.  That's probably the best solution.

Dan

