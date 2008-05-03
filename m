Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38362 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbYECXP4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 May 2008 19:15:56 -0400
Subject: Re: mac80211 truesize bugs
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: herbert@gondor.apana.org.au, mb@bu3sch.de, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <20080503.160705.78111001.davem@davemloft.net>
References: <20080503125940.GA26199@gondor.apana.org.au>
	 <1209830582.3673.8.camel@johannes.berg>
	 <1209855383.3649.3.camel@johannes.berg>
	 <20080503.160705.78111001.davem@davemloft.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-uXOp3gDz7F1eHgA2gWf/"
Date: Sun, 04 May 2008 01:15:39 +0200
Message-Id: <1209856539.3920.1.camel@johannes.berg> (sfid-20080504_011546_472885_101B6BAC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-uXOp3gDz7F1eHgA2gWf/
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-05-03 at 16:07 -0700, David Miller wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
> Date: Sun, 04 May 2008 00:56:23 +0200
>=20
> > This was a stupid mistake, if you do it correctly it actually works and
> > so far has only triggered a single warning on my system:
> >=20
> > [  217.507048] SKB BUG: Invalid truesize (4294964120) size=3D432, sizeo=
f(sk_buff)=3D176
> > =EF=BB=BF
> > that was with my patch though to update skb->truesize during !skb->sk
> > pskb_expand_head() calls.
>=20
> Thanks a lot for tracking this down Johannes.

No, no, I haven't. The only thing that was a stupid mistake was my
change to check the actual allocated skb size in the truesize bug rather
than do the < len check... That works, when you do it as in that patch,
but the mac80211 stuff still stands (along with all the questions I
posted elsewhere in this thread)

johannes

--=-uXOp3gDz7F1eHgA2gWf/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASBzyGqVg1VMiehFYAQLltRAAksORUg1lPvtZBYKAk37ay7Opwj2xraT4
IoLYUP6T+Sy7jIHhdnHs3M3yIqtqPhkKbmCV0MysV2h6tsLyKYK8t/1vwgKQT6PH
AR4A5dVZtwdgq0FB8lC53VaoU19IBVT+H+gjMXrKZnnQY+//ObtYzeNfU3SA4AuO
RlNhZW8LQxmzBYUPSE6lsBezQewVr/FJq3Y+WETH4ehJPaI8B/pEGK03bS2YAOld
pAM9qv65mJcF7yg0i49MjQDqTn9lxybtqzVT0wiMGjUkaSRLpJE0Ii20MypiKOTd
P4Bf4+1yoRi+5HMqjB88GRyg0jDFIeHDHt7HkA+NNYgCojV4VUTaJR6wDBd8hsnY
/SpqL+WjDjNRwaAmfODOZNcfxRmXYJlp650H99V/DRgcZWYRhlm3HgS+odyUane2
AE195YLweySs6ff44ehBW9P/fhILueaAe7pndnnTF+fb0RIVQ3Sn+PVs3pyFbUn8
QAAjMPSoqRDn9cQzsN0WKwG6fR85pDnCa6dIjHnqRedKMvnyAUOcd9I22uH213T0
gjbnmd0M/f3U/kMscxzyc3FgpfrkTBRRmxelcemDVO+5IatoVQVDBuOVmAbarQWY
uqR7N8A8/xdheMwVXT24r5GhwKWCS0D1DedQdhwJVYoVAUmebAcf6afuzFJLeGB1
7QUHcWqYBYs=
=8kcV
-----END PGP SIGNATURE-----

--=-uXOp3gDz7F1eHgA2gWf/--

