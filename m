Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:46368 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754931AbZDOPmk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2009 11:42:40 -0400
Subject: Re: [PATCH] Add vt6656 driver to drivers/staging.
From: Dan Williams <dcbw@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: Forest Bond <forest@alittletooquiet.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Marcel Holtmann <marcel@holtmann.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090415011020.GC10045@kroah.com>
References: <20090414105200.GE25746@storm.local.network>
	 <1239707258.4778.3.camel@johannes.local>
	 <20090414113928.GA20470@storm.local.network>
	 <1239709727.4778.6.camel@johannes.local> <1239712106.11795.21.camel@violet>
	 <1239713034.17109.10.camel@johannes.local>
	 <20090414130248.GA3291@tuxdriver.com>
	 <20090414141852.GB20470@storm.local.network>
	 <20090415011020.GC10045@kroah.com>
Content-Type: text/plain
Date: Wed, 15 Apr 2009 11:43:33 -0400
Message-Id: <1239810213.22532.21.camel@localhost.localdomain> (sfid-20090415_174252_403304_CF095E10)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-04-14 at 18:10 -0700, Greg KH wrote:
> On Tue, Apr 14, 2009 at 10:19:06AM -0400, Forest Bond wrote:
> > Hi,
> > 
> > On Tue, Apr 14, 2009 at 09:02:48AM -0400, John W. Linville wrote:
> > > On Tue, Apr 14, 2009 at 02:43:54PM +0200, Johannes Berg wrote:
> > > > Hi Marcel,
> > > > 
> > > > > just to document the irony here. Two or three years ago at OLS, Kyle and
> > > > > Greg were making fun of Ubuntu merging its 5th wireless stack into their
> > > > > kernel. Now the staging crap is doing exactly the same.
> 
> Yes we are.  But we are doing it correctly :)
> 
> Turns out that people actually want to use their hardware, and no one
> else was working on merging these drivers, so that is what staging is
> for.

If nobody else was working on merging them, then adding them to staging
isn't magically going to make people step up and rewrite the drivers
into a state where they *can* actually be merged.

The solution isn't to drag crap drivers that have no hope of getting
merged without a major rewrite into the kernel, the solution is to get
manufacturers to write drivers that don't suck.  And staging doesn't
help that at all; it doesn't encourage manufacturers to stop pushing out
crap.

The only fixes that drivers are getting in staging now are netdev_ops,
whitespace cleanups, and trivial fixes.  Nobody is actually rewriting
the Ralink or Via staging drivers to use mac80211, which is what's
needed for them to be merged.  Given that they are going nowhere, are
you going to drop them after 6 months of no substantial contributions
that advance their mergability?  Or are they going to sit around in
staging forever, sapping away focus and resources that could be better
spent moving wireless forward instead of fixing up a dead-end?

(yes, some wireless drivers in staging are getting attention, but they
are 95% NOT vendor drivers; they are community-originated drivers like
at76_usb or stlc45xx that were written to use mac80211 in the first
place)

Dan

> > Well, gosh, I understand the criticism here and if I were a kernel developer I
> > imagine my perspective would be much the same.  But I can't help but feel that
> > there's some amount of hypocrisy when we hammer on a manufacturer to properly
> > license their driver and then let it drop dead when they do.
> 
> I agree.
> 
> > I understand that the problem would be solved if they manufacturers would
> > suddenly "get it," but the scale of social problem preventing that is likely too
> > large to change anytime soon.
> 
> Agreed.
> 
> > If kernel developers are too busy to support the hardware, why do the
> > manufacturers take so much criticism for releasing binary-only drivers or badly
> > licensed drivers, or for neglecting to release technical specifications?  If
> > what I'm sensing is correct and there's no practical likelihood of these devices
> > getting in-kernel support even with those issues resolved, the criticism almost
> > seems unjustified.
> > 
> > I appreciate what the kernel developers do, of course, and my intention is not
> > to ruffle feathers.  But when a manufacturer that has taken a lot of criticism
> > for its approach to the Linux community shows some good will, it seems like we
> > ought to be able to turn that into something productive.  If we can't, what have
> > we been complaining about?
> > 
> > My apologies if I'm way off on this.  I haven't been around all that long so it
> > is certainly possible.
> 
> You aren't way off at all.
> 
> Thanks for the patches, I'll get to them in a few days when my "real
> job" calms down a bit.  They're now in my queue, and will not get lost.
> 
> thanks,
> 
> greg k-h

