Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:36475 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756037AbXEQFt3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 May 2007 01:49:29 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 2/2] Add rtl8187 wireless driver
Date: Thu, 17 May 2007 01:48:02 -0400
Cc: Jeff Garzik <jeff@garzik.org>, linux-wireless@vger.kernel.org,
	David Miller <davem@davemloft.net>,
	Andrea Merello <andrea.merello@gmail.com>
References: <20070511195642.8042.20407.stgit@panda.sourmilk.net> <200705122156.43796.flamingice@sourmilk.net> <20070514202929.GD6999@tuxdriver.com>
In-Reply-To: <20070514202929.GD6999@tuxdriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart131045661.kD45mmJZz5";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200705170148.06683.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart131045661.kD45mmJZz5
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 14 May 2007 16:29, John W. Linville wrote:
> If you don't know why it is there, how about a comment indicating
> what gave you the notion of putting it there?  E.g. "copied from
> realtek example code" or somesuch?
>
The driver is mostly a port of the original r8187 driver.

> For this block in particular, I think you had stated that the
> hardware works without it.  Is there any reason not to just remove it?
> Just precaution?
>
Yes. Don't want to change code that's known to be working at this point.

> > > More magic number tables of unknown origin...you get the idea. :-)  I
> > > realize that these are either copied straight from a datasheet or from
> > > someone's reverse engineered sources -- let's just have a comment
> > > saying so for each block of these.
> >
> > The *entire* rtl8187_rtl8225.c file is full of magic numbers. I'm not
> > willing to put comments saying so for every single function/definition.=
 I
> > really don't know what's going on in that file.
>
> OK, "each block" would be excessive if they all come from the
> same place.  A single comment is probably fine.  I do see "Based on
> the r8187 driver" at the top, but more information would be better.
> Since Andrea is still around maybe the origin of that information is
> still identifiable?
>
The r8187 driver is still around. (Realtek has it on their website) For the=
=20
most part, that information is comes from some Realtek engineer(s).

> -------------------------------------------------------------------------=
=2D-
>-----
>
> enum foo {
> 	FOO_BIT_BLAH	=3D (1 << 1),
> 	FOO_BIT_BLECH	=3D (1 << 2),
> };
>
> enum bar {
> 	BAR_BIT_BLAH	=3D (1 << 3),
> 	BAR_BIT_BLECH	=3D (1 << 4),
> };
>
> void blather(void)
> {
> 	enum foo drizzle;
>
> 	drizzle =3D BAR_BIT_BLAH;
> }
>
> -------------------------------------------------------------------------=
=2D-
>-----
>
> [linville-t43.mobile]:> sparse example.c
> example.c:15:12: warning: mixing different enum types
> example.c:15:12:     int [signed] enum bar  versus
> example.c:15:12:     int [signed] enum foo
>
That's what I thought.. but it's not that useful for me. Using the wrong=20
register bit definition is extremely unlikely to happen. (I've never done=20
it.) However, using the wrong size register read or write function happens=
=20
and has been caught a number of times by the register typechecking.

> Interdiff from the prior version also shows this:
>
> @@ -485,25 +485,16 @@
>
>  	rtl818x_iowrite8(priv, &priv->map->SIFS, 0x22);
>
> -	if (conf->flags & IEEE80211_CONF_SHORT_SLOT_TIME)
> +	if (conf->flags & IEEE80211_CONF_SHORT_SLOT_TIME) {
>  		rtl818x_iowrite8(priv, &priv->map->SLOT, 0x9);
> -	else
> +		rtl818x_iowrite8(priv, &priv->map->DIFS, 0x14);
> +		rtl818x_iowrite8(priv, &priv->map->EIFS, 91 - 0x14);
> +		rtl818x_iowrite8(priv, &priv->map->CW_VAL, 0x73);
> +	} else {
>  		rtl818x_iowrite8(priv, &priv->map->SLOT, 0x14);
> -
> -	switch (conf->phymode) {
> -	case MODE_IEEE80211B:
>  		rtl818x_iowrite8(priv, &priv->map->DIFS, 0x24);
>  		rtl818x_iowrite8(priv, &priv->map->EIFS, 91 - 0x24);
>  		rtl818x_iowrite8(priv, &priv->map->CW_VAL, 0xa5);
> -		break;
> -	case MODE_IEEE80211G:
> -		rtl818x_iowrite8(priv, &priv->map->DIFS, 0x14);
> -		rtl818x_iowrite8(priv, &priv->map->EIFS, 91 - 0x14);
> -		rtl818x_iowrite8(priv, &priv->map->CW_VAL, 0x73);
> -		break;
> -	default:
> -		BUG();
> -		break;
>  	}
>
>  	rtl818x_iowrite16(priv, &priv->map->ATIM_WND, 2);
>
> Which seems alright, but I wanted to make sure it was intentional.
>
Yup, it's intentional.

=2DMichael Wu

--nextPart131045661.kD45mmJZz5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGS+yWT3Oqt9AH4aERAnyBAJ49bOrNDTDqeXovZ4vEuBpJ8IRpiwCggHw2
SYTqfFOlAmXqBV0L89tFKBI=
=1+Sp
-----END PGP SIGNATURE-----

--nextPart131045661.kD45mmJZz5--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
