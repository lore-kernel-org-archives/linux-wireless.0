Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12332 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719Ab0IOF2s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 01:28:48 -0400
Subject: Re: [ANN] Full-source Broadcom wireless driver for 11n chips
From: Dan Williams <dcbw@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: Mike Rapoport <mike@compulab.co.il>,
	Henry Ptasinski <henryp@broadcom.com>,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
In-Reply-To: <20100913154227.GB24563@kroah.com>
References: <20100908150322.17dac9c3@nehalam>
	 <20100908225132.GA12490@kroah.com> <4C88F8CE.5090708@broadcom.com>
	 <4C8DD9F4.5090305@compulab.co.il>  <20100913154227.GB24563@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Sep 2010 00:31:18 -0500
Message-ID: <1284528678.10728.16.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-09-13 at 08:42 -0700, Greg KH wrote:
> On Mon, Sep 13, 2010 at 09:59:48AM +0200, Mike Rapoport wrote:
> > Hi Henry,
> > 
> > Henry Ptasinski wrote:
> > >Broadcom would like to announce the initial release of a fully-open
> > >Linux driver for it's latest generation of 11n chipsets.  The driver,
> > >while still a work in progress, is released as full source and uses the
> > >native mac80211 stack.   It supports multiple current chips (BCM4313,
> > >BCM43224, BCM43225) as well as providing a framework for supporting
> > >additional chips in the future, including mac80211-aware embedded chips.
> > >  The README and TODO files included with the sources provide more
> > >details about the current feature set, known issues, and plans for
> > >improving the driver.
> > >
> > >The driver is currently available in staging-next git tree, available at:
> > >
> > >    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-next-2.6.git
> > >
> > >
> > >in the drivers/staging/brcm80211 directory.
> > 
> > Are there any plans to support BCM4319 and BCM4329 SDIO chipsets?
> 
> I think those are supported by the broadcom driver in the android kernel
> trees, right?  If so, yes, there are plans for merging them into the
> main kernel tree, and any help you can provide would be appreciated.

That driver is convoluted; it's going to be a lot of work.  There are
simply too  many abstraction layers for one; I had to touch about 5
functions in 4 files just to get the driver to pass its 'struct device'
from the SDIO probe functions to where it called alloc_etherdev() so
that it called SET_NETDEV_DEV() so that its sysfs 'driver' link was
correctly set up.  I hope somebody is getting paid to do the cleanup :)

Dan


