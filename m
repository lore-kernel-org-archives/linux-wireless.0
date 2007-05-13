Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.182]:28112 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756924AbXEMKHa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 May 2007 06:07:30 -0400
Received: by ik-out-1112.google.com with SMTP id b35so888099ika
        for <linux-wireless@vger.kernel.org>; Sun, 13 May 2007 03:07:29 -0700 (PDT)
Message-ID: <c68f135e0705130307o6ed5949fhb21f1b6e022c9601@mail.gmail.com>
Date: Sun, 13 May 2007 12:07:28 +0200
From: "Andrea Merello" <andrea.merello@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 2/2] Add rtl8187 wireless driver
Cc: "Michael Wu" <flamingice@sourmilk.net>,
	"Jeff Garzik" <jeff@garzik.org>, linux-wireless@vger.kernel.org,
	"David Miller" <davem@davemloft.net>
In-Reply-To: <200705122156.43796.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <20070511195642.8042.20407.stgit@panda.sourmilk.net>
	 <200705111602.18729.flamingice@sourmilk.net>
	 <20070512191823.GB6018@tuxdriver.com>
	 <200705122156.43796.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/13/07, Michael Wu <flamingice@sourmilk.net> wrote:
> On Saturday 12 May 2007 15:18, John W. Linville wrote:
> > On Fri, May 11, 2007 at 04:02:18PM -0400, Michael Wu wrote:
> > > +void rtl8187_write_phy(struct ieee80211_hw *dev, u8 addr, u32 data)
> > > +{
> > > +   struct rtl8187_priv *priv = dev->priv;
> > > +
> > > +   data <<= 8;
> > > +   data |= addr | 0x80;
> > > +
> > > +   rtl818x_iowrite8(priv, &priv->map->PHY[3], (data >> 24) & 0xFF);
> > > +   rtl818x_iowrite8(priv, &priv->map->PHY[2], (data >> 16) & 0xFF);
> > > +   rtl818x_iowrite8(priv, &priv->map->PHY[1], (data >> 8) & 0xFF);
> > > +   rtl818x_iowrite8(priv, &priv->map->PHY[0], data & 0xFF);
> > > +
> > > +   msleep(1);
> > > +}
> >
> > msleep seems better than mdelay, but why is it there at all?

I *THINK* the one msleep you have quoted, most likely, is here because
after 1 msec we are sure the baseband register has been really
written, and/or the BB has done it's work.

We don't know (nearly) anything about the BB.
But I can think about two possible reasons for the delay:

1) The MAC communicates with the BB in some unknown method. let's
imagine it's uses a serial bus. If the mac is still accessing those
reigisters to complete serial bit-banging write and we fire another BB
write we will have a problem. The first write fails or invalid data
and/or invalid address are written, and it is possible the second
write fails too.

2) Maybe this is used to ensure internal serializations. Suppose the
MAC have no problem to do writes fast enough.
What's happen if we do a write that changes register page and we then
write on a register without waiting for the register page to be
changed? Or we try to do a calibration before some values has been
updated in some magic HW stage to power up a particular circuit? Maybe
1msec is a safety values that ensures all BB operations has been
completed.

Maybe  a combination of 1) and 2) is why the value is here.

A bit verbose...I think writing all those suppositions on the code is
not very good, I'm not sure enough about those interpretations.. And
those are just the obvious things all people who will read the code
will imagine by themselves, I suppose.

> > There is
> > no need to speculate.  Just give us a comment for why you put it there,
> > even if it is "copied from app note" or somesuch.
> >
> Magic (copied from the original code). There are many magic seeming delays in
> the code.. why single this one out?

..And the original code I wrote contains those delays because Realtek
gave me sample programming code that contanined them, or, for some of
those delays Realtek changed the code directly or told me that they
are needed to make sure the chip work correctly..

> > > +   msleep(200);
> > > +   rtl818x_iowrite8(priv, (u8 *)0xFE18, 0x10);
> > > +   rtl818x_iowrite8(priv, (u8 *)0xFE18, 0x11);
> > > +   rtl818x_iowrite8(priv, (u8 *)0xFE18, 0x00);
> > > +   msleep(200);
> >
> > Please comment these magic delays too, and give us a symbolic constant
> > for the magic addres.  Yes, "RTL8187_MAGIC_INIT_ADDR_1" is better than a
> > raw number. :-)
> >
> I can't say I agree on that. If it's just a number without any comments, it's
> most likely magic. I don't want to put in #defines for constants which are
> used once and merely serve the purpose of saying I don't know what it does.
> That is counterproductive IMHO.

I agree with Michael. I think filling file with a lot of define is
useful only if those defines improve readability of the code, by
clarify what those values means. This is not the case.

> > More magic number tables of unknown origin...you get the idea. :-)  I
> > realize that these are either copied straight from a datasheet or from
> > someone's reverse engineered sources -- let's just have a comment saying
> > so for each block of these.
> >
> The *entire* rtl8187_rtl8225.c file is full of magic numbers. I'm not willing
> to put comments saying so for every single function/definition. I really
> don't know what's going on in that file.

Absolutely agree with Michael ;-)

Indeed I think that a note at the beginning of the file that notice
about the fact that most is magic should be enough. I can't see any
reason to be repetitive and to say everywhere "we don't know exactly.
maybe can be this, or that" etc.. why do you need explanation for each
table, value, etc? I even don't remember witch values has been touched
by Realtek directly and which has been suggested me by them, etc..

Thanks
Andrea
