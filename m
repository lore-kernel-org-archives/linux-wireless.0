Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:8709 "EHLO annwn14.rutgers.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754835AbXEMB5j (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 May 2007 21:57:39 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 2/2] Add rtl8187 wireless driver
Date: Sat, 12 May 2007 21:56:39 -0400
Cc: Jeff Garzik <jeff@garzik.org>, linux-wireless@vger.kernel.org,
	David Miller <davem@davemloft.net>,
	Andrea Merello <andrea.merello@gmail.com>
References: <20070511195642.8042.20407.stgit@panda.sourmilk.net> <200705111602.18729.flamingice@sourmilk.net> <20070512191823.GB6018@tuxdriver.com>
In-Reply-To: <20070512191823.GB6018@tuxdriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1663759.mmkjUlv217";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200705122156.43796.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1663759.mmkjUlv217
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 12 May 2007 15:18, John W. Linville wrote:
> On Fri, May 11, 2007 at 04:02:18PM -0400, Michael Wu wrote:
> > +void rtl8187_write_phy(struct ieee80211_hw *dev, u8 addr, u32 data)
> > +{
> > +	struct rtl8187_priv *priv =3D dev->priv;
> > +
> > +	data <<=3D 8;
> > +	data |=3D addr | 0x80;
> > +
> > +	rtl818x_iowrite8(priv, &priv->map->PHY[3], (data >> 24) & 0xFF);
> > +	rtl818x_iowrite8(priv, &priv->map->PHY[2], (data >> 16) & 0xFF);
> > +	rtl818x_iowrite8(priv, &priv->map->PHY[1], (data >> 8) & 0xFF);
> > +	rtl818x_iowrite8(priv, &priv->map->PHY[0], data & 0xFF);
> > +
> > +	msleep(1);
> > +}
>
> msleep seems better than mdelay, but why is it there at all?  There is
> no need to speculate.  Just give us a comment for why you put it there,
> even if it is "copied from app note" or somesuch.
>
Magic (copied from the original code). There are many magic seeming delays =
in=20
the code.. why single this one out?

> > +	msleep(200);
> > +	rtl818x_iowrite8(priv, (u8 *)0xFE18, 0x10);
> > +	rtl818x_iowrite8(priv, (u8 *)0xFE18, 0x11);
> > +	rtl818x_iowrite8(priv, (u8 *)0xFE18, 0x00);
> > +	msleep(200);
>
> Please comment these magic delays too, and give us a symbolic constant
> for the magic addres.  Yes, "RTL8187_MAGIC_INIT_ADDR_1" is better than a
> raw number. :-)
>
I can't say I agree on that. If it's just a number without any comments, it=
's=20
most likely magic. I don't want to put in #defines for constants which are=
=20
used once and merely serve the purpose of saying I don't know what it does.=
=20
That is counterproductive IMHO.

> > +	/* setup card */
> > +	rtl818x_iowrite8(priv, (u8 *)0xFF85, 0);
> > +	rtl818x_iowrite8(priv, &priv->map->GPIO, 0);
> > +
> > +	rtl818x_iowrite8(priv, (u8 *)0xFF85, 4);
>
> More magic addresses...
>
These are known. I'll add comments.

> > +	/* host_usb_init */
> > +	rtl818x_iowrite8(priv, (u8 *)0xFF85, 0);
> > +	rtl818x_iowrite8(priv, &priv->map->GPIO, 0);
> > +	reg =3D rtl818x_ioread8(priv, (u8 *)0xFE53);
> > +	rtl818x_iowrite8(priv, (u8 *)0xFE53, reg | (1 << 7));
> > +	rtl818x_iowrite8(priv, (u8 *)0xFF85, 4);
>
> And more...
>
Some of these are known too.

