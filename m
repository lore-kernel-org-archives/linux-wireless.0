Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55780 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbZBMLEU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 06:04:20 -0500
Subject: Re: [PATCH 5/6] cfg80211: make regulatory_request use wiphy_idx
	instead of wiphy
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1234503363-11014-6-git-send-email-lrodriguez@atheros.com>
References: <1234503363-11014-1-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-2-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-3-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-4-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-5-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-6-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-S0/MkLWvEwTG1qmuSYGs"
Date: Fri, 13 Feb 2009 12:04:15 +0100
Message-Id: <1234523055.4219.15.camel@johannes.local> (sfid-20090213_120424_512080_7D02885D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-S0/MkLWvEwTG1qmuSYGs
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-02-12 at 21:36 -0800, Luis R. Rodriguez wrote:
>=20
> +       if (wiphy_idx_valid(last_request->wiphy_idx))
> +               request_wiphy =3D wiphy_idx_to_wiphy(last_request->wiphy_=
idx);

All this seems pointless, wiphy_idx_to_wiphy will just return NULL if
the index isn't valid. This is in a number of places, and it's not like
it being invalid will be happening often so we'd have to optimise for
it.

johannes

--=-S0/MkLWvEwTG1qmuSYGs
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJlVOtAAoJEKVg1VMiehFYqboP/3F79/ZfJbF3LiE+V6J7fOKY
boaXcVcZNNzX30z9S/NyhIZ5a99jLREe0uuDFe8+wlvUn0ZUlQUMHb1VGshkpbBS
iGb+SLvUEv2vSKUEFrbHdj6b0UCS4HWeB7evWPLsq1U7xRqmpF9Rl7A9zL4V8GfM
nbHTPgB/glNIO4zWFlaURX0cO/ll3mtyLfehJfhH2iRwMjEERTQ7U9EkNhhoECV3
rNXBNtphuTiz7JlDpwix0q79uveb41UeGAgm+Fp+TehaW3J3YdOFJBFIbuuDNGLC
X2mb9q2t78x7cmu11LFBHotnE1cinkOBe7clAPkQgFilZ//TmwLEVOc3z7BLIwkA
cbYHMAf2aUU/O79nDFkR+ohxemRvgGhjYG7V7/bh1qbkNjMdbw1hMG9yLUBgG8/0
MlMZ5hePTWiNRYezyUAhyfNO34Nf9d/EbY08t3JJE84D5NfHfAPezYJh6Akfjckw
AdgzCxAQiY0Dr7BBi1oO/FvFMfWIL/udR77eCSUmbvgzvBuOraIHm2bOA6SUlngE
NGIaY51HheIT94vEG/h0ClGzBoCLAoRghJp0xi3zkNB/bPTnPb5Z3pHabbStdXhc
VRvNh2F+IOlu+g86ZbqvdEF3ilY66r2WtwHFLXM7acCDN6TnHkBQvr6j0vzkATO6
3ggEmf6LVIV8eIU8rkD4
=NDsH
-----END PGP SIGNATURE-----

--=-S0/MkLWvEwTG1qmuSYGs--

