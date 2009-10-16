Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58350 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758574AbZJPLjC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 07:39:02 -0400
Subject: Re: cfg80211 / libertas: an unusual race
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200910131055.31739.hs4233@mail.mn-solutions.de>
References: <200910131055.31739.hs4233@mail.mn-solutions.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-NFsjgung3wR1xz1M/Hb0"
Date: Fri, 16 Oct 2009 18:57:10 +0900
Message-Id: <1255687030.4095.327.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NFsjgung3wR1xz1M/Hb0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-10-13 at 10:55 +0200, Holger Schurig wrote:

> But at step "3. b)", which now happens at a later time,
> wdev_current_bss is no longer set. This triggers a
> WARN_ON(!done) warning in __cfg80211_send_deauth(),
> file net/wireless/mlme.c
>=20

> Would it be O.K. to simply remove the WARN_ON(!done) ?
> After all, wdev>current_bss was put'ted and cleared correctly.

I don't see this happening that way -- how are you even getting to
__cfg80211_disconnected() if not through _send_deauth()?

johannes


--=-NFsjgung3wR1xz1M/Hb0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK2ENyAAoJEODzc/N7+QmamW8P/iXFBTFncEB0fRDnkDp9r92c
HFZKKAklNavEW1cIw4W2NK9PSo3cPLqi+4/e0lrjuspdhTNS9Aolrovc09z8AV/1
e4wuYXQRdseOhAlsCMuR0egMwXa5sNYOdlWQXhRggwX3GF4ZMc83hD9LCGeI0UA2
4PbPpqFd91j7ShBGxLVVCdTmZJcuda2Q4XiomxiE1d/Ty2j14LSUxFCmG9QahnXk
P0S6ATiobEml73CoFc3u2XfKtVuXfrcAbkv3i4Chx5iUuoLSmeYCyHWQZ+j5Qe4j
YU05+F00Xu2IqELQfkjjqnYuaaU1PKBqouXE2KC3bvif8/4yDCJmv5GAh2cKOnXB
vj5v4r3rfRAsAt+OsS/vbYb6WMO0jy2DCDt5z0Q98dVg9yG/KTVb14bOfFuifUyF
Ws01WzdEfWD7wUn7TxAtIzN0lFFsl5JSP04jN3UeHzSEjB9vQ9h0FYXHtaf2XgS2
eeZtzpb5RFXXrahuJncQL7bGAjDCCuE7LVY+1BUFLVdNNyVwXir5Piqzi0nuwrz8
Rm6hnTlh+gWeiSjen7438sUVZoE0JT0HFuCIoLcB92pQbjI5i22HQqJ0WYMu7ISw
XhV51oNpLMQsPgOZXM+7lOOzhLD5wMYjasRJ0ZlpoK2FhNl0HXbB/UwTu4tC6FaR
UxPVca4uFh7Hzl0XOkhf
=P5lF
-----END PGP SIGNATURE-----

--=-NFsjgung3wR1xz1M/Hb0--

