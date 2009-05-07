Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50313 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630AbZEGOTm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 May 2009 10:19:42 -0400
Subject: Re: Warning when terminating wpa_supplicant (wext driver)
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless@vger.kernel.org,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
In-Reply-To: <1241704437.4903.15.camel@localhost.localdomain>
References: <1241677107.2918.4.camel@localhost.localdomain>
	 <1241696104.27208.2.camel@johannes.local>
	 <1241704437.4903.15.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-jyAFasi1fRzbswS7bB4X"
Date: Thu, 07 May 2009 16:19:39 +0200
Message-Id: <1241705979.27208.31.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jyAFasi1fRzbswS7bB4X
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-05-07 at 06:53 -0700, Marcel Holtmann wrote:

> > Copying Wey-Yi, but I think she's aware of this? It's definitely a
> > driver issue. I _suspect_, but am not sure, that the driver kills the
> > aggregation session when we disassoc or something and we only tell it
> > about the STA removal after that, when it already killed the STA. Thus
> > it would be a consequence of iwlwifi not implementing a proper
> > sta_notify() callback.
>=20
> I don't see it with nl80211 driver, but that might be pure luck.

Hmm, ok, that points to something else maybe... Now I wish I had my
ftrace-mac80211 patch ready. Well, the patch is almost ready but we
can't use ftrace in modules yet...

Maybe there's some timing issue. I still think it's iwlwifi getting
confused about what mac80211 is telling it as described, but it seems
it's a little more subtle than what I said.

johannes

--=-jyAFasi1fRzbswS7bB4X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKAu30AAoJEODzc/N7+QmaYJkQAMQdPR+ggoQAFKJskQrQnKjU
SydA8uLXNTkkJ+/SAKfZQrGmvz6r2dz2bN3SdM3sTjkGlWDC9YOkhik+5CqRhoSy
DpM9WOHuE8aSR361It0Gub2jEnfq5NoOFvJE3+trDHU43wpu7x32Vufg2BBgAO2b
sLpRXqeRpqKbotofTWt4cpekIvGeJxCRfpOzMNpvytOQtLIXDvZpwTIFcWkDgHoM
79C0lMpdB5G/Lch9s+eSGDVmQgayq1K73GzEFgjENBUPm6910wXFp2vafIRM6iIJ
Z7u2KmLaMj/5wrtIbbvWJ8CevrOE9zK3tO5VNct7vM1GTgvIQ2+Mq0ncPxVzquqL
Bj2Dh+pSnlIOzHHh74r5A1k/g8Wuz1IHOdK1DlFCjpxbv9Ytq3c5mRV8t6Wh4XHc
jAkzYI2sz0r8R9z0zDG6jljro2+tBKxfA2f4Sz5m+B5o3UAhz4kHTX4bxtgU7dC3
Pk89b2GHycKgmtchJ04sM1lqNlSIXGLMtqk8L5eJtTVSgdX5yfrkmeljmp8b1mJU
CC8IdBQtqhej1T4l2Ok8RZWV4EE8FpuL+FaZAeeLOOGfes+potw3S11RkHLp3oIW
ZTRYn0D+4v/7mchQcZ3J0InTw0j3UHrPuYkqSh3ENoAQFdCk/zyqRErxvh2MASPS
8BVH+hjWIgvXTA3RqQ8X
=RbgZ
-----END PGP SIGNATURE-----

--=-jyAFasi1fRzbswS7bB4X--

