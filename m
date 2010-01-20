Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49068 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab0ATKSx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2010 05:18:53 -0500
Subject: Re: [RFC] How to store HT (40MHz) support
From: Johannes Berg <johannes@sipsolutions.net>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.de>,
	"bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
In-Reply-To: <op.u6s09akf9lhzdc@linux-g0th.site>
References: <op.u6s09akf9lhzdc@linux-g0th.site>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-m4hl3Fdy5t5vjRfCYSzo"
Date: Wed, 20 Jan 2010 11:18:49 +0100
Message-ID: <1263982729.14538.5.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-m4hl3Fdy5t5vjRfCYSzo
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2010-01-20 at 01:06 +0100, Rafa=C5=82 Mi=C5=82ecki wrote:

> +	if (phy->supports_40mhz)

That is useless, if it doesn't support it then you should not advertise
it and mac80211 will not use it.

> +		phy->use_40mhz =3D conf_is_ht(conf);

This is wrong, conf_is_ht might also be 20mhz, look at the other
helpers.

johannes

--=-m4hl3Fdy5t5vjRfCYSzo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLVtiFAAoJEODzc/N7+QmaomAQAJ+e9b0zGOrNzcDxfBny2r7T
bwVBroRuo9RsFy5yIgtciPj9C7DkwOoviYPPk5t6v5paaS7WCpP4PFH2z7LtWJ3L
lgmy8OtugFbICpuUdlyQxSAxeqhkng3F6DUD88swp7bJ+XpwTeLrGkHrcmU8q1Ca
cDfw+uKlvGtM8L3ysnKCB1EjZGdIFOavnf7OHbXuk3ti2FlUT217XOQePKpCBVey
TYnraytFko3IYnMO2C4QT7czH8RoTXkFBdgKeO6fV0A1N2dvIeqx3fEIdRH0KDSj
cIQg4k4xKvRYGEB6b5Up8bOOGAlwCaXO9/3NsCihybQ0/v3Z0GK51EGWeepCFlHA
2CcxuCSQyM2CSkfxJpoGk0HiPB79JWqqtfQ08kNC1lFsh79R8SJhGpmcvxC7z09x
BWWd88rU/5NE0jR0m2QME4c7edmBY2nrQANatHUCFmpRIOsp3SZ+/uuDHaqcjkYT
MM5XH1YJg14bOYXVxkW0wX/wE4ZHSs11sBGRMjKdUIo4wkSwk0iXrMTMk7Z/X7Zi
BHjOwUCm+wUlE3psptRwAkKak2iVLv6Q2XcdFxbeafi0DM3Lxm0bhbqPwOMm8ORN
jcw9CSZZUpMqJ8LOh/wmolv6x0sCTKCtSobbyeA9PNqLqNt4L7Ze6mn9smvmkcDG
Zg9+TbHvXkf7YV0HuRoA
=48vU
-----END PGP SIGNATURE-----

--=-m4hl3Fdy5t5vjRfCYSzo--

