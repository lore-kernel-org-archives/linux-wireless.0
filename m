Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:34534 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753267AbYJ1PBc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 11:01:32 -0400
Subject: Re: rtl2860 driver in mainline?
From: Dan Williams <dcbw@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: Ivo Van Doorn <ivdoorn@gmail.com>,
	rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
In-Reply-To: <20081028061023.GA6568@kroah.com>
References: <20081028004915.GA3442@kroah.com>
	 <a32f33a40810272248j5ee755ccoc8f6a8c8d5338cb8@mail.gmail.com>
	 <20081028061023.GA6568@kroah.com>
Content-Type: text/plain
Date: Tue, 28 Oct 2008 10:59:57 -0400
Message-Id: <1225205997.2387.12.camel@localhost.localdomain> (sfid-20081028_160138_377463_4115E780)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-10-27 at 23:10 -0700, Greg KH wrote:
> On Tue, Oct 28, 2008 at 06:48:31AM +0100, Ivo Van Doorn wrote:
> > Hi,
> > 
> > > So, on my quest to suck up every out-of-tree driver and get it into the
> > > main kernel tree (drivers/staging/ to start with), I've been pointed at
> > > the rtl2860 driver.
> > 
> > in that case make sure you include rt2870 on your list as well then. ;)
> 
> Do you have a pointer to it?
> 
> > > Does anyone know of a "cleaned up" version of this driver that is
> > > newer/better than the one on ralink's web site?  I found the
> > > 2008_0918_RT2860_Linux_STA_v1.8.0.0.tar.bz2 version there, and will
> > > start with that if no one else has yet.
> > 
> > rt2800pci/rt2800usb development is in progress in the rt2x00.git
> > experimental branch:
> > http://git.kernel.org/?p=linux/kernel/git/ivd/rt2x00.git;a=shortlog;h=experimental
> > 
> > The current status is that rt2800usb has working RX with some warnings
> > regarding the
> > RX signal, and a non functional TX. rt2800pci isn't complete yet.
> > 
> > So far progress has been very slow because of lack of time, so any help with the
> > development of the drivers is welcome.
> 
> Is this a port of the tarball driver to the in-kernel wireless stack, or
> starting over from scratch?
> 
> As it's not really working, do you mind if I just dump the tarball
> driver into the staging tree for users to use now (hint, they already
> are, the distros are shipping that driver as a kernel module package),
> and then when this "real" driver is up and working properly, we can drop
> the staging version?

Seriously, how does including this help _anybody_ beyond today?  The
vendor driver is not going to get upstream, and shipping it in staging
suggests that people help fix the vendor driver there, not work on the
driver that will actually go upstream.

staging drivers are supposed to eventually go "mainstream" if somebody
fixes them up, right?  So how does cramming in a driver that will go
nowhere help anyone in the medium or long term?  Should we have shipped
madwifi with the open HAL in staging while ath5k was getting brought up
to speed?  Would that have taken effort away from ath5k?

I highly respect the work that you're doing with staging, but just
because the driver is out of tree doesn't mean that it'll ever go
mainline, and that including some drivers will just sap effort from
where it's needed.  Cleaning up crappy vendor driver code is _not_ where
the effort is needed.  We have a higher standard of quality.

Dan