> > +	rtl818x_iowrite16(priv, (__le16 *)0xFFFE, 0x10);
> > +	rtl818x_iowrite8(priv, &priv->map->TALLY_SEL, 0x80);
> > +	rtl818x_iowrite8(priv, (u8 *)0xFFFF, 0x60);
>
> And more...
>
> > +static void rtl8187_register_read(struct eeprom_93cx6 *eeprom)
> > +{
> > +	struct ieee80211_hw *dev =3D eeprom->data;
> > +	struct rtl8187_priv *priv =3D dev->priv;
> > +	u8 reg =3D rtl818x_ioread8(priv, &priv->map->EEPROM_CMD);
> > +
> > +	eeprom->reg_data_in =3D reg & RTL818X_EEPROM_CMD_WRITE;
> > +	eeprom->reg_data_out =3D reg & RTL818X_EEPROM_CMD_READ;
> > +	eeprom->reg_data_clock =3D reg & RTL818X_EEPROM_CMD_CK;
> > +	eeprom->reg_chip_select =3D reg & RTL818X_EEPROM_CMD_CS;
> > +}
> > +
> > +static void rtl8187_register_write(struct eeprom_93cx6 *eeprom)
> > +{
> > +	struct ieee80211_hw *dev =3D eeprom->data;
> > +	struct rtl8187_priv *priv =3D dev->priv;
> > +	u8 reg =3D RTL818X_EEPROM_CMD_PROGRAM;
> > +
> > +	if (eeprom->reg_data_in)
> > +		reg |=3D RTL818X_EEPROM_CMD_WRITE;
> > +	if (eeprom->reg_data_out)
> > +		reg |=3D RTL818X_EEPROM_CMD_READ;
> > +	if (eeprom->reg_data_clock)
> > +		reg |=3D RTL818X_EEPROM_CMD_CK;
> > +	if (eeprom->reg_chip_select)
> > +		reg |=3D RTL818X_EEPROM_CMD_CS;
> > +
> > +	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, reg);
> > +	udelay(10);
> > +}
>
> It seems like these should be named "rtl8187_eeprom_register_{read,write}"
> instead?  Current names seem like you are operating on the wireless
> parts instead of just the eeprom.
>
Sure.

> > +	if (!is_valid_ether_addr(dev->wiphy->perm_addr)) {
> > +		printk(KERN_WARNING "rtl8187: Invalid hwaddr! Using randomly generat=
ed
> > MAC address\n");
>
> I would prefer to see lines wrapped at 80 columns (or less) if at all
> possible.
>
OK.

> > +	for (i =3D 0; i < 3; i++) {
> > +		eeprom_93cx6_read(&eeprom, 0x16 + i, &txpwr);
> > +		(*channel++).val =3D txpwr & 0xFF;
> > +		(*channel++).val =3D txpwr >> 8;
> > +	}
> > +	for (i =3D 0; i < 2; i++) {
> > +		eeprom_93cx6_read(&eeprom, 0x3D + i, &txpwr);
> > +		(*channel++).val =3D txpwr & 0xFF;
> > +		(*channel++).val =3D txpwr >> 8;
> > +	}
> > +	for (i =3D 0; i < 2; i++) {
> > +		eeprom_93cx6_read(&eeprom, 0x1B + i, &txpwr);
> > +		(*channel++).val =3D txpwr & 0xFF;
> > +		(*channel++).val =3D txpwr >> 8;
> > +	}
> > +
> > +	eeprom_93cx6_read(&eeprom, 0x05, &priv->txpwr_base);
>
> Magic offsets for the eeprom data...
>
Will add comments.

> More magic number tables of unknown origin...you get the idea. :-)  I
> realize that these are either copied straight from a datasheet or from
> someone's reverse engineered sources -- let's just have a comment saying
> so for each block of these.
>
The *entire* rtl8187_rtl8225.c file is full of magic numbers. I'm not willi=
ng=20
to put comments saying so for every single function/definition. I really=20
don't know what's going on in that file.

> > +	__le32	TX_CONF;
> > +#define RTL818X_TX_CONF_LOOPBACK_MAC	(1 << 17)
> > +#define RTL818X_TX_CONF_NO_ICV		(1 << 19)
> > +#define RTL818X_TX_CONF_DISCW		(1 << 20)
> > +#define RTL818X_TX_CONF_R8180_ABCD	(2 << 25)
> > +#define RTL818X_TX_CONF_R8180_F		(3 << 25)
> > +#define RTL818X_TX_CONF_R8185_ABC	(4 << 25)
> > +#define RTL818X_TX_CONF_R8185_D		(5 << 25)
> > +#define RTL818X_TX_CONF_HWVER_MASK	(7 << 25)
> > +#define RTL818X_TX_CONF_CW_MIN		(1 << 31)
>
> Using an enum for a sparsely defined bitmask like this should let the
> compiler identify if we misuse a bitmask in the wrong place.
>
How? Can you give an example?

> Do we lose the benefits of the __le32 typechecking by using an enum?
> There is probably some way to force that...
>
Bitmasks and register offsets are rarely typechecked in the first place. Wh=
y=20
does rtl8187 need to be so much better? I don't see any problem with the=20
bitmask definitions in rtl8187, as the register name prefixes make it obvio=
us=20
what bits should go with which registers.

Thanks,
=2DMichael Wu

--nextPart1663759.mmkjUlv217
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGRnBbT3Oqt9AH4aERAmRRAKCiJzxp5HgCmHWRKvuEQbuGnk14/QCfXRoq
FklzwoUg3qSZF42F00mi99Q=
=7f3U
-----END PGP SIGNATURE-----

--nextPart1663759.mmkjUlv217--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
