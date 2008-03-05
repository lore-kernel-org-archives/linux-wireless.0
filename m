Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40024 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758645AbYCEJyX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2008 04:54:23 -0500
Subject: Re: [PATCH] mac80211: fix races between siwessid and siwencode
From: Johannes Berg <johannes@sipsolutions.net>
To: Joonwoo Park <joonwpark81@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1204710009-10040-1-git-send-email-joonwpark81@gmail.com> (sfid-20080305_094021_590968_FB9842FB)
References: <1204710009-10040-1-git-send-email-joonwpark81@gmail.com>
	 (sfid-20080305_094021_590968_FB9842FB)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-kG53/l2qOUlWtt+Jbv7l"
Date: Wed, 05 Mar 2008 10:54:02 +0100
Message-Id: <1204710843.25502.50.camel@johannes.berg> (sfid-20080305_095430_480975_1830F0BA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kG53/l2qOUlWtt+Jbv7l
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Wed, 2008-03-05 at 18:40 +0900, Joonwoo Park wrote:
> resolve: http://bughost.org/bugzilla/show_bug.cgi?id=3D1522
>=20
> The function ieee80211_ioctl_siwencode shouldn't be called if
> authentication process is not completed.
> This patch makes the ieee80211_ioctl_siwessid to wait for authentication
> is completed.

This looks wrong. You could restart association when a key is set but
really the race is by design in WEXT so the only way to fix it is to set
the key first.

johannes

--=-kG53/l2qOUlWtt+Jbv7l
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR85tuaVg1VMiehFYAQL+qhAAigQPRd80BtC1sEZrzYTrkhMWg39CT8U8
RvkYzgeVC0fyiqyvHnFEbD3kR44lIPIVQuWIz16u820eAjUTBqenFQsvWc7VjWcC
C46mHtu82Go2Eqq8I7+NLMY3VZ1C7Z72Y1dG23mEtUjbX8axJwi1H3v+Sej4Insd
KB/7D4SFU03uPHT3jusS3S/zk2XQBwYa9NktdGHgMYMmEE/FDs6hZY8HhbSL1OKK
1JLsyjVXACuv0k+fnKFZ3p/3br+cXkGDpSB0BBtwHSWOPUxhGsKtGtTJzODqGzs+
HyfAekcdApenmv0+6nCr7Tz+t8oywSQnkaRvv++2Xq6mMyr56Xr9wLwCo+/unz1j
0vqpyDGCKeQ3HwHS+IPq5IHsAHmxn7zdQvDf3nfdtQ4H6BL2GE8ue7E2dUD0fJpB
i6I05Kq0ex783/iqrpA+iikpUpU37MT3/vtXczwmlncdongRWKRb5RA3JfC/g4Gr
vuvCpAqpfYY8K00/rqCm3Z0mybnQaUNMk4pH243Uc2JwdgWgMxrpiVQjZ5vIxWvl
ADsqTVyyLu8j4G4DtucRb5sS8v28pI9AafDMEWsXZyx7u8uDrAjRSUn0AiI+MjPG
BFlPzrFQzObT6qkXQ4n3EDD2KA1h+EbHdZyMb3uFCDo2KpKMGFGc3GKZkMgYex/B
lQQoPhXlz30=
=nGAr
-----END PGP SIGNATURE-----

--=-kG53/l2qOUlWtt+Jbv7l--

