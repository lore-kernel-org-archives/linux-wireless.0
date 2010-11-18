Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:17610 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975Ab0KRGVO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 01:21:14 -0500
Subject: RE: [PATCH v4] wl1271: Change wl12xx Files Names
From: Luciano Coelho <luciano.coelho@nokia.com>
To: "ext Krakowski, Oz" <ozk@ti.com>
Cc: "Gabay, Benzy" <benzyg@ti.com>,
	ext =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
	ext Grazvydas Ignotas <notasas@gmail.com>,
	"Levi, Shahar" <shahar_levi@ti.com>, Kalle Valo <kvalo@adurom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <B3E8D1AE4503414CAFD215C4B3688A0501EF42D70641@dlee07.ent.ti.com>
References: <1288883257-30060-1-git-send-email-shahar_levi@ti.com>
	 <AANLkTincpxdpmf5J38LiGsF-d9dG7sG9-bjbkH-B8Ld0@mail.gmail.com>
	 <1288891196.17643.6.camel@powerslave>
	 <AANLkTi=Luv2+5Hys2PcrH+G8jmc4vwz8PM0LFKm+fTt8@mail.gmail.com>
	 <1288907555.17643.14.camel@powerslave>
	 <676FD6AA0F002F49B89E70F0C5EFD22C136DEA0A14@dlee04.ent.ti.com>
	 <1290019712.28892.5.camel@powerslave>
	 <676FD6AA0F002F49B89E70F0C5EFD22C136DEA102C@dlee04.ent.ti.com>
	 <B3E8D1AE4503414CAFD215C4B3688A0501EF42D70641@dlee07.ent.ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Nov 2010 08:21:05 +0200
Message-ID: <1290061265.28892.17.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-11-17 at 23:18 -0600, ext Krakowski, Oz wrote:
> Benzy,
> 
> 
> > > Doesn't help much.  The problem is that the driver which is now called
> > > wl12xx already support wl1271 and wl1273.  In the near future, it will
> > > also support wl1281 and wl1283, so the wl6 or wilink6 scheme would
> > > break
> > > already.
> > >
> > > The wl1251 driver, at least at the moment, only supports wl1251, it
> > > doesn't have the 11a implementation.  If in the future someone adds
> > > support for wl1253, it could be renamed to wl125x.
> > >
> > > In any case, I think the name of the driver is not that important, as
> > > long as we're clear about which chips each one of them supports in the
> > > Kconfig description.
> > >
> > > Renaming the driver all the time (we already did it twice), ends up
> > > confusing more than clarifying things.
> > >
> > > --
> > > Cheers,
> > > Luca.
> > 
> > mmm...
> > 
> > In that case, another idea:
> > 1. why not create new driver source code which will designated for 128x.
> > 2. If we have a problem with unified 12xx then lets dived it completely to sub drivers and
> > have only common part as a unified driver. That way you get to keep the old names and
> > just divide the files content to a new file name wl12xx.c.
> > 
> > e.g:
> > wl1251.c wl1253.c  common part
> > wl1271.c wl1273.c  ---------->  wl12xx.c
> > wl1281.c wl1283.c
> > 
> 
> I agree with Luca here. The names have been changed recently and anyway represent both chipsets (127x and 128x) in a way that makes sense. I don't think we should make any changes to that. 
> Also re-writing the driver into a new partitioning does not serve any special need IMO. Especially since wilink6 and wilink7 share the same driver essentially.

Yeah, we tried to have a common part for the wl1251 and wl1251 when we
started implementing support for wl1271.  But the firmware API was very
different between the two, so we realized it was better to completely
split them into two.

Now, for the wl1281/3, your colleagues at TI are claiming that the
differences are tiny, so wl1281/3 should fit easily in the same driver
and we'll make the differentiation at runtime.

Thanks for your suggestions anyway! Let's keep them in mind in case
things don't go as expected and if we have to split the drivers again
for wl1281/3.  But at least for now, I think it's good as it is (famous
last words).

-- 
Cheers,
Luca.

