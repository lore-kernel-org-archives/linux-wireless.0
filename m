Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43571 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867AbZF2Ifs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Jun 2009 04:35:48 -0400
Subject: Re: [RFC 00/11] cfg80211 connect API + wireless extension move
From: Johannes Berg <johannes@sipsolutions.net>
To: Dave <kilroyd@googlemail.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4A473730.3000409@gmail.com>
References: <20090624120745.239294066@sipsolutions.net>
	 <43e72e890906241324n341f4988wc6e7325ee389e71e@mail.gmail.com>
	 <4A43E002.2060309@gmail.com> <1246047520.21314.67.camel@johannes.local>
	 <4A473730.3000409@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-2ak1OS88rXZrt71HcrPN"
Date: Mon, 29 Jun 2009 10:35:47 +0200
Message-Id: <1246264547.7775.8.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-2ak1OS88rXZrt71HcrPN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-06-28 at 10:26 +0100, Dave wrote:
> Johannes Berg wrote:
> > Yes. Mind you, I was not only talking about iwpriv, but also about
> > things like orinoco's spy support or get/set sensitivity. The latter we
> > don't quite understand -- can you tell us what it actually does? Spy
> > support should just be removed, I think.
>=20
> I've had a closer look at this.

Thanks!

> The sensitivity basically controls the roaming threshold when handled by
> firmware. It is a firmware setting, though the Agere driver also
> validates the multicast rates based on it. The drivers/firmware use
> terms like system scale, AP density, distance between APs.
>=20
> There are 3 valid values:
>=20
> 3 - high density of APs. Maintain 11Mbps by roaming.
> 2 - medium density of APs. Maintain 2Mbps.
> 1 - low density. Maintain 1Mbps.
>=20
> Although the values are defined in terms of the usable bitrate, the
> (Intersil) documentation states that the implementation is based on SNR.

That's actually what people suspected when I asked around at the summit,
and it seemed the general consensus is that we need a proper setting for
that in nl80211 along with some of the roaming capability exports.

So until that happens, the last patch won't get in anyway, and we'll see
about the NEED_... stuff later.

johannes

--=-2ak1OS88rXZrt71HcrPN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKSHzgAAoJEODzc/N7+Qmat9QQAMgB5wq0s4gxS7C2auWp8fSy
QJizex7jDgH1DeFOBTH7E+9ungwGvIKE57AFM//oqzyjcPm+mO37bL3kcce4Ll6V
QNFr1yIEB8+LtxZKfBNO29X2IQWCn9OFVfw3ASw3h1+lnRIZv8IiJKwyjADtoIL8
jhAUovT/5m/MuQXoUSNhOmZfLHvV/wrCvBBOkmZBaqrW3CJn4rCDO9AuvXwNZnCW
wE52qHjidyka5eP/V4ykIXgYQ8lecRrWlY2vXJfwew/DFOuWr4jMSsEmlzu740bd
RVdvdVFdoWFmokEQBT6pYev+WVLYHcvSfID5ROlEcgnqYKHJihAf2M2zucjt/ZdH
HQh9F3X402A4CxkiD9EpOW+I2l28EzELNpRBlW49GgGOuozazlwwmW3s0hPDIogz
JBmG5jOa9FrYYVnDrEEjoaqA448O/O8q3tiDWbrOTuXHQF9/+1NSKjyQHHJUg804
f6hmBy9hhDbxOW+bBI9V01cP7UIIIKGCt61gQIL2WDPzZ3XqbS9fG+vPdUAEd/vt
dbzGyHGNbVCt5yTa1nRNn8Y0ZnGIy7BO4D7UdWsXrgbdM6W3Cb10eczXfyK05/kH
cr9XxRMjlTbXISvgBBoowcvGdEq9pKjQQIeIVFLMfas7QUEhudD9CyxeZWC6bhXx
GVj5iny9+N+cvN/kHMz9
=RXFu
-----END PGP SIGNATURE-----

--=-2ak1OS88rXZrt71HcrPN--

