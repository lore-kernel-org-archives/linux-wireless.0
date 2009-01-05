Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54607 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747AbZAEWH3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 17:07:29 -0500
Subject: drivers returning wrong results from their _tx op
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Bob Copeland <me@bobcopeland.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Daniel Drake <dsd@gentoo.org>,
	Tomas Winkler <tomasw@gmail.com>,
	Javier Cardona <javier@cozybit.com>, Chr <chunkeey@web.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-8kC//sI4wu6XBbip4Ajt"
Date: Mon, 05 Jan 2009 23:07:44 +0100
Message-Id: <1231193264.3697.41.camel@johannes> (sfid-20090105_230733_765440_60D50AC3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-8kC//sI4wu6XBbip4Ajt
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

spatch:

@ r1 @
identifier _tx, _ops;
@@
 struct ieee80211_ops _ops =3D {
...
 .tx =3D _tx,
...
 };

@ r2 depends on r1 @
identifier r1._tx;
@@
static int _tx(...)
{
...
-return ...;
}


shows a lot...

First off: all those should return NETDEV_TX_OK/BUSY.

ath5k: returns 0/-1
ath9k: returns 0/-1
iwl-agn: returns 0 (=3D=3D NETDEV_TX_OK, but still should be changed)
iwl3945: same
libertas_tf: same
rtl8180: same
p54: same (some paths)
rtl8187: that's why I started looking
zd1211: returns -E* codes


These need to be fixed, the bad ones are zd1211 and rtl8187, the -1 from
ath5k/9k is not much of a worry but should be fixed anyway.

Preferably, drivers should just drop frames when they can't handle them,
but keep in mind fragmentation and keep enough space for up to 9 or 10
(I think) fragments.

johannes

--=-8kC//sI4wu6XBbip4Ajt
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJYoSuAAoJEKVg1VMiehFYi04P/jJ82xbju/DrGBIM1QaAyk/d
abqrlmjmE2+jEl2o2Ty9CsvsJMJAk/VVvtMwa2ihGzd6ewnHRLSo0IPICq2l2SQ3
Yk0y9SiBDqmvR3ilctDO5dU/nwFaYZdCGuJJLiZXIq2gTEWbxAojsfI9GqMHhWlT
5nRBI98dGPtu74hA8RysfHty1jLpmTpYcKPBMmKg2Mmr4RqfgbW8qunyBcw6zjon
Ihbr5NS+PPSlNcGuMuLx5QeepsBrBB3ZvLXAoJCRqBsy4YMtZm+kf9K0KesM7QlO
kgZeroc3xBkCAaTHQNNJWinokEKF+7me482Za/agr24IjpV0MLutejkWGXGAk9UE
weSoNirlVXPVznOO5FFb7AlvLmWoKWvMEHpl3Z1dokCIif+Z8d/6IQ70sZIVIFuw
PVAB3NdiasjFEICOr3XeDjRFsMCYLN5BUecfI2NN/ReuTcYJIfNjTEnP3SrWDJuf
3pWdA//qAokjIn04OxMubodbbqOSiBPKF/0c89uKQHj/tmHiMOGFmW4zWR6goZEX
FTEYBTzYlwb1sNZExTJ4LyM5mGN59VccjetKPIq6HRmgRzcShESWXmFgT1wsSEF6
PtpV0vvtn+GeTR09fbVDz7mlyyfEfJN71wHSlN2CfIuiSdkKHhv9xtJq5nPuOcKf
b4NbOgjnkhpwHrwqjOGu
=TFdD
-----END PGP SIGNATURE-----

--=-8kC//sI4wu6XBbip4Ajt--

