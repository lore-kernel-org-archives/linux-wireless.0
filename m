Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:55869 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258AbYLFLNA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Dec 2008 06:13:00 -0500
Received: by ey-out-2122.google.com with SMTP id 6so160090eyi.37
        for <linux-wireless@vger.kernel.org>; Sat, 06 Dec 2008 03:12:58 -0800 (PST)
From: Henning Rogge <hrogge@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: RFC Patch v2: Add signal strength to nl80211station info
Date: Sat, 6 Dec 2008 12:12:50 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>
References: <200811252131.30161.hrogge@googlemail.com> <200812060026.50636.hrogge@googlemail.com> <1228554920.15939.2.camel@johannes.berg>
In-Reply-To: <1228554920.15939.2.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart122860125.EtH9Ki5sAP";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200812061212.55491.hrogge@googlemail.com> (sfid-20081206_121313_522809_2C5882DF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart122860125.EtH9Ki5sAP
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 06 December 2008 10:15:20 Johannes Berg wrote:
> Yes, well, depending on which values you used you might have run into
> the fact that the values from the tables were already rounded.
Both  errors happen for 20 Mhz channels... one of them is definitely a typo=
 in=20
the wiki.

I get 144.4 MBit/s (wiki says 144.0) for MCS 15 (long GI)
and 115.6 MBit/s (wiki says 173.3, which is a typo !) for MCS 27(short GI).

in pseudocode:
=2D----------------

int modulation =3D mcs & 7;
int streams =3D mcs / 8;

int bitrate =3D (flags & 40MHZ) ? 13500000 : 6500000;

if (modulation < 4)
    bitrate *=3D (modulation + 1);
else if (modulation =3D=3D 4)
    bitrate *=3D (modulation + 2);
else
    bitrate *=3D (modulation + 3);

bitrate *=3D streams;

if (flags & SHORT_GI)
    bitrate =3D (bitrate * 10) / 9;

return (bitrate + 50000) / 100000; // do NOT just round down

Henning


--nextPart122860125.EtH9Ki5sAP
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkk6XjcACgkQcenvcwAcHWczQwCgiwMouQqpfni5bbTxcN49G3SI
HsgAn0VOiLObtbqtdW4LNl9EcCfzEHlT
=Baak
-----END PGP SIGNATURE-----

--nextPart122860125.EtH9Ki5sAP--
