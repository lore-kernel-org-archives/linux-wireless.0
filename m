Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:59026 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758314Ab0KQSss (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Nov 2010 13:48:48 -0500
Subject: RE: [PATCH v4] wl1271: Change wl12xx Files Names
From: Luciano Coelho <luciano.coelho@nokia.com>
To: "ext Gabay, Benzy" <benzyg@ti.com>
Cc: ext =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
	ext Grazvydas Ignotas <notasas@gmail.com>,
	"Levi, Shahar" <shahar_levi@ti.com>, Kalle Valo <kvalo@adurom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <676FD6AA0F002F49B89E70F0C5EFD22C136DEA0A14@dlee04.ent.ti.com>
References: <1288883257-30060-1-git-send-email-shahar_levi@ti.com>
	 <AANLkTincpxdpmf5J38LiGsF-d9dG7sG9-bjbkH-B8Ld0@mail.gmail.com>
	 <1288891196.17643.6.camel@powerslave>
	 <AANLkTi=Luv2+5Hys2PcrH+G8jmc4vwz8PM0LFKm+fTt8@mail.gmail.com>
	 <1288907555.17643.14.camel@powerslave>
	 <676FD6AA0F002F49B89E70F0C5EFD22C136DEA0A14@dlee04.ent.ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Nov 2010 20:48:32 +0200
Message-ID: <1290019712.28892.5.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-11-17 at 12:08 -0600, ext Gabay, Benzy wrote:
> Hi All,

Hi Benzy,


> > > What about wl1251 vs. wl12agn (or wl12bgn if no .11a support), like
> > iwlwifi?
> > 
> > Hmmm... wl1251 supports bg.  wl12xx supports abgn.  I don't really see
> > the logic in this? What difference does it make comparing to calling it
> > wl12xx? From wl12agn the user still doesn't know whether wl1251 is
> > supported or not. 
> 
> I have another idea for naming convention here.
> But first to align everyone on the TI chip conventions:
> 12x1 == support for 2.4Ghz
> 12x3 == supports both 2.4Ghz and 5.0Ghz.
> 
> The TI project naming convention per chip is as follow:
> 
> wilink4 == 1251 and 1253
> wilink6 == 1271 and 1273
> wilink7 == 1281 and 1281
> 
> So I propose to use the project name instead of using the chip name.
> e.g.: 
> for wl125x we can use: wl4 or wilink4. If we want to imply the band support: wl4_abg and wl4_bg
> for wl127x we can use: wl6 or wilink6. If we want to imply the band and capability support: wl6_abgn and wl4_bgn
> 
> etc'
> 
> What say?

Doesn't help much.  The problem is that the driver which is now called
wl12xx already support wl1271 and wl1273.  In the near future, it will
also support wl1281 and wl1283, so the wl6 or wilink6 scheme would break
already.

The wl1251 driver, at least at the moment, only supports wl1251, it
doesn't have the 11a implementation.  If in the future someone adds
support for wl1253, it could be renamed to wl125x.

In any case, I think the name of the driver is not that important, as
long as we're clear about which chips each one of them supports in the
Kconfig description.

Renaming the driver all the time (we already did it twice), ends up
confusing more than clarifying things.

-- 
Cheers,
Luca.

