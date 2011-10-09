Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:34299 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751241Ab1JIGJ4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Oct 2011 02:09:56 -0400
Received: by mail-bw0-f50.google.com with SMTP id zt19so7865623bkb.37
        for <linux-wireless@vger.kernel.org>; Sat, 08 Oct 2011 23:09:55 -0700 (PDT)
Subject: Re: [PATCH 1/2] wl12xx: sdio: use dev_dbg instead of wl1271_debug
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CAB3XZEeiyAxzE6tiqe2D71jKuusa-hPz-2fw5bqHocaw+d1xWg@mail.gmail.com>
References: <1317987297-18172-1-git-send-email-coelho@ti.com>
	 <CAB3XZEeiyAxzE6tiqe2D71jKuusa-hPz-2fw5bqHocaw+d1xWg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 09 Oct 2011 09:09:52 +0300
Message-ID: <1318140592.9690.55.camel@cumari> (sfid-20111009_081002_005954_3905654A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-10-09 at 02:08 +0200, Eliad Peller wrote: 
> On Fri, Oct 7, 2011 at 1:34 PM, Luciano Coelho <coelho@ti.com> wrote:
> > To prevent a useless dependency between the sdio module and the wl12xx
> > module, we need to replace the wl1271_debug macros (and friends) for
> > dev_dbg and other equivalents.
> >
> > At the same time, remove the SDIO data hexdump, since this produces
> > way too much data and is not particularly useful.  There's not
> > print_hex_dump() equivalent for dynamic debug, so it's hard to control
> > when the dumps are printed out.
> >
> > Signed-off-by: Luciano Coelho <coelho@ti.com>
> > ---
> [...]
> >                if (!(sdio_flags & MMC_PM_KEEP_POWER)) {
> > -                       wl1271_error("can't keep power while host "
> > +                       dev_err(dev, "can't keep power while host \n"
> >                                     "is suspended");
> 
> you missed the concatenation here :)

Ouch! Et tu Brutus?! :)

My regex didn't spread across lines.  I'll fix it, thanks for checking.


-- 
Cheers,
Luca.

