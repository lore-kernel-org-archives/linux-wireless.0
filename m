Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:38764 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752722Ab1EVRaq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 May 2011 13:30:46 -0400
Received: by ewy22 with SMTP id 22so2304128ewy.21
        for <linux-wireless@vger.kernel.org>; Sun, 22 May 2011 10:30:44 -0700 (PDT)
Subject: Re: [RFC/PATCH 03/13] net: wl12xx: remove some unnecessary prints
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: Felipe Balbi <balbi@ti.com>, linux-wireless@vger.kernel.org
In-Reply-To: <BANLkTi=LKE_wWKxcN0+Unkcqv-tLOKqDXw@mail.gmail.com>
References: <1305321990-22041-1-git-send-email-balbi@ti.com>
	 <1305321990-22041-4-git-send-email-balbi@ti.com>
	 <BANLkTinPipSVdsH5cTb24HKex_h7pOwpAg@mail.gmail.com>
	 <BANLkTi=LKE_wWKxcN0+Unkcqv-tLOKqDXw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 22 May 2011 20:30:40 +0300
Message-ID: <1306085440.12586.1696.camel@cumari> (sfid-20110522_193053_951196_F6DB0547)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-05-22 at 15:37 +0300, Eliad Peller wrote:
> On Sun, May 22, 2011 at 3:34 PM, Eliad Peller <eliad@wizery.com> wrote:
> > On Sat, May 14, 2011 at 12:26 AM, Felipe Balbi <balbi@ti.com> wrote:
> >> Those have little value. Remove those to make
> >> the driver less noisy.
> >>
> >> Signed-off-by: Felipe Balbi <balbi@ti.com>
> >> ---
> > [...]
> >> @@ -287,8 +287,6 @@ static int __devinit wl1271_probe(struct sdio_func *func,
> >>        /* Tell PM core that we don't need the card to be powered now */
> >>        pm_runtime_put_noidle(&func->dev);
> >>
> >> -       wl1271_notice("initialized");
> >> -
> >>        return 0;
> >>
> >
> >>  static void __exit wl1271_exit(void)
> >>  {
> >>        sdio_unregister_driver(&wl1271_sdio_driver);
> >> -
> >> -       wl1271_notice("unloaded");
> >>  }
> >>
> >
> > in fact, i find these prints pretty useful.
> > does changing wl1271_notice to wl1271_debug(DEBUG_MAC80211) will solve
> > the "nosiness"?
> > (i use DEBUG_MAC80211 rather than DEBUG_SDIO, as DEBUG_SDIO is really
> > *very* noisy)
> >
> > (i'll send it as a new patch as the original patch was already applied)
> >
> > Eliad.
> >
> 
> err... s/nosiness/noisiness/

I think these are pretty useless.  You can see whether the driver is
loaded or not by lsmod'ing.  You can also use ftrace to get the same
stuff, if you want to know whether the driver is loaded or not offline.
Or what is the scenario where you think this is useful?

I'm reworking the whole way our traces are handled, so I don't think
reintroducing them is a good thing.


-- 
Cheers,
Luca.

