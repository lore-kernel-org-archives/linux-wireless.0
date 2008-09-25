Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53944 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624AbYIYAiZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Sep 2008 20:38:25 -0400
Date: Wed, 24 Sep 2008 20:39:31 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wireless: consolidate on a single escape_essid
	implementation
Message-ID: <20080925003931.GB3496@tuxdriver.com> (sfid-20080925_023841_026589_7304223E)
References: <1222294536-24367-1-git-send-email-linville@tuxdriver.com> <20080924232453.GG9187@tesla> <20080924233234.GE3639@tuxdriver.com> <20080925002117.GH9187@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080925002117.GH9187@tesla>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 24, 2008 at 05:21:17PM -0700, Luis R. Rodriguez wrote:
> On Wed, Sep 24, 2008 at 04:32:34PM -0700, John W. Linville wrote:
> > On Wed, Sep 24, 2008 at 04:24:53PM -0700, Luis R. Rodriguez wrote:
> > > On Wed, Sep 24, 2008 at 03:15:36PM -0700, John W. Linville wrote:
> > > > This is also an excuse to create the long rumored lib80211 module...
> > >
> > > How about stuffing it in something like:
> > >
> > > include/linux/wlandevice.h
> > >
> > > Is there a benefit to having a module for it as this time?
> > 
> > The escape_essid function is currently not inlined.  Are you
> > arguing that it should be?
> 
> Just an idea, yes, but that's just because it didn't seem
> that escape_essid() in itself was enough reason to create a
> shiny new module.

Is there some huge cost I'm overlooking?  If you are afraid of wasting
a page then build it into the kernel.  Hopefully this module eventually
gets bigger anyway.

> > Otherwise it needs to live _somewhere_.
> > The cfg80211 module might make sense, except that the libertas,
> > ipw2100, and ipw2200 drivers don't use cfg80211 (at least for now).
> 
> If we want a framework for FullMAC drivers I think cfg80211
> can play that role just fine as I believe it was designed that way.
> We could potentialy just add non-wiphy helper routines in there for now
> as well if all we need is a home for them. What if we want to make
> use of some of these in other cfg80211 drivers or maybe mac80211?

Nothing stops that whether or not they are in a different module.

> > Besides, you have to start _somewhere_.  I have a feeling that this
> > happened in the first place because there was nowhere for drivers to
> > share bits of code like this (other than mac80211 or iee80211).
> 
> Agreed, although I do like to think cfg80211 can play this role
> as well, unless we want to remain strict about requiring a wiphy
> for all its callers.

Sure, it could.  Does it make a difference?

<snip>

> > I figure there are probably other bits that can be shared, but most of
> > them probably require at least _some_ recoding.  This is a no-brainer
> > and it "breaks the ice" for more follow-on work.
> 
> Sure, my vote goes towards cfg80211 with helpers which are non wiphy specific.
> The reason being that these drivers *could* also potentially be ported
> to use cfg80211 eventually and in fact I think this should be encouraged
> to help cfg80211 move forward to support them and so eventually
> [if/once] we have a Linux 3.0 we can ditch Wireless Extensions
> completely.
> 
> I think an lib80211 would provide for more excuses for people to stuff
> things in there and help them never cross the line into cfg80211.

I don't really see where this affects that.  What are 'they' going
to stuff in there as an alternative to cfg80211 anyway?  If drivers
suddenly find ways to share WEXT code, that would seem to make
migrating them to cfg80211 that much easier.

In the meantime, this is currently my bikeshed and I'd prefer to
paint it like this. :-)

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
