Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:56073 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753235Ab0KDVvr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Nov 2010 17:51:47 -0400
Subject: Re: [PATCH v4] wl1271: Change wl12xx Files Names
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: ext Grazvydas Ignotas <notasas@gmail.com>,
	Shahar Levi <shahar_levi@ti.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@adurom.com>
In-Reply-To: <AANLkTi=Luv2+5Hys2PcrH+G8jmc4vwz8PM0LFKm+fTt8@mail.gmail.com>
References: <1288883257-30060-1-git-send-email-shahar_levi@ti.com>
	 <AANLkTincpxdpmf5J38LiGsF-d9dG7sG9-bjbkH-B8Ld0@mail.gmail.com>
	 <1288891196.17643.6.camel@powerslave>
	 <AANLkTi=Luv2+5Hys2PcrH+G8jmc4vwz8PM0LFKm+fTt8@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Nov 2010 23:52:35 +0200
Message-ID: <1288907555.17643.14.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-11-04 at 22:48 +0100, ext Gábor Stefanik wrote:
> On Thu, Nov 4, 2010 at 6:19 PM, Luciano Coelho <luciano.coelho@nokia.com> wrote:
> > On Thu, 2010-11-04 at 17:37 +0100, ext Grazvydas Ignotas wrote:
> >> On Thu, Nov 4, 2010 at 5:07 PM, Shahar Levi <shahar_levi@ti.com> wrote:
> >> > All files name prefix removed due to the fact that wl12xx driver supports
> >> > wl1271 and wl1273.
> >> > Also the definition in Kconfig and header files changed respectively.
> >> >
> >> > Signed-off-by: Shahar Levi <shahar_levi@ti.com>
> >>
> >> Hmh the name 'wl12xx' kind of implies it covers 1251, while in fact
> >> wl1251 is completely separate driver.. At least the Kconfig help text
> >> should mention it doesn't cover wl1251 and users should use respective
> >> driver for wl1251.
> >
> > That's a good point.  We have discussed this before and this was the
> > best solution we found.  The wl12xx driver includes support for wl1271
> > and wl1273, so we considered calling it wl127x, but in the near future,
> > we'll have support for wl1281 and wl1283 as well.  So we have to use
> > wl12xx.
> >
> > At least in my opinion, it is kind of clear that if there is a separate
> > driver for wl1251, the user would use that one.  In any case, A note in
> > the Kconfig help text would definitely not hurt.
> >
> > Shahar, could you please change the text in the Kconfig so that it reads
> > something like this?
> >
> > "This module adds support for wireless adapters based on TI wl1271 and
> > TI wl1273 chipsets.  This module does *not* include support for wl1251.
> > For wl1251 support, use the separate homonymous driver instead."
> 
> What about wl1251 vs. wl12agn (or wl12bgn if no .11a support), like iwlwifi?

Hmmm... wl1251 supports bg.  wl12xx supports abgn.  I don't really see
the logic in this? What difference does it make comparing to calling it
wl12xx? From wl12agn the user still doesn't know whether wl1251 is
supported or not.

-- 
Cheers,
Luca.

