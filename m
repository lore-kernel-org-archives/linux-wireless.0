Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:45929 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734Ab1A0XMR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jan 2011 18:12:17 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] subtle pm_runtime_put_sync race and sdio functions
Date: Fri, 28 Jan 2011 00:11:50 +0100
Cc: Kevin Hilman <khilman@ti.com>, "Ohad Ben-Cohen" <ohad@wizery.com>,
	linux-pm@lists.linux-foundation.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org,
	Ido Yariv <ido@wizery.com>
References: <Pine.LNX.4.44L0.1101271158530.2090-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1101271158530.2090-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201101280011.50602.rjw@sisk.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, January 27, 2011, Alan Stern wrote:
> On Wed, 26 Jan 2011, Kevin Hilman wrote:
> 
> > >> Consider this instead:  Since A is required to be functional before B
> > >> can be used, A must be registered before B and hence B gets suspended
> > >> before A.  Therefore during the prepare phase we can runtime-resume A
> > >> and leave it powered up; when B needs to suspend, it won't matter that
> > >> the runtime-PM calls are ineffective.
> > >
> > > We don't really need to do that, because the runtime resume _is_ functional
> > > during system suspend.
> 
> Not asynchronous runtime resume, because the workqueue is frozen.  But 
> that's not the issue here.
> 
> > >  The only thing missing is a ->suspend() callback for A
> > > (and a corresponding ->resume() callback to make sure A will be available to
> > > B during system resume).
> > >
> > 
> > OK, I'm finally back to debugging this problem and looking for a final
> > solution.
> > 
> > I agree that what is needed is ->suspend() and ->resume() callbacks for
> > A, but the question remains how to implement them.
> > 
> > In my case, A doesn't need runtime callbacks, but *does* require that
> > the subsystem callbacks are called because the subsystem actually does
> > all the real PM work.  On OMAP, the device PM code (clock mgmt, device
> > low-power states, etc.) is common for all on-chip devices, so is handled
> > in common code at the subsystem level (in this case, platform_bus.)
> > 
> > Therefore, what is ideally needed is the ability for A's suspend to
> > simply call pm_runtime_suspend() so the subsystem can do the work.
> > However, since runtime transitions are locked out by this time, that
> > doesn't work.  IOW, what is needed is a way for a system suspend to say
> > "please finish the runtime suspend that was already requested."
> 
> Calling the runtime_suspend method directly is the way to do it.
> 
> > What I've done to work around this in driver A is to manually check
> > pm_runtime_suspended() and directly call the subsystem's runtime
> > suspend/resume (patch below[1].  NOTE, I've used the _noirq methods to
> > ensure device A is available when device B needs it.)
> 
> Hmm.  The pm_runtime_suspended() check may not be needed (if A were
> suspended already then B would have encountered problems).  But
> including it doesn't hurt.
> 
> Using the _noirq method isn't a good idea, unless you know for certain 
> that the runtime_suspend handler doesn't need to sleep.

That requirement is long gone, because timer interrupts are still enabled
when the _noirq() callbacks are run.  The _noirq part means that the driver's
own interrupt handler is guaranteed not to run concurrently with the routines
(unless this also is a timer interrupt, that is).

Rafael
