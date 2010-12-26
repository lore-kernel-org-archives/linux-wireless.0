Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:37791 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752365Ab0LZRA2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Dec 2010 12:00:28 -0500
Date: Sun, 26 Dec 2010 12:00:25 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: Ohad Ben-Cohen <ohad@wizery.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
	<linux-pm@lists.linux-foundation.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
	Ido Yariv <ido@wizery.com>,
	Kevin Hilman <khilman@deeprootsystems.com>
Subject: Re: [linux-pm] subtle pm_runtime_put_sync race and sdio functions
In-Reply-To: <AANLkTinyKfwcZLD5D4rdF6OpQqr79F==GRjAMBjjbupW@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1012261050050.18773-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 26 Dec 2010, Ohad Ben-Cohen wrote:

> On Sun, Dec 26, 2010 at 4:48 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> > Is there a separate handler responsible for powering the device back
> > on?  What are the names of these handlers?
> 
> wl1271_sdio_power_on() and wl1271_sdio_power_off().
> 
> If you're taking a look, please do so using the latest code as seen on mmc-next:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git mmc-next

Hmm.  It's a little difficult to untangle the web of dev_pm_ops
pointers and other stuff.  There's wl1271_suspend() and wl1271_resume()
(which don't do anything) plus wl1271_sdio_set_power(), which calls
either wl1271_sdio_power_on() or wl1271_sdio_power_off(), and these
routines in turn call pm_runtime_get_sync() and pm_runtime_put_sync().

Under what circumstances does the MMC/SDIO core call 
wl1271_sdio_set_power(), and where are those function calls?

> > That's not a race
> 
> It is.
> 
> If system suspend will continue uninterruptedly, and the driver will
> be suspended (by the SDIO subsystem), then the device will be powered
> down, and everything will work.
> 
> But if something will interrupt the suspend transition _before_ our
> driver is suspended (e.g. some other suspend() handler will fail),
> then we have a problem, because the device will not be reset as the
> driver needs it to be.

The normal case is that system suspend succeeds.  Then there is no 
race.  If system suspend fails then the failure may occur either before 
or after the wl1271 device is powered down; _that_ is the race 
(assuming you are using asynchronous PM).  But normally it doesn't 
occur.

> > What is the name of the driver's runtime_suspend routine?
> 
> The driver itself doesn't have one; power is being controlled by the
> MMC/SDIO subsystem, so the actual runtime_suspend handler is
> mmc_runtime_suspend().

You mean, the wl1271 device has no PM methods of its own; its power is 
managed entirely by the parent MMC/SDIO controller?  If that's right 
then you should call pm_runtime_no_callbacks() for the wl1271 device.

Is it possible for there to be more than one device connected to the 
same MMC/SDIO controller?  If it is, how do you reset one without 
resetting all the others?

> > And while we're at it, what is the name of the routine that _actually_ changes the
> > device's power level?
> 
> mmc_power_save_host(), which is called by mmc_runtime_suspend().
> 
> (well, more accurately it is actually fixed_voltage_disable(), but
> that's a few levels deeper than I think you'll be interested in)

That's for runtime PM.  What about system sleep?  It looks like
sdio_bus_type has no callbacks for suspend or resume, so the driver's
callbacks get used instead -- that would be wl1271_suspend() and
wl1271_resume().  But they don't do anything, so there's no power
change until the parent MMC/SDIO controller is suspended.  That would
be in mmc_sdio_suspend() and mmc_sdio_resume()?  But I can't tell what
pmops->suspend and pmops->resume methods they end up calling.  Are
these the entries in wl1271_sdio_pm_ops?  Does that mean
wl1271_suspend() and wl1271_resume() get called twice?

I think I already understand how the runtime suspend/resume paths work:
There are no runtime PM methods for the wl1271 device, so the PM core
simply propagates changes up to the parent MMC/SDIO device and ends up
calling mmc_runtime_suspend() or mmc_runtime_resume().  Right?

What is the pathway for reset (or other similar activities that 
require the device to be powered-down while it is in use)?  
wl1271_sdio_reset() doesn't do anything.

Alan Stern

