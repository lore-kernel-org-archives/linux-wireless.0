Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:60202 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752286Ab1A0TtC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jan 2011 14:49:02 -0500
Date: Thu, 27 Jan 2011 14:49:01 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: Kevin Hilman <khilman@ti.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Ohad Ben-Cohen <ohad@wizery.com>,
	<linux-pm@lists.linux-foundation.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
	Ido Yariv <ido@wizery.com>
Subject: Re: [linux-pm] subtle pm_runtime_put_sync race and sdio functions
In-Reply-To: <87hbcum9rh.fsf@ti.com>
Message-ID: <Pine.LNX.4.44L0.1101271439020.2090-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 27 Jan 2011, Kevin Hilman wrote:

> > Calling the runtime_suspend method directly is the way to do it.
> >
> 
> Do you mean the driver's runtime_suspend method, or the subsystem's
> runtime_suspend method?

The subsystem's.  If the driver has a runtime_suspend method then the 
subsystem's method will call it.

> >> While this works, I'm not crazy about it since it requires the driver
> >> know about the subsystem (in this case the bus) where the real PM work
> >> is done.  IMO, it would be much more intuitive (and readable) if the
> >> driver's suspend hooks could simply trigger a runtime suspend (either a
> >> new one, or one already requested.)
> >
> > This isn't clear to me.  Isn't the driver registered on the bus in 
> > question?  Can't the driver therefore call the bus's runtime_suspend 
> > routine directly, instead of dereferencing the bus->pm->runtime_suspend 
> > pointer?
> 
> Not sure what you mean by directly.  The platform_bus doesn't expose
> its runtime PM methods since they can be customized at runtime, so they
> have to be called via bus->pm.
> 
> Or do you mean using dev->driver instead of dev->bus?

You're doing all of this for OMAP, right?  What is the subsystem's
runtime_suspend routine?  Is it omap_pm_runtime_suspend()?

If it is, then you can call omap_pm_runtime_suspend() directly instead
of calling dev->bus->pm->runtime_suspend().

Alan Stern

