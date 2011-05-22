Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:62618 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755205Ab1EVV53 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 May 2011 17:57:29 -0400
Received: by yia27 with SMTP id 27so1884118yia.19
        for <linux-wireless@vger.kernel.org>; Sun, 22 May 2011 14:57:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1306085440.12586.1696.camel@cumari>
References: <1305321990-22041-1-git-send-email-balbi@ti.com>
	<1305321990-22041-4-git-send-email-balbi@ti.com>
	<BANLkTinPipSVdsH5cTb24HKex_h7pOwpAg@mail.gmail.com>
	<BANLkTi=LKE_wWKxcN0+Unkcqv-tLOKqDXw@mail.gmail.com>
	<1306085440.12586.1696.camel@cumari>
Date: Mon, 23 May 2011 00:57:28 +0300
Message-ID: <BANLkTimf8+hLym2RHGeG1r=7EOj91c3Uzg@mail.gmail.com> (sfid-20110522_235737_773501_16352250)
Subject: Re: [RFC/PATCH 03/13] net: wl12xx: remove some unnecessary prints
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: Felipe Balbi <balbi@ti.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 22, 2011 at 8:30 PM, Luciano Coelho <coelho@ti.com> wrote:
> On Sun, 2011-05-22 at 15:37 +0300, Eliad Peller wrote:
>> On Sun, May 22, 2011 at 3:34 PM, Eliad Peller <eliad@wizery.com> wrote:
>> > On Sat, May 14, 2011 at 12:26 AM, Felipe Balbi <balbi@ti.com> wrote:
>> >> Those have little value. Remove those to make
>> >> the driver less noisy.
>> >>
>> >> Signed-off-by: Felipe Balbi <balbi@ti.com>
>> >> ---
>> > [...]
>> >> @@ -287,8 +287,6 @@ static int __devinit wl1271_probe(struct sdio_func *func,
>> >>        /* Tell PM core that we don't need the card to be powered now */
>> >>        pm_runtime_put_noidle(&func->dev);
>> >>
>> >> -       wl1271_notice("initialized");
>> >> -
>> >>        return 0;
>> >>
>> >
>> >>  static void __exit wl1271_exit(void)
>> >>  {
>> >>        sdio_unregister_driver(&wl1271_sdio_driver);
>> >> -
>> >> -       wl1271_notice("unloaded");
>> >>  }
>> >>
>> >
>> > in fact, i find these prints pretty useful.
>> > does changing wl1271_notice to wl1271_debug(DEBUG_MAC80211) will solve
>> > the "nosiness"?
>> > (i use DEBUG_MAC80211 rather than DEBUG_SDIO, as DEBUG_SDIO is really
>> > *very* noisy)
>> >
>> > (i'll send it as a new patch as the original patch was already applied)
>> >
>> > Eliad.
>> >
>>
>> err... s/nosiness/noisiness/
>
> I think these are pretty useless.  You can see whether the driver is
> loaded or not by lsmod'ing.  You can also use ftrace to get the same
> stuff, if you want to know whether the driver is loaded or not offline.
> Or what is the scenario where you think this is useful?
>
i was thinking about a simple offline log analysis, where it's pretty
useful to know when the wl12xx_sdio was insmod'ed/rmmod'ed.
i haven't tried ftrace yet. i'll give it a look.
anyway, the whole wl12xx driver is full of similar logs that get
called multiple times, so i don't see the real advantage of removing 2
prints that get called only once.

> I'm reworking the whole way our traces are handled, so I don't think
> reintroducing them is a good thing.

ok. so i'll just wait for your rework :)

thanks,
Eliad.
