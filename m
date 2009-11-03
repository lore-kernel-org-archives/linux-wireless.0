Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53537 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbZKCIQp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2009 03:16:45 -0500
Subject: Re: [PATCH 1/2] Allow scanning while in authenticated only state
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Jouni Malinen <j@w1.fi>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1257203821.6717.24.camel@maxim-laptop>
References: <1256939391.31271.11.camel@maxim-laptop>
	 <1256939549.31271.14.camel@maxim-laptop>
	 <1256967782.3555.69.camel@johannes.local>
	 <1256982381.3089.10.camel@maxim-laptop>
	 <1256983366.3555.119.camel@johannes.local>
	 <1256985196.3089.34.camel@maxim-laptop>  <20091101201024.GA29524@jm.kir.nu>
	 <1257203821.6717.24.camel@maxim-laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-oBjgy5IqkL4286x7D9Xd"
Date: Tue, 03 Nov 2009 09:16:14 +0100
Message-ID: <1257236174.28469.35.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-oBjgy5IqkL4286x7D9Xd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-11-03 at 01:17 +0200, Maxim Levitsky wrote:

> > There should be no need for doing both disassoc and deauth; just send
> > deauth only if that is needed. This will save one extra frame
> > transmission and speeds up roaming a bit.
> >=20
> > Though, is this enough to handle the roaming cases where wpa_supplicant
> > may not try to send either disassociation or deauthentication?

> Currently wpa_supplicant sends only disassociation.
> deauthentication is send only in rare cases, usually due to [suspected]
> authentication error.
> Other that that I don't know, what I need is a clear statement about how
> things should work that is:
>=20
>=20
> * Should kernel allow authentication while in authenticated? I guess yes
> To same AP? To different APs?

It does allow it to different APs (up to 3/4 at a time), but not to the
same AP -- I plan on fixing the latter case.

> * What should kernel do if it done authentication to several APs?, but
> not association.
> should it timeout, or let wpa_suplicant do it?
> Currently it allows 4 (or 3) such APs, and then then bugs out with
> -ENOSPC

IMHO it should not make the decision on how long authentications are
valid. Any such value might be wrong if wpa_supplicant is really slow,
say it's swapped out.

> * Should kernel allow scanning while in authenticated but not associated
> case?=20
> I have send patch to do so, I hope it will be accepted.

I don't think it should, and as such don't think I want to accept the
patch. You need to make a much much better case for it if you want me to
accept it. I see no reason to ever be in a situation where there are
authentications (that aren't either killed off or used to associate) for
a long enough period of time for it to make sense to scan in that time.

johannes

--=-oBjgy5IqkL4286x7D9Xd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK7+bKAAoJEODzc/N7+Qma5ssP/iHxajFYx2jE+wGcerQKBa2h
T+A55nznB+xWI0EFVMQLVbOWvthEUE9Y843WD+8Xdbe1FulPVaZGULveDmqsdFL9
f+wTjd5vFsud064BFHn1YO80+KSarZCfVzkTk7Se0Ox1ndbuvjmyD6cX6Pxvst+4
/dSYazy2dwtYClFYj8By5qYYqvXVAm0kXN4Svw1Aq2EuNLXhq4RPZXtPEbcBv+05
bEkBLAbW28PbFiXWmF9i/1VL4NJeVdLYpTFRxGQu+2LAQ/Aic/kUAPHPl1Xk94HC
P9+bjTcpzj+QptCto2XjRO+8YQzJAX6S0lGu3arWQGOeQ8FbBRPC+t4cEq8Ovh57
F6x1/pk5L/80tIE6lNu6enhLGJUpKvaNLMQZWhXG64i7is3oEc1+jM940ZG4A7oi
aP2ygAcqrEBrXA8h340UjfYIm7/1pc1ITuZ5DFg4tceInYjRM3T+j0KPJcmLsXeL
pd+TB6Ea2PQeFuo88WOtaPHTvETJwQMtgB1X62YFWjoj7namTA6nUuFxEIfindvV
ttyxGbVF7KfrCUKmNyWrxlXcIZEvOOBiyezZ3yIgNdrHp40OH8btHn3bFSYYspnB
HOp3Dq4uJpjLkD6PXma6welAjjlHDTKINU7IIKR+VguMOrAvAH79eu3nX/fjgPvT
EsNdqnTJtSHIvlA5VoiK
=SWO1
-----END PGP SIGNATURE-----

--=-oBjgy5IqkL4286x7D9Xd--

