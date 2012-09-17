Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:24963 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756257Ab2IQOgO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Sep 2012 10:36:14 -0400
Message-ID: <1347892887.7112.9.camel@sauron.fi.intel.com> (sfid-20120917_163617_677167_0B529F43)
Subject: Re: regression: tethering fails in 3.5 with iwlwifi
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: "Berg, Johannes" <johannes.berg@intel.com>,
	Eric Dumazet <edumazet@google.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 17 Sep 2012 17:41:27 +0300
In-Reply-To: <1347640763.5263.24.camel@sauron.fi.intel.com>
References: <1347361823.26457.3.camel@sauron.fi.intel.com>
	 <1DC40B07CD6EC041A66726C271A73AE6195AE9C8@IRSMSX102.ger.corp.intel.com>
	 <1347631355.5263.19.camel@sauron.fi.intel.com>
	 <1347640763.5263.24.camel@sauron.fi.intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-Umswc144aMln99m44br1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Umswc144aMln99m44br1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-09-14 at 19:39 +0300, Artem Bityutskiy wrote:
> On Fri, 2012-09-14 at 17:02 +0300, Artem Bityutskiy wrote:
> > Hi Johannes,
> >=20
> > We are using iwlwifi driver in Tizen IVI. We were using kernel v3.4 and
> > wifi tethering worked fine. But after upgrading to v3.5 it stopped
> > working.
> >=20
> > I am trying to bisect this already many hours - very difficult, because
> > tethering did not work in kernels around v3.4-rcX for some different
> > reasons, so just 'git bisect' does not work.
>=20
> OK, my latest finding is:
>        =20
>         bad:               3edaf3e Johannes Berg  mac80211: manage AP net=
dev carrier state
>         good:              fe40cb6 Ashok Nagarajan  mac80211: Check basic=
 rates when peering
>        =20
> However, just reverting in 3.5 does not solve the issue. I am out of
> ideas how to proceed.

OK, finally I got it. After 3 days of hardcore intelligent bisecting
        I've found out that tethering in 3.5 works for me if I revert
these 2
        patches:
       =20
            56138f5 iwlwifi: dont pull too much payload in skb head
            3edaf3e mac80211: manage AP netdev carrier state
       =20
        Johannes, Eric?

--=20
Best Regards,
Artem Bityutskiy

--=-Umswc144aMln99m44br1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQVzaXAAoJECmIfjd9wqK0s5wQAIU89tsWzzhoHiUjXzjtleTO
0WeMeJjJFL1OaTvzRo2sVrq5PsJ/59jGSGYzuxLmqC9LPvfTQG6kad9KVtspLNGf
5rrZip7C4fH+QBtQf0uKNoXLRmT2NnhNIRmVdmcqeZ0BW55Mo+E2jRmFMRh50Otf
0qGiCQ8yaaUMT8FjMGzxEqraD4n7Y50x1xPKWKew/pj5ajJ6AoeIxS2M7ermhhHh
lTH15Dja4x9vEvJZgK2Jc7bgtvSfEqYhC7m1AapmeqChuIvKyYHQq9CB0M2UAX8g
hZaT3mUK7rcxv+UEWTAvT9iBU6Ot0hoAm3n5sUwtyHEzRaavNRKcOW8Pr8ggGfwb
FUby7d188VYWdxF3KaGT9LhXzGp5mp5s7SmbCO4IHLxicGbJIKe7NheRplEgYUNx
ya1HrPwrHWz7OOAR+InZ10+rjwTPRCcTQZ8BoefsRU6iI6WDWscKn4jdG/PhGPHW
f8OEdvezy88SmCm1z66b8dQ1pFB6s0kkuPSsIs8qynEoXfOyXv4wLt6X9as9jwYH
xr0rRVwcCRK91pzf4/qo5i2aRo+ys655L0VQ9PU++iG856aPbYEyTvr0mb7awAgV
p5NVyoFbEn27TErri7uV01PRyn4UWoo+Gtcaq2C2Uv0rOXP2wXatJNwjJdxIOhdI
VWx3wuxGOy4gAc1VGQdZ
=DxKt
-----END PGP SIGNATURE-----

--=-Umswc144aMln99m44br1--

