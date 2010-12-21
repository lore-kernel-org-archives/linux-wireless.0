Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:44137 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751280Ab0LUVc5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Dec 2010 16:32:57 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] subtle pm_runtime_put_sync race and sdio functions
Date: Tue, 21 Dec 2010 22:31:57 +0100
Cc: "Ohad Ben-Cohen" <ohad@wizery.com>,
	linux-pm@lists.linux-foundation.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org,
	Ido Yariv <ido@wizery.com>,
	Kevin Hilman <khilman@deeprootsystems.com>
References: <Pine.LNX.4.44L0.1012201946330.19558-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1012201946330.19558-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201012212231.57420.rjw@sisk.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, December 21, 2010, Alan Stern wrote:
> On Mon, 20 Dec 2010, Rafael J. Wysocki wrote:
> 
> > > > In that case, if a device if flagged as "runtime only", we can avoid
> > > > calling pm_runtime_get_noirq() for it in dpm_prepare() and, analogously,
> > > > calling pm_runtime_put_sync() for it in dpm_complete().  However, we will have
> > > > to fail system suspend (or hibernation) if a "runtime only" device has the
> > > > power.runtime_auto flag unset.
> > > 
> > > Or more generally, if pm_runtime_suspended() doesn't return 'true' for 
> > > the device.
> > 
> > That's not necessary, because the device may be suspended using
> > pm_runtime_suspend() later than we check pm_runtime_suspended().
> 
> What if the device has a child in the RPM_ACTIVE state?  Then 
> pm_runtime_suspend() won't do anything, even if the child really is 
> dpm-suspended.

Well, in fact I was thinking of leaf devices.  Following all of the children
for non-leaf devices would pretty much nullify the whole possible gain.

> > I'd use the "runtime only" (or perhaps better "no_dpm") flag as a declaration
> > (if set) that the device is going to be suspended with the help of "runtime"
> > callbacks and the driver takes the responsibility for getting things right.
> 
> I'm still not sure about this; the design isn't clear.  Are these
> runtime callbacks going to come from the PM core or from the driver?  
> If from the driver, how will the driver know when to issue them?  What
> about coordinating async suspends (the device must be suspended after
> its children and before its parent)?

It basically goes like this.  There's device A that is only resumed when it's
needed to carry out an operation and is suspended immediately after that.
There's another device B that needs A to do something during its suspend.
So, when the suspend of B is started, A is woken up, does its work and is
suspended again (using pm_runtime_suspend()).  Then B is suspended.

We currently require that ->suspend() and ->resume() callbacks be defined
for A (presumably pointing to the same code as its runtime callbacks) so that
things work correctly, but perhaps we can just relax this requirement a bit?
I'm not 100% sure that's a good idea, just considering it.

Rafael
