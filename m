Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:58041 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758337Ab2IMQvP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Sep 2012 12:51:15 -0400
Date: Thu, 13 Sep 2012 18:51:24 +0200
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Sven Eckelmann <sven@narfation.org>
Cc: Adrian Chadd <adrian.chadd@gmail.com>,
	Mohammed Shafi <shafi.wireless@gmail.com>,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	openwrt-devel@lists.openwrt.org,
	Marek Lindner <lindner_marek@yahoo.de>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: Re: AR9330 hornet board stops beaconing after a few days
 (0xdeadbeef)
Message-ID: <20120913165124.GA13877@pandem0nium> (sfid-20120913_185119_861644_1A3D8E8C)
References: <20120813165340.GA10044@pandem0nium>
 <CAD2nsn1=q_YCXjQOLyc+KeG6Bji=7b_VHN4PDA7poXk5Kkdi6Q@mail.gmail.com>
 <CAJ-VmonwheNtv8xfEJnWpD-XOmSEebMFJAmQmWUfe2Pd3tMnqA@mail.gmail.com>
 <168362233.PzT7LJrFi2@bentobox>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="r5Pyd7+fXNt84Ff3"
In-Reply-To: <168362233.PzT7LJrFi2@bentobox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

ath9k fellows,

as it seems no one could find the cause for this problem so far. I'd theref=
ore
like to create a workaround by checking one/some registers for 0xdeadbeef a=
nd
reset the chip if this is found.

Can anyone recommend a register which should never go 0xdeadbeef in a norma=
l case?

=46rom what i've seen, AR_CFG (0x0014) might be a good choice. My regdumps =
say:

bad regdump:  0x000014 0xdeadbeef   =20
good regdump: 0x000014 0x0008010a

Unfortunately I don't have documentation to find out if this register can e=
ver
go deadbeef in a normal case. :)

What do you think? (of course, a proper solution is still appreciated ...)

Cheers,
	Simon


On Wed, Sep 05, 2012 at 04:20:52PM +0200, Sven Eckelmann wrote:
> On Wednesday 05 September 2012 07:08:47 Adrian Chadd wrote:
> > I don't think it's a stuck beacon WAR issue here; 0xdeadbeef really
> > does read like the MAC has gone to sleep.
> >=20
> > Where's the complete register dump hiding?
>=20
> It was not sent to the public mailing lists due to the size. You will rec=
eive=20
> the dump mentioned in the first mail in some minutes.
>=20
> Kind regards,
> 	Sven



--r5Pyd7+fXNt84Ff3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlBSDwwACgkQrzg/fFk7axaCLQCg27g4pk6seTqcix0RFoeoglZm
+fkAoJnqhGv77388XjzRPdhSM/V3yNYl
=BYI7
-----END PGP SIGNATURE-----

--r5Pyd7+fXNt84Ff3--
