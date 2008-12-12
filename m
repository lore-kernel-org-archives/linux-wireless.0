Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55670 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365AbYLLWpw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2008 17:45:52 -0500
Subject: Re: [RFC 2/3] mac80211: Make use of the new F_TX_NOACK and
	F_TX_NOSEQ Radiotap TX flags
From: Johannes Berg <johannes@sipsolutions.net>
To: Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <69e28c910812121443h1fae52e6uc88749d7e9baf529@mail.gmail.com> (sfid-20081212_234356_997724_240E2F15)
References: <69e28c910812121432n6e84de41s94a887110051a1dd@mail.gmail.com>
	 <1229121558.3565.6.camel@johannes.berg>
	 <69e28c910812121443h1fae52e6uc88749d7e9baf529@mail.gmail.com>
	 (sfid-20081212_234356_997724_240E2F15)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-wksEJvVkXo1g4DxQRalA"
Date: Fri, 12 Dec 2008 23:45:47 +0100
Message-Id: <1229121947.3565.13.camel@johannes.berg> (sfid-20081212_234554_759297_6C34362E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-wksEJvVkXo1g4DxQRalA
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-12-12 at 23:43 +0100, Stefanik G=C3=A1bor wrote:

> I tried, but for some reason setting IEEE80211_TX_CTL_NO_ACK directly
> in __ieee80211_parse_tx_radiotap resulted in an oops upon unloading
> the driver module.

Huh? That doesn't make sense. Do you have more information on that?

> Note that IEEE80211_TX_MON_NO_ACK is not equivalent to
> !(IEEE80211_TX_CTL_ASSIGN_SEQ), as it also disables mac80211's built
> in sequence numbering.

Ah. But there's precedence for just doing

if (unlikely(!(info->flags & ASSIGN_SEQ)))
	return;

in the handler that assigns the seq, and I prefer that over adding a new
flag.

johannes

--=-wksEJvVkXo1g4DxQRalA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJQumYAAoJEKVg1VMiehFYO0kQAKYUaYr1MrFHW9y0LGcKKR13
kdKtefcpIUfNmkk6cbWaoUO0yLHrMR7aPvufUTt3zNgPrM6lK8zZjyNMVAPAjxAH
vV6YH0suf4kW5M9ddFqHqX4pjhB2JVIDpMuI4pXJQudxpvR0ilrgPGq3k5KK482S
0Rt1RDx2+LXOtxxjgJLgl1ykR3Q3WQ682c68wto0pFzXwqoFZtHoEJ59tpXrQqi4
/82fPrPwEyZ/mTGapI9ybWydslqFP4Wl8U5aFHyWAMXxysg9F8MZeoUU1hOZ7hAr
MpvOgkP1ppK0gP1yLZkuoynISN3FNU61AJ853Fe3rhH6HXJK1QvWhnzUe1w2H9AY
InR80azg1Ae2AUDjYiKeNTOz7Wmqpkj/ZNATVyvFEu+XOYp0oV1w1YJbpPxs1cfz
fglmAqWkvAZmmJ3uxZTCgMMGA0X8Nu2oz+ocIJOvzCL0uAlobYi7h37O9Z0jRITF
A0agdZoKJeumKHd5lLquzqZNOLI6ysG3ANj33IozoiwO8hxBAVCeWgtYkTiBaw+2
8GvZH/DA/OP7RHebpO3mDK7zZ5UnL8X+eUN9logQ+r2YmWFuh4H8LlnvePsJXS/7
pzHFq98pJPAI+Y4J0Wrjlq/8Q2liw6qjxElcCKYySdlYHFS2RuEds8k4MQeM7vKH
Bf4QUh2p2nkqLmoQomsS
=EOKj
-----END PGP SIGNATURE-----

--=-wksEJvVkXo1g4DxQRalA--

