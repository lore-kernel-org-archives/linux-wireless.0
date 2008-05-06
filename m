Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51968 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156AbYEFACD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2008 20:02:03 -0400
Subject: Re: [RFC v2] mac80211: assign needed_headroom/tailroom for netdevs
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: tomasw@gmail.com, linville@tuxdriver.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, herbert@gondor.apana.org.au
In-Reply-To: <20080505.163916.239187195.davem@davemloft.net>
References: <1210027447.8012.15.camel@johannes.berg>
	 <20080505.161458.46071527.davem@davemloft.net>
	 <1210029835.8012.30.camel@johannes.berg>
	 <20080505.163916.239187195.davem@davemloft.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-BvfQ5byRedqdwcCaM0lX"
Date: Tue, 06 May 2008 02:01:16 +0200
Message-Id: <1210032076.8012.49.camel@johannes.berg> (sfid-20080506_020122_918900_864E4FF1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BvfQ5byRedqdwcCaM0lX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > Which buffer? skb->data..skb->tail? And isn't that, in mac80211's case,
> > at least currently all the buffer anyway?
>=20
> Right.
>=20
> For TSO or cases using frag lists of frag page vectors, it gets
> more complicated.

Yeah, but at least right now we don't accept any of those. That might
change, but even then we'll only care about the headroom (and maybe for
TKIP the crypto MIC that's at the end, assuming the hardware does the
encryption which it usually does), but we can stick that elsewhere and
just DMA it on.

> Basically, skb_header_cloned()=3D=3Dfalse means that you can modify
> anything covered by skb->data..skb->tail

Ok.

> > Interesting point. I'll have to see when socket filters are run,
> > wpa_supplicant could have a tap open I think. Maybe that's why I'm
> > seeing so many cloned packets. I think I'll stacktrace skb_clone and
> > print that out.
>=20
> Note that we can even optimize that case even further if we really
> have to.
>=20
> But try to see why the filter used by WPA Supplicant is not effective.
> If the filter fails to match, the packet is free'd immediately using
> kfree_skb() which should undo clone'age.

Right. I just checked, and realised I remembered wrongly, wpa_supplicant
actually binds the socket to the ethertype it wants so
dev_queue_xmit_nit() shouldn't be called. I'll have to check why I got
so many cloned packets, best see if it still happens with the
header_cloned() change.

johannes

--=-BvfQ5byRedqdwcCaM0lX
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASB+fy6Vg1VMiehFYAQIGixAAlHbcLZR592ppU7gJuw23z5UYc+c9fOff
UnYXOXxJatKZYAN3KwkNZ56knFqRnVUTA4xn7G2BYaftabMsAmJ9MovugCohWVcr
RSUYntBXmoc51bzHW0WlsdHufDXJZzCNl43mBrpmNBbBZiDhSfFxg1WoDtDxuyJO
0YWVg5he/E/p097czCn/Q782Qm6qCbtygVdFfOXjs9wsKvT36xqUXQ1Al23VN+9M
gY9h1OEKI32IpazuY8Kv7K2UT5Oi2i282NRgRdctyHjnDIOK1fa1CFwW9EzQ9ZsV
rnCEzRnMCZ2bvkrWY3fjlQ/pocj1vJjAbJyni6uRsXLugDEleIz4NrdR9QqpHOJM
fA5nLSIIlBmPySsqmkYxhbKEdaY5lUQNTZ2gYxbf39I2OAXvyTx9zS0ol5rpThCH
THUemukddTQJMLQxWKTrxKQj8FySvLxWvxYTNfss9hMWuL1fN8PK7RpBRTWrM0Eo
Y2ebQjxFCn+pTxReuKJ9epGty/Z5um0FlAKy1pHqb6zsLvsx5fPL7RcEIUTJo7VA
53OiosJniF+9ZXakQ9Zv6Vvo+2Zl4GmOUhkEXfEcZ1biAXrxK753F6pRd1Q8AH5n
nEqQzkXkfCcPqDo9Zdugu20bMnX1W5UB9euYAwXwXzsYCY+JuFUhnAH1c5MAK5W0
GX+Us1ytMbI=
=N2Br
-----END PGP SIGNATURE-----

--=-BvfQ5byRedqdwcCaM0lX--

