Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:43220 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751608Ab1EWFdC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 May 2011 01:33:02 -0400
Received: by ewy6 with SMTP id 6so2272515ewy.24
        for <linux-wireless@vger.kernel.org>; Sun, 22 May 2011 22:32:59 -0700 (PDT)
Subject: Re: [RFC/PATCH 03/13] net: wl12xx: remove some unnecessary prints
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: Felipe Balbi <balbi@ti.com>, linux-wireless@vger.kernel.org
In-Reply-To: <BANLkTimf8+hLym2RHGeG1r=7EOj91c3Uzg@mail.gmail.com>
References: <1305321990-22041-1-git-send-email-balbi@ti.com>
	 <1305321990-22041-4-git-send-email-balbi@ti.com>
	 <BANLkTinPipSVdsH5cTb24HKex_h7pOwpAg@mail.gmail.com>
	 <BANLkTi=LKE_wWKxcN0+Unkcqv-tLOKqDXw@mail.gmail.com>
	 <1306085440.12586.1696.camel@cumari>
	 <BANLkTimf8+hLym2RHGeG1r=7EOj91c3Uzg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 May 2011 08:32:53 +0300
Message-ID: <1306128773.12586.1704.camel@cumari> (sfid-20110523_073312_878032_CC8E9EA9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-05-23 at 00:57 +0300, Eliad Peller wrote:
> On Sun, May 22, 2011 at 8:30 PM, Luciano Coelho <coelho@ti.com> wrote:
> > On Sun, 2011-05-22 at 15:37 +0300, Eliad Peller wrote:
> >> On Sun, May 22, 2011 at 3:34 PM, Eliad Peller <eliad@wizery.com> wrote:
> >> > On Sat, May 14, 2011 at 12:26 AM, Felipe Balbi <balbi@ti.com> wrote:
> >> >> Those have little value. Remove those to make
> >> >> the driver less noisy.
> >> >>
> >> >> Signed-off-by: Felipe Balbi <balbi@ti.com>
> >> >> ---
> >> > [...]
> >> >> @@ -287,8 +287,6 @@ static int __devinit wl1271_probe(struct sdio_func *func,
> >> >>        /* Tell PM core that we don't need the card to be powered now */
> >> >>        pm_runtime_put_noidle(&func->dev);
> >> >>
> >> >> -       wl1271_notice("initialized");
> >> >> -
> >> >>        return 0;
> >> >>
> >> >
> >> >>  static void __exit wl1271_exit(void)
> >> >>  {
> >> >>        sdio_unregister_driver(&wl1271_sdio_driver);
> >> >> -
> >> >> -       wl1271_notice("unloaded");
> >> >>  }
> >> >>
> >> >
> >> > in fact, i find these prints pretty useful.
> >> > does changing wl1271_notice to wl1271_debug(DEBUG_MAC80211) will solve
> >> > the "nosiness"?
> >> > (i use DEBUG_MAC80211 rather than DEBUG_SDIO, as DEBUG_SDIO is really
> >> > *very* noisy)
> >> >
> >> > (i'll send it as a new patch as the original patch was already applied)
> >> >
> >> > Eliad.
> >> >
> >>
> >> err... s/nosiness/noisiness/
> >
> > I think these are pretty useless.  You can see whether the driver is
> > loaded or not by lsmod'ing.  You can also use ftrace to get the same
> > stuff, if you want to know whether the driver is loaded or not offline.
> > Or what is the scenario where you think this is useful?
> >
> i was thinking about a simple offline log analysis, where it's pretty
> useful to know when the wl12xx_sdio was insmod'ed/rmmod'ed.

Have you really had to know when the modules are insmodded or rmmoded?


> i haven't tried ftrace yet. i'll give it a look.
> anyway, the whole wl12xx driver is full of similar logs that get
> called multiple times, so i don't see the real advantage of removing 2
> prints that get called only once.

Yeah, the driver is full of useless logs.  That's why I'm going to
rework it.  My idea is to use more standard tracing (nobody needs to
learn wl12xx debug bitmask and how to set it), using ftrace and friends.

These two were removed now because Felipe has reworked the SDIO/SPI
modules and, at the same time, cleaned it up a little.  I think it's
good to clean up things little by little, especially on the parts that
are being touched anyway.


> > I'm reworking the whole way our traces are handled, so I don't think
> > reintroducing them is a good thing.
> 
> ok. so i'll just wait for your rework :)

It may still take a bit of time, because it's not my highest priority
right now and the changes are quite intrusive (in the sense that they
will touch every file), but when it's ready, I think it's going to be
cool, you'll be able to use trace-cmd, kernelshark etc.

-- 
Cheers,
Luca.

