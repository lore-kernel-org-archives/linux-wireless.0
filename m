Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35144 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334Ab0LYU60 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Dec 2010 15:58:26 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1012251046060.5079-100000@netrider.rowland.org>
References: <AANLkTi=aHU57xDq+-DWrN2sJsAwx_9bZ_ofy1rOmp0VH@mail.gmail.com> <Pine.LNX.4.44L0.1012251046060.5079-100000@netrider.rowland.org>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sat, 25 Dec 2010 22:58:04 +0200
Message-ID: <AANLkTimj0E3Rz_8WQrU4wGg3ONyXzkUT9+U3Xqz7Cq0X@mail.gmail.com>
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

On Sat, Dec 25, 2010 at 6:21 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> Right.  You may or may not realize it, but this requirement means that
> the driver _must_ bypass runtime PM sometimes.

http://www.spinics.net/lists/linux-pm/msg22864.html

> Now you've lost me.  Which of the driver's handlers are you talking
> about?

The driver's handler, which is called by mac80211, and is responsible
to power off the device.
The _same_ handler is being called either during runtime or during a
system transition to suspend

> What races?

Driver thinks power is off and device is now fully reset, but it's isn't really

> Why does the driver have to _assume_ the device was powered off -- why
> doesn't it simply _do_ the power down?

runtime PM is disabled during suspend. and the driver doesn't know
that the system is suspending, and it is using pm_runtime_put_sync().
It's the same code that executes during runtime and while system is
suspending

Even if we changed mac80211 to tell us the system is suspending, so we
would power off the device directly in this case, it won't solve all
of our problems, because even during runtime we need to bypass runtime
PM due to /sys/devices/.../power/control.

> Maybe it would help if you provided a list of the relevant subroutines
> together with descriptions of the circumstances under which they are
> called and what they are expected to do.  For example, a brief
> pseudo-code listing.

Frankly, I don't think it's worth it.

We're just a single use case and Rafael already said he won't support it.

> It's not necessary to maintain usage_count while you're bypassing
> runtime PM.  Just make sure when you're done that everything is back in
> sync.

I think you are missing the fact that we will have to bypass runtime
PM also during runtime, and not only in suspend/resume, and that's due
to /sys/devices/.../power/control.

That's why we will also have to maintain usage_count - to prevent
dpm_complete() from powering the device down, when it is really up.

> Why shouldn't dpm_complete cause the device to be powered down
> (assuming the device isn't in use, of course)?

Because it _is_ in use
