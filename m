Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:33065 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754615Ab1CVHqe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Mar 2011 03:46:34 -0400
Received: by wyf23 with SMTP id 23so6434109wyf.26
        for <linux-wireless@vger.kernel.org>; Tue, 22 Mar 2011 00:46:32 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: use a bitmask instead of list of booleans in
 scanned_ch
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTimLvjiHMFJ7dxhLnKVcAU2co2d5uoEE6R0mi4-G@mail.gmail.com>
References: <1300742385-15813-1-git-send-email-coelho@ti.com>
	 <AANLkTimLvjiHMFJ7dxhLnKVcAU2co2d5uoEE6R0mi4-G@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Mar 2011 09:45:42 +0200
Message-ID: <1300779942.2593.398.camel@cumari>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-03-22 at 09:40 +0200, Eliad Peller wrote:
> On Mon, Mar 21, 2011 at 11:19 PM, Luciano Coelho <coelho@ti.com> wrote:
> > We were using an array of booleans to mark the channels we had already scanned.  This was causing a sparse error, because bool is not a type with defined size.  To fix this, use bitmasks instead, which is much cleaner anyway.
> >
> > Thanks Johannes Berg for the idea.
> >
> > Signed-off-by: Luciano Coelho <coelho@ti.com>
> > ---
> [...]
> > +       /* make sure all our channels fit in the scanned_ch bitmask */
> > +       BUG_ON(ARRAY_SIZE(wl1271_channels) + ARRAY_SIZE(wl1271_channels_5ghz) >
> > +              WL1271_MAX_CHANNELS);
> 
> maybe use BUILD_BUG_ON here?

Yeah, I had actually done that at first.  But then the compilation error
was so cryptic that I decided to add a BUG_ON instead.  But now I
realize that the BUG_ON is just as cryptic, so I can change it back to
BUILD_BUG_ON.  In either case, the developer will know soon enough that
there is a bug. :)

I'll change it to BUILD_BUG_ON before applying.

Thanks!

-- 
Cheers,
Luca.

