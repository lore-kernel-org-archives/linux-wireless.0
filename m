Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3771 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755880AbXENVCr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 May 2007 17:02:47 -0400
Date: Mon, 14 May 2007 16:34:10 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Andrea Merello <andrea.merello@gmail.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	Jeff Garzik <jeff@garzik.org>, linux-wireless@vger.kernel.org,
	David Miller <davem@davemloft.net>
Subject: Re: [PATCH 2/2] Add rtl8187 wireless driver
Message-ID: <20070514203410.GE6999@tuxdriver.com>
References: <20070511195642.8042.20407.stgit@panda.sourmilk.net> <200705111602.18729.flamingice@sourmilk.net> <20070512191823.GB6018@tuxdriver.com> <200705122156.43796.flamingice@sourmilk.net> <c68f135e0705130307o6ed5949fhb21f1b6e022c9601@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <c68f135e0705130307o6ed5949fhb21f1b6e022c9601@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 13, 2007 at 12:07:28PM +0200, Andrea Merello wrote:
> On 5/13/07, Michael Wu <flamingice@sourmilk.net> wrote:
> >On Saturday 12 May 2007 15:18, John W. Linville wrote:
> >> On Fri, May 11, 2007 at 04:02:18PM -0400, Michael Wu wrote:
> >> > +void rtl8187_write_phy(struct ieee80211_hw *dev, u8 addr, u32 data)
> >> > +{
> >> > +   struct rtl8187_priv *priv = dev->priv;
> >> > +
> >> > +   data <<= 8;
> >> > +   data |= addr | 0x80;
> >> > +
> >> > +   rtl818x_iowrite8(priv, &priv->map->PHY[3], (data >> 24) & 0xFF);
> >> > +   rtl818x_iowrite8(priv, &priv->map->PHY[2], (data >> 16) & 0xFF);
> >> > +   rtl818x_iowrite8(priv, &priv->map->PHY[1], (data >> 8) & 0xFF);
> >> > +   rtl818x_iowrite8(priv, &priv->map->PHY[0], data & 0xFF);
> >> > +
> >> > +   msleep(1);
> >> > +}
> >>
> >> msleep seems better than mdelay, but why is it there at all?

<speculation snipped>

> A bit verbose...I think writing all those suppositions on the code is
> not very good, I'm not sure enough about those interpretations.. And
> those are just the obvious things all people who will read the code
> will imagine by themselves, I suppose.
 
See the part you quoted immediately below.

> >> There is
> >> no need to speculate.  Just give us a comment for why you put it there,
> >> even if it is "copied from app note" or somesuch.
> >>
> >Magic (copied from the original code). There are many magic seeming delays 
> >in
> >the code.. why single this one out?
> 
> ..And the original code I wrote contains those delays because Realtek
> gave me sample programming code that contanined them, or, for some of
> those delays Realtek changed the code directly or told me that they
> are needed to make sure the chip work correctly..

Fine.  Would you mind send a patch to Michael or me putting a comment
to that effect into the code?

> 
> >> > +   msleep(200);
> >> > +   rtl818x_iowrite8(priv, (u8 *)0xFE18, 0x10);
> >> > +   rtl818x_iowrite8(priv, (u8 *)0xFE18, 0x11);
> >> > +   rtl818x_iowrite8(priv, (u8 *)0xFE18, 0x00);
> >> > +   msleep(200);
> >>
> >> Please comment these magic delays too, and give us a symbolic constant
> >> for the magic addres.  Yes, "RTL8187_MAGIC_INIT_ADDR_1" is better than a
> >> raw number. :-)
> >>
> >I can't say I agree on that. If it's just a number without any comments, 
> >it's
> >most likely magic. I don't want to put in #defines for constants which are
> >used once and merely serve the purpose of saying I don't know what it does.
> >That is counterproductive IMHO.
> 
> I agree with Michael. I think filling file with a lot of define is
> useful only if those defines improve readability of the code, by
> clarify what those values means. This is not the case.

Bare hexadecimal isn't too wonderful either.  Anyway, see my reply
to Michael's post asking for a comment explaining the code fragment's
origin as an alternative.

> 
> >> More magic number tables of unknown origin...you get the idea. :-)  I
> >> realize that these are either copied straight from a datasheet or from
> >> someone's reverse engineered sources -- let's just have a comment saying
> >> so for each block of these.
> >>
> >The *entire* rtl8187_rtl8225.c file is full of magic numbers. I'm not 
> >willing
> >to put comments saying so for every single function/definition. I really
> >don't know what's going on in that file.
> 
> Absolutely agree with Michael ;-)
> 
> Indeed I think that a note at the beginning of the file that notice
> about the fact that most is magic should be enough. I can't see any

ACK, as in my reply to Michael.

John
-- 
John W. Linville
linville@tuxdriver.com
