Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:60764 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752011Ab0L1UhH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Dec 2010 15:37:07 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Ohad Ben-Cohen" <ohad@wizery.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] subtle pm_runtime_put_sync race and sdio functions
Date: Tue, 28 Dec 2010 21:36:14 +0100
Cc: linux-pm@lists.linux-foundation.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org,
	Ido Yariv <ido@wizery.com>,
	Kevin Hilman <khilman@deeprootsystems.com>
References: <AANLkTimj0E3Rz_8WQrU4wGg3ONyXzkUT9+U3Xqz7Cq0X@mail.gmail.com> <201012282021.31695.rjw@sisk.pl> <AANLkTinPrUbaFsNMmoZJtOaF6dutLaXXQ7Uws5826n4=@mail.gmail.com>
In-Reply-To: <AANLkTinPrUbaFsNMmoZJtOaF6dutLaXXQ7Uws5826n4=@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201012282136.14258.rjw@sisk.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, December 28, 2010, Ohad Ben-Cohen wrote:
> On Tue, Dec 28, 2010 at 9:21 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > It looks like you could simply do a power down-power up cycle before trying to
> > load new firmware, just in case.  I guess that's suboptimal for some reason?
> 
> It would work, but we will not be able to unconditionally disable the
> radios (e.g. airplane mode comes to mind).

For _unconditional_ disabling you need to bypass the runtime PM anyway.

I guess it's best to simply disable it and invoke whatever-function-powers-off
your device directly in those cases.

> > Please pretend that the runtime PM framework doesn't exist for a while.  How
> > would you design things in that case?
> 
> Duplicate most of runtime-PM's plumbing into the MMC/SDIO subsystem.
> Off the top of my hat:
> - We need the device hierarchy and the suspend/resume dependencies (a
> single SDIO card has several logical sub-devices, a.k.a SDIO
> functions)
> - We need to maintain usage_count for each device, and expose the same
> API to handle it
> - We need autosuspend for MMC cards (power them off on inactivity)
> - We need the same, or similar, locking plumbing
> - We probably need the same sysfs ABI as well: autosuspend_delay_ms,
> and even  /sys/devices/.../power/control itself is useful (not for our
> device, but for others, sure)
> - ...

I didn't mean that, never mind.

To solve the problem with system suspend (I think) you need to:
(1) Add a ->prepare() callback to your driver, calling pm_runtime_resume()
    for the device.  From that point on you know that its runtime callbacks
    won't be called and if all of the pm_runtime_get_* and pm_runtime_put_*
    things are in balance, everything will work out nicely during resume.
(2) Add ->suspend() and ->resume() callbacks to your driver that will
    set the device for system suspend and bring it back to the "power on"
    state during system resume (that will cover your error code path issue in
    particular).
During resume, the pm_runtime_put_sync() in dpm_complete() should put the
device back into the low power state (if it was in that state before).

Thanks,
Rafael
