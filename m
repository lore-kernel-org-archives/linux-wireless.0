Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:52322 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753634AbYJ1SUV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 14:20:21 -0400
Date: Tue, 28 Oct 2008 10:08:38 -0700
From: Greg KH <greg@kroah.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Thorsten Leemhuis <fedora@leemhuis.info>,
	rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: Re: rtl2860 driver in mainline?
Message-ID: <20081028170838.GA4818@kroah.com> (sfid-20081028_192026_585252_C4BB7E3D)
References: <20081028004915.GA3442@kroah.com> <4906B944.4010105@leemhuis.info> <1225180598.3796.66.camel@johannes.berg> <43e72e890810280102i3df34e2h9bf281c5d1e00a48@mail.gmail.com> <1225181562.3796.76.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1225181562.3796.76.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 28, 2008 at 09:12:42AM +0100, Johannes Berg wrote:
> On Tue, 2008-10-28 at 01:02 -0700, Luis R. Rodriguez wrote:
> 
> > > I don't think it makes sense either, at _best_ it'll do nothing but help
> > > a few users [1], and if somebody actually starts working on the vendor
> > > driver because it's in staging that's actively harmful to the real
> > > driver by diverting resources away from it.
> > >
> > > johannes
> > >
> > > [1] I used to think the point wasn't to make users happy but to make it
> > > easier to work on those drivers, but that objective seems long gone
> > 
> > Problem is distributions already ship crap anyway.
> 
> Well, yes, but that's fine, it doesn't mean people will work on the
> crap, it means people will use the crap. As far as I understood, putting
> it into staging was supposed to mean "here is some crap for people to
> work on", which is a huge difference.

"Work on", or "USE".

The problem is, users have this hardware, and they want to run Linux on
it.  Many distros already support this hardware with the "crap" driver,
so we might as well add that to the kernel tree so they at least get the
latest "crap" so that users have an easier time of it.

Now, the fact that there is a competing driver being developed outside
of the tree does make this a bit more complicated.  However, as it
doesn't work yet, there's not much we can do about including it, right?

So adding the driver to the "crap" tree makes users happy in that they
can use their hardware.  I'll support the "crap" to a point, and no one
has to do any API changes to the drivers/staging/ tree either, I can
easily handle that.

Then, when the "correct" driver is finished, I will drop the crap driver
at the same time the "correct" one is added to the tree.

This way, everyone wins, right?

thanks,

greg k-h
