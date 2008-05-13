Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51206 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304AbYEMMaF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2008 08:30:05 -0400
Subject: Re: mac80211: Set IEEE80211_TXPD_REQ_TX_STATUS for all TX frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <200805131346.35897.IvDoorn@gmail.com> (sfid-20080513_133521_086212_042E3A5C)
References: <200805111434.19071.IvDoorn@gmail.com>
	 <1210668171.3646.41.camel@johannes.berg>
	 <200805131346.35897.IvDoorn@gmail.com>
	 (sfid-20080513_133521_086212_042E3A5C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VuQzEcvnpbHz11I0GDtF"
Date: Tue, 13 May 2008 14:29:51 +0200
Message-Id: <1210681791.3646.70.camel@johannes.berg> (sfid-20080513_143011_199514_8DD6A53D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-VuQzEcvnpbHz11I0GDtF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > What about monitor interfaces/injection? Do they already set it?
>=20
> No, should they?

Yes, I think so, since hostapd uses injection for frames and definitely
needs status callback. We could later define a radiotap bit for that, of
course.

> > Other than that, looks good to me, as long as you're aware that in the
> > future this might be more dynamic and don't rely on it too much for
> > internal housekeeping (but you seem to be according to your changelog
> > entry) :)
>=20
> Well it shouldn't matter if it will become more flexible, what I am looki=
ng
> for is making the flag actually mean something for drivers. ;)

Right :)

> We could even make it so that the mac80211 tx_status handler will ignore
> the frame when the flag is set so drivers won't have to look at it at all=
.

You mean "when the flag is unset"? Not sure, maybe we should, but we'll
see that when more uses for it come up/better rate control algorithms
are developed.

johannes

--=-VuQzEcvnpbHz11I0GDtF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASCmJvqVg1VMiehFYAQI1SRAAoivcnehDjnd3dJUAISzd8we/vDiTMAUO
j/2tvcGgmchAzmj9BOI002ce6tLUyS3JE2VpZaEQiu4O2TVuMkXK0ktb3a1/5dJE
8N/kVK7+txsU1/FIPRLMTpfOgB5jbDV/YN/BDDbuuakweFTwDoc/oBAVyfVIf7Tc
Ktg63ixqav5fCSQBUbW2xoIqpvBnCrk9XQQIAzpy9QgrqBRcMyh8BMx6fCIFhrqh
mM421mLa9ZKf7FAwMdpQOij9gVW8JcVVWvlMI+xt0yatQ1BncFPJ3UwUmGfPDOiT
+TE8Q9feI2s/e70loTF5xKgjZvFTI3t78VNNLdseLRTxzCjIptYV6UehrwC+YQN/
dwwqwVpHbip+E0l4L194M0kat8fbwd+eCxzGqqqwOiQtgChdtv1KYgpsV68SKyPv
1GvudD+XzURNan7MO5KMYDwsJ2DdaAJRDSXejfDiavPY/X6PQelwX7e2y97r8QP7
8wBp3CFPsB9TNUj13LnRrUhHkhxiAAX4FI0IVuJJOIAuZHScTexGCMTuwsmKoPHU
5TW8z3XNNCoYznfqpokRgNuKBo+FzRW0/tkGE9eKPgDrN01EkwwTxzsRlxuTEI/7
0w0TcDSk+HJyvd3YASVqGXUUOuWtfGVKIE95qeesYSF330i789bqezAnS3OX5qg3
nKQorB6LNwY=
=f9cS
-----END PGP SIGNATURE-----

--=-VuQzEcvnpbHz11I0GDtF--

