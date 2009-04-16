Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:52770 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753506AbZDPDG3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2009 23:06:29 -0400
Date: Wed, 15 Apr 2009 19:51:06 -0700
From: Greg KH <greg@kroah.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Forest Bond <forest@alittletooquiet.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Marcel Holtmann <marcel@holtmann.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Add vt6656 driver to drivers/staging.
Message-ID: <20090416025106.GB4806@kroah.com> (sfid-20090416_050651_397932_B1434F5E)
References: <20090414105200.GE25746@storm.local.network> <1239707258.4778.3.camel@johannes.local> <20090414113928.GA20470@storm.local.network> <1239709727.4778.6.camel@johannes.local> <1239712106.11795.21.camel@violet> <1239713034.17109.10.camel@johannes.local> <20090414130248.GA3291@tuxdriver.com> <20090414141852.GB20470@storm.local.network> <20090415011020.GC10045@kroah.com> <1239810213.22532.21.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1239810213.22532.21.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 15, 2009 at 11:43:33AM -0400, Dan Williams wrote:
> On Tue, 2009-04-14 at 18:10 -0700, Greg KH wrote:
> > On Tue, Apr 14, 2009 at 10:19:06AM -0400, Forest Bond wrote:
> > > Hi,
> > > 
> > > On Tue, Apr 14, 2009 at 09:02:48AM -0400, John W. Linville wrote:
> > > > On Tue, Apr 14, 2009 at 02:43:54PM +0200, Johannes Berg wrote:
> > > > > Hi Marcel,
> > > > > 
> > > > > > just to document the irony here. Two or three years ago at OLS, Kyle and
> > > > > > Greg were making fun of Ubuntu merging its 5th wireless stack into their
> > > > > > kernel. Now the staging crap is doing exactly the same.
> > 
> > Yes we are.  But we are doing it correctly :)
> > 
> > Turns out that people actually want to use their hardware, and no one
> > else was working on merging these drivers, so that is what staging is
> > for.
> 
> If nobody else was working on merging them, then adding them to staging
> isn't magically going to make people step up and rewrite the drivers
> into a state where they *can* actually be merged.
> 
> The solution isn't to drag crap drivers that have no hope of getting
> merged without a major rewrite into the kernel, the solution is to get
> manufacturers to write drivers that don't suck.  And staging doesn't
> help that at all; it doesn't encourage manufacturers to stop pushing out
> crap.
> 
> The only fixes that drivers are getting in staging now are netdev_ops,
> whitespace cleanups, and trivial fixes.  Nobody is actually rewriting
> the Ralink or Via staging drivers to use mac80211, which is what's
> needed for them to be merged.  Given that they are going nowhere, are
> you going to drop them after 6 months of no substantial contributions
> that advance their mergability?  Or are they going to sit around in
> staging forever, sapping away focus and resources that could be better
> spent moving wireless forward instead of fixing up a dead-end?

I've been pointing people at the community-based ralink drivers, that is
why there is only minor cleanups for those drivers.  That is what the
linux-wireless developers wanted me to do, so to claim that people are
not cleaning them up is totally unfair.

> (yes, some wireless drivers in staging are getting attention, but they
> are 95% NOT vendor drivers; they are community-originated drivers like
> at76_usb or stlc45xx that were written to use mac80211 in the first
> place)

I had patches that added mac80211 to one driver in staging that a
wireless developer asked me to revert.  So it is happening.

Again, it seems that if there is a community driver, people will help
out with it and let the staging one lie for a while, until it gets
dropped.  Which is what I was told the wireless developers _wanted_ to
have happen.  So don't complain if exactly what you all wanted to happen
is now happening...

As for the via driver, if there is no community driver, and people can
find the hardware, let's see what happens.

thanks,

greg k-h
