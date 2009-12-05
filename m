Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web4.futuron.fi ([217.149.52.4]:38099 "EHLO web4.futuron.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754576AbZLEMx5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Dec 2009 07:53:57 -0500
Subject: Re: New rtl8187 rfkill support blocks my wlan for good.
From: Antti =?ISO-8859-1?Q?Kaijanm=E4ki?= <antti@kaijanmaki.net>
To: Hin-Tak Leung <hintak.leung@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <3ace41890912050404h1385a962w42d708af33d5958b@mail.gmail.com>
References: <1259756709.31590.62.camel@peura.elisa-laajakaista.fi>
	 <4B169608.3010902@lwfinger.net>
	 <1259822699.31590.914.camel@peura.elisa-laajakaista.fi>
	 <4B198081.2090901@lwfinger.net>
	 <1260007083.31590.935.camel@peura.elisa-laajakaista.fi>
	 <3ace41890912050404h1385a962w42d708af33d5958b@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-mQ/OzXGI2On2Rmfp+j46"
Date: Sat, 05 Dec 2009 14:53:48 +0200
Message-ID: <1260017628.31590.964.camel@peura.elisa-laajakaista.fi>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mQ/OzXGI2On2Rmfp+j46
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

la, 2009-12-05 kello 12:04 +0000, Hin-Tak Leung kirjoitti:
> 2009/12/5 Antti Kaijanm=C3=A4ki <antti@kaijanmaki.net>:
> > pe, 2009-12-04 kello 15:34 -0600, Larry Finger kirjoitti:
> ..
> >> I will get the same info
> >> from Hin-Tak to see if we can differentiate your two devices.
> >
> > See the attached lsusb_v.txt
>=20
> The only difference between yours and mine is just the USB id (8197 vs
> 8198). There is no other difference. (But it is probably unsafe to
> base any change on product id alone - there are about 5-6 variants
> even among the 3 ids
> 8187/8189 and 8197).
>=20
> > I looked through the reference driver and found out that indeed the GPI=
O
> > pin is different for some devices, mine included (0x8198).
>=20
> There are differences between devices even with the same id - has
> always been the case - see comment above.

The reference driver does not use product id alone. See below, it also
tests EPROM_SELECT_GPIO. I don't know if this is sufficient, but as the
driver comes from Realtek I would presume that the detection is correct.
At least they have the documentation for full EEPROM register map and
such. I haven't got the time to test the reference driver yet, but
EPROM_SELECT_GPIO could just be the difference between our chipsets.


> > r8187_core.c:L4359
> >
> >        if((idProduct =3D=3D 0x8197) || (idProduct =3D=3D 0x8198))      =
{
> >                priv->EEPROMSelectNewGPIO =3D((u8)((eprom_read(dev,EPROM=
_SELECT_GPIO) & 0xff00) >> 8)) ? true : false;
> >                DMESG("EPROM_SELECT_GPIO:%d", priv->EEPROMSelectNewGPIO)=
;
> >        } else {
> >                priv->EEPROMSelectNewGPIO =3D false;
> >        }
> >
> >
> >
> > Here's the begining of the RFKILL code (see, 0x2 vs. 0x4!)
> >
> > r8187_core.c:L6258
> >
> >                        tmp1byte =3D read_nic_byte(dev,GPE);
> >                        if(priv->EEPROMSelectNewGPIO =3D=3D true)
> >                                tmp1byte &=3D ~BIT2;
> >                        else
> >                                tmp1byte &=3D ~BIT1;
> >
> >                        write_nic_byte(dev,GPE,tmp1byte);
>=20
> I'll have a look at what this does when I find the time. What version
> of the vendor driver have you got? The last one we have is
> 26.1036.0708.2008 (mostly you just look at the 1036 part which is the
> version, and 0708.2008 is the release date). If you have a more recent
> version, you should share it with me, Larry and Herton - our e-mails
> are in the MAINTAINERS file, but you already found me and Larry, just
> Herton hasn't comment yet(?). (as I wrote, for some reason Realtek
> doesn't put it up publicly for download but seems to be happy to
> e-mail to people when they ask, so I think it is appropriate to behave
> along similiar lines).

The driver is attached to my previous email to the list.
It should be newer than yours (1055):

    rtl8187B_linux_26[1][1].1055.1102.2009.release.tar.gz


  -- Antti



--=-mQ/OzXGI2On2Rmfp+j46
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digitaalisesti allekirjoitettu viestin osa

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEUEABECAAYFAksaV9cACgkQFYSsxt2pELE3DgCgr71Wr4nYrlmOZxZ/QfQI/YHC
ztgAlAw1M6ACETp44VKRQ9WaKM3gr8o=
=v0WX
-----END PGP SIGNATURE-----

--=-mQ/OzXGI2On2Rmfp+j46--

