Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41599 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756111AbYLKWLD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 17:11:03 -0500
Subject: Re: [PATCH] ath5k : Fix correct padding
From: Johannes Berg <johannes@sipsolutions.net>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Benoit PAPILLAULT <benoit.papillault@free.fr>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
In-Reply-To: <1229033298.15776.18.camel@brick> (sfid-20081211_230823_881207_DB5831F0)
References: <49418D23.8060905@free.fr>  <1229033298.15776.18.camel@brick>
	 (sfid-20081211_230823_881207_DB5831F0)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Xbeu5tVqdW1heAlXaIbs"
Date: Thu, 11 Dec 2008 23:10:11 +0100
Message-Id: <1229033411.8081.91.camel@johannes.berg> (sfid-20081211_231115_036481_AD924F26)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Xbeu5tVqdW1heAlXaIbs
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-12-11 at 14:08 -0800, Harvey Harrison wrote:
> On Thu, 2008-12-11 at 22:58 +0100, Benoit PAPILLAULT wrote:
> > Padding the 802.11 header to a multiple of 4 bytes needs to be done onl=
y
> > for DATA frames. This fixes a bug where 2 bytes were missing in monitor
> > mode for ACK frames.
>=20
> Without commenting on whether or not this is needed
>=20
> >   		/*
> > @@ -2623,6 +2629,7 @@ ath5k_tx(struct ieee80211_hw *hw, struct sk_buff =
*skb)
> >   	unsigned long flags;
> >   	int hdrlen;
> >   	int pad;
> > +	const struct ieee80211_hdr * hdr =3D (const struct ieee80211_hdr *)sk=
b;
>=20
> skb->data perhaps.

For sure, there's a second place like that too.

johannes

--=-Xbeu5tVqdW1heAlXaIbs
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJQY+/AAoJEKVg1VMiehFYCLAQAJdjVhdW11M5zeZNJiW2HT9v
EQ4AaUrzQH1aolpjL06nKkzifXxeveoZn2sSRsOI/KLC626NB1RCIH1NDaerIG1N
UecO5fzJz9df2BaCmpQfuqTwTM3XhwfCyW5cuT3MJCRYLvLqs+qjXQIHR1hbSqJ/
wRBVz+o6EUnR2a1uN40FffG4s0u+0HNFlYlevKrgPmZ0MZu7rxSTb1Bg4m7GQMEH
zMtOumtQhDsu+pY98pU/nNSEG+klKXhJc/do4YhsLkJjb63p5/hEXgY5dBnRLnRG
e//fS3Xp846InwbLwoC7tQjppRlf3aztUHKfCD/RtYnzFmJOgxcqivwPlGCHE3Dg
QKyavR9G7lv3shzaJA9SDAFfqQ8Dgnd3vsBt8MUEU2PFpk3p9a9WKOIw/hh4Ajdd
xONutoGsdeu+eXmT7oMkrxfI6qEGzXBVBd8+EVaP56iYAZy2U6cTX5VbabckCmdI
GBM3p5qQkRERdxja+BUHKMvJUI0kNXF8BxPxDTGJlE/W49loGpinNmSBm/uDTwLC
IoSlX7R9eO7u/X3DCQF/2JzHq9AJWwyK9xhajIqVZ0RZzuiWQ7i/THSFdyRc7T3W
48XkvcRqJvpSI1mFhGKdqxX0w1t3Qh2X5frge4QvzPb25uozBiD8vMqQnAjB9Cps
PKqM1hbtIwuH5DcaFCxL
=bErf
-----END PGP SIGNATURE-----

--=-Xbeu5tVqdW1heAlXaIbs--

