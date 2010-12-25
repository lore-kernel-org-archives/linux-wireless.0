Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35700 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab0LYHez convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Dec 2010 02:34:55 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1012231055440.5617-100000@netrider.rowland.org>
References: <AANLkTi=9kjmb3evOON3WMoGjqadDHqqBKVH4viT02Qf9@mail.gmail.com> <Pine.LNX.4.44L0.1012231055440.5617-100000@netrider.rowland.org>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sat, 25 Dec 2010 09:34:33 +0200
Message-ID: <AANLkTi=aHU57xDq+-DWrN2sJsAwx_9bZ_ofy1rOmp0VH@mail.gmail.com>
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

On Thu, Dec 23, 2010 at 6:03 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> I'm still not aware of the details of your situation.  Nevertheless, it
> shouldn't be hard to set up a suspend() routine that would do whatever
> was needed to power down the device, whether this means calling the
> runtime_suspend() routine directly or something else.  That's basically
> what every other driver does.

And that's what we already do as well, but as I wrote earlier, in our
specific scenario this _breaks_ if system suspend is cancelled (for
whatever reason) _before_ our suspend handler kicks in (and after
mac80211 has suspended our driver).

Moreover, even if it did work, it wouldn't have been enough.

I'll try to explain, and if something is still not clear, please let me know.

Our wlan device is an ARM microcontroller running some flavor of RTOS
(i.e. the firmware); as I mentioned before, its power and reset
functionalities are tied together (as far as software is concerned. a
small detail I won't get into now). The ability to unconditionally
power it down is needed for error recovery, for booting a new firmware
(and for unconditionally stopping all radios...).

The driver assumes it can unconditionally power down the device, and
is built around this assumption, so a user interface such as
/sys/devices/.../power/control has no sense, and if set to 'on', will
be fatal for this driver (e.g. it will not be possible to bring the
wlan interface down and up).

There is no way around this. The driver must be able to
unconditionally power the hardware down.



About the suspend/resume issue:

This is a mac80211 driver. It is basically a set of "dumb" handlers,
which mac80211 uses to abstract the hardware differences between its
various drivers. For example, there are handlers to take down/up an
interface, to start/stop the hardware, etc..

When one of the driver's handlers is being called, the driver doesn't
really know (or care) if this is during runtime or not. If it is asked
to stop its hardware, it should just do so. And when (in our case)
this handler is invoked during system suspend, any disability to power
off the device immediately opens a window for races due to the
driver's assumption, on resume, that the device was powered off
successfully. So, yeah, we do have a suspend() handler, which powers
the device off directly, but we need the "runtime" handler of the
driver to immediately succeed too in order to prevent the race (and
then it's fully powered off and we wouldn't need to wait for the
suspend() handler to do so too). For that to happen, we need runtime
PM not to be disabled during system suspend (or by
/sys/devices/.../power/control).

Tweaking the driver around this limitation (to realize somehow if the
hardware was really powered down or not) doesn't make sense and
frankly isn't worth the effort, since the driver anyway has to be able
to unconditionally power down the device for the aforementioned
reasons (error recovery, reboot a new fw, disable radios, ..).

A small comment: SDIO drivers' suspend handler is actually triggered
by the mmc host controller's suspend routine (through the SDIO
subsystem); it's not the classic dpm-triggered suspend handler, so
Rafael's notion of "runtime only" flag will work here.


Why runtime PM:

The device has an SDIO interface, so one of its incarnations is an SDIO driver.

Short background: MMC/SDIO cards are dynamically probed, identified
and configured by the MMC/SDIO subsystem, so toggling their power must
take place from within the MMC/SDIO subsystem itself.

Until recently, MMC/SDIO cards were kept powered on from the moment
they were inserted, up until they were removed (exception: power was
removed on system suspend and brought up back on resume. there is an
exception to this exception, too, but I won't get into that now).

Recently, we have added runtime PM support to the MMC/SDIO subsystem,
so cards can be powered down when they're not in use. E.g., an SDIO
card is powered down if no driver is available or requires power to
it, and an MMC card might be powered off after some period of
inactivity (the latter is just being discussed and has not yet hit
mainline).

As far as the MMC/SDIO subsystem is concerned, this is merely a power
optimization, and it's perfectly fine if the user will disable runtime
PM for the card and by that disallow powering it down.

But for our particular device this is fatal; as explained, the driver
must have unconditional control of the device's power.

So we need runtime PM at the subsystem level (to allow the MMC/SDIO
subsystem power it off in case the driver is not loaded), but we will
have no choice but bypass runtime PM at the driver level, in order to
avoid the aforementioned suspend race, and a potential
/sys/devices/.../power/control block.

To maintain coherency with the runtime-PM's usage_count (and by that
prevent dpm_complete() from powering off our device after a system
resume) we will also keep calling the pm_runtime_{get, put} API
appropriately.

It's not pretty, but this is the only way we can make this work
(unless, of course, our use case will be supported within the
runtime-PM framework itself).

Thanks,
Ohad.
