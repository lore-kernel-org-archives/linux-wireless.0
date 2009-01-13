Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39630 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbZAMXAu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 18:00:50 -0500
Subject: Re: [PATCH 00/12] cfg80211/mac80211: fixes/enhancements for
	reg_notifier()
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1231876675-20518-1-git-send-email-lrodriguez@atheros.com>
References: <1231876675-20518-1-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-xlPkGNZEPDJB2+/LOMP0"
Date: Wed, 14 Jan 2009 00:00:21 +0100
Message-Id: <1231887621.3728.12.camel@johannes> (sfid-20090114_000053_438205_8A6F32F0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xlPkGNZEPDJB2+/LOMP0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-01-13 at 11:57 -0800, Luis R. Rodriguez wrote:
> This series contains a few fixes for cfg80211 such as another
> fix for parsing country IEs, but mostly contains work to help
> drivers build a more useful reg_notifier(). While at it we remove
> the CONFIG_WIRELESS_OLD_REGULATORY as we are now on road to 2.6.30.
>=20
> Luis R. Rodriguez (12):
>   cfg80211: print correct intersected regulatory domain
>   cfg80211: add helper to indicate when to follow the driver regd
>   cfg80211: add option for wiphys to disregard country IEs
>   cfg80211: split wiphy_update_regulatory() in two
>   cfg80211: add regulatory_set_custom_rd()
>   cfg80211: add regdom_intersect_wiphy_regd()
>   cfg80211: allow driver read access to cfg80211_regdomain
>   cfg80211: export freq_reg_info()
>   cfg80211: Fix sanity check on 5 GHz when processing country IE
>   cfg80211: process user requests only after previous user/driver/core
>     requests
>   mac80211: allow mac80211 drivers to get to driver priv from wiphy
>   cfg80211: Remove CONFIG_WIRELESS_OLD_REGULATORY

I think this series is pretty much overkill. While I'd like you to
finish work on this (you know why), I think you should go back and
describe what you're trying to achieve.

It seems to me that you're trying to achieve two things:
 1) have ath9k have its own world regdomain
 2) restrict ath9k to the channels it has calibration data for

Am I totally off base?

For point (1), I'm not sure how you're doing that right now, but (2) you
should not do via the regulatory code and the notifier but rather by not
registering those channels to start with, or setting the disabled flag
before registration if that's easier.

johannes

--=-xlPkGNZEPDJB2+/LOMP0
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJbR0CAAoJEKVg1VMiehFYkJsQAJTMKitu0S4d0av1MB6vpldx
MWxn1XlJbB/UR4EN4PH6uIZUrVh0UR9CazrLgCqOqV8bDVczoViihmCnI7trqMXC
tljS3i7AhqfkWA159pFtxJID4u4FTiNYxb1NkE4Di+gpgNNQkpzhDOjaN2TGg4KM
UDAX7vYJl+QwheFMhUaVIxBjrQEFu/TDmZSkxZLRYTx3Hd/GX692zzvIcJ1MopFZ
dY/pTAlY2aY/aXgyOT7fcXrMe198p9EFtAix2LmweC8I2HsZrnadp+h4IbxKI/fJ
CcylHXhjbNIcal08pVdKZUYuNSndR7LCTsyX9wM89LoOUhZHGLR0J24d57Dbzzej
ADasrVl34Jpn8RzsspyVE9pVzrBTZKztSOhtSXc48PJMbi47TwwIGXV5siMXlU3w
m9dnZGlGvnznAS7lmP/+r/auT5i0VLu/gpoSaW+YLZjMQl/HHbC4jv8CPqRPaq3t
K4VkaJQtMMsZ5XYsjaUW3t3s+40CkJAZXvzH5n+wNeZd40jlvzSsLAqqpjjXNgNJ
YsDuskdOF+Ro8dsc6rYDeTHzO/kyopOCQibsrA2bUZN6wYm5YmGYuOsdsslFWBtm
JecsTmIgtipBrwJjsYgIDQ4i5umau17sle/lNKjQ4LxHINMObpT4Ag4mk5nhfo4E
6xKf/4iW5x14+uPwbn7N
=qyPp
-----END PGP SIGNATURE-----

--=-xlPkGNZEPDJB2+/LOMP0--

