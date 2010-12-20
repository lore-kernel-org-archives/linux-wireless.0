Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:41836 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933219Ab0LTVRs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Dec 2010 16:17:48 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] subtle pm_runtime_put_sync race and sdio functions
Date: Mon, 20 Dec 2010 22:17:09 +0100
Cc: "Ohad Ben-Cohen" <ohad@wizery.com>,
	linux-pm@lists.linux-foundation.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org,
	Ido Yariv <ido@wizery.com>,
	Kevin Hilman <khilman@deeprootsystems.com>
References: <Pine.LNX.4.44L0.1012192226270.31110-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1012192226270.31110-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201012202217.09374.rjw@sisk.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, December 20, 2010, Alan Stern wrote:
> On Sun, 19 Dec 2010, Rafael J. Wysocki wrote:
> 
> > That said, I think we may do something different that perhaps will make your
> > life somewhat easier.
> > 
> > Namely, if your driver doesn't implement any system suspend callbacks
> > (i.e. ->suspend(), ->resume(), ->freeze(), ->thaw() etc.) and it doesn't
> > want the analogous subsystem callbacks to be executed for the device, it will
> > make sense to flag the device as "runtime only", or something like this,
> > which make the PM core skip the device in dpm_suspend() etc.
> > 
> > In that case, if a device if flagged as "runtime only", we can avoid
> > calling pm_runtime_get_noirq() for it in dpm_prepare() and, analogously,
> > calling pm_runtime_put_sync() for it in dpm_complete().  However, we will have
> > to fail system suspend (or hibernation) if a "runtime only" device has the
> > power.runtime_auto flag unset.
> 
> Or more generally, if pm_runtime_suspended() doesn't return 'true' for 
> the device.

That's not necessary, because the device may be suspended using
pm_runtime_suspend() later than we check pm_runtime_suspended().

I'd use the "runtime only" (or perhaps better "no_dpm") flag as a declaration
(if set) that the device is going to be suspended with the help of "runtime"
callbacks and the driver takes the responsibility for getting things right.

> But if the device gets suspended asynchronously, this may 
> very well happen.  For example, an i2c device is originally runtime 
> suspended, but its device_suspend() call occurs at the same time as the 
> call for the RTC device, so the i2c device actually happens to be 
> resumed at that time in order to communicate with the RTC.
> 
> > So, I think we can add a "runtime only" flag working as described above.
> > I guess it will also help in the case I've been discussing with Kevin for some
> > time (i2c device using runtime PM used by an RTC in a semi-transparent
> > fashion).
> > 
> > Alan, what do you think?
> 
> I'm not sure.  In this situation, should we worry more that we usually
> do about the possibility of a runtime resume occurring after the device
> has gone through device_suspend()?  Or just depend on the driver to do
> everything correctly?

The latter.

Thanks,
Rafael
