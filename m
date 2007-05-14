Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3991 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756721AbXENUcu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 May 2007 16:32:50 -0400
Date: Mon, 14 May 2007 16:29:29 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Jeff Garzik <jeff@garzik.org>, linux-wireless@vger.kernel.org,
	David Miller <davem@davemloft.net>,
	Andrea Merello <andrea.merello@gmail.com>
Subject: Re: [PATCH 2/2] Add rtl8187 wireless driver
Message-ID: <20070514202929.GD6999@tuxdriver.com>
References: <20070511195642.8042.20407.stgit@panda.sourmilk.net> <200705111602.18729.flamingice@sourmilk.net> <20070512191823.GB6018@tuxdriver.com> <200705122156.43796.flamingice@sourmilk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200705122156.43796.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 12, 2007 at 09:56:39PM -0400, Michael Wu wrote:
> On Saturday 12 May 2007 15:18, John W. Linville wrote:
> > On Fri, May 11, 2007 at 04:02:18PM -0400, Michael Wu wrote:
> > > +void rtl8187_write_phy(struct ieee80211_hw *dev, u8 addr, u32 data)
> > > +{
> > > +	struct rtl8187_priv *priv = dev->priv;
> > > +
> > > +	data <<= 8;
> > > +	data |= addr | 0x80;
> > > +
> > > +	rtl818x_iowrite8(priv, &priv->map->PHY[3], (data >> 24) & 0xFF);
> > > +	rtl818x_iowrite8(priv, &priv->map->PHY[2], (data >> 16) & 0xFF);
> > > +	rtl818x_iowrite8(priv, &priv->map->PHY[1], (data >> 8) & 0xFF);
> > > +	rtl818x_iowrite8(priv, &priv->map->PHY[0], data & 0xFF);
> > > +
> > > +	msleep(1);
> > > +}
> >
> > msleep seems better than mdelay, but why is it there at all?  There is
> > no need to speculate.  Just give us a comment for why you put it there,
> > even if it is "copied from app note" or somesuch.
> >
> Magic (copied from the original code). There are many magic seeming delays in 
> the code.. why single this one out?

Not really singling it out.  Anyway, see response to next block.

> > > +	msleep(200);
> > > +	rtl818x_iowrite8(priv, (u8 *)0xFE18, 0x10);
> > > +	rtl818x_iowrite8(priv, (u8 *)0xFE18, 0x11);
> > > +	rtl818x_iowrite8(priv, (u8 *)0xFE18, 0x00);
> > > +	msleep(200);
> >
> > Please comment these magic delays too, and give us a symbolic constant
> > for the magic addres.  Yes, "RTL8187_MAGIC_INIT_ADDR_1" is better than a
> > raw number. :-)
> >
> I can't say I agree on that. If it's just a number without any comments, it's 
> most likely magic. I don't want to put in #defines for constants which are 
> used once and merely serve the purpose of saying I don't know what it does. 
> That is counterproductive IMHO.

If you don't know why it is there, how about a comment indicating
what gave you the notion of putting it there?  E.g. "copied from
realtek example code" or somesuch?

For this block in particular, I think you had stated that the
hardware works without it.  Is there any reason not to just remove it?
Just precaution?
 
> > More magic number tables of unknown origin...you get the idea. :-)  I
> > realize that these are either copied straight from a datasheet or from
> > someone's reverse engineered sources -- let's just have a comment saying
> > so for each block of these.
> >
> The *entire* rtl8187_rtl8225.c file is full of magic numbers. I'm not willing 
> to put comments saying so for every single function/definition. I really 
> don't know what's going on in that file.

OK, "each block" would be excessive if they all come from the
same place.  A single comment is probably fine.  I do see "Based on
the r8187 driver" at the top, but more information would be better.
Since Andrea is still around maybe the origin of that information is
still identifiable?
 
