Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f194.google.com ([209.85.210.194]:62806 "EHLO
	mail-iy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786Ab0L2Geq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Dec 2010 01:34:46 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1012281541580.22998-100000@netrider.rowland.org>
References: <AANLkTim7pGtO=vjKmA_3O74Kwvio124cgoaMeUSB70dW@mail.gmail.com> <Pine.LNX.4.44L0.1012281541580.22998-100000@netrider.rowland.org>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 29 Dec 2010 08:34:25 +0200
Message-ID: <AANLkTikrd3JpBG4JYUUxQhPPNhSmJaE5j5ozz=_vpU52@mail.gmail.com>
Subject: Re: [linux-pm] subtle pm_runtime_put_sync race and sdio functions
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
	linux-pm@lists.linux-foundation.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org,
	Ido Yariv <ido@wizery.com>,
	Kevin Hilman <khilman@deeprootsystems.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 28, 2010 at 11:46 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> What's the relation between mmc_power_off() and mmc_power_save_host()?

Essentially they are the same - mmc_power_off() is the one that
actually powers off the card.

mmc_power_save_host() just invokes first a bus-specific ->power_save()
handler (if one exists).

> Does one merely go into a low-power state whereas the other does the
> complete-power-off reset?

No, think of them as the same. Both will lead to a complete power off.
The mmc_power_off() is just an internal function which belongs to the
MMC core.

> During wlan-interface-down, it's not necessary to reduce the power
> level; it's merely desirable.  That's exactly the sort of thing runtime
> PM is meant for.  Hence the existing call to pm_runtime_put_sync() is
> sufficient.

Not exactly - think of airplane mode, where we must ensure the radios
are disabled, without being blocked by /sys/devices/.../power/control
- we will need to bypass runtime PM in this scenario too.

> Put it another way:  Suppose an SDIO card has more than one function
> and you need to reset the wl1271 function.  It sounds like there's no
> way to do this without resetting the other functions as well.  What
> happens if another function's driver is busy and can't allow a reset
> just then?

That's a chip specific thing. In our case, there is no other active
SDIO function.

Other vendors which does employ several SDIO functions have a separate
reset for each function _in addition_ to the power line. So for them
the runtime PM model is just great - they never care if the actual
power is down or not - it's really just about power consumption, and
nothing else. When they need an unconditional reset, they just use the
appropriate reset line.

In our case we have a single control for both power and reset
functionality (actually we do have a separate power line to the
device, but it is not controlled by software - it is fed directly from
the battery rail).
