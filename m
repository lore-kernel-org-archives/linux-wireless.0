Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web4.futuron.fi ([217.149.52.4]:49939 "EHLO web4.futuron.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755945AbZLEPcy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Dec 2009 10:32:54 -0500
Subject: Re: New rtl8187 rfkill support blocks my wlan for good.
From: Antti =?ISO-8859-1?Q?Kaijanm=E4ki?= <antti@kaijanmaki.net>
To: Hin-Tak Leung <hintak.leung@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1260017628.31590.964.camel@peura.elisa-laajakaista.fi>
References: <1259756709.31590.62.camel@peura.elisa-laajakaista.fi>
	 <4B169608.3010902@lwfinger.net>
	 <1259822699.31590.914.camel@peura.elisa-laajakaista.fi>
	 <4B198081.2090901@lwfinger.net>
	 <1260007083.31590.935.camel@peura.elisa-laajakaista.fi>
	 <3ace41890912050404h1385a962w42d708af33d5958b@mail.gmail.com>
	 <1260017628.31590.964.camel@peura.elisa-laajakaista.fi>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-x6dbXXCLoT87PKoYOSO0"
Date: Sat, 05 Dec 2009 17:32:46 +0200
Message-ID: <1260027166.31590.968.camel@peura.elisa-laajakaista.fi>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-x6dbXXCLoT87PKoYOSO0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

la, 2009-12-05 kello 14:53 +0200, Antti Kaijanm=C3=A4ki kirjoitti:
> The reference driver does not use product id alone. See below, it also
> tests EPROM_SELECT_GPIO. I don't know if this is sufficient, but as the
> driver comes from Realtek I would presume that the detection is correct.
> At least they have the documentation for full EEPROM register map and
> such. I haven't got the time to test the reference driver yet, but
> EPROM_SELECT_GPIO could just be the difference between our chipsets.
>=20
>=20
> > > r8187_core.c:L4359
> > >
> > >        if((idProduct =3D=3D 0x8197) || (idProduct =3D=3D 0x8198))    =
  {
> > >                priv->EEPROMSelectNewGPIO =3D((u8)((eprom_read(dev,EPR=
OM_SELECT_GPIO) & 0xff00) >> 8)) ? true : false;
> > >                DMESG("EPROM_SELECT_GPIO:%d", priv->EEPROMSelectNewGPI=
O);
> > >        } else {
> > >                priv->EEPROMSelectNewGPIO =3D false;
> > >        }

I just tested the reference driver and for me it says:

   rtl8187B: EPROM_SELECT_GPIO:1

And the kill switch works as it should.

Hin-Tak, when you have time could you test the reference driver, too.


 -- Antti


--=-x6dbXXCLoT87PKoYOSO0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digitaalisesti allekirjoitettu viestin osa

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAksafRoACgkQFYSsxt2pELHwNgCgqN/9hBNL+6yeNar28WBgVPIH
YU4AoIAFPmih8GQw+w1aX8PCOpa2ol9e
=Y5rm
-----END PGP SIGNATURE-----

--=-x6dbXXCLoT87PKoYOSO0--

