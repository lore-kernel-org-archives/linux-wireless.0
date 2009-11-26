Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53904 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbZKZTZi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2009 14:25:38 -0500
Subject: Re: [RFC] API for setting ACK timeout
From: Johannes Berg <johannes@sipsolutions.net>
To: 8an@praha12.net
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200911262015.03106.8an@praha12.net>
References: <200911261826.08576.8an@praha12.net>
	 <1259259493.24540.5.camel@johannes.local>
	 <200911262015.03106.8an@praha12.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-f6tZH3HboW0YUABsozAi"
Date: Thu, 26 Nov 2009 20:25:40 +0100
Message-ID: <1259263540.24540.9.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-f6tZH3HboW0YUABsozAi
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-11-26 at 20:14 +0100, Luk=C3=A1=C5=A1 Turek wrote:
> On 26.11.2009 19:18 Johannes Berg wrote:
> > I discussed this with Alina a while back (in private, she didn't want t=
o
> > discuss in English) and we came to the conclusion that set_coverage()
> > should be done like 802.11-2007 17.3.8.6 specifies for 5ghz, but could
> > be done for 2.4ghz as well. Thoughts? It would also allow us to actuall=
y
> > advertise that to compatible clients.

My standard reference was obviously crap -- let's see, 7.3.2.9 is
better.

> If I understand the standard correctly, it means the slottime should be
> (9 + propagation_delay), which equals (9 + distance / 300). And that's=20
> basically the same as the formula from Madwifi's athctrl I wanted to use:
> int slottime =3D 9 + (distance / 300) + ((distance % 300) ? 1 : 0);

That formula is a weird way of rounding up ...

> The main difference is that the coverage classes have an upper limit unde=
r=20
> 28km, but I don't see the point in artifically limiting maximum link dist=
ance=20
> (30km link could be done with big enough antennas).
>=20
> And I would prefer if the userspace API operated with distance rather tha=
n=20
> coverage classes, because it allows the user to set it correctly without=20
> reading a thousand page document. The coverage class could be then calcul=
ated=20
> for use in beacons as you proposed. Of course, in this case we would be=20
> constrained by the maximum coverage class in the standard.

No, you want the _user_ API to be operated with distance, not the
_userspace_ API. Conversion like that ought to be done in iw, not the
kernel.

johannes

--=-f6tZH3HboW0YUABsozAi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLDtYxAAoJEODzc/N7+QmanHQQAIVBJvdqZzMYmcMnHGOJFRBV
G8VvP4o5NTMvbY9j5+ovKJvCzAQAZK5pJS7JmJMtqSrWN524OLP8nXWvfYxFYlPh
nPjAMiVqqdcybj1v8E7N/RItq1VeU2zO6PNJP5DGsbvmTyQkqYecRxSRmKyeCstr
Mwwo8S/D6QwoYsSf8V3Erud9a1PwhiQgpXtjUIQvJGoiSaOY/IemjI2VLNAovdjf
sPaHfHjyYQg9HJXqB38RT2o/UOkaFYMqFgK4owfJdjIfTTSsCClwAFV5QwM8j4t/
d1PXEZa2H7MFahOg2vJpsbuD9JHOf4lJx+O9P/Myz3++Uf3yEwRvbPxeLYw1r4JD
SWS02ZX9Fam3dASZO5q5Xf6kxxH18/KFY7/FJQPNiIjLsqRN5xDiRnmuCQWoEyik
PYh48d9iHDxVmsxXSXSBzlpj8R73ZAu5tRcc+uQYHvks+n4YaTCxpUP8FmKdhnmE
C70ZCHx1H80CuChpjfSc+TfWhZoYUfLXWWIpPbO/NMBU4gcd0Q5mxOpgyfWk/dAk
WKChBct9OCytkEKNNDb3Y4KWxFrtTdmqyLZmBBK64YtlbEd755n5pqbPrtqHNzl6
rfpvH3JN6jPPQE+lwTP32vtBICqRMoEsfj3rbKZzmx2Ktw3tRTUYSlWK5mDOMO6s
X2Xwk9XPNFu9ToNrP1+O
=Ydv3
-----END PGP SIGNATURE-----

--=-f6tZH3HboW0YUABsozAi--

