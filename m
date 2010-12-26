Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46673 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841Ab0LZFz1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Dec 2010 00:55:27 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1012252041260.10725-100000@netrider.rowland.org>
References: <AANLkTimj0E3Rz_8WQrU4wGg3ONyXzkUT9+U3Xqz7Cq0X@mail.gmail.com> <Pine.LNX.4.44L0.1012252041260.10725-100000@netrider.rowland.org>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sun, 26 Dec 2010 07:55:05 +0200
Message-ID: <AANLkTinyKfwcZLD5D4rdF6OpQqr79F==GRjAMBjjbupW@mail.gmail.com>
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

On Sun, Dec 26, 2010 at 4:48 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> Is there a separate handler responsible for powering the device back
> on?  What are the names of these handlers?

wl1271_sdio_power_on() and wl1271_sdio_power_off().

If you're taking a look, please do so using the latest code as seen on mmc-next:

git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git mmc-next

> That's not a race

It is.

If system suspend will continue uninterruptedly, and the driver will
be suspended (by the SDIO subsystem), then the device will be powered
down, and everything will work.

But if something will interrupt the suspend transition _before_ our
driver is suspended (e.g. some other suspend() handler will fail),
then we have a problem, because the device will not be reset as the
driver needs it to be.

> What is the name of the driver's runtime_suspend routine?

The driver itself doesn't have one; power is being controlled by the
MMC/SDIO subsystem, so the actual runtime_suspend handler is
mmc_runtime_suspend().

> And while we're at it, what is the name of the routine that _actually_ changes the
> device's power level?

mmc_power_save_host(), which is called by mmc_runtime_suspend().

(well, more accurately it is actually fixed_voltage_disable(), but
that's a few levels deeper than I think you'll be interested in)

> Evidently you are facing two distinct problems, and they need to be
> solved together.  In fact, solving one problem (bypassing runtime PM)
> will probably help to solve the other (doing system resume correctly).

I agree.

> Well, I'd like to help you find the best solution, but I can't because
> I don't understand how the subsystem and driver are structured, and you
> aren't providing enough details.  We won't make any further progress on
> this unless you abandon the incomplete high-level overviews and instead
> give a more or less complete lower-level description -- including the
> subroutine names!

In fact, I'd appreciate if we can abandon the high-level discussions too :)

I have provided pointers to the actual code, please tell me if you're
interested in any other parts or have questions about it.

> Maybe you mean that you want to prevent dpm_complete() from powering
> the device down while it is in use.

Yes.

> That should never be a problem --
> the device should never be used without the PM core being aware.

That's why I said we will have to both directly manipulate the power
of the device, and also maintain usage_count.

> Therefore you need to have a single routine that actually powers-down
> the device, and you need to call this routine in different settings:
> during system sleep or runtime suspend (the same code in the driver
> handles these two cases, right?) and when a reset is needed.

Yes. and sometimes also just because the user turned wlan off.

Thanks,
Ohad.
