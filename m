Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:36823 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750939Ab0L3EZh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Dec 2010 23:25:37 -0500
Date: Wed, 29 Dec 2010 23:25:36 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: Ohad Ben-Cohen <ohad@wizery.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
	<linux-pm@lists.linux-foundation.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
	Ido Yariv <ido@wizery.com>,
	Kevin Hilman <khilman@deeprootsystems.com>
Subject: Re: [linux-pm] subtle pm_runtime_put_sync race and sdio functions
In-Reply-To: <AANLkTikrd3JpBG4JYUUxQhPPNhSmJaE5j5ozz=_vpU52@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1012292314280.13580-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 29 Dec 2010, Ohad Ben-Cohen wrote:

> On Tue, Dec 28, 2010 at 11:46 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> > What's the relation between mmc_power_off() and mmc_power_save_host()?
> 
> Essentially they are the same - mmc_power_off() is the one that
> actually powers off the card.
> 
> mmc_power_save_host() just invokes first a bus-specific ->power_save()
> handler (if one exists).
> 
> > Does one merely go into a low-power state whereas the other does the
> > complete-power-off reset?
> 
> No, think of them as the same. Both will lead to a complete power off.
> The mmc_power_off() is just an internal function which belongs to the
> MMC core.

Then what routine does the power down without the full reset?

That's why you run into trouble, isn't it?  The device has been powered
down, but if the system sleep transition is aborted then the device
doesn't get reset (by mmc_power_save_host?), so you can't wake it up
again.

Also, what routine tries to do the failing wakeup, and what is its call
path?

> > During wlan-interface-down, it's not necessary to reduce the power
> > level; it's merely desirable.  That's exactly the sort of thing runtime
> > PM is meant for.  Hence the existing call to pm_runtime_put_sync() is
> > sufficient.
> 
> Not exactly - think of airplane mode, where we must ensure the radios
> are disabled, without being blocked by /sys/devices/.../power/control
> - we will need to bypass runtime PM in this scenario too.

I don't see why.  Turning off the radio is different from powering the 
device down -- you should be able to do the first without doing the 
second (although probably not vice versa).

Alan Stern

