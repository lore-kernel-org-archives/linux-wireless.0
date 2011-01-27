Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:45946 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753750Ab1A0XVy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jan 2011 18:21:54 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kevin Hilman <khilman@ti.com>
Subject: Re: [linux-pm] subtle pm_runtime_put_sync race and sdio functions
Date: Fri, 28 Jan 2011 00:21:14 +0100
Cc: Alan Stern <stern@rowland.harvard.edu>,
	"Ohad Ben-Cohen" <ohad@wizery.com>,
	linux-pm@lists.linux-foundation.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org,
	Ido Yariv <ido@wizery.com>
References: <Pine.LNX.4.44L0.1101271439020.2090-100000@iolanthe.rowland.org> <87tyguje7j.fsf@ti.com>
In-Reply-To: <87tyguje7j.fsf@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201101280021.14344.rjw@sisk.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, January 27, 2011, Kevin Hilman wrote:
> Alan Stern <stern@rowland.harvard.edu> writes:
> 
> > On Thu, 27 Jan 2011, Kevin Hilman wrote:
> >
> >> > Calling the runtime_suspend method directly is the way to do it.
> >> >
> >> 
> >> Do you mean the driver's runtime_suspend method, or the subsystem's
> >> runtime_suspend method?
> >
> > The subsystem's.  If the driver has a runtime_suspend method then the 
> > subsystem's method will call it.
> 
> Yes.  Thanks for the clarification.
> 
> >> >> While this works, I'm not crazy about it since it requires the driver
> >> >> know about the subsystem (in this case the bus) where the real PM work
> >> >> is done.  IMO, it would be much more intuitive (and readable) if the
> >> >> driver's suspend hooks could simply trigger a runtime suspend (either a
> >> >> new one, or one already requested.)
> >> >
> >> > This isn't clear to me.  Isn't the driver registered on the bus in 
> >> > question?  Can't the driver therefore call the bus's runtime_suspend 
> >> > routine directly, instead of dereferencing the bus->pm->runtime_suspend 
> >> > pointer?
> >> 
> >> Not sure what you mean by directly.  The platform_bus doesn't expose
> >> its runtime PM methods since they can be customized at runtime, so they
> >> have to be called via bus->pm.
> >> 
> >> Or do you mean using dev->driver instead of dev->bus?
> >
> > You're doing all of this for OMAP, right?  What is the subsystem's
> > runtime_suspend routine?  Is it omap_pm_runtime_suspend()?
> 
> Yes.
> 
> > If it is, then you can call omap_pm_runtime_suspend() directly instead
> > of calling dev->bus->pm->runtime_suspend().
> 
> Personally, I prefer going through dev->bus as we try to avoid SoC
> specific calls in the driver.
> 
> This same HW block might be re-used on non-OMAP SoCs (e.g. TI DaVinci)
> that would have different PM at the susbystem level.
> 
> So, to summarize, as long as folks are OK with drivers directly calling
> the subsystem runtime PM callbacks, I'll go this route.

This is perfectly fine as long as you ensure that they won't be called
concurrently through the runtime PM framework.

Thanks,
Rafael
