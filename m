Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51940 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760549AbZFSMAy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Jun 2009 08:00:54 -0400
Subject: Re: lockdep spew
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
In-Reply-To: <20090619113049.GB18956@hash.localnet>
References: <20090619113049.GB18956@hash.localnet>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-gm1VRu5dV7FOHSdm/pgD"
Date: Fri, 19 Jun 2009 14:00:23 +0200
Message-Id: <1245412823.16399.18.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gm1VRu5dV7FOHSdm/pgD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-06-19 at 07:30 -0400, Bob Copeland wrote:
> I get the following in latest wireless-testing, by starting hostapd, then
> turning on network manager which then tries to act like a station.  Quite
> possibly a driver bug but I haven't had a chance to look at it in depth
> yet.
>=20
> [  959.515213] phy0: device now idle
> [  960.122130] phy0: device no longer idle - in use
> [  960.161448] phy0: device now idle
> [  960.163728] PM: Adding info for No Bus:mon.wlan0
> [  960.199042] phy0: device no longer idle - in use
> [  960.551906] phy0: Allocated STA 00:18:41:c8:58:43
> [  960.552865] phy0: Inserted STA 00:18:41:c8:58:43
> [  966.937833]=20
> [  966.937836] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [  966.937855] [ INFO: SOFTIRQ-safe -> SOFTIRQ-unsafe lock order detected=
 ]
> [  966.937863] 2.6.30-wl #136
> [  966.937869] ------------------------------------------------------

I think this will be fixed by the local_bh_disable patch I posted
recently.

johannes

--=-gm1VRu5dV7FOHSdm/pgD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKO33UAAoJEODzc/N7+QmaE94QAKGZ8meOLqeV06vyMpDihDPf
gfcF7ykb4nXzCJffVAbcbfihaGuR88COGS5H+v9K5pz2R2gxlyAnfiR85rPAnLsT
V7YDOn0d07d8cMCkRdAey3a0vufp+1mGyw/H8SxjYVyDvnszf4qJMSYnOLzaIU3F
09EMK+bYouMUZ40Ps191RdK4BysFRXRKt0ZBlupvSjIPWgQ9c+yj57lyyfte1TPa
j2Dr3zKjoQo9q0pj7HDdmVgWQ6Qf1LZNXzFwD3/LUssXeVrf6gHQlfh+Lw2cWxeZ
vrsw4ppRH+X8kzc/cJf+05VowpYhApnGYOAsbBe3nk+64r/r6F5dML22KbrTuwiV
BMJCIotEoHyq20DspitYpL1jzbyHhqidGHMbTQlpwGF2KWRIjKahh49++8DQ2oTl
8bNihSDbwqpHPAvKQqcqbjzEZlJ0pZZIfILtlijDs0O5fszGgwKmEm36jgqRQefh
L8JgisBLzV+GZj6QgSdYdgqprANpBvCFu5knhOS3ZBJMkqqr5x3FOlDH/nCy5Fbd
jkPb5PpYJBQRv2OarBnUDkItO+fSg0D6Asxf5kcLjKLnsJ1XtygWfvMcGZ9GWym5
81Kai6i84ehO2vY3lfIgFG7AFyuNk+DWWeYJN31lRNaf3SMP7uB/LnAva8Uq9xb7
CEgwVnaEtQHwOg0q0HBi
=CJGR
-----END PGP SIGNATURE-----

--=-gm1VRu5dV7FOHSdm/pgD--

