Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:44022 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753637AbYJ2QeW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 12:34:22 -0400
Date: Wed, 29 Oct 2008 09:30:27 -0700
From: Greg KH <greg@kroah.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Thorsten Leemhuis <fedora@leemhuis.info>,
	rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: Re: rtl2860 driver in mainline?
Message-ID: <20081029163027.GA20440@kroah.com> (sfid-20081029_173441_201743_56407819)
References: <20081028004915.GA3442@kroah.com> <4906B944.4010105@leemhuis.info> <1225180598.3796.66.camel@johannes.berg> <43e72e890810280102i3df34e2h9bf281c5d1e00a48@mail.gmail.com> <1225181562.3796.76.camel@johannes.berg> <20081028170838.GA4818@kroah.com> <1225218952.3598.39.camel@johannes.berg> <20081028224535.GA27948@kroah.com> <1225275184.28968.13.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1225275184.28968.13.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 29, 2008 at 06:13:04AM -0400, Dan Williams wrote:
> On Tue, 2008-10-28 at 15:45 -0700, Greg KH wrote:
> > On Tue, Oct 28, 2008 at 07:35:52PM +0100, Johannes Berg wrote:
> > > On Tue, 2008-10-28 at 10:08 -0700, Greg KH wrote:
> > > 
> > > > "Work on", or "USE".
> > > > 
> > > > The problem is, users have this hardware, and they want to run Linux on
> > > > it.  Many distros already support this hardware with the "crap" driver,
> > > > so we might as well add that to the kernel tree so they at least get the
> > > > latest "crap" so that users have an easier time of it.
> > > > 
> > > > Now, the fact that there is a competing driver being developed outside
> > > > of the tree does make this a bit more complicated.  However, as it
> > > > doesn't work yet, there's not much we can do about including it, right?
> > > > 
> > > > So adding the driver to the "crap" tree makes users happy in that they
> > > > can use their hardware.  I'll support the "crap" to a point, and no one
> > > > has to do any API changes to the drivers/staging/ tree either, I can
> > > > easily handle that.
> > > > 
> > > > Then, when the "correct" driver is finished, I will drop the crap driver
> > > > at the same time the "correct" one is added to the tree.
> > > > 
> > > > This way, everyone wins, right?
> > > 
> > > Only if the point is "use" rather than "work on". As far as I understood
> > > about staging, the point was more "work on" which would direct effort to
> > > the wrong driver.
> > 
> > I'm not going to turn away patches that people send me to get the stable
> > drivers cleaned up and in better shape.
> > 
> > I've now added the rtl2860 driver to the staging tree with a big note
> > that any comments should be made to me only, and that the wireless
> > developers would really have people work on their driver instead to get
> > it into a mergable state.
> 
> Who's going to support this driver now that you're essentially
> green-lighting distros to ship it?

The same people that were supporting it yesterday, when the distros were
shipping it already :)

And if the distros don't want to, I will, like everything else in the
staging tree (hint, see the MAINTAINER entry in the kernel tree...)

If a distro doesn't want to enable it, then they will not do so, that is
their choice.

> I seriously disagree with this decision to add rtl2860.  Adding
> drivers like at76_usb is fine because those are the drivers that
> people should be working on.  But adding crap code just because it
> gets people's hardware working, but that has NO FUTURE in the wireless
> tree, is misguided at best.

Hm, so, you are really saying that if we get users hardware working,
that is a misguided effort?

That's sad.

> If we just wanted to get everyone's hardware "working" [1], why aren't
> we shipping ndiswrapper?  At least add a "TAINT_STAGING" flag so that
> when people _run_ the crappy code and report errors the wireless
> developers are aware of it right off the bat.

I take it you haven't even looked at the staging tree.  If you load any
module in it, you taint your kernel with "TAINT_CRAP" and you get a
message in your syslog saying that this driver isn't supported and you
might have problems.

I have noted your objection to adding this driver to the Kconfig entry
for it.

thanks,

greg k-h
