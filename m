Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52313 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751604AbcDTPsF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Apr 2016 11:48:05 -0400
Message-ID: <1461167278.28559.63.camel@decadent.org.uk> (sfid-20160420_174810_147759_B3F41988)
Subject: Re: RSS configuration in iwlwifi
From: Ben Hutchings <ben@decadent.org.uk>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	"Sharon, Sara" <sara.sharon@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 20 Apr 2016 16:47:58 +0100
In-Reply-To: <1461166207.19157.1.camel@intel.com>
References: <1461164882.28559.61.camel@decadent.org.uk>
	 <1461166207.19157.1.camel@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-xEGYGT8zz07TiD6DId0+"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xEGYGT8zz07TiD6DId0+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2016-04-20 at 15:30 +0000, Grumbach, Emmanuel wrote:
> Hi Ben,
>=20
>=20
> Thanks for looking at our code.
>=20
>=20
> On Wed, 2016-04-20 at 16:08 +0100, Ben Hutchings wrote:
> >=20
> > I'm not sure if you were aware, but there is a standard API for
> > configuring RSS in network drivers, part of ethtool_ops.=C2=A0=C2=A0I t=
hink
> > iwlwifi should implement that rather than a driver-specific debugfs
> > interface.
> >=20
> You are right, this is why Sara made this commit:
>=20
> commit 854d773e4ab5869200004af4ca5d851730849903
> Author: Sara Sharon <sara.sharon@intel.com>
> Date:=C2=A0=C2=A0=C2=A0Tue Mar 22 15:55:58 2016 +0200
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: mvm: improve RSS configuration
> =C2=A0=C2=A0=C2=A0=C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0Improve current RSS configuration:
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0* Use netdev_rss_key instead of keeping a l=
ocal copy.
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0* Configure also UDP hashing to have UDP tr=
affic spread across queues.
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0* Do not direct RSS traffic to our fallback=
 queue.
> =C2=A0=C2=A0=C2=A0=C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0Signed-off-by: Sara Sharon <sara.sharon@intel.com=
>
> =C2=A0=C2=A0=C2=A0=C2=A0Signed-off-by: Emmanuel Grumbach <emmanuel.grumba=
ch@intel.com>

That doesn't really address what I said. =C2=A0Yes, it's using the common
RSS key, but it's not implementing the ethtool operations to get and
set the indirection table and the types of flow hashing that are
enabled.

Ben.

--=20
Ben Hutchings
Never attribute to conspiracy what can adequately be explained by stupidity=
.
--=-xEGYGT8zz07TiD6DId0+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJXF6SuAAoJEOe/yOyVhhEJ3+IP/06f72tBlbbx84DGwrmsrlqc
63KZ12sEpcmN0HHZ3sDW7gpzCBsvq9nIR/etktMx76sJZv/xCYq7lLvHMKZyCGIM
oTP8eepCuJxcPHxneEPfQRjLnEQPx4AGg0s3rcJhU4JYFGuA/YrHyuIABHrav/z4
l1f+79W4ezhky3y0fWwxej4O4Dof50RCDEdCKWhi8m6kaMfAVkY0sz8+ndvA2pAA
9XG0WSaca7UbCBw4HHUg434Fo2Wi/Iq6fh9F9zSOMjbDfdh9pegqsxFxG4EvPdeU
kPPBo5RuAr6lthWVU5wfk6vzj1Ij728X9NbDGG7TZTXPaVfHaPf4qInkMTgeZoWB
UDvQQaTLodOaG4dSahW2q1L83wF+kwH6AC+PK9T20WczgsB1Y9pCeD0MU0WuOSoQ
3ae8pWzpAmR/3+Udfzdw5QibrM1OiWAT3tI/N72vSE44KFEvSbEnTLJlqXTVSpVz
fQZMlkNMVXH+vcZQvnHFIuiG/eEsWtorQmGO5ZxTnNF+QbkGe27d/XdP6UEESuW8
V9HB23/RDHBZC7B3qnNMSTUNUIPuuf3MTHM4VM+bNaQGlXjBPFZi830ln6mR5nZU
40ArVGHhJ/VPuc0lNZ5al8z6P3a1fzcFDOs+eejnGNslhD+YW9exJy1cUAQon4aa
c0OdtmHevXbKK1runa7f
=fz5m
-----END PGP SIGNATURE-----

--=-xEGYGT8zz07TiD6DId0+--
