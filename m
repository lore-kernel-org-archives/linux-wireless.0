Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34498 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515AbYEDS6P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 May 2008 14:58:15 -0400
Subject: Re: S/G operation, skb checksums, data copying
From: Johannes Berg <johannes@sipsolutions.net>
To: netdev <netdev@vger.kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1209925725.3655.15.camel@johannes.berg> (sfid-20080504_202821_526459_C1C8EB56)
References: <1209925725.3655.15.camel@johannes.berg>
	 (sfid-20080504_202821_526459_C1C8EB56)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-UKKlIBWuvwW8SBs5Equa"
Date: Sun, 04 May 2008 20:58:03 +0200
Message-Id: <1209927483.3655.23.camel@johannes.berg> (sfid-20080504_205740_737572_F3637A18)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UKKlIBWuvwW8SBs5Equa
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> However, mac80211 needs to change the skb header before the skb is
> handed to the hardware. Often enough, the skb it will get is cloned, so
> it has to copy the header. Hence, it would benefit from having the
> actual skb data not be in the header, but that is unavoidable currently
> since we have no checksum features.

I just realised that this wouldn't happen since the extra data is
actually in a struct page *, so never mind.

johannes

--=-UKKlIBWuvwW8SBs5Equa
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASB4HOqVg1VMiehFYAQKGoQ//SDoLYkJv6vAIOVoythT9++2WMuCwrYjd
SIT3NBjq89oWbbSFyG/0LlgzTYH1U365aoX2zSOY+GL4KrT3njI4LSYTSZWaPvyg
J2hrX5IuI1iwmX5OAPyoMNy78LE2TOy2N4XAFkkraIXik1bKEj4eoVkXsI8tgtaX
uQvistl487tKt2bMbeWpWLQHItflaUJs81ANaEo/NAC/qHurxbJZ8xzDhSsWYQgc
tuKfvzrQNqkGYJAHnGSata1OfubaYPdnr9jHUbtyvzVvWPtAxPdOEXPIrvDOx0Hi
UkJZswW3xe50Po/UALimkOY8lyG6rGB7ILIhEYcOa8hh8xMEt62eP9vxMjgiaJkt
MxP/VV3GK1XNWH9VamwRfcVAnwpAfeeKpoCCPSus5bQglTnibyD3KekTx/XuV+zQ
VXxfURv5lzQET/5t/uNjm0glc4CiJ1OFdGihD8OuN8Lt1k3YTW1YN2Xh5gb55HhA
ATxl2/7Du6xCYECdOduZYW3ssx2EdtonuBD29pNd7T6TY3nxayf3sA/lX+gusSc6
tYf1jeTxDHhNEMxSB4Vt4KIxdDJPv/nLwqZViOSzaQjgZ9w0vZcmLpt6llvKbwKw
OQs3VhsPgTGVktoz1DkinP9Tn7tVy7NorpSmEi1+aqKzJzm+rvj14O8MREZV87yr
uxbx1ayinp8=
=G7QG
-----END PGP SIGNATURE-----

--=-UKKlIBWuvwW8SBs5Equa--

