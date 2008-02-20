Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60442 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755598AbYBTScn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2008 13:32:43 -0500
Subject: when does ath5k filter frames?
From: Johannes Berg <johannes@sipsolutions.net>
To: bruno randolf <br1@einfach.org>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Michael Renzmann <mrenzmann@madwifi.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dAx8zs2y/eeUYbCpKB3z"
Date: Wed, 20 Feb 2008 14:28:28 +0100
Message-Id: <1203514108.17534.41.camel@johannes.berg> (sfid-20080220_183248_983448_FFFB6AC6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dAx8zs2y/eeUYbCpKB3z
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

In mac80211 we have a whole bunch of cryptic code to handle "filtered"
frames. The only driver that does that seems to be ath5k, and it doesn't
really seem to use this since it is intimately tied to
IEEE80211_TXCTL_CLEAR_DST_MASK which it doesn't check...

Any ideas? Should we kill all this code and not use whatever hardware
powersave helpers atheros hardware might have?

On the other hand, Broadcom also has powersave helpers in
hardware/firmware, maybe we should generalise to be able to use them as
well?

johannes

--=-dAx8zs2y/eeUYbCpKB3z
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR7wq+6Vg1VMiehFYAQILzA/+LVR9ftfvGhJ9jGlxNpzkixLGZ3LAXyVi
kf7olFlGShj6ZHh26ijD8LY2WeacIiwV16/0glwZLutVvau5yAEXvzd2mSHH5lmy
X5KbmeJL6HKkMUYMHatV0gdIrtLwAwacr6f0VTRK1oznQlr2YVqSwe/Bc9RCi4F6
OMcLEr8wOenvhkxCUt4ZIO+ozyn2RaSVJGx0WBbWU/LaQJzsxR9bE/H8fIzKn6Wh
u9U/peW7S7LuuilBhTmMoiGpJ48VN76khOarSlbgYELVGZyPsBelOI3SNyRGicr2
iI7wpbIHJhyE58sEVUy601S19bYTVF5ePBmgiXiqe59lExjLiyVAy9yHzUnTym7T
vrmoPOjI8EYSKsHyDDm6Of45J6f7nLA4naUWuNvQELWSXC693OaRWvF8SN7eSrfj
iuzSColy20MlsuynbRfGvarxFBjGsOv0KuDxq/GdbfTQFXuDbMShsMhMiV6mX+y7
M5Yq0QfUng9N45xQgxQHdzEhjf9Xu9TzzVLNz+A7CE+nWQsw3FtbE3kTQ9PUREdx
ExruqiOucIH4A8ZgTmSk2EfN9Hn/FYTJO0IPASRM9j7cZ0dLHm61//xCGredC8ul
exkCne4Opv3LTlq05X6PKvyNrUQoI5X7Yx0/kum4GQgDx7PadacRX+qCw7NvFQaT
n/3qRWiAAiQ=
=Trme
-----END PGP SIGNATURE-----

--=-dAx8zs2y/eeUYbCpKB3z--

