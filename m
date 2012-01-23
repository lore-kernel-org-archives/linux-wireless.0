Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:49379 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753351Ab2AWQ3p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jan 2012 11:29:45 -0500
Date: Mon, 23 Jan 2012 11:29:43 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: Hauke Mehrtens <hauke@hauke-m.de>, Greg KH <greg@kroah.com>
cc: ralf@linux-mips.org, <linux-mips@linux-mips.org>,
	USB list <linux-usb@vger.kernel.org>, <zajec5@gmail.com>,
	<linux-wireless@vger.kernel.org>, <m@bues.ch>, <george@znau.edu.ua>
Subject: Re: [PATCH 4/7] USB: EHCI: Add a generic platform device driver
In-Reply-To: <20120122192346.GA1691@kroah.com>
Message-ID: <Pine.LNX.4.44L0.1201231115280.1372-100000@iolanthe.rowland.org> (sfid-20120123_172951_046078_67156763)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 22 Jan 2012, Greg KH wrote:

> On Sun, Jan 22, 2012 at 04:02:13PM +0100, Hauke Mehrtens wrote:
> > On 01/22/2012 04:41 AM, Alan Stern wrote:
> > > On Sat, 21 Jan 2012, Hauke Mehrtens wrote:
> > > 
> > >> This adds a generic driver for platform devices. It works like the PCI
> > >> driver and is based on it. This is for devices which do not have an own
> > >> bus but their EHCI controller works like a PCI controller. It will be
> > >> used for the Broadcom bcma and ssb USB EHCI controller.
> > > 
> > > Before adding a generic platform driver for EHCI, you should give some
> > > to thought to how it might be generalized.  There are a lot of EHCI
> > > platform drivers, all differing in various major or minor respects.  
> > > It should be possible to replace a lot of them with the generic driver, 
> > > but first it will need some way to cope with a few minor quirks.
> > > 
> > > Please consider this, and think about which of the existing drivers 
> > > could be replaced.
> > 
> > For now I just build this for bcma and ssb based SoCs. Yes there are
> > some drivers which could be replaced with this one, but most (all ??) of
> > them do something special in the device probing and this have to be
> > moved to somewhere else e.g. where the platform device is created.
> > I could rename it so it would not be generic any more, but I think it is
> > the wrong approach. ;-)
> > I am not able and do not have the time to convert all EHCI platform
> > drivers, where it is possible  to this generic platform driver, as I do
> > not have the devices to test this and time is limited.
> 
> Time is not limited for us, sorry, this seems like the correct thing to
> do, and because of that, we (well I at least) will not accept this patch
> as-is.
> 
> Please go rework it to be as Alan suggested.
> 
> > If someone else wants to improve something on these "generic" platform
> > drivers to make them work with an other device I am totally fine with it.
> 
> I think that someone just became you :)
> 
> Yes, this isn't fair, but it's how Linux kernel development works,
> sorry.

The work doesn't have to be all done right away.  Still, I think it 
makes sense to separate out the "generic platform" drivers from the 
rest of this patch series.

Some platform drivers require additional storage for things like
pointers to clocks or OTG transceivers.  For example see ehci-mv.c,
which allocates its own ehci_hcd_mv structure along with ehci_hcd.  
Some other drivers even define their own private version of ehci_hcd,
such as ehci-fsl.c.  If you can figure out a good way to expend the
ehci_hcd structure so that it can accomodate the extra fields needed by
all these drivers in a generic way, that would be an excellent start
and well worth merging.  Maybe just adding a "void *platform_data"
field would be enough.

As for special activities during device probing...  Many of these can 
be handled later on, easily enough, by adding appropriate quirk flags.  
We don't have to worry about that part right now.

Alan Stern