> > > +	__le32	TX_CONF;
> > > +#define RTL818X_TX_CONF_LOOPBACK_MAC	(1 << 17)
> > > +#define RTL818X_TX_CONF_NO_ICV		(1 << 19)
> > > +#define RTL818X_TX_CONF_DISCW		(1 << 20)
> > > +#define RTL818X_TX_CONF_R8180_ABCD	(2 << 25)
> > > +#define RTL818X_TX_CONF_R8180_F		(3 << 25)
> > > +#define RTL818X_TX_CONF_R8185_ABC	(4 << 25)
> > > +#define RTL818X_TX_CONF_R8185_D		(5 << 25)
> > > +#define RTL818X_TX_CONF_HWVER_MASK	(7 << 25)
> > > +#define RTL818X_TX_CONF_CW_MIN		(1 << 31)
> >
> > Using an enum for a sparsely defined bitmask like this should let the
> > compiler identify if we misuse a bitmask in the wrong place.
> >
> How? Can you give an example?

--------------------------------------------------------------------------------

enum foo {
	FOO_BIT_BLAH	= (1 << 1),
	FOO_BIT_BLECH	= (1 << 2),
};

enum bar {
	BAR_BIT_BLAH	= (1 << 3),
	BAR_BIT_BLECH	= (1 << 4),
};

void blather(void)
{
	enum foo drizzle;

	drizzle = BAR_BIT_BLAH;
}

--------------------------------------------------------------------------------

[linville-t43.mobile]:> sparse example.c
example.c:15:12: warning: mixing different enum types
example.c:15:12:     int [signed] enum bar  versus
example.c:15:12:     int [signed] enum foo

> > Do we lose the benefits of the __le32 typechecking by using an enum?
> > There is probably some way to force that...
> >
> Bitmasks and register offsets are rarely typechecked in the first place. Why 
> does rtl8187 need to be so much better? I don't see any problem with the 
> bitmask definitions in rtl8187, as the register name prefixes make it obvious 
> what bits should go with which registers.

I don't know if I consider this a merge blocker.  Still, if sparse can
help us find "thinko" bugs it would be better to enable it to do so.

Interdiff from the prior version also shows this:

@@ -485,25 +485,16 @@
 
 	rtl818x_iowrite8(priv, &priv->map->SIFS, 0x22);
 
-	if (conf->flags & IEEE80211_CONF_SHORT_SLOT_TIME)
+	if (conf->flags & IEEE80211_CONF_SHORT_SLOT_TIME) {
 		rtl818x_iowrite8(priv, &priv->map->SLOT, 0x9);
-	else
+		rtl818x_iowrite8(priv, &priv->map->DIFS, 0x14);
+		rtl818x_iowrite8(priv, &priv->map->EIFS, 91 - 0x14);
+		rtl818x_iowrite8(priv, &priv->map->CW_VAL, 0x73);
+	} else {
 		rtl818x_iowrite8(priv, &priv->map->SLOT, 0x14);
-
-	switch (conf->phymode) {
-	case MODE_IEEE80211B:
 		rtl818x_iowrite8(priv, &priv->map->DIFS, 0x24);
 		rtl818x_iowrite8(priv, &priv->map->EIFS, 91 - 0x24);
 		rtl818x_iowrite8(priv, &priv->map->CW_VAL, 0xa5);
-		break;
-	case MODE_IEEE80211G:
-		rtl818x_iowrite8(priv, &priv->map->DIFS, 0x14);
-		rtl818x_iowrite8(priv, &priv->map->EIFS, 91 - 0x14);
-		rtl818x_iowrite8(priv, &priv->map->CW_VAL, 0x73);
-		break;
-	default:
-		BUG();
-		break;
 	}
 
 	rtl818x_iowrite16(priv, &priv->map->ATIM_WND, 2);

Which seems alright, but I wanted to make sure it was intentional.

John
-- 
John W. Linville
linville@tuxdriver.com
