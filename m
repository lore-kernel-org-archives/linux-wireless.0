Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:33396 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755562Ab2INQeO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2012 12:34:14 -0400
Message-ID: <1347640763.5263.24.camel@sauron.fi.intel.com> (sfid-20120914_183425_249926_FF3C636F)
Subject: Re: regression: tethering fails in 3.5 with iwlwifi
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: "Berg, Johannes" <johannes.berg@intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 14 Sep 2012 19:39:23 +0300
In-Reply-To: <1347631355.5263.19.camel@sauron.fi.intel.com>
References: <1347361823.26457.3.camel@sauron.fi.intel.com>
	 <1DC40B07CD6EC041A66726C271A73AE6195AE9C8@IRSMSX102.ger.corp.intel.com>
	 <1347631355.5263.19.camel@sauron.fi.intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-aLK83FvLO0Hx8BruFE+W"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-aLK83FvLO0Hx8BruFE+W
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-09-14 at 17:02 +0300, Artem Bityutskiy wrote:
> Hi Johannes,
>=20
> We are using iwlwifi driver in Tizen IVI. We were using kernel v3.4 and
> wifi tethering worked fine. But after upgrading to v3.5 it stopped
> working.
>=20
> I am trying to bisect this already many hours - very difficult, because
> tethering did not work in kernels around v3.4-rcX for some different
> reasons, so just 'git bisect' does not work.

OK, my latest finding is:
       =20
        bad:               3edaf3e Johannes Berg  mac80211: manage AP netde=
v carrier state
        good:              fe40cb6 Ashok Nagarajan  mac80211: Check basic r=
ates when peering
       =20
However, just reverting in 3.5 does not solve the issue. I am out of
ideas how to proceed.

--=20
Best Regards,
Artem Bityutskiy

--=-aLK83FvLO0Hx8BruFE+W
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQU127AAoJECmIfjd9wqK0NokP/RU0ZBjXt9WoOIN5biPAFkUH
BJefUWsyrvJ5nXyR4Z18NmgfZgzjsdr8Qbd/OvqmIORz0KyzrJbZ0GO71C0g1trT
Epv3Gfdzpr0loF8qviFf+CcTGsFVj9/6LSDqiYQdi1JLXwOvitQwuJM4cC3oL3lI
J/LVT9HSgAN1OzqhX3W/x+Y0viTVWgSwkRWD21y28wapwbFywiqd3BC24zh6pTx6
hj4BtFEFrBdgpULzwRxmsgNXEK/EXy3dqmewyd9BFqcD9uVfkFpMohGQ8PJSazEV
I/5IPeEXR0y5Ipzgx/y3Px7orSM9C5pKUBrQsW7oESM6wotvJEWit0m84d5aWJkL
mYcPuCFx4eaHCkl3G0gfgIMqe1wbGGdTIkAbf+YvBkipfj1qqNwH7f7IIEaxZXud
HDF3Eg6yWir/itMKgqsrCHNDS358mbb3YpkjzSPAzShZCpmkVbqHW7cvuGjlNX0+
/4VpiUThilGFzlGsvnmJkT/f4O0qoJPIcx/myMVgWaBaTjGkZNGsV7YijOydAXlS
1Ant2ivNWd0j3aYlB8SmXUUr6p8w3Ul66Kt7KKs/g6mrluReq2iPAfKZzPoyUXGr
t2TKeog9uaEk1MlsbZV5uDYyT9v6WKPT42EacO1l9utUx1nyFvSi0zjJkIX2HjOn
8pJt6iSkP2euvxcgMVb8
=4lFM
-----END PGP SIGNATURE-----

--=-aLK83FvLO0Hx8BruFE+W--

