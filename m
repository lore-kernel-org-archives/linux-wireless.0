Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:38603 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751651AbYIYBwM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Sep 2008 21:52:12 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 24 Sep 2008 18:52:12 -0700
Date: Wed, 24 Sep 2008 18:52:06 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wireless: consolidate on a single escape_essid
	implementation
Message-ID: <20080925015206.GL9187@tesla> (sfid-20080925_035218_156561_BC96371D)
References: <1222294536-24367-1-git-send-email-linville@tuxdriver.com> <20080924232453.GG9187@tesla> <20080924233234.GE3639@tuxdriver.com> <20080925002117.GH9187@tesla> <20080925003931.GB3496@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20080925003931.GB3496@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 24, 2008 at 05:39:31PM -0700, John W. Linville wrote:
> Is there some huge cost I'm overlooking?  If you are afraid of wasting
> a page then build it into the kernel.  Hopefully this module eventually
> gets bigger anyway.

Like I said, just a thought, in general a module for just one routine
seems like complete overkill to me.

> > > Otherwise it needs to live _somewhere_.
> > > The cfg80211 module might make sense, except that the libertas,
> > > ipw2100, and ipw2200 drivers don't use cfg80211 (at least for now).
> >
> > If we want a framework for FullMAC drivers I think cfg80211
> > can play that role just fine as I believe it was designed that way.
> > We could potentialy just add non-wiphy helper routines in there for now
> > as well if all we need is a home for them. What if we want to make
> > use of some of these in other cfg80211 drivers or maybe mac80211?
> 
> Nothing stops that whether or not they are in a different module.

Right, but my point was more towards that if it lives in cfg80211
you don't have to have yet another module loaded -- specially for this
just one routine.

> > > Besides, you have to start _somewhere_.  I have a feeling that this
> > > happened in the first place because there was nowhere for drivers to
> > > share bits of code like this (other than mac80211 or iee80211).
> >
> > Agreed, although I do like to think cfg80211 can play this role
> > as well, unless we want to remain strict about requiring a wiphy
> > for all its callers.
> 
> Sure, it could.  Does it make a difference?

I don't see a point to a "lib80211" for just one routine for now.

> > > I figure there are probably other bits that can be shared, but most of
> > > them probably require at least _some_ recoding.  This is a no-brainer
> > > and it "breaks the ice" for more follow-on work.
> >
> > Sure, my vote goes towards cfg80211 with helpers which are non wiphy specific.
> > The reason being that these drivers *could* also potentially be ported
> > to use cfg80211 eventually and in fact I think this should be encouraged
> > to help cfg80211 move forward to support them and so eventually
> > [if/once] we have a Linux 3.0 we can ditch Wireless Extensions
> > completely.
> >
> > I think an lib80211 would provide for more excuses for people to stuff
> > things in there and help them never cross the line into cfg80211.
> 
> I don't really see where this affects that.  What are 'they' going
> to stuff in there as an alternative to cfg80211 anyway?  If drivers
> suddenly find ways to share WEXT code, that would seem to make
> migrating them to cfg80211 that much easier.

So what will lib80211 be then exactly? If its not some sort of
infrastructure for drivers then why not just stash useful generic
stuff into headers and where appropriate cfg80211? -- Why do we
need another module for this?

> In the meantime, this is currently my bikeshed and I'd prefer to
> paint it like this. :-)

Heh, this is why I said its just my vote.

  Luis
