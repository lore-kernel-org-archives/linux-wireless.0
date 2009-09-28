Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45989 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbZI1UAy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2009 16:00:54 -0400
Date: Mon, 28 Sep 2009 15:50:40 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Joerg Albert <jal2@gmx.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-wireless@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] ar9170: implement frequency calibration for
	one-stage/openfw
Message-ID: <20090928195040.GD4737@tuxdriver.com>
References: <200909032025.31260.chunkeey@googlemail.com> <20090918170211.8acce2cc.akpm@linux-foundation.org> <4AB4CCD0.5080003@gmx.de> <20090928184111.GB4737@tuxdriver.com> <22ee4e770909281245g3346a800n940c28199e429abf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <22ee4e770909281245g3346a800n940c28199e429abf@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 28, 2009 at 09:45:28PM +0200, Christian Lamparter wrote:
> 2009/9/28 John W. Linville <linville@tuxdriver.com>:
> > On Sat, Sep 19, 2009 at 02:21:36PM +0200, Joerg Albert wrote:
> >> On 09/19/2009 02:02 AM, Andrew Morton wrote:

> >> > How did this get all the way into mainline?
> >>
> >> Strangely it compiles without any warning for me with the latest linux-wireless:
> >
> > That is strange -- no warning here (F-11) either...
> >
> > Christian, care to propose a patch?  Or maybe just something like this?
> >
> > diff --git a/drivers/net/wireless/ath/ar9170/phy.c b/drivers/net/wireless/ath/ar9170/phy.c
> > index b3e5cf3..49c10cb 100644
> > --- a/drivers/net/wireless/ath/ar9170/phy.c
> > +++ b/drivers/net/wireless/ath/ar9170/phy.c
> > @@ -1220,7 +1220,7 @@ static int ar9170_set_freq_cal_data(struct ar9170 *ar,
> >                                                             &vpds[1][0]);
> >                        }
> >
> > -                       phy_data |= tmp << ((i & 3) << 3);
> > +                       phy_data = tmp << ((i & 3) << 3);
> >                        if ((i & 3) == 3) {
> >                                ar9170_regwrite(0x1c6280 + chain * 0x1000 +
> >                                                (i & ~3), phy_data);
> >
> > John
> no? Andrew Morton's mail included a tiny patch which initializes the
> phy_data to 0. I assumed you would pick it up right away...
> Or is there something which would prevent it from including?

Don't know what email you got, but there was no patch in my inbox...

So, I presume you have no objection to the patch above?  Initializing
phy_data just to unconditionally assign to it doesn't seem any better.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
