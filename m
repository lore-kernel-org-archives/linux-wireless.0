Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:50941 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932482AbaDILtn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 07:49:43 -0400
Message-ID: <1397044175.4418.66.camel@dubbel> (sfid-20140409_134947_193505_BBAE686E)
From: Luca Coelho <luca@coelho.fi>
To: Yegor Yefremov <yegorslists@googlemail.com>
Cc: linux-wireless@vger.kernel.org, kaloz@openwrt.org
Date: Wed, 09 Apr 2014 14:49:35 +0300
In-Reply-To: <CAGm1_ktMWV0m1-gUTe8bQT1=f9HseBKCJn22bvPAgxynpeaQLg@mail.gmail.com>
References: <CAGm1_ktNAyqWhkTPycA-yKz9iXgqGvx3unjB7JHQpmiKFnFXuA@mail.gmail.com>
	 <1396988949.4418.46.camel@dubbel>
	 <CAGm1_ksFRCUNi1DPfmv=+8bBqiWxLSm6EeSYjhfVwR7oiAWBkw@mail.gmail.com>
	 <1397035298.4418.60.camel@dubbel>
	 <CAGm1_ktMWV0m1-gUTe8bQT1=f9HseBKCJn22bvPAgxynpeaQLg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: wl1271: tx stuck in firmware
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-04-09 at 12:16 +0200, Yegor Yefremov wrote:
> On Wed, Apr 9, 2014 at 11:21 AM, Luca Coelho <luca@coelho.fi> wrote:
> > On Wed, 2014-04-09 at 11:14 +0200, Yegor Yefremov wrote:
> >> On Tue, Apr 8, 2014 at 10:29 PM, Luca Coelho <luca@coelho.fi> wrote:
> >> > On Tue, 2014-04-08 at 17:28 +0200, Yegor Yefremov wrote:
> >> >> Any idea, what could be wrong?
> >> >
> >> > First of all, try a clean kernel.
> >>
> >> It is not simple to get a clean kernel. "Official" support for
> >> am335x-evmsk WLAN was added first in the upcoming 3.15 kernel. I've
> >> tried the merge window version (3.14.0-12041-g75ff24f-dirty) and get
> >> following issue:
> >>
> >> # calibrator wlan0 plt power_mode on
> >> wlcore: power up
> >> wlcore: ERROR timeout waiting for the hardware to complete initialization
> >> wlcore: ERROR timeout waiting for the hardware to complete initialization
> >> wlcore: ERROR timeout waiting for the hardware to complete initialization
> >> wlcore: ERROR firmware boot in PLT mode failed despite 3 retries
> >> command failed: Input/output error (-5)
> >
> > Okay, the main question here is, did you make any changes in the
> > wlcore/wl12xx code? As I said, the TX watchdog should *not* be
> > initialized in PLT mode.
> 
> I made not changes to any file in drivers/net/wireless/ti/
> 
> > Maybe you could add some prints in the driver to see when the watchdog
> > timer is set up? Try to add a printk in every place where
> > wl12xx_rearm_tx_watchdog_locked() is called to see where it is being
> > armed.
> 
> drivers/net/wireless/ti/wlcore/tx.c in wl1271_tx_allocate()
> 
> # calibrator wlan0 plt power_mode on
> [   93.107215] wlcore: power up
> [   93.688714] wlcore: firmware booted in PLT mode PLT_ON (PLT 6.3.10.0.133)
> # [  139.232802] YY: wl1271_tx_allocate
> [  144.241849] wlcore: ERROR Tx stuck (in FW) for 5000 ms. Starting recovery

Okay, you have a starting point. :)

Now try to look from where this is being called and so on.  I don't
think we should be calling wl1271_tx_allocate() in PLT mode either.  Try
tracing back until you find where this is coming from.

--
Luca.

