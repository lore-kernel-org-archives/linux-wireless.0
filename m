Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36341 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932449AbZHVHu1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Aug 2009 03:50:27 -0400
Subject: Re: [PATCH] Implementation of the IEEE80211_RADIOTAP_RATE option
From: Johannes Berg <johannes@sipsolutions.net>
To: Rafael Laufer <rlaufer@cs.ucla.edu>
Cc: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4A8F01B8.40708@cs.ucla.edu>
References: <4A8DED03.2050502@cs.ucla.edu>
	 <1250842695.13872.5.camel@johannes.local>
	 <69e28c910908210630m47eda1eegcd502c212736decd@mail.gmail.com>
	 <4A8EE182.6040709@cs.ucla.edu>
	 <69e28c910908211152k4423d098i92b25078139ee827@mail.gmail.com>
	 <4A8EF031.4050604@cs.ucla.edu>
	 <69e28c910908211257p748e8be5w6078e7e98a205ef6@mail.gmail.com>
	 <4A8F01B8.40708@cs.ucla.edu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-UQ9GMj6mu/MmjGX8yuhB"
Date: Sat, 22 Aug 2009 09:50:25 +0200
Message-Id: <1250927425.23605.8.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UQ9GMj6mu/MmjGX8yuhB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-08-21 at 13:21 -0700, Rafael Laufer wrote:

> It is strange that a function called "get_rate" would also change other
> fields which are at first sight do not look related to rate. Why not
> call other functions for that? What is the reasoning behind this?
> Different rates have different retry counts or RTS/CTS usage?

I can't tell if you're kidding or not. This also doesn't get a single
rate, but the entire rate control setup.

> As far as I could tell from a quick look in the code,
> rate_control_get_rate only sets the fields of info->control.rates,
> except for this driver-specific function.

Right. And now look again what's in control.rates[].

> If this function really does other stuff, then a simple solution is to
> check if the IEEE80211_TX_CTL_RATE_RADIOTAP flag is set and, in that
> case, store the value of info->control.rates[0].idx before calling
> rate_control_get_rate, and restoring it afterwards. Make sense?

Ick, no.

johannes

--=-UQ9GMj6mu/MmjGX8yuhB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKj6M8AAoJEODzc/N7+QmapeYQAJfQ6B29+aRF+3owr9/8Qkrg
4b7eKvJsRLJ+zuKPfaWsG/khbAXSJVL+B9zdvIOhHpWYUzDMpcnhrDXB2kK+gZmF
WsN2FIcYOP6NWdMJNJbNy0lAlAol+HV7pzRYpYhrf4qWVwRKNYY2rtvggtbv1kfL
wGzkPmnODS5yf+Mj6+REqQ31eOk8ZFoh7uQrpZNQZ2dbEy5gCI+wedwyJbV55LSW
iOsuLbdISZ+pBVvC3OnE22dF3GYYbV0WwBI7Eh81JoIy1eTvpaXR+Y+R9VgmVHMA
0TC4PelFFWjHxcUIv+BAqDBjUGafZZhbuddtV/EumKtC1eBBXxBh5rfB2GtAvgRh
xF3SWG7aHdxNShEnkyFeuVKJmX9wHuWpz3WQjcdWESZpKFsat1gR+iuv+399DUHO
kSSAPNdZwbia8adoeRzi69bdmmiSwFiJxel2AGAeK3LAA3zfMSjRkL0klZqgfvpQ
QsK87up0o4VAeMlWGzCMEIcagXNPG4dXYIb+3I6P3goxDSJVU73wO5ORLpUzvf4B
gocwRO6a+d0EJo5NoOdFqvlNEgTq9TrvbF2iDdIKlV5NS0fJbSRzU9ky0ttlm95Y
+jLlK8NeJG+KzHeaaFNTll9Ky3yXuq2DA3pvVoluAPeZMouk2j6B/93uyb6QOTAd
qxjABEm70aVnWeLjyPrM
=DvtN
-----END PGP SIGNATURE-----

--=-UQ9GMj6mu/MmjGX8yuhB--

