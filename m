Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:60712 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033Ab0L1UE6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Dec 2010 15:04:58 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Ohad Ben-Cohen" <ohad@wizery.com>
Subject: Re: [linux-pm] subtle pm_runtime_put_sync race and sdio functions
Date: Tue, 28 Dec 2010 21:04:06 +0100
Cc: Alan Stern <stern@rowland.harvard.edu>,
	linux-pm@lists.linux-foundation.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org,
	Ido Yariv <ido@wizery.com>,
	Kevin Hilman <khilman@deeprootsystems.com>
References: <AANLkTimj0E3Rz_8WQrU4wGg3ONyXzkUT9+U3Xqz7Cq0X@mail.gmail.com> <201012261937.21256.rjw@sisk.pl> <AANLkTinewad6YxXvn5gnJQ+HJn41Sg96319GQn9KRKWj@mail.gmail.com>
In-Reply-To: <AANLkTinewad6YxXvn5gnJQ+HJn41Sg96319GQn9KRKWj@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201012282104.06232.rjw@sisk.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, December 28, 2010, Ohad Ben-Cohen wrote:
> On Sun, Dec 26, 2010 at 8:37 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > So, it only happens during asynchronous suspend?  In other words, if suspend
> > is synchronous, everything should be fine, right?
> 
> Not necessarily.

So it's not a race after all, is it?

> Consider this simple scenario, where a device was added after the mmc
> host controller, but before mac80211. In this case its suspend handler
> will have the chance to abort system suspend after mac80211 already
> told our driver to power down the device (but the device wasn't
> powered down yet, because the driver used pm_runtime_put_sync() which
> is disabled).

Well, first, you shouldn't rely on pm_runtime_put_sync() to actually _suspend_
the device at any point.  What it does is to call pm_runtime_idle() for the
device, which isn't guaranteed to suspend it.  If you want the device to
be suspended, you should use

pm_runtime_put_noidle(device);
pm_runtime_suspend(device);

or, alternatively

pm_runtime_put_sync_suspend(device);

(which equivalent to the above pair of callbacks, but is not available in
kernels prior to 2.6.37-rc1).

Second, what you'd really want to do (I guess) is:

pm_runtime_put_noidle(device);
device->bus->pm->runtime_suspend(device);

(I have omitted all of the usual checks for simplicity), because that would
_unconditionally_ put your device into a low-power state.  No?

The problem is at this point the PM core will think the device is still
RPM_ACTIVE, so it will be necessary to additionally do something like:

pm_runtime_disable(device);
pm_runtime_set_suspended(device);
pm_runtime_enable(device);

Of course, you'll need to ensure there are no races between that and
any other code path that may want to resume the device simultaneously.
And here it backfires, because you have to synchronize not only with
runtime resume, but also with system suspend and possibly resume.

Rafael
