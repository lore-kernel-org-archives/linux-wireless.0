Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37455 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbYBKMyS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2008 07:54:18 -0500
Subject: Re: [PATCH] zd1211rw: Fix beacon filter flags thinko
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>,
	Daniel Drake <dsd@gentoo.org>, linux-wireless@vger.kernel.org
In-Reply-To: <200802101603.56095.mb@bu3sch.de> (sfid-20080210_150436_186402_A253CCC1)
References: <200802101603.56095.mb@bu3sch.de>
	 (sfid-20080210_150436_186402_A253CCC1)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0RQAaZ77S9HMxsLZ3Lat"
Date: Mon, 11 Feb 2008 13:53:51 +0100
Message-Id: <1202734431.11481.80.camel@johannes.berg> (sfid-20080211_125422_887957_88048D2B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0RQAaZ77S9HMxsLZ3Lat
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Sun, 2008-02-10 at 16:03 +0100, Michael Buesch wrote:
> We must not clear the FIF_BCN_PRBRESP_PROMISC bit in the
> new_flags. The zd-driver does support sending beacons and
> probe responses to the host. What the flag does is say "Send me
> all beacons and probe responses". And we actually do that. We always
> do that, so we ignore the case when the bit is disabled. But that is
> fine. But we must not clear the flag, as that tells mac80211 that
> we do not support passing beacons and probe responses to the stack.
> And that's not true.

Good explanation. Maybe it's needed with the filter flags defines/the
config_filter callback description?

> Signed-off-by: Michael Buesch <mb@bu3sch.de>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>=20
> Should probably go -stable, too.

Unnecessary, I don't think we currently ever test the flag in mac80211.

johannes

--=-0RQAaZ77S9HMxsLZ3Lat
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR7BFXqVg1VMiehFYAQL6ig//fWll8L/nXvXjxDaT/qKOD4fksChpX5TO
gRnX4+SFLPcPeDS2uRrbL3UHOzYZtrsgNaqLdvtGilKh0LIQNosZsKe8UbXRbGtC
tQ5ipMRnE4BD1qK3lF4wpc8nH4ehSnUrNbVup2jOwx0z3NpuRL6zmL6U2ogVVRoX
keTKGOretbdcwA3NqbcqjL+on/8B4p/axHOvbOtAXicqxqhinYhxGPGdFpXnTDfX
RTrXLBUT+mCmaLxjSPqt4S+d5ykXQYE8q+HdqnI47OBizTGKKtgV7noJF+CGbnpZ
Qlywq+oWsQ9f4OYdGZrtw9EhlpIkoFlnvLtjzxOEq+7vHlxsfMlDi8kaHFdV1BMY
aqDhhoof3E83YONPm9Whz0AUhVqMdkvFxBjvxNFJu97d9X23MAVHPW6AhPIypvQk
oPxohTclyNz3W+9tBpKbni0QDbHzQ7wu3iTs1xm6zh9kjjk5JAuDq/wxuuw1zGkb
arkuU8CXyvPVFkXjvzU+7QUI9dUlAzRZuFcnrxSm/TNvIkpgRzlxOO7lLb3Sb85X
LKSOBcoJXybgkwbOrRF5tiCrJwvHGlmXbD7IBeAvMBVausw2dIeRXXtzp/z3lSLO
91LC9lICnNfw7L1OC9/epeICdZhmAulq4A7kcqLg7C/L14Lj/xXIT13y6yxMTq+4
YzQuuy04j9g=
=TcyX
-----END PGP SIGNATURE-----

--=-0RQAaZ77S9HMxsLZ3Lat--

