Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26049 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752535AbZJWQ3D (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2009 12:29:03 -0400
Subject: Re: [PATCH 17/19] [RFC, v2] libertas: Kconfig entry for
 libertas+cfg80211
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <1256313851.12174.131.camel@johannes.local>
References: <20091022133043.185554096@mail.mn-solutions.de>
	 <20091022133425.317619132@mail.mn-solutions.de>
	 <1256307572.12174.33.camel@johannes.local>
	 <1256312995.2164.7.camel@localhost.localdomain>
	 <1256313851.12174.131.camel@johannes.local>
Content-Type: text/plain
Date: Fri, 23 Oct 2009 09:28:55 -0700
Message-Id: <1256315335.2164.44.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-10-23 at 18:04 +0200, Johannes Berg wrote:
> On Fri, 2009-10-23 at 08:49 -0700, Dan Williams wrote:
> 
> > > -	(iw_handler) lbs_set_freq,      /* SIOCSIWFREQ */
> > > +	(iw_handler) cfg80211_wext_siwfreq,
> > > 
> > > etc.
> > > 
> > > That's why those exist and are exported. And that way you don't need the
> > > Kconfig at all, and can remove most of the wext code.
> > 
> > I *think* because Holger is trying to keep WEXT around for a bit,
> > because cfg80211 won't be mature enough yet (IMHO, I could be wrong) by
> > 2.6.33, and because it doesn't support the OLPC-style mesh stuff and the
> > libertas monitor interface code.  There's a few loose-ends that need to
> > be tied up before a cfg80211 conversion would completely replace the
> > functionality of the WEXT code.
> 
> I just don't understand why he thinks that wext and cfg80211 need to be
> mutually exclusive. cfg80211 has exported its handlers for exactly this
> purpose, so that you could have everything that cfg80211 supports via
> it, and everything else directly.

I thought about it more, and I think we can go all cfg80211 with a small
WEXT handler for the mesh bits (it only cares about 4 of the WEXT
operations and redirected the rest to the STA interface handlers).  The
mesh stuff is actually quite simple operationally.

Dan

