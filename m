Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f194.google.com ([209.85.214.194]:57724 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604Ab0L1TFI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Dec 2010 14:05:08 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1012261050050.18773-100000@netrider.rowland.org>
References: <AANLkTinyKfwcZLD5D4rdF6OpQqr79F==GRjAMBjjbupW@mail.gmail.com> <Pine.LNX.4.44L0.1012261050050.18773-100000@netrider.rowland.org>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 28 Dec 2010 21:04:47 +0200
Message-ID: <AANLkTim7pGtO=vjKmA_3O74Kwvio124cgoaMeUSB70dW@mail.gmail.com>
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

On Sun, Dec 26, 2010 at 7:00 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> Hmm.  It's a little difficult to untangle the web of dev_pm_ops
> pointers and other stuff.

Yeah, SDIO suspend/resume is very different from other subsystems.

There are several layers of abstractions involved, from the host
controller driver, to the MMC core code, to the SDIO core code, to
finally get to the actual SDIO function driver.

I'll try to explain it below by addressing your questions. If
something is still unclear, feel free to ask me.

> There's wl1271_suspend() and wl1271_resume()
> (which don't do anything)

It just looks like they don't. In fact, by returning 0,
wl1271_suspend() is telling the SDIO subsystem that it's OK to power
down the SDIO function (in general an SDIO card can have several SDIO
functions, each of which may be driven by a separate SDIO driver). If
all the SDIO functions agreed, then SDIO core (mmc_sdio_suspend())
tells MMC core (mmc_suspend_host()) it's OK to power down the card (by
directly calling mmc_power_off()).

> Under what circumstances does the MMC/SDIO core call
> wl1271_sdio_set_power(), and where are those function calls?

The relations are actually reversed: the MMC/SDIO core never calls
this function.

This function is called by the wl1271 driver itself, mostly as a
response to a request by the mac80211 layer (but also as a response to
a hardware error), that requires manipulation of the power of the
card.

There are a handful of reasons this may happen:

error recovery:

wl1271_recovery_work() ->
    __wl1271_op_remove_interface() ->
          wl1271_power_off() ->
               wl1271_sdio_set_power() ->
                      wl1271_sdio_power_off() ->
                             pm_runtime_put_sync()

wlan interface goes down:

ieee80211_do_stop() ->
  wl1271_op_remove_interface() ->
    __wl1271_op_remove_interface() ->
          ...

system suspend:

__ieee80211_suspend ->
  wl1271_op_remove_interface() ->
      ...

> The normal case is that system suspend succeeds.  Then there is no
> race.  If system suspend fails then the failure may occur either before
> or after the wl1271 device is powered down; _that_ is the race
> (assuming you are using asynchronous PM).  But normally it doesn't
> occur.

True. On my setup I have stressed the solution for long nights (using
/sys/power/pm_test) without any error. But we found other setups with
different circumstances where this error showed up.

But it's not only due to the asynchronous PM race - a device that was
added to the device tree after the host controller, but before
mac80211, has a chance to abort a system suspend (by returning an
error in its suspend handler) at a point in time which will leave our
driver thinking (erroneously) that the wl1271 was powered off.

> You mean, the wl1271 device has no PM methods of its own; its power is
> managed entirely by the parent MMC/SDIO controller?

Yes.

> If that's right
> then you should call pm_runtime_no_callbacks() for the wl1271 device.

Yeah, that's in my queue...

>
> Is it possible for there to be more than one device connected to the
> same MMC/SDIO controller?

Generally yes, host controllers may have several slots, but to the
MMC/SDIO core, it is presented as each slot is a separate host
controller (personally I have never seen such hardware, but I did find
an example for that in the host controller's source folder).

> That's for runtime PM.  What about system sleep?  It looks like
> sdio_bus_type has no callbacks for suspend or resume, so the driver's
> callbacks get used instead -- that would be wl1271_suspend() and
> wl1271_resume().  But they don't do anything, so there's no power
> change until the parent MMC/SDIO controller is suspended.  That would
> be in mmc_sdio_suspend() and mmc_sdio_resume()?  But I can't tell what
> pmops->suspend and pmops->resume methods they end up calling.  Are
> these the entries in wl1271_sdio_pm_ops?  Does that mean
> wl1271_suspend() and wl1271_resume() get called twice?

No, wl1271_suspend() and wl1271_resume() are called once, but it's all
triggered by the host controller's suspend/resume handlers.

For example:

omap_hsmmc_suspend() ->
    mmc_suspend_host() ->
        mmc_sdio_suspend() ->
            wl1271_suspend()

And then, if there are no errors, mmc_suspend_host() will eventually
call mmc_power_off(), which powers off the card directly. So only at
this point will our device get eventually shut down.

> I think I already understand how the runtime suspend/resume paths work:
> There are no runtime PM methods for the wl1271 device, so the PM core
> simply propagates changes up to the parent MMC/SDIO device and ends up
> calling mmc_runtime_suspend() or mmc_runtime_resume().  Right?

Right.

> What is the pathway for reset (or other similar activities that
> require the device to be powered-down while it is in use)?

During runtime, the device will have to be powered off for error
recovery and every time the wlan interface goes down. Please see the
pathways above.

Thanks,
Ohad.
