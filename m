Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:59893 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751669Ab0L3EaW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Dec 2010 23:30:22 -0500
Date: Wed, 29 Dec 2010 23:30:21 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: Ohad Ben-Cohen <ohad@wizery.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
	<linux-pm@lists.linux-foundation.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
	Ido Yariv <ido@wizery.com>,
	Kevin Hilman <khilman@deeprootsystems.com>
Subject: Re: [linux-pm] subtle pm_runtime_put_sync race and sdio functions
In-Reply-To: <AANLkTi=QT1thWxy94=imJhbbcXQ1CD36=PnkAyaaA6Hj@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1012292326220.13580-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 29 Dec 2010, Ohad Ben-Cohen wrote:

> On Tue, Dec 28, 2010 at 11:46 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> > Similarly, during system suspend mmc_suspend_host() should be
> > responsible for doing all the necessary power-down operations.  Runtime
> > PM is completely out of the picture at this time.  And this should be
> > independent of mac80211 -- in fact, the card should be powered down
> > appropriately even if the kernel doesn't have a mac80211 layer.
> 
> And it is.
> 
> But in order to boot the firmware on resume, we need to reset the
> device. And if system suspend has been cancelled before
> mmc_power_off() was invoked, we will not be able to. So, in this case
> too, the driver will have to power the device off.

If the suspend transition was cancelled before mmc_power_off(), why do 
you need to boot the firmware on resume?  Since the device hasn't 
actually been powered off, can't it continue using the same firmware as 
before?

What routine is responsible for deciding to boot the firmware, and what 
is its call path?

> It all really boils down to the same solution - we will always have to
> bypass runtime PM and directly control the power of the device.

While this is probably true, I'm not at all convinced that the current 
design is layered correctly.  Fixing the design might reduce the amount 
of bypassing required.

Alan Stern

