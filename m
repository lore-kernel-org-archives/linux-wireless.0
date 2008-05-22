Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:52680 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755811AbYEVWHm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 18:07:42 -0400
Subject: Re: iwl4965 - wpa_supplicant can't see 5Ghz frequencies -
	2.6.26-rc1 kernel
From: Dan Williams <dcbw@redhat.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Vincent C Jones <v.jones@networkingunlimited.com>,
	linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <egrumbach@gmail.com>
In-Reply-To: <1ba2fa240805221356g681c49e4r9cd7f8c80f57801f@mail.gmail.com>
References: <1210352234.3763.23.camel@X61.NetworkingUnlimited.com>
	 <1ba2fa240805120950mf983e97qac4cdfa2c84b6662@mail.gmail.com>
	 <1210617467.3792.4.camel@X61.DFGI.com>
	 <1ba2fa240805220953u746d3429q50faa1885104cadb@mail.gmail.com>
	 <1211478969.3698.56.camel@johannes.berg>
	 <1211481249.28022.15.camel@localhost.localdomain>
	 <1ba2fa240805221151q2e53b069n6658c6cd7d6f4ba0@mail.gmail.com>
	 <1211483568.3698.66.camel@johannes.berg>
	 <1211484612.28022.31.camel@localhost.localdomain>
	 <1211484887.3698.75.camel@johannes.berg>
	 <1ba2fa240805221356g681c49e4r9cd7f8c80f57801f@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 22 May 2008 18:07:41 -0400
Message-Id: <1211494061.10742.3.camel@localhost.localdomain> (sfid-20080523_000749_191843_A20A2F87)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-05-22 at 23:56 +0300, Tomas Winkler wrote:
> On Thu, May 22, 2008 at 10:34 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> >
> >> > Fun. How about it we just make wpa supplicant ignore FREQ/channel
> >> > completely if it uses FREQ/frequency anyway?
> >>
> >> Can't because some drivers send channel and not frequency.  Yeah, we
> >> could fix all the drivers, but that doesn't help people running latest
> >> supplicant on older kernels.
> >
> > Oh, good point. I guess the patch you posted is the only sane thing to
> > do then, and require that drivers that work in the 5 GHz band send
> > frequency (because there channel numbers need not be unique due to
> > 802.11j's channelisation offset)
> >
> 
> Fix in the mac should go in as well in so it will work with older
> supplicants and it doesn't really hurt.

Yup.  Both parts (mac80211 FREQ re-order, and supplicant patch) should
be applied.

Dan

