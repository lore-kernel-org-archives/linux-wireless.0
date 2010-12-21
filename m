Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:38155 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757288Ab0LUA5u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Dec 2010 19:57:50 -0500
Date: Mon, 20 Dec 2010 19:57:48 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Ohad Ben-Cohen <ohad@wizery.com>,
	<linux-pm@lists.linux-foundation.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
	Ido Yariv <ido@wizery.com>,
	Kevin Hilman <khilman@deeprootsystems.com>
Subject: Re: [linux-pm] subtle pm_runtime_put_sync race and sdio functions
In-Reply-To: <201012202217.09374.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1012201946330.19558-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 20 Dec 2010, Rafael J. Wysocki wrote:

> > > In that case, if a device if flagged as "runtime only", we can avoid
> > > calling pm_runtime_get_noirq() for it in dpm_prepare() and, analogously,
> > > calling pm_runtime_put_sync() for it in dpm_complete().  However, we will have
> > > to fail system suspend (or hibernation) if a "runtime only" device has the
> > > power.runtime_auto flag unset.
> > 
> > Or more generally, if pm_runtime_suspended() doesn't return 'true' for 
> > the device.
> 
> That's not necessary, because the device may be suspended using
> pm_runtime_suspend() later than we check pm_runtime_suspended().

What if the device has a child in the RPM_ACTIVE state?  Then 
pm_runtime_suspend() won't do anything, even if the child really is 
dpm-suspended.

> I'd use the "runtime only" (or perhaps better "no_dpm") flag as a declaration
> (if set) that the device is going to be suspended with the help of "runtime"
> callbacks and the driver takes the responsibility for getting things right.

I'm still not sure about this; the design isn't clear.  Are these
runtime callbacks going to come from the PM core or from the driver?  
If from the driver, how will the driver know when to issue them?  What
about coordinating async suspends (the device must be suspended after
its children and before its parent)?

Alan Stern

