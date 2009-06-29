Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51778 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbZF2MZ5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Jun 2009 08:25:57 -0400
Subject: Re: Repeater Bridge Mode with ar9170?
From: Johannes Berg <johannes@sipsolutions.net>
To: Jon Loeliger <jdl@bigfootnetworks.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1245881310.13356.10.camel@jdl-desktop>
References: <1245861185.13356.2.camel@jdl-desktop>
	 <1245881310.13356.10.camel@jdl-desktop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-+Io2+8qSMoRBABICvNZt"
Date: Mon, 29 Jun 2009 14:25:55 +0200
Message-Id: <1246278355.4585.3.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+Io2+8qSMoRBABICvNZt
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-06-24 at 17:08 -0500, Jon Loeliger wrote:

> OK, so, in the other (non-mac80211) drivers, there was a mode
> called IW_MODE_REPEATER that implemented 4-address framing for
> clients that provided the bridging ability.
>=20
> That same functionality is currently not implemented in the
> mac80211 code (ie, no NL80211_IFTYPE_REPEATER mode).

Actually, the IW_MODE_REPEATER was never quite clearly defined afaict
and we made it WDS instead.

> My perhaps mistaken understanding of what it would take to
> make this work would be to create a new NL80211_IFTYPE_REPEATER
> mode that was a hybrid between _STATION and _WDS modes.  In
> particular, it would act like _STATION as far as association
> and authentication are concerned, but would also have _WDS-like
> 4-address frame handling.
>=20
> Does that seem about right to you guys?  Are folks opposed to
> or willing to accept development down those lines?  Or has
> anyone already done such work and is willing to share?

That seems acceptable, though I don't necessarily see a need for adding
a new mode since you can very easily detect that you need to use 4addr
frames, and then it is up to the AP whether to accept them or not.

As far as the AP is concerned, it would probably be violating 802.1X to
accept such frames. Thus, it seems like some fairly obscure
functionality you would only want to enable with a Kconfig option even
on the client side?

johannes

--=-+Io2+8qSMoRBABICvNZt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKSLLMAAoJEODzc/N7+QmacSEQAME+t43wy3CjPeRfSteGDQte
U0rUAiPryMelsPlBVrFeqGyv7WESr64mwL4VDBBqR+9txb2S8fMraK/2xG8pAKWt
ZWFNRb0bOiGW42xrAjPPBpWpMvW/jd0ecx4uA3GPtoR4EbPlaFUwZ2Y8m6CtcNjN
/hjFAqTeaLwLjzUUz+tcCg+JrfqnVfBCZDU8w/krZ8T1nASK9rxzznvscFzedyLH
AQ6/k6kZBq3EJKtjp7Euxz8B9SnO96VsgIY28CXEFUYE9riknw4CNIeAOoZM+1lH
Mmo5Sw6InzqEMN89bEivwUBe3AKfnUrPqUN1L7u8xjUHS/snSiQJD7rL6rjVBr8P
90AyRkiAAJiRxHuIIzjBfhVtCUkXLYddFDfMSBf/0hg4vrHTJejpOyq0noVVW8Fc
ofhTwN1ut9Z/FduTK6P7RpOciYk7QAFGezM7kMf+ZzfAKmY/15nH2ziQAds40Pur
J5pYKYUJdbVQGNBv/M6sKBX3d3f+L5c3dUyoYpY6uMpL1VZDifn/840yfNfLhpGg
xGJ59VUFHHjHhnMd1rsVQXdPezuAg6sU7DhQJUvrZmyh+3FpqRiiGYBvk6jYnBZy
BNpN/BRsfiaIL1J3GRU1zM9v+WxfbVo/dtlhU7dMspg0NngRjNQZpTOlrCs3ZSBl
qz57rl2LNN0PH6r8nIpr
=I1PX
-----END PGP SIGNATURE-----

--=-+Io2+8qSMoRBABICvNZt--

