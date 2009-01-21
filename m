Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41203 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759234AbZAUMod (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2009 07:44:33 -0500
Subject: Re: [PATCH] mac80211: Add documentation bits for
	mac80211_rate_control_flags
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <18806.42720.858590.913279@gargle.gargle.HOWL>
References: <18806.42720.858590.913279@gargle.gargle.HOWL>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-JE2RQESnaCVydXLeSI0p"
Date: Wed, 21 Jan 2009 13:44:13 +0100
Message-Id: <1232541853.4106.0.camel@johannes.local> (sfid-20090121_134436_118294_A4B01260)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-JE2RQESnaCVydXLeSI0p
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-01-21 at 10:08 +0530, Sujith wrote:
> Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
> ---
>  include/net/mac80211.h |   20 ++++++++++++++++++++
>  1 files changed, 20 insertions(+), 0 deletions(-)
>=20
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 9a5869e..742937f 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -262,6 +262,26 @@ enum mac80211_tx_control_flags {
>  	IEEE80211_TX_CTL_RATE_CTRL_PROBE	=3D BIT(12),
>  };
> =20
> +/**
> + * enum mac80211_rate_control_flags - per-rate flags set by the
> + *	Rate Control algorithm.
> + *
> + * These flags are set by the Rate control algorithm for each rate durin=
g tx,
> + * in the @flags member of struct ieee80211_tx_rate.
> + *
> + * @IEEE80211_TX_RC_USE_RTS_CTS: Use RTS/CTS exchange for this rate.
> + * @IEEE80211_TX_RC_USE_CTS_PROTECT: CTS-to-self protection is required.
> + *	This is set if the current BSS requires ERP protection.
> + * @IEEE80211_TX_RC_USE_SHORT_PREAMBLE: Use short preamble.
> + * @IEEE80211_TX_RC_MCS: HT rate.
> + * @IEEE80211_TX_RC_GREEN_FIELD: Indicates whether this rate can be used=
 in
> + *	Greenfield mode.
> + * @IEEE80211_TX_RC_40_MHZ_WIDTH: Indicates if the Channel Width can be =
40 MHz.
> + * @IEEE80211_TX_RC_DUP_DATA: the frame should be transmitted on both of=
 the
> + *	adjacent 20 MHz channels, if the current channel type is
> + *	NL80211_CHAN_HT40MINUS or NL80211_CHAN_HT40PLUS.
> + * @IEEE80211_TX_RC_SHORT_GI: Short Guard interval can be used for this =
rate.
> + */

Are you sure all this should say "can" rather than "should"? I'm
thinking that the driver should just follow whatever the rc algorithm
said here?

johannes

--=-JE2RQESnaCVydXLeSI0p
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJdxiaAAoJEKVg1VMiehFYdaQP/0wZcfzuReZEmGbQFaSZNu9o
9I4CJfiTuucTPx4oIics5dV6tQL91a1fFIDJpxAx5tQqhfzitXiJ34yHB/LWNRo3
IUxC/95fbYlscPoS0AfZj1k+NY/hI3uy3J4YPhIgZyz7mJSv8TZ8F9gc6QJmwcfC
9sF1z+ytkCP2zuXCWD3TT9NJNUy09W63qSDGe1c8UNeeqvjV31ZkeYkAUwtFqkpN
QT4nMjWuLKiNJqEtOPYpMQpe9z0LaPIGdVyi7+/QkYsjctcCj5jwtbSV0AtaOcDz
z3lplaTT+ZT8TCEr0cFd1ZwAgvLRT8wRZbfDyDxK9P79NAuq0Z9DG9d85WdOZLho
8US+MKd16o7deveZj6L2sP85xsDV8jB3sz4Bj5Ftrqt9gt8X3RZPeeDGkKBezr5j
EmcNGrwYVtyywoxbrntauQlWymc6CYNCRcEmiV566IcVT8/nr92TEWg9UZjFJ3Ax
nDMZK8XDAoOU3BJEsjORFqkt78JFprhIbmSsScZdxuEeVrszOZmoAYpHAMHuLToC
GMi5fhejcdXNvlZwovJW2JoJWxhTadprv8Seq+83PxxSXmeAl4XO2q7WstimA0uF
4cGk9yZjLJagEXaRVynnqLqTblJVBhmK/GAbOzxXIlsHruFZzk8bn58mJtGG3gmQ
/XaadNBC8NyZwjNkqH8K
=TH98
-----END PGP SIGNATURE-----

--=-JE2RQESnaCVydXLeSI0p--

